#!/usr/bin/env python3
"""Archive the pinned public theorem's import closure as uncertified text."""

import argparse
import hashlib
import json
import re
import subprocess
import time
from pathlib import Path


ROOT = Path(__file__).resolve().parent
REVISION = "4eaee87548250b2682affda7d05d947c05554bae"
SEEDS = [
    "OAI.CategoryTheory.Thomason.RankedFaithfulness",
    "OAI.CategoryTheory.Thomason.CoreCouniversality",
]
IMPORT = re.compile(r"^\s*(?:public\s+)?import\s+([A-Za-z0-9_.]+)", re.MULTILINE)


def source_path(module):
    return ROOT / "vendor" / "lean" / (module.replace(".", "/") + ".lean.txt")


def inspect():
    pending = list(SEEDS)
    graph = {}
    missing = set()
    external = set()
    while pending:
        module = pending.pop()
        if module in graph or module in missing:
            continue
        path = source_path(module)
        if not path.exists():
            missing.add(module)
            continue
        raw = path.read_bytes()
        imports = IMPORT.findall(raw.decode())
        graph[module] = {
            "path": str(path.relative_to(ROOT)),
            "bytes": len(raw),
            "lines": len(raw.splitlines()),
            "sha256": hashlib.sha256(raw).hexdigest(),
            "imports": imports,
        }
        for dependency in imports:
            if dependency.startswith("OAI."):
                pending.append(dependency)
            else:
                external.add(dependency)
    return graph, sorted(missing), sorted(external)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-batches", type=int, default=12)
    parser.add_argument("--max-seconds", type=float, default=75)
    args = parser.parse_args()
    started = time.monotonic()
    requests = []
    for batch in range(args.max_batches):
        graph, missing, external = inspect()
        if not missing or time.monotonic() - started > args.max_seconds:
            break
        frontier = missing[:16]
        fields = []
        for index, module in enumerate(frontier):
            expression = REVISION + ":lean/" + module.replace(".", "/") + ".lean"
            fields.append(
                f"f{index}: object(expression:{json.dumps(expression)})"
                " { ... on Blob { byteSize text } }"
            )
        query = (
            'query { repository(owner:"openai", name:"math") { '
            + " ".join(fields)
            + " } }"
        )
        result = subprocess.run(
            ["gh", "api", "graphql", "-f", "query=" + query],
            check=True,
            text=True,
            capture_output=True,
            timeout=25,
        )
        response = json.loads(result.stdout)
        if response.get("errors"):
            raise RuntimeError(response["errors"])
        objects = response["data"]["repository"]
        for index, module in enumerate(frontier):
            blob = objects[f"f{index}"]
            if blob is None or "text" not in blob:
                raise RuntimeError("Missing pinned source: " + module)
            path = source_path(module)
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(blob["text"])
            print(f"{module}: {blob['byteSize']} bytes", flush=True)
        requests.append(frontier)
    graph, missing, external = inspect()
    manifest = {
        "repository": "https://github.com/openai/math",
        "revision": REVISION,
        "roots": SEEDS,
        "complete": not missing,
        "certification": "NOT CERTIFIED; upstream source archived as .lean.txt",
        "module_count": len(graph),
        "total_bytes": sum(item["bytes"] for item in graph.values()),
        "total_lines": sum(item["lines"] for item in graph.values()),
        "missing_frontier": missing,
        "external_imports": external,
        "modules": dict(sorted(graph.items())),
    }
    (ROOT / "dependency_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(
        json.dumps(
            {key: value for key, value in manifest.items() if key != "modules"},
            indent=2,
        ),
        flush=True,
    )


if __name__ == "__main__":
    main()
