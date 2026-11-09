#!/usr/bin/env python3
"""Replay exact algebra and finite regressions; validate the real Lean certificate."""

import argparse
import hashlib
import itertools
import json
import math
import re
from fractions import Fraction as Q
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
CLAIM = "C231_COVARIANCE_LOCALITY"
OPERATION = "matrix.symbolic.characteristic_polynomial.compute"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def load(path):
    return json.loads(path.read_text())


def symbolic_checks():
    identities = []

    def zero(name, expression):
        require(sp.simplify(sp.cancel(expression)) == 0, name)
        identities.append(name)

    a, b, c, d, u, v = sp.symbols("a b c d u v", positive=True)
    z = a + b * u + c * v + d * u * v
    pi, pj, pij = (b * u + d * u * v) / z, (c * v + d * u * v) / z, d * u * v / z
    zero("finite_partition_diagonal_derivative", u * sp.diff(pi, u) - pi * (1 - pi))
    zero("finite_partition_cross_derivative", v * sp.diff(pi, v) - (pij - pi * pj))
    zero("two_coordinate_covariance_numerator", pij - pi * pj - u * v * (a * d - b * c) / z**2)
    p = sp.Symbol("p", real=True)
    zero("bernoulli_half_response_square", Q(1, 2) - 2 * p * (1 - p) - 2 * (p - Q(1, 2))**2)

    r, x, y, q, diagonal, dummy = sp.symbols("r x y q diagonal dummy", real=True)
    pp, pm, mp, mm = r + x + y + q, r - x + y - q, r + x - y - q, r - x - y + q
    zero("four_envelopes_sum", pp + pm + mp + mm - 4 * r)
    zero("four_envelopes_upper_bound", pp + mm - 2 * r - 2 * q)
    zero("four_envelopes_lower_bound", pm + mp - 2 * r + 2 * q)
    off = -diagonal - dummy
    zero("homogenized_absolute_row", (diagonal - off) - (2 * diagonal + dummy))

    k = sp.Symbol("k", integer=True, nonnegative=True)
    t, ell = sp.symbols("t ell", positive=True)
    zero("picard_factorial_primitive",
         sp.diff(ell**(k + 1) * t**(k + 2) / sp.factorial(k + 2), t)
         - ell * ell**k * t**(k + 1) / sp.factorial(k + 1))
    zero("conditional_third_moment_majorant", 4 * (a**3 + b**3) - (a + b)**3 - 3 * (a + b) * (a - b)**2)
    h = sp.Symbol("h", positive=True)
    zero("midpoint_increment_variance", h / 4 + h / 4 - h / 2)
    zero("midpoint_cross_covariance", h / 4 - h / 4)

    weights = (a, b, c, d)
    incidence = sp.Matrix([[1, -1, 0, 0], [0, 1, -1, -1], [0, 0, 0, 1]])
    laplacian = incidence * sp.diag(*weights) * incidence.T
    partition = d * (a * b + a * c + b * c)
    zero("triangle_bridge_matrix_tree", laplacian.det() - partition)
    inverse = laplacian.inv()
    means = [sp.cancel(w * sp.diff(partition, w) / partition) for w in weights]
    for i, wi in enumerate(weights):
        transfer = wi * (incidence[:, i].T * inverse * incidence[:, i])[0]
        zero(f"triangle_bridge_inclusion_{i}", means[i] - transfer)
        row = []
        for j, wj in enumerate(weights):
            gradient = wj * sp.diff(means[i], wj)
            predicted = means[i] * (1 - means[i]) if i == j else (
                -wi * wj * (incidence[:, i].T * inverse * incidence[:, j])[0]**2)
            zero(f"triangle_bridge_covariance_{i}_{j}", gradient - predicted)
            row.append(gradient if i == j else -gradient)
        zero(f"triangle_bridge_absolute_row_{i}", sum(row) - 2 * means[i] * (1 - means[i]))
    return identities


def cube(n):
    return itertools.product((0, 1), repeat=n)


def normalize(masses):
    require(all(p >= 0 for p in masses.values()), "negative mass")
    total = sum(masses.values(), Q(0))
    require(total > 0, "zero total mass")
    return {x: p / total for x, p in masses.items() if p}


def covariance(law):
    n = len(next(iter(law)))
    means = [sum((p * x[i] for x, p in law.items()), Q(0)) for i in range(n)]
    return [[sum((p * x[i] * x[j] for x, p in law.items()), Q(0)) - means[i] * means[j]
             for j in range(n)] for i in range(n)]


def tilt(law, fields, observed=None):
    sites = range(len(fields)) if observed is None else observed
    return normalize({x: p * math.prod((fields[j]**x[j] for j in sites), start=Q(1))
                      for x, p in law.items()})


def graph_ball(cov, i, level=None):
    n = len(cov)
    seen = {i}
    frontier = {i}
    radius = n if level is None else level
    threshold = None if level is None else Q(1, 2**level)
    for _ in range(radius):
        frontier = {j for k in frontier for j in range(n)
                    if j != k and cov[k][j] < 0
                    and (threshold is None or -cov[k][j] >= threshold)} - seen
        seen |= frontier
    return seen


def components(cov):
    remaining = set(range(len(cov)))
    result = []
    while remaining:
        block = graph_ball(cov, min(remaining))
        remaining -= block
        result.append(sorted(block))
    return result


def independent_components(law, blocks):
    marginals = []
    for block in blocks:
        marginal = {}
        for x, p in law.items():
            y = tuple(x[i] for i in block)
            marginal[y] = marginal.get(y, Q(0)) + p
        marginals.append(marginal)
    n = len(next(iter(law)))
    for x in cube(n):
        product = math.prod((m.get(tuple(x[i] for i in block), Q(0))
                             for block, m in zip(blocks, marginals)), start=Q(1))
        require(law.get(x, Q(0)) == product, "covariance component factorization")


def examples():
    def product_law(probabilities):
        return normalize({x: math.prod((p if bit else 1 - p
                                       for bit, p in zip(x, probabilities)), start=Q(1))
                          for x in cube(len(probabilities))})

    def one_hot(weights):
        return normalize({tuple(int(i == j) for i in range(len(weights))): Q(w)
                          for j, w in enumerate(weights)})

    pair = one_hot((1, 2))
    block_product = {x + y + (z, 0): px * py * pz
                     for x, px in pair.items() for y, py in pair.items()
                     for z, pz in ((0, Q(3, 5)), (1, Q(2, 5)))}
    kernel = sp.Matrix([[Q(1, 2), Q(1, 8), 0],
                        [Q(1, 8), Q(1, 2), Q(1, 8)],
                        [0, Q(1, 8), Q(1, 2)]])

    def inclusion(sites):
        determinant = kernel.extract(sites, sites).det() if sites else 1
        return Q(determinant)

    dpp = {}
    for x in cube(3):
        occupied = [i for i in range(3) if x[i]]
        absent = [i for i in range(3) if not x[i]]
        dpp[x] = sum(((-1)**len(extra) * inclusion(occupied + list(extra))
                      for size in range(len(absent) + 1)
                      for extra in itertools.combinations(absent, size)), Q(0))
    tree = {x + (1,): math.prod((Q(w)**bit for w, bit in zip((2, 3, 5), x)), start=Q(7))
            for x in cube(3) if sum(x) == 2}
    return {
        "empty_index_set": {(): Q(1)},
        "deterministic": {(0, 1, 0): Q(1)},
        "independent_product": product_law((Q(1, 3), Q(1, 2), Q(2, 5), Q(0), Q(1))),
        "perfect_negative_pair": one_hot((1, 1)),
        "weighted_one_hot": one_hot((1, 1, 2, 2)),
        "independent_covariance_components": normalize(block_product),
        "connected_covariance_path": normalize(dpp),
        "weighted_triangle_with_bridge": normalize(tree),
    }


def permute(x, permutation):
    result = [0] * len(x)
    for i, j in enumerate(permutation):
        result[j] = x[i]
    return tuple(result)


def finite_checks():
    results = []
    grid = (Q(1, 7), Q(1), Q(5))
    for name, law in examples().items():
        n = len(next(iter(law)))
        cov = covariance(law)
        blocks = components(cov)
        independent_components(law, blocks)
        for i in range(n):
            previous = set()
            for level in range(1, 11):
                ball = graph_ball(cov, i, level)
                require(previous <= ball <= graph_ball(cov, i), "intrinsic nesting/component containment")
                degree = sum(j != i and -cov[i][j] >= Q(1, 2**level) for j in range(n))
                require(degree * Q(1, 2**level) <= cov[i][i], "threshold degree bound")
                previous = ball
            require(previous == graph_ball(cov, i), "finite example component exhaustion")
        field_vectors = list(itertools.product(grid, repeat=n)) if n <= 4 else [
            tuple(Q(1) for _ in range(n)),
            tuple(Q(i + 1, 7) for i in range(n)),
            tuple(Q(7, i + 1) for i in range(n)),
            tuple(Q(1, 100) if i % 2 else Q(100) for i in range(n)),
        ]
        for fields in field_vectors:
            tcov = covariance(tilt(law, fields))
            for i, row in enumerate(tcov):
                require(all(value <= 0 for j, value in enumerate(row) if i != j), "off-diagonal sign")
                require(sum(abs(value) for value in row) <= 2 * row[i] <= Q(1, 2), "absolute response row")
                if name in {"perfect_negative_pair", "weighted_one_hot", "weighted_triangle_with_bridge"}:
                    require(sum(abs(value) for value in row) == 2 * row[i], "fixed-count row identity")
        symmetry_count = 0
        fields = tuple(Q(i + 2, i + 3) for i in range(n))
        for permutation in itertools.permutations(range(n)):
            if not all(law.get(permute(x, permutation), Q(0)) == law.get(x, Q(0)) for x in cube(n)):
                continue
            symmetry_count += 1
            transported = permute(fields, permutation)
            for i in range(n):
                for level in range(1, 11):
                    observed = graph_ball(cov, i, level)
                    target = graph_ball(cov, permutation[i], level)
                    require({permutation[j] for j in observed} == target, "intrinsic permutation identity")
                    source_mean = sum((p * x[i] for x, p in tilt(law, fields, observed).items()), Q(0))
                    target_mean = sum((p * x[permutation[i]]
                                       for x, p in tilt(law, transported, target).items()), Q(0))
                    require(source_mean == target_mean, "finite posterior permutation identity")
        if name == "connected_covariance_path":
            require(cov[0][2] == 0 and cov[0][1] < 0 and cov[1][2] < 0, "path versus direct-neighbor distinction")
        if name == "independent_product":
            require(all(graph_ball(cov, i, 10) == {i} for i in range(n)), "balls need not exhaust I")
        results.append({"name": name, "coordinates": n, "positive_atoms": len(law),
                        "components": blocks, "positive_rational_field_cases": len(field_vectors),
                        "law_preserving_permutations_checked": symmetry_count})

    parity = {x: Q(1, 4) for x in cube(3) if sum(x) % 2 == 0}
    pcov = covariance(parity)
    require(all(pcov[i][j] == 0 for i in range(3) for j in range(3) if i != j), "parity pair independence")
    fmean = sum((p * x[0] for x, p in parity.items()), Q(0))
    gmean = sum((p * max(x[1:]) for x, p in parity.items()), Q(0))
    cross = sum((p * x[0] * max(x[1:]) for x, p in parity.items()), Q(0)) - fmean * gmean
    require(cross == Q(1, 8), "positive block covariance witnesses failure of negative association")
    return {"classification": "bounded finite regression experiments, not a proof of the countable theorem",
            "models": results,
            "auxiliary_counterexample": {
                "claim_refuted": "pairwise independence alone implies block independence",
                "is_manuscript_refutation": False,
                "law": "uniform on 000, 011, 101, 110",
                "positive_covariance_X0_max_X1_X2": str(cross)}}


def jacobian_check():
    status = load(HERE / "jacobian_status.json")
    response = load(HERE / "jacobian_output.json")
    payload = load(HERE / "jacobian_payload.json")
    require(status["adapter_exit_code"] == 0 and status["adapter_timeout"] is False, "Jacobian run failed")
    require(response["request"] == {"operation_id": OPERATION, "payload": payload}, "Jacobian request binding")
    require(response["result"]["operation_id"] == OPERATION, "Jacobian operation binding")
    output = response["result"]["output"]
    require(output["degree"] == 2 and output["convention"] == "DET_LAMBDA_I_MINUS_A", "Jacobian output contract")
    variables = sp.symbols("a b c")

    def rational_function(value):
        require(value["domain"] == "QQ" and value["variables"] == ["a", "b", "c"], "symbolic field")

        def polynomial(part):
            return sum(sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
                       * math.prod(var**exponent for var, exponent in zip(variables, term["exponents"]))
                       for term in part["terms"])
        return polynomial(value["numerator"]) / polynomial(value["denominator"])

    coefficients = [rational_function(value) for value in output["coefficients_descending"]]
    a, b, c = variables
    require(len(coefficients) == 3, "Jacobian dense coefficients")
    require(all(sp.cancel(actual - expected) == 0
                for actual, expected in zip(coefficients, (1, -a - c, a * c - b**2))), "covariance characteristic polynomial")
    return {"operation_id": OPERATION, "protocol_version": response["protocol_version"],
            "server_version": response["server"]["version"], "adapter_exit_code": 0,
            "adapter_timeout": False, "structured_error": None,
            "result": "lambda^2 - (a+c) lambda + ac - b^2",
            "scope": "exact generic 2x2 covariance-matrix algebra, not a PSD or sampler certificate"}


def formal_check():
    state = load(ROOT / "research/MATH_STATE.json")
    claim = max((c for c in state["claims"] if c["claim_id"] == CLAIM), key=lambda c: c["version"])
    records = [e for e in state["evidence"]
               if e["subject"]["subject_id"] == CLAIM
               and e["subject"]["content_hash"] == claim["content_hash"]
               and e["tier"] == "mechanical" and e["verdict"] == "supports"]
    require(len(records) == 1, "one current supporting mechanical record is required")
    record = records[0]
    archive = load(ROOT / record["artifact"])
    check = archive["lean_check"]
    source = (HERE / "Main.lean").read_text()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    require(archive["subject"] == record["subject"] and archive["evidence_id"] == record["evidence_id"], "archive ledger binding")
    require(check == load(HERE / "lean_check.json"), "archived and current compiler results differ")
    require(check["status"] == "success" and check["exit_code"] == 0, "real compiler success required")
    require(check["audit_exit_code"] == 0 and check["proof_holes"] == [], "Lean axiom audit/proof holes")
    require(re.search(r"version 4\.31\.0(?:,|\))", check["tools"]["lean"]["version"]) is not None, "Lean 4.31.0 required")
    require(check["source_sha256"] == hashlib.sha256(source.encode()).hexdigest(), "stale Lean source")
    require(check["statement_fidelity_sha256"] == hashlib.sha256(fidelity.encode()).hexdigest(), "stale statement fidelity")
    require(archive["lean_source"]["text"] == source == claim["formal_statement"], "formal claim text binding")
    require(archive["statement_fidelity"]["text"] == fidelity, "fidelity archive binding")
    require("sorryAx" not in check["stdout"], "unexpected proof axiom")
    declarations = ["CovarianceLocality.factorization_of_zero_rank_covariance",
                    "CovarianceLocality.covariance_locality"]
    require(all(name in check["stdout"] for name in declarations), "audited theorem declarations missing")
    return {"claim": CLAIM, "claim_version": claim["version"], "artifact": record["artifact"],
            "compiler": "Lean 4.31.0", "exit_code": 0, "audit_exit_code": 0, "proof_holes": [],
            "source_sha256": check["source_sha256"],
            "statement_fidelity_sha256": check["statement_fidelity_sha256"],
            "declarations": declarations,
            "quantifiers": "all finite Boolean blocks and all nonnegative normalized joint masses with cross-block negative association",
            "conclusion": "zero rank covariance, or all zero cross-coordinate covariances, implies full joint mass factorization",
            "replay_scope": "checks binding of an actual archived compiler run; does not launch a new compilation",
            "statement_fidelity_needs_independent_review": True}


def certificate():
    identities = symbolic_checks()
    return {
        "schema_version": 1,
        "ok": True,
        "objective_claim": "C231_FULL_SYMMETRY",
        "result_class": "new_theorem_candidate",
        "novelty_status": "not_independently_verified",
        "campaign_accepted": False,
        "formal_core": formal_check(),
        "exact_symbolic_identities": identities,
        "jacobian": jacobian_check(),
        "finite_experiments": finite_checks(),
        "full_theorems": {
            "statements": ["Every countable strongly Rayleigh law admits an all-input full-permutation-equivariant IID sampler.",
                           "The same holds for countable negatively associated binary laws with uniform finite-tilt response."],
            "proof": "research/covariance_symmetry/theorem.md, Sections 1-7",
            "classification": "complete mathematical proof submitted for independent review, not a full Lean formalization",
        },
        "outside_formalization": [
            "BBL strong Rayleigh negative association and symmetric homogenization",
            "countable cylinder extension of component independence",
            "covariance summability and intrinsic threshold-ball exhaustion",
            "Gaussian endpoint/bridge Bayes identity and full-history posterior locality",
            "bounded martingale convergence and joint Brownian innovations",
            "Borel parameter integration and countable unbounded-field Picard inversion",
            "integer-time Gaussian recovery and scalar uniform-to-Wiener coding",
            "full-group every-input equivariance of the resulting Borel map",
        ],
        "review_required": ["mathematical proof", "statement fidelity", "primary-proposition attribution",
                            "exact-strength originality", "publishable significance"],
        "manuscript_refutation_established": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        require(load(target) == result, "certificate differs from replay; inspect the material change before regenerating")
    print(json.dumps({"ok": True, "symbolic_identities": len(result["exact_symbolic_identities"]),
                      "finite_models": len(result["finite_experiments"]["models"]),
                      "formal_core": {"compiler": result["formal_core"]["compiler"], "proof_holes": []},
                      "full_theorem_independent_review": "pending"}, sort_keys=True))


if __name__ == "__main__":
    main()
