#!/usr/bin/env python3
"""Replay exact adaptive optimizations and check the recorded Lean core."""

import argparse
import hashlib
import json
from dataclasses import dataclass
from fractions import Fraction as F
from itertools import combinations, product
from math import prod
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def sign(x):
    return 1 if x >= 0 else -1


def signs(n):
    return tuple(product((-1, 1), repeat=n))


def response(matrix, g, indices):
    return sum(abs(sum(matrix[i][k] * g[i] for i in indices)) for k in indices)


def adaptive(matrix):
    n = len(matrix)
    candidates = []
    for delta in signs(n):
        rows = tuple(sum(matrix[i][k] * delta[k] for k in range(n)) for i in range(n))
        candidates.append((sum(map(abs, rows)), delta, tuple(map(sign, rows))))
    return max(candidates, key=lambda x: x[0])


def deterministic_skeletons():
    n = 4
    edges = tuple(combinations(range(n), 2))
    vectors = signs(n)
    subsets = {m: tuple(combinations(range(n), m)) for m in (1, 2, 3)}
    counts = dict(matrices=0, bilinear_sign_pairs=0, variance_rows=0,
                  sign_loss_scalars=0, skeleton_assignments=0,
                  adaptive_skeleton_bounds=0)
    for entries in product((-1, 0, 1), repeat=len(edges)):
        matrix = [[0] * n for _ in range(n)]
        for (i, k), value in zip(edges, entries):
            matrix[i][k] = matrix[k][i] = value
        degree = max(sum(map(abs, row)) for row in matrix)
        squares = sum(x * x for row in matrix for x in row)
        optimum, _, _ = adaptive(matrix)
        full_maximum = 0
        for delta in vectors:
            rows = tuple(sum(matrix[i][k] * delta[k] for k in range(n)) for i in range(n))
            for epsilon in vectors:
                full_maximum = max(full_maximum, abs(sum(r * e for r, e in zip(rows, epsilon))))
                counts["bilinear_sign_pairs"] += 1
            for m, choices in subsets.items():
                errors = []
                losses = []
                for chosen in choices:
                    estimates = tuple(n * sum(matrix[i][j] * delta[j] for j in chosen)
                                      for i in range(n))
                    g = tuple(map(sign, estimates))
                    loss = sum(abs(rows[i]) - rows[i] * g[i] for i in range(n))
                    losses.append(loss)
                    errors.append(tuple(m * rows[i] - estimates[i] for i in range(n)))
                    for i in range(n):
                        require(0 <= m * (abs(rows[i]) - rows[i] * g[i])
                                <= 2 * abs(m * rows[i] - estimates[i]), "scalar sign loss")
                        counts["sign_loss_scalars"] += 1
                    remaining = tuple(i for i in range(n) if i not in chosen)
                    restricted = response(matrix, g, remaining)
                    require(response(matrix, g, range(n)) <= restricted + 2 * m * degree,
                            "endpoint deletion bound")
                    require(sum(map(abs, rows)) <= restricted + loss + 2 * m * degree,
                            "uniform adaptive deleted-response inequality")
                for i in range(n):
                    error_sum = sum(e[i] for e in errors)
                    error_square_sum = sum(e[i] ** 2 for e in errors)
                    row_squares = sum(matrix[i][k] ** 2 for k in range(n))
                    require(error_sum == 0, "without-replacement unbiasedness")
                    require(error_square_sum * (n - 1) ==
                            len(choices) * m * (n - m) * (n * row_squares - rows[i] ** 2),
                            "exact without-replacement variance identity")
                    require(error_square_sum <= len(choices) * m * n * row_squares,
                            "integrated variance upper bound")
                    counts["variance_rows"] += 1
                require(min(losses) ** 2 * m <= 4 * n * n * squares,
                        "existence of a low-loss skeleton for every column vector")
        require(full_maximum == optimum, "full two-sided adaptive optimum")
        for m, choices in subsets.items():
            family_maximum = 0
            for chosen in choices:
                remaining = tuple(i for i in range(n) if i not in chosen)
                for sigma in signs(m):
                    g = tuple(sign(sum(matrix[i][j] * s for j, s in zip(chosen, sigma)))
                              for i in range(n))
                    family_maximum = max(family_maximum, response(matrix, g, remaining))
                    counts["skeleton_assignments"] += 1
            residual = max(0, optimum - family_maximum - 2 * m * degree)
            require(residual ** 2 * m <= 4 * n * n * squares,
                    "the skeleton family covers the actual adaptive maximum")
            counts["adaptive_skeleton_bounds"] += 1
        counts["matrices"] += 1
    require(counts == dict(matrices=729, bilinear_sign_pairs=186624,
                          variance_rows=139968, sign_loss_scalars=653184,
                          skeleton_assignments=46656, adaptive_skeleton_bounds=2187),
            "the prescribed deterministic search was not exhausted")
    return counts


@dataclass(frozen=True)
class Model:
    name: str
    probabilities: tuple
    tables: dict

    @property
    def n(self):
        return len(self.probabilities)

    def weight(self, i, u):
        return self.probabilities[i] if u else 1 - self.probabilities[i]

    def kernel(self, i, k, u, v):
        if i == k:
            return F(0)
        if i < k:
            return F(self.tables[i, k][u][v])
        return F(self.tables[k, i][v][u])

    def configurations(self, indices):
        for values in product((0, 1), repeat=len(indices)):
            yield dict(zip(indices, values)), prod(self.weight(i, u) for i, u in zip(indices, values))

    def matrix(self, values):
        return tuple(tuple(self.kernel(i, k, values[i], values[k]) for k in range(self.n))
                     for i in range(self.n))


def model_parameters(model):
    n = model.n
    degree = max(sum(model.weight(k, v) * abs(model.kernel(i, k, u, v))
                     for k in range(n) for v in (0, 1))
                 for i in range(n) for u in (0, 1))
    q = max(sum(model.weight(i, u) * model.weight(k, v) * model.kernel(i, k, u, v) ** 2
                for k in range(n) for u, v in product((0, 1), repeat=2)) for i in range(n))
    beta = F(0)
    for tests in signs(2 * n):
        value = sum(model.weight(k, v) *
                    abs(sum(model.weight(i, u) * model.kernel(i, k, u, v) * tests[2 * i + u]
                            for i in range(n) for u in (0, 1)))
                    for k in range(n) for v in (0, 1)) / n
        beta = max(beta, value)
    return degree, q, beta


def fixed_tests(model, chosen, sigma, frozen):
    return {i: tuple(sign(sum(model.kernel(i, j, u, frozen[j]) * s
                             for j, s in zip(chosen, sigma))) for u in (0, 1))
            for i in range(model.n) if i not in chosen}


def restricted_response(model, tests, remaining, values):
    return sum(abs(sum(model.kernel(i, k, values[i], values[k]) * tests[i][values[i]]
                       for i in remaining)) for k in remaining) / model.n


def finite_model(model):
    n = model.n
    all_indices = tuple(range(n))
    c0, q, beta = model_parameters(model)
    adaptive_mean = F(0)
    mass_second = F(0)
    optimizer_groups = {}
    for values, probability in model.configurations(all_indices):
        matrix = model.matrix(values)
        optimum, delta, epsilon = adaptive(matrix)
        brute = max(abs(sum(matrix[i][k] * e[i] * d[k] for i in range(n) for k in range(n)))
                    for e in signs(n) for d in signs(n))
        require(optimum == brute, "product-model adaptive optimum")
        adaptive_mean += probability * optimum / n
        mass = sum(abs(x) for row in matrix for x in row) / n
        mass_second += probability * mass ** 2
        optimizer_groups.setdefault((epsilon, delta), []).append((values, probability))
    require(beta <= adaptive_mean, "integral tests cannot beat the realized adaptive maximum")
    require(mass_second <= c0 ** 2 + q, "normalized total mass second moment")
    conditional_cases = 0
    assignments = 0
    for m in range(1, n):
        for chosen in combinations(all_indices, m):
            remaining = tuple(i for i in all_indices if i not in chosen)
            for sigma in signs(m):
                integrated_conditional = F(0)
                for frozen, frozen_probability in model.configurations(chosen):
                    tests = fixed_tests(model, chosen, sigma, frozen)
                    mean_z = F(0)
                    degree_failure = F(0)
                    d = 2 * c0 + 1
                    for values, probability in model.configurations(remaining):
                        mean_z += probability * restricted_response(model, tests, remaining, values)
                        max_degree = max(sum(abs(model.kernel(i, k, values[i], values[k]))
                                             for k in remaining) for i in remaining)
                        if max_degree > d:
                            degree_failure += probability
                    require(max(F(0), mean_z - beta) ** 2 <= q,
                            "conditional mean beta+sqrt(q) for a fixed assignment")
                    require(degree_failure <= n * q / (d - c0) ** 2,
                            "induced common-degree estimate after fixing outside types")
                    integrated_conditional += frozen_probability * mean_z
                    conditional_cases += 1
                direct_mean = F(0)
                for values, probability in model.configurations(all_indices):
                    tests = fixed_tests(model, chosen, sigma, values)
                    direct_mean += probability * restricted_response(model, tests, remaining, values)
                require(direct_mean == integrated_conditional, "conditional integration preserves the product law")
                assignments += 1
    bias = None
    for (epsilon, delta), group in optimizer_groups.items():
        event_probability = sum(p for _, p in group)
        if 0 < event_probability < 1:
            for i in all_indices:
                posterior = sum(p for values, p in group if values[i]) / event_probability
                if posterior != model.probabilities[i]:
                    bias = dict(model=model.name, site=i, prior=str(model.probabilities[i]),
                                posterior=str(posterior), event_probability=str(event_probability),
                                optimizing_row_signs=list(epsilon), optimizing_column_signs=list(delta))
                    break
        if bias is not None:
            break
    require(conditional_cases == 60 and assignments == 18, "all fixed assignments and frozen types")
    summary = dict(name=model.name, configurations=2 ** n, conditional_cases=conditional_cases,
                   assignments=assignments, C0=str(c0), q=str(q), integral_beta=str(beta),
                   expected_adaptive_cut=str(adaptive_mean), mass_second_moment=str(mass_second))
    return summary, bias


def disconnected_extension():
    table = ((F(0), F(2)), (F(2), F(1, 4)))
    model = Model("disconnected_good_set", (F(1, 2),) * 3,
                  {edge: table for edge in combinations(range(3), 2)})
    indices = tuple(range(3))
    configurations = tuple(model.configurations(indices))
    d, cap = F(1, 2), F(1, 3)
    c = 4 * d / model.n
    good, z = [], {}
    for values, _ in configurations:
        key = tuple(values[i] for i in indices)
        matrix = model.matrix(values)
        z[key] = response(matrix, tuple(1 - 2 * values[i] for i in indices), indices) / model.n
        if max(sum(map(abs, row)) for row in matrix) <= d:
            good.append(key)
    require(good == [(0, 0, 0), (1, 1, 1)], "explicit disconnected degree-good set")
    distance = lambda x, y: sum(u != v for u, v in zip(x, y))
    require(distance(*good) == 3, "the good configurations have no one-site path in the good set")
    extension = {}
    for key in z:
        extension[key] = min(cap, min(min(z[v], cap) + c * distance(key, v) for v in good))
        require(0 <= extension[key] <= cap, "clamped extension range")
        if key in good:
            require(extension[key] == min(z[key], cap), "extension agrees with capped response on good set")
            require((z[key] > F(1, 4)) == (extension[key] > F(1, 4)), "threshold below cap")
    for x, y in product(z, repeat=2):
        require(abs(extension[x] - extension[y]) <= c * distance(x, y),
                "global Hamming extension, not just adjacent good pairs")
        if x in good and y in good:
            require(abs(z[x] - z[y]) <= c * distance(x, y), "arbitrary-good-endpoint response bound")
    expected_z = sum(z.values()) / 8
    expected_extension = sum(extension.values()) / 8
    require(expected_extension <= expected_z + cap * F(3, 4), "mean shift uses capped range")
    for length in range(3):
        for prefix in product((0, 1), repeat=length):
            child_means = []
            for bit in (0, 1):
                completions = [value for key, value in extension.items()
                               if key[:length + 1] == prefix + (bit,)]
                child_means.append(sum(completions) / len(completions))
            require(abs(child_means[0] - child_means[1]) <= c, "Doob conditional range length")
    return dict(good_configurations=[list(x) for x in good], degree=str(d),
                lipschitz_constant=str(c), cap=str(cap), bad_probability="3/4",
                expected_response=str(expected_z), expected_extension=str(expected_extension),
                extension=[dict(types=list(key), response=str(z[key]), value=str(extension[key]))
                           for key in z])


def rare_types_and_jacobian():
    family = []
    for r in (2, 4, 8):
        p, amplitude = F(1, r * r), F(r, 2)
        q = 2 * p * p * amplitude ** 2
        conditional_second = 2 * p * amplitude ** 2
        require(q == p / 2 and conditional_second == F(1, 2),
                "rare-type integrated and conditional squared rows")
        family.append(dict(probability=str(p), amplitude=str(amplitude),
                           integrated_q=str(q), conditional_second=str(conditional_second)))
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    adapter = json.loads((HERE / "jacobian_adapter_status.json").read_text())
    operation = "probability.finite_distribution.raw_moment.compute"
    require(adapter["exit_code"] == 0 and not adapter["timeout"] and adapter["error"] is None,
            "the adapter must have completed, not timed out or returned UNKNOWN")
    require(output["request"] == dict(operation_id=operation, payload=payload), "typed payload binding")
    require(output["result"]["operation_id"] == operation, "typed operation binding")
    rational = lambda x: F(int(x["num"]), int(x["den"]))
    probabilities = [rational(a["probability"]) for a in payload["atoms"]]
    require(sum(probabilities) == 1 and min(probabilities) >= 0, "normalized exact atom probabilities")
    expected_atoms = {F(0): F(2025, 2048), F(4, 3): F(45, 4096), F(4): F(1, 4096)}
    actual_atoms = {}
    p = F(1, 16)
    for values in product((0, 1), repeat=3):
        probability = prod(p if v else 1 - p for v in values)
        mass = F(4, 3) * sum(values[i] * values[k] for i, k in combinations(range(3), 2))
        actual_atoms[mass] = actual_atoms.get(mass, F(0)) + probability
    require(actual_atoms == expected_atoms, "Jacobian atom distribution is the actual rare-type mass")
    require({rational(a["value"]): rational(a["probability"]) for a in payload["atoms"]} == actual_atoms,
            "exact atom payload")
    typed = output["result"]["output"]
    moment = F(0)
    for atom, contribution in zip(payload["atoms"], typed["contributions"], strict=True):
        value, probability = rational(atom["value"]), rational(atom["probability"])
        require(rational(contribution["value"]) == value
                and rational(contribution["probability"]) == probability
                and rational(contribution["powered_value"]) == value ** 2
                and rational(contribution["contribution"]) == probability * value ** 2,
                "replay every typed atom contribution")
        moment += probability * value ** 2
    require(payload["order"] == typed["order"] == 2 and rational(typed["moment"]) == moment == F(3, 128),
            "exact raw second moment")
    return dict(family=family, operation_id=operation, adapter_exit_code=0,
                protocol=output["protocol_version"], server_version=output["server"]["version"],
                exact_mass_second_moment=str(moment))


def exponents():
    M, q, d, m, t = F(32, 100), F(-21, 100), F(7, 100), F(14, 100), F(-20, 100)
    powers = dict(degree_failure=M + q - 2 * d, squared_mass_failure=q - t,
                  threshold_skeleton=(M + t - m) / 2, expected_skeleton=(M + q - m) / 2,
                  deletion=m + d - M, fixed_mean=q / 2, entropy=m,
                  concentration_a=(2 * d - M + m) / 2,
                  exceptional_expectation=(M + q - 2 * d) / 2)
    require(powers == dict(degree_failure=F(-3, 100), squared_mass_failure=F(-1, 100),
                          threshold_skeleton=F(-1, 100), expected_skeleton=F(-3, 200),
                          deletion=F(-11, 100), fixed_mean=F(-21, 200), entropy=F(14, 100),
                          concentration_a=F(-2, 100), exceptional_expectation=F(-3, 200)),
            "manuscript exponent specialization")
    require(powers["concentration_a"] < powers["expected_skeleton"], "logarithmic entropy has power margin")
    return {key: str(value) for key, value in powers.items()}


def finite_size_nonvacuity():
    n = 20
    two = lambda k: F(2) ** k
    M, m, d, q = two(32 * n), two(14 * n), two(7 * n), two(-21 * n)
    delta, t, target = two(-3 * n), two(-20 * n), two(-3 * n // 2)
    p = M * q / (d - 1) ** 2
    sqrt_q, a_upper = two(-21 * n // 2), target
    # log binom(M,m)2^m <= m log(2eM/m); e<3 and log(2)<1.
    log_envelope = m * (18 * n + 3) + 3 * n
    require(d > 1 and 0 < p < 1 and 0 < delta < 1, "finite theorem parameter domain")
    require(a_upper ** 2 * M >= 8 * d ** 2 * log_envelope, "entropy beaten at a finite size")
    require((1 + sqrt_q + a_upper + 1) / (1 - p) <= 4, "finite automatic cap bound")
    require(p <= 4 * two(-3 * n), "finite common degree probability")
    require((1 + q) * (p + delta) <= (4 * target) ** 2, "finite exceptional expectation")
    require((2 * target) ** 2 == 4 * M * q / m, "finite expected skeleton error")
    require(sqrt_q + 4 * p + a_upper + 2 * target + 2 * m * d / M + 4 * target
            <= 10 * target, "finite total expected sampling error")
    require((2 * two(-n)) ** 2 == 4 * M * t / m and q / t == two(-n),
            "finite manuscript squared-mass threshold")
    return dict(B="2^2000", M="2^640", m="2^280", d="2^140", q="2^-420",
                squared_mass_threshold="2^-400", delta="2^-60",
                C0=1, C1=1, K=1, beta=1, cap_upper_bound=4,
                expected_sampling_error_upper_bound="10*2^-30",
                interpretation="Exact nonvacuity of Theorem 1, not constants established for the arithmetic kernels.")


def lean_core():
    run = json.loads((HERE / "lean_run.json").read_text())
    require(run["status"] == "success" and run["exit_code"] == 0 and run["proof_holes"] == [],
            "a real successful zero-hole Lean run is required")
    require("version 4.31.0," in run["tools"]["lean"]["version"], "mandated Lean version")
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    require(hashlib.sha256(source).hexdigest() == run["source_sha256"], "fresh compiled source")
    require(hashlib.sha256(fidelity.encode()).hexdigest() == run["statement_fidelity_sha256"],
            "fresh statement-fidelity reading")
    record = run["kernel"]["recorded"]
    require(record["tier"] == "mechanical" and record["verdict"] == "supports", "recorded compiler evidence")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max((c for c in state["claims"] if c["claim_id"] == "C_CUT_FINITE_CORE"),
                key=lambda c: c["version"])
    require(record["subject"]["content_hash"] == claim["content_hash"], "evidence supports the current claim")
    require(claim["formal_statement"].strip() == source.decode().strip(), "claim carries the compiled text")
    require(any(e["evidence_id"] == record["evidence_id"] for e in state["evidence"]),
            "compiler evidence persisted in the campaign ledger")
    archive = json.loads((ROOT / record["artifact"]).read_text())
    require(archive["lean_check"]["exit_code"] == 0 and archive["lean_source"]["text"].strip() == source.decode().strip(),
            "archived certificate contains the proved source")
    return dict(claim="C_CUT_FINITE_CORE", exit_code=0, proof_holes=[],
                lean_version=run["tools"]["lean"]["version"], certificate=record["artifact"],
                declarations=["adaptive_response_bound", "good_configuration_lipschitz",
                              "adaptive_deleted_response_bound"])


def certify():
    tables = {edge: ((1, 1), (1, -1)) for edge in combinations(range(3), 2)}
    models = [
        Model("signed_fair", (F(1, 2),) * 3, tables),
        Model("signed_nonidentical", (F(1, 2), F(1, 3), F(1, 4)),
              {(0, 1): ((1, -1), (1, 1)), (0, 2): ((-1, 1), (1, -1)), (1, 2): ((1, 1), (-1, 1))}),
        Model("rare_positive", (F(1, 16),) * 3,
              {edge: ((0, 0), (0, 2)) for edge in combinations(range(3), 2)}),
    ]
    summaries, biases = zip(*(finite_model(model) for model in models))
    require(any(F(s["expected_adaptive_cut"]) > F(s["integral_beta"]) for s in summaries),
            "the replay must exercise a genuine finite adaptive gap")
    bias = next((b for b in biases if b is not None), None)
    require(bias is not None, "optimizer conditioning really can alter site laws")
    return dict(
        claim="C_ADAPTIVE_TRANSFER",
        result_class="quantitative_verification_theorem",
        theorem="report.md, Theorem 1, inequalities (3) and (4)",
        universal_probability_proof="Complete prose proof; independent mathematical review still required.",
        arithmetic_inputs_verified=False,
        full_joint_Dickman_law_established=False,
        novelty_status="not_established",
        independent_review="pending",
        deterministic=deterministic_skeletons(),
        finite_models=list(summaries),
        excluded_optimizer_conditioning=bias,
        disconnected_extension=disconnected_extension(),
        rare_types_and_jacobian=rare_types_and_jacobian(),
        manuscript_exponents=exponents(),
        finite_size_nonvacuity=finite_size_nonvacuity(),
        lean=lean_core(),
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true",
                        help="write the exact replay result after every required check succeeds")
    args = parser.parse_args()
    result = certify()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    require(json.loads(path.read_text()) == result, "stored exact certificate differs from its replay")
    print("PASS: 729 full adaptive matrix optimizations; 180 fixed-type conditionings; "
          "global capped extension; exact rare-type moments; fresh Lean 4.31.0 core, no proof holes.")


if __name__ == "__main__":
    main()
