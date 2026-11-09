#!/usr/bin/env python3
"""Replay a universal rational proof, without a solver or parameter search."""

import json
from fractions import Fraction as F
from pathlib import Path
import sys
from typing import NamedTuple


VARIABLES = ("a", "c", "z", "b", "y", "H", "d", "i", "rho", "t", "constant")


class Row(NamedTuple):
    coefficients: tuple
    strict: bool


def row(strict=False, **coefficients):
    unknown = set(coefficients) - set(VARIABLES)
    if unknown:
        raise ValueError(f"Unknown coordinates: {sorted(unknown)}")
    return Row(tuple(F(coefficients.get(v, 0)) for v in VARIABLES), strict)


BASE = {
    "unit": row(constant=1),
    **{f"nonnegative_{v}": row(**{v: 1}) for v in ("a", "c", "z", "b", "y", "H")},
    "normalization_positive": row(z=1, c=1, constant=-1),
    "normalization_negative": row(z=-1, c=-1, constant=1),
    "delta_positive": row(d=100000, a=-1, b=-1, y=-1, H=-1),
    "delta_negative": row(d=-100000, a=1, b=1, y=1, H=1),
    "near": row(True, z=1, d=1, a=-2, H="-1/2", y=-2),
    "unsafe_first": row(True, b=1, H="-2/3", z="-1/6", d="1/3"),
    "unsafe_second": row(True, H=1, y=2, z="-1/2", d=1, b=-1),
}

ENERGY = {
    "energy_low": row(True, H="1/2", a=-1, d=1, b=-1),
    "energy_high": row(True, H=1, c=-1, a=-1, d=1, b=-1),
}
ENERGY_RELAXED = row(True, H=1, a=-1, d=1, b=-1)

COMMON = {
    "delta_nonnegative": row(d=1),
    "delta_sharp": row(True, z=4, d=-99995),
    "z_positive": row(True, z=1),
    "delta_small": row(True, z="1/1000", d=-1),
}

HIGH = {
    "H_lower": row(True, H=1, z="-62/125", a=-3, c=-3),
    "actual_margin": row(True, z="753/1000", a="-7/2", c="-3/2", y=-2),
    "z_stage_one": row(True, z=1, constant="-500/751"),
    "y_upper": row(True, z="377/1000", a="-7/4", c="-3/4", y=-1),
    "actual_receiver": row(True, z=1, y=-1, constant="-623/1000"),
    "actual_source": row(True, a=-1, y=-1, constant="377/1000"),
    "stable_far": row(True, H="1/2", y=1, z="1/500", b=-1),
    "middle": row(True, y=2, H="-1/3", z="-41/125"),
    "H_upper": row(True, z="2019/2500", H=-1),
    "sum_small": row(True, z="21/200", a=-1, c=-1),
    "z_high": row(True, z=1, constant="-200/221"),
    "p_high": row(True, a=-1, constant="21/200"),
    "y_lower": row(True, y=1, z="-19/100"),
    "momentum_receiver": row(True, z=1, constant="-7/10"),
    "momentum_source": row(True, a=-1, constant="3/10"),
    "window_receiver_lower": row(True, y=1, z="-4/25"),
    "window_source_lower": row(True, y=1, a="4/25", constant="-4/25"),
    "window_receiver_upper": row(True, z="49/100", y=-1),
    "window_source_upper": row(True, a="-49/100", y=-1, constant="49/100"),
    "improved_far": row(True, H="1/2", y="29/50", d=1, b=-1),
    "beta_lower": row(True, y="29/25", H="-1/3", z="-33/100"),
    "beta_upper": row(True, z="291/500", H="-29/100", y="-29/25"),
    "H_final": row(True, z="378/935", H=-1),
    "contradiction": row(True),
}

ACTIVATIONS = {
    "stable_far": ["actual_receiver", "actual_source"],
    "improved_far": [
        "momentum_receiver",
        "momentum_source",
        "window_receiver_lower",
        "window_source_lower",
        "window_receiver_upper",
        "window_source_upper",
    ],
}

MAXIMUM_BASE = {
    "interval_upper": row(c=-2, i=-1),
    "H_below_split": row(c=2, H=-1),
    "H_above_split": row(H=1, c=-2),
    "rho_ge_c": row(rho=1, c=-1),
    "t_nonnegative": row(t=1),
}

MAXIMUM_TARGETS = {
    "energy_low_max_equals_minus_H": row(H=-1, i=-1),
    "energy_high_I_branch": row(c=-2, i=-1),
    "energy_high_h_branch": row(H=1, c=-2),
    "occupation_constant_plateau": row(rho=2, c=-2, t=2),
    "occupation_I_branch": row(c=-2, i=-1),
    "occupation_h_branch": row(H=1, c=-2),
}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def check_combination(name, target, weights, known):
    require(isinstance(weights, dict) and weights, f"{name}: missing multipliers")
    result = [F(0)] * len(VARIABLES)
    strict = False
    for source, value in weights.items():
        require(source in known, f"{name}: unknown or premature source {source}")
        require(isinstance(value, str), f"{name}: multipliers must be rational strings")
        weight = F(value)
        require(str(weight) == value and weight > 0, f"{name}: noncanonical/nonpositive weight")
        source_row = known[source]
        result = [x + weight * y for x, y in zip(result, source_row.coefficients)]
        strict |= source_row.strict
    require(tuple(result) == target.coefficients, f"{name}: rational identity does not match")
    require(not target.strict or strict, f"{name}: strict conclusion has no strict premise")
    return target


def check_sequence(proofs, targets, known):
    require(set(proofs) == set(targets), "Proof steps are missing or unexpected")
    for name, target in targets.items():
        known[name] = check_combination(name, target, proofs[name], known)


def verify(certificate):
    require(certificate["claim"] == "C_SEL362_EXPONENTS", "Wrong claim")
    require(certificate["epsilon"] == "1/100000", "Wrong epsilon")
    require(certificate["beta"] == "29/25", "Wrong beta")
    require(certificate["variables"] == list(VARIABLES), "Wrong coordinates")
    require(certificate["activations"] == ACTIVATIONS, "Incomplete occupation activation")
    require(set(certificate["energy_relaxations"]) == set(ENERGY), "Missing energy branch")

    for branch, source in ENERGY.items():
        check_combination(
            branch, ENERGY_RELAXED, certificate["energy_relaxations"][branch],
            {**BASE, branch: source},
        )

    common = {**BASE, "energy_relaxed": ENERGY_RELAXED}
    check_sequence(certificate["common"], COMMON, common)
    check_combination(
        "low_energy_contradiction", row(True),
        certificate["low_energy_contradiction"],
        {**common, "energy_low": ENERGY["energy_low"]},
    )

    high = {**common, "energy_high": ENERGY["energy_high"]}
    require(
        set(certificate["high"]) == set(HIGH) - set(ACTIVATIONS),
        "High-branch proof steps are missing or unexpected",
    )
    for name, target in HIGH.items():
        if name in ACTIVATIONS:
            require(
                all(premise in high for premise in ACTIVATIONS[name]),
                f"{name}: occupation bound activated before its window was proved",
            )
            if name == "stable_far":
                require(F(623, 1000) > F(3, 10), "Stable inclusion margin is insufficient")
            high[name] = target
        else:
            high[name] = check_combination(name, target, certificate["high"][name], high)

    require(set(certificate["maxima"]) == set(MAXIMUM_TARGETS), "Missing maximum branch")
    for name, target in MAXIMUM_TARGETS.items():
        permitted = {
            "energy_low_max_equals_minus_H": ("interval_upper", "H_below_split"),
            "energy_high_I_branch": ("interval_upper",),
            "energy_high_h_branch": ("H_above_split",),
            "occupation_constant_plateau": ("rho_ge_c", "t_nonnegative"),
            "occupation_I_branch": ("interval_upper",),
            "occupation_h_branch": ("H_above_split",),
        }[name]
        check_combination(
            name, target, certificate["maxima"][name],
            {key: MAXIMUM_BASE[key] for key in permitted},
        )

    require(2 * 2000**2 == 8000000, "Incorrect explicit exponential threshold")
    require(F(1, 2000) < F(500, 751000), "Absorption exponent is not uniform")
    require(F(29, 25) / 2 == F(29, 50), "Incorrect improved-occupation exponent")
    require(F(378, 935) < F(62, 125), "Final contradiction has no positive gap")
    return {
        "claim": certificate["claim"],
        "result": "VERIFIED_UNIVERSAL_RATIONAL_IMPLICATION",
        "energy_branches": 2,
        "occupation_maximum_branches": 6,
        "conditional_occupation_activations": 2,
        "strict_rational_contradictions": 2,
        "finite_parameter_search": False,
        "real_power_and_uniform_threshold_proof": "REPORT.md; requires human review",
        "analytic_occupation_and_PDE_inputs": "not verified",
        "independent_review": "pending",
    }


def main():
    require(len(sys.argv) <= 2, "Usage: verify.py [exact_certificate.json]")
    path = Path(sys.argv[1]) if len(sys.argv) == 2 else Path(__file__).with_name("exact_certificate.json")
    certificate = json.loads(path.read_text())
    print(json.dumps(verify(certificate), sort_keys=True))


if __name__ == "__main__":
    main()
