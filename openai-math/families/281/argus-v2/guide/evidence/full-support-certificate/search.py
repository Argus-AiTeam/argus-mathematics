#!/usr/bin/env python3
"""Search a bounded finite certificate ansatz; emit an exactly rechecked JSON.

Floating-point linear programming is discovery only. The exact active vertex
and its dual are reconstructed and checked by verify.py without tolerances.
The fixed Q,T and square directions are those of baseline.json. Only x0,y,m,n0
and p0,...,p4 vary. Requires Scipy and Sympy.
"""

import argparse
import copy
import json
from pathlib import Path

import numpy as np
import sympy as sp
from scipy.optimize import linprog

from verify import B, HERE, VARIABLES, b, build, linear_slice, rational, v, verify


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    baseline = json.loads((HERE/"baseline.json").read_text())
    result = copy.deepcopy(baseline)
    names, unknowns, terms = linear_slice(baseline)
    d = {key: rational(value) for key, value in baseline["directions"].items()}
    target = (0, 0, 4, 0, 0)
    constant = {key: coefficient.subs(dict.fromkeys(unknowns, 0))
                for key, coefficient in terms.items()}
    rows = {key: [sp.diff(coefficient, value) for value in unknowns]
            for key, coefficient in terms.items()}
    constraints = [key for key in terms if key != target]
    answer = linprog(
        -np.array(rows[target], dtype=float),
        A_ub=-np.array([rows[key] for key in constraints], dtype=float),
        b_ub=np.array([constant[key] for key in constraints], dtype=float),
        bounds=[(0, None), (None, None), (None, None), (None, None)]+[(0, None)]*5,
        method="highs",
    )
    if not answer.success:
        raise RuntimeError(answer.message)
    active = [key for key, slack in zip(constraints, answer.slack) if abs(slack) < 1e-8]
    matrix = sp.Matrix([rows[key] for key in active])
    rhs = sp.Matrix([-constant[key] for key in active])
    vertex, free = matrix.gauss_jordan_solve(rhs)
    if free.rows:
        raise RuntimeError("The active LP face is not a unique rational vertex")
    for name, value in zip(names, vertex):
        result["parameters"][name] = str(value)
    exact_p = {key: rational(value) for key, value in result["parameters"].items()}
    exact = sp.Poly(build(exact_p, d)[-1].subs(b, B+2*v), *VARIABLES, domain=sp.QQ)
    result["remainder"] = [{"powers": list(key), "coefficient": str(value)}
                           for key, value in exact.terms() if value != 0]
    result["coercivity"] = str(exact.coeff_monomial(v**4))
    dual_keys = [key for key, multiplier in zip(constraints, answer.ineqlin.marginals)
                 if abs(multiplier) > 1e-8]
    dual, free = sp.Matrix([rows[key] for key in dual_keys]).T.gauss_jordan_solve(
        -sp.Matrix(rows[target]))
    if free.rows or any(value < 0 for value in dual):
        raise RuntimeError("Could not reconstruct a nonnegative exact LP dual")
    upper_bound = constant[target]+sum(value*constant[key]
                                       for key, value in zip(dual_keys, dual))
    if upper_bound != exact.coeff_monomial(v**4):
        raise RuntimeError("Primal and dual bounds differ")
    result["search"] = {
        "method": "fixed-Q,T-and-directions LP; exact active vertex and dual reconstruction",
        "free_parameters": list(names),
        "floating_optimum_coercivity": float(-answer.fun+float(constant[target])),
        "exact_upper_bound": str(upper_bound),
        "dual": [{"powers": list(key), "multiplier": str(value)}
                 for key, value in zip(dual_keys, dual)],
    }
    checked = verify(result)
    args.output.write_text(json.dumps(result, indent=2)+"\n")
    print(json.dumps({"written": str(args.output), **checked, "search": result["search"]}, indent=2))


if __name__ == "__main__":
    main()
