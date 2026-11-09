#!/usr/bin/env python3
"""Replay universal descent algebra and one exact, explicitly finite D4 diagnostic."""

import argparse
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
OPERATION = "root_system.positive_roots.compute"
CARTAN = (
    (2, -1, 0, 0),
    (-1, 2, -1, -1),
    (0, -1, 2, 0),
    (0, -1, 0, 2),
)


def product(*words):
    result = []
    for word in words:
        for letter, exponent in word:
            if result and result[-1] == (letter, -exponent):
                result.pop()
            else:
                result.append((letter, exponent))
    return tuple(result)


def generator(name):
    return ((name, 1),)


def inverse(word):
    return tuple((letter, -exponent) for letter, exponent in reversed(word))


def transpose(word):
    return tuple(
        (letter[:-2] if letter.endswith("_T") else letter + "_T", exponent)
        for letter, exponent in reversed(word)
    )


def substitute(word, images):
    return product(
        *(
            images[letter] if exponent == 1 else inverse(images[letter])
            for letter, exponent in word
        )
    )


def display(word):
    return " ".join(
        letter if exponent == 1 else letter + "^-1"
        for letter, exponent in word
    ) or "1"


def universal_identities():
    identities = []

    def check(name, left, right, meaning):
        if left != right:
            raise AssertionError(f"{name}: {display(left)} != {display(right)}")
        identities.append(
            {"name": name, "normal_form": display(left), "meaning": meaning}
        )

    names = "a b n x y k z f_k l r f_l f_r"
    a, b, n, x, y, k, z, fk, l, r, fl, fr = map(generator, names.split())
    frobenius = {
        "n": product(a, n, inverse(b)),
        "x": product(x, inverse(a)),
        "y": product(y, inverse(b)),
        "k": fk,
        "z": product(a, z, inverse(k), inverse(a)),
        "l": fl,
        "r": fr,
    }

    def f(word):
        return substitute(word, frobenius)

    g = product(x, n, inverse(y))
    check("rational_representative", f(g), g, "F(x n y^-1) = x n y^-1")
    check(
        "second_endpoint_intertwining",
        product(inverse(b), f(product(inverse(n), k, n)), b),
        product(inverse(n), inverse(a), fk, a, n),
        "Ad(b^-1) F Ad(n^-1) = Ad(n^-1) Ad(a^-1) F",
    )
    check(
        "first_endpoint_descent",
        f(product(x, k, inverse(x))),
        product(x, inverse(a), fk, a, inverse(x)),
        "Ad(x) intertwines the first twisted Frobenius with F",
    )
    check(
        "both_descended_embeddings",
        product(inverse(g), x, k, inverse(x), g),
        product(y, inverse(n), k, n, inverse(y)),
        "Ad(g^-1) Ad(x) = Ad(y) Ad(n^-1)",
    )

    anew = product(a, k)
    bnew = product(b, inverse(n), k, n)
    xnew = product(x, z)
    ynew = product(y, inverse(n), z, n)
    check(
        "changed_lifts",
        product(anew, n, inverse(bnew)),
        product(a, n, inverse(b)),
        "a' = a k and b' = b n^-1 k n preserve F(n)",
    )
    check(
        "changed_first_lang_solution",
        f(xnew),
        product(xnew, inverse(anew)),
        "F_K(z) = z k^-1 gives the new first Lang solution",
    )
    check(
        "changed_second_lang_solution",
        f(ynew),
        product(ynew, inverse(bnew)),
        "The same z gives the new second Lang solution",
    )
    check(
        "changed_lifts_same_representative",
        product(xnew, n, inverse(ynew)),
        g,
        "Changing both lifts and both Lang solutions leaves g unchanged",
    )
    nnew = product(l, n, inverse(r))
    anew = product(fl, a, inverse(l))
    bnew = product(fr, b, inverse(r))
    check(
        "changed_normalizer_representative",
        f(nnew),
        product(anew, nnew, inverse(bnew)),
        "The two endpoint marking changes respect Frobenius",
    )

    q, w, v = map(generator, ("Q", "w", "v"))
    u = product(inverse(q), w, q, v, inverse(w))
    check(
        "original_lattice_intertwining",
        product(w, q, v),
        product(q, u, w),
        "u is eliminated using w Q v = Q u w",
    )
    qdual = transpose(q)
    wdual = inverse(transpose(w))
    udual = product(inverse(qdual), transpose(u), qdual)
    vdual = product(inverse(qdual), transpose(v), qdual)
    check(
        "dual_frobenius_relation",
        product(inverse(qdual), wdual, qdual),
        product(udual, wdual, inverse(vdual)),
        "F_dual(w^-t) = U w^-t V^-1",
    )
    check(
        "first_dual_twist",
        product(qdual, udual),
        transpose(product(q, u)),
        "Q^t U = (Q u)^t",
    )
    check(
        "second_dual_twist",
        product(qdual, vdual),
        transpose(product(q, v)),
        "Q^t V = (Q v)^t",
    )
    check(
        "dual_second_endpoint",
        product(wdual, qdual, vdual),
        product(qdual, udual, wdual),
        "Both dual twisted Frobenius maps intertwine the second embedding",
    )
    check(
        "transpose_involution",
        transpose(transpose(u)),
        u,
        "The anti-automorphism is involutive",
    )

    m1, m2, h, s, c1, c2 = map(generator, "m1 m2 h s c1 c2".split())
    g = product(m1, h, inverse(m2))
    t = product(m1, s, inverse(m1))
    check(
        "parameter_obstruction",
        product(
            inverse(m1), inverse(t), g, m2, s,
            inverse(m2), inverse(g), m1,
        ),
        product(inverse(s), h, s, inverse(h)),
        "Equality of the two parameter images is equivalent to h centralizing s",
    )
    check(
        "parameter_quotient_action",
        product(
            inverse(product(l, m1, c1)),
            l, g, inverse(r), r, m2, c2,
        ),
        product(inverse(c1), h, c2),
        "The quotient depends on h only modulo C_M(s) on both sides",
    )
    check(
        "tuple_to_centralizer_representative",
        product(inverse(m1), g, m2),
        h,
        "The two endpoint actions reduce every tuple to (h,1,1)",
    )
    check(
        "centralizer_embedding_transport",
        product(
            h,
            inverse(h), k, h,
            inverse(h), s, h,
            inverse(h), inverse(k), h,
            inverse(h), inverse(s), h,
            inverse(h),
        ),
        product(k, s, inverse(k), inverse(s)),
        "The second embedding transports the parameter centralizer",
    )
    return identities


def root_data_replay():
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    envelope = json.loads((HERE / "jacobian_output.json").read_text())
    if contract["result"]["operation"]["operation_id"] != OPERATION:
        raise AssertionError("Wrong inspected Jacobian operation")
    if contract["server"]["version"] != envelope["server"]["version"]:
        raise AssertionError("Jacobian server versions differ")
    if contract["protocol_version"] != envelope["protocol_version"]:
        raise AssertionError("Jacobian protocol versions differ")
    if payload != {"matrix": [list(row) for row in CARTAN]}:
        raise AssertionError("The diagnostic is specifically the stated D4 datum")
    if envelope["request"] != {"operation_id": OPERATION, "payload": payload}:
        raise AssertionError("Jacobian result is not bound to the exact payload")
    if envelope["result"]["operation_id"] != OPERATION:
        raise AssertionError("Jacobian returned a different operation")
    output = envelope["result"]["output"]
    roots = set()
    pending = [
        tuple(sign if i == j else 0 for i in range(4))
        for j in range(4)
        for sign in (-1, 1)
    ]
    while pending:
        root = pending.pop()
        if root in roots:
            continue
        roots.add(root)
        if len(roots) > 24:
            raise AssertionError("Unexpected root closure for D4")
        for i in range(4):
            image = list(root)
            image[i] -= sum(CARTAN[i][j] * root[j] for j in range(4))
            if tuple(image) not in roots:
                pending.append(tuple(image))
    positive = {root for root in roots if all(entry >= 0 for entry in root)}
    negative = {tuple(-entry for entry in root) for root in positive}
    if len(roots) != 24 or roots != positive | negative:
        raise AssertionError("Invalid signed D4 root closure")
    if output["cartan_matrix"] != payload["matrix"] or output["rank"] != 4:
        raise AssertionError("Wrong Jacobian root datum")
    if set(map(tuple, output["positive_roots"])) != positive:
        raise AssertionError("Jacobian positive roots do not replay")
    if set(map(tuple, output["negative_roots"])) != negative:
        raise AssertionError("Jacobian negative roots do not replay")
    if output["num_positive_roots"] != len(positive):
        raise AssertionError("Wrong Jacobian positive-root count")
    if output["simple_roots"] != [
        [int(i == j) for i in range(4)] for j in range(4)
    ]:
        raise AssertionError("Wrong simple-root coordinates")
    component, = output["components"]
    highest = max(positive, key=sum)
    if component != {
        "coxeter_number": 1 + sum(highest),
        "highest_root": list(highest),
        "marks": list(highest),
        "positive_roots": output["positive_roots"],
        "simple_root_indices": [0, 1, 2, 3],
    }:
        raise AssertionError("Jacobian component data do not replay")
    return {
        "operation_id": OPERATION,
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "transport": envelope["transport"],
        "adapter_exit_status": 0,
        "structured_error": None,
        "timeout": False,
        "rank": 4,
        "positive_roots": len(positive),
        "all_roots": len(roots),
        "scope": "finite root-data diagnostic, not character-theoretic verification",
    }


def compose(left, right):
    return tuple(
        (1 if entry > 0 else -1) * left[abs(entry) - 1]
        for entry in right
    )


def perm_inverse(element):
    result = [0] * len(element)
    for index, entry in enumerate(element, 1):
        result[abs(entry) - 1] = index if entry > 0 else -index
    return tuple(result)


def double_cosets(group, subgroup):
    remaining = set(group)
    result = []
    while remaining:
        representative = min(remaining)
        coset = {
            compose(compose(left, representative), right)
            for left in subgroup
            for right in subgroup
        }
        if not coset <= remaining:
            raise AssertionError("Double cosets are not a partition")
        remaining -= coset
        result.append(coset)
    return result


def signed_weyl_replay():
    group = {
        tuple(sign * entry for sign, entry in zip(signs, permutation))
        for permutation in itertools.permutations(range(1, 5))
        for signs in itertools.product((-1, 1), repeat=4)
        if signs.count(-1) % 2 == 0
    }
    levi = {element for element in group if element[3] == 4}
    graph = (1, 2, 3, -4)

    def f(element):
        return compose(compose(graph, element), graph)

    ambient_cosets = double_cosets(group, levi)
    descriptions = []
    for coset in ambient_cosets:
        representative = min(coset)
        if representative[3] == 4:
            support = "equal_positive"
        elif representative[3] == -4:
            support = "equal_negative"
        else:
            support = "disjoint"
        descriptions.append(
            {
                "support": support,
                "size": len(coset),
                "frobenius_stable": {f(element) for element in coset} == coset,
                "fixed_representatives": sum(f(element) == element for element in coset),
            }
        )
    descriptions.sort(key=lambda item: item["support"])
    w = (4, 2, 3, 1)
    u = v = (-1, -2, 3, 4)
    if not u in levi or not v in levi or not w in group:
        raise AssertionError("Descent witnesses are not in the required Weyl groups")
    if f(w) != compose(compose(u, w), perm_inverse(v)):
        raise AssertionError("F(w) = u w v^-1 does not hold")
    disjoint, = [item for item in descriptions if item["support"] == "disjoint"]
    if not disjoint["frobenius_stable"] or disjoint["fixed_representatives"] != 0:
        raise AssertionError("The intended non-fixed-representative example failed")

    packets = ({1, 4}, {2, 3})

    def in_centralizer(element):
        return all(
            {abs(element[i - 1]) for i in packet} == packet
            and sum(element[i - 1] < 0 for i in packet) % 2 == 0
            for packet in packets
        )

    centralizer = {element for element in group if in_centralizer(element)}
    centralizer_levi = centralizer & levi
    centralizer_cosets = double_cosets(centralizer, centralizer_levi)
    stable_centralizer_cosets = [
        coset for coset in centralizer_cosets
        if {f(element) for element in coset} == coset
    ]
    refined_disjoint = sum(
        abs(next(iter(coset))[3]) != 4 for coset in stable_centralizer_cosets
    )
    if (len(group), len(levi), len(centralizer), len(centralizer_levi)) != (192, 24, 16, 4):
        raise AssertionError("Unexpected Weyl subgroup orders")
    if (len(ambient_cosets), len(centralizer_cosets), len(stable_centralizer_cosets)) != (3, 4, 2):
        raise AssertionError("Unexpected exact double-coset counts")
    if refined_disjoint != 0:
        raise AssertionError("The proposed refinement diagnostic failed")
    return {
        "datum": "D4, graph involution flips coordinate 4, Levi roots on coordinates 1,2,3",
        "orders": {"W": 192, "W_M": 24, "W_C": 16, "W_CM": 4},
        "ambient_double_cosets": descriptions,
        "descent_witness": {
            "w": list(w), "u": list(u), "v": list(v), "F_w": list(f(w)),
            "twisted_torus_action": list(compose(graph, u)),
        },
        "centralizer_packets": [[1, 4], [2, 3]],
        "centralizer_algebraic_double_cosets": len(centralizer_cosets),
        "centralizer_stable_double_cosets": len(stable_centralizer_cosets),
        "centralizer_stable_disjoint_double_cosets": refined_disjoint,
        "scope": "exact finite Weyl diagnostic; not an admissible counterexample",
    }


def sign_replay():
    for eh, em, ec, ecm in itertools.product((-1, 1), repeat=4):
        relative = eh * em * ec * ecm
        if eh * em * relative != ec * ecm or relative * relative != 1:
            raise AssertionError("Sign-normalization conversion failed")
    return {
        "all_sign_assignments": 16,
        "relative_sign": "epsilon_H epsilon_M epsilon_C epsilon_CM",
        "hilbert_schmidt_norm_preserved_by_relative_sign": True,
    }


def reconstruct():
    return {
        "claim": "C_SINGLE_CYCLE_TRANSPORT",
        "result_class": "known_result",
        "novelty_status": "not_new",
        "significance_status": "checkpoint",
        "independent_review": "pending",
        "universal_equational_certificate": {
            "method": "free-group normal forms with explicit relation elimination and transpose anti-involution",
            "rank_bound": None,
            "identities": universal_identities(),
        },
        "jacobian": root_data_replay(),
        "finite_weyl_diagnostic": signed_weyl_replay(),
        "sign_conversion": sign_replay(),
        "external_mathematical_inputs_not_machine_checked": [
            "Lang descent and rational orbit classification for connected stabilizers",
            "Jordan decomposition and rational Lusztig-series support",
            "Bonnafe--Michel arxiv:1003.4922v1 Theorem 3.8(4)",
            "Enguehard arxiv:1312.0106v1 Proposition 5.3",
            "Digne--Michel 1990 Proposition 6.3 and Theorem 7.1",
        ],
        "not_claimed": [
            "a counterexample to prop:single-cycle",
            "machine verification of all character-theoretic statements",
            "a new publishable theorem",
            "verification or refutation of either Donovan main theorem",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    computed = reconstruct()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(computed, indent=2) + "\n")
    recorded = json.loads(path.read_text())
    if recorded != computed:
        raise AssertionError("Stored certificate differs from independent reconstruction")
    print(json.dumps({
        "certificate_replay": "pass",
        "universal_word_identities": len(computed["universal_equational_certificate"]["identities"]),
        "finite_diagnostic": "D4 only",
        "full_character_theory_machine_checked": False,
        "result_class": computed["result_class"],
        "publishable_campaign_complete": False,
        "independent_review": "pending",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
