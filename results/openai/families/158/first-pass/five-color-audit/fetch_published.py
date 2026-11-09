"""Fetch only the pinned theorem's source dependency closure, without Git."""

import base64
import hashlib
import json
from pathlib import Path
import re
import subprocess


REVISION = "4eaee87548250b2682affda7d05d947c05554bae"
ROOT = Path(__file__).resolve().parent


def fetch(path):
    result = subprocess.run(
        ["gh", "api", f"repos/openai/math/contents/{path}?ref={REVISION}"],
        capture_output=True,
        text=True,
        timeout=60,
        check=True,
    )
    record = json.loads(result.stdout)
    content = base64.b64decode(record["content"], validate=False)
    actual = hashlib.sha1(
        b"blob " + str(len(content)).encode("ascii") + b"\0" + content
    ).hexdigest()
    if actual != record["sha"]:
        raise ValueError(f"GitHub content/object mismatch: {path}")
    return content, {"path": path, "git_blob": actual, "bytes": len(content)}


def main():
    destination = ROOT / "published"
    if (ROOT / "source_provenance.json").exists():
        raise FileExistsError("Pinned sources already fetched; do not refetch unchanged inputs")
    pending = ["OAI.Geometry.PlaneColoring.Five"]
    records = {}
    imports = {}
    while pending:
        module = pending.pop()
        if module in records:
            continue
        if not re.fullmatch(r"OAI(?:\.[A-Za-z_][A-Za-z_0-9]*)+", module):
            raise ValueError(f"Unsupported external source module: {module}")
        if len(records) >= 128:
            raise ValueError("The bounded source closure exceeded 128 modules")
        relative = module.replace(".", "/") + ".lean"
        content, record = fetch("lean/" + relative)
        path = destination / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(content)
        dependencies = [
            name
            for line in content.decode("utf-8").splitlines()
            if line.startswith("import ")
            for name in line.removeprefix("import ").split()
        ]
        imports[module] = dependencies
        records[module] = record
        pending.extend(name for name in dependencies if name.startswith("OAI."))
        print(f"fetched {module} ({len(content)} bytes)", flush=True)
    for source, target in [
        ("lean/docs/158.md", "scope.txt"),
        ("lean/lean-toolchain", "lean-toolchain.txt"),
        ("lean/ComparatorChallenges/EuclideanFiveColor.lean", "comparator.txt"),
    ]:
        content, record = fetch(source)
        destination.mkdir(parents=True, exist_ok=True)
        (destination / target).write_bytes(content)
        records[target] = record
    order = []
    visiting = set()

    def visit(module):
        if module in order:
            return
        if module in visiting:
            raise ValueError(f"Cyclic source imports: {module}")
        visiting.add(module)
        for dependency in imports[module]:
            if dependency.startswith("OAI."):
                visit(dependency)
        visiting.remove(module)
        order.append(module)

    visit("OAI.Geometry.PlaneColoring.Five")
    provenance = {
        "repository": "https://github.com/openai/math",
        "revision": REVISION,
        "target": "OAI.Geometry.PlaneColoring.Five",
        "records": records,
        "imports": imports,
        "topological_order": order,
    }
    (ROOT / "source_provenance.json").write_text(
        json.dumps(provenance, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps({"source_modules": len(order), "revision": REVISION}))


if __name__ == "__main__":
    main()
