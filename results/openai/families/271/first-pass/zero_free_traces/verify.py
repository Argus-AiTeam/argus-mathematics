#!/usr/bin/env python3
"""Replay exact algebra and source/Lean bindings for the cyclic trace theorem."""

import argparse
import hashlib
import itertools
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = ROOT / (
    "research/openai_manuscript/"
    "The-spherical-magnetization-law-for-the-three-dimensional-quantum-"
    "Heisenberg-ferromagnet-October-5-2026/build/sections"
)
Q = sp.Rational
I = sp.I
BASIS = sp.Matrix([[1, 1], [I, -I]])


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def exact(value):
    return sp.expand(value)


def same_matrix(left, right):
    return left.shape == right.shape and all(exact(v) == 0 for v in left - right)


def complex_pair(value):
    value = exact(value)
    real, imag = value.as_real_imag()
    require(real.is_Rational and imag.is_Rational, "Non-rational certificate component")
    return [str(real), str(imag)]


def modulus_sq(value):
    value = exact(value)
    return exact(value * sp.conjugate(value))


def matrix_data(matrix):
    return [[str(v) for v in matrix.row(i)] for i in range(matrix.rows)]


def tensor(matrices):
    result = sp.ones(1)
    for matrix in matrices:
        result = sp.kronecker_product(result, matrix)
    return result


def word(matrices):
    require(bool(matrices), "The displayed cyclic matrix word must be nonempty")
    result = sp.eye(matrices[0].rows)
    for matrix in matrices:
        result = (result * matrix).applyfunc(exact)
    return result


def permutation_matrix(n, permutation):
    require(sorted(permutation) == list(range(n)), "Invalid slot permutation")
    states = list(itertools.product((0, 1), repeat=n))
    indices = {state: i for i, state in enumerate(states)}
    matrix = sp.zeros(2**n)
    for column, state in enumerate(states):
        output = [0] * n
        for i in range(n):
            output[permutation[i]] = state[i]
        matrix[indices[tuple(output)], column] = 1
    return matrix


def transposition(n, i, j):
    permutation = list(range(n))
    permutation[i], permutation[j] = permutation[j], permutation[i]
    return permutation_matrix(n, permutation)


def admissible_layer(n, layer):
    result = sp.eye(2**n)
    operations = []
    if n > 1:
        for step, probability in enumerate((Q(1, 3), Q(1, 2), Q(1))):
            i = (layer + step) % n
            j = (i + 1) % n
            factor = (1 - probability) * sp.eye(2**n) + probability * transposition(n, i, j)
            result = (result * factor).applyfunc(exact)
            operations.append({"kind": "independent_bernoulli", "slots": [i, j],
                               "probability": str(probability)})
    permutation = [(i + layer + 1) % n for i in range(n)] if n else []
    result = result * permutation_matrix(n, permutation)
    operations.append({"kind": "deterministic_permutation", "images": permutation})
    return result, operations


def real_pulse(layer, slot):
    a = Q(layer + slot + 1, 3)
    b = Q((-1) ** (layer + slot) * (slot + 1), 4)
    upper = sp.Matrix([[1, a], [0, 1]])
    lower = sp.Matrix([[1, 0], [b, 1]])
    require(not same_matrix(upper * lower, lower * upper), "Pulse-order test became commuting")
    matrix = lower * upper
    require(matrix.det() == 1, "Real pulse does not have determinant one")
    return matrix


def normalized_slot(real_matrix, rho):
    require(real_matrix.det() == 1 and all(v.is_real for v in real_matrix),
            "The pulse must be a real SL(2) matrix")
    require(modulus_sq(rho) < 1, "The field ratio is not strictly contracting")
    su = (BASIS.inv() * real_matrix * BASIS).applyfunc(exact)
    matrix = (su * sp.diag(1, rho)).applyfunc(exact)
    u, v = sp.symbols("u v", real=True)
    x = u + I * v
    first = matrix[0, 0] + matrix[0, 1] * x
    second = matrix[1, 0] + matrix[1, 1] * x
    gap = exact(first * sp.conjugate(first) - second * sp.conjugate(second))
    require(exact(gap - (1 - modulus_sq(rho) * (u*u + v*v))) == 0,
            "Uniform disk-gap identity failed")
    require(matrix[0, 0] != 0, "The all-up amplitude vanished")
    return matrix


def polynomial_product(left, right):
    result = {}
    for mask_a, value_a in left.items():
        for mask_b, value_b in right.items():
            require(mask_a & mask_b == 0, "Layer variables were not disjoint")
            mask = mask_a | mask_b
            result[mask] = exact(result.get(mask, 0) + value_a * value_b)
    return {mask: value for mask, value in result.items() if value != 0}


def layer_symbol(matrix, n, layer):
    states = list(itertools.product((0, 1), repeat=n))
    result = {}
    for row, output in enumerate(states):
        for column, input_state in enumerate(states):
            coefficient = exact(matrix[row, column])
            if coefficient == 0:
                continue
            mask = 0
            for i in range(n):
                mask |= input_state[i] << (2*n*layer + i)
                mask |= output[i] << (2*n*layer + n + i)
            result[mask] = coefficient
    return result


def contract_pair(polynomial, first, second):
    bits = (1 << first) | (1 << second)
    result = {}
    for mask, coefficient in polynomial.items():
        selected = mask & bits
        if selected not in (0, bits):
            continue
        new_mask = mask & ~bits
        result[new_mask] = exact(result.get(new_mask, 0) + coefficient)
    return {mask: value for mask, value in result.items() if value != 0}


def cyclic_network(n, layers):
    matrices, layer_inputs = [], []
    rhos = (Q(1, 2), Q(1, 3) + I/4, -Q(2, 5) + I/5, Q(3, 5) + I/5)
    for layer in range(layers):
        mean, operations = admissible_layer(n, layer)
        slots, slot_inputs = [], []
        for i in range(n):
            pulse = real_pulse(layer, i)
            rho = rhos[(layer + i) % len(rhos)]
            require(modulus_sq(rho) <= Q(3, 4)**2, "Common radius 4/3 is not valid")
            slots.append(normalized_slot(pulse, rho))
            slot_inputs.append({"real_pulse": matrix_data(pulse), "rho": complex_pair(rho),
                                "closed_disk_gap": str(1 - modulus_sq(rho))})
        scalar = Q(layer + 2, 3) + I * Q((-1)**layer, 5)
        matrices.append((scalar * mean * tensor(slots)).applyfunc(exact))
        layer_inputs.append({"operations_in_displayed_order": operations,
                             "nonzero_scalar": complex_pair(scalar), "slots": slot_inputs})
    polynomial = {0: sp.Integer(1)}
    for layer, matrix in enumerate(matrices):
        polynomial = polynomial_product(polynomial, layer_symbol(matrix, n, layer))
    all_up = polynomial[0]
    pairs = [(2*n*layer + n + i, 2*n*((layer - 1) % layers) + i)
             for layer in range(layers) for i in range(n)]
    contraction_values = []
    for pairing_order in (pairs, list(reversed(pairs))):
        contracted = polynomial
        for first, second in pairing_order:
            contracted = contract_pair(contracted, first, second)
        require(set(contracted) == {0}, "Complete contraction left a nonconstant or zero polynomial")
        contraction_values.append(exact(contracted[0]))
    trace = exact(sp.trace(word(matrices)))
    require(trace != 0, "Admissible strict example has zero trace")
    require(all(exact(value - trace) == 0 for value in contraction_values),
            "Cyclic symbol pairing does not equal the displayed matrix trace")
    lower_sq = modulus_sq(all_up) * Q(1, 4)**(2*n*layers)
    require(modulus_sq(trace) >= lower_sq, "Quantitative trace lower bound failed")
    return {
        "slots": n, "layers": layers, "inputs": layer_inputs,
        "matrix_order": "K[0] * ... * K[m-1], K[r]=scalar[r] mean[r] tensor(M[r,i])",
        "paired_axes": [list(pair) for pair in pairs],
        "initial_symbol_terms": len(polynomial),
        "exact_trace": complex_pair(trace),
        "exact_all_up": complex_pair(all_up),
        "trace_modulus_squared": str(modulus_sq(trace)),
        "certified_lower_bound_squared_R_4_over_3": str(lower_sq),
        "forward_and_reverse_pairing_orders_agree": True
    }


def symbolic_identities():
    a, b, c, d, u, v, r = sp.symbols("a b c d u v r", real=True)
    x, y = sp.symbols("x y")
    cayley = (I*(1+x)/(1-x) + I*(1-y)/(1+y)
              - 2*I*(1+x*y)/((1-x)*(1+y)))
    require(sp.cancel(cayley) == 0, "Cayley identity failed")
    alpha = (a+d+I*(b-c))/2
    beta = (a-d-I*(b+c))/2
    require(exact(alpha*sp.conjugate(alpha)-beta*sp.conjugate(beta)-(a*d-b*c)) == 0,
            "Real SL(2) basis change failed")
    z = u+I*v
    denominator = alpha+beta*z
    numerator = sp.conjugate(beta)+sp.conjugate(alpha)*z
    require(exact(denominator*sp.conjugate(denominator)
                  - numerator*sp.conjugate(numerator)
                  - (a*d-b*c)*(1-u*u-v*v)) == 0, "SU(1,1) disk identity failed")
    aa, dd, ell, root, other = sp.symbols("A D L root other")
    factor = exact(dd*(z-root)*(z-other) - (aa+ell*z+dd*z*z))
    substituted = factor.subs(aa, dd*root*other).subs(ell, -dd*(root+other))
    require(exact(substituted) == 0, "Quadratic factor/product identity failed")
    q, xp, yp = sp.symbols("q xp yp")
    require(exact((1-q*xp*yp).subs({xp: 0, yp: 0})) == 1, "Sharpness constant failed")
    sharp = {}
    for pairs in range(7):
        slots = [sp.diag(1, -Q(2, 3)) for _ in range(pairs)]
        trace = sp.trace(tensor(slots))
        require(trace == Q(1, 3)**pairs, "One-layer sharpness identity failed")
        sharp[str(pairs)] = str(trace)
    boundary_trace = sp.trace(sp.diag(1, -1))
    require(boundary_trace == 0, "Non-strict boundary control failed")
    return {
        "cayley_identity": True, "real_sl2_norm_identity": True,
        "su11_disk_identity": True, "quadratic_root_product_identity": True,
        "one_layer_sharpness_R_3_over_2": sharp,
        "non_strict_boundary": {"matrix": [["1", "0"], ["0", "-1"]],
                                "trace": "0", "satisfies_strict_hypothesis": False}
    }


def physical_projection_example():
    n = 4
    identity = sp.eye(16)
    projection = ((identity + transposition(n, 0, 1)) *
                  (identity + transposition(n, 2, 3))) / 4
    require(same_matrix(projection*projection, projection), "Symmetric seam is not idempotent")
    generator = sum((transposition(n, i, j) for i in (0, 1) for j in (2, 3)),
                    sp.zeros(16))/2 - identity
    annihilator = generator*(generator+2*identity)*(generator+identity)*(generator-identity)
    require(same_matrix(annihilator, sp.zeros(16)), "Static spectral certificate failed")
    variable = sp.Symbol("h")
    static_polynomial = sp.interpolate([(-2, Q(1, 4)), (-1, Q(1, 2)), (0, 1), (1, 2)], variable)
    static = sp.zeros(16)
    for (power,), coefficient in sp.Poly(static_polynomial, variable).terms():
        static += coefficient * generator**power
    require(same_matrix(static*projection, projection*static), "Static operator does not commute with seam")
    require(all(value >= 0 for value in static), "Ferromagnetic static matrix lost positivity")
    require(all(sum(static.row(i)) == 2 for i in range(16)), "Exchange normalization c=2 failed")
    site_basis = sp.Matrix([[1, 0, 0], [0, 1, 0], [0, 1, 0], [0, 0, 1]])
    site_dual = sp.diag(1, Q(1, 2), 1) * site_basis.T
    embedding = sp.kronecker_product(site_basis, site_basis)
    dual = sp.kronecker_product(site_dual, site_dual)
    require(same_matrix(dual*embedding, sp.eye(9)), "Physical basis has no correct dual")
    require(same_matrix(embedding*dual, projection), "Physical basis does not span the symmetric projection")
    pulses = []
    original_pulses = []
    negative_original_pulses = []
    field = sp.diag(2, Q(1, 2))
    original_field = (BASIS * field * BASIS.inv()).applyfunc(exact)
    original_negative = (BASIS * field.inv() * BASIS.inv()).applyfunc(exact)
    for layer in range(2):
        real_slots = [real_pulse(layer, slot) for slot in range(n)]
        slots = [(BASIS.inv()*g*BASIS*field).applyfunc(exact) for g in real_slots]
        pulse = tensor(slots).applyfunc(exact)
        require(not same_matrix(pulse*projection, projection*pulse),
                "Projection stress example accidentally preserves the physical subspace")
        pulses.append(pulse)
        original_pulses.append(tensor([(g*original_field).applyfunc(exact) for g in real_slots]))
        negative_original_pulses.append(
            tensor([(g*original_negative).applyfunc(exact) for g in real_slots]))
    physical = exact(sp.trace(word([(dual*static*embedding)*(dual*p*embedding) for p in pulses])))
    slot = exact(sp.trace(word([(static*projection*p).applyfunc(exact) for p in pulses])))
    retained = exact(sp.trace(word([(static*projection*p*projection).applyfunc(exact) for p in pulses])))
    require(physical == slot == retained != 0, "Physical and slot traces disagree")
    original = exact(sp.trace(word([static*projection*p for p in original_pulses])))
    negative = exact(sp.trace(word([static*projection*p for p in negative_original_pulses])))
    require(exact(original-slot) == 0, "Common change of qubit basis changed the trace")
    require(exact(sp.conjugate(original)-negative) == 0, "Same-sample negative-field conjugation failed")
    require(exact(sp.im(original)) != 0, "Conjugation sign example became vacuous")
    uniform_lower = 2**2 * Q(3, 2)**(2*n)
    require(modulus_sq(slot) >= uniform_lower**2, "Pulse-independent lower bound failed")
    return {
        "physical_spin": "1", "sites": 2, "slots": n, "layers": 2,
        "physical_dimension": 9, "slot_dimension": 16,
        "static_generator": "H=(1/2) sum_(i in {0,1},j in {2,3}) swap(i,j)-I",
        "static_annihilator": "H(H+2I)(H+I)(H-I)=0",
        "static_exponential": "E=exp((log 2) H)",
        "exact_interpolation_polynomial": str(static_polynomial),
        "exchange_scalar_c": "2",
        "field_eigenvalues": ["2", "1/2"],
        "field_ratio": "1/4",
        "pulses_commute_with_projection": False,
        "physical_trace": complex_pair(physical),
        "slot_trace": complex_pair(slot),
        "trace_with_all_projections": complex_pair(retained),
        "same_sample_negative_field_trace": complex_pair(negative),
        "uniform_modulus_lower_bound": str(uniform_lower)
    }


def source_binding():
    exchange = (SOURCE / "02-exchange.tex").read_text()
    start = exchange.index(r"\begin{lemma}[Zero-free layered traces]\label{lem:trace-zero-free}")
    end = exchange.index(r"\end{lemma}", start) + len(r"\end{lemma}")
    literal = exchange[start:end]
    for phrase in ("at least one permutation layer", "nonzero scalar", "admissible law",
                   "every two successive", "every slot", r"|x|\le1"):
        require(phrase in literal, f"The literal source hypothesis changed: {phrase}")
    pressure = (SOURCE / "07-pressure.tex").read_text()
    pulse_start = pressure.index(r" U_r(z)=")
    pulse_end = pressure.index(r"\]", pulse_start) + 2
    projection_start = pressure.index(r" \Tr_{\rm phys}\prod_{r=1}^k")
    projection_end = pressure.index(r"\]", projection_start) + 2
    return {
        "exchange_file": str((SOURCE / "02-exchange.tex").relative_to(ROOT)),
        "label": "lem:trace-zero-free",
        "line_start": exchange[:start].count("\n")+1,
        "line_end": exchange[:end].count("\n")+1,
        "literal_latex": literal,
        "application_file": str((SOURCE / "07-pressure.tex").relative_to(ROOT)),
        "ordered_pulse_latex": pressure[pulse_start:pulse_end],
        "projection_trace_latex": pressure[projection_start:projection_end],
        "does_not_certify_thermodynamic_main_theorems": True
    }


def jacobian_evidence():
    payload = json.loads((HERE / "jacobian_enclosure_payload.json").read_text())
    output = json.loads((HERE / "jacobian_enclosure_output.json").read_text())
    require(output["server"]["version"] == "0.14.0", "Jacobian version changed")
    require(output["protocol_version"] == "2025-11-25", "Jacobian protocol changed")
    require(output["request"]["payload"] == payload, "Adapter payload is not the inspected input")
    result = output["result"]
    require(result["operation_id"] == "polynomial.box.enclosure.compute", "Wrong adapter operation")
    typed = result["output"]
    require(typed["box"] == payload["box"] and typed["polynomial"] == payload["polynomial"],
            "Typed result is not bound to the exact polynomial and box")
    require(typed["enclosure"] == {"lower": {"num": "1", "den": "2"},
                                  "upper": {"num": "1", "den": "1"}},
            "Unexpected or inconclusive margin enclosure")
    return {"operation_id": result["operation_id"], "server_version": output["server"]["version"],
            "protocol": output["protocol_version"], "adapter_status": "success",
            "payload_file": "jacobian_enclosure_payload.json",
            "typed_output_file": "jacobian_enclosure_output.json",
            "enclosure": typed["enclosure"],
            "scope": "bounded continuum check; not the universal trace theorem"}


def lean_binding():
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "No successful real Lean run")
    require(result["proof_holes"] == [], "Lean proof has holes")
    source_digest = hashlib.sha256((HERE / "Main.lean").read_bytes()).hexdigest()
    fidelity_digest = hashlib.sha256((HERE / "statement_fidelity.md").read_text().encode()).hexdigest()
    require(result["source_sha256"] == source_digest, "Lean source changed after compilation")
    require(result["statement_fidelity_sha256"] == fidelity_digest,
            "Statement fidelity changed after compilation")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claims = [c for c in state["claims"] if c["claim_id"] == "C_ZERO_FREE_CYCLIC_TRACES"]
    require(bool(claims), "The goal is missing from the campaign ledger")
    current = max(claims, key=lambda c: c["version"])
    records = [e for e in state["evidence"]
               if e["tier"] == "mechanical" and e["verdict"] == "supports"
               and e["subject"]["subject_id"] == current["claim_id"]
               and e["subject"]["content_hash"] == current["content_hash"]]
    require(len(records) == 1, "Expected exactly one current claim-bound mechanical certificate")
    certificate = ROOT / records[0]["artifact"]
    require(certificate.is_file(), "The claim-bound compiler certificate is missing")
    require("4.31.0" in json.dumps(result), "Compiler evidence does not identify Lean 4.31.0")
    return {
        "claim": current["claim_id"], "exit_code": 0, "proof_holes": [],
        "source_sha256": source_digest, "statement_fidelity_sha256": fidelity_digest,
        "claim_bound_certificate": records[0]["artifact"],
        "formal_scope": "arbitrary-count contraction, exact trace, disk algebra and projection algebra",
        "not_a_kernel_proof_of_bbl_or_the_full_source_translation": True
    }


def certificate():
    return {
        "claim": "C_ZERO_FREE_CYCLIC_TRACES",
        "result_class": "new_theorem",
        "description": "Universal cyclic trace verification with a sharp quantitative contraction refinement",
        "research_target_level": "publishable", "math_objective_mode": "exploratory",
        "independent_review": "pending Host-invoked Reviewer",
        "novelty_status": "not_yet_independently_verified",
        "significance_status": "not_yet_independently_verified",
        "source_binding": source_binding(),
        "universal_theorems": {
            "trace_bound": "|Tr product K_r| >= |product c_r product (M_ri)_00| (1-1/R)^(mN)",
            "counts": "every finite N>=0 and m>=1, not bounded by the test cases",
            "admissibility": "limits of ordered independent Bernoulli transpositions and deterministic permutations",
            "pulse_bound": "|physical trace| >= c^k [2 sinh(t Re(z)/(2k))]^(kN)",
            "proof": "report.md, Sections 1-5",
            "formal_core": "Main.lean; statement_fidelity.md"
        },
        "symbolic_identities": symbolic_identities(),
        "exact_network_tests": [cyclic_network(n, m)
                                for n, m in ((0, 1), (1, 1), (1, 3), (2, 1),
                                             (2, 2), (2, 3), (3, 2))],
        "physical_projection_test": physical_projection_example(),
        "jacobian": jacobian_evidence(), "lean": lean_binding()
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true",
                        help="persist the exact output, then verify the persisted JSON")
    args = parser.parse_args()
    computed = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(computed, indent=2, sort_keys=True) + "\n")
    require(json.loads(path.read_text()) == computed, "Persisted exact certificate does not replay")
    print("Verified: universal Lean core; 7 exact cyclic networks; noncommuting spin-1 "
          "pulse/projection identity; source and typed Jacobian bindings. Independent review pending.")


if __name__ == "__main__":
    main()
