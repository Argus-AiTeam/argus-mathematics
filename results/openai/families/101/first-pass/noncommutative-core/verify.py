#!/usr/bin/env python3
"""Replay the dimension-free algebraic certificate and exact falsification probes."""

import hashlib
import json
import random
from fractions import Fraction
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
INVERSES = {
    ("D", "Di"), ("Di", "D"),
    ("S", "Si"), ("Si", "S"),
    ("U", "Ut"), ("Ut", "U"),
}
TRANSPOSE = {"W": "Wt", "Wt": "W", "U": "Ut", "Ut": "U"}


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def nc_add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for word, coefficient in polynomial.items():
            result[word] = result.get(word, Fraction(0)) + coefficient
    return {word: coefficient for word, coefficient in result.items() if coefficient}


def nc_scale(coefficient, polynomial):
    return {word: coefficient * value for word, value in polynomial.items() if coefficient * value}


def nc_mul(*polynomials):
    result = {(): Fraction(1)}
    for polynomial in polynomials:
        result = nc_add(*[
            {left + right: a * b}
            for left, a in result.items()
            for right, b in polynomial.items()
        ])
    return result


def nc_star(polynomial):
    return nc_add(*[
        {
            tuple(TRANSPOSE.get(letter, letter) for letter in reversed(word)):
                coefficient * (-1) ** word.count("C")
        }
        for word, coefficient in polynomial.items()
    ])


def cyclic_key(word):
    word = list(word)
    while len(word) > 1:
        for index in range(len(word)):
            following = (index + 1) % len(word)
            if (word[index], word[following]) in INVERSES:
                if following == 0:
                    word = word[1:-1]
                else:
                    word = word[:index] + word[index + 2:]
                break
        else:
            break
    word = tuple(word)
    return min(word[index:] + word[:index] for index in range(len(word))) if word else ()


def trace_polynomial(polynomial):
    result = {}
    for word, coefficient in polynomial.items():
        direct = cyclic_key(word)
        transposed = cyclic_key(tuple(TRANSPOSE.get(letter, letter) for letter in reversed(word)))
        sign = (-1) ** word.count("C")
        if direct == transposed and sign == -1:
            continue
        key, factor = (direct, 1) if direct <= transposed else (transposed, sign)
        result[key] = result.get(key, Fraction(0)) + factor * coefficient
    return {word: coefficient for word, coefficient in result.items() if coefficient}


def check_trace_algebra(alpha, s):
    identity = {(): Fraction(1)}
    symbols = {
        name: {(name,): Fraction(1)}
        for name in ("X", "W", "S", "Si", "C", "D", "Di", "b", "B", "U", "Ut")
    }
    X, W, S, Si, C, D, Di, b, B, U, Ut = symbols.values()
    E = nc_add(W, nc_scale(-1, nc_mul(X, C, Di)))
    square = nc_mul(nc_star(E), E, D)
    expansion = nc_add(
        nc_mul(nc_star(W), W, D),
        nc_scale(2, nc_mul(C, X, W)),
        nc_mul(Di, nc_star(C), X, X, C),
    )
    require(not trace_polynomial(nc_add(square, nc_scale(-1, expansion))),
            "The noncommutative square completion has an incorrect sign or factor order.")
    require(nc_mul(nc_star(nc_mul(X, C)), X, C) == nc_mul(nc_star(C), X, X, C),
            "The symmetric-X Gram contraction is invalid.")

    commutator = nc_add(nc_mul(S, b), nc_scale(-1, nc_mul(b, S)))
    T = nc_add(S, nc_scale(-1, identity))
    gram = nc_scale(1 / alpha, nc_add(Si, nc_scale(-1 / s, identity)))
    P = nc_add(nc_mul(T, b, gram, b), nc_scale(-1, nc_mul(T, gram, b, b)))
    p_square = nc_scale(1 / (2 * alpha),
                        nc_mul(nc_star(commutator), Si, commutator, Si))
    require(not trace_polynomial(nc_add(P, nc_scale(-1, p_square))),
            "The manuscript P-square identity fails in cyclic transpose algebra.")

    expression = nc_add(
        nc_mul(T, b, B, b),
        nc_scale(-1, nc_mul(T, B, b, b)),
        nc_scale(2, nc_mul(commutator, X, W)),
        nc_mul(nc_star(W), W, D),
    )
    transformed = {}
    for word, coefficient in expression.items():
        factors = [nc_mul(Ut, symbols.get(letter, {(letter,): Fraction(1)}), U) for letter in word]
        transformed = nc_add(transformed, nc_scale(coefficient, nc_mul(*factors)))
    require(trace_polynomial(transformed) == trace_polynomial(expression),
            "Orthogonal conjugation does not preserve the trace expression.")
    return ["noncommutative_square_completion", "symmetric_gram_contraction",
            "manuscript_P_square_identity", "orthogonal_trace_invariance"]


def check_scalar_algebra(certificate):
    parameters = certificate["parameters"]
    require(parameters == {"alpha": "3/40", "s": "40/37", "h": "5/37", "constant": "42/37"},
            "The certificate changed a manuscript constant.")
    alpha, s, h, constant = (Fraction(parameters[key]) for key in ("alpha", "s", "h", "constant"))
    require(constant == 1 + s / 8 and h == constant - 1, "The target constant is inconsistent.")
    u, v, a, b, sigma, tau, d, z, w, A = sp.symbols("u v a b sigma tau d z w A")
    G = sum(
        sp.Rational(term["coefficient"]) * u ** term["exponents"][0] * v ** term["exponents"][1]
        for term in certificate["residual_polynomial"]["terms"]
    )
    require(sp.expand(G - (u * v * (u + v - sp.Rational(3, 4)) + sp.Rational(1, 64))) == 0,
            "The supplied residual polynomial is not G.")
    low = (u + v - sp.Rational(1, 2)) ** 2 * ((u + v) / 4 + sp.Rational(1, 16))
    low += (u - v) ** 2 * (sp.Rational(3, 4) - u - v) / 4
    alternative = (a * b - sp.Rational(1, 4)) ** 2 * (2 * a * b + sp.Rational(1, 4))
    alternative += (a * b) ** 2 * (a - b) ** 2
    require(sp.expand(G - low) == 0, "The low-region weighted-square identity is false.")
    require(sp.expand(G.subs({u: a ** 2, v: b ** 2}) - alternative) == 0,
            "The square-root-free substituted identity is false.")
    require(sp.cancel(d * (w - A / d) ** 2 - (d * w ** 2 - 2 * A * w + A ** 2 / d)) == 0,
            "Weighted Young completion is incorrect.")
    beta = (40 - 37 * sigma) / (3 * sigma)
    gamma = (40 - 37 * tau) / (3 * tau)
    K = sp.Rational(40, 3) / (sigma * tau) - beta / (tau + h) - gamma / (sigma + h)
    factor = sp.Rational(64000, 4107) / (sigma * tau * (sigma + h) * (tau + h))
    require(sp.cancel(K - factor * G.subs({u: 37 * sigma / 40, v: 37 * tau / 40})) == 0,
            "The rational pair-coefficient reduction is incorrect.")
    p_pair = (sigma - tau) * (gamma - beta)
    require(sp.cancel(p_pair - sp.Rational(40, 3) * (sigma - tau) ** 2 / (sigma * tau)) == 0,
            "The symmetrized P coefficient is incorrect.")
    require(sp.expand(2 * z ** 2 - z + sp.Rational(1, 8) - 2 * (z - sp.Rational(1, 4)) ** 2) == 0,
            "The supplementary Jacobian polynomial is incorrect.")
    x, y = sp.symbols("x y")
    sx, sy = 40 / (37 + 3 * x ** 2), 40 / (37 + 3 * y ** 2)
    X = sp.diag(x, y)
    skew = sp.Matrix([[0, 1], [-1, 0]])
    symmetric = sp.Matrix([[0, 1 / (y - x)], [1 / (y - x), 0]])
    S = sp.diag(sx, sy)
    T = S - sp.eye(2)
    B = X * X
    P = sp.trace(T * symmetric * B * symmetric - T * B * symmetric * symmetric)
    ratio = (-P - 2 * sp.trace((S * symmetric - symmetric * S) * X * skew) -
             sp.trace(T * skew.T * skew)) / 2
    rational_ratio = 1 + 40 * (3 * x * y - 37) / ((37 + 3 * x ** 2) * (37 + 3 * y ** 2))
    require(sp.cancel(ratio - rational_ratio) == 0, "The sharpness family's exact trace ratio is wrong.")
    gap = 5 * (9 * (x * y - 37) ** 2 + 111 * (x - y) ** 2)
    gap /= 37 * (37 + 3 * x ** 2) * (37 + 3 * y ** 2)
    require(sp.cancel(constant - rational_ratio - gap) == 0, "The sharpness gap identity is wrong.")
    require(sp.simplify(rational_ratio.subs({x: sp.sqrt(37), y: sp.sqrt(37)}) - constant) == 0,
            "The continuously extended sharpness ratio has the wrong limiting value.")
    return alpha, s, h, constant


def check_compiler_record(certificate):
    formal = certificate["formal_certificate"]
    source = ROOT / formal["source"]
    fidelity = ROOT / formal["statement_fidelity"]
    record = json.loads((ROOT / formal["compiler_record"]).read_text())
    archive = json.loads((ROOT / formal["archive"]).read_text())
    require(record["exit_code"] == 0 and record["proof_holes"] == [], "Lean did not certify the source.")
    require(record["audit_exit_code"] == 0, "The real Lean axiom audit did not pass.")
    require("version 4.31.0," in record["tools"]["lean"]["version"], "Wrong Lean version.")
    require(record["source_sha256"] == hashlib.sha256(source.read_bytes()).hexdigest(),
            "The Lean source changed after compilation.")
    require(record["statement_fidelity_sha256"] ==
            hashlib.sha256(fidelity.read_text().encode()).hexdigest(),
            "Statement fidelity changed after compilation.")
    require(archive["lean_check"] == record, "The archived compiler record is not current.")
    require(archive["lean_source"]["text"] == source.read_text(), "The archive carries different Lean text.")
    require(archive["statement_fidelity"]["text"] == fidelity.read_text(), "The archive carries different fidelity text.")
    require(formal["declaration"] in source.read_text(), "The named full matrix declaration is missing.")
    return {"version": "4.31.0", "exit_code": 0, "proof_holes": [], "record_current": True}


def check_case(X, b, w, constant, h):
    dimension = b.rows
    require(b == b.T and all(x == x.T and x.shape == b.shape for x in X),
            "A falsification probe violates the symmetry or size hypotheses.")
    require(len(X) == len(w) and all(a.shape == b.shape for a in w),
            "A falsification probe has incompatible residual matrices.")
    zero = sp.zeros(dimension)
    B = sum((x * x for x in X), zero)
    S = 40 * (37 * sp.eye(dimension) + 3 * B).inv()
    T = S - sp.eye(dimension)
    C = S * b - b * S
    F = sum((x * a for x, a in zip(X, w)), zero)
    energy = sum((a.T * a for a in w), zero)
    P = sp.trace(T * b * B * b - T * B * b * b)
    lhs = -P - 2 * sp.trace(C * F) - sp.trace(T * energy)
    norm = sp.trace(energy)
    slack = constant * norm - lhs
    require(slack >= 0, f"Exact violation found in dimension {dimension}: slack={slack}.")
    D = S + h * sp.eye(dimension)
    Di = D.inv()
    E = [a - x * C * Di for x, a in zip(X, w)]
    completed = sum((sp.trace(e.T * e * D) for e in E), sp.S.Zero)
    completed += P - sp.trace(C.T * B * C * Di)
    require(slack == completed, "The finite matrix replay detects a square-completion orientation error.")
    return norm, lhs, C != zero


def exact_probes(certificate, constant, h, alpha):
    specification = certificate["falsification_probes"]
    rng = random.Random(specification["seed"])
    noncommuting = 0
    count = 0
    for dimension in specification["dimensions"]:
        for _ in range(specification["cases_per_dimension"]):
            def matrix():
                return sp.Matrix(dimension, dimension,
                                 lambda i, j: sp.Rational(rng.randrange(-3, 4), rng.randrange(1, 4)))

            X = []
            for _ in range(dimension):
                raw = matrix()
                X.append(raw + raw.T)
            raw = matrix()
            b = raw + raw.T
            w = [matrix() for _ in range(dimension)]
            _, _, is_noncommuting = check_case(X, b, w, constant, h)
            noncommuting += int(is_noncommuting)
            count += 1

    near = certificate["near_saturation_case"]
    x, y = sp.Rational(near["x"]), sp.Rational(near["y"])
    sigma, tau = 40 / (37 + 3 * x ** 2), 40 / (37 + 3 * y ** 2)
    off_diagonal = alpha * sigma * tau * (x + y) / (sigma - tau)
    require(off_diagonal == sp.Rational(near["b_off_diagonal"]),
            "The near-saturation matrix b does not match the exact certificate.")
    b = sp.Matrix([[0, off_diagonal], [off_diagonal, 0]])
    X = [sp.diag(x, y), sp.zeros(2)]
    w = [sp.Matrix([[0, 1], [-1, 0]]), sp.zeros(2)]
    norm, lhs, is_noncommuting = check_case(X, b, w, constant, h)
    ratio = lhs / norm
    require(ratio == sp.Rational(near["ratio"]), "The near-saturation ratio changed.")
    require(is_noncommuting and sp.Rational(113513, 100000) < ratio < constant,
            "The exact near-saturation probe does not exercise the stated range.")
    return {"count": count, "dimensions": specification["dimensions"],
            "noncommuting_b_S_cases": noncommuting, "violations": 0,
            "near_saturation_ratio": str(ratio), "near_saturation_lower_bound": "113513/100000"}


def main():
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    require(certificate["claim_id"] == "C9000101_NC", "Wrong claim certificate.")
    alpha, s, h, constant = check_scalar_algebra(certificate)
    trace_identities = check_trace_algebra(alpha, s)
    compiler = check_compiler_record(certificate)
    jacobian = json.loads((ROOT / certificate["jacobian"]["typed_result"]).read_text())
    payload = json.loads((ROOT / certificate["jacobian"]["payload"]).read_text())
    adapter = certificate["jacobian"]
    require(adapter["adapter_exit_code"] == 0 and adapter["adapter_error"] is None and
            adapter["timeout"] is False, "The Jacobian adapter did not complete successfully.")
    require(jacobian["server"]["version"] == adapter["server_version"] and
            jacobian["protocol_version"] == adapter["protocol_version"] and
            jacobian["transport"] == adapter["transport"],
            "The Jacobian provenance metadata does not match the retained typed output.")
    require(jacobian["request"]["payload"] == payload, "Jacobian output is bound to another payload.")
    require(jacobian["result"]["operation_id"] == "polynomial.sos.gram.check" and
            jacobian["result"]["output"]["is_valid"] is True,
            "Jacobian did not validate the supplied supplementary Gram certificate.")
    probes = exact_probes(certificate, constant, h, alpha)
    print(json.dumps({
        "claim_id": certificate["claim_id"],
        "result": "universal_algebraic_certificate_verified",
        "trace_identities": trace_identities,
        "scalar_identities": "exact polynomial and rational identities verified",
        "sharpness": "exact family identities verified; limiting argument is in report.md",
        "full_matrix_lean": compiler,
        "falsification_probes": probes,
        "independent_review": certificate["scope"]["independent_review"],
        "entropy_theorem": "not_established",
    }, indent=2))


if __name__ == "__main__":
    main()
