#!/usr/bin/env python3
"""Replay exact degeneracy tests and the source-bound native Lean certificate."""

import argparse
from collections import defaultdict, deque
from dataclasses import dataclass
from itertools import combinations, product
import json
from pathlib import Path


BASE = Path(__file__).resolve().parent
PROJECT = BASE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def parity(value):
    return value.bit_count() & 1


def real(p):
    return (0, p, 0)


def internal(e, j):
    return (1, e, j)


def site(t, row, first, last):
    return ("site", row, t, first, last)


def square(e, k, row, first, last):
    return ("square", row, (e, k), first, last)


def subsets(items):
    items = tuple(sorted(items))
    for size in range(len(items) + 1):
        yield from (frozenset(s) for s in combinations(items, size))


@dataclass(frozen=True)
class Schema:
    source: int
    target: int
    left: int
    right: int
    c_left: int
    c_right: int
    domains: tuple
    maps: tuple


class Model:
    def __init__(self, m):
        self.m, self.r, self.n = m, 3, 16
        self.dimensions = (2, 3, 0)
        full = tuple(range(m))
        identity = tuple(full for _ in range(self.r))
        cyclic = tuple(tuple((a + 1) % m for a in full) for _ in range(self.r))
        self.schemas = (
            Schema(0, 1, 1, 2, 0, 0, ((0,), full, full), cyclic),
            Schema(0, 0, 0, 0, 1, 1, (full, full, full), identity),
            Schema(0, 0, 3, 1, 0, 0, (full, full, (0,)), identity),
            Schema(0, 1, 3, 4, 1, 0, (full, full, full), cyclic),
            Schema(2, 2, 0, 0, 0, 1, (full, (), full), identity),
            Schema(0, 0, 1, 1, 0, 1, (full, full, full), identity),
        )
        self.permutations = {}
        for e, s in enumerate(self.schemas):
            for i, domain in enumerate(s.domains):
                image = tuple(s.maps[i][a] for a in domain)
                require(len(set(image)) == len(domain), "Coordinate map is not injective")
                table = dict(zip(domain, image))
                unused_source = sorted(set(full) - set(domain))
                unused_target = sorted(set(full) - set(image))
                table.update(zip(unused_source, unused_target))
                self.permutations[e, i] = tuple(table[a] for a in full)

    def q(self, p, address):
        dimension = self.dimensions[p]
        base = (0,) + tuple(1 << j for j in range(dimension))
        translate = sum((i + 1) * a for i, a in enumerate(address)) % (1 << dimension)
        return frozenset(v ^ translate for v in base)

    def affine(self, e, side, value):
        s = self.schemas[e]
        form, constant = (s.left, s.c_left) if side == 0 else (s.right, s.c_right)
        return parity(form & value) ^ constant

    def check_consistency(self):
        comparisons = 0
        for e, s in enumerate(self.schemas):
            for address in product(range(self.m), repeat=self.r):
                if not all(a in s.domains[i] for i, a in enumerate(address)):
                    continue
                mapped = tuple(s.maps[i][a] for i, a in enumerate(address))
                left = {self.affine(e, 0, v) for v in self.q(s.source, address)}
                right = {self.affine(e, 1, v) for v in self.q(s.target, mapped)}
                require(left == right, f"Image consistency failed at {(e, address)}")
                comparisons += 1
        q = self.q(0, (0, 0, 0))
        require(any(x ^ y ^ z not in q for x, y, z in product(q, repeat=3)),
                "The non-affine witness test accidentally became affine")
        require(all(self.affine(5, 0, v) != self.affine(5, 1, v) for v in range(4)),
                "The opposite-form self-loop no longer obstructs every global assignment")
        return comparisons

    def dimension(self, t):
        return self.dimensions[t[1]] if t[0] == 0 else 1

    def endpoints(self, link):
        e, k = link
        s = self.schemas[e]
        return (real(s.source) if k == 0 else internal(e, k - 1),
                real(s.target) if k == self.n else internal(e, k))

    def linear(self, link, t, value):
        e, k = link
        s = self.schemas[e]
        if t[0] == 1:
            return value
        require((k == 0 and t == real(s.source)) or
                (k == self.n and t == real(s.target)), "Wrong real endpoint")
        return parity((s.left if k == 0 else s.right) & value)

    def labels(self, t, row):
        return tuple(range(self.m)) if t[0] == 0 else self.schemas[t[1]].domains[row]

    def readouts(self, block):
        kind, i, data, a, b = block
        j = (i + 1) % self.r
        if kind == "site":
            require(a in self.labels(data, i) and b in self.labels(data, j), "Invalid site")
            return ((0, i, data, a, b),)
        e, k = data
        s = self.schemas[e]
        require(a in s.domains[i] and b in s.domains[j], "Invalid square")
        t, u = self.endpoints(data)
        aa, bb = (s.maps[i][a], s.maps[j][b]) if k == self.n else (a, b)
        return ((0, i, t, a, b), (0, i, u, aa, bb),
                (1, i, data, a), (1, j, data, b))

    def edge(self, name):
        if name[0] == 0:
            _, i, t, a, b = name
            return (i, t, a), ((i + 1) % self.r, t, b), int(i == self.r - 1)
        _, i, link, a = name
        e, k = link
        t, u = self.endpoints(link)
        b = self.schemas[e].maps[i][a] if k == self.n else a
        return (i, t, a), (i, u, b), 0

    def components(self, blocks):
        names = {a for b in blocks for a in self.readouts(b)}
        adjacency = defaultdict(list)
        for a in names:
            v, w, mark = self.edge(a)
            adjacency[v].append((w, mark))
            adjacency[w].append((v, mark))
        remaining = set(adjacency)
        result = []
        while remaining:
            root = min(remaining)
            potential, queue, wraps = {root: 0}, deque([root]), False
            while queue:
                v = queue.popleft()
                for w, mark in adjacency[v]:
                    expected = potential[v] ^ mark
                    if w not in potential:
                        potential[w] = expected
                        queue.append(w)
                    elif potential[w] != expected:
                        wraps = True
            corners = frozenset(potential)
            remaining.difference_update(corners)
            members = frozenset(b for b in blocks if self.edge(self.readouts(b)[0])[0] in corners)
            used = frozenset(a for a in names if self.edge(a)[0] in corners)
            result.append((corners, members, used, wraps))
        return result

    def aligned(self, t, i, a, cut):
        return a if t[0] == 0 or t[2] < cut[t[1]] else self.permutations[t[1], i][a]

    def address_at(self, t, address, cut):
        if t[0] == 0 or t[2] < cut[t[1]]:
            return address
        return tuple(self.permutations[t[1], i].index(a) for i, a in enumerate(address))

    def recovered(self, blocks, cut):
        addresses = set()
        for chosen in combinations(sorted(blocks), self.r):
            if not any(c[3] for c in self.components(chosen)):
                continue
            require({b[1] for b in chosen} == set(range(self.r)), "Wrapping missed a row")
            address = [None] * self.r
            for b in chosen:
                _, i, data, a, _ = b
                t = data if b[0] == "site" else self.endpoints(data)[0]
                address[i] = self.aligned(t, i, a, cut)
            address = tuple(address)
            for b in chosen:
                _, i, data, a, last = b
                t = data if b[0] == "site" else self.endpoints(data)[0]
                require(self.aligned(t, (i + 1) % self.r, last, cut) ==
                        address[(i + 1) % self.r], "Recovered address is incoherent")
            addresses.add(address)
        require(len(addresses) <= 1, "Different r-block witnesses recovered different addresses")
        return next(iter(addresses)) if addresses else None

    def shifts(self, types, address, cut):
        reals = [t for t in types if t[0] == 0]
        require(len(reals) <= 1, "A small component reached two real types")
        if reals:
            t = reals[0]
            p = t[1]
            parameters = self.q(p, address) if address is not None else range(1 << self.dimension(t))
            for v in parameters:
                h = {t: v}
                for u in types - {t}:
                    e, j = u[1:]
                    s = self.schemas[e]
                    side = int(j >= cut[e])
                    require((s.source if side == 0 else s.target) == p, "Wrong arm owner")
                    h[u] = self.affine(e, side, v)
                yield h
        else:
            t = min(types)
            e = t[1]
            require(all(u[1] == e for u in types), "A real-free support left its wire")
            if address is None:
                parameters = (0, 1)
            else:
                a = self.address_at(t, address, cut)
                s = self.schemas[e]
                require(all(x in s.domains[i] for i, x in enumerate(a)),
                        "A recovered internal address is outside the wire domain")
                parameters = {self.affine(e, 0, v) for v in self.q(s.source, a)}
            for value in parameters:
                yield dict.fromkeys(types, value)

    def family(self, blocks):
        names = tuple(sorted({a for b in blocks for a in self.readouts(b)}))
        positions, width = {}, 0
        for a in names:
            bits = self.dimension(a[2]) if a[0] == 0 else 1
            positions[a] = (width, bits)
            width += bits
        used_links = {b[2] for b in blocks if b[0] == "square"}
        cut = tuple(next(k for k in range(self.n + 1) if (e, k) not in used_links)
                    for e in range(len(self.schemas)))
        family, wrapping, addressed = {0}, 0, 0
        for corners, members, used, wraps in self.components(blocks):
            types = {v[1] for v in corners}
            links = {b[2] for b in members if b[0] == "square"}
            require(len(links) == len(types) - 1, "The connected support is not a tree")
            require(not wraps or len(members) >= self.r, "Wrapping used fewer than r blocks")
            address = self.recovered(members, cut)
            wrapping += int(wraps)
            addressed += int(address is not None)
            basis = {}
            for corner in sorted(corners):
                for bit in range(self.dimension(corner[1])):
                    column = 0
                    for a in used:
                        v, w, _ = self.edge(a)
                        if corner not in (v, w):
                            continue
                        value = (1 << bit) if a[0] == 0 else self.linear(a[2], corner[1], 1 << bit)
                        column ^= value << positions[a][0]
                    while column:
                        pivot = column.bit_length() - 1
                        if pivot not in basis:
                            basis[pivot] = column
                            break
                        column ^= basis[pivot]
            span = {0}
            for column in basis.values():
                span |= {v ^ column for v in span}
            constants = set()
            for h in self.shifts(types, address, cut):
                for e, k in links:
                    t, u = self.endpoints((e, k))
                    s = self.schemas[e]
                    rhs = (s.c_left if k == 0 else 0) ^ (s.c_right if k == self.n else 0)
                    require(self.linear((e, k), t, h[t]) ^ self.linear((e, k), u, h[u]) == rhs,
                            "An enumerated shift violates its link equation")
                constants.add(sum(h[a[2]] << positions[a][0]
                                  for a in used if a[0] == 0 and a[1] == self.r - 1))
            local = {v ^ c for v in span for c in constants}
            family = {old ^ new for old in family for new in local}
            require(len(family) <= 1 << 18, "Declared finite test work bound exceeded")
        require(family, "An admissible family is empty")
        for value in family:
            for b in blocks:
                if b[0] != "square":
                    continue
                xt, xu, yi, yj = self.readouts(b)
                read = lambda a: (value >> positions[a][0]) & ((1 << positions[a][1]) - 1)
                e, k = b[2]
                t, u = self.endpoints((e, k))
                s = self.schemas[e]
                lhs = self.linear((e, k), t, read(xt)) ^ self.linear((e, k), u, read(xu))
                lhs ^= read(yi) ^ read(yj)
                rhs = int(b[1] == self.r - 1) * (
                    (s.c_left if k == 0 else 0) ^ (s.c_right if k == self.n else 0))
                require(lhs == rhs, "An enumerated offset is not a legal affine valuation")
        return positions, family, {"wrapping_components": wrapping, "addressed_components": addressed}

    def cases(self):
        def ring(t, address):
            return [site(t, i, address[i], address[(i + 1) % self.r]) for i in range(self.r)]

        a = (0, 0, 0)
        yield "first_endpoint_lift", ring(internal(0, 0), a) + [square(0, 0, 0, 0, 0)]
        yield "last_endpoint_partial_lift", ring(internal(0, self.n - 1), a) + [
            square(0, self.n, 0, 0, 0)]
        yield "zero_endpoint_lift", ring(internal(1, 0), a) + [square(1, 0, 2, 0, 0)]
        yield "loop_second_occurrence", ring(internal(2, self.n - 1), a) + [
            square(2, self.n, 2, 0, 0)]
        yield "unavailable_arm_address", ring(real(0), (0, 0, self.m - 1)) + [
            square(2, 0, 0, 0, 0)]
        t, u = internal(1, 1), internal(1, 2)
        yield "first_wrap_at_four", [
            site(t, 0, 0, 0), square(1, 2, 1, 0, 0),
            site(u, 2, 0, 0), square(1, 2, 0, 0, 1)]
        yield "merged_distinct_old_shifts", [
            site(real(0), 2, 0, 0), site(real(0), 1, 1, 1), site(real(0), 0, 0, 1)]
        yield "parallel_and_loop_arms", [
            square(0, 0, 0, 0, 0), square(3, 0, 1, 0, 0),
            site(real(0), 2, 0, 0), square(1, 0, 2, 0, 0)]
        yield "empty_domain_zero_dimension", [
            square(4, 0, 2, 0, 0), square(4, 1, 2, 0, 0),
            square(4, self.n, 2, 0, 0), site(internal(4, self.n - 1), 2, 0, 0)]
        yield "globally_inconsistent_loop", ring(internal(5, self.n - 1), a) + [
            square(5, self.n, 2, 0, 0)]


def finite_experiments():
    results = []
    for m in (2, 3):
        model = Model(m)
        comparisons = model.check_consistency()
        for label, blocks in model.cases():
            full = frozenset(blocks)
            families = {u: model.family(u) for u in subsets(full)}
            restrictions, retained_lists = 0, 0
            for u, (source_positions, source_family, _) in families.items():
                for v in subsets(u):
                    target_positions, target_family, _ = families[v]
                    image = set()
                    for value in source_family:
                        projected = 0
                        for name, (target_start, bits) in target_positions.items():
                            source_start = source_positions[name][0]
                            projected |= ((value >> source_start) & ((1 << bits) - 1)) << target_start
                        image.add(projected)
                    require(image == target_family,
                            f"Exact restriction failed: m={m}, case={label}, U={u}, V={v}")
                    restrictions += 1
                    retained_lists += len(target_family)
            if label == "first_wrap_at_four":
                require(families[full][2] == {"wrapping_components": 1, "addressed_components": 0},
                        "The first-wrapping test does not have the claimed topology")
                require(all(not c[3] for u in subsets(full) if len(u) == 3
                            for c in model.components(u)), "A retained triple already wraps")
            if label == "merged_distinct_old_shifts":
                old = frozenset(blocks[:2])
                require(len(model.components(old)) == 2 and len(model.components(full)) == 1,
                        "The merger test does not actually merge old corner components")
            results.append({
                "case": label, "alphabet_size": m, "r": model.r, "wire_internal_types": model.n,
                "real_dimensions": list(model.dimensions), "consistent_comparisons": comparisons,
                "full_block_count": len(full), "full_family_size": len(families[full][1]),
                "restriction_equalities": restrictions, "retained_list_obligations": retained_lists,
                **families[full][2],
            })
    return results


def replay_jacobian():
    payload = json.loads((BASE / "jacobian_payload.json").read_text())
    envelope = json.loads((BASE / "jacobian_result.json").read_text())
    result = envelope["result"]["output"]
    require(envelope["result"]["operation_id"] == "sat.solve", "Wrong Jacobian operation")
    require(result["source"] == payload, "Jacobian result is bound to another request")
    require(result["outcome"] == "SAT" and result["assignment"] is not None,
            "The Jacobian result is a non-conclusion, not a finite witness")
    clauses = payload["cnf"]["clauses"]

    def cnf(assignment):
        return all(any(assignment[abs(lit) - 1] == (lit > 0) for lit in c) for c in clauses)

    satisfying = []
    for assignment in product((False, True), repeat=6):
        h, p, q, a, b, c = assignment
        intended = h and not (p and q) and h == (p ^ q)
        intended = intended and (a ^ b) and not (b ^ c) and not (c ^ a ^ h)
        require(cnf(assignment) == intended, "CNF is not the stated retained-ring extension predicate")
        if intended:
            satisfying.append(assignment)
    require(cnf(result["assignment"]), "Jacobian's assignment does not satisfy its exact CNF")
    require(tuple(result["assignment"]) in satisfying, "Assignment failed the mathematical predicate")
    initial = json.loads((BASE / "jacobian_initial_result.json").read_text())
    require(initial["error"]["data"]["code"] == "INVALID_REQUEST",
            "The initial adapter error was not preserved faithfully")
    return {
        "operation_id": "sat.solve", "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"], "adapter_exit_code": 0,
        "outcome": result["outcome"], "assignment": result["assignment"],
        "all_assignments_replayed": 64, "satisfying_assignments": len(satisfying),
        "payload": "jacobian_payload.json", "typed_output": "jacobian_result.json",
        "initial_attempt": {"adapter_exit_code": 2, "status": "INVALID_REQUEST",
                            "mathematical_conclusion": "none",
                            "payload": "jacobian_initial_payload.json",
                            "typed_error": "jacobian_initial_result.json"},
    }


def replay_native_certificate():
    result = json.loads((BASE / "kernel_result.json").read_text())
    record = result["kernel"]["recorded"]
    require(record["subject"]["subject_id"] == "EP", "Certificate belongs to another claim")
    require(record["verdict"] == "supports" and record["tier"] == "mechanical",
            "Native proof was not mechanically certified")
    archive = json.loads((PROJECT / record["artifact"]).read_text())
    require(archive["subject"] == record["subject"], "Native claim binding changed")
    require(archive["lean_source"]["text"] == (BASE / "Main.lean").read_text(),
            "Lean source changed after compilation")
    require(archive["statement_fidelity"]["text"] ==
            (BASE / "statement_fidelity.md").read_text(), "Statement fidelity changed after compilation")
    check = archive["lean_check"]
    require(check["status"] == "success" and check["exit_code"] == 0, "Lean compilation did not succeed")
    require(check["proof_holes"] == [] and check["audit_exit_code"] == 0,
            "Lean proof-hole or axiom audit did not pass")
    version = check["tools"]["lean"]["version"]
    require("version 4.31.0," in version, "The proof used another Lean version")
    require("sorryAx" not in check["stdout"], "The exported theorem depends on an admitted proof")
    return {
        "claim": "EP", "result_class": "universal_formal_verification",
        "status": "success", "exit_code": 0, "proof_holes": [], "axiom_audit_exit_code": 0,
        "lean_version": version, "certificate": record["artifact"],
        "declarations": [
            "ProjectionAudit.VariableWL.Blocks.full_projection_certificate",
            "ProjectionAudit.VariableWL.Blocks.manuscript_projection_certificate"],
        "source": "Main.lean", "statement_fidelity": "statement_fidelity.md",
        "independent_statement_fidelity_review": "pending",
        "recompile_command": (
            "$WORKSPACE/argus-live-update/.venv/bin/python -m "
            "argus_skill.verticals.math.lean_evidence verify research/exact_projection/Main.lean "
            "--statement-fidelity research/exact_projection/statement_fidelity.md "
            "--claim EP --project-root ."),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    cases = finite_experiments()
    certificate = {
        "claim": "EP", "outcome": "universal_exact_projection_verified_pending_independent_review",
        "universal_proof": replay_native_certificate(),
        "jacobian_finite_witness": replay_jacobian(),
        "finite_experiment": {
            "classification": "finite_verification_not_a_universal_proof",
            "globally_unsatisfiable_but_image_consistent": True,
            "global_obstruction": "Schema 5 compares the same scalar form with its complement at the same real address.",
            "case_count": len(cases),
            "restriction_equalities": sum(c["restriction_equalities"] for c in cases),
            "retained_list_obligations": sum(c["retained_list_obligations"] for c in cases),
            "cases": cases,
        },
        "manuscript_refutations": [],
        "complexity_theorems_verified": False,
        "mathematical_novelty": "independent_assessment_required",
    }
    path = BASE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    require(json.loads(path.read_text()) == certificate, "Exact certificate differs from replay")
    print(json.dumps({
        "outcome": certificate["outcome"],
        "lean_exit_code": certificate["universal_proof"]["exit_code"],
        "proof_holes": certificate["universal_proof"]["proof_holes"],
        "finite_cases": len(cases),
        "restriction_equalities": certificate["finite_experiment"]["restriction_equalities"],
        "retained_list_obligations": certificate["finite_experiment"]["retained_list_obligations"],
        "jacobian_outcome": certificate["jacobian_finite_witness"]["outcome"],
    }, indent=2))


if __name__ == "__main__":
    main()
