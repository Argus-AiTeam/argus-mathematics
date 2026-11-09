# Generated sheaf excision and natural integral transfers

## Result and its limits

The three statements `lem:cutoff`, `thm:germs`, and `prop:open-cover`
are valid for the actual categories in section 2. In particular their
proofs do extend to arbitrary derived morphisms and to actual summands.
Below is a proof, not an inference from a finite experiment. No false
manuscript assertion or counterexample to these three statements was
found.

There is a stronger **conditional** consequence for
`thm:bounded-comparison`. Keeping the other Witt-theoretic inputs
explicit, its comparison in sphere dimension `j` has a two-sided
`2^j`-transfer. In particular its kernel and cokernel are killed by
`2^j`, uniformly in the Witt degree. This improves the manuscript's
nonoptimized exponent `3(9^j-1)/4` to `j`. It uses naturality of the
explicit doubling map, not just an exponent-two kernel/cokernel bound.

The sheaf-theoretic proofs here are human-readable mathematics. Lean
4.31.0 verifies the universal, torsion-sensitive abelian-group transfer
theorem and its iteration, not the sheaf categories or Hilbert-Smith.
The source readings do not certify every theorem in the manuscript.
Neither novelty nor publishability of this refinement has been
independently established. This result is a bounded Engineer milestone,
not closure of the publishable campaign or independent Reviewer approval.

## Source inputs

The local source is the staged manuscript dated September 23, 2026,
`The-Hilbert-Smith-conjecture-in-every-finite-dimension-September-23-2026`.
The category definitions are `build/sections/02-categories.tex`,
Definition `def:test-categories`. The assertions being checked are
`lem:cutoff`, `thm:germs`, and `prop:open-cover` in
`build/sections/03-localization.tex`, not statements about a constructible
subcategory.

The geometric proof uses exact open extension and restriction, their
derived adjunction, restriction of derived direct image to open subsets,
and the triangle and summand operations of the ambient bounded derived
category. Compatibility with duality additionally uses the duality and
pushforward comparisons stated in `prop:test-duality` and
`prop:test-pushforward`. These are explicit foundational inputs, not
computer-verified facts in this audit.

The implication for Witt groups is conditional on the manuscript's
`thm:homotopy`, `thm:witt-localization`, the elementary point calculation
`lat:point-groups`, and dense cofinality. The localization and cofinality
literature was checked against primary sources by the separate
`localization-sources` reader; the statements and their hypotheses are
preserved in `sources/primary_excerpts.md`. An analogy with the
Ranicki--Weiss chain-complex category is not used to justify arbitrary
derived morphisms here.

The inherited Wiki contains no source on these generated sheaf categories
or this manuscript's excision claim. Its supported-Euler page concerns a
different manuscript and supplies no theorem for the present argument.

The known invalid shortcut is to assume that restrictions land in the
compact-source test categories: even the restriction of the constant
sheaf on `[0,1]` to `(0,1)` fails their compact-support condition. This is
the manuscript's own `cat:restriction-caution`, not a newly discovered
false assertion. All germ Hom groups below use the ambient derived
category.

The scope dependencies were recorded before the proof-graph extension.
The external inputs remain visible as assumptions, rather than being
silently treated as computer-verified consequences. Their ledger source
fields are prose citations. The citation-attribution tool has a fixed
`research/literature/` archival destination outside this mission's
writable paths, so no literature-tier attribution is claimed here.
The independent primary-source readings are preserved inside the owned
directory instead. This is a declared evidence limitation, not permission
to omit a source reading or to relabel an author's reading as Reviewer
acceptance.

## 1. The ambient adjunction is the key point

Write `D(X)=D^b(Sh_R(X))`. For an open inclusion `j:N -> X`,
both `j_!` and `j^*` are exact and `j_!` is left adjoint to `j^*`.
The adjunction therefore holds in the derived categories for arbitrary
bounded complexes and arbitrary derived morphisms. If all the cohomology
of `C` vanishes outside `N`, the counit

    j_! j^* C -> C

is an isomorphism: on every cohomology stalk inside `N` it is the
identity, and outside `N` both sides are zero. Consequently

    Hom_D(X)(C,B) = Hom_D(N)(C|N,B|N)                 (1)

naturally in `B`. No membership of `B|N` or `C|N` in a test category
is used. Equality as well as existence of morphisms can be checked by
this bijection.

Every object of `B_0(X)` and `B(X)`, for `B=T` or `P`, vanishes
outside a compact subset of `X`. For generators use the compact image
of the source; shifts, finite sums, cones, and actual summands preserve
this property, using a finite union of compact bounds. All compact sets
are closed because the test spaces are Hausdorff.

The compatibility with duality used below is exactly the one from
section 2, not stalkwise algebraic biduality. On a closed simplex its
dualizing complex is the oriented interior constant sheaf extended by
zero and shifted by the dimension. The boundary triangle builds it
from constants on compact polyhedra. Proper duality sends a simplex
generator to its source-dual image, with the canonical biduality map
transported by evaluation and trace. Thus boundedness, membership,
and biduality extend by triangles and summands. A compact support
bound for an object is also a bound for its dual by open restriction.
For compact support in an open set, `j_! = Rj_*`, so proper-image
duality gives the duality-preserving open-extension functor. These
are the reductions in `prop:test-duality` and
`prop:test-pushforward`; the ambient duality identities they use are
the standard ones checked in the Schapira source reading.

## 2. Cutoff, including all derived cones

Fix a test space `X`, a closed `K` contained in an open `O`, and
first a generator `A=Rf_* R_B`. Here `B` is any compact finite
polyhedron and `f:B -> X` is allowed. Set `F=f^{-1}(K)`.
This is compact, and is contained in the relatively open `f^{-1}(O)`.
There is a sufficiently fine finite triangulation of `B` whose closed
stars meeting `F` lie in `f^{-1}(O)`: in a metric on the compact
polyhedron, use the positive distance from `F` to the closed complement
and a small mesh.

Set a piecewise-linear function `h` equal to zero on all vertices of
simplices meeting `F`, and one on the remaining vertices. Then `h=0`
on `F`, and every simplex containing a zero vertex lies in
`f^{-1}(O)`. Put

    E={h<1/2},    C={h<=1/2},    D=C\E.

After cutting along the level set, `C,D` are compact finite polyhedra
and `C` is contained in `f^{-1}(O)`. Also `C=closure(E)`: a simplex
with no zero vertex has empty intersection with `C`, while a point
of level `1/2` in any other simplex can be approached along a segment
to a zero vertex. If `F` is empty take `E=C=D=empty`; if the open
inverse image is all of `B`, taking `E=C=B,D=empty` is also allowed.

For `e:E -> B` the canonical map `e_! R_E -> R_B` gives

    s:A'=Rf_* e_! R_E -> Rf_* R_B.

The open-closed triangle on `C` builds `e_! R_E`, extended to `B`,
as the shifted cone of `R_C -> R_D`. Both compact sources map to
`O`. Composition of proper direct images therefore identifies `A'`
as the open extension of an object in `B_0(O)`. It vanishes off the
compact set `f(C)` inside `O`.

The open set `N=X\f(B\E)` contains `K`, since `B\E` is compact and
disjoint from `f^{-1}(K)`. Its inverse image lies in `E`, so restriction
of direct image to `N` identifies `s|N` with an isomorphism.
In the `P` case the finite piecewise-linear cuts `C,D` and all their
restricted maps are semialgebraic, even if `K,O` are not. No
semialgebraicity of `f^{-1}(K)` was assumed.

To pass from generators to *all* objects, consider the property just
proved with its universal quantifiers in `K,O`. It is closed under
shifts and finite sums. Suppose `a:A -> B` is any morphism in the
full ambient derived category between two objects having the property.
Choose `b:B' -> B` over `O`, invertible on an open `N` containing
`K`. Then choose `c:A' -> A` over `O intersect N`. By (1),

    (b|N)^{-1} (a|N) (c|N)

has a unique global lift `a':A' -> B'`. Applying the same bijection
with target `B` proves **the global equality** `ba'=ac`.
Completion of this square to a morphism of triangles gives

    Cone(a') -> Cone(a).

It is invertible on the intersection of the neighborhoods on which
`b,c` are invertible. Full faithfulness of open extension from `O`
places `a'`, hence its cone, in `B_0(O)` after restriction there.
The union of the two compact support bounds lies inside `O` and
bounds this cone. Thus the property is triangulated and contains
every generator. Finite triangulated generation proves the complete
statement `lem:cutoff`. In particular no representative chain map,
constructible model, or lift of an idempotent is required.

## 3. Recognizing the compact-support kernel, with summands

Let `j:U -> X` be open. An extended test object vanishes outside
a compact subset of `U`. Conversely suppose `S in B(X)` vanishes
outside such a compact `C`, and choose an actual splitting

    S --i--> A --r--> S,    ri=id,    A in B_0(X).

Cut off `A` over `U`, invertibly on a neighborhood `N` of `C`,
to obtain `s:A' -> A`. Apply (1) with source `S` to lift
`(s|N)^{-1}(i|N)` to `i':S -> A'`. The same adjunction proves
`si'=i` globally, hence `(rs)i'=id`. On restriction to `U`,
this makes `S|U` an actual summand of `A'|U in B_0(U)`.
Therefore `S|U in B(U)` and `j_!(S|U)=S`.

Finite unions of compact bounds, cohomology exact sequences, and
stalkwise splitting prove that this essential image is thick. Open
duality preserves vanishing outside `C`, so it is duality-stable.
This proves `prop:compact-support` without assuming that arbitrary
restriction preserves the test categories.

## 4. All morphisms in the ordinary quotient are germs

Let `K=X\U` and let `Q=B(X)/B(U)` be the ordinary Verdier quotient.
For a denominator whose cone is in `B(U)`, that cone vanishes on
`X\C` for a compact `C` inside `U`. The denominator is therefore
invertible near `K`. Restriction gives the stated canonical map from
quotient Hom groups to germ Hom groups.

For fullness first take `A in B_0(X)` and a representative
`v:A|N -> B|N` of a germ, with `N` open containing `K`. Cut off
`s:A' -> A` over `N`. By (1), `v(s|N)` extends to `t:A' -> B`.
The cone of `s` has a compact bound `C` and vanishes on some open
`M` containing `K`. It consequently vanishes outside the compact
`C\M` contained in `U`. Section 3 puts this cone in `B(U)`.
Thus the roof `A <-s- A' -t-> B` represents a quotient morphism
with germ `v`.

For general `A in B(X)`, take actual maps
`A -i-> A0 -p-> A` with `pi=id` and `A0 in B_0(X)`. Lift the
germ `v(p|N)` by the preceding case and compose its lift with `i`.
This proves fullness for arbitrary summand sources and targets.

For faithfulness first let `t:A -> B` be an actual morphism with
zero germ. Zero in this filtered colimit means zero on some
neighborhood `N` of `K`. For `A in B_0(X)`, cut off `s:A' -> A`
over `N`. Equation (1) implies `ts=0` globally, while `s` is
invertible in `Q`; hence `t=0` in `Q`. For summand sources apply
this argument to `tp:A0 -> B` and use `t=(tp)i`. Finally any
quotient morphism is a roof. Since its denominator is invertible
in germs, zero germ of the roof implies zero germ of its numerator,
to which the actual-morphism argument applies.

This proves exactly `thm:germs` for the *ordinary* quotient, not
only its idempotent completion. The map is induced by restriction,
so composition and distinguished triangles are respected. Open
restriction commutes with the bounded Verdier operations on these
objects, and the compact-support kernel is duality-stable; the
same canonical map therefore respects duality. There is no
application of duality to an arbitrary nonreflexive restricted
sheaf, and no assertion that `A|N` lies in `B(N)`.

## 5. The open-cover functor is fully faithful and dense

Suppose `X=U union V`. Open extension from `V` carries `B(U intersect V)`
into `B(U)`, so it induces the exact duality-preserving quotient
functor in `prop:open-cover`. Put `K=X\U`, which is closed in `X`
and contained in `V`. Open neighborhoods of `K` contained in `V`
are cofinal among its neighborhoods in `X`, by intersection with `V`.
Section 4 on `V` and `X` therefore identifies all the relevant Hom
groups, proving full faithfulness.

For `A0 in B_0(X)`, section 2 with `O=V` gives `A0' -> A0`
whose cone is compactly supported inside `U`. Thus `A0` in the
quotient is isomorphic to an image object from `B_0(V)`.
Every `A in B(X)` is an actual summand of some `A0`, and its
splitting maps survive the quotient. This proves the asserted
*actual-summand density*. It does not assert essential surjectivity
or split every idempotent in the ordinary quotient.

Fullness and exactness make the replete image triangulated, and
duality preservation makes it duality-stable. The underlying open
extensions are the same for `P` and `T`, so these functors commute
with their comparison. This finishes all clauses of `prop:open-cover`.

The arguments in sections 3-5 are also an abstract verification theorem:
any full compact-support triangulated family in the ambient derived
categories, closed under actual summands and possessing the section-2
cutoffs on its triangulated generators, has these support, germ, and
dense-excision properties. No constructible stratification enters.
No priority or novelty claim for this general principle is made here.

## 6. The extra naturality needed for a sharper exponent

Use the dense-doubling construction from `thm:dense-doubling`.
For a form `q=(x,alpha)` in the larger category, its doubled representative
is `D(q)=q perpendicular q perpendicular H(x[1])`. The manuscript's
well-definedness argument uses actual sums and triangles, not arbitrary
summand closure of the smaller category:

* Density and the cone of `0_y direct-sum id_z` give
  `y direct-sum y[1]` in the smaller category.
* Thus the underlying object of `D(q)` lies there.
* If `l -> x -> #l -> l[1]` is a lagrangian triangle, set
  `z=l direct-sum l[1]`. The stabilized doubled form has lagrangian
  `L=l direct-sum l direct-sum x[1] direct-sum #l direct-sum l[1]`.
  The cone of `a direct-sum 0:z -> x direct-sum x[1]` is
  `#l direct-sum x[1] direct-sum l[2]`. Add `z` and remove
  `l[1] direct-sum l[2]` by its split triangle, between objects
  already in the smaller category. This puts
  `#l direct-sum x[1] direct-sum l` there, hence also `L`.
  Fullness transports the whole lagrangian diagram. Neutral forms
  therefore map to zero.

This gives a homomorphism `d` with `i d=2` and `d i=2`.
The independent cofinality source reading confirms the weaker
exponent-two conclusion with precisely the appropriate hypotheses.

For the refinement, also observe that any exact duality-preserving
functor takes `D(q)` isometrically to `D(F(q))`: it preserves finite
orthogonal sums, shift, and the hyperbolic construction. Thus the
reverse homomorphisms `d` commute with the `P -> T` comparison.
For fully faithful functors, identify the source with its replete
image; the inverse equivalence on Witt groups does not require
choosing a lift of a quotient idempotent.

Here is the integral algebra, for arbitrary abelian groups:

    A0 --iA--> A1              dA:A1 -> A0
    |f         |g             dB:B1 -> B0
    B0 --iB--> B1

Suppose `g iA=iB f`, `dB g=f dA`,
`iA dA=2 id`, `iB dB=2 id`. If `t:B0 -> A0` satisfies
`ft=q id` and `tf=q id`, then `T=iA t dB` satisfies

    gT = iB f t dB = q iB dB = 2q id,
    Tg = iA t f dA = q iA dA = 2q id.              (2)

These are integral identities, valid in the presence of arbitrary
torsion and also when `q=0`. A two-sided transfer is stronger than
the statement that a kernel and cokernel are annihilated; it must
not be inferred from that statement alone.

`Main.lean` proves (2), its kernel and cokernel consequence, and
the iteration to `2^j` for all natural `j`. `verify.py` also checks
integer polynomial syzygies for both identities, with no division
by `q` or 2. The Jacobian rank computation is supplementary and
is explicitly over `Q(q)`; it is not used to remove torsion.

## 7. Exact consequence for bounded comparison

Retain the assumptions of homotopy invariance, the point comparison,
and natural integral Witt localization. The source reading verifies
that Balmer--Walter localization uses the ordinary quotient and that
the full thick duality-stable kernel from section 3 has the required
form. Essential smallness, invertibility of 2 on morphisms, and the
inherited TR4+ are the hypotheses stated in section 2 and the
localization proof of the manuscript.

For either theory `G`, let `Gtilde_r(Z)=ker(G_r(Z)->G_r(pt))`.
A chosen point splits this map naturally with respect to comparison.
For the two-pole cover of `S^j`, `j>=1`, put `I=U intersect V`.
Contractibility and localization give natural integral isomorphisms

    Q_r(X,U) = Gtilde_r(S^j),
    Q_r(V,I) = Gtilde_{r-1}(I)
             = Gtilde_{r-1}(S^{j-1}).              (3)

For the first, `G_r(U)->G_r(X)` is split injective in every degree,
and localization identifies its cokernel with the relative group.
For the second, `G_r(I)->G_r(V)` is split surjective: projection
to a point has a section from a chosen point of `I`. Exactness
then identifies the relative group's boundary with the kernel of
`G_{r-1}(I)->G_{r-1}(V)`. A chosen allowed homotopy equivalence
`I -> S^{j-1}` preserves projection to a point and gives the final
identification. These choices can be made semialgebraically, so
all the identifications commute with comparison.

The reduced comparison on `S^0` is an isomorphism, providing a
two-sided 1-transfer. If the reduced comparison on `S^{j-1}` in
degree `r-1` has a two-sided `2^{j-1}`-transfer, use (3) and the
open-cover square, with its natural doubling reverses. Equation
(2) gives a two-sided `2^j`-transfer on the reduced comparison on
`S^j` in degree `r`. This induction holds for every integer `r`.
For a fixed target `(j,r)`, the formal tower is along the diagonal
`(i,r-j+i)`, not at a mistakenly fixed Witt degree.

On the point summand use `2^j` times the inverse point comparison.
Together with the reduced transfer this gives a homomorphism

    t_{j,r}: E_r(S^j) -> F_r(S^j),
    comparison t_{j,r}=2^j id,
    t_{j,r} comparison=2^j id.

It follows directly that `2^j` annihilates both kernel and cokernel.
No finite generation of any Witt group has been used. Thus the three
localized category statements do supply the missing excision dependency
of `thm:bounded-comparison`. With the other recorded inputs, they even
allow `e_j=j`, instead of `e_j=9e_{j-1}+6`.

With the additional, separately unverified rational-sphere and generic
signature inputs from section 4, the fixed lattice may consequently
use `L_d=2^d`. This is not a proof of those extra inputs or of the
character construction, equality of parts, sum of classes, invariant
chart reduction, or Hilbert-Smith. The proof graph leaves those
campaign obligations open.

## Executable evidence

Run from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/generated_excision_audit/verify.py

The certificate binds the literal source statements, verifies the
integral transfer identities and finite torsion tests, and checks the
recorded real Lean result and Jacobian typed output. It does not
mechanically certify sections 1-5 or the geometric identifications (3).
The faithful formal statement and its explicit exclusions are in
`statement_fidelity.md`. Host-invoked independent Reviewer reading
and replay remain necessary.
