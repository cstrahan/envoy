#!/bin/sh

exe=$1
#exe=bazel-bin/source/exe/envoy-static

rpath=$(nix-instantiate ./deps.nix -A rpath --eval | jq -r .)

#patchelf --print-rpath $exe

patchelf --set-rpath ${rpath} $exe
