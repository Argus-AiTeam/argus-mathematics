#!/usr/bin/env python3
"""Replay exact algebra and boundary controls, not the geometric prose proof."""

import argparse
from fractions import Fraction
import hashlib
import itertools
import json
from pathlib import Path
import re

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = (
    ROOT
    / "research/openai_manuscript"
    / "The-Blockwise-Alperin-Weight-Conjecture-September-23-2026"
    / "build/sections/differentials.tex"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def source_binding():
    text = SOURCE.read_text()
    start = text.index(
        r"\begin{theorem}[Exact purely inseparable genus estimate]"
    )
    end = text.index(r"\end{theorem}", start) + len(r"\end{theorem}")
    statement = text[start:end]
    compact = re.sub(r"\s+", "", statement)
    required = [
        r"p^{s-h}>m\bigl(h+\log_pm\bigr)",
        r"[F:F_0]_p\lep^h",
        r"d\lem",
        r"\frac{\nu(Z)}d\ge\sum_{i=1}^n\left(1-\frac1{r_i}\right)",
    ]
    for token in required:
        require(token in compact, "Target statement changed: " + token)
    return {
        "source": str(SOURCE.relative_to(ROOT)),
        "label": "thm:inseparable-genus",
        "lines": [text.count("\n", 0, start) + 1, text.count("\n", 0, end) + 1],
        "literal_statement": statement,
        "retained_hypotheses": required,
    }


def rational_function(value):
    variables = [sp.Symbol(name) for name in value["variables"]]

    def polynomial(spec):
        return sum(
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
            * sp.prod(x**e for x, e in zip(variables, term["exponents"], strict=True))
            for term in spec["terms"]
        )

    return sp.cancel(polynomial(value["numerator"]) / polynomial(value["denominator"]))


def jacobian_replay():
    payload = json.loads((HERE / "jacobian/payload.json").read_text())
    response = json.loads((HERE / "jacobian/output.json").read_text())
    status = json.loads((HERE / "jacobian/adapter_status.json").read_text())
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(not status["timed_out"], "Jacobian timeout is not evidence")
    require(status["structured_error"] is None, "Jacobian reported an error")
    operation = "matrix.symbolic.determinant.compute"
    require(response["result"]["operation_id"] == operation, "Wrong operation")
    require(response["request"]["payload"] == payload, "Payload does not match")
    require(response["protocol_version"] == status["protocol_version"], "Protocol changed")
    require(response["server"]["version"] == status["server_version"], "Server changed")
    entries = [
        [rational_function(value) for value in row]
        for row in payload["matrix"]["entries"]
    ]
    output = response["result"]["output"]
    computed = sp.Matrix(entries).det()
    require(
        sp.cancel(computed - rational_function(output["determinant"])) == 0,
        "Typed determinant failed independent replay",
    )
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": status["adapter_exit_code"],
        "structured_error": None,
        "determinant": str(computed),
        "scope": "One generic 2x2 determinant over QQ, not a genus theorem",
    }


def zero_mod_p(expression, variables, p):
    return sp.Poly(sp.expand(expression), *variables, modulus=p).is_zero


def symbolic_checks():
    p, q, v, f, image, nxt, degree, lower_degree = sp.symbols(
        "p q v f image next degree lower_degree"
    )
    genus = q * nxt + (p - 1) * f
    numerator = p * genus - q * nxt - (p - 1) * (genus + f)
    require(sp.expand(numerator) == 0, "Genus recurrence numerator has wrong sign")
    normalized = (
        genus / degree
        - nxt / (p * lower_degree)
        - (1 - 1 / p) * (genus + f) / degree
    ).subs(degree, q * lower_degree)
    require(sp.cancel(normalized) == 0, "The recurrence factor is not 1/p")

    t, h, x, a, ell, z, b = sp.symbols("t h x a ell z b")
    parent = (h + 1) * (1 - z * t) + (1 - t) * (x + a - ell - 1)
    child = (1 - t) * (h + x) + t * (
        (h + 1) * (1 - z) + (1 - t) * (a - ell)
    )
    require(
        sp.expand(parent - child - (1 - t) ** 2 * (a - ell)) == 0,
        "Universal profile induction residual is nonzero",
    )
    phi_next = (h + 1) * (1 - z / p) + (1 - 1 / p) * (a - b - 1)
    phi_now = (h + 1) * (1 - z) + (1 - 1 / p) * (a - b)
    require(
        sp.cancel(phi_next - phi_now - (1 - 1 / p) * ((h + 1) * z - 1)) == 0,
        "Maximizing-length difference identity is false",
    )

    determinant_cases = []
    for size, prime in itertools.product((2, 3), (2, 3, 5)):
        variables = sp.symbols(f"x0:{size * size}")
        matrix = sp.Matrix(size, size, variables)
        residual = matrix.applyfunc(lambda value: value**prime).det() - matrix.det() ** prime
        require(zero_mod_p(residual, variables, prime), "Frobenius determinant failure")
        determinant_cases.append({"matrix_size": size, "prime": prime})

    x, y, a, b, c, d, z, u, v = sp.symbols("x y a b c d z u v")
    generators = [a * x + b * y + z * x * y, c * x + d * y + x**2]
    jacobian = sp.Matrix(generators).jacobian([x, y])
    transitions = []
    for prime in (2, 3, 5):
        powered = [
            sum(
                coefficient**prime * u**exponents[0] * v**exponents[1]
                for exponents, coefficient in sp.Poly(generator, x, y).terms()
            )
            for generator in generators
        ]
        changed = sp.Matrix(powered).jacobian([u, v]).subs(
            {u: x**prime, v: y**prime}, simultaneous=True
        )
        for entry in changed - jacobian.applyfunc(lambda value: value**prime):
            require(
                zero_mod_p(entry, (x, y, a, b, c, d, z), prime),
                "Cokernel coordinates do not change by J^[p]",
            )
        for generator in powered:
            for coefficient in (a, b, c, d, z):
                require(
                    zero_mod_p(sp.diff(generator, coefficient), (u, v, a, b, c, d, z), prime),
                    "A pth-power coefficient has nonzero differential",
                )
        transitions.append(prime)

    tau, z = sp.symbols("tau z")
    full_divisor_cases = []
    for prime in (2, 3, 5, 7):
        for exponent in (prime, prime**2):
            parameter = (1 + z * tau) * tau**exponent
            for variable in (tau, z):
                derivative = sp.Poly(sp.diff(parameter, variable), tau, z, modulus=prime)
                require(
                    all(term[0] >= exponent for term, coefficient in derivative.terms() if coefficient),
                    "Differential only vanishes on reduced support",
                )
            full_divisor_cases.append({"prime": prime, "ramification_index": exponent})
        control = sp.Poly(sp.diff((1 + z * tau) * tau, tau), tau, z, modulus=prime)
        require(
            any(term[0] == 0 for term, coefficient in control.terms() if coefficient),
            "The unramified negative control did not distinguish full vanishing",
        )
    return {
        "universal_rational_residuals": {
            "recurrence_numerator": "0",
            "normalized_recurrence": "0",
            "profile_induction": "0",
            "maximizing_length_difference": "0",
        },
        "bounded_frobenius_determinants": determinant_cases,
        "bounded_nonlinear_generator_transitions_primes": transitions,
        "bounded_full_divisor_checks": full_divisor_cases,
        "meaning": "Polynomial identities plus explicitly bounded adversarial controls",
    }


def compositions(total):
    if total == 0:
        yield ()
    else:
        for first in range(1, total + 1):
            for tail in compositions(total - first):
                yield (first,) + tail


def error(p, h, profile):
    t = Fraction(1, p)
    return sum((1 - t) * t**j * (h + rank) for j, rank in enumerate(profile))


def phi(p, a, h, b):
    t = Fraction(1, p)
    return (h + 1) * (1 - t**b) + (1 - t) * (a - b)


def upper_error(p, a, h):
    if a == 0:
        return Fraction(0)
    b = 1
    while b < a and p**b < h + 1:
        b += 1
    return phi(p, a, h, b)


def profile_search():
    checked = 0
    for p in (2, 3, 5, 7):
        for a in range(1, 9):
            profiles = list(compositions(a))
            for h in (0, 1, 2, 7, 10):
                errors = []
                for profile in profiles:
                    value = error(p, h, profile)
                    require(value <= phi(p, a, h, len(profile)), "Profile upper bound failed")
                    errors.append(value)
                    checked += 1
                maximum = max(errors)
                require(maximum == upper_error(p, a, h), "Optimized profile maximum failed")
                require(maximum < h + a, "Original sufficient threshold was not recovered")
                for b in range(1, a + 1):
                    extremal = (a - b + 1,) + (1,) * (b - 1)
                    require(
                        error(p, h, extremal) == phi(p, a, h, b),
                        "Fixed-length extremal profile failed",
                    )

    local_paths = 0
    for p in (2, 3, 5, 7):
        t = Fraction(1, p)
        for length in range(1, 9):
            for steps in itertools.product((0, 1), repeat=length):
                u = sum(steps)
                activation = sum(
                    (1 - t) * t**j for j in range(length) if any(steps[j:])
                )
                require(activation >= 1 - t**u, "Local ramification prefix charge failed")
                degree, ramification = p**length, p**u
                require(degree % ramification == 0, "Nonintegral inseparable residue degree")
                require(
                    ramification * (degree // ramification) == degree,
                    "The local degree formula lost residue degree",
                )
                local_paths += 1

    table = []
    for p, h, a in ((2, 1, 1), (2, 1, 3), (2, 1, 4), (3, 1, 2), (2, 7, 4)):
        degree = p**a
        new = degree * upper_error(p, a, h)
        old = degree * (h + a)

        def least_power(threshold):
            value = 1
            while value <= threshold:
                value *= p
            return value

        table.append(
            {
                "p": p,
                "h": h,
                "m": degree,
                "original_strict_threshold": old,
                "new_strict_threshold": str(new),
                "least_original_N_power": least_power(old),
                "least_new_N_power": least_power(new),
            }
        )
    return {
        "profile_cases": checked,
        "profile_domain": "p in {2,3,5,7}; 1<=a<=8; h in {0,1,2,7,10}; all positive compositions of a",
        "local_ramification_paths": local_paths,
        "path_domain": "all binary height-one ramification paths of lengths 1 through 8",
        "threshold_improvements": table,
        "meaning": "Finite adversarial arithmetic search, not geometric enumeration",
    }


def geometric_controls():
    x, y = sp.symbols("x y")
    cubic = y**2 + x * y - x**3 - 1
    basis = sp.groebner(
        [cubic, sp.diff(cubic, x), sp.diff(cubic, y)], x, y, modulus=2
    )
    require(list(basis) == [1], "The characteristic-two cubic is singular in the affine chart")
    X, Y, Z = sp.symbols("X Y Z")
    homogeneous = Y**2 * Z + X * Y * Z - X**3 - Z**3
    require(
        sp.diff(homogeneous, Z).subs({X: 0, Y: 1, Z: 0}) == 1,
        "The origin at infinity is singular",
    )
    frobenius = homogeneous.subs(
        {X: X**2, Y: Y**2, Z: Z**2}, simultaneous=True
    )
    require(
        zero_mod_p(frobenius - homogeneous**2, (X, Y, Z), 2),
        "Frobenius does not preserve the cubic",
    )
    P = {x: 0, y: 1}
    require(cubic.subs(P) % 2 == 0, "The torsion point is not on the cubic")
    require((y + x).subs(P) == y.subs(P), "The point is not its own inverse")
    require(x.subs(P) ** 2 == x.subs(P), "Frobenius does not fix P")
    require(y.subs(P) ** 2 == y.subs(P), "Frobenius does not fix P")
    d, r, N = 2, 2, 1
    loss = d * error(2, 0, (1,))
    branch = d * (1 - Fraction(1, r))
    require(loss == N == branch, "The strict-threshold boundary control is wrong")
    require(Fraction(0, d) < 1 - Fraction(1, r), "The boundary control is not strict")

    residue_models = []
    for p in (2, 3, 5):
        for ramified, residue_rank in ((0, 1), (1, 0), (1, 1)):
            ramification = p**ramified
            residue = p**residue_rank
            degree = p ** (ramified + residue_rank)
            require(ramification * residue == degree, "Mixed local model failed")
            residue_models.append(
                {"p": p, "e": ramification, "f": residue, "degree": degree}
            )
    return {
        "strict_threshold_geometric_control": {
            "curve": "Y^2 Z + XYZ = X^3 + Z^3 in characteristic 2",
            "map": "[X:Y:Z] -> [X^2:Y^2:Z^2]",
            "mark": "[0:1:0]",
            "smoothness_checks": "affine Jacobian ideal is (1); dF/dZ at the mark is 1",
            "nu": 0,
            "degree": d,
            "ramification_index": r,
            "residue_degree": 1,
            "index": N,
            "d_times_profile_error": str(loss),
            "failed_hypothesis": "N>dE; in this example N=dE",
            "scope": "An exact control outside the manuscript hypotheses, NOT a manuscript counterexample",
            "geometric_inputs_not_recomputed": "A smooth plane cubic has genus one; relative Frobenius has degree two; X/Y is a local parameter at the mark",
        },
        "inseparable_constant_control": {
            "model": "Z=A_(F(u^(1/p))) over F, u not a pth power, A/F constant elliptic",
            "degree": "p",
            "ramification_at_constant_mark": 1,
            "residue_degree_at_constant_mark": "p",
            "nu_F": 0,
            "reduced_point_degree_over_F": "p, not 1",
            "geometric_reducedness_over_F": False,
            "scope": "Permitted type of cover; its degree/genus facts are proved in the report, not enumerated by this script",
        },
        "index_two_strictness_construction": {
            "base": "The translated cyclic twist for p=2, s=1, with P=(0,1)",
            "divisor": "The descended constant orbit O+P, not the manuscript's generic label divisor",
            "P_fixed_by_Frobenius": True,
            "index": 2,
            "h": 1,
            "cover_degree": 2,
            "stage_ranks": [1],
            "ramification_indices": [2, 2],
            "residue_degrees": [1, 1],
            "nu": 0,
            "N_equals_d_times_profile_error": 2,
            "false_conclusion_after_weakening_threshold": "0>=1",
            "not_a_manuscript_counterexample": True,
            "geometric_inputs_not_recomputed": "Twist index, Galois descent and Frobenius equivariance are proved in the report",
        },
        "mixed_DVR_models": residue_models,
        "mixed_DVR_presentations": [
            "B=k(u^p)[tau]_(tau), A=k(u)[tau]_(tau): e=1, f=p",
            "B=k[t]_(t), A=k[tau]_(tau), t=tau^p: e=p, f=1",
            "B=k(u^p)[t]_(t), A=k(u)[tau]_(tau), t=tau^p: e=p, f=p",
        ],
    }


def lean_record():
    folder = HERE / "lean"
    result = json.loads((folder / "lean_check.json").read_text())
    require(result["status"] == "success", "Lean result is not successful")
    require(result["exit_code"] == 0, "Lean compiler returned nonzero")
    require(result["proof_holes"] == [], "Lean proof has holes")
    for name, key in (
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ):
        digest = hashlib.sha256((folder / name).read_bytes()).hexdigest()
        require(digest == result[key], "Official Lean record is stale for " + name)
    names = re.findall(r"^theorem\s+([A-Za-z0-9_]+)", (folder / "Main.lean").read_text(), re.M)
    return {
        "claim": "C_FORMAL_CORE",
        "compiler_exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "fresh_official_source_and_fidelity_digests": True,
        "declarations": ["GenusAudit." + name for name in names],
        "result": "research/genus-bound-audit/lean/lean_check.json",
        "scope": "Universal algebraic/arithmetic subtheorems only; geometry and novelty are not kernel-checked",
        "replay": "This script checks the recorded compiler result and freshness, but does not rerun Lean",
    }


def certificate():
    return {
        "schema_version": 1,
        "target": "C_GENUS",
        "source_binding": source_binding(),
        "mathematical_result": {
            "report": "research/genus-bound-audit/report.md",
            "theorem_A": "nu_F(Z)/d >= sum_j (1-1/p)p^(-j) max(0,c_j-m_j)",
            "theorem_B": "N>p^A U_p(A,h) suffices uniformly for d<=m, A=floor(log_p m)",
            "original_estimate": "Proved in prose under its exact original hypotheses",
            "false_manuscript_assertions_identified": [],
            "independent_reviewer": "pending Host invocation",
            "novelty_status": "not_established",
            "publishability_status": "not_independently_assessed",
        },
        "jacobian": jacobian_replay(),
        "symbolic": symbolic_checks(),
        "bounded_search": profile_search(),
        "geometric_controls": geometric_controls(),
        "formal_core": lean_record(),
        "not_machine_verified": [
            "Normalization, regularity, absolute duality and coherent cohomology",
            "Local presentations and gluing of tangent bundles",
            "Full-divisor vanishing, exterior-power degree estimates and divisor descent",
            "The translated elliptic twist and its index",
            "The full geometric theorem, novelty, publishability and the weight conjecture",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    else:
        require(actual == json.loads(path.read_text()), "Stored exact certificate does not replay")
    print(
        json.dumps(
            {
                "ok": True,
                "certificate": str(path.relative_to(ROOT)),
                "profile_cases": actual["bounded_search"]["profile_cases"],
                "local_paths": actual["bounded_search"]["local_ramification_paths"],
                "lean_exit_code": actual["formal_core"]["compiler_exit_code"],
                "proof_holes": actual["formal_core"]["proof_holes"],
                "independent_review": "pending",
            }
        )
    )


if __name__ == "__main__":
    main()
