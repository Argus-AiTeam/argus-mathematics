#!/usr/bin/env python3
"""Exact replay supporting the universal proof in report.md, not replacing it."""

import argparse
from collections import Counter
from dataclasses import dataclass
from fractions import Fraction
import hashlib
from itertools import product
import json
from math import comb, prod
from pathlib import Path

import sympy as sp
from sympy.polys.fields import field


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


@dataclass(frozen=True)
class Term:
    primary: tuple
    hessian: tuple
    active: tuple


def initial_term(n):
    require(n >= 2 and n % 2 == 0, "The trace moment must be positive and even.")
    s = n // 2
    primary = []
    for i in range(n):
        t = i // 2
        row = t if i % 2 == 0 else (t + 1) % s
        primary.append((f"R{row}", f"C{t}", f"D{i}"))
    return Term(tuple(primary), (), tuple(range(n)))


def check_resources(term):
    n = len(term.primary)
    e = sum(len(slots) - 3 for slots in term.primary)
    h = sum(len(slots) - 2 for slots in term.hessian)
    v = len(term.hessian)
    require(len(term.active) + e + h + 2 * v == n, "Resource invariant failed.")
    require(e >= 0 and h >= 0, "A derivative count became negative.")
    return e, h, v


def terminal_terms(term, statistics, depth=0):
    check_resources(term)
    n = len(term.primary)
    require(depth <= n, "Expansion depth exceeded the initial adjoint count.")
    statistics["states"] += 1
    statistics["max_depth"] = max(statistics["max_depth"], depth)
    if not term.active:
        yield term
        return
    i = term.active[0]
    remaining = tuple(k for k in term.active if k != i)
    children = []
    for j in range(n):
        if j == i:
            continue
        primary = list(term.primary)
        primary[j] += (f"D{i}",)
        children.append(Term(tuple(primary), term.hessian, remaining))
        if j in remaining:
            children.append(
                Term(
                    term.primary,
                    term.hessian + ((f"D{i}", f"D{j}"),),
                    tuple(k for k in remaining if k != j),
                )
            )
    for v in range(len(term.hessian)):
        hessian = list(term.hessian)
        hessian[v] += (f"D{i}",)
        children.append(Term(term.primary, tuple(hessian), remaining))
    require(len(children) <= 3 * n, "The universal branching bound failed.")
    statistics["max_branch"] = max(statistics["max_branch"], len(children))
    for child in children:
        yield from terminal_terms(child, statistics, depth + 1)


def open_network(term):
    require(not term.active, "Only terminal networks may be contracted.")
    n = len(term.primary)
    vertices = {f"P{i}": slots for i, slots in enumerate(term.primary)}
    vertices.update({f"H{i}": slots for i, slots in enumerate(term.hessian)})
    endpoints = {}
    for vertex, slots in vertices.items():
        require(len(slots) == len(set(slots)), "A tensor acquired a self-loop.")
        for label in slots:
            endpoints.setdefault(label, []).append(vertex)
    require(all(len(v) == 2 for v in endpoints.values()), "An index is not paired.")
    require(len(endpoints) == 2 * n, "The total slot count is inconsistent.")
    for label, ends in endpoints.items():
        require(ends[0] != ends[1], "A contraction joined a tensor to itself.")
        if label.startswith("D"):
            require(any(v.startswith("P") for v in ends), "A Hessian--Hessian edge appeared.")
    insertion = {}
    for v, slots in enumerate(term.hessian):
        neighbors = []
        for label in slots:
            other = next(x for x in endpoints[label] if x != f"H{v}")
            require(other.startswith("P"), "A Hessian has a nonprimary neighbor.")
            neighbors.append(int(other[1:]))
        require(len(set(neighbors)) >= 2, "A Hessian lacks distinct creating neighbors.")
        insertion.setdefault(min(neighbors), []).append(f"H{v}")
    order = []
    for i in range(n):
        order.append(f"P{i}")
        order.extend(insertion.get(i, []))
    position = {vertex: i for i, vertex in enumerate(order)}
    require(set(endpoints["R0"]) == {"P0", f"P{n - 1}"}, "The original cut was lost.")
    opened = {}
    for vertex, slots in vertices.items():
        opened[vertex] = tuple(
            ("cut_in" if vertex == "P0" else "cut_out") if x == "R0" else x
            for x in slots
        )
    orientations = {}
    for vertex in order:
        incoming, outgoing = [], []
        for label in opened[vertex]:
            if label == "cut_in":
                incoming.append(label)
            elif label == "cut_out":
                outgoing.append(label)
            else:
                other = next(x for x in endpoints[label] if x != vertex)
                (incoming if position[other] < position[vertex] else outgoing).append(label)
        require(incoming and outgoing, "The schedule used a trivial matrix split.")
        orientations[vertex] = (tuple(incoming), tuple(outgoing))
    return vertices, opened, order, orientations


def tensor_table(slots, incoming, outgoing, serial, unit):
    table = {}
    for coordinates in product(range(2), repeat=len(slots)):
        if unit:
            assignment = dict(zip(slots, coordinates))
            ii = sum(assignment[x] << (len(incoming) - 1 - k) for k, x in enumerate(incoming))
            oo = sum(assignment[x] << (len(outgoing) - 1 - k) for k, x in enumerate(outgoing))
            u = Fraction(3, 5) if oo == 0 else Fraction(4, 5) if oo == 1 else Fraction(0)
            v = Fraction(3, 5) if ii == 0 else Fraction(4, 5) if ii == 1 else Fraction(0)
            table[coordinates] = u * v
        else:
            table[coordinates] = (17 * (serial + 1) + sum((k + 1) * (x + 1) for k, x in enumerate(coordinates))) % 5 - 2
    if unit:
        require(Fraction(3, 5) ** 2 + Fraction(4, 5) ** 2 == 1, "Rank-one norm certificate failed.")
    return table


def raw_contraction(vertices, tables):
    labels = sorted({x for slots in vertices.values() for x in slots})
    total = 0
    for coordinates in product(range(2), repeat=len(labels)):
        values = dict(zip(labels, coordinates))
        total += prod(tables[v][tuple(values[x] for x in slots)] for v, slots in vertices.items())
    return total


def composed_trace(opened, order, orientations, tables):
    retained = ("cut_in",)
    matrix = {(coordinates, b): int(coordinates == (b,)) for coordinates in product(range(2), repeat=1) for b in range(2)}
    for vertex in order:
        incoming, outgoing = orientations[vertex]
        require(set(incoming).issubset(retained), "An incoming index was not carried.")
        carried = tuple(x for x in retained if x not in incoming)
        new_retained = carried + outgoing
        next_matrix = {}
        for old_coordinates in product(range(2), repeat=len(retained)):
            old_values = dict(zip(retained, old_coordinates))
            for out_coordinates in product(range(2), repeat=len(outgoing)):
                values = old_values | dict(zip(outgoing, out_coordinates))
                entry = tables[vertex][tuple(values[x] for x in opened[vertex])]
                new_coordinates = tuple(values[x] for x in new_retained)
                for b in range(2):
                    key = (new_coordinates, b)
                    next_matrix[key] = next_matrix.get(key, 0) + entry * matrix[(old_coordinates, b)]
        retained, matrix = new_retained, next_matrix
    require(retained == ("cut_out",), "More than the original cut remains open.")
    return sum(matrix[((b,), b)] for b in range(2))


def check_network(term):
    vertices, opened, order, orientations = open_network(term)
    result = []
    for unit in (False, True):
        tables = {
            v: tensor_table(opened[v], *orientations[v], serial, unit)
            for serial, v in enumerate(order)
        }
        raw = raw_contraction(vertices, tables)
        composed = composed_trace(opened, order, orientations, tables)
        require(raw == composed, "The ordered matrix composition changed the contraction.")
        if unit:
            require(abs(raw) <= 2, "Unit split norms exceeded the one-trace dimension cost.")
        result.append(raw)
    return result


def gaussian_mean(polynomial, y):
    result = sp.Rational(0)
    for (degree,), coefficient in sp.Poly(sp.cancel(polynomial), y).terms():
        if degree % 2 == 0:
            moment = prod(range(1, degree, 2))
            result += coefficient * moment
    return sp.cancel(result)


def rational_data(value):
    value = sp.Rational(value)
    return {"num": str(value.p), "den": str(value.q)}


def check_non_gaussian_moment(n, profiles):
    y = sp.Symbol("y", real=True)
    a0, b0 = sp.Rational(27, 25), sp.Rational(9, 200)
    w = a0 + b0 * y ** 2
    v = w ** n * (1 + y)
    score = y - sp.diff(w, y) / w
    delta_v = sp.cancel(score * v - sp.diff(v, y))
    require(sp.denom(delta_v).is_number, "The test divergence should be polynomial.")
    normalizer = a0 + b0
    direct = gaussian_mean(sp.expand(delta_v ** n * w), y) / normalizer
    derivatives = [sp.diff(v, y, e) for e in range(n + 1)]
    hessian_derivatives = [sp.diff(score, y, h + 1) for h in range(n + 1)]
    expanded = sp.Rational(0)
    for (es, hs), multiplicity in profiles.items():
        integrand = sp.cancel(w * prod(derivatives[e] for e in es) * prod(hessian_derivatives[h] for h in hs))
        require(sp.denom(integrand).is_number, "An uncancelled rational integrand remains.")
        expanded += multiplicity * gaussian_mean(integrand, y) / normalizer
    require(sp.cancel(direct - expanded) == 0, "The non-Gaussian integration-by-parts identity failed.")
    return {
        "moment": n,
        "density_weight": "27/25 + (9/200)*y^2",
        "field": "(27/25 + (9/200)*y^2)^n * (1+y)",
        "direct_and_expanded_expectation": rational_data(direct),
        "degree_profiles": len(profiles),
    }


def check_material_identities():
    _, rho, y = field("rho,y", sp.QQ)
    c = sp.Rational(1, 8)
    w = 1 + c * (1 - rho ** 2) + c * rho ** 2 * y ** 2
    mean = -2 * c * rho * y / w
    score = y + rho * mean
    jets = {}
    derivative = mean
    for q in range(1, 5):
        derivative = derivative.diff(y)
        jets[q] = derivative / rho ** q
    def material(field):
        return field.diff(rho) - mean * field.diff(y)
    def divergence(field):
        return score * field - field.diff(y)
    require(material(mean) == divergence(jets[1]), "The mean material identity failed.")
    for q in range(1, 4):
        quadratic = sum(comb(q, h) * jets[h] * jets[q - h + 1] for h in range(1, q + 1))
        require(material(jets[q]) == divergence(jets[q + 1]) + 2 * rho * quadratic, f"The order-{q} material-jet identity failed.")
    test_field = y ** 3 + rho * y + 1
    commutator = material(divergence(test_field)) - divergence(material(test_field)) - divergence(mean.diff(y) * test_field)
    require(commutator == 0, "The adjoint material commutator failed.")
    limits = {str(q): str(jets[q].as_expr().subs(rho.as_expr(), 0)) for q in range(1, 5)}
    require(limits == {"1": "-2/9", "2": "0", "3": "4/27", "4": "0"}, "The rho=0 cumulant extensions changed.")
    u = sp.Symbol("u", nonnegative=True)
    require(sp.expand((1 + u) ** 2 - (1 - u)) == u ** 2 + 3 * u, "The original Hessian lower certificate failed.")
    require(sp.expand((1 + u) ** 2 + (1 - u)) == u ** 2 + u + 2, "The original Hessian upper certificate failed.")
    require(sp.expand((1 + u) ** 2 + 8 * (1 - u)) == sp.expand((u - 3) ** 2), "The interpolation Hessian certificate failed.")
    return {
        "family": "F(z)=-sum_i log(1+z_i^2/8), x=0, r=1, lambda=1/4",
        "compatible_declared_parameters": "d=16, e=1/2, delta=1/4, l=1/4",
        "identities": ["material mean", "material jets q=1,2,3", "material adjoint commutator"],
        "rho_zero_jets": limits,
        "rho_3_over_5_hessian_interval": ["11/12", "97/96"],
        "scope": "Exact identities in this admissible family; not a universal proof by finite testing.",
    }


def check_jacobian():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    output = json.loads((ROOT / "jacobian_output.json").read_text())
    status = json.loads((ROOT / "jacobian_status.json").read_text())
    require(status["exit_code"] == 0, "The Jacobian adapter did not complete successfully.")
    require(output["server"]["version"] == "0.14.0", "The inspected Jacobian server version changed.")
    require(output["protocol_version"] == "2025-11-25", "The inspected protocol changed.")
    operation = "matrix.partial_trace.compute"
    require(output["request"]["operation_id"] == operation, "Wrong Jacobian operation.")
    require(output["request"]["payload"] == payload, "Jacobian did not execute the saved payload.")
    result = output["result"]
    require(result["operation_id"] == operation and "output" in result, "Jacobian returned no completed typed output.")
    require(result["output"]["reduced_matrix"]["entries"] == [[{"num": "10349", "den": "1250"}]], "The exact closing trace changed.")
    a = [[[1, 0], [2, 1]], [[0, -1], [1, 1]]]
    h = [Fraction(11, 12), Fraction(579, 625)]
    q = [[sum(a[i][j][k] * h[k] * a[t][j][k] for j in range(2) for k in range(2)) for t in range(2)] for i in range(2)]
    saved = [[Fraction(int(x["num"]), int(x["den"])) for x in row] for row in payload["matrix"]["entries"]]
    require(q == saved, "The payload is not the stated non-Gaussian Hessian contraction.")
    return {
        "operation_id": operation,
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "adapter_exit_code": status["exit_code"],
        "typed_status": "completed",
        "closing_trace": {"num": "10349", "den": "1250"},
        "scope": "One bounded exact matrix contraction, not evidence for the universal inequality by itself.",
    }


def check_lean():
    check = json.loads((ROOT / "lean/lean_check.json").read_text())
    require(check["exit_code"] == 0 and check["audit_exit_code"] == 0, "Lean or its axiom audit failed.")
    require(check["proof_holes"] == [], "Lean proof holes remain.")
    require("version 4.31.0," in check["tools"]["lean"]["version"], "Wrong Lean version.")
    for filename, key in (("Main.lean", "source_sha256"), ("statement_fidelity.md", "statement_fidelity_sha256")):
        require(hashlib.sha256((ROOT / filename).read_bytes()).hexdigest() == check[key], f"{filename} no longer matches the real compiler record.")
    return {
        "claim": "C_DIV_LEAN_CORE",
        "compiler_exit_code": check["exit_code"],
        "axiom_audit_exit_code": check["audit_exit_code"],
        "proof_holes": check["proof_holes"],
        "declarations": [
            "DivergenceAudit.History.resource_invariant",
            "DivergenceAudit.high_trace_moment_core",
            "DivergenceAudit.root_leaf_bound",
        ],
        "scope": "Universal combinatorial conservation, exponent bounds, depth, and branching. The analytic proof is in report.md.",
    }


def verify():
    network_data, moments = [], []
    for n in (2, 4):
        statistics = {"states": 0, "max_depth": 0, "max_branch": 0}
        terms = list(terminal_terms(initial_term(n), statistics))
        require(len(terms) <= (3 * n) ** n, "The leaf bound failed.")
        profiles = Counter()
        signed_total = 0
        for term in terms:
            e, h, v = check_resources(term)
            require(e + h + 2 * v == n, "The terminal degree count failed.")
            for j in (0, 1, 17, 10000):
                require(n * (j + 1) + e + h + v <= 2 * n * (j + 1), "The polynomial exponent budget failed.")
            profiles[(tuple(sorted(len(x) - 3 for x in term.primary)), tuple(sorted(len(x) - 2 for x in term.hessian)))] += 1
            signed_total += check_network(term)[0]
        network_data.append({
            "moment": n,
            "terminal_terms": len(terms),
            "all_terms_have_single_trace_schedules": True,
            "exact_integer_and_unit_split_norm_replays": 2 * len(terms),
            "integer_contraction_checksum": signed_total,
            **statistics,
        })
        moments.append(check_non_gaussian_moment(n, profiles))
    return {
        "schema_version": 1,
        "result_class": "new_theorem",
        "novelty_status": "unresolved",
        "independent_review_status": "pending",
        "universal_result": "The general all-split adjoint-divergence transfer theorem and its manuscript specialization are proved in report.md; Lean certifies the universal resource and branching core only.",
        "sampling_theorem_certified": False,
        "finite_network_replays": network_data,
        "non_gaussian_moment_checks": moments,
        "material_identity_checks": check_material_identities(),
        "jacobian": check_jacobian(),
        "lean": check_lean(),
        "limitations": [
            "Finite replays are tests, not proofs of universal quantifiers.",
            "The analytic argument and statement fidelity require independent mathematical review.",
            "The numerical compiler, noise-removal reduction, and sampling query theorem are not certified.",
            "A bounded literature search did not settle novelty or publishability.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true", help="Write the computed exact replay results after all checks pass.")
    args = parser.parse_args()
    result = verify()
    certificate = ROOT / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2) + "\n")
    else:
        require(json.loads(certificate.read_text()) == result, "The saved exact certificate differs from this replay.")
    print(json.dumps({
        "status": "pass",
        "terminal_networks": sum(x["terminal_terms"] for x in result["finite_network_replays"]),
        "non_gaussian_moments": [x["moment"] for x in result["non_gaussian_moment_checks"]],
        "lean_compiler_exit_code": result["lean"]["compiler_exit_code"],
        "proof_holes": result["lean"]["proof_holes"],
        "universal_analytic_proof": "report.md (independent review pending)",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
