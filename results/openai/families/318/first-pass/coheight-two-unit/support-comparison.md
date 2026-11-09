# The actual constant-cochain and frame maps

This proves C318ORD_SUPPORT at (p,n,t)=(5,3,1). It upgrades the
underlying compact residue/Frobenius comparison used in the accepted
finiteness proof to a comparison with its actual module and frame maps.
The accepted cutoff/corestriction theorem then proves C318CO2ORDINARY.
It does not identify a Morava class with a block-restricted class.

Put P=P_3, G=GL_2(Z_5), U=K x V, and

    A_P = C^*_cts(P,k),
    Y = RΓ_c(Z,Acal) tensor <eta>,
    Z = (Ext^1(O(1),O)^2)_ind.

Use the literal finite-frame coefficient B_U and compact lattice L_U.
Every continuous cochain has one finite frame/root stage and pole
bound. The analytic support complex below is an auxiliary comparison,
not the definition of B_U. Scalar extension is tensor with
R=(O_E/varpi)^a, with no Frobenius on R.

**Theorem.** For sufficiently deep finite U, the residue/Frobenius
comparison is a natural equivalence

    (colim_(S^vee) RΓ(P,L_U)^vee) tensor R
       -> RΓ(U,Y)[11].

It carries the graded transpose of the actual A_P-action to the
action pulled back by the actual classifying P-torsor on [Z/U].
For U' contained in U, coefficient trace transposes to geometric
pullback; coefficient pullback transposes to geometric trace, or
group corestriction. These assertions are compatible with composition,
coefficient units, stationary root maps, and compact parameters.
There is exactly one auxiliary volume line <eta>.

Consequently, using the independently certified C318ORD_FIN and the
accepted bridge, the literal connected coefficient satisfies

    Hom_k(H^i(P,B_conn,G),k) tensor R
       = H^(4-i)(G,k) tensor R,

up to the fixed one-dimensional orientation bases. On the right the
P-cochain action is the action carried by the classifying torsor and
the ensuing supported maps. This theorem does not yet identify that
action with specified block generators.

## 1. Settled inputs and the action to be compared

The round-three review at 2026-11-05T13:16:37Z accepted C318ORD_FIN,
C318FINGEO, C318FIN32, C318FIN21 and the new algebraic core. We reuse
the actual integral marking/determinant component, the underlying
residue/Frobenius support construction of `finiteness.md`, Section 2,
and finite total cohomology. No part of that induction is rerun here.
Round two accepted the conditional cutoff and connected-corestriction
argument in `ordinary-comparison.md`. Its finite-lattice naturality
premise, rather than its linear algebra, is the present question.

For the extra duality input, BGHS v2, Section 4.3, equation (4.25),
Theorem 4.26 and Proposition 4.28 explicitly give the cup/evaluation
pairing and Frobenius reciprocity. This is recorded as SUP-CUP-DUALITY
on C318ORD_SUPPORT; independent source attribution is still required.
Their compact/discrete pairing applies here: P has dimension nine,
no 5-torsion, and trivial adjoint determinant. For k-coefficients its
orientation identifies the discrete dualizing coefficient with k.
Choosing its basis once is harmless; it is not choosing a new unit.

Use the continuous bar model to specify actions. For c in A_P^r,

    (c cup z)(g_1,...,g_(r+s))
      = c(g_1,...,g_r) (g_1...g_r)z(g_(r+1),...,g_(r+s)).

A k-valued constant cochain is locally constant and uses a finite
clopen partition of its compact source. In the geometric P-action
nerve the same formula multiplies the coefficient unit on those
same pieces. Faces, degeneracies and the Alexander--Whitney diagonal
are the same maps on both sides.

No strictly commutative bar cup algebra is assumed. The algebraic
dual of a left differential graded module is canonically a right
module, by (lambda.c)(z)=lambda(c.z). The usual left convention uses
the coherent commutativity of constant cochains; in homogeneous
degrees it is

    (c.lambda)(z) = (-1)^(r*j) lambda(c.z),    |lambda|=j.

The claims below hold for this derived module structure, not merely
for commuting operators on cohomology. A bounded finite projective
resolution is used to compute it, not to choose a different cup
product.

## 2. Group duality with the actual cup maps

Choose the orientation trace once. Cup, coefficient evaluation, and
this trace give the duality pairing. On a bounded projective model
it is the evaluation map induced by a diagonal on a resolution.
The corresponding bar diagonal is homotopy cocommutative, with its
usual coherent higher diagonals. Thus associativity and the
interchange of c with the first factor give the cap/cup transpose,
including the sign in Section 1. This is the chain version of the
perfect pairing of BGHS (4.25), not an arbitrary perfect pairing of
the resulting vector spaces.

More intrinsically the same diagonal makes evaluation a balanced map

    RΓ(P,L_U) tensor^L_(A_P) RΓ(P,L_U^vee)
       -> A_P -> k[-9].

The first arrow is cup followed by coefficient evaluation, and the
second is the fixed orientation trace. Balancing follows from the
lax symmetric monoidal bar construction, including its higher
diagonals. Its adjoint is therefore a morphism of derived A_P-modules
before its underlying equivalence is checked by duality. This avoids
deducing a module equivalence merely from a perfect pairing on
cohomology. Reduction to finite k-coefficients and the bounded
projective resolution give the same map for the compact coefficient.

Here is an explicit sign check. Let N be the dual-coefficient
cochain complex and D the duality dimension. If v has degree j+D,
the map from N[D] to the dual complex is

    v |-> (z |-> (-1)^((D+1)*j) integral(z cup v)).

The dual differential is

    (d lambda)(z) = (-1)^(j+1) lambda(dz).

The displayed sign makes the evaluation a chain map. On N[D] a
degree-r left action has the additional shift sign (-1)^(D*r).
Moving c past z gives (-1)^(r*(-j-r)). The identity

    (D+1)(j+r)+D*r+r*(-j-r)
       = r*j+(D+1)*j                 modulo 2

proves that this is precisely the graded transpose, not its negative
in odd degree. At the group-duality step D=9; after principal parts
the total shift is 11. Both are odd. The formal source checks the
universal parity identity, including negative-degree parities.

Naturality is also at chain level: evaluating a coefficient map
against its dual gives the same scalar before applying the diagonal
and orientation trace. Hence this duality commutes with every
coefficient pullback, trace, stationary transfer and root map. It
commutes with degree-shifted maps without an equivariant splitting.
Compact/discrete duality and exactness of finite projective terms
are the already reviewed continuous-cohomology model.

## 3. Residue, actual Frobenius, and both adjunctions

Let C=C_1 and M_U=Hom_C(L_U,omega_C). The coordinate-free residue
identification is

    L_U^vee = H^2_m(M_U).

For a finite free chart it sends h to the functional

    f |-> res Tr_(B_U/C[1/x])(f h eta).

The trace pairing is perfect on the puncture. At the lattice it is
the Hom module above, not a possibly degenerate boundary trace
matrix. Changing coordinates changes the top differential by its
Jacobian; the residue is unchanged. This is the one top form, not
an additional auxiliary determinant line.

For a finite frame map let B' be over B, i:B->B' its pullback and
T:B'->B its finite etale trace. Trace transitivity and the projection
formula give, for arbitrary f in B and g,h in B',

    res Tr_(B'/C)(i(f) h eta')
       = res Tr_(B/C)(f T(h) eta),

    res Tr_(B'/C)(g i(f) eta')
       = res Tr_(B/C)(T(g) f eta).

Thus i^vee is T on dual functions and T^vee is i. These equalities
hold for nonnormal finite frame maps as well; normal refinements
only make their description by deck sums convenient.

For the stationary Q=5^(6a) fixing k, the normalization already
constructed from invariant torsor volume gives

    res Tr(S(f) h eta) = res Tr(f h^Q eta).

Finite etale splitting proves the same identity on cover functions,
not only on base functions. It also proves

    T(h^Q) = T(h)^Q,       i(f^Q)=i(f)^Q,
    T S = S T,            i S = S i.

The unsplit identities descend by faithful flatness. This proves
that BOTH adjunctions commute with the actual Frobenius transpose.
There is no choice of a matrix having merely the same rank.

The form in h^Q eta is eta, not eta^Q and not the differential
pullback under absolute Frobenius. At root stage r it is
h^(1/Q^r) eta. Power renaming fixes k, and scalar extension fixes R.
All auxiliary characters are therefore unchanged by this renaming.
In particular <eta> has the single GL_2 row weight +1. The
P-orientation is trivial and does not add another volume.

Every finite diagram can be realized using sufficiently enlarged
compact pole lattices. It is not necessary to force each map to
preserve the same arbitrarily chosen lattice. Changing its pole
cutoff gives the canonical cofinal comparison: each larger fixed
pole lattice is absorbed by transfer. For finitely many arrows
one clears their denominators together, forms their residue
adjoints, and compares at larger cutoffs. The maps on the stationary
colimits agree with the original i and T. This also handles a
composition diagram without assuming a simultaneous free lattice
fixed by every arrow.

Concretely, a path L_0->L_1->L_2 is realized by choosing each target
cutoff after the preceding source. A loop may end at a larger cutoff
than it starts; compare both paths at that common final cutoff.
The canonical stable-cutoff identification with ordinary finite
cohomology identifies these choices. It is not necessary, and can
be unjustified, to require a finite list of unrelated denominator
inequalities to close on a single initial cutoff.

## 4. Principal parts and the common classifying torsor

The principal-part map used in the accepted bare comparison is
the map of algebraic Cech fractions into supported analytic Cech
fractions on buffered charts. Its definition does not use a
monomial projection. Norm-preserving monomial contraction only
checks that this very map is an almost quasi-isomorphism.
Consequently a coordinate change, cup operation, or trace is
compared using a common Cech refinement, not by asserting that
a coordinate-dependent contraction is equivariant.

At a fixed positive-valuation cutoff there are finitely many
surviving Laurent terms. Their exponents and coefficients occur
at a common root stage; a finite clopen parameter partition works
for the whole diagram. Positivity identifies the root coefficient
system with j_! nu_* Acal tensor <eta>. All maps into that
coefficient are the actual finite-cover functions of Section 3.
Both frame adjunctions commute with the maps into it. These are
the same equivalences of complexes as in the finiteness proof,
now with their specified structure maps retained.

In particular take the common double nerve of the actual torsor
presentations

    [ (X/U) / P ] = [ Z / U ].

The structural map p_U:[Z/U]->BP is defined by this P-torsor.
On the common cover, choose torsor sections only to write it:
if g_ab are their P-valued transitions, a degree-r cocycle c is
represented by c(g_01,...,g_(r-1,r)). A change of section is the
usual simplicial change of trivialization, not a new group class.
Hence this representative is the pullback of the ORIGINAL c.
Its cup operation is the same Alexander--Whitney operation in
the double nerve. Interchanging its two group directions uses
the totalization sign (-1)^(vertical_degree*horizontal_degree).

The two pullbacks from this double nerve are morphisms over BP.
They commute with the coefficient unit and with supported
restriction fibers, so they are morphisms of derived A_P-modules.
They also commute with finite etale pullback and trace. In a split
frame fiber these assertions say that scalar multiplication and
the finite sum over that fiber commute. The descent equalities,
including compositions and base changes, already hold before
passing to cohomology.

For U' contained in U the same P-torsor is pulled back:
p_(U')=p_U f. Thus its supported f^* and f_! obey the projection
formula for the same c. Section 3 identifies T^vee with f^*
and i^vee with f_!, in these directions. This supplies the frame
map coherence missing from a dimension-only support comparison.

Here compact parameters do not license infinite coefficient data.
For each fixed diagram and cutoff, compactness gives a finite
clopen refinement, one Laurent bound, and one root denominator.
The images of a compact support under the finitely many maps and
its compact group families fit in a common larger bound with a
strict buffer. A finite resolution bounds each group direction.
Faces, diagonals and their comparison homotopies in a fixed total
degree use finitely many such maps. Passing to the filtered
systems preserves these coherent diagrams; a single support tube
or root stage for all possible cochains is neither used nor claimed.

Combining Sections 2--4 with the reviewed underlying equivalences
proves the theorem's compact-lattice comparison as a derived
module comparison with both finite-frame adjunctions.

## 5. The unit and the literal ordinary connected limit

The primal unit is u:k->B_U, 1|->1. Enlarge the compact lattice
to contain 1. Pullback satisfies i(1)=1, and at height one the
actual normalized S satisfies S(1)=1. Its transpose therefore
preserves the dual unit evaluation. In the residue chart this is
the explicit functional

    h eta |-> res Tr(h eta).

Indeed it is the residue adjoint of C->L_U, f|->f*1, followed by
evaluation of a principal part on the constant function 1.
More generally the unit map A_P->RΓ(P,B_U), c|->c cup 1,
is the original constant-cochain map. Applying the same pairings
carries its dual map to the supported evaluation above with the
same classifying-torsor action. No chosen exterior basis defines
this functional.

Trace is NOT asserted to be unital. For a degree-five cover,
T(1)=5=0, whereas T can be nonzero. Its adjoint evaluation law is
ev_(1') T^vee = 5 ev_1, not ev_1. This agrees with the deck norm
and is indispensable at connected pro-five levels. Dividing by
the covering degree or renormalizing trace would destroy the
actual connected map.

Use now the accepted cutoff theorem with the certified finite
cohomology, rather than assume finiteness anew. Its zigzag

    C(P,B_U)^* -> C(P,L_U)^* <- C(P,L_U)^vee

and the stage-zero map into transpose-transfer colimits consist
of restriction and inclusion of the SAME functionals. Section 3
and the original bar formula show that the entire zigzag is
linear for the actual cochain action and both frame adjunctions.
Thus it identifies the ordinary algebraic dual, not a perfected
or completed primal coefficient.

The finite torsor norm calculation accepted in round two now
applies to the supported comparison just constructed: transpose
primal pullback is connected corestriction, with its actual
(norm,identity) two-term chain map. The connected limit retains
degree one, naturally for derived degree-shifted cochain maps.
The reviewed proper-support contraction and the one volume
leave ambient degree six. Hence the degree shift is 11-6-1=4.
The bounded finite-dimensional inverse-limit argument in the
accepted bridge justifies scalar extension here. The coefficient
unit is still the pullback-compatible unit throughout that
ordinary filtered union.

One distinction matters: the P-torsor on Z need not extend to
the dependent locus of N_1^2. The A_P-action on the surviving
ambient G-complex is carried through the actual supported
G-equivalence, uniquely in the derived category, not by asserting
an extension of that torsor or assigning an arbitrary cohomology
action. Computing this carried action as a particular cup product
on G still requires modification transport.

This proves C318CO2ORDINARY from the now-established input
C318ORD_SUPPORT and the certified earlier inputs. It does NOT
compute the endomorphism induced by p_U^* xi_i on the surviving
G-cochains. That is precisely C318CO2ACTION, requiring actual
modification transport and stable-generator restriction.

## 6. Exact and formal scope

The new finite diagnostic uses the etale punctured-chart algebra

    F_5[x^+-1,z^+-1,y] / (y^5-y-x^-1).

Its deck translations are y|->y+a. Tr(1)=0, Tr(y^4)=-1;
the trace pairing is nondegenerate. In the ONE log volume
dx/x wedge dz/z, writing y=y^5-x^-1 computes actual Cartier
transfer. The verifier checks the residue adjunction, both
frame directions, equivariance and bar cup/differential identities,
including the field-fixing progression Q=5^6. This is an exact
local-model test of formulas, not a finite computation of
P_3-cohomology or the Honda coefficient.

`support/Main.lean` proves universal finite-fiber trace adjunction,
composition, projection and Frobenius naturality, unit pullback,
and the graded-duality sign identities. It does not formalize
Poincare duality, perfectoid supports, or the common-torsor
geometric theorem. Their application is the proof above.

Replay only this new mathematics with:

    PYTHONDONTWRITEBYTECODE=1 python3 research/coheight-two-unit/verify.py --support-only

Neither the accepted finiteness proof nor any accepted compiler
source is changed or rerun. No false manuscript assertion or
unbridgeable gap is claimed. Independent review of this proof,
its formal fidelity, and SUP-CUP-DUALITY is still required.
