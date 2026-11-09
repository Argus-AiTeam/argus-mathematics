#!/usr/bin/env python3
"""Exact algebraic checks for the staggered-fidelity proof; no float tests."""

import argparse
import hashlib
import json
import subprocess
from pathlib import Path

import sympy as s


ROOT = Path(__file__).resolve().parent
VARIABLES = s.symbols("a0 l0 a1 l1")
RESIDUALS = {}


def zero(name, expression):
    residual = s.factor(s.cancel(s.expand(expression)))
    if residual != 0:
        raise AssertionError(f"{name}: {residual}")
    RESIDUALS[name] = "0"


def matrix_zero(name, matrix):
    for i, entry in enumerate(matrix):
        zero(f"{name}[{i}]", entry)


def embedded_local(a, l, site):
    matrix = s.zeros(8)
    for column in range(8):
        bits = [(column >> (2 - k)) & 1 for k in range(3)]
        matrix[column, column] = a if bits[0] == bits[site + 1] else l
        if bits[0] != bits[site + 1]:
            swapped = bits.copy()
            swapped[0], swapped[site + 1] = swapped[site + 1], swapped[0]
            row = sum(bit << (2 - k) for k, bit in enumerate(swapped))
            matrix[row, column] = 1
    return matrix


def sparse_polynomial(expression):
    polynomial = s.Poly(expression, *VARIABLES, domain=s.QQ)
    return {
        "terms": [
            {
                "coefficient": {"num": str(coefficient.p), "den": str(coefficient.q)},
                "exponents": list(exponents),
            }
            for exponents, coefficient in polynomial.terms()
            if coefficient
        ]
    }


def typed_matrix(matrix):
    names = [str(variable) for variable in VARIABLES]
    return {
        "variables": names,
        "entries": [
            [
                {
                    "domain": "QQ",
                    "variables": names,
                    "numerator": sparse_polynomial(entry),
                    "denominator": sparse_polynomial(s.Integer(1)),
                }
                for entry in row
            ]
            for row in matrix.tolist()
        ],
    }


def monodromy_checks():
    a0, l0, a1, l1 = VARIABLES
    left = embedded_local(a0, l0, 0)
    right = embedded_local(a1, l1, 1)
    monodromy = left * right
    za = s.diag(1, 1, 1, 1, -1, -1, -1, -1)
    z0 = s.diag(1, 1, -1, -1, 1, 1, -1, -1)
    z1 = s.diag(1, -1, 1, -1, 1, -1, 1, -1)
    physical = (za * left * z0) * (za * right * z1)
    matrix_zero("two_site_physical_gauge", physical - z0 * monodromy * z0 * z0 * z1)
    star = {a0: -l0, l0: -a0, a1: -l1, l1: -a1}
    b = monodromy[:4, 4:]
    c = monodromy[4:, :4]
    matrix_zero("B_adjoint_plus_C", b.xreplace(star).T + c)
    payload = {"left": typed_matrix(left), "right": typed_matrix(right)}
    return payload, monodromy


def jet_checks():
    t = s.symbols("t")
    rho, lp, lpp, hp, hpp, k0, k2, c1, c2 = s.symbols(
        "rho lp lpp hp hpp k0 k2 c1 c2"
    )
    h = hp * t + hpp * t**2 / 2
    density = rho + lp * t + lpp * t**2 / 2
    z = 2 * s.pi * s.I * h * density
    e_jet = 1 + z / 2 + z**2 / 6
    bracket = 1 + c1 * h + c2 * h**2 / 2
    column = k0 + k2 * h**2 / 2 + density * e_jet * bracket
    zp = 2 * s.pi * s.I * rho * hp
    zpp = 2 * s.pi * s.I * (rho * hpp + 2 * hp * lp)
    first = lp + rho * (zp / 2 + c1 * hp)
    second = (
        k2 * hp**2
        + lpp
        + 2 * lp * (zp / 2 + c1 * hp)
        + rho * (zpp / 2 + zp**2 / 3 + c2 * hp**2 + c1 * hpp + zp * c1 * hp)
    )
    zero("coalescent_first_jet", s.diff(column, t).subs(t, 0) - first)
    zero("coalescent_second_jet", s.diff(column, t, 2).subs(t, 0) - second)
    v, w, rhop, rhopp, dotrho, dotrhop, ddotrho = s.symbols(
        "v w rhop rhopp dotrho dotrhop ddotrho"
    )
    theta = s.symbols("theta")
    for orientation in ("AC", "CA"):
        displacement = theta * (v * t + w * t**2 / 2)
        time_first = 0 if orientation == "AC" else dotrho
        time_first_space = 0 if orientation == "AC" else dotrhop
        time_second = 0 if orientation == "AC" else ddotrho
        integrand = (
            rho
            + rhop * displacement
            + rhopp * displacement**2 / 2
            + t * (time_first + time_first_space * displacement)
            + time_second * t**2 / 2
        )
        averaged = s.integrate(integrand, (theta, 0, 1))
        expected_first = time_first + rhop * v / 2
        expected_second = time_second + time_first_space * v + rhopp * v**2 / 3 + rhop * w / 2
        zero(f"{orientation}_L_first_jet", s.diff(averaged, t).subs(t, 0) - expected_first)
        zero(f"{orientation}_L_second_jet", s.diff(averaged, t, 2).subs(t, 0) - expected_second)
    vi, vj, wi, wj, fp, fpp = s.symbols("vi vj wi wj fp fpp")
    second_pair_derivative = (
        fpp * (vj**2 + vi**2 - (vi - vj)**2)
        + fp * (-wj + wi - (wi - wj))
    )
    zero("pair_acceleration_cancellation", second_pair_derivative - 2 * vi * vj * fpp)
    eta, n, k = s.symbols("eta n k")
    excess = n * (1 - eta) - (n - k) * (1 - 2 * eta) / 2 - (n - k) / 2
    zero("half_filling_escape_obstruction", excess - k * (1 - eta))


def kernel_checks():
    x, t = s.symbols("x t")
    cosine = (1 - t**2) / (1 + t**2)
    sine = 2 * t / (1 + t**2)
    q = cosine + s.I * sine
    hyperbolic_cosine = (x + 1 / x) / 2
    bare = sine / (s.pi * (hyperbolic_cosine - cosine))
    kernel = 2 * sine * cosine / (s.pi * (hyperbolic_cosine - (cosine**2 - sine**2)))
    bare_ratio = (x - q) / (x * q - 1)
    scattering = (x * q**2 - 1) / (x - q**2)
    plus = (x * q**2 + 1) / (x * q**2 - 1)
    minus = (x + q**2) / (x - q**2)
    zero("bare_counting_log_derivative", 2 * x * s.diff(bare_ratio, x) / bare_ratio - 2 * s.pi * s.I * bare)
    zero("scattering_counting_log_derivative", 2 * x * s.diff(scattering, x) / scattering + 2 * s.pi * s.I * kernel)
    zero("K_as_coth_difference", (plus - minus) / (-2 * s.pi * s.I) - kernel)
    coth_shift_zero = (q**2 + 1) / (q**2 - 1)
    zero("coalescent_V_first", -coth_shift_zero - s.I * cosine / sine)
    zero("coalescent_V_second", 2 * (s.Rational(1, 3) + coth_shift_zero**2 - 1) - 2 * (s.Rational(1, 3) - 1 / sine**2))


def one_root_checks():
    r = s.symbols("r", positive=True)
    sin_lambda = s.Rational(4, 5)
    cos_lambda = -s.Rational(3, 5)
    q = cos_lambda + s.I * sin_lambda
    sin_half, cos_half = 2 / s.sqrt(5), 1 / s.sqrt(5)
    cosh_a, sinh_a = 3 / (2 * s.sqrt(2)), 1 / (2 * s.sqrt(2))
    cy, sy = (r + 1 / r) / 2, (r - 1 / r) / 2

    def local(sign):
        ch = cy * cosh_a + sign * sy * sinh_a
        sh = sy * cosh_a + sign * cy * sinh_a
        return (
            (sin_half * ch - s.I * cos_half * sh) / sin_lambda,
            (-sin_half * ch - s.I * cos_half * sh) / sin_lambda,
        )

    a0, l0 = local(1)
    a1, l1 = local(-1)
    av, lv = s.factor(a0 * a1), s.factor(l0 * l1)
    vector = s.Matrix([a0, l1])
    initial = vector.subs(r, 1)

    def inner(x, y):
        return s.cancel((s.conjugate(x).T * y)[0])

    norm0, normr = inner(initial, initial), inner(vector, vector)
    physical = s.factor(inner(initial, vector) * inner(vector, initial) / (norm0 * normr))
    shift_plus = (r**2 * q**2 + 1) / (r**2 * q**2 - 1)
    shift_minus = (r**2 + q**2) / (r**2 - q**2)
    coth = (r**2 + 1) / (r**2 - 1)
    scattering = (r**2 * q**2 - 1) / (r**2 - q**2)
    qab = s.cancel(lv / av * scattering)
    qba = s.cancel(av / lv / scattering)
    mac = s.cancel(-((1 + qab) * coth - shift_minus - qab * shift_plus) / (2 * s.pi * s.I))
    mca = s.cancel(-(-(1 + qba) * coth + shift_plus + qba * shift_minus) / (2 * s.pi * s.I))

    def bare(sign):
        e2 = r**2 * (2 if sign == 1 else s.Rational(1, 2))
        return sin_lambda / (s.pi * ((e2 + 1 / e2) / 2 - cos_lambda))

    gy = s.cancel(bare(1) + bare(-1))
    g0 = gy.subs(r, 1)
    zero("one_root_zero_twist_equation", av.subs(r, 1) - lv.subs(r, 1))
    zero("one_root_self_phase_AC", qab.subs(r, 1) + 1)
    zero("one_root_self_phase_CA", qba.subs(r, 1) + 1)
    zero("one_root_AC_coalescence", mac.subs(r, 1) - g0)
    zero("one_root_CA_coalescence", mca.subs(r, 1) - g0)
    pair = 1 + sy**2 / sin_lambda**2
    scalar_overlap = s.cancel(pair * mac * mca / (g0 * gy))
    zero("one_root_normalized_overlap_all_r", scalar_overlap - physical)
    velocity = s.cancel(1 / (s.pi * g0))
    derivative = vector.diff(r).subs(r, 1) * velocity
    metric = s.cancel(inner(derivative, derivative) / norm0 - inner(initial, derivative) * inner(derivative, initial) / norm0**2)
    zero("one_root_exact_metric", metric - s.Rational(481, 1024))
    second_y = (r**2 * s.diff(physical, r, 2) + r * s.diff(physical, r)).subs(r, 1)
    zero("one_root_overlap_quadratic", -velocity**2 * second_y / 2 - metric)
    if not cos_lambda < -s.Rational(1, 2) or not sin_lambda > 0 or not g0 > 0:
        raise AssertionError("The exact finite witness does not satisfy the live hypotheses")
    return {
        "classification": "exact finite consistency check, not an asymptotic proof",
        "L": 2,
        "n": 1,
        "cos_lambda": "-3/5",
        "sin_lambda": "4/5",
        "d": "2*log(2)",
        "b": ["-log(2)/2", "log(2)/2"],
        "root_at_zero_twist": "0",
        "G_at_zero": str(g0),
        "root_velocity": str(velocity),
        "I_L": str(metric),
        "normalized_overlap_as_function_of_exp_y": str(physical),
    }


def fourier_checks():
    a, b, e = s.symbols("a b e")
    half_denominator = 1 / (a * b) - a * b
    s_hat = (1 / b - b) / half_denominator
    k_hat = (a / b - b / a) / half_denominator
    zero("dressed_kernel_factorization", 1 + k_hat - (1 + a**2) * (1 - b**2) / (1 - a**2 * b**2))
    zero("dressed_density_transform", s_hat / (1 + k_hat) - a / (1 + a**2))
    continuous = ((1 - e) * (1 + a * b) / 2 - b + e * a) / (1 - a * b)
    factored = (1 - b) * (1 + e * a) / (1 - a * b)
    for sign in (-1, 1):
        cot = s.I * (e + 1) / (e - 1)
        sampled_pole = (1 - e) * (cot - s.I * sign) / (-2 * s.I)
        continuous_pole = (1 - e) * sign / 2
        correction = s.cancel(sampled_pole - continuous_pole)
        zero(f"sampled_pole_correction_sign_{sign}", correction - (1 + e) / 2)
        zero(f"symbol_factorization_sign_{sign}", continuous + correction - factored)
    relative = (1 + e * a) / (1 + a)

    def phase_derivative(expression):
        return s.I * e * s.diff(expression, e)

    def log_second(expression):
        return phase_derivative(phase_derivative(expression)) / expression - (phase_derivative(expression) / expression)**2

    combined_second = (log_second(relative) + log_second(relative.subs(e, 1 / e))).subs(e, 1)
    zero("both_orientation_log_quadratic", combined_second / 2 + a / (1 + a)**2)
    zero("negative_frequency_logistic", (a / (1 + a)**2).subs(a, 1 / a) - a / (1 + a)**2)
    lam, p = s.symbols("lambda p", positive=True)
    x = s.symbols("x", nonnegative=True)
    antiderivative = -1 / (lam * (1 + x))
    zero("logistic_antiderivative", s.diff(antiderivative, x) - 1 / (lam * (1 + x)**2))
    mass = s.limit(antiderivative, x, s.oo) - antiderivative.subs(x, 0)
    zero("logistic_integral", mass - 1 / lam)
    velocity_per_d = 1 / (2 * (s.pi - lam))
    product_coefficient = 2 * velocity_per_d**2
    determinant_coefficient = -2 * s.pi * velocity_per_d**2 / lam
    zero("final_fidelity_density", product_coefficient + determinant_coefficient + 1 / (2 * lam * (s.pi - lam)))
    q = s.symbols("q")
    sum_q = q / (1 - q)
    sum_m = q * s.diff(sum_q, q)
    sum_m2 = q * s.diff(sum_m, q)
    zero("alias_second_derivative_majorant", sum_m2 - q * (1 + q) / (1 - q)**3)
    return {
        "frequency_signs_checked": [-1, 1],
        "relative_symbol": "(1+E*exp(-lambda*p))/(1+exp(-lambda*p))",
        "pair_log_quadratic_per_length": str(product_coefficient),
        "determinant_log_quadratic_per_length": str(determinant_coefficient),
        "fidelity_density": "1/(2*lambda*(pi-lambda))",
        "logistic_integral_with_dp_over_2pi": "1/(2*pi*lambda)",
        "ordered_remainder": {
            "interior_accuracy_order": "arbitrary fixed m>=8",
            "bound": "C*d^(m-6)+C*d^(-3)*(sqrt(B)+1)/B+C_d*exp(-a*sqrt(B))+C*d^(-3)*exp(-a*pi/d)/(1-exp(-2*a*pi/d))^3",
            "quantifiers": "lambda fixed in (2*pi/3,pi); a,C>0 fixed; for each sufficiently small d>0, B is sufficiently large, and B=L*d/2 with L even",
            "proof": "research/AUDIT_REPORT.md",
            "mechanically_proved": False,
        },
    }


def read_typed_function(value):
    def polynomial(data):
        return sum(
            s.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
            * s.prod(variable**power for variable, power in zip(VARIABLES, term["exponents"], strict=True))
            for term in data["terms"]
        )

    if value["variables"] != [str(variable) for variable in VARIABLES]:
        raise AssertionError("Unexpected Jacobian variable order")
    return polynomial(value["numerator"]) / polynomial(value["denominator"])


def jacobian_check(expected, expected_payload):
    path = ROOT / "jacobian" / "monodromy.output.json"
    receipt = ROOT / "jacobian" / "monodromy.receipt.json"
    if not path.exists():
        return {"status": "not_run", "is_mathematical_evidence": False}
    output = json.loads(path.read_text())
    exit_receipt = json.loads(receipt.read_text())
    if exit_receipt["exit_code"] != 0 or exit_receipt["timeout"]:
        raise AssertionError(f"Jacobian adapter failed: {exit_receipt}")
    if json.loads((ROOT / "jacobian" / "monodromy.payload.json").read_text()) != expected_payload:
        raise AssertionError("Preserved Jacobian payload does not match the monodromy being checked")
    result = output.get("result", {})
    if (
        output.get("error") is not None
        or result.get("error") is not None
        or result.get("operation_id") != "matrix.symbolic.multiply.compute"
        or "output" not in result
    ):
        raise AssertionError("Jacobian returned an error or an unexpected typed result")
    matrix_data = result["output"]
    actual = s.Matrix([[read_typed_function(entry) for entry in row] for row in matrix_data["entries"]])
    matrix_zero("jacobian_monodromy_replay", actual - expected)
    return {
        "status": "exact_output_replayed",
        "operation_id": "matrix.symbolic.multiply.compute",
        "payload": "research/jacobian/monodromy.payload.json",
        "output": "research/jacobian/monodromy.output.json",
        "receipt": "research/jacobian/monodromy.receipt.json",
        "server": output.get("server"),
        "protocol_version": output.get("protocol_version"),
        "exit_code": exit_receipt["exit_code"],
        "adapter_error": None,
        "timeout": False,
    }


def lean_record_check():
    record = json.loads((ROOT / "lean" / "latest-verification.json").read_text())
    source = ROOT / "lean" / "Main.lean"
    fidelity = ROOT / "lean" / "statement_fidelity.md"
    if record["exit_code"] != 0 or record["proof_holes"] or record["environment_failure"]:
        raise AssertionError("The included Lean source has no successful hole-free compiler record")
    for path, key in ((source, "source_sha256"), (fidelity, "statement_fidelity_sha256")):
        if hashlib.sha256(path.read_bytes()).hexdigest() != record[key]:
            raise AssertionError(f"Stale Lean compiler record: {path.name}")
    evidence = record["kernel"]["recorded"]
    if evidence["tier"] != "mechanical" or evidence["verdict"] != "supports":
        raise AssertionError("The Lean result was not attached as supporting mechanical evidence")
    if not (ROOT.parent / evidence["artifact"]).is_file():
        raise AssertionError("The attached Lean certificate is missing")
    return {
        "claim": "C_ALG_KERNEL",
        "source": "research/lean/Main.lean",
        "statement_fidelity": "research/lean/statement_fidelity.md",
        "compiler_certificate": evidence["artifact"],
        "compiler": evidence["produced_by"],
        "exit_code": record["exit_code"],
        "proof_holes": record["proof_holes"],
        "source_and_fidelity_match_compiler_record": True,
        "analytical_limit_mechanically_proved": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prepare-jacobian", action="store_true")
    parser.add_argument("--run-jacobian", action="store_true")
    args = parser.parse_args()
    payload, monodromy = monodromy_checks()
    if args.prepare_jacobian or args.run_jacobian:
        directory = ROOT / "jacobian"
        directory.mkdir(exist_ok=True)
        (directory / "monodromy.payload.json").write_text(json.dumps(payload, indent=2) + "\n")
        if args.run_jacobian:
            command = [
                "$WORKSPACE/argus-live-update/.venv/bin/python",
                "-m", "argus_skill.tools.jacobian", "run",
                "--operation", "matrix.symbolic.multiply.compute",
                "--payload-file", str(directory / "monodromy.payload.json"),
            ]
            try:
                with (directory / "monodromy.output.json").open("w") as out, (directory / "monodromy.stderr.txt").open("w") as err:
                    process = subprocess.run(command, stdout=out, stderr=err, timeout=90)
            except subprocess.TimeoutExpired:
                (directory / "monodromy.receipt.json").write_text(json.dumps({"command": command, "exit_code": None, "timeout": True}, indent=2) + "\n")
                raise
            (directory / "monodromy.receipt.json").write_text(json.dumps({"command": command, "exit_code": process.returncode, "timeout": False}, indent=2) + "\n")
    jet_checks()
    kernel_checks()
    finite = one_root_checks()
    fourier = fourier_checks()
    jacobian = jacobian_check(monodromy, payload)
    lean = lean_record_check()
    certificate = {
        "claim": "C_FIDELITY",
        "extension_claim": "C_NEGATIVE_FIDELITY",
        "result_class": "new_theorem",
        "classification_note": "Proposed negative-kernel range extension and independent analytical verification; novelty and significance await independent review.",
        "novelty_status": "unverified",
        "significance_status": "unreviewed",
        "not_a_refutation": True,
        "sympy_version": s.__version__,
        "arithmetic": "exact rational functions and algebraic numbers; no floating-point tolerance",
        "residual_count": len(RESIDUALS),
        "residuals": RESIDUALS,
        "finite_monodromy_probe": finite,
        "fourier": fourier,
        "jacobian": jacobian,
        "lean": lean,
        "analytical_proof": "research/AUDIT_REPORT.md",
        "limitations": [
            "This script checks the displayed exact algebraic residuals; it does not mechanically prove the ordered-limit estimates.",
            "The analytical proof and the external determinant attribution require independent Reviewer scrutiny.",
            "No conclusion about the complete balanced-plane GFF theorem is certified here.",
        ],
        "independent_review": "pending Host-invoked Reviewer",
    }
    (ROOT / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({"ok": True, "exact_residuals": len(RESIDUALS), "jacobian": jacobian["status"], "certificate": "research/exact_certificate.json"}))


if __name__ == "__main__":
    main()
