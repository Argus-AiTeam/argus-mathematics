#!/usr/bin/env python3
"""Replay exact algebra and source bindings; do not certify the sheaf proof."""

import argparse
import json
import re
from collections import Counter
from itertools import product
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = ROOT / (
    "research/openai_manuscript/"
    "The-Hilbert-Smith-conjecture-in-every-finite-dimension-September-23-2026/"
    "build/sections"
)
OPERATION = "matrix.symbolic.rank.compute"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def source_bindings():
    specifications = [
        ("02-categories.tex", "def:test-categories", [
            "smallest full replete triangulated subcategory",
            "any continuous map", "direct summands", "arbitrary open subset",
        ]),
        ("03-localization.tex", "lem:cutoff", [
            r"K\subset O\subset X", "closed in $X$", "$O$ is open",
            r"A\in\Bzero(X)", "some open neighborhood of $K$",
        ]),
        ("03-localization.tex", "thm:germs", [
            r"\Hom_{\Bcat(X)/\Bcat(U)}(A,B)",
            r"\Hom_{\mathsf D(N)}",
            r"for every $A,B\in\Bcat(X)$", "Verdier quotient itself",
        ]),
        ("03-localization.tex", "prop:open-cover", [
            r"X=U\cup V", "fully faithful exact functor preserving duality",
            "actual summand", r"\Pcat\to\T",
        ]),
        ("04-lattice.tex", "thm:bounded-comparison", [
            r"For every $j\ge0$", "independent of $r$",
            "every integer $r$",
        ]),
    ]
    pattern = re.compile(
        r"\\begin\{(definition|lemma|theorem|proposition)\}"
        r"(?:\[[^\]]*\])?.*?\\end\{\1\}", re.DOTALL
    )
    texts = {
        filename: (SOURCE / filename).read_text(encoding="utf-8")
        for filename, _, _ in specifications
    }
    bindings = []
    for filename, label, markers in specifications:
        blocks = [
            match.group() for match in pattern.finditer(texts[filename])
            if "\\label{" + label + "}" in match.group()
        ]
        require(len(blocks) == 1, f"Expected exactly one statement {label}")
        literal = re.sub(r"\s+", " ", blocks[0]).strip()
        for marker in markers:
            require(marker in literal, f"Missing hypothesis/clause {label}: {marker}")
        bindings.append({
            "path": str((SOURCE / filename).relative_to(ROOT)),
            "label": label,
            "literal_latex": literal,
        })
    require(
        "Neither restricted object is required to belong to" in re.sub(
            r"\s+", " ", texts["03-localization.tex"]
        ),
        "Ambient-category restriction warning changed",
    )
    return bindings


ARROWS = {
    "f": ("A0", "B0"), "g": ("A1", "B1"),
    "iA": ("A0", "A1"), "iB": ("B0", "B1"),
    "dA": ("A1", "A0"), "dB": ("B1", "B0"),
    "t": ("B0", "A0"),
    "idA1": ("A1", "A1"), "idB1": ("B1", "B1"),
}


def polynomial(*terms):
    result = Counter()
    endpoint = None
    for coefficient, degree, path in terms:
        require(degree >= 0 and path, "Invalid integral path monomial")
        for left, right in zip(path, path[1:]):
            require(ARROWS[left][0] == ARROWS[right][1], "Noncomposable arrows")
        current = (ARROWS[path[-1]][0], ARROWS[path[0]][1])
        if endpoint is None:
            endpoint = current
        require(current == endpoint, "Cannot add paths with different endpoints")
        result[(degree, path)] += coefficient
    return Counter({key: value for key, value in result.items() if value})


def encode_polynomial(value):
    return [
        {"coefficient": coefficient, "q_degree": degree, "path": list(path)}
        for (degree, path), coefficient in sorted(value.items())
    ]


def integral_identities():
    certificates = []
    specifications = [
        ("gT", ("g", "iA", "t", "dB"),
         ("iB", "f", "t", "dB"), ("iB", "dB"), "idB1"),
        ("Tg", ("iA", "t", "dB", "g"),
         ("iA", "t", "f", "dA"), ("iA", "dA"), "idA1"),
    ]
    for name, first, second, third, identity in specifications:
        relations = [
            polynomial((1, 0, first), (-1, 0, second)),
            polynomial((1, 0, second), (-1, 1, third)),
            polynomial((1, 0, third), (-2, 0, (identity,))),
        ]
        target = polynomial((1, 0, first), (-2, 1, (identity,)))
        combination = Counter()
        for relation, shift in zip(relations, (0, 0, 1)):
            for (degree, path), coefficient in relation.items():
                combination[(degree + shift, path)] += coefficient
        combination = Counter({
            key: value for key, value in combination.items() if value
        })
        require(combination == target, f"Integral syzygy failed: {name}")
        certificates.append({
            "identity": name,
            "coefficient_ring": "Z[q]",
            "relations": [encode_polynomial(relation) for relation in relations],
            "combination_q_powers": [0, 0, 1],
            "target": encode_polynomial(target),
        })
    return certificates


def finite_torsion_checks():
    results = []
    for modulus in (1, 2, 3, 4, 8):
        doubles = [
            (i, d) for i, d in product(range(modulus), repeat=2)
            if (i * d - 2) % modulus == 0
        ]
        count = 0
        for (iA, dA), (iB, dB) in product(doubles, repeat=2):
            for f, g in product(range(modulus), repeat=2):
                if (g * iA - iB * f) % modulus:
                    continue
                if (dB * g - f * dA) % modulus:
                    continue
                for t in range(modulus):
                    q = f * t % modulus
                    transfer = iA * t * dB % modulus
                    require((g * transfer - 2 * q) % modulus == 0,
                            "Forward transfer failed on a cyclic group")
                    require((transfer * g - 2 * q) % modulus == 0,
                            "Reverse transfer failed on a cyclic group")
                    count += 1
        require(count > 0, "Empty finite test family")
        results.append({"cyclic_group_order": modulus, "admissible_maps": count})
    return {
        "classification": "finite experiment, not the proof of the universal theorem",
        "cases": results,
    }


def jacobian_evidence():
    payload = read_json(HERE / "jacobian_payload.json")
    descriptor = [
        [(1, 0), (0, 0), (0, 0), (1, 0)],
        [(-1, 0), (1, 0), (0, 0), (0, 0)],
        [(0, 0), (-1, 1), (1, 0), (0, 0)],
        [(0, 0), (0, 0), (-2, 0), (-2, 1)],
    ]
    unit = {"terms": [{"coefficient": {"num": "1", "den": "1"}, "exponents": [0]}]}
    entries = [
        [
            {
                "variables": ["q"],
                "numerator": {"terms": [
                    {"coefficient": {"num": str(coefficient), "den": "1"},
                     "exponents": [degree]}
                ] if coefficient else []},
                "denominator": unit,
            }
            for coefficient, degree in row
        ]
        for row in descriptor
    ]
    require(payload == {"matrix": {"variables": ["q"], "entries": entries}},
            "Typed Jacobian payload does not encode the syzygy matrix")
    for row in range(3):
        require(descriptor[row][row] == (1, 0), "Unit minor diagonal changed")
        for column in range(row + 1, 3):
            require(descriptor[row][column][0] == 0, "Unit minor is not triangular")
    raw = read_json(HERE / "jacobian_output.json")
    status = read_json(HERE / "jacobian_status.json")
    require(status["adapter_exit_code"] == 0 and status["timed_out"] is False,
            "Jacobian adapter did not complete successfully")
    require(raw["schema_version"] == 1 and raw["tool"] == "math.run",
            "Unexpected Jacobian envelope")
    require(raw["protocol_version"] == "2025-11-25", "Protocol changed")
    require(raw["server"]["name"] == "jacobian", "Unexpected sidecar server")
    require(raw["server"]["version"] == "0.14.0", "Server version changed")
    require(raw["transport"] == "mcp-stdio", "Unexpected adapter transport")
    require(raw["request"] == {"operation_id": OPERATION, "payload": payload},
            "Jacobian response is not bound to the exact payload")
    require(raw["result"]["operation_id"] == OPERATION, "Operation changed")
    expected = {
        "method": "EXACT_SYMBOLIC_ROW_REDUCTION",
        "pivot_columns": [0, 1, 2], "rank": 3,
    }
    require(raw["result"]["output"] == expected, "No exact symbolic-rank answer")
    return {
        "operation_id": OPERATION,
        "server_version": raw["server"]["version"],
        "protocol_version": raw["protocol_version"],
        "payload_file": "jacobian_payload.json",
        "output_file": "jacobian_output.json",
        "adapter_status": status,
        "typed_output": expected,
        "unit_minor_determinant": 1,
        "interpretation": "Supplementary rank over Q(q); integral proof uses Z[q] syzygies and Lean.",
    }


def lean_evidence():
    output = read_json(HERE / "lean_verify_output.json")
    canonical = read_json(HERE / "lean_check.json")
    require({key: value for key, value in output.items() if key != "kernel"} == canonical,
            "Captured Lean run differs from the canonical compiler result")
    require(canonical["status"] == "success" and canonical["exit_code"] == 0,
            "Lean compilation did not succeed")
    require(canonical["proof_holes"] == [] and canonical["audit_exit_code"] == 0,
            "Lean proof has holes or its axiom audit failed")
    version = canonical["tools"]["lean"]["version"]
    require(version.startswith("Lean (version 4.31.0,"), "Wrong Lean version")
    require(Path(canonical["source"]) == HERE / "Main.lean", "Wrong compiled source")
    record = output["kernel"]["recorded"]
    require(record["tier"] == "mechanical" and record["verdict"] == "supports",
            "No kernel support was recorded")
    require(record["subject"]["subject_id"] == "C304_TRANSFER",
            "Kernel evidence attached to a different claim")
    archive_path = ROOT / record["artifact"]
    require(archive_path.parent == HERE / "certificates", "Certificate outside owned paths")
    archive = read_json(archive_path)
    require(archive["lean_check"] == canonical, "Archived compiler answer changed")
    require(archive["lean_source"]["text"] == (HERE / "Main.lean").read_text(encoding="utf-8"),
            "Lean source changed after compilation")
    require(archive["statement_fidelity"]["text"] ==
            (HERE / "statement_fidelity.md").read_text(encoding="utf-8"),
            "Statement-fidelity document changed after compilation")
    return {
        "claim": "C304_TRANSFER",
        "version": version,
        "exit_code": 0,
        "proof_holes": [],
        "axiom_audit_exit_code": 0,
        "archive": record["artifact"],
        "scope": "Universal abelian-group transfer and all-dimensional tower, not sheaf excision.",
    }


def build_certificate():
    return {
        "schema_version": 1,
        "result": "Prose verification of the three localization statements; conditional exponent e_j=j.",
        "mechanically_verified_claim": "C304_TRANSFER",
        "not_mechanically_verified": [
            "Sheaf-theoretic cutoff, support, germ, and dense-excision arguments",
            "Witt-group realization of the abstract doubling tower",
            "Homotopy invariance, generic signatures, character classes, and Hilbert-Smith",
        ],
        "external_inputs": {
            "sheaves": "Exact derived open adjunction and standard proper Verdier formalism",
            "witt": "Natural integral localization, point and homotopy inputs, dense doubling",
            "source_reading": "sources/primary_excerpts.md; ledger citations remain prose/uncited",
        },
        "novelty": "Not established; Host-invoked independent Reviewer judgment is pending.",
        "source_bindings": source_bindings(),
        "integral_syzygies": integral_identities(),
        "finite_experiments": finite_torsion_checks(),
        "jacobian": jacobian_evidence(),
        "lean": lean_evidence(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true",
                        help="Write exact_certificate.json after all checks succeed")
    arguments = parser.parse_args()
    expected = build_certificate()
    path = HERE / "exact_certificate.json"
    if arguments.write_certificate:
        path.write_text(json.dumps(expected, indent=2) + "\n", encoding="utf-8")
    else:
        require(read_json(path) == expected, "Persistent exact certificate does not replay")
    print(json.dumps({
        "status": "verified",
        "source_statements": len(expected["source_bindings"]),
        "integral_syzygies": len(expected["integral_syzygies"]),
        "finite_torsion_cases": sum(
            item["admissible_maps"] for item in expected["finite_experiments"]["cases"]
        ),
        "lean_claim": expected["lean"]["claim"],
        "lean_exit_code": 0,
        "proof_holes": [],
        "sheaf_proof": "prose, independent review pending",
    }))


if __name__ == "__main__":
    main()
