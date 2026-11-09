#!/usr/bin/env python3
from collections import Counter
from fractions import Fraction as Q
from itertools import product
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
CENTER = Q(5, 12)
SIGMA = Q(7, 8)
ETA = Q(1, 1000)
DELTA = Q(1, 35)
KAPPA = Q(1, 10000)
WIDTH = Q(1, 1000000)
TARGET = Q(19, 15) - KAPPA
S0 = Q(3831, 4791)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def d(sigma):
    return 3 * (1 - sigma) / (
        2 * sigma if sigma <= SIGMA else 10 * sigma - 7
    )


def e4(sigma):
    return 12 * (1 - sigma) / (4 * sigma - 1)


def f2(theta, sigma, a, b, c):
    return theta + 2 * sigma - 1 + (1 - theta) * c * (1 - sigma) / (
        a * sigma + b
    )


def f4(theta, sigma):
    return theta + 4 * sigma - 3 + (1 - theta) * e4(sigma)


def f6(theta, sigma, delta):
    return theta + 6 * sigma - 5 + (1 - theta) * (
        2 * d(sigma) + e4(sigma) - delta
    )


def check_cover():
    left, right = SIGMA - ETA, SIGMA + ETA
    low, high = CENTER - WIDTH, CENTER + WIDTH
    tau_max, tau_min = 1 - low, 1 - high
    require(0 < WIDTH < Q(1, 420), "invalid length width")
    require(Q(29, 70) < low < high < Q(21, 50), "not inside reviewed band")
    require(d(SIGMA) == Q(3, 14) and e4(SIGMA) == Q(3, 5), "central inputs")
    require(2 * d(SIGMA) + e4(SIGMA) == Q(36, 35), "generic energy exponent")
    require(2 * d(SIGMA) + e4(SIGMA) - DELTA == 1, "saved energy exponent")
    for theta in (low, CENTER, high):
        require(f6(theta, SIGMA, DELTA) == Q(5, 4), "conditional central value")
    require(f6(CENTER, SIGMA, 0) == f4(CENTER, SIGMA) == Q(19, 15), "generic peak")
    require(
        f6(CENTER, left, 0) - f4(CENTER, left)
        == 2 * ((1 - CENTER) * d(left) - (1 - left)) > 0,
        "generic surviving-slice loss",
    )
    left_derivative_min = 6 - tau_max * (
        3 / left**2 + 36 / (4 * left - 1)**2
    )
    right_derivative_max = 6 - tau_min * (
        18 / (10 * right - 7)**2 + 36 / (4 * right - 1)**2
    )
    require(left_derivative_min > 0, "sixth budget not increasing on left")
    require(right_derivative_max < 0, "sixth budget not decreasing on right")
    require(TARGET > Q(5, 4), "no new-neighborhood buffer")

    curves = [
        ("Ingham", Q(1, 2), Q(7, 10), -1, 2, 3),
        ("Guth_Maynard", Q(7, 10), Q(13, 17), 5, 3, 15),
        ("Ivic_low", Q(13, 17), Q(25, 32), 5, -1, 6),
        ("A2", Q(25, 32), Q(11, 14), 0, 1, 2),
        ("A9", Q(11, 14), S0, 7, -1, 9),
    ]
    low_maxima = []
    for name, a_left, a_right, a, b, c in curves:
        require(a * a_left + b > 0 and a * a_right + b > 0, name + " denominator")
        require(c * (1 - a_left) / (a * a_left + b) <= 1, name + " theta direction")
        if a < 0:
            require(
                2 - tau_max * c * (a + b) / (a * a_right + b)**2 > 0,
                name + " sigma direction",
            )
        else:
            require(a * (a + b) >= 0, name + " sigma convexity")
        maximum = max(
            f2(high, a_left, a, b, c),
            f2(high, a_right, a, b, c),
        )
        require(maximum < TARGET, name + " misses conditional target")
        low_maxima.append({"curve": name, "maximum": maximum})
    fourth_corners = [
        f4(theta, sigma) for theta, sigma in product((low, high), (S0, left))
    ]
    require(max(fourth_corners) < TARGET, "outside-neighborhood fourth budget")
    removal_margin = (1 - Q(279, 314)) * (
        1 - tau_max * 3 / (10 * right - 7)
    )
    require(removal_margin > 0, "high-real-part removal fails")

    known_gap_lower = 2 * (1 - right) + tau_max * (d(right) - e4(left))
    new_gap_upper = 2 * (tau_max * d(left) - (1 - right)) - tau_min * DELTA
    require(known_gap_lower > Q(1, 100), "fourth moment not the reviewed minimum")
    require(new_gap_upper < -Q(1, 100), "sixth estimate does not improve fourth")
    return {
        "conditional_hypothesis": {
            "sixth_energy_saving": DELTA,
            "real_part_radius": ETA,
            "proved_unconditionally": False,
        },
        "conditional_kappa": KAPPA,
        "conditional_width": WIDTH,
        "conditional_target": TARGET,
        "central_generic_budget": Q(19, 15),
        "new_neighborhood_maximum": Q(5, 4),
        "left_derivative_minimum": left_derivative_min,
        "right_derivative_maximum": right_derivative_max,
        "low_slice_maxima": low_maxima,
        "fourth_rectangle_maximum": max(fourth_corners),
        "fourth_rectangle_target_buffer": TARGET - max(fourth_corners),
        "high_slice_removal_margin": removal_margin,
        "known_second_minus_fourth_lower_bound": known_gap_lower,
        "new_sixth_minus_fourth_upper_bound": new_gap_upper,
        "remaining_high_slices": "Reused reviewed removal on the larger theta band; no unchanged replay.",
        "coverage_method": "Exact interval monotonicity, convexity and rational endpoints; not sampling.",
    }


def sums(values, order):
    counts = Counter({0: 1})
    for _ in range(order):
        next_counts = Counter()
        for total, count in counts.items():
            for value in values:
                next_counts[total + value] += count
        counts = next_counts
    require(sum(counts.values()) == len(values)**order, "lost ordered multiplicity")
    return counts


def energy(values, order):
    return sum(count * count for count in sums(values, order).values())


def sidon_values(p):
    return [2 * p * i + i * i % p for i in range(p)]


def interval_sixth(length):
    return (11 * length**5 + 5 * length**3 + 4 * length) // 20


def check_models():
    checks = []
    for p in (3, 5, 7, 11):
        values = sidon_values(p)
        fourth, sixth = energy(values, 2), energy(values, 3)
        require(fourth == 2 * p*p - p, "Sidon formula")
        require(Q(p**4, 6) <= sixth <= 2 * p**4, "Sidon triple-energy bounds")
        checks.append({"p": p, "fourth": fourth, "sixth": sixth})
    for length in range(1, 10):
        interval = list(range(length))
        require(energy(interval, 2) == (2 * length**3 + length) // 3, "interval fourth formula")
        require(energy(interval, 3) == interval_sixth(length), "interval sixth formula")
    for p, length in ((3, 2), (3, 7), (5, 3)):
        values = sidon_values(p)
        base = 8 * p*p
        digital = [base * a + b for a in range(length) for b in values]
        for order in (2, 3):
            require(
                energy(digital, order)
                == energy(list(range(length)), order) * energy(values, order),
                "digital no-carry factorization",
            )
    repeated = [0, 0, 2]
    require(energy(repeated, 2) == 33 and energy(repeated, 3) == 245, "repeated-index convention")
    p = 3
    values = sidon_values(p)
    length = p**4
    digital = [8 * p*p * a + b for a in range(length) for b in values]
    lower, upper = 0, p**24
    while lower + 1 < upper:
        middle = (lower + upper) // 2
        if 8 * middle**3 <= p**70:
            lower = middle
        else:
            upper = middle
    shift = lower
    require(8 * shift**3 <= p**70 < 8 * (shift + 1)**3, "incorrect exact height shift")
    positive = [shift + 2 * a for a in digital]
    symmetric = positive + [-a for a in positive]
    require(len(set(symmetric)) == 2 * p**5, "symmetric set is not distinct")
    require(27 * min(positive)**3 >= p**70, "ordinate below T/3")
    require(max(positive)**3 <= p**70, "ordinate above T")
    ordered = sorted(symmetric)
    require(min(b - a for a, b in zip(ordered, ordered[1:])) >= 2, "unit-interval spacing")
    fourth = energy(symmetric, 2)
    sixth = energy(symmetric, 3)
    require(Q(2 * p**14, 3) <= fourth <= 32 * p**14, "symmetric fourth bounds")
    require(Q(p**24, 18) <= sixth <= 128 * p**24, "symmetric sixth bounds")
    profile = sums(symmetric, 3)
    near_sixth = sum(
        count * sum(profile[total + offset] for offset in (-1, 0, 1))
        for total, count in profile.items()
    )
    require(near_sixth == sixth, "tolerance-one/equality mismatch")
    require(Q(5) / Q(70, 3) == Q(3, 14), "density power translation")
    require(Q(14) / Q(70, 3) == Q(3, 5), "fourth power translation")
    require(Q(24) / Q(70, 3) == Q(36, 35), "sixth power translation")
    return {
        "sidon_instances": checks,
        "symmetric_p3": {
            "cardinality": len(symmetric),
            "exact_height_shift": shift,
            "height_cubed": p**70,
            "fourth": fourth,
            "sixth": sixth,
            "ratio_to_D_squared_E4": Q(sixth, len(symmetric)**2 * fourth),
        },
        "family_exponents": [Q(3, 14), Q(3, 5), Q(36, 35)],
        "scope": "Exact finite replay of an elementary asymptotic generic-data construction; not zeta zeros.",
    }


def check_jacobian():
    contract = json.loads((HERE / "jacobian-contract.json").read_text())
    payload = json.loads((HERE / "jacobian-payload.json").read_text())
    response = json.loads((HERE / "jacobian-output.json").read_text())
    status = json.loads((HERE / "jacobian-execution-status.json").read_text())
    operation = "additive.ordered_difference_profile.compute"
    require(status["adapter_exit_status"] == 0, "Jacobian adapter failed")
    require(not status["timeout"] and status["output_complete"], "Jacobian incomplete")
    require(response["tool"] == "math.run", "not an execution")
    require(response["request"]["operation_id"] == operation, "operation mismatch")
    require(response["request"]["payload"] == payload, "payload mismatch")
    require(response["result"]["operation_id"] == operation, "result operation mismatch")
    require(response["server"] == contract["server"], "server changed")
    require(response["protocol_version"] == contract["protocol_version"], "protocol changed")
    require(response["transport"] == contract["transport"], "transport changed")
    output = response["result"]["output"]
    values = sidon_values(11)
    require(
        payload["vectors"]["vectors"]
        == [{"coordinates": [str(value)]} for value in values],
        "wrong mathematical payload",
    )
    require(output["vectors"] == payload["vectors"], "source vectors changed")
    require(output["dimension"] == 1 and output["set_size"] == 11, "output shape")
    require(output["total_ordered_pairs"] == output["support_size"] == 110, "lost pairs")
    require(output["max_multiplicity"] == 1, "Sidon collision")
    require(output["has_repeated_difference"] is False, "repeated difference")
    expected = {}
    for i, a in enumerate(values):
        for j, b in enumerate(values):
            if i != j:
                expected[a - b] = [(i, j)]
    actual = {}
    for entry in output["entries"]:
        difference = int(entry["difference"]["coordinates"][0])
        require(difference not in actual, "duplicate profile entry")
        pairs = sorted((pair["left_index"], pair["right_index"]) for pair in entry["pairs"])
        require(entry["multiplicity"] == len(pairs), "entry multiplicity")
        actual[difference] = pairs
    require(actual == expected, "independent ordered-difference replay disagrees")
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_status": status["adapter_exit_status"],
        "replayed_ordered_pairs": 110,
        "finite_fourth_energy": 231,
        "scope": "Finite B_11 Sidon check only, not a zeta-energy certificate.",
    }


def encode(value):
    if isinstance(value, Q):
        return str(value)
    raise TypeError(type(value).__name__)


if __name__ == "__main__":
    result = {
        "conditional_cover": check_cover(),
        "generic_models": check_models(),
        "jacobian_replay": check_jacobian(),
        "classification": "Exact arithmetic and construction replay; analytic arguments need independent review.",
        "new_unconditional_sixth_energy_saving_proved": False,
        "unconditional_window_improvement_proved": False,
        "publishable_result_certified": False,
    }
    print(json.dumps(result, indent=2, default=encode))
