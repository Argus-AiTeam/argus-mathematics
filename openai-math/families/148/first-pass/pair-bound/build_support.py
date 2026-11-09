#!/usr/bin/env python3
"""Fetch and compile the pinned elementary Lean libraries used by this proof."""

import argparse
import base64
import json
import os
from pathlib import Path
import re
import subprocess


HERE = Path(__file__).resolve().parent
VENDOR = HERE / "vendor"
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
REVISION = "4eaee87548250b2682affda7d05d947c05554bae"
ROOTS = (
    "OAI.MeasureTheory.SelfSimilar.ProductLaw",
)
FORBIDDEN = {
    "OAI.MeasureTheory.SelfSimilar.GridCoupling",
    "OAI.MeasureTheory.SelfSimilar.FiniteRefinement",
    "OAI.MeasureTheory.SelfSimilar.SumsetBound",
}


def source_path(module):
    return VENDOR.joinpath(*module.split(".")).with_suffix(".lean")


def imports(source):
    return [
        module
        for line in source.splitlines()
        if line.startswith("import ")
        for module in line.removeprefix("import ").split()
        if module.startswith("OAI.")
    ]


def fetch(module, seen):
    if module in seen:
        return
    if module in FORBIDDEN:
        raise ValueError(f"Forbidden high-level proof dependency: {module}")
    seen.add(module)
    relative = "lean/" + module.replace(".", "/") + ".lean"
    response = subprocess.run(
        ["gh", "api", f"repos/openai/math/contents/{relative}?ref={REVISION}"],
        check=True,
        capture_output=True,
        text=True,
    )
    document = json.loads(response.stdout)
    source = base64.b64decode(document["content"]).decode()
    original = source
    if module.endswith(".FairPairs"):
        source = source.replace(
            "import OAI.MeasureTheory.SelfSimilar.TranslationGain",
            "import OAI.MeasureTheory.SelfSimilar.FiniteEntropy",
        )
    for old, new in (
        ("Set.mem_ofPred_eq", "Set.mem_setOf_eq"),
        ("Set.ofPred_forall", "Set.setOf_forall"),
        ("dite_eq_left", "dif_pos"), ("dite_eq_right", "dif_neg"),
        ("ite_eq_left", "if_pos"), ("ite_eq_right", "if_neg"),
    ):
        source = re.sub(r"\b" + re.escape(old) + r"\b", new, source)
    if source != original:
        source = (
            "/-\nModified for this audit: source imports and theorem names adapted to\n"
            "Lean/Mathlib 4.31.0; theorem statements unchanged. Upstream OpenAI/math\n"
            f"revision {REVISION}, Apache-2.0; see the package LICENSE.\n-/\n"
        ) + source
    path = source_path(module)
    path.parent.mkdir(parents=True, exist_ok=True)
    if not path.exists() or path.read_text() != source:
        path.write_text(source)
    print(f"fetched {module}", flush=True)
    for dependency in imports(source):
        fetch(dependency, seen)


def build(module, seen, environment):
    if module in seen:
        return
    if module in FORBIDDEN:
        raise ValueError(f"Forbidden high-level proof dependency: {module}")
    path = source_path(module)
    source = path.read_text()
    if re.search(r"^\s*(axiom|sorry|admit)\b", source, re.MULTILINE):
        raise ValueError(f"Unproved declaration in {path}")
    dependencies = imports(source)
    for dependency in dependencies:
        build(dependency, seen, environment)
    output = path.with_suffix(".olean")
    inputs = [path] + [source_path(item).with_suffix(".olean") for item in dependencies]
    if output.exists() and output.stat().st_mtime_ns >= max(item.stat().st_mtime_ns for item in inputs):
        seen.add(module)
        print(f"up to date {module}", flush=True)
        return
    print(f"compiling {module}", flush=True)
    subprocess.run(
        [
            "lake", "env", "lean", f"--root={VENDOR}",
            "-o", str(output), str(path),
        ],
        cwd=WORKSPACE,
        env=environment,
        check=True,
    )
    seen.add(module)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fetch", action="store_true")
    parser.add_argument("--build", action="store_true")
    args = parser.parse_args()
    if not (args.fetch or args.build):
        parser.error("Choose --fetch or --build.")
    if args.fetch:
        seen = set()
        for module in ROOTS:
            fetch(module, seen)
        response = subprocess.run(
            ["gh", "api", f"repos/openai/math/contents/LICENSE?ref={REVISION}"],
            check=True, capture_output=True, text=True,
        )
        (HERE / "LICENSE").write_bytes(base64.b64decode(json.loads(response.stdout)["content"]))
        print(f"Fetched {len(seen)} modules at {REVISION}.", flush=True)
    if args.build:
        environment = dict(os.environ, LEAN_PATH=str(VENDOR))
        seen = set()
        for module in ROOTS:
            build(module, seen, environment)
        print(f"Compiled {len(seen)} elementary support modules.", flush=True)


if __name__ == "__main__":
    main()
