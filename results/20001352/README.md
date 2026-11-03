# Result 20001352

## Literal-scope counterexample for commutator width and involution factorization in Thompson's group $F$ (AIMPL Problem 3.1)

**Status:** independently verified literal-scope counterexample / domain correction<br>
**Field:** geometric group theory

AIMPL Problem 3.1 literally includes Thompson's group $F$ alongside the simple groups $T$, $V$, and topological full groups when asking to prove that every element is a product of at most three involutions ($\rho_2 = 3$) and has commutator width one ($\rho_1 = 1$).

In $F$, the explicit dyadic piecewise-linear homeomorphism $f:[0,1]\to[0,1]$ with breakpoints $(0, 1/2, 3/4, 1)$, slopes $(1/2, 1, 2)$, $f(1/2)=1/4$, and additive log-slope endpoint character

$$
\chi(f) = (\log_2 f'_+(0),\ \log_2 f'_-(1)) = (-1, 1)
$$

refutes both literal assertions on $F$:

1. Every orientation-preserving involution of $[0,1]$ is the identity, so no nonidentity element of $F$ is a finite product of involutions.
2. The abelianization homomorphism $\chi: F \to \mathbb Z^2$ vanishes on $[F,F]$, whereas $\chi(f) = (-1,1) \neq (0,0)$, so $f$ is not a finite product of commutators.

## Boundary

This is a domain correction to the literal inclusion of unrestricted $F$ in the problem statement. It does not refute commutator-width bounds restricted to the derived subgroup $[F,F]$, nor the assertions for the simple groups $T$ and $V$.

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_20001352_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_20001352_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `F_counterexample.md` | Proof of the universal order and endpoint-character obstructions on $F$ |
| `f_witness.json` | Exact dyadic piecewise-affine specification of $f$ |
| `verify_f_witness.py` | Exact rational piecewise-affine verifier |
| `test_verify_f_witness.py` | Unit tests for the exact verifier |
| `commutators.result.json` | Commutator obstruction verification output |
| `involutions.result.json` | Involution obstruction verification output |
| `verification-summary.json` | Structured verification summary |
