#!/bin/sh

nix-build ./deps.nix -A repoEnv

nix-instantiate ./deps.nix -A buildFile --eval | jq -r . > nix_envoy_deps.BUILD

nix-instantiate ./deps.nix -A workspaceFile --eval | jq -r . > WORKSPACE
