# Ordinary generation of the prime-five overlap

Put S=S_5-complete, A_i=L_i S, Q=HQ_5, R_i=L_K(i) S, and
X=L_2 L_K(3) S. All maps below are S-module maps. The category is
the homotopy category of E(2)-local S-modules, not a category of
compact spectra. Put G=A_2 vee A_1 vee Q.

The level-one objects are retracts of finite sums of arbitrary shifts
of G. The subsequent levels allow extensions and retracts. These are
the conventions of Stacks, Section 13.36, Tag 09SI; Lemma 13.36.1,
Tag 0FX9, gives extension associativity. Neither citation is a
characterization by ghosts.

**Previously reviewed result: 2 <= level_G(X) <= 3.** The lower bound below
excludes every level-one retract, not merely a retraction of the
canonical unit. It does not exclude arbitrary two-layer presentations.
Section 3 isolates one scalar whose vanishing gives an actual
two-layer presentation. The new proof in `degree-five/proof.md`
computes c=0 through the full ordinary rank-two-kernel comparison,
constructs that presentation and deduces level_G(X)=2. This delta
awaits independent review; the previously reviewed arguments below
are retained without alteration.

## 1. Accepted inputs and source boundaries

The sealed independent verdicts for C318H3BASES, C318H3P5,
C318TAU3 and C318RATNORETRACT are reused without reopening their
proofs or rerunning their certificates.

Section 7 of `research/prime-five-height-three/proof.md` gives
triangles

    B_1 -> X -> Y -> Sigma B_1,
    B_2 -> Y -> V -> Sigma B_2,

where

    B_1 = A_2 vee Sigma^-1 A_2,
    B_2 = Sigma^-3 A_1 vee Sigma^-4 A_1,
    V = Sigma^-5 Q vee Sigma^-6 Q vee Sigma^-8 Q vee Sigma^-9 Q.

Thus X has level at most THREE, not merely eight. The maps of B_1
and B_2 use the accepted common classes 1,y_1,y_2,y_1 y_2.
The object Y is E(1)-local, and the actual map B_2 -> Y is a
K(1)-equivalence and is injective on rational homotopy.

The following other accepted facts are used:

* L_0 A_i=Q, with rational homotopy only in degree zero.
* K(2)-localization identifies X with R_2 vee Sigma^-1 R_2.
* The canonical comparison tau_2:L_0 X -> L_0 L_K(2) X is nonzero
  on pi_-3 (C318TAU3, the premise of C318RATNORETRACT).
* The rational homotopy of R_2 is exterior in degrees -1,-3;
  that of R_1 is exterior in degree -1. These are the known BSSW
  calculation, arXiv:2402.00960v2, Theorem A, already used in the
  accepted proofs.
* The rational degrees of X are 0,-1,-3,-4,-5,-6,-8,-9, each once.

The mission's bounded lookup did not locate an exact ordinary-level
theorem for this pair (X,G). This is a search limitation, not evidence
of novelty. The preceding no-retraction corollary remains the
strongest previously accepted obstruction. No false assertion in
the staged manuscripts is identified here.

One additional known input used for the smaller-core reduction in
Section 3 is the odd-prime height-two splitting

    L_1 R_2 = A_1 vee Sigma^-1 A_1 vee Sigma^-3 Q vee Sigma^-4 Q.

This is Barthel--Beaudry, arXiv:1901.09004v2, Theorem 6.7, in the
archived primary text. The reduction uses only this unpointed
equivalence, not an identification of its unit summand. It is not a
new height-two theorem.

## 2. A lower bound against all level-one retracts

We prove a general observation, then apply it. Suppose Z is a
retract of a finite sum P of shifts of A_2,A_1,Q. Write i:Z->P,
r:P->Z with ri=1 and e=ir. Apply ordinary K(2)-localization and
then rationalization.

Only the A_2 summands survive K(2)-localization. For each integer d
let N_d be the number of copies of Sigma^d A_2 in P. Only finitely
many N_d are nonzero. A component of e between A_2 summands with
shifts d and d' is, by localization adjunction, an element of
pi_(d-d') A_2. After rationalization this component vanishes unless
d=d', because pi_* L_0 A_2 is Q_5 in degree zero only. When the shifts
agree its localized map is scalar multiplication on R_2.

Consequently L_0 L_K(2)e is the direct sum, over d, of constant
idempotent matrices E_d on N_d copies of Sigma^d L_0 R_2. The
lower-height summands and every matrix entry involving one of them
are zero after K(2)-localization. Set m_d=rank_(Q_5) E_d. Its image
has Hilbert Laurent polynomial

    H_Z(t) = (1+t^-1)(1+t^-3) sum_d m_d t^d.                 (2.1)

This argument concerns an arbitrary finite presentation and its
arbitrary idempotent. No compactness, Krull--Schmidt theorem,
classification of spectra, or converse ghost lemma is used.

Apply (2.1) to Z=X. The accepted K(2)-basis gives

    H_X(t) = (1+t^-1)(1+t^-3)(1+t^-1).

Cancellation in the integral domain Z[t,t^-1] implies

    sum_d m_d t^d = 1+t^-1.

In particular m_-3=0. An idempotent matrix of rank zero is zero,
so E_-3=0.

Naturality factors the canonical comparison for X as

    L_0 X --L_0 i--> L_0 P --tau_P--> L_0 L_K(2) P
                                      --L_0 L_K(2)r--> L_0 L_K(2)X.

On pi_-3 the map tau_P only uses copies of Sigma^-3 A_2:
lower-height summands localize to zero, and L_0 Sigma^d A_2 has
homotopy only in degree d. But r e=r, and the localized rational
idempotent is zero on exactly this shift block. Thus the last map
kills tau_P in degree -3. This would make tau_2 zero on pi_-3,
contrary to C318TAU3.

Therefore X is not a level-one object, including after arbitrary
retracts. Combined with Section 1 this proves the displayed bounds.
This is stronger than failure of the canonical unit to retract;
it still proves no level-three lower bound.

## 3. The single remaining attachment in the chosen three blocks

Fix the actual triangle B_2 -> Y -> V of Section 1 and its actual
unit-first K(1)-basis

    L_K(1)Y = Sigma^-3 R_1 vee Sigma^-4 R_1.

Write z for a nonzero generator of pi_-1 L_0 R_1. Rational
comparison for B_2 sends its two rational generators to the unit
of the corresponding shifted R_1. Naturality gives precisely
these images for the two generators of L_0 Y in degrees -3,-4.

There is a single possible additional image. The rational degrees
of the two target summands are

    -3,-4     and     -4,-5.

Among the complementary degrees -5,-6,-8,-9 only -5 occurs.
Thus, after choosing a nonzero vector v_5 in pi_-5 L_0 Y, there
is a unique scalar c in Q_5 with

    tau_1(v_5) = c z in the Sigma^-4 R_1 summand,             (3.1)

and comparison is zero on the complementary degrees -6,-8,-9.
Changing v_5 or z rescales c by a nonzero scalar; whether c=0
is intrinsic. There is no degree-minus-five vector from B_2
that can change v_5.

**Conditional compression theorem.** If c=0, then

    Y = B_2 vee V,
    B_1 -> X -> B_2 vee V -> Sigma B_1

is a two-layer presentation, and level_G(X)=2.

**Proof.** Use the E(1)-local fracture square

    Y = L_K(1)Y x_(L_0 L_K(1)Y) L_0 Y.

If c=0, the rational inclusion of V into L_0 Y has null composite
to the overlap. Its map to the K(1)-local corner is zero. A choice
of that nullhomotopy therefore lifts it to a map V->Y. Together
with the existing map B_2->Y, it gives B_2 vee V -> Y which is
both a K(1)-equivalence and a rational equivalence, hence an
E(1)-local equivalence. The first triangle now has both end blocks
in level one. Section 2 excludes level one. QED.

Conversely, a splitting of this particular second triangle makes
(3.1) zero by naturality, since V is K(1)-acyclic. This converse
only concerns the chosen block triangle. A nonzero c would NOT
exclude all two-layer presentations of X.

For comparison with the attachment description, the height-one
fracture square for A_1 and K(1)-locality of R_1 give

    F_S(Q,A_1) = fib(Q -> L_0 R_1) = Sigma^-2 Q.

Here F_S(Q,R_1)=0 by localization adjunction, and the unit is
an isomorphism on rational degree zero. Hence the only possible
component of V -> Sigma B_2 is

    Sigma^-5 Q -> Sigma^-3 A_1,

coming from the degree-minus-four summand of B_2. Its scalar is,
up to the fixed rotation sign and normalizations, c in (3.1).
All other components vanish by their degrees. This identifies
the missing datum without assuming it is nonzero.

### Both scalar cases and a smaller core

The other case also has a complete description. If c is nonzero,
rescale v_5 so that its image is z. The rational comparison diagram
for Y is then the direct sum of the diagrams for

    Sigma^-3 A_1,  Sigma^-4 R_1,
    Sigma^-6 Q,    Sigma^-8 Q,    Sigma^-9 Q.

Indeed the first diagram has its unit in rational degree -3.
The second has the identity comparison on its rational degrees
-4,-5. The remaining three diagrams have zero K(1)-corner.
These are exactly the coordinates of the comparison already
computed above; there are no other degrees or unrecorded cross
components. Finite direct sums commute with the fracture
pullback. Consequently

    c=0:  Y = B_2 vee Sigma^-5 Q vee V',
    c!=0: Y = Sigma^-3 A_1 vee Sigma^-4 R_1 vee V',
    V' = Sigma^-6 Q vee Sigma^-8 Q vee Sigma^-9 Q.          (3.2)

The dichotomy itself does not assert which case occurs. The new
`degree-five/proof.md` decides the zero case separately. In the nonzero case
the second triangle is nonsplit, but this alone says nothing
about arbitrary two-layer presentations of X.

The summands V' can also be removed from X itself. Apply F_S(Q,-)
to the height-two fracture triangle for A_2. Mapping Q into the
K(2)-local corner R_2 is zero by localization adjunction, so

    F_S(Q,A_2) = fib(F_S(Q,A_1) -> F_S(Q,L_1 R_2)).

The height-two splitting stated in Section 1 and
F_S(Q,A_1)=Sigma^-2 Q identify the target, as an unpointed
rational spectrum, with

    Sigma^-2 Q vee Sigma^-3 Q vee Sigma^-3 Q vee Sigma^-4 Q.

No identification of the map from Sigma^-2 Q is needed:
its fiber has no homotopy below degree -5. Thus

    pi_d F_S(Q,Sigma B_1)=0 for d<-5.

Every map V'->Sigma B_1 is zero. In either decomposition (3.2)
the boundary Y->Sigma B_1 therefore vanishes on V'. Taking its
fiber gives an actual splitting

    X = Z vee Sigma^-6 Q vee Sigma^-8 Q vee Sigma^-9 Q,    (3.3)

where Z fits in B_1->Z->Y_0 and

    c=0:  Y_0=B_2 vee Sigma^-5 Q,
    c!=0: Y_0=Sigma^-3 A_1 vee Sigma^-4 R_1.

The rational homotopy of Z has exactly the five degrees
0,-1,-3,-4,-5. Its positive-height bases are unchanged.
Since the removed summands are in level one and levels are
closed under finite sums and retracts,

    level_G(X)=level_G(Z).                                (3.4)

This equality applies to arbitrary presentations and retracts,
not only presentations respecting (3.3). It reduces the exact
question without answering it. The known height-one triangle
A_1->R_1->Sigma^-1 Q shows that the nonzero case still has a
three-block upper bound. It does not give a two-layer one.

## 4. What the available calculations do not decide

The accepted residue theorem says that xi_3 acts by zero in the
ordinary mod-five coefficient calculation. It does not compute
(3.1). After full K(1)-descent the degree-one class of R_1 can
combine with the degree-four basis vector to give degree five.
Forgetting the P_1-action can erase exactly this type of
secondary equivariant class. The retired forget-and-inflate
inference in `research/rational-unit-obstruction/proof.md`,
Section 3, must not be used to set c=0.

Likewise the nonzero K(2)-comparison on pi_-3 computes the first
middle attachment, not the scalar (3.1). Nonzero attachments in a
chosen filtration do not by themselves prove minimal generation
level three.

The finite exterior-algebra calculation in `verify.py` exhibits
two graded comparison systems with c=0 and c=1. They have the same
rational dimensions, the same actual-unit positions in the
positive-height bases, and the same nonzero degree-minus-three
K(2) comparison. They are algebraic diagnostic models only. They
are not spectra, are not a realization theorem, and do not prove
either value of c for X.

Before the new degree-five computation, the exact-level question required either:
an equivariant computation making c=0 and the preceding
compression applicable; a different actual two-layer presentation;
or a universal two-layer obstruction (for example two genuine
G-ghosts with nonzero composite and all Hom-vanishings proved).
The lower bound of Section 2 supplies none of those missing
assertions.

## 5. The ghost implication, and a failed concrete choice

A G-ghost is a map f such that Hom(Sigma^d G,f)=0 for every
integer d. The same vanishing holds with any level-one object
in place of Sigma^d G: use finite sums and then retracts.

Here is the implication that would give a genuine lower bound.
If f:X->Z and g:Z->T are G-ghosts and gf is nonzero, X is not
level two. Indeed suppose X is a retract of E with maps i,r and
a triangle A->E->B with A,B level one. The restriction of fr to
A is zero, so exactness of Hom(-,Z) factors fr through B. The
second ghost kills every map from B, hence gfr=0. Precomposing
with i gives gf=0, a contradiction. This proof assumes no
compactness and asserts no converse.

The canonical quotient maps X->Y and Y->V are NOT such a pair.
The first is an isomorphism on rational degree -3, because B_1
has rational homotopy only in degrees 0,-1. The second is an
isomorphism on rational degree -5, because B_2 has rational
homotopy only in degrees -3,-4. These rational groups are
nonzero. Thus each quotient induces a nonzero map on some
ordinary homotopy element before rationalization: otherwise
its rationalization would also induce zero. For an E(2)-local
S-module M, Hom(Sigma^d A_2,M)=pi_d M by adjunction. Since A_2
is a summand of G, each quotient fails the required G-ghost
vanishing. Their composite is nonzero on rational degree -5,
but that fact is not a two-ghost lower bound.

Likewise a nonzero attachment whose domain is a summand of a
shift of G cannot itself be a G-ghost: the identity of that
summand already detects it. The canonical quotient route is
retired for the specific Hom-vanishing failure above, not for
lack of a finite matrix witness. Constructing different genuine
ghosts remains an open route.
