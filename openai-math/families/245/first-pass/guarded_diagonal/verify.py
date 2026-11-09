#!/usr/bin/env python3
"""Replay finite local projections and the conditional guarded-core Lean proof."""

import argparse
import itertools
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
VARIABLES = [
    "ea0", "ea1", "eb0", "eb1", "la0", "la1", "lb0", "lb1",
    "v0", "v1", "w0", "w1",
]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def ind_projection():
    checked = 0
    unguarded = None
    for bits in itertools.product((False, True), repeat=8):
        ea, eb, la, lb = (bits[k:k + 2] for k in (0, 2, 4, 6))
        if ea != eb:
            continue
        valid = tuple(la[x] == lb[x] for x in range(2))
        ia = all(not valid[x] or not la[x] or ea[x] for x in range(2))
        ib = all(not valid[x] or not lb[x] or eb[x] for x in range(2))
        require(ia == ib, "Counterexample to the exact guarded IndC projection")
        checked += 1
        ua = all(not la[x] or ea[x] for x in range(2))
        ub = all(not lb[x] or eb[x] for x in range(2))
        if ua != ub and unguarded is None:
            unguarded = {"eval_a": ea, "eval_b": eb, "le_a": la, "le_b": lb,
                         "valid": valid, "unguarded_ind_a": ua, "unguarded_ind_b": ub}
    require(unguarded is not None, "Validity-deletion sensitivity test did not fire")
    return {"carrier_sizes": {"X": 2, "PX": 2}, "equivalent_code_tables": checked,
            "counterexamples": 0, "validity_deleted_diagnostic": unguarded}


def response_projection():
    models = 0
    valid_instances = 0
    rounded_models = 0
    diagnostic = None
    for ev in itertools.product((False, True), repeat=2):
        for bits in itertools.product((False, True), repeat=4):
            lp, lv = bits[:2], bits[2:]
            eq = lambda x, y: lp[x] == lp[y] and lv[x] == lv[y]
            ext = all(not eq(x, y) or ev[x] == ev[y]
                      for x in range(2) for y in range(2))
            if not ext:
                continue
            valid = tuple(lp[x] == lv[x] for x in range(2))
            models += 1
            for rounding in itertools.product(range(2), repeat=2):
                if all(eq(x, rounding[x]) for x in range(2)):
                    rounded_models += 1
            for x in range(2):
                # The query has Ext(i_P) as antecedent, and pair-right is Equiv.
                pr = (not ext) or all(
                    not valid[y] or not eq(x, y) or lp[y] for y in range(2))
                if valid[x]:
                    require(pr == lv[x], "Counterexample to the guarded SB projection")
                    valid_instances += 1
                elif pr != lv[x] and diagnostic is None:
                    diagnostic = {"eval_both_codes": ev, "le_left_code": lp,
                                  "le_response_code": lv, "valid": valid,
                                  "point": x, "query_property": pr, "le_response": lv[x]}
    require(diagnostic is not None, "SB validity-deletion sensitivity test did not fire")
    return {"local_models_with_extensional_response": models,
            "valid_point_instances": valid_instances,
            "rounding_choices_preserving_observations": rounded_models,
            "counterexamples": 0, "validity_deleted_diagnostic": diagnostic,
            "scope": "Local response/pair-right/query projection, not a full upstream or PTS model"}


def sat_payload():
    clauses = []

    def add(*literals):
        clauses.append(tuple(sorted(literals, key=abs)))

    for ea, eb in ((1, 3), (2, 4)):
        add(-ea, eb)
        add(ea, -eb)
    for ea, eb, la, lb, valid, witness in (
            (1, 3, 5, 7, 9, 11), (2, 4, 6, 8, 10, 12)):
        # Valid is exactly equality of the two le observations under Approx.
        add(la, lb, valid)
        add(-la, -lb, valid)
        add(la, -lb, -valid)
        add(-la, lb, -valid)
        add(-valid, -la, ea)
        # witness iff Valid and le_b and not eval_b.
        add(-witness, valid)
        add(-witness, lb)
        add(-witness, -eb)
        add(witness, -valid, -lb, eb)
    add(11, 12)
    return {"cnf": {"variables": VARIABLES, "clauses": [
        list(clause) for clause in sorted(set(clauses))]}, "timeout_ms": 1000}


def canonical_payload():
    expected = sat_payload()["cnf"]
    named = json.loads((HERE / "jacobian_named_payload.json").read_text())
    require(named == {"variable_names": VARIABLES, "clauses": expected["clauses"]},
            "The named canonicalization request is not the mathematical source")
    response = json.loads((HERE / "jacobian_canonical_result.json").read_text())
    status = json.loads((HERE / "jacobian_canonical_status.json").read_text())
    require(status["exit_code"] == 0, "Jacobian canonicalization adapter failed")
    require(response["request"] == {
        "operation_id": "sat.cnf.canonicalize", "payload": named},
        "Canonicalization answered a different request")
    require(response["result"]["operation_id"] == "sat.cnf.canonicalize",
            "Wrong canonicalization operation")
    cnf = response["result"]["output"]["cnf"]
    require(cnf["variables"] == VARIABLES, "Canonicalization changed variable meanings")
    require({tuple(c) for c in cnf["clauses"]} == {tuple(c) for c in expected["clauses"]},
            "Canonicalization changed the mathematical clauses")
    return {"cnf": cnf, "timeout_ms": 1000}


def replay_cnf(payload):
    clauses = payload["cnf"]["clauses"]
    satisfying = 0
    for assignment in itertools.product((False, True), repeat=len(VARIABLES)):
        clause_truth = all(any(assignment[abs(lit) - 1] == (lit > 0) for lit in clause)
                           for clause in clauses)
        ea, eb, la, lb = (assignment[k:k + 2] for k in (0, 2, 4, 6))
        valid = assignment[8:10]
        witness = assignment[10:12]
        direct = (
            ea == eb
            and all(valid[x] == (la[x] == lb[x]) for x in range(2))
            and all(not valid[x] or not la[x] or ea[x] for x in range(2))
            and all(witness[x] == (valid[x] and lb[x] and not eb[x]) for x in range(2))
            and any(witness)
        )
        require(clause_truth == direct, "CNF is not the stated finite IndC counterexample query")
        satisfying += int(clause_truth)
    require(satisfying == 0, "Finite IndC counterexample query is satisfiable")
    return {"operation_id": "sat.solve", "variables": len(VARIABLES),
            "clauses": len(clauses), "assignments_replayed": 2 ** len(VARIABLES),
            "satisfying_assignments": satisfying}


def check_jacobian(payload):
    stored = json.loads((HERE / "jacobian_payload.json").read_text())
    require(stored == payload, "Jacobian input no longer matches the mathematical query")
    result = json.loads((HERE / "jacobian_result.json").read_text())
    transport = json.loads((HERE / "jacobian_status.json").read_text())
    require(transport["exit_code"] == 0, "Jacobian adapter failed")
    require(result["request"]["operation_id"] == "sat.solve",
            "Wrong Jacobian operation")
    require(result["request"]["payload"] == payload, "Adapter submitted a different query")
    require(result["result"]["operation_id"] == "sat.solve", "Wrong typed answer")
    answer = result["result"]["output"]
    require(answer["source"] == payload, "Jacobian answered a different query")
    require(answer["outcome"] == "UNSAT", "Jacobian outcome is a non-conclusion or SAT")
    return {"operation_id": "sat.solve", "server": result["server"],
            "protocol_version": result["protocol_version"], "adapter_exit_code": 0,
            "outcome": answer["outcome"], "independently_replayed": True}


def run_checked(command):
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=False)
    if result.returncode:
        raise RuntimeError(
            f"Command failed ({result.returncode}): {command}\n{result.stdout}\n{result.stderr}")
    return result.stdout


def check_project():
    checks = {}
    for module in ("math_state", "proof_graph_check"):
        run_checked([ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}",
                     "check", "--project-root", str(ROOT)])
        checks[module] = 0
    return {"project_root": str(ROOT), "exit_codes": checks}


def compile_lean():
    command = [
        ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"), "--project-root", str(ROOT),
        "--claim", "C_GUARDED_DIAGONAL",
        "--statement-fidelity", str(HERE / "STATEMENT_FIDELITY.md"),
        "--artifact-dir", str(HERE), "--no-lake", "--timeout", "110",
    ]
    output = run_checked(command)
    result = json.loads(output)
    require(result["status"] == "success", "Lean did not certify the source")
    require(result["exit_code"] == 0, "The Lean compiler returned nonzero")
    require(result["proof_holes"] == [], "Lean reported proof holes")
    require(result["kernel"]["recorded"] is not None, "Mechanical evidence was not recorded")
    require((HERE / "statement_fidelity.md").read_text()
            == (HERE / "STATEMENT_FIDELITY.md").read_text(),
            "The compiler's canonical fidelity document differs from the supplied reading")
    return {"command": command, "exit_code": result["exit_code"],
            "status": result["status"], "proof_holes": result["proof_holes"],
            "tools": result["tools"], "kernel": result["kernel"],
            "axiom_audit": result["stdout"].strip()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prepare-jacobian", action="store_true")
    parser.add_argument("--build-solver-payload", action="store_true")
    parser.add_argument("--finite-only", action="store_true")
    args = parser.parse_args()
    if args.build_solver_payload:
        (HERE / "jacobian_payload.json").write_text(
            json.dumps(canonical_payload(), indent=2) + "\n")
        print("Canonical solver payload saved; no mathematical search repeated.")
        return
    payload = sat_payload()
    finite = {"ind_congruence": ind_projection(), "response_comparison": response_projection(),
              "cnf_replay": replay_cnf(payload)}
    if args.prepare_jacobian:
        named = {"variable_names": VARIABLES, "clauses": payload["cnf"]["clauses"]}
        (HERE / "jacobian_named_payload.json").write_text(json.dumps(named, indent=2) + "\n")
    if args.prepare_jacobian or args.finite_only:
        print(json.dumps(finite, indent=2))
        return
    jacobian = check_jacobian(canonical_payload())
    lean = compile_lean()
    validation = check_project()
    certificate = {
        "claim": "C_GUARDED_DIAGONAL",
        "result_class": "conditional_formal_verification",
        "terminal": "Arbitrary B representing F_b; False only in no_false_model",
        "source": "Main.lean",
        "statement_fidelity": "STATEMENT_FIDELITY.md",
        "finite_local_projections": finite,
        "jacobian": jacobian,
        "lean": lean,
        "campaign_local_validation": validation,
        "independent_review": "pending",
        "upstream_realization": "unverified",
        "full_normalization_theorem": "open",
        "novelty_status": "not_established",
        "significance_status": "not_independently_reviewed",
        "manuscript_refutations": [],
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({"certificate": str(HERE / "exact_certificate.json"),
                      "validation": validation}, indent=2))


if __name__ == "__main__":
    main()
