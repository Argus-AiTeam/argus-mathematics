#!/usr/bin/env python3
"""Replay exact arithmetic and the source-bound formal obstruction certificate."""

import argparse
from fractions import Fraction as Q
import hashlib
from itertools import product
import json
import os
from pathlib import Path
import re
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
LEAN = "$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean"
CLAIM = "C_NO_C0_324"
DECLARATIONS = [
    "exact_compatible_detectors",
    "no_bounded_signs_lower",
    "noLinearC0_of_localization",
    "ordinary_c0_obstruction",
]
AXIOMS = ["Classical.choice", "Quot.sound", "propext"]


def rational(value):
    result = Q(int(value["num"]), int(value["den"]))
    assert str(result.numerator) == value["num"]
    assert str(result.denominator) == value["den"]
    return result


def replay_jacobian():
    payload = json.loads((HERE / "jacobian_reduced_payload.json").read_text())
    response = json.loads((HERE / "jacobian_reduced_output.json").read_text())
    status = json.loads((HERE / "jacobian_reduced_status.json").read_text())
    assert status["adapter_exit_code"] == 0
    assert response["result"]["operation_id"] == status["operation_id"]
    output = response["result"]["output"]
    assert output["status"] == "OPTIMAL"
    assert output["program"] == payload["program"]
    assert payload["program"]["objective"]["sense"] == "MAXIMIZE"
    assert len(payload["program"]["variables"]) == 2
    assert all(
        rational(v["lower_bound"]) == 0 and v["upper_bound"] is None
        for v in payload["program"]["variables"]
    )
    point = list(map(rational, output["primal_candidate"]))
    dual = list(map(rational, output["constraint_dual"]))
    objective = list(map(rational, payload["program"]["objective"]["coefficients"]))
    assert objective == [Q(1), Q(1)]
    rows = payload["program"]["constraints"]
    for row, multiplier in zip(rows, dual, strict=True):
        coefficients = list(map(rational, row["coefficients"]))
        assert row["relation"] == "LE" and multiplier >= 0
        assert sum(a * x for a, x in zip(coefficients, point, strict=True)) <= rational(row["rhs"])
    assert all(x >= 0 for x in point)
    assert all(
        sum(y * rational(row["coefficients"][j]) for row, y in zip(rows, dual, strict=True)) == c
        for j, c in enumerate(objective)
    )
    primal_value = sum(c * x for c, x in zip(objective, point, strict=True))
    dual_value = sum(y * rational(row["rhs"]) for row, y in zip(rows, dual, strict=True))
    assert primal_value == dual_value == Q(2)
    assert rational(output["primal_objective"]) == primal_value
    assert rational(output["dual_objective"]) == dual_value
    assert all(rational(x) == 0 for x in output["stationarity_residuals"])
    rejected = json.loads((HERE / "jacobian_output.json").read_text())
    assert rejected["ok"] is False
    assert rejected["error"]["data"]["code"] == "INVALID_REQUEST"
    return {
        "operation_id": status["operation_id"],
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "status": "OPTIMAL",
        "exact_optimum": "2",
        "original_admission_rejection": "non-conclusion; preserved separately",
    }


def chi(t):
    return min(Q(1), max(Q(0), 2 * t - 1))


def operation(kind, q, scale, u):
    value = u(q)

    def result(x):
        g = value + chi(abs(x - q) / scale) * (u(x) - value)
        return g if kind == "G" else g - u(x)

    return result


def apply_operations(operations, u):
    for kind, q, scale in operations:
        u = operation(kind, q, scale, u)
    return u


def replay_operations():
    operations = [("G", Q(0), Q(1, 8)), ("R", Q(1, 16), Q(1, 16)), ("G", Q(0), Q(1, 32))]
    assert sum(scale for _, _, scale in operations) < Q(1, 2)
    assert all(a[2] >= b[2] for a, b in zip(operations, operations[1:]))
    assert all((q / (scale / 8)).denominator == 1 for _, q, scale in operations)
    base = lambda x: 3 * x + Q(1, 5)
    original = apply_operations(operations, base)
    branches = []
    for first, last in product([False, True], repeat=2):
        branch = []
        if first:
            branch.append(("R", operations[0][1], operations[0][2]))
        branch.append(operations[1])
        if last:
            branch.append(("R", operations[2][1], operations[2][2]))
        branches.append(apply_operations(branch, base))
    points = [Q(i, 128) for i in range(-128, 129)]
    assert all(original(x) == sum(f(x) for f in branches) for x in points)
    for kind, q, scale in operations:
        g = operation("G", q, scale, base)
        r = operation("R", q, scale, base)
        assert all(g(x) == base(x) + r(x) for x in points)
        assert all(abs(r(x)) <= scale * 3 for x in points)
        assert all(g(x) == base(q) for x in points if abs(x - q) < scale / 2)
        assert all(r(x) == 0 for x in points if abs(x - q) >= scale)
    return {"grid_points": len(points), "noncommuting_expansion_terms": len(branches)}


def replay_signs():
    entries = 0
    for n in range(1, 7):
        signs = list(product([-1, 1], repeat=n))
        for j in range(n):
            for k in range(n):
                expectation = Q(sum(s[j] * s[k] for s in signs), len(signs))
                assert expectation == int(j == k)
                entries += 1
    return {"dimensions": [1, 2, 3, 4, 5, 6], "exact_character_products": entries}


def replay_tail_index():
    point = [Q(0), Q(1, 2), Q(0)]
    tail = lambda cutoff: max([Q(0)] + [abs(x) for k, x in enumerate(point) if k > cutoff])
    factor = lambda cutoff: min(Q(1), max(Q(0), 2 - tail(cutoff) / Q(1, 4)))
    assert tail(0) == Q(1, 2) and tail(1) == 0
    assert factor(0) == 0 and factor(1) == 1
    return {
        "coordinate_mapping": "source k maps to Lean k-1",
        "source_first_cutoff": 1,
        "required_lean_first_cutoff": 0,
        "factor_at_required_cutoff": "0",
        "factor_at_upstream_first_cutoff": "1",
        "limitation": "Distinguishes ingredients; does not assert inequivalence of the completed norms.",
    }


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def display_path(path):
    path = Path(path).absolute()
    return str(path.relative_to(ROOT)) if path.is_relative_to(ROOT) else str(path)


def input_bindings():
    original = json.loads((HERE / "compiler_build.json").read_text())
    manuscript = json.loads((HERE / "manuscript_build.json").read_text())
    assert original["status"] == manuscript["status"] == "compiled"
    assert len(original["modules"]) == 23 and len(manuscript["modules"]) == 13
    assert "version 4.31.0," in original["compiler"]
    assert original["project_root"] == str(ROOT)
    paths = {
        HERE / name
        for name in [
            "Main.lean", "CompatibleSelection.lean", "STATEMENT_FIDELITY.md",
            "build_upstream.py", "build_manuscript.py", "make_selection.py",
            "verify.py", "manuscript_lean_path.txt",
            "jacobian_payload.json", "jacobian_output.json", "jacobian_status.json",
            "jacobian_reduced_payload.json", "jacobian_reduced_output.json",
            "jacobian_reduced_status.json", "build/compatibility_audit.json",
        ]
    }
    sections = (
        ROOT / "research/openai_manuscript"
        / "Bi-Lipschitz-Absorption-of-c0-Without-a-Linear-Copy-of-c0-September-26-2026"
        / "build/sections"
    )
    paths.update(
        sections / name
        for name in ["03-weights.tex", "05-tests.tex", "06-molecules.tex", "07-no-c0.tex"]
    )
    for row in original["modules"] + manuscript["modules"]:
        assert row["exit_code"] == 0 and row["command"][0] == LEAN
        source = Path(row["source"])
        if "source_sha256" in row:
            assert digest(source) == row["source_sha256"], f"Changed compiler input: {source}"
        paths.add(source)
        compiled = Path(row["command"][row["command"].index("-o") + 1])
        assert compiled.is_file(), f"Missing compiled dependency: {compiled}"
        paths.add(compiled)
        for suffix in [".private", ".server"]:
            companion = compiled.with_name(compiled.name + suffix)
            if companion.exists():
                paths.add(companion)
    selection = HERE / "manuscript_build/CompatibleSelection.olean"
    assert selection.is_file()
    paths.add(selection)
    for suffix in [".private", ".server"]:
        companion = selection.with_name(selection.name + suffix)
        if companion.exists():
            paths.add(companion)
    audit = json.loads((HERE / "build/compatibility_audit.json").read_text())
    assert audit["all_compiler_exits_zero"] is True
    assert audit["module_count"] == 23 and audit["proof_edit_count"] == 14
    source_root = Path(original["source_root"])
    for edit in audit["proof_only_edits"]:
        relative = Path(edit["module"].replace(".", "/") + ".lean")
        upstream = source_root / relative
        ported = HERE / "compat" / relative
        assert digest(upstream) == edit["upstream_sha256"]
        assert digest(ported) == edit["compiled_source_sha256"]
        paths.update([upstream, ported])
    assert (HERE / "manuscript_lean_path.txt").read_text().split(":")[0] == str(HERE / "manuscript_build")
    return {display_path(path): digest(path) for path in sorted(paths)}


def replay_formal():
    response = json.loads((HERE / "native_response.json").read_text())
    assert response["status"] == "success" and response["exit_code"] == 0
    assert response["audit_exit_code"] == 0 and response["proof_holes"] == []
    assert response["environment_failure"] == ""
    assert response["tools"]["lean"]["available"] is True
    assert "version 4.31.0," in response["tools"]["lean"]["version"]
    record = response["kernel"]["recorded"]
    assert record is not None and response["kernel"]["refusals"] == []
    assert record["tier"] == "mechanical" and record["verdict"] == "supports"
    assert record["subject"]["subject_id"] == CLAIM
    artifact = ROOT / record["artifact"]
    assert artifact.resolve().is_relative_to(HERE)
    certificate = json.loads(artifact.read_text())
    assert certificate["evidence_id"] == record["evidence_id"]
    assert certificate["subject"] == record["subject"]
    assert certificate["tier"] == "mechanical" and certificate["verdict"] == "supports"
    assert certificate["lean_check"] == {key: value for key, value in response.items() if key != "kernel"}
    assert digest(HERE / "Main.lean") == digest(response["source"]) == response["source_sha256"]
    assert digest(HERE / "STATEMENT_FIDELITY.md") == digest(response["statement_fidelity"])
    assert digest(HERE / "STATEMENT_FIDELITY.md") == response["statement_fidelity_sha256"]
    assert certificate["lean_source"]["text"] == (HERE / "Main.lean").read_text()
    assert certificate["statement_fidelity"]["text"] == (HERE / "STATEMENT_FIDELITY.md").read_text()
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    current = max((c for c in ledger["claims"] if c["claim_id"] == CLAIM), key=lambda c: c["version"])
    assert current["content_hash"] == record["subject"]["content_hash"]
    assert current["formal_statement"] == (HERE / "Main.lean").read_text()
    assert current["external_assumptions"] == []
    axioms = {}
    for line in response["stdout"].splitlines():
        match = re.fullmatch(r"'Audit324\.(\w+)' depends on axioms: \[([^]]*)\]", line)
        assert match is not None, f"Unexpected axiom output: {line}"
        axioms[match.group(1)] = sorted(match.group(2).split(", "))
    assert sorted(axioms) == sorted(DECLARATIONS)
    assert all(value == AXIOMS for value in axioms.values())
    return {
        "artifact": record["artifact"],
        "artifact_sha256": digest(artifact),
        "evidence_id": record["evidence_id"],
        "subject": record["subject"],
        "lean_version": response["tools"]["lean"]["version"],
        "exit_code": response["exit_code"],
        "audit_exit_code": response["audit_exit_code"],
        "proof_holes": response["proof_holes"],
        "source_sha256": response["source_sha256"],
        "statement_fidelity_sha256": response["statement_fidelity_sha256"],
        "transitive_axioms": axioms,
    }


def campaign_checks():
    checks = {"project_root": str(ROOT)}
    for name, module in [
        ("math_state", "argus_skill.verticals.math.math_state"),
        ("proof_graph_check", "argus_skill.verticals.math.proof_graph_check"),
    ]:
        result = subprocess.run(
            [ARGUS_PYTHON, "-m", module, "check", "--project-root", str(ROOT)],
            cwd=ROOT, capture_output=True, text=True, timeout=30,
        )
        checks[name] = {
            "exit_code": result.returncode, "stdout": result.stdout, "stderr": result.stderr,
        }
    (HERE / "validation_checks.json").write_text(json.dumps(checks, indent=2) + "\n")
    assert all(checks[name]["exit_code"] == 0 for name in ["math_state", "proof_graph_check"]), checks


def run_logged(command, name, env=None):
    with (HERE / name).open("w") as stream:
        subprocess.run(
            command, cwd=ROOT, env=env, stdout=stream, stderr=subprocess.STDOUT,
            check=True, timeout=900,
        )


def rebuild():
    run_logged([ARGUS_PYTHON, str(HERE / "build_upstream.py"), "--fresh"], "replay_upstream.log")
    run_logged([ARGUS_PYTHON, str(HERE / "build_manuscript.py")], "replay_manuscript.log")
    run_logged([ARGUS_PYTHON, str(HERE / "make_selection.py")], "replay_generation.log")
    env = dict(os.environ, LEAN_PATH=(HERE / "manuscript_lean_path.txt").read_text().strip())
    run_logged(
        [LEAN, "-o", str(HERE / "manuscript_build/CompatibleSelection.olean"),
         str(HERE / "CompatibleSelection.lean")],
        "replay_selection.log", env,
    )


def compile_formal():
    before = input_bindings()
    env = dict(os.environ, LEAN_PATH=(HERE / "manuscript_lean_path.txt").read_text().strip())
    result = subprocess.run(
        [ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
         str(HERE / "Main.lean"), "--statement-fidelity", str(HERE / "STATEMENT_FIDELITY.md"),
         "--claim", CLAIM, "--project-root", str(ROOT),
         "--artifact-dir", str(HERE / "lean_evidence"), "--no-lake",
         "--lean-bin", LEAN, "--timeout", "120"],
        cwd=ROOT, env=env, capture_output=True, text=True, timeout=300,
    )
    (HERE / "native_response.json").write_text(result.stdout)
    (HERE / "native_stderr.log").write_text(result.stderr)
    campaign_checks()
    assert result.returncode == 0, result.stdout + result.stderr
    assert before == input_bindings(), "A formal input changed during compilation."


def main():
    if not __debug__:
        raise RuntimeError("Run this verifier without Python's optimization flags.")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true", help="Bind the existing genuine compiler result.")
    parser.add_argument("--compile", action="store_true", help="Obtain a fresh native Main.lean compiler result.")
    parser.add_argument("--rebuild", action="store_true", help="Freshly compile every dependency, selection, and Main.lean.")
    parser.add_argument("--check-ledgers", action="store_true", help="Run both official campaign-local checks.")
    args = parser.parse_args()
    previous = None
    if not args.write_certificate:
        previous = json.loads((HERE / "exact_certificate.json").read_text())
        assert previous["input_hashes"] == input_bindings(), "The certificate's inputs are stale."
    if args.rebuild:
        rebuild()
    if args.compile or args.rebuild:
        compile_formal()
    elif args.check_ledgers:
        campaign_checks()
    arithmetic = {
        "jacobian": replay_jacobian(),
        "operations": replay_operations(),
        "signs": replay_signs(),
        "tail_index": replay_tail_index(),
    }
    certificate = {
        "schema_version": 1,
        "claim": CLAIM,
        "result_class": "complete_solution",
        "scope": "Independent formal verification of the bounded ordinary-c0 obstruction mission.",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "formal": replay_formal(),
        "input_hashes": input_bindings(),
        "arithmetic": arithmetic,
        "arithmetic_scope": "Auxiliary exact finite identities and LP duality; not the infinite-dimensional proof.",
        "independent_review": "Not asserted by this verifier; Host-invoked Reviewer must assess statement fidelity.",
        "novelty_status": "unassessed",
        "significance_status": "unassessed",
        "manuscript_refutation": False,
    }
    if args.write_certificate or args.compile or args.rebuild:
        (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        assert previous == certificate, "The saved certificate does not match its mathematical evidence."
    print(json.dumps({
        "status": "verified",
        "mode": "fresh_dependency_and_kernel_replay" if args.rebuild else
                "fresh_kernel_replay" if args.compile else "recorded_certificate_replay",
        "claim": CLAIM,
        "lean_exit_code": certificate["formal"]["exit_code"],
        "proof_holes": certificate["formal"]["proof_holes"],
        "declarations": DECLARATIONS,
        "input_hash_count": len(certificate["input_hashes"]),
        "independent_review": certificate["independent_review"],
    }, indent=2))


if __name__ == "__main__":
    main()
