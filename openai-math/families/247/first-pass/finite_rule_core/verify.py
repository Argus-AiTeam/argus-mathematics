#!/usr/bin/env python3
"""Replay the exact truncated-boundary-cursor certificate, without dependencies."""

import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = (
    "research/openai_manuscript/"
    "An-infinite-finitely-presented-periodic-group-September-23-2026/"
    "build/sections/finite-rules.tex"
)

SOURCE_PASSAGES = {
    "missing_structural_neighbors": (
        "Missing neighbors at the ends of the whole\n"
        "word impose no structural test."
    ),
    "known_endpoints": (
        "For a nonidle letter define its \\emph{known first position} to mean\n"
        "$b=1$ and structural type $C(1)$, and its \\emph{known last position}\n"
        "to mean $b=l$ and structural type $S$."
    ),
    "truncated_transaction_neighbors": (
        "At the ends of the whole\n"
        "word an interface for which no neighbor is present is not checked;"
    ),
    "boundary_region_shape": (
        "a boundary-cursor region has the form $L^*B$\n"
        "and can stop at any acquired cell."
    ),
    "cursor_creation": (
        "An idle $C(1)$ can become a boundary cursor with $b=1$"
    ),
    "binary_acquisition": (
        "The old cursor becomes $L$, the next cell\n"
        "becomes the boundary cursor"
    ),
    "acquisition_exhaustive": (
        "Both moves have their inverse moves and there are no other\n"
        "acquisition or release moves."
    ),
    "full_conversion": (
        "At that position, and only there,\n"
        "its boundary cursor may become a full head"
    ),
    "full_head_fields": (
        "boundary cursor has no verifier control or reading bits."
    ),
    "semantic_zeros": (
        "A state $A_j$, $Z_j$,\n"
        "or success with $\\rho\\ne0$ is declared zero."
    ),
    "full_control_exhaustive": (
        "This convention completely lists the control transitions;\n"
        "there is no clock or phase stored on wing cells."
    ),
    "move_arities": "Each elementary move is a unary or two-letter replacement.",
    "no_long_entries": (
        "All strings of\n"
        "lengths $3,\\ldots,k$ have no elementary entries except in the\n"
        "provisional small-parameter convention below."
    ),
    "semantic_zeros_preserve_edges": (
        "A semantic zero declaration never\n"
        "removes an otherwise specified replacement edge."
    ),
    "literal_assertion": (
        "A boundary-cursor region can always be released inside\n"
        "its acquired interval."
    ),
}


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def matmul(a, b):
    return [
        [sum(a[i][k] * b[k][j] for k in range(2)) for j in range(2)]
        for i in range(2)
    ]


def possible_unary_sources(cell):
    """Source guards of all unary schemas, enlarged on full-head controls."""
    at_first = cell["structural_type"] == "C" and cell["p"] == 1
    at_stop = cell["structural_type"] == "S"
    marker = cell["marker"]
    return {
        "creation_forward": at_first and marker == "idle",
        "creation_reverse": at_first and marker == "B",
        "boundary_full_forward": at_stop and marker == "B",
        "boundary_full_reverse": at_stop and marker == "F",
        "reading_entry_turn_exit_both_directions": marker == "F",
        "gate_both_directions": marker == "F",
        "undo_entry_turn_exit_both_directions": marker == "F",
        "interclause_both_directions": marker == "F",
        "success_interface_both_directions": marker == "F",
        "committed_side_change": marker == "F",
    }


def check_witness_format(cell):
    """Check all fields of this family, under the displayed layout premises."""
    require(cell["structural_type"] == "C" and cell["p"] == 2, "wrong core")
    require(cell["marker"] == "B", "not a boundary cursor")
    require(cell["l"] == cell["b"] == 1, "wrong transaction metadata")
    require(cell["tau"] == "rep" and cell["epsilon"] == 0, "wrong task or side")
    require(cell["data_slots"] == [0, 0], "invalid data bits")
    require(cell["certificate_bit"] == 0, "invalid certificate bit")
    require(cell["verifier_phase"] is None, "boundary cursor carries a phase")
    require(cell["reading_registers"] is None, "boundary cursor carries registers")
    require(cell["checker"] == "I", "nonidle checker on a core")
    require(cell["unused_fields"] == 0, "nonzero unused fields")


def unary_zero_tests(cell):
    known_first = (
        cell["b"] == 1 and cell["structural_type"] == "C" and cell["p"] == 1
    )
    known_last = cell["b"] == cell["l"] and cell["structural_type"] == "S"
    return {
        "right_at_known_first": cell["marker"] == "R" and known_first,
        "left_at_known_last": cell["marker"] == "L" and known_last,
        "full_head_semantic_zero_possible": cell["marker"] == "F",
        "passed_color_zero_possible": cell["structural_type"] == "P",
    }


def check_jacobian(certificate):
    evidence = certificate["jacobian_evidence"]
    result = json.loads((ROOT / evidence["typed_result"]).read_text())
    payload = json.loads((ROOT / evidence["payload"]).read_text())
    require(evidence["adapter_exit_code"] == 0, "Jacobian adapter failed")
    require(evidence["structured_error"] is None, "Jacobian reported an error")
    require(evidence["timeout"] is False, "Jacobian timed out")
    require(result["server"]["version"] == evidence["server_version"], "server mismatch")
    require(
        result["protocol_version"] == evidence["protocol_version"],
        "protocol mismatch",
    )
    require(result["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(
        result["result"]["operation_id"] == evidence["operation_id"],
        "Jacobian operation mismatch",
    )
    output = result["result"]["output"]
    require(output["scope"] == "ALL_APPLICABLE_STEPS", "incomplete rewrite scope")
    require(output["applications"] == [], "an applicable unary projection was found")
    require(len(payload["rules"]) == 5, "unary projection partition changed")


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    source = (ROOT / SOURCE).read_text()
    require(certificate["source"] == SOURCE, "wrong manuscript")
    locations = {}
    for name, passage in SOURCE_PASSAGES.items():
        require(passage in source, f"source passage not found: {name}")
        locations[name] = source[: source.index(passage)].count("\n") + 1
    literal = " ".join(SOURCE_PASSAGES["literal_assertion"].split())
    require(literal == certificate["literal_assertion"], "assertion mismatch")
    require(locations["literal_assertion"] == 580, "assertion locator changed")
    require(certificate["source_lines"] == [580, 581], "wrong source lines")
    require(len(certificate["word"]) == 1, "witness is not a singleton")
    cell = certificate["word"][0]
    check_witness_format(cell)

    source_tests = possible_unary_sources(cell)
    require(
        set(source_tests) == set(certificate["unary_source_partition"]),
        "unary schema partition mismatch",
    )
    require(not any(source_tests.values()), "a unary replacement is applicable")
    zeros = unary_zero_tests(cell)
    require(not any(zeros.values()), "a unary semantic zero is applicable")
    require(1 < cell["p"], "the known first position is present")
    require(cell["marker"] != "idle", "the word is already released")

    matrix_certificate = certificate["nonzero_certificate"]
    n = matrix_certificate["chosen_letter_image"]
    z = matrix_certificate["all_other_letter_images"]
    require(n == [[0, 1], [0, 0]], "wrong matrix witness")
    require(z == [[0, 0], [0, 0]], "wrong other-letter image")
    require(n != z, "chosen image is zero")
    for a in (n, z):
        for b in (n, z):
            require(matmul(a, b) == z, "a degree-two relation may fail")
    require(matmul(n, n) == matrix_certificate["square_of_chosen_image"], "bad square")
    require(
        matrix_certificate["unary_relations_incident_on_chosen_letter"] == [],
        "unary relation would invalidate the representation",
    )
    require(certificate["campaign_complete"] is False, "scope erratum is not completion")
    require(certificate["significance_status"] == "scope_erratum", "overstated result")
    check_jacobian(certificate)

    print(
        json.dumps(
            {
                "status": "verified",
                "claim_id": certificate["claim_id"],
                "result_class": certificate["result_class"],
                "parameter_scope": (
                    "every legal sufficiently large h with 10000*D*h <= 2^h "
                    "and 2^h >= 3; not a finite parameter search"
                ),
                "elementary_replacement_successors": [],
                "unary_source_tests": source_tests,
                "unary_zero_tests": zeros,
                "matrix_certificate": "nonzero over every field; all degree >= 2 images vanish",
                "jacobian": "typed unary-projection matching succeeded with no applications",
                "source_locations": locations,
                "limitation": (
                    "Refutes only the unqualified truncated-boundary reading; "
                    "the complete-region interpretation and the two target lemmas "
                    "are not refuted."
                ),
                "independent_review": "pending",
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
