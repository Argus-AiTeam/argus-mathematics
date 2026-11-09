import unittest
from itertools import combinations, product

from model import Construction, Model, bits, union
from verify import exchange_payload


class ExactModelTests(unittest.TestCase):
    def test_sentinels_and_single_slot(self):
        model = Model(3, [])
        schedule = (7,)
        construction = Construction(model, schedule)
        for frame in (1, -1):
            self.assertEqual(model.cone(schedule, -1, frame, "D").mask, 7)
            self.assertEqual(model.cone(schedule, -1, frame, "P").mask, 0)
            self.assertEqual(model.cone(schedule, 1, frame, "D").mask, 0)
            self.assertEqual(model.cone(schedule, 1, frame, "P").mask, 7)
            self.assertTrue(construction.separator(schedule, -1, 0, -1, frame, 0))
        self.assertEqual(construction.run()["nodes"], 1)

    def test_global_closure_and_reversed_rank(self):
        model = Model(6, [(0, 4), (4, 2), (5, 1)])
        self.assertTrue(model.pred[2] & 1)
        self.assertTrue(model.succ[0] & (1 << 2))
        for x in range(6):
            self.assertEqual(model.rank(1, x) + model.rank(-1, x), 7)
        for x, y in ((0, 4), (4, 2), (0, 2), (5, 1)):
            self.assertLess(model.rank(1, x), model.rank(1, y))
            self.assertLess(model.rank(-1, y), model.rank(-1, x))

    def test_normalization_against_all_two_slot_partitions(self):
        model = Model(6, [(0, 4), (1, 5)])
        for frame in (1, -1):
            priority = sorted(range(6), key=lambda x: model.rank(frame, x))
            position = {x: i for i, x in enumerate(priority)}
            schedules = []
            for first in combinations(range(6), 3):
                mask = sum(1 << x for x in first)
                candidate = (mask, model.full ^ mask)
                if model.feasible(candidate, frame):
                    schedules.append(candidate)
            expected = min(schedules, key=lambda s: tuple(
                i for triple in s for i in sorted(position[x] for x in bits(triple))))
            self.assertEqual(model.solve(model.full, frame, priority), expected)

    def test_normalization_rejects_a_greedy_dead_end(self):
        model = Model(9, [(3, 6), (6, 8)])
        greedy_first = (1 << 0) | (1 << 1) | (1 << 2)
        self.assertIsNone(model.solve(model.full ^ greedy_first, 1))
        normalized = model.solve(model.full, 1)
        self.assertEqual(list(bits(normalized[0])), [0, 1, 3])
        self.assertTrue(model.feasible(normalized))

    def test_interval_reversal(self):
        model = Model(9, [(0, 4), (4, 8)])
        schedule = (7, 56, 448)
        construction = Construction(model, schedule)
        original, a, b = construction.view(construction.root, 1)
        reversed_schedule, ra, rb = construction.view(construction.root, -1)
        self.assertEqual(union(original[a + 1:b]), union(reversed_schedule[ra + 1:rb]))
        self.assertTrue(model.feasible(reversed_schedule, -1))

    def test_future_exchange_reduction_by_exhaustive_reordering(self):
        edges = [(0, 4), (0, 8), (2, 6), (3, 10), (5, 9), (8, 11)]
        model = Model(12, edges)
        original = (7, 56, 448, 3584)
        for frame in (1, -1):
            schedule = original if frame == 1 else tuple(reversed(original))
            domain = schedule[1] | schedule[2]
            d_a = model.cone(schedule, 0, frame, "D").mask
            for x in bits(domain & ~d_a):
                if model.predecessors(frame)[x] & domain:
                    continue
                for y in bits(schedule[0]):
                    augmented = list(model.predecessors(frame))
                    for z in bits(model.successors(frame)[y] & domain):
                        augmented[z] |= 1 << x
                    found = False
                    for first in combinations(bits(domain), 3):
                        triple = sum(1 << z for z in first)
                        future = [schedule[0], triple, domain ^ triple, schedule[3]]
                        if not model.feasible(future, frame):
                            continue
                        target = 1 if triple >> x & 1 else 2
                        future[0] ^= (1 << x) | (1 << y)
                        future[target] ^= (1 << x) | (1 << y)
                        found |= model.feasible(future, frame)
                    self.assertEqual(model.solve(domain, frame,
                                                 predecessors=augmented) is not None, found)

    def test_exact_capacity_cnf(self):
        predecessors = [[], [], [], [1], [0], []]
        payload = exchange_payload({"jobs": list(range(6)),
                                    "augmented_predecessors": predecessors})
        cnf = payload["cnf"]
        for placement in product(range(2), repeat=6):
            assignment = []
            for name in cnf["variables"]:
                parts = name.split("_")
                if parts[0] == "job":
                    assignment.append(placement[int(parts[1])] == int(parts[3]))
                else:
                    slot, prefix, threshold = int(parts[2]), int(parts[4]), int(parts[6])
                    assignment.append(sum(t == slot for t in placement[:prefix])
                                      >= threshold)
            actual = all(any(assignment[abs(lit) - 1] == (lit > 0) for lit in clause)
                         for clause in cnf["clauses"])
            expected = (all(placement.count(t) <= 3 for t in range(2))
                        and all(placement[x] < placement[y]
                                for y in range(6) for x in predecessors[y]))
            self.assertEqual(actual, expected)

    def test_varied_center_priorities_and_split_formulas(self):
        model = Model(12, [(0, 4), (0, 8), (2, 6), (3, 10), (5, 9), (8, 11)])
        schedule = (7, 56, 448, 3584)
        stats = Construction(model, schedule, "varied", "varied", 17).run()
        self.assertGreater(stats["split_formulas"], 0)


if __name__ == "__main__":
    unittest.main()
