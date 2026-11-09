#!/usr/bin/env python3
"""Exact new word witnesses, not a checker for the universal relation-gap proof."""

import argparse
import copy
import json
from pathlib import Path
import sys


GENERATORS = ["x1", "a1", "x2", "a2", "s", "t"]
RELATORS = {
    "r1": [1, 2, -1] + [-2] * 4,
    "r2": [3, 4, -3] + [-4] * 3,
    "r3": [1] + [-4] * 13,
    "r4": [5, 3, -5] + [-2] * 5,
    "r5": [6, 5, -6, -1, -5],
}
T1 = (1, 1)
T2 = (3, 3, 3)
A2 = (4,)
W = T1 + T2
SCOPE = (
    "Free-group presentation equivalences and the new relator's Fox derivative "
    "only; universal deficiency, module minima, topology, and novelty are not "
    "mechanically certified."
)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def reduce_word(letters):
    stack = []
    for letter in letters:
        if stack and stack[-1] == -letter:
            stack.pop()
        else:
            stack.append(letter)
    return tuple(stack)


def inverse_word(letters):
    return tuple(-letter for letter in reversed(letters))


def commutator(left, right):
    return reduce_word(left + right + inverse_word(left) + inverse_word(right))


def checked_word(value, n):
    require(isinstance(value, list), "a free word must be a list")
    require(
        all(type(x) is int and 1 <= abs(x) <= n for x in value),
        "invalid signed generator",
    )
    return tuple(value)


def factor(relator, conjugator=(), sign=1):
    return {"relator": relator, "conjugator": list(conjugator), "sign": sign}


def inverse_factors(factors):
    return [
        factor(f["relator"], f["conjugator"], -f["sign"])
        for f in reversed(factors)
    ]


def conjugate_factors(factors, prefix):
    return [
        factor(
            f["relator"],
            reduce_word(tuple(prefix) + tuple(f["conjugator"])),
            f["sign"],
        )
        for f in factors
    ]


def expand(factors, relators, n):
    require(isinstance(factors, list), "relator factors must be a list")
    result = ()
    for f in factors:
        require(
            isinstance(f, dict) and set(f) == {"relator", "conjugator", "sign"},
            "invalid relator-factor fields",
        )
        require(f["relator"] in relators, "factor uses an unavailable relator")
        require(type(f["sign"]) is int and f["sign"] in (-1, 1), "invalid sign")
        conjugator = checked_word(f["conjugator"], n)
        relator = tuple(relators[f["relator"]])
        if f["sign"] == -1:
            relator = inverse_word(relator)
        result = reduce_word(
            result + conjugator + relator + inverse_word(conjugator)
        )
    return result


def word_witnesses():
    a = [factor("r3", (1,)), factor("r3")]
    b = []
    for exponent in range(1, 4):
        b = conjugate_factors(b, (3,)) + [
            factor("r2", (4,) * (3 * j))
            for j in range(3 ** (exponent - 1))
        ]
    e = conjugate_factors(b, T1) + conjugate_factors(
        inverse_factors(a), T1 + A2
    )
    t1 = inverse_factors(e) + [factor("w"), factor("w", A2, -1)]
    t2 = inverse_factors(t1) + [factor("w")]
    definitions = [
        ("A=t1*a2^-26", "base", T1 + (-4,) * 26, a),
        ("B=[t2,a2]*a2^-26", "base", commutator(T2, A2) + (-4,) * 26, b),
        ("E=[w,a2]*t1^-1", "base", commutator(W, A2) + inverse_word(T1), e),
        ("t1_in_balanced", "balanced", T1, t1),
        ("t2_in_balanced", "balanced", T2, t2),
        ("w_in_two_power", "two_power", W, [factor("t1"), factor("t2")]),
    ]
    return [
        {
            "name": name,
            "ambient": ambient,
            "target_free_word": list(reduce_word(target)),
            "relator_conjugates": factors,
        }
        for name, ambient, target, factors in definitions
    ]


def q_add(left, right):
    return (left[0] + right[0], left[1] + right[1])


def q_multiply(left, right):
    a, b = left
    c, d = right
    return (a * c - b * d, a * d + b * c - b * d)


def q_inverse_unit(value):
    a, b = value
    require(a * a - a * b + b * b == 1, "expected a cyclotomic unit of norm one")
    return (a - b, -b)


def new_fox(n):
    values = {1: (-1, 0), 3: (-1, -1)}
    prefix = (1, 0)
    derivatives = [(0, 0)] * n
    for letter in W:
        index = abs(letter)
        require(index in values, "w contains an unexpected generator")
        if letter > 0:
            derivatives[index - 1] = q_add(derivatives[index - 1], prefix)
            prefix = q_multiply(prefix, values[index])
        else:
            prefix = q_multiply(prefix, q_inverse_unit(values[index]))
            derivatives[index - 1] = q_add(
                derivatives[index - 1], (-prefix[0], -prefix[1])
            )
    require(prefix == (1, 0), "w does not evaluate to the identity")
    require(all(x == (0, 0) for x in derivatives), "new Fox row is not zero")
    return {
        "field": "Q[zeta]/(zeta^2+zeta+1)",
        "pair_convention": "[a,b] means a+b*zeta",
        "representation_dimension": n - 4,
        "values_used": {"x1": [-1, 0], "x2": [-1, -1]},
        "word_image": list(prefix),
        "scalar_coefficients": [list(x) for x in derivatives],
        "block_interpretation": "Each coefficient multiplies the identity matrix.",
    }


def presentation_case(n):
    base = {name: word[:] for name, word in list(RELATORS.items())[:n - 1]}
    return {
        "n": n,
        "generators": GENERATORS[:n],
        "two_power_presentation": {**base, "t1": list(T1), "t2": list(T2)},
        "balanced_presentation": {**base, "w": list(W)},
        "fox_of_w": new_fox(n),
    }


def polynomial_product(left, right):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return result


def certificate():
    return {
        "schema_version": 1,
        "scope": SCOPE,
        "word_encoding": "Signed one-based indices in each listed generator order.",
        "presentations": [presentation_case(5), presentation_case(6)],
        "witnesses": word_witnesses(),
        "cyclotomic_identity": {
            "coefficient_order": "ascending degree",
            "dividend": [1, 0, 1, 0, 1],
            "divisor": [1, 1, 1],
            "quotient": [1, -1, 1],
            "remainder": [0],
        },
    }


def verify(data):
    expected = certificate()
    require(isinstance(data, dict) and set(data) == set(expected), "certificate fields")
    for key in ["schema_version", "scope", "word_encoding"]:
        require(data[key] == expected[key], "changed " + key)
    require(data["presentations"] == expected["presentations"], "source or new Fox data")
    polynomial = data["cyclotomic_identity"]
    require(polynomial == expected["cyclotomic_identity"], "changed cyclotomic identity")
    require(
        polynomial_product(polynomial["divisor"], polynomial["quotient"])
        == polynomial["dividend"],
        "polynomial product does not reconstruct the dividend",
    )
    require(isinstance(data["witnesses"], list), "witnesses must be a list")
    require(len(data["witnesses"]) == len(expected["witnesses"]), "missing witness")
    checks = 0
    for case in data["presentations"]:
        n = case["n"]
        base = {name: case["balanced_presentation"][name] for name in RELATORS if name != "r5" or n == 6}
        environments = {
            "base": base,
            "balanced": case["balanced_presentation"],
            "two_power": case["two_power_presentation"],
        }
        for witness, reconstructed in zip(data["witnesses"], expected["witnesses"]):
            require(
                isinstance(witness, dict) and set(witness) == set(reconstructed),
                "witness fields",
            )
            for key in ["name", "ambient", "target_free_word"]:
                require(witness[key] == reconstructed[key], "changed witness " + key)
            target = checked_word(witness["target_free_word"], n)
            relators = environments[witness["ambient"]]
            require(
                expand(reconstructed["relator_conjugates"], relators, n) == target,
                "reconstructed identity failed: " + witness["name"],
            )
            require(
                expand(witness["relator_conjugates"], relators, n) == target,
                "free reduction failed: " + witness["name"],
            )
            checks += 1
    return {
        "verified": True,
        "presentations": [5, 6],
        "distinct_word_witnesses": 6,
        "auxiliary_word_witnesses": 2,
        "new_word_witnesses": 4,
        "word_checks_across_both_presentations": checks,
        "factor_counts": {
            w["name"]: len(w["relator_conjugates"]) for w in data["witnesses"]
        },
        "new_Fox_rows_exactly_zero": 2,
        "universal_claims_mechanically_verified": False,
    }


def corrupted_cases(data):
    changes = [
        ("wrong compressed word", ["presentations", 0, "balanced_presentation", "w", 4], -3),
        ("wrong original power", ["presentations", 1, "two_power_presentation", "t2"], [3, 3]),
        ("wrong extension orientation", ["presentations", 1, "balanced_presentation", "r5", 3], 1),
        ("wrong auxiliary sign", ["witnesses", 0, "relator_conjugates", 0, "sign"], -1),
        ("wrong base relator", ["witnesses", 1, "relator_conjugates", 1, "relator"], "r1"),
        ("wrong E conjugator", ["witnesses", 2, "relator_conjugates", 0, "conjugator"], [2]),
        ("wrong w sign", ["witnesses", 3, "relator_conjugates", 16, "sign"], 1),
        ("wrong t2 conjugator", ["witnesses", 4, "relator_conjugates", 0, "conjugator"], [2]),
        ("wrong reverse inclusion", ["witnesses", 5, "relator_conjugates", 0, "relator"], "t2"),
        ("changed target", ["witnesses", 2, "target_free_word"], [1, 1]),
        ("unavailable relator", ["witnesses", 3, "relator_conjugates", 0, "relator"], "t1"),
        ("invalid free letter", ["witnesses", 3, "relator_conjugates", 0, "conjugator"], [0]),
        ("wrong scalar Fox entry", ["presentations", 0, "fox_of_w", "scalar_coefficients", 0], [1, 0]),
        ("wrong block dimension", ["presentations", 1, "fox_of_w", "representation_dimension"], 1),
        ("wrong cyclotomic quotient", ["cyclotomic_identity", "quotient", 1], 1),
    ]
    for name, path, value in changes:
        changed = copy.deepcopy(data)
        node = changed
        for key in path[:-1]:
            node = node[key]
        node[path[-1]] = value
        yield name, changed
    changed = copy.deepcopy(data)
    changed["witnesses"][2]["relator_conjugates"].pop()
    yield "deleted E factor", changed


def self_test(data):
    rejected = []
    for name, changed in corrupted_cases(data):
        try:
            verify(changed)
        except ValueError:
            rejected.append(name)
        else:
            raise ValueError("corrupted witness accepted: " + name)
    return rejected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("certificate", nargs="?", help="JSON file, or - for stdin")
    parser.add_argument("--self-test", action="store_true")
    parser.add_argument("--emit-certificate", action="store_true")
    args = parser.parse_args()
    try:
        if args.emit_certificate:
            data = certificate()
        elif args.certificate == "-":
            data = json.load(sys.stdin)
        else:
            path = Path(args.certificate) if args.certificate else Path(__file__).with_name("exact_certificate.json")
            data = json.loads(path.read_text())
        result = verify(data)
        if args.self_test:
            rejected = self_test(data)
            result["corruptions_rejected"] = len(rejected)
            result["rejected_cases"] = rejected
        print(json.dumps(data if args.emit_certificate else result, indent=2))
        return 0
    except (OSError, ValueError, KeyError, TypeError) as error:
        print("certificate rejected: " + str(error), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
