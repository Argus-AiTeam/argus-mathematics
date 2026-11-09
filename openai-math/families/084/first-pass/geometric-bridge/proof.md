# Conditional all-scales control for the actual geometric routing construction

## Statement

Use exactly Sections 3--5 of the staged October 5, 2026 geometric manuscript.
Let real numbers `q,p` satisfy `0<q,p<1`, and let `M>=2`, `d,g,r0>=1`.
Use the manuscript's complete ordered tree, preorder windows, recursive
lengths (in particular **`r1=r0`**), and any allowed first index `n0>=1`
with `2*q^n0<=1/4`. Use its half-open periodic cells and mutually independent
fair selector / Bernoulli-p terminal tables.

Fix a stable real center `x` and a positive-mass atom `xi` of the field
exposing the center address in **every** selector table. Suppose the center
route has a first default at `U`, of height `h`. Set

```
c = 4/(1-q),       r = r_h,       k = (M-1)*r,
L = 1 + k*(1 + 2*c/q^(2*r)).
```

Then the following strengthened version of Lemma conditional-scales holds:

```
P(exists t in [1,2], forall n in N, x+t*q^n not in B | xi)
    <= L*(1-p/2)^k
    <= L*exp(-p*k/2)
    <= D_{M,q}(r)*exp(-p*k/2).
```

This is a parameter-uniform mathematical statement, not an inference from
the finite diagnostics in `exact_certificate.json`. The mathematical
improvement over the manuscript is a representative count
`1 + sum ceil(N_{b_i^*}*q^n)` in place of its boundary-plus-midpoint count.
The main avoiding-set theorem, its open-neighborhood repair, significance,
and independent novelty assessment are not claimed to be certified here.

## 1. Deterministic window arithmetic

An edge and its child subtree are a consecutive preorder block. At height
one its span is `r1`; at greater height it is
`r_h+g+sigma_{h-1}<=2*r_h`, by the defining maximum for `r_h`. This proves
the block-span bound uniformly, without assuming `r0>=g`.

All descendant endpoints lie between the incoming edge endpoint and its
block endpoint. Endpoint order is preorder order, since every window has
positive integer length and every prescribed gap has nonnegative length.
At each strict ancestor of `U`, the chosen nondefault edge and every
earlier sibling edge precede every edge out of `U`. At `U`, edge `j<i`
precedes edge `i`. These facts follow directly from the definition
"edge, then its complete child subtree, then the next sibling block";
they do not depend on selector outcomes beyond which child lies on the
center route.

The upstream `WindowConstruction.windowData` is **not** substituted for
these original windows: its bottom length is `max(r0,g)`, and its interface
requires starts at least three. Neither is an original hypothesis here.

## 2. Rounded grids, stability, and separation

Write `H_b=c/q^b`, `E_b=ceil(log_2 H_b)`, and `N_b=2^E_b`.
Since `H_b>4`, `E_b` is nonnegative, so natural and integer ceiling agree.
Exponentiating

```
log_2(H_b) <= E_b < log_2(H_b)+1
```

gives `H_b<=N_b<2*H_b`. Since `H_b` is nondecreasing, so is `E_b`.
Thus whenever `b<=B`, `N_B/N_b` is a positive integer, possibly one.
The finer periodic key determines the coarser one. This argument allows
equal adjacent resolutions.

For a noninitial window with predecessor endpoint `bprev`, stability
excludes precisely the grid boundaries in `(x,x+2*q^a]`. If `a<=n` and
`1<=t<=2`, then `0<t*q^n<=2*q^a`. The lifted floor at resolution `bprev`
is unchanged. There is no exception at an integer wraparound: integers
are grid boundaries too. A boundary at `x` is permitted because cells
are closed on the left. Refinement then preserves every earlier key.

For one window `[a,b]`, all its points and its center lie in an interval
of length at most `1/4`. A center-to-point distance is at least `q^b`;
for `n<m<=b`, a point-to-point distance is

```
t*(q^n-q^m) >= (1-q)*q^b.
```

Both are strictly larger than the cell width
`1/N_b <= (1-q)*q^b/4`. The corresponding circular distances are the
ordinary distances because all displacements are at most `1/4`.
Therefore the original periodic keys are pairwise distinct, including
points on boundaries. Nesting preserves this distinction at every
descendant's resolution.

## 3. Actual selector and terminal addresses

For trial `(i,n)`, the fresh selector address is the pair
`(e_i,J_{b_i}(x+t*q^n))`. Its table tag separates different `i`;
the preceding separation argument separates different `n` within a
table and separates every trial from that table's center address.
All other exposed center addresses have different table tags. Hence
the **combined** map of all center addresses and fresh trial addresses
is injective.

Fix an arbitrary complete selector realization. Route each trial from
the actual child `U_i`, as in the manuscript, obtaining its actual local
leaf `L_{i,n}`. The terminal address is
`(L_{i,n},J_{b(L_{i,n})}(x+t*q^n))`.

Different child tags give leaves in disjoint child-prefix subtrees.
Different leaves give different terminal tables. For a common leaf
under a common child, `b(L)>=b_i`, and refinement preserves the distinct
keys for different `n`. Thus terminal addresses are injective **for
every selector realization**, even though the leaf selection depends
on all selectors. No terminal bit is consulted to select a leaf.

This establishes the geometric hypotheses of
`FixedScaleProbability.measure_fixed_scale_eq_atom_mass`; it does not
assume those hypotheses as a probabilistic independence shortcut.

## 4. Local success is actual membership

On `xi`, the route of `x`, its first-default vertex, and all selectors
at `x` are fixed. At each strict ancestor the center chooses some
nondefault child `a`: its earlier selectors are zero and its selector
at `a` is one. All these edges precede `e_i`. Section 2 therefore gives
the same values at every point from window `e_i`. Induction along the
center route shows that the trial reaches `U`.

At `U` all exposed selectors are zero. The same earlier-key argument
shows that every child `j<i` is rejected at the trial point. If
`Q_i=1`, its selector at `i` is one, so the actual route enters `U_i`.
Thereafter it is precisely the local route defining `Q_i`; its terminal
bit is one. This is the defining membership condition for `B`.

These are deterministic implications on the original atom, for every
table completion. They use the original one-sided stability condition,
not a stronger two-sided distance-to-boundary assumption.

## 5. A sharper, completion-independent representative construction

Index coordinates by the `k` trials. For trial `(i,n)` let `B_i=b_i^*`
and define the **lifted** integer key

```
f_{i,n}(t) = floor(N_{B_i}*(x+t*q^n)),    1<=t<=2.
```

Each coordinate is nondecreasing. Their sum `s(t)` is an integer between
`s(1)` and `s(2)`. If two scales have the same sum, compare them in the
usual order on the real line. All coordinate differences are
nonnegative integers with sum zero, so every coordinate agrees.

For each attained sum choose one scale attaining it. These choices give
a finite set `R` with

```
|R| <= 1 + s(2)-s(1)
     <= 1 + sum_{i,n} ceil(N_{B_i}*q^n).
```

The last step is the elementary inequality
`floor(A+v)-floor(A)<=ceil(v)`. Importantly, these are lifted floors:
periodic keys themselves are not monotone across a wraparound.
Equal lifted floors imply equal periodic keys at that integer
resolution.

Every grid consulted by `Q_i` is indexed by the incoming edge or a
descendant, hence by an endpoint at most `B_i`. Nested keys therefore
show that equal coordinate keys imply identical `Q_i` values for
**all selector and terminal table completions simultaneously**.
One can prove this directly by induction along the local route: at
each node the entire selector vector agrees, so its selected child
agrees; the final terminal address then agrees as well.

The quantifier order is

```
exists finite R, forall t in [1,2], exists s in R,
    forall remaining table realizations, forall trials,
        Q_i(x+t*q^n) = Q_i(x+s*q^n).
```

`R` and the matching `s` are chosen solely from the real affine floors,
before any remaining table entry. The atom supplies `U`, not any
additional random coordinate of this construction. Endpoints and
boundary scales are included by their attained floor vector; no
generic-position, strict-grid-growth, or boundary-nullness argument
is being used.

For each coordinate, `a_i<=n` and `B_i+1<=a_i+2*r`, so
`B_i<n+2*r`. The resolution estimate gives

```
N_{B_i}*q^n < 2*c*q^(n-B_i) <= 2*c/q^(2*r).
```

Since `ceil(v)<v+1`,
`|R| <= 1+k*(1+2*c/q^(2*r)) = L`.
The original `D=4+2*k*(1+2*c/q^(2*r))` equals `2*L+2`.

## 6. Probability and the final bound

Fix a representative scale on `xi`. Section 3 gives independent fair
fresh selectors under the center conditioning. Next fix **all**
selectors. The actual terminal addresses are then fixed and injective,
so their bits remain independent Bernoulli-p variables. If `A_j` are
the fresh selector bits, the conditional failure probability is
`(1-p)^(sum A_j)`. Averaging over the independent fair selectors gives

```
product_j (1/2+(1-p)/2) = (1-p/2)^k.
```

Equivalently, the upstream exact-mass theorem gives atom mass times
this factor; division is legitimate because the original atom has
positive mass.

A global all-indices miss at any scale forces all local tests to fail
by Section 4, and Section 5 transfers those failures to a representative
fixed before table completion. The finite representative union bound
therefore gives `L*(1-p/2)^k`. Finally
`1-p/2<=exp(-p/2)`, positivity allows raising to the integer power `k`,
and `exp(-p/2)^k=exp(-p*k/2)`. This proves the claimed strengthened
bound and the original lemma.

## Sources and evidence boundary

The authoritative target is the staged geometric manuscript, Sections
3--5, especially labels `stability`, `separation`, `routing`,
`independent-tests`, and `conditional-scales`.

Reusable formal results are in `openai/math` commit
`4eaee87548250b2682affda7d05d947c05554bae`:
`FixedScaleProbability.measure_fixed_scale_eq_atom_mass`,
`ExposureUnionBound.measure_inter_le_of_finite_cover`,
`ScaleDiscretization.exists_affine_floor_representatives`,
`GridSeparation.periodicKey_ne_of_small_shift`, and
`FiniteLocalPredicate.finite_local_predicate_factors`.
Their sources are retained locally under `vendor/`; Lean 4.31 API ports
are listed in `upstream.json`.

The certificate's rational computations are adversarial finite
diagnostics, not proofs of this universally quantified statement.
Compiler coverage must be read from `statement-fidelity.md` and the
fresh native compiler record, not inferred from the presence of
`Main.lean`. Independent Reviewer approval is still required.
