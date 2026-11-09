#!/usr/bin/env python3
"""Replay exact geometric fixtures and the archived universal Lean certificate."""

import argparse
from dataclasses import dataclass
from fractions import Fraction
from functools import total_ordering
from itertools import combinations, product
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
PROJECT = ROOT.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


@total_ordering
@dataclass(frozen=True, eq=False)
class Q5:
    a: Fraction = Fraction(0)
    b: Fraction = Fraction(0)

    def __post_init__(self):
        object.__setattr__(self, "a", Fraction(self.a))
        object.__setattr__(self, "b", Fraction(self.b))

    @staticmethod
    def coerce(value):
        return value if isinstance(value, Q5) else Q5(value)

    def __eq__(self, other):
        if not isinstance(other, (Q5, int, Fraction)):
            return NotImplemented
        other = self.coerce(other)
        return self.a == other.a and self.b == other.b

    def __hash__(self):
        return hash(self.a) if self.b == 0 else hash((self.a, self.b))

    def __add__(self, other):
        other = self.coerce(other)
        return Q5(self.a + other.a, self.b + other.b)

    __radd__ = __add__

    def __neg__(self):
        return Q5(-self.a, -self.b)

    def __sub__(self, other):
        return self + -self.coerce(other)

    def __rsub__(self, other):
        return self.coerce(other) - self

    def __mul__(self, other):
        other = self.coerce(other)
        return Q5(self.a * other.a + 5 * self.b * other.b,
                  self.a * other.b + self.b * other.a)

    __rmul__ = __mul__

    def conjugate(self):
        return Q5(self.a, -self.b)

    def __truediv__(self, other):
        other = self.coerce(other)
        norm = other.a * other.a - 5 * other.b * other.b
        if norm == 0:
            raise ZeroDivisionError("division by zero in Q(sqrt(5))")
        value = self * other.conjugate()
        return Q5(value.a / norm, value.b / norm)

    def __rtruediv__(self, other):
        return self.coerce(other) / self

    def __pow__(self, exponent):
        if exponent < 0:
            return (1 / self) ** (-exponent)
        value, base = Q5(1), self
        while exponent:
            if exponent % 2:
                value *= base
            base *= base
            exponent //= 2
        return value

    def sign(self):
        if self.b == 0:
            return (self.a > 0) - (self.a < 0)
        if self.a == 0:
            return (self.b > 0) - (self.b < 0)
        if (self.a > 0) == (self.b > 0):
            return 1 if self.a > 0 else -1
        difference = self.a * self.a - 5 * self.b * self.b
        require(difference != 0, "irrationality of sqrt(5) violated")
        return (1 if self.a > 0 else -1) * (1 if difference > 0 else -1)

    def __lt__(self, other):
        return (self - other).sign() < 0

    def __abs__(self):
        return -self if self.sign() < 0 else self

    def encoded(self):
        return {"rational_part": str(self.a), "sqrt5_coefficient": str(self.b)}


ZERO, ONE = Q5(), Q5(1)
TAU = Q5(Fraction(1, 2), Fraction(1, 2))


def dot(row, point):
    return row[0] * point[0] + row[1] * point[1]


def forms(lam):
    return ((ONE, ZERO), (ZERO, ONE), (-lam, ONE), (ONE, -lam))


def determinant(row, other):
    return row[0] * other[1] - row[1] * other[0]


def intersection(row, other, c, d):
    det = determinant(row, other)
    require(det != 0, "parallel lines passed to intersection")
    return ((c * other[1] - row[1] * d) / det,
            (row[0] * d - c * other[0]) / det)


def in_ring(value):
    return (value.a - value.b).denominator == 1 and (2 * value.b).denominator == 1


def check_arithmetic():
    cases = 0
    denominators = {}
    for exponent in (1, 2, 20, 37):
        lam = TAU ** exponent
        rows = forms(lam)
        expected = (ONE, ONE, -lam, lam, -ONE, lam * lam - 1)
        norm = (lam * lam - 1) * (lam * lam - 1).conjugate()
        require(norm.b == 0 and norm.a.denominator == 1 and norm != 0,
                "nonzero integral determinant norm")
        denominator = abs(norm.a.numerator)
        denominators[str(exponent)] = str(denominator)
        require(in_ring(1 / lam), "lambda must be a unit")
        for index, (j, k) in enumerate(combinations(range(4), 2)):
            require(determinant(rows[j], rows[k]) == expected[index],
                    "signed pair determinant mismatch")
            c, d = TAU - 1, 2 - TAU
            point = intersection(rows[j], rows[k], c, d)
            require(dot(rows[j], point) == c and dot(rows[k], point) == d,
                    "intersection equations")
            require(all(in_ring(denominator * z) for z in point),
                    "common denominator does not clear a vertex")
            conjugated = intersection(tuple(x.conjugate() for x in rows[j]),
                                      tuple(x.conjugate() for x in rows[k]),
                                      c.conjugate(), d.conjugate())
            require(conjugated == tuple(z.conjugate() for z in point),
                    "conjugate core equation")
            cases += 1
    return {"exact_intersection_cases": cases, "common_denominators": denominators}


def barrier(marks, active, point):
    ordered = sorted(marks)
    return any(p <= point <= q and active.get(p, False)
               for p, q in zip(ordered, ordered[1:]))


def check_intervals():
    a, b = ZERO, ONE
    interior = (2 - TAU, TAU - 1)
    breakpoints = (a, *interior, b)
    probes = (*interior, *((p + q) / 2 for p, q in zip(breakpoints, breakpoints[1:])))
    cases = 0
    for marked_bits in product((False, True), repeat=2):
        inside_marks = {a, b} | {p for p, bit in zip(interior, marked_bits) if bit}
        for activation in product((False, True), repeat=3):
            shared = dict(zip((a, *interior), activation))
            for outside_marks in product((False, True), repeat=4):
                source = inside_marks | {p for p, bit in
                                         zip((-ONE, TAU), outside_marks[:2]) if bit}
                target = inside_marks | {p for p, bit in
                                         zip((-TAU, Q5(2)), outside_marks[2:]) if bit}
                for terminal_bits in product((False, True), repeat=2):
                    source_active = {**shared, b: terminal_bits[0]}
                    target_active = {**shared, b: terminal_bits[1], -TAU: True, Q5(2): True}
                    for point in probes:
                        expected = barrier(inside_marks, shared, point)
                        require(barrier(source, source_active, point) == expected,
                                "source clipping failed")
                        require(barrier(target, target_active, point) == expected,
                                "destination clipping or outgoing-bit independence failed")
                    cases += 1
    midpoint = ONE / 2
    require(barrier({a, b}, {a: True}, midpoint) !=
            barrier({-ONE, b}, {-ONE: False}, midpoint),
            "negative control must detect a missing incoming mark")
    require(barrier({a, b}, {a: True}, midpoint) !=
            barrier({a, b}, {a: False}, midpoint),
            "negative control must detect an untransported initial bit")
    return {"finite_fixture_cases": cases, "probes_per_case": len(probes),
            "negative_controls_detected": 2,
            "proof_of_unbounded_statement": "PartitionTransport.barrier_transport"}


def flag_sign(d, v, w):
    return next((z.sign() for z in (d, v, w) if z != 0), 0)


def add(point, vector):
    return tuple(x + y for x, y in zip(point, vector))


def flagged_exchange(point, tangent, transverse):
    h, c = TAU - 1, 2 - TAU
    shift = tuple(-c if flag_sign(x - c, v, w) > 0 else h
                  for x, v, w in zip(point, tangent, transverse))
    return add(point, shift), shift


def check_flags_and_cutoff():
    lam, h, c = TAU ** 2, TAU - 1, 2 - TAU
    rows = forms(lam)
    tangents = ((ZERO, ONE), (ONE, ZERO), (ONE, lam), (lam, ONE))
    transverse = ((ONE, ZERO), (ZERO, ONE), (ZERO, ONE), (ONE, ZERO))
    require(all(dot(row, w) != 0 for row, w in zip(rows, transverse)),
            "invalid tangent flag")
    p = (c, c)
    for j, k in combinations(range(4), 2):
        require(intersection(rows[j], rows[k], dot(rows[j], p), dot(rows[k], p)) == p,
                "four-way concurrent vertex")
    entering = (ONE, lam)
    signed_edges = (rows[0], rows[1], tuple(-x for x in rows[3]))
    require(all(dot(edge, entering) > 0 for edge in signed_edges),
            "tangent does not enter all three concurrent half-planes")
    image, _ = flagged_exchange(p, entering, transverse[2])
    require(image == (ZERO, ZERO), "incoming vertex must land on the entering square corner")
    reversed_image, _ = flagged_exchange(p, tuple(-x for x in entering), transverse[2])
    require(reversed_image == (ONE, ONE), "reverse tangent must use the other square representative")
    endpoint = (c / lam, c)
    initial_shift = (h, h)
    preceding_terminal = add(endpoint, initial_shift)
    outgoing_flag_image, _ = flagged_exchange(endpoint, entering, transverse[2])
    require(preceding_terminal[1] == 1 and outgoing_flag_image[1] == 0 and
            preceding_terminal != outgoing_flag_image,
            "fixture must distinguish terminal location from outgoing flag image")
    N, Q = Q5(8), Q5(3, 1)
    require(Q < N, "buffer scale")
    for u in product((h, -c), repeat=2):
        require(all(abs(dot(row, u).conjugate()) <= Q for row in rows),
                "Q does not bound all chart and seam translations")
    level = -22 + 14 * TAU
    translated = level - c
    require(c < level < 1 and 0 < translated < h,
            "cutoff lines must meet corresponding open square charts")
    require(abs(level.conjugate()) <= 4 * N and
            abs(translated.conjugate()) > 4 * N and
            abs(level.conjugate()) > 3 * N,
            "exact candidate mismatch and negative-band check")
    B = max(abs(z.conjugate()) for z in (ZERO, ONE, h, c))
    R0 = Q5(20)
    core_checks = 0
    for j, k in product(range(4), range(2)):
        if j == k:
            continue
        conjugated_rows = [tuple(z.conjugate() for z in row) for row in rows]
        for candidate_level, chart_level in product((-(4 * N + Q), 4 * N + Q), (-B, B)):
            vertex = intersection(conjugated_rows[j], conjugated_rows[k],
                                  candidate_level, chart_level)
            require(max(abs(z) for z in vertex) + 1 <= R0 * N,
                    "core does not cover enlarged candidates and representative corrections")
            core_checks += 1
    return {
        "concurrent_directions": 4,
        "simultaneous_entered_half_planes": 3,
        "opposite_tangent_square_representatives_checked": True,
        "outgoing_flag_differs_from_preceding_terminal": True,
        "core_extreme_checks": core_checks,
        "N": 8,
        "Q": Q.encoded(),
        "R0": 20,
        "candidate_level": level.encoded(),
        "translated_non_candidate_level": translated.encoded(),
        "mismatch_present_line_is_inactive": True
    }


def area_twice(polygon):
    return sum((p[0] * q[1] - p[1] * q[0]
                for p, q in zip(polygon, polygon[1:] + polygon[:1])), ZERO)


def canonical(polygon):
    points = []
    for point in polygon:
        if not points or point != points[-1]:
            points.append(point)
    if len(points) > 1 and points[0] == points[-1]:
        points.pop()
    if len(points) < 3 or area_twice(points) == 0:
        return ()
    require(area_twice(points) > 0, "polygon orientation reversed")
    start = min(range(len(points)), key=points.__getitem__)
    return tuple(points[start:] + points[:start])


def clip(polygon, row, level):
    output = []
    for p, q in zip(polygon, polygon[1:] + polygon[:1]):
        dp, dq = dot(row, p) - level, dot(row, q) - level
        if dp >= 0:
            output.append(p)
        if (dp < 0 < dq) or (dq < 0 < dp):
            t = dp / (dp - dq)
            output.append(tuple(x + t * (y - x) for x, y in zip(p, q)))
    return canonical(output)


def grid(cuts):
    return [(track, i, j, ((x0, y0), (x1, y0), (x1, y1), (x0, y1)))
            for track in (1, 2)
            for i, (x0, x1) in enumerate(zip(cuts, cuts[1:]))
            for j, (y0, y1) in enumerate(zip(cuts, cuts[1:]))]


def split_cell(cells, track, i, j, row, level):
    output = []
    for cell_track, cell_i, cell_j, polygon in cells:
        if (cell_track, cell_i, cell_j) != (track, i, j):
            output.append((cell_track, cell_i, cell_j, polygon))
            continue
        for signed_row, signed_level in ((row, level), (tuple(-z for z in row), -level)):
            piece = clip(polygon, signed_row, signed_level)
            if piece:
                output.append((cell_track, cell_i, cell_j, piece))
    return output


def check_partitions():
    lam, h, c = TAU ** 2, TAU - 1, 2 - TAU
    rows = forms(lam)
    source = grid((ZERO, c, h, 2 * c, ONE))
    target = grid((ZERO, 2 * h - 1, c, h, ONE))
    source = split_cell(source, 1, 0, 0, rows[2], ZERO)
    target = split_cell(target, 2, 3, 3, rows[2], dot(rows[2], (h, h)))
    for j in (2, 3):
        source = split_cell(source, 1, 1, 1, rows[j], dot(rows[j], (c, c)))
        target = split_cell(target, 2, 0, 0, rows[j], ZERO)
    transported = set()
    for track, _, _, polygon in source:
        coordinates = tuple(zip(*polygon))
        require(all(max(axis) <= c or min(axis) >= c for axis in coordinates),
                "a source cell crosses a chart")
        centroid = tuple(sum(axis, ZERO) / len(axis) for axis in coordinates)
        u = tuple(h if z < c else -c for z in centroid)
        transported.add((3 - track, canonical([add(p, u) for p in polygon])))
    target_cells = {(track, canonical(list(polygon))) for track, _, _, polygon in target}
    require(transported == target_cells, "track-labelled polygon partition transport failed")
    require(len(source) == len(target) == len(transported) == 35, "unexpected cell count")
    for name, cells in (("source", source), ("destination", target)):
        require(sum((area_twice(p) for _, _, _, p in cells), ZERO) == 4,
                name + " partition has incorrect total area")
    return {"tracks": 2, "source_cells": 35, "destination_cells": 35,
            "chart_containment": True, "exact_translated_polygon_sets_equal": True,
            "total_area_each": "2",
            "fixture_scope": "finite geometric instance of the abstract theorem, not a random-field-law sample"}


def check_jacobian():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    response = json.loads((ROOT / "jacobian_output.json").read_text())
    require(response["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(response["result"]["operation_id"] == "arithmetic.real_quadratic.order.compute",
            "unexpected Jacobian operation")
    result = response["result"]["output"]
    require(result["order"] == "GT" and
            result["difference"]["rational_part"] == {"num": "5", "den": "1"} and
            result["difference"]["radical_coefficient"] == {"num": "-1", "den": "1"} and
            Q5(29, -1) > Q5(24), "Jacobian cutoff comparison disagrees with exact replay")
    return {"operation_id": response["result"]["operation_id"],
            "server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"],
            "adapter_exit_code": 0, "adapter_error": None, "timeout": False,
            "order": "GT", "payload_file": "jacobian_payload.json",
            "typed_output_file": "jacobian_output.json",
            "scope": "one exact cutoff comparison, not a general arrangement solver"}


def check_lean_archive():
    result = json.loads((ROOT / "lean_result.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0 and
            result["proof_holes"] == [], "Lean did not certify a hole-free proof")
    record = result["kernel"]["recorded"]
    require(record is not None, "compiler outcome was not recorded in the ledger")
    archive_path = PROJECT / record["artifact"]
    archive = json.loads(archive_path.read_text())
    require(archive["lean_source"]["text"] == (ROOT / "Main.lean").read_text(),
            "Lean source differs from the archived compiler evidence")
    require(archive["statement_fidelity"]["text"] == (ROOT / "statement_fidelity.md").read_text(),
            "statement fidelity differs from the archived compiler evidence")
    require(archive["lean_check"]["status"] == "success" and
            archive["subject"]["subject_id"] == "C_INTERVAL",
            "wrong claim or unsuccessful archived compiler result")
    version = result["tools"]["lean"]["version"]
    require("4.31.0" in version, "Lean compiler version is not 4.31.0")
    return {"claim": "C_INTERVAL", "compiler_version": version,
            "exit_code": 0, "proof_holes": [], "archive": record["artifact"],
            "source_and_fidelity_match_archive": True,
            "scope": "universal interval, tangent-flag and cutoff lemmas; geometry remains a prose proof"}


def replay():
    return {
        "claim": "C_PT",
        "result_class": "uniform_verification_theorem",
        "arithmetic": "Q(sqrt(5)); rational coefficients and integer squared-sign tests only",
        "arithmetic_checks": check_arithmetic(),
        "interval_checks": check_intervals(),
        "geometry_checks": check_flags_and_cutoff(),
        "partition_checks": check_partitions(),
        "jacobian": check_jacobian(),
        "formal_core": check_lean_archive(),
        "full_theorem_proof": "transport_theorem.md",
        "independent_review": "pending_host_reviewer",
        "novelty_status": "not_claimed",
        "main_theorem_verified": False,
        "probabilistic_lemma_verified": False,
        "campaign_complete": False
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    arguments = parser.parse_args()
    actual = replay()
    path = ROOT / "exact_certificate.json"
    if arguments.write_certificate:
        path.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(path.read_text()) == actual, "stored exact certificate differs from replay")
    print(json.dumps({"ok": True, "claim": actual["claim"],
                      "interval_fixture_cases": actual["interval_checks"]["finite_fixture_cases"],
                      "transported_cells": actual["partition_checks"]["source_cells"],
                      "formal_core_exit": actual["formal_core"]["exit_code"],
                      "independent_review": actual["independent_review"],
                      "campaign_complete": False}, sort_keys=True))
