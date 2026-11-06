#!/usr/bin/env python3
"""Replay exact algebra/order support; the analytic theorem is proved in report.md."""

import argparse
from collections import Counter
from copy import deepcopy
from fractions import Fraction
import json
from pathlib import Path
import sys

import sympy as sp


ROOT = Path(__file__).resolve().parent


class CertificateError(ValueError):
    pass


class Checks:
    def __init__(self):
        self.counts = Counter()

    def equal(self, name, actual, expected, category="arithmetic"):
        if actual != expected:
            raise CertificateError(f"{name}: got {actual!r}, expected {expected!r}")
        self.counts[category] += 1

    def identity(self, name, expression):
        self.equal(name, sp.cancel(expression), 0, "symbolic_identities")

    def require(self, name, condition, category="input_integrity"):
        self.equal(name, bool(condition), True, category)


def read_json(path):
    return json.loads(Path(path).read_text(encoding="utf-8"))


def sparse_polynomial(data, variables, checks, label):
    answer = sp.Integer(0)
    previous = None
    for index, term in enumerate(data["terms"]):
        exponents = term["exponents"]
        checks.require(f"{label}.{index}.exponents",
                       len(exponents) == len(variables)
                       and all(type(e) is int and 0 <= e <= 64 for e in exponents))
        key = tuple(exponents)
        checks.require(f"{label}.{index}.term_order",
                       previous is None or previous > key)
        previous = key
        numerator = term["coefficient"]["num"]
        denominator = term["coefficient"]["den"]
        n, d = int(numerator), int(denominator)
        checks.require(f"{label}.{index}.canonical_rational",
                       d > 0 and n != 0 and str(n) == numerator
                       and str(d) == denominator
                       and Fraction(n, d).numerator == n
                       and Fraction(n, d).denominator == d)
        answer += sp.Rational(n, d) * sp.prod(
            v ** e for v, e in zip(variables, exponents)
        )
    return answer


def rational_function(data, variables, checks, label):
    checks.equal(f"{label}.variables", data["variables"],
                 [str(v) for v in variables], "input_integrity")
    checks.equal(f"{label}.domain", data["domain"], "QQ", "input_integrity")
    numerator = sparse_polynomial(data["numerator"], variables, checks,
                                  f"{label}.numerator")
    denominator = sparse_polynomial(data["denominator"], variables, checks,
                                    f"{label}.denominator")
    checks.equal(f"{label}.denominator", denominator, 1, "input_integrity")
    return numerator


def verify(certificate, payload, response, run):
    checks = Checks()
    checks.equal("schema_version", certificate["schema_version"], 1,
                 "input_integrity")
    checks.equal("claim", certificate["claim"], "AN_analytic_endpoint",
                 "input_integrity")
    checks.equal("research_target_level", certificate["research_target_level"],
                 "publishable", "input_integrity")
    checks.equal("math_objective_mode", certificate["math_objective_mode"],
                 "exploratory", "input_integrity")
    a, b, c, d, p, q, r, s = variables = sp.symbols("a b c d p q r s")
    t, z = sp.symbols("t z")
    wedge = certificate["wedge"]
    checks.equal("wedge.variables", wedge["variables"],
                 [str(v) for v in variables], "input_integrity")
    monomials = [a*d, a*s, b*c, b*r, c*q, d*p, p*s, q*r]
    checks.equal("wedge.determinant_monomials", wedge["determinant_monomials"],
                 ["ad", "as", "bc", "br", "cq", "dp", "ps", "qr"],
                 "input_integrity")
    checks.equal("wedge.coefficient_count",
                 len(wedge["determinant_coefficients"]), len(monomials),
                 "input_integrity")
    determinant = sp.Matrix([[a+p, c+r], [b+q, d+s]]).det()
    recorded = sum(coefficient * monomial for coefficient, monomial in
                   zip(wedge["determinant_coefficients"], monomials))
    checks.identity("wedge.determinant_coefficients", recorded - determinant)

    operation = "matrix.symbolic.determinant.compute"
    checks.equal("jacobian.operation", response["result"]["operation_id"],
                 operation, "input_integrity")
    checks.equal("jacobian.request.operation", response["request"]["operation_id"],
                 operation, "input_integrity")
    checks.equal("jacobian.request.payload", response["request"]["payload"],
                 payload, "input_integrity")
    checks.equal("jacobian.server_version", response["server"]["version"],
                 "0.14.0", "input_integrity")
    checks.equal("jacobian.protocol", response["protocol_version"],
                 "2025-11-25", "input_integrity")
    checks.require("jacobian.no_error", "error" not in response
                   and "error" not in response["result"])
    checks.equal("jacobian.method", response["result"]["output"]["method"],
                 "SYMPY_BAREISS", "input_integrity")
    checks.equal("jacobian.run.operation", run["operation_id"], operation,
                 "input_integrity")
    for field, expected in (("adapter_exit_code", 0), ("status", "completed"),
                            ("error", None), ("timeout", False),
                            ("server_version", "0.14.0"),
                            ("protocol_version", "2025-11-25")):
        checks.equal(f"jacobian.run.{field}", run[field], expected,
                     "input_integrity")
    checks.equal("jacobian.runtime", run["runtime_ms"],
                 response["result"]["runtime_ms"], "input_integrity")
    checks.equal("jacobian.matrix.variables", payload["matrix"]["variables"],
                 [str(v) for v in variables], "input_integrity")
    entries = payload["matrix"]["entries"]
    checks.require("jacobian.matrix.shape",
                   len(entries) == 2 and all(len(row) == 2 for row in entries))
    matrix = sp.Matrix([
        [rational_function(value, variables, checks, f"matrix.{i}.{j}")
         for j, value in enumerate(row)]
        for i, row in enumerate(entries)
    ])
    for i, row in enumerate([[a+p, c+r], [b+q, d+s]]):
        for j, value in enumerate(row):
            checks.identity(f"jacobian.input.{i}.{j}", matrix[i, j] - value)
    typed = rational_function(response["result"]["output"]["determinant"],
                              variables, checks, "typed_determinant")
    checks.identity("jacobian.output.replay", typed - matrix.det())

    geometry = certificate["geometry"]
    for field, expected in (("genus", 21), ("degree_L", 10),
                            ("canonical_power", 4)):
        checks.equal(f"reviewed_input.{field}", geometry[field], expected,
                     "input_integrity")
    genus, degree, canonical = (geometry["genus"], geometry["degree_L"],
                                geometry["canonical_power"])
    checks.equal("canonical_degree", canonical * degree, 2 * genus - 2)
    checks.equal("geometry.self_intersection", geometry["self_intersection"],
                 -degree)
    ky = 2 * genus - 2 - geometry["self_intersection"]
    checks.equal("geometry.canonical_intersection",
                 geometry["canonical_intersection"], ky)
    checks.require("singularity.adjunction_positive", ky > 0, "arithmetic")
    checks.require("singularity.exceptional_negative",
                   geometry["self_intersection"] < 0, "arithmetic")
    checks.equal("geometry.discrepancy", sp.Rational(ky, -degree),
                 geometry["discrepancy"])
    checks.equal("geometry.dual_graph_first_betti",
                 geometry["dual_graph_first_betti"], 0)

    jets = certificate["jets"]
    checks.equal("jets.last_row_index", jets["last_row_index"], 7,
                 "input_integrity")
    checks.equal("jets.minimum_field_order", jets["minimum_field_order"], 1,
                 "input_integrity")
    checks.equal("jets.row_wedge_order", jets["row_wedge_order"], 2,
                 "input_integrity")
    checks.equal("jets.last_coefficient_degree", jets["last_coefficient_degree"],
                 jets["last_row_index"] + 1, "order_equalities")
    cutoff = jets["last_coefficient_degree"] + 1
    checks.equal("jets.quotient_exponent", jets["quotient_exponent"], cutoff,
                 "order_equalities")
    base_order = jets["minimum_field_order"]
    log_order = 2 * base_order + jets["row_wedge_order"]
    checks.equal("jets.log_wedge_order", jets["log_wedge_order"], log_order,
                 "order_equalities")
    checks.equal("jets.ordinary_wedge_order", jets["ordinary_wedge_order"],
                 log_order + 1, "order_equalities")
    checks.equal("discrepancy.from_actual_wedge", geometry["discrepancy"],
                 -jets["ordinary_wedge_order"])
    weighted = determinant.xreplace({
        variable: t ** weight * variable
        for variable, weight in zip(variables, [base_order]*4 + [cutoff]*4)
    })
    error = sp.expand(weighted - t ** (2*base_order) * (a*d-b*c))
    error_terms = dict(sp.Poly(error, t).terms())
    checks.equal("jets.mixed_error_order", jets["mixed_error_order"],
                 min(exponent[0] for exponent in error_terms), "order_equalities")
    checks.equal("jets.quadratic_error_order", jets["quadratic_error_order"],
                 max(exponent[0] for exponent in error_terms), "order_equalities")
    mixed = sum(x*y for x, y in zip(wedge["mixed_coefficients"],
                                   [a*s, p*d, b*r, c*q]))
    quadratic = sum(x*y for x, y in zip(wedge["quadratic_coefficients"],
                                       [p*s, q*r]))
    checks.equal("wedge.mixed_count", len(wedge["mixed_coefficients"]), 4,
                 "input_integrity")
    checks.equal("wedge.quadratic_count", len(wedge["quadratic_coefficients"]), 2,
                 "input_integrity")
    checks.identity("wedge.mixed_coefficients",
                    error_terms[(base_order+cutoff,)] - mixed)
    checks.identity("wedge.quadratic_coefficients",
                    error_terms[(2*cutoff,)] - quadratic)
    checks.identity("wedge.weighted_identity",
                    error - t ** (base_order+cutoff)*mixed
                    - t ** (2*cutoff)*quadratic)
    checks.equal("jets.ordinary_error_order", jets["ordinary_error_order"],
                 jets["mixed_error_order"]+1, "order_equalities")
    checks.equal("jets.relative_unit_error_order",
                 jets["relative_unit_error_order"],
                 jets["mixed_error_order"]-log_order, "order_equalities")
    checks.require("unit.relative_error_positive",
                   jets["relative_unit_error_order"] > 0, "order_equalities")
    checks.identity("common_zero_model", sp.diag(t**2, t**2).det() - t**4)
    weak = sp.Matrix([[t, 0], [0, t**3]])
    checks.identity("insufficient_precision.initial_wedge", weak.det() - t**4)
    weak[1, 1] -= t**3
    checks.equal("insufficient_precision.can_cancel", weak.det(), 0)

    T, Tt, Tz, Zt, Zz = sp.symbols("T Tt Tz Zt Zz")
    log_matrix = sp.Matrix([[t*Tt/T, Tz/T], [t*Zt, Zz]])
    checks.identity("coordinate.log_jacobian",
                    log_matrix.det() - t/T * (Tt*Zz-Tz*Zt))
    flow = certificate["flow"]
    forward, inverse = t/(1-t), t/(1+t)
    checks.identity("flow.inverse_left", forward.subs(t, inverse) - t)
    checks.identity("flow.inverse_right", inverse.subs(t, forward) - t)
    checks.equal("flow.fixes_zero", forward.subs(t, 0), 0)
    checks.equal("flow.conormal_identity", sp.diff(forward, t).subs(t, 0), 1)
    multiplier = sp.cancel(t**5 * forward**(-5) * sp.diff(forward, t))
    recorded_multiplier = sum(value*t**index for index, value in
                              enumerate(flow["volume_multiplier_coefficients"]))
    checks.identity("flow.volume_multiplier_coefficients",
                    multiplier-recorded_multiplier)
    checks.equal("flow.volume_is_unit", multiplier.subs(t, 0), 1)
    checks.require("flow.volume_is_not_invariant",
                   sp.expand(multiplier-1) != 0, "symbolic_identities")
    checks.equal("flow.log_coordinate_extra_t_power",
                 flow["log_coordinate_extra_t_power"], 1, "order_equalities")

    graded = certificate["graded"]
    checks.equal("graded.threshold", graded["threshold"], 2*canonical+1)
    checks.equal("graded.cutoff_agreement", graded["threshold"], cutoff)
    k = sp.Symbol("k", integer=True, nonnegative=True)
    dual_degrees = [degree*(canonical-(graded["threshold"]+k)),
                    degree*(2*canonical-(graded["threshold"]+k))]
    for i, polynomial in enumerate(dual_degrees):
        values = [int(polynomial.subs(k, 0)), int(sp.diff(polynomial, k))]
        checks.equal(f"graded.dual_degrees_at_threshold_plus_k.{i}",
                     graded["dual_degrees_at_threshold_plus_k"][i], values)
        checks.require(f"graded.universal_negativity.{i}",
                       values[0] < 0 and values[1] <= 0, "arithmetic")
    checks.equal("graded.boundary_index", graded["boundary_index"],
                 graded["threshold"]-1)
    checks.equal("graded.boundary_dual_degree", graded["boundary_dual_degree"],
                 degree*(2*canonical-graded["boundary_index"]))
    checks.equal("graded.boundary_H1_dimension",
                 graded["boundary_H1_dimension"], 1)

    cofinal = certificate["cofinality"]
    checks.equal("cofinality.variables", cofinal["monomial_variables"],
                 ["a", "r"], "input_integrity")
    exponent_a, exponent_r = sp.symbols("exponent_a exponent_r", positive=True,
                                      integer=True)
    powers = {}
    for field in ("from_J_exponent", "via_I_exponent", "to_J_exponent"):
        vector = cofinal[field]
        checks.require(f"cofinality.{field}.shape",
                       len(vector) == 2 and all(type(x) is int and x >= 0
                                                for x in vector))
        powers[field] = exponent_a**vector[0] * exponent_r**vector[1]
    checks.identity("cofinality.from_J_exponent",
                    powers["from_J_exponent"]-exponent_a*exponent_r)
    checks.identity("cofinality.via_I_exponent",
                    powers["via_I_exponent"]-exponent_a*exponent_r)
    checks.identity("cofinality.to_J_exponent",
                    powers["to_J_exponent"]-exponent_r)
    checks.identity("cofinality.power_composition",
                    powers["via_I_exponent"]
                    - exponent_a*powers["to_J_exponent"])
    inner, gap = sp.symbols("inner gap", positive=True)
    checks.identity("collar.closed_boundary_margin",
                    (inner+gap)-(inner+gap/2)-gap/2)
    checks.require("collar.margin_positive", (gap/2).is_positive,
                   "symbolic_identities")

    extension = certificate["extension"]
    checks.equal("extension.normal_dimension", extension["normal_dimension"], 2)
    checks.equal("extension.required_depth", extension["required_depth"],
                 min(2, extension["normal_dimension"]))
    checks.equal("extension.rank", extension["rank"], 2)
    x, y = sp.symbols("x y")
    coefficients = extension["cramer_numerator_coefficients"]
    checks.require("extension.cramer_shape",
                   len(coefficients) == 2 and all(len(row) == 2
                                                 for row in coefficients))
    h1 = (coefficients[0][0]*d*x + coefficients[0][1]*c*y)/(a*d-b*c)
    h2 = (coefficients[1][0]*b*x + coefficients[1][1]*a*y)/(a*d-b*c)
    cramer = sp.Matrix([[a, c], [b, d]]) * sp.Matrix([h1, h2])
    checks.identity("extension.cramer_numerator_coefficients.0", cramer[0]-x)
    checks.identity("extension.cramer_numerator_coefficients.1", cramer[1]-y)
    f, g, h = sp.symbols("f g h")
    n = sp.Symbol("N", integer=True, positive=True)
    checks.identity("extension.regular_sequence_identity",
                    g**n*(f**n*h)-f**n*(g**n*h))

    genus_data = certificate["genus"]
    checks.equal("reviewed_input.h0_L", genus_data["h0_L"], 2, "input_integrity")
    checks.equal("reviewed_input.h0_L2", genus_data["h0_L2"], 3, "input_integrity")
    chi = degree+1-genus
    checks.equal("genus.chi_L", genus_data["chi_L"], chi)
    h1_values = [genus, genus_data["h0_L"]-chi, genus_data["h0_L2"],
                 genus_data["h0_L"], 1, 0]
    checks.equal("genus.H1_L_powers_0_through_5",
                 genus_data["H1_L_powers_0_through_5"], h1_values)
    double_curve = h1_values[0]+h1_values[1]
    checks.equal("genus.H1_double_curve", genus_data["H1_double_curve"],
                 double_curve)
    checks.equal("genus.stabilization_multiple",
                 genus_data["stabilization_multiple"], canonical+1)
    checks.identity("genus.all_higher_dual_degrees",
                    degree*(canonical-(canonical+1+k))+degree*(1+k))
    checks.equal("genus.pg_lower_bound", genus_data["pg_lower_bound"], double_curve)
    checks.equal("genus.pg_upper_bound", genus_data["pg_upper_bound"],
                 sum(h1_values[:canonical+1]))
    checks.equal("genus.pg_minus_g_minus_b_lower_bound",
                 genus_data["pg_minus_g_minus_b_lower_bound"],
                 double_curve-genus-geometry["dual_graph_first_betti"])
    return checks.counts


def negative_controls(certificate, payload, response, run):
    mutations = [
        ("wedge determinant sign", ("wedge", "determinant_coefficients", 3), 1),
        ("mixed wedge sign", ("wedge", "mixed_coefficients", 3), 1),
        ("quadratic wedge sign", ("wedge", "quadratic_coefficients", 1), 1),
        ("jet cutoff", ("jets", "quotient_exponent"), 8),
        ("ordinary determinant", ("jets", "ordinary_wedge_order"), 4),
        ("mixed error", ("jets", "mixed_error_order"), 9),
        ("relative unit error", ("jets", "relative_unit_error_order"), 5),
        ("vanishing threshold", ("graded", "threshold"), 8),
        ("boundary obstruction", ("graded", "boundary_H1_dimension"), 0),
        ("cofinal middle index", ("cofinality", "via_I_exponent"), [0, 1]),
        ("unjustified volume invariance",
         ("flow", "volume_multiplier_coefficients"), [1, 0, 0, 0]),
        ("Cramer sign", ("extension", "cramer_numerator_coefficients", 0, 1), 1),
        ("discrepancy sign", ("geometry", "discrepancy"), 5),
        ("geometric genus lower bound", ("genus", "pg_lower_bound"), 32),
        ("geometric genus upper bound", ("genus", "pg_upper_bound"), 40),
        ("premature stabilization", ("genus", "stabilization_multiple"), 4),
    ]
    rejected = []
    for name, path, value in mutations:
        altered = deepcopy(certificate)
        target = altered
        for key in path[:-1]:
            target = target[key]
        target[path[-1]] = value
        try:
            verify(altered, payload, response, run)
        except CertificateError as error:
            rejected.append({"control": name, "failure": str(error)})
        else:
            raise CertificateError(f"negative control was not rejected: {name}")
    return rejected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path,
                        default=ROOT / "exact_certificate.json")
    parser.add_argument("--negative-controls", action="store_true")
    args = parser.parse_args()
    try:
        certificate = read_json(args.certificate)
        payload = read_json(ROOT / "jacobian_payload.json")
        response = read_json(ROOT / "jacobian_output.json")
        run = read_json(ROOT / "jacobian_run.json")
        counts = verify(certificate, payload, response, run)
        rejected = (negative_controls(certificate, payload, response, run)
                    if args.negative_controls else [])
    except (OSError, ValueError, KeyError, TypeError, ZeroDivisionError) as error:
        print(json.dumps({"status": "failed", "error": str(error)}, indent=2))
        return 1
    print(json.dumps({
        "status": "passed",
        "claim": "AN_analytic_endpoint",
        "scope": "Exact algebra and order support, not a kernel analytic proof.",
        "exact_checks": sum(value for key, value in counts.items()
                            if key != "input_integrity"),
        "checks_by_category": dict(counts),
        "negative_controls_rejected": len(rejected),
        "rejecting_controls": rejected,
        "analytic_proof": "research/analytic_audit/report.md",
        "kernel_verified": False
    }, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
