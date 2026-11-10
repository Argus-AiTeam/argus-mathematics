#!/usr/bin/env python3
"""Check the two packing examples over Q; this does not certify their geometry."""

import argparse
from copy import deepcopy
from fractions import Fraction
import json
from pathlib import Path


class Rejected(ValueError):
    pass


def require(condition, reason):
    if not condition:
        raise Rejected(reason)


def independent(vectors):
    rows = []
    pivots = []
    for vector in vectors:
        row = list(map(Fraction, vector))
        for pivot, previous in zip(pivots, rows):
            coefficient = row[pivot]
            row = [a - coefficient * b for a, b in zip(row, previous)]
        pivot = next((i for i, value in enumerate(row) if value), None)
        if pivot is not None:
            coefficient = row[pivot]
            rows.append(tuple(value / coefficient for value in row))
            pivots.append(pivot)
    return rows


def check(model):
    names = model["basis"]
    n = len(names)
    require(len(set(names)) == n, "duplicate basis name")
    index = {name: i for i, name in enumerate(names)}
    zero = (Fraction(0),) * n
    basis = [tuple(Fraction(i == j) for j in range(n)) for i in range(n)]
    table = {}
    for left, right, coefficients in model["brackets"]:
        i, j = index[left], index[right]
        require(i != j and (i, j) not in table, "duplicate or diagonal bracket")
        vector = tuple(Fraction(coefficients.get(name, 0)) for name in names)
        require(set(coefficients) <= set(names), "unknown bracket coordinate")
        table[i, j] = vector
        table[j, i] = tuple(-value for value in vector)

    def bracket(left, right):
        answer = [Fraction(0)] * n
        for i, a in enumerate(left):
            for j, b in enumerate(right):
                if a and b:
                    for k, c in enumerate(table.get((i, j), zero)):
                        answer[k] += a * b * c
        return tuple(answer)

    def span_equal(left, right):
        return len(independent(left)) == len(independent(right)) == len(
            independent([*left, *right])
        )

    for x in basis:
        for y in basis:
            for z in basis:
                summands = (
                    bracket(x, bracket(y, z)),
                    bracket(y, bracket(z, x)),
                    bracket(z, bracket(x, y)),
                )
                require(
                    all(sum(v[i] for v in summands) == 0 for i in range(n)),
                    "Jacobi identity",
                )

    # This supplied order triangularizes every adjoint matrix, not just ad(T).
    for x in basis:
        for column, y in enumerate(basis):
            require(
                all(value == 0 for value in bracket(x, y)[column + 1 :]),
                "adjoint matrices not simultaneously upper triangular",
            )
    characters = [tuple(bracket(x, basis[i])[i] for x in basis) for i in range(n)]
    require(
        all(sum(character[j] for character in characters) == 0 for j in range(n)),
        "unimodularity",
    )
    kernel = [basis[index[name]] for name in model["kernel"]]
    require(
        all(
            sum(a * b for a, b in zip(character, x)) == 0
            for character in characters
            for x in kernel
        )
        and len(independent(kernel)) == n - len(independent(characters)),
        "canonical kernel does not equal the common character kernel",
    )
    require(
        span_equal(kernel, [*kernel, *(bracket(x, y) for x in basis for y in kernel)]),
        "kernel not an ideal",
    )

    dimensions = []
    current = independent(kernel)
    for _ in range(n + 1):
        dimensions.append(len(current))
        if not current:
            break
        current = independent(bracket(x, y) for x in kernel for y in current)
    require(dimensions[-1] == 0, "kernel lower central series does not vanish")
    degree = sum(
        j * (dimensions[j - 1] - dimensions[j]) for j in range(1, len(dimensions))
    )
    require(dimensions == model["lower_central_dimensions"], "lower central dimensions")
    require(degree == model["homogeneous_dimension"], "homogeneous dimension")

    cartan_indices = {index[name] for name in model["cartan"]}
    cartan = [basis[i] for i in sorted(cartan_indices)]
    require(
        all(bracket(x, y) == zero for x in cartan for y in cartan),
        "displayed Cartan subalgebra not abelian",
    )
    normalizer_equations = [
        tuple(bracket(x, d)[j] for x in basis)
        for d in cartan
        for j in range(n)
        if j not in cartan_indices
    ]
    require(
        n - len(independent(normalizer_equations)) == len(cartan),
        "displayed Cartan subalgebra not self-normalizing",
    )
    generators = []
    for i, x in enumerate(basis):
        weights = []
        for d in cartan:
            value = bracket(d, x)
            require(
                all(value[j] == 0 for j in range(n) if j != i),
                "example is not diagonal on the displayed Cartan subalgebra",
            )
            weights.append(value[i])
        if any(weights):
            generators.append(x)
    generated = independent(generators)
    while True:
        enlarged = independent(
            [*generated, *(bracket(x, y) for x in generated for y in generated)]
        )
        if len(enlarged) == len(generated):
            break
        generated = enlarged
    expected_n = [basis[index[name]] for name in model["nonzero_weight_generated"]]
    require(span_equal(generated, expected_n), "nonzero-weight-generated algebra")
    actual_overlap = [
        basis[i]
        for i in cartan_indices
        if len(independent([*generated, basis[i]])) == len(generated)
    ]
    overlap_dimension = len(generated) + len(cartan) - len(independent([*generated, *cartan]))
    expected_overlap = [basis[index[name]] for name in model["overlap"]]
    require(
        len(actual_overlap) == overlap_dimension
        and span_equal(actual_overlap, expected_overlap),
        "N intersect D",
    )
    return {
        "name": model["name"],
        "kernel": model["kernel"],
        "lower_central_dimensions": dimensions,
        "Q": degree,
        "N_intersect_D": model["overlap"],
    }


def self_test(models):
    cases = []
    wrong_degree = deepcopy(models[1])
    wrong_degree["homogeneous_dimension"] = 3
    cases.append(("wrong degree 3 instead of 4", wrong_degree))
    wrong_kernel = deepcopy(models[0])
    wrong_kernel["kernel"] = ["X", "Y", "T"]
    cases.append(("height direction incorrectly in kernel", wrong_kernel))
    wrong_jacobi = deepcopy(models[1])
    wrong_jacobi["brackets"].append(["T", "Z", {"Z": 1}])
    cases.append(("noncentral Z violates Jacobi", wrong_jacobi))
    wrong_n = deepcopy(models[1])
    wrong_n["nonzero_weight_generated"] = ["X", "Y"]
    cases.append(("omitted bracket-generated Z", wrong_n))
    wrong_cartan = deepcopy(models[1])
    wrong_cartan["cartan"] = ["T"]
    cases.append(("omitted zero-weight Cartan direction Z", wrong_cartan))
    wrong_overlap = deepcopy(models[1])
    wrong_overlap["overlap"] = []
    cases.append(("incorrectly disjoint N and D", wrong_overlap))
    results = []
    for label, model in cases:
        try:
            check(model)
        except Rejected as error:
            results.append({"negative_control": label, "rejected_by": str(error)})
        else:
            raise RuntimeError(f"checker accepted negative control: {label}")
    return results


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("models", nargs="?", type=Path, default=Path(__file__).with_name("models.json"))
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    models = json.loads(args.models.read_text())
    output = {"checked": [check(model) for model in models]}
    if args.self_test:
        output["negative_controls"] = self_test(models)
    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()
