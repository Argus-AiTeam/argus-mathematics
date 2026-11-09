#!/usr/bin/env python3
"""Replay exact stress cases, compile the universal theorem, and check its ledger."""

from __future__ import annotations

import argparse
from collections import defaultdict
from dataclasses import dataclass
from fractions import Fraction as Q
import json
from math import factorial
from pathlib import Path
import re
import subprocess
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
EXP_LOWER = Q(8, 3)
EXP_UPPER = Q(11, 4)


def check(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def rational(value: dict[str, str]) -> Q:
    return Q(int(value["num"]), int(value["den"]))


def masks(n: int) -> list[frozenset[int]]:
    return [frozenset(i for i in range(n) if bits & (1 << i)) for bits in range(1 << n)]


@dataclass(frozen=True)
class Arc:
    index: int
    label: frozenset[int]
    weight: Q
    children: tuple[Arc, ...] | None = None


@dataclass
class Evaluation:
    mass: tuple[Q, ...]
    failure: Q
    target: tuple[Q, ...]
    good: bool
    reduced: tuple[Arc, ...] | None
    potential: dict[int, Q]


def normal_law(arcs: tuple[Arc, ...]) -> None:
    check(bool(arcs), "A non-leaf has no children")
    check(len({arc.index for arc in arcs}) == len(arcs), "Distinct histories were merged")
    check(all(arc.weight > 0 for arc in arcs), "Nonpositive child weight")
    check(sum((arc.weight for arc in arcs), Q(0)) == 1, "Unnormalized child law")


def spread(arcs: tuple[Arc, ...], universe: list[frozenset[int]], alpha: Q) -> None:
    for j in universe:
        mass = sum((arc.weight for arc in arcs if j <= arc.label), Q(0))
        check(mass <= alpha ** len(j), f"Spread failed for test set {sorted(j)}")


def score(arcs: tuple[Arc, ...], y: frozenset[int], rho: Q) -> tuple[Q, ...]:
    return tuple(
        arc.weight * rho ** (-len(arc.label)) if arc.label <= y else Q(0)
        for arc in arcs
    )


def transition(
    arcs: tuple[Arc, ...], w: frozenset[int], rho: Q, capacity: int
) -> tuple[tuple[Q, ...], Q, tuple[Q, ...]]:
    kept = [Q(0) for _ in arcs]
    target = [Q(0) for _ in arcs]
    failure = Q(0)
    for source in arcs:
        scores = score(arcs, w | source.label, rho)
        z = sum(scores, Q(0))
        check(z > 0, "Planted union has zero partition function")
        # All stress laws have empty-label mass > 1/2. This certifies the
        # denominator test exactly, rather than evaluating an exponential.
        check(z >= Q(1, 2) > EXP_LOWER ** (-10 * capacity), "Uncertified denominator test")
        row = Q(0)
        for b, arc in enumerate(arcs):
            joint = source.weight * scores[b] / z
            row += joint
            target[b] += joint
            fragment = arc.label - w
            if joint:
                check(fragment <= source.label & arc.label, "Fragment/source inclusion failed")
                check(arc.label <= w | fragment, "Target recovery failed")
            passes = 2 * len(fragment) <= capacity
            check(passes == (len(fragment) <= capacity // 2), "Capacity rounding mismatch")
            if passes:
                kept[b] += joint
            else:
                failure += joint
        check(row == source.weight, "The fixed-W source marginal changed")
    check(failure + sum(kept, Q(0)) == 1, "Local mass normalization failed")
    return tuple(kept), failure, tuple(target)


def polynomial_add(target: dict[int, Q], source: dict[int, Q], scale: Q, shift: int) -> None:
    for exponent, coefficient in source.items():
        value = target.get(exponent + shift, Q(0)) + scale * coefficient
        if value:
            target[exponent + shift] = value


def evaluate_tree(
    arcs: tuple[Arc, ...],
    w: frozenset[int],
    rho: Q,
    capacities: tuple[int, ...],
    history: tuple[int, ...],
    records: dict[tuple[int, ...], dict[frozenset[int], Evaluation]],
) -> Evaluation:
    capacity = capacities[0]
    child_results: list[Evaluation | None] = []
    for arc in arcs:
        child_results.append(
            None if arc.children is None else evaluate_tree(
                arc.children, w, rho, capacities[1:], history + (arc.index,), records
            )
        )
    mass, failure, target = transition(arcs, w, rho, capacity)
    gamma = sum((
        mass[b] for b, child in enumerate(child_results) if child is None or child.good
    ), Q(0))
    loss = 1 - gamma
    if loss <= EXP_UPPER ** (-capacity):
        good = True
    elif loss > EXP_LOWER ** (-capacity):
        good = False
    else:
        raise AssertionError("The rational enclosure does not decide the goodness test")
    potential: dict[int, Q] = {}
    if failure:
        potential[capacity] = failure
    for b, child in enumerate(child_results):
        if child is not None:
            polynomial_add(potential, child.potential, mass[b], capacity)
    reduced = None
    if good:
        check(gamma > 0, "A good node has zero retained mass")
        reduced = tuple(
            Arc(arc.index, arc.label - w, mass[b] / gamma,
                None if child_results[b] is None else child_results[b].reduced)
            for b, arc in enumerate(arcs)
            if (child_results[b] is None or child_results[b].good) and mass[b] > 0
        )
        normal_law(reduced)
    result = Evaluation(mass, failure, target, good, reduced, potential)
    records.setdefault(history, {})[w] = result
    return result


def paths(arcs: tuple[Arc, ...]) -> list[tuple[tuple[int, ...], frozenset[int]]]:
    result = []
    for arc in arcs:
        if arc.children is None:
            result.append(((arc.index,), arc.label))
        else:
            for history, union in paths(arc.children):
                check(not arc.label & union, "Labels intersect on a full path")
                result.append(((arc.index,) + history, arc.label | union))
    return result


def check_reduced(
    arcs: tuple[Arc, ...], capacities: tuple[int, ...],
    universe: list[frozenset[int]], alpha: Q
) -> None:
    normal_law(arcs)
    m = capacities[0]
    check(all(len(arc.label) <= m // 2 for arc in arcs), "Output capacity failed")
    # This rational parameter is no larger than alpha/(1-exp(-m)).
    spread(arcs, universe, alpha / (1 - EXP_UPPER ** (-m)))
    for arc in arcs:
        if arc.children is not None:
            check_reduced(arc.children, capacities[1:], universe, alpha)


def build_case(alpha: Q, large_size: int) -> tuple[Arc, ...]:
    small = alpha / 8
    large = alpha ** large_size / 8

    def children(single: int, big: frozenset[int]) -> tuple[Arc, ...]:
        return (
            Arc(0, frozenset(), 1 - 2 * small - large),
            Arc(1, frozenset({single}), small),
            Arc(2, frozenset({single}), small),
            Arc(3, big, large),
        )

    return (
        Arc(0, frozenset(), 1 - 3 * small,
            children(0, frozenset(range(2, large_size + 2)))),
        Arc(1, frozenset({0}), small,
            children(1, frozenset(range(1, large_size + 1)))),
        Arc(2, frozenset({0}), small,
            children(large_size + 1, frozenset(range(2, large_size + 2)))),
        Arc(3, frozenset({1}), small,
            children(0, frozenset({0, *range(2, large_size + 1)}))),
    )


def check_case(spec: dict, alpha: Q, rho: Q) -> dict:
    n = spec["ground_size"]
    capacities = tuple(spec["capacities"])
    universe = masks(n)
    check(len(universe) == spec["sample_count"], "Incorrect sample count")
    check(capacities[1] >= 3 * capacities[0] > 0, "Factor-3 separation failed")
    arcs = build_case(alpha, spec["large_label_size"])
    originals = dict(paths(arcs))
    nodes = {(): arcs, **{(arc.index,): arc.children for arc in arcs}}
    for history, law in nodes.items():
        check(law is not None, "Missing input subtree")
        normal_law(law)
        check(all(len(arc.label) <= capacities[len(history)] for arc in law), "Input capacity failed")
        spread(law, universe, alpha)
    mu = {w: rho ** len(w) * (1 - rho) ** (n - len(w)) for w in universe}
    check(sum(mu.values(), Q(0)) == 1, "Bernoulli law not normalized")
    records: dict[tuple[int, ...], dict[frozenset[int], Evaluation]] = {}
    successes = Q(0)
    for w in universe:
        result = evaluate_tree(arcs, w, rho, capacities, (), records)
        if result.good:
            successes += mu[w]
            check(result.reduced is not None, "Successful root returned no tree")
            check_reduced(result.reduced, capacities, universe, alpha)
            for history, output_union in paths(result.reduced):
                check(history in originals, "Output path lost its original history")
                check(originals[history] <= w | output_union, "Full-path recovery failed")
    check(successes >= Q(3, 4), "Success probability failed")
    nonzero_descendant = False
    for b, arc in enumerate(arcs):
        incoming = arc.label
        for w in universe:
            toggled = w ^ incoming
            check(records[(b,)][w].potential == records[(b,)][toggled].potential,
                  "Descendant potential uses an incoming-label coordinate")
            nonzero_descendant |= bool(records[(b,)][w].potential)
    check(nonzero_descendant, "The dependence stress case has zero descendant potential")
    for history, law in nodes.items():
        capacity = capacities[len(history)]
        planted = defaultdict(Q)
        target_prior = [Q(0) for _ in law]
        outside_joint = [defaultdict(Q) for _ in law]
        outside_prior = [defaultdict(Q) for _ in law]
        expected_failure = Q(0)
        for w in universe:
            ev = records[history][w]
            expected_failure += mu[w] * ev.failure
            for source in law:
                planted[w | source.label] += mu[w] * source.weight
            for b, arc in enumerate(law):
                target_prior[b] += mu[w] * ev.target[b]
                outside = w - arc.label
                outside_joint[b][outside] += mu[w] * ev.target[b]
                outside_prior[b][outside] += mu[w]
        for y in universe:
            check(planted[y] == mu[y] * sum(score(law, y, rho), Q(0)),
                  "Indexed planted-union density failed")
        for b, arc in enumerate(law):
            check(target_prior[b] == arc.weight, "Unconditional target marginal failed")
            for outside, value in outside_joint[b].items():
                check(value <= EXP_LOWER ** (11 * capacity) * arc.weight *
                      outside_prior[b][outside], "Outside-atom distortion failed")
        check(expected_failure <= EXP_UPPER ** (-9 * capacity), "Local failure estimate failed")
    expected_potential: dict[int, Q] = {}
    for w in universe:
        polynomial_add(expected_potential, records[()][w].potential, mu[w], 0)
    upper_potential = sum((
        coefficient * EXP_UPPER ** exponent
        for exponent, coefficient in expected_potential.items()
    ), Q(0))
    check(upper_potential <= EXP_UPPER ** (-7 * capacities[0]),
          "Uniform expected-potential bound failed")
    return {
        "ground_size": n, "capacities": list(capacities),
        "samples": len(universe), "local_states": len(nodes) * len(universe),
        "success_probability": str(successes), "nonzero_descendant_potential": True,
    }


def check_jacobian(certificate: dict) -> dict:
    spec = certificate["jacobian"]
    payload = json.loads((HERE / spec["payload"]).read_text())
    response = json.loads((HERE / spec["output"]).read_text())
    check(response["request"]["operation_id"] == spec["operation_id"], "Wrong Jacobian operation")
    check(response["request"]["payload"] == payload, "Jacobian payload was substituted")
    check(response["result"]["operation_id"] == spec["operation_id"], "Wrong result operation")
    output = response["result"]["output"]
    atoms = payload["distribution"]["atoms"]
    demo = (
        Arc(0, frozenset(), Q(1, 2)),
        Arc(1, frozenset({0}), Q(1, 4)),
        Arc(2, frozenset({0}), Q(1, 4)),
    )
    for atom in atoms:
        value = int(rational(atom["value"]))
        c, bit = divmod(value, 2)
        check(rational(atom["probability"]) == demo[c].weight / 2, "Unbound posterior atom")
        planted_bit = bool(bit) or bool(demo[c].label)
        check(planted_bit == (value != 0), "Incorrect conditioning event")
    check(rational(output["event_probability"]) == Q(3, 4), "Wrong exact event mass")
    conditioned = {int(rational(a["value"])): rational(a["probability"])
                   for a in output["distribution"]["atoms"]}
    check(conditioned == {1: Q(1, 3), 2: Q(1, 6), 3: Q(1, 6),
                          4: Q(1, 6), 5: Q(1, 6)}, "Wrong conditional distribution")
    singleton_law = (Arc(0, frozenset({0}), Q(1, 2)), Arc(1, frozenset({1}), Q(1, 2)))
    fixed_w = frozenset({0})
    fixed_target = Q(0)
    for source in singleton_law:
        scores = score(singleton_law, fixed_w | source.label, Q(1, 2))
        fixed_target += source.weight * scores[0] / sum(scores, Q(0))
    check(fixed_target == Q(3, 4), "The retired fixed-W shortcut example is incorrect")
    return {
        "operation_id": spec["operation_id"], "adapter_status": spec["adapter_status"],
        "server_version": response["server"]["version"], "protocol": response["protocol_version"],
        "event_probability": "3/4",
    }


def command(args: list[str]) -> subprocess.CompletedProcess[str]:
    result = subprocess.run(args, cwd=ROOT, text=True, capture_output=True)
    if result.returncode:
        sys.stderr.write(result.stdout)
        sys.stderr.write(result.stderr)
        raise SystemExit(result.returncode)
    return result


def compile_universal(certificate: dict) -> dict:
    source = HERE / certificate["formal_source"]
    text = source.read_text()
    check(not re.search(r"\b(sorry|admit|sorryAx|unsafe)\b", text), "Forbidden proof hole or unsafe source")
    check(not re.search(r"(?m)^\s*(axiom|constant)\b", text), "A custom axiom was introduced")
    result = command([
        ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(source), "--statement-fidelity", str(HERE / certificate["statement_fidelity"]),
        "--project-root", str(ROOT), "--claim", certificate["claim_id"], "--timeout", "120",
    ])
    evidence = json.loads(result.stdout)
    check(evidence["status"] == "success" and evidence["exit_code"] == 0,
          "No successful real compiler run")
    check(evidence["proof_holes"] == [], "Compiler evidence contains proof holes")
    version = re.search(r"Lean \(version ([0-9.]+)", evidence["tools"]["lean"]["version"])
    check(version is not None and version.group(1) == certificate["required_lean_version"],
          "The actual compiler is not the required Lean version")
    check(Path(evidence["source"]).resolve() == source, "The compiler checked another source")
    check(evidence["kernel"]["recorded"] is not None, "Compiler result was not attached to the claim")
    check((HERE / "statement_fidelity.md").read_bytes() ==
          (HERE / certificate["statement_fidelity"]).read_bytes(), "Canonical fidelity differs")
    allowed = set(certificate["allowed_foundational_axioms"])
    for declaration in certificate["required_declarations"]:
        match = re.search(
            rf"'{re.escape(declaration)}' depends on axioms: \[([^\]]*)\]", evidence["stdout"]
        )
        check(match is not None, f"No compiler axiom audit for {declaration}")
        axioms = {item.strip() for item in match.group(1).split(",") if item.strip()}
        check(axioms <= allowed, f"Unexpected axioms in {declaration}: {sorted(axioms - allowed)}")
    command([ARGUS_PYTHON, "-m", "argus_skill.verticals.math.math_state",
             "check", "--project-root", str(ROOT)])
    command([ARGUS_PYTHON, "-m", "argus_skill.verticals.math.proof_graph_check",
             "check", "--project-root", str(ROOT)])
    return {
        "project_root": str(ROOT), "compiler_exit_code": 0, "proof_holes": [],
        "math_state_exit_code": 0, "proof_graph_exit_code": 0,
        "claim": certificate["claim_id"],
        "certificate": evidence["kernel"]["recorded"]["artifact"],
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exact-only", action="store_true",
                        help="Run only the explicitly finite part, without claiming universal certification")
    args = parser.parse_args()
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    partial = sum((Q(1, factorial(j)) for j in range(6)), Q(0))
    tail_majorant = Q(1, factorial(6)) / (1 - Q(1, 7))
    check(sum((Q(1, factorial(j)) for j in range(4)), Q(0)) == EXP_LOWER,
          "Incorrect lower exponential series bound")
    check(partial + tail_majorant < EXP_UPPER, "Incorrect upper exponential series bound")
    alpha = Q(certificate["finite_replay"]["alpha"])
    rho = Q(certificate["finite_replay"]["rho"])
    check(0 < rho < 1 and alpha > 0, "Invalid sampling parameters")
    check(alpha * EXP_UPPER ** 50 <= rho, "The original alpha<=a hypothesis is uncertified")
    exact = [check_case(spec, alpha, rho) for spec in certificate["finite_replay"]["cases"]]
    output = {
        "classification": "finite_verification" if args.exact_only else "universal_formal_verification",
        "finite_cases": exact, "jacobian": check_jacobian(certificate),
    }
    if not args.exact_only:
        output["formal"] = compile_universal(certificate)
    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()
