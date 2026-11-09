#!/usr/bin/env python3
"""Replay exact algebraic evidence; do not replace the infinite-law proof."""

import argparse
import hashlib
import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = (
    ROOT
    / "research/openai_manuscript"
    / "The-sharp-factor-of-IID-threshold-for-the-free-Ising-model-on-regular-trees-September-26-2026"
    / "build/sections"
)


def certificate():
    checks = []

    def require(name, condition, scope="universal algebraic identity"):
        if not condition:
            raise AssertionError(f"{name}: exact verification failed")
        checks.append({"name": name, "scope": scope, "result": "passed"})

    def zero(name, expression):
        require(name, sp.cancel(sp.expand(expression)) == 0)

    u, v, theta, q, b, x, lam = sp.symbols("u v theta q b x lambda")
    fusion = ((u + v) ** 2 / (1 + u * v) + (u - v) ** 2 / (1 - u * v)) / 2
    loss = u**2 * v**2 * (2 - u**2 - v**2) / (1 - u**2 * v**2)
    zero("sign-symmetrized binary fusion", fusion - (u**2 + v**2 - loss))
    zero(
        "fusion loss lower-bound numerator",
        u * v * (2 - u - v) - 2 * (1 - q) * u * v - u * v * (2 * q - u - v),
    )
    a = (1 - x**2) / (1 - theta**2 * x**2)
    zero(
        "normalized cavity transition slope",
        ((x + theta) / (1 + theta * x) - (x - theta) / (1 - theta * x)) / 2
        - theta * a,
    )
    zero(
        "log-factor derivative in tanh coordinates",
        sp.diff(a, x) * (1 - x**2) / a
        + 2 * (1 - theta**2) * x / (1 - theta**2 * x**2),
    )
    zero("strict vertex spectral gap", (b + 1) ** 2 - 4 * b - (b - 1) ** 2)

    rho, f, g = sp.symbols("rho f g")
    gram = f**2 + g**2 + 2 * lam * f * g
    zero(
        "lower lift-Gram sum of squares",
        gram
        - (1 - rho) * (f**2 + g**2)
        - ((rho + lam) * (f + g) ** 2 + (rho - lam) * (f - g) ** 2) / 2,
    )
    zero(
        "upper lift-Gram sum of squares",
        (1 + rho) * (f**2 + g**2)
        - gram
        - ((rho - lam) * (f + g) ** 2 + (rho + lam) * (f - g) ** 2) / 2,
    )

    companion = sp.Matrix([[0, -1], [1, 2 * x]])
    require(
        "companion Cayley-Hamilton identity",
        companion**2 - 2 * x * companion + sp.eye(2) == sp.zeros(2),
    )
    require(
        "companion characteristic polynomial",
        sp.expand(companion.charpoly(lam).as_expr() - (lam**2 - 2 * x * lam + 1)) == 0,
    )
    n = sp.symbols("n", integer=True, nonnegative=True)
    endpoint_n = sp.Matrix([[1 - n, -n], [n, 1 + n]])
    endpoint_next = sp.Matrix([[-n, -n - 1], [n + 1, n + 2]])
    require("endpoint power base case", endpoint_n.subs(n, 0) == sp.eye(2))
    require(
        "endpoint power induction for all natural n",
        sp.simplify(endpoint_n * companion.subs(x, 1) - endpoint_next) == sp.zeros(2),
    )
    s = sp.symbols("s", nonzero=True)
    normalized = sp.Matrix([[0, -1 / s], [s, 2 * x]])
    diagonal = sp.diag(1, s)
    require(
        "similarity to normalized transfer fiber",
        diagonal.inv() * normalized * diagonal == companion,
    )

    r, p, beta, w = sp.symbols("r p beta w")
    zero(
        "partition-square extremizer for two positive parts",
        (p - 1) ** 2 + 1 - r**2 - (p - r) ** 2 - 2 * (r - 1) * (p - r - 1),
    )
    zero("merging positive exponent parts", (u + v) ** 2 - u**2 - v**2 - 2 * u * v)
    zero(
        "geometric cut-cost induction",
        beta * (1 - w) / (1 - theta)
        + beta * w
        - beta * (1 - theta * w) / (1 - theta),
    )
    N, gap, z = sp.symbols("N gap z")
    zero("conditional Chernoff optimizer", (-z * N * gap + N * z**2 / 8).subs(z, 4 * gap) + 2 * N * gap**2)
    zero("summable edge-power generating function", 1 / (1 - q) ** 2 - 1 - q * (2 - q) / (1 - q) ** 2)
    zero("geometric first-moment series", q * sp.diff(q / (1 - q), q) - q / (1 - q) ** 2)

    path_p, j = sp.symbols("path_p j", integer=True)
    reverse_index = path_p - j + 1
    zero("reverse-prefix component-root index", reverse_index - 1 - (path_p - j))
    zero("reverse-prefix excluded-neighbor index", reverse_index - (path_p - j + 1))

    t, V, K, L = sp.symbols("t V K L", positive=True)
    I = 1 + sp.log(K / V)
    require(
        "double-exponential exception absorption identity",
        sp.simplify(sp.exp(-2 * I) - sp.exp(-2) * (V / K) ** 2) == 0,
    )
    require(
        "Osgood transformed derivative",
        sp.simplify(sp.diff(sp.log(I), V) + 1 / (V * I)) == 0,
    )
    require(
        "actual small-time power antiderivative",
        sp.simplify(sp.diff(4 * t ** sp.Rational(1, 4), t) - t ** sp.Rational(-3, 4)) == 0,
    )
    exponent = sp.symbols("exponent", positive=True)
    require(
        "general logarithmic-tail antiderivative",
        sp.simplify(
            sp.diff(sp.log(1 / t) ** (1 - exponent) / (exponent - 1), t)
            - 1 / (t * sp.log(1 / t) ** exponent)
        ) == 0,
    )
    require(
        "actual logarithmic antiderivative has zero initial limit",
        sp.limit(1 / sp.log(1 / t), t, 0, dir="+") == 0,
    )
    require(
        "fixed finite branch cannot supply square-root information",
        sp.limit((t + t**2) / sp.sqrt(t), t, 0, dir="+") == 0,
        "exact obstruction to a rejected method, not a manuscript refutation",
    )
    moment_s = sp.symbols("moment_s", positive=True)
    zero("moment-growth Legendre exponent", 1 + 1 / (moment_s - 1) - moment_s / (moment_s - 1))
    require(
        "actual integer moment tail exponent",
        sp.expand((K * p**2 - p * L / 8) - (K * p - L / 16) * p + p * L / 16) == 0,
    )
    require(
        "q=1 abstract scalar counterexample derivative",
        sp.diff(t, t) == 1 and sp.simplify((1 + sp.log(2 / t)) - sp.log(1 / t) - 1 - sp.log(2)) == 0,
        "method-sharpness construction only; not an observation joining",
    )
    zero(
        "q=1 exact path-noise series",
        t * q / (1 - q) ** 2 - t * q * sp.diff(q / (1 - q), q),
    )

    theta_rational = Fraction(1, 2)
    cylinder_tests = 0
    for sa in (-1, 1):
        for sb in (-1, 1):
            cut_mass = (1 + theta_rational**2 * sa * sb) / 4
            for su in (-1, 1):
                for sv in (-1, 1):
                    joint = Fraction(0)
                    for sr in (-1, 1):
                        mass = Fraction(1, 2)
                        for parent, child in ((sr, sa), (sr, sb), (sa, su), (sb, sv)):
                            mass *= (1 + theta_rational * parent * child) / 2
                        joint += mass
                    expected = ((1 + theta_rational * sa * su) / 2) * ((1 + theta_rational * sb * sv) / 2)
                    if joint / cut_mass != expected:
                        raise AssertionError("conditional broadcast cylinder factorization failed")
                    cylinder_tests += 1
    require(
        "conditioned cut cylinder factorization",
        cylinder_tests == 16,
        "finite exact diagnostic at d=5, theta=1/2; infinite extension is proved in PROOF.md",
    )

    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    adapter = json.loads((HERE / "jacobian_output.json").read_text())
    adapter_status = json.loads((HERE / "jacobian_status.json").read_text())
    operation = "matrix.symbolic.characteristic_polynomial.compute"
    require(
        "Jacobian adapter completed without timeout or transport error",
        adapter_status["operation_id"] == operation
        and adapter_status["adapter_exit_code"] == 0
        and adapter_status["timeout"] is False
        and adapter_status["stderr"] == "",
        "typed adapter replay",
    )
    require(
        "Jacobian exact request binding",
        adapter["request"]["operation_id"] == operation
        and adapter["request"]["payload"] == payload
        and adapter["result"]["operation_id"] == operation,
        "typed adapter replay",
    )

    def rational_function(entry):
        require("Jacobian coefficient domain", entry["variables"] == ["x"] and entry["domain"] == "QQ", "typed adapter replay")

        def polynomial(terms):
            value = sp.Integer(0)
            for term in terms:
                num = int(term["coefficient"]["num"])
                den = int(term["coefficient"]["den"])
                require("Jacobian coefficient denominator", den > 0, "typed adapter replay")
                require("Jacobian coefficient arity", len(term["exponents"]) == 1, "typed adapter replay")
                value += sp.Rational(num, den) * x ** term["exponents"][0]
            return value

        denominator = polynomial(entry["denominator"]["terms"])
        require("Jacobian rational-function denominator", denominator != 0, "typed adapter replay")
        return sp.cancel(polynomial(entry["numerator"]["terms"]) / denominator)

    output = adapter["result"]["output"]
    require("Jacobian polynomial shape", output["degree"] == 2 and output["convention"] == "DET_LAMBDA_I_MINUS_A", "typed adapter replay")
    coefficients = [rational_function(entry) for entry in output["coefficients_descending"]]
    require("Jacobian all-symbolic coefficients", coefficients == [1, -2 * x, 1], "typed adapter replay")

    section7 = (SOURCE / "07-path-averages.tex").read_text()
    section8 = (SOURCE / "08-critical-comparison.tex").read_text()
    needles7 = [
        r"\label{prop:weighted-paths}",
        r"Q_r(t)&\le C e^{-c\omega(t)r}\,rS(t)",
        r"L_r(t)&\le C e^{-c\omega(t)r}\,V(t)",
        r"G_p^-(v_p;\{v_{p+1}\})",
        r"\frac{4\beta}{1-\theta}",
    ]
    needles8 = [
        r"\label{prop:critical-uniqueness}",
        r"$V(t)=0$ for every $t\ge0$.",
        r"\frac{I(t)}{\log^2(1/t)}",
        r"R=\left\lceil C_1\bigl(\omega^{-1}+\log I\bigr)\right\rceil",
    ]
    require("literal weighted-path source binding", all(text in section7 for text in needles7), "manuscript statement binding, not a proof")
    require("literal critical-closure source binding", all(text in section8 for text in needles8), "manuscript statement binding, not a proof")

    lean = json.loads((HERE / "lean_check.json").read_text())
    validation = json.loads((HERE / "lean_validation.json").read_text())
    require(
        "Lean real compiler success with no proof holes",
        lean["status"] == "success" and lean["exit_code"] == 0 and lean["proof_holes"] == [],
        "kernel-checked finite-dimensional core only",
    )
    require(
        "required Lean toolchain version",
        "version 4.31.0," in lean["tools"]["lean"]["version"],
        "compiler environment",
    )
    require(
        "Lean source is the compiled source",
        hashlib.sha256((HERE / "Main.lean").read_bytes()).hexdigest() == lean["source_sha256"],
        "compiler record freshness",
    )
    require(
        "Lean statement fidelity is the compiled reading",
        hashlib.sha256((HERE / "statement_fidelity.md").read_text().encode()).hexdigest()
        == lean["statement_fidelity_sha256"],
        "compiler record freshness",
    )
    require(
        "post-compiler campaign-local checks",
        validation["project_root"] == str(ROOT)
        and validation["lean_exit_code"] == 0
        and validation["math_state_exit_code"] == 0
        and validation["proof_graph_exit_code"] == 0,
        "structural checks, not mathematical review",
    )
    return {
        "schema_version": 1,
        "result_class": "new_theorem",
        "result_status": "engineer_proof_and_partial_formal_certification; independent_review_required",
        "manuscript_refutation_identified": False,
        "theorems": {
            "C_CE_VERIFICATION": {
                "statement": "For every integer d>=3, at theta=(d-1)^(-1/2), the actual compatible innovation-conditioned copies obey the stated Q_r,L_r bounds with the exact length restriction, and V(t)=0 for every t>=0.",
                "evidence_type": "analytic proof in PROOF.md, with exact algebraic and partial Lean support",
                "not_kernel_verified": ["infinite sigma-fields", "spectral transfer", "stochastic transport", "concentration", "expectation induction", "absolutely continuous comparison"],
            },
            "C_CE_CLOSURE": {
                "statement": "The same estimate closure works for any positive local flatness exponent and any marginal log-tail exponent q>1; q>1 is sharp for this abstract system of estimates.",
                "evidence_type": "general theorem and method-sharpness construction in PROOF.md",
                "caution": "The q=1 scalar construction is not a counterexample to any manuscript assertion or to the Ising threshold.",
            },
            "C_CE_ALGEBRA": {
                "statement": "All declarations described in statement_fidelity.md are proved in Main.lean.",
                "evidence_type": "real Lean compiler run; probability claims excluded",
                "proof_holes": [],
            },
        },
        "quantifiers": {
            "degree": "every integer d>=3; constants may depend on d, not uniformly on all degrees",
            "time": "every finite horizon T>0, 0<t<=T; uniqueness for all t>=0",
            "length": "weighted Q_r bound for every integer r>=2*ceil(C0/omega(t)); L_r actually needs only ceil(C0/omega(t)); unweighted bounds for all r>=1",
            "joining": "actual conditional copies given the entire innovation array; weighted bounds also hold for any invariant joining with the same marginals and a deterministic site-discrepancy bound",
        },
        "constants_and_bounds": {
            "omega": "min(sqrt(t),1)",
            "c_beta": "min(sech(2*beta+1)^4, tanh(1)^2/beta^2)",
            "c0": "min(1/2, c_beta*(1-theta^2)^2*theta^2/5)",
            "eta": "min(c0/4,log(b)/8)",
            "C0": "max(2,4*log(2)/c0)",
            "ell_star": "ceil(C0/omega)",
            "C_cut": "exp(4*beta/(1-theta))",
            "H_T": "2*T+2*d*beta",
            "D_T": "2*H_T/(1-theta)",
            "Q_r": "4*C_cut*C_var*exp(-eta*omega*r/3)*r*S + 4*D_T^2*r^2*exp(-b^(r/12)/(2*b))",
            "L_r": "C_cut*exp(-eta*omega*r)*V + H_T^2*exp(-b^(r/4)/(2*b))",
            "I": "1+log(K_T/V), K_T>max(1,H_T^2), used only for V>0",
            "R": "ceil(C1*(omega^(-1)+log(I))) with C1 satisfying the three inequalities in PROOF.md section 8",
            "actual_integrable_coefficient": "C_T*(1+t^(-3/4)+1/(t*log(1/t)^2)) for sufficiently small t; bounded on later compact intervals",
            "general_integrable_coefficient": "C_T*(1+t^(-3/4)+t^(delta-1)+1/(t*log(1/t)^q)), delta>0,q>1",
        },
        "standard_background": ["conditional-expectation convergence and disintegration", "bounded self-adjoint spectral theorem", "Ito/Levy/Doob/isometry with proved integrability", "chain rule for absolutely continuous real functions on compact ranges"],
        "proof": "research/critical_endpoint/PROOF.md",
        "formal_reading": "research/critical_endpoint/statement_fidelity.md",
        "jacobian": {
            "operation_id": operation,
            "server_version": adapter["server"]["version"],
            "protocol_version": adapter["protocol_version"],
            "payload_file": "research/critical_endpoint/jacobian_payload.json",
            "typed_output_file": "research/critical_endpoint/jacobian_output.json",
            "adapter_status_file": "research/critical_endpoint/jacobian_status.json",
            "conclusion": "exact characteristic polynomial lambda^2-2*x*lambda+1 only",
        },
        "checks": checks,
        "independent_review": {
            "status": "pending Host-invoked Reviewer",
            "required": ["read the analytic proof and statement fidelity", "replay verify.py", "inspect the compiler certificate", "close the prior-scope citation attribution", "record independent judgements on the mathematical claims"],
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(actual, indent=2, ensure_ascii=True) + "\n")
    else:
        expected = json.loads(path.read_text())
        if actual != expected:
            raise AssertionError("exact_certificate.json differs from the rerun")
    print(json.dumps({"result": "passed", "exact_checks": len(actual["checks"]), "independent_review": "pending", "certificate": str(path.relative_to(ROOT))}))


if __name__ == "__main__":
    main()
