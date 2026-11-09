#!/usr/bin/env python3
"""Replay exact diagnostics and check the recorded Lean core's freshness.

This script does not check the analytic proof of energy bounds or locality.
The actual compiler invocation is given in report.md.
"""

import argparse
from collections import Counter, defaultdict
from fractions import Fraction
from hashlib import sha256
from itertools import product
import json
from math import comb, factorial
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def formal_core():
    source = (HERE / "Main.lean").read_text(encoding="utf-8")
    fidelity = (HERE / "statement_fidelity.md").read_text(encoding="utf-8")
    run = read_json(HERE / "lean_check.json")
    require(run["status"] == "success", "Lean did not succeed")
    require(run["exit_code"] == 0, "nonzero Lean exit")
    require(run["proof_holes"] == [], "Lean proof holes")
    require(run["audit_exit_code"] == 0, "axiom audit did not succeed")
    require("version 4.31.0," in run["tools"]["lean"]["version"], "wrong Lean version")
    require(
        run["source_sha256"] == sha256(source.encode()).hexdigest(),
        "Lean source changed after compilation",
    )
    require(
        run["statement_fidelity_sha256"] == sha256(fidelity.encode()).hexdigest(),
        "statement fidelity changed after compilation",
    )
    state = read_json(ROOT / "research/MATH_STATE.json")
    claim = max(
        (c for c in state["claims"] if c["claim_id"] == "C_PATH_CORE"),
        key=lambda c: c["version"],
    )
    require(claim["formal_statement"].strip() == source.strip(),
            "ledger carries a different formal source")
    evidence = [
        e for e in state["evidence"]
        if e["subject"]["subject_id"] == "C_PATH_CORE"
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
    ]
    require(len(evidence) == 1, "expected one current mechanical core certificate")
    artifact = evidence[0]["artifact"]
    archive = read_json(ROOT / artifact)
    require(archive["lean_source"]["text"] == source, "archived source mismatch")
    require(archive["statement_fidelity"]["text"] == fidelity, "archived reading mismatch")
    require(archive["lean_check"] == run, "archive does not describe the actual compiler run")
    return {
        "claim": "C_PATH_CORE",
        "certificate": artifact,
        "lean_version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "axiom_audit_exit_code": 0,
        "source_sha256": run["source_sha256"],
        "statement_fidelity_sha256": run["statement_fidelity_sha256"],
        "declarations": [
            "EnergyBootstrap.graphSchur",
            "EnergyBootstrap.tupleSumCount",
            "EnergyBootstrap.modeSumSchur",
            "EnergyBootstrap.iteratedColumns",
            "EnergyBootstrap.rightPrefixBudget",
            "EnergyBootstrap.rightEnergyCutoff",
            "EnergyBootstrap.oneModeIndexBound",
            "EnergyBootstrap.mixedExponentIdentity",
        ],
        "scope": "universal finite operator-path core, not the analytic VOA theorem",
    }


def count_and_schur_checks():
    fibers = 0
    for length in range(1, 7):
        for bound in range(5):
            counts = Counter(map(sum, product(range(bound + 1), repeat=length)))
            for count in counts.values():
                require(count <= (bound + 1) ** (length - 1), "tuple fiber overflow")
                fibers += 1
    graphs = 0
    edges = 0
    for p, q, bound in product(range(1, 5), range(1, 5), range(4)):
        left = list(product(range(bound + 1), repeat=p))
        right = list(product(range(bound + 1), repeat=q))
        lc, rc = Counter(map(sum, left)), Counter(map(sum, right))
        la, rb = defaultdict(int), defaultdict(int)
        a = [(-1) ** sum(v) * (1 + sum((i + 1) * x for i, x in enumerate(v)))
             for v in left]
        b = [(-1) ** v[0] * (2 + sum((i + 2) * x for i, x in enumerate(v)))
             for v in right]
        for v, weight in zip(left, a):
            la[sum(v)] += weight
        for v, weight in zip(right, b):
            rb[sum(v)] += weight
        sa, sb = sum(x * x for x in a), sum(x * x for x in b)
        for target in range(-p * bound - 1, q * bound + 2):
            row = max(rc.get(s + target, 0) for s in lc)
            col = max(lc.get(s - target, 0) for s in rc)
            require(row <= (bound + 1) ** (q - 1), "row completion bound")
            require(col <= (bound + 1) ** (p - 1), "column completion bound")
            pairing = sum(weight * rb.get(s + target, 0) for s, weight in la.items())
            require(pairing * pairing <= row * col * sa * sb, "Schur inequality")
            require(
                pairing * pairing <= (bound + 1) ** (p + q - 2) * sa * sb,
                "mode-sum exponent",
            )
            edges += sum(count * rc.get(s + target, 0) for s, count in lc.items())
            graphs += 1
    tuples = list(product(range(3), repeat=2))
    selected = [v for v in tuples if sum(v) == 2]
    saturated_pairing = len(selected) ** 2
    require(saturated_pairing ** 2 == 3 * 3 * 3 * 3 == 81, "sharp graph witness")
    return {
        "tuple_fibers": fibers,
        "graphs": graphs,
        "edges": edges,
        "saturation_witness": {
            "left_length": 2, "right_length": 2, "index_bound": 2,
            "target": 0, "supported_sum": 2,
            "pairing_squared": 81, "degree_bound_rhs": 81,
        },
        "meaning": "finite regression tests; arbitrary lengths are proved in Lean",
    }


def cutoff_checks():
    lists = prefixes = viable_steps = 0
    choices = list(product(range(3), range(5)))
    for length in range(5):
        for xs in product(choices, repeat=length):
            budget = sum(c for c, _ in xs)
            displacement = 0
            for c, j in xs:
                displacement += c - j
                require(displacement <= budget, "prefix exceeded the fixed budget")
                prefixes += 1
            for initial in (Fraction(0), Fraction(1, 2), Fraction(5, 2), Fraction(5)):
                energy = initial
                for c, j in xs:
                    output = energy + c - j
                    if output < 0:
                        break
                    require(output <= initial + budget, "intermediate cutoff enlargement")
                    require(j <= initial + budget, "nonzero path index exceeds N+budget")
                    require(j <= energy + c, "one-step mode-index bound")
                    energy = output
                    viable_steps += 1
            lists += 1
    return {
        "lists": lists,
        "prefixes": prefixes,
        "nonnegative_energy_steps": viable_steps,
        "initial_energies": ["0", "1/2", "5/2", "5"],
        "meaning": "finite regression tests including nonintegral energies",
    }


def integer_binomial(top, n):
    numerator = 1
    for k in range(n):
        numerator *= top - k
    denominator = factorial(n)
    require(numerator % denominator == 0, "nonintegral generalized binomial")
    return numerator // denominator


def normal_words(ns, cutoff, method):
    words = defaultdict(int)
    length = len(ns)
    if method == "iterate":
        for sides in product((False, True), repeat=length):
            for js in product(range(cutoff + 1), repeat=length):
                modes = [(-1 - n - j if left else j)
                         for n, j, left in zip(ns, js, sides)]
                if 0 in modes or sum(modes) or sum(m for m in modes if m > 0) > cutoff:
                    continue
                coefficient = 1
                for n, j, left in zip(ns, js, sides):
                    coefficient *= comb(n + j, n) * (1 if left else (-1) ** n)
                word = tuple(sorted(modes))
                words[word] += coefficient
    else:
        require(method == "wick", "unknown expansion method")
        for modes in product(range(-cutoff, cutoff + 1), repeat=length):
            if 0 in modes or sum(modes) or sum(m for m in modes if m > 0) > cutoff:
                continue
            coefficient = 1
            for n, mode in zip(ns, modes):
                coefficient *= integer_binomial(-mode - 1, n)
            if coefficient:
                words[tuple(sorted(modes))] += coefficient
    return {word: coefficient for word, coefficient in words.items() if coefficient}


def fock_basis(cutoff):
    for occupations in product(*(range(cutoff // n + 1) for n in range(1, cutoff + 1))):
        if sum((n + 1) * k for n, k in enumerate(occupations)) <= cutoff:
            yield occupations


def act_word(word, occupations, cutoff):
    state = list(occupations)
    coefficient = 1
    for mode in reversed(word):
        n = abs(mode)
        if n > cutoff:
            return None, 0
        if mode > 0:
            if not state[n - 1]:
                return None, 0
            coefficient *= n * state[n - 1]
            state[n - 1] -= 1
        else:
            state[n - 1] += 1
        require(sum((i + 1) * k for i, k in enumerate(state)) <= cutoff,
                "normal-ordered zero-mode path left the exact Fock cutoff")
    return tuple(state), coefficient


def fock_checks():
    cutoff = 6
    basis = list(fock_basis(cutoff))
    monomials = matrix_columns = word_count = binomials = 0
    for n, j in product(range(11), repeat=2):
        require((-1) ** j * integer_binomial(-1 - n, j) == comb(n + j, n),
                "negative-product binomial sign")
        binomials += 1
    for length in range(1, 4):
        for ns in product(range(3), repeat=length):
            if length + sum(ns) > 5:
                continue
            iterate = normal_words(ns, cutoff, "iterate")
            wick = normal_words(ns, cutoff, "wick")
            require(iterate == wick, f"iterate/Wick mismatch for derivatives {ns}")
            word_count += len(iterate)
            for v in basis:
                image = defaultdict(int)
                for word, coefficient in iterate.items():
                    output, factor = act_word(word, v, cutoff)
                    if factor:
                        image[output] += coefficient * factor
                for output, coefficient in image.items():
                    if coefficient:
                        require(sum((i + 1) * k for i, k in enumerate(output)) ==
                                sum((i + 1) * k for i, k in enumerate(v)),
                                "zero mode did not preserve energy")
                matrix_columns += 1
            monomials += 1
    return {
        "model": "neutral Heisenberg Fock sector inside a rank-one positive even lattice VOA",
        "energy_cutoff": cutoff,
        "basis_vectors": len(basis),
        "derivative_monomials": monomials,
        "normal_words": word_count,
        "matrix_columns": matrix_columns,
        "binomial_identities": binomials,
        "meaning": "finite exact field-identity diagnostics, not a proof of universal VOA bounds",
    }


def jacobian_check():
    graph = read_json(HERE / "jacobian-mode-graph.json")
    payload = read_json(HERE / "jacobian-inertia-payload.json")
    response = read_json(HERE / "jacobian-inertia-output.json")
    tuples = list(product(range(3), repeat=2))
    incidence = [[int(sum(r) - sum(l) == 2) for r in tuples] for l in tuples]
    require(graph["tuples"] == [list(v) for v in tuples], "Jacobian tuple source mismatch")
    require(graph["incidence"] == incidence, "Jacobian constraint was mistranslated")
    n = len(tuples)
    r = max(map(sum, incidence))
    s = max(sum(row[j] for row in incidence) for j in range(n))
    matrix = [[r * s * (i == j) -
               sum(incidence[k][i] * incidence[k][j] for k in range(n))
               for j in range(n)] for i in range(n)]
    require(graph["schur_remainder"] == matrix, "Schur remainder construction mismatch")
    expected_payload = {
        "dimension": n,
        "entries": [
            {"row": i, "col": j, "value": {"num": str(matrix[i][j]), "den": "1"}}
            for i in range(n) for j in range(i, n) if matrix[i][j]
        ],
    }
    require(payload == expected_payload, "typed payload changed")
    require(response["request"]["payload"] == payload, "adapter ran a different payload")
    require(response["result"]["operation_id"] == "matrix.inertia.compute", "wrong operation")
    output = response["result"]["output"]
    dense = [[Fraction(int(x["num"]), int(x["den"])) for x in row]
             for row in output["matrix"]["entries"]]
    require(dense == matrix, "typed output retained a different matrix")
    require((output["n_positive"], output["n_negative"], output["n_zero"]) == (9, 0, 0),
            "unexpected inertia")
    require(output["definiteness"] == "positive_definite", "wrong definiteness")
    pivots = []
    reduced = [[Fraction(x) for x in row] for row in matrix]
    for k in range(n):
        pivot = reduced[k][k]
        require(pivot > 0, "independent exact LDL replay failed")
        pivots.append(str(pivot))
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                reduced[i][j] -= reduced[i][k] * reduced[k][j] / pivot
    return {
        "operation_id": "matrix.inertia.compute",
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_status": "COMPUTED",
        "structured_error": None,
        "payload_file": "jacobian-inertia-payload.json",
        "typed_output_file": "jacobian-inertia-output.json",
        "inertia": [9, 0, 0],
        "independently_replayed_ldl_pivots": pivots,
        "meaning": "one bounded diagnostic, not support for an infinite analytic claim",
    }


def certificate():
    return {
        "schema_version": 1,
        "campaign": "9000280",
        "mission": "energy-bootstrap",
        "result_class": "new_theorem",
        "result_scope": "independent analytic verification candidate with a universal formal path core",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "significance_status": "pending_independent_review",
        "novelty_status": "unverified",
        "independent_review": "required; not performed by this script or the Engineer",
        "formal_core": formal_core(),
        "exact_diagnostics": {
            "counting_and_schur": count_and_schur_checks(),
            "cutoffs": cutoff_checks(),
            "field_identities": fock_checks(),
            "jacobian": jacobian_check(),
        },
        "analytic_proof": {
            "file": "report.md",
            "machine_checked": False,
            "claims": ["C_SHARP_NORMAL", "C_POLYNOMIAL", "C_ZERO_TRANSFER",
                       "C_OPTIMAL", "C_LOCALITY", "C_GENERAL_COLUMN",
                       "C_C2_BOOTSTRAP", "C_C2_LOCALITY"],
            "stronger_vacuum_statement": "C2-cofiniteness suffices; rationality is not used",
        },
        "refutation": {
            "established_false_manuscript_assertions": [],
            "main_theorem_refuted": False,
        },
        "limitations": [
            "Finite diagnostics alone establish no universal operator estimate.",
            "The Lean compiler checks the finite core, not its VOA or analytic application.",
            "Primary-source citation attribution and theorem novelty await independent review.",
            "Annulus, fusion, unitarization, comparison and exhaustion claims remain unaudited.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    else:
        require(read_json(path) == result, "certificate differs from the exact replay")
    print(json.dumps({
        "exact_replay": "passed",
        "lean_core": "recorded success; source and reading unchanged",
        "graphs": result["exact_diagnostics"]["counting_and_schur"]["graphs"],
        "field_monomials": result["exact_diagnostics"]["field_identities"]["derivative_monomials"],
        "analytic_proof_checked_by_script": False,
        "independent_review": "pending",
    }, indent=2))


if __name__ == "__main__":
    main()
