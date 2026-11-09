# A coherent Adams lift on constrained smash-product unions

## Scope and known inputs

The assertion under audit is the literal proposition
`prop:compatible-adams-lift`, companion manuscript
`build/sections/02-filtered-products.tex`. The proof to be
audited occupies the following simplex-slicing lemma and the proof ending
with the fiber sequence of the unit cube. This is a question about a
coherent null cone, not only vanishing in the homotopy category at its
individual vertices.

Two relevant primary-source facts have been obtained and read:

1. A. Mathew, *Examples of descent up to nilpotence*,
   arXiv:1701.01528v1, Definition 2.28, Definition 3.26, Proposition 3.28,
   and Theorem 3.30. For fixed p, the exponent of
   `tau_{<k} S_(p)` with respect to `MU_(p)` is `o(k)`. Proposition 3.28
   explicitly quantifies over every connective p-local spectrum.
   The defining general ring is connective, has `pi_0 = Z_(p)`, and
   has degreewise finitely generated homotopy. This input belongs to
   the downstream filtered-product argument, not to the coherent lift.
   It does not assert a prime-independent cutoff. The downloaded
   versioned PDF and its extracted text are retained in this directory.

2. A. Mathew, N. Naumann, and J. Noel, *Nilpotence and descent in
   equivariant stable homotopy theory*, arXiv:1507.06869v2,
   Section 2.1, Construction 2.7 and Propositions 2.11 and 2.14.
   Their setting is a presentable symmetric monoidal stable
   infinity-category with tensor product preserving colimits separately.
   Proposition 2.11 identifies the punctured external tensor cube's limit
   with the cofiber of the tensor product of its edge fibers.
   Proposition 2.14 relates the Adams tower to the cobar totalization
   tower. The present argument will reprove the required finite-cube
   fiber identity and will not use cofinality or convergence of a
   totalization tower. The versioned primary source is retained here.

These are scope inputs, not evidence that the proposition under audit
has already been proved. A search of the inherited project Wiki index
found no relevant Adams-lift, complex-cobordism, or nilpotence entry.
No priority or novelty assertion follows from that negative lookup.

## A closed unsuccessful approach

It is not valid to infer a null cone from null composites to all of
its objects. A lift on any one product stratum does exist: choose a
lift on G through I_R, smash it in the n specified restricted
coordinates, and smash v in the remaining coordinates. This says
nothing yet about agreement between the choices of coordinates.
Already in spectra, take a cospan

```
0 -> Sigma HZ <- 0.
```

Its homotopy pullback is `Omega Sigma HZ = HZ`. The identity of HZ
is a nonzero cone, although all of its objectwise components are zero.
Its nontrivial datum is a loop in the mapping space into `Sigma HZ`.
This example is not a unit cube and is not a counterexample to the
manuscript. It closes the proposed audit shortcut
"choose nullhomotopies separately on each product".

The auxiliary circle chain complex supplied to Jacobian has one
nonzero H1 class and illustrates this lost loop datum. It is not a
calculation of an Adams obstruction for any ring spectrum.

## Computational applicability

The installed Jacobian server is version 0.14.0, using MCP protocol
2025-11-25. The inspected coherent-configuration operation concerns
finite partitions of ordered pairs, not homotopy-coherent cones.
The inspected `chain_complex.homology.compute` accepts only finite
based chain complexes over QQ or a prime field. Neither contract
accepts spectra, mapping-space coherences, or the universal lifting
postcondition. No operation implementing that postcondition was
identified. The latter operation is used only for the explicit
circle diagnostic above. Its exact payload, typed response, and
adapter exit status are separate JSON artifacts.

The complete general mathematical argument and the exact boundary
of executable evidence are developed below; survival of finite
examples is not a proof of the proposition.

## Theorem

Let G be a pointed CW subcomplex of E, let R be an E-infinity ring
spectrum, and put `I = fib(S -> R)`. Fix an integer d, a stable map
`v : Sigma^infinity E -> Sigma^d S`, and a nullhomotopy h of its
unit composite on G. For `1 <= n <= ell`, let U be the subcomplex
of `E^smash ell` with at least n coordinates in G. There exists a map

```
L : Sigma^infinity U -> Sigma^(d ell) I^smash n
```

whose composite with the smash of the fiber inclusions is homotopic
to `v^smash ell |_U`.

The original proposition is true. Finiteness of the CW pair is not
used: the same proof applies to CW pairs without that restriction,
with smash products and subcomplex unions in compactly generated
based spaces. No claim of priority for this extension is made.

### 1. A universal parameter construction

For real numbers `a <= b` and `l <= u`, write

```
O(a,b;l,u) = max(0, min(b,u) - max(a,l)).
```

This is the length of the intersection of the intervals. For
`a <= b <= c` and `l <= u`,

```
O(a,c;l,u) = O(a,b;l,u) + O(b,c;l,u).                 (1)
```

For completeness, split into the three cases `b <= l`, `u <= b`,
and `l <= b <= u`. In the first case the first summand is zero
and both other left endpoints are l. In the second the second
summand is zero and both other right endpoints are u. In the third,
the summands are respectively `b - max(a,l)` and `min(c,u) - b`,
and all three displayed differences are nonnegative. They telescope.
The coincident-endpoint cases are included.

Take a point x of the standard j-simplex and its ordered cumulative
breaks `s_0=0 <= s_1 <= ... <= s_(j+1)=1`. Define

```
rho_r(x)_a = ell O(s_a,s_(a+1); (r-1)/ell, r/ell),
             1 <= r <= ell, 0 <= a <= j.            (2)
```

Formula (1), iterated over all j+1 mass intervals, shows that each
output has coordinate sum one. Nonnegativity is immediate, and
continuity follows from continuity of min, max, and addition.

If `alpha:[j]->[k]` is any monotone map, each nonempty fiber of
alpha is a consecutive block. Iterating (1) on that block gives

```
sum_(a:alpha(a)=b) rho_r(x)_a = rho_r(alpha_* x)_b.  (3)
```

For an empty fiber both sides are zero: the corresponding cumulative
endpoints coincide. This proves naturality for every morphism of
the simplex category, including all codegeneracies and maps that
are neither injective nor surjective. It is an equality of continuous
maps of spaces, not a homotopy chosen separately for each morphism.

If an output of (2) is not a vertex, two of its coordinates, say
those indexed by a<b, are positive. Positivity of the first gives
`(r-1)/ell < s_(a+1)`. Positivity of the second gives
`s_b < r/ell`. Since `s_(a+1) <= s_b`, the internal break
`s_(a+1)` lies strictly inside the rth slice. Distinct slices have
disjoint interiors. Choosing one such break per nonvertex output
therefore gives an injection into the j internal breaks, and there
are at most j nonvertex outputs.

This argument includes repeated breaks, zero simplex coordinates,
and breaks exactly at slice endpoints. When j=0 no output is a
nonvertex. Positivity of a slice width is the only denominator
condition used; here it follows from `ell >= 1`.

### 2. One nullhomotopy, extended as a coherent diagram

Work in `D = Fun(Delta, Sp)`, where the simplex category is its full
ordinary category, not just its injective maps. There is a
cosimplicial object of commutative ring spectra

```
B^j = R^smash(j+1).
```

For a monotone map, multiply the tensor factors in each nonempty
fiber and insert units in the empty fibers. The E-infinity algebra
structure supplies the coherent functor and its natural
multiplications `mu_ell : B^smash ell -> B`. In particular we are
not treating a homotopy-commutative multiplication as a strict
commutative multiplication.

Let `V^j` be the set of vertices of `Delta^j`. As a covariant set
diagram, V is `Hom_Delta([0],-)`. Thus

```
T^j = Sigma^infinity(G smash V^j_+)
```

is the left Kan extension of `Sigma^infinity G` along the inclusion
of the one-object subcategory `[0]` into Delta. Indeed, the comma
category at `[j]` consists of j+1 discrete maps `[0]->[j]`;
its colimit is precisely that wedge of j+1 copies of G.
The defining mapping-space adjunction for this extension gives

```
Map_D(T, Sigma^d B) =
Map_Sp(Sigma^infinity G, Sigma^d R).                (4)
```

Here and below equality between mapping spaces denotes the natural
equivalence. In particular (4) carries paths and all their higher
compatibilities, not only homotopy classes.

Let `X^j = Sigma^infinity(E smash Delta^j_+)`, and define
`a:X -> Sigma^d B` by forgetting the simplex parameter and
applying v and then the unit. This is a map of diagrams since the
unit is an augmented cone for B. Under (4) its restriction to T
is exactly the unit composite of `v|G`. The single chosen h
therefore gives a nullhomotopy of `a|T` in D.

Take the cofiber in D:

```
Q^j = Sigma^infinity((E smash Delta^j_+) /
                    (G smash V^j_+)).
```

The ordinary quotient computes this cofiber, because each indicated
inclusion is a based CW cofibration. Colimits in D are computed
objectwise. The cofiber universal property, applied to the
nullhomotopy just obtained, produces

```
psi:Q -> Sigma^d B,     H: psi q ~ a in D.          (5)
```

Thus H is already a homotopy in the entire diagram category. No
extension problem on the intersections of the product strata has
been omitted.

### 3. A strict collapse on the entire constrained union

Using (2), form the continuous map of based diagrams

```
C^j : U smash Delta^j_+ ->
      ((E smash Delta^j_+) / (G smash V^j_+))^smash ell
```

by sending `(x_1 smash ... smash x_ell, x)` to the smash of the
classes of `(x_r,rho_r(x))`. Formula (3) makes C an actual natural
transformation before passage to spectra.

For `j<n`, at least n coordinates x_r are in G, and at most j
parameters rho_r(x) are nonvertices. Some coordinate is consequently
in G and has a vertex parameter, so its quotient factor is the
basepoint. This proves that C is the *strict zero natural
transformation* after restriction to `Delta_(<=n-1)`.
It is a statement about one continuous map on U itself. It is
not obtained by gluing independently selected stable lifts.
Basepoint inputs are also sent to the basepoint.

Compose its suspension with `psi^smash ell` and `mu_ell`, using
the fixed factor order to identify the suspension with
`Sigma^(d ell)`. By (5), the resulting diagram map F is homotopic,
in D, to

```
Sigma^infinity(U smash Delta^bullet_+)
    --p--> const(Sigma^infinity U)
    --const(v^smash ell|U)--> const(Sigma^(d ell) S)
    --> Sigma^(d ell) B.                          (6)
```

The identification in (6) is a homotopy of diagrams: tensor (5)
ell times, precompose with the slicing maps, and postcompose with
the natural multiplication. Every factor of a forgets its own
simplex parameter, which is why the endpoint of that homotopy is
exactly (6). Tensoring homotopies and composing natural
transformations are operations on mapping spaces. This also handles
all higher coherences. For negative or odd d the same fixed-order
identification applies; no permutation of the ell suspended
factors is being asserted to act trivially.

The map p is an objectwise equivalence, since every simplex is
contractible. Equivalences in the functor category are objectwise,
so p can be inverted there. This uses neither a natural vertex
selection nor a natural contraction of the simplices.

Restrict (6) to `Delta_(<=n-1)`. Since F on that restriction
factors through the strict zero C, it supplies a nullhomotopy of
(6) in that diagram category. Precomposition with an equivalence
is an equivalence of mapping spaces; invert p to obtain a null
morphism

```
const(Sigma^infinity U) -> Sigma^(d ell) B
```

on the full truncated simplex category. This is the coherent
null cone required in the question.

### 4. Restrict the cone, and identify its fiber

For nonempty subsets A of `{1,...,n}`, send A to `[|A|-1]`.
An inclusion of subsets induces the ordered injection between
their enumerations. This is a functor: the injections compose
as the subset inclusions do. Its image lies in
`Delta_(<=n-1)`, and its restriction of B is the punctured unit
cube `A |-> R^smash |A|`.

Restriction is a functor on diagram categories and hence on their
mapping spaces. It carries the *one* null cone just constructed
to a null cone on this cube. The defining adjunction for limits,
`Map(const K,B) = Map(K,lim B)`, now gives a nullhomotopy of

```
Sigma^infinity U --v^smash ell-->
Sigma^(d ell) S -->
Sigma^(d ell) holim_(A nonempty) R^smash |A|.        (7)
```

No cofinality assertion and no comparison of partial
totalizations occurs in this step.

Adjoin S at the empty subset. The resulting cube is the external
smash of n copies of `S->R`. Its total fiber is `I^smash n`.
Here is a direct proof. In a stable category, smash with any
spectrum preserves finite cofibers, hence finite fibers. Taking
fibers in one coordinate replaces the corresponding `S->R`
by I. Induct on n, commuting finite limits to take the remaining
coordinate fibers. The iterated fiber equals the fiber from the
initial vertex to the limit over the other vertices: for two
coordinates this follows by writing both sides as iterated
pullbacks over zero, and the same pullback identity proves the
general statement by induction. At each step the fiber-to-source
map is the corresponding fiber inclusion. Consequently its map
to S is exactly their smash product, not just an unspecified map
from an equivalent object.

We have thus proved the fiber sequence

```
I^smash n --phi_R,n--> S -->
holim_(A nonempty) R^smash |A|.                     (8)
```

Suspension preserves this finite-limit sequence. By the
mapping-space universal property of its fiber, the specific
nullhomotopy in (7) gives the lift L claimed in the theorem.
This proves the assertion for all the stated objects and
quantifiers.

### 5. Structural corollary: one compatible map of finite towers

The construction gives more than independently existing lifts
for different n. Fix ell and the single nullhomotopy h, and put
`U_0=E^smash ell` and `U_n=U_(ell,n)` for `1<=n<=ell`.
Let the transition `I^smash(n+1) -> I^smash n` apply the fiber
inclusion to the last factor. There is a morphism of finite
diagrams of spectra

```
Sigma^infinity U_ell -> ... -> Sigma^infinity U_1 -> Sigma^infinity U_0
         |                             |                       |
         v                             v                       v
Sigma^(d ell) I^smash ell -> ... -> Sigma^(d ell) I -> Sigma^(d ell) S,
```

with last vertical map `v^smash ell`. In particular the lifts
can be chosen compatible with all the Adams-tower transitions,
with their homotopy coherences. This is an existence assertion
about the diagram, not a uniqueness assertion about the lifts.

To prove it, perform the construction of C and F above on all of
`E^smash ell`, before imposing any constraint. Its restrictions
to the U_n share the same psi, the same homotopy H in (5), and
the same slicing maps. On the index pairs `(n,[j])` with `j<n`,
every restricted C is the literal zero map. Thus the
nullhomotopies on the truncated simplex diagrams agree under
restriction to a smaller U_m and a smaller simplex truncation.
This agreement is a restriction of a single transformation of
diagrams; it includes the coherences for composed restrictions.
Equivalently, invert p once in the functor category that also
includes the finite U-filtration, rather than choosing an
inverse separately at each n.

The inclusion of the first n cube coordinates into the first
n+1 coordinates restricts the latter punctured cube to the
former. Its ordered-subset functor to Delta is unchanged on
these subsets. Consequently the preceding null cones give a
compatible family of null composites to the punctured-cube
limits Q_n. The maps of fiber sequences induced by
`Q_(n+1)->Q_n` identify the maps between their fibers with
`I^smash(n+1)->I^smash n` specified above; this follows from
the coordinate-by-coordinate proof of (8), keeping the first
n coordinates. For n=0 the punctured cube is empty, its limit
in spectra is zero, and its fiber is S.

Finally take fibers in the functor category of these finite
towers. They are computed objectwise, so the compatible
family of maps with its compatible nullhomotopy is a map
into the fiber tower. This proves the displayed assertion,
including all its diagram coherences, without choosing
pairwise compatibility homotopies afterwards.

This strengthens the single-n assertion and records an
additional precise structural consequence of its proof.
Its literature novelty has not been established.

## Audit conclusion and downstream boundary

The proposed coherent-null-cone route succeeds. No false literal
manuscript assertion has been identified in this proposition or
its simplex-slicing proof, so this result is not a refutation,
and there is no corresponding `F_` claim to register. The closed
unsuccessful route is an auditor shortcut, explicitly not an
assertion attributed to the manuscript.

Compared with the prior scope result, which only supported the
fixed-prime nilpotence input, this proves the missing coherent
lift itself. The vertex representable, quotient factorization,
strict sliced collapse, and inversion of p take place in the
diagram category before restriction to the cube; these are the
steps that separately chosen nullhomotopies would not supply.
Section 5 additionally gives a single compatible map of the
finite constrained-union and Adams towers, not merely a list
of individual lifts.

This resolves a substantive upstream dependency. It does not
verify filtered-product vanishing at all primes, local duality,
controlled avoidance, padding, the arbitrary compact-metrizable
bundle criterion, or the dynamical comparison lower bound.
Those nodes remain open in the proof graph. Neither a claim of
new literature priority nor completion of the publishable
campaign is made. Independent Reviewer acceptance of this proof
and the fidelity reading is still required.

## What the executable evidence proves

`Main.lean` proves dimension-independent interval-overlap
additivity and its finite telescoping consequence, the
positivity implications needed to find an internal break,
the cardinal bound for arbitrary disjoint ordered open slices,
and the finite-set pigeonhole step selecting a restricted
coordinate outside the nonvertex set. These are general
statements over the real numbers and arbitrary natural
dimensions, not bounded experiments.

`verify.py` independently checks the overlap identities on
every possible endpoint-order cone, with integer linear
expressions, so this arithmetic check is also universal rather
than a sample of reals. It then runs explicitly bounded exact
rational examples of slicing, including all monotone maps
within the declared bound and endpoint degeneracies, and
replays the retained Jacobian circle diagnostic. It also checks
that the official Lean certificate reports compiler and axiom
audit success with no proof holes, and that its source and
statement-fidelity hashes match the current files. This is a
freshness check of an actual recorded compiler run, not a
new execution of the compiler by `verify.py`.

Neither executable implements infinity-categories, ring
spectra, or stable mapping spaces. The passage from these
parameter identities to the coherent cone and the lift is the
mathematical proof in Sections 2-4 above, requiring independent
human mathematical review. A successful compiler run must not
be described as a formalization of the spectral theorem.
