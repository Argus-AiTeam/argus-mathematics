# Result 9400114

## Prime-power and shared-order cofactor exclusions for Agrawal's conjecture

**Status:** independently verified scoped exclusion certificates<br>
**Field:** computational number theory and primality testing

Agrawal's conjecture asks whether two coprime integers $n, r \ge 2$ satisfying

$$
(X - 1)^n \equiv X^n - 1 \pmod{(n, X^r - 1)}
$$

must satisfy either $n$ is prime or $n^2 \equiv 1 \pmod r$.

This package archives two exact certified family exclusions:

1. **Prime-power exclusion ($e \ge 2$):** for every odd prime $p \le 100{,}000$ and every $r \in \{5,7,11,13,17,19,23,29,31\}$ with $p \nmid r$, all $16$ modulo-$p$ norm survivors have nonzero modulo-$p^2$ polynomial coefficient residuals, excluding every prime power $p^e$ ($e \ge 2$) in that range.
2. **Shared-order cyclic and order-three Frobenius subset exclusions:** across all $12{,}286$ shared-order prime-subset candidates and the order-three Frobenius free-prime completion pools, every subset satisfying the modular Korselt/Frobenius conditions forces $n^2 \equiv 1 \pmod r$.

## Boundary

These are finite-family and bounded-parameter exclusions; the unrestricted Agrawal conjecture remains open.

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_9400114_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_9400114_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `prime_power_lift.md` | Prime-power modulo-$p^2$ obstruction analysis |
| `cofactor_construction.md` | Shared-order cofactor construction analysis |
| `coordinated_subset.md` | Coordinated prime-subset analysis |
| `free_prime_completion.md` | Order-three Frobenius free-prime completion analysis |
| `coupled_factor_method.md` | Coupled-factor completion method |
| `bounded-route-replay.json` | Bounded route replay certificate |
| `shared-order-generated-replay.json` | 12,286-subset shared-order exclusion certificate |
| `order-three-free-prime-replay-final.json` | Order-three free-prime completion certificate |
| `verify_candidate.py` | Exact polynomial congruence verifier |
| `replay_boundary.py` | Standalone boundary replay verifier |
| `verification-summary.json` | Structured verification summary |
