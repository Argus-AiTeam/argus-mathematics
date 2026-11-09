#!/usr/bin/env python3
"""Fetch only the pinned OpenAI producer import closure using GitHub's API."""

from __future__ import annotations

import concurrent.futures
import hashlib
import json
import pathlib
import re
import subprocess
import time

ROOT = pathlib.Path(__file__).resolve().parent
REPOSITORY = "openai/math"
REVISION = "4eaee87548250b2682affda7d05d947c05554bae"
ENTRY = "OAI.Analysis.Nonexpansive.TreeProducer"
FORBIDDEN = {
    "Main",
    "Reduction",
    "NormalizedContradiction",
    "BranchContradiction",
}


def uncomment(source: str) -> str:
    result: list[str] = []
    depth = 0
    index = 0
    while index < len(source):
        pair = source[index : index + 2]
        if pair == "/-":
            depth += 1
            result.extend("  ")
            index += 2
        elif pair == "-/" and depth:
            depth -= 1
            result.extend("  ")
            index += 2
        elif pair == "--" and not depth:
            end = source.find("\n", index)
            if end == -1:
                break
            result.extend(" " * (end - index))
            index = end
        else:
            character = source[index]
            result.append(character if not depth or character == "\n" else " ")
            index += 1
    return "".join(result)


def imports(source: str) -> list[str]:
    clean = uncomment(source)
    modules: list[str] = []
    for match in re.finditer(
        r"(?m)^\s*(?:(?:public|private|meta)\s+)*import\s+([^\n]+)", clean
    ):
        modules.extend(re.findall(r"\b[A-Z][A-Za-z0-9_'.]*\b", match.group(1)))
    return modules


def api_file(path: str) -> bytes:
    return subprocess.run(
        [
            "gh",
            "api",
            "-H",
            "Accept: application/vnd.github.raw+json",
            f"repos/{REPOSITORY}/contents/{path}?ref={REVISION}",
        ],
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    ).stdout


def fetch_module(module: str) -> tuple[str, bytes]:
    path = "lean/" + module.replace(".", "/") + ".lean"
    original = ROOT / "upstream" / path
    if original.is_file():
        return module, original.read_bytes()
    data = api_file(path)
    original.parent.mkdir(parents=True, exist_ok=True)
    original.write_bytes(data)
    return module, data


def main() -> None:
    start = time.monotonic()
    seen: dict[str, dict[str, object]] = {}
    pending = {ENTRY}
    external: set[str] = set()
    while pending:
        batch = sorted(pending)
        pending = set()
        with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
            for module, data in pool.map(fetch_module, batch):
                source = data.decode("utf-8")
                dependencies = imports(source)
                if module.split(".")[-1] in FORBIDDEN:
                    raise RuntimeError(f"Forbidden dependency: {module}")
                holes = re.findall(r"\b(?:sorry|admit|axiom)\b", uncomment(source))
                if holes:
                    raise RuntimeError(f"Unproved declaration in {module}: {holes}")
                destination = ROOT / (module.replace(".", "/") + ".lean")
                destination.parent.mkdir(parents=True, exist_ok=True)
                if not destination.exists():
                    destination.write_bytes(data)
                seen[module] = {
                    "path": str(destination.relative_to(ROOT)),
                    "upstream_path": "lean/" + module.replace(".", "/") + ".lean",
                    "upstream_sha256": hashlib.sha256(data).hexdigest(),
                    "imports": dependencies,
                }
                for dependency in dependencies:
                    if dependency.startswith("OAI."):
                        if dependency not in seen:
                            pending.add(dependency)
                    else:
                        external.add(dependency)
                print(f"Fetched {module}", flush=True)
        pending.difference_update(seen)

    licenses = {}
    for name in ("LICENSE", "NOTICE"):
        try:
            data = api_file(name)
        except subprocess.CalledProcessError as error:
            if b"404" not in error.stderr:
                raise
            licenses[name] = {"present": False}
            continue
        path = ROOT / "upstream" / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
        licenses[name] = {
            "present": True,
            "sha256": hashlib.sha256(data).hexdigest(),
        }

    toolchain = api_file("lean/lean-toolchain")
    (ROOT / "upstream" / "lean" / "lean-toolchain").write_bytes(toolchain)
    record = {
        "repository": REPOSITORY,
        "revision": REVISION,
        "revision_url": f"https://github.com/{REPOSITORY}/commit/{REVISION}",
        "entry": ENTRY,
        "upstream_toolchain": toolchain.decode().strip(),
        "source_count": len(seen),
        "modules": dict(sorted(seen.items())),
        "external_imports": sorted(external),
        "license_files": licenses,
        "elapsed_seconds": time.monotonic() - start,
    }
    (ROOT / "source_manifest.json").write_text(json.dumps(record, indent=2) + "\n")
    print(json.dumps({key: record[key] for key in ("revision", "source_count", "elapsed_seconds")}))


if __name__ == "__main__":
    main()
