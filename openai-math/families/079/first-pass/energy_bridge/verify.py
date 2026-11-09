#!/usr/bin/env python3
"""Replay exact algebra and the current, source-bound Lean evidence."""

import argparse
import hashlib
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ZERO = (sp.S.Zero,) * 4
ONE = (sp.S.One, sp.S.Zero, sp.S.Zero, sp.S.Zero)
UNITS = (
    ONE,
    (sp.S.Zero, sp.S.One, sp.S.Zero, sp.S.Zero),
    (sp.S.Zero, sp.S.Zero, sp.S.One, sp.S.Zero),
    (sp.S.Zero, sp.S.Zero, sp.S.Zero, sp.S.One),
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def equal(actual, expected, label):
    residual = sp.factor(sp.expand(actual - expected))
    require(residual == 0, f"{label}: nonzero exact residual {residual}")


def qa(a, b):
    return tuple(x + y for x, y in zip(a, b))


def qs(c, a):
    return tuple(c * x for x in a)


def qc(a):
    return (a[0], -a[1], -a[2], -a[3])


def qm(a, b):
    a0, a1, a2, a3 = a
    b0, b1, b2, b3 = b
    return (
        a0 * b0 - a1 * b1 - a2 * b2 - a3 * b3,
        a0 * b1 + a1 * b0 + a2 * b3 - a3 * b2,
        a0 * b2 - a1 * b3 + a2 * b0 + a3 * b1,
        a0 * b3 + a1 * b2 - a2 * b1 + a3 * b0,
    )


def qsum(values):
    result = ZERO
    for value in values:
        result = qa(result, value)
    return result


def qequal(actual, expected, label):
    for component, (x, y) in enumerate(zip(actual, expected)):
        equal(x, y, f"{label}, quaternion component {component}")


def pairing_coefficients():
    a = sp.symbols("a0:4", real=True)
    for alpha in range(3):
        for beta in range(3):
            real_tensor = qm(qm(qc(UNITS[alpha]), a), UNITS[beta])[0]
            hessian_trace = qm(qm(a, UNITS[beta]), qc(UNITS[alpha]))[0]
            equal(real_tensor, hessian_trace, f"pairing {alpha},{beta}")
    return {
        "kind": "universal_quaternion_coefficient_identity",
        "three_slot_pairing_residuals": ["0"] * 9,
        "extension": "Summing the coefficient identity covers every index dimension.",
    }


def moore_schur():
    a, b, c = sp.symbols("a b c", real=True)
    q = sp.symbols("q0:4", real=True)
    r = sp.symbols("r0:4", real=True)
    s = sp.symbols("s0:4", real=True)
    norm_q = sum(x * x for x in q)
    norm_r = sum(x * x for x in r)
    norm_s = sum(x * x for x in s)
    determinant = (
        a * b * c - a * norm_s - b * norm_r - c * norm_q
        + 2 * qm(qm(q, s), qc(r))[0]
    )
    matrix = [[qs(a, ONE), q, r],
              [qc(q), qs(b, ONE), s],
              [qc(r), qc(s), qs(c, ONE)]]
    c01 = tuple(sp.diff(determinant, x) / 2 for x in q)
    c02 = tuple(sp.diff(determinant, x) / 2 for x in r)
    c12 = tuple(sp.diff(determinant, x) / 2 for x in s)
    cofactor = [
        [qs(sp.diff(determinant, a), ONE), c01, c02],
        [qc(c01), qs(sp.diff(determinant, b), ONE), c12],
        [qc(c02), qc(c12), qs(sp.diff(determinant, c), ONE)],
    ]
    for i in range(3):
        for j in range(3):
            product = qsum(qm(matrix[i][k], cofactor[k][j]) for k in range(3))
            target = qs(determinant, ONE) if i == j else ZERO
            qequal(product, target, f"Moore cofactor inverse polynomial {i},{j}")
    delta = b * c - norm_s
    adjugate_d = [[qs(c, ONE), qs(-1, s)],
                  [qs(-1, qc(s)), qs(b, ONE)]]
    row = [q, r]
    column = [qc(q), qc(r)]
    quadratic = qsum(
        qm(qm(row[i], adjugate_d[i][j]), column[j])
        for i in range(2) for j in range(2)
    )
    qequal(quadratic, qs(quadratic[0], ONE), "Schur correction is real")
    equal(determinant, a * delta - quadratic[0], "indefinite quaternionic Schur identity")
    control = sp.Matrix([[0, 1, 0], [1, 0, 0], [0, 0, 1]])
    equal(control.det(), -1, "full Hessian need not be singular")
    equal(control.minor_submatrix(0, 0).det(), 0, "normal cofactor still vanishes")
    return {
        "kind": "generic_three_by_three_quaternionic_polynomial_identities",
        "independent_real_matrix_parameters": 15,
        "adjugate_product_component_residuals": ["0"] * 36,
        "schur_residual": "0",
        "full_determinant_control": "-1",
        "normal_cofactor_control": "0",
        "scope": "Supplementary convention check, not an all-dimension proof.",
    }


def actual_current_interference():
    py, qy, pp, qp, kappa, slope = sp.symbols(
        "py qy pp qp kappa slope", real=True
    )
    y = sp.sqrt(py * py + qy * qy)
    w_re = (pp * py + qp * qy) / y**2
    w_im = (qp * py - pp * qy) / y**2
    log_weight = -sp.log(y) / 2 - kappa * y * ((w_re - slope)**2 + w_im**2) / 2
    point = {py: 1, qy: 0, pp: 0, qp: 0}
    aux = (py, qy, pp, qp)
    log_jets = tuple(sp.diff(log_weight, x).subs(point) for x in aux)
    expected_log = (-(1 + kappa * slope**2) / 2, 0, kappa * slope, 0)
    for x, expected in zip(log_jets, expected_log):
        equal(x, expected, "Gaussian logarithmic derivative")
    w_jets = tuple(
        (sp.diff(w_re, x).subs(point), sp.diff(w_im, x).subs(point)) for x in aux
    )
    e_jets = tuple(
        (sp.diff(py / y, x).subs(point), sp.diff(qy / y, x).subs(point)) for x in aux
    )
    chi = [ZERO for _ in range(3)]
    dchi = [[ZERO for _ in range(3)] for _ in range(9)]
    for index in (1, 2):
        kap, v, ar, bi, weight = sp.symbols(
            f"k{index} v{index} a{index} b{index} m{index}", real=True
        )
        amplitude = (ar, -bi, sp.S.Zero, sp.S.Zero)
        phase_derivative = qs(-1, qm(UNITS[1], amplitude))
        polarization = (ONE, qs(v / 2, ONE), ZERO)
        phase_covector = (-kap * v * v / 2, kap * v, kap)
        for mu in range(3):
            base = qm(polarization[mu], amplitude)
            chi[mu] = qa(chi[mu], qs(weight, base))
            for physical in range(3):
                contribution = qs(
                    weight * phase_covector[physical],
                    qm(polarization[mu], phase_derivative),
                )
                coordinate = 3 * physical
                dchi[coordinate][mu] = qa(dchi[coordinate][mu], contribution)
            for j, coordinate in enumerate((1, 2, 4, 5)):
                dw = (w_jets[j][0], 0, 0, w_jets[j][1])
                dv = (ZERO, qs(sp.Rational(1, 2), dw), qs(-v / 2, dw))[mu]
                de = (0, -bi * e_jets[j][0], -bi * e_jets[j][1], 0)
                log_jet = log_jets[j].subs({kappa: kap, slope: v})
                contribution = qs(weight, qsum((
                    qm(dv, amplitude),
                    qm(polarization[mu], de),
                    qs(log_jet, base),
                )))
                dchi[coordinate][mu] = qa(dchi[coordinate][mu], contribution)
    for nu in range(3):
        for beta in range(3):
            divergence = 0
            for mu in range(3):
                for alpha in range(3):
                    coordinate = 3 * mu + alpha
                    derivative_a = qa(
                        qm(dchi[coordinate][mu], qc(chi[nu])),
                        qm(chi[mu], qc(dchi[coordinate][nu])),
                    )
                    divergence += qm(
                        qm(qc(UNITS[alpha]), derivative_a), UNITS[beta]
                    )[0]
            equal(divergence, 0, f"actual two-mode current divergence {nu},{beta}")
    return {
        "kind": "exact_symbolic_first_jet_of_actual_current",
        "spatial_dimension": 2,
        "auxiliary_point": {"Y": "1", "P": "0"},
        "modes": 2,
        "parameters": "arbitrary k1,k2,v1,v2,a1,b1,a2,b2,m1,m2",
        "interference": "All cross-mode coefficients are retained.",
        "real_column_divergence_residuals": ["0"] * 9,
        "scope": "A universal parameter identity at one auxiliary point; the global proof is in theorem.md.",
    }


def radial_family():
    n = sp.Symbol("n", integer=True, positive=True)
    length = sp.Symbol("L", positive=True)
    energy = n * length**(n + 1) / (n + 1)**2
    laplacian = 4 * ((1 - length) * sp.diff(energy, length, 2)
                     - sp.diff(energy, length))
    flux = 4 * n * (1 - length) * length**(n - 1)
    defect = 4 * n * length**(n - 1) / (n + 1)
    residual = sp.simplify(laplacian - flux + defect)
    require(residual == 0, f"all-dimensional moving-ball identity: {residual}")
    samples = []
    for s_squared in (sp.S.Zero, sp.Rational(1, 4)):
        substitution = {n: 2, length: 1 - s_squared}
        values = {
            "n": 2,
            "s_squared": str(s_squared),
            "laplacian_over_ball_volume": str(sp.simplify(laplacian.subs(substitution))),
            "current_flux_over_ball_volume": str(sp.simplify(flux.subs(substitution))),
            "wall_defect_over_ball_volume": str(sp.simplify(defect.subs(substitution))),
        }
        samples.append(values)
    require(samples[0]["laplacian_over_ball_volume"] == "-8/3", "center sign")
    require(samples[1]["current_flux_over_ball_volume"] == "3/2", "full moving-normal flux")
    return {
        "kind": "symbolic_identity_for_every_positive_integer_n",
        "energy_over_ball_volume": "n*L**(n+1)/(n+1)**2",
        "current_flux_over_ball_volume": "4*n*(1-L)*L**(n-1)",
        "wall_defect_over_ball_volume": "4*n*L**(n-1)/(n+1)",
        "identity_residual": "0",
        "exact_specializations": samples,
        "is_manuscript_counterexample": False,
    }


def decode_rational_function(value):
    variables = [sp.Symbol(name) for name in value["variables"]]

    def polynomial(part):
        total = sp.S.Zero
        for term in part["terms"]:
            coefficient = term["coefficient"]
            monomial = sp.Rational(int(coefficient["num"]), int(coefficient["den"]))
            require(len(term["exponents"]) == len(variables), "typed exponent arity")
            for variable, exponent in zip(variables, term["exponents"]):
                monomial *= variable**exponent
            total += monomial
        return total

    require(value["domain"] == "QQ", "Jacobian output domain")
    return polynomial(value["numerator"]) / polynomial(value["denominator"])


def jacobian_replay():
    request = json.loads((HERE / "jacobian_request.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    operation = "matrix.symbolic.determinant.compute"
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not complete successfully")
    require(response["tool"] == "math.run", "not a Jacobian execution")
    require(response["request"]["operation_id"] == operation, "wrong requested operation")
    require(response["result"]["operation_id"] == operation, "wrong returned operation")
    require(response["request"]["payload"] == request, "payload differs from archived request")
    output = response["result"]["output"]
    require(output["method"] == "SYMPY_BAREISS", "wrong typed determinant method")
    matrix = sp.Matrix([
        [decode_rational_function(entry) for entry in row]
        for row in request["matrix"]["entries"]
    ])
    returned = decode_rational_function(output["determinant"])
    w1, w2 = sp.symbols("w1 w2")
    expected = 1 + (w1**2 + w2**2) / 2
    equal(returned, expected, "typed Jacobian determinant")
    equal(matrix.det(), expected, "independent determinant replay")
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "transport": response["transport"],
        "adapter_exit_code": status["adapter_exit_code"],
        "determinant": "1+w1**2/2+w2**2/2",
        "replay_residual": "0",
        "scope": "The dimension-uniform counterpart is proved in Main.lean.",
    }


def lean_replay():
    source = HERE / "lean/Main.lean"
    fidelity = HERE / "lean/statement_fidelity.md"
    result = json.loads((HERE / "lean/lean_check.json").read_text())
    require(result["status"] == "success", "Lean compiler did not succeed")
    require(result["exit_code"] == 0, "Lean compiler returned a nonzero exit code")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require(
        hashlib.sha256(source.read_bytes()).hexdigest() == result["source_sha256"],
        "Lean source changed after compilation",
    )
    require(
        hashlib.sha256(fidelity.read_text().encode()).hexdigest()
        == result["statement_fidelity_sha256"],
        "statement fidelity changed after compilation",
    )
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max(
        (item for item in state["claims"] if item["claim_id"] == "C_ENERGY_CORE"),
        key=lambda item: item["version"],
    )
    require(claim["formal_statement"].strip() == source.read_text().strip(),
            "current ledger formal statement does not match the compiled source")
    records = [
        item for item in state["evidence"]
        if item["subject"]["subject_id"] == "C_ENERGY_CORE"
        and item["subject"]["content_hash"] == claim["content_hash"]
        and item["tier"] == "mechanical" and item["verdict"] == "supports"
    ]
    require(len(records) == 1, "expected one current mechanically supporting Lean record")
    record = records[0]
    archive = json.loads((ROOT / record["artifact"]).read_text())
    require(archive["lean_check"] == result, "archived and current compiler results differ")
    require(archive["lean_source"]["text"] == source.read_text(), "archived Lean source differs")
    require(archive["statement_fidelity"]["text"] == fidelity.read_text(),
            "archived statement-fidelity text differs")
    require("4.31.0" in record["produced_by"], "unexpected Lean toolchain")
    return {
        "claim_id": "C_ENERGY_CORE",
        "compiler_exit_code": 0,
        "proof_holes": [],
        "produced_by": record["produced_by"],
        "archive": record["artifact"],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "all_finite_dimensions": True,
        "formalizes_the_analytic_PDE": False,
    }


def symbolic_checks():
    return {
        "pairing": pairing_coefficients(),
        "moore_schur": moore_schur(),
        "actual_current": actual_current_interference(),
        "moving_ball_family": radial_family(),
        "jacobian": jacobian_replay(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = {
        "schema_version": 1,
        "claim_id": "C_ENERGY_WALL",
        "result_class": "new_theorem",
        "mathematical_result": "Exact moving-wall defect formula and sharp common-null cancellation criterion.",
        "manuscript_conclusion": "October prop:energy-flux follows; no manuscript counterexample is asserted.",
        "proof": "theorem.md",
        "exact_algebra": symbolic_checks(),
        "formal_core": lean_replay(),
        "independent_review": "Required; no Reviewer verdict is manufactured by this verifier.",
        "outside_mechanical_scope": [
            "Independent citation attribution of MA_ZHU_PERIODIC",
            "Independent statement-fidelity and analytic proof review",
            "Bibliographic novelty and publishable significance",
            "October scale-uniform estimates and both manuscripts' local-smoothing conclusions",
        ],
    }
    destination = HERE / "exact_certificate.json"
    if args.write_certificate:
        destination.write_text(json.dumps(certificate, indent=2, ensure_ascii=True) + "\n")
    else:
        require(json.loads(destination.read_text()) == certificate,
                "saved exact certificate does not match the current replay")
    print(json.dumps({
        "status": "verified",
        "claim_id": certificate["claim_id"],
        "formal_core_exit_code": 0,
        "proof_holes": [],
        "manuscript_refuted": False,
        "certificate": str(destination.relative_to(ROOT)),
    }, indent=2))


if __name__ == "__main__":
    main()
