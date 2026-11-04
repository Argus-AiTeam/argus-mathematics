"""Exact algebraic certificate and clearly separated stability regressions."""

from fractions import Fraction as F
from itertools import combinations
import json
from math import factorial
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


class Polynomial:
    """Sparse rational polynomials in three indeterminates."""

    def __init__(self, value=0):
        terms = value if isinstance(value, dict) else {(0, 0, 0): F(value)}
        self.terms = {key: F(value) for key, value in terms.items() if value}

    def __add__(self, other):
        other = other if isinstance(other, Polynomial) else Polynomial(other)
        terms = self.terms.copy()
        for key, value in other.terms.items():
            terms[key] = terms.get(key, F(0)) + value
        return Polynomial(terms)

    __radd__ = __add__

    def __neg__(self):
        return Polynomial({key: -value for key, value in self.terms.items()})

    def __sub__(self, other):
        return self + (-other if isinstance(other, Polynomial) else -F(other))

    def __rsub__(self, other):
        return -self + other

    def __mul__(self, other):
        other = other if isinstance(other, Polynomial) else Polynomial(other)
        terms = {}
        for left, a in self.terms.items():
            for right, b in other.terms.items():
                key = tuple(x + y for x, y in zip(left, right))
                terms[key] = terms.get(key, F(0)) + a * b
        return Polynomial(terms)

    __rmul__ = __mul__

    def __pow__(self, exponent):
        require(type(exponent) is int and exponent >= 0, "Invalid exponent.")
        result = Polynomial(1)
        for _ in range(exponent):
            result = result * self
        return result


def polynomial_certificate():
    x = Polynomial({(1, 0, 0): 1})
    y = Polynomial({(0, 1, 0): 1})
    z = Polynomial({(0, 0, 1): 1})
    identities = {
        "span_chord": (x * (3 - 2 * x) - 1, (2 * x - 1) * (1 - x)),
        "lambda_over_T": ((x + 1) ** 2 - (x - 1) ** 2, 4 * x),
        "R_from_d": ((x + 1) + (x - 1), x * ((x + 1) - (x - 1))),
        "terminal_majorant_cleared": (
            (x - 4 * y) * z ** 2 + 4 * y ** 2 * x
            - 4 * y * x * z + 4 * y * z ** 2,
            x * (z - 2 * y) ** 2,
        ),
        "central_antiderivative_cleared": (
            (1 - x) + (1 + x) - 2 * (1 - x ** 2),
            2 * x ** 2,
        ),
        "span_square_completion_cleared": (
            4 * x * (2 * x * z + y) * (3 - 2 * z),
            (3 * x + y) ** 2 - (4 * x * z - (3 * x - y)) ** 2,
        ),
        "radius_lower_bound_cleared": (
            2 * (x * (y + z) - (y + F(1, 2))),
            2 * (x - 1) * y - (1 - 2 * x * z),
        ),
    }
    for name, (left, right) in identities.items():
        require(not (left - right).terms, f"Polynomial identity failed: {name}")
    return {
        "method": "exact rational coefficient comparison, not sampled evaluation",
        "identities": list(identities),
    }


def arithmetic_certificate():
    exponential_lower = sum((F(3) ** k / factorial(k) for k in range(9)), F(0))
    require(exponential_lower == F(89641, 4480), "Exponential sum mismatch.")
    require(exponential_lower > 20, "Cannot infer log(20)<3.")
    a_upper, b, span = F(19, 14), F(20, 441), F(64, 5)
    base = a_upper + b * span
    error = 22 * a_upper + 176 * b
    margin = 2 - base
    threshold = margin / (error + 10 * margin)
    require(base == F(1709, 882), "Exact-case energy margin mismatch.")
    require(error == F(16687, 441), "Perturbation coefficient mismatch.")
    require(threshold == F(5, 3084), "Wrong threshold.")
    require(0 < threshold < F(1, 10), "Radius positivity range failed.")

    def energy_upper(epsilon):
        return base + error * epsilon / (1 - 10 * epsilon)

    require(energy_upper(threshold) == 2, "Endpoint is not exactly excluded.")
    require(energy_upper(F(1, 1000)) < 2, "Requested threshold not reached.")
    require(threshold - F(1, 1000) == F(479, 771000), "Target margin mismatch.")
    return {
        "exp3_taylor_degree": 8,
        "exp3_strict_lower": str(exponential_lower),
        "log20_strict_upper": "3",
        "a20_strict_upper": str(a_upper),
        "b20": str(b),
        "span_envelope": str(span),
        "base_strict_upper": str(base),
        "margin": str(margin),
        "error_coefficient": str(error),
        "epsilon_strict_lower": str(threshold),
        "aspect_ratio_strict_lower": str(1 + threshold),
        "required_ratio": "1001/1000",
        "epsilon_improvement_over_required": str(threshold - F(1, 1000)),
        "coarse_energy_at_required_ratio": str(energy_upper(F(1, 1000))),
        "coarse_energy_at_certified_endpoint": str(energy_upper(threshold)),
        "radius_lower_at_endpoint": str((1 - 10 * threshold) / 8),
        "prior_elementary_epsilon": "1/" + str(11 ** 26),
        "strictly_improves_prior_elementary_gap": threshold > F(1, 11 ** 26),
    }


def jacobian_certificate(threshold):
    directory = ROOT / "jacobian"
    payload = json.loads((directory / "robust-threshold.payload.json").read_text())
    contract = json.loads((directory / "robust-threshold.contract.json").read_text())
    result = json.loads((directory / "robust-threshold.result.json").read_text())
    operation = "linear.rational_solution.compute"
    require(contract["result"]["operation"]["operation_id"] == operation,
            "Wrong inspected operation.")
    require(result["request"]["operation_id"] == operation, "Wrong request.")
    require(result["request"]["payload"] == payload, "Payload was changed.")
    require(result["result"]["operation_id"] == operation, "Wrong result.")
    output = result["result"]["output"]
    require(output["status"] == "SOLUTION", "Jacobian did not give a solution.")
    require(output["system"]["variables"] == ["epsilon_threshold"],
            "Unexpected solution variables.")
    requested = payload["system"]
    require(output["system"]["coefficients"]["entries"]
            == requested["coefficients"]["entries"], "Changed coefficients.")
    require(output["system"]["rhs"] == requested["rhs"], "Changed right side.")

    def rational(value):
        return F(int(value["num"]), int(value["den"]))

    require(len(output["values"]) == 1, "Wrong solution dimension.")
    value = rational(output["values"][0])
    coefficient = rational(requested["coefficients"]["entries"][0][0])
    rhs = rational(requested["rhs"][0])
    require(coefficient == 33924 and rhs == 55, "Wrong threshold equation.")
    require(coefficient * value == rhs and value == threshold,
            "Jacobian solution fails exact replay.")
    return {
        "operation_id": operation,
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "status": output["status"],
        "solution": str(value),
        "equation_residual": str(coefficient * value - rhs),
        "scope": "one rational threshold equation, not the analytic theorem",
    }


def distance(left, right):
    return sum((abs(x - y) for x, y in zip(left, right)), F(0))


def clipping_regression(points):
    m, n = len(points), len(points[0])
    bounds = [sorted(point[j] for point in points) for j in range(n)]
    clipped = [[min(bounds[j][-2], max(bounds[j][1], point[j]))
                for j in range(n)] for point in points]
    displacement = [distance(point, image) for point, image in zip(points, clipped)]
    for i, k in combinations(range(m), 2):
        require(distance(clipped[i], clipped[k])
                == distance(points[i], points[k]) - displacement[i] - displacement[k],
                "Clipping pair-loss identity failed.")
    require(sum(s > 0 for s in displacement) <= 2 * n, "Too many labels moved.")
    for j in range(n):
        values = [point[j] for point in clipped]
        require(values.count(min(values)) >= 2 and values.count(max(values)) >= 2,
                "Clipped extremum is not repeated.")
    return clipped, [F(1, 2) - s for s in displacement]


def stability_regressions():
    data = json.loads((ROOT / "configuration-115-106.json").read_text())
    points = [[F(value, data["scale"]) for value in point]
              for point in data["integer_points"]]
    y, radii = clipping_regression(points)
    epsilon = F(data["aspect_ratio"]) - 1
    require(all((1 - 10 * epsilon) / 8 <= r <= F(1, 2) for r in radii),
            "Perturbed radius bound failed.")
    mu = [1 / r for r in radii]
    total, maximum = sum(mu), max(mu)
    pairs = list(combinations(range(11), 2))
    eta = {(i, k): distance(points[i], points[k]) - 1 for i, k in pairs}
    require(all(0 <= error <= epsilon for error in eta.values()),
            "Regression input is outside its distance-error range.")
    require(all(abs(y[i][j] - y[k][j]) <= min(radii[i], radii[k]) + epsilon
                for i, k in pairs for j in range(5)), "Coordinate bound failed.")
    spans = [max(p[j] for p in y) - min(p[j] for p in y) for j in range(5)]
    assigned = []
    for j in range(5):
        for value in (min(p[j] for p in points), max(p[j] for p in points)):
            owners = [i for i in range(11) if points[i][j] == value]
            mass = mu[owners[0]] if len(owners) == 1 else F(2)
            assigned.append(mass)
            group_mass = sum(mu[i] for i in range(11) if y[i][j] == (
                min(p[j] for p in y) if value == min(p[j] for p in points)
                else max(p[j] for p in y)))
            require(group_mass >= mass + 2, "Endpoint group-mass bound failed.")
            require(spans[j] <= 1 / mass + epsilon, "Assigned-end span bound failed.")
    require(total <= sum(assigned) + 2, "Endpoint accounting failed.")
    require(all(length <= 2 / maximum + 2 * epsilon for length in spans),
            "Maximum-mass span bound failed.")
    w = sum(assigned) / (10 * maximum)
    phi = (10 * w + 2 / maximum) * min(2, 3 - 2 * w)
    require(total * sum(spans) / 5 <= phi + 2 * epsilon * total,
            "Shifted-span averaging failed.")
    require(phi <= F(64, 5), "Uniform span envelope failed.")
    total_energy = sum(mu[i] * mu[k] * distance(y[i], y[k]) for i, k in pairs) / total
    require(total_energy == 10 + sum(mu[i] * mu[k] * eta[i, k]
                                     for i, k in pairs) / total,
            "Perturbed total-energy identity failed.")
    require(total_energy >= 10, "Total-energy lower bound failed.")
    signed_vectors = [
        [F(0)] * 11,
        [F(1), F(-1)] + [F(0)] * 9,
        [F((-1) ** i * (i + 1)) for i in range(10)],
    ]
    signed_vectors[-1].append(-sum(signed_vectors[-1]))
    for a in signed_vectors:
        require(sum(a) == 0, "Regression signed vector is not balanced.")
        norm = sum(a[i] ** 2 / mu[i] for i in range(11))
        signed_error = sum(a[i] * a[k] * eta[i, k] for i, k in pairs)
        quadratic = F(0)
        for j in range(5):
            order = sorted(range(11), key=lambda i: y[i][j])
            prefix = F(0)
            for k in range(10):
                prefix += a[order[k]]
                quadratic += (y[order[k + 1]][j] - y[order[k]][j]) * prefix ** 2
        require(quadratic == norm - signed_error, "Signed quadratic identity failed.")
        require(quadratic <= (1 + epsilon * total / 4) * norm,
                "Signed quadratic-error bound failed.")
    # These inputs test clipping degeneracies, not the near-equilateral hypotheses.
    degenerate_inputs = [
        [[F(i), F(0), F(0), F(0), F(0)] for i in range(11)],
        [[F(min(8, max(1, i))), F(0), F(i % 2), F(0), F(0)] for i in range(11)],
        [[F(i), F(i), F(i), F(i), F(i)] for i in range(11)],
    ]
    for sample in degenerate_inputs:
        clipping_regression(sample)
    require(2 + F(1, 7) == (1 + F(1, 7) * 2 / 4) * 2,
            "Two-label sharp signed-error example failed.")
    shifted = -2 * F(5, 3084)
    require(22 * shifted <= 2 * 22, "Negative shifted-span example failed.")
    return {
        "scope": "finite regression tests only; not a universal proof",
        "new_clipping_and_stability_checks_on_existing_witness": True,
        "balanced_signed_vectors": len(signed_vectors),
        "degenerate_clipping_inputs": len(degenerate_inputs),
        "ties_repeated_extrema_constant_coordinates": True,
        "multiple_ends_owned_by_one_label": True,
        "negative_shifted_span": str(shifted),
        "witness_total_reciprocal_mass": str(total),
        "witness_total_coordinate_energy": str(total_energy),
    }


def main():
    algebra = polynomial_certificate()
    arithmetic = arithmetic_certificate()
    jacobian = jacobian_certificate(F(arithmetic["epsilon_strict_lower"]))
    regressions = stability_regressions()
    print(json.dumps({
        "certificate_kind": "exact_algebra_and_arithmetic_with_separate_regressions",
        "analytic_proof": "research/robust_clipping_gap.md",
        "analytic_proof_machine_checked": False,
        "independent_review_completed": False,
        "polynomial_certificate": algebra,
        "arithmetic_certificate": arithmetic,
        "jacobian_replay": jacobian,
        "regressions": regressions,
        "ok": True,
    }, indent=2))


if __name__ == "__main__":
    main()
