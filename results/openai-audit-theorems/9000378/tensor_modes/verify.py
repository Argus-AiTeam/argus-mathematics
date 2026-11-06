#!/usr/bin/env python3
"""Exact finite replay accompanying, not replacing, the universal proof."""

import argparse
import itertools
import json
import math
from collections import Counter
from dataclasses import dataclass
from fractions import Fraction
from functools import lru_cache
from pathlib import Path


HERE = Path(__file__).resolve().parent


def check(condition, message):
    if not condition:
        raise AssertionError(message)


def v2(n):
    check(n != 0, "v2 requires a nonzero integer")
    n = abs(n)
    return (n & -n).bit_length() - 1


def gf2_remainder(n, divisor):
    while n and n.bit_length() >= divisor.bit_length():
        n ^= divisor << (n.bit_length() - divisor.bit_length())
    return n


def irreducible_mod_two(f):
    degree = len(f) - 1
    bits = sum((c % 2) << j for j, c in enumerate(f))
    for d in range(1, degree // 2 + 1):
        for lower in range(1 << d):
            if gf2_remainder(bits, (1 << d) | lower) == 0:
                return False
    return True


class Ring:
    """Normal forms in (Z/2^p)[U,V]/(f(U),V^ell)."""

    def __init__(self, p, f, ell):
        check(p >= 1 and ell >= 1 and f[-1] == 1, "invalid ring")
        check(irreducible_mod_two(f), "the replay uses irreducible f modulo two")
        self.p, self.f, self.ell = p, tuple(f), ell
        self.e, self.modulus = len(f) - 1, 1 << p
        self.dimension = self.e * ell
        self.zero = (0,) * self.dimension
        self.one = self.scalar(1)
        self.products = {}
        for x in range(self.dimension):
            for y in range(self.dimension):
                vx, ux = divmod(x, self.e)
                vy, uy = divmod(y, self.e)
                terms = []
                if vx + vy < ell:
                    u = [0] * (2 * self.e - 1)
                    u[ux + uy] = 1
                    for d in range(len(u) - 1, self.e - 1, -1):
                        for k in range(self.e):
                            u[d - self.e + k] -= u[d] * self.f[k]
                    terms = [
                        ((vx + vy) * self.e + k, u[k])
                        for k in range(self.e) if u[k]
                    ]
                self.products[x, y] = terms

    def scalar(self, n):
        return (n % self.modulus,) + (0,) * (self.dimension - 1)

    def u(self):
        if self.e == 1:
            return self.scalar(-self.f[0])
        return (0, 1) + (0,) * (self.dimension - 2)

    def v(self):
        if self.ell == 1:
            return self.zero
        return (0,) * self.e + (1,) + (0,) * (self.dimension - self.e - 1)

    def add(self, x, y):
        return tuple((a + b) % self.modulus for a, b in zip(x, y))

    def neg(self, x):
        return tuple(-a % self.modulus for a in x)

    def sub(self, x, y):
        return self.add(x, self.neg(y))

    def mul(self, x, y):
        out = [0] * self.dimension
        for i, a in enumerate(x):
            if a:
                for j, b in enumerate(y):
                    if b:
                        for k, c in self.products[i, j]:
                            out[k] += a * b * c
        return tuple(a % self.modulus for a in out)

    def power(self, x, n):
        check(n >= 0, "negative ring exponent")
        out = self.one
        while n:
            if n & 1:
                out = self.mul(out, x)
            x = self.mul(x, x)
            n //= 2
        return out

    def odd_inverse(self, x):
        check(tuple(a % 2 for a in x) == (1,) + (0,) * (self.dimension - 1),
              "normalized denominator is not 1 modulo two")
        out, precision = self.one, 1
        while precision < self.p:
            out = self.mul(out, self.sub(self.scalar(2), self.mul(x, out)))
            precision *= 2
        check(self.mul(x, out) == self.one, "Newton unit inverse failed")
        return out

    def rational(self, x):
        x = Fraction(x)
        check(x.denominator % 2 == 1, "nonintegral kernel polynomial coefficient")
        return self.scalar(x.numerator * pow(x.denominator, -1, self.modulus))

    def divisible(self, x, weight):
        return all(a % (1 << min(weight, self.p)) == 0 for a in x)

    def product(self, values):
        out = self.one
        for x in values:
            out = self.mul(out, x)
        return out


@lru_cache(maxsize=None)
def cprime_zero(a):
    L = 1 << a
    return math.prod(-q for q in range(-L, L) if q)


@lru_cache(maxsize=None)
def kernel_polynomial(a, t, difference):
    L, alpha = 1 << a, 1 << (a + 1)
    check(-L <= difference < L, "difference not on the grid")
    out = [1]
    for q in range(-L, L):
        if q == difference:
            continue
        new = [0] * (len(out) + 1)
        for k, c in enumerate(out):
            new[k] += (t - q) * c
            new[k + 1] += alpha * c
        out = new
    result = tuple(Fraction(c, cprime_zero(a)) for c in out)
    check(all(c.denominator % 2 for c in result), "local integrality failed")
    return result


def evaluate_kernel(R, a, t, difference, zeta):
    out = R.zero
    for c in reversed(kernel_polynomial(a, t, difference)):
        out = R.add(R.mul(out, zeta), R.rational(c))
    return out


def normalized_n(R, a, t, zeta):
    L, alpha = 1 << a, 1 << (a + 1)
    derivative = cprime_zero(a)
    d = v2(derivative)
    out = R.mul(zeta, R.rational(Fraction(1, derivative // (1 << d))))
    total = 0
    for q in range(-L, L):
        if q == t:
            continue
        k = v2(t - q)
        total += k
        factor = R.add(R.scalar((t - q) // (1 << k)),
                       R.mul(R.scalar(alpha >> k), zeta))
        out = R.mul(out, factor)
    check(total == d, "grid derivative valuations differ")
    return out


def crossing_coefficients(R, a, t, i, x, y0, zeta, n):
    h = 1 << (i + 1)
    check(((x >> i) & 1) == ((y0 >> i) & 1), "not a crossing tile")
    delta = v2(t - y0 + x)
    check(delta <= i < a, "crossing denominator valuation bound failed")
    unit = R.add(R.scalar((t - y0 + x) // (1 << delta)),
                 R.mul(R.scalar(1 << (a + 1 - delta)), zeta))
    inverse = R.odd_inverse(unit)
    A = R.mul(R.scalar(1 << (a + 1 - delta)), R.mul(n, inverse))
    q = R.mul(R.scalar(h >> delta), inverse)
    out, coefficient = [], A
    for b in range(R.p + 1):
        check(R.divisible(coefficient, b + 1), "mode coefficient lost its weight")
        if b + 1 < R.p:
            out.append(coefficient)
        coefficient = R.mul(coefficient, q)
    return out


def kernel_replay():
    stats = Counter()
    profiles = []
    for f, ell in [((1, 1), 1), ((1, 1, 0, 0, 1), 2)]:
        for p in (1, 2, 4, 5):
            R = Ring(p, f, ell)
            profiles.append({"p": p, "f": list(f), "ell": ell})
            zetas = (R.zero, R.one, R.scalar(-1), R.u())
            for a in (1, 2, 3):
                L = 1 << a
                for t in range(-L + 1, L):
                    if not t:
                        continue
                    i = v2(t)
                    counts = Counter(v2(t - q) for q in range(-L, L) if q != t)
                    check(counts == Counter({k: 1 << (a - k) for k in range(a + 1)}),
                          "translated grid counts failed")
                    stats["grid_profiles"] += 1
                    for zeta in zetas:
                        n = normalized_n(R, a, t, zeta)
                        direct = {
                            d: evaluate_kernel(R, a, t, d, zeta)
                            for d in range(-L + 1, L)
                        }
                        stats["kernel_evaluations"] += len(direct)
                        h = 1 << (i + 1)
                        for x in range(L):
                            for y0 in range(h):
                                if ((x >> i) & 1) != ((y0 >> i) & 1):
                                    continue
                                coeffs = crossing_coefficients(
                                    R, a, t, i, x, y0, zeta, n)
                                stats["weighted_coefficients"] += R.p + 1
                                for j, y in enumerate(range(y0, L, h)):
                                    expanded = R.zero
                                    for b, c in enumerate(coeffs):
                                        expanded = R.add(expanded, R.mul(c, R.scalar(j ** b)))
                                    check(expanded == direct[y - x],
                                          f"Cauchy split failed: a={a}, t={t}, p={p}, x={x}, y={y}")
                                    stats["crossing_entries"] += 1
                        if zeta == R.zero:
                            for x in range(L):
                                for y in range(L):
                                    if y - x != t:
                                        check(direct[y - x] == R.zero,
                                              "root kernel has an unexpected surviving entry")
                                    if ((x >> i) & 1) == ((y >> i) & 1):
                                        check(direct[y - x] == R.zero,
                                              "root kernel is not local in actual orientation")
                                    stats["root_orientation_entries"] += 1
    R = Ring(5, (1, 1, 0, 0, 1), 2)
    for a in (1, 2, 3, 4):
        for x in range(1 << a):
            for y in range(1 << a):
                check(evaluate_kernel(R, a, 0, y - x, R.zero) ==
                      (R.one if x == y else R.zero), "W(0) is not the identity")
                stats["origin_identity_entries"] += 1
    return {"ring_profiles": profiles, **dict(sorted(stats.items()))}


@dataclass(frozen=True)
class Packet:
    pairs: tuple
    occupied: tuple

    def label(self, slot, column=False):
        result = []
        for k, (left, right) in enumerate(self.pairs):
            bit = ((slot >> k) & 1) ^ column
            result.append(right if bit else left)
        return tuple(result)


def budget_tuples(weights, p):
    beta = [0] * len(weights)

    def visit(k, remaining):
        if k == len(weights):
            yield tuple(beta)
            return
        for b in range(remaining // weights[k] + 1):
            beta[k] = b
            yield from visit(k + 1, remaining - b * weights[k])

    yield from visit(0, p - 1)


def tensor_entry(R, side, index, bits):
    seed = 1 + 3 * index + 5 * side + sum((j + 2) * b for j, b in enumerate(bits))
    seed += sum(bits[j] * bits[j + 1] for j in range(len(bits) - 1))
    out = R.add(R.scalar(seed), R.mul(R.u(), R.scalar(seed * seed + 1)))
    return R.add(out, R.mul(R.v(), R.scalar(2 * seed + side + 1)))


def network_replay(name, a, t, p, zeta_kind, packets):
    R = Ring(p, (1, 1, 0, 0, 1), 2)
    i, L = v2(t), 1 << a
    zeta = {"zero": R.zero, "one": R.one, "u": R.u(),
            "one_plus_u": R.add(R.one, R.u())}[zeta_kind]
    ports = [(k, slot) for k, packet in enumerate(packets) for slot in packet.occupied]
    M = len(ports)
    row_labels = [packets[k].label(slot) for k, slot in ports]
    col_labels = [packets[k].label(slot, True) for k, slot in ports]
    row_group = [label[i] for label in row_labels]
    col_group = [label[i] for label in col_labels]
    vertices = []
    for side, labels in enumerate((row_labels, col_labels)):
        for index, label in enumerate(sorted(set(labels))):
            indices = tuple(j for j, value in enumerate(labels) if value == label)
            vertices.append((side, index, label[i], indices))
    vertices.append((0, 37, 55, ()))
    tables = {}
    for side, index, group, indices in vertices:
        tables[side, index] = {
            bits: tensor_entry(R, side, index, bits)
            for bits in itertools.product((0, 1), repeat=len(indices))
        }

    def old_weight(group, Y, X):
        values = []
        for side, index, g, indices in vertices:
            if group is None or group == g:
                bits = X if side else Y
                values.append(tables[side, index][tuple(bits[j] for j in indices)])
        return R.product(values)

    W = {}
    for x, (k, slot_x) in enumerate(ports):
        for y, (other, slot_y) in enumerate(ports):
            W[x, y] = (evaluate_kernel(R, a, t, slot_y - slot_x, zeta)
                       if k == other else R.zero)
    modes, weights, mode_coeffs = [], [], {}
    n = normalized_n(R, a, t, zeta)
    h = 1 << (i + 1)
    for k, packet in enumerate(packets):
        pair = packet.pairs[i]
        if pair[0] == pair[1]:
            continue
        for y0 in range(h):
            source = packet.label(y0, True)[i]
            target = pair[1] if source == pair[0] else pair[0]
            ids = []
            for b in range(p - 1):
                ids.append(len(modes))
                modes.append((k, y0, b, source, target))
                weights.append(b + 1)
            for x, (packet_id, slot_x) in enumerate(ports):
                if packet_id == k and row_group[x] == target:
                    coeffs = crossing_coefficients(R, a, t, i, slot_x, y0, zeta, n)
                    for mode_id, c in zip(ids, coeffs):
                        mode_coeffs[x, mode_id] = c
    betas = list(budget_tuples(weights, p))
    stats = Counter()

    def source_values(X):
        out = []
        for k, y0, b, _, _ in modes:
            value = 0
            for y, (packet_id, slot) in enumerate(ports):
                if packet_id == k and slot % h == y0:
                    value += ((slot - y0) // h) ** b * X[y]
            out.append(R.scalar(value))
        return out

    def local_value(x, X):
        return R.product(()) if False else sum_ring(
            R, (R.mul(W[x, y], R.scalar(X[y]))
                for y in range(M) if col_group[y] == row_group[x]))

    direct = R.zero
    all_bits = list(itertools.product((0, 1), repeat=M))
    for X in all_bits:
        source = source_values(X)
        row_values = []
        for x in range(M):
            actual = sum_ring(R, (R.mul(W[x, y], R.scalar(X[y])) for y in range(M)))
            split = local_value(x, X)
            for mode_id in range(len(modes)):
                split = R.add(split, R.mul(mode_coeffs.get((x, mode_id), R.zero),
                                           source[mode_id]))
            check(actual == split, "network row forms disagree before coefficient extraction")
            row_values.append(actual)
            stats["row_form_replays"] += 1
        for Y in all_bits:
            term = old_weight(None, Y, X)
            for x in range(M):
                term = R.mul(term, row_values[x] if Y[x] else R.sub(R.one, row_values[x]))
            direct = R.add(direct, term)

    target_ids = {
        (k, g): [z for z, mode in enumerate(modes) if mode[0] == k and mode[4] == g]
        for k in range(len(packets)) for g in range(64)
    }

    def packet_polynomial(k, group, Y, X):
        ids = target_ids[k, group]
        zero = (0,) * len(ids)
        out = {zero: R.one}
        for x, (packet_id, _) in enumerate(ports):
            if packet_id != k or row_group[x] != group:
                continue
            local = local_value(x, X)
            constant = local if Y[x] else R.sub(R.one, local)
            new = {}
            for exponent, coefficient in out.items():
                new[exponent] = R.add(new.get(exponent, R.zero), R.mul(coefficient, constant))
                for j, mode_id in enumerate(ids):
                    mode_coefficient = mode_coeffs.get((x, mode_id), R.zero)
                    if not Y[x]:
                        mode_coefficient = R.neg(mode_coefficient)
                    shifted = list(exponent)
                    shifted[j] += 1
                    key = tuple(shifted)
                    new[key] = R.add(new.get(key, R.zero),
                                     R.mul(coefficient, mode_coefficient))
            for exponent, coefficient in new.items():
                weight = sum(weights[z] * b for z, b in zip(ids, exponent))
                check(R.divisible(coefficient, weight), "affine product violates weighted divisibility")
                if weight >= p:
                    check(coefficient == R.zero, "a discarded coefficient does not vanish")
                    stats["discarded_zero_coefficients"] += 1
                stats["packet_coefficients"] += 1
            out = {exponent: c for exponent, c in new.items() if c != R.zero}
        return out

    children = []
    for group in range(64):
        row_indices = [j for j, g in enumerate(row_group) if g == group]
        col_indices = [j for j, g in enumerate(col_group) if g == group]
        child = [R.zero] * len(betas)
        for bits in itertools.product((0, 1), repeat=len(row_indices) + len(col_indices)):
            Y, X = [0] * M, [0] * M
            for j, bit in zip(row_indices, bits):
                Y[j] = bit
            for j, bit in zip(col_indices, bits[len(row_indices):]):
                X[j] = bit
            old = old_weight(group, Y, X)
            polynomials = [packet_polynomial(k, group, Y, X) for k in range(len(packets))]
            source = source_values(X)
            for index, beta in enumerate(betas):
                value = old
                for k, polynomial in enumerate(polynomials):
                    exponent = tuple(beta[z] for z in target_ids[k, group])
                    value = R.mul(value, polynomial.get(exponent, R.zero))
                for z, mode in enumerate(modes):
                    if mode[3] == group:
                        value = R.mul(value, R.power(source[z], beta[z]))
                child[index] = R.add(child[index], value)
        children.append(child)
    rhs, nonzero = R.zero, 0
    for index in range(len(betas)):
        value = R.product(child[index] for child in children)
        nonzero += value != R.zero
        rhs = R.add(rhs, value)
    check(direct == rhs, f"one-step child contraction identity failed: {name}")
    return {"name": name, "a": a, "t": t, "p": p, "zeta": zeta_kind,
            "edges": M, "packets": len(packets), "modes": len(modes),
            "budget_tuples": len(betas), "nonzero_summands": nonzero,
            "contraction_coordinates": list(direct), **dict(sorted(stats.items()))}


def sum_ring(R, values):
    out = R.zero
    for x in values:
        out = R.add(out, x)
    return out


def network_cases():
    return [
        network_replay("precision_one_root", 1, 1, 1, "zero",
                       [Packet(((2, 7),), (0, 1))]),
        network_replay("negative_node_shared_vertices", 2, -1, 3, "u",
                       [Packet(((2, 7), (11, 11)), (0, 1, 2)),
                        Packet(((2, 7), (11, 11)), (0, 3))]),
        network_replay("higher_bit_and_equal_pair", 2, 2, 4, "one_plus_u",
                       [Packet(((5, 5), (3, 19)), (0, 2, 3)),
                        Packet(((5, 5), (19, 19)), (1,))]),
        network_replay("reversed_orientation_empty_tile_and_packet", 2, 1, 5, "u",
                       [Packet(((9, 4), (3, 3)), (0, 1, 3)),
                        Packet(((17, 21), (3, 3)), ())]),
        network_replay("multiple_crossing_selections", 2, 1, 7, "one",
                       [Packet(((2, 7), (11, 11)), (0, 1, 2, 3))]),
        network_replay("empty_port_scalar_children", 1, -1, 4, "zero",
                       [Packet(((2, 7),), ())]),
    ]


def child_size_replay():
    results = []
    for a, i, occupied, equal in [
        (2, 0, (0, 1, 2, 3), False),
        (2, 1, (0, 3), False),
        (2, 0, (0, 1, 2, 3), True),
    ]:
        L = 1 << a
        packets = []
        for group in range(64) if equal else range(0, 64, 2):
            pairs = [(5, 5)] * a
            pairs[i] = (group, group) if equal else (group, group + 1)
            packets.append(Packet(tuple(pairs), occupied))
        M = sum(len(packet.occupied) for packet in packets)
        row, col, degrees = Counter(), Counter(), []
        for packet in packets:
            pr, pc = Counter(), Counter()
            for slot in packet.occupied:
                pr[packet.label(slot)[i]] += 1
                pc[packet.label(slot, True)[i]] += 1
            row.update(pr)
            col.update(pc)
            degrees.extend(pr[g] + pc[g] for g in range(64))
        check(len(packets) * L <= 3 * M, "packet count premise is false")
        for g in range(64):
            check(64 * row[g] <= 3 * M and 64 * col[g] <= 3 * M,
                  "per-side group load premise is false")
            E = row[g] + col[g]
            check(32 * E <= 3 * M and 8 * E < M, "child edge bound failed")
        check(max(degrees) <= 2 * L, "packet degree bound failed")
        D = L >> i
        modes_per_weight = sum(1 << (i + 1) for packet in packets
                               if packet.pairs[i][0] != packet.pairs[i][1])
        check(D * modes_per_weight <= 6 * M, "mode multiplicity bound failed")
        results.append({"a": a, "i": i, "edges": M, "packets": len(packets),
                        "equal_pairs": equal, "max_child_edges": max(row[g] + col[g] for g in range(64)),
                        "max_packet_degree": max(degrees),
                        "modes_per_weight": modes_per_weight})
    return results


def jacobian_replay():
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    result = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    operation = "formal_series.rational.inverse.compute"
    check(status["adapter_exit_code"] == 0, "Jacobian did not complete successfully")
    check(contract["result"]["operation"]["operation_id"] == operation,
          "wrong inspected operation")
    check(result["request"] == {"operation_id": operation, "payload": payload},
          "typed output is not bound to the exact payload")
    check(result["result"]["operation_id"] == operation, "wrong executed operation")
    out = result["result"]["output"]
    check(out["exactness"] == "EXACT_RATIONAL", "Jacobian output is not exact")
    check(out["residual_congruence"] == "PRODUCT_IS_ONE_MOD_X_TO_N", "wrong residual contract")

    def fractions(series):
        return [Fraction(int(c["num"]), int(c["den"])) for c in series]

    source = fractions(out["source"]["coefficients"])
    inverse = fractions(out["result"]["coefficients"])
    check(source == fractions(payload["coefficients"]), "returned source differs")
    check(inverse == [Fraction(2, 9) ** b for b in range(4)], "inverse coefficients differ")
    for k in range(4):
        check(sum(source[j] * inverse[k - j] for j in range(k + 1)) == (k == 0),
              "independent rational convolution failed")
    check(fractions(out["residual_coefficients"]) == [0] * 4, "nonzero typed residual")
    numerator = Fraction(math.prod(9 - q for q in range(-4, 4)), cprime_zero(2))
    actual, prefix = numerator / 7, numerator / 9
    approximation = prefix * sum(inverse)
    difference = actual - approximation
    check(numerator == -360360 and actual == -51480 and prefix == -40040,
          "Jacobian example is not the actual stated Cauchy specialization")
    check(difference == 0 or v2(difference.numerator) - v2(difference.denominator) >= 5,
          "actual-kernel remainder fails the p=5 cutoff")
    return {"operation_id": operation, "server_version": result["server"]["version"],
            "protocol_version": result["protocol_version"], "adapter_exit_code": 0,
            "residual_coefficients_checked": 4,
            "actual_kernel_parameters": {"a": 2, "t": 1, "x": 0, "y0": 0, "j": 1, "zeta": 1, "p": 5},
            "kernel_value": str(actual), "prefix": str(prefix),
            "finite_remainder": str(difference)}


def certificate():
    return {
        "schema_version": 1,
        "claim_id": "C9000378-TENSOR-STEP",
        "result_kind": "universal_one_step_verification_theorem",
        "universal_proof": "research/tensor_modes/proof.md",
        "formal_core": "research/tensor_modes/Main.lean",
        "statement_fidelity": "research/tensor_modes/statement_fidelity.md",
        "finite_replay_is_not_universal_proof": True,
        "independent_review_required": True,
        "novelty_status": "not_established",
        "full_counting_algorithm_certified": False,
        "kernel_replay": kernel_replay(),
        "network_replays": network_cases(),
        "load_admissible_child_size_replays": child_size_replay(),
        "jacobian_replay": jacobian_replay(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = certificate()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    else:
        expected = json.loads(target.read_text())
        check(actual == expected, "exact certificate mismatch")
    print(json.dumps({"ok": True, "claim_id": actual["claim_id"],
                      "kernel_replay": actual["kernel_replay"],
                      "network_replays": actual["network_replays"],
                      "load_admissible_child_size_replays": actual["load_admissible_child_size_replays"],
                      "jacobian_replay": actual["jacobian_replay"]}, sort_keys=True))


if __name__ == "__main__":
    main()
