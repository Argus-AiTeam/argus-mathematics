#!/usr/bin/env python3
"""Exact finite Gibbs checks, not a certificate of the asymptotic theorem."""

import argparse
import json
from fractions import Fraction as Q
from itertools import combinations, product
from math import comb, lcm
from pathlib import Path


ROOT = Path(__file__).resolve().parent
N = 8
T = Q(4)
ORDER = 4
MODELS = {
    "independent": {},
    "frustrated_triangle": {
        (0, 1): Q(1, 3),
        (0, 2): Q(-2, 5),
        (1, 2): Q(1, 2),
    },
    "near_frozen_triangle": {
        (0, 1): Q(99, 100),
        (0, 2): Q(-7, 8),
        (1, 2): Q(5, 6),
    },
}
PAIRS = [
    ((0, 1), 1),
    ((0, 2), 1),
    ((1, 2), 1),
    ((0, 3), 5),
    ((1, 3), 5),
    ((2, 3), 5),
    ((3, 4), 10),
]


def zeros(n):
    return [[Q(0) for _ in range(n)] for _ in range(n)]


def dot(x, y):
    return sum((a * b for a, b in zip(x, y)), Q(0))


def mv(a, x):
    return [dot(row, x) for row in a]


def inverse(a):
    n = len(a)
    work = [
        row[:] + [Q(i == j) for j in range(n)]
        for i, row in enumerate(a)
    ]
    for k in range(n):
        pivot = next(i for i in range(k, n) if work[i][k])
        work[k], work[pivot] = work[pivot], work[k]
        scale = work[k][k]
        work[k] = [x / scale for x in work[k]]
        for i in range(n):
            if i != k and work[i][k]:
                scale = work[i][k]
                work[i] = [
                    x - scale * y for x, y in zip(work[i], work[k])
                ]
    result = [row[n:] for row in work]
    for i, row in enumerate(a):
        for j in range(n):
            assert dot(row, [result[k][j] for k in range(n)]) == (i == j)
    return result


def edge_add(a, lo, hi, coefficient):
    a[lo][lo] += coefficient
    a[hi][hi] += coefficient
    a[lo][hi] -= coefficient
    a[hi][lo] -= coefficient


def model(parameters, pair):
    sites = sorted(set(range(3)) | set(pair))
    states = list(product((-1, 1), repeat=len(sites)))
    position = {site: k for k, site in enumerate(sites)}
    index = {x: i for i, x in enumerate(states)}
    weights = []
    for x in states:
        value = Q(1)
        for (i, j), a in parameters.items():
            assert abs(a) < 1
            value *= 1 + a * x[position[i]] * x[position[j]]
        weights.append(value)
    total = sum(weights)
    probabilities = [w / total for w in weights]
    assert sum(probabilities) == 1 and min(probabilities) > 0
    q = [x[position[pair[0]]] * x[position[pair[1]]] for x in states]
    edges = []
    for k, site in enumerate(sites):
        for lo, x in enumerate(states):
            if x[k] != -1:
                continue
            plus = list(x)
            plus[k] = 1
            hi = index[tuple(plus)]
            p, r = probabilities[lo], probabilities[hi]
            conductance = p * r / (p + r)
            a = (p * q[lo] + r * q[hi]) / (p + r)
            edges.append((site, lo, hi, conductance, a))
    return sites, states, probabilities, q, edges


def forms(data, pair, z, degree=ORDER, u=None):
    sites, states, probabilities, q, edges = data
    matrices = [zeros(len(states)) for _ in range(degree + 1)]
    for i, p in enumerate(probabilities):
        matrices[0][i][i] = z * p
        if degree:
            matrices[1][i][i] = z * p * q[i]
    endpoint = zeros(len(states))
    for site, lo, hi, c, a in edges:
        edge_add(matrices[0], lo, hi, T * c)
        if site in pair:
            edge_add(endpoint, lo, hi, T * c)
            if degree:
                edge_add(matrices[1], lo, hi, -T * c * a)
            for k in range(2, degree + 1):
                edge_add(
                    matrices[k], lo, hi,
                    T * c * ((-a) ** k - (-a) ** (k - 2)),
                )
        elif degree:
            assert q[lo] == q[hi]
            edge_add(matrices[1], lo, hi, T * c * q[lo])
    if u is None:
        return matrices, endpoint
    direct = zeros(len(states))
    pu = [p * (1 + u * qi) for p, qi in zip(probabilities, q)]
    assert min(pu) > 0
    for i, p in enumerate(pu):
        direct[i][i] = z * p
    for site, lo, hi, c, a in edges:
        actual = pu[lo] * pu[hi] / (pu[lo] + pu[hi])
        expected = c * (
            (1 - u * u) / (1 + u * a)
            if site in pair else 1 + u * q[lo]
        )
        assert actual == expected
        edge_add(direct, lo, hi, T * actual)
    return direct


def features(data, kind):
    sites, states, probabilities, q, edges = data
    free = N - len(sites)
    one = [Q(1) for _ in states]
    coordinates = [
        [Q(x[k]) for x in states] for k in range(len(sites))
    ]
    if kind == 1:
        result = [(0, x, Q(1, 4)) for x in coordinates]
        if free:
            result.append((1, one, Q(free, 4)))
        return result
    result = [(0, one, Q(1, N))]
    result.extend(
        (0, [a * b for a, b in zip(x, y)], Q(2, N * N))
        for x, y in combinations(coordinates, 2)
    )
    if free:
        result.extend((1, x, Q(2 * free, N * N)) for x in coordinates)
    if free >= 2:
        result.append((2, one, Q(2 * comb(free, 2), N * N)))
    return result


def residual_rhs(data, pair, y):
    sites, states, probabilities, q, edges = data
    position = {site: k for k, site in enumerate(sites)}
    result = [Q(0) for _ in states]
    for site, lo, hi, c, a in edges:
        if site not in pair:
            continue
        other = pair[1] if site == pair[0] else pair[0]
        s = states[lo][position[other]]
        p, r = probabilities[lo], probabilities[hi]
        t = (r - p) / (r + p)
        w = 1 - t * t
        dy = (y[hi] - y[lo]) / 2
        result[lo] += T * w * dy * s * p
        result[hi] += T * w * dy * s * r
    return result


def compact_series(trace):
    result = [1 / (1 + trace[0])]
    for k in range(1, len(trace)):
        result.append(
            -result[0] * sum(
                (trace[j] * result[k - j] for j in range(1, k + 1)),
                Q(0),
            )
        )
    return result


def check_case(parameters, pair, z, kind, cache):
    data = model(parameters, pair)
    sites, states, probabilities, q, edges = data
    mean_q = dot(probabilities, q)
    trace = [Q(0) for _ in range(ORDER + 1)]
    b = energy = residual = endpoint_energy = b1norm = Q(0)
    m1yy = Q(0)
    checks = 0
    for level, feature, multiplicity in features(data, kind):
        shifted_z = z + T * level
        if level not in cache:
            matrices, endpoint = forms(data, pair, shifted_z)
            displaced = {}
            for u in (Q(1, 5), Q(-2, 7)):
                direct = forms(data, pair, shifted_z, u=u)
                displaced[u] = direct, inverse(direct)
            cache[level] = matrices, endpoint, inverse(matrices[0]), displaced
        matrices, endpoint, inv, displaced = cache[level]
        b0 = [p * f for p, f in zip(probabilities, feature)]
        b1 = [v * qi for v, qi in zip(b0, q)]
        y = mv(inv, b0)
        r = [a - c for a, c in zip(b1, mv(matrices[1], y))]
        assert r == residual_rhs(data, pair, y)
        b += multiplicity * dot(b0, y)
        endpoint_energy += multiplicity * dot(y, mv(endpoint, y))
        energy += multiplicity * (
            dot(b0, y) - z * dot(probabilities, [v * v for v in y])
        )
        residual += multiplicity * dot(r, mv(inv, r))
        b1norm += multiplicity * dot(b1, mv(inv, b1))
        m1yy += multiplicity * dot(y, mv(matrices[1], y))

        ys = [y]
        for k in range(1, ORDER + 1):
            target = b1[:] if k == 1 else [Q(0) for _ in states]
            for j in range(1, k + 1):
                target = [
                    a - c
                    for a, c in zip(target, mv(matrices[j], ys[k - j]))
                ]
            ys.append(mv(inv, target))
        for k in range(ORDER + 1):
            coefficient = [Q(0) for _ in states]
            for j in range(k + 1):
                coefficient = [
                    a + c
                    for a, c in zip(coefficient, mv(matrices[j], ys[k - j]))
                ]
            expected = b0 if k == 0 else (
                b1 if k == 1 else [Q(0) for _ in states]
            )
            assert coefficient == expected
            ak = dot(b0, ys[k])
            if k:
                ak += dot(b1, ys[k - 1])
            for j in range(k, ORDER + 1):
                trace[j] += multiplicity * ak * (-mean_q) ** (j - k)

        for u, (direct, direct_inv) in displaced.items():
            bu = [a + u * c for a, c in zip(b0, b1)]
            yu = mv(direct_inv, bu)
            ru = [a - c for a, c in zip(bu, mv(direct, y))]
            actual = dot(bu, yu)
            completed = (
                2 * dot(bu, y) - dot(y, mv(direct, y))
                + dot(ru, mv(direct_inv, ru))
            )
            assert actual == completed
            checks += 1

    assert trace[0] == b
    assert b >= 0 and energy >= 0 and residual >= 0
    gamma = endpoint_energy / (1 + b)
    r2 = residual / (1 + b)
    assert 0 <= gamma <= 1
    assert r2 <= (2 * T / z) * gamma
    assert abs(m1yy) <= b
    assert r2 <= 2 * (b1norm + b) / (1 + b)
    if kind == 2:
        assert b <= 1 / z and b1norm <= 1 / z
        assert r2 <= 2 + 2 / z
    else:
        assert b <= 2 / z
    compact = compact_series(trace)
    return {
        "pair": list(pair),
        "feature": kind,
        "z": str(z),
        "B": str(b),
        "scaled_energy": str(energy),
        "Gamma": str(gamma),
        "R_squared": str(r2),
        "b1_dual_squared": str(b1norm),
        "compact_u_coefficients_0_to_4": [str(v) for v in compact],
        "fourth_theta_derivative_at_zero": str(24 * compact[4] - 16 * compact[2]),
        "source44_margin": str((2 * T / z) * gamma - r2),
        "exact_displaced_completion_checks": checks,
    }


def encode_jacobian():
    data = model(MODELS["frustrated_triangle"], (0, 1))
    matrices, endpoint = forms(data, (0, 1), Q(1), degree=0)
    a = matrices[0]
    denominator = lcm(*(x.denominator for row in a for x in row))
    payload = {
        "matrix": {
            "entries": [[str(int(denominator * x)) for x in row] for row in a]
        }
    }
    return payload, denominator, a


def check_jacobian():
    payload, scale, a = encode_jacobian()
    assert json.loads((ROOT / "jacobian_payload.json").read_text()) == payload
    output = json.loads((ROOT / "jacobian_output.json").read_text())
    assert output["schema_version"] == 1
    assert output["server"]["version"] == "0.14.0"
    assert output["protocol_version"] == "2025-11-25"
    adapter = json.loads((ROOT / "jacobian_adapter_status.json").read_text())
    assert adapter["adapter_exit_code"] == 0
    assert output["request"]["payload"] == payload
    result = output["result"]
    assert result["operation_id"] == "matrix.inverse.compute"
    assert "error" not in result
    typed = result["output"]["inverse"]["entries"]
    supplied = [[Q(v["num"]) / Q(v["den"]) for v in row] for row in typed]
    expected = inverse(a)
    assert [
        [scale * x for x in row] for row in supplied
    ] == expected
    integer_matrix = [[Q(x) for x in row] for row in payload["matrix"]["entries"]]
    for left, right in ((integer_matrix, supplied), (supplied, integer_matrix)):
        for i in range(len(a)):
            for j in range(len(a)):
                assert dot(left[i], [right[k][j] for k in range(len(a))]) == (i == j)
    return {
        "operation_id": "matrix.inverse.compute",
        "matrix_dimension": len(a),
        "integer_scaling": str(scale),
        "protocol_version": output["protocol_version"],
        "server_version": output["server"]["version"],
        "adapter_status": "typed_output_returned",
        "adapter_exit_code": adapter["adapter_exit_code"],
        "structured_error": None,
        "two_sided_inverse_replayed": True,
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
    }


def generate():
    cases = []
    averages = []
    assert sum(weight for pair, weight in PAIRS) == comb(N, 2)
    for name, parameters in MODELS.items():
        for z in (Q(1), Q(3, 2)):
            by_kind = {1: [], 2: []}
            for pair, multiplicity in PAIRS:
                cache = {}
                for kind in (1, 2):
                    case = check_case(parameters, pair, z, kind, cache)
                    case["model"] = name
                    case["pair_multiplicity"] = multiplicity
                    cases.append(case)
                    by_kind[kind].append(case)
            b2 = Q(by_kind[2][0]["B"])
            for case in by_kind[1]:
                assert Q(case["b1_dual_squared"]) ** 2 <= 4 * b2 / z
                excess = max(Q(0), Q(case["R_squared"]) - 2)
                assert excess ** 2 <= 16 * b2 / z
            for kind, group in by_kind.items():
                b = Q(group[0]["B"])
                energy = Q(group[0]["scaled_energy"])
                assert all(Q(case["B"]) == b for case in group)
                assert all(Q(case["scaled_energy"]) == energy for case in group)
                avg_gamma = sum(
                    (Q(case["Gamma"]) * case["pair_multiplicity"] for case in group),
                    Q(0),
                ) / comb(N, 2)
                avg_r2 = sum(
                    (Q(case["R_squared"]) * case["pair_multiplicity"] for case in group),
                    Q(0),
                ) / comb(N, 2)
                avg_r4 = sum(
                    (Q(case["R_squared"]) ** 2 * case["pair_multiplicity"] for case in group),
                    Q(0),
                ) / comb(N, 2)
                assert avg_gamma == Q(2, N) * energy / (1 + b)
                assert avg_r2 <= Q(4, 1) * T / (z * N)
                if kind == 2:
                    assert avg_r4 <= (2 + 2 / z) * 4 * T / (z * N)
                else:
                    excess = max(Q(0), avg_r4 - 4 / z)
                    assert excess ** 2 <= 64 * b2 / z ** 3
                averages.append({
                    "model": name,
                    "z": str(z),
                    "feature": kind,
                    "pair_average_Gamma": str(avg_gamma),
                    "pair_average_R_squared": str(avg_r2),
                    "pair_average_R_fourth": str(avg_r4),
                    "all_28_pairs_accounted_for": True,
                })
    law = [(-2, Q(1, 5)), (-1, Q(1, 4)), (1, Q(1, 2)), (3, Q(1, 20))]
    moments = [sum((p * x ** k for x, p in law), Q(0)) for k in range(5)]
    assert moments == [1, 0, 2, 0, 8]
    return {
        "certificate_kind": "exact_finite_algebra_and_model_verification",
        "asymptotic_theorem_machine_checked": False,
        "manuscript_refutation_found": False,
        "finite_model": {
            "n": N,
            "T": str(T),
            "state_count": 2 ** N,
            "feature_1_scale": "1/2",
            "feature_2_scale": "1/8",
            "coupling_convention": "J_ij/sqrt(n)=atanh(a_ij), with rational a_ij",
            "models": {
                name: {f"{i},{j}": str(a) for (i, j), a in parameters.items()}
                for name, parameters in MODELS.items()
            },
            "reduction": "Independent spectator-spin Fourier sectors; exact, not sampling.",
        },
        "jacobian": check_jacobian(),
        "cases": cases,
        "averages": averages,
        "nonsymmetric_example": {
            "unscaled_law": [[x, str(p)] for x, p in law],
            "unscaled_moments_0_to_4": [str(x) for x in moments],
            "standardization": "J=X/sqrt(2)",
            "standardized_mean_variance_third_fourth": ["0", "1", "0", "2"],
        },
        "scope": [
            "Endpoint multipliers and residual covectors are checked exactly.",
            "The specified source-44 constant and explicit source-45/46 bounds are checked in the listed finite models.",
            "Fourth derivatives are exact coefficients, not a finite proof of the unspecified uniform bound.",
            "The all-disorder identities and variational completion have a separate Lean source.",
            "The Cramer-class comparison theorem is a prose proof conditional on two unverified Gaussian inputs.",
            "Independent Reviewer acceptance and originality assessment are not supplied by this program.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prepare-jacobian", action="store_true")
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    if args.prepare_jacobian:
        payload, scale, a = encode_jacobian()
        (ROOT / "jacobian_payload.json").write_text(json.dumps(payload, indent=2) + "\n")
        print(f"Prepared integer-scaled {len(a)}x{len(a)} Gibbs resolvent mass form; scale={scale}.")
        return
    certificate = generate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    assert json.loads(path.read_text()) == certificate, "Certificate differs from exact replay"
    print(json.dumps({
        "status": "passed",
        "exact_cases": len(certificate["cases"]),
        "models": len(MODELS),
        "all_pairs_per_model": comb(N, 2),
        "asymptotic_theorem_machine_checked": False,
        "refutation_found": False,
    }))


if __name__ == "__main__":
    main()
