#!/usr/bin/env python3
"""Source-qualified manuscript inventory and exact local-algebra verification."""

import argparse
import json
import re
import subprocess
from datetime import datetime, timezone
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
STATE_MODULE = "argus_skill.verticals.math.math_state"
GRAPH_MODULE = "argus_skill.verticals.math.proof_graph_check"
SOURCES = ROOT / "research/openai_manuscript"
MANUSCRIPTS = {
    "M23": "Ambiently-homeomorphic-isolated-hypersurfaces-of-multiplicities-two-and-three-September-24-2026",
    "M45": "Ambiently-homeomorphic-isolated-hypersurface-germs-in-C4-with-multiplicities-four-and-five-September-27-2026",
}
ENVIRONMENTS = re.compile(
    r"\\begin\{(theorem|lemma|proposition|corollary|definition|remark)\}"
    r"(?:\[([^\]]*)\])?(.*?)\\end\{\1\}",
    re.S,
)
DISPLAYS = re.compile(
    r"\\begin\{(equation\*?|align\*?|gather\*?|multline\*?)\}(.*?)\\end\{\1\}",
    re.S,
)
LABEL = re.compile(r"\\label\{([^}]+)\}")
REFERENCE = re.compile(r"\\(?:eqref|ref)\{([^}]+)\}")
CITE = re.compile(r"\\cite(?:\[[^\]]*\])*\{([^}]+)\}")

DEPENDENCIES = {
    "M23:thm:main": [
        "topo:analytic", "topo:sphere", "global:integral",
        "global:recover-seifert", "bg:classification",
    ],
    "M23:seed:product": [],
    "M23:seed:chain": [],
    "M23:seed:seeds": ["seed:product", "seed:chain", "bg:spectrum", "bg:real", "bg:orlik"],
    "M23:seed:prepared": ["seed:seeds", "bg:ts", "bg:real", "bg:orlik"],
    "M23:local:symmetrize": ["seed:prepared"],
    "M23:local:odd-primes": ["local:lifting", "local:symmetrize"],
    "M23:local:dyadic": ["local:symmetrize"],
    "M23:local:hasse-descent": ["bg:hasse", "local:hermitian-lengths"],
    "M23:local:rational": [
        "seed:prepared", "local:symmetrize", "local:odd-primes",
        "local:dyadic", "local:hasse-descent",
    ],
    "M23:local:reverser": ["seed:prepared", "local:symmetrize"],
    "M23:global:determinants": ["local:rational", "local:reverser"],
    "M23:global:indefinite": ["seed:prepared", "bg:ts", "bg:spectrum"],
    "M23:global:integral": ["global:determinants", "global:indefinite", "bg:approximation"],
    "M23:global:recover-seifert": ["local:symmetrize"],
    "M23:topo:analytic": ["seed:prepared", "topo:polynomials"],
    "M23:topo:sphere": ["bg:milnor", "seed:prepared", "bg:ts", "global:indefinite"],
    "M23:topo:arnold-corank": ["thm:main", "topo:analytic"],
    "M23:topo:right-equivalence": ["thm:main"],
    "M23:topo:tangent-milnor": ["topo:right-equivalence", "topo:analytic"],
    "M45:thm:main": ["prop:ambient-orders", "thm:tube", "prop:arith-integral-congruence"],
    "M45:lem:plane-data": ["setup-plane"],
    "M45:lem:cover-adjunction": ["lem:plane-data"],
    "M45:prop:ambient-orders": ["setup-ambient", "lem:simultaneous-parameters", "lem:isolation"],
    "M45:thm:tube": [
        "setup-tube", "lem:boundary", "lem:continuations", "lem:isolation",
        "lem:acyclic", "lem:local", "lem:mv", "lem:bock", "lem:lattice",
        "lem:exterior", "lem:inner",
    ],
    "M45:lem:boundary": ["setup-tube"],
    "M45:lem:continuations": ["lem:boundary"],
    "M45:lem:isolation": ["setup-ambient", "lem:simultaneous-parameters", "eq:plane-gradient"],
    "M45:lem:acyclic": ["lem:continuations", "lem:cover-adjunction"],
    "M45:lem:local": ["lem:boundary", "lem:isolation", "lem:acyclic"],
    "M45:lem:mv": ["lem:acyclic", "lem:continuations", "lem:boundary"],
    "M45:lem:bock": ["lem:acyclic", "lem:mv", "lem:continuations", "lem:cover-adjunction"],
    "M45:lem:lattice": ["lem:bock", "lem:mv", "lem:cover-adjunction"],
    "M45:lem:exterior": ["lem:acyclic", "lem:continuations"],
    "M45:lem:inner": ["lem:acyclic", "lem:continuations"],
    "M45:lem:parameter-indices": ["lem:simultaneous-parameters"],
    "M45:lem:arith-boundary": ["lem:plane-data", "lem:cover-adjunction", "setup-tube"],
    "M45:lem:arith-local-splitting": ["lem:arith-boundary", "lem:parameter-indices"],
    "M45:lem:arith-discrepancy": ["lem:arith-local-splitting"],
    "M45:lem:arith-real-signs": ["lem:parameter-indices", "lem:plane-data"],
    "M45:prop:arith-integral-congruence": [
        "thm:tube", "lem:plane-data", "lem:parameter-indices",
        "lem:arith-boundary", "lem:arith-local-splitting",
        "lem:arith-discrepancy", "lem:arith-real-signs",
    ],
}


def source_inventory():
    claims, aliases, files = {}, {}, []

    def add(namespace, path, text, start, end, kind, body, labels, title=""):
        relative = str(path.relative_to(ROOT))
        ordinal = 1 + sum(
            item["source"]["path"] == relative and item["kind"] == kind
            for item in claims.values()
        )
        suffix = labels[0] if labels else f"{path.stem}:{kind}:{ordinal}"
        claim_id = f"{namespace}:{suffix}"
        if claim_id in claims:
            raise ValueError(f"Duplicate source-qualified claim: {claim_id}")
        source = {
            "manuscript": namespace,
            "path": relative,
            "line_start": text.count("\n", 0, start) + 1,
            "line_end": text.count("\n", 0, end) + 1,
            "labels": labels,
        }
        statement = (
            f"[{namespace}; {relative}:{source['line_start']}-{source['line_end']}; "
            f"{kind}{': ' + title if title else ''}] {body.strip()}"
        )
        claims[claim_id] = {
            "statement": statement,
            "kind": kind,
            "source": source,
            "source_references": sorted(set(REFERENCE.findall(body))),
            "citation_keys": sorted(
                {key.strip() for group in CITE.findall(body) for key in group.split(",")}
            ),
        }
        for label in labels:
            aliases[f"{namespace}:{label}"] = claim_id

    for namespace, dirname in MANUSCRIPTS.items():
        for path in sorted((SOURCES / dirname).rglob("*.tex")):
            text = path.read_text()
            files.append(str(path.relative_to(ROOT)))
            for match in ENVIRONMENTS.finditer(text):
                add(namespace, path, text, match.start(), match.end(), match[1],
                    match[3], LABEL.findall(match[3]), match[2] or "")
            for match in DISPLAYS.finditer(text):
                labels = LABEL.findall(match[2])
                if labels:
                    add(namespace, path, text, match.start(), match.end(),
                        "equation", match[2], labels)
            if namespace == "M45" and path.stem in {
                "02-plane", "03-ambient", "04-tube"
            }:
                marker = {
                    "02-plane": ("Set\n", r"\begin{lemma}", "setup-plane"),
                    "03-ambient": ("Fix this choice", r"\begin{proposition}", "setup-ambient"),
                    "04-tube": ("Let \\(p=", r"\begin{theorem}", "setup-tube"),
                }[path.stem]
                start, end = text.index(marker[0]), text.index(marker[1])
                add(namespace, path, text, start, end, "definition",
                    text[start:end], [marker[2]])
    return claims, aliases, files


def argus(module, *arguments):
    return subprocess.run(
        [ARGUS_PYTHON, "-m", module, *arguments],
        cwd=ROOT, text=True, capture_output=True, check=True,
    )


def record_action(action, status, artifact):
    entry = {
        "ts": datetime.now(timezone.utc).isoformat(),
        "role": "engineer",
        "agent": "gpt-6-astra",
        "kind": "mathematical_audit",
        "action": action,
        "status": status,
        "artifact": artifact,
    }
    with (ROOT / "activity.jsonl").open("a") as stream:
        stream.write(json.dumps(entry) + "\n")


def decompose():
    claims, aliases, files = source_inventory()
    unresolved = []
    for claim_id, dependencies in DEPENDENCIES.items():
        if claim_id not in aliases and claim_id not in claims:
            unresolved.append(claim_id)
        namespace = claim_id.split(":")[0]
        for dependency in dependencies:
            qualified = f"{namespace}:{dependency}"
            if qualified not in aliases and qualified not in claims:
                unresolved.append(qualified)
    if unresolved:
        raise ValueError(
            "Dependency inventory needs source-label reconciliation: "
            + ", ".join(sorted(set(unresolved)))
            + "\nAvailable theorem labels: "
            + ", ".join(key for key, value in claims.items() if value["kind"] != "equation")
        )
    graph_path = ROOT / "research/PROOF_GRAPH.json"
    graph = json.loads(graph_path.read_text())
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    known_claims = {claim["claim_id"] for claim in state["claims"]}
    for claim_id, item in claims.items():
        if claim_id not in known_claims:
            argus(STATE_MODULE, "claim", "--project-root", str(ROOT),
                  "--id", claim_id, "--context", "CTX9000059",
                  "--statement", item["statement"])
        if claim_id not in graph["nodes"]:
            graph["nodes"][claim_id] = {
                **item, "status": "open", "reviewer_confirmed": False,
                "depends_on": [], "evidence": [item["source"]["path"]],
            }
    for claim_id, dependencies in DEPENDENCIES.items():
        namespace = claim_id.split(":")[0]
        claim_id = aliases.get(claim_id, claim_id)
        resolved = [
            aliases.get(f"{namespace}:{dependency}", f"{namespace}:{dependency}")
            for dependency in dependencies
        ]
        graph["nodes"][claim_id]["depends_on"] = resolved
        if resolved:
            route_id = f"source-route:{claim_id}"
            if route_id not in {route["route_id"] for route in state["routes"]}:
                arguments = ["route", "--project-root", str(ROOT),
                             "--id", route_id, "--goal", claim_id]
                for dependency in resolved:
                    arguments.extend(["--obligation", dependency])
                argus(STATE_MODULE, *arguments)
    graph["source_inventory"] = {
        "tex_files": files,
        "source_claim_count": len(claims),
        "interpretation": (
            "Source assertions, not certified mathematical facts. Explicit logical "
            "dependencies are separate from mere cross-references. M23 and M45 are "
            "independent manuscript arguments."
        ),
    }
    source_routes = [
        {"name": "Audit the independent M23 construction", "status": "untried",
         "evidence": "OBJECTIVE.md", "goal": "M23:thm:main"},
        {"name": "Audit the independent M45 construction", "status": "untried",
         "evidence": "OBJECTIVE.md", "goal": "M45:thm:main"},
    ]
    existing_routes = graph.get("routes", [])
    if isinstance(existing_routes, dict):
        existing_routes = list(existing_routes.values())
    names = {route["name"] for route in existing_routes}
    graph["routes"] = existing_routes + [
        route for route in source_routes if route["name"] not in names
    ]
    graph_path.write_text(json.dumps(graph, indent=2) + "\n")
    checks = {}
    for module in (STATE_MODULE, GRAPH_MODULE):
        result = argus(module, "check", "--project-root", str(ROOT))
        checks[module] = result.returncode
        print(result.stdout.strip())
    record_action(
        f"Decomposed {len(files)} LaTeX files into {len(claims)} source-qualified "
        f"claims; campaign-local checks at {ROOT}: {checks}.",
        "complete", "research/PROOF_GRAPH.json",
    )
    print(json.dumps({"tex_files": len(files), "claims": len(claims), "checks": checks}))


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for exponent, coefficient in polynomial.items():
            result[exponent] = result.get(exponent, 0) + coefficient
    return {exponent: value for exponent, value in result.items() if value}


def scale(polynomial, coefficient):
    return {exponent: coefficient * value for exponent, value in polynomial.items()
            if coefficient * value}


def multiply(left, right, cutoff):
    result = {}
    for (i, j), c in left.items():
        for (k, ell), d in right.items():
            exponent = (i + k, j + ell)
            if sum(exponent) < cutoff:
                result[exponent] = result.get(exponent, 0) + c * d
    return {exponent: value for exponent, value in result.items() if value}


def power(polynomial, exponent, cutoff):
    result = {(0, 0): 1}
    for _ in range(exponent):
        result = multiply(result, polynomial, cutoff)
    return result


def derivative(polynomial, axis):
    result = {}
    for exponent, coefficient in polynomial.items():
        if exponent[axis]:
            shifted = list(exponent)
            shifted[axis] -= 1
            result[tuple(shifted)] = coefficient * exponent[axis]
    return result


def plane_polynomials(cutoff):
    x, w = {(1, 0): 1}, {(0, 1): 1}

    def q(u):
        return multiply(
            multiply(add(u, scale(w, -1), scale(power(w, 8, cutoff), -1)),
                     add(u, scale(w, -1), scale(power(w, 8, cutoff), -2)),
                     cutoff),
            add(u, scale(power(w, 2, cutoff), -1)), cutoff,
        )

    q0 = q(x)
    d0 = multiply(multiply(x, q0, cutoff),
                  add(q0, scale(power(x, 2, cutoff), -1)), cutoff)
    u = add(x, w)
    psi = multiply(
        multiply(u, add(u, scale(power(w, 2, cutoff), -1)), cutoff),
        add(q(u), scale(power(u, 2, cutoff), -1)), cutoff,
    )
    psi_squared = power(psi, 2, cutoff)
    d1 = multiply(
        multiply(psi, add(x, scale(psi_squared, -1)), cutoff),
        add(x, scale(psi_squared, -2)), cutoff,
    )
    h = multiply(
        multiply(w, add(x, scale(power(w, 2, cutoff), -1)), cutoff),
        add(x, scale(power(w, 2, cutoff), -2)), cutoff,
    )
    return {"h": h, "d0": d0, "d1": d1}


def jet_quotient(polynomial, cutoff):
    """Exact length of QQ[[x,w]]/(J(polynomial), (x,w)^cutoff)."""
    monomials = [(i, degree - i) for degree in range(cutoff)
                 for i in range(degree, -1, -1)]
    columns = {exponent: index for index, exponent in enumerate(monomials)}
    pivots = {}
    generated_rows = 0
    for axis in (0, 1):
        generator = derivative(polynomial, axis)
        minimum_degree = min(map(sum, generator))
        for degree in range(cutoff - minimum_degree):
            for i in range(degree + 1):
                j = degree - i
                row = {
                    columns[(u + i, v + j)]: Fraction(coefficient)
                    for (u, v), coefficient in generator.items()
                    if u + i + v + j < cutoff
                }
                generated_rows += 1
                while row:
                    pivot = min(row)
                    coefficient = row[pivot]
                    if pivot not in pivots:
                        pivots[pivot] = {
                            index: value / coefficient for index, value in row.items()
                        }
                        break
                    for index, value in pivots[pivot].items():
                        updated = row.get(index, 0) - coefficient * value
                        if updated:
                            row[index] = updated
                        else:
                            row.pop(index, None)
    basis = [exponent for index, exponent in enumerate(monomials)
             if index not in pivots]
    return {
        "cutoff": cutoff,
        "ambient_dimension": len(monomials),
        "generated_rows": generated_rows,
        "rank": len(pivots),
        "quotient_dimension": len(basis),
        "standard_monomials": [list(exponent) for exponent in basis],
    }


def verify_plane_algebras():
    polynomials = plane_polynomials(26)
    result = {}
    for name, cutoff, expected in (("h", 6, 6), ("d0", 24, 51), ("d1", 24, 51)):
        lower = jet_quotient(polynomials[name], cutoff)
        upper = jet_quotient(polynomials[name], cutoff + 1)
        require(lower["quotient_dimension"] == upper["quotient_dimension"],
                f"{name}: consecutive jet lengths do not stabilize")
        require(lower["quotient_dimension"] == expected,
                f"{name}: unexpected exact local dimension")
        entry = {
            "jet_lengths": [lower, upper],
            "local_milnor_number": expected,
            "certified_maximal_ideal_power_in_jacobian": cutoff,
        }
        if name != "h":
            restriction = {i: value for (i, j), value in polynomials[name].items()
                           if j == 0}
            require(min(restriction) == 6 and restriction[6] == -1,
                    f"{name}: restriction to w=0 has the wrong initial term")
            entry["restriction_w_zero_order"] = 6
            entry["restriction_w_zero_leading_coefficient"] = "-1"
        result[name] = entry
    return result


def verify_symbolic_identities(certificate):
    import sympy as sp

    X, T, w, u, c = sp.symbols("X T w u c")
    a, b, k = sp.symbols("a b k", positive=True, integer=True)
    mu_h, mu_d, ell = sp.symbols("mu_h mu_d ell")
    q1 = (u - w - w**8) * (u - w - 2*w**8) * (u - w**2)
    q2 = q1 - u**2
    psi = (u * (u - w**2) * q2).subs(u, X + w)
    F0 = X - T**2 - q1.subs(u, T)
    F1 = T - psi
    expected_units = [(1 + w**7) * (1 + 2*w**7),
                      (1 - w) - 2*w**15 * (1 - w)**2]
    for equation, unit, coordinate in zip((F0, F1), expected_units, (X, T)):
        require(sp.expand(equation.subs({X: 0, T: 0}) - w**4 * unit) == 0,
                "A graph equation does not have the certified Weierstrass order")
        require(unit.subs(w, 0) == 1, "The Weierstrass unit is not a unit at zero")
        require(sp.diff(equation, coordinate).subs({X: 0, T: 0, w: 0}) == 1,
                "The smooth graph's base derivative is not a unit")

    h = T * (X - T**2) * (X - 2*T**2)
    expected_gradient = [2*X*T - 3*T**3, X**2 - 9*X*T**2 + 10*T**4]
    require([sp.expand(sp.diff(h, v)) for v in (X, T)] == expected_gradient,
            "The plane gradient differs from the certified formula")
    require(sp.expand((2*c - 15)*(2*c - 3) - 4*(c**2 - 9*c + 10)) == 5,
            "The noncancellation identity for the arc bound failed")

    adapter = certificate["jacobian"]
    require(adapter["payload"] == adapter["response"]["request"]["payload"],
            "The preserved Jacobian payload and response do not match")
    require(adapter["response"]["result"]["output"]["outcome"] == "COMPUTED",
            "The Jacobian adapter did not produce a mathematical result")

    def decode(polynomial):
        return sum(
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
            * X**term["exponents"][0] * T**term["exponents"][1]
            for term in polynomial["polynomial"]["terms"]
        )

    decoded_input = [decode(p) for p in adapter["payload"]["ideal"]["generators"]]
    require(decoded_input == expected_gradient, "The adapter input is not J(h)")
    decoded_basis = [
        decode(p)
        for p in adapter["response"]["result"]["output"]["basis"]["generators"]
    ]
    basis = sp.groebner(expected_gradient, X, T, order="lex", domain=sp.QQ)
    require(list(basis) == decoded_basis, "Independent replay of J(h) disagrees")
    require(list(basis) == [X**2 - sp.Rational(7, 2)*T**4,
                            X*T - sp.Rational(3, 2)*T**3, T**5],
            "The base Jacobian ideal is not the expected origin-primary ideal")

    alpha, beta = 4*b/(a+b), 4*a/(a+b)
    slack0, slack1 = (a-2)*alpha/4 - 4, (b-2)*beta/4 - 4
    n, m, N = a*b, a+b, a*b-a-b
    require(sp.factor(N/m - 4 - (slack0 + slack1)/2) == 0,
            "Tube inequalities do not imply the theorem's strict range")
    L_A = a*mu_d + k*n*mu_h
    L_w = a*ell + (a+b)*mu_h
    L_z = a*ell + (a-1)*mu_d
    computed = sp.expand(L_A + L_w - L_z)
    require(sp.expand(computed - mu_d - (k*a*b+a+b)*mu_h) == 0,
            "Intersection-length subtraction or sign is wrong")
    specialized = sp.expand(computed.subs({k: 4, mu_h: 6, mu_d: 51}))
    require(specialized == 24*a*b+6*a+6*b+51, "The final polynomial differs")

    R, Rw, xi, t, Ht = sp.symbols("R Rw xi t Ht", nonzero=True)
    second = -Rw*Ht + m*t**n/a
    third = Ht + b*w*t**N/xi
    identity = sp.expand(second + Rw*third)
    require(sp.expand(identity - t**N*(m*t**m/a + b*w*Rw/xi)) == 0,
            "The polar factorization failed")
    require(sp.expand(a*xi*(m*R/(a*xi)+b*w*Rw/xi) - (m*R+n*w*Rw)) == 0,
            "The polar Euler equation has a wrong coefficient")
    y, z, rho = sp.symbols("y z rho", nonzero=True)
    g1, g2, g3 = y*z-rho, y**a+z**b, z**(b+1)+rho*y**(a-1)
    require(sp.expand(y**(a-1)*g1-z*g2+g3) == 0,
            "The first monic quotient reduction failed")
    require(sp.expand(z**b*g1-y*g3+rho*g2) == 0,
            "The second monic quotient reduction failed")
    require(sp.expand(z**(b+1)*g2-y**a*g3-z**b*g3+rho*y**(a-1)*g2) == 0,
            "The third monic quotient reduction failed")
    return {
        "weierstrass_degree": 4,
        "unit_constants": [1, 1],
        "unit_base_derivatives": [1, 1],
        "gradient_exponent": 4,
        "gradient_noncancellation_constant": 5,
        "parameter_condition": "a,b integers >1; ab>5(a+b)",
        "tube_slack_identity": "(ab-a-b)/(a+b)-4=(slack0+slack1)/2",
        "polar_factorization": "m R+n w R_w, with m=a+b, n=ab",
        "length_identity": "L_A+L_w-L_z=mu_d+(kab+a+b)mu_h",
        "free_binomial_quotient_rank": "a+b",
        "monic_pair_reductions_checked": 3,
        "milnor_formula": "24*a*b+6*a+6*b+51",
        "s_range": "every fixed complex s!=0, as an analytic germ",
        "weierstrass_units_removed": False,
        "four_variable_jet_truncation": False,
    }


def verify(write_certificate=False):
    certificate_path = ROOT / "research/exact_certificate.json"
    certificate = json.loads(certificate_path.read_text())
    graph = json.loads((ROOT / "research/PROOF_GRAPH.json").read_text())
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claims, aliases, files = source_inventory()
    recorded = {claim["claim_id"]: claim for claim in state["claims"]}
    for claim_id, claim in claims.items():
        require(graph["nodes"][claim_id]["statement"] == claim["statement"],
                f"Proof graph is stale for {claim_id}")
        require(recorded[claim_id]["natural_statement"] == claim["statement"],
                f"Claim ledger is stale for {claim_id}")
    for claim_id, dependencies in DEPENDENCIES.items():
        namespace = claim_id.split(":")[0]
        resolved = [
            aliases.get(f"{namespace}:{dependency}", f"{namespace}:{dependency}")
            for dependency in dependencies
        ]
        require(graph["nodes"][aliases.get(claim_id, claim_id)]["depends_on"] == resolved,
                f"Source dependencies are stale for {claim_id}")
    require(len(files) == 22 and len(claims) == 114,
            "Source decomposition coverage changed")
    require("M23:thm:main" in graph["nodes"] and "M45:thm:main" in graph["nodes"],
            "An independent manuscript route was lost")
    computations = {
        "arithmetic": "exact rational; no floating point or finite-field inference",
        "plane_local_algebras": verify_plane_algebras(),
        "symbolic": verify_symbolic_identities(certificate),
    }
    if write_certificate:
        certificate["computations"] = computations
        certificate_path.write_text(json.dumps(certificate, indent=2) + "\n")
        record_action(
            "Exact rational local-jet stabilization and symbolic length identities passed; "
            "the analytic proof and independent review remain separate obligations.",
            "verified_computational_inputs", "research/exact_certificate.json",
        )
    else:
        require(computations == certificate["computations"],
                "Recomputed evidence differs from exact_certificate.json")
    print(json.dumps({
        "status": "passed",
        "source_tex_files": len(files),
        "source_qualified_claims": len(claims),
        "local_milnor_numbers": {
            name: data["local_milnor_number"]
            for name, data in computations["plane_local_algebras"].items()
        },
        "verified_symbolic_formula": computations["symbolic"]["milnor_formula"],
        "proof": "research/audit_report.tex (analytic argument; not kernel-checked)",
        "independent_review": certificate["independent_review"],
    }, sort_keys=True))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--decompose", action="store_true")
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    require(not (args.decompose and args.write_certificate), "Choose one write action")
    if args.decompose:
        decompose()
    else:
        verify(args.write_certificate)


if __name__ == "__main__":
    main()
