#!/usr/bin/env python3
"""Replay exact identities for the joint curve/trace existence proof.

The geometric existence arguments are in report.md. This is not a proof
assistant and does not decide analytic realization, algebraization, or novelty.
"""

import argparse
import copy
import json
import sys
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
CHECKS = []


class VerificationError(Exception):
    pass


def require(name, condition):
    if not condition:
        raise VerificationError(name)
    CHECKS.append(name)


def equal(name, left, right=0):
    require(name, sp.cancel(sp.expand(left - right)) == 0)


def wedge(a, b):
    return a[0] * b[1] - a[1] * b[0]


def sphere_cohomology(n):
    return max(n + 1, 0), max(-n - 1, 0)


def quadric_cohomology(a, b):
    a0, a1 = sphere_cohomology(a)
    b0, b1 = sphere_cohomology(b)
    return [a0 * b0, a1 * b0 + a0 * b1, a1 * b1]


def partitions(n, bound=None):
    if n == 0:
        yield []
        return
    for first in range(1, min(n, n if bound is None else bound) + 1):
        for rest in partitions(n - first, first):
            yield [first] + rest


def elliptic_and_vectors():
    x = sp.Symbol("x")
    cubic = x**3 - x
    equal("smooth affine cubic", sp.gcd(cubic, sp.diff(cubic, x)), 1)
    X, Y, Z = sp.symbols("X Y Z")
    equation = Y**2 * Z - X**3 + X * Z**2
    equal("smooth point at infinity", sp.diff(equation, Z).subs({X: 0, Y: 1, Z: 0}), 1)
    px, py = sp.I, 1 - sp.I
    equal("four-torsion point lies on curve", py**2, px**3 - px)
    slope = (3 * px**2 - 1) / (2 * py)
    dx = sp.simplify(slope**2 - 2 * px)
    dy = sp.simplify(slope * (px - dx) - py)
    equal("doubling gives x=0", dx)
    equal("doubling gives y=0", dy)
    require("four-torsion point is not two-torsion", py != 0)
    tangent = py + slope * (x - px)
    equal("tangent divisor is 2P+T", tangent**2 - cubic, -x * (x - sp.I)**2)

    t = sp.Symbol("t")
    t2 = sp.Rational(125, 313)
    modulus = sp.Poly(t**2 - t2, t, domain=sp.QQ)
    require("quadratic witness field", modulus.is_irreducible)

    def reduce(expression):
        return sp.Poly(sp.expand(expression), t, domain=sp.QQ).rem(modulus).as_expr()

    rows = [
        (sp.Integer(1), -sp.Rational(43, 4)),
        (t, (133 - 313 * t) / 8),
        (-t, (133 + 313 * t) / 8),
    ]
    total = tuple(2 * sum(v[i] for v in rows) for i in range(2))
    equal("six-vector sum first entry", total[0], 2)
    equal("six-vector sum second entry", total[1], 45)
    total_norm = reduce(total[0] * total[1])
    equal("total quadratic norm", total_norm, 90)
    norms = []
    for i, row in enumerate(rows):
        norm = reduce(row[0] * row[1])
        dot_total = reduce((row[0] * total[1] + row[1] * total[0]) / 2)
        equal(f"pointwise six-vector equation {i}", norm + dot_total, 1)
        require(f"nonisotropic direction {i}", norm != 0)
        norms.append(norm)
        for j in range(i):
            require(f"distinct directions {j},{i}", reduce(wedge(rows[j], row)) != 0)
    total_residue = reduce(2 * sum(norms) - 6)
    equal("total residue from six vectors", total_residue, -90)
    evaluation = sp.Matrix([[a**2, a * b, b**2] for a, b in rows])
    require("three directions determine a binary quadratic", reduce(evaluation.det()) != 0)
    equal(
        "binary quadratic evaluation determinant",
        evaluation.det(),
        wedge(rows[0], rows[1]) * wedge(rows[0], rows[2]) * wedge(rows[1], rows[2]),
    )
    nu, a, b, c, d = sp.symbols("nu a b c d", nonzero=True)
    equal("isometry preserves norm", (nu * a) * (b / nu), a * b)
    equal("isometry preserves polar form", ((nu * a) * (d / nu) + (b / nu) * (nu * c)) / 2,
          (a * d + b * c) / 2)

    dual_metric = sp.Matrix([[0, sp.Rational(1, 2)], [sp.Rational(1, 2), 0]])
    J = -dual_metric * sp.Matrix(total)
    T0, T1 = sp.symbols("T0 T1")
    equal("metric form of global J pairing", (J.T * dual_metric.inv() * sp.Matrix([T0, T1]))[0],
          -total[0] * T0 - total[1] * T1)
    for i, row in enumerate(rows):
        equal(f"local J evaluation {i}", reduce((sp.Matrix([row]) * J)[0] - norms[i]), -1)

    return {
        "elliptic": {
            "equation": "y^2=x^3-x",
            "discriminant": 64,
            "point": ["i", "1-i"],
            "double": [int(dx), int(dy)],
            "exact_order": 4,
        },
        "vectors": {
            "quadratic_form": "x*y",
            "t_squared": str(t2),
            "paired_rows": [
                [["1", "0"], ["-43/4", "0"]],
                [["0", "1"], ["133/8", "-313/8"]],
                [["0", "-1"], ["133/8", "313/8"]],
            ],
            "coefficient_convention": "each entry is constant + coefficient*t; use each row twice",
            "total": [int(total[0]), int(total[1])],
            "total_norm": int(total_norm),
            "pointwise_norm_plus_dot": 1,
            "sum_norms_minus_one": int(total_residue),
        },
    }


def geometry():
    def add(a, b):
        return [a[0] + b[0], (a[1] + b[1]) % 4]

    def scale(n, a):
        return [n * a[0], (n * a[1]) % 4]

    F, D0 = [1, 0], [0, 1]
    S = add(F, D0)
    Gamma = add(scale(2, F), scale(2, S))
    Delta = scale(2, D0)
    Phi = add(F, Delta)
    M = scale(3, Phi)
    identities = {
        "4M=2Gamma+4F": (scale(4, M), add(scale(2, Gamma), scale(4, F))),
        "2M-Gamma-F=Phi": (scale(2, M), add(add(Gamma, F), Phi)),
        "Gamma+2F-2M=Delta": (add(Gamma, scale(2, F)), add(scale(2, M), Delta)),
        "2Phi=2F": (scale(2, Phi), scale(2, F)),
    }
    for name, (left, right) in identities.items():
        require(name, left == right)

    kernel = quadric_cohomology(6, 2)
    require("restriction to elliptic curve is onto", kernel[1] == 0)
    family_dimension = kernel[0]
    gamma, gy, gz = sp.symbols("gamma gy gz")
    jet_matrix = sp.Matrix([[gamma, 0, 0], [gy, gamma, 0], [gz, 0, gamma]])
    equal("off-Gamma first-jet multiplier", jet_matrix.det(), gamma**3)
    incidence_bound = 2 + family_dimension - 3
    require("singular incidence has smaller dimension", incidence_bound < family_dimension)
    require("connectedness kernel vanishing", quadric_cohomology(-8, -4)[:2] == [0, 0])
    genus = quadric_cohomology(-8, -4)[2]
    degree_H, degree_Z = 4, 6
    degree_L = degree_H + degree_Z
    degree_K = 6 * 4 + 2 * 8
    equal("canonical degree", degree_K, 2 * genus - 2)
    equal("canonical fourth root degree", 4 * degree_L, degree_K)

    rows = []
    for j, length in [(0, 1), (1, 2), (2, 2), (3, 2)]:
        require(f"adjoint restriction to C {j}",
                quadric_cohomology(-2 - j, -2)[:2] == [0, 0])
        require(f"adjoint restriction to Gamma {j}",
                quadric_cohomology(4 - j, 0)[1] == 0)
        require(f"ruling restriction {j}", quadric_cohomology(j - 8, -4)[:2] == [0, 0])
        N = add(Gamma, scale(4 - j, F))
        residual = add(N, scale(-length, M))
        h0_N = 2 * N[0]
        degree_residual = 2 * residual[0]
        h0_residual = max(degree_residual, 0)
        if degree_residual == 0:
            require("degree-zero residual is nontrivial torsion", residual == [0, 2])
        rank = h0_N - h0_residual
        rows.append({
            "j": j, "length": length,
            "surface_h0": quadric_cohomology(6 - j, 2)[0],
            "elliptic_h0": h0_N, "residual_bundle_F_D0": residual,
            "residual_h0": h0_residual, "evaluation_rank": rank,
        })
    dimensions = {
        "O(Z)": 1 + 6 - rows[0]["evaluation_rank"],
        "H+2Z": 2 + 12 - rows[1]["evaluation_rank"],
        "2H+2Z": 3 + 12 - rows[2]["evaluation_rank"],
        "3H+2Z": 4 + 12 - rows[3]["evaluation_rank"],
    }
    require("L bracketed by two equal two-dimensional spaces", dimensions["H+2Z"] == 2)
    dimensions.update({"L": 2, "3L": 2 - degree_L - 1 + genus, "4L": genus})
    equal("first negative interpolation degree", (4 - 5) * degree_L + degree_Z, -4)
    for n in (2, 3, 6):
        require(f"split extension H1 O({n})", sphere_cohomology(n)[1] == 0)
    quotient_h0 = dimensions["3H+2Z"] - sphere_cohomology(3)[0]
    quotient_twist_h0 = dimensions["2H+2Z"] - sphere_cohomology(2)[0]
    equal("trace quotient dimension", quotient_h0, 2)
    equal("trace quotient has no negative-twist sections", quotient_twist_h0, 0)

    return {
        "geometry": {
            "restricted_bundles_F_D0": {"Gamma": Gamma, "Delta": Delta, "Phi": Phi, "M": M},
            "curve_bidegree": [8, 4],
            "genus": genus, "degree_H": degree_H, "degree_Z": degree_Z,
            "degree_L": degree_L, "degree_K": degree_K,
            "affine_family_dimension": family_dimension,
            "off_Gamma_singular_incidence_bound": incidence_bound,
            "marked_bad_normal_derivative_codimension": 1,
            "contact_order": 4,
            "h0_jH": list(range(1, 5)),
            "adjoint_evaluation_table": rows,
            "section_dimensions": dimensions,
            "interpolation": {"first_degree": 3, "negative_case_first_degree": 5,
                              "negative_case_degree_at_5": -4, "degree_slope": -10},
        },
        "trace_quotient": {
            "splitting": [3, 0, 0, -3],
            "global_radical_dimension": sphere_cohomology(3)[0],
            "quotient_h0": quotient_h0,
            "quotient_negative_twist_h0": quotient_twist_h0,
        },
    }


def trace_ramification():
    x = sp.Symbol("x", nonzero=True)
    signs = []
    blocks = {}
    for e in range(1, 5):
        multiplication = sp.zeros(e)
        for i in range(e - 1):
            multiplication[i + 1, i] = 1
        multiplication[0, e - 1] = x
        require(f"ramification algebra degree {e}", multiplication**e == x * sp.eye(e))
        inverse_differential = (e * multiplication ** (e - 1)).inv()
        gram = sp.Matrix(e, e, lambda i, j: sp.trace(multiplication ** (i + j) * inverse_differential))
        expected = sp.Matrix(e, e, lambda i, j: int(i + j == e - 1))
        for i in range(e):
            for j in range(e):
                equal(f"field trace degree {e} entry {i},{j}", gram[i, j], expected[i, j])
        coefficients = sp.symbols(f"a0:{e}")
        nilpotent = multiplication.subs(x, 0)
        unit = sp.zeros(e)
        for i in range(e):
            unit += coefficients[i] * nilpotent**i
        unit_gram = gram * unit
        require(f"unit-twisted symmetry degree {e}", unit_gram == unit_gram.T)
        sign = (-1) ** (e * (e - 1) // 2)
        equal(f"unit-twisted perfection degree {e}", unit_gram.det(), sign * coefficients[0] ** e)
        signs.append(sign)
        blocks[e] = expected

    all_partitions = list(partitions(4))
    d = sp.Symbol("d", nonzero=True)
    for partition in all_partitions:
        matrix = sp.diag(*(blocks[e] for e in partition))
        require(f"perfect fibre partition {partition}", matrix.det() in (-1, 1))
        offset = 0
        for e in partition:
            if e == 1:
                scaled = matrix.copy()
                scaled[offset, offset] = d
                equal(f"unramified dual evaluation {partition} at {offset}", scaled.inv()[offset, offset], 1 / d)
            offset += e
    require("all degree-four fibre types enumerated", len(all_partitions) == 5)
    return {"trace": {
        "ramification_partitions": all_partitions,
        "antidiagonal_entries": 1,
        "unit_gram_determinant_signs_e1_to_e4": signs,
        "trace_normalization": 1,
        "dual_evaluation": "E/s",
    }}


def principal_parts():
    z = sp.Symbol("z")
    b1, K0 = sp.symbols("b1 K0", nonzero=True)
    b2, K1, pi0, pi1, tilde0, tilde1, E, L2 = sp.symbols(
        "b2 K1 pi0 pi1 tilde0 tilde1 E L2"
    )
    b = b1 * z + b2 * z**2
    K = K0 + K1 * z
    approximate_y = -b**4 / K
    equal("contact residual is order eight",
          b**4 + K * approximate_y + L2 * approximate_y**2, L2 * b**8 / K**2)
    leading_contact = sp.limit(approximate_y / z**4, z, 0)
    equal("exact fourth contact coefficient", leading_contact, -b1**4 / K0)
    s0 = sp.cancel(leading_contact / K0)
    equal("normal-first adjunction frame square", s0, -b1**4 / K0**2)
    ky, kz = sp.symbols("ky kz")
    equal("normal-first Jacobian sign", sp.Matrix([[ky, kz], [0, 1]]).det(), ky)

    c_series = sp.series((pi0 + pi1 * z) / K, z, 0, 2).removeO()
    g_series = sp.series((tilde0 + tilde1 * z) / (b1 + b2 * z)**2, z, 0, 2).removeO()
    equations = [sp.expand(c_series - g_series).coeff(z, i) for i in range(2)]
    solution = sp.solve(equations, [tilde0, tilde1], dict=True)[0]
    alpha0 = sp.cancel(solution[tilde0] / pi0)
    alpha1 = sp.cancel((solution[tilde1] - alpha0 * pi1) / pi0)
    equal("principal-part leading coefficient", alpha0, b1**2 / K0)
    equal("principal-part derivative coefficient", alpha1,
          2 * b1 * b2 / K0 - b1**2 * K1 / K0**2)
    for i, equation in enumerate(equations):
        equal(f"full principal part coefficient {i}", equation.subs(solution))
    equal("comparison isometry sign and scale", alpha0**2 * E / s0, -E)
    transformation = sp.Matrix([[alpha0, 0], [alpha1, alpha0]])
    equal("full residue-dual map invertible", transformation.det(), b1**4 / K0**2)

    return {"principal_parts": {
        "contact_equation_sign": int(sp.cancel(leading_contact * K0 / b1**4)),
        "normal_first_adjunction_sign": 1,
        "frame_square_sign": int(sp.cancel(s0 * K0**2 / b1**4)),
        "leading_coefficient": int(sp.cancel(alpha0 * K0 / b1**2)),
        "derivative_coefficients": [
            int(sp.cancel(alpha1.subs(K1, 0) * K0 / (b1 * b2))),
            int(sp.cancel(alpha1.subs(b2, 0) * K0**2 / (b1**2 * K1))),
        ],
        "transported_dual_norm_sign": int(sp.cancel(alpha0**2 / s0)),
        "contact_remainder_order": 8,
    }}


def residue_and_coordinates():
    z = sp.Symbol("z")
    c, g0 = sp.symbols("c g0", nonzero=True)
    a0, a1, b0, b1, p0, p1, T, g1 = sp.symbols("a0 a1 b0 b1 p0 p1 T g1")
    u = sp.Matrix([a0 + a1 * z, b0 + b1 * z])
    p = sp.Matrix([p0, p1])
    r = z * u
    R = c * u
    P = p + c * sp.diff(r, z) / z
    J = wedge(u, P)
    equal("J has no pole", sp.limit(z * J, z, 0))
    equal("local global-pair identity", c * J, wedge(R, p) + wedge(R, sp.diff(R, z)))
    for i in range(2):
        equal(f"P constant term {i}", sp.limit(P[i] - R[i].subs(z, 0) / z, z, 0),
              p[i] + 2 * sp.diff(R[i], z))
    equal("marked residue of global differential", sp.limit(z * P[0] * T / u[0], z, 0), c * T)
    slope, u2, pole_section = sp.symbols("slope u2 pole_section", nonzero=True)
    equal("residue at a zero of u1 has trace sign",
          (-u2 * pole_section) * T / (-u2 * slope), pole_section * T / slope)
    local_sum, pairing = sp.symbols("local_sum pairing")
    pairing_value = sp.solve(local_sum + pairing, pairing)[0]
    global_sign = int(sp.diff(pairing_value, local_sum))
    norm, dual_dot = sp.symbols("norm dual_dot")
    J_evaluation = -dual_dot
    p_wedge_R = norm - J_evaluation
    equal("pointwise determinant from vector constraint", p_wedge_R.subs(dual_dot, 1 - norm), 1)

    g = g0 + g1 * z
    psi = sp.integrate(g**4, (z, 0, z))
    equal("compatible coordinate differential", sp.diff(psi, z), g**4)
    c_new = g0**7 * c
    scalar_R = c_new / c * z / (psi * g)
    equal("R coordinate scale", sp.limit(scalar_R, z, 0), g0**2)
    equal("W coordinate invariant", sp.limit(scalar_R, z, 0)**2 / sp.diff(psi, z).subs(z, 0), 1)
    scalar_r = z * (a0 + a1 * z) / g
    scalar_P = (c * a0 / z + p0 + 2 * c * a1) / g**2
    new_p = scalar_P - c_new / psi * sp.diff(scalar_r, z) / sp.diff(psi, z)
    new_p0 = sp.limit(sp.cancel(new_p), z, 0)
    shift = sp.cancel((new_p0 - p0 / g0**2) * g0**3 / (c * a0 * g1))
    equal("p coordinate correction parallel to R", shift, 6)
    equal("new Laurent pole coefficient", g0**4 * g0**-2, g0**2)
    return {
        "residue": {
            "global_pairing_sign": global_sign,
            "pointwise_p_wedge_R": 1,
            "total_W_minus_one": -90,
            "P_constant_R_derivative_coefficient": 2,
        },
        "coordinates": {
            "evaluation_scale_exponent": -7,
            "c_scale_exponent": 7,
            "R_scale_exponent": 2,
            "p_transverse_scale_exponent": -2,
            "p_parallel_shift_coefficient": int(shift),
            "W_scale": 1,
        },
    }


def jacobian_replay():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    output = json.loads((ROOT / "jacobian_output.json").read_text())
    contract = json.loads((ROOT / "jacobian_contract.json").read_text())
    operation = "formal_series.rational.divide.compute"
    require("Jacobian inspected operation", contract["result"]["operation"]["operation_id"] == operation)
    require("Jacobian exact operation binding", output["request"]["operation_id"] == operation)
    require("Jacobian exact payload binding", output["request"]["payload"] == payload)
    require("Jacobian result operation", output["result"]["operation_id"] == operation)
    result = output["result"]["output"]
    require("Jacobian exactness", result["exactness"] == "EXACT_RATIONAL")

    def coefficients(series):
        require("Jacobian variable", series["variable"] == "z")
        require("Jacobian truncation", series["truncation_order"] == 4)
        require("Jacobian coefficient count", len(series["coefficients"]) == 4)
        return [sp.Rational(int(v["num"]), int(v["den"])) for v in series["coefficients"]]

    numerator = coefficients(result["numerator"])
    denominator = coefficients(result["denominator"])
    quotient = coefficients(result["quotient"])
    require("Jacobian source numerator", numerator == [4, 12, 29, 30])
    require("Jacobian source denominator", denominator == [3, 7, 11, 0])
    require("Jacobian returned numerator binding", result["numerator"] == payload["left"])
    require("Jacobian returned denominator binding", result["denominator"] == payload["right"])
    z = sp.Symbol("z")
    source_numerator = sp.Poly((2 + 3*z + 5*z**2)**2, z)
    for n in range(4):
        equal(f"Jacobian principal-part multiplier numerator {n}", numerator[n], source_numerator.nth(n))
        equal(f"Jacobian independently replayed division {n}",
              sum(denominator[i] * quotient[n - i] for i in range(n + 1)), numerator[n])
    residual = result["residual_coefficients"]
    require("Jacobian residual count", len(residual) == 4)
    for n, value in enumerate(residual):
        equal(f"Jacobian reported residual {n}", sp.Rational(int(value["num"]), int(value["den"])))
    return {"jacobian": {
        "operation_id": operation,
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "adapter_exit_code": 0,
        "adapter_status": "completed",
        "error": None,
        "timeout": False,
        "quotient": [str(v) for v in quotient],
        "scope": "one exact rational specialization of the universal principal-part multiplier",
    }}


def derive():
    result = {
        "schema_version": 1,
        "claim_id": "CT_joint_inputs",
        "proof": "report.md",
        "scope": "exact identity certificate accompanying a prose joint-existence proof",
        "independent_review": "pending",
        "not_certified": ["analytic realization", "algebraization", "novelty", "publishable significance", "kernel proof"],
    }
    for part in (elliptic_and_vectors, geometry, trace_ramification, principal_parts,
                 residue_and_coordinates, jacobian_replay):
        result.update(part())
    return result


def compare(actual, expected, path="$"):
    if isinstance(expected, dict):
        if not isinstance(actual, dict) or set(actual) != set(expected):
            raise VerificationError(f"{path}: certificate keys do not match")
        for key, value in expected.items():
            compare(actual[key], value, f"{path}.{key}")
    elif isinstance(expected, list):
        if not isinstance(actual, list) or len(actual) != len(expected):
            raise VerificationError(f"{path}: certificate list length does not match")
        for i, value in enumerate(expected):
            compare(actual[i], value, f"{path}[{i}]")
    elif type(actual) is not type(expected) or actual != expected:
        raise VerificationError(f"{path}: got {actual!r}, derived {expected!r}")


def negative_controls(certificate, expected):
    mutations = [
        ("vectors", "total_norm", 89),
        ("vectors", "sum_norms_minus_one", 90),
        ("geometry", "affine_family_dimension", 20),
        ("trace", "trace_normalization", "1/4"),
        ("trace", "ramification_partitions", expected["trace"]["ramification_partitions"][:-1]),
        ("principal_parts", "frame_square_sign", 1),
        ("principal_parts", "derivative_coefficients", [1, -1]),
        ("principal_parts", "transported_dual_norm_sign", 1),
        ("residue", "global_pairing_sign", 1),
        ("residue", "pointwise_p_wedge_R", -1),
        ("coordinates", "c_scale_exponent", 6),
        ("coordinates", "p_parallel_shift_coefficient", 5),
        ("jacobian", "quotient", ["4/3", "8/9", "74/27", "35/81"]),
    ]
    rejected = []
    for section, key, value in mutations:
        candidate = copy.deepcopy(certificate)
        candidate[section][key] = value
        try:
            compare(candidate, expected)
        except VerificationError:
            rejected.append(f"{section}.{key}")
        else:
            raise VerificationError(f"negative control was accepted: {section}.{key}")
    return rejected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=ROOT / "exact_certificate.json")
    parser.add_argument("--negative-controls", action="store_true")
    parser.add_argument("--emit-certificate", action="store_true",
                        help="print the derived certificate; does not report independent review")
    args = parser.parse_args()
    try:
        expected = derive()
        if args.emit_certificate:
            print(json.dumps(expected, indent=2))
            return 0
        certificate = json.loads(args.certificate.read_text())
        compare(certificate, expected)
        rejected = negative_controls(certificate, expected) if args.negative_controls else []
        print(json.dumps({
            "ok": True,
            "claim": "CT_joint_inputs",
            "exact_checks": len(CHECKS),
            "ramification_types": expected["trace"]["ramification_partitions"],
            "negative_controls_rejected": len(rejected),
            "negative_controls": rejected,
            "scope": expected["scope"],
            "independent_review": "pending",
        }, indent=2))
        return 0
    except (VerificationError, OSError, ValueError, TypeError, KeyError) as error:
        print(json.dumps({"ok": False, "error": str(error), "exact_checks_before_failure": len(CHECKS)}))
        return 1


if __name__ == "__main__":
    sys.exit(main())
