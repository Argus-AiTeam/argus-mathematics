#!/usr/bin/env python3
"""Replay exact supporting evidence, not a numerical singularity test."""

import argparse
from fractions import Fraction as Q
import hashlib
import json
from math import isqrt
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SEEDS = {
    "P1": (13, (Q(1, 2), Q(-1, 2)), [1, -1, -1, -1, 1]),
    "P2": (2, (Q(1), Q(-1)), [1, -2, 1, -2, 1]),
}


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def quadratic_mul(x, y, d):
    a, b = x
    c, e = y
    return a * c + d * b * e, a * e + b * c


def quadratic_sign(x, d):
    a, b = x
    if b == 0:
        return (a > 0) - (a < 0)
    if a == 0:
        return (b > 0) - (b < 0)
    if (a > 0) == (b > 0):
        return (a > 0) - (a < 0)
    difference = a * a - d * b * b
    return ((a > 0) - (a < 0)) * (
        (difference > 0) - (difference < 0)
    )


def subtract(x, y):
    return x[0] - y[0], x[1] - y[1]


def return_delta_squared(t, d, k):
    previous, current = (Q(2), Q(0)), t
    for _ in range(1, k):
        previous, current = current, subtract(
            quadratic_mul(t, current, d), previous
        )
    return subtract((Q(4), Q(0)), quadratic_mul(current, current, d))


def seed_witness(name, k):
    d, t, coefficients = SEEDS[name]
    require(isinstance(k, int) and k > 0, f"{name}: invalid exponent")
    require(isqrt(d) ** 2 != d, f"{name}: field is not quadratic")
    y = (t[0], -t[1])
    require(quadratic_sign(subtract(y, (Q(2), Q(0))), d) > 0,
            f"{name}: y is not greater than 2")
    require(quadratic_sign(subtract((Q(5, 2), Q(0)), y), d) > 0,
            f"{name}: y is not less than 5/2")
    require(quadratic_sign(subtract(t, (Q(-2), Q(0))), d) > 0
            and quadratic_sign(subtract((Q(2), Q(0)), t), d) > 0,
            f"{name}: unit-circle trace outside (-2,2)")
    require(quadratic_sign(
        subtract(y, (Q(17, 10) + Q(10, 17), Q(0))), d) > 0,
        f"{name}: beta>17/10 was not certified")
    require(Q(17, 10) - Q(10, 17) > 1, "A_1 lower bound failed")
    y_squared = quadratic_mul(y, y, d)
    t_squared = quadratic_mul(t, t, d)
    require(quadratic_sign(subtract(y_squared, (Q(4), Q(0))), d) > 0
            and quadratic_sign(subtract(t_squared, (Q(4), Q(0))), d) < 0,
            f"{name}: irreducibility sign obstruction failed")
    trace_sum = y[0] + t[0]
    trace_product = quadratic_mul(y, t, d)
    require(y[1] + t[1] == 0 and trace_product[1] == 0,
            f"{name}: traces did not descend to Q")
    reconstructed = [
        Q(1), -trace_sum, trace_product[0] + 2, -trace_sum, Q(1)
    ]
    require(reconstructed == coefficients, f"{name}: wrong polynomial")
    delta_squared = return_delta_squared(t, d, k)
    require(quadratic_sign(delta_squared, d) > 0,
            f"{name}: return is zero")
    require(quadratic_sign(
        subtract((Q(1, 256), Q(0)), delta_squared), d) > 0,
        f"{name}: actual delta_1<1/16 postcondition failed")
    return {
        "polynomial_descending": coefficients,
        "radicand": d,
        "unit_circle_trace": [str(t[0]), str(t[1])],
        "k_1": k,
        "delta_1_squared": [str(x) for x in delta_squared],
        "verified_postconditions": [
            "quartic irreducible Salem polynomial",
            "1 < beta < 2",
            "beta > 17/10 and A_1 > 1",
            "0 < delta_1_squared < 1/256",
        ],
    }


def first_seed(name):
    d, t, _ = SEEDS[name]
    for k in range(1, 513):
        delta_squared = return_delta_squared(t, d, k)
        if (quadratic_sign(delta_squared, d) > 0
                and quadratic_sign(
                    subtract((Q(1, 256), Q(0)), delta_squared), d) > 0):
            return k
    raise RuntimeError(f"{name}: bounded seed discovery found no witness")


def trim(p):
    p = list(p)
    while p and p[-1] == 0:
        p.pop()
    return p


def remainder(a, b):
    a, b = trim(a), trim(b)
    require(bool(b), "division by the zero polynomial")
    while len(a) >= len(b):
        shift = len(a) - len(b)
        scale = a[-1] / b[-1]
        for i, coefficient in enumerate(b):
            a[shift + i] -= scale * coefficient
        a = trim(a)
    return a


def evaluate(p, x):
    answer = Q(0)
    for coefficient in reversed(p):
        answer = answer * x + coefficient
    return answer


def variations(signs):
    signs = [s for s in signs if s]
    return sum(a != b for a, b in zip(signs, signs[1:]))


def jacobian_check():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    require(response["request"]["payload"] == payload,
            "Jacobian result is not bound to the exact payload")
    require(response["request"]["operation_id"] == "polynomial.roots.isolate"
            and response["result"]["operation_id"] == "polynomial.roots.isolate",
            "wrong Jacobian operation")
    require(response["server"]["name"] == "jacobian"
            and response["server"]["version"] == "0.14.0",
            "unexpected Jacobian server")
    require(response["protocol_version"] == "2025-11-25",
            "unexpected Jacobian protocol")
    require("error" not in response and "error" not in response["result"],
            "Jacobian returned a structured error")
    p = [Q(int(c["num"]), int(c["den"]))
         for c in reversed(payload["coefficients_descending"])]
    require(p == [Q(c) for c in reversed(SEEDS["P1"][2])],
            "wrong root-isolation polynomial")
    sequence = [p, [i * p[i] for i in range(1, len(p))]]
    while sequence[-1]:
        r = remainder(sequence[-2], sequence[-1])
        if not r:
            break
        sequence.append([-c for c in r])
    require(len(sequence[-1]) == 1, "polynomial has a repeated root")

    def at(x):
        return variations([
            (evaluate(poly, x) > 0) - (evaluate(poly, x) < 0)
            for poly in sequence
        ])

    infinity_positive = variations([
        (poly[-1] > 0) - (poly[-1] < 0) for poly in sequence
    ])
    infinity_negative = variations([
        ((poly[-1] > 0) - (poly[-1] < 0)) * (-1) ** (len(poly) - 1)
        for poly in sequence
    ])
    require(infinity_negative - infinity_positive == 2,
            "Sturm calculation did not give exactly two real roots")
    output = response["result"]["output"]
    require(output["convention"] == "SYMPY_REAL_ROOTS",
            "unrecognized root convention")
    require(output["multiplicities"] == [1, 1]
            and len(output["roots"]) == 2, "wrong multiplicities")
    intervals = []
    for pair in output["roots"]:
        lower, upper = [Q(int(c["num"]), int(c["den"])) for c in pair]
        require(lower < upper and evaluate(p, lower) != 0
                and evaluate(p, upper) != 0, "invalid isolating endpoints")
        require(at(lower) - at(upper) == 1,
                "returned interval does not isolate a root")
        intervals.append([str(lower), str(upper)])
    require(Q(intervals[0][1]) <= Q(intervals[1][0]),
            "returned intervals overlap")
    return {
        "operation_id": "polynomial.roots.isolate",
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_status": 0,
        "structured_error": None,
        "timed_out": False,
        "independent_exact_sturm_root_count": 2,
        "isolating_intervals": intervals,
    }


def compiler_check():
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "unverified or failing Lean source")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require(result["audit_exit_code"] == 0, "Lean axiom audit did not pass")
    version = result["tools"]["lean"]["version"]
    require("version 4.31.0," in version, "wrong Lean version")
    for name, field in [
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ]:
        require(hashlib.sha256((HERE / name).read_bytes()).hexdigest()
                == result[field], f"{name} changed after compilation")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claims = [c for c in state["claims"] if c["claim_id"] == "C_SAL_KERNEL"]
    require(bool(claims), "formal claim is missing")
    claim = max(claims, key=lambda c: c["version"])
    require(claim["formal_statement"].strip()
            == (HERE / "Main.lean").read_text().strip(),
            "ledger formalization differs from the compiled source")
    evidence = [
        e for e in state["evidence"]
        if e["subject"]["subject_id"] == "C_SAL_KERNEL"
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
    ]
    require(bool(evidence), "no current supporting mechanical evidence")
    archive_path = ROOT / evidence[-1]["artifact"]
    require(archive_path.resolve().is_relative_to(HERE),
            "compiler archive is outside the owned audit directory")
    archive = json.loads(archive_path.read_text())
    require(archive["lean_check"] == result
            and archive["lean_source"]["text"]
            == (HERE / "Main.lean").read_text(),
            "archived compiler answer differs from the current run")
    return {
        "claim": "C_SAL_KERNEL",
        "lean_version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "axiom_audit_exit_code": 0,
        "certificate": evidence[-1]["artifact"],
        "scope": "universal algebraic, floor, and infinite-recurrence core",
        "full_singularity_theorem_formalized": False,
    }


def certify(seed_indices):
    eta, r, g = Q(1, 100), Q(20301, 10000), Q(21, 10)
    require((1 + eta) * (2 + eta) == r, "wrong loss factor")
    margins = {
        "loss_vs_length": g - r,
        "large_return_initial_growth": Q(29, 10) - Q(14, 5),
        "small_return_initial_growth": Q(29, 10) - Q(11, 10) - Q(7, 4),
        "small_return_improved_growth": Q(29, 10) - Q(3, 4) - g,
        "large_return_next_K": Q(3, 4) * Q(14, 5) - Q(19, 10),
        "small_return_next_K": Q(3, 4) * Q(7, 4) - Q(11, 10),
        "multiplier_squared_error": 2 - Q(19, 10),
        "block_count_surplus": Q(3, 2) - Q(3, 4) - Q(7, 10),
        "window_squared_error": 2 - Q(3, 2),
        "probability_exception_decay": Q(1, 2) - Q(1, 10),
        "lebesgue_exception_decay": Q(7, 10) - Q(1, 10),
    }
    require(all(v > 0 for v in margins.values()),
            "a required strict universal margin is nonpositive")
    require(Q(100) * margins["small_return_improved_growth"] >= 4
            and Q(100) * margins["small_return_initial_growth"] >= 4
            and Q(100) * margins["large_return_initial_growth"] >= 3,
            "the explicit L>=100 threshold is insufficient")
    require(r / g == Q(6767, 7000) < 1, "loss ratio is not contracting")
    require(1 + Q(5) + Q(25, 2) > 12,
            "the exp(5)>12 block-count bound failed")
    require(1 + 3 + Q(9, 2) + Q(27, 6) + Q(81, 24) > 16,
            "the log(4*pi)<3 bound failed")
    require(1 + 4 + 8 + Q(64, 6) + Q(256, 24) > 32,
            "the log(8*pi)<4 bound failed")
    require(set(seed_indices) == set(SEEDS), "wrong seed set")
    return {
        "schema_version": 1,
        "result": "exact supporting certificate for Theorem A and sal:main",
        "mathematical_evidence_kind": "complete analytic proof plus formal universal core",
        "analytic_proof": "research/salem_audit/report.md",
        "claim_ids": ["C_SAL_MAIN", "C_SAL_NONSTATIONARY", "C_SAL_KERNEL"],
        "actual_postconditions": {
            "quantifier": "every quartic Salem beta in (1,2)",
            "sign_laws": "every deterministic sequence p_l in [0,1], independent signs",
            "conclusion": "for each law there exists a full-mass Lebesgue-null Borel set",
            "null_set_common_to_all_laws": False,
            "finite_multiplier_search_used_to_certify_infinite_sequence": False,
            "false_manuscript_assertion_identified": False,
        },
        "rational_margins": {k: str(v) for k, v in margins.items()},
        "normalized_loss_contraction": str(r / g),
        "seed_witnesses": {
            name: seed_witness(name, seed_indices[name]) for name in sorted(SEEDS)
        },
        "jacobian": jacobian_check(),
        "formal_core": compiler_check(),
        "limitations": [
            "The complete analytic proof requires independent human review.",
            "No full Lean formalization of singularity is claimed.",
            "No verified-new or publishable status is asserted before independent review.",
            "The arithmetic classification and degree-31 theorem are not verified.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        indices = {name: first_seed(name) for name in SEEDS}
        certificate = certify(indices)
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        certificate = json.loads(path.read_text())
        indices = {name: w["k_1"]
                   for name, w in certificate["seed_witnesses"].items()}
        require(certify(indices) == certificate,
                "exact certificate does not match recomputed evidence")
    print(json.dumps({
        "status": "PASS",
        "exact_seed_exponents": {
            name: w["k_1"]
            for name, w in certificate["seed_witnesses"].items()
        },
        "infinite_recurrence_core": "Lean 4.31.0, no proof holes",
        "analytic_singularity_proof": "requires independent Reviewer acceptance",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
