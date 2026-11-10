#!/usr/bin/env python3
"""Bundle the pinned family-255 coarse and cyclic-series interfaces for replay."""
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
MANIFEST = json.loads((HERE / "closure.json").read_text())
MODULES = MANIFEST["modules"]
ENTRIES = [
    "OAI.GroupTheory.PolycyclicRecognition.Analysis.CoarseEquivalenceMetric",
    "OAI.GroupTheory.PolycyclicRecognition.CoarseFiniteGeneration",
    "OAI.GroupTheory.PolycyclicRecognition.Analysis.SelfQuasiIsometry",
]
order = []
seen = set()


def visit(module):
    if module in seen or module not in MODULES:
        return
    seen.add(module)
    for dependency in MODULES[module]["imports"]:
        visit(dependency)
    order.append(module)


for entry in ENTRIES:
    visit(entry)

parts = ["import Mathlib\n"]
for module in order:
    path = HERE / "upstream/lean" / (module.replace(".", "/") + ".lean")
    data = path.read_bytes()
    assert hashlib.sha256(data).hexdigest() == MODULES[module]["sha256"], path
    source = data.decode()
    parts.append(f"\n/- Pinned source: {MODULES[module]['path']} -/\n")
    parts.append("".join(
        line for line in source.splitlines(keepends=True)
        if not line.startswith("import ")
    ))

extracts = []


def extract(module, start, stop):
    path = HERE / "upstream/lean" / (module.replace(".", "/") + ".lean")
    data = path.read_bytes()
    assert hashlib.sha256(data).hexdigest() == MODULES[module]["sha256"], path
    source = data.decode()
    result = source[source.index(start):source.index(stop, source.index(start))]
    extracts.append({"module": module, "start": start, "stop_before": stop})
    return result


length = "OAI.GroupTheory.CyclicSeries.Length"
parts.append("\n/- Exact cyclic-series declarations and constructors only. -/\n")
parts.append(extract(length, "namespace OAI", "noncomputable def cyclicLength"))
parts.append(extract(length, "namespace CyclicStep\nvariable {G : Type*}",
                     "def map (c : CyclicSeries"))
parts.append("\nend CyclicSeries\nend ChromaticCyclic\nend OAI\n")
parts.append(extract("OAI.GroupTheory.PolycyclicRecognition.Algebra.Polycyclic",
                     "namespace OAI", "variable {G}"))
parts.append("\nend PolycyclicRecognition\nend OAI\n")
parts.append(extract("OAI.GroupTheory.PolycyclicRecognition.Algebra.Extensions",
                     "namespace OAI", "/-- Polycyclic groups are closed"))
parts.append("\nend PolycyclicRecognition\nend OAI\n")
parts.append("\n/- Task-local witnesses, not author theorems. -/\n")
parts.append("".join(
    line for line in (HERE / "InterfaceWitnesses.lean").read_text().splitlines(keepends=True)
    if not line.startswith("import ")
))
(HERE / "InterfaceReplay.lean").write_text("".join(parts))
(HERE / "interface-replay.json").write_text(json.dumps({
    "upstream_commit": MANIFEST["commit"],
    "entries": ENTRIES,
    "module_order": order,
    "exact_declaration_extracts": extracts,
    "substitutions": ["Hoist all imports to the locally installed Mathlib umbrella.",
                      "Remove local OAI imports after dependency-order concatenation.",
                      "For cyclic-series non-vacuity, include only exact defining "
                      "declarations and the cyclic base-case constructors, not "
                      "the unrelated Length/comap/index API."],
    "source_bytes": sum(MODULES[module]["bytes"] for module in order),
    "output_sha256": hashlib.sha256((HERE / "InterfaceReplay.lean").read_bytes()).hexdigest(),
}, indent=2) + "\n")
print(f"{len(order)} modules; {sum(MODULES[m]['bytes'] for m in order)} source bytes")
