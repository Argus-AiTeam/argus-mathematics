# Intrinsic determinant comparison

## Exact conditional statement

This is old report Part (B), historical `CITS-DET` v1, and the determinant
component of CITS-STRUCTURAL. The manuscript reference is
`rd:det-switch` and `rd:common-tensor` in `ring-determinants.tex`,
October 7, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`.
The shared-tensor argument reconstructs the source assertion; the old
certificate's label "new_theorem" does not establish novelty.

Let O be a DVR, K its fraction field, and take the actual exact perfect
integral strict/finite/singular/relaxed complexes and localization
triangles. Require compatible perfect dualities, the retained
degree-zero conditions, a unimodular conjugate-Weil local pairing,
and the stated generic concentration in degrees one and two.
Assume the old H1 is K*A, with f(A)=v nonzero, and an actual switched
class B satisfies f(B)=0 and s(B)=J*v. The functionals in the
class-dual determinant tensors must be the ones induced by these
same dualities, not arbitrary independently rescaled functionals.

Then the switched generic H1 is K*B and the two tensor coordinates
have equal O-valuations. There is no primitivity assumption on v.
The assertion extends to every **finite** sequence of such admissible
switches, with nonzero localization at every step.

## Decisive argument

Over K, the nonzero map from the old one-dimensional H1 into the
finite plane makes strict H1 vanish. Compatible global/local duality
makes the relaxed localization image self-annihilating in F+S, of
dimension two. The two independent localized vectors (v,0) and
(0,J*v) therefore span that image. Its intersection with either
plane is one-dimensional, giving the new rank-one assertion.
Without that actual self-annihilator property, generic dimension
counting would not suffice.

Write V=H1(C_rel), with basis A,B. The same duality identifies generic
H2(C_str) with V*. Compatibility identifies the finite connecting
map with the dual of localization. In the corresponding generic
exact sequence

    0 -> K*A -> F -> V* -> K*A* -> 0,

the connecting map evaluates against v in the B* direction, up to
the prescribed integral unit and determinant sign. Thus a preimage x
of B* has unit pairing with v. For the singular triangle a preimage
y of A* has unit pairing with J*v. These unit statements rely on
the normalized compatible integral pairing; generic nonsingularity
alone would permit nonunit rescaling and would not prove the claim.

For arbitrary divisibility, write v=p*(a,b), where p is nonzero and
(a,b) is primitive in O^2. Choose r,s in O with a*r+b*s=1. In K^2,

    x=(-s/p,r/p);     det(v,x)=a*r+b*s=1.

Although x may be fractional, its wedge with v is an integral
generator of det(F). The same holds for J*v and y, since J is
integral unimodular. No estimate on val(p) is used.

The perfect-complex triangles identify the determinant lines
**integrally**:

    D(C_F)=D(C_str) tensor det(F),
    D(C_S)=D(C_str) tensor det(S).

For bounded free representatives the mapping-cone construction gives
these identifications on graded determinants. Replacing such a
representative by a quasi-isomorphic one introduces a bounded acyclic
free cone. Over a DVR this splits into contractible unit disks, so
the comparison does not introduce a nonunit determinant factor.
This does not contract nonacyclic disks with differential pi^d:
their torsion is precisely what must remain.

Cancellation in the generic exact sequences sends the actual two
class-functional tensors, up to unit/sign factors, to

    (A* wedge B*)^* tensor (v wedge x),
    (A* wedge B*)^* tensor (J*v wedge y).

The first factor has the **same position in the same integral strict
determinant line** on both sides. The second factors generate the
respective integral plane determinant lattices. Equality of valuations
follows. This checks the decisive common-lattice point; replacing the
strict factor by abstract torsion-free cohomology would not do so.

For example a strict disk `[O --pi^d--> O]` in degrees one and two
contributes pi^(-d) in the report's inverse-determinant convention.
Such factors are common, not absent. The explicit construction in
unit 07 has two of them and coordinates +/-p^(-2), confirming the
convention without substituting that example for this general proof.

## Iteration and formalization boundary

Every admissible comparison is multiplication by an integral unit
after compatible integral bases are chosen. Induction therefore gives
a product of units for any finite list, with no accumulation of
valuation. A common initial scaling L scales the class and its
duality-induced functional by L, hence their tensor by L^2 once.
It is not a new scalar choice at every switch.

Lean's `two_by_two_volume` proves the general two-by-two determinant
identity over commutative rings. `nonprimitive_volume` proves the
displayed fractional-vector identity in a field, assuming p is
nonzero and the Bezout relation holds. It does not construct the
DVR primitive factorization or prove the determinant-functor argument.
`unit_product_no_loss` and `arbitrary_switch_count` quantify over
a monoid, an additive commutative monoid, and a multiplicatively
additive map v with v(1)=0. Their list is named `units`, but the
actual hypothesis is v(u)=0 for every entry, not implicit invertibility.
The geometric/algebraic application must supply the actual units.

**Recommendation: support the conditional integral comparison and
finite iteration, not an unconditional arithmetic theorem.** The proof
is prose with formalized algebraic sublemmas, not a Lean formalization
of the entire derived determinant comparison. Units 03-05 retain the
arithmetic realization and compatibility gaps. Nothing here proves
the zero-localization case, arbitrary incompatible duality rescalings,
an infinite product statement, the pointwise converse or rational H10.
