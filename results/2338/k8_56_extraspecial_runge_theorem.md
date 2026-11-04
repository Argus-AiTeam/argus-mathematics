# An actual extraspecial cover and its arithmetic pole action

## Result and status

This is an Engineer prose proof, with a rerunnable certificate for its new
finite algebra. Independent mathematical, citation, originality and
publishable-significance review is still required. No finite computation
below is a substitute for the quantified proof.

Let C be the smooth projective model of

    (T-1)(T-9)(T-25) = 384u(u^2-1)(u^2-4).

Write x=P_(25,2), y=P_infinity, J=Jac(C), and D=[x-y].
There is a geometrically connected finite etale pointed cover

    (Z,z_x) -> (C,x)

over Q, of degree 512 and genus 1537, with geometric deck group
E=2_+^(1+8). Its central quotient, as a pointed cover over Q, is exactly

    Y_1 = {(P,Q): 2Q=[P-y]-D},     basepoint (x,0).

The actual based Galois image on E is A=Aut(E). The actual Galois
permutation image on the 512-point fiber above y is

    G = Hol(E) = E semidirect Aut(E).

Here Aut(E) is the **nonsplit** extension V.O_8^+(2), V=E/Z(E).
Replacing Aut(E) by O_8^+(2) would give the wrong group.
For every number field K,

    r_Z(K) <= r_1(K)+r_2(K),

where r_Z(K) counts K-irreducible points of the reduced infinity fiber.
All these points are order-three poles of u. Consequently this cover
does not restore the strict direct-Runge pole condition over any K.
This says nothing about integral-point classification, complete Selmer
groups, exclusion of either surviving K(a)=8 system, or K(a)>=9.

The proof also gives the same conclusion for any smooth projective
genus-four curve over Q with two rational points x,y, a Galois-stable
plus quadratic refinement on J[2] with full O_8^+(2) image, and
[y-x] not in 2J(Q), for a function whose pole support is {y}.
These are explicit hypotheses, not a claim that arbitrary curves
have maximal image.

## 1. Inputs already settled, and what is not assumed

The unchanged reviewed claim
K-K8-56-THETA-2COVER-DIRECT-RUNGE-BOUNDARY, version 4, and
`k8_56_theta_2cover_runge_boundary.md` supply:

* C is smooth of genus four, y is rational and unique at infinity,
  and ord_y(u)=-3.
* The rational even theta characteristic 3y gives a Galois-stable
  quadratic refinement q on V=J[2], of plus type.
* The actual residue image is the full O=O_8^+(2). Its natural
  module is nontrivial irreducible, and H^1(O,V)=0.
* D is not in 2J(Q).

The reviewed multiplication-cover geometry identifies Y_1 with the
pointed mod-two Abel-Jacobi cover based at x. These results are reused,
not recomputed. In particular no accepted tower certificate is rerun.

One published group-theoretic input is needed: Griess (1973),
DOI 10.2140/pjm.1973.48.403, Theorem 1(a), pp. 406--407, says

    1 -> Inn(E) -> Aut(E) -> O_8^+(2) -> 1

is nonsplit. The independent source attribution already recorded for
L-K8-56-THETA-TWO-POWER-KNOWN-INGREDIENT-REDUCTION applies to exactly
this positive-type, rank-four extension.

The fundamental-group correspondence and comparison used in Section 3
are the SGA1 propositions specified in Section 9. There is no assumption
of a maximal arithmetic image, an embedding of a theta group into a
fundamental group, or a complete Selmer calculation.

## 2. A quotient of the actual geometric surface group

Let Pi be the maximal pro-two quotient of pi_1(C_Qbar,x).
Put

    F = closure of Pi^4 [Pi,Pi]^2 [[Pi,Pi],Pi],     U=Pi/F.

Powers and commutator subgroups here mean the closed generated
subgroups, not a set of individual powers. F is characteristic.
By complex comparison Pi has the pro-two surface presentation

    <a_1,b_1,...,a_4,b_4 | product_i [a_i,b_i]=1>.

Use the mod-two symplectic basis supplied by these surface
generators, ordered a_1,b_1,...,a_4,b_4. In these coordinates

    q(v)=sum_i q(e_i)v_i+sum_j v_(2j)v_(2j+1).

There is no requirement that this basis be Galois invariant,
or that its individual q-values vanish. Plus type means that
q admits a hyperbolic basis, not that every surface basis is one.

Here is an explicit finite model of U, which also verifies the
surface relation. In the free class-two, exponent-four group on
e_0,...,e_7, let

    t_i=e_i^2,       c_ij=[e_i,e_j] (i<j).

All these elements are central of exponent two. Before the surface
relation they form an independent 36-dimensional space W_0.
One direct construction, proving independence rather than presuming
it, is F_2^8 times W_0 with multiplication

    (v,w)(v',w') =
      (v+v', w+w'+sum_i v_i v'_i t_i
                      +sum_(i<j) v_j v'_i c_ij).

The correction is bilinear, hence satisfies the associativity
cocycle identity. Conversely collection of words in a class-two
group with these exponent relations gives exactly these normal
forms. Thus this is the required free quotient.

The surface word imposes the single nonzero central relation

    R = c_01+c_23+c_45+c_67 = 0.

Consequently U has order 2^43 and the central elementary subgroup

    W = <t_i,c_ij>/ <R>

has dimension 35; U/W=V. It is also Phi(U): squares and commutators
generate W. In particular, if a lift of v is changed by w in W,
its square does not change. There is a well-defined square map

    S:V -> W,       S(v)=sum_i v_i t_i+sum_(i<j) v_i v_j c_ij.

Its values span W, since

    S(e_i)=t_i,
    S(e_i+e_j)+S(e_i)+S(e_j)=c_ij.

Define a linear character lambda:W -> F_2 by

    lambda(t_i)=q(e_i),
    lambda(c_ij)=b(e_i,e_j),

where b is the polar form of q. It is well-defined on W:

    lambda(R)=1+1+1+1=0.

Moreover lambda(S(v))=q(v). These two checks are essential.
An abstract theta group would not establish either check on Pi.
The same prescription would fail for the canonical commutator
pairing in odd genus, since its surface word would map to the
nontrivial central element.

Now set N=ker(lambda) inside W and E=U/N. This is a genuine
quotient of Pi, not just an abstract central extension of V.
It has order 2^9, center and derived subgroup of order two, and
commutator pairing b. Choose a hyperbolic basis for q in E/Z(E)
and lifts h_i of those eight vectors. Their squares are trivial,
and their commutators are prescribed by b, so E has presentation

    z^2=1,  z central,  h_i^2=1,
    [h_(2j),h_(2j+1)]=z   (j=0,1,2,3),
    all other generator commutators equal 1.

It is the central product of four dihedral groups of order eight,
hence is the plus-type extraspecial group. Equivalently its square
quadratic form is q, of Arf invariant zero. The definition of lambda
is independent of the surface basis: it is the unique character
whose composition with S is q.

## 3. Galois stability, descent, and the precise central quotient

The rational point x splits the arithmetic fundamental sequence.
Thus G_Q acts by actual automorphisms on Pi, not merely by outer
automorphisms. It acts on U and W because F is characteristic and
W=Phi(U). The square map is equivariant:

    sigma S(v) = S(sigma v).

For every v,

    lambda(sigma S(v))=q(sigma v)=q(v)=lambda(S(v)).

Since the S(v) span W, lambda is G_Q invariant. Hence N is stable
and Pi -> E is a G_Q-equivariant epimorphism. This proves descent
of the specified geometric kernel; invariance of an abstract
isomorphism type alone would not have sufficed.

Let phi:G_Q -> Aut(E) be the resulting based action. The finite
arithmetic fundamental-group set E, with action

    (p,sigma): h |-> image(p) phi(sigma)(h),

defines Z over Q. Its geometric action is regular, so Z is
geometrically connected of degree 512 and has geometric deck group
isomorphic to E (right translations, with the opposite convention
identified by inversion). The arithmetic section at x fixes the
identity, giving the rational lift z_x.

Finite etaleness over the smooth projective curve C makes Z smooth
and projective. Etale Riemann--Hurwitz gives

    2g(Z)-2 = 512(2*4-2),       g(Z)=1537.

The central involution is fixed by every automorphism of E, so its
quotient descends over Q. The pointed cover Z/Z(E) has geometric
quotient V and the actual G_Q action on V=J[2]. The mod-two
Abel-Jacobi map P |-> [P-x] induces the same geometric quotient
and the same arithmetic section. Thus finite fundamental-group
sets identify it over Q, as a pointed cover, with

    2Q=[P-x]=[P-y]-D,

which is exactly Y_1, not merely an isomorphic geometric cover
with unspecified twist.

The group scheme of deck transformations over Q is generally
nonconstant. This construction is not a constant E-Galois cover
over Q. The requested geometric deck group and rational lift do
not require such constancy.

Since the cover is etale over y, its fiber there is reduced of
size 512 and every point has u-pole order three.

## 4. The actual based automorphism image is full

For completeness the automorphism sequence has its expected
meaning here. Every automorphism of E fixes z, so it induces an
isometry of (V,q). An isometry lifts: send the eight involutory
generators to lifts of their isometric images. Their squares and
commutators satisfy the displayed presentation, and the induced
map is surjective, hence an automorphism. The kernel consists of
maps multiplying each generator by a power of z, namely V^*.
Nondegeneracy of b identifies all of them with inner
automorphisms. Therefore

    1 -> I=Inn(E)=V -> A=Aut(E) -> O -> 1

is the extension to which Griess applies.

Let B=phi(G_Q). Its projection to O is the reviewed actual full
residue image. The subgroup B intersect I is O invariant. By
irreducibility it is either 0 or I. The first case would make B
a complement to I in A, contrary to Griess. Hence B contains I
and projects onto O, so B=A. This determines the actual image;
maximality has not been assumed.

We also need, and now prove,

    End_O(V)=F_2,       H^1(A,V)=0,

where A acts on V through O.

For the first equality, an endomorphism commuting with every
nonsingular transvection t_r commutes with the rank-one map
t_r-1, whose image is F_2 r. Thus it sends r into F_2 r.
Transitivity on nonsingular r makes this the same scalar for
all such r. They span V: for any coordinate vector e_i, choose
a different hyperbolic pair, put h=e_j+f_j, and write
e_i=h+(h+e_i), a sum of two nonsingular vectors.

For the cohomology, let c:A -> V be a 1-cocycle. Its restriction
to I is an O-equivariant homomorphism, since I acts trivially.
By the first equality it is either zero or the identity under
I=V. In the identity case ker(c) is a subgroup complementary
to I: multiplying an arbitrary a by an appropriate element of
I makes its cocycle zero, and ker(c) intersects I trivially.
This contradicts nonsplitting. Therefore c is zero on I and
descends to O. The reviewed H^1(O,V)=0 makes it a coboundary.
This proves the assertion without invoking any unproved
maximal-image or nonabelian-cohomology computation.

## 5. The actual infinity path action is full Hol(E)

Choose a geometric path from x to y and label the infinity
fiber by E. Its arithmetic action has the form

    h |-> t_sigma phi(sigma)(h),
    t_(sigma tau)=t_sigma phi(sigma)(t_tau).

Changing the path changes the labeling by a translation and
does not change the assertion about the image. Modulo Z(E),
the cocycle bar(t) is exactly the Kummer class of [y-x]=-D:
the central quotient was identified as the pointed cover Y_1
in Section 3. This class is nonzero because D is not in 2J(Q).

Let H be the actual image in G=E semidirect A, and L=H intersect E.
Its projection to A is full by Section 4. The image bar(L) in V
is invariant under O: conjugation by (e,a) acts on V by the
outer image of a. Irreducibility gives bar(L)=0 or V.

If bar(L)=0 then L is contained in Z(E). The cocycle
(e,a) |-> bar(e) on H is zero on L and therefore defines a
1-cocycle A=H/L -> V. Section 4 makes it a coboundary.
Inflating to G_Q would make bar(t) a coboundary, contradicting
the preceding nonzero Kummer class.

Hence bar(L)=V. Any subgroup of E surjecting to V is E itself:
choose two of its elements whose images have b-pairing one;
their commutator is z, so it contains Z(E) as well as a lift of
every v. Thus L=E, and surjectivity to A gives H=G.

This is the actual nonabelian translation argument. Surjectivity
onto the old affine action alone would not prove it. In
particular no assumed independent central sign, finite subgroup
sample, or hypothetical maximal holomorph has entered the proof.
The natural holomorph action is faithful: fixing the identity
forces e=1, after which fixing every element forces a=1.

## 6. Every subgroup, not just a collection of examples

Regard A as the identity stabilizer in G, so E=G/A. For any
subgroup H<G put d=[G:H]. Its number r(H) of orbits on E is

    |H\\G/A|,

also the number of right A-orbits on the d-element set H\\G.
If there is no singleton A-orbit, r(H)<=d/2 immediately.

Otherwise some coset Hg is fixed by A, and gAg^(-1) is contained
in H. Conjugate H so that A<=H. Then

    H=W semidirect A,       W=H intersect E,

and W is invariant under every automorphism of E. Its image in
V is either zero or V. The latter would give W=E by the
commutator argument in Section 5, contradicting H<G.
Thus W<=Z(E), so W=1 or W=Z(E). This exhausts the singleton
case; there is no assumption that A is a maximal subgroup.

If W=1 then d=512. Inner automorphisms interchange the two
lifts of every nonzero v: choose w with b(w,v)=1.
The two nonzero O-orbits in V have sizes 120 and 135.
Consequently A has exactly four orbits on E, of sizes

    1, 1, 240, 270.

Hence r(H)=4<=512/2.
If W=Z(E) then d=256, and A has the three orbits on E/W,
of sizes 1,120,135. Hence r(H)=3<=256/2.
This proves for every proper H<G

    r(H) <= [G:H]/2.

## 7. Every number field, including field intersections

Let M be the splitting field of the infinity fiber. By Section 5
it is a finite Galois extension of Q with group G in the specified
faithful action. For an arbitrary number field K in Qbar, set

    F=M intersect K,       H=Gal(M/F),       d=[F:Q].

The image of G_K on M is exactly H, even when K/Q or F/Q is
not Galois. Indeed M/Q is Galois, and restriction identifies
Gal(MK/K) with Gal(M/(M intersect K)); equivalently the fixed
field in M of the restriction image is precisely M intersect K.
Thus d=[G:H] and d<=[K:Q].

If d=1 the fiber is one H-orbit and r_Z(K)=1<=s_inf(K).
If d>1, Section 6 gives

    r_Z(K)<=d/2<=[K:Q]/2<=r_1(K)+r_2(K),

the last inequality following from [K:Q]=r_1(K)+2r_2(K).
This includes real, imaginary, mixed-signature, disjoint and
nontrivial-intersection cases. If S contains the archimedean
places, r_Z(K)<=s_inf(K)<=|S|. Only the strict direct-Runge
condition for this pole function has been excluded.

## 8. Exact finite certificate and its limits

The new checker is

    /home/argustest/zimo/argus-live-update/.venv/bin/python \
      research/k8_56_extraspecial_runge_verify.py

Its default replay is nonwriting. Initial generation uses the
same command with `--write`; that performs one bounded Jacobian
operation through the configured isolated Argus adapter.
The unchanged binary-rank helper is imported from
`k8_56_theta_affine_orbit_ratio_certificate.py`; importing it
does not run that earlier certificate.

The new finite model uses hyperbolic coordinates for q and elements
(v,a), v in F_2^8, a in F_2, with

    (v,a)(w,c)=(v+w,a+c+sum_i v_(2i+1) w_(2i)).

The code checks the full 65536-product quotient from the
35-dimensional central presentation, its surface relation,
squares, commutators, center and element orders. It constructs
eight inner automorphisms and lifts of all 120 nonsingular
transvections, verifies their multiplication compatibility on
every group element times every generator, and obtains the
four and three orbit sizes in Section 6.

The inspected Jacobian operation is
`prime_field.matrix.rank.compute`. Its exact typed input is the
256-by-35 square-value matrix over F_2, within the inspected
256-row/256-column bound. The output must retain exactly that
source matrix and have rank 35. The dedicated payload, typed
result and execution-status JSON files under this prefix retain
the operation id, server version, protocol, exit status, timeout
and structured error. Failure, incomplete output or UNKNOWN
cannot produce a passing certificate.

The certificate does not computationally prove etale descent,
Galois surjectivity, nonsplitting, all-subgroup exhaustion or the
universal number-field conclusion. Those are the arguments in
Sections 2--7 and require independent mathematical review.

## 9. Primary-source scope and genuine improvement

**Descent foundations actually read.** SGA1,
`arxiv:math/0206203v2`, is retained as
`k8_56_extraspecial_runge_sga1.pdf` and `.txt`.
Expose V, Theorem 4.1 and Section 7 identify finite etale covers
with finite continuous fundamental-group sets and connectedness
with transitivity. Expose IX, Theorem 6.1 and Corollary 6.4 give
the arithmetic exact sequence for a geometrically connected
curve and its splitting at a rational point. Expose X,
Corollary 1.8 gives invariance under algebraically closed
base extension for a proper connected scheme; Expose XII,
Theorem 5.1 and Corollary 5.2 identify the complex etale group
with the profinite completion of the topological group. All
hypotheses apply to the smooth projective connected C used
here. The independently confirmed Griess proposition is
identified in Section 1. Neither source asserts this arithmetic
path-image theorem for this curve.

**Focused antecedent search.** The independent source researcher
`extraspecial-antecedents` found no matching arithmetic theorem
in the primary statements obtained. Johnson, *Spin structures
and quadratic forms on surfaces*, JLMS (2) 22 (1980), 365--373,
Theorems 3A--3B and the p. 372 corollary, gives the
spin/quadratic-form correspondence and orthogonal stabilizer,
not descent of this cover. Stoll, *Finite descent obstructions
and rational points on curves*, ANT 1 (2007), Sections 4--5
and Lemma 5.6, treats finite possibly nonconstant torsors but
does not construct this prescribed geometric kernel.
Wickelgren, `arxiv:1006.0265v3`, Section 2 and Proposition 3.1,
supplies the path-cocycle and class-two obstruction framework,
not the finite exponent-four maximal-image conclusion here.
These are comparisons, not additional assumptions of the proof.

The actual `arxiv:2607.18493v1`, Proposition 6.14, concerns
admissible extraspecial quotients of the two-strand full
surface **braid** group, with odd genus and diagonal branching
over Sym^2(C). It is not a proposition about Pi or an etale
cover of C, so its odd-genus criterion is not imported.

Schmid, *On the Automorphism Group of Extraspecial 2-Groups*,
J. Algebra 234 (2000), 492--506, DOI 10.1006/jabr.2000.8552,
was bibliographically verified but its full primary text was
unavailable. The Ellenberg preprint *2-nilpotent quotients of
fundamental groups of curves* (2000), cited by Wickelgren,
was also unavailable. No unseen proposition from either is
assumed. A search-generated Guralnick--Pries citation to
Trans. AMS 352 (2000), 743--776 is not usable: the page range
overlaps the unrelated publisher-recorded articles at
731--751 and 753--780. No statement from it is cited.

**Comparison with the strongest accepted campaign theorem.**
The accepted multiplication tower has abelian geometric deck
groups (Z/2^r)^8. This cover has nonabelian deck group E, whose
commutator is nontrivial. It cannot be dominated over C by any
of those Galois covers: that would make E a quotient of an
abelian deck group. Sections 2--5 therefore construct and
determine an additional actual nonabelian cover and arithmetic
path image, not a new presentation of the accepted tower.
The proof needs only the already reviewed residue and
nondivisibility inputs, not the higher tower image calculation.

The mathematical extension is explicit and unconditional for
this curve. Failure to find a prior matching theorem is not a
verified-new or publishable-significance verdict. Those remain
for the normal independent Reviewer. The earlier failed tactic
of declaring the old general cohomology/counting ingredients
new is not reopened, and the accepted arithmetic results and
completed claims are unchanged.
