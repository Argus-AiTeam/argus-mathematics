#!/usr/bin/env python3
"""Independently expand the certificate from ordinary spatial jets, not D-rules."""

import copy
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
r, v, w, z, s, sx, sxx = sp.symbols("r v w z s sx sxx")
R, K, b, j, L, B = sp.symbols("R K b j L B")


def require(condition, message):
    if not condition:
        raise ValueError(message)


def check(data):
    require(data["source_commit"] == "4eaee87548250b2682affda7d05d947c05554bae",
            "unexpected source commit")
    p = {name: sp.Rational(value) for name, value in data["parameters"].items()}
    d = {name: sp.Rational(value) for name, value in data["directions"].items()}
    q = p["A"]*v*b + p["C"]*v**2 + p["k"]*K*v - 2*p["k"]*R*b + p["T0"]*R*v
    t = v*(p["g0"]*R + p["h"]*j)
    f = ((p["A"]*v - 2*p["k"]*R)*b**2
         + b*(2*p["C"]*v**2 + 2*p["k"]*K*v
              + (p["g0"] + 2*p["T0"])*R*v + p["h"]*j*v)
         + p["x0"]*v**2*j + p["y"]*v**3 + p["m"]*K*v**2 + p["n0"]*R*v**2)
    jets = {R: r**2, K: r*s, b: -w/r, j: sx-s*v/r}
    fj = f.subs(jets, simultaneous=True)
    derivative = sum(sp.diff(fj, a)*da
                     for a, da in ((r, v), (v, w), (w, z), (s, sx), (sx, sxx)))
    divergence = r*derivative + (v+r**2-r*s)*fj
    back = {w: -b*r, s: K/r, sx: j+K*v/r**2, sxx: -L/r}
    divergence = sp.Poly(sp.cancel(divergence.subs(back, simultaneous=True)), r)
    require(all(power[0] % 2 == 0 for power, _ in divergence.terms()),
            "uncancelled odd power of r")
    divergence = sum(coefficient*R**(power[0]//2)
                     for power, coefficient in divergence.terms())
    squares = (
        R*j*(b-d["d0"]*v)**2,
        R*(b-2*v)*(b-d["d1"]*v)**2,
        K*v*(b-d["d2"]*v)**2,
        v*(b-2*v)*(K+d["d3R"]*R+d["d3v"]*v)**2,
        (v*b+d["d4v"]*v**2+d["d4K"]*K*v+d["d4R"]*R*v)**2,
    )
    residual = sp.expand(z**2-12*R*v*b**2+6*v**4
                         - (z+q)**2 - (z+b*v-2*R*b)*t - divergence
                         - L*(p["x0"]*v**2+p["h"]*b*v)
                         - sum(p[f"p{i}"]*term for i, term in enumerate(squares)))
    require(not residual.has(z, L), "uncancelled z or L")
    coefficients = sp.Poly(residual.subs(b, B+2*v), R, K, v, B, j).as_dict()
    expected = {tuple(row["powers"]): sp.Rational(row["coefficient"])
                for row in data["remainder"]}
    require(len(expected) == len(data["remainder"]), "duplicate remainder monomial")
    require(coefficients == expected, "remainder table does not match spatial expansion")
    require(all(c > 0 for c in coefficients.values()), "nonpositive remainder coefficient")
    for name in ("g0", "h", "x0", "p0", "p1", "p2", "p3", "p4"):
        require(p[name] >= 0, f"negative multiplier: {name}")
    kappa = coefficients[(0, 0, 4, 0, 0)]
    require(kappa == sp.Rational(data["coercivity"]), "unsupported coercivity")
    return {"terms": len(coefficients), "coercivity": str(kappa)}


def main():
    results = {}
    for name in ("baseline", "improved", "nonlinear"):
        data = json.loads((HERE / f"{name}.json").read_text())
        results[name] = check(data)
        broken = copy.deepcopy(data)
        broken["parameters"]["h"] = str(-sp.Rational(broken["parameters"]["h"]))
        try:
            check(broken)
        except ValueError:
            results[name]["flipped_score_coefficient_rejected"] = True
        else:
            raise ValueError("corrupted score coefficient accepted")
    print(json.dumps({
        "method": "ordinary total x derivative of F(r^2,rs,v,-w/r,sx-sv/r)",
        "certificates": results,
        "scope": "exact finite identity only; density, tails and PDE limits checked by hand",
    }, indent=2))


if __name__ == "__main__":
    main()
