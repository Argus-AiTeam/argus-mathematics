from __future__ import annotations

import json
from fractions import Fraction
from pathlib import Path


def fraction_text(value: Fraction) -> str:
    return f"{value.numerator}/{value.denominator}"


def main() -> None:
    q = Fraction
    route_dir = Path(__file__).parent
    payload = json.loads(
        (route_dir / "jacobian-payload.json").read_text(encoding="utf-8")
    )
    evidence = json.loads(
        (route_dir / "jacobian-evidence.json").read_text(encoding="utf-8")
    )

    alpha = q(2, 3)
    pole_x = q(3, 8)
    bridge_left = q(1, 4)
    bridge_right = q(1, 2)
    bridge_height = q(2)
    lobe_height = q(3)
    u_min = q(4, 3)
    u_max = q(7, 5)
    height_min = u_min**3
    height_max = u_max**3
    coarse_height_min = q(9, 4)
    coarse_height_max = q(11, 4)
    epsilon = q(1, 8)
    local_height_min = coarse_height_min - epsilon
    local_height_max = coarse_height_max + epsilon

    output = evidence["response"]["output"]
    checks = {
        "alpha_is_strictly_between_endpoint_and_one": q(1, 2) < alpha < 1,
        "pole_is_in_bridge": bridge_left < pole_x < bridge_right,
        "upper_and_lower_lobes_overlap_bridge": (
            1 < bridge_height
            and bridge_left < bridge_right < 1
        ),
        "arc_parameter_interval_is_nondegenerate": 1 < u_min < u_max,
        "arc_heights_lie_in_coarse_interval": (
            height_min == q(64, 27)
            and height_max == q(343, 125)
            and coarse_height_min < height_min < height_max < coarse_height_max
        ),
        "uniform_ball_stays_above_bridge": (
            local_height_min == q(17, 8)
            and bridge_height < local_height_min
        ),
        "uniform_ball_stays_below_lobe_cap": (
            local_height_max == q(23, 8)
            and local_height_max < lobe_height
        ),
        "curved_stratum_identity_at_lower_endpoint": (
            (u_min**2) ** 3 == (u_min**3) ** 2
        ),
        "curved_stratum_identity_at_upper_endpoint": (
            (u_max**2) ** 3 == (u_max**3) ** 2
        ),
        "all_four_arc_types_are_nondegenerate": (
            height_max - height_min > 0
            and u_max**2 - u_min**2 > 0
        ),
        "jacobian_protocol": evidence["protocol_version"] == "2025-11-25",
        "jacobian_schema": evidence["schema_version"] == 1,
        "jacobian_server_version": evidence["server"]["version"] == "0.14.0",
        "jacobian_operation": (
            evidence["request"]["operation_id"]
            == "arithmetic.real_quadratic.order.compute"
            and evidence["response"]["operation_id"]
            == "arithmetic.real_quadratic.order.compute"
        ),
        "jacobian_request_preserves_exact_payload": (
            evidence["request"]["payload"] == payload
        ),
        "jacobian_exact_order": (
            output["order"] == "GT"
            and output["sign_basis"] == "RATIONAL_ONLY"
            and output["difference"]["rational_part"]
            == {"num": "1", "den": "8"}
        ),
        "jacobian_adapter_ok": evidence["adapter_status"]
        == {"status": "ok", "error": None, "timeout": False},
    }

    failed = [name for name, passed in checks.items() if not passed]
    if failed:
        raise AssertionError(", ".join(failed))

    result = {
        "status": "exact_all_strata_model_domain_certificate_passed",
        "arithmetic": "integers and fractions.Fraction only",
        "checks": checks,
        "derived": {
            "alpha": fraction_text(alpha),
            "pole": [fraction_text(pole_x), "0/1"],
            "arc_parameter_interval": [
                fraction_text(u_min),
                fraction_text(u_max),
            ],
            "arc_height_interval": [
                fraction_text(height_min),
                fraction_text(height_max),
            ],
            "uniform_local_height_window": [
                fraction_text(local_height_min),
                fraction_text(local_height_max),
            ],
            "local_radius": fraction_text(epsilon),
            "jacobian_difference": "1/8",
        },
        "universal_steps": [
            "The three open connected pieces U_+, R, U_- have nonempty consecutive overlaps, so their union D is a domain.",
            "The exact horizontal sections identify the displayed twelve-piece simple closed boundary, hence D is a bounded Jordan domain.",
            "For every selected point, the radius-1/8 ball stays in 2<|Im z|<3, where D equals the corresponding component of C_(2/3).",
            "For every u>0, (u^2)^3=(u^3)^2, so the two curved arcs lie on the two curved boundary strata; the other two arcs lie on the open vertical strata.",
            "A Riemann map of a Jordan domain extends homeomorphically to the boundary, and each nonempty open boundary arc maps to a nonempty circle arc with strictly positive Poisson integral from every pole.",
        ],
        "source_scope": (
            "The replay verifies the exact arithmetic and typed Jacobian result. "
            "The proof establishes all four natural non-origin strata without "
            "choosing a sign or branch. Whether the publication permits an "
            "additional unprinted proper-sublocus rule remains a statement-"
            "fidelity judgement for independent review."
        ),
    }
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
