# One arithmetic ambient-open map for the two explicit frames

This is the component-separation argument for the Borisov-Keum input.
It uses the actual globally defined morphisms in the cited frame
construction, not two unrelated local retractions and not a
smooth-equivalence assertion. The retained independent judgement
`judgement-C16-02af88d22cc6` supports the current C16 statement.
Its frame-map source is independently attributed in
`research/literature/afade0f9dbe0759ca2e56f7f1ba376f1.json`;
the recovery argument below is a separate mathematical deduction.

Let K=Q(r), r^2=-7. Use the concrete 84-cubic ideals I_+,I_- in
`research/sources/c6_followup/explicit_arithmetic_input.md`, and put

    B_+ = I_+ + (U0,...,U9)^5,
    J_+ = I_+*T + (U0,...,U9)^5 + (Y0,...,Y9)^2 + Q,
    Q = U0*Y0 + ... + U9*Y9,

with the minus ideals obtained by coefficient conjugation.
Here B_+ denotes an ideal, not its quotient, in this note.
The exact computation gives length 4803 for T/J_+ and T/J_-.

## 1. Fixed rational group actions and fixed Hilbert functions

All parameter schemes and morphisms in this section are over Q.
Let

    H = Hilb^4803(A^20_Q).

Use the total dilation G_xy, dilation G_y of only the Y variables,
and the 100-dimensional shear group G of Jelisiejew equation (3.4),
in precisely the convention of his Diagram (4.1).

The total-graded Hilbert function at both frames is

    h = (1,20,154,676,1558,2394).

The bigraded Hilbert function has only Y-degrees 0 and 1:

    h_(p,0) = (1,10,55,136,253)_p,
    h_(p,1) = (10,99,540,1305,2394)_p,   0<=p<=4.

Fix these components of the respective graded Hilbert functors.
For a torus action, the ranks of each weight summand of a finite
locally free quotient are locally constant, so this restriction is
open and closed in the fixed locus. In particular it can be made
for both frames at once and is invariant under conjugation.

## 2. The two BB inverses are common rational maps

The BB schemes and their evaluation-at-one, limit, and fixed-point
maps are constructed over the base ring, not separately at each
geometric point. Write the two global action-evaluation maps as

    theta_xy : A^20 x H^+ -> H,
    theta_y  : G x (H^{G_xy})^{+,G_y} -> H^{G_xy}.

Their limit projections are pi_xy and pi_y.

Apply the constructions in Jelisiejew,
**arXiv:1812.08531v2**, Propositions 4.5 and 4.7, on the rational
open loci used in their proofs. Namely, take the etale locus of
theta_xy, and for theta_y take the etale locus with the
injective Lie(G)-action condition at the bigraded limit used in
Lemma 4.6. Restrict to the fixed Hilbert functions just specified.
These are properties of the universal morphisms and finite
tangent maps, hence are defined over Q.

The proofs show universal injectivity on these loci: for
theta_xy it is the uniqueness of the supported translate and
BB lift; for theta_y it is the shear uniqueness proved using
Lemma 4.6. An etale universally injective morphism is an open
immersion. Thus, exactly as in those propositions, their inverses
are regular on their open images. Use those images, not an
arbitrarily chosen isomorphism of completed local rings.

Both (0,[J_+]) and (0,[J_-]) belong to the respective loci.
Indeed, the exact initial ideal

    in(I_+)=(U0,...,U6)^3

shows that S/I_+ is free over K[U7,U8,U9], of rank 36. Thus it
has depth 3, and I_2=0. Lemma 4.3 applies to the frame of size
a=4. The same facts hold after conjugation. The tangent and
obstruction hypotheses in Propositions 4.5 and 4.7 are therefore
met at both frames.

Equivalently, treat the K-valued frame as a single closed point
q of H over Q. Its residue field really is K: the monic reduced
basis has a nonrational coefficient, recorded in the finite
construction-data certificate. The two complex frames are the
two geometric lifts of q. The open-immersion proofs apply at
this one point using the same universal rational morphisms.
A rational open containing q contains both lifts. This is not
the retired argument that only preserved the smooth-equivalence
singularity type of Spec(K).

Compose each inverse with its limit projection. Restrict the first
open image by the inverse image of the second open image. The
result is a SINGLE Q-defined open W_0 in H, containing both
frames, with a SINGLE Q-morphism

    rho_0 : W_0 -> H^{G_xy x G_y}

sending each frame to itself as a bigraded ideal.

This construction is compatible on overlaps because it inverts
the same global action-evaluation maps. There is no independent
choice of a formal neighborhood or retraction at the two points.

## 3. Recover the U-only truncation functorially

For a bigraded ideal L with the fixed bigraded Hilbert function,
take its Y-degree-zero part. This gives an ideal L intersect S,
with quotient Hilbert function

    h_B=(1,10,55,136,253).

The operation is compatible with base change: it is the kernel
of the map from S to the degree-zero direct summand of the
universal quotient. Each graded piece is locally free of its
specified rank. Hence it defines a Q-morphism

    rho_B : H^{G_xy x G_y}_{h_bi} -> Hilb^{h_B}_{graded}(A^10).

It sends J_+ to B_+ and J_- to B_-. This is the U-only
recovery expressed by the flag maps in Propositions 4.8-4.9;
for the present pair it also has the direct degree-zero
description above.

## 4. An explicit degree-three chart gives the common Proj map

Here the computed initial ideal allows a more concrete construction
than invoking a sufficiently large truncation inverse.

Put v=(U0,...,U6) and w=(U7,U8,U9). Use degree reverse
lexicographic order with U0>...>U9, as in the exact computation.
The 84 degree-three monomials in v are precisely the largest
84 monomials of degree three. Let P_3 be the remaining 136
degree-three monomials.

In the graded h_B Hilbert scheme let W_B be the open where the
images of P_3 form a basis of the degree-three quotient. This is
one explicit determinant condition, and holds at B_+ and B_-.
Over W_B the degree-three ideal has a unique marked basis

    f_m = m - sum_{t in P_3} a_(m,t) t,   |m|=3, m in K[v].

The coefficients are regular functions on W_B. Define I' to be
the homogeneous ideal generated by these 84 polynomials.

The following degree-four argument proves that these are a
Groebner basis for EVERY point of W_B, and works over arbitrary
parameter algebras as well. There are exactly 462 degree-four
monomials divisible by a degree-three monomial in v. Choose one
product U_i*f_m for each such leading monomial. Their distinct
leading monomials give a monic triangular system, so they are
independent and their quotient in degree four is free of rank
715-462=253. They lie in the degree-four ideal of the given
h_B quotient, whose quotient is also locally free of rank253.
The resulting surjection between these two rank253 quotients
is an isomorphism. Therefore every degree-four S-polynomial of
the f_m reduces to zero.

These degree-four pairs suffice. For any two degree-three
monomials in v dividing a monomial l, move between them by
transferring one variable factor at a time, keeping every
intermediate degree-three divisor inside l. Consecutive
divisors have lcm of degree four. This writes the lcm syzygy
of the original pair as a sum of monomial multiples of the
degree-four syzygies, with every intermediate lcm dividing l.
Their zero reductions thus give a standard representation of
every S-polynomial. Buchberger's criterion proves the assertion.
No infinite-degree persistence assumption is being substituted.

It follows that

    in(I') = (U0,...,U6)^3

over the ENTIRE explicit open W_B. The quotient S/I' is free
over the parameter algebra tensored with Q[U7,U8,U9], with the
36 monomials in U0,...,U6 of degree at most two as a basis.
In particular it is flat, has Hilbert function
P(j)=18*j^2-9*j+1 for all j>=0, and is saturated
(multiplication by U9 is injective, so there is no irrelevant
ideal torsion). Taking Proj therefore gives a Q-morphism

    psi : W_B -> H_surf = Hilb^P(P^9_Q),
    psi(B') = Proj(S/I').

At B_+ and B_- it recovers I_+ and I_-, because their computed
full Groebner bases are exactly their marked degree-three bases.

Thus, restricting W_0 by (rho_B rho_0)^(-1)(W_B) gives one
Q-defined open W containing both frames and one Q-morphism

    rho : W -> H_surf,
    rho = psi o rho_B o rho_0.

It sends the two frames to their respective surfaces. This
construction is explicit on the same determinant chart for both.

For comparison only, Erman **arXiv:1205.0587v1**, Proposition3.1,
has the bound m>=reg(I)+2, met here by m=5. That source was
read to check the cutoff, but the direct marked-basis argument
above now supplies the map without depending on that theorem.

## 5. Consequence: the frames share no irreducible component

The surface input gives two distinct rigid projective-Hilbert
orbits with no common irreducible component. In detail, fake
projective planes are rigid, q=0 prevents a varying polarization,
and the bicanonical system has dimension 10. A reduced
neighborhood of either point consists of its PGL_10 orbit.
The two surfaces are nonisomorphic: the primary no-real-structure
theorem together with the odd order 21 of Aut(X) excludes an
antiholomorphic automorphism. Thus the two orbit closures are
distinct and neither special point is in their intersection.

Suppose an irreducible component Z of H_C contained both frames.
Then Z intersect W_C is a nonempty irreducible open containing
both. Its image under rho has irreducible closure in H_surf,C
containing both surface points. An irreducible closed subset is
contained in an irreducible component; this contradicts the
surface separation.

Therefore J_+ and J_- share no irreducible component of
Hilb^4803(A^20_C). More strongly, for EVERY component Z
containing J_+, its conjugate contains J_- and is distinct
from Z. This uniform conclusion avoids any unsupported
uniqueness or smoothness assertion about the frames.

This conclusion is the new implication needed by C10. It is not
inferred from the finite arithmetic alone; the cited geometric
inputs and the common-map argument are essential.
