"""Exact controls for the full-quotient inverse-Frobenius theorem."""

import json
import math
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / "search/non-frobenius-cofactor"))
sys.path.insert(0, str(ROOT / "certificates"))

import local_logarithms as local
from construct import prime_divisors, save
from verify_candidate import coefficients, cyclic_product, verify


def require(condition, message):
    if not condition:
        raise ArithmeticError(message)


def valuation(n, p):
    require(n > 0, "valuation requires a positive integer")
    result = 0
    while n % p == 0:
        n //= p
        result += 1
    return result


def prime_certificate(p):
    require(p > 2 and prime_divisors(p) == [p], f"{p} is not an odd prime")
    return {"p": p, "trial_division_bound": math.isqrt(p), "is_prime": True}


def u_vector(r, a, p):
    values = [0] * r
    values[0] = 2
    values[a % r] -= 1
    values[-a % r] -= 1
    return tuple((x - values[-1]) % p for x in values[:-1])


def splitting_factors(p, h):
    upper = p**h - 1
    components = [p - 1, p * p + p + 1] if h == 3 else [upper]
    primes = sorted({q for n in components for q in prime_divisors(n)})
    remaining = upper
    factors = {}
    for q in primes:
        while remaining % q == 0:
            factors[q] = factors.get(q, 0) + 1
            remaining //= q
    require(remaining == 1, "the splitting order was not fully factored")
    return upper, factors


def exact_order(base, upper, factors, p):
    one = (1,) + (0,) * (len(base) - 1)
    require(local.power(base, upper, p) == one, "invalid order upper bound")
    order = upper
    for q in factors:
        while order % q == 0 and local.power(base, order // q, p) == one:
            order //= q
    strict = {
        str(q): list(local.power(base, order // q, p))
        for q in factors if order % q == 0
    }
    require(all(tuple(v) != one for v in strict.values()),
            "order minimality failed")
    require(local.power(base, order, p) == one, "order equality failed")
    return order, strict


def exponent_classes(p, r, m, h):
    g = math.gcd(r, m)
    a = valuation(m, 2)
    T = (4 if a == 0 else 1 if a == 1 else 2) * r * m // g
    forward = [pow(p, j, T) for j in range(h)]
    inverse = []
    if g == 1 and a != 1:
        for j in range(h):
            pj = p**j
            if a == 0:
                t = pj * pow(r, -1, m) % m
                if t % 2:
                    t += m
            else:
                t = pj * pow(r - m // 2, -1, m) % m
            inverse.append((2 * r * t - pj) % T)
    require(len(set(forward + inverse)) == len(forward + inverse),
            "the exponent classes are not distinct")
    return T, forward, inverse


def complete_full_ring_classes(p, r, T):
    base = [p - 1, 1] + [0] * (r - 2)
    value = base
    found = []
    for k in range(1, T + 1):
        if k % r:
            right = [0] * r
            right[0] = p - 1
            right[k % r] = 1
            if value == right:
                found.append(k % T)
        value = cyclic_product(value, base, p)
    return sorted(found)


def local_control(p, r):
    prime = prime_certificate(p)
    require(r >= 7 and r % 4 == 3 and prime_divisors(r) == [r],
            "r is outside the theorem hypotheses")
    orbit = local.frobenius_orbit(p, r)
    h = (r - 1) // 2
    require(len(orbit) == h, f"ord_{r}({p}) is not {h}")
    upper, factors = splitting_factors(p, h)
    b = local.target_vector(r, 1, p)
    U = u_vector(r, 1, p)
    m, m_strict = exact_order(U, upper, factors, p)
    T_actual, T_strict = exact_order(b, upper, factors, p)
    T, forward, inverse = exponent_classes(p, r, m, h)
    require(T == T_actual, f"the period formula fails for p={p}, r={r}")
    require(T % r == 0 and T % 2 == 0 and T % p != 0,
            "period divisibility failed")

    one = (1,) + (0,) * (r - 2)
    real_norm = one
    full_norm = one
    for a in orbit:
        real_norm = local.multiply(real_norm, u_vector(r, a, p), p)
    for a in range(1, r):
        full_norm = local.multiply(full_norm, u_vector(r, a, p), p)
    require(real_norm == (r % p,) + (0,) * (r - 2),
            "the fixed-algebra norm is not r")
    require(full_norm == (r * r % p,) + (0,) * (r - 2),
            "the whole-algebra norm is not r squared")
    require(local.power(U, upper // (p - 1), p) == real_norm,
            "the Frobenius norm and paired product disagree")

    scalar_order = p - 1
    for q in prime_divisors(p - 1):
        while scalar_order % q == 0 and pow(r, scalar_order // q, p) == 1:
            scalar_order //= q
    require(valuation(m, 2) == valuation(scalar_order, 2),
            "norm lost two-primary order information")

    controls = []
    for k in forward + inverse:
        n = k or T
        for offset in (0, 1):
            exponent = n + offset * T
            left, right, residual = coefficients(exponent, r, p)
            require(not any(residual), "a predicted full-ring class failed")
            controls.append({
                "n": str(exponent),
                "target": exponent % r,
                "left": left,
                "right": right,
                "residual": residual,
            })
        require(any(coefficients(n + 1, r, p)[2]),
                "the wrong-parity negative control unexpectedly passed")

    complete = None
    if T <= 16000:
        complete = complete_full_ring_classes(p, r, T)
        require(complete == sorted(forward + inverse),
                "complete full-ring enumeration disagrees with classification")

    return {
        "prime_certificate": prime,
        "r": r,
        "h": h,
        "frobenius_orbit": orbit,
        "splitting_order": str(upper),
        "splitting_factorization": {str(k): v for k, v in factors.items()},
        "m": str(m),
        "gcd_r_m": math.gcd(r, m),
        "v2_m": valuation(m, 2),
        "U_order_minimality": m_strict,
        "T": str(T),
        "b_order_minimality": T_strict,
        "norm_fixed_algebra": list(real_norm),
        "norm_whole_algebra": list(full_norm),
        "scalar_norm_order": str(scalar_order),
        "forward_classes": [str(k) for k in forward],
        "inverse_classes": [str(k) for k in inverse],
        "full_coefficient_controls": controls,
        "complete_period_enumeration": complete,
    }


def polynomial_product(left, right, f, p):
    d = len(f) - 1
    values = [0] * (2 * d - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            values[i + j] += a * b
    for k in range(len(values) - 1, d - 1, -1):
        for j in range(d):
            values[k - d + j] -= values[k] * f[j]
    return [a % p for a in values[:d]]


def single_factor_false_positive():
    p, r = 23, 7
    f1, f2 = [22, 9, 10, 1], [22, 13, 14, 1]
    product = [0] * 7
    for i, a in enumerate(f1):
        for j, b in enumerate(f2):
            product[i + j] = (product[i + j] + a * b) % p
    require(product == [1] * 7, "the two cubic factors do not multiply to Phi_7")
    target = (-p) % r
    require(target * target % r != 1, "the inverse control target is trivial")
    logs = []
    for f in (f1, f2):
        x = [0, 1, 0]
        rhs = [1, 0, 0]
        for _ in range(target):
            rhs = polynomial_product(rhs, x, f, p)
        rhs[0] = (rhs[0] - 1) % p
        base = [p - 1, 1, 0]
        value = [1, 0, 0]
        found = None
        for k in range(p**3 - 1):
            if value == rhs:
                found = k
                break
            value = polynomial_product(value, base, f, p)
        logs.append(found)
    require(sum(k is not None for k in logs) == 1,
            "expected exactly one single-factor logarithm")
    k = next(k for k in logs if k is not None)
    left = coefficients(k, r, p)[0]
    right = [0] * r
    right[0] = p - 1
    right[target] = 1
    full = [(a - b) % p for a, b in zip(left, right)]
    require(any(full), "the single-factor control is not a false positive")
    return {
        "p": p, "r": r, "target": target,
        "target_squared_mod_r": target * target % r,
        "cubic_factors": [f1, f2],
        "single_factor_logs": logs,
        "false_positive_exponent": k,
        "exponent_mod_r": k % r,
        "full_cyclic_target_residual": full,
    }


def integer_cyclic_product(left, right):
    r = len(left)
    values = [0] * r
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            values[(i + j) % r] += a * b
    return values


def characteristic_zero_controls():
    theta = [0, 1, 1, -1, 1, -1, -1]
    theta2 = integer_cyclic_product(theta, theta)
    theta2[0] += 7
    require(len(set(theta2)) == 1, "theta squared is not -7 modulo Phi_7")
    U = [2, -1, 0, 0, 0, 0, -1]
    U2 = integer_cyclic_product(U, U)
    U3 = integer_cyclic_product(U2, U)
    residual = [a - 7 * b + 14 * c for a, b, c in zip(U3, U2, U)]
    residual[0] -= 7
    require(len(set(residual)) == 1, "the real cubic polynomial failed")
    require([2 * a % 7 for a in (1, 2, 4)] == [2, 4, 1],
            "the proposed Frobenius does not fix the quadratic Gauss sum")
    require(9 % 4 == 1 and 9 % 7 == 2 and 9 % 16 == 9,
            "cyclotomic restriction compatibility failed")
    return {
        "theta_squared_plus_7": theta2,
        "U_cubic_residual": residual,
        "real_cubic_polynomial": [-7, 14, -7, 1],
        "L2_degree": 96,
        "Galois_degree_upper_bound": 96 * 7**4,
        "density_lower_bound": "1/230496",
    }


def actual_integer_local_control(record):
    p, r, T = record["prime_certificate"]["p"], record["r"], int(record["T"])
    k = int(record["inverse_classes"][1])
    n = p * (k * pow(p, -1, T) % T)
    if n <= p:
        n += p * T
    require(n % p == 0 and n > p and n % T == k,
            "the arbitrary-cofactor CRT control failed")
    require(n % r == (-p) % r and n * n % r != 1,
            "the inverse target lost original-statement fidelity")
    left, right, residual = coefficients(n, r, p)
    require(not any(residual), "the actual integer did not pass modulo p")
    native = verify({"n": str(n), "r": r, "d": str(p)})
    return {
        "scope": "actual composite exponent, local modulus p only",
        "n": str(n), "p": p, "r": r,
        "target": n % r, "target_squared_mod_r": n * n % r,
        "local_modulus": str(p),
        "local_left": left, "local_right": right, "local_residual": residual,
        "full_modulus_native_result": native,
        "local_seed_is_not_an_original_counterexample": not native["is_counterexample"],
    }


def main():
    started = time.monotonic()
    cases = [
        (11, 7), (23, 7), (37, 7), (53, 7), (67, 7), (109, 7), (193, 7),
        (3, 11), (5, 11), (31, 11), (5, 19), (3, 23),
        (30137, 7), (37781, 7),
    ]
    records = [local_control(p, r) for p, r in cases]
    density, odd = records[-2:]
    require(density["gcd_r_m"] == 1 and density["v2_m"] == 2,
            "the density-class local control is not admissible")
    require(odd["gcd_r_m"] == 1 and odd["v2_m"] == 0,
            "the odd-order inverse-class control is not admissible")
    p = density["prime_certificate"]["p"]
    require(p % 49 == 2 and p % 16 == 9 and
            valuation(p**3 - 1, 7) == 1 and valuation(p**3 - 1, 2) == 3,
            "the density-class valuation conditions failed")
    require(pow(7, (p - 1) // 4, p) == p - 1,
            "7 is not a square-but-not-fourth-power norm control")

    payload = json.loads((HERE / "jacobian-norm-order.payload.json").read_text())
    typed = json.loads((HERE / "jacobian-norm-order.output.json").read_text())
    require(payload == {"value": "7", "modulus": p}, "Jacobian payload mismatch")
    require(typed["request"]["payload"] == payload and
            typed["result"]["operation_id"] == "modular.compute.multiplicative_order",
            "Jacobian did not return the requested operation")
    require(typed["result"]["output"] ==
            {"value": density["scalar_norm_order"]},
            "independent scalar order differs from the Jacobian result")

    actual = [actual_integer_local_control(density),
              actual_integer_local_control(odd)]
    complete = sum(r["complete_period_enumeration"] is not None for r in records)
    full = sum(len(r["full_coefficient_controls"]) for r in records)
    require(complete >= 3, "too few independent complete-period controls")
    report = {
        "result_kind": "exact_controls_for_a_prose_theorem",
        "universal_theorem_verified_by_this_script": False,
        "independent_review": "not_asserted",
        "characteristic_zero_controls": characteristic_zero_controls(),
        "single_factor_false_positive": single_factor_false_positive(),
        "local_controls": records,
        "actual_composite_local_controls": actual,
        "Jacobian_typed_result_replayed": {
            "server": typed["server"]["version"],
            "protocol": typed["protocol_version"],
            "operation": typed["result"]["operation_id"],
            "output": typed["result"]["output"],
        },
        "elapsed_seconds": round(time.monotonic() - started, 6),
    }
    path = HERE / "exact_controls.json"
    save(path, report)
    print(json.dumps({
        "status": "passed", "local_algebras": len(records),
        "complete_periods": complete, "full_coefficient_identities": full,
        "elapsed_seconds": report["elapsed_seconds"],
        "original_counterexamples": sum(
            a["full_modulus_native_result"]["is_counterexample"] for a in actual),
    }))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
