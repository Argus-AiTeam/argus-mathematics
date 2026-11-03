# Result 20001849

## Flying wings refute uniqueness of the collapsed product steady Ricci soliton (AIMPL Problem 6.7)

**Status:** independently verified theorem-backed counterexample<br>
**Field:** differential geometry and Ricci flow

AIMPL Problem 6.7 asks whether the cylinder product $\mathbb R \times \Sigma_{\mathrm{cigar}}$ is the unique collapsed three-dimensional steady gradient Ricci soliton.

Using Lai's $O(2)$-symmetric flying-wing theorem (`arXiv:2010.07272v2`, Theorem 1.1 and Corollaries 1.3 and 1.5) specialized to dimension $n=3$ and asymptotic angle $\alpha = 1/2$, this package certifies an explicit complete, connected, three-dimensional steady gradient Ricci soliton $(M^3, g, f)$ such that:

- $(M^3, g)$ is collapsed at all scales under the curvature-controlled spatial collapse convention of Lai Definition 3.4 (for every $\kappa > 0$, first-exit curvature control along the asymptotic $S^1$ fibers yields balls of radius $r_j$ with $|\mathrm{Rm}| \le r_j^{-2}$ and $\mathrm{Vol}(B(p_j, r_j))/r_j^3 < 32/j < \kappa$);
- $(M^3, g)$ has strictly positive Ricci curvature everywhere ($\mathrm{Ric} > 0$), which obstructs any isometry to $\mathbb R \times \Sigma_{\mathrm{cigar}}$ (whose $\mathbb R$-factor lies in $\ker(\mathrm{Ric})$).

## Boundary

AIMPL Problem 6.7 does not print an explicit definition of "collapsed"; this result holds under Lai's Definition 3.4 all-scales spatial collapse convention and imports Lai's PDE existence and asymptotic convergence theorems while certifying the exact algebraic/metric comparison steps.

## Files

| File | Purpose |
|---|---|
| `flying-wing.md` | Complete proof of completeness, all-scales spatial collapse, and positive-Ricci non-isometry |
| `classification-probe.md` | Source alignment and collapse convention analysis |
| `replay.py` | Exact symbolic/rational verifier for the curvature, volume-ratio, and Ricci-kernel steps |
| `replay-result.json` | Recorded replay output |
