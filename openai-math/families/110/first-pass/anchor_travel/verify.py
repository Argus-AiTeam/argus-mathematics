#!/usr/bin/env python3
"""Replay exact algebra and finite interfaces; the full proof is in report.md."""

import json
from collections import defaultdict
from fractions import Fraction as F
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def add(*polynomials):
    result = defaultdict(F)
    for polynomial in polynomials:
        for monomial, coefficient in polynomial.items():
            result[monomial] += coefficient
    return {m: c for m, c in result.items() if c}


def mul(*polynomials):
    result = {(): F(1)}
    for polynomial in polynomials:
        terms = defaultdict(F)
        for left, a in result.items():
            for right, b in polynomial.items():
                terms[tuple(sorted(left + right))] += a * b
        result = {m: c for m, c in terms.items() if c}
    return result


def scale(coefficient, polynomial):
    return {m: F(coefficient) * c for m, c in polynomial.items() if coefficient * c}


def variable(name):
    return {(name,): F(1)}


def check_polynomials(certificate):
    c = {name: F(value) for name, value in certificate["constants"].items()}
    rho = c["rho"]
    one = {(): F(1)}
    C, L, z, v, x, E, V, P, Q = map(variable, ("C", "L", "z", "v", "x", "E", "V", "P", "Q"))
    actual_C = add(one, x)
    delta = add({(): F(1, 4)}, scale(-1, v))
    amounts = add(V, mul(E, P), mul(E, Q))
    packing_input = mul(C, add(scale(rho * 14, L), scale(4 * rho, add(one, scale(2, L)))))
    drop_left = scale(2, mul(add(one, z), add(one, scale(-1, delta))))
    drop_right = scale(rho, add(z, one, delta))
    manuscript_input = add(
        scale(12 * rho, V),
        scale(1160 * rho, mul(actual_C, E, P)),
        scale(36, mul(actual_C, E, Q)),
    )
    extension_input = add(
        scale(6 * rho, V),
        scale(580 * rho, mul(actual_C, E, P)),
        scale(18, mul(actual_C, E, Q)),
    )
    expressions = {
        "packing_gap": add(mul(scale(c["coefficient_constant"], C), add(one, L)), scale(-1, packing_input)),
        "retained_drop_cross_gap": add(drop_left, scale(-1, drop_right)),
        "manuscript_constant_gap": add(
            scale(c["manuscript_constant"], mul(actual_C, amounts)), scale(-1, manuscript_input)
        ),
        "extension_constant_gap": add(
            scale(c["extension_constant"], mul(actual_C, amounts)), scale(-1, extension_input)
        ),
    }
    for name, terms in certificate["nonnegative_polynomial_certificates"].items():
        declared = defaultdict(F)
        for term in terms:
            coefficient = F(term["coefficient"])
            require(coefficient >= 0, f"{name}: negative coefficient")
            require(set(term["monomial"]) <= set(certificate["nonnegative_variables"]), f"{name}: unknown variable")
            declared[tuple(sorted(term["monomial"]))] += coefficient
        require(dict(declared) == expressions[name], f"{name}: polynomial identity is false")
    require(len(expressions) == len(certificate["nonnegative_polynomial_certificates"]), "missing polynomial")
    require(c["tau_min"] ** int(c["scale_offset"]) >= c["outer_ball_factor"], "scale offset too small")
    require(c["bad_count_per_log"] == c["scale_offset"] / c["log_two_lower_bound"], "bad count")
    require(c["good_count_per_log"] == 1 / c["log_two_lower_bound"], "band count")
    require(c["refresh_credit"] == c["refresh_separation"] ** 2 / 4, "refresh credit factor")
    require(c["refresh_drift"] == 2 / c["refresh_credit"], "refresh drift factor")
    require(c["refresh_endpoint"] == 2 / c["refresh_credit"], "refresh endpoint factor")
    require(c["physical_drift"] == c["coefficient_constant"] / 3, "ramp factor")
    require(c["park_variation"] == 2 * rho * (1 + 1 / c["tau_min"]), "variation factor")
    require(c["manuscript_endpoint"] == rho / c["manuscript_drop"], "endpoint factor")
    require(c["extension_endpoint"] == 2 * rho, "extension endpoint factor")
    require(c["manuscript_constant"] == 2 * c["extension_constant"], "specialization factor")
    return len(expressions)


def snapshot(levels, exponents, alpha):
    points = sorted({F(0)} | {sign * F(2) ** p for p in exponents for sign in (-1, 1)})
    weights = {point: F(1 if point == 0 else 1 + (i % 3)) for i, point in enumerate(points)}
    K = sum(weights.values(), F(0))
    r0 = max(points) - min(points)
    radii = [r0 / 2 ** j for j in range(levels + 1)]
    require(40 * radii[-1] < min(b - a for a, b in zip(points, points[1:])), "last cells not separated")
    keys = {
        point: tuple("H" if abs(point) <= 18 * radii[j] else f"S{point}"
                     for j in range(1, levels + 1))
        for point in points
    }
    require(len(set(keys.values())) == len(points), "prefix map not injective")
    mass = defaultdict(F)
    for point in points:
        for j in range(levels + 1):
            mass[keys[point][:j]] += weights[point]
    parks = defaultdict(F)
    root_parks = defaultdict(F)
    for point in points:
        depth = max(j for j in range(levels + 1)
                    if j == 0 or abs(point) <= 18 * radii[j])
        parks[keys[point][:depth]] += weights[point]
        root_parks[keys[point] if point == 0 else ()] += weights[point]

    def allocation(park):
        q = defaultdict(F)
        for vertex, amount in park.items():
            for j in range(len(vertex) + 1):
                q[vertex[:j]] += amount
        for vertex, amount in q.items():
            require(0 <= amount <= mass[vertex], "domination violated")
            children = sum((value for child, value in q.items()
                            if len(child) == len(vertex) + 1 and child[:-1] == vertex), F(0))
            require(children <= amount, "subtree feasibility violated")
            require(amount - children == park[vertex], "park identity violated")
        require(q[()] == K and q[keys[F(0)]] >= 1, "root or requested-leaf constraint")
        return q

    old_q, new_q = allocation(parks), allocation(root_parks)
    require(any(0 < len(vertex) < levels and amount > 0 for vertex, amount in parks.items()), "no internal park")
    require(root_parks[()] > 0, "root variation not exercised")
    vertices = set(old_q) | set(new_q) | set(parks) | set(root_parks)
    variation = sum((radii[len(v) - 1] * abs(new_q[v] - old_q[v])
                     for v in vertices if v), F(0))
    park_variation = sum((radii[len(v)] * abs(root_parks[v] - parks[v]) for v in vertices), F(0))
    require(park_variation <= F(3, 2) * variation, "parked variation bound")
    b = {j: sum((amount for vertex, amount in parks.items()
                 if len(vertex) == j and vertex[-1] == "H"), F(0))
         for j in range(1, levels + 1)}
    new_b = {j: sum((amount for vertex, amount in root_parks.items()
                     if len(vertex) == j and vertex[-1] == "H"), F(0))
             for j in range(1, levels + 1)}
    grouped = sum((radii[j] * abs(new_b[j] - b[j]) for j in b), F(0))
    require(grouped <= park_variation, "fixed-coordinate grouping")
    M = {j: sum((weights[p] for p in points if abs(p) <= 18 * radii[j]), F(0)) for j in b}
    u = {j: alpha + M[j] for j in b}
    rho = F(6, 5)
    for y in points:
        selected = [j for j in b if abs(y) <= 7 * radii[j]]
        A = {j: alpha + sum((weights[p] for p in points if abs(p - y) <= 67 * radii[j]), F(0)) for j in b}
        B = {j: alpha + sum((weights[p] for p in points if abs(p - y) <= radii[j]), F(0)) for j in b}
        product = F(1)
        for j in b:
            product *= A[j] / B[j]
            coarser = alpha + K if j <= 7 else B[j - 7]
            require(B[j] <= A[j] <= coarser, "geometric scale comparison")
            tail = sum((b[i] for i in selected if i >= j), F(0))
            require(tail <= A[j] - alpha, "cumulative capacity violated")
        require(product <= ((alpha + K) / alpha) ** 7, "multiplicative log telescope")
        bad = [j for j in selected if A[j] > 2 * B[j]]
        require(F(2) ** len(bad) <= product, "bad-level product bound")
        groups = defaultdict(list)
        for j in selected:
            require(u[j] >= B[j] / rho and b[j] <= M[j], "coefficient hypotheses")
            require(b[j] / u[j] <= rho, "individual coefficient")
            if j not in bad:
                a = 0
                while 2 ** (a + 1) * alpha <= A[j]:
                    a += 1
                groups[a].append(j)
        for a, members in groups.items():
            scale_a = 2 ** a * alpha
            require(all(u[j] >= scale_a / (2 * rho) for j in members), "band denominator")
            require(sum((b[j] for j in members), F(0)) <= 2 * scale_a, "band numerator")
            require(sum((b[j] / u[j] for j in members), F(0)) <= 4 * rho, "band coefficient")
        if groups:
            require(F(2) ** (len(groups) - 1) <= (alpha + K) / alpha, "band count")
        coefficients = sum((b[j] / u[j] for j in selected), F(0))
        require(coefficients <= rho * len(bad) + 4 * rho * len(groups), "packing aggregation")
    return len(points)


def check_refreshes(settings):
    rho = F(6, 5)
    grid = list(map(F, settings["refresh_mass_grid"]))
    count = 0
    absence_with_held_reference = False
    for alpha in map(F, settings["affine_offsets"]):
        for old_mass in grid:
            for new_mass in grid:
                u, s = alpha + old_mass, alpha + new_mass
                refresh = not (u / rho <= s <= rho * u)
                new_u = s if refresh else u
                require(new_u / rho <= s <= rho * new_u, "completed reference comparison")
                if refresh:
                    maximum = max(u, s)
                    require(abs(s - u) >= maximum / 6, "refresh separation")
                    quadratic_gap = (s - u) ** 2 / (2 * maximum)
                    require(quadratic_gap >= (s + u) / 144, "refresh credit")
                count += 1
        u = alpha
        for mass in map(F, settings["reuse_mass_sequence"]):
            s = alpha + mass
            old_u = u
            refresh = not (u / rho <= s <= rho * u)
            if refresh:
                u = s
            require(u / rho <= s <= rho * u, "persistent reference comparison")
            if mass == 0 and not refresh and u != alpha:
                absence_with_held_reference = True
                require(u == old_u, "absent slot was restarted")
    require(absence_with_held_reference, "persistent absent-slot test not exercised")
    return count


def travel_family(horizon, alpha):
    rho, K, r0 = F(6, 5), F(2), F(10)
    r1, r2 = F(1), F(1, 10)
    require(r0 / r1 == r1 / r2 == 10 and 40 * r2 < 10, "two-level scales")
    require(8 * r1 < 10 <= 40 * r1, "retained reuse displacement")
    require(10 <= 18 * r1 and 18 * r2 < 10 <= 100 * r2, "heavy ball intersection geometry")
    pool_size = 12
    refs = [alpha + K] + [alpha] * (pool_size - 1)
    current, previous_released = 0, None
    R = F(0)
    for t in range(1, horizon + 1):
        new = t % 3
        require(new not in {current, previous_released}, "fresh-slot cooldown")
        for slot in range(pool_size):
            mass = K if slot == new else F(0)
            s = alpha + mass
            if not (refs[slot] / rho <= s <= rho * refs[slot]):
                R += r2 * (refs[slot] + s)
                refs[slot] = s
            require(refs[slot] / rho <= s <= rho * refs[slot], "family reference")
        actual_drop = K / (alpha + K)
        lower_drop = 1 / (2 * (1 + alpha / K))
        require(actual_drop >= lower_drop, "retained inner-mass payment")
        previous_released, current = current, new
    V, P, Q, T = F(2 * horizon), F(2 * horizon), F(20 * horizon), F(horizon)
    L_H = r1 + pool_size * r2
    D_lower = 576 * (alpha + K) * L_H
    require(R <= 288 * P + D_lower, "finite refresh amortization")
    A = 1 + alpha / K
    rhs_lower = 700 * A * (V + P + Q) + F(12, 5) * A * (K * r0 + D_lower)
    require(T <= rhs_lower, "finite travel bound")
    require(10 * T <= 40 * T, "physical retained-anchor distance")
    return {"horizon": horizon, "T": str(T), "V": str(V), "P": str(P), "Q": str(Q)}


def check_jacobian(certificate):
    item = certificate["jacobian"]
    payload = json.loads((HERE / item["payload"]).read_text())
    output = json.loads((HERE / item["output"]).read_text())
    require(item["adapter_status"] == "completed" and not item["timeout"] and item["structured_error"] is None,
            "adapter is not a mathematical conclusion")
    require(output["server"]["version"] == item["server_version"], "Jacobian version")
    require(output["protocol_version"] == item["protocol_version"], "Jacobian protocol")
    require(output["request"] == {"operation_id": item["operation_id"], "payload": payload}, "exact payload binding")
    result = output["result"]
    require(result["operation_id"] == item["operation_id"], "Jacobian operation")
    require(result["output"]["order"] == payload["order"] == 1, "moment order")

    def rational(value):
        answer = F(int(value["num"]), int(value["den"]))
        require(str(answer.numerator) == value["num"] and str(answer.denominator) == value["den"],
                "noncanonical Jacobian rational")
        return answer

    total, probability, selected = F(0), F(0), F(0)
    contributions = result["output"]["contributions"]
    require(len(contributions) == len(payload["atoms"]), "incomplete Jacobian output")
    for atom, contribution in zip(payload["atoms"], contributions):
        p, value = rational(atom["probability"]), rational(atom["value"])
        require(contribution["probability"] == atom["probability"] and contribution["value"] == atom["value"],
                "Jacobian atom binding")
        require(rational(contribution["powered_value"]) == value, "powered value")
        require(rational(contribution["contribution"]) == p * value, "atom contribution")
        probability += p
        total += p * value
        if value > 0:
            selected += p * value
    require(probability == 1 and total == rational(result["output"]["moment"]) == F(item["expected_moment"]),
            "all-step filtering expectation")
    require(selected == F(item["positive_event_restricted_mean"]) > 0, "invalid selected-event cancellation")


def check_lean(certificate):
    receipt = json.loads((HERE / "lean_verify.json").read_text())
    require(receipt["status"] == "success" and receipt["exit_code"] == 0 and receipt["proof_holes"] == [],
            "no successful hole-free compiler receipt")
    require("version 4.31.0," in receipt["tools"]["lean"]["version"], "wrong Lean version")
    record = receipt["kernel"]["recorded"]
    require(record["subject"]["subject_id"] == certificate["formal_claim_id"] and record["verdict"] == "supports",
            "wrong mechanical claim or verdict")
    archive_path = (ROOT / record["artifact"]).resolve()
    require(archive_path.is_relative_to(HERE), "compiler archive outside mission")
    archive = json.loads(archive_path.read_text())
    require(archive["lean_source"]["text"] == (HERE / "Main.lean").read_text(), "source edited after compile")
    require(archive["statement_fidelity"]["text"] == (HERE / "statement_fidelity.md").read_text(),
            "statement fidelity edited after compile")
    require(archive["lean_check"]["source_sha256"] == receipt["source_sha256"], "compiler source binding")
    require(archive["lean_check"]["statement_fidelity_sha256"] == receipt["statement_fidelity_sha256"],
            "compiler fidelity binding")
    source = archive["lean_source"]["text"]
    for declaration in certificate["formal_declarations"]:
        require(f"theorem {declaration}" in source, f"missing formal declaration {declaration}")
    return record["artifact"]


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["schema_version"] == 1 and not certificate["full_theorem_formalized"], "scope mismatch")
    require((HERE / certificate["proof"]).is_file(), "missing quantified prose proof")
    polynomial_count = check_polynomials(certificate)
    settings = certificate["finite_tests"]
    snapshots = 0
    for levels in settings["snapshot_levels"]:
        for alpha in map(F, settings["affine_offsets"]):
            snapshots += snapshot(levels, settings["line_exponents"], alpha)
    refresh_cases = check_refreshes(settings)
    families = [travel_family(n, alpha) for n in settings["travel_horizons"]
                for alpha in map(F, settings["affine_offsets"])]
    check_jacobian(certificate)
    archive = check_lean(certificate)
    print(json.dumps({
        "status": "verified",
        "universal_nonnegative_polynomial_identities": polynomial_count,
        "coefficient_snapshot_point_tests": snapshots,
        "refresh_grid_cases": refresh_cases,
        "repeated_reuse_interface_families": len(families),
        "largest_family": families[-1],
        "lean_version": "4.31.0",
        "lean_exit_code": 0,
        "lean_proof_holes": [],
        "lean_certificate": archive,
        "full_stochastic_geometric_theorem_formalized": False,
        "independent_review": certificate["independent_review"]
    }, indent=2))


if __name__ == "__main__":
    main()
