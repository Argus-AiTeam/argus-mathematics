#!/usr/bin/env python3
"""Replay exact identities; bind the universal Lean proof to its real compiler record."""

import argparse
from collections import defaultdict
from hashlib import sha256
import json
from math import comb, gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


class Poly:
    """Sparse polynomials over Z; equality is coefficientwise, not sampled."""

    def __init__(self, value=0):
        if isinstance(value, int):
            self.terms = {(): value} if value else {}
        elif isinstance(value, dict):
            self.terms = {key: val for key, val in value.items() if val}
        else:
            raise TypeError("expected an integer or sparse coefficient dictionary")

    def __add__(self, other):
        other = other if isinstance(other, Poly) else Poly(other)
        terms = defaultdict(int, self.terms)
        for key, val in other.terms.items():
            terms[key] += val
        return Poly(dict(terms))

    __radd__ = __add__

    def __neg__(self):
        return Poly({key: -val for key, val in self.terms.items()})

    def __sub__(self, other):
        other = other if isinstance(other, Poly) else Poly(other)
        return self + (-other)

    def __rsub__(self, other):
        return Poly(other) - self

    def __mul__(self, other):
        other = other if isinstance(other, Poly) else Poly(other)
        terms = defaultdict(int)
        for key1, val1 in self.terms.items():
            for key2, val2 in other.terms.items():
                exponents = defaultdict(int, key1)
                for name, exponent in key2:
                    exponents[name] += exponent
                terms[tuple(sorted(exponents.items()))] += val1 * val2
        return Poly(dict(terms))

    __rmul__ = __mul__

    def __pow__(self, exponent):
        require(isinstance(exponent, int) and exponent >= 0, "invalid polynomial exponent")
        result = Poly(1)
        base = self
        while exponent:
            if exponent & 1:
                result = result * base
            base = base * base
            exponent //= 2
        return result

    def __eq__(self, other):
        other = other if isinstance(other, Poly) else Poly(other)
        return self.terms == other.terms


def var(name):
    return Poly({((name, 1),): 1})


def eye():
    return [[Poly(int(i == k)) for k in range(3)] for i in range(3)]


def unit(i, k):
    return [[Poly(int(row == i and col == k)) for col in range(3)] for row in range(3)]


def madd(left, right):
    return [[left[i][k] + right[i][k] for k in range(3)] for i in range(3)]


def msub(left, right):
    return [[left[i][k] - right[i][k] for k in range(3)] for i in range(3)]


def mscale(scalar, matrix):
    return [[scalar * entry for entry in row] for row in matrix]


def mmul(left, right):
    return [[sum(left[i][k] * right[k][h] for k in range(3)) for h in range(3)]
            for i in range(3)]


def twist(m, a, b):
    return madd(eye(), madd(mscale(m * a, unit(0, 1)), mscale(m * b, unit(1, 2))))


def central(m, exponent):
    return madd(eye(), mscale(m ** 2 * exponent, unit(0, 2)))


def symbolic_identities():
    m, a, b, ap, bp, k, t = map(var, ("m", "a", "b", "ap", "bp", "k", "t"))
    D = [[var(f"D{i}{h}") for h in range(3)] for i in range(3)]
    E = [[var(f"E{i}{h}") for h in range(3)] for i in range(3)]
    N = madd(eye(), mscale(m ** 2, D))
    Np = madd(eye(), mscale(m ** 2, E))
    T = madd(mscale(a, unit(0, 1)), mscale(b, unit(1, 2)))
    g = twist(m, a, b)
    identities = {
        "central_extension_product":
            (mmul(g, twist(m, ap, bp)),
             mmul(twist(m, a + ap, b + bp), central(m, a * bp))),
        "central_transvection_addition":
            (mmul(central(m, k), central(m, t)), central(m, k + t)),
        "central_transvection_inverse":
            (mmul(central(m, k), central(m, -k)), eye()),
        "kernel_addition_error":
            (msub(mmul(N, Np), madd(eye(), mscale(m ** 2, madd(D, E)))),
             mscale(m ** 4, mmul(D, E))),
        "kernel_transport_commutator":
            (msub(mmul(N, g), mmul(g, N)),
             mscale(m ** 3, msub(mmul(D, T), mmul(T, D)))),
        "noncentral_arbitrary_fiber":
            (msub(mmul(central(m, 1), madd(eye(), unit(2, 0))),
                  mmul(madd(eye(), unit(2, 0)), central(m, 1))),
             mscale(m ** 2, msub(unit(0, 0), unit(2, 2)))),
    }
    for name, (left, right) in identities.items():
        require(left == right, f"universal matrix identity failed: {name}")
    a01, a12, b12, b23 = map(var, ("a01", "a12", "b12", "b23"))
    cup_boundary = a12 * b23 - (a01 + a12) * b23 + a01 * (b12 + b23) - a01 * b12
    require(cup_boundary == 0, "cup cocycle identity failed")
    c01, c02, c03, c12, c13, c23 = map(var, ("c01", "c02", "c03", "c12", "c13", "c23"))
    delta_squared = ((c23 - c13 + c12) - (c23 - c03 + c02)
                     + (c13 - c03 + c01) - (c12 - c02 + c01))
    require(delta_squared == 0, "coboundary squared identity failed")
    u = var("u")
    require(c12 - (u + c01 + c12) + c01 == -u, "lifted cochain sign failed")
    return {
        "coefficient_domain": "Z[m,a,b,ap,bp,k,t,D00,...,D22,E00,...,E22,...]",
        "scope": "formal polynomial identities for all integer substitutions",
        "matrix_identities": list(identities),
        "scalar_identities": ["cup_cocycle", "coboundary_squared", "negative_cup_sign"],
        "entries_checked": 9 * len(identities),
        "noncentrality_scope": "m=2^j, j>=1: m^2 is not divisible by m^3",
        "manuscript_refutation": False,
    }


def jacobian_payload():
    a, b = var("a"), var("b")
    D = [[var(f"D{i}{h}") for h in range(3)] for i in range(3)]
    tags = [[var(f"x{i}{h}") for h in range(3)] for i in range(3)]
    N = madd(eye(), mscale(64, D))
    g = twist(Poly(8), a, b)
    residual = msub(mmul(N, g), mmul(g, N))
    tagged = sum(tags[i][h] * residual[i][h] for i in range(3) for h in range(3))
    internal_variables = ["a", "b"] + [f"D{i}{h}" for i in range(3) for h in range(3)]
    internal_variables += [f"x{i}{h}" for i in range(3) for h in range(3)]
    variables = list("abcdefghijklmnopqrst")
    terms = []
    for monomial, coefficient in sorted(tagged.terms.items()):
        exponents = dict(monomial)
        terms.append({"coefficient": str(coefficient),
                      "exponents": [exponents.get(name, 0) for name in internal_variables]})
    return {"modulus": 512, "variables": variables, "left": terms, "right": []}


def replay_jacobian():
    payload = json.loads((HERE / "jacobian/payload-canonical.json").read_text())
    require(payload == jacobian_payload(), "Jacobian payload does not encode the stated commutator")
    envelope = json.loads((HERE / "jacobian/result-canonical.json").read_text())
    require(envelope.get("tool") == "math.run", "not a Jacobian execution envelope")
    require(envelope.get("server", {}).get("version"), "Jacobian server version missing")
    require(envelope.get("protocol_version"), "Jacobian protocol version missing")
    require(envelope["request"]["operation_id"] == "modular.polynomial_identity.compute",
            "Jacobian operation id mismatch")
    require(envelope["request"]["payload"] == payload, "Jacobian did not execute the saved payload")
    result = envelope["result"]
    require(isinstance(result, dict), "Jacobian typed result is absent")
    require(result["operation_id"] == "modular.polynomial_identity.compute",
            "Jacobian result belongs to a different operation")
    value = result["output"]
    require(value.get("identical") is True and value.get("residual") == [],
            "Jacobian did not return a complete positive coefficientwise comparison")
    require(value.get("comparison_scope") == "FORMAL_COEFFICIENTWISE_IDENTITY",
            "Jacobian comparison has a different scope")
    require(value["modulus"] == payload["modulus"] and value["variable_order"] == payload["variables"],
            "Jacobian output has different polynomial parameters")
    status = json.loads((HERE / "jacobian/adapter_status-canonical.json").read_text())
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not exit successfully")
    first_status = json.loads((HERE / "jacobian/adapter_status.json").read_text())
    first_error = json.loads((HERE / "jacobian/result.json").read_text())
    require(first_status["adapter_exit_code"] == 2 and first_error["ok"] is False,
            "initial rejected-request record changed")
    return {
        "operation_id": "modular.polynomial_identity.compute",
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "modulus": 512,
        "status": "success",
        "adapter_error": None,
        "timeout": False,
        "scope": "supplementary fixed-modulus formal coefficient check, not an all-j proof",
        "initial_attempt": {
            "payload": "jacobian/payload.json",
            "output": "jacobian/result.json",
            "adapter_exit_code": first_status["adapter_exit_code"],
            "structured_error": first_error["error"],
            "mathematical_conclusion": "none; request rejected before execution",
        },
    }


def v2(n):
    require(isinstance(n, int) and n != 0, "v2 requires a nonzero integer")
    n = abs(n)
    return (n & -n).bit_length() - 1


def finite_regressions():
    count = 0
    sharp_bounds = 0
    for j in range(1, 13):
        N = 2 ** j
        for D in sorted({min(cap, N - 1) for cap in (1, 2, 3, 7, 8, 15, 16, 31, 32, 63)}):
            L = D.bit_length() - 1
            divisor = 2 ** (j - L)
            common = 0
            for h in range(1, D + 1):
                coefficient = comb(N, h)
                require(coefficient % divisor == 0, "finite coefficient divisibility failed")
                require(v2(coefficient) == j - v2(h), "finite exact valuation failed")
                common = gcd(common, coefficient)
                count += 1
            require(v2(common) == j - L, "finite truncated-ring sharpness regression failed")
            sharp_bounds += 1
    thresholds = []
    for r in (3, 4, 8):
        for n in (-12, -1, 1, 2, 3, 8, 16):
            degree, A = 18, 2
            a = (A - 1).bit_length()
            D = sum(degree ** i for i in range(r + 1)) - 1
            L = D.bit_length() - 1
            j = max(2 * r + 1, a * r + 1, L + v2(n) + 1)
            require(100 * (j + 1) > 4 * r and j > 2 * r, "collar/interpolation threshold failed")
            require(2 ** (2 * j) > 2 * A ** (2 * r), "word injectivity bound failed")
            require(2 ** j > D and j - L > v2(n), "dimension/endpoint threshold failed")
            require(n % (2 ** (j - L)) != 0, "endpoint integer obstruction failed")
            thresholds.append({"r": r, "n": n, "D_r": D, "j": j})
    require((2 + 4 * 1) == 2 * 3 and (2 - 2 * 3) % 4 == 0,
            "Z/4 cohomology integral-lift regression failed")
    return {
        "classification": "finite_regression_only_not_the_uniform_proof",
        "j_range": [1, 12],
        "coefficient_cases": count,
        "truncated_degree_cases": sharp_bounds,
        "explicit_threshold_samples": thresholds,
        "torsion_regression": {
            "cochain_complex": "Z --(t -> (4t,0))--> Z^2 --((x,y) -> y)--> Z",
            "H2": "Z/4",
            "closed_cochain": [2, 0],
            "integer_lift": [3, 0],
            "m": 2,
            "c": 1,
            "identity": "(2,0)+d1(1)=2*(3,0); [2]=2*[3] in Z/4",
        },
    }


def formal_evidence():
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result.get("status") == "success" and result.get("exit_code") == 0,
            "no successful real Lean compiler result")
    require(result.get("proof_holes") == [], "Lean proof has holes")
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    require(sha256(source).hexdigest() == result.get("source_sha256"), "Lean source changed after compilation")
    require(sha256(fidelity.encode()).hexdigest() == result.get("statement_fidelity_sha256"),
            "statement fidelity changed after compilation")
    lean = result.get("tools", {}).get("lean", {}).get("version", "")
    require(lean.startswith("Lean (version 4.31.0,"), "unexpected Lean version")
    declarations = [
        "lifted_triangle", "coboundary_sign", "cup_is_closed", "coboundary_squared",
        "integral_lift_is_closed", "integral_lift_representation", "integral_cocycle_divisible",
        "dyadic_choose_divisible", "nilpotent_binomial_divisible",
        "dyadic_nilpotent_divisible", "dyadic_not_dvd_int",
        "pairing_obstruction", "endpoint_pairing_impossible",
    ]
    for name in declarations:
        require(f"theorem {name}" in source.decode(), f"missing formal declaration: {name}")
    return {
        "claim": "C_CP_ALG",
        "compiler_version": lean,
        "exit_code": 0,
        "proof_holes": [],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "declarations": declarations,
        "scope": "universal algebraic core, not formal construction of topological K-homology",
    }


def certificate():
    return {
        "claim": "C_CP",
        "result_class": "exact_verification_theorem",
        "novelty": "not_claimed",
        "independent_review": "pending_host_reviewer",
        "manuscript_assertions": ["top:chern-divisibility", "top:k-divisibility",
                                  "top:component-detection"],
        "quantifiers": "for every fixed integer r>=3 and fixed n!=0, all j>=J(r,n)",
        "threshold": {
            "A": "max(2, max_s absolute-row-sum norm(s))",
            "a": "ceil(log2 A)",
            "D_r": "sum((|S|+6)^i, i=0,...,r)-1",
            "L_r": "floor(log2 D_r)",
            "J_chern": "max(2r+1, ar+1)",
            "J_K": "max(J_chern, L_r+1)",
            "J_component": "max(J_chern, L_r+v2(|n|)+1)",
        },
        "universal_symbolic_checks": symbolic_identities(),
        "formal_evidence": formal_evidence(),
        "jacobian": replay_jacobian(),
        "finite_regressions": finite_regressions(),
        "standard_topological_inputs": [
            "integer cochain interpretation and line-bundle classification",
            "cellular approximation and integral K^0(CP^D) relation",
            "bilinear natural index pairing and finite-subcomplex Mayer--Vietoris exactness",
            "the torus class tau has pairing one",
        ],
        "remaining_open": [
            "independent review and source attribution of the topological bridge",
            "October maximal-norm analytic transfer and endpoint cancellation",
            "independent audit of the separate September reduced-assembly branch",
            "publication-level novelty and campaign completion",
        ],
        "proof": "proof.md",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prepare-jacobian", action="store_true")
    parser.add_argument("--write", action="store_true", help="write the exact certificate after successful replay")
    args = parser.parse_args()
    if args.prepare_jacobian:
        path = HERE / "jacobian/payload-canonical.json"
        path.write_text(json.dumps(jacobian_payload(), indent=2) + "\n")
        print(json.dumps({"payload": str(path), "operation_id": "modular.polynomial_identity.compute"}))
        return
    actual = certificate()
    path = HERE / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(actual, indent=2) + "\n")
    else:
        expected = json.loads(path.read_text())
        require(actual == expected, "certificate does not match the current replay")
    print(json.dumps({"ok": True, "claim": "C_CP", "universal_matrix_identities": 6,
                      "universal_scalar_identities": 3,
                      "lean_exit_code": 0, "proof_holes": [],
                      "independent_review": "pending_host_reviewer"}))


if __name__ == "__main__":
    main()
