#!/usr/bin/env python3
"""Exact legal-configuration diagnostics; no finite search proves universality."""

import argparse
import hashlib
import itertools
import json
from collections import Counter, defaultdict
from dataclasses import dataclass
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def edge(u, v):
    return tuple(sorted((u, v)))


def rectangle(m, n):
    assert m >= 3 and n >= 3 and m % 2 == n % 2 == 1
    vertices = tuple(
        (x, y)
        for x in range(1, m + 1)
        for y in range(1, n + 1)
        if (x, y) != (1, 1)
    )
    vs = set(vertices)
    edges = {
        edge(v, w)
        for v in vertices
        for w in ((v[0] + 1, v[1]), (v[0], v[1] + 1))
        if w in vs
    }
    return vertices, edges


def matchings(vertices, edges):
    neighbors = defaultdict(list)
    for u, v in sorted(edges):
        neighbors[u].append(v)
        neighbors[v].append(u)

    def visit(remaining, chosen):
        if not remaining:
            yield frozenset(chosen)
            return
        u = min(remaining)
        for v in neighbors[u]:
            if v in remaining:
                yield from visit(remaining - {u, v}, chosen + [edge(u, v)])

    return list(visit(set(vertices), []))


def check_matching(vertices, edges, matching):
    assert len(matching) * 2 == len(vertices)
    assert set(matching) <= edges
    assert Counter(v for e in matching for v in e) == Counter(vertices)


def loops_of(first, second):
    singles = first ^ second
    adj = defaultdict(list)
    for u, v in sorted(singles):
        adj[u].append(v)
        adj[v].append(u)
    assert all(len(adj[v]) == 2 for v in adj)
    remaining = set(adj)
    loops = []
    while remaining:
        start = min(remaining)
        path = [start]
        previous, current = start, min(adj[start])
        while current != start:
            path.append(current)
            following = next(v for v in adj[current] if v != previous)
            previous, current = current, following
        assert len(path) >= 4 and len(path) % 2 == 0
        assert len(set(path)) == len(path)
        remaining.difference_update(path)
        loops.append(tuple(path))
    return tuple(loops)


def crossings(loop, seam):
    return {
        i: (u[1], 1 if u[0] <= seam else -1)
        for i, u in enumerate(loop)
        for v in [loop[(i + 1) % len(loop)]]
        if min(u[0], v[0]) <= seam < max(u[0], v[0])
    }


@dataclass(frozen=True)
class Arch:
    loop: int
    ends: tuple
    deepest: int


def cap_arches(loops, seam, left):
    arches = []
    for g, loop in enumerate(loops):
        hits = crossings(loop, seam)
        indices = sorted(hits)
        for k, i in enumerate(indices):
            after = loop[(i + 1) % len(loop)]
            if (after[0] <= seam) != left:
                continue
            j = indices[(k + 1) % len(indices)]
            distance = (j - i) % len(loop)
            assert distance > 0
            inside = [loop[(i + d) % len(loop)] for d in range(1, distance + 1)]
            assert all((v[0] <= seam) == left for v in inside)
            depth = (min if left else max)(v[0] for v in inside)
            arches.append(Arch(g, tuple(sorted((hits[i][0], hits[j][0]))), depth))
    return tuple(arches)


def weight_arches(arches, deep, left, cutoff, base=None):
    base = 2 * cutoff if base is None else base
    assert cutoff >= 1 and base >= 1 and base > cutoff - 1
    eligible = tuple(
        a for a in arches if (a.deepest <= deep if left else a.deepest >= deep)
    )
    weights = {}
    for a in eligible:
        nesting = sum(
            b.ends[0] < a.ends[0] < a.ends[1] < b.ends[1] for b in eligible
        )
        weights[a] = Fraction(1, base ** nesting)
    return eligible, weights


def constrained_assignments(nodes, relations, fixed):
    adj = defaultdict(list)
    for u, v, sign in relations:
        adj[u].append((v, sign))
        adj[v].append((u, sign))
    fixed_values = {}
    for u, value in fixed:
        if u in fixed_values and fixed_values[u] != value:
            return 0
        fixed_values[u] = value
    visited = set()
    answer = 1
    for start in nodes:
        if start in visited:
            continue
        relative = {start: 1}
        pending = [start]
        forced = set()
        while pending:
            u = pending.pop()
            visited.add(u)
            if u in fixed_values:
                forced.add(fixed_values[u] * relative[u])
            for v, sign in adj[u]:
                required = relative[u] * sign
                if v in relative:
                    if relative[v] != required:
                        return 0
                else:
                    relative[v] = required
                    pending.append(v)
        if len(forced) > 1:
            return 0
        answer *= 1 if forced else 2
    return answer


def direct_color_count(loops, seams, left_mark, right_mark, sinks):
    """Propagate raw endpoint signs, not either challenged color-ratio formula."""
    a, c, b = seams
    nodes, relations, fixed = set(), [], []
    free_internal = 0
    for g, loop in enumerate(loops):
        by_cut = {s: crossings(loop, s) for s in seams}
        hits = sorted(
            (i, s, row, sign)
            for s, hits_at_cut in by_cut.items()
            for i, (row, sign) in hits_at_cut.items()
        )
        if not hits:
            free_internal += 1
            continue

        def port(hit, after):
            _, seam, row, direction = hit
            if seam != c:
                node = (g, seam, row, "glued")
            else:
                right_side = (direction == 1) == after
                node = (g, seam, row, "R" if right_side else "L")
            nodes.add(node)
            return node

        for h, first in enumerate(hits):
            second = hits[(h + 1) % len(hits)]
            i, seam1, row1, direction1 = first
            _, seam2, row2, direction2 = second
            u, v = port(first, True), port(second, False)
            after_x = loop[(i + 1) % len(loop)][0]
            mark = left_mark if after_x <= a else right_mark if after_x > b else None
            is_marked = (
                mark is not None
                and mark.loop == g
                and mark.ends == tuple(sorted((row1, row2)))
                and seam1 == seam2 == (a if after_x <= a else b)
            )
            if is_marked:
                value = 1 if after_x <= a else -1
                fixed.extend(((u, value), (v, value)))
            else:
                relations.append((u, v, direction1 * direction2))
        for _, _, row, _ in (h for h in hits if h[1] == c):
            left = (g, c, row, "L")
            right = (g, c, row, "R")
            nodes.update((left, right))
            if row in sinks:
                fixed.extend(((left, 1), (right, -1)))
            else:
                relations.append((left, right, 1))
    return 2**free_internal * constrained_assignments(nodes, relations, fixed)


def arc_intersections(loop, left_mark, right_mark, seams, interval):
    a, c, b = seams
    ca, cb = crossings(loop, a), crossings(loop, b)

    def mark_position(arch, cut, hits, left):
        candidates = sorted(hits)
        for k, i in enumerate(candidates):
            j = candidates[(k + 1) % len(candidates)]
            if tuple(sorted((hits[i][0], hits[j][0]))) != arch.ends:
                continue
            after = loop[(i + 1) % len(loop)]
            if (after[0] <= cut) == left:
                return (i + 1) % len(loop)
        raise AssertionError("mark is not an extracted cap arch")

    start = mark_position(left_mark, a, ca, True)
    end = mark_position(right_mark, b, cb, False)
    cm = crossings(loop, c)
    length = (end - start) % len(loop)
    forward = sum(
        cm[i][1]
        for d in range(length)
        for i in [(start + d) % len(loop)]
        if i in cm and interval[0] <= cm[i][0] <= interval[1]
    )
    whole = sum(v for row, v in cm.values() if interval[0] <= row <= interval[1])
    return forward, forward - whole


def tested_event(loops, seam, deep_left, deep_right, interval):
    incompatible = False
    active_loops = 0
    for loop in loops:
        hits = crossings(loop, seam)
        increments = [
            hits[i][1] if i in hits and interval[0] <= hits[i][0] <= interval[1] else 0
            for i in range(len(loop))
        ]
        whole = sum(increments)
        assert whole in (-1, 0, 1)
        active = False
        for i, u in enumerate(loop):
            total = 0
            for d in range(1, len(loop)):
                total += increments[(i + d - 1) % len(loop)]
                v = loop[(i + d) % len(loop)]
                opposite_deep = (
                    u[0] <= deep_left and v[0] >= deep_right
                ) or (v[0] <= deep_left and u[0] >= deep_right)
                if opposite_deep:
                    active |= total != 0
                    incompatible |= total != 0 and total != whole
        active_loops += active
    return incompatible or active_loops >= 2


def inside(point, polygon):
    x, y = point[0], Fraction(point[1]) + Fraction(1, 3)
    return sum(
        u[0] == v[0] and u[0] > x and min(u[1], v[1]) <= y < max(u[1], v[1])
        for u, v in zip(polygon, polygon[1:] + polygon[:1])
    ) % 2 == 1


def audit_configuration(loops, n, seams, deep_left, deep_right, cutoff, observations=None):
    a, c, b = seams
    la, lw = weight_arches(cap_arches(loops, a, True), deep_left, True, cutoff)
    ra, rw = weight_arches(cap_arches(loops, b, False), deep_right, False, cutoff)
    _, optimized_lw = weight_arches(cap_arches(loops, a, True), deep_left, True, cutoff, cutoff)
    _, optimized_rw = weight_arches(cap_arches(loops, b, False), deep_right, False, cutoff, cutoff)
    if len(la) > cutoff or len(ra) > cutoff:
        return Counter(cutoff_exclusions=1)
    hits = sorted(
        (row, g, i)
        for g, loop in enumerate(loops)
        for i, (row, _) in crossings(loop, c).items()
    )
    assert len({row for row, _, _ in hits}) == len(hits)
    rank_sign = {row: (-1) ** (r + 1) for r, (row, _, _) in enumerate(hits)}
    denominator = 2 ** len(loops)
    counts = Counter(configurations=1)
    two_m = 2 * Fraction(cutoff)
    assert two_m.denominator == 1, "these exact diagnostics use integral or half-integral cutoffs"
    q_squared = Fraction(2 * cutoff) ** (2 - two_m.numerator)
    optimized_bound = Fraction(cutoff) ** (-two_m.numerator) / 2
    original_stronger_bound = Fraction((cutoff + 1) ** 2, 8 * cutoff**2) * q_squared
    for lo in range(1, n + 1):
        for hi in range(lo, n + 1):
            interval = (lo, hi)
            rows = [row for row, _, _ in hits if lo <= row <= hi]
            observable = Fraction(0)
            optimized_observable = Fraction(0)
            mark_terms = []
            totals = defaultdict(int)
            for row, g, _ in hits:
                if lo <= row <= hi:
                    totals[g] += rank_sign[row]
            for outer, inner in itertools.permutations(range(len(loops)), 2):
                if not totals[outer] or not totals[inner] or not inside(loops[inner][0], loops[outer]):
                    continue
                for eligible, weights, decay in (
                    (la, lw, Fraction(cutoff - 1, 2 * cutoff)),
                    (ra, rw, Fraction(cutoff - 1, 2 * cutoff)),
                    (la, optimized_lw, Fraction(cutoff - 1, cutoff)),
                    (ra, optimized_rw, Fraction(cutoff - 1, cutoff)),
                ):
                    outer_arches = [x for x in eligible if x.loop == outer]
                    inner_arches = [x for x in eligible if x.loop == inner]
                    for x in inner_arches:
                        assert any(
                            y.ends[0] < x.ends[0] < x.ends[1] < y.ends[1]
                            for y in outer_arches
                        ), ("missing geometric spanning arch", outer, inner, x)
                    assert sum(weights[x] for x in inner_arches) <= decay * sum(
                        weights[x] for x in outer_arches
                    )
                    counts["nested_cap_comparisons"] += 1
            for lm, rm in itertools.product(la, ra):
                raw = Fraction(0)
                for i, j in itertools.combinations(rows, 2):
                    assignments = direct_color_count(loops, seams, lm, rm, (i, j))
                    parity = (-1) ** sum(i < row < j for row, _, _ in hits)
                    assert parity == -rank_sign[i] * rank_sign[j]
                    raw += Fraction(parity * assignments, denominator)
                    counts["raw_sink_counts"] += 1
                if lm.loop == rm.loop:
                    u, v = arc_intersections(loops[lm.loop], lm, rm, seams, interval)
                    expected = Fraction(u * v, 2)
                    assert expected >= 0
                    counts["same_loop_ratios"] += 1
                else:
                    expected = Fraction(-totals[lm.loop] * totals[rm.loop], 4)
                    counts["distinct_loop_ratios"] += 1
                assert raw == expected, (loops, lm, rm, interval, raw, expected)
                counts["negative_individual_mark_terms"] += raw < 0
                observable += lw[lm] * rw[rm] * raw
                optimized_observable += optimized_lw[lm] * optimized_rw[rm] * raw
                if observations is not None:
                    mark_terms.append({
                        "left_loop": lm.loop,
                        "right_loop": rm.loop,
                        "signed_color_ratio": str(raw),
                        "original_weight_product": str(lw[lm] * rw[rm]),
                        "optimized_weight_product": str(optimized_lw[lm] * optimized_rw[rm]),
                    })
            event = tested_event(loops, c, deep_left, deep_right, interval)
            assert observable >= (q_squared / 16 if event else 0), (
                loops, interval, event, observable, q_squared
            )
            assert observable >= (original_stronger_bound if event else 0)
            assert optimized_observable >= (optimized_bound if event else 0)
            negative = sum(Fraction(t["signed_color_ratio"]) < 0 for t in mark_terms)
            if observations is not None and event and (
                not observations or negative and not any(o["negative_mark_terms"] for o in observations)
            ):
                observations.append({
                    "interval_rows": [lo, hi],
                    "tested_event": event,
                    "negative_mark_terms": negative,
                    "original_observable": str(observable),
                    "original_manuscript_lower_bound": str(q_squared / 16),
                    "original_stronger_lower_bound": str(original_stronger_bound),
                    "optimized_observable": str(optimized_observable),
                    "optimized_lower_bound": str(optimized_bound),
                    "mark_terms": mark_terms,
                })
            counts["intervals"] += 1
            counts["detected_intervals"] += event
    return counts


def box(x0, x1, y0, y1):
    return tuple(
        [(x, y0) for x in range(x0, x1 + 1)]
        + [(x1, y) for y in range(y0 + 1, y1 + 1)]
        + [(x, y1) for x in range(x1 - 1, x0 - 1, -1)]
        + [(x0, y) for y in range(y1 - 1, y0, -1)]
    )


def explicit_example(m, n, boxes, seams, depths, cutoff):
    vertices, edges = rectangle(m, n)
    first, second, used = set(), set(), set()
    for coordinates in boxes:
        loop = box(*coordinates)
        assert not used.intersection(loop)
        used.update(loop)
        for i, u in enumerate(loop):
            (first if i % 2 else second).add(edge(u, loop[(i + 1) % len(loop)]))
    remaining = set(vertices) - used
    filler_edges = {e for e in edges if set(e) <= remaining}
    fillers = matchings(tuple(sorted(remaining)), filler_edges)
    assert fillers, "prescribed loops are not legally completable"
    first.update(fillers[0])
    second.update(fillers[0])
    for matching in (first, second):
        check_matching(vertices, edges, matching)
    loops = loops_of(first, second)
    observations = []
    stats = audit_configuration(loops, n, seams, *depths, cutoff, observations)
    return {
        "rectangle": [m, n],
        "deleted_vertex": [1, 1],
        "seams_after_columns": list(seams),
        "deep_lines": list(depths),
        "cutoff": {
            "numerator": Fraction(cutoff).numerator,
            "denominator": Fraction(cutoff).denominator,
        },
        "first_matching": [[list(u), list(v)] for u, v in sorted(first)],
        "second_matching": [[list(u), list(v)] for u, v in sorted(second)],
        "counts": dict(sorted(stats.items())),
        "spot_checks": observations,
    }


def run_diagnostics():
    cases = []
    for m, n, limit in ((5, 3, None), (5, 5, 384)):
        vertices, edges = rectangle(m, n)
        covers = matchings(vertices, edges)
        for cover in covers:
            check_matching(vertices, edges, cover)
        if (m, n) == (5, 3):
            payload = json.loads((ROOT / "jacobian_payload.json").read_text())
            expected_edges = {
                (vertices.index(u), vertices.index(v)) for u, v in edges
            }
            assert payload["graph"]["vertex_count"] == len(vertices)
            assert {(e["u"], e["v"]) for e in payload["graph"]["edges"]} == expected_edges
            result = json.loads((ROOT / "jacobian_output.json").read_text())
            assert result["request"]["payload"] == payload
            assert result["result"]["operation_id"] == "graph.polynomial.matching.compute"
            constant = next(
                t["coefficient"] for t in result["result"]["output"]["terms"] if t["degree"] == 0
            )
            assert constant == (-1) ** (len(vertices) // 2) * len(covers)
        seen, stats = set(), Counter()
        for first, second in itertools.product(covers, repeat=2):
            signature = tuple(sorted(Counter((*first, *second)).items()))
            if signature in seen:
                continue
            seen.add(signature)
            loops = loops_of(first, second)
            stats.update(audit_configuration(loops, n, (1, 2, 3), 1, m, 3))
            if limit is not None and len(seen) >= limit:
                break
        cases.append({
            "rectangle": [m, n],
            "deleted_vertex": [1, 1],
            "seams_after_columns": [1, 2, 3],
            "deep_lines": [1, m],
            "cutoff": 3,
            "legal_single_matchings": len(covers),
            "uncolored_configurations_examined": len(seen),
            "exhaustive_matching_pair_search": limit is None,
            "counts": dict(sorted(stats.items())),
        })
    explicit = [
        explicit_example(
            5, 3, [(1, 5, 2, 3)], (1, 2, 3), (1, 5), 1,
        ),
        explicit_example(
            7, 5, [(1, 7, 2, 5), (2, 6, 3, 4)], (2, 3, 4), (2, 6), Fraction(5, 2),
        ),
        explicit_example(
            9, 9, [(2, 9, 1, 9), (3, 8, 2, 8), (4, 7, 3, 7)],
            (4, 5, 6), (4, 7), 3,
        ),
        explicit_example(
            9, 15, [(2, 9, 1, 7), (3, 8, 2, 6), (2, 9, 9, 15), (3, 8, 10, 14)],
            (3, 4, 5), (3, 8), 4,
        ),
    ]
    return {"enumerated_cases": cases, "explicit_legal_examples": explicit}


def formal_certificate():
    run = json.loads((ROOT / "lean_run.json").read_text())
    relative = run["kernel"]["recorded"]["artifact"]
    path = (ROOT.parent.parent / relative).resolve()
    assert path.parent == ROOT / "certificates"
    certificate = json.loads(path.read_text())
    assert certificate["subject"]["subject_id"] == "C_CAP_FORMAL"
    assert certificate["tier"] == "mechanical" and certificate["verdict"] == "supports"
    check = certificate["lean_check"]
    assert check["status"] == "success" and check["exit_code"] == 0
    assert check["audit_exit_code"] == 0 and check["proof_holes"] == []
    assert check["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,")
    for filename, text_key, digest_key in (
        ("Main.lean", "lean_source", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity", "statement_fidelity_sha256"),
    ):
        text = (ROOT / filename).read_text()
        assert certificate[text_key]["text"] == text
        assert hashlib.sha256(text.encode()).hexdigest() == check[digest_key]
    return {
        "claim": "C_CAP_FORMAL",
        "certificate": relative,
        "compiler_exit_code": 0,
        "axiom_audit_exit_code": 0,
        "proof_holes": [],
        "current_source_and_fidelity_match": True,
        "coverage": "arbitrary finite chains, bilinear color sums, integer signs, local trace counts",
        "not_formalized": "lattice gluing, planar containment, and geometric extraction; proved in report.md",
    }


def literal_assertions():
    base = ROOT.parent / "openai_manuscript" / (
        "The-curve-scaling-limit-of-half-plane-double-dimers-September-23-2026"
    ) / "build" / "sections"
    assertions = []
    for filename, label, environment in (
        ("20-transfer.tex", "lem:marked-cap", "lemma"),
        ("30-short-segment.tex", "lem:color-contractions", "lemma"),
        ("30-short-segment.tex", "lem:cap-weight-decrease", "lemma"),
        ("30-short-segment.tex", "lem:two-chain-positivity", "lemma"),
        ("30-short-segment.tex", "eq:pointwise-detection", "equation"),
    ):
        source = (base / filename).read_text()
        marker = "\\label{" + label + "}"
        assert source.count(marker) == 1
        location = source.index(marker)
        opening, closing = "\\begin{" + environment + "}", "\\end{" + environment + "}"
        start = source.rfind(opening, 0, location)
        finish = source.index(closing, location) + len(closing)
        assert start >= 0
        assertions.append({
            "source": str((base / filename).relative_to(ROOT.parent.parent)),
            "label": label,
            "verbatim": source[start:finish],
        })
    return assertions


def main():
    if not __debug__:
        raise RuntimeError("Run this exact verifier without Python optimization (-O).")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    diagnostics = run_diagnostics()
    certificate = {
        "classification": "universal_prose_theorem_with_kernel_checked_algebraic_core",
        "result_class": "new_theorem",
        "novelty_status": "pending_independent_review",
        "significance_status": "pending_independent_review",
        "independent_review": "Host invocation required; no acceptance recorded",
        "universal_claim": "C_CAP_DETECTION",
        "extension_claim": "C_CAP_GENERALIZED",
        "universal_proof": "research/cap_positivity/report.md",
        "finite_tests_prove_universality": False,
        "literal_source_assertions": literal_assertions(),
        "theorem": {
            "hypotheses": "Legal manuscript configuration; real M>=1; real B>=1 and B>M-1; unchanged eligibility, seams, signs and cutoff",
            "weights": "B^(-b(A))",
            "detection_coefficient": "(B-M+1)^2/(2*B^(2*M))",
            "original_weights": "B=2*M; implies the original q_M^2/16 bound",
            "additional_optimal_base_in_this_bound_family": "B=M",
            "additional_detection_coefficient": "1/(2*M^(2*M))",
            "main_CLE4_theorem_certified": False,
            "false_manuscript_assertion_established": False,
        },
        "formal_core": formal_certificate(),
        "diagnostics": diagnostics,
    }
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    assert json.loads(path.read_text()) == certificate
    print(json.dumps({
        "verified": True,
        "classification": certificate["classification"],
        "formal_core": certificate["formal_core"],
        "enumerated": [
            {"rectangle": c["rectangle"], "configurations": c["uncolored_configurations_examined"]}
            for c in diagnostics["enumerated_cases"]
        ],
        "explicit_examples": [
            {
                "rectangle": c["rectangle"],
                "counts": c["counts"],
                "spot_checks": [
                    {k: v for k, v in o.items() if k != "mark_terms"} for o in c["spot_checks"]
                ],
            }
            for c in diagnostics["explicit_legal_examples"]
        ],
        "independent_review": certificate["independent_review"],
    }, indent=2))


if __name__ == "__main__":
    main()
