#!/usr/bin/env python3
"""Replay the exact finite core; the analytic transfer proof is in report.md."""

import itertools
import json
import math
from fractions import Fraction as F
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def clean(p):
    return {e: c for e, c in p.items() if c}


def add(*polys):
    out = {}
    for p in polys:
        for e, c in p.items():
            out[e] = out.get(e, F(0)) + c
    return clean(out)


def scale(p, c):
    return clean({e: c * a for e, a in p.items()})


def mul(p, q):
    out = {}
    for e, a in p.items():
        for f, b in q.items():
            g = tuple(x + y for x, y in zip(e, f))
            out[g] = out.get(g, F(0)) + a * b
    return clean(out)


def power(p, k):
    require(k >= 0 and bool(p), "Power needs a nonzero polynomial and k>=0")
    out = {(0,) * len(next(iter(p))): F(1)}
    for _ in range(k):
        out = mul(out, p)
    return out


def monomial(exponents, c=1):
    return {tuple(exponents): F(c)}


def check_signs(cert):
    n = cert["cluster_labels"]
    require(n == 4, "The two-pair reduction needs four labels")
    coords = cert["walsh_coordinates"]
    require(coords == 2 * n, "Old/fresh sign coordinates mismatch")
    for character in range(1 << coords):
        total = sum(
            -1 if (character & signs).bit_count() % 2 else 1
            for signs in range(1 << coords)
        )
        require(total == ((1 << coords) if character == 0 else 0),
                "Walsh orthogonality failed")
    pairs = list(itertools.combinations(range(n), 2))
    cases = 0
    for large in range(1 << n):
        old = [sum(1 << c for c in pair) for pair in pairs]
        fresh = [
            sum(1 << (c + n if (large >> c) & 1 else c) for c in pair)
            for pair in pairs
        ]
        for i, pair in enumerate(pairs):
            affected = any((large >> c) & 1 for c in pair)
            for j in range(len(pairs)):
                gram = (
                    int(fresh[i] == fresh[j]) - int(fresh[i] == old[j])
                    - int(old[i] == fresh[j]) + int(old[i] == old[j])
                )
                require(gram == (2 if i == j and affected else 0),
                        "Resampling interaction kernel failed")
                cases += 1
    require(cases == cert["pair_gram_cases"] == 576, "Incomplete pair patterns")
    require(cert["resampling_subsets"] == 1 << n, "Incomplete resampling subsets")
    return cases


def check_cubic(cert):
    require(cert["parameters"] == ["c", "p", "e", "s", "M", "m", "H"],
            "Cubic parameter order changed")
    variables = [monomial([int(i == j) for i in range(7)]) for j in range(7)]
    c, p, e, s, mass, cells, cross = variables
    lhs = add(mul(mul(cells, power(mass, 2)), cross),
              scale(mul(power(c, 5), power(p, 3)), -1))
    first = mul(mass, add(mul(mul(cells, mass), cross),
                         scale(mul(power(c, 2), power(s, 2)), -1)))
    second = mul(power(c, 2),
                 add(mul(mass, power(s, 2)), scale(power(e, 3), -1)))
    cp = mul(c, p)
    third = mul(
        mul(power(c, 2), add(e, scale(cp, -1))),
        add(power(e, 2), mul(e, cp), power(cp, 2)),
    )
    require(lhs == add(first, second, third), "Universal cubic slack identity failed")


def bernstein_nonnegative(poly):
    require(all(len(e) == 1 and e[0] >= 0 for e in poly), "Not a polynomial")
    degree = max(e[0] for e in poly)
    coefficients = [
        sum(
            (a * F(math.comb(j, k), math.comb(degree, k)) / (2 ** k)
             for (k,), a in poly.items() if k <= j),
            F(0),
        )
        for j in range(degree + 1)
    ]
    require(all(b >= 0 for b in coefficients),
            "Nonnegative Bernstein certificate failed on [0,1/2]")
    return len(coefficients)


def check_sharpness(cert):
    q = monomial([1])
    one = monomial([0])
    high = (power(q, 4), monomial([-1]), power(q, 4), True)
    low_prob = add(power(q, 2), scale(power(q, 4), -1))
    low = (low_prob, power(q, 8), power(q, 8), True)
    helper = (scale(power(q, 12), 2), monomial([-3]), monomial([-3]), False)
    events = (high, low, helper)

    def moment(a_degree, z_degree, exterior_only=False):
        return add(*(
            mul(prob, mul(power(a, a_degree), power(z, z_degree)))
            for prob, a, z, exterior in events
            if not exterior_only or exterior
        ))

    prob = power(q, 2)
    cross = moment(1, 1)
    polynomials = {
        "low_event_probability": low_prob,
        "remaining_probability": add(one, scale(prob, -1), scale(power(q, 12), -2)),
        "exterior_gap": add(moment(2, 0, True), scale(prob, -1)),
        "biased_gap": add(moment(1, 2), scale(moment(1, 0), -1)),
        "fourth_A_slack": add(scale(one, 4), scale(moment(4, 0), -1)),
        "fourth_Z_slack": add(scale(one, 4), scale(moment(0, 4), -1)),
        "H_lower_gap": add(cross, scale(power(prob, 3), -2)),
        "H_upper_gap": add(scale(power(prob, 3), 3), scale(cross, -1)),
    }
    expected = cert["polynomial_nonnegativity"]
    require(set(expected) == set(polynomials), "Sharpness obligations changed")
    count = 0
    for name, poly in polynomials.items():
        recorded = {(int(k),): F(v) for k, v in expected[name].items()}
        require(poly == recorded, f"Sharpness polynomial mismatch: {name}")
        count += bernstein_nonnegative(poly)
    return count


def solve(matrix, vector):
    n = len(vector)
    rows = [[F(x) for x in matrix[i]] + [F(vector[i])] for i in range(n)]
    for col in range(n):
        pivot = next((i for i in range(col, n) if rows[i][col]), None)
        require(pivot is not None, "Grounded Laplacian is singular")
        rows[col], rows[pivot] = rows[pivot], rows[col]
        value = rows[col][col]
        rows[col] = [x / value for x in rows[col]]
        for i in range(n):
            if i != col:
                value = rows[i][col]
                rows[i] = [x - value * y for x, y in zip(rows[i], rows[col])]
    return [row[-1] for row in rows]


def check_network(cert):
    payload = json.loads((ROOT / cert["payload"]).read_text())
    output = json.loads((ROOT / cert["typed_output"]).read_text())
    require(output["server"]["version"] == cert["jacobian_server_version"],
            "Jacobian server version changed")
    require(output["protocol_version"] == cert["jacobian_protocol"],
            "Jacobian protocol changed")
    require(output["request"]["operation_id"] == cert["jacobian_operation"],
            "Jacobian operation changed")
    require(output["request"]["payload"] == payload, "Payload/output mismatch")
    require("error" not in output and cert["adapter_exit_code"] == 0,
            "Adapter error is not evidence")
    n = payload["network"]["vertex_count"]
    require(n == 5 and payload["terminal_b"] == 0 and payload["terminal_a"] == 2,
            "Finite primary normalization geometry changed")
    lap = [[F(0) for _ in range(n)] for _ in range(n)]
    for edge in payload["network"]["edges"]:
        i, j = edge["source"], edge["target"]
        c = F(int(edge["conductance"]["num"]), int(edge["conductance"]["den"]))
        require(c > 0, "Invalid conductance")
        lap[i][i] += c
        lap[j][j] += c
        lap[i][j] -= c
        lap[j][i] -= c
    grounded = [row[1:] for row in lap[1:]]
    voltage = solve(grounded, [0, 1, 0, 0])
    resistance = voltage[1]
    typed = output["result"]["output"]["effective_resistance"]
    require(resistance == F(cert["terminal_effective_resistance"]) ==
            F(int(typed["num"]), int(typed["den"])), "Resistance replay failed")
    f = [F(1, cert["full_cell_denominator"])] * (n - 1)
    u = solve(grounded, f)
    cost = sum(x * y for x, y in zip(f, u))
    require(cost == F(cert["remaining_full_cell_mean_reference_cost"]),
            "Full denominator reference cost failed")
    wrong = cost * F(cert["full_cell_denominator"], cert["unvisited_primary_count"]) ** 2
    require(wrong == F(cert["incorrect_renormalized_mean_reference_cost"]),
            "Unvisited-only denominator comparison failed")
    return str(resistance), str(cost)


def check_formal(cert):
    result = json.loads((ROOT / cert["compiler_record"]).read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "No successful real Lean run")
    require(result["proof_holes"] == [], "Lean proof has holes")
    version = result["tools"]["lean"]["version"]
    require(f"version {cert['required_lean_version']}," in version, "Wrong Lean version")
    record = result["kernel"]["recorded"]
    require(record["tier"] == "mechanical" and record["verdict"] == "supports",
            "Formal evidence was not recorded as support")
    require(record["subject"]["subject_id"] == cert["formalized_claim"],
            "Compiler record targets another claim")
    archive = json.loads((ROOT / record["artifact"]).read_text())
    source = (ROOT / cert["formal_source"]).read_text()
    fidelity = (ROOT / cert["statement_fidelity"]).read_text()
    require(archive["lean_source"]["text"] == source, "Formal source changed since compilation")
    require(archive["statement_fidelity"]["text"] == fidelity,
            "Statement fidelity changed since compilation")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claims = [c for c in state["claims"] if c["claim_id"] == cert["formalized_claim"]]
    claim = max(claims, key=lambda c: c["version"])
    require(claim["formal_statement"] == source, "Ledger formalization mismatch")
    require(claim["content_hash"] == record["subject"]["content_hash"],
            "Compiler record binds to a retired claim")
    return record["artifact"]


def main():
    cert = json.loads((HERE / "exact_certificate.json").read_text())
    scope = cert["source_scope"]
    for key, labels in (("profile", "profile_labels"), ("antecedent", "antecedent_labels")):
        source = (ROOT / scope[key]).read_text()
        for label in scope[labels]:
            require("\\label{" + label + "}" in source, f"Missing source locator: {label}")
    cases = check_signs(cert["sign_identity"])
    check_cubic(cert["reach_identity"])
    coefficients = check_sharpness(cert["abstract_sharpness"])
    resistance, cost = check_network(cert["primary_normalization_check"])
    archive = check_formal(cert)
    print(json.dumps({
        "exact_core": "passed",
        "pair_gram_cases": cases,
        "nonnegative_Bernstein_coefficients": coefficients,
        "terminal_resistance": resistance,
        "full_cell_mean_cost": cost,
        "lean_certificate": archive,
        "analytic_transfer": "proof in report.md; independent review pending",
    }, indent=2))


if __name__ == "__main__":
    main()
