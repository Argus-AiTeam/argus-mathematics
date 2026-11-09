#!/usr/bin/env python3
"""Replay the exact metric certificate; do not certify four-manifold topology."""

import json
from fractions import Fraction
from itertools import product
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(name):
    return json.loads((ROOT / name).read_text(encoding="utf-8"))


def verify_margin(certificate):
    margin = certificate["universal_margin"]
    require(margin["power_base"] == margin["push_off_factor"] == 3,
            "The power and push-off bases must be three.")
    require(margin["height_factor"] == 7 and margin["height_substeps"] == 2,
            "The source-dependent height-raising constants changed.")
    growth = margin["height_factor"] ** margin["height_substeps"]
    budget = margin["power_base"] ** margin["budget_power_offset"]
    require(growth == margin["component_diameter_coefficient"] == 49,
            "Wrong component-diameter coefficient.")
    require(budget == margin["cover_budget_coefficient"] == 81,
            "Wrong cover-budget coefficient.")
    require(margin["anchor_coefficient"] == 1, "The body-anchor cost is missing.")

    gap = [budget - growth - 1, budget - growth]
    require(gap == margin["gap_coefficients_in_u"] == [31, 32],
            "The identity after substituting t=1+u is false.")
    require(all(coefficient > 0 for coefficient in gap),
            "The gap is not certified positive for every u>=0.")

    union_bound = Fraction(growth + 1, 2 * budget)
    cover_budget = Fraction(margin["normalized_cover_budget"])
    thickening_budget = Fraction(margin["normalized_thickening_budget"])
    require(union_bound == Fraction(margin["normalized_union_radius_upper_bound"]),
            "The normalized anchored-union bound is wrong.")
    require(0 < union_bound < cover_budget == Fraction(1, 2),
            "The universal estimate does not leave the claimed cover margin.")
    require(cover_budget < thickening_budget < 1,
            "There is no strict target-space margin for thickening.")


def verify_metric(certificate, payload, output):
    example = certificate["finite_metric_illustration"]
    positions = example["positions"]
    count = len(positions)
    distances = [[abs(x - y) for y in positions] for x in positions]
    require(payload == {"metric_space": {
        "point_count": count, "distances": distances}},
        "The archived payload does not encode the stated line metric.")
    for i, j, k in product(range(count), repeat=3):
        require(distances[i][k] <= distances[i][j] + distances[j][k],
                "The payload violates the triangle inequality.")

    jacobian = certificate["jacobian"]
    operation = jacobian["operation_id"]
    require(output["tool"] == "math.run", "Not an executed operation.")
    require(output["request"] == {"operation_id": operation, "payload": payload},
            "The typed output belongs to a different operation or payload.")
    require(output["server"]["version"] == jacobian["server_version"],
            "The server version does not match the recorded run.")
    require(output["protocol_version"] == jacobian["protocol_version"],
            "The protocol version does not match the recorded run.")
    require("error" not in output and "error" not in output["result"],
            "Adapter errors are non-conclusions, not evidence.")
    require(output["result"]["operation_id"] == operation,
            "The result names a different operation.")
    require(jacobian["adapter_exit_code"] == 0
            and jacobian["adapter_error"] is None
            and jacobian["adapter_timeout"] is False,
            "The adapter did not report a successful complete run.")

    eccentricities = [max(row) for row in distances]
    radius = min(eccentricities)
    diameter = max(eccentricities)
    centers = [i for i, value in enumerate(eccentricities) if value == radius]
    periphery = [i for i, value in enumerate(eccentricities) if value == diameter]
    expected = {
        "diameter": diameter,
        "radius": radius,
        "eccentricities": [
            {"point": i, "eccentricity": value}
            for i, value in enumerate(eccentricities)
        ],
        "centers": centers,
        "periphery": periphery,
        "method": "DIRECT_DISTANCE_MATRIX_SCAN",
    }
    require(output["result"]["output"] == expected,
            "The Jacobian profile disagrees with exact replay.")
    for key, value in (("diameter", diameter), ("radius", radius),
                       ("centers", centers), ("periphery", periphery)):
        require(example[f"whole_metric_{key}"] == value,
                f"The certificate has an incorrect whole-metric {key}.")

    delta = Fraction(example["delta"])
    epsilon = Fraction(example["epsilon"])
    t = 3 ** (example["cover_count"] - 1)
    require(example["cover_count"] >= 1 and delta > 0 and epsilon > 0,
            "The example violates the positivity hypotheses.")
    require(delta == epsilon / (162 * t), "The delta choice is not as stated.")
    components = example["components"]
    anchors = example["body_anchors"]
    targets = example["assigned_K_points"]
    require(len(components) == len(anchors) == len(targets),
            "Every component needs its own retained anchor and K-point.")
    component_diameters = []
    distances_to_K = []
    for component, anchor, target in zip(components, anchors, targets):
        require(anchor in component, "The stated body anchor was not retained.")
        require(distances[anchor][target] < delta,
                "A body anchor is not within delta of its assigned K-point.")
        component_diameter = max(distances[i][j] for i, j in product(component, repeat=2))
        require(component_diameter < 49 * t * delta,
                "A component violates the first-phase diameter hypothesis.")
        component_diameters.append(component_diameter)
        for point in component:
            require(distances[point][target] < (49 * t + 1) * delta < 81 * t * delta,
                    "The anchored containment estimate failed.")
            distances_to_K.append(distances[point][target])
    require(component_diameters == example["component_diameters"],
            "Incorrect component diameters in the certificate.")
    union = [point for component in components for point in component]
    require(max(distances[i][j] for i, j in product(union, repeat=2))
            == example["union_diameter"], "Incorrect union diameter.")
    require(max(distances_to_K) == example["maximum_distance_to_assigned_K_point"],
            "Incorrect entire-union distance to the assigned K-points.")


def main():
    certificate = read_json("exact_certificate.json")
    require(certificate["result_class"] == "known_result"
            and certificate["campaign_complete"] is False,
            "This certificate must not claim a new publishable topological result.")
    verify_margin(certificate)
    jacobian = certificate["jacobian"]
    verify_metric(certificate, read_json(jacobian["exact_payload_file"]),
                  read_json(jacobian["typed_output_file"]))
    print(json.dumps({
        "universal_arithmetic_margin": "31+32u>0 for all u>=0",
        "finite_metric_replay": "passed",
        "topological_claim": "prose proof, not machine-checked",
        "independent_review": certificate["independent_review"],
        "campaign_complete": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
