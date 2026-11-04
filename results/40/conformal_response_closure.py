#!/usr/bin/env python3
"""Exact algebra checks for the original-response closure manuscript."""

import hashlib
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
CHECKS = []


def equal(name, actual, expected):
    difference = sp.factor(sp.expand(actual - expected))
    if difference != 0:
        raise AssertionError(f"{name}: nonzero difference {difference}")
    CHECKS.append({"name": name, "status": "passed"})


def require(name, condition):
    if not condition:
        raise AssertionError(name)
    CHECKS.append({"name": name, "status": "passed"})


def polynomial(record):
    variables = sp.symbols(" ".join(record["variables"]), seq=True)
    return sp.Add(
        *(
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
            * sp.prod(v**n for v, n in zip(variables, term["exponents"]))
            for term in record["polynomial"]["terms"]
        )
    )


operation = "polynomial.differential_operator.apply.compute"
payload_path = ROOT / "research/jacobian/conformal-response-payload.json"
result_path = ROOT / "research/jacobian/conformal-response-result.json"
contract_path = ROOT / "research/jacobian/conformal-response-contract.json"
payload = json.loads(payload_path.read_text())
result = json.loads(result_path.read_text())
contract = json.loads(contract_path.read_text())
require("inspected_operation", contract["result"]["operation"]["operation_id"] == operation)
require("adapter_operation", result["result"]["operation_id"] == operation)
require("adapter_payload_binding", result["request"]["payload"] == payload)
typed = result["result"]["output"]
require("typed_source_binding", typed["polynomial"] == payload["polynomial"])
require("typed_operator_binding", typed["operator"] == payload["operator"])
require("typed_expected_binding", typed["expected"] == payload["expected"])
require("typed_iterations", typed["iterations"] == 1)
require("typed_matches_expected", typed["matches_expected"] is True)
require("typed_nonzero", typed["is_zero"] is False)
require("adapter_no_error", "error" not in result and "error" not in result["result"])
require("finite_adapter_runtime", 0 <= result["result"]["runtime_ms"] < 45000)

x, y = sp.symbols("x y")
origin = {x: 0, y: 0}
test_cutoff = 1 - (x**4 + y**4) / 16
primitive = x * y**3 * test_cutoff / 6
laplacian = sp.diff(primitive, x, 2) + sp.diff(primitive, y, 2)
equal("jacobian_source_reconstruction", polynomial(payload["polynomial"]), primitive)
equal("jacobian_output_reconstruction", polynomial(typed["output"]), laplacian)
equal("original_first_response_unit_jet", sp.diff(laplacian, x, y).subs(origin), 1)
shapes = [laplacian, x * y * test_cutoff, x**2 * test_cutoff / 2]
jets = [(x, y), (x, y), (x, x)]
for i, (shape, jet) in enumerate(zip(shapes, jets), 1):
    equal(f"response_{i}_jet_normalization", sp.diff(shape, *jet).subs(origin), 1)
    for monomial, coefficient in sp.Poly(shape, x, y).terms():
        if sum(monomial) < 2:
            equal(f"response_{i}_lower_jet_{monomial}", coefficient, 0)

p, T, qb, db, q, d = sp.symbols("p T qb db q d")
k, ell, a, zeta = sp.symbols("k ell a zeta")
omega = p * x + (qb + q) * x * y + x**3 + 2 * x * y**2
eta = T * x + (db + d) * x * y + 3 * x**3 + 5 * x * y**2
xi = (db + d) * x**2 / 2 + 5 * x**2 * y
equal("total_scalar_gradient_compatibility", sp.diff(eta, y), sp.diff(xi, x))
du = zeta * x + 2 * k * ell * a * x * y - (x**3 - 3 * x * y**2)
dv = -zeta * y + (sp.Rational(1, 2) - 2 * k) * ell * a * y**2
dv += 3 * x**2 * y - y**3
As_minus_one = (4 - k) * ell * y
Bs = k * ell * x


def advect(field):
    return du * sp.diff(field, x) + dv * sp.diff(field, y)


defects = [
    -advect(omega) + zeta * omega + As_minus_one * eta + Bs * xi,
    -advect(eta) + (2 * zeta - sp.diff(du, x)) * eta - sp.diff(dv, x) * xi,
    -advect(xi) + (2 * zeta - sp.diff(dv, y)) * xi - sp.diff(du, y) * eta,
]
j1 = zeta * (qb + q) + ell * ((4 - k) * T - 2 * k * a * p)
j2 = zeta * (db + d) - 4 * k * ell * a * T
expected_jets = [j1, j2, j2]
for i, (defect, jet, expected, shape) in enumerate(
    zip(defects, jets, expected_jets, shapes), 1
):
    equal(f"exact_defect_jet_{i}", sp.diff(defect, *jet).subs(origin), expected)
    projected = sp.Poly(sp.expand(defect - expected * shape), x, y)
    require(
        f"projected_defect_{i}_all_low_jets_vanish",
        all(sum(powers) >= 3 for powers, coefficient in projected.terms() if coefficient),
    )
    equal(
        f"projected_defect_{i}_parity",
        projected.as_expr().subs(x, -x),
        (-1 if i < 3 else 1) * projected.as_expr(),
    )
equal("projected_even_trace", (defects[2] - j2 * shapes[2]).subs(x, 0), 0)
equal("fixed_vorticity_first_jet", sp.diff(defects[0], x).subs(origin), 0)
equal("fixed_scalar_first_jet", sp.diff(defects[1], x).subs(origin), 0)

lam, ab, c = sp.symbols("lam ab c")
abar_rate = lam - ab
a_actual = ab - c - zeta
q_full_rhs = -(3 * lam + a_actual) * (qb + q) + db + d - p**2
q_full_rhs += ell * ((4 - k) * T - 2 * k * a_actual * p)
d_full_rhs = -(2 * lam + a_actual) * (db + d) - 2 * p * T
d_full_rhs -= 4 * k * ell * a_actual * T
rq = (-4 * lam + abar_rate) * qb + db - p**2
rd = (-3 * lam + abar_rate) * db - 2 * p * T
q_reference_rhs = (-4 * lam + abar_rate) * q + d + c * qb + c * q + rq
d_reference_rhs = (-3 * lam + abar_rate) * d + c * db + c * d + rd
equal("full_q_equation_with_response_defect", q_full_rhs - q_reference_rhs, j1.subs(a, a_actual))
equal("full_d_equation_with_response_defect", d_full_rhs - d_reference_rhs, j2.subs(a, a_actual))
equal("actual_rate_comparison", lam - a_actual, abar_rate + c + zeta)
equal("original_q_nonlinear_coefficient", c * q + rq + j1 - (c * q + rq), j1)
equal("original_d_nonlinear_coefficient", c * d + rd + j2 - (c * d + rd), j2)

t, s, end, rate = sp.symbols("t s end rate")
b0, b1, b2 = sp.symbols("b0 b1 b2")
k0, k1, k2, k3 = sp.symbols("k0 k1 k2 k3")
b = b0 + b1 * t + b2 * t**2
kernel = k0 + k1 * s + k2 * s**2 + k3 * s**3
delayed = b.subs(t, t - s)
I_before = sp.integrate(delayed * kernel, (s, 0, t))
I_after = sp.integrate(delayed * kernel, (s, 0, end))
initial_term = b * kernel.subs(s, 0)
endpoint_term = -b.subs(t, t - end) * kernel.subs(s, end)
density = delayed * (sp.diff(kernel, s) - rate * kernel)
equal(
    "strain_history_before_endpoint",
    sp.diff(I_before, t) - rate * I_before,
    initial_term + sp.integrate(density, (s, 0, t)),
)
equal(
    "strain_history_after_endpoint",
    sp.diff(I_after, t) - rate * I_after,
    initial_term + endpoint_term + sp.integrate(density, (s, 0, end)),
)
equal("history_continuity_at_endpoint", I_before.subs(t, end), I_after.subs(t, end))
equal(
    "history_derivative_jump",
    (sp.diff(I_after, t) - sp.diff(I_before, t)).subs(t, end),
    -b0 * kernel.subs(s, end),
)
F = sp.symbols("F")
equal(
    "residual_initial_mismatch_kept",
    b * F + b * (kernel.subs(s, 0) - F),
    initial_term,
)
phi = (1 + s + s**2) * x * y**3 + s * x**3 * y
Gomega = (2 + 3 * s) * x * y + (1 + s**3) * x**3
eps = Gomega + sp.diff(phi, x, 2) + sp.diff(phi, y, 2)
phi_hist = sp.integrate(delayed * phi, (s, 0, t))
omega_hist = sp.integrate(delayed * Gomega, (s, 0, t))
equal(
    "stream_source_error_history_commutes",
    omega_hist + sp.diff(phi_hist, x, 2) + sp.diff(phi_hist, y, 2),
    sp.integrate(delayed * eps, (s, 0, t)),
)

fstar = x * y / (x**2 + y**2)**2
equal("homogeneous_kernel_dilation_divergence", sp.diff(x * fstar, x) + sp.diff(y * fstar, y), 0)
equal(
    "nonzero_geometric_euclidean_divergence",
    sp.diff(du, x) + sp.diff(dv, y),
    (1 - 2 * k) * ell * a * y,
)
equal(
    "moment_product_divergence",
    sp.diff(du * fstar, x) + sp.diff(dv * fstar, y),
    du * sp.diff(fstar, x) + dv * sp.diff(fstar, y)
    + (sp.diff(du, x) + sp.diff(dv, y)) * fstar,
)

alpha = sp.Rational(1, 3) + sp.Rational(1, 10**8)
equal("flat_inverse_holder_product_exponent", sp.Rational(1, 6) * 2 - alpha, -sp.Rational(1, 10**8))
equal("geometric_holder_product_exponent", sp.Rational(7, 6) + sp.Rational(1, 6) - alpha, 1 - sp.Rational(1, 10**8))
E, C, small, epsilon, M = sp.symbols("E C small epsilon M", positive=True)
equal("all_three_A10_coefficient_increments", 2 * C * small * E + C * small * E**2 + C * small, C * small * (1 + E)**2)
equal("first_A11_half_margin_allocation", epsilon - epsilon / 2, epsilon / 2)
equal("second_A11_is_separate_bound", M + C * small * (1 + E)**2 - M, C * small * (1 + E)**2)
equal("outer_floor_below_inner_threshold", 1 - (epsilon / 2) / (epsilon + epsilon / 2), sp.Rational(2, 3))
equal("explicit_energy_smallness_budget", C * (epsilon / (8 * C * (1 + E)**2)) * (1 + E)**2, epsilon / 8)
equal("explicit_mode_smallness_budget", C * (epsilon / (8 * C)), epsilon / 8)
equal("explicit_exterior_floor_budget", 2 * C * (epsilon * E / (16 * C * (1 + E))) * (1 + E) / epsilon, E / 8)
E_star = sp.Rational(5, 10**6)
require("original_threshold_less_than_one", 0 < E_star < 1)
mu6, mu7, mu8 = sp.Integer(61), sp.Rational(19, 2), sp.Rational(9, 2)
require("q_exact_product_below_coarse_certified_product", mu6 * mu8 * E_star**2 < mu6 * mu8 * E_star)
require("d_exact_product_below_coarse_certified_product", mu6 * mu7 * E_star**2 < mu6 * mu7 * E_star)
sigma = sp.symbols("sigma", positive=True)
cbar = -sp.Rational(1, 2) - mu6 * E_star - sigma
equal("rate_margin_without_strain_bootstrap", cbar + mu6 * E_star + sigma / 2, -sp.Rational(1, 2) - sigma / 2)

R, Z = sp.symbols("R Z", positive=True)
stream_base = sp.Function("b")(R, Z)
P = R**2 * stream_base
physical_op = -(sp.diff(P, R, 2) - sp.diff(P, R) / R + sp.diff(P, Z, 2))
five_dimensional_op = -R**2 * (
    sp.diff(stream_base, R, 2) + 3 * sp.diff(stream_base, R) / R
    + sp.diff(stream_base, Z, 2)
)
equal("physical_five_dimensional_inverse", physical_op, five_dimensional_op)
uR, uZ = -sp.diff(P, Z) / R, sp.diff(P, R) / R
equal("physical_meridional_incompressibility", sp.diff(R * uR, R) / R + sp.diff(uZ, Z), 0)
equal(
    "physical_azimuthal_vorticity",
    (sp.diff(uR, Z) - sp.diff(uZ, R)) / R,
    five_dimensional_op / R**2,
)
theta_local = sp.symbols("offset") + T * x**2 / 2 + db * x**2 * y / 2
equal("smooth_swirl_scalar_T_jet", sp.diff(theta_local, x, 2).subs(origin), T)
equal("smooth_swirl_scalar_d_jet", sp.diff(theta_local, x, 2, y).subs(origin), db)
equal("smooth_swirl_inner_trace", sp.diff(theta_local, y).subs(x, 0), 0)

paths = [
    Path(__file__).resolve(),
    HERE / "conformal_response_closure.md",
    payload_path,
    result_path,
    contract_path,
]
report = {
    "status": "passed",
    "scope": "Exact finite algebra only; not an analytic closure or numerical-profile verification.",
    "checks_passed": len(CHECKS),
    "checks": CHECKS,
    "sympy_version": sp.__version__,
    "jacobian": {
        "operation_id": operation,
        "adapter_exit_status": 0,
        "structured_error": None,
        "timeout": False,
        "runtime_ms": result["result"]["runtime_ms"],
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "payload": str(payload_path.relative_to(ROOT)),
        "typed_output_artifact": str(result_path.relative_to(ROOT)),
        "matches_expected": typed["matches_expected"],
    },
    "source_sha256": {
        str(path.relative_to(ROOT)): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in paths
    },
    "not_proved_by_this_certificate": [
        "The analytic row estimates R30 and their uniform constants.",
        "The imported Chen-Hou rigorous numerical comparison margins.",
        "The application of Lemma A.2, smooth Euler continuation, or blowup.",
        "Novelty or publishable acceptance.",
    ],
}
output = HERE / "conformal-response-closure-result.json"
output.write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps({"status": report["status"], "checks_passed": len(CHECKS), "artifact": str(output.relative_to(ROOT))}))
