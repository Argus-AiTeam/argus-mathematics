#!/usr/bin/env python3
"""Replay exact diagnostics of the uniform theorem proved in report.md."""

import argparse
import hashlib
import itertools
import json
from collections import defaultdict
from fractions import Fraction as F
from pathlib import Path


HERE = Path(__file__).resolve().parent
LABEL_MASS = (F(1, 2), F(1, 4), F(1, 8), F(1, 8))
WITNESS_MASS = (1 - F(1, 2**20), F(1, 2**20))
STATES = tuple(itertools.product(range(4), repeat=2))
RAW = {s: LABEL_MASS[s[0]] * LABEL_MASS[s[1]] for s in STATES}
HORIZON = 3


def rational(x):
    x = F(x)
    return f"{x.numerator}/{x.denominator}"


def hits(w, label):
    return w == 0 or label != 3


def reply(question, label):
    return (
        int(label == 3),
        label % 2,
        int(label >= 2),
        int(label == 2),
        0,
    )[question]


def trace(policy, state):
    q0, q1, q2, flip = policy
    r0 = reply(q0, state[0])
    b1 = r0 ^ flip
    r1 = reply(q1, state[b1])
    b2 = r0 ^ r1 ^ flip
    r2 = reply(q2, state[b2])
    return ((0, q0, r0), (b1, q1, r1), (b2, q2, r2))


def cylinder(prefix, block):
    return tuple(
        x for x in range(4)
        if all(reply(q, x) == answer for h, q, answer in prefix if h == block)
    )


def deviates(w, path):
    return w == 1 and path[0][2] == 0 and path[-1][2] == 1


def transcript_levels(paths):
    levels = []
    checked = 0
    for t in range(HORIZON + 1):
        groups = defaultdict(list)
        for state in STATES:
            groups[paths[state][:t]].append(state)
        info = {}
        for prefix, states in groups.items():
            cs = (cylinder(prefix, 0), cylinder(prefix, 1))
            assert set(states) == set(itertools.product(*cs)), "nonrectangular transcript"
            masses = tuple(sum(LABEL_MASS[x] for x in c) for c in cs)
            mass = sum(RAW[s] for s in states)
            assert mass == masses[0] * masses[1]
            factors = {}
            for w in range(2):
                prior = sum(LABEL_MASS[x] for x in range(4) if hits(w, x))
                factors[w] = tuple(
                    sum(LABEL_MASS[x] for x in cs[h] if hits(w, x)) / masses[h] / prior
                    for h in range(2)
                )
            info[prefix] = {
                "mass": mass,
                "cylinder_masses": masses,
                "factors": factors,
                "likelihood": {w: factors[w][0] * factors[w][1] for w in range(2)},
                "states": states,
            }
            checked += 1
        levels.append(info)
    return levels, checked


def check_protocols():
    counts = defaultdict(int)
    max_epsilon = F(0)
    max_tilted = F(0)
    min_bound = None
    conditional_one = None
    frozen_example = None
    for policy in itertools.product(range(5), range(5), range(5), range(2)):
        paths = {s: trace(policy, s) for s in STATES}
        levels, rectangles = transcript_levels(paths)
        counts["protocols"] += 1
        counts["positive_transcript_cylinders"] += rectangles
        tilted = {}
        priors = {}
        for w in range(2):
            c = sum(LABEL_MASS[x] for x in range(4) if hits(w, x))
            assert c >= F(1, 2)
            priors[w] = c * c
            tilted[w] = {
                s: RAW[s] / priors[w] if all(hits(w, x) for x in s) else F(0)
                for s in STATES
            }
            assert sum(tilted[w].values()) == 1
            for t, nodes in enumerate(levels):
                assert sum(n["mass"] * n["likelihood"][w] for n in nodes.values()) == 1
                for prefix, node in nodes.items():
                    actual = sum(tilted[w][s] for s in node["states"])
                    assert actual == node["mass"] * node["likelihood"][w]
                    counts["likelihood_identities"] += 1
                    if t:
                        parent = levels[t - 1][prefix[:-1]]
                        changed = prefix[-1][0]
                        assert node["factors"][w][1 - changed] == parent["factors"][w][1 - changed]
            for t in range(HORIZON):
                for prefix, parent in levels[t].items():
                    child_sum = sum(
                        n["mass"] * n["likelihood"][w]
                        for child, n in levels[t + 1].items() if child[:-1] == prefix
                    )
                    assert child_sum == parent["mass"] * parent["likelihood"][w]
                    counts["martingale_identities"] += 1

        prefix_range = 1
        for block, other in itertools.product(range(2), range(4)):
            possible = {
                (t, tuple(item[2] for item in paths[s][:t] if item[0] == block))
                for s in STATES if s[1 - block] == other
                for t in range(HORIZON + 1)
            }
            prefix_range = max(prefix_range, len(possible))
        for t in range(1, HORIZON + 1):
            small = sum(
                node["mass"] for prefix, node in levels[t].items()
                if node["cylinder_masses"][prefix[-1][0]] < F(1, 4)
            )
            assert small <= 2 * prefix_range * F(1, 4)
            counts["adaptive_small_cylinder_bounds"] += 1

        beta = sum(
            WITNESS_MASS[w] * RAW[s] * int(deviates(w, paths[s]))
            for w, s in itertools.product(range(2), STATES)
        )
        ptilt = {
            w: sum(tilted[w][s] for s in STATES if deviates(w, paths[s]))
            for w in range(2)
        }
        eta = sum(WITNESS_MASS[w] * ptilt[w] for w in range(2))
        max_tilted = max(max_tilted, eta)
        weighted = sum(WITNESS_MASS[w] * priors[w] * ptilt[w] for w in range(2))
        surviving = sum(
            WITNESS_MASS[w] * RAW[s] *
            int(all(hits(w, x) for x in s) and deviates(w, paths[s]))
            for w, s in itertools.product(range(2), STATES)
        )
        assert weighted == surviving
        weight_second = sum(WITNESS_MASS[w] * priors[w] ** 2 for w in range(2))
        assert weighted**2 <= weight_second * eta
        counts["survival_weighted_cauchy_bounds"] += 1

        for delta in (F(1, 10), F(1, 4)):
            bad = {
                (w, t, prefix): abs(node["factors"][w][prefix[-1][0]] - 1) > delta
                for w in range(2)
                for t in range(1, HORIZON + 1)
                for prefix, node in levels[t].items()
            }
            eps_by_time = [
                sum(
                    WITNESS_MASS[w] * node["mass"] * int(bad[w, t, prefix])
                    for w in range(2) for prefix, node in levels[t].items()
                )
                for t in range(1, HORIZON + 1)
            ]
            eps = max(eps_by_time)
            assert eps <= WITNESS_MASS[1]
            max_epsilon = max(max_epsilon, eps)
            if conditional_one is None:
                for t in range(2, HORIZON + 1):
                    for prefix, parent in levels[t - 1].items():
                        if any(bad[1, j, prefix[:j]] for j in range(1, t)):
                            continue
                        child_bad = sum(
                            node["mass"] * int(bad[1, t, child])
                            for child, node in levels[t].items() if child[:-1] == prefix
                        )
                        if child_bad == parent["mass"]:
                            conditional_one = {
                                "policy": list(policy),
                                "delta": rational(delta),
                                "witness": "sensitive",
                                "previous_transcript": [list(x) for x in prefix],
                                "previous_likelihood": rational(parent["likelihood"][1]),
                                "conditional_next_exception_probability": "1/1",
                                "raw_integrated_exception_upper_bound": rational(WITNESS_MASS[1]),
                            }
                            break
                    if conditional_one is not None:
                        break

            for barrier in (F(1), F(11, 10), F(4), F(16)):
                a = 2 * delta / (1 - delta)
                M = 2 / (1 - delta)
                q = 1 + a * a
                H = q**HORIZON * (1 + HORIZON * barrier**2 * M**2 * eps)
                moments = [F(0) for _ in range(HORIZON + 1)]
                linear = [F(0) for _ in range(HORIZON)]
                bar_mass = F(0)
                exc_mass = F(0)
                good_deviation = F(0)
                for w, state in itertools.product(range(2), STATES):
                    path = paths[state]
                    raw_weight = WITNESS_MASS[w] * RAW[state]
                    tilt_weight = WITNESS_MASS[w] * tilted[w][state]
                    r = F(1)
                    stopped = False
                    at_barrier = False
                    at_exception = False
                    moments[0] += raw_weight
                    for t in range(1, HORIZON + 1):
                        previous = r
                        live_exception = 0
                        if not stopped:
                            assert 0 < previous <= barrier
                            parent = levels[t - 1][path[:t - 1]]
                            node = levels[t][path[:t]]
                            block = path[t - 1][0]
                            assert abs(parent["factors"][w][block] - 1) <= delta
                            r = node["likelihood"][w]
                            z = r / previous
                            assert 0 <= z <= M
                            live_exception = int(bad[w, t, path[:t]])
                            if not live_exception:
                                assert abs(z - 1) <= a
                            at_barrier = r > barrier
                            at_exception = bool(live_exception)
                            stopped = at_barrier or at_exception
                        else:
                            z = F(1)
                            if r > barrier:
                                counts["frozen_updates_above_barrier"] += 1
                                if frozen_example is None:
                                    frozen_example = {
                                        "policy": list(policy),
                                        "delta": rational(delta),
                                        "barrier": rational(barrier),
                                        "stopped_likelihood": rational(r),
                                        "next_multiplier": "1/1",
                                        "live_exception_indicator": 0,
                                    }
                        assert r == previous * z
                        assert (z - 1)**2 <= a**2 + M**2 * live_exception
                        assert previous**2 * live_exception <= barrier**2 * live_exception
                        assert r**2 <= (
                            (1 + a**2) * previous**2
                            + 2 * previous**2 * (z - 1)
                            + barrier**2 * M**2 * live_exception
                        )
                        linear[t - 1] += raw_weight * previous**2 * (z - 1)
                        moments[t] += raw_weight * r**2
                        counts["pointwise_stopped_inequalities"] += 1
                    bar_mass += tilt_weight * int(at_barrier)
                    exc_mass += tilt_weight * int(at_exception)
                    good_deviation += tilt_weight * int(not stopped and deviates(w, path))
                assert all(x == 0 for x in linear), "nonzero stopped linear term"
                for t in range(1, HORIZON + 1):
                    assert moments[t] <= q * moments[t - 1] + barrier**2 * M**2 * eps
                    assert moments[t] <= q**t * (1 + t * barrier**2 * M**2 * eps)
                    counts["integrated_second_moment_bounds"] += 1
                assert moments[-1] <= H
                assert bar_mass <= H / barrier
                assert exc_mass <= barrier * M * HORIZON * eps
                assert good_deviation <= barrier * beta
                bound = H / barrier + barrier * M * HORIZON * eps + barrier * beta
                assert eta <= bar_mass + exc_mass + good_deviation <= bound
                min_bound = bound if min_bound is None else min(min_bound, bound)
                counts["stopped_transfer_replays"] += 1
    assert conditional_one is not None, "missing integrated-only exception example"
    assert frozen_example is not None, "missing frozen barrier-overshoot example"
    return {
        "counts": dict(counts),
        "maximum_raw_integrated_exception": rational(max_epsilon),
        "maximum_actual_tilted_deviation": rational(max_tilted),
        "minimum_certified_transfer_upper_bound": rational(min_bound),
        "conditional_exception_negative_control": conditional_one,
        "frozen_overshoot_example": frozen_example,
    }


def check_survival_recursion():
    checked = 0
    for m, p, b, e in itertools.product(
        range(1, 7), (F(1, 2), F(1, 4)), (F(1, 1000), F(1, 100)),
        (F(0), F(1, 10**6))
    ):
        values = {F(1)}
        for _ in range(m):
            values = {
                max(F(0), min(F(1), p * x + sign * (3 * b * x + e)))
                for x in values for sign in (-1, 1)
            }
        rho = (1 + 12 * b)**m - 1 + m * e * 4**m
        for x in values:
            assert abs(x - p**m) <= p**m * rho
            checked += 1
    parity = {(0, 0): F(1, 2), (1, 1): F(1, 2)}
    px = sum(m for (x, _), m in parity.items() if x == 1)
    py = sum(m for (_, y), m in parity.items() if y == 1)
    assert parity[1, 1] != px * py
    return {
        "recursion_endpoint_checks": checked,
        "cylinder_dependence_negative_control": {
            "model": "Two raw independent fair bits, conditioned on equal parity.",
            "conditional_joint_11": rational(parity[1, 1]),
            "product_of_conditional_marginals_11": rational(px * py),
            "interpretation": "Coordinates need not remain independent within a cylinder.",
        },
        "second_moment_power_exponent": rational(1 - 2 * F(24, 25)),
    }


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    d = json.loads((HERE / "jacobian_output.json").read_text())
    operation = "probability.finite_distribution.condition.compute"
    assert d["request"]["operation_id"] == operation
    assert d["request"]["payload"] == payload
    assert d["result"]["operation_id"] == operation
    out = d["result"]["output"]
    assert out["event_probability"] == {"num": "7", "den": "8"}
    atoms = out["distribution"]["atoms"]
    assert [
        F(int(a["probability"]["num"]), int(a["probability"]["den"])) for a in atoms
    ] == [F(4, 7), F(2, 7), F(1, 7)]
    return {
        "operation_id": operation,
        "server_version": d["server"]["version"],
        "protocol_version": d["protocol_version"],
        "transport": d["transport"],
        "adapter_exit_code": 0,
        "adapter_status": "completed_typed_output",
        "timeout": False,
        "structured_error": None,
        "event_probability": "7/8",
        "conditioned_probabilities": ["4/7", "2/7", "1/7"],
        "scope": "One finite conditioning normalization, not a proof of the uniform theorem.",
    }


def check_lean():
    d = json.loads((HERE / "lean_check.json").read_text())
    assert d["status"] == "success" and d["exit_code"] == 0
    assert d["proof_holes"] == [] and d["audit_exit_code"] == 0
    for key, filename in (
        ("source_sha256", "Main.lean"),
        ("statement_fidelity_sha256", "statement_fidelity.md"),
    ):
        assert hashlib.sha256((HERE / filename).read_bytes()).hexdigest() == d[key]
    assert "4.31.0" in d["tools"]["lean"]["version"]
    return {
        "claim_id": "V_LPT_L2_STEP",
        "status": d["status"],
        "compiler_exit_code": d["exit_code"],
        "proof_holes": d["proof_holes"],
        "axiom_audit_exit_code": d["audit_exit_code"],
        "lean_version": d["tools"]["lean"]["version"],
        "scope": "Universal finite weighted second-moment integration and iteration only.",
    }


def replay():
    return {
        "claim_id": "V_LPT",
        "result_class": "uniform_local_verification_theorem",
        "status": "engineer_replay_passed_pending_independent_review",
        "upstream_inputs_independently_proved": False,
        "main_ramsey_theorem_established": False,
        "novelty_status": "not_claimed",
        "proof": "report.md, Sections 1-4",
        "finite_theorem": {
            "a0": "2 delta / (1-delta)",
            "M": "kappa^(-m) / (1-delta)",
            "H": "(1+a0^2)^L (1+L B^2 M^2 epsilon)",
            "tilted_deviation": "<= H/B + B M L epsilon + B beta",
            "rho": "(1+12b)^m - 1 + m(v+zeta)4^m",
            "theta": "m eta_D/v",
            "epsilon": "K S lambda + (K+1)theta",
            "surviving_witnesses": "<= M_i^u 2^(-u d) sqrt(W eta)",
            "conditional_exception_bound_assumed": False,
            "postconditioning_coordinate_independence_assumed": False,
            "growth_rate_for_C_n_assumed": False,
        },
        "finite_replay_scope": "Diagnostics, not a finite replacement for the uniform proof.",
        "adaptive_protocols": check_protocols(),
        "survival": check_survival_recursion(),
        "jacobian": check_jacobian(),
        "formal_core": check_lean(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = replay()
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        assert json.loads(certificate.read_text()) == result, "certificate replay mismatch"
    print(json.dumps({
        "status": result["status"],
        "protocols": result["adaptive_protocols"]["counts"]["protocols"],
        "stopped_transfer_replays": result["adaptive_protocols"]["counts"]["stopped_transfer_replays"],
        "lean_exit_code": result["formal_core"]["compiler_exit_code"],
        "proof_holes": result["formal_core"]["proof_holes"],
        "certificate": str(certificate),
    }, sort_keys=True))


if __name__ == "__main__":
    main()
