#!/usr/bin/env python3
"""Rebuild an S4 BMP sheaf and check a supplied nonfree partial-kernel witness."""

import argparse
import ast
import copy
import itertools
import json
import re
import subprocess
import sys
import tempfile
from fractions import Fraction
from pathlib import Path

import sympy as sp

import bmp_a3


VARIABLES = sp.symbols("a b c")
SYMBOLS = dict(zip(("a", "b", "c"), VARIABLES))


def require(condition, message):
    if not condition:
        raise ValueError(message)


def polynomial(text):
    require(isinstance(text, str) and len(text) <= 2000, "invalid polynomial text")

    def visit(node):
        if isinstance(node, ast.Expression):
            return visit(node.body)
        if isinstance(node, ast.Constant) and type(node.value) is int:
            require(abs(node.value) <= 10**9, "coefficient too large")
            return sp.Integer(node.value)
        if isinstance(node, ast.Name) and node.id in SYMBOLS:
            return SYMBOLS[node.id]
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, (ast.UAdd, ast.USub)):
            value = visit(node.operand)
            return value if isinstance(node.op, ast.UAdd) else -value
        if isinstance(node, ast.BinOp):
            left, right = visit(node.left), visit(node.right)
            if isinstance(node.op, ast.Add):
                return left + right
            if isinstance(node.op, ast.Sub):
                return left - right
            if isinstance(node.op, ast.Mult):
                return left * right
            if isinstance(node.op, ast.Div):
                require(right.is_Rational and right != 0, "nonconstant or zero denominator")
                return left / right
            if isinstance(node.op, ast.Pow):
                require(right.is_Integer and 0 <= right <= 12, "invalid polynomial exponent")
                return left**right
        raise ValueError("only exact rational polynomials in a,b,c are allowed")

    try:
        value = sp.Poly(visit(ast.parse(text, mode="eval")), *VARIABLES, domain=sp.QQ)
    except (SyntaxError, sp.PolynomialError, sp.CoercionFailed) as exc:
        raise ValueError("invalid rational polynomial") from exc
    require(value.total_degree() <= 20, "polynomial degree too large")
    return value.as_expr()


def singular_polynomial(text):
    require(re.fullmatch(r"[abc0-9+\-/ ]+", text) is not None, "unexpected Singular output")
    expanded = re.sub(
        r"([abc])([0-9]*)",
        lambda m: "*" + m[1] + ("**" + m[2] if m[2] else ""),
        text.replace(" ", ""),
    )
    return polynomial(re.sub(r"(^|[+\-])\*", r"\1", expanded))


def decode_matrix(record, start):
    rows, cols = map(int, record[start : start + 2])
    entries = record[start + 2].split(",")
    require(len(entries) == rows * cols, "truncated matrix output")
    return sp.Matrix(rows, cols, [singular_polynomial(e) for e in entries])


def input_matrix(data, rows, cols):
    require(isinstance(data, list) and len(data) == rows, "wrong matrix row count")
    require(all(isinstance(row, list) and len(row) == cols for row in data), "wrong column count")
    return sp.Matrix([[polynomial(e) for e in row] for row in data])


def as_json(matrix):
    return [[str(matrix[i, j]) for j in range(matrix.cols)] for i in range(matrix.rows)]


def integer_list(values):
    return isinstance(values, list) and all(type(value) is int for value in values)


def homogeneous_degree(value):
    monomials = sp.Poly(value, *VARIABLES).monoms()
    degrees = {sum(monomial) for monomial in monomials}
    require(len(degrees) == 1, "inhomogeneous matrix entry")
    return next(iter(degrees))


def column_degrees(matrix, row_degrees):
    degrees = []
    for j in range(matrix.cols):
        candidates = {
            homogeneous_degree(matrix[i, j]) + row_degrees[i]
            for i in range(matrix.rows)
            if matrix[i, j] != 0
        }
        require(len(candidates) == 1, "zero or inhomogeneous generator")
        degrees.append(next(iter(candidates)))
    return degrees


def construction(top):
    result = bmp_a3.run(top)
    ranks, maps, kernels, relations = {}, {}, {}, {}
    for record in result["records"]:
        if record[0] == "RANK":
            ranks[record[1]] = int(record[2])
        elif record[0] == "MAP":
            maps[(record[1], record[2])] = decode_matrix(record, 4)
        elif record[0] == "KERNEL":
            kernels[(record[1], int(record[2]))] = decode_matrix(record, 3)
        elif record[0] == "RELATION":
            relations[(record[1], int(record[2]))] = decode_matrix(record, 3)
    degrees = {bmp_a3.name(top): [0]}
    for vertex in bmp_a3.interval(top)[1:]:
        name = bmp_a3.name(vertex)
        candidates = [set() for _ in range(ranks[name])]
        for (lower, upper), matrix in maps.items():
            if lower != name:
                continue
            for j in range(matrix.cols):
                for i in range(matrix.rows):
                    if matrix[i, j] != 0:
                        candidates[j].add(homogeneous_degree(matrix[i, j]) + degrees[upper][i])
        require(all(len(s) == 1 for s in candidates), "constructed cover is not homogeneous")
        degrees[name] = [next(iter(s)) for s in candidates]
    return ranks, maps, degrees, kernels, relations


def permutation(text):
    require(
        isinstance(text, str) and len(text) == 4 and sorted(text) == list("1234"),
        "not an S4 permutation",
    )
    return tuple(map(int, text))


def matrix_declaration(name, matrix):
    entries = ",".join(str(e).replace("**", "^") for e in matrix)
    return f"matrix {name}[{matrix.rows}][{matrix.cols}]={entries};"


def exact_module_check(generators, relations, expected):
    source = "\n".join(
        [
            "ring A=0,(a,b,c),dp;",
            matrix_declaration("W", generators),
            matrix_declaration("R", relations),
            matrix_declaration("K", expected),
            "module MW=W;module MR=R;module MK=K;",
            'if(size(reduce(MW,std(MK)))!=0){print("@@FAIL");quit;}',
            'if(size(reduce(MK,std(MW)))!=0){print("@@FAIL");quit;}',
            "module Z=syz(MW);",
            'if(size(reduce(MR,std(Z)))!=0){print("@@FAIL");quit;}',
            'if(size(reduce(Z,std(MR)))!=0){print("@@FAIL");quit;}',
            'print("@@OK");',
            "quit;",
        ]
    )
    result = subprocess.run(
        ["Singular", "-q"],
        input=source,
        text=True,
        capture_output=True,
        check=True,
        timeout=120,
    )
    if "?" in result.stdout or result.stderr:
        raise RuntimeError(result.stdout + result.stderr)
    require("@@OK" in result.stdout and "@@FAIL" not in result.stdout, "false kernel or syzygy witness")


def verify(data):
    require(isinstance(data, dict), "witness must be a JSON object")
    require(data.get("field") == "Q", "witness must use the exact rational field")
    require(data.get("variables") == ["a", "b", "c"], "incorrect root coordinates")
    require(type(data.get("linear_degree")) is int and data["linear_degree"] == 1, "wrong grading")
    top, bottom = permutation(data.get("top")), permutation(data.get("bottom"))
    require(bmp_a3.bruhat(bottom, top), "bottom is not below top")
    ranks, maps, degrees, kernels, _ = construction(top)
    vertices = [v for v in bmp_a3.interval(top) if bmp_a3.bruhat(bottom, v)]
    graph = bmp_a3.edges(vertices)
    vertex_data = data.get("vertices")
    require(isinstance(vertex_data, list), "missing vertex data")
    require(len(vertex_data) == len(vertices), "wrong vertex set")
    given_vertices = {}
    for vertex in vertex_data:
        require(isinstance(vertex, dict) and isinstance(vertex.get("name"), str), "invalid vertex")
        require(vertex["name"] not in given_vertices, "duplicate vertex")
        require(integer_list(vertex.get("degrees")), "noninteger stalk grading")
        given_vertices[vertex["name"]] = vertex.get("degrees")
    require(given_vertices == {bmp_a3.name(v): degrees[bmp_a3.name(v)] for v in vertices}, "false BMP stalks")
    edge_data = data.get("edges")
    require(isinstance(edge_data, list) and len(edge_data) == len(graph), "wrong edge set")
    given_edges = {}
    for edge in edge_data:
        require(isinstance(edge, dict), "invalid edge")
        key = (edge.get("lower"), edge.get("upper"))
        require(all(isinstance(v, str) for v in key) and key not in given_edges, "duplicate or invalid edge")
        given_edges[key] = edge
    require(
        set(given_edges) == {(bmp_a3.name(x), bmp_a3.name(y)) for x, y, _ in graph},
        "not the Coxeter interval graph",
    )
    for x, y, label in graph:
        sx, sy = bmp_a3.name(x), bmp_a3.name(y)
        edge = given_edges[(sx, sy)]
        alpha = polynomial(label)
        require(polynomial(edge.get("label")) == alpha, "incorrect left reflection label")
        matrix = input_matrix(edge.get("lower_map"), ranks[sy], ranks[sx])
        difference = matrix - maps[(sx, sy)]
        require(
            all(sp.rem(e, alpha, *VARIABLES) == 0 for e in difference),
            "map is not the constructed BMP restriction",
        )
    sx = bmp_a3.name(bottom)
    outgoing = [(bmp_a3.name(y), label) for x, y, label in graph if x == bottom]
    F = data.get("F")
    require(isinstance(F, list) and all(isinstance(y, str) for y in F), "invalid edge subset")
    require(len(F) == 2 and len(set(F)) == 2, "witness requires two distinct outgoing edges")
    require(set(F) <= {y for y, _ in outgoing}, "F contains a non-outgoing edge")
    mask = sum(1 << i for i, (y, _) in enumerate(outgoing) if y in F)
    require(ranks[sx] == 2, "witness is not a rank-two singular stalk")
    W = input_matrix(data.get("generators"), 2, 3)
    R = input_matrix(data.get("relations"), 3, 1)
    generator_degrees = column_degrees(W, degrees[sx])
    relation_degrees = column_degrees(R, generator_degrees)
    require(integer_list(data.get("generator_degrees")), "noninteger generator grading")
    require(integer_list(data.get("relation_degrees")), "noninteger relation grading")
    require(generator_degrees == data.get("generator_degrees"), "wrong generator degrees")
    require(relation_degrees == data.get("relation_degrees"), "wrong relation degrees")
    require(R != sp.zeros(3, 1), "relation map must be injective")
    require(all(e.subs(dict.fromkeys(VARIABLES, 0)) == 0 for e in R), "presentation is not minimal")
    exact_module_check(W, R, kernels[(sx, mask)])
    numerator = [0] * (max(generator_degrees + relation_degrees) + 1)
    for degree in generator_degrees:
        numerator[degree] += 1
    for degree in relation_degrees:
        numerator[degree] -= 1
    require(integer_list(data.get("hilbert_numerator")) and numerator == data["hilbert_numerator"], "false Hilbert numerator")
    cycle = data.get("atom_cycle")
    atoms = {bmp_a3.name(v) for v in vertices if bmp_a3.length(v) == bmp_a3.length(bottom) + 1}
    require(isinstance(cycle, list) and len(cycle) == 4 and set(cycle) == atoms, "invalid atom cycle")
    require(bmp_a3.length(top) - bmp_a3.length(bottom) == 3, "not a rank-three interval")
    upper_neighbors = {
        atom: {bmp_a3.name(y) for x, y, _ in graph if bmp_a3.name(x) == atom}
        for atom in atoms
    }
    for i, j in itertools.combinations(range(4), 2):
        common = upper_neighbors[cycle[i]] & upper_neighbors[cycle[j]]
        require(len(common) == (1 if (j - i) % 4 in (1, 3) else 0), "atom cycle is not the interval eight-cycle")
    indices = sorted(cycle.index(y) for y in F)
    require(indices[1] - indices[0] == 2, "F is not the opposite-atom nonterminal certificate")
    return {
        "top": data["top"],
        "bottom": sx,
        "F": F,
        "stalk_degrees": degrees[sx],
        "generic_rank": 2,
        "minimal_generators": 3,
        "generator_degrees": generator_degrees,
        "relation_degrees": relation_degrees,
        "hilbert_numerator": numerator,
        "nonfree_at": "(a,b,c)",
        "nonterminal_basis": "eight-cycle plus Dyer 1993 Proposition 4.3 and Remark 4.4",
    }


def verify_classification(data, sheaf):
    verify(sheaf)
    require(data.get("top") == "3412" and data.get("bottom") == "1324", "wrong classification interval")
    _, _, degrees, kernels, _ = construction((3, 4, 1, 2))
    outgoing = ["1342", "1423", "2314", "3124"]
    roots = [(1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0), (0, 1, 1), (1, 1, 1)]
    bottom_roots = [roots[4], roots[2], roots[0], roots[3]]
    require(isinstance(data.get("cases"), list) and len(data["cases"]) == 16, "incomplete classification")
    seen, output = set(), []
    for case in data["cases"]:
        F = case.get("F")
        require(isinstance(F, list) and len(set(F)) == len(F) and set(F) <= set(outgoing), "invalid classification F")
        mask = sum(1 << outgoing.index(y) for y in F)
        require(mask not in seen, "duplicate classification F")
        seen.add(mask)
        free = mask not in (5, 10)
        require(type(case.get("free")) is bool and case["free"] == free, "false freeness classification")
        W = input_matrix(case.get("generators"), 2, 2 if free else 3)
        R = sp.zeros(2, 1) if free else input_matrix(case.get("relations"), 3, 1)
        if free:
            require(case.get("relations") == [], "a free basis has no relation generators")
            require(W.det() != 0, "claimed free basis is dependent")
        else:
            require(all(e.subs(dict.fromkeys(VARIABLES, 0)) == 0 for e in R), "nonminimal presentation")
            require(R != sp.zeros(3, 1), "zero relation map")
        exact_module_check(W, R, kernels[("1324", mask)])
        gd = column_degrees(W, degrees["1324"])
        rd = [] if free else column_degrees(R, gd)
        numerator = [0] * (max(gd + rd) + 1)
        for degree in gd:
            numerator[degree] += 1
        for degree in rd:
            numerator[degree] -= 1
        require(integer_list(case.get("hilbert_numerator")) and case["hilbert_numerator"] == numerator, "false classification Hilbert numerator")
        functional = case.get("terminal_functional")
        if free:
            require(integer_list(functional) and len(functional) == 3, "missing exact separating functional")
            slopes = {root: Fraction(sum(f * r for f, r in zip(functional, root)), sum(root)) for root in roots}
            require(len(set(slopes.values())) == 6, "reflection-label ties")
            chosen = [slopes[root] for y, root in zip(outgoing, bottom_roots) if y in F]
            remaining = [slopes[root] for y, root in zip(outgoing, bottom_roots) if y not in F]
            require(not chosen or not remaining or max(remaining) < min(chosen), "F is not terminal for this functional")
        else:
            require(functional is None, "opposite roots cannot be strictly separated")
        output.append({"F": F, "free": free, "hilbert_numerator": numerator})
    return {"top": "3412", "bottom": "1324", "cases": output}


def make_witness(top_text, bottom_text, selected, cycle):
    top, bottom = permutation(top_text), permutation(bottom_text)
    ranks, maps, degrees, kernels, relations = construction(top)
    vertices = [v for v in bmp_a3.interval(top) if bmp_a3.bruhat(bottom, v)]
    graph = bmp_a3.edges(vertices)
    outgoing = [bmp_a3.name(y) for x, y, _ in graph if x == bottom]
    mask = sum(1 << outgoing.index(y) for y in selected)
    W, R = kernels[(bottom_text, mask)], relations[(bottom_text, mask)]
    gd = column_degrees(W, degrees[bottom_text])
    rd = column_degrees(R, gd)
    numerator = [0] * (max(gd + rd) + 1)
    for d in gd:
        numerator[d] += 1
    for d in rd:
        numerator[d] -= 1
    return {
        "field": "Q",
        "variables": ["a", "b", "c"],
        "linear_degree": 1,
        "top": top_text,
        "bottom": bottom_text,
        "vertices": [{"name": bmp_a3.name(v), "degrees": degrees[bmp_a3.name(v)]} for v in vertices],
        "edges": [
            {"lower": bmp_a3.name(x), "upper": bmp_a3.name(y), "label": label,
             "lower_map": as_json(maps[(bmp_a3.name(x), bmp_a3.name(y))])}
            for x, y, label in graph
        ],
        "F": selected,
        "generators": as_json(W),
        "relations": as_json(R),
        "generator_degrees": gd,
        "relation_degrees": rd,
        "hilbert_numerator": numerator,
        "atom_cycle": cycle,
    }


def make_classification():
    a, b, c = VARIABLES
    s, t, d = a + b, b + c, a + b + c
    bases = [
        [[1, 0], [0, 1]],
        [[t, 0], [0, 1]],
        [[-b, c], [1, 0]],
        [[t, 0], [-1, c]],
        [[-b, a], [1, 0]],
        [[0, b*t, a*t], [a, -t, -a]],
        [[-b, a*c], [1, 0]],
        [[b*t, a*t], [-t, -a]],
        [[s, 0], [0, 1]],
        [[s*t, 0], [0, 1]],
        [[0, b*s, c*s], [c, -s, -c]],
        [[s*t, 0], [-d, c]],
        [[s, 0], [-1, a]],
        [[s*t, 0], [-t, a]],
        [[c*s, b*s], [-c, -s]],
        [[s*t, 0], [-d, a*c]],
    ]
    outgoing = ["1342", "1423", "2314", "3124"]
    roots = [(1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0), (0, 1, 1), (1, 1, 1)]
    bottom_indices = [4, 2, 0, 3]
    cases = []
    for mask, basis in enumerate(bases):
        F = [y for i, y in enumerate(outgoing) if mask & (1 << i)]
        free = mask not in (5, 10)
        W = sp.Matrix(basis)
        gd = column_degrees(W, [0, 1])
        numerator = [0] * (max(gd) + 1 if free else 4)
        for degree in gd:
            numerator[degree] += 1
        if not free:
            numerator[3] -= 1
        functional = None
        if free:
            for f in itertools.product(range(-4, 5), repeat=3):
                slopes = [Fraction(sum(x*y for x, y in zip(f, root)), sum(root)) for root in roots]
                chosen = [slopes[index] for i, index in enumerate(bottom_indices) if mask & (1 << i)]
                rest = [slopes[index] for i, index in enumerate(bottom_indices) if not mask & (1 << i)]
                if len(set(slopes)) == 6 and (not chosen or not rest or max(rest) < min(chosen)):
                    functional = list(f)
                    break
            require(functional is not None, "no separating functional found in the chosen certificate box")
        cases.append({
            "F": F,
            "free": free,
            "generators": as_json(W),
            "relations": [] if free else as_json(sp.Matrix([c, a, -b] if mask == 5 else [a, c, -b])),
            "hilbert_numerator": numerator,
            "terminal_functional": functional,
        })
    return {"top": "3412", "bottom": "1324", "cases": cases}


def self_test(directory):
    path = Path(__file__).resolve()
    fixtures = [directory / "3412_witness.json", directory / "4231_witness.json"]
    output = {"positive_controls": [], "negative_controls": []}
    for fixture in fixtures:
        process = subprocess.run([sys.executable, str(path), str(fixture)], text=True, capture_output=True)
        require(process.returncode == 0, f"positive control failed: {process.stderr}")
        output["positive_controls"].append(json.loads(process.stdout))
    original = json.loads(fixtures[0].read_text())

    def reject(label, mutate):
        broken = copy.deepcopy(original)
        mutate(broken)
        with tempfile.TemporaryDirectory(prefix="bmp-negative-") as temporary:
            candidate = Path(temporary) / "witness.json"
            candidate.write_text(json.dumps(broken))
            process = subprocess.run([sys.executable, str(path), str(candidate)], text=True, capture_output=True)
        require(process.returncode == 2 and process.stderr.startswith("rejected:"), f"negative control escaped: {label}")
        output["negative_controls"].append({"mutation": label, "rejection": process.stderr.strip()})

    reject("invalid permutation", lambda d: d.update(top="3411"))
    reject("false root label", lambda d: d["edges"][0].update(label="a"))
    reject("false BMP map", lambda d: d["edges"][0].update(lower_map=[["0", "0"]]))
    reject("missing interval edge", lambda d: d["edges"].pop())
    reject("false stalk grading", lambda d: d["vertices"][-1].update(degrees=[0, 0]))
    reject("non-outgoing edge in F", lambda d: d.update(F=["1342", "3412"]))
    reject("duplicate edge in F", lambda d: d.update(F=["1342", "1342"]))
    reject("valid but wrong F", lambda d: d.update(F=["1342", "1423"]))
    reject("false kernel generator", lambda d: d["generators"][0].__setitem__(0, "1"))
    reject("homogeneous false kernel", lambda d: d["generators"][0].__setitem__(1, "a*c"))
    reject("homogeneous false syzygy", lambda d: d["relations"][0].__setitem__(0, "c+a"))
    reject("false Hilbert numerator", lambda d: d.update(hilbert_numerator=[0, 0, 2]))
    reject("nonexact coefficient", lambda d: d["generators"][0].__setitem__(0, "0.5"))
    reject("foreign root variable", lambda d: d["edges"][0].update(label="z"))
    reject("false atom cycle", lambda d: d.update(atom_cycle=["1342", "2314", "1423", "3124"]))
    reject("floating stalk degree", lambda d: d["vertices"][-1].update(degrees=[0, 1.0]))
    classification = subprocess.run(
        [sys.executable, str(path), "--classification", str(directory / "classification.json")],
        text=True,
        capture_output=True,
    )
    require(classification.returncode == 0, f"classification failed: {classification.stderr}")
    output["classification"] = json.loads(classification.stdout)
    return output


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("witness", type=Path, nargs="?")
    parser.add_argument("--self-test", action="store_true", help="run positive and mutated JSONs through this CLI")
    parser.add_argument("--classification", type=Path, help="check the complete sixteen-subset boundary classification")
    parser.add_argument("--output", type=Path, help="write the exact check results")
    args = parser.parse_args()
    try:
        if args.self_test:
            result = self_test(Path(__file__).resolve().parent)
        elif args.classification:
            data = json.loads(args.classification.read_text())
            sheaf = json.loads((args.classification.parent / "3412_witness.json").read_text())
            result = verify_classification(data, sheaf)
        else:
            require(args.witness is not None, "a witness JSON path is required")
            result = verify(json.loads(args.witness.read_text()))
    except (ValueError, KeyError, TypeError, IndexError) as exc:
        print(f"rejected: {exc}", file=sys.stderr)
        return 2
    text = json.dumps(result, indent=2) + "\n"
    if args.output:
        args.output.write_text(text)
    print(text, end="")
    return 0


if __name__ == "__main__":
    sys.exit(main())
