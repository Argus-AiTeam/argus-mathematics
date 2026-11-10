#!/usr/bin/env python3
"""Replay all three saved certificates, rejection tests and algebra boundaries.

Run: python3 guide/evidence/full-support-certificate/audit.py
Requires only Sympy. The search scripts additionally require Scipy and Numpy.
Output is JSON evidence; no optimization or network connection is needed.
"""

import json

import sympy as sp

from verify import (
    HERE, K, L, R, b, build, j, negative_tests, rational, require,
    v, verify, verify_jet_rules, verify_source, z,
)


def boundaries(certificate):
    p = {key: rational(value) for key, value in certificate["parameters"].items()}
    d = {key: rational(value) for key, value in certificate["directions"].items()}
    W = build(p, d)[3]
    witness = json.loads((HERE/"boundary.json").read_text())
    variables = (R, K, v, b, j, z, L)
    require(witness["variable_order"] == [str(x) for x in variables], "Bad point order")
    results = []
    for point in witness["points"]:
        require(len(point["values"]) == len(variables), "Bad point dimension")
        values = dict(zip(variables, map(rational, point["values"])))
        signs = [values[x] for x in (R, K, v, j, L)]
        signs.extend([values[b]-2*values[v],
                      values[z]+values[b]*values[v]-2*values[R]*values[b]])
        admissible = all(value >= 0 for value in signs)
        require(admissible == point["expected_admissible_signs"], "Bad shape-sign verdict")
        raw = (z**2-12*R*v*b**2+6*v**4).subs(values)
        require(raw == rational(point["raw_curvature"]), "Bad raw curvature witness")
        divergence = sp.expand(W).subs(values)
        results.append({
            "name": point["name"], "shape_signs": admissible,
            "raw_curvature": str(raw), "W_F": str(divergence),
        })
    require(rational(results[0]["raw_curvature"]) < 0, "Pointwise counterexample lost")
    require(rational(results[0]["W_F"]) != 0, "Not an integrated witness")
    return results


def main():
    result = {"jet_rules": verify_jet_rules(), "certificates": {}}
    data = {}
    for name in ("baseline", "improved", "nonlinear"):
        data[name] = json.loads((HERE/f"{name}.json").read_text())
        checked = verify(data[name])
        checked["source_blobs_checked"] = verify_source(data[name])
        checked["negative_tests_rejected"] = negative_tests(data[name])
        result["certificates"][name] = checked
    baseline = rational(data["baseline"]["coercivity"])
    strengthened = rational(data["nonlinear"]["coercivity"])
    require(strengthened > sp.Rational(9, 1000) > baseline, "No genuine improvement")
    result["comparison"] = {
        "published_coefficient": str(baseline),
        "strengthened_coefficient": str(strengthened),
        "strengthened_minus_9_over_1000": str(strengthened-sp.Rational(9, 1000)),
        "ratio_to_published": str(strengthened/baseline),
        "ratio_decimal_for_orientation_only": float(strengthened/baseline),
        "minimum_strengthened_remainder_coefficient": str(min(
            rational(row["coefficient"]) for row in data["nonlinear"]["remainder"])),
        "claim": "stronger sufficient certificate; no PDE-sharpness claim",
    }
    result["boundary_points"] = boundaries(data["nonlinear"])
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
