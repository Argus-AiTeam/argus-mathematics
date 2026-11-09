#!/usr/bin/env python3
"""Replay the exact graph-neck route exclusion, not the manuscript theorem."""

import json
from fractions import Fraction as Q
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(name):
    with (ROOT / name).open(encoding="utf-8") as stream:
        return json.load(stream)


def linear_product(left, right):
    return [
        left[0] * right[0],
        left[0] * right[1] + left[1] * right[0],
        left[1] * right[1],
    ]


def adapter_rational(value):
    result = Q(int(value["num"]), int(value["den"]))
    require(
        value == {"num": str(result.numerator), "den": str(result.denominator)},
        "Noncanonical adapter rational",
    )
    return result


def verify_adapter(certificate, coefficients, roots):
    adapter = certificate["adapter"]
    require(adapter["exit_code"] == 0, "Adapter execution did not succeed")
    require(adapter["error"] is None, "Adapter error cannot be evidence")
    require(adapter["timeout"] is False, "Adapter timeout cannot be evidence")
    operation = "polynomial.roots.isolate"
    require(adapter["operation_id"] == operation, "Wrong adapter operation")

    payload = read_json(adapter["payload_file"])
    supplied = [adapter_rational(v) for v in payload["coefficients_descending"]]
    require(supplied == coefficients, "Payload is not the obstruction polynomial")
    contract = read_json(adapter["contract_file"])
    require(contract["operation_id"] == operation, "Wrong inspected contract")
    require(
        contract["input_schema"]["required"] == ["coefficients_descending"],
        "Unrecognized polynomial input contract",
    )

    envelope = read_json(adapter["output_file"])
    require("error" not in envelope, "Adapter envelope contains an error")
    require(envelope["tool"] == "math.run", "Not an operation execution")
    require(envelope["transport"] == "mcp-stdio", "Unexpected adapter transport")
    require(
        envelope["protocol_version"] == adapter["protocol_version"],
        "Protocol metadata mismatch",
    )
    require(
        envelope["server"]["version"] == adapter["server_version"],
        "Server metadata mismatch",
    )
    require(envelope["request"]["operation_id"] == operation, "Wrong request")
    require(envelope["request"]["payload"] == payload, "Payload binding mismatch")
    result = envelope["result"]
    require(
        set(result) == {"operation_id", "output", "runtime_ms"},
        "Incomplete, unknown, or error adapter result",
    )
    require(result["operation_id"] == operation, "Wrong result operation")
    require(result["runtime_ms"] >= 0, "Invalid runtime")
    output = result["output"]
    require(output["convention"] == "SYMPY_REAL_ROOTS", "Wrong root convention")
    require(output["multiplicities"] == [1, 1], "Wrong root multiplicities")
    intervals = [
        [adapter_rational(endpoint) for endpoint in interval]
        for interval in output["roots"]
    ]
    require(
        intervals == [[Q(v) for v in pair] for pair in adapter["returned_intervals"]],
        "Root interval record mismatch",
    )
    require(len(intervals) == len(roots) == 2, "Wrong number of roots")
    for index, (lower, upper) in enumerate(intervals):
        require(lower <= roots[index] <= upper, "Exact root outside its interval")
        require(
            not lower <= roots[1 - index] <= upper,
            "Interval does not isolate a single root",
        )


def main():
    certificate = read_json("exact_certificate.json")
    require(
        certificate["certificate_kind"] == "exact_graph_neck_route_exclusion",
        "Wrong certificate scope",
    )
    require(certificate["result_class"] == "partial_result", "Overstated result")
    for field in ("main_goal_met", "manuscript_refuted", "full_statement_verified"):
        require(certificate[field] is False, f"Unsupported conclusion: {field}")
    require(
        certificate["family"]
        == {
            "domain": "-2<r<2 and abs(y-x*r)<t+r^2",
            "parameter_box": "abs(x)<1/4 and 0<t<1",
            "fixed_seed": ["-1", "0"],
            "accessible_endpoint": ["1", "0"],
            "open_kernel": "-2<r<2 and abs(y-x*r)<r^2",
            "marked_component": "-2<r<0 and abs(y-x*r)<r^2",
            "distance_endpoint_to_marked_closure": "1",
        },
        "Family statement does not match the proved formulas",
    )
    expected = certificate["expected"]
    parameters = {key: Q(value) for key, value in certificate["parameters"].items()}
    require(
        parameters
        == {
            "real_center_radius": Q(1, 4),
            "complex_center_radius": Q(1, 2),
            "scale_upper": Q(1),
            "spatial_cutoff": Q(2),
            "seed_ball_radius": Q(1, 8),
            "probe_imaginary_part": Q(1, 8),
            "ratio_error": Q(1, 16),
            "small_scale": Q(1, 64),
        },
        "Certificate parameters do not match the theorem in report.md",
    )
    x_radius = parameters["real_center_radius"]
    rho = parameters["complex_center_radius"]
    cutoff = parameters["spatial_cutoff"]
    seed_radius = parameters["seed_ball_radius"]
    probe = parameters["probe_imaginary_part"]
    error = parameters["ratio_error"]
    t_bound = parameters["small_scale"]
    computed = {}
    computed["family_vertical_bound"] = (
        x_radius * cutoff + parameters["scale_upper"] + cutoff**2
    )
    require(computed["family_vertical_bound"] < 6, "Family is not in the stated box")

    segments = certificate["path_segments"]
    require(len(segments) == 3, "Missing path segment")
    durations = [Q(segment["duration"]) for segment in segments]
    require(durations == [Q(1, 4), Q(1, 2), Q(1, 4)], "Wrong path timing")
    r_coefficients = [
        [Q(v) for v in segment["r_coefficients_in_local_parameter"]]
        for segment in segments
    ]
    h_coefficients = [
        [Q(v) for v in segment["y_over_x_coefficients_in_local_parameter"]]
        for segment in segments
    ]
    require(
        r_coefficients == [[-1, 0], [-1, 2], [1, 0]]
        and h_coefficients == [[0, -1], [-1, 2], [1, -1]],
        "Path coefficients do not encode the reported path",
    )
    residuals = [
        [h[0] - r[0], h[1] - r[1]]
        for r, h in zip(r_coefficients, h_coefficients)
    ]
    require(residuals == [[1, -1], [0, 0], [0, -1]], "Wrong fiber residuals")
    endpoints = []
    speeds_squared = []
    for duration, r, h in zip(durations, r_coefficients, h_coefficients):
        endpoints.append(((r[0], h[0]), (sum(r), sum(h))))
        # Affine functions attain their absolute maximum at an endpoint.
        require(max(abs(r[0]), abs(sum(r))) <= 1, "Horizontal path bound failed")
        require(max(abs(h[0]), abs(sum(h))) <= 1, "Vertical path bound failed")
        speeds_squared.append((r[1] ** 2 + rho**2 * h[1] ** 2) / duration**2)
    require(endpoints[0][0] == (-1, 0), "Wrong fixed seed")
    require(endpoints[-1][1] == (1, 0), "Wrong fixed endpoint")
    require(
        endpoints[0][1] == endpoints[1][0]
        and endpoints[1][1] == endpoints[2][0],
        "Path joints do not agree",
    )
    computed["side_path_slack_lower_bound"] = 1 - x_radius
    require(computed["side_path_slack_lower_bound"] > 0, "Side path not interior")
    require(residuals[1] == [0, 0], "Middle path must have slack t+r^2 > 0")
    computed["complex_path_norm_squared_bound"] = 1 + rho**2
    computed["complex_path_speed_squared_bound"] = max(speeds_squared)
    require(
        computed["complex_path_speed_squared_bound"]
        == 16 * computed["complex_path_norm_squared_bound"],
        "Norm/speed relation failed",
    )
    computed["complex_norm_plus_speed_squared_bound"] = (
        25 * computed["complex_path_norm_squared_bound"]
    )
    computed["strict_norm_plus_speed_bound"] = Q(6)
    require(
        computed["complex_norm_plus_speed_squared_bound"] < 6**2,
        "Uniform complex path estimate failed",
    )
    computed["real_path_norm_squared_bound"] = 1 + x_radius**2
    require(
        computed["real_path_norm_squared_bound"] < cutoff**2,
        "Real paths leave the fixed spatial ball",
    )

    require(1 + seed_radius < cutoff, "Seed ball leaves the spatial box")
    computed["seed_ball_slack_lower_bound"] = (1 - seed_radius) ** 2 - (
        seed_radius + x_radius * (1 + seed_radius)
    )
    require(computed["seed_ball_slack_lower_bound"] > 0, "No uniform seed ball")
    computed["probe_fiber_residual_upper_bound"] = probe + x_radius
    require(
        computed["probe_fiber_residual_upper_bound"] < 1,
        "Probe is not in every nearby-center fiber",
    )
    computed["recentered_probe_residual_lower_bound"] = (
        (1 - error) * probe - x_radius * error
    )
    require(
        computed["recentered_probe_residual_lower_bound"] > 0,
        "Cannot remove the absolute value in the probe residual",
    )
    computed["recentered_probe_width_upper_bound"] = t_bound + error**2
    margin = (
        computed["recentered_probe_residual_lower_bound"]
        - computed["recentered_probe_width_upper_bound"]
    )
    computed["recentered_probe_violation_margin"] = margin
    require(margin > 0, "Probe does not exclude fixed-domain recentering")

    q_ascending = [t_bound + x_radius * error - probe, -probe, Q(1)]
    roots = [Q(-1, 4), Q(3, 8)]
    require(
        linear_product([-roots[0], Q(1)], [-roots[1], Q(1)]) == q_ascending,
        "Exact root factorization failed",
    )
    q_plus_margin = [q_ascending[0] + margin, q_ascending[1], q_ascending[2]]
    require(
        linear_product([error, Q(1)], [-3 * error, Q(1)]) == q_plus_margin,
        "Sharp uniform slack bound failed",
    )
    require(error > 0 and error - 3 * error < 0, "Wrong factor signs")
    computed["maximum_membership_slack"] = -margin
    for key, value in computed.items():
        require(Q(expected[key]) == value, f"Wrong exact certificate value: {key}")
    coefficients = list(reversed(q_ascending))
    require(
        [Q(value) for value in expected["slack_polynomial_descending"]]
        == coefficients,
        "Wrong slack polynomial",
    )
    require(
        [Q(value) for value in expected["slack_polynomial_exact_roots"]] == roots,
        "Wrong exact roots",
    )
    verify_adapter(certificate, coefficients, roots)
    print(
        json.dumps(
            {
                "ok": True,
                "result_class": "partial_result",
                "manuscript_refuted": False,
                "full_statement_verified": False,
                "maximum_membership_slack": str(-margin),
                "strict_complex_path_bound": "6",
                "adapter_status": "completed",
                "independent_review": certificate["independent_review"],
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
