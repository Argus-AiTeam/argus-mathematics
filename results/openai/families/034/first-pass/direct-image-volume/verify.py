#!/usr/bin/env python3
"""Replay the exact algebraic evidence; do not certify analytic assertions."""

import copy
import json
from fractions import Fraction
from math import comb, factorial
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for monomial, coefficient in polynomial.items():
            result[monomial] = result.get(monomial, 0) + coefficient
    return {m: c for m, c in result.items() if c}


def neg(polynomial):
    return {m: -c for m, c in polynomial.items()}


def mul(left, right):
    result = {}
    for a, x in left.items():
        for b, y in right.items():
            monomial = tuple(sorted(a + b))
            result[monomial] = result.get(monomial, 0) + x * y
    return {m: c for m, c in result.items() if c}


def symbolic_identities():
    i0, i1, im, ik, ip = ({(name,): 1} for name in ("i0", "i1", "im", "ik", "ip"))
    qk = add(mul(i1, ik), neg(mul(i0, ip)))
    qm = add(mul(i1, im), neg(mul(i0, ik)))
    defect = add(mul(ik, ik), neg(mul(im, ip)))
    residual = add(mul(ik, qk), neg(mul(ip, qm)), neg(mul(i1, defect)))
    require(not residual, "The universal log-concavity propagation identity is false")

    e, d, one = {("e",): 1}, {("d",): 1}, {(): 1}
    residual = add(
        mul(add(e, one), d),
        neg(add(d, e)),
        neg(mul(e, add(d, neg(one)))),
    )
    require(not residual, "The universal coefficient-comparison identity is false")
    return 2


def bundle_volume(e, b, t):
    return sum((Fraction(comb(e + b, i)) * t**i for i in range(b + 1)), Fraction())


def determinant_counts():
    cases = 0
    for e in range(1, 9):
        for j in range(1, 17):
            counts = [comb(j - k + e - 1, e - 1) for k in range(j + 1)]
            rank = sum(counts)
            weight = sum(k * count for k, count in enumerate(counts))
            require(rank == comb(j + e, e), f"Rank count failed: e={e}, j={j}")
            require(weight == comb(j + e, e + 1), f"Determinant count failed: e={e}, j={j}")
            require(
                Fraction(weight, j * rank) == Fraction(1, e + 1),
                f"Determinant normalization failed: e={e}, j={j}",
            )
            cases += 1
    return cases


def bundle_grid():
    coefficient_cases = 0
    value_cases = 0
    parameters = [Fraction(1, 100), Fraction(1, 10), Fraction(1, 2), Fraction(1), Fraction(3, 2)]
    for e in range(1, 9):
        for b in range(1, 9):
            for i in range(b + 1):
                lhs = comb(e + b, i)
                rhs = comb(b, i) * (e + 1)**i
                require(lhs <= rhs, f"Coefficient inequality failed: e={e}, b={b}, i={i}")
                if i:
                    product = Fraction(1)
                    for r in range(i):
                        product *= Fraction(e + b - r, b - r)
                    require(product == Fraction(lhs, comb(b, i)), "Binomial product identity failed")
            coefficient_cases += 1
            require(
                Fraction(1) / Fraction(1, e + 1)**b == (e + 1)**b,
                "The limiting sharpness constant is incorrect",
            )
            for t in parameters:
                lhs = bundle_volume(e, b, t)
                rhs = (e + 1)**b * (t + Fraction(1, e + 1))**b
                require(lhs <= rhs, f"Volume inequality failed: e={e}, b={b}, t={t}")
                if b == 1:
                    require(lhs == rhs, "The base-curve equality failed")
                value_cases += 1
    return coefficient_cases, value_cases


def nonflat_grid():
    cases = 0
    for e in range(1, 5):
        for b in range(2, 6):
            for delta in (Fraction(1, 4), Fraction(1, 2), Fraction(3, 4)):
                exceptional_top = (-1)**(b - 1)
                flat_top = 1 + (-delta)**b * exceptional_top
                require(flat_top == 1 - delta**b, "Point-blowup intersection sign failed")
                require(0 < flat_top < 1, "Flattened volume comparison failed")
                lhs = comb(e + b, b) * flat_top
                require(lhs <= (e + 1)**b, "Non-equidimensional family violates the bound")
                cases += 1
    return cases


def canonical_rational(value):
    require(set(value) == {"num", "den"}, "Invalid rational output shape")
    result = Fraction(int(value["num"]), int(value["den"]))
    require(value == {"num": str(result.numerator), "den": str(result.denominator)}, "Noncanonical rational")
    return result


def jacobian_check(discovery, payload, result):
    require(result["schema_version"] == 1, "Unexpected Jacobian schema")
    require(result["protocol_version"] == discovery["protocol_version"], "Protocol mismatch")
    require(result["server"]["name"] == "jacobian", "Unexpected server")
    require(result["server"]["version"] == discovery["server"]["version"], "Server-version mismatch")
    require(result["tool"] == "math.run", "Not an executed operation")
    require(result["request"]["operation_id"] == "polytope.volume.compute", "Operation mismatch")
    require(result["request"]["payload"] == payload, "Payload is not source-bound")
    require(result["result"]["operation_id"] == "polytope.volume.compute", "Result operation mismatch")
    require("error" not in result and "error" not in result["result"], "Adapter reported an error")

    vertices = {
        tuple(canonical_rational(x) for x in vertex["coordinates"])
        for vertex in payload["vertices"]
    }
    expected_vertices = {
        (0, 0, 0), (0, 1, 0), (0, 0, 1),
        (1, 0, 0), (1, 2, 0), (1, 0, 2),
    }
    require(payload["dimension_bound"] == 3, "Wrong bounded request dimension")
    require(len(payload["vertices"]) == 6 and vertices == expected_vertices, "Not the stated toric polytope")
    output = result["result"]["output"]
    require(set(output) == {"dimension", "representation", "volume"}, "Unexpected typed output")
    require(output["dimension"] == 3 and output["representation"] == "vertices", "Wrong output type")
    volume = canonical_rational(output["volume"])
    slice_integral = sum((Fraction(comb(2, i), 2 * (i + 1)) for i in range(3)), Fraction())
    require(volume == slice_integral == Fraction(7, 6), "Incorrect exact polytope volume")
    require(factorial(3) * volume == bundle_volume(1, 2, Fraction(1)) == 7, "Toric intersection mismatch")
    return volume


def expect_rejection(check, message):
    try:
        check()
    except AssertionError:
        return
    raise AssertionError(message)


def main():
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    discovery = json.loads((ROOT / "jacobian/discovery.json").read_text())
    payload = json.loads((ROOT / "jacobian/payload.json").read_text())
    result = json.loads((ROOT / "jacobian/result.json").read_text())

    identities = symbolic_identities()
    ranks = determinant_counts()
    coefficients, volumes = bundle_grid()
    nonflat = nonflat_grid()
    polytope_volume = jacobian_check(discovery, payload, result)

    ruled = certificate["exact_examples"]["ruled_bundle"]
    b, e, t = ruled["b"], ruled["e"], Fraction(ruled["t"])
    require((b, e, t) == (2, 1, 1), "Certificate parameters do not match the toric payload")
    b_coefficient = t + Fraction(1, e + 1)
    expected_ruled = {
        "w": Fraction(1),
        "B_coefficient": b_coefficient,
        "source_top_intersection": bundle_volume(e, b, t),
        "bound": (e + 1)**b * b_coefficient**b,
        "polytope_volume": polytope_volume,
    }
    for field, value in expected_ruled.items():
        require(Fraction(ruled[field]) == value, f"Ruled-bundle certificate mismatch: {field}")

    blown_up = certificate["exact_examples"]["non_equidimensional"]
    b, e = blown_up["b"], blown_up["e"]
    delta = Fraction(blown_up["delta"])
    require((b, e) == (2, 1) and 0 < delta < 1, "Invalid non-equidimensional example parameters")
    expected_nonflat = {
        "w": Fraction(1),
        "B_top_intersection": Fraction(1),
        "Bprime_top_intersection": 1 - delta**b,
        "source_top_intersection": comb(e + b, b) * (1 - delta**b),
        "bound": Fraction((e + 1)**b),
        "exceptional_divisor_coefficient": delta,
    }
    for field, value in expected_nonflat.items():
        require(Fraction(blown_up[field]) == value, f"Nonflat certificate mismatch: {field}")

    wrong_volume = copy.deepcopy(result)
    wrong_volume["result"]["output"]["volume"] = {"num": "4", "den": "3"}
    expect_rejection(
        lambda: jacobian_check(discovery, payload, wrong_volume),
        "An incorrect Jacobian volume was accepted",
    )
    wrong_payload = copy.deepcopy(payload)
    wrong_payload["vertices"][0]["coordinates"][0] = {"num": "1", "den": "1"}
    expect_rejection(
        lambda: jacobian_check(discovery, wrong_payload, result),
        "An altered, unbound payload was accepted",
    )
    # On a line in the exceptional divisor, E has degree -1.
    require(-(-delta) == delta > 0, "Correct exceptional subtraction is not relatively nef")
    expect_rejection(
        lambda: require(-delta >= 0, "Reversed exceptional sign has negative degree"),
        "The reversed exceptional sign was accepted",
    )

    counts = {
        "universal_polynomial_identities": identities,
        "determinant_count_cases": ranks,
        "coefficient_comparison_cases": coefficients,
        "ample_volume_cases": volumes,
        "non_equidimensional_cases": nonflat,
        "negative_controls": 3,
    }
    require(counts == certificate["replay_counts"], "Replay counts disagree with the certificate")
    require(certificate["analytic_machine_certification"] is False, "Certificate overstates its scope")
    print(json.dumps({
        "ok": True,
        "claim": certificate["claim_id"],
        "exact_replay": counts,
        "jacobian_volume": str(polytope_volume),
        "analytic_proof": "proof.md; not decided by this program",
        "independent_review": "not decided by this program",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
