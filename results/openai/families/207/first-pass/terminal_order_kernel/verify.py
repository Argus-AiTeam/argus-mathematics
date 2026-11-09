#!/usr/bin/env python3
"""Replay exact algebra and boundary regressions, not replace the analytic proof."""

import hashlib
import json
import math
from dataclasses import dataclass
from fractions import Fraction as F
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
Label = tuple[int, int]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


@dataclass(frozen=True)
class Cell:
    label: Label
    left: F
    right: F
    mass: F

    @property
    def length(self) -> F:
        return self.right - self.left


def below_area(a: F, b: F, c: F, d: F) -> F:
    """Lebesgue area of v<u in (a,b) x (c,d)."""
    lo, hi = max(a, c), min(b, d)
    ramp = ((hi - c) ** 2 - (lo - c) ** 2) / 2 if lo < hi else F(0)
    return ramp + max(F(0), b - max(a, d)) * (d - c)


def lag_area(out: Cell, inp: Cell, shift: int, truncated: bool) -> F:
    def sublevel(cut: int) -> F:
        return below_area(
            out.left, out.right, inp.left + shift - cut, inp.right + shift - cut
        )

    if truncated:
        return sublevel(1) - 2 * sublevel(0) + sublevel(-1)
    return out.length * inp.length - 2 * sublevel(0)


def weighted_area(out: Cell, inp: Cell, area: F) -> F:
    return area * out.mass * inp.mass / (out.length * inp.length)


def inertia(matrix: list[list[F]]) -> tuple[int, int, int]:
    """Exact symmetric congruence, including zero-diagonal two-by-two pivots."""
    a = [row[:] for row in matrix]
    require(all(a[i][j] == a[j][i] for i in range(len(a)) for j in range(len(a))),
            "inertia input is not symmetric")
    positive = negative = zero = 0
    while a:
        n = len(a)
        pivot = next((i for i in range(n) if a[i][i] != 0), None)
        if pivot is not None:
            d = a[pivot][pivot]
            positive += d > 0
            negative += d < 0
            rest = [i for i in range(n) if i != pivot]
            a = [[a[i][j] - a[i][pivot] * a[pivot][j] / d for j in rest]
                 for i in rest]
            continue
        pair = next(((i, j) for i in range(n) for j in range(i + 1, n)
                     if a[i][j] != 0), None)
        if pair is None:
            zero += n
            break
        p, q = pair
        d = a[p][q]
        rest = [i for i in range(n) if i not in (p, q)]
        a = [[a[i][j] - (a[i][p] * a[q][j] + a[i][q] * a[p][j]) / d
              for j in rest] for i in rest]
        positive += 1
        negative += 1
    return positive, negative, zero


def norm_comparison(pairing: list[list[F]], output_masses: list[F],
                    input_masses: list[F], bound_squared: F) -> list[list[F]]:
    n = len(input_masses)
    return [[(bound_squared * input_masses[j] if j == k else F(0))
             - sum((pairing[i][j] * pairing[i][k] / output_masses[i]
                    for i in range(len(output_masses))), F(0))
             for k in range(n)] for j in range(n)]


def symbolic_checks(cert: dict) -> int:
    p, q, h, slack, x, m, nu, n, gap, z, k = sp.symbols(
        "p q h slack x m nu n gap z k", positive=True
    )
    rank = q + 1 - slack
    identities = {
        "two_measure_am_gm": (p + q) ** 2 - 4 * p * q - (p - q) ** 2,
        "ceiling_rank_budget": (2 * q - rank - (h + slack)).subs(q, 1 + h),
        "allocation_error": 2 * x * n - 2 * x * (n - gap) - 2 * x * gap,
        "three_contribution_rank": 3 * (2 * m / (x / 3)) - 18 * m / x,
        "three_contribution_error": 3 * (x / 3) - x,
        "free_compression_threshold": 2 * m / (4 * m / nu) - nu / 2,
        "truncated_compression_threshold": 18 * m / (36 * m / nu) - nu / 2,
        "pfaffian_product_recurrence":
            (z ** k / sp.factorial(k)) * z / (k + 1)
            - z ** (k + 1) / sp.factorial(k + 1),
        "factorial_induction_step":
            (k + 1) * (k / 3) ** k / ((k + 1) / 3) ** (k + 1)
            - 3 * (k / (k + 1)) ** k,
        "integer_terminal_constant": sp.Integer(11) ** 2 - 3 * 36 - 13,
    }
    require(list(identities) == cert["universal_algebra_checks"], "algebra list changed")
    for name, expression in identities.items():
        require(sp.simplify(expression) == 0, f"universal identity failed: {name}")
    for size in range(1, 65):
        require(3 ** size * math.factorial(size) >= size ** size,
                "finite factorial regression failed")
    require(13 > 0, "integer constant lacks nonnegative slack")
    return len(identities)


def order_regressions(sizes: list[int]) -> int:
    endpoints = list(map(F, ["0", "1/5", "1/2", "4/5", "1"]))
    mu = list(map(F, ["0", "3/2", "1/4", "1"]))
    nu = list(map(F, ["2", "0", "1/2", "0"]))
    combined = [p + q for p, q in zip(mu, nu)]
    total = sum((d * (b - a) for a, b, d in
                 zip(endpoints, endpoints[1:], combined)), F(0))

    def quantile(target: F) -> F:
        acc = F(0)
        for a, b, density in zip(endpoints, endpoints[1:], combined):
            next_acc = acc + density * (b - a)
            if density and acc <= target <= next_acc:
                return a + (target - acc) / density
            acc = next_acc
        raise AssertionError("positive interior quantile not reached")

    checked = 0
    for bins in sizes:
        cuts = [F(0)] + [quantile(total * i / bins) for i in range(1, bins)] + [F(1)]
        pieces = sorted(set(endpoints + cuts))
        outputs, inputs, out_bins, in_bins = [], [], [], []
        block_masses = [F(0)] * bins
        for a, b in zip(pieces, pieces[1:]):
            mid = (a + b) / 2
            base = next(i for i in range(len(mu)) if endpoints[i] < mid < endpoints[i + 1])
            index = next(i for i in range(bins) if cuts[i] < mid < cuts[i + 1])
            block_masses[index] += combined[base] * (b - a)
            if mu[base]:
                outputs.append(Cell((0, 0), a, b, mu[base] * (b - a)))
                out_bins.append(index)
            if nu[base]:
                inputs.append(Cell((0, 0), a, b, nu[base] * (b - a)))
                in_bins.append(index)
        require(block_masses == [total / bins] * bins, "quantile masses unequal")
        for kind in ("sign", "less", "greater"):
            pairing = []
            for out in outputs:
                row = []
                for inp in inputs:
                    below = below_area(out.left, out.right, inp.left, inp.right)
                    area = out.length * inp.length
                    value = area - 2 * below if kind == "sign" else (
                        below if kind == "less" else area - below
                    )
                    row.append(weighted_area(out, inp, value))
                pairing.append(row)
            approx = [[value if out_bins[i] != in_bins[j] else F(0)
                       for j, value in enumerate(row)] for i, row in enumerate(pairing)]
            require(sp.Matrix(approx).rank() <= bins, "order approximation rank exceeds bins")
            residual = [[value - approx[i][j] for j, value in enumerate(row)]
                        for i, row in enumerate(pairing)]
            masses_out, masses_in = [c.mass for c in outputs], [c.mass for c in inputs]
            _, negative, _ = inertia(norm_comparison(
                residual, masses_out, masses_in, (total / (2 * bins)) ** 2
            ))
            require(negative == 0, "order approximation error exceeds exact threshold")
            whole_bound = sum(masses_out, F(0)) * sum(masses_in, F(0))
            require(inertia(norm_comparison(pairing, masses_out, masses_in, whole_bound))[1] == 0,
                    "whole order norm exceeds two-measure threshold")
            checked += 1
    return checked


def pfaffian(a: list[list[F]]) -> F:
    if not a:
        return F(1)
    require(len(a) % 2 == 0, "Pfaffian requires even dimension")
    return sum(((1 if j % 2 else -1) * a[0][j]
                * pfaffian([[a[p][q] for q in range(1, len(a)) if q != j]
                            for p in range(1, len(a)) if p != j])
                for j in range(1, len(a))), F(0))


def make_cells(labels: list[Label], mass: F) -> list[Cell]:
    endpoints = list(map(F, ["0", "1/3", "1/2", "1"]))
    weights = [0 if i % 4 == 0 else 1 + i % 3 for i in range(len(labels) * 3)]
    denominator = sum(weights)
    return [Cell(label, endpoints[j], endpoints[j + 1],
                 mass * weights[3 * i + j] / denominator)
            for i, label in enumerate(labels) for j in range(3)]


def twisted_regressions(cert: dict) -> dict:
    thresholds = matrices = zero_cells = pfaffians = 0
    families = []
    for cycles in cert["finite_regressions"]["twist_cycles"]:
        permutation = {(i, j): (i, (j + 1) % size)
                       for i, size in enumerate(cycles) for j in range(size)}
        families.append((list(permutation), permutation))
    families.append(([tuple(label) for label in cert["finite_regressions"]["free_labels"]], None))
    for labels, permutation in families:
        inverse = {v: k for k, v in permutation.items()} if permutation is not None else {}

        def action(label: Label, power: int) -> Label:
            for _ in range(abs(power)):
                label = permutation[label] if power >= 0 else inverse[label]
            return label

        for multiplier in map(F, cert["finite_regressions"]["mass_multipliers"]):
            all_cells = make_cells(labels, multiplier)
            zero_cells += sum(c.mass == 0 for c in all_cells)
            cells = [c for c in all_cells if c.mass]
            mass = sum((c.mass for c in cells), F(0))
            require(mass == multiplier, "test field has wrong total mass")
            if not cells:
                matrices += 1
                continue
            pairing = []
            for out in cells:
                row = []
                for inp in cells:
                    if permutation is None:
                        area = lag_area(out, inp, out.label[1] - inp.label[1], False) \
                            if out.label[0] == inp.label[0] else F(0)
                    else:
                        area = sum((lag_area(out, inp, shift, True)
                                    for shift in range(-2, 3)
                                    if out.label == action(inp.label, shift)), F(0))
                        below = below_area(out.left, out.right, inp.left, inp.right)
                        rectangle = out.length * inp.length
                        decomposed = ((rectangle - 2 * below) * (out.label == inp.label)
                                      + below * (out.label == permutation[inp.label])
                                      - (rectangle - below) * (out.label == inverse[inp.label]))
                        require(area == decomposed, "three-shift formula changed the kernel")
                        if all(permutation[y] == y for y in labels):
                            require(area == 0, "identity twist did not cancel")
                        if all(permutation[permutation[y]] == y for y in labels):
                            require(area == (rectangle - 2 * below)
                                    * ((out.label == inp.label)
                                       - (out.label == permutation[inp.label])),
                                    "involution formula failed")
                    row.append(weighted_area(out, inp, area))
                pairing.append(row)
            d = len(cells)
            require(all(pairing[i][j] == -pairing[j][i] for i in range(d) for j in range(d)),
                    "exact integrated kernel is not skew")
            coefficient = 4 if permutation is None else 36
            for index in range(1, d + 1):
                bound = coefficient * mass / index
                comparison = norm_comparison(pairing, [c.mass for c in cells],
                                             [c.mass for c in cells], bound ** 2)
                require(inertia(comparison)[1] < index,
                        f"singular-value threshold failed at index {index}")
                thresholds += 1
            for size in range(2, min(d, 6) + 1, 2):
                sub = [row[:size] for row in pairing[:size]]
                value = pfaffian(sub)
                require(value ** 2 == sp.Matrix(sub).det(), "Pfaffian determinant identity failed")
                require(value ** 2 * math.factorial(size)
                        <= (36 * mass) ** size * math.prod(c.mass for c in cells[:size]),
                        "squared Pfaffian exceeded exact factorial threshold")
                require(pfaffian([[F(5, 2) * x for x in row] for row in sub])
                        == F(5, 2) ** (size // 2) * value, "Pfaffian scaling failed")
                pfaffians += 1
            if d >= 4:
                indices = [0, 0, 2, 3]
                require(pfaffian([[pairing[i][j] for j in indices] for i in indices]) == 0,
                        "dependent compression has nonzero Pfaffian")
            matrices += 1
    require(pfaffian([]) == 1, "empty Pfaffian convention failed")
    return {"matrices": matrices, "singular_thresholds": thresholds,
            "zero_mass_cells": zero_cells, "pfaffian_checks": pfaffians}


def check_jacobian(cert: dict) -> None:
    spec = cert["jacobian"]
    payload = json.loads((HERE / spec["payload"]).read_text())
    response = json.loads((HERE / spec["typed_output"]).read_text())
    require(response["server"]["version"] == spec["server_version"], "Jacobian version changed")
    require(response["protocol_version"] == spec["protocol_version"], "Jacobian protocol changed")
    require(response["request"] == {"operation_id": spec["operation_id"], "payload": payload},
            "Jacobian request/payload binding failed")
    result = response["result"]
    require(result["operation_id"] == spec["operation_id"] and "output" in result,
            "Jacobian failed or returned incomplete output")
    output = result["output"]
    require(output["spectrum_kind"] == "SINGULAR_VALUES", "wrong typed spectrum")
    require(output["values"] == [{"multiplicity": 2, "value": {
        "polynomial": ["2", "-1"], "real_root_index": 0}}],
        "two-interval singular values are not exactly one half")
    entries = [[F(int(e["rational_part"]["num"]), int(e["rational_part"]["den"]))
                for e in row] for row in payload["matrix"]["entries"]]
    require(entries == [[F(0), F(1, 2)], [F(-1, 2), F(0)]], "wrong compression payload")
    require(all(e["radical_coefficient"] == {"num": "0", "den": "1"}
                for row in payload["matrix"]["entries"] for e in row), "payload not rational")
    cells = [Cell((0, 0), F(0), F(1, 2), F(1, 2)),
             Cell((0, 0), F(1, 2), F(1), F(1, 2))]
    normalized = [[2 * weighted_area(out, inp, lag_area(out, inp, 0, False))
                   for inp in cells] for out in cells]
    require(normalized == entries, "Jacobian matrix is not the stated sign compression")
    require(sp.Matrix(entries).T * sp.Matrix(entries) == sp.eye(2) / 4,
            "independent rational spectral replay failed")


def check_lean(cert: dict) -> None:
    spec = cert["lean"]
    record = json.loads((HERE / spec["record"]).read_text())
    require(record["status"] == "success" and record["exit_code"] == 0
            and record["proof_holes"] == [], "Lean record did not verify")
    require(f'version {spec["required_version"]},' in record["tools"]["lean"]["version"],
            "wrong Lean compiler version")
    for file_key, hash_key in (("source", "source_sha256"),
                               ("statement_fidelity", "statement_fidelity_sha256")):
        digest = hashlib.sha256((HERE / spec[file_key]).read_bytes()).hexdigest()
        require(digest == record[hash_key], f"stale Lean {file_key}")
    bound = record["kernel"]["recorded"]
    require(bound["artifact"] == str((HERE / spec["certificate"]).relative_to(ROOT)),
            "wrong archived Lean certificate")
    archive = json.loads((HERE / spec["certificate"]).read_text())
    require(archive["lean_check"]["source_sha256"] == record["source_sha256"]
            and archive["lean_check"]["statement_fidelity_sha256"]
            == record["statement_fidelity_sha256"], "archive binding failed")
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claims = [c for c in ledger["claims"] if c["claim_id"] == spec["claim"]]
    require(claims and max(claims, key=lambda c: c["version"])["content_hash"]
            == bound["subject"]["content_hash"], "formal claim was revised after compilation")


def main() -> None:
    cert = json.loads((HERE / "exact_certificate.json").read_text())
    theorem = cert["theorem"]
    require((theorem["full_sign_rank_coefficient"], theorem["full_sign_singular_coefficient"],
             theorem["truncated_sign_rank_coefficient"],
             theorem["truncated_sign_singular_coefficient"],
             theorem["pfaffian_squared_constant_at_mass_one"],
             theorem["manuscript_pfaffian_constant"]) == (2, 4, 18, 36, 108, 11),
            "quantified constants changed")
    identities = symbolic_checks(cert)
    check_jacobian(cert)
    check_lean(cert)
    order_cases = order_regressions(cert["finite_regressions"]["order_partition_sizes"])
    twisted = twisted_regressions(cert)
    print(json.dumps({
        "status": "exact_replay_passed",
        "universal_algebra_identities": identities,
        "two_measure_compressions": order_cases,
        "twisted_compressions": twisted,
        "lean_algebra_core": "exit_code=0; proof_holes=[]; source/fidelity current",
        "analytic_theorem": "proved in proof.md; not wholly formalized",
        "independent_review": cert["independent_review"],
        "campaign_complete": False
    }, indent=2))


if __name__ == "__main__":
    main()
