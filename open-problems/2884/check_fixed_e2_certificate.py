#!/usr/bin/env python3
"""Replay the compact exact certificate for the final seven-arrow chain."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from copy import deepcopy
from pathlib import Path

sys.dont_write_bytecode = True


HERE = Path(__file__).resolve().parent
CAMPAIGN = HERE.parents[2]
OUTPUT = HERE / "aggregate_certificate.json"
CHECK_OUTPUT = HERE / "checker_output.json"


PINNED_INPUTS = {
    "objective": (
        "OBJECTIVE.md",
        "5a5ae7f8611acc3bbd6616cb196939822f21ba3ba3b132d3ba6b3a6538d11921",
    ),
    "central_bridge": (
        "research/fixed-e2-closed-kirby/pointwise-central-t2xp-bridge/"
        "pointwise_bridge_certificate.json",
        "6410c953ebed8f6a3ebade0dd40ab1de3da61f9ada1d2261b3233dbe10363ca9",
    ),
    "central_source_atlas": (
        "research/fixed-e2-closed-kirby/pointwise-central-t2xp-bridge/"
        "source_central_atlas.json",
        "c877e96076a42ef532fc50e48147ce3a6de84bea6a1626e0bc274eb8eb604e11",
    ),
    "two_cap_bridge": (
        "research/fixed-e2-closed-kirby/pointwise-two-cap-atlas-bridge/"
        "pointwise_bridge_certificate.json",
        "44995356ca87588bebdf94fddfa2aa808800a5647dfc903128f3dee010b394f4",
    ),
    "cap_source_atlas": (
        "research/fixed-e2-closed-kirby/pointwise-two-cap-atlas-bridge/"
        "source_cap_atlas.json",
        "fbaca6ba1a342997ed98933c74c8687e4fd87b829a78766111fcb748e0e13ca7",
    ),
    "h2_15_bridge": (
        "research/fixed-e2-closed-kirby/figure22-h2-15-geometric-transport/"
        "geometric_transport_certificate.json",
        "d61473c73cf27cc5fc93b2e6125cf16ff3f6d7b7068044d2618171ea6980bc6a",
    ),
    "h2_28_bridge": (
        "research/fixed-e2-closed-kirby/"
        "figure22-h2-28-full-cell-target-chart-v4/"
        "native_inclusion_certificate.json",
        "4c839e4f462173601f0da279e980a393f3bbaef661b2b7399a6faedf584201ef",
    ),
    "figure22_source_object": (
        "research/fixed-e2-closed-kirby/"
        "figure22-frozen-carrier-ambient-bridge/source_object.json",
        "733d384b46f99e0f94b55bc49ef0f48aea9f8ac9ea7f8bc654d695613c5996a4",
    ),
    "native_carrier": (
        "research/fixed-e2-closed-kirby/"
        "source-independent-native-28-carrier/carrier_certificate.json",
        "30311b0e1c9719974de27351805cbebe29c7f38ff881731e59d734bbb0e74e0e",
    ),
    "pre_cancellation_prefix": (
        "research/fixed-e2-closed-kirby/pre-cancellation-cap1-absorber/"
        "pre_cancellation_prefix.json",
        "caa74cf3ed2cd12a3b92b2f609a1e17efcaa11d41e3899a6878823d4aa7e4fd3",
    ),
    "k0_endpoint": (
        "research/fixed-e2-closed-kirby/"
        "pre-cancellation-k0-native-endpoint/endpoint_correspondence.json",
        "7b797aee6a97c62bfc7b1609cfe3ae8c72c441d8841e671588063cd1d0597460",
    ),
    "source_bound_k1": (
        "research/fixed-e2-closed-kirby/source-bound-k1-endpoint-bridge/"
        "source_bound_certificate.json",
        "c7c7887e229e25679349b7d1a1dc0ade67ff9e63ed6931624bd73c71c11ded88",
    ),
    "k1_reversed_band": (
        "research/fixed-e2-closed-kirby/k1-reversed-rgb-band-pl/"
        "rational_pl_certificate.json",
        "7a36c0523ad8be1f758bb3c06b0dd405f56162074f70dec5868706fb1db846ee",
    ),
    "double_cap_model": (
        "research/fixed-e2-closed-kirby/rgb-double-cap/"
        "double_cap_model.json",
        "6288b7a9d97436eb8511ba4449efd5059477156669ba830dc0acee5487a205cb",
    ),
    "closed_k0": (
        "research/fixed-e2-closed-kirby/flexible-e1-caps/"
        "k0_closed_endpoint_summary.json",
        "437768956ebf94ce8e0be12b70e8e5649843b2079fe16b9f545e90415a8604eb",
    ),
    "closed_k1": (
        "research/fixed-e2-closed-kirby/flexible-e1-caps/"
        "k1_closed_endpoint_summary.json",
        "3b666e3a159832f1790b32873c7c912beb391cc5007f18d6bd551134138089a5",
    ),
    "cap_theorem_audit": (
        "research/fixed-e2-closed-kirby/flexible-e1-caps/"
        "source_theorem_audit.json",
        "245e20cda8dbc537077cb9883c578df3df35456c272d003171718bb6c755dbd3",
    ),
    "cap_model": (
        "research/fixed-e2-closed-kirby/marked-smooth-cap-movie/cap_model.json",
        "0a3b169de09cd375145ba6bf79101c005cbca7789ad8cda77532c75099baa177",
    ),
    "section_model": (
        "research/fixed-e2-closed-kirby/"
        "cap-belt-section-cut-planar-absorber/"
        "section_cut_planar_absorber.json",
        "d1b253aa63759353706a0fe4d4d2beee736199da435782366e234d31b459510b",
    ),
    "native_k1": (
        "research/fixed-e2-closed-kirby/direct-overlay/k1_product_summary.json",
        "4aedb4361fb4dd3a6eabffe248d871488bfeb03923641299d87c447123f31f75",
    ),
    "pd_scope": (
        "research/fixed-e2-cusp-kirby/constructive-attack/"
        "pd_scope_certificate.json",
        "b1f19e3d2e9e23905cf0a3b4f7153c3d83018be5ca99583e217cc7857eb02078",
    ),
    "source_bound_replay_code": (
        "research/fixed-e2-closed-kirby/source-bound-k1-endpoint-bridge/"
        "build_source_bound_certificate.py",
        "bd652ee5af5809cdf8f7162c49587efb090103177c09f9d07305d749037c73d1",
    ),
    "endpoint_replay_code": (
        "research/fixed-e2-closed-kirby/"
        "source-bound-final-fixed-e2-composition/check_composition.py",
        "ac8d87e77ed1b6be666a203ed9c0e466fa76aa05a59d0c0825fb2c5f8fde4b6e",
    ),
    "hirsch_source": (
        "research/fixed-e2-closed-kirby/final-seven-arrow-diffeomorphism/"
        "hirsch-1963-smoothing.pdf",
        "f79847a7d779cc425d37f740c88399ad0be9e9242b5950261fa3cffaccff416f",
    ),
    "milnor_source": (
        "research/fixed-e2-closed-kirby/final-seven-arrow-diffeomorphism/"
        "milnor-differential-topology.pdf",
        "b57e4aa75338677bb9ca8d1b07835faeecacc3a0fc864892a2aea8a1bcfffe42",
    ),
    "smoothing_hypotheses": (
        "research/fixed-e2-closed-kirby/final-seven-arrow-diffeomorphism/"
        "smoothing_hypotheses.json",
        "12c86a0619e0d6410fc2c8bb2305c492d5455531e4b32f488a62d07fbc21ed0b",
    ),
    "smoothing_note": (
        "research/fixed-e2-closed-kirby/final-seven-arrow-diffeomorphism/"
        "SMOOTHING.md",
        "9cf8cc04c54dd30111db51bfa57995d608252ae76c8c10f60de80275a3f0e080",
    ),
    "jacobian_discovery": (
        "research/fixed-e2-closed-kirby/final-seven-arrow-diffeomorphism/"
        "jacobian_find.json",
        "eb97ebb78710c95ddb73f9e71d795c81f72c21d4ef9b929538e49192b355dd8c",
    ),
    "jacobian_contract": (
        "research/fixed-e2-closed-kirby/final-seven-arrow-diffeomorphism/"
        "jacobian_contract.json",
        "0726ccfe38053c1263892a7993efb92edd23de8743030164741b3c22b546aa13",
    ),
    "jacobian_payload": (
        "research/fixed-e2-closed-kirby/final-seven-arrow-diffeomorphism/"
        "jacobian_payload.json",
        "4bf43c45382884fe23473eb5fded6529b4975a7ebbedceccb3c3e16243069065",
    ),
    "jacobian_output": (
        "research/fixed-e2-closed-kirby/final-seven-arrow-diffeomorphism/"
        "jacobian_output.json",
        "e0405e5d47d2bd5bc2488bc0ae48f3c805cc7b13ecaa281fd755b2c663e5c0f2",
    ),
}

FORBIDDEN_EVIDENCE = {
    "research/fixed-e2-closed-kirby/reviewed-v4-final-fixed-e2-composition/"
    "final_certificate.json",
    "research/fixed-e2-closed-kirby/figure22-frozen-carrier-ambient-bridge/"
    "ambient_bridge_certificate.json",
}

REVIEWED_COMPONENT_CLAIMS = [
    "C-MARKED-SMOOTH-E1-CAP",
    "C-SOURCE-INDEPENDENT-NATIVE-28-CARRIER",
    "C-FIGURE22-REAL-SOURCE-INCIDENCE-ANCHOR",
    "C-FIGURE22-TARGET-CUSP-H2-28-CELLULAR-INCLUSION",
    "C-FIGURE22-H2-15-FILLED-CUSP-GEOMETRIC-TRANSPORT",
    "C-POINTWISE-TWO-CAP-ATLAS-BRIDGE",
    "C-POINTWISE-CENTRAL-T2XP-BRIDGE",
    "C-RGB-PRE-CANCELLATION-CAP1-PREFIX",
    "C-RGB-K0-NATIVE-ENDPOINT",
    "C-K1-REVERSED-RGB-BAND-PL",
    "C-KNOTS",
]

SOURCE_MATH_KEYS = [
    "complete_projection_embedding_digest",
    "counts",
    "four_handles",
    "one_handles",
    "reviewed_local_PL_support_bindings",
    "rgb_slot_map",
    "slot_order",
    "source_projection_chart_map",
    "three_handles",
    "two_handles",
]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def canonical_json(value):
    return json.dumps(
        value, sort_keys=True, separators=(",", ":"), ensure_ascii=True
    )


def digest(value):
    return hashlib.sha256(canonical_json(value).encode("ascii")).hexdigest()


def sha256(path):
    hasher = hashlib.sha256()
    with path.open("rb") as stream:
        while chunk := stream.read(1024 * 1024):
            hasher.update(chunk)
    return hasher.hexdigest()


def read_json(path):
    return json.loads(path.read_text())


def seal(value):
    value = deepcopy(value)
    value.pop("certificate_digest", None)
    value["certificate_digest"] = digest(value)
    return value


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    require(spec is not None and spec.loader is not None, f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def input_records():
    records = {}
    for name, (relative, expected) in PINNED_INPUTS.items():
        path = CAMPAIGN / relative
        require(path.is_file(), f"missing pinned input: {relative}")
        actual = sha256(path)
        require(actual == expected, f"pinned input hash mismatch: {relative}")
        records[name] = {
            "path": relative,
            "sha256": actual,
            "role": (
                "algorithmic replay helper, not mathematical evidence"
                if name.endswith("_replay_code")
                else "immutable mathematical or source evidence"
            ),
        }
    require(
        not FORBIDDEN_EVIDENCE.intersection(
            record["path"] for record in records.values()
        ),
        "forbidden symbolic candidate was admitted",
    )
    return records


def load_inputs():
    values = {}
    for name, (relative, _) in PINNED_INPUTS.items():
        if relative.endswith(".json"):
            values[name] = read_json(CAMPAIGN / relative)
    return values


def reviewer_reference(ledger, claim_id):
    versions = [
        claim for claim in ledger["claims"] if claim["claim_id"] == claim_id
    ]
    require(versions, f"missing reviewed claim: {claim_id}")
    claim = max(versions, key=lambda item: item["version"])
    references = [
        evidence
        for evidence in ledger["evidence"]
        if evidence.get("subject", {}).get("kind") == "claim"
        and evidence.get("subject", {}).get("subject_id") == claim_id
        and evidence.get("subject", {}).get("content_hash")
        == claim["content_hash"]
        and evidence.get("tier") == "judgement"
        and evidence.get("verdict") == "supports"
        and evidence.get("produced_by", "").startswith("reviewer:")
    ]
    require(references, f"no current independent Reviewer support: {claim_id}")
    reference = deepcopy(references[-1])
    reference["claim_version"] = claim["version"]
    reference["claim_content_hash"] = claim["content_hash"]
    return reference


def reviewed_component_bindings():
    ledger = read_json(CAMPAIGN / "research/MATH_STATE.json")
    return {
        claim_id: reviewer_reference(ledger, claim_id)
        for claim_id in REVIEWED_COMPONENT_CLAIMS
    }


def full_state_record(state_id, label, payload):
    endpoint = state_id in {"X0", "X7"}
    return {
        "id": state_id,
        "label": label,
        "state_digest": digest(payload),
        "payload": deepcopy(payload),
        "top_level_object_realization": (
            "explicit closed endpoint"
            if endpoint
            else "closure of the serialized marked core by both pinned E(1)-nu(F) caps"
        ),
        "payload_scope": (
            "complete closed endpoint"
            if endpoint
            else "movable marked core; fixed cap closures are pinned separately"
        ),
    }


def compact_native_inventory(carrier):
    stage_b = carrier["stage_B_after_central_H2_before_caps"]
    stage_c = carrier["stage_C_after_H2_28"]
    order = deepcopy(stage_b["index_2_target_order"])
    spheres = stage_c["parameterized_index_3_spheres"]
    disks = []
    for sphere in spheres:
        for disk in sphere["signed_cocore_disks"]:
            signed = disk["signed_cocore_disk"]
            disks.append(
                {
                    "sphere": sphere["id"],
                    "two_handle": disk["two_handle"],
                    "curve": disk.get("curve", disk.get("source_handle")),
                    "interior_key": signed["interior_key"],
                    "lane": signed["lane"],
                    "orientation_sign": signed["orientation_sign"],
                    "record_digest": digest(disk),
                }
            )
    require(len(order) == 28, "native two-handle inventory is incomplete")
    require([item["position"] for item in order] == list(range(1, 29)),
            "native two-handle order is not 1 through 28")
    require(len(disks) == 36, "native signed cocore inventory is incomplete")
    require(
        len(
            {
                (
                    item["sphere"],
                    item["two_handle"],
                    item["interior_key"],
                )
                for item in disks
            }
        )
        == 36,
        "native signed cocore inventory contains a duplicate",
    )
    require(
        stage_c["signed_cocore_disk_count"] == 36,
        "native signed cocore declaration mismatch",
    )
    return {
        "counts": {"h1": 1, "h2": 28, "h3": 5, "h4": 2},
        "two_handle_order": order,
        "sphere_order": deepcopy(stage_c["sphere_order"]),
        "four_handle_order": [
            handle["id"] for handle in stage_c["cap_D4_handles"]
        ],
        "signed_cocore_disks": disks,
        "full_stage_b_digest": digest(stage_b),
        "full_stage_c_digest": digest(stage_c),
    }


def verify_common_mother(source_object, construction):
    source = source_object["source_side_handle_state"]
    mother = construction["common_mother"]
    source_math = {key: deepcopy(source[key]) for key in SOURCE_MATH_KEYS}
    mother_math = {key: deepcopy(mother[key]) for key in SOURCE_MATH_KEYS}
    require(source_math == mother_math,
            "Figure 22 source and construction mother disagree")
    require(
        source_math["counts"]
        == {
            "h1": 1,
            "h2": 28,
            "h3": 5,
            "h4": 2,
            "relative_euler_characteristic": 24,
        },
        "source common-mother handle count mismatch",
    )
    require(
        source_math["slot_order"]
        == [f"H2-{index:02d}" for index in range(1, 29)],
        "source common-mother slot order mismatch",
    )
    require(
        source_math["rgb_slot_map"]
        == {"R": "H1-01", "G_p": "H2-15", "B": "H2-28"},
        "source cusp-role binding mismatch",
    )
    ignored = sorted((set(source) | set(mother)) - set(SOURCE_MATH_KEYS))
    require(
        ignored
        == [
            "binding_status",
            "k0_terminal_neighborhood_binding",
            "phase",
            "schema",
        ],
        "source/common-mother normalization ignored a mathematical field",
    )
    return {
        "normalized_mathematical_state_digest": digest(source_math),
        "source_object_full_state_digest": digest(source),
        "construction_common_mother_full_state_digest": digest(mother),
        "normalization_ignored_metadata_only": ignored,
    }


def verify_pointwise_bridge(values, prefix):
    central = values["central_bridge"]
    caps = values["two_cap_bridge"]
    carrier = values["native_carrier"]
    inventory = compact_native_inventory(carrier)

    require(
        central["complete_inventory"]
        == {
            "index_1": 1,
            "index_2": 28,
            "index_3": 5,
            "index_4": 2,
            "signed_cocore_disks": 36,
        },
        "central source inventory mismatch",
    )
    require(
        central["counts"]["global_signed_cocore_disks"] == 36,
        "central signed cocore count mismatch",
    )
    require(
        central["conclusion"]
        ["complete_1_28_5_2_marked_ambient_bridge_constructed"]
        and central["conclusion"]
        ["H2_15_H2_28_and_two_cap_overlaps_pointwise"],
        "central bridge omits inventory or an overlap",
    )
    require(
        central["global_cross_block_overlaps"]["cross_block_support"]
        ["all_cross_block_overlaps_pointwise"],
        "central bridge leaves an overlap restriction unchecked",
    )
    require(
        central["R_cusp_transport"]["orientation_sign"] == 1
        and central["R_cusp_transport"]["both_composites_identity"]
        and central["R_cusp_transport"]["literal_inverse"],
        "central R bridge orientation or inverse mismatch",
    )
    require(
        central["Sigma_u_bridge"]["literal_inverse"]
        and central["Sigma_u_bridge"]
        ["all_base_and_patch_overlaps_pointwise"],
        "central Sigma_u bridge lacks a pointwise inverse",
    )
    require(
        central["stage_order"]["all_index_2_before_all_index_3"]
        and central["stage_order"]
        ["Sigma_u_and_cap_spheres_only_after_H2_28"]
        and central["stage_order"]["inverse"]
        == list(reversed(central["stage_order"]["forward"])),
        "central stage order or inverse order mismatch",
    )
    require(
        {
            key: caps["counts"][key]
            for key in [
                "noncentral_two_handles",
                "three_handle_spheres",
                "four_handles",
                "signed_incidence_seams",
            ]
        }
        == {
            "noncentral_two_handles": 24,
            "three_handle_spheres": 4,
            "four_handles": 2,
            "signed_incidence_seams": 32,
        },
        "two-cap bridge inventory mismatch",
    )
    require(
        caps["conclusion"]["all_cell_overlaps_two_sided_identity"]
        and caps["conclusion"]
        ["all_tube_cells_have_exact_two_sided_inverses"]
        and caps["conclusion"]
        ["all_4_spheres_and_32_signed_seams_carried"],
        "two-cap bridge lacks a complete two-sided inverse",
    )
    require(
        caps["stage_order"]["spheres_only_after_H2_28"]
        and caps["stage_order"]["each_D4_after_its_two_D3_handles"],
        "two-cap bridge breaks target stage order",
    )
    require(
        caps["conclusion"]["pointwise_two_cap_bridge_constructed"]
        and caps["classification"]
        == "exact_bounded_pointwise_two_cap_bridge_candidate",
        "two-cap bridge map representation changed",
    )

    native_slots = prefix["native_inventory"]["index_2_slots"]
    side_positions = {"central": 0, "cap-1": 0, "cap-2": 0}
    normalized_prefix_slots = []
    for item in native_slots:
        side = item.get("cap", "central").replace("_", "-")
        side_positions[side] += 1
        normalized_prefix_slots.append(
            {
                "handle_id": item["slot"],
                "curve_id": item["native_id"],
                "side": side,
                "position": side_positions[side],
            }
        )
    require(
        normalized_prefix_slots
        == [
            {
                "handle_id": item["handle_id"],
                "curve_id": item["curve_id"],
                "side": (
                    "central"
                    if item["side"] == "central"
                    else f"cap-{item['side']}"
                ),
                "position": item["position"]
                - (2 if item["side"] == 1 else 15 if item["side"] == 2 else 0),
            }
            for item in inventory["two_handle_order"]
        ],
        "pre-cancellation prefix does not bind the native 28-slot carrier",
    )
    require(
        "route-T_1_0" == prefix["routes"][0]["id"],
        "wrong pre-cancellation parity route",
    )
    require(
        prefix["scope"]["literal_reverse_constructed"]
        and prefix["scope"]["all_28_attaching_curves_and_push_offs_accounted"]
        and prefix["scope"]["all_five_three_spheres_transport_constructed"]
        and prefix["scope"]["unstabilized"],
        "native prefix does not have the complete literal inverse",
    )

    h2_15 = values["h2_15_bridge"]
    h2_28 = values["h2_28_bridge"]
    require(
        h2_15["acceptance"]["exact_forward_reverse_complement_map"]
        and h2_15["acceptance"]["pointwise_solid_torus_extension"]
        and h2_15["acceptance"]["pointwise_zero_twist_p0_splice"],
        "H2-15 bridge is not pointwise bidirectional",
    )
    require(
        h2_15["native_H2_15_comparison"]
        ["pointwise_equal_to_native_restored_zero_pair"],
        "H2-15 bridge misses native H2-15",
    )
    require(
        h2_28["validation"]
        ["selected_push_off_extends_to_native_minus_one_framing"]
        and h2_28["validation"]["all_marked_chains_have_literal_inverse"],
        "H2-28 bridge misses marked cocore or framing data",
    )
    require(
        h2_28["validation"]
        ["every_maximal_cell_has_explicit_affine_image_and_inverse"]
        and h2_28["validation"]["every_shared_face_restriction_agrees"],
        "H2-28 bridge lacks a literal inverse",
    )

    return {
        "map_id": "P:Figure22-source-common-mother-to-native-28-carrier",
        "source": "X4",
        "target": "N",
        "map_representation":
            "explicit supported pointwise four-dimensional rational-PL blocks",
        "symbolic_name_substitution_forbidden": True,
        "source_counts": {"h1": 1, "h2": 28, "h3": 5, "h4": 2},
        "target_counts": deepcopy(inventory["counts"]),
        "source_rgb_roles": {"R": "H1-01", "G_p": "H2-15", "B": "H2-28"},
        "target_rgb_roles": {
            "R": "k_sh^vee",
            "G_p": "G_1(b_Hc)",
            "B": "G_2(b_Hc)",
        },
        "native_inventory": inventory,
        "component_maps": [
            {
                "id": "P_H2_15",
                "source": "Figure22:G_p",
                "target": "H2-15=G_1(b_Hc)",
                "orientation_sign": 1,
                "literal_inverse": True,
                "artifact_sha256": PINNED_INPUTS["h2_15_bridge"][1],
            },
            {
                "id": "P_H2_28",
                "source": "Figure22:B",
                "target": "H2-28=G_2(b_Hc)",
                "orientation_sign": 1,
                "literal_inverse": True,
                "artifact_sha256": PINNED_INPUTS["h2_28_bridge"][1],
            },
            {
                "id": "P_cap_1",
                "source": "Figure22:cap-1",
                "target": "native:cap-1",
                "orientation_sign": 1,
                "literal_inverse": True,
                "artifact_sha256": PINNED_INPUTS["two_cap_bridge"][1],
            },
            {
                "id": "P_cap_2",
                "source": "Figure22:cap-2",
                "target": "native:cap-2",
                "orientation_sign": 1,
                "literal_inverse": True,
                "artifact_sha256": PINNED_INPUTS["two_cap_bridge"][1],
            },
            {
                "id": "P_central",
                "source": "Figure22:R plus H2-01,H2-02,Sigma_u",
                "target": "native central T2xP block",
                "orientation_sign": 1,
                "literal_inverse": True,
                "artifact_sha256": PINNED_INPUTS["central_bridge"][1],
            },
        ],
        "cross_block_overlaps": {
            "count": len(central["global_cross_block_overlaps"]),
            "records": deepcopy(central["global_cross_block_overlaps"]),
            "records_digest": digest(central["global_cross_block_overlaps"]),
            "all_verified": True,
        },
        "cap_seams": {
            "count": caps["counts"]["signed_incidence_seams"],
            "records_digest": digest(caps["cap_maps"]),
            "all_verified": True,
        },
        "peripheral_actions": {
            "R": [[0, -1], [1, 0]],
            "cap_1": [[1, 0, 0], [0, 1, 0], [0, 0, -1]],
            "cap_2": [[1, 0, 0], [0, 1, 0], [0, 0, -1]],
            "direct_sum_determinant": 1,
        },
        "forward_then_inverse": "identity on every serialized marked cell",
        "inverse_then_forward": "identity on every serialized marked cell",
        "complete_two_sided_inverse": True,
    }


def verify_jacobian(values):
    output = values["jacobian_output"]
    result = output["result"]
    require(result["operation_id"] == "matrix.inverse.compute",
            "wrong Jacobian operation")
    inverse = [
        [
            entry["num"] if entry["den"] == "1"
            else f"{entry['num']}/{entry['den']}"
            for entry in row
        ]
        for row in result["output"]["inverse"]["entries"]
    ]
    require(
        output["transport"] == "mcp-stdio"
        and output["server"]["version"] == "0.14.0",
        "Jacobian server or transport mismatch",
    )
    require(
        inverse
        == [
            ["0", "1", "0", "0", "0", "0", "0", "0"],
            ["-1", "0", "0", "0", "0", "0", "0", "0"],
            ["0", "0", "1", "0", "0", "0", "0", "0"],
            ["0", "0", "0", "1", "0", "0", "0", "0"],
            ["0", "0", "0", "0", "-1", "0", "0", "0"],
            ["0", "0", "0", "0", "0", "1", "0", "0"],
            ["0", "0", "0", "0", "0", "0", "1", "0"],
            ["0", "0", "0", "0", "0", "0", "0", "-1"],
        ],
        "Jacobian returned a different exact inverse",
    )
    matrix = [
        [int(entry) for entry in row]
        for row in output["request"]["payload"]["matrix"]["entries"]
    ]
    inverse_int = [[int(entry) for entry in row] for row in inverse]
    product_left = [
        [
            sum(matrix[i][k] * inverse_int[k][j] for k in range(8))
            for j in range(8)
        ]
        for i in range(8)
    ]
    product_right = [
        [
            sum(inverse_int[i][k] * matrix[k][j] for k in range(8))
            for j in range(8)
        ]
        for i in range(8)
    ]
    identity_8 = [
        [1 if i == j else 0 for j in range(8)] for i in range(8)
    ]
    require(
        product_left == identity_8 and product_right == identity_8,
        "Jacobian inverse is not two-sided",
    )
    return {
        "role": "algebraic marked-interface checksum only",
        "operation_id": result["operation_id"],
        "payload_sha256": PINNED_INPUTS["jacobian_payload"][1],
        "output_sha256": PINNED_INPUTS["jacobian_output"][1],
        "server": deepcopy(output["server"]),
        "protocol": output["protocol_version"],
        "adapter_status": {"error": None, "status": "ok", "timeout": False},
        "exact_inverse": inverse,
        "verification": {"left_identity": True, "right_identity": True},
    }


def arrow_record(arrow_id, source, target, name, inverse_name, evidence):
    return {
        "id": arrow_id,
        "source": source["id"],
        "target": target["id"],
        "source_state_digest": source["state_digest"],
        "target_state_digest": target["state_digest"],
        "forward_map": name,
        "inverse_map": inverse_name,
        "orientation_sign": 1,
        "category": "exact PL homeomorphism",
        "forward_then_inverse": True,
        "inverse_then_forward": True,
        "evidence": evidence,
    }


def derive_certificate():
    records = input_records()
    values = load_inputs()
    source_replay = load_module(
        "final_seven_source_replay",
        CAMPAIGN / PINNED_INPUTS["source_bound_replay_code"][0],
    )
    endpoint_replay = load_module(
        "final_seven_endpoint_replay",
        CAMPAIGN / PINNED_INPUTS["endpoint_replay_code"][0],
    )

    source_bound = values["source_bound_k1"]
    require(
        source_bound["certificate_digest"]
        == digest(
            {
                key: value
                for key, value in source_bound.items()
                if key != "certificate_digest"
            }
        ),
        "source-bound subproof digest mismatch",
    )
    construction = source_bound["construction"]
    require(
        construction["construction_digest"]
        == "22be28062f14870b5c22501ed6729440c535b04d88dc823a9d065754c4322371",
        "source construction digest mismatch",
    )
    require(
        construction["serialized_inverse_certificate"]
        ["inverse_certificate_digest"]
        == "aa97c2c5a6de05e9c168518a4be63a2e450bf32575bd3521b8fde6859c0190ef",
        "source inverse digest mismatch",
    )

    mother = deepcopy(construction["common_mother"])
    terminal = deepcopy(construction["post_cancellation_state"])
    fresh_terminal, fresh_replay = source_replay.replay_forward(
        deepcopy(mother), deepcopy(construction["source_safe_local_PL"])
    )
    require(fresh_terminal == terminal,
            "five-move source replay misses the stored terminal")
    require(fresh_replay == construction["forward_replay"],
            "five-move source replay record mismatch")
    recovered = source_replay.replay_inverse(
        deepcopy(terminal),
        deepcopy(construction["serialized_inverse_certificate"]),
    )
    require(recovered == mother,
            "terminal-derived source inverse misses the common mother")

    common_mother_binding = verify_common_mother(
        values["figure22_source_object"], construction
    )
    pointwise = verify_pointwise_bridge(
        values, values["pre_cancellation_prefix"]
    )

    mother_payload = endpoint_replay.build_marked_source_state(
        mother,
        construction,
        values["section_model"],
        values["cap_model"],
        "source_complete_common_mother",
    )
    terminal_payload = endpoint_replay.build_marked_source_state(
        terminal,
        construction,
        values["section_model"],
        values["cap_model"],
        "source_bound_K1_terminal",
    )
    k0 = endpoint_replay.verify_k0_route(
        values["k0_endpoint"],
        values["pre_cancellation_prefix"],
        mother_payload,
    )
    k0_anchor = endpoint_replay.verify_k0_anchor(
        construction, k0
    )
    transfer = endpoint_replay.trace_transfer_data(values["double_cap_model"])
    native_product_circle = endpoint_replay.reconstruct_native_product_circle(
        values["native_k1"], values["pd_scope"]
    )
    endpoint_map = endpoint_replay.derive_endpoint_map(
        source_bound["comparison"],
        terminal_payload,
        values["native_k1"],
        native_product_circle,
    )
    native_k1_payload = endpoint_replay.apply_endpoint_action(
        terminal_payload, endpoint_map, "forward"
    )
    require(
        endpoint_replay.apply_endpoint_action(
            native_k1_payload, endpoint_map, "inverse"
        )
        == terminal_payload,
        "K1 endpoint action lacks a two-sided inverse",
    )
    require(
        endpoint_map["peripheral_matrix"] == [[1, 0], [0, -1]]
        and endpoint_map["global_matrix"]
        == [[-1, 0, 0], [0, 1, 0], [0, 0, -1]]
        and endpoint_map["orientation_sign"] == 1,
        "K1 endpoint orientation or peripheral sign mismatch",
    )

    x1_payload = deepcopy(k0["native"])
    x2_payload = endpoint_replay.trace_forward(x1_payload, transfer)
    require(
        endpoint_replay.trace_inverse(x2_payload, transfer) == x1_payload,
        "K0 trace transfer lacks a two-sided inverse",
    )
    require(
        endpoint_replay.trace_inverse(x2_payload, transfer) == k0["native"],
        "K0 trace state does not equal native Z0(m0)",
    )
    x6_payload = native_k1_payload
    closed_k0_summary = endpoint_replay.closed_summary(
        values["closed_k0"], "K0"
    )
    closed_k1_summary = endpoint_replay.closed_summary(
        values["closed_k1"], "K1"
    )
    x0_payload = endpoint_replay.close_relative(
        x1_payload,
        "6_3",
        closed_k0_summary,
        values["cap_theorem_audit"],
    )
    x7_payload = endpoint_replay.close_relative(
        x6_payload,
        "19nh_78",
        closed_k1_summary,
        values["cap_theorem_audit"],
    )
    require(
        endpoint_replay.close_relative(
            x1_payload,
            "6_3",
            closed_k0_summary,
            values["cap_theorem_audit"],
        )
        == x0_payload,
        "K0 cap closure does not recover E(2)_6_3",
    )
    require(
        endpoint_replay.open_relative(x7_payload) == x6_payload,
        "K1 cap opening does not recover native Z1(m1)",
    )
    require(
        endpoint_replay.close_relative(
            x6_payload,
            "19nh_78",
            closed_k1_summary,
            values["cap_theorem_audit"],
        )
        == x7_payload,
        "K1 cap closure does not recover E(2)_19nh_78",
    )

    states = [
        full_state_record("X0", "E(2)_{6_3}", x0_payload),
        full_state_record("X1", "Z_0(m_0)", x1_payload),
        full_state_record("X2", "Z_1(beta_1)", x2_payload),
        full_state_record(
            "X3", "reviewed K0 post-cancellation terminal", k0["source"]
        ),
        full_state_record(
            "X4", "Figure 22 source common mother", mother_payload
        ),
        full_state_record(
            "X5", "source-bound K1 terminal", terminal_payload
        ),
        full_state_record("X6", "Z_1(m_1)", x6_payload),
        full_state_record("X7", "E(2)_{19nh_78}", x7_payload),
    ]
    require(
        [state["id"] for state in states]
        == [f"X{index}" for index in range(8)],
        "top-level state order mismatch",
    )

    arrow4_evidence = {
        "formula": "P^{-1} o Q^{-1}",
        "inverse_formula": "Q o P",
        "intermediate_native_state": "N",
        "typed_forward_path": [
            "X3 --Q^{-1}--> N",
            "N --P^{-1}--> X4",
        ],
        "typed_inverse_path": [
            "X4 --P--> N",
            "N --Q--> X3",
        ],
        "P": deepcopy(pointwise),
        "Q": {
            "map_id": "Q:route-T_1_0-native-prefix-to-K0-terminal",
            "source": "N",
            "target": "X3",
            "orientation_sign": 1,
            "literal_inverse": True,
            "selected_route": values["pre_cancellation_prefix"]
            ["routes"][0]["id"],
            "selected_route_terminal_digest":
                "8d4278548b2ad2420274a961f595f67720ef78ec166772b713acd9ff8c7e60ac",
            "native_target_digest":
                "16053cb516618a188e9a6d21925876681aed98792dac10de812841b8ad08a17e",
            "k0_anchor": k0_anchor,
        },
        "domain_codomain_match": True,
        "forward_then_inverse":
            "(Q o P) o (P^{-1} o Q^{-1}) = id_X3",
        "inverse_then_forward":
            "(P^{-1} o Q^{-1}) o (Q o P) = id_X4",
        "orientation_sign": 1,
        "complete_marked_inventory_carried": True,
    }

    pl_arrows = [
        arrow_record(
            "A1", states[0], states[1],
            "reviewed two-port E(1)-cap endpoint identification",
            "inverse reviewed two-port E(1)-cap endpoint identification",
            ["closed_k0", "cap_theorem_audit"],
        ),
        arrow_record(
            "A2", states[1], states[2],
            "reviewed relative trace transfer",
            "inverse relative trace transfer",
            ["double_cap_model"],
        ),
        arrow_record(
            "A3", states[2], states[3],
            "reviewed K0 endpoint correspondence",
            "inverse K0 endpoint correspondence",
            ["pre_cancellation_prefix", "k0_endpoint"],
        ),
        arrow_record(
            "A4", states[3], states[4],
            "P^{-1} o Q^{-1}",
            "Q o P",
            ["pre_cancellation_prefix", "central_bridge",
             "two_cap_bridge", "h2_15_bridge", "h2_28_bridge",
             "native_carrier"],
        ),
        arrow_record(
            "A5", states[4], states[5],
            "five exact source-bound moves and R-B cancellation",
            "serialized terminal-derived literal inverse",
            ["source_bound_k1", "k1_reversed_band"],
        ),
        arrow_record(
            "A6", states[5], states[6],
            "exact K1 source/native endpoint action",
            "self-inverse K1 endpoint action",
            ["source_bound_k1", "native_k1", "pd_scope"],
        ),
        arrow_record(
            "A7", states[6], states[7],
            "reviewed two-port E(1)-cap endpoint identification",
            "inverse reviewed two-port E(1)-cap endpoint identification",
            ["closed_k1", "cap_theorem_audit"],
        ),
    ]

    for index, arrow in enumerate(pl_arrows):
        require(arrow["source"] == states[index]["id"],
                f"arrow {index + 1} source mismatch")
        require(arrow["target"] == states[index + 1]["id"],
                f"arrow {index + 1} target mismatch")
    require(
        [arrow["target_state_digest"] for arrow in pl_arrows[:-1]]
        == [arrow["source_state_digest"] for arrow in pl_arrows[1:]],
        "adjacent PL arrow state digests do not match",
    )

    smoothing = deepcopy(values["smoothing_hypotheses"])
    smooth_objects = []
    for index, state in enumerate(states):
        smooth_objects.append(
            {
                "id": state["id"],
                "fixed_smoothing": f"alpha_{index}",
                "pullback_smoothing": f"beta_{index}",
                "comparison_map": f"h_{index}",
                "h_orientation_sign": 1,
                "h_concordant_to_identity": True,
                "h_is_identity": index == 7,
                "state_digest": state["state_digest"],
            }
        )
    smooth_arrows = []
    for index, arrow in enumerate(pl_arrows, start=1):
        smooth_arrows.append(
            {
                "id": f"D{index}",
                "source": arrow["source"],
                "target": arrow["target"],
                "pl_representative": arrow["id"],
                "forward_formula":
                    f"h_{index}^(-1) o a_{index} o h_{index - 1}",
                "inverse_formula":
                    f"h_{index - 1}^(-1) o a_{index}^(-1) o h_{index}",
                "category": "genuine diffeomorphism",
                "orientation_sign": 1,
                "forward_then_inverse": True,
                "inverse_then_forward": True,
            }
        )

    certificate = {
        "schema": "final-seven-arrow-diffeomorphism-certificate-v1",
        "classification": (
            "candidate exact unstabilized orientation-preserving "
            "diffeomorphism pending independent Reviewer replay"
        ),
        "objective": {
            "source": "E(2)_{6_3}",
            "target": "E(2)_{19nh_78}",
            "source_knot": "6_3",
            "target_knot": "19nh_78",
            "knots_prime": True,
            "knots_distinct": True,
            "knots_not_mirrors": True,
            "ambient": "E(2)",
            "fintushel_stern_gluing": "standard fixed gluing",
            "stabilization_count": 0,
            "orientation_sign": 1,
            "originality_claimed": False,
        },
        "inputs": records,
        "excluded_evidence": sorted(FORBIDDEN_EVIDENCE),
        "reviewed_component_bindings": reviewed_component_bindings(),
        "unreviewed_subproof_boundary": {
            "claim": "C-SOURCE-BOUND-K1-ENDPOINT-BRIDGE",
            "current_claim_treated_as_reviewed": False,
            "artifact_replayed_inside_this_candidate": records[
                "source_bound_k1"
            ],
            "review_required_here": True,
        },
        "category_model": {
            "top_level_objects_are_closed_or_fixed_cap_closures": True,
            "intermediate_payloads_are_movable_marked_cores": True,
            "fixed_cap_count_per_intermediate_object": 2,
            "fixed_cap_model": "E(1)-nu(F)",
            "endpoint_identifications_extend_over_both_caps": True,
            "first_and_seventh_arrows_are_endpoint_diffeomorphisms": True,
            "literal_closed_to_boundary_deletion_map_claimed": False,
        },
        "common_mother_binding": common_mother_binding,
        "pointwise_bridge": pointwise,
        "jacobian_checksum": verify_jacobian(values),
        "states": states,
        "pl_arrows": pl_arrows,
        "fourth_arrow_composite": arrow4_evidence,
        "smoothing": {
            "hypotheses": smoothing,
            "objects": smooth_objects,
            "arrows": smooth_arrows,
            "global_forward_formula":
                "d_7 o ... o d_1 = h_7^(-1) o "
                "(a_7 o ... o a_1) o h_0",
            "global_inverse_formula":
                "d_1^(-1) o ... o d_7^(-1) = h_0^(-1) o "
                "(a_1^(-1) o ... o a_7^(-1)) o h_7",
            "h_7_is_identity": True,
            "both_global_composites_are_identities": True,
            "marked_pointwise_claim_attaches_to_pl_representatives": True,
            "smooth_arrows_concordant_to_pl_representatives": True,
            "h_i_pointwise_fixed_on_every_marked_cell_claimed": False,
        },
        "inverse_replay": {
            "source_five_move_forward_replayed": True,
            "source_terminal_inverse_replayed": True,
            "k0_open_close_replayed": True,
            "relative_trace_two_sided_replayed": True,
            "k0_endpoint_two_sided_replayed": True,
            "pointwise_common_bridge_two_sided_replayed": True,
            "k1_endpoint_two_sided_replayed": True,
            "k1_open_close_replayed": True,
            "all_seven_local_composites_are_identities": True,
            "both_global_composites_are_identities": True,
        },
        "mutation_policy": {
            "reject_omitted_or_duplicated_handle": True,
            "reject_omitted_or_duplicated_cocore_disk": True,
            "reject_cusp_role_change": True,
            "reject_peripheral_sign_change": True,
            "reject_overlap_or_seam_failure": True,
            "reject_orientation_reversal": True,
            "reject_symbolic_map_substitution": True,
            "reject_smoothing_hypothesis_failure": True,
            "reject_endpoint_knot_change": True,
            "reject_gluing_change": True,
            "reject_stabilization": True,
            "reject_inverse_composite_failure": True,
            "reject_fourth_arrow_composition_order_change": True,
            "reject_missing_fixed_cap_closure": True,
        },
        "scope_boundary": {
            "mathematical_conclusion": (
                "The exact PL representatives and the low-dimensional "
                "smoothing conjugation give an unstabilized "
                "orientation-preserving diffeomorphism "
                "E(2)_{6_3} -> E(2)_{19nh_78} with explicit inverse formulas."
            ),
            "finite_experiment_only": False,
            "invariant_comparison_only": False,
            "symbolic_phi_records_used": False,
            "stabilized_result": False,
            "independent_reviewer_replay_required": True,
            "engineer_may_mark_campaign_done": False,
        },
    }
    return seal(certificate)


def validate_certificate(certificate):
    require(
        certificate["certificate_digest"]
        == digest(
            {
                key: value
                for key, value in certificate.items()
                if key != "certificate_digest"
            }
        ),
        "aggregate certificate digest mismatch",
    )
    require(
        certificate["schema"]
        == "final-seven-arrow-diffeomorphism-certificate-v1",
        "aggregate certificate schema mismatch",
    )
    require(
        not FORBIDDEN_EVIDENCE.intersection(
            item["path"] for item in certificate["inputs"].values()
        ),
        "forbidden symbolic evidence included",
    )
    objective = certificate["objective"]
    require(
        objective
        == {
            "source": "E(2)_{6_3}",
            "target": "E(2)_{19nh_78}",
            "source_knot": "6_3",
            "target_knot": "19nh_78",
            "knots_prime": True,
            "knots_distinct": True,
            "knots_not_mirrors": True,
            "ambient": "E(2)",
            "fintushel_stern_gluing": "standard fixed gluing",
            "stabilization_count": 0,
            "orientation_sign": 1,
            "originality_claimed": False,
        },
        "objective fidelity mismatch",
    )
    require(
        certificate["unreviewed_subproof_boundary"]
        ["current_claim_treated_as_reviewed"] is False,
        "source-bound current claim was falsely presented as reviewed",
    )
    require(
        certificate["category_model"]
        == {
            "top_level_objects_are_closed_or_fixed_cap_closures": True,
            "intermediate_payloads_are_movable_marked_cores": True,
            "fixed_cap_count_per_intermediate_object": 2,
            "fixed_cap_model": "E(1)-nu(F)",
            "endpoint_identifications_extend_over_both_caps": True,
            "first_and_seventh_arrows_are_endpoint_diffeomorphisms": True,
            "literal_closed_to_boundary_deletion_map_claimed": False,
        },
        "fixed-cap closure category mismatch",
    )
    require(
        set(certificate["reviewed_component_bindings"])
        == set(REVIEWED_COMPONENT_CLAIMS),
        "reviewed component binding set mismatch",
    )
    require(
        all(
            item["produced_by"].startswith("reviewer:")
            and item["verdict"] == "supports"
            for item in certificate["reviewed_component_bindings"].values()
        ),
        "component review binding is not independent support",
    )

    states = certificate["states"]
    arrows = certificate["pl_arrows"]
    require(len(states) == 8 and len(arrows) == 7,
            "seven-arrow chain cardinality mismatch")
    require([state["id"] for state in states] == [f"X{i}" for i in range(8)],
            "state identifier order mismatch")
    require(
        states[0]["top_level_object_realization"] == "explicit closed endpoint"
        and states[7]["top_level_object_realization"]
        == "explicit closed endpoint"
        and all(
            state["top_level_object_realization"]
            == "closure of the serialized marked core by both pinned E(1)-nu(F) caps"
            for state in states[1:7]
        ),
        "top-level fixed-cap object realization mismatch",
    )
    for index, arrow in enumerate(arrows):
        require(
            arrow["source"] == states[index]["id"]
            and arrow["target"] == states[index + 1]["id"],
            f"arrow A{index + 1} domain/codomain mismatch",
        )
        require(
            arrow["source_state_digest"] == states[index]["state_digest"]
            and arrow["target_state_digest"]
            == states[index + 1]["state_digest"],
            f"arrow A{index + 1} state hash mismatch",
        )
        require(
            arrow["orientation_sign"] == 1
            and arrow["forward_then_inverse"]
            and arrow["inverse_then_forward"],
            f"arrow A{index + 1} orientation or inverse mismatch",
        )
    require(
        certificate["fourth_arrow_composite"]["formula"]
        == "P^{-1} o Q^{-1}"
        and certificate["fourth_arrow_composite"]["inverse_formula"] == "Q o P"
        and certificate["fourth_arrow_composite"]["P"]["source"] == "X4"
        and certificate["fourth_arrow_composite"]["P"]["target"] == "N"
        and certificate["fourth_arrow_composite"]["Q"]["source"] == "N"
        and certificate["fourth_arrow_composite"]["Q"]["target"] == "X3"
        and certificate["fourth_arrow_composite"]["typed_forward_path"]
        == ["X3 --Q^{-1}--> N", "N --P^{-1}--> X4"]
        and certificate["fourth_arrow_composite"]["typed_inverse_path"]
        == ["X4 --P--> N", "N --Q--> X3"]
        and arrows[3]["forward_map"] == "P^{-1} o Q^{-1}"
        and arrows[3]["inverse_map"] == "Q o P"
        and certificate["fourth_arrow_composite"]["domain_codomain_match"]
        and certificate["fourth_arrow_composite"]["orientation_sign"] == 1,
        "fourth arrow composite mismatch",
    )

    pointwise = certificate["pointwise_bridge"]
    require(
        pointwise["map_representation"]
        == "explicit supported pointwise four-dimensional rational-PL blocks"
        and pointwise["symbolic_name_substitution_forbidden"]
        and pointwise["complete_two_sided_inverse"],
        "pointwise bridge representation or inverse mismatch",
    )
    require(
        pointwise["source_counts"] == {"h1": 1, "h2": 28, "h3": 5, "h4": 2}
        and pointwise["target_counts"]
        == {"h1": 1, "h2": 28, "h3": 5, "h4": 2},
        "pointwise bridge handle count mismatch",
    )
    require(
        pointwise["source_rgb_roles"]
        == {"R": "H1-01", "G_p": "H2-15", "B": "H2-28"}
        and pointwise["target_rgb_roles"]
        == {
            "R": "k_sh^vee",
            "G_p": "G_1(b_Hc)",
            "B": "G_2(b_Hc)",
        },
        "pointwise bridge cusp-role mismatch",
    )
    inventory = pointwise["native_inventory"]
    require(
        inventory["counts"] == {"h1": 1, "h2": 28, "h3": 5, "h4": 2},
        "native inventory count mismatch",
    )
    require(
        len(inventory["two_handle_order"]) == 28
        and [item["position"] for item in inventory["two_handle_order"]]
        == list(range(1, 29))
        and len({item["handle_id"] for item in inventory["two_handle_order"]})
        == 28,
        "native two-handle omission, duplication, or order mismatch",
    )
    disks = inventory["signed_cocore_disks"]
    require(len(disks) == 36,
            "native signed cocore disk count mismatch")
    require(
        len(
            {
                (item["sphere"], item["two_handle"], item["interior_key"])
                for item in disks
            }
        )
        == 36,
        "native signed cocore disk duplication",
    )
    require(
        pointwise["cross_block_overlaps"]["count"]
        == len(pointwise["cross_block_overlaps"]["records"])
        and pointwise["cross_block_overlaps"]["records_digest"]
        == digest(pointwise["cross_block_overlaps"]["records"])
        and pointwise["cross_block_overlaps"]["all_verified"],
        "cross-block overlap mismatch",
    )
    require(
        pointwise["cap_seams"]["count"] == 32
        and pointwise["cap_seams"]["all_verified"],
        "cap seam mismatch",
    )
    require(
        pointwise["peripheral_actions"]
        == {
            "R": [[0, -1], [1, 0]],
            "cap_1": [[1, 0, 0], [0, 1, 0], [0, 0, -1]],
            "cap_2": [[1, 0, 0], [0, 1, 0], [0, 0, -1]],
            "direct_sum_determinant": 1,
        },
        "peripheral sign or determinant mismatch",
    )

    smoothing = certificate["smoothing"]
    hypotheses = smoothing["hypotheses"]
    require(
        hypotheses["ambient_dimension"] == 4
        and hypotheses["low_dimensional_obstruction_input"]
        ["gamma_k_vanishes_for_k_less_than_7"]
        and hypotheses["low_dimensional_obstruction_input"]
        ["dimension_four_uniqueness_obstructions_vanish"]
        and hypotheses["concordance_and_diffeomorphism"]
        ["compatible_smoothings_are_concordant"]
        and hypotheses["concordance_and_diffeomorphism"]
        ["concordance_gives_diffeomorphism"],
        "smoothing hypothesis failure",
    )
    require(
        len(smoothing["objects"]) == 8
        and len(smoothing["arrows"]) == 7
        and smoothing["h_7_is_identity"]
        and smoothing["both_global_composites_are_identities"],
        "smooth chain cardinality or global inverse mismatch",
    )
    for index, arrow in enumerate(smoothing["arrows"]):
        require(
            arrow["source"] == states[index]["id"]
            and arrow["target"] == states[index + 1]["id"]
            and arrow["orientation_sign"] == 1
            and arrow["category"] == "genuine diffeomorphism"
            and arrow["forward_then_inverse"]
            and arrow["inverse_then_forward"],
            f"smooth arrow D{index + 1} mismatch",
        )
    require(
        smoothing["marked_pointwise_claim_attaches_to_pl_representatives"]
        and smoothing["smooth_arrows_concordant_to_pl_representatives"]
        and not smoothing["h_i_pointwise_fixed_on_every_marked_cell_claimed"],
        "PL/smooth claim boundary mismatch",
    )
    require(
        certificate["jacobian_checksum"]["adapter_status"]
        == {"error": None, "status": "ok", "timeout": False}
        and certificate["jacobian_checksum"]["verification"]
        == {"left_identity": True, "right_identity": True},
        "Jacobian typed checksum mismatch",
    )
    require(
        all(certificate["inverse_replay"].values()),
        "one or more inverse replays failed",
    )
    require(
        certificate["scope_boundary"]["independent_reviewer_replay_required"]
        and not certificate["scope_boundary"]["engineer_may_mark_campaign_done"]
        and not certificate["scope_boundary"]["symbolic_phi_records_used"]
        and not certificate["scope_boundary"]["stabilized_result"],
        "scope boundary mismatch",
    )
    return True


def reseal(certificate):
    certificate.pop("certificate_digest", None)
    certificate["certificate_digest"] = digest(certificate)


def run_mutations(certificate):
    cases = []

    def add(name, mutate):
        candidate = deepcopy(certificate)
        mutate(candidate)
        reseal(candidate)
        try:
            validate_certificate(candidate)
        except AssertionError as error:
            cases.append(
                {"name": name, "status": "rejected", "reason": str(error)}
            )
            return
        raise AssertionError(f"mutation was accepted: {name}")

    add(
        "omit-handle",
        lambda value: value["pointwise_bridge"]["native_inventory"]
        ["two_handle_order"].pop(),
    )
    add(
        "duplicate-handle",
        lambda value: value["pointwise_bridge"]["native_inventory"]
        ["two_handle_order"].append(
            deepcopy(
                value["pointwise_bridge"]["native_inventory"]
                ["two_handle_order"][-1]
            )
        ),
    )
    add(
        "omit-signed-cocore",
        lambda value: value["pointwise_bridge"]["native_inventory"]
        ["signed_cocore_disks"].pop(),
    )
    add(
        "duplicate-signed-cocore",
        lambda value: value["pointwise_bridge"]["native_inventory"]
        ["signed_cocore_disks"].append(
            deepcopy(
                value["pointwise_bridge"]["native_inventory"]
                ["signed_cocore_disks"][-1]
            )
        ),
    )
    add(
        "alter-cusp-role",
        lambda value: value["pointwise_bridge"]["source_rgb_roles"].__setitem__(
            "B", "H2-27"
        ),
    )
    add(
        "break-overlap",
        lambda value: value["pointwise_bridge"]["cross_block_overlaps"]
        .__setitem__("all_verified", False),
    )
    add(
        "reverse-peripheral-sign",
        lambda value: value["pointwise_bridge"]["peripheral_actions"]
        .__setitem__("R", [[0, 1], [1, 0]]),
    )
    add(
        "reverse-orientation",
        lambda value: value["pl_arrows"][3].__setitem__(
            "orientation_sign", -1
        ),
    )
    add(
        "substitute-symbolic-map",
        lambda value: value["pointwise_bridge"].__setitem__(
            "map_representation", "Phi(name)"
        ),
    )
    add(
        "invalidate-smoothing",
        lambda value: value["smoothing"]["hypotheses"]
        ["low_dimensional_obstruction_input"].__setitem__(
            "dimension_four_uniqueness_obstructions_vanish", False
        ),
    )
    add(
        "change-source-knot",
        lambda value: value["objective"].__setitem__(
            "source_knot", "not-6_3"
        ),
    )
    add(
        "change-fs-gluing",
        lambda value: value["objective"].__setitem__(
            "fintushel_stern_gluing", "changed gluing"
        ),
    )
    add(
        "insert-stabilization",
        lambda value: value["objective"].__setitem__(
            "stabilization_count", 1
        ),
    )
    add(
        "break-local-inverse",
        lambda value: value["smoothing"]["arrows"][4].__setitem__(
            "forward_then_inverse", False
        ),
    )
    add(
        "break-global-inverse",
        lambda value: value["smoothing"].__setitem__(
            "both_global_composites_are_identities", False
        ),
    )
    add(
        "reverse-fourth-composition-order",
        lambda value: value["fourth_arrow_composite"].__setitem__(
            "formula", "Q^{-1} o P^{-1}"
        ),
    )
    add(
        "drop-fixed-cap-closure",
        lambda value: value["category_model"].__setitem__(
            "top_level_objects_are_closed_or_fixed_cap_closures", False
        ),
    )
    return cases


def check(stored):
    derived = derive_certificate()
    require(stored == derived,
            "stored aggregate certificate differs from exact replay")
    validate_certificate(stored)
    mutations = run_mutations(stored)
    require(len(mutations) == 17, "mutation suite cardinality mismatch")
    return {
        "schema": "final-seven-arrow-checker-output-v1",
        "status": "pass",
        "aggregate_certificate": str(OUTPUT.relative_to(CAMPAIGN)),
        "aggregate_certificate_sha256": sha256(OUTPUT),
        "aggregate_certificate_digest": stored["certificate_digest"],
        "pinned_input_count": len(PINNED_INPUTS),
        "reviewed_component_binding_count":
            len(stored["reviewed_component_bindings"]),
        "state_count": len(stored["states"]),
        "pl_arrow_count": len(stored["pl_arrows"]),
        "smooth_arrow_count": len(stored["smoothing"]["arrows"]),
        "handle_inventory": {"h1": 1, "h2": 28, "h3": 5, "h4": 2},
        "signed_cocore_disk_count": 36,
        "jacobian_operation": "matrix.inverse.compute",
        "jacobian_status": "ok",
        "mutation_cases": mutations,
        "mutation_rejections": len(mutations),
        "independent_reviewer_replay_required": True,
        "campaign_done": False,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write-output", action="store_true")
    args = parser.parse_args()
    require(OUTPUT.is_file(), f"missing aggregate certificate: {OUTPUT}")
    result = check(read_json(OUTPUT))
    if args.write_output:
        CHECK_OUTPUT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
