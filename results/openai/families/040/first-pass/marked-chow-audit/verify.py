#!/usr/bin/env python3
"""Exact algebra replay accompanying the arbitrary-length Chow proof in REPORT.md.

The geometric premises are not established by this program. Its Hilbert
recursion acts on the actual fiber integrand, not on graphs supplied by hand.
An independent toric computation checks its ordinary Chow realization on P^2.
"""

import argparse
from collections import Counter, defaultdict
from fractions import Fraction as Q
from itertools import product
import json
from math import factorial
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def atom_degree(atom):
    kind = atom[0]
    if kind in ("A", "I"):
        return atom[2]
    if kind == "E":
        return atom[3]
    return {"K": 1, "C": 2, "D": 2, "z": 1, "s": 1, "x": 0}[kind]


def degree(monomial):
    return sum(map(atom_degree, monomial))


class Algebra:
    def __init__(self, cutoff, x_cutoffs=(0, 0)):
        self.cutoff = cutoff
        self.x_cutoffs = x_cutoffs
        self.one = {(): Q(1)}

    def atom(self, *atom):
        return {(tuple(atom),): Q(1)}

    def add(self, *polynomials):
        result = defaultdict(Q)
        for polynomial in polynomials:
            for monomial, coefficient in polynomial.items():
                result[monomial] += coefficient
        return {m: c for m, c in result.items() if c}

    def scale(self, polynomial, scalar):
        return {m: c * scalar for m, c in polynomial.items() if c * scalar}

    def mul(self, left, right):
        result = defaultdict(Q)
        for m, c in left.items():
            for n, d in right.items():
                monomial = tuple(sorted(m + n))
                if degree(monomial) > self.cutoff:
                    continue
                if any(sum(a == ("x", i) for a in monomial) > bound
                       for i, bound in enumerate(self.x_cutoffs)):
                    continue
                surface_degrees = Counter()
                for atom in monomial:
                    if atom[0] in ("K", "C"):
                        surface_degrees[atom[1]] += atom_degree(atom)
                if any(value > 2 for value in surface_degrees.values()):
                    continue
                result[monomial] += c * d
        return {m: c for m, c in result.items() if c}

    def power(self, polynomial, exponent):
        result = self.one
        for _ in range(exponent):
            result = self.mul(result, polynomial)
        return result

    def homogeneous(self, polynomial, target):
        return {m: c for m, c in polynomial.items() if degree(m) == target}

    def exp(self, polynomial, cutoff):
        result, term = self.one, self.one
        for k in range(1, cutoff + 1):
            term = self.scale(self.mul(term, polynomial), Q(1, k))
            term = {m: c for m, c in term.items() if degree(m) <= cutoff}
            result = self.add(result, term)
        return result

    def chern(self, ch, rank):
        result = [self.one]
        for n in range(1, rank + 1):
            value = {}
            for k in range(1, n + 1):
                value = self.add(value, self.scale(
                    self.mul(ch(k), result[n - k]),
                    Q((-1) ** (k - 1) * factorial(k), n)))
            result.append(value)
        return result[rank]

    def weight_power(self, constant, shift, exponent):
        require(constant != 0, "A moving weight must have nonzero constant part.")
        result = {}
        for k in range(self.cutoff + sum(self.x_cutoffs) + 1):
            term = self.scale(self.power(shift, k),
                              Q(constant) ** (exponent - k) * binomial_integer(exponent, k))
            result = self.add(result, term)
        return result

    def extract_x(self, polynomial):
        result = {}
        for monomial, coefficient in polynomial.items():
            if all(sum(a == ("x", i) for a in monomial) == bound
                   for i, bound in enumerate(self.x_cutoffs)):
                rest = tuple(a for a in monomial if a[0] != "x")
                result = self.add(result, {rest: coefficient})
        return result


def ideal_ch(algebra, i, k, slot):
    if k == 0:
        return algebra.one
    if k == 1:
        return {}
    return algebra.atom("I", i, k, slot)


def simplify_empty(algebra, polynomial, lengths):
    result = {}
    for monomial, coefficient in polynomial.items():
        term = algebra.scale(algebra.one, coefficient)
        for atom in monomial:
            kind = atom[0]
            if kind in ("A", "I") and lengths[atom[1]] == 0:
                term = {}
                break
            replacement = algebra.atom(*atom)
            if kind == "E":
                _, i, j, k, p = atom
                if lengths[i] == 0:
                    replacement = (
                        algebra.atom("A", j, k, p) if lengths[j] else {})
                elif lengths[j] == 0:
                    replacement = algebra.scale(
                        algebra.atom("A", i, k, 1 - p), (-1) ** k)
            term = algebra.mul(term, replacement)
        result = algebra.add(result, term)
    return result


def pull_atom(algebra, atom, chosen, residual):
    kind = atom[0]
    old = algebra.atom(*atom)
    z = algebra.atom("z")
    K = algebra.atom("K", residual)
    if kind == "A" and atom[1] == chosen:
        _, _, k, p = atom
        twist = algebra.add(z, algebra.scale(K, p))
        return algebra.add(old, algebra.scale(
            algebra.power(twist, k), Q(1, factorial(k))))
    if kind == "I" and atom[1] == chosen:
        _, _, k, slot = atom
        inverse_todd = [
            algebra.one,
            algebra.scale(K, Q(1, 2)),
            algebra.add(algebra.scale(algebra.power(K, 2), Q(1, 6)),
                        algebra.scale(algebra.atom("C", residual), Q(-1, 12))),
        ]
        graph = {}
        for d in range(3):
            s = k - 2 - d
            if s >= 0:
                graph = algebra.add(graph, algebra.scale(
                    algebra.mul(algebra.power(z, s), inverse_todd[d]),
                    Q(1, factorial(s))))
        graph = algebra.mul(
            algebra.atom("D", min(slot, residual), max(slot, residual)), graph)
        return algebra.add(old, algebra.scale(graph, -1))
    if kind == "E" and chosen in atom[1:3]:
        _, i, j, k, p = atom
        source = chosen == i
        other = j if source else i
        twist = algebra.add(
            algebra.scale(z, -1 if source else 1),
            algebra.scale(K, p - 1 if source else p))
        correction = {}
        for b in range(k + 1):
            ch = ideal_ch(algebra, other, b, residual)
            if not source:
                ch = algebra.scale(ch, (-1) ** b)
            correction = algebra.add(correction, algebra.scale(
                algebra.mul(ch, algebra.power(twist, k - b)),
                Q(1, factorial(k - b))))
        return algebra.add(old, correction)
    return old


def lower_length(algebra, polynomial, lengths, chosen, residual):
    r = lengths[chosen]
    require(r > 0, "A length-reduction step must lower a positive length.")
    pulled = {}
    replacements = {}
    for monomial, coefficient in polynomial.items():
        term = algebra.scale(algebra.one, coefficient)
        for atom in monomial:
            if atom not in replacements:
                replacements[atom] = pull_atom(algebra, atom, chosen, residual)
            term = algebra.mul(term, replacements[atom])
        pulled = algebra.add(pulled, term)
    smaller = list(lengths)
    smaller[chosen] -= 1
    require(sum(smaller) == sum(lengths) - 1, "Length measure did not decrease.")
    pulled = simplify_empty(algebra, pulled, smaller)
    max_z = max((sum(a[0] == "z" for a in m) for m in pulled), default=0)
    segre = [algebra.one]
    for n in range(1, max_z + 1):
        value = {}
        if smaller[chosen]:
            for k in range(2, n + 1):
                value = algebra.add(value, algebra.scale(
                    algebra.mul(ideal_ch(algebra, chosen, k, residual),
                                segre[n - k]),
                    Q(factorial(k), n)))
        segre.append(value)
    result = {}
    for monomial, coefficient in pulled.items():
        k = sum(a[0] == "z" for a in monomial)
        other_atoms = tuple(a for a in monomial if a[0] != "z")
        result = algebra.add(result, algebra.mul(
            {other_atoms: coefficient / r}, segre[k]))
    return result, tuple(smaller)


def initial_fiber(algebra, lengths):
    """Literal rel:fiber-contribution at L1=L2=T=H=0, p=m1=m2=0."""
    total = sum(lengths)
    if total < 2:
        return {}
    fixed = algebra.one
    for i, n in enumerate(lengths):
        fixed = algebra.mul(fixed, algebra.scale(
            algebra.chern(lambda k: algebra.atom("A", i, k, 1), n),
            (-1) ** n))
    log_ratio = {}
    for i, j, u in ((0, 1, -1), (1, 0, 1)):
        for k in range(1, total - 1):
            scale = Q(factorial(k - 1), u ** k)
            log_ratio = algebra.add(
                log_ratio,
                algebra.scale(algebra.atom("A", i, k, 1), -scale),
                algebra.scale(algebra.atom("E", i, j, k, 0), (-1) ** k * scale))
    log_ratio = simplify_empty(algebra, log_ratio, lengths)
    ratio = algebra.scale(algebra.exp(log_ratio, total - 2), (-1) ** lengths[1])
    polynomial = algebra.mul(fixed, ratio)
    for output in (0, 1):
        incidence = algebra.add(*[
            algebra.scale(ideal_ch(algebra, i, 2, output), -1)
            for i in range(2)])
        polynomial = algebra.mul(polynomial, incidence)
    return simplify_empty(
        algebra, algebra.homogeneous(polynomial, 2 * total + 2), lengths)


def chi_multiple_K(p):
    value = Q(1) + Q(9, 2) * p * (p - 1)
    require(value.denominator == 1, "The selected P^2 line must have integral Euler characteristic.")
    return value.numerator


def shifted_fiber(algebra, lengths):
    """Full x extraction for the genuine P^2 data T=O(1), H=L1=L2=0."""
    D, w = (Q(-1, 3), Q()), (Q(1, 2), Q(-1, 2))
    xs = [algebra.atom("x", i) for i in range(2)]
    total = sum(lengths)
    fixed, scalar, log_ratio = algebra.one, algebra.one, {}
    for i, n in enumerate(lengths):
        euler = {}
        for j in range(n + 1):
            euler = algebra.add(euler, algebra.scale(algebra.mul(
                algebra.chern(lambda k: algebra.atom("A", i, k, 1 - D[i]), j),
                algebra.power(xs[i], n - j)), (-1) ** j))
        fixed = algebra.mul(fixed, euler)
    for i, j, u in ((0, 1, -1), (1, 0, 1)):
        y = algebra.add(xs[i], algebra.scale(xs[j], -1))
        scalar = algebra.mul(scalar, algebra.mul(
            algebra.weight_power(u, y, chi_multiple_K(D[i] - D[j]) - total),
            algebra.weight_power(u, xs[i], lengths[i] - chi_multiple_K(D[i]))))
        for k in range(1, algebra.cutoff + 1):
            log_ratio = algebra.add(
                log_ratio,
                algebra.scale(algebra.mul(
                    algebra.atom("A", i, k, 1 - D[i]),
                    algebra.weight_power(u, xs[i], -k)), -factorial(k - 1)),
                algebra.scale(algebra.mul(
                    algebra.atom("E", i, j, k, D[i] - D[j]),
                    algebra.weight_power(u, y, -k)), (-1) ** k * factorial(k - 1)))
    log_ratio = simplify_empty(algebra, log_ratio, lengths)
    polynomial = algebra.mul(fixed, algebra.mul(
        scalar, algebra.exp(log_ratio, algebra.cutoff)))
    for output in (0, 1):
        J = {}
        for i in range(2):
            divisor = algebra.add(algebra.scale(algebra.atom("K", output), D[i]), xs[i])
            J = algebra.add(J, algebra.scale(ideal_ch(algebra, i, 2, output), -1),
                            algebra.scale(divisor, w[i]),
                            algebra.scale(algebra.power(divisor, 2), Q(-1, 2)))
        polynomial = algebra.mul(polynomial, J)
    polynomial = algebra.extract_x(polynomial)
    return simplify_empty(algebra, algebra.homogeneous(polynomial, 2 * total + 2), lengths)


def normalize_graphs(polynomial, slots):
    result = defaultdict(Q)
    for monomial, coefficient in polynomial.items():
        parent = list(range(slots))

        def find(v):
            while parent[v] != v:
                v = parent[v]
            return v

        edges = []
        for atom in monomial:
            if atom[0] == "D":
                _, a, b = atom
                parent[find(b)] = find(a)
                edges.append((a, b))
            else:
                require(atom[0] in ("K", "C"),
                        "A Hilbert or projective generator survived elimination.")
        components = defaultdict(list)
        for v in range(slots):
            components[find(v)].append(v)
        moments, outputs, connected = [], {}, False
        valid = True
        for vertices in components.values():
            vertices = set(vertices)
            e = sum(a in vertices for a, _ in edges)
            c2 = e - len(vertices) + 1
            K = 0
            for atom in monomial:
                if atom[0] == "K" and atom[1] in vertices:
                    K += 1
                if atom[0] == "C" and atom[1] in vertices:
                    c2 += 1
            codimension = K + 2 * c2
            retained = vertices & {0, 1}
            if not retained:
                if (K, c2) == (2, 0):
                    moments.append("K2")
                elif (K, c2) == (0, 1):
                    moments.append("c2")
                else:
                    valid = False
                    break
            elif len(retained) == 2:
                connected = True
                if codimension:
                    valid = False
                    break
            else:
                if codimension > 2:
                    valid = False
                    break
                outputs[next(iter(retained))] = (K, c2)
        if valid:
            if connected:
                key = ("diagonal", (), tuple(sorted(moments)))
            else:
                require(sum(k + 2 * c for k, c in outputs.values()) == 2,
                        "The output has the wrong ordinary codimension.")
                key = ("external", (outputs[0], outputs[1]), tuple(sorted(moments)))
            result[key] += coefficient
    return {key: value for key, value in result.items() if value}


def recursive_fiber(lengths, shifted=False):
    total = sum(lengths)
    algebra = Algebra(2 * total + 2, (2, 0) if shifted else (0, 0))
    polynomial = shifted_fiber(algebra, lengths) if shifted else initial_fiber(algebra, lengths)
    sizes, residual = [], 2
    while sum(lengths):
        choices = [i for i in range(2) if lengths[i]]
        chosen = choices[0]
        polynomial, lengths = lower_length(
            algebra, polynomial, lengths, chosen, residual)
        sizes.append(len(polynomial))
        residual += 1
    return normalize_graphs(polynomial, residual), sizes


def p2_realization(normal):
    answer = defaultdict(Q)
    for (kind, outputs, moments), coefficient in normal.items():
        for moment in moments:
            coefficient *= {"K2": 9, "c2": 3}[moment]
        if kind == "diagonal":
            for powers in ((2, 0), (1, 1), (0, 2)):
                answer[powers] += coefficient
        else:
            powers = []
            for k, c in outputs:
                coefficient *= (-3) ** k * 3 ** c
                powers.append(k + 2 * c)
            answer[tuple(powers)] += coefficient
    return {powers: answer[powers] for powers in ((2, 0), (1, 1), (0, 2))}


def partitions(n, largest=None):
    if n == 0:
        yield ()
        return
    if largest is None:
        largest = n
    for first in range(min(n, largest), 0, -1):
        for rest in partitions(n - first, first):
            yield (first,) + rest


def toric_configurations(n):
    for a in range(n + 1):
        for b in range(n - a + 1):
            c = n - a - b
            yield from product(partitions(a), partitions(b), partitions(c))


def cells(partition):
    return [(r, c) for r, width in enumerate(partition) for c in range(width)]


def local_weights(partition, a, b):
    tangent = []
    for row, col in cells(partition):
        arm = partition[row] - col - 1
        leg = sum(width > col for width in partition[row + 1:])
        tangent.extend((-leg * a + (arm + 1) * b,
                        (leg + 1) * a - arm * b))
    require(all(tangent), "Non-generic torus specialization; not a mathematical failure.")
    taut_dual = [a + b + r * a + c * b for r, c in cells(partition)]
    V = Counter(-(r * a + c * b) for r, c in cells(partition))
    return tangent, taut_dual, V


def ext_character(Vi, Vj, a, b):
    result = Counter(Vj)
    for v, multiplicity in Vi.items():
        result[a + b - v] += multiplicity
        for w, count in Vj.items():
            for shift, sign in ((0, -1), (a, 1), (b, 1), (a + b, -1)):
                result[shift - v + w] += sign * multiplicity * count
    return {weight: count for weight, count in result.items() if count}


def binomial_integer(n, k):
    result = Q(1)
    for j in range(k):
        result *= Q(n - j, j + 1)
    return result


def series_multiply(left, right, order):
    return [sum((left[j] * right[k - j] for j in range(k + 1)), Q())
            for k in range(order)]


def toric_fiber(lengths):
    """Independent equivariant Hilbert integration on P^2, then ordinary degree."""
    total = sum(lengths)
    answer = {(2, 0): Q(), (1, 1): Q(), (0, 2): Q()}
    if total < 2:
        return answer, 0
    weights = (0, 13, 101)
    charts = [tuple(weights[q] - weights[p] for q in range(3) if q != p)
              for p in range(3)]
    order, count = total - 1, 0
    for left, right in product(toric_configurations(lengths[0]),
                               toric_configurations(lengths[1])):
        count += 1
        local = [[local_weights(config[p], *charts[p]) for p in range(3)]
                 for config in (left, right)]
        fixed, tangent_euler = Q(1), Q(1)
        for i in range(2):
            for tangent, taut, _ in local[i]:
                for weight in tangent:
                    tangent_euler *= weight
                for weight in taut:
                    fixed *= weight
        ratio = [Q(1)] + [Q()] * (order - 1)
        for i, j, u in ((0, 1, -1), (1, 0, 1)):
            factors = Counter()
            for p, (a, b) in enumerate(charts):
                factors.update(local[i][p][1])
                ext = ext_character(local[i][p][2], local[j][p][2], a, b)
                require(sum(ext.values()) == sum(map(len, (cells((left, right)[i][p]),
                                                           cells((left, right)[j][p])))),
                        "The Ext character has the wrong virtual rank.")
                for weight, multiplicity in ext.items():
                    factors[weight] -= multiplicity
            for weight, multiplicity in factors.items():
                factor = [binomial_integer(multiplicity, k) * Q(weight, u) ** k
                          for k in range(order)]
                ratio = series_multiply(ratio, factor, order)
            ratio = [value * Q(u) ** (-lengths[j]) for value in ratio]
        occupancy = [len(cells(left[p])) + len(cells(right[p])) for p in range(3)]
        moments = [sum(occupancy[p] * (-weights[p]) ** k for p in range(3))
                   for k in range(3)]
        scalar = fixed * ratio[total - 2] / tangent_euler
        answer[(2, 0)] += scalar * moments[0] * moments[2]
        answer[(1, 1)] += scalar * moments[1] ** 2
        answer[(0, 2)] += scalar * moments[2] * moments[0]
    return answer, count


def toric_shifted_fiber(lengths):
    """Independent toric evaluation including the two projective variables."""
    total = sum(lengths)
    algebra = Algebra(2 * total, (2, 0))
    s = algebra.atom("s")
    xs = [algebra.atom("x", i) for i in range(2)]
    divisors, w = (Q(-1, 3), Q()), (Q(1, 2), Q(-1, 2))
    weights = (0, 13, 101)
    charts = [tuple(weights[q] - weights[p] for q in range(3) if q != p)
              for p in range(3)]
    answer, count = defaultdict(Q), 0
    for left, right in product(toric_configurations(lengths[0]),
                               toric_configurations(lengths[1])):
        count += 1
        configs = (left, right)
        local = [[local_weights(config[p], *charts[p]) for p in range(3)]
                 for config in configs]
        integrand, tangent_euler = algebra.one, Q(1)
        for i in range(2):
            for p, (a, b) in enumerate(charts):
                tangent, _, _ = local[i][p]
                for weight in tangent:
                    tangent_euler *= weight
                for row, col in cells(configs[i][p]):
                    dual_weight = (1 - divisors[i]) * (a + b) + row * a + col * b
                    integrand = algebra.mul(integrand, algebra.add(
                        xs[i], algebra.scale(s, dual_weight)))
        for i, j, u in ((0, 1, -1), (1, 0, 1)):
            shift = algebra.add(xs[i], algebra.scale(xs[j], -1))
            integrand = algebra.mul(integrand, algebra.mul(
                algebra.weight_power(u, shift, chi_multiple_K(divisors[i] - divisors[j])),
                algebra.weight_power(u, xs[i], -chi_multiple_K(divisors[i]))))
            for p, (a, b) in enumerate(charts):
                for row, col in cells(configs[i][p]):
                    weight = (1 - divisors[i]) * (a + b) + row * a + col * b
                    integrand = algebra.mul(integrand, algebra.weight_power(
                        u, algebra.add(xs[i], algebra.scale(s, weight)), 1))
                ext = ext_character(local[i][p][2], local[j][p][2], a, b)
                for weight, multiplicity in ext.items():
                    weight -= (divisors[i] - divisors[j]) * (a + b)
                    integrand = algebra.mul(integrand, algebra.weight_power(
                        u, algebra.add(shift, algebra.scale(s, weight)), -multiplicity))
        moments = []
        for k in range(3):
            laurent = defaultdict(Q)
            for p, (a, b) in enumerate(charts):
                J = algebra.scale(algebra.power(s, 2),
                                  (len(cells(left[p])) + len(cells(right[p]))) * a * b)
                for i in range(2):
                    divisor = algebra.add(xs[i], algebra.scale(s, -divisors[i] * (a + b)))
                    J = algebra.add(J, algebra.scale(divisor, w[i]),
                                    algebra.scale(algebra.power(divisor, 2), Q(-1, 2)))
                for monomial, coefficient in J.items():
                    exponent = sum(atom[0] == "s" for atom in monomial) + k - 2
                    x_part = tuple(atom for atom in monomial if atom[0] != "s")
                    laurent[(exponent, x_part)] += coefficient * Q((-weights[p]) ** k, a * b)
            moment = {}
            for (exponent, x_part), coefficient in laurent.items():
                if not coefficient:
                    continue
                require(exponent >= 0, "Surface toric integration retained a negative degree.")
                monomial = tuple(sorted(x_part + (("s",),) * exponent))
                moment[monomial] = coefficient
            moments.append(moment)
        for powers in ((2, 0), (1, 1), (0, 2)):
            paired = algebra.mul(integrand, algebra.mul(moments[2 - powers[0]], moments[2 - powers[1]]))
            paired = algebra.homogeneous(algebra.extract_x(paired), 2 * total)
            answer[powers] += sum(paired.values(), Q()) / tangent_euler
    return {p: answer[p] for p in ((2, 0), (1, 1), (0, 2))}, count


def check_local_identities():
    algebra = Algebra(8)
    K, C = algebra.atom("K", 0), algebra.atom("C", 0)
    todd = algebra.add(algebra.one, algebra.scale(K, Q(-1, 2)),
                       algebra.scale(algebra.power(K, 2), Q(1, 12)),
                       algebra.scale(C, Q(1, 12)))
    inverse = algebra.add(algebra.one, algebra.scale(K, Q(1, 2)),
                          algebra.scale(algebra.power(K, 2), Q(1, 6)),
                          algebra.scale(C, Q(-1, 12)))
    require(algebra.mul(todd, inverse) == algebra.one, "Graph Todd factor is incorrect.")
    n = 8
    positive = algebra.exp(algebra.atom("K", 1), n)
    negative = algebra.exp(algebra.scale(algebra.atom("K", 1), -1), n)
    require(algebra.mul(positive, negative) == algebra.one, "Dual line sign is incorrect.")
    P = algebra.atom("I", 0, 2, 0)
    pulled = pull_atom(algebra, ("I", 0, 2, 0), 0, 2)
    expected = algebra.add(P, algebra.scale(algebra.atom("D", 0, 2), -1))
    require(pulled == expected, "The universal ideal sequence has the wrong sign.")
    repeated = {(("D", 0, 2), ("D", 0, 2), ("D", 1, 2)): Q(1)}
    require(normalize_graphs(repeated, 3) == {}, "A decorated output diagonal survived in codimension two.")
    triangle = {(("D", 0, 2), ("D", 0, 3), ("D", 2, 3)): Q(1)}
    normalized = normalize_graphs(triangle, 4)
    require(normalized == {
        ("external", ((0, 1), (0, 0)), ()): Q(1)},
        "A triangular incidence cycle lost its c_2 excess decoration.")
    double_edge = {(("D", 2, 3), ("D", 2, 3)): Q(1)}
    # This graph has output codimension zero, so test its excess with a top-degree output.
    decorated = {tuple(sorted(m + (("K", 0), ("K", 1)))): c
                 for m, c in double_edge.items()}
    require(normalize_graphs(decorated, 4) == {
        ("external", ((1, 0), (1, 0)), ("c2",)): Q(1)},
        "A repeated incidence edge lost its c_2 excess factor.")
    return {"surface_todd_inverse": True, "derived_dual_sign": True,
            "ideal_sequence_minus_sign": True, "repeated_incidence_excess": True}


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_adapter_status.json").read_text())
    require(not status["timed_out"], "The archived adapter attempt timed out.")
    require(status["exit_code"] == 2 and output.get("ok") is False,
            "The adapter status changed; review its typed outcome.")
    error = output["error"]["data"]
    require(error["code"] == "INVALID_REQUEST"
            and error["stage"] == "operation_validation"
            and error["operation_id"] == "formal_series.rational.inverse.compute",
            "The archived refusal is not the inspected operation's typed refusal.")
    coefficients = [Q(int(c["num"]), int(c["den"])) for c in payload["coefficients"]]
    inverse = [1 / coefficients[0]]
    for k in range(1, payload["truncation_order"]):
        inverse.append(-sum((coefficients[j] * inverse[k - j] for j in range(1, k + 1)),
                            Q()) / coefficients[0])
    product = series_multiply(coefficients, inverse, len(coefficients))
    require(product == [Q(1)] + [Q()] * (len(coefficients) - 1),
            "The independently computed inverse does not multiply to one.")
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    return contract, [str(value) for value in inverse]


def serialize_normal(normal):
    return [{"kind": kind, "outputs": outputs, "moments": moments,
             "coefficient": str(coefficient)}
            for (kind, outputs, moments), coefficient in sorted(normal.items())]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    identities = check_local_identities()
    adapter, inverse = check_jacobian()
    cases = []
    for lengths in ((0, 0), (1, 0), (2, 0), (1, 1), (3, 0), (2, 1), (3, 1), (2, 2)):
        normal, sizes = recursive_fiber(lengths)
        realized = p2_realization(normal)
        toric, fixed_points = toric_fiber(lengths)
        require(realized == toric, f"Independent full-integrand disagreement at {lengths}: {realized} != {toric}")
        if lengths == (2, 0):
            require(realized == {(2, 0): Q(), (1, 1): Q(9), (0, 2): Q()},
                    "The direct length-two normalization is incorrect.")
        cases.append({
            "lengths": lengths,
            "formal_chow_result": serialize_normal(normal),
            "p2_h2x1_hxh_1xh2": [str(realized[p]) for p in ((2, 0), (1, 1), (0, 2))],
            "independent_toric_fixed_points": fixed_points,
            "terms_after_each_length_reduction": sizes,
        })
    lengths = (1, 0)
    shifted, sizes = recursive_fiber(lengths, shifted=True)
    shifted_toric, fixed_points = toric_shifted_fiber(lengths)
    require(p2_realization(shifted) == shifted_toric,
            "The full projective-coefficient expression disagrees with independent toric integration.")
    require(shifted.get(("diagonal", (), ())) == 1,
            "The nonzero selected diagonal coefficient was not retained before Chow realization.")
    shifted_case = {
        "lengths": lengths, "T": "O_P2(1)", "H": 0, "L1": 0, "L2": 0,
        "p": 0, "m1": 2, "m2": 0,
        "formal_chow_result": serialize_normal(shifted),
        "p2_h2x1_hxh_1xh2": [str(shifted_toric[p]) for p in ((2, 0), (1, 1), (0, 2))],
        "independent_toric_fixed_points": fixed_points,
        "terms_after_each_length_reduction": sizes,
        "selected_diagonal_coefficient": "1",
    }
    certificate = {
        "claim": "C40_BRIDGE",
        "result_type": "mathematical_proof_with_exact_algebra_replay",
        "proof": "REPORT.md",
        "geometric_inputs": "sources.md",
        "uniform_scope": "All nonnegative point lengths and all specified manuscript parameters, by the induction in REPORT.md; finite instances below are not its proof.",
        "kernel_formalization": False,
        "independent_review": "pending",
        "local_identities": identities,
        "jacobian_inverse_recomputed": inverse,
        "jacobian_status": "adapter_refused_input; no mathematical conclusion",
        "jacobian_protocol": adapter["protocol_version"],
        "jacobian_server_version": adapter["server"]["version"],
        "fiber_slice": {"L1": 0, "L2": 0, "T": 0, "H": 0, "p": 0, "m1": 0, "m2": 0,
                        "w1": "1/2", "w2": "-1/2"},
        "cases": cases,
        "nonzero_projective_shift_case": shifted_case,
    }
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        expected = json.loads(target.read_text())
        actual = json.loads(json.dumps(certificate))
        require(actual == expected, "Certificate does not replay; regenerate only after explaining the mathematical change.")
    print(json.dumps({"ok": True, "claim": "C40_BRIDGE", "exact_full_integrand_cases": len(cases) + 1,
                      "geometric_proof": "REPORT.md", "review": "pending"}))


if __name__ == "__main__":
    main()
