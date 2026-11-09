#!/usr/bin/env python3
"""Replay exact algebra and the degree-one P^2 check; do not certify geometry."""

import argparse
import hashlib
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
LEAN_CERTIFICATE = (
    "lean_evidence/certificates/C_LOC_JET-eb1805af26b62351.json"
)


def zero(expression, label):
    reduced = sp.cancel(expression)
    if reduced != 0:
        raise AssertionError(f"{label}: nonzero remainder {reduced}")


def zero_matrix(matrix, label):
    for i in range(matrix.rows):
        for j in range(matrix.cols):
            zero(matrix[i, j], f"{label}[{i},{j}]")


def rational_function(data):
    variables = [sp.Symbol(name) for name in data["variables"]]

    def polynomial(terms):
        value = sp.Integer(0)
        for term in terms:
            coefficient = term["coefficient"]
            monomial = sp.Rational(coefficient["num"], coefficient["den"])
            if len(term["exponents"]) != len(variables):
                raise AssertionError("Invalid typed exponent vector")
            for variable, exponent in zip(variables, term["exponents"]):
                monomial *= variable ** exponent
            value += monomial
        return value

    denominator = polynomial(data["denominator"]["terms"])
    if denominator == 0:
        raise AssertionError("Zero denominator in typed output")
    return sp.cancel(polynomial(data["numerator"]["terms"]) / denominator)


def typed_matrix(data):
    return sp.Matrix(
        [[rational_function(entry) for entry in row] for row in data["entries"]]
    )


def jacobian_replay():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    operation = "matrix.symbolic.multiply.compute"
    if status["exit_code"] != 0:
        raise AssertionError("Jacobian adapter did not complete successfully")
    if output["request"]["operation_id"] != operation:
        raise AssertionError("Unexpected Jacobian operation")
    if output["request"]["payload"] != payload:
        raise AssertionError("Stored output is for a different payload")
    if output["result"]["operation_id"] != operation:
        raise AssertionError("Unexpected Jacobian result type")
    left = typed_matrix(payload["left"])
    right = typed_matrix(payload["right"])
    product = typed_matrix(output["result"]["output"])
    zero_matrix(left * right - product, "independent typed-product replay")
    zero_matrix(product - sp.eye(3), "nilpotent resolvent")
    return {
        "operation_id": operation,
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "adapter_exit_code": status["exit_code"],
        "timeout_seconds": status["timeout_seconds"],
        "structured_error": None,
        "typed_product": "identity_3",
        "scope": "A three-dimensional illustration, not the all-orders proof.",
    }


def lean_binding():
    certificate = json.loads((HERE / LEAN_CERTIFICATE).read_text())
    check = certificate["lean_check"]
    if check["status"] != "success" or check["exit_code"] != 0:
        raise AssertionError("No successful archived Lean compiler run")
    if check["proof_holes"] or check["audit_exit_code"] != 0:
        raise AssertionError("Lean proof-hole or axiom audit did not pass")
    for filename, hash_key, archive_key in [
        ("Main.lean", "source_sha256", "lean_source"),
        ("statement_fidelity.md", "statement_fidelity_sha256", "statement_fidelity"),
    ]:
        content = (HERE / filename).read_bytes()
        if hashlib.sha256(content).hexdigest() != check[hash_key]:
            raise AssertionError(f"{filename} changed after compilation")
        if content.decode() != certificate[archive_key]["text"]:
            raise AssertionError(f"{filename} differs from the archived text")
    return {
        "claim": "C_LOC_JET",
        "certificate": LEAN_CERTIFICATE,
        "compiler_version": check["tools"]["lean"]["version"],
        "exit_code": check["exit_code"],
        "proof_holes": check["proof_holes"],
        "axiom_audit_exit_code": check["audit_exit_code"],
        "declarations": [
            "finite_geometric_remainder",
            "nilpotent_resolvent_inverse",
            "nilpotent_resolvent_unique",
            "joint_moment_naturality",
            "joint_dressing_naturality",
            "all_flag_contraction",
        ],
        "scope": "Arbitrary finite orders and flags; no GW moduli in Lean.",
        "replay": "Source binding only; a fresh compiler run is a separate command.",
    }


def geometric_remainder_induction():
    x, g, p = sp.symbols("x g p")
    zero(
        (1 - x) * (g + p) - (1 - p * x)
        - ((1 - x) * g - (1 - p)),
        "universal geometric-series induction step",
    )
    zero((1 - x) * 0 - (1 - 1), "geometric-series base")
    return "Exact induction identity; the quantification over N is proved in Lean."


def joint_moment_example():
    h, lam, s, t, alpha, beta = sp.symbols("h lambda s t alpha beta")
    c0, c1, c2 = sp.symbols("c0 c1 c2")
    multiplicities = (2, 3)
    a0 = [-lam / m for m in multiplicities]
    nu = [-h / m for m in multiplicities]
    coefficient = c0 + c1 * h + c2 * h ** 2

    def push(expression):
        return sp.cancel(sp.diff(expression, h, 2).subs(h, 0) / 2)

    direct = push(coefficient / (a0[0] + nu[0] - s) / (a0[1] + nu[1] - t))
    k1 = [
        sp.diff(1 / (alpha - s), alpha, j).subs(alpha, a0[0]) / sp.factorial(j)
        for j in range(3)
    ]
    k2 = [
        sp.diff(1 / (beta - t), beta, j).subs(beta, a0[1]) / sp.factorial(j)
        for j in range(3)
    ]
    moments = [
        [push(nu[0] ** j * nu[1] ** k * coefficient) for k in range(3)]
        for j in range(3)
    ]
    reconstructed = sum(
        k1[j] * k2[k] * moments[j][k]
        for j in range(3) for k in range(3)
    )
    zero(direct - reconstructed, "joint dummy-derivative pushforward")
    joint_unit = direct.subs({c0: 1, c1: 0, c2: 0})
    false_marginal_product = (
        push(1 / (a0[0] + nu[0] - s))
        * push(1 / (a0[1] + nu[1] - t))
    )
    point = {lam: 1, s: 0, t: 0}
    joint_value = sp.cancel(joint_unit.subs(point))
    marginal_value = sp.cancel(false_marginal_product.subs(point))
    if (joint_value, marginal_value) != (18, 6):
        raise AssertionError("Unexpected exact joint-moment example")
    return {
        "space": "X=P^2 over B=point, two B-flags sharing X",
        "multiplicities": list(multiplicities),
        "ring": "QQ(lambda,s,t,c0,c1,c2)[h]/(h^3)",
        "coefficient": "c0+c1*h+c2*h^2",
        "joint_formula_remainder": "0",
        "joint_unit_at_lambda_1_s_t_0": str(joint_value),
        "product_of_marginals_at_same_point": str(marginal_value),
        "scope": "The manuscript retains joint moments; this is not a refutation.",
    }


def degree_one_projective_plane():
    p, q, z, w, lam = sp.symbols("p q z w lambda")
    basis = [p ** 2 / lam ** 2, 1 - p ** 2 / lam ** 2, p + p ** 2 / lam]
    denominator = (p - z) ** 2 * (p + lam - z)
    sw = sp.zeros(3)
    for j, polynomial in enumerate(basis):
        # The degree-one evaluation map is Bl_Delta(P^2 x P^2), psi_2=p_1-p_2.
        integrand = polynomial.subs(p, q) / (z - p + q)
        value = sp.cancel(
            integrand.subs(q, -lam) / lam ** 2
            + sp.diff(integrand, q).subs(q, 0) / lam
            - integrand.subs(q, 0) / lam ** 2
        )
        zero(
            value + polynomial.subs(p, p - z) / denominator,
            "ambient degree-one equivariant pushforward",
        )
        sw[0, j] = sp.cancel(value.subs(p, -lam))
        sw[1, j] = sp.cancel(value.subs(p, 0))
        sw[2, j] = sp.cancel(sp.diff(value, p).subs(p, 0))

    # M_0,2(P^1,1)=P^1 x P^1, psi_2=h_1-h_2; the twist is lambda^-2.
    h1, h2 = sp.symbols("h1 h2")
    states1, states2 = [1, h1], [1, h2]
    correlators = sp.zeros(2)
    for i in range(2):
        for j in range(2):
            correlators[i, j] = sum(
                sp.expand(states1[i] * states2[j] * (h1 - h2) ** k)
                .coeff(h1, 1).coeff(h2, 1) / (lam ** 2 * z ** (k + 1))
                for k in range(3)
            )
    metric_x = sp.Matrix([[-1 / lam ** 2, 1 / lam], [1 / lam, 0]])
    sx = metric_x.inv() * correlators
    unit = sp.Matrix([1, 1, 0])
    j_coefficient = z * sw * unit
    epsilon = sp.zeros(3, 1)
    for i, entry in enumerate(j_coefficient):
        laurent = sp.series(entry, z, 0, 1).removeO().expand()
        principal = sum(
            term for term in sp.Add.make_args(laurent)
            if term.as_powers_dict().get(z, 0) < 0
        )
        epsilon[i] = sp.cancel(entry - principal)
    u = epsilon.subs(z, 0)
    zero_matrix(u - sp.Matrix([1 / lam ** 2, -1 / lam ** 2, 0]), "primary shift")
    u_b, u_x = u[0], u[1]
    block = sp.zeros(3)
    block[0, 0] = u_b / z
    for i in range(2):
        for j in range(2):
            block[i + 1, j + 1] = sx[i, j] + (u_x / z if i == j else 0)
    r = (sw - block).applyfunc(sp.cancel)
    metric = sp.diag(1 / lam ** 2, metric_x)

    def adjoint(matrix):
        return metric.inv() * matrix.T * metric

    for entry in r:
        if sp.cancel(entry).as_numer_denom()[1].subs(z, 0) == 0:
            raise AssertionError("A negative loop power survives in R at degree one")
    zero_matrix(adjoint(r.subs(z, -z)) + r, "first-order symplectic identity")
    x = epsilon - u
    zero_matrix(x - sp.Matrix([
        1 / (lam + z) ** 2 - 1 / lam ** 2,
        -z / (lam ** 2 * (lam - z)),
        z / (lam ** 2 * (lam - z) ** 2),
    ]), "end translation from the ambient J-function")
    zero_matrix(x - z * r * unit, "same-R translation")
    kernel = ((adjoint(r.subs(z, w)) + r) / (w + z)).applyfunc(sp.cancel)
    for entry in kernel:
        if entry.as_numer_denom()[1].subs({w: 0, z: 0}) == 0:
            raise AssertionError("Bridge-kernel pole at the origin")

    h = sp.Symbol("h")
    a_x, a_b = lam + h, -lam - h
    e_b, e_x = lam ** 2, lam + h
    leg_euler = lam ** 2 * (lam + h)

    def constant(expression):
        return sp.cancel(expression.subs(h, 0))

    def push_x(expression):
        return sp.cancel(sp.diff(expression, h).subs(h, 0))

    end_x = e_x * a_b / leg_euler / (a_x - z)
    ends_from_legs = sp.Matrix([
        e_b * push_x(a_x / leg_euler / (a_b - z)),
        constant(end_x),
        push_x(end_x),
    ])
    zero_matrix(epsilon - ends_from_legs, "direct leg-Euler end contributions")
    bivector_bx = e_b * e_x / leg_euler / (a_b + w) / (a_x + z)
    bivector_xb = e_b * e_x / leg_euler / (a_x + w) / (a_b + z)
    direct_kernel = sp.zeros(3)
    direct_kernel[0, 1] = push_x(bivector_bx / e_x)
    direct_kernel[0, 2] = push_x(h * bivector_bx / e_x)
    direct_kernel[1, 0] = constant(bivector_xb / e_b)
    direct_kernel[2, 0] = push_x(bivector_xb / e_b)
    zero_matrix(kernel - direct_kernel, "same-R bridge versus direct family Euler gluing")
    return {
        "target": "W=P^2, B=point, E=C^2, X=P^1",
        "class": {"base_integral_class": 0, "fiber_degree": 1},
        "fixed_basis": ["1_B", "1_X", "h_X"],
        "ambient_coefficient": "Direct equivariant integration over Bl_Delta(P^2 x P^2)",
        "fixed_coefficient": "Direct integration over P^1 x P^1 with Euler twist lambda^-2",
        "u_coefficient": [str(u_b), str(u_x), "0"],
        "r_coefficient": [[str(r[i, j]) for j in range(3)] for i in range(3)],
        "negative_loop_powers_in_r": False,
        "symplectic_remainder": "zero_3_by_3",
        "translation_remainder": "zero_3_by_1",
        "bridge_kernel_regular_at_origin": True,
        "direct_leg_euler": str(leg_euler),
        "end_euler_remainder": "zero_3_by_1",
        "bridge_euler_remainder": "zero_3_by_3",
        "scope": "An exact admissible degree-one check, not an all-degree theorem.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = {
        "schema_version": 1,
        "proposition": "C_LOC",
        "mathematical_report": "report.md",
        "full_proposition_kernel_checked": False,
        "geometric_proof_status": "prose proof awaiting independent review",
        "novelty_status": "not certified; CGT Remark 3.7 anticipates the formula",
        "jacobian": jacobian_replay(),
        "all_orders_core": lean_binding(),
        "induction_replay": geometric_remainder_induction(),
        "joint_moments": joint_moment_example(),
        "degree_one_geometry": degree_one_projective_plane(),
    }
    certificate_path = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate_path.write_text(json.dumps(result, indent=2) + "\n")
    elif json.loads(certificate_path.read_text()) != result:
        raise AssertionError("Exact certificate differs from its replay")
    print(
        "PASS: typed Jacobian replay; source-bound zero-hole Lean core; "
        "joint moments; exact degree-one common-R, translation and bridge checks. "
        "Geometric proof and novelty still require independent review."
    )


if __name__ == "__main__":
    main()
