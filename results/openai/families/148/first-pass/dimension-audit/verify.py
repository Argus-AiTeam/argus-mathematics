#!/usr/bin/env python3
"""Replay exact diagnostics; do not confuse them with the analytic proof."""

import argparse
from collections import defaultdict
from fractions import Fraction as Q
from functools import lru_cache
import hashlib
from itertools import combinations, product
import json
from math import lcm, prod
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SECTIONS = (
    ROOT / "research/openai_manuscript"
    / "The-entropy-rate-dimension-formula-for-self-similar-measures-on-the-line-September-24-2026"
    / "build/sections"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


@lru_cache(maxsize=None)
def factors(n):
    result = {}
    d = 2
    while d * d <= n:
        while n % d == 0:
            result[d] = result.get(d, 0) + 1
            n //= d
        d += 1
    if n > 1:
        result[n] = result.get(n, 0) + 1
    return result


def entropy_form(weights):
    """Return exact coefficients of log_2(prime), without numerical logs."""
    weights = list(weights)
    require(sum(weights, Q(0)) == 1, "entropy law is not normalized")
    answer = defaultdict(Q)
    for p in weights:
        require(p >= 0, "negative probability")
        if p:
            for prime, exponent in factors(p.numerator).items():
                answer[prime] -= p * exponent
            for prime, exponent in factors(p.denominator).items():
                answer[prime] += p * exponent
    return {p: c for p, c in answer.items() if c}


def linear_combination(*terms):
    answer = defaultdict(Q)
    for scale, form in terms:
        for prime, coefficient in form.items():
            answer[prime] += scale * coefficient
    return {p: c for p, c in answer.items() if c}


def nonnegative(form):
    scale = lcm(*(c.denominator for c in form.values()))
    numerator = denominator = 1
    for prime, coefficient in form.items():
        exponent = coefficient * scale
        require(exponent.denominator == 1, "nonintegral log-product exponent")
        if exponent >= 0:
            numerator *= prime ** int(exponent)
        else:
            denominator *= prime ** -int(exponent)
    return numerator >= denominator


def word_law(system, length):
    rows = []
    for word in product(range(len(system)), repeat=length):
        r, t, mass = Q(1), Q(0), Q(1)
        for i in word:
            ri, ti, pi = system[i]
            t += r * ti
            r *= ri
            mass *= pi
        rows.append((word, r, t, mass))
    require(sum(row[3] for row in rows) == 1, "word probabilities")
    return rows


def merged(rows, key):
    answer = defaultdict(Q)
    for row in rows:
        answer[key(row)] += row[3]
    return dict(answer)


def type_tuple(word, b, m):
    return tuple(
        tuple(word[h:h + b].count(i) for i in range(m))
        for h in range(0, len(word), b)
    )


def grid_law(law, scale):
    answer = defaultdict(Q)
    for x, p in law.items():
        answer[x // scale] += p
    return dict(answer)


def sumset(support, k):
    result = {Q(0)}
    for _ in range(k):
        result = {a + b for a in result for b in support}
    return result


def power_two(n):
    return Q(2 ** n) if n >= 0 else Q(1, 2 ** -n)


def band_index(distance):
    require(distance > 0, "zero distance has no pair band")
    ell = distance.denominator.bit_length() - distance.numerator.bit_length()
    while distance < power_two(-ell):
        ell += 1
    while distance >= power_two(1 - ell):
        ell -= 1
    require(power_two(-ell) <= distance < power_two(1 - ell), "dyadic band")
    return ell


def coding_diagnostics():
    systems = {
        "singleton_negative": [(Q(-1, 2), Q(2), Q(1))],
        "unequal_signed_duplicate_indices": [
            (Q(1, 3), Q(0), Q(1, 3)),
            (Q(1, 3), Q(0), Q(1, 6)),
            (Q(-1, 2), Q(1), Q(1, 2)),
        ],
        "merged_word_collisions": [
            (Q(1, 2), Q(0), Q(1, 2)),
            (Q(1, 2), Q(1), Q(1, 3)),
            (Q(1, 2), Q(2), Q(1, 6)),
        ],
        "subcritical": [(Q(1, 4), Q(0), Q(1, 2)), (Q(1, 4), Q(1), Q(1, 2))],
        "critical": [(Q(1, 2), Q(0), Q(1, 2)), (Q(1, 2), Q(1), Q(1, 2))],
        "supercritical_positive": [
            (Q(2, 3), Q(0), Q(1, 2)), (Q(2, 3), Q(1), Q(1, 2))
        ],
        "supercritical_negative": [
            (Q(-2, 3), Q(0), Q(1, 2)), (Q(-2, 3), Q(1), Q(1, 2))
        ],
    }
    counts = defaultdict(int)
    for name, system in systems.items():
        require(sum(p for _, _, p in system) == 1, name + ": weights")
        require(all(0 < abs(r) < 1 and p > 0 for r, _, p in system), name)
        m, b = len(system), 2
        block_rows = word_law(system, b)
        tail_rows = word_law(system, 2)
        tail = merged(tail_rows, lambda row: row[2])
        for n in (1, 2):
            rows = word_law(system, b * n)
            maps = merged(rows, lambda row: (row[1], row[2]))
            environments = defaultdict(list)
            for row in rows:
                environments[type_tuple(row[0], b, m)].append(row)
            env_law = {}
            average_entropy = {}
            average_grid = {s: {} for s in (Q(1), Q(1, 4), Q(1, 16))}
            full = defaultdict(Q)
            joint = defaultdict(Q)
            for env, group in environments.items():
                mass = sum(row[3] for row in group)
                env_law[env] = mass
                require(len({row[1] for row in group}) == 1, "type fixes signed slope")
                require(all(row[3] / mass == Q(1, len(group)) for row in group),
                        "conditional words are uniform, even with unequal weights")
                law = {x: p / mass for x, p in merged(group, lambda row: row[2]).items()}
                conditional_maps = {
                    x: p / mass for x, p in merged(group, lambda row: (row[1], row[2])).items()
                }
                require(
                    sorted(law.values()) == sorted(conditional_maps.values()),
                    "translation/full-map conditional entropy identity",
                )
                average_entropy = linear_combination(
                    (1, average_entropy), (mass, entropy_form(law.values()))
                )
                for row in group:
                    joint[env, row[1], row[2]] += row[3]
                slope = group[0][1]
                for x, px in law.items():
                    for y, py in tail.items():
                        full[x + slope * y] += mass * px * py
                for s in average_grid:
                    average_grid[s] = linear_combination(
                        (1, average_grid[s]),
                        (mass, entropy_form(grid_law(law, s).values())),
                    )
                for k in (1, 2, 3):
                    ks = sumset(law, k)
                    block_sumsets = []
                    for h in range(n):
                        block_digits = {
                            block_rows[i][2]
                            for i in range(m ** b)
                            if type_tuple(block_rows[i][0], b, m)[0] == env[h]
                        }
                        block_sumsets.append(len(sumset(block_digits, k)))
                    require(len(ks) <= prod(block_sumsets), "conditional sumset product bound")
                    require(len(ks) <= (k + 1) ** (n * m ** b), "uniform sumset bound")
                    counts["sumset_inequalities"] += 1
                for x, y in combinations(law, 2):
                    band_index(abs(x - y))
                    counts["positive_pair_distances"] += 1
                counts["conditional_laws"] += 1
            require(
                linear_combination(
                    (1, entropy_form(joint.values())),
                    (-1, entropy_form(env_law.values())),
                    (-1, average_entropy),
                ) == {},
                "conditional entropy chain identity",
            )
            require(
                nonnegative(linear_combination(
                    (1, average_entropy), (1, entropy_form(env_law.values())),
                    (-1, entropy_form(maps.values())),
                )),
                "conditioning costs at most type entropy",
            )
            for s in average_grid:
                require(nonnegative(linear_combination(
                    (1, entropy_form(grid_law(full, s).values())),
                    (-1, average_grid[s]), (1, {2: Q(1)}),
                )), "fixed-grid comparison against an independent finite future")
                counts["grid_entropy_inequalities"] += 1
            if name == "merged_word_collisions":
                require(len(maps) < len(rows), "nontrivial word collisions exercised")
            if name.startswith("supercritical") or name in ("subcritical", "critical"):
                require(len(maps) == len(rows), "finite no-collision diagnostic")
            counts["prefix_models"] += 1
    counts["systems"] = len(systems)
    return dict(sorted(counts.items()))


def rounding_diagnostics():
    checks = 0
    for contraction in (Q(1), Q(1, 3), Q(-2, 3), Q(1, 1024), Q(-2, 5)):
        z = band_index(abs(contraction))
        for L in range(1, 13):
            ell = L - z
            for multiplier in (Q(1), Q(3, 2), Q(1999, 1000)):
                u = power_two(-ell) * multiplier
                ratio = abs(contraction) * u / power_two(-L)
                require(1 <= ratio < 4, "scaled pair lies in [r,4r)")
                require(1 / ratio + ratio <= 5, "two-point window loss <=5/M")
                checks += 1
    scale_checks = checks
    for previous in (17, 10 ** 50, 10 ** 200):
        A, Ap = Q(7, 3), Q(5, 3)
        n = int((previous + 3) / (A - Ap)) + 1
        a = -(-(A * n).numerator // (A * n).denominator) - 1
        require(a - Ap * n - 1 > previous, "arbitrarily large previous endpoint")
        T, D = 2 * (previous + a + 1), Q(11, 3)
        candidate_count = T // (2 * D * n) + 1
        require(candidate_count * n >= Q(T) / (2 * D), "candidate count")
        U = T // 2
        for z in (0, U // 2, U):
            for ell in (1, previous):
                L = ell + z
                require(1 <= L <= T and L - z == ell, "target recovery")
                checks += 1
    return {"scale_alignment_checks": scale_checks,
            "adaptive_and_target_checks": checks - scale_checks}


def retained_window_diagnostics():
    configurations = cross_band = 0
    for increments in product((Q(1, 2), Q(1), Q(3, 2)), repeat=6):
        depths = [Q(0)]
        for d in increments:
            depths.append(depths[-1] + d)
        ceilings = [-(-d.numerator // d.denominator) for d in depths]
        for L in range(1, 19):
            windows = []
            for band, (n, a, B) in enumerate(((1, 1, 2), (2, 8, 9))):
                for j in range(0, 7 - n, n):
                    if depths[j + n] - depths[j] <= n and a <= L - ceilings[j] <= B:
                        windows.append((j, j + n, band))
            for x, y in combinations(windows, 2):
                require(x[1] <= y[0] or y[1] <= x[0], "retained windows overlap")
                if x[2] != y[2]:
                    finer, coarser = (x, y) if x[2] > y[2] else (y, x)
                    require(finer[1] < coarser[0], "strict cross-band ordering")
                    cross_band += 1
            gain = sum((Q(1, j + 1) - Q(1, end + 1) for j, end, _ in windows), Q(0))
            require(0 <= gain <= 1, "pathwise antitone telescoping bound")
            configurations += 1
    require(cross_band > 0, "diagnostic did not exercise cross-band retention")
    delta, c, D, log_M = Q(1, 5), Q(1, 42), Q(7, 3), 7
    q = int(8 * D * log_M / (delta * c)) + 1
    require(delta * c * q > 8 * D * log_M, "final arbitrary-q contradiction")
    return {"configurations": configurations, "cross_band_pairs": cross_band,
            "exact_contradiction_example_q": q}


def rational(wire):
    return Q(int(wire["num"]), int(wire["den"]))


def jacobian_diagnostic():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    receipt = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    operation = "probability.joint.mutual_information.compute"
    require(status["adapter_exit_code"] == 0 and not status["timeout"], "adapter incomplete")
    require(status["structured_error"] is None and status["output_complete"], "adapter error")
    require(receipt["request"]["operation_id"] == operation, "wrong Jacobian operation")
    require(receipt["request"]["payload"] == payload, "Jacobian payload not bound")
    table = [[rational(p) for p in row] for row in payload["probabilities"]]
    rows = [sum(row) for row in table]
    columns = [sum(row[j] for row in table) for j in range(3)]
    out = receipt["result"]["output"]
    require(rows == [rational(p) for p in out["row_marginals"]], "row marginals")
    require(columns == [rational(p) for p in out["column_marginals"]], "column marginals")
    terms = {}
    for i, row in enumerate(table):
        for j, p in enumerate(row):
            if p:
                terms[i, j] = p / (rows[i] * columns[j])
    require({(t["row_index"], t["column_index"]): rational(t["likelihood_ratio"])
             for t in out["positive_support"]} == terms, "likelihood ratios")
    certificate = out["log_product_certificate"]
    scale = int(certificate["scale"])
    product_value = Q(1)
    for (i, j), ratio in terms.items():
        exponent = scale * table[i][j]
        require(exponent.denominator == 1, "Jacobian exponent")
        product_value *= ratio ** int(exponent)
    require(product_value == rational(certificate["product"]) == 4, "exact MI product")
    require(scale == 4 and rational(out["exact_value"]) == Q(1, 2), "MI=1/2")
    return {"operation_id": operation, "server_version": receipt["server"]["version"],
            "protocol_version": receipt["protocol_version"], "adapter_exit_code": 0,
            "exact_information_bits": "1/2", "average_conditional_deficit": "1",
            "mixture_deficit": "1/2", "general_Jensen_proved_in": "proof.md, Section 2"}


def compiler_record(artifact, source, fidelity):
    record = json.loads((ROOT / artifact).read_text())
    check = record["lean_check"]
    require(check["exit_code"] == 0 and check["audit_exit_code"] == 0, "Lean failed")
    require(check["proof_holes"] == [] and check["status"] == "success", "Lean holes")
    require("4.31.0" in check["tools"]["lean"]["version"], "wrong Lean toolchain")
    for path, digest_key in ((source, "source_sha256"),
                             (fidelity, "statement_fidelity_sha256")):
        require(hashlib.sha256((ROOT / path).read_bytes()).hexdigest() == check[digest_key],
                "compiler evidence does not match current source/fidelity: " + path)
    return {"artifact": artifact, "exit_code": 0, "audit_exit_code": 0,
            "proof_holes": [], "lean_version": "4.31.0"}


def certificate():
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    current = {c["claim_id"]: c for c in state["claims"]}
    core_evidence = [
        e for e in state["evidence"]
        if e["subject"]["subject_id"] == "L_DIMENSION_WINDOW_CORE"
        and e["subject"]["content_hash"] == current["L_DIMENSION_WINDOW_CORE"]["content_hash"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
    ]
    require(bool(core_evidence), "missing claim-bound window-core certificate")
    pair_artifact = "research/pair-bound/certificates/C_PAIR_BOUND-6724e437dd6bbb81.json"
    require(any(
        e["subject"]["subject_id"] == "C_PAIR_BOUND"
        and e["subject"]["content_hash"] == current["C_PAIR_BOUND"]["content_hash"]
        and e["produced_by"] == "reviewer:copilot"
        and e["verdict"] == "supports" and e["artifact"] == pair_artifact
        for e in state["evidence"]
    ), "missing existing independent pair-bound approval")
    labels = {
        "introduction.tex": ("thm:main", "eq:rate-and-lyapunov", "sec:upper"),
        "entropy.tex": ("lem:entropy-calculus", "lem:entropy-dimension",
                        "lem:nonsaturation", "lem:two-point"),
        "types.tex": ("lem:type-deficit", "prop:pair-bands"),
        "windows.tex": ("lem:conditional-gain", "lem:disjoint-windows", "eq:final-window-count"),
    }
    locations = {}
    for filename, anchors in labels.items():
        lines = (SECTIONS / filename).read_text().splitlines()
        for anchor in anchors:
            matches = [i for i, line in enumerate(lines, 1) if "\\label{" + anchor + "}" in line]
            require(len(matches) == 1, "source anchor missing/ambiguous: " + anchor)
            locations[anchor] = {"file": filename, "line": matches[0]}
    return {
        "claim_id": "C_DIMENSION_FORMULA",
        "result_class": "complete_solution",
        "proof_kind": "analytic proof with formally certified finite cores",
        "statement": "For every finite nonempty indexed real affine contraction system with "
                     "0<|r_i|<1 and positive weights, dim_H(mu)=min(1,h_RW/chi), "
                     "with equal complete signed maps merged before taking entropy.",
        "proof": "research/dimension-audit/proof.md",
        "statement_fidelity": "research/dimension-audit/statement_fidelity.md",
        "specialized_inputs": ["reviewed C_PAIR_BOUND",
                               "Feng-Hu Theorem 2.8, arxiv:1002.2036v1"],
        "source_locations": locations,
        "formal_certificates": {
            "pair_bound": compiler_record(pair_artifact, "research/pair-bound/Main.lean",
                                          "research/pair-bound/statement_fidelity.md"),
            "window_core": compiler_record(core_evidence[-1]["artifact"],
                                           "research/dimension-audit/Main.lean",
                                           "research/dimension-audit/statement_fidelity.md"),
        },
        "exact_diagnostics": {"coding": coding_diagnostics(), "rounding": rounding_diagnostics(),
                              "windows": retained_window_diagnostics(),
                              "jacobian": jacobian_diagnostic()},
        "evidence_boundary": {
            "full_dimension_formula_formalized": False,
            "finite_tests_prove_universality": False,
            "analytic_obligations_proved_in_prose": True,
            "independent_review_of_this_proof": "pending; not asserted by this replay",
            "independent_Feng_Hu_citation_attribution": "pending",
            "novelty_status": "not_claimed",
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="write the computed exact certificate")
    args = parser.parse_args()
    result = certificate()
    path = HERE / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    require(json.loads(path.read_text()) == result, "certificate differs from replay")
    print(json.dumps({"ok": True, "claim": result["claim_id"],
                      "diagnostics": result["exact_diagnostics"],
                      "full_theorem_Lean_certificate": False}, sort_keys=True))


if __name__ == "__main__":
    main()
