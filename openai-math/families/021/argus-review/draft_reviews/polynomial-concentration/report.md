# Polynomial concentration from congruence lattices

**Engineer assessment: supported as a prose proof with one formal arithmetic
lemma.** The proof constructs a nonzero polynomial; it does not assume
concentration as an input or require a common prime set for all points.

## Exact claim, source, and attribution

Historical claim `C_INVERSE_POLYNOMIAL` v1 is assessed against
`9000021/research/inverse_certificate/REPORT.md`, "Obtaining the polynomial:
no assumed concentration", and the corresponding algebraic-concentration
paragraphs of the staged `inverse.tex`. The latter belongs to the manuscript
dated September 25, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`.
This is a reconstruction of its coefficient-lattice/prime-product argument,
related in the manuscript to Walsh's method; no originality is established.
The active claim is `R_POLYNOMIAL`.

Let `P` be distinct primes at least `R>=2`, with finite slope sets `T_p`
and classes `a_p`. Let the selected integer points lie in `[0,S]^2`, `S>=1`,
each incident to at least `r` distinct primes through a permitted line
`Y=a_p-sX (mod p)`. For a natural degree `d`, set

```
v=(d+1)*(d+2)/2,
J_index=product_p p^((d+1)*|T_p|).
```

If an integer `h>=1` satisfies

```
(h+1)^v > J_index, v*h*S^d < R^r,              (6)
```

there is a nonzero integer polynomial of total degree at most `d`,
coefficients of absolute value at most `h`, vanishing at every selected
point. No density statement beyond the pointwise incidence threshold is
being asserted.

## Decisive argument

The `v` monomials form a free integer coefficient module. Substituting
`Y=a_p-sX` gives a univariate polynomial of degree at most `d`; requiring
all its coefficients to vanish modulo `p` imposes at most `d+1`
homogeneous linear congruences for that slope. The combined map to the
finite residue modules has kernel of index at most `J_index`. Dependencies
between congruences reduce the image and cannot invalidate this upper bound.

The box `[0,h]^v` contains `(h+1)^v` coefficient vectors, more than the
index. Two distinct vectors have the same image. Their difference is
nonzero, has coefficient absolute values at most `h`, and is in every
congruence kernel. Distinct formal monomials ensure a nonzero vector is a
nonzero polynomial. This addresses both existence and nontriviality.

At any selected point, its own incident primes divide the polynomial value.
They need not be incident to any other point. Their distinctness makes them
coprime, so their product, at least `R^r`, divides that integer. There are
at most `v` monomials and each has size at most `S^d`; hence the value's
absolute value is at most `v*h*S^d`. The strict inequality in (6) makes a
nonzero divisible value impossible.

`prime_product_forces_zero` in `Main.lean` proves this last divisibility/size
criterion for an arbitrary integer and pairwise-coprime finite factors.
It does **not** encode the monomial module, substitution constraints, index
estimate, coefficient-box pigeonhole argument, or evaluation bound.
The old statement-fidelity note is correct about that boundary.

## Quantitative bridge and replay

In the manuscript regime the primes also obey `p<=2R`. Choosing
`h=ceil(J_index^(1/v))` gives

```
log(2h) <= log 4 + 2*K*log(2R)/(d+2),
```

because `(d+1)/v=2/(d+2)`, and `ceil(x)<=2x` for `x>=1`.
With `d=floor(R/L^2)` and `K<=n*R/L^6`, `n=O(R/log R)`, this is
`O(R/L^4)`. Consequently the evaluation logarithm is `O(R/L)=o(R)`,
while `r*log R` is at least a positive fixed-`xi` multiple of `R`.
This uses the original order of choices, not a bound uniform as `xi`
tends to zero with `z`. The full analytic bridge is assessed separately
in [inverse-application](../inverse-application/report.md).

The unchanged exact replay's complete small fixture has `d=1`, `v=3`,
`h=12000`, primes `101,103,107`, points with `q=2,3,5`, and `b_q=1`.
It verifies

```
(h+1)^v = 1728432036001 > 1239038360641 = J_index,
v*h*S^d = 180000 < 1030301 = R^r.
```

The polynomial `Y-1` satisfies the constraints. This is a finite existence
fixture, not exhaustive verification of the universal pigeonhole theorem.
The fresh Lean run also checks the unchanged zero criterion, with the
toolchain and certificate recorded in
[finite-rigidity/report.md](../finite-rigidity/report.md).
No separate new run of the same source was necessary for this unit.

No concrete gap was identified in (6)'s implication. Its prose construction
and quantitative application still require the native independent reading;
compilation of the zero criterion alone cannot close those obligations.
