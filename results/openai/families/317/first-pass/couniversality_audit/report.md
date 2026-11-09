# Couniversality: universal argument and certification limits

## Result classification

The argument below supports the manuscript's couniversality theorem
with its unrestricted quantifiers. It also gives an exact, stronger
criterion for the particular append-prism formula. No false literal
manuscript assertion has been established.

The **machine-certified result is narrower**: Lean 4.31.0 proves the
unbounded terminal correction, the exact edge criterion, derivation
of that criterion from the manuscript hypotheses, and the abstract
adjunction/pushout gluing mechanism. The native run has exit code zero,
an empty proof-hole list, and a successful axiom audit. The finite
Python replay is a regression experiment, not a proof of
couniversality. `exact_certificate.json` deliberately says
`partial_result`; it must not be used to close `C_COUNIVERSAL`.

The full mathematical argument still requires independent reading,
attribution of its literature inputs, and the Host-invoked Reviewer.
Publication significance and novelty are not certified. This is an
Engineer handoff, not completion of the independent campaign.

## Statement and scope

The target is `thm:couniversal` in the staged manuscript's
`build/sections/05-couniversality.tex`: for every small poset sieve
`i : A -> E` with a right-adjoint retraction, every strict attaching map
`a : c_n N(A) -> X`, and every positive finite `n` or `n = omega`, the map
`X -> X amalg_{c_n N(A)} c_n N(E)` is a Street weak equivalence.
The attaching map may identify objects, arrows, and higher cells. No
cofibrancy, freeness, or injectivity assumption is permitted.

The manuscript source root is
`research/openai_manuscript/Thomason-Model-Structures-in-Every-Strict-Higher-Dimension-September-25-2026/`.
Labels below refer to that immutable staged source, not a reconstruction
of the statement.

## Scope findings

1. `lem:relative-prism` assumes that the upper map is constant on the
   complement of the old sieve. It does not assert a positive append
   prism for every pointwise inequality. Its formula is a whole
   directed-chain map, not just a prescription for top-dimensional
   generators. Its claimed stationarity is equality on every old cell.
2. `lem:internal-truncation` supplies the passage to finite dimensions
   through the right internal hom. The pushout in finite strict
   categories is not assumed to be its pushout in strict omega
   categories.
3. `lem:pushout-cylinder` uses the actual internal-hom adjunction.
   The comparison maps into that internal hom must agree on the entire
   attaching source. Agreement on objects or top chains alone is
   insufficient.
4. `prop:labelled-pushout` and `cor:attachment-covers` use fiber left
   adjoints and object colimits to describe actual full subcategories
   after arbitrary identifications. It would be invalid to replace this
   calculation by a union of free generators before quotienting.
5. The known poset-unit theorem does not establish this arbitrary
   attachment statement. Relevant antecedents are Ara--Maltsiniotis,
   arXiv:1503.02720v1, Corollary 10.11, and Gagna,
   arXiv:1612.04450v2, Theorem 6.9. The two-dimensional couniversality
   antecedent is Ara--Maltsiniotis, arXiv:1305.5086v3,
   Proposition 6.25 and Corollary 6.26. These are scope comparisons,
   not a proof of the all-dimensional target.
6. A separate read-only primary-source inventory found supplied public
   constructors for `RightIntervalCore` and
   `NormalizedSimplexIdentities`, and an all-dimensional comparison
   route in `RankedFaithfulness`. Generic theorems with
   `SimplexDescent` as a parameter must not be mistaken for an
   unconditional certification. No fresh compilation or full
   statement-fidelity check has yet been obtained for that public
   development.

The public inventory used revision
`4eaee87548250b2682affda7d05d947c05554bae` of `openai/math`.
Its decisive declarations are
`GrayRecursive.IntervalHom.intervalCore`,
`core_finite_poset_couniversal`, `core_poset_couniversal`,
`chainComparison_finiteSimplex_onCells_bijective`,
`standardSimplexComparison_isIso`, and
`Thomason.Construction.normalizedSimplexIdentities`.
This inventory establishes source availability, not mathematical or
compiler verification.

## Dependencies requiring verification

The proof graph separates the positive prism identity, simplex descent
and whole stationarity, finite reflection, arbitrary pushout gluing,
actual labeled fibers, nerve homotopies, finite induction, and filtered
passage. None is marked independently proved at scope.

The categorical literature input needed for the prism route is the
biclosed Gray tensor on all strict omega categories and its natural
strong-Steiner comparison, Ara--Maltsiniotis,
arXiv:1607.00668v4, Theorem A.15 and Sections A.16--A.18.
The other directed-complex inputs are Steiner,
arXiv:math/0403237v2, Definitions 2.6 and 2.8 and Theorem 6.1,
and Steiner, arXiv:math/0601383v2, Theorem 3.2 and the cosimplicial
description in Section 4. Their actual hypotheses and locators must
be read, not inferred from the manuscript bibliography.

## Exact append-prism criterion

Let `E` be any small poset and let `f,g : E -> E` be monotone with
`f(x) <= g(x)` for all `x`. Define the condition

```
(AC)  x <= y  ==>  f(x)=g(x) or g(x)=g(y).
```

Equivalently, `g` is constant on the upper set of each `x` with
`f(x) != g(x)`. There is no global constancy requirement.

**Theorem.** The prescription on a selected ordered tuple
`w=(w_0,...,w_p)`

```
C(w tensor e_0) = [f(w_0),...,f(w_p)] = F(w),
C(w tensor e_1) = [g(w_0),...,g(w_p)] = G(w),
C(w tensor u)   = [f(w_0),...,f(w_p),g(w_p)] = h(w)
```

defines positive, augmentation-preserving chain maps on every simplex
if and only if (AC) holds. Under (AC), these maps assemble into whole
right Gray cylinders on `c_n N(E)` for every positive finite `n` and
omega. They are strictly stationary on every subposet `B` on which
`f=g`, relative to the common map `B -> E`; `B` need not be a sieve.
Necessity concerns this prescribed formula, not the existence of
some other cylinder.

**Proof.** First show that the target vertices in one simplex form a
chain. Write `f_i=f(w_i)` and `g_i=g(w_i)`. The two individual lists
are ordered. For `i <= j`, if `g_i=g_j`, then `f_j <= g_i`; otherwise
(AC) gives `g_i=f_i <= f_j`. Thus `g_i` and `f_j` are comparable.
All pairs in the union of the two lists are comparable. Denote this
finite ordered set by `T`. Every displayed tuple is therefore a
positive simplex of `M[T]` or zero after normalization.

For `p=0`, `d h(w)=G(w)-F(w)`. For `p>0`, put

```
B  = [f(w_0),...,f(w_{p-1}),g(w_p)],
B' = [f(w_0),...,f(w_{p-1}),g(w_{p-1})].
```

If `g(w_{p-1})=g(w_p)`, then `B=B'` and `G(w)=0`.
Otherwise, for every `i<p`, monotonicity gives
`g(w_i) <= g(w_{p-1}) < g(w_p)`. Applying (AC) to
`w_i <= w_p` gives `f(w_i)=g(w_i)`. Consequently `B=G(w)` and
`B'=0`. In both cases `B-B'=G(w)`. Expansion of the alternating
boundary now gives

```
d h(w) =
  sum_{j=0}^p (-1)^j h(w with w_j deleted)
  + (-1)^p (G(w)-F(w)).
```

This is the right-interval tensor sign, since
`d(w tensor u)=dw tensor u + (-1)^p w tensor (e_1-e_0)`.
The alternating deletion formula remains valid for a weakly
increasing repeated tuple: the two deletions at a repeated adjacent
pair cancel, and every other deletion is still degenerate. Thus
normalization does not remove a hypothesis from the argument.

For necessity apply the chain-map identity to an edge `x <= y`.
It implies

```
[f(x),g(y)] - [f(x),g(x)] = [g(x),g(y)].
```

For `a <= b <= c` the normalized edge identity
`[a,c]-[a,b]=[b,c]` holds exactly when `a=b` or `b=c`.
Indeed, if both inequalities are strict, the coefficient of the
basis edge `[a,c]` is one on the left and zero on the right.
Taking `a=f(x), b=g(x), c=g(y)` proves (AC).
`Main.lean` proves this equivalence for every poset, and proves the
terminal identity above for lists of arbitrary length.

For simplex operators, let `alpha : [q] -> [m]` be monotone.
On a selected tuple where `alpha` is injective, the two composite
maps are literally the same displayed tuple. If it is not injective,
the repeated selected indices yield repeated `f` entries in both
the `e_0` and `u` formulas and repeated `g` entries in the `e_1`
formula. Both entire chain maps are therefore zero on that basis
element. This compares every degree, not only the top chain.

By the natural strong-Steiner tensor comparison, these are compatible
strict functors
`O_m tensor D_1 -> nu M[T] -> c_infinity N(E)`.
The simplex presentation of categorification and separate
cocontinuity of the Gray tensor assemble them. No preservation of
arbitrary colimits by `nu` is asserted.

On a simplex in `B`, every selected tuple has equal endpoints and
the entire chain map is
`F composed with (id tensor epsilon)`, where `epsilon(u)=0`.
Applying `nu` and assembling proves equality to the constant
cylinder on every cell. Section "Finite reflection" below gives the
same statement after reflection. This proves the theorem.

The manuscript's hypotheses imply (AC): if `x` is old, `f(x)=g(x)`;
if `x` is new and `x <= y`, the sieve condition makes `y` new and
the constancy hypothesis gives `g(x)=g(y)`. This implication is
also proved in Lean.

**Strict improvement in scope.** In the fork `0<1, 0<2`, take
`f` constant at `0` and `g=id`. Condition (AC) holds, although `g`
is not constant on `{1,2}`. Thus the criterion is genuinely less
restrictive than the manuscript's global constancy condition.
More generally, if the new complement of a sieve retract is an
antichain, `f=ir` and `g=id` satisfy (AC). After every attachment
there is then a single stationary right cylinder from `jp` to
`id`, with `pj=id`, rather than merely the zigzag used in the
general theorem. This is a mathematical structural refinement;
its novelty and publication significance remain unverified.

Gagna's Sections 6.3--6.8 construct a different simplicial homotopy
by positive concatenation with a cut. That construction does not,
by itself, assert the whole stationary right cylinder characterized
here. Reading those sections and the source inventory has not
established a prior publication of this exact append-formula
criterion; this is not an exhaustive novelty search.

## Finite reflection

Write `H(Y)` for the right internal hom representing
`Hom(X tensor D_1,Y)`. Fix a strict finite `n`-category `Y`.
An `i`-cell of `H(Y)` is a strict map `D_i tensor D_1 -> Y`.
Let `s : D_{i-1} -> D_i` be the source inclusion and
`p : D_i -> D_{i-1}` collapse the top cell to the identity of
its source. Comparing a map `P` with `P(sp tensor id)` compares
that cell with the identity on its source.

The tensor atoms outside the source face are the top `i`-atom
paired with either endpoint or with `u`, and the target
`(i-1)`-atom paired with these same three interval atoms. If
`i>n+1`, they all have dimension greater than `n`. If `i=n+1`,
the only such atoms of dimension at most `n` are the target
`n`-atom at the two endpoints. The top `(n+1)`-atom at either
endpoint maps to an identity in `Y`, forcing the source and
target `n`-atom images to agree. The two maps agree on every
atom of dimension at most `n`; every higher atom image is the
iterated identity on its determined `n`-source. Generation by
atoms proves their equality. Hence every cell of `H(Y)` above
`n` is an identity.

If `q_X : X -> tau_n X` is reflection, transposition now gives
the bijection

```
Hom((tau_n X) tensor D_1,Y) ~= Hom(X tensor D_1,Y).
```

It is natural in `X`, and endpoint evaluation preserves the
factorization. Apply it to `q_E P_infinity` to obtain the
finite-dimensional prism. For stationarity, precompose the
two claimed restriction maps with `q_B tensor id`; they agree
by the omega construction. Injectivity of the displayed
bijection proves equality after reflection. This establishes
stationarity on the whole reflected attaching object, including
any identifications among its top-dimensional cells.

The literature independently states the more general truncation
result at Ara--Maltsiniotis, Proposition A.29. The local argument
above uses only its explicit globe-atom case. It does not infer a
finite-category pushout by silently applying an omega-category
pushout calculation.

## Arbitrary pushout gluing

Let `Y=X amalg_{B_0} B` be the actual pushout in strict
`n`-categories, for arbitrary `i : B_0 -> B` and `a : B_0 -> X`.
Suppose `P : B tensor D_1 -> B` has endpoints fixing `i` and
`P(i tensor id)=i pi_{B_0}` as equality of strict functors.
In `Y`, the two cylinders `bP` and `j pi_X` agree on
`B_0 tensor D_1` by the pushout's strict commutativity.

Transposing gives actual functors `B -> H(Y)` and `X -> H(Y)`.
The preceding section makes `H(Y)` a strict `n`-category, so
the universal property of the given pushout applies to them.
It gives `Y -> H(Y)`, whose transpose is the required whole
cylinder. Restriction, endpoint equations, and stationarity on
`X` follow by restriction to the two summands and uniqueness.
Nothing refers to a free presentation of `X` or to injectivity
of the attaching map. In particular any identifications of old
objects or cells are already imposed before this universal
property is used.

`glue_along_adjunction` is a fully kernel-checked version of the
general adjunction/pushout mechanism. The identification with
this particular right internal hom and its dimensional bound is
the separate mathematical argument above, not an implicit Lean
assumption about strict categories.

## From cylinders to nerve homotopies

For each normalized simplex complex define the positive diagonal

```
AW[i_0,...,i_p] =
  sum_{a=0}^p [i_0,...,i_a] tensor [i_a,...,i_p].
```

In its boundary, deletions away from the shared vertex give
`AW d`. The remaining term at cut `a` has coefficient `(-1)^a`
and cancels the shared-vertex term at cut `a-1`, with coefficient
`(-1)^(a-1)`. This proves the chain identity in every degree.
Both counits give the identity. For a monotone ordinal map that
identifies adjacent entries `j,j+1`, every cut at most `j` has a
degenerate right factor and every later cut has a degenerate
left factor. This proves naturality for degeneracies as well as
faces.

Realizing through `nu` and the natural tensor comparison gives
`delta_m : O_m -> O_m tensor O_m`. For
`F : O_m -> Z` and `theta : [m] -> [1]`, use
`(F tensor O(theta)) delta_m`. Naturality makes this a simplicial
map `N_infinity Z times Delta[1] -> N_infinity(Z tensor D_1)`.
The counits give its endpoints and projection. Composing with
a stationary cylinder gives a simplicial homotopy stationary
on the entire nerve of its old source. The same formula works
for strict `n`-category targets.

## Actual fibers after object and cell identifications

Small strict-category colimits used here can be constructed
without assuming that an old set of cells is closed under the
new composites. Take raw sorted finite terms on the diagram's
cells. Generate definedness and equality judgments together:
total operations preserve definedness, matching-boundary
equalities allow partial composites, and equality transports
definedness and values. Add the strict laws with their full
matching guards. The union of the finite derivation stages is
closed because each rule has finitely many premises. Defined
terms modulo derivable equality form a strict category, with
composition defined exactly when boundary classes match.
Assignments into another strict category satisfying the
diagram's operation tables and compatibility equations extend
uniquely by induction on derivations. This is the required
colimit. In particular a newly imposed boundary equality can
create new powers or new higher composites; these are not
silently omitted by the construction. This is the saturation
argument spelled out in the staged Section 09, not a naive
quotient-of-existing-cells shortcut.

For `epsilon=0,1`, the full fiber functor
`F_epsilon : nCat/D_1 -> nCat` is a left adjoint. For `F_0`,
its right adjoint puts a given `B` over `0`, adjoins one object
`*` over `1`, retains the hom categories of `B`, puts terminal
homs from each old object to `*`, and empty reverse homs.
All other mixed compositions have terminal codomain and are
unique. A functor from the zero fiber extends uniquely because
all one-labeled objects and all mixed cells have forced images.
The construction for `F_1` adjoins an initial object instead.
This proves the adjunction in every positive finite dimension
and in omega, including empty fibers.

The object functor is also a left adjoint: its right adjoint
sends a set to the chaotic ordinary category, regarded as a
strict higher category. Consequently both fibers and object
sets preserve the colimits being used.

In an oriental, every atom appearing in a cell with endpoints
`a,b` has vertices in `[a,b]`. This follows by induction on a
finite composite expression: a zero-composite has an
intermediate vertex between its endpoints, and higher
composites have the same zero-endpoints as their factors.
An initial or final vertex segment is therefore a full face.
The same holds after reflection, since representatives have
the same zero-endpoints. Injectivity of the reflected face
inclusion follows from the monotone clamp retraction.

For a poset sieve `S` in `P`, label its objects zero and its
complement one. In every simplex the zero vertices form an
initial segment. Taking the zero fiber of the simplex colimit
therefore gives exactly `U_n(S)`: the selected face of each
simplex maps into `S`, and the face-inclusion morphism in the
simplex category identifies it with its own occurrence there.
The same calculation identifies objects of `U_n(P)` with `P`.

Now give `P` a characteristic label and give `X` a compatible
strict label. The actual attachment is a pushout in `nCat/D_1`.
Taking its full fiber gives, canonically,

```
Y_epsilon =
  X_epsilon amalg_{U_n(A_epsilon)} U_n(P_epsilon).
Ob(Y) = Ob(X) amalg_A P = Ob(X) disjoint_union (P minus A).
```

The last equality uses injectivity of `A -> P`, not of `a`.
Taking two membership labels and their maximum computes their
common zero fiber. Hence any two sieves of `P` containing `A`
and covering `P` give actual full sieve subcategories of `Y`,
whose full intersection is the corresponding pushout over the
intersection. These equations already incorporate old-object,
old-arrow, and higher-cell identifications. They do not assert
that quotienting a free-generator union creates no new
composites.

For two full sieves covering the objects of a strict category,
every Street simplex is in one piece: choose a piece containing
its last vertex, use the oriental arrows from every earlier
vertex to that last vertex, then use fullness for every cell.
The nerves are therefore an actual union of simplicial subsets,
with intersection the nerve of the full intersection.

## Universal couniversality argument

This section quantifies over every attaching target and attaching
map throughout; the finite experiments are not its premises.

First suppose `E minus A` has a greatest element `x`, and put
`t=r(x)`. Define `k` to fix `A` and send all new elements to
`t`; define `g` to fix `A` and send all new elements to `x`.
For an old-to-new comparable pair `b <= y`, adjunction and
`y <= x` give `b <= t <= x`. The sieve condition excludes the
new-to-old case. Thus both maps are monotone, `id <= g` and
`k <= g`. Both comparisons satisfy (AC), as well as the
manuscript's stronger constancy hypotheses, and fix `A`.

The whole stationary prisms therefore glue over the given
arbitrary attachment and give

```
id_Y -> G <- K.
```

Write `k=i bar_k` for its factorization through a retraction
`bar_k : E -> A`. The maps `id_X` and `a U_n(bar_k)` induce
`p : Y -> X`. Their restrictions give `pj=id_X` and `jp=K`.
The nerve homotopies above, followed by ordinary topological
reversal of the second homotopy, make `N(p)` a homotopy inverse
to `N(j)`. No reversed directed cylinder is needed.

For finite `E`, induct on `|E minus A|`, simultaneously for
all `X,a`. The empty complement is the identity case; the
greatest-element case is just proved. Otherwise choose two
distinct maximal new elements `x_1,x_2`. They are also maximal
in `E` because `A` is a sieve. Deleting either, or both, gives
three smaller sieves containing `A`, with the same restricted
right-adjoint retraction. The actual-fiber calculation identifies
their attachments `Y_1,Y_2` with full sieves covering `Y` and
their intersection with `Y_12`.

Their nerves are therefore a pushout over monomorphisms.
The map of spans from the constant identity span on `N(X)`
to `N(Y_1) <- N(Y_12) -> N(Y_2)` has all three vertical maps
weak equivalences by induction. Simplicial gluing gives a weak
equivalence on pushouts. Its top pushout is `N(X)` and its
bottom pushout is `N(Y)`, with induced map exactly `N(j)`.
This does not require the local cylinders on different pieces
to agree.

For arbitrary `E`, let `q=ir`. The finite subsets `F` satisfying
`q(F) subset F` form a nonempty filtered system under union;
every finite set `T` is contained in the finite stable set
`T union q(T)` since `q^2=q`. With full induced orders,
`A_F=A intersection F` is a sieve and `r|F : F -> A_F` is a
right-adjoint retraction. It is not necessary for `F` to be a
sieve of `E`.

Each ordinary nerve simplex has finite support, so
`N(E)=colim N(F)` and `N(A)=colim N(A_F)`. Left adjointness of
`c_n` and the pushout universal property give

```
colim_F (X amalg_{U_n(A_F)} U_n(F))
  = X amalg_{U_n(A)} U_n(E).
```

The copy of `X` is fixed in this diagram. A compatible cocone
uses the same map on `X` because the indexing category is
nonempty and connected. This proves the displayed equality
even when the transition maps of attachments identify cells.

Filtered colimits of strict categories are computed on cells:
represent finitely many cells and matching-boundary equations
at a common stage, compose there, and use a later stage for
independence and the strict laws. An oriental has finitely many
polygraphic generators and boundary equations. Its hom functor
therefore preserves filtered colimits; reflection gives the
same fact for truncated orientals. Thus Street nerve preserves
this filtered colimit.

Finally simplicial weak equivalences are closed under filtered
colimits without an injectivity assumption. One direct proof
applies `Ex^infinity`, which preserves filtered colimits because
each subdivision of a representable is finite. Filtered
colimits of Kan complexes are Kan since horns have finite
support. Components, based spheres, and homotopies between
them are finite simplicial data, so their representatives and
equalities are detected at some stage. Consequently components
and based homotopy groups commute with these colimits. Apply
this to the objectwise weak equivalences and use
`K -> Ex^infinity K` and two-out-of-three. This completes the
universal argument, in finite positive dimensions and omega.

The simplicial gluing input likewise needs only the classical
Kan--Quillen structure, not a transferred higher-category model
structure. For clarity, for a map of spans
`A <- C -> B` to `A' <- C' -> B'` with monomorphic right legs,
put `D=B amalg_C C'`. Left properness makes `B -> D` a weak
equivalence, hence `D -> B'` one as well. Both objects under
`C'` are cofibrant; cobase change to `A'` preserves that weak
equivalence. Left properness applied to `A -> A'` finishes the
comparison of pushouts. These are standard simplicial
homotopy-theory inputs, not consequences of the target theorem.

## Exact replay and its boundaries

Run from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/couniversality_audit/verify.py
```

The retained run checked 60,240 prism tensor-basis equations,
40,410 simplex-operator equations, and 7,386 stationary basis
cases. It considered 408 naturally ordered finite posets
(all isomorphism types through five objects occur),
1,349 sieve/retract pairs and 40,855 finite-stable-closure cases.
There were 264 actual ordinary-category attachments to a
one-object two-element monoid, identifying every old object,
with old strict arrows sent either to identities or to the
absorbing idempotent. Their actual composite tables,
associativity, canonical functor equations, and 562 full-sieve
fiber identifications were checked. These are genuinely
category-valued regressions, but only in dimension one.

For clarity, the ordinary-category model used in this experiment
is an actual pushout by the following independent universal-property
argument; the script does not enumerate all outgoing functors.
Its objects are those of `X` and the new objects of `E`. Old-to-old
hom sets are those of `X`, new-to-new hom sets are the poset hom
sets, new-to-old hom sets are empty, and
`Hom(x,e)=Hom_X(x,a(r(e)))` for an old object `x` and a new object
`e`. Composing onward to `e'` uses `a(r(e)<=r(e'))`.
Given agreeing functors `F:X->Z` and `G:E->Z`, the image of such
a mixed arrow `h` must be
`G(r(e)<=e) F(h)`. This defines the unique extension. It preserves
composition because the two poset paths
`r(e)<=e<=e'` and `r(e)<=r(e')<=e'` agree. The other composition
types are internal to `X` or `E`, or precompose `h` inside `X`.
Every mixed arrow has the indicated factorization, so uniqueness
does not assume injectivity of `a`, faithful old arrows, or
distinct old object images.

The zero-top-chain example maps the square's top chain to zero
while its two one-boundaries remain the nonidentity edge
`[0,1]`. It is the identity two-cell on that edge, not the
identity on an object. The replay checks these retained
boundaries explicitly.

The script also certifies failure of the *unrestricted* append
shortcut for `E={0<1<2}`, `A={0}`, `f=ir=const_0`, `g=id`.
On `[1,2]`, `dC=0` but

```
Cd = [0,2] - [0,1] - [1,2] != 0.
```

The pair satisfies the couniversality hypotheses but violates
the relative-prism hypothesis that the upper map is constant
on the new complement. This is **not** a refutation of either
literal manuscript assertion. The route is retired for this
explicit reason rather than silently retried.

The Jacobian adapter's exact operation was
`chain_complex.tensor_product.compute` on the two interval
complexes. The exact payload and full typed envelope are in
`jacobian_payload.json` and `jacobian_output.json`. The server
reported version `0.14.0`, protocol `2025-11-25`, typed success,
and no adapter error or timeout. The replay independently
checks the square's differential and its Koszul sign. This
operation concerns a finite chain complex, not couniversality.

The native Lean certificate is
`lean/certificates/C_AUDIT_KERNEL-328e1a861c44e370.json`.
Its source and statement-fidelity hashes are checked by the
Python replay; that replay does not claim to be a fresh
compiler invocation. The genuine native invocation was:

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/couniversality_audit/lean/Main.lean --statement-fidelity research/couniversality_audit/lean/statement_fidelity.md --artifact-dir research/couniversality_audit/lean --project-root . --claim C_AUDIT_KERNEL --timeout 100
```

All five printed axiom closures contain only `propext`,
`Classical.choice`, and `Quot.sound`.

## Remaining certification barriers

The pinned public development has an explicit, source-level
faithful route to both finite and omega couniversality, rather
than only a `SimplexDescent` hypothesis. Its unmodified build
requires Lean 4.34.1 and another Mathlib revision. A real
4.34.1 import against the assigned 4.31 library failed with an
incompatible-header error. A second, distinct bounded attempt
compiled the source under 4.31; it stopped in the first module
after 55.453 seconds on missing `ite_eq_left`/`ite_eq_right`
and associated proof errors. Neither failure refutes the
mathematics. No full backport has been established, and the
public wrapper remains an explicitly unchecked text draft.
The upstream library sources are retained as `.lean.txt`
primary-source archives, not as purported compiler-certified
local `.lean` deliverables; the manifest records their paths.

The durable receipt is task `couniversality-lean431-compat`,
run `couniversality-lean431-compat-1793912035995787221`, initially
`state=submitted`. Its prescribed status command returned
`state=error`, exit one, and `live=false`; it was not a lost
or timed-out mathematical proof.

The Engineer read the actual arXiv sources for the Gray
extension, Steiner functor/presentation, oriental realization,
and Gagna comparison. These readings are not independent
attribution of the Engineer's own ledger assumptions.
Moreover the installed `citation_check attribute` archives
under `research/literature/`, outside this mission's explicit
writable boundary. It was not invoked with a false identity
or a different project root to bypass that boundary. The
primary sources are preserved inside the owned
`research/couniversality_audit/literature/` subtree; native
independent attribution remains outstanding.
There are three distinct arXiv propositions, recorded both for
the original prism and for generalized append descent. The
standard simplicial model and Kan-replacement inputs are
transparently source-only assumptions, not cleared citations.

The full source of the cited Goerss--Jardine book propositions
was not obtained during this round: the publisher book-page
fetch returned HTTP 406, and the author's course page directs
readers to institutional Springer access. The standard simplicial
model-category input must therefore remain explicitly
unverified as a citation, rather than acquire a fictitious
locator check.

Independent statement-fidelity review, the complete
categorical/topological proof, and a publishability/novelty
verdict remain for the Host-invoked Reviewer. A positive
judgement on the Lean core alone would not satisfy the live
objective.
