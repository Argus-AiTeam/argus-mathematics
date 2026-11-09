#!/usr/bin/env python3
"""Retrieve the pinned Apache-2.0 solution closure, then flatten its imports."""

from pathlib import Path
import re
import urllib.request


ROOT = Path(__file__).resolve().parent
REVISION = "4eaee87548250b2682affda7d05d947c05554bae"
BASE = f"https://raw.githubusercontent.com/openai/math/{REVISION}/lean/"
IMPORT = re.compile(r"^import\s+(.+)$", re.MULTILINE)


def main():
    sources = {}
    ordered = []

    def visit(module):
        if module in sources:
            return
        path = ROOT / "upstream" / (module.replace(".", "/") + ".lean.txt")
        if not path.exists():
            with urllib.request.urlopen(
                BASE + module.replace(".", "/") + ".lean", timeout=40
            ) as response:
                text = response.read().decode()
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text)
        text = path.read_text()
        sources[module] = text
        for line in IMPORT.findall(text):
            for dependency in line.split():
                if dependency.startswith("OAI."):
                    visit(dependency)
                elif not dependency.startswith("Mathlib"):
                    raise ValueError(f"Unrecognized import: {dependency}")
        ordered.append(module)

    visit("OAI.NumberTheory.ShortEgyptian.MomentAsymptotics")
    sections = [
        "import Mathlib\n",
        "set_option maxHeartbeats 1600000\n",
        "/- The following Apache-2.0 sources are from openai/math, revision\n"
        f"   {REVISION}. Modified here by flattening imports for Lean 4.31.0.\n"
        "   See LICENSE.upstream and the original files in upstream/. -/\n",
        (ROOT / "compatibility.lean.txt").read_text(),
    ]
    relevant = ordered[ordered.index("OAI.NumberTheory.ShortEgyptian.PrimeReciprocals") :]
    for module in relevant:
        adapted = IMPORT.sub("", sources[module])
        adapted = adapted.replace("prod_le_prod₀", "prod_le_prod")
        adapted = adapted.replace("ite_eq_left", "if_pos").replace("ite_eq_right", "if_neg")
        adapted = adapted.replace(
            "convert Real.log_pow 2 2 using 1\n      norm_num",
            "convert Real.log_pow 2 2 using 1 <;> norm_num",
        )
        sections.extend(
            [f"\n/- Upstream module: {module} -/\n", adapted]
        )
    (ROOT / "Upstream.lean.txt").write_text("\n".join(sections))
    bridge = ROOT / "bridge.lean.txt"
    if bridge.exists():
        (ROOT / "Main.lean").write_text("\n".join(sections) + "\n" + bridge.read_text())
    print(f"Recovered {len(ordered)} modules; bundled {len(relevant)} relevant proof modules.")


if __name__ == "__main__":
    main()
