#!/usr/bin/env python3
"""Replay exact algebra and finite regressions; do not certify the full target."""

import argparse
from collections import Counter
import hashlib
from itertools import combinations, combinations_with_replacement
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
PROJECT = ROOT.parent.parent


def check(condition, message):
    if not condition:
        raise AssertionError(message)


def add(left, right, coefficient=1):
    result = dict(left)
    for key, value in right.items():
        result[key] = result.get(key, 0) + coefficient * value
        if result[key] == 0:
            del result[key]
    return result


def bracket(word):
    word = tuple(word)
    check(all(a <= b for a, b in zip(word, word[1:])), "Unordered simplex")
    if len(set(word)) != len(word):
        return {}
    return {word: 1}


def boundary_word(word):
    if len(word) <= 1:
        return {}
    result = {}
    for index in range(len(word)):
        result = add(
            result, bracket(word[:index] + word[index + 1 :]), (-1) ** index
        )
    return result


def linear(chain, operation):
    result = {}
    for key, coefficient in chain.items():
        result = add(result, operation(key), coefficient)
    return result


def subsets(size):
    for length in range(1, size + 1):
        yield from combinations(range(size), length)


def prism(f, g, word, factor):
    image = tuple(f[x] for x in word)
    if factor == 0:
        return bracket(image)
    if factor == 1:
        return bracket(tuple(g[x] for x in word))
    check(factor == 2, "Unknown interval basis element")
    return bracket(image + (g[word[-1]],))


def prism_tensor_boundary(f, g, word, factor):
    result = linear(boundary_word(word), lambda face: prism(f, g, face, factor))
    if factor == 2:
        sign = (-1) ** (len(word) - 1)
        result = add(result, prism(f, g, word, 1), sign)
        result = add(result, prism(f, g, word, 0), -sign)
    return result


def controlled(f, g):
    return all(
        f[x] == g[x] or g[x] == g[y]
        for x in range(len(f))
        for y in range(x, len(f))
    )


def endpoints(length, target):
    lists = list(combinations_with_replacement(range(target), length))
    for f in lists:
        for g in lists:
            if all(a <= b for a, b in zip(f, g)):
                yield f, g


def check_prisms(counts):
    for target in range(1, 5):
        for length in range(1, 6):
            for f, g in endpoints(length, target):
                counts["endpoint_pairs"] += 1
                edges_hold = all(
                    linear(prism(f, g, word, 2), boundary_word)
                    == prism_tensor_boundary(f, g, word, 2)
                    for word in combinations(range(length), 2)
                )
                check(edges_hold == controlled(f, g), "Edge criterion mismatch")
                if not edges_hold:
                    counts["excluded_endpoint_pairs"] += 1
                    continue
                counts["controlled_endpoint_pairs"] += 1
                for word in subsets(length):
                    for factor in range(3):
                        image = prism(f, g, word, factor)
                        check(all(v > 0 for v in image.values()), "Nonpositive prism")
                        check(
                            linear(image, boundary_word)
                            == prism_tensor_boundary(f, g, word, factor),
                            "Wrong right-interval differential",
                        )
                        counts["prism_basis_checks"] += 1
                    if all(f[x] == g[x] for x in word):
                        check(prism(f, g, word, 2) == {}, "Failed stationarity")
                        check(
                            prism(f, g, word, 0) == prism(f, g, word, 1),
                            "Unequal stationary endpoints",
                        )
                        counts["stationary_basis_checks"] += 1


def check_simplex_operators(counts):
    for length in range(1, 4):
        for f, g in endpoints(length, 3):
            if not controlled(f, g):
                continue
            for source_length in range(1, 5):
                for alpha in combinations_with_replacement(
                    range(length), source_length
                ):
                    fa = tuple(f[x] for x in alpha)
                    ga = tuple(g[x] for x in alpha)
                    for word in subsets(source_length):
                        selected = tuple(alpha[x] for x in word)
                        for factor in range(3):
                            left = prism(fa, ga, word, factor)
                            right = (
                                prism(f, g, selected, factor)
                                if len(set(selected)) == len(selected)
                                else {}
                            )
                            check(left == right, "Failed whole simplex naturality")
                            counts["simplex_operator_checks"] += 1


def tensor(left, right):
    return {
        (a, b): x * y
        for a, x in left.items()
        for b, y in right.items()
    }


def tensor_boundary(pair):
    left, right = pair
    result = tensor(boundary_word(left), bracket(right))
    return add(
        result,
        tensor(bracket(left), boundary_word(right)),
        (-1) ** (len(left) - 1),
    )


def aw(word):
    result = {}
    for cut in range(len(word)):
        result = add(
            result, tensor(bracket(word[: cut + 1]), bracket(word[cut:]))
        )
    return result


def check_aw(counts):
    for word in subsets(7):
        diagonal = aw(word)
        check(
            linear(diagonal, tensor_boundary) == linear(boundary_word(word), aw),
            "Alexander-Whitney differential failed",
        )
        for side in range(2):
            counit = {}
            for (left, right), coefficient in diagonal.items():
                removed, kept = (left, right) if side == 0 else (right, left)
                if len(removed) == 1:
                    counit = add(counit, bracket(kept), coefficient)
            check(counit == bracket(word), "Alexander-Whitney counit failed")
        counts["aw_basis_checks"] += 1
    for source_length in range(1, 5):
        for target_length in range(1, 5):
            for alpha in combinations_with_replacement(
                range(target_length), source_length
            ):
                for word in subsets(source_length):
                    image = tuple(alpha[x] for x in word)
                    left = linear(bracket(image), aw)
                    right = linear(
                        aw(word),
                        lambda pair: tensor(
                            bracket(tuple(alpha[x] for x in pair[0])),
                            bracket(tuple(alpha[x] for x in pair[1])),
                        ),
                    )
                    check(left == right, "Alexander-Whitney degeneracy failed")
                    counts["aw_operator_checks"] += 1


def posets(size):
    pairs = list(combinations(range(size), 2))
    for mask in range(1 << len(pairs)):
        relation = {(x, x) for x in range(size)}
        relation.update(pair for bit, pair in enumerate(pairs) if mask >> bit & 1)
        if all(
            (x, z) in relation
            for x, y in relation
            for yy, z in relation
            if y == yy
        ):
            yield relation


def lower(A, E, relation):
    return all(x in A for x, y in relation if x in E and y in A)


def retract(A, E, relation):
    result = {}
    for e in E:
        below = [a for a in A if (a, e) in relation]
        maxima = [
            a for a in below if all((b, a) in relation for b in below)
        ]
        if len(maxima) != 1:
            return None
        result[e] = maxima[0]
    return result


def check_adjoint(A, E, relation, r):
    check(all(r[a] == a for a in A), "Not a retraction")
    check(
        all(
            ((a, e) in relation) == ((a, r[e]) in relation)
            for a in A
            for e in E
        ),
        "Adjunction orientation failed",
    )
    check(
        all((r[x], r[y]) in relation for x, y in relation if x in E and y in E),
        "Nonmonotone retraction",
    )


def monotone_map(mapping, E, relation):
    return all(
        (mapping[x], mapping[y]) in relation
        for x, y in relation
        if x in E and y in E
    )


def check_finite_reductions(counts):
    for size in range(6):
        E = set(range(size))
        for relation in posets(size):
            counts["posets"] += 1
            for mask in range(1 << size):
                A = {x for x in E if mask >> x & 1}
                if not lower(A, E, relation):
                    continue
                r = retract(A, E, relation)
                if r is None:
                    continue
                check_adjoint(A, E, relation, r)
                counts["sieve_retract_pairs"] += 1
                new = E - A
                greatest = [x for x in new if all((y, x) in relation for y in new)]
                if greatest:
                    x = greatest[0]
                    k = {e: e if e in A else r[x] for e in E}
                    g = {e: e if e in A else x for e in E}
                    check(monotone_map(k, E, relation), "Nonmonotone local k")
                    check(monotone_map(g, E, relation), "Nonmonotone local g")
                    check(all((e, g[e]) in relation for e in E), "id not <= g")
                    check(all((k[e], g[e]) in relation for e in E), "k not <= g")
                    check(set(k.values()) <= A, "k does not retract into A")
                    counts["greatest_new_cases"] += 1
                elif new:
                    maxima = [
                        x for x in new
                        if all(y == x or (x, y) not in relation for y in E)
                    ]
                    check(len(maxima) >= 2, "Finite maximal-element step failed")
                    x, y = maxima[:2]
                    for F in (E - {x}, E - {y}, E - {x, y}):
                        check(lower(F, E, relation), "Deleted piece is not a sieve")
                        check_adjoint(A, F, relation, {e: r[e] for e in F})
                    check((E - {x}) | (E - {y}) == E, "Pieces do not cover")
                    counts["two_maximal_cases"] += 1
                for subset in range(1 << size):
                    T = {x for x in E if subset >> x & 1}
                    F = T | {r[x] for x in T}
                    check({r[x] for x in F} <= F, "Finite closure is not stable")
                    AF = A & F
                    check(lower(AF, F, relation), "Restricted sieve failed")
                    check_adjoint(AF, F, relation, {e: r[e] for e in F})
                    counts["finite_stable_closure_checks"] += 1


def category_pushout(E, A, relation, r, nonidentity):
    objects = {("x",)} | {("new", e) for e in E - A}
    arrows = {("x", m): (("x",), ("x",)) for m in (0, 1)}
    for e in E - A:
        for m in (0, 1):
            arrows[("cross", m, e)] = (("x",), ("new", e))
        for ep in E - A:
            if (e, ep) in relation:
                arrows[("new", e, ep)] = (("new", e), ("new", ep))

    def attaching_arrow(x, y):
        check((x, y) in relation and x in A and y in A, "Invalid old arrow")
        return 1 if x == y else nonidentity

    def compose(f, g):
        check(arrows[f][1] == arrows[g][0], "Noncomposable arrows")
        if f[0] == "x" and g[0] == "x":
            return ("x", f[1] * g[1])
        if f[0] == "x" and g[0] == "cross":
            return ("cross", f[1] * g[1], g[2])
        if f[0] == "cross" and g[0] == "new":
            return ("cross", f[1] * attaching_arrow(r[f[2]], r[g[2]]), g[2])
        if f[0] == "new" and g[0] == "new":
            return ("new", f[1], g[2])
        raise AssertionError("Missing composite")

    identities = {
        obj: ("x", 1) if obj == ("x",) else ("new", obj[1], obj[1])
        for obj in objects
    }

    def vertex(e):
        return ("x",) if e in A else ("new", e)

    def image(x, y):
        if y in A:
            return ("x", attaching_arrow(x, y))
        if x in A:
            return ("cross", attaching_arrow(x, r[y]), y)
        return ("new", x, y)

    for f, (source, target) in arrows.items():
        check(compose(identities[source], f) == f, "Left unit failed")
        check(compose(f, identities[target]) == f, "Right unit failed")
        for g, (gsource, gtarget) in arrows.items():
            if target != gsource:
                continue
            fg = compose(f, g)
            check(arrows[fg] == (source, gtarget), "Composite boundary failed")
            for h, (hsource, _) in arrows.items():
                if gtarget == hsource:
                    check(
                        compose(fg, h) == compose(f, compose(g, h)),
                        "Pushout composition is not associative",
                    )
    for x, y in relation:
        if x not in E or y not in E:
            continue
        check(arrows[image(x, y)] == (vertex(x), vertex(y)), "Functor boundary")
        for yy, z in relation:
            if y == yy and z in E:
                check(
                    compose(image(x, y), image(y, z)) == image(x, z),
                    "Attaching functor equations failed",
                )
    return objects, arrows


def check_identifying_attachments(counts):
    for size in range(1, 5):
        E = set(range(size))
        for relation in posets(size):
            for mask in range(1, 1 << size):
                A = {x for x in E if mask >> x & 1}
                if not lower(A, E, relation):
                    continue
                r = retract(A, E, relation)
                if r is None:
                    continue
                for nonidentity in (0, 1):
                    objects, arrows = category_pushout(E, A, relation, r, nonidentity)
                    check(
                        len(objects) == 1 + len(E - A),
                        "Object-identifying attachment changed new objects",
                    )
                    for piece_mask in range(1 << size):
                        F = {x for x in E if piece_mask >> x & 1}
                        if not A <= F or not lower(F, E, relation):
                            continue
                        piece_objects, piece_arrows = category_pushout(
                            F, A, relation, r, nonidentity
                        )
                        fiber = {
                            arrow: endpoints for arrow, endpoints in arrows.items()
                            if endpoints[0] in piece_objects
                            and endpoints[1] in piece_objects
                        }
                        check(fiber == piece_arrows, "Actual full fiber mismatch")
                        check(
                            all(
                                source in piece_objects
                                for source, target in arrows.values()
                                if target in piece_objects
                            ),
                            "Actual fiber is not a sieve",
                        )
                        counts["actual_category_fiber_checks"] += 1
                    counts["identifying_category_attachments"] += 1


def check_retained_boundary():
    f, g, word = (0, 0), (0, 1), (0, 1)
    positive = add(prism(f, g, (1,), 2), prism(f, g, word, 0))
    negative = add(prism(f, g, (0,), 2), prism(f, g, word, 1))
    check(prism(f, g, word, 2) == {}, "Example top is not zero")
    check(positive == negative == bracket((0, 1)), "Lost nonidentity lower cell")
    return {
        "top_chain": [],
        "one_source": [[0, 1]],
        "one_target": [[0, 1]],
        "zero_source": 0,
        "zero_target": 1,
        "interpretation": "identity 2-cell on a nonidentity 1-cell",
    }


def check_naive_route():
    f, g, word = (0, 0, 0), (0, 1, 2), (1, 2)
    left = linear(prism(f, g, word, 2), boundary_word)
    right = prism_tensor_boundary(f, g, word, 2)
    check(left == {}, "Naive example changed")
    expected = {(0, 2): 1, (0, 1): -1, (1, 2): -1}
    check(right == expected, "Naive route defect changed")
    check(not controlled(f, g), "Excluded route accidentally satisfies control")
    return {
        "E": [0, 1, 2],
        "A": [0],
        "retraction": [0, 0, 0],
        "f": list(f),
        "g": list(g),
        "edge": list(word),
        "dC": [],
        "Cd": [
            {"simplex": list(key), "coefficient": value}
            for key, value in sorted(right.items())
        ],
        "violated_prism_hypothesis": "g is not constant on E minus A",
        "manuscript_refutation": False,
    }


def check_jacobian():
    output = json.loads((ROOT / "jacobian_output.json").read_text())
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    check(output["request"]["payload"] == payload, "Adapter payload changed")
    check("error" not in output, "Jacobian returned a structured error")
    result = output["result"]["output"]
    check(result["tensor_basis_sizes"] == [4, 4, 1], "Wrong interval tensor")
    matrices = [
        [[int(value) for value in row] for row in matrix]
        for matrix in result["tensor_differential_matrices"]
    ]
    first, second = matrices
    check(
        all(
            sum(first[i][k] * second[k][0] for k in range(4)) == 0
            for i in range(4)
        ),
        "Tensor differential does not square to zero",
    )
    check([row[0] for row in second] == [-1, 1, 1, -1], "Wrong Koszul sign")
    return {
        "operation_id": output["result"]["operation_id"],
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "transport": output["transport"],
        "adapter_status": "typed_success",
        "error": None,
        "timeout": False,
        "scope": "exact interval-square chain complex only",
    }


def check_lean_record():
    source = ROOT / "lean/Main.lean"
    fidelity = ROOT / "lean/statement_fidelity.md"
    result = json.loads((ROOT / "lean/lean_check.json").read_text())
    check(result["status"] == "success" and result["exit_code"] == 0, "Lean failed")
    check(result["proof_holes"] == [], "Lean proof has holes")
    check(result["audit_exit_code"] == 0, "Lean axiom audit failed")
    check("4.31.0" in result["tools"]["lean"]["version"], "Wrong Lean version")
    for path, key in (
        (source, "source_sha256"),
        (fidelity, "statement_fidelity_sha256"),
    ):
        check(hashlib.sha256(path.read_bytes()).hexdigest() == result[key],
              "Lean source or statement fidelity changed after compilation")
    state = json.loads((PROJECT / "research/MATH_STATE.json").read_text())
    claims = [c for c in state["claims"] if c["claim_id"] == "C_AUDIT_KERNEL"]
    claim = max(claims, key=lambda c: c["version"])
    evidence = [
        e for e in state["evidence"]
        if e["subject"]["subject_id"] == "C_AUDIT_KERNEL"
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
    ]
    check(len(evidence) == 1, "Missing current native kernel certificate")
    artifact = evidence[0]["artifact"]
    archived = json.loads((PROJECT / artifact).read_text())
    check(archived["lean_source"]["text"] == source.read_text(), "Archive mismatch")
    check(archived["statement_fidelity"]["text"] == fidelity.read_text(),
          "Archived statement fidelity mismatch")
    check(archived["lean_check"]["source_sha256"] == result["source_sha256"],
          "Wrong archived compiler run")
    return {
        "claim": "C_AUDIT_KERNEL",
        "certificate": artifact,
        "compiler_version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "scope": "unbounded tuple correction, exact edge criterion and abstract adjunction gluing",
        "full_couniversality_formalized": False,
        "fresh_compile_performed_by_this_python_replay": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="Write the exact replay record")
    args = parser.parse_args()
    counts = Counter()
    check_prisms(counts)
    check_simplex_operators(counts)
    check_aw(counts)
    check_finite_reductions(counts)
    check_identifying_attachments(counts)
    certificate = {
        "target": "thm:couniversal, staged build/sections/05-couniversality.tex",
        "result_class": "partial_result",
        "classification": "unbounded formal core plus bounded exact regressions; not a full target certificate",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "target_independently_reviewed": False,
        "novelty_status": "not_verified",
        "formal_core": check_lean_record(),
        "finite_bounds": {
            "chain_endpoint_list_length_max": 5,
            "chain_target_cardinality_max": 4,
            "naturality_source_length_max": 4,
            "aw_simplex_dimension_max": 6,
            "poset_cardinality_max": 5,
            "actual_category_pushout_poset_cardinality_max": 4,
            "attaching_categories": "one-object two-element monoid; every old object identified; strict arrows sent to identity or absorbing idempotent",
        },
        "counts": dict(sorted(counts.items())),
        "retained_boundary_example": check_retained_boundary(),
        "excluded_naive_route": check_naive_route(),
        "jacobian": check_jacobian(),
        "unverified_by_this_certificate": [
            "The construction of the Gray tensor and its strict-category interpretation",
            "The complete all-dimensional couniversality theorem",
            "Literature attribution by an independent reader",
            "Publication significance and novelty",
            "Host-invoked independent Reviewer acceptance",
        ],
    }
    path = ROOT / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        check(json.loads(path.read_text()) == certificate, "Replay differs from saved certificate")
    print(json.dumps({
        "ok": True,
        "result_class": certificate["result_class"],
        "formal_core": certificate["formal_core"],
        "counts": certificate["counts"],
    }, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
