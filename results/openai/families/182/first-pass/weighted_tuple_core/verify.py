#!/usr/bin/env python3
"""Replay the exact diagnostics and current, narrowly scoped Lean certificate."""

import argparse
from fractions import Fraction
from hashlib import sha256
from itertools import combinations, permutations, product
import json
from math import factorial, prod
from pathlib import Path
import sys


class VerificationError(Exception):
    pass


def require(condition, message):
    if not condition:
        raise VerificationError(message)


def load_json(path):
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def check_manifest(certificate):
    require(certificate["schema_version"] == 1, "Unsupported certificate schema")
    require(certificate["claim_id"] == "WTC_VERIFY", "Wrong mathematical claim")
    proof = certificate["proof"]
    require(proof["formal_claim"] == "WTC_FORMAL_CORE", "Wrong formal claim")
    require(proof["full_theorem_mechanically_verified"] is False,
            "The complete analytic theorem is not a Lean theorem")
    require(proof["arithmetic_inputs_are_hypotheses"] is True,
            "The local arithmetic inputs must remain explicit hypotheses")
    require(proof["main_power_saving_theorems_certified"] is False,
            "This certificate does not certify the main power-saving theorems")
    require(certificate["theorem"]["restriction_factor"] == "r^(-n)",
            "Incorrect marking restriction factor")
    diagnostics = certificate["diagnostics"]
    require(diagnostics["bridge"] == {
        "L": 3, "t": 1, "all_cuts": True,
        "label_patterns": ["constant", "repeated_mod_5"]},
        "The actual-construction diagnostic scope changed")
    require(diagnostics["marked_matrices"] == {
        "L": [3, 4, 5, 6, 7], "cut_symbols": [0, 1]},
        "The marked-matrix diagnostic scope changed")
    require(diagnostics["restriction"] == {
        "slot_counts": [0, 1, 2, 3], "sublist_counts": [1, 2, 3],
        "old_list_lengths": [1, 2]}, "The index restriction scope changed")
    require(diagnostics["sharpness_identity"] == {
        "cluster_slots": 6, "list_length": 3, "alphabet_size": 2},
        "The sharpness identity scope changed")


def check_sources(root, certificate):
    require(len(certificate["source_locators"]) == 3, "Missing source family")
    count = 0
    for locator in certificate["source_locators"]:
        text = (root / locator["path"]).read_text(encoding="utf-8")
        for label in locator["labels"]:
            require(text.count("\\label{" + label + "}") == 1,
                    f"Missing or ambiguous source locator: {label}")
            count += 1
    return count


def check_lean(root, directory, certificate):
    proof = certificate["proof"]
    source = (directory / proof["formal_source"]).read_text(encoding="utf-8")
    fidelity = (directory / proof["statement_fidelity"]).read_text(encoding="utf-8")
    report = (directory / proof["all_parameter_proof"]).read_text(encoding="utf-8")
    require("## Theorem 1" in report and "## Theorem 3" in report,
            "Missing all-parameter theorem or sharpness proof")
    state = load_json(root / "research/MATH_STATE.json")
    claims = [c for c in state["claims"] if c["claim_id"] == proof["formal_claim"]]
    require(bool(claims), "The formal claim is absent from the ledger")
    claim = max(claims, key=lambda c: c["version"])
    require(claim["formal_statement"] == source, "The claim's formal source is stale")
    evidence = [
        e for e in state["evidence"]
        if e["subject"]["subject_id"] == proof["formal_claim"]
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
        and e["produced_by"] == "lean_evidence/lean 4.31.0"
    ]
    require(len(evidence) == 1, "Missing or ambiguous current Lean 4.31.0 support")
    archive_path = root / evidence[0]["artifact"]
    archive = load_json(archive_path)
    require(archive["lean_source"]["text"] == source, "Archived source differs")
    require(archive["statement_fidelity"]["text"] == fidelity,
            "Archived statement fidelity differs")
    compiled = archive["lean_check"]
    require(compiled["status"] == "success" and compiled["exit_code"] == 0,
            "The actual compiler did not succeed")
    require(compiled["proof_holes"] == [] and compiled["audit_exit_code"] == 0,
            "The Lean proof has holes or lacks a successful axiom audit")
    require(compiled["environment_failure"] == "", "Unverified Lean environment")
    require("Lean (version 4.31.0," in compiled["tools"]["lean"]["version"],
            "Wrong Lean toolchain")
    require(compiled["source_sha256"] == sha256(source.encode()).hexdigest(),
            "Compiler/source binding is stale")
    require(compiled["statement_fidelity_sha256"] == sha256(fidelity.encode()).hexdigest(),
            "Compiler/fidelity binding is stale")
    require(load_json(directory / "lean_check.json") == compiled,
            "The current compiler record differs from its archived support")
    return {"claim": proof["formal_claim"], "exit_code": 0, "proof_holes": [],
            "certificate": str(archive_path.relative_to(root))}


def check_bridge():
    words = tuple(permutations(range(3)))
    shift = {word: word[1:] + word[:1] for word in words}
    graphs = {}

    def graph(marked):
        marked = frozenset(marked)
        if marked not in graphs:
            clean = tuple(b for b in range(3) if b not in marked)
            addresses = tuple(product(words, repeat=len(clean)))
            length = 3 ** len(marked)
            entries = {(address, i) for address in addresses for i in range(length)}
            edges = set()
            if len(marked) <= 1:
                for u, v in product(addresses, repeat=2):
                    if sum(v[b] == shift[u[b]] for b in range(len(clean))) >= 2:
                        edges.update(((u, i), (v, j))
                                     for i, j in product(range(length), repeat=2))
            require(all(x != y and (y, x) not in edges for x, y in edges),
                    "A formal graph has a loop or opposite edge")
            graphs[marked] = (clean, entries, edges)
        return graphs[marked]

    weight = tuple(Fraction(a, a + 1) for a in range(1, 6))
    require(weight[1] != weight[-1], "Orientation diagnostic is accidentally even")
    cases = terminal = product_checks = strict = 0
    for block in range(3):
        possible_marks = [frozenset()] + [
            frozenset([b]) for b in range(3) if b != block]
        for first, second in permutations(range(3), 2):
            plus_words = tuple(q for q in words if q.index(first) < q.index(second))
            require(len(plus_words) == 3, "Incorrect number of old plus words")
            for marked in possible_marks:
                clean, entries, edges = graph(marked)
                new_marked = marked | {block}
                new_clean, new_entries, new_edges = graph(new_marked)
                old_length = 3 ** len(marked)
                block_index = clean.index(block)
                old_plus = {e for e in entries if e[0][block_index] in plus_words}
                old_edges = {(x, y) for x, y in edges if x in old_plus and y in old_plus}

                def to_old(entry):
                    address, index = entry
                    word_index, residual_index = divmod(index, old_length)
                    by_block = dict(zip(new_clean, address))
                    by_block[block] = plus_words[word_index]
                    return tuple(by_block[b] for b in clean), residual_index

                image = {to_old(e) for e in new_entries}
                require(len(image) == len(new_entries) and image == old_plus,
                        "Concatenation is not a bijection of formal entries")
                mapped_edges = {(to_old(x), to_old(y)) for x, y in new_edges}
                require(len(mapped_edges) == len(new_edges),
                        "A new directed factor was duplicated")
                require(mapped_edges <= old_edges, "Directed factor inclusion failed")
                strict += len(mapped_edges) < len(old_edges)
                for constant in (True, False):
                    labels = {e: 0 if constant else (11 * i + i // 7) % 5
                              for i, e in enumerate(sorted(old_plus))}
                    old_product = prod(
                        (weight[(labels[y] - labels[x]) % 5] for x, y in old_edges),
                        start=Fraction(1))
                    new_product = prod(
                        (weight[(labels[y] - labels[x]) % 5] for x, y in mapped_edges),
                        start=Fraction(1))
                    require(old_product <= new_product,
                            "The pointwise weighted domination has the wrong direction")
                    product_checks += 1
                cases += 1
                terminal += len(new_marked) == 2
    require(strict > 0, "No diagnostic actually exercised removal of factors")
    return {"bridge_cases": cases, "terminal_bridge_cases": terminal,
            "directed_factor_product_checks": product_checks}


def check_marked_matrices():
    rows_checked = 0
    small_matrix = None
    for length in range(3, 8):
        delta = Fraction(1, 10 * length * length)
        kappa = Fraction(9, 10) * delta ** (length - 1)
        words = tuple(q for q in permutations(range(length)) if q.index(0) < q.index(1))
        rows = {}
        for word in words:
            gap = word.index(1) - word.index(0)
            row = {}
            for a, b in combinations(range(length), 2):
                swapped = list(word)
                swapped[a], swapped[b] = swapped[b], swapped[a]
                if swapped.index(0) > swapped.index(1):
                    reflected = tuple(1 if x == 0 else 0 if x == 1 else x
                                      for x in swapped)
                    require(reflected not in row, "Duplicated transposition factor")
                    row[reflected] = delta ** (b - a)
                    if reflected != word:
                        require(b - a > gap, "The claimed crossing gap inequality is false")
            require(row[word] == delta ** gap, "Wrong diagonal marked interaction")
            off = sum((v for y, v in row.items() if y != word), Fraction(0))
            require(off <= row[word] / 10 and row[word] - off >= kappa,
                    "Marked interaction is not uniformly diagonally dominant")
            rows[word] = row
            rows_checked += 1
        for x, row in rows.items():
            for y, value in row.items():
                require(rows[y].get(x, Fraction(0)) == value,
                        "The actual marked-cut matrix is not symmetric")
        if length == 3:
            small_matrix = [[rows[x].get(y, Fraction(0)) for y in words] for x in words]
    return rows_checked, small_matrix


def check_restriction():
    cases = 0
    for slots, sublists, old_length in product(range(4), range(1, 4), range(1, 3)):
        required_words = tuple(v % sublists for v in range(slots))
        new_indices = tuple(product(range(sublists), range(old_length)))

        def integrand(indices):
            return Fraction((1 + sum((v + 1) * (a * old_length + i + 1)
                                     for v, (a, i) in enumerate(indices))) ** 2, 7)

        total = restricted = Fraction(0)
        restricted_count = 0
        for indices in product(new_indices, repeat=slots):
            value = integrand(indices)
            total += value
            if all(pair[0] == required_words[v] for v, pair in enumerate(indices)):
                restricted += value
                restricted_count += 1
        old_sum = sum((integrand(tuple(zip(required_words, indices)))
                       for indices in product(range(old_length), repeat=slots)), Fraction(0))
        new_count = (sublists * old_length) ** slots
        probability = Fraction(1, sublists ** slots)
        require(restricted_count == old_length ** slots, "Wrong restriction cardinality")
        require(Fraction(restricted_count, new_count) == probability,
                "The index-event probability is not r^(-n)")
        require(restricted == old_sum, "Labels/indices changed under restriction")
        require(restricted / new_count == probability * old_sum / old_length ** slots,
                "Uniform-average normalization is incorrect")
        require(restricted <= total, "Restriction of a nonnegative integrand increased its sum")
        cases += 1
    return cases


def check_sharpness_identity():
    checked = 0
    for indices in product(range(3), repeat=6):
        require(len(set(indices[1:])) < 5, "Pigeonhole event was not certain")
        covariance = 0
        for labels in product((-1, 1), repeat=3):
            covariance += labels[indices[0]] * sum(labels[i] for i in indices[1:])
        require(Fraction(covariance, 8) == sum(i == indices[0] for i in indices[1:]),
                "The sharpness covariance identity is false")
        checked += 1
    return checked


def check_jacobian(directory, certificate, small_matrix):
    spec = certificate["jacobian"]
    contract = load_json(directory / spec["contract"])
    payload = load_json(directory / spec["payload"])
    result = load_json(directory / spec["result"])
    status = load_json(directory / spec["status"])
    operation = "matrix.symbolic.eigenvalues.compute"
    require(spec["operation_id"] == status["operation_id"] == operation,
            "Wrong Jacobian operation")
    require(status["adapter_exit_code"] == 0 and status["timed_out"] is False,
            "Jacobian failure/timeout is not mathematical evidence")
    require(contract["result"]["operation"]["operation_id"] == operation,
            "The inspected contract belongs to another operation")
    require(result["request"] == {"operation_id": operation, "payload": payload},
            "Jacobian did not execute the retained exact payload")
    for envelope in (contract, result):
        require(envelope["server"]["version"] == spec["server_version"],
                "The retained Jacobian server version changed")
        require(envelope["protocol_version"] == spec["protocol_version"],
                "The retained Jacobian protocol changed")
    require(result["result"]["operation_id"] == operation, "Wrong typed output")
    output = result["result"]["output"]
    expected_roots = ["-d**2 + d", "d**2 + d", "d**2"]
    require(spec["expected_eigenvalues"] == output["eigenvalues"] == expected_roots,
            "Unexpected or incomplete symbolic eigenvalues")
    require(spec["expected_multiplicities"] == output["multiplicities"] == [1, 1, 1],
            "Unexpected eigenvalue multiplicities")
    require(output["representation"] == "EXPLICIT_ROOTS", "Incomplete eigenvalue result")
    require(output["convention"] == "SYMPY_EIGENVALS", "Wrong spectral convention")

    def polynomial(entry):
        require(entry["variables"] == ["d"], "Wrong symbolic coordinate")
        require(entry["denominator"]["terms"] == [
            {"coefficient": {"num": "1", "den": "1"}, "exponents": [0]}],
            "Unexpected symbolic denominator")
        coefficients = [Fraction(0)] * 3
        for term in entry["numerator"]["terms"]:
            exponent, = term["exponents"]
            require(0 <= exponent <= 2, "Unexpected symbolic degree")
            coefficients[exponent] += Fraction(
                int(term["coefficient"]["num"]), int(term["coefficient"]["den"]))
        return tuple(coefficients)

    matrix = [[polynomial(e) for e in row] for row in payload["matrix"]["entries"]]
    zero, d, d2 = (0, 0, 0), (0, 1, 0), (0, 0, 1)
    require(matrix == [[d, zero, d2], [zero, d2, zero], [d2, zero, d]],
            "The symbolic payload is not the genuine L=3 cut matrix")
    roots = [(0, 1, -1), (0, 1, 1), (0, 0, 1)]
    vectors = [(1, 0, -1), (1, 0, 1), (0, 1, 0)]
    for eigenvalue, vector in zip(roots, vectors):
        for row in range(3):
            left = tuple(sum(matrix[row][col][k] * vector[col] for col in range(3))
                         for k in range(3))
            require(left == tuple(coefficient * vector[row] for coefficient in eigenvalue),
                    "Exact polynomial eigenvector replay failed")
    basis_det = vectors[0][0] * (
        vectors[1][1] * vectors[2][2] - vectors[1][2] * vectors[2][1]) - vectors[1][0] * (
        vectors[0][1] * vectors[2][2] - vectors[0][2] * vectors[2][1])
    require(basis_det != 0, "The three eigenvectors do not span")
    delta = Fraction(1, 90)
    evaluated = [[sum(c * delta ** k for k, c in enumerate(entry)) for entry in row]
                 for row in matrix]
    require(evaluated == small_matrix, "The symbolic matrix is disconnected from the construction")
    require(all(sum(c * delta ** k for k, c in enumerate(root)) > 0 for root in roots),
            "A genuine marked-cut eigenvalue is not positive")
    return {"operation_id": operation, "adapter_exit_code": 0,
            "server_version": result["server"]["version"], "exact_eigenvectors": 3}


def verify(root, certificate_path):
    certificate = load_json(certificate_path)
    check_manifest(certificate)
    directory = certificate_path.parent
    source_locators = check_sources(root, certificate)
    formal = check_lean(root, directory, certificate)
    diagnostics = check_bridge()
    rows, small_matrix = check_marked_matrices()
    diagnostics["marked_matrix_rows"] = rows
    diagnostics["restriction_cases"] = check_restriction()
    diagnostics["sharpness_index_assignments"] = check_sharpness_identity()
    require(diagnostics == certificate["diagnostics"]["expected"],
            f"Exact diagnostic results disagree with certificate: {diagnostics}")
    jacobian = check_jacobian(directory, certificate, small_matrix)
    return {
        "ok": True, "claim": certificate["claim_id"], "source_locators": source_locators,
        "diagnostics": diagnostics, "formal_core": formal, "jacobian": jacobian,
        "full_theorem_mechanically_verified": False,
        "all_parameter_argument": "report.md, Theorems 1 and 3",
        "independent_review": "not performed by this replay"
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument("--certificate", type=Path,
                        default=Path(__file__).resolve().with_name("exact_certificate.json"))
    args = parser.parse_args()
    try:
        result = verify(args.project_root.resolve(), args.certificate.resolve())
    except (VerificationError, OSError, ValueError, KeyError, TypeError) as error:
        print(json.dumps({"ok": False, "error": str(error)}))
        return 1
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
