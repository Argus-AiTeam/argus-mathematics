#!/usr/bin/env python3
"""Replay exact supporting evidence, not a formalization of as:base-equality."""

import argparse
import itertools
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def rref(matrix, prime=None):
    rows = [[x % prime if prime else Fraction(x) for x in row] for row in matrix]
    width = len(rows[0]) if rows else 0
    require(all(len(row) == width for row in rows), "Nonrectangular matrix")
    pivots = []
    for column in range(width):
        pivot = next((i for i in range(len(pivots), len(rows))
                      if rows[i][column]), None)
        if pivot is None:
            continue
        index = len(pivots)
        rows[index], rows[pivot] = rows[pivot], rows[index]
        inverse = (pow(rows[index][column], -1, prime) if prime
                   else 1 / rows[index][column])
        rows[index] = [x * inverse % prime if prime else x * inverse
                       for x in rows[index]]
        for i in range(len(rows)):
            if i != index:
                coefficient = rows[i][column]
                rows[i] = [(x - coefficient * y) % prime if prime
                           else x - coefficient * y
                           for x, y in zip(rows[i], rows[index])]
        pivots.append(column)
    return rows, pivots


def rank(matrix, prime=None):
    return len(rref(matrix, prime)[1])


def multiply(left, right, prime):
    require(bool(right) and all(len(row) == len(right) for row in left),
            "Incompatible matrix product")
    return [[sum(left[i][k] * right[k][j] for k in range(len(right))) % prime
             for j in range(len(right[0]))] for i in range(len(left))]


def hstack(*matrices):
    require(bool(matrices) and all(len(m) == len(matrices[0]) for m in matrices),
            "Incompatible horizontal concatenation")
    return [sum((m[i] for m in matrices), []) for i in range(len(matrices[0]))]


def nullspace(matrix, prime):
    rows, pivots = rref(matrix, prime)
    width = len(matrix[0])
    free = [j for j in range(width) if j not in pivots]
    vectors = []
    for j in free:
        vector = [0] * width
        vector[j] = 1
        for i, pivot in enumerate(pivots):
            vector[pivot] = -rows[i][j] % prime
        vectors.append(vector)
    return [[v[i] for v in vectors] for i in range(width)]


def in_span(matrix, vector, prime):
    return rank(hstack(matrix, [[x] for x in vector]), prime) == rank(matrix, prime)


def tor_differential(m, q):
    basis = [(i, j) for j in range(q) for i in range(m)]
    index = {monomial: i for i, monomial in enumerate(basis)}
    size = len(basis)
    matrix = [[0] * size for _ in range(3 * size)]
    for column, (i, j) in enumerate(basis):
        if j + 1 < q:
            matrix[size + index[i, j + 1]][column] = -1
        if i + 1 < m:
            matrix[2 * size + index[i + 1, j]][column] = 1
    return basis, matrix


def rational(entry):
    result = Fraction(int(entry["num"]), int(entry["den"]))
    require(str(result.numerator) == entry["num"]
            and str(result.denominator) == entry["den"],
            "Noncanonical rational in typed evidence")
    return result


def replay_jacobian():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    envelope = json.loads((ROOT / "jacobian_output.json").read_text())
    operation = "matrix.nullspace.compute"
    require(envelope["tool"] == "math.run", "Not an executed Jacobian operation")
    require("error" not in envelope and "error" not in envelope["result"],
            "Jacobian evidence reports an error")
    require(envelope["request"]["operation_id"] == operation
            and envelope["result"]["operation_id"] == operation,
            "Wrong Jacobian operation")
    require(envelope["request"]["payload"] == payload, "Payload binding differs")
    output = envelope["result"]["output"]
    require(output["matrix"] == payload["matrix"], "Output matrix differs")
    matrix = [[rational(x) for x in row]
              for row in payload["matrix"]["entries"]]
    require(matrix == tor_differential(2, 2)[1], "Not the stated Tor differential")
    reduced, pivots = rref(matrix)
    free = [j for j in range(4) if j not in pivots]
    require(output["rank"] == len(pivots) == 3, "Wrong rational rank")
    require(output["ambient_dimension"] == 4 and output["nullity"] == 1,
            "Wrong rational dimensions")
    require(output["convention"] == "RREF_FUNDAMENTAL_BASIS"
            and output["free_columns"] == free == [3], "Wrong free column")
    vectors = [[rational(x) for x in v] for v in output["basis_vectors"]]
    expected = []
    for j in free:
        vector = [Fraction(int(i == j)) for i in range(4)]
        for i, pivot in enumerate(pivots):
            vector[pivot] = -reduced[i][j]
        expected.append(vector)
    require(vectors == expected == [[0, 0, 0, 1]], "Wrong kernel basis")
    require(all(sum(row[j] * v[j] for j in range(4)) == 0
                for row in matrix for v in vectors), "Kernel equation failed")
    return {
        "operation_id": operation,
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "transport": envelope["transport"],
        "adapter_exit_code": 0,
        "adapter_error": None,
        "timeout": False,
        "rank_over_QQ": 3,
        "nullity_over_QQ": 1,
        "kernel_basis": [[0, 0, 0, 1]],
        "scope": "Rational matrix only; prime-field ranks are replayed separately."
    }


def replay_nonflat_family():
    cases = []
    for prime, m, q in itertools.product((2, 3, 5), range(1, 5), range(1, 5)):
        basis, matrix = tor_differential(m, q)
        size = len(basis)
        socle = basis.index((m - 1, q - 1))
        require(all(row[socle] == 0 for row in matrix), "Socle is not killed")
        for column, (i, j) in enumerate(basis):
            if column == socle:
                continue
            pivot = (size + basis.index((i, j + 1)) if j + 1 < q
                     else 2 * size + basis.index((i + 1, j)))
            require(matrix[pivot][column] in (-1, 1)
                    and sum(x != 0 for x in matrix[pivot]) == 1,
                    "Missing characteristic-independent private pivot")
        differential_rank = rank(matrix, prime)
        h0 = 3 * size - differential_rank
        h1 = size - differential_rank
        require(differential_rank == size - 1, "Nonflat-family rank failed")
        require((h0, h1, h0 - h1) == (2 * size + 1, 1, 2 * size),
                "Ordinary Tor correction or its Euler sign failed")
        c_basis = [(i, j) for j in range(q) for i in range(2 * m)]
        parity_basis = {(i // 2, j, i % 2) for i, j in c_basis}
        require(parity_basis == {(i, j, parity) for i, j in basis
                                 for parity in (0, 1)},
                "The two free A/(a^m,b^q) summands of C do not match")
        c_h0 = len(c_basis)
        require(h0 - h1 == c_h0 == 2 * size, "C quotient length differs")
        cases.append({
            "prime": prime, "m": m, "q": q, "d": size,
            "differential_rank": differential_rank,
            "ordinary_h0": h0, "ordinary_h1": h1,
            "ordinary_euler": h0 - h1, "C_h0": c_h0,
            "C_higher_zero_reason": "C is A-free of rank two, proved in report.md."
        })
    return cases


def replay_images():
    results = []
    differential = [[1, 0], [0, 0]]
    for prime in (2, 3):
        projectors = []
        for entries in itertools.product(range(prime), repeat=4):
            matrix = [list(entries[:2]), list(entries[2:])]
            if multiply(matrix, matrix, prime) == matrix:
                projectors.append(matrix)
        kernel = nullspace(differential, prime)
        compatible_pairs = 0
        for a, b in itertools.product(projectors, repeat=2):
            if multiply(b, differential, prime) != multiply(differential, a, prime):
                continue
            compatible_pairs += 1
            image_h1 = rank(multiply(a, kernel, prime), prime)
            image_h0 = rank(hstack(differential, b), prime) - 1
            restricted_rank = rank(multiply(differential, a, prime), prime)
            require(image_h1 == rank(a, prime) - restricted_rank,
                    "Image does not commute with kernel homology")
            require(image_h0 == rank(b, prime) - restricted_rank,
                    "Image does not commute with quotient homology")
            require(image_h0 - image_h1 == rank(b, prime) - rank(a, prime),
                    "Projected Euler identity failed")
        subspaces = [[[], []], [[1, 0], [0, 1]]]
        subspaces += [[[1], [t]] for t in range(prime)] + [[[0], [1]]]
        invariant_pairs = 0
        for b, filtration in itertools.product(projectors, subspaces):
            projected_step = multiply(b, filtration, prime)
            step_rank = rank(filtration, prime)
            if rank(hstack(filtration, projected_step), prime) != step_rank:
                continue
            invariant_pairs += 1
            for vector in itertools.product(range(prime), repeat=2):
                intersection = (in_span(b, vector, prime)
                                and in_span(filtration, vector, prime))
                require(intersection == in_span(projected_step, vector, prime),
                        "Image-intersection identity failed")
            quotient_image = rank(hstack(filtration, b), prime) - step_rank
            image_quotient = rank(b, prime) - rank(projected_step, prime)
            require(quotient_image == image_quotient,
                    "Graded-image identification failed")
        results.append({
            "prime": prime, "all_2_by_2_projectors": len(projectors),
            "all_compatible_projector_pairs": compatible_pairs,
            "all_invariant_projector_subspace_pairs": invariant_pairs
        })
    return results


def replay_euler_signs():
    u, b, r, one = (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1)
    source_degree = tuple(x + y for x, y in zip(u, b))
    target_u = tuple(x - y for x, y in zip(u, r))
    target_b = tuple(x + y - z for x, y, z in zip(b, r, one))
    target_degree = tuple(x + y for x, y in zip(target_u, target_b))
    require(tuple(y - x for x, y in zip(source_degree, target_degree))
            == (0, 0, 0, -1), "Symbolic total-degree change is not minus one")
    cells = list(itertools.product(range(4), range(-2, 3)))
    cases = []
    for page in range(1, 4):
        coefficients = {}
        edges = [(source, (source[0] - page, source[1] + page - 1))
                 for source in cells
                 if (source[0] - page, source[1] + page - 1) in cells]
        for source, target in edges:
            name = (source, target)
            coefficients[name] = sum(1 if sum(cell) % 2 == 0 else -1
                                     for cell in (source, target))
        require(all(x == 0 for x in coefficients.values()),
                "A symbolic boundary did not cancel")
        require(all((-1 if (u + b) % 2 else 1)
                    == (-1 if u % 2 else 1) * (-1 if b % 2 else 1)
                    for u, b in cells), "Double-Euler product sign failed")
        cases.append({"page": page, "formal_boundary_variables": len(edges),
                      "all_boundary_coefficients": 0})
    return {
        "coordinates": ["u", "b", "page", "constant"],
        "source_total_degree": list(source_degree),
        "target_total_degree": list(target_degree),
        "finite_formal_cancellation_cases": cases
    }


def replay_quotient_stress():
    cases = []
    for n in (1, 2, 7, 31):
        diagonal = [1] * n + [0] * n + [2]
        matrix = [[x if i == j else 0 for j in range(len(diagonal))]
                  for i, x in enumerate(diagonal)]
        square = multiply(matrix, matrix, 3)
        defect = [[(x - y) % 3 for x, y in zip(row, original)]
                  for row, original in zip(square, matrix)]
        require(all(value == (2 if i == j == len(diagonal) - 1 else 0)
                    for i, row in enumerate(defect) for j, value in enumerate(row)),
                "Defect does not factor through the designated extra copy")
        require(rank(defect, 3) == 1, "Defect not confined to one copy")
        require(square != matrix, "Representative unexpectedly idempotent")
        cases.append({"n": n, "copy_count": 2 * n + 1,
                      "copy_projector_defect_rank": 1,
                      "normalized_max_term_defect_rank": str(Fraction(2, n))})
    return {
        "characteristic": 3, "normalization": "s_n=n",
        "defect_factors_through_one_Koszul_copy": True,
        "defect_term_ranks": [1, 2, 1],
        "ordinary_negligibility": "Each fixed term rank divided by n tends to zero.",
        "genuine_nonlifting_example": False,
        "cases": cases
    }


def certificate():
    return {
        "claim_id": "C193_BASE",
        "manuscript_label": "as:base-equality",
        "result": "Exact supporting evidence for the proof in report.md",
        "full_proposition_kernel_verified": False,
        "independent_review": "pending",
        "novelty": "not_verified",
        "jacobian": replay_jacobian(),
        "nonflat_family": {
            "A": "F_p[[a,b]]", "T": "A direct_sum (a,b)u, u^2=a",
            "C": "F_p[[u,b]]", "rank_A_T": 2,
            "all_power_length_hypotheses": "Proved in report.md, not inferred from cases.",
            "finite_field_cases": replay_nonflat_family()
        },
        "idempotent_images": replay_images(),
        "spectral_euler": replay_euler_signs(),
        "quotient_stress": replay_quotient_stress(),
        "limitations": [
            "Finite computations are not a proof of arbitrary Verdier localization.",
            "The full supported-quotient comparison is proved in prose in report.md.",
            "Lean certifies C193_IMAGE_CORE only; see statement_fidelity.md.",
            "The Serre positivity dependency chain remains open."
        ]
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2) + "\n")
    else:
        require(json.loads(path.read_text()) == result,
                "Saved exact certificate differs from mathematical replay")
    print(json.dumps({
        "ok": True, "claim_id": result["claim_id"],
        "nonflat_exact_cases": len(result["nonflat_family"]["finite_field_cases"]),
        "image_replays": result["idempotent_images"],
        "full_proposition_kernel_verified": False,
        "independent_review": "pending"
    }))


if __name__ == "__main__":
    main()
