#!/usr/bin/env python3
"""Exact finite canceled-anchor replays; not a universal or probabilistic proof.

Run ``python research/shifted_tree_core/verify.py`` to check the persisted
certificate, or add ``--write-certificate`` to regenerate it.  Only Python's
standard library is used.  Old leaves remain individually labeled, unary
vertices are retained, and a fresh child has one canonical new index, not
an artificial multiplicity from its possible names.
"""

from __future__ import annotations

import argparse
import json
import math
import sys
import time
from collections import Counter
from dataclasses import dataclass, field
from fractions import Fraction
from pathlib import Path
from typing import Any


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "exact_certificate.json"
PathTuple = tuple[int, ...]


def branch(depth: int, *children: Any) -> dict[str, Any]:
    return {"depth": depth, "children": list(children)}


def default_fixtures() -> list[dict[str, Any]]:
    definitions = [
        ("binary", 7, 1, branch(3, "a", "b"),
         [("a", ["b"], ["a", "b"]), ("b", ["a"], ["b", "a"])]),
        ("ternary", 7, 1, branch(3, "a", "b", "c"),
         [("a", ["b", "c"], ["a", "b", "c"]),
          ("c", ["b", "a"], ["b", "c", "a"])]),
        ("nested", 8, 1, branch(3, "a", branch(5, "b", "c")),
         [("a", ["b", "c"], ["a", "b", "c"]),
          ("c", ["a", "b"], ["b", "a", "c"])]),
        ("sibling_equal_depth", 8, 1,
         branch(3, branch(5, "a", "b"), branch(5, "c", "d")),
         [("a", ["c", "b", "d"], ["d", "a", "c", "b"]),
          ("d", ["b", "c", "a"], ["b", "d", "a", "c"])]),
        ("quaternary", 7, 1, branch(3, "a", "b", "c", "d"),
         [("a", ["b", "c", "d"], ["a", "b", "c", "d"]),
          ("d", ["b", "a", "c"], ["c", "a", "d", "b"])]),
        ("root_separation_adjacent_split", 4, 0, branch(1, "a", "b"),
         [("b", ["a"], ["a", "b"])]),
        ("deep_comb_five", 10, 0,
         branch(1, "a", branch(4, "b", branch(7, "c", "d", "e"))),
         [("e", ["b", "a", "c", "d"], ["c", "e", "b", "a", "d"])]),
        ("mixed_five", 11, 0,
         branch(2, branch(5, "a", "b"), branch(7, "c", "d"), "e"),
         [("b", ["d", "e", "a", "c"], ["e", "c", "b", "d", "a"])]),
    ]
    for L in (8, 16, 32, 64):
        definitions.append((
            f"shallow_ternary_L{L}", L, 0, branch(1, "a", "b", "c"),
            [("c", ["a", "b"], ["b", "a", "c"])],
        ))
    return [
        {
            "name": f"{name}_order_{index + 1}",
            "L": L,
            "d": d,
            "S": shape,
            "anchor_label": anchor,
            "I_order": first,
            "II_order": second,
        }
        for name, L, d, shape, orders in definitions
        for index, (anchor, first, second) in enumerate(orders)
    ]


def common_prefix(first: PathTuple, second: PathTuple) -> int:
    for depth, (left, right) in enumerate(zip(first, second)):
        if left != right:
            return depth
    return min(len(first), len(second))


def topology(shape: Any, address: PathTuple = ()) -> tuple[list[str], list[dict]]:
    if isinstance(shape, str):
        if not shape or shape.startswith("@"):
            raise ValueError("Leaf labels must be nonempty and not start with @.")
        return [shape], []
    if not isinstance(shape, dict) or set(shape) != {"depth", "children"}:
        raise ValueError("A branch needs exactly depth and children.")
    if type(shape["depth"]) is not int or len(shape["children"]) < 2:
        raise ValueError("Branch depths must be integers and arity must be >= 2.")
    labels = []
    vertices = [{
        "address": list(address),
        "depth": shape["depth"],
        "arity": len(shape["children"]),
    }]
    for index, child in enumerate(shape["children"]):
        child_labels, child_vertices = topology(child, address + (index,))
        labels.extend(child_labels)
        vertices.extend(child_vertices)
    return labels, vertices


def copy_paths(shape: Any, stem: PathTuple, L: int, shift: int) -> dict[str, PathTuple]:
    if isinstance(shape, str):
        if len(stem) > L:
            raise ValueError("A leaf extends past depth L.")
        return {shape: stem + (0,) * (L - len(stem))}
    depth = shape["depth"] + shift
    if not len(stem) <= depth < L:
        raise ValueError("Branch depths must increase and stay strictly below L.")
    prefix = stem + (0,) * (depth - len(stem))
    result = {}
    for index, child in enumerate(shape["children"]):
        result.update(copy_paths(child, prefix + (index,), L, shift))
    return result


def internal_vertices(leaves: tuple[PathTuple, ...]) -> dict[PathTuple, tuple[int, ...]]:
    children: dict[PathTuple, set[int]] = {}
    for leaf in leaves:
        for depth, child in enumerate(leaf):
            children.setdefault(leaf[:depth], set()).add(child)
    result = {}
    for prefix in sorted(children):
        indices = tuple(sorted(children[prefix]))
        if indices != tuple(range(len(indices))):
            raise ValueError("The canonical child indices are not contiguous.")
        result[prefix] = indices
    return result


@dataclass
class RetainedNode:
    marks: list[str] = field(default_factory=list)
    children: dict[int, RetainedNode] = field(default_factory=dict)


def retained_skeleton(old: dict[str, PathTuple], prefix: PathTuple) -> tuple[tuple, int]:
    root = RetainedNode()
    for mark, path in [*old.items(), ("@first_II_prefix", prefix)]:
        vertex = root
        for child in path:
            vertex = vertex.children.setdefault(child, RetainedNode())
        vertex.marks.append(mark)

    def canonical(vertex: RetainedNode) -> tuple[tuple, int]:
        below = [canonical(child) for child in vertex.children.values()]
        # Forget child names, but retain every unary vertex and all old labels.
        return (
            (tuple(sorted(vertex.marks)), tuple(sorted(tree for tree, _ in below))),
            1 + sum(count for _, count in below),
        )

    return canonical(root)


def compact(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=True)


@dataclass(frozen=True)
class Choice:
    path: PathTuple
    numerator: int
    old_label: str | None = None
    vertex: PathTuple | None = None
    child_count: int | None = None

    def describe(self, color: str, L: int) -> dict[str, Any]:
        result = {
            "color": color,
            "kind": "old" if self.old_label is not None else "fresh",
            "path": list(self.path),
            "coefficient": str(Fraction(self.numerator, L)),
        }
        if self.old_label is not None:
            result["old_leaf"] = self.old_label
        else:
            result.update({
                "vertex": list(self.vertex),
                "divergence_depth": len(self.vertex),
                "child_count_before": self.child_count,
                "new_child_index": self.child_count,
            })
        return result


class Budget:
    def __init__(self) -> None:
        self.started = time.monotonic()

    def check(self) -> None:
        if time.monotonic() - self.started > 100:
            raise TimeoutError("The finite replay exceeded its 100-second run guard.")


def replay(definition: dict[str, Any], budget: Budget) -> dict[str, Any]:
    budget.check()
    L, d, shape = definition["L"], definition["d"], definition["S"]
    labels, vertices = topology(shape)
    if len(set(labels)) != len(labels):
        raise ValueError("S must have distinct leaf labels.")
    if type(L) is not int or type(d) is not int or not 0 <= d < shape["depth"] < L:
        raise ValueError("A fixture requires 0 <= d < e < L.")
    e = shape["depth"]
    anchor_label = definition["anchor_label"]
    if anchor_label not in labels:
        raise ValueError("The anchor must be an old leaf of copy I.")
    first, second = definition["I_order"], definition["II_order"]
    if sorted(first) != sorted(label for label in labels if label != anchor_label):
        raise ValueError("I_order must list all non-anchor labels exactly once.")
    if sorted(second) != sorted(labels):
        raise ValueError("II_order must list every label exactly once.")
    old_depths = {d, *(vertex["depth"] for vertex in vertices)}
    shifted_depths = {vertex["depth"] + 1 for vertex in vertices}
    if not old_depths.isdisjoint(shifted_depths):
        raise ValueError("The charging fixtures require shifted depths away from old splits.")

    old: dict[str, PathTuple] = {}
    target: dict[str, PathTuple] = {}
    for side, index in (("I", 0), ("II", 1)):
        stem = (0,) * d + (index,)
        old.update({
            f"{side}:{label}": path
            for label, path in copy_paths(shape, stem, L, 0).items()
        })
        target.update({
            f"{side}:{label}": path
            for label, path in copy_paths(shape, stem, L, 1).items()
        })
    anchor_name = f"I:{anchor_label}"
    colors = [f"I:{label}" for label in first] + [f"II:{label}" for label in second]
    reference_names = [anchor_name, *colors]
    k = len(colors)
    q_old = len(old)
    b = 2 * len(vertices)
    if not b <= k or q_old != 2 * len(labels) or k != 2 * len(labels) - 1:
        raise ValueError("Invalid fixture leaf or branch counts.")
    required = [
        [common_prefix(target[color], target[previous])
         for previous in reference_names[:step + 1]]
        for step, color in enumerate(colors)
    ]
    initial_leaves = tuple(old.values())
    old_set = frozenset(initial_leaves)
    initial_vertices = internal_vertices(initial_leaves)
    old_II_stem = old[f"II:{labels[0]}"][:e]
    first_II_step = len(first)
    denominator = L ** k
    kappa = Fraction(1)
    for vertex in vertices:
        depth = vertex["depth"] + 1
        for j in range(1, vertex["arity"]):
            kappa *= Fraction(depth - j * (depth + 1), L)
    J = kappa * kappa
    expected_total = -J / L

    class_names = [f"fresh_{ell}" for ell in range(d, e)] + ["old_prefix"]
    expected_prefixes = {
        f"fresh_{ell}": old_II_stem[:ell]
        + (len(initial_vertices[old_II_stem[:ell]]),)
        + (0,) * (e - ell - 1)
        for ell in range(d, e)
    }
    expected_prefixes["old_prefix"] = old_II_stem
    expected_skeletons = {
        name: retained_skeleton(old, prefix)
        for name, prefix in expected_prefixes.items()
    }
    totals = {
        name: {
            "signed_numerator": 0,
            "absolute_numerator": 0,
            "history_count": 0,
            "old_reuse_history_count": 0,
            "canonical_skeletons": set(),
            "raw_prefixes": set(),
        }
        for name in class_names
    }
    counters = Counter()
    counters["maximum_current_arity"] = max(map(len, initial_vertices.values()))
    reused_witness = None
    late_reuse_witness = None
    first_failure = None
    skeleton_cache: dict[PathTuple, tuple[tuple, int]] = {}
    reuse_pairs: Counter[tuple[str, str]] = Counter()
    positive_mass = Fraction(0)

    def fail(message: str, history: tuple[Choice, ...], extra: Any = None) -> None:
        nonlocal first_failure
        if first_failure is None:
            first_failure = {
                "message": message,
                "history": [choice.describe(color, L)
                            for color, choice in zip(colors, history)],
                "details": extra,
            }

    def search(
        leaves: tuple[PathTuple, ...],
        references: tuple[PathTuple, ...],
        used_old: frozenset[PathTuple],
        numerator: int,
        history: tuple[Choice, ...],
        first_II_path: PathTuple | None,
        class_name: str | None,
    ) -> None:
        nonlocal reused_witness, late_reuse_witness, positive_mass
        counters["history_prefixes_visited"] += 1
        if counters["history_prefixes_visited"] % 256 == 0:
            budget.check()
        step = len(history)
        if not old_set.issubset(leaves) or len(set(leaves)) != len(leaves):
            raise ValueError("An old leaf disappeared or a leaf was duplicated.")
        if step == k:
            counters["finite_history_count"] += 1
            for i, left in enumerate(references):
                for j, right in enumerate(references[:i]):
                    if common_prefix(left, right) != common_prefix(
                        target[reference_names[i]], target[reference_names[j]]
                    ):
                        fail("The final reference tree violates a prescribed split.", history)
            if len(set(references)) != len(references) or references[0] != old[anchor_name]:
                raise ValueError("A protected reference was selected again.")
            if first_II_path is None or class_name is None:
                raise ValueError("The first target-II path was not classified.")
            row = totals[class_name]
            row["signed_numerator"] += numerator
            row["absolute_numerator"] += abs(numerator)
            row["history_count"] += 1
            prefix = first_II_path[:e]
            if prefix not in skeleton_cache:
                skeleton_cache[prefix] = retained_skeleton(old, prefix)
            skeleton, node_count = skeleton_cache[prefix]
            row["canonical_skeletons"].add(skeleton)
            row["raw_prefixes"].add(prefix)
            if (skeleton, node_count) != expected_skeletons[class_name]:
                fail(
                    "The retained old paths plus first-II prefix vary within a class.",
                    history,
                    {"class": class_name, "actual_skeleton": skeleton,
                     "expected_skeleton": expected_skeletons[class_name][0]},
                )
            old_steps = [i for i, choice in enumerate(history)
                         if choice.old_label is not None]
            weight = Fraction(numerator, denominator)
            if old_steps:
                if len(old_steps) != 1:
                    fail("More than one target path reuses an old leaf.", history)
                chosen = old_steps[0]
                pair = (colors[chosen], history[chosen].old_label)
                reuse_pairs[pair] += 1
                if not all(name.startswith("II:") for name in pair):
                    fail("An old selection is outside target side II.", history)
                if weight != J:
                    fail("A one-reuse history does not have coefficient J.", history,
                         {"actual": str(weight), "J": str(J)})
                positive_mass += weight
            elif weight >= 0:
                fail("A zero-reuse history does not have negative coefficient.", history)
            counters["old_selections_over_completed_histories"] += len(old_steps)
            counters["maximum_old_choices_in_one_history"] = max(
                counters["maximum_old_choices_in_one_history"], len(old_steps)
            )
            if old_steps:
                row["old_reuse_history_count"] += 1
                counters["old_reuse_history_count"] += 1
            late_reuse = any(i > first_II_step for i in old_steps)
            counters["old_reuse_after_first_II_history_count"] += int(late_reuse)
            if (old_steps and reused_witness is None) or (
                late_reuse and late_reuse_witness is None
            ):
                witness = {
                    "class": class_name,
                    "signed_coefficient": str(Fraction(numerator, denominator)),
                    "choices": [choice.describe(color, L)
                                for color, choice in zip(colors, history)],
                }
                if old_steps and reused_witness is None:
                    reused_witness = witness
                if late_reuse and late_reuse_witness is None:
                    late_reuse_witness = witness
            return

        current_vertices = internal_vertices(leaves)
        if step == first_II_step:
            for ell in range(d, e):
                vertex = old_II_stem[:ell]
                if current_vertices[vertex] != initial_vertices[vertex]:
                    fail("Target-I additions changed an old-II stem child count.", history)

        def compatible(path: PathTuple) -> bool:
            return all(
                common_prefix(path, reference) == split
                for reference, split in zip(references, required[step])
            )

        # All unused old leaves and all internal vertices are considered.
        # In particular, unused old branches are never pruned from the tree.
        choices = []
        for old_label, path in old.items():
            if path not in used_old:
                counters["old_leaf_candidates_examined"] += 1
                if compatible(path):
                    choices.append(Choice(path, L, old_label=old_label))
                    counters["compatible_old_choices"] += 1
        for vertex, children in current_vertices.items():
            counters["fresh_vertex_candidates_examined"] += 1
            depth, n = len(vertex), len(children)
            path = vertex + (n,) + (0,) * (L - depth - 1)
            if compatible(path):
                choices.append(Choice(
                    path, depth - n * (depth + 1), vertex=vertex, child_count=n
                ))
                counters["compatible_fresh_choices"] += 1
                counters["maximum_current_arity"] = max(
                    counters["maximum_current_arity"], n + 1
                )
        for choice in choices:
            new_history = history + (choice,)
            new_class, new_first_II = class_name, first_II_path
            if step == first_II_step:
                new_first_II = choice.path
                if choice.path[:e] == old_II_stem:
                    new_class = "old_prefix"
                else:
                    ell = common_prefix(choice.path, old_II_stem)
                    if not d <= ell < e:
                        raise ValueError("A first-II path has no permitted prefix class.")
                    new_class = f"fresh_{ell}"
                    expected_numerator = -(d + 2) if ell == d else -1
                    if (choice.old_label is not None
                            or choice.vertex != old_II_stem[:ell]
                            or choice.numerator != expected_numerator):
                        fail("A fresh prefix class has the wrong one-step coefficient.",
                             new_history)
            if choice.old_label is not None:
                new_leaves = leaves
                new_used_old = used_old | {choice.path}
            else:
                if choice.path in leaves:
                    raise ValueError("A purported fresh leaf already exists.")
                new_leaves = leaves + (choice.path,)
                new_used_old = used_old
            search(
                new_leaves, references + (choice.path,), new_used_old,
                numerator * choice.numerator, new_history, new_first_II, new_class,
            )

    search(initial_leaves, (old[anchor_name],), frozenset({old[anchor_name]}),
           1, (), None, None)

    signed_mass = sum(
        (Fraction(row["signed_numerator"], denominator) for row in totals.values()),
        Fraction(0),
    )
    absolute_mass = sum(
        (Fraction(row["absolute_numerator"], denominator) for row in totals.values()),
        Fraction(0),
    )
    charging_bound = Fraction(
        math.factorial(k) // math.factorial(k - b)
        * (q_old + k) ** b * (2 * (q_old + k)) ** (k - b),
        L ** b,
    )
    failures = []
    class_results = []
    for name in class_names:
        row = totals[name]
        ell = int(name.removeprefix("fresh_")) if name != "old_prefix" else None
        factor = Fraction(e, L) if ell is None else -Fraction(
            d + 2 if ell == d else 1, L
        )
        expected = factor * J
        actual = Fraction(row["signed_numerator"], denominator)
        absolute = Fraction(row["absolute_numerator"], denominator)
        skeleton, node_count = expected_skeletons[name]
        fixed = row["canonical_skeletons"] == {skeleton}
        if actual != expected:
            failures.append({
                "literal_assertion": (
                    "The fresh class at ell has total coefficient -c_ell J."
                    if ell is not None else
                    "The remaining prefix-through-e class has coefficient m_e J."
                ),
                "class": name,
                "expected": str(expected),
                "actual": str(actual),
            })
        if not fixed:
            failures.append({
                "literal_assertion": "The retained tree depends only on the class.",
                "class": name,
                "distinct_canonical_skeletons": len(row["canonical_skeletons"]),
            })
        class_results.append({
            "class": name,
            "divergence_depth": ell,
            "expected_factor_times_J": str(factor),
            "expected_signed_mass": str(expected),
            "signed_mass": str(actual),
            "absolute_mass": str(absolute),
            "normalized_signed_mass": str(actual / J),
            "normalized_absolute_mass": str(absolute / abs(J)),
            "history_count": row["history_count"],
            "old_reuse_history_count": row["old_reuse_history_count"],
            "retained_skeleton": {
                "fixed_within_class": fixed,
                "distinct_canonical_skeletons": len(row["canonical_skeletons"]),
                "distinct_child_index_prefixes": len(row["raw_prefixes"]),
                "checked_history_count": row["history_count"],
                "expected_representative_prefix": list(expected_prefixes[name]),
                "canonical_tree": json.loads(compact(skeleton)),
                "vertex_count_including_unary_vertices": node_count,
                "retained_old_leaf_count": q_old,
                "first_II_prefix_depth": e,
            },
        })
    if signed_mass != expected_total:
        failures.append({
            "literal_assertion": "The total coefficient is -delta J.",
            "expected": str(expected_total), "actual": str(signed_mass),
        })
    if absolute_mass > charging_bound:
        failures.append({
            "literal_assertion": "The charging fresh splits bound holds.",
            "bound": str(charging_bound), "actual_absolute_mass": str(absolute_mass),
        })
    expected_pairs = {
        (f"II:{color}", f"II:{old_label}") for color in labels for old_label in labels
    }
    if set(reuse_pairs) != expected_pairs or any(n != 1 for n in reuse_pairs.values()):
        failures.append({
            "assertion": "One-reuse histories are in bijection with old-II leaf / target-II color pairs.",
            "actual_pairs": [[*pair, count] for pair, count in sorted(reuse_pairs.items())],
        })
    exact_normalized_mass = 2 * len(labels) ** 2 + Fraction(1, L)
    if absolute_mass / J != exact_normalized_mass:
        failures.append({
            "assertion": "The exact normalized absolute mass is 2*s^2+delta.",
            "expected": str(exact_normalized_mass),
            "actual": str(absolute_mass / J),
        })
    if first_failure is not None:
        failures.append(first_failure)
    if counters["finite_history_count"] == 0:
        raise ValueError("The prescribed target has no finite extension histories.")
    if reused_witness is None or late_reuse_witness is None:
        raise ValueError("A required old-leaf-reuse coverage check was not exercised.")

    return {
        "name": definition["name"],
        "status": "finite_checks_passed" if not failures else "finite_mismatch",
        "e": e,
        "q_old": q_old,
        "colors": k,
        "b": b,
        "branch_vertices_of_S": vertices,
        "shifted_branch_depth_multiplicities_in_two_target_copies": {
            str(depth): 2 * sum(vertex["depth"] + 1 == depth for vertex in vertices)
            for depth in sorted(shifted_depths)
        },
        "old_leaf_paths": {label: list(path) for label, path in old.items()},
        "target_leaf_paths_for_split_constraints_only": {
            label: list(path) for label, path in target.items()
        },
        "anchor": anchor_name,
        "color_order": colors,
        "required_splits_with_anchor_and_earlier_colors": required,
        "kappa_S_plus": str(kappa),
        "J": str(J),
        "common_history_weight_denominator": str(denominator),
        "first_II_class_totals": class_results,
        "signed_mass": str(signed_mass),
        "expected_signed_mass": str(expected_total),
        "absolute_mass": str(absolute_mass),
        "normalized_signed_mass": str(signed_mass / J),
        "normalized_absolute_mass": str(absolute_mass / abs(J)),
        "charging_bound": str(charging_bound),
        "charging_bound_holds": absolute_mass <= charging_bound,
        "normalized_charging_bound": str(charging_bound / abs(J)),
        "exact_mass_normal_form": {
            "one_reuse_histories": [
                {"target_color": color, "old_leaf": old_leaf, "count": count}
                for (color, old_leaf), count in sorted(reuse_pairs.items())
            ],
            "expected_one_reuse_count": len(labels) ** 2,
            "one_reuse_coefficient": str(J),
            "positive_mass": str(positive_mass),
            "negative_absolute_mass": str(positive_mass - signed_mass),
            "expected_normalized_absolute_mass": str(exact_normalized_mass),
            "exact_normalized_identity_holds": absolute_mass / J == exact_normalized_mass,
        },
        "old_leaf_reuse": {
            "occurs": reused_witness is not None,
            "after_first_II_occurs": late_reuse_witness is not None,
            "witness": reused_witness,
            "after_first_II_witness": late_reuse_witness,
        },
        "enumeration_counts": dict(sorted(counters.items())),
        "failures": failures,
    }


def reference_free_cases() -> list[dict[str, Any]]:
    return [
        {"name": "singleton_nonuniform", "u": 1,
         "mesh": ["0", "1/6", "1/2", "1"], "old": "x", "target": "a"},
        {"name": "three_old_two_target", "u": 1,
         "mesh": ["0", "1/13", "3/13", "6/13", "8/13", "11/13", "1"],
         "old": branch(2, "x", "y", "z"), "target": branch(3, "a", "b")},
        {"name": "two_old_four_target", "u": 1,
         "mesh": ["0", "1/11", "2/11", "4/11", "7/11", "9/11", "1"],
         "old": branch(2, "x", "y"), "target": branch(3, "a", "b", "c", "d")},
        {"name": "nested_unequal_nonuniform", "u": 1,
         "mesh": ["0", "1/17", "2/17", "5/17", "9/17", "14/17", "1"],
         "old": branch(1, branch(3, "w", "x", "y"), "z"),
         "target": branch(2, "a", branch(4, "b", "c"))},
    ]


def replay_reference_free(definition: dict[str, Any], budget: Budget) -> dict[str, Any]:
    mesh = [Fraction(value) for value in definition["mesh"]]
    L, u = len(mesh) - 1, definition["u"]
    if mesh[0] != 0 or mesh[-1] != 1 or any(
        left >= right for left, right in zip(mesh, mesh[1:])
    ):
        raise ValueError("A general-mesh fixture must be strictly increasing from 0 to 1.")
    if not 0 <= u <= L:
        raise ValueError("The reference-free root must be at a valid depth.")
    old_labels, old_vertices = topology(definition["old"])
    target_labels, target_vertices = topology(definition["target"])
    if len(set(old_labels)) != len(old_labels) or len(set(target_labels)) != len(target_labels):
        raise ValueError("Old and target labels must each be distinct.")
    if {v["depth"] for v in old_vertices} & {v["depth"] for v in target_vertices}:
        raise ValueError("The exact normal form requires disjoint branching depth sets.")
    old = copy_paths(definition["old"], (0,) * u, L, 0)
    target = copy_paths(definition["target"], (0,) * u, L, 0)
    required = [
        [common_prefix(target[color], target[previous]) for previous in target_labels[:step]]
        for step, color in enumerate(target_labels)
    ]
    kappa = Fraction(1)
    for vertex in target_vertices:
        d = vertex["depth"]
        for j in range(1, vertex["arity"]):
            kappa *= mesh[d] - j * mesh[d + 1]
    count = 0
    signed_mass = Fraction(0)
    absolute_mass = Fraction(0)
    reuse_pairs: Counter[tuple[str, str]] = Counter()
    failures: list[str] = []

    def search(
        leaves: tuple[PathTuple, ...], references: tuple[PathTuple, ...],
        used_old: frozenset[PathTuple], weight: Fraction,
        reused: tuple[tuple[str, str], ...],
    ) -> None:
        nonlocal count, signed_mass, absolute_mass
        budget.check()
        step = len(references)
        if step == len(target_labels):
            count += 1
            signed_mass += weight
            absolute_mass += abs(weight)
            if reused:
                if len(reused) != 1 or weight != kappa:
                    failures.append("A one-reuse history violates its exact kappa coefficient.")
                reuse_pairs[reused[0]] += 1
            elif weight * kappa >= 0:
                failures.append("A zero-reuse history has the wrong relative sign.")
            return

        def compatible(path: PathTuple) -> bool:
            return all(common_prefix(path, ref) == depth
                       for ref, depth in zip(references, required[step]))

        for label, path in old.items():
            if path not in used_old and compatible(path):
                search(
                    leaves, references + (path,), used_old | {path}, weight,
                    reused + ((target_labels[step], label),),
                )
        for vertex, children in internal_vertices(leaves).items():
            d, n = len(vertex), len(children)
            if d < u:
                continue
            path = vertex + (n,) + (0,) * (L - d - 1)
            if compatible(path):
                search(leaves + (path,), references + (path,), used_old,
                       weight * (mesh[d] - n * mesh[d + 1]), reused)

    search(tuple(old.values()), (), frozenset(), Fraction(1), ())
    q, r = len(old_labels), len(target_labels)
    expected_pairs = {(color, label) for color in target_labels for label in old_labels}
    expected_signed = mesh[u] * kappa
    expected_absolute = (2 * q * r - mesh[u]) * abs(kappa)
    if set(reuse_pairs) != expected_pairs or any(n != 1 for n in reuse_pairs.values()):
        failures.append("The q*r old-leaf / target-color normal-form bijection failed.")
    if signed_mass != expected_signed or absolute_mass != expected_absolute:
        failures.append("The general-mesh signed or exact absolute identity failed.")
    return {
        "name": definition["name"], "q": q, "r": r, "root_depth": u,
        "kappa": str(kappa), "signed_mass": str(signed_mass),
        "expected_signed_mass": str(expected_signed), "absolute_mass": str(absolute_mass),
        "expected_absolute_mass": str(expected_absolute), "finite_history_count": count,
        "one_reuse_pairs": [
            {"target_color": color, "old_leaf": leaf, "count": n}
            for (color, leaf), n in sorted(reuse_pairs.items())
        ],
        "failures": failures,
    }


def compute(definitions: list[dict[str, Any]], budget: Budget) -> dict[str, Any]:
    results = []
    for definition in definitions:
        result = replay(definition, budget)
        results.append(result)
        if result["failures"]:
            break
    passed = len(results) == len(definitions) and all(not row["failures"] for row in results)
    general_definitions = reference_free_cases()
    general_results = [replay_reference_free(case, budget) for case in general_definitions]
    passed = passed and all(not row["failures"] for row in general_results)
    return {
        "schema_version": 1,
        "experiment_kind": "deterministic_stdlib_exact_finite_replay",
        "status": "finite_checks_passed" if passed else "finite_mismatch",
        "limitations": [
            "These are finitely many exact experiments, not a universal proof.",
            "No independent Reviewer acceptance is asserted.",
            "Retained labeled skeleton isomorphism is checked, not a probability theorem.",
            "No claim is made about sampled values, kernels, projection errors, or limits.",
            "One canonical fresh-child name represents each extension choice.",
        ],
        "primary_sources": [
            "trees.tex:250-445, canceled-anchor extension and charging rules",
            "decorrelation.tex:300-453, shifted target copies and prefix classes",
        ],
        "enumeration_method": {
            "method": "exhaustive_depth_first_enumeration_without_pruning_old_paths",
            "coefficient": "old: 1; fresh at depth h with n children: (h-n*(h+1))/L",
            "integer_accumulation": "Every step has denominator L; old steps have numerator L.",
            "fresh_candidates": "Every internal vertex of the full current tree, including unary vertices.",
            "old_candidates": "Every individually labeled unused old leaf except the protected anchor.",
            "constraints": "Exact common-prefix lengths with anchor and every earlier color only.",
            "protection": "Every fresh leaf is immediately protected and never an old candidate.",
            "arity": "No binary restriction or upper arity cutoff.",
            "retained_skeleton": "All labeled old full paths plus marked first-II prefix through e.",
            "skeleton_comparison": "Canonical unordered children; all depths and unary vertices retained.",
            "charging_bound": "k!/(k-b)! * (q_old+k)^b * (2*(q_old+k))^(k-b) / L^b",
        },
        "fixture_definitions": definitions,
        "fixture_results": results,
        "general_mesh_fixture_definitions": general_definitions,
        "general_mesh_fixture_results": general_results,
        "summary": {
            "completed_fixtures": len(results),
            "finite_history_count": sum(
                row["enumeration_counts"]["finite_history_count"] for row in results
            ),
            "general_mesh_fixtures": len(general_results),
            "general_mesh_finite_history_count": sum(
                row["finite_history_count"] for row in general_results
            ),
            "every_completed_fixture_exercises_old_leaf_reuse": all(
                row["old_leaf_reuse"]["occurs"] for row in results
            ),
            "every_completed_fixture_exercises_old_reuse_after_first_II": all(
                row["old_leaf_reuse"]["after_first_II_occurs"] for row in results
            ),
            "every_completed_fixture_checks_retained_skeletons": all(
                entry["retained_skeleton"]["fixed_within_class"]
                for row in results for entry in row["first_II_class_totals"]
            ),
            "every_completed_fixture_checks_exact_mass_normal_form": all(
                row["exact_mass_normal_form"]["exact_normalized_identity_holds"]
                for row in results
            ),
        },
    }


def first_difference(expected: Any, actual: Any, path: str = "$") -> str | None:
    if type(expected) is not type(actual):
        return f"{path}: different types"
    if isinstance(expected, dict):
        if set(expected) != set(actual):
            return f"{path}: different keys"
        for key in sorted(expected):
            difference = first_difference(expected[key], actual[key], f"{path}.{key}")
            if difference:
                return difference
    elif isinstance(expected, list):
        if len(expected) != len(actual):
            return f"{path}: different lengths"
        for index, (left, right) in enumerate(zip(expected, actual)):
            difference = first_difference(left, right, f"{path}[{index}]")
            if difference:
                return difference
    elif expected != actual:
        return f"{path}: persisted {expected!r}, recomputed {actual!r}"
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true",
                        help="Regenerate the deterministic exact certificate.")
    args = parser.parse_args()
    budget = Budget()
    try:
        if args.write_certificate:
            definitions = default_fixtures()
            persisted = None
        else:
            persisted = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
            definitions = persisted["fixture_definitions"]
            if first_difference(default_fixtures(), definitions):
                raise ValueError("Persisted fixture definitions differ from the fixed test suite.")
        result = compute(definitions, budget)
        if args.write_certificate:
            CERTIFICATE.write_text(
                json.dumps(result, indent=2, sort_keys=True, ensure_ascii=True) + "\n",
                encoding="utf-8",
            )
            persisted = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
        difference = first_difference(persisted, result)
        if difference:
            print(f"FAIL certificate comparison: {difference}", file=sys.stderr)
            return 1
        if result["status"] != "finite_checks_passed":
            for failed in [*result["fixture_results"], *result["general_mesh_fixture_results"]]:
                if failed["failures"]:
                    print(f"EXACT FINITE MISMATCH: {failed['name']}: "
                          f"{compact(failed['failures'])}", file=sys.stderr)
            return 1
        print(
            f"PASS: {len(result['fixture_results'])} fixtures, "
            f"{result['summary']['finite_history_count']} exact finite histories; "
            f"{result['summary']['general_mesh_fixtures']} nonuniform/unequal-size fixtures; "
            "class totals, retained skeletons, one-reuse normal forms, "
            "exact 2*s^2+delta mass, and charging bounds checked; "
            f"{time.monotonic() - budget.started:.3f}s. Not a universal proof."
        )
        return 0
    except (OSError, ValueError, KeyError, TypeError, TimeoutError) as error:
        print(f"FAIL: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
