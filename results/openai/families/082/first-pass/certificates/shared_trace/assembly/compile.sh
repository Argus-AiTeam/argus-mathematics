#!/usr/bin/env bash
set -euo pipefail
root="campaigns/9000082"
cert="$root/research/certificates/shared_trace"
workspace="$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0"
LEAN_PATH="$cert/assembly:$cert/cubic:$cert/hessian"
for lib in "$workspace"/.lake/packages/*/.lake/build/lib/lean "$workspace"/.lake/build/lib/lean; do
  if [[ -d "$lib" ]]; then LEAN_PATH="$LEAN_PATH:$lib"; fi
done
export LEAN_PATH
lean --version | grep -F 'version 4.31.0'
lean "$@"
