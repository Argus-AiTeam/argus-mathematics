#!/usr/bin/env python3
"""Replay finite identities, not the global analytic auxiliary theorem."""

import argparse
import itertools
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
OPERATION = "matrix.symbolic.determinant.compute"
XI = sp.symbols("x0:4", real=True)
BASIS = list(itertools.combinations(range(4), 2))
VOLUME = (0, 1, 2, 3)


def sign(indices):
    inversions = sum(a > b for i, a in enumerate(indices) for b in indices[i + 1 :])
    return (-1) ** inversions


def clean(form):
    result = {}
    for indices, value in form.items():
        value = sp.expand(value)
        if value != 0:
            result[indices] = value
    return result


def add(*forms):
    result = {}
    for form in forms:
        for indices, value in form.items():
            result[indices] = result.get(indices, 0) + value
    return clean(result)


def scale(value, form):
    return clean({indices: value * coefficient for indices, coefficient in form.items()})


def wedge(left, right):
    result = {}
    for a, va in left.items():
        for b, vb in right.items():
            if set(a).isdisjoint(b):
                indices = a + b
                key = tuple(sorted(indices))
                result[key] = result.get(key, 0) + sign(indices) * va * vb
    return clean(result)


def interior(index, form):
    return clean(
        {
            indices[:position] + indices[position + 1 :]: (-1) ** position * value
            for indices, value in form.items()
            for position in range(len(indices))
            if indices[position] == index
        }
    )


def star(form):
    result = {}
    for indices, value in form.items():
        complement = tuple(i for i in range(4) if i not in indices)
        result[complement] = sign(indices + complement) * value
    return clean(result)


def plus(form):
    return scale(sp.Rational(1, 2), add(form, star(form)))


def same(left, right):
    keys = set(left) | set(right)
    return all(sp.simplify(left.get(key, 0) - right.get(key, 0)) == 0 for key in keys)


def coefficient(form):
    return sp.simplify(form.get(VOLUME, 0))


def norm_squared(form):
    return sp.expand(sum(value**2 for value in form.values()))


def standard_frame():
    return [
        {(0, 1): 1, (2, 3): 1},
        {(0, 2): 1, (1, 3): -1},
        {(0, 3): 1, (1, 2): 1},
    ]


def symbol_matrix():
    b = sp.symbols("b0:4", real=True)
    simple = wedge({(i,): XI[i] for i in range(4)}, {(i,): b[i] for i in range(4)})
    slots = [sum(XI[i] * b[i] for i in range(4))]
    slots += [coefficient(wedge(form, simple)) for form in standard_frame()]
    return sp.Matrix([[sp.expand(slot).coeff(value) for value in b] for slot in slots])


def rational_function(expression):
    poly = sp.Poly(expression, *XI, domain=sp.QQ)
    terms = [
        {
            "coefficient": {"num": str(value.p), "den": str(value.q)},
            "exponents": list(exponents),
        }
        for exponents, value in poly.terms()
        if value != 0
    ]
    return {
        "domain": "QQ",
        "variables": [str(value) for value in XI],
        "numerator": {"terms": terms},
        "denominator": {
            "terms": [
                {"coefficient": {"num": "1", "den": "1"}, "exponents": [0, 0, 0, 0]}
            ]
        },
    }


def payload():
    matrix = symbol_matrix()
    return {
        "matrix": {
            "variables": [str(value) for value in XI],
            "entries": [
                [rational_function(matrix[i, j]) for j in range(4)] for i in range(4)
            ],
        }
    }


def algebra_checks():
    checks = []
    frame = standard_frame()
    assert all(same(star(form), form) for form in frame)
    gram = sp.Matrix(
        [[coefficient(wedge(left, right)) for right in frame] for left in frame]
    )
    assert gram == 2 * sp.eye(3)
    for v in range(4):
        for w in range(4):
            rhs = {}
            for permutation in itertools.permutations(range(3)):
                i, j, ell = permutation
                rhs = add(
                    rhs,
                    scale(
                        sp.Rational(sign(permutation), 6),
                        wedge(
                            wedge(interior(v, frame[i]), interior(w, frame[j])),
                            frame[ell],
                        ),
                    ),
                )
            assert coefficient(rhs) == int(v == w)
    checks.append("oriented_metric_reconstruction")

    eps = sp.Symbol("epsilon", positive=True)
    hr, hi, t1, t2 = sp.symbols("hr hi tau1 tau2", real=True)
    real_base = {(0, 2): 1, (0, 3): t1, (1, 3): -t2}
    imag_base = {(0, 3): t2, (1, 2): 1, (1, 3): t1}
    a = add(scale(hr, real_base), scale(-hi, imag_base))
    imaginary = add(scale(hi, real_base), scale(hr, imag_base))
    area = 2 * (hr**2 + hi**2) * t2
    assert sp.simplify(coefficient(wedge(a, a)) - area) == 0
    assert sp.simplify(coefficient(wedge(imaginary, imaginary)) - area) == 0
    assert coefficient(wedge(a, imaginary)) == 0

    mixed = sp.symbols("p0:5", real=True)
    psi = dict(zip(BASIS[:-1], mixed))
    psi[(2, 3)] = 1
    basic = {(0, 1): 1}
    assert coefficient(wedge(psi, basic)) == 1
    assert not wedge(a, basic) and not wedge(imaginary, basic)
    beta = (area - eps**2 * coefficient(wedge(psi, psi))) / (2 * eps)
    dsf = add(scale(eps, psi), scale(beta, basic))
    assert sp.simplify(coefficient(wedge(dsf, dsf)) - area) == 0
    assert sp.simplify(coefficient(wedge(a, dsf)) - eps * coefficient(wedge(a, psi))) == 0
    assert (
        sp.simplify(
            coefficient(wedge(imaginary, dsf))
            - eps * coefficient(wedge(imaginary, psi))
        )
        == 0
    )
    local = add(scale(eps, {(2, 3): 1}), scale(area / (2 * eps), basic))
    assert local[(2, 3)] == eps
    assert sp.simplify(coefficient(wedge(local, local)) - area) == 0
    x, y = sp.symbols("x y", real=True)
    c = add(scale(x, a), scale(y, imaginary))
    local_gram = sp.Matrix(
        [[coefficient(wedge(left, right)) / area for right in (a, c, local)]
         for left in (a, c, local)]
    ).applyfunc(sp.simplify)
    assert local_gram == sp.Matrix([[1, x, 0], [x, x**2 + y**2, 0], [0, 0, 1]])
    assert sp.factor(local_gram.det()) == y**2
    assert local_gram.subs(y, 0).det() == 0
    assert sp.simplify(area.subs({hr: 0, hi: 0})) == 0
    assert sp.simplify(area.subs(t2, 0)) == 0
    assert scale(-1, local)[(2, 3)] == -eps
    assert coefficient(wedge(scale(-1, local), scale(-1, local))) == coefficient(wedge(local, local))
    checks.append("invariant_and_nodal_semiflat")

    monodromy = sp.Matrix([[1, -1], [0, 1]])
    invariant_cycle = sp.Matrix([1, 0])
    assert monodromy.det() == 1
    assert (monodromy - sp.eye(2)).rank() == 1
    assert (monodromy - sp.eye(2)) * invariant_cycle == sp.zeros(2, 1)
    assert (monodromy - sp.eye(2)).nullspace() == [invariant_cycle]
    checks.append("annular_two_period_directions")

    aa, bb, ee = sp.symbols("a b e", real=True)
    intersection = sp.Matrix([[1, 0, aa], [0, 1, bb], [aa, bb, ee]])
    hat = sp.Matrix([-aa, -bb, 1])
    assert (intersection * hat)[:2, :] == sp.zeros(2, 1)
    q = sp.expand((hat.T * intersection * hat)[0])
    assert q == ee - aa**2 - bb**2
    r = sp.Symbol("r", positive=True)
    change = sp.Matrix([[1, 0, -r * aa], [0, 1, -r * bb], [0, 0, r]])
    assert change.det() == r
    assert sp.expand(((r * hat).T * intersection * (r * hat))[0] - r**2 * q) == 0
    assert q.subs({aa: 0, bb: 0, ee: 1}) == 1
    checks.append("three_moments_and_frame_change")

    m00, m01, m02, m11, m12, m22 = sp.symbols("m00 m01 m02 m11 m12 m22")
    matrix = sp.Matrix([[m00, m01, m02], [m01, m11, m12], [m02, m12, m22]])
    assert (matrix * matrix.adjugate() - matrix.det() * sp.eye(3)).applyfunc(sp.expand) == sp.zeros(3)
    h = dict(zip(BASIS, sp.symbols("h0:6", real=True)))
    hp = plus(h)
    hm = scale(sp.Rational(1, 2), add(h, scale(-1, star(h))))
    assert sp.expand(norm_squared(h) - norm_squared(hp) - norm_squared(hm)) == 0
    assert sp.expand(coefficient(wedge(h, h)) - norm_squared(hp) + norm_squared(hm)) == 0
    assert sp.expand(norm_squared(h) - 2 * norm_squared(hp) + coefficient(wedge(h, h))) == 0
    checks.append("gram_and_stokes_pointwise_algebra")

    zz = sp.symbols("z0:3", real=True)
    psi_selfdual = add(*(scale(zz[i], frame[i]) for i in range(3)))
    contracted = add(*(scale(XI[i], interior(i, psi_selfdual)) for i in range(4)))
    xi_form = {(i,): XI[i] for i in range(4)}
    norm_xi = sum(value**2 for value in XI)
    assert same(scale(2, plus(wedge(xi_form, contracted))), scale(norm_xi, psi_selfdual))
    symbol = symbol_matrix()
    assert (symbol.T * symbol).applyfunc(sp.expand) == norm_xi * sp.eye(4)
    determinant = sp.expand(symbol.det())
    assert sp.expand(determinant - norm_xi**2) == 0
    b_form = {(i,): value for i, value in enumerate(sp.symbols("b0:4", real=True))}
    simple = wedge(xi_form, b_form)
    assert not wedge(simple, simple)
    checks.append("selfdual_green_symbol_and_coulomb_symbol")

    d0 = dict(zip(BASIS, sp.symbols("d0:6", real=True)))
    assert same(
        wedge(add(d0, h), add(d0, h)),
        add(wedge(d0, d0), scale(2, wedge(d0, h)), wedge(h, h)),
    )
    pp, qq, delta = sp.symbols("P Q delta", positive=True)
    radius = 2 * pp * delta
    lam = pp * qq * radius
    ball_bound = pp * delta + pp * qq * radius**2 / 2
    assert sp.expand(lam - 2 * pp**2 * qq * delta) == 0
    assert sp.expand(ball_bound - radius * (1 + lam) / 2) == 0
    assert sp.expand(3 * radius / 4 - ball_bound - radius * (1 - 2 * lam) / 4) == 0
    checks.append("nonlinear_expansion_and_contraction_arithmetic")
    return checks, determinant


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prepare-jacobian", action="store_true")
    args = parser.parse_args()
    if args.prepare_jacobian:
        path = ROOT / "jacobian_payload.json"
        path.write_text(json.dumps(payload(), indent=2) + "\n")
        print(json.dumps({"operation": OPERATION, "payload_file": str(path), "state": "prepared"}))
        return

    checks, determinant = algebra_checks()
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    assert certificate["schema_version"] == 1
    assert certificate["claim"] == "AUX_ALGEBRA"
    assert certificate["classification"] == "exact_finite_algebra_for_a_conditional_analytic_theorem"
    assert certificate["machine_proves_analytic_theorem"] is False
    assert certificate["checks"] == checks
    assert certificate["annular_h2_dimension_given_wang_sequence"] == 2
    assert certificate["gauge_symbol_determinant"] == "(x0**2+x1**2+x2**2+x3**2)**2"
    assert certificate["moment_square"] == "e-a**2-b**2"
    assert certificate["frame_change_determinant"] == "r>0"
    assert certificate["boundary_tests"] == [
        "y=0 destroys pair definiteness",
        "h=0 or tau2=0 destroys the positive volume",
        "-D has the same wedge equations but forbidden negative fiber sign",
    ]
    assert certificate["parameter_quantifier"] == "for every sufficiently small positive epsilon"
    assert certificate["bootstrap_parameter"] == "one fixed epsilon; no infinite-order uniform threshold"
    assert certificate["upstream_hypotheses"] == [
        "prop:regular-preparation",
        "thm:nodal-model including both periods and item iii",
        "b-plus equals three from prop:topology",
        "classical fixed-metric and local analytic inputs listed in argument.md",
    ]
    assert certificate["jacobian"]["operation_id"] == OPERATION
    assert certificate["jacobian"]["server_version"] == "0.14.0"
    assert certificate["jacobian"]["protocol_version"] == "2025-11-25"
    assert certificate["jacobian"]["adapter_exit_code"] == 0
    assert certificate["jacobian"]["timeout"] is False
    assert certificate["jacobian"]["structured_error"] is None
    assert certificate["jacobian"]["typed_output_complete"] is True
    assert json.loads((ROOT / "jacobian_payload.json").read_text()) == payload()
    replay_jacobian(determinant)
    print(json.dumps({
        "ok": True,
        "checks": len(checks),
        "claim": "AUX_ALGEBRA",
        "analytic_theorem_machine_verified": False,
    }, sort_keys=True))


def replay_jacobian(determinant):
    output = json.loads((ROOT / "jacobian_output.json").read_text())
    assert output["schema_version"] == 1
    assert output["tool"] == "math.run"
    assert output["server"]["name"] == "jacobian"
    assert output["server"]["version"] == "0.14.0"
    assert output["protocol_version"] == "2025-11-25"
    assert output["transport"] == "mcp-stdio"
    assert output["request"] == {"operation_id": OPERATION, "payload": payload()}
    assert "error" not in output
    result = output["result"]
    assert set(result) == {"operation_id", "output", "runtime_ms"}
    assert result["operation_id"] == OPERATION
    assert isinstance(result["runtime_ms"], int) and result["runtime_ms"] >= 0
    assert result["output"]["method"] == "SYMPY_BAREISS"
    assert result["output"]["determinant"] == rational_function(determinant)


if __name__ == "__main__":
    main()
