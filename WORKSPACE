workspace(name = "nix")

load("//bazel:repositories.bzl", "envoy_dependencies")
load("//bazel:cc_configure.bzl", "cc_configure")

new_local_repository(
    name = "nix_envoy_deps",
    path = "/nix/store/y79a1cfqz0vbfz60w2gb2qr9k96kdqcy-repo-env",
    build_file = "nix_envoy_deps.BUILD"
)

envoy_dependencies(
    path = "@nix_envoy_deps//",
    skip_protobuf_bzl = True,
)

new_local_repository(
    name = "protobuf_bzl",
    path = "/home/cstrahan/src/envoy/thirdparty/protobuf",
    # We only want protobuf.bzl, so don't support building out of this repo.
    #build_file_content = "",
    build_file = "/home/cstrahan/src/envoy/thirdparty/protobuf/BUILD",
)

cc_configure()

load("@envoy_api//bazel:repositories.bzl", "api_dependencies")
api_dependencies()

