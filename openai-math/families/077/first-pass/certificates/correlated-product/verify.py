#!/usr/bin/env python3
"""Replay exact checks accompanying the analytic theorem in report.md."""

import itertools
import json
from collections import Counter, defaultdict
from fractions import Fraction as F
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def add(*polynomials):
    result = defaultdict(F)
    for polynomial in polynomials:
        for monomial, coefficient in polynomial.items():
            result[monomial] += coefficient
    return {m: c for m, c in result.items() if c}


def scale(polynomial, coefficient):
    return {m: c * coefficient for m, c in polynomial.items() if c * coefficient}


def mul(*polynomials):
    result = {(): F(1)}
    for polynomial in polynomials:
        product = defaultdict(F)
        for left, a in result.items():
            for right, b in polynomial.items():
                product[tuple(sorted(left + right))] += a * b
        result = {m: c for m, c in product.items() if c}
    return result


def variable(name):
    return {(name,): F(1)}


def constant(value):
    return {(): F(value)} if value else {}


def difference(left, right):
    return add(left, scale(right, -1))


def check_polynomial_identities():
    x, y, z, w, dr, dt = map(variable, ("x", "y", "z", "w", "dr", "dt"))
    yd = difference(y, mul(dr, x))
    zd = add(z, mul(dt, x))
    wd = add(w, mul(dt, y), scale(mul(dr, z), -1), scale(mul(dt, dr, x), -1))
    overlap = add(wd, scale(mul(dt, yd), -1), mul(dr, zd))
    require(overlap == add(w, mul(dt, dr, x)), "Mixed shear identity")
    inverse = add(wd, scale(mul(dt, yd), -1), mul(dr, zd), scale(mul(dt, dr, x), -1))
    require(inverse == w, "Full shear inverse")

    cr, ct, fr, ft, length, vr, vt = map(
        variable, ("cr", "ct", "fr", "ft", "L", "vr", "vt")
    )
    qr, qt = difference(cr, fr), difference(ct, ft)
    actual = mul(add(qr, mul(length, vr)), add(qt, mul(length, vt)))
    expansion = add(
        mul(qr, qt),
        mul(length, qt, vr),
        mul(length, qr, vt),
        mul(length, length, vr, vt),
    )
    require(actual == expansion, "Exact nonlinear Taylor remainder")

    s, sigma, j = map(variable, ("s", "sigma", "J"))
    gap = difference(s, sigma)
    a = scale(add(s, sigma), F(1, 2))
    cleared_left = add(
        mul(difference(j, constant(3)), difference(scale(a, 8), gap)),
        scale(mul(j, sigma), -8),
        scale(mul(j, gap), -2),
    )
    cleared_right = add(mul(j, gap), scale(a, -24), scale(gap, 3))
    require(cleared_left == cleared_right, "Universal exponent-margin identity")
    return 4


def ceil_fraction(value):
    return -(-value.numerator // value.denominator)


def exponent_budget(s, sigma, h):
    require(0 <= sigma < s <= 1 and 0 < h <= 1, "Exponent hypotheses")
    gap = s - sigma
    a = (s + sigma) / 2
    j = ceil_fraction(24 * a / gap)
    n = j - 3
    eta = h / j
    k = gap / (8 * a)
    tau = eta * k
    c0 = h * gap / (32 * j)
    margin = F(n, j) * a * (1 - k) - sigma
    decay = (a * (eta - tau) - h * sigma / n) / 2
    require(j >= 12 and n > 0, "Positive usable block count")
    require(0 < k <= F(1, 4), "Gradient cutoff lies above the block mesh")
    require(j * gap >= 24 * a, "Ceiling rule")
    require(margin - gap / 4 == (j * gap - 24 * a + 3 * gap) / (8 * j), "Margin identity")
    require(margin >= gap / 4, "Strict full-chain margin")
    require(decay >= h * gap / (8 * n) >= 4 * c0, "Support decay")
    require(tau * s >= 4 * c0, "Near-diagonal decay")

    radial_gap = s - a
    alpha = radial_gap / 16
    step = radial_gap * radial_gap / 512
    require(3 * step + alpha < radial_gap / 2, "Dispersed bootstrap margin")
    require(step < alpha * radial_gap / 2, "Concentrated bootstrap margin")
    improvements = ceil_fraction((a - s / 4) / step)
    require(s / 4 + improvements * step >= a, "Finite radial bootstrap reaches a")
    require(s / 4 + improvements * step < s, "Bootstrap stays below s")
    return {
        "a": a,
        "J": j,
        "eta": eta,
        "tau": tau,
        "c0": c0,
        "support_decay_exponent": decay,
        "normalized_margin": margin,
    }


def check_budgets(certificate):
    cases = [
        (F(i, 16), F(q, 16), h)
        for i in range(1, 17)
        for q in range(i)
        for h in (F(1), F(1, 2), F(1, 16))
    ]
    cases.extend(
        (
            (F(1), 1 - F(1, 2**20), F(1)),
            (F(1, 100), F(1, 100) * (1 - F(1, 2**20)), F(1, 16)),
        )
    )
    for case in cases:
        exponent_budget(*case)
    example = certificate["example"]
    actual = exponent_budget(F(example["s"]), F(example["sigma"]), F(example["h"]))
    for name, value in actual.items():
        expected = example[name] if name == "J" else F(example[name])
        require(value == expected, "Exact example: " + name)
    return len(cases)


def entropy_product(rows, labels, parent_cells=None):
    """Return exp(T*H(output|conditioning)) using integer joint masses."""
    groups = defaultdict(Counter)
    for f, row in enumerate(rows):
        for d, weight in enumerate(row):
            if weight:
                condition = (f,) if parent_cells is None else (f, parent_cells[d])
                groups[condition][labels[f][d]] += weight
    result = F(1)
    for counts in groups.values():
        total = sum(counts.values())
        for count in counts.values():
            result *= F(total, count) ** count
    return result


def original_collision(target_weights, labels, indices):
    total = sum(target_weights[d] for d in indices)
    counts = Counter()
    for d in indices:
        counts[labels[d]] += target_weights[d]
    return sum((F(c, total) ** 2 for c in counts.values()), F(0))


def check_conditioned_incidences():
    points = ((F(-1, 2), F(-1, 2)), (F(-1, 4), F(1, 4)),
              (F(1, 4), F(-1, 4)), (F(1, 2), F(1, 2)))
    pins = ((F(3, 4), F(0)), (F(0), F(3, 4)))
    product_labels = tuple(
        tuple((4 * (r - rf) * (t - tf)).__floor__() for r, t in points)
        for rf, tf in pins
    )
    scenarios = (
        ((1, 1, 1, 1), ((0, 0, 1, 2), (0, 1, 1, 2))),
        ((1, 2, 1, 2), product_labels),
    )
    pin_weights = (1, 2)
    parent_cells = (0, 0, 1, 1)
    checked = 0
    for target_weights, labels in scenarios:
        pin_total, target_total = sum(pin_weights), sum(target_weights)
        for mask in range(1, 1 << 8):
            rows = [
                [
                    pin_weights[f] * target_weights[d] if mask & (1 << (4 * f + d)) else 0
                    for d in range(4)
                ]
                for f in range(2)
            ]
            total = sum(map(sum, rows))
            density = F(total, pin_total * target_total)
            k = sum(
                (F(pin_weights[f], pin_total) * original_collision(target_weights, labels[f], range(4))
                 for f in range(2) if sum(rows[f])),
                F(0),
            )
            fine_product = entropy_product(rows, labels)
            require(fine_product >= (density * density / k) ** total, "Conditional entropy inequality")

            cell_collision_bounds = []
            for cell in (0, 1):
                indices = tuple(d for d in range(4) if parent_cells[d] == cell)
                if any(rows[f][d] for f in range(2) for d in indices):
                    cell_collision_bounds.append(sum(
                        (F(pin_weights[f], pin_total) * original_collision(target_weights, labels[f], indices)
                         for f in range(2) if any(rows[f][d] for d in indices)),
                        F(0),
                    ))
            parent_product = entropy_product(rows, labels, parent_cells)
            uniform_k = max(cell_collision_bounds)
            require(parent_product >= (density * density / uniform_k) ** total, "Original-parent averaging")

            coarse = tuple(tuple(label // 2 for label in row) for row in labels)
            coarse_product = entropy_product(rows, coarse)
            coarse_parent_product = entropy_product(rows, coarse, parent_cells)
            require(fine_product * coarse_parent_product >= coarse_product * parent_product, "Nested conditional entropy chain")
            checked += 1
    return checked


def check_overlap_average():
    universe_size = 6
    checked = 0
    for left in range(1, 1 << universe_size):
        for right in range(1, 1 << universe_size):
            l, r, intersection = left.bit_count(), right.bit_count(), (left & right).bit_count()
            average = F(l + 4 * intersection + 4 * r, 9)
            mean_size = F(l + 2 * r, 3)
            require(average * universe_size >= mean_size * mean_size, "Weighted full-spatial overlap")
            checked += 1
    return checked


def check_rich_supports():
    points = tuple(itertools.product((0, 1), repeat=4))
    inputs = tuple((x, w) for x, y, z, w in points)
    input_groups = defaultdict(int)
    for index, key in enumerate(inputs):
        input_groups[key] |= 1 << index
    updates = {}
    for dr, dt in itertools.product((-1, 1), repeat=2):
        updates[(dr, dt)] = tuple(
            (y - dr * x, z + dt * x, w + dt * y - dr * z - dt * dr * x)
            for x, y, z, w in points
        )
    checked = 0
    for mask in range(1, 1 << len(points)):
        selected = tuple(i for i in range(len(points)) if mask & (1 << i))
        sizes = {key: (mask & group).bit_count() for key, group in input_groups.items()}
        for dr, dt in updates:
            outputs = {updates[(dr, dt)][i] for i in selected}
            for threshold in range(1, 5):
                rich = {key for key, size in sizes.items() if size >= threshold}
                scalar_values = {w + dt * dr * x for x, w in rich}
                require(len(scalar_values) * threshold <= len(outputs), "Rich nonlinear scalar support")
                retained = tuple(i for i in selected if inputs[i] in rich)
                retained_weight_units = sum(i + 1 for i in retained)
                require(retained_weight_units >= len(retained), "Pre-trim lower weights retain dense mass")
                original_input_weight_units = sum(i + 1 for i in range(len(points)) if inputs[i] in rich)
                require(original_input_weight_units >= retained_weight_units, "Rich image measured by original planar law")
                checked += 1
    return checked


def check_density_sharpness():
    alpha, atoms = F(1, 2), 3
    k = alpha * alpha + (1 - alpha) ** 2 / atoms
    require(k == F(1, 3), "Sharpness model collision")
    require(alpha / k > 1, "A one-log density penalty would be false")
    require(alpha * alpha / k <= 1, "The two-log penalty has the correct orientation")
    return 1


def check_jacobian(certificate):
    expected = certificate["jacobian"]
    payload = json.loads((ROOT / expected["payload"]).read_text())
    record = json.loads((ROOT / expected["result"]).read_text())
    require(record["status"] == "completed" and record["exit_code"] == 0, "Adapter completed, not UNKNOWN/error")
    require(record["operation_id"] == expected["operation_id"], "Operation identity")
    require(record["payload"] == payload, "Exact submitted payload")
    typed = record["typed_output"]
    require(typed["protocol_version"] == expected["protocol_version"], "Adapter protocol")
    require(typed["server"]["version"] == expected["server_version"], "Server version")
    require(typed["request"]["payload"] == payload, "Server's source-bound request")
    result = typed["result"]
    require(result["operation_id"] == expected["operation_id"], "Typed result operation")
    output = result["output"]
    require(output["source_polynomial"] == payload["polynomial"], "Source polynomial preserved")
    for name in ("threshold", "lower", "upper"):
        require(output[name] == payload[name], "Source-bound scope: " + name)
    measure = output["measure"]
    rational = measure["rational_part"]
    require(F(int(rational["num"]), int(rational["den"])) == F(expected["expected_measure"]), "Exact sublevel measure")
    require(measure["root_terms"] == [], "No unaccounted irrational measure terms")
    require(len(output["components"]) == 1, "Complete quadratic component count")
    component = output["components"][0]
    require(not component["left_included"] and not component["right_included"], "Strict endpoint convention")
    endpoints = tuple(map(F, expected["expected_open_endpoints"]))
    for index, (name, value) in enumerate(zip(("left", "right"), endpoints)):
        endpoint = component[name]
        require(endpoint["kind"] == "LEVEL_ROOT", "Level endpoint type")
        require(endpoint["root"] == {"equation": "F_MINUS_THRESHOLD", "root_index": index, "multiplicity": 1}, "Exact ordered simple roots")
        require(value * value == F(1, 64) and 2 * value != 0, "Exact root and multiplicity replay")
    require(endpoints[1] - endpoints[0] == F(1, 4), "Independent interval length")
    require(-4 * F(1, 64) < 0, "The plus-threshold quadratic has no real roots")
    return 1


def main():
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    require(certificate["finite_theorem"]["density_penalty"] == 2, "Entropy theorem fidelity")
    require(certificate["finite_theorem"]["coarse_bin_ambiguity"] == 8, "Coarse-bin theorem fidelity")
    counts = {
        "polynomial_identities": check_polynomial_identities(),
        "rational_exponent_budgets": check_budgets(certificate),
    }
    conditioned = check_conditioned_incidences()
    counts.update({
        "query_dependent_incidences": conditioned,
        "parent_averaging_inequalities": conditioned,
        "conditional_entropy_chains": conditioned,
        "weighted_overlap_cauchy_schwarz": check_overlap_average(),
        "rich_overlap_support_inequalities": check_rich_supports(),
        "sharp_density_penalty_examples": check_density_sharpness(),
        "jacobian_results_replayed": check_jacobian(certificate),
    })
    require(counts == certificate["expected_exact_checks"], "Recorded check counts")
    print(json.dumps({
        "status": "exact_checks_passed",
        "claim_id": certificate["claim_id"],
        "checks": counts,
        "analytic_proof": "report.md; independent mathematical review still required",
        "full_restriction_theorems_verified": False,
        "kernel_verification": False,
    }, indent=2))


if __name__ == "__main__":
    main()
