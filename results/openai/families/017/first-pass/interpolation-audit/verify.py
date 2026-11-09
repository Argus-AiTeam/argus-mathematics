#!/usr/bin/env python3
"""Replay exact algebraic evidence; see REPORT.md for the geometric proof."""

import hashlib
import json
from collections import Counter
from fractions import Fraction as Q
from itertools import combinations, product
from math import ceil, comb, factorial
from pathlib import Path


BASE = Path(__file__).resolve().parent
ROOT = BASE.parent.parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def multiply(values):
    result = Q(1)
    for value in values:
        result *= value
    return result


def subsets(indices):
    for size in range(1, len(indices) + 1):
        yield from combinations(indices, size)


def flat_counts(centers, m):
    result = {}
    for free in subsets(tuple(range(1, m + 1))):
        fixed = [i for i in range(m + 1) if i not in free]
        groups = Counter(tuple(point[i] for i in fixed) for point in centers)
        result[",".join(map(str, free))] = max(groups.values())
    return result


def original_hypotheses(centers, theta, w0, v0):
    m = len(centers[0]) - 1
    k = len(centers)
    return (
        all(point[0] == 1 for point in centers)
        and all(len({point[i] for point in centers}) == k for i in range(1, m + 1))
        and k * theta**m < 1
        and k * (w0 / v0) * theta**m < 1
    )


def check_configuration(case, parameters):
    m = parameters["m"]
    w = list(map(Q, parameters["w"]))
    theta, sigma, v0 = Q(case["theta"]), Q(parameters["sigma"]), Q(parameters["v0"])
    centers = [tuple(map(Q, point)) for point in case["centers"]]
    require(len(w) == m + 1 and all(weight > 0 for weight in w), "Invalid degree weights")
    require(0 < theta < 1 and sigma > 0 and v0 > 0, "Invalid order weights")
    require(all(len(point) == m + 1 and point[0] != 0 for point in centers), "Invalid center")
    require(len(set(centers)) == len(centers) > 0, "Centers are not distinct")
    v = [v0] + [weight / theta for weight in w[1:]]
    l0 = m + 2
    cstar = max(Q(2 * factorial(k)) * (l0 / sigma) ** k for k in range(1, m + 1))
    require(l0 == parameters["L0"] and cstar == Q(parameters["C_star"]), "Wrong multiplicity constant")
    ratio = len(centers) * (w[0] / v0) * theta**m
    require(ratio == Q(case["total_volume_ratio"]), "Wrong ambient volume ratio")
    require(len(centers) * theta**m == Q(case["fiber_volume_ratio"]), "Wrong single-fiber comparison")
    require((1 + 3 * sigma) ** (m + 1) * ratio < 1, "Ambient coefficient count has no slack")
    counts = flat_counts(centers, m)
    require(counts == case["flat_counts"], "Incorrect coordinate-flat occupancy")
    for key, count in counts.items():
        dimension = len(key.split(","))
        require((1 + 3 * sigma) ** dimension * count * theta**dimension < 1,
                f"Flat {key} has insufficient density slack")
    ratios = []
    for size in range(1, m + 1):
        bases = list(combinations(range(m + 1), size))
        for a, b in product(bases, repeat=2):
            positive_difference = (set(a) ^ set(b)) - {0}
            if positive_difference and max(positive_difference) in a:
                separation = multiply(w[i] for i in a) / multiply(v[i] for i in b)
                require(separation > cstar, f"Failed complete separation: A={a}, B={b}")
                ratios.append(separation)
    require(len(ratios) == case["separation_pairs"], "Some separation pairs were not checked")
    require(min(ratios) == Q(case["minimum_separation_ratio"]), "Wrong minimum separation ratio")
    admissible = original_hypotheses(centers, theta, w[0], v0)
    require(admissible == case["original_hypotheses"], "Misclassified manuscript hypotheses")
    if admissible:
        require((1 + 3 * sigma) ** m * len(centers) * theta**m < 1, "Original fiber count failed")
        require((1 + sigma) * theta < 1, "Original final pole comparison failed")
    return centers, w, v, sigma


def trim(p):
    p = list(p)
    while len(p) > 1 and p[-1] == 0:
        p.pop()
    return p


def padd(p, q):
    return trim([(p[i] if i < len(p) else Q(0)) + (q[i] if i < len(q) else Q(0))
                 for i in range(max(len(p), len(q)))])


def pscale(p, scalar):
    return trim([scalar * coefficient for coefficient in p])


def pmul(p, q):
    result = [Q(0)] * (len(p) + len(q) - 1)
    for i, a in enumerate(p):
        for j, b in enumerate(q):
            result[i + j] += a * b
    return trim(result)


def pdivrem(p, q):
    require(q != [0], "Polynomial division by zero")
    remainder = trim(p)
    quotient = [Q(0)] * max(1, len(p) - len(q) + 1)
    while remainder != [0] and len(remainder) >= len(q):
        offset = len(remainder) - len(q)
        coefficient = remainder[-1] / q[-1]
        quotient[offset] += coefficient
        remainder = padd(remainder, [Q(0)] * offset + pscale(q, -coefficient))
    return trim(quotient), remainder


def pgcd(p, q):
    while q != [0]:
        p, q = q, pdivrem(p, q)[1]
    return pscale(p, 1 / p[-1]) if p != [0] else p


def shift(p, a):
    return trim([sum((p[k] * comb(k, r) * a ** (k - r) for k in range(r, len(p))), Q(0))
                 for r in range(len(p))])


def order(p):
    return next((i for i, coefficient in enumerate(p) if coefficient), None)


def branch_orders(coordinates, center, a):
    limit = 8
    shifted = [shift(p, a) for p in coordinates]
    t = pscale(padd(shifted[0], [-center[0]]), 1 / center[0])
    log_series, power = [Q(0)], [Q(1)]
    for n in range(1, limit + 1):
        power = trim(pmul(power, t)[:limit + 1])
        log_series = padd(log_series, pscale(power, Q((-1) ** (n + 1), n)))
    result = [order(t)]
    for p, constant in zip(shifted[1:], center[1:]):
        difference = trim(padd(padd(p, [-constant]), pscale(log_series, -1))[:limit + 1])
        value = order(difference)
        require(value is not None or (t == [0] and padd(p, [-constant]) == [0]),
                "Truncated zero series does not certify an infinite branch order")
        result.append(value)
    return result


def check_curve(curve, configuration):
    centers, w, v, sigma = configuration
    coordinates = [trim(list(map(Q, coefficients))) for coefficients in curve["coordinates_low_to_high"]]
    require(len(coordinates) == len(w), "Wrong ambient curve dimension")
    s = [Q(0), Q(1)]
    if curve["normalization_inverse"] == "X2/X1":
        require(coordinates[1] != [0], "Invalid rational inverse denominator")
        require(coordinates[2] == pmul(s, coordinates[1]), "Normalization inverse identity failed")
        implicit = padd(pmul(coordinates[2], coordinates[2]),
                        pscale(pmul(pmul(coordinates[1], coordinates[1]), padd(coordinates[1], [Q(1)])), -1))
        require(implicit == [0], "Nodal curve equation failed")
    elif curve["normalization_inverse"] == "Y-1":
        require(padd(coordinates[0], [Q(-1)]) == s, "Normalization inverse identity failed")
    else:
        raise ValueError("Unsupported normalization certificate")
    total_contact = Q(0)
    for j, center in enumerate(centers):
        common = [Q(0)]
        for p, value in zip(coordinates, center):
            common = pgcd(common, padd(p, [-value]))
        branches = [branch for branch in curve["branches"] if branch["center"] == j]
        root_product = [Q(1)]
        require(len({branch["parameter"] for branch in branches}) == len(branches), "Repeated branch")
        for branch in branches:
            a = Q(branch["parameter"])
            root_product = pmul(root_product, [-a, Q(1)])
            orders = branch_orders(coordinates, center, a)
            require(orders == branch["orders"], "Incorrect branch contact orders")
            require(all(value is None or value > 0 for value in orders), "Branch misses its center")
            contact = min(Q(value) / cost for value, cost in zip(orders, v) if value is not None)
            total_contact += contact
        require(common == root_product, f"Unaccounted complex branch or wrong center preimage at {j}")
    poles = [-(len(p) - 1) if len(p) > 1 else 0 for p in coordinates]
    require(curve["only_pole"] == "infinity" and poles == curve["pole_orders"], "Wrong global pole data")
    degree = max([Q(0)] + [-Q(pole) / weight for pole, weight in zip(poles, w)])
    require(degree == Q(curve["weighted_degree"]), "Wrong weighted curve degree")
    require(total_contact == Q(curve["total_contact"]), "Wrong total branch contact")
    require(degree >= (1 + sigma) * total_contact, "Curve violates the claimed inequality")
    return {"name": curve["name"], "branches": len(curve["branches"]),
            "degree": str(degree), "contact": str(total_contact)}


def sadd(p, q):
    result = dict(p)
    for exponent, coefficient in q.items():
        result[exponent] = result.get(exponent, Q(0)) + coefficient
    return {exponent: coefficient for exponent, coefficient in result.items() if coefficient}


def smul(p, q):
    result = {}
    for a, coefficient_a in p.items():
        for b, coefficient_b in q.items():
            exponent = tuple(x + y for x, y in zip(a, b))
            result[exponent] = result.get(exponent, Q(0)) + coefficient_a * coefficient_b
    return {exponent: coefficient for exponent, coefficient in result.items() if coefficient}


def sparse(poly):
    return {tuple(term["exponents"]): Q(int(term["coefficient"]["num"]), int(term["coefficient"]["den"]))
            for term in poly["terms"]}


def check_jacobian(spec):
    request = json.loads((BASE / spec["request"]).read_text())
    response = json.loads((BASE / spec["response"]).read_text())
    require(spec["adapter_exit_code"] == 0 and spec["error"] is None and spec["timeout"] is False,
            "An adapter error or timeout is not mathematical evidence")
    require("error" not in response, "Structured adapter error")
    require(response["server"]["version"] == spec["server_version"], "Wrong Jacobian version")
    require(response["protocol_version"] == spec["protocol_version"], "Wrong Jacobian protocol")
    require(response["request"]["operation_id"] == spec["operation_id"], "Wrong operation")
    require(response["request"]["payload"] == request, "Payload is not source-bound")
    require(response["result"]["operation_id"] == spec["operation_id"], "Wrong returned operation")
    require(response["result"]["output"] == spec["expected_output"], "Unexpected typed rank output")
    matrix = request["matrix"]
    require(matrix["variables"] == ["y", "b", "c"], "Wrong rational function field")
    entries = []
    for row in matrix["entries"]:
        values = []
        for entry in row:
            require(entry["domain"] == "QQ" and entry["variables"] == matrix["variables"], "Wrong entry field")
            require(sparse(entry["denominator"]) == {(0, 0, 0): Q(1)}, "Nonpolynomial rank replay")
            values.append(sparse(entry["numerator"]))
        entries.append(values)
    require(len(entries) == 3 and all(len(row) == 3 for row in entries), "Wrong frame matrix")
    c, b_minus_c = {(0, 0, 1): Q(1)}, {(0, 1, 0): Q(1), (0, 0, 1): Q(-1)}
    for row in entries:
        require(sadd(smul(c, row[0]), smul(b_minus_c, row[1])) == row[2],
                "Universal polynomial column relation failed")
    minor = sadd(smul(entries[1][0], entries[2][1]),
                 smul({(0, 0, 0): Q(-1)}, smul(entries[1][1], entries[2][0])))
    require(minor == {(0, 0, 0): Q(-1)}, "No constant nonzero lower-rank witness")


def check_lean(spec):
    source, fidelity = BASE / spec["source"], BASE / spec["statement_fidelity"]
    result = json.loads((BASE / spec["result"]).read_text())
    require(result["status"] == "success" and result["exit_code"] == spec["expected_exit_code"] == 0,
            "Lean did not compile successfully")
    require(result["proof_holes"] == spec["expected_proof_holes"] == [], "Lean proof has holes")
    require(result["audit_exit_code"] == 0 and "sorryAx" not in result["stdout"], "Axiom audit failed")
    require(f"version {spec['version']}" in result["tools"]["lean"]["version"], "Wrong Lean version")
    require(hashlib.sha256(source.read_bytes()).hexdigest() == result["source_sha256"], "Stale Lean source")
    fidelity_digest = hashlib.sha256(fidelity.read_text().encode()).hexdigest()
    require(fidelity_digest == result["statement_fidelity_sha256"], "Stale statement fidelity")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claims = [claim for claim in state["claims"] if claim["claim_id"] == spec["claim"]]
    require(bool(claims), "Formal claim is absent")
    claim = max(claims, key=lambda item: item["version"])
    supporting = [evidence for evidence in state["evidence"]
                  if evidence["subject"]["subject_id"] == spec["claim"]
                  and evidence["subject"]["content_hash"] == claim["content_hash"]
                  and evidence["tier"] == "mechanical" and evidence["verdict"] == "supports"]
    require(bool(supporting), "No mechanical evidence for the current claim version")
    matched = False
    for evidence in supporting:
        archive = json.loads((ROOT / evidence["artifact"]).read_text())
        checked = archive["lean_check"]
        if (checked["source_sha256"] == result["source_sha256"]
                and checked["statement_fidelity_sha256"] == fidelity_digest
                and checked["exit_code"] == 0 and checked["proof_holes"] == []):
            matched = True
    require(matched, "Compiler result is not attached to the current formal claim")


def check_excluded_obstruction(spec, parameters):
    centers = [tuple(map(Q, point)) for point in spec["centers"]]
    theta, w0, v0 = Q(spec["theta"]), Q(parameters["w"][0]), Q(parameters["v0"])
    require(not original_hypotheses(centers, theta, w0, v0), "False refutation: example is admissible")
    require(centers == [(Q(1), Q(0), Q(0)), (Q(1), Q(1), Q(0))], "Wrong excluded flat")
    require(spec["free_coordinates"] == [1], "Wrong free coordinate")
    require(len(centers) * theta == Q(spec["density"]) > 1, "No overcrowding")
    source, target = spec["source_dimension_coefficients"], spec["target_dimension_coefficients"]
    require(source == [1, 5] and target == [0, 6] and spec["H"] == "5*l*w1", "Wrong exact dimensions")
    defect = [b - a for a, b in zip(source, target)]
    require(defect == spec["defect_coefficients"] == [-1, 1], "Wrong polynomial dimension defect")
    lower = spec["valid_for_all_integer_l_at_least"]
    require(lower == 2 and defect[1] > 0 and defect[0] + defect[1] * lower > 0,
            "Defect is not positive on the whole asserted integer ray")
    require(spec["not_a_manuscript_counterexample"] is True, "Excluded hypotheses are concealed")


def check_local_counts(spec):
    cases = 0
    for vector in spec["cost_vectors"]:
        costs = list(map(Q, vector))
        require(all(cost > 0 for cost in costs), "Nonpositive local cost")
        for threshold in map(Q, spec["thresholds"]):
            require(threshold > 0, "Nonpositive threshold")
            count = sum(sum((cost * index for cost, index in zip(costs, alpha)), Q(0)) < threshold
                        for alpha in product(*(range(ceil(threshold / cost)) for cost in costs)))
            volume = threshold ** len(costs) / (factorial(len(costs)) * multiply(costs))
            require(count >= volume, "Strict-cutoff lattice lower bound failed")
            cases += 1
    require(cases == spec["expected_cases"], "Some local regression cases were omitted")
    return cases


def main():
    certificate = json.loads((BASE / "exact_certificate.json").read_text())
    require(certificate["manuscript_refutations"] == [], "No manuscript refutation is certified by this script")
    require(certificate["novelty_status"] == "unverified", "Novelty was not established by this replay")
    configurations = {case["name"]: check_configuration(case, certificate["parameters"])
                      for case in certificate["configurations"]}
    curves = [check_curve(curve, configurations[curve["configuration"]]) for curve in certificate["curves"]]
    check_excluded_obstruction(certificate["excluded_collision_obstruction"], certificate["parameters"])
    finite_cases = check_local_counts(certificate["local_count_regressions"])
    check_jacobian(certificate["jacobian"])
    check_lean(certificate["lean"])
    print(json.dumps({
        "status": "verified",
        "scope": "exact examples, symbolic frame identity, and current universal Lean core; geometric proof in REPORT.md",
        "configurations": len(configurations),
        "curves": curves,
        "local_finite_regressions": finite_cases,
        "lean_claim": certificate["lean"]["claim"],
        "independent_review": "pending",
        "novelty": certificate["novelty_status"]
    }, indent=2))


if __name__ == "__main__":
    main()
