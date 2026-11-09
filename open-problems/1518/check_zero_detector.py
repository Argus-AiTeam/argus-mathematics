#!/usr/bin/env python3
from fractions import Fraction as Q
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SIGMA = Q(7, 8)
ETA = Q(1, 1000)
LOW, HIGH = SIGMA - ETA, SIGMA + ETA
MOLLIFIER = Q(1, 1000)
CUTOFF = Q(5, 12)
SUBCONVEX = Q(13, 84)
DELTA = Q(1, 200)
WIDTH = Q(1, 1000000)
KAPPA = Q(1, 10000)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def d(sigma):
    return 3 * (1 - sigma) / (
        2 * sigma if sigma <= SIGMA else 10 * sigma - 7
    )


def e4(sigma):
    return 12 * (1 - sigma) / (4 * sigma - 1)


def vector_add(a, b):
    return tuple(x + y for x, y in zip(a, b))


def vector_scale(coefficient, vector):
    return tuple(coefficient * value for value in vector)


def gaps():
    a_branches = [
        (Q(4), Q(0), Q(0), Q(1), Q(0)),
        (Q(0), Q(1), Q(0), Q(2), Q(0)),
        (Q(1), Q(3, 4), Q(1, 2), Q(1), Q(0)),
    ]
    q_offsets = [
        (Q(3), Q(0), Q(0), Q(1, 2), Q(-2)),
        (Q(0), Q(0), Q(0), Q(2), Q(-4)),
        (Q(6, 5), Q(0), Q(2, 5), Q(4, 5), Q(-16, 5)),
    ]
    baseline = (Q(2), Q(1), Q(0), Q(0), Q(0))
    result = []
    for a in a_branches:
        for coefficient, offset in zip((Q(1, 2), Q(1), Q(4, 5)), q_offsets):
            q = vector_add(vector_scale(coefficient, a), offset)
            result.append(vector_add(baseline, vector_scale(Q(-1), q)))
    expected = [
        (Q(-3), Q(1), Q(0), Q(-1), Q(2)),
        (Q(-2), Q(1), Q(0), Q(-3), Q(4)),
        (Q(-12, 5), Q(1), Q(-2, 5), Q(-8, 5), Q(16, 5)),
        (Q(-1), Q(1, 2), Q(0), Q(-3, 2), Q(2)),
        (Q(2), Q(0), Q(0), Q(-4), Q(4)),
        (Q(4, 5), Q(1, 5), Q(-2, 5), Q(-12, 5), Q(16, 5)),
        (Q(-3, 2), Q(5, 8), Q(-1, 4), Q(-1), Q(2)),
        (Q(1), Q(1, 4), Q(-1, 2), Q(-3), Q(4)),
        (Q(0), Q(2, 5), Q(-4, 5), Q(-8, 5), Q(16, 5)),
    ]
    require(result == expected, "incorrect fifth/sixth-feedback exponent algebra")
    return result


def check_energy_gaps():
    require(d(LOW) >= d(SIGMA) >= d(HIGH), "density endpoints")
    require(e4(LOW) >= e4(SIGMA) >= e4(HIGH), "fourth-energy endpoints")
    lower_bounds = []
    for index, (cd, ce, constant, clambda, csigma_lambda) in enumerate(gaps()):
        if index == 4:
            require(3 / (10 * HIGH - 7) > Q(5, 3), "correlated density brace")
            bound = 2 * (1 - HIGH) * (3 / (10 * HIGH - 7) - Q(5, 3))
            require(bound == Q(31, 3300), "correlated minimum")
        else:
            require(clambda + csigma_lambda * LOW > 0, "lambda monotonicity")
            require(ce >= 0 and csigma_lambda > 0, "sigma/energy endpoint direction")
            density = d(HIGH) if cd >= 0 else d(LOW)
            bound = (
                cd * density
                + ce * e4(HIGH)
                + constant
                + (clambda + csigma_lambda * LOW) / 2
            )
        require(bound > DELTA, "a sixth-energy branch loses the fixed saving")
        lower_bounds.append(bound)
    require(min(lower_bounds) == Q(31, 3300), "wrong overall energy margin")
    return {
        "gap_coordinate_order": ["d", "e4", "constant", "lambda", "sigma_times_lambda"],
        "nine_gap_vectors": gaps(),
        "nine_uniform_gap_lower_bounds": lower_bounds,
        "minimum_gap": min(lower_bounds),
        "saving": DELTA,
        "residual_energy_buffer": min(lower_bounds) - DELTA,
        "method": "Exact affine identities and correlated interval bounds, not sampled cells.",
    }


def check_powering():
    cells = []
    for k in range(2, 501):
        left = max(MOLLIFIER, Q(1, 2 * k))
        right = min(CUTOFF, Q(1, 2 * (k - 1)))
        if left <= right:
            require(k * left >= Q(1, 2), "powered polynomial too short")
            require(k * right <= Q(5, 6), "powered polynomial too long")
            cells.append((left, right, k))
    cells.sort()
    require(cells[0][0] == MOLLIFIER and cells[-1][1] == CUTOFF, "uncovered length endpoints")
    covered = MOLLIFIER
    for left, right, _ in cells:
        require(left <= covered, "uncovered original detector length")
        covered = max(covered, right)
    require(covered == CUTOFF, "incomplete detector length cover")
    require(max(k for _, _, k in cells) == 500, "unbounded powering count")
    return {
        "original_length_interval": [MOLLIFIER, CUTOFF],
        "powered_length_interval": [Q(1, 2), Q(5, 6)],
        "maximum_power": 500,
        "exact_cover_cell_count": len(cells),
        "coverage": "Closed rational intervals; logarithmic endpoint perturbations use the residual buffer.",
    }


def check_detector_and_window():
    detector_margin = CUTOFF * (LOW - Q(1, 2)) - SUBCONVEX - MOLLIFIER / 2
    require(detector_margin == Q(1, 1750), "Type-II suppression exponent")
    require(detector_margin > Q(1, 3500), "no fixed detector source-epsilon buffer")
    central_e6 = 2 * d(SIGMA) + e4(SIGMA) - DELTA
    require(central_e6 == Q(1433, 1400), "new central energy exponent")
    central_max = Q(19, 15) - Q(7, 12) * DELTA + WIDTH * (central_e6 - 1)
    target = Q(19, 15) - KAPPA
    require(central_max < target, "new sixth-energy input does not instantiate the window")
    theta_low, theta_high = Q(5, 12) - WIDTH, Q(5, 12) + WIDTH
    tau_max, tau_min = 1 - theta_low, 1 - theta_high
    left_derivative_min = 6 - tau_max * (3 / LOW**2 + 36 / (4 * LOW - 1)**2)
    right_derivative_max = 6 - tau_min * (18 / (10 * HIGH - 7)**2 + 36 / (4 * HIGH - 1)**2)
    require(left_derivative_min > 0 and right_derivative_max < 0, "central location changed")
    comparison_loss = 2 * (1 - LOW) * max(
        Q(0), tau_max * 3 / (2 * LOW) - 1
    ) - tau_min * DELTA
    require(comparison_loss < -Q(1, 500), "no pointwise gain over reviewed fourth energy")
    require(0 < WIDTH < Q(1, 420), "operator width condition")
    return {
        "mollifier_exponent": MOLLIFIER,
        "short_cutoff_exponent": CUTOFF,
        "subconvex_exponent": SUBCONVEX,
        "Type_II_elimination_margin": detector_margin,
        "real_part_radius": ETA,
        "sixth_energy_saving": DELTA,
        "central_saved_energy_exponent": central_e6,
        "new_neighborhood_pair_budget": central_max,
        "window_target": target,
        "window_kappa": KAPPA,
        "window_width": WIDTH,
        "window_buffer": target - central_max,
        "left_derivative_minimum": left_derivative_min,
        "right_derivative_maximum": right_derivative_max,
        "sixth_minus_fourth_uniform_upper_bound": comparison_loss,
        "outside_new_neighborhood": "Unchanged independently reviewed cover; not replayed.",
    }


def check_source_comparison():
    require(Q(5, 6) < LOW, "TTY energy clause could intersect the new neighborhood")
    require(Q(3, 4) < LOW < HIGH < Q(14, 15), "TTY density row range")
    require(Q(7, 9) < LOW, "Chen new-density proof range")
    require(108 - 122 * HIGH > 0, "TTY first left-density comparison")
    require(31 - 34 * HIGH > 0, "TTY first right-density comparison")
    require(1 - HIGH > 0 and 21 * SIGMA - 18 > 0, "Chen classical comparison")
    require(5 * LOW - 3 > 0 and 37 * SIGMA - 31 > 0, "Chen density theorem comparison")
    require(Q(7, 3) > 3 / (2 * LOW), "Chen uniform density comparison")
    others = [
        Q(11, 48),
        Q(4, 15),
        Q(7, 24),
        Q(3, 13),
    ]
    require(all(value > d(SIGMA) for value in others), "stronger central density row omitted")
    return {
        "reviewed_central_density": d(SIGMA),
        "reviewed_central_fourth_energy": e4(SIGMA),
        "other_applicable_central_density_exponents": others,
        "TTY_Theorem_64_maximum_sigma": Q(5, 6),
        "comparison_method": "Positive cross-multiplied affine differences on the full new neighborhood.",
        "scope": "Applicability of the two inspected additional sources, not exhaustive literature optimality.",
    }


def rational(value):
    require(set(value) == {"num", "den"}, "noncanonical rational fields")
    result = Q(int(value["num"]), int(value["den"]))
    require(value == {"num": str(result.numerator), "den": str(result.denominator)}, "unreduced rational")
    return result


def check_typed_lp():
    payload = json.loads((HERE / "jacobian-detector-standard-payload.json").read_text())
    contract = json.loads((HERE / "jacobian-detector-standard-contract.json").read_text())
    response = json.loads((HERE / "jacobian-detector-standard-output.json").read_text())
    status = json.loads((HERE / "jacobian-detector-standard-execution-status.json").read_text())
    operation = "optimization.linear.rational_optimum.compute"
    require(status["adapter_exit_status"] == 0 and not status["timeout"], "adapter failure is not evidence")
    require(status["output_complete"], "incomplete LP output")
    require(response["tool"] == "math.run", "not an execution")
    require(response["request"]["operation_id"] == operation, "wrong operation")
    require(response["request"]["payload"] == payload, "payload changed")
    require(response["result"]["operation_id"] == operation, "wrong result operation")
    require(response["server"] == contract["server"], "server changed")
    require(response["protocol_version"] == contract["protocol_version"], "protocol changed")
    require(response["transport"] == contract["transport"], "transport changed")
    output = response["result"]["output"]
    program = payload["program"]
    require(output["program"] == program and output["status"] == "OPTIMAL", "no source-bound optimum")
    objective = [rational(v) for v in program["objective"]]
    require(objective == [-1, 0, 0], "wrong mathematical objective")
    rows = [[rational(v) for v in row] for row in program["coefficients"]]
    rhs = [rational(v) for v in program["rhs"]]
    require(rows == [[1, 1, 0], [1, 0, 1]], "wrong LP mathematical rows")
    require(
        rhs == [
            CUTOFF * (LOW - Q(1, 2)) - SUBCONVEX - MOLLIFIER / 2,
            2 * (1 - HIGH) * (3 / (10 * HIGH - 7) - 4 * CUTOFF) - DELTA,
        ],
        "wrong LP mathematical constants",
    )
    primal = [rational(v) for v in output["primal_candidate"]]
    dual = [rational(v) for v in output["dual_candidate"]]
    require(len(primal) == 3 and len(dual) == 2, "LP output shape")
    require(min(primal) >= 0 and primal[0] == Q(1, 1750), "primal infeasible")
    residuals = [
        sum(a * x for a, x in zip(row, primal)) - bound
        for row, bound in zip(rows, rhs)
    ]
    require(residuals == [0, 0], "primal equalities fail")
    slacks = [
        c - sum(row[j] * y for row, y in zip(rows, dual))
        for j, c in enumerate(objective)
    ]
    require(min(slacks) >= 0, "dual infeasible")
    primal_value = sum(c * x for c, x in zip(objective, primal))
    dual_value = sum(b * y for b, y in zip(rhs, dual))
    require(primal_value == dual_value == -Q(1, 1750), "duality gap")
    require(residuals == [rational(v) for v in output["primal_residuals"]], "reported residuals")
    require(slacks == [rational(v) for v in output["dual_slacks"]], "reported dual slacks")
    require(rational(output["primal_objective"]) == primal_value, "reported primal objective")
    require(rational(output["dual_objective"]) == dual_value, "reported dual objective")
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_status": 0,
        "timeout": False,
        "optimal_joint_slack": -primal_value,
        "primal_and_dual_replayed": True,
        "prior_general_form_call": "Admission refused; its structured error is preserved and is not mathematical evidence.",
        "scope": "Exact parameter arithmetic only; not verification of the analytic proof.",
    }


def encode(value):
    if isinstance(value, Q):
        return str(value)
    raise TypeError(type(value).__name__)


if __name__ == "__main__":
    result = {
        "detector_and_window": check_detector_and_window(),
        "uniform_energy_gaps": check_energy_gaps(),
        "all_polynomial_length_cells": check_powering(),
        "additional_source_comparison": check_source_comparison(),
        "typed_Jacobian_parameter_replay": check_typed_lp(),
        "classification": "Exact arithmetic certificate for the new analytic proof; not a finite zero search.",
        "analytic_proof_independently_verified": False,
        "novelty_verified": False,
        "publishable_result_certified": False,
    }
    print(json.dumps(result, indent=2, default=encode))
