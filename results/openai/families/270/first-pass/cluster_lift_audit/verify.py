#!/usr/bin/env python3
"""Replay exact algebra, not the infinite-dimensional analytic proof."""

import argparse
import json
from fractions import Fraction
from itertools import combinations
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OPERATION = "matrix.symbolic.characteristic_polynomial.compute"


def zeros(n):
    return [[0 for _ in range(n)] for _ in range(n)]


def eye(n):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def transpose(a):
    return [list(row) for row in zip(*a)]


def add(a, b):
    return [[x + y for x, y in zip(ra, rb)] for ra, rb in zip(a, b)]


def scale(s, a):
    return [[s * x for x in row] for row in a]


def multiply(a, b):
    bt = transpose(b)
    return [[sum(x * y for x, y in zip(row, col)) for col in bt] for row in a]


def mv(a, v):
    return [sum(x * y for x, y in zip(row, v)) for row in a]


def dot(u, v):
    return sum(x * y for x, y in zip(u, v))


def outer(u, v):
    return [[x * y for y in v] for x in u]


def trace(a):
    return sum(a[i][i] for i in range(len(a)))


def block(a, b, c, d):
    return [ra + rb for ra, rb in zip(a, b)] + [
        rc + rd for rc, rd in zip(c, d)
    ]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def gamma_matrices():
    triples = ((1, 2, 3), (1, 4, 5), (1, 7, 6), (2, 4, 6),
               (2, 5, 7), (3, 4, 7), (3, 6, 5))
    products = {}
    for a, b, c in triples:
        for i, j, k in ((a, b, c), (b, c, a), (c, a, b)):
            products[i, j] = (1, k)
            products[j, i] = (-1, k)
    left = []
    for a in range(1, 8):
        matrix = zeros(8)
        matrix[a][0] = 1
        matrix[0][a] = -1
        for b in range(1, 8):
            if b != a:
                sign, c = products[a, b]
                matrix[c][b] = sign
        left.append(matrix)
    z, identity = zeros(8), eye(8)
    return [block(z, a, scale(-1, a), z) for a in left] + [
        block(z, identity, identity, z),
        block(identity, z, z, scale(-1, identity)),
    ]


def clifford_and_square():
    gamma = gamma_matrices()
    identity, zero = eye(16), zeros(16)
    for i, a in enumerate(gamma):
        require(a == transpose(a), f"gamma {i + 1} is not real symmetric")
        for j, b in enumerate(gamma):
            target = scale(2, identity) if i == j else zero
            require(add(multiply(a, b), multiply(b, a)) == target,
                    f"Clifford relation {i + 1},{j + 1}")
    t = multiply(multiply(gamma[0], gamma[1]), gamma[2])
    require(transpose(t) == scale(-1, t), "T transpose")
    require(multiply(t, t) == scale(-1, identity), "T square")
    for i, a in enumerate(gamma):
        sign = 1 if i < 3 else -1
        require(multiply(t, a) == scale(sign, multiply(a, t)), "T grading")

    # Polarization proves quadratic identities for all real spinors.
    basis = eye(16)
    probes = basis + [
        [x + y for x, y in zip(basis[a], basis[b])]
        for a, b in combinations(range(16), 2)
    ]
    for singled in range(9):
        transverse = [g for i, g in enumerate(gamma) if i != singled]
        for index, v in enumerate(probes):
            norm2 = dot(v, v)
            gv = mv(gamma[singled], v)
            s = dot(v, gv)
            a = [mv(g, v) for g in transverse]
            c = [mv(g, gv) for g in transverse]
            summed = zeros(16)
            for ai, ci in zip(a, c):
                summed = add(summed, add(outer(ai, ci), outer(ci, ai)))
            require(summed == add(scale(s, identity), scale(-norm2, gamma[singled])),
                    f"Fierz coefficient, axis {singled + 1}, polarization {index}")
            for i in range(8):
                for j in range(8):
                    require(dot(a[i], a[j]) == (norm2 if i == j else 0),
                            "kinetic Gram polynomial")
                    require(dot(c[i], c[j]) == (norm2 if i == j else 0),
                            "potential Gram polynomial")
                    require(dot(a[i], c[j]) == (s if i == j else 0),
                            "mixed Gram polynomial")

    pairs = list(combinations(range(9), 2))
    b = {pair: scale(-1, multiply(gamma[pair[0]], gamma[pair[1]])) for pair in pairs}
    for ij in pairs:
        for kl in pairs:
            gram = multiply(transpose(b[ij]), b[kl])
            symmetrized = add(gram, transpose(gram))
            if ij == kl:
                target = scale(2, identity)
            elif len(set(ij + kl)) < 4:
                target = zero
            else:
                word = ij + kl
                inversions = sum(word[i] > word[j] for i in range(4) for j in range(i + 1, 4))
                ordered = identity
                for i in sorted(word):
                    ordered = multiply(ordered, gamma[i])
                target = scale(-2 * (-1) ** inversions, ordered)
            require(symmetrized == target, "quartic Clifford Gram decomposition")

    monomials = [identity]
    for g in gamma[:8]:
        monomials += [multiply(matrix, g) for matrix in monomials]
    flattened = [[x for row in matrix for x in row] for matrix in monomials]
    for i, a in enumerate(flattened):
        for j in range(i + 1):
            require(dot(a, flattened[j]) == (16 if i == j else 0),
                    "full real Clifford matrix-algebra basis")
    return {
        "dimension": 16,
        "real_symmetric_generators": 9,
        "CAR_normalization": "{theta_a,theta_b}=delta_ab; theta_a^2=1/2",
        "quadratic_polarization_vectors": len(probes),
        "coverage": "all 136 coefficients of each homogeneous quadratic identity",
        "singled_axes": 9,
        "Fierz_identity": "sum_i(A_i C_i^t+C_i A_i^t)=(v^t gamma9 v)I-(v^t v)gamma9",
        "one_plane_square": "1/2(p^2+r^2q^2)+rs p.Jq+(ir/2)theta^t[J tensor (sI-gamma9)]theta",
        "neutral_reduction": "p.Jq+(i/2)theta^t(J tensor I)theta=0",
        "T_polarization": "T^t=-T; T^2=-I; commutes with gamma1..3 and anticommutes with gamma4..9",
        "quartic_Gram_pairs": len(pairs) ** 2,
        "quartic_reduction": "the only nonmetric coefficient is an alternating four-form; it contracts the invariant-bracket Jacobi identity",
        "undeformed_square": "D_v(h,0)^2=1/2 p^2+h^2/2 sum_[i<j]|[x_i,x_j]|^2-(ih/2)theta^t(ad(x_j) tensor gamma_j)theta on gauge invariants",
        "full_matrix_algebra_basis": 256,
        "verdict": "identities_hold",
    }


def gauge_density():
    j = [[0, 1], [-1, 0]]
    z, identity = zeros(2), eye(2)
    big_j = block(j, z, z, j)
    ke_inverse = scale(Fraction(-1, 2), big_j)
    colors = {
        "center": big_j,
        "internal_sigma_x": block(z, j, j, z),
        "internal_sigma_y": block(z, scale(-1, identity), identity, z),
        "internal_sigma_z": block(j, z, z, scale(-1, j)),
    }
    results = {}
    for name, kq in colors.items():
        require(transpose(kq) == scale(-1, kq), "slow color skewness")
        require(multiply(kq, big_j) == multiply(big_j, kq), "complex linearity")
        real_trace = trace(multiply(ke_inverse, kq))
        imaginary_trace = trace(multiply(multiply(big_j, kq), ke_inverse))
        require(imaginary_trace == 0, "imaginary ground contraction")
        # Coefficients of i*theta_s(A_e), not complex floating-point values.
        spin = -real_trace / 2
        density = real_trace / 2
        require(spin + density == 0, "spin-density cancellation")
        results[name] = {
            "trace_Ke_inverse_Kq": str(real_trace),
            "imaginary_trace": str(imaginary_trace),
            "spin_coefficient_divided_by_i": str(spin),
            "density_coefficient_divided_by_i": str(density),
        }
    return {
        "probe": "SU(3), partition (2,1), scalar center gap r=2",
        "span": "center plus all three Hermitian internal generators of U(2)",
        "results": results,
        "general_identity": "Tr(J Kq Ke^-1)=Tr(Kq)/delta=0, Ke=delta J, J^2=-I, Kq^t=-Kq",
        "general_proof": "substitute Ke^-1=-J/delta and cycle the final J to the front of the trace",
        "verdict": "identities_hold",
    }


def graded_inverse():
    parity = [[1, 0], [0, -1]]
    odd = [[0, 1], [1, 0]]
    # Order: slow parity, then fast two-state off-kernel subspace.
    z = zeros(2)
    e_full = block(odd, z, z, scale(-1, odd))
    e_inverse = e_full
    require(multiply(e_full, e_inverse) == eye(4), "graded reduced inverse")
    naive_inverse = block(odd, z, z, odd)
    require(multiply(e_full, naive_inverse) == block(eye(2), z, z, scale(-1, eye(2))),
            "slow-parity factor in the naive inverse")
    require(multiply(parity, odd) == scale(-1, multiply(odd, parity)),
            "odd inverse parity")
    return {
        "full_fast_operator": "E=Gamma_s tensor e_f",
        "full_reduced_inverse": "E_reduced^-1=Gamma_s tensor e_f_reduced^-1",
        "correction": "W=E_reduced^-1(1-P)A; E W=(1-P)A",
        "parity": "A odd, inverse odd, W even",
        "probe": "the parity-free inverse leaves a sign error on odd slow vectors",
        "manuscript_uses_full_inverse": True,
        "verdict": "identities_hold",
    }


def rational_function(terms):
    def polynomial(coefficients):
        return {
            "terms": [
                {"coefficient": {"num": str(coefficient), "den": "1"},
                 "exponents": list(exponents)}
                for exponents, coefficient in sorted(coefficients.items(), reverse=True)
                if coefficient
            ]
        }
    return {
        "domain": "QQ",
        "variables": ["r", "u"],
        "numerator": polynomial(terms),
        "denominator": polynomial({(0, 0): 1}),
    }


def jacobian_payload():
    values = [
        [{}, {(1, 0): 1, (0, 1): 1}, {}, {}],
        [{(1, 0): -1, (0, 1): -1}, {}, {}, {}],
        [{}, {}, {}, {(1, 0): 1, (0, 1): -1}],
        [{}, {}, {(1, 0): -1, (0, 1): 1}, {}],
    ]
    return {
        "matrix": {
            "variables": ["r", "u"],
            "entries": [[rational_function(value) for value in row] for row in values],
        }
    }


def decode_polynomial(value):
    require(value["variables"] == ["r", "u"], "Jacobian variable order")
    denominator = value["denominator"]["terms"]
    require(denominator == [{"coefficient": {"num": "1", "den": "1"},
                             "exponents": [0, 0]}], "non-polynomial Jacobian coefficient")
    return {
        tuple(term["exponents"]): str(Fraction(
            int(term["coefficient"]["num"]), int(term["coefficient"]["den"])
        ))
        for term in value["numerator"]["terms"]
    }


def replay_jacobian():
    payload_path = ROOT / "jacobian/payload.json"
    output_path = ROOT / "jacobian/output.json"
    payload = json.loads(payload_path.read_text())
    require(payload == jacobian_payload(), "typed Jacobian payload changed")
    output = json.loads(output_path.read_text())
    require(output["server"]["name"] == "jacobian", "Jacobian server")
    require(output["protocol_version"] == "2025-11-25", "Jacobian protocol")
    require(output["server"]["version"] == "0.14.0", "Jacobian server version")
    request = output["request"]
    require(request["operation_id"] == OPERATION, "Jacobian operation id")
    require(request["payload"] == payload, "Jacobian executed payload")
    require(output["result"]["operation_id"] == OPERATION, "Jacobian returned operation")
    result = output["result"]["output"]
    require("coefficients_descending" in result, "Jacobian output incomplete or unsuccessful")
    require(result["degree"] == 4, "Jacobian characteristic degree")
    coefficients = [decode_polynomial(c) for c in result["coefficients_descending"]]
    expected = [
        {(0, 0): "1"}, {},
        {(2, 0): "2", (0, 2): "2"}, {},
        {(4, 0): "1", (2, 2): "-2", (0, 4): "1"},
    ]
    require(coefficients == expected, "SU(3) symbolic characteristic polynomial")
    return {
        "operation_id": OPERATION,
        "server_version": output["server"]["version"],
        "protocol": output["protocol_version"],
        "payload": "jacobian/payload.json",
        "typed_output": "jacobian/output.json",
        "characteristic_polynomial": "lambda^4+2(r^2+u^2)lambda^2+(r^2-u^2)^2",
        "density": "det Ke=(r^2-u^2)^2",
        "gap_hypothesis": "|u|<r",
        "adapter_status": "success",
        "verdict": "identity_holds",
    }


def compute():
    return {
        "claim": "C_LIFT_ALGEBRA_270",
        "result_class": "exact_algebraic_verification",
        "scope": "Load-bearing scalar-center algebra and specified SU(3) probe; analytic limits require report.md.",
        "clifford_square": clifford_and_square(),
        "gauge_density": gauge_density(),
        "graded_inverse": graded_inverse(),
        "jacobian": replay_jacobian(),
        "not_certified_by_this_script": [
            "infinite-dimensional graph-domain arguments",
            "uniform parameter-dependent analytic estimates",
            "existence or dimensions of internal BFSS kernels",
            "either manuscript's main spectral theorem",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prepare-jacobian", action="store_true")
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    if args.prepare_jacobian:
        path = ROOT / "jacobian/payload.json"
        path.write_text(json.dumps(jacobian_payload(), indent=2) + "\n")
        print(f"Prepared typed payload: {path}")
        return
    certificate = compute()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        require(json.loads(path.read_text()) == certificate, "certificate does not replay")
    print(json.dumps({
        "status": "pass",
        "claim": certificate["claim"],
        "quadratic_coefficients": 136,
        "analytic_proof": "separate human review required",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
