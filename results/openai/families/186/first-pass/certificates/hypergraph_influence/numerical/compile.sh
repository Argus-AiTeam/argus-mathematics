#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/../../../.." && pwd)"
workspace=$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0
export LEAN_PATH="$(cd "$workspace" && lake env printenv LEAN_PATH)"
cd "$root"
mkdir -p research/certificates/hypergraph_influence/build/research/certificates/hypergraph_influence
$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean \
  --root="$root" \
  -o research/certificates/hypergraph_influence/build/research/certificates/hypergraph_influence/Constants.olean \
  research/certificates/hypergraph_influence/Constants.lean
