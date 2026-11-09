#!/usr/bin/env python3
"""Replay exact algebra used by the conditional restricted-jet proof."""

import argparse
import json
import re
from itertools import combinations
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
MANUSCRIPT = (
    ROOT
    / "research/openai_manuscript"
    / "Deforming-hypersymplectic-four-manifolds-to-hyperkahler-triples-October-7-2026"
    / "build/sections/07-pencil.tex"
)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def zero(expression, label):
    require(sp.cancel(sp.expand(expression)) == 0, label)


def zero_matrix(matrix, label):
    for entry in matrix:
        zero(entry, label)


def manuscript_assertions():
    text = MANUSCRIPT.read_text(encoding="utf-8")
    labels = [
        "eq:pencil-coefficient-pair",
        "eq:pencil-universal-section",
        "eq:pencil-pullback-linearization",
        "eq:pencil-point-distribution",
        "eq:pencil-period-cokernel",
        "eq:pencil-critical-index",
    ]
    equations = {}
    for label in labels:
        pattern = (
            r"\\begin\{equation\}\s*\\label\{"
            + re.escape(label)
            + r"\}(.*?)\\end\{equation\}"
        )
        match = re.search(pattern, text, re.DOTALL)
        require(match is not None, f"Missing manuscript assertion: {label}")
        equations[label] = re.sub(r"\s+", "", match.group(1))
    require(
        equations["eq:pencil-coefficient-pair"]
        == r"A_v=A-\frac{v_1}{v_3}B,\qquadC_v=C-\frac{v_2}{v_3}B.",
        "Coefficient pair differs from the audited assertion",
    )
    require(
        equations["eq:pencil-critical-index"] == "4+2+2-4=4.",
        "Critical index differs from the audited assertion",
    )
    compact = re.sub(r"\s+", "", text)
    require(
        r"A_v(u_s,u_t)=-2A_v(u_s,Je)" in compact,
        "Pullback identity differs from the audited assertion",
    )
    lemma = re.search(
        r"\\begin\{lemma\}\[Restricted first-jet transversality\]"
        r"\\label\{lem:pencil-jets\}(.*?)\\end\{lemma\}",
        text,
        re.DOTALL,
    )
    require(lemma is not None, "Missing target lemma")
    lemma_statement = re.sub(r"\s+", "", lemma.group(1))
    expected_lemma = (
        r"Anarbitrarilysmallsmoothexactperturbationof$(A,C)$,with$B$"
        r"fixedandthetriplepositive,makeseverysimplesphereinclass$F$"
        r"immersed.Thesameassertionholdsforapathofsuchpairs,relative"
        r"toimmersedendpoints.Theseperturbationsmaypreserveanyfinite"
        r"setofspecifiedimmersed$F$-spheresthatarecommonLagrangians"
        r"throughoutthepath.Atanendpointtheymayalsoleavefixedclosed"
        r"modelsubdisksalreadyfoliatedby$F$-curves."
    )
    require(lemma_statement == expected_lemma, "Target lemma quantifiers changed")
    equations["lem:pencil-jets"] = lemma_statement
    return equations


def decode_rational_function(entry, variables):
    require(entry["variables"] == [str(v) for v in variables], "Variable order")

    def polynomial(data):
        value = sp.Integer(0)
        for term in data["terms"]:
            coefficient = term["coefficient"]
            monomial = sp.Rational(coefficient["num"], coefficient["den"])
            require(len(term["exponents"]) == len(variables), "Exponent arity")
            for variable, exponent in zip(variables, term["exponents"]):
                require(exponent >= 0, "Negative polynomial exponent")
                monomial *= variable**exponent
            value += monomial
        return value

    denominator = polynomial(entry["denominator"])
    require(denominator != 0, "Zero rational-function denominator")
    return polynomial(entry["numerator"]) / denominator


def verify():
    a, b, x, y = sp.symbols("a b x y", real=True)
    s, t = sp.symbols("s t", real=True)
    area = sp.Symbol("area", positive=True)
    J = sp.Matrix([[0, -1, 0, 0], [1, 0, 0, 0],
                   [0, 0, 0, -1], [0, 0, 1, 0]])
    identity = sp.eye(4)
    zero_matrix(J * J + identity, "J squared")

    A = sp.Matrix([[0, 0, 1, 0], [0, 0, 0, -1],
                   [-1, 0, 0, 0], [0, 1, 0, 0]])
    H = sp.Matrix([[0, 0, 0, 1], [0, 0, 1, 0],
                   [0, -1, 0, 0], [-1, 0, 0, 0]])
    u = sp.Matrix(sp.symbols("u0:4", real=True))
    v = sp.Matrix(sp.symbols("v0:4", real=True))
    residual = (u + J * v) / 2
    for form in (A, H):
        zero_matrix(J.T * form * J + form, "Anti-invariance")
        zero((u.T * form * v)[0] + 2 * (u.T * form * J * residual)[0],
             "Exact pullback identity for arbitrary tangent vectors")

    e = sp.Matrix(sp.symbols("e0:4", real=True))
    tangent = sp.Matrix([a, b, 0, 0])
    pullbacks = sp.Matrix([
        -2 * (tangent.T * A * J * e)[0],
        -2 * (tangent.T * (x * A + y * H) * J * e)[0],
    ])
    normal = 2 * sp.Matrix([[b, a], [x * b - y * a, x * a + y * b]])
    zero_matrix(pullbacks - normal * sp.Matrix([e[2], e[3]]),
                "Normal residual and tangential kernel")
    determinant = 4 * y * (a**2 + b**2)
    zero(normal.det() - determinant, "Normal determinant")
    zero_matrix(normal.adjugate() * normal - determinant * sp.eye(2),
                "Normal inverse numerator")
    require(normal.subs(y, 0).rank() <= 1, "Degenerate pair boundary")
    require(normal.subs({a: 0, b: 0}) == sp.zeros(2), "Critical tangent boundary")

    dot_j = sp.Matrix([[s, t], [t, -s]])
    j = sp.Matrix([[0, -1], [1, 0]])
    zero_matrix(dot_j * j + j * dot_j, "Domain variation anti-commutes with j")
    du = sp.Matrix.hstack(tangent, J * tangent)
    tangential = (J * du * dot_j / 2)[:, 0]
    tangent_tests = tangential[:2, :].jacobian([s, t])
    zero(tangent_tests.det() - (a**2 + b**2) / 4,
         "Domain tests span the tangential residuals")

    symbol = s * identity + t * J
    zero_matrix((s * identity - t * J) * symbol - (s**2 + t**2) * identity,
                "Symbol inverse polynomial identity")
    zero(symbol.det() - (s**2 + t**2)**2, "Real symbol determinant")
    require(symbol.subs({s: 0, t: 0}) == sp.zeros(4), "Zero covector excluded")

    jet = sp.BlockMatrix([[identity / 2, J / 2],
                          [identity / 2, -J / 2]]).as_explicit()
    jet_inverse = sp.BlockMatrix([[identity, identity], [-J, J]]).as_explicit()
    zero_matrix(jet * jet_inverse - sp.eye(8), "Independent jet realization")
    zero_matrix(jet_inverse * jet - sp.eye(8), "Jet reconstruction")
    zero(jet.det() - sp.Rational(1, 16), "Full real first-jet determinant")

    v1, v2 = sp.symbols("v1 v2", real=True)
    coefficient_periods = -area * sp.Matrix([v1, v2]) / sp.sqrt(1-v1**2-v2**2)
    period_derivative = coefficient_periods.jacobian([v1, v2]).subs({v1: 0, v2: 0})
    zero_matrix(period_derivative + area * sp.eye(2), "Coefficient-sphere periods")
    zero_matrix(period_derivative * (-sp.eye(2) / area) - sp.eye(2),
                "Period right inverse")
    require(period_derivative.subs(area, 0) == sp.zeros(2), "Zero area excluded")

    coordinates = sp.symbols("z0:4")
    beta = []
    for i in range(4):
        polynomial = sum(sp.Symbol(f"c{i}_{j}") * coordinates[j] for j in range(4))
        polynomial += sum(
            sp.Symbol(f"h{i}_{j}_{k}") * coordinates[j] * coordinates[k]
            for j in range(4) for k in range(j, 4)
        )
        beta.append(polynomial)
    d_beta = {
        (i, j): sp.diff(beta[j], coordinates[i]) - sp.diff(beta[i], coordinates[j])
        for i, j in combinations(range(4), 2)
    }
    for i, j, k in combinations(range(4), 3):
        zero(
            sp.diff(d_beta[j, k], coordinates[i])
            - sp.diff(d_beta[i, k], coordinates[j])
            + sp.diff(d_beta[i, j], coordinates[k]),
            "d squared on arbitrary symmetric second jets of an ambient one-form",
        )

    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    require(output["request"]["payload"] == payload, "Jacobian exact payload binding")
    require(output["request"]["operation_id"] == "matrix.symbolic.rank.compute",
            "Jacobian operation binding")
    require(output["result"]["operation_id"] == "matrix.symbolic.rank.compute",
            "Jacobian result operation")
    require("output" in output["result"] and "error" not in output,
            "Jacobian did not return a completed mathematical output")
    require(output["result"]["output"] == {
        "rank": 2, "pivot_columns": [0, 1], "method": "EXACT_SYMBOLIC_ROW_REDUCTION"
    }, "Jacobian exact generic rank")
    decoded = sp.Matrix([
        [decode_rational_function(entry, [a, b, x, y]) for entry in row]
        for row in payload["matrix"]["entries"]
    ])
    zero_matrix(decoded - normal, "Jacobian matrix equals the geometric normal map")
    require(decoded.rank() == 2, "Independent symbolic rank replay")

    return {
        "schema_version": 1,
        "claim_id": "JET_ALGEBRA",
        "result_class": "exact_algebraic_verification",
        "status": "verified",
        "source": str(MANUSCRIPT.relative_to(ROOT)),
        "manuscript_assertions": manuscript_assertions(),
        "identities": {
            "pullbacks": "Q(u,v)=-2 Q(u,J((u+Jv)/2)), Q=A,H",
            "normal_matrix": [["2*b", "2*a"], ["2*x*b-2*y*a", "2*x*a+2*y*b"]],
            "normal_determinant": "4*y*(a^2+b^2)",
            "tangential_test_determinant": "(a^2+b^2)/4",
            "symbol_product": "(s*I-t*J)*(s*I+t*J)=(s^2+t^2)*I",
            "symbol_determinant": "(s^2+t^2)^2",
            "first_jet_determinant": "1/16",
            "first_jet_right_inverse": "w_s=e+h, w_t=J(h-e)",
            "period_derivative": "-area*I_2",
            "period_inverse": "-I_2/area",
            "exactness_algebra": "d(d beta)=0 for arbitrary symmetric ambient second jets",
        },
        "hypotheses_for_invertibility": [
            "y != 0",
            "a^2+b^2 > 0",
            "s^2+t^2 > 0 for a nonzero real symbol covector",
            "area=<B,F> > 0",
        ],
        "excluded_boundary_tests": [
            "y=0 loses normal rank",
            "a=b=0 makes the pullback linearization zero",
            "s=t=0 makes the symbol zero",
            "area=0 makes the period derivative zero",
        ],
        "indices": {
            "assumed_real_sphere_CR_index": 4,
            "augmented_critical": 4 + 2 + 2 - 4,
            "augmented_path_critical": 4 + 2 + 2 - 4 + 1,
            "simple_sphere_reparametrization_dimension": 6,
        },
        "jacobian": {
            "operation_id": output["result"]["operation_id"],
            "server_version": output["server"]["version"],
            "protocol_version": output["protocol_version"],
            "adapter_status": "completed",
            "adapter_error": None,
            "output": output["result"]["output"],
            "scope": "Rank over QQ(a,b,x,y), not every real specialization",
        },
        "not_machine_verified": [
            "Off-mark elliptic regularity and the exact-test annihilator argument",
            "The point-support distribution theorem and highest-order comparison",
            "The sphere domain-complex-structure surjectivity theorem",
            "The real Fredholm index formula and relative Sard-Smale",
            "Marked compactness, nonsplitting, support exclusion, and positivity openness",
            "Existence of a global smooth perturbation or the main hypersymplectic theorem",
        ],
        "analytic_argument": "argument.md gives the conditional proof with its actual support and path quantifiers",
        "independent_review": "pending",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = verify()
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
        print("Exact algebra verified; certificate written. Analytic theorem and review remain separate.")
    else:
        require(json.loads(certificate.read_text()) == result,
                "Stored certificate differs from exact replay")
        print("PASS: exact algebra and manuscript binding replayed; analytic proof is conditional, review pending.")


if __name__ == "__main__":
    main()
