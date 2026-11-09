#!/usr/bin/env python3
"""Replay the exact diagnostics and the arbitrary-degree Lean nesting proof."""

import argparse
from dataclasses import dataclass
import hashlib
import itertools
import json
from pathlib import Path
import random
import re
import shutil
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
DECLARATIONS = (
    "NestedLoss.Diagram.absorption",
    "NestedLoss.Diagram.through_absorption",
    "NestedLoss.Diagram.rectangle_factor",
    "NestedLoss.Diagram.signed_containment",
    "NestedLoss.Diagram.nested_chain_bound",
)


def identity(m):
    return sum(1 << (i * m + i) for i in range(m))


def compose(a, b, m):
    result = 0
    mask = (1 << m) - 1
    for i in range(m):
        row = (a >> (i * m)) & mask
        out = 0
        while row:
            bit = row & -row
            row -= bit
            out |= (b >> ((bit.bit_length() - 1) * m)) & mask
        result |= out << (i * m)
    return result


def star(a, m):
    a |= identity(m)
    for k in range(m):
        row = (a >> (k * m)) & ((1 << m) - 1)
        for i in range(m):
            if a & (1 << (i * m + k)):
                a |= row << (i * m)
    return a


def product(*relations, m):
    result = identity(m)
    for relation in relations:
        result = compose(result, relation, m)
    return result


@dataclass(frozen=True)
class Diagram:
    m: int
    F: int
    B: int
    L: int
    R: int

    def reflected(self):
        return Diagram(self.m, self.B, self.F, self.R, self.L)

    def multiply(self, other):
        assert self.m == other.m
        m = self.m
        join = star(compose(other.L, self.R, m), m)
        back_join = star(compose(self.R, other.L, m), m)
        return Diagram(
            m,
            product(self.F, join, other.F, m=m),
            product(other.B, back_join, self.B, m=m),
            self.L | product(self.F, join, other.L, self.B, m=m),
            other.R | product(other.B, self.R, join, other.F, m=m),
        )

    def paths_multiply(self, other):
        """Explore actual entry nodes; stop at the first exterior exit."""
        assert self.m == other.m
        factors = (self, other)
        m = self.m
        answer = [0, 0, 0, 0]
        for entry_sign in (0, 1):
            for label in range(m):
                initial = (entry_sign, entry_sign, label)
                seen = {initial}
                todo = [initial]
                while todo:
                    factor, sign, point = todo.pop()
                    diagram = factors[factor]
                    edges = ((0, diagram.F), (1, diagram.L)) if sign == 0 else (
                        (0, diagram.R), (1, diagram.B)
                    )
                    for exit_sign, relation in edges:
                        for target in range(m):
                            if not relation & (1 << (point * m + target)):
                                continue
                            next_factor = factor + (1 if exit_sign == 0 else -1)
                            if next_factor not in (0, 1):
                                component = ((0, 2), (3, 1))[entry_sign][exit_sign]
                                answer[component] |= 1 << (label * m + target)
                            else:
                                node = (next_factor, exit_sign, target)
                                if node not in seen:
                                    seen.add(node)
                                    todo.append(node)
        return Diagram(m, *answer)

    def idempotent_power(self):
        power = self
        seen = set()
        while power not in seen:
            if power.multiply(power) == power:
                return power
            seen.add(power)
            power = power.multiply(self)
        raise AssertionError("A finite semigroup power cycle had no idempotent")

    def positive_data(self):
        k = star(compose(self.L, self.R, self.m), self.m)
        return k, product(k, self.F, k, m=self.m)

    def signed_classes(self):
        result = []
        for sign, diagram in (("+", self), ("-", self.reflected())):
            _, p = diagram.positive_data()
            remaining = {i for i in range(self.m) if edge(p, i, i, self.m)}
            while remaining:
                point = min(remaining)
                cls = frozenset(
                    j for j in remaining
                    if edge(p, point, j, self.m) and edge(p, j, point, self.m)
                )
                assert cls
                result.append((sign, cls))
                remaining -= cls
        return frozenset(result)

    def missing(self, other):
        answer = set()
        for sign, cls in self.signed_classes():
            e, z = (self, other) if sign == "+" else (
                self.reflected(), other.reflected()
            )
            k, _ = e.positive_data()
            u = product(k, z.F, k, m=self.m)
            loops = {edge(u, point, point, self.m) for point in cls}
            assert len(loops) == 1, "Missingness not constant on a corner class"
            if loops == {False}:
                answer.add((sign, cls))
        return frozenset(answer)


def edge(relation, x, y, m):
    return bool(relation & (1 << (x * m + y)))


def included(a, b):
    return a & b == a


def check_pair(e, d):
    assert e.multiply(e) == e and d.multiply(d) == d
    assert e.paths_multiply(e) == e and d.paths_multiply(d) == d
    assert e.multiply(d) == d and d.multiply(e) == d
    assert e.paths_multiply(d) == d and d.paths_multiply(e) == d
    for old, new in ((e, d), (e.reflected(), d.reflected())):
        m = e.m
        ke, pe = old.positive_data()
        kd, pd = new.positive_data()
        assert included(ke, kd)
        for lhs in (
            compose(pe, pd, m), compose(pd, pe, m),
            compose(old.F, pd, m), compose(pd, old.F, m),
        ):
            assert included(lhs, pd), ("absorption", e, d, lhs, pd)
    old_classes = e.signed_classes()
    missing = e.missing(d)
    for sign, cls in d.signed_classes():
        contained = {
            (s, c) for s, c in old_classes if s == sign and c <= cls
        }
        assert contained - missing or len(contained) >= 2, (
            "containment", e, d, sign, cls, contained, missing
        )


def all_diagrams(m):
    bound = 1 << (m * m)
    return (Diagram(m, *bits) for bits in itertools.product(range(bound), repeat=4))


def t1_payload():
    diagrams = list(all_diagrams(1))
    labels = [str(i) for i in range(len(diagrams))]
    indices = {diagram: labels[i] for i, diagram in enumerate(diagrams)}
    table = []
    for a in diagrams:
        row = []
        for b in diagrams:
            formula = a.multiply(b)
            assert formula == a.paths_multiply(b)
            row.append(indices[formula])
        table.append(row)
    return {"semigroup": {"elements": labels, "multiplication": table}}


def encoded_classes(classes):
    return [
        {"sign": sign, "labels": sorted(cls)}
        for sign, cls in sorted(classes, key=lambda c: (c[0], sorted(c[1])))
    ]


def merging_example():
    e = Diagram(2, 9, 1, 0, 0)
    d = Diagram(2, 2, 1, 5, 3)
    z = Diagram(2, 0, 1, 5, 3)
    check_pair(e, d)
    check_pair(d, z)
    j0 = e.missing(d) | e.missing(z)
    losses = [len(e.missing(d)), len(d.missing(z))]
    assert j0 == frozenset({("+", frozenset({0})), ("+", frozenset({1}))})
    assert losses == [2, 1]
    assert sum(losses) <= 2 * len(j0)
    assert ("+", frozenset({0, 1})) in d.signed_classes()
    return {
        "classification": "exact_construction_not_a_counterexample",
        "degree": 2,
        "encoding": "bit i*m+j is the edge (i,j); fields are F,B,L,R",
        "chain": [[a.F, a.B, a.L, a.R] for a in (e, d, z)],
        "signed_classes": [encoded_classes(a.signed_classes()) for a in (e, d, z)],
        "initial_budget": encoded_classes(j0),
        "successive_missing": [encoded_classes(a.missing(b)) for a, b in ((e, d), (d, z))],
        "successive_losses": losses,
        "total_loss": sum(losses),
        "bound": 2 * len(j0),
    }


def diagnostics():
    diagrams = list(all_diagrams(1))
    idempotents = [d for d in diagrams if d.multiply(d) == d]
    nested_pairs = 0
    for e, d in itertools.product(idempotents, repeat=2):
        if e.multiply(d) == d and d.multiply(e) == d:
            check_pair(e, d)
            nested_pairs += 1
    rng = random.Random(129)
    chain_count = 0
    tested_pairs = nested_pairs
    for m in (2, 3):
        bound = 1 << (m * m)
        for _ in range(400):
            current = Diagram(m, *(rng.randrange(bound) for _ in range(4)))
            current = current.idempotent_power()
            chain = [current]
            for _ in range(5):
                a = Diagram(m, *(rng.randrange(bound) for _ in range(4)))
                sandwich = current.multiply(a).multiply(current)
                current = sandwich.idempotent_power()
                check_pair(chain[-1], current)
                tested_pairs += 1
                chain.append(current)
            j0 = frozenset().union(*(chain[0].missing(d) for d in chain))
            losses = [len(e.missing(d)) for e, d in zip(chain, chain[1:])]
            assert sum(losses) <= 2 * len(j0), ("chain", chain, losses, j0)
            chain_count += 1
    return {
        "classification": "finite_diagnostic_only",
        "degree_one_diagrams": len(diagrams),
        "degree_one_idempotents": len(idempotents),
        "degree_one_nested_pairs": nested_pairs,
        "nested_pairs_checked": tested_pairs + 2,
        "sampled_chains": chain_count,
        "sampled_degrees": [2, 3],
        "counterexample_found": False,
        "composition_replay": "independent first-exterior-exit reachability",
        "merge_then_delete": merging_example(),
    }


def jacobian_replay():
    payload = json.loads((HERE / "jacobian/payload.json").read_text())
    contract = json.loads((HERE / "jacobian/contract.json").read_text())
    output = json.loads((HERE / "jacobian/output.json").read_text())
    operation = "semigroup.idempotents.compute"
    assert payload == t1_payload(), "The submitted Cayley table must match actual finite paths"
    assert contract["result"]["operation"]["operation_id"] == operation
    assert output["request"]["operation_id"] == operation
    assert output["request"]["payload"] == payload
    assert output["result"]["operation_id"] == operation
    assert output["result"]["output"]["semigroup"] == payload["semigroup"]
    assert output["result"]["output"]["idempotents"] == payload["semigroup"]["elements"]
    return {
        "operation_id": operation,
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "adapter_status": "success",
        "idempotents": 16,
        "contract": "jacobian/contract.json",
        "payload": "jacobian/payload.json",
        "typed_output": "jacobian/output.json",
    }


def axiom_audit(stdout):
    found = {}
    for name, axioms in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", stdout):
        found[name] = sorted(a.strip() for a in axioms.split(",") if a.strip())
    assert set(found) == set(DECLARATIONS), "Missing or unexpected declaration audit"
    allowed = {"propext", "Classical.choice", "Quot.sound"}
    assert all(set(axioms) <= allowed for axioms in found.values()), found
    return found


def formal_evidence():
    official = json.loads((HERE / "official_verify.json").read_text())
    assert official["kernel"]["refusals"] == []
    record = official["kernel"]["recorded"]
    assert record["subject"]["subject_id"] == "C_NEST_CHAIN"
    assert record["tier"] == "mechanical" and record["verdict"] == "supports"
    archive_path = ROOT / record["artifact"]
    assert archive_path.parent == HERE / "certificates"
    archive = json.loads(archive_path.read_text())
    result = archive["lean_check"]
    for field in (
        "status", "exit_code", "proof_holes", "audit_exit_code",
        "source_sha256", "statement_fidelity_sha256",
    ):
        assert official[field] == result[field], field
    assert result["status"] == "success" and result["exit_code"] == 0
    assert result["proof_holes"] == [] and result["audit_exit_code"] == 0
    assert result["environment_failure"] == ""
    version = result["tools"]["lean"]["version"]
    assert "version 4.31.0," in version, version
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    assert hashlib.sha256(source).hexdigest() == result["source_sha256"]
    assert hashlib.sha256(fidelity.encode()).hexdigest() == result["statement_fidelity_sha256"]
    assert archive["lean_source"]["text"].encode() == source
    assert archive["statement_fidelity"]["text"] == fidelity
    assert archive["subject"] == record["subject"]
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max(
        (c for c in state["claims"] if c["claim_id"] == "C_NEST_CHAIN"),
        key=lambda c: c["version"],
    )
    assert claim["content_hash"] == record["subject"]["content_hash"]
    assert claim["external_assumptions"] == [], "The verification must be unconditional"
    return result, {
        "claim": "C_NEST_CHAIN",
        "lean_version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "archived_certificate": record["artifact"],
        "axioms": axiom_audit(result["stdout"]),
        "scope": "arbitrary finite degree and arbitrary finite chain length",
        "manuscript_specific_lemmas_assumed": [],
    }


def replay_lean(result):
    lake = shutil.which("lake")
    if lake is None:
        raise RuntimeError("Independent Lean replay requires Lake and Lean 4.31.0")
    workspace = Path(result["lake_workspace"])
    if not workspace.is_dir():
        raise RuntimeError(f"The recorded Mathlib workspace is unavailable: {workspace}")
    version = subprocess.run(
        [lake, "env", "lean", "--version"], cwd=workspace,
        capture_output=True, text=True, timeout=30, check=True,
    )
    assert "version 4.31.0," in version.stdout, version.stdout
    replay = subprocess.run(
        [lake, "env", "lean", str(HERE / "Main.lean")], cwd=workspace,
        capture_output=True, text=True, timeout=100, check=False,
    )
    if replay.returncode:
        raise RuntimeError(f"Lean replay failed:\n{replay.stdout}\n{replay.stderr}")
    assert axiom_audit(replay.stdout) == axiom_audit(result["stdout"])
    assert hashlib.sha256((HERE / "Main.lean").read_bytes()).hexdigest() == result["source_sha256"]
    assert hashlib.sha256((HERE / "statement_fidelity.md").read_text().encode()).hexdigest() == result["statement_fidelity_sha256"]


def main():
    if not __debug__:
        raise RuntimeError("Run without Python optimization: the exact checks use assertions")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jacobian-payload", type=Path)
    parser.add_argument("--diagnostics", action="store_true")
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument(
        "--package-recorded-evidence", action="store_true",
        help="Package the genuine official compiler run without recompiling; requires --write-certificate",
    )
    args = parser.parse_args()
    if args.package_recorded_evidence and not args.write_certificate:
        parser.error("--package-recorded-evidence requires --write-certificate")
    if args.jacobian_payload:
        args.jacobian_payload.write_text(json.dumps(t1_payload(), indent=2) + "\n")
    if args.diagnostics:
        print(json.dumps(diagnostics(), indent=2))
        return
    if args.jacobian_payload:
        return
    finite = diagnostics()
    jacobian = jacobian_replay()
    result, formal = formal_evidence()
    if not args.package_recorded_evidence:
        replay_lean(result)
    certificate = {
        "classification": "formal_verification",
        "statement": "For arbitrary nested idempotent finite path diagrams, sum of successive missing-class counts is at most twice one initial missing-class budget.",
        "formal": formal,
        "finite_diagnostics": finite,
        "jacobian": jacobian,
        "counterexample_found": False,
        "entire_manuscript_lower_bounds_certified": False,
    }
    if args.write_certificate:
        (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
        (HERE / "finite_diagnostics.json").write_text(json.dumps(finite, indent=2) + "\n")
    else:
        expected = json.loads((HERE / "exact_certificate.json").read_text())
        assert certificate == expected, "The replay does not match exact_certificate.json"
    print(json.dumps({
        "status": "pass",
        "classification": certificate["classification"],
        "claim": formal["claim"],
        "lean_version": formal["lean_version"],
        "proof_holes": formal["proof_holes"],
        "live_lean_replay": not args.package_recorded_evidence,
        "nested_pairs_checked": finite["nested_pairs_checked"],
        "sampled_chains": finite["sampled_chains"],
        "merge_then_delete_losses": finite["merge_then_delete"]["successive_losses"],
        "jacobian_adapter_status": jacobian["adapter_status"],
    }, indent=2))


if __name__ == "__main__":
    main()
