#!/usr/bin/env python3
"""Replay the exact algebra of the dimension-22 construction, without a CAS."""

import argparse
from fractions import Fraction
import json
from math import gcd
from pathlib import Path


ROOT = Path(__file__).resolve().parent
AMBIENT_DIMENSION = 9
CENTERS = [
    {"prime": 2, "projective_factor_dimension": 1, "copies_per_m": 2},
    {"prime": 3, "projective_factor_dimension": 0, "copies_per_m": 3},
    {"prime": 3, "projective_factor_dimension": 2, "copies_per_m": 2},
]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def convolve(left, right):
    result = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            result[i + j] += x * y
    return result


def projective_homology(dimension):
    return [int(i % 2 == 0) for i in range(2 * dimension + 1)]


def add_shift(target, source, shift, multiplicity):
    require(len(source) + shift <= len(target), "homology shift out of range")
    for degree, value in enumerate(source):
        target[degree + shift] += multiplicity * value


def matrix_product(left, right):
    require(len(left[0]) == len(right), "incompatible matrix dimensions")
    return [
        [sum(x * y for x, y in zip(row, column)) for column in zip(*right)]
        for row in left
    ]


def determinant(matrix):
    n = len(matrix)
    require(all(len(row) == n for row in matrix), "nonsquare determinant")
    work = [[Fraction(x) for x in row] for row in matrix]
    answer = Fraction(1)
    for j in range(n):
        pivot = next((i for i in range(j, n) if work[i][j]), None)
        if pivot is None:
            return 0
        if pivot != j:
            work[j], work[pivot] = work[pivot], work[j]
            answer = -answer
        value = work[j][j]
        answer *= value
        for i in range(j + 1, n):
            ratio = work[i][j] / value
            for k in range(j, n):
                work[i][k] -= ratio * work[j][k]
    require(answer.denominator == 1, "nonintegral integer determinant")
    return answer.numerator


def smith_two_by_two(matrix):
    require(len(matrix) == 2 and all(len(row) == 2 for row in matrix),
            "expected a two-by-two presentation")
    first = gcd(*(abs(x) for row in matrix for x in row))
    det = abs(determinant(matrix))
    require(first > 0 and det > 0, "expected a finite lattice cokernel")
    require(det % first == 0, "invalid determinantal divisors")
    diagonal = [first, det // first]
    require(diagonal[1] % diagonal[0] == 0, "Smith divisibility failed")
    return diagonal


def typed_matrix(value):
    require(value["domain"] == "ZZ", "Jacobian matrix is not integral")
    entries = [[int(x) for x in row] for row in value["entries"]]
    require(len(entries) == value["row_count"], "typed row count mismatch")
    require(all(len(row) == value["column_count"] for row in entries),
            "typed column count mismatch")
    return entries


def verify_jacobian(source):
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    envelope = json.loads((ROOT / "jacobian_output.json").read_text())
    status = json.loads((ROOT / "jacobian_status.json").read_text())
    operation = "matrix.normal_form.smith.certified.compute"
    require(status["adapter_exit_code"] == 0, "adapter failure is not evidence")
    require(status["adapter_status"] == "completed" and not status["timed_out"]
            and status["structured_error"] is None,
            "an incomplete or failed adapter run is not evidence")
    require(status["operation_id"] == operation, "wrong adapter operation")
    require(envelope["request"]["operation_id"] == operation, "wrong request")
    require(envelope["request"]["payload"] == payload, "payload not preserved")
    require(typed_matrix(payload["matrix"]) == source, "wrong source matrix")
    result = envelope["result"]
    require(result["operation_id"] == operation, "wrong result operation")
    output = result["output"]
    require(output["completeness"] == "FULL_MATRIX_TRANSFORMATIONS",
            "incomplete Smith output")
    require(output["exactness"] == "EXACT_INTEGER", "inexact Smith output")
    cert = output["certificate"]
    require(cert["relation"] == "DIAGONAL_EQUALS_LEFT_TIMES_SOURCE_TIMES_RIGHT",
            "unrecognized transformation convention")
    require(cert["transformation_scope"] == "FULL_BASIS_BOTH_SIDES",
            "missing basis transformations")
    require(typed_matrix(cert["source"]) == source, "certificate source mismatch")
    left = typed_matrix(cert["left_transformation"])
    right = typed_matrix(cert["right_transformation"])
    diagonal = typed_matrix(cert["diagonal"])
    require(matrix_product(matrix_product(left, source), right) == diagonal,
            "Smith transformation equality failed")
    left_det, right_det = determinant(left), determinant(right)
    require(abs(left_det) == abs(right_det) == 1, "nonunimodular transformations")
    require(left_det == int(cert["left_determinant"])
            and right_det == int(cert["right_determinant"]),
            "incorrect reported determinant")
    invariants = [int(x) for x in cert["invariant_factors"]]
    require(invariants == [1, 1, 2, 6], "unexpected mixed-prime invariant factors")
    require(cert["rank"] == 4, "incomplete rank")
    require(diagonal == [
        [invariants[i] if i == j else 0 for j in range(4)] for i in range(4)
    ], "not the claimed diagonal")
    return {
        "operation_id": operation,
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "adapter_exit_code": status["adapter_exit_code"],
        "runtime_ms": result["runtime_ms"],
        "smith_diagonal": invariants,
        "left_determinant": left_det,
        "right_determinant": right_det,
        "relation_replayed": True,
    }


def invariant_factor_multiplicities(a, q):
    require(a >= 0 and q >= 0, "negative primary multiplicity")
    factors = {"2": max(a - q, 0), "3": max(q - a, 0), "6": min(a, q)}
    require(factors["2"] + factors["6"] == a, "lost 2-primary factors")
    require(factors["3"] + factors["6"] == q, "lost 3-primary factors")
    require(sum(factors.values()) == max(a, q), "generator minimum failed")
    return factors


def generator_rows(primary):
    return [
        invariant_factor_multiplicities(a, q)
        for a, q in zip(primary[2], primary[3])
    ]


def count_polynomials(free_base, free_coefficient, primary):
    generators = [max(a, q) for a, q in zip(primary[2], primary[3])]
    parity_primary = {
        str(p): [sum(row[parity::2]) for parity in (0, 1)]
        for p, row in primary.items()
    }
    parity_generators = [
        max(parity_primary["2"][parity], parity_primary["3"][parity])
        for parity in (0, 1)
    ]
    return {
        "lambda": [sum(free_base), sum(free_coefficient) + 2 * sum(generators)],
        "beta_cyclic": [
            sum(free_base), sum(free_coefficient) + 2 * sum(parity_generators)
        ],
        "primary_totals_by_parity": parity_primary,
        "degreewise_invariant_factors_per_m": generator_rows(primary),
    }


def shift_profile(length, r):
    result = [0] * (length + 1)
    for k in range(1, length - r + 1):
        for ell in range(r + 1):
            result[k + ell] += 1
    return result


def boundary_check(length):
    f0, f1, f2 = (shift_profile(length, r) for r in range(3))
    a = [4 * x for x in f1]
    q = [3 * x + 2 * y for x, y in zip(f0, f2)]
    delta = [x - y for x, y in zip(a, q)]
    c_delta = convolve([1, 1], delta)
    m_delta = convolve([1, 6, 1], delta)
    return {
        "shift_length": length,
        "C_positive_entries": [[j, x] for j, x in enumerate(c_delta) if x > 0],
        "M_positive_entries": [[j, x] for j, x in enumerate(m_delta) if x > 0],
        "sum_primary_2": sum(a),
        "sum_primary_3": sum(q),
    }


def reconstruct():
    rotation2 = [[-1, 0], [0, -1]]
    rotation3 = [[0, -1], [1, -1]]
    identity = [[1, 0], [0, 1]]
    require(matrix_product(rotation2, rotation2) == identity, "wrong order two")
    require(matrix_product(matrix_product(rotation3, rotation3), rotation3)
            == identity, "wrong order three")
    matrices = {
        p: [[rotation[i][j] - identity[i][j] for j in range(2)] for i in range(2)]
        for p, rotation in ((2, rotation2), (3, rotation3))
    }
    smith = {p: smith_two_by_two(matrix) for p, matrix in matrices.items()}
    require(smith == {2: [2, 2], 3: [1, 3]}, "surface cokernels disagree")
    torsion_rank = {p: sum(x > 1 for x in row) for p, row in smith.items()}
    h1_rank = 2
    h3_rank = h1_rank
    h2_rank = h1_rank + h3_rank - 2
    surface_free = [1, h1_rank, h2_rank, h3_rank, 1]
    require(sum((-1) ** i * x for i, x in enumerate(surface_free)) == 0,
            "surface Euler characteristic is not zero")
    mixed_source = ([row + [0, 0] for row in matrices[2]]
                    + [[0, 0] + row for row in matrices[3]])
    jacobian = verify_jacobian(mixed_source)

    dimension = AMBIENT_DIMENSION
    x_base = projective_homology(dimension)
    x_free = [0] * len(x_base)
    x_primary = {2: [0] * len(x_base), 3: [0] * len(x_base)}
    centers = []
    for center in CENTERS:
        p = center["prime"]
        r = center["projective_factor_dimension"]
        copies = center["copies_per_m"]
        center_dimension = 2 + r
        codimension = dimension - center_dimension
        require(codimension >= 2, "center has invalid blowup codimension")
        center_free = convolve(surface_free, projective_homology(r))
        center_torsion = convolve(
            [0, torsion_rank[p], torsion_rank[p], 0, 0],
            projective_homology(r),
        )
        shifts = list(range(1, codimension))
        for k in shifts:
            add_shift(x_free, center_free, 2 * k, copies)
            add_shift(x_primary[p], center_torsion, 2 * k, copies)
        centers.append({
            **center,
            "complex_dimension": center_dimension,
            "codimension": codimension,
            "blowup_shift_indices": shifts,
            "center_total_free_rank": sum(center_free),
        })
    require(2 * max(c["complex_dimension"] for c in centers) + 1 == dimension,
            "wrong simultaneous projection dimension")

    unit_profiles = {}
    for p, raw in x_primary.items():
        odd = [raw[1 + 2 * j] for j in range(dimension)]
        even = [raw[2 + 2 * j] for j in range(dimension)]
        require(odd == even, "the two parity lists do not coincide")
        unit_profiles[str(p)] = odd
    require(unit_profiles == {
        "2": [0, 4, 8, 8, 8, 8, 4, 0, 0],
        "3": [0, 5, 7, 9, 9, 7, 5, 0, 0],
    }, "reconstructed profiles disagree with the theorem")
    require(sum(x_free) == 496 and sum(x_base) == 10, "wrong free rank of X")
    c_factor = projective_homology(1)
    y_factor = [1, 0, 6, 0, 1]
    c_base, c_free = convolve(x_base, c_factor), convolve(x_free, c_factor)
    m_base, m_free = convolve(x_base, y_factor), convolve(x_free, y_factor)
    c_primary = {p: convolve(row, c_factor) for p, row in x_primary.items()}
    m_primary = {p: convolve(row, y_factor) for p, row in x_primary.items()}
    x_counts = count_polynomials(x_base, x_free, x_primary)
    c_counts = count_polynomials(c_base, c_free, c_primary)
    m_counts = count_polynomials(m_base, m_free, m_primary)
    fixed = [4 * x for x in c_counts["lambda"]]
    gap = [x - y for x, y in zip(m_counts["lambda"], fixed)]
    require(c_counts["lambda"] == [20, 1328], "incorrect Morse component count")
    require(m_counts["lambda"] == [80, 5344], "incorrect stable-Morse count")
    require(fixed == m_counts["beta_cyclic"] == [80, 5312],
            "cyclic sharpness failed")
    require(gap == [0, 32], "incorrect strict deficit")

    a, q = unit_profiles["2"][:7], unit_profiles["3"][:7]
    c_a, c_q = convolve([1, 1], a), convolve([1, 1], q)
    m_a, m_q = convolve([1, 6, 1], a), convolve([1, 6, 1], q)
    require(all(x <= y for x, y in zip(c_a, c_q)), "C dominance failed")
    excess = [max(x - y, 0) for x, y in zip(m_a, m_q)]
    require([[j, x] for j, x in enumerate(excess) if x] == [[3, 4], [6, 4]],
            "boundary interaction changed the excess")
    boundaries = [boundary_check(length) for length in (3, 4, 5, 6, 7, 1661)]
    require(all(boundaries[i]["C_positive_entries"] for i in (0, 1)),
            "short-profile negative control failed")
    require(all(not boundaries[i]["C_positive_entries"] for i in (2, 3, 4, 5)),
            "sharp-profile boundary check failed")

    return {
        "claim_id": "C9000347_SHARP22_CORE",
        "scope": "exact integral presentations and all-parameter profile algebra",
        "not_machine_certified": [
            "geometric realization", "Morse attainment", "Hamiltonian dynamics",
            "publishability or novelty", "independent Reviewer approval",
        ],
        "parameter": "m is any nonnegative integer; geometric theorem uses m>=1",
        "coefficient_order": ["constant", "coefficient_of_m"],
        "all_parameter_argument": (
            "Each primary profile is m times its reconstructed unit profile. "
            "For nonnegative u,v,m, max(m*u,m*v)=m*max(u,v); hence the "
            "listed affine coefficient identities hold for every m, "
            "not merely a finite set of evaluated parameters."
        ),
        "ambient_complex_dimension": dimension,
        "M_real_dimension": 2 * (dimension + 2),
        "surface_presentations": {str(p): a for p, a in matrices.items()},
        "surface_smith_diagonals": {str(p): a for p, a in smith.items()},
        "surface_free_ranks": surface_free,
        "jacobian": jacobian,
        "centers": centers,
        "X_free_ranks": {"constant": x_base, "coefficient_of_m": x_free},
        "X_primary_profiles_per_parity_per_m": unit_profiles,
        "X_counts": x_counts,
        "C_counts": c_counts,
        "M_counts": m_counts,
        "convolution_kernels": {"C": [1, 1], "M": [1, 6, 1]},
        "C_primary_profiles_per_parity_per_m": {"2": c_a, "3": c_q},
        "M_primary_profiles_per_parity_per_m": {"2": m_a, "3": m_q},
        "M_positive_excess_per_parity_per_m": excess,
        "fixed_point_count_given_geometric_proof": fixed,
        "stable_Morse_count_given_attainment": m_counts["lambda"],
        "stable_Morse_deficit": gap,
        "finite_boundary_experiments_not_a_universal_L_theorem": boundaries,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--certificate", type=Path,
                        default=ROOT / "exact_certificate.json")
    args = parser.parse_args()
    computed = reconstruct()
    if args.write_certificate:
        args.certificate.write_text(json.dumps(computed, indent=2) + "\n")
    recorded = json.loads(args.certificate.read_text())
    require(recorded == computed, "recorded certificate differs from exact replay")
    print(json.dumps({
        "certificate_valid": True,
        "parameter_domain": "all integers m>=0 (algebra); m>=1 (geometric theorem)",
        "fixed_equals_beta_cyclic": [80, 5312],
        "lambda_M": [80, 5344],
        "deficit": [0, 32],
        "geometry_certified_by_this_script": False,
    }, separators=(",", ":")))


if __name__ == "__main__":
    main()
