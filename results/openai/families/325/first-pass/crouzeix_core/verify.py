#!/usr/bin/env python3
"""Replay exact algebraic certificates; finite examples are not the uniform proof."""

import argparse
import itertools
import json
from pathlib import Path

import sympy as s

ROOT = Path(__file__).resolve().parent
Q = s.Rational


def zero(value):
    if isinstance(value, s.MatrixBase):
        return all(s.simplify(x) == 0 for x in value)
    return s.simplify(value) == 0


def hs2(matrix):
    return s.simplify(s.trace(matrix.H * matrix))


def pair(left, right):
    assert left.shape == right.shape
    return s.simplify(sum(left[i, j] * right[i, j]
                          for i in range(left.rows) for j in range(left.cols)))


def tensor_vector(matrix):
    return s.Matrix([matrix[i, j]
                     for i in range(matrix.rows) for j in range(matrix.cols)])


def psd(matrix):
    assert zero(matrix - matrix.H)
    count = 0
    for size in range(1, matrix.rows + 1):
        for indices in itertools.combinations(range(matrix.rows), size):
            minor = s.simplify(matrix.extract(indices, indices).det())
            assert minor.is_nonnegative is True, (indices, minor)
            count += 1
    return count


def rotation(m):
    u = s.eye(m)
    u[0, 0] = u[m - 1, m - 1] = Q(3, 5)
    u[0, m - 1] = -Q(4, 5)
    u[m - 1, 0] = Q(4, 5)
    assert zero(u.H * u - s.eye(m))
    return u


def disk_case(n, m, constant_term=False):
    a = s.zeros(n)
    a[0, 1] = Q(3, 2)
    u = rotation(m)
    e = s.zeros(m)
    e[m - 1, m - 1] = 1
    if constant_term:
        f0 = u / 2
        f1 = u / 2
        v = s.zeros(m, 1)
        v[0], v[m - 1] = Q(3, 5), Q(4, 5)
        xb, yb = s.zeros(n, 1), s.zeros(n, 1)
        xb[0], xb[1] = 1 / s.sqrt(5), 2 / s.sqrt(5)
        yb[0], yb[1] = 2 / s.sqrt(5), 1 / s.sqrt(5)
        gamma = s.Integer(1)
    else:
        f0, f1 = u * (s.eye(m) - e), u * e
        v = s.eye(m)[:, m - 1]
        xb, yb = s.eye(n)[:, 1], s.eye(n)[:, 0]
        gamma = Q(3, 2)
    xmat, ymat = xb * v.T, yb * (u * v).T
    x, y = tensor_vector(xmat), tensor_vector(ymat)
    fa = s.kronecker_product(s.eye(n), f0) + s.kronecker_product(a, f1)
    assert zero((x.H * x)[0] - 1) and zero((y.H * y)[0] - 1)
    assert zero(fa * x - gamma * y)
    assert zero(fa.H * y - gamma * x)
    top_norm_minors = psd(gamma ** 2 * s.eye(n * m) - fa.H * fa)
    if not constant_term:
        assert not zero(f0 * f1 - f1 * f0)
    c0 = s.Matrix(m, m, lambda i, j: Q(2 * i - j + 1, 7) + s.I * Q(i + 2 * j, 11))
    c1 = s.Matrix(m, m, lambda i, j: Q(i + j + 1, 13) - s.I * Q(3 * i - j, 17))
    ga = s.kronecker_product(s.eye(n), c0) + s.kronecker_product(a, c1)
    product = [f0 * c0, f0 * c1 + f1 * c0, f1 * c1]
    reverse = [c0 * f0, c0 * f1 + c1 * f0, c1 * f1]
    eval_product = sum((s.kronecker_product(a ** k, c)
                        for k, c in enumerate(product)), s.zeros(n * m))
    eval_reverse = sum((s.kronecker_product(a ** k, c)
                        for k, c in enumerate(reverse)), s.zeros(n * m))
    assert zero(eval_product - fa * ga)
    assert zero(eval_reverse - ga * fa)
    assert zero((y.H * eval_product * x)[0] - gamma * (x.H * ga * x)[0])
    assert zero((y.H * eval_reverse * x)[0] - gamma * (y.H * ga * y)[0])
    mk = [ymat.H * (a ** k) * xmat for k in range(2)]
    pk = [xmat.H * (a ** k) * xmat for k in range(2)]
    qk = [ymat.H * (a ** k) * ymat for k in range(2)]
    lk = [xmat.H * (a ** k) * ymat for k in range(2)]
    actual_pair = (y.H * ga * x)[0]
    assert zero(actual_pair - pair(mk[0], c0) - pair(mk[1], c1))
    wrong_transpose = pair(mk[0].T, c0) + pair(mk[1].T, c1)
    wrong_adjoint = pair(mk[0].H, c0) + pair(mk[1].H, c1)
    a2 = sum(hs2(c) for c in mk)
    dp = hs2(pk[0]) + hs2(pk[1]) / 2
    dq = hs2(qk[0]) + hs2(qk[1]) / 2
    assert s.simplify(a2 - gamma ** 2 * dp).is_nonnegative is True
    assert s.simplify(a2 - gamma ** 2 * dq).is_nonnegative is True
    diagp, diagq = 4 * dp, 4 * dq
    cross = 4 * hs2(mk[0]) + hs2(mk[1]) + hs2(lk[1])
    assert s.simplify(cross - a2).is_nonnegative is True
    assert s.simplify(diagp + diagq - 2 * cross).is_nonnegative is True
    lam = Q(3, 5) + s.I * Q(4, 5)
    b = lam * s.eye(n) - a
    r = lam * b.inv()
    rh = r + r.H
    assert zero(b.H * rh * b - (s.conjugate(lam) * b + lam * b.H))
    resolvent_minors = psd(rh)
    compression = xmat.row_join(ymat)
    delta = s.simplify(compression.H * rh * compression)
    block_minors = psd(delta)
    p, q = xmat.H * rh * xmat, ymat.H * rh * ymat
    z = ymat.H * rh * xmat
    assert s.simplify(hs2(p) + hs2(q) - 2 * hs2(z)).is_nonnegative is True
    return {
        "n": n, "m": m, "gamma": str(gamma),
        "domain": "unit disk",
        "numerical_radius": "3/4 < 1 (one 2-by-2 nilpotent block and zeros)",
        "boundary_contractivity": (
            "F=(1+z)U/2; triangle inequality" if constant_term
            else "F=U(I-E+zE) is unitary on the circle"),
        "noncommuting_F_coefficients": not zero(f0 * f1 - f1 * f0),
        "nonzero_constant_cross_coefficient": not zero(mk[0]),
        "transpose_shortcut_rejected": not zero(actual_pair - wrong_transpose),
        "adjoint_shortcut_rejected": not zero(actual_pair - wrong_adjoint),
        "a_squared": str(a2), "p_dual": str(dp), "q_dual": str(dq),
        "cross_L2": str(s.simplify(cross)),
        "diagonal_L2_sum": str(s.simplify(diagp + diagq)),
        "exact_nonnegative_principal_minors": {
            "top_singular_value": top_norm_minors,
            "positive_resolvent": resolvent_minors,
            "positive_compression": block_minors,
        },
    }


def weighted_test():
    z, t = s.symbols("z t", real=True)
    x, y = s.symbols("x y", real=True)
    w, v = s.symbols("w v", positive=True)
    p = [z + s.I * t, x + s.I * y]
    weights = [w, v]
    c = [s.conjugate(a) / b for a, b in zip(p, weights)]
    d = sum(s.expand(s.conjugate(a) * a) / b for a, b in zip(p, weights))
    paired = sum(a * b for a, b in zip(p, c))
    energy = sum(a * s.conjugate(b) * b for a, b in zip(weights, c))
    assert zero(paired - d) and zero(energy - d)
    return {
        "pairing_residual": "0", "weighted_test_energy_residual": "0",
        "test": "entrywise conjugate(p_i)/w_i, not transpose or adjoint",
        "weights": "arbitrary positive real weights",
    }


def nonsymmetric_exterior():
    u, v = s.symbols("u v", nonzero=True)
    a = s.symbols("a", real=True)
    h = 1 - a * (u * v ** 2 + u ** 2 * v)
    numer = a * (u * v ** 2 + 2 * u ** 2 * v)
    correction = -u * s.diff(h, u) / h
    assert zero(correction - numer / h)
    conjugate = lambda f: f.subs({u: 1 / u, v: 1 / v}, simultaneous=True)
    kernel_numerator = s.expand(h * conjugate(h) + numer * conjugate(h)
                                + conjugate(numer) * h)
    target = (1 + a * (u ** 2 * v + 1 / (u ** 2 * v))
              - 4 * a ** 2 - 2 * a ** 2 * (u / v + v / u))
    assert zero(kernel_numerator - target)
    coef12 = s.diff(correction, u, 1, v, 2).subs({u: 0, v: 0}) / 2
    coef21 = s.diff(correction, u, 2, v, 1).subs({u: 0, v: 0}) / 2
    assert zero(coef12 - a) and zero(coef21 - 2 * a)
    aval, radius = Q(1, 32), Q(3, 4)
    lower = 1 - 2 * aval - 8 * aval ** 2
    collar_ratio = 2 * aval / radius ** 3
    assert lower > 0 and collar_ratio < 1
    return {
        "map": "h(lambda)=lambda+(1/32)lambda^(-2)",
        "collar_radius": str(radius),
        "divided_difference_error_bound": str(collar_ratio),
        "kernel_numerator_identity_residual": "0",
        "kernel_numerator_uniform_lower_bound": str(lower),
        "curvature_numerator_uniform_lower_bound": str(lower),
        "s_1_2": str(aval), "s_2_1": str(2 * aval),
        "symmetry_not_assumed": True,
        "unit_marginals": "all correction monomials have strictly mixed nonzero frequencies",
        "scope": "exact symbolic identities and bounds; geometric applicability proved in REPORT.md",
    }


def infinite_tail():
    r = s.symbols("r", real=True, nonnegative=True)
    N = s.symbols("N", integer=True, nonnegative=True)
    a2 = 1 + 4 * r ** 2 / (1 - r ** 2)
    dual = 1 + 2 * r ** 2 / (1 - r ** 2)
    field = 4 + 8 * r ** 2 / (1 - r ** 2)
    partial = 1 + 2 * r ** 2 * (1 - r ** (2 * N)) / (1 - r ** 2)
    tail = 2 * r ** (2 * N + 2) / (1 - r ** 2)
    assert zero(dual - partial - tail)
    assert zero(field - 4 * dual)
    assert zero(field - (4 + 8 * r ** 2 / (1 - r ** 2)))
    assert zero(a2 - dual - 2 * r ** 2 / (1 - r ** 2))
    return {
        "map": "h(lambda)=lambda+r/lambda, 0<r<1; A=0; F=1; x=y",
        "resolvent": "(1-r/lambda^2)/(1+r/lambda^2)",
        "coefficients": "R_0=1; R_(2k)=2(-r)^k (k>=1); odd coefficients zero",
        "a_squared": str(a2), "dual_energy": str(dual),
        "diagonal_and_cross_energy": str(field),
        "dual_tail_after_even_index_2N": str(tail),
        "tail_identity_residual": "0",
        "tail_tends_to_zero": "geometric for every fixed 0<r<1; no finite truncation assumption",
    }


def jacobian_replay():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    receipt = json.loads((ROOT / "jacobian_result.json").read_text())
    operation = "matrix.symmetric.rational_spectrum_claim.check"
    assert receipt["request"]["operation_id"] == operation
    assert receipt["request"]["payload"] == payload
    assert receipt["result"]["operation_id"] == operation
    out = receipt["result"]["output"]
    assert out["outcome"] == "VALID" and out["valid_complete_rational_spectrum"]
    entries = out["matrix"]["entries"]
    d = s.Matrix([[Q(x["num"], x["den"]) for x in row] for row in entries])
    assert d.eigenvals() == {s.Integer(0): 2, s.Integer(2): 2}
    u, v, z = d[:2, :2], d[2:, 2:], d[2:, :2]
    assert zero(hs2(u) + hs2(v) - 2 * hs2(z))
    w = s.Matrix([[Q(3, 5), -Q(4, 5)], [Q(4, 5), Q(3, 5)]])
    gram = s.eye(2).row_join(w.T)
    assert zero(d - gram.T * gram)
    return {
        "operation_id": operation, "server_version": receipt["server"]["version"],
        "protocol_version": receipt["protocol_version"], "transport": receipt["transport"],
        "adapter_status": "success", "adapter_exit_code": 0,
        "timeout_or_unknown": False, "spectrum": {"0": 2, "2": 2},
        "positive_block_comparison_slack": "0",
        "mismatch": "bounded symmetric QQ spectrum only; not a complex parameter-uniform or infinite-tail proof",
    }


def certificate():
    cases = [disk_case(3, 2), disk_case(2, 3), disk_case(2, 2, True)]
    assert any(c["transpose_shortcut_rejected"] for c in cases)
    assert any(c["adjoint_shortcut_rejected"] for c in cases)
    assert any(c["nonzero_constant_cross_coefficient"] for c in cases)
    assert any(c["noncommuting_F_coefficients"] for c in cases)
    return {
        "claim_id": "V_DIRECT_CORE",
        "result": "independent parameter-uniform verification theorem, with explicit analytic premises",
        "not_a_refutation": True,
        "not_a_finite_search_proof": True,
        "independent_review": "pending Host-invoked Reviewer",
        "novelty": "not established; do not infer a new unconditional proof of the complete conjecture",
        "uniform_proof": {
            "source": "Main.lean", "reading": "statement_fidelity.md",
            "main_declaration": "CrouzeixCore.ordered_coefficient_positive_block",
            "generalization": "arbitrary positive coefficient-tail weight beta gives gamma^2 <= max(4,2 beta)",
            "analytic_boundary": [
                "coefficient sandwich and boundary multiplier inequalities",
                "positive resolvent Fourier representation and its constant terms",
                "convergence of all coefficient energy partial sums and Parseval identities",
            ],
        },
        "weighted_duality_identity": weighted_test(),
        "full_hypothesis_exact_disk_examples": cases,
        "nonsymmetric_exterior_kernel": nonsymmetric_exterior(),
        "genuinely_infinite_tail": infinite_tail(),
        "jacobian": jacobian_replay(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="write the exact replay output")
    args = parser.parse_args()
    result = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        assert json.loads(path.read_text()) == result, "certificate differs from exact recomputation"
    print(json.dumps({
        "status": "exact replay passed", "claim": result["claim_id"],
        "full_hypothesis_disk_examples": len(result["full_hypothesis_exact_disk_examples"]),
        "symbolic_weighted_duality": True, "nonsymmetric_kernel": True,
        "infinite_tail_identity": True, "jacobian_replayed_exactly": True,
        "uniform_theorem": "Main.lean (separate real compiler receipt required)",
        "independent_review": "pending",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
