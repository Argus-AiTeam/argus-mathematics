# Result 9400114

## Target-Free Prime-Power Reduction, Short-Arc Cubic Obstructions, and Inverse-Frobenius Classifications for Agrawal's Conjecture

**Status:** `independently_verified` (`publishable_theorem`, `novelty_status=verified_new`)<br>
**Resolved scope:** Target-free radical/multiplicity equivalence for F_n = 0 mod (n, X^r-1), explicit cubic primitive-prime bound p >= max(r^2+2, 1+N(floor((r-1)/4))) ~ r^3/384, and complete inverse-Frobenius cyclotomic norm classification<br>
**Field:** computational and algebraic number theory

## Summary

Agrawal's conjecture predicts that if $n \ge 2$ is coprime to $r$ and $F_n(X) = (X-1)^n - X^n + 1 \equiv 0 \pmod{(n, X^r-1)}$, then either $n$ is prime or $n^2 \equiv 1 \pmod r$. We establish three unconditional structural results on the cyclotomic congruences governing hypothetical counterexamples. First, we prove a target-free prime-power reduction: $F_n(X) \equiv 0 \pmod{(n,X^r-1)}$ if and only if $F_n(X) \equiv 0 \pmod{(\operatorname{rad}(n),X^r-1)}$ and every prime power $p^e \parallel n$ satisfies $e \le w(p,r)$. Second, for odd primes $p$ primitive modulo a prime $r \ge 37$ with $p^2 \mid n$, we classify short-arc rational cross-ratios $R_{x,y,z}(T) = \frac{(1-T^{x+y})(1-T^{y+z})}{(1-T^{x+y+z})(1-T^y)}$ in the finite logarithm $L_p(X)$ to prove the explicit cubic lower bound $p \ge \max\{r^2+2,\ 1 + N(\lfloor(r-1)/4\rfloor)\}$ where $N(M) = \frac{1}{2}(\binom{M}{3} + \lfloor(M-1)^2/4\rfloor) \sim \frac{1}{768}r^3$, whence $n \ge p^2 \gg r^6$. Third, in the index-two cyclotomic quotient $\mathbb{F}_p[X]/\Phi_r(X)$ ($r \equiv 3 \pmod 4$, $\operatorname{ord}_r(p)=(r-1)/2$), we classify all inverse-Frobenius solutions $(X-1)^k \equiv X^{-p^j}-1$ via the norm identity $N(2-X-X^{-1})=r$ and prove that admissible primes have positive natural density for $r=7$.

## Open Boundaries

- Unrestricted squarefree composite counterexamples to Agrawal's conjecture

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_9400114_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_9400114_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `obstruction_theorem.md` | Mathematical proof / verification artifact |
| `zero_propagation.md` | Mathematical proof / verification artifact |
| `projective_obstruction.md` | Mathematical proof / verification artifact |
| `cubic_obstruction.md` | Mathematical proof / verification artifact |
| `verify_short_arc.py` | Mathematical proof / verification artifact |
| `inverse_frobenius.md` | Mathematical proof / verification artifact |
| `verify_inverse_frobenius.py` | Mathematical proof / verification artifact |
| `verification-summary.json` | Structured verification summary |
