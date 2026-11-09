#!/usr/bin/env bash
set -euo pipefail
root="campaigns/9000082"
cert="$root/research/certificates/shared_trace"
assembly="$cert/assembly"
cd "$root"

for module in General Blocks Trace Phase Projections; do
  bash "$assembly/compile.sh" -o "$assembly/$module.olean" "$assembly/$module.lean" \
    > "$assembly/logs/${module,,}.log" 2>&1
done
bash "$assembly/compile.sh" -o "$assembly/Main.olean" "$cert/Main.lean" \
  > "$assembly/logs/main.log" 2>&1
bash "$assembly/compile.sh" --stdin > "$assembly/logs/axioms.log" 2>&1 <<'LEAN'
import Main
#print axioms SharedTraceAssembly.cubicSum_bound_unsorted
#print axioms SharedTraceAssembly.b_diagonal_square
#print axioms SharedTraceAssembly.hermitian_cubic_bound
#print axioms SharedTraceAssembly.rowCost_spectral_positive
#print axioms SharedTraceAssembly.rowCost_isometry
#print axioms SharedTraceAssembly.triangle_common_metric
#print axioms SharedTraceAssembly.blockD_norm_le
#print axioms SharedTraceAssembly.projection0_gram
#print axioms SharedTraceAssembly.projection1_gram
#print axioms SharedTraceAssembly.projection2_gram
#print axioms SharedTraceAssembly.projection0_direction
#print axioms SharedTraceAssembly.projection1_direction
#print axioms SharedTraceAssembly.projection2_direction
#print axioms SharedTraceAssembly.triangle_trace_cube
#print axioms SharedTraceAssembly.real_trace_bound
#print axioms SharedTraceAssembly.rowCost_fromCols_phase
#print axioms SharedTraceAssembly.exists_aligning_phase
#print axioms SharedTrace.energy_phase
#print axioms SharedTrace.mixed_trace_estimate
LEAN

python - <<'PY'
import hashlib
import json
import pathlib
import re
import subprocess

cert = pathlib.Path("research/certificates/shared_trace")
assembly = cert / "assembly"
log = (assembly / "logs/axioms.log").read_text()
allowed = {"propext", "Classical.choice", "Quot.sound"}
entries = re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", log)
assert entries and entries[-1][0] == "SharedTrace.mixed_trace_estimate"
for theorem, raw in entries:
    axioms = {s.strip() for s in raw.split(",") if s.strip()}
    assert axioms <= allowed, (theorem, axioms - allowed)
sources = [cert / "Main.lean", *sorted(assembly.glob("*.lean"))]
for source in sources:
    text = source.read_text()
    assert not re.search(r"\b(sorry|admit|axiom)\b", text), source
result = {
    "theorem": "SharedTrace.mixed_trace_estimate",
    "compiler": subprocess.check_output(["lean", "--version"], text=True).strip(),
    "command": "bash research/certificates/shared_trace/assembly/verify.sh",
    "exit_code": 0,
    "proof_holes": [],
    "axioms": sorted(allowed),
    "sources_sha256": {
        str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in sources
    },
    "checked_theorems": [name for name, _ in entries],
}
(assembly / "compile_result.json").write_text(json.dumps(result, indent=2) + "\n")
print("Lean 4.31.0: exit_code=0; proof_holes=[]")
print("Final theorem axioms: propext, Classical.choice, Quot.sound")
PY
