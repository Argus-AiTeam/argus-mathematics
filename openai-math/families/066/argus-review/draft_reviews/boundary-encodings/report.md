# Encoding the two constraints by effective lc boundaries

**Assessment:** both constructions in `L_LC_ENCODING` v1 meet the
fixed-boundary and effectivity requirements of the rational bridge.
The general-member and snc conditions are load-bearing, not cosmetic.

## Claim, source version and attribution

The claim is that the lc ideal constraint in complements Proposition
`a:exact-penalization` and the finite `h`-lc order constraints in Cartier
Theorem `thm:E-exact-minimizer` admit fixed effective rational Cartier
lc boundaries with exactly the specified zero-discrepancy cones,
preserving their heights there and permitting effective rational
small klt perturbations.

Here “rational Cartier boundary” means a rational combination of
principal Cartier divisors, not that every resulting coefficient is
an integer. The germs are the fixed complex Q-Gorenstein klt germs of
the old proof. The source is `verification.md:398-460`; the matching
manuscript constructions are complements `constrained-minimum.tex`
and Cartier `lem:E-slice-boundary`. Their manifest-aligned hashes are
in the index. This is a reproduction of those constructions.

## Ideal-lc encoding

Suppose `I0,J` are nonzero ideals, `c>0`, `b0>=1`, `c'>=0` rational,
`(X,I0^c)` is lc with a centred quasi-monomial lc place, and

```
A_X <= a=b0*A_X-c'*v(J) <= b0*A_X.
```

Resolve `I0,J,m`. If `I0*O_P=O_P(-D0)`, general members have
divisors `D0+M_i`, with residual free divisors transverse to the
resolved snc support and containing none of its strata. Define
`B0=(c/N)*sum div(f_i)`, choosing `N` with `c/N<1`.
On old components its crepant discrepancies are exactly those of
the ideal pair. Each new moving component has positive discrepancy.
The snc discrepancy formula then shows both lc and equality of the
zero cones, not merely containment of one cone in the other.

Similarly average enough general members of `J` to obtain `BJ`,
with each moving coefficient at most `1/2`. Set
`a_D=b0*A_X-v(BJ)`. On old components the original lower bound is
at least `A_X`; on new moving components the lower coefficient is
`b0-c'/N>=1/2`; the residual log-smooth coefficient is `b0>=1`.
These component inequalities yield

```
A_X/2 <= a_D <= b0*A_X
```

on the working valuation domain. Along every old monomial lc stratum
the residual general members have value zero, so `a_D=a` there.
A unit `J` or empty residual divisor causes no exception.

For the bridge use `Psi=B0`, `alpha=b0` and height `a_D`. Its boundary is

```
Delta_t=(B0+t*BJ)/(1+t*b0).
```

It is visibly effective and rational for positive rational `t`.
The lower bound on `a_D` gives positivity on every normalized lc face,
including noncentred ones. Thus the bridge's hypotheses really hold;
they were not inferred just from the scalar inequality.

## Common-slice encoding

Suppose `(X,div(h))` is lc, `F_j!=0`, `m_j` are positive integers,
and the common rays satisfy

```
A_X(v)=v(h)>0,    v(F_j)>=m_j*v(h).
```

Take rational `theta_j>0` with `sum theta_j<1` and ideals
`b_j=(h^m_j,F_j)`. Before choosing members their discrepancy is

```
A_X(v)-v(h)
  + sum theta_j*(v(h)-min(v(h),v(F_j)/m_j)).
```

Every summand is nonnegative. It vanishes exactly on the common
lc cone (and at the trivial valuation), since each `theta_j` is
strictly positive. After resolving the pencils, choose sufficiently
general `h^m_j+a_j*F_j`. The residual free divisors have coefficients
`theta_j/m_j<1`, meet the support transversely, and contain no lc
stratum. Thus

```
Psi=(1-sum theta_j)*div(h)
       + sum (theta_j/m_j)*div(h^m_j+a_j*F_j)
```

is effective, rational and lc, with precisely the same zero cone.
On that cone each pencil member has value `m_j*v(h)`.
This avoids a cancellation error that would arise from arbitrary,
rather than sufficiently general, choices of `a_j`.

For an allowed rational height
`b=b0*v(h)-sum b_l*v(G_l)`, `b_l>=0`, positive on the entire
normalized common slice, use `alpha=0` and boundary

```
Psi_lambda=Psi-lambda*b0*div(h)
                  +lambda*sum b_l*div(G_l).
```

The positive initial coefficient `1-sum theta_j` of `div(h)`
ensures effectivity for sufficiently small `lambda`; the added
coefficients are nonnegative. Positivity on the compact slice
provides the zero-component klt test. The bound is uniform for a
fixed compact positive family with bounded `b0`.

## Evidence and limits

The exact-version prior support is
`judgement-L_LC_ENCODING-0082a463d56d` by
`reviewer:dccb8f343ba8` on the unchanged proof draft. The present
reading checks the fixed component, moving component, equality-cone
and effectivity arguments explicitly. No numerical experiment or
Lean theorem verifies a general-member construction.

The geometric background is resolution/principalization and
characteristic-zero Bertini/transversality for finitely many strata,
together with the log-smooth discrepancy and monomial-retraction
formulas. The fixed-resolution setup is an assumption of this
reviewed argument; it is not formalized. Ordinary klt minimization
is used only after these boundaries have been constructed.

No concrete gap was found under these hypotheses. Arbitrary pencil
members, irrational coefficients passed to the stated rational-pair
input, and omission of face positivity are not certified variants.
Neither manuscript's remaining degeneration or global geometry is
settled by this unit.
