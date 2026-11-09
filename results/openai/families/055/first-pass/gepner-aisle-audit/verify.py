#!/usr/bin/env python3
"""Replay the exact algebra behind the written quantitative verification theorem.

Requires SymPy. This does not decide categorical membership of numerical vectors.
"""

import argparse
import json
from pathlib import Path
import re

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = ROOT / "research/openai_manuscript/A-Gepner-stability-condition-on-every-smooth-quintic-threefold-September-24-2026/build/sections"
Q = sp.Rational
U = sp.Symbol("u", real=True)
POLY = 5 * U**2 - 5 * U + 1
UG = (5 - sp.sqrt(5)) / 10
ULO, UHI = Q(27, 100), Q(138197, 500000)
M = sp.Matrix([
    [-4, -Q(20, 3), -5, -5],
    [1, 1, 0, 0],
    [Q(1, 2), 1, 1, 0],
    [Q(1, 6), Q(1, 2), 1, 1],
])
N = sp.Matrix([[U, Q(1, 2), 1, 0]])
REAL = sp.Matrix([[-U / 2, -U - Q(1, 12), -Q(1, 2), -1]])


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def reduced(expression):
    numerator, denominator = sp.cancel(expression).as_numer_denom()
    require(not denominator.has(U), "Only polynomial reduction is admitted here")
    return sp.rem(numerator, POLY, U) / denominator


def zero_matrix(matrix):
    return all(sp.simplify(entry) == 0 for entry in matrix)


def affine_value(line, x):
    return line[0] * x + line[1]


F_LINES = [(Q(-3, 25), Q(0)), (Q(1, 2), Q(-7, 25)), (Q(28, 25), Q(-31, 50))]
G_PIECES = [
    (Q(0), Q(1, 4), (Q(-1, 2), Q(0))),
    (Q(1, 4), Q(5, 13), (Q(1, 2), Q(-1, 4))),
    (Q(5, 13), Q(6, 13), (Q(-3, 20), Q(0))),
    (Q(6, 13), Q(7, 13), (Q(1, 2), Q(-3, 10))),
    (Q(7, 13), Q(8, 13), (Q(23, 20), Q(-13, 20))),
    (Q(8, 13), Q(3, 4), (Q(1, 2), Q(-1, 4))),
    (Q(3, 4), Q(1), (Q(3, 2), Q(-1))),
]


def f(x):
    return max(affine_value(line, x) for line in F_LINES)


def g(x):
    values = [affine_value(line, x) for left, right, line in G_PIECES if left <= x <= right]
    require(bool(values) and len(set(values)) == 1, "Xu pieces must agree at endpoints")
    return values[0]


def envelope_cells():
    points = {endpoint for left, right, _ in G_PIECES for endpoint in (left, right)}
    for a, first in enumerate(F_LINES):
        for second in F_LINES[a + 1:]:
            crossing = (second[1] - first[1]) / (first[0] - second[0])
            if 0 <= crossing <= 1:
                points.add(crossing)
    points = sorted(points)
    cells = []
    for left, right in zip(points, points[1:]):
        midpoint = (left + right) / 2
        upper = max(F_LINES, key=lambda line: affine_value(line, midpoint))
        lower = next(line for a, b, line in G_PIECES if a < midpoint < b)
        margins = [affine_value(upper, endpoint) - affine_value(lower, endpoint)
                   for endpoint in (left, right)]
        require(min(margins) >= 0, "Xu bound is not below the manuscript envelope")
        cells.append({"interval": [str(left), str(right)], "minimum_margin": str(min(margins))})
    return cells


def maximum_strip(function, right, breakpoints):
    points = [Q(1, 2), right] + [x for x in breakpoints if Q(1, 2) < x < right]
    return max(function(x) - x / 2 for x in points)


def source_anchors():
    specifications = {
        "aisles.tex": {
            "labels": ["lem:second-tilt", "lem:compare-slope-cuts", "lem:twist-aisle", "prop:uniform-aisle"],
            "tokens": [
                r"-\frac{3x}{25}",
                r"\frac{x}{2}-\frac7{25}",
                r"\frac{28x}{25}-\frac{31}{50}",
                r"\delta=10^{-5}",
                r"s_0=\frac{553}{1000}",
                r"N_b^\eta=d-bc+ur+\eta_1c+\eta_0r",
                r"\alpha_1=\eta_1,\qquad\alpha_0=\eta_0-\eta_1",
                r"|\eta_0|,|\eta_1|<5\cdot10^{-6}",
                r"(\eta,\theta\in\Omega)",
            ],
        },
        "grid.tex": {
            "labels": [
                "prop:fine-grid", "lem:block-filtrations", "prop:block-support",
                "lem:block-hn", "lem:block-hom", "prop:slicing",
                "lem:phase-cuts", "lem:interval-quasiabelian", "prop:local-finiteness",
            ],
            "tokens": [
                r"D_3^\alpha\subset D_0^\beta[1]",
                r"k=2m+5j",
                r"\mathcal S_k=V_k\cap V_{k+1}^\perp",
                r"\mathcal P((c,c+1])",
                r"\mathcal P([c,c+1))",
            ],
        },
        "numerical.tex": {
            "labels": ["lem:numerical", "prop:central-charge"],
            "tokens": [
                r"u=\frac45\sin^2(\pi/5)=\frac{5-\sqrt5}{10}",
                r"\Z\times\Z\times\tfrac1{10}\Z\times\tfrac1{30}\Z",
                r"-4&-20/3&-5&-5\\1&1&0&0\\1/2&1&1&0\\1/6&1/2&1&1",
            ],
        },
    }
    anchors = {}
    for name, spec in specifications.items():
        text = (SOURCE / name).read_text()
        compact = re.sub(r"\s+", "", text)
        for token in spec["tokens"]:
            require(re.sub(r"\s+", "", token) in compact, f"Source formula changed: {name}: {token}")
        anchors[name] = {}
        for label in spec["labels"]:
            token = r"\label{" + label + "}"
            require(token in text, f"Missing source label {label}")
            anchors[name][label] = text[:text.index(token)].count("\n") + 1
    return anchors


def compiler_receipt():
    result = json.loads((HERE / "lean_result.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "The formal core has no successful compiler run")
    require(result["audit_exit_code"] == 0 and result["proof_holes"] == [],
            "The formal core failed its proof-hole audit")
    recorded = result["kernel"]["recorded"]
    require(recorded["tier"] == "mechanical" and recorded["verdict"] == "supports",
            "Missing mechanical support")
    require(recorded["subject"]["subject_id"] == "C55_CORE", "Wrong formal claim")
    archive_path = ROOT / recorded["artifact"]
    archive = json.loads(archive_path.read_text())
    require(archive["lean_check"]["exit_code"] == 0 and archive["lean_check"]["proof_holes"] == [],
            "Archived compiler certificate is not successful")
    require("4.31.0" in archive["lean_check"]["tools"]["lean"]["version"], "Wrong Lean version")
    require(archive["lean_source"]["text"] == (HERE / "Main.lean").read_text(),
            "Lean source changed after compilation")
    require(archive["statement_fidelity"]["text"] == (HERE / "statement_fidelity.md").read_text(),
            "Statement fidelity changed after compilation")
    require(Path(result["source"]).read_bytes() == (HERE / "Main.lean").read_bytes(),
            "Compiled source snapshot differs from the current source")
    require(Path(result["statement_fidelity"]).read_bytes() == (HERE / "statement_fidelity.md").read_bytes(),
            "Compiled fidelity snapshot differs from the current document")
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max((claim for claim in ledger["claims"] if claim["claim_id"] == "C55_CORE"),
                key=lambda claim: claim["version"])
    require(claim["content_hash"] == recorded["subject"]["content_hash"],
            "Compiler evidence belongs to a superseded claim")
    require(claim["formal_statement"] == (HERE / "Main.lean").read_text(),
            "The ledger's formal statement differs from the source")
    return {
        "claim_id": "C55_CORE",
        "certificate": recorded["artifact"],
        "lean_version": "4.31.0",
        "exit_code": 0,
        "axiom_audit_exit_code": 0,
        "proof_holes": [],
        "source_and_fidelity_match_compiled_snapshot": True,
        "claim_binding_is_current": True,
        "scope": "universal real algebra; not the categorical theorem",
    }


def verify():
    anchors = source_anchors()
    require(sp.simplify(POLY.subs(U, UG)) == 0, "Wrong Gepner quadratic")
    lower_sqrt = 5 - 10 * UHI
    upper_sqrt = 5 - 10 * ULO
    require(0 < lower_sqrt and lower_sqrt**2 < 5 < upper_sqrt**2, "Invalid exact enclosure")
    require(Q(1, 4) < ULO < UHI < Q(7, 25) < Q(3, 10), "Wrong rational parameter order")

    identity = sp.eye(4)
    require(M**5 == identity, "Numerical period is not five")
    z = sp.Symbol("z")
    require(M.charpoly(z).as_expr() == z**4 + z**3 + z**2 + z + 1, "Wrong characteristic polynomial")
    J = sp.Matrix([[0, Q(25, 6), 0, 5], [-Q(25, 6), 0, -5, 0],
                   [0, 5, 0, 0], [-5, 0, 0, 0]])
    require(J.det() == 625 and M.T * J * M == J, "Euler form mismatch")
    line_bundles = sp.Matrix([[1, k, Q(k**2, 2), Q(k**3, 6)] for k in range(4)])
    require(line_bundles.det() == 1, "Line-bundle classes do not span")

    cosine = 1 - Q(5, 2) * U
    t_squared = Q(3, 4) - U
    require(all(reduced(entry) == 0 for entry in REAL * M - cosine * REAL + 5 * U * t_squared * N),
            "Real eigencharge equation failed")
    require(all(reduced(entry) == 0 for entry in N * M - 5 * U * REAL - cosine * N),
            "Imaginary eigencharge equation failed")
    require(reduced(cosine**2 + 25 * U**2 * t_squared - 1) == 0, "Charge rotation is not unitary")
    require(Q(3, 4) - Q(7, 25) > Q(1, 4), "t0 > 1/2 bound failed")

    cells = envelope_cells()
    require(f(Q(1, 2)) == Q(-3, 100), "Wrong boundary envelope")
    require(all(affine_value(line, endpoint) <= 0
                for line in F_LINES for endpoint in (Q(0), Q(1, 2))),
            "The envelope is not nonpositive on the half strip")
    reflected_lines = {(-a, a + b) for a, b in F_LINES}
    shifted_lines = {(a - 1, b + Q(1, 2)) for a, b in F_LINES}
    require(reflected_lines == shifted_lines, "Envelope reflection identity failed")
    old_strip = maximum_strip(f, Q(553, 1000), [Q(14, 31), Q(17, 31)])
    require(old_strip == Q(-13857, 50000), "Wrong original strip supremum")
    old_delta = Q(1, 100000)
    old_margins = [
        Q(7, 25) - UHI - Q(3, 2) * old_delta,
        Q(13857, 50000) - UHI - (1 + Q(553, 1000)) * old_delta,
        Q(1, 2) - UHI / Q(553, 1000) - 3 * old_delta,
    ]
    require(old_margins == [Q(3591, 10**6), Q(73047, 10**8), Q(8941, 55300000)],
            "Original exact margins changed")

    s = Q(13, 23)
    delta = Q(1, 2000)
    threshold = Q(13, 46)
    xu_breakpoints = sorted({a for a, _, _ in G_PIECES} | {b for _, b, _ in G_PIECES})
    require(maximum_strip(g, s, xu_breakpoints) == -threshold, "Wrong improved strip supremum")
    new_margins = {
        "O_X": ULO - delta,
        "boundary": Q(3, 10) - UHI - Q(3, 2) * delta,
        "strip": threshold - UHI - (1 + s) * delta,
        "comparison": Q(1, 2) - UHI / s - 3 * delta,
    }
    require(min(new_margins.values()) > 0, "Extended square has no strict margins")
    require(20 * threshold + 13 * s == 13 and 2 * threshold == s, "Threshold witness failed")
    parameter, strip_endpoint = sp.symbols("parameter strip_endpoint")
    require(sp.expand((20 * parameter + 13 * strip_endpoint) +
                      13 * (2 * parameter - strip_endpoint) - 46 * parameter) == 0,
            "Threshold dual combination failed")

    r, c, d, eta0, eta1 = sp.symbols("r c d eta0 eta1")
    tensor_test = (d + c + r / 2) - (c + r) / 2 + U * r + eta1 * (c + r) + (eta0 - eta1) * r
    require(sp.expand(tensor_test - (d + c / 2 + U * r + eta1 * c + eta0 * r)) == 0,
            "Parameter shear has the wrong sign")
    require(2 * Q(1, 4000) == delta, "Widened square does not survive the shear")

    inverse = M.inv()
    a = 5 * U - 1
    circuit = N + a * N * inverse + a * N * inverse**2 + N * inverse**3
    require(all(reduced(entry) == 0 for entry in circuit), "Positive circuit failed")
    expected_circuit = -POLY * sp.Matrix([[3, Q(35, 6), 5, 10]])
    require(zero_matrix(circuit - expected_circuit), "Circuit residual is not the stated polynomial")
    coordinates = sp.Matrix.vstack(sp.Matrix([[1, 0, 0, 0], [0, 1, 0, 0]]), N, N * inverse)
    require(sp.simplify(coordinates.det()) == 5 * U, "Middle coordinates are not invertible")
    endpoint = sp.Matrix.vstack((M * coordinates.inv())[:2, :],
                               (inverse**2 * coordinates.inv())[:2, :])
    expected_endpoint = sp.Matrix([
        [5 * U - 4, -1 / U, -5 + 1 / U, -1 / U],
        [1, 1, 0, 0],
        [5 * U - 4, 5 - 3 / U, -5 + 3 / U, -3 / U],
        [3 - 5 * U, -4 + 2 / U, 5 - 2 / U, 2 / U],
    ])
    require(zero_matrix(endpoint - expected_endpoint), "Endpoint-coordinate identity failed")
    inverse_u = sp.Symbol("inverse_u")
    rectangular = expected_endpoint.subs(1 / U, inverse_u)
    row_bounds = sp.Matrix([[3, 4, 2, 4], [1, 1, 0, 0], [3, 7, 7, 12], [2, 4, 3, 8]])
    for i in range(4):
        for j in range(4):
            values = [abs(rectangular[i, j].subs({U: u, inverse_u: q}))
                      for u in (Q(1, 4), Q(3, 10)) for q in (Q(10, 3), Q(4))]
            require(max(values) <= row_bounds[i, j], "Endpoint absolute coefficient bound failed")
    column_bounds = [int(sum(row_bounds[i, j] for i in range(4))) for j in range(4)]
    require(column_bounds == [9, 16, 12, 24], "Wrong endpoint column bounds")
    require(5 * ULO - 1 >= Q(7, 20), "Circuit weight bound failed")
    refined_error_factor = (16 * 8000 + 24) / sp.Integer(500000)
    require(Q(7, 20) - refined_error_factor > 0, "Quantitative refinement has no margin")
    require(Q(1, 8000) < Q(1, 4000), "Middle perturbations leave the extended square")
    require(Q(1, 500000) < Q(1, 200000), "Refinement square leaves the source square")

    power_norms = [max(sum(abs(x) for x in (M**k)[:, j]) for j in range(4)) for k in range(5)]
    require(power_norms == [1, Q(55, 6), Q(68, 3), Q(82, 3), Q(38, 3)],
            "Wrong transport operator norms")
    require(UHI / 2 <= Q(1, 2) and UHI + Q(1, 12) <= Q(1, 2), "Real charge coefficient bound failed")
    support_before_transport = (Q(9, 4) * 10**6 + Q(3, 2)) * Q(2, 5) + Q(1, 5)
    require(support_before_transport < 10**6, "Pulled-back support constant failed")
    support_constant = 30000000
    require(max(power_norms) * 10**6 <= support_constant, "Full support constant failed")
    require(Q(1, 10**6) < Q(1, 500000), "Support corners leave the refined square")
    require(sp.simplify((5 + sp.sqrt(5)) / 8 - Q(1, 4)) > 0, "Block projection bound failed")

    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    adapter = json.loads((HERE / "jacobian_status.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    require(contract["operation_id"] == adapter["operation_id"], "Jacobian operation identity mismatch")
    require(adapter["adapter_exit_code"] == 2 and output["ok"] is False, "Unexpected adapter receipt")
    require(output["error"]["data"]["code"] == "INVALID_REQUEST", "Unrecorded Jacobian failure")
    require(payload["program"]["objective"]["sense"] == "MAXIMIZE", "Changed archived payload")

    return {
        "schema_version": 1,
        "claim_id": "C55_GEPNER_VERIFY",
        "result_class": "new_theorem",
        "kind": "exact_algebra_certificate_for_written_quantitative_verification",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "independent_review": "not_asserted_by_this_certificate",
        "novelty_status": "requires_independent_review",
        "source_anchors": anchors,
        "external_inputs": ["Xu arxiv:2511.21288v2 Theorem 1.3",
                            "Categorical Phi^5=[2], Toda arxiv:1305.0345v3 Section 3.3",
                            "Standard geometry explicitly listed in report.md"],
        "constants": {
            "uG": "(5-sqrt(5))/10",
            "uG_enclosure": [str(ULO), str(UHI)],
            "general_parameter_range": "0 < u < 13/46",
            "improved_slope_strip_endpoint": str(s),
            "extended_second_cut_radius": str(delta),
            "extended_comparison_square_radius": "1/4000",
            "source_comparison_square_radius": "1/200000",
            "refined_square_radius": "1/500000",
            "middle_test_radius": "1/8000",
            "support_test_radius": "1/1000000",
            "full_numerical_support_constant": support_constant,
            "block_projection_lower_bound": str(Q(1, 60 * support_constant)),
        },
        "universal_checks": {
            "Xu_to_manuscript_envelope_cells": cells,
            "original_margin_lower_bounds": [str(x) for x in old_margins],
            "extended_margin_lower_bounds": {name: str(value) for name, value in new_margins.items()},
            "threshold_proof": "20u+13s<=13 and 2u<=s imply 46u<=13; equality at (13/46,13/23)",
            "numerical_period": "M^5=I; not a proof of functor periodicity",
            "positive_circuit": "N0+(5u-1)N1+(5u-1)N2+N3=0 modulo 5u^2-5u+1",
            "middle_coordinate_determinant": "5u",
            "endpoint_absolute_column_bounds": column_bounds,
            "refinement_margin_lower_bound": str(Q(7, 20) - refined_error_factor),
            "transport_l1_operator_norms": [str(x) for x in power_norms],
            "pulled_back_support_factor": str(support_before_transport),
        },
        "jacobian": {
            "server_version": contract["server"]["version"],
            "protocol_version": contract["protocol_version"],
            "operation_id": adapter["operation_id"],
            "adapter_exit_code": adapter["adapter_exit_code"],
            "status": "operation_validation_failed_before_execution",
            "mathematical_conclusion": "none",
        },
        "scope_limit": "The script proves exact algebraic identities and universal affine bounds. Actual-object membership, truncations, finite filtrations, phase cuts and local finiteness are proved in report.md and require independent mathematical review; this script does not infer them from character searches.",
        "formal_core": compiler_receipt(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = verify()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    require(json.loads(path.read_text()) == certificate, "Stored certificate differs from exact replay")
    print(json.dumps({"status": "PASS", "claim": certificate["claim_id"],
                      "certificate": str(path.relative_to(ROOT)),
                      "scope": "exact algebra and constants; categorical proof is separate"}))


if __name__ == "__main__":
    main()
