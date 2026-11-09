#!/usr/bin/env python3
"""Exact algebra and adaptive replay accompanying the universal proof in report.md."""

import argparse
from collections import defaultdict
from fractions import Fraction as F
from functools import cache
from hashlib import sha256
from itertools import permutations, product
import json
from math import comb, factorial
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def qtext(value):
    return str(F(value))


def symbolic_identities():
    m, k, r, x, p = sp.symbols("m k r x p")
    coefficient_ratio = -(k - r) * (k + r + 1) / ((r + 1) * (m - r - 1))
    leading_ratio = -(k + 1) ** 2 * (m - k - 1) / ((2 * k + 2) * (2 * k + 1))
    upper = -(k + 1) * (m - 1 - k) / (2 * (2 * k + 1))
    lower = -k * (m + k) / (2 * (2 * k + 1))
    previous_upper = -k * (m - k) / (2 * (2 * k - 1))
    norm_ratio = (2 * k - 1) * (m + k) / ((2 * k + 1) * (m - k))
    identities = {
        "binomial_operator_action": (
            (x + 1) * (m - 1 - x) - (m - x) * (x - r + 1)
            + (r + 1) * (x - r + 1) - r * (m - r)
        ),
        "eigenvector_coefficient_recurrence": (
            -r * (r + 1) + (r + 1) * (m - r - 1) * coefficient_ratio
            + k * (k + 1)
        ),
        "leading_coefficient_ratio": leading_ratio - upper,
        "three_term_endpoint": upper + lower + (m - 1) / 2,
        "norm_recurrence": lower / previous_upper - norm_ratio,
        "inverse_norm_recurrence": (
            1 / norm_ratio
            - (2 * k + 1) * (m - k) / ((2 * k - 1) * (m + k))
        ),
        "endpoint_constant_telescoping": (
            (m - k) - (m - k - 1) * (m - k) / (m + k)
            - (2 * k + 1) * (m - k) / (m + k)
        ),
        "bernoulli_chi_square_identity": (
            x * (x / p - 1) + (1 - x) * ((1 - x) / (1 - p) - 1)
            - (x - p) ** 2 / (p * (1 - p))
        ),
    }
    for name, expression in identities.items():
        require(sp.cancel(expression) == 0, f"symbolic identity failed: {name}")
    return list(identities)


def grid_constant(b, m):
    require(1 <= b <= m, "grid degree must satisfy 1 <= b <= m")
    ratio = F(1)
    total = F(0)
    for k in range(b):
        if k:
            ratio *= F(m - k, m + k)
        total += (2 * k + 1) * ratio
    telescoped = F(1)
    for r in range(1, b + 1):
        telescoped *= F(m - r, m + r - 1)
    require(total == m * (1 - telescoped), "grid constant did not telescope")
    require(0 < total <= min(b * b, m), "grid constant out of proved range")
    return total


def grid_polynomial(m, k, j):
    return sum(
        (F((-1) ** r * comb(k, r) * comb(k + r, r) * comb(j, r),
           comb(m - 1, r)) for r in range(k + 1) if r <= j),
        F(0),
    )


def check_grid(m, b):
    values = [[grid_polynomial(m, k, j) for j in range(m)] for k in range(b)]
    inverse_norms = []
    ratio = F(1)
    for k in range(b):
        if k:
            ratio *= F(m - k, m + k)
        inverse_norms.append((2 * k + 1) * ratio)
        require(values[k][0] == 1, "wrong grid endpoint")
        for l in range(k + 1):
            inner = sum((values[k][j] * values[l][j] for j in range(m)), F(0)) / m
            require(inner == (1 / inverse_norms[k] if k == l else 0),
                    "grid orthogonality or norm failed")
    constant = grid_constant(b, m)
    kernel = [sum((inverse_norms[k] * values[k][j] for k in range(b)), F(0))
              for j in range(m)]
    require(kernel[0] == constant, "reproducing-kernel endpoint failed")
    require(sum((v * v for v in kernel), F(0)) / m == constant,
            "reproducing-kernel norm failed")
    for k in range(b):
        require(sum((kernel[j] * values[k][j] for j in range(m)), F(0)) / m == 1,
                "reproducing-kernel evaluation failed")
    return {"m": m, "b": b, "constant": qtext(constant)}


@cache
def log_bounds(value):
    value = F(value)
    require(value > 0, "log argument must be positive")
    if value == 1:
        return F(0), F(0)
    if value < 1:
        lo, hi = log_bounds(1 / value)
        return -hi, -lo
    power = 0
    while value > 2:
        value /= 2
        power += 1
    y = (value - 1) / (value + 1)
    terms = 48
    partial = 2 * sum((y ** (2 * j + 1) / (2 * j + 1) for j in range(terms)), F(0))
    tail = 2 * y ** (2 * terms + 1) / ((2 * terms + 1) * (1 - y * y))
    if not power:
        return partial, partial + tail
    lo2, hi2 = log_bounds(F(2))
    return partial + power * lo2, partial + tail + power * hi2


def divergence_bounds(q_law, mu_law):
    lo, hi = F(0), F(0)
    for key, mass in q_law.items():
        if not mass:
            continue
        require(mu_law.get(key, F(0)) > 0, "reference law lacks comparison support")
        left, right = log_bounds(mass / mu_law[key])
        lo += mass * left
        hi += mass * right
    return lo, hi


def validate_tree(tree, n, used=frozenset()):
    if tree is None:
        return
    require(isinstance(tree, dict) and set(tree) == {"query", "zero", "one"},
            "a query node must have exactly query, zero, one")
    e = tree["query"]
    require(type(e) is int and 0 <= e < n, "invalid queried coordinate")
    require(e not in used, "an algorithm rereads a coordinate on a path")
    validate_tree(tree["zero"], n, used | {e})
    validate_tree(tree["one"], n, used | {e})


def local_trace(tree, omega):
    history = ()
    nodes = []
    while tree is not None:
        e = tree["query"]
        nodes.append((history, e))
        answer = omega[e]
        history += ((e, answer),)
        tree = tree["one" if answer else "zero"]
    return history, nodes


def fresh_weight(m, j, k):
    require(1 <= k <= m and 0 <= j < m, "invalid rank or reader count")
    return F(comb(m - 1 - j, k - 1) if m - 1 - j >= k - 1 else 0,
             comb(m - 1, k - 1))


def analyze_instance(instance):
    n = instance["n_bits"]
    p = F(instance["p"])
    a = instance["a"]
    algorithms = instance["algorithms"]
    m = len(algorithms)
    require(type(n) is int and n >= 0, "n_bits must be nonnegative")
    require(0 < p < 1 and type(a) is int and a >= 1, "invalid p or a")
    for tree in algorithms:
        validate_tree(tree, n)
    configurations = list(product((0, 1), repeat=n))
    mu = {omega: p ** sum(omega) * (1 - p) ** (n - sum(omega))
          for omega in configurations}
    q = {omega: F(0) for omega in configurations}
    for bits, mass in instance["Q"].items():
        require(len(bits) == n and set(bits) <= {"0", "1"}, "invalid Q configuration")
        value = F(mass)
        require(value >= 0, "negative Q mass")
        q[tuple(int(bit) for bit in bits)] = value
    require(sum(q.values(), F(0)) == 1, "Q is not a probability law")
    traces = {}
    readers = {}
    local_q = [defaultdict(F) for _ in algorithms]
    local_mu = [defaultdict(F) for _ in algorithms]
    nodes = {}
    for omega in configurations:
        readers[omega] = [set() for _ in range(n)]
        for i, tree in enumerate(algorithms):
            transcript, visited = local_trace(tree, omega)
            traces[omega, i] = transcript
            local_q[i][transcript] += q[omega]
            local_mu[i][transcript] += mu[omega]
            for history, e in visited:
                readers[omega][e].add(i)
                key = (i, history, e)
                if key not in nodes:
                    nodes[key] = {"q": F(0), "mu": F(0), "q_one": F(0),
                                  "mu_one": F(0), "support": []}
                node = nodes[key]
                node["q"] += q[omega]
                node["mu"] += mu[omega]
                node["q_one"] += q[omega] * omega[e]
                node["mu_one"] += mu[omega] * omega[e]
                if q[omega]:
                    node["support"].append(omega)
    overlap = max((len(readers[omega][e]) for omega in configurations if q[omega]
                   for e in range(n)), default=0)
    full_overlap = max((len(readers[omega][e]) for omega in configurations
                        for e in range(n)), default=0)
    require(overlap <= a, "comparison-support overlap hypothesis failed")
    local_energy = F(0)
    for (i, history, e), node in nodes.items():
        require(node["mu_one"] == p * node["mu"], "local reference transition is not p")
        if node["q"]:
            node["bias"] = node["q_one"] / node["q"] - p
            local_energy += node["q"] * node["bias"] ** 2
            node["a"] = max(len(readers[omega][e]) for omega in node["support"])
    for omega in configurations:
        for i in range(m):
            transcript = traces[omega, i]
            require(local_mu[i][transcript]
                    == p ** sum(bit for _, bit in transcript)
                    * (1 - p) ** sum(1 - bit for _, bit in transcript),
                    "local transcript is not the claimed cylinder")
            if not q[omega]:
                continue
            telescoped = F(1)
            for t, (e, bit) in enumerate(transcript):
                node = nodes[i, transcript[:t], e]
                child_q = node["q_one"] if bit else node["q"] - node["q_one"]
                telescoped *= child_q / node["q"] / (p if bit else 1 - p)
            require(telescoped == local_q[i][transcript] / local_mu[i][transcript],
                    "local entropy likelihood chain does not telescope")

    group_mass = defaultdict(F)
    group_signed = defaultdict(F)
    group_energy = defaultdict(F)
    global_energy = F(0)
    permutation_count = factorial(m)
    for order in permutations(range(m)):
        global_nodes = {}
        decisions = {}
        q_leaves = defaultdict(F)
        mu_leaves = defaultdict(F)
        fibers = defaultdict(list)
        for omega in configurations:
            seen = set()
            fresh = ()
            for rank, i in enumerate(order):
                history = ()
                tree = algorithms[i]
                while tree is not None:
                    e = tree["query"]
                    if e not in seen:
                        descriptor = (rank, i, history, e)
                        if fresh in decisions:
                            require(decisions[fresh] == descriptor,
                                    "fresh-node ownership is not prefix measurable")
                        else:
                            decisions[fresh] = descriptor
                        key = (fresh, descriptor)
                        if key not in global_nodes:
                            global_nodes[key] = [F(0), F(0), F(0), F(0)]
                        data = global_nodes[key]
                        data[0] += q[omega]
                        data[1] += mu[omega]
                        data[2] += q[omega] * omega[e]
                        data[3] += mu[omega] * omega[e]
                        seen.add(e)
                        fresh += ((e, omega[e]),)
                    answer = omega[e]
                    history += ((e, answer),)
                    tree = tree["one" if answer else "zero"]
                require(history == traces[omega, i], "caching changed an individual path")
            if fresh in decisions:
                require(decisions[fresh] is None, "a stop and fresh query share one prefix")
            else:
                decisions[fresh] = None
            q_leaves[fresh] += q[omega]
            mu_leaves[fresh] += mu[omega]
            fibers[fresh].append(omega)
        current_energy = F(0)
        for (prefix, descriptor), (qmass, mumass, qone, muone) in global_nodes.items():
            require(muone == p * mumass, "fresh global reference transition is not p")
            if not qmass:
                continue
            rank, i, history, e = descriptor
            bias = qone / qmass - p
            energy = qmass * bias * bias / permutation_count
            key = ((i, history, e), rank)
            group_mass[key] += qmass / permutation_count
            group_signed[key] += qmass * bias / permutation_count
            group_energy[key] += energy
            global_energy += energy
            current_energy += qmass * bias * bias
        for transcript, mumass in mu_leaves.items():
            require(mumass == p ** sum(bit for _, bit in transcript)
                    * (1 - p) ** sum(1 - bit for _, bit in transcript),
                    "global transcript is not the claimed cylinder")
            if not q_leaves[transcript]:
                continue
            telescoped = F(1)
            for t, (e, bit) in enumerate(transcript):
                prefix = transcript[:t]
                descriptor = decisions[prefix]
                require(descriptor is not None and descriptor[-1] == e,
                        "fresh prefix does not reconstruct the next coordinate")
                qmass, _, qone, _ = global_nodes[prefix, descriptor]
                telescoped *= (qone if bit else qmass - qone) / qmass / (p if bit else 1 - p)
            require(telescoped == q_leaves[transcript] / mumass,
                    "global entropy likelihood chain does not telescope")
        for transcript, members in fibers.items():
            if not q_leaves[transcript]:
                continue
            positive = [omega for omega in members if q[omega]]
            q_conditional_sum = sum((q[omega] / q_leaves[transcript]
                                     for omega in positive), F(0))
            mu_conditional_sum = sum((mu[omega] / mu_leaves[transcript]
                                      for omega in positive), F(0))
            require(q_conditional_sum == 1 and mu_conditional_sum <= 1,
                    "conditional Gibbs lower bound is not nonnegative")
            for omega in positive:
                require(q[omega] / mu[omega]
                        == (q_leaves[transcript] / mu_leaves[transcript])
                        * (q[omega] / q_leaves[transcript])
                        / (mu[omega] / mu_leaves[transcript]),
                        "data-processing conditional likelihood identity failed")
        gamma_lo, _ = divergence_bounds(q_leaves, mu_leaves)
        require(gamma_lo >= 2 * current_energy,
                "inconclusive logarithm enclosure for global Pinsker; not a refutation")

    weighted_energy = F(0)
    root_z, root_w = [], []
    for key, node in nodes.items():
        if not node["q"]:
            continue
        i, history, e = key
        z_values = []
        w_values = []
        for rank in range(m):
            w = sum((q[omega] * fresh_weight(m, rank, len(readers[omega][e]))
                     for omega in node["support"]), F(0)) / node["q"]
            z = sum((q[omega] * (omega[e] - p)
                     * fresh_weight(m, rank, len(readers[omega][e]))
                     for omega in node["support"]), F(0)) / node["q"]
            require(group_mass[key, rank] == node["q"] * w / m,
                    "rank-conditioned freshness pooling failed")
            require(group_signed[key, rank] == node["q"] * z / m,
                    "rank-conditioned signed-bias pooling failed")
            require(0 <= w <= 1, "freshness weight is not a probability")
            if w:
                require(group_energy[key, rank] >= node["q"] * z * z / (m * w),
                        "weighted pooling Cauchy inequality failed")
            else:
                require(z == 0 and group_energy[key, rank] == 0, "bad zero-mass convention")
            z_values.append(z)
            w_values.append(w)
        require(z_values[0] == node["bias"], "rank-zero bias reconstruction failed")
        differences = z_values
        for _ in range(node["a"]):
            differences = [differences[j + 1] - differences[j]
                           for j in range(len(differences) - 1)]
        require(all(value == 0 for value in differences), "rank bias exceeds its degree bound")
        c = grid_constant(node["a"], m)
        require(node["bias"] ** 2
                <= c * sum((v * v for v in z_values), F(0)) / m,
                "node endpoint inequality failed")
        weighted_energy += node["q"] * node["bias"] ** 2 / c
        if i == 0 and not history:
            root_z, root_w = z_values, w_values
    require(weighted_energy <= global_energy, "universal budget transfer regression failed")
    total_q_lo, total_q_hi = divergence_bounds(q, mu)
    local_lo, local_hi = F(0), F(0)
    for qlaw, mulaw in zip(local_q, local_mu):
        lo, hi = divergence_bounds(qlaw, mulaw)
        local_lo += lo
        local_hi += hi
    require(total_q_lo >= 2 * global_energy,
            "inconclusive logarithm enclosure for global entropy; not a refutation")
    require(local_hi <= local_energy / (p * (1 - p)),
            "inconclusive logarithm enclosure for local chi-square; not a refutation")
    c = grid_constant(min(a, m), m) if m else F(0)
    original_factor = F(a * a, 2) / (p * (1 - p))
    refined_factor = c / (2 * p * (1 - p))
    require(local_hi <= original_factor * total_q_lo,
            "inconclusive logarithm enclosure for original bound; not a refutation")
    require(local_hi <= refined_factor * total_q_lo,
            "inconclusive logarithm enclosure for refined bound; not a refutation")
    covariance = F(0)
    if m and algorithms[0] is not None and (0, (), algorithms[0]["query"]) in nodes:
        e = algorithms[0]["query"]
        ex = sum((q[omega] * omega[e] for omega in configurations), F(0))
        ek = sum((q[omega] * len(readers[omega][e]) for omega in configurations), F(0))
        exk = sum((q[omega] * omega[e] * len(readers[omega][e])
                   for omega in configurations), F(0))
        covariance = exk - ex * ek
    return {
        "support_overlap": overlap,
        "full_space_overlap": full_overlap,
        "local_squared_bias_sum": qtext(local_energy),
        "global_squared_bias_budget": qtext(global_energy),
        "root_rank_bias_numerators": list(map(qtext, root_z)),
        "root_rank_freshness_weights": list(map(qtext, root_w)),
        "root_reader_bit_covariance": qtext(covariance),
        "finite_grid_constant": qtext(c),
        "original_entropy_factor": qtext(original_factor),
        "refined_entropy_factor": qtext(refined_factor),
    }


def check_jacobian(spec):
    payload = json.loads((ROOT / spec["payload"]).read_text())
    response = json.loads((ROOT / spec["output"]).read_text())
    status = json.loads((ROOT / spec["status"]).read_text())
    require(status["adapter_exit_code"] == 0, "Jacobian operation did not succeed")
    require(response["request"]["operation_id"] == spec["operation_id"],
            "Jacobian operation id mismatch")
    require(response["request"]["payload"] == payload, "Jacobian retained payload mismatch")
    output = response["result"]["output"]
    matrix = [[F(value["num"]) / F(value["den"]) for value in row]
              for row in output["matrix"]["entries"]]
    require(matrix == [[F(16, i + j + 1) - 1 for j in range(4)] for i in range(4)],
            "Jacobian source is not the intended endpoint Gram matrix")
    lower = [[F(int(i == j)) for j in range(4)] for i in range(4)]
    diagonal = []
    for k in range(4):
        d = matrix[k][k] - sum((lower[k][j] ** 2 * diagonal[j] for j in range(k)), F(0))
        diagonal.append(d)
        for i in range(k + 1, 4):
            remainder = matrix[i][k] - sum(
                (lower[i][j] * lower[k][j] * diagonal[j] for j in range(k)), F(0))
            if d:
                lower[i][k] = remainder / d
            else:
                require(remainder == 0, "zero LDL pivot has a nonzero remaining column")
    for i in range(4):
        for j in range(4):
            require(matrix[i][j] == sum((lower[i][k] * diagonal[k] * lower[j][k]
                                        for k in range(4)), F(0)),
                    "exact LDL source identity failed")
    inertia = [sum(d > 0 for d in diagonal), sum(d < 0 for d in diagonal),
               sum(d == 0 for d in diagonal)]
    require(inertia == spec["expected_inertia"], "independent inertia differs from certificate")
    require(inertia == [output["n_positive"], output["n_negative"], output["n_zero"]],
            "Jacobian inertia differs from independent LDL replay")
    require(output["definiteness"] == "positive_semidefinite" and inertia == [3, 0, 1],
            "endpoint Gram matrix is not positive semidefinite")
    return {"server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"], "inertia": inertia,
            "ldl_diagonal": list(map(qtext, diagonal))}


def check_lean(spec):
    result = json.loads((ROOT / spec["result"]).read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "Lean source lacks a successful compiler run")
    require(result["audit_exit_code"] == 0 and result["proof_holes"] == [],
            "Lean source has unaccepted axioms or proof holes")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "wrong Lean version")
    require(sha256((ROOT / spec["source"]).read_bytes()).hexdigest() == result["source_sha256"],
            "Lean source changed after its compiler run")
    require(sha256((ROOT / spec["statement_fidelity"]).read_bytes()).hexdigest()
            == result["statement_fidelity_sha256"],
            "statement-fidelity document changed after its compiler run")
    recorded = result["kernel"]["recorded"]
    require(recorded["subject"]["subject_id"] == spec["claim"]
            and recorded["tier"] == "mechanical" and recorded["verdict"] == "supports",
            "Lean result is not mechanically recorded on the scoped pooling claim")
    require((ROOT.parents[1] / recorded["artifact"]).is_file(),
            "claim-bound Lean certificate is missing")
    return {"claim": spec["claim"], "version": "4.31.0", "exit_code": 0, "proof_holes": []}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--instance", type=Path,
                        help="replay an arbitrary finite legal instance JSON instead of the regression")
    args = parser.parse_args()
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    identities = symbolic_identities()
    jacobian = check_jacobian(certificate["jacobian"])
    lean = check_lean(certificate["lean"])
    require(identities + ["ldl_source_identity"] == certificate["symbolic_identities"],
            "symbolic certificate list differs from checked identities")
    grids = [check_grid(m, b) for m, b in certificate["grid_cases"]]
    instance = json.loads(args.instance.read_text()) if args.instance else certificate["fixture"]
    result = analyze_instance(instance)
    if not args.instance:
        require(result == certificate["expected"], "exact regression result differs from certificate")
    print(json.dumps({"ok": True, "symbolic_identities": len(identities),
                      "grid_replays": grids, "adaptive_replay": result,
                      "jacobian": jacobian, "lean": lean,
                      "scope": "Universal proof in report.md; exact algebra and finite replay here."},
                     indent=2))


if __name__ == "__main__":
    main()
