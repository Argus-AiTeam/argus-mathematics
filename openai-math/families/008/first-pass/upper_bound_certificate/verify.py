#!/usr/bin/env python3
"""Replay the manuscript upper bound without rebuilding the upstream library."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
UPSTREAM = Path("openai-math/lean")
WORKSPACE = HERE / ".lake/packages/mathlib"
LEAN = Path("$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.34.1/bin/lean")
ARGUS_PYTHON = Path("$WORKSPACE/argus-live-update/.venv/bin/python")
TARGET = "OAI.Algebra.Drinfeld.Ihara"
BUILD = HERE / "build"
UPSTREAM_REVISION = "4eaee87548250b2682affda7d05d947c05554bae"
MATHLIB_REVISION = "d13f23b723b8a846827a245b89c10fc7d3f11612"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path, value):
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def source_imports(path):
    imports = []
    for line in path.read_text().splitlines():
        match = re.fullmatch(r"\s*(?:public\s+)?import\s+([^/]+?)\s*", line)
        if match:
            imports.extend(match.group(1).split())
    return imports


def source_closure():
    ordered = []
    seen = set()

    def visit(module):
        if module in seen or not module.startswith("OAI."):
            return
        seen.add(module)
        path = UPSTREAM / (module.replace(".", "/") + ".lean")
        text = path.read_text()
        imports = source_imports(path)
        for dependency in imports:
            visit(dependency)
        ordered.append({
            "module": module,
            "source": str(path),
            "source_sha256": digest(path),
            "imports": imports,
            "lines": len(text.splitlines()),
        })

    visit(TARGET)
    return ordered


def compiler_environment():
    env = os.environ.copy()
    manifest = json.loads((WORKSPACE / "lake-manifest.json").read_text())
    packages = [WORKSPACE / ".lake/packages" / item["name"]
                for item in manifest["packages"]]
    env["LEAN_PATH"] = os.pathsep.join(map(str, [
        BUILD, WORKSPACE / ".lake/build/lib/lean",
        *(p / ".lake/build/lib/lean" for p in packages),
        LEAN.parent.parent / "lib/lean",
    ]))
    env["LEAN_SRC_PATH"] = os.pathsep.join(map(str, [WORKSPACE, *packages]))
    env["PATH"] = str(LEAN.parent) + os.pathsep + env["PATH"]
    env["MATHLIB_CACHE_DIR"] = str(HERE / ".lake/cache")
    env["ARGUS_SKILL_MATHLIB_WORKSPACE"] = str(WORKSPACE)
    return env


def restore_mathlib():
    archives = HERE / "dependencies"
    archives.mkdir(exist_ok=True)
    if not (WORKSPACE / "lake-manifest.json").is_file():
        archive = archives / "mathlib4-434.tar.gz"
        url = f"https://codeload.github.com/leanprover-community/mathlib4/tar.gz/{MATHLIB_REVISION}"
        command = ["curl", "--silent", "--show-error", "--location",
                   "--fail-with-body", "--max-time", "90", url,
                   "--output", str(archive)]
        result = subprocess.run(command, check=False)
        if result.returncode:
            return result.returncode
        WORKSPACE.mkdir(parents=True, exist_ok=True)
        result = subprocess.run(
            ["tar", "-xzf", str(archive), "--strip-components=1",
             "--no-same-owner", "--directory", str(WORKSPACE)], check=False,
        )
        if result.returncode:
            return result.returncode
    manifest = json.loads((WORKSPACE / "lake-manifest.json").read_text())
    restore = {"mathlib_revision": MATHLIB_REVISION, "packages": [],
               "completed": False, "git_invoked": False}
    for package in manifest["packages"]:
        target = WORKSPACE / ".lake/packages" / package["name"]
        url = package["url"].removeprefix("https://github.com/").removesuffix(".git")
        archive_url = f"https://codeload.github.com/{url}/tar.gz/{package['rev']}"
        archive = archives / (package["name"] + ".tar.gz")
        target.mkdir(parents=True, exist_ok=True)
        command = ["curl", "--silent", "--show-error", "--location",
                   "--fail-with-body", "--max-time", "60", archive_url,
                   "--output", str(archive)]
        result = subprocess.run(command, check=False)
        entry = {"name": package["name"], "revision": package["rev"],
                 "url": archive_url, "download_exit_code": result.returncode}
        restore["packages"].append(entry)
        write_json(HERE / "dependency_restore.json", restore)
        if result.returncode:
            return result.returncode
        command = ["tar", "-xzf", str(archive), "--strip-components=1",
                   "--no-same-owner", "--directory", str(target)]
        result = subprocess.run(command, check=False)
        entry["extract_exit_code"] = result.returncode
        write_json(HERE / "dependency_restore.json", restore)
        if result.returncode:
            return result.returncode
        print("Restored " + package["name"], flush=True)

    ordered = []
    seen = set()

    def visit(module):
        if module in seen or module.split(".")[0] in ("Lean", "Lake", "Std", "Init"):
            return
        seen.add(module)
        if module.startswith("Cache."):
            root = WORKSPACE
        elif module.startswith("Batteries."):
            root = WORKSPACE / ".lake/packages/batteries"
        else:
            raise RuntimeError("Unexpected cache-helper dependency: " + module)
        source = root / (module.replace(".", "/") + ".lean")
        for dependency in source_imports(source):
            visit(dependency)
        ordered.append((module, root, source))

    visit("Cache.Requests")
    for module, root, source in ordered:
        output = root / ".lake/build/lib/lean" / (module.replace(".", "/") + ".olean")
        output.parent.mkdir(parents=True, exist_ok=True)
        command = [str(LEAN), "--root=" + str(root), "-o", str(output), str(source)]
        result = subprocess.run(command, cwd=WORKSPACE, env=compiler_environment(),
                                check=False)
        if result.returncode:
            return result.returncode
        print("Built cache helper " + module, flush=True)
    command = [str(LEAN), "--run", str(HERE / ".lake/RestoreCache.lean")]
    result = subprocess.run(command, cwd=WORKSPACE, env=compiler_environment(),
                            check=False)
    restore["cache_command"] = command
    restore["cache_exit_code"] = result.returncode
    restore["cache_helper_modules"] = [module for module, _, _ in ordered]
    restore["completed"] = result.returncode == 0
    write_json(HERE / "dependency_restore.json", restore)
    return result.returncode


def pin_upstream_sources(modules):
    pin = {"repository": "openai/math", "revision": UPSTREAM_REVISION, "modules": []}
    for module in modules:
        relative = module["module"].replace(".", "/") + ".lean"
        target = HERE / ".lake/source_pin" / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        url = f"https://raw.githubusercontent.com/openai/math/{UPSTREAM_REVISION}/lean/{relative}"
        command = ["curl", "--silent", "--show-error", "--location",
                   "--fail-with-body", "--max-time", "30", url,
                   "--output", str(target)]
        result = subprocess.run(command, check=False)
        if result.returncode:
            raise RuntimeError("Pinned upstream source retrieval failed: " + relative)
        matches = digest(target) == module["source_sha256"]
        pin["modules"].append({"module": module["module"], "url": url,
                               "source_sha256": digest(target), "matches_local": matches})
        write_json(HERE / "upstream_source_pin.json", pin)
        if not matches:
            raise RuntimeError("Local source differs from the pinned upstream revision")


def prepare():
    BUILD.mkdir(parents=True, exist_ok=True)
    logs = HERE / "build_logs"
    logs.mkdir(exist_ok=True)
    modules = source_closure()
    pin_upstream_sources(modules)
    receipt = {
        "target": TARGET,
        "upstream_declared_toolchain": (UPSTREAM / "lean-toolchain").read_text().strip(),
        "workspace": str(WORKSPACE),
        "compiler_version": subprocess.check_output(
            [str(LEAN), "--version"], cwd=WORKSPACE, text=True
        ).strip(),
        "modules": modules,
        "completed": False,
    }
    write_json(HERE / "build_receipt.json", receipt)
    print(f"Minimal closure: {len(modules)} OAI modules, "
          f"{sum(m['lines'] for m in modules)} source lines", flush=True)
    for module in modules:
        output = BUILD / (module["module"].replace(".", "/") + ".olean")
        output.parent.mkdir(parents=True, exist_ok=True)
        log = logs / (module["module"] + ".log")
        command = [
            str(LEAN), "--root=" + str(UPSTREAM),
            "-o", str(output), module["source"],
        ]
        started = time.monotonic()
        with log.open("w") as stream:
            result = subprocess.run(
                command, cwd=WORKSPACE, env=compiler_environment(),
                stdout=stream, stderr=subprocess.STDOUT, check=False,
            )
        module.update({
            "command": command,
            "cwd": str(WORKSPACE),
            "exit_code": result.returncode,
            "elapsed_seconds": round(time.monotonic() - started, 3),
            "log": str(log.relative_to(ROOT)),
        })
        if digest(Path(module["source"])) != module["source_sha256"]:
            raise RuntimeError("An upstream source changed during compilation")
        if result.returncode == 0:
            module["olean"] = str(output.relative_to(ROOT))
            module["olean_sha256"] = digest(output)
        write_json(HERE / "build_receipt.json", receipt)
        print(f"{module['module']}: exit={result.returncode}, "
              f"seconds={module['elapsed_seconds']}", flush=True)
        if result.returncode:
            print("\n".join(log.read_text().splitlines()[-24:]), flush=True)
            return result.returncode
    receipt["completed"] = True
    write_json(HERE / "build_receipt.json", receipt)
    return 0


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for word, coefficient in polynomial.items():
            result[word] = result.get(word, 0) + coefficient
    return {word: value for word, value in result.items() if value}


def scale(coefficient, polynomial):
    return {word: coefficient * value for word, value in polynomial.items()
            if coefficient * value}


def multiply(left, right):
    result = {}
    for u, a in left.items():
        for v, b in right.items():
            result[u + v] = result.get(u + v, 0) + a * b
    return {word: value for word, value in result.items() if value}


def bracket(left, right):
    return add(multiply(left, right), scale(-1, multiply(right, left)))


def source_action_checks():
    x = {"X": 1}
    u = {i: {i: 1} for i in ("i", "j", "k")}
    h = multiply(x, x)
    v = {i: bracket(x, u[i]) for i in u}

    def derivation(polynomial, images):
        result = {}
        for word, coefficient in polynomial.items():
            for position, letter in enumerate(word):
                for replacement, value in images.get(letter, {}).items():
                    target = word[:position] + replacement + word[position + 1:]
                    result[target] = result.get(target, 0) + coefficient * value
        return result

    def delta(polynomial):
        return derivation(polynomial, {"X": v["i"], "i": v["i"]})

    def epsilon(polynomial):
        value = bracket(u["i"], u["j"])
        return derivation(polynomial, {"i": value, "j": value})

    def action_a(polynomial):
        return delta(delta(polynomial))

    def action_v(polynomial):
        return add(delta(epsilon(polynomial)), epsilon(delta(polynomial)))

    r = {i: bracket(h, u[i]) for i in u}
    q = bracket(add(h, v["i"]), u["i"])
    w = add(bracket(v["i"], u["j"]), bracket(u["i"], v["j"]))
    expected_a = {
        "H": add(bracket(h, v["i"]), bracket(r["i"], u["i"])),
        "Ui": q,
        "Uj": {},
        "Uk": {},
        "Vi": add(bracket(h, v["i"]),
                  bracket(bracket(v["i"], u["i"]), u["i"])),
        "Vj": bracket(q, u["j"]),
        "Vk": bracket(q, u["k"]),
    }
    expected_u = {
        "H": {},
        "Ui": bracket(u["i"], u["j"]),
        "Uj": bracket(u["i"], u["j"]),
        "Uk": {},
        "Vi": w,
        "Vj": w,
        "Vk": {},
    }
    expected_v = {
        "H": bracket(h, bracket(u["i"], u["j"])),
        "Ui": bracket(u["i"], v["j"]),
        "Uj": bracket(u["j"], v["i"]),
        "Uk": {},
        "Vi": add(bracket(v["i"], v["j"]), bracket(w, u["i"]),
                  bracket(u["i"], r["j"])),
        "Vj": add(bracket(v["i"], v["j"]), bracket(w, u["j"]),
                  bracket(u["j"], r["i"])),
        "Vk": bracket(w, u["k"]),
    }
    inputs = {"H": h, **{"U" + i: u[i] for i in u},
              **{"V" + i: v[i] for i in v}}
    identities = []
    for label, action, expected in (
        ("source-a", action_a, expected_a),
        ("source-u", epsilon, expected_u),
        ("source-v", action_v, expected_v),
    ):
        for name, value in inputs.items():
            residual = add(action(value), scale(-1, expected[name]))
            residual = {word: coefficient % 2 for word, coefficient in residual.items()
                        if coefficient % 2}
            if residual:
                raise AssertionError(f"{label}:{name} has residual {residual}")
            identities.append(label + ":" + name)
    return {
        "coefficient_field": "F_2",
        "free_associative_fiber_generators": ["X", "i", "j", "k"],
        "identities": identities,
        "count": len(identities),
        "scope": "Exact noncommutative polynomial identities for all source table index types.",
    }


def exact_boundary_checks():
    edges = {edge: {edge: 1} for edge in ("12", "13", "14", "23", "24", "34")}

    def pentagon(p):
        return add(
            p(edges["12"], add(edges["23"], edges["24"])),
            p(add(edges["13"], edges["23"]), edges["34"]),
            scale(-1, p(edges["23"], edges["34"])),
            scale(-1, p(add(edges["12"], edges["13"]),
                        add(edges["24"], edges["34"]))),
            scale(-1, p(edges["12"], edges["23"])),
        )

    residual_x = pentagon(lambda x, y: x)
    residual_y = pentagon(lambda x, y: y)
    if residual_x != {"12": -1} or residual_y != {"34": -1}:
        raise AssertionError("Degree-one pentagon or orientation is incorrect")
    x, y = {"x": 1}, {"y": 1}
    degree_two_words = [bracket(a, b) for a in (x, y) for b in (x, y)]
    if degree_two_words != [{}, bracket(x, y), scale(-1, bracket(x, y)), {}]:
        raise AssertionError("The ordinary degree-two bracket spanning list failed")
    z = scale(-1, add(x, y))
    degree_two = add(bracket(x, y), bracket(y, z), bracket(z, x))
    if degree_two != scale(3, bracket(x, y)):
        raise AssertionError("Degree-two three-term equation is incorrect")
    a, b = {"A": 1}, {"B": 1}
    residual_lie = bracket(b, bracket(a, b))
    mod_two = {word: value % 2 for word, value in residual_lie.items() if value % 2}
    words = ("ABB", "BAB", "BBA")
    payload = {"matrix": {
        "prime": 2, "columns": 2,
        "entries": [[mod_two.get(word, 0), 1] for word in words],
    }}
    if payload != json.loads((HERE / "jacobian_payload.json").read_text()):
        raise AssertionError("Jacobian payload is not bound to the Lie calculation")
    return {
        "weight_zero": "No positive-generator free-Lie monomial has weight zero.",
        "weight_one_pentagon_columns": [residual_x, residual_y],
        "weight_two_all_generator_brackets": degree_two_words,
        "weight_two_three_term": degree_two,
        "ordinary_lie_boundary_basis": words,
        "ordinary_lie_boundary_coefficients_mod_2": [
            mod_two.get(word, 0) for word in words
        ],
        "jacobian_payload": payload,
        "scope": "Exact low-weight and residual-kernel boundary checks only.",
    }


def verify():
    boundary = exact_boundary_checks()
    actions = source_action_checks()
    adapter_status = json.loads((HERE / "jacobian_status.json").read_text())
    adapter = json.loads((HERE / "jacobian_output.json").read_text())
    output = adapter["result"]["output"]
    if adapter_status["exit_code"] != 0:
        raise RuntimeError("Jacobian failed or timed out; its output is not evidence")
    if (adapter["result"]["operation_id"] != "prime_field.matrix.rank.compute"
            or output["source"] != boundary["jacobian_payload"]
            or output["prime"] != 2 or output["rank"] != 2):
        raise AssertionError("Jacobian output does not certify the submitted matrix")
    matrix = boundary["jacobian_payload"]["matrix"]["entries"]
    minor = (matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]) % 2
    if minor != 1:
        raise AssertionError("Independent rank-two minor failed")
    receipt = json.loads((HERE / "build_receipt.json").read_text())
    if not receipt["completed"]:
        raise RuntimeError("The upstream proof closure has not compiled")
    for module in receipt["modules"]:
        if digest(Path(module["source"])) != module["source_sha256"]:
            raise RuntimeError("The upstream source no longer matches its compile")
        if digest(ROOT / module["olean"]) != module["olean_sha256"]:
            raise RuntimeError("A compiled dependency no longer matches its receipt")
    command = [
        str(ARGUS_PYTHON), "-m", "argus_skill.verticals.math.lean_evidence",
        "verify", str(HERE / "Main.lean"), "--statement-fidelity",
        str(HERE / "statement_fidelity.md"), "--claim", "C_UB_GT2",
        "--project-root", str(ROOT), "--artifact-dir", str(HERE),
        "--lean-bin", str(LEAN), "--no-lake", "--timeout", "300",
    ]
    with (HERE / "argus_result.json").open("w") as stream:
        result = subprocess.run(command, cwd=ROOT, env=compiler_environment(),
                                stdout=stream, check=False)
    lean = json.loads((HERE / "argus_result.json").read_text())
    axioms_match = re.search(
        r"Audit9000008\.upper_bound_gt_two'?\s+depends on axioms:\s*\[([^\]]*)\]",
        lean.get("stdout", ""),
    )
    axioms = ([item.strip() for item in axioms_match.group(1).split(",")
               if item.strip()] if axioms_match else None)
    allowed = {"propext", "Classical.choice", "Quot.sound"}
    validation = {"project_root": str(ROOT)}
    for name in ("math_state", "proof_graph_check"):
        check_command = [str(ARGUS_PYTHON), "-m",
                         "argus_skill.verticals.math." + name, "check",
                         "--project-root", str(ROOT)]
        with (HERE / (name + "_check.json")).open("w") as stream:
            check = subprocess.run(check_command, cwd=ROOT, stdout=stream, check=False)
        validation[name + "_exit_code"] = check.returncode
    write_json(HERE / "validation.json", validation)
    kernel = lean["kernel"]
    bindings = {
        "source_unchanged": lean.get("source_sha256") == digest(HERE / "Main.lean"),
        "statement_fidelity_unchanged": lean.get("statement_fidelity_sha256")
        == digest(HERE / "statement_fidelity.md"),
    }
    success = (
        result.returncode == 0 and lean.get("status") == "success"
        and lean.get("exit_code") == 0 and lean.get("audit_exit_code") == 0
        and lean.get("proof_holes") == [] and axioms is not None
        and set(axioms) <= allowed
        and bool(kernel.get("recorded")) and not kernel.get("refusals")
        and all(bindings.values())
        and validation["math_state_exit_code"] == 0
        and validation["proof_graph_check_exit_code"] == 0
    )
    certificate = {
        "theorem": "For every n in N, dim_Q W_n <= dim_Q FreeLie_Q(e_3,e_5,...)_n, wt(e_j)=j.",
        "status": "engineer_verified_pending_independent_review" if success else "unverified",
        "all_weights": success,
        "proof_cases": {
            "n_greater_than_two": "Audit9000008.upper_bound_gt_two",
            "n_zero_one_two": boundary,
        },
        "source_action_identities": actions,
        "upstream_revision": UPSTREAM_REVISION,
        "mathlib_revision": MATHLIB_REVISION,
        "upstream_source_pin": "research/upper_bound_certificate/upstream_source_pin.json",
        "compiler_version": receipt["compiler_version"],
        "lean_command": command,
        "lean_evidence_exit_code": result.returncode,
        "lean_status": lean.get("status"),
        "kernel_recording": kernel,
        "bindings": bindings,
        "proof_holes": lean.get("proof_holes"),
        "axioms": axioms,
        "lean_result": "research/upper_bound_certificate/argus_result.json",
        "build_receipt": "research/upper_bound_certificate/build_receipt.json",
        "source_sha256": digest(HERE / "Main.lean"),
        "statement_fidelity_sha256": digest(HERE / "statement_fidelity.md"),
        "jacobian": {"server": adapter["server"], "protocol_version": adapter["protocol_version"],
                     "operation_id": adapter["result"]["operation_id"],
                     "adapter_exit_code": adapter_status["exit_code"],
                     "timed_out": adapter_status["exit_code"] == 124,
                     "rank": output["rank"], "independent_minor_mod_2": minor},
        "validation": validation,
        "independent_review": {"required": True, "completed": False},
        "novelty": "Not asserted by the Engineer; this is a replay of the upstream universal proof.",
    }
    write_json(HERE / "exact_certificate.json", certificate)
    print(json.dumps({"status": certificate["status"], "all_weights": success,
                      "lean_evidence_exit_code": result.returncode, "axioms": axioms,
                      "validation": validation}, indent=2))
    return 0 if success else 1


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--prepare", action="store_true")
    group.add_argument("--restore-mathlib", action="store_true")
    args = parser.parse_args()
    if args.restore_mathlib:
        return restore_mathlib()
    return prepare() if args.prepare else verify()


if __name__ == "__main__":
    sys.exit(main())
