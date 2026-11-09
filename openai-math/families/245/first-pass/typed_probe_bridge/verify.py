#!/usr/bin/env python3
"""Replay the exact Access projection and certify the parametric typed bridge."""

import argparse
import itertools
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
CLAIM = "C_TYPED_PROBE_BRIDGE"
VARIABLES = [
    "access", "d_m", "fe_dummy", "fe_m",
    "fi_dummy", "fi_point", "inner_m", "target",
]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def read_json(name):
    return json.loads((HERE / name).read_text())


def write_json(name, value):
    (HERE / name).write_text(json.dumps(value, indent=2) + "\n")


def gate(condition, positive, negative):
    return (condition and positive) or (not condition and negative)


def access_projection():
    values = ("dummy", "parameter", "point0", "point1")
    points = {"point0": 0, "point1": 1}
    cases = 0
    guarded = 0
    no_guard = None
    changed_parameter = None
    for rounding in itertools.product(range(2), repeat=2):
        for bits in itertools.product((False, True), repeat=8):
            table = dict(zip(values, (bits[i:i + 2] for i in range(0, 8, 2))))
            for parameter_flag in (False, True):
                flags = {"dummy": True, "parameter": parameter_flag,
                         "point0": False, "point1": False}
                for other_queries in itertools.product((False, True), repeat=2):
                    def query(o, predicate):
                        if o in points:
                            return predicate(points[o])
                        return other_queries[values.index(o)]

                    for m in values:
                        for y in range(2):
                            point = f"point{y}"

                            def bundle(f):
                                return gate(f("dummy"), f(m), f(point))

                            def inner(o):
                                def f(o_prime):
                                    predicate = lambda x: table[o][rounding[x]]
                                    return gate(flags[o_prime], False,
                                                query(o_prime, predicate))
                                return f

                            def outer(o):
                                return gate(flags[o], True, bundle(inner(o)))

                            actual = bundle(outer)
                            target = table[m][rounding[y]]
                            cases += 1
                            if not flags[m]:
                                require(actual == target,
                                        "Failure of the expanded guarded Access construction")
                                guarded += 1
                                replacement = table[point][rounding[y]]
                                if replacement != target and changed_parameter is None:
                                    changed_parameter = {
                                        "m": m, "incorrect_replacement": point,
                                        "y": y, "round_y": rounding[y],
                                        "callback_table": table,
                                        "actual_access": actual,
                                        "correct_target": target,
                                        "incorrect_target": replacement,
                                    }
                            elif actual != target and no_guard is None:
                                no_guard = {
                                    "m": m, "D_m": flags[m], "y": y,
                                    "rounding": rounding, "callback_table": table,
                                    "actual_access": actual, "unguarded_target": target,
                                }
    require(no_guard is not None, "The not-D guard sensitivity check did not fire")
    require(changed_parameter is not None, "The exact-parameter sensitivity check did not fire")
    return {
        "kind": "finite_local_functional_projection",
        "evaluations": cases,
        "guarded_evaluations": guarded,
        "guarded_counterexamples": 0,
        "guard_deleted_diagnostic": no_guard,
        "parameter_replacement_diagnostic": changed_parameter,
        "scope": "Expanded Bundle, inner and outer callbacks; not a model of the full PTS.",
        "diagnostics_are_manuscript_refutations": False,
    }


def named_cnf():
    clauses = []

    def relation(names, predicate):
        indexes = [VARIABLES.index(name) + 1 for name in names]
        for bits in itertools.product((False, True), repeat=len(names)):
            if not predicate(*bits):
                clauses.append([(-index if bit else index)
                                for index, bit in zip(indexes, bits)])

    relation(["fe_dummy"], bool)
    relation(["fi_dummy"], lambda x: not x)
    relation(["fi_point", "target"], lambda x, y: x == y)
    relation(["inner_m", "fi_point"], lambda x, y: x == y)
    relation(["fe_m", "d_m", "inner_m"],
             lambda out, flag, inner: out == gate(flag, True, inner))
    relation(["access", "fe_m"], lambda x, y: x == y)
    relation(["d_m"], lambda x: not x)
    relation(["access", "target"], lambda x, y: x != y)
    return {"variable_names": VARIABLES, "clauses": clauses}


def canonical_payload():
    source = named_cnf()
    require(read_json("jacobian_named_payload.json") == source,
            "The named CNF no longer represents the stated Access projection")
    result = read_json("jacobian_canonical_result.json")
    status = read_json("jacobian_canonical_status.json")
    require(status == {"exit_code": 0}, "The canonicalization adapter did not succeed")
    require(result["request"] == {
        "operation_id": "sat.cnf.canonicalize", "payload": source},
        "Canonicalization answered a different request")
    require(result["result"]["operation_id"] == "sat.cnf.canonicalize",
            "Unexpected canonicalization operation")
    cnf = result["result"]["output"]["cnf"]
    require(cnf["variables"] == VARIABLES, "Variable meanings changed in canonicalization")
    original = {tuple(sorted(clause, key=abs)) for clause in source["clauses"]}
    require({tuple(clause) for clause in cnf["clauses"]} == original,
            "Canonicalization changed a source clause")
    return {"cnf": cnf, "timeout_ms": 1000}


def replay_cnf(payload):
    clauses = payload["cnf"]["clauses"]
    satisfying = 0
    for bits in itertools.product((False, True), repeat=len(VARIABLES)):
        access, flag, fe_dummy, fe_m, fi_dummy, fi_point, inner, target = bits
        cnf = all(any(bits[abs(lit) - 1] == (lit > 0) for lit in clause)
                  for clause in clauses)
        direct = (
            fe_dummy and not fi_dummy and fi_point == target and inner == fi_point
            and fe_m == gate(flag, True, inner) and access == fe_m
            and not flag and access != target
        )
        require(cnf == direct, "The CNF is not the selected-branch Access counterexample query")
        satisfying += int(cnf)
    require(satisfying == 0, "The guarded Boolean Access projection has a counterexample")
    return {
        "variables": len(VARIABLES), "clauses": len(clauses),
        "assignments_replayed": 2 ** len(VARIABLES),
        "satisfying_assignments": satisfying,
        "scope": "Selected branches justified by the signed dummy and point facts.",
    }


def check_jacobian(payload):
    require(read_json("jacobian_payload.json") == payload, "The solver payload changed")
    result = read_json("jacobian_result.json")
    status = read_json("jacobian_status.json")
    require(status == {"exit_code": 0}, "The SAT adapter did not succeed")
    require(result["request"] == {"operation_id": "sat.solve", "payload": payload},
            "The adapter submitted a different solver request")
    require(result["result"]["operation_id"] == "sat.solve", "Unexpected solver operation")
    output = result["result"]["output"]
    require(output["source"] == payload, "The typed solver result answers a different CNF")
    require(output["outcome"] == "UNSAT",
            "SAT, UNKNOWN, timeout or transport failure is not a positive certificate")
    require(output.get("exhausted") is None, "The solver exhausted its bound")
    return {
        "operation_id": "sat.solve", "server": result["server"],
        "protocol_version": result["protocol_version"], "adapter_exit_code": 0,
        "outcome": output["outcome"], "independent_exhaustive_replay": True,
    }


def run_checked(command):
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=False)
    if result.returncode:
        raise RuntimeError(
            f"Command failed ({result.returncode}): {command}\n"
            f"{result.stdout}\n{result.stderr}")
    return result.stdout


def check_project():
    checks = {}
    for module, filename in (
            ("math_state", "math_state_check.txt"),
            ("proof_graph_check", "proof_graph_check.txt")):
        output = run_checked([
            ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}",
            "check", "--project-root", str(ROOT),
        ])
        (HERE / filename).write_text(output)
        checks[module] = 0
    return {"project_root": str(ROOT), "exit_codes": checks}


def compile_lean():
    command = [
        ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"), "--statement-fidelity",
        str(HERE / "STATEMENT_FIDELITY.md"), "--claim", CLAIM,
        "--project-root", str(ROOT), "--artifact-dir", str(HERE),
        "--no-lake", "--timeout", "100",
    ]
    result = json.loads(run_checked(command))
    # Recording mechanical evidence changes the ledger, even on an unverified run.
    validation = check_project()
    require(result["status"] == "success", "Lean did not certify the source")
    require(result["exit_code"] == 0, "The compiler returned nonzero")
    require(result["proof_holes"] == [], "The source contains proof holes")
    require(result["kernel"]["recorded"] is not None, "Mechanical evidence was not recorded")
    require((HERE / "statement_fidelity.md").read_text()
            == (HERE / "STATEMENT_FIDELITY.md").read_text(),
            "Canonical and supplied statement-fidelity documents differ")
    return {
        "command": command, "status": result["status"],
        "exit_code": result["exit_code"], "proof_holes": result["proof_holes"],
        "tools": result["tools"], "kernel": result["kernel"],
        "axiom_audit": result["stdout"].strip(),
    }, validation


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prepare-jacobian", action="store_true")
    parser.add_argument("--build-solver-payload", action="store_true")
    args = parser.parse_args()
    require(not (args.prepare_jacobian and args.build_solver_payload),
            "Choose one payload preparation stage")
    if args.prepare_jacobian:
        write_json("jacobian_named_payload.json", named_cnf())
        print("Saved the named Access counterexample query; no validation repeated.")
        return
    if args.build_solver_payload:
        write_json("jacobian_payload.json", canonical_payload())
        print("Saved the solver request from the inspected canonicalizer output.")
        return
    finite = access_projection()
    payload = canonical_payload()
    replay = replay_cnf(payload)
    jacobian = check_jacobian(payload)
    lean, validation = compile_lean()
    certificate = {
        "claim": CLAIM,
        "result_class": "conditional_typed_macro_verification",
        "unbounded_result": [
            "Syntax.type_preservation and Syntax.formula_preservation",
            "Syntax.uniform_probe_typed, Syntax.access_typed, Syntax.lift_typed",
            "Syntax.uniform_probe_has_no_open_A and global_types_have_no_parameter",
            "access_exact and realize_four_laws",
        ],
        "guarded_core_fields_discharged": [
            "lift_cancel", "probe_rounded", "lift_congr", "lift_valid",
        ],
        "remaining_upstream_inputs": [
            "Actual labelled PTS realization of the primitive typing interpretation",
            "Primitive exact wrapper, rounded predicate and X cancellation",
            "Typed fixed positive retraction and the two native beta conversions",
            "Typed marker/dummy/point laws and logical constructors",
        ],
        "finite_access_projection": finite,
        "cnf_replay": replay,
        "jacobian": jacobian,
        "lean": lean,
        "campaign_local_validation": validation,
        "source": "Main.lean",
        "statement_fidelity": "STATEMENT_FIDELITY.md",
        "independent_review": "pending_Host_invoked_Reviewer",
        "reused_guarded_core_review": "handoffs/8e184e6af0d9/round-0001.json",
        "unchanged_guarded_core_replayed": False,
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "novelty_status": "not_established",
        "significance_status": "bounded_engineering_milestone",
        "campaign_complete": False,
        "manuscript_refutations": [],
    }
    write_json("exact_certificate.json", certificate)
    print(json.dumps({
        "certificate": str(HERE / "exact_certificate.json"),
        "lean_exit_code": lean["exit_code"], "proof_holes": lean["proof_holes"],
        "finite_guarded_evaluations": finite["guarded_evaluations"],
        "validation": validation,
    }, indent=2))


if __name__ == "__main__":
    main()
