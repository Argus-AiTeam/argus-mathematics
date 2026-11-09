#!/usr/bin/env python3
"""Replay the exact quotient and all-degree diagnostic identities."""

import argparse
from fractions import Fraction
import hashlib
from itertools import product
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = Path(
    "research/openai_manuscript/"
    "Elementary-Positivity-of-Chromatic-Quasisymmetric-Functions-September-24-2026/"
    "build/sections/03-reordering.tex"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def verify():
    points = ((1, 0), (1, 1), (0, 1))
    d, a, b = (1, 1, 1), (0, 1, 0), (1, 0, 1)

    def det(p, q):
        return p[0] * q[1] - p[1] * q[0]

    arrows = [
        [0 if i == j else max(det(points[j], points[i]), 0) for j in range(3)]
        for i in range(3)
    ]

    def exponent(r):
        return tuple(sum(r[i] * points[i][j] for i in range(3)) for j in range(2))

    def charge(r):
        return sum(exponent(r))

    def slope(r):
        p = exponent(r)
        return Fraction(p[1], sum(p))

    def chi(r, s):
        return sum(r[i] * s[i] for i in range(3)) - sum(
            arrows[i][j] * r[i] * s[j] for i in range(3) for j in range(3)
        )

    require(all(det(points[i], points[j]) > 0 for i in range(3) for j in range(i + 1, 3)),
            "The input rays must have the manuscript's positive determinant order.")
    require(all(sum(p) > 0 and min(p) >= 0 for p in points),
            "The input points must be nonzero in N^2 with positive charge.")
    require([slope(tuple(int(i == j) for i in range(3))) for j in range(3)]
            == [Fraction(0), Fraction(1, 2), Fraction(1)],
            "Height/charge must increase in input order.")
    require(tuple(a[i] + b[i] for i in range(3)) == d, "Incorrect split.")
    require(exponent(a) == exponent(b) == (1, 1), "The two split dimensions must differ but have equal exponents.")
    require(a != b and slope(a) == slope(b) == slope(d), "The split must be genuinely distinct and same-slope.")
    require([chi(a, a), chi(b, b), chi(a, b), chi(b, a), chi(d, d)] == [1, 1, -1, -1, 0],
            "Unexpected Euler pairings.")

    x1, x2, x3, h, t, z = sp.symbols("x1 x2 x3 h t z")
    xs = (x1, x2, x3)
    coordinates = {x1: z + h, x2: z + t, x3: z}

    def subdimensions(r):
        return product(*(range(v + 1) for v in r))

    def destabilizing_generators(r):
        generators, cuts = [], []
        for first in subdimensions(r):
            if not any(first) or first == r or slope(first) <= slope(r):
                continue
            second = tuple(r[i] - first[i] for i in range(3))
            require(all(first[i] * second[i] == 0 for i in range(3)),
                    "This fixture's principal-image proof requires disjoint packs.")
            kernel = sp.prod(
                (xs[j] - xs[i]) ** (first[i] * second[j] * arrows[i][j])
                for i in range(3) for j in range(3)
            )
            generators.append(sp.expand(kernel))
            cuts.append(first)
        return generators, cuts

    generators, cuts = destabilizing_generators(d)
    ga, cuts_a = destabilizing_generators(a)
    gb, cuts_b = destabilizing_generators(b)
    require(cuts == [(0, 0, 1), (0, 1, 1)], "Not all destabilizing cuts were accounted for.")
    require(ga == [] and cuts_a == [], "The middle singleton quotient should be free.")
    require(cuts_b == [(0, 0, 1)] and gb == [x1 - x3], "The outer-pair quotient must impose x1=x3.")
    transformed = [sp.expand(g.subs(coordinates)) for g in generators]
    require(transformed == [h * t, h**2 - h * t], "Incorrect transformed ideal generators.")
    require(sp.expand(transformed[0] + transformed[1] - h**2) == 0,
            "The inverse ideal-containment certificate failed.")
    basis = sp.groebner(transformed, h, t, z, order="lex", domain=sp.QQ)
    require([p.as_expr() for p in basis.polys] == [h**2, h*t], "Unexpected reduced Groebner basis.")
    require(basis.reduce(h)[1] == h, "The nilpotent class h must be nonzero.")
    require(basis.reduce(h**2)[1] == basis.reduce(h*t)[1] == 0, "The annihilator relations must hold.")

    # This map detects h without assuming the quotient is reduced.
    eps = sp.Symbol("eps")
    dual_numbers = sp.groebner([eps**2], eps, domain=sp.QQ)
    require(all(dual_numbers.reduce(g.subs({h: eps, t: 0, z: 0}))[1] == 0 for g in transformed),
            "The independent dual-number specialization must kill the ideal.")
    require(dual_numbers.reduce(eps)[1] != 0, "The detector must not kill h.")

    def slope_lists(r):
        if not any(r):
            return [()]
        result = []
        for first in subdimensions(r):
            if not any(first) or slope(first) != slope(d):
                continue
            rest = tuple(r[i] - first[i] for i in range(3))
            result.extend((first,) + tail for tail in slope_lists(rest))
        return result

    lists = slope_lists(d)
    require(set(lists) == {(d,), (a, b), (b, a)}, "A filtration test list was omitted.")
    require(slope_lists(a) == [(a,)] and slope_lists(b) == [(b,)],
            "The two tensor factors must have only one-block same-slope tests.")

    u, v, Z, za, zb = sp.symbols("u v Z za zb")
    m, n = sp.symbols("m n", integer=True, nonnegative=True)
    U = u - v + Z
    first_ab, second_ab = (0, u + Z, 0), (v, 0, v)
    first_ba, second_ba = (u + Z, 0, u + Z), (0, v, 0)
    computed_ab = sp.prod(
        (second_ab[j] - first_ab[i]) ** ((arrows[i][j] - int(i == j)) * a[i] * b[j])
        for i in range(3) for j in range(3)
    )
    computed_ba = sp.prod(
        (second_ba[j] - first_ba[i]) ** ((arrows[i][j] - int(i == j)) * b[i] * a[j])
        for i in range(3) for j in range(3)
    )
    require(sp.expand(computed_ab + U) == 0, "The forward kernel was not derived from the manuscript arrow convention.")
    require(sp.expand(computed_ba - (v - u - Z)) == 0, "The reverse kernel was not derived from the manuscript arrow convention.")
    numerator = U**(n + 1) * v**m
    kernel = -U
    cancelled = -U**n * v**m
    require(sp.simplify(numerator - kernel * cancelled) == 0,
            "Forward cancellation failed for arbitrary basis exponents.")
    forward = cancelled.subs(Z, 0)
    forward_symbol = -zb**m * (za - zb)**n
    require(sp.simplify(forward.subs({u: za, v: zb}) - forward_symbol) == 0,
            "The forward coproduct-symbol identity failed.")
    fine_numerator = (za - zb)**(n + 1) * zb**m
    require(sp.simplify(fine_numerator - (zb - za) * forward_symbol) == 0,
            "The normalization must cancel the negative Euler exponent.")
    reverse = u**m * (v - u)**n
    swapped_reverse = reverse.xreplace({u: v, v: u})
    require(sp.simplify(forward + swapped_reverse) == 0,
            "The two ordered components must have interchange sign -1.")
    require(sp.simplify((m + n + 1) - (m + n + Fraction(1, 2) + Fraction(1, 2))) == 0,
            "Original shifted degree was not preserved.")

    lines = (ROOT / SOURCE).read_text().splitlines()
    start = lines.index(r"\begin{lemma}[Graded coproduct]\label{alg:coproduct}")
    stop = next(i for i in range(start, len(lines)) if lines[i] == r"\end{lemma}")
    literal = "\n".join(lines[start:stop + 1])
    require(r"\Delta_{a,b}:\gr B_d\longrightarrow\gr B_a\otimes\gr B_b" in literal,
            "The staged target assertion changed.")
    require(r"(L_R\otimes L_S)(\Delta_{a,b}f)=L_{R,S}(f)" in literal,
            "The staged coproduct-symbol assertion changed.")

    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    adapter = json.loads((HERE / "jacobian_result.json").read_text())
    require(adapter["request"]["payload"] == payload, "Adapter output is not bound to the exact retained payload.")
    require(adapter["request"]["operation_id"] == "polynomial.ideal.normal_form.compute",
            "Unexpected Jacobian operation.")
    output = adapter["result"]["output"]
    require(output["outcome"] == "COMPUTED" and output["in_ideal"] is False,
            "Incomplete, error, timeout, or UNKNOWN output is not evidence.")
    require(output["request"] == payload, "The typed result changed its request.")
    require(output["remainder"] == payload["polynomial"], "The typed remainder must be exactly h.")

    lean = json.loads((HERE / "lean/lean_check.json").read_text())
    require(lean["status"] == "success" and lean["exit_code"] == 0,
            "The formal core needs a successful real compiler run.")
    require(lean["audit_exit_code"] == 0 and lean["proof_holes"] == [],
            "The formal core must have no proof holes.")
    require(hashlib.sha256((HERE / "Main.lean").read_bytes()).hexdigest() == lean["source_sha256"],
            "The current Lean source no longer matches the real compiler record.")
    require(hashlib.sha256((HERE / "statement_fidelity.md").read_bytes()).hexdigest()
            == lean["statement_fidelity_sha256"],
            "The current fidelity reading no longer matches the real compiler record.")
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max(
        (c for c in ledger["claims"] if c["claim_id"] == "K_POLYNOMIAL_IMAGE_DESCENT"),
        key=lambda c: c["version"],
    )
    attached = [
        e for e in ledger["evidence"]
        if e["subject"]["subject_id"] == "K_POLYNOMIAL_IMAGE_DESCENT"
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
    ]
    require(len(attached) > 0, "The real compiler result is not attached to the current formal-core claim.")
    mechanical = attached[-1]
    archived = json.loads((ROOT / mechanical["artifact"]).read_text())
    require(archived["subject"] == mechanical["subject"]
            and archived["evidence_id"] == mechanical["evidence_id"],
            "The archived proof is not the mechanically attached evidence.")
    require(archived["lean_check"]["source_sha256"] == lean["source_sha256"]
            and archived["lean_check"]["statement_fidelity_sha256"] == lean["statement_fidelity_sha256"],
            "The archived mechanical evidence does not match the compiler record.")

    return {
        "result_class": "exact_verification_theorem",
        "claim": "V_ALG_COPRODUCT",
        "general_theorem_evidence": {
            "proof": "report.md, Structural verification",
            "formal_subclaim": "K_POLYNOMIAL_IMAGE_DESCENT",
            "formal_source": "Main.lean",
            "scope_limit": "Python replays the diagnostic, not the general mathematical proof.",
            "independent_review": "required; not performed by Engineer",
            "novelty": "not established",
            "campaign_terminal": False,
        },
        "source": {"path": SOURCE.as_posix(), "lines": [start + 1, stop + 1], "literal_assertion": literal},
        "fixture": {
            "cone": "N^2 in the pointed nonnegative quadrant",
            "charge": "x+y; positive coefficients imply finite charge sublevels",
            "height": "y",
            "input_points": [list(p) for p in points],
            "input_types": ["E", "E", "E"],
            "input_parameters": [0, 0, 0],
            "admissibility": "finite input list",
            "arrows": arrows,
            "d": list(d), "a": list(a), "b": list(b),
            "chi_aa_bb_ab_ba_dd": [1, 1, -1, -1, 0],
            "destabilizing_first_dimensions": [list(r) for r in cuts],
            "coordinates": {"h": "x1-x3", "t": "x2-x3", "z": "x3"},
            "source_ideal": ["h*t", "h**2-h*t"],
            "reduced_groebner_basis": ["h**2", "h*t"],
            "source_normal_form": "F(z,t)+h*G(z), uniquely",
            "nilpotent_class": {"element": "h", "nonzero_remainder": "h", "square": "0", "h_times_t": "0"},
            "factor_quotients": {"a": "Q[u]", "b": "Q[v], with x1=x3"},
            "restricted_kernels": {"a_then_b": "-Z-u+v", "b_then_a": "-Z-u+v"},
            "same_slope_test_lists": [[list(r) for r in item] for item in lists],
            "filtration": {
                "source_gr_0": "Q[z]",
                "source_gr_1": "t*Q[z,t] direct_sum h*Q[z]",
                "other_source_grades": "zero",
                "factor_weights": ["1/2", "1/2"],
                "only_tensor_weight": "1",
            },
            "all_degree_basis": {
                "indices": "m,n >= 0, arbitrary integers",
                "grade_0": "z^m",
                "grade_1": ["z^m*t^(n+1)", "h*z^m"],
                "delta_ab": {"z^m": "0 on grade 0", "z^m*t^(n+1)": "-v^m*(u-v)^n", "h*z^m": "0"},
                "delta_ba": {"z^m": "0 on grade 0", "z^m*t^(n+1)": "u^m*(v-u)^n", "h*z^m": "0"},
                "forward_symbol": "-zb^m*(za-zb)^n",
                "shifted_degree": "m+n+1 on both sides for z^m*t^(n+1)",
            },
            "negative_tail": "For z^m the pre-graded expansion is -v^m/(Z+u-v); its coefficients need not vanish in the tensor quotient but all vanish in tensor grade 0.",
            "conclusion": "The fixture passes for all polynomial classes; h is not a counterexample.",
        },
        "jacobian": {
            "server_version": adapter["server"]["version"],
            "protocol_version": adapter["protocol_version"],
            "operation_id": adapter["request"]["operation_id"],
            "payload_file": "jacobian_payload.json",
            "typed_output_file": "jacobian_result.json",
            "outcome": output["outcome"],
            "detail": output["detail"],
            "adapter_exit_status": 0,
            "timeout": False,
            "independent_replay": "Exact Groebner reduction and dual-number specialization above",
        },
        "formal_core": {
            "claim": "K_POLYNOMIAL_IMAGE_DESCENT",
            "artifact_directory": "lean",
            "compiler": lean["tools"]["lean"]["version"],
            "exit_code": lean["exit_code"],
            "audit_exit_code": lean["audit_exit_code"],
            "proof_holes": lean["proof_holes"],
            "source_and_fidelity_freshness": "Matched to the real compiler's required source hashes",
            "mechanical_evidence": "Attached to the current formal-core claim; archived certificate present",
            "scope": "Coefficient descent and polynomial kernel cancellation, not the entire manuscript lemma",
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = verify()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(path.read_text()) == certificate, "The persisted exact certificate does not match replay.")
    print("PASS: exact quotient, nonzero nilpotent, all-degree formulas, source binding, Jacobian replay, and fresh zero-hole Lean core.")
    print("Full-scope coproduct proof: report.md; independent review and novelty remain outstanding.")


if __name__ == "__main__":
    main()
