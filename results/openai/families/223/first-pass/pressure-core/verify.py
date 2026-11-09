#!/usr/bin/env python3
"""Exact diagnostics for the below-one manuscript's site-pressure mechanism."""

import argparse
import hashlib
import itertools
import json
import math
from collections import defaultdict
from fractions import Fraction as Q
from pathlib import Path


HERE = Path(__file__).resolve().parent
DEGREE = 4


def product(values):
    answer = Q(1)
    for value in values:
        answer *= value
    return answer


def subsets(size):
    for mask in range(1 << size):
        yield tuple(i for i in range(size) if mask & (1 << i))


def components(size, edges):
    parent = list(range(size))

    def root(i):
        while parent[i] != i:
            i = parent[i]
        return i

    for a, b in edges:
        parent[root(a)] = root(b)
    blocks = defaultdict(list)
    for i in range(size):
        blocks[root(i)].append(i)
    return tuple(tuple(block) for block in blocks.values())


def clean(poly):
    return {m: value for m, value in poly.items() if value}


def multiply(left, right, degree):
    answer = defaultdict(Q)
    for a, av in left.items():
        for b, bv in right.items():
            m = tuple(x + y for x, y in zip(a, b))
            if sum(m) <= degree:
                answer[m] += av * bv
    return clean(answer)


def site_polynomial(size, edges, q):
    denominator = product(1 + v for _, _, v in edges)
    answer = defaultdict(Q)
    zero = (0,) * size
    for chosen in subsets(len(edges)):
        state = [(edges[i][0], edges[i][1]) for i in chosen]
        value = product(edges[i][2] for i in chosen) / denominator
        term = {zero: Q(1)}
        for block in components(size, state):
            exponent = tuple(int(i in block) for i in range(size))
            term = multiply(term, {zero: Q(1), exponent: q - 1}, size)
        for m, coefficient in term.items():
            answer[m] += value * coefficient
    return clean(answer)


def pressure_coefficients(poly, degree):
    zero = (0,) * len(next(iter(poly)))
    assert poly[zero] == 1
    increment = {m: value for m, value in poly.items() if m != zero}
    power = {zero: Q(1)}
    answer = defaultdict(Q)
    for k in range(1, degree + 1):
        power = multiply(power, increment, degree)
        for m, coefficient in power.items():
            answer[m] += Q((-1) ** k, k) * coefficient
    return clean(answer)


def simple_graph(edges):
    odds = defaultdict(lambda: Q(1))
    for a, b, value in edges:
        if a != b:
            odds[tuple(sorted((a, b)))] *= 1 + value
    return tuple((a, b, value - 1) for (a, b), value in sorted(odds.items()))


def partition_sum(size, edges, parameter):
    answer = Q(0)
    for chosen in subsets(len(edges)):
        state = [(edges[i][0], edges[i][1]) for i in chosen]
        answer += parameter ** len(components(size, state)) * product(
            edges[i][2] for i in chosen
        )
    return answer


def squarefree_moments(size, edges, q):
    answer = {}
    for chosen in subsets(size):
        indices = {vertex: i for i, vertex in enumerate(chosen)}
        induced = tuple(
            (indices[a], indices[b], v)
            for a, b, v in edges
            if a in indices and b in indices
        )
        answer[frozenset(chosen)] = product(1 + v for _, _, v in induced) * (
            partition_sum(len(chosen), induced, q - 1)
        )
    return answer


def polymer_moments(size, edges, q):
    amplitudes = {}
    for vertices in subsets(size):
        if not vertices:
            continue
        indices = {vertex: i for i, vertex in enumerate(vertices)}
        induced = tuple(
            (indices[a], indices[b], v)
            for a, b, v in edges
            if a in indices and b in indices
        )
        amplitude = Q(0)
        for chosen in subsets(len(induced)):
            ordinary = tuple(induced[i] for i in chosen)
            if len(components(len(vertices), [(a, b) for a, b, _ in ordinary])) != 1:
                continue
            negative_partition = partition_sum(
                len(vertices), tuple((a, b, 1 + v) for a, b, v in ordinary), q - 1
            )
            assert negative_partition < 0
            amplitude -= product(v for _, _, v in ordinary) * negative_partition
        assert amplitude >= 0
        amplitudes[frozenset(vertices)] = amplitude
    moments = {}
    for vertices in subsets(size):
        moments[frozenset(vertices)] = sum(
            product(-amplitudes[frozenset(block)] for block in partition)
            for partition in set_partitions(list(vertices))
        )
    return moments


def set_partitions(elements):
    if not elements:
        yield ()
        return
    first, *rest = elements
    for partition in set_partitions(rest):
        yield ((first,),) + partition
        for j in range(len(partition)):
            yield partition[:j] + ((first,) + partition[j],) + partition[j + 1 :]


def labeled_cumulant(types, moments):
    answer = Q(0)
    for partition in set_partitions(list(range(len(types)))):
        weight = Q((-1) ** (len(partition) - 1) * math.factorial(len(partition) - 1))
        for block in partition:
            labels = [types[i] for i in block]
            if len(set(labels)) != len(labels):
                weight = Q(0)
                break
            weight *= moments[frozenset(labels)]
        answer += weight
    return answer


def grouped_connected_sum(types, edges, q):
    odds = {(a, b): v for a, b, v in edges}
    ordinary = []
    hard = []
    for a, b in itertools.combinations(range(len(types)), 2):
        if types[a] == types[b]:
            hard.append((a, b))
        elif tuple(sorted((types[a], types[b]))) in odds:
            ordinary.append((a, b, odds[tuple(sorted((types[a], types[b])))]))
    answer = Q(0)
    groups = 0
    for union in subsets(len(ordinary)):
        d_edges = tuple(ordinary[i] for i in union)
        d_pairs = [(a, b) for a, b, _ in d_edges]
        blocks = components(len(types), d_pairs)
        fixed_union = product(v for _, _, v in d_edges) * partition_sum(
            len(types), tuple((a, b, 1 + v) for a, b, v in d_edges), q - 1
        )
        direct_union = Q(0)
        for a_set in subsets(len(d_edges)):
            for b_set in subsets(len(d_edges)):
                if set(a_set) | set(b_set) != set(range(len(d_edges))):
                    continue
                direct_union += product(d_edges[i][2] for i in a_set) * product(
                    d_edges[i][2] for i in b_set
                ) * (q - 1) ** len(
                    components(len(types), [d_pairs[i] for i in a_set])
                )
        assert fixed_union == direct_union, ("fixed-union", types, union)
        assert (-1) ** len(blocks) * fixed_union >= 0
        hard_sum = sum(
            (-1) ** len(chosen)
            for chosen in subsets(len(hard))
            if len(
                components(len(types), d_pairs + [hard[i] for i in chosen])
            ) == 1
        )
        assert (-1) ** (len(blocks) - 1) * hard_sum >= 0
        contribution = fixed_union * hard_sum
        assert contribution <= 0
        answer += contribution
        groups += 1
    return answer, groups


def multiindices(size, degree):
    return (
        m
        for m in itertools.product(range(degree + 1), repeat=size)
        if 0 < sum(m) <= degree
    )


def fk_moments(size, edges, q):
    z = Q(0)
    singles = [Q(0)] * len(edges)
    pairs = defaultdict(Q)
    for chosen in subsets(len(edges)):
        weight = q ** len(
            components(size, [(edges[i][0], edges[i][1]) for i in chosen])
        ) * product(edges[i][2] for i in chosen)
        z += weight
        for i in chosen:
            singles[i] += weight
        for i, j in itertools.combinations(chosen, 2):
            pairs[i, j] += weight
    return z, singles, pairs


def cases():
    for size in (1, 2, 3):
        possible = list(itertools.combinations(range(size), 2))
        for chosen in subsets(len(possible)):
            for profile in (0, 1):
                edges = tuple(
                    (*possible[i], Q(1, 2) if profile == 0 else Q(i + 1))
                    for i in chosen
                )
                for q in (Q(1, 3), Q(1, 2), Q(3, 4)):
                    yield size, edges, q
    examples = (
        ((0, 1), (1, 2), (2, 3), (3, 0)),
        tuple(itertools.combinations(range(4), 2)),
        ((0, 1), (1, 2), (0, 2), (2, 3), (1, 3)),
        ((0, 1), (2, 3)),
    )
    for pairs in examples:
        edges = tuple((*pair, Q(i + 1, 2)) for i, pair in enumerate(pairs))
        for q in (Q(1, 3), Q(1, 2), Q(3, 4)):
            yield 4, edges, q
    yield 2, ((0, 0, Q(3)), (0, 1, Q(1, 2)), (0, 1, Q(2))), Q(1, 2)
    yield 3, ((0, 1, Q(0)), (1, 2, Q(2))), Q(1, 2)


def run_diagnostics():
    coefficient_checks = 0
    connected_groups = 0
    incident_checks = 0
    case_count = 0
    repeated_checks = 0
    polymer_checks = 0
    for size, original_edges, q in cases():
        case_count += 1
        edges = simple_graph(original_edges)
        poly = site_polynomial(size, original_edges, q)
        assert poly == site_polynomial(size, edges, q)
        coefficients = pressure_coefficients(poly, DEGREE)
        moments = squarefree_moments(size, edges, q)
        assembled = polymer_moments(size, edges, q)
        assert assembled == moments, ("polymer-identity", size, edges, q)
        polymer_checks += len(moments)
        gamma = tuple(
            1 / product(1 + v for a, b, v in edges if i in (a, b))
            for i in range(size)
        )
        for chosen in subsets(size):
            exponent = tuple(int(i in chosen) for i in range(size))
            assert poly.get(exponent, Q(0)) == moments[frozenset(chosen)] * product(
                gamma[i] for i in chosen
            )
        for m in multiindices(size, DEGREE):
            types = tuple(i for i, multiplicity in enumerate(m) for _ in range(multiplicity))
            cumulant = labeled_cumulant(types, moments)
            connected_sum, groups = grouped_connected_sum(types, edges, q)
            assert cumulant == connected_sum, ("exponential-formula", size, edges, q, m)
            predicted = -cumulant * product(
                gamma[i] ** m[i] / math.factorial(m[i]) for i in range(size)
            )
            actual = coefficients.get(m, Q(0))
            assert actual == predicted, ("coefficient", size, edges, q, m)
            assert actual >= 0, ("sign", size, edges, q, m, actual)
            if actual:
                support = [i for i in range(size) if m[i]]
                indices = {vertex: i for i, vertex in enumerate(support)}
                induced = [(indices[a], indices[b]) for a, b, _ in edges if a in indices and b in indices]
                assert len(components(len(support), induced)) == 1
            coefficient_checks += 1
            connected_groups += groups
            repeated_checks += int(max(m) > 1)
        hub_edges = original_edges + tuple((i, size, Q(i + 1, 2)) for i in range(size))
        hub_edges += ((0, size, Q(2)),)
        z, singles, pairs = fk_moments(size + 1, hub_edges, q)
        for i, j in itertools.combinations(range(len(hub_edges)), 2):
            if set(hub_edges[i][:2]) & set(hub_edges[j][:2]):
                assert pairs[i, j] * z <= singles[i] * singles[j], (
                    "incident-Rayleigh", size, hub_edges, q, i, j
                )
                incident_checks += 1
        s = tuple(
            product(1 + v for a, b, v in hub_edges[len(original_edges):] if i in (a, b))
            for i in range(size)
        )
        evaluation = sum(
            value * product(s[i] ** -m[i] for i in range(size))
            for m, value in poly.items()
        )
        assert z == q * product(1 + v for _, _, v in original_edges) * product(s) * evaluation
    return {
        "result_class": "finite_verification",
        "universal_conclusion": False,
        "source": "01-pressure.tex",
        "assertions": [
            "pressure:squarefree",
            "pressure:fixed-union",
            "labeled exponential formula including repeated types",
            "pressure:negative-partition (tested instances)",
            "hard-edge alternating sign",
            "exact connected-ordinary-union hard-core polymerization",
            "thm:pressure (coefficients of total degree at most four)",
            "pressure:hub-partition",
            "lem:adjacent-rayleigh (tested incident pairs)",
        ],
        "arithmetic": "fractions.Fraction; no numerical tolerance",
        "maximum_total_degree": DEGREE,
        "graph_parameter_cases": case_count,
        "coefficient_checks": coefficient_checks,
        "repeated_label_coefficient_checks": repeated_checks,
        "ordinary_union_groups": connected_groups,
        "polymer_moment_checks": polymer_checks,
        "incident_covariance_checks": incident_checks,
        "counterexample_found": False,
        "interpretation": "Diagnostics only; not a universal proof or campaign completion.",
    }


def sparse_polynomial(value):
    return {
        tuple(term["exponents"]): Q(
            int(term["coefficient"]["num"]), int(term["coefficient"]["den"])
        )
        for term in value["polynomial"]["terms"]
    }


def differentiate(poly, variable):
    answer = {}
    for m, value in poly.items():
        if m[variable]:
            exponent = list(m)
            exponent[variable] -= 1
            answer[tuple(exponent)] = value * m[variable]
    return answer


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    assert response["request"]["payload"] == payload
    assert response["result"]["operation_id"] == "polynomial.multivariate.factor.compute"
    assert "error" not in response
    result = response["result"]["output"]
    assert result["status"] == "FACTORIZED"
    assert result["product_reconstruction"] == "EXACT"
    assert payload["polynomial"]["variables"] == ["q", "a", "b", "c"]
    z = {}
    triangle = ((0, 1), (0, 2), (1, 2))
    for chosen in subsets(3):
        exponent = (
            len(components(3, [triangle[i] for i in chosen])),
            *(int(i in chosen) for i in range(3)),
        )
        z[exponent] = Q(1)
    delta = defaultdict(Q)
    for m, value in multiply(differentiate(z, 1), differentiate(z, 2), 32).items():
        delta[m] += value
    for m, value in multiply(z, differentiate(differentiate(z, 1), 2), 32).items():
        delta[m] -= value
    delta = clean(delta)
    assert sparse_polynomial(payload["polynomial"]) == delta
    assert sparse_polynomial(result["reconstructed"]) == delta
    coefficient = result["coefficient"]
    reconstructed = {(0, 0, 0, 0): Q(int(coefficient["num"]), int(coefficient["den"]))}
    for factor in result["factors"]:
        assert factor["factor"]["variables"] == ["q", "a", "b", "c"]
        for _ in range(factor["multiplicity"]):
            reconstructed = multiply(reconstructed, sparse_polynomial(factor["factor"]), 32)
    assert reconstructed == delta
    return {
        "operation_id": response["result"]["operation_id"],
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_status": result["status"],
        "exact_payload": "research/pressure-core/jacobian_payload.json",
        "typed_output": "research/pressure-core/jacobian_output.json",
        "independent_product_reconstruction": True,
        "triangle_Rayleigh_numerator": "q^2*(1-q)*c*(q+c)",
        "scope": "One symbolic identity, not a proof for all graphs.",
    }


def check_formal_evidence():
    recorded = json.loads((HERE / "lean_verify_output.json").read_text())
    kernel = recorded["kernel"]
    assert not kernel["refusals"]
    evidence = kernel["recorded"]
    assert evidence["subject"]["subject_id"] == "PC_POLYMER"
    assert evidence["tier"] == "mechanical" and evidence["verdict"] == "supports"
    project_root = HERE.parents[1]
    archived = json.loads((project_root / evidence["artifact"]).read_text())
    check = archived["lean_check"]
    assert {key: value for key, value in recorded.items() if key != "kernel"} == check
    assert check["status"] == "success" and check["exit_code"] == 0
    assert check["proof_holes"] == [] and check["audit_exit_code"] == 0
    assert check["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,")
    assert not check["environment_failure"]
    assert hashlib.sha256((HERE / "Main.lean").read_bytes()).hexdigest() == check["source_sha256"]
    assert hashlib.sha256((HERE / "statement_fidelity.md").read_bytes()).hexdigest() == (
        check["statement_fidelity_sha256"]
    )
    assert archived["lean_source"]["text"] == (HERE / "Main.lean").read_text()
    assert archived["statement_fidelity"]["text"] == (HERE / "statement_fidelity.md").read_text()
    return {
        "claim": "PC_POLYMER",
        "certificate": evidence["artifact"],
        "compiler_version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "axiom_audit_exit_code": 0,
        "source_and_fidelity_current": True,
        "theorems": [
            "PressureCore.hard_core_pressure_nonnegative",
            "PressureCore.monomial_pressure_nonnegative",
        ],
        "quantifiers": "Every finite polymer set, symmetric compatibility, nonnegative zero-constant polynomial-coefficient activities, grading degree and site multiindex; repeated labels unrestricted.",
        "kernel_boundary": "Generic hard-core coefficient mechanism. FK polymerization, Tutte sign, support, convergence and Rayleigh are proved in report.md, not encoded as Lean graph/analysis theorems.",
        "replay_boundary": "This script checks the archived real compiler result and freshness, not a new compiler invocation.",
    }


def exact_example():
    poly = site_polynomial(2, ((0, 1, Q(1)),), Q(1, 2))
    pressure = pressure_coefficients(poly, DEGREE)
    return {
        "vertices": [0, 1],
        "edges": [{"endpoints": [0, 1], "odds": "1"}],
        "q": "1/2",
        "site_polynomial": [
            {"multiindex": list(m), "coefficient": str(value)}
            for m, value in sorted(poly.items())
        ],
        "pressure_coefficients": [
            {"multiindex": list(m), "coefficient": str(pressure[m])}
            for m in ((1, 1), (2, 1), (2, 2))
        ],
    }


def run():
    return {
        "result_class": "universal_formal_verification_with_prose_reduction",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "campaign_complete": False,
        "independent_review": "pending Host-invoked Reviewer",
        "classical_novelty_claimed": False,
        "formal_verification": check_formal_evidence(),
        "finite_diagnostics": run_diagnostics(),
        "jacobian": check_jacobian(),
        "exact_example": exact_example(),
        "mathematical_proof": "research/pressure-core/report.md",
        "interpretation": "Universal generic coefficient theorem is kernel checked. The complete finite FK proof is in prose for independent reduction/fidelity review. Finite tests are not promoted to universal evidence.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = run()
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2) + "\n")
    else:
        assert json.loads(certificate.read_text()) == result, "certificate differs from replay"
    print(json.dumps({
        "formal_exit_code": result["formal_verification"]["exit_code"],
        "proof_holes": result["formal_verification"]["proof_holes"],
        "diagnostics": result["finite_diagnostics"],
        "jacobian_status": result["jacobian"]["adapter_status"],
        "independent_review": result["independent_review"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
