#!/usr/bin/env python3
"""Exact algebra for the all-real-plane theorem in proof.md."""

import argparse
import hashlib
import itertools
import json
import math
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
CHECKS = {}


def equal(name, left, right=0):
    if isinstance(left, sp.MatrixBase):
        for i in range(left.rows):
            for j in range(left.cols):
                equal(f"{name}_{i}{j}", left[i, j], right[i, j])
        return
    residual = sp.cancel(left - right)
    if residual != 0:
        raise AssertionError(f"{name}: nonzero residual {residual}")
    CHECKS[name] = True


def norm_square(value):
    return sp.expand(value * sp.conjugate(value))


def pair(form, left, right):
    return sum(
        form[i, j] * left[i] * sp.conjugate(right[j])
        for i in range(len(left))
        for j in range(len(right))
    )


def gram(form, left, right):
    pairing = sp.expand(pair(form, left, right))
    imaginary = sp.expand(sp.im(pairing))
    area = sp.expand(
        pair(form, left, left) * pair(form, right, right)
        - sp.re(pairing) ** 2
    )
    return area, imaginary


def jet_add(target, source, factor=1):
    for monomial, coefficient in source.items():
        target[monomial] = target.get(monomial, 0) + factor * coefficient


def jet_product(left, right):
    result = {}
    for m, a in left.items():
        for n, b in right.items():
            exponent = tuple(i + j for i, j in zip(m, n))
            if sum(exponent) <= 4:
                result[exponent] = result.get(exponent, 0) + a * b
    return result


def jet_term(jet, indices, coefficient):
    exponent = tuple(indices.count(i) for i in range(6))
    jet[exponent] = jet.get(exponent, 0) + coefficient


def derivative(jet, indices):
    exponent = tuple(indices.count(i) for i in range(6))
    return sp.expand(
        jet.get(exponent, 0)
        * math.prod(math.factorial(k) for k in exponent)
    )


def tensor_from_potential():
    x, lam = sp.symbols("x lam", real=True)
    d1, d2, hr, hi = sp.symbols("d1 d2 hr hi", real=True)
    q = x * (1 + x)
    h = sp.Matrix([[d1, hr + sp.I * hi], [hr - sp.I * hi, d2]])
    g = lam * sp.eye(2) + x * h
    inv = g.inv()
    pairs = list(itertools.combinations_with_replacement(range(2), 2))
    a = {
        (i, k, j): sp.Symbol(f"A{i}{k}{j}")
        for i, k in pairs
        for j in range(2)
    }
    abar = {key: sp.Symbol(f"Ac{key[0]}{key[1]}{key[2]}") for key in a}
    b = {
        (i, k, j, l): sp.Symbol(f"B{i}{k}{j}{l}")
        for i, k in pairs
        for j, l in pairs
    }

    def third(i, k, j, conjugate=False):
        i, k = sorted((i, k))
        return (abar if conjugate else a)[i, k, j]

    def fourth(i, k, j, l):
        i, k = sorted((i, k))
        j, l = sorted((j, l))
        return b[i, k, j, l]

    s = {}
    jet_term(s, [2], 1)
    jet_term(s, [5], 1)
    for i, j in itertools.product(range(2), repeat=2):
        jet_term(s, [i, j + 3], h[i, j])
    for i, k, j in itertools.product(range(2), repeat=3):
        jet_term(s, [i, k, j + 3], third(i, k, j) / 2)
        jet_term(s, [i + 3, k + 3, j], third(i, k, j, True) / 2)
    for i, k, j, l in itertools.product(range(2), repeat=4):
        jet_term(s, [i, k, j + 3, l + 3], fourth(i, k, j, l) / 4)
    for triple in itertools.combinations_with_replacement(range(2), 3):
        coefficient = sp.Symbol("P" + "".join(map(str, triple)))
        divisor = math.prod(math.factorial(triple.count(i)) for i in range(2))
        jet_term(s, list(triple), coefficient / divisor)
        jet_term(s, [i + 3 for i in triple], sp.conjugate(coefficient) / divisor)

    radius = {}
    for i in range(2):
        jet_term(radius, [i, i + 3], 1)
    psi = dict(radius)
    jet_add(psi, jet_product(radius, radius), sp.Rational(1, 2))
    potential = {}
    jet_add(potential, psi, lam)
    power = {(0,) * 6: 1}
    f_derivatives = [x, q, q * (1 + 2 * x), q * (1 + 6 * x + 6 * x**2)]
    for order, value in enumerate(f_derivatives, start=1):
        power = jet_product(power, s)
        jet_add(potential, power, value / math.factorial(order))

    for i, j in itertools.product(range(3), repeat=2):
        expected = g[i, j] if i < 2 and j < 2 else q if i == j == 2 else 0
        equal(f"metric_{i}{j}", derivative(potential, [i, j + 3]), expected)

    def raw_curvature(aa, bb, cc, dd):
        value = -derivative(potential, [aa, cc, bb + 3, dd + 3])
        for p, e in itertools.product(range(2), repeat=2):
            value += (
                inv[e, p]
                * derivative(potential, [aa, cc, e + 3])
                * derivative(potential, [p, bb + 3, dd + 3])
            )
        value += (
            derivative(potential, [aa, cc, 5])
            * derivative(potential, [2, bb + 3, dd + 3])
            / q
        )
        return value

    for aa, bb, cc, dd in itertools.product(range(3), repeat=4):
        hol = [i for i in (aa, cc) if i < 2]
        anti = [i for i in (bb, dd) if i < 2]
        horizontal_count = len(hol) + len(anti)
        expected = 0
        if horizontal_count == 4:
            si = int(aa == bb) * int(cc == dd) + int(aa == dd) * int(cc == bb)
            sh = h[aa, bb] * h[cc, dd] + h[aa, dd] * h[cc, bb]
            correction = sum(
                inv[e, p] * third(aa, cc, e) * third(bb, dd, p, True)
                for p, e in itertools.product(range(2), repeat=2)
            )
            expected = -lam * si - q * sh - x * fourth(aa, cc, bb, dd)
            expected += x**2 * correction
        elif horizontal_count == 3 and len(hol) == 2:
            i, k = hol
            j = anti[0]
            correction = sum(
                inv[e, p] * third(i, k, e) * h[p, j]
                for p, e in itertools.product(range(2), repeat=2)
            )
            expected = q * (-third(i, k, j) + x * correction)
        elif horizontal_count == 3:
            j, l = anti
            i = hol[0]
            correction = sum(
                inv[e, p] * h[i, e] * third(j, l, p, True)
                for p, e in itertools.product(range(2), repeat=2)
            )
            expected = q * (-third(j, l, i, True) + x * correction)
        elif horizontal_count == 2 and len(hol) == len(anti) == 1:
            i, j = hol[0], anti[0]
            expected = -q * ((1 + 2 * x) * h[i, j] - q * (h * inv * h)[i, j])
        elif horizontal_count == 0:
            expected = -2 * q**2
        equal(f"curvature_jet_{aa}{bb}{cc}{dd}", raw_curvature(aa, bb, cc, dd), expected)

    zero = {}
    jet_add(zero, psi, lam)
    jet_term(zero, [2, 5], 1)
    jet_term(zero, [2, 2, 5, 5], sp.Rational(1, 2))
    for i, j in itertools.product(range(2), repeat=2):
        jet_term(zero, [i, j + 3, 2, 5], h[i, j])
    for indices in itertools.product(range(3), repeat=3):
        equal("zero_third_" + "".join(map(str, indices)),
              derivative(zero, [indices[0], indices[1], indices[2] + 3]))
    for aa, bb, cc, dd in itertools.product(range(3), repeat=4):
        hol = [i for i in (aa, cc) if i < 2]
        anti = [i for i in (bb, dd) if i < 2]
        expected = 0
        if len(hol) == len(anti) == 2:
            expected = -lam * (
                int(aa == bb) * int(cc == dd) + int(aa == dd) * int(cc == bb)
            )
        elif len(hol) == len(anti) == 1:
            expected = -h[hol[0], anti[0]]
        elif not hol and not anti:
            expected = -2
        equal(f"zero_curvature_{aa}{bb}{cc}{dd}",
              -derivative(zero, [aa, cc, bb + 3, dd + 3]), expected)
    equal("D_alternative", (1 + 2 * x) * h - q * h * inv * h,
          x * h + lam * (1 + x) * h * inv)
    equal("vertical_curvature", -q * (1 + 6 * x + 6 * x**2) + q * (1 + 2 * x)**2,
          -2 * q**2)


def contractions_and_corners():
    real = sp.symbols("u1r u1i u2r u2i u0r u0i v1r v1i v2r v2i v0r v0i", real=True)
    u = [real[2 * i] + sp.I * real[2 * i + 1] for i in range(3)]
    v = [real[6 + 2 * i] + sp.I * real[7 + 2 * i] for i in range(3)]
    horizontal = sp.diag(1, 1, 0)
    vertical = sp.diag(0, 0, 1)
    ah, bh = gram(horizontal, u, v)
    av, bv = gram(vertical, u, v)
    total, _ = gram(horizontal + vertical, u, v)
    mixed = sp.expand(total - ah - av)
    xi = sp.Matrix(3, 3, lambda i, j: u[i] * sp.conjugate(v[j]) - v[i] * sp.conjugate(u[j]))
    hh_norm = sum(norm_square(xi[i, j]) for i, j in itertools.product(range(2), repeat=2))
    mix_column = sum(norm_square(xi[i, 2]) for i in range(2))
    equal("Xi_HH_norm", hh_norm, 2 * (ah + bh**2))
    equal("Xi_mixed_norm", mix_column, mixed + 2 * bh * bv)
    equal("vertical_rank_one", av, bv**2)
    full_norm = sum(norm_square(value) for value in xi)
    _, total_imaginary = gram(horizontal + vertical, u, v)
    equal("Xi_full_norm", full_norm, 2 * (total + total_imaginary**2))
    d1, d2, hr, hi = sp.symbols("hd1 hd2 hreal himag", real=True)
    hform = sp.Matrix([[d1, hr + sp.I * hi, 0],
                       [hr - sp.I * hi, d2, 0], [0, 0, 0]])
    weighted_area, weighted_imaginary = gram(hform, u, v)
    weighted_total, _ = gram(hform + vertical, u, v)
    weighted_mixed = weighted_total - weighted_area - av
    weighted_column = sum(hform[i, j] * xi[i, 2] * sp.conjugate(xi[j, 2])
                          for i, j in itertools.product(range(2), repeat=2))
    equal("Xi_weighted_mixed_norm", weighted_column,
          weighted_mixed + 2 * weighted_imaginary * bv)

    indices = list(itertools.combinations_with_replacement(range(3), 2))
    hermitian = {}
    for i in range(6):
        for j in range(i, 6):
            re = sp.Symbol(f"R{i}{j}", real=True)
            im = 0 if i == j else sp.Symbol(f"J{i}{j}", real=True)
            hermitian[i, j] = re + sp.I * im
            hermitian[j, i] = re - sp.I * im

    def tensor(a, b, c, d):
        return hermitian[indices.index(tuple(sorted((a, c)))),
                         indices.index(tuple(sorted((b, d))))]

    # Independent conjugate symbols keep this multilinear identity small.
    uu, vv, ub, vb = [sp.symbols(f"{name}0:3") for name in ("U", "V", "Uc", "Vc")]
    xx = sp.Matrix(3, 3, lambda i, j: uu[i] * vb[j] - vv[i] * ub[j])
    h_value = 0
    xi_value = 0
    for a, b, c, d in itertools.product(range(3), repeat=4):
        t = tensor(a, b, c, d)
        h_value += t * (
            uu[a] * ub[b] * vv[c] * vb[d]
            - (uu[a] * vb[b] * uu[c] * vb[d] + vv[a] * ub[b] * vv[c] * ub[d]) / 2
        )
        xi_value -= t * xx[a, b] * xx[c, d] / 2
    equal("generic_Kahler_Xi_contraction", h_value, xi_value)

    e1, e2 = sp.symbols("e1 e2", real=True)
    e = sp.diag(e1, e2, 0)
    ae, be = gram(e, u, v)
    combined, _ = gram(e + vertical, u, v)
    me = sp.expand(combined - ae - av)
    original = ah + 3 * bh**2 + 4 * av + me + 6 * be * bv
    b1 = sp.expand(sp.im(u[0] * sp.conjugate(v[0])))
    b2 = sp.expand(sp.im(u[1] * sp.conjugate(v[1])))
    d12 = norm_square(u[0] * v[1] - u[1] * v[0])
    c12 = norm_square(u[0] * sp.conjugate(v[1]) - v[0] * sp.conjugate(u[1]))
    c1, c2 = (norm_square(xi[i, 2]) for i in range(2))
    equal("horizontal_Plucker", c12, d12 + 4 * b1 * b2)
    p = d12 + 4 * (b1 + b2)**2 + 4 * bv**2 + e1 * (c1 + 4 * b1 * bv) + e2 * (c2 + 4 * b2 * bv)
    equal("diagonal_mixed_expression", original, p)
    corners = {
        (1, 1): c12 + c1 + c2 + 2 * (b1 + b2 + bv)**2 + 2 * (b1**2 + b2**2 + bv**2),
        (1, 2): c12 + c1 + 2 * c2 + (2 * b1 + b2 + bv)**2 + 3 * (b2 + bv)**2,
        (2, 1): c12 + 2 * c1 + c2 + (b1 + 2 * b2 + bv)**2 + 3 * (b1 + bv)**2,
        (2, 2): d12 + 2 * (c1 + c2) + 4 * (b1 + b2 + bv)**2,
    }
    for corner, sos in corners.items():
        equal(f"corner_{corner[0]}{corner[1]}", p.subs({e1: corner[0], e2: corner[1]}), sos)
    interpolation = sum(
        (2 - e1 if i == 1 else e1 - 1)
        * (2 - e2 if j == 1 else e2 - 1)
        * expression
        for (i, j), expression in corners.items()
    )
    equal("four_corner_interpolation", p, interpolation)
    p11 = p.subs({e1: 1, e2: 1})
    equal("corner11_hyperbolic", p11, total + 3 * (bh + bv)**2)

    # Verify S_P for an arbitrary Hermitian 3-by-3 form, not just h or V.
    pform = sp.Matrix(3, 3, lambda i, j: hermitian[min(i, j), max(i, j)] if i <= j
                      else sp.conjugate(hermitian[j, i]))
    def formal_pair(left, right):
        return sum(pform[i, j] * left[i] * right[j]
                   for i, j in itertools.product(range(3), repeat=2))
    puu, pvv = formal_pair(uu, ub), formal_pair(vv, vb)
    puv, pvu = formal_pair(uu, vb), formal_pair(vv, ub)
    area = puu * pvv - ((puv + pvu) / 2)**2
    imaginary = (puv - pvu) / (2 * sp.I)
    h_sp = puu * pvv + puv * pvu - puv**2 - pvu**2
    equal("generic_S_contraction", h_sp, area + 3 * imaginary**2)


def scalar_certificates():
    a, s, t, delta, k, m = sp.symbols("a s t delta k m", real=True)
    square = (s - 2 * t)**2
    equal("Young_absorption", m**2 / 4 + (k * a)**2 - k * a * m, (m / 2 - k * a)**2)
    equal("gap_absorption", square / 4 + delta * a * t - delta * a**2 / 4,
          (t - (s - delta * a) / 2)**2
          + delta * a * (s - a) / 2 + delta * (1 - delta) * a**2 / 4)
    equal("vertical_area_control", 2 * a**2 + square / 2 - t**2,
          (s - t)**2 + (4 * a**2 - s**2) / 2)
    equal("cross_area_control", 2 * a**2 + square / 4 - a * t,
          (a - t)**2 / 2 + (2 * a**2 + square / 2 - t**2) / 2 + a**2 / 2)
    b = sp.Symbol("b", real=True)
    equal("imaginary_pairing_bound", 4 * (a**2 + 3 * b**2) - (a + 3 * b)**2,
          3 * (a - b)**2)
    x, lam, C, ce = sp.symbols("x lam C ce", real=True)
    c = sp.Symbol("c", positive=True)
    q = x * (1 + x)
    equal("epsilon_rationalization", (1 + 2 * x)**2 - 4 * q, 1)
    equal("sqrtq_upper_for_x_ge_one", 4 * x**2 - q, x * (3 * x - 1))
    equal("q_ge_two_for_x_ge_one", q - 2, (x - 1) * (x + 2))
    B = 1 + 2 * ce + 16 * ce**2 / c + 2 * C**2
    alpha = c**3 / 8
    threshold = sp.cancel(B**2 * (B + C) / alpha)
    equal("threshold_formula", threshold, 8 * B**2 * (B + C) / c**3)
    equal("threshold_low_lambda_product",
          B * x * ((B + C) * x), (B * (B + C)) * x**2)
    equal("threshold_high_x_product", (alpha * x) * x**2, alpha * x**3)
    equal("small_x_cross_absorption",
          2 * t**2 + sp.Rational(81, 2) * C**2 * a**2 - 18 * C * a * t,
          2 * (t - sp.Rational(9, 2) * C * a)**2)
    equal("small_x_error_absorption",
          c * m**2 / 2 + 16 * ce**2 * a**2 / c - 4 * sp.sqrt(2) * ce * a * m,
          (sp.sqrt(c / 2) * m - 4 * ce * a / sp.sqrt(c))**2)
    disk_x, disk_y = sp.symbols("disk_x disk_y", real=True)
    conformal = 2 / (1 - disk_x**2 - disk_y**2)**2
    gaussian = -(sp.diff(sp.log(conformal), disk_x, 2)
                 + sp.diff(sp.log(conformal), disk_y, 2)) / (2 * conformal)
    equal("disk_real_sectional_normalization",
          gaussian.subs({disk_x: 0, disk_y: 0}), -2)


def sparse(expression, variables):
    polynomial = sp.Poly(sp.expand(expression), *variables, domain=sp.QQ)
    return {
        "domain": "QQ",
        "variables": [str(v) for v in variables],
        "polynomial": {
            "terms": [
                {"coefficient": {"num": str(coefficient.p), "den": str(coefficient.q)},
                 "exponents": list(exponents)}
                for exponents, coefficient in polynomial.terms()
                if coefficient
            ]
        },
    }


def jacobian_payload():
    a, b, c, d, e, f, g, k = variables = sp.symbols("a b c d e f g k", real=True)
    bh, bv = -a * c, -f * k
    ah = a**2 * (c**2 + d**2 + e**2)
    av = f**2 * k**2
    mixed = a**2 * (g**2 + k**2) + f**2 * (b**2 + c**2 + d**2 + e**2) - 2 * a * b * f * g
    p22 = ah + 3 * bh**2 + 4 * av + 2 * mixed + 12 * bh * bv
    summands = [a * d, a * e, 2 * (bh + bv)]
    mixed_summands = [a * g - b * f, a * k + c * f, d * f, e * f]
    summands += mixed_summands + mixed_summands
    equal("Jacobian_payload_identity", p22, sum(value**2 for value in summands))
    return {"polynomial": sparse(p22, variables),
            "summands": [sparse(value, variables) for value in summands]}


def formal_evidence():
    result = json.loads((HERE / "lean_verification.json").read_text())
    if result["status"] != "success" or result["exit_code"] != 0 or result["proof_holes"]:
        raise AssertionError("the recorded Lean run is not a successful hole-free compile")
    if "version 4.31.0," not in result["tools"]["lean"]["version"]:
        raise AssertionError("the recorded compiler is not Lean 4.31.0")
    for filename, field in (("Main.lean", "source_sha256"),
                            ("statement_fidelity.md", "statement_fidelity_sha256")):
        if hashlib.sha256((HERE / filename).read_bytes()).hexdigest() != result[field]:
            raise AssertionError(f"{filename} changed after the recorded compiler run")
    record = result["kernel"]["recorded"]
    if record["verdict"] != "supports" or record["subject"]["subject_id"] != "C359_ALGEBRA":
        raise AssertionError("the compiler record does not support C359_ALGEBRA")
    archive_path = HERE / "certificates" / Path(record["artifact"]).name
    archive = json.loads(archive_path.read_text())
    if archive["lean_source"]["text"] != (HERE / "Main.lean").read_text():
        raise AssertionError("the archived formal claim differs from the current Lean source")
    if archive["lean_check"] != {key: value for key, value in result.items() if key != "kernel"}:
        raise AssertionError("the archived compiler answer differs from lean_verification.json")
    return {"claim": "C359_ALGEBRA", "version": "4.31.0", "exit_code": 0,
            "proof_holes": [], "archive": str(archive_path.relative_to(HERE)),
            "scope": "Universal scalar identities and inequalities, not the entire geometry."}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--write-jacobian-payload", action="store_true")
    args = parser.parse_args()
    tensor_from_potential()
    contractions_and_corners()
    scalar_certificates()
    payload = jacobian_payload()
    lean = formal_evidence()
    if args.write_jacobian_payload:
        (HERE / "jacobian_payload.json").write_text(json.dumps(payload, indent=2) + "\n")
    if (HERE / "jacobian_payload.json").exists():
        if json.loads((HERE / "jacobian_payload.json").read_text()) != payload:
            raise AssertionError("saved Jacobian payload differs from the exact derived polynomial")
    adapter = {"operation_id": "polynomial.sos.decomposition.check", "status": "not_run"}
    if (HERE / "jacobian_result.json").exists():
        result = json.loads((HERE / "jacobian_result.json").read_text())
        run_status = json.loads((HERE / "jacobian_run_status.json").read_text())
        if run_status["exit_code"] != 0 or run_status["timed_out"]:
            raise AssertionError("Jacobian run failed or timed out")
        checked = result["result"]["output"]
        if checked.get("is_valid") is not True:
            raise AssertionError("Jacobian did not return an exact valid decomposition")
        adapter.update(status="exact_valid", server=result["server"]["version"],
                       protocol=result["protocol_version"],
                       exit_code=run_status["exit_code"], timed_out=run_status["timed_out"])
        if checked["polynomial"] != payload["polynomial"] or checked["summands"] != payload["summands"]:
            raise AssertionError("Jacobian checked a different polynomial or summand family")
        if checked["computed_sum"] != payload["polynomial"] or checked["method"] != "EXACT_COEFFICIENT_IDENTITY":
            raise AssertionError("Jacobian did not return the claimed exact coefficient identity")
    certificate = {
        "result_class": "new_theorem",
        "claim": "C359_EXPLICIT_PINCH",
        "also_supports": ["C359_PINCH", "C359_TENSOR", "C359_COERCIVITY", "C359_DIMENSION_FREE"],
        "novelty_status": "pending_independent_review",
        "scope": "Quantitative verification of the threefold real-plane curvature core only.",
        "method": "Exact symbolic identities, compiled universal scalar inequalities, and the geometric bridges proved in proof.md.",
        "threshold": {
            "B": "1 + 2*Ce + 16*Ce^2/c + 2*C^2",
            "lambda0": "max(1,C,1+2*Ce+41*C^2+16*Ce^2/c,8*B^2*(B+C)/c^3)",
        },
        "curvature_bounds": {
            "H": "2+2*C^2+(4*C^2+2)/c",
            "eta": "min(c^3/(8*(lambda+C)),1/8)",
            "A": "min(1,c/2,eta/H)/(2*(lambda+C)^2)",
            "Bcurv": "(4*lambda+8*C^2+2+24*C+3*Ce)/min(c/2,1)^2",
        },
        "quantifiers": "Every fixed 0<c<=C, Ce>=0, lambda>=lambda0, x>=0, admissible h and error tensors, and every real two-plane.",
        "norm": "Full complex component Frobenius norm; other fixed Euclidean conventions require norm-equivalence adjustment of Ce.",
        "coverage": ["x=0 regular-coordinate jet", "0<=x<=1", "x>=1 unbounded", "lambda comparable to x^(3/2)", "degenerate projected areas", "arbitrary permitted T3 and T4"],
        "dimension_free_extension": "The same constants and mixed coercivity hold on C^n plus C for every n>=1, by restricting to the complex span of the two horizontal vectors and using dimension-free contractions.",
        "checks": CHECKS,
        "exact_identity_count": len(CHECKS),
        "jacobian": adapter,
        "lean": lean,
        "limitations": [
            "Symbolic verification is not a formalization of the entire geometric proof.",
            "Lean certifies the separate scalar algebra claim C359_ALGEBRA, not either manuscript.",
            "Independent Host review and the final novelty/significance determination are outstanding.",
        ],
    }
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    if not path.exists():
        raise FileNotFoundError("Run once with --write-certificate to materialize the computed certificate.")
    if json.loads(path.read_text()) != certificate:
        raise AssertionError("exact_certificate.json does not match the freshly computed result")
    print(json.dumps({"ok": True, "exact_identity_count": len(CHECKS),
                      "jacobian": adapter, "lean": lean,
                      "certificate": str(path.relative_to(HERE))}))


if __name__ == "__main__":
    main()
