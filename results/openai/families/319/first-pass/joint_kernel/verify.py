#!/usr/bin/env python3
"""Replay the exact subclaims of report.md, not the infinite-action theorem."""

import argparse
from fractions import Fraction
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent.parent
OPERATION = "prime_field.matrix.rank.compute"
PAYLOAD = HERE / "jacobian_rank.payload.json"
RESULT = HERE / "jacobian_rank.result.json"
EXECUTION = HERE / "jacobian_rank.execution.json"
CERTIFICATE = HERE / "exact_certificate.json"
MANUSCRIPT = (
    "research/openai_manuscript/"
    "Counterexamples-to-the-Hahn-Wilson-conjecture-at-height-two-"
    "September-26-2026/build/sections/obstruction.tex"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def rank_mod(entries, prime, columns):
    require(all(len(row) == columns for row in entries), "ragged matrix")
    matrix = [[value % prime for value in row] for row in entries]
    pivot_row = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(pivot_row, len(matrix)) if matrix[row][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        inverse = pow(matrix[pivot_row][column], -1, prime)
        matrix[pivot_row] = [
            value * inverse % prime for value in matrix[pivot_row]
        ]
        for row in range(pivot_row + 1, len(matrix)):
            scalar = matrix[row][column]
            matrix[row] = [
                (left - scalar * right) % prime
                for left, right in zip(matrix[row], matrix[pivot_row])
            ]
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    return pivot_row


def monomial_matrix(t, u, v):
    matrix = [[0] * (t * t) for _ in range(t * t)]
    for i, j in itertools.product(range(t), repeat=2):
        if i + u < t and j + v < t:
            matrix[(i + u) * t + j + v][i * t + j] = 1
    return matrix


def jacobian_payload():
    return {
        "matrix": {
            "prime": 5,
            "columns": 25,
            "entries": monomial_matrix(5, 1, 1),
        }
    }


def interpolation_checks():
    identities = 0
    for d in range(8):
        points = [1 + 5 * i for i in range(d + 1)]
        denominators = []
        for i, point in enumerate(points):
            denominator = 1
            for j, other in enumerate(points):
                if i != j:
                    denominator *= point - other
            denominators.append(denominator)
        complete = [1] + [0] * 6
        for point in points:
            for degree in range(1, 7):
                complete[degree] += point * complete[degree - 1]
        for degree in range(d + 7):
            value = sum(
                (Fraction(point**degree, denominator)
                 for point, denominator in zip(points, denominators)),
                Fraction(0),
            )
            expected = 0 if degree < d else complete[degree - d]
            require(value == expected, "divided-difference identity failed")
            identities += 1
    return {
        "kind": "finite_exact_identity_replay",
        "d": [0, 7],
        "identities": identities,
        "points": "z_i=1+5i; all differences are nonunits at 5",
        "universal_argument": "report.md equation (3), by partial fractions",
    }


def balanced_checks():
    inequalities = 0
    exact_last_counts = 0
    for prime in (2, 3, 5):
        levels = [1, prime, prime**2, prime**3]
        for d in range(min(40, prime**3)):
            for index in range(d + 1):
                for modulus in levels:
                    matches = sum(
                        other != index and (other - index) % modulus == 0
                        for other in range(d + 1)
                    )
                    require(matches <= d // modulus, "denominator count failed")
                    inequalities += 1
            for modulus in levels:
                matches = sum(
                    (other - d) % modulus == 0 for other in range(d)
                )
                require(matches == d // modulus, "last-point count failed")
                exact_last_counts += 1
                occupancies = [
                    sum(other % modulus == residue for other in range(d))
                    for residue in range(modulus)
                ]
                require(min(occupancies) == d // modulus, "balance failed")
    return {
        "kind": "finite_nested_coset_model_not_stabilizer_computation",
        "denominator_inequalities": inequalities,
        "exact_last_point_counts": exact_last_counts,
        "universal_argument": "Euclidean division of the consecutive index set",
    }


def saturation_checks():
    prime = 5
    x = Fraction(5)
    original = [[Fraction(1), Fraction(1)],
                [Fraction(1), Fraction(1) + x]]
    saturated = [
        [row[0], (row[1] - row[0]) / x] for row in original
    ]
    require(saturated == [[1, 0], [1, 1]], "saturation calculation failed")
    before = [[int(value) % prime for value in row] for row in original]
    after = [[int(value) % prime for value in row] for row in saturated]
    before_rank = rank_mod(before, prime, 2)
    after_rank = rank_mod(after, prime, 2)
    require((before_rank, after_rank) == (1, 2), "rank loss model failed")
    return {
        "kind": "finite_DVR_linear_algebra_example_not_orbit_data",
        "original_reduction_rank": before_rank,
        "saturated_reduction_rank": after_rank,
        "divided_vector": [0, 1],
        "universal_argument": "M intersect x-valued functions equals xM",
    }


def group_checks():
    prime = 3
    elements = list(itertools.product(range(prime), repeat=3))
    indices = {element: index for index, element in enumerate(elements)}

    def multiply(left, right):
        a, b, c = left
        u, v, w = right
        return ((a + u) % prime, (b + v) % prime,
                (c + w + a * v) % prime)

    first = (1, 0, 0)
    central = (0, 0, 1)
    rows = []
    for generator in (central, first):
        for h in elements:
            row = [0] * len(elements)
            row[indices[multiply(h, generator)]] += 1
            row[indices[h]] -= 1
            rows.append(row)
    rank = rank_mod(rows, prime, len(elements))
    quotient = len(elements) - rank
    require(quotient == prime, "Heisenberg joint quotient failed")
    left_values = [
        (multiply(h, first)[2] - h[2]) % prime for h in elements
    ]
    right_values = [
        (multiply(first, h)[2] - h[2]) % prime for h in elements
    ]
    require(not any(left_values), "left-translate pairing failed")
    require(any(right_values), "orientation test did not distinguish sides")
    return {
        "kind": "finite_noncommutative_group_model_not_actual_height_two_action",
        "group": "Heisenberg(F_3), (a,b,c)(u,v,w)=(a+u,b+v,c+w+av)",
        "group_order": len(elements),
        "left_ideal_relation_matrix_shape": [len(rows), len(elements)],
        "left_ideal_relation_rank": rank,
        "joint_quotient_dimension": quotient,
        "orientation_witness": "psi(a,b,c)=c kills all h(first-1), not all (first-1)h",
    }


def semilinear_checks():
    prime = 5
    precision = 6
    x = [0, 1, 0, 0, 0, 0]
    gx = [0, 1, 1, 0, 0, 0]

    def multiply(left, right):
        return [
            sum(left[i] * right[degree - i] for i in range(degree + 1)) % prime
            for degree in range(precision)
        ]

    difference = [(left - right) % prime for left, right in zip(gx, x)]
    inner = multiply(x, difference)
    require(difference == [0, 0, 1, 0, 0, 0], "g(x)-x differs")
    require(inner == [0, 0, 0, 1, 0, 0], "semilinear coefficient move differs")
    for hx in (x, gx):
        outer_difference = [0] * precision
        require(not any(multiply(hx, outer_difference)),
                "outer K-linear combination lost its annihilator equation")
    return {
        "kind": "exact_formal_automorphism_example_not_height_two_action",
        "prime": prime,
        "g": "g(x)=x+x^2",
        "mu": "x*(delta_g-1)",
        "f": "1",
        "outer_combination": "Phi(h)=x*h(1)=x satisfies the orbit equation",
        "incorrect_inner_combination": "mu(x*1)=x^3 is nonzero",
        "universal_argument": "equation (9) is K-linear in Phi, not in f",
    }


def monomial_checks():
    count = 0
    for t in range(1, 17):
        for u, v in itertools.product(range(t + 3), repeat=2):
            actual = sum(
                not (i >= u and j >= v)
                for i, j in itertools.product(range(t), repeat=2)
            )
            formula = t * t - max(t - u, 0) * max(t - v, 0)
            require(actual == formula, "monomial counting formula failed")
            require(actual <= (u + v) * t, "monomial dimension bound failed")
            count += 1
    examples = []
    for u, v in ((1, 1), (2, 0), (0, 0), (6, 2)):
        matrix = monomial_matrix(5, u, v)
        rank = rank_mod(matrix, 5, 25)
        quotient = 25 - rank
        expected = 25 - max(5 - u, 0) * max(5 - v, 0)
        require(quotient == expected, "finite-field quotient replay failed")
        examples.append({"t": 5, "u": u, "v": v, "rank": rank,
                         "quotient_dimension": quotient})
    return {
        "kind": "finite_exact_replay_of_general_counting_formula",
        "count_cases": count,
        "finite_field_examples": examples,
        "universal_argument": "report.md equation (12), two exact cases",
    }


def scale_checks():
    count = 0
    for prime in (2, 3, 5, 7):
        values = set(range(1, 513))
        for power in range(5):
            for offset in (-1, 0, 1):
                value = prime ** (3 * power) + offset
                if value > 0:
                    values.add(value)
        for j in sorted(values):
            s = 1
            while prime ** (3 * (s - 1)) <= j:
                s += 1
            require(s >= 2, "wrong lower scale")
            require(prime ** (3 * (s - 2)) <= j, "scale is not minimal")
            require(prime ** (3 * s) <= prime**6 * j, "cubic scale bound failed")
            count += 1
        for n in range(1, 97):
            for lattice in range(6):
                j = 3 * n + 4 * lattice
                difference = (3 + 4 * lattice) * n - j
                require(difference == 4 * lattice * (n - 1),
                        "fixed-lattice algebra failed")
                require(difference >= 0, "fixed-lattice upper bound failed")
    return {
        "kind": "finite_boundary_replay_not_all_precision_enumeration",
        "scale_cases": count,
        "fixed_lattice_cases": 4 * 96 * 6,
        "primes": [2, 3, 5, 7],
        "universal_argument": "minimality of s; t^3=p^6*p^(3(s-2))",
    }


def manuscript_statement():
    source = (PROJECT / MANUSCRIPT).read_text()
    start = source.index(r"\begin{lemma}[Joint-kernel growth]")
    end = source.index(r"\end{lemma}", start) + len(r"\end{lemma}")
    statement = source[start:end]
    require(r"\bigl(\sigma(\bar a_1)\bigr)=(C)" in statement,
            "first symbol hypothesis changed")
    require(r"\sigma(\bar b_1)\notin(C)" in statement,
            "second symbol hypothesis changed")
    require(r"x^{-L_0}R" in statement and r"n\geq1" in statement,
            "lattice or precision quantifier changed")
    return statement


def jacobian_check():
    execution = json.loads(EXECUTION.read_text())
    require(execution["operation_id"] == OPERATION, "wrong adapter operation")
    require(execution["exit_status"] == 0 and not execution["timeout"],
            "adapter did not complete successfully")
    require(execution["adapter_error"] is None, "adapter reported an error")
    payload = json.loads(PAYLOAD.read_text())
    require(payload == jacobian_payload(), "typed rank input differs")
    response = json.loads(RESULT.read_text())
    require(response["server"]["version"] == "0.14.0", "server version differs")
    require(response["protocol_version"] == "2025-11-25",
            "protocol version differs")
    result = response["result"]
    require(result["operation_id"] == OPERATION, "wrong typed result")
    value = result["output"]
    require(value["source"] == payload and value["prime"] == 5,
            "rank result is not bound to the exact input")
    require(value["rank"] == rank_mod(payload["matrix"]["entries"], 5, 25) == 16,
            "independent rank replay disagrees with Jacobian")
    return {
        "operation_id": OPERATION,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "exact_rank": value["rank"],
        "quotient_dimension": 25 - value["rank"],
        "exit_status": execution["exit_status"],
        "timeout": execution["timeout"],
        "adapter_error": execution["adapter_error"],
        "postcondition_boundary": "one 25-by-25 GF(5) rank, not an infinite action",
    }


def compute_certificate():
    return {
        "claim_id": "C_OBS_GROWTH",
        "result_scope": "universal lemma proof relative to three recorded chart inputs",
        "mathematical_status": "prose_proof_pending_independent_review",
        "machine_status": "exact_subclaim_replay_not_kernel_verified",
        "campaign_complete": False,
        "novelty_status": "not_claimed",
        "source": MANUSCRIPT,
        "manuscript_statement": manuscript_statement(),
        "theorem": "v(n)^3 <= D^3*p^6*(3*n+4*L_0), all n>=1; D=0 gives v=0",
        "upstream_assumptions": [
            "A_HEIGHT_TWO_CHART", "A_ORBIT_COUNTS", "A_LEVEL_GROWTH"
        ],
        "interpolation": interpolation_checks(),
        "balanced_counts": balanced_checks(),
        "saturation": saturation_checks(),
        "semilinearity": semilinear_checks(),
        "orientation": group_checks(),
        "finite_quotients": monomial_checks(),
        "scales": scale_checks(),
        "jacobian": jacobian_check(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--prepare-jacobian", action="store_true")
    mode.add_argument("--write-certificate", action="store_true")
    arguments = parser.parse_args()
    if arguments.prepare_jacobian:
        PAYLOAD.write_text(json.dumps(jacobian_payload(), indent=2) + "\n")
        print(f"Prepared exact typed input: {PAYLOAD}")
        return
    fresh = compute_certificate()
    if arguments.write_certificate:
        CERTIFICATE.write_text(json.dumps(fresh, indent=2) + "\n")
        print(f"Wrote exact replay certificate: {CERTIFICATE}")
        return
    recorded = json.loads(CERTIFICATE.read_text())
    require(fresh == recorded, "fresh exact replay differs from saved certificate")
    print("PASS: exact subclaims and typed Jacobian rank replay agree.")
    print("Universal prose proof and actual-chart dependencies still require independent review.")


if __name__ == "__main__":
    main()
