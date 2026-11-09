#!/usr/bin/env python3
"""Replay exact diagnostics and bind the all-degree proof to a real Lean run."""

from __future__ import annotations

import argparse
import hashlib
import json
from fractions import Fraction
from functools import cache
from itertools import combinations, product
from pathlib import Path
from typing import TypeAlias

Group: TypeAlias = tuple[int, ...]
Word: TypeAlias = tuple[int, ...]
Colors: TypeAlias = tuple[Group, ...]
CrossWord: TypeAlias = tuple[Colors, Group]
Field: TypeAlias = tuple[tuple[tuple[Group, Fraction], ...], ...]
Polynomial: TypeAlias = dict[Word, Fraction]
CrossPolynomial: TypeAlias = dict[CrossWord, Fraction]

HERE = Path(__file__).resolve().parent
ZERO = Fraction(0)
ONE = Fraction(1)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def add_term(polynomial: dict, word: tuple, coefficient: Fraction) -> None:
    total = polynomial.get(word, ZERO) + coefficient
    if total:
        polynomial[word] = total
    else:
        polynomial.pop(word, None)


def reduce_word(word: Word) -> Word:
    result: list[int] = []
    for letter in word:
        if letter and result and result[-1] == -letter:
            result.pop()
        else:
            result.append(letter)
    return tuple(result)


def inverse(group: Group) -> Group:
    return tuple(-letter for letter in reversed(group))


def multiply(left: Group, right: Group) -> Group:
    return reduce_word(left + right)


def marginal(power: int) -> Fraction:
    return ZERO if power % 2 else Fraction(1, power + 1)


@cache
def original_trace(word: Word) -> Fraction:
    """Center alternating blocks in C[F_2] * C[T], without conjugate freeness."""
    reduced = reduce_word(word)
    if reduced != word:
        return original_trace(reduced)
    if not word:
        return ONE
    if all(letter == 0 for letter in word):
        return marginal(len(word))
    if 0 not in word:
        return ZERO

    runs: list[tuple[int, int]] = []
    start = 0
    while start < len(word):
        if word[start] != 0:
            start += 1
            continue
        end = start + 1
        while end < len(word) and word[end] == 0:
            end += 1
        if marginal(end - start):
            runs.append((start, end))
        start = end

    # Expanding the zero trace of the fully centered alternating product
    # expresses the full moment using nonempty sets of omitted scalar blocks.
    result = ZERO
    for count in range(1, len(runs) + 1):
        for omitted in combinations(runs, count):
            positions = {i for start, end in omitted for i in range(start, end)}
            coefficient = ONE if count % 2 else -ONE
            for start, end in omitted:
                coefficient *= marginal(end - start)
            remaining = tuple(x for i, x in enumerate(word) if i not in positions)
            result += coefficient * original_trace(remaining)
    return result


def normal_form(word: Word) -> CrossWord:
    prefix: Group = ()
    colors: list[Group] = []
    for letter in word:
        if letter == 0:
            colors.append(prefix)
        else:
            prefix = multiply(prefix, (letter,))
    return tuple(colors), prefix


def first_blocks(size: int):
    for count in range(size):
        for rest in combinations(range(1, size), count):
            yield (0,) + rest


def gaps(size: int, block: tuple[int, ...]):
    for index, position in enumerate(block):
        end = block[index + 1] if index + 1 < len(block) else size
        yield position + 1, end


@cache
def cumulant(size: int) -> Fraction:
    require(size >= 1, "Cumulants have positive order")
    result = marginal(size)
    for block in first_blocks(size):
        if len(block) == size:
            continue
        term = cumulant(len(block))
        for start, end in gaps(size, block):
            term *= marginal(end - start)
        result -= term
    return result


@cache
def colored_moment(pattern: tuple[int, ...]) -> Fraction:
    """Independent noncrossing first-block moment/cumulant recursion."""
    if not pattern:
        return ONE
    result = ZERO
    for block in first_blocks(len(pattern)):
        if any(pattern[i] != pattern[0] for i in block):
            continue
        term = cumulant(len(block))
        for start, end in gaps(len(pattern), block):
            term *= colored_moment(pattern[start:end])
        result += term
    return result


def conjugate_trace(word: CrossWord) -> Fraction:
    colors, label = word
    if label:
        return ZERO
    names: dict[Group, int] = {}
    pattern = tuple(names.setdefault(color, len(names)) for color in colors)
    return colored_moment(pattern)


def derive_original(polynomial: Polynomial, field: Field) -> Polynomial:
    result: Polynomial = {}
    for word, coefficient in polynomial.items():
        for position, letter in enumerate(word):
            if letter == 0:
                continue
            for group, value in field[abs(letter) - 1]:
                conjugate = group + (0,) + inverse(group)
                replacement = (
                    conjugate + (letter,)
                    if letter > 0
                    else (letter,) + conjugate
                )
                target = reduce_word(word[:position] + replacement + word[position + 1 :])
                add_term(result, target, coefficient * value * (1 if letter > 0 else -1))
    return result


@cache
def cocycle(group: Group, field: Field) -> tuple[tuple[Group, Fraction], ...]:
    result: dict[Group, Fraction] = {}
    prefix: Group = ()
    for letter in group:
        shift = prefix if letter > 0 else multiply(prefix, (letter,))
        for support, value in field[abs(letter) - 1]:
            add_term(
                result,
                multiply(shift, support),
                value * (1 if letter > 0 else -1),
            )
        prefix = multiply(prefix, (letter,))
    return tuple(sorted(result.items()))


def derive_crossed(polynomial: CrossPolynomial, field: Field) -> CrossPolynomial:
    result: CrossPolynomial = {}
    for (colors, label), coefficient in polynomial.items():
        for position, color in enumerate(colors):
            for support, value in cocycle(color, field):
                left = colors[:position] + (support, color) + colors[position + 1 :]
                right = colors[:position] + (color, support) + colors[position + 1 :]
                add_term(result, (left, label), coefficient * value)
                add_term(result, (right, label), -coefficient * value)
        for support, value in cocycle(label, field):
            add_term(result, (colors + (support,), label), coefficient * value)
    return result


def normalize_polynomial(polynomial: Polynomial) -> CrossPolynomial:
    result: CrossPolynomial = {}
    for word, coefficient in polynomial.items():
        add_term(result, normal_form(word), coefficient)
    return result


def conjugate_word(colors: Colors) -> Word:
    return reduce_word(tuple(x for g in colors for x in g + (0,) + inverse(g)))


def field_data(field: Field) -> list:
    return [
        [{"group": list(g), "coefficient": str(c)} for g, c in component]
        for component in field
    ]


def diagnostics() -> dict:
    fields: tuple[Field, ...] = (
        ((((), ONE),), ()),
        (
            (((), ONE), ((-1,), Fraction(-2, 3)), ((2, 1), Fraction(3, 2))),
            (((1,), -ONE), ((-2, 1), Fraction(2, 5))),
        ),
    )
    for field in fields:
        require(len(field) == 2, "The diagnostic model is F_2")
        for component in field:
            for group, coefficient in component:
                require(group == reduce_word(group), "Unreduced coefficient support")
                require(all(x in (-2, -1, 1, 2) for x in group), "Invalid group letter")
                require(isinstance(coefficient, Fraction), "Coefficients must be exact real rationals")

    require(original_trace((0, 0)) == Fraction(1, 3), "Uniform second moment")
    require(original_trace((0, 0, 0, 0)) == Fraction(1, 5), "Uniform fourth moment")
    require(original_trace((1, -1)) == ONE, "Group inverse cancellation")
    require(cumulant(2) == Fraction(1, 3), "Second cumulant")
    require(cumulant(4) == Fraction(-1, 45), "Fourth cumulant")
    require(cumulant(6) == Fraction(2, 945), "Sixth cumulant")
    require(colored_moment((0, 1, 0, 1)) == ZERO, "Crossing pairing is excluded")
    require(colored_moment((0, 0, 1, 1)) == Fraction(1, 9), "Free squared marginals")
    require(colored_moment((0, 1, 1, 0)) == Fraction(1, 9), "Nested pairing")

    alphabet = (-2, -1, 0, 1, 2)
    cases = {
        reduce_word(word): 2
        for length in range(4)
        for word in product(alphabet, repeat=length)
    }
    component_labels = ((), (1,), (2,))
    for colors in product(component_labels, repeat=3):
        cases.setdefault(conjugate_word(colors), 2)
    stress_colors: tuple[Colors, ...] = (
        ((1,), (1,), ()),
        ((1,), (2,), (1,)),
        ((1, 2), (-2,), (1, 2)),
        ((1,), (), (2,), (1,)),
        ((-1,), (2,), (-1,), (2,)),
        ((1,), (), (1,), (), (2,)),
    )
    for colors in stress_colors:
        cases[conjugate_word(colors)] = 3

    small_groups = sorted(
        {reduce_word(w) for size in range(3) for w in product((-2, -1, 1, 2), repeat=size)}
    )
    cocycle_checks = 0
    relation_checks = 0
    derivative_checks = 0
    nonidentity_derivative_checks = 0
    seen_moments: set[Word] = set()
    largest_derivative_polynomial = 0
    largest_t_degree = 0

    for field in fields:
        for generator in (1, 2):
            for relation in ((generator, -generator), (-generator, generator)):
                require(derive_original({relation: ONE}, field) == {}, "Unitary relation derivative")
                relation_checks += 1
        for left in small_groups:
            for right in small_groups:
                expected = dict(cocycle(left, field))
                for support, value in cocycle(right, field):
                    add_term(expected, multiply(left, support), value)
                require(
                    dict(cocycle(multiply(left, right), field)) == expected,
                    f"Cocycle orientation failed at {left}, {right}",
                )
                cocycle_checks += 1
        for word, maximum_order in sorted(cases.items()):
            original = {word: ONE}
            crossed = {normal_form(word): ONE}
            initial_label = normal_form(word)[1]
            for order in range(maximum_order + 1):
                require(
                    normalize_polynomial(original) == crossed,
                    f"Independent derivation mismatch: {word}, order {order}",
                )
                value = ZERO
                for term, coefficient in original.items():
                    normal = normal_form(term)
                    require(normal[1] == initial_label, "Derivation changed the group label")
                    if term not in seen_moments:
                        require(
                            original_trace(term) == conjugate_trace(normal),
                            f"Independent free-product moment mismatch: {term}",
                        )
                        seen_moments.add(term)
                    value += coefficient * original_trace(term)
                    largest_t_degree = max(largest_t_degree, term.count(0))
                largest_derivative_polynomial = max(largest_derivative_polynomial, len(original))
                if order:
                    require(value == ZERO, f"NONZERO TRACE WITNESS: {word}, order {order}: {value}")
                    derivative_checks += 1
                    if initial_label:
                        nonidentity_derivative_checks += 1
                if order < maximum_order:
                    original = derive_original(original, field)
                    crossed = derive_crossed(crossed, field)

    a, b = (1,), ()
    first = (
        original_trace(conjugate_word((b, a, a, b)))
        - original_trace(conjugate_word((a, b, a, b)))
    )
    second = (
        original_trace(conjugate_word((a, b, a, b)))
        - original_trace(conjugate_word((a, a, b, b)))
    )
    require(first == Fraction(1, 9) and second == Fraction(-1, 9), "Nontrivial insertion cancellation")
    require(first + second == ZERO, "Selected insertion trace")
    return {
        "model": "Original reduced free product C[F_2] * C[T], T uniform on [-1,1]",
        "fields": [field_data(field) for field in fields],
        "input_monomials_per_field": len(cases),
        "positive_derivative_trace_checks": derivative_checks,
        "nonidentity_label_derivative_checks": nonidentity_derivative_checks,
        "independent_exact_moments_compared": len(seen_moments),
        "independent_cocycle_checks": cocycle_checks,
        "unitary_relation_derivative_checks": relation_checks,
        "maximum_derivative_order": max(cases.values()),
        "maximum_normalized_variable_degree": largest_t_degree,
        "largest_derivative_polynomial_terms": largest_derivative_polynomial,
        "selected_insertion_traces": [str(first), str(second)],
        "postcondition": "Every tested derivative trace is exactly zero; two independent derivations and moment recursions agree.",
        "logical_role": "Finite adversarial diagnostics only, not the proof of the universal quantifiers.",
    }


def formal_evidence() -> dict:
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result["status"] == "success", "Lean compilation did not succeed")
    require(result["exit_code"] == 0, "Lean compiler exit status is not zero")
    require(result["proof_holes"] == [], "Lean source contains proof holes")
    require(result["audit_exit_code"] == 0, "Lean axiom audit failed")
    require(
        result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
        "The required Lean 4.31.0 compiler was not used",
    )
    source = (HERE / "Main.lean").read_text()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    source_digest = hashlib.sha256(source.encode()).hexdigest()
    fidelity_digest = hashlib.sha256(fidelity.encode()).hexdigest()
    require(result["source_sha256"] == source_digest, "Lean source changed after compilation")
    require(result["statement_fidelity_sha256"] == fidelity_digest, "Statement fidelity changed after compilation")
    verification = json.loads((HERE / "lean_verification.json").read_text())
    kernel = verification.pop("kernel")
    require(verification == result, "The recorded claim does not describe this compiler run")
    require(kernel["refusals"] == [], "The compiler result was refused by the ledger")
    recorded = kernel["recorded"]
    require(recorded["tier"] == "mechanical" and recorded["verdict"] == "supports", "No supporting mechanical evidence")
    require(recorded["subject"]["subject_id"] == "L_FLOW_ALGEBRA_CORE", "Wrong formal claim")
    root = HERE.parent.parent
    archived = json.loads((root / recorded["artifact"]).read_text())
    require(archived["subject"] == recorded["subject"], "Archived claim binding differs")
    require(archived["lean_check"] == result, "Archived compiler result differs")
    require(archived["lean_source"]["text"] == source, "Archived Lean source differs")
    require(archived["statement_fidelity"]["text"] == fidelity, "Archived fidelity differs")
    state = json.loads((root / "research" / "MATH_STATE.json").read_text())
    current = max(
        (claim for claim in state["claims"] if claim["claim_id"] == "L_FLOW_ALGEBRA_CORE"),
        key=lambda claim: claim["version"],
    )
    require(
        current["content_hash"] == recorded["subject"]["content_hash"],
        "The formal claim was revised after compilation",
    )
    return {
        "claim": "L_FLOW_ALGEBRA_CORE",
        "source": "Main.lean",
        "statement_fidelity": "statement_fidelity.md",
        "compiler_record": "lean_check.json",
        "archived_claim_certificate": recorded["artifact"],
        "compiler_version": "Lean 4.31.0",
        "source_sha256": source_digest,
        "statement_fidelity_sha256": fidelity_digest,
        "exit_code": 0,
        "proof_holes": [],
        "axiom_audit_exit_code": 0,
        "declarations": [
            "FlowTraceAudit.variation_split",
            "FlowTraceAudit.trace_comm_zero",
            "FlowTraceAudit.selected_trace_zero",
            "FlowTraceAudit.all_positive_iterates",
            "FlowTraceAudit.length_factor_le",
            "FlowTraceAudit.growth_bound",
        ],
        "coverage": "Arbitrary noncommutative ring, every finite word and position selection; all positive iterates; all natural-number Taylor growth parameters.",
        "not_formalized": "Freeness, reduced-centered-word spanning, operator-algebra realization, ODE existence and analytic continuation are proved in REPORT.md, not in Lean.",
    }


def jacobian_evidence() -> dict:
    directory = HERE / "jacobian"
    payload = json.loads((directory / "scalar_payload.json").read_text())
    result = json.loads((directory / "scalar_result.json").read_text())
    operation = "polynomial.ideal.normal_form.compute"
    require(result["request"]["operation_id"] == operation, "Wrong Jacobian operation")
    require(result["request"]["payload"] == payload, "Jacobian payload mismatch")
    output = result["result"]["output"]
    require(output["outcome"] == "COMPUTED", "Jacobian is incomplete, timed out, or failed")
    require(output["in_ideal"] is True, "Scalar telescoping relation failed")
    require(output["remainder"]["polynomial"]["terms"] == [], "Scalar remainder is nonzero")
    require(output["detail"] is None, "Jacobian reported an unexpected detail")
    return {
        "operation_id": operation,
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "payload_file": "jacobian/scalar_payload.json",
        "typed_output_file": "jacobian/scalar_result.json",
        "outcome": output["outcome"],
        "adapter_error": None,
        "timeout": False,
        "logical_role": "Auxiliary linear coefficient check for the two-factor telescoping step; no noncommutative freeness claim is delegated to a commutative operation.",
    }


def certificate() -> dict:
    formal = formal_evidence()
    jacobian = jacobian_evidence()
    finite = diagnostics()
    return {
        "result_kind": "all_degree_verification_with_prose_analytic_bridge",
        "target": "lem:flow-trace-identity and lem:flow-moments",
        "initial_trace_identity": "tau(ev_0(delta^r p)) = 0",
        "quantifiers": {
            "polynomial": "Every finite complex formal star polynomial, with no degree bound",
            "coefficients": "Every finite tuple of finitely supported real h_j on F_n",
            "derivative_order": "Every integer r >= 1",
            "time": "Every real t for the actual global unitary solution",
        },
        "normalization": "For a monomial of z-degree m, the manuscript derivative trace is i^r*pi^(m+r) times the normalized real-derivation trace. Extend by finite linearity.",
        "proof": {
            "report": "REPORT.md",
            "mechanism": "Group-label reduction, initial conjugate freeness, complementary inner-commutator insertion cancellation, positive iteration, and a time-uniform Taylor bound.",
            "circular_assumptions_used": [],
            "positive_time_freeness_assumed": False,
            "bounded_tests_used_to_infer_universality": False,
        },
        "formal_evidence": formal,
        "jacobian": jacobian,
        "finite_diagnostics": finite,
        "flawed_manuscript_assertion_identified": False,
        "headline_isomorphism_established": False,
        "novelty_status": "not_claimed",
        "independent_review": "required_from_host",
        "campaign_complete": False,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    computed = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(computed, indent=2, sort_keys=True) + "\n")
    require(json.loads(path.read_text()) == computed, "Exact certificate differs from deterministic replay")
    finite = computed["finite_diagnostics"]
    print(
        json.dumps(
            {
                "status": "verified",
                "all_degree_algebraic_core": "Lean, exit_code=0, proof_holes=[]",
                "derivative_trace_checks": finite["positive_derivative_trace_checks"],
                "independent_moments": finite["independent_exact_moments_compared"],
                "analytic_bridge": "Prose proof; independent review required",
                "campaign_complete": False,
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
