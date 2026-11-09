#!/usr/bin/env python3
"""Replay the source schedule; finite diagnostics are not a universal proof."""

import argparse
import itertools
import json
import random
import subprocess
from dataclasses import dataclass
from functools import cache
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"


@dataclass(frozen=True)
class Field:
    modulus: int

    @property
    def size(self):
        return 1 << (self.modulus.bit_length() - 1)

    def mul(self, a, b):
        result = 0
        while b:
            if b & 1:
                result ^= a
            b >>= 1
            a <<= 1
            if a & self.size:
                a ^= self.modulus
        return result

    def inverse(self, a):
        assert a != 0
        for b in range(1, self.size):
            if self.mul(a, b) == 1:
                return b
        raise AssertionError("The chosen modulus does not define a field")

    @cache
    def stencil(self, degree):
        assert 0 <= degree < self.size
        samples = tuple(range(degree + 1))
        weights = []
        for s in samples:
            product = 1
            for u in samples:
                if s != u:
                    product = self.mul(product, s ^ u)
            weights.append(self.inverse(product))
        return tuple(zip(samples, weights))


@dataclass(frozen=True)
class Word:
    name: str
    kind: str
    bits: tuple = ()
    deps: tuple = ()
    function: object = None
    g: int = 0
    outputs: tuple = ()
    predicates: tuple = ()


@cache
def semantic(word):
    if word.kind == "base":
        return word.bits
    if word.kind == "ordinary":
        return word.function(tuple(semantic(u) for u in word.deps))
    h, *arrays = (semantic(u) for u in word.deps)
    passing = [
        y for y in range(1 << word.g)
        if all(word.predicates[y][i](h, a) for i, a in enumerate(arrays))
    ]
    assert len(passing) == 1
    return word.outputs[passing[0]]((h,))


@cache
def path_weight(word):
    if word.kind == "base":
        return 0
    if word.kind == "ordinary":
        return max(1 + path_weight(u) for u in word.deps)
    h, *arrays = word.deps
    return max(
        [1 + path_weight(h)]
        + [word.g + 1 + path_weight(a) for a in arrays]
    )


class Evaluator:
    def __init__(self, field, d, p=3):
        self.field, self.d, self.p = field, d, p
        self.calls = self.lookups = self.zero_augmentations = 0
        self.suspended = self.peak = 0
        self.borrowed_ancestor_slots = 0
        self.ancestors = []

    def basis(self, bits, vector):
        result = 1
        for i, bit in enumerate(bits):
            result = self.field.mul(
                result, vector[i] if bit else vector[-1] ^ vector[i]
            )
        return result

    def lookup(self, function, args, coordinate, augmented=True):
        self.lookups += 1
        self.zero_augmentations += any(a[-1] == 0 for a in args)
        result = 0
        for bits in itertools.product((0, 1), repeat=self.d * len(args)):
            words = tuple(
                bits[j * self.d:(j + 1) * self.d] for j in range(len(args))
            )
            value = (
                1 if augmented and coordinate == self.d
                else function(words)[coordinate] if augmented
                else function(*words)
            )
            if value:
                product = 1
                for u, vector in zip(words, args):
                    product = self.field.mul(product, self.basis(u, vector))
                result ^= product
        return result

    def call(self, word, scalar, target, pool, frame):
        self.suspended += frame
        self.add(word, scalar, target, pool)
        self.suspended -= frame

    def add(self, word, scalar, target, pool):
        # This interpreter never calls semantic() or reads nonbase true values.
        self.calls += 1
        self.peak = max(self.peak, self.suspended + 2 * (self.d + 1))
        slots = [q for q in range(self.p) if q != target]
        self.borrowed_ancestor_slots += sum(
            q in ancestor for ancestor in self.ancestors for q in slots
        )
        self.ancestors.append(tuple(range(self.p)))
        try:
            if word.kind == "base":
                assert len(word.bits) == self.d
                for z, bit in enumerate(word.bits + (1,)):
                    pool[target][z] ^= self.field.mul(scalar, bit)
                return
            if word.kind == "ordinary":
                assert 1 <= len(word.deps) < self.p

                def nest(j, coefficient):
                    if j == len(word.deps):
                        args = [pool[slots[i]] for i in range(len(word.deps))]
                        for z in range(self.d + 1):
                            value = self.lookup(word.function, args, z)
                            pool[target][z] ^= self.field.mul(coefficient, value)
                        return
                    for s, weight in self.field.stencil(self.d):
                        self.call(word.deps[j], s, slots[j], pool, 1)
                        nest(j + 1, self.field.mul(coefficient, weight))
                        self.call(word.deps[j], s, slots[j], pool, 1)

                nest(0, scalar)
                return
            assert word.kind == "history" and 0 <= word.g <= self.d
            h, *arrays = word.deps
            qh, qa = slots[:2]
            degree = (len(arrays) + 1) * self.d
            for s, weight in self.field.stencil(degree):
                self.call(h, s, qh, pool, 1)
                for z in range(self.d + 1):
                    for y in range(1 << word.g):
                        u = self.lookup(word.outputs[y], [pool[qh]], z)
                        for i, array in enumerate(arrays):
                            b = 0
                            for point, inner_weight in self.field.stencil(self.d):
                                self.call(array, point, qa, pool, word.g + 1)
                                c = self.lookup(
                                    word.predicates[y][i], [pool[qh], pool[qa]],
                                    0, augmented=False,
                                )
                                self.call(array, point, qa, pool, word.g + 1)
                                b ^= self.field.mul(inner_weight, c)
                            u = self.field.mul(u, b)
                        pool[target][z] ^= self.field.mul(
                            self.field.mul(scalar, weight), u
                        )
                self.call(h, s, qh, pool, 1)
        finally:
            self.ancestors.pop()


def check_call(evaluator, word, scalar, target, contents):
    pool = [list(row) for row in contents]
    before = [row[:] for row in pool]
    evaluator.peak = 0
    evaluator.add(word, scalar, target, pool)
    expected = [row[:] for row in before]
    for z, bit in enumerate(semantic(word) + (1,)):
        expected[target][z] ^= evaluator.field.mul(scalar, bit)
    assert pool == expected, (word.name, scalar, target, before, pool, expected)
    assert evaluator.suspended == 0 and not evaluator.ancestors
    assert evaluator.peak <= 2 * (evaluator.d + 1) + path_weight(word)


def finite_diagnostics():
    f4 = Field(0b111)
    f8 = Field(0b1011)
    adapter = json.loads((HERE / "jacobian_output.json").read_text())
    assert adapter["result"]["operation_id"] == "finite_field.polynomial_map.table.compute"
    assert adapter["request"]["payload"] == json.loads(
        (HERE / "jacobian_payload.json").read_text()
    )
    for a, b in adapter["result"]["output"]["entries"]:
        x = sum(c << i for i, c in enumerate(a["coordinates"]))
        y = sum(c << i for i, c in enumerate(b["coordinates"]))
        assert f4.mul(f4.mul(x, x), x) == y
    h = Word("H", "base", (0,))
    a = Word("A", "base", (1,))
    factored = Word(
        "history-repeated-array", "history", deps=(h, a, a), g=1,
        outputs=(lambda x: (1 ^ x[0][0],), lambda x: (x[0][0],)),
        predicates=(
            (lambda h, a: a[0] == h[0], lambda h, a: True),
            (lambda h, a: a[0] != h[0], lambda h, a: a[0] == 1 or h[0] == 1),
        ),
    )
    ordinary = Word(
        "ordinary-repeated-input", "ordinary", deps=(a, a),
        function=lambda xs: (xs[0][0] & xs[1][0],),
    )
    e = Evaluator(f4, 1)
    cases = 0
    for flat in itertools.product(range(f4.size), repeat=6):
        pool = tuple(tuple(flat[2 * q:2 * q + 2]) for q in range(3))
        for node in (ordinary, factored):
            check_call(e, node, 1, 0, pool)
            cases += 1
    rng = random.Random(137)
    nested_h = Word(
        "negated-history", "ordinary", deps=(factored,),
        function=lambda xs: (1 ^ xs[0][0],),
    )
    nested = Word(
        "nested-borrowing", "history", deps=(nested_h, factored, factored), g=1,
        outputs=tuple(
            (lambda y: lambda xs: (xs[0][0] ^ y,))(y) for y in range(2)
        ),
        predicates=tuple(
            (
                (lambda y: lambda h, a: y == (h[0] ^ a[0]))(y),
                lambda h, a: h[0] == 1 or a[0] == 1,
            ) for y in range(2)
        ),
    )
    for _ in range(8):
        pool = tuple(tuple(rng.randrange(4) for _ in range(2)) for _ in range(3))
        for scalar in range(4):
            for target in range(3):
                check_call(e, nested, scalar, target, pool)
                cases += 1
    e8 = Evaluator(f8, 2)
    h2 = Word("H2", "base", (1, 0))
    a2 = Word("A2", "base", (0, 1))
    zero_guess = Word(
        "zero-guess-width-two", "history", deps=(h2, a2), g=0,
        outputs=(lambda xs: xs[0],),
        predicates=((lambda h, a: h[0] == 1 and a[1] == 1,),),
    )
    for _ in range(8):
        pool = tuple(tuple(rng.randrange(8) for _ in range(3)) for _ in range(3))
        for scalar in range(8):
            for target in range(3):
                check_call(e8, zero_guess, scalar, target, pool)
                cases += 1
    assert e.zero_augmentations > 0 and e8.zero_augmentations > 0
    assert e.borrowed_ancestor_slots > 0
    return {
        "classification": "finite_diagnostic_only",
        "cases": cases,
        "exhaustive_GF4_pools": 4096,
        "tested_dimensions": [1, 2],
        "tested_guess_lengths": [0, 1],
        "repeated_dependency_roles": True,
        "correlated_arrays": True,
        "nested_ancestor_register_borrowing": True,
        "GF4_calls": e.calls,
        "GF8_calls": e8.calls,
        "zero_augmentation_lookups": e.zero_augmentations + e8.zero_augmentations,
        "GF4_peak_abstract_units": e.peak,
        "GF8_peak_abstract_units": e8.peak,
    }


def official_compile():
    command = [
        ARGUS, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        "--project-root", str(ROOT), "--claim", "C137_WEIGHTED",
        "--statement-fidelity", str(HERE / "STATEMENT_FIDELITY.md"),
        str(HERE / "Main.lean"),
    ]
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
    if result.returncode:
        raise RuntimeError(result.stdout + result.stderr)
    evidence = json.loads(result.stdout)
    assert evidence["status"] == "success"
    assert evidence["exit_code"] == evidence["audit_exit_code"] == 0
    assert evidence["proof_holes"] == []
    assert evidence["kernel"]["recorded"] is not None
    record = evidence["kernel"]["recorded"]
    assert "4.31.0" in record["produced_by"]
    print(json.dumps({
        "status": evidence["status"],
        "exit_code": evidence["exit_code"],
        "audit_exit_code": evidence["audit_exit_code"],
        "proof_holes": evidence["proof_holes"],
        "certificate": record["artifact"],
    }, sort_keys=True))
    for module in ("math_state", "proof_graph_check"):
        subprocess.run(
            [ARGUS, "-m", f"argus_skill.verticals.math.{module}", "check",
             "--project-root", str(ROOT)], cwd=ROOT, check=True,
        )
    return {
        "classification": "real_Lean_compilation",
        "claim": "C137_WEIGHTED",
        "command": command,
        "exit_code": result.returncode,
        "audit_exit_code": evidence["audit_exit_code"],
        "proof_holes": evidence["proof_holes"],
        "certificate": record["artifact"],
        "compiler": record["produced_by"],
        "statement_fidelity": evidence["statement_fidelity"],
        "project_root": str(ROOT),
        "campaign_local_check_exit_codes": [0, 0],
        "independent_review": "pending_host_reviewer",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument("--finite-only", action="store_true")
    modes.add_argument("--formal-only", action="store_true")
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    path = HERE / "exact_certificate.json"
    certificate = json.loads(path.read_text()) if path.exists() else {}
    diagnostics = (
        certificate["finite_diagnostics"] if args.formal_only
        else finite_diagnostics()
    )
    if args.write_certificate:
        certificate["finite_diagnostics"] = diagnostics
    else:
        assert certificate["finite_diagnostics"] == diagnostics
    if not args.finite_only:
        certificate["formal_verification"] = official_compile()
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    print(json.dumps(
        certificate["formal_verification"] if args.formal_only else diagnostics,
        sort_keys=True,
    ))


if __name__ == "__main__":
    main()
