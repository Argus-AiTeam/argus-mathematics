#!/usr/bin/env python3
"""Verify the uniform left and right Schreier-defect induction."""

from __future__ import annotations

import argparse
from functools import lru_cache
import gzip
import importlib.util
import json
from pathlib import Path

from sage.all import (
    BraidGroup,
    FreeAlgebra,
    GF,
    PolynomialRing,
    QQ,
    matrix,
    sage_eval,
    vector,
)


HERE = Path(__file__).resolve().parent
CAMPAIGN = HERE.parents[2]
BASE_VERIFIER = HERE.parent / "verify_base_and_candidate_transversals.py"
Q4_ACTIONS = CAMPAIGN / "research/q4_orbit_scc/exact-left-right-actions.json.gz"
Q5_LEFT = HERE.parent / "q5_left_membership/q5-left-membership-certificate.json"
Q5_RIGHT = (
    HERE.parent / "q5_right_membership/q5-right-membership-certificate.json"
)
Q6_ACTION = (
    CAMPAIGN
    / "research/infinite_countermodel/parabolic_induction/radical_first_return"
    / "q6-quotient-q2-p101.pa"
)
Q6_TERMINAL = HERE / "q6-propagation-certificate.json"
JACOBIAN_OUTPUT = HERE / "jacobian-output-tail-inverse.json"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def d(index: int, rank: int) -> tuple[int, ...]:
    return tuple(range(index, rank))


def bar_d(index: int, rank: int) -> tuple[int, ...]:
    return tuple(range(rank - 1, index - 1, -1))


@lru_cache(maxsize=None)
def basis_labels(rank: int):
    if rank == 3:
        return (0, 1)
    return tuple(
        (index, lower)
        for index in range(rank, 0, -1)
        for lower in basis_labels(rank - 1)
    )


def add_scaled(target, source, scalar):
    for label, coefficient in source.items():
        value = target.get(label, 0) + scalar * coefficient
        if value:
            target[label] = value
        elif label in target:
            del target[label]


def scaled(source, scalar):
    result = {}
    add_scaled(result, source, scalar)
    return result


def singleton(label, coefficient):
    return {label: coefficient} if coefficient else {}


class DefectSystem:
    def __init__(self, q, base_defects):
        self.q = q
        self.base_defects = base_defects
        self.cache = {}
        self.calls_by_rank = {}

    def insertion(self, rank: int, cut: int, value):
        result = {}
        for label, coefficient in value.items():
            top, lower = label
            if cut == 0:
                add_scaled(
                    result,
                    singleton((1, label), coefficient),
                    1 - self.q,
                )
                add_scaled(
                    result,
                    singleton((top + 1, (1, lower)), coefficient),
                    self.q,
                )
            elif cut == rank - 1:
                add_scaled(
                    result,
                    singleton(
                        (top, (rank - 1, lower)), coefficient
                    ),
                    1,
                )
            elif top <= cut:
                add_scaled(
                    result,
                    singleton((top, (cut, lower)), coefficient),
                    1,
                )
            else:
                add_scaled(
                    result,
                    singleton((cut + 1, label), coefficient),
                    1 - self.q,
                )
                add_scaled(
                    result,
                    singleton(
                        (top + 1, (cut + 1, lower)), coefficient
                    ),
                    self.q,
                )
        unknown = set(result) - set(basis_labels(rank))
        if unknown:
            raise AssertionError(f"insertion produced invalid labels: {unknown}")
        return result

    def prepend(self, rank: int, top: int, value):
        return {(top, label): coefficient for label, coefficient in value.items()}

    def defect(self, rank: int, index: int, label):
        key = (rank, index, label)
        if key in self.cache:
            return self.cache[key]
        if rank == 4:
            result = dict(self.base_defects[(index, label)])
        else:
            top, lower = label
            if top < index:
                previous = self.defect(rank - 1, index - 1, lower)
                result = {}
                add_scaled(
                    result,
                    self.insertion(rank, top - 1, previous),
                    self.q**-1,
                )
                add_scaled(
                    result,
                    self.prepend(rank, top, previous),
                    (self.q - 1) / self.q,
                )
            elif top == index:
                result = {}
            else:
                previous = self.defect(rank - 1, index, lower)
                result = self.insertion(rank, top, previous)
        self.cache[key] = result
        self.calls_by_rank[rank] = self.calls_by_rank.get(rank, 0) + 1
        return result

    def defect_vector(self, rank: int, index: int, value):
        result = {}
        for label, coefficient in value.items():
            add_scaled(
                result,
                self.defect(rank, index, label),
                coefficient,
            )
        return result


class LeftActionSystem:
    def __init__(self, q, defects, base_actions):
        self.q = q
        self.defects = defects
        self.base_actions = base_actions
        self.cache = {}

    def act(self, rank: int, index: int, label):
        key = (rank, index, label)
        if key in self.cache:
            return self.cache[key]
        if rank == 3:
            result = dict(self.base_actions[(index, label)])
        else:
            top, lower = label
            if index < top - 1:
                result = self.defects.prepend(
                    rank, top, self.act(rank - 1, index, lower)
                )
            elif index == top - 1:
                result = singleton((top - 1, lower), self.q.parent().one())
            elif index == top:
                result = {
                    (top, lower): 1 - self.q,
                    (top + 1, lower): self.q,
                }
                add_scaled(
                    result,
                    self.defects.defect(rank, index, lower),
                    1,
                )
            else:
                result = self.defects.prepend(
                    rank, top, self.act(rank - 1, index - 1, lower)
                )
        self.cache[key] = result
        return result

    def act_vector(self, rank: int, index: int, value):
        result = {}
        for label, coefficient in value.items():
            add_scaled(result, self.act(rank, index, label), coefficient)
        return result

    def word(self, rank: int, indices):
        label = 0
        for current_rank in range(4, rank + 1):
            label = (current_rank, label)
        value = singleton(label, self.q.parent().one())
        for index in reversed(tuple(indices)):
            value = self.act_vector(rank, index, value)
        return value

    def polynomial(self, rank: int, index: int, value):
        first = self.act_vector(rank, index, value)
        second = self.act_vector(rank, index, first)
        result = dict(second)
        add_scaled(result, first, self.q - 1)
        add_scaled(result, value, -self.q)
        return result


def exact_q4_data(base, q_polynomial, q, field):
    with gzip.open(Q4_ACTIONS, "rt", encoding="utf-8") as stream:
        encoded = json.load(stream)
    actions = {
        name: base.decode_matrix(
            encoded["matrices"][name],
            field,
            q_polynomial.parent(),
            q_polynomial,
        )
        for name in ("L1", "L2", "L3", "R1", "R2", "R3")
    }
    left_generators = [actions[f"L{index}"] for index in range(1, 4)]
    right_generators = [actions[f"R{index}"] for index in range(1, 4)]
    left_e = base.exact_principal_record(
        "L", left_generators, q, field
    )["matrix"]
    right_e = base.exact_principal_record(
        "R", right_generators, q, field, opposite=True
    )["matrix"]
    unit = vector(field, [1] + [0] * 168)
    e_vector = left_e * unit
    if e_vector != right_e * unit:
        raise AssertionError("left and right regular actions disagree on e")

    left_core = [e_vector, left_generators[0] * e_vector]
    right_core = [e_vector, right_generators[1] * e_vector]
    left_vectors = {}
    right_vectors = {}
    for top in range(4, 0, -1):
        for core in (0, 1):
            left_vectors[(top, core)] = base.matrix_word_left(
                left_core[core], d(top, 4), left_generators
            )
            right_vectors[(top, core)] = base.matrix_word_right(
                right_core[core], bar_d(top, 4), right_generators
            )
    left_basis = matrix(
        field,
        [list(left_vectors[label]) for label in basis_labels(4)],
    ).transpose()
    right_basis = matrix(
        field,
        [list(right_vectors[label]) for label in basis_labels(4)],
    ).transpose()
    if left_basis.rank() != 8 or right_basis.rank() != 8:
        raise AssertionError("the exact recursive Q4 bases lost rank")

    identity = matrix.identity(field, 169, sparse=True)
    left_defects = {}
    right_defects = {}
    for index in range(1, 4):
        left_p = (
            (left_generators[index - 1] - identity)
            * (left_generators[index - 1] + q * identity)
        )
        right_p = (
            (right_generators[index - 1] - identity)
            * (right_generators[index - 1] + q * identity)
        )
        for core in (0, 1):
            left_target = left_p * base.matrix_word_left(
                left_core[core], d(index + 1, 4), left_generators
            )
            right_target = right_p * base.matrix_word_right(
                right_core[core], bar_d(index + 1, 4), right_generators
            )
            left_solution = left_basis.solve_right(left_target)
            right_solution = right_basis.solve_right(right_target)
            left_defects[(index, core)] = {
                label: coefficient
                for label, coefficient in zip(
                    basis_labels(4), left_solution
                )
                if coefficient
            }
            right_defects[(index, core)] = {
                label: coefficient
                for label, coefficient in zip(
                    basis_labels(4), right_solution
                )
                if coefficient
            }

    left_base_actions = {}
    right_base_actions = {}
    left_core_basis = matrix(
        field, [list(value) for value in left_core]
    ).transpose()
    right_core_basis = matrix(
        field, [list(value) for value in right_core]
    ).transpose()
    for index in (1, 2):
        for core in (0, 1):
            left_solution = left_core_basis.solve_right(
                left_generators[index - 1] * left_core[core]
            )
            right_solution = right_core_basis.solve_right(
                right_generators[index - 1] * right_core[core]
            )
            left_base_actions[(index, core)] = {
                label: coefficient
                for label, coefficient in zip((0, 1), left_solution)
                if coefficient
            }
            right_base_actions[(index, core)] = {
                label: coefficient
                for label, coefficient in zip((0, 1), right_solution)
                if coefficient
            }
    return {
        "left_defects": left_defects,
        "right_defects": right_defects,
        "left_base_actions": left_base_actions,
        "right_base_actions": right_base_actions,
        "left_basis": left_basis,
        "right_basis": right_basis,
        "left_vectors": left_vectors,
        "right_vectors": right_vectors,
        "left_generators": left_generators,
        "right_generators": right_generators,
        "e_vector": e_vector,
    }


def parse_coefficient(raw: str, q, field):
    return field(sage_eval(raw, locals={"q": q}))


def check_q5_right(right_defects, q, field):
    certificate = json.loads(Q5_RIGHT.read_text(encoding="utf-8"))
    labels = basis_labels(5)
    label_index = {label: index for index, label in enumerate(labels)}
    checked = 0
    for record in certificate["diagonal_targets"]["targets"]:
        input_label = basis_labels(4)[record["core_index"]]
        actual = right_defects.defect(5, record["k"], input_label)
        expected = {}
        for entry in record["coordinates"]:
            label = labels[entry["index"]]
            expected[label] = parse_coefficient(
                entry["coefficient"], q, field
            )
        if actual != expected:
            differing = sorted(
                label_index[label]
                for label in set(actual) | set(expected)
                if actual.get(label, 0) != expected.get(label, 0)
            )
            raise AssertionError(
                f"Q5 right target {(record['k'], record['core_index'])} "
                f"changed at coordinates {differing}"
            )
        checked += 1
    if checked != 32:
        raise AssertionError("not every exact Q5 right target was replayed")
    return checked


def check_q5_left(left_actions, q):
    e = left_actions.word(5, ())
    ce = left_actions.word(5, (3,))
    target = left_actions.polynomial(
        5, 4, {**ce, **{}}
    )
    add_scaled(target, left_actions.polynomial(5, 4, e), -1)

    pc = left_actions.word(5, (3, 4, 3, 3))
    add_scaled(pc, left_actions.word(5, (3, 4, 3)), q - 1)
    add_scaled(pc, left_actions.word(5, (3, 4)), -q)
    rhs = scaled(pc, (q - 1) / q)
    long = left_actions.word(5, (1, 2, 3, 4, 2, 3))
    add_scaled(long, left_actions.word(5, (2, 3, 4, 2, 3)), q)
    add_scaled(rhs, long, 1 - q)
    if target != rhs:
        raise AssertionError("the uniform recursion missed the exact Q5 left row")

    certificate = json.loads(Q5_LEFT.read_text(encoding="utf-8"))
    if certificate["exact_two_sided_membership"]["target_normal_form"] != "0":
        raise AssertionError("the prior exact Q5 left certificate changed")
    return {
        "target": certificate["claim"],
        "coordinate_support": len(
            certificate["schreier_span"]["nonzero_coordinates"]
        ),
        "uniform_formula_matches": True,
    }


def check_q6_displayed(left_actions, q):
    e = left_actions.word(6, ())
    ce = left_actions.word(6, (3,))
    d_ce_minus_e = left_actions.act_vector(6, 4, ce)
    add_scaled(
        d_ce_minus_e,
        left_actions.act_vector(6, 4, e),
        -1,
    )
    terminal = left_actions.polynomial(6, 5, d_ce_minus_e)
    terminal_rhs = {}
    terms = [
        (1 - q, (4, 5, 3)),
        ((q - 1) ** 2 / q, (4, 5, 4, 3)),
        ((q - 1) / q, (4, 5, 4, 4, 3)),
        (-(q - 1) / q, (3, 4, 5, 3, 4)),
        ((q - 1) ** 2 / q**2, (3, 4, 5, 3, 4, 3)),
        ((q - 1) / q**2, (3, 4, 5, 3, 4, 3, 3)),
        (1 - q, (2, 3, 4, 5, 3, 4, 2, 3)),
        (-(q - 1) / q, (1, 2, 3, 4, 5, 3, 4, 2, 3)),
    ]
    for coefficient, word in terms:
        add_scaled(
            terminal_rhs, left_actions.word(6, word), coefficient
        )
    if terminal != terminal_rhs:
        raise AssertionError("the exact eight-state Q6 terminal row changed")

    input_label = (3, (4, 0))
    crossing = left_actions.defects.defect(6, 2, input_label)
    crossing_rhs = {}
    crossing_terms = [
        (q**2 * (q - 1), (5, 4)),
        (-q * (q - 1) ** 2, (4, 5, 4)),
        (-(q - 1) / q, (1, 2, 3, 4, 5, 3, 4)),
        ((q - 1) / q, (1, 2, 3, 4, 5, 3, 4, 1)),
    ]
    for coefficient, word in crossing_terms:
        add_scaled(
            crossing_rhs, left_actions.word(6, word), coefficient
        )
    if crossing != crossing_rhs:
        raise AssertionError("the four-state Q6 crossing row changed")
    return {
        "terminal_support": len(terminal),
        "terminal_formula_terms": len(terms),
        "crossing_support": len(crossing),
        "crossing_formula_terms": len(crossing_terms),
    }


def braid_polynomial(group, field, q, prefix, index, suffix):
    result = {}
    for middle, coefficient in (
        ((index, index), field.one()),
        ((index,), q - 1),
        ((), -q),
    ):
        element = group(tuple(prefix) + middle + tuple(suffix))
        result[element] = result.get(element, 0) + coefficient
    return {element: value for element, value in result.items() if value}


def polynomial_equal(left, right):
    difference = dict(left)
    for element, coefficient in right.items():
        value = difference.get(element, 0) - coefficient
        if value:
            difference[element] = value
        elif element in difference:
            del difference[element]
    return not difference


def check_braid_templates(field, q):
    records = {}
    for rank in (4, 5, 6):
        group = BraidGroup(rank)
        schreier = 0
        right_schreier = 0
        diagonal = 0
        right_diagonal = 0
        for generator in range(1, rank):
            for top in range(1, rank + 1):
                left_word = (generator,) + d(top, rank)
                left = group(left_word)
                right_word = None
                if generator < top - 1:
                    right_word = d(top, rank) + (generator,)
                    right = group(right_word)
                    if left != right:
                        raise AssertionError("distant Schreier braid failed")
                elif generator == top - 1:
                    right_word = d(top - 1, rank)
                    if left != group(right_word):
                        raise AssertionError("Schreier insertion braid failed")
                elif generator == top:
                    left_polynomial = {left: field.one()}
                    right_polynomial = {}
                    add_scaled(
                        right_polynomial,
                        {group(d(top, rank)): field.one()},
                        1 - q,
                    )
                    add_scaled(
                        right_polynomial,
                        {group(d(top + 1, rank)): field.one()},
                        q,
                    )
                    add_scaled(
                        right_polynomial,
                        braid_polynomial(
                            group,
                            field,
                            q,
                            (),
                            generator,
                            d(top + 1, rank),
                        ),
                        1,
                    )
                    if not polynomial_equal(
                        left_polynomial, right_polynomial
                    ):
                        raise AssertionError(
                            "diagonal Schreier decomposition failed"
                        )
                    diagonal += 1
                    reversed_left_polynomial = {
                        group(tuple(reversed(left_word))): field.one()
                    }
                    reversed_right_polynomial = {}
                    add_scaled(
                        reversed_right_polynomial,
                        {
                            group(
                                tuple(reversed(d(top, rank)))
                            ): field.one()
                        },
                        1 - q,
                    )
                    add_scaled(
                        reversed_right_polynomial,
                        {
                            group(
                                tuple(reversed(d(top + 1, rank)))
                            ): field.one()
                        },
                        q,
                    )
                    for middle, coefficient in (
                        ((generator, generator), field.one()),
                        ((generator,), q - 1),
                        ((), -q),
                    ):
                        word = middle + d(top + 1, rank)
                        add_scaled(
                            reversed_right_polynomial,
                            {
                                group(
                                    tuple(reversed(word))
                                ): field.one()
                            },
                            coefficient,
                        )
                    if not polynomial_equal(
                        reversed_left_polynomial,
                        reversed_right_polynomial,
                    ):
                        raise AssertionError(
                            "right diagonal Schreier decomposition failed"
                        )
                    right_diagonal += 1
                elif generator > top:
                    right_word = d(top, rank) + (generator - 1,)
                    right = group(right_word)
                    if left != right:
                        raise AssertionError("Schreier slide braid failed")
                if right_word is not None:
                    reversed_left = group(tuple(reversed(left_word)))
                    reversed_right = group(tuple(reversed(right_word)))
                    if reversed_left != reversed_right:
                        raise AssertionError(
                            "right Schreier braid reversal failed"
                        )
                schreier += 1
                right_schreier += 1

        transport = 0
        right_transport = 0
        if rank >= 5:
            b = rank - 1
            for index in range(1, rank):
                for top in range(1, rank):
                    left = braid_polynomial(
                        group,
                        field,
                        q,
                        (),
                        index,
                        d(index + 1, rank) + d(top, rank - 1),
                    )
                    if top < index:
                        right = braid_polynomial(
                            group,
                            field,
                            q,
                            d(top, rank),
                            index - 1,
                            d(index, rank - 1) + (-b,),
                        )
                    elif top == index:
                        right = braid_polynomial(
                            group,
                            field,
                            q,
                            d(index + 1, rank) + d(index, rank - 1),
                            b,
                            (),
                        )
                    else:
                        right = braid_polynomial(
                            group,
                            field,
                            q,
                            d(top + 1, rank),
                            index,
                            d(index + 1, rank - 1) + (b,),
                        )
                    if not polynomial_equal(left, right):
                        raise AssertionError(
                            f"left defect transport failed: {(rank, index, top)}"
                        )
                    transport += 1

                    right_left = braid_polynomial(
                        group,
                        field,
                        q,
                        bar_d(top, rank - 1) + bar_d(index + 1, rank),
                        index,
                        (),
                    )
                    if top < index:
                        right_right = braid_polynomial(
                            group,
                            field,
                            q,
                            (-b,) + bar_d(index, rank - 1),
                            index - 1,
                            bar_d(top, rank),
                        )
                    elif top == index:
                        right_right = braid_polynomial(
                            group,
                            field,
                            q,
                            (),
                            b,
                            bar_d(index, rank - 1)
                            + bar_d(index + 1, rank),
                        )
                    else:
                        right_right = braid_polynomial(
                            group,
                            field,
                            q,
                            (b,) + bar_d(index + 1, rank - 1),
                            index,
                            bar_d(top + 1, rank),
                        )
                    if not polynomial_equal(right_left, right_right):
                        raise AssertionError(
                            f"right defect transport failed: "
                            f"{(rank, index, top)}"
                        )
                    right_transport += 1

        insertion = 0
        right_insertion = 0
        if rank >= 5:
            b = rank - 1
            for cut in range(0, rank):
                for top in range(1, rank):
                    if top <= cut:
                        left_word = (
                            d(cut + 1, rank)
                            + d(top, rank - 1)
                            + (b,)
                        )
                        right_word = d(top, rank) + d(cut, rank - 1)
                        if group(left_word) != group(right_word):
                            raise AssertionError("left insertion braid failed")
                        if group(tuple(reversed(left_word))) != group(
                            tuple(reversed(right_word))
                        ):
                            raise AssertionError("right insertion braid failed")
                    else:
                        left_word = d(cut + 1, rank) + d(top, rank - 1)
                        right_word = d(top + 1, rank) + d(cut + 1, rank)
                        if group(left_word) != group(right_word):
                            raise AssertionError(
                                "left insertion overlap braid failed"
                            )
                        if group(tuple(reversed(left_word))) != group(
                            tuple(reversed(right_word))
                        ):
                            raise AssertionError(
                                "right insertion overlap braid failed"
                            )
                    insertion += 1
                    right_insertion += 1
        records[str(rank)] = {
            "schreier_cases": schreier,
            "right_schreier_cases": right_schreier,
            "left_diagonal_decompositions": diagonal,
            "right_diagonal_decompositions": right_diagonal,
            "left_defect_transports": transport,
            "right_defect_transports": right_transport,
            "left_insertion_cases": insertion,
            "right_insertion_cases": right_insertion,
        }
    return records


def instantiate_symbolic_defects(system, rank: int):
    checked = 0
    maximum_support = 0
    valid = set(basis_labels(rank))
    for index in range(1, rank):
        for label in basis_labels(rank - 1):
            value = system.defect(rank, index, label)
            if set(value) - valid:
                raise AssertionError(
                    f"rank-{rank} symbolic defect left the Schreier family"
                )
            checked += 1
            maximum_support = max(maximum_support, len(value))
    return {
        "targets_checked": checked,
        "maximum_coordinate_support": maximum_support,
    }


def specialize(value, target, q_value):
    numerator = value.numerator()(QQ(q_value))
    denominator = value.denominator()(QQ(q_value))
    numerator_value = target(int(numerator.numerator())) / target(
        int(numerator.denominator())
    )
    denominator_value = target(int(denominator.numerator())) / target(
        int(denominator.denominator())
    )
    if not denominator_value:
        raise AssertionError("specialization denominator vanished")
    return numerator_value / denominator_value


def label_word(rank: int, label):
    if rank == 3:
        return () if label == 0 else (1,)
    top, lower = label
    return d(top, rank) + label_word(rank - 1, lower)


def check_q6_fiber(base, left_defects):
    action = base.parse_plain_action(Q6_ACTION)
    target_field = GF(101)
    generators = dict(zip(range(1, 6), action["actions"][:5]))
    identity = matrix.identity(target_field, 240, sparse=True)
    seed = action["images"].row(0) * action["actions"][6]

    def apply_word(value, word):
        result = value
        for index in reversed(tuple(word)):
            result *= generators[index]
        return result

    labels6 = basis_labels(6)
    vectors6 = {
        label: apply_word(seed, label_word(6, label)) for label in labels6
    }
    basis6 = matrix(
        target_field, [list(vectors6[label]) for label in labels6]
    )
    if basis6.rank() != 240:
        raise AssertionError("the recursive Q6 fiber states lost rank")

    checked = 0
    for index in range(1, 6):
        p = (
            (generators[index] - identity)
            * (generators[index] + target_field(2) * identity)
        )
        for input_label in basis_labels(5):
            value = apply_word(seed, label_word(5, input_label))
            actual = apply_word(value, d(index + 1, 6)) * p
            expected = vector(target_field, [0] * 240)
            for label, coefficient in left_defects.defect(
                6, index, input_label
            ).items():
                expected += specialize(coefficient, target_field, 2) * vectors6[
                    label
                ]
            if actual != expected:
                raise AssertionError(
                    f"Q6 fiber defect mismatch: {(index, input_label)}"
                )
            checked += 1
    if checked != 200:
        raise AssertionError("the Q6 fiber replay missed a defect")
    return {
        "field": "F_101",
        "q": 2,
        "recursive_state_rank": 240,
        "left_diagonal_targets_checked": checked,
        "all_equal": True,
        "scope": (
            "This exact finite-field replay checks every instantiated Q6 "
            "left formula. The all-rank conclusion comes from the symbolic "
            "braid/tail induction, not from this finite fiber."
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=HERE / "uniform-defect-propagation-certificate.json",
    )
    args = parser.parse_args()
    if args.output.resolve().parent != HERE:
        raise SystemExit("output must stay in the mission directory")

    polynomial_ring = PolynomialRing(QQ, "q")
    q_polynomial = polynomial_ring.gen()
    field = polynomial_ring.fraction_field()
    q = field(q_polynomial)
    base = load_module("principal_base_verifier", BASE_VERIFIER)
    exact = exact_q4_data(base, q_polynomial, q, field)
    left_defects = DefectSystem(q, exact["left_defects"])
    right_defects = DefectSystem(q, exact["right_defects"])
    left_actions = LeftActionSystem(
        q, left_defects, exact["left_base_actions"]
    )

    q5_right_count = check_q5_right(right_defects, q, field)
    q5_left = check_q5_left(left_actions, q)
    q6_displayed = check_q6_displayed(left_actions, q)
    q6_left_symbolic = instantiate_symbolic_defects(left_defects, 6)
    q6_right_symbolic = instantiate_symbolic_defects(right_defects, 6)
    braid_templates = check_braid_templates(field, q)
    q6_fiber = check_q6_fiber(base, left_defects)

    q6_terminal = json.loads(Q6_TERMINAL.read_text(encoding="utf-8"))
    if q6_terminal["exact_membership"]["target_normal_form"] != "0":
        raise AssertionError("the independent exact Q6 terminal proof changed")
    jacobian = json.loads(JACOBIAN_OUTPUT.read_text(encoding="utf-8"))
    typed = jacobian["result"]["output"]
    if typed["classification"] != "UNIQUE":
        raise AssertionError("the Jacobian tail-inverse solve changed")

    certificate = {
        "schema": "uniform-schreier-defect-propagation-v1",
        "status": "passed",
        "coefficient_field": "Q(q)",
        "theorem": {
            "left": "Q_n e=L_n for every n>=4",
            "right": "e Q_n=R_n for every n>=4",
            "principal_bounds": [
                "dim Q_n e <= n!/3",
                "dim e Q_n <= n!/3",
            ],
            "ideal_bound": "dim Q_n e Q_n <= (n!/3)^2",
            "quotient_bound": (
                "dim Q_n <= (2n-1)!!+(n!/3)^2"
            ),
            "repairs": ["truncated", "direct-limit terminal-row"],
        },
        "uniform_formulas": {
            "defect": "D_k^(n)(v)=P(sigma_k)d_(k+1)^(n)v",
            "input": "v=d_j^(n-1)u, u in L_(n-2)",
            "j_less_k": (
                "q^-1 C_(j-1)(D_(k-1)^(n-1)(u))"
                "+(q-1)q^-1 d_j^(n)D_(k-1)^(n-1)(u)"
            ),
            "j_equal_k": "0",
            "j_greater_k": "C_j(D_k^(n-1)(u))",
            "insertion_l_le_j": (
                "C_j(d_l^(n-1)u)=d_l^(n)d_j^(n-1)u"
            ),
            "insertion_l_gt_j": (
                "C_j(d_l^(n-1)u)=(1-q)d_(j+1)^(n)"
                "d_l^(n-1)u+q d_(l+1)^(n)d_(j+1)^(n-1)u"
            ),
            "right": (
                "bar(D)_k^(n)(u bar(d)_j^(n-1)) has the same j<k, "
                "j=k, j>k formulas with bar(C)_j(A)="
                "sigma_(n-1) A bar(d)_(j+1)^(n)"
            ),
            "right_insertion_l_le_j": (
                "bar(C)_j(u bar(d)_l^(n-1))="
                "u bar(d)_j^(n-1) bar(d)_l^(n)"
            ),
            "right_insertion_l_gt_j": (
                "bar(C)_j(u bar(d)_l^(n-1))=(1-q)"
                "u bar(d)_l^(n-1) bar(d)_(j+1)^(n)"
                "+q u bar(d)_(j+1)^(n-1) bar(d)_(l+1)^(n)"
            ),
        },
        "termination": {
            "measure": (
                "(maximum rank of the unique marked defect, unresolved "
                "defect count) in lexicographic order"
            ),
            "strict_decrease": (
                "Every nonzero defect formula calls only a rank-(n-1) "
                "defect. Insertion formulas create no marked defect; the "
                "equal-index branch is zero. The process reaches the exact "
                "rank-four action table after at most n-4 calls."
            ),
        },
        "exact_q4_base": {
            "left_basis_rank": int(exact["left_basis"].rank()),
            "right_basis_rank": int(exact["right_basis"].rank()),
            "left_base_defects": len(exact["left_defects"]),
            "right_base_defects": len(exact["right_defects"]),
        },
        "q5_replay": {
            "left": q5_left,
            "right_targets_checked": q5_right_count,
            "right_certificate_match": True,
        },
        "q6_replay": {
            "displayed_exact_formulas": q6_displayed,
            "left_symbolic": q6_left_symbolic,
            "right_symbolic": q6_right_symbolic,
            "independent_terminal_original_row_normal_form": "0",
            "fiber": q6_fiber,
        },
        "critical_pair_replay": braid_templates,
        "jacobian": {
            "server_version": jacobian["server"]["version"],
            "protocol_version": jacobian["protocol_version"],
            "operation_id": jacobian["result"]["operation_id"],
            "classification": typed["classification"],
            "runtime_ms": jacobian["result"]["runtime_ms"],
            "exact_payload": str(
                (HERE / "jacobian-payload-tail-inverse.json").relative_to(
                    CAMPAIGN
                )
            ),
            "typed_output": str(JACOBIAN_OUTPUT.relative_to(CAMPAIGN)),
            "adapter_error": None,
            "adapter_timeout": False,
        },
        "scope": (
            "The all-rank result is a symbolic induction from exact Q4 "
            "left/right action and the common tail quadratic row. The finite "
            "Q6 action is only an exhaustive replay of the instantiated "
            "left formulas. No novelty claim is made."
        ),
    }
    args.output.write_text(
        json.dumps(certificate, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    print(
        json.dumps(
            {
                "status": certificate["status"],
                "q5_right_targets": q5_right_count,
                "q6_left_targets": q6_fiber[
                    "left_diagonal_targets_checked"
                ],
                "left_bound": certificate["theorem"]["principal_bounds"][0],
                "right_bound": certificate["theorem"]["principal_bounds"][1],
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
