#!/usr/bin/env python3
"""Bounded local discovery search in all 15 original certificate parameters.

Square directions stay fixed. SLSQP output is not evidence: only an output
passing verify.py is written. Requires Numpy, Scipy and Sympy.
"""

import argparse
import copy
import json
from pathlib import Path

import numpy as np
import sympy as sp
from scipy.optimize import minimize

from verify import B, HERE, PARAMETERS, VARIABLES, b, build, rational, v, verify


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    baseline = json.loads((HERE/"baseline.json").read_text())
    start = json.loads((HERE/"improved.json").read_text())
    unknowns = sp.symbols(" ".join(PARAMETERS))
    p = dict(zip(PARAMETERS, unknowns))
    d = {key: rational(value) for key, value in baseline["directions"].items()}
    polynomial = sp.Poly(build(p, d)[-1].subs(b, B+2*v), *VARIABLES)
    terms = polynomial.as_dict()
    keys = list(terms)
    target_index = keys.index((0, 0, 4, 0, 0))
    coefficients = sp.Matrix([terms[key] for key in keys])
    evaluate = sp.lambdify([unknowns], coefficients, "numpy")
    derivative = sp.lambdify([unknowns], coefficients.jacobian(unknowns), "numpy")
    target = lambda x: float(evaluate(x)[target_index, 0])
    rows = [i for i in range(len(keys)) if i != target_index]
    constraints = {
        "type": "ineq",
        "fun": lambda x: evaluate(x).ravel()[rows],
        "jac": lambda x: derivative(x)[rows, :],
    }
    positive = {"g0", "h", "x0", "p0", "p1", "p2", "p3", "p4"}
    bounds = [(0 if name in positive else -10, 10) for name in PARAMETERS]
    x = np.array([float(rational(start["parameters"][name])) for name in PARAMETERS])
    answer = minimize(
        lambda values: -target(values), x,
        jac=lambda values: -derivative(values)[target_index, :],
        constraints=constraints, bounds=bounds, method="SLSQP",
        options={"maxiter": 1000, "ftol": 1e-12},
    )
    if not answer.success:
        raise RuntimeError(answer.message)
    for denominator in (10000, 100000, 1000000, 10000000):
        rounded = [sp.Rational(round(float(value)*denominator), denominator)
                   for value in answer.x]
        for weight in (sp.Rational(9999, 10000), sp.Rational(999, 1000),
                       sp.Rational(99, 100), sp.Rational(9, 10)):
            result = copy.deepcopy(baseline)
            for name, value in zip(PARAMETERS, rounded):
                mixed = weight*value+(1-weight)*rational(baseline["parameters"][name])
                result["parameters"][name] = str(
                    sp.Rational(round(mixed*denominator), denominator))
            exact_p = {key: rational(value) for key, value in result["parameters"].items()}
            exact = sp.Poly(build(exact_p, d)[-1].subs(b, B+2*v), *VARIABLES, domain=sp.QQ)
            result["remainder"] = [{"powers": list(key), "coefficient": str(value)}
                                   for key, value in exact.terms() if value != 0]
            result["coercivity"] = str(exact.coeff_monomial(v**4))
            if rational(result["coercivity"]) <= rational(start["coercivity"]):
                continue
            try:
                checked = verify(result)
            except ValueError:
                continue
            result["search"] = {
                "method": "one bounded SLSQP run; rational decimal rounding, baseline mixing, decimal rounding",
                "bounds": {name: list(bound) for name, bound in zip(PARAMETERS, bounds)},
                "iterations": answer.nit,
                "floating_candidate": target(answer.x),
                "rounding_denominator": denominator,
                "baseline_mixing_weight": str(1-weight),
                "global_optimality": "not claimed",
            }
            args.output.write_text(json.dumps(result, indent=2)+"\n")
            print(json.dumps({"written": str(args.output), **checked,
                              "parameters": result["parameters"],
                              "search": result["search"]}, indent=2))
            return
    raise RuntimeError("No rounded nonlinear candidate passed exact verification")


if __name__ == "__main__":
    main()
