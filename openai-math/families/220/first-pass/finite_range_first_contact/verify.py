#!/usr/bin/env python3
"""Replay exact models; universal and infinite-path proofs are in report.md."""

import argparse
import itertools
import json
from fractions import Fraction as Q
from pathlib import Path


HERE = Path(__file__).resolve().parent
OPERATION = "probability.conditional_expectation.finite.compute"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def rational(value):
    return Q(int(value["num"]), int(value["den"]))


def peak(n, s):
    return 1 + sum(
        Q(2**i, 2) * (1 - (1 - Q(1, 2 ** (i + 1))) ** s)
        for i in range(n)
    )


def prefix_posterior(n, depth, observed):
    m = 2**n
    return [
        Q(1, 2 * m)
        + (Q(2**depth, 2 * m) if e >> (n - depth) == observed else 0)
        for e in range(m)
    ]


def check_posterior_states():
    states = 0
    for n in range(1, 7):
        m = 2**n
        uniform = [Q(1, m)] * m
        require(prefix_posterior(n, 0, 0) == uniform, "initial posterior")
        for depth in range(n + 1):
            for observed in range(2**depth):
                w = prefix_posterior(n, depth, observed)
                require(sum(w) == 1 and min(w) >= 0, "simplex identity")
                if depth < n:
                    left = prefix_posterior(n, depth + 1, 2 * observed)
                    right = prefix_posterior(n, depth + 1, 2 * observed + 1)
                    require(
                        all((a + b) / 2 == c for a, b, c in zip(left, right, w)),
                        "next-bit martingale identity",
                    )
                else:
                    require(
                        all(
                            (uniform[e] + int(e == observed)) / 2 == w[e]
                            for e in range(m)
                        ),
                        "flag-reveal martingale identity",
                    )
                states += 1
    return states


def check_experiment_bayes():
    states = 0
    for n in range(1, 5):
        m = 2**n
        atom_mass = Q(1, 2 * m**2)
        for depth in range(n + 1):
            joint = [[Q(0)] * m for _ in range(2**depth)]
            for hidden, flag, noise in itertools.product(range(m), (0, 1), range(m)):
                observed = (hidden if flag else noise) >> (n - depth)
                joint[observed][hidden] += atom_mass
            for observed, masses in enumerate(joint):
                marginal = sum(masses)
                require(marginal == Q(1, 2**depth), "observation-prefix marginal")
                require(
                    [p / marginal for p in masses] == prefix_posterior(n, depth, observed),
                    "posterior derived independently from latent experiment",
                )
                states += 1
        joint = {(flag, z): [Q(0)] * m for flag in (0, 1) for z in range(m)}
        for hidden, flag, noise in itertools.product(range(m), (0, 1), range(m)):
            z = hidden if flag else noise
            joint[flag, z][hidden] += atom_mass
        for (flag, z), masses in joint.items():
            posterior = [p / sum(masses) for p in masses]
            expected = [Q(int(e == z)) if flag else Q(1, m) for e in range(m)]
            require(posterior == expected, "flag-conditioned latent posterior")
            states += 1
    return states


def enumerated_peak(n, s):
    m = 2**n
    total = Q(0)
    for observations in itertools.product(range(m), repeat=s):
        maxima = [Q(1, m)] * m
        for z in observations:
            for depth in range(n + 1):
                posterior = prefix_posterior(n, depth, z >> (n - depth))
                maxima = [max(a, b) for a, b in zip(maxima, posterior)]
        total += sum(maxima) / m**s
    return total


def check_peak_formula():
    cases = 0
    for n in range(1, 4):
        for s in range(4):
            require(enumerated_peak(n, s) == peak(n, s), "reset maximum formula")
            cases += 1
    return cases


def reset_instance(n, J, L=None):
    delta = Q(1, 2**J)
    masses = [Q(1, 2 ** (s + 1)) for s in range(J)] + [delta]
    h = [delta * 2**s for s in range(J + 1)]
    require(sum(masses) == 1 and h[-1] == 1, "capped-geometric probability")
    for i, t in enumerate(h):
        tail = sum(masses[i:])
        require(tail * t == delta, "exact weak-L1 atom tail")
    moment = sum(masses[s] * h[s] * peak(n, s) for s in range(J + 1))
    formula = delta / 2 * sum(peak(n, s) for s in range(J)) + delta * peak(n, J)
    require(moment == formula, "lower-moment identity")
    result = {
        "n": n,
        "m": 2**n,
        "J": J,
        "delta": str(delta),
        "reset_skeleton_lower_moment": str(moment),
        "tail_scope": "All positive real thresholds, by constancy between checked atoms.",
    }
    if L is not None:
        require(J <= 2**L and 2 * L <= n, "unsaturated hypotheses")
        for s in range(J + 1):
            require(peak(n, s) >= Q(s * n, 16), "reset peak lower bound")
        lower = delta * n * J**2 / 64
        require(moment >= lower, "universal-core instance")
        result.update({"L": L, "lower_bound": str(lower), "regime": "unsaturated"})
    else:
        m = 2**n
        require(J >= 2 * m, "saturated hypotheses")
        for s in range(m, J + 1):
            require(peak(n, s) >= Q(m, 4), "saturated reset peak")
        lower = delta * m * J / 16
        require(moment >= lower, "saturated lower bound")
        result.update({"lower_bound": str(lower), "regime": "saturated"})
    return result


def local_environment_check():
    def row_plus(a, b):
        return Q(4 + a + b, 24)

    def row_minus(a, b):
        return Q(4 - a - b, 24)

    lam = Q(1, 48)
    for a, b in itertools.product((0, 1), repeat=2):
        row = [row_plus(a, b), row_minus(a, b)] + [Q(1, 6)] * 4
        require(sum(row) == 1 and min(row) >= Q(1, 12), "elliptic row")
        require(2 * lam < min(row), "positive residual marks")

    data = list(itertools.product((0, 1), repeat=3))
    likelihood = [row_plus(a, b) - 2 * lam for a, b, c in data]
    adjacent = [row_plus(b, c) for a, b, c in data]
    prefix_probability = sum(likelihood) / 8
    mean = sum(adjacent) / 8
    tilted = sum(x * y for x, y in zip(likelihood, adjacent)) / 8 / prefix_probability
    require(prefix_probability == Q(1, 6), "active departure probability")
    require(mean == Q(5, 24) and tilted == Q(27, 128), "adjacent posterior")
    require(tilted - mean == Q(1, 384), "non-iid posterior shift")

    joint = Q(0)
    old = Q(0)
    new = Q(0)
    for a, b, c, d, e in itertools.product((0, 1), repeat=5):
        p0 = row_plus(a, b) - 2 * lam
        # A three-step future word uses rows 6, 7, and 6 again.
        future = (row_plus(c, d) - 2 * lam) ** 2 * (row_minus(d, e) - 2 * lam)
        joint += p0 * future / 32
        old += p0 / 32
        new += future / 32
    require(joint == old * new, "separated repeated-row word factorization")
    script = lam**5
    require(joint * script == (old * script) * new, "constant script factorization")
    return {
        "dimension": 3,
        "range": 1,
        "kappa": "1/12",
        "lambda": "1/48",
        "script_length": 5,
        "unconditional_adjacent_plus": str(mean),
        "conditioned_adjacent_plus": str(tilted),
        "posterior_shift": str(tilted - mean),
        "separated_future_word_probability": str(new),
        "separated_joint_probability": str(joint),
        "scope": "Exact finite cylinders of an infinite stationary 1-dependent bit-factor field.",
        "not_claimed": "No coexistence hypothesis or RWRE counterexample is asserted for this example.",
    }


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    execution = json.loads((HERE / "jacobian_execution.json").read_text())
    envelope = json.loads((HERE / "jacobian_result.json").read_text())
    require(execution["adapter_exit_code"] == 0, "Jacobian adapter did not complete")
    require(envelope["request"]["operation_id"] == OPERATION, "Jacobian operation")
    require(envelope["request"]["payload"] == payload, "Jacobian payload binding")
    require(envelope["result"]["operation_id"] == OPERATION, "typed result operation")
    space = payload["rv"]["space"]
    masses = list(map(rational, space["masses"]))
    values = list(map(rational, payload["rv"]["values"]))
    require(sum(masses) == 1 and min(masses) > 0, "Jacobian source probability")
    require(payload["sigma"]["space"] == space, "Jacobian sigma-space binding")
    require(payload["sigma"]["blocks"] == [space["samples"]], "trivial sigma algebra")
    expected = sum(p * x for p, x in zip(masses, values))
    output = envelope["result"]["output"]
    require(output["space"] == space, "Jacobian output probability space")
    require(
        all(rational(x) == expected == Q(27, 128) for x in output["values"]),
        "Jacobian exact conditional expectation",
    )
    require(len(output["values"]) == len(space["samples"]), "Jacobian output shape")
    return {
        "operation_id": OPERATION,
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "adapter_exit_code": execution["adapter_exit_code"],
        "typed_value": str(expected),
        "mathematical_scope": "Eight-atom conditional expectation, not infinite-path certification.",
    }


def certificate():
    states = check_posterior_states()
    bayes_states = check_experiment_bayes()
    enumerations = check_peak_formula()
    # These are rational majorants in the exponential-moment proof, not
    # floating-point evaluations of exp or log.
    require(Q(8, 7) * (1 + Q(4, 3) / (1 - Q(4, 3) / 2)) == Q(40, 7), "moment majorant")
    require(Q(40, 7) < 8, "moment constant")
    instances = [
        reset_instance(2, 2, 1),
        reset_instance(4, 3, 2),
        reset_instance(4, 4, 2),
        reset_instance(6, 8, 3),
        reset_instance(8, 16, 4),
        reset_instance(1, 4),
        reset_instance(2, 8),
        reset_instance(3, 16),
    ]
    return {
        "schema_version": 1,
        "claim_scope": {
            "C_FR_CONTACT": "Complete finite-range proof in report.md, sections 1-2; independent review required.",
            "C_POSTERIOR_PRODUCT": "Universal two-regime upper product theorem, proved in report.md.",
            "C_POSTERIOR_SHARPNESS": "Explicit finite probability construction with universal lower-family proofs, not an RWRE model.",
            "C_POSTERIOR_SHARP_CORE": "Universal binomial and finite-sum core formalized in Main.lean.",
        },
        "manuscript_refutations": [],
        "local_non_iid_model": local_environment_check(),
        "jacobian": check_jacobian(),
        "posterior_states_checked": states,
        "latent_experiment_bayes_states": bayes_states,
        "independent_peak_enumerations": enumerations,
        "exact_reset_instances": instances,
        "upper_bound_constants": {
            "posterior_event": 48,
            "exponential_moment": 8,
            "explicit_contact_coefficient": 192,
            "contact_formula": "192*(2*d-1)*kappa^(-d*R)/(p_plus*p_minus)",
            "script_cost_cancels": True,
        },
        "limitations": [
            "Finite exact checks do not prove the infinite-environment theorem; the complete proof is in report.md.",
            "The Lean theorem certifies only its stated algebraic core, not the probability-space interpretation or RWRE.",
            "Abstract sharpness is not a counterexample to, or a sharpness theorem for, the RWRE contact bound.",
            "Headline zero-one and ballisticity theorems remain unaudited beyond the dependency map.",
            "Novelty and publishable significance are not certified by the bounded source lookup.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    computed = certificate()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(computed, indent=2) + "\n")
    else:
        require(json.loads(target.read_text()) == computed, "recorded certificate differs from replay")
    print(
        json.dumps(
            {
                "ok": True,
                "posterior_states": computed["posterior_states_checked"],
                "bayes_states": computed["latent_experiment_bayes_states"],
                "peak_enumerations": computed["independent_peak_enumerations"],
                "reset_instances": len(computed["exact_reset_instances"]),
                "manuscript_refutations": 0,
                "scope": "Exact model replay; see report and separate Lean record for universal statements.",
            }
        )
    )


if __name__ == "__main__":
    main()
