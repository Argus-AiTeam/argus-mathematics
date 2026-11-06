"""Exact finite model of the staged construction; no scheduling heuristics."""

from dataclasses import dataclass, replace
from functools import lru_cache
from itertools import combinations
import random


def bits(mask):
    while mask:
        bit = mask & -mask
        yield bit.bit_length() - 1
        mask -= bit


def union(masks):
    result = 0
    for mask in masks:
        result |= mask
    return result


class WorkLimit(RuntimeError):
    pass


class Violation(RuntimeError):
    def __init__(self, assertion, detail):
        super().__init__(assertion)
        self.assertion = assertion
        self.detail = detail


@dataclass(frozen=True)
class Predicate:
    mask: int
    leaves: int
    syntax: object

    def meet(self, other):
        return Predicate(self.mask & other.mask, self.leaves + other.leaves,
                         ["and", self.syntax, other.syntax])

    def join(self, other):
        return Predicate(self.mask | other.mask, self.leaves + other.leaves,
                         ["or", self.syntax, other.syntax])

    def complement(self, full):
        return Predicate(full ^ self.mask, self.leaves, ["not", self.syntax])


@dataclass(frozen=True)
class Entry:
    core: Predicate
    threshold: int = 0
    kind: str = "simple"
    pair_cone: Predicate | None = None

    def predicate(self, model, frame):
        if self.threshold:
            return self.core.meet(model.rank_test(frame, self.threshold, ">="))
        return self.core


@dataclass
class Node:
    schedule: tuple
    lo: int
    hi: int
    frame: int
    entries: tuple
    parent: object = None
    incoming_low: Predicate | None = None
    center: int | None = None
    path: tuple = ()
    switches: int = 0
    trimmed_after_switch: bool = False
    switch_carry_switch: bool = False
    complex_carry: bool = False
    complex_switch_carry_switch: bool = False


class Model:
    def __init__(self, n, edges, work_limit=200000):
        self.n = n
        self.full = (1 << n) - 1
        self.edges = tuple(map(tuple, edges))
        self.pred = [0] * n
        for x, y in self.edges:
            if not (0 <= x < n and 0 <= y < n) or x == y:
                raise ValueError("invalid edge")
            self.pred[y] |= 1 << x
        for k in range(n):
            for y in range(n):
                if self.pred[y] >> k & 1:
                    self.pred[y] |= self.pred[k]
        if any(self.pred[x] >> x & 1 for x in range(n)):
            raise ValueError("cyclic instance")
        self.succ = [sum(1 << y for y in range(n) if self.pred[y] >> x & 1)
                     for x in range(n)]
        remaining = self.full
        extension = []
        while remaining:
            x = next(x for x in bits(remaining) if not self.pred[x] & remaining)
            extension.append(x)
            remaining ^= 1 << x
        self.ranks = [0] * n
        for rank, x in enumerate(extension, 1):
            self.ranks[x] = rank
        self.work_limit = work_limit
        self.work = 0
        self.solve_calls = 0

    def rank(self, frame, x):
        return self.ranks[x] if frame == 1 else self.n + 1 - self.ranks[x]

    def predecessors(self, frame):
        return self.pred if frame == 1 else self.succ

    def successors(self, frame):
        return self.succ if frame == 1 else self.pred

    def constant(self, value):
        return Predicate(self.full if value else 0, 1, ["constant", value])

    def rank_test(self, frame, threshold, comparison):
        if comparison == ">=":
            mask = sum(1 << x for x in range(self.n)
                       if self.rank(frame, x) >= threshold)
        elif comparison == "<=":
            mask = sum(1 << x for x in range(self.n)
                       if self.rank(frame, x) <= threshold)
        else:
            raise ValueError("invalid rank comparison")
        return Predicate(mask, 1, ["rank", frame, comparison, threshold])

    def cone(self, schedule, position, frame, kind):
        length = len(schedule)
        if position in (-1, length):
            is_down = kind in ("P", "wP")
            value = (position == length) if is_down else (position == -1)
            return self.constant(value)
        triple = schedule[position]
        relation = (self.predecessors(frame) if kind in ("P", "wP")
                    else self.successors(frame))
        mask = union(relation[x] for x in bits(triple))
        if kind.startswith("w"):
            mask |= triple
        return Predicate(mask, 1, ["cone", frame, kind, list(bits(triple))])

    def feasible(self, schedule, frame=1, domain=None):
        domain = self.full if domain is None else domain
        seen = 0
        predecessors = self.predecessors(frame)
        for triple in schedule:
            if triple.bit_count() != 3 or triple & seen or triple & ~domain:
                return False
            for x in bits(triple):
                if predecessors[x] & domain & ~seen:
                    return False
            seen |= triple
        return seen == domain

    def solve(self, domain, frame, priority=None, predecessors=None):
        """Return the exact lexicographic minimum, or None after exhaustion."""
        self.solve_calls += 1
        if domain.bit_count() % 3:
            return None
        predecessors = (self.predecessors(frame) if predecessors is None
                        else predecessors)
        priority = (sorted(bits(domain), key=lambda x: self.rank(frame, x))
                    if priority is None else priority)
        order = {x: i for i, x in enumerate(priority)}
        if set(order) != set(bits(domain)):
            raise ValueError("priority is not a permutation of domain")

        @lru_cache(None)
        def visit(remaining):
            self.work += 1
            if self.work > self.work_limit:
                raise WorkLimit(f"exact solver exceeded {self.work_limit} states")
            if not remaining:
                return ()
            minimal = sorted((x for x in bits(remaining)
                              if not predecessors[x] & remaining),
                             key=order.__getitem__)
            for jobs in combinations(minimal, 3):
                triple = sum(1 << x for x in jobs)
                tail = visit(remaining ^ triple)
                if tail is not None:
                    return (triple,) + tail
            return None

        return visit(domain)

    def upset(self, predicate, frame):
        return all(not self.successors(frame)[x] & ~predicate.mask
                   for x in bits(predicate.mask))


class Construction:
    def __init__(self, model, schedule, center_choice="balanced",
                 center_order="rank", center_seed=0):
        if not model.feasible(schedule):
            raise ValueError("input is not a full feasible global schedule")
        self.model = model
        self.center_choice = center_choice
        self.center_order = center_order
        self.center_seed = center_seed
        self.root = Node(tuple(schedule), -1, len(schedule), 1,
                         (Entry(model.constant(True)),))
        self.events = []
        self.stats = {"nodes": 0, "edges": 0, "switch_edges": 0,
                      "trimmed_carries": 0, "i3_candidates": 0,
                      "max_depth": 0, "max_entries": 0, "max_entry_leaves": 0,
                      "max_switches": 0, "switch_carry_switch_nodes": 0,
                      "surviving_first_entries": 0, "flattened_first_entries": 0,
                      "complex_switch_carry_switch_nodes": 0, "split_formulas": 0}
        self.deepest = None
        self.i3_example = None

    def check(self, condition, assertion, **detail):
        if not condition:
            raise Violation(assertion, {"events": self.events, **detail})

    def view(self, node, frame):
        if frame == 1:
            return node.schedule, node.lo, node.hi
        length = len(node.schedule)
        return tuple(reversed(node.schedule)), length - 1 - node.hi, length - 1 - node.lo

    def local(self, node):
        return union(node.schedule[node.lo + 1:node.hi])

    def entry_union(self, entries, frame):
        return union(e.predicate(self.model, frame).mask for e in entries)

    def key(self, entries, frame, x):
        memberships = [i for i, entry in enumerate(entries)
                       if entry.predicate(self.model, frame).mask >> x & 1]
        if not memberships:
            raise ValueError("key requested for a nonqualifier")
        return max(memberships), self.model.rank(frame, x)

    def carry(self, node, low):
        model = self.model
        old_high = self.local(node) & self.entry_union(node.entries, node.frame)
        unpromoted = old_high & ~low
        if not unpromoted:
            return ()
        d, rank = min(self.key(node.entries, node.frame, x) for x in bits(unpromoted))
        result = list(node.entries[d:])
        result[0] = replace(result[0], threshold=max(result[0].threshold, rank))
        return tuple(result)

    def cutoff(self, node, frame, low):
        model = self.model
        schedule, a, b = self.view(node, frame)
        if frame == node.frame:
            carry = self.carry(node, low)
            union_pred = model.constant(False)
            if carry:
                union_pred = carry[0].predicate(model, frame)
                for entry in carry[1:]:
                    union_pred = union_pred.join(entry.predicate(model, frame))
            return model.cone(schedule, b, frame, "P").meet(
                union_pred.complement(model.full))
        last = max((model.rank(frame, x) for x in bits(low)), default=0)
        return model.cone(schedule, a, frame, "D").complement(model.full).meet(
            model.rank_test(frame, last, "<="))

    def historical_cutoff(self, node, frame, low):
        model = self.model
        schedule, a, b = self.view(node, frame)
        domain = self.local(node)
        if frame != node.frame:
            result = self.cutoff(node, frame, low)
        else:
            carry = self.carry(node, low)
            terms = []
            complex_entries = [e for e in carry if e.kind == "first"]
            if complex_entries:
                self.check(len(complex_entries) == 1, "implementation:one-first")
                first = complex_entries[0]
                second = [e for e in carry if e.kind == "second"]
                self.check(all(e.threshold == 0 for e in second),
                           "lem:flatten:untrimmed-second")
                flattened = first.pair_cone.join(
                    model.rank_test(frame, first.threshold, ">="))
                pair_union = first.predicate(model, frame).mask | union(
                    e.predicate(model, frame).mask for e in second)
                self.check((flattened.mask & domain) == (pair_union & domain),
                           "lem:flatten", path=node.path, frame=frame)
                self.stats["flattened_first_entries"] += 1
                terms.append(flattened)
            for entry in carry:
                if complex_entries and entry.kind in ("first", "second"):
                    continue
                terms.append(entry.predicate(model, frame))
            combined = model.constant(False)
            if terms:
                combined = terms[0]
                for term in terms[1:]:
                    combined = combined.join(term)
            result = model.cone(schedule, b, frame, "P").meet(
                combined.complement(model.full))
        self.check(result.mask & domain == low, "lem:old-low:agreement",
                   path=node.path, frame=frame, low=low, extension=result.mask)
        self.check(model.upset(result.complement(model.full), frame),
                   "lem:old-low:downset", path=node.path)
        self.check(result.leaves <= 21, "lem:old-low:size", path=node.path,
                   leaves=result.leaves)
        return result

    def separator(self, schedule, a, b, position, frame, low):
        model = self.model
        before = union(schedule[a + 1:position]) if position > a else 0
        after = union(schedule[position + 1:b])
        return (not (before & ~low & ~model.cone(schedule, position, frame, "P").mask)
                and not (after & low & ~model.cone(schedule, position, frame, "D").mask))

    def walk(self, schedule, a, b, frame, initial_low, promotions):
        low = initial_low
        position = a
        positions, cutoffs = [a], [low]
        self.check(self.separator(schedule, a, b, position, frame, low),
                   "implementation:starting-separator")
        for x in promotions:
            old_low = low
            low |= 1 << x
            while True:
                descendants = self.model.cone(schedule, position, frame, "D").mask
                target = next((t for t in range(position + 1, b)
                               if schedule[t] & low & ~descendants), None)
                if target is None:
                    break
                position = target
            self.check(self.separator(schedule, a, b, position, frame, old_low)
                       and self.separator(schedule, a, b, position, frame, low),
                       "lem:shared", frame=frame, low=low, position=position)
            positions.append(position)
            cutoffs.append(low)
        return positions, cutoffs

    def replace_interval(self, node, frame, a, b, replacement):
        schedule, _, _ = self.view(node, frame)
        result = schedule[:a + 1] + replacement + schedule[b:]
        node.schedule = result if frame == 1 else tuple(reversed(result))
        self.check(self.model.feasible(node.schedule), "implementation:reordering")

    def boundary_invariants(self, node):
        model = self.model
        frame = node.frame
        schedule, a, b = self.view(node, frame)
        domain = self.local(node)
        qualifying = self.entry_union(node.entries, frame)
        old_high = domain & qualifying
        d_a = model.cone(schedule, a, frame, "D").mask
        p_b = model.cone(schedule, b, frame, "P").mask
        self.check(not old_high & ~p_b and not (domain & ~old_high & ~d_a),
                   "I1", path=node.path)
        early = union(schedule[:a + 1])
        self.check(not qualifying & early & ~model.cone(schedule, a, frame, "wP").mask,
                   "I2", path=node.path, early_qualifiers=qualifying & early)
        for entry in node.entries:
            predicate = entry.predicate(model, frame)
            self.check(model.upset(predicate, frame), "entry:upset", path=node.path)
            self.check(predicate.leaves < 40, "lem:entry-size", path=node.path,
                       leaves=predicate.leaves)
            self.stats["max_entry_leaves"] = max(self.stats["max_entry_leaves"],
                                                  predicate.leaves)
        self.check(len(node.entries) <= 5, "lem:list-length", path=node.path)
        if a == -1:
            return
        predecessors = model.predecessors(frame)
        successors = model.successors(frame)
        for x in bits(domain & ~d_a):
            if predecessors[x] & domain:
                continue
            for y in bits(schedule[a] & qualifying):
                if self.key(node.entries, frame, x) >= self.key(node.entries, frame, y):
                    continue
                self.stats["i3_candidates"] += 1
                augmented = list(predecessors)
                for z in bits(successors[y] & domain):
                    augmented[z] |= 1 << x
                future = model.solve(domain, frame, predecessors=augmented)
                if domain.bit_count() <= 27 and (
                        self.i3_example is None
                        or domain.bit_count() > len(self.i3_example["jobs"])):
                    self.i3_example = {
                        "path": list(node.path), "frame": frame, "a": a, "b": b,
                        "schedule": [list(bits(t)) for t in schedule],
                        "jobs": list(bits(domain)), "x": x, "y": y,
                        "key_x": list(self.key(node.entries, frame, x)),
                        "key_y": list(self.key(node.entries, frame, y)),
                        "augmented_predecessors": [list(bits(p & domain)) for p in augmented],
                        "expected_outcome": "UNSAT" if future is None else "SAT",
                    }
                if future is None:
                    continue
                reordered = schedule[:a + 1] + future + schedule[b:]
                target = next(t for t in range(a + 1, b) if reordered[t] >> x & 1)
                exchanged = list(reordered)
                exchanged[a] ^= (1 << x) | (1 << y)
                exchanged[target] ^= (1 << x) | (1 << y)
                self.check(not model.feasible(tuple(exchanged), frame),
                           "I3", path=node.path, frame=frame, x=x, y=y,
                           future=[list(bits(t)) for t in future],
                           exchanged=[list(bits(t)) for t in exchanged])
                raise AssertionError("augmented solver and direct exchange disagree")

    def update(self, node, frame, a_new, b_new, low):
        model = self.model
        schedule, a, b = self.view(node, frame)
        domain = self.local(node)
        child_domain = union(schedule[a_new + 1:b_new])
        extension = self.historical_cutoff(node, frame, low)
        d_a = model.cone(schedule, a, frame, "D")
        trimmed = False
        complex_carry = False
        if frame == node.frame:
            carry = self.carry(node, low)
            trimmed = bool(carry and self.entry_union(carry, frame)
                           != self.entry_union(node.entries, frame))
            complex_carry = trimmed and any(e.kind == "first" for e in carry)
            injection = d_a.meet(model.cone(schedule, b, frame, "P").complement(model.full))
            entries = carry + (Entry(injection, kind="injection"),)
        else:
            self.check(node.parent is not None, "implementation:no-root-switch")
            ancestor_schedule, ancestor_a, _ = self.view(node.parent, frame)
            ancestor_center = (node.parent.center if frame == 1
                               else len(schedule) - 1 - node.parent.center)
            self.check(ancestor_schedule[ancestor_center] == schedule[ancestor_center],
                       "implementation:frozen-center")
            g = model.cone(schedule, ancestor_a, frame, "D").meet(
                model.cone(schedule, a, frame, "wP").complement(model.full)).meet(
                model.cone(schedule, ancestor_center, frame, "wP").complement(
                    model.full)).meet(node.incoming_low)
            x_set = domain & ~d_a.mask
            self.check(not x_set & ~g.mask, "lem:G:coverage", path=node.path,
                       frame=frame, missing=x_set & ~g.mask)
            self.check(not g.mask & union(schedule[:a + 1]), "lem:G:early-exclusion",
                       path=node.path, frame=frame)
            self.check(model.upset(g, frame), "lem:G:upset", path=node.path)
            h = min((model.rank(frame, x) for x in bits(x_set & ~low)),
                    default=model.n + 1)
            entries = (Entry(g, h, "first", d_a), Entry(d_a, kind="second"))
            self.stats["switch_edges"] += 1
        self.check(self.entry_union(entries, frame) & domain == domain & ~low,
                   "lem:update-labels:union", path=node.path, frame=frame)
        high_order = sorted(bits(domain & ~low),
                            key=lambda x: self.key(entries, frame, x))
        priority = self.side_priority(node, frame)[0]
        self.check(high_order == [x for x in priority if not low >> x & 1],
                   "lem:update-labels:order", path=node.path, frame=frame)
        entries = tuple(e for e in entries if e.predicate(model, frame).mask & child_domain)
        self.stats["surviving_first_entries"] += sum(e.kind == "first" for e in entries)
        if frame == 1:
            lo, hi = a_new, b_new
        else:
            lo, hi = len(schedule) - 1 - b_new, len(schedule) - 1 - a_new
        switched = frame != node.frame
        child = Node(node.schedule, lo, hi, frame, entries, node, extension,
                     path=node.path + (self.stats["edges"],),
                     switches=node.switches + int(switched),
                     trimmed_after_switch=(node.trimmed_after_switch
                                           or (trimmed and node.switches > 0)),
                     switch_carry_switch=(node.switch_carry_switch
                                          or (switched and node.trimmed_after_switch)),
                     complex_carry=(node.complex_carry or complex_carry),
                     complex_switch_carry_switch=(node.complex_switch_carry_switch
                                                  or (switched and node.complex_carry)))
        self.stats["edges"] += 1
        self.stats["trimmed_carries"] += int(trimmed)
        self.events.append({
            "path": list(child.path), "frame": frame, "a": a_new, "b": b_new,
            "low": list(bits(low)), "jobs": list(bits(child_domain)),
            "schedule": [list(bits(t)) for t in node.schedule],
            "entries": [e.predicate(model, frame).syntax for e in entries],
            "entry_kinds": [e.kind for e in entries],
            "switched": switched, "restricted_carry": trimmed,
            "restricted_complex_carry": complex_carry,
        })
        self.boundary_invariants(child)
        qualifier = self.entry_union(entries, frame)
        high = qualifier & model.cone(schedule, b_new, frame, "P").mask & (
            model.full ^ model.cone(schedule, a_new, frame, "wP").mask)
        low_formula = (model.cone(schedule, a_new, frame, "D").mask
                       & model.cone(schedule, b, frame, "P").mask
                       & ~model.cone(schedule, b_new, frame, "wD").mask
                       & ~model.cone(schedule, (node.center if frame == 1 else
                                               len(schedule) - 1 - node.center),
                                    frame, "wD").mask
                       & self.cutoff(node, frame, low).mask)
        self.check(high == child_domain & ~low, "eq:global-high",
                   path=child.path, actual=high, expected=child_domain & ~low)
        self.check(low_formula == child_domain & low, "eq:global-low",
                   path=child.path, actual=low_formula, expected=child_domain & low)
        global_leaves = sum(e.predicate(model, frame).leaves for e in entries) or 1
        global_leaves += 2 + self.cutoff(node, frame, low).leaves + 4
        self.check(global_leaves < 500, "lem:final-count", path=child.path,
                   leaves=global_leaves)
        return child

    def side_priority(self, node, frame):
        model = self.model
        schedule, a, b = self.view(node, frame)
        domain = self.local(node)
        by_rank = lambda mask: sorted(bits(mask), key=lambda x: model.rank(frame, x))
        if frame == node.frame:
            old_high = domain & self.entry_union(node.entries, frame)
            p_b = model.cone(schedule, b, frame, "P").mask
            initial = domain & ~old_high & p_b
            promotions = sorted(bits(old_high), key=lambda x: self.key(node.entries, frame, x))
            priority = by_rank(initial) + promotions + by_rank(domain & ~p_b)
        else:
            initial = 0
            x_set = domain & ~model.cone(schedule, a, frame, "D").mask
            promotions = by_rank(x_set)
            priority = promotions + by_rank(domain & ~x_set)
        self.check(len(priority) == domain.bit_count(), "implementation:priority-partition")
        priority_position = {x: i for i, x in enumerate(priority)}
        self.check(all(priority_position[x] < priority_position[y]
                       for y in bits(domain)
                       for x in bits(model.predecessors(frame)[y] & domain)),
                   "construction:priority-extension", path=node.path, frame=frame)
        return priority, initial, promotions

    def check_split(self, node, frame, position, low=None):
        model = self.model
        schedule, a, b = self.view(node, frame)
        domain = self.local(node)
        center = node.center if frame == 1 else len(schedule) - 1 - node.center
        h = (model.cone(schedule, b, frame, "P") if frame == node.frame else
             model.cone(schedule, a, frame, "D").complement(model.full))

        def earlier(z, predicate):
            return model.cone(schedule, z, frame, "P").join(
                predicate.meet(model.cone(schedule, z, frame, "wD").complement(model.full)))

        formula = earlier(center, h)
        if low is not None:
            cutoff = self.cutoff(node, frame, low)
            self.check(cutoff.mask & domain == low, "eq:cutoff-agreement",
                       path=node.path, frame=frame)
            formula = formula.meet(earlier(position, cutoff))
        expected = union(schedule[a + 1:position])
        self.check(formula.mask & domain == expected, "lem:relative-splits",
                   path=node.path, frame=frame, position=position)
        if frame == -1:
            converted = domain & ~formula.mask & ~schedule[position]
            original_position = len(schedule) - 1 - position
            expected_original = union(node.schedule[node.lo + 1:original_position])
            self.check(converted == expected_original, "eq:reverse-split",
                       path=node.path, position=position)
        self.check(formula.leaves + int(frame == -1) < 500,
                   "lem:relative-splits:size", path=node.path)
        self.stats["split_formulas"] += 1

    def develop(self, node):
        model = self.model
        domain = self.local(node)
        self.stats["nodes"] += 1
        self.stats["max_depth"] = max(self.stats["max_depth"], len(node.path))
        self.stats["max_entries"] = max(self.stats["max_entries"], len(node.entries))
        self.stats["max_switches"] = max(self.stats["max_switches"], node.switches)
        self.stats["switch_carry_switch_nodes"] += int(node.switch_carry_switch)
        self.stats["complex_switch_carry_switch_nodes"] += int(
            node.complex_switch_carry_switch)
        if self.deepest is None or (node.switches, len(node.path)) > (
                self.deepest.switches, len(self.deepest.path)):
            self.deepest = node
        schedule, a, b = self.view(node, node.frame)
        if node.parent is None:
            center = b - 1
        else:
            ideal = domain & model.cone(schedule, b, node.frame, "P").mask
            rng = random.Random((self.center_seed + 1) * 1000003
                                + sum((i + 1) * v for i, v in enumerate(node.path)))
            if self.center_order == "rank":
                priority = sorted(bits(domain), key=lambda x: (
                    0 if ideal >> x & 1 else 1, model.rank(node.frame, x)))
            elif self.center_order == "varied":
                priority = []
                for group in (ideal, domain & ~ideal):
                    while group:
                        choices = [x for x in bits(group)
                                   if not model.predecessors(node.frame)[x] & group]
                        x = rng.choice(choices)
                        priority.append(x)
                        group ^= 1 << x
            else:
                raise ValueError("invalid center priority order")
            normalized = model.solve(domain, node.frame, priority)
            self.check(normalized is not None, "implementation:center-existence")
            self.replace_interval(node, node.frame, a, b, normalized)
            schedule, a, b = self.view(node, node.frame)
            centers = [z for z in range(a + 1, b)
                       if self.separator(schedule, a, b, z, node.frame, ideal)]
            self.check(bool(centers), "cor:any-ideal", path=node.path)
            if self.center_choice == "first":
                center = centers[0]
            elif self.center_choice == "last":
                center = centers[-1]
            elif self.center_choice == "balanced":
                center = min(centers, key=lambda z: (max(z - a, b - z), z))
            elif self.center_choice == "varied":
                center = rng.choice(centers)
            else:
                raise ValueError("invalid center choice")
        node.center = center if node.frame == 1 else len(schedule) - 1 - center
        for frame in (node.frame, -node.frame):
            schedule, a, b = self.view(node, frame)
            v = node.center if frame == 1 else len(schedule) - 1 - node.center
            side = union(schedule[a + 1:v])
            if not side:
                continue
            priority, _, _ = self.side_priority(node, frame)
            normalized = model.solve(side, frame, [x for x in priority if side >> x & 1])
            self.check(normalized is not None, "implementation:side-existence")
            self.replace_interval(node, frame, a, v, normalized)
        children = []
        for frame in (node.frame, -node.frame):
            schedule, a, b = self.view(node, frame)
            v = node.center if frame == 1 else len(schedule) - 1 - node.center
            _, initial, promotions = self.side_priority(node, frame)
            positions, cutoffs = self.walk(schedule, a, v, frame, initial, promotions)
            self.check_split(node, frame, v)
            checked_marks = set()
            for position, low in zip(positions, cutoffs):
                if a < position < v and position not in checked_marks:
                    self.check_split(node, frame, position, low)
                    checked_marks.add(position)
            final_low = initial | sum(1 << x for x in promotions)
            self.check(self.separator(schedule, a, b, v, frame, final_low),
                       "eq:center-cutoff", path=node.path, frame=frame)
            positions.append(v)
            for i, (left, right) in enumerate(zip(positions, positions[1:])):
                if left + 1 >= right:
                    continue
                child = self.update(node, frame, left, right, cutoffs[i])
                children.append(child)
        for child in children:
            self.develop(child)
        return self.stats

    def run(self):
        self.boundary_invariants(self.root)
        return self.develop(self.root)
