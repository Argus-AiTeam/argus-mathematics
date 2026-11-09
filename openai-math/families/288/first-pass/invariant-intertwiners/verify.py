#!/usr/bin/env python3
"""Replay exact diagnostics and check the current, genuinely compiled Lean core."""

import argparse
import hashlib
import itertools
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = ROOT / (
    "research/openai_manuscript/"
    "Kadisons-similarity-theorem-through-uniform-derivation-estimates-"
    "September-23-2026/build/sections/tensors.tex"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def matrix_unit(m, i, j):
    return tuple(tuple(Fraction(a == i and b == j) for b in range(m))
                 for a in range(m))


def multiply(a, b):
    return tuple(tuple(sum((a[i][k] * b[k][j] for k in range(len(b))),
                           Fraction(0))
                       for j in range(len(b[0])))
                 for i in range(len(a)))


def transpose(a):
    return tuple(zip(*a))


def normalized_trace(a):
    return sum((a[i][i] for i in range(len(a))), Fraction(0)) / len(a)


def centered(a):
    t = normalized_trace(a)
    return tuple(tuple(value - (t if i == j else 0)
                       for j, value in enumerate(row))
                 for i, row in enumerate(a))


def include(a, q):
    m = len(a)
    return tuple(tuple(a[i // q][j // q] if i % q == j % q else Fraction(0)
                       for j in range(m * q))
                 for i in range(m * q))


def check_matrix_units():
    products = centers = 0
    for m in range(1, 6):
        zero = tuple((Fraction(0),) * m for _ in range(m))
        units = {(i, j): matrix_unit(m, i, j)
                 for i in range(m) for j in range(m)}
        for i, j, k, l in itertools.product(range(m), repeat=4):
            expected = units[i, l] if j == k else zero
            require(multiply(units[i, j], units[k, l]) == expected,
                    f"matrix-unit product failed: {m,i,j,k,l}")
            products += 1
        for (i, j), a in units.items():
            aa = multiply(transpose(a), a)
            require(aa == units[j, j] and multiply(aa, aa) == aa,
                    "absolute-value square must be a positive rank-one projection")
            require(normalized_trace(aa) == Fraction(1, m),
                    "matrix-unit L2 norm squared or L1 norm is misnormalized")
            c = centered(a)
            norm_squared = normalized_trace(multiply(transpose(c), c))
            expected = Fraction(1, m) - (Fraction(1, m * m) if i == j else 0)
            require(normalized_trace(c) == 0 and norm_squared == expected,
                    "centering or its exact L2 norm failed")
            require(norm_squared <= Fraction(1, m), "centering increased L2 norm")
            centers += 1
    return {"matrix_sizes": [1, 2, 3, 4, 5],
            "matrix_unit_products": products, "centered_units": centers}


def cycles(permutation):
    unseen = set(range(len(permutation)))
    result = []
    while unseen:
        start = min(unseen)
        word = []
        i = start
        while i in unseen:
            unseen.remove(i)
            word.append(i)
            i = permutation[i]
        require(i == start, "invalid permutation cycle")
        result.append(tuple(word))
    return tuple(result)


def unit_word_trace(units, word, m):
    row, col = units[word[0]]
    for slot in word[1:]:
        next_row, next_col = units[slot]
        if col != next_row:
            return Fraction(0)
        col = next_col
    return Fraction(1, m) if col == row else Fraction(0)


def unit_cycle_form(cycle_words, units, m):
    value = Fraction(1)
    for word in cycle_words:
        value *= unit_word_trace(units, word, m)
        if value == 0:
            break
    return value


def check_coefficient_isolation():
    comparisons = boundary_probes = 0
    for p in range(1, 7):
        permutations = list(itertools.permutations(range(p)))
        decompositions = {q: cycles(q) for q in permutations}
        for pi in permutations:
            units = tuple(enumerate(pi))
            for rho in permutations:
                expected = Fraction(1, (p + 1) ** len(decompositions[pi])) \
                    if rho == pi else Fraction(0)
                require(unit_cycle_form(decompositions[rho], units, p + 1) == expected,
                        f"unrestricted coefficient isolation failed: {pi,rho}")
                comparisons += 1
            require(unit_cycle_form(decompositions[pi], units, p) ==
                    Fraction(1, p ** len(decompositions[pi])),
                    "independence boundary m=p failed")
            boundary_probes += 1
    return {"slot_counts": [1, 2, 3, 4, 5, 6],
            "all_probe_form_comparisons": comparisons,
            "additional_m_equals_p_probes": boundary_probes,
            "formula": "Phi_rho(e_i,pi(i)) = delta_rho,pi / m^c(pi)"}


def check_cycle_threshold():
    inspected = 0
    survivors = {}
    for p in range(1, 9):
        count = 0
        for pi in itertools.permutations(range(p)):
            inspected += 1
            words = cycles(pi)
            if any(len(word) == 1 and word[0] != 0 for word in words):
                continue
            if 2 * len(words) < p + 1:
                continue
            require((0,) in words and
                    all(len(word) == 2 for word in words if word != (0,)),
                    "cycle threshold did not force a singleton endpoint and pairs")
            count += 1
        survivors[str(p - 1)] = count
    return {"permutations_inspected": inspected,
            "tail_counts": list(range(8)),
            "survivors_by_tail_count": survivors}


def check_inclusions():
    examples = 0
    for m in range(1, 5):
        a = tuple(tuple(Fraction(2 * i - j + 1, j + 1) for j in range(m))
                  for i in range(m))
        b = tuple(tuple(Fraction(i + 3 * j - 1, i + 1) for j in range(m))
                  for i in range(m))
        for q in range(1, 4):
            ai, bi = include(a, q), include(b, q)
            require(multiply(ai, bi) == include(multiply(a, b), q),
                    "unital inclusion did not preserve multiplication")
            require(normalized_trace(ai) == normalized_trace(a) and
                    normalized_trace(multiply(ai, bi)) ==
                    normalized_trace(multiply(a, b)),
                    "normalized traces were not preserved")
            require(centered(ai) == include(centered(a), q),
                    "centering did not commute with the inclusion")
            examples += 1
    return {"base_sizes": [1, 2, 3, 4], "multiplicities": [1, 2, 3],
            "exact_inclusion_examples": examples}


def matchings(slots):
    if not slots:
        yield ()
        return
    i = slots[0]
    for pos in range(1, len(slots)):
        j = slots[pos]
        for rest in matchings(slots[1:pos] + slots[pos + 1:]):
            yield ((i, j),) + rest


def matching_value(pairing, labels):
    return int(all(labels[i] == labels[j] for i, j in pairing))


def side_sums(pairing, k, M, source):
    same = ([b for b, (i, j) in enumerate(pairing) if i < k and j < k]
            if source else
            [b for b, (i, j) in enumerate(pairing) if i >= k and j >= k])
    block_of = {slot: block for block, pair in enumerate(pairing) for slot in pair}
    slots = range(k) if source else range(k, 2 * len(pairing))
    tensors = []
    for assignment in itertools.product(range(M), repeat=len(same)):
        choices = dict(zip(same, assignment))
        tensors.append(tuple((block_of[i], choices.get(block_of[i], 0)) for i in slots))
    require(len(tensors) == M ** len(same), "assignment cardinality failed")
    require(len(set(tensors)) == len(tensors),
            "same-side tensor summands were not orthonormal")
    return tensors, len(same)


def check_pairing_support():
    support_checks = norm_checks = expansion_terms = 0
    for n in range(0, 9, 2):
        all_pairings = list(matchings(tuple(range(n))))
        for pairing in all_pairings:
            labels = [None] * n
            for b, (i, j) in enumerate(pairing):
                labels[i] = labels[j] = (b, b % 3)
            for other in all_pairings:
                require(matching_value(other, labels) == int(other == pairing),
                        "another matching survived disjoint-pool isolation")
                support_checks += 1
            for k in range(n + 1):
                for M in (1, 2, 3):
                    source, s = side_sums(pairing, k, M, True)
                    test, t = side_sums(pairing, k, M, False)
                    coefficient = sum(matching_value(pairing, x + z)
                                      for x in source for z in test)
                    expansion_terms += len(source) * len(test)
                    require(coefficient == M ** (s + t),
                            "isolated summed coefficient is not M^(s+t)")
                    norm_squared_product = len(source) * len(test)
                    require(norm_squared_product == M ** (s + t),
                            "product of squared tensor norms is not M^(s+t)")
                    require(Fraction(coefficient ** 2, norm_squared_product) ==
                            M ** (s + t), "exact squared norm ratio failed")
                    if s + t == 0:
                        require(k == n - k, "cross matching has unequal degrees")
                    norm_checks += 1
    return {"tail_counts": [0, 2, 4, 6, 8], "pool_sizes": [1, 2, 3],
            "matching_support_comparisons": support_checks,
            "summed_coefficient_and_norm_checks": norm_checks,
            "expanded_source_test_terms": expansion_terms,
            "squared_norm_ratio": "M^(r_s+r_t)",
            "unbounded_inference": "Main.lean: same_side_coefficient_zero"}


def gadd(a, b):
    return (a[0] + b[0], a[1] + b[1])


def gmul(a, b):
    return (a[0] * b[0] - a[1] * b[1], a[0] * b[1] + a[1] * b[0])


def gconj(a):
    return (a[0], -a[1])


def gsum(values):
    result = (0, 0)
    for value in values:
        result = gadd(result, value)
    return result


def gproduct(values):
    result = (1, 0)
    for value in values:
        result = gmul(result, value)
    return result


def tensor(letters):
    return {indices: gproduct(letter[i] for letter, i in zip(letters, indices))
            for indices in itertools.product(*(range(len(x)) for x in letters))}


def inverse(sigma):
    return tuple(sigma.index(i) for i in range(len(sigma)))


def permute(vector, sigma):
    inv = inverse(sigma)
    return {tuple(indices[inv[j]] for j in range(len(sigma))): value
            for indices, value in vector.items()}


def inner(a, b):
    return gsum(gmul(value, gconj(b[index])) for index, value in a.items())


def vector_inner(a, b):
    return gsum(gmul(x, gconj(y)) for x, y in zip(a, b))


def matrix_vector(a, v):
    return [gsum(gmul(c, x) for c, x in zip(row, v)) for row in a]


def adjoint(a):
    return tuple(tuple(gconj(a[j][i]) for j in range(len(a)))
                 for i in range(len(a[0])))


def apply_word_operator(vector, terms):
    result = {index: (0, 0) for index in vector}
    for sigma, a in terms:
        inv = inverse(sigma)
        for index, value in vector.items():
            endpoint, tails, j = index[0], index[1:-1], index[-1]
            output_tails = tuple(tails[inv[i]] for i in range(len(sigma)))
            for out in range(2):
                target = (endpoint,) + output_tails + (out,)
                result[target] = gadd(result[target], gmul(a[out][j], value))
    return result


def check_complex_permutations_and_words():
    coefficient_checks = repeated_checks = full_output_checks = 0
    x = [(1, 1), (2, -1), (-1, 2)]
    d, alpha = [(1, 1), (2, 0)], [(1, -1), (0, 2)]
    for k in range(5):
        xs = [[(i + 1, 1), (2, -i - 1), (-1, i + 2)] for i in range(k)]
        zs = [[(1, -j - 1), (j + 2, 1), (2, j)] for j in range(k)]
        source, test, repeated = tensor(xs), tensor(zs), tensor([x] * k)
        terms = []
        for number, sigma in enumerate(itertools.permutations(range(k))):
            require(inner(permute(source, sigma), test) ==
                    gproduct(vector_inner(xs[i], zs[sigma[i]]) for i in range(k)),
                    "inverse-permutation convention or complex inner product failed")
            coefficient_checks += 1
            require(permute(repeated, sigma) == repeated,
                    "permutation failed to fix a non-real repeated letter")
            repeated_checks += 1
            a = (((number + 1, 1), (1, -number)),
                 ((2, number + 1), (-number, 2)))
            terms.append((sigma, a))
        b = tuple(tuple(gsum(a[i][j] for _, a in terms) for j in range(2))
                  for i in range(2))
        v = tensor([d] + [x] * k + [alpha])
        expected = tensor([d] + [x] * k + [matrix_vector(b, alpha)])
        require(apply_word_operator(v, terms) == expected,
                "repeated-letter identity failed in the full output tensor")
        star_terms = [(inverse(sigma), adjoint(a)) for sigma, a in terms]
        star_expected = tensor([d] + [x] * k +
                               [matrix_vector(adjoint(b), alpha)])
        require(apply_word_operator(v, star_terms) == star_expected,
                "adjoint repeated-letter identity failed in the full output tensor")
        full_output_checks += 2
    return {"degrees": [0, 1, 2, 3, 4],
            "gaussian_integer_arithmetic_only": True,
            "permutation_coefficient_checks": coefficient_checks,
            "non_real_repeated_letter_checks": repeated_checks,
            "full_output_word_and_adjoint_checks": full_output_checks}


def canonical_rational(value):
    rational = Fraction(int(value["num"]), int(value["den"]))
    require(str(rational.numerator) == value["num"] and
            str(rational.denominator) == value["den"],
            "Jacobian rational was not canonical")
    return rational


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    require(status["adapter_exit_code"] == 0 and not status["timeout"],
            "Jacobian execution did not complete successfully")
    require(response["request"]["payload"] == payload and
            response["request"]["operation_id"] == "matrix.partial_trace.compute",
            "Jacobian output does not bind to the saved payload and operation")
    result = response["result"]["output"]
    a = [[canonical_rational(x) for x in row]
         for row in payload["matrix"]["entries"]]
    traced, kept = payload["traced_dimension"], payload["kept_dimension"]
    actual = [[canonical_rational(x) for x in row]
              for row in result["reduced_matrix"]["entries"]]
    expected = [[sum((a[t * kept + i][t * kept + j] for t in range(traced)),
                     Fraction(0)) for j in range(kept)] for i in range(kept)]
    require(actual == expected == [[Fraction(1), Fraction(0)],
                                   [Fraction(0), Fraction(1)]],
            "independent replay of the typed partial trace failed")
    require(normalized_trace(a) == Fraction(1, 2),
            "normalized trace of the included e_11 was not one half")
    return {"operation_id": "matrix.partial_trace.compute",
            "server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"],
            "adapter_exit_code": status["adapter_exit_code"],
            "applicability": "one finite trace-normalization example only"}


def check_current_lean():
    result = json.loads((HERE / "lean_check.json").read_text())
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    require(result["status"] == "success" and result["exit_code"] == 0 and
            result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "no successful hole-free real compiler and axiom-audit record")
    require("Lean (version 4.31.0," in result["tools"]["lean"]["version"],
            "compiler is not the required Lean 4.31.0")
    require(result["source_sha256"] == hashlib.sha256(source).hexdigest(),
            "Lean source changed after compilation")
    require(result["statement_fidelity_sha256"] ==
            hashlib.sha256(fidelity.encode()).hexdigest(),
            "statement-fidelity document changed after compilation")
    command_record = json.loads((HERE / "lean_verify_output.json").read_text())
    recorded = command_record["kernel"]["recorded"]
    require(recorded["verdict"] == "supports" and recorded["tier"] == "mechanical",
            "official compiler result was not attached as mechanical evidence")
    archive_path = recorded["artifact"]
    archive = json.loads((ROOT / archive_path).read_text())
    for field in ("status", "exit_code", "proof_holes", "audit_exit_code",
                  "source_sha256", "statement_fidelity_sha256"):
        require(archive["lean_check"][field] == result[field],
                f"archived and current compiler records disagree on {field}")
    require(archive["lean_source"]["text"] == source.decode() and
            archive["statement_fidelity"]["text"] == fidelity,
            "archived certificate does not describe the current formal statement")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max((c for c in state["claims"] if c["claim_id"] == "C_CORE"),
                key=lambda c: c["version"])
    require(archive["subject"]["subject_id"] == "C_CORE" and
            archive["subject"]["content_hash"] == claim["content_hash"],
            "formal evidence belongs to a superseded claim")
    require(claim["formal_statement"].strip() == source.decode().strip(),
            "claim ledger does not carry the source actually compiled")
    return {"claim_id": "C_CORE", "lean_version": "4.31.0", "exit_code": 0,
            "proof_holes": [], "archive": archive_path,
            "source_sha256": result["source_sha256"],
            "statement_fidelity_sha256": result["statement_fidelity_sha256"],
            "replay_boundary": "checks current real-compiler records; does not rerun Lean"}


def check_source():
    source = SOURCE.read_text()
    invariant = source.split(
        r"\begin{lemma}[Invariant intertwiners]\label{lem:invariant-intertwiners}", 1
    )[1].split(r"\begin{lemma}[Word structure]", 1)[0]
    for literal in (
        r"Let $k,l\geq0$",
        r"Y=0$ if $k\ne l$",
        r"\bigcup_j\mathcal U(D_j)",
        r"x_{\sigma^{-1}(1)}",
        r"m^{-c(\pi)}",
        r"\lambda_{\mathcal P}M^{r_s+r_t}",
    ):
        require(literal in invariant, f"source assertion changed: {literal}")
    for literal in (
        r"The operators $B_k$ are independent of the repeated letter $x$",
        r"x$ may be any complex centered $L^2$ vector",
        r"G^*(d_0\otimes x^{\otimes k}\otimes\alpha)",
    ):
        require(literal in source, f"word-structure assertion changed: {literal}")
    return {"labels": ["lem:invariant-intertwiners", "lem:word-structure"],
            "literal_assertions_checked": 9,
            "refutation_claimed": False}


def build_certificate():
    return {
        "result": "all-degree verification theorem with a separately formalized core",
        "mathematical_proof": "proof.md",
        "source_fidelity": "source_fidelity.md",
        "scope": {
            "all_degree_basis": "ordinary proof plus the stated Lean core",
            "python_computations": "bounded exact diagnostics, not an all-degree proof",
            "independent_review": "not performed by this script",
            "mathematical_novelty": "not claimed; related 2024 prior art identified",
            "kadison_similarity_conjecture": "not certified",
        },
        "source": check_source(),
        "matrix_units_and_centering": check_matrix_units(),
        "coefficient_isolation": check_coefficient_isolation(),
        "normalized_inclusions": check_inclusions(),
        "cycle_threshold": check_cycle_threshold(),
        "same_side_pairings": check_pairing_support(),
        "complex_permutations_and_words": check_complex_permutations_and_words(),
        "jacobian": check_jacobian(),
        "formal_core": check_current_lean(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true",
                        help="write the deterministically recomputed exact certificate")
    args = parser.parse_args()
    certificate = build_certificate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(path.read_text()) == certificate,
                "exact certificate does not equal independent recomputation")
    print(json.dumps({
        "status": "passed",
        "exact_certificate": str(path.relative_to(ROOT)),
        "probe_form_comparisons":
            certificate["coefficient_isolation"]["all_probe_form_comparisons"],
        "pairing_support_comparisons":
            certificate["same_side_pairings"]["matching_support_comparisons"],
        "lean_exit_code": certificate["formal_core"]["exit_code"],
        "proof_holes": certificate["formal_core"]["proof_holes"],
        "independent_review": "still required",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
