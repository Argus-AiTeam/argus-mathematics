#!/usr/bin/env python3
"""Replay restricted alignment results, not the full alignment lemma."""

import argparse
import hashlib
import json
from fractions import Fraction
from itertools import combinations, product
from math import comb
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OPERATION = "optimization.linear.rational_general_optimum.compute"
FORMAL_TARGETS = (
    ("A_THREE_UPPER", "."),
    ("A_PATTERNS", "finite-patterns"),
    ("A_MINIMAX", "minimax"),
    ("A_RATIONALIZATION", "rationalization"),
)


def check(condition, message):
    if not condition:
        raise AssertionError(message)


def subsets(points, maximum=None):
    points = tuple(sorted(points))
    stop = len(points) if maximum is None else min(maximum, len(points))
    return tuple(
        frozenset(items)
        for size in range(1, stop + 1)
        for items in combinations(points, size)
    )


def separated(lists):
    return all(
        not (lists[left] & lists[right])
        for left in lists
        for right in lists
        if max(left) < min(right)
    )


def labels_inside(lists, block):
    return set().union(*(lists[index] for index in subsets(block)))


def bad_labels(lists, block):
    bad = set()
    for label in labels_inside(lists, block):
        common = set(block)
        for index in subsets(block):
            if label in lists[index]:
                common.intersection_update(index)
        if not common:
            bad.add(label)
    return bad


def brute_aligned(lists, block):
    labels = sorted(labels_inside(lists, block))
    for values in product(sorted(block), repeat=len(labels)):
        assignment = dict(zip(labels, values))
        if all(
            assignment[label] in index
            for index in subsets(block)
            for label in lists[index]
        ):
            return True
    return False


def triple_witnesses(lists, lo, mid, hi):
    left = subsets({lo, mid})
    right = subsets({mid, hi})
    return {
        label
        for label in lists[frozenset({lo, hi})]
        if any(label in lists[index] for index in left)
        and any(label in lists[index] for index in right)
    }


def partial_partitions(length):
    def extend(prefix, largest):
        if len(prefix) == length + 1:
            yield prefix[1:]
            return
        for value in range(largest + 2):
            yield from extend(prefix + (value,), max(largest, value))

    yield from extend((0,), 0)


def exhaustive_three_patterns():
    indices = subsets(range(3))
    total = allowed = bad = 0
    for pattern in partial_partitions(len(indices)):
        total += 1
        lists = {
            index: frozenset() if label == 0 else frozenset({label})
            for index, label in zip(indices, pattern)
        }
        if not separated(lists):
            continue
        allowed += 1
        bad_here = bad_labels(lists, frozenset(range(3)))
        check(
            bool(bad_here) == (not brute_aligned(lists, frozenset(range(3)))),
            "The intersection criterion disagrees with a direct map search.",
        )
        check(
            bad_here == triple_witnesses(lists, 0, 1, 2),
            "The three-point witness characterization failed.",
        )
        bad += bool(bad_here)
    check(total == 4140, "Not all partial partitions of seven slots were enumerated.")
    return {"r": 3, "s": 3, "d": 1, "patterns": total, "allowed": allowed, "bad": bad}


def lower_families(r):
    pairs = tuple((lo, hi) for lo in range(r) for hi in range(lo + 2, r))
    families = []
    for middles in product(*(range(lo + 1, hi) for lo, hi in pairs)):
        lists = {index: frozenset() for index in subsets(range(r), 3)}
        for mid in range(r):
            lists[frozenset({mid})] = frozenset({mid})
        for (lo, hi), mid in zip(pairs, middles):
            lists[frozenset({lo, hi})] = frozenset({mid})
        families.append(lists)
    return families


def payoff_data():
    triples = tuple(combinations(range(5), 3))
    families = lower_families(5)
    check(len(families) == 12, "Unexpected number of exact lower-bound families.")
    rows = []
    for lists in families:
        check(separated(lists), "A dual family violates separated disjointness.")
        row = []
        for lo, mid, hi in triples:
            block = frozenset({lo, mid, hi})
            failures = bad_labels(lists, block)
            expected = mid in lists[frozenset({lo, hi})]
            check(bool(failures) == expected, "A dual bad-set indicator is wrong.")
            check(
                failures == triple_witnesses(lists, lo, mid, hi),
                "A dual family violates the witness characterization.",
            )
            row.append(int(expected))
        rows.append(row)
    return triples, rows


def canonical(value):
    value = Fraction(value)
    return {"num": str(value.numerator), "den": str(value.denominator)}


def lp_payload():
    triples, rows = payoff_data()
    columns = [
        i for i, block in enumerate(triples) if block[0] == 0 and block[2] == 4
    ]
    triples = tuple(triples[i] for i in columns)
    rows = sorted({tuple(row[i] for i in columns) for row in rows})
    check(len(triples) == len(rows) == 3, "Incorrect pinned-endpoint LP projection.")
    zero, one = canonical(0), canonical(1)
    variables = [
        {"name": "mu_" + "_".join(map(str, block)), "lower_bound": zero, "upper_bound": None}
        for block in triples
    ] + [{"name": "badness_bound", "lower_bound": zero, "upper_bound": None}]
    constraints = [
        {
            "label": "probability_normalization",
            "coefficients": [one] * len(triples) + [zero],
            "relation": "EQ",
            "rhs": one,
        }
    ]
    constraints += [
        {
            "label": f"separated_family_{number}",
            "coefficients": [canonical(value) for value in row] + [canonical(-1)],
            "relation": "LE",
            "rhs": zero,
        }
        for number, row in enumerate(rows)
    ]
    return {
        "program": {
            "variables": variables,
            "objective": {
                "sense": "MINIMIZE",
                "coefficients": [zero] * len(triples) + [one],
            },
            "constraints": constraints,
        }
    }


def dot(left, right):
    return sum((a * b for a, b in zip(left, right)), Fraction())


def verify_exact_game():
    triples, rows = payoff_data()
    primal = [
        Fraction(1, 3) if block[0] == 0 and block[2] == 4 else Fraction()
        for block in triples
    ]
    dual = [Fraction(1, len(rows))] * len(rows)
    check(sum(primal) == 1 and sum(dual) == 1, "Game laws are not normalized.")
    primal_value = max(dot(row, primal) for row in rows)
    dual_value = min(
        sum((dual[i] * rows[i][j] for i in range(len(rows))), Fraction())
        for j in range(len(triples))
    )
    check(primal_value == dual_value == Fraction(1, 3), "The exact game value is wrong.")
    return {
        "r": 5,
        "s": 3,
        "d": 1,
        "triples": [list(block) for block in triples],
        "families": len(rows),
        "value": "1/3",
        "primal": [str(value) for value in primal],
        "dual": [str(value) for value in dual],
    }


def replay_jacobian():
    payload = json.loads((ROOT / "jacobian-lp-payload.json").read_text())
    check(payload == lp_payload(), "The submitted LP is not the alignment payoff matrix.")
    contract = json.loads((ROOT / "jacobian-lp-contract.json").read_text())
    output = json.loads((ROOT / "jacobian-lp-output.json").read_text())
    rejected = json.loads((ROOT / "jacobian-lp-rejected-output.json").read_text())
    rejected_payload = json.loads((ROOT / "jacobian-lp-rejected-payload.json").read_text())
    basis_rejected = json.loads((ROOT / "jacobian-lp-basis-rejected-output.json").read_text())
    check(rejected["ok"] is False, "The preserved rejected request is not an error.")
    check(
        rejected["error"]["data"]["code"] == "INVALID_REQUEST",
        "Unexpected preserved admission error.",
    )
    check(
        all(variable["upper_bound"] == canonical(1)
            for variable in rejected_payload["program"]["variables"]),
        "The rejected payload no longer carries its redundant upper bounds.",
    )
    check(
        basis_rejected["ok"] is False
        and "simplex bases" in basis_rejected["error"]["data"]["errors"][0]["message"],
        "The second bounded operation's admission failure was not preserved.",
    )
    check(
        contract["result"]["operation"]["operation_id"] == OPERATION,
        "Wrong inspected operation.",
    )
    check(output["ok"] is False, "The preserved final adapter outcome is not its recorded error.")
    error = output["error"]
    check(error["data"]["operation_id"] == OPERATION, "Wrong attempted operation.")
    check(error["data"]["code"] == "INVALID_REQUEST", "Unexpected final adapter error.")
    return {
        "operation_id": OPERATION,
        "server_version_at_inspection": contract["server"]["version"],
        "protocol_version_at_inspection": contract["protocol_version"],
        "execution_server_version": None,
        "status": "INVALID_REQUEST",
        "adapter_exit_code": 2,
        "adapter_error": error,
        "timed_out": False,
        "mathematical_conclusion": None,
        "scope": "All adapter requests were rejected before solving. The full-game primal and dual laws are checked independently using Fraction arithmetic.",
        "rejected_admission": {
            "payload": "jacobian-lp-rejected-payload.json",
            "output": "jacobian-lp-rejected-output.json",
            "adapter_exit_code": 2,
            "error": rejected["error"],
            "mathematical_conclusion": None,
            "correction": "Omit redundant upper bounds, reducing normalized LP variables below 32.",
        },
        "rejected_basis_admission": {
            "payload": "jacobian-lp-basis-rejected-payload.json",
            "output": "jacobian-lp-basis-rejected-output.json",
            "adapter_exit_code": 2,
            "error": basis_rejected["error"],
            "mathematical_conclusion": None,
            "reformulation": "Restrict the primal to its pinned-endpoint law and remove duplicate rows; preserve the full-game lower certificate independently.",
        },
    }


def multiply(left, right):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return result


def shift(coefficients, offset):
    return [
        sum(coefficients[i] * comb(i, j) * offset ** (i - j)
            for i in range(j, len(coefficients)))
        for j in range(len(coefficients))
    ]


def all_r_cut_identity():
    even_product = multiply([-1, 2], [-3, 2])
    odd_product = multiply([1, 2], [-1, 2])
    even_difference = [
        12 * coefficient - 3 * correction
        for coefficient, correction in zip([0, -1, 1], even_product)
    ]
    odd_difference = [
        12 * coefficient - 3 * correction
        for coefficient, correction in zip([0, 1, 1], odd_product)
    ]
    check(even_difference == [-9, 12, 0], "Even all-r polynomial identity failed.")
    check(odd_difference == [3, 12, 0], "Odd all-r polynomial identity failed.")
    even_num = shift(even_difference, 2)
    odd_num = shift(odd_difference, 2)
    even_den = shift([8 * value for value in even_product], 2)
    odd_den = shift([8 * value for value in odd_product], 2)
    for polynomial in (even_num, odd_num, even_den, odd_den):
        check(polynomial[0] > 0 and all(c >= 0 for c in polynomial),
              "The m=n+2 positivity certificate is invalid.")
    return {
        "parameter": "m=n+2, n>=0",
        "even_failure_minus_3_over_8": {"numerator": even_num, "denominator": even_den},
        "odd_failure_minus_3_over_8": {"numerator": odd_num, "denominator": odd_den},
        "coefficient_order": "ascending",
    }


def verify_cut_families():
    cases = []
    for r in range(4, 13):
        cut = r // 2
        lists = {
            index: frozenset({0})
            if len(index) == 2 and min(index) < cut <= max(index)
            else frozenset()
            for index in subsets(range(r), 4)
        }
        check(separated(lists), "A cut family violates separation.")
        check(all(len(values) <= 1 for values in lists.values()), "A cut list exceeds d=1.")
        bad = 0
        for block in combinations(range(r), 4):
            predicted = sum(value < cut for value in block) == 2
            actual = bool(bad_labels(lists, frozenset(block)))
            check(actual == predicted, "Cut-family badness is not exactly a 2+2 split.")
            bad += actual
        expected = comb(cut, 2) * comb(r - cut, 2)
        check(bad == expected, "Incorrect cut-family bad count.")
        mass = Fraction(bad, comb(r, 4))
        check(mass >= Fraction(3, 8), "Uniform-law failure is below the certified bound.")
        cases.append({"r": r, "bad": bad, "total": comb(r, 4), "failure": str(mass)})
    return {"cases": cases, "all_r_sign_certificate": all_r_cut_identity()}


def verify_native_certificates():
    certificates = []
    for claim, directory in FORMAL_TARGETS:
        folder = ROOT / directory
        native = json.loads((folder / "lean-verification.json").read_text())
        source = folder / "Main.lean"
        fidelity = folder / "statement_fidelity.md"
        check(Path(native["source"]).resolve() == source.resolve(), "Wrong compiled source.")
        check(native["status"] == "success" and native["exit_code"] == 0,
              "A native compiler run did not succeed.")
        check(native["audit_exit_code"] == 0 and native["proof_holes"] == [],
              "A native proof-hole audit did not succeed.")
        check(native["environment_failure"] == "", "A native run has an environment failure.")
        version = native["tools"]["lean"]["version"]
        check(version.startswith("Lean (version 4.31.0,"), "Wrong Lean compiler version.")
        check(hashlib.sha256(source.read_bytes()).hexdigest() == native["source_sha256"],
              "The current Lean source differs from the compiled source.")
        check(
            hashlib.sha256(fidelity.read_text().encode()).hexdigest()
            == native["statement_fidelity_sha256"],
            "The current fidelity reading differs from the compiled reading.",
        )
        recorded = native["kernel"]["recorded"]
        check(recorded["subject"]["subject_id"] == claim, "Wrong compiler target claim.")
        check(recorded["tier"] == "mechanical" and recorded["verdict"] == "supports",
              "The native run was not recorded as mechanical support.")
        archive_path = ROOT.parent.parent / recorded["artifact"]
        check(archive_path.resolve().is_relative_to(ROOT),
              "The recorded native certificate is outside this owned evidence directory.")
        archived = json.loads(archive_path.read_text())
        check(archived["subject"] == recorded["subject"], "The archived subject is different.")
        check(archived["lean_source"]["text"] == source.read_text(),
              "The archived theorem is not the current theorem.")
        check(archived["statement_fidelity"]["text"] == fidelity.read_text(),
              "The archived fidelity document is not the current reading.")
        for field in ("exit_code", "proof_holes", "source_sha256", "statement_fidelity_sha256"):
            check(archived["lean_check"][field] == native[field],
                  f"The archived compiler field {field} differs.")
        certificates.append({
            "claim": claim,
            "source": str(source.relative_to(ROOT)),
            "certificate": recorded["artifact"],
            "compiler": "Lean 4.31.0",
            "exit_code": 0,
            "proof_holes": [],
            "independent_statement_fidelity_review": "pending",
        })
    return certificates


def certificate():
    return {
        "result_class": "partial_result",
        "full_alignment_certified": False,
        "manuscript_assertion_refuted": None,
        "independent_review": "pending_host_reviewer",
        "novelty_status": "not_claimed",
        "significance_status": "unassessed",
        "certified_scope": {
            "formal_upper_claim": "A_THREE_UPPER",
            "formal_source": "Main.lean",
            "finite_pattern_claim": "A_PATTERNS",
            "finite_pattern_source": "finite-patterns/Main.lean",
            "finite_minimax_claim": "A_MINIMAX",
            "finite_minimax_source": "minimax/Main.lean",
            "rationalization_claim": "A_RATIONALIZATION",
            "rationalization_source": "rationalization/Main.lean",
            "three_layer_minimax": "min(1,d/(r-2)), r>=3",
            "uniform_four_layer_exclusion": "failure>=3/8 for every r>=4 at d=1",
        },
        "exhaustive_patterns": exhaustive_three_patterns(),
        "native_certificates": verify_native_certificates(),
        "finite_minimax_certificate": verify_exact_game(),
        "jacobian": replay_jacobian(),
        "uniform_four_layer_certificate": verify_cut_families(),
        "unresolved": [
            "Full all-parameter Lean proof of A_ALIGNMENT, in particular s>=4.",
            "Formal minimax-to-invariant-law extraction and countable extension.",
            "Independent Reviewer replay and statement-fidelity judgement.",
            "Primary-source attribution for the still-assumed Ramsey and extension inputs.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prepare-lp", action="store_true")
    parser.add_argument("--write-certificate", action="store_true")
    arguments = parser.parse_args()
    if arguments.prepare_lp:
        check(not arguments.write_certificate, "Preparation and replay are separate operations.")
        path = ROOT / "jacobian-lp-payload.json"
        path.write_text(json.dumps(lp_payload(), indent=2) + "\n")
        print(json.dumps({"prepared": str(path), "operation_id": OPERATION}))
        return
    actual = certificate()
    path = ROOT / "exact_certificate.json"
    if arguments.write_certificate:
        path.write_text(json.dumps(actual, indent=2) + "\n")
    else:
        check(json.loads(path.read_text()) == actual, "The saved exact certificate is stale.")
    print(json.dumps({
        "status": "restricted_results_replayed",
        "full_alignment_certified": False,
        "patterns": actual["exhaustive_patterns"],
        "finite_game_value": "1/3",
        "jacobian_status": actual["jacobian"]["status"],
        "uniform_four_layer_lower_bound": "3/8",
        "formal_claims": [item["claim"] for item in actual["native_certificates"]],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
