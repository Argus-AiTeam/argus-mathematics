"""Replay finite coverage and check integer separation certificates without Z3."""

import argparse
import json
import subprocess
from pathlib import Path


def coefficient_matrix(labels, k):
    n = len(labels)
    if not 1 <= n <= 4 or any(len(row) != n for row in labels):
        raise ValueError("Invalid template dimensions")
    if any(type(mask) is not int or not 0 <= mask < 1 << k for row in labels for mask in row):
        raise ValueError("Invalid label mask")
    if any(labels[v][v] for v in range(n)):
        raise ValueError("Template has a loop")
    result = []
    for start in range(n):
        endpoints = set()

        def visit(u, visited, used):
            for v, label_set in enumerate(labels[u]):
                available = label_set & ~used
                while available:
                    bit = available & -available
                    available -= bit
                    if v == start:
                        raise ValueError("Representative has a rainbow directed cycle")
                    if v not in visited:
                        endpoints.add(v)
                        visit(v, visited | {v}, used | bit)

        visit(start, {start}, 0)
        result.append([labels[start][v].bit_count() - int(v in endpoints) for v in range(n)])
    return result


def coefficient_shape(matrix):
    if not matrix or not matrix[0]:
        raise ValueError("Need a nonempty integer coefficient matrix")
    columns = len(matrix[0])
    if any(
        len(row) != columns or any(type(a) is not int for a in row)
        for row in matrix
    ):
        raise ValueError("Coefficient rows must have equal length and integer entries")
    return len(matrix), columns


def check_dual(matrix, dual):
    rows, columns = coefficient_shape(matrix)
    if len(dual) != rows or any(type(y) is not int or y < 0 for y in dual) or not any(dual):
        raise ValueError("Dual must be a nonzero nonnegative integer vector")
    if any(sum(dual[u] * matrix[u][v] for u in range(rows)) > 0 for v in range(columns)):
        raise ValueError("A dual column sum is positive")


def key(matrix):
    return tuple(tuple(row) for row in matrix)


def replay(certificate, enumerator, replay_dir):
    if certificate["status"] != "EXACT_RESTRICTED_EXCLUSION":
        raise ValueError("This is not a complete exclusion certificate")
    domains = certificate["domains"]
    if len(domains) != 4 or {(d["n"], d["k"]) for d in domains} != {(n, 3) for n in range(1, 5)}:
        raise ValueError("The declared n<=4, k<=3 domain is incomplete")
    replay_dir.mkdir(parents=True, exist_ok=True)
    checked_domains = []
    for domain in domains:
        n, k = domain["n"], domain["k"]
        cases = domain["cases"]
        certified_counts = {}
        for case in cases:
            if case["status"] != "EXCLUDED_BY_EXACT_DUAL":
                raise ValueError("An unresolved coefficient system remains")
            matrix = case["A"]
            if matrix != coefficient_matrix(case["representative_matrix"], k):
                raise ValueError("Coefficient matrix disagrees with direct simple-path enumeration")
            check_dual(matrix, case["dual"])
            matrix_key = key(matrix)
            if matrix_key in certified_counts:
                raise ValueError("Duplicate coefficient system")
            count = case["template_count"]
            if type(count) is not int or count <= 0:
                raise ValueError("Invalid template multiplicity")
            certified_counts[matrix_key] = count
        replay_file = replay_dir / f"cases-n{n}-k{k}.json"
        completed = subprocess.run(
            [str(enumerator.resolve()), str(n), str(k), str(replay_file.resolve())],
            text=True, capture_output=True, check=True,
        )
        enumeration = json.loads(completed.stdout)
        generated = json.loads(replay_file.read_text())
        actual_counts = {key(case["A"]): case["template_count"] for case in generated["cases"]}
        if len(actual_counts) != len(generated["cases"]) or actual_counts != certified_counts:
            raise ValueError("The replayed finite coefficient domain is different")
        expected = (2 * (1 << k) - 1 + k) ** (n * (n - 1) // 2)
        if enumeration["status"] != "EXHAUSTED" or enumeration["visited"] != expected:
            raise ValueError("The finite template space was not exhausted")
        if enumeration["all_label_incidence_patterns"] != 2 ** (k * n * (n - 1)):
            raise ValueError("Incorrect original finite domain")
        if enumeration["visited"] != (
            enumeration["excluded_without_outgoing_multilabel"]
            + enumeration["excluded_rainbow_cycle"]
            + enumeration["cycle_free_tested"]
        ):
            raise ValueError("Finite accounting mismatch")
        if sum(certified_counts.values()) != enumeration["cycle_free_tested"]:
            raise ValueError("A retained template is not covered by the dual certificates")
        checked_domains.append({
            "n": n, "k": k, "visited": enumeration["visited"],
            "cycle_free_templates": enumeration["cycle_free_tested"],
            "coefficient_systems": len(certified_counts),
        })
        replay_file.unlink()
    return {
        "status": "EXACT_RESTRICTED_EXCLUSION_REPLAYED",
        "scope": "All positive integer independent-set blow-ups of all templates with 1<=n<=4 and 1<=k<=3",
        "method": "Complete finite template replay, separate simple-path coefficient calculation, and integer dual inequalities",
        "domains": checked_domains,
        "coefficient_systems": sum(d["coefficient_systems"] for d in checked_domains),
        "candidate_found": False,
        "campaign_complete": False,
        "reviewer_acceptance": False,
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", type=Path)
    parser.add_argument("--enumerator", type=Path, required=True)
    parser.add_argument("--replay-dir", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = replay(json.loads(args.certificate.read_text()), args.enumerator, args.replay_dir)
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, sort_keys=True))
