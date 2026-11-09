#!/usr/bin/env python3
"""Replay the exact algebra supporting report.md; no stochastic sampling."""

import argparse
import hashlib
import itertools
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def zero(name, expression, identities):
    residual = sp.cancel(sp.expand(expression))
    if residual != 0:
        raise AssertionError(f"{name}: nonzero exact residual {residual}")
    identities[name] = "0"


def polynomial(encoded, variables):
    value = sp.Integer(0)
    for term in encoded["terms"]:
        coefficient = term["coefficient"]
        monomial = sp.Rational(coefficient["num"], coefficient["den"])
        if len(term["exponents"]) != len(variables):
            raise AssertionError("Jacobian exponent dimension mismatch")
        for variable, exponent in zip(variables, term["exponents"]):
            monomial *= variable**exponent
        value += monomial
    return value


def rational_function(encoded, names):
    if encoded["domain"] != "QQ" or encoded["variables"] != names:
        raise AssertionError("Unexpected Jacobian rational-function field")
    variables = [sp.Symbol(name) for name in names]
    denominator = polynomial(encoded["denominator"], variables)
    if denominator == 0:
        raise AssertionError("Zero Jacobian denominator")
    return polynomial(encoded["numerator"], variables) / denominator


def replay_jacobian(identities):
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    response = json.loads((ROOT / "jacobian_result.json").read_text())
    operation = "matrix.symbolic.multiply.compute"
    if response["request"] != {"operation_id": operation, "payload": payload}:
        raise AssertionError("Jacobian response is not bound to the saved payload")
    result = response["result"]
    if result["operation_id"] != operation:
        raise AssertionError("Wrong Jacobian operation")
    names = payload["left"]["variables"]
    if payload["right"]["variables"] != names:
        raise AssertionError("Incompatible input fields")
    output = result["output"]
    if output["variables"] != names or len(output["entries"]) != 1:
        raise AssertionError("Unexpected typed product shape")
    if len(output["entries"][0]) != 1:
        raise AssertionError("Unexpected typed product width")
    left = payload["left"]["entries"][0]
    right = payload["right"]["entries"]
    if len(left) != 2 or len(right) != 2 or any(len(row) != 1 for row in right):
        raise AssertionError("Unexpected typed input dimensions")
    direct = sum(
        rational_function(a, names) * rational_function(b[0], names)
        for a, b in zip(left, right)
    )
    answer = rational_function(output["entries"][0][0], names)
    p, F, u, S, c, j, q = map(sp.Symbol, names)
    expected = c * (p * F * u + S) ** 2 + 2 * j * (p * F * u + S) + q
    zero("jacobian_typed_product", answer - direct, identities)
    zero("jacobian_hessian_contraction", answer - expected, identities)
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "transport": response["transport"],
        "adapter_status": "completed",
        "adapter_exit_code": 0,
        "timeout_status": "not_timed_out",
        "structured_error": None,
        "runtime_ms": result["runtime_ms"],
        "typed_output_replayed": True,
        "exact_polynomial": str(sp.expand(answer)),
    }


def replay_formal_core():
    check = json.loads((ROOT / "lean" / "lean_check.json").read_text())
    if (check["status"] != "success" or check["exit_code"] != 0
            or check["audit_exit_code"] != 0 or check["proof_holes"] != []):
        raise AssertionError("The official Lean core is not hole-free and verified")
    version = check["tools"]["lean"]["version"]
    if not version.startswith("Lean (version 4.31.0,"):
        raise AssertionError("Unexpected Lean compiler version")
    for name, key in [
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ]:
        original = (ROOT / name).read_bytes()
        compiled = (ROOT / "lean" / name).read_bytes()
        if original != compiled or hashlib.sha256(original).hexdigest() != check[key]:
            raise AssertionError(f"Stale official Lean evidence for {name}")
    return {
        "claim": "C_PAIR_ALGEBRA",
        "official_result": "research/pair_response/lean/lean_check.json",
        "compiler_version": version,
        "exit_code": check["exit_code"],
        "audit_exit_code": check["audit_exit_code"],
        "proof_holes": check["proof_holes"],
        "source_and_fidelity_fresh": True,
        "analytical_theorem_formalized": False,
    }


def local_child_patterns(identities):
    m = sp.Symbol("m")
    covariances = {
        pair: sp.Symbol(f"C{pair[0]}{pair[1]}")
        for pair in [(0, 2), (0, 3), (1, 2), (1, 3)]
    }
    patterns = set()
    for c, d in itertools.product(range(4), repeat=2):
        if c == d:
            continue
        relabel = {}
        pattern = []
        for child in (0, 1, c, d):
            if child not in relabel:
                relabel[child] = len(relabel)
            pattern.append(relabel[child])
        patterns.add(tuple(pattern))
    if len(patterns) != 7:
        raise AssertionError("The exhaustive four-slot classification changed")
    for pattern in sorted(patterns):
        conditional = sp.Integer(1)
        for child in set(pattern):
            slots = [slot for slot in range(4) if pattern[slot] == child]
            if len(slots) == 1:
                conditional *= m
            elif len(slots) == 2:
                pair = tuple(slots)
                conditional *= m**2 + covariances[pair]
            else:
                raise AssertionError("A forbidden three-slot child appeared")
        C02, C03, C12, C13 = [
            covariance if pattern[pair[0]] == pattern[pair[1]] else sp.Integer(0)
            for pair, covariance in covariances.items()
        ]
        claimed = (
            m**4
            + m**2 * (C02 + C03 + C12 + C13)
            + C02 * C13
            + C03 * C12
        )
        zero(f"conditional_pattern_{''.join(map(str, pattern))}",
             conditional - claimed, identities)
    return [list(pattern) for pattern in sorted(patterns)]


def certificate():
    identities = {}
    p, F, u, c, cz, czz, jz, jzz, S, Qpast = sp.symbols(
        "p F u c cz czz jz jzz S Qpast"
    )
    H = p * F * u - S
    raw = (
        F**2 * (czz + 2*p*c**2 + 4*p*u*cz + 4*p**2*u**2*c)
        + 2*F*jzz + 4*p*F*u*jz
        + 2*F*(-F*(czz + 2*p*c**2 + 2*p*u*cz) - jzz)
        + 2*H*(-F*(cz + 2*p*u*c) - jz)
        + F**2*czz + 2*F*H*cz
        + (H**2 + p*F**2*c - Qpast)*c
    )
    reduced = (
        -p*F**2*c**2 - Qpast*c
        + (p*F*u + S)**2*c + 2*(p*F*u + S)*jz
    )
    zero("colored_prefix_curvature", raw - reduced, identities)

    a, b, q, n, I, m, h, second = sp.symbols("a b q n I m h second")
    zero("real_power_induction_factor",
         b*(a/b - q - n) - (a - (q+n)*b), identities)
    tilted_hessian = (p*I*(h+p*second))/(p*I) - (p*I*m)**2/(p*I**2)
    zero("normalized_source_hessian",
         tilted_hessian - (h + p*(second-m**2)), identities)

    parent, child = sp.symbols("parent child")
    cases = {
        "k_le_t": (parent-child + parent-child, -2*(child-parent)),
        "k_eq_t_plus_one": (parent-child-child, -(2*child-parent)),
        "k_gt_t_plus_one": (parent-child, -(child-parent)),
    }
    for name, (d, minus_mu) in cases.items():
        zero(f"sheet_row_mass_{name}", d-minus_mu, identities)

    q, r = sp.symbols("q r")
    diagonal = 1-q**2
    shared = q-q**2
    disjoint = r-q**2
    Mconstant = (
        diagonal + 2*(p-2)*shared + (p-2)*(p-3)*disjoint/2
    )
    Madditive = diagonal + (p-4)*shared - (p-3)*disjoint
    Mrowzero = diagonal - 2*shared + disjoint
    susceptibility_square = 1-2*q+r
    Bconstant = q-r + p*(r-q**2)/4
    Badditive = q-r
    zero("one_sheet_constant_sector",
         Mconstant - (susceptibility_square - 2*(1-p)*Bconstant), identities)
    zero("one_sheet_additive_sector",
         Madditive - (susceptibility_square - (2-p)*Badditive), identities)
    zero("one_sheet_row_zero_sector",
         Mrowzero - susceptibility_square, identities)

    x, y, g00, g10, g01, g11 = sp.symbols("x y g00 g10 g01 g11")
    g = g00 + x*g10 + y*g01 + x*y*g11
    mixed = sp.diff(1/(1-b*g), x, y).subs({x: 0, y: 0})
    expected_mixed = b*g11/(1-b*g00)**2 + 2*b**2*g10*g01/(1-b*g00)**3
    zero("reciprocal_mixed_derivative", mixed-expected_mixed, identities)
    ai, ai1, al, al1 = sp.symbols("ai ai1 al al1")
    zero("child_mixed_difference",
         ai*al-ai1*al-ai*al1+ai1*al1-(ai-ai1)*(al-al1), identities)

    alpha, mr, mt, chi, psir, psit = sp.symbols(
        "alpha mr mt chi psir psit"
    )
    zero("energy_past_past_drift",
         mr*mt*(-alpha*chi**2) + alpha*(mr*chi)*(mt*chi), identities)
    zero("energy_past_future_drift",
         mr*(-alpha*chi*psit) + alpha*(mr*chi)*psit, identities)
    zero("energy_future_future_lower_limit",
         -alpha*psir*psit + alpha*psir*psit, identities)
    zero("energy_marker_boundary",
         mr*(mt*chi) - mr*mt*chi, identities)
    zero("conditional_energy_field_field_drift",
         -alpha*chi**2 + alpha*chi*chi, identities)
    zero("conditional_energy_field_future_drift",
         -alpha*chi*psit + alpha*chi*psit, identities)

    patterns = local_child_patterns(identities)
    jacobian = replay_jacobian(identities)
    return {
        "theorem": "Full finite scalar sector response with prefix Gram-energy strengthening",
        "result_class": "new_theorem",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "independent_review": "pending_host_invoked_reviewer",
        "novelty_status": "requires_independent_review",
        "campaign_complete": False,
        "proof": {
            "artifact": "research/pair_response/report.md",
            "scalar_response_scope": "All finite resolutions and fixed old-label topologies under the stated normalized scalar and signed-allocation model.",
            "strengthening": "The full switching field/profile Hessian has a conditional terminal Gram representation and is a positive-semidefinite matrix supermartingale, including bounded stopping prefixes under uniform integrability. Its deterministic expectation has exact Loewner-positive prefix decrements. A smooth convex terminal value and a nonnegative profile suffice, subject to the stated regularity.",
            "not_claimed": [
                "A machine-checked proof of the PDE or stochastic calculus",
                "Independent certification of the companion's entire calculus",
                "A proof of either SK asymptotic main theorem",
                "An admissible counterexample",
                "A Reviewer verdict or established novelty",
            ],
        },
        "exact_algebra": {
            "domain": "QQ with algebraically independent indeterminates; denominators are required nonzero",
            "residuals": identities,
            "conditional_child_patterns": patterns,
            "classification_scope": "Exhaustive local four-slot child patterns, not a bounded enumeration of global trees.",
            "real_power_scope": "The symbolic induction step holds for arbitrary slot index; the all-natural-slot theorem is in Main.lean.",
        },
        "jacobian": jacobian,
        "formal_core": replay_formal_core(),
        "lean_scope": "Universal polynomial cancellation, real-power slot induction, and arbitrary-dimensional positive-functional Gram-square algebra only; consult statement_fidelity.md and the official ledger certificate.",
        "analytic_inputs_requiring_review": [
            "Normalized scalar recursion and positive forward law",
            "Ito and Gaussian integration-by-parts identities with the tilted prefix density",
            "Profile-derivative PDE and continuous impulse limits",
            "Conditional Hessian drift and optional sampling of the uniformly integrable compensated process",
            "Old-label-preserving real-power coefficient transfer",
            "Resolution-independent finite-source derivative bounds",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        recorded = json.loads(path.read_text())
        if recorded != result:
            raise AssertionError("Saved certificate differs from the exact replay")
    print(json.dumps({
        "ok": True,
        "exact_identities": len(result["exact_algebra"]["residuals"]),
        "local_child_patterns": len(result["exact_algebra"]["conditional_child_patterns"]),
        "jacobian_replayed": True,
        "lean_algebra_core_replayed": True,
        "analytical_proof": "report.md; independent review pending",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
