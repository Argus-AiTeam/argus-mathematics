#!/usr/bin/env python3
from __future__ import annotations

import argparse
from collections import deque
from fractions import Fraction
from itertools import combinations
import json
from math import prod
from pathlib import Path
import subprocess


ROOT = Path(__file__).resolve().parents[1]
PREFIX = ROOT / "research" / "affine_orthogonal_runge"
OPERATION = "group.order.compute"
ARGUS_PYTHON = "/home/argustest/zimo/argus-live-update/.venv/bin/python"


def artifact(suffix: str) -> Path:
    return PREFIX.with_name(PREFIX.name + suffix)


def read_json(path: Path):
    return json.loads(path.read_text())


def q(value: int, g: int) -> int:
    return sum(
        ((value >> (2 * i)) & 1) * ((value >> (2 * i + 1)) & 1)
        for i in range(g)
    ) & 1


def b(left: int, right: int, g: int) -> int:
    return q(left ^ right, g) ^ q(left, g) ^ q(right, g)


def nonsingular_count(g: int) -> int:
    return (1 << (g - 1)) * ((1 << g) - 1)


def singular_count(g: int) -> int:
    return ((1 << (g - 1)) + 1) * ((1 << g) - 1)


def orthogonal_order(g: int, epsilon: int = 1) -> int:
    assert g >= 1 and epsilon in (-1, 1)
    return (
        (1 << (g * (g - 1) + 1))
        * ((1 << g) - epsilon)
        * prod((1 << (2 * i)) - 1 for i in range(1, g))
    )


def singular_subspaces(g: int, dimension: int) -> int:
    numerator = prod(singular_count(g - j) for j in range(dimension))
    denominator = prod((1 << i) - 1 for i in range(1, dimension + 1))
    count, remainder = divmod(numerator, denominator)
    assert remainder == 0
    return count


def generators() -> list[list[int]]:
    return [
        [x ^ (v if b(x, v, 3) else 0) for x in range(64)]
        for v in range(64)
        if q(v, 3)
    ]


def payload() -> dict:
    return {"degree": 64, "generators": generators()}


def execute_adapter() -> None:
    assert read_json(artifact("_jacobian_payload.json")) == payload()
    command = [
        ARGUS_PYTHON, "-m", "argus_skill.tools.jacobian", "run",
        "--operation", OPERATION,
        "--payload-file", str(artifact("_jacobian_payload.json")),
        "--timeout", "60",
    ]
    try:
        process = subprocess.run(command, cwd=ROOT, capture_output=True, timeout=90)
    except subprocess.TimeoutExpired as error:
        artifact("_jacobian_result.json").write_bytes(error.stdout or b"")
        artifact("_jacobian_stderr.txt").write_bytes(error.stderr or b"")
        artifact("_jacobian_execution.json").write_text(json.dumps({
            "operation_id": OPERATION,
            "adapter_exit_status": None,
            "timeout_seconds": 60,
            "timed_out": True,
            "structured_error": {"kind": "adapter_process_timeout", "seconds": 90},
        }, indent=2) + "\n")
        raise
    artifact("_jacobian_result.json").write_bytes(process.stdout)
    artifact("_jacobian_stderr.txt").write_bytes(process.stderr)
    artifact("_jacobian_execution.json").write_text(json.dumps({
        "operation_id": OPERATION,
        "adapter_exit_status": process.returncode,
        "timeout_seconds": 60,
        "timed_out": False,
    }, indent=2) + "\n")
    process.check_returncode()
    print("Adapter completed with exit 0; exact typed output retained")


def rref(rows, n: int = 6) -> tuple[int, ...]:
    remaining = [row for row in rows if row]
    answer = []
    for column in range(n):
        pivot_index = next(
            (i for i, row in enumerate(remaining) if (row >> column) & 1),
            None,
        )
        if pivot_index is None:
            continue
        pivot = remaining.pop(pivot_index)
        remaining = [
            row ^ pivot if (row >> column) & 1 else row for row in remaining
        ]
        answer = [
            row ^ pivot if (row >> column) & 1 else row for row in answer
        ]
        answer.append(pivot)
    return tuple(answer)


def subspaces(dimension: int) -> set[tuple[int, ...]]:
    answer = set()
    for pivots in combinations(range(6), dimension):
        slots = [
            (row, column)
            for row, pivot in enumerate(pivots)
            for column in range(pivot + 1, 6)
            if column not in pivots
        ]
        for mask in range(1 << len(slots)):
            rows = [1 << pivot for pivot in pivots]
            for bit, (row, column) in enumerate(slots):
                if (mask >> bit) & 1:
                    rows[row] |= 1 << column
            answer.add(tuple(rows))
    return answer


def small_rank_test() -> dict:
    perms = generators()
    for permutation in perms:
        assert sorted(permutation) == list(range(64))
        assert all(q(permutation[x], 3) == q(x, 3) for x in range(64))
    profiles = {}
    counts = {}
    for dimension in range(6):
        unseen = subspaces(dimension)
        counts[str(dimension)] = len(unseen)
        sizes = []
        while unseen:
            seed = min(unseen)
            unseen.remove(seed)
            queue = deque([seed])
            size = 1
            while queue:
                current = queue.popleft()
                for permutation in perms:
                    image = rref(permutation[row] for row in current)
                    if image in unseen:
                        unseen.remove(image)
                        queue.append(image)
                        size += 1
            sizes.append(size)
        profiles[str(dimension)] = sorted(sizes)
    assert counts == {"0": 1, "1": 63, "2": 651, "3": 1395, "4": 651, "5": 63}
    assert sum(counts.values()) == 2824
    assert profiles["1"] == profiles["5"] == [28, 35]
    assert all(min(profiles[str(d)]) >= 28 for d in range(1, 6))
    minima = {
        str(d): (1 << (6 - d)) * min(profiles[str(d)]) for d in range(6)
    }
    assert min(minima.values()) == 56
    v = 3
    hyperplane = [x for x in range(64) if b(v, x, 3) == 0]
    basis = rref(hyperplane)
    assert q(v, 3) == 1 and len(basis) == 5 and len(hyperplane) == 32
    assert all(b(v, x ^ w, 3) == b(v, x, 3) for x in range(64) for w in basis)
    return {
        "g": 3,
        "proper_subspace_count_including_zero": 2824,
        "counts_by_dimension": counts,
        "orbit_sizes_by_dimension": profiles,
        "affine_index_lower_bound_by_translation_dimension": minima,
        "minimum_intransitive_index": 56,
        "attaining_hyperplane_vector": v,
        "attaining_orbit_sizes": [32, 32],
    }


def adapter_evidence() -> dict:
    discovery = read_json(artifact("_jacobian_discovery.json"))
    assert any(
        match["operation_id"] == OPERATION
        for match in discovery["result"]["matches"]
    )
    contract = read_json(artifact("_jacobian_order_contract.json"))
    operation = contract["result"]["operation"]
    assert operation["operation_id"] == OPERATION
    assert operation["input_schema"]["properties"]["degree"]["maximum"] == 64
    exact_payload = read_json(artifact("_jacobian_payload.json"))
    assert exact_payload == payload()
    result = read_json(artifact("_jacobian_result.json"))
    assert result.get("error") is None
    assert result["tool"] == "math.run"
    assert result["request"] == {"operation_id": OPERATION, "payload": exact_payload}
    typed = result["result"]
    assert typed.get("error") is None
    assert typed["operation_id"] == OPERATION
    assert typed["output"] == {"order": "40320", "method": "SYMPY_SCHREIER_SIMS"}
    assert int(typed["output"]["order"]) == orthogonal_order(3)
    assert result["server"]["version"] == contract["server"]["version"]
    assert result["protocol_version"] == contract["protocol_version"]
    assert typed["runtime_ms"] >= 0
    execution = read_json(artifact("_jacobian_execution.json"))
    assert execution == {
        "operation_id": OPERATION,
        "adapter_exit_status": 0,
        "timeout_seconds": 60,
        "timed_out": False,
    }
    return {
        "operation_id": OPERATION,
        "payload_file": str(artifact("_jacobian_payload.json").relative_to(ROOT)),
        "typed_output_file": str(artifact("_jacobian_result.json").relative_to(ROOT)),
        "server": result["server"],
        "protocol_version": result["protocol_version"],
        "transport": result["transport"],
        "typed_output": typed["output"],
        "runtime_ms": typed["runtime_ms"],
        "adapter_exit_status": execution["adapter_exit_status"],
        "timeout_seconds": execution["timeout_seconds"],
        "timed_out": execution["timed_out"],
        "structured_error": result.get("error"),
        "scope": "Full O^+_6(2) generated by nonsingular transvections; not a uniform proof.",
    }


def reviewed_g4_input() -> dict:
    path = ROOT / "research/k8_56_theta_2cover_extension_stability_certificate.json"
    old = read_json(path)
    table = old["complete_subspace_orbit_enumeration"]
    group = old["exact_finite_group_replay"]
    assert table["proper_subspace_count"] == 417198
    assert table["minimum"]["index"] == (1 << 8) - (1 << 4) == 240
    assert group["point_stabilizer_order"] == orthogonal_order(4) == 348364800
    assert group["minimal_subgroup_orbit_sizes"] == [128, 128]
    assert group["point_stabilizer_orbit_sizes"] == [1, 120, 135]
    assert group["affine_action_primitive"] is True
    state = read_json(ROOT / "research/MATH_STATE.json")
    claim_id = "K-K8-56-THETA-2COVER-EXTENSION-STABILITY"
    claim = max(
        (entry for entry in state["claims"] if entry["claim_id"] == claim_id),
        key=lambda entry: entry["version"],
    )
    reviews = [
        entry["produced_by"]
        for entry in state["evidence"]
        if entry["subject"]["kind"] == "claim"
        and entry["subject"]["subject_id"] == claim_id
        and entry["subject"]["content_hash"] == claim["content_hash"]
        and entry["tier"] == "judgement"
        and entry["verdict"] == "supports"
        and entry["produced_by"].startswith("reviewer:")
        and entry["artifact"] == str(path.relative_to(ROOT))
    ]
    assert reviews, "Current reviewed g=4 prerequisite is missing"
    graph = read_json(ROOT / "research/PROOF_GRAPH.json")
    assert graph["nodes"][claim_id]["reviewer_confirmed"] is True
    return {
        "claim_id": claim_id,
        "claim_version": claim["version"],
        "artifact": str(path.relative_to(ROOT)),
        "reviewers": sorted(reviews),
        "minimum_intransitive_index": 240,
        "attaining_orbit_sizes": [128, 128],
        "existing_artifact_rewritten": False,
        "old_enumeration_rerun": False,
    }


def arithmetic_controls() -> list[dict]:
    assert Fraction(7, 54) > Fraction(1, 8)
    answer = []
    for g in (3, 4, 5):
        counts = [singular_subspaces(g, r) for r in range(1, g + 1)]
        assert min(counts) > nonsingular_count(g)
        nondegenerate_indices = []
        for k in range(1, g):
            l = g - k
            assert k * l >= g - 1
            for epsilon in (-1, 1):
                denominator = orthogonal_order(k, epsilon) * orthogonal_order(l, epsilon)
                index, remainder = divmod(orthogonal_order(g), denominator)
                assert remainder == 0
                assert index > Fraction(7, 54) * (1 << (4 * k * l))
                assert index > nonsingular_count(g)
                nondegenerate_indices.append(index)
        answer.append({
            "g": g,
            "nonsingular_vector_count": nonsingular_count(g),
            "totally_singular_subspace_counts": counts,
            "least_nondegenerate_subspace_index": min(nondegenerate_indices),
            "minimum_affine_intransitive_index": 2 * nonsingular_count(g),
        })
    return answer


def certificate() -> dict:
    return {
        "mathematical_evidence_kind": "prose_proof_with_exact_computational_corroboration",
        "universal_proof": "research/affine_orthogonal_runge_theorem.md",
        "universal_statement_proved_by_finite_enumeration": False,
        "independent_review_of_new_theorem_recorded": False,
        "novelty_status": "unverified",
        "significance_status": "requires_independent_review",
        "small_rank_falsification_test": small_rank_test(),
        "jacobian_adapter": adapter_evidence(),
        "unchanged_reviewed_g4_input": reviewed_g4_input(),
        "bounded_formula_controls_not_uniform_proof": arithmetic_controls(),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=("prepare", "execute", "certify", "verify"))
    action = parser.parse_args().action
    if action == "prepare":
        path = artifact("_jacobian_payload.json")
        path.write_text(json.dumps(payload(), indent=2) + "\n")
        print(f"Prepared {path.relative_to(ROOT)}: degree 64, 28 generators")
        return
    if action == "execute":
        execute_adapter()
        return
    current = certificate()
    path = artifact("_certificate.json")
    if action == "certify":
        path.write_text(json.dumps(current, indent=2, sort_keys=True) + "\n")
    else:
        assert read_json(path) == current, "Certificate does not replay exactly"
    print(
        f"{action}: exact computational ingredients pass; "
        "g=3 minimum 56, reviewed g=4 minimum 240; universal prose review pending"
    )


if __name__ == "__main__":
    main()
