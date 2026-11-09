#!/usr/bin/env python3
"""Replay the pinned upstream theorem without creating or invoking Git."""

import argparse
import concurrent.futures
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tarfile
import time
import urllib.request


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
NATIVE = HERE / "native"
MATHLIB = NATIVE / "mathlib"
UPSTREAM = NATIVE / "upstream"
BOOTSTRAP = NATIVE / "build"
BUILD = NATIVE / "upstream_build"
LEAN = Path("$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.34.1/bin/lean")
REVISION = "4eaee87548250b2682affda7d05d947c05554bae"
IMPORT = re.compile(r"^(?:(?:public|private|meta)\s+)*import\s+(.+)$", re.M)


def output(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def imports(source):
    return [word for line in IMPORT.findall(source.read_text()) for word in line.split()
            if not word.startswith("--")]


def archive(repo_url, revision, destination):
    url = f"https://codeload.github.com/{repo_url.removeprefix('https://github.com/').removesuffix('.git')}/tar.gz/{revision}"
    target = destination.parent / f"{destination.name}.tar.gz"
    if not destination.exists():
        destination.mkdir(parents=True)
        urllib.request.urlretrieve(url, target)
        with tarfile.open(target) as bundle:
            for entry in bundle.getmembers():
                parts = Path(entry.name).parts[1:]
                if not parts or ".git" in parts:
                    continue
                entry.name = str(Path(*parts))
                bundle.extract(entry, destination, filter="data")
    return {"url": url, "revision": revision, "directory": str(destination.relative_to(ROOT))}


def closure(roots, source_roots):
    found = {}
    external = set()
    todo = list(roots)
    while todo:
        module = todo.pop()
        if module in found or module in external:
            continue
        candidates = [p / (module.replace(".", "/") + ".lean") for p in source_roots]
        source = next((p for p in candidates if p.is_file()), None)
        if source is None:
            external.add(module)
            continue
        found[module] = source
        todo.extend(imports(source))
    return found, external


def compile_modules(modules, source_roots, env, logdir, build, workers=4, rebuild=False):
    logdir.mkdir(parents=True, exist_ok=True)
    pending = dict(modules)
    completed = set()
    active = {}
    dependencies = {m: set(imports(p)) & modules.keys() for m, p in modules.items()}

    def compile_one(module, source):
        target = build / (module.replace(".", "/") + ".olean")
        target.parent.mkdir(parents=True, exist_ok=True)
        log = logdir / (module + ".log")
        prerequisites = [build / (m.replace(".", "/") + ".olean")
                         for m in dependencies[module]]
        if not rebuild and target.exists() and target.stat().st_mtime >= max(
                [source.stat().st_mtime, *(p.stat().st_mtime for p in prerequisites)]):
            return module
        with log.open("w") as stream:
            result = subprocess.run(
                [str(LEAN), "-o", str(target), str(source)],
                cwd=max((p for p in source_roots if source.is_relative_to(p)),
                        key=lambda p: len(p.parts)),
                env=env, stdout=stream, stderr=subprocess.STDOUT,
            )
        if result.returncode:
            raise RuntimeError(f"Compilation failed: {module}; see {log.relative_to(ROOT)}\n{log.read_text()[-5000:]}")
        return module

    with concurrent.futures.ThreadPoolExecutor(max_workers=workers) as pool:
        while pending or active:
            for module in list(pending):
                if len(active) >= workers:
                    break
                if dependencies[module] <= completed:
                    source = pending.pop(module)
                    active[pool.submit(compile_one, module, source)] = module
            if not active:
                raise RuntimeError(f"Unresolved compilation dependencies: {list(pending)[:8]}")
            done, _ = concurrent.futures.wait(active, return_when=concurrent.futures.FIRST_COMPLETED)
            for future in done:
                completed.add(future.result())
                del active[future]
            if len(completed) % 25 == 0 or not pending:
                print(f"Compiled {len(completed)}/{len(modules)} modules", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rebuild", action="store_true",
                        help="recompile every upstream proof module, retaining the pinned library cache")
    args = parser.parse_args()
    started = time.monotonic()
    NATIVE.mkdir(parents=True, exist_ok=True)
    BUILD.mkdir(parents=True, exist_ok=True)
    version = subprocess.check_output([str(LEAN), "--version"], text=True).strip()
    if "version 4.34.1," not in version:
        raise RuntimeError(f"Wrong native compiler: {version}")
    dependencies = []
    manifest = json.loads((MATHLIB / "lake-manifest.json").read_text())
    packages = []
    for package in manifest["packages"]:
        destination = MATHLIB / ".lake/packages" / package["name"]
        dependencies.append(archive(package["url"], package["rev"], destination))
        packages.append(destination / package["subDir"] if package.get("subDir") else destination)

    env = os.environ.copy()
    env["PATH"] = str(LEAN.parent) + os.pathsep + env["PATH"]
    env["LEAN_SRC_PATH"] = os.pathsep.join(map(str, [MATHLIB, *packages]))
    libraries = [MATHLIB / ".lake/build/lib/lean"]
    libraries += [p / ".lake/build/lib/lean" for p in packages]
    env["LEAN_PATH"] = os.pathsep.join(map(str, [BOOTSTRAP, *libraries]))
    env["MATHLIB_CACHE_DIR"] = str(NATIVE / "cache")
    env["MATHLIB_CACHE_FROM"] = "master"
    bootstrap, external = closure(["Cache.Requests"], [MATHLIB, *packages])
    unresolved = [m for m in external if not m.startswith(("Lean", "Lake", "Std", "Init"))]
    if unresolved:
        raise RuntimeError(f"Missing cache bootstrap sources: {unresolved}")
    compile_modules(bootstrap, [MATHLIB, *packages], env, NATIVE / "cache_compile_logs", BOOTSTRAP)
    if not (MATHLIB / ".lake/build/lib/lean/Mathlib.olean").exists():
        with (NATIVE / "cache_fetch.log").open("w") as log:
            subprocess.run([str(LEAN), "--run", str(HERE / "CacheFetch.lean")],
                           cwd=MATHLIB, env=env, stdout=log, stderr=subprocess.STDOUT, check=True)
    if not (MATHLIB / ".lake/build/lib/lean/Mathlib.olean").exists():
        raise RuntimeError("The exact pinned Mathlib cache did not provide Mathlib.olean")

    sources, external = closure(["OAI.Combinatorics.BalancedRyser.Results"], [UPSTREAM])
    if any(not m.startswith("Mathlib") for m in external):
        raise RuntimeError(f"Unexpected external upstream imports: {sorted(external)}")
    listing = json.loads(subprocess.check_output(
        ["gh", "api", f"repos/openai/math/contents/lean/OAI/Combinatorics?ref={REVISION}"], text=True))
    tree_id = next(x["sha"] for x in listing if x["name"] == "BalancedRyser")
    tree = json.loads(subprocess.check_output(
        ["gh", "api", f"repos/openai/math/git/trees/{tree_id}?recursive=1"], text=True))
    if tree.get("truncated"):
        raise RuntimeError("Upstream source tree listing is truncated")
    blobs = {x["path"]: x["sha"] for x in tree["tree"] if x["type"] == "blob"}
    source_binding = {}
    for module, source in sources.items():
        relative = source.relative_to(UPSTREAM)
        if not str(relative).startswith("OAI/Combinatorics/BalancedRyser/"):
            raise RuntimeError(f"Source outside the pinned subtree: {relative}")
        data = source.read_bytes()
        digest = hashlib.sha1(f"blob {len(data)}\0".encode() + data).hexdigest()
        key = str(relative.relative_to("OAI/Combinatorics/BalancedRyser"))
        if blobs.get(key) != digest:
            raise RuntimeError(f"Project source differs from pinned public source: {relative}")
        source_binding[module] = digest
    output(NATIVE / "source_binding.json", {"revision": REVISION, "blobs": source_binding})
    env["LEAN_PATH"] = os.pathsep.join(map(str, [BUILD, *libraries]))
    env["LEAN_SRC_PATH"] = os.pathsep.join(map(str, [UPSTREAM, MATHLIB, *packages]))
    compile_modules(sources, [UPSTREAM], env, NATIVE / "upstream_compile_logs", BUILD,
                    rebuild=args.rebuild)
    command = [str(LEAN), str(HERE / "NativeMain.lean")]
    result = subprocess.run(command, cwd=UPSTREAM, env=env, text=True, capture_output=True)
    (NATIVE / "main_stdout.txt").write_text(result.stdout)
    (NATIVE / "main_stderr.txt").write_text(result.stderr)
    axioms = re.search(r"depends on axioms:\s*\[([^\]]*)\]", result.stdout)
    if not axioms:
        raise RuntimeError(f"No transitive axiom answer:\n{result.stdout}\n{result.stderr}")
    axiom_list = [a.strip() for a in axioms.group(1).split(",") if a.strip()]
    if result.returncode or set(axiom_list) - {"propext", "Classical.choice", "Quot.sound"}:
        raise RuntimeError(f"Native replay or foundational-axiom gate failed: {result.returncode}, {axiom_list}")
    output(HERE / "native_replay_result.json", {
        "status": "verified",
        "compiler": version,
        "command": command,
        "cwd": str(UPSTREAM),
        "exit_code": result.returncode,
        "axioms": axiom_list,
        "upstream_revision": REVISION,
        "source_count": len(sources),
        "source_binding": "research/balanced_certification/native/source_binding.json",
        "dependencies": dependencies,
        "elapsed_seconds": time.monotonic() - started,
    })
    print("Native balanced theorem and transitive axiom gate verified.", flush=True)


if __name__ == "__main__":
    main()
