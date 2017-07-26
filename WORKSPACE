workspace(name = "nix")

load("//bazel:repositories.bzl", "envoy_dependencies")
load("//bazel:cc_configure.bzl", "cc_configure")

new_local_repository(
    name = "nix_envoy_deps",
    path = "/nix/store/mrsid8jk8dycc4wh5fdckl0hgql4ydx0-repo-env",
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
    build_file_content = "",
)

cc_configure()

