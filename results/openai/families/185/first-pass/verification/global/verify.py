#!/usr/bin/env python3
"""Replay the unconditional global proof, preserving the approved analytic core."""

import argparse
from datetime import datetime, timezone
from fractions import Fraction
import hashlib
import itertools
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import time


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
BASE = ROOT / "research/verification"
UPSTREAM = HERE / "upstream"
COMPILED = BASE / "compiled_sources"
LIB = HERE / "lib"
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
COMMIT = "4eaee87548250b2682affda7d05d947c05554bae"
PREFIX = "OAI.Combinatorics.InfiniteMatroid."
APPROVED = {
    "Basic", "BlockDensity", "Cesaro", "ProbeLimits",
    "SparsePerturbation", "Interpolation", "LocalBases", "BasisExtension",
}
BLOBS = {
    "Basic": "e8754872743fcfb47aef636a5a3913700a2cef38",
    "BasisExtension": "1aca156aeb59ef7a9203514f57452fb7c0c0b102",
    "BlockDensity": "5af8d03a8fecc9561fed69ed803762152e840b1e",
    "Cardinality": "301fcb9eaf488b85a71f0b848e96a80a5735c155",
    "Cesaro": "8a1e0a5ffa0ed717817b62c1c6b858f52b0680b9",
    "Columns": "7e8355df3c04ffabeb8429fefafebdcf55a546a5",
    "DensityIdeal": "d26bb7b34ab4d6933822da6bb9739ccd2e3cf0ab",
    "DoubleRay": "f3a0e6dccae834666cb5314111bc11576cd3e5aa",
    "FiniteCounting": "0e4c6badb8013a4f342452dd4962553653f11a21",
    "Ideals": "f405abd2098a4bda70b3bc927139df4734382647",
    "Interpolation": "8a77c1bd534035944bb6664ac96c3de3dd2f5ff9",
    "LocalBases": "7ddc402359b79a2a99988404fbb2212b69e3e0b7",
    "Main": "83f4d579908a794de66d79bfcf81377492b63d00",
    "Matroid": "433ede2d7132357bc1fe205acb8a588a7f4cc2da",
    "OrdinalRank": "8f4f8edcc72e5da281b2c1ea2f35aa8cfcb4d10e",
    "PackingCovering": "fc60f7913cdfffff405b2284a520cd6b3fa8f673",
    "ProbeLimits": "1010b17ef949c978968075987e55fe5b0ca49cc0",
    "Prototype": "63c800ada9088a118698047f0560ef194bd6aa7a",
    "PrototypeExtension": "e6c097c01eed84b89528a2f65c59df4787ead03b",
    "RankDescent": "387c0c4ca8d5d94976fb5a3b8e08d98bd46c22dd",
    "Reservations": "01c3d537e539395cc4d3fd61ac17515100399525",
    "Separation": "63f20e5b09b8c3b8f7830e93eb9b64e297b0b00e",
    "SparsePerturbation": "43c413a813b00d7d5f7471599356cea645bf7abc",
    "TransfiniteConstruction": "df1e4d33692a4a7365b8eec039eef02a490dbf6d",
    "Zones": "cb0b919c40cd76becf6d8c14d9584ca38c8ca22a",
}
LOCAL_TARGETS = (
    "concrete_rank_certificate", "reservation_certificate", "unconditional_local_matroid",
    "contraction_onto_bridge", "packing_covering_bridge", "orientation_bridge", "manuscript_main",
)
UPSTREAM_TARGETS = (
    "finite_union_small", "columns_pattern", "exists_rank_ultrafilter",
    "ordinalRank_thinning", "simultaneous_reservations",
    "RankModel.exists_complete_prototypes", "BasisSystem.exists_maximal",
    "independent_rank_step", "no_independent_cover", "independent_cover_of_packing_covering",
)
TARGETS = tuple("Manuscript185Global." + n for n in LOCAL_TARGETS) + tuple(
    "OAI.InfiniteMatroidCounterexample." + n for n in UPSTREAM_TARGETS
)


def run(command, *, cwd=ROOT, env=None, log=None):
    result = subprocess.run(command, cwd=cwd, env=env, text=True, capture_output=True)
    if log is not None:
        log.write_text(result.stdout + result.stderr)
    if result.returncode:
        raise RuntimeError(
            f"Command failed ({result.returncode}): {command!r}\n"
            f"{result.stdout}{result.stderr}"
        )
    return result.stdout


def write_json(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def check_ledgers():
    checks = []
    for module in ("math_state", "proof_graph_check"):
        result = subprocess.run(
            [PYTHON, "-m", "argus_skill.verticals.math." + module,
             "check", "--project-root", str(ROOT)],
            cwd=ROOT, text=True, capture_output=True,
        )
        checks.append({
            "module": module, "exit_code": result.returncode,
            "output": result.stdout + result.stderr,
        })
    record = {"project_root": str(ROOT), "checks": checks}
    write_json(HERE / "ledger_checks.json", record)
    if any(c["exit_code"] for c in checks):
        raise RuntimeError(json.dumps(record))
    return record


def compiler():
    lean = run(["lake", "env", "which", "lean"], cwd=WORKSPACE).strip()
    paths = run(["lake", "env", "printenv", "LEAN_PATH"], cwd=WORKSPACE).strip()
    env = dict(os.environ, LEAN_PATH=os.pathsep.join((str(LIB), str(BASE / "lib"), paths)))
    version = run([lean, "--version"], env=env).strip()
    assert re.search(r"version 4\.31\.0,", version), version
    return lean, env, version


def source_order():
    order, visiting = [], set()

    def visit(name):
        if name in order:
            return
        assert name not in visiting, f"Import cycle: {name}"
        visiting.add(name)
        data = (UPSTREAM / (name + ".lean")).read_bytes()
        digest = hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest()
        assert digest == BLOBS[name], f"Unpinned source: {name}"
        assert not re.search(rb"\b(sorry|admit|axiom)\b", data), name
        for imported in re.findall(r"^import (\S+)", data.decode(), re.MULTILINE):
            if imported == "Mathlib":
                continue
            assert imported.startswith(PREFIX), imported
            visit(imported.removeprefix(PREFIX))
        visiting.remove(name)
        order.append(name)

    visit("Main")
    assert set(order) == set(BLOBS), "The pinned import closure changed"
    return order


def build(lean, env):
    approved_certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    assert approved_certificate["claim"] == "C_LOCAL_INTERVALS"
    assert approved_certificate["exit_code"] == 0
    assert approved_certificate["proof_holes"] == []
    records = []
    previous_path = HERE / "upstream_build.json"
    previous = {
        r["module"]: r for r in json.loads(previous_path.read_text())
    } if previous_path.is_file() else {}
    rebuilt = set()
    for name in source_order():
        original = (UPSTREAM / (name + ".lean")).read_bytes()
        relative = Path("OAI/Combinatorics/InfiniteMatroid") / (name + ".lean")
        if name in APPROVED:
            assert (BASE / relative).read_bytes() == original
            approved_object = BASE / "lib" / relative.with_suffix(".olean")
            assert approved_object.is_file()
            output = LIB / relative.with_suffix(".olean")
            output.parent.mkdir(parents=True, exist_ok=True)
            if output.is_file():
                assert output.read_bytes() == approved_object.read_bytes(), name
            else:
                shutil.copyfile(approved_object, output)
            records.append({
                "module": name, "pinned_blob": BLOBS[name],
                "status": "reused_approved_analytic_module",
            })
            continue
        edits = []
        data = original
        for old, new in (
            (b"Set.mem_ofPred_eq", b"Set.mem_setOf_eq"),
            (b"dite_eq_left", b"dif_pos"),
            (b"ite_eq_left", b"if_pos"),
            (b"WellFoundedLT.min_le", b"WellFounded.min_le wellFounded_lt"),
        ):
            count = data.count(old)
            if count:
                data = data.replace(old, new)
                edits.append({"from": old.decode(), "to": new.decode(), "occurrences": count})
        source = COMPILED / relative
        source.parent.mkdir(parents=True, exist_ok=True)
        output = LIB / relative.with_suffix(".olean")
        output.parent.mkdir(parents=True, exist_ok=True)
        dependencies = {
            n.removeprefix(PREFIX) for n in re.findall(
                r"^import (\S+)", original.decode(), re.MULTILINE
            )
        }
        prior = previous.get(name)
        if (prior is not None and prior.get("exit_code") == 0
                and prior.get("compatibility_identifier_rewrites") == edits
                and source.is_file() and source.read_bytes() == data
                and output.is_file() and not dependencies.intersection(rebuilt)):
            records.append(dict(prior, reused_completed_compile=True))
            continue
        source.write_bytes(data)
        start = time.monotonic()
        run([lean, "--root=" + str(COMPILED), "-o", str(output), str(source)],
            env=env, log=HERE / (name + ".compile.log"))
        records.append({
            "module": name, "pinned_blob": BLOBS[name], "exit_code": 0,
            "elapsed_seconds": round(time.monotonic() - start, 3),
            "compatibility_identifier_rewrites": edits,
        })
        rebuilt.add(name)
        write_json(HERE / "upstream_build.json", records)
        print("Compiled global " + name, flush=True)
    write_json(HERE / "upstream_build.json", records)
    return records


def finite_checks():
    count = 0
    for q in range(7):
        for signs in itertools.product((False, True), repeat=q):
            avoiding = 0
            for bits in itertools.product((False, True), repeat=2 * q):
                avoiding += all(bits[2*i] or bits[2*i+1] != signs[i] for i in range(q))
            assert avoiding == 3 ** q
            assert Fraction(avoiding, 4 ** q) == Fraction(3, 4) ** q
            count += 1
    patterns = 0
    for a, b in itertools.product((False, True), repeat=2):
        cells = (not a and not b, not a and b)
        assert not all(cells)
        assert not any(cells) or not a
        patterns += 1
    response = json.loads((HERE / "jacobian_output.json").read_text())
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    assert response["request"]["operation_id"] == "sat.assignment.check"
    assert response["request"]["payload"] == payload
    assert response["server"]["version"] == "0.14.0"
    assert response["protocol_version"] == "2025-11-25"
    assert response["result"]["output"]["satisfies"] is True
    assert payload == {
        "cnf": {"variables": ["a", "b"], "clauses": [[-1]]},
        "assignment": [False, True],
    }
    return {
        "classification": "supplementary_finite_experiment_not_the_infinite_proof",
        "all_sign_patterns_q_zero_through_six": count,
        "cell_disjointness_patterns": patterns,
        "jacobian_operation": "sat.assignment.check",
        "jacobian_scope": "A point of H(t,1) has a=false and b=true and satisfies the A-complement predicate.",
        "jacobian_adapter_exit_code": 0,
        "jacobian_status": "completed_typed_output",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--build-only", action="store_true")
    args = parser.parse_args()
    lean, env, version = compiler()
    builds = build(lean, env)
    if args.build_only:
        print(json.dumps({"global_modules_compiled": 17, "lean_version": version}))
        return
    experiments = finite_checks()
    command = [
        PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        "--project-root", str(ROOT), "--claim", "C_MAIN_COUNTEREXAMPLE",
        "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--artifact-dir", str(HERE / "lean"), "--no-lake", "--lean-bin", lean,
        str(HERE / "Main.lean"),
    ]
    result = subprocess.run(command, cwd=ROOT, env=env, text=True, capture_output=True)
    (HERE / "lean_verify_output.json").write_text(result.stdout)
    (HERE / "lean_verify_stderr.txt").write_text(result.stderr)
    checks = check_ledgers()
    if result.returncode:
        raise RuntimeError(result.stdout + result.stderr)
    evidence = json.loads(result.stdout)
    assert evidence["status"] == "success"
    assert evidence["exit_code"] == evidence["audit_exit_code"] == 0
    assert evidence["proof_holes"] == []
    assert evidence["kernel"]["recorded"] is not None
    axioms = {}
    for target in TARGETS:
        match = re.search(
            re.escape("'" + target + "'") + r"\s+depends on axioms:\s*\[([^\]]*)\]",
            evidence["stdout"],
        )
        if match is None:
            assert "'" + target + "' does not depend on any axioms" in evidence["stdout"], target
            values = set()
        else:
            values = {v.strip() for v in match.group(1).split(",") if v.strip()}
        assert values <= {"propext", "Classical.choice", "Quot.sound"}, (target, values)
        axioms[target] = sorted(values)
    certificate = {
        "claim": "C_MAIN_COUNTEREXAMPLE",
        "result_class": "formal_verification",
        "scope": "Unconditional original thm:main, including labelled duality, maximal extension, no independent covering and no mixed packing/covering partition.",
        "source_commit": COMMIT, "lean_version": version,
        "exit_code": 0, "audit_exit_code": 0, "proof_holes": [],
        "undischarged_assumptions": [],
        "upstream_compilation": builds,
        "transitive_axioms": axioms,
        "supplementary_exact_checks": experiments,
        "kernel_record": evidence["kernel"],
        "campaign_local_checks": checks,
        "independent_review": "required_pending_host_reviewer",
        "novelty": "No new mathematical counterexample is claimed; the full global manuscript theorem and explicit minor/orientation/IM bridges are now machine checked.",
    }
    write_json(HERE / "exact_certificate.json", certificate)
    with (ROOT / "activity.jsonl").open("a") as stream:
        stream.write(json.dumps({
            "ts": datetime.now(timezone.utc).isoformat(), "role": "engineer",
            "agent": "copilot", "kind": "certification",
            "action": "Verified the unconditional global theorem with Lean 4.31.0 and standard transitive axioms only.",
            "status": "pending_independent_review",
            "artifact": "research/verification/global/exact_certificate.json",
        }) + "\n")
    print(json.dumps({
        "claim": certificate["claim"], "exit_code": 0, "proof_holes": [],
        "axiom_targets": len(axioms), "project_root": str(ROOT),
        "math_state_exit": 0, "proof_graph_exit": 0,
        "independent_review": certificate["independent_review"],
    }))


if __name__ == "__main__":
    main()
