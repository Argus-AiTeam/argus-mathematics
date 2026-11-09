import json
import sys
from fractions import Fraction
from itertools import combinations_with_replacement
from math import comb
from pathlib import Path
from time import perf_counter


ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT.parent / "projective-cross-ratio"))
from verify_projective import (
    add,
    check_parameters,
    cyclic_product,
    multiply,
    require,
    scale,
)


def gaps(m):
    return [
        (x, y, z)
        for x in range(1, m - 1)
        for y in range(1, m - x)
        for z in range(1, m - x - y + 1)
    ]


def canonical(gap):
    x, y, z = gap
    return min(x, z), y, max(x, z)


def count_formula(m):
    numerator = comb(m, 3) + (m - 1) ** 2 // 4
    require(numerator % 2 == 0, "The orbit-count numerator is not even")
    return numerator // 2


def cleared_comparison(first, second, modulus):
    if any(value <= 0 for gap in (first, second) for value in gap):
        raise ValueError("All three gaps must be positive")
    x, y, z = first
    a, b, c = second
    positive = cyclic_product(
        ((0, x + y), (0, y + z), (0, a + b + c), (0, b)), modulus
    )
    negative = cyclic_product(
        ((0, a + b), (0, b + c), (0, x + y + z), (0, y)), modulus
    )
    return tuple(
        positive.get(i, 0) - negative.get(i, 0) for i in range(modulus)
    )


def zero_at_primitive_root(coefficients, p=None):
    last = coefficients[-1]
    if p is None:
        return all(c == last for c in coefficients)
    return all((c - last) % p == 0 for c in coefficients)


def check_gap_family(m, r=None, p=None):
    family = gaps(m)
    require(len(family) == comb(m, 3), "The positive-triple count failed")
    fixed = sum(x == z for x, y, z in family)
    require(fixed == (m - 1) ** 2 // 4, "The fixed-triple count failed")
    classes = {canonical(gap) for gap in family}
    require(len(classes) == count_formula(m), "The reversal count failed")
    modulus = 4 * m - 3 if r is None else r
    require(4 * m - 4 < modulus, "Integer comparisons would wrap exponents")
    if r is not None:
        check_parameters(p, r)
        require(m == (r - 1) // 4, "The specialized arc length is incorrect")
        require(4 * m - 4 < r - 1, "Cyclotomic degree separation failed")
        for x, y, z in family:
            s = x + y + z
            require(0 < x < x + y < s <= m < r, "Root indices are invalid")
            denominator = cyclic_product(((0, s), (0, y)), r)
            coefficients = tuple(denominator.get(i, 0) for i in range(r))
            require(
                not zero_at_primitive_root(coefficients)
                and not zero_at_primitive_root(coefficients, p),
                "A specialized denominator vanished",
            )
    comparisons = equal = maximum_coefficient = 0
    for first, second in combinations_with_replacement(family, 2):
        coefficients = cleared_comparison(first, second, modulus)
        expected = canonical(first) == canonical(second)
        rational_equal = all(c == 0 for c in coefficients)
        require(rational_equal == expected, "Rational classification failed")
        maximum_coefficient = max(
            maximum_coefficient, max(abs(c) for c in coefficients)
        )
        if r is not None:
            require(
                zero_at_primitive_root(coefficients) == expected
                and zero_at_primitive_root(coefficients, p) == expected,
                "Exact cyclotomic specialization changed a collision",
            )
        comparisons += 1
        equal += expected
    require(maximum_coefficient <= 16, "The coefficient threshold failed")
    return {
        "M": m,
        "triples": len(family),
        "fixed_triples": fixed,
        "distinct_values": len(classes),
        "pair_comparisons_including_diagonal": comparisons,
        "equal_comparisons": equal,
        "maximum_observed_coefficient": maximum_coefficient,
        "r": r,
        "p": p,
        "finite_field_ring": None if r is None else "F_p[T]/Phi_r(T)",
        "is_universal_proof": False,
        "local_solution_asserted": False,
    }


def check_boundary_controls():
    first, second, r = (1, 1, 1), (1, 34, 1), 37
    degree_bound = sum(first) + first[1] + sum(second) + second[1]
    ordinary = cleared_comparison(first, second, degree_bound + 1)
    specialized = cleared_comparison(first, second, r)
    require(any(ordinary), "The long-arc functions unexpectedly agree in Q(T)")
    require(
        zero_at_primitive_root(specialized),
        "The specified long-arc cyclotomic collision was not detected",
    )
    require(
        sum(second) > (r - 1) // 4 and sum(second) < r,
        "The boundary control must be defined but outside the short arc",
    )
    rejected = 0
    for gap in ((0, 1, 1), (1, -1, 1), (1, 1, 0)):
        try:
            cleared_comparison(gap, first, 37)
        except ValueError:
            rejected += 1
        else:
            raise AssertionError(f"Nonpositive gap accepted: {gap}")
    return {
        "r": r,
        "first": first,
        "second": second,
        "unequal_in_Q_T": True,
        "equal_at_primitive_complex_root": True,
        "outside_short_arc": True,
        "nonpositive_gap_controls_rejected": rejected,
        "conclusion": "The short-arc restriction cannot be omitted.",
    }


def read_polynomial(blob):
    require(
        blob["domain"] == "QQ" and blob["variables"] == ["a", "b", "c"],
        "The Jacobian coefficient ring changed",
    )
    return {
        tuple(term["exponents"]): Fraction(
            int(term["coefficient"]["num"]), int(term["coefficient"]["den"])
        )
        for term in blob["polynomial"]["terms"]
    }


def replay_jacobian():
    payload = json.loads((ROOT / "jacobian_gap_payload.json").read_text())
    response = json.loads((ROOT / "jacobian_gap_output.json").read_text())
    operation = "polynomial.multivariate.factor.compute"
    require(response["request"]["payload"] == payload, "The payload changed")
    require(
        response["request"]["operation_id"] == operation
        and response["result"]["operation_id"] == operation,
        "The Jacobian operation changed",
    )
    output = response["result"]["output"]
    require(
        output["status"] == "FACTORIZED"
        and output["product_reconstruction"] == "EXACT",
        "The typed Jacobian outcome is not an exact factorization",
    )
    coefficient = output["coefficient"]
    product = {
        (0, 0, 0): Fraction(int(coefficient["num"]), int(coefficient["den"]))
    }
    for factor in output["factors"]:
        polynomial = read_polynomial(factor["factor"])
        for _ in range(factor["multiplicity"]):
            product = multiply(product, polynomial)
    one = {(0, 0, 0): 1}
    a, b, c = [
        {tuple(int(i == j) for i in range(3)): 1} for j in range(3)
    ]
    numerator = multiply(
        add(one, scale(multiply(a, b), -1)),
        add(one, scale(multiply(b, c), -1)),
    )
    denominator = multiply(
        add(one, scale(multiply(multiply(a, b), c), -1)),
        add(one, scale(b, -1)),
    )
    gap = add(numerator, scale(denominator, -1))
    require(
        gap == product == read_polynomial(payload["polynomial"])
        == read_polynomial(output["reconstructed"]),
        "Exact reconstruction of the gap numerator failed",
    )
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "typed_status": output["status"],
        "exact_factor_reconstruction": True,
        "adapter_rerun": False,
        "is_universal_classification_proof": False,
    }


def check_parity_formulas():
    for m in range(3, 10001):
        numerator = 2 * m ** 3 - 3 * m ** 2 - 2 * m + 3 * (m % 2)
        require(
            numerator == 24 * count_formula(m),
            f"The exact parity formula failed at M={m}",
        )
    return {"M_min": 3, "M_max": 10000, "exact_parity_formula": True}


def main():
    started = perf_counter()
    result = {
        "status": "passed",
        "scope": "Exact finite algebra controls; universal proof is cubic_obstruction.md",
        "rational_families": [check_gap_family(m) for m in range(3, 11)],
        "cyclotomic_families": [
            check_gap_family((r - 1) // 4, r, p)
            for r, p in ((37, 17), (41, 17), (43, 19))
        ],
        "boundary_controls": check_boundary_controls(),
        "parity_formulas": check_parity_formulas(),
        "jacobian_reconstruction": replay_jacobian(),
        "universal_proof_mechanically_verified": False,
        "counterexample_or_local_solution_present": False,
    }
    result["elapsed_seconds"] = round(perf_counter() - started, 6)
    (ROOT / "short_arc_checks.json").write_text(
        json.dumps(result, indent=2) + "\n"
    )
    print(json.dumps(result))


if __name__ == "__main__":
    main()
