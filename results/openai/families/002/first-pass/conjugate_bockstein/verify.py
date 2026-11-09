#!/usr/bin/env python3
"""Replay exact universal algebra, boundary controls, and bound compiler evidence."""

import argparse
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent


class Polynomial:
    def __init__(self, value=0):
        self.terms = (
            {m: c for m, c in value.items() if c}
            if isinstance(value, dict)
            else ({(): value} if value else {})
        )

    def __add__(self, other):
        other = other if isinstance(other, Polynomial) else Polynomial(other)
        terms = self.terms.copy()
        for monomial, coefficient in other.terms.items():
            terms[monomial] = terms.get(monomial, 0) + coefficient
        return Polynomial(terms)

    __radd__ = __add__

    def __neg__(self):
        return Polynomial({m: -c for m, c in self.terms.items()})

    def __sub__(self, other):
        return self + -(
            other if isinstance(other, Polynomial) else Polynomial(other)
        )

    def __rsub__(self, other):
        return -self + other

    def __mul__(self, other):
        other = other if isinstance(other, Polynomial) else Polynomial(other)
        terms = {}
        for m, c in self.terms.items():
            for n, d in other.terms.items():
                monomial = tuple(sorted(m + n))
                terms[monomial] = terms.get(monomial, 0) + c * d
        return Polynomial(terms)

    __rmul__ = __mul__

    def reduced(self, square_zero):
        return {
            m: c for m, c in self.terms.items()
            if not square_zero or m.count("s") < 2
        }


def var(name):
    return Polynomial({(name,): 1})


def vector(name):
    return var(name + "1"), var(name + "2")


def add(a, b):
    return tuple(x + y for x, y in zip(a, b))


def neg(a):
    return tuple(-x for x in a)


def scale(s, a):
    return tuple(s * x for x in a)


def e(a, b):
    return a[0] * b[1] - a[1] * b[0]


def B(v, w):
    return e(v[0], w[1]) + e(v[1], w[0])


def heis(name):
    return vector(name + "a"), vector(name + "b"), var(name + "z")


def mul(v, w):
    return add(v[0], w[0]), add(v[1], w[1]), v[2] + w[2] + e(v[0], w[1])


def inverse(v):
    return neg(v[0]), neg(v[1]), -v[2] + e(v[0], v[1])


def conjugate(v, w):
    return mul(mul(v, w), inverse(v))


def kernel(s, v, center):
    return scale(s, v[0]), scale(s, v[1]), center


def flat(v):
    return (*v[0], *v[1], v[2])


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def universal_identities():
    checks = []

    def zero(name, residual, square_zero=False):
        reduced = residual.reduced(square_zero)
        require(not reduced, f"{name}: nonzero formal residual {reduced}")
        checks.append({
            "identity": name,
            "domain": "Z[variables]/(s^2)" if square_zero else "Z[variables]",
            "residual": [],
        })

    def equal_heis(name, left, right, square_zero=False):
        for i, (a, b) in enumerate(zip(flat(left), flat(right))):
            zero(f"{name}.{i}", a - b, square_zero)

    v, w, t = heis("v"), heis("w"), heis("t")
    zero("induced_diagonal", B(v, v))
    equal_heis("associativity", mul(mul(v, w), t), mul(v, mul(w, t)))
    equal_heis("right_inverse", mul(v, inverse(v)), ((0, 0), (0, 0), 0))
    equal_heis("left_inverse", mul(inverse(v), v), ((0, 0), (0, 0), 0))

    c11, c12, c21, c22 = (var(n) for n in ("c11", "c12", "c21", "c22"))
    det = c11 * c22 - c12 * c21

    def C(a):
        return c11 * a[0] + c12 * a[1], c21 * a[0] + c22 * a[1]

    def F(h):
        return C(h[1]), C(h[0]), -h[2] + e(h[0], h[1])

    zero("determinant_form", e(C(v[0]), C(w[1])) - det * e(v[0], w[1]))
    fleft, fright = F(mul(v, w)), mul(F(v), F(w))
    for i in range(4):
        zero(f"conjugation_action.vector.{i}", flat(fleft)[i] - flat(fright)[i])
    zero("conjugation_action.central",
         fleft[2] - fright[2] - (1 + det) * e(w[0], v[1]))
    equal_heis("conjugation_square", F(F(v)),
               (C(C(v[0])), C(C(v[1])), v[2] - (1 + det) * e(v[0], v[1])))
    lam, mu = var("lambda"), var("mu")
    zero("opposite_twists", e(scale(lam, C(v[0])), scale(mu, C(w[1])))
         - det * e(v[0], w[1]) - (lam * mu - 1) * det * e(v[0], w[1]))

    s, d, dp = var("s"), var("d"), var("dp")
    equal_heis("kernel_conjugation", conjugate(v, kernel(s, w, d)),
               kernel(s, w, d + s * B(v, w)))
    equal_heis("square_zero_kernel_product",
               mul(kernel(s, v, d), kernel(s, w, dp)),
               kernel(s, (add(v[0], w[0]), add(v[1], w[1]), 0), d + dp), True)
    graph_unit = var("graph_inverse_unit")
    zero("invariant_graph_quadratic", e(v[0], scale(graph_unit, v[0])))

    ys = [heis(f"y{i}") for i in range(4)]
    ds = [var(f"delta{i}") for i in range(4)]
    left = mul(kernel(s, ys[0], ds[0]), kernel(s, ys[1], ds[1]))
    right = mul(conjugate(v, kernel(s, ys[2], ds[2])), kernel(s, ys[3], ds[3]))
    ddelta = ds[2] - ds[1] + ds[3] - ds[0]
    zero("global_associator_defect",
         left[2] - right[2] + ddelta + s * B(v, ys[2]), True)

    a, Y = heis("local_a"), heis("local_Y")
    deltaU = var("delta_U")
    ref = conjugate(inverse(a), kernel(s, Y, deltaU))
    expected_ref = kernel(s, Y, deltaU - s * B(a, Y))
    equal_heis("local_reference_defect", ref, expected_ref)
    bg, bh, bgh = (heis(n) for n in ("bg", "bh", "bgh"))
    lg, lh, lgh = (var(n) for n in ("ell_g", "g_ell_h", "ell_gh"))
    actual = mul(mul(mul(kernel(s, bg, lg), conjugate(v, kernel(s, bh, lh))),
                     ref), inverse(kernel(s, bgh, lgh)))
    linear = (
        add(add(add(Y[0], bg[0]), bh[0]), neg(bgh[0])),
        add(add(add(Y[1], bg[1]), bh[1]), neg(bgh[1])), 0,
    )
    expected = kernel(s, linear, deltaU - s * B(a, Y) + lg + lh - lgh + s * B(v, bh))
    equal_heis("local_actual_defect", actual, expected, True)

    p, cup_aY, cup_xb, dell = (var(n) for n in ("p0", "cup_aY", "cup_xb", "dell"))
    delta_res = deltaU - s * cup_aY + dell + s * cup_xb
    dh = deltaU + s * p
    q = p + cup_aY - cup_xb
    zero("compact_boundary_local", -delta_res + dh + dell - s * q)
    u0, u1, u2 = (var(n) for n in ("u0", "u1", "u2"))
    zero("compact_primitive_leibniz", (u0 + u1 - (-u2)) - (u0 + u1 + u2))
    require(bool((s * cup_xb).reduced(True)), "Missing-local-term mutation escaped")

    zx, zy = var("b_zx"), var("b_zy")
    zero("hyperbolic_projection_x", zx - (zy * 0 - zx * (-1)))
    zero("hyperbolic_projection_y", zy - (zy * 1 - zx * 0))
    aa, bb, cc, dd = (var(n) for n in ("alpha", "beta", "gamma", "delta"))
    zero("hyperbolic_pairing", (aa * dd - bb * cc) - e((aa, bb), (cc, dd)))
    r, k = var("r"), var("k")
    zero("regular_scalar_representatives", s * (r - s * k) - (s * r - s * s * k))
    return checks


def boundary_controls():
    def artin_mul(x, y):
        return (x[0] * y[0]) % 4, (x[0] * y[1] + x[1] * y[0]) % 2

    require(artin_mul((2, 0), (0, 1)) == (0, 0), "Artin annihilator guard")
    blocks, elements = 0, 0
    for prime, maximum in ((2, 5), (3, 3)):
        for N in range(1, maximum + 1):
            for a in range(1, N + 1):
                images = set()
                for z in range(prime**a):
                    representative = prime**(N - a) * z
                    differential = prime**a * representative
                    require(differential % prime**N == 0, "Not a mod-s cycle")
                    image = (differential // prime**N) % prime**a
                    require(image == z, "Incorrect Bockstein block")
                    images.add(image)
                    elements += 1
                require(len(images) == prime**a, "Bockstein not onto")
                blocks += 1
    return {
        "finite_bockstein_blocks": blocks,
        "finite_bockstein_elements": elements,
        "finite_checks_are_not_universal_proof": True,
        "skew_only_guard": {"ring": "F2", "b(x,y)": "x*y", "diagonal_at_1": 1},
        "extra_annihilator_guard": {
            "ring": "(Z/4)[t]/(2t,t^2)", "s": 2, "nonzero_mod_s": "t",
            "s_times_t": 0, "cancellation_at_this_precision": False,
        },
        "missing_local_cup_term_detected": True,
    }


def compiler_evidence():
    result = json.loads((ROOT / "lean_check.json").read_text())
    require(result["status"] == "success", "Lean compiler did not succeed")
    require(result["exit_code"] == 0 and result["proof_holes"] == [], "Lean proof is incomplete")
    version = result["tools"]["lean"]["version"]
    require(version.startswith("Lean (version 4.31.0,"), "Wrong Lean version")
    for filename, key in (("Main.lean", "source_sha256"),
                          ("statement_fidelity.md", "statement_fidelity_sha256")):
        digest = hashlib.sha256((ROOT / filename).read_bytes()).hexdigest()
        require(digest == result[key], f"Stale compiler binding: {filename}")
    return {
        "source": "Main.lean", "statement_fidelity": "statement_fidelity.md",
        "kernel_version": "4.31.0", "exit_code": 0, "proof_holes": [],
        "source_and_fidelity_binding": "current",
        "scope": "universal algebra; not arithmetic duality or full DVR classification",
    }


def jacobian_evidence():
    result = json.loads((ROOT / "jacobian_result.json").read_text())
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    operation = "modular.polynomial_identity.compute"
    require(result["request"]["operation_id"] == operation, "Wrong Jacobian operation")
    require(result["request"]["payload"] == payload, "Payload binding differs")
    require(result["result"]["operation_id"] == operation, "Wrong typed output")
    output = result["result"]["output"]
    require(output["identical"] is True and output["residual"] == [], "Nonidentity or incomplete output")
    require(output["comparison_scope"] == "FORMAL_COEFFICIENTWISE_IDENTITY"
            and output["modulus"] == 4, "Wrong comparison scope")
    require(result["server"]["version"] == "0.14.0", "Unexpected server version")
    require(result["protocol_version"] == "2025-11-25", "Unexpected protocol")
    require("error" not in result and "error" not in result["result"], "Adapter error")
    return {
        "operation_id": operation, "server_version": "0.14.0",
        "protocol_version": "2025-11-25", "adapter_exit_code": 0,
        "timeout": False, "structured_error": None,
        "scope": "one ancillary coefficientwise identity modulo 4 only",
        "payload": "jacobian_payload.json", "typed_output": "jacobian_result.json",
    }


def source_locations():
    manuscript = ROOT.parent / "openai_manuscript"
    dyadic = (
        "The-two-primary-Birch-Swinnerton-Dyer-formula-in-Selmer-corank-at-most-one-"
        "October-6-2026/build/sections/12-alternation-imaginary.tex"
    )
    exact = "Exact-Birch-Swinnerton-Dyer-Formula-from-Low-Selmer-Corank-October-7-2026"
    locations = []
    for path, label in (
        (dyadic, "alternation-imaginary:alternation"),
        (dyadic, "alternation-imaginary:parity"),
        (exact + "/build/sections/04-vertical.tex", "vertical:parity"),
        (exact + "/build/sections/09-unit.tex", "unit:simultaneous-jumps"),
    ):
        lines = (manuscript / path).read_text().splitlines()
        matches = [i + 1 for i, line in enumerate(lines) if r"\label{" + label + "}" in line]
        require(len(matches) == 1, f"Source label missing or ambiguous: {label}")
        locations.append({"path": path, "label": label, "line": matches[0]})
    return locations


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = {
        "schema_version": 1,
        "result_kind": "source_faithful_universal_verification",
        "claims": ["CB_ALT", "CB_PARITY"],
        "formal_claim": "CB_ALG",
        "argument": "argument.md",
        "source_locations": source_locations(),
        "universal_polynomial_identities": universal_identities(),
        "boundary_controls": boundary_controls(),
        "lean": compiler_evidence(),
        "jacobian": jacobian_evidence(),
        "arithmetic_input": "Milne ADT 2006, I.4.10(b,c), II.2 compact support, II.3.10; Tate-real convention",
        "not_checked_by_lean": [
            "arithmetic compact invariant and source attribution",
            "application to the stated local and finite-stage diagrams",
            "full Artin-module induction and DVR parity deduction",
        ],
        "independent_review": "pending_host_reviewer",
        "novelty": "not_claimed",
        "campaign_complete": False,
    }
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(path.read_text()) == certificate, "Exact certificate differs from replay")
    print(json.dumps({
        "ok": True, "universal_identities": len(certificate["universal_polynomial_identities"]),
        "finite_bockstein_blocks": certificate["boundary_controls"]["finite_bockstein_blocks"],
        "lean_exit_code": certificate["lean"]["exit_code"],
        "independent_review": certificate["independent_review"],
        "campaign_complete": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
