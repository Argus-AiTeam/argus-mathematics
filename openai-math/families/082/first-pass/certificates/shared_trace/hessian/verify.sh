#!/usr/bin/env bash
set -euo pipefail

here="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
workspace="$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0"
LEAN_PATH="$here"
for lib in "$workspace"/.lake/packages/*/.lake/build/lib/lean \
    "$workspace"/.lake/build/lib/lean; do
  if [[ -d "$lib" ]]; then
    LEAN_PATH="$LEAN_PATH:$lib"
  fi
done
export LEAN_PATH

lean --version | grep -F 'version 4.31.0'
lean -o "$here/Hessian.olean" "$here/Hessian.lean" > "$here/compile.log" 2>&1

lean --stdin > "$here/axioms.log" 2>&1 <<'LEAN'
import Hessian
#print axioms SharedTraceHessian.sqrt_mono
#print axioms SharedTraceHessian.b_spectral_positive
#print axioms SharedTraceHessian.b_antitone
#print axioms SharedTraceHessian.b_antitone_of_hermitian
#print axioms SharedTraceHessian.b_three
#print axioms SharedTraceHessian.common_metric_three
#print axioms SharedTraceHessian.b_unitary
#print axioms SharedTraceHessian.b_isometry
#print axioms SharedTraceHessian.b_zero_extension
#print axioms SharedTraceHessian.supported_gram
#print axioms SharedTraceHessian.supported_vertex
#print axioms SharedTraceHessian.vertex_le_square
LEAN

if grep -q 'sorryAx' "$here/axioms.log"; then
  echo 'Unexpected proof hole in theorem dependencies.' >&2
  exit 1
fi
echo 'Lean 4.31.0: exit_code=0; proof_holes=[]'
