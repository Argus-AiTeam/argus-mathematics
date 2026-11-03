# Result 2457

## Countermodel to the Arvidsson heat-trace bounded-kernel implication (Erdős Problem #1055)

**Status:** independently verified source-implication countermodel and route boundary<br>
**Field:** spectral theory and analytic number theory

In `viXra:2506.0023v1` (Section 5 Lemma 2 and Section 6 Theorem 1), an attempt on Erdős Problem #1055 / Cunningham chains asserts that for a sequence of positive semidefinite operators $H_N$ with spectral gap $\lambda_1 \ge 3/10$ and kernel dimension $K_N = \dim\ker(H_N)$, the bounded-kernel heat-trace inequalities force an unbounded kernel as $N\to\infty$.

For every fixed integer $K \ge 1$ and every $N \ge K$, the explicit diagonal matrix family

$$
H_N = \mathrm{diag}\bigl(0_K,\ (3/10)I_{N-K}\bigr)
$$

has constant kernel dimension $\dim\ker(H_N) = K$, spectral gap $3/10$, and heat trace $\mathrm{Tr}(e^{-t H_N}) = K + (N-K)e^{-3t/10}$, satisfying every displayed hypothesis while keeping the kernel dimension bounded by $K$.

## Boundary

This refutes only the flawed spectral-transfer implication in `viXra:2506.0023v1`. Erdős Problem #1055 itself remains open.

## Files

| File | Purpose |
|---|---|
| `FINAL_NEGATIVE_REPORT.md` | Exact diagonal countermodel $H_N$ and primary-source audit |
| `ORIGINAL_FRONTIER_NEGATIVE_REPORT.md` | Summary of algebraic and sieve route boundaries for Problem #1055 |
