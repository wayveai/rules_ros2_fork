# Copyright 2022 Milan Vukov
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
import argparse
import asyncio
import logging
import os
import pathlib
import sys
import tempfile
import urllib

import aiofile
import aiohttp
import tqdm.asyncio
import yaml


def is_github_url(url):
    url_info = urllib.parse.urlparse(url)
    return url_info.netloc == 'github.com'


def is_gitlab_url(url):
    url_info = urllib.parse.urlparse(url)
    return url_info.netloc == 'gitlab.com'


def get_gitlab_project_name(url):
    url_info = urllib.parse.urlparse(url)
    return url_info.path.split('/')[-1]


def create_archive_name(name, url):
    url_info = urllib.parse.urlparse(url)
    archive_name = url_info.path.split('/')[-1]
    if archive_name.startswith(name):
        return archive_name
    return f'{name}-{archive_name}'


async def compute_sha_sum(file):
    sha256sum_process = await asyncio.create_subprocess_shell(
        f'sha256sum {file}',
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE)
    await sha256sum_process.wait()
    if sha256sum_process.returncode:
        logging.error(f'Failed to calculate SHA256 sum for {file}!')
        return None
    stdout = await sha256sum_process.stdout.read()
    return stdout.decode('utf-8').split(' ')[0]


async def download_urls_and_compute_sha_sums(names_to_urls, outputs_dir):
    semaphore = asyncio.BoundedSemaphore(5)

    async def download_url_and_compute_sha_sum(name, url, session):
        async with semaphore:
            async with session.get(url) as response:
                if response.status != 200:
                    logging.error(f'Failed to fetch {url}: {response.reason}')
                    return name, None
                data = await response.read()

            output_file = outputs_dir / create_archive_name(name, url)
            async with aiofile.async_open(output_file, 'wb') as stream:
                await stream.write(data)

            return name, await compute_sha_sum(output_file)

    async with aiohttp.ClientSession() as session:
        tasks = [
            asyncio.create_task(
                download_url_and_compute_sha_sum(name, url, session))
            for name, url in names_to_urls.items()
        ]
        names_and_data = [
            await f for f in tqdm.asyncio.tqdm.as_completed(
                tasks, desc='Downloading archives and calculating SHA sums')
        ]
        return dict(names_and_data)


HTTP_ARCHIVE_TEMPLATE = """\
    maybe(
        http_archive,
{args}
    )
"""

BZL_TEMPLATE = """\
# This file is automatically generated.
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def ros2_repositories_impl():
{http_archives}
"""


def dump_http_archives(repos):
    http_archives = []
    for repo in repos:
        http_archive_args = []
        for key, value in repo.items():
            if isinstance(value, str):
                http_archive_args.append(' ' * 8 + f'{key} = "{value}",')
            elif isinstance(value, list):
                value_str = ', '.join([f'"{v}"' for v in value])
                http_archive_args.append(' ' * 8 + f'{key} = [{value_str}],')
            else:
                sys.exit(f'Cannot handle {value} for {key}!')
        http_archives.append(
            HTTP_ARCHIVE_TEMPLATE.format(args='\n'.join(http_archive_args)))
    return BZL_TEMPLATE.format(
        http_archives='\n'.join(http_archives)).rstrip() + '\n'


def main():
    if 'BUILD_WORKSPACE_DIRECTORY' not in os.environ:
        sys.exit("""
Please run this app as a Bazel target
bazel run //repositories/private:resolver
        """)

    parser = argparse.ArgumentParser()
    parser.add_argument('--repos', type=str)
    parser.add_argument('--repo_mappings', type=str)
    parser.add_argument('--output', type=str)
    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO)

    with open(args.repos, 'r', encoding='utf-8') as stream:
        repos = yaml.load(stream, Loader=yaml.Loader)['repositories']
    with open(args.repo_mappings, 'r', encoding='utf-8') as stream:
        repo_mappings = yaml.load(stream, Loader=yaml.Loader)['repositories']

    all_repos_ok = all([info['type'] == 'git' for info in repos.values()])
    if not all_repos_ok:
        sys.exit('Type of all repositories must be `git`!')

    requested_repos = repo_mappings.keys()
    names_to_urls = {}
    names_to_versions = {}
    suffix_len = len('.git')
    for name, info in repos.items():
        url = info['url'][:-suffix_len]
        version = info['version']
        if is_github_url(url):
            archive_url = f'{url}/archive/refs/tags/{version}.tar.gz'
        elif is_gitlab_url(url):
            archive_url = (f'{url}/-/archive/{version}/'
                           f'{get_gitlab_project_name(url)}-{version}.tar.gz')
        else:
            sys.exit(f'{name}: URL must be github/gitlab hosted, got `{url}`!')

        project_name = name.split('/')[-1]
        if project_name not in requested_repos:
            continue
        names_to_urls[project_name] = archive_url
        names_to_versions[project_name] = version

    with tempfile.TemporaryDirectory() as tmp_dir_name:
        names_to_sha_sums = asyncio.run(
            download_urls_and_compute_sha_sums(names_to_urls,
                                               pathlib.Path(tmp_dir_name)))

    for name, sha_sum in names_to_sha_sums.items():
        repo_mappings[name]['sha256'] = sha_sum
    for name, version in names_to_versions.items():
        repo_mappings[name]['strip_prefix'] = f'{name}-{version}'
    for name, url in names_to_urls.items():
        repo_mappings[name]['url'] = url

    with open(args.output, 'w', encoding='utf-8') as stream:
        stream.write(dump_http_archives(repo_mappings.values()))


if __name__ == '__main__':
    main()
