# Nodal scope and bound

**Assessment:** supported as a mathematical argument for the stated nodal
lemma and as rejection of two inapplicable Argus attacks. This is not a
refutation of a manuscript, a new theorem beyond the old draft, or native
independent Reviewer acceptance.

## Exact assertions, hypotheses and attribution

This unit covers historical `C_RS_SCOPE@v1` and `C_RS_NODE@v1`. The primary
old argument is `9000039/research/reshaping_audit/report.md`, sections
"Statement and source fidelity" and "The nodal bound, including
characteristic two". Its report and historical ledger have matching
`reviewer:reshaping-audit` supporting judgements; these are reused as
historical evidence, not substituted for acceptance of this review.

The target sources are the positive-characteristic manuscript's
`build/build/sections/04-reshape.tex:46-59,73-84`
(`lem:nodal-bound`) and `02-transfer.tex:225-259`
(`lem:compression`). The staged edition is identified by the existing
`9100039/MANUSCRIPTS.json`, upstream revision
`4eaee87548250b2682affda7d05d947c05554bae`. The source-reading unit
`../companion-trace/report.md` records matching file contents, exact
excerpts, and independently confirmed source-text assumptions
`C_REVIEW/A_PC_TARGET` and `C_REVIEW_SCOPE/A_PC_SCOPE`.
The manuscripts supply the construction being assessed; the old Argus
draft supplies this self-contained reconstruction. No literature-priority
claim is made.

Let `A,B>0`, `H=AB`, `d=max(3/A,2/B)`, `W=dH=max(2A,3B)`,
and `c=1/d`. For any real `t>0`, order nonnegative exponents by
`(alpha+t beta,beta)` lexicographically. Write the resulting least
exponent as `nu_t`.

The exact nodal assertion is: for every real `kappa>=0` and nonzero
polynomial `f` supported in `kappa Delta(A,B)`, its expansion in the
formal node coordinates has

```text
nu_t(f) in kappa conv{(0,0), (Wt/(1+t),0), (1/d,1/d),
                        (0,W/(1+t))}.
```

The ambient reshaping theorem fixes an algebraically closed field, of any
characteristic. The algebra of this lemma works over an arbitrary field.
There is no rational-intercept assumption, and the zero residual degree
is included. This statement does not concern a general singular curve,
or an arbitrary equation chosen in characteristic two.

## Decisive argument

### The actual node and its formal coordinates

The polynomial is `g=y^2+xy-x^3`, not the complex companion's
`y^2-x^2(1+x)`. Solve `r^2+r=x` recursively with constant term
`r_1(0)=0` or `r_2(0)=-1`. At each coefficient, the multiplier of
the new unknown is respectively `1` or `-1`, never zero, including
in characteristic two. Thus both formal roots exist, their sum is
`-1`, and their product is `-x`.

Set `eta=y-x r_1(x)` and `xi=y-x r_2(x)`. Their linear parts
are `y` and `y+x`; hence the coordinate substitution has invertible
linear part and a formal inverse obtained recursively by total degree.
Furthermore `xi eta=g`. Characteristic two does not identify `0`
and `-1`, nor the linear forms `y` and `y+x`.

The parametrization `x=v(v+1)`, `y=v^2(v+1)` has kernel exactly
`(g)`. Indeed, division by the monic polynomial `g` in `y`
leaves `a(x)+y b(x)`. Under parametrization, the two nonzero
summands have highest degrees `2 deg(a)` and `3+2 deg(b)`;
one is even and the other odd. They cannot cancel in any
characteristic. This proves injectivity of `k[x,y]/(g)` into
`k[v]`, not just a numerical test of the parametrization.

### Factor extraction and the two branch orders

Write `f=g^e f_0`, with `g` not dividing `f_0`.
Weighted degree for weights `(1/A,1/B)` is additive: the product
of the highest-weight forms is nonzero in a polynomial domain.
The three weights in `g` are `2/B`, `1/A+1/B`, and `3/A`;
the middle one is at most `5d/6`, and the maximum is `d`.
Consequently

```text
ed <= kappa,
deg_(A,B)(f_0) <= kappa-ed,
deg f_0(v(v+1),v^2(v+1)) <= W(kappa-ed).
```

The last polynomial is nonzero by the kernel calculation. Both branch
restrictions are therefore nonzero. Near `v=0` and `v=-1`, the
surviving formal coordinates have order one: `x=v(v+1)` has a
simple zero at each point, and `r_1-r_2` has nonzero constant
term there. These two points remain distinct in every characteristic.

If `nu_t(f_0)=(alpha,beta)` and `mu=alpha+t beta`,
every term has weight at least `mu`. Restricting to the two
coordinate branches gives orders at least `mu` and `mu/t`.
Orders at two distinct roots of a nonzero polynomial add to at most
its degree. Thus

```text
(1+1/t) mu <= W(kappa-ed).
```

With `a=Wt/(1+t)` and `b=W/(1+t)`, this is precisely
`alpha/a+beta/b <= kappa-ed`. In particular
`nu_t(f_0)` belongs to `(kappa-ed) Delta(a,b)`.
The order is additive on products, so
`nu_t(g^e)=(e,e)=ed(c,c)`. Adding these two contributions
places `nu_t(f)` in the stated dilated convex hull. This uses
convexity with total coefficient `kappa`, not a restriction to
integer residual degrees. If `kappa=0`, only a nonzero constant
is possible, so its least exponent is `(0,0)`.

Positive weights give finitely many lattice exponents below any fixed
weight. The order used above is therefore a genuine additive well-order;
the least-term and product arguments do not assume convergence of an
analytic series.

## The failed attacks, separately dispositioned

**Branch-coincidence attack:** invalid as an attack on this source.
The complex node and its square-root presentation belong to a complex
companion. Applying that equation in characteristic two does not change
the equation actually used in the positive-characteristic manuscript.
The recursive and determinant arguments above dispose of the alleged
coincidence for the actual node. They do not prove any main theorem.

**Consecutive-compression attack:** invalid as an attack on the stated
compression lemma. In characteristic `p`,
`z^p-1=(z-1)^p`, so `span{1,z^p}` has orders `{0,p}` at
one, not `{0,1}`. The cited source expressly permits this and uses
only the interval-length bound `[0,p]`. Finding this gap reproduces
an allowed example, rather than a counterexample to its assertion.
Both dead routes and their mathematical reasons are recorded in the
active ledger; no further attack search is authorized.

## Evidence boundary and remaining obligations

The fresh Jacobian result in `../finite-certificates/` checks only
the rank-two linear matrix `[[1,1],[0,1]]` over the prime field
of characteristic two. Its determinant is also manually `1`.
It does not certify the formal recursion, the kernel of the
parametrization, the weighted-degree estimate, or the branch-order
argument; those were checked above in prose. The finite Python node
identities are bounded checks, not the proof for all series or degrees.
There is no Lean formalization of this nodal lemma in the old draft.

No unproved external mathematical proposition is needed for the
argument just given: coefficient recursion, polynomial division,
weighted leading forms, and root multiplicity supply its steps.
The cited source assumptions concern what the target text says,
not an assumption that its theorem is true.

There is no identified gap in these two assertions within this exact
scope. Jet-rank specialization, multiplicativity through subsequent
compressions, and the final all-degree geometry are separate obligations
assessed in the other units. Downstream maximality and the separate
Nagata proof remain unresolved here. The strongest existing prior claim
is already `dw<1/3` with mixed-order rank transfer; this unit neither
improves it nor claims novelty.

**Acceptance:** `pending_native_independent_review`.
