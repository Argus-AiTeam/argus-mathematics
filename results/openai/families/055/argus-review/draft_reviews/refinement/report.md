# C55_REFINEMENT: the explicit fifth-step square

**Engineer assessment: `conditionally_supported_written_proof`.** The
radius `1/500000` follows from an actual common-heart argument and the
correct combined endpoint estimate. It is not inferred from realizability
of arbitrary numerical classes or from matrix periodicity.

## Exact claim, hypotheses, version, and attribution

At `u=uG`, let `U_eta` be the actual bounded aisles of the preceding unit.
Assume its **independent-parameter** comparison on the square of radius
`1/4000`, heart positivity for `N_eta=d+c/2+uG*r+eta1*c+eta0*r`,
and exclusion of nonzero zero-class heart objects. Also use the categorical
relation for the ordered exact autoequivalence
`Phi=T_OX o (- tensor OX(1))`, namely `Phi^5 is naturally isomorphic to [2]`.
Then for arbitrary independent endpoints
`abs(alpha_j),abs(beta_j)<1/500000`,

```text
Phi^3 U_alpha subset U_beta[1].
```

Consequently `V_k^eta=Phi^m U_eta[j]`, `k=2m+5j`, is well-defined and
`V_(k+1)^alpha subset V_k^beta`,
`V_(k+5)^eta=V_k^eta[1]`, `Phi V_k^eta=V_(k+2)^eta`.

This is historical C55_REFINEMENT v1, in section 6 of the read-only old
Gepner report. Reference `grid.tex`, `prop:fine-grid`, at revision
`4eaee87548250b2682affda7d05d947c05554bae` proves an existential
refinement square by compactness. The old draft replaces that step by
an explicit separation estimate, without changing the construction.
This is a proposed strengthening relative to that supplied version,
not a verified novelty claim.

The separate source reader checked **Toda arXiv:1305.0345v3, section
3.3 after (13)**, including Theorem 2.5 and identity (5) as its stated
reason for the categorical relation. It is not conditional on the
existence of a Gepner stability condition. See
[sources.json](../sources/sources.json) and
[the passage](../sources/toda_1305.0345v3.txt). The proof of the external
relation and the manuscript's alternative kernel appendix are not
newly audited here.

## Decisive argument

Write `D_i^eta=Phi^i U_eta`. For an actual object

```text
E in D_3^alpha intersect (D_0^beta[1])^perp,
```

coarse independent nesting puts `E` in both endpoint hearts. For each
`i=1,2` and **every** `gamma` in the fixed enlarged comparison square,
`D_3^alpha subset D_i^gamma subset D_0^beta` supplies aisle membership,
while `D_i^gamma[1] subset D_0^beta[1]` supplies right orthogonality.
Thus the common-heart assertions do not assume the desired refined
inclusion, and the middle parameters need not approach the endpoints.

Let `v=[E]`, `w=M^-1*v`, `x=N(w)`, `y=N(M^-1*w)`,
`X=abs(r(w))+abs(c(w))`, and let `T` be the sum of the two endpoint
rank/first-character absolute norms. Common-heart positivity gives
`x,y>=0`. Four middle tests at `gamma_j=+/-1/8000`, strictly inside
the enlarged square, give `X/8000<=x`.

The exact coordinate map `w -> (r(w),c(w),x,y)` has determinant `5*uG!=0`.
The endpoint coefficient bounds give column sums `(9,16,12,24)`, hence

```text
T <= 16X+24(x+y) <= 128024(x+y).
```

For `N_i=N(M^-i*v)` the circuit is
`N0+(5*uG-1)*x+(5*uG-1)*y+N3=0`,
with `5*uG-1>=7/20`. The actual endpoint tests give errors
`h*R0` and `h*R3`, where `T=R0+R3`, so
`N0+N3>=-T/500000`. Therefore

```text
(7/20)(x+y) <= T/500000 <= (128024/500000)(x+y).
```

The gap is `1468/15625>0`. It forces `x=y=X=0`, whence invertibility
forces `v=0`. Actual endpoint-heart zero-class exclusion then gives
`E=0`; numerical vanishing alone would not have sufficed.

To pass from this zero intersection to the **aisle inclusion**, truncate
`E in D_3^alpha` with respect to `D_0^beta`:
`A -> E -> H^0(E) -> A[1]`, with `A in D_0^beta[1]`.
Categorical periodicity, not `M^5=I`, puts
`A[1] in D_0^beta[2]=D_5^beta subset D_3^alpha`.
Extension closure puts `H^0(E)` in the zero intersection. Thus
`H^0(E)=0` and `E in D_0^beta[1]`.

Finally the two representations of `k=2m+5j` differ by `(5q,-2q)`,
which act trivially by the categorical relation. Transporting
`V_1^alpha=Phi^3 U_alpha[-1] subset U_beta` proves independent nesting
at every grid index.

## Supported scope and concrete boundaries

The exact checker verifies the circuit residual, determinant, endpoint
interval bounds, the radius comparisons, and the strict scalar margin.
The current Lean declaration uses the **combined** endpoint hypothesis
just derived. The false historical version-1 scalar formulation with
two separate full-`T` budgets is assessed in [core](../core/report.md);
its countermodel violates the correct combined premise and therefore
does not attack this object-level proof.

No missing internal implication was identified in the current conditional
argument. Its substantive dependencies are actual aisle comparison,
positivity and zero-class exclusion, and categorical periodicity. The
compiler proves none of those dependencies. A proof of this unit is
therefore not independent support for the preceding unit or a
standalone full Gepner theorem. Native Host Reviewer acceptance is pending.
