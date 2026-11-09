#!/usr/bin/env python3
"""Replay the exact core; no network, Jacobian service, or third-party packages."""

import argparse
from fractions import Fraction
from itertools import product
import json
from math import comb, prod
from operator import add, mul
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OPERATION = "matrix.normal_form.smith.certified.compute"
N = 4
M = [[1, 1], [1, -1], [0, 2], [2, 0]]
KERNEL_BASIS = [[2, 0], [2, 4]]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def matrix_product(a, b, plus=add, times=mul, zero=0):
    require(len(a[0]) == len(b), "Incompatible matrix dimensions")
    return [
        [
            sum_ring((times(a[i][k], b[k][j]) for k in range(len(b))), plus, zero)
            for j in range(len(b[0]))
        ]
        for i in range(len(a))
    ]


def sum_ring(values, plus, zero):
    result = zero
    for value in values:
        result = plus(result, value)
    return result


def matrix_sum(a, b, plus=add):
    return [[plus(x, y) for x, y in zip(ar, br)] for ar, br in zip(a, b)]


def determinant(a):
    require(all(len(row) == len(a) for row in a), "Determinant needs a square matrix")
    work = [[Fraction(x) for x in row] for row in a]
    answer = Fraction(1)
    for j in range(len(work)):
        pivot = next((i for i in range(j, len(work)) if work[i][j]), None)
        if pivot is None:
            return Fraction(0)
        if pivot != j:
            work[j], work[pivot] = work[pivot], work[j]
            answer = -answer
        value = work[j][j]
        answer *= value
        for i in range(j + 1, len(work)):
            ratio = work[i][j] / value
            for k in range(j + 1, len(work)):
                work[i][k] -= ratio * work[j][k]
    return answer


def typed_matrix(value):
    require(value["domain"] == "ZZ", "The lattice matrix must be integral")
    rows = value["entries"]
    require(len(rows) == value["row_count"], "Incorrect typed row count")
    require(all(len(row) == value["column_count"] for row in rows), "Incorrect typed column count")
    require(all(isinstance(x, str) and str(int(x)) == x for row in rows for x in row),
            "Noncanonical typed integer")
    return [[int(x) for x in row] for row in rows]


def polynomial(*terms):
    result = {}
    for a_exp, d_exp, coefficient in terms:
        key = (a_exp, d_exp)
        result[key] = result.get(key, Fraction(0)) + Fraction(coefficient)
    return {key: value for key, value in result.items() if value}


def polynomial_add(a, b):
    return polynomial(*(key + (value,) for key, value in a.items()),
                      *(key + (value,) for key, value in b.items()))


def polynomial_multiply(a, b):
    return polynomial(*(
        (i + k, j + ell, x * y)
        for (i, j), x in a.items() for (k, ell), y in b.items()
    ))


def scale(a, coefficient):
    return polynomial(*(key + (value * coefficient,) for key, value in a.items()))


def polynomial_text(a):
    return [{"exponents": list(key), "coefficient": str(value)} for key, value in sorted(a.items())]


def universal_identities():
    one = polynomial((0, 0, 1))
    a = polynomial((1, 0, 1))
    inverse_a = polynomial((-1, 0, 1))
    d = polynomial((0, 1, 1))
    zero = {}
    differential = [[d, zero], [a, scale(d, -1)]]
    homotopy = [[zero, inverse_a], [zero, zero]]
    dh = matrix_product(differential, homotopy, polynomial_add, polynomial_multiply, zero)
    hd = matrix_product(homotopy, differential, polynomial_add, polynomial_multiply, zero)
    require(matrix_sum(dh, hd, polynomial_add) == [[one, zero], [zero, one]],
            "Universal Koszul contracting-homotopy identity failed")

    n = polynomial((1, 0, 1))
    g = polynomial((0, 1, 1))
    n2_minus_one = polynomial_add(polynomial_multiply(n, n), scale(one, -1))
    r = polynomial_multiply(n2_minus_one, polynomial_add(g, scale(one, -1)))
    b = scale(polynomial_multiply(n, polynomial_add(n, scale(one, -1))), Fraction(1, 2))
    delta = scale(polynomial_add(polynomial_add(r, b), g), 2)
    auxiliary_center = polynomial_add(delta, scale(b, 2))
    after_thom = polynomial_add(auxiliary_center, scale(b, -2))
    after_duality = polynomial_add(scale(delta, 2), scale(after_thom, -1))
    after_flag = polynomial_add(after_duality, scale(b, -2))
    after_determinant = polynomial_add(scale(after_flag, Fraction(1, 2)), scale(g, -1))
    require(after_thom == delta, "Thom actual-weight shift is incorrect")
    require(after_duality == delta, "Poincare duality center is incorrect")
    require(after_determinant == r, "Final Lefschetz center is not R")
    return {
        "coefficient_ring": "Q[a,a^-1,d]; a central and invertible, d arbitrary",
        "identity": "[[d,0],[a,-d]] [[0,a^-1],[0,0]] + [[0,a^-1],[0,0]] [[d,0],[a,-d]] = I",
        "residual": [[[], []], [[], []]],
        "universality": "An identity of Laurent polynomials, not a parameter sweep.",
        "weight_polynomials": {
            "variables": ["n", "g"],
            "R": polynomial_text(r),
            "b": polynomial_text(b),
            "delta": polynomial_text(delta),
            "auxiliary_actual_center": polynomial_text(auxiliary_center),
            "after_flag_actual_center": polynomial_text(after_flag),
            "final_half_weight_center": polynomial_text(after_determinant),
        },
    }


GZERO = (Fraction(0), Fraction(0))
GONE = (Fraction(1), Fraction(0))
ROOTS = (GONE, (Fraction(0), Fraction(1)), (-GONE[0], GZERO[1]),
         (Fraction(0), Fraction(-1)))


def gaussian_add(x, y):
    return (x[0] + y[0], x[1] + y[1])


def gaussian_multiply(x, y):
    return (x[0] * y[0] - x[1] * y[1], x[0] * y[1] + x[1] * y[0])


def gaussian_inverse(x):
    norm = x[0] ** 2 + x[1] ** 2
    require(norm != 0, "Acyclic character has no invertible Koszul coefficient")
    return (x[0] / norm, -x[1] / norm)


def exterior_operator(coefficients, contraction=False):
    s = len(coefficients)
    size = 1 << s
    result = [[GZERO for _ in range(size)] for _ in range(size)]
    for mask in range(size):
        for j, coefficient in enumerate(coefficients):
            present = bool(mask & (1 << j))
            if present != contraction:
                continue
            target = mask ^ (1 << j)
            sign = -1 if (mask & ((1 << j) - 1)).bit_count() % 2 else 1
            value = (sign * coefficient[0], sign * coefficient[1])
            result[target][mask] = gaussian_add(result[target][mask], value)
    return result


def exact_example():
    k, s = len(M), len(M[0])
    image = {
        tuple(sum(M[i][j] * v[j] for j in range(s)) % N for i in range(k))
        for v in product(range(N), repeat=s)
    }
    component_count = N ** k // len(image)
    require(component_count * len(image) == N ** k, "Nonintegral component count")
    require(all(value % N == 0 for row in matrix_product(M, KERNEL_BASIS) for value in row),
            "Proposed component lattice is not in the monodromy kernel")
    kernel_index = abs(determinant(KERNEL_BASIS))
    require(kernel_index == len(image), "Proposed component lattice does not exhaust the kernel")
    identity = [[GONE if i == j else GZERO for j in range(1 << s)] for i in range(1 << s)]
    zero_matrix = [[GZERO for _ in range(1 << s)] for _ in range(1 << s)]
    survivors = []
    acyclic = 0
    for character in product(range(N), repeat=k):
        phases = [sum(character[i] * M[i][j] for i in range(k)) % N for j in range(s)]
        coefficients = [gaussian_add(ROOTS[phase], (-1, 0)) for phase in phases]
        differential = exterior_operator(coefficients)
        require(matrix_product(differential, differential, gaussian_add, gaussian_multiply, GZERO)
                == zero_matrix, "Koszul differential does not square to zero")
        annihilates_image = all(sum(x * y for x, y in zip(character, h)) % N == 0 for h in image)
        require(annihilates_image == all(phase == 0 for phase in phases),
                "Character/component annihilator correspondence failed")
        if all(value == GZERO for value in coefficients):
            require(differential == zero_matrix, "Trivial restriction has nonzero differential")
            survivors.append(list(character))
        else:
            direction = next(j for j, value in enumerate(coefficients) if value != GZERO)
            h_coefficients = [GZERO for _ in range(s)]
            h_coefficients[direction] = gaussian_inverse(coefficients[direction])
            homotopy = exterior_operator(h_coefficients, contraction=True)
            dh = matrix_product(differential, homotopy, gaussian_add, gaussian_multiply, GZERO)
            hd = matrix_product(homotopy, differential, gaussian_add, gaussian_multiply, GZERO)
            require(matrix_sum(dh, hd, gaussian_add) == identity,
                    "Exact Gaussian-rational character contraction failed")
            acyclic += 1
    require(len(survivors) == component_count, "A component character was lost")
    require(len(survivors) + acyclic == N ** k, "Not all deck characters were examined")
    genus = k // 2
    r, b = (N * N - 1) * (genus - 1), N * (N - 1) // 2
    delta = 2 * r + 2 * b + 2 * genus
    return {
        "n": N, "g": genus, "torus_rank": s, "deck_rank": k,
        "exponent_matrix": M,
        "cover_degree": N ** k,
        "monodromy_image_order": len(image),
        "component_count": component_count,
        "component_lattice_column_basis": KERNEL_BASIS,
        "component_cover_degree": int(kernel_index),
        "ordinary_betti_numbers": [component_count * comb(s, j) for j in range(s + 1)],
        "character_field": "Q(i), represented by pairs of rational numbers",
        "surviving_characters": survivors,
        "surviving_nontrivial_characters": len(survivors) - 1,
        "acyclic_characters_with_checked_contractions": acyclic,
        "integral_pullback_is_an_isomorphism": False,
        "rational_pullback_determinants_by_degree": [1, int(kernel_index), int(kernel_index)],
        "centers": {
            "R": r, "b": b, "delta": delta,
            "auxiliary_compact_actual": delta + 2 * b,
            "covered_ordinary_half": delta // 2,
            "after_flag_half": delta // 2 - b,
            "determinant_half": genus,
            "fixed_determinant_half": r,
        },
    }


def check_jacobian(payload, envelope, status):
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(status["operation_id"] == OPERATION, "Adapter status names another operation")
    require(envelope["tool"] == "math.run", "Not a Jacobian execution envelope")
    require(envelope["request"] == {"operation_id": OPERATION, "payload": payload},
            "The typed output is not bound to the exact submitted payload")
    require(envelope["result"]["operation_id"] == OPERATION, "Unexpected result operation")
    require("error" not in envelope and "error" not in envelope["result"],
            "Jacobian returned a structured error")
    output = envelope["result"]["output"]
    require(output["exactness"] == "EXACT_INTEGER", "Nonexact Jacobian result")
    require(output["completeness"] == "FULL_MATRIX_TRANSFORMATIONS", "Incomplete Jacobian result")
    certificate = output["certificate"]
    source = typed_matrix(certificate["source"])
    expected = [[N if i == j else 0 for j in range(len(M))] + M[i] for i in range(len(M))]
    require(source == expected == typed_matrix(payload["matrix"]), "Unexpected source lattice")
    left = typed_matrix(certificate["left_transformation"])
    right = typed_matrix(certificate["right_transformation"])
    diagonal = typed_matrix(certificate["diagonal"])
    require(certificate["relation"] == "DIAGONAL_EQUALS_LEFT_TIMES_SOURCE_TIMES_RIGHT",
            "Wrong Smith transformation convention")
    require(matrix_product(matrix_product(left, source), right) == diagonal, "D != U A V")
    for transformation, field in ((left, "left_determinant"), (right, "right_determinant")):
        value = determinant(transformation)
        require(value in (-1, 1) and str(int(value)) == certificate[field],
                "A claimed Smith transformation is not unimodular")
    factors = [diagonal[i][i] for i in range(len(M))]
    require(all(value > 0 for value in factors), "The Smith matrix is not full rank and positive")
    require(all(y % x == 0 for x, y in zip(factors, factors[1:])), "Noncanonical Smith factors")
    require(all(value == (factors[i] if i == j else 0)
                for i, row in enumerate(diagonal) for j, value in enumerate(row)),
            "The proposed Smith form is not diagonal")
    require(certificate["rank"] == len(M), "Wrong Smith rank")
    require([int(x) for x in certificate["invariant_factors"]] == factors, "Wrong Smith factors")
    return factors


def compute(payload, envelope, status):
    factors = check_jacobian(payload, envelope, status)
    example = exact_example()
    require(prod(factors) == example["component_count"], "Smith and character calculations disagree")
    return {
        "claim": "C_KOSZUL_CONTRACTION",
        "prose_application": "C_BETTI_CHL",
        "result_class": "exact_core_of_prose_verification_theorem",
        "machine_checked_scope": [
            "Universal Laurent-polynomial Koszul contracting-homotopy identity.",
            "Universal polynomial degree/weight-center bookkeeping.",
            "All 256 deck characters and all 32 components of one disconnected Kummer cover.",
            "Independent exact verification of the full Jacobian Smith transformations.",
        ],
        "not_machine_checked": [
            "Mellit's geometric stratifications and their identification with the ordered family.",
            "Mixed Hodge functoriality, relative duality, natural base change, and flag geometry.",
            "The prose proof of the all-parameter theorem, its novelty, and independent review.",
            "The full P=W theorem and its separate common-lowering-operator construction.",
        ],
        "universal_core": universal_identities(),
        "disconnected_example": example,
        "jacobian_smith_factors": factors,
        "jacobian_payload": payload,
        "jacobian_typed_output": envelope,
        "jacobian_adapter_status": status,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true",
                        help="Generate the initial certificate from the preserved adapter files.")
    args = parser.parse_args()
    certificate_path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        payload = json.loads((ROOT / "jacobian_payload.json").read_text())
        envelope = json.loads((ROOT / "jacobian_output.json").read_text())
        status = json.loads((ROOT / "jacobian_status.json").read_text())
        result = compute(payload, envelope, status)
        certificate_path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        recorded = json.loads(certificate_path.read_text())
        result = compute(recorded["jacobian_payload"], recorded["jacobian_typed_output"],
                         recorded["jacobian_adapter_status"])
        require(result == recorded, "Certificate differs from the independently recomputed exact result")
    example = result["disconnected_example"]
    print(json.dumps({
        "status": "verified_exact_core",
        "universal_homotopy": True,
        "final_center": "R=(n^2-1)(g-1)",
        "components": example["component_count"],
        "characters_checked": example["cover_degree"],
        "surviving_nontrivial_characters": example["surviving_nontrivial_characters"],
        "geometry_machine_checked": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
