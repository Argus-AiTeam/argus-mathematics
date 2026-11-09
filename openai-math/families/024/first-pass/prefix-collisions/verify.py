#!/usr/bin/env python3
"""Replay exact arithmetic and check the recorded universal Lean certificate."""

import hashlib
import json
import math
from fractions import Fraction as Q
from functools import lru_cache
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = (
    ROOT
    / "research/openai_manuscript"
    / "An-asymptotic-formula-for-the-number-of-totients-September-25-2026"
    / "build/source"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def source_bindings():
    proposition = r"""
\begin{proposition}[Prefix collisions]\label{prop:collisions}
Fix $c>1$, and form all parameters from $x$, with $H$ fixed before $x$
tends to infinity.  For $t=x$ or $t=x/c$, let
\[
 K(t)=\#\{(\tau,\sigma)\in\mathcal G(t)^2:
             \tau\ne\sigma,\ F(\tau)=F(\sigma)\}.
\]
There is a quantity $\epsilon_H\to0$, independent of the phase, such that
\[
 K(t)\le\bigl(\epsilon_H+o_{x;H}(1)\bigr)
                   \frac{xG_m}{\log x}.
\]
The pairs counted here are ordered pairs of distinct tuples.
\end{proposition}
"""
    collision_source = (SOURCE / "collisions.tex").read_text()
    start = collision_source.index(r"\begin{proposition}[Prefix collisions]")
    end = collision_source.index(r"\end{proposition}", start) + len(r"\end{proposition}")
    require(
        " ".join(collision_source[start:end].split()) == " ".join(proposition.split()),
        "The complete target proposition changed",
    )
    passages = {
        "collisions.tex": [
            proposition.strip(),
            r"(h+1)^{\Omega(D_i)+\Omega(D_i')}",
            r"\exp\{2b_i\log(h+1)/h^8\}",
        ],
        "extraction.tex": [
            r"\label{eq:good-conditions}",
            r"\Omega(D_i)\le b_i/h_i^8",
            r"\sum_{r=i+1}^L a_{r-i}u_r\le(1-h_i^{-4})u_i",
            r"\mathcal D(t)=\mathcal T(t)\setminus\mathcal G(t)",
        ],
        "statements.tex": [
            r"a_j=(j+1)\log(j+1)-j\log j-1",
            r"\sum_{j\ge1}a_j\rho^j=1",
        ],
    }
    for filename, snippets in passages.items():
        text = " ".join((SOURCE / filename).read_text().split())
        for snippet in snippets:
            require(" ".join(snippet.split()) in text, f"Source changed: {filename}: {snippet}")
    return passages


def log_unit_interval(x, terms=40):
    require(Q(1) <= x <= Q(2), "Log series argument outside [1,2]")
    t = (x - 1) / (x + 1)
    lower = 2 * sum((t ** (2 * j + 1) / (2 * j + 1) for j in range(terms)), Q(0))
    tail = 2 * t ** (2 * terms + 1) / ((2 * terms + 1) * (1 - t * t))
    return lower, lower + tail


def log_interval(x):
    require(x >= 1, "This verifier only needs logarithms at least 1")
    power = 0
    while x > 2:
        x /= 2
        power += 1
    lower, upper = log_unit_interval(x)
    l2, u2 = log_unit_interval(Q(2))
    return lower + power * l2, upper + power * u2


def enclosing_decimal_interval(lower, upper):
    scale = 10**12
    lo = lower.numerator * scale // lower.denominator
    hi = -((-upper.numerator * scale) // upper.denominator)
    return {"lower": f"{lo}/{scale}", "upper": f"{hi}/{scale}"}


def root_certificate():
    terms = 64
    logs = {j: log_interval(Q(j)) for j in range(1, terms + 2)}

    def series_interval(r):
        lower = Q(0)
        upper = Q(0)
        for j in range(1, terms + 1):
            l1, u1 = logs[j]
            l2, u2 = logs[j + 1]
            al = (j + 1) * l2 - j * u1 - 1
            au = (j + 1) * u2 - j * l1 - 1
            require(0 < al <= au <= j, "Coefficient interval failed")
            lower += al * r**j
            upper += au * r**j
        tail = r ** (terms + 1) * ((terms + 1) - terms * r) / (1 - r) ** 2
        return lower, upper + tail

    low = series_interval(Q(27, 50))
    high = series_interval(Q(109, 200))
    require(low[1] < 1 < high[0], "Exact root bracket failed")
    lambda_lower = log_interval(Q(200, 109))[0]
    lambda_upper = log_interval(Q(50, 27))[1]
    require(Q(3, 5) < lambda_lower <= lambda_upper < Q(2, 3), "Lambda bounds failed")
    return {
        "rho_open_interval": ["27/50", "109/200"],
        "series_terms": terms,
        "F_at_27_over_50": enclosing_decimal_interval(*low),
        "F_at_109_over_200": enclosing_decimal_interval(*high),
        "tail_majorant": "sum_{j>N} j*r^j = r^(N+1)*((N+1)-N*r)/(1-r)^2; a_j<=j",
        "log_interval_method": "atanh series, 40 terms after power-of-two range reduction; positive geometric tail bound",
        "lambda_open_interval": ["3/5", "2/3"],
        "thirty_lambda_open_interval": ["18", "20"],
    }


def uniform_decay_certificate():
    h0 = 4096
    degree = 100
    q = Q(109, 200)
    ratio = (Q(h0 + 1, h0) ** degree) * q
    require(ratio < Q(3, 4), "Uniform ratio bound failed")
    require(
        h0**degree * 109**h0 * 2**1000 < 200**h0,
        "Exact starting bound failed",
    )
    require(30 * math.isqrt(h0) + 1 < h0 // 2, "Layer-count starting bound failed")
    require(Q(11, 10) * q < Q(3, 5) < Q(31, 50), "Next-band separation failed")
    require(Q(9, 10) * Q(99, 100) > Q(22, 25), "Lower-band margin failed")
    require(Q(31, 50) / Q(22, 25) < Q(3, 4), "First cutoff height failed")
    require(Q(9, 10) * Q(99, 100) > Q(3, 4) > Q(7, 10), "Last cutoff margin failed")
    return {
        "quantifier": "every integer h>=4096",
        "dominator": "h^100*(109/200)^h",
        "successive_ratio": "(1+1/h)^100*(109/200) <= (4097/4096)^100*(109/200) < 3/4",
        "initial_bound": "4096^100*(109/200)^4096 < 2^(-1000)",
        "consequence": "the dominator is <=2^(-1000)*(3/4)^(h-4096); every lower-degree polynomial times rho^h tends uniformly to zero",
        "layer_count": "log h<=sqrt(h); 30*sqrt(h)+1<h/2 for h>=4096",
        "rational_cost_ratios": ["log(h)/h^4 <= 1/h^3", "log(h)*log(log(3*h))/h^14 <= 1/h^12 for h>=2"],
        "not_claimed": "4096 is not an effective H0 for Ford's theorem or its unspecified absolute constants",
        "ford_last_cutoff": "log_2(V_b)=3*b_{i+J}/4 > 7*b_{i+J}/10=log_2(z)",
        "ford_dummy_factor": "ell=1, f_1=1, including b=1",
    }


def prime_powers(n):
    require(n >= 1, "Residuals must be positive")
    factors = []
    p = 2
    while p * p <= n:
        exponent = 0
        while n % p == 0:
            n //= p
            exponent += 1
        if exponent:
            factors.append((p, exponent))
        p += 1
    if n > 1:
        factors.append((n, 1))
    return factors


@lru_cache(maxsize=None)
def ordered_factorizations(n, slots):
    if slots == 1:
        return ((n,),)
    return tuple(
        (d,) + rest
        for d in range(1, n + 1)
        if n % d == 0
        for rest in ordered_factorizations(n // d, slots - 1)
    )


def factorization_count(n, slots):
    return math.prod(math.comb(e + slots - 1, e) for _, e in prime_powers(n))


def recovery_checks():
    checked = 0
    for n in range(1, 97):
        for slots in range(1, 6):
            factorizations = ordered_factorizations(n, slots)
            exact = factorization_count(n, slots)
            require(len(factorizations) == len(set(factorizations)) == exact, "Ordered enumeration mismatch")
            require(all(math.prod(f) == n for f in factorizations), "Incorrect factorization")
            omega = sum(e for _, e in prime_powers(n))
            require(exact <= slots**omega, "Recovery inequality failed")
            checked += 1
    left = ordered_factorizations(360, 3)
    right = ordered_factorizations(72, 4)
    require(len(left) == 180 and len(right) == 200, "Repeated-prime examples failed")
    require(len(left) * len(right) == 36000 <= 5**11, "Two-residual bound failed")
    stress_count = math.comb(136, 100)
    require(stress_count <= 37**100, "Prime-power stress test failed")
    return {
        "universal_evidence": "Main.lean: mem_factorizations_iff, ordered_factorizations_bound, two_residuals_bound",
        "finite_diagnostic_only": {"integers": [1, 96], "slots": [1, 5], "cases": checked},
        "repeated_prime_example": {
            "left": {"n": 360, "slots": 3, "omega": 6, "ordered_count": 180},
            "right": {"n": 72, "slots": 4, "omega": 5, "ordered_count": 200},
            "pair_count": 36000,
            "common_slot_bound": 5**11,
        },
        "prime_power_stress": {"n": "2^100", "slots": 37, "count": str(stress_count), "bound": "37^100"},
    }


def jacobian_check():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    operation = "integer.compute.prime_factorization"
    require(response["request"] == {"operation_id": operation, "payload": payload}, "Jacobian source mismatch")
    require(response["result"]["operation_id"] == operation, "Jacobian operation mismatch")
    output = response["result"]["output"]
    require(output["status"] == "COMPLETE", "Jacobian did not complete; no conclusion is available")
    actual = [(int(f["prime"]), f["power"]) for f in output["factors"]]
    require(output["value"] == payload["value"] == "360", "Jacobian integer mismatch")
    require(actual == prime_powers(360), "Independent factorization replay failed")
    return {
        "operation_id": operation,
        "protocol_version": response["protocol_version"],
        "server_version": response["server"]["version"],
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_result.json",
        "contract_file": "jacobian_contract.json",
        "adapter_status": "COMPLETE",
        "adapter_error": None,
        "timeout": False,
        "use": "one repeated-prime residual example; not an asymptotic or universal proof",
    }


def lean_check():
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result["exit_code"] == 0 and result["status"] == "success", "Lean compiler did not succeed")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "Unexpected Lean version")
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    require(hashlib.sha256(source).hexdigest() == result["source_sha256"], "Lean source changed after compilation")
    require(
        hashlib.sha256(fidelity.encode()).hexdigest() == result["statement_fidelity_sha256"],
        "Statement fidelity changed after compilation",
    )
    return {
        "result_file": "lean_check.json",
        "exit_code": 0,
        "proof_holes": [],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "scope": "universal finite combinatorics only; analytic transfer is proved in proof.md",
    }


def main():
    certificate = {
        "schema_version": 1,
        "claim": "C_PREFIX_COLLISIONS",
        "result": "source-bound proof of the quantitative ordered collision-transfer theorem (T)",
        "classification": {
            "analytic_argument": "prose proof using Ford 1104.3264v2 Lemma 5.1",
            "formal_result": "universal ordered residual recovery and endpoint restriction",
            "finite_experiments": "diagnostics, not proofs of the asymptotic theorem",
            "independent_review": "required; not performed by this script",
            "novelty_status": "not_established_by_engineer",
            "full_manuscript_certified": False,
        },
        "source_bindings": source_bindings(),
        "root": root_certificate(),
        "uniform_decay": uniform_decay_certificate(),
        "tuple_recovery": recovery_checks(),
        "jacobian": jacobian_check(),
        "lean": lean_check(),
        "proof": "proof.md, equations (1)--(23)",
        "remaining_external_inputs": [
            "Ford 1104.3264v2 Lemma 5.1, with all original application hypotheses checked",
            "classical Mertens unit-box prime-sum estimate; the Euler-product and prime upper bounds are derived in proof.md",
        ],
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "status": "exact_checks_passed",
        "certificate": "research/prefix-collisions/exact_certificate.json",
        "finite_diagnostic_cases": certificate["tuple_recovery"]["finite_diagnostic_only"]["cases"],
        "universal_recovery": "Lean, no proof holes",
        "independent_review": "pending",
    }))


if __name__ == "__main__":
    main()
