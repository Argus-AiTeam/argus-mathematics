#!/usr/bin/env python3
"""Replay the exact arithmetic, structural fixtures, and full Lean theorem."""

import argparse
from fractions import Fraction
from functools import reduce
from itertools import product
import json
from math import gcd
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
COMPILER = HERE / "compiler"
PRINCIPAL = "ZeroWeightedCount.manuscript_zero_count"
STANDARD_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
DECLARATIONS = {
    "OAI.Problem355.ZeroGlobalCount.weighted_count_le_log",
    "OAI.Problem355.AuxiliaryZeroCount.weighted_count_le_log",
    *(f"ZeroWeightedCount.{name}" for name in (
        "uniform_weight_eq", "restrictedWeight_eq_uniform_product", "restrictedLaw",
        "logarithm_conversion", "cap_size_bound_iff", "mem_zeroMatrices",
        "weighted_law_box_bound", "weighted_determinant_zero_bound",
        "manuscript_parameters_bound", "manuscript_zero_count",
    )),
}


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def dot(u, v):
    return sum(a * b for a, b in zip(u, v))


def determinant(a):
    return (
        a[0][0] * (a[1][1] * a[2][2] - a[1][2] * a[2][1])
        - a[0][1] * (a[1][0] * a[2][2] - a[1][2] * a[2][0])
        + a[0][2] * (a[1][0] * a[2][1] - a[1][1] * a[2][0])
    )


def arithmetic():
    row_constant = 576 ** 3
    cap_constant = 2000 ** 3
    shell_constant = row_constant * (
        1000 + 3342 * cap_constant ** 2 + 1296 * cap_constant
    )
    require(8 * shell_constant < 10 ** 33, "Uniform constant is too small")
    log_lower_sum = sum((Fraction(1, n) for n in (5, 6, 7, 8)), Fraction())
    require(log_lower_sum > Fraction(5, 8), "Logarithm lower sum failed")
    require(Fraction(64, 21) < 4, "Affine weight constant failed")
    require(Fraction(32, 21) < 2, "Independent linear pair constant failed")
    require(Fraction(16, 7) < 4, "Distinct affine pair constant failed")
    require(Fraction(8, 7) < 2, "General weight constant failed")
    require(Fraction(18, 1000) + Fraction(3, 2000) < Fraction(1, 2),
            "Allowed-shift conditioning estimate failed")
    require(2 ** 22 >= 2000, "q>=h^26 does not imply the auxiliary size bound")

    exponents = {
        "equal_additional": tuple(a + 2 * b for a, b in zip((2, -3), (12, 1))),
        "special_rank_two": tuple(a + b for a, b in zip((2, -2), (12, 1))),
        "special_rank_at_most_one": tuple(
            a + 2 * b for a, b in zip((2, -4), (12, 1))
        ),
    }
    require(exponents == {
        "equal_additional": (26, -1),
        "special_rank_two": (14, -1),
        "special_rank_at_most_one": (26, -2),
    }, "A power of a growing parameter was lost")
    for h_power, q_power in exponents.values():
        require(q_power < 0 and h_power <= -26 * q_power,
                "A shell factor is not absorbed by q>=h^26")

    moment_fixtures = 0
    for base in (2, 3, 5, 7):
        for e in range(9):
            for b in range(e + 1):
                total = sum(base ** (2 * j - max(j - b, 0)) for j in range(e + 1))
                a, t = base ** b, base ** (e - b)
                closed = (
                    Fraction(base ** 2 * a ** 2 - 1, base ** 2 - 1)
                    + Fraction(base * a ** 2 * (t - 1), base - 1)
                )
                require(total == closed, "Prime-power sum formula failed")
                require(
                    (base ** 2 - 1) * (2 * a ** 2 * t - closed)
                    == a ** 2 * t * (base - 2) * (base + 1) + base * a ** 2 + 1,
                    "Moment remainder identity failed",
                )
                require(total <= 2 * base ** (b + e), "Moment fixture failed")
                moment_fixtures += 1
    return {
        "row_constant": row_constant,
        "cap_constant": cap_constant,
        "shell_constant": shell_constant,
        "explicit_analytic_K": 10 ** 33,
        "eight_times_shell_constant": 8 * shell_constant,
        "log_two_lower_sum": str(log_lower_sum),
        "normalized_shell_exponents_h_q": exponents,
        "moment_formula_fixtures": moment_fixtures,
    }


def main_modulus_fixtures():
    q_matrix = ((1, 1, 0), (0, 1, 1), (0, 0, 1))
    require(determinant(q_matrix) == 1, "Orientation fixture is not invertible")
    lattice_cases = pairing_cases = 0
    distinguishes_transpose = False
    for base, k in ((2, 1), (2, 2), (3, 1), (3, 2), (5, 1)):
        h = base ** k
        for e in range(k + 1):
            for b in range(e + 1):
                d, E = base ** b, base ** e
                index = d * E
                c = tuple(
                    tuple(scale * entry % h for entry in row)
                    for scale, row in zip((1, d, E), q_matrix)
                )
                rows = {
                    tuple(sum(a[i] * c[i][j] for i in range(3)) % h for j in range(3))
                    for a in product(range(h), repeat=3)
                }
                require(len(rows) * index == h ** 3, "Row-lattice index failed")
                for j in range(3):
                    require(tuple(E % h if i == j else 0 for i in range(3)) in rows,
                            "E times a coordinate vector is missing")
                for j in range(e + 1):
                    modulus = base ** j
                    kernels = sum(
                        all(dot(row, x) % modulus == 0 for row in c)
                        for x in product(range(modulus), repeat=3)
                    )
                    expected = base ** (3 * j - j - max(j - b, 0))
                    require(kernels == expected, "Smith kernel density failed")
                for x in product(range(-2, 3), repeat=3):
                    if reduce(gcd, x) != 1:
                        continue
                    g = gcd(h, *(dot(row, x) for row in c))
                    require(E % g == 0 and g ** 3 <= index * h ** 2,
                            "Pairing divisor bound failed")
                    for j in range(e + 1):
                        modulus = base ** j
                        right = all(dot(row, x) % modulus == 0 for row in c)
                        left = all(
                            sum(x[i] * c[i][v] for i in range(3)) % modulus == 0
                            for v in range(3)
                        )
                        distinguishes_transpose |= right != left
                        require((g % modulus == 0) == right,
                                "Right-null-vector convention failed")
                    pairing_cases += 1
                lattice_cases += 1
    require(distinguishes_transpose, "Fixtures do not detect a transposition error")

    matrix = ((1, 1, 1), (1, 3, 2), (6, 8, 7))
    x = (1, 1, -2)
    require(determinant(matrix) == 0 and all(dot(row, x) == 0 for row in matrix),
            "Primitive right-null fixture failed")
    require(all(xi != 0 for xi in x) and reduce(gcd, x) == 1,
            "Null fixture is not primitive with nonzero coordinates")
    require(all(0 <= matrix[i][j] < 5 for i in (0, 1) for j in range(3))
            and all(5 <= matrix[2][j] < 10 for j in range(3)),
            "Half-open projective box fixture failed")
    projections = {
        (Fraction(matrix[0][j], matrix[2][j]), Fraction(matrix[1][j], matrix[2][j]))
        for j in range(3)
    }
    require(len(projections) == 3, "Fixture has a proportional column pair")
    require(abs(determinant((matrix[0], matrix[1], (11, 0, 0)))) == 11,
            "Maximal g^3/I fixture has the wrong lattice index")
    return {
        "smith_lattice_fixtures": lattice_cases,
        "primitive_pairing_fixtures": pairing_cases,
        "row_column_orientation_distinguished": distinguishes_transpose,
        "nonzero_null_and_distinct_projection_fixture": {
            "matrix_rows": matrix, "right_null_vector": x, "N": 5,
            "main_lattice_index": 11, "pairing_divisor": 11,
            "g_cubed_over_I": 121,
        },
    }


def auxiliary_fixtures():
    plane_cases = pair_cases = 0
    for q in (2, 3, 5, 7):
        vectors = tuple(product(range(q), repeat=3))
        for x in vectors[1:]:
            plane = tuple(v for v in vectors if dot(x, v) % q == 0)
            require(len(plane) == q ** 2, "Primitive reduction plane has wrong size")
            lines = set()
            for v in plane:
                if not any(v):
                    continue
                leading = next(a for a in v if a)
                inverse = pow(leading, -1, q)
                lines.add(tuple(a * inverse % q for a in v))
            require(len(lines) == q + 1, "Low-rank line cover failed")
            additional_pair_exists = False
            for i, j in ((0, 1), (0, 2), (1, 2)):
                delta = tuple((int(a == i) - int(a == j)) % q for a in range(3))
                parallel = any(tuple(t * a % q for a in delta) == x for t in range(q))
                image = {(v[i] - v[j]) % q for v in plane}
                require(len(image) == (1 if parallel else q),
                        "Equal-pair equation has wrong index in the plane")
                additional_pair_exists |= not parallel
                pair_cases += 1
            require(additional_pair_exists, "All-equal residues have no usable pair")
            plane_cases += 1
        special = (1, q - 1, q)
        require(reduce(gcd, special) == 1 and all(special)
                and sum(a * a for a in special) >= q * q,
                "Sparse exceptional normal boundary failed")

    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    require(response["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(response["result"]["operation_id"] == "lattice.rank_gram.compute",
            "Wrong Jacobian operation")
    basis = tuple(tuple(map(int, row)) for row in payload["lattice"]["basis"]["entries"])
    gram = tuple(tuple(dot(u, v) for v in basis) for u in basis)
    squared_covolume = gram[0][0] * gram[1][1] - gram[0][1] * gram[1][0]
    output = response["result"]["output"]
    require(output["rank"] == 2 and squared_covolume == 6,
            "Independent Gram arithmetic failed")
    require(output["gram_matrix"]["entries"] == [[str(a) for a in row] for row in gram]
            and output["squared_covolume"] == str(squared_covolume),
            "Jacobian exact Gram output disagrees with integer arithmetic")
    return {
        "prime_field_planes": plane_cases,
        "equal_pair_index_fixtures": pair_cases,
        "jacobian": {
            "operation_id": response["result"]["operation_id"],
            "server": response["server"],
            "protocol_version": response["protocol_version"],
            "adapter_status": "completed",
            "exact_squared_covolume": squared_covolume,
            "metadata_scope": "The covolume_rational flag is not used; the checked invariant is the squared covolume.",
        },
    }


def compile_theorem(rebuild):
    build = [sys.executable, str(COMPILER / "build_upstream.py")]
    if rebuild:
        build.append("--force")
    log = COMPILER / "Replay.log"
    with log.open("w") as stream:
        for command in (build, [sys.executable, str(COMPILER / "compile_main.py")]):
            result = subprocess.run(command, cwd=HERE.parents[1],
                                    stdout=stream, stderr=subprocess.STDOUT)
            if result.returncode:
                raise RuntimeError(
                    f"Compiler replay exited {result.returncode}; see {log}"
                )
    result = json.loads((COMPILER / "Main.compile.json").read_text())
    require(result["exit_code"] == 0, "Lean compilation did not succeed")
    require("version 4.31.0" in result["compiler_version"], "Wrong Lean version")
    require(not result["unexpected_axioms"], "Target-specific axiom found")
    reports = result["axiom_reports"]
    require({item["declaration"] for item in reports} == DECLARATIONS,
            "A required theorem or probability identity lacks an axiom report")
    for item in reports:
        require(set(item["axioms"]) <= STANDARD_AXIOMS,
                f"Unapproved axiom in {item['declaration']}")
    return {
        "principal_declaration": PRINCIPAL,
        "compiler_version": result["compiler_version"],
        "exit_code": result["exit_code"],
        "source_sha256": result["source_sha256"],
        "axioms": sorted(STANDARD_AXIOMS),
        "target_specific_axioms": [],
        "axiom_report_count": len(reports),
        "proof_holes": [],
        "statement_fidelity": "statement_fidelity.md",
        "formal_constant": "AuxiliaryZeroCount.countConstant * (2 / Real.log 2)",
        "scope": "Full matrix set and actual normalized allowed-shift weight, conditional on the supplied cap and Smith data.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rebuild-upstream", action="store_true",
                        help="Recompile every upstream dependency rather than reuse checked artifacts")
    args = parser.parse_args()
    certificate = {
        "claim_id": "C_ZERO_WEIGHTED",
        "mathematical_result": "Uniform proof of Proposition zero:weighted-zero",
        "result_nature": "Infinite-parameter proof and Lean certification, with supplementary finite structural checks",
        "novelty_status": "not_claimed; reuses an existing upstream zero-count theorem",
        "campaign_completion_claimed": False,
        "independent_review": "Pending Host-invoked Reviewer; this script is not independent review",
        "hypotheses": {
            "main_modulus": "B prime, h=B^k>=2, Smith exponents 0<=b<=e<=k, I=B^(b+e)",
            "auxiliary_modulus": "q prime, h^100<q<=2*h^100; intermediate theorem only needs q>=h^26",
            "cap": "S in [0,floor(q/(1000*h^4)))^3 with no three distinct collinear points and |S|>=q^2/(2000^3*h^12)",
            "matrices": "All box matrices, rows in the row lattice, determinant zero, pairwise distinct projected columns",
            "weight": "(q^3/|S|)^3 times the joint inclusion probability under independent uniform G and allowed input shift",
            "N": "(h*q)^10; intermediate theorem covers every integer N>=1",
        },
        "arithmetic": arithmetic(),
        "main_modulus_fixtures": main_modulus_fixtures(),
        "auxiliary_fixtures": auxiliary_fixtures(),
        "finite_check_limit": "The fixtures are not full-parameter counterexamples or a finite proof of the uniform theorem. The Lean theorem supplies the universal quantifiers.",
    }
    certificate["formal_verification"] = compile_theorem(args.rebuild_upstream)
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({"status": "verified", "claim_id": "C_ZERO_WEIGHTED",
                      "principal_declaration": PRINCIPAL, "lean_exit_code": 0,
                      "proof_holes": [], "certificate": str(HERE / "exact_certificate.json")}))


if __name__ == "__main__":
    main()
