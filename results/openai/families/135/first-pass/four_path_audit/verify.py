#!/usr/bin/env python3
"""Replay exact finite checks; the universal proof is in report.md and Main.lean."""

import argparse
from collections import defaultdict
from dataclasses import dataclass
from fractions import Fraction
from functools import lru_cache
from itertools import product
import json
from math import comb, factorial, isqrt, prod
from pathlib import Path


HERE = Path(__file__).resolve().parent


@lru_cache(maxsize=None)
def compositions(total, parts):
    if parts == 1:
        return ((total,),)
    return tuple(
        (first,) + rest
        for first in range(total + 1)
        for rest in compositions(total - first, parts - 1)
    )


def falling(t, h):
    return prod(t - j for j in range(h)) if h <= t else 0


def rising(t, h):
    return prod(t + j for j in range(h))


def monomial_gram(exponent):
    return prod(factorial(x) for x in exponent)


@dataclass(frozen=True)
class MatrixPath:
    vertices: tuple
    coordinates: tuple
    shift: tuple


def paths(width, schedule):
    k = schedule.count("V")
    v, u = k * width**2, schedule.count("U") * width**2
    bases = []
    next_v, next_u = 0, v
    for group in schedule:
        if group == "V":
            bases.append(next_v)
            next_v += width**2
        else:
            bases.append(next_u)
            next_u += width**2
    result = []
    for internal in product(range(width), repeat=len(schedule) - 1):
        vertices = (0,) + internal + (0,)
        coordinates = tuple(
            base + vertices[t] * width + vertices[t + 1]
            for t, base in enumerate(bases)
        )
        shift = [0] * (v + u)
        for group, coordinate in zip(schedule, coordinates):
            shift[coordinate] += -1 if group == "V" else 1
        result.append(MatrixPath(vertices, coordinates, tuple(shift)))
    return tuple(result), v, u


def ordinary_matrix_traces(path_list, schedule, v, u, a, b):
    domain = tuple(x + y for x in compositions(a, v) for y in compositions(b, u))
    rows = defaultdict(lambda: defaultdict(int))
    for column, exponent in enumerate(domain):
        for path in path_list:
            output, coefficient = list(exponent), 1
            for group, coordinate in zip(schedule, path.coordinates):
                if group == "V":
                    coefficient *= output[coordinate]
                    output[coordinate] -= 1
                    if coefficient == 0:
                        break
                else:
                    output[coordinate] += 1
            if coefficient:
                assert min(output) >= 0
                assert sum(output[:v]) == a - schedule.count("V")
                assert sum(output[v:]) == b + schedule.count("U")
                rows[tuple(output)][column] += coefficient
    gram_domain = tuple(monomial_gram(exponent) for exponent in domain)
    h = defaultdict(Fraction)
    for output, entries in rows.items():
        gram_output = monomial_gram(output)
        for i, ci in entries.items():
            for j, cj in entries.items():
                h[i, j] += Fraction(ci * gram_output * cj, gram_domain[i])
    trace = sum(h[i, i] for i in range(len(domain)))
    trace2 = sum(value * h[j, i] for (i, j), value in tuple(h.items()))
    return domain, trace, trace2, len(rows), sum(map(len, rows.values()))


def squared_amplitude(path, exponent, schedule):
    if any(x < 0 for x in exponent):
        return 0
    return prod(
        exponent[i] if group == "V" else exponent[i] + 1
        for group, i in zip(schedule, path.coordinates)
    )


def compatible_quadruples(path_list):
    pairs = defaultdict(list)
    for p, q in product(path_list, repeat=2):
        delta = tuple(x - y for x, y in zip(p.shift, q.shift))
        pairs[delta].append((p, q))
    return tuple(
        (p, q, r, s, delta)
        for delta, pair_list in pairs.items()
        for (p, q), (r, s) in product(pair_list, repeat=2)
    )


def local_data(quadruple, schedule):
    p, q, r, s, _ = quadruple
    result = []
    for group, i, j, x, y in zip(
        schedule, p.coordinates, q.coordinates, r.coordinates, s.coordinates
    ):
        if i == j:
            assert x == y
            result.append((group, "N", i, x))
        else:
            assert i == x and j == y
            result.append((group, "D", i, j))
    return tuple(result)


def local_polynomial(data, exponent):
    value = 1
    for group, pairing, i, j in data:
        x, y = exponent[i], exponent[j]
        if group == "V":
            value *= x * (y if pairing == "N" else y + 1)
        else:
            value *= (x + 1) * (y + 1 if pairing == "N" else y)
    return value


def local_geometric(data, a_mean, b_mean):
    value = Fraction(1)
    for group, pairing, i, j in data:
        if group == "V":
            if pairing == "D":
                value *= a_mean * (1 + a_mean)
            else:
                value *= 2 * a_mean**2 + a_mean if i == j else a_mean**2
        elif pairing == "D":
            value *= b_mean * (1 + b_mean)
        else:
            value *= (
                2 * b_mean**2 + 3 * b_mean + 1
                if i == j
                else (1 + b_mean) ** 2
            )
    return value


def vertex_choices(left, right, width):
    if left != right:
        return tuple((i, i, i, i) for i in range(width))
    if left == "N":
        return tuple((i, i, j, j) for i, j in product(range(width), repeat=2))
    return tuple((i, j, i, j) for i, j in product(range(width), repeat=2))


def relaxed_vertices(word, width):
    choices = tuple(vertex_choices(x, y, width) for x, y in zip(word, word[1:]))
    return tuple(
        ((0, 0, 0, 0),) + internal + ((0, 0, 0, 0),)
        for internal in product(*choices)
    )


def event_at(vertices, layer):
    return (
        vertices[layer][0] == vertices[layer][2]
        and vertices[layer + 1][0] == vertices[layer + 1][2]
    )


def support(word, layer):
    return frozenset(
        j for j in (layer - 1, layer)
        if 0 <= j < len(word) - 1 and word[j] == word[j + 1] == "N"
    )


def valid_schedule(schedule):
    return "VV" not in schedule and "V" in schedule and "U" in schedule


def word_bound(width, schedule, alpha, beta):
    result = Fraction(0)
    for word in product("ND", repeat=len(schedule)):
        switches = sum(x != y for x, y in zip(word, word[1:]))
        value = Fraction(1, width**switches)
        for t, (group, pairing) in enumerate(zip(schedule, word)):
            if pairing == "D":
                value *= 1 / alpha if group == "V" else beta
            elif group == "V":
                value *= 1 + 1 / (alpha * width ** len(support(word, t)))
        result += value
    return (1 + beta) ** schedule.count("U") * result


def relaxed_weight_sum(width, schedule, alpha, beta):
    result = Fraction(0)
    for word in product("ND", repeat=len(schedule)):
        for vertices in relaxed_vertices(word, width):
            weight = Fraction(1)
            for t, (group, pairing) in enumerate(zip(schedule, word)):
                if pairing == "D":
                    weight *= 1 / alpha if group == "V" else beta
                elif group == "V":
                    weight *= 1 + int(event_at(vertices, t)) / alpha
                else:
                    weight *= 1 + beta * int(event_at(vertices, t))
            result += weight
    return result


def check_trace_case(width, schedule, a, b):
    path_list, v, u = paths(width, schedule)
    domain, trace, trace2, rows, entries = ordinary_matrix_traces(
        path_list, schedule, v, u, a, b
    )
    k, m = schedule.count("V"), schedule.count("U")
    dimension = comb(v + a - 1, a) * comb(u + b - 1, b)
    assert len(domain) == dimension
    a_mean, b_mean = Fraction(a, v), Fraction(b, u)
    alpha, beta = a_mean / (1 + a_mean), b_mean / (1 + b_mean)
    mu2 = (a_mean**k * (1 + b_mean) ** m) ** 2
    expected_trace = (
        dimension * width ** (len(schedule) - 1)
        * Fraction(falling(a, k), rising(v, k))
        * sum(
            comb(m, j) * Fraction(falling(b, j), rising(u, j))
            for j in range(m + 1)
        )
    )
    assert trace == expected_trace and trace > 0
    direct, geometric = 0, Fraction(0)
    zero_contributions, invalid_shifts, repeated_n = 0, 0, 0
    quadruples = compatible_quadruples(path_list)
    for quadruple in quadruples:
        p, q, r, s, delta = quadruple
        data = local_data(quadruple, schedule)
        geometric += local_geometric(data, a_mean, b_mean)
        repeated_n += sum(pairing == "N" and i == j for _, pairing, i, j in data)
        for exponent in domain:
            shifted = tuple(x + dx for x, dx in zip(exponent, delta))
            squared = (
                squared_amplitude(p, exponent, schedule)
                * squared_amplitude(q, shifted, schedule)
                * squared_amplitude(r, exponent, schedule)
                * squared_amplitude(s, shifted, schedule)
            )
            contribution = isqrt(squared)
            assert contribution**2 == squared
            assert contribution == local_polynomial(data, exponent)
            direct += contribution
            zero_contributions += contribution == 0
            invalid_shifts += any(x < 0 for x in shifted)
    assert trace2 == direct
    relaxed = relaxed_weight_sum(width, schedule, alpha, beta)
    bound = word_bound(width, schedule, alpha, beta)
    path_square = width ** (2 * (len(schedule) - 1))
    assert trace2 <= dimension * geometric
    assert geometric / mu2 <= relaxed <= path_square * bound
    active = set(i for path in path_list for i in path.coordinates)
    return {
        "width": width, "schedule": schedule, "a": a, "b": b,
        "v": v, "u": u, "domain_dimension": dimension,
        "codomain_dimension": comb(v + a - k - 1, a - k) * comb(u + b + m - 1, b + m),
        "nonzero_matrix_rows": rows, "nonzero_matrix_entries": entries,
        "inactive_coordinates": v + u - len(active),
        "compatible_quadruples": len(quadruples),
        "zero_four_path_contributions": zero_contributions,
        "invalid_shift_contributions": invalid_shifts,
        "repeated_N_layer_occurrences": repeated_n,
        "T_matrix_and_exact_formula": str(trace),
        "T2_matrix_and_four_path": str(trace2),
        "geometric_upper_T2": str(dimension * geometric),
        "relaxed_upper_T2": str(dimension * mu2 * relaxed),
        "moment_reduction_upper_T2": str(dimension * path_square * mu2 * bound),
    }


def check_compositions():
    cases = 0
    for parts in range(1, 5):
        for total in range(6):
            population = compositions(total, parts)
            for order in range(7):
                for degrees in compositions(order, parts):
                    observed = Fraction(
                        sum(prod(falling(x, h) for x, h in zip(c, degrees)) for c in population),
                        len(population),
                    )
                    expected = (
                        Fraction(falling(total, order), rising(parts, order))
                        * prod(factorial(h) for h in degrees)
                    )
                    geometric = Fraction(total, parts) ** order * prod(
                        factorial(h) for h in degrees
                    )
                    assert observed == expected and observed <= geometric
                    cases += 1
    for z in range(10):
        assert z*z == falling(z, 2) + z
        assert (z+1)**2 == falling(z, 2) + 3*z + 1
    return cases


def check_pairing_core():
    records, factorizations = [], 0
    for width, max_length in ((1, 5), (2, 4), (3, 3)):
        for length in range(1, max_length + 1):
            raw_paths, _, _ = paths(width, "U" * length)
            for word in product("ND", repeat=length):
                assignments = relaxed_vertices(word, width)
                switches = sum(x != y for x, y in zip(word, word[1:]))
                expected_count = width ** (2 * (length - 1) - switches)
                direct_count = 0
                for p, q, r, s in product(raw_paths, repeat=4):
                    direct_count += all(
                        (p.coordinates[t] == q.coordinates[t] and r.coordinates[t] == s.coordinates[t])
                        if word[t] == "N"
                        else (p.coordinates[t] == r.coordinates[t] and q.coordinates[t] == s.coordinates[t])
                        for t in range(length)
                    )
                assert len(assignments) == direct_count == expected_count
                for mask in product((False, True), repeat=length):
                    if any(x and y for x, y in zip(mask, mask[1:])):
                        continue
                    layers = tuple(t for t in range(length) if mask[t] and word[t] == "N")
                    supports = tuple(support(word, t) for t in layers)
                    assert all(
                        supports[i].isdisjoint(supports[j])
                        for i in range(len(layers)) for j in range(i)
                    )
                    coefficients = {t: Fraction((-1)**t * (t + 2), 3) for t in layers}
                    observed = Fraction(
                        sum(
                            prod(1 + coefficients[t] * int(event_at(x, t)) for t in layers)
                            for x in assignments
                        ),
                        len(assignments),
                    )
                    expected = prod(
                        1 + coefficients[t] * Fraction(1, width ** len(support(word, t)))
                        for t in layers
                    )
                    assert observed == expected
                    factorizations += 1
                records.append({
                    "width": width, "word": "".join(word),
                    "switches": switches, "relaxed_quadruples": expected_count,
                })
    assignments = relaxed_vertices("NNN", 2)
    adjacent_average = Fraction(
        sum((1 + int(event_at(x, 0))) * (1 + int(event_at(x, 1))) for x in assignments),
        len(assignments),
    )
    unjustified_product = (1 + Fraction(1, 2)) * (1 + Fraction(1, 4))
    assert adjacent_average == 2 and unjustified_product == Fraction(15, 8)
    return records, factorizations, {
        "scope": "Counterexample only to removing the no-adjacent-V hypothesis; not a manuscript refutation.",
        "width": 2, "schedule": "VVU", "pairing_word": "NNN",
        "actual_average": str(adjacent_average),
        "incorrect_independent_product": str(unjustified_product),
    }


def check_jacobian():
    response = json.loads((HERE / "jacobian_result.json").read_text())
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    operation = "matrix.symbolic.multiply.compute"
    assert response["request"] == {"operation_id": operation, "payload": payload}
    assert response["result"]["operation_id"] == operation
    assert response["server"]["version"] == "0.14.0"
    assert response["protocol_version"] == "2025-11-25"
    expected = (({4: 1, 2: 1}, {3: 2}), ({3: 2}, {4: 1, 2: 1}))
    output = response["result"]["output"]
    assert output["variables"] == ["w"]
    assert len(output["entries"]) == 2
    for row, expected_row in zip(output["entries"], expected):
        assert len(row) == 2
        for entry, coefficients in zip(row, expected_row):
            assert entry["domain"] == "QQ" and entry["variables"] == ["w"]
            assert entry["denominator"]["terms"] == [
                {"coefficient": {"num": "1", "den": "1"}, "exponents": [0]}
            ]
            assert {
                term["exponents"][0]: Fraction(
                    int(term["coefficient"]["num"]), int(term["coefficient"]["den"])
                )
                for term in entry["numerator"]["terms"]
            } == coefficients
    return {
        "operation_id": operation, "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"], "adapter_status": "success",
        "structured_error": None,
        "identity": "[[w^2,w],[w,w^2]]^2=[[w^4+w^2,2*w^3],[2*w^3,w^4+w^2]]",
        "payload_file": "jacobian_payload.json", "typed_output_file": "jacobian_result.json",
    }


def verify():
    occupation_cases = check_compositions()
    pairing_records, factorizations, adjacent_boundary = check_pairing_core()
    cases = []
    for width in (1, 2):
        for length in range(2, 5):
            for letters in product("VU", repeat=length):
                schedule = "".join(letters)
                if valid_schedule(schedule):
                    cases.append((width, schedule, schedule.count("V"), 1))
    cases += [(3, "VU", 1, 1), (3, "UV", 1, 1), (2, "VU", 2, 2), (2, "UVU", 2, 2)]
    trace_records = [check_trace_case(*case) for case in cases]
    for coverage in (
        "inactive_coordinates", "invalid_shift_contributions",
        "zero_four_path_contributions", "repeated_N_layer_occurrences",
    ):
        assert sum(row[coverage] for row in trace_records) > 0, coverage
    return {
        "claim": "C_FP_REDUCTION",
        "finite_evidence_class": "finite_verification",
        "universal_proof": {
            "mathematical_proof": "report.md",
            "formal_core": "Main.lean",
            "statement_fidelity": "statement_fidelity.md",
            "qualification": "Finite checks do not prove the universal theorem or the asymptotic circuit lower bound. Use the actual Lean compiler certificate and independent Reviewer verdict separately.",
        },
        "occupation_moment_cases": occupation_cases,
        "pairing_count_cases": pairing_records,
        "disjoint_support_factorization_cases": factorizations,
        "trace_cases": trace_records,
        "out_of_scope_adjacent_boundary": adjacent_boundary,
        "jacobian": check_jacobian(),
        "manuscript_refutations_established": [],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = verify()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
        status = "written"
    else:
        assert json.loads(target.read_text()) == result, "The saved exact certificate does not replay."
        status = "replayed"
    print(
        f"Exact certificate {status}: {len(result['trace_cases'])} factorial-Gram trace cases, "
        f"{len(result['pairing_count_cases'])} pairing words, "
        f"{result['disjoint_support_factorization_cases']} factorization cases, "
        f"{result['occupation_moment_cases']} occupation moments."
    )


if __name__ == "__main__":
    main()
