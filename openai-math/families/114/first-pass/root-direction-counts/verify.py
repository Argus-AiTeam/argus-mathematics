#!/usr/bin/env python3
"""Authenticate the universal Lean proof and replay exact adversarial tests."""

import argparse
from collections import Counter, defaultdict
from fractions import Fraction
from itertools import combinations, product
import json
import hashlib
import os
from pathlib import Path
import re
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = (
    "research/openai_manuscript/"
    "An-FPRAS-for-Common-Integer-Polymatroid-Bases-with-Binary-Capacities-"
    "October-5-2026/build/sections/signatures.tex"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def subset_sum(vector, mask):
    return sum(value for e, value in enumerate(vector) if mask >> e & 1)


def validate_rank(rank):
    size = len(rank)
    require(size >= 1 and size & (size - 1) == 0, "rank table size")
    require(rank[0] == 0, "normalization")
    require(all(type(value) is int for value in rank), "integrality")
    for a in range(size):
        for b in range(size):
            require(
                rank[a] + rank[b] >= rank[a | b] + rank[a & b],
                f"submodularity at {a}, {b}",
            )
    return (size - 1).bit_length()


def monotone(rank):
    return all(
        rank[a] <= rank[b]
        for a in range(len(rank))
        for b in range(len(rank))
        if a & b == a
    )


def in_base(rank, vector):
    return sum(vector) == rank[-1] and all(
        subset_sum(vector, a) <= bound for a, bound in enumerate(rank)
    )


def bases(rank):
    n = validate_rank(rank)
    full = (1 << n) - 1
    bounds = [
        range(rank[full] - rank[full ^ (1 << e)], rank[1 << e] + 1)
        for e in range(n)
    ]
    return tuple(vector for vector in product(*bounds) if in_base(rank, vector))


def translate(rank, vector):
    return tuple(value + subset_sum(vector, a) for a, value in enumerate(rank))


def coverage_rank(n, blocks):
    return tuple(
        sum(weight for mask, weight in blocks if a & mask)
        for a in range(1 << n)
    )


def penalty(rank, vector):
    m = min(
        value + subset_sum(vector, (len(rank) - 1) ^ a)
        for a, value in enumerate(rank)
    )
    value = sum(vector) + rank[-1] - 2 * m
    require(value >= 0, "negative penalty")
    require((value == 0) == in_base(rank, vector), "base-indicator limit")
    return value


def shifted_monotone(rank, lower):
    n = validate_rank(rank)
    shift = tuple(
        max(
            -lower[e],
            max(
                rank[a] - rank[a | (1 << e)]
                for a in range(1 << n)
                if not a >> e & 1
            ),
        )
        for e in range(n)
    )
    result = translate(rank, shift)
    require(monotone(result), "modular shift did not make rank monotone")
    require(all(x + c >= 0 for x, c in zip(lower, shift)), "shifted lower bound")
    return result, shift


def inertia(matrix):
    a = [[Fraction(x) for x in row] for row in matrix]
    require(all(a[i][j] == a[j][i] for i in range(len(a)) for j in range(len(a))),
            "nonsymmetric matrix")
    positive = negative = zero = 0
    while a:
        n = len(a)
        pivot = next((i for i in range(n) if a[i][i]), None)
        if pivot is not None:
            order = [pivot] + [i for i in range(n) if i != pivot]
            a = [[a[i][j] for j in order] for i in order]
            p = a[0][0]
            positive += p > 0
            negative += p < 0
            a = [
                [a[i][j] - a[i][0] * a[0][j] / p for j in range(1, n)]
                for i in range(1, n)
            ]
            continue
        edge = next(
            ((i, j) for i in range(n) for j in range(i + 1, n) if a[i][j]),
            None,
        )
        if edge is None:
            zero += n
            break
        i, j = edge
        order = [i, j] + [k for k in range(n) if k not in edge]
        a = [[a[i][j] for j in order] for i in order]
        p = a[0][1]
        positive += 1
        negative += 1
        a = [
            [
                a[i][j] - (a[i][0] * a[1][j] + a[i][1] * a[0][j]) / p
                for j in range(2, n)
            ]
            for i in range(2, n)
        ]
    return positive, negative, zero


def check_sequence(values):
    support = sorted(t for t, value in values.items() if value)
    if not support:
        return 0
    require(support == list(range(support[0], support[-1] + 1)), "support gap")
    checked = 0
    for a, b in combinations(support, 2):
        for t in range(a + 1, b):
            require(
                values[t] ** (b - a)
                >= values[a] ** (b - t) * values[b] ** (t - a),
                f"global interpolation fails at {a}, {t}, {b}: {values}",
            )
            checked += 1
    return checked


def difference_tests(ranks):
    point_sets = [bases(rank) for rank in ranks]
    stats = Counter()
    examples = []
    for i, first in enumerate(ranks):
        n = validate_rank(first)
        for h, second in enumerate(ranks):
            if len(second) != len(first):
                continue
            counts = Counter(
                tuple(x - y for x, y in zip(x1, x2))
                for x1 in point_sets[i]
                for x2 in point_sets[h]
            )
            stats["rank_pairs"] += 1
            stats["base_pairs"] += len(point_sets[i]) * len(point_sets[h])
            stats["differing_total_rank_pairs"] += first[-1] != second[-1]
            stats["nonmonotone_rank_pairs"] += not monotone(first) or not monotone(second)
            for j, k in combinations(range(n), 2):
                lines = defaultdict(Counter)
                for difference, count in counts.items():
                    key = tuple(
                        difference[e] for e in range(n) if e not in (j, k)
                    ) + (difference[j] + difference[k],)
                    lines[key][difference[j]] = count
                for key, values in lines.items():
                    stats["root_lines"] += 1
                    stats["global_interpolation_inequalities"] += check_sequence(values)
                    stats["singleton_lines"] += len(values) == 1
                    if len(values) >= 3 and len(examples) < 3:
                        examples.append({
                            "first_rank": list(first),
                            "second_rank": list(second),
                            "j": j,
                            "k": k,
                            "fixed_other_coordinates_and_pair_sum": list(key),
                            "counts": {str(t): values[t] for t in sorted(values)},
                        })
            require(
                sum(counts.values()) == len(point_sets[i]) * len(point_sets[h]),
                "pair-count partition",
            )
    stats["negative_base_coordinates"] = sum(
        any(value < 0 for point in points for value in point) for points in point_sets
    )
    return dict(stats), examples


def support_boundary_tests():
    first = translate((0, 1, 1, 1), (-3, 1))
    second = translate((0, 0, 0, 0), (2, -2))
    first_points, second_points = bases(first), bases(second)
    d0 = (0, 0)
    require(first[-1] - second[-1] != sum(d0), "empty-support total obstruction")
    differences = [
        tuple(x - y for x, y in zip(x1, x2))
        for x1 in first_points for x2 in second_points
    ]
    require(
        all(sum(delta) != sum(d0) for delta in differences),
        "pair violates the exact empty-support obstruction",
    )
    x1, x2 = (-2, 4, 0), (1, -3, 2)
    singleton_first = translate((0,) * 8, x1)
    singleton_second = translate((0,) * 8, x2)
    require(bases(singleton_first) == (x1,), "first rigid base")
    require(bases(singleton_second) == (x2,), "second rigid base")
    singleton_d0 = tuple(x - y for x, y in zip(x1, x2))
    singleton_counts = Counter()
    for a in bases(singleton_first):
        for b in bases(singleton_second):
            delta = tuple(x - y for x, y in zip(a, b))
            t = delta[0] - singleton_d0[0]
            if delta[1] == singleton_d0[1] and delta[2] == singleton_d0[2] - t:
                singleton_counts[t] += 1
    require(singleton_counts == {0: 1}, "singleton support count")
    require(check_sequence(singleton_counts) == 0, "singleton interpolation")
    return {
        "empty": {
            "first_rank": list(first),
            "second_rank": list(second),
            "first_bases": [list(point) for point in first_points],
            "second_bases": [list(point) for point in second_points],
            "d0": list(d0),
            "j": 0,
            "k": 1,
            "first_total_minus_second_total": first[-1] - second[-1],
            "displacement_total": sum(d0),
            "all_integer_parameters_excluded_by_total_equation": True,
        },
        "singleton": {
            "first_rank": list(singleton_first),
            "second_rank": list(singleton_second),
            "first_base": list(x1),
            "second_base": list(x2),
            "d0": list(singleton_d0),
            "j": 0,
            "k": 2,
            "counts": {str(t): count for t, count in singleton_counts.items()},
            "all_other_parameters_excluded_by_unique_pair": True,
        },
    }


def grouped_tests():
    ranks = [
        coverage_rank(2, [(1, 1), (2, 1), (3, 1)]),
        coverage_rank(2, [(3, 1)]),
        coverage_rank(3, [(3, 1), (6, 1), (5, 1)]),
    ]
    ranks.append(translate(ranks[0], (-3, 1)))
    configurations = [
        ((0, 0), (0, 0, 1), (1, 2, 2)),
        ((1, 0), (0, 1, 1), (2, 1, 2)),
        ((0, 0), (0, 0, 0), (2, 2, 2)),
        ((0, 0, 0), (0, 0, 2), (2, 2, 1)),
        ((0, 0, 1), (1, 2), (2, 2)),
        ((-2, -1), (0, 0, 1), (1, 2, 2)),
    ]
    stats = Counter()
    q = Fraction(1, 2)
    for rank in ranks:
        n = validate_rank(rank)
        for b, groups, capacities in configurations:
            if len(b) != n:
                continue
            for reflected in (False, True):
                def weight(z):
                    v = list(b)
                    for i, e in enumerate(groups):
                        v[e] += capacities[i] - z[i] if reflected else z[i]
                    return q ** penalty(rank, v)

                def valid(z):
                    return all(0 <= x <= m for x, m in zip(z, capacities))

                for z in product(*(range(m + 1) for m in capacities)):
                    for sign in (-1, 1):
                        active = [
                            i for i in range(len(groups))
                            if 0 <= z[i] + sign <= capacities[i]
                        ]
                        matrix = []
                        normalized = []
                        for i in active:
                            row, norm_row = [], []
                            zi = list(z)
                            zi[i] += sign
                            for j in active:
                                zj, zij = list(z), list(zi)
                                zj[j] += sign
                                zij[j] += sign
                                entry = weight(zij) if valid(zij) else Fraction(0)
                                row.append(entry)
                                norm_row.append(weight(z) * entry / (weight(zi) * weight(zj)))
                            matrix.append(row)
                            normalized.append(norm_row)
                        complement = [[1 - x for x in row] for row in normalized]
                        require(inertia(complement)[1] == 0, "grouped normalized PSD")
                        require(inertia(matrix)[0] <= 1, "grouped signature")
                        stats["normalized_psd_tests"] += 1
                        stats["signature_tests"] += 1
                        stats["removal_tests" if sign == -1 else "addition_tests"] += 1
                stats["configurations"] += 1
    require(inertia([[1, 0], [0, 1]]) == (2, 0, 0), "positive inertia control")
    require(inertia([[0, 1], [1, 0]]) == (1, 1, 0), "null-axis inertia control")
    return dict(stats)


def encoding_test():
    first = translate(coverage_rank(3, [(3, 1), (6, 1), (5, 1)]), (-2, 1, -1))
    second = translate(coverage_rank(3, [(7, 2), (3, 1)]), (0, -2, 1))
    n = validate_rank(first)
    validate_rank(second)
    first_points, second_points = bases(first), bases(second)
    d0 = tuple(x - y for x, y in zip(first_points[0], second_points[0]))
    j, k, a, end = 0, 2, -2, 2
    lower = tuple(min(x[e] for x in second_points) for e in range(n))
    upper = tuple(max(max(x[e] for x in second_points), lower[e] + 2) for e in range(n))
    widths = tuple(u - l for l, u in zip(lower, upper))
    lower1 = tuple(
        lower[e] + d0[e] + (a if e == j else 0) - (end if e == k else 0)
        for e in range(n)
    )
    r1, c1 = shifted_monotone(first, lower1)
    r2, c2 = shifted_monotone(second, lower)
    output = {}
    inequalities = 0
    for t in range(a, end + 1):
        polynomial = Counter()
        limit_pairs = []
        for counts in product(*(range(d + 1) for d in widths)):
            x2 = tuple(l + count for l, count in zip(lower, counts))
            x1 = tuple(
                x2[e] + d0[e] + (t if e == j else -t if e == k else 0)
                for e in range(n)
            )
            p1 = penalty(r1, tuple(x + c for x, c in zip(x1, c1)))
            p2 = penalty(r2, tuple(x + c for x, c in zip(x2, c2)))
            require(p1 == penalty(first, x1), "first modular penalty invariance")
            require(p2 == penalty(second, x2), "second modular penalty invariance")
            p = p1 + p2
            polynomial[p] += 1
            if p == 0:
                limit_pairs.append((x1, x2))
        expected = sum(
            tuple(x - y for x, y in zip(x1, x2))
            == tuple(d0[e] + (t if e == j else -t if e == k else 0) for e in range(n))
            for x1 in first_points for x2 in second_points
        )
        require(polynomial[0] == expected == len(limit_pairs), "unweighted encoding")
        require(len(set(limit_pairs)) == len(limit_pairs), "labelled multiplicity")
        output[t] = polynomial
    for q in (Fraction(1, 2), Fraction(1, 3)):
        values = {t: sum(c * q ** p for p, c in poly.items()) for t, poly in output.items()}
        inequalities += check_sequence(values)
    return {
        "first_rank": list(first),
        "second_rank": list(second),
        "d0": list(d0),
        "j": j,
        "k": k,
        "parameter_interval": [a, end],
        "lower": list(lower),
        "upper": list(upper),
        "first_translation": list(c1),
        "second_translation": list(c2),
        "penalty_polynomials": {
            str(t): {str(p): poly[p] for p in sorted(poly)}
            for t, poly in output.items()
        },
        "ordinary_counts": {str(t): poly[0] for t, poly in output.items()},
        "positive_approximation_interpolations": inequalities,
    }


def rank_family():
    result = set()
    for n in (2, 3):
        masks = list(range(1, 1 << n))
        for first in masks:
            for second in masks:
                rank = coverage_rank(n, [(first, 1), (second, 1)])
                result.add(rank)
                shift = tuple(-2 if e == 0 else e - 1 for e in range(n))
                result.add(translate(rank, shift))
        for r in range(1, 4):
            rank = tuple(min(a.bit_count(), r) for a in range(1 << n))
            result.add(rank)
            result.add(translate(rank, tuple(e - 2 for e in range(n))))
    return sorted(result, key=lambda x: (len(x), x))


def replay_jacobian():
    payload_path = HERE / "jacobian_payload.json"
    output_path = HERE / "jacobian_output.json"
    require(output_path.exists(), "missing required Jacobian output")
    payload = json.loads(payload_path.read_text())
    output = json.loads(output_path.read_text())
    require(
        output.get("result", {}).get("operation_id")
        == "matrix.symmetric.rational_spectrum_claim.check",
        "Jacobian operation binding",
    )
    result = output["result"]["output"]
    require(output.get("server", {}).get("version"), "Jacobian server version missing")
    require(output.get("protocol_version"), "Jacobian protocol missing")
    require(result.get("outcome") == "VALID", "Jacobian did not certify spectrum")
    require(result.get("matrix", {}).get("entries") == payload["matrix"]["entries"],
            "Jacobian source matrix mismatch")
    require(result.get("claimed_profile") == payload["claimed_profile"],
            "Jacobian spectrum claim mismatch")
    matrix = [
        [Fraction(int(x["num"]), int(x["den"])) for x in row]
        for row in payload["matrix"]["entries"]
    ]
    rank = (0, 1, 1, 1)
    validate_rank(rank)
    q = Fraction(1, 2)
    g0 = q ** penalty(rank, (0, 0))
    g1 = q ** penalty(rank, (1, 0))
    g2 = q ** penalty(rank, (2, 0))
    defect = 1 - g0 * g2 / (g1 * g1)
    require(defect == Fraction(3, 4), "rank-one grouped normalization")
    require(matrix == [[defect] * 3 for _ in range(3)], "grouped complement binding")
    require(inertia(matrix) == (1, 0, 2), "independent exact complement inertia")
    return {
        "status": "VALID",
        "operation_id": "matrix.symmetric.rational_spectrum_claim.check",
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "adapter_error": None,
        "timeout": False,
        "inertia": [1, 0, 2],
    }


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def native_certificate(folder, claim_id, source, fidelity, declarations, printed_axioms=True):
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    check = json.loads((folder / "lean_check.json").read_text())
    official = json.loads((folder / "lean_verify_output.json").read_text())
    require(check["status"] == "success", f"{claim_id}: compiler did not succeed")
    require(check["exit_code"] == 0, f"{claim_id}: compiler exit")
    require(check["audit_exit_code"] == 0, f"{claim_id}: axiom-audit exit")
    require(check["proof_holes"] == [], f"{claim_id}: proof holes")
    require(check["source_sha256"] == sha256(source), f"{claim_id}: stale source")
    require(check["statement_fidelity_sha256"] == sha256(fidelity),
            f"{claim_id}: stale statement fidelity")
    version = check["tools"]["lean"]["version"]
    require(version.startswith("Lean (version 4.31.0,"), f"{claim_id}: Lean version")
    foundation = {"propext", "Classical.choice", "Quot.sound"}
    for declaration in declarations:
        if printed_axioms:
            prefix = f"'{declaration}' depends on axioms: ["
            lines = [line for line in check["stdout"].splitlines() if line.startswith(prefix)]
            require(len(lines) == 1 and lines[0].endswith("]"),
                    f"{claim_id}: missing declaration audit: {declaration}")
            require(set(lines[0][len(prefix):-1].split(", ")) == foundation,
                    f"{claim_id}: nonfoundational axiom: {declaration}")
        else:
            name = declaration.rsplit(".", 1)[-1]
            require(re.search(r"^theorem " + re.escape(name) + r"\b", source.read_text(), re.M),
                    f"{claim_id}: expected theorem absent from audited source: {declaration}")
    recording = official["kernel"]
    require(recording["refusals"] == [], f"{claim_id}: recording refused")
    record = recording["recorded"]
    require(record["tier"] == "mechanical" and record["verdict"] == "supports",
            f"{claim_id}: not mechanical supporting evidence")
    require(record["produced_by"] == "lean_evidence/lean 4.31.0",
            f"{claim_id}: evidence producer")
    archive_path = ROOT / record["artifact"]
    archive = json.loads(archive_path.read_text())
    require(archive["lean_check"] == check, f"{claim_id}: archive/compiler mismatch")
    require(archive["subject"] == record["subject"], f"{claim_id}: archive/subject mismatch")
    require(archive["lean_source"]["text"] == source.read_text(),
            f"{claim_id}: archived source mismatch")
    require(archive["statement_fidelity"]["text"] == fidelity.read_text(),
            f"{claim_id}: archived reading mismatch")
    claim = max(
        (c for c in state["claims"] if c["claim_id"] == claim_id),
        key=lambda c: c["version"],
    )
    require(record["subject"]["subject_id"] == claim_id, f"{claim_id}: wrong subject")
    require(record["subject"]["content_hash"] == claim["content_hash"],
            f"{claim_id}: stale claim version")
    require(record in state["evidence"], f"{claim_id}: record absent from ledger")
    require(claim["formal_statement"] == source.read_text(),
            f"{claim_id}: claim formalization differs from source")
    return {
        "claim_id": claim_id,
        "claim_version": claim["version"],
        "status": "success",
        "exit_code": 0,
        "audit_exit_code": 0,
        "proof_holes": [],
        "lean_version": version,
        "source": str(source.relative_to(ROOT)),
        "source_sha256": sha256(source),
        "statement_fidelity_sha256": sha256(fidelity),
        "archived_certificate": record["artifact"],
        "evidence_id": record["evidence_id"],
        "declarations": declarations,
        "printed_axioms": sorted(foundation) if printed_axioms else None,
        "axiom_evidence": "printed_closure_and_native_audit" if printed_axioms else "native_source_audit",
    }


def balanced_dependency():
    folder = ROOT / "research/balanced-summation"
    result = native_certificate(
        folder, "C_BALANCED", folder / "Main.lean", folder / "statement_fidelity.md",
        [
            "BalancedSummation.balanced_pairs_removal_spectral",
            "BalancedSummation.balanced_pairs_addition_spectral",
            "BalancedSummation.fixing_removal_spectral",
            "BalancedSummation.fixing_addition_spectral",
        ],
    )
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    mechanical = next(
        e for e in state["evidence"] if e["evidence_id"] == result["evidence_id"]
    )
    require(
        any(
            e["subject"] == mechanical["subject"]
            and e["tier"] == "judgement"
            and e["verdict"] == "supports"
            and e["produced_by"].startswith("reviewer:")
            and e["artifact"] == mechanical["artifact"]
            for e in state["evidence"]
        ),
        "accepted balanced dependency lacks its independent Reviewer judgement",
    )
    result["independent_review"] = "previously_accepted"
    return result


def formal_evidence():
    balanced = balanced_dependency()
    fidelity = HERE / "statement_fidelity.md"
    grouped = native_certificate(
        HERE / "rank-evidence", "L_ROOT_GROUPED", HERE / "RankSignatures.lean", fidelity,
        [
            "RankSignatures.boxed_disjoint_grouped_signature",
            "RankSignatures.boxed_disjoint_grouped_slice_signature",
            "RankSignatures.boxed_disjoint_grouped_power_signature",
            "RankSignatures.boxed_groupedWeight_limit",
            "RankSignatures.exists_monotone_modular_shift",
        ],
        printed_axioms=False,
    )
    root = native_certificate(
        HERE, "C_ROOT_COUNTS", HERE / "Main.lean", fidelity,
        [
            "RootDirectionCounts.boxPairEquiv",
            "RootDirectionCounts.basePairs_finite",
            "RootDirectionCounts.pairCount_interpolation",
            "RootDirectionCounts.root_direction_logconcavity",
            "RootDirectionCounts.root_direction_real_interpolation",
        ],
    )
    objects = {}
    for module in (HERE / "deps/RankSignatures.olean",
                   HERE / "deps/research/balanced-summation/Main.olean"):
        require(module.exists(), f"missing imported object: {module}")
        for path in sorted(module.parent.glob(module.name + "*")):
            if path.is_file():
                objects[str(path.relative_to(ROOT))] = sha256(path)
    return {
        "accepted_balanced_dependency": balanced,
        "grouped_input": grouped,
        "root_count_theorem": root,
        "linked_object_sha256": objects,
        "unproved_mathematical_inputs": [],
    }


def build_dependencies():
    balanced_dependency()
    accepted = ROOT / "research/balanced-summation"
    check = json.loads((accepted / "lean_check.json").read_text())
    workspace = Path(check["lake_workspace"])
    lake = Path(check["command"][0])
    require(workspace.is_dir() and lake.is_file(), "recorded Lean workspace unavailable")
    env = os.environ.copy()
    env["LEAN_PATH"] = str(HERE / "deps") + (
        ":" + env["LEAN_PATH"] if env.get("LEAN_PATH") else ""
    )
    modules = [
        (accepted / "Main.lean", ROOT,
         HERE / "deps/research/balanced-summation/Main.olean",
         HERE / "balanced-dependency-build.log"),
        (HERE / "RankSignatures.lean", HERE,
         HERE / "deps/RankSignatures.olean", HERE / "rank-dependency-build.log"),
    ]
    for source, module_root, target, log in modules:
        target.parent.mkdir(parents=True, exist_ok=True)
        with log.open("w") as stream:
            subprocess.run(
                [str(lake), "env", "lean", "--root=" + str(module_root),
                 "-o", str(target), str(source)],
                cwd=workspace, env=env, stdin=subprocess.DEVNULL,
                stdout=stream, stderr=subprocess.STDOUT, check=True,
            )
    print(json.dumps({"built_import_modules": 2, "accepted_certificate_reused": True}))


def run():
    ranks = rank_family()
    counts, examples = difference_tests(ranks)
    return {
        "claim": "prop:shift-logconcavity",
        "source": SOURCE,
        "classification": "formal_verification",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "universal_theorem_certified": True,
        "counterexample_found": False,
        "rank_table_order": "bitmask, element e has bit 2**e",
        "integer_rank_functions": len(ranks),
        "difference_counts": counts,
        "support_boundary_cases": support_boundary_tests(),
        "sample_root_lines": examples,
        "grouped_rank_signatures": grouped_tests(),
        "unweighted_limit_encoding": encoding_test(),
        "jacobian": replay_jacobian(),
        "formal_evidence": formal_evidence(),
        "limitations": [
            "Finite tests are not a proof of the arbitrary-submodular theorem.",
            "Engineer delivery does not assert Host-invoked independent acceptance.",
            "No claim of FPRAS correctness or publication-level novelty.",
        ],
    }


def main():
    prefix = (
        "LEAN_PATH=" + str(HERE / "deps") + " "
        "$WORKSPACE/argus-live-update/.venv/bin/python "
        "-m argus_skill.verticals.math.lean_evidence verify "
    )
    parser = argparse.ArgumentParser(
        description=__doc__,
        epilog=(
            "Fresh compiler replay from the campaign root, after --build-dependencies:\n"
            + prefix + "research/root-direction-counts/RankSignatures.lean "
            "--statement-fidelity research/root-direction-counts/statement_fidelity.md "
            "--artifact-dir research/root-direction-counts/rank-evidence "
            "--claim L_ROOT_GROUPED --project-root .\n"
            + prefix + "research/root-direction-counts/Main.lean "
            "--statement-fidelity research/root-direction-counts/statement_fidelity.md "
            "--artifact-dir research/root-direction-counts --claim C_ROOT_COUNTS --project-root ."
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--build-dependencies", action="store_true")
    args = parser.parse_args()
    if args.build_dependencies:
        require(not args.write_certificate, "dependency build and certificate generation are separate")
        build_dependencies()
        return
    result = run()
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    require(certificate.exists(), "missing exact certificate; use --write-certificate")
    require(json.loads(certificate.read_text()) == result, "certificate replay mismatch")
    print(json.dumps({
        "classification": result["classification"],
        "counterexample_found": result["counterexample_found"],
        "rank_functions": result["integer_rank_functions"],
        "root_lines": result["difference_counts"]["root_lines"],
        "signature_tests": result["grouped_rank_signatures"]["signature_tests"],
        "universal_theorem_certified": result["universal_theorem_certified"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
