#!/usr/bin/env python3
"""Replay exact certificates; the universal proof is separate from these finite tests."""

import argparse
import json
import math
from fractions import Fraction as Q
from pathlib import Path


def require(condition, message):
    if not condition:
        raise ValueError(message)


def v2_int(x):
    require(x != 0, "valuation of zero was requested")
    x = abs(x)
    return (x & -x).bit_length() - 1


def v2(x):
    x = Q(x)
    return math.inf if x == 0 else v2_int(x.numerator) - v2_int(x.denominator)


def loss(n, k):
    return sum(j * min(j, k) * 2 ** (n - j) for j in range(1, n + 1))


def closed_loss(n, k):
    require(0 <= k <= n, "closed loss outside its domain")
    return 6 * 2**n - (2 * k + 6) * 2 ** (n - k) - k * (n + 2)


def multiply_truncated(a, b, q):
    out = [Q(0) for _ in range(q)]
    for i, x in enumerate(a[:q]):
        for j, y in enumerate(b[: q - i]):
            out[i + j] += x * y
    return out


def inverse_prefix(e, q):
    require(e[0] == 1, "local denominator does not have constant term one")
    b = [Q(1)]
    for j in range(1, q):
        b.append(-sum(e[r] * b[j - r] for r in range(1, j + 1)))
    require(all(v2(x) >= 0 for x in b), "reciprocal is not 2-integral")
    product = multiply_truncated(e, b, q)
    require(product == [1] + [0] * (q - 1), "reciprocal identity failed")
    return b


def local_coefficients(poly, t, alpha, q):
    return [
        sum(
            (poly[d] * math.comb(d, j) * t ** (d - j) * alpha**j
             for d in range(j, len(poly))),
            Q(0),
        )
        for j in range(q)
    ]


def residue(x, p):
    require(v2(x) >= 0, "attempt to reduce a nonintegral rational")
    modulus = 2**p
    return x.numerator * pow(x.denominator, -1, modulus) % modulus


def sweep_grid(max_a):
    require(1 <= max_a <= 8, "grid sweep must remain bounded")
    profiles = 0
    nodes_checked = 0
    for a in range(1, max_a + 1):
        L = 2**a
        S = list(range(-L, L))
        valuations = {t: v2_int(t) for t in S if t}
        for r in range(a + 1):
            require(sum(i == r for i in valuations.values()) == 2 ** (a - r),
                    f"grid valuation count failed at a={a}, r={r}")
        for u in range(1, a + 1):
            for t, i in valuations.items():
                if i >= u:
                    continue
                direct = sum(
                    max(u - valuations[q], 0) * (valuations[q] - v2_int(t - q))
                    for q in valuations if q != t
                )
                n, k = a - i, u - i
                B = loss(n, k)
                require(B == closed_loss(n, k), "finite loss closed form failed")
                require(0 <= B <= 6 * 2**n, "loss bound failed")
                require(direct == -B,
                        f"valuation cancellation failed at a={a}, u={u}, t={t}")
                for j in range(1, n + 1):
                    count = sum(
                        q != t and v2_int(t - q) == i + j
                        for q in valuations
                    )
                    require(count == 2 ** (n - j), "translated shell count failed")
                nodes_checked += 1
            for M in sorted({u, u + 1, 2 * u}):
                h = (3 * M + u - 1) // u
                multiplicity = sum(h * max(u - i, 0) for i in valuations.values())
                require(3 * M <= h * u <= 4 * M, "ceiling bound failed")
                require(multiplicity > M * (2 * L - 1), "insufficient jet count")
                profiles += 1
    return {"parameter_profiles": profiles, "retained_nodes": nodes_checked}


def recovery_rows(a, u, M, p):
    L, alpha = 2**a, 2 ** (a + 1)
    h = (3 * M + u - 1) // u
    nodes = {
        t: h * max(u - v2_int(t), 0)
        for t in range(-L, L) if t and v2_int(t) < u
    }
    rows = []
    for t, q in nodes.items():
        E = Q(1)
        e = [Q(1)] + [Q(0)] * (q - 1)
        for other, m in nodes.items():
            if other == t:
                continue
            E *= Q(-other, t - other) ** m
            c = Q(alpha, t - other)
            require(v2(c) >= 1, "a local factor is not 2-integral")
            factor = [
                Q(math.comb(m, j)) * c**j if j <= m else Q(0)
                for j in range(q)
            ]
            e = multiply_truncated(e, factor, q)
        require(all(v2(x) >= 0 for x in e), "local denominator not integral")
        inverse = inverse_prefix(e, q)
        i = v2_int(t)
        exact_loss = h * loss(a - i, u - i)
        require(v2(E) == -exact_loss, "actual E_t(0) has the wrong valuation")
        x = Q(-t, alpha)
        weights = [
            E * sum((inverse[j - r] * x**j for j in range(r, q)), Q(0))
            for r in range(q)
        ]
        refined = p + exact_loss + (q - 1) * (a + 1 - i)
        paper = p + 8 * h * (L // 2**i) + 8 * M * (a + 1)
        require(refined <= paper, "paper precision does not cover refined bound")
        for weight in weights:
            require(v2(weight) + refined >= p, "refined raw-jet stability failed")
            require(v2(weight) + paper >= p, "paper raw-jet stability failed")
        rows.append({
            "t": t, "q": q, "i": i, "loss": exact_loss,
            "weights": weights, "refined": refined, "paper": paper,
        })
    return rows, alpha


def quotient_ring_multiply(x, y, f, ell):
    e = len(f) - 1
    out = [Q(0)] * (e * ell)
    for cx in range(ell):
        for cy in range(ell - cx):
            coefficients = [Q(0)] * (2 * e - 1)
            for bx in range(e):
                for by in range(e):
                    coefficients[bx + by] += x[cx * e + bx] * y[cy * e + by]
            for d in range(2 * e - 2, e - 1, -1):
                for b in range(e):
                    coefficients[d - e + b] -= coefficients[d] * f[b]
                coefficients[d] = 0
            for b in range(e):
                out[(cx + cy) * e + b] += coefficients[b]
    return out


def check_ring(ring):
    f, ell = ring["f_coefficients_low_to_high"], ring["ell"]
    require(f == [1, 1, 0, 0, 1] and ell == 3, "unexpected ring certificate")
    e = len(f) - 1
    binary = sum((coefficient & 1) << j for j, coefficient in enumerate(f))
    for d in range(1, e // 2 + 1):
        for tail in range(2**d):
            divisor = 2**d + tail
            remainder = binary
            while remainder.bit_length() >= divisor.bit_length():
                remainder ^= divisor << (remainder.bit_length() - divisor.bit_length())
            require(remainder != 0, "ring polynomial is reducible modulo two")
    zero = [Q(0)] * (e * ell)
    one = zero.copy()
    one[0] = 1
    U, V = zero.copy(), zero.copy()
    U[1], V[e] = 1, 1
    V2 = quotient_ring_multiply(V, V, f, ell)
    require(V2 != zero and quotient_ring_multiply(V2, V, f, ell) == zero,
            "nilpotent ring test failed")
    U4 = one
    for _ in range(4):
        U4 = quotient_ring_multiply(U4, U, f, ell)
    require(all(U4[j] + U[j] + one[j] == 0 for j in range(e * ell)),
            "monic quotient relation failed")
    return e, ell


def check_algebra_case(case, ring):
    a, u, M, p = (case[k] for k in ("a", "u", "M", "p"))
    require(1 <= u <= a and M >= u and p >= 1, "inadmissible algebra case")
    rows, alpha = recovery_rows(a, u, M, p)
    N = sum(row["q"] for row in rows)
    require(N == case["expected_total_multiplicity"], "jet count mismatch")
    for row in rows:
        require(row["loss"] == case["expected_loss_by_i"][row["i"]],
                "serialized exact loss mismatch")
    for d in range(N):
        value = Q(0)
        for row in rows:
            coefficients = local_coefficients([Q(0)] * d + [Q(1)],
                                              row["t"], alpha, row["q"])
            value += sum((w * c for w, c in zip(row["weights"], coefficients)), Q(0))
        require(value == (1 if d == 0 else 0),
                f"full monomial-basis interpolation failed at degree {d}")
    e, ell = check_ring(ring)
    polynomials = [[Q(0)] for _ in range(e * ell)]
    polynomials[0] = [Q(1), Q(1, 2), Q(-1), Q(1, 2)]
    polynomials[1] = [Q(2), Q(0), Q(-1)]
    polynomials[e + 1] = [Q(0), Q(-1, 2), Q(1, 2)]
    polynomials[2 * e] = [Q(7), Q(1)]
    require(max(map(len, polynomials)) - 1 <= M * (2 * 2**a - 1),
            "test polynomial exceeds source degree bound")
    for poly in polynomials:
        require(v2(poly[0]) >= 0, "nonintegral F(0)")
        for t in range(-2**a, 2**a):
            require(all(v2(c) >= 0 for c in local_coefficients(poly, t, alpha, len(poly))),
                    "test polynomial violates a local-integrality hypothesis")
    target = [poly[0] for poly in polynomials]
    require(target == ring["expected_constant_coordinates"], "ring target mismatch")
    for precision in ("refined", "paper"):
        recovered = []
        for coordinate, poly in enumerate(polynomials):
            value = Q(0)
            for row in rows:
                P = row[precision]
                coefficients = local_coefficients(poly, row["t"], alpha, row["q"])
                lifts = [
                    Q(residue(c, P) + 2**P * (coordinate + j + row["t"]))
                    for j, c in enumerate(coefficients)
                ]
                value += sum((w * c for w, c in zip(row["weights"], lifts)), Q(0))
            require(v2(value - poly[0]) >= p, "arbitrary-lift ring recovery failed")
            recovered.append(residue(value, p))
        require(recovered == [residue(x, p) for x in target],
                "reconstructed quotient-ring residue mismatch")
    return {"a": a, "u": u, "M": M, "jet_count": N,
            "basis_identities": N, "coordinate_lift_replays": 2 * e * ell}


def canonical_rational(item):
    result = Q(int(item["num"]), int(item["den"]))
    require(str(result.numerator) == item["num"] and str(result.denominator) == item["den"],
            "noncanonical Jacobian rational")
    return result


def check_jacobian(root, specification):
    payload = json.loads((root / specification["payload"]).read_text())
    response = json.loads((root / specification["typed_output"]).read_text())
    require(response["protocol_version"] == specification["protocol_version"],
            "Jacobian protocol mismatch")
    require(response["server"]["version"] == specification["server_version"],
            "Jacobian server version mismatch")
    result = response["result"]
    require(result["operation_id"] == specification["operation_id"] and "output" in result,
            "Jacobian operation failed or returned incomplete output")
    output = result["output"]
    require(output["source"] == payload["table"], "Jacobian retained source mismatch")
    require(output["total_multiplicity"] == 6 and output["degree"] == 2,
            "Jacobian polynomial shape mismatch")
    poly = [Q(0)] * 3
    for term in output["polynomial"]["polynomial"]["terms"]:
        poly[term["exponents"][0]] += canonical_rational(term["coefficient"])
    require(poly == [Q(1), Q(-1, 2), Q(1, 2)], "Jacobian interpolant mismatch")
    expected_replays = []
    for jet in payload["table"]["jets"]:
        t = canonical_rational(jet["node"])
        for derivative in jet["derivatives"]:
            j = derivative["derivative_order"]
            actual = sum(
                (poly[d] * (math.factorial(d) // math.factorial(d - j)) * t ** (d - j)
                 for d in range(j, len(poly))), Q(0)
            )
            require(actual == canonical_rational(derivative["value"]),
                    "independent ordinary-derivative replay failed")
            expected_replays.append((t, j, actual))
    require(len(output["replay"]) == len(expected_replays), "Jacobian replay length mismatch")
    for retained, (t, j, actual) in zip(output["replay"], expected_replays):
        require(canonical_rational(retained["node"]) == t
                and retained["derivative_order"] == j
                and canonical_rational(retained["computed"]) == actual
                and canonical_rational(retained["expected"]) == actual,
                "Jacobian typed constraint replay mismatch")
    return {"operation_id": result["operation_id"], "adapter_status": "success",
            "constraints_independently_replayed": len(expected_replays)}


def check_formal_core(root, certificate):
    archive = json.loads((root / certificate["formal_core_certificate"]).read_text())
    require(archive["tier"] == "mechanical" and archive["verdict"] == "supports"
            and archive["subject"]["subject_id"] == certificate["formal_core_claim"],
            "wrong formal claim or unsupported compiler result")
    require(archive["lean_source"]["text"] == (root / certificate["formal_core"]).read_text(),
            "Lean source differs from the compiler-certified text")
    require(archive["statement_fidelity"]["text"]
            == (root / certificate["statement_fidelity"]).read_text(),
            "statement fidelity differs from the compiler-certified reading")
    result = archive["lean_check"]
    require(result["status"] == "success" and result["exit_code"] == 0
            and result["proof_holes"] == [] and result["audit_exit_code"] == 0
            and result["environment_failure"] == "",
            "formal core is unverified or contains proof holes")
    require(result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
            "unexpected Lean toolchain")
    return {"claim": certificate["formal_core_claim"], "exit_code": 0,
            "proof_holes": [], "source_and_fidelity_match_archive": True,
            "full_recovery_formalized": False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("certificate", nargs="?", type=Path,
                        default=Path(__file__).with_name("exact_certificate.json"))
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())
    root = args.certificate.resolve().parent
    require(certificate["claim"] == "C9000378-HERMITE-FULL", "wrong claim")
    require(certificate["independent_review"] == "pending_host_reviewer",
            "this verifier cannot grant independent review")
    result = {
        "ok": True,
        "universal_proof": "proof.md; formal core separately compiler-certified",
        "finite_replay_only": True,
        "formal_core": check_formal_core(root, certificate),
        "grid": sweep_grid(certificate["grid_sweep_max_a"]),
        "algebra": [check_algebra_case(case, certificate["ring"])
                    for case in certificate["algebra_cases"]],
        "jacobian": check_jacobian(root, certificate["jacobian"]),
    }
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
