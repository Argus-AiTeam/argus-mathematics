#!/usr/bin/env python3
"""Replay the exact algebra supporting report.md; no floating-point tests."""

import argparse
import json
from fractions import Fraction
from math import comb, prod
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
MANUSCRIPT = (
    ROOT
    / "research/openai_manuscript"
    / "Generic-Future-Inextendibility-with-Square-Integrable-Connection-Near-a-Fixed-Kerr-Spacetime-September-23-2026"
    / "build/sections"
)
OPERATION = "matrix.rational_linear_system.solve"


def zero_matrix(matrix):
    assert all(sp.cancel(entry) == 0 for entry in matrix), matrix


def exact_rational(value):
    result = Fraction(int(value["num"]), int(value["den"]))
    assert value == {"num": str(result.numerator), "den": str(result.denominator)}
    return result


def source_anchors():
    anchors = []
    labels = {
        "holonomy_category.tex": [
            "ho:base-comparison",
            "ho:loop-jets",
            "prop:averaged-holonomy",
            "ho:density-only",
            "ho:frame-ode",
            "ho:stop-improvement",
            "ho:coefficient-estimate",
            "thm:nowhere-dense",
        ],
        "weak_exits.tex": [
            "ex:homotopy",
            "ex:graph",
            "ex:boxes",
            "ex:momentum-jacobian",
            "ex:section-volume",
            "prop:exit-family",
        ],
    }
    for filename, names in labels.items():
        path = MANUSCRIPT / filename
        lines = path.read_text().splitlines()
        for label in names:
            literal = "\\label{" + label + "}"
            hits = [i + 1 for i, line in enumerate(lines) if literal in line]
            assert len(hits) == 1, (filename, label, hits)
            anchors.append(
                {"file": str(path.relative_to(ROOT)), "label": label, "line": hits[0]}
            )
    text = (MANUSCRIPT / "holonomy_category.tex").read_text()
    for literal in (
        r"\nu_T(\mathcal N_T)\le C e^{-\kappa T/16}",
        r"M'=M\mathsf A-\widetilde\Gamma_c(Mf)M.",
        r"=C e^{-13\kappa T/32}+Q_Te^{-\kappa T}.",
    ):
        assert literal in text, literal
    return anchors


def interpolation():
    order = 18
    n = order - 1
    harmonic = sum((Fraction(1, k) for k in range(1, n + 1)), Fraction())
    weights = [
        sum(
            (Fraction(1, i * j) for i in range(1, n + 1) for j in range(i + 1, n + 1)),
            Fraction(),
        )
    ]
    weights.extend(
        (-1) ** j * comb(n, j) * (harmonic - Fraction(1, j)) / j
        for j in range(1, n + 1)
    )
    moments = [
        sum((weights[j] * j**k for j in range(order)), Fraction())
        for k in range(order)
    ]
    assert moments == [Fraction(int(k == 2)) for k in range(order)]
    determinant = prod(j - i for i in range(order) for j in range(i + 1, order))
    assert determinant > 0

    payload = json.loads((HERE / "jacobian_linear_payload.json").read_text())
    envelope = json.loads((HERE / "jacobian_linear_output.json").read_text())
    contract = json.loads((HERE / "jacobian_linear_contract.json").read_text())
    discovery = json.loads((HERE / "jacobian_linear_discovery.json").read_text())
    status = json.loads((HERE / "jacobian_linear_status.json").read_text())
    assert status["operation_id"] == OPERATION
    assert status["adapter_exit_code"] == 0 and not status["timeout_observed"]
    assert envelope["request"] == {"operation_id": OPERATION, "payload": payload}
    assert envelope["result"]["operation_id"] == OPERATION
    assert contract["result"]["operation"]["operation_id"] == OPERATION
    for other in (contract, discovery):
        assert other["server"] == envelope["server"]
        assert other["protocol_version"] == envelope["protocol_version"]
    output = envelope["result"]["output"]
    assert output["convention"] == "LINEAR_SYSTEM_CLASSIFICATION_OVER_QQ"
    assert output["outcome"] == "UNIQUE"
    entries = [
        [exact_rational(entry) for entry in row]
        for row in payload["matrix"]["entries"]
    ]
    assert entries == [[Fraction(j**k) for j in range(order)] for k in range(order)]
    assert output["matrix"]["entries"] == payload["matrix"]["entries"]
    assert output["rhs"] == payload["rhs"]
    assert [exact_rational(entry) for entry in payload["rhs"]] == moments
    assert [exact_rational(entry) for entry in output["solution"]] == weights
    return {
        "order": order,
        "nodes": list(range(order)),
        "quadratic_weights": [str(weight) for weight in weights],
        "moment_vector": [str(moment) for moment in moments],
        "vandermonde_determinant": str(determinant),
        "jacobian": {
            "operation_id": OPERATION,
            "server_version": envelope["server"]["version"],
            "protocol_version": envelope["protocol_version"],
            "transport": envelope["transport"],
            "outcome": output["outcome"],
            "adapter_exit_code": status["adapter_exit_code"],
            "timeout_observed": status["timeout_observed"],
            "payload": "jacobian_linear_payload.json",
            "typed_output": "jacobian_linear_output.json",
            "contract": "jacobian_linear_contract.json",
        },
    }


def exponent_identities():
    p, q, sigma = sp.symbols("p q sigma", positive=True)
    delta = (1 - sigma - 1 / p - sigma / q) / 3
    a, b = sigma / q + delta, 1 / p + delta
    for residual in (
        p * b - 1 - p * delta,
        1 - b - a - sigma - delta,
        q * a - sigma - q * delta,
        4 * p * q * (sp.Rational(3, 4) - 1 / p - 1 / (4 * q))
        - ((3 * p - 4) * q - p),
        4 * q / (3 * q - 1) - sp.Rational(4, 3) - 4 / (3 * (3 * q - 1)),
    ):
        assert sp.cancel(residual) == 0

    p0, a0, b0, sigma0 = map(
        Fraction, ("2", "1/16", "17/32", "1/4")
    )
    exponents = {
        "exception": p0 * b0 - 1,
        "curvature": 1 - b0 - a0,
        "remainder": 16 * a0,
        "stop": 1 + a0 - b0,
        "curvature_margin": 1 - b0 - a0 - sigma0,
        "remainder_margin": 16 * a0 - sigma0,
    }
    assert list(exponents.values()) == list(
        map(Fraction, ("1/16", "13/32", "1", "17/32", "5/32", "3/4"))
    )
    assert all(value > 0 for value in exponents.values())
    assert Fraction(4 * 16, 3 * 18 - 7) == Fraction(64, 47)
    assert Fraction(4 * 27, 3 * 29 - 7) == Fraction(27, 20)
    overlap = Fraction(95, 100) - Fraction(4, 100)
    assert overlap == Fraction(91, 100)
    assert overlap / 2 == Fraction(91, 200)
    return {
        "constructive_slack": "(1-sigma-1/p-sigma/q)/3",
        "witness_a": "sigma/q+delta",
        "witness_b": "1/p+delta",
        "slack_identities": ["p*b-1=p*delta", "1-b-a-sigma=delta", "q*a-sigma=q*delta"],
        "finite_order_criterion": "p>4*(N-2)/(3*N-7), N>=3",
        "some_finite_order_criterion": "p>4/3",
        "original_exponents": {name: str(value) for name, value in exponents.items()},
        "N18_threshold": "64/47",
        "N29_threshold": "27/20",
        "joint_good_slice_lower_bound": str(overlap),
        "joint_signal_measure_lower_bound": str(overlap / 2),
        "quantifier_proof": "Main.lean; exact identities here alone are not inequality proofs",
    }


def base_frame_and_density():
    eta = sp.diag(-1, 1, 1, 1)
    matrix = sp.Matrix([[1, 1, 0, 0], [0, 1, 0, 0], [0, 0, 2, 0], [0, 0, 0, 1]])
    uc = sp.Matrix([sp.Rational(5, 3), sp.Rational(4, 3), 0, 0])
    gram = matrix.T * eta * matrix
    uf = matrix.inv() * uc

    def positive_form(metric, tangent):
        covector = metric * tangent
        return metric + 2 * covector * covector.T

    assert (uc.T * eta * uc)[0] == -1
    assert (uf.T * gram * uf)[0] == -1
    kf, kc = positive_form(gram, uf), positive_form(eta, uc)
    zero_matrix(kf - matrix.T * kc * matrix)
    assert kf.det() == -gram.det() == 4
    assert all(kf[:i, :i].det() > 0 for i in range(1, 5))

    t = sp.symbols("t", positive=True)
    c, s = (t + 1 / t) / 2, (t - 1 / t) / 2
    boost = sp.Matrix([[c, s, 0, 0], [s, c, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]])
    zero_matrix(boost.T * eta * boost - eta)
    assert sp.cancel((boost * sp.eye(4)[:, 0])[0] - c) == 0

    u, v, x, y = sp.symbols("u v x y", real=True)
    r = sp.symbols("r", positive=True)
    phi = sp.Matrix([u, r * v, x + r * u * v, y])
    jacobian = phi.jacobian([u, v, x, y])
    gx = jacobian.T * eta * jacobian
    frame = sp.diag(1, 1 / r, 1, 1)
    gf = frame.T * gx * frame
    assert sp.factor(jacobian.det()) == r
    assert sp.factor(gx.det()) == -(r**2)
    assert sp.factor(gf.det()) == -1
    assert sp.cancel(gx.det() - r**2 * gf.det()) == 0
    return {
        "positive_form_determinant": "4=-det(G)",
        "positive_form_congruence_residual": "zero",
        "boost_family": "cosh=(t+1/t)/2; bounded Gram alone fails but chart unit tangent grows",
        "nonlinear_position_map": "(u,r*v,theta1+r*u*v,theta2)",
        "position_jacobian": "r",
        "coordinate_metric_determinant": "-r^2",
        "frame_metric_determinant": "-1",
        "scope": "exact structural identity checks; universal comparison proof is in report.md",
    }


def frame_ode():
    t = sp.symbols("t", real=True)
    identity = sp.eye(4)
    shear, internal = sp.zeros(4), sp.zeros(4)
    shear[0, 1], internal[1, 0] = 1, 1
    assert shear * internal != internal * shear
    f = t * (1 - t)
    matrix, inverse = identity + f * shear, identity - f * shear
    contracted_chart = (matrix * internal - matrix.diff(t)) * inverse
    pf = identity - t * internal
    pc = matrix * pf
    zero_matrix(matrix * inverse - identity)
    zero_matrix(matrix.diff(t) - matrix * internal + contracted_chart * matrix)
    zero_matrix(pc.diff(t) + contracted_chart * pc)
    zero_matrix(pf.diff(t) + internal * pf)
    zero_matrix(pc.subs(t, 0) - identity)
    zero_matrix(matrix.subs(t, 1) - identity)
    zero_matrix(pc.subs(t, 1) - pf.subs(t, 1))
    return {
        "frame_equation": "M'=M*A-B*M, B=Gamma(y')",
        "residual": "zero polynomial matrix for all t",
        "noncommuting_gauge": True,
        "closed_frame_endpoint_transport_residual": "zero",
    }


def phase_space():
    entries = sp.symbols("g00 g01 g02 g03 g11 g12 g13 g22 g23 g33", real=True)
    g00, g01, g02, g03, g11, g12, g13, g22, g23, g33 = entries
    metric = sp.Matrix(
        [[g00, g01, g02, g03], [g01, g11, g12, g13],
         [g02, g12, g22, g23], [g03, g13, g23, g33]]
    )
    slopes = sp.Matrix(sp.symbols("e1 e2 e3", real=True))
    velocity = sp.Matrix([1, *slopes])
    normalization = (-(velocity.T * metric * velocity)[0]) ** (-sp.Rational(1, 2))
    spatial = metric[1:, 1:]
    covector = metric[1:, 0] + spatial * slopes
    momenta = normalization * covector
    expected = normalization * spatial + normalization**3 * covector * covector.T
    zero_matrix(momenta.jacobian(slopes) - expected)

    time = sp.symbols("s", real=True)
    positions = sp.symbols("z1 z2 z3", real=True)
    momenta_symbols = sp.symbols("p1 p2 p3", real=True)
    h = sp.Function("h")(time, *positions, *momenta_symbols)
    divergence = sum(
        sp.diff(sp.diff(h, pi), z) - sp.diff(sp.diff(h, z), pi)
        for z, pi in zip(positions, momenta_symbols)
    )
    assert divergence == 0
    return {
        "general_symmetric_metric_slope_jacobian_residual": "zero",
        "reduced_hamiltonian_phase_divergence": "zero, assuming commuting mixed partials",
        "scope": "algebra only; phase flow domains and representative null sets require the analytic proof",
    }


def nonflat_oriented_loop():
    u, v, x, y = sp.symbols("u v x y", real=True)
    r = sp.symbols("r", positive=True)
    coordinates = (u, v, x, y)
    warp = 1 + v**2
    metric = sp.Matrix([[0, -r, 0, 0], [-r, 0, 0, 0],
                        [0, 0, warp**2, 0], [0, 0, 0, 1]])
    inverse = metric.inv()

    def connection(direction):
        return sp.Matrix(
            4, 4,
            lambda k, j: sp.cancel(
                sum(
                    inverse[k, h]
                    * (sp.diff(metric[h, j], coordinates[direction])
                       + sp.diff(metric[h, direction], coordinates[j])
                       - sp.diff(metric[direction, j], coordinates[h]))
                    / 2
                    for h in range(4)
                )
            ),
        )

    av, ax = connection(1), connection(2)
    curvature = av * ax - ax * av + ax.diff(v) - av.diff(x)
    frame = sp.diag(1, 1 / r, 1, 1)
    gram = frame.T * metric * frame
    a, b = frame.inv() * av * frame, frame.inv() * (r * ax) * frame
    avar, awar = a.diff(v), r * a.diff(x)
    bvar, bwar = b.diff(v), r * b.diff(x)
    identity, zero = sp.eye(4), sp.zeros(4)
    edges = (
        [identity, -a, (a * a - avar) / 2],
        [identity, -b, (b * b - bwar) / 2 - bvar],
        [identity, a, (a * a + avar) / 2 + awar],
        [identity, b, (b * b + bwar) / 2],
    )
    total = [identity, zero, zero]
    for edge in edges:
        total = [
            sum((edge[i] * total[k - i] for i in range(k + 1)), sp.zeros(4))
            for k in range(3)
        ]
    zero_matrix(total[1])
    zero_matrix(total[2] + bvar - awar + a * b - b * a)
    ev, ex = sp.eye(4)[:, 1], sp.eye(4)[:, 2]
    d11 = (ex.T * metric * curvature * ev)[0]
    pairing = (ex.T * gram * total[2] * ev)[0]
    assert sp.cancel(d11 - 2 * warp) == 0
    assert sp.cancel(pairing + d11) == 0
    return {
        "metric": "-2*r*du*dv+(1+v^2)^2*dtheta1^2+dtheta2^2",
        "curvature_convention": "R(V,W)=d_V Gamma_W-d_W Gamma_V+[Gamma_V,Gamma_W]",
        "positive_rectangle_quadratic_matrix": "-R(partial_v,r*partial_theta1) in F",
        "D11": "2*(1+v^2)",
        "quadratic_pairing": "-2*(1+v^2)",
        "uncancelled_r_factor": False,
        "vacuum_asserted": False,
    }


def build_certificate():
    return {
        "claim_coverage": ["C_LOOP_JETS", "C_AVERAGED_LP", "C_AVERAGED_L2",
                           "C_EXPONENTS", "C_EXIT_L1", "C_CATEGORY_LP"],
        "result_type": "exact algebraic support for the analytic implication theorems in report.md",
        "source_anchors": source_anchors(),
        "hypotheses": [
            "N>=3 fixed, finite p>=1, a>0, 1+a-b>0",
            "smooth four-dimensional observation metric, commuting scaled frame F",
            "uniform Gram/inverse bounds and subpower ordinary jets through N+1",
            "parameter measure dx dm, fixed bounded momentum box",
            "smooth injective open isometric embedding, continuous nondegenerate ambient metric",
            "at most B charts with metric, inverse and Lp connection bounds",
            "selected unit timelike tangents bounded in F and the admissible base chart",
            "weak and smooth Christoffel arrays agree almost everywhere on the open image",
            "category conclusion additionally assumes the explicit unverified companion packages",
        ],
        "interpolation": interpolation(),
        "exponents": exponent_identities(),
        "base_frame_and_density": base_frame_and_density(),
        "stopped_frame_ode": frame_ode(),
        "weak_exit_phase_space": phase_space(),
        "oriented_curvature_cancellation": nonflat_oriented_loop(),
        "coverage_limits": [
            "No finite computation proves the analytic and measure-theoretic steps.",
            "Universal exponent quantifiers are proved by Main.lean, not by sampled p or N.",
            "No full near-Kerr PDE, packet realization or MGHD attachment is certified.",
            "No counterexample was established; exponent infeasibility is only a method limitation.",
            "Independent Reviewer acceptance, significance and broader novelty remain outstanding.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = build_certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(actual, indent=2) + "\n")
        print("Wrote exact_certificate.json after all exact assertions passed.")
    else:
        expected = json.loads(path.read_text())
        assert actual == expected, "The retained certificate does not match exact replay."
        print("PASS: exact identities, 18 interpolation moments, typed Jacobian result, source anchors and original constants.")
        print("Analytic proofs, statement fidelity, novelty and independent acceptance are separate obligations.")


if __name__ == "__main__":
    main()
