#!/usr/bin/env python3
"""Replay the exact quantitative parts of proof.md, not its entire prose proof."""

import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def read(name):
    return json.loads((ROOT / name).read_text())


def rational(value):
    result = Fraction(int(value["num"]), int(value["den"]))
    require(str(result.numerator) == value["num"], "noncanonical numerator")
    require(str(result.denominator) == value["den"], "noncanonical denominator")
    return result


def dot(left, right):
    return sum((a * b for a, b in zip(left, right, strict=True)), Fraction())


def replay_lean(certificate):
    info = certificate["lean"]
    archive = read(info["certificate"])
    result = read(info["result"])
    require(archive["subject"]["subject_id"] == info["claim"] == "C86_PACKING_CORE",
            "wrong formal claim; the full counting theorem is not formalized")
    require(archive["tier"] == "mechanical" and archive["verdict"] == "supports",
            "archive is not a supporting compiler certificate")
    require(archive["lean_check"] == result, "canonical compiler result changed")
    require(archive["lean_source"]["text"] == (ROOT / info["source"]).read_text(),
            "Lean source changed after the recorded compiler run")
    require(archive["statement_fidelity"]["text"] ==
            (ROOT / info["statement_fidelity"]).read_text(),
            "statement fidelity changed after the recorded compiler run")
    require(result["status"] == "success" and result["exit_code"] == 0,
            "Lean compilation did not succeed")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "Lean proof has holes or lacks a successful axiom audit")
    require(result["environment_failure"] == "", "Lean environment was unverified")
    require(f'Lean (version {info["compiler_version"]},' in
            result["tools"]["lean"]["version"], "wrong Lean compiler version")
    return {
        "claim": info["claim"],
        "compiler_version": info["compiler_version"],
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "audit_exit_code": result["audit_exit_code"],
        "source_and_fidelity_match_archive": True,
        "scope": info["scope"]
    }


def replay_lp(certificate):
    info = certificate["jacobian"]
    contract = read(info["contract"])
    output = read(info["output"])
    payload = read(info["payload"])
    require(contract["result"]["operation"]["operation_id"] == info["operation_id"],
            "wrong inspected operation")
    require(output["server"]["version"] == contract["server"]["version"],
            "Jacobian server versions differ")
    require(output["protocol_version"] == contract["protocol_version"],
            "Jacobian protocols differ")
    require(output["result"]["operation_id"] == info["operation_id"],
            "wrong executed operation")
    require(output["request"]["payload"] == payload, "wrong executed payload")
    require(read("jacobian_run_status.json")["process_exit_code"] == 0,
            "Jacobian adapter did not complete successfully")
    require(read(info["admission_status"])["process_exit_code"] == 2,
            "missing preserved admission-failure status")
    require(read(info["admission_error"])["error"]["data"]["code"] == "INVALID_REQUEST",
            "missing preserved typed admission error")
    result = output["result"]["output"]
    require(result["status"] == "OPTIMAL", "LP is not an exact optimal outcome")
    program = payload["program"]
    require(result["program"] == program, "typed output is not source-bound")
    require(program["objective"]["sense"] == "MINIMIZE", "unexpected LP sense")
    require([v["name"] for v in program["variables"]] ==
            ["other_residuals", "box_error"], "incorrect scalar normalization")
    require([rational(v) for v in program["objective"]["coefficients"]] ==
            [1, -1], "incorrect objective")
    require(program["constraints"] == [], "unexpected constraints")
    expected_bounds = [(Fraction(-1, 100), Fraction(1, 100)),
                       (Fraction(-1, 100), Fraction(1, 100))]
    for variable, expected in zip(program["variables"], expected_bounds, strict=True):
        bounds = tuple(None if variable[key] is None else rational(variable[key])
                       for key in ("lower_bound", "upper_bound"))
        require(bounds == expected, "incorrect error or dominant-residual bound")

    point = [rational(v) for v in result["primal_candidate"]]
    objective = [rational(v) for v in program["objective"]["coefficients"]]
    dual = [rational(v) for v in result["constraint_dual"]]
    lower = [rational(v) for v in result["lower_bound_dual"]]
    upper = [rational(v) for v in result["upper_bound_dual"]]
    stationarity = [Fraction() for _ in point]
    dual_value = Fraction()
    for constraint, multiplier in zip(program["constraints"], dual, strict=True):
        coefficients = [rational(v) for v in constraint["coefficients"]]
        rhs = rational(constraint["rhs"])
        value = dot(coefficients, point)
        relation = constraint["relation"]
        require({"LE": value <= rhs, "GE": value >= rhs, "EQ": value == rhs}[relation],
                "LP primal row failed")
        require(relation == "EQ" or (multiplier <= 0 if relation == "LE"
                                    else multiplier >= 0), "LP row dual sign failed")
        stationarity = [s + multiplier * a
                        for s, a in zip(stationarity, coefficients, strict=True)]
        dual_value += multiplier * rhs
    for i, variable in enumerate(program["variables"]):
        require(lower[i] >= 0 and upper[i] <= 0, "LP bound dual signs failed")
        for key, multiplier, is_lower in [
            ("lower_bound", lower[i], True), ("upper_bound", upper[i], False)
        ]:
            bound = variable[key]
            if bound is None:
                require(multiplier == 0, "dual weight on absent bound")
            else:
                bound = rational(bound)
                require(point[i] >= bound if is_lower else point[i] <= bound,
                        "LP primal bound failed")
                dual_value += multiplier * bound
        stationarity[i] += lower[i] + upper[i]
    require(stationarity == objective, "LP stationarity failed")
    primal_value = dot(objective, point)
    require(primal_value == dual_value == Fraction(info["expected_optimum"]),
            "primal/dual error endpoint is not exactly -1/50")
    require(1 + primal_value == Fraction(info["derived_endpoint"]) == Fraction(49, 50),
            "dominant-residual endpoint is not exactly 49/50")
    require(rational(result["primal_objective"]) == primal_value
            and rational(result["dual_objective"]) == dual_value,
            "typed objective does not replay")
    return {
        "operation_id": info["operation_id"],
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "status": result["status"],
        "replayed_optimum": str(primal_value),
        "derived_endpoint": str(1 + primal_value)
    }


def verify_constants(certificate):
    c, b, p = (certificate[key] for key in ("constants", "budgets", "density_powers"))
    require(c == {
        "reserve_exponent": 40, "bound_exponent": 160,
        "grid_reserve_exponent": 30, "grid_bound_exponent": 152,
        "gap_exponent": 32, "cover_exponent": 32,
        "combination_density_exponent": 14
    }, "theorem constants changed")
    n, h, e = b["index_interval"], b["growth_height"], b["scalar_interval"]
    require((n, h, e) == (33, 100, 17), "neighborhood constants changed")
    computed = {
        "local_index_raw": 36 * 2 * h * n + 72,
        "local_error_raw": 2 * 3 * 2 * h * e + 2,
        "anchor_index_raw": 2 * 2**18 + 12 * h * n,
        "anchor_error_raw": 2 * 2**15 + 2 * h * e,
        "within_index_raw": 24 * h * n,
        "within_error_raw": 4 * h * e,
        "cross_index_raw": 144 + 9 * 24 * h * n,
        "cross_error_raw": 9 * 4 * h * e
    }
    for name, value in computed.items():
        require(b[name] == value, f"incorrect {name}")
    require(b["local_index_raw"] < 2**b["local_index_power"], "local index")
    require(b["local_error_raw"] < 2**b["local_error_power"], "local error")
    require(b["anchor_index_raw"] < 2**20 < 2**c["grid_reserve_exponent"],
            "anchor shift reserve")
    require(b["anchor_error_raw"] < 2**17 < 2**c["grid_reserve_exponent"],
            "anchor scalar reserve")
    require(b["within_index_raw"] < 2**c["grid_reserve_exponent"],
            "within-translation shift reserve")
    require(b["within_error_raw"] < 2**c["grid_reserve_exponent"],
            "within-translation scalar reserve")
    require(b["cross_index_raw"] < 2**20 < 2**c["grid_reserve_exponent"],
            "cross-translation shift reserve")
    require(Fraction(3, 2**c["gap_exponent"]) < Fraction(1, 100),
            "other residuals too large")
    require(Fraction(b["cross_error_raw"], 2**c["gap_exponent"]) <
            Fraction(1, 100), "box error too large")
    require(Fraction(49, 50) > Fraction(1, 100)
            and Fraction(51, 50) < 100, "pure-shift forbidden interval")
    for excluded in range(4):
        coefficients = [i - excluded for i in range(4) if i != excluded]
        require(sum(abs(a) for a in coefficients) <= 9, "coefficient sum")
        for a in coefficients:
            require(6 % abs(a) == 0 and 36 % abs(a) == 0,
                    "nonintegral divided shift")
    require(Fraction(1, 4) - Fraction(100, 4096) > Fraction(1, 8),
            "graph averaging margin")
    require(Fraction(1, 8) * Fraction(1, 4096)**2 >= Fraction(1, 2**28),
            "four-path constant")
    require(8 <= 2**32 and 2**28 <= 2**32, "difference-cover constant")
    require(8 * 16**7 == 2**31, "slab-cover coefficient")
    require(Fraction(1, 512) * Fraction(1, 8) == Fraction(1, 2**12),
            "indexed-output lower coefficient")
    require(2**31 * 2**12 == 2**43 and 32**10 >= 2**43,
            "tenth-root coefficient")
    require(2**11 > 32 and 64 >= 34, "quartile and thinning margins")
    require(p == {"delta": 810, "alpha": 2, "kappa": 3,
                  "delta_tenth": 81, "final": 1, "manuscript_denominator": 2080},
            "density exponents changed")
    require(p["delta"] == 10 * p["delta_tenth"], "tenth-root substitution")
    require(p["kappa"] - p["alpha"] == p["final"], "uncovered exponent")
    require(p["alpha"] == 2 * p["final"], "nonfuture exponent")
    require(p["delta_tenth"] - 4 * p["alpha"] - 24 * p["kappa"] == p["final"],
            "future-combination exponent")
    require(5 + 6 * 4 == 29 and 4 * c["cover_exponent"] + 14 == 142,
            "L or constant exponent")
    require(18 + (4 * 3**4) * 2**142 < 2**c["grid_bound_exponent"],
            "final grid coefficient")
    require(c["grid_bound_exponent"] + 1 <= c["bound_exponent"],
            "ell relaxation factor")
    require(c["reserve_exponent"] - 2 >= c["grid_reserve_exponent"],
            "grid-relaxation reserves")
    require(Fraction(1, p["delta"]) > Fraction(1, p["manuscript_denominator"]),
            "new exponent does not improve the stated exponent")
    # For D=t+1, the exponential-growth comparison has positive coefficients.
    coefficients = [48 - 8, 2 * 48 - 8, 48]
    require(coefficients == [40, 88, 48] and all(a > 0 for a in coefficients),
            "universal small-growth exponent comparison")
    require(200 + 3 <= 256, "small-growth subdivision coefficient")
    return computed


def main():
    certificate = read("exact_certificate.json")
    require(certificate["claim"] == "C86_SPARSE_EXPLICIT", "wrong theorem claim")
    require(not certificate["main_operator_theorem_verified"],
            "certificate must not assert the main analytic theorem")
    budgets = verify_constants(certificate)
    jacobian = replay_lp(certificate)
    lean = replay_lean(certificate)
    print(json.dumps({
        "ok": True,
        "claim": certificate["claim"],
        "result_class": certificate["result_class"],
        "density_exponent": "1/810",
        "constants": {"C_res": "2^40", "C": "2^160"},
        "exact_budget_checks": budgets,
        "jacobian": jacobian,
        "lean": lean,
        "scope": "Quantitative identities and LP duality replay; the complete "
                 "universal proof is proof.md, with its packing core in Main.lean.",
        "independent_review": certificate["independent_review"]
    }, indent=2))


if __name__ == "__main__":
    main()
