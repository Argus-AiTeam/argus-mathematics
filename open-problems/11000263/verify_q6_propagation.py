#!/usr/bin/env python3
"""Verify the first exact Q6 propagation of the left Schreier defect."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import time
from pathlib import Path

from sage.all import FreeAlgebra, PolynomialRing, QQ, sage_eval


HERE = Path(__file__).resolve().parent
CAMPAIGN = HERE.parents[2]
SUPERVISOR = CAMPAIGN.parent.parent / "supervisor-evidence" / CAMPAIGN.name
SOURCE = HERE / "probe_q6_candidate_sparse.sing"
FIBERS = HERE / "q6-first-defect-fibers.json"
Q5_LEFT = HERE.parent / "q5_left_membership/q5-left-membership-certificate.json"
Q5_RIGHT = (
    HERE.parent / "q5_right_membership/q5-right-membership-certificate.json"
)
JACOBIAN_INSPECT = HERE / "jacobian-inspect-symbolic-linear-system.json"
JACOBIAN_PAYLOAD = HERE / "jacobian-payload-tail-inverse.json"
JACOBIAN_OUTPUT = HERE / "jacobian-output-tail-inverse.json"


def word_tuple(word) -> tuple[str, ...]:
    return tuple(str(letter) for letter in word.to_word())


def factor_string(value) -> str:
    numerator = value.numerator().factor()
    denominator = value.denominator().factor()
    if denominator == 1:
        return str(numerator)
    return f"({numerator})/({denominator})"


def parse_source(q):
    free = FreeAlgebra(q.parent(), 6, names=("a", "b", "c", "d", "t", "y"))
    a, b, c, d, t, y = free.gens()
    locals_map = dict(zip(("a", "b", "c", "d", "t", "y"), free.gens()))
    locals_map["q"] = q
    source = SOURCE.read_text(encoding="ascii")
    assignments = re.findall(
        r"poly\s+([A-Za-z_][A-Za-z0-9_]*)\s*=(.*?);",
        source,
        flags=re.DOTALL,
    )
    parsed = {}
    for name, expression in assignments:
        value = sage_eval(expression.replace("\n", " "), locals=locals_map)
        parsed[name] = value
        locals_map[name] = value

    Pc = c**2 + (q - 1) * c - q
    Pb = b**2 + (q - 1) * b - q
    Pd = d**2 + (q - 1) * d - q
    Pt = t**2 + (q - 1) * t - q
    expected = {
        "bab": a * b * a - b * a * b,
        "bbc": b * c * b - c * b * c,
        "cdc": c * d * c - d * c * d,
        "dtd": d * t * d - t * d * t,
        "ac": a * c - c * a,
        "ad": a * d - d * a,
        "at": a * t - t * a,
        "bd": b * d - d * b,
        "bt": b * t - t * b,
        "ct": c * t - t * c,
        "dy": d * y - y * d,
        "ty": t * y - y * t,
        "Pc": Pc,
        "Pb": Pb,
        "Pd": Pd,
        "Pt": Pt,
        "tail_d": Pd * y,
        "tail_t": Pt * y,
        "seed_b0": b * y + q**3 * y,
        "q5_left": (
            q * Pd * (c - 1) * y
            - (q - 1) * c * d * Pc * y
            - q * (1 - q) * (a + q) * b * c * d * b * c * y
        ),
    }
    rhs = (
        (1 - q) * d * t * c * y
        + (q - 1) ** 2 / q * d * t * d * c * y
        + (q - 1) / q * d * t * d**2 * c * y
        - (q - 1) / q * c * d * t * c * d * y
        + (q - 1) ** 2 / q**2 * c * d * t * c * d * c * y
        + (q - 1) / q**2 * c * d * t * c * d * c**2 * y
        + (1 - q) * b * c * d * t * c * d * b * c * y
        - (q - 1) / q * a * b * c * d * t * c * d * b * c * y
    )
    expected["rhs"] = rhs
    expected["target"] = Pt * d * (c - 1) * y - rhs
    crossing_rhs = (
        q**2 * (q - 1) * t * d * y
        - q * (q - 1) ** 2 * d * t * d * y
        - (q - 1) / q * a * b * c * d * t * c * d * y
        + (q - 1) / q * a * b * c * d * t * c * d * a * y
    )
    expected["crossing_rhs"] = crossing_rhs
    expected["crossing_target"] = (
        Pb * c * d * t * c * d * y - crossing_rhs
    )
    if parsed != expected:
        changed = sorted(
            name
            for name in set(parsed) | set(expected)
            if parsed.get(name) != expected.get(name)
        )
        raise AssertionError(f"the sparse proof source changed: {changed}")

    ideal_block = source.split("ideal I=", 1)[1].split(
        ";\nideal G=", 1
    )[0]
    actual_ideal = re.sub(r"\s+", "", ideal_block)
    expected_ideal = ",".join(
        (
            "bab",
            "bbc",
            "cdc",
            "dtd",
            "ac",
            "ad",
            "at",
            "bd",
            "bt",
            "ct",
            "dy",
            "ty",
            "tail_d",
            "tail_t",
            "q5_left",
        )
    )
    if actual_ideal != expected_ideal:
        raise AssertionError("the sparse proof ideal has an unexpected source row")

    defect_identity = Pt * d * t - d * t * Pd
    braid_combination = -t * expected["dtd"] - expected["dtd"] * d - (
        q - 1
    ) * expected["dtd"]
    if defect_identity != braid_combination:
        raise AssertionError("the adjacent braid-defect identity failed")
    return parsed


def check_prior_certificates():
    left = json.loads(Q5_LEFT.read_text(encoding="utf-8"))
    if (
        left["exact_two_sided_membership"]["target_normal_form"] != "0"
        or left["claim"]
        != "P(d)(c*e-e)=((q-1)/q)*c*d*P(c)*e+(1-q)*(a+q)*b*c*d*b*c*e"
    ):
        raise AssertionError("the exact Q5 left identity changed")

    right = json.loads(Q5_RIGHT.read_text(encoding="utf-8"))
    tail = next(
        record
        for record in right["diagonal_targets"]["targets"]
        if record["k"] == 4 and record["core_index"] == 0
    )
    if tail["target"] != "e*P(d)" or tail["coordinates"]:
        raise AssertionError("the exact tail quadratic relation changed")
    return {
        "q5_left_target_normal_form": "0",
        "q5_right_tail_target": tail["target"],
        "q5_right_tail_coordinate_count": 0,
    }


def check_fibers():
    fibers = json.loads(FIBERS.read_text(encoding="utf-8"))
    expected_words = [
        "dec*X3",
        "dedc*X3",
        "deddc*X3",
        "cdecd*X3",
        "cdecdc*X3",
        "cdecdcc*X3",
        "bcdecdbc*X3",
        "abcdecdbc*X3",
    ]
    if fibers["common_coordinate_support"] != expected_words:
        raise AssertionError("the finite-fiber support changed")
    field = QQ
    for sample in fibers["samples"]:
        q_value = field(sample["q"])
        expected = [
            1 - q_value,
            (q_value - 1) ** 2 / q_value,
            (q_value - 1) / q_value,
            -(q_value - 1) / q_value,
            (q_value - 1) ** 2 / q_value**2,
            (q_value - 1) / q_value**2,
            1 - q_value,
            -(q_value - 1) / q_value,
        ]
        residues = [
            (
                int(value.numerator())
                * pow(int(value.denominator()), -1, 101)
            )
            % 101
            for value in expected
        ]
        actual = [
            entry["coefficient_mod_101"] for entry in sample["coordinates"]
        ]
        if (
            actual != residues
            or sample["candidate_rank"] != 240
            or sample["augmented_rank"] != 240
        ):
            raise AssertionError(f"the q={sample['q']} discovery fiber changed")
    return {
        "field": fibers["coefficient_field"],
        "q_values": fibers["q_values"],
        "candidate_ranks": [
            sample["candidate_rank"] for sample in fibers["samples"]
        ],
        "augmented_ranks": [
            sample["augmented_rank"] for sample in fibers["samples"]
        ],
        "common_support_size": len(expected_words),
        "scope": fibers["scope"],
    }


def check_jacobian():
    inspected = json.loads(JACOBIAN_INSPECT.read_text(encoding="utf-8"))
    payload = json.loads(JACOBIAN_PAYLOAD.read_text(encoding="utf-8"))
    output = json.loads(JACOBIAN_OUTPUT.read_text(encoding="utf-8"))
    operation = "matrix.symbolic.linear_system.solve"
    if inspected["result"]["operation"]["operation_id"] != operation:
        raise AssertionError("the wrong Jacobian contract was inspected")
    typed = output["result"]["output"]
    if (
        output["result"]["operation_id"] != operation
        or typed["classification"] != "UNIQUE"
        or typed["system"] != payload
    ):
        raise AssertionError("the Jacobian tail-inverse solve changed")
    return {
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "operation_id": operation,
        "exact_payload": str(JACOBIAN_PAYLOAD.relative_to(CAMPAIGN)),
        "typed_output": str(JACOBIAN_OUTPUT.relative_to(CAMPAIGN)),
        "classification": typed["classification"],
        "solution": ["1/q", "(q-1)/q"],
        "runtime_ms": output["result"]["runtime_ms"],
        "adapter_error": None,
        "adapter_timeout": False,
        "scope": (
            "This checks the two scalar coefficients in "
            "g^-1 e=q^-1 g e+(q-1)q^-1 e when P(g)e=0. "
            "It does not prove the noncommutative propagation identity."
        ),
    }


def check_baseline():
    records = {}
    for filename in (
        "twist-extension-verification.json",
        "twist-extension-modular-verification.json",
    ):
        replay = HERE / "baseline_replay" / filename
        reviewed = SUPERVISOR / filename
        payload = json.loads(replay.read_text(encoding="utf-8"))
        if payload["status"] != "passed" or replay.read_bytes() != reviewed.read_bytes():
            raise AssertionError(f"baseline replay changed: {filename}")
        records[filename] = {
            "status": "passed",
            "byte_identical_to_reviewed": True,
        }
    return records


def run_singular():
    started = time.monotonic()
    environment = dict(os.environ)
    environment.pop("SINGULAR_BIN_DIR", None)
    completed = subprocess.run(
        ["/usr/bin/Singular", "-q", str(SOURCE)],
        check=True,
        capture_output=True,
        text=True,
        timeout=110,
        env=environment,
    )
    elapsed = time.monotonic() - started
    errors = [
        line
        for line in completed.stdout.splitlines()
        if line.lstrip().startswith("?")
        or "for a different version of Singular" in line
    ]
    if completed.stderr.strip() or errors:
        raise AssertionError(
            "Singular reported errors: "
            + " / ".join([completed.stderr.strip(), *errors])
        )
    records = {}
    for line in completed.stdout.splitlines():
        if "|" in line:
            key, value = line.split("|", 1)
            records[key] = value
    if records.get("ONE_NF") != "1" or records.get("TARGET_NF") != "0":
        raise AssertionError("the exact Q6 propagation did not reduce to zero")
    return {
        "engine": "Singular freegb.lib/twostd",
        "coefficient_field": "Q(q)",
        "degree_bound": 10,
        "source_relation_count": 15,
        "standard_basis_size": int(records["GB_SIZE"]),
        "one_normal_form": records["ONE_NF"],
        "target_normal_form": records["TARGET_NF"],
        "crossing_unseeded_normal_form": records["CROSSING_TARGET_NF"],
        "crossing_q4_seed_normal_form": records[
            "CROSSING_SEED_DIVISION"
        ],
        "crossing_q4_seed": "sigma_2*X3=-q^3*X3",
        "crossing_q4_seed_reduction_zero": (
            records["CROSSING_SEED_DIVISION"] == "0"
        ),
        "elapsed_seconds": round(elapsed, 3),
        "membership_semantics": (
            "Every twostd rule is generated by two-sided compositions from "
            "the listed braid, commutation, tail-quadratic, and exact Q5 rows."
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=HERE / "q6-propagation-certificate.json",
    )
    args = parser.parse_args()
    if args.output.resolve().parent != HERE:
        raise SystemExit("output must stay in the mission directory")

    polynomial_ring = PolynomialRing(QQ, "q")
    q = polynomial_ring.fraction_field()(polynomial_ring.gen())
    parsed = parse_source(q)
    certificate = {
        "schema": "q6-left-defect-propagation-v1",
        "status": "passed",
        "coefficient_field": "Q(q)",
        "claim": (
            "P(t)d(c-1)X3=(1-q)dtcX3+((q-1)^2/q)dtdcX3"
            "+((q-1)/q)dt(d^2)cX3-((q-1)/q)cdtcdX3"
            "+((q-1)^2/q^2)cdtcdcX3+((q-1)/q^2)cdtcd(c^2)X3"
            "+(1-q)bcdtcdbcX3-((q-1)/q)abcdtcdbcX3"
        ),
        "notation": {
            "a": "sigma_1",
            "b": "sigma_2",
            "c": "sigma_3",
            "d": "sigma_4",
            "t": "sigma_5",
            "P(g)": "(g-1)(g+q)",
        },
        "schreier_membership": {
            "target": "P(sigma_5)*sigma_4*(sigma_3*e-e)",
            "state_count": 8,
            "top_representatives": ["dt", "cdt", "bcdt", "abcdt"],
            "all_cores_lie_in_Q5_e": True,
            "conclusion": "the target lies in L_6",
        },
        "source_derivation": {
            "q5_left_identity": (
                "the exact prior Q5 row q5_left=0"
            ),
            "tail_d": (
                "eP(d)=0 from the exact Q5 right certificate; d commutes "
                "with X3, hence P(d)X3=0"
            ),
            "tail_t": (
                "P(t)dt=dtP(d), X3 commutes with d,t, and d,t are "
                "invertible by the cubic, so P(d)X3=0 implies P(t)X3=0"
            ),
            "adjacent_defect_identity": factor_string(
                parsed["Pt"] * parsed["d"] * parsed["t"]
                - parsed["d"] * parsed["t"] * parsed["Pd"]
            )
            if "d" in parsed
            else "P(t)dt=dtP(d)",
            "repairs": (
                "Every source identity holds in the truncated repair. "
                "The direct-limit terminal rows have X4 or a shifted "
                "descendant as a factor, so the same consequence holds."
            ),
        },
        "prior_certificates": check_prior_certificates(),
        "exact_membership": run_singular(),
        "finite_fiber_discovery": check_fibers(),
        "jacobian": check_jacobian(),
        "baseline_replay": check_baseline(),
        "scope": (
            "This proves one exact Q6 left diagonal membership from the "
            "rank-five identities. It does not by itself prove an all-rank "
            "propagation schema, termination, the right recursion, or "
            "universal finite-dimensionality."
        ),
    }
    certificate["source_derivation"][
        "adjacent_defect_identity"
    ] = "P(t)dt=dtP(d), exactly modulo the braid dtd=tdt"
    args.output.write_text(
        json.dumps(certificate, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    print(
        json.dumps(
            {
                "status": certificate["status"],
                "standard_basis_size": certificate["exact_membership"][
                    "standard_basis_size"
                ],
                "target_normal_form": certificate["exact_membership"][
                    "target_normal_form"
                ],
                "schreier_state_count": certificate[
                    "schreier_membership"
                ]["state_count"],
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
