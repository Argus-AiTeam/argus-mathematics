#!/bin/sh
# Attempt the unchanged pinned entry points with the configured math-pack verifier.
set -u
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
printf '%s\n' 'Original pinned sources; no compatibility substitutions.'
printf 'MATH_LEAN_WORKSPACE=%s\nELAN_HOME=%s\n' "${MATH_LEAN_WORKSPACE-}" "${ELAN_HOME-}"
math-lean-verify \
  "$here/upstream/lean/OAI/Probability/SKSupport/Main.lean" \
  "$here/upstream/lean/OAI/Probability/SKValue/Main.lean" --timeout 120
status=$?
printf 'math-lean-verify exit status: %s\n' "$status"
exit "$status"
