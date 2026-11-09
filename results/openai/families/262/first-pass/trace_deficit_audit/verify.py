#!/usr/bin/env python3
"""Replay exact certificates; analytic proofs remain in report.md."""

from __future__ import annotations

import argparse
import copy
import hashlib
import json
import re
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
Polynomial = dict[tuple[str, ...], sp.Expr]


class CertificateError(ValueError):
    pass


def require(condition: bool, message: str) -> None:
    if not condition:
        raise CertificateError(message)


def rational(text: str) -> sp.Rational:
    require(isinstance(text, str), "rational must be an exact string")
    require(bool(re.fullmatch(r"-?\d+(?:/[1-9]\d*)?", text)), "invalid rational")
    value = Fraction(text)
    require(str(value) == text, "rational must be reduced and canonical")
    return sp.Rational(value.numerator, value.denominator)


def clean(poly: Polynomial) -> Polynomial:
    return {word: value for word, c in poly.items() if (value := sp.cancel(c)) != 0}


def scalar(value: sp.Expr | int) -> Polynomial:
    return clean({(): sp.sympify(value)})


def symbol(name: str) -> Polynomial:
    return {(name,): sp.Integer(1)}


def add(*polys: Polynomial) -> Polynomial:
    result: Polynomial = {}
    for poly in polys:
        for word, value in poly.items():
            result[word] = result.get(word, sp.Integer(0)) + value
    return clean(result)


def scale(value: sp.Expr | int, poly: Polynomial) -> Polynomial:
    return clean({word: value * c for word, c in poly.items()})


def mul(*polys: Polynomial) -> Polynomial:
    result = scalar(1)
    for poly in polys:
        product: Polynomial = {}
        for left, a in result.items():
            for right, b in poly.items():
                word = left + right
                product[word] = product.get(word, sp.Integer(0)) + a * b
        result = clean(product)
    return result


def star(poly: Polynomial) -> Polynomial:
    return clean({word[::-1]: sp.conjugate(c) for word, c in poly.items()})


def reduce_word(word: tuple[str, ...], inverses: set[tuple[str, str]]) -> tuple[str, ...]:
    result: list[str] = []
    for letter in word:
        if result and (result[-1], letter) in inverses:
            result.pop()
        else:
            result.append(letter)
    return tuple(result)


def trace_word(word: tuple[str, ...], inverses: set[tuple[str, str]]) -> tuple[str, ...]:
    word = reduce_word(word, inverses)
    while len(word) > 1 and (word[-1], word[0]) in inverses:
        word = word[1:-1]
    return min(word[i:] + word[:i] for i in range(len(word))) if word else ()


def trace_normal_form(poly: Polynomial, inverses: set[tuple[str, str]]) -> Polynomial:
    result: Polynomial = {}
    for word, value in poly.items():
        key = trace_word(word, inverses)
        result[key] = result.get(key, sp.Integer(0)) + value
    return clean(result)


def zero(poly: Polynomial, label: str, inverses: set[tuple[str, str]] | None = None) -> None:
    result = clean(poly) if inverses is None else trace_normal_form(poly, inverses)
    require(not result, f"{label}: nonzero exact word residual {result}")


def matrix_zero(matrix: sp.Matrix, label: str) -> None:
    require(all(sp.cancel(x) == 0 for x in matrix), f"{label}: nonzero matrix")


def exact_matrix(data: list[list[str]], size: int) -> sp.Matrix:
    require(len(data) == size and all(len(row) == size for row in data), "wrong matrix size")
    return sp.Matrix([[rational(x) for x in row] for row in data])


def check_universal_algebra(cert: dict) -> list[str]:
    B, S, L, Z, W, R, U, A, H = [symbol(x) for x in "BSLZWRUAH"]
    s, h = sp.symbols("s h", real=True, nonzero=True)
    comm = lambda X, Y: add(mul(X, Y), scale(-1, mul(Y, X)))
    square = lambda X: mul(X, X)
    k = add(scalar(s), scale(-1, B))
    zero(add(mul(add(k, scale(sp.I, S)), add(k, scale(-sp.I, S))),
             scale(-1, add(square(k), square(S), scale(sp.I, comm(B, S))))),
         "ordered spectral factorization")

    plus = add(W, scale(-1, square(add(L, Z))), scale(-sp.I, comm(B, add(L, Z))))
    minus = add(W, scale(-1, square(add(L, scale(-1, Z)))),
                scale(sp.I, comm(B, add(L, scale(-1, Z)))))
    riccati = add(W, scale(-1, square(L)), scale(-1, square(Z)),
                  scale(-sp.I, comm(B, Z)))
    sylvester = add(mul(L, Z), mul(Z, L), scale(sp.I, comm(B, L)))
    averaging = cert["riccati_averaging"]
    for name, target in [("mean_coefficients", riccati),
                         ("sylvester_coefficients", sylvester)]:
        weights = averaging[name]
        require(len(weights) == 2, "Riccati averaging needs two coefficients")
        zero(add(target, scale(-rational(weights[0]), plus),
                 scale(-rational(weights[1]), minus)), name)

    require(cert["inverse_relations"] == [["R", "L"], ["L", "R"]],
            "both actual inverse hypotheses are required")
    relations = {"riccati": riccati, "sylvester": sylvester}
    symbols = dict(zip("BSLZWRUAH", [B, S, L, Z, W, R, U, A, H]))

    def word_product(word: list[str]) -> Polynomial:
        require(all(x in symbols for x in word), "unknown word symbol")
        return mul(*(symbols[x] for x in word))

    witness = scalar(0)
    for term in cert["trace_relation_witness"]:
        require(term["relation"] in relations, "unknown matrix relation")
        witness = add(witness, scale(rational(term["coefficient"]),
                      mul(word_product(term["left"]), relations[term["relation"]],
                          word_product(term["right"]))))
    target = add(mul(R, W), scale(-1, L), mul(R, Z, Z))
    zero(add(target, scale(-1, witness)), "inverse/Riccati trace contraction",
         {("R", "L"), ("L", "R")})

    require(cert["ordered_square_right_factor"] == ["A", "H"],
            "the manuscript square is U-AH, not a commuted matrix expression")
    difference = add(U, scale(-1, mul(A, H)))
    gram = mul(star(difference), difference)
    square_target = add(mul(U, U), mul(A, A, H, H), scale(-2, H))
    zero(add(gram, scale(-1, square_target)), "ordered adjoint square trace",
         {("U", "A"), ("A", "U")})
    zero(add(mul(A, A, Z, Z), scale(-1, mul(star(mul(A, Z)), mul(A, Z)))),
         "Gram trace correction", set())

    V = symbol("V")
    P = add(scalar(1 / h), scale(-1, R))
    F = add(scale(1 / h, V), scale(-2, L), scalar(2 * h))
    G = add(L, scalar(-2 * h), scale(h**2, R))
    fg = add(mul(P, V), scale(-1, F), scale(-1, G), scale(-1, mul(R, Z, Z)))
    contraction = add(mul(R, add(V, scalar(h**2))), scale(-1, L), mul(R, Z, Z))
    zero(add(fg, contraction), "F+G identity", set())
    D = add(square(H), scalar(-h**2))
    F0 = add(scale(1 / h, D), scale(-2, H), scalar(2 * h))
    zero(add(G, scale(-1, mul(P, D)), F0,
             scale(-1, add(L, mul(R, H, H), scale(-2, H)))),
         "square/duality decomposition", set())
    sigma = sp.Symbol("sigma", positive=True)
    p, r, q = 1 + sigma, 1 / sigma, 1 + 1 / sigma
    require(sp.cancel(r * p - q) == 0 and sp.cancel(q * (1 - 1 / p) - 1) == 0,
            "incorrect exact exponent coefficients")
    return ["ordered factorization", "Riccati mean", "Riccati Sylvester relation",
            "inverse/Riccati trace sign", "ordered adjoint-square trace",
            "Gram correction", "F+G decomposition", "square/duality decomposition",
            "exponent coefficients"]


def check_gapped_specimen(cert: dict) -> dict:
    data = cert["gapped_specimen"]
    J, B, V = [exact_matrix(data[x], 2) for x in ["J", "B", "V"]]
    I = sp.eye(2)
    gap, sigma, M, tau, lower = [
        rational(data[x]) for x in
        ["gap", "sigma", "resolvent_bound", "split_t", "N_over_c_lower"]
    ]
    require(gap > 0 and 0 < sigma <= sp.Rational(1, 2), "invalid gap or exponent")
    matrix_zero(B - B.T, "B Hermitian")
    matrix_zero(V - V.T, "V Hermitian")
    matrix_zero(B - (J + J.T) / 2, "B from Jordan factor")
    matrix_zero(V - (J.T * J - B * B + gap * I), "exact uniform-gap Gram factor")
    matrix_zero(J * J, "nilpotent Jordan factor")
    matrix_zero(J.T * J - sp.diag(0, 1), "Jordan norm bound")
    matrix_zero(B * B - I / 4, "B operator norm")
    require(V[0, 1] == V[1, 0] == 0, "diagonal inertia certificate required")
    require(V[0, 0] < 0 < V[1, 1], "the perturbation is not indefinite")
    require(B * V != V * B, "the specimen must be noncommuting")
    require(all(abs(V[j, j]) <= 1 for j in range(2)), "tail perturbation bound fails")
    s = sp.Symbol("s", real=True)
    matrix_zero((s * I - B)**2 + V - ((s * I - J).T * (s * I - J) + gap * I),
                "uniform symbol positivity for every real s")
    k = data["split_power_of_two"]
    require(isinstance(k, int) and 1 <= k <= 64, "invalid split exponent")
    require(tau == sp.Rational(1, 2**k) and tau == 1 / (4 * M**2),
            "split does not give t^(-1/2)>=2M")
    require(M >= 4 / gap + 4, "unproved R(0) bound")
    require(k * sigma <= 1, "tau^sigma>=1/2 bound fails")
    require(lower == 1 / (4 * sigma) - 2 * M - 4 and lower > 0,
            "the claimed positive N lower bound is not justified")
    return {"gap": str(gap), "sigma": str(sigma), "N_over_c_lower": str(lower),
            "N_positivity_basis": "exact rational bounds plus report section 13"}


def check_gapless_specimens(cert: dict) -> list[dict]:
    s = sp.Symbol("s", real=True, nonzero=True)
    results = []
    for data in cert["gapless_jordan_specimens"]:
        n = data["dimension"]
        require(isinstance(n, int) and 2 <= n <= 8, "invalid bounded specimen dimension")
        J = sp.zeros(n)
        for j in range(n - 1):
            J[j, j + 1] = 1
        I = sp.eye(n)
        B = (J + J.T) / 2
        V = J.T * J - B * B
        X = (s * I - J).T * (s * I - J)
        matrix_zero(X - ((s * I - B)**2 + V), "gapless Hermitian symbol")
        require(sp.expand(X.det()) == s**(2 * n), "wrong determinant vanishing order")
        inverse_factor = sp.zeros(n)
        for j in range(n):
            inverse_factor += J**j / s**(j + 1)
        matrix_zero((s * I - J) * inverse_factor - I, "exact finite geometric inverse")
        inverse = inverse_factor * inverse_factor.T
        matrix_zero(X * inverse - I, "exact inverse symbol")
        leading = J**(n - 1) * (J.T)**(n - 1)
        expected = sp.zeros(n)
        expected[0, 0] = 1
        matrix_zero(leading - expected, "nonzero maximal-pole coefficient")
        require(data["pole_order"] == 2 * n, "incorrect inverse pole order")
        threshold = sp.Rational(n - 1, 2 * n)
        require(rational(data["threshold"]) == threshold, "incorrect convergence threshold")
        require(threshold < rational(data["convergent_sigma"]) < 1,
                "claimed convergent exponent fails the theorem hypothesis")
        require(0 < rational(data["divergent_sigma"]) <= threshold,
                "claimed divergent exponent is outside the divergence range")
        coefficient = data["leading_resolvent_coefficient"]
        radicand = coefficient["sqrt_integer"]
        require(isinstance(radicand, int) and 1 <= radicand <= 64,
                "invalid exact leading coefficient")
        leading_constant = rational(coefficient["rational"]) * sp.sqrt(radicand)
        require(sp.simplify(sp.csc(sp.pi / (2 * n)) / n - leading_constant) == 0,
                "wrong leading resolvent asymptotic coefficient")
        results.append({"dimension": n, "exact_pole_order": 2 * n,
                        "threshold": str(threshold),
                        "leading_resolvent_coefficient": str(leading_constant)})
    require(len(results) == 2 and [x["dimension"] for x in results] == [2, 3],
            "the certificate must retain both declared exact boundary specimens")
    return results


def check_half_exponent(cert: dict) -> dict:
    data = cert["exact_half_exponent"]
    require(rational(data["sigma"]) == rational(data["c_sigma"]) == sp.Rational(1, 2),
            "incorrect half-exponent normalization")
    z = sp.Symbol("z", positive=True)
    normal_primitive = 2 * (sp.sqrt(z) - sp.sqrt(z + 1))
    require(sp.simplify(sp.diff(normal_primitive, z)
                       - (1 / sp.sqrt(z) - 1 / sp.sqrt(z + 1))) == 0,
            "normalization primitive failed")
    require(sp.limit(normal_primitive, z, sp.oo)
            - sp.limit(normal_primitive, z, 0, dir="+") == 2,
            "incorrect exact normalization integral")
    x, c, alpha = sp.symbols("x c alpha", positive=True)
    denominator = x**4 + alpha * x**2 + c**2
    change = x - c / x
    require(sp.cancel((x**2 + c) / denominator
                      - sp.diff(change, x) / (change**2 + alpha + 2 * c)) == 0,
            "quartic integral centering substitution failed")
    require(sp.cancel(((x**2 / denominator).subs(x, c / z)) * c / z**2
                      - c / (z**4 + alpha * z**2 + c**2)) == 0,
            "quartic inverse substitution failed")
    u = sp.Symbol("u", positive=True)
    a, b = (u - 1 / u) / 2, (u + 1 / u) / 2
    t, K = a**2, sp.sqrt(u**2 - 1)
    require(sp.cancel(b**2 - t - 1) == 0, "wrong t,u change of variable")
    require(sp.simplify(K**2 - 2 * t - 2 * a * b) == 0,
            "quartic integral denominator does not give the asserted R")
    R11, R22 = (1 + b / a) / K, (1 + a / b) / K
    require(sp.simplify((R11 + R22) * sp.diff(t, u) - 2 * sp.diff(K, u)) == 0,
            "trace primitive differentiation failed")
    integrand = 2 / (u * sp.sqrt(u**2 - 1))
    require(sp.simplify((R11 - R22) * sp.diff(t, u) - integrand) == 0,
            "difference change of variable failed")
    primitive = 2 * sp.atan(sp.sqrt(u**2 - 1))
    require(sp.simplify(sp.diff(primitive, u) - integrand) == 0,
            "difference antiderivative failed")
    require(sp.limit(primitive, u, 1, dir="+") == 0
            and sp.limit(primitive, u, sp.oo) == sp.pi, "wrong antiderivative endpoints")
    require(sp.limit(2 * a - K, u, sp.oo) == 0
            and sp.limit(K, u, 1, dir="+") == 0, "wrong trace primitive endpoints")
    require(sp.limit(t**sp.Rational(3, 4) * R11, u, 1, dir="+") == sp.sqrt(2) / 2
            and sp.limit(t**sp.Rational(3, 4) * R22, u, 1, dir="+") == 0,
            "exact quartic resolvent disagrees with the general matrix asymptotic")
    N = sp.diag(*(rational(x) * sp.pi for x in data["N_diagonal_pi_coefficients"]))
    require(N == sp.diag(-sp.pi / 4, sp.pi / 4), "incorrect exact N")
    V = sp.diag(-sp.Rational(1, 4), sp.Rational(3, 4))
    deficit = sp.trace(N * V) - (sp.pi / 4)**3
    claimed = rational(data["deficit_pi_linear_coefficient"]) * sp.pi \
        + rational(data["deficit_pi_cubic_coefficient"]) * sp.pi**3
    require(sp.expand(deficit - claimed) == 0, "incorrect exact extended deficit")

    alternating = sum((-1)**j * x**(2 * j) for j in range(8))
    require(sp.cancel(1 / (1 + x**2) - alternating - x**16 / (1 + x**2)) == 0,
            "pi lower-bound remainder failed")
    require(4 * sum(sp.Rational((-1)**j, 2 * j + 1) for j in range(8)) > 3,
            "exact rational pi lower bound is not strong enough")
    negative = cert["gapped_negative_N"]
    delta = rational(negative["gap"])
    require(delta > 0 and rational(negative["sigma"]) == sp.Rational(1, 2),
            "invalid uniformly gapped negative-N specimen")
    J = sp.Matrix([[0, 1], [0, 0]])
    B = (J + J.T) / 2
    Vdelta = exact_matrix(negative["V"], 2)
    matrix_zero(Vdelta - (J.T * J - B**2 + delta * sp.eye(2)),
                "negative-N specimen uniform Gram gap")
    u0 = sp.sqrt(delta) + sp.sqrt(delta + 1)
    K0 = sp.simplify(sp.sqrt(u0**2 - 1))
    trace_N = rational(negative["trace_N_sqrt3_coefficient"]) * sp.sqrt(3)
    difference_N = rational(negative["difference_N_pi_coefficient"]) * sp.pi
    require(sp.simplify(K0 - trace_N) == 0
            and sp.simplify(-sp.pi / 2 + sp.atan(K0) - difference_N) == 0,
            "wrong exact uniformly gapped N")
    require(sp.limit(2 * sp.sqrt(t - delta) - K, u, sp.oo) == 0,
            "shifted trace endpoint failed")
    require(sp.simplify(t.subs(u, u0) - delta) == 0,
            "wrong lower endpoint in the shifted resolvent calculation")
    require(difference_N == -sp.pi / 3 and 0 < trace_N < 1,
            "pi>3 does not certify the claimed negative N eigenvalue")

    A, U = sp.diag(1, 2), sp.diag(1, sp.Rational(1, 2))
    R, L, H = A**2, U**2, sp.Matrix([[2, 1], [1, 2]])
    actual = (U - A * H).T * (U - A * H)
    matrix_zero(actual - (L + H * R * H - 2 * H), "ordered matrix square specimen")
    require(actual != L + R * H**2 - 2 * H,
            "noncommuting order guard failed to distinguish matrices from traces")
    require(sp.trace(actual) == sp.trace(L + R * H**2 - 2 * H),
            "the valid trace equality failed")
    return {"N": ["-pi/4", "pi/4"], "deficit": "pi*(16-pi^2)/64",
            "interpretation": "gapless extension, not a manuscript counterexample",
            "uniform_gap_does_not_imply_N_nonnegative": True}


def check_jacobian(cert: dict) -> dict:
    data = cert["jacobian"]
    require(data["adapter_exit_code"] == 0 and data["transport_status"] == "success"
            and data["timeout"] is False and data["error"] is None,
            "Jacobian failure, timeout or incompleteness is not evidence")
    require(data["operation_id"] == "matrix.inertia.compute", "wrong inspected operation")
    for key, name in [("payload", "jacobian_inertia_payload.json"),
                      ("output", "jacobian_inertia_output.json"),
                      ("contract", "jacobian_inertia_contract.json")]:
        require(data[key] == name, "wrong Jacobian evidence path")
    payload = json.loads((HERE / data["payload"]).read_text())
    output = json.loads((HERE / data["output"]).read_text())
    contract = json.loads((HERE / data["contract"]).read_text())
    require(output["request"]["payload"] == payload, "Jacobian payload/output mismatch")
    require(output["request"]["operation_id"] == data["operation_id"]
            and output["result"]["operation_id"] == data["operation_id"]
            and contract["result"]["operation"]["operation_id"] == data["operation_id"],
            "Jacobian operation mismatch")
    require(output["server"]["version"] == contract["server"]["version"] == "0.14.0"
            and output["protocol_version"] == contract["protocol_version"] == "2025-11-25",
            "unexpected Jacobian server or protocol")
    result = output["result"]["output"]
    dense = sp.Matrix([[sp.Rational(int(x["num"]), int(x["den"])) for x in row]
                       for row in result["matrix"]["entries"]])
    require(dense == exact_matrix(cert["gapped_specimen"]["V"], 2),
            "Jacobian retained source is not the certified perturbation")
    require((result["n_positive"], result["n_negative"], result["n_zero"]) == (1, 1, 0)
            and result["definiteness"] == "indefinite", "wrong exact inertia")
    return {"operation": data["operation_id"], "inertia": [1, 1, 0],
            "adapter_exit_code": 0}


def check_lean_record(cert: dict) -> dict:
    data = cert["lean"]
    require(data["source"] == "lean/Main.lean"
            and data["statement_fidelity"] == "lean/statement_fidelity.md"
            and data["result"] == "lean/lean_check.json", "wrong formal source paths")
    source = (HERE / data["source"]).read_bytes()
    fidelity = (HERE / data["statement_fidelity"]).read_text().encode()
    result = json.loads((HERE / data["result"]).read_text())
    archive_path = HERE / data["certificate"]
    require(archive_path.parent == HERE / "lean/certificates", "wrong archive directory")
    archive = json.loads(archive_path.read_text())
    require(result["status"] == "success" and result["exit_code"] == 0
            and result["proof_holes"] == [] and result["audit_exit_code"] == 0
            and result["environment_failure"] == "", "Lean run did not certify the source")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "wrong Lean version")
    for key, contents in [("source_sha256", source), ("statement_fidelity_sha256", fidelity)]:
        digest = hashlib.sha256(contents).hexdigest()
        require(result[key] == archive["lean_check"][key] == digest,
                f"stale compiler record: {key}")
    require(archive["verdict"] == "supports" and archive["tier"] == "mechanical",
            "archive is not mechanical supporting evidence")
    require(archive["lean_source"]["text"].encode() == source
            and archive["statement_fidelity"]["text"].encode() == fidelity,
            "archive no longer matches the formal source and its reading")
    require(cert["formal_claim"] == archive["subject"]["subject_id"] == "C_TD_ALGEBRA",
            "compiler certificate concerns another claim")
    return {"version": "4.31.0", "exit_code": 0, "proof_holes": [],
            "scope": "finite matrix algebra only; recorded compiler run, not a new compile"}


def verify(cert: dict, evidence: bool = True) -> dict:
    require(cert["schema"] == "trace-deficit-exact-v1", "unknown certificate schema")
    require(cert["result_type"] == "independent_verification_and_gapless_extension",
            "incorrect result classification")
    require(cert["analytic_proof"] == "report.md" and len(cert["analytic_obligations"]) == 6,
            "analytic proof boundaries must remain explicit")
    result = {
        "universal_exact_checks": check_universal_algebra(cert),
        "gapped_indefinite_specimen": check_gapped_specimen(cert),
        "gapless_exact_specimens": check_gapless_specimens(cert),
        "half_exponent_exact_value": check_half_exponent(cert),
    }
    if evidence:
        result["jacobian"] = check_jacobian(cert)
        result["lean_record_consistency"] = check_lean_record(cert)
    result["analytic_status"] = "Proof in report.md; not machine checked; independent review required."
    return result


def self_test(cert: dict) -> int:
    changes = [
        lambda x: x["gapped_specimen"].update(gap="-1/16"),
        lambda x: x["gapped_specimen"].update(sigma="0"),
        lambda x: x["gapped_specimen"]["V"][0].__setitem__(0, "1/16"),
        lambda x: x["gapped_specimen"].update(N_over_c_lower="253"),
        lambda x: x["trace_relation_witness"][1].update(coefficient="-1"),
        lambda x: x.update(ordered_square_right_factor=["H", "A"]),
        lambda x: x["gapless_jordan_specimens"][0].update(pole_order=2),
        lambda x: x["gapless_jordan_specimens"][0].update(convergent_sigma="1/4"),
        lambda x: x["gapless_jordan_specimens"][0]["leading_resolvent_coefficient"].update(rational="1"),
        lambda x: x["gapped_negative_N"].update(difference_N_pi_coefficient="1/3"),
    ]
    for change in changes:
        altered = copy.deepcopy(cert)
        change(altered)
        try:
            verify(altered, evidence=False)
        except CertificateError:
            continue
        raise CertificateError("an invalid hypothesis or altered exact conclusion was accepted")
    return len(changes)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("certificate", nargs="?", type=Path, default=HERE / "exact_certificate.json")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    cert = json.loads(args.certificate.read_text())
    result = verify(cert)
    if args.self_test:
        result["invalid_certificates_rejected"] = self_test(cert)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
