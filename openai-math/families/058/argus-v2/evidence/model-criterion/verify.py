#!/usr/bin/env python3
"""Recheck finite rational Cayley examples, not the general geometric lemma.

Usage: python3 evidence/model-criterion/verify.py [witness.json] [--self-test]
Requires SymPy. All inputs are integers or rational strings, never floats.
Each case uses C = {y: L*y > 0}; forms are real symmetric matrices M_j
with H_j(z,t) = conjugate(t).T * M_j * z (linear in z).
"""

import argparse
import copy
import json
import re
import sys
from pathlib import Path

import sympy as sp


def require(condition, message):
    if not condition:
        raise ValueError(message)


def rational(value):
    require(
        type(value) is int
        or (
            isinstance(value, str)
            and re.fullmatch(r"-?\d+(?:/[1-9]\d*)?", value) is not None
        ),
        "entries must be exact integers or rational strings",
    )
    return sp.Rational(value)


def matrix(rows, size):
    require(isinstance(rows, list) and len(rows) == size, "wrong matrix height")
    require(
        all(isinstance(row, list) and len(row) == size for row in rows),
        "wrong matrix width",
    )
    return sp.Matrix(size, size, [rational(x) for row in rows for x in row])


def vector(entries):
    require(isinstance(entries, list), "coordinates must be a list")
    require(
        all(isinstance(x, list) and len(x) == 2 for x in entries),
        "complex coordinates must be [real, imaginary] pairs",
    )
    return sp.Matrix(
        len(entries), 1, [rational(x) + sp.I * rational(y) for x, y in entries]
    )


def norm_squared(values):
    return sp.simplify(sum(sp.conjugate(x) * x for x in values))


def verify_case(case):
    z, w = vector(case["z"]), vector(case["w"])
    m, k = len(z), len(w)
    require(k > 0, "at least one normal coordinate is required")
    supports = matrix(case["supports"], k)
    require(supports.det() != 0, "supports must be independent")
    require(len(case["forms"]) == k, "one form per normal coordinate is required")
    forms = [matrix(rows, m) for rows in case["forms"]]
    require(all(form == form.T for form in forms), "forms must be symmetric")
    scalars = [
        sum((supports[a, j] * forms[j] for j in range(k)), sp.zeros(m, m))
        for a in range(k)
    ]
    require(
        m == 0 or all(form.is_positive_semidefinite is True for form in scalars),
        "scalar forms must be positive semidefinite",
    )
    total = sum(scalars, sp.zeros(m, m))
    require(total.rank() == m, "common kernel is nonzero")
    c = rational(case["c"])
    require(c > 0, "c must be positive")
    require(
        m == 0 or (total - c * sp.eye(m)).is_positive_semidefinite is True,
        "claimed lower bound S >= c I is false",
    )

    h = sp.Matrix(
        k, 1, [sp.simplify((sp.conjugate(z).T * form * z)[0]) for form in forms]
    )
    imaginary_w = w.applyfunc(sp.im)
    require(all(x > 0 for x in supports * (imaginary_w - h)), "point is not in C")
    u = supports * w
    require(all(sp.im(x) > 0 for x in u), "Cayley coordinates leave upper half-plane")
    cayley = u.applyfunc(lambda x: sp.simplify((x - sp.I) / (x + sp.I)))
    scaled_z = z / (sum(u) + sp.I)
    require(all(norm_squared([x]) < 1 for x in cayley), "Cayley bound failed")
    require(norm_squared(scaled_z) < 1 / (4 * c), "pooled denominator bound failed")
    recovered_u = cayley.applyfunc(lambda x: sp.simplify(sp.I * (1 + x) / (1 - x)))
    require(
        (supports.inv() * recovered_u - w).applyfunc(sp.simplify) == sp.zeros(k, 1),
        "normal inverse failed",
    )
    require(
        (scaled_z * (sum(recovered_u) + sp.I) - z).applyfunc(sp.simplify)
        == sp.zeros(m, 1),
        "tangential inverse failed",
    )

    mixed = (sp.eye(k) + sp.ones(k)) * supports
    require(mixed.det() == (k + 1) * supports.det(), "support mixing failed")
    require(
        m == 0 or all((form + total).is_positive_definite is True for form in scalars),
        "mixed scalar forms are not positive definite",
    )
    return {
        "name": case["name"],
        "scalar_ranks": [form.rank() for form in scalars],
        "sum_rank": total.rank(),
        "scaled_z_norm_squared": str(norm_squared(scaled_z)),
    }


def verify_boundary_examples():
    t = sp.Symbol("t", real=True)
    z = sp.Matrix([0, t])
    w = sp.Matrix([sp.I, sp.I * (t**2 + 1)])
    old_norm = norm_squared(z / (w[0] + sp.I))
    pooled_norm = norm_squared(z / (sum(w) + sp.I))
    require(sp.simplify(old_norm - t**2 / 4) == 0, "old denominator example failed")
    require(sp.limit(old_norm, t, sp.oo) == sp.oo, "old map should be unbounded")
    require(
        sp.simplify(pooled_norm - t**2 / (t**2 + 3)**2) == 0,
        "pooled denominator example failed",
    )
    v = sp.Matrix([0, 1])
    shared = sp.diag(1, 0)
    require(shared * v == sp.zeros(2, 1), "claimed shared kernel is false")
    require(norm_squared(v) == 1, "line direction must be nonzero")
    require((sp.conjugate(t * v).T * shared * (t * v))[0] == 0, "line test failed")
    epsilon = sp.Symbol("epsilon", positive=True)
    near_extremal_z = sp.Matrix([sp.Rational(3, 5), sp.I * sp.Rational(4, 5)])
    near_extremal_h = sp.Matrix(
        [norm_squared([near_extremal_z[0]]), norm_squared([near_extremal_z[1]])]
    )
    near_extremal_w = sp.I * (near_extremal_h + epsilon * sp.ones(2, 1) / 2)
    near_extremal_norm = norm_squared(
        near_extremal_z / (sum(near_extremal_w) + sp.I)
    )
    require(sp.limit(near_extremal_norm, epsilon, 0) == sp.Rational(1, 4), "sharpness failed")


def rejection_tests(base):
    changes = [
        ("negative scalar form", "scalar forms must be positive semidefinite",
         lambda x: x["forms"][0][0].__setitem__(0, -1)),
        ("shared kernel", "common kernel is nonzero",
         lambda x: x["forms"].__setitem__(1, [[1, 0], [0, 0]])),
        ("dependent supports", "supports must be independent",
         lambda x: x["supports"].__setitem__(1, [1, 0])),
        ("boundary point", "point is not in C",
         lambda x: x["w"][0].__setitem__(1, "9/25")),
        ("false coercivity", "claimed lower bound S >= c I is false",
         lambda x: x.__setitem__("c", 2)),
        ("floating-point entry", "entries must be exact integers or rational strings",
         lambda x: x["forms"][0][0].__setitem__(0, 1.0)),
        ("wrong matrix size", "wrong matrix width",
         lambda x: x["supports"][0].append(0)),
    ]
    for name, message, mutate in changes:
        broken = copy.deepcopy(base)
        mutate(broken)
        try:
            verify_case(broken)
        except ValueError as error:
            require(str(error) == message, f"{name}: rejected for the wrong reason: {error}")
        else:
            raise ValueError(f"{name}: bad input was accepted")
    return len(changes)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("witness", nargs="?", type=Path, default=Path(__file__).with_name("witness.json"))
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    try:
        data = json.loads(args.witness.read_text())
        require(isinstance(data["cases"], list) and data["cases"], "no cases supplied")
        results = [verify_case(case) for case in data["cases"]]
        verify_boundary_examples()
        rejected = rejection_tests(data["cases"][0]) if args.self_test else 0
    except (OSError, ValueError, KeyError, TypeError) as error:
        print(f"REJECTED: {error}", file=sys.stderr)
        return 2
    print(json.dumps({"checked": results, "rejected_mutations": rejected}, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
