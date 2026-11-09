#!/usr/bin/env python3

import hashlib
import json
from itertools import combinations
from math import comb
from pathlib import Path


RESEARCH = Path(__file__).resolve().parent
OUTPUT = RESEARCH / "k7_total_exclusion_synthesis_certificate.json"
COUNTING_DOMAIN = "1 <= k <= floor(n/2)"

PINNED_ARTIFACTS = {
    "lower_index_six": {
        "path": "lower_index_six_certificate.json",
        "sha256": "0dd4f5d842a5bb9caf47440a6773995d5caabcd9c5d208dcc28de66fa1ba1b73",
        "role": "m(a)=5 implies K(a)>=7",
    },
    "k7_lower_index_reduction": {
        "path": "k7_67_overlap_equality_certificate.json",
        "sha256": "26a7e4f79151198cd3ace0334cf86c93e4bcae40e76857f69fc5be6ba9d507e1",
        "role": "exhaustion of the ten K=7 lower-index sets",
    },
    "column_24_classification": {
        "path": "k7_24_intersection_certificate.json",
        "sha256": "9cae0a28e78209668f1c8bed3f61f6cd022b8dfb6c66c1034482273fee9895d6",
        "role": "complete (2,4) classification and P(210)",
    },
    "columns_36_46_classification": {
        "path": "k7_36_46_intersections_certificate.json",
        "sha256": "9e5f9a6d89d0684df53fd355b3cb349ab27f0af020f86575e8c14451cb2eae12",
        "role": "complete (3,6) and (4,6) classifications",
    },
    "k8_residual_reduction": {
        "path": "k8_lower_index_overlap_reduction_certificate.json",
        "sha256": "8a3ff5cebaf061393ee4915e386c141dcdf4ae794f2a8c033f813c899b5cabf8",
        "role": "complete K=8 lower-index and all-disjoint residual",
    },
}

EXPECTED_K7_SETS = [
    [2, 4, 6, 7],
    [3, 5, 6, 7],
    [4, 5, 6, 7],
]
EXPECTED_K8_SETS = [
    [3, 5, 7, 8],
    [5, 6, 7, 8],
]


def load_pinned_artifact(name):
    specification = PINNED_ARTIFACTS[name]
    path = RESEARCH / specification["path"]
    raw = path.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if digest != specification["sha256"]:
        raise AssertionError(
            f"{specification['path']} hash changed: expected "
            f"{specification['sha256']}, got {digest}"
        )
    return json.loads(raw), {
        "path": f"research/{specification['path']}",
        "sha256": digest,
        "role": specification["role"],
    }


def occurrence_tuples(record):
    return sorted((item["n"], item["k"]) for item in record["occurrences"])


def verify_occurrence_record(value, record, expected):
    expected = sorted(expected)
    actual = occurrence_tuples(record)
    if actual != expected:
        raise AssertionError(
            f"P({value}) mismatch: expected {expected}, got {actual}"
        )
    if record["multiplicity"] != len(expected):
        raise AssertionError(f"m({value}) does not match its occurrence list")
    expected_maximum = max((k for _, k in expected), default=None)
    if record["maximum_lower_index"] != expected_maximum:
        raise AssertionError(f"K({value}) does not match its occurrence list")
    for n, k in actual:
        if not (1 <= k <= n // 2):
            raise AssertionError(f"P({value}) contains off-domain point {(n, k)}")
        if comb(n, k) != value:
            raise AssertionError(f"P({value}) contains false point {(n, k)}")
        if n > value:
            raise AssertionError(f"P({value}) violates the n<=a bound")


def verify_k7_lower_index_exhaustion(certificate):
    reduction = certificate["lower_index_reduction"]
    records = reduction["set_records"]
    all_sets = [
        [*prefix, 7]
        for prefix in combinations(range(2, 7), 3)
    ]
    recorded_sets = [record["lower_indices"] for record in records]
    if reduction["raw_K7_set_count"] != 10:
        raise AssertionError("the K=7 raw set count is not 10")
    if sorted(recorded_sets) != all_sets:
        raise AssertionError("the K=7 set records do not exhaust all ten sets")
    if len({tuple(indices) for indices in recorded_sets}) != 10:
        raise AssertionError("the K=7 set records contain a duplicate")

    surviving_sets = sorted(
        record["lower_indices"] for record in records if record["survives"]
    )
    if surviving_sets != EXPECTED_K7_SETS:
        raise AssertionError(
            f"unexpected K=7 residual: {surviving_sets}"
        )
    if reduction["surviving_sets"] != EXPECTED_K7_SETS:
        raise AssertionError("the recorded K=7 conclusion changed")
    for record in records:
        if record["survives"] == bool(record["audited_blockers"]):
            raise AssertionError(
                "a K=7 set's survival flag disagrees with its blockers"
            )
    return {
        "raw_set_count": 10,
        "enumerated_sets": all_sets,
        "surviving_sets": surviving_sets,
        "excluded_set_count": 7,
        "exhaustion_verified": True,
    }


def verify_column_24(certificate):
    if certificate["P_210"]["counting_domain"] != COUNTING_DOMAIN:
        raise AssertionError("(2,4) counting domain changed")
    if certificate["status"] != (
        "COMPLETE_RELATIVE_TO_CITED_DE_WEGER_THEOREMS"
    ):
        raise AssertionError("(2,4) completeness status changed")
    if certificate["admissible_left_half_X_Y"] != [[10, 21]]:
        raise AssertionError("unexpected (2,4) left-half points")
    if certificate["admissible_common_values"] != [210]:
        raise AssertionError("unexpected (2,4) left-half values")
    if comb(10, 4) != 210 or comb(21, 2) != 210:
        raise AssertionError("the recorded (2,4) point does not have value 210")

    p_210 = certificate["P_210"]
    verify_occurrence_record(
        210,
        p_210,
        [(10, 4), (21, 2), (210, 1)],
    )
    if (
        p_210["contains_lower_index_6"]
        or p_210["contains_lower_index_7"]
    ):
        raise AssertionError("P(210) unexpectedly contains column 6 or 7")
    return {
        "required_pair": [2, 4],
        "row_variables": {"column_2": "Y", "column_4": "X"},
        "left_half_domain": {"Y_min": 4, "X_min": 8},
        "admissible_points_X_Y": [[10, 21]],
        "admissible_values": [210],
        "exception": {
            "value": 210,
            "occurrences": [[10, 4], [21, 2], [210, 1]],
            "multiplicity": 3,
            "maximum_lower_index": 4,
        },
        "excludes_set": [2, 4, 6, 7],
        "reason": "the only common value has m(210)=3 and K(210)=4",
    }


def verify_empty_left_half_classification(
    certificate,
    key,
    expected_domain,
    minimum_n,
    minimum_m,
    expected_solution_count,
):
    classification = certificate[key]
    if classification["campaign_domain"] != expected_domain:
        raise AssertionError(f"{key} campaign domain changed")
    if classification["admissible_left_half_solutions"]:
        raise AssertionError(f"{key} has an admissible left-half solution")
    solutions = classification["all_integer_binomial_solutions"]
    if len(solutions) != expected_solution_count:
        raise AssertionError(f"{key} complete solution count changed")
    filtered = [
        solution
        for solution in solutions
        if solution["n"] >= minimum_n and solution["m"] >= minimum_m
    ]
    if filtered:
        raise AssertionError(f"{key} domain filter is not empty: {filtered}")
    return {
        "campaign_domain": {
            "n_min": minimum_n,
            "m_min": minimum_m,
        },
        "recorded_integer_solution_count": len(solutions),
        "admissible_left_half_solutions": [],
        "domain_filter_verified": True,
    }


def verify_columns_36_46(certificate):
    if certificate["status"] != (
        "COMPLETE_RELATIVE_TO_STROEKER_DE_WEGER_1999_"
        "THEOREMS_A36_A46"
    ):
        raise AssertionError("(3,6)/(4,6) completeness status changed")

    c36 = verify_empty_left_half_classification(
        certificate,
        "C36",
        "n>=6 and m>=12",
        6,
        12,
        22,
    )
    w46 = verify_empty_left_half_classification(
        certificate,
        "W46",
        "n>=8 and m>=12",
        8,
        12,
        32,
    )

    expected_occurrences = {
        1: [],
        84: [(9, 3), (84, 1)],
        210: [(10, 4), (21, 2), (210, 1)],
    }
    exceptional = certificate["exceptional_positive_values"]
    if set(exceptional) != {"1", "84", "210"}:
        raise AssertionError("the exceptional positive values changed")
    for value, expected in expected_occurrences.items():
        verify_occurrence_record(value, exceptional[str(value)], expected)

    return {
        "column_36": {
            "required_pair": [3, 6],
            **c36,
            "excludes_set": [3, 5, 6, 7],
            "reason": "the complete campaign left-half intersection is empty",
        },
        "column_46": {
            "required_pair": [4, 6],
            **w46,
            "excludes_set": [4, 5, 6, 7],
            "reason": "the complete campaign left-half intersection is empty",
        },
        "exceptional_positive_values": {
            str(value): {
                "occurrences": [list(point) for point in expected],
                "multiplicity": len(expected),
                "maximum_lower_index": max(
                    (k for _, k in expected),
                    default=None,
                ),
            }
            for value, expected in expected_occurrences.items()
        },
    }


def verify_lower_bound(certificate):
    if certificate["counting_domain"] != COUNTING_DOMAIN:
        raise AssertionError("the lower-bound counting domain changed")
    if certificate["status"] != "COMPLETE_RELATIVE_TO_CITED_CLASSIFICATIONS":
        raise AssertionError("the K>=7 completeness status changed")
    if certificate["claim"] != (
        "Conditional on the three cited complete classifications, "
        "m(a)=5 implies K(a)>=7."
    ):
        raise AssertionError("the inherited K>=7 claim changed")
    return {
        "claim": "m(a)=5 implies K(a)>=7",
        "integer_step": "K(a)>=7 and K(a)!=7 imply K(a)>=8",
    }


def verify_k8_residual(certificate):
    if certificate["counting_domain"] != COUNTING_DOMAIN:
        raise AssertionError("the K=8 counting domain changed")
    reduction = certificate["lower_index_reduction"]
    records = reduction["all_twenty_sets"]
    all_sets = [
        [*prefix, 8]
        for prefix in combinations(range(2, 8), 3)
    ]
    recorded_sets = [record["lower_indices"] for record in records]
    if sorted(recorded_sets) != all_sets or len(records) != 20:
        raise AssertionError("the K=8 records do not exhaust all twenty sets")
    surviving_sets = sorted(
        record["lower_indices"]
        for record in records
        if record["decision"] == "survives"
    )
    if surviving_sets != EXPECTED_K8_SETS:
        raise AssertionError(f"unexpected K=8 residual: {surviving_sets}")
    if reduction["surviving_sets"] != EXPECTED_K8_SETS:
        raise AssertionError("the recorded K=8 residual changed")
    if reduction["decision_counts"] != {
        "excluded_by_28": 10,
        "excluded_by_36": 2,
        "excluded_by_48": 6,
        "survives": 2,
    }:
        raise AssertionError("the K=8 decision counts changed")

    disjoint_records = certificate["all_disjoint_consequence"]["candidate_sets"]
    disjoint_sets = sorted(record["lower_indices"] for record in disjoint_records)
    if disjoint_sets != EXPECTED_K8_SETS:
        raise AssertionError("the K=8 all-disjoint candidate list changed")
    if not all(
        record["all_adjacent_overlaps_excluded_for_m5_K8"]
        and record["all_pairwise_disjoint"]
        for record in disjoint_records
    ):
        raise AssertionError("a K=8 residual is not certified all-disjoint")

    return {
        "raw_set_count": 20,
        "surviving_sets": surviving_sets,
        "all_pairwise_disjoint": True,
        "boundary": (
            "These are the complete K=8 residual sets, not excluded branches."
        ),
    }


def main():
    loaded = {}
    artifact_records = {}
    for name in PINNED_ARTIFACTS:
        loaded[name], artifact_records[name] = load_pinned_artifact(name)

    lower_bound = verify_lower_bound(loaded["lower_index_six"])
    k7_exhaustion = verify_k7_lower_index_exhaustion(
        loaded["k7_lower_index_reduction"]
    )
    low24 = verify_column_24(loaded["column_24_classification"])
    low36_46 = verify_columns_36_46(
        loaded["columns_36_46_classification"]
    )

    branch_exclusions = [
        low24,
        low36_46["column_36"],
        low36_46["column_46"],
    ]
    excluded_sets = sorted(branch["excludes_set"] for branch in branch_exclusions)
    if excluded_sets != EXPECTED_K7_SETS:
        raise AssertionError("the branch exclusions do not cover the K=7 residual")
    for branch in branch_exclusions:
        required_pair = set(branch["required_pair"])
        if not required_pair.issubset(branch["excludes_set"]):
            raise AssertionError("a branch does not contain its required pair")

    k8_residual = verify_k8_residual(loaded["k8_residual_reduction"])

    certificate = {
        "schema_version": 1,
        "status": "EXACT_HASH_PINNED_LOGICAL_SYNTHESIS_REVIEW_REQUIRED",
        "counting_domain": COUNTING_DOMAIN,
        "claim": (
            "There is no positive integer a with m(a)=5 and K(a)=7; "
            "therefore m(a)=5 implies K(a)>=8."
        ),
        "scope": (
            "This certificate reads hash-pinned existing classifications and "
            "checks only their domain filters, exceptional multiplicities, "
            "finite set exhaustion, and the final logical implication. It "
            "does not recompute an integral-point classification or extend "
            "a finite search."
        ),
        "upstream_artifacts": artifact_records,
        "inherited_lower_bound": lower_bound,
        "k7_lower_index_exhaustion": k7_exhaustion,
        "branch_exclusions": branch_exclusions,
        "exceptional_positive_values": low36_46[
            "exceptional_positive_values"
        ],
        "logical_check": {
            "candidate_sets": EXPECTED_K7_SETS,
            "excluded_sets": excluded_sets,
            "all_candidates_excluded": True,
            "k7_total_exclusion": "m(a)=5 implies K(a)!=7",
            "combined_conclusion": "m(a)=5 implies K(a)>=8",
        },
        "next_exact_residual": k8_residual,
        "open_boundary": {
            "C-T5": "OPEN",
            "K8_3578": "OPEN",
            "K8_5678": "OPEN",
            "counterexample_found": False,
        },
        "independent_review_required": True,
    }
    OUTPUT.write_text(
        json.dumps(certificate, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    print(
        "verified exact K=7 exhaustion; m(a)=5 implies K(a)>=8; "
        "both K=8 residual branches remain open"
    )


if __name__ == "__main__":
    main()
