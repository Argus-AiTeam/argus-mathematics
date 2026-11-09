#!/usr/bin/env python3
"""Replay exact experiments and the recorded, scope-limited Lean certificate."""

import argparse
from dataclasses import dataclass
from fractions import Fraction as F
from functools import cache
from hashlib import sha256
from itertools import combinations, product
import json
from math import gcd, lcm, prod
from pathlib import Path


HERE = Path(__file__).resolve().parent
UNIFORM_THEOREM = {
    "quantifiers": "Every admissible specified period pool and every finite recursion depth.",
    "hypotheses": [
        "b>=2; 1<=t<b; c,L,h are positive integers.",
        "The periods n_j>=2 are pairwise coprime and bounded above by R.",
        "The product of every t distinct periods is at least L.",
        "Each g_s is a positive integer; C=c+b-1 and mu=min(c,b-t).",
        "H has real sequence-space l1 values and meets all listed averaged budgets.",
    ],
    "length": "N_0=1; N_s=L*(C+g_s)*N_(s-1).",
    "pointwise_cheap_steps": "ID(W_s(z),W_s(z+e))<=N_s*r for every state and listed (e,r).",
    "pointwise_separation": "ID(W_s(z),W_s(z+u*v))>=N_s*a_s for every state and 0<u<n_j.",
    "a_recurrence": "a_0=1; a_s=2*mu*g_s*a_(s-1)/((2*g_s+mu*a_(s-1))*(C+g_s)).",
    "averaged_displacement": "V_H(u*v)<=B_s for every nonzero distinguished residue.",
    "B_recurrence": "B_0=2; B_s=R^(2*(h-1))/L+2*C*B_(s-1)/(h*(C+g_s)).",
    "boundary_alignment_assumed": False,
    "individual_slice_feasibility_assumed": False,
    "word_map_injectivity_assumed": False,
    "proof": "theorem.md, Sections 1-5",
    "full_uniform_proof_kernel_verified": False,
}


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def lcs(x, y):
    row = [0] * (len(y) + 1)
    for a in x:
        previous = 0
        for j, b in enumerate(y, 1):
            old = row[j]
            row[j] = previous + 1 if a == b else max(row[j], row[j - 1])
            previous = old
    return row[-1]


def distance(x, y):
    return len(x) + len(y) - 2 * lcs(x, y)


def matchings(x, y, i=0, j=0, prefix=()):
    yield prefix
    for a in range(i, len(x)):
        for b in range(j, len(y)):
            if x[a] == y[b]:
                yield from matchings(x, y, a + 1, b + 1, prefix + ((a, b),))


def marked_exhaustion():
    cases = matches = positive_deficit_cases = 0
    for T, p, q in product((1, 2), repeat=3):
        payloads = tuple(product((0, 1), repeat=p))
        lists = tuple(product(payloads, repeat=T))
        for U, V in product(lists, repeat=2):
            x = tuple(a for row in U for a in row + (2,) * q)
            y = tuple(a for row in V for a in row + (2,) * q)
            d = min(p - lcs(u, v) for u, v in product(U, V))
            positive_deficit_cases += d > 0
            cases += 1
            best = 0
            for matching in matchings(x, y):
                matches += 1
                best = max(best, len(matching))
                E = len(x) - len(matching)
                hits = [set() for _ in range(T)]
                target_matches = {b for _, b in matching}
                for a, b in matching:
                    if a % (p + q) < p:
                        require(b % (p + q) < p, "payload matched to marker")
                        hits[a // (p + q)].add(b // (p + q))
                split = [i for i in range(T) if len(hits[i]) > 1]
                chosen = [min(hits[i]) for i in split]
                require(len(set(chosen)) == len(chosen), "marker charged twice")
                for row in chosen:
                    marker = range(row * (p + q) + p, (row + 1) * (p + q))
                    require(not target_matches.intersection(marker), "charged marker matched")
                require(E >= d * (T - len(split)), "unsplit source charge")
                require(E >= q * len(split), "split target charge")
                require(E * (d + q) >= T * d * q, "unrounded marked bound")
            require(best == lcs(x, y), "matching enumeration versus independent LCS")
    return {
        "classification": "finite_exhaustive_experiment_not_uniform_proof",
        "alphabet": [0, 1],
        "T_p_q_each_in": [1, 2],
        "payload_list_pairs": cases,
        "positive_local_deficit_pairs": positive_deficit_cases,
        "all_increasing_matchings": matches,
    }


@dataclass(frozen=True)
class Family:
    periods: tuple
    t: int
    copies: int
    horizon: int
    markers: tuple

    @property
    def C(self):
        return self.copies + len(self.periods) - 1

    @property
    def mu(self):
        return min(self.copies, len(self.periods) - self.t)

    def check_parameters(self):
        b = len(self.periods)
        require(b >= 2 and 1 <= self.t < b, "period count and t")
        require(self.copies >= 1 and self.horizon >= 1, "copies and horizon")
        require(all(n >= 2 for n in self.periods), "period minimum")
        require(all(gcd(a, b) == 1 for a, b in combinations(self.periods, 2)),
                "pairwise coprimality")
        require(all(prod(ns) >= self.horizon for ns in combinations(self.periods, self.t)),
                "every t-period product, not just one product")
        require(all(isinstance(g, int) and g >= 1 for g in self.markers), "marker lengths")

    @cache
    def states(self, depth, j):
        if depth == 0:
            return tuple(range(self.periods[j]))
        return tuple(product(*(self.states(depth - 1, k) for k in range(len(self.periods)))))

    @cache
    def zero(self, depth, j):
        if depth == 0:
            return 0
        return tuple(self.zero(depth - 1, k) for k in range(len(self.periods)))

    @cache
    def distinguished(self, depth, j):
        if depth == 0:
            return 1
        return tuple(self.distinguished(depth - 1, k) if k == j
                     else self.zero(depth - 1, k) for k in range(len(self.periods)))

    def add(self, depth, j, x, y):
        if depth == 0:
            return (x + y) % self.periods[j]
        return tuple(self.add(depth - 1, k, a, b) for k, (a, b) in enumerate(zip(x, y)))

    def scale(self, depth, j, x, a):
        if depth == 0:
            return (x * a) % self.periods[j]
        return tuple(self.scale(depth - 1, k, v, a) for k, v in enumerate(x))

    @cache
    def length(self, depth):
        if depth == 0:
            return 1
        return self.horizon * (self.C + self.markers[depth - 1]) * self.length(depth - 1)

    @cache
    def separation(self, depth):
        if depth == 0:
            return F(1)
        a = self.separation(depth - 1)
        g = self.markers[depth - 1]
        return 2 * self.mu * g * a / ((2 * g + self.mu * a) * (self.C + g))

    @cache
    def word(self, depth, distinguished, z):
        if depth == 0:
            return (z,)
        components = [distinguished] * self.copies
        components += [j for j in range(len(self.periods)) if j != distinguished]
        m = self.length(depth - 1)
        out = []
        for i in range(self.horizon):
            for tag, j in enumerate(components):
                state = self.add(depth - 1, j, z[j],
                                 self.scale(depth - 1, j, self.distinguished(depth - 1, j), i))
                out.extend((tag, symbol) for symbol in self.word(depth - 1, j, state))
            out.extend([None] * (self.markers[depth - 1] * m))
        return tuple(out)

    @cache
    def steps(self, depth, j):
        if depth == 0:
            return tuple((a, F(2)) for a in range(1, self.periods[j]))
        b = len(self.periods)
        tau = tuple(self.distinguished(depth - 1, k) for k in range(b))
        out = [(tau, F(2, self.horizon))]
        for k in range(b):
            copies = self.copies if k == j else 1
            weight = F(copies, self.C + self.markers[depth - 1])
            for e, r in self.steps(depth - 1, k):
                lift = tuple(e if k == a else self.zero(depth - 1, a) for a in range(b))
                out.append((lift, weight * r))
        return tuple(out)


def recursive_exhaustion():
    families = (
        Family((2, 3), 1, 2, 2, (3, 3)),
        Family((4, 9), 1, 1, 3, (1,)),
        Family((2, 3, 5), 2, 2, 6, (2,)),
    )
    cheap = far = row_pairs = shift_rows = states = 0
    summaries = []
    for family in families:
        family.check_parameters()
        max_depth = len(family.markers)
        for depth in range(max_depth + 1):
            N = family.length(depth)
            alphabet_bound = max(family.periods)
            for _ in range(depth):
                alphabet_bound = 1 + family.C * alphabet_bound
            for j, period in enumerate(family.periods):
                alphabet = set()
                v = family.distinguished(depth, j)
                zero = family.zero(depth, j)
                require(family.scale(depth, j, v, period) == zero, "distinguished period")
                for u in range(1, period):
                    require(family.scale(depth, j, v, u) != zero, "exact distinguished order")
                for z in family.states(depth, j):
                    states += 1
                    x = family.word(depth, j, z)
                    alphabet.update(x)
                    require(len(x) == N, "recursive word length")
                    for e, r in family.steps(depth, j):
                        y = family.word(depth, j, family.add(depth, j, z, e))
                        require(distance(x, y) <= N * r, "pointwise cheap step")
                        cheap += 1
                    if depth:
                        row_length = (family.C + family.markers[depth - 1]) * family.length(depth - 1)
                        tau = family.steps(depth, j)[0][0]
                        shifted = family.word(depth, j, family.add(depth, j, z, tau))
                        for i in range(family.horizon - 1):
                            require(shifted[i * row_length:(i + 1) * row_length] ==
                                    x[(i + 1) * row_length:(i + 2) * row_length], "row-shift witness")
                            shift_rows += 1
                    for u in range(1, period):
                        y = family.word(depth, j, family.add(
                            depth, j, z, family.scale(depth, j, v, u)))
                        require(distance(x, y) >= N * family.separation(depth), "global separation")
                        far += 1
                        if depth:
                            m = family.length(depth - 1)
                            p = family.C * m
                            q = family.markers[depth - 1] * m
                            d = m * family.mu * family.separation(depth - 1) / 2
                            for a, b in product(range(family.horizon), repeat=2):
                                U = x[a * (p + q):a * (p + q) + p]
                                V = y[b * (p + q):b * (p + q) + p]
                                require(p - lcs(U, V) >= d, "all-pairs payload deficit")
                                row_pairs += 1
                require(len(alphabet) <= alphabet_bound, "alphabet bound")
        summaries.append({
            "periods": family.periods,
            "t": family.t,
            "copies": family.copies,
            "L": family.horizon,
            "g_by_level": family.markers,
            "depth": max_depth,
            "maximum_word_length": family.length(max_depth),
            "certified_lower_separation_at_test_depth": str(family.separation(max_depth)),
        })
    return {
        "classification": "finite_exhaustive_experiment_not_uniform_proof",
        "families": summaries,
        "all_states_across_levels_and_distinguished_components": states,
        "pointwise_cheap_step_tests": cheap,
        "pointwise_nonzero_shift_tests": far,
        "all_row_pair_tests": row_pairs,
        "explicit_row_shift_equalities": shift_rows,
    }


def translation_data(periods):
    points = tuple(product(*(range(n) for n in periods)))
    index = {x: i for i, x in enumerate(points)}

    def permutation(shift):
        return tuple(index[tuple((a + s) % n for a, s, n in zip(x, shift, periods))]
                     for x in points)

    shifts = []
    for j, n in enumerate(periods):
        shifts.append(tuple(permutation(tuple(a if j == k else 0
                                              for k in range(len(periods))))
                            for a in range(n)))
    return points, permutation((1,) * len(periods)), tuple(shifts)


def translated_mask(mask, permutation):
    out = 0
    while mask:
        bit = mask & -mask
        i = bit.bit_length() - 1
        out |= 1 << permutation[i]
        mask -= bit
    return out


def cut_exhaustion():
    cuts = inequalities = 0
    for periods in ((2, 3), (3, 5)):
        points, tau, shifts = translation_data(periods)
        R = max(periods)
        denominator = lcm(*periods)
        for mask in range(1 << len(points)):
            cuts += 1
            simultaneous = (mask ^ translated_mask(mask, tau)).bit_count()
            counts = [[(mask ^ translated_mask(mask, permutation)).bit_count()
                       for permutation in coordinate] for coordinate in shifts]
            component_numerator = sum((denominator // n) * sum(cs)
                                      for n, cs in zip(periods, counts))
            for h in (1, 2, 3):
                rhs = h * denominator * R ** (2 * (h - 1)) * simultaneous
                rhs += 4 * component_numerator
                for cs in counts:
                    for target in cs[1:]:
                        require(2 * h * denominator * target <= rhs,
                                "strong coprime-period displacement inequality")
                        inequalities += 1
    return {
        "classification": "finite_exhaustive_experiment_not_uniform_proof",
        "period_pools": [[2, 3], [3, 5]],
        "all_Boolean_cuts": cuts,
        "h_values": [1, 2, 3],
        "all_distinguished_nonzero_shift_inequalities": inequalities,
        "arithmetic": "integer cross-multiplication of uniform rational averages",
    }


def anova_replay():
    periods = (2, 3, 5)
    points, tau, shifts = translation_data(periods)
    N = len(points)
    masks = (0, 1, (1 << N) - 1, sum(1 << i for i in range(0, N, 2)),
             sum(1 << i for i, x in enumerate(points) if sum(x) % 3 == 0))
    components_checked = cyclic_orbit_checks = 0

    def inner(x, y):
        return sum(a * b for a, b in zip(x, y)) / N

    def energy(x):
        return inner(x, x)

    def average_j(f, j):
        return tuple(sum(f[permutation[i]] for permutation in shifts[j]) / periods[j]
                     for i in range(N))

    def difference(f, permutation):
        return tuple(f[permutation[i]] - f[i] for i in range(N))

    for mask in masks:
        f = tuple(F((mask >> i) & 1) for i in range(N))
        components = []
        for support in range(1 << len(periods)):
            value = f
            for j in range(len(periods)):
                mean = average_j(value, j)
                value = tuple(x - y for x, y in zip(value, mean)) if support >> j & 1 else mean
            components.append(value)
        require(tuple(map(sum, zip(*components))) == f, "orthogonal expansion")
        for i, j in combinations(range(len(components)), 2):
            require(inner(components[i], components[j]) == 0, "orthogonality")
        require(sum(energy(v) for v in components) == energy(f), "Parseval without Fourier")
        for support, value in enumerate(components):
            components_checked += 1
            E = energy(value)
            for j in range(len(periods)):
                average = sum(energy(difference(value, p)) for p in shifts[j]) / periods[j]
                require(average == (2 * E if support >> j & 1 else 0),
                        "averaged active/inactive coordinate energy")
            if not support:
                continue
            q = prod(n for j, n in enumerate(periods) if support >> j & 1)
            orbit = [value]
            for _ in range(1, q):
                orbit.append(tuple(orbit[-1][i] for i in tau))
            require(tuple(map(sum, zip(*orbit))) == (F(0),) * N, "CRT orbit average")
            delta = energy(difference(value, tau))
            orbit_displacements = []
            for a, v in enumerate(orbit):
                cyclic_orbit_checks += 1
                displacement = energy(tuple(x - y for x, y in zip(v, value)))
                require(displacement <= min(a, q - a) ** 2 * delta, "short cyclic path")
                orbit_displacements.append(displacement)
            require(sum(orbit_displacements) / q == 2 * E, "cyclic variance identity")
            require(4 * E <= F(q * q, 2) * delta, "low-support Poincare coefficient")
    return {
        "classification": "finite_exact_structural_replay_not_uniform_proof",
        "periods": list(periods),
        "Boolean_examples": len(masks),
        "orthogonal_components": components_checked,
        "cyclic_short_path_checks": cyclic_orbit_checks,
        "uses_complex_numbers_or_floating_point": False,
    }


def direct_sum_replay():
    nx, ny, nz = 3, 10, 3
    weight = F(2, 7)

    def H(x, y):
        return (F(x * x if y == 0 else 0), F((x + y) % 2), F(x * y, 3))

    checks = 0
    for e in range(nx):
        lifted = sum(sum(abs(a - b) for a, b in zip(H((x + e) % nx, y), H(x, y)))
                     for x in range(nx) for y in range(ny)) / (nx * ny)
        direct = sum(sum(abs((H((x + e) % nx, y)[z] - H(x, y)[z]) / (weight * ny))
                         for y in range(ny) for z in range(nz))
                     for x in range(nx)) / nx
        require(direct == lifted / weight, "direct-sum averaged identity")
        checks += 1
    return {"classification": "finite_exact_replay_not_uniform_proof",
            "slice_count": ny, "weight": str(weight), "all_component_steps": checks}


def jacobian_replay():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    require(response["request"]["payload"] == payload, "Jacobian source payload mismatch")
    require(response["server"]["version"] == "0.14.0", "Jacobian recorded server")
    require(response["result"]["operation_id"] ==
            "optimization.linear.rational_general_optimum.compute", "Jacobian operation")
    output = response["result"]["output"]
    require(output["status"] == "OPTIMAL", "Jacobian incomplete/UNKNOWN is not evidence")
    require(output["program"] == payload["program"], "Jacobian original-coordinate program")

    def rational(x):
        return F(int(x["num"]), int(x["den"]))

    point = tuple(map(rational, output["primal_candidate"]))
    dual = tuple(map(rational, output["constraint_dual"]))
    program = payload["program"]
    for variable, x in zip(program["variables"], point):
        if variable["lower_bound"] is not None:
            require(x >= rational(variable["lower_bound"]), "LP lower bound")
        if variable["upper_bound"] is not None:
            require(x <= rational(variable["upper_bound"]), "LP upper bound")
    require(all(x >= 0 for x in dual), "GE-row minimization dual sign")
    rows = [tuple(map(rational, c["coefficients"])) for c in program["constraints"]]
    rhs = [rational(c["rhs"]) for c in program["constraints"]]
    for row, bound in zip(rows, rhs):
        require(sum(a * x for a, x in zip(row, point)) >= bound, "LP primal row")
    objective = tuple(map(rational, program["objective"]["coefficients"]))
    require(tuple(sum(dual[i] * rows[i][j] for i in range(len(rows)))
                  for j in range(len(point))) == objective, "LP exact dual balance")
    primal_value = sum(a * x for a, x in zip(objective, point))
    dual_value = sum(a * b for a, b in zip(dual, rhs))
    require(primal_value == dual_value == F(60, 7), "LP strong-duality replay")
    require(rational(output["primal_objective"]) == primal_value, "LP returned objective")
    require(rational(output["dual_objective"]) == dual_value, "LP returned dual objective")
    return {"classification": "one_bounded_LP_not_a_uniform_matching_proof",
            "operation_id": response["result"]["operation_id"],
            "protocol_version": response["protocol_version"],
            "server_version": response["server"]["version"],
            "adapter_status": "OPTIMAL", "adapter_error": None, "timeout": False,
            "exact_optimum": str(primal_value), "independent_primal_dual_replay": True}


def lean_replay():
    result = json.loads((HERE / "lean_result.json").read_text())
    require(result["status"] == "success", "Lean compiler did not succeed")
    require(result["exit_code"] == 0, "nonzero Lean exit")
    require(result["proof_holes"] == [], "Lean proof holes")
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text().encode()
    require(result["source_sha256"] == sha256(source).hexdigest(), "stale Lean source")
    require(result["statement_fidelity_sha256"] == sha256(fidelity).hexdigest(),
            "stale statement fidelity")
    kernel = result["kernel"]
    require(kernel.get("recorded") is not None, "Lean evidence was not attached to its claim")
    return {
        "classification": "kernel_verification_of_explicitly_limited_core_only",
        "claim": "C_PP_FORMAL",
        "exit_code": 0,
        "proof_holes": [],
        "full_family_kernel_formalized": False,
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
    }


def original_specialization():
    checks = 0
    for k in range(1, 6):
        b = 100 * k
        P, h = b * b, 10 * k
        L = P ** (b // 2)
        C, mu = 2 * b - 1, b // 2
        a, sharp, old = F(1), F(2), F(2)
        epsilon_sharp = F((2 * P) ** (2 * h - 2), L)
        epsilon_old = F(2 * (2 * P) ** (2 * h), L)
        for s in range(1, 21):
            a = mu * a / (2 * C + mu * a)
            sharp = epsilon_sharp + sharp / h
            old = epsilon_old + old / h
            require(a >= F(1, 9 ** s) >= F(1, 24 ** s), "improved geometric specialization")
            require(sharp <= old, "improved analytic specialization")
            checks += 1
    return {"classification": "finite_parameter_arithmetic_not_uniform_proof",
            "k_values": [1, 2, 3, 4, 5], "depths_per_k": 20, "checks": checks,
            "prime_pool_existence_inferred": False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = {
        "claim": "C_PP_GENERAL",
        "result_class": "new_reduction_candidate",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "uniform_proof": "theorem.md",
        "uniform_proof_kind": "complete_prose_proof_requiring_independent_review",
        "uniform_theorem": UNIFORM_THEOREM,
        "stronger_manuscript_constants": {
            "separation": "9^(-s) instead of 24^(-s)",
            "analytic_additive_term": "(2P)^(2h-2)/L instead of 2(2P)^(2h)/L",
            "same_words_and_step_lists": True,
        },
        "independent_review_required": True,
        "independent_review_completed": False,
        "novelty_status": "pending_independent_review",
        "significance_status": "pending_independent_review",
        "campaign_complete": False,
        "jacobian": jacobian_replay(),
        "marked_matchings": marked_exhaustion(),
        "recursive_words": recursive_exhaustion(),
        "analytic_all_cuts": cut_exhaustion(),
        "orthogonal_projection_route": anova_replay(),
        "direct_sum": direct_sum_replay(),
        "original_specialization": original_specialization(),
        "formal_core": lean_replay(),
        "refuted_manuscript_assertions": [],
        "limitations": [
            "The entire recursive-family theorem is not kernel formalized.",
            "Finite experiments do not establish the parameter-uniform theorem.",
            "No prime-supply, binary-code, or upper-bound theorem is certified.",
            "No independent Reviewer, significance, or novelty approval is claimed.",
        ],
    }
    certificate = json.loads(json.dumps(certificate))
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        expected = json.loads(path.read_text())
        require(certificate == expected, "rerun differs from exact_certificate.json")
    print(json.dumps({
        "status": "passed",
        "matching_cases": certificate["marked_matchings"]["all_increasing_matchings"],
        "word_cheap_step_tests": certificate["recursive_words"]["pointwise_cheap_step_tests"],
        "cut_inequalities": certificate["analytic_all_cuts"]["all_distinguished_nonzero_shift_inequalities"],
        "formal_core": "C_PP_FORMAL only; full theorem requires independent proof review",
        "independent_review_completed": False,
    }, indent=2))


if __name__ == "__main__":
    main()
