#!/usr/bin/env python3
"""Replay exact selector tests and compile the universal Lean core."""

from collections import defaultdict
from fractions import Fraction as Q
from functools import lru_cache
from itertools import product
import json
from math import comb, factorial, prod
from pathlib import Path
import subprocess
import sys
import time


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
CELLS = lambda s: tuple((i, h) for i in range(1, s + 1) for h in range(i + 1, s + 2))


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def compositions(total, parts):
    if parts == 0:
        if total == 0:
            yield ()
        return
    if parts == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, parts - 1):
            yield (first,) + rest


def score(weights, inside, charge, deficit, cutoff):
    return sum(
        (min(w, cutoff) * (Q(x in inside) - (1 - deficit))
         for x, w in enumerate(weights)),
        Q(0),
    ) - charge * cutoff


def admissible(weights, inside, charge, deficit, cutoff):
    return (
        0 <= cutoff <= 1
        and all(w <= cutoff or x in inside for x, w in enumerate(weights))
        and score(weights, inside, charge, deficit, cutoff) >= 0
    )


@lru_cache(maxsize=None)
def maximal_cutoff(weights, inside, charge, deficit):
    """All affine pieces are examined; this is not a cutoff grid search."""
    endpoints = sorted({Q(0), Q(1), *weights})
    candidates = set(endpoints)
    for left, right in zip(endpoints, endpoints[1:]):
        mid = (left + right) / 2
        slope = sum(
            (Q(x in inside) - (1 - deficit)
             for x, w in enumerate(weights) if w > mid),
            Q(0),
        ) - charge
        intercept = sum(
            (w * (Q(x in inside) - (1 - deficit))
             for x, w in enumerate(weights) if w <= mid),
            Q(0),
        )
        if slope:
            root = -intercept / slope
            if left <= root <= right:
                candidates.add(root)
    valid = [u for u in candidates if admissible(weights, inside, charge, deficit, u)]
    return max(valid) if valid else None


def cumulative(z, i):
    return frozenset(x for x, color in enumerate(z) if color <= i)


def crossings(a, z, i):
    return sum(zx <= i < ax for ax, zx in zip(a, z))


def changed(a, z):
    return frozenset(x for x, (ax, zx) in enumerate(zip(a, z)) if zx < ax)


def feasible_with(weights, a, z, cutoffs, deficits):
    return all(zx <= ax for ax, zx in zip(a, z)) and all(
        admissible(weights, cumulative(z, i), Q(crossings(a, z, i)), d, u)
        for i, (d, u) in enumerate(zip(deficits, cutoffs), 1)
    )


def witness(weights, a, z, deficits):
    cutoffs = tuple(
        maximal_cutoff(weights, cumulative(z, i), Q(crossings(a, z, i)), d)
        for i, d in enumerate(deficits, 1)
    )
    return None if any(u is None for u in cutoffs) else cutoffs


def first_witness(masses, a, z, deficits):
    for h, weights in enumerate(masses):
        cutoffs = witness(weights, a, z, deficits)
        if cutoffs is not None:
            return h, cutoffs
    return None


def coloring_probability(a, palette):
    return prod((palette[color - 1] for color in a), start=Q(1))


def profile(a, z, cells):
    return tuple(
        sum(zx == i and ax == h for ax, zx in zip(a, z))
        for i, h in cells
    )


def minimum_cover_cost(family, p, n):
    full = (1 << len(family)) - 1
    costs = {0: Q(0)}
    for mask in range(1 << n):
        generator = frozenset(x for x in range(n) if mask & (1 << x))
        covered = sum(1 << h for h, member in enumerate(family) if generator <= member)
        if covered == 0:
            continue
        cost = p ** len(generator)
        for old, old_cost in tuple(costs.items()):
            new = old | covered
            candidate = old_cost + cost
            if new not in costs or candidate < costs[new]:
                costs[new] = candidate
    return costs[full]


def check_truncations():
    tested = 0
    for n in range(1, 5):
        masses = {
            tuple(Q(k, denominator) for k in ks)
            for denominator in range(1, 5)
            for ks in compositions(denominator, n)
        }
        for weights in sorted(masses):
            for bits in range(1 << n):
                inside = frozenset(x for x in range(n) if bits & (1 << x))
                for charge in {Q(0), Q(1, 2), Q(1), Q(3, 2), Q(n)}:
                    for deficit in (Q(1, 4), Q(1, 2), Q(3, 4)):
                        cutoff = maximal_cutoff(weights, inside, charge, deficit)
                        tested += 1
                        if cutoff is not None:
                            high = sum(w > cutoff for w in weights)
                            require(deficit * high <= charge, "maximal-cutoff count bound")

    examples = [
        ("zero cutoff", (Q(1),), frozenset({0}), Q(1), Q(1, 2), Q(0)),
        ("unit cutoff with zero masses", (Q(1, 2), Q(1, 2), Q(0)),
         frozenset({0, 1}), Q(0), Q(1, 2), Q(1)),
        ("equal weights at cutoff", (Q(1, 2), Q(1, 2)),
         frozenset({0, 1}), Q(1), Q(1, 2), Q(1, 2)),
        ("interior affine root", (Q(3, 4), Q(1, 4)),
         frozenset({0, 1}), Q(3, 4), Q(1, 2), Q(1, 2)),
        ("no admissible cutoff", (Q(1),), frozenset(), Q(0), Q(1, 2), None),
    ]
    for name, weights, inside, charge, deficit, expected in examples:
        require(maximal_cutoff(weights, inside, charge, deficit) == expected, name)
    return {
        "exact_truncation_instances": tested,
        "explicit_boundaries": [
            {"case": row[0], "maximal_cutoff": None if row[-1] is None else str(row[-1])}
            for row in examples
        ],
    }


def check_instance(name, family, masses, p, palette):
    n = len(masses[0])
    s = len(palette) - 1
    deficits = tuple(Q(1, 2 ** i) for i in range(1, s + 1))
    cells = CELLS(s)
    require(len(family) == len(masses), "one mass per member")
    require(all(pi > 0 for pi in palette) and sum(palette) == 1, "positive probability palette")
    require(0 < p <= 1, "p domain")
    for member, weights in zip(family, masses):
        require(bool(member) and len(weights) == n, "nonempty member")
        require(sum(weights) == 1 and all(w >= 0 for w in weights), "probability mass")
        require(all(w == 0 or x in member for x, w in enumerate(weights)), "mass support")

    cover_cost = minimum_cover_cost(family, p, n)
    require(cover_cost > Q(1, 2), "test must meet non-p-small hypothesis")
    fibers = defaultdict(list)
    bad_probability = Q(0)
    total_cover_cost = Q(0)
    selected_pairs = 0
    raw_duplicate_changed_sets = 0
    raw_duplicate_bad_changed_sets = 0
    low_mass_delay_checks = 0
    for a in product(range(1, s + 2), repeat=n):
        bad = not any(
            all(sum(weights[x] for x in cumulative(a, i)) >= 1 - d
                for i, d in enumerate(deficits, 1))
            for weights in masses
        )
        require((first_witness(masses, a, a, deficits) is None) == bad,
                "unchanged feasibility iff simultaneous capture")
        if bad:
            bad_probability += coloring_probability(a, palette)
        moves = []
        for z in product(*(range(1, ax + 1) for ax in a)):
            found = first_witness(masses, a, z, deficits)
            if found is None:
                continue
            length = sum(ax - zx for ax, zx in zip(a, z))
            moves.append((length, z))
            h, cutoffs = found
            for x in changed(a, z):
                i = z[x]
                require(1 <= i <= s, "changed final color range")
                if masses[h][x] <= cutoffs[i - 1]:
                    delayed = z[:x] + (i + 1,) + z[x + 1:]
                    require(feasible_with(masses[h], a, delayed, cutoffs, deficits),
                            "same witness survives one-level delay")
                    require(sum(ax - zx for ax, zx in zip(a, delayed)) == length - 1,
                            "delay reduces length by exactly one")
                    low_mass_delay_checks += 1
        moves.sort()
        selected = defaultdict(list)
        raw_changed = []
        for h0, member in enumerate(family):
            chosen = next(z for _, z in moves if changed(a, z) <= member)
            selected[chosen].append(h0)
            raw_changed.append(changed(a, chosen))
        duplicates = len(raw_changed) - len(set(raw_changed))
        raw_duplicate_changed_sets += duplicates
        if bad:
            raw_duplicate_bad_changed_sets += duplicates
        for z, h0s in selected.items():
            t = len(changed(a, z))
            require(t > 0 or not bad, "bad colorings have nonempty changed sets")
            fibers[(z, profile(a, z, cells))].append((a, h0s))
            selected_pairs += 1
            if bad:
                total_cover_cost += coloring_probability(a, palette) * p ** t

    nontrivial_common_fibers = 0
    common_witness_different_from_h0 = 0
    common_fiber_example = None
    for (z, counts), entries in fibers.items():
        a0 = entries[0][0]
        found = first_witness(masses, a0, z, deficits)
        require(found is not None, "fiber has a feasible witness")
        h, cutoffs = found
        high_sets = tuple(
            frozenset(x for x, w in enumerate(masses[h]) if w > cutoff)
            for cutoff in cutoffs
        )
        row_sums = tuple(sum(count for (j, _), count in zip(cells, counts) if j == i)
                         for i in range(1, s + 1))
        t = sum(row_sums)
        if len(entries) > 1 and t:
            nontrivial_common_fibers += 1
            if common_fiber_example is None:
                common_fiber_example = {
                    "final_coloring": list(z),
                    "profile_cells": [list(cell) for cell in cells],
                    "profile_counts": list(counts),
                    "two_original_colorings": [list(entry[0]) for entry in entries[:2]],
                    "common_witness_member": sorted(family[h]),
                    "common_witness_masses": [str(w) for w in masses[h]],
                    "maximal_cutoffs": [str(u) for u in cutoffs],
                    "strict_high_weight_sets": [sorted(high) for high in high_sets],
                }
        bound = 1
        for i, (high, row_sum, d) in enumerate(zip(high_sets, row_sums, deficits), 1):
            m = sum(count for (j, old), count in zip(cells, counts) if j <= i < old)
            require(d * len(high) <= m <= t, "maximal cutoff and crossing-size bound")
            row_factorial = prod(factorial(count) for (j, _), count in zip(cells, counts)
                                 if j == i)
            require(factorial(row_sum) % row_factorial == 0, "integer multinomial")
            bound *= comb(len(high), row_sum) * factorial(row_sum) // row_factorial
        require(len(entries) <= bound, "injective encoding bound")
        encoded_originals = set()
        contribution = Q(0)
        for a, h0s in entries:
            require(feasible_with(masses[h], a, z, cutoffs, deficits),
                    "common witness transfers across full-profile fiber")
            common_witness_different_from_h0 += sum(h0 != h for h0 in h0s)
            encoded = tuple(
                tuple(x for x in range(n) if z[x] == i and a[x] == old)
                for i, old in cells
            )
            require(encoded not in encoded_originals, "encoding injection")
            encoded_originals.add(encoded)
            reconstructed = list(z)
            for (_, old), vertices in zip(cells, encoded):
                for x in vertices:
                    reconstructed[x] = old
            require(tuple(reconstructed) == a, "exact decoding")
            for i, high in enumerate(high_sets, 1):
                require({x for x in changed(a, z) if z[x] == i} <= high,
                        "minimality forces changed vertices into common high sets")
                expected_crossing = sum(count for (j, old), count in zip(cells, counts)
                                        if j <= i < old)
                require(crossings(a, z, i) == expected_crossing, "profile crossing identity")
            likelihood = coloring_probability(z, palette) * prod(
                ((p * palette[old - 1] / palette[i - 1]) ** count
                 for (i, old), count in zip(cells, counts)), start=Q(1)
            )
            actual = p ** t * coloring_probability(a, palette)
            require(actual == likelihood, "exact likelihood identity")
            contribution += actual
        if t:
            profile_bound = coloring_probability(z, palette) * t ** t * prod(
                (((p * palette[old - 1] / (deficits[i - 1] * palette[i - 1])) ** count)
                 / factorial(count) for (i, old), count in zip(cells, counts)),
                start=Q(1),
            )
            require(contribution <= profile_bound, "factorial full-profile bound")

    R = sum(
        (p * sum(palette[i:]) / (d * palette[i - 1])
         for i, d in enumerate(deficits, 1)), Q(0)
    )
    polynomial = sum((Q(t ** t, factorial(t)) * R ** t for t in range(1, n + 1)), Q(0))
    require(bad_probability / 2 <= total_cover_cost <= polynomial, "full finite probability chain")
    if 3 * R < 1:
        require(polynomial <= R / (1 - 3 * R), "geometric majorant")
        require(bad_probability <= 2 * R / (1 - 3 * R), "universal theorem replay")
    return {
        "name": name,
        "ground_set_size": n,
        "scales": s,
        "original_colorings": (s + 1) ** n,
        "selected_pairs": selected_pairs,
        "minimum_cover_cost": str(cover_cost),
        "bad_probability": str(bad_probability),
        "weighted_cover_sum": str(total_cover_cost),
        "R": str(R),
        "factorial_polynomial": str(polynomial),
        "raw_duplicate_changed_sets": raw_duplicate_changed_sets,
        "raw_duplicate_bad_changed_sets": raw_duplicate_bad_changed_sets,
        "nontrivial_common_fibers": nontrivial_common_fibers,
        "common_fiber_example": common_fiber_example,
        "common_witness_different_from_h0": common_witness_different_from_h0,
        "low_mass_delay_checks": low_mass_delay_checks,
    }


def check_profile_summation():
    tested = 0
    for s in (1, 2, 3):
        weights = tuple(Q(k + 1, 101) for k in range(len(CELLS(s))))
        R = sum(weights)
        for total in range(1, 7):
            direct = sum((
                total ** total * prod((w ** count / factorial(count)
                                       for w, count in zip(weights, counts)), start=Q(1))
                for counts in compositions(total, len(weights))
            ), Q(0))
            require(direct == Q(total ** total, factorial(total)) * R ** total,
                    "exact multinomial factorial summation")
            tested += 1
    for t in range(1, 257):
        require(t ** t <= factorial(t) * 3 ** (t - 1), "factorial majorant")
        require((t + 1) ** t < 3 * t ** t, "successive coefficient ratio")
    require(Q(4, 48 - 8) == Q(1, 10), "improved palette constant")
    require(Q(4, 256 - 8) == Q(1, 62), "original palette improved probability")
    return {"exact_multinomial_sums": tested, "finite_coefficient_checks": 256}


def check_geometric_palettes():
    rows = []
    for D in (48, 256):
        p = Q(1, 4 * D)
        n = 2 * D + 1
        pi1 = D * p
        R = p * (1 - pi1) / (Q(1, 2) * pi1)
        bad = (1 - pi1) ** n
        require(n * p > Q(1, 2), "singleton family is not p-small")
        require(D * p <= Q(1, 2), "geometric color budget")
        require(bad <= 2 * R / (1 - 3 * R), "geometric palette exact probability")
        rows.append({
            "D": D, "p": str(p), "singleton_family_size": n,
            "pi_1": str(pi1), "R": str(R),
            "bad_probability_exact": f"({1 - pi1})^{n}",
        })
    return rows


def compile_lean():
    command = [
        ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"), "--project-root", str(ROOT),
        "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--artifact-dir", str(HERE / "lean"), "--claim", "SEL_CORE175",
        "--timeout", "110",
    ]
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=False)
    (HERE / "lean_verifier_output.json").write_text(result.stdout, encoding="utf-8")
    if result.stderr:
        sys.stderr.write(result.stderr)
    print(result.stdout, flush=True)
    return result.returncode


def official_checks():
    outcomes = {}
    for module in ("math_state", "proof_graph_check"):
        result = subprocess.run(
            [ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}",
             "check", "--project-root", str(ROOT)],
            cwd=ROOT, text=True, capture_output=True, check=False,
        )
        print(result.stdout, end="", flush=True)
        if result.stderr:
            sys.stderr.write(result.stderr)
        outcomes[module] = result.returncode
    require(all(code == 0 for code in outcomes.values()), "campaign-local official checks")
    return outcomes


def main():
    started = time.monotonic()
    truncations = check_truncations()
    print(f"Exact truncation instances: {truncations['exact_truncation_instances']}", flush=True)
    family = (frozenset({0, 1}), frozenset({2, 3}), frozenset({0, 2, 3}))
    masses = (
        (Q(1, 2), Q(1, 2), Q(0), Q(0)),
        (Q(0), Q(0), Q(1, 2), Q(1, 2)),
        (Q(1, 2), Q(0), Q(1, 4), Q(1, 4)),
    )
    cases = [
        ("s=0", family, masses, Q(3, 4), (Q(1),)),
        ("one scale; ties and zero masses", family, masses, Q(3, 4), (Q(99, 100), Q(1, 100))),
        ("two scales; common profile fibers", family, masses, Q(3, 4),
         (Q(99, 100), Q(99, 10000), Q(1, 10000))),
        ("three scales; overlapping supports", family, masses, Q(3, 4),
         (Q(99, 100), Q(99, 10000), Q(99, 1000000), Q(1, 1000000))),
        ("uniform masses; many originals in one fiber",
         (frozenset({0, 1, 2}),), ((Q(1, 3), Q(1, 3), Q(1, 3)),), Q(9, 10),
         (Q(99, 100), Q(99, 10000), Q(1, 10000))),
    ]
    replay = []
    for args in cases:
        record = check_instance(*args)
        replay.append(record)
        print(f"Exact replay: {record['name']}; {record['selected_pairs']} selected pairs", flush=True)
    require(sum(row["raw_duplicate_bad_changed_sets"] for row in replay) > 0,
            "repeated changed sets on bad colorings were actually exercised")
    require(sum(row["nontrivial_common_fibers"] for row in replay) > 0,
            "multi-original common-witness fibers were actually exercised")
    require(sum(row["low_mass_delay_checks"] for row in replay) > 0,
            "low-mass one-level delays were actually exercised")
    summation = check_profile_summation()
    palettes = check_geometric_palettes()
    adapter = json.loads((HERE / "jacobian_output.json").read_text(encoding="utf-8"))
    require(adapter["ok"] is False, "preserve actual Jacobian non-conclusion")
    require(adapter["error"]["data"]["code"] == "INVALID_REQUEST", "actual typed adapter error")
    lean_exit = compile_lean()
    checks = official_checks()
    require(lean_exit == 0, "approved Lean verifier must succeed")
    certificate = {
        "result_class": "new_theorem",
        "independent_review": "pending Host-invoked Reviewer",
        "novelty_status": "unverified; scoped primary-source comparison only",
        "universal_claim": "SEL_GENERAL175",
        "universal_proof": "research/selector_certificate/proof.md",
        "formal_claim": "SEL_CORE175",
        "formal_source": "research/selector_certificate/Main.lean",
        "statement_fidelity": "research/selector_certificate/statement_fidelity.md",
        "formal_scope": "Universal reconstruction, maximal truncation, injective encoding, untruncation, multinomial and factorial/geometric summation components; not the entire probability theorem.",
        "theorem": {
            "R": "sum_i p * sum_{h>i} pi_h / (d_i*pi_i)",
            "finite_bound": "(1/2)Pr(bad) <= sum_{t=1}^{|X|} (t^t/t!) R^t",
            "geometric_bound": "3R<1 implies Pr(bad)<=2R/(1-3R)",
            "geometric_palette": "D>8 implies Pr(bad)<4/(D-8) for s>=1; s=0 has bad probability 0",
            "improved_D": 48,
            "original_D": 256,
            "original_success_lower_bound": "61/62",
            "rounding_constant": 25 * 96 ** 4,
            "staged_rounding_constant": 25 * 512 ** 4,
        },
        "manuscript_statements": [
            "selector.tex thm:multiscale-selector",
            "selector.tex sel:truncation",
            "selector.tex sel:profile-crossings",
            "selector.tex sel:changed-vertices",
            "selector.tex sel:encoding-bound",
            "selector.tex sel:likelihood",
            "selector.tex sel:tuple-sum",
            "rounding.tex round:mass through round:upper",
        ],
        "truncation_replay": truncations,
        "finite_replay_not_universal_proof": replay,
        "exact_algebra_replay": summation,
        "geometric_palette_examples": palettes,
        "jacobian": {
            "operation_id": "optimization.linear.rational_general_optimum.compute",
            "server_version_at_inspection": "0.14.0",
            "protocol_version_at_inspection": "2025-11-25",
            "payload": "research/selector_certificate/jacobian_payload.json",
            "typed_output": "research/selector_certificate/jacobian_output.json",
            "adapter_exit_code": 2,
            "status": "INVALID_REQUEST: simplex basis admission bound; no mathematical conclusion",
        },
        "lean_verifier_exit_code": lean_exit,
        "project_root": str(ROOT),
        "official_check_exit_codes": checks,
        "replay_elapsed_seconds": round(time.monotonic() - started, 3),
    }
    (HERE / "exact_certificate.json").write_text(
        json.dumps(certificate, indent=2) + "\n", encoding="utf-8"
    )
    print("Universal proof and kernel-checked core ready for independent review.", flush=True)


if __name__ == "__main__":
    main()
