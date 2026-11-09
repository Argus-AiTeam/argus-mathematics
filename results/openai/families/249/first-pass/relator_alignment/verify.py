#!/usr/bin/env python3
"""Replay exact noncommutative word identities and check the Lean certificate."""

from __future__ import annotations

import hashlib
import json
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
Word = tuple[int, ...]
Vector = dict[tuple[int, Word], int]
Term = tuple[Word, int, int]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def reduce_word(letters) -> Word:
    stack: list[int] = []
    for letter in letters:
        require(letter != 0, "Zero is not a free-group letter")
        if stack and stack[-1] == -letter:
            stack.pop()
        else:
            stack.append(letter)
    return tuple(stack)


def multiply(*words: Word) -> Word:
    return reduce_word(letter for word in words for letter in word)


def inverse(word: Word) -> Word:
    return tuple(-letter for letter in reversed(word))


def power(word: Word, exponent: int) -> Word:
    base = word if exponent >= 0 else inverse(word)
    return multiply(*(base for _ in range(abs(exponent))))


def conjugate(by: Word, word: Word) -> Word:
    return multiply(by, word, inverse(by))


def evaluate(word: Word) -> Word:
    return reduce_word(letter for letter in word if abs(letter) <= 2)


def clean(vector) -> Vector:
    return {key: value for key, value in vector.items() if value}


def add(*vectors: Vector) -> Vector:
    out: Counter = Counter()
    for vector in vectors:
        out.update(vector)
    return clean(out)


def negate(vector: Vector) -> Vector:
    return {key: -value for key, value in vector.items()}


def translate(g: Word, vector: Vector, coefficient: int = 1) -> Vector:
    out: Counter = Counter()
    for (index, h), n in vector.items():
        out[index, multiply(g, h)] += coefficient * n
    return clean(out)


def unit(index: int) -> Vector:
    return {(index, ()): 1}


def linear_apply(columns: list[Vector], vector: Vector) -> Vector:
    return add(*(translate(g, columns[index], n) for (index, g), n in vector.items()))


def graph_chain(word: Word) -> Vector:
    prefix: Word = ()
    out: Counter = Counter()
    for letter in word:
        step = (letter,) if abs(letter) <= 2 else ()
        if letter > 0:
            out[letter, prefix] += 1
            prefix = multiply(prefix, step)
        else:
            prefix = multiply(prefix, step)
            out[-letter, prefix] -= 1
    require(prefix == evaluate(word), "The path endpoint disagrees with evaluation")
    return clean(out)


def cycle_coordinates(word: Word) -> Vector:
    chain = graph_chain(word)
    require(evaluate(word) == (), "A relator has nontrivial group value")
    require(all(index >= 3 for index, _ in chain), "Unexpected a/b cycle edge")
    return {(index - 3, g): n for (index, g), n in chain.items()}


def evaluate_terms(words: list[Word], terms: list[Term]) -> Word:
    return multiply(*(conjugate(g, power(words[j], n)) for g, j, n in terms))


def inverse_terms(terms: list[Term]) -> list[Term]:
    return [(g, j, -n) for g, j, n in reversed(terms)]


def translate_terms(g: Word, terms: list[Term]) -> list[Term]:
    return [(multiply(g, h), j, n) for h, j, n in terms]


def substitute(terms: list[Term], replacements: list[list[Term]]) -> list[Term]:
    out: list[Term] = []
    for g, j, exponent in terms:
        base = replacements[j] if exponent >= 0 else inverse_terms(replacements[j])
        for _ in range(abs(exponent)):
            out.extend(translate_terms(g, base))
    return out


def translated_counts(terms: list[Term]) -> Vector:
    out: Counter = Counter()
    for g, j, n in terms:
        out[j, evaluate(g)] += n
    return clean(out)


def serialize_vector(vector: Vector) -> list[dict]:
    return [
        {"index": index, "translate": list(g), "coefficient": n}
        for (index, g), n in sorted(vector.items())
    ]


def serialize_terms(terms: list[Term]) -> list[dict]:
    return [
        {"conjugator": list(g), "index": j, "exponent": n}
        for g, j, n in terms
    ]


def exact_word_replay() -> dict:
    # a,b evaluate freely; d,t,u0,u1 are distinct identity-valued letters.
    a0 = multiply((3,), conjugate((2,), (4,)))
    a1 = multiply((4,), conjugate((1,), a0))
    words = [a0, a1, (5,), (6,)]
    columns = [cycle_coordinates(a0), cycle_coordinates(a1)]
    inverse_columns = [
        {(0, ()): 1, (0, (2, 1)): 1, (1, (2,)): -1},
        {(0, (1,)): -1, (1, ()): 1},
    ]
    require(multiply((1,), (2,)) != multiply((2,), (1,)), "The test group must be nonabelian")
    require(columns == [
        {(0, ()): 1, (1, (2,)): 1},
        {(1, ()): 1, (0, (1,)): 1, (1, (1, 2)): 1},
    ], "Initial columns do not have the stated noncommutative coefficients")
    for j in range(2):
        require(linear_apply(columns, inverse_columns[j]) == unit(j), "A A^-1 failed")
        require(linear_apply(inverse_columns, columns[j]) == unit(j), "A^-1 A failed")

    expression_t: list[Term] = [((), 1, 1), ((1,), 0, -1)]
    expression_d: list[Term] = [((), 0, 1)] + translate_terms(
        (2,), inverse_terms(expression_t)
    )
    expressions = [expression_d, expression_t]
    require(evaluate_terms(words, expressions[0]) == (3,), "Initial d expression failed")
    require(evaluate_terms(words, expressions[1]) == (4,), "Initial t expression failed")
    stages: list[dict] = []
    specifications = [
        ("P", [2, 3], [0, 1], inverse_columns),
        ("Q", [0, 1], [2, 3], [negate(column) for column in columns]),
        ("P", [2, 3], [0, 1], inverse_columns),
    ]
    for name, changed, fixed, corrections in specifications:
        old = words
        new = list(old)
        old_to_new: list[list[Term]] = [[((), j, 1)] for j in range(4)]
        new_to_old: list[list[Term]] = [[((), j, 1)] for j in range(4)]
        stage_terms: list[list[Term]] = []
        for j, vector in zip(changed, corrections, strict=True):
            terms = [(g, fixed[k], n) for (k, g), n in sorted(vector.items())]
            correction = evaluate_terms(old, terms)
            require(evaluate(correction) == (), "Correction is not a closed word")
            new[j] = multiply(old[j], correction)
            expected = add(
                cycle_coordinates(old[j]),
                linear_apply([cycle_coordinates(old[k]) for k in fixed], vector),
            )
            require(cycle_coordinates(new[j]) == expected, "Shear boundary realization failed")
            old_to_new[j] += inverse_terms(terms)
            new_to_old[j] += terms
            stage_terms.append(terms)
        for j in range(4):
            require(evaluate_terms(new, old_to_new[j]) == old[j],
                    "Old relator was not recovered in the new normal closure")
            require(evaluate_terms(old, new_to_old[j]) == new[j],
                    "New relator was not in the old normal closure")
        expressions = [substitute(expr, old_to_new) for expr in expressions]
        words = new
        require(evaluate_terms(words, expressions[0]) == (3,), "Transported d expression failed")
        require(evaluate_terms(words, expressions[1]) == (4,), "Transported t expression failed")
        stages.append({
            "shear": name,
            "changed_indices": changed,
            "fixed_indices": fixed,
            "corrections": [serialize_terms(terms) for terms in stage_terms],
            "word_lengths": [len(word) for word in words],
            "both_normal_closure_inclusions": True,
        })

    for j in range(2):
        shifted_negative = {(index + 2, g): -n for (index, g), n in columns[j].items()}
        require(cycle_coordinates(words[j]) == shifted_negative, "Final first block is not -A")
        require(cycle_coordinates(words[j + 2]) == unit(j), "Final second block is not the identity")
        require(translated_counts(expressions[j]) == unit(j + 2), "Exact translated count failed")

    for g in [(), (1,), (2, 1), (1, 2, -1)]:
        for j, relator in enumerate(words):
            for n in [-3, -1, 0, 1, 2]:
                conjugated = conjugate(g, power(relator, n))
                require(graph_chain(conjugated) == translate(g, graph_chain(relator), n),
                        "A translated signed path chain has the wrong sign or basepoint")
            null_terms = [(g, j, 1), (g, j, -1)]
            augmented = expressions[0] + null_terms
            require(evaluate_terms(words, augmented) == (3,), "Null expression changed the word")
            require(translated_counts(augmented) == unit(2), "Null expression changed exact counts")

    require(evaluate_terms(words, []) == (), "Empty word convention failed")
    require(translated_counts([]) == {}, "Empty count convention failed")
    # Ordinary order is (t-index of second block, then the original first block).
    projected = [
        {(index - 1, g): n for (index, g), n in cycle_coordinates(words[j]).items()
         if index != 0}
        for j in [3, 0, 1]
    ]
    expected_projection = [unit(0)] + [
        {(index + 1, g): -n for (index, g), n in column.items()}
        for column in columns
    ]
    require(projected == expected_projection, "Ordinary projection is not diag(1,-A)")
    return {
        "classification": "exact finite illustration; universality comes from Lean, not this example",
        "group": "The nonabelian free group F(a,b), not a commuting or finite-quotient surrogate",
        "alphabet": {"1": "a", "2": "b", "3": "d", "4": "t", "5": "u0", "6": "u1"},
        "initial_relators": [list(a0), list(a1), [5], [6]],
        "A_columns": [serialize_vector(column) for column in columns],
        "A_inverse_columns": [serialize_vector(column) for column in inverse_columns],
        "stages": stages,
        "final_relators": [list(word) for word in words],
        "d_normal_expression": serialize_terms(expressions[0]),
        "d_translated_count": serialize_vector(translated_counts(expressions[0])),
        "ordinary_projected_columns": [serialize_vector(column) for column in projected],
        "conjugation_power_checks": 80,
        "null_expression_checks": 16,
    }


def lean_binding() -> dict:
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result["status"] == "success", "Lean compiler did not report success")
    require(result["exit_code"] == 0, "Lean compiler exit status is not zero")
    require(result["proof_holes"] == [], "Lean compiler reported proof holes")
    require(result["audit_exit_code"] == 0, "Lean axiom audit did not pass")
    source = HERE / "Main.lean"
    fidelity = HERE / "statement_fidelity.md"
    require(Path(result["source"]).resolve() == source, "Certificate names a different source")
    require(result["source_sha256"] == hashlib.sha256(source.read_bytes()).hexdigest(),
            "Lean source changed after its compiler run")
    require(result["statement_fidelity_sha256"] ==
            hashlib.sha256(fidelity.read_text().encode()).hexdigest(),
            "Statement fidelity changed after the compiler run")
    require("sorryAx" not in result["audit_stdout"], "A theorem depends on sorryAx")
    require("4.31.0" in json.dumps(result["tools"]), "Compiler was not Lean 4.31.0")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max((claim for claim in state["claims"]
                 if claim["claim_id"] == "RELATOR_ALIGNMENT"), key=lambda c: c["version"])
    require(claim["formal_statement"].strip() == source.read_text().strip(),
            "Claim ledger does not carry the compiled formal statement")
    records = [record for record in state["evidence"]
               if record["subject"]["subject_id"] == "RELATOR_ALIGNMENT"
               and record["subject"]["content_hash"] == claim["content_hash"]
               and record["tier"] == "mechanical" and record["verdict"] == "supports"]
    require(bool(records), "No current mechanical evidence supports RELATOR_ALIGNMENT")
    for record in records:
        archived = json.loads((ROOT / record["artifact"]).read_text())
        require(archived["lean_check"]["source_sha256"] == result["source_sha256"],
                "Archived claim evidence describes another Lean source")
        require(archived["lean_check"]["statement_fidelity_sha256"] ==
                result["statement_fidelity_sha256"], "Archived fidelity does not match")
    return {
        "source": str(source.relative_to(ROOT)),
        "statement_fidelity": str(fidelity.relative_to(ROOT)),
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "audit_exit_code": result["audit_exit_code"],
        "claim_id": "RELATOR_ALIGNMENT",
        "claim_version": claim["version"],
        "mechanical_evidence": [record["artifact"] for record in records],
        "theorems": [
            "RelatorAlignment.presentation_alignment",
            "RelatorAlignment.finite_normal_expression",
            "RelatorAlignment.presentation_expression",
            "RelatorAlignment.exact_translated_counts",
        ],
    }


def jacobian_replay() -> dict:
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    result = json.loads((HERE / "jacobian_output.json").read_text())
    operation = "topology.simplicial.edge_path.word.compute"
    require(result["request"]["operation_id"] == operation, "Wrong Jacobian operation")
    require(result["request"]["payload"] == payload, "Jacobian payload was changed")
    require("error" not in result and "error" not in result["result"], "Jacobian reported an error")
    output = result["result"]["output"]
    require(output["word"] == ["e1", "e2", "e3", "e4", "e1^-1"], "Unexpected edge-path word")
    require(output["length"] == 5, "Unexpected edge-path word length")
    vertex = payload["start_vertex"]
    net: Counter = Counter()
    for step in payload["path"]:
        edge = step["edge_index"]
        sign = step["orientation"]
        start, end = payload["edges"][edge]
        if sign == -1:
            start, end = end, start
        require(vertex == start, "Jacobian input is not a composable edge path")
        vertex = end
        net[edge] += sign
    require(vertex == payload["start_vertex"], "The conjugated loop is not closed")
    require(clean(net) == {1: 1, 2: 1, 3: 1}, "Conjugating edge failed to cancel as a chain")
    return {
        "operation_id": operation,
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "adapter_status": "success",
        "structured_error": None,
        "scope": "One bounded path-word illustration, not evidence for the universal theorem",
        "payload_file": "research/relator_alignment/jacobian_payload.json",
        "typed_output_file": "research/relator_alignment/jacobian_output.json",
    }


def main() -> None:
    certificate = {
        "result_class": "exact_verification_theorem",
        "claim": "RELATOR_ALIGNMENT",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "scope": "Universal arbitrary-index finite-word P,Q,P alignment and exact translated counts",
        "novelty": "Independent formal certification; no claim of a new literature theorem",
        "independent_review": "required; not performed by this Engineer script",
        "campaign_complete": False,
        "main_eilenberg_ganea_theorem": "open",
        "lean": lean_binding(),
        "finite_noncommutative_replay": exact_word_replay(),
        "jacobian": jacobian_replay(),
        "unproved_interfaces": [
            "CW reduction and initial stabilization",
            "geometric model and small transport",
            "localized degree and uniform analytic estimate",
            "finite-quotient solvability and arbitrary-product compactness",
        ],
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "status": "verified",
        "claim": certificate["claim"],
        "lean_exit_code": certificate["lean"]["exit_code"],
        "proof_holes": certificate["lean"]["proof_holes"],
        "certificate": "research/relator_alignment/exact_certificate.json",
        "independent_review": "required",
        "main_theorem": "open",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
