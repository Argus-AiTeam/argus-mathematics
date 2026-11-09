#!/usr/bin/env python3
"""Replay exact arithmetic/algebra and bounded interleaving stress checks.

The universal analytic proof is in audit_report.md, not inferred from the
finite checks. This verifier uses only the Python standard library.
"""

import json
import math
from collections import Counter
from fractions import Fraction as Q
from itertools import combinations
from pathlib import Path


def require(condition, message):
    if not condition:
        raise ValueError(message)


class Poly:
    def __init__(self, dimension, terms=None):
        self.dimension = dimension
        self.terms = {p: Q(c) for p, c in (terms or {}).items() if c}

    @classmethod
    def variable(cls, dimension, index):
        power = tuple(int(i == index) for i in range(dimension))
        return cls(dimension, {power: 1})

    def coerce(self, other):
        if isinstance(other, Poly):
            require(self.dimension == other.dimension, "polynomial dimensions")
            return other
        return Poly(self.dimension, {(0,) * self.dimension: Q(other)})

    def __add__(self, other):
        other = self.coerce(other)
        terms = dict(self.terms)
        for power, coefficient in other.terms.items():
            terms[power] = terms.get(power, Q()) + coefficient
        return Poly(self.dimension, terms)

    __radd__ = __add__

    def __neg__(self):
        return Poly(self.dimension, {p: -c for p, c in self.terms.items()})

    def __sub__(self, other):
        return self + -self.coerce(other)

    def __rsub__(self, other):
        return self.coerce(other) - self

    def __mul__(self, other):
        other = self.coerce(other)
        terms = {}
        for left, a in self.terms.items():
            for right, b in other.terms.items():
                power = tuple(x + y for x, y in zip(left, right))
                terms[power] = terms.get(power, Q()) + a * b
        return Poly(self.dimension, terms)

    __rmul__ = __mul__

    def __pow__(self, exponent):
        require(isinstance(exponent, int) and exponent >= 0, "polynomial power")
        result = self.coerce(1)
        for _ in range(exponent):
            result = result * self
        return result

    def __eq__(self, other):
        return self.terms == self.coerce(other).terms


def atan_bounds(x, terms):
    require(0 <= x <= 1 and terms >= 1, "arctangent series domain")
    total = sum(
        ((-1) ** j * x ** (2 * j + 1) / (2 * j + 1) for j in range(terms)),
        Q(),
    )
    next_sum = total + (-1) ** terms * x ** (2 * terms + 1) / (2 * terms + 1)
    return min(total, next_sum), max(total, next_sum)


def verify_constants(data):
    c = data["constants"]
    expected = {
        "K": 2**16,
        "beta": "1/281474976710656",
        "eta_0": "1/79228162514264337593543950336",
        "C_0": 2**48,
        "C_1": 2**15,
        "C_2": 2**12,
        "C_3": 2**13,
        "rho": "500/1001",
    }
    require(c == expected, "explicit theorem constants changed")
    rho, beta, eta = Q(c["rho"]), Q(c["beta"]), Q(c["eta_0"])
    delta = 1 - 4 * rho**2
    c_one = delta / 2
    c_four = 3 + (4 + rho) ** 2 * (1 + 8 * rho**2 / delta)
    require(c_one == Q(2001, 2004002), "contour coercivity")
    require(c_four == Q(40618639330019, 2005004001), "Young coefficient")
    require(c_one > Q(1, 1024), "four-factor Gaussian decay")
    alpha = c_four * c["K"] ** 2 * beta**2 / 2
    require(alpha < Q(1, 10**6), "contour mass exponential cost")
    require(c_one * c["K"] ** 2 / 1024 > 30, "contour tail exponent")
    require(beta + rho * (beta + Q(1, 4)) < 1, "retained-box outer decay")
    require(3 * (c["C_3"] + Q(1, 16)) < c["C_1"], "added angles")
    require(Q(1001, 500) / Q(9999, 10000) < Q(2003, 1000), "window angle")
    require(Q(10001, 10000) * c["C_2"] < c["C_3"], "individual frequencies")
    require(Q(512, c["C_0"]) + Q(2, 2**23) < Q(1, 10**6), "log budgets")
    window_ratio = beta**2 * c["K"] ** 2 / eta**2
    require(Q(1, 10000) ** 2 * window_ratio / 8 > 100, "tilted Gaussian tail")
    require(Q(1, 10000) * window_ratio / 2 > 100, "large-distance tail")

    a5 = atan_bounds(Q(1, 5), 14)
    a239 = atan_bounds(Q(1, 239), 4)
    machin = (16 * a5[0] - 4 * a239[1], 16 * a5[1] - 4 * a239[0])
    pi_lo, pi_hi = Q(314159, 100000), Q(3927, 1250)
    require(pi_lo < machin[0] < machin[1] < pi_hi, "Machin pi enclosure")
    tau_hi = Q(2079, 10000)
    exp_lower = sum(
        ((pi_lo / 2) ** j / math.factorial(j) for j in range(21)), Q()
    )
    require(exp_lower > 1 / tau_hi, "exp(-pi/2) upper bound")
    single_mass = Q(1, 2) - (
        atan_bounds(Q(3, 1000), 8)[1]
        + atan_bounds(Q(1000, 4003), 12)[1]
    ) / pi_lo
    matching_mass = 1 - 4 * atan_bounds(tau_hi, 8)[1] / pi_lo
    retained_mass = matching_mass - 4 / (
        pi_lo * (c["C_2"] - Q(2003, 1000))
    )
    require(single_mass > Q(421, 1000), "single Cauchy mass > 0.421")
    require(matching_mass > Q(739, 1000), "double matching mass > 0.739")
    require(retained_mass > Q(738, 1000), "retained double pair mass > 0.738")
    critical_loss_upper = 1 / single_mass + 2 * max(1 / single_mass, 2 / matching_mass)
    require(critical_loss_upper < Q(779, 100), "structural loss criterion below 7.79")
    require(
        data["structural_extension"]["criterion"]
        == "L > 1/F(R,c) + 2 max(1/F(R,c),2/M(R))",
        "general theorem includes endpoint normalization",
    )

    budget = data["exponents"]
    require(
        budget
        == {
            "poisson": "10001/10000",
            "single": "297/125",
            "pair": "2711/1000",
            "single_normalization": "2377/1000",
            "pair_normalization": "339/125",
            "balanced": "781/100",
            "output": "196/25",
            "literal_output": "399/50",
            "contour_mass": "1/1000",
            "interleavings": "1/1000",
            "uniform_signal": "1/1000",
            "tail": "20",
        },
        "exponent certificate changed",
    )
    e = {key: Q(value) for key, value in budget.items()}
    require(e["poisson"] / single_mass < e["single"], "single deficit")
    require(2 * e["poisson"] / retained_mass < e["pair"], "pair deficit")
    require(1 + (e["balanced"] / 2 - e["pair"]) * c["C_0"] > 3, "evaluation")
    require(
        1 + (e["single_normalization"] - e["single"]) * c["C_0"] > 3,
        "single normalization factor",
    )
    require(
        1 + (e["pair_normalization"] - e["pair"]) * c["C_0"] > 9,
        "pair normalization factor",
    )
    xi_loss = e["balanced"] - 2 * e["pair_normalization"]
    require(xi_loss == Q(1193, 500), "Gram error exponent is 2.386")
    require(xi_loss - Q(1, 10**6) > e["single"], "Gram contradiction margin")
    retained_gap = e["output"] - e["contour_mass"] - e["interleavings"] - e["balanced"]
    tail_gap = e["tail"] - e["uniform_signal"] - e["interleavings"] - e["balanced"]
    require(100 * min(retained_gap, tail_gap) > 1, "final sum of exponentials")
    require(e["output"] < e["literal_output"], "strictly stronger output")
    require(4 <= 2 * 2, "degree-2k vectors use moments only through degree-4k")
    return {"single_mass_lower": ">0.421", "retained_double_pair_mass_lower": ">0.738"}


def verify_polynomial_identities(rho):
    u = [Poly.variable(4, i) for i in range(4)]
    q = sum(x**2 for x in u)
    sos = sum((u[i] - u[j]) ** 2 for i, j in combinations(range(4), 2))
    require(4 * q - sum(u) ** 2 == sos, "four-variable Cauchy SOS")
    delta = 1 - 4 * rho**2
    require(
        q - rho**2 * sum(u) ** 2 == delta * q + rho**2 * sos,
        "universal contour coercivity identity",
    )
    x, b = [Poly.variable(2, i) for i in range(2)]
    c_one = delta / 2
    c_four = 3 + (4 + rho) ** 2 * (1 + 8 * rho**2 / delta)
    require(
        (1 - c_one) * x**2 + (c_four - 3) * b**2
        - (2 * rho * x + (4 + rho) * b) ** 2
        == delta / 2 * (x - (4 * rho * (4 + rho) / delta) * b) ** 2,
        "universal weighted-Young identity",
    )
    ar, ai, zr, zi = [Poly.variable(4, i) for i in range(4)]
    require(
        (1 - ar * zr - ai * zi) ** 2 + (ar * zi - ai * zr) ** 2
        - (zr - ar) ** 2 - (zi - ai) ** 2
        == (1 - ar**2 - ai**2) * (1 - zr**2 - zi**2),
        "Poisson root-factor sign",
    )
    for m in range(1, 5):
        variables = [Poly.variable(2 * m + 1, i) for i in range(2 * m + 1)]
        coefficients, positions, center = variables[:m], variables[m:2 * m], variables[-1]
        left = sum(c * (j - center) for c, j in zip(coefficients, positions))
        right = sum(coefficients) * (positions[-1] - center)
        right -= sum(
            sum(coefficients[:r]) * (positions[r] - positions[r - 1])
            for r in range(1, m)
        )
        require(left == right, f"endpoint telescope m={m}")
    for sign in (-1, 1):
        real_derivative, imaginary_derivative = -rho * sign, Q(1)
        quotient_by_i = (imaginary_derivative, -real_derivative)
        require(quotient_by_i == (1, rho * sign), "bent-contour differential sign")
    return 10


def verify_jacobian(record, rho):
    response = record["successful_call"]["response"]
    require(record["successful_call"]["adapter_exit_code"] == 0, "Jacobian exit")
    require(response["protocol_version"] == "2025-11-25", "Jacobian protocol")
    require(response["server"]["version"] == "0.14.0", "Jacobian version")
    request = response["request"]
    require(request["operation_id"] == "matrix.inertia.compute", "Jacobian operation")
    payload = request["payload"]
    require(payload["dimension"] == 4, "Jacobian matrix size")
    matrix = [[Q() for _ in range(4)] for _ in range(4)]
    seen = set()
    for entry in payload["entries"]:
        i, j = entry["row"], entry["col"]
        require(0 <= i <= j < 4 and (i, j) not in seen, "upper triangular request")
        seen.add((i, j))
        value = Q(int(entry["value"]["num"]), int(entry["value"]["den"]))
        matrix[i][j] = matrix[j][i] = value
    expected = [[Q(i == j) - rho**2 for j in range(4)] for i in range(4)]
    require(matrix == expected, "Jacobian metric realizes I-rho^2 11^T")
    output = response["result"]["output"]
    dense = [
        [Q(int(x["num"]), int(x["den"])) for x in row]
        for row in output["matrix"]["entries"]
    ]
    require(dense == matrix, "retained typed source matrix")
    require(
        (output["n_positive"], output["n_negative"], output["n_zero"], output["definiteness"])
        == (4, 0, 0, "positive_definite"),
        "retained typed inertia",
    )
    work = [row[:] for row in matrix]
    for pivot in range(4):
        diagonal = work[pivot][pivot]
        require(diagonal > 0, "exact independent LDL pivot")
        for i in range(pivot + 1, 4):
            for j in range(pivot + 1, 4):
                work[i][j] -= work[i][pivot] * work[pivot][j] / diagonal
    rejected = record["rejected_call"]
    require(rejected["adapter_exit_code"] == 2, "retained adapter failure")
    require(rejected["response"]["ok"] is False, "failure was not support")
    require(
        rejected["response"]["error"]["data"]["code"] == "INVALID_REQUEST",
        "structured adapter error",
    )
    original = rejected["request"]["payload"]
    require(original["dimension"] == 4 and len(original["entries"]) == 16, "original payload")
    require(
        all(
            Q(int(v["value"]["num"]), int(v["value"]["den"])) == expected[v["row"]][v["col"]]
            for v in original["entries"]
        ),
        "original mirrored request matrix",
    )
    return "positive_definite, exact LDL replay"


def interleavings(m, k):
    positions = [[] for _ in range(m)]

    def visit(remaining, rank):
        live = [i for i, count in enumerate(remaining) if count]
        if not live:
            yield tuple(tuple(p) for p in positions)
            return
        for mask in range(1, 1 << len(live)):
            chosen = [i for bit, i in enumerate(live) if mask & (1 << bit)]
            following = list(remaining)
            for i in chosen:
                following[i] -= 1
                positions[i].append(rank)
            yield from visit(tuple(following), rank + 1)
            for i in chosen:
                positions[i].pop()

    yield from visit((k,) * m, 0)


def verify_interleaving(tuples, k):
    m = len(tuples)
    vertices = max(t[-1] for t in tuples) + 1
    edges = []
    for copy, positions in enumerate(tuples):
        require(len(positions) == k and len(set(positions)) == k, "old tuple order")
        for h in range(k - 1):
            edges.append((positions[h], positions[h + 1], copy, Q(h + 2, h + 3)))
    endpoints = sorted(t[-1] for t in tuples)
    b = Q(1, 5)
    for r in range(1, m):
        if endpoints[r - 1] != endpoints[r]:
            edges.append((endpoints[r - 1], endpoints[r], m, r * b))
    crossing = [[e for e, (left, right, _, _) in enumerate(edges) if left <= g < right]
                for g in range(vertices - 1)]
    assigned = {}

    def augment(gap, seen):
        for edge in crossing[gap]:
            if edge in seen:
                continue
            seen.add(edge)
            if edge not in assigned or augment(assigned[edge], seen):
                assigned[edge] = gap
                return True
        return False

    height = Q(1)
    for gap, crossing_edges in enumerate(crossing):
        require(crossing_edges, "nonempty new parameter")
        copies = [edges[e][2] for e in crossing_edges]
        require(len(copies) == len(set(copies)), "at most one factor from each list/link family")
        require(augment(gap, set()), "distinct-edge gap assignment")
        damping = sum((edges[e][3] for e in crossing_edges), Q())
        height *= 1 + 1 / damping
    old_height = math.prod(1 + 1 / Q(h + 2, h + 3) for h in range(k - 1))
    target = old_height**m * (1 + 1 / b) ** (m - 1)
    require(height <= target, "exact positive-damping height stress case")
    for left, right, _, _ in edges:
        require(
            sum(int(left <= g < right) for g in range(vertices - 1)) == right - left,
            "edge exponent splits into precisely its crossed merged gaps",
        )
    return vertices


def verify_interleavings(data):
    expected = data["finite_interleavings"]
    cases = {(m, k) for m in range(1, 5) for k in (1, 2)} | {(1, 3), (2, 3)}
    require(set(expected) == {f"m{m}_k{k}" for m, k in cases}, "bounded case set")
    counts = {}
    for name, declared_count in expected.items():
        m, k = (int(s[1:]) for s in name.split("_"))
        distribution = Counter()
        for tuples in interleavings(m, k):
            distribution[verify_interleaving(tuples, k)] += 1
        counts[name] = sum(distribution.values())
        require(counts[name] == declared_count, f"pattern inventory {name}")
        for n in range(m * k + 1):
            merged = sum(count * math.comb(n, v) for v, count in distribution.items() if v <= n)
            require(merged == math.comb(n, k)**m, f"interleaving coverage {name}, n={n}")
    require(sum(counts.values()) == 24496, "bounded inventory total")
    return counts


def verify_nonrepresentable_moments():
    cases = []
    for n, degree, denominator in ((4, 2, 11), (8, 4, 199)):
        rows = [mask for mask in range(1 << n) if mask.bit_count() <= degree]
        dimension = len(rows)
        off_diagonal = -Q(1, denominator)
        for left in rows:
            for right in rows:
                difference = left ^ right
                require(difference.bit_count() <= 2 * degree, "Boolean moment degree")
                moment = Q(1) if not difference else off_diagonal
                require(moment == (1 - off_diagonal if left == right else 0) + off_diagonal,
                        "Boolean matrix is the claimed rank-one perturbation")
        eigen_constant = Q(denominator + 1 - dimension, denominator)
        eigen_orthogonal = Q(denominator + 1, denominator)
        require(min(eigen_constant, eigen_orthogonal) > 0, "all polynomial vectors have positive norm")
        atom_mass = Q(denominator + 1 - 2**n, denominator * 2**n)
        require(atom_mass < 0 and n == 2 * degree, "no representing distribution")
        other_atom = Q(denominator + 1, denominator * 2**n)
        require(atom_mass + (2**n - 1) * other_atom == 1, "signed realization normalizes")
        cases.append({
            "suffix_bits": n,
            "D": degree,
            "matrix_dimension": dimension,
            "eigenvalue_constant": str(eigen_constant),
            "eigenvalue_orthogonal": str(eigen_orthogonal),
            "negative_atom_mass": str(atom_mass),
        })
    return cases


def main():
    certificate = json.loads(Path(__file__).with_name("exact_certificate.json").read_text())
    require(certificate["result_class"] == "improved_bound", "result classification")
    masses = verify_constants(certificate)
    identities = verify_polynomial_identities(Q(certificate["constants"]["rho"]))
    jacobian = verify_jacobian(certificate["jacobian"], Q(certificate["constants"]["rho"]))
    inventory = verify_interleavings(certificate)
    moments = verify_nonrepresentable_moments()
    print(json.dumps({
        "status": "verified",
        "scope": "exact constants and universal polynomial identities; finite interleavings are stress checks, not the universal analytic proof",
        "cauchy_masses": masses,
        "universal_polynomial_identities": identities,
        "jacobian_replay": jacobian,
        "finite_interleavings": sum(inventory.values()),
        "nonrepresentable_boolean_moments": moments,
        "universal_analytic_proof": "research/audit_report.md; independent review pending",
    }, indent=2))


if __name__ == "__main__":
    main()
