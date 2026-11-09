#!/usr/bin/env python3
"""Replay a route exclusion and conditional weight algebra, not quantum Langlands."""

import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SECTIONS = (
    ROOT
    / "research/openai_manuscript"
    / "Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026"
    / "build/sections"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def normalized(text):
    return " ".join(text.split())


def rational_polynomial(data, variable):
    value = sp.Integer(0)
    for term in data["terms"]:
        exponents = term["exponents"]
        require(len(exponents) == 1 and exponents[0] >= 0, "Invalid exponent")
        coefficient = term["coefficient"]
        numerator = int(coefficient["num"])
        denominator = int(coefficient["den"])
        require(denominator > 0, "Invalid denominator")
        value += sp.Rational(numerator, denominator) * variable ** exponents[0]
    return value


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["result_class"] == "partial_result", "Overstated result class")
    require(certificate["significance_status"] == "checkpoint", "Overstated significance")
    require(certificate["novelty_status"] == "not_claimed", "Unsupported novelty claim")
    require(certificate["campaign_goal_complete"] is False, "Campaign is not completed")
    require(certificate["refuted_manuscript_assertions"] == [], "No manuscript refutation")
    require(certificate["main_theorem_verdict"] == "unresolved", "Main theorem is unresolved")

    for obligation in certificate["source_obligations"]:
        text = (SECTIONS / obligation["section_file"]).read_text()
        marker = "\\label{" + obligation["label"] + "}"
        require(text.count(marker) == 1, "Missing or ambiguous source label")
        statement = text.split(marker, 1)[1].split(obligation["environment_end"], 1)[0]
        require(
            normalized(obligation["literal"]) in normalized(statement),
            "The quoted source obligation changed: " + obligation["label"],
        )

    q = sp.Symbol("q")
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    matrix = payload["matrix"]
    require(matrix["variables"] == ["q"], "Wrong Jacobian coefficient field")
    require(len(matrix["entries"]) == 1, "Wrong Jacobian matrix height")
    require(len(matrix["entries"][0]) == 1, "Wrong Jacobian matrix width")
    entry = matrix["entries"][0][0]
    require(entry["domain"] == "QQ" and entry["variables"] == ["q"], "Wrong entry type")
    scalar = sp.cancel(
        rational_polynomial(entry["numerator"], q)
        / rational_polynomial(entry["denominator"], q)
    )
    require(sp.expand(scalar - (q - 1)) == 0, "Payload is not the claimed transition")

    adapter = json.loads((HERE / "jacobian_result.json").read_text())
    metadata = certificate["jacobian"]
    require(adapter["adapter_exit_code"] == metadata["adapter_exit_code"] == 0, "Adapter failed")
    require(adapter["adapter_status"] == metadata["adapter_status"] == "completed", "Incomplete adapter")
    response = adapter["response"]
    require(response["request"]["payload"] == payload, "Jacobian output belongs to another payload")
    require(
        adapter["operation_id"]
        == response["request"]["operation_id"]
        == response["result"]["operation_id"]
        == metadata["operation_id"]
        == "matrix.symbolic.rank.compute",
        "Wrong operation binding",
    )
    require(response["server"]["version"] == metadata["server_version"], "Wrong server version")
    require(response["protocol_version"] == metadata["protocol_version"], "Wrong protocol version")
    output = response["result"]["output"]
    independent_rank = sp.Matrix([[scalar]]).rank()
    require(output["method"] == "EXACT_SYMBOLIC_ROW_REDUCTION", "Wrong rank method")
    require(output["rank"] == metadata["typed_rank"] == independent_rank == 1, "Wrong generic rank")
    require(output["pivot_columns"] == metadata["pivot_columns"] == [0], "Wrong pivot columns")

    tower = certificate["scalar_tower"]
    require(tower["transition"] == "q-1", "Wrong scalar tower")
    require(tower["ordinary_parameter"] == 1, "Wrong ordinary parameter")
    require(tower["witness_parameter"] == 2, "Wrong non-torsion witness")
    require(scalar.subs(q, 1) == tower["ordinary_transition"] == 0, "Ordinary map is not zero")
    require(scalar.subs(q, 2) == tower["witness_transition"] == 1, "Witness map is not identity")
    require(tower["ordinary_colimit_dimension"] == 0, "Wrong zero-map colimit")
    require(tower["witness_colimit_dimension"] == 1, "Wrong identity-map colimit")
    require(tower["admissible_manuscript_countermodel"] is False, "Inadmissible model mislabelled")
    i = sp.Symbol("i", integer=True, nonnegative=True)
    a = sp.Symbol("a")
    require(
        sp.cancel((q - 1) * a / (q - 1) ** (i + 1) - a / (q - 1) ** i) == 0,
        "Localization cocone is incompatible",
    )

    logarithm = certificate["logarithm_length_two"]
    require(logarithm["basis"] == ["1", "h"], "Wrong logarithm basis")
    require(logarithm["weights"] == [0, -2], "Wrong Tate convention")
    require(logarithm["hodge_F0_basis_indices"] == [0], "Wrong Hodge filtration")
    h = sp.Matrix(logarithm["transition_matrix"])
    require(h == sp.Matrix([[0, 0], [1, 0]]), "Wrong first-order substitution")
    require(h * h == sp.zeros(2), "Length-two nilpotence failed")
    require(sp.eye(2) + h - sp.eye(2) == h, "Exponential substitution failed")
    e0 = sp.Matrix([1, 0])
    image = h * e0
    require(image == sp.Matrix([0, 1]), "Wrong Hodge-filtration obstruction")
    require(image[1] != 0 and logarithm["preserves_hodge_F0"] is False, "Non-mixed map mislabelled")
    weights = sp.diag(*logarithm["weights"])
    defect = weights * h - h * weights
    require(defect == sp.Matrix(logarithm["weight_defect_matrix"]), "Wrong weight defect")
    require(defect != sp.zeros(2), "No weight defect detected")

    w, v, w0 = sp.symbols("w v w0", integer=True)
    source_weights = sp.diag(w, w - 2)
    target_weights = sp.diag(v, v - 2)
    symbolic_defect = target_weights * h - h * source_weights
    require(symbolic_defect == sp.Matrix([[0, 0], [v - w - 2, 0]]), "Weight-growth identity failed")
    require(logarithm["necessary_target_weight_increment"] == 2, "Wrong necessary increment")
    require(logarithm["higher_lifts_constructed"] is False, "Necessary condition is not sufficient")
    require(sp.expand((w0 + 2 * (i + 1)) - (w0 + 2 * i) - 2) == 0, "Tower recurrence failed")
    k = sp.Symbol("k", integer=True, nonnegative=True)
    parity_gaps = [
        int(sp.expand(w0 + 2 * (k + 1) - (w0 + 2 * k + remainder)))
        for remainder in (0, 1)
    ]
    require(parity_gaps == logarithm["unboundedness_gap_by_parity"] == [2, 1], "Wrong unboundedness gaps")
    require(all(gap > 0 for gap in parity_gaps), "Weights need not exceed a proposed upper bound")

    config = certificate["configuration_propagation"]
    require(config["status"] == "conditional_all_index_proof", "Conditional result mislabelled")
    require(config["actual_geometric_hypotheses_verified"] is False, "Geometric hypotheses are open")
    require(config["stalk_upper_weight"] == "W+E", "Wrong conditional upper bound")
    n, n_prime, c, ell, j, E, W, degree = sp.symbols("n n_prime c ell j E W degree", integer=True)
    link_degree = degree - 2 * n
    link_weight = 2 * degree - 2 * n
    require(sp.expand(link_weight - link_degree) == degree, "Wrong normalized link weight")
    integrated_upper_degree = E + c - 2 * n + 2 * n_prime - ell
    require(
        sp.expand(integrated_upper_degree.subs(n_prime, n - c) - (E - c - ell)) == 0,
        "Collision codimension decay has the wrong sign",
    )
    piece_upper_weight = W + c + ell + j
    contribution_slack = E - c - ell - j
    require(
        sp.expand(W + E - piece_upper_weight - contribution_slack) == 0,
        "Contribution condition does not give the asserted weight bound",
    )

    print(json.dumps({
        "ok": True,
        "source_obligations_bound": len(certificate["source_obligations"]),
        "exact_generic_rank": independent_rank,
        "scalar_tower_mixed_lift": "fails_at_length_2",
        "conditional_configuration_stalk_weight": "W+E",
        "actual_geometric_hypotheses_verified": False,
        "campaign_goal_complete": False,
        "refuted_manuscript_assertions": [],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
