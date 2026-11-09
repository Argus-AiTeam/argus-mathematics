#!/usr/bin/env python3
"""Replay exact sign calculations and bind them to the universal Lean theorem."""

import argparse
from collections import Counter, deque
from fractions import Fraction
import hashlib
import itertools
import json
from math import gcd, isqrt
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "matrix.nullspace.compute"
FORMAL_CERTIFICATE = (
    "formal/evidence/certificates/C_UC_SPLIT_FORMAL-391717346b7e61fd.json"
)
PRIMES = (3, 5, 7, 11, 13, 17, 19)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def read_json(name):
    return json.loads((HERE / name).read_text())


def write_json(name, value):
    (HERE / name).write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def jacobian_payload():
    words = list(itertools.product(range(3), repeat=2))
    parity = (0, 0, 1)
    matrix = [[0] * 18 for _ in range(18)]
    for block, twist in enumerate((1, -1)):
        for column, word in enumerate(words):
            row = words.index(word[::-1])
            sign = twist * (-1 if parity[word[0]] * parity[word[1]] else 1)
            matrix[9 * block + column][9 * block + column] += 1
            matrix[9 * block + row][9 * block + column] -= sign
    return {
        "matrix": {
            "domain": "QQ",
            "entries": [
                [{"num": str(entry), "den": "1"} for entry in row]
                for row in matrix
            ],
        }
    }


def run_jacobian():
    payload = jacobian_payload()
    write_json("jacobian_payload.json", payload)
    command = [
        ARGUS_PYTHON, "-m", "argus_skill.tools.jacobian", "run",
        "--operation", OPERATION,
        "--payload-file", str(HERE / "jacobian_payload.json"),
    ]
    try:
        outcome = subprocess.run(
            command, capture_output=True, text=True, timeout=90, cwd=ROOT
        )
    except subprocess.TimeoutExpired as error:
        output = error.stdout or b""
        stderr = error.stderr or b""
        write_json("jacobian_run_status.json", {
            "operation_id": OPERATION,
            "command": command,
            "status": "timeout",
            "timeout_seconds": 90,
            "exit_code": None,
            "partial_stdout": output.decode() if isinstance(output, bytes) else output,
            "stderr": stderr.decode() if isinstance(stderr, bytes) else stderr,
            "mathematical_conclusion": None,
        })
        raise RuntimeError("Jacobian timed out; no mathematical conclusion") from error
    (HERE / "jacobian_output.json").write_text(outcome.stdout)
    status = {
        "operation_id": OPERATION,
        "command": command,
        "status": "completed" if outcome.returncode == 0 else "adapter_error",
        "exit_code": outcome.returncode,
        "stderr": outcome.stderr,
        "mathematical_conclusion": None,
    }
    write_json("jacobian_run_status.json", status)
    require(outcome.returncode == 0, "Jacobian adapter returned an error")
    try:
        json.loads(outcome.stdout)
    except json.JSONDecodeError as error:
        status["status"] = "incomplete_or_invalid_json"
        write_json("jacobian_run_status.json", status)
        raise RuntimeError("Jacobian did not return complete typed JSON") from error


def rational(value):
    numerator, denominator = int(value["num"]), int(value["den"])
    require(denominator > 0, "Nonpositive rational denominator")
    require(gcd(numerator, denominator) == 1, "Noncanonical rational")
    require(str(numerator) == value["num"], "Noncanonical numerator encoding")
    require(str(denominator) == value["den"], "Noncanonical denominator encoding")
    return Fraction(numerator, denominator)


def rank(matrix, prime=None):
    rows = [
        [Fraction(x) if prime is None else int(x) % prime for x in row]
        for row in matrix
    ]
    pivot_row = 0
    columns = len(rows[0]) if rows else 0
    for column in range(columns):
        pivot = next(
            (i for i in range(pivot_row, len(rows)) if rows[i][column]), None
        )
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        value = rows[pivot_row][column]
        inverse = 1 / value if prime is None else pow(value, -1, prime)
        rows[pivot_row] = [x * inverse for x in rows[pivot_row]]
        if prime is not None:
            rows[pivot_row] = [x % prime for x in rows[pivot_row]]
        for i in range(len(rows)):
            if i == pivot_row:
                continue
            scale = rows[i][column]
            rows[i] = [x - scale * y for x, y in zip(rows[i], rows[pivot_row])]
            if prime is not None:
                rows[i] = [x % prime for x in rows[i]]
        pivot_row += 1
        if pivot_row == len(rows):
            break
    return pivot_row


def verify_jacobian():
    payload = read_json("jacobian_payload.json")
    require(payload == jacobian_payload(), "Jacobian payload is not the signed action")
    status = read_json("jacobian_run_status.json")
    require(
        status["status"] == "completed" and status["exit_code"] == 0,
        "Jacobian error/timeout is not evidence",
    )
    envelope = read_json("jacobian_output.json")
    require(envelope["tool"] == "math.run", "Not a Jacobian execution record")
    require(envelope["server"]["version"] == "0.14.0", "Unexpected server version")
    require(envelope["protocol_version"] == "2025-11-25", "Unexpected protocol")
    require(envelope["result"]["operation_id"] == OPERATION, "Wrong executed operation")
    result = envelope["result"]["output"]
    require(result["matrix"] == payload["matrix"], "Typed matrix binding differs")
    matrix = [[rational(x) for x in row] for row in payload["matrix"]["entries"]]
    vectors = [[rational(x) for x in row] for row in result["basis_vectors"]]
    require(result["ambient_dimension"] == 18, "Wrong ambient dimension")
    require(result["rank"] == rank(matrix) == 9, "Wrong signed-constraint rank")
    require(result["nullity"] == len(vectors) == 9, "Wrong invariant dimension")
    require(rank(vectors) == 9, "Returned invariant vectors are dependent")
    for vector in vectors:
        require(len(vector) == 18, "Wrong vector dimension")
        require(
            all(sum(x * y for x, y in zip(row, vector)) == 0 for row in matrix),
            "Returned vector is not in the signed kernel",
        )
    for prime in PRIMES:
        require(rank(matrix, prime) == 9, "Unexpected odd-characteristic rank")
    return {
        "operation_id": OPERATION,
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "adapter_exit_code": status["exit_code"],
        "matrix_shape": [18, 18],
        "rank": 9,
        "nullity": 9,
        "meaning": "Two-slot Koszul invariants and sign-isotypical invariants, not a universal proof.",
    }


def cyclic_letters(prime, twist):
    period = 2 * (prime - 1)
    target = (prime - 1) // 2 if twist else 0
    letters = [
        (exterior, exponent, exterior + 2 * exponent)
        for exterior in (0, 1)
        for exponent in range(period + 1)
        if exterior + 2 * exponent <= 2 * period
        and (exterior + exponent) % (prime - 1) == target
    ]
    return sorted(letters, key=lambda x: (x[2], x[0], x[1]))


def orbit_invariants(letters, length, prime, twist=False):
    seen = set()
    basis = {}
    for representative in itertools.product(range(len(letters)), repeat=length):
        if representative in seen:
            continue
        coefficients = {representative: 1}
        queue = deque([representative])
        consistent = True
        while queue:
            word = queue.popleft()
            for i in range(length - 1):
                other = list(word)
                other[i], other[i + 1] = other[i + 1], other[i]
                other = tuple(other)
                sign = -1 if letters[word[i]][0] * letters[word[i + 1]][0] else 1
                if twist:
                    sign = -sign
                value = sign * coefficients[word] % prime
                if other in coefficients:
                    if coefficients[other] != value:
                        consistent = False
                else:
                    coefficients[other] = value
                    queue.append(other)
        seen.update(coefficients)
        if consistent:
            basis[representative] = coefficients
    return basis


def canonical_words(letters, length, prime, twist=False):
    result = []
    for word in itertools.combinations_with_replacement(range(len(letters)), length):
        if prime != 2:
            forbidden_parity = 0 if twist else 1
            if any(
                count > 1 and letters[index][0] == forbidden_parity
                for index, count in Counter(word).items()
            ):
                continue
        result.append(word)
    return result


def word_degree(letters, word):
    return sum(letters[index][2] for index in word)


def verify_invariants():
    results = []
    for prime in PRIMES:
        unsigned = cyclic_letters(prime, False)
        signed = cyclic_letters(prime, True)
        require(unsigned[0] == (0, 0, 0), "Unit missing from U")
        for twist, letters in [(False, unsigned), (True, signed)]:
            for exterior, exponent, _ in letters:
                for unit in range(1, prime):
                    character = pow(unit, (prime - 1) // 2, prime) if twist else 1
                    weight = exterior + exponent
                    require(pow(unit, weight, prime) * character % prime == 1,
                            "Wrong independent-multiplier character")
                    require(pow(unit, -weight, prime) * character % prime == 1,
                            "Opposite conjugation convention changes invariance")
        previous = None
        for length in range(5):
            basis = orbit_invariants(unsigned, length, prime)
            twisted = orbit_invariants(signed, length, prime, twist=True)
            expected = canonical_words(unsigned, length, prime)
            require(list(basis) == expected, "Unsigned orbit/stabilizer classification failed")
            require(
                list(twisted) == canonical_words(signed, length, prime, twist=True),
                "Twisted orbit/stabilizer classification failed",
            )
            sign_bottom = min(word_degree(signed, word) for word in twisted)
            require(sign_bottom == length * (prime - 2), "Wrong sharp sign endpoint")
            kernel = []
            if length:
                images = set()
                for representative, vector in basis.items():
                    image = {
                        word[:-1]: value
                        for word, value in vector.items() if word[-1] == 0
                    }
                    if 0 not in representative:
                        require(not image, "Full occupation survives augmentation")
                        kernel.append(representative)
                    else:
                        target = list(representative)
                        target.remove(0)
                        target = tuple(target)
                        require(image == previous[target],
                                "Augmentation is not coefficient-one restriction")
                        images.add(target)
                require(images == set(previous), "Restriction is not surjective")
                kernel_bottom = min(word_degree(unsigned, word) for word in kernel)
                require(
                    kernel_bottom == length * 2 * (prime - 1) - 1,
                    "Wrong sharp cofiber kernel endpoint",
                )
                require(len(basis) == len(previous) + len(kernel),
                        "Occupied-slot dimension decomposition failed")
            else:
                kernel_bottom = None
            results.append({
                "p": prime, "l": length,
                "unsigned_dimension": len(basis),
                "sign_isotypical_dimension": len(twisted),
                "kernel_dimension": len(kernel),
                "sign_first_degree": sign_bottom,
                "kernel_first_degree": kernel_bottom,
                "symmetric_group_range": length < prime,
            })
            previous = basis
    return results


def verify_characters():
    checked = 0
    for prime in PRIMES:
        for unit in range(1, prime):
            permutation = [unit * x % prime for x in range(prime)]
            inversions = sum(
                permutation[i] > permutation[j]
                for i in range(prime) for j in range(i + 1, prime)
            )
            sign = -1 if inversions % 2 else 1
            require(sign % prime == pow(unit, (prime - 1) // 2, prime),
                    "Block multiplier sign differs from the Legendre character")
            checked += 1
    return checked


def verify_bounds():
    cases = 0
    degrees = (-7, -4, -1, 0, 1, 2, 6)
    for prime in PRIMES:
        for constant in range(1, min(prime - 1, 6) + 1):
            for arity in range(constant * prime + 1):
                blocks, remainder = divmod(arity, prime)
                require(arity < prime * prime and blocks <= constant,
                        "The Sylow range hypothesis is not satisfied")
                for degree in degrees:
                    rank_degree = arity * degree
                    if degree % 2:
                        if remainder < 2:
                            exact = rank_degree + blocks * (prime - 2)
                            require(exact >= rank_degree, "Basic virtual rank bound failed")
                            require(exact >= rank_degree + arity - (2 * constant + 1),
                                    "conn:odd-bound failed")
                    else:
                        if arity == 0:
                            exact = 0
                        elif remainder:
                            continue
                        else:
                            exact = rank_degree + 2 * blocks * (prime - 1) - 1
                            require(
                                exact - rank_degree - blocks * (2 * prime - 3)
                                == blocks - 1, "Sharp endpoint comparison failed"
                            )
                        require(exact >= rank_degree + 2 * arity - 3 * constant,
                                "conn:cofiber-bound failed")
                    cases += 1
    for subset_size in range(65):
        left = -subset_size + subset_size % 2 + 2 * (subset_size == 0)
        require(left >= 2 * (1 - subset_size), "Koszul degree inequality failed")
    return {"prime_arity_degree_cases": cases, "koszul_subset_sizes": 65}


def is_prime(number):
    return number >= 2 and all(
        number % divisor for divisor in range(2, isqrt(number) + 1)
    )


def verify_moving_weights():
    examples = []
    for stage in range(5):
        coefficients = []
        mass_lambda = mass_delta = 0
        for j in range(stage + 1):
            for mask in range(1 << j):
                subset = [h for h in range(j) if mask & (1 << h)]
                size = len(subset)
                mass = 3**j - sum(3**h for h in subset)
                require(mass >= 1, "Generator mass is not positive")
                slope = 1
                remainder = int(size % 2 and j % 2)
                mass_lambda += slope * mass
                mass_delta += remainder * mass
                coefficients.append((size, mass, slope, remainder))
        constant = mass_lambda + abs(mass_delta) + 1
        prime = constant + 1
        while not is_prime(prime):
            prime += 1
        types = 2 ** (stage + 1) - 1
        error = types * (5 * constant + 1)
        relative = nu = mass_gamma = 0
        for size, mass, slope, remainder in coefficients:
            arity = slope * prime + remainder
            require(arity <= constant * prime, "Mass arity bound failed")
            mass_gamma += arity * mass
            nu += arity * (1 - size)
            relative -= size * arity
            if size == 0:
                relative += 2 * slope * (prime - 1) - 1
            elif size % 2:
                relative += slope * (prime - 2)
        require(mass_gamma == prime * mass_lambda + mass_delta,
                "Moving weight does not satisfy its exact mass identity")
        require(relative >= 2 * nu - error, "Conditional moving-weight bound failed")
        examples.append({
            "a": stage, "p": prime, "C": constant, "N_a": types,
            "sigma_lambda": mass_lambda, "sigma_delta": mass_delta,
            "sigma_gamma": mass_gamma, "nu_gamma": nu,
            "relative_factor_bound": relative,
            "claimed_relative_bound": 2 * nu - error,
            "multiplicity_growth": "p or p+1 in every variable type",
        })
    return examples


def verify_formal_record():
    certificate = read_json(FORMAL_CERTIFICATE)
    check = certificate["lean_check"]
    require(check["status"] == "success", "Formal record is not a successful compile")
    require(check["exit_code"] == check["audit_exit_code"] == 0,
            "Compiler or axiom audit did not succeed")
    require(check["proof_holes"] == [], "Formal source contains proof holes")
    require(check["environment_failure"] == "", "Unverified formal environment")
    require("version 4.31.0" in check["tools"]["lean"]["version"], "Wrong Lean version")
    for source, field in [
        ("formal/Main.lean", "source_sha256"),
        ("formal/statement_fidelity.md", "statement_fidelity_sha256"),
    ]:
        digest = hashlib.sha256((HERE / source).read_bytes()).hexdigest()
        require(digest == check[field], "Formal source/fidelity changed after compilation")
    for name in [
        "signed_permutation_invariance", "tensorDirectSumEquiv",
        "split_augmentation", "augment_lower_summand", "augment_top",
        "augmentationKernelEquiv", "augment_section",
    ]:
        require(f"'UniformConnectivity.{name}' depends on axioms:" in check["stdout"],
                "A claimed theorem is missing from the compiler dependency prints")
    return {
        "claim_id": "C_UC_SPLIT_FORMAL",
        "certificate": FORMAL_CERTIFICATE,
        "lean_version": "4.31.0",
        "exit_code": 0, "audit_exit_code": 0, "proof_holes": [],
        "source_sha256": check["source_sha256"],
        "statement_fidelity_sha256": check["statement_fidelity_sha256"],
        "coverage": "Universal finite-support free-alphabet Koszul invariant splitting and exact augmentation kernel, over every commutative ring and every arity.",
        "unformalized_bridge": "Equivariant tensor-basis identification; group cohomology and topology are proved or assumed in report.md, not in Lean.",
        "replay": "Use the official lean_evidence command in formal/statement_fidelity.md for a fresh compiler run; this Python check only binds the existing real compiler record to its unchanged source.",
    }


def certificate_value():
    return {
        "schema_version": 1,
        "claim_id": "C_UC_CONDITIONAL",
        "result_class": "formal_verification",
        "independent_review": "pending",
        "novelty_status": "not_established",
        "campaign_complete": False,
        "universal_proof": verify_formal_record(),
        "exact_prose_theorems": {
            "range": "all odd primes p, 0<=k<p^2, k=lp+b, and every integer d",
            "odd_first_degree_when_b_le_1": "kd+l(p-2)",
            "odd_vanishing": "b>=2",
            "even_positive_cofiber_first_degree_when_b_eq_0": "kd+2l(p-1)-1",
            "even_positive_cofiber_vanishing": "b>0",
            "restriction": "coefficient-one last-slot augmentation; surjective with full-occupation kernel",
            "module_estimate": "conditional on universal:whole-module and the stated bounded positive-mass filtration",
            "proof": "report.md",
        },
        "cited_inputs_not_formalized": [
            {
                "claim_id": "C_SCOPE_308",
                "assumption_id": "A_ANGELTVEIT_V4",
                "source_id": "arxiv:2610.23215v1",
                "locator": "Theorem 1.1",
                "role": "Independent stronger fixed-height existence result; not an input to the connectivity proof.",
            },
            {
                "claim_id": "C_UC_TOPOLOGY",
                "assumption_id": "A_MAY_THOM",
                "source_id": "isbn:9780226511832",
                "locator": "Chapter 23, section 5, p. 195, Thom isomorphism theorem",
                "role": "Oriented finite-rank theorem only; the virtual sign-local-system extension is a prose argument.",
            },
            {
                "claim_id": "C_UC_TOPOLOGY",
                "assumption_id": "A_MAY_HUREWICZ",
                "source_id": "isbn:9780226511832",
                "locator": "Chapter 15, section 1, p. 118, Hurewicz theorem",
                "role": "Theorem for connected spaces; the stable extension is a prose argument.",
            },
        ],
        "bounded_regression_only": {
            "primes": list(PRIMES),
            "lengths": [0, 1, 2, 3, 4],
            "invariant_models": verify_invariants(),
            "vandermonde_characters_checked": verify_characters(),
            "bounds": verify_bounds(),
            "moving_weight_examples": verify_moving_weights(),
            "warning": "These finite experiments are not the universal theorem.",
        },
        "jacobian": verify_jacobian(),
        "unverified_dependencies": [
            "Independent Reviewer statement fidelity and mathematical replay",
            "Source attribution of recorded external assumptions",
            "universal:whole-module and its primewise model construction",
            "layer:comparison and module-action compatibility in conn:k-test",
            "The remaining chains in both manuscripts' main existence proofs",
            "Campaign-level publishability and novelty",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--prepare-jacobian", action="store_true")
    group.add_argument("--run-jacobian", action="store_true")
    group.add_argument("--write-certificate", action="store_true")
    arguments = parser.parse_args()
    if arguments.prepare_jacobian:
        write_json("jacobian_payload.json", jacobian_payload())
        print("Prepared exact 18-by-18 signed-permutation constraint matrix.")
        return
    if arguments.run_jacobian:
        run_jacobian()
        print("Preserved the exact Jacobian request, typed output, and adapter status.")
        return
    result = certificate_value()
    if arguments.write_certificate:
        write_json("exact_certificate.json", result)
    require(read_json("exact_certificate.json") == result,
            "Exact certificate differs from its deterministic replay")
    print(json.dumps({
        "status": "verified",
        "universal_kernel": "C_UC_SPLIT_FORMAL",
        "lean_exit": result["universal_proof"]["exit_code"],
        "proof_holes": result["universal_proof"]["proof_holes"],
        "finite_invariant_models": len(result["bounded_regression_only"]["invariant_models"]),
        "independent_review": "pending",
        "campaign_complete": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
