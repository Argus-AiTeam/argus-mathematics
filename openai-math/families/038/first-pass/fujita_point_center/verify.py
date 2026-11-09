#!/usr/bin/env python3
"""Replay exact algebra and regressions; optionally obtain a fresh Lean verdict."""

import argparse
import hashlib
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
VARIABLES = ["d", "sigma", "t", "n", "a"]
ZERO = (0,) * len(VARIABLES)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load(name):
    return json.loads((HERE / name).read_text(encoding="utf-8"))


def rational(value):
    q = Fraction(int(value["num"]), int(value["den"]))
    require(
        value == {"num": str(q.numerator), "den": str(q.denominator)},
        "Noncanonical rational in Jacobian evidence",
    )
    return q


def polynomial(value):
    require(value["domain"] == "QQ", "Expected a QQ polynomial")
    require(value["variables"] == VARIABLES, "Polynomial variable order changed")
    result = {}
    exponents = []
    for term in value["polynomial"]["terms"]:
        exponent = tuple(term["exponents"])
        require(
            len(exponent) == len(VARIABLES)
            and all(type(e) is int and e >= 0 for e in exponent),
            "Invalid polynomial exponent",
        )
        coefficient = rational(term["coefficient"])
        require(coefficient != 0 and exponent not in result, "Invalid sparse polynomial")
        result[exponent] = coefficient
        exponents.append(exponent)
    require(exponents == sorted(exponents, reverse=True), "Noncanonical term order")
    return result


def add(*values):
    result = {}
    for value in values:
        for exponent, coefficient in value.items():
            result[exponent] = result.get(exponent, Fraction(0)) + coefficient
    return {exponent: q for exponent, q in result.items() if q}


def scale(value, q):
    return {exponent: coefficient * q for exponent, coefficient in value.items() if coefficient * q}


def multiply(left, right):
    result = {}
    for x, a in left.items():
        for y, b in right.items():
            exponent = tuple(i + j for i, j in zip(x, y))
            result[exponent] = result.get(exponent, Fraction(0)) + a * b
    return {exponent: q for exponent, q in result.items() if q}


def constant(q):
    return {ZERO: Fraction(q)} if q else {}


def variable(index):
    return {tuple(int(i == index) for i in range(len(VARIABLES))): Fraction(1)}


def exact_algebra():
    d, sigma, t, n, a = map(variable, range(len(VARIABLES)))
    n1, n2 = add(n, constant(1)), add(n, constant(2))
    numerator = add(
        multiply(multiply(multiply(d, sigma), t), n2),
        multiply(multiply(d, sigma), a),
        scale(multiply(multiply(d, n1), n2), -1),
    )
    factored = multiply(
        d,
        add(
            multiply(sigma, add(multiply(t, n2), a)),
            scale(multiply(n1, n2), -1),
        ),
    )
    require(numerator == factored, "Wrong denominator-cleared margin identity")

    payload = load("jacobian_payload.json")
    output = load("jacobian_output.json")
    require((HERE / "jacobian_exit_status.txt").read_text().strip() == "0", "Adapter failed")
    require((HERE / "jacobian_stderr.txt").read_text() == "", "Adapter reported an error")
    require(output["server"]["version"] == "0.14.0", "Unexpected recorded server version")
    require(output["protocol_version"] == "2025-11-25", "Unexpected recorded protocol")
    operation = "polynomial.multivariate.factor.compute"
    require(output["request"]["operation_id"] == operation, "Wrong requested operation")
    require(output["result"]["operation_id"] == operation, "Wrong result operation")
    require(output["request"]["payload"] == payload, "Adapter payload does not match")
    require(polynomial(payload["polynomial"]) == numerator, "Payload is not the claimed margin")
    result = output["result"]["output"]
    require(result["status"] == "FACTORIZED", "No mathematical factorization conclusion")
    require(result["product_reconstruction"] == "EXACT", "Inexact factorization")
    reconstructed = constant(rational(result["coefficient"]))
    for factor in result["factors"]:
        multiplicity = factor["multiplicity"]
        require(type(multiplicity) is int and 1 <= multiplicity <= 64, "Invalid multiplicity")
        for _ in range(multiplicity):
            reconstructed = multiply(reconstructed, polynomial(factor["factor"]))
    require(reconstructed == numerator, "Independent factor multiplication failed")
    require(polynomial(result["reconstructed"]) == numerator, "Wrong retained polynomial")
    return {
        "ring": "QQ[d,sigma,t,n,a]",
        "margin_numerator": "d*(sigma*(t*(n+2)+a)-(n+1)*(n+2))",
        "positive_denominator": "t*(n+1)*(n+2), for t>0 and n>=0",
        "factor_reconstruction": "exact",
        "operation_id": operation,
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "adapter_exit_status": 0,
        "typed_status": result["status"],
        "structured_error": None,
    }


def nonempty_subsets(points):
    for size in range(1, len(points) + 1):
        yield from itertools.combinations(points, size)


def moment_regressions():
    counts = {}
    for dimension, side in [(1, 3), (2, 3), (3, 2)]:
        points = list(itertools.product(range(side), repeat=dimension))
        count = 0
        for subset in nonempty_subsets(points):
            size = len(subset)
            moment = sum(map(sum, subset))
            left = ((dimension + 1) * (2 * moment + dimension * size)) ** dimension
            right = (2 * dimension * size) ** dimension * math.factorial(dimension) * size
            require(left >= right, f"Simplex moment regression failed: {subset}")
            count += 1
        counts[str(dimension)] = count
    return counts


def discrete_bm_regressions():
    counts = {}
    for dimension, side in [(1, 3), (2, 2), (3, 2), (4, 2)]:
        points = list(itertools.product(range(side), repeat=dimension))
        cube = list(itertools.product(range(2), repeat=dimension))
        families = list(nonempty_subsets(points)) if dimension <= 2 else [(points[0],), tuple(points)]
        count = 0
        for left, right in itertools.product(families, repeat=2):
            summed = {
                tuple(a + b + c for a, b, c in zip(x, y, z))
                for x, y, z in itertools.product(left, right, cube)
            }
            size, a, b = len(summed), len(left), len(right)
            if dimension == 1:
                valid = size >= a + b
            elif dimension == 2:
                valid = size >= a + b and (size - a - b) ** 2 >= 4 * a * b
            else:
                root_a, root_b = (1 if a == 1 else 2), (1 if b == 1 else 2)
                require(root_a**dimension == a and root_b**dimension == b, "Nonintegral fixture root")
                valid = size >= (root_a + root_b) ** dimension
            require(valid, f"Discrete Brunn-Minkowski regression failed in dimension {dimension}")
            count += 1
        counts[str(dimension)] = count
    return counts


def section_fixture():
    def data(j):
        q = sum((Fraction(1, 2**p) * (j - p + 1) for p in range(j + 1)), Fraction(0))
        b = sum((Fraction(1, 2**p) * (j - p + 1) ** 2 for p in range(j + 1)), Fraction(0))
        u = sum(
            (Fraction((j - p) * (j - p + 1), 2 * 2**p) for p in range(j + 1)),
            Fraction(0),
        )
        require(u + q / 2 == b / 2, "Wrong exact cube moment")
        return q, b, u

    growth_cases = 0
    for j in range(13):
        q, b, _ = data(j)
        for h in range(1, 4):
            require(data(j + h)[1] >= b + 2 * h * q, "Wrong weighted slice-growth sign")
            growth_cases += 1
    m, t = 12, 3
    q, _, u = data(m)
    mean = u / (m * q)
    derivative = Fraction(1, t) - mean
    require(derivative < 0, "Fixture must exhibit a descent direction, not a minimizer")
    require(
        mean + Fraction(1, 2 * m)
        >= sum((Fraction(4, m) * data(j)[0] / q for j in (4, 8)), Fraction(0)),
        "Wrong partition factor",
    )
    return {
        "variety": "P^2, L=O(1), ordinary degree-12 monomial basis",
        "test": "v=12*log(2)*ord_line; center is a line",
        "transverse_weights": "exp(-ell(p)/12)=2^(-p)",
        "normalized_tangential_moment": str(mean),
        "normalized_right_derivative_at_t_3": str(derivative),
        "conclusion": "This particular positive-center test is not minimizing; it is not a counterexample.",
        "weighted_growth_cases": growth_cases,
        "cube_moment": "exact equality with d/2, in every tested slice",
    }


def partition_regressions():
    count = 0
    for n, u, length in itertools.product(
        range(1, 11), [Fraction(0), Fraction(1, 2), Fraction(1), Fraction(3, 2)], [2, 3, 7, 17]
    ):
        s = sum((Fraction(i, length) ** n for i in range(length)), Fraction(0)) / length
        s_next = sum((Fraction(i, length) ** (n + 1) for i in range(length)), Fraction(0)) / length
        require(Fraction(1, n + 1) - Fraction(1, length) <= s <= Fraction(1, n + 1),
                "Power Riemann comparison failed")
        polynomial_sum = (1 + u) * s - u * s_next
        lower = Fraction(1, n + 1) + u / ((n + 1) * (n + 2)) - (1 + u) / length
        require(polynomial_sum >= lower, "Wrong explicit partition error")
        count += 1
    return count


def compile_fresh():
    command = [
        ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"), "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--claim", "PC9000038", "--project-root", str(ROOT), "--timeout", "110",
    ]
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=False)
    (HERE / "lean_verify.json").write_text(result.stdout, encoding="utf-8")
    (HERE / "lean_verify.stderr").write_text(result.stderr, encoding="utf-8")
    validation = {"project_root": str(ROOT), "lean_exit_status": result.returncode}
    for module, key, filename in [
        ("math_state", "math_state_exit_status", "math_state_check.json"),
        ("proof_graph_check", "proof_graph_exit_status", "proof_graph_check.txt"),
    ]:
        checked = subprocess.run(
            [ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}", "check",
             "--project-root", str(ROOT)],
            cwd=ROOT, text=True, capture_output=True, check=False,
        )
        (HERE / filename).write_text(checked.stdout + checked.stderr, encoding="utf-8")
        validation[key] = checked.returncode
    (HERE / "validation.json").write_text(json.dumps(validation, indent=2) + "\n", encoding="utf-8")
    require(all(validation[k] == 0 for k in validation if k != "project_root"),
            "Fresh compiler or official structural check failed; inspect recorded outputs")


def formal_evidence():
    result = load("lean_verify.json")
    require(result["status"] == "success" and result["exit_code"] == 0, "Lean has not succeeded")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0, "Axiom audit did not pass")
    require("sorryAx" not in result["stdout"], "Compiler reported an unproved axiom")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "Wrong Lean version")
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text(encoding="utf-8")
    require(hashlib.sha256(source).hexdigest() == result["source_sha256"], "Stale source verdict")
    require(hashlib.sha256(fidelity.encode()).hexdigest() == result["statement_fidelity_sha256"],
            "Stale statement-fidelity verdict")
    require(Path(result["source"]).resolve() == HERE / "Main.lean", "Wrong compiled source")
    require(result["kernel"]["refusals"] == [], "Mechanical recording was refused")
    record = result["kernel"]["recorded"]
    require(record["tier"] == "mechanical" and record["verdict"] == "supports", "No kernel support")
    require(record["subject"]["subject_id"] == "PC9000038", "Wrong certified claim")
    archive_path = (ROOT / record["artifact"]).resolve()
    require(archive_path.parent == HERE / "certificates", "Certificate outside the assigned artifact directory")
    archive = json.loads(archive_path.read_text(encoding="utf-8"))
    require(archive["lean_source"]["text"] == source.decode("utf-8"), "Archived source mismatch")
    require(archive["statement_fidelity"]["text"] == fidelity, "Archived fidelity mismatch")
    require(archive["subject"] == record["subject"], "Archived claim mismatch")
    for key in ["source_sha256", "statement_fidelity_sha256", "exit_code", "proof_holes", "audit_exit_code"]:
        require(archive["lean_check"][key] == result[key], f"Archived compiler field mismatch: {key}")
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text(encoding="utf-8"))
    current = max((c for c in ledger["claims"] if c["claim_id"] == "PC9000038"),
                  key=lambda c: c["version"])
    require(current["content_hash"] == record["subject"]["content_hash"], "Claim has been restated")
    require(current["formal_statement"] == source.decode("utf-8"), "Formal claim/source mismatch")
    return {
        "claim_id": "PC9000038",
        "certificate": record["artifact"],
        "lean_version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "axiom_audit_exit_code": 0,
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "main_theorem": "PointCenter.partition_obstruction",
        "quantification": "all natural n; all integers l>=2; positive real d,t,sigma; a>=0",
        "scope": "Formal finite weighted-growth and partition obstruction, not the unformalized geometry.",
    }


def certificate():
    algebra = exact_algebra()
    moments = moment_regressions()
    sums = discrete_bm_regressions()
    fixture = section_fixture()
    partitions = partition_regressions()
    formal = formal_evidence()
    validation = load("validation.json")
    require(validation["project_root"] == str(ROOT), "Checks ran against a different project root")
    for key in ["lean_exit_status", "math_state_exit_status", "proof_graph_exit_status"]:
        require(validation[key] == 0, f"Required validation failed: {key}")
    return {
        "claim_id": "PCBRIDGE9000038",
        "result_type": "conditional_universal_verification_theorem",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "statement": (
            "Under the explicitly exposed upstream minimizer and specialization hypotheses, "
            "every t in [t0,n+1) with t>n+1-a/(n+2) has only point-centered minimizing pairs "
            "in all sufficiently late degrees of any positive-liminf subsequence. "
            "Integral centers, degrees, and models may vary."
        ),
        "proof": "report.md, Sections 1-7; unformalized geometric passages require mathematical review.",
        "structural_generalization": "Uniform pure-slice slope sigma forces sigma*(t+a/(n+2))<=n+1.",
        "exact_algebra": algebra,
        "formal_evidence": formal,
        "finite_regressions": {
            "purpose": "Adversarial regression only, not a proof by bounded exhaustion.",
            "simplex_moment_cases_by_dimension": moments,
            "discrete_bm_cases_by_dimension": sums,
            "rational_partition_cases": partitions,
            "section_ring_fixture": fixture,
        },
        "official_validation": validation,
        "independent_review": "Not established or represented by this script.",
        "novelty_status": "unverified",
        "significance_status": "awaiting_independent_review",
        "fujita_conjecture_certified": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compile", action="store_true",
                        help="Obtain a fresh host Lean compiler verdict and official campaign-local checks.")
    parser.add_argument("--write-certificate", action="store_true",
                        help="Write the deterministic certificate instead of comparing it with the saved one.")
    args = parser.parse_args()
    if args.compile:
        compile_fresh()
    result = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    else:
        require(result == load(path.name), "Saved certificate does not match exact replay")
    print(json.dumps({
        "status": "exact_replay_passed",
        "universal_formal_claim": result["formal_evidence"]["claim_id"],
        "lean_exit_code": result["formal_evidence"]["exit_code"],
        "proof_holes": result["formal_evidence"]["proof_holes"],
        "independent_review": "pending",
        "certificate": str(path.relative_to(ROOT)),
    }, sort_keys=True))


if __name__ == "__main__":
    main()
