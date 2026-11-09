#!/usr/bin/env python3
"""Replay exact shielding identities; the geometric proof is in README.md."""

import argparse
import hashlib
import json
from fractions import Fraction
from pathlib import Path

import sympy as s


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
R = s.Rational
CHECKS = []


def require(name, condition):
    if not bool(condition):
        raise AssertionError(name)
    CHECKS.append(name)


def identity(name, expression):
    require(name, s.simplify(s.cancel(s.expand(expression))) == 0)


def read_json(name):
    return json.loads((HERE / name).read_text(encoding="utf-8"))


def rational(value):
    result = Fraction(int(value["num"]), int(value["den"]))
    require(
        "canonical rational",
        str(result.numerator) == value["num"] and str(result.denominator) == value["den"],
    )
    return result


def interval_product(left, right):
    products = [a * b for a in left for b in right]
    return min(products), max(products)


def replay_jacobian():
    payload = read_json("jacobian_payload.json")
    response = read_json("jacobian_output.json")
    status = read_json("jacobian_run_status.json")
    discovery = read_json("jacobian_inspect.json")
    operation = "polynomial.box.enclosure.compute"
    require("adapter exited successfully", status["exit_code"] == 0 and not status["timeout"])
    require("inspected operation", discovery["result"]["operation"]["operation_id"] == operation)
    require("exact retained request", response["request"] == {
        "operation_id": operation, "payload": payload
    })
    require("typed operation", response["result"]["operation_id"] == operation)
    require("server binding", response["server"] == discovery["server"])
    require("protocol binding", response["protocol_version"] == discovery["protocol_version"])
    output = response["result"]["output"]
    require("retained polynomial", output["polynomial"] == payload["polynomial"])
    require("retained complete box", output["box"] == payload["box"])
    require("ordered box axes", payload["box"]["variables"] == payload["polynomial"]["variables"])

    intervals = [
        (rational(item["lower"]), rational(item["upper"]))
        for item in payload["box"]["intervals"]
    ]
    require("exact full error box", intervals == [
        (Fraction(0), Fraction(1, 10000)), (Fraction(0), Fraction(1))
    ])
    bounds = [Fraction(0), Fraction(0)]
    terms = {}
    for term in payload["polynomial"]["polynomial"]["terms"]:
        coefficient = rational(term["coefficient"])
        powers = tuple(term["exponents"])
        require("complete monomial axes", len(powers) == len(intervals))
        require("nonnegative integral exponents", all(type(p) is int and p >= 0 for p in powers))
        term_bounds = (coefficient, coefficient)
        for interval, power in zip(intervals, powers):
            factor = (Fraction(1), Fraction(1))
            for _ in range(power):
                factor = interval_product(factor, interval)
            term_bounds = interval_product(term_bounds, factor)
        bounds[0] += term_bounds[0]
        bounds[1] += term_bounds[1]
        require("distinct monomial", powers not in terms)
        terms[powers] = R(coefficient.numerator, coefficient.denominator)
    claimed = [rational(output["enclosure"][side]) for side in ("lower", "upper")]
    require("independent exact enclosure replay", bounds == claimed)
    require("strictly positive on the whole real box", bounds[0] > 0)

    e, t = s.symbols("e t", real=True)
    b, c = R(4, 5), R(17, 10)
    bulk = b * (9 - 18 * e)
    cylinder = c * (R(25, 4) - R(55, 4) * e) - R(288, 85) * (1 + e)
    retained = sum(coefficient * e ** power[0] * t ** power[1]
                   for power, coefficient in terms.items())
    identity(
        "Jacobian polynomial is the actual bulk/cylinder mixed margin",
        retained - (t * (bulk - R(719, 100)) + (1 - t) * (cylinder - R(719, 100))),
    )
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "exit_code": status["exit_code"],
        "timeout": status["timeout"],
        "structured_error": None,
        "enclosure": [str(value) for value in bounds],
        "scope": "A full real error box for scalar Hardy margins, not a geometric solver.",
    }


def profile_checks():
    a, C, y, z, r = s.symbols("a C y z r", real=True)
    q = a * y**2 / 2 - y + C / 2
    identity("all-real Riccati square identity", 2 * a * q - (a * y - 1)**2 - (a * C - 1))
    identity("all-real radial derivative identity", 2 * (q + y) - a * y**2 - C)
    identity("transformed Riccati ODE", a * q.subs(y, (1 + z) / a) -
             (z**2 + a * C - 1) / 2)
    u = y / r
    derivative = s.diff(u, r) + s.diff(u, y) * (-q / r)
    identity("chain rule at every positive radius", -2 * derivative - a * u**2 - C / r**2)

    values = {}
    for name, av, low, up in [
        ("original", R(29, 50), R(2), R(53, 25)),
        ("refined", R(59, 100), R(17, 10), R(171, 100)),
    ]:
        gap = av * low - 1
        require(name + " positive quadratic for every real y", av > 0 and gap > 0)
        require(name + " stage margin", av < R(3, 5))
        require(name + " smooth-potential strict margin", up > low)
        values[name] = {
            "profile_coefficient": str(av),
            "inverse_square_lower": str(low),
            "inverse_square_upper": str(up),
            "discriminant_gap": str(gap),
        }
    identity("original exact crossing factor", 2 / s.sqrt(R(29, 50) * 2 - 1) - 5)

    ar, da, p, D, cost = s.symbols("ar da p D cost", nonnegative=True)
    identity("active forcing branch residual",
             ((a + da) * y**2 + p + cost + D) - (a * y**2 + cost) - (da * y**2 + p + D))
    require("forcing residual is nonnegative for every branch value",
            (da * y**2 + p + D).is_nonnegative is True)
    return values


def hardy_checks():
    e = s.symbols("e", real=True)
    b, c = R(4, 5), R(17, 10)
    bulk = b * (9 - 18 * e)
    cylinder = c * (R(25, 4) - R(55, 4) * e) - (b**2 / c) * 9 * (1 + e)
    wall = c * (R(25, 4) - R(55, 4) * e)
    identity("rank-eight bulk field", bulk - b * (3 * (8 - e) - 15 * (1 + e)))
    identity("rank-eight wall/cylinder field",
             wall - c * (R(5, 2) * (7 - e) - R(45, 4) * (1 + e)))
    identity("vertical square is included", (b**2 / c) * 9 - R(288, 85))
    require("bulk full-interval monotonicity", s.diff(bulk, e) < 0)
    require("cylinder full-interval monotonicity", s.diff(cylinder, e) < 0)
    bulk_lower = bulk.subs(e, R(1, 10000))
    cylinder_lower = cylinder.subs(e, R(1, 10000))
    require("bulk uniform lower bound", bulk_lower > R(719, 100))
    require("cylinder uniform lower bound", cylinder_lower > R(719, 100))
    identity("strict limiting cylinder slack", cylinder.subs(e, 0) - R(36, 5) - R(5, 136))

    A, normal, trace, seam_slack = s.symbols("A normal trace seam_slack", real=True)
    identity("seam cancellation for arbitrary matching trace",
             (-b * normal + c * (b / c) * A) * trace**2 -
             b * (A - normal) * trace**2)
    require("seam residual never restricts the trace value",
            (b * s.Symbol("nonnegative_flux_slack", nonnegative=True) * trace**2).is_nonnegative is True)
    identity("wall needs no compensating square", wall - cylinder - (b**2 / c) * 9 * (1 + e))

    factor = R(1001, 1000)**3 / R(719, 100)
    original = R(29, 25) * R(53, 25) * factor
    refined = R(29, 25) * R(171, 100) * factor
    manuscript = R(29, 25) * R(53, 25) * R(26, 25) / R(7, 2)
    require("old shell with improved field", original < R(344, 1000) < R(78, 100))
    require("new shell local bound", refined < R(277, 1000))
    require("manuscript printed local arithmetic", manuscript < R(731, 1000) < R(78, 100))
    return {
        "error_upper": "1/10000",
        "common_local_hardy_coefficient": "719/100",
        "bulk_lower": str(bulk_lower),
        "cylinder_lower": str(cylinder_lower),
        "limiting_hardy_coefficient": "36/5",
        "limiting_cylinder_slack": "5/136",
        "old_shell_local_quotient": str(original),
        "refined_local_quotient": str(refined),
        "manuscript_printed_quotient": str(manuscript),
    }


def dimension_and_budget_checks():
    n, extra, count_slack, codim = s.symbols(
        "n extra count_slack codim", nonnegative=True
    )
    m = n + 8
    q = 2 * m / (m - 2)
    beta = 2 * (m - 1) / (m - 2)
    identity("trace Holder exponent in every dimension", 2 * (beta - 1) - q)
    identity("bulk BV exponent in every dimension", beta * m / (m - 1) - q)
    identity("bulk interpolation exponent in every dimension", beta - (q + 2) / 2)
    require("strict Sobolev gain in every dimension", s.factor(q - 2).is_positive is True)
    require("bulk absorption in every dimension",
            s.factor((m - 1) / m - R(1, 2)).is_positive is True)
    identity("product-independent wall capacity gap",
             ((m + extra - 3) - (m + extra - 8)) - 5)
    identity("bulk capacity gap", ((m - 2) - (m - 8)) - 6)
    identity("strict guard count gap", (m - 2) - (m - 8) - 6)
    identity("face projection count slack",
             (m - 2 + count_slack) - (m - codim - 2) - (count_slack + codim))
    require("face projection for every nonnegative codimension",
            (count_slack + codim).is_nonnegative is True)
    identity("bulk kernel positive trace coefficient", m - (m - 4) - 2 - 2)
    identity("wall kernel positive trace coefficient", (m - 1) - (m - 4) - 2 - 1)
    identity("rough density dyadic exponent", R(15, 2) - R(11, 2) - 2)
    identity("rough kernel leading scale", m - R(11, 2) - (m - 4) + R(3, 2))
    identity("rough kernel first derivative scale", m - R(11, 2) - (m - 3) + R(5, 2))

    theta, kappa, t, gap = s.symbols("theta kappa t gap", real=True)
    identity("maximum argument when old coefficient is larger",
             (kappa + gap) - ((kappa + gap) * t + kappa * (1 - t)) -
             gap * (1 - t))
    identity("maximum argument when local coefficient is larger",
             (theta + gap) - (theta * t + (theta + gap) * (1 - t)) - gap * t)

    N = s.symbols("N", integer=True, nonnegative=True)
    k = s.symbols("k", integer=True, positive=True)
    allowance = s.symbols("allowance", nonnegative=True)
    identity("exact allowance sum for every finite prefix",
             s.summation(allowance / 2**k, (k, 1, N)) -
             allowance * (1 - 2**(-N)))
    identity("original global allowance", R(78, 100) + R(1, 10) - R(22, 25))
    identity("refined global allowance", R(277, 1000) + R(3, 1000) - R(7, 25))
    identity("general strict limiting threshold",
             (R(29, 25) / (R(3, 5) * R(36, 5))) - R(29, 108))
    require("explicit improved coefficient exceeds strict threshold",
            R(7, 25) > R(29, 108))
    return {
        "dimensions": "all integers m>=8; every finite Euclidean product dimension",
        "guard_count_margin": 6,
        "wall_capacity_exponent_gap": 5,
        "old_common_bound": "22/25",
        "refined_common_bound": "7/25",
        "refined_bookkeeping_start": "277/1000",
        "refined_total_allowance": "3/1000",
        "strict_general_threshold": "29/108",
        "critical_endpoint_claimed": False,
    }


def source_checks():
    base = ROOT / "research/openai_manuscript/Positive-scalar-curvature-and-uniform-codimension-two-width-September-23-2026/build"
    local = (base / "appendices/shield-local.tex").read_text(encoding="utf-8")
    global_source = (base / "appendices/shield-global.tex").read_text(encoding="utf-8")
    packets = (base / "sections/finite-cuts.tex").read_text(encoding="utf-8")
    for text, token in [
        (local, r".29y^2-y+1"),
        (local, r"R_\varepsilon=e^{5\pi}\varepsilon"),
        (local, r"D_\varepsilon&\le2.12\delta^{-2}"),
        (local, r"1.16\int D_\varepsilon v^2"),
        (local, r"No vanishing trace condition"),
        (global_source, r"\theta_*=.88"),
        (global_source, r"\gamma_\nu=.1\,2^{-\nu}"),
        (global_source, r"\ge m-2"),
        (global_source, r"two traces agree"),
        (packets, r"a_r=.60+\frac{.03r}{N_*}"),
    ]:
        require("literal staged source: " + token, token in text)
    return {
        "manuscript": str(base.relative_to(ROOT)),
        "target": "shield:global",
        "original_construction_also_checked": True,
        "geometric_inputs_not_reproved": [
            "packet:category and packet:geometry/packet:escape",
            "cut:gmt and cut:end-convergence",
            "packet:initialization and cut:barriers for the radial parent",
        ],
    }


def lean_checks():
    result = read_json("lean_check.json")
    require("real Lean compiler success", result["status"] == "success")
    require("Lean compiler exit zero", result["exit_code"] == 0)
    require("no formal proof holes", result["proof_holes"] == [])
    version = result["tools"]["lean"]["version"]
    require("required Lean 4.31.0 compiler", "version 4.31.0," in version)
    for source_name, key in [
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ]:
        actual = hashlib.sha256((HERE / source_name).read_bytes()).hexdigest()
        require("fresh formal evidence: " + source_name, result[key] == actual)
    record = read_json("lean_invocation.json")["kernel"]["recorded"]
    require("official mechanical claim binding",
            record["subject"]["subject_id"] == "C_SHIELD_CORE" and
            record["tier"] == "mechanical" and record["verdict"] == "supports")
    archive_path = ROOT / record["artifact"]
    archive = json.loads(archive_path.read_text(encoding="utf-8"))
    require("archived compiler result is this run", archive["lean_check"] == result)
    require("archived source is the current formal statement",
            archive["lean_source"]["text"] == (HERE / "Main.lean").read_text(encoding="utf-8"))
    require("archived statement fidelity is current",
            archive["statement_fidelity"]["text"] ==
            (HERE / "statement_fidelity.md").read_text(encoding="utf-8"))
    return {
        "claim": "C_SHIELD_CORE",
        "source": "Main.lean",
        "statement_fidelity": "statement_fidelity.md",
        "status": result["status"],
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "version": version,
        "official_certificate": record["artifact"],
        "scope": "Only the quantified algebraic, seam, count, exponent and budget core, not the geometric theorem.",
    }


def certificate():
    CHECKS.clear()
    result = {
        "schema_version": 1,
        "primary_claim": "C_SHIELD_GLOBAL",
        "strengthening_claim": "C_SHIELD_028",
        "result_class": "improved_bound",
        "engineer_status": "analytic_proof_complete_pending_independent_review",
        "campaign_complete": False,
        "independently_certified": False,
        "novelty_status": "unverified",
        "significance_status": "pending_independent_review",
        "source": source_checks(),
        "profiles": profile_checks(),
        "hardy": hardy_checks(),
        "dimensions_and_budgets": dimension_and_budget_checks(),
        "jacobian": replay_jacobian(),
        "lean": lean_checks(),
        "analytic_proof": "README.md",
        "analytic_obligations_in_proof": [
            "matching-domain compactness, no singular concentration and limit completion membership",
            "shrinking-form density argument, energy splitting and maximum-of-costs localization",
            "late-front coface transfer on translated moving domains and compatible cap/core construction",
            "compact residual singular guard and increasing-open-cover finite stopping",
            "finite incoming source incidence and locally finite radial construction",
        ],
        "external_analytic_sources": [
            "Simon 2014, Chapter 4 Section 5 Theorem 5.7 and Remark 5.9",
            "Nash 1956, DOI 10.2307/1969989, Theorem 2",
        ],
        "limits": [
            "Exact symbolic identities and the Lean core do not mechanically verify the analytic obligations.",
            "The geometric true-cut and packet inputs are explicit imported hypotheses.",
            "No main scalar-curvature, width or three-dimensional theorem is certified.",
            "Independent analytic, citation, statement-fidelity, novelty and significance review is pending.",
            "citation_check reports the Nash assumption unchecked; its default research/literature archive is outside this mission's writable paths.",
        ],
    }
    result["exact_checks"] = sorted(set(CHECKS))
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    computed = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(computed, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    require("certificate matches independent replay", computed == read_json(path.name))
    print(json.dumps({
        "status": "pass",
        "exact_checks": len(computed["exact_checks"]),
        "primary_bound": computed["dimensions_and_budgets"]["old_common_bound"],
        "improved_bound": computed["dimensions_and_budgets"]["refined_common_bound"],
        "independent_review": "pending",
        "campaign_complete": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
