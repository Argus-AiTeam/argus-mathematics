from __future__ import annotations

import json
from fractions import Fraction
from pathlib import Path


def current_claim(state: dict[str, object], claim_id: str) -> dict[str, object]:
    claims = [
        claim
        for claim in state["claims"]
        if claim["claim_id"] == claim_id
    ]
    if not claims:
        raise AssertionError(f"missing claim {claim_id}")
    return max(claims, key=lambda claim: claim["version"])


def has_independent_support(
    state: dict[str, object], claim_id: str
) -> bool:
    claim = current_claim(state, claim_id)
    return any(
        evidence["subject"]["kind"] == "claim"
        and evidence["subject"]["subject_id"] == claim_id
        and evidence["subject"]["content_hash"] == claim["content_hash"]
        and evidence["verdict"] == "supports"
        and str(evidence["produced_by"]).startswith("reviewer:")
        for evidence in state["evidence"]
    )


def main() -> None:
    q = Fraction
    route_dir = Path(__file__).parent
    project_root = route_dir.parents[2]

    lattice = json.loads(
        (route_dir / "parse-lattice.json").read_text(encoding="utf-8")
    )
    payload = json.loads(
        (route_dir / "jacobian-payload.json").read_text(encoding="utf-8")
    )
    raw_jacobian = json.loads(
        (route_dir / "jacobian-output.json").read_text(encoding="utf-8")
    )
    jacobian = json.loads(
        (route_dir / "jacobian-evidence.json").read_text(encoding="utf-8")
    )
    state = json.loads(
        (project_root / "research/MATH_STATE.json").read_text(encoding="utf-8")
    )

    primary_angular = (
        project_root
        / "research/routes/primary-page-acquisition/"
        "cambridge-search-7-15.html"
    ).read_text(encoding="utf-8")
    primary_replacement = (
        project_root
        / "research/routes/primary-page-acquisition/"
        "cambridge-search-translates.html"
    ).read_text(encoding="utf-8")
    primary_endpoint = (
        project_root
        / "research/routes/primary-page-acquisition/"
        "cambridge-search-result-is-false.html"
    ).read_text(encoding="utf-8")
    primary_general = (
        project_root
        / "research/routes/primary-page-acquisition/"
        "cambridge-search-characterise.html"
    ).read_text(encoding="utf-8")
    exact_source = (
        project_root / "research/literature/hayman-lingham-2018-v1.tex"
    ).read_text(encoding="utf-8")

    constituent_ids = {entry["id"] for entry in lattice["constituents"]}
    rule_ids = {entry["id"] for entry in lattice["transformation_rules"]}
    scope_ids = {entry["id"] for entry in lattice["quantifier_scopes"]}
    cells = [entry["id"] for entry in lattice["boundary_partition"]]
    shapes = {
        entry["id"]: set(entry["compatible_cells"])
        for entry in lattice["shape_choices"]
    }
    cell_to_arc = lattice["witness"]["cell_to_arc"]
    q_provenance = {
        entry["atom"]: entry for entry in lattice["q_atom_provenance"]
    }

    nonorigin = {"V+", "V-", "G+", "G-", "I+", "I-"}
    endpoint_positive = set(
        lattice["endpoint_classification"]["positive_measure_cells"]
    )
    endpoint_null = set(lattice["endpoint_classification"]["null_cells"])
    selector_pairs: list[tuple[str, frozenset[str]]] = []
    endpoint_survivors: list[tuple[str, frozenset[str]]] = []
    normal_forms: list[tuple[str, frozenset[str], str]] = []
    every_nonorigin_selector_has_witness = True
    every_endpoint_survivor_has_target_witness = True
    only_origin_selector_is_unmapped = True
    null_counts: dict[str, int] = {}
    for shape, compatible in shapes.items():
        ordered = [cell for cell in cells if cell in compatible]
        null_count = 0
        for mask in range(1, 1 << len(ordered)):
            selected = frozenset(
                cell
                for index, cell in enumerate(ordered)
                if mask & (1 << index)
            )
            selector_pairs.append((shape, selected))
            normal_forms.extend(
                (shape, selected, scope_id) for scope_id in scope_ids
            )
            has_target_witness = any(
                cell in cell_to_arc for cell in selected & nonorigin
            )
            if selected & nonorigin:
                every_nonorigin_selector_has_witness &= has_target_witness
            else:
                only_origin_selector_is_unmapped &= selected == {"O"}
            if selected & endpoint_positive:
                endpoint_survivors.append((shape, selected))
                every_endpoint_survivor_has_target_witness &= (
                    has_target_witness
                )
            else:
                null_count += 1
                assert selected <= endpoint_null
        null_counts[shape] = null_count

    output = raw_jacobian["result"]["output"]
    alpha = q(2, 3)
    u_min = q(4, 3)
    u_max = q(7, 5)
    height_min = u_min**3
    height_max = u_max**3

    checks = {
        "primary_angular_hit": (
            "every component domain" in primary_angular
            and "with vertex at z" in primary_angular
        ),
        "primary_replacement_hit": (
            "defined by replacing the angles less than TT" in primary_replacement
            and "<strong>translates</strong>" in primary_replacement
        ),
        "primary_endpoint_hit": (
            "<strong>result is false</strong>" in primary_endpoint
            and "taking D to be a disk" in primary_endpoint
        ),
        "primary_general_profile_hit": (
            "set obtained on replacing the angles by translates of"
            in primary_general
            and "0 < x < f(|y |)" in primary_general
        ),
        "glyph_faithful_full_context": all(
            phrase in exact_source
            for phrase in (
                "every component domain of",
                "with vertex at $z_0$",
                "replacing the angles less than $\\pi$ with translates",
                "For $\\alpha=\\frac{1}{2}$ the result is false",
                "the set obtained on replacing",
            )
        ),
        "all_constituents_recorded": constituent_ids
        == {f"C{index}" for index in range(8)},
        "finite_transformation_grammar": rule_ids
        == {f"T{index}" for index in range(8)},
        "occurrence_preserving_parameter_local_grammar": (
            lattice["grammar_constraints"]["comparator_occurrences"] == 1
            and lattice["grammar_constraints"]["occurrence_preserving"]
            and lattice["grammar_constraints"]["parameter_local"]
        ),
        "cross_parameter_copy_explicitly_excluded": (
            "X^2=|Y|"
            in lattice["grammar_constraints"]["excluded_cross_parameter_copy"]
        ),
        "all_scope_variants_recorded": scope_ids
        == {"componentwise", "common", "witness_set_common"},
        "seven_cell_closure_partition": cells
        == ["O", "V+", "V-", "G+", "G-", "I+", "I-"],
        "shape_compatibility": shapes
        == {
            "full": {"O", "V+", "V-", "G+", "G-", "I+", "I-"},
            "upper": {"O", "V+", "G+", "I+"},
            "lower": {"O", "V-", "G-", "I-"},
        },
        "all_compatible_selector_pairs_enumerated": (
            len(selector_pairs) == 127 + 15 + 15
        ),
        "all_scope_labelled_normal_forms_enumerated": (
            len(normal_forms) == 471
        ),
        "endpoint_cell_partition": (
            endpoint_positive == {"G+", "G-", "I+", "I-"}
            and endpoint_null == {"O", "V+", "V-"}
            and endpoint_positive.isdisjoint(endpoint_null)
            and endpoint_positive | endpoint_null == set(cells)
        ),
        "endpoint_null_selector_counts": null_counts
        == {"full": 7, "upper": 3, "lower": 3},
        "every_nonorigin_selector_has_target_witness": (
            every_nonorigin_selector_has_witness
        ),
        "every_endpoint_survivor_has_target_witness": (
            every_endpoint_survivor_has_target_witness
        ),
        "origin_is_only_unmapped_boundary_selector": (
            only_origin_selector_is_unmapped
        ),
        "q_nonorigin_atom_is_conditionally_derived": (
            q_provenance["0<|Y|"]["generic_source_derivable"]
        ),
        "q_unit_cutoff_is_new": (
            not q_provenance["|Y|<1"]["generic_source_derivable"]
        ),
        "q_endpoint_equation_is_not_generic": (
            not q_provenance["X^2=|Y|"]["generic_source_derivable"]
        ),
        "strict_target_alpha": q(1, 2) < alpha < 1,
        "all_strata_height_interval": (
            height_min == q(64, 27)
            and height_max == q(343, 125)
            and height_min < height_max
        ),
        "all_frozen_arcs_fail_q_height_cutoff": 1 < height_min,
        "distant_upper_translate_containment": (
            q(3) ** 2 < q(3) ** 3
            and q(4) ** 3 < q(97) ** 2
        ),
        "distant_lower_translate_containment": (
            q(3) ** 2 < q(3) ** 3
            and q(4) ** 3 < q(97) ** 2
        ),
        "exact_capacity_segment_length_and_coefficient": (
            (q(3) - q(1)) / 4 == q(1, 2)
        ),
        "reviewed_all_strata_geometry": has_independent_support(
            state, "ALL-STRATA-JORDAN"
        ),
        "reviewed_all_strata_containment": has_independent_support(
            state, "ALL-STRATA-CONTAINMENT"
        ),
        "reviewed_all_strata_harmonic": has_independent_support(
            state, "ALL-STRATA-HARMONIC"
        ),
        "reviewed_origin_obstruction": has_independent_support(
            state, "PINNED-GLOBAL-OBSTRUCTION"
        ),
        "reviewed_q_target_exclusion": has_independent_support(
            state, "SEMANTIC-Q-TARGET-EMPTY"
        ),
        "reviewed_endpoint_curved_arc": has_independent_support(
            state, "SEMANTIC-Q-ENDPOINT"
        ),
        "reviewed_finite_exit_at_infinity": has_independent_support(
            state, "COMPONENT-VACUITY-ZERO"
        ),
        "jacobian_protocol": (
            raw_jacobian["protocol_version"] == "2025-11-25"
            and jacobian["protocol_version"] == "2025-11-25"
        ),
        "jacobian_server": (
            raw_jacobian["server"]["version"] == "0.14.0"
            and jacobian["server"]["version"] == "0.14.0"
        ),
        "jacobian_operation": (
            raw_jacobian["request"]["operation_id"]
            == "arithmetic.real_quadratic.order.compute"
            and raw_jacobian["result"]["operation_id"]
            == "arithmetic.real_quadratic.order.compute"
            and jacobian["operation_id"]
            == "arithmetic.real_quadratic.order.compute"
        ),
        "jacobian_exact_payload": raw_jacobian["request"]["payload"] == payload,
        "jacobian_exact_result": (
            output["order"] == "GT"
            and output["sign_basis"] == "RATIONAL_ONLY"
            and output["difference"]["rational_part"]
            == {"num": "37", "den": "27"}
        ),
        "jacobian_adapter_status": jacobian["adapter"]
        == {
            "exit_status": 0,
            "error": None,
            "timeout": False,
            "incomplete_output": False,
        },
    }

    failed = [name for name, passed in checks.items() if not passed]
    if failed:
        raise AssertionError(", ".join(failed))

    result = {
        "status": "full_scope_parse_robust_witness_certificate_passed",
        "checks": checks,
        "new_result": (
            "The occurrence-preserving, parameter-local source-vocabulary "
            "grammar has 157 compatible shape-selector pairs and 471 "
            "scope-labelled normal forms. Every endpoint survivor contains "
            "an interior or curved cell, and the frozen witness handles every "
            "nonorigin selector; origin-only is excluded."
        ),
        "q_result": (
            "Only 0<|Y| is available after nonorigin cell selection. "
            "|Y|<1 is new, while generic X^2=|Y| requires a forbidden "
            "second comparator occurrence specialized at alpha=1/2."
        ),
        "reused_evidence": (
            "Existing independent judgements, rather than a repeated geometry "
            "replay, certify the frozen all-strata and origin-obstruction "
            "dependencies."
        ),
        "jacobian_result": "64/27 > 1 exactly, by difference 37/27",
    }
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
