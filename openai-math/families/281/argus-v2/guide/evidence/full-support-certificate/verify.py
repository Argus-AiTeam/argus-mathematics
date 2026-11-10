#!/usr/bin/env python3
"""Rebuild the full-support curvature certificate over Q, including D and L.

Run: python3 guide/evidence/full-support-certificate/verify.py --negative-tests
The default certificate is baseline.json; pass another JSON path to check it.
Requires Sympy. This checks finite algebra, not the analytic PDE hypotheses.
"""

import argparse
import copy
import hashlib
import json
import re
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
R, K, v, b, j, z, L, B = sp.symbols("R K v b j z L B")
VARIABLES = (R, K, v, B, j)
PARAMETERS = ("A", "C", "k", "T0", "g0", "h", "x0", "y", "m", "n0",
              "p0", "p1", "p2", "p3", "p4")
DIRECTIONS = ("d0", "d1", "d2", "d3R", "d3v", "d4v", "d4K", "d4R")


def require(condition, message):
    if not condition:
        raise ValueError(message)


def rational(text):
    require(isinstance(text, str) and re.fullmatch(r"-?\d+(?:/[1-9]\d*)?", text),
            f"Not an exact rational: {text!r}")
    return sp.Rational(text)


def verify_jet_rules():
    r, rv, rw, rz, score, a, ss = sp.symbols("r rv rw rz score a ss")
    jets = (r, rv, rw, score, a)
    next_jets = (rv, rw, rz, a, ss)

    def dx(expression):
        return sum(sp.diff(expression, variable)*derivative
                   for variable, derivative in zip(jets, next_jets))

    values = {R: r**2, K: r*score, v: rv, b: -rw/r,
              j: a-score*rv/r, z: rz, L: -r*ss}
    rules = (2*R*v, 2*v*K+R*j, -R*b, -z-b*v, -j*v+K*b-L)
    for variable, rule in zip((R, K, v, b, j), rules):
        require(sp.cancel(r*dx(values[variable])-rule.subs(values, simultaneous=True)) == 0,
                f"Incorrect jet derivative: {variable}")
    H = rw/(2*r)+rv
    require(sp.cancel((b-2*v).subs(values, simultaneous=True)+2*H) == 0,
            "Incorrect H/B relation")
    require(sp.cancel((z+b*v-2*R*b).subs(values, simultaneous=True)-2*r*dx(H)) == 0,
            "Incorrect H_x/S relation")
    require(sp.cancel((R*b**2).subs(values, simultaneous=True)-rw**2) == 0,
            "Incorrect w^2 substitution")
    return "D-rules, B=-2H, S=2rH_x and Rb^2=w^2 derived from jets"


def build(p, d, *, l_sign=-1, s_sign=-1):
    Q = p["A"]*v*b + p["C"]*v**2 + p["k"]*K*v - 2*p["k"]*R*b + p["T0"]*R*v
    T = p["g0"]*R*v + p["h"]*j*v
    F = ((p["A"]*v-2*p["k"]*R)*b**2
         + b*(2*p["C"]*v**2+2*p["k"]*K*v
              +(p["g0"]+2*p["T0"])*R*v+p["h"]*j*v)
         + p["x0"]*v**2*j+p["y"]*v**3+p["m"]*K*v**2+p["n0"]*R*v**2)
    rules = (2*R*v, 2*v*K+R*j, -R*b, -z-b*v, -j*v+K*b+l_sign*L)
    W = sum(sp.diff(F, variable)*rule
            for variable, rule in zip((R, K, v, b, j), rules))+(v+R-K)*F
    S = z+b*v+s_sign*2*R*b
    squares = (
        R*j*(b-d["d0"]*v)**2,
        R*(b-2*v)*(b-d["d1"]*v)**2,
        K*v*(b-d["d2"]*v)**2,
        v*(b-2*v)*(K+d["d3R"]*R+d["d3v"]*v)**2,
        (v*b+d["d4v"]*v**2+d["d4K"]*K*v+d["d4R"]*R*v)**2,
    )
    correction = L*(p["x0"]*v**2+p["h"]*b*v)
    curvature = z**2-12*R*v*b**2+6*v**4
    residual = sp.expand(curvature-(z+Q)**2-S*T-W-correction
                         -sum(p[f"p{i}"]*term for i, term in enumerate(squares)))
    return Q, T, F, W, correction, residual


def polynomial_table(data):
    table = {}
    for row in data["remainder"]:
        powers = row["powers"]
        require(isinstance(powers, list) and len(powers) == 5
                and all(type(e) is int and e >= 0 for e in powers)
                and sum(powers) == 4, f"Bad monomial: {powers!r}")
        powers = tuple(powers)
        require(powers not in table, f"Duplicate monomial: {powers}")
        coefficient = rational(row["coefficient"])
        require(coefficient > 0, f"Nonpositive remainder: {powers}")
        table[powers] = coefficient
    return table


def linear_slice(baseline):
    names = ("x0", "y", "m", "n0", "p0", "p1", "p2", "p3", "p4")
    unknowns = sp.symbols(" ".join(names))
    p = {key: rational(value) for key, value in baseline["parameters"].items()}
    p.update(zip(names, unknowns))
    d = {key: rational(value) for key, value in baseline["directions"].items()}
    coefficients = sp.Poly(build(p, d)[-1].subs(b, B+2*v), *VARIABLES).as_dict()
    return names, unknowns, coefficients


def verify_dual(data):
    baseline = json.loads((HERE/"baseline.json").read_text())
    names, unknowns, coefficients = linear_slice(baseline)
    require(data["search"]["free_parameters"] == list(names), "Wrong LP slice")
    require(data["directions"] == baseline["directions"], "LP directions changed")
    require(all(data["parameters"][name] == baseline["parameters"][name]
                for name in PARAMETERS if name not in names), "LP fixed parameters changed")
    target = (0, 0, 4, 0, 0)
    expression = coefficients[target]
    seen = set()
    for row in data["search"]["dual"]:
        powers = tuple(row["powers"])
        require(powers in coefficients and powers != target and powers not in seen,
                "Bad or duplicate dual monomial")
        seen.add(powers)
        weight = rational(row["multiplier"])
        require(weight > 0, "Nonpositive dual multiplier")
        expression += weight*coefficients[powers]
    upper = rational(data["search"]["exact_upper_bound"])
    require(sp.expand(expression-upper) == 0, "Dual does not give a constant upper bound")
    require(upper == rational(data["coercivity"]), "LP primal/dual gap")
    require(not expression.expand().has(*unknowns), "Uncancelled LP variable")
    return str(upper)


def verify(data, *, l_sign=-1, s_sign=-1, b_shift=2):
    require(data["source_commit"] == "4eaee87548250b2682affda7d05d947c05554bae",
            "Wrong source commit")
    require(data["variable_order"] == [str(x) for x in VARIABLES], "Wrong variable order")
    require(set(data["parameters"]) == set(PARAMETERS), "Wrong parameter names")
    require(set(data["directions"]) == set(DIRECTIONS), "Wrong square directions")
    p = {key: rational(value) for key, value in data["parameters"].items()}
    d = {key: rational(value) for key, value in data["directions"].items()}
    for key in ("g0", "h", "x0", "p0", "p1", "p2", "p3", "p4"):
        require(p[key] >= 0, f"Negative multiplier: {key}")
    Q, T, F, W, correction, residual = build(p, d, l_sign=l_sign, s_sign=s_sign)
    require(sp.expand(sp.diff(F, b)-2*Q-T) == 0, "F_b != 2Q+T")
    require(sp.expand(sp.diff(F, j)-(p["x0"]*v**2+p["h"]*b*v)) == 0,
            "Incorrect j derivative")
    W0 = W.subs(L, 0)
    require(sp.expand(W-W0+correction) == 0, "Incorrect L correction")
    require(not residual.has(z, L), "Uncancelled z or L")
    expanded = sp.Poly(residual.subs(b, B+b_shift*v), *VARIABLES, domain=sp.QQ)
    table = polynomial_table(data)
    require(expanded.as_dict() == table,
            f"Remainder mismatch: {sp.expand(expanded.as_expr()-sum(c*sp.prod(x**e for x,e in zip(VARIABLES,m)) for m,c in table.items()))}")
    coercivity = rational(data["coercivity"])
    require(coercivity > 0 and table.get((0, 0, 4, 0, 0), 0) >= coercivity,
            "Unsupported coercivity")
    result = {
        "identity": "exact over Q",
        "nonzero_remainder_terms": len(table),
        "coercivity": str(coercivity),
        "all_unlisted_coefficients": "zero",
        "D_F_and_L_correction": "verified",
        "B_and_S_substitutions": "verified",
    }
    if "exact_upper_bound" in data.get("search", {}):
        result["fixed_slice_exact_dual_bound"] = verify_dual(data)
    return result


def verify_source(data):
    directory = (HERE.parents[2]/"paper"
                 /"Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026"
                 /"build")
    for name, expected in data["source_blobs"].items():
        payload = (directory/name).read_bytes()
        actual = hashlib.sha1(f"blob {len(payload)}\0".encode()+payload).hexdigest()
        require(actual == expected, f"Source blob differs: {name}")
    return len(data["source_blobs"])


def negative_tests(data):
    cases = []
    changed = copy.deepcopy(data)
    changed["remainder"][0]["coefficient"] = str(rational(changed["remainder"][0]["coefficient"])+1)
    cases.append(("changed coefficient", changed, {}))
    changed = copy.deepcopy(data)
    changed["remainder"][0]["coefficient"] = "-223/160000"
    cases.append(("negative coefficient", changed, {}))
    changed = copy.deepcopy(data)
    changed["remainder"].pop()
    cases.append(("omitted term", changed, {}))
    changed = copy.deepcopy(data)
    changed["remainder"].append(copy.deepcopy(changed["remainder"][0]))
    cases.append(("duplicate term", changed, {}))
    changed = copy.deepcopy(data)
    changed["parameters"]["m"] = str(-rational(changed["parameters"]["m"]))
    cases.append(("flipped F parameter", changed, {}))
    cases.extend([
        ("wrong D_j L sign", data, {"l_sign": 1}),
        ("wrong S sign", data, {"s_sign": 1}),
        ("wrong B substitution", data, {"b_shift": 1}),
    ])
    changed = copy.deepcopy(data)
    changed["coercivity"] = str(1+rational(data["coercivity"]))
    cases.append(("overclaimed coercivity", changed, {}))
    if "exact_upper_bound" in data.get("search", {}):
        changed = copy.deepcopy(data)
        changed["search"]["dual"][0]["multiplier"] = "1"
        cases.append(("corrupted dual multiplier", changed, {}))
        changed = copy.deepcopy(data)
        changed["search"]["dual"].pop()
        cases.append(("omitted dual term", changed, {}))
    rejected = []
    for name, candidate, options in cases:
        try:
            verify(candidate, **options)
        except ValueError:
            rejected.append(name)
        else:
            raise ValueError(f"Negative test accepted: {name}")
    return rejected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("certificate", nargs="?", type=Path, default=HERE/"baseline.json")
    parser.add_argument("--negative-tests", action="store_true")
    args = parser.parse_args()
    data = json.loads(args.certificate.read_text())
    result = verify(data)
    result["jet_rule_check"] = verify_jet_rules()
    result["source_blobs_checked"] = verify_source(data)
    if args.negative_tests:
        result["negative_tests_rejected"] = negative_tests(data)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
