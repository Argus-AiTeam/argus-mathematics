#!/usr/bin/env python3
"""Replay universal algebra; do not identify symbolic checks with an analytic proof."""

import argparse
import hashlib
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def polynomial(value, variables):
    result = sp.Integer(0)
    for term in value["terms"]:
        exponents = term["exponents"]
        require(len(exponents) == len(variables), "Incorrect exponent arity")
        require(all(isinstance(e, int) and e >= 0 for e in exponents),
                "A polynomial exponent is not a nonnegative integer")
        coefficient = term["coefficient"]
        numerator, denominator = int(coefficient["num"]), int(coefficient["den"])
        require(denominator > 0, "Nonpositive rational denominator")
        monomial = sp.Rational(numerator, denominator)
        for variable, exponent in zip(variables, exponents):
            monomial *= variable ** exponent
        result += monomial
    return result


def rational_function(value, names, variables):
    require(value["domain"] == "QQ", "Jacobian result is not exact rational algebra")
    require(value["variables"] == names, "Jacobian variable ordering changed")
    denominator = polynomial(value["denominator"], variables)
    require(denominator != 0, "Zero rational-function denominator")
    return polynomial(value["numerator"], variables) / denominator


def replay():
    identities = []

    def zero(name, expression, hypotheses="polynomial identity over the reals"):
        residual = sp.cancel(expression)
        require(residual == 0, f"{name}: nonzero exact residual {residual}")
        identities.append({"name": name, "residual": "0", "hypotheses": hypotheses})

    b, c, u, v = sp.symbols("b c u v", real=True)
    names = ["b", "c", "u", "v"]
    variables = [b, c, u, v]
    payload = json.loads((ROOT / "jacobian/edge_precision_payload.json").read_text())
    answer = json.loads((ROOT / "jacobian/edge_precision_output.json").read_text())
    operation = "matrix.symbolic.determinant.compute"
    require(answer["tool"] == "math.run", "Not a Jacobian execution envelope")
    require(answer["request"]["operation_id"] == operation, "Wrong requested operation")
    require(answer["request"]["payload"] == payload, "Executed payload differs from saved payload")
    require("error" not in answer, "Jacobian adapter reported an error")
    require(answer["result"]["operation_id"] == operation, "Wrong returned operation")
    output = answer["result"]["output"]
    require(output["method"] == "SYMPY_BAREISS", "No completed exact determinant output")
    require(payload["matrix"]["variables"] == names, "Unexpected input variable order")
    scaled = sp.Matrix([
        [rational_function(entry, names, variables) for entry in row]
        for row in payload["matrix"]["entries"]
    ])
    expected_scaled = sp.Matrix([
        [v * (c**2 + b**2) + b, v * c + b * u],
        [v * c + b * u, v + b * (u**2 + v**2)],
    ])
    for i in range(2):
        for j in range(2):
            zero(f"typed_oriented_precision_{i}{j}", scaled[i, j] - expected_scaled[i, j])
    delta = (1 - c * u + b * v)**2 + (c * v + b * u)**2
    returned_det = rational_function(output["determinant"], names, variables)
    zero("jacobian_universal_edge_determinant", returned_det - b * v * delta)
    zero("independent_universal_edge_determinant", scaled.det() - b * v * delta)
    zero("positive_edge_discriminant_gap",
         delta - 4 * b * v - (1 - c * u - b * v)**2 - (c * v - b * u)**2,
         "b>0 and v>0 make the displayed sum-of-squares expression strictly positive")
    Q = sp.Matrix([[c**2 + b**2, c], [c, 1]]) / b
    J = sp.Matrix([[0, 1], [1, 0]])
    Q_reverse = J * (sp.Matrix([[u**2 + v**2, u], [u, 1]]) / v) * J
    for i in range(2):
        for j in range(2):
            zero(f"edge_endpoint_orientation_{i}{j}",
                 Q[i, j] + Q_reverse[i, j] - scaled[i, j] / (b * v),
                 "b!=0, v!=0")
    zero("one_sided_unit_determinant", Q.det() - 1, "b!=0")
    K = sp.Matrix([
        [v + b * (u**2 + v**2), -(v * c + b * u)],
        [-(v * c + b * u), v * (c**2 + b**2) + b],
    ]) / delta
    product = (Q + Q_reverse) * K - sp.eye(2)
    for i in range(2):
        for j in range(2):
            zero(f"edge_covariance_inverse_{i}{j}", product[i, j],
                 "b>0, v>0 imply delta>0")
    zero("edge_covariance_determinant", K.det() - b * v / delta,
         "b>0, v>0 imply delta>0")

    B, x, y = sp.symbols("B x y", real=True)
    zero("arbitrary_degree_residual_gram_gap",
         (B-x) * (B-y) - x*y - B*(B-x-y),
         "B=sum beta_i; beta_i>0 and d>=3 imply B-x-y>0 for distinct branches")
    indicator = sp.symbols("indicator", real=True)
    zero("arbitrary_degree_residual_projector_entry",
         indicator*x - 2*x*y/B + x*y*B/B**2 - (indicator*x - x*y/B),
         "B=sum beta_i>0; entrywise finite-sum expansion of W diag(beta)^(-1) W=W")
    S, beta, P, t = sp.symbols("S beta P t", real=True)
    zero("arbitrary_degree_star_determinant_scalar",
         (S+beta)/P * (1+(t**2/(S+beta)+S)/beta)
         - (t**2+(S+beta)**2)/(P*beta),
         "S=sum retained beta_i; P=product retained beta_i; beta omitted; all positive")
    ui, uj, dj, T = sp.symbols("ui uj dj T", real=True)
    zero("arbitrary_dimension_rank_one_inverse_entry",
         -ui*uj*dj/(beta+T) + ui*uj*dj/beta
         - ui*T*uj*dj/(beta*(beta+T)),
         "beta>0; T=u^T D^(-1)u>=0; diagonal entries of D positive")

    r, q, H, Do = sp.symbols("r q H Do", real=True)
    rotation = sp.Matrix([[r, q], [q, -r]])
    transformed = rotation * sp.diag(H, Do) * rotation.T
    zero("reverse_complementary_hessian",
         transformed[1, 1] - (q**2*H + r**2*Do))
    zero("reverse_mixed_hessian", transformed[0, 1] - r*q*(H-Do))
    square = rotation * rotation - (r**2+q**2)*sp.eye(2)
    for i in range(2):
        for j in range(2):
            zero(f"edge_coordinate_rotation_{i}{j}", square[i, j])
    so, co, si, ci = sp.symbols("so co si ci", real=True)
    norm = r**2 + q**2 - 1
    cross = r*so-r*si
    left = so-r**2*si-q**2*ci
    right = si-r**2*so-q**2*co
    zero("zero_correlation_safe_covariance_swap_0",
         q**2*(co-si) - (-right-si*norm-r*cross),
         "norm=cross=left=right=0 and q!=0; no assumption r!=0")
    zero("zero_correlation_safe_covariance_swap_1",
         q**2*(ci-so) - (-left-so*norm+r*cross),
         "norm=cross=left=right=0 and q!=0; no assumption r!=0")

    s = sp.symbols("s", positive=True)
    A, C = s + 1, s + 4
    zero("two_phase_entropy_equality_all_times",
         (A*C**4) * (C*A**4) - (A*C)**5,
         "degree five, arbitrary s>0; holds per color and multiplies over any finite colors")
    k = sp.Rational(2, 5)
    zero("two_phase_exact_annealed_normalization", (k + 4*k)/2 - 1)
    require(k != 1 and 4*k != 1, "Sharpness variances no longer distinguish the phases")
    zero("degree_five_clean_cavity_at_zero",
         sp.I/2 - 1/(-4*(sp.I/2)))
    zero("degree_five_clean_root_at_zero", sp.I*k - 1/(-5*(sp.I/2)))

    recording = json.loads((ROOT / "lean_verification.json").read_text())["kernel"]["recorded"]
    archive_path = ROOT.parent.parent / recording["artifact"]
    archive = json.loads(archive_path.read_text())
    require(archive["subject"] == recording["subject"],
            "Compiler archive and recorded claim disagree")
    require(archive["evidence_id"] == recording["evidence_id"],
            "Compiler archive and recorded run disagree")
    require(archive["tier"] == "mechanical" and archive["verdict"] == "supports",
            "The pinned compiler archive is not supporting mechanical evidence")
    lean = archive["lean_check"]
    require(lean["status"] == "success", "Lean source is not successfully compiled")
    require(lean["exit_code"] == 0, "Lean compiler returned a nonzero exit status")
    require(lean["proof_holes"] == [], "Lean source has proof holes")
    require("version 4.31.0," in lean["tools"]["lean"]["version"],
            "The required Lean 4.31.0 compiler was not used")
    require(lean["audit_exit_code"] == 0, "The real Lean axiom audit did not pass")
    source_digest = hashlib.sha256((ROOT / "Main.lean").read_bytes()).hexdigest()
    fidelity_digest = hashlib.sha256(
        (ROOT / "statement_fidelity.md").read_text().encode("utf-8")
    ).hexdigest()
    require(lean["source_sha256"] == source_digest, "Lean result has a stale source binding")
    require(lean["statement_fidelity_sha256"] == fidelity_digest,
            "Lean result has a stale statement-fidelity binding")

    ledger_path = ROOT.parent / "MATH_STATE.json"
    ledger = json.loads(ledger_path.read_text())
    candidates = [
        claim for claim in ledger["claims"] if claim["claim_id"] == "C_QGR_FINITE_CORE"
    ]
    claim = max(candidates, key=lambda item: item["version"])
    require(claim["formal_statement"] == (ROOT / "Main.lean").read_text(),
            "Current formal claim does not contain the compiled source")
    require(archive["lean_source"]["text"] == claim["formal_statement"],
            "Archived compiler source differs from the current formal statement")
    require(archive["statement_fidelity"]["text"] ==
            (ROOT / "statement_fidelity.md").read_text(),
            "Archived statement fidelity differs from the current reading")
    mechanical = [
        record for record in ledger["evidence"]
        if record["subject"]["subject_id"] == "C_QGR_FINITE_CORE"
        and record["subject"]["content_hash"] == claim["content_hash"]
        and record["tier"] == "mechanical" and record["verdict"] == "supports"
    ]
    require(recording in mechanical,
            "The pinned real compiler evidence is not attached to the current claim")

    return {
        "claim": "C_QGR_GENERAL",
        "result": "Quantified parity-ergodic quenched entropy-rigidity theorem with a zero-correlation-safe equality case",
        "classification": {
            "analytic_result": "proved_in_report_pending_independent_review",
            "finite_core": "exact_symbolic_and_lean_verification",
            "sharpness": "exact_two_phase_construction_not_a_manuscript_refutation",
            "novelty": "extension_relative_to_staged_source_literature_wide_novelty_pending",
            "reviewer": "pending_host_invocation",
        },
        "quantifiers": {
            "degree": "every integer d>=3",
            "colors": "every finite m>=1",
            "algebra": "identities over all declared real variables with the stated denominators",
            "sampling": "none",
        },
        "symbolic_identities": identities,
        "jacobian": {
            "server": answer["server"]["name"],
            "server_version": answer["server"]["version"],
            "protocol_version": answer["protocol_version"],
            "operation_id": operation,
            "payload": "jacobian/edge_precision_payload.json",
            "typed_output": "jacobian/edge_precision_output.json",
            "adapter_status": "completed_exact_output",
            "structured_error": None,
            "timeout": False,
        },
        "formal_core": {
            "claim": "C_QGR_FINITE_CORE",
            "status": lean["status"],
            "exit_code": lean["exit_code"],
            "proof_holes": lean["proof_holes"],
            "compiler_version": lean["tools"]["lean"]["version"],
            "axiom_audit_exit_code": lean["audit_exit_code"],
            "source_sha256": source_digest,
            "statement_fidelity_sha256": fidelity_digest,
            "evidence_archives": [recording["artifact"]],
            "declarations": [
                "QuenchedRigidity.color_blocks_agree",
                "QuenchedRigidity.common_block_on_sums",
                "QuenchedRigidity.edge_determinant_scaled",
                "QuenchedRigidity.edge_discriminant_positive",
                "QuenchedRigidity.edge_hessian_constant",
                "QuenchedRigidity.edge_covariance_swap",
                "QuenchedRigidity.two_step_covariance",
                "QuenchedRigidity.covariance_normalization",
            ],
        },
        "sharpness": {
            "degree": 5,
            "energy": 0,
            "root_reference_variance": "2/5",
            "phase_multipliers": ["1", "2"],
            "conditional_root_variances": ["2/5", "8/5"],
            "annealed_second_moment": "1",
            "entropy_equality": "every s>0 and every finite color dimension",
            "missing_hypothesis": "parity-preserving ergodicity",
            "not_a_manuscript_refutation": True,
        },
        "not_machine_certified": [
            "The measure-theoretic and analytic proof in report.md",
            "Existence and boundary regularity of Green functions in new disorder regimes",
            "The inherited finite-graph conditional entropy and marked-law assertions",
            "Literature-wide novelty and publishable significance",
            "Either main GOE universality theorem",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = replay()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    require(json.loads(path.read_text()) == result,
            "Saved exact certificate differs from the independently replayed result")
    print(json.dumps({
        "status": "verified",
        "universal_symbolic_identities": len(result["symbolic_identities"]),
        "lean_claim": result["formal_core"]["claim"],
        "lean_exit_code": result["formal_core"]["exit_code"],
        "proof_holes": result["formal_core"]["proof_holes"],
        "independent_review": "pending",
        "manuscript_refutation": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
