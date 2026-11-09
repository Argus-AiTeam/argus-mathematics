"""Exact single-label zigzag complexes; paths compose in traversal order."""

from dataclasses import dataclass
from fractions import Fraction


@dataclass(frozen=True, order=True)
class Path:
    source: str
    target: str
    length: int
    channel: int = 0


@dataclass(frozen=True)
class Generator:
    vertex: str
    cochain: int
    internal: int

    @property
    def level(self):
        return self.cochain + self.internal


def accumulate(mapping, key, value):
    value = mapping.get(key, Fraction(0)) + value
    if value:
        mapping[key] = value
    else:
        mapping.pop(key, None)


class Zigzag:
    def __init__(self, vertices, edges):
        self.vertices = tuple(vertices)
        self.edges = {}
        for source, target, multiplicity in edges:
            if source == target or multiplicity < 1:
                raise ValueError("An edge must have distinct ends and positive multiplicity")
            self.edges[source, target] = multiplicity
            self.edges[target, source] = multiplicity

    def paths(self, source, target):
        if source == target:
            return (Path(source, target, 0), Path(source, target, 2))
        return tuple(
            Path(source, target, 1, channel)
            for channel in range(self.edges.get((source, target), 0))
        )

    @staticmethod
    def compose(first, second):
        if first.target != second.source:
            raise ValueError("Paths are not composable")
        if first.length == 0:
            return second
        if second.length == 0:
            return first
        if (
            first.length == second.length == 1
            and first.source == second.target
            and first.channel == second.channel
        ):
            return Path(first.source, first.source, 2)
        return None

    @staticmethod
    def dual(path):
        return Path(path.target, path.source, 2 - path.length, path.channel)


class Complex:
    def __init__(self, algebra, generators, differential=None):
        self.algebra = algebra
        self.generators = list(generators)
        self.differential = dict(differential or {})

    def validate(self, minimal=False):
        for (source, target, path), coefficient in self.differential.items():
            a, b = self.generators[source], self.generators[target]
            if not coefficient or path not in self.algebra.paths(a.vertex, b.vertex):
                raise ValueError("Invalid differential coefficient or path")
            if b.cochain != a.cochain + 1 or a.internal != b.internal + path.length:
                raise ValueError("Differential does not have bidegree (1,0)")
            if minimal and path.length == 0:
                raise ValueError("The complex is not minimal")
        square = {}
        for (a, b, p), c in self.differential.items():
            for (b1, d, q), e in self.differential.items():
                if b != b1:
                    continue
                product = self.algebra.compose(p, q)
                if product is not None:
                    accumulate(square, (a, d, product), c * e)
        if square:
            raise ValueError(f"Differential does not square to zero: {square}")

    def minimize(self):
        generators = dict(enumerate(self.generators))
        differential = dict(self.differential)
        while True:
            pivot = next(
                ((key, c) for key, c in differential.items() if key[2].length == 0),
                None,
            )
            if pivot is None:
                break
            (source, target, _), coefficient = pivot
            incoming = [
                (a, p, c)
                for (a, b, p), c in differential.items()
                if b == target and a != source
            ]
            outgoing = [
                (b, p, c)
                for (a, b, p), c in differential.items()
                if a == source and b != target
            ]
            differential = {
                key: c
                for key, c in differential.items()
                if key[0] not in (source, target) and key[1] not in (source, target)
            }
            for a, p, c in incoming:
                for b, q, e in outgoing:
                    product = self.algebra.compose(p, q)
                    if product is not None:
                        accumulate(differential, (a, b, product), -c * e / coefficient)
            del generators[source]
            del generators[target]
        indices = {old: new for new, old in enumerate(generators)}
        result = Complex(
            self.algebra,
            generators.values(),
            {(indices[a], indices[b], p): c for (a, b, p), c in differential.items()},
        )
        result.validate(minimal=True)
        return result

    def twist(self, vertex, sign):
        if sign not in (-1, 1):
            raise ValueError("A twist sign must be +1 or -1")
        generators = list(self.generators)
        inserted = {}
        for source, generator in enumerate(self.generators):
            for path in self.algebra.paths(vertex, generator.vertex):
                inserted[source, path] = len(generators)
                generators.append(
                    Generator(
                        vertex,
                        generator.cochain - sign,
                        generator.internal + path.length - (2 if sign == -1 else 0),
                    )
                )
        differential = dict(self.differential)
        identity = Path(vertex, vertex, 0)
        for (source, path), index in inserted.items():
            if sign == 1:
                accumulate(differential, (index, source, path), Fraction(1))
            else:
                accumulate(
                    differential, (source, index, self.algebra.dual(path)), Fraction(1)
                )
            for (a, target, entry), coefficient in self.differential.items():
                if a != source:
                    continue
                product = self.algebra.compose(path, entry)
                if product is not None:
                    target_index = inserted[target, product]
                    accumulate(
                        differential, (index, target_index, identity), -coefficient
                    )
        result = Complex(self.algebra, generators, differential)
        result.validate()
        return result.minimize()

    def layer(self, level, vertices=None):
        indices = {
            old: new
            for new, old in enumerate(
                i
                for i, g in enumerate(self.generators)
                if g.level == level and (vertices is None or g.vertex in vertices)
            )
        }
        result = Complex(
            self.algebra,
            [self.generators[i] for i in indices],
            {
                (indices[a], indices[b], p): c
                for (a, b, p), c in self.differential.items()
                if a in indices and b in indices and p.length == 1
            },
        )
        result.validate(minimal=True)
        return result

    def counts(self):
        counts = {}
        for g in self.generators:
            key = (g.level, g.vertex)
            counts[key] = counts.get(key, 0) + 1
        return counts

    def as_json(self):
        return {
            "generators": [
                [g.vertex, g.cochain, g.internal] for g in self.generators
            ],
            "differential": [
                [a, b, p.length, p.channel, str(c)]
                for (a, b, p), c in sorted(self.differential.items())
            ],
        }


def rank(matrix, columns=None):
    rows = [[Fraction(x) for x in row] for row in matrix]
    width = len(rows[0]) if rows else (columns or 0)
    if any(len(row) != width for row in rows):
        raise ValueError("Ragged matrix")
    pivot_row = 0
    for column in range(width):
        pivot = next(
            (r for r in range(pivot_row, len(rows)) if rows[r][column]), None
        )
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        scale = rows[pivot_row][column]
        rows[pivot_row] = [x / scale for x in rows[pivot_row]]
        for r in range(len(rows)):
            if r != pivot_row and rows[r][column]:
                factor = rows[r][column]
                rows[r] = [x - factor * y for x, y in zip(rows[r], rows[pivot_row])]
        pivot_row += 1
        if pivot_row == len(rows):
            break
    return pivot_row


def hom_data(source, target, linear_only=False):
    basis = {}
    for a, x in enumerate(source.generators):
        for b, y in enumerate(target.generators):
            for path in source.algebra.paths(x.vertex, y.vertex):
                key = (y.cochain - x.cochain, y.internal + path.length - x.internal)
                basis.setdefault(key, []).append((a, b, path))
    matrices = {}
    dimensions = {}
    for (n, v), vectors in basis.items():
        following = basis.get((n + 1, v), [])
        indices = {item: row for row, item in enumerate(following)}
        matrix = [[Fraction(0) for _ in vectors] for _ in following]
        for column, (a, b, path) in enumerate(vectors):
            for (b1, c, entry), coefficient in target.differential.items():
                if b1 != b or (linear_only and entry.length != 1):
                    continue
                product = source.algebra.compose(path, entry)
                if product is not None:
                    matrix[indices[a, c, product]][column] += coefficient
            for (c, a1, entry), coefficient in source.differential.items():
                if a1 != a or (linear_only and entry.length != 1):
                    continue
                product = source.algebra.compose(entry, path)
                if product is not None:
                    matrix[indices[c, b, product]][column] -= (
                        -1 if n % 2 else 1
                    ) * coefficient
        matrices[n, v] = matrix
        dimensions[n, v] = len(vectors)
    ranks = {
        key: rank(matrix, dimensions[key]) for key, matrix in matrices.items()
    }
    cohomology = {
        (n, v): dimension - ranks[n, v] - ranks.get((n - 1, v), 0)
        for (n, v), dimension in dimensions.items()
    }
    if any(value < 0 for value in cohomology.values()):
        raise ValueError("Negative cohomology dimension")
    return basis, matrices, {key: value for key, value in cohomology.items() if value}
