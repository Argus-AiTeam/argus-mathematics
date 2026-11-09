#!/usr/bin/env python3
"""Exact rational reconstruction of the family-348 Hessian projection bridge."""

import argparse
import json
from pathlib import Path

import sympy as sp


R = sp.Rational


def eye(n):
    return sp.SparseMatrix(sp.eye(n))


def zero(n, m=None):
    return sp.SparseMatrix.zeros(n, n if m is None else m)


def kron(*matrices):
    return sp.SparseMatrix(sp.kronecker_product(*matrices))


def total(matrices, n):
    return sum(matrices, zero(n))


def quaternion_product(p, q):
    return sp.Matrix([
        p[0] * q[0] - sum(p[i] * q[i] for i in range(1, 4)),
        *[
            p[0] * q[i + 1] + q[0] * p[i + 1]
            + sum(sp.LeviCivita(i, j, k) * p[j + 1] * q[k + 1]
                  for j in range(3) for k in range(3))
            for i in range(3)
        ],
    ])


def coordinates(s):
    return sp.Matrix([
        (s[0, 0] - s[1, 1]) / 2,
        (s[0, 0] + s[1, 1]) / 2,
        s[0, 1], s[0, 2], s[1, 2],
    ])


def weighted_action(t, generators, denominator, projector):
    n = projector.rows
    raw = total([
        t[r, s] * generators[r] * generators[s]
        for r in range(3) for s in range(3) if t[r, s] != 0
    ], n)
    return projector * raw * projector / denominator


def reconstruct():
    checks = []

    def equal(name, a, b):
        residual = a - b
        if any(value != 0 for value in residual):
            raise AssertionError(f"{name}: exact nonzero residual {residual}")
        checks.append(name)

    def projector(name, p, metric):
        equal(name + ":idempotent", p * p, p)
        equal(name + ":orthogonal", metric * p, p.T * metric)
        return int(sp.trace(p))

    def product_coefficients(name, operator, rhs):
        for i in range(4):
            equal(f"{name}:a{i}^2", operator[20*i:20*i+20, 20*i:20*i+20], rhs)
            for j in range(i + 1, 4):
                equal(
                    f"{name}:a{i}a{j}",
                    operator[20*i:20*i+20, 20*j:20*j+20]
                    + operator[20*j:20*j+20, 20*i:20*i+20],
                    zero(20),
                )

    v_basis = [eye(4)[:, i] for i in range(4)]
    plus = [
        sp.SparseMatrix.hstack(*[
            quaternion_product(v_basis[s + 1], v) for v in v_basis
        ]) for s in range(3)
    ]
    minus = [
        sp.SparseMatrix.hstack(*[
            -quaternion_product(v, v_basis[s + 1]) for v in v_basis
        ]) for s in range(3)
    ]
    for s in range(3):
        equal(f"I{s}:square", plus[s]**2, -eye(4))
        equal(f"J{s}:square", minus[s]**2, -eye(4))
        equal(f"I{s}:skew", plus[s].T, -plus[s])
        equal(f"J{s}:skew", minus[s].T, -minus[s])
        equal(f"I{s}:cyclic", plus[s] * plus[(s + 1) % 3], plus[(s + 2) % 3])
        equal(f"J{s}:cyclic", minus[s] * minus[(s + 1) % 3], minus[(s + 2) % 3])
        for t in range(3):
            equal(f"I{s}J{t}:commute", plus[s] * minus[t], minus[t] * plus[s])
        for family, matrices, chirality in [("I", plus, 1), ("J", minus, -1)]:
            star = sp.SparseMatrix(4, 4, lambda i, j: sum(
                sp.LeviCivita(i, j, k, l) * matrices[s][k, l] / 2
                for k in range(4) for l in range(4)
            ))
            equal(f"{family}{s}:Hodge", star, chirality * matrices[s])

    f_basis = [
        sp.diag(1, -1, 0), sp.diag(1, 1, -2),
        sp.Matrix([[0, 1, 0], [1, 0, 0], [0, 0, 0]]),
        sp.Matrix([[0, 0, 1], [0, 0, 0], [1, 0, 0]]),
        sp.Matrix([[0, 0, 0], [0, 0, 1], [0, 1, 0]]),
    ]
    wf = sp.diag(2, 6, 2, 2, 2)
    w20 = kron(eye(4), wf)
    w80 = kron(eye(4), w20)
    equal("F:Hilbert-Schmidt-metric", sp.Matrix(5, 5, lambda i, j:
          sp.trace(f_basis[i] * f_basis[j])), wf)
    rotations = [
        sp.Matrix(3, 3, lambda i, j: 2 * sp.LeviCivita(s, j, i))
        for s in range(3)
    ]
    sigma = [
        sp.SparseMatrix.hstack(*[
            coordinates(a * f - f * a) for f in f_basis
        ]) for a in rotations
    ]
    for s in range(3):
        equal(f"Sigma{s}:skew", wf * sigma[s], -sigma[s].T * wf)
        equal(f"Sigma{s}:Lie", sigma[s] * sigma[(s + 1) % 3]
              - sigma[(s + 1) % 3] * sigma[s], 2 * sigma[(s + 2) % 3])
    equal("F:Casimir", total([s*s for s in sigma], 5), -24 * eye(5))

    bianchi = sp.SparseMatrix(12, 20, lambda row, col: sum(
        plus[s][row % 4, col // 5] * f_basis[col % 5][s, row // 4]
        for s in range(3)
    ))
    kernel = sp.SparseMatrix.hstack(*bianchi.nullspace())
    if kernel.cols != 12 or bianchi.rank() != 8:
        raise AssertionError("Bianchi kernel/rank is not 12/8")
    kernel_projector = kernel * (kernel.T * w20 * kernel).inv() * kernel.T * w20
    coupling = total([kron(plus[s], sigma[s]) for s in range(3)], 20)
    pg = (6 * eye(20) - coupling) / 10
    equal("G:kernel-vs-Casimir-projector", pg, kernel_projector)
    equal("G:Bianchi", bianchi * pg, zero(12, 20))
    equal("G:Casimir-minimal-polynomial", coupling**2 - 2*coupling, 24*eye(20))
    equal("G:coupling-eigenvalue", coupling * pg, -4 * pg)
    equal("G:complement-eigenvalue", coupling * (eye(20)-pg), 6*(eye(20)-pg))
    ranks = {"G": projector("G", pg, w20)}

    # s=(1,1,-2) makes sqrt(3)*tilde(s) integral without changing G.
    parameters = []
    s = [1, 1, -2]
    for column in range(12):
        p, k, l = [sp.zeros(4, 1) for _ in range(3)]
        [p, k, l][column // 4][column % 4] = 1
        z = [sp.zeros(3) for _ in range(4)]
        for i in range(3):
            j, h = (i + 1) % 3, (i + 2) % 3
            diagonal = s[i]*p - (s[j]-s[h])*k
            off = -plus[i] * (l + s[i]*k + R(s[j]-s[h], 3)*p)
            for d in range(4):
                z[d][i, i] = diagonal[d]
                z[d][j, h] = z[d][h, j] = off[d]
        parameters.append(sp.Matrix.vstack(*[coordinates(t) for t in z]))
    parameter_map = sp.SparseMatrix.hstack(*parameters)
    equal("G:parametrization-Bianchi", bianchi * parameter_map, zero(12))
    equal("G:parametrization-metric", parameter_map.T * w20 * parameter_map,
          sp.diag(*([10]*4 + [30]*4 + [6]*4)))
    if parameter_map.rank() != 12:
        raise AssertionError("Gradient parametrization does not span G")

    inner_plus = [kron(plus[s], eye(5)) + kron(eye(4), sigma[s]) for s in range(3)]
    inner_minus = [kron(minus[s], eye(5)) for s in range(3)]
    equal("G:total-plus-Casimir", -total([g*g for g in inner_plus], 20)*pg, 35*pg)
    h = kron(eye(4), pg)
    lp = [kron(plus[s], eye(20)) + kron(eye(4), inner_plus[s]) for s in range(3)]
    lm = [kron(minus[s], eye(20)) + kron(eye(4), inner_minus[s]) for s in range(3)]
    cp = -total([g*g for g in lp], 80)
    cm = -total([g*g for g in lm], 80)
    pp = h * (cp - 24 * eye(80)) * h / 24
    pm = h * cm * h / 8
    py = pp * pm
    p30, p21, p20 = pp-py, pm-py, h-pp-pm+py
    for name, proj in [("H", h), ("P_plus", pp), ("P_minus", pm),
                       ("Y_(3,1)", py), ("(3,0)", p30),
                       ("(2,1)", p21), ("(2,0)", p20)]:
        ranks[name] = projector(name, proj, w80)
    if ranks != {"G": 12, "H": 48, "P_plus": 28, "P_minus": 36,
                 "Y_(3,1)": 21, "(3,0)": 7, "(2,1)": 15, "(2,0)": 5}:
        raise AssertionError(f"Incorrect representation dimensions: {ranks}")
    equal("H:plus-minus-commute", pp * pm, pm * pp)
    for name, proj, pc, mc in [
        ("Y", py, 48, 8), ("30", p30, 48, 0),
        ("21", p21, 24, 8), ("20", p20, 24, 0),
    ]:
        equal(name + ":plus-Casimir", cp * proj, pc * proj)
        equal(name + ":minus-Casimir", cm * proj, mc * proj)
    trace = sp.SparseMatrix(5, 80, lambda a, c:
                            int(c % 5 == a and c // 20 == (c // 5) % 4))
    trace_adjoint = h * trace.T
    equal("trace:normalization", trace * trace_adjoint, R(12, 5)*eye(5))
    equal("trace:type-projector", R(5, 12)*trace_adjoint*trace*h, p20)

    def bf(t):
        return sp.SparseMatrix.hstack(*[
            coordinates((t*f + f*t)/2 - sp.trace(t*f)*eye(3)/3)
            for f in f_basis
        ])

    qg, qt, ud = [], [], []
    for a, t in enumerate(f_basis):
        qg.append(weighted_action(t, inner_plus, 40, pg))
        qt.append(weighted_action(t, lp, 60, h))
        derivative_plus = h * total([
            t[r, s] * kron(plus[r], plus[s], eye(5))
            for r in range(3) for s in range(3) if t[r, s] != 0
        ], 80) * h / 2
        ud.append(h * total([
            t[r, s] * kron(minus[r], minus[s], eye(5))
            for r in range(3) for s in range(3) if t[r, s] != 0
        ], 80) * h / 2)
        bf_h = h * kron(eye(4), eye(4), bf(t)) * h
        equal(f"T{a}:B_F-compression", pg*kron(eye(4), bf(t))*pg, qg[a])
        equal(f"T{a}:combined-curvature", derivative_plus + 2*bf_h, 3*qt[a])
        equal(f"T{a}:trace-curvature", R(5, 2)*qt[a]*trace_adjoint,
              trace_adjoint*bf(t))
        equal(f"U{a}:total-minus-action", ud[a], weighted_action(t, lm, 4, h))
        equal(f"U{a}:minus-zero", ud[a]*(h-pm), zero(80))
        for name, proj in [("Y", py), ("30", p30), ("21", p21), ("20", p20)]:
            equal(f"T{a}:{name}-preserved", qt[a]*proj, proj*qt[a])
            equal(f"U{a}:{name}-preserved", ud[a]*proj, proj*ud[a])
        product_coefficients(f"T{a}:weighted-real-projection", pp*qt[a]*pp, qg[a]/2)
    product_coefficients("norm-real-projection", pp, R(7, 12)*pg)

    # These are coefficient identities, not test matrices for unknown T or U.
    for axis in range(3):
        for a, t in enumerate(f_basis):
            rotated = coordinates(rotations[axis]*t - t*rotations[axis])
            q_rotated = total([rotated[b]*qg[b] for b in range(5)], 20)
            u_rotated = total([rotated[b]*ud[b] for b in range(5)], 80)
            equal(f"G:covariance:{axis}:{a}",
                  inner_plus[axis]*qg[a]-qg[a]*inner_plus[axis], q_rotated)
            equal(f"U:covariance:{axis}:{a}",
                  lm[axis]*ud[a]-ud[a]*lm[axis], u_rotated)

    d_high = [-pp*g*g*pp for g in lp]
    equal("high-plus:sum-squares", total(d_high, 80), 48*pp)
    for axis in range(3):
        equal(f"high-plus:Gram:{axis}", w80*d_high[axis],
              (lp[axis]*pp).T*w80*(lp[axis]*pp))
    minus_axes = [py*(eye(80)+g*g/4)*py for g in lm]
    for axis, proj in enumerate(minus_axes):
        ranks[f"minus_axis_{axis}"] = projector(f"minus-axis:{axis}", proj, w80)
        if ranks[f"minus_axis_{axis}"] != 7:
            raise AssertionError("A minus-axis eigenspace has incorrect dimension")
        for other in range(axis):
            equal(f"minus-axes:{axis}:{other}", proj*minus_axes[other], zero(80))
    equal("minus-axes:sum", total(minus_axes, 80), py)
    for a in range(2):
        equal(f"U{a}:diagonal-spectral-resolution", ud[a]*py,
              total([f_basis[a][s, s]*minus_axes[s] for s in range(3)], 80))

    for axis, g in enumerate(inner_plus):
        d = -pg*g*g*pg
        eigenspaces = [
            (d-9*pg)*(d-25*pg)/192,
            -(d-pg)*(d-25*pg)/128,
            (d-pg)*(d-9*pg)/384,
        ]
        for eigenvalue, proj in zip([1, 9, 25], eigenspaces):
            rank = projector(f"G:axis{axis}:square{eigenvalue}", proj, w20)
            if rank != 4:
                raise AssertionError("Incorrect half-integer weight multiplicity")
            equal(f"G:axis{axis}:eigenvalue{eigenvalue}", d*proj, eigenvalue*proj)
        equal(f"G:axis{axis}:spectral-sum", total(eigenspaces, 20), pg)
        equal(f"G:axis{axis}:positive-square-slack", d-pg,
              8*eigenspaces[1]+24*eigenspaces[2])
    d_inner = [-pg*g*g*pg for g in inner_plus]
    equal("Q5:sharp-x-coefficient", R(4, 5)*pg,
          total([d-pg for d in d_inner], 20)/40)
    for a in range(2):
        equal(f"Q5:sharp-T{a}-coefficient", -qg[a],
              total([f_basis[a][s, s]*(d_inner[s]-pg) for s in range(3)], 20)/40)

    def gap_identity(label, curvature_plus, curvature_minus, scalar, y):
        a = (scalar+y)*pp - R(5, 2)*pp*curvature_plus*pp
        p = scalar*h - R(5, 2)*curvature_plus - curvature_minus
        equal(label, a-py*p*py,
              p30*a*p30 + py*(curvature_minus+y*h)*py)

    gap_identity("cost-gap:constant", zero(80), zero(80), 4, 0)
    gap_identity("cost-gap:y", zero(80), zero(80), 0, 1)
    for a in range(5):
        gap_identity(f"cost-gap:T{a}", qt[a], zero(80), 0, 0)
        gap_identity(f"cost-gap:U{a}", zero(80), ud[a], 0, 0)
    equal("A:Gram-x-coefficient", 2*pp, total(d_high, 80)/24)
    for a, t in enumerate(f_basis):
        gram_coefficient = -pp * total([
            t[r, s]*lp[r]*lp[s] for r in range(3) for s in range(3)
            if t[r, s] != 0
        ], 80) * pp
        equal(f"A:Gram-T{a}-coefficient", -R(5, 2)*pp*qt[a]*pp,
              gram_coefficient/24)

    x, y, energy, b_form = sp.symbols("x y e B")
    bracket = R(7, 12)*(4+y)*energy - R(5, 4)*b_form
    sharp_decomposition = (
        (R(1, 3)+R(19, 12)*y+2-x-y)*energy
        + R(5, 4)*(R(4, 5)*x*energy-b_form)
    )
    if sp.expand(bracket-sharp_decomposition) != 0:
        raise AssertionError("Incorrect scalar bracket decomposition")
    if R(6, 24)*R(3, 4)**2 != R(9, 64):
        raise AssertionError("Incorrect weight cost scaling")
    checks.extend(["bracket:sharp-closed-cone-decomposition", "weight:9/64"])

    t_extreme = -2*f_basis[1]
    q_extreme = -2*qg[1]
    qh_extreme = -2*qt[1]
    z = parameter_map[:, 0]
    e = (z.T*w20*z)[0]/6
    b = (z.T*w20*q_extreme*z)[0]/6
    if e <= 0 or sp.simplify(b/e) != R(8, 5):
        raise AssertionError("Sharp bound witness is invalid")
    equal("sharp-witness:Bianchi", bianchi*z, zero(12, 1))
    sharp_ratio = sp.simplify((R(7, 3)*e-R(5, 4)*b)/e)
    if sharp_ratio != R(1, 3):
        raise AssertionError("The bracket sharpness witness does not attain 1/3")
    equal("boundary:x2-y0:A-is-axis-square",
          4*pp-R(5, 2)*pp*qh_extreme*pp, d_high[2]/4)
    d = d_high[2]
    axis_zero = -(d-4*pp)*(d-16*pp)*(d-36*pp)/2304
    ranks["boundary_high_plus_kernel"] = projector("boundary:high-plus-zero", axis_zero, w80)
    ranks["boundary_Y_kernel"] = projector("boundary:Y-zero", py*axis_zero, w80)
    equal("boundary:x2-y0:zero", (4*h-R(5, 2)*qh_extreme)*py*axis_zero, zero(80))
    equal("boundary:x0-y2:zero", (4*h+2*ud[1])*minus_axes[2], zero(80))
    mixed_zero = axis_zero*minus_axes[2]
    ranks["boundary_x1_y1_kernel"] = projector("boundary:mixed-zero", mixed_zero, w80)
    equal("boundary:x1-y1:zero", (4*h+R(5, 2)*qt[1]+ud[1])*mixed_zero, zero(80))
    if [ranks["boundary_high_plus_kernel"], ranks["boundary_Y_kernel"],
        ranks["boundary_x1_y1_kernel"]] != [4, 3, 1]:
        raise AssertionError("Boundary equality spaces have incorrect dimensions")

    embed_a = sp.SparseMatrix.vstack(eye(20), zero(60, 20))
    z_equal = z
    product = embed_a*z_equal
    equal("cost-equality:Bianchi", bianchi*z_equal, zero(12, 1))
    equal("cost-equality:discarded-minus-zero", p30*product, zero(80, 1))
    a_operator = 4*pp-R(5, 2)*pp*qh_extreme*pp
    p_operator = 4*h-R(5, 2)*qh_extreme
    gap = (product.T*w80*(a_operator-py*p_operator*py)*product)[0]
    if gap != 0 or (z_equal.T*w20*z_equal)[0] <= 0:
        raise AssertionError("Cost equality witness is invalid")
    z_matrices = [
        total([z_equal[5*d+a]*f_basis[a] for a in range(5)], 3)
        for d in range(4)
    ]
    norm_gradient = sp.Matrix([sp.trace(t_extreme*t)/12 for t in z_matrices])
    equal("weight-witness:norm-gradient", norm_gradient, -v_basis[0])
    m_root = R(1, 4)
    m = m_root**2
    dm = -R(3, 4)*m_root*norm_gradient
    projected_weight = py*kron(dm, z_equal)
    lhs = (projected_weight.T*w80*p_operator*projected_weight)[0]/(24*m)
    rhs = R(9, 64)*(norm_gradient.T*norm_gradient)[0]*(R(7, 3)*e-R(5, 4)*b)
    if lhs != rhs or lhs != R(5, 64):
        raise AssertionError("The exact equation-(14) equality witness is invalid")
    checks.append("weight-witness:equation-14-equality")

    return {
        "result": "universal_exact_algebraic_verification",
        "scope": "Real Bianchi gradients; not a global Einstein classification or a novelty certification.",
        "arithmetic": "Exact rational matrix coefficients; no floating point or numerical sampling.",
        "tensor_order": ["outer real derivative (4)", "inner real derivative (4)", "F coordinates (5)"],
        "F_basis": [[[str(value) for value in row] for row in f.tolist()] for f in f_basis],
        "F_metric_diagonal": [2, 6, 2, 2, 2],
        "I_matrices": [m.tolist() for m in plus],
        "J_matrices": [m.tolist() for m in minus],
        "bianchi_rank": 8,
        "projector_ranks": ranks,
        "universal_projection_coefficients": {"norm": "7/12", "curvature": "1/2"},
        "cost_coefficients": {"weight": "9/64", "B": "-5/4"},
        "positivity_certificate": {
            "domain": "x=-lambda_min(T)>=0, y=-lambda_min(U)>=0, x+y<=2",
            "A_slack": "A=(2*(2-x-y)+3*y)Id+(1/24)sum_(r,s)(T+xId)_rs K_r^* K_s on P_plus",
            "minus_slack": "U_D+yId=sum_s(u_s+y)E_s on Y after minus rotation; E_s are orthogonal projectors",
            "P_slack": "P=2*(2-x-y)Id+(1/24)sum_(r,s)(T+xId)_rs K_r^* K_s+sum_s(2*y-u_s)E_s on Y",
            "cost_gap": "<A r,r>+<(U_D+yId)w,w>, r=P_(3,0)(a tensor Z), w=P_Y(a tensor Z)",
            "Q5_sharp_bound": "Q_(5/2)(T)<=4*x/5",
            "Q5_slack": "(4*x/5)Id-Q5(T)=(1/40)sum_s(t_s+x)(D_s-Id); D_s-Id=8E_9+24E_25",
            "bracket_slack": "(1/3+19*y/12+(2-x-y))*e+(5/4)*((4*x/5)*e-B)",
            "boundary_divisions": "None. Only fixed positive rational denominators and the positive weight M are used.",
        },
        "sharp_bracket_witness": {
            "T": t_extreme.tolist(), "U": sp.zeros(3).tolist(),
            "x": "2", "y": "0", "Z_coordinates": [str(v) for v in z],
            "e": str(e), "B": str(b), "bracket_over_e": str(sharp_ratio),
        },
        "algebraic_cost_equality_witness": {
            "a": [1, 0, 0, 0], "T": t_extreme.tolist(),
            "U": sp.zeros(3).tolist(), "Z_coordinates": [str(v) for v in z_equal],
            "exact_unscaled_cost_gap": str(gap),
            "scope": "Equality for arbitrary-a algebraic cost, not a claim of realizability by geometric weight gradients.",
        },
        "equation_14_equality_witness": {
            "p": [str(v) for v in norm_gradient], "q": [0, 0, 0, 0],
            "v": "2", "b": "0", "M": str(m_root), "m": str(m),
            "dm": [str(v) for v in dm], "left_side": str(lhs), "right_side": str(rhs),
            "scope": "Algebraic gradient contraction and weight substitution only; no global metric or sec-preserving curvature first jet is asserted.",
        },
        "zero_residual_count": len(checks),
        "zero_residual_checks": checks,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = reconstruct()
    certificate = Path(__file__).with_name("exact_certificate.json")
    encoded = json.dumps(actual, indent=2, sort_keys=True, default=str) + "\n"
    if args.write_certificate:
        certificate.write_text(encoded)
    else:
        expected = json.loads(certificate.read_text())
        if json.loads(encoded) != expected:
            raise AssertionError("Reconstructed evidence differs from exact_certificate.json")
    print(f"PASS: {actual['zero_residual_count']} exact residual checks; "
          "universal projections, closed-cone cost, sharp bracket >= (1/3+19y/12)e.")


if __name__ == "__main__":
    main()
