#!/usr/bin/env python3
"""Exact BMP construction and transported-edge tests in type A.

Requires Python, SymPy, NetworkX, and Singular. No KL character formula is
used to construct the stalks or to decide polynomial-module membership.
"""

import argparse
import functools
import itertools
import json
import shutil
import subprocess
from collections import deque
from fractions import Fraction
from pathlib import Path

import networkx as nx
import sympy as sp


@functools.cache
def length(w):
    return sum(a > b for i, a in enumerate(w) for b in w[i + 1 :])


@functools.cache
def bruhat(x, y):
    return all(
        all(a <= b for a, b in zip(sorted(x[:k]), sorted(y[:k])))
        for k in range(1, len(x) + 1)
    )


def reflected(w, i, j):
    return tuple(j if v == i else i if v == j else v for v in w)


def label(x, y):
    changed = sorted(a for a, b in zip(x, y) if a != b)
    if len(changed) != 2 or reflected(x, *changed) != y:
        raise ValueError(f"Not a left-reflection edge: {x}, {y}")
    return tuple(changed)


def identity_columns(n):
    return [["1" if i == j else "0" for i in range(n)] for j in range(n)]


def module_text(columns):
    return ",".join("[" + ",".join(col) + "]" for col in columns) or "0"


def write_json(path, data):
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_text(json.dumps(data, indent=2) + "\n")
    temporary.replace(path)


class ExactAlgebra:
    def __init__(self, n):
        self.names = tuple(f"x{i}" for i in range(1, n))
        self.variables = sp.symbols(" ".join(self.names), seq=True)
        self.locals = dict(zip(self.names, self.variables))
        self.calls = 0
        if shutil.which("Singular") is None:
            raise RuntimeError("Singular is required for exact module computations")

    def run(self, body):
        self.calls += 1
        source = (
            f"ring r=0,({','.join(self.names)}),dp;\nshort=0;\n"
            + body
            + "\nquit;\n"
        )
        answer = subprocess.run(
            ["Singular", "-q"],
            input=source,
            text=True,
            capture_output=True,
            timeout=90,
            check=True,
        )
        if "?" in answer.stdout or answer.stderr.strip():
            raise RuntimeError(answer.stdout + answer.stderr)
        return answer.stdout.splitlines()

    def matrix(self, body, name, rows):
        lines = self.run(
            body
            + f'\nmatrix O={name};\nprint("__MATRIX__");\n'
            + f"print({rows});print(ncols(O));\n"
            + f"int i,j;for(j=1;j<=ncols(O);j++){{"
            + f"for(i=1;i<={rows};i++){{print(O[i,j]);}}}}"
        )
        start = lines.index("__MATRIX__")
        nrows, ncols = map(int, lines[start + 1 : start + 3])
        values = lines[start + 3 :]
        if nrows != rows or len(values) != rows * ncols:
            raise RuntimeError(f"Incomplete Singular matrix: {lines}")
        return [
            values[j * rows : (j + 1) * rows]
            for j in range(ncols)
            if any(v != "0" for v in values[j * rows : (j + 1) * rows])
        ]

    @functools.lru_cache(maxsize=16384)
    def polynomial(self, expression):
        return sp.Poly(
            sp.sympify(expression.replace("^", "**"), locals=self.locals),
            *self.variables,
            domain=sp.QQ,
        )

    def expression(self, terms):
        p = sp.Poly.from_dict(terms, self.variables, domain=sp.QQ)
        return str(p.as_expr()).replace("**", "^")

    def homogeneous(self, columns, shifts):
        components = []
        seen = set()
        for col in columns:
            pieces = {}
            for row, value in enumerate(col):
                for monomial, coefficient in self.polynomial(value).terms():
                    if coefficient == 0:
                        continue
                    degree = sum(monomial) + shifts[row]
                    pieces.setdefault(degree, [{} for _ in shifts])
                    pieces[degree][row][monomial] = coefficient
            for degree, rows in pieces.items():
                vector = tuple(self.expression(terms) for terms in rows)
                if vector not in seen:
                    seen.add(vector)
                    components.append((degree, list(vector)))
        return sorted(components, key=lambda entry: (entry[0], entry[1]))

    def minimal_generators(self, columns, shifts, relations=()):
        candidates = self.homogeneous(columns, shifts)
        if not candidates:
            return [], []
        body = (
            f"module P={module_text(relations)};\n"
            + "module GS=std(P);module H;vector v;\n"
        )
        for index, (_, col) in enumerate(candidates):
            body += (
                f"H={module_text([col])};v=H[1];\n"
                + f'if(reduce(v,GS)!=0){{print("KEEP={index}");'
                + "P=P+H;GS=std(P);}\n"
            )
        keep = [
            int(line.split("=")[1])
            for line in self.run(body)
            if line.startswith("KEEP=")
        ]
        return (
            [candidates[i][1] for i in keep],
            [candidates[i][0] for i in keep],
        )

    def kernel_mod(self, columns, relations, domain_rank):
        if not relations and not any(any(v != "0" for v in c) for c in columns):
            return identity_columns(domain_rank)
        return self.matrix(
            f"module M={module_text(columns + relations)};module S=syz(M);",
            "S",
            domain_rank,
        )

    def product(self, left, right, rows):
        if not left or not right:
            return []
        return self.matrix(
            f"module L={module_text(left)};module R={module_text(right)};"
            + "matrix ML=L;matrix MR=R;matrix P=ML*MR;",
            "P",
            rows,
        )

    def remainders(self, columns, generators, rows):
        if not columns:
            return []
        return self.matrix(
            f"module M={module_text(columns)};"
            + f"module N={module_text(generators)};"
            + "module G=std(N);module R=reduce(M,G);",
            "R",
            rows,
        )


class BMP:
    def __init__(self, top):
        self.top = top
        self.n = len(top)
        self.algebra = ExactAlgebra(self.n)
        self.vertices = sorted(
            (w for w in itertools.permutations(range(1, self.n + 1)) if bruhat(w, top)),
            key=lambda w: (length(w), w),
        )
        self.edges = [
            (x, y)
            for x in self.vertices
            for i, j in itertools.combinations(range(1, self.n + 1), 2)
            if (y := reflected(x, i, j)) in self.vertices and length(x) < length(y)
        ]
        self.out = {x: [e for e in self.edges if e[0] == x] for x in self.vertices}
        self.shifts = {top: [0]}
        self.maps = {}
        self.kernels = {}
        self.tested = {}
        self.construction = []
        for x in reversed(self.vertices[:-1]):
            self.construct_vertex(x)

    @classmethod
    def from_export(cls, data):
        obj = cls.__new__(cls)
        obj.top = tuple(data["top"])
        obj.n = len(obj.top)
        obj.algebra = ExactAlgebra(obj.n)
        obj.shifts = {
            tuple(item["vertex"]): item["generator_degrees"] for item in data["stalks"]
        }
        obj.vertices = sorted(obj.shifts, key=lambda x: (length(x), x))
        obj.maps = {
            tuple(map(tuple, item["edge"])): item["columns"]
            for item in data["lower_endpoint_maps"]
        }
        obj.edges = list(obj.maps)
        obj.out = {x: [e for e in obj.edges if e[0] == x] for x in obj.vertices}
        obj.kernels = {}
        obj.tested = {}
        obj.construction = []
        return obj

    def root(self, pair):
        i, j = pair
        return f"x{i}" if j == self.n else f"(x{i}-x{j})"

    def relation_columns(self, edges):
        rows = sum(len(self.shifts[y]) for _, y in edges)
        columns = []
        offset = 0
        for edge in edges:
            for _ in self.shifts[edge[1]]:
                col = ["0"] * rows
                col[offset] = self.root(label(*edge))
                columns.append(col)
                offset += 1
        return columns

    def construct_vertex(self, x):
        upper = [y for y in self.vertices if y != x and bruhat(x, y)]
        offsets = {}
        rank = 0
        for y in upper:
            offsets[y] = rank
            rank += len(self.shifts[y])
        internal = [e for e in self.edges if e[0] in upper and e[1] in upper]
        rows = sum(len(self.shifts[e[1]]) for e in internal)
        matrix = [["0"] * rows for _ in range(rank)]
        offset = 0
        for edge in internal:
            a, b = edge
            for j, col in enumerate(self.maps[edge]):
                for i, value in enumerate(col):
                    matrix[offsets[a] + j][offset + i] = value
            for i in range(len(self.shifts[b])):
                matrix[offsets[b] + i][offset + i] = "-1"
            offset += len(self.shifts[b])
        sections = self.algebra.kernel_mod(
            matrix, self.relation_columns(internal), rank
        )
        boundary_rows = [
            offsets[y] + i
            for _, y in self.out[x]
            for i in range(len(self.shifts[y]))
        ]
        boundary = [[col[i] for i in boundary_rows] for col in sections]
        boundary_shifts = [s for _, y in self.out[x] for s in self.shifts[y]]
        generators, degrees = self.algebra.minimal_generators(
            boundary, boundary_shifts, self.relation_columns(self.out[x])
        )
        if not generators or any(d < 0 for d in degrees):
            raise RuntimeError(f"Invalid BMP projective cover at {x}")
        self.shifts[x] = degrees
        offset = 0
        for edge in self.out[x]:
            r = len(self.shifts[edge[1]])
            self.maps[edge] = [col[offset : offset + r] for col in generators]
            offset += r
        self.construction.append(
            {"vertex": list(x), "boundary_generator_degrees": degrees}
        )

    def kernel(self, x, edges):
        key = (x, tuple(sorted(edges)))
        if key not in self.kernels:
            r = len(self.shifts[x])
            matrix = [
                [
                    value
                    for edge in edges
                    for value in self.maps[edge][j]
                ]
                for j in range(r)
            ]
            self.kernels[key] = self.algebra.kernel_mod(
                matrix, self.relation_columns(edges), r
            )
        return self.kernels[key]

    def scalar(self, edge):
        x, _ = edge
        i, j = label(*edge)
        positions = {a: x.index(a) for a in range(1, self.n + 1)}
        middle = [
            k
            for k in range(i + 1, j)
            if positions[i] < positions[k] < positions[j]
        ]
        if length(edge[1]) - length(x) != 1 + 2 * len(middle):
            raise AssertionError("Incorrect type-A edge orientation or length")
        return "*".join(self.root((i, k)) for k in middle) or "1"

    def compare(self, edge, later_x, later_y):
        key = (edge, tuple(sorted(later_x)), tuple(sorted(later_y)))
        if key in self.tested:
            return self.tested[key]
        x, y = edge
        rows = len(self.shifts[y])
        lower = self.kernel(x, later_x)
        upper = self.kernel(y, later_y)
        image = self.algebra.product(self.maps[edge], lower, rows)
        f = self.scalar(edge)
        target = [[f"({f})*({v})" for v in col] for col in upper]
        relations = self.relation_columns([edge])
        forward = self.algebra.remainders(image, target + relations, rows)
        backward = self.algebra.remainders(target, image + relations, rows)
        result = {
            "equality": not forward and not backward,
            "inclusion": not forward,
            "edge": [list(x), list(y)],
            "label": list(label(*edge)),
            "f": f,
            "later_x": [[list(a), list(b)] for a, b in later_x],
            "later_y": [[list(a), list(b)] for a, b in later_y],
            "I_generators": image,
            "fJ_generators": target,
            "I_mod_fJ_remainders": forward,
            "fJ_mod_I_remainders": backward,
        }
        self.tested[key] = result
        return result

    def free_kernel(self, x, edges):
        basis, shifts = self.algebra.minimal_generators(
            self.kernel(x, edges), self.shifts[x]
        )
        syzygies = self.algebra.matrix(
            f"module M={module_text(basis)};module S=syz(M);",
            "S",
            len(basis),
        )
        return {"free": not syzygies, "degrees": shifts, "basis": basis}

    def export(self):
        return {
            "top": list(self.top),
            "field": "QQ (faithfully extending to RR preserves all tests)",
            "ring": list(self.algebra.names),
            "stalks": [
                {"vertex": list(x), "generator_degrees": self.shifts[x]}
                for x in self.vertices
            ],
            "lower_endpoint_maps": [
                {"edge": [list(x), list(y)], "columns": self.maps[(x, y)]}
                for x, y in self.edges
            ],
            "construction": "Descending graded minimal covers of actual boundary-section images",
        }


@functools.cache
def interval_graph(vertices, bottom, top):
    graph = nx.DiGraph()
    members = [x for x in vertices if bruhat(bottom, x) and bruhat(x, top)]
    for x in members:
        graph.add_node(x, rank=length(x) - length(bottom))
    for x in members:
        for y in members:
            if length(y) == length(x) + 1 and bruhat(x, y):
                graph.add_edge(x, y)
    return graph


@functools.cache
def validate_type_a(n):
    identity = tuple(range(1, n + 1))
    distances = {identity: 0}
    queue = deque([identity])
    while queue:
        w = queue.popleft()
        for i in range(n - 1):
            v = list(w)
            v[i], v[i + 1] = v[i + 1], v[i]
            v = tuple(v)
            if v not in distances:
                distances[v] = distances[w] + 1
                queue.append(v)
    vertices = tuple(itertools.permutations(range(1, n + 1)))
    if set(distances) != set(vertices) or any(distances[w] != length(w) for w in vertices):
        raise AssertionError("Inversion count disagrees with exact Coxeter word length")
    conjugates = {
        tuple(sorted((w[i], w[i + 1])))
        for w in vertices for i in range(n - 1)
    }
    if conjugates != set(itertools.combinations(range(1, n + 1), 2)):
        raise AssertionError("The transpositions are not precisely the reflections")
    strong = nx.DiGraph()
    strong.add_nodes_from(vertices)
    for x in vertices:
        for i, j in conjugates:
            y = reflected(x, i, j)
            if distances[x] < distances[y]:
                strong.add_edge(x, y)
    covers = nx.DiGraph()
    covers.add_nodes_from(vertices)
    covers.add_edges_from(
        (x, y) for x, y in strong.edges if distances[y] == distances[x] + 1
    )
    strong_order = set(nx.transitive_closure_dag(strong).edges)
    cover_order = set(nx.transitive_closure_dag(covers).edges)
    prefix_order = {(x, y) for x in vertices for y in vertices if x != y and bruhat(x, y)}
    if strong_order != prefix_order or cover_order != prefix_order:
        raise AssertionError("Prefix, reflection, and Hasse definitions disagree")
    return {
        "n": n,
        "group_order": len(vertices),
        "reflections": len(conjugates),
        "strict_comparable_pairs": len(strong_order),
        "increasing_reflection_edges": strong.number_of_edges(),
        "hasse_edges": covers.number_of_edges(),
        "coxeter_lengths_verified_by_bfs": True,
        "prefix_order_equals_strong_bruhat_and_hasse_closure": True,
    }


def geometric_scores(n, f=None):
    h = [n - i for i in range(1, n + 1)]
    f = f or [2 ** i for i in range(n)]
    scores = {
        (i, j): Fraction(f[i - 1] - f[j - 1], h[i - 1] - h[j - 1])
        for i, j in itertools.combinations(range(1, n + 1), 2)
    }
    if len(set(scores.values())) != len(scores):
        raise ValueError("The chosen geometric order has tied root slopes")
    return h, f, scores


def geometric_orders(n, count):
    base = [2 ** i for i in range(n)]
    candidates = []
    for k in range(n):
        rotation = base[k:] + base[:k]
        candidates.extend([rotation, list(reversed(rotation))])
    candidates.extend(itertools.permutations(base))
    orders = []
    seen = set()
    for f in candidates:
        try:
            h, f, scores = geometric_scores(n, list(f))
        except ValueError:
            continue
        signature = tuple(sorted(scores, key=scores.get))
        if signature in seen:
            continue
        seen.add(signature)
        orders.append((h, f, scores))
        if len(orders) == count:
            return orders
    raise ValueError(f"Only {len(orders)} distinct orders in the specified sample")


def pattern_tops(n):
    answer = []
    for w in itertools.permutations(range(1, n + 1)):
        for indices in itertools.combinations(range(n), 4):
            values = [w[i] for i in indices]
            pattern = tuple(1 + sum(b < a for b in values) for a in values)
            if pattern in [(3, 4, 1, 2), (4, 2, 3, 1)]:
                answer.append(w)
                break
    return answer


def check_schedule(bmp, bottom, iso, scores, target_label=label):
    edges = [e for e in bmp.edges if bruhat(bottom, e[0])]
    priorities = {e: scores[target_label(iso[e[0]], iso[e[1]])] for e in edges}
    for x in iso:
        incident = [e for e in edges if x in e]
        if len({priorities[e] for e in incident}) != len(incident):
            raise AssertionError("A reflection-label tie meets a vertex")
    for edge in sorted(edges, key=lambda e: (priorities[e], e)):
        x, y = edge
        later_x = [e for e in bmp.out[x] if priorities[e] > priorities[edge]]
        later_y = [e for e in bmp.out[y] if priorities[e] > priorities[edge]]
        result = bmp.compare(edge, later_x, later_y)
        if not result["equality"]:
            result = dict(result)
            result["upper_kernel"] = bmp.free_kernel(y, later_y)
            return result
    return None


def search(tops, output, max_isomorphisms, order_count=1):
    n = len(tops[0])
    domain_validation = validate_type_a(n)
    all_vertices = tuple(itertools.permutations(range(1, n + 1)))
    orders = geometric_orders(n, order_count)
    tested_isomorphisms = 0
    tested_schedules = 0
    summary = []

    def save_finite(search_status):
        write_json(output, {
            "result_class": "finite_verification",
            "search_status": search_status,
            "type_a_hypotheses": domain_validation,
            "isomorphisms_tested": tested_isomorphisms,
            "schedules_tested": tested_schedules,
            "isomorphism_limit": max_isomorphisms,
            "isomorphism_limit_reached": tested_isomorphisms >= max_isomorphisms,
            "requested_source_tops": [list(w) for w in tops],
            "all_requested_tops_completed": (
                search_status == "complete" and tested_isomorphisms < max_isomorphisms
            ),
            "completed_source_tops": [
                case["top"] for case in summary if case["source_top_exhausted"]
            ],
            "target_geometric_orders": [{"h": h, "f": f} for h, f, _ in orders],
            "cases": summary,
            "limitation": "No uniform rigidity conclusion follows from passing finite tests.",
        })

    for top in tops:
        initial_isomorphisms = tested_isomorphisms
        initial_schedules = tested_schedules
        bmp = BMP(top)
        print(f"BMP {top}: {len(bmp.vertices)} vertices; "
              f"{sum(len(bmp.shifts[x]) > 1 for x in bmp.vertices)} singular stalks",
              flush=True)
        for bottom in bmp.vertices:
            if len(bmp.shifts[bottom]) <= 1:
                continue
            source = interval_graph(all_vertices, bottom, top)
            for target_top in all_vertices:
                for target_bottom in all_vertices:
                    if not bruhat(target_bottom, target_top):
                        continue
                    if length(target_top) - length(target_bottom) != length(top) - length(bottom):
                        continue
                    target = interval_graph(all_vertices, target_bottom, target_top)
                    if len(target) != len(source) or target.number_of_edges() != source.number_of_edges():
                        continue
                    matcher = nx.algorithms.isomorphism.DiGraphMatcher(
                        source, target,
                        node_match=lambda a, b: a["rank"] == b["rank"],
                    )
                    for iso in matcher.isomorphisms_iter():
                        tested_isomorphisms += 1
                        for h, f, scores in orders:
                            tested_schedules += 1
                            defect = check_schedule(bmp, bottom, iso, scores)
                            if defect:
                                certificate = {
                                    "result_class": "candidate_exact_counterexample",
                                    "type_a_hypotheses": domain_validation,
                                    "source_bottom": list(bottom),
                                    "source_top": list(top),
                                    "target_bottom": list(target_bottom),
                                    "target_top": list(target_top),
                                    "isomorphism": [
                                        [list(x), list(iso[x])] for x in sorted(iso)
                                    ],
                                    "target_geometric_order": {"h": h, "f": f},
                                    "defect": defect,
                                    "bmp": bmp.export(),
                                    "isomorphisms_tested_before_witness": tested_isomorphisms,
                                    "schedules_tested_before_witness": tested_schedules,
                                }
                                write_json(output, certificate)
                                print(f"DEFECT saved to {output}", flush=True)
                                return
                        if tested_isomorphisms >= max_isomorphisms:
                            break
                    if tested_isomorphisms >= max_isomorphisms:
                        break
                if tested_isomorphisms >= max_isomorphisms:
                    break
            if tested_isomorphisms >= max_isomorphisms:
                break
        summary.append({
            "top": list(top),
            "isomorphisms_tested": tested_isomorphisms - initial_isomorphisms,
            "schedules_tested": tested_schedules - initial_schedules,
            "source_top_exhausted": tested_isomorphisms < max_isomorphisms,
            "module_comparisons": len(bmp.tested),
            "singular_calls": bmp.algebra.calls,
            "bmp": bmp.export(),
        })
        save_finite("checkpoint")
        if tested_isomorphisms >= max_isomorphisms:
            break
    save_finite("isomorphism_limit" if tested_isomorphisms >= max_isomorphisms else "complete")
    print(f"No defect in {tested_schedules} schedules over "
          f"{tested_isomorphisms} genuine isomorphisms", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--tops", nargs="+", default=["3412", "4231"])
    parser.add_argument("--all-pattern-tops", type=int)
    parser.add_argument("--orders", type=int, default=1)
    parser.add_argument("--max-isomorphisms", type=int, default=10000)
    parser.add_argument("--output", type=Path, default=Path(__file__).with_name("search.json"))
    args = parser.parse_args()
    if args.orders < 1:
        parser.error("--orders must be positive")
    if args.max_isomorphisms < 1:
        parser.error("--max-isomorphisms must be positive")
    tops = (
        pattern_tops(args.all_pattern_tops)
        if args.all_pattern_tops is not None
        else [tuple(map(int, top)) for top in args.tops]
    )
    if not tops or len({len(w) for w in tops}) != 1:
        parser.error("Choose nonempty tops of a common type-A rank")
    if any(sorted(w) != list(range(1, len(w) + 1)) or len(w) < 2 for w in tops):
        parser.error("Each top must be a permutation of 1,...,n with n>=2")
    search(tops, args.output, args.max_isomorphisms, args.orders)


if __name__ == "__main__":
    main()
