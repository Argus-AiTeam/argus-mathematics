#!/usr/bin/env python3
"""Replay exact adversarial experiments and check the fresh Lean certificate."""

import argparse
import hashlib
import itertools
import json
from fractions import Fraction as Q
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def matchings(items):
    if not items:
        yield ()
        return
    first, *rest = items
    for i, second in enumerate(rest):
        for tail in matchings(rest[:i] + rest[i + 1 :]):
            yield ((first, second),) + tail


def reversals(vertices, degree):
    for pairs in matchings(list(range(vertices * degree))):
        reverse = [None] * (vertices * degree)
        for a, b in pairs:
            reverse[a], reverse[b] = b, a
        yield tuple(reverse)


def continuation(vertices, degree, reverse, compatible, near, n):
    states = len(near)
    darts = range(vertices * degree)
    require(n >= 1, "positive cutoff")
    require(len(reverse) == vertices * degree, "complete incidence set")
    require(
        all(reverse[reverse[e]] == e and reverse[e] != e for e in darts),
        "fixed-point-free reversal",
    )
    require(
        all(near[j][k] == near[k][j] for j in range(states) for k in range(states)),
        "symmetric state steps",
    )
    layers = [[[False] * states for _ in darts]]
    for length in range(1, n + 1):
        layer = []
        for e in darts:
            x, y = e // degree, reverse[e] // degree
            row = []
            for j in range(states):
                if length == 1:
                    found = any(near[j][k] and compatible[y][k] for k in range(states))
                else:
                    found = any(
                        near[j][k] and layers[-1][f][k]
                        for k in range(states)
                        for f in range(y * degree, (y + 1) * degree)
                        if f != reverse[e]
                    )
                row.append(compatible[x][j] and found)
            layer.append(row)
        layers.append(layer)
    bad = [
        any(layers[n][e][j] for e in range(x * degree, (x + 1) * degree) for j in range(states))
        for x in range(vertices)
    ]
    records = [
        [max([0] + [t for t in range(1, n) if layers[t][e][j]]) for j in range(states)]
        for e in darts
    ]
    exceptional = [
        [
            bad[e // degree]
            or all(
                records[f][j] < records[e][j]
                for f in range((e // degree) * degree, (e // degree + 1) * degree)
                if f != e
            )
            for j in range(states)
        ]
        for e in darts
    ]
    for t in range(2, n + 1):
        require(
            all(not layers[t][e][j] or layers[t - 1][e][j] for e in darts for j in range(states)),
            "actual matched-walk prefix property",
        )
    for x in range(vertices):
        if not bad[x]:
            for j in range(states):
                require(
                    sum(exceptional[e][j] for e in range(x * degree, (x + 1) * degree)) <= 1,
                    "unique strict maximum at a good vertex",
                )
    for e in darts:
        x, y = e // degree, reverse[e] // degree
        for j in range(states):
            for k in range(states):
                if compatible[x][j] and compatible[y][k] and near[j][k]:
                    require(exceptional[e][j] or exceptional[reverse[e]][k], "continuation covering")
    return bad, records, exceptional, layers


def exhaustive_records():
    counts = {"graphs": 0, "contexts": 0, "zero_good_records": 0, "positive_good_ties": 0}
    for vertices, degree in ((1, 2), (1, 4), (2, 2), (2, 4), (3, 2), (4, 2)):
        graph_family = (cycle_reverse(4),) if vertices == 4 else reversals(vertices, degree)
        for reverse in graph_family:
            counts["graphs"] += 1
            for state_count in (0, 1, 2):
                near_options = (False, True) if state_count == 2 else (False,)
                for off_diagonal in near_options:
                    near = [
                        [j == k or off_diagonal for k in range(state_count)]
                        for j in range(state_count)
                    ]
                    for mask in range(1 << (vertices * state_count)):
                        comp = [
                            [bool(mask & (1 << (x * state_count + j))) for j in range(state_count)]
                            for x in range(vertices)
                        ]
                        for n in (1, 2, 3, 4):
                            bad, records, _, _ = continuation(vertices, degree, reverse, comp, near, n)
                            counts["contexts"] += 1
                            for x in range(vertices):
                                if bad[x]:
                                    continue
                                for j in range(state_count):
                                    rs = [records[e][j] for e in range(x * degree, (x + 1) * degree)]
                                    counts["zero_good_records"] += rs.count(0)
                                    counts["positive_good_ties"] += int(max(rs) > 0 and rs.count(max(rs)) > 1)
    require(counts["positive_good_ties"] > 0, "positive tied records must be exercised")
    _, _, _, loop_layers = continuation(1, 2, (1, 0), [[True]], [[True]], 4)
    require(loop_layers[4][0][0], "the same loop incidence may repeat")
    reverse = (4, 5, 6, 7, 0, 1, 2, 3)
    _, _, _, parallel_layers = continuation(2, 4, reverse, [[True], [True]], [[True]], 4)
    require(parallel_layers[4][0][0], "a return along another parallel edge is nonbacktracking")
    counts["explicit_repeated_state_loop_and_parallel_cases"] = 2
    return counts


def cycle_reverse(vertices):
    reverse = [None] * (2 * vertices)
    for x in range(vertices):
        e, r = 2 * x, 2 * ((x + 1) % vertices) + 1
        reverse[e], reverse[r] = r, e
    return tuple(reverse)


def dot(left, right):
    return sum((a * b for a, b in zip(left, right)), Q(0))


def scalar_and_signed():
    counts = {
        "contexts": 0,
        "opposing_tests": 0,
        "signed_one_sided_checks": 0,
        "averaged_obstructions": 0,
        "empty_prescription_sets": 0,
        "nonempty_good_prescriptions": 0,
        "strict_threshold_pairs": 0,
        "equal_threshold_pairs": 0,
        "greater_threshold_pairs": 0,
    }
    signed_vectors = tuple(itertools.product(map(Q, (-2, -1, 0, 1, 2)), repeat=3))
    for vertices, points, L, K, n_choice in itertools.product(
        (12, 20),
        ((-1, 0, 1), (0, 1, 3), (0, 2, 5)),
        (Q(0), Q(1, 2), Q(1)),
        (Q(1), Q(2)),
        (2, 5, "long"),
    ):
        points = tuple(map(Q, points))
        n = vertices + 1 if n_choice == "long" else n_choice
        degree, reverse = 2, cycle_reverse(vertices)
        labels = [Q(min(x, vertices - x)) for x in range(vertices)]
        distances = [[abs(j - k) for k in points] for j in points]
        near = [[d <= 2 * L for d in row] for row in distances]
        comp = [[abs(label - j) <= K + 2 * L + 1 for j in points] for label in labels]
        bumps = [[L * max(1 - abs(label - j) / K, 0) for j in points] for label in labels]
        for e in range(2 * vertices):
            require(abs(labels[e // 2] - labels[reverse[e] // 2]) <= 1, "edge label bound")
        for x in range(vertices):
            require(all(0 <= b <= L for b in bumps[x]), "bump range")
            for j in range(3):
                require(not bumps[x][j] > 0 or abs(labels[x] - points[j]) < K, "strict bump support")
                for k in range(3):
                    require(abs(bumps[x][j] - bumps[x][k]) <= distances[j][k], "bump Lipschitz")
        bad, _, exceptional, _ = continuation(vertices, 2, reverse, comp, near, n)
        functions = []
        for e in range(2 * vertices):
            x, y, r = e // 2, reverse[e] // 2, reverse[e]
            data = {}
            for j in range(3):
                if not exceptional[e][j]:
                    data[j] = bumps[x][j]
                if not exceptional[r][j]:
                    require(j not in data or data[j] == -bumps[y][j], "intersection consistency")
                    data[j] = -bumps[y][j]
            counts["empty_prescription_sets"] += int(not data)
            counts["nonempty_good_prescriptions"] += int(bool(data) and not bad[x] and not bad[y])
            f = [
                max(-L, min(L, min((v + distances[j][k] for k, v in data.items()), default=Q(0))))
                for j in range(3)
            ]
            require(all(-L <= v <= L for v in f), "clipped range")
            for j in range(3):
                require(exceptional[e][j] or f[j] == bumps[x][j], "left prescription")
                require(exceptional[r][j] or f[j] == -bumps[y][j], "right prescription")
                for k in range(3):
                    d = distances[j][k]
                    counts["strict_threshold_pairs"] += int(d < 2 * L)
                    counts["equal_threshold_pairs"] += int(d == 2 * L)
                    counts["greater_threshold_pairs"] += int(d > 2 * L)
                    require(abs(f[j] - f[k]) <= d, "extended scalar test is Lipschitz")
                    if not exceptional[e][j] and not exceptional[r][k]:
                        require(bumps[x][j] + bumps[y][k] <= d, "opposing cross pair")
                        if d <= 2 * L:
                            require(bumps[x][j] == bumps[y][k] == 0, "closed-threshold zero data")
            for mu in signed_vectors:
                loss_x = sum((abs(mu[j]) for j in range(3) if exceptional[e][j]), Q(0))
                loss_y = sum((abs(mu[j]) for j in range(3) if exceptional[r][j]), Q(0))
                require(dot(bumps[x], mu) - 2 * L * loss_x <= dot(f, mu), "signed left variation loss")
                require(dot(bumps[y], mu) - 2 * L * loss_y <= -dot(f, mu), "signed right variation loss")
                counts["signed_one_sided_checks"] += 2
            functions.append(f)
            counts["opposing_tests"] += 1
        mu = [tuple(map(Q, ((2, -1, 0), (0, 2, -1), (-1, 0, 2))[x % 3])) for x in range(vertices)]
        variation = [sum(map(abs, row)) for row in mu]
        loss = [
            sum((abs(mu[e // 2][j]) for j in range(3) if exceptional[e][j]), Q(0))
            for e in range(2 * vertices)
        ]
        for x in range(vertices):
            require(
                bad[x] or sum(loss[2 * x : 2 * x + 2]) <= variation[x],
                "good-vertex incidence dilution",
            )
        Vbound, beta = max(variation), Q(sum(bad), vertices)
        a0 = min(dot(bumps[x], mu[x]) for x in range(vertices))
        Lambda = max(
            L * sum(abs(mu[e // 2][j] - mu[reverse[e] // 2][j]) for j in range(3))
            for e in range(2 * vertices)
        )
        require(sum(loss) == sum(loss[reverse[e]] for e in range(2 * vertices)), "reversal invariance")
        require(Q(sum(loss), 2 * vertices) <= Vbound / 2 + Vbound * beta, "averaged variation")
        for e, f in enumerate(functions):
            x, y = e // 2, reverse[e] // 2
            pairing = dot(f, [a - b for a, b in zip(mu[x], mu[y])])
            require(2 * a0 - 2 * L * (loss[e] + loss[reverse[e]]) <= pairing, "edge lower bound")
            require(abs(pairing) <= Lambda, "uniform bounded-test upper bound")
        require(2 * a0 - 4 * L * Vbound * (Q(1, 2) + beta) <= Lambda, "normalized obstruction")
        counts["contexts"] += 1
        counts["averaged_obstructions"] += 1
    require(counts["nonempty_good_prescriptions"] > 0, "tests cannot all be empty or bad")
    require(all(counts[name] > 0 for name in (
        "strict_threshold_pairs", "equal_threshold_pairs", "greater_threshold_pairs"
    )), "all three exact distance comparisons must be exercised")
    return counts


def jacobian_replay():
    payload = json.loads((ROOT / "jacobian_reduced_payload.json").read_text())
    envelope = json.loads((ROOT / "jacobian_reduced_output.json").read_text())
    require(envelope["request"]["payload"] == payload, "Jacobian payload binding")
    require(envelope["server"]["version"] == "0.14.0", "preserved Jacobian server version")
    require(envelope["protocol_version"] == "2025-11-25", "preserved protocol")
    result = envelope["result"]["output"]
    require(result["program"] == payload["program"] and result["status"] == "OPTIMAL", "typed LP conclusion")
    rational = lambda r: Q(int(r["num"]), int(r["den"]))
    point = tuple(map(rational, result["primal_candidate"]))
    dual = tuple(map(rational, result["constraint_dual"]))
    require(point == (0,), "unique tight midpoint extension")
    program = payload["program"]
    slacks = []
    for row in program["constraints"]:
        lhs = dot(map(rational, row["coefficients"]), point)
        rhs = rational(row["rhs"])
        require(row["relation"] == "LE" and lhs <= rhs, "exact LP primal feasibility")
        slacks.append(rhs - lhs)
    require(slacks == list(map(rational, result["constraint_slacks"])), "exact slacks")
    objective = dot(map(rational, program["objective"]["coefficients"]), point)
    dual_objective = dot(dual, [rational(row["rhs"]) for row in program["constraints"]])
    require(all(d <= 0 for d in dual), "minimization LE dual sign")
    require(
        sum(dual[i] * rational(row["coefficients"][0]) for i, row in enumerate(program["constraints"]))
        == rational(program["objective"]["coefficients"][0]),
        "dual stationarity",
    )
    require(objective == dual_objective == rational(result["primal_objective"]) == rational(result["dual_objective"]) == 0,
            "exact primal-dual equality")
    require(all(a * b == 0 for a, b in zip(dual, slacks)), "complementary slackness")
    require(all(rational(r) == 0 for r in result["lower_bound_dual"] + result["upper_bound_dual"]),
            "unused bound multipliers")
    require(all(rational(r) == 0 for r in result["stationarity_residuals"] + result["primal_residuals"]),
            "replayed zero residuals")
    rejected = json.loads((ROOT / "jacobian_output.json").read_text())
    require(not rejected["ok"] and rejected["error"]["data"]["code"] == "INVALID_REQUEST",
            "original oversized normalization remains a non-conclusion")
    f = (Q(1), point[0], Q(-1))
    require(all(abs(f[j] - f[k]) <= abs(j - k) for j in range(3) for k in range(3)),
            "full three-state scalar reconstruction")
    require(dot(f, (Q(2), Q(-3), Q(1))) == 1, "restored constant in signed objective")
    return {
        "operation_id": envelope["result"]["operation_id"],
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "adapter_exit": 0,
        "status": result["status"],
        "unique_extension": ["1", "0", "-1"],
        "full_signed_objective": "1",
        "initial_request": "INVALID_REQUEST: simplex-basis admission limit; no mathematical conclusion",
    }


def lean_certificate():
    result = json.loads((ROOT / "lean_check.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0, "successful real compiler run")
    require(result["proof_holes"] == [], "zero Lean proof holes")
    require(result["audit_exit_code"] == 0, "successful kernel axiom audit")
    for name, key in (("Main.lean", "source_sha256"), ("statement_fidelity.md", "statement_fidelity_sha256")):
        require(hashlib.sha256((ROOT / name).read_bytes()).hexdigest() == result[key], "fresh source/fidelity binding")
    require("sorryAx" not in result["stdout"] + result["audit_stdout"], "no sorry axiom dependency")
    require("4.31.0" in json.dumps(result["tools"]), "Lean 4.31.0 toolchain")
    return {
        "source": "Main.lean",
        "fidelity": "statement_fidelity.md",
        "compiler_result": "lean_check.json",
        "status": "success",
        "exit_code": 0,
        "audit_exit_code": 0,
        "proof_holes": [],
        "claim": "C_SIGNED_CONTINUATION",
        "theorem": "SignedContinuation.BumpData.signed_continuation",
    }


def run(experiments_only=False):
    result = {
        "result_class": "finite_experiment" if experiments_only else "formal_verification",
        "scope": "Parameter-uniform signed continuation component, not the complete manuscript",
        "records": exhaustive_records(),
        "scalar_signed": scalar_and_signed(),
        "jacobian": jacobian_replay(),
        "refutation_found": False,
    }
    if not experiments_only:
        result["lean"] = lean_certificate()
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--experiments-only", action="store_true")
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    require(not (args.experiments_only and args.write_certificate), "finite experiments are not a universal certificate")
    result = run(args.experiments_only)
    if args.write_certificate:
        (ROOT / "exact_certificate.json").write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
        require(json.loads((ROOT / "exact_certificate.json").read_text()) == result, "persisted certificate readback")
    elif not args.experiments_only:
        expected = json.loads((ROOT / "exact_certificate.json").read_text())
        require(result == expected, "exact certificate replay")
    print(json.dumps(result, indent=2, sort_keys=True))
