load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def ros2_repositories():
    maybe(
        http_archive,
        name = "ros2_ament_cmake_ros",
        build_file = "@com_github_mvukov_rules_ros2//repositories:ament_cmake_ros.BUILD.bazel",
        sha256sum = "6d7d8e4612e155953327d40a7c4d6c6c57ab02f6accfc21969bae679618a5560",
        strip_prefix = "ament_cmake_ros-0.9.2",
        url = "https://github.com/ros2/ament_cmake_ros/archive/refs/tags/0.9.2.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_common_interfaces",
        build_file = "@com_github_mvukov_rules_ros2//repositories:common_interfaces.BUILD.bazel",
        sha256sum = "8cfe9b00f0dc75e6e5e2fae8de0b2c84564ce43b94c68b227e317d4dcfe77073",
        strip_prefix = "common_interfaces-2.0.5",
        url = "https://github.com/ros2/common_interfaces/archive/refs/tags/2.0.5.tar.gz",
    )

    maybe(
        http_archive,
        name = "cyclonedds",
        build_file = "@com_github_mvukov_rules_ros2//repositories:cyclonedds.BUILD.bazel",
        sha256sum = "ff3a8545c78c0019014bbb906da2f44184e919a4f9985995014a0b08238d86e5",
        strip_prefix = "cyclonedds-0.7.0",
        url = "https://github.com/eclipse-cyclonedds/cyclonedds/archive/refs/tags/0.7.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_launch_ros",
        build_file = "@com_github_mvukov_rules_ros2//repositories:launch_ros.BUILD.bazel",
        sha256sum = "afd6f1b31a6bc985682cf2753ea96056e1132eeb0ac5d0f063ab60515f79a2ce",
        strip_prefix = "launch_ros-0.11.7",
        url = "https://github.com/ros2/launch_ros/archive/refs/tags/0.11.7.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_libstatistics_collector",
        build_file = "@com_github_mvukov_rules_ros2//repositories:libstatistics_collector.BUILD.bazel",
        sha256sum = "03dcc2153364d540ec2ad18380015cef6da9a9ba2a664360a326093142743444",
        strip_prefix = "libstatistics_collector-1.0.1",
        url = "https://github.com/ros-tooling/libstatistics_collector/archive/refs/tags/1.0.1.tar.gz",
    )

    maybe(
        http_archive,
        name = "osrf_pycommon",
        build_file = "@com_github_mvukov_rules_ros2//repositories:osrf_pycommon.BUILD.bazel",
        sha256sum = "79ecd4c267e2eb0effd376528226581d66cbdb81daa1d8b78c81bb0007b21c69",
        strip_prefix = "osrf_pycommon-0.1.11",
        url = "https://github.com/osrf/osrf_pycommon/archive/refs/tags/0.1.11.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_rcl",
        build_file = "@com_github_mvukov_rules_ros2//repositories:rcl.BUILD.bazel",
        sha256sum = "e0b6f1607104093fc3eced0ccaf9c4c0a91c8a05560596273a767dccc6ccf2f3",
        strip_prefix = "rcl-1.1.14",
        url = "https://github.com/ros2/rcl/archive/refs/tags/1.1.14.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_rcl_interfaces",
        build_file = "@com_github_mvukov_rules_ros2//repositories:rcl_interfaces.BUILD.bazel",
        sha256sum = "bb603420186394cc4e7a5f6da44d62d530f01e3246a8f78e952d21bf2d41a45b",
        strip_prefix = "rcl_interfaces-1.0.0",
        url = "https://github.com/ros2/rcl_interfaces/archive/refs/tags/1.0.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_rcl_logging",
        build_file = "@com_github_mvukov_rules_ros2//repositories:rcl_logging.BUILD.bazel",
        sha256sum = "c7a4a8f22b77269fe99ad43c1e075bf2a3f42513bfb2531fd9e5fe9f146e6e63",
        strip_prefix = "rcl_logging-1.1.0",
        url = "https://github.com/ros2/rcl_logging/archive/refs/tags/1.1.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_rclcpp",
        build_file = "@com_github_mvukov_rules_ros2//repositories:rclcpp.BUILD.bazel",
        sha256sum = "a8b572ca741f26079b823ebdbf028e280bc02dfcfe49d870a81020ca00114d3f",
        strip_prefix = "rclcpp-2.4.2",
        url = "https://github.com/ros2/rclcpp/archive/refs/tags/2.4.2.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_rcutils",
        build_file = "@com_github_mvukov_rules_ros2//repositories:rcutils.BUILD.bazel",
        sha256sum = "798f716adeee873223bcfc949943a162699fa02f142c73078a8384b1b732fca1",
        strip_prefix = "rcutils-1.1.4",
        url = "https://github.com/ros2/rcutils/archive/refs/tags/1.1.4.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_rmw",
        build_file = "@com_github_mvukov_rules_ros2//repositories:rmw.BUILD.bazel",
        sha256sum = "5e437ff6f6ff3e8b4b4bb4afc013efa7d4a5b28ace8686e94889d1f6a703fa53",
        strip_prefix = "rmw-1.0.3",
        url = "https://github.com/ros2/rmw/archive/refs/tags/1.0.3.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_rmw_dds_common",
        build_file = "@com_github_mvukov_rules_ros2//repositories:rmw_dds_common.BUILD.bazel",
        sha256sum = "34e46de0e2858af57d996b5d17fbfd76b58b1c37b64321d2c6bafaf4198d64db",
        strip_prefix = "rmw_dds_common-1.0.3",
        url = "https://github.com/ros2/rmw_dds_common/archive/refs/tags/1.0.3.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_tracing",
        build_file = "@com_github_mvukov_rules_ros2//repositories:ros2_tracing.BUILD.bazel",
        sha256sum = "552f35e1dbdc30cdd5ddeeccf278f8fc50811f15f3d2eb98e25a28fadac0ae8f",
        strip_prefix = "ros2_tracing-1.0.5",
        url = "https://github.com/ros2/ros2_tracing/archive/refs/tags/1.0.5.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_ros_testing",
        build_file = "@com_github_mvukov_rules_ros2//repositories:ros_testing.BUILD.bazel",
        sha256sum = "1def68962286e95dcbce54445f5589429d7d6fb44b580183356c3281b3670798",
        strip_prefix = "ros_testing-0.2.1",
        url = "https://github.com/ros2/ros_testing/archive/refs/tags/0.2.1.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_rosidl_runtime_py",
        build_file = "@com_github_mvukov_rules_ros2//repositories:rosidl_runtime_py.BUILD.bazel",
        sha256sum = "b171a9358ed30df2f702f64c4618872c22802287dbf7b6d27310bd6c8a550dcf",
        strip_prefix = "rosidl_runtime_py-0.9.1",
        url = "https://github.com/ros2/rosidl_runtime_py/archive/refs/tags/0.9.1.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_rpyutils",
        build_file = "@com_github_mvukov_rules_ros2//repositories:rpyutils.BUILD.bazel",
        sha256sum = "8b321fd04ffc65b7be2e8d6e4dde6e632bac291021dc5adc67077c9cac601243",
        strip_prefix = "rpyutils-0.2.0",
        url = "https://github.com/ros2/rpyutils/archive/refs/tags/0.2.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "ros2_unique_identifier_msgs",
        build_file = "@com_github_mvukov_rules_ros2//repositories:unique_identifier_msgs.BUILD.bazel",
        sha256sum = "aa0f5a440cface1dd85cf05d97cadb812b2796973882d02a7e795ae70b64b9a0",
        strip_prefix = "unique_identifier_msgs-2.1.3",
        url = "https://github.com/ros2/unique_identifier_msgs/archive/refs/tags/2.1.3.tar.gz",
    )
