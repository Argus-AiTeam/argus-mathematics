#!/usr/bin/env python3
"""Replay exact certificates; the default run also requires fresh Lean evidence."""

import argparse
from collections import deque
from fractions import Fraction as Q
from functools import lru_cache
import hashlib
import json
from math import lcm
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(name):
    return json.loads((ROOT / name).read_text())


def vector(values):
    return [Q(x) for x in values]


def add(*vectors):
    return [sum(entries, Q(0)) for entries in zip(*vectors, strict=True)]


def scale(scalar, values):
    return [scalar * value for value in values]


def dot(left, right):
    return sum((x * y for x, y in zip(left, right, strict=True)), Q(0))


def affine(values, x):
    slope, intercept = vector(values)
    return slope * x + intercept


def replay_linear_certificate(cert):
    require(1 + max(Q(1), Q(1), Q(4, 3)) == Q(7, 3) and
            1 + max(Q(1), 2 * Q(2, 3)) == Q(7, 3),
            "The generic endpoint obstruction was misstated")
    data = cert["second_endpoint"]
    rows = [vector(row["coefficients"]) for row in data["le_rows"]]
    rhs = [Q(row["rhs"]) for row in data["le_rows"]]
    require(rows == [[-1, -2], [1, 0], [1, 4]], "Wrong endpoint moment constraints")
    require(rhs == [Q(-7, 3), Q(2, 3), Q(4)], "Wrong endpoint right sides")
    for consequence in data["consequences"]:
        multipliers = vector(consequence["multipliers"])
        require(all(x >= 0 for x in multipliers), "A Farkas multiplier is negative")
        combined = add(*(scale(t, row) for t, row in zip(multipliers, rows, strict=True)))
        require(combined == vector(consequence["coefficients"]), consequence["name"])
        require(dot(multipliers, rhs) == Q(consequence["rhs"]), consequence["name"])
    point = vector(data["forced_point"])
    require(point == [Q(2, 3), Q(5, 6)], "Wrong forced endpoint")
    require(all(dot(row, point) <= b for row, b in zip(rows, rhs, strict=True)),
            "Forced endpoint is not feasible")

    lo, hi = vector(cert["cubic_middle_interval"])
    require((lo, hi) == (Q(1, 2), Q(2)), "Wrong cubic middle interval")
    middle = [Q(2, 3), Q(2, 3)]
    for competitor in ([Q(0), Q(1)], [Q(1), Q(0)]):
        require(all(dot(add(middle, scale(-1, competitor)), [z, 1]) >= 0
                    for z in (lo, hi)), "Cubic maximum identity failed")
    require(add([Q(1), Q(0)], middle) == [Q(5, 3), Q(2, 3)],
            "Cubic multiplicity normalization failed")


def replay_gram(cert):
    data = cert["gram"]
    lo, hi = vector(data["interval"])
    switch, gap = Q(data["switch"]), Q(data["common_gap"])
    require((lo, hi, switch, gap) == (Q(7, 5), Q(19, 10), Q(3, 2), Q(1, 30)),
            "Wrong universal Gram interval")
    require(hi - lo >= Q(data["coverage_max_step"]) == Q(1, 2),
            "Interval does not cover all positive short steps")
    target = vector(data["target_affine"])
    diagonal = [Q(1), Q(-2, 3)]
    off_low = scale(Q(1, 2), add([Q(1), Q(0)], [Q(-2, 3), Q(2)], [Q(0), Q(-2, 3)]))
    off_high = scale(Q(1, 2), add([Q(1), Q(0)], [Q(0), Q(1)], [Q(0), Q(-2, 3)]))
    require(target == [Q(2, 3), Q(0)], "Wrong Gram target exponent")
    for name, branch, left, right in (
        ("diagonal", diagonal, lo, hi),
        ("off_low", off_low, lo, switch),
        ("off_high", off_high, switch, hi),
    ):
        require(branch == vector(data[name + "_affine"]), "Wrong " + name + " exponent")
        difference = add(target, scale(-1, branch))
        require(difference == vector(data[name + "_gap_affine"]), "Wrong " + name + " gap")
        require(all(dot(difference, [z, 1]) >= gap for z in (left, right)),
                "Nonpositive universal " + name + " gap")
    require(Q(1) <= 2 - 2 * lo / 3 and Q(1) >= 2 - 2 * hi / 3,
            "Wrong maximum branches")
    require(2 - 2 * switch / 3 == 1, "Wrong Gram switch point")

    rows = [[Q(1), Q(-1), Q(0)], [Q(0), Q(1), Q(3)], [Q(-3), Q(0), Q(6)]]
    bounds = [Q(-1, 2), Q(2), Q(-4)]
    multipliers = vector(data["optimal_le_multipliers"])
    require(all(x >= 0 for x in multipliers), "Invalid optimal-gap dual signs")
    require(add(*(scale(t, row) for t, row in zip(multipliers, rows, strict=True))) ==
            [Q(0), Q(0), Q(1)], "Invalid optimal-gap dual balance")
    require(dot(multipliers, bounds) == gap, "Wrong optimal common gap")
    require(2 * Q(37, 100) == Q(37, 50), "Wrong height convention")


def replay_dominant_and_poisson(cert):
    data = cert["dominant_full"]
    h, threshold = Q(data["height_exponent"]), Q(data["near_full_threshold"])
    require((h, threshold) == (Q(37, 100), Q(19, 20)), "Wrong dominant-full parameters")
    dual = [-Q(1), 1 + 2 * h]
    cubic = scale(Q(2, 3), add([Q(0), Q(1)], dual))
    first = add([-Q(1), Q(2)], cubic)
    second = [-Q(2), Q(10, 3) + 2 * h]
    require(dual == vector(data["first_dual_length_affine"]), "Wrong full dual length")
    require(first == vector(data["first_upper_affine"]), "Wrong first full-sum exponent")
    require(second == vector(data["second_upper_affine"]), "Wrong second full-sum exponent")
    for a in (threshold, Q(1)):
        require(dot(cubic, [a, 1]) >= max(1, dot(dual, [a, 1])),
                "Wrong dominant-full cubic maximum")
    require(dot(first, [1, 1]) == Q(data["first_exact_full_upper"]),
            "Wrong first endpoint full-sum exponent")
    require(dot(second, [1, 1]) == Q(data["second_exact_full_upper"]),
            "Wrong second endpoint full-sum exponent")
    for name, expression in (("first", first), ("second", second)):
        gap = Q(data[name + "_near_full_gap"])
        require(gap > 0, "Full-sum gap must be strict")
        require(all(Q(7, 3) - dot(expression, [a, 1]) >= gap
                    for a in (threshold, Q(1))), "Dominant-full inequality failed")

    dyads = cert["poisson_dyads"]
    amplitude = vector(dyads["amplitude_squared"])
    length = vector(dyads["natural_dual_length"])
    outer = vector(dyads["outer_length"])
    require(amplitude == [2, -2, 2, -2], "Wrong squared Poisson amplitude")
    require(length == [-1, 2, -2, 1] and outer == [0, 1, -1, 0],
            "Wrong Poisson lengths")
    resulting = [
        add(amplitude, length, outer),
        add(amplitude, scale(2, length)),
        add(amplitude, scale(Q(5, 3), length), scale(Q(2, 3), outer)),
    ]
    require(resulting == [vector(row) for row in dyads["resulting_terms"]],
            "Poisson substitution identity failed")
    for term, bound in zip(resulting, dyads["dominating_terms"], strict=True):
        require(all(x >= 0 for x in add(vector(bound), scale(-1, term))),
                "A claimed Poisson monomial domination is false")
    powers = vector(dyads["positive_dyadic_powers"])
    require(powers == [1, 2, Q(5, 3)], "Wrong frequency dyad powers")
    require(all(0 < q < Q(dyads["decay_power"]) for q in powers),
            "Dyadic decay fails, including when the natural length is below one")


def wire_rational(value):
    number = Q(int(value["num"]), int(value["den"]))
    require(str(number.numerator) == value["num"] and str(number.denominator) == value["den"],
            "Noncanonical wire rational")
    return number


def replay_jacobian(cert):
    data = cert["jacobian"]
    failed = read_json(data["initial_output"])
    require(data["initial_adapter_exit"] == 2 and not failed["ok"], "Missing adapter refusal")
    require(failed["error"]["data"]["code"] == "INVALID_REQUEST", "Wrong initial refusal")
    require(failed["error"]["data"]["operation_id"] == data["operation_id"],
            "Initial operation identity changed")
    request, response = read_json(data["exact_payload"]), read_json(data["exact_output"])
    require(data["exact_adapter_exit"] == 0, "Adapter did not succeed")
    require(response["request"]["operation_id"] == data["operation_id"],
            "Wrong executed operation")
    require(response["request"]["payload"] == request, "Payload/source mismatch")
    require(response["server"]["version"] == data["server_version"] and
            response["protocol_version"] == data["protocol_version"], "Wrong adapter version")
    output = response["result"]["output"]
    require(output["status"] == "OPTIMAL", "A non-conclusion is not optimality evidence")
    program = request["program"]
    require(output["program"] == program, "Solver output is bound to another LP")
    point = [wire_rational(x) for x in output["primal_candidate"]]
    dual = [wire_rational(x) for x in output["constraint_dual"]]
    require(point == vector(data["primal"]), "Wrong exact LP point")
    stationarity = [Q(0)] * len(point)
    dual_value = Q(0)
    for row, multiplier in zip(program["constraints"], dual, strict=True):
        coefficients, rhs = [wire_rational(x) for x in row["coefficients"]], wire_rational(row["rhs"])
        lhs = dot(coefficients, point)
        relation = row["relation"]
        require((lhs <= rhs and multiplier >= 0) if relation == "LE" else
                (lhs >= rhs and multiplier <= 0) if relation == "GE" else lhs == rhs,
                "LP primal feasibility or dual sign failed")
        require(multiplier * (lhs - rhs) == 0, "LP complementarity failed")
        stationarity = add(stationarity, scale(multiplier, coefficients))
        dual_value += multiplier * rhs
    for index, variable in enumerate(program["variables"]):
        lower = variable["lower_bound"]
        upper = variable["upper_bound"]
        lower_dual = wire_rational(output["lower_bound_dual"][index])
        upper_dual = wire_rational(output["upper_bound_dual"][index])
        require(lower_dual <= 0 <= upper_dual, "Wrong bound dual signs")
        if lower is not None:
            lower = wire_rational(lower)
            require(point[index] >= lower and lower_dual * (point[index] - lower) == 0,
                    "Wrong lower-bound certificate")
            dual_value += lower_dual * lower
        else:
            require(lower_dual == 0, "Dual weight on an absent lower bound")
        if upper is not None:
            upper = wire_rational(upper)
            require(point[index] <= upper and upper_dual * (upper - point[index]) == 0,
                    "Wrong upper-bound certificate")
            dual_value += upper_dual * upper
        else:
            require(upper_dual == 0, "Dual weight on an absent upper bound")
        stationarity[index] += lower_dual + upper_dual
    objective = [wire_rational(x) for x in program["objective"]["coefficients"]]
    require(program["objective"]["sense"] == "MAXIMIZE" and stationarity == objective,
            "LP stationarity failed")
    require(dot(objective, point) == dual_value == Q(1, 30), "LP strong duality failed")


def emul(z, w):
    a, b = z
    c, d = w
    return a * c - b * d, a * d + b * c - b * d


def eadd(z, w):
    return z[0] + w[0], z[1] + w[1]


def enorm(z):
    a, b = z
    return a * a - a * b + b * b


def ediv(z, w):
    numerator = emul(z, (w[0] - w[1], -w[1]))
    denominator = enorm(w)
    return Q(numerator[0], denominator), Q(numerator[1], denominator)


def key(z, modulus):
    a, b = ediv(z, modulus)
    return a % 1, b % 1


def representatives(modulus):
    size = enorm(modulus)
    require(0 < size <= 200, "Finite test exceeded its declared bound")
    seen = {key((0, 0), modulus)}
    queue, result = deque([(0, 0)]), [(0, 0)]
    while queue:
        z = queue.popleft()
        for generator in ((1, 0), (0, 1)):
            w = eadd(z, generator)
            k = key(w, modulus)
            if k not in seen:
                seen.add(k)
                queue.append(w)
                result.append(w)
    require(len(result) == size, "Incorrect quotient-ring cardinality")
    return result


def epow(z, power):
    result = (1, 0)
    for _ in range(power):
        result = emul(result, z)
    return result


CUBE_ROOTS = ((1, 0), (0, 1), (-1, -1))
LAMBDA = (1, 2)


def character(z, prime):
    if key(z, prime) == (0, 0):
        return None
    power = epow(z, (enorm(prime) - 1) // 3)
    matches = [i for i, root in enumerate(CUBE_ROOTS) if key(power, prime) == key(root, prime)]
    require(len(matches) == 1, "A listed factor is not a suitable cubic prime")
    return matches[0]


def psi(z, a, b):
    left, right = character(z, a), character(z, b)
    return None if left is None or right is None else (left - right) % 3


def trim(poly):
    while len(poly) > 1 and poly[-1] == 0:
        poly.pop()
    return poly


def divide_monic(numerator, denominator):
    rest = trim(list(numerator))
    require(denominator[-1] == 1, "Nonmonic cyclotomic divisor")
    quotient = [0] * max(1, len(rest) - len(denominator) + 1)
    while len(rest) >= len(denominator) and rest != [0]:
        shift, coefficient = len(rest) - len(denominator), rest[-1]
        quotient[shift] += coefficient
        for j, entry in enumerate(denominator):
            rest[shift + j] -= coefficient * entry
        trim(rest)
    return trim(quotient), rest


@lru_cache(maxsize=None)
def cyclotomic(order):
    poly = [-1] + [0] * (order - 1) + [1]
    for divisor in range(1, order):
        if order % divisor == 0:
            poly, rest = divide_monic(poly, cyclotomic(divisor))
            require(rest == [0], "Cyclotomic construction was not exact")
    return tuple(poly)


def root_exponent(value, order):
    exponent = value * order
    require(exponent.denominator == 1, "Root-of-unity order is too small")
    return exponent.numerator % order


def zero_in_cyclotomic(poly, order):
    return divide_monic(poly, cyclotomic(order))[1] == [0]


def replay_finite_poisson(cert):
    require(epow((-LAMBDA[0], -LAMBDA[1]), 3) == (3, 6),
            "The identity (-lambda)^3 = 3lambda failed")
    counts = []
    for case in cert["finite_poisson_checks"]:
        a, b = tuple(case["a"]), tuple(case["b"])
        require(all(z[0] % 3 == 1 and z[1] % 3 == 0 for z in (a, b)),
                "A tested modulus is not primary")
        for prime in (a, b):
            values = set()
            for x in representatives(prime):
                if key(x, prime) != (0, 0):
                    require(key(epow(x, enorm(prime) - 1), prime) == key((1, 0), prime),
                            "A listed prime quotient is not a field")
                    values.add(character(x, prime))
            require(values == {0, 1, 2}, "Local cubic character is principal")
        require(key(b, a) != (0, 0), "Finite primitive factors are not coprime")
        modulus = emul(a, b)
        reps, order = representatives(modulus), lcm(3, enorm(modulus))
        require(psi((3, 6), a, b) == 0, "The CRT unit factor is not one")
        gauss = [0] * order
        for x in reps:
            value = psi(x, a, b)
            if value is not None:
                u, v = ediv(x, modulus)
                gauss[root_exponent(2 * u - v + Q(value, 3), order)] += 1
        for h in reps:
            fourier = [0] * order
            for s in reps:
                x = eadd(modulus, (3 * s[0], 3 * s[1]))
                value = psi(x, a, b)
                if value is None:
                    continue
                denominator = emul((3, 6), modulus)
                u, v = ediv(emul(x, h), denominator)
                direct_phase = 2 * u - v
                separated_phase = Q(h[1], 3) + ediv(emul(s, h), modulus)[1]
                require((direct_phase - separated_phase).denominator == 1,
                        "The supposedly fixed CRT phase depends on the modulus")
                fourier[root_exponent(direct_phase + Q(value, 3), order)] += 1
            value = psi(h, a, b)
            rhs = [0] * order
            if value is not None:
                shift = root_exponent(Q(h[1] - value, 3), order)
                for j, coefficient in enumerate(gauss):
                    rhs[(j + shift) % order] += coefficient
            require(zero_in_cyclotomic(
                [x - y for x, y in zip(fourier, rhs, strict=True)], order),
                "Exact finite Poisson/CRT coefficient failed")
            if h == (0, 0):
                require(zero_in_cyclotomic(fourier, order), "Zero frequency did not vanish")
        absolute_square = [0] * order
        for i, left in enumerate(gauss):
            for j, right in enumerate(gauss):
                absolute_square[(i - j) % order] += left * right
        absolute_square[0] -= enorm(modulus)
        require(zero_in_cyclotomic(absolute_square, order), "Primitive Gauss norm failed")
        counts.append({"conductor_norm": enorm(modulus), "all_frequency_classes": len(reps)})

    k, a, b = (-2, 0), (1, 3), (-2, -3)
    for x in representatives(emul(k, emul(a, b))):
        shared = character(x, k)
        left, right = character(x, a), character(x, b)
        p_value = None if shared is None or left is None else (shared + left) % 3
        pprime_value = None if shared is None or right is None else (shared + right) % 3
        lhs = None if p_value is None or pprime_value is None else (p_value - pprime_value) % 3
        value = psi(x, a, b)
        rhs = value if key(x, k) != (0, 0) else None
        require(lhs == rhs, "Common-factor exclusion failed")
    return counts


def replay_lean(cert):
    result = read_json("lean_check.json")
    require(result["status"] == "success" and result["exit_code"] == 0,
            "A successful real Lean compile is required")
    require(result.get("proof_holes") == [], "Lean proof has holes")
    require(result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
            "Lean 4.31.0 is required")
    require("sorryAx" not in result["stdout"], "An audited theorem depends on sorryAx")
    for name, field in (("Main.lean", "source_sha256"),
                        ("statement_fidelity.md", "statement_fidelity_sha256")):
        require(hashlib.sha256((ROOT / name).read_bytes()).hexdigest() == result[field],
                name + " changed after the compiler run")
    source = (ROOT / "Main.lean").read_text()
    fidelity = (ROOT / "statement_fidelity.md").read_text()
    for declaration in cert["formal_declarations"]:
        name = declaration.split(".")[-1]
        require("theorem " + name in source and name in fidelity,
                "Missing formal declaration or fidelity description: " + name)
    project = ROOT.parents[1]
    state = json.loads((project / "research/MATH_STATE.json").read_text())
    claims = [claim for claim in state["claims"] if claim["claim_id"] == cert["claim_id"]]
    require(bool(claims), "The formal claim is missing from the project ledger")
    claim = max(claims, key=lambda item: item["version"])
    require(claim["formal_statement"].strip() == source.strip(),
            "The current claim records a different formal source")
    matching = [evidence for evidence in state["evidence"]
                if evidence["subject"]["subject_id"] == cert["claim_id"]
                and evidence["subject"]["content_hash"] == claim["content_hash"]
                and evidence["tier"] == "mechanical" and evidence["verdict"] == "supports"]
    require(bool(matching), "The current claim has no mechanical supporting evidence")
    for evidence in matching:
        archive = json.loads((project / evidence["artifact"]).read_text())
        require(archive["lean_source"]["text"] == source and
                archive["statement_fidelity"]["text"] == fidelity,
                "The claim's immutable archive describes another theorem or fidelity reading")
        require(archive["lean_check"]["source_sha256"] == result["source_sha256"] and
                archive["lean_check"]["statement_fidelity_sha256"] ==
                result["statement_fidelity_sha256"],
                "The claim's mechanical archive is stale")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--arithmetic-only", action="store_true",
                        help="Development check only; does not certify the universal Lean theorem")
    args = parser.parse_args()
    cert = read_json("exact_certificate.json")
    require(cert["schema_version"] == 1 and cert["claim_id"] == "C_EXPONENTS",
            "Wrong certificate identity")
    replay_linear_certificate(cert)
    replay_gram(cert)
    replay_dominant_and_poisson(cert)
    replay_jacobian(cert)
    finite = replay_finite_poisson(cert)
    if not args.arithmetic_only:
        replay_lean(cert)
    print(json.dumps({
        "status": "arithmetic_only" if args.arithmetic_only else "verified",
        "claim_id": cert["claim_id"],
        "universal_exponent_theorem": not args.arithmetic_only,
        "both_exceptional_configurations": True,
        "dominant_full_sum": True,
        "strict_common_gram_gap": cert["gram"]["common_gap"],
        "jacobian_optimum_independently_replayed": True,
        "finite_exact_poisson_checks": finite,
        "analytic_derivation": "prose proof in report.md; independent review pending",
        "full_prime_asymptotic_certified": False
    }, indent=2))


if __name__ == "__main__":
    main()
