#!/usr/bin/env python3
"""Replay exact algebra and examples; the universal argument is in REPORT.md."""

import argparse
import json
import math
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def zero(matrix):
    return matrix == sp.zeros(matrix.rows, matrix.cols)


def frobenius_squared(matrix):
    return sum(entry * sp.conjugate(entry) for entry in matrix)


def symbolic_certificates(certificate):
    expected = {
        "rayleigh_error_factor": 8,
        "incoming_smallness_denominator": 16,
        "projection_energy_denominator": 4,
        "end_norm_factor": 2,
        "nilpotent_norm_factor": 4,
        "conjugated_norm_factor": 4,
        "first_taylor_order": 4,
        "second_taylor_order": 2,
        "d0_denominator": 1536,
        "start_threshold_numerator": 256,
    }
    require(certificate["universal_constants"] == expected, "Unexpected theorem constants")
    r, R, e, j, K, d, n, A = sp.symbols("r R e j K d n A")
    residual = (r + 8 * R * e) * (1 - e) ** 2 - r - R * (2 * e + e**2)
    positive_decomposition = (
        e * (2 - e) * (R - r) + 4 * R * e * (1 - 4 * e + 2 * e**2)
    )
    identities = {
        "perturbed_rayleigh_residual": residual - positive_decomposition,
        "macro_compensation": (
            2 * (j + 1) ** 2 - j**2 - K - ((j**2 - K) + 4 * j + 2)
        ),
        "bootstrap_cross_product": (
            d**2 * j**3 - 256 * n**3 * A**2 * j**2
            - j**2 * (d**2 * j - 256 * n**3 * A**2)
        ),
    }
    for name, expression in identities.items():
        require(sp.expand(expression) == 0, f"False universal identity: {name}")
    require(
        2**4 * math.factorial(4) * 4 == expected["d0_denominator"],
        "Wrong fourth-order exponential constant",
    )
    require(
        4 * math.factorial(2) * 2 * 16 == expected["start_threshold_numerator"],
        "Wrong backward-bootstrap constant",
    )
    return list(identities)


def propagated_weights(rates, theta, epsilon, scale):
    count, dimension = len(rates), len(rates[0])
    vertices = [(k, i) for k in range(count) for i in range(dimension)]
    raw = [scale * (rates[k][i] - theta) for k, i in vertices]
    weights = raw[:]
    edges = [
        (a, b)
        for a, (k, i) in enumerate(vertices)
        for b, (l, t) in enumerate(vertices)
        if l in (k, k + 1) and rates[l][t] >= rates[k][i] - epsilon * theta
    ]
    for _ in vertices:
        old = weights[:]
        for source, destination in edges:
            weights[destination] = max(weights[destination], old[source])
        if weights == old:
            break
    require(
        all(weights[b] >= weights[a] for a, b in edges),
        "Reachability propagation did not stabilize",
    )
    for index, (k, i) in enumerate(vertices):
        require(raw[index] <= weights[index], "A propagated weight is below its raw weight")
        require(
            weights[index]
            <= scale * (rates[k][i] - theta + (dimension - 1) * epsilon * theta),
            "The record-loss bound fails",
        )
    return [weights[k * dimension : (k + 1) * dimension] for k in range(count)]


def rotation_chain(dimension, cosine, sine):
    require(cosine**2 + sine**2 == 1, "The rational rotation is not orthogonal")
    result = sp.eye(dimension)
    for i in range(dimension - 1):
        rotation = sp.eye(dimension)
        rotation[i, i] = rotation[i + 1, i + 1] = cosine
        rotation[i, i + 1], rotation[i + 1, i] = sine, -sine
        result *= rotation
    require(result * result.T == sp.eye(dimension), "Unitary convention mismatch")
    return result


def nested_lifts(B, old_weights, new_weights):
    dimension = B.rows
    requirements = {}
    for threshold in sorted(set(old_weights + new_weights)):
        coordinates = tuple(i for i, weight in enumerate(old_weights) if weight <= threshold)
        selected = tuple(i for i, weight in enumerate(new_weights) if weight <= threshold)
        requirements[coordinates] = selected
    full = tuple(range(dimension))
    require(full in requirements, "The full coordinate space is missing")
    lifts = {full: sp.eye(dimension)}
    larger, T_plus = full, sp.eye(dimension)
    partial_stages = 0
    proper_partial_stages = 0
    for coordinates in sorted(requirements, key=len, reverse=True):
        if coordinates == full:
            continue
        selected = requirements[coordinates]
        size = len(coordinates)
        if size == 0:
            require(not selected, "Nonzero selected rows project to the empty space")
            continue
        A_rows = B[list(selected), :] if selected else sp.zeros(0, dimension)
        A_E = A_rows[:, list(coordinates)]
        require(A_E.rank() == len(selected), "The required projection is not injective")
        S = T_plus[[larger.index(i) for i in coordinates], :]
        if selected:
            gram = A_E * A_E.T
            R_projected = A_E.T * gram.inv() * A_rows
            P_Y = A_E.T * gram.inv() * A_E
        else:
            R_projected, P_Y = sp.zeros(size, dimension), sp.zeros(size)
        require(P_Y**2 == P_Y and P_Y.T == P_Y, "P_Y is not an orthogonal projection")
        complement = (sp.eye(size) - P_Y) * S
        T = R_projected + complement
        require(T[:, list(coordinates)] == sp.eye(size), "Graph lift has wrong projection")
        require(zero(A_rows - A_E * T), "Graph lift does not contain its required rows")
        require(
            zero(T - T[:, list(larger)] * T_plus),
            "The newly constructed graph is not in the previous graph",
        )
        if 0 < len(selected) < size:
            require(not zero(R_projected) and not zero(complement), "A summand was lost")
            partial_stages += 1
            if len(larger) < dimension:
                proper_partial_stages += 1
        lifts[coordinates] = T
        larger, T_plus = coordinates, T
    result = sp.zeros(dimension)
    for i, weight in enumerate(old_weights):
        coordinates = tuple(t for t, value in enumerate(old_weights) if value <= weight)
        result[i, :] = lifts[coordinates][coordinates.index(i), :]
    for i in range(dimension):
        for l in range(dimension):
            if old_weights[l] <= old_weights[i]:
                require(result[i, l] == int(i == l), "Lift violates strict weight triangularity")
    return result, partial_stages, proper_partial_stages


def verify_run(example):
    rates = [[sp.Rational(x) for x in row] for row in example["rates"]]
    dimension = len(rates[0])
    require(all(len(row) == dimension for row in rates), "Unequal step dimensions")
    require(all(sorted(row) == row and min(row) > 0 for row in rates), "Bad sorted rates")
    require(
        all(new[i] >= old[i] for old, new in zip(rates, rates[1:]) for i in range(dimension)),
        "Coordinate rates decrease",
    )
    j = example["macro_index"]
    theta = sp.Rational(example["Q"]) / j**2
    epsilon, scale = sp.Rational(example["epsilon"]), sp.Rational(example["lambda"])
    require(0 < epsilon < sp.Rational(1, 10 * dimension), "Bad passage epsilon")
    delta = epsilon * theta
    weights = propagated_weights(rates, theta, epsilon, scale)
    require(min(min(row) for row in weights) >= 1, "The weights are not normalized positive")
    U = rotation_chain(
        dimension, sp.Rational(example["rotation_cos"]), sp.Rational(example["rotation_sin"])
    )
    base = sp.Rational(example["diagonal_base"])
    require(0 < base < 1, "Bad diagonal contraction base")
    derivatives = [sp.diag(*(base**rate for rate in row)) for row in rates]
    end = [sp.eye(dimension) for _ in rates]
    start = [sp.eye(dimension) for _ in rates]
    forbidden_counts = [0] * (len(rates) - 1)
    partial_stages = proper_partial_stages = 0
    R = max(max(row) for row in rates)
    A_bound = max(sp.Integer(1), R / (delta * j**2))
    P = 4 * dimension**2 * A_bound * j
    noncommuting_jumps = 0
    for k in reversed(range(len(rates) - 1)):
        difference = sp.diag(*rates[k + 1]) - U * sp.diag(*rates[k]) * U.T
        if zero(difference):
            pass
        else:
            require(
                all(difference[:t, :t].det() > 0 for t in range(1, dimension + 1)),
                "The example violates Loewner order",
            )
        if not zero(U * sp.diag(*rates[k]) * U.T * sp.diag(*rates[k + 1])
                    - sp.diag(*rates[k + 1]) * U * sp.diag(*rates[k]) * U.T):
            noncommuting_jumps += 1
        require(
            frobenius_squared(start[k + 1] - sp.eye(dimension))
            <= (delta / (16 * R)) ** 2,
            "Incoming start adjustment exceeds the proved perturbation budget",
        )
        B = start[k + 1] * U
        end[k], partial, proper_partial = nested_lifts(B, weights[k], weights[k + 1])
        partial_stages += partial
        proper_partial_stages += proper_partial
        N = end[k] - sp.eye(dimension)
        require(zero(N**dimension), "The end adjustment is not unipotent")
        inverse = sp.eye(dimension)
        for power in range(1, dimension):
            inverse += (-N) ** power
        require(end[k] * inverse == inverse * end[k] == sp.eye(dimension), "Bad inverse")
        require(frobenius_squared(N) <= P**2, "The example exceeds the end bound")
        start[k] = derivatives[k].inv() * end[k] * derivatives[k]
        require(end[k] * derivatives[k] == derivatives[k] * start[k], "Derivative changed")
        J = B * inverse
        for i in range(dimension):
            for l in range(dimension):
                if weights[k + 1][i] < weights[k][l]:
                    forbidden_counts[k] += 1
                    require(rates[k][l] > rates[k + 1][i] + delta, "Passage separation fails")
                    require(J[i, l] == 0, "A forbidden jump entry survived")
                if N[i, l] != 0:
                    require(weights[k][i] < weights[k][l], "A lift has forbidden support")
                    require(rates[k][l] > rates[k][i] + delta, "Conjugation has no rate gap")
                    require(
                        (start[k] - sp.eye(dimension))[i, l]
                        == N[i, l] * base ** (rates[k][l] - rates[k][i]),
                        "The diagonal conjugation has the wrong sign",
                    )
    require(forbidden_counts == example["expected_forbidden_entries"], "Wrong zero-pattern test")
    if example["require_proper_partial_extension"]:
        require(proper_partial_stages > 0, "No partial extension inside a proper graph was tested")
    if example["name"].startswith("noncommuting"):
        require(noncommuting_jumps == len(rates) - 1, "The advertised example commutes")
    return {
        "name": example["name"],
        "steps": len(rates),
        "forbidden_entries": forbidden_counts,
        "partial_extension_stages": partial_stages,
        "partial_stages_inside_proper_graphs": proper_partial_stages,
        "noncommuting_jumps": noncommuting_jumps,
    }


def verify_record_loss(example):
    rates = [[sp.Rational(x) for x in example["rates"]]]
    theta = sp.Rational(example["theta"])
    epsilon, scale = sp.Rational(example["epsilon"]), sp.Rational(example["lambda"])
    weights = propagated_weights(rates, theta, epsilon, scale)[0]
    actual = weights[0] / scale - (rates[0][0] - theta)
    require(actual == sp.Rational(example["expected_drop"]), "Wrong sharp record loss")
    require(actual == (len(rates[0]) - 1) * epsilon * theta, "Record bound is not sharp")
    require(len(set(weights)) == 1, "The same-step cycle was not propagated")
    return str(actual)


def typed_matrix(value):
    return sp.Matrix([
        [sp.Rational(entry["num"], entry["den"]) for entry in row]
        for row in value["matrix"]["entries"]
    ])


def verify_jacobian(specification):
    payload = json.loads((ROOT / specification["payload"]).read_text())
    response = json.loads((ROOT / specification["typed_output"]).read_text())
    status = json.loads((ROOT / specification["adapter_status"]).read_text())
    require(status["exit_code"] == 0 and not status["timeout"], "Jacobian did not conclude")
    require(response["request"]["payload"] == payload, "Jacobian payload is not source-bound")
    require(response["server"]["version"] == specification["expected_server_version"],
            "Unexpected Jacobian server version")
    require(response["protocol_version"] == specification["expected_protocol_version"],
            "Unexpected Jacobian protocol")
    require(response["result"]["operation_id"] == specification["operation_id"],
            "Unexpected Jacobian operation")
    output = response["result"]["output"]
    left, right = typed_matrix(payload["left"]), typed_matrix(payload["right"])
    require(typed_matrix(output["left"]) == left and typed_matrix(output["right"]) == right,
            "Jacobian returned different operands")
    difference = right - left
    require(typed_matrix(output["difference"]) == difference, "Wrong PSD difference")
    require(difference[0, 0] > 0 and difference.det() > 0, "Independent PSD replay failed")
    require(output["is_less_or_equal"] is True and output["negative_witness"] is None,
            "Jacobian did not return the expected PSD verdict")
    require(output["inertia"] == {"n_positive": 2, "n_negative": 0, "n_zero": 0},
            "Wrong exact inertia")
    U = sp.Matrix([[sp.Rational(24, 25), sp.Rational(7, 25)],
                   [-sp.Rational(7, 25), sp.Rational(24, 25)]])
    require(left == U * sp.diag(1, 3) * U.T, "Wrong old-rate coordinate transformation")
    require(not zero(left * right - right * left), "The PSD example is commuting")
    return {"operation_id": specification["operation_id"], "determinant": str(difference.det())}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=ROOT / "exact_certificate.json")
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())
    require(certificate["claim"] == "C_LA_UNIFORM", "Unexpected target claim")
    result = {
        "ok": True,
        "claim": certificate["claim"],
        "universal_algebra_identities": symbolic_certificates(certificate),
        "exact_examples": [verify_run(example) for example in certificate["examples"]],
        "sharp_record_loss": verify_record_loss(certificate["record_loss_example"]),
        "jacobian_replay": verify_jacobian(certificate["jacobian"]),
        "scope": "Exact algebra and finite illustrations; universal proof is REPORT.md; Lean core is separate.",
    }
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
