# Localization audit: exact scope and shrinking-neck test

## Status and source

This is an incomplete audit, not a refutation or a verification of the full
localization theorem. No false assertion in the manuscript has been established.
The exact result below excludes one proposed shrinking-neck attack. It does
not settle the manuscript's classification theorem or meet the campaign's
publishable-result stopping criterion.

The target is the September 24, 2026 normal-projective manuscript staged at
`research/openai_manuscript/Semialgebraic-universal-covers-of-normal-projective-varieties-September-24-2026/build/`.
The relevant statements are `sections/localization.tex`, Lemma `loc:paths`
and Theorem `loc:theorem`; the open kernel is defined in
`sections/preliminaries.tex`, Definition `prep:kernel`. Theorem
`win:construction` in `sections/windows.tex` invokes `loc:theorem` for
bounded-path retention. This use is one bridge in the proof of
`thm:main`, not an equivalence with the classification theorem.

No prior localization result was present in the campaign's initial claim
ledger. The shared Wiki index contained no localization, normal-projective,
or shrinking-neck entry. This is a statement about that index, not a
literature-completeness or novelty claim.

## The assertions being tested

**Controlled paths.** A bounded globally subanalytic family
`D subset U x (0,epsilon) x R^n` has open fibers. Bounded subanalytic
sections `v,w` lie in the same component of every fiber. Locally at generic
`x0`, the assertion is the existence of connecting paths `F_t(x,a)` whose
dependence on the real center `x` extends holomorphically to one fixed
complex neighborhood. On a smaller neighborhood both their sizes and their
Lipschitz constants in `a` are bounded independently of `t`. All fixed
orders of center derivatives obey analogous bounds. Neither the new paths
nor their timing is required to be subanalytic.

The section's convention that subanalytic families on bounded boxes are
globally subanalytic is part of the hypothesis. Locally analytic but
oscillatory examples such as `sin(x/t)` do not satisfy that convention.

**Accessible upper containment.** The domain `S` is a single fixed
subanalytic open subset of a complex coordinate box `Omega`, locally
pseudoconvex at its boundary. Real centers `x` vary in an open real box.
The real invertible matrices `R_t(x)` tend to zero locally uniformly at
generic centers. The normalized domains and ratios are

```
D_t^x = {Z : x + R_t(x) Z belongs to S},
C_t(x,u) = inverse(R_t(x)) R_t(x + R_t(x) u).
```

For every finite real displacement box and every fixed derivative order,
`C_t(x,u)` converges to the specified block-diagonal triangular polynomial
`G_x(u)`. Its `j`-th block depends only on later displacement blocks,
`G_x(0)=I`, and it is invertible for every real `u`. A single fixed seed `p`
belongs to the open kernel at every center. If `P_x` is its kernel
component, the claimed conclusion is

```
for generic x, every L > |p| and eta > 0, eventually
component_p(D_t^x intersect B(0,L))
    subset {Z : distance(Z, closure(P_x)) < eta}.
```

The order of these quantifiers and the allowed countable union of
lower-dimensional exceptional center sets are essential. An example only
at an exceptional center, a moving original domain, or a family without
the ratio condition is not a counterexample.

## Dependencies that are not discharged by a neck computation

The path proof first uses compatible definable Hardt triviality to obtain
a continuous definable path graph. It then uses proper analytic
uniformization, resolution of the scale function, generic retention of
the center coordinates, a finite chart-intersection chain, generic
Puiseux preparation of selected lifts, and logarithmic interpolation in
positive monomial fibers. Its final change of clock is independent of the
center. Testing a narrow corridor does not disprove any of those steps.

The upper-containment proof additionally needs persistence of the
triangular Bishop equation in a Holder space, a full-real-rank
center-perturbation map, the continuity principle in the fixed
pseudoconvex original domain, the all-finite-`L^q` endpoint induction, and
the generic-center selection argument. A checked finite-dimensional
triangular identity is not a verification of these analytic assertions.

The principal primary references requested by the manuscript for the
first part are Bierstone--Milman (1988), Theorem 0.1 and Corollary 4.9,
and Coste's November 1999 notes, Theorem 5.22. The actual
Bierstone--Milman PDF was obtained from NUMDAM, not merely its landing
page. Theorem 0.1 states the asserted proper uniformization of a closed
subanalytic set. Corollary 4.9 requires the analytic function not to
vanish identically on **any component** of its real analytic source;
it supplies a proper surjective analytic map with normal-crossings
pullback and a dense open locally isomorphic locus. Printed page 29
was rendered and read because the text extraction was corrupted.
The manuscript explicitly discards components supported at `t=0`,
so this componentwise hypothesis is not an identified missing
hypothesis in its application.

The local source files and short exact proposition transcriptions are
in `literature/`. This source reading confirms the absolute theorems,
not the manuscript's additional relative estimates. Independent
citation attribution remains outstanding in the ledger: the Engineer
who filed these assumptions cannot independently confirm them, and
the citation tool's mandatory `research/literature/` archival directory
is outside this mission's writable paths.

Coste's primary `univ-rennes1.fr` URL failed at the transport layer.
The current-domain `univ-rennes.fr` variant returned HTTP 404. The
MODNET resource page still linked the former address; the proposed
nLab mirror returned an HTML upload page instead of a PDF. Thus
Theorem 5.22 was **not obtained or checked**. Its assumption is
explicitly uncited in the ledger, with the original bibliographic
source retained. No mathematical conclusion is drawn from these
retrieval failures.

## Exact shrinking-neck family

Let `x in (-1/4,1/4)`, `0<t<1`, and identify the fiber `R^2` with `C`
by `z=r+i y`. Define

```
N_(x,t) = {(r,y) : -2<r<2, |y-x r| < t+r^2}.
p=(-1,0), q=(1,0).
```

These are bounded open semialgebraic planar domains. Their open kernel is

```
K_x = {(r,y) : -2<r<2, |y-x r| < r^2}.
```

It has two components, distinguished by the sign of `r`. The component
`P_x` containing `p` has `r<0`, and `distance(q,closure(P_x))=1`.
For every positive `t`, there is a path from `p` to `q` in `N_(x,t)`
contained in `B(0,2)`. Thus this family really has a collapsing neck and
fails the upper-containment conclusion on a nonempty open set of
parameters if the fixed-original-domain hypothesis is omitted.

Here are the continuum arguments, separately from the rational
computations. Decreasing `t` gives the limiting closed inequality
`|y-x r|<=r^2`. Its equality locus has no interior, since at fixed `r`
one can move `y` toward its exterior by an arbitrarily small amount.
Strict inequality has a neighborhood that persists for every smaller
`t`; equality has no such neighborhood. This proves the asserted
open-kernel formula. For each sign of `r`, the map
`(r,s) -> (r,x r+s r^2)` from the corresponding interval times
`(-1,1)` is a continuous parametrization with continuous inverse,
so those are exactly the two components. Their closures cannot cross
`r=0`, and `(0,0)` lies in the marked closure. The distance from
`(1,0)` is therefore exactly one. All planar domains are locally
pseudoconvex; for these bounded domains one can also use
`-log distance(z,C\N_(x,t))`, a locally bounded supremum of harmonic
functions, as a subharmonic exhaustion. This does not fix the
normalization obstruction below.

Nevertheless it satisfies the controlled-path conclusion explicitly:

```
0 <= a <= 1/4:     F(x,a) = (-1, -4 a x),
1/4 <= a <= 3/4:   F(x,a) = (4 a-2, x (4 a-2)),
3/4 <= a <= 1:     F(x,a) = (1, (4-4 a) x).
```

The joints and endpoints agree. On the first and last segments,
`|y-x r| <= |x| < 1/4 < 1+t`; on the middle segment it is zero.
The middle segment passes through the narrowest point `(0,0)`.
For every complex `x` with `|x|<1/2`, the path is holomorphic in `x`,
its Euclidean norm is at most `sqrt(5)/2`, and its Lipschitz constant is
at most `2 sqrt(5)`. Their sum is less than `6`, independently of `t`.
The concatenation obeys the same Lipschitz bound because the pieces are
continuous and their interval lengths add. This is an exact verification
for this family, not a finite sample and not the full path lemma.

### Why it cannot be a witness for the stated localization theorem

In complex dimension one every allowed limiting recentering is `G=1`.
Suppose the displayed family were realized, even just on the bounded
portions used here, by a fixed `S` and real scales satisfying the
manuscript's hypotheses at a center `x`. Take the real displacement
`u=1`, put `x'=x+R_t(x)`, and write `C=C_t(x,1)`. For all sufficiently
small `t`, `x'` remains in the parameter interval and `C` tends to `1`.

The fixed point `b=-1+i/8` belongs to every `N_(x',t)`, because
`|1/8+x'|<3/8<1+t`. The fixed-`S` recentering identity therefore forces

```
1+C b = (1-C) + i C/8
```

to belong to `N_(x,t)`. This is impossible. Indeed, for
`|C-1|<=1/16`, `|x|<=1/4`, and `t<=1/64`, its vertical residual is
positive, and

```
|C/8-x(1-C)| >= 13/128,
t+(1-C)^2 <= 5/256.
```

The required strict domain inequality fails with margin at least
`21/256`. Equivalently, writing `delta=C-1`, an upper bound for
the purported membership slack is

```
delta^2-delta/8-3/32 = (delta+1/4)(delta-3/8) <= -21/256.
```

This excludes this family from the actual fixed-`S`, ratio-convergent
hypotheses. It does not show that all shrinking-neck attacks are
impossible. In particular, it refutes our proposed admissibility
claim `C_LOC_NECK_ADMISSIBLE`, **not** any literal assertion in the
manuscript. Route `R_LOC_GRAPH_NECK` must not be retried as a
manuscript counterexample.

### Exact replay and its limits

From the campaign root, run:

```
python3 research/localization_audit/verify.py
```

An absolute script path also works from another working directory.
The script uses only Python's standard
library and reads its adjacent certificate and saved Jacobian result.
There is no network call, floating-point test, finite-grid search, or
dependency installation in the replay.

Jacobian operation `polynomial.roots.isolate` was inspected and executed
once through the authorized Argus adapter. The exact payload, inspected
typed schemas, and original typed output are the adjacent
`jacobian_*.json` files. The execution returned exit status zero,
server version `0.14.0`, protocol `2025-11-25`, and no error or timeout.
It returned isolating intervals `[-1,0]` and `[0,1]`, each of
multiplicity one. These broad intervals alone **do not** establish
negativity on `[-1/16,1/16]`. The independent exact factorization
in `verify.py` supplies the roots `-1/4,3/8`, validates their binding
to the typed result, and proves the rational bound. In particular,

```
(delta^2-delta/8-3/32)+21/256
    = (delta+1/16)(delta-3/16) <= 0
    for -1/16 <= delta <= 1/16.
```

The replay also checks the polynomial path identities, all affine
piece bounds on their whole intervals, the uniform seed ball, and
the probe's strict exclusion margin. The open-kernel, connectedness,
distance, and recentering implications have the mathematical proofs
above; the replay is not a kernel formalization of topology or
complex analysis. Its output deliberately says `partial_result`,
`manuscript_refuted=false`, and `full_statement_verified=false`.

Compared with the initial untested shrinking-neck suspicion, the
improvement is an exact, all-parameter exclusion of this explicit
route, together with a clear separation of failure of a weakened
moving-domain assertion from failure of the actual theorem. No
novelty or publishable significance is claimed for this checkpoint.

## Remaining obligation

No stated-hypothesis counterexample has been constructed. No
machine-checkable formalization of either full manuscript statement has
been supplied. The unresolved obligation is to settle the generic
relative-resolution/path argument (`C_LOC_CHART_GLUE`, including the
center-independent clock) and the analytic-disc persistence
argument (`C_LOC_DISC_PERSIST`) at their full quantifiers, or find a
different family that
retains fixed `S`, local pseudoconvexity, the fixed seed, and all bounded
real-displacement recentering limits while violating containment on an
open set of centers. There is no basis to register an `F_...` refutation
claim for the manuscript on the evidence above.
