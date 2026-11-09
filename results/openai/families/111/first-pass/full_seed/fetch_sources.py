#!/usr/bin/env python3
"""Retrieve the pinned OAI import closure, without repository metadata."""

import concurrent.futures
import json
from pathlib import Path
import re
import urllib.request


COMMIT = "4eaee87548250b2682affda7d05d947c05554bae"
ROOT = Path(__file__).resolve().parent
BASE = f"https://raw.githubusercontent.com/openai/math/{COMMIT}/lean/"


def fetch(module):
    relative = module.replace(".", "/") + ".lean"
    with urllib.request.urlopen(BASE + relative, timeout=60) as response:
        source = response.read()
    destination = ROOT / "upstream" / relative
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(source)
    imports = [
        name
        for line in source.decode().splitlines()
        if re.match(r"^(?:public )?import ", line)
        for name in line.split("import ", 1)[1].split()
        if name.startswith("OAI.")
    ]
    return module, imports


def main():
    pending = {"OAI.Probability.MatroidProphet.Main"}
    dependencies = {}
    with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
        while pending:
            batch = sorted(pending)
            pending = set()
            for module, imports in pool.map(fetch, batch):
                dependencies[module] = imports
                pending.update(name for name in imports if name not in dependencies)
    for name in ("lean-toolchain", "lakefile.lean"):
        with urllib.request.urlopen(BASE + name, timeout=60) as response:
            (ROOT / "upstream" / name).write_bytes(response.read())
    (ROOT / "upstream" / "import_closure.json").write_text(
        json.dumps({"commit": COMMIT, "dependencies": dependencies}, indent=2) + "\n"
    )
    print(json.dumps({"commit": COMMIT, "oai_modules": len(dependencies)}))


if __name__ == "__main__":
    main()
