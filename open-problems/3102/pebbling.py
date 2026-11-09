"""Exact sufficient pebbling rules; failure of a rule is not unsolvability."""

import ast
from collections import deque
from fractions import Fraction
from itertools import permutations
from pathlib import Path


EDGES = (
    (1, 2), (2, 3), (3, 4), (4, 5), (5, 6), (6, 7), (7, 1),
    (3, 6), (3, 8), (4, 7), (5, 7), (5, 8), (7, 8),
)
VERTICES = tuple((a, b) for a in range(1, 9) for b in range(1, 9))
INDEX = {v: i for i, v in enumerate(VERTICES)}
BASE = {v: set() for v in range(1, 9)}
for a, b in EDGES:
    BASE[a].add(b)
    BASE[b].add(a)
ADJ = tuple(tuple(sorted(
    [INDEX[(x, b)] for x in BASE[a]] +
    [INDEX[(a, y)] for y in BASE[b]]
)) for a, b in VERTICES)


def all_distances(adj):
    result = []
    for root in range(len(adj)):
        d = [-1] * len(adj)
        d[root] = 0
        queue = deque([root])
        while queue:
            v = queue.popleft()
            for w in adj[v]:
                if d[w] == -1:
                    d[w] = d[v] + 1
                    queue.append(w)
        if -1 in d:
            raise ValueError("The fixed graph is disconnected")
        result.append(tuple(d))
    return tuple(result)


DIST = all_distances(ADJ)


def check_author_graph():
    source = Path(__file__).with_name("author_implementation.py").read_text()
    tree = ast.parse(source)
    function = next(n for n in tree.body
                    if isinstance(n, ast.FunctionDef)
                    and n.name == "get_lemke_graph")
    branch = next(n for n in function.body if isinstance(n, ast.If))
    call = branch.body[0].value
    expected_test = ast.parse("index == 0", mode="eval").body
    if ast.dump(branch.test) != ast.dump(expected_test):
        raise ValueError("The author implementation's first branch changed")
    if not (isinstance(call, ast.Call)
            and isinstance(call.func, ast.Attribute)
            and call.func.attr == "add_edges_from"):
        raise ValueError("The author graph definition is not the expected call")
    source_edges = ast.literal_eval(call.args[0])
    if {frozenset(e) for e in source_edges} != {frozenset(e) for e in EDGES}:
        raise ValueError("The fixed adjacency differs from the author source")


def root_representatives():
    classes = (1, 2, 3, 4, 5, 7)
    return tuple(INDEX[(a, b)] for i, a in enumerate(classes)
                 for b in classes[i:])


def product_automorphisms():
    twins = (4, 6, 8)
    maps = []
    for p in permutations(twins):
        phi = {v: v for v in BASE}
        phi.update(zip(twins, p))
        if any({phi[w] for w in BASE[v]} != BASE[phi[v]] for v in BASE):
            raise ValueError("An asserted twin permutation is not an automorphism")
        maps.append(phi)
    result = []
    for phi in maps:
        for psi in maps:
            for swap in (False, True):
                image = tuple(INDEX[(psi[b], phi[a]) if swap else
                                    (phi[a], psi[b])] for a, b in VERTICES)
                if any({image[w] for w in ADJ[v]} != set(ADJ[image[v]])
                       for v in range(64)):
                    raise ValueError("An asserted product map is not an automorphism")
                result.append(image)
    reps = set(root_representatives())
    if any(not any(image[r] in reps for image in result) for r in range(64)):
        raise ValueError("The root representatives do not cover every root")
    return tuple(result)


def shortest_path(v, u):
    path = [v]
    while v != u:
        v = next(w for w in ADJ[v] if DIST[w][u] == DIST[v][u] - 1)
        path.append(v)
    return path


def transport(v, u, count):
    if count == 0:
        return []
    path = shortest_path(v, u)
    return [(path[i], path[i + 1],
             count * (1 << (len(path) - i - 2)))
            for i in range(len(path) - 1)]


def execute(configuration, moves):
    if len(configuration) != 64 or any(type(x) is not int or x < 0
                                      for x in configuration):
        raise ValueError("A configuration needs 64 nonnegative integers")
    c = list(configuration)
    for v, w, n in moves:
        if (type(v) is not int or type(w) is not int
                or not 0 <= v < 64 or not 0 <= w < 64
                or type(n) is not int or n < 0
                or w not in ADJ[v] or 2 * n > c[v]):
            raise ValueError(f"Illegal move batch {(v, w, n)}")
        c[v] -= 2 * n
        c[w] += n
    return c


def replay(configuration, root, moves):
    if type(root) is not int or not 0 <= root < 64:
        raise ValueError("The root must be a vertex index in [0,63]")
    c = execute(configuration, moves)
    if c[root] < 1:
        raise ValueError("The replayed moves do not reach the root")
    return c


def gathering_value(c, u):
    return sum(x >> DIST[v][u] for v, x in enumerate(c) if x)


def gathering_solution(c, root):
    for u in range(64):
        if gathering_value(c, u) < 1 << DIST[u][root]:
            continue
        moves = []
        for v, x in enumerate(c):
            if v != u and x:
                moves.extend(transport(v, u, x >> DIST[v][u]))
        moves.extend(transport(u, root, 1))
        replay(c, root, moves)
        return moves
    return None


def fan_value(center_count, child_counts):
    k = center_count // 2
    odd = sum(x % 2 for x in child_counts)
    first = min(k, odd)
    return sum(x // 2 for x in child_counts) + first + (k - first) // 2


def fan_solution(c, root):
    for center, x in enumerate(c):
        if x < 2:
            continue
        for target in range(64):
            if DIST[center][target] != 2:
                continue
            children = sorted(set(ADJ[center]) & set(ADJ[target]))
            used = {center, target, *children}
            score = c[target] + fan_value(x, [c[w] for w in children])
            score += sum(y >> DIST[v][target] for v, y in enumerate(c)
                         if y and v not in used)
            if score < 1 << DIST[target][root]:
                continue
            remaining = x // 2
            arrivals = dict.fromkeys(children, 0)
            for w in children:
                if c[w] % 2 and remaining:
                    arrivals[w] = 1
                    remaining -= 1
            arrivals[children[0]] += remaining
            moves = []
            for w in children:
                if arrivals[w]:
                    moves.append((center, w, arrivals[w]))
                count = (c[w] + arrivals[w]) // 2
                if count:
                    moves.append((w, target, count))
            for v, y in enumerate(c):
                if y and v not in used:
                    moves.extend(transport(v, target, y >> DIST[v][target]))
            moves.extend(transport(target, root, 1))
            replay(c, root, moves)
            return moves
    return None


def gathering_rows(root, support):
    rows = []
    for u in range(64):
        coefficients = [Fraction(1, 1 << DIST[v][u]) for v in support]
        rhs = Fraction((1 << DIST[u][root]) - 1)
        rhs += sum(1 - a for a in coefficients)
        rows.append((coefficients, rhs))
    return rows


def rational(x):
    x = Fraction(x)
    return {"num": str(x.numerator), "den": str(x.denominator)}


def lp_payload(root, support):
    return {"program": {
        "variables": [
            {"name": f"C_{VERTICES[v][0]}_{VERTICES[v][1]}",
             "lower_bound": rational(0),
             "upper_bound": rational((1 << DIST[v][root]) - 1)}
            for v in support
        ],
        "objective": {
            "sense": "MAXIMIZE",
            "coefficients": [rational(1) for _ in support],
        },
        "constraints": [
            {"label": f"gather_{VERTICES[u][0]}_{VERTICES[u][1]}",
             "coefficients": [rational(a) for a in row],
             "relation": "LE", "rhs": rational(rhs)}
            for u, (row, rhs) in enumerate(gathering_rows(root, support))
        ],
    }}
