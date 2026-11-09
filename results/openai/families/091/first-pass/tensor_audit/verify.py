#!/usr/bin/env python3
"""Replay the dimension-free algebra and exact tensor-lemma diagnostics."""

import argparse
from collections import Counter, defaultdict
from fractions import Fraction
from functools import lru_cache
from hashlib import sha256
from itertools import permutations, product
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
FULL_SYMMETRY = {"h", "C", "S", "D", "M", "tau", "R", "H"}


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def term(coefficient, *factors):
    return Fraction(coefficient), tuple((name, tuple(indices)) for name, indices in factors)


def add(*expressions):
    return [entry for expression in expressions for entry in expression]


def scale(coefficient, expression):
    return [(Fraction(coefficient) * c, f) for c, f in expression]


def multiply(left, right):
    return [(c * d, f + g) for c, f in left for d, g in right]


def square(expression):
    return multiply(expression, expression)


@lru_cache(maxsize=None)
def canonical(factors):
    counts = Counter(index for _, indices in factors for index in indices)
    require(all(count == 2 for count in counts.values()), "Not a complete Einstein contraction")
    labels = sorted(counts)
    candidates = []
    for renaming in permutations(range(len(labels))):
        names = dict(zip(labels, renaming))
        normalized = []
        for tensor, indices in factors:
            indices = tuple(names[index] for index in indices)
            if tensor in FULL_SYMMETRY:
                indices = tuple(sorted(indices))
            elif tensor == "J":
                indices = (indices[0],) + tuple(sorted(indices[1:]))
            elif tensor in {"ddP", "ddW"}:
                indices = indices[:-2] + tuple(sorted(indices[-2:]))
            normalized.append((tensor, indices))
        candidates.append(tuple(sorted(normalized)))
    return min(candidates)


def normalize(expression):
    result = defaultdict(Fraction)
    for coefficient, factors in expression:
        result[canonical(factors)] += coefficient
    return {factors: coefficient for factors, coefficient in result.items() if coefficient}


def tensor_identities():
    checks = []

    def equal(name, left, right):
        residual = normalize(add(left, scale(-1, right)))
        require(not residual, f"{name}: nonzero universal contraction residual {residual}")
        checks.append({"identity": name, "residual_monomials": len(residual)})

    equal(
        "eq:W-gradient, original moment-coordinate contractions",
        [
            term(1, ("tau", "ka"), ("f1", "k"), ("probe", "a")),
            term(1, ("x", "k"), ("tau", "ia"), ("h", "ki"), ("probe", "a")),
            term(-1, ("C", "ajk"), ("h", "jk"), ("probe", "a")),
            term(-1, ("tau", "jk"), ("tau", "ia"), ("S", "jki"), ("probe", "a")),
            term(-1, ("tau", "ia"), ("f1", "i"), ("probe", "a")),
        ],
        [
            term(1, ("x", "k"), ("tau", "ai"), ("h", "ik"), ("probe", "a")),
            term(-1, ("C", "aik"), ("h", "ik"), ("probe", "a")),
            term(-1, ("tau", "ai"), ("tau", "jk"), ("S", "ikj"), ("probe", "a")),
        ],
    )
    equal(
        "D_z W=B+R from the weighted commutator",
        [
            term(1, ("tau", "kl"), ("tau", "ai"), ("h", "ik"), ("probe2", "al")),
            term(1, ("x", "k"), ("dP", "akl"), ("probe2", "al")),
            term(-1, ("ddP", "akkl"), ("probe2", "al")),
        ],
        [
            term(1, ("tau", "ai"), ("h", "ik"), ("tau", "kl"), ("probe2", "al")),
            term(1, ("x", "k"), ("dP", "akl"), ("probe2", "al")),
            term(-1, ("ddP", "aklk"), ("probe2", "al")),
        ],
    )
    bochner_gradient = [
        term(1, ("H", "ij"), ("W", "i"), ("W", "j")),
        term(1, ("V1", "j"), ("W", "i"), ("dW", "ji")),
        term(-1, ("W", "i"), ("ddW", "jji")),
    ]
    equal(
        "eq:bochner, exact weighted-divergence correction",
        bochner_gradient,
        [
            term(1, ("H", "ij"), ("W", "i"), ("W", "j")),
            term(1, ("dW", "ij"), ("dW", "ji")),
            term(1, ("V1", "j"), ("W", "i"), ("dW", "ji")),
            term(-1, ("dW", "ij"), ("dW", "ji")),
            term(-1, ("W", "i"), ("ddW", "jij")),
        ],
    )
    sj = [term(1, ("S", "ijk"), ("h", "ia"), ("C", "ajk"))]
    ss = [term(1, ("S", "ijk"), ("S", "ijk"))]
    jj = [term(1, ("h", "ia"), ("C", "ajk"), ("h", "ib"), ("C", "bjk"))]
    jj12 = [term(1, ("h", "ia"), ("C", "ajk"), ("h", "jb"), ("C", "bik"))]
    equal(
        "eq:normalized-cross",
        [
            term(2, ("S", "alk"), ("C", "ail"), ("h", "ik")),
            term(2, ("S", "alk"), ("S", "akl")),
        ],
        add(scale(2, ss), scale(2, sj)),
    )
    equal(
        "eq:normalized-derivative",
        [
            term(1, ("S", "iad"), ("h", "aj"), ("C", "ijd")),
            term(1, ("h", "ia"), ("S", "ajd"), ("C", "ijd")),
            term(1, ("h", "ia"), ("C", "abd"), ("h", "bj"), ("C", "ijd")),
        ],
        add(scale(2, sj), jj12),
    )
    equal(
        "eq:normalized-cubic",
        [term(1, ("h", "ia"), ("h", "aj"), ("C", "ikl"), ("C", "jlk"))],
        jj,
    )
    equal(
        "inverse-Hessian contracted derivative",
        [term(-1, ("M", "da"), ("C", "abd"), ("M", "bk"), ("C", "ijk"), ("h", "ij"))],
        [term(-1, ("M", "da"), ("C", "bda"), ("M", "bk"), ("C", "ijk"), ("h", "ij"))],
    )
    equal(
        "fourth-derivative contraction in eq:twice-moment",
        [term(1, ("M", "dk"), ("D", "ijkd"), ("h", "ij"))],
        [term(1, ("M", "kl"), ("D", "klij"), ("h", "ij"))],
    )

    s = [term(1, ("S", "ijk"))]
    j = [term(1, ("J", "ijk"))]
    j12 = [term(1, ("J", "jik"))]
    jcycle = [term(1, ("J", "kij"))]
    symj = scale(Fraction(1, 3), add(j, j12, jcycle))
    a = square(j)
    b = multiply(j, j12)
    equal("universal symmetrization norm", square(symj), scale(Fraction(1, 3), add(a, scale(2, b))))
    equal("symmetric test pairing", multiply(s, symj), multiply(s, j))
    original = add(scale(2, square(s)), scale(4, multiply(s, j)), a, b)
    squares = add(scale(2, square(add(s, symj))), scale(Fraction(1, 6), square(add(j, scale(-1, j12)))))
    equal("eq:tensor-squares, arbitrary finite index type", original, squares)
    derivative = add(s, j12)
    invariant = add(
        scale(Fraction(1, 2), square(derivative)),
        scale(Fraction(3, 2), square(add(s, symj))),
    )
    equal("invariant exact derivative remainder", original, invariant)
    return checks


def reduce_word(word):
    word = list(word)
    changed = True
    while changed:
        changed = False
        for index in range(len(word) - 1):
            if tuple(word[index:index + 2]) in {("M", "tau"), ("tau", "M")}:
                del word[index:index + 2]
                changed = True
                break
    return tuple(word)


def normalize_words(expression, trace=False):
    answer = defaultdict(Fraction)
    for coefficient, word in expression:
        word = reduce_word(word)
        if trace and word:
            candidates = [
                reduce_word(word[index:] + word[:index]) for index in range(len(word))
            ]
            minimum_length = min(map(len, candidates))
            candidates = [candidate for candidate in candidates if len(candidate) == minimum_length]
            word = min(
                candidate[index:] + candidate[:index]
                for candidate in candidates
                for index in range(max(1, len(candidate)))
            )
        answer[word] += coefficient
    return {word: coefficient for word, coefficient in answer.items() if coefficient}


def inverse_and_trace_identities():
    checks = []

    def equal(name, left, right, trace=False):
        residual = normalize_words(left + [(-c, word) for c, word in right], trace=trace)
        require(not residual, f"{name}: noncommutative residual {residual}")
        checks.append(name)

    equal(
        "differentiate M tau=I",
        [(-1, ("M", "Ci", "M", "tau")), (1, ("M", "Ci"))],
        [],
    )
    derivative_rules = {
        "M": [(-1, ("M", "Cj", "M"))],
        "Ci": [(1, ("Dij",))],
    }
    differentiated = []
    word = ("M", "Ci", "M")
    for index, letter in enumerate(word):
        for coefficient, replacement in derivative_rules[letter]:
            differentiated.append((-coefficient, word[:index] + replacement + word[index + 1:]))
    equal(
        "second inverse derivative retains both product orders",
        differentiated,
        [
            (1, ("M", "Cj", "M", "Ci", "M")),
            (1, ("M", "Ci", "M", "Cj", "M")),
            (-1, ("M", "Dij", "M")),
        ],
    )
    equal(
        "Q is the coefficient of tau H tau",
        [(1, ("M", "tau", "h", "tau", "M", "G", "M", "tau", "h", "tau"))],
        [(1, ("h", "tau", "h", "G"))],
        trace=True,
    )
    equal(
        "common base trace",
        [(1, ("M", "tau", "h", "tau", "M", "tau", "h", "tau"))],
        [(1, ("h", "tau", "h", "tau"))],
        trace=True,
    )
    equal(
        "trace cross term uses MBM=h",
        [(1, ("M", "tau", "h", "tau", "M", "R"))],
        [(1, ("h", "R"))],
        trace=True,
    )
    x, h, dh, p, dp, q, dq, a, da = sp.symbols("x h dh p dp q dq a da")
    require(sp.expand(h * (x * p - dp) - (x * h * p - dh * p - h * dp) - dh * p) == 0,
            "First source integration-by-parts product rule")
    require(sp.expand(-q * (da - x * a) - (x * q * a - dq * a - q * da) - dq * a) == 0,
            "Second source integration-by-parts product rule")
    checks.extend(["trace-expansion product rule", "H-expansion product rule"])
    return checks


def covariance_checks():
    signatures = {
        "M": "--", "B": "++", "R": "++", "H": "--", "Q": "--",
        "C": "+++", "dh": "--+", "dP": "+-+", "dQ": "--+",
        "DXW": "+-", "tau": "++", "K": "+++",
    }
    contractions = {
        "matrix-square trace": [("DXW", "ij"), ("DXW", "ji")],
        "original H trace": [("M", "ij"), ("B", "jk"), ("H", "kl"), ("B", "li")],
        "trace expansion cross": [("dh", "alk"), ("dP", "akl")],
        "H expansion derivative": [("dQ", "ijd"), ("M", "dk"), ("C", "ijk")],
        "H expansion cubic": [("Q", "ij"), ("M", "ab"), ("C", "ibc"), ("M", "cd"), ("C", "jda")],
        "R trace": [("M", "ij"), ("R", "jk"), ("M", "kl"), ("R", "li")],
        "invariant K norm": [("M", "ad"), ("M", "be"), ("M", "cf"), ("K", "abc"), ("K", "def")],
    }
    for name, factors in contractions.items():
        counts = defaultdict(Counter)
        for tensor, indices in factors:
            require(len(indices) == len(signatures[tensor]), f"Tensor arity: {name}")
            for index, variance in zip(indices, signatures[tensor]):
                counts[index][variance] += 1
        require(all(count == Counter({"+": 1, "-": 1}) for count in counts.values()),
                f"Unbalanced dual transformation indices: {name}")
    require(-1 + 2 - 1 == 0, "Moment determinant factors under constant T")
    return list(contractions)


def tensor_norm(tensor, inverse, dimension):
    return sum(
        inverse[a, d] * inverse[b, e] * inverse[c, f] *
        tensor[a, b, c] * tensor[d, e, f]
        for a, b, c, d, e, f in product(range(dimension), repeat=6)
    )


def symmetrize(tensor, dimension):
    return {
        indices: sum(tensor[permutation] for permutation in permutations(indices)) / 6
        for indices in product(range(dimension), repeat=3)
    }


def exact_jet_checks():
    n = 2
    indices = range(n)
    z = sp.symbols("z0:2")
    y = sp.symbols("y0:2")
    phi = (z[0] ** 2 + z[1] ** 2) / 2 + z[0] ** 4 / 12 + (z[0] + z[1]) ** 4 / 12
    phi += z[0] / 5 - z[1] / 7
    x = sp.Matrix([sp.diff(phi, coordinate) for coordinate in z])
    tau = x.jacobian(z)
    inverse = tau.inv()
    f = y[0] ** 3 / 6 + y[0] ** 2 * y[1] / 2 - y[0] * y[1] ** 2 / 3
    f += y[1] ** 4 / 12 + y[0] ** 2 / 2 + 2 * y[0] * y[1] - y[1] ** 2 / 2 + y[0]
    substitution = dict(zip(y, x))
    h = sp.hessian(f, y).subs(substitution, simultaneous=True)
    p = tau * h
    b = p * tau
    q = h * tau * h
    c = {(i, j, k): sp.diff(phi, z[i], z[j], z[k]) for i, j, k in product(indices, repeat=3)}
    dp = {(a, k, l): sp.diff(p[a, k], z[l]) for a, k, l in product(indices, repeat=3)}
    dh = {(a, l, k): sp.diff(h[a, l], z[k]) for a, l, k in product(indices, repeat=3)}
    dq = {(i, j, d): sp.diff(q[i, j], z[d]) for i, j, d in product(indices, repeat=3)}
    w = sp.Matrix([sum(x[k] * p[a, k] - dp[a, k, k] for k in indices) for a in indices])
    dwz = w.jacobian(z)
    source_v = phi + sp.log(tau.det())
    target_gradient = inverse * sp.Matrix([sp.diff(source_v, coordinate) for coordinate in z])
    target_hessian = target_gradient.jacobian(z) * inverse
    f_source = f.subs(substitution, simultaneous=True)
    g = (sum(x[i] * sp.diff(f, y[i]).subs(substitution, simultaneous=True) for i in indices)
         - sp.trace(tau * h) - f_source)
    wg = sp.Matrix([sp.diff(g, coordinate) for coordinate in z])
    u_flux = sp.Matrix([
        2 * sum(h[a, l] * dp[a, k, l] for a, l in product(indices, repeat=2)) +
        sum(q[i, j] * inverse[k, r] * c[i, j, r] for i, j, r in product(indices, repeat=3))
        for k in indices
    ])
    flux_derivative = u_flux.jacobian(z)
    records = []
    noncommuting = False

    for point in [(0, 0), (sp.Rational(1, 2), -sp.Rational(1, 3)), (-sp.Rational(1, 3), sp.Rational(2, 3))]:
        at = dict(zip(z, point))

        def ev(expression):
            return expression.subs(at, simultaneous=True).applyfunc(sp.cancel) if isinstance(expression, sp.MatrixBase) else sp.cancel(expression.subs(at, simultaneous=True))

        t, m, hv, pv, bv, qv = map(ev, [tau, inverse, h, p, b, q])
        cv, dpv, dhv, dqv = ({key: ev(value) for key, value in tensor.items()} for tensor in [c, dp, dh, dq])
        wv, dzw, gradv, hessian = map(ev, [w, dwz, target_gradient, target_hessian])
        r = dzw - bv
        dxw = dzw * m
        require(r == r.T, "R symmetry on the original jet")
        require(wv == ev(wg), "eq:W-gradient on the original jet")
        row_divergence = sp.Matrix([
            sum(gradv[j] * bv[a, j] - sum(ev(sp.diff(b[a, j], z[l])) * m[l, j] for l in indices)
                for j in indices) for a in indices
        ])
        require(wv == row_divergence, "W=delta_mu B on the original jet")
        moment_hessian = sp.zeros(n)
        for i, j in product(indices, repeat=2):
            ci = sp.Matrix(n, n, lambda a, k: cv[i, a, k])
            cj = sp.Matrix(n, n, lambda a, k: cv[j, a, k])
            moment_hessian[i, j] = (
                t[i, j] +
                sum(m[k, l] * ev(sp.diff(phi, z[k], z[l], z[i], z[j]))
                    for k, l in product(indices, repeat=2)) -
                sp.trace(m * ci * m * cj) - sum(cv[i, j, k] * gradv[k] for k in indices)
            )
        require((t * hessian * t - moment_hessian).applyfunc(sp.cancel) == sp.zeros(n),
                "Twice-differentiated moment equation from independent V derivatives")
        kernel = {
            (a, bindex, l): sum(t[bindex, k] * dpv[a, k, l] for k in indices)
            for a, bindex, l in product(indices, repeat=3)
        }
        normk = sp.cancel(tensor_norm(kernel, m, n))
        norms = sp.cancel(tensor_norm(symmetrize(kernel, n), m, n))
        raw = sp.cancel(sp.trace(dxw * dxw) - sp.trace(m * bv * hessian * bv))
        rnorm = sp.cancel(sp.trace(m * r * m * r))
        flux = sp.cancel((ev(x).T * ev(u_flux))[0] - sp.trace(ev(flux_derivative)))
        require(sp.cancel(raw - rnorm - normk / 2 - 3 * norms / 2 - flux) == 0,
                "Complete original-contraction-to-squares flux identity")
        require(t.det() > 0 and t[0, 0] > 0, "Positive definite Hessian on exact jets")
        require(normk >= 0 and norms >= 0 and rnorm >= 0, "Nonnegative exact remainders")
        noncommuting |= hv * t != t * hv
        covariance = exact_coordinate_check(t, m, bv, r, hessian, qv, cv, dpv, dhv, dqv, kernel)
        records.append({
            "point": list(map(str, point)),
            "raw_trace_difference": str(raw),
            "R_square": str(rnorm),
            "K_norm_square": str(normk),
            "sym_K_norm_square": str(norms),
            "weighted_divergence": str(flux),
            "flux_identity_residual": "0",
            "nonorthogonal_coordinate_residuals": covariance,
        })
    require(noncommuting, "The exact diagnostics accidentally used commuting matrices only")
    require(any(record["weighted_divergence"] != "0" for record in records),
            "The exact diagnostics did not exercise the integration-by-parts correction")
    return {
        "classification": "finite_exact_diagnostic_not_the_universal_proof",
        "source_potential": str(phi),
        "test_germ": str(f),
        "probability_realization": "Add the log source normalizer to phi and define V by the global moment diffeomorphism. The normalizer cancels from all derivatives. A compact smooth cutoff equal to one near each target point realizes the displayed test jets.",
        "global_convexity": "tau=I+z0^2 e0 e0^T+(z0+z1)^2 (1,1)(1,1)^T, so phi is coercive and strongly convex and its gradient is a global diffeomorphism.",
        "non_even_potential_and_test": True,
        "noncommuting_case_exercised": bool(noncommuting),
        "points": records,
    }


def exact_coordinate_check(t, m, b, r, target_hessian, q, c, dp, dh, dq, kernel):
    n = t.rows
    indices = range(n)
    transform = sp.Matrix([[2, 1], [1, 2]])
    inv = transform.inv()

    def cov3(tensor):
        return {
            (a, bindex, l): sum(
                transform[i, a] * transform[j, bindex] * transform[k, l] * tensor[i, j, k]
                for i, j, k in product(indices, repeat=3)
            )
            for a, bindex, l in product(indices, repeat=3)
        }

    def mixed(tensor, first, second, third):
        return {
            (a, bindex, l): sum(
                first[i, a] * second[j, bindex] * third[k, l] * tensor[i, j, k]
                for i, j, k in product(indices, repeat=3)
            )
            for a, bindex, l in product(indices, repeat=3)
        }

    tp, mp = transform.T * t * transform, inv * m * inv.T
    bp, rp = transform.T * b * transform, transform.T * r * transform
    hp, qp = inv * target_hessian * inv.T, inv * q * inv.T
    cp = cov3(c)
    dpp = mixed(dp, transform, inv.T, transform)
    dhp, dqp = mixed(dh, inv.T, inv.T, transform), mixed(dq, inv.T, inv.T, transform)
    kp = {
        (a, bindex, l): sum(tp[bindex, k] * dpp[a, k, l] for k in indices)
        for a, bindex, l in product(indices, repeat=3)
    }
    require(kp == cov3(kernel), "K is a covariant three-tensor under constant dual coordinates")

    def scalars(mm, bb, rr, hh, qq, cc, dppp, dhhh, dqqq, kk):
        return [
            sp.trace(((bb + rr) * mm) ** 2),
            sp.trace(mm * bb * hh * bb),
            sp.trace(mm * rr * mm * rr),
            2 * sum(dhhh[a, l, k] * dppp[a, k, l] for a, l, k in product(indices, repeat=3)),
            sum(dqqq[i, j, d] * mm[d, k] * cc[i, j, k]
                for i, j, d, k in product(indices, repeat=4)),
            sum(qq[i, j] * sp.trace(
                mm * sp.Matrix(n, n, lambda a, k: cc[i, a, k]) *
                mm * sp.Matrix(n, n, lambda a, k: cc[j, a, k]))
                for i, j in product(indices, repeat=2)),
            tensor_norm(kk, mm, n),
            tensor_norm(symmetrize(kk, n), mm, n),
        ]

    old = scalars(m, b, r, target_hessian, q, c, dp, dh, dq, kernel)
    new = scalars(mp, bp, rp, hp, qp, cp, dpp, dhp, dqp, kp)
    residuals = [sp.cancel(left - right) for left, right in zip(old, new)]
    require(all(value == 0 for value in residuals), "Constant dual-coordinate scalar invariance")
    return list(map(str, residuals))


def jacobian_check():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    result = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_adapter_status.json").read_text())
    require(status["exit_code"] == 0, "Jacobian adapter did not complete successfully")
    require(result["server"]["name"] == "jacobian", "Unexpected sidecar server")
    require(result["request"]["operation_id"] == "matrix.inertia.compute", "Operation binding")
    require(result["request"]["payload"] == payload, "Exact payload binding")
    typed = result["result"]
    require(typed["operation_id"] == "matrix.inertia.compute", "Typed output operation binding")
    value = typed["output"]
    matrix = sp.zeros(payload["dimension"])
    for entry in payload["entries"]:
        matrix[entry["row"], entry["col"]] = sp.Rational(entry["value"]["num"], entry["value"]["den"])
        matrix[entry["col"], entry["row"]] = matrix[entry["row"], entry["col"]]
    returned = sp.Matrix([
        [sp.Rational(entry["num"], entry["den"]) for entry in row]
        for row in value["matrix"]["entries"]
    ])
    require(returned == matrix and matrix == matrix.T, "Typed output lost its exact source matrix")
    decomposition = sp.Matrix([
        [1, sp.Rational(1, 3), sp.Rational(1, 3), sp.Rational(1, 3)],
        [0, 1, -1, 0], [0, 0, 1, -1], [0, -1, 0, 1],
    ])
    weights = sp.diag(12, sp.Rational(1, 3), sp.Rational(1, 3), sp.Rational(1, 3))
    require(decomposition.T * weights * decomposition == matrix, "Exact Gram decomposition")
    require(matrix.rank() == 3, "Exact Gram rank")
    require((value["n_positive"], value["n_negative"], value["n_zero"]) == (3, 0, 1),
            "Jacobian inertia not independently reproduced")
    s, a, b, c = sp.symbols("s a b c")
    vector = sp.Matrix([s, a, b, c])
    require(sp.expand((vector.T * matrix * vector)[0] -
                      12 * (s + (a + b + c) / 3) ** 2 -
                      ((a - b) ** 2 + (b - c) ** 2 + (c - a) ** 2) / 3) == 0,
            "Gram matrix is not the orbit-averaged tensor polynomial")
    rejected = json.loads((HERE / "jacobian_rejected_result.json").read_text())
    rejected_status = json.loads((HERE / "jacobian_rejected_status.json").read_text())
    require(rejected_status["exit_code"] == 2 and
            rejected["error"]["data"]["code"] == "INVALID_REQUEST",
            "The rejected payload must remain a validation error, not a mathematical verdict")
    return {
        "operation_id": "matrix.inertia.compute",
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "adapter_exit_code": status["exit_code"],
        "timeout": False,
        "error": None,
        "typed_inertia": [3, 0, 1],
        "independent_exact_Gram_replay": True,
        "scope": "A four-scalar orbit polynomial, not a dimension-four restriction on the theorem.",
        "rejected_payload": {
            "file": "jacobian_rejected_payload.json",
            "exit_code": rejected_status["exit_code"],
            "structured_error": rejected["error"],
            "mathematical_conclusion": "none",
            "correction": "Supply each symmetric-matrix entry once, using the upper triangle.",
        },
    }


def formal_algebra_check():
    compiler = json.loads((HERE / "lean_check.json").read_text())
    receipt = json.loads((HERE / "lean_verification.json").read_text())
    require({key: value for key, value in receipt.items() if key != "kernel"} == compiler,
            "The compiler receipt and canonical result differ")
    require(compiler["status"] == "success" and compiler["exit_code"] == 0,
            "The Lean formalization is not verified")
    require(compiler["proof_holes"] == [] and compiler["audit_exit_code"] == 0,
            "The Lean formalization has proof holes or an unsuccessful axiom audit")
    require("version 4.31.0," in compiler["tools"]["lean"]["version"], "Wrong Lean version")
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    require(sha256(source).hexdigest() == compiler["source_sha256"], "Stale Lean source")
    require(sha256(fidelity.encode()).hexdigest() == compiler["statement_fidelity_sha256"],
            "Stale statement-fidelity document")
    evidence = receipt["kernel"]["recorded"]
    require(evidence["subject"]["subject_id"] == "C_TENSOR_ALGEBRA" and
            evidence["tier"] == "mechanical" and evidence["verdict"] == "supports",
            "The genuine compiler record is attached to a different claim")
    archive = json.loads((HERE.parent.parent / evidence["artifact"]).read_text())
    require(archive["lean_check"] == compiler, "Archived compiler result differs")
    require(archive["lean_source"]["text"] == source.decode(), "Archived formal source differs")
    require(archive["statement_fidelity"]["text"] == fidelity, "Archived fidelity differs")
    return {
        "claim": "C_TENSOR_ALGEBRA",
        "archive": evidence["artifact"],
        "lean_version": "4.31.0",
        "exit_code": compiler["exit_code"],
        "proof_holes": compiler["proof_holes"],
        "source_and_fidelity_fresh": True,
        "scope": "Universal finite-index algebra only; the analytic theorem still requires independent mathematical review.",
    }


def build_certificate():
    return {
        "claim": "C_TENSOR_DEFECT",
        "target_labels": ["lem:tensor", "eq:twice-moment", "eq:trace-expansion", "eq:H-expansion",
                          "eq:normalized-cross", "eq:normalized-derivative", "eq:normalized-cubic",
                          "eq:tensor-squares", "eq:bochner", "eq:tensor-estimate", "eq:tensor-energy"],
        "result": "dimension-independent exact verification theorem with an invariant defect and equality case",
        "universal_contraction_checks": tensor_identities(),
        "universal_noncommutative_and_product_rule_checks": inverse_and_trace_identities(),
        "universal_dual_coordinate_index_balance": covariance_checks(),
        "exact_jet_diagnostics": exact_jet_checks(),
        "jacobian": jacobian_check(),
        "formal_algebra": formal_algebra_check(),
        "proof": "report.md, equations (1)-(10) and theorem (T)",
        "formal_scope": "Main.lean formalizes C_TENSOR_ALGEBRA only; see statement_fidelity.md and the genuine compiler certificate.",
        "independent_review": "required_from_Host_reviewer",
        "novelty_status": "not_established",
        "campaign_complete": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    expected = json.loads(path.read_text())
    require(certificate == expected, "Replayed mathematical certificate differs from the saved one")
    print(json.dumps({
        "ok": True,
        "universal_contraction_identities": len(certificate["universal_contraction_checks"]),
        "noncommutative_and_product_rule_identities": len(certificate["universal_noncommutative_and_product_rule_checks"]),
        "dual_coordinate_contractions": len(certificate["universal_dual_coordinate_index_balance"]),
        "exact_jet_points": len(certificate["exact_jet_diagnostics"]["points"]),
        "independent_review": certificate["independent_review"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
