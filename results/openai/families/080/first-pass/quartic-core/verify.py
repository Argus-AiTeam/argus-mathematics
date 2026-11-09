#!/usr/bin/env python3
"""Replay the exact core, not the analytic operator estimates in report.md."""

import hashlib
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
FRAME = (
    ROOT
    / "research/openai_manuscript"
    / "Endpoint-convergence-for-the-planar-Schrodinger-equation-September-24-2026"
    / "build/sections/05-frame.tex"
)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def constant(value, dimension):
    value = Fraction(value)
    return {(0,) * dimension: value} if value else {}


def variable(index, dimension):
    exponents = [0] * dimension
    exponents[index] = 1
    return {tuple(exponents): Fraction(1)}


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for exponent, coefficient in polynomial.items():
            result[exponent] = result.get(exponent, Fraction(0)) + coefficient
    return {e: c for e, c in result.items() if c}


def scale(polynomial, coefficient):
    return {e: c * coefficient for e, c in polynomial.items() if c * coefficient}


def multiply(left, right):
    result = {}
    for e, c in left.items():
        for f, d in right.items():
            exponent = tuple(a + b for a, b in zip(e, f, strict=True))
            result[exponent] = result.get(exponent, Fraction(0)) + c * d
    return {e: c for e, c in result.items() if c}


def square(polynomial):
    return multiply(polynomial, polynomial)


def equal(left, right, name):
    require(left == right, f"Exact polynomial identity failed: {name}")


def parse_typed_polynomial(polynomial):
    result = {}
    for term in polynomial["polynomial"]["terms"]:
        exponent = tuple(term["exponents"])
        require(exponent not in result, "Repeated typed monomial")
        require(len(exponent) == len(polynomial["variables"]), "Wrong polynomial axis")
        coefficient = term["coefficient"]
        require(int(coefficient["den"]) > 0, "Nonpositive rational denominator")
        result[exponent] = Fraction(int(coefficient["num"]), int(coefficient["den"]))
    return {e: c for e, c in result.items() if c}


def equation(source, label):
    marker = "\\begin{equation}\\label{" + label + "}"
    start = source.index(marker)
    end = source.index("\\end{equation}", start) + len("\\end{equation}")
    return source[start:end]


def normalized(text):
    return "".join(text.split())


def check_source():
    source = FRAME.read_text()
    expected_error = r"""
\begin{equation}\label{eq:src21}
 |\operatorname{Err}_j|\lesssim_K\lambda^2
 \left[\left(\frac{\Delta_0}{\Delta_{j-1}}\right)^2D+
 \sum_{m<j}\left(\frac{\Delta_m}{\Delta_{j-1}}\right)^2l_m\right].
\end{equation}
"""
    expected_growth = r"""
\begin{equation}\label{eq:src22}
 \sum_{j=1}^n\int_{\R^2}(G_j-G_{j-1})(u)
       |\widehat{|g_{j-1}|^2}(u,\tau)|^2\,du\,d\tau
 \lesssim_K\lambda^2D.
\end{equation}
"""
    error = equation(source, "eq:src21")
    growth = equation(source, "eq:src22")
    require(normalized(error) == normalized(expected_error), "Error assertion changed")
    require(normalized(growth) == normalized(expected_growth), "Growth assertion changed")
    for anchor in (
        r"1-\rho_a=\sum_e\chi_e(\Delta^2t)m_e(r_x)",
        r"m_e=\psi*\mathbf1_{\{r:\dist(r,A_e)<K+2\}}",
        r"\sum_e\chi_e(\Delta^2t)=1",
        r"\int p^2=1",
        r"\sum_jl_j\leq D",
        r"\mathcal L=iD_a+(\partial_x-ia)^2",
    ):
        require(normalized(anchor) in normalized(source), f"Missing actual input: {anchor}")
    return {
        "path": str(FRAME.relative_to(ROOT)),
        "eq:src21": error,
        "eq:src22": growth,
        "mask_construction_anchor": True,
        "energy_contraction_anchor": True,
    }


def check_polynomial_core():
    a, b, d = (variable(i, 3) for i in range(3))
    xi3 = add(b, d, scale(a, -1))
    resonance = add(square(a), scale(square(b), -1), square(xi3), scale(square(d), -1))
    equal(
        resonance,
        scale(multiply(add(a, scale(b, -1)), add(a, scale(d, -1))), 2),
        "quartet resonance",
    )
    x, u, v, center = (variable(i, 4) for i in range(4))
    midpoint = add(x, scale(add(u, v), Fraction(-1, 2)))
    frequencies = (x, add(x, scale(u, -1)), add(x, scale(u, -1), scale(v, -1)),
                   add(x, scale(v, -1)))
    left = add(*(square(add(f, scale(center, -1))) for f in frequencies))
    right = add(scale(square(add(center, scale(midpoint, -1))), 4), square(u), square(v))
    equal(left, right, "Gaussian completion of squares")

    ju, jv, pu, pv = (variable(i, 4) for i in range(4))
    one = constant(1, 4)
    error = add(
        multiply(add(one, scale(ju, -1)), add(one, scale(jv, -1))),
        scale(multiply(add(one, scale(pu, -1)), add(one, scale(pv, -1))), -1),
    )
    equal(
        add(multiply(ju, jv), scale(multiply(pu, pv), -1)),
        add(ju, scale(pu, -1), jv, scale(pv, -1), error),
        "potential increment with its signed error",
    )
    return resonance


def check_tensor_core():
    S, T, bs, bt, os, ot = (variable(i, 6) for i in range(6))
    tensor = add(multiply(bs, bt), scale(multiply(os, ot), -1))
    error = add(
        multiply(multiply(S, bs), multiply(T, bt)),
        scale(multiply(multiply(S, os), multiply(T, ot)), -1),
    )
    quotient = scale(tensor, Fraction(1, 4))
    equal(error, scale(multiply(multiply(S, T), quotient), 4),
          "globally twice-divided rank-two tensor quotient")

    k = variable(0, 1)
    one = constant(1, 1)
    equal(add(add(k, one), scale(k, -1)), one,
          "reciprocal-square comparison after clearing k*(k+1)^2")
    for k_value in range(1, 129):
        gap = Fraction(1, k_value * (k_value + 1)) - Fraction(1, (k_value + 1) ** 2)
        require(gap == Fraction(1, k_value * (k_value + 1) ** 2),
                "Rational reciprocal-square comparison failed")
        require(gap > 0, "Incorrect reciprocal-square comparison sign")
    return {
        "factorization": "E_B(s,t)=(2*s*t)^2*(r_B(s)*r_B(t)-r_1(s)*r_1(t))/4",
        "tensor_rank_at_most": 2,
        "curvature_transfers": 2,
        "unit_offset_weight": "(1+abs(p))^-2",
        "absolute_lattice_weight_bound": "9 by the positive-denominator comparison in report.md",
        "formal_geometric_majorant": "25 using geometric_bound at r=1/2",
        "rational_comparison_checks": 128,
        "analytic_kernel_bounds_machine_checked": False,
    }


def check_summation_core():
    n, p = (variable(i, 2) for i in range(2))
    one = constant(1, 2)

    def tail_formula(n_value, p_value, boundary, slope):
        return add(constant(boundary, 2),
                   scale(multiply(add(scale(n_value, slope), constant(boundary, 2)),
                                  p_value), -1))

    for boundary, slope, summand_slope, summand_constant in ((6, 4, 2, 1), (8, 2, 1, 3)):
        current = tail_formula(n, p, boundary, slope)
        following = tail_formula(add(n, one), scale(p, Fraction(1, 2)), boundary, slope)
        increment = multiply(
            add(scale(n, summand_slope), constant(summand_constant, 2)), p
        )
        equal(add(following, scale(current, -1)), increment, "all-depth dyadic recurrence")
        equal(
            tail_formula({}, constant(1, 2), boundary, slope),
            {},
            "dyadic induction base N=0",
        )

    r, total, power = (variable(i, 3) for i in range(3))
    one = constant(1, 3)
    current_defect = add(
        multiply(add(one, scale(r, -1)), total), scale(one, -1), power
    )
    following_defect = add(
        multiply(add(one, scale(r, -1)), add(total, power)),
        scale(one, -1),
        multiply(power, r),
    )
    equal(current_defect, following_defect, "geometric induction step")

    a0, an, following, deletions, increments, mixed = (variable(i, 6) for i in range(6))
    old_defect = add(increments, scale(an, -1), a0, scale(deletions, -1))
    new_defect = add(
        increments, mixed, scale(an, -1), scale(following, -1), a0,
        scale(deletions, -1), scale(mixed, -1), following,
    )
    equal(old_defect, new_defect, "changing-state potential telescoping recurrence")

    rows = []
    for z in range(65):
        Z = Fraction(2) ** z
        row = 1 / Z
        for k in range(-z, z + 1):
            U = Fraction(2) ** k
            symbol = min(U * U, Fraction(1)) / (U * U * Z * Z)
            offsets = Z * max(Fraction(1), U)
            row += symbol * offsets
        require(row == (z + 3) / Z - 1 / (Z * Z), "Incorrect rational offset row")
        require(row <= (z + 3) / Z, "Offset row exceeds analytic majorant")
        if z in (0, 1, 2, 8, 32, 64):
            rows.append({"z": z, "exact_normalized_row": str(row)})
    return {
        "proof_method": "polynomial induction identities, with all-natural-depth Lean theorems",
        "dyadic_partial_sum": "6-(4*N+6)/2^N <= 6",
        "rectangle_partial_sum": "8-(2*N+8)/2^N <= 8",
        "geometric_partial_sum": "(1-r)*sum(k<N,r^k)=1-r^N; 0<=r<1",
        "potential_telescoping": "exact changing-state induction recurrence with favorable initial sign",
        "rational_offset_row_checks": 65,
        "row_checks_are_not_an_analytic_proof": True,
        "rows_are_a_nonsharp_dyadic_corollary_of_the_tensor_bound": True,
        "selected_rows": rows,
    }


def check_jacobian(resonance):
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    require(status["adapter_exit_status"] == 0 and not status["timeout"], "Adapter failed")
    require(response["request"]["payload"] == payload, "Adapter payload was not preserved")
    require(response["server"]["version"] == status["server_version"], "Server version changed")
    require(response["protocol_version"] == status["protocol_version"], "Protocol changed")
    require(response["result"]["operation_id"] == status["operation_id"], "Wrong operation")
    output = response["result"]["output"]
    require(output["status"] == "FACTORIZED", "No exact mathematical factorization")
    require(output["product_reconstruction"] == "EXACT", "Inexact reconstruction")
    equal(parse_typed_polynomial(payload["polynomial"]), resonance, "typed request")
    equal(parse_typed_polynomial(output["reconstructed"]), resonance, "typed reconstruction")
    coefficient = output["coefficient"]
    product = constant(Fraction(int(coefficient["num"]), int(coefficient["den"])), 3)
    for item in output["factors"]:
        require(item["factor"]["variables"] == ["a", "b", "d"], "Factor axes changed")
        factor = parse_typed_polynomial(item["factor"])
        for _ in range(item["multiplicity"]):
            product = multiply(product, factor)
    equal(product, resonance, "independent reconstruction of Jacobian factors")
    return {
        "operation_id": status["operation_id"],
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_status": status["adapter_exit_status"],
        "typed_status": output["status"],
        "structured_error": status["structured_error"],
        "timeout": status["timeout"],
        "scope": "quartet polynomial only",
    }


def check_lean():
    result = json.loads((HERE / "lean/lean_check.json").read_text())
    recording = json.loads((HERE / "lean_verify_output.json").read_text())
    require(result["status"] == "success", "Lean did not verify the exact core")
    require(result["exit_code"] == 0 and result["proof_holes"] == [], "Lean proof has holes")
    require(recording["kernel"]["recorded"] is not None, "Compiler outcome was not recorded")
    source = HERE / "lean/Main.lean"
    fidelity = HERE / "lean/statement_fidelity.md"
    require(
        hashlib.sha256(source.read_bytes()).hexdigest() == result["source_sha256"],
        "Lean source changed after its compiler run",
    )
    require(
        hashlib.sha256(fidelity.read_text().encode()).hexdigest()
        == result["statement_fidelity_sha256"],
        "Statement fidelity changed after its compiler run",
    )
    return {
        "claim": "C_Q_SERIES_CORE",
        "source": "research/quartic-core/lean/Main.lean",
        "statement_fidelity": "research/quartic-core/lean/statement_fidelity.md",
        "compiler_result": "research/quartic-core/lean/lean_check.json",
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "scope": "exact polynomial identities and arbitrary-finite-depth summation bounds only",
    }


def main():
    sources = check_source()
    resonance = check_polynomial_core()
    tensor = check_tensor_core()
    summations = check_summation_core()
    jacobian = check_jacobian(resonance)
    lean = check_lean()
    certificate = {
        "schema_version": 1,
        "claim": "C_Q_GROWTH",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "result_class": "verification_theorem_candidate",
        "mathematical_result": "Theorem T in report.md: two-derivative defect-budget bound and its actual-mask application to eq:src21 and eq:src22.",
        "engineer_proof": "research/quartic-core/report.md",
        "mechanical_replay": "passed",
        "analytic_operator_estimates_machine_checked": False,
        "independent_review": "required_pending_host",
        "novelty_status": "not_established",
        "significance_status": "pending_independent_assessment",
        "false_manuscript_assertions_established": [],
        "source_assertions": sources,
        "exact_polynomial_identities": [
            "quartet resonance",
            "Gaussian completion of squares",
            "potential increment with signed error",
            "globally twice-divided rank-two tensor quotient",
        ],
        "summation_evidence": summations,
        "global_tensor_quotient": tensor,
        "jacobian": jacobian,
        "lean": lean,
        "limitations": [
            "The Fourier-kernel, Holder, Duhamel and cap-induction proofs are analytic prose requiring independent review.",
            "Finite rational row checks alone do not prove an analytic estimate.",
            "Neither manuscript's full endpoint convergence theorem is certified here.",
        ],
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print("Exact quartic/tensor identities, actual-mask anchors, summation core and typed Jacobian result: PASS")
    print("Full analytic proof and originality: independent review required")


if __name__ == "__main__":
    main()
