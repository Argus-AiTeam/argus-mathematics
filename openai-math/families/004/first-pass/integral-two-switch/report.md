# Integral two-switch audit

## Exact scope and source dependencies

The target is the companion manuscript, *A pointwise 2-converse for
elliptic curves with rational two-torsion*, dated October 7, 2026,
`build/sections/ring-determinants.tex`, specifically `rd:local-model`
(lines 64-163), `rd:derivative` (182-409), and `rd:det-switch`
(473-566). The staged manuscripts are not modified.

The claimed dependency is:

1. `rl:finite-model`, `rl:finite-limits`, the integral Kummer condition,
   and `rl:global-duality` supply actual complexes, localization maps,
   contractions, and compatible dualities.
2. `rd:local-model` supplies the finite and singular integral planes and
   their conjugate-Weil cross pairing.
3. `rd:derivative` claims simultaneous descent with a single initial
   multiplier and both local switch identities.
4. `rd:det-switch` uses those actual dualities and identities to compare
   determinant tensors, including nonprimitive localization and torsion.
5. These feed `rd:ring-lower`, `rd:outer-bound`, and
   `rd:missing-vertex`. Together with other, unaudited inputs these feed
   the companion's `thm:main`.
6. The rational manuscript's `03-parity.tex`, `par:global-point`
   (458-525), invokes that converse to obtain finiteness of Sha and a
   rational point. Its finite-test reduction then uses this arithmetic
   input. A defect in the switch package would not by itself refute
   undecidability over the rationals.

## Known status at entry

The campaign ledger initially contained only the open campaign objective;
there was no earlier mathematical certificate to improve on. The inherited
Wiki index contains no entry on this switch, Heegner derivatives, Selmer
duality, or the pointwise two-converse. That is a retrieval result, not a
novelty claim.

The cyclic derivative identity and the rank-two alternating determinant
identity are elementary known algebra. Checking either alone cannot establish
the requested switch package. Likewise, bounded successful examples cannot
establish a multiplier uniform in the number of primes.

The manuscript explicitly does not import Howard's odd-prime global theorem
at 2. Its reference to Proposition 1.7.4 is a comparison of local calculations.
The applicability of external duality and Tate-image results remains to be
checked separately from the displayed algebra. The audit must retain the
coefficient transfer, descent ambiguity, local boundary witnesses, and
integral determinant lattices rather than replace them by rational
cohomology groups.

The result below improves that initial open state by giving a general proof,
a sharpness extension for natural descent, and a fully coherent integral
test family. It does not turn an inaccessible external source or an
unverified arithmetic realization into a proved fact.

## Result and its exact boundary

**Uniform descent and integral-switch theorem.** The following statements
hold.

**(A) Natural simultaneous descent.** Let r:A -> B be a homomorphism of
abelian groups. Suppose a positive integer h kills ker(r) and B/im(r).
There is a canonical additive, natural map

    D_h:B -> A,       r D_h(b) = h^2 b.

It uses one h^2 for the entire restriction problem, irrespective of how
many generators or primes define it. The factor h^2 is optimal for a
construction natural in all such restriction diagrams: for every h >= 2,
one example forces any universally natural clearing factor q to be
divisible by h^2.

**(B) Integral determinant switch.** Let O be a DVR, and use the exact
perfect integral strict/finite/singular/relaxed diagram, compatible
duality maps, degree-zero local conditions, and unimodular conjugate-Weil
pairing in `rd:local-model` and `rd:det-switch`. Assume the generic
concentration and old rank-one hypothesis in `rd:det-switch`. If the
actual classes satisfy

    f(A)=v != 0,       f(B)=0,       s(B)=Jv,

and their functionals come from these compatible dualities, then the
new generic cohomology is rank one and

    val(u_F) = val(u_S).

There is no bound on val(v), and no primitive-localization hypothesis.
For any finite sequence of such switches, the coordinate changes only
by a product of integral units. Common strict torsion is retained
throughout.

**(C) Coherent nonprimitive family.** There is an explicit integral
diagram over every DVR and every nonzero p in it with

    f(A)=p e_1,       s(B)=p e_1=Jf(A),
    H^2(C_str)_tors = (O/p)^2,
    u_F=-p^(-2),      u_S=p^(-2).

The diagram includes perfect plane dualities, an integral deformation
retraction for strict/relaxed duality, their actual comparison maps,
and the local cup-product defect. Thus it verifies the torsion-sensitive
comparison for every p=2^d, d >= 0, not just for small d.

Part (A), its integer sharpness obstruction, the full matrix identities
of (C), and the algebraic volume and iteration lemmas are formalized in
Lean. The intrinsic determinant argument in (B) is proved below in
ordinary mathematics. Symbolic normal forms and adjugates independently
check (C).

**Arithmetic qualification.** The application to the manuscript's
Heegner classes also needs its fixed scalar-homothety input, actual
Heegner trace/reduction relations, local unramified descent, and
the actual compatible target Selmer diagrams. The argument below states
precisely how these inputs imply the uniform switch. The scalar's cited
group-level source was not obtained; the global arithmetic diagrams
are not reconstructed by the concrete matrix family. Consequently this
is a general verification theorem with an explicit arithmetic
applicability boundary, not an unconditional certification of every
arithmetic assertion of `rd:derivative` or `CITS-DIAGRAMS`.

No hypothesis-complete elliptic-curve counterexample is claimed.
Novelty, significance, and independent mathematical acceptance remain
for the Host-invoked Reviewer. In particular this report is not a
certification of the pointwise converse or of undecidability over Q.

## Proof of natural simultaneous descent and sharpness

For b in B, choose x with r(x)=h b and put D_h(b)=h x. Such an x
exists because h kills the cokernel. If x' is another choice, x-x'
is in ker(r), so h(x-x')=0. Thus the definition is independent of
the choice. Choosing x+y for b+c proves additivity. Restriction gives
r(hx)=h^2 b. In a commuting square, the image of x is a valid lift
of h times the image of b; independence proves naturality. Nothing
in the proof mentions a relative group order.

For sharpness let A=B=Z/(h^3), r(x)=h x, alpha(x)=(1+h^2)x,
and beta=identity. The kernel and cokernel of r are killed by h;
alpha is an automorphism since gcd(1+h^2,h^3)=1, and
r alpha = beta r. If a natural q-cleared descent sends 1 to x,
restriction and naturality require

    h^3 | h x-q,       h^3 | h^2 x.

Cancellation of h^2 in the second divisibility gives h|x. Substituting
in the first gives h^2|q. The choice q=h^2 is achieved by D_h above.
This proves sharpness in the category of natural restriction diagrams,
not necessity of that factor for each special Galois problem.

The Lean declarations `cleared_lifts_agree`,
`clearedDescent_restrict`, `clearedDescent_eq`,
`clearedDescent_add`, `clearedDescent_natural`, and
`optimal_natural_clearing` carry these precise algebraic assertions.

### Application to simultaneous ring-class descent

Let h=2^e annihilate E(H)[2-infinity] for every permitted ring-class
field H. The inflation-restriction sequence for the *whole* conductor
extension has kernel in H^1(G,E[2^a](H)) and obstruction in
H^2(G,E[2^a](H)). Both groups are killed by h: multiplication by h
already kills their entire coefficient cochain complex. Applying (A)
once to this restriction map descends h^2 times the invariant
derivative class, independently of the size or number of factors of G.
The same reasoning is coefficientwise valid for the finite Artin
coefficient modules, whose character is trivial over the upper field.

Here is the source's uniform torsion argument with its external input
exposed. Given g acting on T_2(E) by u*1, u in 1+4 Z_2, u != 1,
put z=g^2 tau g^2 tau^(-1), where tau is rational complex conjugation.
The square g^2 is in every quadratic subgroup. In every ring-class
quotient conjugation inverts the abelian action, so z acts trivially.
Its Tate action is u^4. Thus u^4-1 kills all the relevant torsion;
e=val_2(u^4-1) is fixed. This deduction is uniform in the conductor
and in the allowed quadratic fields. It does not prove existence of g.
That is the separate scalar-homothety assumption in the ledger.

The other fixed factors are a cuspidal annihilator L0 and a local
component-group factor C. At the finitely many places over 2N,
the conductor extensions are unramified. The usual connected
Neron-model unramified-descent assertion leaves only the component
group obstruction. Its orders are bounded over unramified extensions
of each fixed local type, so C can be fixed. This use of connected
unramified descent is an arithmetic input, not a consequence of the
abstract homomorphism lemma. Under it one may take

    L = L0 C h^2.

Every class for every conductor is constructed from this same L.
One does not descend by h^2 separately for each prime.

## Local identities and finite precision

Write m=ell+1 and D=sum( i sigma^i : 1 <= i < m ). Direct telescoping,
before imposing sigma^m=1, gives

    (sigma-1)D + sum(sigma^i : 0 <= i < m) - m
      = (m-1)(sigma^m-1).

This proves `rd:derivative-identity` for arbitrary m. The Lean proof
is induction, and the Python certificate checks both the base and the
polynomial induction step. It is not a finite check of cyclic orders.
Together with the actual trace relation, the identity makes the
derivative class invariant at the prescribed precision. The descent
in the previous section is then applied to the complete conductor.

For the local cup product let b=2^a and q=1+2bk. Then

    1-q = b(-2k),       binom(q,2)=bkq.

Both Fox coefficients vanish modulo b, including the pure-tame term.
The mixed terms are units. In the limit the local free model is
the exterior two-direction complex with H^0=M, H^1=M+M,
H^2=M and zero differentials. Extending coefficients to a finite
Artin algebra preserves this calculation. Conjugate transport is J
on the finite coordinate and -J on the tame coordinate. The
conjugate-Weil cross form is therefore a unit times <x,Jy>.
The pure planes are zero as pairing maps, so the zero isotropy
homotopies agree on the retained H^0. The strict and relaxed
conditions retain this H^0; they do not mean the zero and full
local complex. The duality between local H^0 and H^2 is also
retained, with H^2 omitted from these conditions.

For the derivative at ell, put X and Y for the lower and upper
points after applying every other derivative. Choose Q with
2^a Q=LX. The source's trace and reduction relations give

    f = (a_ell F-(ell+1)) Q,
    s = (a_ell-(ell+1)F) Q,
    F^2-a_ell F+ell=0.

All points here are reduced where F is defined. The exact difference
between (F-a_ell) times the first operator and the second is

    a_ell (F^2-a_ell F+ell).

It is zero, not merely divisible by 2. Thus s=(F-a_ell)f, and
at the retained precision a_ell=0 this is s=Ff. The Frobenius
limit is J.

The descent ambiguity must not be omitted in obtaining the singular
formula. If b is the descended cocycle and 2^a Z=L D_ell Y, set

    U=(sigma-1)Z-b(sigma).

Comparison of the two crossed-cocycle expansions of b(g sigma),
g in the upper-field subgroup, shows gU=U. Also

    2^a U=L((ell+1)Y-a_ell X).

Because the two integers are divisible by 2^a,

    U0=L((ell+1)/2^a)Y-L(a_ell/2^a)X

is an actual upper-field point with this multiple. Hence U-U0
is torsion killed by the same fixed h. Inertia is trivial on
reduction and Y reduces to FX, so reduction of b(sigma)=-U
gives the stated s, up to this bounded torsion. This comparison
uses integer quotients and an upper-field point; replacing U0
by an arbitrary division point would not justify the uniform bound.

For the new finite coordinate the derivative point reduces to

    ell(ell+1)/2 * F X.

Under ell+1=2^(a+1) k this is 2^a times the F^2-fixed point
ell*k*F X. The coefficient module also has trivial F^2 at the
retained precision. Any reduced 2^a-division point therefore has
zero finite Kummer coordinate. This proves f(P_new)=0. The
extra power of 2 is a precision requirement, not a new scalar
multiplier of the class. The Python certificate checks this
integer factorization for arbitrary k and b.

Finally project from precision a to m with a-m >= e. A discrepancy
killed by 2^e is multiplied by 2^(a-m) and vanishes. For any finite
set of primes choose one precision large enough for all its conditions.
There is no factor per prime. The same computation for a previously
chosen ell, with the other derivatives absorbed into X,Y, retains
its singular condition.

## Cochain transfers and comparison witnesses

Coefficient transfer is an integral Shapiro/coset-sum map followed
by [sigma] -> chi(sigma) Psi(sigma), with inverse actions if that
Shapiro convention is chosen. It never divides by the class-group
order. In each translate transport the place and tame orientation
first; the lower and upper weights are then the same. Additivity
and naturality of the cleared descent commute with these maps.

It matters that these operations occur on actual cochains before
contraction. If (i,p,h) is a strong contraction and z is a cycle,
then

    z-i p z=d h z.

For a cochain comparison f, the exact difference in the target is

    p' f z-p' f i p z = d(p' f h z).

Thus a retained boundary witness is p' f h z, not just an equality
between abstract cohomology groups. `transferred_boundary` is the
kernel-checked additive version of this formula. Likewise p sends
z-z'=d b to pz-pz'=d(pb). All specified duality homotopies,
including higher compatibility data, must be transported as data.
Over the finite Artin rings they are finite matrix identities;
fixed original contractions and the same ultrafilter preserve
them under a common slower cofinal precision.

This explains why the source's target-side construction, if performed
with those data, adds no denominator. It does not construct an
arithmetic map from a list of desired cohomology groups. Nekovar's
Theorem 6.3.4 has exactly this distinction; see the independent
primary-source findings. The source's bounded target ranks can
depend on the fixed finite number of derivative slots. The scalar
L above does not.

## Proof of the intrinsic determinant comparison

Work first over the fraction field K of O. The old localization is
nonzero on the one-dimensional H^1(C_F), so the strict H^1 is zero.
The relaxed localization image in F+S is self-annihilating for
the retained perfect local pairing; it has dimension two. It contains
the independent vectors (v,0) and (0,Jv). Therefore it is their
span, and its intersection with either plane has dimension one.
The new class B spans H^1(C_S). This uses the actual duality:
dimension counting alone would not give the self-annihilating image.

Let V=H^1(C_rel), with basis A,B. The same duality identifies
H^2(C_str) with V*, with dual basis A*,B*. The exact sequence
for the finite triangle is

    0 -> K A -> F -> V* -> K A* -> 0.

Compatibility says the boundary is dual to relaxed localization,
not an arbitrarily chosen map. Hence

    delta_F(x)=epsilon_F <x,v> B*,       epsilon_F in O^units.

Choose x over K with delta_F(x)=B*. Then <x,v> is a unit.
The Weil form is unimodular, so v wedge x is a generator of
the *integral* determinant lattice det_O(F), even when x itself
is fractional. Similarly choose y with delta_S(y)=A*;
Jv wedge y is a generator of det_O(S).

For explicit arbitrary divisibility, write v=p(a,b) with (a,b)
primitive, choose ar+bs=1, and take x=(-s/p,r/p). Then

    det(v,x)=ar+bs=1.

There is no inequality restricting val(p). The formal theorem
`nonprimitive_volume` proves precisely this identity. A unimodular
J changes this volume only by det(J), an integral unit.

The exact triangles give integral determinant-line isomorphisms

    D(C_F)=D(C_str) tensor det(F),
    D(C_S)=D(C_str) tensor det(S).

These are already integral: realize a triangle by a mapping cone
of bounded free complexes and split its graded terms. A bounded
acyclic free cone over a DVR contracts in unit disks; changing
to that presentation changes determinant bases only by units.
Thus no rational-cohomology replacement of the integral line is
being made.

Cancellation in the generic exact sequences sends the actual
class-functional tensors, up to determinant signs, to

    (A* wedge B*)^* tensor (v wedge x),
    (A* wedge B*)^* tensor (Jv wedge y).

The first factor, including its position in D(C_str), is common.
The two second factors generate their integral plane determinants,
which are identified by an integral isomorphism. The coordinates
therefore have equal valuation.

For clarity, an elementary torsion summand
[O --pi^d--> O] in degrees 1,2 contributes pi^(-d) in this
inverse-determinant convention. Such factors have not disappeared:
they occur in the common strict determinant and in the integral
triangle identifications. The argument also covers strict torsion
in other degrees; the mapping-cone determinant identity, not a
two-term torsion-free replacement, is what was used.

Repeating the argument gives u_n=epsilon_n ... epsilon_1 u_0
in compatible bases, with every epsilon_i an integral unit.
The formal `arbitrary_switch_count` proves the corresponding
valuation identity for every finite list. Scaling all initial
points by L scales the class-dual tensors by L^2 once; it is
not a repeated L^2 at each switch. This conclusion requires
nonzero localization at every switch where the rank-one lemma
is applied. No assertion is made for a zero localization.

## The fully coherent integral family

The matrices in `exact_certificate.json` are over Z[p]; specializing
to any DVR and nonzero p preserves the identities. All global
complexes are in degrees 1,2. The strict differential is

    D0 = [ 0   0
           0   0
           0  -p
           p   0 ].

The relaxed differential is [D0 | U], with local columns ordered
F1,F2,S1,S2. The finite and singular complexes use respectively
columns 1,2,3,4 and 1,2,5,6 of that relaxed matrix.
The vectors A=(0,1,p,0) and B=(1,0,p,0) are cycles. Their
localizations are both p e1, and J=diag(1,-1).

Let K1,K2 be the retained relative duality matrices, I1,I2 their
inverses, and H the displayed homotopy. The certificate checks

    K2 Dr = D0^t K1,       Dr I1 = I2 D0^t,
    K1 I1=1,              K2 I2=1,
    1-I1 K1=H Dr,         1-I2 K2=Dr H.

This is an integral homotopy equivalence, including torsion.
For each plane its duality is (-P^t,P) in degrees 1,2, so the
signed chain-map condition is P D+(P D)^t=0. The restrictions
of (K1,K2) are exactly these plane maps. The local duality defect is

    V^t U+U^t V = Q,       V=K1 restricted to the four local columns.

Here Q has zero pure-plane blocks and cross block

    [0  1; -1  0] J = [0 -1; -1 0].

Thus det(Q)=1, and this is the manuscript's conjugate-Weil
orientation, not an unrelated rational pairing. `coherent_diamond`
checks the full displayed identities over every commutative ring.

The plane pairing matrices are intentionally not termwise
invertible: each contains a contractible unit disk. Integral
unimodular row and column changes, explicitly recomputed by the
script, give

    D_F ~ diag(0,p,p,1),
    D_S ~ diag(0,-p,p,-1).

Their transformed pairing matrices have a zero unit-disk block
and a unimodular 3-by-3 block. Hence they are perfect derived
dualities, not merely nonzero generic maps. This also shows
the generic ranks and the two torsion factors p.

The actual functionals are lambda_F=-A^t P_F=(-1,0,0,0) and
lambda_S=-B^t P_S=(0,-1,0,0). For a rank-(n-1) based
two-term matrix D, its determinant coordinate u is characterized by

    u adj(D) = z lambda.

This follows by cancellation in a diagonal presentation and is
preserved under the recorded integral basis changes. The script
recomputes the entire adjugate equations, not only one minor.
They give u_F=-1/p^2 and u_S=1/p^2. In particular, for p=2^d
the valuation is -2d on both sides. Discarding strict torsion
would give the wrong answer even though it would preserve the
generic cohomology dimensions.

The local degree-zero and degree-two dual pieces can be attached
as in `rd:local-model`; the strict and both plane conditions retain
the same H^0 and exclude H^2. Their quotients are exactly the
degree-one planes used above. The displayed global model is an
algebraic test of those quotient triangles, not an assertion that
it is the Selmer complex of a particular elliptic curve.

## Exact replay and falsification controls

From the campaign root run:

    $WORKSPACE/argus-live-update/.venv/bin/python research/integral-two-switch/verify.py

The script recomputes universal polynomial identities, all integral
chain maps and homotopies, normal forms, the local pairing, actual
class functionals, and determinant coordinates. It replays the
retained Jacobian transformation certificate D=U A V, and checks
the real Lean 4.31.0 compiler/axiom-audit answer against the current
source and statement-fidelity document. The compiler-generated
digests are used only for the required freshness check.

Four deliberate invalid certificates must be rejected: an extra
factor 2 in the new functional; deletion of strict torsion; the
wrong J orientation; and replacement of the determinant coordinate
by its torsion-free cohomological proxy.

The Jacobian adapter was discovered and its exact typed Smith
operation inspected before execution. The retained operation is
`matrix.normal_form.smith.certified.compute`, server 0.14.0,
protocol 2025-11-25. Its payload and complete typed result are in
separate JSON files. The adapter exited 0 with no structured error.
At p=8 it returns Smith factors 1,8,8,0 and unimodular left/right
transformations. This one bounded calculation is supplementary;
it is not promoted into the proof for arbitrary p or switch count.

## What remains open

The general algebraic theorem and its concrete integral family
do not discharge the scalar-homothety literature input, connected
unramified descent, the CM-point trace/reduction input, or all
arithmetic target-diagram realizations. Howard's cited odd-prime
result cannot replace those verifications at 2. The independent
source reader confirmed Nekovar's complex-level hypotheses and
Howard's limitation; the Bogomolov locator remains unavailable.

These limits stay visible in the claim ledger and proof graph.
The campaign's source claims and main goal are not marked proved.
The intended next assessment is an independent replay and
statement-fidelity/significance review by the Host's Reviewer,
not an invented acceptance by the Engineer.

The complete native replay exited 0 with `status=PASS`, including
all four invalid-certificate rejections. The current Lean run
completed with compiler exit 0, axiom-audit exit 0, and
`proof_holes=[]` in Lean 4.31.0 (61,980 ms). Its archived certificate is
`lean/certificates/CITS-ALG-16211f6d28984c94.json`.
The ledger derives `CITS-ALG` version 5 as `closed_kernel`;
the statement-fidelity review is still unperformed. This kernel
status concerns the recorded algebraic formal statement only.
