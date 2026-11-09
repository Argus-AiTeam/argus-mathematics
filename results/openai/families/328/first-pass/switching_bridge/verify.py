#!/usr/bin/env python3
"""Replay the exact arithmetic and obtain fresh official Lean evidence."""

import hashlib
import json
import re
import subprocess
from datetime import datetime, timezone
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
CLAIM = "C_SWITCHING_BRIDGE"
THEOREM = "SwitchingBridge.switching_bridge_from_manuscript"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(name):
    return json.loads((HERE / name).read_text(encoding="utf-8"))


def rational(value):
    result = Fraction(int(value["num"]), int(value["den"]))
    require(
        value == {"num": str(result.numerator), "den": str(result.denominator)},
        "Noncanonical rational in the exact LP evidence",
    )
    return result


def replay_lp():
    payload = read_json("jacobian_bounded_payload.json")
    response = read_json("jacobian_bounded_output.json")
    operation = "optimization.linear.rational_general_optimum.compute"
    require(response["request"]["operation_id"] == operation, "Wrong Jacobian operation")
    require(response["request"]["payload"] == payload, "Jacobian request/payload mismatch")
    require(response["result"]["operation_id"] == operation, "Wrong result operation")
    out = response["result"]["output"]
    program = payload["program"]
    require(out["program"] == program, "The LP answer is not in the submitted coordinates")
    require(out["status"] == "OPTIMAL", "Jacobian supplied no exact optimality conclusion")
    require(program["objective"]["sense"] == "MAXIMIZE", "Unexpected objective sense")
    x = [rational(v) for v in out["primal_candidate"]]
    dual = [rational(v) for v in out["constraint_dual"]]
    lower = [rational(v) for v in out["lower_bound_dual"]]
    upper = [rational(v) for v in out["upper_bound_dual"]]
    objective = [rational(v) for v in program["objective"]["coefficients"]]
    require(
        [v["name"] for v in program["variables"]]
        == ["bad_leaf_mass", "total_weighted_deficit"]
        and objective == [1, 0],
        "The LP no longer maximizes the manuscript's bad-leaf mass",
    )
    expected_rows = [
        ("bad_leaves_cost_at_least_one_half", "GE", [Fraction(-1, 2), Fraction(1)], Fraction(0)),
        ("total_deficit_budget", "LE", [Fraction(0), Fraction(1)], Fraction(5, 128)),
    ]
    actual_rows = [
        (row["label"], row["relation"], [rational(v) for v in row["coefficients"]],
         rational(row["rhs"]))
        for row in program["constraints"]
    ]
    require(actual_rows == expected_rows, "The exact LP premises no longer match the deficit bound")
    require(
        all(v["upper_bound"] is None and rational(v["lower_bound"]) == 0
            for v in program["variables"]),
        "The LP's nonnegative-variable domain changed",
    )
    require(len(x) == len(objective) == len(program["variables"]), "Wrong primal dimension")
    require(len(dual) == len(program["constraints"]), "Wrong dual dimension")
    require(len(lower) == len(upper) == len(x), "Wrong bound-dual dimension")
    balance = [Fraction(0) for _ in x]
    dual_value = Fraction(0)
    for row, multiplier in zip(program["constraints"], dual):
        a = [rational(v) for v in row["coefficients"]]
        require(len(a) == len(x), "Wrong row dimension")
        rhs = rational(row["rhs"])
        lhs = sum(c * v for c, v in zip(a, x))
        relation = row["relation"]
        require(relation in {"LE", "GE", "EQ"}, "Unknown row relation")
        if relation == "LE":
            require(lhs <= rhs and multiplier >= 0, "Invalid LE primal/dual row")
        elif relation == "GE":
            require(lhs >= rhs and multiplier <= 0, "Invalid GE primal/dual row")
        else:
            require(lhs == rhs, "Invalid equality row")
        dual_value += multiplier * rhs
        balance = [v + multiplier * c for v, c in zip(balance, a)]
    for i, variable in enumerate(program["variables"]):
        lo = variable["lower_bound"]
        hi = variable["upper_bound"]
        if lo is None:
            require(lower[i] == 0, "A missing lower bound has a nonzero multiplier")
        else:
            bound = rational(lo)
            require(x[i] >= bound and lower[i] <= 0, "Invalid lower-bound certificate")
            dual_value += lower[i] * bound
        if hi is None:
            require(upper[i] == 0, "A missing upper bound has a nonzero multiplier")
        else:
            bound = rational(hi)
            require(x[i] <= bound and upper[i] >= 0, "Invalid upper-bound certificate")
            dual_value += upper[i] * bound
        balance[i] += lower[i] + upper[i]
    require(balance == objective, "The source-coordinate dual stationarity identity fails")
    primal_value = sum(c * v for c, v in zip(objective, x))
    require(primal_value == dual_value == Fraction(5, 64), "The bad-mass bound is not 5/64")
    require(rational(out["primal_objective"]) == primal_value, "Wrong recorded primal value")
    require(rational(out["dual_objective"]) == dual_value, "Wrong recorded dual value")
    rejected = read_json("jacobian_output.json")
    require(rejected["ok"] is False, "The preserved rejected invocation was relabelled")
    return {
        "operation_id": operation,
        "server": response["server"],
        "protocol_version": response["protocol_version"],
        "payload": "jacobian_bounded_payload.json",
        "typed_output": "jacobian_bounded_output.json",
        "status": "OPTIMAL",
        "independent_exact_primal_dual_replay": True,
        "bad_leaf_mass_upper_bound": "5/64",
        "rejected_invocation": {
            "payload": "jacobian_payload.json",
            "typed_output": "jacobian_output.json",
            "error": rejected["error"],
            "conclusion": "none",
        },
        "scope": "Arithmetic consequence only; its nonlinear premises are proved in Lean.",
    }


def run_checked(command):
    process = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=False)
    if process.returncode:
        raise RuntimeError(
            f"Command exited {process.returncode}: {' '.join(command)}\n"
            f"{process.stdout[-6000:]}\n{process.stderr[-3000:]}"
        )
    return process


def main():
    arithmetic = replay_lp()
    command = [
        PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        "--project-root", str(ROOT), "--claim", CLAIM,
        "--statement-fidelity", str(HERE / "STATEMENT_FIDELITY.md"),
        str(HERE / "Main.lean"),
    ]
    result = json.loads(run_checked(command).stdout)
    require(result["status"] == "success", "The compiler did not certify the source")
    require(result["exit_code"] == 0, "Nonzero Lean compiler exit")
    require(result["audit_exit_code"] == 0, "The environment axiom audit did not pass")
    require(result["proof_holes"] == [], "The source has proof holes")
    require(result["environment_failure"] == "", "The required environment is unverified")
    require(result["kernel"]["recorded"] is not None, "Mechanical evidence was not recorded")
    version = result["tools"]["lean"]["version"]
    require(re.search(r"\bversion 4\.31\.0(?:,|\))", version), "Wrong Lean version")
    require(Path(result["source"]).resolve() == HERE / "Main.lean", "Wrong compiled source")
    require(
        result["source_sha256"] == hashlib.sha256((HERE / "Main.lean").read_bytes()).hexdigest(),
        "The source changed after compilation",
    )
    require(
        result["statement_fidelity_sha256"]
        == hashlib.sha256((HERE / "STATEMENT_FIDELITY.md").read_text(encoding="utf-8").encode()).hexdigest(),
        "Statement fidelity changed after compilation",
    )
    axioms_match = re.search(
        rf"'{re.escape(THEOREM)}' depends on axioms:\s*\[([^\]]*)\]", result["stdout"]
    )
    require(axioms_match is not None, "The principal theorem's axiom list is missing")
    axioms = [name.strip() for name in axioms_match.group(1).split(",") if name.strip()]
    require(
        set(axioms) <= {"propext", "Classical.choice", "Quot.sound"},
        "The principal theorem depends on a nonstandard axiom",
    )
    checks = {}
    for name in ("math_state", "proof_graph_check"):
        check_command = [
            PYTHON, "-m", f"argus_skill.verticals.math.{name}",
            "check", "--project-root", str(ROOT),
        ]
        process = run_checked(check_command)
        checks[name] = {"project_root": str(ROOT), "exit_code": process.returncode,
                        "output": process.stdout.strip()}
    certificate = {
        "claim_id": CLAIM,
        "result_class": "exact_verification_theorem",
        "scope": "Conditional nonlinear switching implication, not the input construction or main fixed-point theorem.",
        "principal_declaration": THEOREM,
        "source": "Main.lean",
        "statement_fidelity": "STATEMENT_FIDELITY.md",
        "compiler_record": "lean_check.json",
        "compiler_log": "compile.log",
        "lean_version": version,
        "exit_code": result["exit_code"],
        "audit_exit_code": result["audit_exit_code"],
        "proof_holes": result["proof_holes"],
        "principal_axioms": axioms,
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "kernel_recording": result["kernel"],
        "arithmetic": arithmetic,
        "campaign_local_checks": checks,
        "independent_review": "not_performed_by_this_script",
        "novelty": "not_claimed",
        "campaign_complete": False,
    }
    (HERE / "exact_certificate.json").write_text(
        json.dumps(certificate, indent=2, ensure_ascii=True) + "\n", encoding="utf-8"
    )
    event = {
        "ts": datetime.now(timezone.utc).isoformat(),
        "role": "engineer", "agent": "copilot", "kind": "certification",
        "action": "Replayed the exact LP primal/dual certificate; obtained fresh Lean 4.31.0 evidence for the full conditional nonlinear switching bridge, with no proof holes or nonstandard axioms. Both campaign-local checks exited zero. Independent review remains pending.",
        "status": "passed",
        "artifact": "research/switching_bridge/exact_certificate.json",
    }
    with (ROOT / "activity.jsonl").open("a", encoding="utf-8") as log:
        log.write(json.dumps(event, ensure_ascii=True) + "\n")
    print(json.dumps({"claim": CLAIM, "exit_code": 0, "proof_holes": [],
                      "project_root": str(ROOT), "independent_review": "pending"}))


if __name__ == "__main__":
    main()
