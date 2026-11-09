#!/usr/bin/env python3
"""Vendor the needed Apache-2.0 proofs and assemble one checkable Lean source."""

import argparse
import base64
import json
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parent
REVISION = "4eaee87548250b2682affda7d05d947c05554bae"
PREFIX = "OAI.Combinatorics.Sensitivity."
UPSTREAM = ROOT / "upstream"


def fetch(path):
    response = subprocess.run(
        ["gh", "api", f"repos/openai/math/contents/{path}?ref={REVISION}"],
        check=True,
        capture_output=True,
        text=True,
    )
    return base64.b64decode(json.loads(response.stdout)["content"]).decode("utf-8")


def dependencies(source):
    return re.findall(r"^import OAI\.Combinatorics\.Sensitivity\.(\w+)\s*$", source, re.M)


def vendor():
    UPSTREAM.mkdir(exist_ok=True)
    (UPSTREAM / "LICENSE").write_text(fetch("lean/LICENSE"), encoding="utf-8")
    pending = ["Construction", "Labeling", "Iterates"]
    sources = {}
    while pending:
        name = pending.pop()
        if name in sources:
            continue
        source = fetch(f"lean/OAI/Combinatorics/Sensitivity/{name}.lean")
        sources[name] = source
        (UPSTREAM / f"{name}.lean").write_text(source, encoding="utf-8")
        pending.extend(dependencies(source))
    ordered = []

    def visit(name):
        if name in ordered:
            return
        for dependency in dependencies(sources[name]):
            visit(dependency)
        ordered.append(name)

    for name in sorted(sources):
        visit(name)
    manifest = {
        "repository": "https://github.com/openai/math",
        "revision": REVISION,
        "license": "Apache-2.0",
        "modules_in_dependency_order": ordered,
        "assembly": (
            "Incorporate every selected source in dependency order, omitting "
            "only import lines. Compile the resulting Main.lean against Mathlib 4.31.0."
        ),
    }
    (UPSTREAM / "manifest.json").write_text(
        json.dumps(manifest, indent=2) + "\n", encoding="ascii"
    )
    print(f"Vendored {len(ordered)} needed proof modules at {REVISION}.")


def assembled_source():
    manifest = json.loads((UPSTREAM / "manifest.json").read_text())
    chunks = [
        "import Mathlib\n\n",
        "/-!\n",
        "The dependency proofs below are from OpenAI's openai/math, revision\n",
        f"{REVISION}, under Apache-2.0; see upstream/LICENSE.\n",
        "This combined file changes the upstream packaging by removing local imports.\n",
        "The new quantitative extension follows the inherited dependencies.\n",
        "All dependency proofs are compiled here, not imported as unchecked oleans.\n",
        "-/\n\n",
        (ROOT / "Compatibility.lean").read_text(),
        "\n",
    ]
    for name in manifest["modules_in_dependency_order"]:
        source = (UPSTREAM / f"{name}.lean").read_text()
        chunks.extend(
            [
                f"\n/- Upstream module: {PREFIX}{name}. -/\n",
                re.sub(r"^import .*\n", "", source, flags=re.M),
                "\n",
            ]
        )
    for name in ("ProfileCore.lean", "SeedTrace.lean", "BooleanExtension.lean"):
        source = (ROOT / name).read_text()
        chunks.extend(
            [
                f"\n/- Campaign extension: {name}. -/\n",
                re.sub(r"^import .*\n", "", source, flags=re.M),
                "\n",
            ]
        )
    return "".join(chunks)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fetch", action="store_true")
    args = parser.parse_args()
    if args.fetch:
        vendor()
    else:
        (ROOT / "Main.lean").write_text(assembled_source(), encoding="utf-8")
        print("Assembled Main.lean from the archived sources and new extension.")


if __name__ == "__main__":
    main()
