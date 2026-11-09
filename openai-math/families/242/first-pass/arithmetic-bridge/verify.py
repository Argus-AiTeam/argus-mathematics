#!/usr/bin/env python3
"""Replay the exact arithmetic diagnostics and the real Lean certificate."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import subprocess
from collections import Counter
from fractions import Fraction as Q
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
BUILD = (
    ROOT
    / "research/openai_manuscript"
    / "Single-fold-Diophantine-representations-September-24-2026/build"
)
SLOPE_CASES = (2, 3, 5, 6)
ZERO_LOCAL = (0,) * 7
Point = tuple[Q, Q] | None
Code = tuple[int, ...]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def code(x: Q) -> Code:
    a, d = abs(x.numerator), x.denominator
    t = pow(a, -1, d) if d > 1 else 0
    return (
        max(x.numerator, 0),
        max(-x.numerator, 0),
        d,
        t,
        d - 1 - t,
        (a * t + d - 1) // d,
    )


def valid_code(z: Code) -> bool:
    if len(z) != 6 or any(v < 0 for v in z):
        return False
    p, n, d, t, s, q = z
    return p * n == 0 and d == 1 + t + s and (p + n) * t + d == 1 + q * d


def value(z: Code) -> Q:
    require(valid_code(z), "attempted to decode an invalid active rational code")
    return Q(z[0] - z[1], z[2])


def point_code(p: Point) -> Code:
    x, y = p if p is not None else (Q(0), Q(0))
    return (int(p is None), *code(x), *code(y))


def on_curve(p: Point) -> bool:
    return p is None or p[1] ** 2 == p[0] ** 3 - 25 * p[0]


def represents(z: Code, p: Point) -> bool:
    if len(z) != 13 or not valid_code(z[1:7]) or not valid_code(z[7:13]):
        return False
    x, y = p if p is not None else (Q(0), Q(0))
    return z[0] == int(p is None) and value(z[1:7]) == x and value(z[7:13]) == y


def guards(p: Point, q: Point) -> tuple[bool, ...]:
    if p is None:
        return (True, False, False, False, False, False, False)
    if q is None:
        return (False, True, False, False, False, False, False)
    x, y = p
    X, Y = q
    return (
        False,
        False,
        x < X,
        X < x,
        x == X and y + Y == 0,
        x == X and y == Y and y > 0,
        x == X and y == Y and y < 0,
    )


def slope(p: tuple[Q, Q], q: tuple[Q, Q], case: int) -> Q:
    x, y = p
    X, Y = q
    return (Y - y) / (X - x) if case in (2, 3) else (3 * x * x - 25) / (2 * y)


def add(p: Point, q: Point) -> Point:
    require(on_curve(p) and on_curve(q), "addition inputs must lie on E")
    active = [i for i, g in enumerate(guards(p, q)) if g]
    require(len(active) == 1, "the seven addition guards did not partition")
    i = active[0]
    if i == 0:
        return q
    if i == 1:
        return p
    if i == 4:
        return None
    require(p is not None and q is not None, "affine branch had an identity input")
    l = slope(p, q, i)
    x = l * l - p[0] - q[0]
    result = (x, l * (p[0] - x) - p[1])
    require(on_curve(result), "the chord--tangent output left the curve")
    return result


def cross(x: Q, y: Q) -> int:
    return x.numerator * y.denominator - y.numerator * x.denominator


def guard_gap(p: tuple[Q, Q], q: tuple[Q, Q], case: int) -> int:
    if case == 2:
        return cross(q[0], p[0])
    if case == 3:
        return cross(p[0], q[0])
    return p[1].numerator if case == 5 else -p[1].numerator


def addition_witness(p: Point, q: Point) -> Code:
    active = guards(p, q).index(True)
    z = [*point_code(add(p, q)), *(int(i == active) for i in range(7))]
    for i in SLOPE_CASES:
        if i == active:
            require(p is not None and q is not None, "missing affine inputs")
            z.extend((*code(slope(p, q, i)), guard_gap(p, q, i) - 1))
        else:
            z.extend(ZERO_LOCAL)
    require(len(z) == 48, "addition tuple omitted or duplicated a coordinate")
    return tuple(z)


def addition_valid(p: Point, q: Point, z: Code) -> bool:
    if len(z) != 48 or any(v < 0 for v in z) or not on_curve(p) or not on_curve(q):
        return False
    selectors = z[13:20]
    if any(e * (e - 1) != 0 for e in selectors) or sum(selectors) != 1:
        return False
    i = selectors.index(1)
    if not guards(p, q)[i]:
        return False
    for j, branch in enumerate(SLOPE_CASES):
        local = z[20 + 7 * j : 27 + 7 * j]
        if branch != i:
            if local != ZERO_LOCAL:
                return False
            continue
        if p is None or q is None or not valid_code(local[:6]):
            return False
        l = value(local[:6])
        if guard_gap(p, q, i) != 1 + local[6]:
            return False
        if i in (2, 3):
            if l * (q[0] - p[0]) != q[1] - p[1]:
                return False
        elif 2 * p[1] * l != 3 * p[0] ** 2 - 25:
            return False
        x = l**2 - p[0] - q[0]
        if not represents(z[:13], (x, l * (p[0] - x) - p[1])):
            return False
    if i == 0:
        return represents(z[:13], q)
    if i == 1:
        return represents(z[:13], p)
    if i == 4:
        return represents(z[:13], None)
    return True


def rational_diagnostics() -> dict:
    fractions = {Q(a, d) for a in range(-12, 13) for d in range(1, 13)}
    for x in fractions:
        z = code(x)
        require(valid_code(z) and value(z) == x, f"rational-code failure at {x}")
        for i in range(6):
            for change in (-1, 1):
                w = tuple(v + change if j == i else v for j, v in enumerate(z))
                require(
                    not valid_code(w) or value(w) != x,
                    f"second code survived a coordinate perturbation at {x}",
                )
    require(code(Q(0)) == (0, 0, 1, 0, 0, 0), "zero code mismatch")
    require(code(Q(-3)) == (0, 3, 1, 0, 0, 0), "denominator-one boundary mismatch")
    require(not valid_code((0,) * 6), "inactive zero tuple was treated as globally valid")
    return {"distinct_fractions": len(fractions), "numerator_range": [-12, 12], "max_denominator": 12}


def point_diagnostics() -> dict:
    P = (Q(-4), Q(6))
    torsion = (None, (Q(0), Q(0)), (Q(5), Q(0)), (Q(-5), Q(0)))
    orbit: set[Point] = set(torsion)
    p: Point = None
    for _ in range(4):
        p = add(p, P)
        require(p is not None, "sample point unexpectedly became torsion")
        for t in torsion:
            orbit.add(add(p, t))
            orbit.add(add((p[0], -p[1]), t))
    cases: Counter[int] = Counter()
    perturbed_cases: set[int] = set()
    perturbations = 0
    for p in orbit:
        require(represents(point_code(p), p), "point-code representation failed")
        for q in orbit:
            w = addition_witness(p, q)
            require(addition_valid(p, q, w), "complete addition tuple did not satisfy its system")
            i = guards(p, q).index(True)
            cases[i] += 1
            if i not in perturbed_cases:
                for j in range(len(w)):
                    mutant = tuple(v + 1 if k == j else v for k, v in enumerate(w))
                    require(not addition_valid(p, q, mutant), f"addition coordinate {j} was unconstrained")
                    perturbations += 1
                perturbed_cases.add(i)
    require(set(cases) == set(range(7)), "boundary diagnostics missed an addition case")
    maximum_cases = 0
    for a in range(13):
        for b in range(13):
            first = b <= a
            selectors = (int(first), int(not first))
            local = (a - b if first else 0, b - a - 1 if not first else 0)
            require(sum(selectors) == 1, "maximum selector failure")
            require((a if first else b) == max(a, b), "maximum output failure")
            require(min(local) >= 0, "negative maximum slack")
            maximum_cases += 1
    return {
        "sample_points": len(orbit),
        "ordered_pairs": sum(cases.values()),
        "zero_based_guard_counts": {str(i): cases[i] for i in range(7)},
        "addition_natural_coordinates_including_output": 48,
        "single_coordinate_mutations_rejected": perturbations,
        "maximum_pairs_including_ties": maximum_cases,
        "identity_and_affine_zero_codes_distinct": point_code(None) != point_code((Q(0), Q(0))),
    }


def pell(a: int, n: int) -> tuple[int, int]:
    require(a >= 2 and n >= 0, "Pell parameters outside the claimed domain")
    x, y = 1, 0
    for _ in range(n):
        x, y = a * x + (a * a - 1) * y, x + a * y
    return x, y


def pell_diagnostics() -> dict:
    sequence_terms = 0
    for a in range(2, 13):
        for i in range(17):
            x, y = pell(a, i)
            require(x * x - (a * a - 1) * y * y == 1, "Pell norm failed")
            require((y - i) % (a - 1) == 0, "Pell index residue failed")
            if i:
                require((2 * a - 1) ** (i - 1) <= y <= (2 * a) ** (i - 1), "Pell size bound failed")
            sequence_terms += 1
    positive_solutions = 0
    for a in range(2, 9):
        terms = {pell(a, i) for i in range(17)}
        for y in range(1, 201):
            square = 1 + (a * a - 1) * y * y
            x = math.isqrt(square)
            if x * x == square:
                require((x, y) in terms, "bounded Pell completeness diagnostic failed")
                positive_solutions += 1
    paired = controlled = 0
    for b in range(2, 9):
        for u in range(2, 17):
            for n in range(11):
                F, H = pell(b * u, n + 1)[1], pell(u, n + 1)[1]
                ratio = Q(F, H)
                require(b**n <= ratio <= b**n * Q(2 * u, 2 * u - 1) ** n, "paired ratio failed")
                if b**n * n < 2 * u - 1 - n:
                    require(F // H == b**n, "controlled quotient failed")
                    controlled += 1
                paired += 1
    prescribed_subtuples = 0
    for b in range(2, 9):
        for n in range(9):
            c = b**n
            u = (c + 1) * (n + 1) * (b + 1) + 4
            X, F = pell(b * u, n + 1)
            Y, H = pell(u, n + 1)
            q, qrem = divmod(F - n - 1, b * u - 1)
            qp, qprem = divmod(H - n - 1, u - 1)
            r = F - c * H
            require(qrem == qprem == 0 and min(q, qp, r) >= 0 and r < H, "Pell subtuple failed")
            require(X * X == 1 + ((b * u) ** 2 - 1) * F**2, "first subtuple norm failed")
            require(Y * Y == 1 + (u * u - 1) * H**2, "second subtuple norm failed")
            if n == 0:
                require((c, F, H, X, Y, q, qp, r) == (1, 1, 1, b * u, u, 0, 0, 0), "n=0 failed")
            prescribed_subtuples += 1
    for u in range(4, 65):
        require(u**u < (2 * u - 1) ** (u - 1), "numerical index cutoff failed")
    return {
        "sequence_terms": sequence_terms,
        "a_range": [2, 12],
        "index_range": [0, 16],
        "positive_solutions_with_y_at_most_200": positive_solutions,
        "paired_cases": paired,
        "controlled_quotient_cases": controlled,
        "prescribed_pell_subtuples_without_growth_cutoff": prescribed_subtuples,
        "subtuple_scale": "ell=1,u0=4, c=b^n; no v or growth witness is asserted",
        "finite_index_cutoffs": [4, 64],
    }


def symbolic_certificates() -> dict:
    k, r = sp.symbols("k r")
    require(
        sp.expand((2 * k) ** 2 + r**2 + 1 - 2 * k**2 - (r + 1) ** 2 - 2 * (k**2 - r)) == 0,
        "square-window polynomial cancellation failed",
    )
    errors = sp.symbols("e2k er e1 ek er1")
    error = errors[0] + errors[1] + errors[2] - 2 * errors[3] - errors[4]
    error_norm = sum(abs(sp.expand(error).coeff(e)) for e in errors)
    require(error_norm == 6, "the height window did not have six error terms")
    x1, x2, y1, y2, l = sp.symbols("x1 x2 y1 y2 l")
    x3 = l**2 - x1 - x2
    y3 = l * (x1 - x3) - y1
    f1 = y1**2 - x1**3 + 25 * x1
    f2 = y2**2 - x2**3 + 25 * x2
    f3 = y3**2 - x3**3 + 25 * x3
    C = l**2 * (x2 - x1) + 2 * y1 * l - (x2**2 + x1 * x2 + x1**2 - 25)
    identities = {
        "output_curve_remainder": f3 - f1 - (x3 - x1) * C,
        "chord_divisor_identity": f2 - f1 - (x2 - x1) * C
        - (y2 - y1 - l * (x2 - x1)) * (y2 + y1 + l * (x2 - x1)),
        "tangent_remainder": (f3 - f1).subs(x2, x1)
        - (x3 - x1).subs(x2, x1) * (2 * y1 * l - 3 * x1**2 + 25),
    }
    for name, expression in identities.items():
        require(sp.expand(expression) == 0, f"universal group-law identity failed: {name}")
    m = sp.symbols("m", integer=True, positive=True)
    height_internal = 48 * (m - 1) + 4
    representative_internal = 1 + height_internal + 4 * 48 + 6
    growth_internal = 26 + 2 * representative_internal + 5 * (48 + 1 + height_internal) + 2 * 5 + 2 + 4
    require(sp.expand(growth_internal - (336 * (m - 1) + 713)) == 0, "complete tuple count failed")
    return {
        "kind": "exact polynomial identities, not finite numerical evidence",
        "square_window_remainder": 0,
        "height_error_l1_norm": int(error_norm),
        "curve_identity_remainders": {name: 0 for name in identities},
        "curve_certificate": {
            "C": str(C),
            "x3": str(x3),
            "y3": str(y3),
            "identities": [
                "f3-f1=(x3-x1)*C",
                "f2-f1=(x2-x1)*C+(y2-y1-l*(x2-x1))*(y2+y1+l*(x2-x1))",
                "(f3-f1)|x2=x1=(x3-x1)|x2=x1*(2*y1*l-3*x1^2+25)",
            ],
            "use": "Chord inputs have f1=f2=0, nonzero x2-x1 and the slope equation; tangent inputs have f1=0 and the tangent slope equation.",
        },
        "growth_auxiliary_dimension": "336*(m-1)+713 for the chain Q,2Q,...,mQ",
        "whole_power_dimension_including_c": "336*(m-1)+729",
        "sympy_version": sp.__version__,
    }


def source_linkage() -> dict:
    specifications = {
        "elliptic.tex": (
            ("prop:growth", "lem:rational-codes", "lem:point-arithmetic", "lem:representatives"),
            (
                r"pn=0,\qquad d=1+t+s,\qquad (p+n)t+d=1+qd.",
                r"L_0&=W([2]Q)\,W(R)\,W_1,",
                r"D_0&=W(Q)^2\max\{W(R+P),W(R-P)\},",
                r"L_0\le\kappa D_0,\qquad D_0\le\kappa L_0.",
            ),
        ),
        "power.tex": (
            ("prop:power", "lem:pell-sequences"),
            (
                r"u=(c+1)^\ell(n+1)(b+1)+u_0",
                r"X^2-\bigl((bu)^2-1\bigr)F^2=1",
                r"Y^2-(u^2-1)H^2=1",
                r"F=n+1+(bu-1)q,\qquad H=n+1+(u-1)q'",
                r"F=cH+r,\qquad r<H.",
            ),
        ),
        "witness-ledger.tex": (
            ("app:witnesses",),
            (
                r"u+W_1-h_Q,\quad N_Q-u-W_1-1,\quad \kappa D_0-L_0,\quad \kappa L_0-D_0.",
                r"b-2,\quad F-1,\quad v-F-1,\quad H-1,\quad v-H-1,\quad H-r-1.",
            ),
        ),
    }
    result = {}
    for name, (labels, formulas) in specifications.items():
        text = (BUILD / name).read_text()
        compact = "".join(text.split())
        for label in labels:
            require(text.count(r"\label{" + label + "}") == 1, f"source locator missing or ambiguous: {label}")
        for formula in formulas:
            require("".join(formula.split()) in compact, f"literal source formula changed: {name}: {formula}")
        result[name] = {"labels": list(labels), "literal_formulas_checked": len(formulas)}
    return result


def jacobian_replay() -> dict:
    record = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    operation = "number_theory.elliptic_curve.short_weierstrass.scalar_multiply.compute"
    require(record["request"]["payload"] == payload, "Jacobian payload preservation failed")
    require(record["request"]["operation_id"] == operation == record["result"]["operation_id"], "Jacobian operation mismatch")
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not report success")
    output = record["result"]["output"]
    require(output["at_infinity"] is False, "Jacobian returned the wrong point type")
    coordinates = output["point"]
    point = tuple(Q(int(coordinates[c]["num"]), int(coordinates[c]["den"])) for c in ("x", "y"))
    require(point == add((Q(-4), Q(6)), (Q(-4), Q(6))), "Jacobian doubling disagreed with exact replay")
    return {
        "operation_id": operation,
        "server_version": record["server"]["version"],
        "protocol_version": record["protocol_version"],
        "adapter_exit_code": status["adapter_exit_code"],
        "point": ["1681/144", "-62279/1728"],
        "kind": "one preserved exact diagnostic; not universal verification",
    }


def lean_replay(workspace: Path) -> dict:
    require(workspace.is_dir(), f"missing built Mathlib workspace: {workspace}")
    official = json.loads((HERE / "lean_check.json").read_text())
    require(official["status"] == "success" and official["exit_code"] == 0, "official Lean result was not successful")
    require(official["proof_holes"] == [], "official Lean result has proof holes")
    for filename, key in (
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ):
        actual = hashlib.sha256((HERE / filename).read_bytes()).hexdigest()
        require(actual == official[key], f"official compiler binding is stale: {filename}")
    version = subprocess.run(
        ["lake", "env", "lean", "--version"], cwd=workspace, capture_output=True, text=True, check=True
    ).stdout.strip()
    require("Lean (version 4.31.0," in version, f"wrong Lean version: {version}")
    compiled = subprocess.run(
        ["lake", "env", "lean", str(HERE / "Main.lean")],
        cwd=workspace,
        capture_output=True,
        text=True,
    )
    require(compiled.returncode == 0, f"Lean replay failed:\n{compiled.stdout}\n{compiled.stderr}")
    return {
        "claim": "AB_KERNEL",
        "version": version,
        "exit_code": compiled.returncode,
        "proof_holes": official["proof_holes"],
        "official_result": "research/arithmetic-bridge/lean_check.json",
        "source_sha256": official["source_sha256"],
        "statement_fidelity_sha256": official["statement_fidelity_sha256"],
        "declaration": "ArithmeticBridge.elliptic_pell_complete",
        "scope": "universal arithmetic core and primitive witness kernels; see statement_fidelity.md",
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--diagnostics-only", action="store_true")
    parser.add_argument(
        "--mathlib-workspace",
        type=Path,
        default=Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0"),
    )
    args = parser.parse_args()
    require(not (args.write_certificate and args.diagnostics_only), "a finite-only run cannot write the universal certificate")
    result = {
        "schema_version": 1,
        "project": "9000242",
        "source_linkage": source_linkage(),
        "symbolic_certificates": symbolic_certificates(),
        "finite_diagnostics": {
            "rational_codes": rational_diagnostics(),
            "point_addition": point_diagnostics(),
            "pell": pell_diagnostics(),
        },
        "jacobian": jacobian_replay(),
        "limits": [
            "No manuscript refutation was found.",
            "Finite diagnostics are not proofs of universal claims.",
            "Theorem.md Section 5 discharges the source-specific expansion in ordinary mathematics, not a closed Lean instantiation.",
            "Rank, canonical-height sources, independent review, novelty and publishability are not certified by this script.",
            "No artificial growth value v or full power witness is supplied by the bounded Pell diagnostics.",
        ],
    }
    if args.diagnostics_only:
        result["mode"] = "exact_symbolic_and_bounded_diagnostics_only"
    else:
        result["kernel"] = lean_replay(args.mathlib_workspace)
        certificate = HERE / "exact_certificate.json"
        if args.write_certificate:
            certificate.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
        else:
            require(json.loads(certificate.read_text()) == result, "certificate differs from the exact replay")
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
