#!/usr/bin/env python3
"""Replay exact certificates, not the non-formalized analytic proof."""

import argparse
from fractions import Fraction
import hashlib
import json
from math import lcm
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "optimization.linear.rational_general_optimum.compute"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text())


def rational(value):
    result = Fraction(int(value["num"]), int(value["den"]))
    require(
        str(result.numerator) == value["num"]
        and str(result.denominator) == value["den"],
        "noncanonical typed rational",
    )
    return result


def dot(left, right):
    require(len(left) == len(right), "vector dimension mismatch")
    return sum((a * b for a, b in zip(left, right)), Fraction(0))


def check_jacobian(certificate):
    metadata = certificate["jacobian"]
    status = read_json(ROOT / metadata["adapter_status"])
    require(status["exit_code"] == 0, "Jacobian adapter did not succeed")
    require(status["adapter_status"] == "returned", "Jacobian did not return")
    require(status["operation_id"] == OPERATION, "wrong adapter operation")

    payload = read_json(ROOT / metadata["payload"])
    response = read_json(ROOT / metadata["typed_result"])
    require(response["schema_version"] == 1, "wrong Jacobian schema")
    require(
        response["protocol_version"] == metadata["protocol_version"],
        "wrong Jacobian protocol",
    )
    require(
        response["server"]["version"] == metadata["server_version"],
        "wrong Jacobian server version",
    )
    require(response["request"]["operation_id"] == OPERATION, "wrong operation")
    require(response["request"]["payload"] == payload, "payload was not preserved")
    require(response["result"]["operation_id"] == OPERATION, "wrong result operation")
    output = response["result"]["output"]
    require(output["status"] == "OPTIMAL", "UNKNOWN or incomplete LP is not evidence")
    program = payload["program"]
    require(output["program"] == program, "result changed original coordinates")
    require(program["objective"]["sense"] == "MAXIMIZE", "unexpected objective")
    require(
        [v["name"] for v in program["variables"]]
        == ["range_only_leak", "quotient_first_leak"],
        "the diagnostic variables changed",
    )
    require(
        program["constraints"]
        == [
            {
                "label": "exact_source_quotient_zero",
                "coefficients": [
                    {"num": "0", "den": "1"},
                    {"num": "1", "den": "1"},
                ],
                "relation": "EQ",
                "rhs": {"num": "0", "den": "1"},
            }
        ],
        "the exact source-zero row changed",
    )
    require(
        program["objective"]["coefficients"]
        == [{"num": "1", "den": "1"}, {"num": "-1", "den": "1"}],
        "the diagnostic objective changed",
    )

    point = [rational(v) for v in output["primal_candidate"]]
    objective = [rational(v) for v in program["objective"]["coefficients"]]
    rows = program["constraints"]
    row_dual = [rational(v) for v in output["constraint_dual"]]
    lower_dual = [rational(v) for v in output["lower_bound_dual"]]
    upper_dual = [rational(v) for v in output["upper_bound_dual"]]
    require(len(point) == 2, "wrong primal dimension")
    require(len(row_dual) == len(rows), "wrong row-dual dimension")
    require(len(lower_dual) == len(point), "wrong lower-dual dimension")
    require(len(upper_dual) == len(point), "wrong upper-dual dimension")

    dual_value = Fraction(0)
    balance = [lower_dual[i] + upper_dual[i] for i in range(len(point))]
    for row, multiplier in zip(rows, row_dual):
        coefficients = [rational(v) for v in row["coefficients"]]
        rhs = rational(row["rhs"])
        value = dot(coefficients, point)
        relation = row["relation"]
        if relation == "EQ":
            require(value == rhs, "primal equality failed")
        elif relation == "LE":
            require(value <= rhs and multiplier >= 0, "LE primal/dual failed")
        elif relation == "GE":
            require(value >= rhs and multiplier <= 0, "GE primal/dual failed")
        else:
            raise ValueError("unrecognized LP relation")
        require(multiplier * (value - rhs) == 0, "row complementarity failed")
        dual_value += multiplier * rhs
        balance = [
            entry + multiplier * coefficient
            for entry, coefficient in zip(balance, coefficients)
        ]

    for i, variable in enumerate(program["variables"]):
        lower = rational(variable["lower_bound"])
        upper = rational(variable["upper_bound"])
        require(lower == 0 and upper == 1, "diagnostic bounds changed")
        require(lower <= point[i] <= upper, "primal bound failed")
        require(lower_dual[i] <= 0 <= upper_dual[i], "dual-bound sign failed")
        require(lower_dual[i] * (point[i] - lower) == 0, "lower complementarity")
        require(upper_dual[i] * (upper - point[i]) == 0, "upper complementarity")
        dual_value += lower_dual[i] * lower + upper_dual[i] * upper

    primal_value = dot(objective, point)
    require(balance == objective, "dual stationarity failed")
    require(primal_value == dual_value == Fraction(metadata["objective"]), "duality gap")
    require(rational(output["primal_objective"]) == primal_value, "wrong primal report")
    require(rational(output["dual_objective"]) == dual_value, "wrong dual report")
    require(point == [Fraction(1), Fraction(0)], "wrong diagnostic witness")
    return str(primal_value)


def scaled_rank(coefficient, value):
    if coefficient == 0 or value == 0:
        return Fraction(0)
    return None if value is None else coefficient * value


def rank_sum(values):
    return None if any(v is None for v in values) else sum(values, Fraction(0))


def rank_le(left, right):
    return right is None or (left is not None and left <= right)


def check_rank_examples(examples):
    controllers = [
        None if value == "infinity" else Fraction(value)
        for value in examples["rank_controller_cases"]
    ]
    checked = 0
    for tests in range(examples["maximum_test_count"] + 1):
        for i in range(max(1, tests)):
            for controller in controllers:
                for pattern in range(3):
                    for omit_alternate in (False, True):
                        ranks = []
                        budget = 0
                        for sector in range(2**tests):
                            active = bool(sector & (1 << i))
                            multiplicity = (sector + pattern) % 3
                            bound = scaled_rank(multiplicity, controller)
                            rank = bound if active else Fraction(0)
                            if omit_alternate and sector % 2:
                                rank = Fraction(0)
                            ranks.append(rank)
                            if active:
                                budget += multiplicity
                        total = rank_sum(ranks)
                        require(
                            rank_le(total, scaled_rank(budget, controller)),
                            "extended-rank consistency example failed",
                        )
                        if controller == 0:
                            require(total == 0, "zero-controller conclusion failed")
                        if controller is not None and controller <= 1:
                            require(
                                rank_le(total, Fraction(budget)),
                                "finite whole-cap example failed",
                            )
                        checked += 1
    require(checked == examples["rank_case_count"], "rank-example coverage changed")
    require(not rank_le(Fraction(1), Fraction(0)), "missing-zero witness failed")
    return checked


def check_averaging(examples):
    data = examples["averaging"]
    weights = [Fraction(value) for value in data["weights"]]
    spectra = [[Fraction(value) for value in row] for row in data["internal_spectra"]]
    require(sum(weights) == 1 and all(w > 0 for w in weights), "invalid convex weights")
    require(len(weights) == len(spectra), "averaging data dimension mismatch")
    require(all(0 <= x <= 1 for row in spectra for x in row), "invalid diagonal spectra")
    cut = Fraction(data["cut"])
    first = sum(w * sum(row) for w, row in zip(weights, spectra))
    square = sum(w * sum(x * x for x in row) for w, row in zip(weights, spectra))
    rank = sum(w * sum(x > cut for x in row) for w, row in zip(weights, spectra))
    require(first == Fraction(data["first_moment"]), "first moment changed")
    require(square == Fraction(data["square_moment"]), "square moment changed")
    require(rank == Fraction(data["cut_rank"]), "cut rank changed")
    denominator = lcm(*(w.denominator for w in weights))
    width = max(map(len, spectra))
    for multiplier in data["denominator_multipliers"]:
        require(isinstance(multiplier, int) and multiplier > 0, "invalid multiplier")
        blocks = denominator * multiplier
        diagonal = []
        for weight, row in zip(weights, spectra):
            multiplicity = weight * blocks
            require(multiplicity.denominator == 1, "nonintegral multiplicity")
            padded = row + [Fraction(0)] * (width - len(row))
            diagonal.extend(padded * multiplicity.numerator)
        require(Fraction(sum(diagonal), blocks) == first, "first trace normalization")
        require(
            Fraction(sum(x * x for x in diagonal), blocks) == square,
            "square trace normalization",
        )
        require(
            Fraction(sum(x > cut for x in diagonal), blocks) == rank,
            "rank normalization",
        )
    lower = examples["lower_constant"]
    epsilon, norm = Fraction(lower["epsilon"]), Fraction(lower["norm_y"])
    require(epsilon > 0 and norm >= 0, "invalid lower-bound parameters")
    constant = 2 * norm * norm / (epsilon * epsilon)
    require(constant == Fraction(lower["value"]), "lower constant changed")
    return {"first": str(first), "square": str(square), "cut_rank": str(rank)}


def check_formal_record(certificate):
    core = certificate["formal_core"]
    archive_path = ROOT / core["certificate"]
    archive = read_json(archive_path)
    result = archive["lean_check"]
    require(archive["verdict"] == "supports", "formal archive does not support claim")
    require(archive["tier"] == "mechanical", "formal archive is not mechanical evidence")
    require(result["status"] == "success" and result["exit_code"] == 0, "Lean failed")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require(result["audit_exit_code"] == 0, "Lean axiom audit failed")
    require(result["environment_failure"] == "", "Lean environment was not verified")
    require(
        f"version {core['lean_version']}," in result["tools"]["lean"]["version"],
        "wrong Lean version",
    )
    source = ROOT / core["source"]
    fidelity = ROOT / core["statement_fidelity"]
    require(archive["lean_source"]["text"] == source.read_text(), "source archive is stale")
    require(
        archive["statement_fidelity"]["text"] == fidelity.read_text(),
        "statement-fidelity archive is stale",
    )
    require(
        hashlib.sha256(source.read_bytes()).hexdigest() == result["source_sha256"],
        "source no longer matches the real compiler stamp",
    )
    require(
        hashlib.sha256(fidelity.read_text().encode()).hexdigest()
        == result["statement_fidelity_sha256"],
        "fidelity no longer matches the real compiler stamp",
    )
    ledger = read_json(ROOT / "research/MATH_STATE.json")
    claim = next(
        c for c in reversed(ledger["claims"]) if c["claim_id"] == core["claim"]
    )
    require(claim["formal_statement"] == source.read_text(), "ledger translation is stale")
    require(
        archive["subject"]["content_hash"] == claim["content_hash"],
        "archive is about an old claim",
    )
    require(
        any(
            record["subject"] == archive["subject"]
            and record["tier"] == "mechanical"
            and record["verdict"] == "supports"
            and record["artifact"] == core["certificate"]
            for record in ledger["evidence"]
        ),
        "compiler evidence is not attached to the claim",
    )
    return core["claim"]


def compile_and_check():
    command = [
        ARGUS_PYTHON,
        "-m",
        "argus_skill.verticals.math.lean_evidence",
        "verify",
        str(HERE / "Main.lean"),
        "--statement-fidelity",
        str(HERE / "statement_fidelity.md"),
        "--claim",
        "C_EXTENDED_SUPPORT",
        "--project-root",
        str(ROOT),
        "--timeout",
        "90",
    ]
    compiled = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
    if compiled.returncode:
        print(compiled.stdout, end="", file=sys.stderr)
        print(compiled.stderr, end="", file=sys.stderr)
    codes = [compiled.returncode]
    for module in ("math_state", "proof_graph_check"):
        result = subprocess.run(
            [
                ARGUS_PYTHON,
                "-m",
                f"argus_skill.verticals.math.{module}",
                "check",
                "--project-root",
                str(ROOT),
            ],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        if result.returncode:
            print(result.stdout, end="", file=sys.stderr)
            print(result.stderr, end="", file=sys.stderr)
        codes.append(result.returncode)
    require(all(code == 0 for code in codes), f"compile/check exits: {codes}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--compile",
        action="store_true",
        help="also replay the real Lean compiler, record evidence, and run both official checks",
    )
    args = parser.parse_args()
    if args.compile:
        compile_and_check()
    certificate = read_json(HERE / "exact_certificate.json")
    require(certificate["project_root"] == str(ROOT), "wrong campaign project root")
    require(certificate["claim"] == "C_TC_FINITE", "wrong bounded proposition")
    require((ROOT / certificate["proof"]).is_file(), "analytic proof is missing")
    require(
        certificate["refuted_manuscript_assertions"] == [],
        "a manuscript refutation requires its own dedicated ledger judgement",
    )
    output = {
        "status": "passed",
        "formal_core": check_formal_record(certificate),
        "formal_recompiled": args.compile,
        "jacobian_diagnostic_optimum": check_jacobian(certificate),
        "extended_rank_examples": check_rank_examples(
            certificate["finite_consistency_examples"]
        ),
        "normalized_averaging": check_averaging(certificate["finite_consistency_examples"]),
        "analytic_proposition": "proof supplied; independent Host review required",
        "classification_theorem": "not certified",
    }
    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, KeyError, StopIteration, ZeroDivisionError) as error:
        print(f"verification failed: {error}", file=sys.stderr)
        raise SystemExit(1)
