#!/usr/bin/env python3
"""Replay exact algebra; see report.md for the universal and geometric proofs."""

import hashlib
import itertools
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
CHECKS = []


def require(condition, label):
    if not condition:
        raise ArithmeticError(label)
    CHECKS.append(label)


def basis(generators, variables, domain=sp.GF(2)):
    return sp.groebner(generators, *variables, order="lex", domain=domain)


def generators(gb):
    return [p.as_expr() for p in gb.polys]


def normal_form(expr, gb):
    return gb.reduce(sp.expand(expr))[1]


def equal_ideals(left, right, variables, label):
    lgb, rgb = basis(left, variables), basis(right, variables)
    require(
        generators(lgb) == generators(rgb),
        label,
    )
    return generators(lgb)


def intersection(left, right, variables):
    z = sp.Dummy("intersection")
    gb = basis(
        [z * p for p in left] + [(1 - z) * p for p in right],
        (z, *variables),
    )
    return [p for p in generators(gb) if not p.has(z)]


def colon_by_element(ideal, element, variables):
    common = intersection(ideal, [element], variables)
    quotients = []
    for p in common:
        q, r = sp.div(p, element, *variables, domain=sp.GF(2))
        require(r == 0, "intersection generator exactly divisible by colon element")
        quotients.append(q)
    return quotients


def saturation(ideal, element, variables):
    z = sp.Dummy("saturation")
    gb = basis([*ideal, 1 - z * element], (z, *variables))
    return [p for p in generators(gb) if not p.has(z)]


def parse_polynomial(text, symbols):
    result = sp.sympify(text, locals=symbols)
    sp.Poly(result, *symbols.values(), domain=sp.GF(2))
    return result


def check_matrix_equations():
    a, b, c, d, e, f, g, t = sp.symbols("a b c d e f g t")
    variables = (a, b, c, d, e, f, g, t)
    tau = sp.Matrix([[1 + a, b], [c, 1 + a]])
    phi = sp.Matrix([[1 + d, e], [f, 1 + g]])
    zero = basis([], variables)
    reduce2 = lambda p: normal_form(p, zero)
    require(reduce2(tau.trace()) == 0, "characteristic-two inertia trace")
    require(
        reduce2(tau.det() - 1 - (a**2 + b * c)) == 0,
        "characteristic-two determinant equation",
    )
    commutator = phi * tau - tau * phi
    expected = sp.Matrix([[b * f + c * e, b * t], [c * t, b * f + c * e]])
    require(
        all(
            reduce2((commutator - expected)[r, s].subs(g, t + d)) == 0
            for r in range(2)
            for s in range(2)
        ),
        "commutator gives exactly bf+ce,bt,ct after g=t+d",
    )
    q, v, n, h, x, i = sp.symbols("q v n h x i")
    nmat = sp.Matrix([[0, n], [0, 0]])
    uphi = sp.Matrix([[q * v, h], [0, v]])
    require(
        uphi * nmat - q * nmat * uphi == sp.zeros(2),
        "arithmetic Frobenius orientation in unipotent incidence",
    )
    itau = sp.Matrix([[i, n], [0, -i]])
    iphi = sp.Matrix([[v + x, h], [0, v]])
    require(
        sp.expand((iphi * itau - itau * iphi)[0, 1] - (x * n - 2 * i * h)) == 0,
        "i-type incidence has xn=2ih with the stated sign",
    )
    require(
        itau**2 + sp.eye(2) == (i**2 + 1) * sp.eye(2),
        "i-type Cayley-Hamilton identity",
    )


def check_integral_groebner(gens, variables):
    polys = [sp.Poly(p, *variables, domain=sp.ZZ) for p in gens]
    for p in polys:
        require(p.LC() == 1, "integral candidate basis is monic")
    for p, q in itertools.combinations(polys, 2):
        pm, qm = p.monoms()[0], q.monoms()[0]
        lcm = tuple(max(x, y) for x, y in zip(pm, qm))
        mon = lambda exps: sp.prod(x**e for x, e in zip(variables, exps))
        s = mon(tuple(x - y for x, y in zip(lcm, pm))) * p.as_expr()
        s -= mon(tuple(x - y for x, y in zip(lcm, qm))) * q.as_expr()
        _, remainder = sp.reduced(s, gens, *variables, domain=sp.ZZ)
        require(remainder == 0, "integral Buchberger S-polynomial reduces to zero")


def check_jacobian(gens, variables):
    request = json.loads((ROOT / "jacobian_payload.json").read_text())
    response = json.loads((ROOT / "jacobian_output.json").read_text())
    require(
        response["request"]["payload"] == request,
        "Jacobian output is bound to the exact saved payload",
    )
    require(
        response["server"]["version"] == "0.14.0"
        and response["protocol_version"] == "2025-11-25",
        "Jacobian server and protocol recorded",
    )
    result = response["result"]
    require(
        result["operation_id"] == "polynomial.ideal.groebner_basis.compute"
        and result["output"]["outcome"] == "COMPUTED",
        "Jacobian computation completed, not timeout, error, or UNKNOWN",
    )
    rational_variables = variables[:6]
    result_gens = []
    for p in result["output"]["basis"]["generators"]:
        require(p["domain"] == "QQ", "Jacobian result is explicitly rational, not GF(2)")
        terms = []
        for term in p["polynomial"]["terms"]:
            num, den = term["coefficient"]["num"], term["coefficient"]["den"]
            require(den == "1", "candidate coefficients are integral")
            terms.append(
                sp.Rational(num, den)
                * sp.prod(z**e for z, e in zip(rational_variables, term["exponents"]))
            )
        result_gens.append(sum(terms))
    require(
        generators(basis(result_gens, rational_variables, sp.QQ))
        == generators(basis(gens, rational_variables, sp.QQ)),
        "typed rational candidate basis replay",
    )
    equal_ideals(result_gens, gens, variables, "candidate independently checked over GF(2)")


def check_lean_record(certificate):
    metadata = certificate["lean"]
    result = json.loads((ROOT / "lean_check.json").read_text())
    archived = json.loads((ROOT.parents[1] / metadata["certificate"]).read_text())
    require(
        result["status"] == "success"
        and result["exit_code"] == 0
        and result["proof_holes"] == []
        and result["audit_exit_code"] == 0,
        "real Lean compiler and axiom audit succeeded without proof holes",
    )
    require(
        "version 4.31.0," in result["tools"]["lean"]["version"],
        "Lean evidence uses the required 4.31.0 toolchain",
    )
    source = (ROOT / "Main.lean").read_bytes()
    fidelity = (ROOT / "statement_fidelity.md").read_text()
    require(
        hashlib.sha256(source).hexdigest() == result["source_sha256"]
        and hashlib.sha256(fidelity.encode()).hexdigest() == result["statement_fidelity_sha256"],
        "current Lean source and reading match the real compiler record",
    )
    require(
        archived["lean_source"]["text"].encode() == source
        and archived["statement_fidelity"]["text"] == fidelity
        and archived["subject"]["subject_id"] == certificate["lean_claim"]
        and archived["lean_check"] == result,
        "archived claim certificate binds exactly the checked source and reading",
    )
    require(
        metadata["exit_code"] == result["exit_code"]
        and metadata["proof_holes"] == result["proof_holes"],
        "certificate metadata agrees with actual compiler output",
    )


def check_exponent_map(bound):
    seen = {}
    for eps in (0, 1):
        for j, k, l, m in itertools.product(range(bound + 1), repeat=4):
            if j and m:
                continue
            output = (eps + 2 * (k + m), j - k - 2 * m, l + m)
            require(output not in seen, "bounded standard-monomial images are distinct")
            recovered_eps = output[0] % 2
            total = (output[0] - recovered_eps) // 2
            difference = output[1] + total
            recovered_m = max(0, -difference)
            recovered_j = max(0, difference)
            recovered = (
                recovered_eps,
                recovered_j,
                total - recovered_m,
                output[2] - recovered_m,
                recovered_m,
            )
            require(recovered == (eps, j, k, l, m), "exponent recovery formula")
            seen[output] = recovered
    return len(seen)


def local_data(index):
    a, b, c, t, e, f, d = sp.symbols(
        " ".join(f"{name}{index}" for name in ("a", "b", "c", "t", "e", "f", "d"))
    )
    ff, gg = a**2 + b * c, b * f + c * e
    return {
        "variables": (a, b, c, t, e, f, d),
        "I": [ff, b * t, c * t, gg],
        "U": [a**2, b, c],
        "PU": [a, b, c],
        "R": [t, ff, gg],
        "n": a * t,
    }


def check_products(certificate):
    full_u = certificate["bounded_replay"]["full_product_primary_decomposition_places"]
    require(full_u == 2, "full product replay has exactly the declared two places")
    data = [local_data(j) for j in range(full_u)]
    variables = tuple(x for item in data for x in item["variables"])
    ideal = [p for item in data for p in item["I"]]
    pattern_ideals, pattern_primes = [], []
    for pattern in itertools.product(("U", "R"), repeat=full_u):
        pattern_ideals.append([p for kind, item in zip(pattern, data) for p in item[kind]])
        pattern_primes.append(
            [p for kind, item in zip(pattern, data) for p in item["PU" if kind == "U" else "R"]]
        )
    intersect_primary = pattern_ideals[0]
    intersect_prime = pattern_primes[0]
    for primary, prime in zip(pattern_ideals[1:], pattern_primes[1:]):
        intersect_primary = intersection(intersect_primary, primary, variables)
        intersect_prime = intersection(intersect_prime, prime, variables)
    equal_ideals(intersect_primary, ideal, variables, "two-place full primary intersection")
    equal_ideals(
        intersect_prime,
        [*ideal, *(item["n"] for item in data)],
        variables,
        "two-place full reduced intersection",
    )
    output = []
    for u in certificate["bounded_replay"]["nilpotence_and_witness_places"]:
        data = [local_data(j) for j in range(u)]
        variables = tuple(x for item in data for x in item["variables"])
        gb = basis([p for item in data for p in item["I"]], variables)
        nils = [item["n"] for item in data]
        top = normal_form(sp.prod(nils), gb)
        require(top != 0, f"{u}-place top nilradical product is nonzero")
        for indices in itertools.combinations_with_replacement(range(u), u + 1):
            value = sp.prod(nils[j] for j in indices)
            require(normal_form(value, gb) == 0, f"{u}-place exact N^(u+1) bound")
        require(
            normal_form(sum(nils) ** 2, gb) == 0,
            f"{u}-place sum is square-zero despite nonzero top ideal power",
        )
        eps = sp.symbols(f"epsilon0:{u}")
        ts = sp.symbols(f"T0:{u}")
        target = basis([x**2 for x in eps], (*eps, *ts))
        image = sp.prod(e * t for e, t in zip(eps, ts))
        require(normal_form(image, target) != 0, f"{u}-place explicit continuous formal witness")
        output.append({"u": u, "top_nonzero_normal_form": str(top), "nilpotence_index": u + 1})
    return output


def main():
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    require(certificate["characteristic"] == 2, "certificate uses characteristic two")
    variables = sp.symbols(" ".join(certificate["variables"]))
    symbols = dict(zip(certificate["variables"], variables))
    ideals = {
        name: [parse_polynomial(text, symbols) for text in expressions]
        for name, expressions in certificate["ideals"].items()
    }
    a, b, c, t, e, f, d = variables
    ideal, qu, pu, pr = (ideals[name] for name in ("I", "Q_U", "P_U", "P_R"))
    n = parse_polynomial(certificate["nilpotent"], symbols)
    require(
        ideal == [a**2 + b * c, b * t, c * t, b * f + c * e]
        and qu == [a**2, b, c]
        and pu == [a, b, c]
        and pr == [t, a**2 + b * c, b * f + c * e]
        and n == a * t,
        "certificate exactly encodes the manuscript-derived ideal",
    )
    check_matrix_equations()
    check_integral_groebner(ideal, variables)
    check_jacobian(ideal, variables)
    check_lean_record(certificate)
    primary = equal_ideals(
        intersection(qu, pr, variables), ideal, variables, "one-place exact primary intersection"
    )
    radical = equal_ideals(
        intersection(pu, pr, variables),
        [*ideal, n],
        variables,
        "one-place exact reduced intersection",
    )
    annihilator = equal_ideals(
        colon_by_element(ideal, n, variables), pu, variables, "exact annihilator (I:at)"
    )
    equal_ideals(
        saturation(pr, b, variables), pr, variables, "ramified ideal is b-saturated"
    )
    gb = basis(ideal, variables)
    require(normal_form(n, gb) != 0, "at is nonzero in the raw quotient")
    require(normal_form(n**2, gb) == 0, "at squares to zero")
    for z in (a, b, c):
        require(normal_form(z * n, gb) == 0, "a,b,c annihilate at")
    require(normal_form(t, basis(qu, variables)) != 0, "unramified trace witness is nonzero")
    require(normal_form(b, basis(pr, variables)) != 0, "ramified nontrivial inertia witness")
    eps, tt = sp.symbols("epsilon T")
    target = basis([eps**2], (eps, tt))
    substitution = {a: eps, t: tt, b: 0, c: 0, e: 0, f: 0, d: 0}
    for p in ideal:
        require(normal_form(p.subs(substitution), target) == 0, "formal witness kills every equation")
    require(normal_form(n.subs(substitution), target) == eps * tt, "formal witness is epsilon*T")
    exponent_count = check_exponent_map(
        certificate["bounded_replay"]["standard_monomial_exponent_bound"]
    )
    products = check_products(certificate)
    multiplicities = []
    for r in range(5):
        monomials = list(itertools.product((0, 1), repeat=r))
        require(len(monomials) == 2**r, "generic square-free monomial basis has length 2^r")
        multiplicities.append({"unramified_factors": r, "generic_length": len(monomials)})
    print(
        json.dumps(
            {
                "status": "passed",
                "classification": "exact algebraic replay, not an all-u finite proof",
                "check_count": len(CHECKS),
                "matrix_and_frobenius_identities": "passed",
                "primary_basis": [str(p) for p in primary],
                "radical_basis": [str(p) for p in radical],
                "annihilator_basis": [str(p) for p in annihilator],
                "standard_monomial_instances": exponent_count,
                "products": products,
                "generic_lengths": multiplicities,
                "lean_record": {
                    "version": "4.31.0",
                    "exit_code": 0,
                    "proof_holes": [],
                    "source_and_fidelity_match": True,
                    "classification": "replay of a real stored compiler run, not a fresh compile",
                },
                "universal_proof": "report.md",
                "independent_review": "pending",
            },
            indent=2,
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
