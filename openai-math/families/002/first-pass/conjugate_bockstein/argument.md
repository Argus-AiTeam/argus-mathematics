# Conjugate Bockstein alternation: scoped audit

## Exact source and scope

The target is the staged two-primary manuscript, October 6, 2026,
`build/sections/12-alternation-imaginary.tex`, Lemma
`alternation-imaginary:alternation` and Corollary
`alternation-imaginary:parity`. The comparison targets are the October 7,
2026 exact-BSD manuscript, `build/sections/04-vertical.tex`, Lemma
`vertical:parity`, and `09-unit.tex`, Proposition
`unit:simultaneous-jumps`. All paths below are relative to the campaign's
`research/openai_manuscript/` directory.

The two-primary lemma uses a free rank-two representation T from Q over a
complete integer, order, or power-series coefficient ring R, a perfect
alternating determinant form e valued in R(1), an imaginary quadratic
field K, and an anticyclotomic character chi. On the restriction of the
induced representation, the two twists are opposite and

    B((a,b),(a',b')) = e(a,b') + e(b,a').

Complex conjugation interchanges the summands using the ordinary
T-action C, where e(Ca,Cb) = -e(a,b). For a regular scalar s, the claim
is diagonal vanishing of the compact Selmer pairing
`<x, partial x>` modulo s, with partial induced by reduction modulo
s squared. Skew-symmetry alone is not this claim at two.

The allowed local data are an unrestricted split coordinate and a strict
other coordinate (or zero), and unramified cochains over K at newly
allowed odd quadratic-discriminant primes where T and chi are unramified
over K. The latter must retain the specified residue-cochain isotropy
homotopy. The induced inertia invariants are the graph
`b = delta^(-1) a`. Zero conditions are not asserted self-orthogonal.
The manuscript also invokes the contractibility of the induced real Tate
complex, Shapiro trace with no factor two, compatible finite models, and
passage to scalar localizations and limits. These are obligations to
check, not conclusions of a matrix experiment.

The parity corollary additionally assumes a perfect two-term DVR complex
in degrees 1 and 2, perfect shift-minus-three self-duality, and the
preceding diagonal vanishing. Its proof uses s equal to a sufficiently
large power of a uniformizer, not only the first Bockstein modulo the
uniformizer.

## Source comparison

The odd-primary argument explicitly uses that 2 is a unit to
antisymmetrize a transferred pairing on a minimal two-term model. This
does not supply a dyadic proof. Its sign convention is the same B above;
it is not the ordinary height symmetry. The later simultaneous-jumps
argument uses even one-sided jump dimensions and alternating
differentials, and then needs additional obstruction-span and
codimension assertions outside this audit's scope.

There are three different sign questions. B is alternating on the
coefficient module. Its local cup pairing in degrees (1,1) is
symmetric: the cup sign and the coefficient-form sign cancel, as
the two-primary source itself notes in `13-real.tex`, line 313.
The form at issue here is instead `b(x,y)=P(x,partial y)` for the
compact degree-(1,2) pairing P and this specific Bockstein. Its
zero diagonal is a stronger assertion than skew-symmetry at two.
No identification with an ordinary p-adic height, nor any symmetry
assertion about an ordinary or conjugate height, is used as a proof.

The immediate dyadic use is `12-alternation-imaginary.tex`,
lines 279--284: after the stated acyclic-place replacements,
parity makes the residual generic dimension h even and permits
rank-two dimension reduction. Further explicit uses are
`13-real.tex`, lines 313, 355, 399 and 536, including the
alternating-linking-form step of a Pfaffian construction.
This audit verifies the common alternation/parity input, not
those applications' additional acyclicity, regular-sequence,
residual-comparison or transversality assertions.

No relevant prior BSD/Bockstein topic was located in the shared Wiki
index. The stronger prior result relevant here is the manuscript's
integral diagonal-vanishing claim, not the odd-primary matrix argument.
The verification below independently reconstructs its compact primitive
and proves the slightly stronger even-multiplicity conclusion for every
positive elementary-divisor exponent. That strengthening is a standard
consequence of alternating Artin-module theory, not a novelty claim.

## Verification theorem

Under precisely the coefficient, stage-diagram, local-condition and
isotropy conventions stated above and in Section 3 of the two-primary
source, the conjugate Bockstein form has zero diagonal for every regular
scalar s. For the self-dual two-term DVR complexes of the corollary,
every positive elementary-divisor exponent occurs with even
multiplicity. In particular generic and special H1 dimensions have the
same parity. This verifies the stated bridge; it does not verify the
remaining BSD argument or the obstruction-span claims.

### 1. Central extension and actions

Write A=R/(s^2), I=sA, so I^2=0. Use the group H with vector coordinate
(a,b), central coordinate z and multiplication

    (a,b,z)(a',b',z')=(a+a',b+b',z+z'+e(a,b')).

Its inverse is (-a,-b,-z+e(a,b)). Bilinearity proves associativity,
and the commutator is B, with the plus sign in the source. These
identities hold in every commutative coefficient ring.

An element of G_K acts diagonally on the two twists and by its
cyclotomic multiplier on the center. The opposite character scalars
cancel in e(a,b'), so this is a group action on H. Complex conjugation
acts by

    F(a,b,z)=(Cb,Ca,-z+e(a,b)).

The anti-isometry e(Ca,Cb)=-e(a,b), alternation of e, and C^2=1 prove
that F is an automorphism and F^2=1. The anticyclotomic character
identity proves its compatibility with conjugation of G_K. No
diagonalization of C over R is used.

The section (sy)->(sy,0) on I times the vector module is additive
and equivariant: every quadratic correction has a factor s^2.
Conjugation by a lift of a vector v changes the center of (sy,z) by
s B(v,y). This calculation does not require s to be cancellable in A.

### 2. Global associativity defect

Use the cohomological differential, so a degree-zero coboundary is
`da(g)=g a-a`. A Selmer degree-one cocycle is a full localization
triple (x,X_v,a_v), with x_v=X_v+da_v. There is no assumption that its
global component detects the Selmer class.

Choose its linear lift modulo s^2 as in the Bockstein construction,
and choose any central lift to H. Write its multiplicative defect as

    D(g,h)=(s y(g,h),delta(g,h)).

Here y is the chosen global Bockstein cochain. In the identity

    D(g,h)D(gh,k)
      = [tilde x(g) gD(h,k) tilde x(g)^(-1)] D(g,hk),

all products of two s-vector terms vanish in the central coordinate.
The conjugation formula therefore gives

    d delta = -s B(x cup y).                              (1)

This is the actual degree-three cup, not a symmetry argument or a
test on a finite list of matrices.

### 3. Local defects and the specified compact primitive

For each place choose a lift A_v of a_v and a lift tilde X of the
local-condition cochain. A reference lift is
`A_v^(-1) tilde X(g) gA_v`. If the defect of tilde X is
`(sY,delta_U)`, its reference defect is

    (sY,delta_U-s B(a_v,Y)).

Write the actual local lift as `(s b_v,ell_v)` times that reference
lift. Kernel additivity and conjugation give exactly

    y_v = Y + d b_v,
    delta_v = delta_U-s B(a_v,Y)+d ell_v+s B(x_v cup b_v).  (2)

For example, the latter follows by multiplying, in order, the kernel
factor at g, its conjugated factor at h, the reference defect, and
the inverse kernel factor at gh. This fixes both potentially
ambiguous local signs.

Let p0 be the *specified* local primitive of B(X cup Y). The local
conditions below give

    delta_U+s p0=d h_v.                                   (3)

Then

    q_v=p0+B(a_v cup Y)-B(x_v cup b_v)

is a primitive of B(x_v cup y_v), by the cup Leibniz rule. A common
alternative cone-cup convention has primitive
`p0+B(a_v cup y_v)-B(X cup b_v)`; its difference from q_v is
`d B(a_v cup b_v)`, so the compact class is unchanged.

In the compact mapping-fiber convention
`D(g,l)=(dg,res(g)-dl)`, equations (1)--(3) say

    D(-delta,-(h+ell))=s (B(x cup y),(q_v)_v).              (4)

Thus the s-multiple of the full compact cup is a boundary. This
includes the localization homotopies, not just its global image.

### 4. Every allowed local condition

At a split coordinate condition the extension and its action have
zero central correction on that coordinate. The lifted vectors stay
in that coordinate. Hence delta_U=0 and the stated cup nullhomotopy
is p0=0. The zero condition is the same computation with X=Y=0.
Self-orthogonality of a zero condition is not used.

At an allowed odd discriminant prime, the cyclotomic action of
inertia is trivial. On the vector module a quadratic inertia
generator acts by `(a,b)->(delta b,delta^(-1)a)`. Its lift on H is
`(a,b,z)->(delta b,delta^(-1)a,z-e(a,b))`. On the invariant graph
`b=delta^(-1)a`, alternation gives e(a,b)=0, so graph-with-center
is inertia-fixed integrally. It is stable under the decomposition
group. Consequently the lifted unramified cochains and delta_U
are genuine residue cochains over the *same* residue field.

The residue pro-2 cohomology is computed by the two-term procyclic
resolution in degrees 0 and 1, so H2 is zero at every finite
precision. The retained residue nullhomotopy supplies p0 with
`d p0=B(X cup Y)`. Equation (1) on the residue group makes
delta_U+s p0 a 2-cocycle; H2=0 gives (3). There is no averaging by
the ramification index. In particular B on this graph is generally
`2 delta^(-1)e`, not zero; treating the graph as pointwise isotropic
would be a false shortcut.

At infinity, the change of coordinates `(a,b)->(a,Cb)` identifies
the vector action with an ordinary swap. In its Tate resolution,
the kernels of swap-minus-one and one-plus-swap are respectively
the diagonal and anti-diagonal, and both are the images of the
other map, with integral splittings. Thus the induced real Tate
complex is contractible without dividing by two. Its ordinary H1
vanishes, so use X=Y=0 and the above reference-lift calculation in
positive degrees. It gives (2)--(3) directly and hence the required
Tate primitive. The *scalar* Tate complex is not discarded.

### 5. Compact invariant and regularity

Take the compact invariant of (4). It is natural in the scalar
coefficient, so the scalar diagonal value t in R/(s) satisfies

    j(t)=0 in R/(s^2),  j(r mod s)=sr mod s^2.

This j is injective exactly because s is regular: sr=s^2k implies
s(r-sk)=0 and hence r=sk. Therefore t=0. Reversing all cup or
mapping-fiber orientations consistently changes signs in (4), not
its vanishing. No sign choice or division by two supplies the
injectivity.

The arithmetic input here is the Tate-modified compact invariant,
not the unmodified real-place statement. The primary source is
J.S. Milne, *Arithmetic Duality Theorems*, second edition, author's
2006-07-01 version, ISBN 1-4196-4274-X,
<https://www.jmilne.org/math/Books/ADTnot.pdf>. One can obtain the
required top compact invariant directly from the Galois form
I.4.10(b,c), pp.56--57, without assuming an additional
etale-to-Galois comparison over Q at two. Its hypothesis and
the end of its exact sequence are:

> Let M be a finite G_S-module whose order is a unit in R_{K,S}.
>
> H^2(G_S,M) -> P_S^2(K,M) -> H^0(G_S,M^D)^* -> 0.

The same theorem, part (c), identifies global degree-r cohomology
with the product of its real local terms for r>=3. The compact
mapping-fiber long exact sequence therefore identifies
H_c^3(M) with the cokernel of global-to-local degree-two
localization, hence with the finite dual of H^0(M^D). For
M=A(1), its Tate dual is the constant finite dual module of A.
Finite biduality gives H_c^3(A(1))=A naturally in A. The order
condition holds at every Artin stage because its coefficients
are two-primary and the support contains the places over two.
This proof uses no scalar-ring Gorenstein hypothesis.

For comparison, the compact-support definition in II.2
(pp.165--166) uses complete resolutions at real places; II.2.6
(p.169) constructs the same trace normalization, and II.3.1(b)
(p.177) gives finite-coefficient duality. Its exact
hypothesis-bearing passage is:

> If F is constructible, then
> Ext^r_U(F,G_m) x H_c^{3-r}(U,F) -> H_c^3(U,G_m)
> is a nondegenerate pairing of finite groups for all r in Z.

This is consistent with the direct Galois calculation above;
it is not being used to erase the real terms or to posit an
unstated comparison theorem.

The norm compatibility is explicitly proved in II.3.10 (p.182):

> The left hand arrow commutes with the invariant maps, and so the
> right hand arrow commutes with the trace maps.

Thus Shapiro followed by corestriction preserves the compact
invariant; it does not multiply it by two. Restriction, in contrast,
must not be substituted for corestriction. This primary-source
reading is recorded by the Engineer; independent citation
attribution and review remain pending.

### 6. Finite precision, limits, and the stated replacements

For a complete source ring, first choose the Bockstein linear data
in its free Selmer model modulo s^2. The model chain equations are
`d tilde x=s y` and
`tilde x_v-tilde X-d tilde a_v=s b_v`; y,Y,b also satisfy their
mod-s cocycle equations. At each fixed Artin quotient of R/(s^2),
the marked model maps of Section 3 transfer these equations to
actual stage cochains on an ultrafilter-large set. The lifted
coordinate or invariant-graph maps, residue nullhomotopy, compact
cup and trace are the very maps retained in those diagrams.

Equations (1)--(4) only use multiplication in the square-zero image
ideal and the displayed linear equations. They never divide by s
at an Artin precision. This distinction matters: for R=Z_2[[t]],
s=2 and the quotient by (4,2t,t^2), t is nonzero modulo s but
s*t=0. That finite quotient cannot be used for scalar cancellation.

At each precision equation (4) nevertheless gives zero scalar
trace in that quotient of R/(s^2). The retained trace maps are
scalar-compatible. The resulting trace element in R/(s^2) is zero
in all its cofinal Artin quotients and therefore is zero, by
completeness and separation. Only *now* apply regularity of s in
R to get the claimed diagonal vanishing in R/(s). Compatible
choices of nonlinear primitives across precisions are not needed:
it is their zero trace values that pass to the limit.

If a local condition and its full local complex become
contractible after one of the source's scalar localizations,
replace that condition by zero. The resulting map of integral
Selmer complexes is a quasi-isomorphism after localization, and
its compact pairing restricts to the original pairing (the zero
condition has no isotropy correction). Finite free models allow
clearing all the finitely many denominators in a class and its
linear Bockstein equations before applying (4). Inverting again
recovers vanishing; a cleared scalar unit acts quadratically on
the diagonal value. Regularity is needed only for the final
scalar injection in the testing ring, not at the auxiliary Artin
precisions. For the source's integral power-series curve base
changes, repeat the same calculation with the base-changed
marked diagrams and a regular scalar in that ring. No statement
is made for an arbitrary local condition without the specified
isotropy homotopy.

### 7. DVR parity and elementary divisors

Let C be the corollary's two-term perfect DVR complex and let pi
be a uniformizer. Remove unit Smith blocks. Write r for the
number of zero differential blocks and a_i>0 for the finite
elementary-divisor exponents. Shift-minus-three perfect duality
ensures the degree-one and degree-two ranks agree.

Choose N>=1 at least every a_i and put A=R/(pi^N). A finite block
`[R --pi^a--> R]` has

    H1=pi^(N-a)R/pi^N,  H2=R/pi^a,
    beta(pi^(N-a) z)=z mod pi^a.

Indeed its lifted differential is pi^N z, whose quotient by
pi^N is z. This is a well-defined isomorphism of the two cyclic
A-modules. A zero block has beta=0. This computation covers a=N,
and shows why checking only beta modulo pi is insufficient.

For completeness, the Smith decomposition used here follows by
choosing a nonzero differential entry of least valuation and
eliminating its row and column by integral elementary operations,
then inducting on the matrix size. Zero entries terminate the
process. On each resulting cyclic block,
`Hom_A(A/(pi^a),A)=pi^(N-a)A`; on a zero block the dual is A
itself. Computing the dual two-term complex block by block
therefore identifies its cohomology with the A-dual of the
opposite cohomology. Applying the assumed chain-level perfect
self-duality gives a perfect A-valued pairing P between H1 and H2.
This proves the particular consequence of Artin self-injectivity
needed here without importing a separate classification theorem.
Set b(x,y)=P(x,beta y). The already proved lemma makes b
alternating. Polarization, valid even at two, gives
`b(y,x)=-b(x,y)`. Perfectness of P now identifies either radical
of b with ker(beta), the free-lifting summand A^r.

Consequently b descends to an injective map from
M=H1/ker(beta) into Hom_A(M,A). A cyclic module A/(pi^a) and its
A-dual have the same length, so this injection is an isomorphism.
Thus M has a perfect alternating A-valued pairing.

Here is the full splitting argument, including modules that are
not free over A. Choose x of maximal order pi^a as a generator of
a cyclic summand. The functional taking x to pi^(N-a) and the
other summands to zero exists. Perfectness provides y with
b(x,y)=pi^(N-a). Every element, including y, is killed by pi^a.
The pairing shows that a relation u*x+v*y=0 forces u and v
divisible by pi^a, so their span is (R/pi^a)^2.

For any z, the values b(z,y), b(z,x) lie in
pi^(N-a)A. Divide these values into R/pi^a, a well-defined
operation, obtaining alpha and gamma. Then

    z_H=alpha*x-gamma*y

has exactly the same pairings with x and y as z, because
b(y,x)=-pi^(N-a) and both diagonal entries vanish. Hence z-z_H
is orthogonal to the span. This defines an A-linear orthogonal
direct-sum splitting, whose complement is again perfect
alternating. The length strictly decreases. Induction splits M
as hyperbolic pairs of equal exponent. In particular *each*
positive exponent a_i occurs an even number of times.

Generic H1 has dimension r, whereas special H1 has dimension
r+#(a_i). Their difference is even. This proof divides a
coefficient in an annihilator ideal into its canonical cyclic
quotient, never divides by two, and never infers an even number
of generators merely from even module length.

## Extent of the conclusion

The source-faithful result is a universal verification of the
alternation-to-parity bridge, with the stated arithmetic compact
trace as an explicitly cited standard input. No
hypothesis-compliant counterexample has been found, and the
one-dimensional skew pairing over F2 is only a counterexample to
the discarded skew-only inference.

The Lean source certifies the universal central-extension,
compact-boundary/trace-cancellation, radical-kernel and normalized
hyperbolic algebra. Its separate fidelity document explicitly
excludes arithmetic duality, finite-model existence and the full
Artin-module classification from the encoded statement. The
standalone exact verifier checks integer polynomial identities
and boundary controls; its finite block checks are supplementary,
not the proof of the universal theorem.

Independent Reviewer replay and citation attribution are still
required. Publication-level novelty has not been established;
this is a bounded campaign milestone, not completion of the
unrestricted BSD audit.

## Reproduction

From the campaign directory, `python3
research/conjugate_bockstein/verify.py` replays the exact identities
and supplementary boundary checks, validates the current Lean
source/fidelity binding, and compares the persisted certificate.
It has no third-party Python dependencies.

The real compiler command is

    $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/conjugate_bockstein/Main.lean --statement-fidelity research/conjugate_bockstein/statement_fidelity.md --claim CB_ALG --project-root .

The resulting `lean_check.json`, compile log and archived
certificate are generated by Argus, not asserted by the Python
identity checker. A compiler failure, timeout, missing toolchain,
changed source or changed fidelity document makes replay fail.
