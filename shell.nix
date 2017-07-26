#with import <nixpkgs> { };
with import ~/src/nixpkgs { };

let
  # from TARGET_RECIPES
  deps = [
    c-ares
    backward-cpp
    libevent
    pythonPackages.gcovr
    gtest
    gperftools
    http-parser
    nghttp2
    protobuf3_2
    rapidjson
    spdlog
    boringssl
  ];

in

runCommand "dummy" {
  hardeningDisable = "all";
  buildInputs = [
    bazel pkgconfig patchelf
  ] ++ deps;
  shellHook = ''
  '';
} ""
