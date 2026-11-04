import json
from pathlib import Path
import unittest

from discharge_cover import DischargeCover
from pebbling import DIST, INDEX, replay
from solve_configuration import find_solution


class DischargeCoverTests(unittest.TestCase):
    def test_seed_template_covers_reviewed_witness(self):
        source = json.loads(Path(__file__).with_name(
            "multistage_template.json").read_text())
        source["sparse_demand"] = [
            [v, n] for v, n in enumerate(source["demand"]) if n]
        engine = DischargeCover(source["root"], INDEX[(5, 5)], [source], 10)
        selected = [(v, n) for v, n in enumerate(source["demand"]) if n]
        self.assertTrue(engine.covered_by_template(selected))
        selected = [(v, n - 1 if v == INDEX[(5, 5)] else n)
                    for v, n in selected]
        self.assertFalse(engine.covered_by_template(selected))

    def test_caps_do_not_exclude_a_rule_feasible_extension(self):
        root, heavy = INDEX[(2, 2)], INDEX[(5, 5)]
        for selected in [[(heavy, 13)], [(heavy, 59), (INDEX[(5, 7)], 2)]]:
            engine = DischargeCover(root, heavy, [], 10)
            maximum = selected[-1][1]
            caps = engine.caps(selected, maximum)
            self.assertIsNotNone(caps)
            occupied = dict(selected)
            last = selected[-1][0] if len(selected) > 1 else -1
            for v in range(64):
                if v in occupied:
                    continue
                for n in range(1, maximum + 1):
                    if last >= 0 and v < last and n == maximum:
                        continue
                    c = dict(selected + [(v, n)])
                    feasible = all(
                        sum(x >> DIST[w][u] for w, x in c.items()) <
                        1 << DIST[u][root] for u in range(64))
                    for b, children, used in engine.fans:
                        numerator = c[heavy] + 2 * sum(c.get(w, 0)
                                                       for w in children)
                        outside = c.get(b, 0) + sum(
                            x >> DIST[w][b] for w, x in c.items()
                            if w not in used)
                        feasible &= numerator // 4 + outside < 1 << DIST[b][root]
                    if feasible:
                        self.assertLessEqual(n, caps[v])

    def test_zero_slots_are_allowed_in_the_total_bound(self):
        root, heavy = INDEX[(1, 2)], INDEX[(3, 5)]
        engine = DischargeCover(root, heavy, [], 1000)
        self.assertTrue(engine.visit([(heavy, 31)]))
        self.assertGreater(engine.stats["strict_total_bounds"], 0)

    def test_tied_piles_have_one_auxiliary_order(self):
        root, heavy = INDEX[(2, 2)], INDEX[(5, 5)]
        first = INDEX[(5, 7)]
        engine = DischargeCover(root, heavy, [], 10)
        caps = engine.caps([(heavy, 13), (first, 2)], 2)
        self.assertIsNotNone(caps)
        self.assertTrue(all(caps[v] < 2 for v in range(first) if v != heavy))
        self.assertTrue(any(caps[v] == 2 for v in range(first + 1, 64)))

    def test_template_orbits_keep_exact_resource_balances(self):
        root, heavy = INDEX[(2, 2)], INDEX[(5, 5)]
        source = json.loads(Path(__file__).with_name(
            "multistage_template.json").read_text())
        engine = DischargeCover(root, heavy, [], 10)
        engine.add_template_orbit(source["moves"])
        self.assertGreater(len(engine.templates), 1)
        self.assertTrue(engine.covered_by_template(
            [(v, n) for v, n in enumerate(source["demand"]) if n]))

    def test_monotone_feasibility_supplies_a_positive_certificate(self):
        root, heavy = INDEX[(2, 2)], INDEX[(5, 5)]
        c = [0] * 64
        c[heavy] = 64
        moves, report = find_solution(
            c, root, seconds=2, greedy=True, optimize_moves=False)
        replay(c, root, moves)
        self.assertTrue(all(DIST[w][root] < DIST[v][root]
                            for v, w, _ in moves))
        self.assertEqual(report["objective"], "feasibility")

    def test_one_missing_template_resource_gives_an_exact_cap(self):
        source = json.loads(Path(__file__).with_name(
            "multistage_template.json").read_text())
        source["sparse_demand"] = [
            [v, n] for v, n in enumerate(source["demand"]) if n]
        root, heavy = source["root"], INDEX[(5, 5)]
        selected = [(heavy, 59), (INDEX[(5, 7)], 2),
                    (INDEX[(1, 5)], 1), (INDEX[(4, 8)], 1)]
        missing = INDEX[(8, 6)]
        baseline = DischargeCover(root, heavy, [], 10).caps(selected, 1)
        learned = DischargeCover(root, heavy, [source], 10).caps(selected, 1)
        self.assertEqual(baseline[missing], 1)
        self.assertEqual(learned[missing], 0)
        selected[0] = (heavy, 49)
        learned = DischargeCover(root, heavy, [source], 10).caps(selected, 1)
        self.assertEqual(learned[missing], 1)


if __name__ == "__main__":
    unittest.main()
