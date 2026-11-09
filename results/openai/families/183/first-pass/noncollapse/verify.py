#!/usr/bin/env python3
"""Replay the exact radial-bridge evidence from the campaign root."""

import hashlib
import json
import re
import subprocess
from datetime import datetime, timezone
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
ARGUS_PYTHON = Path("$WORKSPACE/argus-live-update/.venv/bin/python")
CLAIM = "C183_ZOOM_RADIAL"
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
DECLARATIONS = {
    "ThreeDirection.sequential_compactness_of_moving",
    "ThreeDirection.movingDirections_iff_vanishingDefect",
    "RankGeometry.normalized_triple_bounds",
    "RankRadial.inverse_comp_locallyUniform_of_pointwise",
    "RankRadial.iterated_of_diagonal_subsequence",
    "RankRadial.NormalizedRankData.iterated_radial",
    "RankRadial.identity_cutoff_example",
}


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def relative(path):
    return str(path.relative_to(ROOT))


def run_module(module, arguments):
    command = [str(ARGUS_PYTHON), "-m", module, *arguments]
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=False)
    if result.returncode:
        raise RuntimeError(
            f"Command exited {result.returncode}: {command}\n"
            f"{result.stdout}\n{result.stderr}"
        )
    return {
        "command": command,
        "project_root": str(ROOT),
        "exit_code": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr,
    }


def rational(value):
    return Fraction(int(value["num"]), int(value["den"]))


def triangle_primal_dual():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    program = payload["program"]
    require(program["objective"]["sense"] == "MAXIMIZE", "Unexpected LP objective")
    variables = program["variables"]
    witness = tuple(map(Fraction, (-1, 1, 3, 4, 7)))
    require(len(variables) == len(witness), "Wrong LP coordinate count")
    for variable, value in zip(variables, witness):
        lower = variable["lower_bound"]
        upper = variable["upper_bound"]
        if lower is not None:
            require(rational(lower) <= value, f"Primal violates {variable['name']} lower bound")
        if upper is not None:
            require(value <= rational(upper), f"Primal violates {variable['name']} upper bound")
    rows = {row["label"]: row for row in program["constraints"]}
    for row in rows.values():
        value = sum(rational(c) * x for c, x in zip(row["coefficients"], witness))
        rhs = rational(row["rhs"])
        if row["relation"] == "LE":
            require(value <= rhs, f"Primal violates {row['label']}")
        elif row["relation"] == "GE":
            require(value >= rhs, f"Primal violates {row['label']}")
        elif row["relation"] == "EQ":
            require(value == rhs, f"Primal violates {row['label']}")
        else:
            raise RuntimeError(f"Unknown LP relation: {row['relation']}")

    dual_rows = [
        ("vertical_upper", Fraction(1)),
        ("diagonal_lower", Fraction(-1)),
    ]
    coefficients = [Fraction(0)] * len(witness)
    bound = Fraction(0)
    for label, multiplier in dual_rows:
        row = rows[label]
        require(
            (row["relation"] == "LE" and multiplier >= 0)
            or (row["relation"] == "GE" and multiplier <= 0),
            f"Invalid upper-bound dual sign at {label}",
        )
        coefficients = [
            a + multiplier * rational(c)
            for a, c in zip(coefficients, row["coefficients"])
        ]
        bound += multiplier * rational(row["rhs"])
    dual_bounds = [(0, "lower_bound", -1), (1, "upper_bound", 1), (2, "upper_bound", 1)]
    for index, key, multiplier in dual_bounds:
        coefficients[index] += multiplier
        bound += multiplier * rational(variables[index][key])
    objective = [rational(c) for c in program["objective"]["coefficients"]]
    require(coefficients == objective, "Dual balance does not equal the original objective")
    attained = sum(c * x for c, x in zip(objective, witness))
    require(attained == bound == 7, "The claimed exact optimum was not reproduced")
    require(bound < 8, "Triangle bound does not exclude the chosen exit radius")
    return {
        "classification": "exact rational primal/dual certificate, supplementary to the general Lean proof",
        "scope": "H=1, endpoint image bound B=1; the diagonal y coordinate is at most 7",
        "primal": {variable["name"]: str(x) for variable, x in zip(variables, witness)},
        "dual_rows": [{"label": label, "multiplier": str(m)} for label, m in dual_rows],
        "dual_bounds": [
            {"variable": variables[i]["name"], "bound": key, "multiplier": str(m)}
            for i, key, m in dual_bounds
        ],
        "exact_optimum": str(bound),
        "excluded_exit_radius": "8",
        "general_parametric_theorem": "ThreeDirection.diagonal_bound_horizontal",
    }


def main():
    require((ROOT / "OBJECTIVE.md").is_file(), "Not the assigned campaign root")
    source = HERE / "Main.lean"
    fidelity = HERE / "statement_fidelity.md"
    source_text = source.read_text()
    imports = re.findall(r"^import\s+(.+)$", source_text, re.MULTILINE)
    require(imports == ["Mathlib"], "Campaign-specific imported oleans are not permitted")
    triangle = triangle_primal_dual()
    adapter = json.loads((HERE / "jacobian_output.json").read_text())
    require(adapter["ok"] is False, "Reassess the recorded adapter outcome before certifying")
    adapter_error = adapter["error"]["data"]
    require(adapter_error["code"] == "INVALID_REQUEST", "Unexpected adapter error classification")
    require(
        adapter_error["operation_id"] == "optimization.linear.rational_general_optimum.compute",
        "The adapter error is for a different operation",
    )

    native = run_module(
        "argus_skill.verticals.math.lean_evidence",
        [
            "verify",
            str(source),
            "--statement-fidelity",
            str(fidelity),
            "--project-root",
            str(ROOT),
            "--claim",
            CLAIM,
            "--timeout",
            "600",
        ],
    )
    outcome = json.loads(native["stdout"])
    require(outcome["status"] == "success", "Lean did not report success")
    require(outcome["exit_code"] == 0, "Lean compiler exit was not zero")
    require(outcome["proof_holes"] == [], "Lean proof holes were reported")
    require(
        outcome["source_sha256"] == hashlib.sha256(source.read_bytes()).hexdigest(),
        "The compiler result is stale for Main.lean",
    )
    require(
        outcome["statement_fidelity_sha256"]
        == hashlib.sha256(fidelity.read_text().encode()).hexdigest(),
        "The compiler result is stale for statement fidelity",
    )
    axiom_reports = dict(
        re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", outcome["stdout"])
    )
    require(set(axiom_reports) == DECLARATIONS, "Missing or unexpected transitive axiom reports")
    for declaration, report in axiom_reports.items():
        axioms = {item.strip() for item in report.split(",") if item.strip()}
        require(axioms == ALLOWED_AXIOMS, f"Unapproved transitive axiom in {declaration}: {axioms}")

    checks = [
        run_module(
            "argus_skill.verticals.math.math_state",
            ["check", "--project-root", str(ROOT)],
        ),
        run_module(
            "argus_skill.verticals.math.proof_graph_check",
            ["check", "--project-root", str(ROOT)],
        ),
    ]
    require(json.loads(checks[0]["stdout"])["ok"] is True, "Claim ledger check did not pass")
    certificate = {
        "claim_id": CLAIM,
        "result_class": "exact_verification_theorem",
        "scope": "The fixed-scale radial-comparison bridge, not the global halving-line theorem",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "independent_review": {"required": True, "status": "pending", "next_owner": "reviewer"},
        "novelty_status": "not_claimed_before_independent_review",
        "refuted_manuscript_assertions": [],
        "formal_declaration": "RankRadial.NormalizedRankData.iterated_radial",
        "constant": "C_p=16*K^2/a; K=norm(B)+norm(B^-1)+1; a>0 derived from projective separation",
        "quantifiers": "exists C>0, forall integer T>=2, exists delta>0, forall fixed 0<h<delta, eventually j, both radial inequalities",
        "source_realization": {
            "artifact": relative(HERE / "proof.md"),
            "classification": "complete prose identification with the staged rank hypotheses; independent review pending",
        },
        "lean": {
            "source": relative(source),
            "statement_fidelity": relative(fidelity),
            "source_sha256": outcome["source_sha256"],
            "statement_fidelity_sha256": outcome["statement_fidelity_sha256"],
            "exit_code": outcome["exit_code"],
            "proof_holes": outcome["proof_holes"],
            "axioms": {name: sorted(ALLOWED_AXIOMS) for name in sorted(axiom_reports)},
            "official_result": relative(HERE / "lean_check.json"),
            "official_compile_log": relative(HERE / "compile.log"),
            "kernel_recording": outcome["kernel"],
        },
        "rational_triangle_replay": triangle,
        "jacobian": {
            "server": {"name": "jacobian", "version": "0.14.0"},
            "protocol_version": "2025-11-25",
            "transport": "mcp-stdio",
            "operation_id": adapter_error["operation_id"],
            "payload": relative(HERE / "jacobian_payload.json"),
            "typed_output": relative(HERE / "jacobian_output.json"),
            "adapter_exit_code": 2,
            "status": "INVALID_REQUEST",
            "mathematical_conclusion": "none; simplex-basis admission limit rejected the request",
        },
        "official_checks": checks,
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    action = {
        "ts": datetime.now(timezone.utc).isoformat(),
        "role": "engineer",
        "agent": "gpt-6.1-sol",
        "kind": "certification",
        "action": (
            "Replayed the standalone Lean radial theorem, checked all transitive axioms, "
            "replayed the exact rational triangle certificate, and passed both official "
            f"checks at {ROOT}; both exit statuses are 0. Independent Reviewer replay is pending."
        ),
        "status": "verified_engineer_pending_independent_review",
        "artifact": relative(HERE / "exact_certificate.json"),
    }
    with (ROOT / "activity.jsonl").open("a") as stream:
        stream.write(json.dumps(action) + "\n")
    print(
        json.dumps(
            {
                "claim": CLAIM,
                "lean_exit_code": 0,
                "proof_holes": [],
                "axiom_reports_checked": len(axiom_reports),
                "project_root": str(ROOT),
                "math_state_exit_code": checks[0]["exit_code"],
                "proof_graph_exit_code": checks[1]["exit_code"],
                "certificate": relative(HERE / "exact_certificate.json"),
                "independent_review": "pending",
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
