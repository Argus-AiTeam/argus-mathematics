#!/usr/bin/env python3
"""Exact support for proof.tex; no topological or novelty certification."""

import argparse
import copy
import json
import sys
from pathlib import Path

import sympy as sp


class VerificationError(Exception):
    pass


def require(condition, message):
    if not condition:
        raise VerificationError(message)


def equal(actual, expected, message):
    if isinstance(actual, sp.MatrixBase):
        require(actual.shape == expected.shape, message + ": shape")
        for value in actual - expected:
            require(sp.simplify(value) == 0, message + ": nonzero entry")
    else:
        require(sp.simplify(actual - expected) == 0, message)


def rational(pair):
    require(len(pair) == 2 and pair[1] > 0, "invalid rational")
    return sp.Rational(pair[0], pair[1])


def signs(data):
    q = sp.symbols("q0:2")
    p = sp.symbols("p0:2")
    hamiltonian = sp.Function("H")(*q, *p)
    coordinates = q + p
    velocity, force = data["field_coefficients"]
    field = sp.Matrix(
        [velocity * sp.diff(hamiltonian, v) for v in p]
        + [force * sp.diff(hamiltonian, v) for v in q]
    )
    omega = sp.zeros(4)
    pair = sp.Matrix(data["omega_pair"])
    equal(pair, sp.Matrix([[0, -1], [1, 0]]), "omega = dp wedge dq")
    for i in range(2):
        omega[i, i + 2], omega[i + 2, i] = pair[0, 1], pair[1, 0]
    gradient = sp.Matrix([sp.diff(hamiltonian, v) for v in coordinates])
    equal(field.T * omega, -gradient.T, "Hamiltonian contraction sign")
    a, b = data["action_coefficients"]
    action_density = a * sum(p[i] * field[i] for i in range(2)) + b * hamiltonian
    lie = sp.Matrix(
        [
            field[j + 2] + sum(p[i] * sp.diff(field[i], q[j]) for i in range(2))
            for j in range(2)
        ]
        + [
            sum(p[i] * sp.diff(field[i], p[j]) for i in range(2))
            for j in range(2)
        ]
    )
    equal(
        lie,
        sp.Matrix([sp.diff(action_density, v) for v in coordinates]),
        "Cartan action primitive",
    )

    x, X, old_p, P, dx, dX, dp = sp.symbols("x X old_p P dx dX dp")
    ca, cxp, cXp = data["mixed_primitive_coefficients"]
    differential = (
        ca * (P * dX - old_p * dx)
        + cxp * (old_p * dx + x * dp)
        + cXp * (old_p * dX + X * dp)
    )
    equal(
        differential,
        (P - old_p) * dX + (x - X) * dp,
        "mixed primitive and both graph signs",
    )

    t, q0, p0, current_q, current_p = sp.symbols("t q0 p0 current_q current_p")
    reverse_flow = sp.Matrix([q0 - t + t**2 / 2, p0 + t])
    reverse_h = data["reverse_hamiltonian_factor"] * ((1 - t) * current_p + current_q)
    equal(
        reverse_flow.diff(t),
        sp.Matrix([sp.diff(reverse_h, current_p), -sp.diff(reverse_h, current_q)]),
        "reverse of the nonautonomous flow H_t=t*p+q",
    )
    kinetic_sigma = -t * old_p**2 / 2
    potential_sigma = -t * X**2 / 2
    equal(X + sp.diff(kinetic_sigma, old_p), X - t * old_p, "kinetic shear input")
    equal(old_p + sp.diff(potential_sigma, X), old_p - t * X, "potential shear output")


def radial(data):
    alpha, momentum, H = sp.symbols("alpha momentum H")
    zeta = sp.Function("zeta")(alpha)
    xi = sp.Function("xi")(momentum)
    extended = H * zeta * xi
    c_position, c_momentum = data["radial_coefficients"]
    equal(
        sp.diff(extended, momentum),
        c_position * H * zeta * sp.diff(xi, momentum),
        "radial position equation",
    )
    equal(
        -sp.diff(extended, alpha),
        c_momentum * H * xi * sp.diff(zeta, alpha),
        "radial momentum equation",
    )
    padding = rational(data["plateau_padding"])
    require(padding > 0, "the radial trajectory must stay strictly inside the plateau")
    M, t = sp.symbols("M t", nonnegative=True)
    equal(M + padding - M * t, M * (1 - t) + padding, "plateau margin")
    require(data["initial_radial_momentum"] == 0, "initial cylinder radial momentum")


def cutoff(data):
    X = sp.symbols("X0:2")
    z = sp.symbols("z0:2")
    w = sp.symbols("w0:2")
    p = sp.symbols("p0:2")
    zeta = sp.Function("zeta")(*X)
    beta = sp.Function("beta")(*z)
    chi = sp.Function("chi")(*w)
    kappa = zeta * beta * chi
    shifted = tuple(X[i] + kappa * z[i] for i in range(2))
    composed = sp.Function("F")(*shifted, *w)
    sigma = sp.Function("sigma")(*X, *p)
    hat = composed + sigma - sum(z[i] * p[i] for i in range(2))
    a = [composed.fdiff(i + 1) for i in range(2)]
    old_w = [composed.fdiff(i + 3) for i in range(2)]
    az = sum(a[i] * z[i] for i in range(2))
    cp, cz, cw, cX = (data[key] for key in ("p", "z", "w", "X"))
    for i in range(2):
        equal(
            sp.diff(hat, p[i]),
            cp[0] * sp.diff(sigma, p[i]) + cp[1] * z[i],
            "full cutoff p equation",
        )
        equal(
            sp.diff(hat, z[i]),
            cz[0] * kappa * a[i] + cz[1] * az * sp.diff(kappa, z[i]) + cz[2] * p[i],
            "full cutoff z equation",
        )
        equal(
            sp.diff(hat, w[i]),
            cw[0] * old_w[i] + cw[1] * az * sp.diff(kappa, w[i]),
            "full cutoff w equation",
        )
        equal(
            sp.diff(hat, X[i]),
            cX[0] * a[i] + cX[1] * az * sp.diff(kappa, X[i]) + cX[2] * sp.diff(sigma, X[i]),
            "full cutoff X equation",
        )
        equal(sp.diff(kappa, z[i]), zeta * chi * sp.diff(beta, z[i]), "beta derivative")
        equal(sp.diff(kappa, w[i]), zeta * beta * sp.diff(chi, w[i]), "chi derivative")
        equal(sp.diff(kappa, X[i]), beta * chi * sp.diff(zeta, X[i]), "spatial derivative")
    reference = sp.Function("g")(*X, *w) - sum(z[i] * p[i] for i in range(2))
    for i in range(2):
        equal(
            sp.diff(hat - reference, p[i]),
            data["error_p_factor"] * sp.diff(sigma, p[i]),
            "full-vertical error: exact cancellation of -z.p",
        )


def scalar_blocks(data):
    a, b, c, s, j, u, v = sp.symbols("a b c s j u v")
    old_p_sign, graph_x_sign, graph_identity = data["differential_coefficients"]
    inverse_p, inverse_subtraction, inverse_s = data["inverse_coefficients"]
    h = b * u + a * v
    left = sp.Matrix(
        [[a, c, 0, 0], [b, a, old_p_sign, 0], [graph_x_sign, 0, s, graph_identity + j - 1]]
    )
    right = sp.Matrix(
        [
            [u, 0, 0],
            [v, 0, 0],
            [h, inverse_p, 0],
            [(u + inverse_subtraction * s * h) / j, inverse_s * s / j, 1 / j],
        ]
    )
    return (a, b, c, s, j, u, v), left, right


def regularity(data):
    variables, left, right = scalar_blocks(data)
    a, b, c, s, j, u, v = variables
    x, w, p, X = sp.symbols("x w p X")
    old = b * x**2 / 2 + a * x * w + c * w**2 / 2
    sigma = (j - 1) * X * p + s * p**2 / 2
    equations = sp.Matrix([sp.diff(old, w), sp.diff(old, x) - p, X + sp.diff(sigma, p) - x])
    equal(left, equations.jacobian([x, w, p, X]), "scalar jet differential")
    product = (left * right).applyfunc(sp.cancel)
    equal(product, sp.diag(a * u + c * v, 1, 1), "scalar right inverse product")
    require(
        [[sp.sstr(product[i, j]) for j in range(3)] for i in range(3)]
        == data["scalar_product"],
        "declared scalar product",
    )
    require(data["old_hessian_may_be_zero"] is True, "no inverse of the old fiber Hessian")
    require(all(not sp.denom(sp.cancel(entry)).has(c) for entry in right), "unallowed inverse of c")

    d, r = sp.symbols("d r", integer=True, positive=True)
    A = sp.MatrixSymbol("A", r, d)
    B = sp.MatrixSymbol("B", d, d)
    C = sp.MatrixSymbol("C", r, r)
    S = sp.MatrixSymbol("S", d, d)
    J = sp.MatrixSymbol("J", d, d)
    U = sp.MatrixSymbol("U", d, r)
    V = sp.MatrixSymbol("V", r, r)
    Z = sp.ZeroMatrix
    I = sp.Identity
    K = B * U + A.T * V
    differential = sp.BlockMatrix(
        [[A, C, Z(r, d), Z(r, d)], [B, A.T, -I(d), Z(d, d)], [-I(d), Z(d, r), S, J]]
    )
    inverse = sp.BlockMatrix(
        [
            [U, Z(d, d), Z(d, d)],
            [V, Z(r, d), Z(r, d)],
            [K, -I(d), Z(d, d)],
            [J.I * (U - S * K), J.I * S, J.I],
        ]
    )
    product = sp.block_collapse(differential * inverse)
    sizes = [r, d, d]
    for i in range(3):
        for j in range(3):
            expected = A * U + C * V if i == j == 0 else I(sizes[i]) if i == j else Z(sizes[i], sizes[j])
            difference = sp.expand(product.blocks[i, j] - expected)
            # SymPy leaves this scalar identity power unevaluated for symbolic d.
            difference = difference.xreplace({(-I(d)) ** 2: I(d)}).doit()
            require(difference == Z(sizes[i], sizes[j]), "dimension-independent noncommutative block identity")


def errors(data):
    delta, Bx, Bw, Kchi, Kbeta, C0, C1, S0, S1 = sp.symbols(
        "delta Bx Bw Kchi Kbeta C0 C1 S0 S1", nonnegative=True
    )
    value_terms = [delta * Bx, C0, S0]
    derivative_terms = [Bw, delta * Bx * Kchi, Bx, delta * Bx * Kbeta, C1, S1]
    require(len(data["value_coefficients"]) == len(value_terms), "value error coefficient count")
    require(len(data["vertical_coefficients"]) == len(derivative_terms), "vertical error coefficient count")
    claimed_value = sum(c * term for c, term in zip(data["value_coefficients"], value_terms))
    claimed_derivative = sum(c * term for c, term in zip(data["vertical_coefficients"], derivative_terms))
    shift_value = 2 * delta * Bx
    shift_w = 2 * Bw + shift_value * Kchi
    shift_z = Bx + shift_value * Kbeta
    equal(claimed_value, shift_value + C0 + S0, "uniform value error")
    equal(claimed_derivative, shift_w + shift_z + C1 + S1, "full-vertical error budget")

    c, delta = sp.symbols("c delta", positive=True)
    C = sp.symbols("C", nonnegative=True)
    delta1 = c / (data["log_denominator"] * delta * (data["log_shift"] + C))
    margin = c - C * delta * delta1
    lower = rational(data["gradient_fraction"])
    equal(margin - lower * c, c / (4 * (1 + C)), "strict logarithmic-cutoff margin")
    require(lower > 0, "positive outer gradient margin")
    radius, inner, T = sp.symbols("radius inner T", positive=True)
    theta = sp.Function("theta")(sp.log(radius / inner) / T)
    equal(
        radius * sp.diff(theta, radius),
        data["log_derivative_factor"] * theta.fdiff(1) / T,
        "logarithmic derivative",
    )
    equal(sp.log((inner * sp.exp(T)) / inner) / T, 1, "finite logarithmic support endpoint")

    X, z, p, w1, w2 = sp.symbols("X z p w1 w2")
    reference = -(1 + X) * w1**2 + w2**2 - z * p
    shifted = -(1 + X + z / 2) * w1**2 + w2**2 - z * p
    error = shifted - reference
    equal(sp.diff(error, p), 0, "error is independent of the unbounded momentum axis")
    equal(error.subs({w1: 1, z: 1}), rational(data["noncompact_error_value"]), "noncompact but bounded-axis error example")


def split(data):
    t, z, p = sp.symbols("t z p", real=True)
    negative, positive, mixed = data["path_coefficients"]
    form = negative * t * z**2 + positive * t * p**2 + mixed * (1 - t) * z * p
    equal(form.subs(t, 0), -z * p, "initial split cross term")
    equal(form.subs(t, 1), -z**2 + p**2, "standard balanced endpoint")
    hessian = sp.hessian(form, (z, p))
    coefficients = data["squared_gradient_coefficients"]
    require(len(coefficients) == 3, "split polynomial coefficient count")
    polynomial = coefficients[0] * t**2 + coefficients[1] * t + coefficients[2]
    equal(hessian * hessian, polynomial * sp.eye(2), "split gradient norm")
    center, lower = rational(data["square_center"]), rational(data["lower_squared_margin"])
    equal(polynomial, 5 * (t - center)**2 + lower, "positive completed square")
    require(lower > 0, "split path must remain nondegenerate")
    equal(sp.trace(hessian), 0, "balanced trace")
    equal(hessian.det(), -polynomial, "one negative and one positive direction")


def singular_model(data):
    X, w, z, p, epsilon = sp.symbols("X w z p epsilon")
    hat = (X + z) * w + w**3 / 3 - epsilon * p**2 / 2 - z * p
    gradient = sp.Matrix([sp.diff(hat, v) for v in (w, z, p)])
    base_linear, base_quadratic = data["critical_base_coefficients"]
    critical = {
        X: base_linear * epsilon * w + base_quadratic * w**2,
        z: data["critical_z_factor"] * epsilon * w,
        p: data["critical_p_factor"] * w,
    }
    equal(gradient.subs(critical), sp.zeros(3, 1), "supported exact critical-locus correspondence")
    equal(sp.diff(hat, X).subs(critical), w, "supported output momentum")
    linear, quadratic = data["hessian_determinant_coefficients"]
    equal(sp.hessian(hat, (w, z, p)).det(), linear * epsilon + quadratic * w, "vertical Hessian determinant")
    minor = gradient.jacobian([X, w, z, p])[:, :3].det()
    equal(minor, data["full_rank_minor"], "full regularity despite singular fiber Hessian")
    point = [rational(value) for value in data["singular_critical_point"]]
    substitution = dict(zip((X, w, z, p), point))
    substitution[epsilon] = sp.Rational(1, 2)
    equal(gradient.subs(substitution), sp.zeros(3, 1), "singular-Hessian exact point")
    equal(sp.hessian(hat, (w, z, p)).det().subs(substitution), 0, "fiber Hessian really singular")
    require(minor != 0, "singular model still a full Morse family")
    old_x = sp.symbols("old_x")
    old = old_x * w + w**3 / 3
    equal(sp.diff(old, w, 2).subs(w, 0), 0, "old Hessian may also be singular")
    equal(sp.diff(old, w, old_x), 1, "old full equation remains regular")


def transition_model(data):
    X, w, z, p = sp.symbols("X w z p")
    zeta = sp.Rational(1, 2) + X / 10
    hat = (X + zeta * z) * w + w**3 / 3 - z * p
    gradient = sp.Matrix([sp.diff(hat, v) for v in (w, z, p)])
    point = dict(zip((X, w, z, p), [rational(value) for value in data["critical_point"]]))
    equal(gradient.subs(point), sp.zeros(3, 1), "critical point in spatial cutoff transition")
    require(0 < zeta.subs(point) < 1 and sp.diff(zeta, X) != 0, "genuine nonconstant spatial transition")
    old_momentum = w.subs(point)
    auxiliary = p.subs(point)
    output = sp.diff(hat, X).subs(point)
    equal(old_momentum, rational(data["old_momentum"]), "old momentum")
    equal(auxiliary, rational(data["auxiliary_momentum"]), "auxiliary rescaled momentum")
    equal(output, rational(data["generated_momentum"]), "generated momentum outside support")
    equal(output, old_momentum, "identity transport despite auxiliary rescaling")
    require(auxiliary != old_momentum, "the adversarial example must distinguish the two momenta")
    require(gradient.jacobian([X, w, z, p]).subs(point).rank() == 3, "transition full regularity")


def endpoint(data):
    X, w = sp.symbols("X w")
    degenerate = w**4
    equal(sp.diff(degenerate, w), data["quartic_gradient_coefficient"] * w**3, "quartic critical equation")
    equal(sp.diff(degenerate, w, 2).subs(w, 0), data["quartic_hessian_at_zero"], "quartic degenerate Hessian")
    differential = sp.Matrix([sp.diff(degenerate, w)]).jacobian([X, w]).subs(w, 0)
    require(differential.rank() == data["quartic_full_rank"] == 0, "quartic is not a Morse family")

    d, r = sp.symbols("d r", integer=True, positive=True)
    B = sp.MatrixSymbol("B", r, d)
    H = sp.MatrixSymbol("H", r, r)
    differential = sp.BlockMatrix([[B, H]])
    vertical = sp.BlockMatrix([[sp.ZeroMatrix(d, r)], [sp.Identity(r)]])
    require(sp.block_collapse(differential * vertical) == H, "vertical tangent-kernel identity")
    require(data["requires_full_regularity"] is True, "endpoint theorem must keep full regularity")
    require(data["requires_projection_diffeomorphism"] is True, "endpoint theorem must keep projection hypothesis")
    u, s = sp.symbols("u s", nonnegative=True)
    m = 20 + u
    d = 2 * m + 10
    p = m + d * s
    coefficients = data["dimension_margin_coefficients"]
    equal(p - 20, coefficients[0] * u + coefficients[1] * s + coefficients[2] * u * s, "all finite stabilizations retain p>=20")


def sparse_polynomial(expression, variables):
    polynomial = sp.Poly(expression, *variables, domain=sp.QQ)
    return {
        "terms": [
            {
                "coefficient": {"num": str(coefficient.p), "den": str(coefficient.q)},
                "exponents": list(exponents),
            }
            for exponents, coefficient in polynomial.terms()
            if coefficient != 0
        ]
    }


def typed_rational(expression, variables):
    numerator, denominator = sp.fraction(sp.cancel(expression))
    leading = sp.Poly(denominator, *variables, domain=sp.QQ).LC()
    numerator, denominator = sp.expand(numerator / leading), sp.expand(denominator / leading)
    return {
        "domain": "QQ",
        "variables": [str(variable) for variable in variables],
        "numerator": sparse_polynomial(numerator, variables),
        "denominator": sparse_polynomial(denominator, variables),
    }


def typed_matrix(value, variables):
    names = [str(variable) for variable in variables]
    return {
        "variables": names,
        "entries": [
            [typed_rational(value[i, j], variables) for j in range(value.cols)]
            for i in range(value.rows)
        ],
    }


def jacobian_payload(data):
    variables, left, right = scalar_blocks(data)
    return {"left": typed_matrix(left, variables), "right": typed_matrix(right, variables)}


def jacobian(meta, block_data, records):
    operation = "matrix.symbolic.multiply.compute"
    require(meta["operation_id"] == operation, "Jacobian operation id")
    variables, left, right = scalar_blocks(block_data)
    require(meta["variables"] == [str(variable) for variable in variables], "Jacobian field order")
    require(meta["left_shape"] == [3, 4] and meta["right_shape"] == [4, 3], "Jacobian matrix dimensions")
    require(records["payload"] == jacobian_payload(block_data), "exact retained Jacobian payload")
    output, status = records["output"], records["status"]
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(status["timed_out"] is False, "Jacobian timeout is not evidence")
    require(status["structured_error"] is None, "Jacobian error is not evidence")
    require(status["outcome"] == "completed", "incomplete Jacobian output is not evidence")
    require(status["contract_inspected_before_execution"] is True, "Jacobian contract not inspected")
    require(status["operation_id"] == operation, "adapter status operation id")
    require(output["schema_version"] == 1, "Jacobian envelope schema")
    require(output["protocol_version"] == meta["protocol_version"] == status["protocol_version"], "Jacobian protocol")
    require(output["server"]["version"] == meta["server_version"] == status["server_version"], "Jacobian server version")
    require(output["tool"] == "math.run", "Jacobian execution record")
    require(output.get("error") is None, "Jacobian structured error")
    result = output["result"]
    require(result["operation_id"] == operation, "Jacobian result operation id")
    expected = typed_matrix((left * right).applyfunc(sp.cancel), variables)
    require(result["output"] == expected, "exact typed Jacobian product")
    require(result["runtime_ms"] >= 0, "invalid recorded runtime")

    rejected = records["rejected_output"]
    rejected_status = records["rejected_status"]
    require(rejected["ok"] is False, "rejected adapter input must remain a rejection")
    require(rejected_status["adapter_exit_code"] == 2, "rejected adapter exit code")
    require(rejected_status["mathematical_conclusion"] == "none", "an invalid request cannot support the theorem")
    require(rejected_status["structured_error"] == rejected["error"], "exact retained rejection")
    require(rejected["error"]["data"]["code"] == "INVALID_REQUEST", "rejection classification")
    require(rejected["error"]["data"]["operation_id"] == operation, "rejected operation id")
    require(
        rejected["error"]["data"]["errors"][0]["code"] == "matrix.budget_exceeded",
        "rejected denominator admission bound",
    )
    a, b, c, s, j, u, v = variables
    t = sp.Symbol("t")
    rejected_variables = (a, b, c, s, t, u, v)
    expected_rejected = {
        "left": typed_matrix(left.subs(j, 1 + t), rejected_variables),
        "right": typed_matrix(right.subs(j, 1 + t), rejected_variables),
    }
    require(records["rejected_payload"] == expected_rejected, "first exact payload must not be overwritten")


def load_jacobian(meta, directory):
    rejected = meta["rejected_attempt"]
    paths = {
        "payload": meta["payload"],
        "output": meta["typed_output"],
        "status": meta["adapter_status"],
        "rejected_payload": rejected["payload"],
        "rejected_output": rejected["typed_output"],
        "rejected_status": rejected["adapter_status"],
    }
    return {key: json.loads((directory / path).read_text()) for key, path in paths.items()}


CHECKS = {
    "symplectic_action_signs": signs,
    "radial_plateau": radial,
    "full_cutoff_chain_rule": cutoff,
    "regularity_block_identity": regularity,
    "uniform_error_and_logarithmic_margin": errors,
    "fixed_split_homotopy": split,
    "supported_singular_hessian_model": singular_model,
    "spatial_transition_model": transition_model,
    "endpoint_hessian_boundary_and_dimension": endpoint,
}


MUTATIONS = [
    ("symplectic_action_signs", "field_coefficients", [1, 1]),
    ("symplectic_action_signs", "action_coefficients", [1, 1]),
    ("symplectic_action_signs", "mixed_primitive_coefficients", [1, -1, 1]),
    ("symplectic_action_signs", "reverse_hamiltonian_factor", 1),
    ("radial_plateau", "radial_coefficients", [1, 1]),
    ("radial_plateau", "plateau_padding", [0, 1]),
    ("full_cutoff_chain_rule", "z", [1, 0, -1]),
    ("full_cutoff_chain_rule", "w", [1, 0]),
    ("full_cutoff_chain_rule", "X", [1, 0, 1]),
    ("full_cutoff_chain_rule", "error_p_factor", -1),
    ("regularity_block_identity", "inverse_coefficients", [-1, 1, 1]),
    ("uniform_error_and_logarithmic_margin", "vertical_coefficients", [2, 0, 1, 2, 1, 1]),
    ("uniform_error_and_logarithmic_margin", "vertical_coefficients", [2, 2, 1, 0, 1, 1]),
    ("uniform_error_and_logarithmic_margin", "log_denominator", 1),
    ("fixed_split_homotopy", "path_coefficients", [-1, 1, 1]),
    ("fixed_split_homotopy", "lower_squared_margin", [0, 1]),
    ("supported_singular_hessian_model", "critical_z_factor", 1),
    ("spatial_transition_model", "generated_momentum", [2, 5]),
    ("endpoint_hessian_boundary_and_dimension", "requires_full_regularity", False),
]

ADAPTER_MUTATIONS = [
    ("payload", ["left", "entries", 1, 2, "numerator", "terms", 0, "coefficient", "num"], "1"),
    ("output", ["result", "output", "entries", 0, 0, "numerator", "terms", 0, "coefficient", "num"], "-1"),
    ("status", ["adapter_exit_code"], 2),
    ("status", ["timed_out"], True),
    ("status", ["outcome"], "UNKNOWN"),
    ("rejected_status", ["mathematical_conclusion"], "supports"),
]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("certificate", nargs="?", type=Path, default=Path(__file__).with_name("exact_certificate.json"))
    parser.add_argument("--self-test", action="store_true")
    parser.add_argument("--emit-jacobian-payload", action="store_true")
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())
    require(certificate["format"] == "transport-exact-v1", "certificate format")
    require(certificate["claim"] == "HT-exact-calculations", "certificate claim")
    require(certificate["topology_machine_verified"] is False, "scope must not claim machine-verified topology")
    require(certificate["novelty_certified"] is False, "scope must not claim novelty")
    checks = certificate["checks"]
    if args.emit_jacobian_payload:
        regularity(checks["regularity_block_identity"])
        print(json.dumps(jacobian_payload(checks["regularity_block_identity"]), indent=2))
        return
    require(set(checks) == set(CHECKS), "exact check-group coverage")
    for name, check in CHECKS.items():
        check(checks[name])
    meta = certificate["jacobian"]
    records = load_jacobian(meta, args.certificate.parent)
    jacobian(meta, checks["regularity_block_identity"], records)
    rejected = 0
    if args.self_test:
        for name, field, value in MUTATIONS:
            modified = copy.deepcopy(checks[name])
            modified[field] = value
            try:
                CHECKS[name](modified)
            except VerificationError:
                rejected += 1
            else:
                raise VerificationError("mutation survived: " + name + "." + field)
        for record, keys, value in ADAPTER_MUTATIONS:
            modified = copy.deepcopy(records)
            target = modified[record]
            for key in keys[:-1]:
                target = target[key]
            target[keys[-1]] = value
            try:
                jacobian(meta, checks["regularity_block_identity"], modified)
            except VerificationError:
                rejected += 1
            else:
                raise VerificationError("adapter mutation survived: " + record + "." + str(keys))
    print(json.dumps({
        "result": "PASS",
        "claim": certificate["claim"],
        "exact_check_groups": len(CHECKS) + 1,
        "substantive_mutations_rejected": rejected,
        "jacobian_operation": meta["operation_id"],
        "jacobian_product": "diag(a*u+c*v,1,1)",
        "rejected_adapter_input": "preserved INVALID_REQUEST; no mathematical conclusion",
        "topology_machine_verified": False,
        "novelty_certified": False,
        "independent_review": "Host-invoked; not performed by this script",
    }, indent=2))


if __name__ == "__main__":
    try:
        main()
    except VerificationError as error:
        print("FAIL: " + str(error), file=sys.stderr)
        sys.exit(1)
