#!/usr/bin/env python3
"""Replay a universal interval proof, not a sampling test or the author runner."""

import argparse
from fractions import Fraction as Q
import json
from pathlib import Path
import re
import subprocess
import tempfile
import time

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
MANUSCRIPT = (
    "research/openai_manuscript/"
    "Hellinger-contraction-with-arbitrary-Boolean-output-bias-September-24-2026"
)
ROWS = [
    [0, 70, 0, 36, 940, -440, 300, 960, 1000, 956],
    [70, 160, 35, 81, 940, -440, 300, 930, 1050, 953],
    [160, 300, 80, 152, 886, -398, 250, 860, 1150, 985],
    [300, 490, 151, 254, 842, -335, 180, 770, 1150, 1024],
    [490, 630, 253, 335, 842, -335, 180, 690, 1150, 1058],
    [630, 750, 334, 412, 842, -335, 180, 632, 1160, 1087],
    [750, 840, 411, 479, 842, -335, 180, 583, 1160, 1111],
]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def algebra():
    checked = []

    def zero(name, expression):
        require(sp.cancel(expression) == 0, f"False symbolic identity: {name}")
        checked.append(name)

    d, z, g0, gd, ge, g1, L = sp.symbols("delta z g0 gd ge g1 L")
    dd0 = ((g1 - gd) / ((1 - d) * z) - (gd - g0) / (d * z)) / z
    dd1 = ((g1 - ge) / (d * z) - (ge - g0) / ((1 - d) * z)) / z
    K = -(dd0 + dd1) / 8
    D = (gd + ge - g0 - g1) / 2
    zero("D=4*delta*(1-delta)*z^2*K", D - 4 * d * (1 - d) * z**2 * K)
    W = 1 - (g1 - g0) / (4 * L * z)
    zero("shear=z*W", z - (g1 - g0) / (4 * L) - z * W)

    y, q, U, V = sp.symbols("y q U V")
    h = 2 * q * y
    lam = L + U * h + V * h**2
    den = 1 + h * lam
    N = 4 * q * (y + q * lam) / den
    R = 4 * q**2 * (q + y * lam) / den
    M = 4 * (
        L * y + q * (
            2 * L**2 - 1 - 2 * U * q**2
            + h * (2 * L * U - 2 * V * q**2 + 2 * L * V * h)
        )
    ) / den
    gleft = h * (den + 2 * y**2 - 1) / den
    gright = h * (den + 1 - 2 * y**2) / den
    for name, expr in [
        ("G(y^2)=y^2*N(y)", gleft - y**2 * N),
        ("G(y^2)=4*L*y^2-y^3*M(y)", gleft - 4 * L * y**2 + y**3 * M),
        ("G(1-y^2)=y*R(y)", gright - y * R),
    ]:
        numerator = sp.fraction(sp.cancel(expr))[0]
        remainder = sp.rem(numerator, q**2 + y**2 - 1, q)
        zero(name + " modulo q^2+y^2=1", remainder)

    u, i, a, m0, A, B = sp.symbols("u i a m0 A B")
    m = m0 + (a - u) * A + (a - u) * (a - i) * B
    mi, m2 = m.subs(a, i), m.subs(a, 1)
    m02, m12, m012 = A + (1 - i) * B, A + (1 - u) * B, B
    E = u**2 / (u + i)
    F1 = (1 + u**2 / (1 + u)) * m2 + u**3 * m02 / (1 + u)
    P1 = (
        (1 - E / (1 + u)) * m2 + (i + E) * m12
        + E * u * (m012 - m02 / (1 + u))
    ) / (1 + i)
    F2 = (m2 + u * m02) / (1 + u)

    def second(power):
        return (
            (m2 - i**power * mi) / (1 - i**2)
            - (i**power * mi - u**power * m0) / (i**2 - u**2)
        ) / (1 - u**2)

    zero("Case1 endpoint first difference", F1 - (m2 - u**3 * m0) / (1 - u**2))
    zero("Case1 endpoint second difference", P1 - second(3))
    zero("Case2 endpoint first difference", F2 - (m2 - u * m0) / (1 - u**2))
    zero("Case2 scaled negative second difference",
         (F2 - m12 - u * m012) / (1 + i) + (u + i) * second(1))

    j = sp.symbols("j")
    dc = j * (2 * u + (1 - u) * j)
    delta = dc / (1 + u)
    w = u + (1 - u) * j
    t2 = 1 - (1 - u) * dc
    zero("endpoint delta parametrization", delta - j**2 - 2 * u * j * (1 - j) / (1 + u))
    zero("w^2=u^2+delta*(1-u^2)", w**2 - u**2 - delta * (1 - u**2))
    zero("t^2=1-delta*(1-u^2)", t2 - 1 + delta * (1 - u**2))
    zero("Case1 noise factor", 4 * delta * (1 - delta) * (1 - u**2)**2
         - 4 * dc * (1 - u) * (1 - w**2))

    v, Z, F, S0, S1, Lambda, mu, s2 = sp.symbols("v Z F S0 S1 Lambda mu s2")
    delta1 = (Z / v) * (v**2 * S0 + Lambda * s2 * v**3 * (1 - u**2)**2 * Z) \
        - mu * (v * F / (4 * L))**2
    zero("Case1 expression=Delta/v", delta1 / v - (
        Z * S0 + Lambda * s2 * v * (1 - u**2)**2 * Z**2 - mu * v * F**2 / (4 * L)**2
    ))
    ww = sp.symbols("w")
    delta2 = Z / (v**3 * (u + ww)) * v * S1 - mu * (1 + F / (4 * L * v))**2
    zero("Case2 expression=v^2*(u+w)*Delta",
         v**2 * (u + ww) * delta2 - (Z * S1 - mu * (u + ww) * (v + F / (4 * L))**2))

    l, lp, up_, n0, n2, r0, r2 = sp.symbols("l lp up n0 n2 r0 r2")
    P = n2 + l**2 / (l + lp) * (n2 - n0) / (lp - l)
    Qr = r2 + u * (r2 - r0) / (up_ - u)
    zero("Case3 lower increment", (lp**2 - l**2) * P - (lp**2 * n2 - l**2 * n0))
    zero("Case3 upper increment", (up_ - u) * Qr - (up_ * r2 - u * r0))
    alpha, PP, QQ, RR = sp.symbols("alpha P Q R")
    bracket1 = alpha * RR / 2 + Lambda * (up_ - u) * PP / 2
    bracket2 = Lambda * QQ / 2 + Lambda * (up_ - u) * PP / 2
    combination = (2 * u * bracket1 + (up_ - u) * bracket2) / (u + up_)
    zero("Case3 positive convex combination", combination - (
        alpha * u * RR + Lambda * (up_ - u) * QQ / 2
        + Lambda * (up_**2 - u**2) * PP / 2
    ) / (u + up_))
    return checked


def parameters():
    source = (ROOT / MANUSCRIPT / "build/sections/induction.tex").read_text()
    table = source.split(r"\begin{tabular}", 1)[1].split(r"\end{tabular}", 1)[0]
    found = re.findall(r"^([0-6])\s*&(.+?)\\\\\s*$", table, re.MULTILINE)
    parsed = [[int(x.strip().replace("$", "")) for x in tail.split("&")]
              for _, tail in found]
    require(parsed == ROWS, "Manuscript table and audited rows differ")
    cpp = (HERE / "interval_verify.cpp").read_text()
    embedded = cpp.split("constexpr std::array<Row, 7> rows = {{", 1)[1].split("}};", 1)[0]
    cpp_rows = [[int(x) for x in entry.split(",")] for entry in re.findall(r"\{([^{}]+)\}", embedded)]
    require(cpp_rows == ROWS, "C++ constants and audited rows differ")
    for index, row in enumerate(ROWS):
        slo, shi, rlo, rhi, L, U, V, alpha, Lambda, mu = [Q(x, 1000) for x in row]
        require(0 <= rlo <= rhi < Q(1, 2), f"Invalid radius row {index}")
        require(4 * rlo**2 * (1 - rlo**2) <= slo**2, f"Lower noise row {index}")
        require(4 * rhi**2 * (1 - rhi**2) >= shi**2, f"Upper noise row {index}")
        require(U < 0 < V and L + U >= Q(488, 1000), f"Denominator row {index}")
        require(0 < alpha < 1 and Lambda > 0 and mu > 0, f"Sign row {index}")
        require(Q(9, 25) + rhi**2 < Q(16, 25), f"Smooth profile radius row {index}")
        if index:
            require(ROWS[index - 1][1] == row[0], "Noise intervals leave a gap")
    require(ROWS[0][0] == 0 and ROWS[-1][1] == 840, "Wrong noise coverage")
    return {"rows_thousandths": ROWS, "noise_bounds_exact": True, "positive_denominators": True}


def jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    result = json.loads((HERE / "jacobian_result.json").read_text())
    require(result["request"]["payload"] == payload, "Jacobian source mismatch")
    require(result["result"]["operation_id"] == "polynomial.box.enclosure.compute",
            "Wrong Jacobian operation")
    output = result["result"]["output"]
    require(output["polynomial"] == payload["polynomial"] and output["box"] == payload["box"],
            "Jacobian retained source mismatch")
    enclosure = output["enclosure"]
    rational = lambda x: Q(int(x["num"]), int(x["den"]))
    require(rational(enclosure["lower"]) == Q(7, 25) and rational(enclosure["upper"]) == 1,
            "Unexpected Case 3 gap enclosure")
    require(1 - 2 * Q(3, 5)**2 == Q(7, 25), "Case 3 enclosure replay failed")
    return {"operation_id": result["result"]["operation_id"], "server": result["server"]["version"],
            "protocol": result["protocol_version"], "adapter_status": "success",
            "enclosure": enclosure}


def intervals(cxx):
    results = []
    with tempfile.TemporaryDirectory(prefix="pair-check-", dir=HERE) as temporary:
        executable = Path(temporary) / "interval_verify"
        subprocess.run(
            [cxx, "-std=c++17", "-O3", "-Wall", "-Wextra", "-Werror",
             str(HERE / "interval_verify.cpp"), "-o", str(executable)], check=True,
        )
        for row in range(7):
            for region in range(1, 4):
                start = time.monotonic()
                completed = subprocess.run(
                    [str(executable), str(row), str(region)], check=True,
                    text=True, stdout=subprocess.PIPE,
                )
                result = json.loads(completed.stdout)
                require(result["row"] == row and result["region"] == region,
                        "Interval checker returned the wrong region")
                require(result["failed_leaves"] == 0 and result["minimum_margin_scaled"] > 0,
                        "Incomplete strict interval proof")
                require(result["visited"] == 1 + 8 * result["subdivided"],
                        "Incomplete subdivision tree")
                require(result["visited"] == sum(result[k] for k in [
                    "subdivided", "excluded", "value_leaves", "derivative_leaves"
                ]), "Unaccounted-for subdivision leaf")
                results.append(result)
                print(json.dumps({"completed": result, "elapsed_seconds": round(time.monotonic() - start, 3)}),
                      flush=True)
    return results


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--algebra-only", action="store_true")
    parser.add_argument("--cxx", default="g++")
    args = parser.parse_args()
    certificate = {
        "result_class": "universal_verification_theorem",
        "claim": "C119_PAIR",
        "statement": (
            "For every one of the seven prescribed rows, every 0<s<=0.84 in that row, "
            "rho=sqrt(1-s^2), delta=(1-rho)/2, and 0<=p0<=p1<=1, "
            "D>=0 and D*(S+Lambda*D)>=mu*s^2*(p1-p0-(G(p1)-G(p0))/(4*L))^2. "
            "For p0<p1, D>0 and the second inequality is strict."
        ),
        "independent_review": "required; not self-issued",
        "source_locators": [
            MANUSCRIPT + "/build/sections/induction.tex:lem:scalar(1),ind:eq:G,ind:tab:parameters",
            MANUSCRIPT + "/build/sections/scalar.tex:sc:pair-reduction,sc:interval",
        ],
        "parameters": parameters(),
        "symbolic_identities": algebra(),
        "jacobian": jacobian(),
        "arithmetic": {
            "interval_scale": 10**12,
            "stored_endpoint_bound": 10**18,
            "rounding": "exact integer floor/ceiling; exact integer square roots",
            "coverage": "closed dyadic boxes; exclusion only by exact monotone delta bounds",
            "invalid_arithmetic": "uncertified; subdivision, never acceptance",
        },
        "argument": "PROOF.md",
    }
    if args.algebra_only:
        print(json.dumps({"status": "pass", "algebra_identities": len(certificate["symbolic_identities"]),
                          "parameters": "all seven rows", "jacobian": "exact replay"}))
        return
    certificate["regions"] = intervals(args.cxx)
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        require(json.loads(path.read_text()) == certificate, "Recorded certificate does not replay")
    print(json.dumps({"status": "pass", "theorem": "C119_PAIR", "regions": 21,
                      "independent_review": "pending"}), flush=True)


if __name__ == "__main__":
    main()
