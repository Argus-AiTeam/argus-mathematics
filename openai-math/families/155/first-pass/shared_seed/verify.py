#!/usr/bin/env python3
"""Replay exact activation inverses and check the recorded universal Lean proof."""

import argparse
from collections import Counter
from hashlib import sha256
from itertools import product
import json
from math import gcd, isqrt, prod
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
CLAIM = "C_SHARED_SEED"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


class CRT:
    def __init__(self, moduli):
        require(all(m > 1 for m in moduli), "CRT moduli must exceed one")
        require(all(gcd(m, n) == 1 for i, m in enumerate(moduli)
                    for n in moduli[i + 1:]), "CRT moduli are not coprime")
        self.moduli = tuple(moduli)
        self.modulus = prod(moduli)
        self.basis = tuple((self.modulus // m) * pow(self.modulus // m, -1, m)
                           for m in moduli)

    def __call__(self, residues):
        return sum(c * r for c, r in zip(self.basis, residues, strict=True)) % self.modulus


class Shifts:
    def __init__(self, a, b, twisted):
        self.a, self.b = a, b
        self.sign = -1 if twisted else 1
        self.twisted = twisted

    @staticmethod
    def swap(delta):
        if delta == (1, 0):
            return 0, 1
        if delta == (0, 1):
            return 1, 0
        return delta

    def entry(self, delta):
        return self.swap(delta)[0], delta[1]

    def offset_a(self, xi):
        return 3 * xi + 1 if self.twisted else 0

    def offset_b(self, alpha):
        return 2 * alpha + 1 if self.twisted else 0

    def order_a(self, delta):
        ea, eb = self.entry(delta)
        return eb, (self.sign * delta[0] + self.offset_a(eb)) % self.a

    def order_b(self, delta):
        ea, _ = self.entry(delta)
        return ea, (self.sign * self.swap(delta)[1] + self.offset_b(ea)) % self.b

    def inverse_a(self, xi, value):
        return (self.sign * (value - self.offset_a(xi))) % self.a, xi

    def inverse_b(self, alpha, value):
        return self.swap((alpha, (self.sign * (value - self.offset_b(alpha))) % self.b))

    def rho(self, delta):
        ea, eb = self.entry(delta)
        return (self.order_a(delta)[1] - ea) % self.a, \
            (self.order_b(delta)[1] - eb) % self.b

    def indices(self):
        return product(range(self.a), range(self.b))


class Blocks:
    def __init__(self, a, b, r, count_a, count_b):
        require(r == count_a * a + count_b * b, "Invalid block partition")
        self.a, self.b, self.r = a, b, r
        self.count_a, self.count_b = count_a, count_b
        self.step, self.offset = 2, 3
        require(gcd(self.step, r) == 1, "Block relabelling is not a permutation")
        self.step_inverse = pow(self.step, -1, r)

    def chart(self, k):
        t = ((k - self.offset) * self.step_inverse) % self.r
        if t < self.count_a * self.a:
            kind, block, position, size = 0, t // self.a, t % self.a, self.a
        else:
            t -= self.count_a * self.a
            kind, block, position, size = 1, t // self.b, t % self.b, self.b
        return kind, block, (block - position) % size

    def point(self, kind, block, label):
        size = self.b if kind else self.a
        t = block * size + (block - label) % size
        if kind:
            t += self.count_a * self.a
        return (self.step * t + self.offset) % self.r

    def useful(self, k):
        kind, _, y = self.chart(k)
        return (0, y) if kind else (y, 0)

    def rotate(self, t, k):
        kind, block, y = self.chart(k)
        size = self.b if kind else self.a
        return self.point(kind, block, (y + t) % size)


class DigitBlocks(Blocks):
    def __init__(self, selected):
        self.digits = (Blocks(5, 7, 17, 2, 1), Blocks(5, 7, 19, 1, 2))
        self.selected = selected
        self.a, self.b, self.r = 5, 7, 17 * 19
        self.crt = CRT((self.digits[selected].r, self.digits[1 - selected].r))

    def chart(self, k):
        kind, block, y = self.digits[self.selected].chart(k)
        return kind, (block, k % self.digits[1 - self.selected].r), y

    def point(self, kind, block, label):
        index, other = block
        return self.crt((self.digits[self.selected].point(kind, index, label), other))


def rotate_world(t, world):
    region, copy, y, z = world
    return region, copy, None if y is None else (y + t) % 2, \
        None if z is None else (z + t) % 3


class SmallSpace:
    D, copies, horizontal_modulus = 19, 2, 19

    @staticmethod
    def rank(s):
        return s

    def residue(self, x):
        return x[0] % self.D

    def sub(self, s, tau):
        return (s - tau) % self.D

    def first(self, tau):
        return tau

    @staticmethod
    def second(tau):
        return 0

    def layout(self, s):
        t = (7 * s + 3) % self.D
        if t < 3:
            return 1, 0, None, t
        if t < 7:
            t -= 3
            return 2, t // 2, t % 2, None
        t -= 7
        return 0, t // 6, (t % 6) // 3, t % 3

    def unlayout(self, world):
        region, copy, y, z = world
        t = z if region == 1 else 3 + 2 * copy + y if region == 2 \
            else 7 + 6 * copy + 3 * y + z
        return (pow(7, -1, self.D) * (t - 3)) % self.D

    def label(self, s):
        return (5 * s + 2) % self.D

    def unlabel(self, z):
        return (pow(5, -1, self.D) * (z - 2)) % self.D

    def elements(self):
        return range(self.D)


class ManuscriptSpace:
    def __init__(self, p):
        self.p = p
        self.horizontal_modulus = p * p
        self.D = p ** 4
        self.copies = (self.D - 7) // 6
        self.first_region = tuple(1 + p * k for k in range(3))
        self.second_region = tuple(2 + p * k for k in range(4))
        self.excluded = tuple(sorted(self.first_region + self.second_region))
        require(self.D == 7 + 6 * self.copies, "Invalid seed-region cardinality")

    def rank(self, s):
        return s[0] * self.horizontal_modulus + s[1]

    def from_rank(self, t):
        return divmod(t, self.horizontal_modulus)

    def residue(self, x):
        return x[0] % self.horizontal_modulus, x[1] % self.horizontal_modulus

    def sub(self, s, tau):
        m = self.horizontal_modulus
        return (s[0] - tau[0]) % m, (s[1] - tau[1]) % m

    @staticmethod
    def first(tau):
        return tau[0]

    @staticmethod
    def second(tau):
        return tau[1]

    def layout(self, s):
        t = self.rank(s)
        if t in self.first_region:
            return 1, 0, None, self.first_region.index(t)
        if t in self.second_region:
            k = self.second_region.index(t)
            return 2, k // 2, k % 2, None
        rank = t - sum(e < t for e in self.excluded)
        return 0, rank // 6, (rank % 6) // 3, rank % 3

    def unlayout(self, world):
        region, copy, y, z = world
        if region == 1:
            return self.from_rank(self.first_region[z])
        if region == 2:
            return self.from_rank(self.second_region[2 * copy + y])
        t = 6 * copy + 3 * y + z
        for excluded in self.excluded:
            if t >= excluded:
                t += 1
        return self.from_rank(t)

    def label(self, s):
        return (5 * self.rank(s) + 2) % self.D

    def unlabel(self, z):
        return self.from_rank((pow(5, -1, self.D) * (z - 2)) % self.D)


def shear(r, x, k, beta):
    return (x + (k - x) % r + r * beta) % (r * r)


def check_carry(r, x, h, k, l, beta):
    require(h % r == l, "Wrong low-coordinate CRT residue")
    require((shear(r, x - h, (k - l) % r, beta) + h) % (r * r)
            == shear(r, x, k, beta), "Sheared high-coordinate carry failed")


def block_inverse(shifts, blocks, x, k, c, beta):
    alpha, xi = c
    kind, block, q = blocks.chart(beta)
    if kind == 0:
        delta = shifts.inverse_a(xi, (alpha + x - q) % shifts.a)
        y = (alpha - shifts.entry(delta)[0]) % shifts.a
    else:
        delta = shifts.inverse_b(alpha, (xi + x - q) % shifts.b)
        y = (xi - shifts.entry(delta)[1]) % shifts.b
    return (k - blocks.point(kind, block, y)) % blocks.r, delta


class OrdinaryTest:
    def __init__(self, shifts, blocks):
        self.shifts, self.blocks = shifts, blocks
        self.crt = CRT((blocks.r, shifts.a, shifts.b))
        self.domain_size = blocks.r * shifts.a * shifts.b

    def forward(self, x, k, lift, value):
        l, delta = value
        ea, eb = self.shifts.entry(delta)
        ra, rb = self.shifts.rho(delta)
        code = (l * self.shifts.a + delta[0]) * self.shifts.b + delta[1]
        h = self.crt((l, ra, rb)) + self.crt.modulus * (code + lift)
        low = (k - l) % self.blocks.r
        c = self.blocks.useful(low)
        beta = self.blocks.rotate(x - h, low)
        check_carry(self.blocks.r, x, h, k, l, beta)
        require((31 + 17 * h) + 17 * (x - h) == 31 + 17 * x,
                "Ordinary line invariant failed")
        return ((c[0] + ea) % self.shifts.a,
                (c[1] + eb) % self.shifts.b), beta

    def inverse(self, x, k, target):
        return block_inverse(self.shifts, self.blocks, x, k, *target)


class SeedTest:
    def __init__(self, seed, shifts, blocks, space):
        self.seed, self.shifts, self.blocks, self.space = seed, shifts, blocks, space
        other = 3 if seed == 1 else 2
        self.crt = CRT((blocks.r, shifts.a, shifts.b, other, space.horizontal_modulus))
        self.domain_size = blocks.r * shifts.a * shifts.b * space.D

    def offset(self, value, lift):
        l, delta, tau = value
        ra, rb = self.shifts.rho(delta)
        code = ((l * self.shifts.a + delta[0]) * self.shifts.b + delta[1]) \
            * self.space.D + self.space.rank(tau)
        quotient = code + lift
        h = self.crt((l, ra, rb, 0, self.space.first(tau))) \
            + self.crt.modulus * quotient
        h2 = self.space.second(tau) + self.space.horizontal_modulus * quotient
        return h, h2

    def forward(self, x, k, lift, value):
        l, delta, tau = value
        s0 = self.space.residue(x)
        source = self.space.sub(s0, tau)
        world = self.space.layout(source)
        h, h2 = self.offset(value, lift)
        require(self.space.residue((x[0] - h, x[1] - h2)) == source,
                "Horizontal CRT source mismatch")
        low = (k - l) % self.blocks.r
        if world[0] == self.seed:
            c = self.blocks.useful(low)
            beta = self.blocks.rotate(x[0] - h, low)
        else:
            c = world[2 if self.seed == 1 else 3], 0
            beta = low
        ea, eb = self.shifts.entry(delta)
        z = self.space.label(self.space.unlayout(rotate_world(x[0] - h, world)))
        check_carry(self.blocks.r, x[0], h, k, l, beta)
        return ((c[0] + ea) % self.shifts.a,
                (c[1] + eb) % self.shifts.b), beta, z

    def inverse(self, x, k, target):
        (alpha, xi), beta, z = target
        world = self.space.layout(self.space.unlabel(z))
        if world[0] == self.seed:
            source_world = rotate_world(-x[0], world)
            l, delta = block_inverse(self.shifts, self.blocks, x[0], k,
                                     (alpha, xi), beta)
        else:
            own = 2 if self.seed == 1 else 3
            other = 3 if self.seed == 1 else 2
            q = world[own]
            delta = self.shifts.inverse_a(xi, (alpha + x[0] - q) % self.shifts.a)
            source_world = list(world)
            source_world[own] = (alpha - self.shifts.entry(delta)[0]) % self.shifts.a
            if source_world[other] is not None:
                size = 3 if self.seed == 1 else 2
                source_world[other] = (source_world[other] - x[0]) % size
            source_world = tuple(source_world)
            l = (k - beta) % self.blocks.r
        source = self.space.unlayout(source_world)
        tau = self.space.sub(self.space.residue(x), source)
        return l, delta, tau


def check_shift_data(shifts):
    indices = list(shifts.indices())
    counts = Counter(shifts.entry(delta) for delta in indices)
    require(len({shifts.order_a(d) for d in indices}) == len(indices),
            "First fibre ordering is not bijective")
    require(len({shifts.order_b(d) for d in indices}) == len(indices),
            "Second fibre ordering is not bijective")
    for delta in indices:
        ea, eb = shifts.entry(delta)
        expected = 1 + (ea == 0 and eb == 0) - (ea == 1 and eb == 0) \
            - (ea == 0 and eb == 1) + (ea == 1 and eb == 1)
        require(counts[ea, eb] == expected, "Wrong shift multiplicity")
        require(shifts.inverse_a(*shifts.order_a(delta)) == delta,
                "First fibre inverse failed")
        require(shifts.inverse_b(*shifts.order_b(delta)) == delta,
                "Second fibre inverse failed")
    require(counts[0, 0] == counts[1, 1] == 2, "Repeated shifts were lost")
    require(counts[1, 0] == counts[0, 1] == 0, "Zero multiplicities were lost")


def finite_experiments():
    ordinary_left = ordinary_right = seed_left = seed_right = 0
    seed_regions = Counter()
    for twisted, digit in product((False, True), range(2)):
        shifts = Shifts(5, 7, twisted)
        check_shift_data(shifts)
        test = OrdinaryTest(shifts, DigitBlocks(digit))
        inputs = list(product(range(test.blocks.r), list(shifts.indices())))
        targets = list(product(list(shifts.indices()), range(test.blocks.r)))
        for x, k, sign in product((-17, 0, 8), (0, test.blocks.r - 1), (-1, 1)):
            lift = sign * test.domain_size
            seen = set()
            for value in inputs:
                target = test.forward(x, k, lift, value)
                require(test.inverse(x, k, target) == value, "Ordinary inverse after map failed")
                seen.add(target)
                ordinary_left += 1
            require(len(seen) == len(targets), "Ordinary collision or missing target")
            for target in targets:
                require(test.forward(x, k, lift, test.inverse(x, k, target)) == target,
                        "Ordinary map after inverse failed")
                ordinary_right += 1
    space = SmallSpace()
    for seed, a, b, r, ca, cb in ((1, 2, 5, 11, 3, 1), (2, 3, 7, 13, 2, 1)):
        for twisted in (False, True):
            shifts = Shifts(a, b, twisted)
            check_shift_data(shifts)
            test = SeedTest(seed, shifts, Blocks(a, b, r, ca, cb), space)
            inputs = list(product(range(r), list(shifts.indices()), space.elements()))
            targets = list(product(list(shifts.indices()), range(r), range(space.D)))
            for x1, k, sign in product((-19, -1, 0, 8), (0, r - 1), (-1, 1)):
                x, lift = (x1, -2 * x1 + 1), sign * test.domain_size
                seen, offsets = set(), set()
                for value in inputs:
                    target = test.forward(x, k, lift, value)
                    require(test.inverse(x, k, target) == value,
                            "Seed inverse after map failed")
                    source = space.sub(space.residue(x), value[2])
                    seed_regions[space.layout(source)[0]] += 1
                    seen.add(target)
                    offsets.add(test.offset(value, lift)[0])
                    seed_left += 1
                require(len(offsets) == len(inputs), "Batches have repeated horizontal offsets")
                require(len(seen) == len(targets), "Seed collision or missing target")
                for target in targets:
                    value = test.inverse(x, k, target)
                    require(test.forward(x, k, lift, value) == target,
                            "Seed map after inverse failed")
                    seed_right += 1
    return {
        "classification": "finite_verification_support_only",
        "ordinary_inverse_after_map": ordinary_left,
        "ordinary_map_after_inverse": ordinary_right,
        "seed_inverse_after_map": seed_left,
        "seed_map_after_inverse": seed_right,
        "seed_source_region_counts": {str(k): v for k, v in sorted(seed_regions.items())},
        "ordinary_digit_primes": [17, 19],
        "small_space_order": space.D,
        "scope": "Exhaustive low inputs, indexed shifts, horizontal residues and targets per scenario; both independent fibre orderings, both digits, negative coordinates, both signs of separated CRT lifts.",
    }


def prime(n):
    if n < 2:
        return False
    if n % 2 == 0:
        return n == 2
    return all(n % d for d in range(3, isqrt(n) + 1, 2))


def next_prime(n):
    candidate = n + 1
    while not prime(candidate):
        candidate += 1
    return candidate


def manuscript_experiments():
    space = ManuscriptSpace(211)
    b1 = next_prime(space.D)
    b2 = next_prime(b1)
    r1 = next_prime(b2)
    r2 = next_prime(2 * b2 + 3)
    require(all(prime(n) for n in (211, b1, b2, r1, r2)), "Nonprime manuscript datum")
    require(len({2, 3, 211, b1, b2, r1, r2}) == 7, "Prime choices overlap")
    worlds = [(1, 0, None, z) for z in range(3)]
    worlds += [(2, c, y, None) for c, y in product(range(2), range(2))]
    worlds += [(0, c, y, z) for c, y, z in
               product((0, space.copies - 1), range(2), range(3))]
    for world in worlds:
        s = space.unlayout(world)
        require(space.layout(s) == world, "Manuscript label-space inverse failed")
        require(space.unlabel(space.label(s)) == s, "Cyclic-output label inverse failed")
        if world[0] in (1, 2):
            require(s[0] % 211 == 0 and s[1] % 211 == world[0],
                    "Seed region does not have the required residues")
        for t in (-space.D - 1, -1, 0, 1, space.D + 1):
            require(rotate_world(-t, rotate_world(t, world)) == world,
                    "Shared label rotation is not inverted")
    left = right = 0
    data = []
    for seed, a, b, r in ((1, 2, b1, r1), (2, 3, b2, r2)):
        cb = next(j for j in range(a) if (r - j * b) % a == 0)
        ca = (r - cb * b) // a
        require(ca >= 0 and cb > 0, "Missing a/b seed block type")
        blocks = Blocks(a, b, r, ca, cb)
        shifts = Shifts(a, b, True)
        test = SeedTest(seed, shifts, blocks, space)
        deltas = sorted({(0, 0), (1, 0), (0, 1), (1, 1), (a - 1, b - 1)})
        beta_values = sorted({blocks.point(kind, copy, y)
                              for kind, copies, size in ((0, ca, a), (1, cb, b))
                              for copy in (0, copies - 1)
                              for y in (0, 1, size - 1)})
        for x1, k, sign in product((-44522, -1, 0, 44523), (0, r - 1), (-1, 1)):
            x, lift = (x1, -3 * x1 - 2), sign * test.domain_size
            for world, delta, l in product(worlds, deltas, (0, r // 2, r - 1)):
                tau = space.sub(space.residue(x), space.unlayout(world))
                value = l, delta, tau
                require(test.inverse(x, k, test.forward(x, k, lift, value)) == value,
                        "Admissible seed inverse after map failed")
                left += 1
            for alpha, xi, beta, world in product(range(a), (0, 1, b - 1),
                                                  beta_values, worlds):
                target = (alpha, xi), beta, space.label(space.unlayout(world))
                require(test.forward(x, k, lift, test.inverse(x, k, target)) == target,
                        "Admissible seed map after inverse failed")
                right += 1
        data.append({"seed": seed, "a": a, "b": b, "r": r,
                     "a_blocks": ca, "b_blocks": cb})
    return {
        "classification": "finite_boundary_stress_support_only",
        "p": space.p, "D": space.D, "both_inactive_copies": space.copies,
        "seed_data": data, "inverse_after_map": left, "map_after_inverse": right,
        "scope": "Actual p>200, b_i>D, distinct prime seed data, prescribed seed-region residues, both block types, repeated shifts, extreme copies/labels and negative horizontal coordinates. This is not an enumeration of all D residues or the full ordinary-channel family.",
    }


def mechanical_evidence():
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "The universal Lean proof has not compiled successfully")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require(result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
            "The required Lean 4.31.0 toolchain was not used")
    require(result["source_sha256"] == sha256((HERE / "Main.lean").read_bytes()).hexdigest(),
            "Lean source changed after official compilation")
    fidelity = (HERE / "statement_fidelity.md").read_text()
    require(result["statement_fidelity_sha256"] == sha256(fidelity.encode()).hexdigest(),
            "Statement fidelity changed after official compilation")
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max((c for c in ledger["claims"] if c["claim_id"] == CLAIM),
                key=lambda c: c["version"])
    records = [e for e in ledger["evidence"]
               if e["subject"]["subject_id"] == CLAIM and e["tier"] == "mechanical"
               and e["verdict"] == "supports"
               and e["subject"]["content_hash"] == claim["content_hash"]]
    require(len(records) == 1, "Expected one current mechanical certificate for the claim")
    artifact = records[0]["artifact"]
    archived = json.loads((ROOT / artifact).read_text())
    require(archived["subject"] == records[0]["subject"]
            and archived["lean_check"] == result,
            "Archived compiler evidence does not match the current claim and run")
    require(archived["lean_source"]["text"] == (HERE / "Main.lean").read_text(),
            "Archived proof differs from the current source")
    require(archived["statement_fidelity"]["text"] == fidelity,
            "Archived fidelity differs from the current statement")
    adapter = json.loads((HERE / "jacobian_output.json").read_text())
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    require(adapter["request"]["payload"] == payload, "Jacobian payload was changed")
    output = adapter["result"]["output"]
    require(output["is_exact_factorization"] and output["pair_count"] == 25
            and output["first_duplicate"] is None and output["first_missing"] is None,
            "Ancillary Jacobian exact factorization did not succeed")
    return {
        "claim": CLAIM, "artifact": artifact, "exit_code": 0, "proof_holes": [],
        "universal_declarations": [
            "SharedSeed.ordinary_bijective",
            "SharedSeed.ordinary_inverse_compositions",
            "SharedSeed.simultaneous_activation",
            "SharedSeed.manuscript_specialization",
            "SharedSeed.shear_carry",
            "SharedSeed.horizontal_source",
        ],
        "scope": "Kernel-checked universal inverse theorem, not an inference from the finite experiments.",
        "independent_review": "required_not_self_certified",
        "jacobian": {"operation_id": adapter["result"]["operation_id"],
                     "server_version": adapter["server"]["version"],
                     "protocol_version": adapter["protocol_version"],
                     "adapter_exit_code": 0, "structured_error": None,
                     "scope": "Ancillary Z/25 subgroup/transversal calculation only"},
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    mechanical = mechanical_evidence()
    certificate = {
        "schema_version": 1,
        "result_class": "parameter_uniform_formal_verification",
        "claim": CLAIM,
        "false_manuscript_assertion_identified": False,
        "mechanical_evidence": mechanical,
        "finite_experiments": finite_experiments(),
        "manuscript_boundary_experiments": manuscript_experiments(),
        "limits": [
            "No claim that the complete periodic-tiling theorem is formalized.",
            "No global novelty or publishability verdict is supplied by Engineer.",
            "Region/block charts and fibre orderings encode the manuscript's explicitly chosen labelled sets; activation bijectivity is proved, not assumed.",
            "All permitted lifts are covered by the universal Lean theorem, not exhausted by finite tests.",
        ],
    }
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        expected = json.loads(path.read_text())
        require(certificate == expected, "Exact certificate differs from independent replay")
    print(json.dumps({"status": "verified", "claim": CLAIM,
                      "ordinary_compositions": 2 * certificate["finite_experiments"]
                      ["ordinary_inverse_after_map"],
                      "seed_compositions": 2 * certificate["finite_experiments"]
                      ["seed_inverse_after_map"],
                      "admissible_seed_compositions":
                      certificate["manuscript_boundary_experiments"]["inverse_after_map"]
                      + certificate["manuscript_boundary_experiments"]["map_after_inverse"],
                      "independent_review": "pending"}, sort_keys=True))


if __name__ == "__main__":
    main()
