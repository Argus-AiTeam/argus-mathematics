#!/usr/bin/env python3
"""Exact factorization certificate for the support-capacity finite kernel."""

from __future__ import annotations

import json
from collections import Counter
from math import comb, isqrt, prod
from pathlib import Path


ROW_MIN = 1001
ROW_MAX = 5060
LOWER_INDEX = 7
OUTPUT = Path(__file__).with_suffix(".json")
JACOBIAN_RESULT = (
    Path(__file__).parent
    / "jacobian"
    / "support_seven_factor_result.json"
)


def primes_through(limit: int) -> list[int]:
    sieve = bytearray(b"\x01") * (limit + 1)
    sieve[:2] = b"\x00\x00"
    for prime in range(2, isqrt(limit) + 1):
        if sieve[prime]:
            start = prime * prime
            count = (limit - start) // prime + 1
            sieve[start : limit + 1 : prime] = b"\x00" * count
    return [value for value in range(2, limit + 1) if sieve[value]]


def is_prime_by_trial_division(value: int) -> bool:
    if value < 2:
        return False
    if value % 2 == 0:
        return value == 2
    divisor = 3
    while divisor * divisor <= value:
        if value % divisor == 0:
            return False
        divisor += 2
    return True


def factorial_valuation(value: int, prime: int) -> int:
    exponent = 0
    while value:
        value //= prime
        exponent += value
    return exponent


def factor_binomial(
    n: int, k: int, prime_basis: list[int]
) -> list[tuple[int, int]]:
    factors = []
    for prime in prime_basis:
        if prime > n:
            break
        exponent = (
            factorial_valuation(n, prime)
            - factorial_valuation(k, prime)
            - factorial_valuation(n - k, prime)
        )
        if exponent:
            factors.append((prime, exponent))
    return factors


def checked_inequality(k: int, x: int) -> dict[str, int | str]:
    coefficient = comb(x, k)
    sixth_power = x**6
    return {
        "k": k,
        "x": x,
        "binomial": coefficient,
        "x_to_six": sixth_power,
        "comparison": (
            "greater"
            if coefficient > sixth_power
            else "less"
            if coefficient < sixth_power
            else "equal"
        ),
        "difference": coefficient - sixth_power,
    }


def main() -> None:
    prime_basis = primes_through(ROW_MAX)
    if not all(is_prime_by_trial_division(p) for p in prime_basis):
        raise AssertionError("sieve emitted a composite")

    rows = []
    omega_histogram: Counter[int] = Counter()
    for n in range(ROW_MIN, ROW_MAX + 1):
        value = comb(n, LOWER_INDEX)
        factors = factor_binomial(n, LOWER_INDEX, prime_basis)
        factor_product = prod(p**e for p, e in factors)
        if factor_product != value:
            raise AssertionError(
                f"factor product mismatch at n={n}: {factor_product} != {value}"
            )
        if not all(is_prime_by_trial_division(p) for p, _ in factors):
            raise AssertionError(f"nonprime factor at n={n}")

        omega = len(factors)
        omega_histogram[omega] += 1
        rows.append(
            {
                "n": n,
                "value": value,
                "omega": omega,
                "largest_primary_component": max(
                    p**e for p, e in factors
                ),
                "factors": [
                    {
                        "prime": p,
                        "exponent": e,
                        "primary_component": p**e,
                    }
                    for p, e in factors
                ],
            }
        )

    minimum_omega = min(row["omega"] for row in rows)
    deficient_rows = [row["n"] for row in rows if row["omega"] <= 6]
    if deficient_rows:
        raise AssertionError(
            f"rows with at most six prime factors: {deficient_rows}"
        )

    threshold_checks = [
        checked_inequality(17, 34),
        checked_inequality(8, 1001),
        checked_inequality(7, 5060),
        checked_inequality(7, 5061),
    ]
    expected_comparisons = ["greater", "greater", "less", "greater"]
    if [
        item["comparison"] for item in threshold_checks
    ] != expected_comparisons:
        raise AssertionError("threshold comparison changed")

    spotcheck = json.loads(JACOBIAN_RESULT.read_text(encoding="utf-8"))
    spotcheck_row = next(row for row in rows if row["n"] == 1439)
    spotcheck_factors = [
        (int(item["prime"]), item["power"])
        for item in spotcheck["output"]["factors"]
    ]
    expected_spotcheck_factors = [
        (item["prime"], item["exponent"])
        for item in spotcheck_row["factors"]
    ]
    if (
        spotcheck["operation_id"]
        != "integer.compute.prime_factorization"
        or spotcheck["output"]["status"] != "COMPLETE"
        or int(spotcheck["output"]["value"]) != spotcheck_row["value"]
        or spotcheck_factors != expected_spotcheck_factors
    ):
        raise AssertionError("Jacobian spot-check does not match row 1439")

    certificate = {
        "schema_version": 1,
        "claim": (
            "For every integer n with 1001 <= n <= 5060, "
            "omega(binomial(n,7)) >= 7."
        ),
        "status": "COMPLETE",
        "row_interval": {"minimum": ROW_MIN, "maximum": ROW_MAX},
        "rows_checked": len(rows),
        "factorization_method": (
            "Exact Legendre valuations over the complete Eratosthenes "
            "prime basis p<=5060; each listed prime is independently checked "
            "by deterministic trial division and each prime-power product is "
            "checked against Python's exact integer binomial coefficient."
        ),
        "minimum_omega": minimum_omega,
        "rows_at_minimum_omega": [
            row["n"] for row in rows if row["omega"] == minimum_omega
        ],
        "omega_histogram": {
            str(omega): count
            for omega, count in sorted(omega_histogram.items())
        },
        "rows_with_omega_at_most_six": deficient_rows,
        "threshold_checks": threshold_checks,
        "jacobian_spotcheck": {
            "role": "cross-check only; not used for completeness",
            "row": 1439,
            "operation_id": spotcheck["operation_id"],
            "payload_file": (
                "research/jacobian/support_seven_factor_payload.json"
            ),
            "result_file": (
                "research/jacobian/support_seven_factor_result.json"
            ),
            "contract_file": (
                "research/jacobian/all_primary_factor_contract.json"
            ),
            "status": spotcheck["output"]["status"],
            "runtime_ms": spotcheck["runtime_ms"],
            "matches_exact_certificate": True,
        },
        "analytic_scope": (
            "The certificate proves only the displayed finite-kernel "
            "factorizations and exact endpoint inequalities. The reduction "
            "from m(a)=5 and omega(a)<=6 to this kernel is proved separately "
            "in research/support_capacity_seven.md."
        ),
        "rows": rows,
    }
    OUTPUT.write_text(
        json.dumps(certificate, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    print(
        f"verified {len(rows)} exact factorizations; "
        f"minimum omega={minimum_omega}; deficient rows={len(deficient_rows)}"
    )


if __name__ == "__main__":
    main()
