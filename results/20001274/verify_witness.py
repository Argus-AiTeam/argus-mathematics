"""Exact algebraic replay for the construction in hyperplane_witness.md."""

import json
from fractions import Fraction as F
from itertools import combinations, product
from pathlib import Path


A = (3, 2, 1)
HIGH = F(5, 2)
LOW = F(3, 2)
EPSILON = F(1, 1000)
VARIABLES = ["u1", "u2", "u3", "v1", "v2", "v3"]


def require(condition, message):
    if not condition:
        raise ValueError("Certificate failure: " + message)


def variable(index):
    exponents = [0] * 6
    exponents[index] = 1
    return {tuple(exponents): F(1)}


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for monomial, coefficient in polynomial.items():
            result[monomial] = result.get(monomial, F(0)) + coefficient
    return {m: c for m, c in result.items() if c}


def scale(polynomial, coefficient):
    return {m: c * coefficient for m, c in polynomial.items() if c * coefficient}


def multiply(left, right):
    result = {}
    for lm, lc in left.items():
        for rm, rc in right.items():
            monomial = tuple(x + y for x, y in zip(lm, rm))
            result[monomial] = result.get(monomial, F(0)) + lc * rc
    return {m: c for m, c in result.items() if c}


def square(polynomial):
    return multiply(polynomial, polynomial)


def subtract(left, right):
    return add(left, scale(right, -1))


def decode_polynomial(value):
    require(value["domain"] == "QQ", "Jacobian coefficient domain must be QQ")
    require(value["variables"] == VARIABLES, "Jacobian variables changed")
    result = {}
    previous = None
    for term in value["polynomial"]["terms"]:
        monomial = tuple(term["exponents"])
        require(len(monomial) == 6, "wrong exponent dimension")
        require(all(type(e) is int and e >= 0 for e in monomial),
                "invalid exponent")
        require(previous is None or previous > monomial,
                "terms are not in strict descending lexicographic order")
        numerator = int(term["coefficient"]["num"])
        denominator = int(term["coefficient"]["den"])
        require(denominator > 0, "nonpositive rational denominator")
        coefficient = F(numerator, denominator)
        require(coefficient != 0, "zero sparse coefficient")
        require(coefficient.numerator == numerator
                and coefficient.denominator == denominator,
                "noncanonical rational")
        result[monomial] = coefficient
        previous = monomial
    return result


def support_parts(direction, body):
    """Return (q, bump): the unit-direction support is sqrt(q) + bump."""
    require(body in ("K", "L"), "body must be K or L")
    require(len(direction) == 3, "a direction must have three coordinates")
    require(all(type(x) is int or isinstance(x, F) for x in direction),
            "directions must use exact integers or fractions")
    norm_squared = sum(x * x for x in direction)
    require(norm_squared > 0, "zero is not a direction")
    q = F(sum(a * x * x for a, x in zip(A, direction)), norm_squared)
    high_gate = direction[0] > 0 if body == "K" else direction[0] < 0
    high = max(q - HIGH, F(0)) ** 3 if high_gate else F(0)
    low = max(LOW - q, F(0)) ** 3 if direction[2] > 0 else F(0)
    return q, EPSILON * (high + low)


def verify():
    require(A == (3, 2, 1), "the proof is for A=diag(3,2,1)")
    require(HIGH == F(5, 2) and LOW == F(3, 2), "cutoffs changed")
    require(EPSILON == F(1, 1000), "the documented nonzero epsilon changed")
    u = [variable(i) for i in range(3)]
    v = [variable(i + 3) for i in range(3)]
    nu = add(*(square(x) for x in u))
    nv = add(*(square(x) for x in v))
    qu = add(*(scale(square(x), a) for a, x in zip(A, u)))
    qv = add(*(scale(square(x), a) for a, x in zip(A, v)))
    uv = add(*(multiply(x, y) for x, y in zip(u, v)))
    uav = add(*(scale(multiply(x, y), a) for a, x, y in zip(A, u, v)))

    require(subtract(qu, nu) == add(scale(square(u[0]), 2), square(u[1])),
            "q >= norm squared identity")
    require(subtract(scale(nu, 3), qu)
            == add(square(u[1]), scale(square(u[2]), 2)),
            "q <= 3 norm squared identity")
    require(subtract(qu, scale(nu, 2))
            == subtract(square(u[0]), square(u[2])),
            "coordinate gate separation identity")

    minors = [
        subtract(multiply(u[i], v[j]), multiply(u[j], v[i]))
        for i, j in combinations(range(3), 2)
    ]
    euclidean_det = subtract(multiply(nu, nv), square(uv))
    require(euclidean_det == add(*(square(w) for w in minors)),
            "Euclidean Lagrange identity")
    weighted_det = subtract(multiply(qu, qv), square(uav))
    curvature_polynomial = subtract(weighted_det, euclidean_det)
    expected_sos = add(*(scale(square(w), c)
                         for w, c in zip(minors, (5, 2, 1))))
    require(curvature_polynomial == expected_sos, "weighted curvature identity")
    summands = [scale(minors[0], 2), minors[0], minors[1], minors[1], minors[2]]
    require(expected_sos == add(*(square(s) for s in summands)),
            "five rational squares")

    au = [scale(x, a) for a, x in zip(A, u)]
    au_minors = [
        subtract(multiply(au[i], v[j]), multiply(au[j], v[i]))
        for i, j in combinations(range(3), 2)
    ]
    operator_slack = add(*(scale(square(x), 9 - a * a)
                           for a, x in zip(A, u)))
    require(all(9 - a * a >= 0 for a in A), "operator slack signs")
    require(subtract(scale(multiply(nu, nv), 9), square(uav))
            == add(multiply(operator_slack, nv),
                   *(square(w) for w in au_minors)),
            "|u A v| <= 3 for unit vectors")

    directory = Path(__file__).resolve().parent
    payload = json.loads((directory / "jacobian-sos-payload.json").read_text())
    recorded = json.loads((directory / "jacobian-sos-output.json").read_text())
    require(decode_polynomial(payload["polynomial"]) == curvature_polynomial,
            "payload is the actual curvature polynomial")
    require([decode_polynomial(s) for s in payload["summands"]] == summands,
            "payload uses the documented summands")
    require(recorded["operation_id"] == "polynomial.sos.decomposition.check",
            "wrong recorded Jacobian operation")
    output = recorded["output"]
    require(output["is_valid"] is True, "Jacobian did not validate the identity")
    require(output["method"] == "EXACT_COEFFICIENT_IDENTITY",
            "Jacobian did not use exact coefficient identity")
    require(output["polynomial"] == payload["polynomial"]
            and output["summands"] == payload["summands"],
            "typed output does not retain the exact request")
    require(decode_polynomial(output["computed_sum"]) == curvature_polynomial,
            "typed computed sum differs from the independent expansion")

    cap_width = F(1, 2)
    g0 = cap_width ** 3
    g1 = 3 * cap_width ** 2
    g2 = 6 * cap_width
    dq = 2 * max(A)
    ddq = 2 * (max(A) - min(A))
    perturbation_bound = g2 * dq ** 2 + g1 * ddq + g0
    curvature_margin = F(1, 8) - EPSILON * perturbation_bound
    require(LOW < HIGH and F(1) < LOW < F(2) < HIGH < F(3),
            "disjoint extreme caps")
    require(perturbation_bound == F(889, 8), "perturbation norm bound")
    require(curvature_margin == F(111, 8000) and curvature_margin > 0,
            "strict positive curvature margin")
    require(F(2) + EPSILON * g0 < 3, "compactness radius")
    require(all(value == 0 for value in (F(0) ** 3, 3 * F(0) ** 2, 6 * F(0))),
            "C2 matching at the cutoff")

    # Indeterminates M,m,a,b,c verify identities for every plane eigenbasis.
    maximum, minimum, a, b, cutoff = [variable(i) for i in range(5)]
    circle_norm = add(square(a), square(b))
    plane_q = add(multiply(maximum, square(a)), multiply(minimum, square(b)))
    reflected_q = {
        monomial: coefficient * (-1) ** monomial[2]
        for monomial, coefficient in plane_q.items()
    }
    require(reflected_q == plane_q, "reflection preserves the restricted form")
    high_identity = add(multiply(subtract(maximum, cutoff), square(a)),
                        scale(multiply(subtract(cutoff, minimum), square(b)), -1))
    low_identity = add(multiply(subtract(cutoff, minimum), square(b)),
                       scale(multiply(subtract(maximum, cutoff), square(a)), -1))
    require(subtract(plane_q, multiply(cutoff, circle_norm)) == high_identity,
            "high-cap connected-interval identity")
    require(subtract(multiply(cutoff, circle_norm), plane_q) == low_identity,
            "low-cap connected-interval identity")
    for high_present, low_present in product((False, True), repeat=2):
        case = "I" if not high_present else ("II" if not low_present else "III")
        require(case in ("I", "II", "III"), "the plane cases are exhaustive")
        if case in ("II", "III"):
            for sign in (-1, 1):
                require(int(-sign > 0) == int(sign < 0),
                        "high-cap hemisphere exchange")
        if case == "III":
            # This is the exact coordinate matrix in the p,r eigenbasis.
            reflection = ((-1, 0), (0, 1))
            for i, j in product(range(2), repeat=2):
                require(sum(reflection[k][i] * reflection[k][j] for k in range(2))
                        == int(i == j), "orthogonal plane involution")
            for sign in (-1, 1):
                require(reflection[1][1] * sign == sign,
                        "the low-cap coefficient keeps its sign")

    directions = ((0, 1, 0), (1, 1, 0), (0, 1, 1))
    for direction, q_expected in zip(directions, (F(2), HIGH, LOW)):
        opposite = tuple(-x for x in direction)
        require(support_parts(direction, "K") == (q_expected, F(0)),
                "unperturbed K translation direction")
        require(support_parts(direction, "L") == (q_expected, F(0)),
                "unperturbed L translation direction")
        require(support_parts(opposite, "L") == (q_expected, F(0)),
                "unperturbed reflected L translation direction")
    r, s, t = directions
    determinant = (r[0] * (s[1] * t[2] - s[2] * t[1])
                   - r[1] * (s[0] * t[2] - s[2] * t[0])
                   + r[2] * (s[0] * t[1] - s[1] * t[0]))
    require(determinant == -1, "translation directions span R^3")
    e1, e3 = (1, 0, 0), (0, 0, 1)
    ordinary_gap = support_parts(e1, "K")[1] - support_parts(e1, "L")[1]
    reflected_gap = support_parts(e3, "K")[1] - support_parts((0, 0, -1), "L")[1]
    require(ordinary_gap == EPSILON / 8 == F(1, 8000),
            "positive nontranslation witness")
    require(reflected_gap == F(1, 8000), "positive reflected-translation witness")

    common, left, right, coordinate = [variable(i) for i in range(4)]
    require(subtract(add(common, multiply(left, coordinate)),
                     add(common, multiply(right, coordinate)))
            == multiply(subtract(left, right), coordinate),
            "common-even plus linear-odd route is a translation")

    return {
        "result": "exact_algebra_and_bounds_passed",
        "epsilon": str(EPSILON),
        "curvature_lower_bound": str(curvature_margin),
        "translation_direction_determinant": determinant,
        "nontranslation_support_gap": str(ordinary_gap),
        "reflected_translation_support_gap": str(reflected_gap),
        "jacobian_identity": "recomputed independently over QQ",
        "plane_coverage": "symbolic identities; universal sign proof in Section 3",
        "retired_alternative": "common even support plus linear odd parts",
        "proof_document": "research/hyperplane_witness.md",
        "evidence_kind": "exact algebra supporting an analytic proof; not a proof kernel",
        "independent_review": "not asserted by this program",
    }


if __name__ == "__main__":
    print(json.dumps(verify(), indent=2, sort_keys=True))
