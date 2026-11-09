#!/usr/bin/env python3
"""Replay exact algebra behind theorem.md; no sampled asymptotic tests."""

import hashlib
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def zero(expression, label):
    require(sp.simplify(expression) == 0, label)


def algebra_product(left, right, k):
    a, b = left
    c, e = right
    return sp.simplify(a * c), sp.simplify(a * e + b * c + k * b * e)


def main():
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    k = sp.Symbol("k", positive=True, integer=True)
    t = sp.Symbol("t", positive=True)
    x, total, defect = sp.symbols("x total defect", real=True)

    next_defect = (defect + 1 - total) * (1 - x) - 1 + total + x
    zero(next_defect - ((1 - x) * defect + x * total),
         "Universal product-complement induction identity")
    r = sp.Symbol("r", integer=True, nonnegative=True)
    zero((r + 1) * (r + 2) / 2 - r * (r + 1) / 2 - (r + 1),
         "Universal donor-collision arithmetic sum")

    center = (sp.Integer(1), -1 / k)
    square = algebra_product(center, center, k)
    zero(square[0] - center[0], "Centering projector I coefficient")
    zero(square[1] - center[1], "Centering projector J coefficient")
    zero(center[0] + k * center[1], "Centering matrix kills constants")
    zero(k * square[0] + k * square[1] - (k - 1),
         "Centering projector squared Frobenius norm")

    p, q, y, z = sp.symbols("p q y z", positive=True)
    c = sp.Matrix(2, 2, sp.symbols("c0:4"))
    e = sp.Matrix(2, 2, sp.symbols("e0:4"))
    rp, ry = sp.diag(p, q), sp.diag(y, z)
    word = (sp.kronecker_product(rp, ry.inv())
            * sp.kronecker_product(c, e)
            * sp.kronecker_product(rp.inv(), ry))
    u = sp.kronecker_product(sp.eye(2), ry * e.adjoint() * ry.inv())
    v = sp.kronecker_product(rp * c * rp.inv(), sp.eye(2))
    require((word - u.adjoint() * v).applyfunc(sp.simplify) == sp.zeros(4),
            "Inverse-innermost orientation, for arbitrary complex matrix entries")

    rho = sp.Matrix(2, 2, sp.symbols("rho0:4"))
    swap = sp.Matrix([[1, 0, 0, 0], [0, 0, 1, 0],
                      [0, 1, 0, 0], [0, 0, 0, 1]])
    product = sp.kronecker_product(rho, sp.eye(2)) * swap
    contraction = sp.Matrix(2, 2, lambda i, j: sum(
        product[2 * donor + i, 2 * donor + j] for donor in range(2)))
    require(contraction == rho, "Partial-swap contraction is rho, not rho transpose")

    def weight(parts):
        d = len(parts)
        c0 = d + (1 + t) * sp.binomial(d, 2)
        return (sp.gamma(c0) / sp.gamma(c0 + t * k)
                * sp.prod(sp.gamma(1 + t * (part + d - i - 1))
                          / sp.gamma(1 + t * (d - i - 1))
                          for i, part in enumerate(parts)))

    ratio = sp.cancel(weight([k] + [0] * 7) / weight([k - 1, 1] + [0] * 6))
    expected_ratio = (sp.gamma(1 + t * (k + 7))
                      / sp.gamma(1 + t * (k + 6))
                      * sp.gamma(1 + 6 * t) / sp.gamma(1 + 7 * t))
    zero(ratio / expected_ratio - 1, "Exact eight-dimensional Schur-weight ratio")

    gamma_constant = sp.simplify((sp.gamma(4) / sp.gamma(sp.Rational(9, 2))) ** 2)
    endpoint = sp.simplify(gamma_constant / 2)
    require(endpoint == 512 / (1225 * sp.pi), "Exact endpoint constant")
    base = (k + 8) / 2
    lower = sp.cancel(base ** 2 / (k * (base + sp.Rational(1, 2))))
    upper = sp.cancel(base / k)
    zero(lower - sp.Rational(1, 2) - (7 * k + 64) / (2 * k * (k + 9)),
         "Strict positive lower bound at every k>=2")
    require(sp.limit(lower, k, sp.oo) == sp.Rational(1, 2),
            "Endpoint lower rational bound has the claimed limit")
    require(sp.limit(upper, k, sp.oo) == sp.Rational(1, 2),
            "Endpoint upper rational bound has the claimed limit")

    a = sp.Symbol("a", real=True)
    nilpotent = sp.Matrix([[0, 0], [a, 0]])
    commutator = nilpotent * nilpotent.T - nilpotent.T * nilpotent
    require(nilpotent ** 2 == sp.zeros(2), "Universal nilpotence")
    require(commutator == sp.diag(-a ** 2, a ** 2),
            "Universal self-commutator")
    zero((sp.Rational(1, 2) - t) / 3
         - (sp.Rational(1, 2) - (1 + t) / 3),
         "Cutoff and Bernstein inverse errors balance")
    require(sp.solve(sp.Eq(t / 2, (1 - 2 * t) / 6), t) == [sp.Rational(1, 5)],
            "Logarithmic-rate transition")
    zero(4 * sp.Symbol("L", positive=True) * sp.log(2 * sp.Symbol("d", positive=True))
         / (8 * sp.Symbol("L", positive=True)
            * sp.log(2 * sp.Symbol("d", positive=True))) - sp.Rational(1, 2),
         "Growing-degree coefficient budget")

    adapter = json.loads((ROOT / "jacobian_output.json").read_text())
    require(adapter["server"]["version"] == certificate["jacobian"]["server_version"],
            "Preserved Jacobian server version")
    require(adapter["protocol_version"] == certificate["jacobian"]["protocol_version"],
            "Preserved Jacobian protocol version")
    contract = json.loads((ROOT / "jacobian_contract.json").read_text())
    require(contract["result"]["operation"]["operation_id"]
            == certificate["jacobian"]["operation_id"], "Inspected operation id")
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    require(adapter["request"]["operation_id"]
            == certificate["jacobian"]["operation_id"], "Executed operation id")
    require(adapter["request"]["payload"] == payload, "Exact executed payload")
    result = adapter["result"]["output"]
    require(result["outcome"] == "VALID"
            and result["valid_complete_rational_spectrum"] is True,
            "Jacobian exact normalized-commutator spectrum")
    require(result["matrix"]["entries"] == payload["matrix"]["entries"]
            and result["claimed_profile"] == payload["claimed_profile"],
            "Typed result retains the exact requested matrix")
    normalized_entries = [[sp.Rational(entry["num"], entry["den"]) for entry in row]
                          for row in result["matrix"]["entries"]]
    require(sp.Matrix(normalized_entries) == commutator.subs(a, 1),
            "The Jacobian input is the derived normalized commutator")

    require(certificate["endpoint"]["limiting_alpha"] == "512/(1225*pi)",
            "Certificate endpoint")
    zero(sp.sympify(certificate["endpoint"]["alpha_k"],
                    locals={"Gamma": sp.gamma, "k": k, "t": t})
         - expected_ratio ** 2 / k, "Certificate's complete symbolic alpha formula")
    require(certificate["uniform_theorem"]["t_interval"] == "0<t<1/2",
            "Certificate theorem range")
    require(certificate["manuscript_refuted"] is False,
            "Endpoint is outside manuscript hypotheses")
    require(certificate["analytic_theorem_kernel_formalized"] is False,
            "Do not overstate the formal scope")
    lean = json.loads((ROOT / "lean_check.json").read_text())
    require(lean["status"] == "success" and lean["exit_code"] == 0
            and lean["audit_exit_code"] == 0 and lean["proof_holes"] == [],
            "Real successful compiler and axiom-audit results are required")
    require("version 4.31.0," in lean["tools"]["lean"]["version"],
            "Required Lean toolchain")
    require(lean["source_sha256"]
            == hashlib.sha256((ROOT / "Main.lean").read_bytes()).hexdigest(),
            "Current formal source is exactly the compiled source")
    require(lean["statement_fidelity_sha256"] == hashlib.sha256(
        (ROOT / "statement_fidelity.md").read_text(encoding="utf-8").encode("utf-8")
    ).hexdigest(), "Current statement reading is exactly the compiler-bound reading")
    archived = json.loads(
        (ROOT.parent.parent / certificate["formal_evidence"]["certificate"]).read_text()
    )
    require(archived["lean_check"] == lean
            and archived["subject"]["subject_id"] == "C_SYMBOL_FORMAL_CORE"
            and archived["verdict"] == "supports"
            and archived["tier"] == "mechanical",
            "Certificate cites the archived real compiler evidence")
    require(archived["lean_source"]["text"] == (ROOT / "Main.lean").read_text()
            and archived["statement_fidelity"]["text"]
            == (ROOT / "statement_fidelity.md").read_text(),
            "Archived source and reading agree with the current files")
    require(certificate["formal_evidence"]["exit_code"] == lean["exit_code"]
            and certificate["formal_evidence"]["proof_holes"] == lean["proof_holes"],
            "Exact certificate reports the actual formal result")
    print(json.dumps({
        "ok": True,
        "result": "exact symbolic identities and universal induction cores verified",
        "replica_parameter": "symbolic k; not a bounded replica sweep",
        "formal_core": "Lean 4.31.0, exit 0, no holes, source and reading current",
        "analytic_proof": "theorem.md; requires independent mathematical review",
        "manuscript_refuted": False
    }, indent=2))


if __name__ == "__main__":
    main()
