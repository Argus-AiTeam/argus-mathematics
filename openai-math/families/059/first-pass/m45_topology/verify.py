#!/usr/bin/env python3
"""Replay the exact supporting calculations, not the geometric proof."""

import argparse
import json
from math import gcd
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = ROOT / (
    "research/openai_manuscript/"
    "Ambiently-homeomorphic-isolated-hypersurface-germs-in-C4-"
    "with-multiplicities-four-and-five-September-27-2026/build/sections"
)


def compute():
    checks = []

    def require(label, condition):
        if not condition:
            raise AssertionError(label)
        checks.append(label)

    def equal(label, left, right):
        require(label, sp.expand(left - right) == 0)

    def read_json(name):
        return json.loads((HERE / name).read_text())

    x, t, u, v, w, y, z, c, k, e = sp.symbols("X T u v w y z c k epsilon")
    x1, x2, t1, t2, a1, a2, r0, r1 = sp.symbols("x1 x2 t1 t2 A1 A2 R0 R1")
    q1 = (u - v - v**8) * (u - v - 2 * v**8) * (u - v**2)
    q2 = q1 - u**2
    psi = ((u * (u - v**2) * q2).subs(u, x + v)).expand()
    h = t * (x - t**2) * (x - 2 * t**2)
    g0 = x - t**2 - q1.subs(u, t)
    g1 = t - psi

    source = "".join((SOURCE / "02-plane.tex").read_text().split())
    for label, formula in [
        ("h_source", r"h(X,T)&=T(X-T^2)(X-2T^2)"),
        ("q1_source", r"q_1(u,w)&=(u-w-w^8)(u-w-2w^8)(u-w^2)"),
        ("q2_source", r"q_2(u,w)&=q_1(u,w)-u^2"),
        ("psi_source", r"\psi(x,w)&=u(u-w^2)q_2(u,w),\quadu=x+w"),
    ]:
        require(label, formula in source)

    unit0 = (1 + v**7) * (1 + 2 * v**7)
    unit1 = (1 - v) * (1 - 2 * v**15 * (1 - v))
    equal("exact_specialization_graph0", g0.subs({x: 0, t: 0}), v**4 * unit0)
    equal("exact_specialization_graph1", g1.subs({x: 0, t: 0}), v**4 * unit1)
    equal("unit0_constant", unit0.subs(v, 0), 1)
    equal("unit1_constant", unit1.subs(v, 0), 1)
    equal("base_derivative_graph0", sp.diff(g0, x).subs({x: 0, t: 0, v: 0}), 1)
    equal("base_derivative_graph1", sp.diff(g1, t).subs({x: 0, t: 0, v: 0}), 1)
    equal("q1_initial", sp.expand(q1.subs({u: e * u, v: e * v})).coeff(e, 3),
          u * (u - v)**2)
    equal("psi_initial", sp.expand(psi.subs({x: e * x, v: e * v})).coeff(e, 4),
          -(x + v)**4)
    require("q1_order_three", min(sum(m) for m, _ in sp.Poly(q1, u, v).terms()) == 3)
    require("psi_order_four", min(sum(m) for m, _ in sp.Poly(psi, x, v).terms()) == 4)

    # A1,A2 encode arbitrary positive-degree corrections of the composed units.
    unit = 1 + e * a1 + e**2 * a2
    residual0 = (
        e * x1 + e**2 * x2 - (e * t)**2
        - q1.subs({u: e * t, v: e * k * w})
        - c * unit * e**2 * y * z
    ).expand()
    residual1 = (
        e * t1 + e**2 * t2
        - psi.subs({x: e * x, v: e * k * w})
        - c * unit * e**2 * y * z
    ).expand()
    equal("implicit0_linear_equation", residual0.coeff(e, 1), x1)
    equal("implicit1_linear_equation", residual1.coeff(e, 1), t1)
    equal("implicit0_quadratic_equation", residual0.coeff(e, 2), x2 - t**2 - c * y * z)
    equal("implicit1_quadratic_equation", residual1.coeff(e, 2), t2 - c * y * z)
    require("unit_corrections_absent_in_quadratic_jets",
            not (residual0.coeff(e, 2).free_symbols
                 | residual1.coeff(e, 2).free_symbols) & {a1, a2, k})

    substituted0 = h.subs(
        {x: e**2 * (t**2 + c * y * z) + e**3 * r0, t: e * t},
        simultaneous=True,
    ).expand()
    substituted1 = h.subs(
        {x: e * x, t: e**2 * c * y * z + e**3 * r1},
        simultaneous=True,
    ).expand()
    initial0 = t * c * y * z * (c * y * z - t**2)
    initial1 = c * y * z * x**2
    equal("degree_five_initial_form", substituted0.coeff(e, 5), initial0)
    equal("degree_four_initial_form", substituted1.coeff(e, 4), initial1)
    require("no_degree_below_five", all(substituted0.coeff(e, j) == 0 for j in range(5)))
    require("no_degree_below_four", all(substituted1.coeff(e, j) == 0 for j in range(4)))
    p0 = sp.Poly(initial0, t, y, z, w)
    p1 = sp.Poly(initial1, x, y, z, w)
    require("all_initial0_monomials_degree_five", {sum(m) for m, _ in p0.terms()} == {5})
    require("all_initial1_monomials_degree_four", {sum(m) for m, _ in p1.terms()} == {4})
    equal("nonzero_coefficient_initial0", p0.coeff_monomial(t * y**2 * z**2), c**2)
    equal("nonzero_coefficient_initial1", p1.coeff_monomial(x**2 * y * z), c)
    require("initial_forms_independent_of_remainders",
            not (initial0.free_symbols | initial1.free_symbols) & {r0, r1, a1, a2})
    require("vanishing_c_is_excluded", initial0.subs(c, 0) == initial1.subs(c, 0) == 0)

    r, n0 = 4, 97
    n1 = n0 + 5 * 2**r
    a, b = (n0**2 - 1) // 4, (n1**2 - 1) // 4
    require("parameter_congruences", n0 % 2**r == 1 and n0 % 5 == 2)
    require("parameter_strict_lower_bound", n0 > 5 * 2**r)
    require("parameter_integrality", (n0**2 - 1) % 4 == (n1**2 - 1) % 4 == 0)
    require("parameter_coprime_boundary_indices", gcd(n0, n1) == 1)
    require("local_isolation_range", a > 1 and b > 1 and a * b > 5 * (a + b))
    require("first_strict_tube_bound", a * b - 2 * b > 4 * (a + b))
    require("second_strict_tube_bound", a * b - 2 * a > 4 * (a + b))
    require("perturbing_terms_above_degree_five", min(a + 1, b + 1) > 5)
    require("gcd_condition_for_retained_arithmetic", gcd(a, b) >= 2**(r - 1) > 5)

    permutation = [1, 2, 3, 4, 0, 5, 6, 7]
    collar_sign = int(sp.eye(8)[:, permutation].det())
    require("ordered_collar_intersection_sign", collar_sign == 1)
    require("inclusive_kato_threshold", (2 * 3 + 1, 2 * 3, 2 * 3 - 1) == (7, 6, 5))

    contract = read_json("jacobian_factor_contract.json")
    payload = read_json("jacobian_factor_payload.json")
    response = read_json("jacobian_factor_result.json")
    status = read_json("jacobian_factor_status.json")
    operation = "polynomial.multivariate.factor.compute"
    require("inspected_operation", contract["result"]["operation"]["operation_id"] == operation)
    require("adapter_success", status["adapter_exit_code"] == 0 and not status["timeout"])
    require("empty_adapter_stderr", not (HERE / status["stderr_file"]).read_text().strip())
    require("exact_request_retained", response["request"] == {
        "operation_id": operation, "payload": payload,
    })
    require("typed_operation_matches", response["result"]["operation_id"] == operation)
    result = response["result"]["output"]
    require("factorized_not_unknown", result["status"] == "FACTORIZED")
    require("typed_exact_reconstruction", result["product_reconstruction"] == "EXACT")

    def rational(value):
        return sp.Rational(value["num"], value["den"])

    def polynomial(value):
        require("jacobian_exact_QQ_ring", value["domain"] == "QQ")
        symbols = sp.symbols(value["variables"])
        return sum(
            rational(term["coefficient"])
            * sp.prod(symbol**power for symbol, power in zip(symbols, term["exponents"], strict=True))
            for term in value["polynomial"]["terms"]
        )

    requested = polynomial(payload["polynomial"])
    equal("jacobian_bound_to_initial_form", requested, initial0)
    reconstruction = rational(result["coefficient"])
    for factor in result["factors"]:
        reconstruction *= polynomial(factor["factor"]) ** factor["multiplicity"]
    equal("independent_factor_product_replay", reconstruction, requested)
    equal("typed_reconstruction_matches_request", polynomial(result["reconstructed"]), requested)
    require("preserved_protocol_and_server",
            response["protocol_version"] == contract["protocol_version"]
            and response["server"]["version"] == contract["server"]["version"])

    return {
        "campaign_id": "9000059",
        "mission": "m45-ambient-equivalence",
        "claim_id": "M45:thm:main",
        "result_class": "exact_verification_theorem",
        "proof_kind": "Prose proof using retained reviewed inputs and cited topology; exact supporting algebra.",
        "machine_scope": "Unit-aware jets, explicit integer admissibility, and a collar-orientation permutation only.",
        "independent_review": "required_pending",
        "kernel_verified": False,
        "novelty_status": "not_established",
        "campaign_complete": False,
        "M23": "unresolved_and_unchanged",
        "exact_checks": {"count": len(checks), "passed": checks},
        "algebra": {
            "fixed_scale": "s != 0; c=s^-4; k=s^-1",
            "unit0_on_base_zero": str(unit0),
            "unit1_on_base_zero": str(unit1),
            "graph0_solved_coordinate": "X=T^2+c*y*z+O(degree>=3)",
            "graph1_solved_coordinate": "T=c*y*z+O(degree>=3)",
            "initial_f5": str(initial0),
            "initial_f4": str(initial1),
            "orders": [5, 4],
            "nonzero_coefficients": ["c^2", "c"],
            "reducedness": "Follows in the prose proof from retained isolation, not from the tangent cones.",
        },
        "explicit_integer_choice": {
            "r": r, "n0": n0, "n1": n1, "a": a, "b": b, "gcd_a_b": gcd(a, b),
            "first_tube_ratio": str(sp.Rational(a * b - 2 * b, a + b)),
            "second_tube_ratio": str(sp.Rational(a * b - 2 * a, a + b)),
            "s": "An unspecified common sufficiently small positive real; no numeric threshold certified.",
        },
        "orientation": {
            "ordered_dimensions": [4, 4],
            "ambient_dimension": 8,
            "collar_column_permutation": permutation,
            "determinant": collar_sign,
            "geometric_application": "Proved in audit_report.tex, not certified by the determinant alone.",
        },
        "jacobian": {
            "operation_id": operation,
            "protocol_version": response["protocol_version"],
            "server_version": response["server"]["version"],
            "typed_status": result["status"],
            "adapter_exit_code": status["adapter_exit_code"],
            "timeout": status["timeout"],
            "contract_file": "jacobian_factor_contract.json",
            "payload_file": "jacobian_factor_payload.json",
            "result_file": "jacobian_factor_result.json",
            "status_file": "jacobian_factor_status.json",
        },
        "retained_inputs_not_recomputed": [
            {"claim": "C059APPLICATION", "proof": "research/audit_report.tex"},
            {"claim": "M45:thm:tube", "proof": "research/m45_seifert/audit_report.tex"},
            {"claim": "M45:prop:arith-integral-congruence", "proof": "research/m45_arithmetic/audit_report.tex"},
        ],
        "geometric_proof_not_machine_checked": [
            "Actual compact pages have handles of indices <=3 and collar-fixed monodromy.",
            "The reviewed ordered local filling pairing is Kato's ordered linking pairing.",
            "The retained onto integral isometry gives an integral unimodular congruence.",
            "Kato Theorem B identifies the embedded links on standard S7.",
            "Massey Theorem 1.4 extends the sphere-link equivalence to ambient germ pairs.",
        ],
        "primary_sources_inspected_pending_independent_attribution": [
            {"assumption": "A059TOPO-KATO", "source_id": "doi:10.2969/jmsj/02630454",
             "locator": "Theorem B p.454 and Section 2 pp.455-456",
             "excerpt": "literature/kato_excerpt.txt"},
            {"assumption": "A059TOPO-MILNOR-SIMPLE", "source_id": "doi:10.2969/jmsj/05110063",
             "locator": "Definition and local analytic example pp.63-64",
             "excerpt": "literature/nemethi_excerpt.txt"},
            {"assumption": "A059TOPO-CONE", "source_id": "arxiv:1410.3312v2",
             "locator": "Theorem 1.4 p.4", "excerpt": "literature/massey_cone_excerpt.txt"},
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = compute()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2) + "\n")
    elif json.loads(path.read_text()) != result:
        raise AssertionError("The retained certificate differs from the exact replay.")
    print(json.dumps({
        "ok": True, "exact_checks": result["exact_checks"]["count"],
        "orders": result["algebra"]["orders"],
        "scope": result["machine_scope"],
        "independent_review": result["independent_review"],
    }))


if __name__ == "__main__":
    main()
