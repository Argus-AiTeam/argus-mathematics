#!/usr/bin/env python3
"""Acquire and compile the pinned primary proof against the assigned Mathlib."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import urllib.request


HERE = Path(__file__).resolve().parent
VENDOR = HERE / "formal"
MANIFEST = json.loads((HERE / "formal_dependencies.json").read_text())


def source_path(module):
    if not re.fullmatch(r"OAI(?:\.[A-Za-z][A-Za-z0-9_]*)+", module):
        raise ValueError(f"Unexpected primary module: {module!r}")
    return VENDOR / (module.replace(".", "/") + ".lean")


def imports(text):
    return [
        name
        for line in text.splitlines()
        if re.match(r"^(?:public )?import ", line)
        for name in re.sub(r"^(?:public )?import ", "", line).split()
        if name.startswith("OAI.")
    ]


def fetch():
    pending = list(MANIFEST["roots"])
    seen = set()
    base = (
        "https://raw.githubusercontent.com/"
        f"{MANIFEST['repository']}/{MANIFEST['revision']}/"
        f"{MANIFEST['source_prefix']}/"
    )
    while pending:
        module = pending.pop()
        if module in seen:
            continue
        path = source_path(module)
        if path.exists():
            text = path.read_text()
        else:
            url = base + module.replace(".", "/") + ".lean"
            with urllib.request.urlopen(url, timeout=60) as response:
                text = response.read().decode("utf-8")
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text)
        seen.add(module)
        pending.extend(imports(text))
    license_path = VENDOR / "LICENSE"
    if not license_path.exists():
        with urllib.request.urlopen(base + "LICENSE", timeout=60) as response:
            license_path.write_bytes(response.read())
    print(json.dumps({"action": "fetch", "modules": len(seen), "revision": MANIFEST["revision"]}))


def build(target=None, force=False):
    order = []
    seen = set()
    visiting = set()

    def visit(module):
        if module in seen:
            return
        if module in visiting:
            raise ValueError(f"Import cycle at {module}")
        visiting.add(module)
        for dependency in imports(source_path(module).read_text()):
            visit(dependency)
        visiting.remove(module)
        seen.add(module)
        order.append(module)

    for root in ([target] if target else MANIFEST["roots"]):
        visit(root)
    workspace = Path(MANIFEST["mathlib_workspace"])
    actual = (workspace / "lean-toolchain").read_text().strip()
    if actual != MANIFEST["required_toolchain"]:
        raise RuntimeError(f"Wrong compiler workspace: {actual}")
    env = os.environ.copy()
    env["LEAN_PATH"] = str(VENDOR) + (os.pathsep + env["LEAN_PATH"] if env.get("LEAN_PATH") else "")
    with (HERE / "formal_build.log").open("a") as log:
        for index, module in enumerate(order, 1):
            source = source_path(module)
            output = source.with_suffix(".olean")
            inputs = [source] + [
                source_path(dependency).with_suffix(".olean")
                for dependency in imports(source.read_text())
            ]
            if not force and output.exists() and all(
                item.exists() and output.stat().st_mtime_ns >= item.stat().st_mtime_ns
                for item in inputs
            ):
                continue
            command = [
                "lake", "env", "lean", "--root", str(VENDOR),
                "-o", str(output), str(source),
            ]
            print(f"[{index}/{len(order)}] {module}", flush=True)
            log.write(json.dumps({"module": module, "command": command}) + "\n")
            log.flush()
            result = subprocess.run(command, cwd=workspace, env=env, text=True, stdout=log, stderr=log)
            if result.returncode:
                raise RuntimeError(
                    f"{module}: compiler exit {result.returncode}; see {HERE / 'formal_build.log'}"
                )
    if target is None:
        manifest = {
            "schema_version": 1,
            "repository": MANIFEST["repository"],
            "revision": MANIFEST["revision"],
            "toolchain": actual,
            "exit_code": 0,
            "modules": [
                {
                    "module": module,
                    "source": str(source_path(module).relative_to(HERE)),
                    "source_sha256": hashlib.sha256(source_path(module).read_bytes()).hexdigest(),
                    "olean": str(source_path(module).with_suffix(".olean").relative_to(HERE)),
                    "olean_sha256": hashlib.sha256(
                        source_path(module).with_suffix(".olean").read_bytes()
                    ).hexdigest(),
                    "imports": imports(source_path(module).read_text()),
                }
                for module in order
            ],
        }
        (HERE / "formal_build_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(json.dumps({"action": "build", "modules": len(order), "exit_code": 0, "toolchain": actual}))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("fetch", "build"))
    parser.add_argument("--target", help="Compile one module and its source dependency closure.")
    parser.add_argument("--force", action="store_true", help="Recompile every selected source.")
    args = parser.parse_args()
    if args.action == "fetch":
        if args.target or args.force:
            parser.error("--target and --force apply only to build")
        fetch()
    else:
        build(args.target, args.force)
