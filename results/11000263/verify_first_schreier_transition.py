#!/usr/bin/env python3
"""Test the first factorial Schreier transition in the exact local algebra."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import subprocess
import tempfile
from pathlib import Path

from sage.all import FreeAlgebra, PolynomialRing, QQ, matrix, sage_eval, vector


HERE = Path(__file__).resolve().parent
CAMPAIGN = HERE.parents[1]
LOCAL_SOURCE = (
    CAMPAIGN
    / "research/kernel_ideal/peirce_defect/verify_peirce_membership.py"
)
LOCAL_CERTIFICATE = (
    CAMPAIGN
    / "research/kernel_ideal/peirce_defect/peirce-first-defect-membership.json"
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def load_module(path: Path):
    spec = importlib.util.spec_from_file_location("peirce_local_source", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def run_singular(program: str) -> str:
    environment = os.environ.copy()
    environment.pop("SINGULAR_BIN_DIR", None)
    with tempfile.TemporaryDirectory(prefix="schreier-local-", dir=HERE) as temp:
        source = Path(temp) / "replay.sing"
        source.write_text(program, encoding="utf-8")
        completed = subprocess.run(
            ["/usr/bin/Singular", "-q", str(source)],
            check=True,
            capture_output=True,
            text=True,
            timeout=120,
            env=environment,
        )
    if completed.stderr:
        raise AssertionError(
            f"Singular stderr was not empty: {completed.stderr}"
        )
    errors = [
        line
        for line in completed.stdout.splitlines()
        if line.lstrip().startswith("?")
        or "for a different version of Singular" in line
    ]
    if errors:
        raise AssertionError(
            "Singular interpreter errors: " + " / ".join(errors[:5])
        )
    return completed.stdout


def parse_records(stdout: str):
    records = {}
    for line in stdout.splitlines():
        if not line.startswith("NF|"):
            continue
        _, name, value = line.split("|", 2)
        records[name] = value
    return records


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=HERE / "first-schreier-transition-certificate.json",
    )
    args = parser.parse_args()
    output = args.output.resolve()
    if output.parent != HERE:
        raise SystemExit("output must stay in the mission directory")

    local = json.loads(LOCAL_CERTIFICATE.read_text(encoding="utf-8"))
    local_presentation = local["local_presentation"]
    if (
        local["status"] != "passed"
        or local_presentation["groebner_basis_size"] != 20
        or local_presentation["normal_basis_dimension"] != 61
        or not local_presentation["all_composition_remainders_zero"]
    ):
        raise AssertionError("reviewed local completion changed")

    source = load_module(LOCAL_SOURCE)
    names = ("e", "ze", "we", "wze", "zwe", "zwze")
    expressions = (
        "e",
        "z*e",
        "w*e",
        "w*z*e",
        "z*w*e",
        "z*w*z*e",
    )
    lines = [source.BASE_PROGRAM]
    for name, expression in zip(names, expressions):
        lines.append(
            f'print("NF|{name}|"+string(reduce({expression},G)));'
        )
    lines.extend(
        [
            "poly P_w=w*w+(q-1)*w-q;",
            "poly target=P_w*(z*e-e);",
            'print("NF|target|"+string(reduce(target,G)));',
            "quit;",
            "",
        ]
    )
    normal_forms = parse_records(run_singular("\n".join(lines)))
    if set(normal_forms) != {*names, "target"}:
        raise AssertionError("missing local normal-form record")

    polynomial_ring = PolynomialRing(QQ, "q")
    field = polynomial_ring.fraction_field()
    free = FreeAlgebra(field, 3, names=("e", "z", "w"))
    e, z, w = free.gens()
    parsed = {
        name: sage_eval(
            expression.replace("^", "**"),
            locals={"q": field(polynomial_ring.gen()), "e": e, "z": z, "w": w},
        )
        for name, expression in normal_forms.items()
    }
    monomials = sorted(
        {
            monomial
            for polynomial in parsed.values()
            for monomial in polynomial.monomial_coefficients()
        },
        key=str,
    )

    def coordinates(polynomial):
        coefficients = polynomial.monomial_coefficients()
        return vector(field, [coefficients.get(word, 0) for word in monomials])

    candidate_columns = [coordinates(parsed[name]) for name in names]
    target_column = coordinates(parsed["target"])
    candidate_matrix = matrix(
        field, [list(column) for column in candidate_columns]
    ).transpose()
    augmented = candidate_matrix.augment(
        matrix(field, [list(target_column)]).transpose()
    )
    candidate_rank = candidate_matrix.rank()
    augmented_rank = augmented.rank()
    if augmented_rank != candidate_rank + 1:
        raise AssertionError("the local target was not separated as expected")

    separator = None
    for functional in candidate_matrix.transpose().right_kernel().basis():
        value = functional.dot_product(target_column)
        if value:
            separator = functional / value
            break
    if separator is None:
        raise AssertionError("failed to extract an exact local separator")
    separator_terms = [
        {
            "normal_word": str(monomial),
            "coefficient": str(coefficient.factor()),
        }
        for monomial, coefficient in zip(monomials, separator)
        if coefficient
    ]
    if separator.dot_product(target_column) != 1:
        raise AssertionError("separator normalization failed")
    if any(
        separator.dot_product(column) for column in candidate_columns
    ):
        raise AssertionError("separator does not annihilate candidate span")

    payload = {
        "schema": "first-factorial-schreier-transition-v1",
        "status": "passed",
        "coefficient_field": "Q(q)",
        "setting": {
            "generators": "z=sigma_3, w=sigma_4",
            "idempotent": "e=((q-1)^2*(q+1))^-1*X3",
            "quadratic_polynomial": "P(T)=(T-1)*(T+q)",
            "target": "P(w)*(z*e-e)",
            "why_required": (
                "It is the first non-Coxeter diagonal transition in the "
                "forward factorial Schreier family at n=5."
            ),
        },
        "local_completion": {
            "ambient": (
                "the complete 61-dimensional algebra on e,z,w generated by "
                "eight universal local consequences"
            ),
            "source_relations": local_presentation["source_relations"],
            "groebner_basis_size": 20,
            "normal_basis_dimension": 61,
            "overlap_compositions": local_presentation[
                "overlap_compositions"
            ],
            "inclusion_compositions": local_presentation[
                "inclusion_compositions"
            ],
            "all_composition_remainders_zero": True,
        },
        "candidate_local_schreier_states": list(names),
        "normal_forms": normal_forms,
        "candidate_span_rank": candidate_rank,
        "augmented_rank": augmented_rank,
        "separator": {
            "normalization": "lambda(target)=1",
            "annihilates_every_candidate": True,
            "terms": separator_terms,
        },
        "conclusion": {
            "proved": (
                "The first required target is not reducible using only the "
                "complete e,z,w local relation system and the six local "
                "Schreier states."
            ),
            "not_proved": (
                "This does not show nonmembership in the full Q5 Schreier "
                "span: relations involving sigma_1 and sigma_2 may create an "
                "additional syzygy. It therefore does not refute the "
                "factorial recursion."
            ),
            "next_exact_obligation": (
                "Decide P(sigma_4)*(sigma_3*e-e) in the full 40-state Q5 "
                "Schreier span using original defining relations over Q(q)."
            ),
        },
        "inputs": {
            "local_source": str(LOCAL_SOURCE.relative_to(CAMPAIGN)),
            "local_source_sha256": sha256(LOCAL_SOURCE),
            "local_certificate": str(
                LOCAL_CERTIFICATE.relative_to(CAMPAIGN)
            ),
            "local_certificate_sha256": sha256(LOCAL_CERTIFICATE),
        },
    }
    output.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    print(
        json.dumps(
            {
                "status": "passed",
                "candidate_rank": candidate_rank,
                "augmented_rank": augmented_rank,
                "separator_terms": len(separator_terms),
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
