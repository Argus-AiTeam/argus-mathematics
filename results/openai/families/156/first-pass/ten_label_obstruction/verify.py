#!/usr/bin/env python3
"""Exact finite encoding and certificate replay for the ten-label obstruction."""

import argparse
import hashlib
from itertools import combinations, product
import json
from pathlib import Path
import time


ROOT = Path(__file__).resolve().parent


def subsets(n, k):
    return [sum(1 << v for v in c) for c in combinations(range(n), k)]


def contained(a, b):
    return a & b == a


def write_json(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def six_systems():
    triples = sorted(subsets(6, 3))
    complementary = [(t, 63 ^ t) for t in triples if t < (63 ^ t)]
    systems = []
    for choices in product(range(2), repeat=10):
        triangles = frozenset(pair[c] for pair, c in zip(complementary, choices))
        if all(sum(contained(p, t) for t in triangles) == 2
               for p in subsets(6, 2)):
            systems.append(triangles)
    return triples, systems


class Cnf:
    def __init__(self):
        self.names = set()
        self.clauses = set()

    def add(self, *literals):
        clause = frozenset(literals)
        if any((name, not value) in clause for name, value in clause):
            return
        self.names.update(name for name, _ in clause)
        self.clauses.add(clause)

    def xor(self, names, expected):
        for values in product((False, True), repeat=len(names)):
            if (sum(values) % 2 == 1) != expected:
                self.add(*[(name, not value) for name, value in zip(names, values)])

    def exactly_two(self, names, guard=None):
        assert len(names) == 4
        prefix = [] if guard is None else [(guard, False)]
        for triple in combinations(names, 3):
            self.add(*prefix, *[(name, True) for name in triple])
            self.add(*prefix, *[(name, False) for name in triple])

    def canonical(self):
        names = sorted(self.names)
        indices = {name: i + 1 for i, name in enumerate(names)}
        clauses = {
            tuple(sorted((indices[name] if value else -indices[name]
                          for name, value in clause), key=abs))
            for clause in self.clauses
        }
        return {"variables": names, "clauses": [list(c) for c in sorted(clauses)]}


def six_cnf():
    cnf = Cnf()
    triples = sorted(subsets(6, 3))
    name = lambda t: f"t_{t:02d}"
    for t in triples:
        u = 63 ^ t
        if t < u:
            cnf.add((name(t), True), (name(u), True))
            cnf.add((name(t), False), (name(u), False))
    for pair in subsets(6, 2):
        cnf.exactly_two([name(t) for t in triples if contained(pair, t)])
    return cnf.canonical()


def ten_cnf():
    facets = sorted(subsets(10, 4))
    triangles = sorted(subsets(10, 3))
    pairs = sorted(subsets(10, 2))
    cnf = Cnf()
    fname = lambda s: f"f_{s:04d}"
    tname = lambda t: f"t_{t:04d}"
    cnf.add(*[(fname(s), True) for s in facets])
    for t in triangles:
        incident = [fname(s) for s in facets if contained(t, s)]
        assert len(incident) == 7
        cnf.add((tname(t), False), *[(name, True) for name in incident])
        for name in incident:
            cnf.add((name, False), (tname(t), True))
        a, b = f"x_{t:04d}_a", f"x_{t:04d}_b"
        cnf.xor(incident[:3] + [a], False)
        cnf.xor(incident[3:6] + [b], False)
        cnf.xor([a, b, incident[6]], False)
    for s in facets:
        complement = 1023 ^ s
        local = [t for t in triangles if contained(t, complement)]
        assert len(local) == 20
        for t in local:
            u = complement ^ t
            if t < u:
                cnf.add((fname(s), False), (tname(t), True), (tname(u), True))
                cnf.add((fname(s), False), (tname(t), False), (tname(u), False))
        for pair in pairs:
            if contained(pair, complement):
                cnf.exactly_two([tname(t) for t in local if contained(pair, t)],
                                guard=fname(s))
    return cnf.canonical()


def check_assignment(cnf, assignment):
    assert len(assignment) == len(cnf["variables"])
    assert all(type(value) is bool for value in assignment)
    assert all(any(assignment[abs(lit) - 1] == (lit > 0) for lit in clause)
               for clause in cnf["clauses"])


def check_family(facets):
    facets = set(facets)
    assert facets and all(0 <= s < 1024 and s.bit_count() == 4 for s in facets)
    triangles = {t for t in subsets(10, 3) if any(contained(t, s) for s in facets)}
    for t in subsets(10, 3):
        assert sum(contained(t, s) for s in facets) % 2 == 0
    for s in facets:
        c = 1023 ^ s
        local = {t for t in triangles if contained(t, c)}
        for t in subsets(10, 3):
            if contained(t, c):
                assert (t in local) != ((c ^ t) in local)
        for p in subsets(10, 2):
            if contained(p, c):
                assert sum(contained(p, t) for t in local) == 2


def prepare():
    payload = {"cnf": six_cnf(), "timeout_ms": 10000}
    write_json(ROOT / "jacobian_six_payload.json", payload)
    triples, systems = six_systems()
    assert len(triples) == 20 and len(systems) == 12
    print(json.dumps({"six_systems": len(systems),
                      "six_variables": len(payload["cnf"]["variables"]),
                      "six_clauses": len(payload["cnf"]["clauses"])}))


def search():
    from pysat.solvers import Solver

    cnf = ten_cnf()
    start = time.monotonic()
    with Solver(name="glucose4", bootstrap_with=cnf["clauses"],
                with_proof=True) as solver:
        solver.conf_budget(200000)
        result = solver.solve_limited()
        record = {"operation": "pysat.glucose4.solve_limited",
                  "conflict_budget": 200000,
                  "variables": len(cnf["variables"]),
                  "clauses": len(cnf["clauses"]),
                  "outcome": {True: "SAT", False: "UNSAT", None: "UNKNOWN"}[result],
                  "seconds": time.monotonic() - start,
                  "statistics": solver.accum_stats()}
        if result is True:
            model = solver.get_model()
            assignment = [False] * len(cnf["variables"])
            for lit in model:
                assignment[abs(lit) - 1] = lit > 0
            check_assignment(cnf, assignment)
            facets = [int(name[2:]) for name, value in
                      zip(cnf["variables"], assignment) if name.startswith("f_") and value]
            check_family(facets)
            record["facets"] = facets
        elif result is False:
            proof = solver.get_proof()
            (ROOT / "refutation.drat").write_text("\n".join(proof) + "\n")
            record["proof_lines"] = len(proof)
        write_json(ROOT / "search_result.json", record)
        print(json.dumps(record))


class RupChecker:
    def __init__(self, variable_count, clauses):
        self.variable_count = variable_count
        self.clauses = []
        self.positions = []
        self.watches = [[] for _ in range(2 * variable_count + 1)]
        self.units = []
        for clause in clauses:
            self.add(clause)

    def add(self, clause):
        clause = list(dict.fromkeys(clause))
        assert all(0 < abs(lit) <= self.variable_count for lit in clause)
        index = len(self.clauses)
        self.clauses.append(clause)
        if len(clause) <= 1:
            self.positions.append([0, 0])
            self.units.append((clause[0] if clause else 0, index + 1))
        else:
            self.positions.append([0, 1])
            self.watches[clause[0]].append(index)
            self.watches[clause[1]].append(index)

    def trace(self, clause):
        values = [0] * (self.variable_count + 1)
        queue = []
        hints = []

        def assign(lit):
            if lit == 0:
                return False
            variable, value = abs(lit), 1 if lit > 0 else -1
            if values[variable] == -value:
                return False
            if values[variable] == 0:
                values[variable] = value
                queue.append(lit)
            return True

        def value(lit):
            return values[abs(lit)] * (1 if lit > 0 else -1)

        for lit in clause:
            if not assign(-lit):
                return []
        for lit, index in self.units:
            if lit != 0 and value(lit) == 1:
                continue
            hints.append(index)
            if not assign(lit):
                return hints
        cursor = 0
        while cursor < len(queue):
            false_lit = -queue[cursor]
            cursor += 1
            watched = self.watches[false_lit]
            i = 0
            while i < len(watched):
                index = watched[i]
                current = self.clauses[index]
                positions = self.positions[index]
                side = 0 if current[positions[0]] == false_lit else 1
                assert current[positions[side]] == false_lit
                other_side = 1 - side
                other = current[positions[other_side]]
                if value(other) == 1:
                    i += 1
                    continue
                replacement = next(
                    (j for j, lit in enumerate(current)
                     if j not in positions and value(lit) != -1), None)
                if replacement is not None:
                    positions[side] = replacement
                    watched[i] = watched[-1]
                    watched.pop()
                    self.watches[current[replacement]].append(index)
                else:
                    hints.append(index + 1)
                    if not assign(other):
                        return hints
                    i += 1
        return None

    def proves(self, clause):
        return self.trace(clause) is not None


def replay_refutation():
    cnf = ten_cnf()
    checker = RupChecker(len(cnf["variables"]), cnf["clauses"])
    additions, deletions, empty = 0, 0, False
    for line_number, line in enumerate((ROOT / "refutation.drat").read_text().splitlines(), 1):
        tokens = line.split()
        assert tokens, f"Empty proof line {line_number}"
        if tokens[0] == "d":
            deletions += 1
            tokens = tokens[1:]
            assert tokens and tokens[-1] == "0"
            assert all(0 < abs(int(lit)) <= len(cnf["variables"]) for lit in tokens[:-1])
            continue
        assert tokens[-1] == "0", f"Unterminated proof line {line_number}"
        clause = [int(lit) for lit in tokens[:-1]]
        assert all(0 < abs(lit) <= len(cnf["variables"]) for lit in clause)
        assert checker.proves(clause), f"Non-RUP addition at line {line_number}"
        checker.add(clause)
        additions += 1
        empty |= not clause
    assert empty, "No derived empty clause"
    result = {"variables": len(cnf["variables"]),
              "initial_clauses": len(cnf["clauses"]),
              "rup_additions": additions, "deletions_ignored": deletions,
              "derived_empty_clause": True}
    print(json.dumps(result))
    return result


def check_local_systems():
    triples, systems = six_systems()
    assert len(systems) == 12
    for system in systems:
        for a in range(6):
            vertices = set(range(6)) - {a}
            edges = {p for p in subsets(6, 2)
                     if not (p & (1 << a)) and (p | (1 << a)) in system}
            assert len(edges) == 5
            assert all(sum(bool(p & (1 << v)) for p in edges) == 2 for v in vertices)
            reached = {next(iter(vertices))}
            while True:
                enlarged = reached | {
                    v for p in edges
                    if any(p & (1 << u) for u in reached)
                    for v in vertices if p & (1 << v)}
                if enlarged == reached:
                    break
                reached = enlarged
            assert reached == vertices
        for four in subsets(6, 4):
            assert 0 < sum(contained(t, four) for t in system) < 4
        for a, b in combinations(range(6), 2):
            remaining = set(range(6)) - {a, b}
            for vertices in combinations(sorted(remaining), 3):
                r = sum(1 << v for v in vertices)
                link_a = {p for p in subsets(6, 2)
                          if contained(p, r) and (p | (1 << a)) in system}
                link_b = {p for p in subsets(6, 2)
                          if contained(p, r) and (p | (1 << b)) in system}
                assert link_a != link_b
    for omitted in range(6):
        five = 63 ^ (1 << omitted)
        restrictions = {frozenset(t for t in system if contained(t, five))
                        for system in systems}
        assert len(restrictions) == 12
    return {"complementary_choices_exhausted": 1024, "six_systems": 12,
            "six_properties_verified": 4}


def check_encoding_gates():
    for arity in (3, 4):
        names = [f"v_{i}" for i in range(arity)]
        cnf = Cnf()
        cnf.xor(names, False)
        formula = cnf.canonical()
        for values in product((False, True), repeat=arity):
            satisfied = all(any(values[abs(lit) - 1] == (lit > 0) for lit in clause)
                            for clause in formula["clauses"])
            assert satisfied == (sum(values) % 2 == 0)
    for guarded in (False, True):
        names = [f"v_{i}" for i in range(4)]
        cnf = Cnf()
        cnf.exactly_two(names, "guard" if guarded else None)
        formula = cnf.canonical()
        for values in product((False, True), repeat=len(formula["variables"])):
            bits = dict(zip(formula["variables"], values))
            satisfied = all(any(values[abs(lit) - 1] == (lit > 0) for lit in clause)
                            for clause in formula["clauses"])
            expected = sum(bits[name] for name in names) == 2
            if guarded:
                expected = not bits["guard"] or expected
            assert satisfied == expected
    for k, expected in ((2, 45), (3, 120), (4, 210)):
        masks = sorted(subsets(10, k))
        assert masks == [s for s in range(1024) if s.bit_count() == k]
        assert len(masks) == expected
    return {"label_count": 10, "facet_count": 210, "triangle_count": 120,
            "pair_count": 45, "xor_and_exact_two_truth_tables": True}


def check_jacobian():
    load = lambda name: json.loads((ROOT / name).read_text())
    rejected = load("jacobian_six_result.json")
    assert rejected["ok"] is False
    assert rejected["error"]["data"]["code"] == "INVALID_REQUEST"
    original = load("jacobian_canonicalize_payload.json")
    canonical_record = load("jacobian_canonicalize_result.json")
    assert canonical_record["request"]["operation_id"] == "sat.cnf.canonicalize"
    assert canonical_record["request"]["payload"] == original
    canonical = canonical_record["result"]["output"]["cnf"]
    expected = six_cnf()
    assert original["variable_names"] == expected["variables"] == canonical["variables"]
    clause_set = lambda clauses: {frozenset(c) for c in clauses}
    assert clause_set(original["clauses"]) == clause_set(expected["clauses"])
    assert clause_set(canonical["clauses"]) == clause_set(expected["clauses"])
    payload = load("jacobian_six_canonical_payload.json")
    record = load("jacobian_six_canonical_result.json")
    assert payload == {"cnf": canonical, "timeout_ms": 10000}
    assert record["request"]["operation_id"] == "sat.solve"
    assert record["request"]["payload"] == payload
    assert record["result"]["operation_id"] == "sat.solve"
    output = record["result"]["output"]
    assert output["source"] == payload and output["outcome"] == "SAT"
    check_assignment(canonical, output["assignment"])
    witness = frozenset(int(name[2:]) for name, value in
                        zip(canonical["variables"], output["assignment"]) if value)
    assert witness in six_systems()[1]
    return {"operation_id": "sat.solve",
            "server_version": record["server"]["version"],
            "protocol_version": record["protocol_version"],
            "outcome": output["outcome"],
            "original_request_rejection": "INVALID_REQUEST",
            "assignment_satisfies_original_six_system": True}


def check_lean(certificate):
    lean = certificate["lean"]
    assert lean["required"] is True and lean["status"] == "success"
    assert lean["theorem"] == "TenLabel.no_nonempty_good_family"
    source = ROOT / lean["source"]
    fidelity = ROOT / lean["statement_fidelity"]
    result = json.loads((ROOT / lean["result_file"]).read_text())
    assert result["status"] == "success"
    assert result["exit_code"] == 0 and result["audit_exit_code"] == 0
    assert result["proof_holes"] == []
    assert result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,")
    assert source.read_text() == lean_source(), "Lean source differs from the exact model generator"
    assert hashlib.sha256(source.read_bytes()).hexdigest() == result["source_sha256"]
    assert hashlib.sha256(fidelity.read_text().encode()).hexdigest() == result["statement_fidelity_sha256"]
    assert "sorryAx" not in result["stdout"]
    assert Path(result["source"]).resolve() == source.resolve()
    return {"status": "success", "lean_version": "4.31.0", "exit_code": 0,
            "audit_exit_code": 0, "proof_holes": []}


def verify_certificate():
    from formal import replay as replay_formal, replay_core

    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    assert certificate["claim_id"] == "C9000156_COMB"
    assert certificate["continuum_projector_theorem_verified"] is False
    formal = check_lean(certificate)
    assert check_encoding_gates() == certificate["encoding"]
    assert check_local_systems() == certificate["local_systems"]
    assert check_jacobian() == certificate["jacobian"]
    replay = replay_refutation()
    expected = {key: value for key, value in certificate["refutation"].items()
                if key not in ("file", "format")}
    assert certificate["refutation"]["file"] == "refutation.drat"
    assert replay == expected
    expected_formal = {key: value for key, value in certificate["formal_refutation"].items()
                       if key not in ("file", "format")}
    assert certificate["formal_refutation"]["file"] == "formal_refutation_trimmed.lrat"
    assert replay_formal() == expected_formal
    core = certificate["kernel_refutation"]
    assert core["file"] == "core_refutation.lrat" and core["indices_file"] == "core_indices.json"
    expected_core = {key: value for key, value in core.items()
                     if key not in ("file", "indices_file", "format")}
    assert replay_core() == expected_core
    print(json.dumps({"claim_id": certificate["claim_id"],
                      "conclusion": "No nonempty family satisfies both finite conditions",
                      "rup": "verified", "formal_lrat": "verified",
                      "kernel_lrat": "verified", "lean": formal,
                      "independent_review": certificate["independent_review"]["status"],
                      "continuum_projector_theorem_verified": False}))


def lean_source():
    from formal import lean_source as generate

    return generate()


def main():
    if not __debug__:
        raise SystemExit("Verification requires assertions; do not run Python with -O.")
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument("--prepare", action="store_true")
    modes.add_argument("--search", action="store_true")
    modes.add_argument("--replay", action="store_true")
    modes.add_argument("--write-lean", action="store_true")
    args = parser.parse_args()
    if args.prepare:
        prepare()
    elif args.search:
        search()
    elif args.replay:
        replay_refutation()
    elif args.write_lean:
        (ROOT / "Main.lean").write_text(lean_source())
        print("Wrote the exact finite-model Lean source.")
    else:
        verify_certificate()


if __name__ == "__main__":
    main()
