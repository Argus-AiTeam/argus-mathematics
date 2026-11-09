#!/usr/bin/env python3
"""Exact algebraic replay; the all-parameter analytic proof is in report.md."""

import argparse
from collections import Counter, defaultdict
from fractions import Fraction as Q
from hashlib import sha256
from itertools import combinations_with_replacement, permutations, product
import json
from math import comb, factorial
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def clean(vector):
    return {word: coefficient for word, coefficient in vector.items() if coefficient}


def add_scaled(target, source, scale=Q(1)):
    for word, coefficient in source.items():
        target[word] += scale * coefficient


def centered_label(a, d):
    return {a: Q(1)} if a < d else {i: Q(-1) for i in range(1, d)}


def create(vector, copy, a, d):
    out = defaultdict(Q)
    for word, coefficient in vector.items():
        require(not word or word[0][0] != copy, "creation source is not reduced")
        for i, value in centered_label(a, d).items():
            out[((copy, i, i),) + word] += coefficient * value
    return clean(out)


def matrix_product_first(a, u, v, d):
    """Multiply actual matrices (e_a-I/d)b, then change to centered basis."""
    entries = [[Q(0) for _ in range(d)] for _ in range(d)]
    if u == v:
        for i in range(1, d + 1):
            entries[i - 1][i - 1] = Q(i == u) - Q(1, d)
    else:
        entries[u - 1][v - 1] = Q(1)
    for i in range(1, d + 1):
        scale = Q(i == a) - Q(1, d)
        entries[i - 1] = [scale * x for x in entries[i - 1]]
    scalar = sum((entries[i][i] for i in range(d)), Q(0)) / d
    for i in range(d):
        entries[i][i] -= scalar
    coordinates = {}
    for i in range(1, d):
        value = entries[i - 1][i - 1] - entries[d - 1][d - 1]
        if value:
            coordinates[(i, i)] = value
    for i in range(1, d + 1):
        for j in range(1, d + 1):
            if i != j and entries[i - 1][j - 1]:
                coordinates[(i, j)] = entries[i - 1][j - 1]
    return scalar, coordinates


def cut_product_first(a, u, v, d):
    """Independent closed formulas for the annihilation and preservation legs."""
    if u != v:
        value = Q(a == u) - Q(1, d)
        return Q(0), {(u, v): value} if value else {}
    scalar = Q(a == u, d) - Q(1, d * d)
    coordinates = defaultdict(Q)
    for i, value in centered_label(a, d).items():
        coordinates[(i, i)] += (Q(a == u) - Q(1, d)) * value
    coordinates[(u, u)] -= Q(1, d)
    return scalar, clean(coordinates)


def direct_left(vector, copy, a, d):
    out = defaultdict(Q)
    for word, coefficient in vector.items():
        if not word or word[0][0] != copy:
            add_scaled(out, create({word: coefficient}, copy, a, d))
            continue
        _, u, v = word[0]
        scalar, leg = matrix_product_first(a, u, v, d)
        out[word[1:]] += coefficient * scalar
        for (i, j), value in leg.items():
            out[((copy, i, j),) + word[1:]] += coefficient * value
    return clean(out)


def direct_word(labels, word, d):
    vector = {word: Q(1)}
    for copy, a in enumerate(labels, 1):
        vector = direct_left(vector, copy, a, d)
    return vector


def one_cut(labels, word, d, p, preservation):
    r = len(labels)
    if len(word) < p or any(word[i][0] != i + 1 for i in range(p)):
        return {}
    coefficient = Q(1)
    for i in range(p):
        _, u, v = word[i]
        coefficient *= cut_product_first(labels[i], u, v, d)[0]
    if not coefficient:
        return {}
    tail = word[p:]
    if preservation:
        j = p + 1
        if not tail or tail[0][0] != j:
            return {}
        _, u, v = tail[0]
        leg = cut_product_first(labels[p], u, v, d)[1]
        vector = {
            ((j, i, k),) + tail[1:]: coefficient * value
            for (i, k), value in leg.items()
        }
        first_creation = j + 1
    else:
        forbidden = ({p} if p else set()) | ({p + 1} if p < r else set())
        if tail and tail[0][0] in forbidden:
            return {}
        vector = {tail: coefficient}
        first_creation = p + 1
    for copy in range(first_creation, r + 1):
        vector = create(vector, copy, labels[copy - 1], d)
    return clean(vector)


def test_words(r):
    words = {()}
    for p in range(r + 1):
        prefix = tuple((j, 1, 1) for j in range(1, p + 1))
        words.add(prefix)
        for j in range(1, r + 1):
            if prefix and prefix[-1][0] == j:
                continue
            words.add(prefix + ((j, 1, 2),))
        if r >= 2:
            j = 1 if not prefix or prefix[-1][0] != 1 else r
            k = r if j == 1 else 1
            words.add(prefix + tuple((j if i % 2 == 0 else k, 1, 1)
                                     for i in range(7)))
    return sorted(words)


def check_fock_actions():
    local_cases = 0
    for d in range(2, 5):
        for a, u, v in product(range(1, d + 1), repeat=3):
            if u == v == d:
                continue
            require(matrix_product_first(a, u, v, d) ==
                    cut_product_first(a, u, v, d),
                    f"component action mismatch: d={d}, a={a}, b={(u, v)}")
            local_cases += 1
    cases = 0
    longest = 0
    for d in (2, 3):
        for r in range(1, 5):
            if d == 3 and r == 4:
                label_tuples = sorted(set(permutations((1, 1, 2, 3)))) + [
                    (1, 1, 1, 1), (3, 3, 3, 3)]
            else:
                label_tuples = product(range(1, d + 1), repeat=r)
            for labels in label_tuples:
                for word in test_words(r):
                    longest = max(longest, len(word))
                    cuts = defaultdict(Q)
                    for p in range(r + 1):
                        add_scaled(cuts, one_cut(labels, word, d, p, False))
                    for p in range(r):
                        add_scaled(cuts, one_cut(labels, word, d, p, True))
                    require(clean(cuts) == direct_word(labels, word, d),
                            f"cut mismatch: d={d}, labels={labels}, word={word}")
                    cases += 1
    return {"component_matrix_actions": local_cases, "centered_word_actions": cases,
            "longest_input_word": longest, "output_truncation": False}


def order_count(multiset):
    denominator = 1
    for n in Counter(multiset).values():
        denominator *= factorial(n)
    return factorial(len(multiset)) // denominator


def check_tuple_fibers():
    cuts = 0
    cases = set()
    for r in range(1, 7):
        cases.update(combinations_with_replacement(range(1, 4), r))
        cases.add(tuple(range(1, r + 1)))
    for W in sorted(cases, key=lambda x: (len(x), x)):
        r = len(W)
        orders = set(permutations(W))
        for p in range(r + 1):
            q = r - p
            blocks = Counter((tuple(sorted(x[p:])), tuple(sorted(x[:p])))
                             for x in orders)
            for (A, B), count in blocks.items():
                require(count == order_count(A) * order_count(B),
                        "non-preservation block multiplicity")
                require(count <= factorial(p) * factorial(q),
                        "non-preservation norm coefficient")
            cuts += 1
        for p in range(r):
            q = r - p - 1
            blocks = Counter((tuple(sorted(x[p + 1:])), tuple(sorted(x[:p])), x[p])
                             for x in orders)
            row_label = {}
            col_label = {}
            row_columns = defaultdict(set)
            col_rows = defaultdict(set)
            for (A, B, a), count in blocks.items():
                require(count == order_count(A) * order_count(B),
                        "preservation replication weight")
                require(count <= factorial(p) * factorial(q),
                        "preservation norm coefficient")
                require(row_label.setdefault((A, a), B) == B, "row/label collision")
                require(col_label.setdefault((B, a), A) == A, "column/label collision")
                row_columns[A].add(B)
                col_rows[B].add(A)
            require(all(len(s) <= p + 1 for s in row_columns.values()), "row degree")
            require(all(len(s) <= q + 1 for s in col_rows.values()), "column degree")
            require(sum(blocks.values()) == len(orders), "lost word multiplicity")
            cuts += 1
    return {"multisets": len(cases), "cuts": cuts, "maximum_length": 6,
            "scope": "finite regression; universal cancellation is formalized separately"}


def poly_add(*polys):
    result = defaultdict(Q)
    for p in polys:
        for monomial, coefficient in p.items():
            result[monomial] += coefficient
    return clean(result)


def poly_scale(p, scalar):
    return clean({m: scalar * c for m, c in p.items()})


def poly_mul(a, b):
    result = defaultdict(Q)
    for (i, j), c in a.items():
        for (k, l), d in b.items():
            result[(i + k, j + l)] += c * d
    return clean(result)


def check_universal_polynomials():
    one = {(0, 0): Q(1)}
    x, y = {(1, 0): Q(1)}, {(0, 1): Q(1)}
    x2, y2, xy = poly_mul(x, x), poly_mul(y, y), poly_mul(x, y)
    tail_left = poly_add(
        poly_mul(poly_add(x, poly_scale(one, -1)),
                 poly_add(x, poly_scale(one, -4))),
        poly_scale(poly_mul(poly_add(x, poly_scale(one, -3)),
                            poly_add(x, poly_scale(one, -3))), -1))
    require(tail_left == poly_add(x, poly_scale(one, -5)), "middle-tail identity")
    cs_left = poly_add(poly_scale(x2, 3), poly_scale(y2, Q(3, 2)),
                       poly_scale(poly_mul(poly_add(x, y), poly_add(x, y)), -1))
    cs_right = poly_scale(poly_mul(poly_add(poly_scale(x, 2), poly_scale(y, -1)),
                                   poly_add(poly_scale(x, 2), poly_scale(y, -1))),
                          Q(1, 2))
    require(cs_left == cs_right, "weighted Cauchy square identity")
    product_left = poly_add(
        poly_add(one, poly_scale(x, -1)),
        poly_scale(poly_mul(poly_add(one, y),
                            poly_add(one, poly_scale(x, -1), poly_scale(y, -1))), -1))
    require(product_left == poly_add(xy, y2), "finite-product induction identity")
    return {"middle_tail": "m-5",
            "weighted_cauchy_defect": "(2u-v)^2/2",
            "product_induction_defect": "s*x+x^2",
            "method": "exact rational polynomial coefficients, not sampled evaluation"}


def H(r):
    return 1 + (r + 1) * (2 ** r - 2)


def old_threshold(r):
    return max(5 * r, r * factorial(r) * (H(r) + r + 1) ** 2)


def new_threshold(r):
    return max(8 * r, 4 * r * factorial(r) * (H(r) + r + 1) ** 2,
               13 * (r - 1) * (r - 2))


def check_counts_and_thresholds():
    count_cases = 0
    for r in range(1, 8):
        for d in range(1, 7):
            actual = sum(1 for W in combinations_with_replacement(range(d), r) if 0 in W)
            require(actual == comb(d + r - 2, r - 1), "remove-one-label bijection")
            if r >= 2:
                repeated = sum(1 for W in combinations_with_replacement(range(d), r)
                               if 0 in W and len(set(W)) < r)
                formula = sum(comb(d - 1, t - 1) * comb(r - 1, t - 1)
                              for t in range(1, min(r - 1, d) + 1))
                require(repeated == formula, "repeated-label support count")
            count_cases += 1
    examples = []
    for r in range(1, 13):
        require(H(r) == 1 + sum(comb(r, l) * (2 * l + 1) for l in range(1, r)),
                "scalar-remainder closed form")
        c = factorial(r) * (2 * r + 1 + H(r))
        d_old = max(old_threshold(r),
                    (c * c * 2 ** (r - 1) + 14) // 15 if r >= 2 else 1)
        distinct = comb(d_old - 1, r - 1)
        repeated = comb(d_old + r - 2, r - 1) - distinct
        old_sum = Q(49 * factorial(r - 1) * distinct + c * c * repeated,
                    d_old ** (r - 1))
        require(old_sum <= 64, "original through-label threshold")
        d_new = new_threshold(r)
        new_sum = Q(25 * factorial(r - 1) * comb(d_new + r - 2, r - 1),
                    d_new ** (r - 1))
        require(new_sum <= 26, "strengthened through-label threshold")
        if r <= 4:
            examples.append({"r": r, "original_simultaneous_component": d_old,
                             "strengthened_simultaneous_component": d_new,
                             "H_r": H(r)})
    return {"enumerated_count_cases": count_cases, "threshold_sanity_lengths": 12,
            "examples": examples,
            "scope": "finite sanity checks of explicit formulas; universal proof is in report.md"}


def decode_constant(entry):
    require(entry["variables"] == [], "Jacobian entry is not rational")
    def value(poly):
        return sum((Q(int(t["coefficient"]["num"]), int(t["coefficient"]["den"]))
                    for t in poly["terms"]), Q(0))
    return value(entry["numerator"]) / value(entry["denominator"])


def check_jacobian():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    output = json.loads((ROOT / "jacobian_output.json").read_text())
    adapter = json.loads((ROOT / "jacobian_adapter_status.json").read_text())
    rows = [(1, 1), (1, 2), (2, 1)]
    cols = [(1,), (2,)]
    matrix = [[int(tuple(sorted(A + B)) == (1, 1, 2)) for B in cols] for A in rows]
    gram = [[sum(row[i] * row[j] for row in matrix) for j in range(2)] for i in range(2)]
    decoded = [[decode_constant(e) for e in row] for row in payload["matrix"]["entries"]]
    require(decoded == gram == [[2, 0], [0, 1]], "Jacobian payload is not the tuple Gram")
    require(output["request"]["payload"] == payload, "Jacobian request/payload mismatch")
    require(adapter["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(adapter["structured_error"] is None and
            adapter["timeout_status"] == "completed_with_typed_output",
            "Jacobian did not complete with a typed result")
    operation = "matrix.symbolic.eigenvalues.compute"
    require(output["result"]["operation_id"] == operation, "wrong Jacobian operation")
    result = output["result"]["output"]
    require(result["representation"] == "EXPLICIT_ROOTS", "Jacobian did not return roots")
    roots = dict(zip(result["eigenvalues"], result["multiplicities"]))
    require(roots == {"1": 1, "2": 1}, "wrong exact Gram eigenvalues")
    return {"operation_id": operation, "server_version": output["server"]["version"],
            "protocol_version": output["protocol_version"], "adapter_exit_code": 0,
            "gram": gram, "eigenvalues_with_multiplicities": roots,
            "scope": "one exact finite matrix, not an all-parameter conclusion"}


def check_formal_record():
    result = json.loads((ROOT / "lean_verification.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "Lean compilation did not succeed")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "Lean source has proof holes or an unsuccessful axiom audit")
    version = result["tools"]["lean"]["version"]
    require(version.startswith("Lean (version 4.31.0,"), "wrong Lean version")
    source = (ROOT / "Main.lean").read_bytes()
    fidelity = (ROOT / "statement_fidelity.md").read_text().encode("utf-8")
    require(sha256(source).hexdigest() == result["source_sha256"],
            "Lean source changed since compilation")
    require(sha256(fidelity).hexdigest() == result["statement_fidelity_sha256"],
            "statement fidelity changed since compilation")
    recorded = result["kernel"]["recorded"]
    require(recorded["subject"]["subject_id"] == "C_MATCH289" and
            recorded["tier"] == "mechanical" and recorded["verdict"] == "supports",
            "compiler evidence is not attached to the formal core claim")
    project = ROOT.parent.parent
    archive_path = project / recorded["artifact"]
    require(archive_path.resolve().is_relative_to(ROOT),
            "formal archive is outside the assigned artifact directory")
    archive = json.loads(archive_path.read_text())
    for key in ("status", "exit_code", "proof_holes", "audit_exit_code",
                "source_sha256", "statement_fidelity_sha256"):
        require(archive["lean_check"][key] == result[key],
                f"compiler certificate differs on {key}")
    require(archive["lean_source"]["text"].encode("utf-8") == source and
            archive["statement_fidelity"]["text"].encode("utf-8") == fidelity,
            "formal archive is not the current source/fidelity pair")
    state = json.loads((project / "research/MATH_STATE.json").read_text())
    claim = max((c for c in state["claims"] if c["claim_id"] == "C_MATCH289"),
                key=lambda c: c["version"])
    require(claim["content_hash"] == recorded["subject"]["content_hash"] and
            claim["formal_statement"].encode("utf-8") == source,
            "compiler certificate is bound to an obsolete claim version")
    return {"claim": "C_MATCH289", "compiler_version": "4.31.0",
            "exit_code": 0, "proof_holes": [], "axiom_audit_exit_code": 0,
            "archive": recorded["artifact"],
            "source_and_fidelity_fresh": True,
            "scope": "universal combinatorial/scalar core; not the full analytic theorem",
            "replay_method": "validate the real compiler record and its required source/fidelity digests"}


def replay():
    return {"universal_polynomial_identities": check_universal_polynomials(),
            "genuine_free_product_regressions": check_fock_actions(),
            "tuple_fibers": check_tuple_fibers(),
            "counting_and_threshold_sanity": check_counts_and_thresholds(),
            "jacobian": check_jacobian(),
            "lean_formal_core": check_formal_record()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--actions-only", action="store_true")
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    if args.actions_only:
        require(not args.write_certificate, "actions-only is not a theorem certificate")
        print(json.dumps({"finite_adversarial_actions": check_fock_actions()}, indent=2))
        return
    checks = replay()
    path = ROOT / "exact_certificate.json"
    theorem = {
        "hypotheses": "arbitrary r>=1; scalar-free equal-trace projection partitions; faithful tracial representation; every r-label multiset",
        "H_r": "1+(r+1)(2^r-2)",
        "norm_threshold": "max(8r,4r*r!*(H_r+r+1)^2)",
        "norm_bound": "5*sqrt((r-1)!)*d^(-(r-1)/2), for all multisets",
        "through_label_additional_threshold": "13(r-1)(r-2), empty for r=1,2",
        "through_label_bound": 26,
        "scalar_tuple_norm_squared": "max_(A+B=W) n(A)*n(B), n(A)=|A|!/product_a(A_a!)",
        "preservation_projection_norm_squared": "max_(A+B+{a}=W) n(A)*n(B), before centering compression",
        "permutation_replication_factor": "sqrt(n(A)*n(B))",
        "tails": "identity on the unrestricted Hilbert tail after the stated copy-index source projection",
        "simultaneous_threshold": "maximum of the explicit length thresholds for 1<=r<=N",
        "analytic_proof": "report.md, Sections 1-4",
        "formal_scope": "statement_fidelity.md; combinatorial and scalar core only"
    }
    if args.write_certificate:
        certificate = {
            "schema_version": 1,
            "result_class": "new_theorem",
            "classification_status": "candidate strengthening; novelty and publishability are not certified",
            "result_description": "all_parameter_verification_and_structural_strengthening",
            "research_target_level": "publishable",
            "math_objective_mode": "exploratory",
            "claims": ["C_FW289", "C_TL289", "C_MULTI289", "C_MATCH289"],
            "theorem": theorem,
            "exact_checks": checks,
            "independent_review": "pending Host Reviewer replay",
            "novelty_status": "not_established",
            "campaign_status": "open; downstream amplification and universal stability are not certified",
            "limitations": [
                "Finite action and enumeration checks are regressions, not the proof of all parameters.",
                "The full analytic theorem requires review of report.md; it is not wholly formalized in Lean.",
                "Jacobian supports only its explicitly archived finite matrix postcondition."
            ]
        }
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        certificate = json.loads(path.read_text())
        require(certificate["exact_checks"] == checks, "certificate replay differs")
        require(certificate["theorem"] == theorem, "certificate theorem differs")
    print(json.dumps({"status": "exact_replay_passed", "checks": checks,
                      "all_parameter_proof": "report.md; human analytic review required",
                      "independent_review": "pending"}, indent=2))


if __name__ == "__main__":
    main()
