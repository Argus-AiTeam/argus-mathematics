#!/usr/bin/env python3
"""Replay exact arithmetic and finite diagnostics accompanying report.md."""

import argparse
import itertools
import json
import math
from collections import defaultdict
from fractions import Fraction as Q
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def rational(value):
    return Q(int(value["num"]), int(value["den"]))


def encoded(value):
    value = Q(value)
    return f"{value.numerator}/{value.denominator}"


def analytic_budget():
    m = 2**1024 + 1
    require(m % 2 == 1 and 257 <= m < 2**1025, "finite odd width")
    require(8 * 1025 < 96**2, "R upper bound from log(2)<1")
    require(2**1024 < m, "sqrt(m)>2^512")
    require(m**3 < 2**3076, "h>2^-1538")
    require(m**5 > 2**5120, "tail power bound")
    require(Q(96, m - 1) + Q(1, m) < 1, "central density comparison")
    require(1 + 1 + Q(1, 2) + Q(1, 4) < 4, "exp(1)<4 series bound")
    require(2 * 4 < 3**2, "normal density prefactor exceeds 1/3")
    require(96 * ((2 * 96 + 1) ** 2 + 1) == 3576000, "central constant")
    require(3 * 16 * (96 + 2) == 4704, "tail constant")
    central = Q(3576000 * 4**194, 2**512)
    tail = Q(4704, 2**2560)
    require(central == Q(3576000, 2**124), "exponential cancellation")
    require(central < Q(1, 2**102), "central strict bound")
    require(tail < Q(1, 2**102), "tail strict bound")
    require(central + tail < Q(1, 2**101) < Q(1, 4), "strict J bound")
    require(Q(1, m**2) < Q(1, 2**2048), "S bound")
    require(98**2 // 2 == 4802 and 1538 + 2 * 4802 == 11142,
            "interval mass exponent")
    require(Q(2, 3) > Q(1, 2), "beta_i>2^-11143")
    return {
        "m": "2^1024+1",
        "R": "sqrt(8*log(m))",
        "h": "m^(-3/2)",
        "central_upper": "3576000/2^124",
        "tail_upper": "4704/2^2560",
        "J_strict_upper": "2^-101",
        "S_strict_upper": "2^-2048",
        "each_beta_strict_lower": "2^-11143",
        "p_star_strict_lower": "2^(-11143*m)",
        "eta0": "2^(-11143*m-1)",
        "deficit_strict_lower": "(1-2^-101)*p_star",
        "quadrature_used": False,
    }


def cancellation_truth_tables():
    checked = 0
    for m in range(1, 9):
        for selected in range(m):
            for passes in itertools.product((0, 1), repeat=m):
                p = math.prod(v for i, v in enumerate(passes) if i != selected)
                b = math.prod(passes)
                lhs = int(bool(p) and not bool(b))
                rhs = sum(int(i == selected) *
                          math.prod(v for j, v in enumerate(passes) if j != i)
                          for i in range(m)) - b
                require(lhs == rhs, "pointwise exceptional cancellation")
                checked += 1
    return {"widths": [1, 8], "selected_index_and_test_patterns": checked}


def report(u, leaves, selected, intervals):
    passes = [lo <= z <= hi for z, (lo, hi) in zip(leaves, intervals)]
    b = all(passes)
    p = all(v for j, v in enumerate(passes) if j != selected)
    if p and not b:
        return ("A",)
    if b:
        return ("B", leaves)
    return ("Pc", u, selected,
            tuple((j, z) for j, z in enumerate(leaves) if j != selected))


def endpoint_cells():
    results = []
    for m, width in ((3, Q(1, 4)), (3, Q(1)), (5, Q(1, 4))):
        radius = Q(2)
        centers = [1 - radius + 2 * radius * i / (m - 1) for i in range(m)]
        intervals = [(a - width, a + width) for a in centers]
        cuts = [(centers[i] + centers[i + 1]) / 2 - 1 for i in range(m - 1)]
        us = sorted({-radius - 1, -radius, Q(0), radius, radius + 1}
                    | {c + offset for c in cuts
                       for offset in (-Q(1, 100), Q(0), Q(1, 100))})
        alphabets = [tuple(sorted({lo - 1, lo, a, hi, hi + 1}))
                     for a, (lo, hi) in zip(centers, intervals)]

        def select(u):
            if abs(u) > radius:
                return m // 2
            return min(range(m), key=lambda i: (abs(1 + u - centers[i]), i))

        for i, cut in enumerate(cuts):
            require(select(cut) == i, "lower-index selector tie")
        require(select(-radius) == 0 and select(radius) == m - 1,
                "selector at radius endpoints")
        require(select(-radius - 1) == select(radius + 1) == m // 2,
                "middle fallback")
        for i, (lo, hi) in enumerate(intervals):
            require(lo <= lo <= hi and lo <= hi <= hi, "closed interval endpoints")

        cells = defaultdict(list)
        for u in us:
            for leaves in itertools.product(*alphabets):
                key = report(u, leaves, select(u), intervals)
                cells[key].append((u, leaves))
        total = sum(map(len, cells.values()))
        require(total == len(us) * math.prod(map(len, alphabets)), "partition")
        for key, inputs in cells.items():
            if key[0] == "B":
                require(len(inputs) == len(us), "B cell omits center")
                require({u for u, _ in inputs} == set(us), "B cylinder completeness")
            elif key[0] == "Pc":
                i = key[2]
                require(len(inputs) == len(alphabets[i]), "Pc cell omits leaf")
                require({z[i] for _, z in inputs} == set(alphabets[i]),
                        "Pc cylinder completeness")
        score_cells = defaultdict(list)
        for key, inputs in cells.items():
            score = sum((u + sum(z) for u, z in inputs), Q(0)) / len(inputs)
            score_cells[score].append(key)
        require(sum(len(keys) for keys in score_cells.values()) == len(cells),
                "score collision merging is a disjoint union")
        results.append({
            "m": m,
            "interval_half_width": encoded(width),
            "inputs": total,
            "attained_cells": len(cells),
            "score_labels": len(score_cells),
            "all_attained_ordinary_cells_are_complete_cylinders": True,
            "endpoints_ties_and_fallback_checked": True,
        })
    return results


def independent_marginal_example():
    laws = [
        [(Q(-1), Q(1, 2)), (Q(1), Q(1, 2))],
        [(Q(-1), Q(1, 2)), (Q(1), Q(1, 2))],
        [(Q(-2), Q(1, 8)), (Q(0), Q(3, 4)), (Q(2), Q(1, 8))],
        [(Q(-1, 2), Q(4, 5)), (Q(2), Q(1, 5))],
    ]
    for law in laws:
        require(sum(p for _, p in law) == 1, "marginal probability")
        require(sum(x * p for x, p in law) == 0, "marginal centering")
        require(sum(x*x * p for x, p in law) == 1, "marginal variance")
    intervals = [(Q(-1), Q(-1)), (Q(0), Q(2)), (Q(-1, 2), Q(-1, 2))]
    rows = []
    mass = defaultdict(Q)
    first = defaultdict(Q)
    for entries in itertools.product(*laws):
        values = tuple(x for x, _ in entries)
        probability = math.prod(p for _, p in entries)
        u, leaves = values[0], values[1:]
        selected = 0 if u < 0 else 2
        key = report(u, leaves, selected, intervals)
        total = sum(values)
        rows.append((u, leaves, selected, key, probability, total))
        mass[key] += probability
        first[key] += probability * total
    require(sum(mass.values()) == 1, "joint probability")
    require(sum(p * total**2 for _, _, _, _, p, total in rows) == 4,
            "sum variance")
    retained = sum(first[key]**2 / p for key, p in mass.items())
    results = []
    require(mass[("A",)] > 0, "nonempty exceptional report")
    for b in (Q(-31, 14), first[("A",)] / mass[("A",)]):
        mse = Q(0)
        delta = Q(0)
        for u, leaves, selected, key, p, total in rows:
            if key[0] == "A":
                predicted = b
                delta += p * (1 - (total - b)**2)
            elif key[0] == "B":
                predicted = sum(leaves)
            else:
                predicted = u + sum(z for j, z in enumerate(leaves) if j != selected)
            mse += p * (total - predicted)**2
        require(mse == 1 - delta, "exact predictor-error identity")
        require(retained >= 3 + delta, "conditional projection lower bound")
        results.append({"b": encoded(b), "Delta_b": encoded(delta),
                        "predictor_mse": encoded(mse)})
    return {"states": len(rows), "p_A": encoded(mass[("A",)]),
            "retained_variance": encoded(retained), "predictors": results}


def fourth_moment_and_readout():
    law = {Q(-1, 2): Q(4, 5), Q(2): Q(1, 5)}
    fourth = sum(p * x**4 for x, p in law.items())
    convolution = {Q(0): Q(1)}
    for copies in range(1, 9):
        next_law = defaultdict(Q)
        for x, p in convolution.items():
            for y, q in law.items():
                next_law[x + y] += p * q
        convolution = dict(next_law)
        actual = sum(p * x**4 for x, p in convolution.items()) / copies**2
        require(actual == fourth / copies + Q(3 * (copies - 1), copies),
                "normalized fourth-moment identity")
    for n in range(1, 9):
        singleton_sum = Q(0)
        absolute_sum = Q(0)
        for bits in itertools.product((-1, 1), repeat=n):
            total = sum(bits)
            sign = 1 if total >= 0 else -1
            singleton_sum += Q(sign * total, 2**n)
            absolute_sum += Q(abs(total), 2**n)
        require(singleton_sum == absolute_sum > 0, "signed readout, including ties")
    return {"fourth_moment_copy_counts": [1, 8],
            "signed_readout_bit_counts": [1, 8], "sign_at_zero": 1}


def gaussian_moment_replay():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    envelope = json.loads((HERE / "jacobian_output.json").read_text())
    require(envelope["request"]["payload"] == payload, "Jacobian source binding")
    operation = "probability.gaussian_polynomial.moment.compute"
    require(envelope["request"]["operation_id"] == operation, "operation binding")
    require(envelope["result"]["operation_id"] == operation, "result operation")
    require(envelope.get("error") is None, "Jacobian adapter error")
    output = envelope["result"]["output"]
    require(output["completeness"] == "COMPLETE_BOUNDED_EXPANSION",
            "incomplete Jacobian output is not evidence")
    require(output["exactness"] == "EXACT_COMPLEX_RATIONAL" and
            output["determinism"] == "DETERMINISTIC" and
            output["gaussian_model"] == "INDEPENDENT_STANDARD_REAL",
            "Jacobian typed outcome")
    require(payload["order"] == output["order"] == 2, "bounded moment order")
    expanded = defaultdict(Q)
    terms = payload["polynomial"]["terms"]
    for a, b in itertools.product(terms, repeat=2):
        require(rational(a["coefficient"]["imaginary"]) == 0 and
                rational(b["coefficient"]["imaginary"]) == 0, "real coefficients")
        powers = tuple(x + y for x, y in zip(a["exponents"], b["exponents"]))
        expanded[powers] += (rational(a["coefficient"]["real"]) *
                             rational(b["coefficient"]["real"]))
    expected_moment = Q(0)
    require(output["expanded_monomial_count"] == len(expanded), "expansion count")
    require(output["expansion_path_count"] == len(terms)**2, "path count")
    require(len(output["contractions"]) == len(expanded), "complete contractions")
    for contraction in output["contractions"]:
        powers = tuple(contraction["exponents"])
        coefficient = expanded.pop(powers)
        factors = [0 if n % 2 else math.prod(range(1, n, 2)) for n in powers]
        contribution = coefficient * math.prod(factors)
        require(rational(contraction["expanded_coefficient"]["real"]) == coefficient,
                "contraction coefficient")
        require(list(map(int, contraction["variable_moment_factors"])) == factors,
                "Gaussian monomial factors")
        require(int(contraction["gaussian_moment_factor"]) == math.prod(factors),
                "Gaussian contraction factor")
        require(rational(contraction["contribution"]["real"]) == contribution and
                rational(contraction["contribution"]["imaginary"]) == 0 and
                rational(contraction["expanded_coefficient"]["imaginary"]) == 0,
                "contraction contribution")
        expected_moment += contribution
    require(not expanded, "no missing monomials")
    require(expected_moment == rational(output["moment"]["real"]) == Q(349, 144),
            "independent exact moment replay")
    require(rational(output["moment"]["imaginary"]) == 0, "real moment")
    s = Q(1, 4) + Q(1, 9) + Q(1, 16)
    require(1 - expected_moment == -(1 + s), "B contribution has negative sign")
    return {
        "operation_id": operation,
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "transport": envelope["transport"],
        "adapter_status": "success",
        "timeout": False,
        "moment": encoded(expected_moment),
        "B_deficit": encoded(1 - expected_moment),
        "scope": "One affine Gaussian second moment, not a truncated-Gaussian integral.",
    }


def certificate():
    return {
        "result": "exact quantitative verification of the direct reporting proof",
        "false_manuscript_assertion_identified": False,
        "analytic_budget": analytic_budget(),
        "finite_truth_tables": cancellation_truth_tables(),
        "endpoint_cell_examples": endpoint_cells(),
        "nonidentical_marginal_example": independent_marginal_example(),
        "finite_moment_and_readout_examples": fourth_moment_and_readout(),
        "jacobian": gaussian_moment_replay(),
        "scope": {
            "arithmetic": "Exact integers and rational numbers only.",
            "finite_examples": "Diagnostics, not substitutes for universal statements.",
            "universal_combinatorics": "Main.lean and report.md.",
            "analysis_and_all_C_bridge": "Proof in report.md; independent review required.",
            "full_theorem_formalized_in_Lean": False,
            "novelty": "Explicit quantitative refinement; priority not independently established.",
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(path.read_text()) == result, "stored certificate differs")
    print(json.dumps({"verified": True, "certificate": str(path),
                      "arithmetic": "exact", "quadrature": False}))


if __name__ == "__main__":
    main()
