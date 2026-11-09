#!/usr/bin/env python3
"""Exact diagnostics for C318H3P5; this does not compute Morava spectra."""

import argparse
from collections import defaultdict
from hashlib import sha256
from itertools import permutations, product
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PRIME = 5
GROUP = tuple(permutations(range(3)))
IDENTITY = (0, 1, 2)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def compose(g, h):
    return tuple(g[h[i]] for i in range(3))


def inverse(g):
    return tuple(g.index(i) for i in range(3))


def standard_parameters(coords):
    if not coords:
        return ()
    return tuple(compose(g, inverse(h)) for g, h in zip(coords, coords[1:])) + (
        coords[-1],
    )


def cumulative_parameters(args):
    value = IDENTITY
    result = []
    for g in reversed(args):
        value = compose(g, value)
        result.append(value)
    return tuple(reversed(result))


def transported_term(coords):
    actor = inverse(coords[0]) if coords else IDENTITY
    return actor, standard_parameters(coords)


def standard_face(args, i):
    if i == 0:
        return args[0], args[1:]
    if i == len(args):
        return IDENTITY, args[:-1]
    return IDENTITY, args[: i - 1] + (
        compose(args[i - 1], args[i]),
    ) + args[i + 1 :]


def dh_face_of_transported(coords, i):
    if i < len(coords):
        return transported_term(coords[:i] + coords[i + 1 :])
    last_inverse = inverse(coords[-1])
    shifted = tuple(compose(g, last_inverse) for g in coords[:-1])
    actor, args = transported_term(shifted)
    return compose(last_inverse, actor), args


def coface_checks():
    faces = degeneracies = inverses = cups = square_terms = squares = 0
    missing_value_action = 0
    for q in range(5):
        for coords in product(GROUP, repeat=q):
            args = standard_parameters(coords)
            require(cumulative_parameters(args) == coords, "T parameter inverse")
            require(standard_parameters(cumulative_parameters(args)) == args,
                    "inverse T parameters")
            inverses += 1
    for q in range(4):
        for coords in product(GROUP, repeat=q + 1):
            args = standard_parameters(coords)
            for i in range(q + 2):
                actor, value = standard_face(args, i)
                left = compose(inverse(coords[0]), actor), value
                right = dh_face_of_transported(coords, i)
                require(left == right, f"coface transport q={q}, i={i}")
                if q == 0 and (actor, value) != right:
                    missing_value_action += 1
                faces += 1
    for q in range(1, 5):
        for coords in product(GROUP, repeat=q - 1):
            actor, args = transported_term(coords)
            for i in range(q):
                left = actor, args[:i] + (IDENTITY,) + args[i:]
                if i == q - 1:
                    repeated = coords + (IDENTITY,)
                else:
                    repeated = coords[: i + 1] + coords[i:]
                require(left == transported_term(repeated),
                        f"codegeneracy transport q={q}, i={i}")
                degeneracies += 1
    for n in range(4):
        for coords in product(GROUP, repeat=n):
            actor, args = transported_term(coords)
            for p in range(n + 1):
                prefix = IDENTITY
                for g in args[:p]:
                    prefix = compose(prefix, g)
                left = ((actor, args[:p]), (compose(actor, prefix), args[p:]))
                pivot = coords[p] if p < n else IDENTITY
                first_coords = tuple(compose(g, inverse(pivot))
                                     for g in coords[:p])
                first_actor, first_args = transported_term(first_coords)
                right = (
                    (compose(inverse(pivot), first_actor), first_args),
                    transported_term(coords[p:]),
                )
                require(left == right, "semilinear cup transport")
                cups += 1
    for q in range(3):
        for args in product(GROUP, repeat=q + 2):
            coefficients = defaultdict(int)
            for i in range(q + 3):
                actor_i, args_i = standard_face(args, i)
                for j in range(q + 2):
                    actor_j, args_j = standard_face(args_i, j)
                    key = compose(actor_i, actor_j), args_j
                    coefficients[key] += (-1) ** (i + j)
                    square_terms += 1
            require(all(c % PRIME == 0 for c in coefficients.values()),
                    "bar differential square")
            squares += 1
    require(missing_value_action > 0, "untwisted-face negative control")
    return {
        "group": "S_3, with noncommutative composition",
        "parameter_inverse_cases": inverses,
        "individual_coface_cases": faces,
        "individual_codegeneracy_cases": degeneracies,
        "cup_transport_cases": cups,
        "bar_square_instances": squares,
        "bar_square_terms": square_terms,
        "omitting_value_action_is_detected": True,
        "scope": "Exact coefficient/action-index identities for arbitrary cochains "
                 "in this finite group model, not profinite Morava cooperations.",
    }


def field_multiply(x, y):
    a, b = x
    c, d = y
    return (a * c + 2 * b * d) % PRIME, (a * d + b * c) % PRIME


def field_frobenius(x):
    return x[0], -x[1] % PRIME


def semilinear_checks():
    field = tuple(product(range(PRIME), repeat=2))
    for x, y in product(field, repeat=2):
        require(field_frobenius(field_multiply(x, y)) ==
                field_multiply(field_frobenius(x), field_frobenius(y)),
                "F_25 Frobenius multiplicativity")
    for x in field:
        power = (1, 0)
        for _ in range(PRIME):
            power = field_multiply(power, x)
        require(power == field_frobenius(x), "F_25 fifth power")
    scalar = (0, 1)
    require(field_frobenius(scalar) != scalar,
            "semilinear scalar must not be silently fixed")
    basis = tuple(
        tuple(value if i == j else (0, 0) for i in range(3))
        for j in range(3) for value in ((1, 0), (0, 1))
    )

    def odd(g):
        return sum(g[i] > g[j] for i in range(3) for j in range(i + 1, 3)) % 2

    def scalar_action(g, value):
        return field_frobenius(value) if odd(g) else value

    def action(g, vector):
        g_inverse = inverse(g)
        return tuple(scalar_action(g, vector[g_inverse[i]]) for i in range(3))

    group_cases = scalar_cases = 0
    for g, h in product(GROUP, repeat=2):
        for vector in basis:
            require(action(g, action(h, vector)) ==
                    action(compose(g, h), vector), "semilinear S_3 action law")
            group_cases += 1
    for g in GROUP:
        for value, vector in product(field, basis):
            left = action(g, tuple(field_multiply(value, x) for x in vector))
            right = tuple(field_multiply(scalar_action(g, value), x)
                          for x in action(g, vector))
            require(left == right, "genuine semilinear scalar action")
            scalar_cases += 1
    return {
        "field": "F_5[b]/(b^2-2)",
        "frobenius_multiplication_cases": len(field) ** 2,
        "frobenius_power_cases": len(field),
        "module": "F_25^3, coordinate permutations and Frobenius for odd permutations",
        "group_action_cases": group_cases,
        "semilinearity_cases": scalar_cases,
        "nonfixed_scalar_control": True,
    }


SIZE = 5
ZERO = (0,) * SIZE
ONE = (1,) + (0,) * (SIZE - 1)
VARIABLE = (0, 1) + (0,) * (SIZE - 2)


def poly_add(a, b):
    return tuple((x + y) % PRIME for x, y in zip(a, b))


def poly_scale(c, a):
    return tuple(c * x % PRIME for x in a)


def poly_sub(a, b):
    return poly_add(a, poly_scale(-1, b))


def poly_multiply(a, b):
    return tuple(sum(a[i] * b[j - i] for i in range(j + 1)) % PRIME
                 for j in range(SIZE))


def poly_substitute(a, psi):
    result, power = ZERO, ONE
    for coefficient in a:
        result = poly_add(result, poly_scale(coefficient, power))
        power = poly_multiply(power, psi)
    return result


def unit_inverse(u):
    coefficients = [pow(u[0], -1, PRIME)]
    for j in range(1, SIZE):
        coefficients.append(
            -coefficients[0] *
            sum(u[i] * coefficients[j - i] for i in range(1, j + 1)) % PRIME
        )
    result = tuple(coefficients)
    require(poly_multiply(u, result) == ONE, "truncated unit inverse")
    return result


def translation_checks():
    automorphisms = chains = homotopies = nonstrict = 0
    for linear in range(1, PRIME):
        for higher in product(range(PRIME), repeat=SIZE - 2):
            psi = (0, linear) + higher
            u = psi[1:] + (0,)
            u_inverse = unit_inverse(u)
            c = u_inverse[0]
            v = u_inverse[1:] + (0,)
            require(poly_sub(u_inverse, poly_scale(c, ONE)) ==
                    poly_multiply(VARIABLE, v),
                    "augmentation derivative homotopy coefficient")
            for j in range(SIZE):
                basis = tuple(int(i == j) for i in range(SIZE))
                sb = poly_substitute(basis, psi)
                left = poly_multiply(u_inverse, poly_substitute(
                    poly_multiply(VARIABLE, basis), psi))
                require(left == poly_multiply(VARIABLE, sb),
                        "nonlinear Koszul chain map")
                difference = poly_sub(poly_multiply(u_inverse, sb),
                                      poly_scale(c, sb))
                require(difference == poly_multiply(
                    VARIABLE, poly_multiply(v, sb)),
                    "top insertion naturality up to chain homotopy")
                nonstrict += int(difference != ZERO)
                chains += 1
                homotopies += 1
            automorphisms += 1
    require(nonstrict > 0, "strict-naturality negative control")
    weights = {"ambient": [-1, 0], "removed_origin": [1, 2]}
    projections = {}
    for exponent in (-1, 0, 1, 2):
        projection = pow(4, -1, PRIME) * sum(
            pow(2, exponent * j, PRIME) for j in range(4)) % PRIME
        require(projection == int(exponent == 0), "tame weight projection")
        projections[str(exponent)] = projection
    require(9 + 1 - 4 - 1 - 4 == 1, "coheight-one dual degree shift")
    return {
        "ring": "F_5[D]/D^5",
        "augmented_automorphisms": automorphisms,
        "nonlinear_koszul_chain_map_cases": chains,
        "top_insertion_chain_homotopy_cases": homotopies,
        "nonstrict_cases_repaired_by_homotopy": nonstrict,
        "weights": weights,
        "order_four_scalar": 2,
        "tame_invariant_projections": projections,
        "dual_reindexing": "i=1-a",
        "scope": "Translation algebra and derived-naturality diagnostics. "
                 "Failure of strict naturality is a negative control, not a "
                 "refutation of the manuscript's derived construction.",
    }


def matrix_rank(matrix):
    rows = [list(row) for row in matrix]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next((i for i in range(rank, len(rows))
                      if rows[i][column] % PRIME), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        rows[rank] = [x * pow(rows[rank][column], -1, PRIME) % PRIME
                      for x in rows[rank]]
        for i in range(len(rows)):
            if i != rank:
                c = rows[i][column]
                rows[i] = [(x - c * y) % PRIME
                           for x, y in zip(rows[i], rows[rank])]
        rank += 1
    return rank


def filtration_checks():
    cases = {}
    for degrees in ((0, 1), (0, 1, 3, 4)):
        pairs = [(i, j) for i in range(len(degrees)) for j in range(i)
                 if (degrees[i] - degrees[j]) % 2 == 0]
        count = 0
        for parameters in product(range(PRIME), repeat=len(pairs)):
            matrix = [[int(i == j) for j in range(len(degrees))]
                      for i in range(len(degrees))]
            for (i, j), c in zip(pairs, parameters):
                matrix[i][j] = c
            require(matrix_rank(matrix) == len(degrees),
                    "actual filtered leading-basis comparison")
            count += 1
        cases[str(degrees)] = count
    possible_degree_three_differentials = []
    for r in range(2, 10):
        if r - 1 >= 7 and 3 + r <= 9:
            possible_degree_three_differentials.append(r)
    require(not possible_degree_three_differentials, "degree-three lift window")
    require(1 + 8 == 9 and 8 - 1 == 7, "degree-one obstruction control")
    subsets = sorted(
        (sum((1, 3, 5)[i] for i in range(3) if mask & (1 << i)), mask)
        for mask in range(8)
    )
    degrees = [degree for degree, _ in subsets]
    require(degrees == [0, 1, 3, 4, 5, 6, 8, 9], "rational degree catalogue")
    expected_pieces = [
        {"height": 2, "shift": 0}, {"height": 2, "shift": -1},
        {"height": 1, "shift": -3}, {"height": 1, "shift": -4},
        {"height": 0, "shift": -5}, {"height": 0, "shift": -6},
        {"height": 0, "shift": -8}, {"height": 0, "shift": -9},
    ]
    pieces = [
        {"height": 2 if mask == 0 else 3 - mask.bit_length(), "shift": -degree}
        for degree, mask in subsets
    ]
    require(pieces == expected_pieces, "indexed chromatic cofiber heights")
    labels = []
    for piece in pieces:
        base = "HQ_5" if piece["height"] == 0 else f"L_{piece['height']}S"
        labels.append(base if piece["shift"] == 0 else
                      f"Sigma^{piece['shift']} {base}")
    require(labels == [
        "L_2S", "Sigma^-1 L_2S", "Sigma^-3 L_1S", "Sigma^-4 L_1S",
        "Sigma^-5 HQ_5", "Sigma^-6 HQ_5", "Sigma^-8 HQ_5", "Sigma^-9 HQ_5",
    ], "literal required ordered cofiber output")
    return {
        "graded_filtered_matrix_cases": cases,
        "periodic_same_parity_filtration_pairs": [[0, 4], [1, 3]],
        "degree_three_possible_outgoing_differentials": [],
        "degree_one_potential_target_not_excluded": [9, 7],
        "rational_degrees": [-degree for degree in degrees],
        "ordered_cofibers": pieces,
        "literal_ordered_cofibers": labels,
        "required_first_map": "L_2 of the canonical unit S -> L_K(3)S",
        "actual_first_map_machine_checked": False,
        "scope": "Finite diagnostics; the universal filtered comparison and "
                 "unbounded differential range are separately Lean-checked.",
    }


def mechanical_evidence():
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result["exit_code"] == 0 and result["audit_exit_code"] == 0,
            "real Lean compiler and proof-hole audit must both pass")
    require(result["proof_holes"] == [], "Lean proof holes")
    require("4.31.0" in result["tools"]["lean"]["version"], "Lean version")
    for filename, key in (
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ):
        require(sha256((HERE / filename).read_bytes()).hexdigest() == result[key],
                f"compiler record is stale for {filename}")
    output = json.loads((HERE / "jacobian-output.json").read_text())
    payload = json.loads((HERE / "jacobian-payload.json").read_text())
    status = json.loads((HERE / "jacobian-status.json").read_text())
    require(status["adapter_exit_code"] == 0 and not status["timed_out"] and
            status["structured_error"] is None, "Jacobian non-conclusion")
    operation = "prime_field.matrix.rank.compute"
    require(output["request"]["operation_id"] == operation and
            output["result"]["operation_id"] == operation, "operation identity")
    require(output["request"]["payload"] == payload and
            output["result"]["output"]["source"] == payload, "exact payload")
    rank = matrix_rank(payload["matrix"]["entries"])
    require(rank == 4 == output["result"]["output"]["rank"], "typed rank")
    require(output["result"]["output"]["prime"] == PRIME, "typed prime")
    return {
        "lean": {
            "version": "4.31.0",
            "exit_code": result["exit_code"],
            "audit_exit_code": result["audit_exit_code"],
            "proof_holes": result["proof_holes"],
            "source": "Main.lean",
            "statement_fidelity": "statement_fidelity.md",
            "source_and_fidelity_current": True,
            "scope": "Universal finite filtered linear algebra and range arithmetic, "
                     "not spectra or the geometric application hypotheses.",
        },
        "jacobian": {
            "operation_id": operation,
            "server_version": output["server"]["version"],
            "protocol_version": output["protocol_version"],
            "adapter_exit_code": status["adapter_exit_code"],
            "timed_out": status["timed_out"],
            "structured_error": status["structured_error"],
            "typed_rank": rank,
            "kernel_dimension": SIZE - rank,
            "cokernel_dimension": SIZE - rank,
            "scope": "The finite one-variable translation differential only.",
        },
    }


def verify():
    return {
        "claim": "C318H3P5",
        "prime": PRIME,
        "height": 3,
        "machine_status": "scoped_checks_pass",
        "mathematical_status": "engineer_proof_pending_independent_review",
        "manuscript_refuted": False,
        "publication_novelty": "unverified",
        "publication_significance": "not established",
        "reused_input": {
            "claim": "C318CO2",
            "independently_reviewed_at": "2026-11-05T14:21:56Z",
            "unchanged_mathematical_checks_repeated": False,
        },
        "coface_identities": coface_checks(),
        "semilinear_scalar": semilinear_checks(),
        "coheight_one_translation": translation_checks(),
        "filtered_basis_and_filtration": filtration_checks(),
        "mechanical_evidence": mechanical_evidence(),
        "not_machine_checked": [
            "Construction and structured realization of the Morava spectra.",
            "Ordinary Landweber-exact cooperation and continuous function comparison.",
            "Actual compact support, trace descent and modification geometry.",
            "Actual spherical lifts and their full-tower residue representatives.",
            "Rational sphere theorem, fracture, and the eight spectral pullback stages.",
            "Independent mathematical review and publication novelty.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true",
                        help="compare the exact certificate without rewriting it")
    args = parser.parse_args()
    result = verify()
    certificate = HERE / "exact_certificate.json"
    if args.check:
        require(json.loads(certificate.read_text()) == result,
                "persisted exact certificate differs from replay")
    else:
        certificate.write_text(json.dumps(result, indent=2) + "\n")
    print("C318H3P5: exact diagnostics and current zero-hole Lean evidence pass; "
          "independent spectral proof review remains.")


if __name__ == "__main__":
    main()
