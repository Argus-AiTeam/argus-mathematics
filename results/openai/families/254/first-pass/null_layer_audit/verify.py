#!/usr/bin/env python3
"""Replay the exact certificates; the full categorical bridge is in theorem.md."""

import argparse
import copy
import hashlib
import json
import re
import subprocess
from fractions import Fraction
from pathlib import Path as FilePath

from zigzag import Complex, Generator, Path, Zigzag, accumulate, hom_data, rank


ROOT = FilePath(__file__).resolve().parent
PROJECT = ROOT.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
DECLARATIONS = {
    "middleExact", "middleExactAcyclic", "secondaryKernelZero",
    "strictChamberDetect", "finiteSeparation", "topVanishes",
    "rankStage", "boundedStagesEscape",
}
RELATIONS = [
    ["dd", "0"], ["rd", "0"], ["tr", "0"], ["tt", "0"],
    ["tj", "jt"], ["tk", "kt"],
]


class VerificationError(Exception):
    pass


def require(condition, message):
    if not condition:
        raise VerificationError(message)


def local_path(relative):
    path = (ROOT / relative).resolve()
    require(path.is_relative_to(ROOT), f"Evidence path leaves the audit directory: {relative}")
    return path


def read_json(relative):
    return json.loads(local_path(relative).read_text())


def add(first, second, factor=Fraction(1)):
    result = dict(first)
    for word, coefficient in second.items():
        accumulate(result, word, factor * coefficient)
    return result


def product(first, second, reduce_word):
    result = {}
    for a, x in first.items():
        for b, y in second.items():
            word = reduce_word(a + b)
            if word is not None:
                accumulate(result, word, x * y)
    return result


def nc_reduce(word):
    while True:
        for source, target in RELATIONS:
            position = word.find(source)
            if position >= 0:
                if target == "0":
                    return None
                word = word[:position] + target + word[position + len(source):]
                break
        else:
            return word


def nc_entry(text):
    if text == "0":
        return {}
    if text == "1":
        return {"": Fraction(1)}
    sign = -1 if text.startswith("-") else 1
    word = text[1:] if sign == -1 else text
    require(word and all(letter in "drkjt" for letter in word), "Invalid free-ring monomial")
    word = nc_reduce(word)
    return {} if word is None else {word: Fraction(sign)}


def matrix(raw):
    require(raw and raw[0] and all(len(row) == len(raw[0]) for row in raw), "Ragged proof matrix")
    return [[nc_entry(entry) for entry in row] for row in raw]


def mmul(first, second):
    require(len(first[0]) == len(second), "Noncomposable proof matrices")
    return [
        [
            sum_polys(
                product(first[i][k], second[k][j], nc_reduce)
                for k in range(len(second))
            )
            for j in range(len(second[0]))
        ]
        for i in range(len(first))
    ]


def sum_polys(polynomials):
    result = {}
    for polynomial in polynomials:
        result = add(result, polynomial)
    return result


def madd(first, second, factor=Fraction(1)):
    require(
        len(first) == len(second) and len(first[0]) == len(second[0]),
        "Incompatible proof-matrix shapes",
    )
    return [
        [add(a, b, factor) for a, b in zip(row, other)]
        for row, other in zip(first, second)
    ]


def identity(size):
    return [[{"": Fraction(1)} if i == j else {} for j in range(size)] for i in range(size)]


def zero_matrix(value, name):
    require(not any(entry for row in value for entry in row), f"Universal identity failed: {name}")


def verify_homotopy(certificate):
    proof = certificate["universal_homotopy"]
    require(proof["relations"] == RELATIONS, "Unapproved or missing algebraic relation")
    require(proof["variables"] == list("drkjt"), "Wrong free-ring variables")
    require(proof["block_order"] == ["A", "B", "C", "U", "T"]
            and proof["remaining_blocks"] == ["A", "C", "U"], "Relabelled homotopy blocks")
    raw = proof["matrices"]
    require(raw["D"] == [
        ["d", "0", "0", "0", "0"], ["kr", "tj", "0", "0", "0"],
        ["r", "0", "0", "0", "0"], ["0", "t", "0", "0", "0"],
        ["0", "1", "-k", "-j", "0"],
    ], "Source is not the specified negative-twist block differential")
    require(raw["Dbar"] == [
        ["d", "0", "0"], ["r", "0", "0"], ["0", "tk", "tj"],
    ], "Target is not the specified next-string differential")
    D, B, i, p, h = (matrix(raw[name]) for name in ("D", "Dbar", "i", "p", "h"))
    identities = {
        "D_squared": mmul(D, D),
        "Dbar_squared": mmul(B, B),
        "inclusion_chain_map": madd(mmul(D, i), mmul(i, B), -1),
        "projection_chain_map": madd(mmul(p, D), mmul(B, p), -1),
        "projection_inclusion": madd(mmul(p, i), identity(3), -1),
        "chain_homotopy": madd(
            madd(madd(mmul(i, p), mmul(D, h)), mmul(h, D)), identity(5), -1
        ),
    }
    for name, value in identities.items():
        zero_matrix(value, name)
    return len(identities)


def commutative(expression, variables):
    if isinstance(expression, int):
        return {(): Fraction(expression)} if expression else {}
    if isinstance(expression, str):
        require(expression in variables, f"Unknown polynomial variable: {expression}")
        return {(expression,): Fraction(1)}
    operator, *arguments = expression
    terms = [commutative(argument, variables) for argument in arguments]
    if operator == "add" and len(terms) == 2:
        return add(*terms)
    if operator == "sub" and len(terms) == 2:
        return add(*terms, factor=-1)
    if operator == "mul" and len(terms) == 2:
        return product(*terms, reduce_word=lambda word: tuple(sorted(word)))
    raise VerificationError(f"Unknown polynomial expression: {expression}")


def verify_polynomials(certificate):
    require(len(certificate["equality_certificates"]) == 1, "Missing top-zero certificate")
    for proof in certificate["equality_certificates"]:
        variables = set(proof["variables"])
        require(proof["name"] == "old_top_zero"
                and variables == {"old", "new", "top", "row_old", "row_new"},
                "Different equality-certificate statement")
        equations = {
            name: commutative(expression, variables)
            for name, expression in proof["equations"].items()
        }
        expected = {
            "count": {("new",): 1, ("old",): -1, ("row_old",): 1, ("top",): -1},
            "row_difference": {("row_new",): 1, ("row_old",): -1, ("new",): -2, ("old",): 2},
            "old_zero": {("row_old",): 1},
            "new_zero": {("row_new",): 1},
        }
        require(equations == expected and proof["target"] == "top",
                "Equality premises do not match the Cartan-row argument")
        combination = {}
        for multiplier, equation in proof["combination"]:
            require(equation in equations, "Equality certificate cites an unknown premise")
            combination = add(combination, equations[equation], Fraction(multiplier))
        target = commutative(proof["target"], variables)
        require(combination == target, f"Invalid equality certificate: {proof['name']}")
    expected_identities = {
        "euler_surplus": ({"a", "b", "bs", "h"}, {("b",): 1, ("bs",): -1, ("h",): 1}),
        "stage_budget": ({"k", "L"}, {("L", "k"): 1, ("L",): 1}),
        "sharp_family_level": ({"s", "t"}, {("s",): 1, ("t",): -1, (): 1}),
    }
    require(
        {proof["name"] for proof in certificate["polynomial_identities"]} == set(expected_identities)
        and len(certificate["polynomial_identities"]) == len(expected_identities),
        "Missing or relabelled polynomial identity",
    )
    for proof in certificate["polynomial_identities"]:
        variables = set(proof["variables"])
        expected_variables, expected_polynomial = expected_identities[proof["name"]]
        require(variables == expected_variables, "Wrong polynomial variables")
        require(
            commutative(proof["left"], variables)
            == commutative(proof["right"], variables)
            == expected_polynomial,
            f"Invalid polynomial identity: {proof['name']}",
        )
    return len(certificate["equality_certificates"]) + len(certificate["polynomial_identities"])


def verify_kernel(certificate, replay):
    info = certificate["kernel"]
    require(info["claim_id"] == "K_NULL_CORE", "The abstract kernel theorem was relabelled")
    source = local_path(info["source"])
    fidelity = local_path(info["statement_fidelity"])
    archived = read_json(info["certificate"])
    record = archived["lean_check"]
    require(record["status"] == "success" and record["exit_code"] == 0, "Lean did not succeed")
    require(record["proof_holes"] == [] and record["audit_exit_code"] == 0, "Lean proof has holes")
    require("version 4.31.0," in record["tools"]["lean"]["version"], "Wrong Lean version")
    require(hashlib.sha256(source.read_bytes()).hexdigest() == record["source_sha256"], "Stale Lean source")
    require(
        hashlib.sha256(fidelity.read_bytes()).hexdigest() == record["statement_fidelity_sha256"],
        "Stale statement-fidelity reading",
    )
    require(archived["lean_source"]["text"] == source.read_text(), "Archived source differs")
    require(archived["statement_fidelity"]["text"] == fidelity.read_text(), "Archived reading differs")
    for item, original in ((archived["lean_source"], source), (archived["statement_fidelity"], fidelity)):
        saved = (PROJECT / item["path"]).resolve()
        require(saved.is_relative_to(ROOT) and saved.read_bytes() == original.read_bytes(),
                "Compiler snapshot no longer matches the current source and reading")
    require(set(info["declarations"]) == DECLARATIONS, "Missing or relabelled kernel declaration")
    found = set(re.findall(r"'NullLayerAudit\.(\w+)' depends on axioms:", record["stdout"]))
    require(found == DECLARATIONS, "Compiler output does not cover the claimed declarations")
    for line in record["stdout"].splitlines():
        names = line.split("[", 1)[-1].rstrip("]").split(", ")
        require(set(names) <= {"propext", "Classical.choice", "Quot.sound"}, "Unexpected proof axiom")
    ledger = json.loads((PROJECT / "research/MATH_STATE.json").read_text())
    claims = [claim for claim in ledger["claims"] if claim["claim_id"] == "K_NULL_CORE"]
    require(claims and claims[-1]["formal_statement"] == source.read_text(), "Ledger formalization differs")
    require(archived["subject"]["content_hash"] == claims[-1]["content_hash"], "Stale kernel claim")
    if replay:
        command = [
            ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence",
            "verify", str(source), "--project-root", str(PROJECT),
            "--artifact-dir", str(ROOT / "lean"),
            "--statement-fidelity", str(fidelity), "--claim", "K_NULL_CORE",
        ]
        completed = subprocess.run(command, cwd=PROJECT, text=True, capture_output=True, check=False)
        require(completed.returncode == 0, f"Compiler replay failed:\n{completed.stdout}\n{completed.stderr}")
        answer = json.loads(completed.stdout)
        require(answer["exit_code"] == 0 and answer["proof_holes"] == [], "Compiler replay unverified")
        for module in ("math_state", "proof_graph_check"):
            checked = subprocess.run(
                [ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}",
                 "check", "--project-root", str(PROJECT)],
                cwd=PROJECT, text=True, capture_output=True, check=False,
            )
            require(checked.returncode == 0, f"{module} failed:\n{checked.stdout}\n{checked.stderr}")
    return len(found)


def apply_word(complex_, word, allowed):
    for vertex, sign in word:
        require(vertex in allowed and sign in (-1, 1), "Invalid acted letter")
        complex_ = complex_.twist(vertex, sign)
    return complex_


def cap(complex_, vertices, level):
    return all(g.level <= level for g in complex_.generators if g.vertex in vertices)


def cohomology_json(cohomology):
    return [[n, v, d] for (n, v), d in sorted(cohomology.items())]


def sharp_model(algebra, n):
    generators = [
        Generator("f", 0, 0), Generator("k", -1, 1),
        Generator("a", -2, 2), Generator("a", -3, 4),
    ]
    differential = {
        (1, 0, Path("k", "f", 1)): Fraction(1),
        (2, 1, Path("a", "k", 1)): Fraction(1),
        (3, 2, Path("a", "a", 2)): Fraction(1),
    }
    branches = {}
    for s in (0, 1):
        for r in (0, 1):
            previous = 2 + s
            for t in range(1, n + 1):
                index = len(generators)
                generators.append(Generator("b", -2 - s + t, 3 + 2 * s - 2 * t))
                path = Path("a", "b", 1, r) if t == 1 else Path("b", "b", 2)
                differential[previous, index, path] = Fraction(1)
                branches[s, r, t] = index
                previous = index
    result = Complex(algebra, generators, differential)
    result.validate(minimal=True)
    return result, branches


def compare_sharp_model(actual, n):
    model, branches = sharp_model(actual.algebra, n)
    placement = {
        (g.vertex, g.cochain, g.internal): index
        for index, g in enumerate(actual.generators) if g.vertex != "b"
    }
    correspondence = {
        i: placement[g.vertex, g.cochain, g.internal]
        for i, g in enumerate(model.generators) if g.vertex != "b"
    }
    scales = {i: Fraction(1) for i in correspondence}
    for s in (0, 1):
        for r in (0, 1):
            previous = 2 + s
            for t in range(1, n + 1):
                index = branches[s, r, t]
                path = Path("a", "b", 1, r) if t == 1 else Path("b", "b", 2)
                candidates = [
                    (b, c) for (a, b, p), c in actual.differential.items()
                    if a == correspondence[previous] and p == path
                ]
                require(len(candidates) == 1, "Sharp-family string does not have the certified shape")
                target, coefficient = candidates[0]
                require(actual.generators[target] == model.generators[index], "Wrong sharp-family placement")
                correspondence[index] = target
                scales[index] = scales[previous] * coefficient
                previous = index
    require(
        len(correspondence) == len(actual.generators) == 4 + 4 * n
        and len(set(correspondence.values())) == len(correspondence),
        "Sharp-family basis identification is not bijective",
    )
    transported = {
        (correspondence[a], correspondence[b], p): c * scales[b] / scales[a]
        for (a, b, p), c in model.differential.items()
    }
    require(transported == actual.differential, "Sharp-family chain isomorphism failed")


def verify_orbits(certificate):
    data = read_json(certificate["orbit_experiment"])
    S, X, I, J = (set(certificate["sharp_family"][key]) for key in ("S", "X", "I", "J"))
    require(S == {"a", "b", "k"} and X == I == {"a", "b"} and J == {"b"}, "Wrong sharpness diagram")
    Z = Zigzag(data["vertices"], data["edges"])
    require(set(Z.vertices) == S | {"f", "o"}, "Incorrect frame vertices")
    require(Z.edges.get(("a", "b")) == 2 and Z.edges.get(("a", "k")) == 1
            and Z.edges.get(("b", "k"), 0) == 0, "Incorrect operated Coxeter diagram")
    for vertex in S:
        require(Z.edges.get((vertex, "f"), 0) == (0 if vertex in X else 1), "Incorrect relative frame")
    for vertex in S | {"f"}:
        require(Z.edges.get((vertex, "o")) == 1, "Incorrect auxiliary frame")
    q = certificate["sharp_family"]["q"]
    require(q == data["q"] == 1 and data["I"] == ["a", "b"] and data["J"] == ["b"], "Wrong orbit scope")
    c = [Fraction(x) for x in data["c"]]
    require(c == [1, 1] and certificate["sharp_family"]["c"] == [1, 1], "Wrong null-vector certificate")
    C = [[2, -2], [-2, 2]]
    require(all(sum(a * b for a, b in zip(row, c)) == 0 for row in C), "Cartan vector is not null")
    base = Complex(Z, [Generator("f", 0, 0)])
    E = apply_word(base, data["word_in_action_order"], S)
    require(E.as_json() == data["complex"], "Supplied orbit complex is incorrect")
    boundary = {v for v in Z.vertices if v not in I and any(Z.edges.get((v, i), 0) for i in I)}
    require(boundary == {"k", "o"} and cap(E, I | boundary, q), "Exterior cap is invalid")
    counts = E.counts()
    require(counts.get((q, "a"), 0) == 1 and all(counts.get((q, v), 0) == 0 for v in boundary),
            "Prescribed exterior counts are incorrect")
    _, _, actual = hom_data(E, E)
    require(actual == {(0, 0): 1, (0, 2): 1}, "Actual transported self-Hom differs")
    require(cohomology_json(actual) == data["actual_Hom"], "Wrong supplied actual-Hom certificate")
    levels = {g.level for g in E.generators}
    pairs = {(item["source_level"], item["target_level"]) for item in data["linear_Hom"]}
    require(pairs == {(l, k) for l in levels for k in levels}
            and len(data["linear_Hom"]) == len(pairs), "Linear-Hom certificate omits a layer pair")
    for item in data["linear_Hom"]:
        l, k = item["source_level"], item["target_level"]
        _, _, h = hom_data(E.layer(l), E.layer(k), linear_only=True)
        require(cohomology_json(h) == item["cohomology"], "Wrong supplied linear-Hom certificate")
        require(not any(n + v == k - l + 1 for n, v in h), "Nonzero middle Hom")
    escape = E
    for vertex, sign in data["escape_word_in_action_order"]:
        require(vertex in J and sign == -1, "Escape is not a negative parabolic word")
        escape = escape.twist(vertex, sign)
        require(cap(escape, I | boundary, q), "Escape loses the cap")
    require(escape.as_json() == data["escape_complex"], "Incorrect supplied escape complex")
    require(escape.counts().get((q, "b"), 0) <= 1, "Escape is not a witness")
    inverse_checks = 0
    for vertex in Z.vertices:
        initial = Complex(Z, [Generator(vertex, 0, 0)])
        for color in S:
            for sign in (-1, 1):
                require(initial.twist(color, sign).twist(color, -sign).as_json() == initial.as_json(),
                        "A single-twist inverse test failed")
                inverse_checks += 1
    require(inverse_checks == data["inverse_checks"], "Wrong inverse-test count")
    family = certificate["sharp_family"]
    require(family["channels"] == 2 and family["longest_length"] == 1, "Wrong rank-one constants")
    require(family["b_level_one_count"] == {"n_zero": 0, "n_positive": 2}, "False sharp-family count")
    require(family["d_min_for_positive_n"] == ["sub", 1, "n"], "Wrong amplitude formula")
    initial = apply_word(base, family["base_word_in_action_order"], S)
    for n in family["sample_parameters"]:
        require(isinstance(n, int) and n >= 0, "Invalid sample parameter")
        sample = initial
        for _ in range(n):
            sample = sample.twist("b", -1)
        compare_sharp_model(sample, n)
        require(cap(sample, I | boundary, q), "Sharp family loses the cap")
        require(sample.counts().get((q, "b"), 0) == (2 if n else 0), "Wrong sharp-family top count")
        if n:
            require(min(g.level for g in sample.generators) == 1 - n, "Wrong sharp-family lower level")
            for r in range(n):
                for tested in (sample, sample.twist("b", -1)):
                    require(tested.counts().get((q, "b"), 0) > 1, "Sharp prefix is not good")
                sample = sample.twist("b", 1)
                require(cap(sample, I | boundary, q), "Sharp positive prefix loses the cap")
            require(sample.counts().get((q, "b"), 0) == 0, "Sharp family does not exit at its bound")
    origin = data["jacobian_matrix_origin"]
    M = E.layer(q, I)
    basis, matrices, _ = hom_data(M, E.layer(0), linear_only=True)
    key = origin["n"], origin["v"]
    for field, degree in (("domain_basis", key), ("codomain_basis", (key[0] + 1, key[1]))):
        require(origin[field] == [
            [a, b, p.source, p.target, p.length, p.channel] for a, b, p in basis[degree]
        ], "Hom-matrix basis labels are incorrect")
    return matrices[origin["n"], origin["v"]], inverse_checks, len(family["sample_parameters"])


def verify_jacobian(certificate, matrix_):
    info = certificate["jacobian"]
    require(info["adapter_exit_code"] == 0 and info["adapter_error"] is None and not info["timed_out"],
            "Adapter error or timeout is not evidence")
    contract = read_json(info["contract"])
    payload = read_json(info["payload"])
    result = read_json(info["typed_result"])
    operation = info["operation_id"]
    require(operation == contract["result"]["operation"]["operation_id"] == "matrix.rank.compute",
            "Uninspected or different operation")
    require(result["request"]["operation_id"] == operation and result["result"]["operation_id"] == operation,
            "Wrong executed operation")
    require(result["server"]["version"] == info["server_version"]
            and result["protocol_version"] == info["protocol_version"], "Adapter metadata mismatch")
    require(result["request"]["payload"] == payload, "Executed payload differs")
    output = result["result"]["output"]
    require(output["matrix"] == payload["matrix"], "Typed output is not source-bound")
    require(output["method"] == "EXACT_RATIONAL_ROW_REDUCTION", "Different rank method")
    entries = [
        [Fraction(int(x["num"]), int(x["den"])) for x in row]
        for row in payload["matrix"]["entries"]
    ]
    for row, encoded in zip(entries, payload["matrix"]["entries"]):
        require(all(str(value.numerator) == item["num"] and str(value.denominator) == item["den"]
                    for value, item in zip(row, encoded)), "Noncanonical typed rational")
    require(entries == matrix_, "Payload is not the claimed actual Hom differential")
    computed = rank(entries)
    require(computed == output["rank"] == info["rank"], "False exact rank")
    pivots = output["pivot_columns"]
    require(len(pivots) == computed and len(set(pivots)) == computed, "Invalid pivot certificate")
    require(all(0 <= p < len(entries[0]) for p in pivots), "Pivot is out of bounds")
    return computed


def verify(certificate, replay=False):
    require(certificate["schema_version"] == 1, "Unknown certificate schema")
    require(certificate["claim_id"] == "N_BOUNDED_NULL"
            and certificate["sharpness_claim_id"] == "N_SHARP_NULL", "Wrong mathematical target")
    require(certificate["positive_budget"] == ["mul", "N", "L"]
            and certificate["negative_budget"] == "L", "Relabelled witness bound")
    identities = verify_homotopy(certificate)
    polynomials = verify_polynomials(certificate)
    matrix_, inverses, samples = verify_orbits(certificate)
    exact_rank = verify_jacobian(certificate, matrix_)
    declarations = verify_kernel(certificate, replay)
    for citation in certificate["literature"]:
        require(local_path(citation["excerpt"]).is_file(), "Missing cited proposition excerpt")
    return {
        "status": "verified",
        "universal_chain_homotopy_identities": identities,
        "rational_polynomial_certificates": polynomials,
        "kernel_declarations": declarations,
        "lean_replayed": replay,
        "inverse_checks": inverses,
        "finite_sharp_family_samples": samples,
        "jacobian_exact_rank": exact_rank,
        "scope": "Uniform algebraic construction and bounded-induction core; full categorical theorem proved in prose.",
        "independent_review": "required; not supplied by this script",
    }


def mutation_tests(certificate):
    mutations = []
    bad = copy.deepcopy(certificate)
    bad["universal_homotopy"]["matrices"]["i"][1][1] = "-k"
    mutations.append(("wrong chain-map sign", bad))
    bad = copy.deepcopy(certificate)
    bad["universal_homotopy"]["relations"].append(["1", "0"])
    mutations.append(("assumed target relation", bad))
    bad = copy.deepcopy(certificate)
    bad["equality_certificates"][0]["equations"]["old_zero"] = "top"
    mutations.append(("assumed top-zero conclusion", bad))
    bad = copy.deepcopy(certificate)
    bad["equality_certificates"][0]["combination"][1][0] = "1/2"
    mutations.append(("wrong top-zero multiplier", bad))
    bad = copy.deepcopy(certificate)
    bad["sharp_family"]["c"] = [2, 2]
    mutations.append(("wrong exterior null scale", bad))
    bad = copy.deepcopy(certificate)
    bad["jacobian"]["rank"] = 4
    mutations.append(("false rank", bad))
    bad = copy.deepcopy(certificate)
    bad["positive_budget"] = ["sub", ["mul", "N", "L"], 1]
    mutations.append(("stronger unproved bound", bad))
    for name, bad in mutations:
        try:
            verify(bad)
        except VerificationError:
            continue
        raise VerificationError(f"Verifier accepted corruption: {name}")
    return len(mutations)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", default="exact_certificate.json")
    parser.add_argument("--self-test", action="store_true")
    parser.add_argument("--replay-lean", action="store_true",
                        help="Run the real official compiler and both campaign-local ledger checks again")
    args = parser.parse_args()
    try:
        certificate = read_json(args.certificate)
        result = verify(certificate, args.replay_lean)
        if args.self_test:
            result["rejected_corruptions"] = mutation_tests(certificate)
    except VerificationError as error:
        print(json.dumps({"status": "failed", "error": str(error)}))
        return 1
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
