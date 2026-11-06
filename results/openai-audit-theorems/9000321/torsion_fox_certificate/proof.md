# The presentation-theoretic torsion obstruction

## Statement and formal theorem

Let \(n,m\geq0\), \(F=F(x_1,\ldots,x_n)\),
\(r=(r_1,\ldots,r_m)\), \(N=\langle\!\langle r_1,\ldots,r_m\rangle\!\rangle_F\),
and \(G=F/N\). Write \(\pi:F\to G\) for the quotient map. For an arbitrary
character \(\rho:G\to\mathbb C^\times\), put \(a=\rho\pi\).
Define the evaluated Fox derivative \(d:F\to\mathbb C^n\) by
\[
d(x_i)=e_i,\qquad d(uv)=d(u)+a(u)d(v).
\]
The inverse rule is \(d(u^{-1})=-a(u^{-1})d(u)\).
Define the **actual relator boundary**
\[
D_\rho:\mathbb C^m\longrightarrow\mathbb C^n,\qquad
D_\rho(c)=\sum_{j=1}^m c_jd(r_j).
\tag{1}
\]
The requested theorem is
\[
\operatorname{Injective}(D_\rho),\quad g^q=1,\quad q>0
\quad\Longrightarrow\quad \rho(g)=1.
\tag{2}
\]
There are no restrictions on the relator words, asphericity, the image of
\(\rho\), residual finiteness, or whether \(q\) is the exact order.

The Lean declaration

    FoxTower.universal_torsion_statement :
      TorsionFox.UniversalTorsionStatement

proves (2), rather than merely defining it. Section 4 gives its complete
word-graph proof: a fixed source is lifted through explicit rational-voltage
actions, the actual local boundary is transported over the group algebra
\(\mathbb C[\mathbb Q]\), and a strictly increasing vertex count contradicts
an explicit fixed bound. All initialization and transfer hypotheses are
proved from (1), the actual quotient, and \(g^q=1\).

Lean 4.31.0 has certified the complete source with compiler exit 0,
axiom-audit exit 0, and `proof_holes=[]`. The native record is bound to
`C-TORSION-FOX-CERT` version 4, whose ledger status is `closed_kernel`:
`certificates/C-TORSION-FOX-CERT-84bd8af494165de0.json`.
Its source SHA-256 is
`0ab7acabd317f1f7ba24c0d8f2dc4dceb051ef9451a4ddca793c9730e92d5ced`.
From the campaign root, the native reproduction command is:

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify --project-root . \
  --claim C-TORSION-FOX-CERT research/torsion_fox_certificate/Main.lean \
  --statement-fidelity research/torsion_fox_certificate/statement-fidelity.md
```

The independently reviewed, narrower version-2 calculus certificate remains
archived at
`certificates/C-FOX-TORSION-CALCULUS-77df55a843d842f3.json`.
Its source and fidelity text describe the earlier partial result, not the
expanded source. The direct zero-coefficient inference in Section 3 remains
insufficient; the new proof does not resurrect it.

The algebraic universal theorem is formalized. The presentation-complex
identification in Section 1 and the alternative simplicial proof in Section 2
are mathematical prose, not formal topological declarations. Their
interpretation remains a separate Host Reviewer responsibility.

## 1. Correspondence with finite two-complexes

Attach one oriented two-cell along each \(r_j\) to the bouquet of the \(n\)
oriented generator circles. This is a finite connected presentation complex
\(Y_r\), including the cases \(n=0\) or \(m=0\).
Van Kampen identifies its fundamental group with **this** quotient \(G\),
not with an unrelated group satisfying the relators.

Use the reviewed conventions from `wall_d2_audit/report.md`, Section 2:
universal-cover cellular chains are left \(\mathbb ZG\)-modules, and
\(\mathbb C_\rho\) is the right module \(z\cdot g=\rho(g)z\).
A positive traversal of a generator edge after a prefix \(u\) contributes
\(a(u)e_i\). A negative traversal contributes
\(-a(ux_i^{-1})e_i\). Concatenating paths and reversing paths give exactly
the product and inverse rules above. Thus, with **columns** indexed by
relators, the local cellular second boundary is (1).
There are no three-cells, so
\[
H_2(Y_r;\mathbb C_\rho)=\ker D_\rho.
\tag{3}
\]
The first boundary is
\(\partial_1(v)=\sum_i v_i(\rho(\pi x_i)-1)\).
The Fox fundamental formula gives
\(\partial_1d(w)=a(w)-1\), hence \(\partial_1D_\rho=0\).
No asphericity assertion is used in (3).

Conversely, choose a maximal tree in the one-skeleton of any finite connected
two-complex and collapse it. The resulting homotopy-equivalent complex has
one vertex and a finite presentation whose generators are the remaining
oriented edges and whose relators are the two-cell attaching words.
The transported character and local homology are unchanged. This explains
both directions of the correspondence with the manuscript's
`cor:torsion`; subdivision and tree collapse are not extra hypotheses.

The foundational sources are the **existing, independently attributed**
`C-FOUNDATIONS` assumptions (Hatcher, Proposition 1.26 and Theorem 2.35,
Section 3.H, and the covering/approximation propositions), together with
the existing Fox product/inverse convention. No new source attribution or
unchecked theorem is asserted here.

## 2. Prose proof retaining the universal quantifiers

Suppose (1) is injective and \(g^q=1\), \(q>0\). If \(q=1\), then \(g=1\).
Otherwise, assume \(\rho(g)\ne1\). A loop representing \(g\) extends to a map
\[
M_q=S^1\cup_{\deg q}D^2\longrightarrow Y_r
\]
because its \(q\)th power is nullhomotopic. The domain has
\(H_1(M_q;\mathbb Q)=0\), since its ordinary second boundary is multiplication
by the nonzero integer \(q\).

Replace \(Y_r\) and \(M_q\) by finite simplicial homotopy models without
increasing dimension above two. The explicit mapping-cylinder construction
in report Section 3.1 applies also to constant attaching words. Subdivide the
domain sufficiently to make the map simplicial, and fix that subdivision.
Its finite image \(A_0\) has zero twisted \(H_2\): in dimension two, the
chain inclusion of a subcomplex is injective on the kernel of the second
boundary. Its pulled-back character is still nontrivial.

At any finite image \(A\), nontrivial monodromy makes \(H_0(A;L)=0\).
Together with \(H_2(A;L)=0\), the rank-one Euler formula gives
\(\chi(A)=-\dim H_1(A;L)\leq0\).
Ordinary rational homology gives
\(\chi(A)=1-b_1(A;\mathbb Q)+b_2(A;\mathbb Q)\), so \(b_1(A;\mathbb Q)>0\).
The finite generation of its abelianization yields an epimorphism
\(\phi:\pi_1(A)\twoheadrightarrow\mathbb Z\).

The domain map lifts to the cover for \(\ker\phi\): its composite with \(\phi\)
is zero since the domain's first integral homology is finite.
The lifted triangulation makes the lift simplicial on the **same** finite
domain; no repeated subdivision is needed.

Here is the necessary homology-transfer argument, rather than an assumption
of it. On the infinite cyclic cover, deck translation acts on the pulled-back
fiber by \((\widehat x,v)\mapsto(\tau\widehat x,v)\). Thus the finite-support
cellular chains are finite free modules over
\(R=\mathbb C[z,z^{-1}]\). Their second boundary \(B(z)\) specializes at
\(z=1\) to the local boundary of \(A\), including its original character.
If there are no two-cells, injectivity is immediate. Otherwise injectivity
of \(B(1)\) supplies a nonzero maximal minor. Its determinant remains nonzero
in \(R\), so \(B(z)\) is injective over \(\mathbb C(z)\), and hence over \(R\).
This proves vanishing of the cover's ordinary, finite-support twisted \(H_2\).
Restriction to the finite lifted image preserves that vanishing.

The lifted image maps onto \(A\), simplex by simplex, without dimension
collapse. Its simplex count cannot decrease. Equality would give exactly
one lift of each simplex, compatibly with faces; the inverse assignment
would be a simplicial section of the cover. On fundamental groups a section
would make the covering inclusion surjective, contradicting
\(\ker\phi\ne\pi_1(A)\). The simplex count therefore strictly increases.
Every image simplex still comes from a simplex in the fixed domain, so
these counts are bounded by that domain's finite simplex count.
Iteration is impossible. The assumption \(\rho(g)\ne1\) was false, proving
(2).

This is the reviewed mathematical argument specialized to the **actual
presentation complex**. It is not a new priority claim and not a Lean proof
of the topological steps. Louder--Wilton's already attributed maximal-tower
lemma supplies only tower existence; Howie's quoted homology-transfer lemma
has constant coefficients. Neither source supplies the twisted transfer
statement needed above. The displayed Laurent argument is essential.

## 3. What direct Fox differentiation actually proves

Choose \(w\in F\) with \(\pi(w)=g\). Since \(g^q=1\), normal-closure membership
provides a finite certificate
\[
w^q=\prod_{\ell=1}^k u_\ell r_{j_\ell}^{\epsilon_\ell}u_\ell^{-1},
\qquad \epsilon_\ell\in\{1,-1\}.
\tag{4}
\]
This existence is not an extra assumption: the products of signed conjugates
form a normal subgroup containing the relators, and hence contain \(N\).
The Lean proof constructs that subgroup and uses the quotient kernel
criterion to obtain (4).

The evaluated coefficient vector of (4) is
\[
c_j=\sum_{\ell:j_\ell=j}\epsilon_\ell a(u_\ell).
\]
Since \(a(r_j)=1\), the Fox rules give
\[
D_\rho(c)=d(w^q)
 =\left(1+a(w)+\cdots+a(w)^{q-1}\right)d(w).
\tag{5}
\]
If \(a(w)\ne1\) and \(a(w)^q=1\), the geometric sum is zero.
Thus \(c\in\ker D_\rho\). Under injectivity the conclusion is \(c=0\),
**not a contradiction**. No nonzeroness of \(c\) follows from (4).

The Lean reduction quantifies over arbitrary \(n,m,r,\rho,w,q\) and over
**every** certificate (4). It assumes neither the tower theorem nor any
covering-transfer law. In particular it cannot be used to replace them.
`torsion_element_has_certificate` explicitly lifts each quotient element,
so even existence of the word representative is not an implicit change of
group. `fox_fundamental` and `firstBoundary_boundary` also certify the
first-boundary signs and chain condition in Section 1.

### A concrete cancellation defeating the naive inference

In \(G=\langle x\mid r=x^6\rangle\), take a primitive sixth root \(\zeta\)
and \(\rho(x)=\zeta\). The free-group identity
\[
x^6=r\,(x r^{-1}x^{-1})\,(x^2 r x^{-2})
\tag{6}
\]
has coefficient
\[
c=1-\zeta+\zeta^2=\Phi_6(\zeta)=0.
\tag{7}
\]
The exponent sum of the three signed occurrences is \(1-1+1=1\), so (6)
is genuinely a certificate for \(x^6\), not an identity for \(1\).
Here \(\rho(x)\ne1\). The one-factor certificate \([r]\), in contrast, has
coefficient \(1\). Therefore a nonzero relation word does not ensure a
nonzero coefficient for an arbitrarily selected factorization.

This example **does not refute (2)**: its boundary is the zero map
\(1+\zeta+\cdots+\zeta^5=0\), and is not injective. It refutes only the
proposed Engineer shortcut, which the manuscript does not make.
Accordingly there is no manuscript `F_<LABEL>` claim to register for it.

Jacobian 0.14.0, protocol `2025-11-25`, was used only for the bounded
cyclotomic subcalculation. The inspected operation
`finite_abelian_group.spectral_pair.decide` returned `SPECTRAL` for
the points \(\{0,2,4\}\) and frequencies \(\{0,1,2\}\) in \(\mathbb Z/6\).
In particular \(1+\zeta^2+\zeta^4=0\); since \(\zeta^3=-1\), this is (7).
The exact contract, payload and typed output are the separate
`jacobian-spectral-*.json` files. The adapter exited zero, with no error or
timeout. This finite character-sum result is not support for the universal
torsion theorem. The discovery responses expose no matching universal Fox
or tower operation.

## 4. Formal word-graph proof of the universal implication

This construction implements the tower directly on finite word images.
It does not assume the existence of image complexes, a transfer theorem,
or a growing sequence. Put \(\kappa=\rho\pi\), and assume
\(\kappa(w)\ne1\). Choose the finite certificate (4).

### 4.1. The fixed source and its actual images

A right action of \(F\) on a set \(V\), written \(v\cdot u\), gives a labeled
graph with generator edge \((v,i)\) from \(v\) to \(v\cdot x_i\).
In Lean this is `RightAction`; no action of the quotient is assumed.
For a root \(v\), follow the following fixed list of paths:

1. The word \(w\), starting at \(v\).
2. Each conjugator \(u_\ell\), starting at \(v\).
3. Each positive relator word \(r_{j_\ell}\), starting at \(v\cdot u_\ell\).

The Boolean signs in (4) are used when lifting the identity; they do not
change the underlying relator cells. A negative generator traversal uses
the positively oriented edge based at the preceding inverse translate.
`sourcePaths`, `walkEdges`, `edgeSet`, `vertexSet`, and `faceSet` construct
these images explicitly. The faces are indexed by the distinct pairs
\((v\cdot u_\ell,j_\ell)\), preserving the original relator indices.
Duplicate occurrences of the same pair are the same image face.

Write \(E,S,T\) for the finite image edges, vertices, and faces. If
\[
L=|w|+\sum_\ell(|u_\ell|+|r_{j_\ell}|),\qquad B=1+2L,
\]
then `vertexSet_bound` proves \(|S|\le B\) for every action and root.
The source words and this bound never change.
The invariants are that \(w\) closes at the root and every selected
relator closes at its selected vertex.

### 4.2. The actual weighted maps and a rational voltage

For the character weights, define the integral along a word by its generator
values and
\[
I_\kappa(c,uz,v)=I_\kappa(c,u,v)+
 \kappa(u)I_\kappa(c,z,v\cdot u).
\]
`Weights.integral` is constructed by a free-group lift and has the
corresponding inverse rule. Cochains on \(E\) are extended by zero to the
whole graph. The actual constraint map
\[
C_\kappa:\mathbb C^E\longrightarrow\mathbb C^T,\qquad
(C_\kappa c)_{(s,j)}=I_\kappa(c,r_j,s)
\]
is `constraints`, not an unspecified matrix.
The weighted gradient is
\[
(\delta_\kappa b)(s,i)=\kappa(x_i)b(s\cdot x_i)-b(s).
\]
Its integral telescopes to
\(\kappa(u)b(s\cdot u)-b(s)\).
Since \(w\) closes and \(\kappa(w)\ne1\), a zero gradient forces the
root value to vanish. Propagation along the actual source paths forces
every vertex value to vanish. Thus \(\delta_\kappa\) is injective.
Closed relator loops and \(\kappa(r_j)=1\) give
\(C_\kappa\delta_\kappa=0\).

Suppose \(C_\kappa\) is surjective. Finite-dimensional rank-nullity gives
\[
|T|+|S|\le |E|.
\tag{8}
\]
For ordinary rational cochains, let \(C_1\) and \(\delta_1\) denote the
same actual word constraints and unweighted gradient. The constant vertex
cochain is a nonzero vector in \(\ker\delta_1\), since the root belongs
to \(S\). Consequently
\[
\dim\ker C_1\ge |E|-|T|\ge |S|>
\dim\operatorname{im}\delta_1.
\]
Choose \(a\in\ker C_1\setminus\operatorname{im}\delta_1\), and extend
it by zero outside \(E\).
`source_voltage_exists` proves this choice from the actual maps and (8).
It is a rational edge voltage, zero around every selected relator, and
not a vertex gradient on the source image.

### 4.3. Lifting the source, including its torsion loop

Let \(\nu_a(u,s)\) be the ordinary voltage integral. Define the actual
lifted action on \(V\times\mathbb Q\) by
\[
(s,h)\cdot u=(s\cdot u,h+\nu_a(u,s)).
\]
The voltage product rule proves this is a right action.
Each selected relator fixes the lift of its stem endpoint because its
voltage is zero. Its inverse also fixes that endpoint. Hence each signed
conjugate in (4) fixes the lifted root, and so does their product \(w^q\).
Since \(w\) fixes the old root, its \(q\)th power has height displacement
\(q\nu_a(w,v)\). The hypothesis \(q>0\), over \(\mathbb Q\), implies
\(\nu_a(w,v)=0\). Thus \(w\) closes at the new root as well.
This is `torsion_lifts`, not an assumed lifting criterion.

The projection of the new source vertex image onto the old one is
surjective (`vertexSet_natural`). If their cardinalities were equal,
there would be a unique height above each old source vertex. Denote it
by \(b(s)\). Every lifted source edge would give
\[
a(s,i)=b(s\cdot x_i)-b(s),
\]
contradicting the choice of \(a\).
`equal_count_implies_gradient` and `voltage_strict_growth` therefore prove
strict growth of the **actual** vertex image.

### 4.4. Transfer of the actual boundary

It remains to prove, not assume, surjectivity of the lifted constraint
map \(C'\). Use the commutative domain
\[
R=\mathbb C[\mathbb Q]
 =\left\{\sum_{\text{finitely many }h}c_h t^h\right\}.
\]
Its augmentation \(\varepsilon(t^h)=1\) has the constant-coefficient
section \(\iota:\mathbb C\to R\).
The downstairs weights
\(\kappa(u)t^{\nu_a(u,s)}\) define the genuine word-integral matrix
\(C_t\), with \(\varepsilon(C_t)=C_\kappa\).
Since \(C_\kappa\) is surjective, \(C_\kappa^{\mathsf T}\) is injective.
`specialization_injective` proves that \(C_t^{\mathsf T}\) is injective:
lift a left inverse of the specialized matrix, multiply to get a square
matrix specializing to the identity, and use its nonzero determinant
and adjugate over the domain \(R\).
This argument includes empty matrices.

For a lifted face \(f\), let \(p_Ff\) be its downstairs face and \(h_f\)
its starting height. For a lifted edge \(e'\), use the analogous
projection \(p_Ee'\) and height \(h_{e'}\). Define
\[
J_{f_0,f}=\mathbf1_{f_0=p_Ff}t^{h_f},\qquad
P_{e',e}=\mathbf1_{e=p_Ee'}t^{h_{e'}}.
\]
`integral_lift_monomial` and `lifted_constraint_column` prove the exact
source-derived identity
\[
C_t^{\mathsf T}J=P^{\mathsf T}(\iota C')^{\mathsf T}.
\tag{9}
\]
It follows from following the actual relator words, including negative
letters; it is not an assumed chain-transfer interface.

If \((C')^{\mathsf T}x=0\) for \(x\in\mathbb C^{T'}\), (9) and the
injectivity of \(C_t^{\mathsf T}\) give \(J\iota(x)=0\).
A lifted face is uniquely determined by its projection and starting
height (`projectFace_height_injective`). Therefore the coefficient of
\(t^{h_f}\) in coordinate \(p_Ff\) of \(J\iota(x)\) is exactly \(x_f\).
All \(x_f\) vanish. Thus \((C')^{\mathsf T}\) is injective and \(C'\)
is surjective.
Importantly, **\(J\) is not asserted injective over \(R\)**; coefficient
separation is used only for the embedded complex coefficient vectors.
`source_constraints_lift_surjective` implements this entire transfer.

Using rational heights avoids an unnecessary common-denominator choice.
The voltage has only finitely many nonzero values, so their additive
subgroup of \(\mathbb Q\) is cyclic. One could scale to integral heights,
but that normalization is neither assumed nor needed by the formal proof.
The rational-voltage construction is the implemented variant of the
cyclic-tower argument; it puts no restriction on the image of \(\rho\).

### 4.5. Initialization from the quotient and termination

Start with the one-vertex action `roseAction`. All words close there.
`rose_integral_functional` proves, for every linear functional \(\ell\),
\[
I_\kappa\bigl((\ell(e_i))_i,u,*\bigr)=\ell(d(u)).
\tag{10}
\]
The proof uses the actual generator-derived `TorsionFox.fox`.
Injectivity of \(D_\rho\) supplies a linear left inverse \(s\).
Given values on the selected faces, extend them by zero to all original
relator indices and form the corresponding functional after \(s\).
Its values on \(d(r_j)=D_\rho(e_j)\) are precisely the prescribed values.
Restrict its generator cochain to the actual selected source edges.
Locality of the word integral and (10) show that this restriction still
has the prescribed integrals. This proves initial surjectivity in
`initial_constraints_surjective`; no matrix-identification hypothesis
is inserted.

The preceding steps now apply repeatedly: the source-loop and relator-loop
invariants persist, the actual constraint map stays surjective, and the
vertex count strictly increases while remaining at most \(B\).
`finite_source_tower_contradiction` proves by induction that for every
natural \(k\), every such state would satisfy \(k+|S|\le B\).
Its successor step constructs the voltage and lifted state just proved.
Taking \(k=B+1\) at the initial state is impossible.
This disproves \(\kappa(w)\ne1\) and proves (2).

Finally `universal_torsion_statement` obtains \(w\) using surjectivity
of the **actual** presented-group quotient and obtains (4) from its
normal-closure kernel. It discharges all tower inputs and concludes
\(\rho(g)=1\), with precisely the quantifiers in (2).

## 5. Improvement and remaining review boundary

The strongest prior result for this goal was the independently reviewed
`C-FOX-TORSION-CALCULUS` version 2, which stopped at (5). The new result
proves the previously missing universal implication by constructing the
finite source, rational lifts, source-derived transfer and strict bound.
It is not a larger finite experiment or a fixed-presentation substitute.

The arbitrary-witness shortcut remains retired for the precise cancellation
in (7). Historical tower-route identifiers are superseded only to bind the
new source and rational-voltage instantiation; the tower mathematics was
not refuted. `R-FOX-TORSION-VOLTAGE-CERT-V4` records that continuation.

The Host Reviewer must check the final universal declaration, the fidelity
reading, and the cellular interpretation. The current theorem does not
formalize all CW topology, certify higher-rank local systems, establish
publication-level novelty, refute the manuscript, or finish the campaign.
