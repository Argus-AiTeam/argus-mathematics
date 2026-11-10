#!/usr/bin/env python3
"""Exact finite checks for the star-average semigroup and regular cavity law.

Run: python3 verification/triangle-removal/semigroup_checks.py
Optional floating-point discovery run: add --explore (requires scipy/numpy).
The default checker uses only the Python standard library. The proof belongs
in the reader's guide, not in this computational evidence.
"""

import argparse
import hashlib
import itertools
import json
import math
from dataclasses import dataclass
from fractions import Fraction as F
from pathlib import Path


@dataclass
class Graph:
    n: int
    edges: list

    def __post_init__(self):
        if self.n < 2:
            raise ValueError("at least two vertices are required")
        self.adj = [set() for _ in range(self.n)]
        seen = set()
        for u, v in self.edges:
            if not (0 <= u < self.n and 0 <= v < self.n) or u == v:
                raise ValueError("invalid endpoint or loop")
            edge = tuple(sorted((u, v)))
            if edge in seen:
                raise ValueError("duplicate undirected edge")
            seen.add(edge)
            self.adj[u].add(v)
            self.adj[v].add(u)
        self.degrees = [len(neighbors) for neighbors in self.adj]
        if min(self.degrees) == 0:
            raise ValueError("V is undefined at an isolated vertex")
        self.m = len(self.edges)

    def incidence(self, row):
        values = [0] * self.n
        for value, (u, v) in zip(row, self.edges):
            values[u] += value
            values[v] += value
        return values

    def U(self, values):
        return [values[u] + values[v] for u, v in self.edges]

    def V(self, row):
        return [F(value, d) for value, d in
                zip(self.incidence(row), self.degrees)]

    def W(self, values):
        return [sum((values[v] for v in ns), F(0)) / d
                for ns, d in zip(self.adj, self.degrees)]

    def P(self, row):
        return self.U(self.V(row))

    def Q(self, row):
        return self.U(self.W(self.V(row)))

    def eta(self):
        regular = len(set(self.degrees)) == 1
        result = F(0)
        for u in range(self.n):
            counts = [0] * self.n
            for v in self.adj[u]:
                for w in self.adj[v]:
                    counts[w] += (1 if regular else
                                  F(1, self.degrees[u] * self.degrees[v]))
            if regular:
                d = self.degrees[0]
                total = F(sum(abs(self.n * c - d * d) for c in counts),
                          self.n * d * d)
            else:
                total = sum((abs(c - F(d, 2 * self.m)) for c, d in
                             zip(counts, self.degrees)), F(0))
            result = max(result, total)
        return result


def build(spec):
    kind = spec["kind"]
    if kind == "complete":
        n = spec["n"]
        return Graph(n, list(itertools.combinations(range(n), 2)))
    if kind == "path":
        n = spec["n"]
        return Graph(n, [(u, u + 1) for u in range(n - 1)])
    if kind == "cycle":
        n = spec["n"]
        return Graph(n, [(u, (u + 1) % n) for u in range(n)])
    if kind == "star":
        n = spec["n"]
        return Graph(n, [(0, u) for u in range(1, n)])
    if kind == "theta":
        k, length = spec["k"], spec["length"]
        if k < 1 or length < 3 or length % 2 == 0:
            raise ValueError("theta requires k >= 1 and odd length >= 3")
        edges = [(0, 1)]
        paths = []
        for i in range(k):
            path = [0] + list(range(2 + i * (length - 1),
                                   2 + (i + 1) * (length - 1))) + [1]
            paths.append(path)
            edges.extend(zip(path, path[1:]))
        graph = Graph(2 + k * (length - 1), edges)
        graph.paths = paths
        return graph
    if kind == "symplectic":
        q = spec["q"]
        if q < 2 or any(q % a == 0 for a in range(2, math.isqrt(q) + 1)):
            raise ValueError("this constructor requires a prime q")
        vertices = []
        for point in itertools.product(range(q), repeat=4):
            if any(point) and next(x for x in point if x) == 1:
                vertices.append(point)
        edges = []
        for u, x in enumerate(vertices):
            for v, y in enumerate(vertices[:u]):
                if (x[0] * y[1] - x[1] * y[0] +
                        x[2] * y[3] - x[3] * y[2]) % q == 0:
                    edges.append((v, u))
        return Graph(len(vertices), edges)
    raise ValueError(f"unknown graph kind: {kind}")


def tail(s, order):
    x = 2 * s
    if s < 0 or order < 0 or x >= order + 2:
        raise ValueError("invalid time or insufficient Taylor order")
    return x ** (order + 1) / math.factorial(order + 1) / (1 - x / (order + 2))


def exponential_row(graph, index, s, order):
    initial = [0] * graph.m
    initial[index] = 1
    if len(set(graph.degrees)) == 1:
        d = graph.degrees[0]
        base = s.denominator * d
        denominator = base ** order * math.factorial(order)
        coefficient = denominator
        power = initial
        numerator = [0] * graph.m
        for k in range(order + 1):
            numerator = [a + coefficient * b for a, b in zip(numerator, power)]
            if k != order:
                incident = graph.incidence(power)
                power = graph.U(incident)
                top = -s.numerator * coefficient
                divisor = base * (k + 1)
                assert top % divisor == 0
                coefficient = top // divisor
        return [F(x, denominator) for x in numerator], tail(s, order)
    total = [F(x) for x in initial]
    term = total[:]
    for k in range(1, order + 1):
        term = [-s * x / k for x in graph.P(term)]
        total = [x + y for x, y in zip(total, term)]
    return total, tail(s, order)


def scalar_exp_minus(s, order):
    value = term = F(1)
    for k in range(1, order + 1):
        term *= -s / k
        value += term
    if s >= order + 2:
        raise ValueError("insufficient scalar Taylor order")
    error = s ** (order + 1) / math.factorial(order + 1) / (1 - s / (order + 2))
    return value, error


def interval(lo, hi, places=12):
    scale = 10 ** places
    lower = lo.numerator * scale // lo.denominator
    upper = -((-hi.numerator * scale) // hi.denominator)
    return {"lower": f"{lower}/{scale}", "upper": f"{upper}/{scale}"}


def check_kernel_and_gradient(graph, vector, potential):
    if any(graph.incidence(vector)):
        raise AssertionError("candidate is not in ker(B)")
    complement = graph.U(potential)
    target = [F(int(i == 0)) - value for i, value in enumerate(vector)]
    if target != complement:
        raise AssertionError("complement is not the supplied B^T potential")


def theta_projection(graph, spec):
    k, length = spec["k"], spec["length"]
    denominator = k + length
    vector = [F(k, denominator)]
    potential = [F(0)] * graph.n
    potential[0] = F(length, denominator)
    for path in graph.paths:
        for j, vertex in enumerate(path):
            potential[vertex] = F((-1) ** j * (length - j), denominator)
        vector.extend(F((-1) ** (j + 1), denominator) for j in range(length))
    check_kernel_and_gradient(graph, vector, potential)
    norm = sum(map(abs, vector))
    assert norm == F(k * (length + 1), denominator)
    return vector, potential, norm


def symplectic_projection(graph, q):
    n, d = (q + 1) * (q * q + 1), q * (q + 1)
    assert graph.n == n and set(graph.degrees) == {d}
    for u in range(n):
        for v in range(u):
            expected = q - 1 if v in graph.adj[u] else q + 1
            assert len(graph.adj[u] & graph.adj[v]) == expected
    a, b, c = F(d - q - 1, d * d), F(-2, d), F((q + 1) * n, d * d)
    y = -1 / (1 + b - a)
    x, z = (1 + b) / (1 + b - a), -y * c / 2
    assert x + a * y == 1 and x + (1 + b) * y == 0 and c * y + 2 * z == 0
    initial = [F(int(i == 0)) for i in range(graph.m)]
    values = graph.V(initial)
    walked = graph.W(values)
    potential = [x * value + y * step + z / graph.m
                 for value, step in zip(values, walked)]
    vector = [value - correction for value, correction in
              zip(initial, graph.U(potential))]
    check_kernel_and_gradient(graph, vector, potential)
    assert graph.eta() == 2 * (F(q, q * q + 1) - F(q - 1, q * (q + 1)))
    return sum(map(abs, vector))


def cavity_interval(d, t):
    if d == 0:
        return F(1), F(1)
    if d == 1:
        return 1 - t, 1 - t
    k = 2 * d - 3
    target = (1 + k * t) ** (-d)
    lo, hi = F(0), F(1)
    for _ in range(80):
        mid = (lo + hi) / 2
        power = mid ** k
        if power == target:
            return mid, mid
        if power < target:
            lo = mid
        else:
            hi = mid
    return lo, hi


def expect_rejection(label, function):
    try:
        function()
    except (ValueError, AssertionError):
        return label
    raise AssertionError(f"negative control was accepted: {label}")


def negative_controls():
    graph = build({"kind": "theta", "k": 2, "length": 3})
    vector, potential, _ = theta_projection(graph, {"k": 2, "length": 3})
    flipped = vector[:]
    flipped[1] = -flipped[1]
    wrong_potential = potential[:]
    wrong_potential[0] += 1
    return [
        expect_rejection("loop", lambda: Graph(2, [(0, 0), (0, 1)])),
        expect_rejection("duplicate edge", lambda: Graph(2, [(0, 1), (1, 0)])),
        expect_rejection("isolated vertex", lambda: Graph(3, [(0, 1)])),
        expect_rejection("wrong theta parity",
                         lambda: build({"kind": "theta", "k": 2, "length": 4})),
        expect_rejection("flipped projection entry",
                         lambda: check_kernel_and_gradient(graph, flipped, potential)),
        expect_rejection("wrong potential",
                         lambda: check_kernel_and_gradient(graph, vector, wrong_potential)),
        expect_rejection("negative time", lambda: tail(F(-1), 40)),
        expect_rejection("insufficient Taylor order", lambda: tail(F(8), 3)),
        expect_rejection("false norm certificate",
                         lambda: assert_window(F(2), F(2), ["0", "1"])),
        expect_rejection("bipartite graph used as mixing example",
                         lambda: require_mixing(build({"kind": "cycle", "n": 4}).eta())),
    ]


def require_mixing(eta):
    if not eta < 1:
        raise ValueError("the constant-six theorem requires eta < 1")


def assert_window(lo, hi, window):
    assert F(window[0]) <= lo <= hi <= F(window[1]), (lo, hi, window)


def run_checks(data):
    result = {"arithmetic": "exact rational Taylor intervals; no floating-point evidence",
              "negative_controls_rejected": negative_controls(), "graphs": []}
    root = Path(__file__).resolve().parents[2]
    result["source_sha256"] = {}
    for name, digest in data["source_sha256"].items():
        actual = hashlib.sha256((root / name).read_bytes()).hexdigest()
        assert actual == digest, f"source changed: {name}"
        result["source_sha256"][name] = actual
    order = data["taylor_order"]
    for case in data["graphs"]:
        graph = build(case)
        eta = graph.eta()
        entry = {"name": case["name"], "n": graph.n, "m": graph.m,
                 "degree_min": min(graph.degrees), "degree_max": max(graph.degrees),
                 "eta": str(eta), "times": []}
        if "projection_norm" in case:
            if case["kind"] == "theta":
                _, _, norm = theta_projection(graph, case)
            else:
                norm = symplectic_projection(graph, case["q"])
            assert norm == F(case["projection_norm"]), (
                case["name"], str(norm), case["projection_norm"])
            entry["terminal_projection_row_0_l1"] = str(norm)
        for time_case in case.get("times", []):
            s = F(time_case["s"])
            rows = range(graph.m) if case.get("all_rows") else [0]
            values = []
            for index in rows:
                row, error = exponential_row(graph, index, s, order)
                values.append(sum(map(abs, row)))
            norm = max(values)
            lo, hi = max(F(0), norm - error), norm + error
            assert_window(lo, hi, time_case["norm_window"])
            record = {"s": str(s), "quantity": "operator infinity norm" if
                      case.get("all_rows") else "row 0 l1 norm",
                      "certified_interval": interval(lo, hi),
                      "Taylor_tail_upper": interval(F(0), error, 24)["upper"]}
            if eta < 1:
                one = [F(int(i == 0)) for i in range(graph.m)]
                p, q = graph.P(one), graph.Q(one)
                e1, r1 = scalar_exp_minus(s, order)
                e2, r2 = scalar_exp_minus(2 * s, order)
                alpha, beta = 1 - e1, 1 - (1 + s) * e1
                gamma = 1 - e2 - 2 * s * e1
                approximate = [v - alpha * a + beta * b - gamma / graph.m
                               for v, a, b in zip(one, p, q)]
                exact_row, row_error = exponential_row(graph, 0, s, order)
                residual = sum(abs(x - y) for x, y in zip(exact_row, approximate))
                residual_upper = residual + row_error + (4 + 4 * s) * r1 + r2
                assert residual_upper <= 4 * eta / (1 - eta)
                record["mixing_decomposition_residual"] = interval(F(0), residual_upper)
                record["theoretical_residual_bound"] = str(4 * eta / (1 - eta))
            entry["times"].append(record)
        result["graphs"].append(entry)
    result["cavity_terminal"] = []
    for case in data["cavity"]:
        d = case["D"]
        lo, hi = cavity_interval(d, F(1))
        assert_window(lo, hi, case["terminal_window"])
        if d >= 2:
            k = 2 * d - 3
            assert F(1 + 2 * d) ** k <= F(1 + k) ** (2 * d)
        record = {"D": d, "q_D_interval": interval(lo, hi)}
        if "published_table_1_upper" in case:
            lower_ceil = -((-lo.numerator * 1000) // lo.denominator)
            upper_ceil = -((-hi.numerator * 1000) // hi.denominator)
            assert lower_ceil == upper_ceil
            assert F(lower_ceil, 1000) == F(case["published_table_1_upper"])
            record["published_table_1_upper_confirmed"] = case["published_table_1_upper"]
        result["cavity_terminal"].append(record)
    return result


def explore(data):
    import numpy as np
    from scipy.sparse import lil_matrix
    from scipy.sparse.linalg import expm_multiply
    output = {"status": "floating-point exploration only", "graphs": []}
    for case in data["graphs"]:
        graph = build(case)
        incidence = lil_matrix((graph.n, graph.m))
        for j, (u, v) in enumerate(graph.edges):
            incidence[u, j] = incidence[v, j] = 1
        b = incidence.tocsr()
        p = b.T @ b.multiply((1 / np.array(graph.degrees))[:, None])
        initial = np.zeros(graph.m)
        initial[0] = 1
        entry = {"name": case["name"], "row_0_l1": []}
        for tc in case.get("times", []):
            s = float(F(tc["s"]))
            value = float(abs(expm_multiply(-s * p, initial)).sum())
            entry["row_0_l1"].append({"s": s, "value": value,
                                    "paper_bound": 1 + 2 * s,
                                    "profile_F": 6 - 4 * (s + 1) * math.exp(-s)
                                    - math.exp(-2 * s)})
        output["graphs"].append(entry)
    return output


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path,
                        default=Path(__file__).with_name("semigroup_cases.json"))
    parser.add_argument("--explore", action="store_true")
    args = parser.parse_args()
    data = json.loads(args.input.read_text())
    print(json.dumps(explore(data) if args.explore else run_checks(data),
                     indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
