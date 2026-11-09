#!/usr/bin/env python3
"""Replay exact certificates; the universal proof is in report.md and Main.lean."""

import hashlib
import itertools
import json
import math
from dataclasses import dataclass
from fractions import Fraction as Q
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load(name):
    return json.loads((HERE / name).read_text())


def add(a, b):
    return tuple(x + y for x, y in zip(a, b, strict=True))


def scale(c, a):
    return tuple(c * x for x in a)


def dot(a, b):
    return sum((x * y for x, y in zip(a, b, strict=True)), Q(0))


def total(vectors, dimension):
    out = (Q(0),) * dimension
    for vector in vectors:
        out = add(out, vector)
    return out


def inside(fine, coarse):
    return coarse[0] <= fine[0] < fine[1] <= coarse[1]


def check_partition(partition, atoms):
    coverage = [0] * atoms
    for lo, hi in partition:
        length = hi - lo
        require(0 <= lo < hi <= atoms, "Invalid cell endpoints")
        require(length & (length - 1) == 0 and lo % length == 0,
                "Cell is not dyadic")
        for x in range(lo, hi):
            coverage[x] += 1
    require(coverage == [1] * atoms, "Cells do not partition the root")


def refines(fine, coarse):
    return all(any(inside(cell, parent) for parent in coarse) for cell in fine)


def diagonal_sos(matrix):
    """Return coefficients of an exact diagonally-dominant PSD decomposition."""
    n = len(matrix)
    require(all(len(row) == n for row in matrix), "Nonsquare SOS matrix")
    require(all(matrix[i][j] == matrix[j][i] for i in range(n) for j in range(n)),
            "Nonsymmetric SOS matrix")
    diagonal = [
        matrix[i][i] - sum((abs(matrix[i][j]) for j in range(n) if j != i), Q(0))
        for i in range(n)
    ]
    require(all(d >= 0 for d in diagonal), "Negative diagonal SOS coefficient")
    reconstructed = [[Q(0)] * n for _ in range(n)]
    for i, d in enumerate(diagonal):
        reconstructed[i][i] += d
    for i in range(n):
        for j in range(i + 1, n):
            value = matrix[i][j]
            weight = abs(value)
            sign = 1 if value >= 0 else -1
            reconstructed[i][i] += weight
            reconstructed[j][j] += weight
            reconstructed[i][j] += sign * weight
            reconstructed[j][i] += sign * weight
    require(reconstructed == matrix, "SOS does not reconstruct the matrix")
    return diagonal


def check_formal(spec):
    result = load(spec["compiler_result"])
    archive = load(spec["archive"])
    require(result["status"] == "success", "Lean result is not successful")
    require(result["exit_code"] == spec["required_exit_code"] == 0, "Lean failed")
    require(result["proof_holes"] == spec["required_proof_holes"] == [],
            "Lean proof has holes")
    require(result["audit_exit_code"] == 0, "Lean axiom audit failed")
    require(not result["environment_failure"], "Lean environment was unverified")
    require(f"Lean (version {spec['lean_version']}," in result["tools"]["lean"]["version"],
            "Wrong Lean version")
    source = (HERE / spec["source"]).read_bytes()
    fidelity = (HERE / spec["statement_fidelity"]).read_text()
    require(hashlib.sha256(source).hexdigest() == result["source_sha256"],
            "Lean source changed since its real compiler run")
    require(hashlib.sha256(fidelity.encode()).hexdigest() ==
            result["statement_fidelity_sha256"], "Statement fidelity changed")
    require(archive["lean_check"] == result, "Archived and current compiler records differ")
    require(archive["lean_source"]["text"] == source.decode(), "Wrong archived Lean text")
    require(archive["statement_fidelity"]["text"] == fidelity,
            "Wrong archived fidelity text")
    require(archive["subject"]["subject_id"] == spec["claim_id"], "Wrong formal claim")
    require(archive["verdict"] == "supports" and archive["tier"] == "mechanical",
            "Archive is not supporting mechanical evidence")
    return {"claim": spec["claim_id"], "lean": spec["lean_version"],
            "exit_code": 0, "proof_holes": [], "archive": spec["archive"]}


def check_constants(spec):
    alpha = Q(spec["alpha"])
    weak = list(map(Q, spec["weak_constant_squared_terms"]))
    strong = list(map(Q, spec["l1_constant_squared_terms"]))
    old = list(map(Q, spec["original_l1_constant_squared_terms"]))
    require(0 < alpha < 1, "Invalid remainder fraction")
    require(weak == [1 / alpha ** 2, 1 / (1 - alpha) ** 2],
            "Incorrect two weak-bound contributions")
    require(strong == [4 * x for x in weak], "Incorrect layer-cake factor")
    denominator = Q(spec["difference_denominator"])
    numerator = list(map(Q, spec["difference_numerator_terms"]))
    require([old[i] - strong[i] for i in range(2)] ==
            [x / denominator for x in numerator], "Incorrect constant difference")
    minimum = spec["minimum_L"]
    require(numerator[1] > 0 and numerator[0] + numerator[1] * minimum ** 2 > 0,
            "Claimed strict improvement does not hold for all L>=minimum")
    require(old[0] + old[1] * 36 == Q(spec["D2_original_l1_squared"]),
            "Incorrect original D=2 constant")
    require(strong[0] + strong[1] * 36 == Q(spec["D2_improved_l1_squared"]),
            "Incorrect improved D=2 constant")
    log_polynomial = [Q(25 - 9 - 4), Q(50 - 20), Q(25 - 25)]
    require(log_polynomial == list(map(Q, spec["logarithmic_comparison_polynomial"])),
            "Incorrect logarithmic-bound polynomial")
    return {"improved_D2_squared": str(strong[0] + strong[1] * 36),
            "original_D2_squared": str(old[0] + old[1] * 36),
            "strict_improvement_for_all_L_at_least": minimum}


def rational(entry):
    value = Q(int(entry["num"]), int(entry["den"]))
    require(str(value.numerator) == entry["num"] and str(value.denominator) == entry["den"],
            "Jacobian rational is not canonical")
    return value


def check_jacobian(spec):
    require(spec["adapter_exit_code"] == 0 and spec["timeout"] is False,
            "Jacobian transport did not complete successfully")
    payload = load(spec["payload"])
    result = load(spec["typed_result"])
    require(result["protocol_version"] == spec["protocol_version"],
            "Wrong Jacobian protocol")
    require(result["server"]["version"] == spec["server_version"],
            "Wrong Jacobian server version")
    require(result["request"]["operation_id"] == spec["operation_id"],
            "Wrong Jacobian operation")
    require(result["request"]["payload"] == payload, "Jacobian source payload mismatch")
    require(result["result"]["operation_id"] == spec["operation_id"],
            "Wrong typed-result operation")
    out = result["result"]["output"]
    require(out["outcome"] == "VALID" and out["valid_complete_rational_spectrum"],
            "Jacobian did not validate the claimed spectrum")
    require(out["matrix"] == payload["matrix"] and
            out["claimed_profile"] == payload["claimed_profile"], "Result source mismatch")
    gram = [[rational(x) for x in row] for row in out["matrix"]["entries"]]
    require(gram == [[Q(5, 4), Q(1)], [Q(1), Q(5, 4)]], "Unexpected Gram matrix")
    for eigenvalue, vector in [(Q(9, 4), (1, 1)), (Q(1, 4), (1, -1))]:
        require(tuple(dot(row, vector) for row in gram) == scale(eigenvalue, vector),
                "Independent exact eigenvector replay failed")
    require(out["matrix_order"] == out["established_multiplicity_sum"] == 2,
            "Incomplete spectrum")
    require(all(x["exact_nullity"] == x["claimed_multiplicity"] == 1 and
                x["multiplicity_matches"] for x in out["nullity_ledger"]),
            "Wrong exact nullity ledger")
    return {"operation": spec["operation_id"], "adapter_exit_code": 0,
            "outcome": "VALID", "exact_eigenvalues": ["9/4", "1/4"]}


@dataclass(frozen=True)
class Row:
    round: int
    support: tuple
    coefficients: tuple


class Model:
    def __init__(self, spec):
        self.spec = spec
        self.atoms = spec["atoms"]
        self.weight = Q(spec["atom_measure"])
        self.D = Q(spec["D"])
        self.gamma = Q(spec["private_weight"])
        self.births = [tuple(cell) for cell in spec["birth_cells"]]
        self.labels = len(self.births)
        self.dimension = self.labels + 1
        self.pi = [[tuple(c) for c in p] for p in spec["support_partitions"]]
        self.sigma = [[tuple(c) for c in p] for p in spec["observation_partitions"]]
        self.rounds = len(self.pi)
        self.rows = []
        self.by_round = []
        for n, modes in enumerate(spec["row_modes_by_round"]):
            indices = []
            for support in self.pi[n]:
                for mode in modes:
                    coefficients = [(Q(0),) * self.labels for _ in range(self.atoms)]
                    for cell in self.sigma[n]:
                        if not inside(cell, support):
                            continue
                        a = tuple(
                            Q(((n + 2) * (cell[0] + 1) + (mode + 1) * (v + 1)) % 5 - 2, 2)
                            if inside(cell, birth) and
                            (mode == 2 or (mode == 0 and v == 0) or (mode == 1 and v != 0))
                            else Q(0)
                            for v, birth in enumerate(self.births)
                        )
                        for x in range(*cell):
                            coefficients[x] = a
                    indices.append(len(self.rows))
                    self.rows.append(Row(n, support, tuple(coefficients)))
            self.by_round.append(indices)
        self.kernels = [
            [self.physical(row.coefficients[x], x) for x in range(self.atoms)]
            for row in self.rows
        ]
        self.gram = [
            [self.weight * sum((dot(h[x], g[x]) for x in range(self.atoms)), Q(0))
             for g in self.kernels]
            for h in self.kernels
        ]
        self.B2 = max(sum(map(abs, row), Q(0)) for row in self.gram)
        self.m = Q(spec["frame_lower"])
        self.M = Q(spec["frame_upper"])

    def physical(self, a, x):
        require(all(a[v] == 0 or self.births[v][0] <= x < self.births[v][1]
                    for v in range(self.labels)), "Coefficient uses unavailable label")
        sign = 1 if x % 2 == 0 else -1
        return (sign * sum(a, Q(0)),) + tuple(self.gamma * z for z in a)

    def coefficient_sum(self, indices, tests, x):
        return total((scale(tests[r], self.rows[r].coefficients[x]) for r in indices),
                     self.labels)

    def l2_squared(self, coefficients):
        return self.weight * sum(
            (dot(self.physical(a, x), self.physical(a, x))
             for x, a in enumerate(coefficients)), Q(0))

    def validate(self):
        require(self.atoms * self.weight == 1, "Root measure is not one")
        require(self.D >= 2 and abs(self.gamma) >= 1 / self.D, "Private-weight budget failed")
        for lo, hi in self.births:
            length = hi - lo
            require(0 <= lo < hi <= self.atoms and length & (length - 1) == 0
                    and lo % length == 0, "A catalog birth cell is not dyadic in the root")
        require(len(self.pi) == len(self.sigma) == len(self.by_round), "Schedule mismatch")
        for n in range(self.rounds):
            check_partition(self.pi[n], self.atoms)
            check_partition(self.sigma[n], self.atoms)
            require(refines(self.sigma[n], self.pi[n]), "Observation does not refine support")
            if n + 1 < self.rounds:
                require(refines(self.pi[n + 1], self.sigma[n]), "Wrong cross-round refinement")
        path_counts = []
        for x in range(self.atoms):
            available = [v for v, (lo, hi) in enumerate(self.births) if lo <= x < hi]
            path_counts.append(len(available))
            require(len(available) <= self.D, "Full birth-path count exceeds D")
            columns = []
            for v in available:
                unit = tuple(Q(int(i == v)) for i in range(self.labels))
                column = self.physical(unit, x)
                require(dot(column, column) <= self.D ** 2, "Column norm budget failed")
                require(column[v + 1] == self.gamma and
                        all(column[j + 1] == 0 for j in range(self.labels) if j != v),
                        "A private coordinate is not private")
                columns.append(column)
            gram = [[dot(a, b) for b in columns] for a in columns]
            diagonal_sos([[gram[i][j] - self.m ** 2 * int(i == j)
                           for j in range(len(available))] for i in range(len(available))])
            diagonal_sos([[self.M ** 2 * int(i == j) - gram[i][j]
                           for j in range(len(available))] for i in range(len(available))])
        for row in self.rows:
            require(row.support in self.pi[row.round], "Row has no whole support cell")
            for x in range(self.atoms):
                if not row.support[0] <= x < row.support[1]:
                    require(row.coefficients[x] == (Q(0),) * self.labels,
                            "Row leaks outside its support")
            for cell in self.sigma[row.round]:
                require(all(row.coefficients[x] == row.coefficients[cell[0]]
                            for x in range(*cell)), "Coefficients are not observation-constant")
                for v, birth in enumerate(self.births):
                    if row.coefficients[cell[0]][v]:
                        require(inside(cell, birth), "Column is not available on the whole cell")
        require(len(self.rows) == self.spec["expected_rows"], "Wrong row count")
        require(self.B2 == Q(self.spec["expected_B_squared"]), "Wrong all-input Bessel budget")
        slack = [[self.B2 * int(i == j) - self.gram[i][j]
                  for j in range(len(self.rows))] for i in range(len(self.rows))]
        sos = diagonal_sos(slack)
        return {"rows": len(self.rows), "rounds": self.rounds, "atoms": self.atoms,
                "total_labels": self.labels, "maximum_birth_path_count": max(path_counts),
                "D": str(self.D), "B_squared": str(self.B2),
                "Bessel_certificate": "Exact PSD SOS for B_squared I - Gram(A*)",
                "minimum_diagonal_SOS_coefficient": str(min(sos))}


def tests_for(name, rows):
    if name == "zero":
        return [Q(0)] * rows
    if name == "ones":
        return [Q(1)] * rows
    if name == "alternating":
        return [Q((-1) ** r) for r in range(rows)]
    if name == "rational_periodic":
        return [Q(r % 5 - 2, 2) for r in range(rows)]
    if name == "sparse":
        return [Q(int(r == 1)) for r in range(rows)]
    raise ValueError(f"Unknown test vector: {name}")


def sqrt_upper(value):
    require(value >= 0, "Negative squared norm")
    scale_factor = 1 << 20
    scaled_numerator = value.numerator * scale_factor ** 2
    root = math.isqrt(scaled_numerator // value.denominator)
    if root ** 2 * value.denominator < scaled_numerator:
        root += 1
    upper = Q(root, scale_factor)
    require(upper ** 2 >= value, "Incorrect rational square-root upper bound")
    return upper


def stopping_replay(model, tests, T, tau):
    require(T > 0 and T & (T - 1) == 0 and tau > 0, "Invalid stopping parameters")
    zero = (Q(0),) * model.labels
    bucket = [0] * model.atoms
    accumulator = [zero] * model.atoms
    owners = [None] * len(model.rows)
    history = [(bucket.copy(), accumulator.copy())]
    hit_vectors = {}
    for n, indices in enumerate(model.by_round):
        for r in indices:
            points = range(*model.rows[r].support)
            states = {bucket[x] for x in points}
            require(len(states) == 1, "A row was split between test-dependent buckets")
            owner = states.pop()
            owners[r] = owner if owner < T else None
        for x in range(model.atoms):
            if bucket[x] == T:
                continue
            updated = add(accumulator[x], model.coefficient_sum(indices, tests, x))
            if dot(updated, updated) > tau ** 2:
                hit_vectors[x, bucket[x]] = updated
                bucket[x] += 1
                accumulator[x] = zero
            else:
                accumulator[x] = updated
        history.append((bucket.copy(), accumulator.copy()))
    bucket_coefficients = [
        [model.coefficient_sum([r for r, owner in enumerate(owners) if owner == i], tests, x)
         for x in range(model.atoms)]
        for i in range(T)
    ]
    E = sum((c ** 2 for c in tests), Q(0))
    require(sum((model.l2_squared(v) for v in bucket_coefficients), Q(0)) <= model.B2 * E,
            "Disjoint whole-row mask energy failed")
    for h in range(T.bit_length()):
        length = 1 << h
        for start in range(0, T, length):
            indices = [r for r, owner in enumerate(owners)
                       if owner is not None and start <= owner < start + length]
            coefficients = [model.coefficient_sum(indices, tests, x)
                            for x in range(model.atoms)]
            budget = model.B2 * sum((tests[r] ** 2 for r in indices), Q(0))
            require(model.l2_squared(coefficients) <= budget, "Subset Bessel check failed")
    maximum_squared = []
    bucket_maximum_squared = []
    for x in range(model.atoms):
        partial = zero
        max_squared = Q(0)
        for cutoff in range(model.rounds + 1):
            if cutoff:
                partial = add(partial, model.coefficient_sum(model.by_round[cutoff - 1], tests, x))
            image = model.physical(partial, x)
            max_squared = max(max_squared, dot(image, image))
            if bucket[x] < T:
                b, acc = history[cutoff][0][x], history[cutoff][1][x]
                completed = total((bucket_coefficients[i][x] for i in range(b)), model.labels)
                require(partial == add(completed, acc), "Completed-prefix identity failed")
                require(dot(acc, acc) <= tau ** 2, "Unfinished accumulator exceeds threshold")
                remainder = model.physical(acc, x)
                require(dot(remainder, remainder) <= model.M ** 2 * tau ** 2,
                        "Upper frame bound failed on remainder")
        if bucket[x] == T:
            for i in range(T):
                a = bucket_coefficients[i][x]
                require(a == hit_vectors[x, i], "Completed bucket has future contamination")
                require(dot(a, a) > tau ** 2, "A completed bucket did not hit")
                v = model.physical(a, x)
                require(dot(v, v) > model.m ** 2 * tau ** 2,
                        "Lower frame bound failed on a hit")
        maximum_squared.append(max_squared)
        prefixes = [zero]
        for i in range(T):
            prefixes.append(add(prefixes[-1], bucket_coefficients[i][x]))
        bucket_maximum_squared.append(max(
            dot(model.physical(a, x), model.physical(a, x)) for a in prefixes))
    L = T.bit_length()
    require(model.weight * sum(bucket_maximum_squared) <= L ** 2 * model.B2 * E,
            "Binary-prefix L2 estimate failed")
    omega = model.weight * sum(b == T for b in bucket)
    require(omega * T * model.m ** 2 * tau ** 2 <= model.B2 * E,
            "Many-hit measure estimate failed")
    for alpha in (Q(1, 4), Q(2, 9)):
        lam = model.M * tau / alpha
        K = (model.M / model.m) ** 2 / (T * alpha ** 2) + L ** 2 / (1 - alpha) ** 2
        exceptional = model.weight * sum(a > lam ** 2 for a in maximum_squared)
        require(exceptional * lam ** 2 <= K * model.B2 * E, "Weak maximal estimate failed")
        require(exceptional * lam ** 2 <= Q(80) * model.B2 * E,
                "Original manuscript weak-bound shape failed")
        require(exceptional * lam ** 2 <= Q(15633, 196) * model.B2 * E,
                "Improved manuscript weak-bound shape failed")
        l1_upper = model.weight * sum(map(sqrt_upper, maximum_squared), Q(0))
        require(l1_upper ** 2 <= 4 * K * model.B2 * E, "L1 maximal estimate failed")
        require(l1_upper ** 2 <= Q(320) * model.B2 * E,
                "Original manuscript L1-bound shape failed")
        require(l1_upper ** 2 <= Q(15633, 49) * model.B2 * E,
                "Improved manuscript L1-bound shape failed")
    return {"stopped_paths": sum(b == T for b in bucket),
            "unfinished_paths": sum(b < T and any(acc) for b, acc in zip(bucket, accumulator))}


def check_depth(model):
    profiles = [
        ([[0, 1, 2, 3, 4, 5]], [Q(0), Q(1, 4), Q(1, 4), Q(1, 2), Q(1, 2), Q(1, 2)]),
        ([[0, 1, 2], [3, 4, 5]], [Q(0), Q(1, 8), Q(1, 4), Q(1, 4), Q(1, 8), Q(0)]),
        ([[0, 1], [2, 3], [4, 5]], [Q(0), Q(1, 4), Q(1, 4), Q(0), Q(0), Q(-1, 4)]),
    ]
    reads = model.spec["read_schedule"]
    require(len(reads) == model.rounds and reads == sorted(reads), "Nonmonotone reads")
    require([len(blocks) for blocks, _ in profiles] == model.spec["depth_block_counts"],
            "Wrong depth fixtures")
    results = []
    for blocks, scalar in profiles:
        for block in blocks:
            bound = max(abs(scalar[s]) for s in block) + sum(
                (abs(scalar[t] - scalar[s]) for s, t in zip(block, block[1:])), Q(0))
            require(bound ** 2 <= Q(1, len(blocks)), "Original block normalization failed")
        inputs = [
            [((1 if x % 3 else -1) * value,) + (Q(0),) * model.labels
             for x in range(model.atoms)]
            for value in scalar
        ]
        outputs = [
            model.weight * sum((dot(inputs[reads[row.round]][x], model.kernels[r][x])
                                for x in range(model.atoms)), Q(0))
            for r, row in enumerate(model.rows)
        ]
        energy = sum((a ** 2 for a in outputs), Q(0))
        require(energy <= Q(320) * model.B2, "Original depth bound failed")
        require(energy <= Q(15633, 49) * model.B2, "Improved depth bound failed")
        for name in model.spec["test_vectors"]:
            tests = tests_for(name, len(model.rows))
            for block in blocks:
                rounds = [n for n, s in enumerate(reads) if s in block]
                if not rounds:
                    continue
                require(rounds == list(range(rounds[0], rounds[-1] + 1)),
                        "Read block is not consecutive")
                for x in range(model.atoms):
                    g = [
                        model.physical(model.coefficient_sum(model.by_round[n], tests, x), x)
                        for n in rounds
                    ]
                    partials = []
                    partial = (Q(0),) * model.dimension
                    for a in g:
                        partial = add(partial, a)
                        partials.append(partial)
                    lhs = sum((dot(inputs[reads[n]][x], a)
                               for n, a in zip(rounds, g)), Q(0))
                    rhs = dot(inputs[reads[rounds[-1]]][x], partials[-1])
                    for j, (n, next_n) in enumerate(zip(rounds, rounds[1:])):
                        difference = add(inputs[reads[n]][x],
                                         scale(-1, inputs[reads[next_n]][x]))
                        rhs += dot(difference, partials[j])
                    require(lhs == rhs, "Exact blockwise Abel identity failed")
        results.append({"blocks": len(blocks), "output_energy": str(energy)})
    return results


def enumerate_core(spec):
    require(spec["atoms"] == 2 and spec["rounds"] == 4, "Unexpected enumeration shape")
    values = spec["increment_values"]
    count = 0
    replays = 0
    stopped = 0
    branching = 0
    for flat in itertools.product(values, repeat=8):
        count += 1
        increments = [flat[2 * n:2 * n + 2] for n in range(4)]
        for T in spec["bucket_counts"]:
            for threshold in map(Q, spec["thresholds"]):
                replays += 1
                b = [0, 0]
                acc = [0, 0]
                history = [(b.copy(), acc.copy())]
                owners = [[None, None] for _ in range(4)]
                for n, a in enumerate(increments):
                    if n == 0:
                        require(b[0] == b[1], "Root row has multiple owners")
                    for x in range(2):
                        owners[n][x] = b[x] if b[x] < T else None
                        if b[x] < T:
                            candidate = acc[x] + a[x]
                            if candidate ** 2 * threshold.denominator ** 2 > threshold.numerator ** 2:
                                b[x] += 1
                                acc[x] = 0
                            else:
                                acc[x] = candidate
                    history.append((b.copy(), acc.copy()))
                branching += history[1][0][0] != history[1][0][1]
                for x in range(2):
                    buckets = [sum(increments[n][x] for n in range(4)
                                   if owners[n][x] == i) for i in range(T)]
                    if b[x] == T:
                        stopped += 1
                        require(all(v ** 2 > threshold ** 2 for v in buckets),
                                "Enumerated completed bucket was contaminated")
                    else:
                        for cutoff, (state_b, state_acc) in enumerate(history):
                            partial = sum(increments[n][x] for n in range(cutoff))
                            require(partial == sum(buckets[:state_b[x]]) + state_acc[x],
                                    "Enumerated prefix identity failed")
                            require(state_acc[x] ** 2 <= threshold ** 2,
                                    "Enumerated residual threshold failed")
    require(count == spec["expected_increment_arrays"], "Incomplete increment enumeration")
    require(replays == spec["expected_stopping_replays"], "Incomplete stopping enumeration")
    require(stopped > 0 and branching > 0, "Enumeration missed stopping or branch splitting")
    return {"increment_arrays": count, "stopping_replays": replays,
            "stopped_paths": stopped, "different_first_round_branch_states": branching,
            "scope": "Finite regression, not the proof of the universal theorem"}


def main():
    certificate = load("exact_certificate.json")
    formal = check_formal(certificate["formal_evidence"])
    constants = check_constants(certificate["constants"])
    jacobian = check_jacobian(certificate["jacobian"])
    model = Model(certificate["finite_model"])
    model_result = model.validate()
    replays = 0
    stopped = 0
    unfinished = 0
    for name in model.spec["test_vectors"]:
        tests = tests_for(name, len(model.rows))
        for T in model.spec["bucket_counts"]:
            for tau in map(Q, model.spec["thresholds"]):
                result = stopping_replay(model, tests, T, tau)
                replays += 1
                stopped += result["stopped_paths"]
                unfinished += result["unfinished_paths"]
    require(stopped > 0 and unfinished > 0, "Fixtures missed stopped or unfinished paths")
    require(replays == model.spec["expected_stopping_replays"], "Missing row-model replays")
    result = {
        "status": "exact_replay_passed",
        "scope": certificate["scope"],
        "formal_core": formal,
        "constants": constants,
        "jacobian": jacobian,
        "finite_model": model_result,
        "hypothesis_faithful_stopping_replays": replays,
        "stopped_paths": stopped,
        "unfinished_paths": unfinished,
        "depth_profiles": check_depth(model),
        "combinatorial_regression": enumerate_core(certificate["combinatorial_enumeration"]),
        "universal_proof": "report.md; finite replays do not establish its quantifiers",
        "independent_review": certificate["independent_review"],
    }
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
