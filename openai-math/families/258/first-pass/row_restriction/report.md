# Division-free restriction to actual row orbits

## Scope and dependencies

The target is Proposition `row:restriction` of the staged September 25,
2026 virtual-specialness manuscript, not just its dimension consequence.
The quantifiers include every subgroup `U <= L`, every actual level, all
double cosets, both primitive presentations, root rows, coarse rows, and
one incident slot at a time. Coefficients are on the left of chains and
group-ring entries multiply them on the right.

The supplied scope findings are retained as follows. A rank inequality,
an abstract failure of descent from a division ring, a finite example,
or a theorem assuming the desired homology injection cannot settle this
mission. No counterexample is asserted without the original primitive
and group hypotheses. Downstream `row:path-inertia` and
`close:join-injection` remain separate obligations.

The coefficient existence input is recorded as `A258-ATIYAH-PRECISE` in the
ledger. The primary author version arXiv:1810.12135v4 was obtained:
Corollary 1.3 gives the strong Atiyah conjecture for one-relator groups,
the introduction states its torsion-free division-ring consequence,
and Section 2.2 describes the compatible subgroup embeddings of
affiliated-operator algebras. Independent source attribution remains
the Reviewer's task. Coset independence is proved below rather than
assumed from a dimension calculation.

The manuscript also cites Jaikin-Zapirain, *The universality of
Hughes-free division rings*, doi:10.1007/s00029-021-00691-w.
The author host had a TLS failure, the institutional mirror returned
403, and the publisher retrieval returned 406. No proposition in that
unobtained source is used here. A search service supplied the unrelated
arXiv identifier 2106.09082; checking its primary abstract rejected that
identification. Neither a search summary nor a registry resolution is
treated as theorem attribution.

## Verification theorem

Let the primitive data and actual splittings be those of
`row:primitive-data` and `row:refinement`. Let \(K=L\), or let \(K\)
be a refined or coarse vertex group when considering one incident
slot. Let \(D\) be a division ring containing \(\mathbb QK\), and
let \(M\) be a right \(\mathbb QK\)-module equipped with a faithful
right-linear embedding into \(D\).

**Theorem.** For every refined or coarse row group \(X\) at a
specified height, the natural map
\[
 H_1(X;M)\longrightarrow H_1(L;M)
\]
is injective (in the first case \(K=L\)). For an incident edge type
\(X\) in a vertex group \(K\), the map
\[
 H_1(X;M)\longrightarrow H_1(K;M)
\]
is injective. These statements need no inverses in \(M\), no flatness
of \(M\) over a group ring, and no finite generation of a subgroup
used to construct \(M\).

Taking \(M=D_U\otimes_{\mathbb QU}\mathbb QK\) proves
`row:restriction`, including all actual \(U\)-orbit summands
simultaneously. It is not merely a bound on their dimensions.

The theorem is a verification and coefficient generalization of the
specified proposition, not a refutation. Hyperbolicity, malnormality,
the ordinary/conjugate intersection theorems, `row:level-basis`, and
`row:path-inertia` are not used in its proof once the stated primitive
splitting and division coefficient objects are available. In
particular this argument does not use a downstream inertia assertion
to prove its own input.

## 1. Faithfulness of the induced coefficients

Identify \(D_U\) with its natural division closure in
\(\mathcal U(U)\subseteq\mathcal U(K)\). The latter inclusion is the
one described in Section 2.2 of the obtained primary source.
Division closure is compatible with this inclusion: inverses of
nonzero elements agree in the ambient affiliated algebra. Thus
\(D_U\subseteq D_K\).

For completeness, the multiplication map
\[
 D_U\otimes_{\mathbb QU}\mathbb QK\ \longrightarrow D_K,\qquad
 d\otimes g\longmapsto dg
\]
is injective. Write a finite tensor using distinct cosets \(Ug_j\)
as \(\sum_j d_j\otimes g_j\). There is an injective bounded
\(s\in\mathcal N(U)\) with every \(sd_j\) bounded. For example, for
the affiliated row operator \(T=(d_1,\ldots,d_r)\), take
\(s=(1+TT^*)^{-1/2}\). Spectral calculus gives zero kernel and dense
range for \(s\), and polar decomposition gives
\(\|sT\|\leq1\). These assertions also show directly why a common
left multiplier, rather than commuting denominators, is legitimate.

If \(\sum_jd_jg_j=0\), then
\(\sum_j(sd_j)g_j=0\) in \(\mathcal N(K)\). Applied to the identity
vector, these terms have disjoint Fourier supports \(Ug_j\).
Consequently each bounded coefficient \(sd_j\) is zero. Since \(s\)
is injective, \(d_j=0\) for every \(j\). This proves the claimed
faithfulness for every \(U\), including infinitely generated \(U\).

The proof below actually works for any right module with this
faithfulness property. In particular it never concludes that a
quotient over \(M\) embeds in a quotient over \(D\); that generally
invalid descent argument is unnecessary.

The rejected overfield-only route is recorded as
`R258-FIELD-ONLY`. For example, with
\(E=\mathbb Q[s,s^{-1}]\subset D=\mathbb Q(s)\),
\(E/E(s-1)\) is nonzero (evaluation at \(s=1\) detects \(1\)),
but \(D/D(s-1)=0\). This only refutes a general descent
inference; it is **not** a counterexample to the manuscript
or to any primitive row.

## 2. All local Fox maps are monomorphisms

Use the manuscript's convention
\(d(vw)=d(v)+v\,d(w)\). A coefficient \(c\in M\) therefore
multiplies a Fox entry on its right. If \(p\in\mathbb QK\) is
nonzero, then
\[
 cp=0\quad\Longrightarrow\quad c=0.                 \tag{1}
\]
Indeed embed the equation in the division ring. This detects a zero
coefficient already in \(M\); it neither divides in \(M\) nor replaces
that coefficient by one from an overfield.

For any nonzero integer \(m\), set
\[
 S_m(u)=
 \begin{cases}
 \sum_{j=0}^{m-1}u^j,&m>0,\\
 -\sum_{j=1}^{-m}u^{-j},&m<0.
 \end{cases}
\]
Then \(d(u^m)=S_m(u)\,du\). If \(u\) has infinite order, \(S_m(u)\)
is a nonzero group-ring element: its support consists of distinct
powers, each with the same nonzero sign. This argument covers both
signs of each primitive quotient exponent.
In the first form \(u\) is a free generator. In the root form the
free base embeds, \(z\ne1\) has infinite order, and \(u^d=z\);
therefore \(u\) has infinite order there too.

### Free-side maps

Write \(B=B_0\). The map
\(F(B,x)\to P_-=F(a_0,B)\) sends the \(B\)-basis chains identically
and sends the \(x\)-chain to \(d(x)\). Its \(a_0\)-entry \(p\) is
nonzero. To see this, the reduced path spelling \(x\) in the free
Cayley tree has no repeated edge. The terms of its \(a_0\)-Fox
derivative are the signed initial vertices of the corresponding
positively oriented edges. Equal such terms with opposite signs
would traverse one edge twice, impossible for a reduced path.
There is an \(a_0\)-occurrence because \(x\notin F(B)\).

A chain in the kernel of this Fox map has missing-letter coordinate
\(c_xp=0\). By (1), \(c_x=0\); the remaining identity columns then
give every \(B\)-coefficient zero. Thus the whole degree-one chain
map is injective over \(M\), and so is its restriction to cycles.
The same argument, using \(a_k\), applies to \(F(B,y)\to P_+\).
It remains valid after all shifts and actual conjugations.

### First primitive form: the free middle row

Here \(Q=F(B,u)\), \(x=u^d\), \(y=u^n\), with \(d,n\ne0\).
The two edge Fox maps have the identity \(B\)-block and final entries
\(S_d(u)\) and \(S_n(u)\), respectively. Both are nonzero. Equation
(1) makes both chain maps injective, hence both maps on \(H_1\).
This includes \(B=\varnothing\).

### Second primitive form: the root row

Use its presentation
\[
 Q=\langle B,x,u\mid z(B)u^{-d}\rangle,\qquad
 y=x^{-1}u^n.
\]
The row relation has Fox boundary, after evaluating in \(Q\),
\[
 d(z)-S_d(u)\,du.                                  \tag{2}
\]
The \(x\)-coordinate of (2) is zero because \(z\) uses only \(B\).
The inclusion of \(I=F(B,x)\) is the identity on the \(B,x\)
coordinates and has zero \(u\)-coordinate.

If an \(I\)-cycle is the boundary of a \(Q\)-two-chain, its image
equals \(e(d(z)-S_d(u)\,du)\) for its original coefficient
\(e\in M\). Comparing \(u\)-coordinates gives \(eS_d(u)=0\), hence
\(e=0\). Comparing the remaining coordinates gives that the
original \(I\)-chain is zero. This proves \(H_1(I;M)\to H_1(Q;M)\)
injective with no change of the boundary coefficient.

For \(J=F(B,y)\), change free generators from \(x,u\) to \(y,u\).
The inverse substitutions and their Fox formulas are
\[
 \begin{aligned}
 y&=x^{-1}u^n,&
 dy&=-x^{-1}dx+x^{-1}S_n(u)\,du,\\
 x&=u^ny^{-1},&
 dx&=-x\,dy+S_n(u)\,du .
 \end{aligned}                                    \tag{3}
\]
On coefficient pairs these give
\[
 (c,e)\mapsto(-cx,cS_n(u)+e),\qquad
 (c,e)\mapsto(-cx^{-1},cx^{-1}S_n(u)+e).
\]
They are inverse in the stated noncommutative order. All entries
are group-ring elements, so these changes preserve \(M\).
They fix \(B\) and \(u\), hence also fix (2). The preceding private
\(u\)-column argument now applies to \(J\). This covers genuine
nonfree root rows as well as \(d=\pm1\); no root row is discarded.
For \(k=1\), the second form is absent because it requires
\(1\ne z\in F(B)\).

The group embeddings used above are also explicit. In a free product
\(F(B)*\langle a_0\rangle\), reduced normal forms show that a
subgroup generated by \(F(B)\) and an element outside it is
\(F(B)*\langle x\rangle\). In the second form \(F(B,x)\) embeds in
its root amalgam by reduced amalgam normal forms. The alternative
base \(F(B,y)\) embeds by (3). Thus these are the actual free edge
groups, not abstract coefficient matrices attached to nonexistent
subgroups.

## 3. Exact trimming on the line, without scalar extension

Here is the algebraic fact formalized in `Main.lean`. Let \(A_j\)
be arbitrary abelian vertex groups and \(B_j\) arbitrary abelian
edge groups on a line. Let
\[
 l_j:B_j\hookrightarrow A_j,\qquad
 r_j:B_{j-1}\hookrightarrow A_j
\]
be injective. For a finite-support family \(b=(b_j)\), the incidence
boundary at vertex \(j\) is
\(l_jb_j-r_jb_{j-1}\).

If this boundary is supported at a single vertex \(o\), then \(b=0\).
Otherwise let \(m\) and \(n\) be the least and greatest indices
where \(b\ne0\). The boundary at \(m\) is \(l_mb_m\ne0\), forcing
\(m=o\). The boundary at \(n+1\) is
\(-r_{n+1}b_n\ne0\), forcing \(n+1=o\), contrary to \(m\leq n\).
In particular each \(A_o\) injects into the incidence cokernel.
Finite paths are covered by padding with zero groups.

To apply this fact to group homology for an arbitrary right module
\(M\), form the tree of classifying spaces for the **actual**
graph of groups. A vertex space is a \(K(X_v,1)\); an edge cylinder
is a \(K(X_e,1)\) times an interval, attached by the actual
inclusions. Its universal cover is a tree of contractible covers
and is contractible. Thus it computes the group homology.

On chains this is the mapping cone of the difference of the two
endpoint maps
\[
 \bigoplus_e C_*(X_e;M)
 \longrightarrow
 \bigoplus_v C_*(X_v;M).
\]
This construction works before applying coefficients, with free
group-ring chains. After tensoring with \(M\), it is still literally
the same mapping-cone complex; no exactness of tensoring a quotient
and no flatness assertion is involved.

More explicitly, a vertex cycle vector \(z\) bounding in that cone
has the form \(z=dv_2+f(e_1)\), with \(de_1=0\).
Its vertex homology vector is therefore the incidence image of the
finite-support edge homology vector \([e_1]\). Conversely any such
incidence image bounds. This proves the exactness at
\(\bigoplus_vH_1(X_v;M)\) that is needed, directly in degree one.
Every endpoint map on these edge homologies is injective by
Section 2 (or is an isomorphism for a shift edge). The line lemma
therefore proves that each vertex \(H_1\) injects in the total group
homology. It is not necessary that \(H_0(X_e;M)\) vanish.

For a coarse row \(H\), first apply this argument to the finite
three-vertex line
\[
 P_-\ *_{I}\ Q\ *_{J}\ P_+ .
\]
It proves \(H_1(P_\pm;M)\to H_1(H;M)\) injective. Apply it again
to the infinite coarse line of \(H\)-rows with \(P\)-edges.
It proves every coarse-row injection. Alternatively apply it to
the infinite refined line before collapsing the isomorphic shift
edges; this proves all refined vertex injections. Refined midpoint
groups inject through either endpoint, using Section 2. These
arguments give all row types, not only free rows.

For one incident slot in a refined vertex, use precisely the
corresponding local edge inclusion from Section 2. In a coarse
vertex, use the just-proved \(P_\pm\to H\) inclusion. No assertion
about the simultaneous union of the two different slots is made
or needed.

## 4. Bridge to the original primitive Fox complex and height frames

For the first primitive form, killing the primitive relator in
the abstract two-slot free group leaves an infinite cyclic group
with \(x=u^d,\ y=u^n\), where \(d,n\ne0\).
For the second, apply the same operation to the slots \(xy,z\):
\(xy=u^n,\ z=u^d\). Keeping \(F(B)\) and the two free sides gives
exactly the three-piece presentations used in Section 2.
Indeed, if the positive primitive word has slot occurrence counts
\(\alpha,\beta>0\), its cyclic quotient sends those slots to
\(u^{\pm\beta},u^{\mp\alpha}\). Thus neither quotient exponent
vanishes, independently of the choice of orientation for \(u\).
Normal forms give the indicated embeddings into each piece. Adding
the stable letter identifying \(P_+\) and \(P_-\) recovers the
original two-generator presentation by eliminating the \(a_j\).
Thus these are the stipulated actual Bass-Serre trees.

This is also a chain bridge, not just a group isomorphism. A
primitive basis change of a free two-slot group has an invertible
Fox Jacobian over its group ring: applying the Fox chain rule to
the basis change and its inverse gives inverse Jacobians.
Adjoining its complementary generator \(u\) adds a generator and
a defining relation with a unit generator pivot. Killing the
primitive basis element therefore replaces the original relator
by the following paired relations over the group ring:
\[
 \begin{array}{ll}
 x_j u_j^{-d},\quad y_j u_j^{-n},
     &\text{first form},\\
 x_jy_j u_j^{-n},\quad z_j u_j^{-d},
     &\text{second form}.
 \end{array}
\]
Their Fox two-boundaries, in exactly this order, are
\[
 \begin{array}{ll}
 dx_j-S_d(u_j)du_j,\quad dy_j-S_n(u_j)du_j,\\
 dx_j+x_jdy_j-S_n(u_j)du_j,\quad
 dz_j-S_d(u_j)du_j .
 \end{array}                                      \tag{4}
\]
Introducing the named edge generators in the mapping-cylinder
model and then removing them gives these same presentations.
Each removal has an identity generator pivot; collapsing the
connecting base line is a tree collapse with group-unit pivots.
Together with the primitive Fox Jacobian changes, these are
chain equivalences through the degrees computing \(H_1\) over
the group ring, and therefore over every \(M\). No \(S_m(u_j)\)
is inverted in these operations.

For any group presentation, its Fox complex computes \(H_1\)
with arbitrary right coefficients: the universal cover of the
presentation complex is simply connected, so the cellular
sequence is a free resolution through degree one. Higher
asphericity is not needed for this assertion. Consequently the
mapping-cone argument of Section 3 computes exactly the
manuscript's Fox homology, not a different chain invariant.
On the row generators the chain maps are the actual inclusion
Fox maps of Section 2; hence their induced homology maps are
the stated ones.

There is a sign-sensitive indexing point. With the manuscript's
\(a_j=t^{-j}at^j\), the coarse representative of height \(i\) is
\[
 H^{(i)}=t^iHt^{-i}
       =\langle a_{-i},\ldots,a_{k-i}\mid R_{-i}\rangle.
\]
It is **not** the relator row \(R_i\). Write \(P_\pm^{(i)}\),
\(Q^{(i)}\), \(I^{(i)}\), and \(J^{(i)}\) in this same frame.
The shift edge identifies
\(P_+^{(i)}=P_-^{(i-1)}\), just as the stated height convention
requires. Before collapse the quotient is the infinite line of
these three-piece blocks and shift edges. After collapse it is
the alternating line of \(P\)- and \(Q\)-vertices, with \(I,J\)
midpoints at the prescribed quarter heights. This checks both
the actual frames and the coarse/refined correspondence.

## 5. All actual double cosets, and the natural map

Let \(K=L\) for a level and let \(X\) be the stabilizer of its
chosen standard row. Actual rows in that level are \(K/X\);
actual \(U\)-orbits are \(U\backslash K/X\). Put
\(M=D_U\otimes_{\mathbb QU}\mathbb QK\). For each representative
\(g\), set
\[
 V_g=g^{-1}Ug\cap X,\qquad W_g=U\cap gXg^{-1}.
\]
Give \(D_U\) the right \(V_g\)-action
\(d\cdot v=d(gvg^{-1})\). Restricting \(M\) to \(X\) gives the
actual bimodule decomposition
\[
 M|_X=
 \bigoplus_{UgX}
 \left(D_U^{(g)}\otimes_{\mathbb QV_g}\mathbb QX\right),
 \qquad d\otimes x\longmapsto d\otimes gx.           \tag{5}
\]
It is well-defined because moving \(v\) across the tensor on
the right moves \(gvg^{-1}\in U\) across the tensor on the left.
Different double cosets have disjoint group-ring supports, so
(5) is a direct sum, not a dimension comparison.

Here the Shapiro identification follows directly from free
resolutions: a free \(\mathbb QK\)-resolution of the trivial
module remains a free resolution on restriction to \(U\), and
associativity of tensoring identifies its induced-coefficient
complex with the \(U\)-coefficient complex. The same argument
for \(V_g\leq X\), followed by conjugation by \(g\), gives
\[
 H_1(X;M)
 \cong \bigoplus_{UgX}H_1(W_g;D_U),\qquad
 H_1(K;M)\cong H_1(U;D_U).                          \tag{6}
\]
Homology commutes with these algebraic direct sums, since all
chains have finite support.

The map in (6) is the requested sum of inclusions. This
naturality can be checked without choosing a dimension basis.
For \(w=gvg^{-1}\), Fox differentiation gives
\[
 d(w)=(1-w)d(g)+g\,d(v).                            \tag{7}
\]
In a cycle the sum of coefficients times \(w-1\) is zero, so
the connecting-path terms in (7) cancel. The remaining terms
are precisely those of \(d\otimes gx\) in (5), followed by
the inclusion \(W_g\leq U\). No coefficient has been commuted
past \(g\). Replacing a representative by an element of the
same double coset gives the usual subgroup conjugation and
right group-unit transport; (7) proves that the ambient cycle
class is unchanged. This matches the manuscript's specified
coefficient transport.

The map \(H_1(X;M)\to H_1(K;M)\) is injective by Sections 2--3.
Conjugating it by the isomorphisms (6) proves exactly the
simultaneous direct-sum injection in `row:level-restriction`.
For a vertex slot replace \(K\) by that vertex group and use
its incident edge group for \(X\); the same proof identifies
all actual incident edges, not just one preferred edge.
This proves every stated coarse-row and incident-slot version.

Finally, if a row one-chain maps to a two-boundary, its own
zero-boundary is zero because the degree-zero inclusion is
identity (or a group-unit change of basepoint). Thus the
induced-module homology result also says that such a chain
already bounds in the row over the same \(M\). This is the
chain-level saturation assertion used in the manuscript.

## Certification boundary and comparison

`Main.lean` formalizes the universal finite-support incidence
argument, noncommutative triangular pivots, private columns, and
the two inverse root-frame changes. `statement_fidelity.md`
states the exact boundary of that formalization. Group homology,
the actual presentation bridge, the affiliated-operator input,
and the map identification (5)--(7) are mathematical arguments
in this report and require independent review; they are not
silently labelled kernel-checked.

The previous strongest relevant result was the manuscript's
asserted restriction theorem and its extreme-column sketch;
the campaign ledger contained no prior certified result. The
improvement here is a proof over arbitrary faithful right
modules, with all original boundary coefficients retained,
and an explicit mapping-cone/Mackey bridge preserving every
actual row orbit. It does not merely re-establish numerical
inertia, nor does it rely on extending homology to \(D_L\).
No literature novelty or publishable manuscript-wide result
is claimed without independent assessment.

The saved Jacobian operation `chain_complex.homology.compute`
checked the signs of one two-edge rational incidence matrix.
Its exact payload, typed output, server version, protocol, and
adapter exit status are retained separately. It is an auxiliary
finite sanity check and contributes no inference about the
universal theorem.

Independent Reviewer acceptance is still required. Resolving
this dependency does not by itself verify `row:path-inertia`,
`close:join-injection`, Gersten's conjecture, or the manuscript's
virtual compact specialness theorem.

The Engineer's real Lean 4.31.0 run returned `exit_code=0` and
`proof_holes=[]`; its immutable archive is named in
`exact_certificate.json`. The default replay command is
`python3 research/row_restriction/verify.py`. It checks that
archive against the present source, fidelity document, and live
claim version, and checks ten universal noncommutative identities,
not numerical samples. For an independent fresh kernel replay,
use `python3 research/row_restriction/verify.py --compile`.
The default command intentionally does not repeat an unchanged
compiler run. Neither command purports to replace independent
reading of the group-theoretic proof and its coefficient source.
