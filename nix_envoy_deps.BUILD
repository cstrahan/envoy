licenses(["notice"])  # Apache 2

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "ares",
    srcs = ["lib/libcares.so"],
    hdrs = glob(["include/ares*.h"]),
    includes = ["include"],
)

cc_library(
    name = "backward",
    hdrs = ["include/backward.hpp"],
    includes = ["include"],
)

cc_library(
    name = "crypto",
    srcs = ["lib/libcrypto.a"],
    hdrs = glob(["include/openssl/**/*.h"]),
    includes = ["include"],
)

cc_library(
    name = "event",
    srcs = ["lib/libevent.so"],
    hdrs = glob(["include/event2/**/*.h"]),
    includes = ["include"],
)

cc_library(
    name = "event_pthreads",
    srcs = ["lib/libevent_pthreads.so"],
    deps = [":event"],
)

cc_library(
    name = "googletest",
    srcs = [ "lib/libgmock.so", "lib/libgtest.so" ],
    hdrs = glob(["include/gmock/**/*.h", "include/gtest/**/*.h"]),
    includes = ["include"],
)

cc_library(
    name = "http_parser",
    srcs = ["lib/libhttp_parser.so"],
    hdrs = glob(["include/http_parser.h"]),
    includes = ["include"],
)

cc_library(
    name = "lightstep",
    srcs = ["lib/liblightstep_core_cxx11.a"],
    hdrs = glob([ "include/lightstep/**/*.h", "include/mapbox_variant/**/*.hpp" ]) + [ "include/collector.pb.h", "include/lightstep_carrier.pb.h" ],
    deps = [":protobuf"],
    includes = ["include"],
)

cc_library(
    name = "nghttp2",
    srcs = ["lib/libnghttp2.so"],
    hdrs = glob(["include/nghttp2/**/*.h"]),
    includes = ["include"],
)

cc_library(
    name = "protobuf",
    srcs = glob(["lib/libproto*.so"]),
    hdrs = glob(["include/google/protobuf/**/*.h"]),
    includes = ["include"],
)

cc_library(
    name = "rapidjson",
    hdrs = glob(["include/rapidjson/**/*.h"]),
    includes = ["include"],
)

cc_library(
    name = "spdlog",
    hdrs = glob([ "include/spdlog/**/*.cc", "include/spdlog/**/*.h" ]),
    includes = ["include"],
)

cc_library(
    name = "ssl",
    srcs = ["lib/libssl.a"],
    deps = [":crypto"],
)

cc_library(
    name = "tclap",
    hdrs = glob(["include/tclap/**/*.h"]),
    includes = ["include"],
)

cc_library(
    name = "tcmalloc_and_profiler",
    srcs = ["lib/libtcmalloc_and_profiler.so"],
    hdrs = glob(["include/gperftools/**/*.h"]),
    strip_include_prefix = "include",
)

cc_library(
    name = "yaml_cpp",
    srcs = ["lib/libyaml-cpp.so"],
    hdrs = glob(["include/yaml-cpp/**/*.h"]),
    includes = ["include"],
)

cc_library(
    name = "zlib",
    srcs = [ "lib/libz.so" ],
    hdrs = [ "include/zconf.h", "include/zlib.h" ],
)
filegroup(
    name = "protoc",
    srcs = ["bin/protoc"],
)

