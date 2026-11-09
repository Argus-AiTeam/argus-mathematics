#!/usr/bin/env python3
"""Replay exact certificates for the scoped return-pattern verification theorem."""

import argparse
from fractions import Fraction as Q
from hashlib import sha256
import json
from math import gcd
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load(name):
    return json.loads((HERE / name).read_text(encoding="utf-8"))


def rational(value):
    result = Q(int(value["num"]), int(value["den"]))
    require(
        str(result.numerator) == value["num"]
        and str(result.denominator) == value["den"],
        "noncanonical rational in typed evidence",
    )
    return result


def dot(left, right):
    return sum((x * y for x, y in zip(left, right)), Q(0))


def replay_lp():
    payload = load("jacobian_lp_payload.json")
    envelope = load("jacobian_lp_output.json")
    operation = "optimization.linear.rational_general_optimum.compute"
    require(envelope["request"]["operation_id"] == operation, "wrong LP operation")
    require(envelope["request"]["payload"] == payload, "LP payload is not source-bound")
    require(envelope["result"]["operation_id"] == operation, "wrong result operation")
    require(envelope["protocol_version"] == "2025-11-25", "unexpected protocol")
    require(envelope["server"]["version"] == "0.14.0", "unexpected server version")
    output = envelope["result"]["output"]
    program = payload["program"]
    require(output["program"] == program, "LP result changed the original program")
    require(output["status"] == "OPTIMAL", "LP did not prove an optimum")
    point = list(map(rational, output["primal_candidate"]))
    dual = list(map(rational, output["constraint_dual"]))
    lower_dual = list(map(rational, output["lower_bound_dual"]))
    upper_dual = list(map(rational, output["upper_bound_dual"]))
    objective = list(map(rational, program["objective"]["coefficients"]))
    rows = [list(map(rational, row["coefficients"])) for row in program["constraints"]]
    rhs = [rational(row["rhs"]) for row in program["constraints"]]
    require(len(point) == len(objective) == 3, "wrong primal dimension")
    require(len(dual) == len(rows) == 3, "wrong dual dimension")
    require(len(lower_dual) == len(upper_dual) == 3, "wrong bound-dual dimension")
    require(program["objective"]["sense"] == "MINIMIZE", "wrong objective sense")
    for index, variable in enumerate(program["variables"]):
        require(variable["upper_bound"] is None, "unexpected finite upper bound")
        require(rational(variable["lower_bound"]) == 0, "unexpected lower bound")
        require(point[index] >= 0 and lower_dual[index] >= 0, "invalid lower bound")
        require(upper_dual[index] == 0, "dual for an absent upper bound")
    for index, row in enumerate(program["constraints"]):
        require(row["relation"] == "GE", "unexpected LP row relation")
        require(dual[index] >= 0, "incorrect source-coordinate dual sign")
        slack = dot(rows[index], point) - rhs[index]
        require(slack >= 0, "infeasible primal LP point")
        require(slack == rational(output["constraint_slacks"][index]), "wrong slack")
        require(slack * dual[index] == 0, "complementary slackness failed")
    for column in range(3):
        balance = sum(dual[row] * rows[row][column] for row in range(3))
        require(balance + lower_dual[column] == objective[column], "dual balance")
    primal_value = dot(objective, point)
    dual_value = dot(dual, rhs)
    require(primal_value == dual_value == Q(1, 16), "primal/dual gap")
    require(rational(output["primal_objective"]) == primal_value, "wrong objective")
    require(rational(output["dual_objective"]) == dual_value, "wrong dual objective")
    error = load("jacobian_lp_admission_error.json")["error"]
    require(error["data"]["stage"] == "operation_validation", "unclassified refusal")
    require(error["data"]["operation_id"] == operation, "wrong refused operation")
    original = load("jacobian_lp_admission_payload.json")
    require(original["program"]["constraints"] == program["constraints"], "changed rows")
    require(original["program"]["objective"] == program["objective"], "changed objective")
    require(
        all(v["lower_bound"] is None and v["upper_bound"] is None
            for v in original["program"]["variables"]),
        "the preserved refused payload is not the all-free representation",
    )
    return {
        "operation_id": operation,
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "adapter_exit_status": 0,
        "status": output["status"],
        "optimum": str(primal_value),
        "primal": list(map(str, point)),
        "row_dual": list(map(str, dual)),
        "prior_admission_error": error["data"]["errors"][0]["code"],
        "prior_adapter_exit_status": 2,
        "timeout": False,
    }


def sign(value):
    return (value > 0) - (value < 0)


def planar_sign_faces(functions):
    points = {(Q(0), Q(0))}
    for a, b, c in functions:
        if a == b == 0:
            continue
        if b:
            origin, direction = (Q(0), -c / b), (Q(1), -a / b)
        else:
            origin, direction = (-c / a, Q(0)), (Q(0), Q(1))
        parameters = set()
        for aa, bb, cc in functions:
            slope = aa * direction[0] + bb * direction[1]
            value = aa * origin[0] + bb * origin[1] + cc
            if slope:
                parameters.add(-value / slope)
        ordered = sorted(parameters)
        samples = [Q(0)] if not ordered else [ordered[0] - 1, ordered[-1] + 1]
        samples += [(left + right) / 2 for left, right in zip(ordered, ordered[1:])]
        for parameter in ordered:
            points.add(tuple(origin[i] + parameter * direction[i] for i in range(2)))
        for parameter in samples:
            point = tuple(origin[i] + parameter * direction[i] for i in range(2))
            points.add(point)
            margin = Q(1)
            for aa, bb, cc in functions:
                value = aa * point[0] + bb * point[1] + cc
                derivative = aa * a + bb * b
                if value and derivative:
                    margin = min(margin, abs(value) / (2 * abs(derivative)))
            for side in (-1, 1):
                points.add((point[0] + side * margin * a,
                            point[1] + side * margin * b))
    return {
        tuple(sign(a * x + b * y + c) for a, b, c in functions)
        for x, y in points
    }


def replay_planar_faces():
    results = []
    for count in range(9):
        lines = [(Q(i), Q(-1), Q(i * i)) for i in range(count)]
        actual = len(planar_sign_faces(lines))
        require(actual == 2 * count * count + 1, "generic all-face count")
        results.append({"case": f"general_position_{count}", "faces": actual})
    cases = [
        ("parallel", [(Q(1), Q(0), Q(-i)) for i in range(6)], 13),
        ("concurrent", [(Q(i), Q(-1), Q(0)) for i in range(5)], 21),
        ("coincident_and_constants",
         [(Q(0), Q(-1), Q(0)), (Q(1), Q(-1), Q(1)),
          (Q(2), Q(-1), Q(4)), (Q(-2), Q(2), Q(-2)),
          (Q(0), Q(0), Q(0)), (Q(0), Q(0), Q(7))], 19),
    ]
    for name, lines, expected in cases:
        actual = len(planar_sign_faces(lines))
        require(actual == expected, f"{name}: wrong equality-face count")
        require(actual <= 2 * len(lines) ** 2 + 1, "planar upper bound")
        results.append({"case": name, "faces": actual})
    return results


def floor(value):
    return value.numerator // value.denominator


def ceil(value):
    return -floor(-value)


def centered(value):
    return (value + Q(1, 2)) % 1 - Q(1, 2)


def rho(value):
    return Q(1, 2) - abs(centered(value))


def replay_ranges():
    tested = 0
    for shift in (-Q(10**120), -Q(5, 3), Q(0), Q(7, 11), Q(10**120)):
        for width in (Q(1, 32), Q(1, 10**12), Q(1, 10**120)):
            left = -Q(7, 13)
            lo, hi = left + shift - width, left + shift + 2 * width
            lattice_count = floor(hi / width) - ceil(lo / width) + 1
            require(lattice_count <= 4, "uniform endpoint count depends on translation")
            for endpoint in (Q(7, 19), lo % 1, hi % 1):
                lifts = max(0, floor(hi - endpoint) - ceil(lo - endpoint) + 1)
                require(lifts <= 1, "multiple lifts in a range shorter than one")
            for a in (left, left + width / 2, left + width):
                for b in (-width, Q(0), width):
                    for coefficient in (-Q(1), -Q(16, 17), Q(0), Q(16, 17), Q(1)):
                        value = a + shift + coefficient * b
                        require(lo <= value <= hi, "anchored closed range")
                        tested += 1
    return {"exact_range_tests": tested, "largest_translation": "10^120",
            "smallest_anchor_width": "10^-120"}


def replay_thresholds():
    tested = 0
    for k, dimension in ((2**20, 4), (10**10, 10)):
        width = Q(1, 4 * k * k)
        eta = Q(1, 1000 * dimension)
        epsilon = min(eta / 100, width / 10)

        def label(y):
            return floor((centered(y) + Q(1, 2)) / width)

        def truncated(y):
            return label(y) if rho(y) >= eta else None

        require(label(Q(1, 2)) == 0, "cut must belong to interval starting at -1/2")
        require(label(Q(0)) == 2 * k * k, "zero must belong to its right interval")
        for orientation in (-1, 1):
            boundary = Q(1, 2) + orientation * eta
            require(rho(boundary) == eta, "threshold is not exact")
            require(truncated(boundary) == label(boundary), "threshold equality discarded")
            require(truncated(Q(1, 2) + orientation * (eta - epsilon)) is None,
                    "strictly excluded point recorded")
            require(truncated(Q(1, 2) + orientation * (eta + epsilon)) is not None,
                    "regular point discarded")
            if k == 10**10:
                quotient = (centered(boundary) + Q(1, 2)) / width
                require(quotient.denominator == 1, "intended coincident endpoint missing")
                require(label(boundary + epsilon) == label(boundary),
                        "half-open endpoint assigned to wrong side")
                require(label(boundary - epsilon) != label(boundary),
                        "left-neighbor endpoint test failed")
            tested += 3
    return {"threshold_tests": tested, "coincident_mesh_threshold_points": 2}


def dilation(cutoff, maximum_period):
    result = 1
    for prime in range(2, cutoff + 1):
        if any(prime % divisor == 0 for divisor in range(2, prime)):
            continue
        power = prime
        while power * prime <= maximum_period:
            power *= prime
        result *= power
    return result


def replay_heavy_blocks():
    k, dimension, M = 2**20, 4, 1024
    H = Q(1, k * k)
    lam = dilation(dimension * dimension, 2 * M)
    Hx, width = H / lam, H / 4
    eta = Q(1, 1000 * dimension)
    require(k >= 64 * M and 4000 * dimension * M < k**3, "parameter gate")
    require(H * Q(3, 4) / 4 <= width <= 2 * H * Q(1, 4),
            "uniform rational V does not satisfy the global width law")
    results = []
    for h in (17, 32):
        t = [1, 0, 0, 0]
        periods = [h // gcd(h, lam * coordinate) for coordinate in t]
        rotating = [index for index, period in enumerate(periods) if period != 1]
        require(all(period == 1 or period > dimension**2 for period in periods),
                "dilation gap")
        for direction in (-1, 1):
            u = direction * Hx / (4 * k)
            v = lam * u
            starts = [Q(1, 2 * lam) - Q(8, h) * (coordinate + u)
                      for coordinate in t]

            def xs(j):
                return [start + Q(j, h) * (coordinate + u)
                        for start, coordinate in zip(starts, t)]

            def ys(j):
                return [lam * value for value in xs(j)]

            def label(j):
                return (tuple(floor((value % 1) / Hx) for value in xs(j)),
                        tuple(floor((centered(value) + Q(1, 2)) / width)
                              for value in ys(j)))

            def regular(j):
                return all(rho(ys(j)[i]) >= eta for i in rotating)

            heavy = 8 if direction == 1 else 9
            returns = (k - 1 - heavy) // h
            multiplicity = returns + 1
            require(multiplicity > Q(k, M), "the specified index is not heavy")
            beta = label(heavy)
            for coordinate in range(dimension):
                x0 = xs(heavy)[coordinate] % 1
                y0 = centered(ys(heavy)[coordinate])
                xleft = beta[0][coordinate] * Hx
                yleft = -Q(1, 2) + beta[1][coordinate] * width
                for amount in (0, returns):
                    require(xleft <= x0 + amount * u < xleft + Hx,
                            "an endpoint return leaves its literal U interval")
                    require(yleft <= y0 + amount * v < yleft + width,
                            "an endpoint return leaves its literal V interval")
            # Convexity certifies every intervening return, not just these endpoints.
            require(abs(u) <= Hx and abs(v) <= H, "condition (ii)")
            labels = [label(j) for j in range(h)]
            regular_indices = [j for j in range(h) if regular(j)]
            require(2 * len(regular_indices) >= h, "regular-count condition (i)")
            require(len(set(labels)) == h, "residue separation")
            for index in range(dimension):
                if index not in rotating:
                    for j in regular_indices:
                        require(abs(v) <= width, "stationary condition (iii)")
            require(centered(ys(8)[1]) == -Q(1, 2), "exact stationary cut hit missing")
            if direction == 1:
                require(centered(ys(7)[1]) > 0 and centered(ys(9)[1]) < 0,
                        "positive cut crossing missing")
            else:
                require(centered(ys(7)[1]) < 0 and centered(ys(9)[1]) > 0,
                        "negative cut crossing missing")
            if rotating and direction == 1:
                require(not regular(heavy), "irregular heavy anchor case missing")
            results.append({
                "h": h, "drift_sign": direction, "rotating_coordinates": len(rotating),
                "regular_positions": len(regular_indices), "heavy_index": heavy,
                "heavy_index_is_regular": regular(heavy),
                "certified_heavy_multiplicity_lower_bound": multiplicity,
                "mesh": "uniform rational width-law test mesh, not the staged exponential mesh",
            })
    return results


def replay_transfer_threshold():
    cases = []
    H = Q(1, 8)
    for width in (Q(1), Q(1, 10**12), Q(1, 10**120)):
        radius0 = width / (2 * H)
        for mu in (Q(1, 16), Q(4, 33), Q(1, 8)):
            drift = mu * width
            radius1 = radius0 - drift
            target_width = H * radius1 / 4
            require(radius1 > 0, "sharpness example has nonpositive radius")
            require(width <= 2 * H * radius0, "anchor width condition")
            require(radius0 - radius1 == drift, "Lipschitz condition")
            require((target_width >= drift) == (mu <= Q(4, 33)),
                    "pointwise threshold computation")
            cases.append({"anchor_width": str(width), "relative_drift": str(mu),
                          "target_width_over_drift": str(target_width / drift),
                          "stationary_width_sufficient": target_width >= drift})
    return cases


def replay_compiler():
    result = load("lean_check.json")
    output = load("lean_verify_output.json")
    require(result["status"] == "success" and result["exit_code"] == 0, "Lean failed")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require(result["audit_exit_code"] == 0, "axiom audit failed")
    require(not result["environment_failure"], "unverified Lean environment")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "wrong Lean version")
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text(encoding="utf-8")
    require(sha256(source).hexdigest() == result["source_sha256"], "Lean source changed")
    require(sha256(fidelity.encode("utf-8")).hexdigest()
            == result["statement_fidelity_sha256"], "statement fidelity changed")
    proof_keys = ("source_sha256", "statement_fidelity_sha256", "status",
                  "exit_code", "proof_holes", "audit_exit_code")
    for key in proof_keys:
        require(output[key] == result[key], "compiler outputs describe different proofs")
    record = output["kernel"]["recorded"]
    require(record["subject"]["subject_id"] == "C160_FORMAL_CORE", "wrong formal claim")
    require(record["tier"] == "mechanical" and record["verdict"] == "supports",
            "missing actual mechanical support")
    archive = json.loads((ROOT / record["artifact"]).read_text(encoding="utf-8"))
    for key in proof_keys:
        require(archive["lean_check"][key] == result[key], "archived proof differs")
    require(archive["lean_source"]["text"] == source.decode("utf-8"), "archived source differs")
    require(archive["statement_fidelity"]["text"] == fidelity, "archived fidelity differs")
    return {"claim": "C160_FORMAL_CORE", "lean_version": "4.31.0", "exit_code": 0,
            "proof_holes": [], "certificate": record["artifact"],
            "coverage": "the universal declarations specified in statement_fidelity.md",
            "full_counting_theorem_formalized": False}


def build_certificate():
    require(2 * 16004**2 + 1 == 512256033, "scalar coefficient")
    require(801**3 == 513922401 > 512256033, "absolute entropy constant")
    return {
        "schema_version": 1,
        "claim": "C160_CORE",
        "mathematical_result": "proved verification theorem and structural generalization",
        "independent_review": "pending",
        "novelty": "not independently assessed",
        "scope": "count:local and longer-period heavy-block eligibility, not the main theorem",
        "absolute_counting_constant": 801,
        "sufficient_core_threshold_k": 2**20,
        "bound_before_absorption": "h^(D+1)*(2*(16004*D*h)^2+1)^(2*D)",
        "bound_after_absorption": "(801*D*h)^(6*D)",
        "stronger_stationary_budget": "(8+2*H)*abs(v_i) <= anchor_width",
        "uniform_sufficient_relative_drift": "4/33",
        "proof": "report.md, Theorems A-C and Sections 1-6",
        "jacobian": replay_lp(),
        "planar_regressions": replay_planar_faces(),
        "range_regressions": replay_ranges(),
        "threshold_regressions": replay_thresholds(),
        "heavy_block_regressions": replay_heavy_blocks(),
        "pointwise_transfer_regressions": replay_transfer_threshold(),
        "formal": replay_compiler(),
        "regression_limit": "Finite regressions are not the proof of the unbounded theorem.",
        "manuscript_refutation_found": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--compile", action="store_true",
                        help="also rerun the recorded real Lean compiler, without changing the ledger")
    args = parser.parse_args()
    if args.compile:
        compiler = load("lean_check.json")
        subprocess.run(compiler["command"], cwd=compiler["cwd"], check=True)
    actual = build_certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(actual, indent=2) + "\n", encoding="utf-8")
    else:
        require(json.loads(path.read_text(encoding="utf-8")) == actual,
                "the exact certificate differs from independent replay")
    print(json.dumps({
        "ok": True, "claim": "C160_CORE", "absolute_constant": 801,
        "heavy_block_cases": len(actual["heavy_block_regressions"]),
        "lean_exit_code": actual["formal"]["exit_code"],
        "independent_review": "pending",
    }))


if __name__ == "__main__":
    main()
