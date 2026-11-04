"""Exact split-arm discharging in the two diameter-three rooted fibers."""

from multistage import trim_to_root
from pebbling import (
    BASE, DIST, INDEX, VERTICES, execute, fan_value, replay, transport,
)


TWINS = (4, 6, 8)


def fan_moves(center, target, counts, arrivals):
    allocation = dict.fromkeys(TWINS, 0)
    remaining = arrivals
    for v in TWINS:
        if counts[v - 1] % 2 and remaining:
            allocation[v] += 1
            remaining -= 1
    allocation[TWINS[0]] += remaining
    moves = []
    for v in TWINS:
        if allocation[v]:
            moves.append((center, v, allocation[v]))
        sent = (counts[v - 1] + allocation[v]) // 2
        if sent:
            moves.append((v, target, sent))
    return moves


def extract_fiber(counts, root):
    if (len(counts) != 8 or any(type(n) is not int or n < 0 for n in counts)
            or type(root) is not int or root not in (2, 5)):
        raise ValueError("A fiber needs eight nonnegative integers and root 2 or 5")
    center = 5 if root == 2 else 2
    budget = counts[center - 1] // 2
    children = [counts[v - 1] for v in TWINS]

    def score(left):
        right = budget - left
        if root == 2:
            first = (2 * counts[0] + counts[6] + left) // 4
            second = (counts[2] + fan_value(2 * right, children)) // 2
        else:
            first = (2 * counts[6] + counts[0] + left) // 4
            second = fan_value(counts[2] + right, children)
        return counts[root - 1] + first + second

    left = max(range(budget + 1), key=score)
    right = budget - left
    if root == 2:
        arrivals = (counts[6] + left) // 2
        fan = fan_value(2 * right, children)
        moves = [(5, 7, left), (7, 1, arrivals),
                 (1, 2, (counts[0] + arrivals) // 2)]
        moves += fan_moves(5, 3, counts, right)
        moves.append((3, 2, (counts[2] + fan) // 2))
    else:
        arrivals = (counts[0] + left) // 2
        moves = [(2, 1, left), (2, 3, right), (1, 7, arrivals),
                 (7, 5, (counts[6] + arrivals) // 2)]
        moves += fan_moves(3, 5, counts, (counts[2] + right) // 2)
    moves = [(v, w, n) for v, w, n in moves if n]
    final = list(counts)
    for v, w, n in moves:
        if w not in BASE[v] or 2 * n > final[v - 1]:
            raise ValueError("The fiber formula produced an illegal move batch")
        final[v - 1] -= 2 * n
        final[w - 1] += n
    if final[root - 1] != score(left):
        raise ValueError("The fiber replay disagrees with the extraction formula")
    return final[root - 1], moves


def fiber_solution(configuration, root):
    if (len(configuration) != 64
            or any(type(n) is not int or n < 0 for n in configuration)
            or type(root) is not int or not 0 <= root < 64):
        raise ValueError("A configuration needs 64 nonnegative integers and a root")
    first, second = VERTICES[root]
    if first not in (2, 5) or second not in (2, 5):
        return None
    for swap in (False, True):
        a, b = (second, first) if swap else (first, second)

        def vertex(i, j):
            return INDEX[(j, i) if swap else (i, j)]

        gathered, moves = [], []
        for i in range(1, 9):
            counts = [configuration[vertex(i, j)] for j in range(1, 9)]
            value, local = extract_fiber(counts, b)
            gathered.append(value)
            moves.extend((vertex(i, v), vertex(i, w), n) for v, w, n in local)
        value, local = extract_fiber(gathered, a)
        if value:
            moves.extend((vertex(v, b), vertex(w, b), n) for v, w, n in local)
            replay(configuration, root, moves)
            moves = trim_to_root(moves, root)
            replay(configuration, root, moves)
            return moves
    return None


def shifted_fiber_solution(configuration, root, center):
    if type(center) is not int or not 0 <= center < 64:
        raise ValueError("The shift center must be a vertex index in [0,63]")
    if type(root) is not int or not 0 <= root < 64:
        raise ValueError("The root must be a vertex index in [0,63]")
    execute(configuration, [])
    if any(v not in (2, 5) for v in VERTICES[root]):
        return None
    for distance in (1, 2):
        for target in range(64):
            if DIST[center][target] != distance:
                continue
            arrivals = configuration[center] >> distance
            if not arrivals:
                continue
            prefix = transport(center, target, arrivals)
            shifted = execute(configuration, prefix)
            suffix = fiber_solution(shifted, root)
            if suffix is not None:
                moves = trim_to_root(prefix + suffix, root)
                replay(configuration, root, moves)
                return moves
    return None
