#!/bin/sh

export HOME=$PWD/.home
mkdir -p build

DIR=$PWD

# TODO: automate setting up thirdparty/protobuf
#https://github.com/htuch/protobuf.git
#d490587268931da78c942a6372ef57bb53db80da
#mkdir -p thirdparty

BAZEL_OPTIONS="--package_path %workspace%:$PWD"

BAZEL_BUILD_OPTIONS="\
  --strategy=Genrule=standalone \
  --spawn_strategy=standalone \
  --verbose_failures \
  ${BAZEL_OPTIONS} \
  --action_env=HOME \
  --action_env=PYTHONUSERBASE \
  ${enableParallelBuilding:+--jobs=${NIX_BUILD_CORES}} \
  --show_task_finish"

export hardeningDisable="all"

build() {
  #export LD_PRELOAD=$LD_PRELOAD 
  #export BEAR_OUTPUT=$BEAR_OUTPUT

  #BAZEL_BUILD_OPTIONS="${BAZEL_BUILD_OPTIONS} --explain=explain.log"
  #BAZEL_BUILD_OPTIONS="${BAZEL_BUILD_OPTIONS} --verbose_explanations"
  #BAZEL_BUILD_OPTIONS="${BAZEL_BUILD_OPTIONS} --logging=0"
    #--action_env LD_PRELOAD \
  bazel \
    --batch \
    build \
    -s --verbose_failures \
    --experimental_ui \
    ${BAZEL_BUILD_OPTIONS} \
    -c opt \
    //source/exe:envoy-static.stripped
    #//source/exe:envoy_main_common_lib
    #//source/exe:envoy-static
}

query() {
  bazel \
    query \
    ${BAZEL_OPTIONS} \
    --experimental_ui \
    //source/exe:envoy-static
}

build
