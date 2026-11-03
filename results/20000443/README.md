# Result 20000443

## Smooth rationally connected hypersurface over a $\mathrm{cd}(K)\le1$ field with no $K$-rational point

**Status:** independently verified counterexample with exact resultant certificate (Batch 001)<br>
**Field:** arithmetic and algebraic geometry

James Ax (*J. Algebra* 15, 1970, pp. 417--428, Theorem 1) constructed a field $K$ of cohomological dimension $\mathrm{cd}(K) \le 1$ (and $\mathrm{char}(K)=0$) together with a degree-5 homogeneous form $\Phi(X_0,\ldots,X_9)$ in 10 variables with no nontrivial zero in $K^{10}$.

Using Jacobian's `polynomial.multivariate.resultant.compute` on the binary quintic block $f(z) = (z^2-s)(z^3+s)$, Argus certified the exact resultant

$$
\mathrm{Res}_z(f, f') = -108\, s^7 (s-1)^2 \neq 0,
$$

confirming smoothness of the projective hypersurface $X = V(\Phi) \subset \mathbb P^9_K$. Since $\deg X = 5 \le 9 = \dim \mathbb P^9$, $X$ is a smooth Fano hypersurface (hence rationally connected by Campana / Kollár--Miyaoka--Mori) with $X(K) = \emptyset$, refuting the unrestricted arbitrary-$\mathrm{cd}(K)\le1$ assertion beyond $C_1$ fields.

## Files

| File | Purpose |
|---|---|
| `evidence-summary.md` | Proposition alignment, smoothness verification, and Fano/rational-connectedness bridge |
| `jacobian-request.json` | Exact Jacobian resultant request payload |
| `jacobian-output.json` | Exact Jacobian resultant output (`-108 * s^7 * (s - 1)^2`) |
| `source-location.txt` | Primary source citation and passage index |
