/*
This file is here to support development under Nix.

This provides a means of setting up a repo base on Nix pkgs, instead of the
prebuilt binaries approach used by upstream.


*/

with import ~/src/nixpkgs { };

let
  allDeps = [
    c-ares
    backward-cpp
    libevent
    gtest
    gperftools
    http-parser
    lightstep-tracer-cpp
    nghttp2
    protobuf3_2
    tclap
    rapidjson
    spdlog
    boringssl
  ];

  # the repo we'll use for our new_local_repository in our generated WORKSPACE.
  repoEnv = buildEnv {
    name = "repo-env";
    paths = lib.concatMap (p:
      lib.unique [(lib.getBin p) (lib.getLib p) (lib.getDev p)]
    ) allDeps;
  };

  # from ci/prebuilt/BUILD
  # at the moment, this doesn't _need_ to be a map that we dynamically create a
  # BUILD file from (we could instead just include the contents directly);
  # however, this sets us up to be ready if we (or upstream) decide to split
  # things into multiple bazel repos, instead of one big one.
  ccTargets = {
    ares = {
      pkg = c-ares;
      srcs = ''["lib/libcares.so"]'';
      hdrs = ''glob(["include/ares*.h"])'';
      includes = ''["include"]'';
    };

    backward = {
      pkg = backward-cpp;
      hdrs = ''["include/backward.hpp"]'';
      includes = ''["include"]'';
    };

    crypto = {
      pkg = boringssl;
      srcs = ''["lib/libcrypto.a"]'';
      hdrs = ''glob(["include/openssl/**/*.h"])'';
      includes = ''["include"]'';
    };

    event = {
      pkg = libevent;
      srcs = ''["lib/libevent.so"]'';
      hdrs = ''glob(["include/event2/**/*.h"])'';
      includes = ''["include"]'';
    };

    event_pthreads = {
      pkg = libevent;
      srcs = ''["lib/libevent_pthreads.so"]'';
      deps = ''[":event"]'';
    };

    googletest = {
      pkg = gtest;
      srcs = ''[ "lib/libgmock.so", "lib/libgtest.so" ]'';
      hdrs = ''glob(["include/gmock/**/*.h", "include/gtest/**/*.h"])'';
      includes = ''["include"]'';
    };

    http_parser = {
      pkg = http-parser;
      srcs = ''["lib/libhttp_parser.so"]'';
      hdrs = ''glob(["include/http_parser.h"])'';
      includes = ''["include"]'';
    };

    lightstep = {
      pkg = lightstep-tracer-cpp;
      srcs = ''["lib/liblightstep_core_cxx11.a"]'';
      hdrs = ''glob([ "include/lightstep/**/*.h", "include/mapbox_variant/**/*.hpp" ]) + [ "include/collector.pb.h", "include/lightstep_carrier.pb.h" ]'';
      includes = ''["include"]'';
      deps = ''[":protobuf"]'';
    };

    nghttp2 = {
      pkg = nghttp2;
      srcs = ''["lib/libnghttp2.so"]'';
      hdrs = ''glob(["include/nghttp2/**/*.h"])'';
      includes = ''["include"]'';
    };

    protobuf = {
      pkg = protobuf;
      srcs = ''glob(["lib/libproto*.so"])'';
      hdrs = ''glob(["include/google/protobuf/**/*.h"])'';
      includes = ''["include"]'';
    };

    rapidjson = {
      pkg = rapidjson;
      hdrs = ''glob(["include/rapidjson/**/*.h"])'';
      includes = ''["include"]'';
    };

    spdlog = {
      name = "spdlog";
      hdrs = ''glob([ "include/spdlog/**/*.cc", "include/spdlog/**/*.h" ])'';
      includes = ''["include"]'';
    };

    ssl = {
      pkg = boringssl;
      srcs = ''["lib/libssl.a"]'';
      deps = ''[":crypto"]'';
    };

    tclap = {
      pkg = tclap;
      hdrs = ''glob(["include/tclap/**/*.h"])'';
      includes = ''["include"]'';
    };

    tcmalloc_and_profiler = {
      pkg = gperftools;
      srcs = ''["lib/libtcmalloc_and_profiler.so"]'';
      hdrs = ''glob(["include/gperftools/**/*.h"])'';
      strip_include_prefix = ''"include"'';
    };
  };

  field = name: attrs: if attrs ? "${name}" then "    ${name} = ${attrs.${name}},\n" else "";
  buildFile = 
    ''
    licenses(["notice"])  # Apache 2

    package(default_visibility = ["//visibility:public"])

    '' +
    lib.concatStringsSep "\n\n" (
      lib.mapAttrsToList (name: value:
          "cc_library(\n"
        + "    name = \"${name}\",\n"
        + field "srcs" value
        + field "hdrs" value
        + field "deps" value
        + field "includes" value
        + field "strip_include_prefix" value
        + ")"
      ) ccTargets
    ) + ''

    filegroup(
        name = "protoc",
        srcs = ["bin/protoc"],
    )
    '';

  workspaceFile = 
    ''
    workspace(name = "nix")

    load("//bazel:repositories.bzl", "envoy_dependencies")
    load("//bazel:cc_configure.bzl", "cc_configure")

    new_local_repository(
        name = "nix_envoy_deps",
        path = "${repoEnv}",
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
    '';

  rpath = stdenv.lib.makeLibraryPath (allDeps ++ [
    stdenv.cc.cc
  ]);

in

{
  inherit buildFile;
  inherit workspaceFile;
  inherit repoEnv;
  inherit rpath;
}
