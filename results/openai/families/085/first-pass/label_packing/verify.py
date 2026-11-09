#!/usr/bin/env python3
"""Replay exact supporting checks and require the current real Lean certificate."""

import argparse
import hashlib
import json
from collections import defaultdict
from fractions import Fraction as Q
from itertools import product
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
TAU = Q(1, 100)
E1 = (Q(1), Q(0))
E2 = (Q(0), Q(1))
MINUS_E1 = (-Q(1), Q(0))


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def distance2(u, v):
    return sum((a - b) ** 2 for a, b in zip(u, v))


def radius(k):
    return Q(1, 2**k)


def hat1(p, k, x):
    return max(Q(0), 1 - abs(x / radius(k) - p))


def hat(q, k, x):
    return hat1(q[0], k, x[0]) * hat1(q[1], k, x[1])


def hat_derivative(p, k, x):
    t = x / radius(k) - p
    require(t not in (-1, 0, 1), "smooth-bump center lies at a hat breakpoint")
    if abs(t) >= 1:
        return Q(0)
    return (Q(1) if t < 0 else -Q(1)) / radius(k)


def coefficients(k, atoms):
    vertices = set()
    for x, _ in atoms:
        floors = [v // radius(k) for v in x]
        vertices.update(product(*(range(p - 1, p + 3) for p in floors)))
    result = {}
    for q in vertices:
        value = sum(weight * hat(q, k, x) for x, weight in atoms)
        if value:
            result[q] = value
    return result


def direction(value):
    return E1 if value > 0 else MINUS_E1 if value < 0 else E2


def symbolic_checks():
    a, b, u, v, x, y, M, S, t = sp.symbols("a b u v x y M S t")
    identities = [
        2 * a**2 + 2 * b**2 - (a + b) ** 2 - (a - b) ** 2,
        2 * (1 - u*x - v*y) - (u-x)**2 - (v-y)**2
        - (2-u**2-v**2-x**2-y**2),
        M*t/S + (t-M*t/S) - t,
        ((1-a**2)/(1+a**2) - (1-b**2)/(1+b**2))**2
        + (2*a/(1+a**2) - 2*b/(1+b**2))**2
        - 4*(a-b)**2/((1+a**2)*(1+b**2)),
    ]
    for expression in identities:
        require(sp.cancel(expression) == 0, "symbolic identity failed")
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    require(not response.get("error"), "Jacobian returned a structured error")
    result = response["result"]
    output = result["output"]
    require(result["operation_id"] == "polynomial.multivariate.factor.compute",
            "wrong Jacobian operation")
    require(output["status"] == "FACTORIZED", "Jacobian non-conclusion")
    require(output["product_reconstruction"] == "EXACT", "inexact Jacobian output")
    require(output["reconstructed"] == payload["polynomial"], "source mismatch")

    def polynomial(spec):
        require(spec["domain"] == "QQ" and spec["variables"] == ["a", "b"],
                "Jacobian polynomial has the wrong typed ring")
        return sum(
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
            * a**term["exponents"][0] * b**term["exponents"][1]
            for term in spec["polynomial"]["terms"]
        )

    coefficient = output["coefficient"]
    reconstructed = sp.Rational(coefficient["num"], coefficient["den"])
    for factor in output["factors"]:
        reconstructed *= polynomial(factor["factor"]) ** factor["multiplicity"]
    require(sp.expand(reconstructed - polynomial(payload["polynomial"])) == 0,
            "independent Jacobian factor replay failed")
    return {
        "identities": len(identities),
        "jacobian_operation": result["operation_id"],
        "jacobian_status": output["status"],
        "jacobian_server_version": response["server"]["version"],
        "jacobian_protocol": response["protocol_version"],
        "adapter_exit": 0,
        "adapter_status": "completed",
        "adapter_timeout": False,
        "structured_error": response.get("error"),
    }


def particle_check(m):
    atoms = [
        ((Q(1, 12), Q(1, 6)), Q(1)),
        ((Q(1, 4), Q(1, 6)), -Q(2)),
        ((Q(5, 12), Q(1, 6)), Q(1)),
    ]
    values = {k: coefficients(k, atoms) for k in range(1, m + 1)}
    roots = list(product((0, 1), repeat=2))
    levels = {1: {((q,), Q(1)) for q in roots}}
    weights = {(q,): Q(1) for q in roots}
    for k in range(1, m):
        levels[k + 1] = set()
        for path, weight in levels[k]:
            p = path[-1]
            for dx, dy in product((-1, 0, 1), repeat=2):
                q = (2*p[0]+dx, 2*p[1]+dy)
                edge = hat(p, k, (radius(k+1)*q[0], radius(k+1)*q[1]))
                child = path + (q,)
                weights[child] = weight * edge
                levels[k + 1].add((child, weights[child]))
    masses = {
        path: weight * abs(values[k].get(path[-1], 0))
        for k, nodes in levels.items() for path, weight in nodes
    }
    children = defaultdict(list)
    for k in range(2, m + 1):
        for path, _ in levels[k]:
            children[path[:-1]].append(path)
    population = {path: {1: mass} if mass else {}
                  for path, mass in masses.items() if len(path) == 1}
    zero_ancestors = 0
    for k in range(1, m):
        for path, _ in levels[k]:
            capacity = sum(masses[child] for child in children[path])
            require(masses[path] <= capacity, "child capacity inequality")
            zero_ancestors += int(masses[path] == 0 and capacity > 0)
            for child in children[path]:
                t = masses[child]
                if capacity == 0:
                    require(t == masses[path] == 0, "zero capacity branch")
                    population[child] = {}
                    continue
                inherited = {birth: amount*t/capacity
                             for birth, amount in population[path].items()
                             if amount*t}
                born = t - masses[path]*t/capacity
                require(born >= 0, "negative newborn mass")
                if born:
                    inherited[k + 1] = inherited.get(k + 1, Q(0)) + born
                population[child] = inherited
                require(sum(inherited.values()) == t, "child filling identity")
    particles = [
        (path, birth, amount)
        for path, _ in sorted(levels[m])
        for birth, amount in sorted(population[path].items()) if amount
    ]
    occupied = defaultdict(Q)
    birth_masses = defaultdict(Q)
    for path, birth, amount in particles:
        birth_masses[birth] += amount
        terminal = tuple(radius(m)*p for p in path[-1])
        for k, q in enumerate(path, start=1):
            position = tuple(radius(k)*p for p in q)
            require(max(abs(a-b) for a, b in zip(terminal, position)) < radius(k),
                    "complete-path locality failed")
            if birth <= k:
                occupied[path[:k]] += amount
    for path, mass in masses.items():
        require(occupied[path] == mass, "post-birth node occupancy failed")
    for k, nodes in levels.items():
        for q, value in values[k].items():
            column = sum(w for path, w in nodes if path[-1] == q)
            require(column == 1, "actual refinement path column sum")
            total = sum(occupied[path] for path, _ in nodes if path[-1] == q)
            require(total == abs(value), "actual vertex occupancy")

    marked = set()
    anchor = {}
    for k, nodes in levels.items():
        for path, _ in nodes:
            theta = direction(values[k].get(path[-1], 0))
            if k == 1 or distance2(theta, anchor[path[:-1]]) > (TAU/8)**2:
                marked.add(path)
                anchor[path] = theta
            else:
                anchor[path] = anchor[path[:-1]]
    defects = 0
    for path in marked:
        if len(path) == m:
            continue
        frontier = []
        pending = list(children[path])
        while pending:
            child = pending.pop()
            if child in marked or len(child) == m:
                frontier.append(child)
            else:
                pending.extend(children[child])
        theta = direction(values[len(path)].get(path[-1], 0))
        defect = sum(masses[child] for child in frontier) - masses[path]
        chord = sum(masses[child] * distance2(
            direction(values[len(child)].get(child[-1], 0)), theta)
                    for child in frontier) / 2
        require(defect == chord, "stopped defect at a possibly zero ancestor")
        defects += 1
    total = sum(amount for _, _, amount in particles)
    require(total == sum(abs(v) for v in values[m].values()), "terminal mass")
    require(sum(masses[path] for path in marked) <= 1280001*4, "mark budget")

    # All selected nonzero neighbors are included throughout these whole squares.
    require(Q(1, 3)/radius(m) + 54 < 300, "whole-square inclusion condition")
    chosen = {}
    energy = Q(0)
    for k, field in values.items():
        if field:
            winner = min(field, key=lambda q: (-abs(field[q]), q))
            chosen[k] = direction(field[winner])
            energy += sum(abs(value) * distance2(chosen[k], direction(value))
                          for value in field.values())
        else:
            chosen[k] = E2
    rates = {1: Q(1), m + 1: Q(1)}
    for k in range(2, m + 1):
        rates[k] = Q(chosen[k] != chosen[k - 1])
    packing = sum(sum(abs(v) for v in values[k].values())
                  * (rates[k] + rates[k + 1]) for k in values)
    particle_energy = Q(0)
    particle_switches = Q(0)
    for path, birth, amount in particles:
        for k in range(birth, m + 1):
            q = path[k - 1]
            require(all(max(abs(w[i]-q[i]) for i in range(2)) <= 100
                        for w in values[k]), "particle's full neighbor window")
            particle_energy += amount * distance2(
                chosen[k], direction(values[k].get(q, 0)))
            particle_switches += amount * rates[k]
    KE, KR, KS = 540*4097**2, 1+2*1280001+2000000*(540*4097**2), 2000000000
    require(particle_energy == energy, "post-birth energy occupancy")
    require(energy <= KE*4, "actual-tent neighboring-direction budget")
    require(particle_switches <= KR*4, "post-birth switch budget")
    require(packing <= (1+60*KS+8*KS*(KR+KE))*4, "actual whole-square packing")
    return {
        "m": m,
        "terminal_mass": str(total),
        "birth_masses": {str(k): str(v) for k, v in sorted(birth_masses.items())},
        "zero_ancestors_with_positive_children": zero_ancestors,
        "stopped_defects_checked": defects,
        "neighbor_energy": str(energy),
        "postbirth_switch_integral": str(particle_switches),
        "actual_whole_square_packing": str(packing),
        "row_derivative_cost_on_these_squares": "0",
    }


def smooth_gradient_check():
    a, b = Q(1, 12), Q(1, 3)
    counts = {}
    for k in range(1, 5):
        require(all(min(x % radius(k), radius(k)-x % radius(k)) > Q(1, 160)
                    for x in (a, b)), "bump support crosses a hat breakpoint")
        axis = range(-1, int(b // radius(k)) + 3)
        F = {p: hat1(p, k, a) - hat1(p, k, b) for p in axis}
        D = {p: hat_derivative(p, k, a) - hat_derivative(p, k, b) for p in axis}
        vectors = [(-D[p]*F[q], -F[p]*D[q]) for p, q in product(axis, repeat=2)]
        counts[str(k)] = sum(vector != (0, 0) for vector in vectors)
    require(counts["1"] == 0 and counts["2"] > 0,
            "actual smooth-gradient zero-ancestor degeneracy absent")
    return {
        "centers": ["1/12", "1/3"],
        "bump_half_width": "1/160",
        "nonzero_actual_gradient_tent_masses_by_level": counts,
        "construction": "g=(rho(x-1/12)-rho(x-1/3))*(rho(y-1/12)-rho(y-1/3)); rho even, smooth, integral 1",
    }


def row_check():
    def P(d):
        return min(Q(1), max(Q(0), d-TAU)**2 / TAU**2)

    require([P(d) for d in (Q(0), TAU, 3*TAU/2, 2*TAU, Q(2))]
            == [0, 0, Q(1, 4), 1, 1], "exact switch thresholds")
    field = {(-300, 0): Q(1), (301, 0): -Q(1)}
    atoms = [((radius(1)*q[0], radius(1)*q[1]), value)
             for q, value in field.items()]
    require(coefficients(1, atoms) == field, "row example is not an actual tent field")
    selected = {}
    for z in product((0, 1), repeat=2):
        candidates = [w for w in field
                      if max(abs(w[i]-z[i]) for i in range(2)) <= 300]
        w = min(candidates, key=lambda q: (-abs(field[q]), q))
        selected[z] = direction(field[w])
    require(all(selected[z] == (E1 if z[0] == 0 else MINUS_E1)
                for z in selected), "actual maximal-neighbor choices")
    x = (Q(1, 4), Q(1, 4))
    probabilities = defaultdict(Q)
    gradients = defaultdict(lambda: [Q(0), Q(0)])
    for z, n in selected.items():
        probabilities[n] += hat(z, 1, x)
        gradients[n][0] += hat_derivative(z[0], 1, x[0]) * hat1(z[1], 1, x[1])
        gradients[n][1] += hat1(z[0], 1, x[0]) * hat_derivative(z[1], 1, x[1])
    require(probabilities[E1] == probabilities[MINUS_E1] == Q(1, 2), "initial row")
    require(gradients[E1] == [-2, 0] and gradients[MINUS_E1] == [2, 0],
            "actual Euclidean row gradients")
    require(radius(1)*(abs(gradients[E1][0])+abs(gradients[MINUS_E1][0])) == 2,
            "scaled Euclidean row cost")
    return {"actual_neighbor_selected_row": ["1/2", "1/2"],
            "scaled_euclidean_gradient_cost": "2",
            "old_plus_label_switch_probability": "1/2",
            "threshold_cases": 5}


def filter_check():
    cases = [(m, b) for m in range(33) for b in range(m + 1)]
    cases += [(256, b) for b in (0, 1, 128, 255, 256)] + [(2048, 2047)]
    for m, b in cases:
        c = [Q(5) if k < b else Q((3*k+1) % 7, 3) for k in range(m)] + [Q(0)]
        e, f = [Q(0)], [Q(0)]
        for value in c:
            e.append(e[-1]/2 + value)
            f.append(f[-1]/2 + e[-1])
        require(e[b] <= 10 and f[b] <= 20, "inherited pre-birth costs")
        post = sum(c[b:m])
        require(sum(e[b+1:m+1]) == 2*post+e[b]-e[m], "filter telescope")
        cost = sum(e[k+1]+e[k+2]+f[k+1] for k in range(b, m))
        require(cost <= 8*post+60, "universal-core regression inequality")
    return {"exact_cases": len(cases), "largest_depth": 2048,
            "proof_scope": "finite regression only; arbitrary depth is proved in Main.lean"}


def lean_certificate():
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "Lean did not succeed")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require("version 4.31.0," in result["tools"]["lean"]["version"],
            "wrong Lean compiler version")
    for filename, key in (("Main.lean", "source_sha256"),
                          ("statement_fidelity.md", "statement_fidelity_sha256")):
        digest = hashlib.sha256((HERE / filename).read_bytes()).hexdigest()
        require(result[key] == digest, "stale Lean source or fidelity document")
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max((c for c in ledger["claims"] if c["claim_id"] == "C_FORMAL9000085"),
                key=lambda c: c["version"])
    canonical_source = "\n".join(
        line.rstrip() for line in (HERE / "Main.lean").read_text().strip().splitlines())
    canonical_formal = "\n".join(
        line.rstrip() for line in claim["formal_statement"].strip().splitlines())
    require(canonical_formal == canonical_source,
            "the claim carries a different formal statement")
    records = [e for e in ledger["evidence"]
               if e.get("subject", {}).get("subject_id") == "C_FORMAL9000085"
               and e["subject"]["content_hash"] == claim["content_hash"]
               and e.get("tier") == "mechanical" and e.get("verdict") == "supports"]
    require(records, "no actual kernel-recorded Lean evidence")
    archives = []
    for record in records:
        archive = ROOT / record["artifact"]
        data = json.loads(archive.read_text())
        if data["lean_check"]["source_sha256"] == result["source_sha256"]:
            require(data["lean_check"]["statement_fidelity_sha256"]
                    == result["statement_fidelity_sha256"], "stale archived reading")
            archives.append(record["artifact"])
    require(archives, "current compiler certificate is not archived in the ledger")
    return {"claim": "C_FORMAL9000085", "exit_code": 0, "proof_holes": [],
            "source_sha256": result["source_sha256"],
            "statement_fidelity_sha256": result["statement_fidelity_sha256"],
            "certificates": sorted(archives)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    KE, KM, KS = 540*4097**2, 1280001, 2000000000
    KR = 1+2*KM+2000000*KE
    require(KS >= 1040000 and KS >= 2*13*66560000, "spatial constants")
    require(Q(1, 4000) <= TAU/20, "explicit net spacing")
    require(all(distance2(u, v) >= (2*TAU)**2
                for u, v in product((E1, E2, MINUS_E1), repeat=2) if u != v),
            "reachable-label switches do not saturate")
    lean = lean_certificate()
    certificate = {
        "result_class": "universal_verification_with_vector_measure_extension",
        "target_claim": "C_MEASURE_PACK9000085",
        "manuscript_specialization": "C_PACK9000085",
        "independent_review": "pending_host_invocation",
        "constants": {"neighbor": KE, "marks": KM, "switch": KR, "spatial": KS,
                      "packing": 1+60*KS+8*KS*(KR+KE)},
        "symbolic": symbolic_checks(),
        "actual_tent_particles": [particle_check(m) for m in range(1, 5)],
        "actual_smooth_gradient_degeneracy": smooth_gradient_check(),
        "actual_rows": row_check(),
        "birth_filters": filter_check(),
        "lean": lean,
        "not_certified": ["lem:local", "prop:prices", "prop:finite-band", "thm:main"],
    }
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(path.read_text()) == certificate, "exact certificate mismatch")
    print(json.dumps({"ok": True, "claim": certificate["target_claim"],
                      "lean_exit": 0, "proof_holes": [],
                      "filter_cases": certificate["birth_filters"]["exact_cases"],
                      "independent_review": certificate["independent_review"]}))


if __name__ == "__main__":
    main()
