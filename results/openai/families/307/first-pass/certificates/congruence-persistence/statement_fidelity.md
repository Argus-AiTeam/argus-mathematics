# Statement fidelity: C_CP_ALG

The file `Main.lean`, namespace `CongruencePersistence`, formalizes the
algebraic implication used in the October 2026 integral persistence proof.
It is not a formalization of the maximal coarse assembly theorem or of
the entire topological construction.

`lifted_triangle` quantifies over every group and arbitrary elements
q0,q1,q2, the three Cayley words, the three horizontal transports, the
three right defects, and the extension defect k. Its hypotheses are the
three lifted-edge equalities, w12*w01=w02, g01*g12=g02*k, and ONLY the
commutation of n01 with g12. Its conclusion is n02=k*n01*n12. In the
manuscript k=C^(a01*b12). Neither q0 nor a Cayley word is assumed to
commute with any kernel element. This precisely checks the noncentral
cancellation step after the manuscript's matrix and injectivity facts
have supplied the hypotheses.

`coboundary_sign` is valid in every additive commutative group. The
hypothesis c02=u+c01+c12 implies delta c=c12-c02+c01=-u. In the
application the group is Z/(2^j), and u=a01*b12.
`cup_is_closed` checks the cup-cocycle identity with additive seams on a
tetrahedron; a23 and b01 are quantified but do not occur in that
particular identity. `coboundary_squared` checks the alternating
tetrahedron identity for six arbitrary edge values.

`integral_lift_is_closed` has arbitrary index types I,J,K, so it applies
to the sets of ordered edges, triangles, and tetrahedra of a finite
simplicial complex. Its cochain groups are all functions from these
types to Z, not cohomology groups. The additive maps d1,d2 satisfy
d2(d1 c)=0 for every c. Given a closed integer 2-cochain x, nonzero
integer m, and integer cochains c,y with m*y=x+d1 c, it proves d2 y=0.
`integral_lift_representation` gives x=m*y-d1 c. Together these supply
a divisible cohomology representative even if the resulting H^2 has
torsion. The formal theorem assumes the displayed lift equation; the
pointwise existence of y follows in the prose proof from the modular
cochain identity and integer lifts of residues. It does NOT assume that
m is invertible, that H^2 is torsion-free, or that a cohomology class
vanishes rationally. No cohomology quotient is implemented in this file.

`integral_cocycle_divisible` additionally supplies that representative,
rather than assuming its existence: for every natural m>0, if the
integer cochain x+d1 c reduces pointwise to zero in ZMod m, integer
division defines y, and the theorem proves d2 y=0 and
x=m*y-d1 c. This applies to every positive modulus, including all
2^j in the manuscript. The input c is an integer lift of the modular
edge cochain; choosing such lifts is not formalized.

`dyadic_choose_divisible` quantifies over all natural numbers j,D,h
with D>0, D<2^j, and 1<=h<=D. Its conclusion is exactly
2^(j-Nat.log 2 D) divides binomial(2^j,h) in N. Nat.log is the floor
logarithm and subtraction is natural-number subtraction. The hypotheses
imply Nat.log 2 D<j, so this subtraction is the nonnegative integer
subtraction required in the manuscript. Its proof uses Mathlib's
kernel-checked prime-power binomial factorization theorem, not finite
tests or an added axiom.

`nilpotent_binomial_divisible` quantifies over every commutative ring R,
arbitrary N,D,d in N, and z in R. Under z^(D+1)=0 and d dividing each
binomial(N,h) for 1<=h<=D, it constructs w with
(1+z)^N-1=d*w in R. `dyadic_nilpotent_divisible` specializes this to
N=2^j and the preceding uniform divisor. The natural coefficient is
cast into R. No torsion-freeness of R and no cancellation in R are
assumed. The application R=K^0(P_r(Y_j)) and z=[L']-1 uses the
separately cited integral projective-space relation. Multiplication by
the odd K-class is a further bilinear operation, described in prose
rather than encoded as graded K-theory.

`dyadic_not_dvd_int` uses natAbs, so it applies to negative as well as
positive nonzero integers n. If e>v_2(|n|), it proves that 2^e does not
divide n in Z. `pairing_obstruction` quantifies over every additive
commutative group A, every additive integer-valued functional f, and
arbitrary x,y,d,n with x=d*y and d not dividing n; it proves f(x)!=n.
`endpoint_pairing_impossible` combines these statements for all
j,D,n satisfying log_2 D+v_2(|n|)<j. A may have arbitrary torsion.
In the application A is K^1(I), and f is the index pairing with the
Mayer--Vietoris preimage eta.

The following are outside the formal source: construction of the
finite quotient graphs and their Rips complexes; the matrix
description of their congruence kernels; classification of line
bundles; cellular approximation; the K-ring of projective space; the
existence of tau with pairing one; and analytic K-homology
Mayer--Vietoris and naturality. The universal matrix identities and
explicit thresholds have an independent exact symbolic checker and a
prose proof in this directory. The standard topological inputs are
explicit assumptions in the claim ledger. Their interpretation and
the connection of the formal objects to the manuscript require
independent human review. No formal certification of those inputs,
publication novelty, or analytic index vanishing is asserted.
