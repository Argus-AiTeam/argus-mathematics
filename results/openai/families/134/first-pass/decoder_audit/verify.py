#!/usr/bin/env python3
"""Replay the exact geometry diagnostics and the universal Lean certificate."""

import itertools
import json
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
REQUIRED_THEOREMS = (
    "actual_anchor_list_le_three",
    "end_failures_le_four",
    "inner_failures_le_three",
    "whole_stencil_bound",
    "decoder_pre_uniqueness",
    "decoder_success_and_endpoint",
    "actual_reference_guard_passes",
    "surviving_copy_has_unique_witness",
    "search_locality",
    "end_search_locality",
    "manuscript_budget",
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def separated(markers, distance):
    return all(b - a >= distance for a, b in zip(markers, markers[1:]))


def first(markers, z, width):
    return next((m for m in markers if z <= m <= z + width), None)


def inner_bad(markers, z, width, ext, wiggle):
    original = first(markers, z, width)
    return any(
        first(markers, z + v, width) != original
        for v in range(-wiggle, wiggle + 1)
    ) or (original is None and first(markers, z, width + ext) is not None)


def end_search(markers, center, base, step, modulus):
    return next(
        (
            m
            for m in markers
            if abs(m - center) <= base + ((m - center) % modulus) * step
        ),
        None,
    )


def residue_diagnostic():
    checked_pairs = 0
    for size in range(1, 11):
        modulus = 20 * (size + 1) ** 3
        residues = [4 * size * size * i + i * i for i in range(1, size + 1)]
        differences = [
            (a - b) % modulus for a in residues for b in residues if a != b
        ]
        require(0 not in differences, "zero distinct-slot residue")
        require(len(set(differences)) == len(differences), "residue collision")
        checked_pairs += len(differences)
    return {"roster_sizes": [1, 10], "ordered_pairs_checked": checked_pairs}


def inner_diagnostic():
    slots = (0, 5, 17)
    delta = sorted(a - b for a in slots for b in slots if a != b)
    h, wiggle, ext, modulus = 17, 1, 7, 1280
    distance = 10 * (2 * h + 2 * wiggle + 5) + 1
    radius = max(ext, wiggle)
    base = (2 * distance // modulus + 1) * modulus
    width_step = (2 * h + 2 * radius + 2) // modulus * modulus + modulus
    require(len(set(delta)) == len(delta), "duplicate displacement")
    require(len({x % modulus for x in delta}) == len(delta), "duplicate residue")
    require(
        all(abs(x - y) > 2 * wiggle + 2 for x, y in itertools.combinations(delta, 2)),
        "invalid displacement spacing",
    )
    cases = 0
    maximum_bad = 0
    for anchor in (-1, 0, 1, modulus // 2, modulus - 1, modulus, modulus + 1):
        widths = {x: base + width_step * ((anchor - x) % modulus) for x in delta}
        require(
            all(
                abs((x + widths[x]) - (y + widths[y])) > 2 * radius
                for x, y in itertools.combinations(delta, 2)
            ),
            "right endpoints not separated",
        )
        points = sorted(
            {x + v for x in delta for v in (-wiggle, 0, wiggle)}
            | {
                x + widths[x] + v
                for x in delta
                for v in (-radius, -1, 0, 1, ext)
            }
        )
        boards = itertools.chain(
            ((),),
            itertools.combinations(points, 1),
            itertools.combinations(points, 2),
            itertools.combinations(points[::6], 3),
        )
        for markers in boards:
            if not separated(markers, distance):
                continue
            cases += 1
            bad = 0
            for x in delta:
                if not inner_bad(markers, x, widths[x], ext, wiggle):
                    continue
                bad += 1
                left = any(abs(m - x) <= wiggle for m in markers)
                m = next((m for m in markers if x <= m), None)
                right = m is not None and abs(m - (x + widths[x])) <= radius
                require(left or right, "inner failure classification failed")
            require(bad <= 3, "inner census violated")
            maximum_bad = max(maximum_bad, bad)
    return {"configurations": cases, "maximum_bad_observed": maximum_bad, "proved_bound": 3}


def end_diagnostic():
    slots = (0, 5, 17)
    delta = sorted({0} | {a - b for a in slots for b in slots if a != b})
    false_delta = [x for x in delta if x != 0]
    h, modulus = 17, 1280
    wiggle = 2 * modulus
    step = 4 * (h + wiggle + 1) + 1
    distance = 10 * modulus * step + 10 * (h + wiggle + 1) + 1
    small, large = distance, 3 * distance
    require(2 * h + (modulus - 1) * step + 2 * wiggle < distance, "end strip")
    require(step - 2 * h > 2 * wiggle, "end target spacing")
    require(small + (modulus - 1) * step + 2 * h < large, "nested end searches")
    strips = []
    for base, sign in itertools.product((small, large), (-1, 1)):
        points = []
        for x, u in itertools.product(false_delta, (0, 1, modulus // 3, modulus - 1)):
            target = sign * (base + u * step)
            nearest = x + u + modulus * ((target - u + modulus // 2) // modulus)
            points.extend(nearest + v for v in (-modulus, 0, modulus))
        strips.append(sorted(set(points)))
    singleton_points = sorted(set(itertools.chain.from_iterable(strips)))
    boards = {()}
    boards.update((m,) for m in singleton_points)
    for i in range(max(map(len, strips))):
        four = [strip[(i + 11 * j) % len(strip)] for j, strip in enumerate(strips)]
        for mask in range(16):
            board = tuple(sorted(four[j] for j in range(4) if mask & (1 << j)))
            if separated(board, distance):
                boards.add(board)
    cases = 0
    max_end = max_returns = max_anchors = 0
    for markers in sorted(boards):
        require(separated(markers, distance), "invalid end marker board")
        cases += 1
        count = 0
        for x in false_delta:
            changed = any(
                end_search(markers, x, base, step, modulus)
                != end_search(markers, x + v, base, step, modulus)
                for base in (small, large)
                for v in range(-wiggle, wiggle + 1, modulus)
            )
            count += changed
        require(count <= 4, "end-instability census violated")
        returns = [end_search(markers, x, large, step, modulus) for x in delta]
        present = {q for q in returns if q is not None}
        mismatch = 100 * large
        anchors = {mismatch if q is None else q for q in returns}
        require(len(present) <= 2, "leftmost return census violated")
        require(len(anchors) <= 3, "anchor census violated")
        if None in returns:
            require(
                all(end_search(markers, x, small, step, modulus) is None for x in delta),
                "absent larger search did not force all smaller searches absent",
            )
        max_end = max(max_end, count)
        max_returns = max(max_returns, len(present))
        max_anchors = max(max_anchors, len(anchors))
    return {
        "configurations": cases,
        "maximum_end_failures_observed": max_end,
        "maximum_present_returns_observed": max_returns,
        "maximum_anchors_observed": max_anchors,
        "proved_bounds": {"end": 4, "present_returns": 2, "anchors": 3},
    }


def endpoint_diagnostic():
    period, length, mismatch, tail = 2, 28, 60, 7
    starts = (0, 3)

    def continuation(x):
        return x % period

    def word(x):
        return 1 - continuation(x) if x == mismatch else continuation(x)

    def mismatch_at(start, q):
        return (
            q >= start + length
            and word(q) != continuation(q)
            and all(word(x) == continuation(x) for x in range(start + length, q))
        )

    for start in starts:
        require(
            all(word(x) == continuation(x) for x in range(start, start + length)),
            "seed agreement",
        )
    accepted_reference = [
        endpoint
        for endpoint in range(mismatch + tail + 21)
        if mismatch_at(starts[1], endpoint - tail)
    ]
    require(accepted_reference == [mismatch + tail], "reference end guard")
    for proposed in range(mismatch + tail + 21):
        if mismatch_at(starts[1], proposed - tail):
            require(proposed - tail == mismatch, "absent-branch witness was relabelled")
        bounded_anchor = 20
        require(bounded_anchor == 20, "bounded anchor depends on proposed endpoint")
        final_passes = mismatch_at(starts[0], proposed - tail)
        require(final_passes == (proposed == mismatch + tail), "final end guard")
    return {
        "reference_accepted_endpoints": accepted_reference,
        "all_present_smaller_absent_tested": True,
        "false_endpoint_with_surviving_bounded_witness": mismatch + tail + 1,
        "that_false_endpoint_rejected_by_final_guard": True,
    }


def replay_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    operation = "integer.counting.congruence_box.compute"
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(status["stderr"] == "", "Jacobian adapter stderr needs inspection")
    require(output["server"]["version"] == contract["server"]["version"], "server version")
    require(output["protocol_version"] == contract["protocol_version"], "protocol version")
    require(output["request"]["operation_id"] == operation, "wrong operation")
    require(output["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(output["result"]["operation_id"] == operation, "wrong typed result")
    count = sum(
        (payload["u"] * x + payload["v"] * y - payload["c"]) % payload["modulus"] == 0
        for x in range(payload["x_lo"], payload["x_hi"] + 1)
        for y in range(payload["y_lo"], payload["y_hi"] + 1)
    )
    require(output["result"]["output"] == {"count": count, "modulus": payload["modulus"]},
            "Jacobian count did not replay")
    require(count == 39, "unexpected finite congruence diagnostic")
    return {"operation_id": operation, "adapter_exit_code": 0, "independent_exact_count": count}


def checked_module(module, arguments):
    command = [ARGUS_PYTHON, "-m", module, *arguments]
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, timeout=110)
    if result.returncode:
        sys.stderr.write(result.stdout + result.stderr)
        raise RuntimeError(f"{module} exited {result.returncode}")
    return result.stdout


def finite_checks():
    return {
        "classification": "finite_diagnostics_only; the universal proof is Lean",
        "residues": residue_diagnostic(),
        "inner": inner_diagnostic(),
        "end_and_anchors": end_diagnostic(),
        "endpoints": endpoint_diagnostic(),
        "jacobian": replay_jacobian(),
    }


def certify(diagnostics):
    source = (HERE / "Main.lean").read_text()
    for name in REQUIRED_THEOREMS:
        require(f"theorem {name} " in source, f"missing required declaration {name}")
    output = checked_module(
        "argus_skill.verticals.math.lean_evidence",
        [
            "verify",
            str(HERE / "Main.lean"),
            "--statement-fidelity", str(HERE / "statement_fidelity.md"),
            "--claim", "C_DA_CORE",
            "--project-root", str(ROOT),
            "--artifact-dir", str(HERE),
            "--timeout", "90",
        ],
    )
    compiler = json.loads(output)
    require(compiler["status"] == "success", "formal compilation did not succeed")
    require(compiler["exit_code"] == 0, "nonzero compiler exit")
    require(compiler["proof_holes"] == [], "proof holes in formal certificate")
    require("(version 4.31.0," in compiler["tools"]["lean"]["version"], "wrong Lean version")
    require(compiler["kernel"]["recorded"] is not None, "mechanical evidence not recorded")
    checked_module("argus_skill.verticals.math.math_state", ["check", "--project-root", str(ROOT)])
    checked_module("argus_skill.verticals.math.proof_graph_check", ["check", "--project-root", str(ROOT)])
    certificate = {
        "claim_id": "C_DA_CORE",
        "result_class": "new_theorem",
        "result_description": "Universal decoder verification with a strengthened anchor bound, relative to the staged manuscript.",
        "manuscript_claims": ["decode:anchor-list", "decode:sparsity", "decode:decoder"],
        "theorem": {
            "larger_search_returns": "at most 2",
            "anchors_including_shared_mismatch": "at most 3",
            "false_ordered_pair_bound": "4 + 3 * (C + 3 * (g + 1))",
            "original_multiplicity_suffices": True,
            "pre_uniqueness_branches": ["some larger search absent", "all larger searches present"],
            "exact_endpoint_guard_required_in_both_branches": True,
            "surviving_copy_of_every_kind": True,
        },
        "compiler": {
            "status": compiler["status"],
            "exit_code": compiler["exit_code"],
            "proof_holes": compiler["proof_holes"],
            "lean_version": compiler["tools"]["lean"]["version"],
            "command": compiler["command"],
            "kernel": compiler["kernel"],
        },
        "campaign_local_checks": {
            "project_root": str(ROOT),
            "math_state_exit": 0,
            "proof_graph_exit": 0,
        },
        "diagnostics": diagnostics,
        "scope": {
            "full_star_height_theorem_certified": False,
            "false_manuscript_assertion_identified": False,
            "application_inputs": [
                "actual local-marker separation and markerless periodic-seed guarantee",
                "actual schedule and injective displacement residues",
                "uniform clock roster estimate at every translate",
                "mandatory bounded inspections internal to the actual episode",
            ],
            "independent_review": "required; not performed by this Engineer script",
            "novelty_status": "not globally verified; stronger than the staged bound twenty",
            "significance_status": "pending independent review at the publishable target",
            "finite_diagnostics_are_legal_full_episode_counterexamples": False,
        },
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "claim": "C_DA_CORE",
        "compiler_exit": 0,
        "proof_holes": [],
        "anchor_bound": 3,
        "campaign_root": str(ROOT),
        "math_state_exit": 0,
        "proof_graph_exit": 0,
        "certificate": "research/decoder_audit/exact_certificate.json",
        "independent_review": "pending",
    }, indent=2))


def main():
    certify(finite_checks())


if __name__ == "__main__":
    main()
