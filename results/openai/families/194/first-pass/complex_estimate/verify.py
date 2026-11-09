#!/usr/bin/env python3
"""Replay exact components; the universal geometric proof still needs review."""

import argparse
import hashlib
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
MAX_H = 10


def require(condition, message):
    if not condition:
        raise ValueError(message)


def rational(value):
    value = Fraction(value)
    return {"num": str(value.numerator), "den": str(value.denominator)}


def read_rational(value):
    require(set(value) == {"num", "den"}, "Invalid typed rational fields")
    answer = Fraction(int(value["num"]), int(value["den"]))
    require(rational(answer) == value, "Noncanonical typed rational")
    return answer


def polynomial(coefficients):
    coefficients = list(map(Fraction, coefficients))
    while len(coefficients) > 1 and coefficients[-1] == 0:
        coefficients.pop()
    return tuple(coefficients)


def multiply(left, right):
    result = [Fraction(0)] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return polynomial(result)


def derivative(p):
    return polynomial([i * p[i] for i in range(1, len(p))] or [0])


def evaluate(p, x):
    result = Fraction(0)
    for coefficient in reversed(p):
        result = result * x + coefficient
    return result


def remainder(left, right):
    require(right != (0,), "Polynomial division by zero")
    result = list(left)
    while len(result) >= len(right) and any(result):
        shift = len(result) - len(right)
        factor = result[-1] / right[-1]
        for j, coefficient in enumerate(right):
            result[shift + j] -= factor * coefficient
        result = list(polynomial(result))
    return polynomial(result)


def sturm_chain(p):
    chain = [p]
    d = derivative(p)
    if d == (0,):
        return chain
    chain.append(d)
    while True:
        rest = remainder(chain[-2], chain[-1])
        if rest == (0,):
            return chain
        chain.append(polynomial([-a for a in rest]))


def variations(chain, x):
    signs = []
    for p in chain:
        value = evaluate(p, x)
        if value:
            signs.append(1 if value > 0 else -1)
    return sum(a != b for a, b in zip(signs, signs[1:]))


def closed_root_count(p, chain, left, right):
    require(left <= right, "Reversed root interval")
    if left == right:
        return int(evaluate(p, left) == 0)
    return variations(chain, left) - variations(chain, right) + int(evaluate(p, left) == 0)


def h_polynomial(h):
    result = polynomial([1])
    for i in range(1, h + 1):
        result = multiply(result, polynomial([i, 1]))
    return result


def rounded_root(p, chain, j, s):
    previous = evaluate(p, Fraction(-(j + 1) * s, s))
    for k in range(-(j + 1) * s + 1, -j * s + 1):
        value = evaluate(p, Fraction(k, s))
        if value == 0:
            return k
        if value * previous < 0:
            require(closed_root_count(p, chain, Fraction(k - 1, s), Fraction(k, s)) == 1,
                    "Root rounding cell is not isolating")
            return k - 1
        previous = value
    raise ValueError("No derivative root in the prescribed interval")


def replay_jacobian():
    payload = json.loads((HERE / "jacobian_roots.payload.json").read_text())
    response = json.loads((HERE / "jacobian_roots.output.json").read_text())
    status = json.loads((HERE / "jacobian_roots.status.json").read_text())
    require(status["adapter_exit_code"] == 0, "Adapter failure is not mathematical evidence")
    require("error" not in response and "error" not in response["result"],
            "Structured adapter error is a non-conclusion")
    require(response["request"]["operation_id"] == "polynomial.roots.isolate",
            "Unexpected Jacobian operation")
    require(response["request"]["payload"] == payload, "Payload is not source-bound")
    p = polynomial(list(reversed([read_rational(x) for x in payload["coefficients_descending"]])))
    require(p == derivative(h_polynomial(4)), "Jacobian polynomial is not H_4 prime")
    output = response["result"]["output"]
    require(output["convention"] == "SYMPY_REAL_ROOTS", "Unexpected root convention")
    require(output["multiplicities"] == [1, 1, 1], "Unexpected root multiplicities")
    require(len(output["roots"]) == 3, "Incomplete Jacobian output")
    chain = sturm_chain(p)
    intervals = []
    for endpoints in output["roots"]:
        require(len(endpoints) == 2, "Invalid typed isolating interval")
        a, b = map(read_rational, endpoints)
        require(closed_root_count(p, chain, a, b) == 1, "Independent Sturm replay failed")
        require(evaluate(p, a) != 0 and evaluate(p, b) != 0,
                "The retained intervals must have non-root endpoints")
        intervals.append([rational(a), rational(b)])
    require(all(read_rational(a[1]) <= read_rational(b[0])
                for a, b in zip(intervals, intervals[1:])), "Overlapping root interiors")
    return {
        "operation_id": response["request"]["operation_id"],
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "transport": response["transport"],
        "adapter_exit_code": status["adapter_exit_code"],
        "typed_output_independently_replayed": True,
        "intervals": intervals,
        "scope": "One cubic, not a universal proof or a counterexample search.",
    }


def replay_polynomials():
    report = []
    for h in range(1, MAX_H + 1):
        H = h_polynomial(h)
        p = derivative(H)
        chain = sturm_chain(p)
        lead = math.factorial(h - 1)
        error = Fraction(0) if h == 1 else Fraction(3 * (h - 1) * h ** (h - 1), 2)
        constant = Fraction(0) if h == 1 else max(Fraction(h), error / lead)
        for i in range(1, h + 1):
            require(evaluate(H, -i) == 0, "H has lost an integer root")
            integral = sum(a * (0 ** (k + 1) - (-i) ** (k + 1)) / (h * (k + 1))
                           for k, a in enumerate(p))
            require(integral == lead, "The exact integral is not (h-1)!")
        for j in range(1, h):
            require(closed_root_count(p, chain, Fraction(-j - 1), Fraction(-j)) == 1,
                    "Derivative roots do not interlace")
            require(closed_root_count(p, chain, -j - 1 + Fraction(1, h),
                                      -j - Fraction(1, h)) == 1,
                    "The 1/h endpoint separation failed")
        largest_ratio = Fraction(0)
        cases = 0
        first_roots = []
        for s in range(h, 3 * h + 5):
            roots = [rounded_root(p, chain, j, s) for j in range(1, h)]
            require(all(-(j + 1) * s < r < -j * s for j, r in enumerate(roots, 1)),
                    "Rounded root violates a strict layer interval")
            require(all(a > b for a, b in zip(roots, roots[1:])), "Roots are not strictly ordered")
            if s == h:
                first_roots = roots
            for i in range(1, h + 1):
                total = sum(math.prod(l - r for r in roots) for l in range(-i * s, 0))
                discrepancy = abs(Fraction(total, s ** h) - lead)
                require(discrepancy <= error / s, "The stated explicit error bound failed")
                if error:
                    largest_ratio = max(largest_ratio, discrepancy * s / error)
                cases += 1
        if h > 1:
            require(constant >= h, "Small-s extension does not follow")
        report.append({
            "h": h,
            "s_min": h,
            "s_max": 3 * h + 4,
            "i_s_pairs": cases,
            "A_h": rational(constant),
            "E_h": rational(error),
            "roots_at_s_min": first_roots,
            "largest_error_to_bound_ratio": rational(largest_ratio),
        })
    return report


def matmul(left, right):
    return [[sum(a * b for a, b in zip(row, column)) for column in zip(*right)]
            for row in left]


def matrix_rank(matrix):
    rows = [list(map(Fraction, row)) for row in matrix]
    pivot = 0
    for column in range(len(rows[0])):
        index = next((i for i in range(pivot, len(rows)) if rows[i][column]), None)
        if index is None:
            continue
        rows[pivot], rows[index] = rows[index], rows[pivot]
        divisor = rows[pivot][column]
        rows[pivot] = [x / divisor for x in rows[pivot]]
        for i in range(len(rows)):
            if i != pivot:
                factor = rows[i][column]
                rows[i] = [a - factor * b for a, b in zip(rows[i], rows[pivot])]
        pivot += 1
    return pivot


def replay_filtered_tower():
    transition = [
        [1, 0, 1, 2, 0],
        [0, 1, 0, 1, 1],
        [0, 0, 0, 1, 0],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 0],
    ]
    power = [[int(i == j) for j in range(5)] for i in range(5)]
    ranks = []
    for k in range(5):
        ranks.append(matrix_rank(power))
        if k >= 3:
            require(all(x == 0 for row in power[2:] for x in row), "Quotient did not die")
            require([row[:2] for row in power[:2]] == [[1, 0], [0, 1]],
                    "The canonical H inclusion was not preserved")
        power = matmul(power, transition)
    require(ranks == [5, 4, 3, 2, 2], "Incorrect stabilized-image ranks")
    return {
        "quotient_filtration_steps": 3,
        "transition": transition,
        "ranks_of_powers_0_through_4": ranks,
        "stabilized_image_dimension": 2,
        "scope": "A finite example; the arbitrary-module assertion is the Lean theorem.",
    }


def add_term(chain, key, coefficient):
    chain[key] = chain.get(key, 0) + coefficient
    if chain[key] == 0:
        del chain[key]


def koszul_d(chain, s):
    result = {}
    for (subset, exponents), coefficient in chain.items():
        for position, j in enumerate(subset):
            powers = list(exponents)
            powers[j] += s
            add_term(result, (subset[:position] + subset[position + 1:], tuple(powers)),
                     coefficient * (-1) ** position)
    return result


def koszul_homotopy(chain, s, j):
    result = {}
    for (subset, exponents), coefficient in chain.items():
        if j not in subset:
            powers = list(exponents)
            powers[j] -= s
            sign = (-1) ** sum(i < j for i in subset)
            add_term(result, (tuple(sorted((*subset, j))), tuple(powers)), coefficient * sign)
    return result


def replay_koszul_family():
    cases = []
    for h, s in itertools.product(range(1, 5), repeat=2):
        ranks = [math.comb(h, i) for i in range(h + 1)]
        require(sum((-1) ** i * b for i, b in enumerate(ranks)) == 0,
                "Koszul alternating rank is nonzero")
        basis_size = sum(1 for _ in itertools.product(range(s), repeat=h))
        require(basis_size == s ** h, "Incorrect monomial quotient colength")
        for size in range(h + 1):
            for subset in itertools.combinations(range(h), size):
                element = {(subset, (0,) * h): 1}
                require(not koszul_d(koszul_d(element, s), s), "Koszul differential squared is nonzero")
                for j in range(h):
                    contraction = koszul_d(koszul_homotopy(element, s, j), s)
                    for key, coefficient in koszul_homotopy(koszul_d(element, s), s, j).items():
                        add_term(contraction, key, coefficient)
                    require(contraction == element, "Off-support Laurent contraction failed")
        cases.append({"h": h, "s": s, "ranks": ranks, "colength": basis_size})
    return cases


def check_lean_core(ledger):
    claims = [c for c in ledger["claims"] if c["claim_id"] == "C_COMPLEX_STABILIZATION"]
    claim = max(claims, key=lambda c: c["version"])
    evidence = [e for e in ledger["evidence"]
                if e["subject"]["subject_id"] == claim["claim_id"]
                and e["subject"]["content_hash"] == claim["content_hash"]
                and e["tier"] == "mechanical" and e["verdict"] == "supports"]
    require(len(evidence) == 1, "Expected one current real kernel certificate for the core")
    path = (ROOT / evidence[0]["artifact"]).resolve()
    require(path.is_relative_to(HERE), "Compiler certificate is outside the owned evidence directory")
    certificate = json.loads(path.read_text())
    require(certificate["subject"] == evidence[0]["subject"], "Compiler subject is stale")
    check = certificate["lean_check"]
    require(check["exit_code"] == 0 and check["audit_exit_code"] == 0,
            "Compiler or axiom audit did not pass")
    require(check["proof_holes"] == [] and check["environment_failure"] == "",
            "Unverified or hole-bearing source is not evidence")
    require("version 4.31.0," in check["tools"]["lean"]["version"], "Wrong Lean version")
    source = (HERE / "lean/Main.lean").read_bytes()
    fidelity = (HERE / "lean/statement_fidelity.md").read_bytes()
    require(hashlib.sha256(source).hexdigest() == check["source_sha256"], "Lean source changed")
    require(hashlib.sha256(fidelity).hexdigest() == check["statement_fidelity_sha256"],
            "Statement-fidelity document changed")
    require(certificate["lean_source"]["text"] == source.decode(), "Archived source differs")
    require(certificate["statement_fidelity"]["text"] == fidelity.decode(), "Archived reading differs")
    require(claim["formal_statement"] == source.decode(), "Ledger formal statement differs")
    return {
        "claim_id": claim["claim_id"],
        "artifact": evidence[0]["artifact"],
        "exit_code": check["exit_code"],
        "audit_exit_code": check["audit_exit_code"],
        "proof_holes": check["proof_holes"],
        "compiler_version": check["tools"]["lean"]["version"],
        "scope": "Universal filtration, stabilized-image, and normalization cores only.",
    }


def build_certificate():
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claims = {c["claim_id"]: c for c in ledger["claims"]}
    target = claims["C_COMPLEX_ESTIMATE"]
    context = next(c for c in ledger["contexts"] if c["context_id"] == "CTX_COMPLEX")
    dependencies = [
        "C_COMPLEX_ACYCLICITY", "C_COMPLEX_GRADED", "C_COMPLEX_TWISTS",
        "C_COMPLEX_STABILIZATION", "C_COMPLEX_COMPARISON", "C_COMPLEX_ROOT_BUNDLE",
        "C_COMPLEX_POSITIVITY", "C_COMPLEX_ERROR",
    ]
    require(all(c in claims for c in dependencies), "An obligation is missing from the ledger")
    return {
        "claim_id": target["claim_id"],
        "statement": target["natural_statement"],
        "context": context["statement"],
        "proof": "research/complex_estimate/proof.md",
        "proof_dependencies": dependencies,
        "external_inputs": {
            c: [{"id": a["assumption_id"], "source_id": a["source_id"], "locator": a["locator"]}
                for a in claims[c]["external_assumptions"]]
            for c in ("C_COMPLEX_GRADED", "C_COMPLEX_ROOT_BUNDLE")
        },
        "certification_scope": {
            "universal_geometric_theorem": "Written proof requiring independent mathematical review.",
            "python": "Finite exact replay; not a universal proof or an exhaustion of counterexamples.",
            "lean": "Real kernel verification of the stated universal algebraic core.",
            "independent_review": "Not asserted by this Engineer executable; consult the claim ledger.",
            "novelty": "Not claimed.",
            "not_certified": ["The full Lech inequality", "The manuscript characteristic applications"],
        },
        "lean_core": check_lean_core(ledger),
        "jacobian_replay": replay_jacobian(),
        "polynomial_replay": replay_polynomials(),
        "filtered_tower_replay": replay_filtered_tower(),
        "sharp_koszul_examples": replay_koszul_family(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="Write the computed replay certificate")
    args = parser.parse_args()
    certificate = build_certificate()
    path = HERE / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    require(json.loads(path.read_text()) == certificate, "Stored certificate differs from exact replay")
    print(json.dumps({
        "replay": "passed",
        "claim": certificate["claim_id"],
        "polynomial_i_s_pairs": sum(r["i_s_pairs"] for r in certificate["polynomial_replay"]),
        "sharp_koszul_examples": len(certificate["sharp_koszul_examples"]),
        "lean_core_exit_code": certificate["lean_core"]["exit_code"],
        "lean_core_proof_holes": certificate["lean_core"]["proof_holes"],
        "universal_geometric_proof": "Requires independent review; not proved by this Python replay.",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
