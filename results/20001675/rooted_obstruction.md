# A rooted surgery invisible to quiver point counts

This is an ordinary proof with exact replay code, not a Lean formalization.
The Host-invoked Reviewer independently verified the mathematics, statement
fidelity, both certificates, and the 13 original source attributions on
2026-11-03. That correctness verdict is preserved. A later independent
publication review rejected this package's technical publication basis:
standard coalescence already supplies its amplification and full defect.
The new comparison below makes the full Traldi overlap explicit; it does
not re-open that retired strategy or certify priority of the exact example.

## Conventions and main theorem

For a rooted forest \(F\), let
\[
C_F(x,y)=\sum_{S\ {\rm independent}}x^{|S|}
 y^{|S|-|\{\operatorname{parent}(v):v\in S,\ v\text{ is not a root}\}|}.
\]
Schwartz's Lemma 4.1 proves that this polynomial is independent of the chosen roots.
Write \(I_F(x)=C_F(x,1)\) and \(M_F(x)=C_F(x,0)\), where the latter is the
matching **generating** polynomial, not the signed characteristic matching
polynomial. For a forest of order \(n\), the supplied source identities are
\[
 R_F(q)=(q-1)^nI_F\!\left(\frac{q}{(q-1)^2}\right),\qquad
 P_F(a,z)=a^{-n}z^n C_F(z^{-2},1-a^{-2}).                 \tag{1}
\]
Here \(R_F\) is the normalized quiver point-count rational function; it need
not be a polynomial or an integer-valued unnormalized variety count.
The HOMFLY normalization is \(P_{\bigcirc}=1\) and
\(aP_+-a^{-1}P_-=zP_0\).

**Theorem.** For every \(m\geq1\), there are connected trees
\(T_{m,\epsilon}\), \(\epsilon\in\{0,1\}^m\), on \(N=8m+2\) vertices,
of maximum degree at most four, with the following properties.

1. All \(I_{T_{m,\epsilon}}\), and hence all \(R_{T_{m,\epsilon}}\), are equal
   for this fixed \(m\).
2. There is an integer \(b_m\), independent of \(\epsilon\), such that
   \[
   [a^{-(N+4)}z^{N-8}]P_{T_{m,\epsilon}}
       =b_m+2|\epsilon|.                                \tag{2}
   \]
   Thus a single normalized point count has at least \(m+1\) distinct full
   HOMFLY polynomials. Fiber cardinalities are unbounded as \(m\) varies;
   this does not assert an infinite fiber of one fixed rational function.
3. Every tree in the construction has an explicitly specified connected,
   simple, non-reduced plabic realization. Formula (1) and the associated
   link HOMFLY polynomial apply to those realizations.

The construction and the stronger arbitrary-host identity below are not
disconnected products. They do not address whether mutation-equivalent
quivers determine the same full HOMFLY polynomial.

## The rooted core and its exact deletion defect

Let \(Q\) have vertices \(0,\ldots,7\) and edges
\[
01,\ 05,\ 12,\ 14,\ 23,\ 56,\ 67.
\]
It is the spider with arms of lengths \(1,2,4\), centered at \(1\).
Mark \(r=2\) and \(s=5\), both of degree two. Set
\(K=y-1+xy^2\). Direct leaf recurrence gives
\[
\begin{aligned}
C_Q={}&1+x(7+y)+x^2(14+7y)\\
 &+x^3(8+12y+y^2)+x^4(1+4y+2y^2),\\
C_{Q-r}={}&(1+xy)
 \{1+x(5+y)+x^2(6+4y)+x^3(1+3y)\},\\
C_{Q-s}={}&(1+x+xy)
 \{1+x(4+y)+x^2(2+4y)+x^3(y+y^2)\}.
\end{aligned}                                                    \tag{3}
\]
Indeed, \(Q-r=P_1\sqcup P_6\), whereas
\(Q-s=P_2\sqcup D_5\), where \(D_5\) has arms \(1,1,2\).
Each displayed factor follows from
\[
 C_\varnothing=1,\quad C_{P_1}=1+xy,\quad
 C_F=C_{F-v}+xC_{F-\{v,u\}}                              \tag{4}
\]
for a leaf \(v\) adjacent to \(u\), with multiplication on components.
Equation (4) also follows by substituting (1) into Schwartz's Definition 3.1.
Expanding (3) yields the important two-variable identity
\[
 C_{Q-s}-C_{Q-r}=x^3(y-1)K.                              \tag{5}
\]
In particular,
\[
\begin{aligned}
 I_Q&=1+8x+21x^2+21x^3+7x^4,\\
 I_{Q-r}=I_{Q-s}
    &=A=1+7x+16x^2+14x^3+4x^4,\\
 I_Q-A&=B=x+5x^2+7x^3+3x^4,\\
 M_{Q-s}-M_{Q-r}&=x^3.
\end{aligned}                                                    \tag{6}
\]
The finite search located these roots; (3)-(6), rather than exhaustion or
the search's minimality, are what the proof uses.

## Universal host identity

For a rooted tree \((H,h)\), let \(H\cdot Q_r\) mean identification of \(h\)
with \(r\) in a disjoint copy of \(Q\); define \(H\cdot Q_s\) similarly.
For every such \(H\),
\[
\boxed{\quad
 C_{H\cdot Q_r}-C_{H\cdot Q_s}
  =x^3(y-1)\{C_H-(1+xy)C_{H-h}\}.
\quad}                                                         \tag{7}
\]
No bound on the size or shape of the host is imposed.

Here is a derivation directly from the parent-count definition. At a root,
let \(A_H\) and \(B_H\) count sets excluding and including the root.
For the rooted child subtrees put
\[
 E_H=\prod A_{\rm child},\qquad
 D_H=\prod C_{\rm child}=C_{H-h}.
\]
If no child root is selected the contribution is \(E_H\). Otherwise the
new parent \(h\) is counted once, irrespective of how many child roots
were selected. Consequently
\[
 A_H=E_H+(D_H-E_H)/y,\quad B_H=xyE_H,\quad
 yC_H=D_H+KE_H.                                         \tag{8}
\]
The quotient is a polynomial: every term of \(D_H-E_H\) contains a
selected child root and is divisible by \(y\).

Under root identification the child lists are concatenated. Substituting
(8) gives the polynomial identity
\[
 C_{H\cdot T}
  =yC_HC_T-K\{C_HE_T+C_TE_H-(1+xy)E_HE_T\}.               \tag{9}
\]
The unrooted \(C_Q\) is the same at \(r,s\). Equations (5) and (8) give
\(E_{Q_r}-E_{Q_s}=x^3(y-1)\). Subtracting (9) at the two roots gives
\[
 x^3(y-1)K\{(1+xy)E_H-C_H\}.
\]
Finally (8) implies
\(K\{(1+xy)E_H-C_H\}=C_H-(1+xy)D_H\), proving (7).
The replay checks (9) and this cancellation with independent symbolic
host variables, not just with finitely many hosts.

Setting \(y=1\) in (7) proves independence equality for every host.
Setting \(y=0\) gives the exact matching separation
\[
 M_{H\cdot Q_r}-M_{H\cdot Q_s}
    =-x^3(M_H-M_{H-h}).                                 \tag{10}
\]
For a non-isolated \(h\), the right side is nonzero.

More precisely put \(d=\deg_H(h)\), \(v=|H|\), and \(N=v+7\).
The single-vertex independent sets give
\[
 [x]C_H=v-1+y,\qquad
 [x]C_{H-h}=v-1-d+dy.
\]
It follows from (7) that
\[
 [x^4](C_{H\cdot Q_r}-C_{H\cdot Q_s})=-d(y-1)^2,
\]
with all lower \(x\)-coefficients zero. Therefore
\[
 [a^{-(N+4)}z^{N-8}]
 (P_{H\cdot Q_r}-P_{H\cdot Q_s})=-d.                     \tag{11}
\]
This proves separation without numerical specialization, with the
necessary exception \(H=P_1\), for which the two graphs are both \(Q\).
Equivalently (7) gives the full exact HOMFLY defect
\[
 P_{H\cdot Q_r}-P_{H\cdot Q_s}
   =-a^{-9}zP_H+a^{-10}(z^2+1-a^{-2})P_{H-h}.            \tag{12}
\]
For a disconnected forest \(H-h\), its \(P\) in this expression means the
forest invariant, multiplicative on components, not a disjoint link union.

## The parameter-uniform connected family

Start with the path \(v_0,\ldots,v_{m+1}\). At each internal vertex \(v_i\),
identify a fresh copy of \(Q\) at \(r\) if \(\epsilon_i=0\), and at \(s\)
if \(\epsilon_i=1\). This defines \(T_{m,\epsilon}\) without enumeration.
Identifying trees at one vertex produces a tree, adds seven vertices,
and creates no repeated edges. Hence \(N=m+2+7m=8m+2\).
Each internal path vertex has degree \(2+2=4\); all other degrees are
at most three.

By (6) the excluded/included independence weights at every internal
site are \(A,B\), independent of the bit. In particular the common
independence polynomial has the explicit transfer formula
\[
 J_m(x)=
 (1+x,\ 1)
 \begin{pmatrix}A&A\\B&0\end{pmatrix}^{m}
 \begin{pmatrix}1\\x\end{pmatrix}.                        \tag{13}
\]
The common normalized point count is
\[
 R_m(q)=(q-1)^{8m+2}J_m\!\left(q/(q-1)^2\right).          \tag{14}
\]
This is rooted substitution, not multiplication by a common invariant
of a detached component.

To switch one bit, remove that site's seven non-root vertices. The
remaining host is connected and its root has degree two, regardless of
the other bits. By (11), switching \(r\) to \(s\) increases the specified
HOMFLY coefficient by exactly two. Telescoping proves (2). The same
argument applied to (10) gives
\([x^4]M_{T_{m,\epsilon}}=[x^4]M_{T_{m,0}}+2|\epsilon|\).
Taking weights \(0,\ldots,m\) proves the stated lower bound. We do not
claim that all \(2^m\) words have different HOMFLY polynomials.

## Explicit non-reduced simple plabic disk maps

Here is a uniform combinatorial embedding for any input tree \(T\) of
order \(n\geq2\). It specifies a disk map, including its boundary order,
and not merely an abstract graph claimed to be planar.

Root the input tree at \(0\), and order each neighbor list increasingly.
For every vertex \(v\) of degree \(d_v\), take a clockwise polygon with
vertices \((v,i)\), \(0\leq i<2(d_v+2)\). The edge
\((v,2j)(v,2j+1)\) is the port for its \(j\)-th neighbor.
For an input edge \(vw\), with port indices \(j,k\), identify
\[
 (v,2j)=(w,2k+1),\qquad (v,2j+1)=(w,2k).
\]
All ports within one polygon are nonadjacent. Gluing along a tree
attaches one disk at a time along a boundary edge; the union is a disk
and all its vertices stay on its outer perimeter. Equivalently, the
oriented face and vertex-rotation lists below certify this embedding.
There are
\[
 b=\sum_v2(d_v+2)-2(n-1)=6n-2
\]
perimeter edges and perimeter vertices.

Color \((v,i)\) by \(\operatorname{depth}(v)+i\bmod2\), with \(0\) black.
The reversed port identifications preserve colors. Every polygon edge
has opposite-colored endpoints. Trace the unglued edges clockwise,
starting at the least canonical vertex label, to obtain
\(u_0,\ldots,u_{b-1}\).
Place black boundary vertices \(b_0,\ldots,b_{b-1}\) in that clockwise
order on a larger disk and draw noncrossing spokes \(u_jb_j\) through
the annulus. These boundary vertices have degree one.
Finally add one interior leaf \(t\), of color opposite to \(u_0\), in
the boundary face between \(u_0,u_1,b_1,b_0\), joined only to \(u_0\).

These are connected ordinary simple graphs as well as simple plabic
graphs. Their interior faces are precisely the input polygon cells.
Each shared cell edge has opposite colors and gives exactly the
corresponding input-tree quiver edge. Every other edge has a boundary
face on at least one side; the added leaf has the same boundary face
on both sides. Thus the mutable quiver is an orientation of \(T\),
with no loop, multiple edge, or directed two-cycle.

The leaf \(t\) is interior, its neighbor has degree at least four, and
the two colors are opposite. This is the explicit non-reduced
configuration in Schwartz Section 2.1, Figure 5(ii). Non-reducedness
does not rely on an untested strand drawing. It is a transparent
boundary-face modification, not a claimed new source of polynomial
separation. The polynomial obstruction is (7) and the repeated connected
substitution above; neither is a claimed new general mechanism.

For a finite exact embedding certificate, append formal boundary arcs
\(b_jb_{j+1}\), which are **not plabic graph edges**. The disk faces are
the cells and the annular walks
\[
 (u_{j+1},u_j,b_j,b_{j+1});
\]
at \(j=0\), insert the spur \(u_0,t,u_0\).
Append the outside boundary walk in reverse order. Every directed edge
occurs in exactly one face walk; the induced rotation is a single cycle
at each vertex. The connected oriented map has Euler characteristic
two, so it is a sphere embedding, with the specified outside disk
removed. This supplies a precise disk embedding and boundary order.
The replay verifies these properties and derives the quiver arrows
from the colored face incidences. The construction is an explicit
polygon-cell variant of the tree realization in Schwartz Proposition
2.1; the added boundary-face leaf forces the authorized non-reduced
condition. No non-alternating property is asserted or needed.

## Small exact example and replay

For \(H=P_2\), rooted at an endpoint, the pair has order nine. Its edge
lists are recorded in `tree_surgery.json`, and both have
\[
 I(x)=1+9x+28x^2+37x^3+21x^4+4x^5,
\]
\[
 R(q)=\frac{(q+1)^2(q^2-q+1)^2
                 (q^4-q^3+q^2-q+1)}{q-1}.
\]
The matching polynomials are respectively
\(1+8x+19x^2+14x^3+2x^4\) and
\(1+8x+19x^2+14x^3+3x^4\).
In the fixed normalization the exact full HOMFLY difference is
\[
 P_{\rm left}-P_{\rm right}
   =a^{-11}z^{-1}(1-a^{-2})^2-a^{-13}z,
\]
so, for example, the coefficient difference at \(a^{-13}z\) is \(-1\).

The two `plabic_disk_maps.json` encodings each have nine interior cells,
52 black boundary vertices, one specified opposite-color interior
leaf, and 105 graph vertices in total. The code produces the same
encoding for every member of the general family.

From the campaign directory, with Python and SymPy available, run:

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python research/refinement_obstruction.py --check research/tree_surgery.json
/home/argustest/zimo/argus-live-update/.venv/bin/python research/plabic_realization.py --check research/plabic_disk_maps.json
```

The mathematical replay uses no NetworkX. It checks the stored data
against fresh exact arithmetic, not just a stored success flag.
Independent subset enumeration of the core at all eight roots and of
the nine-vertex pair agrees with the parent-count dynamic program.
Direct leaf-skein evaluation agrees with the transformed refinement.
The rational point-count recurrence is independently evaluated with
base \(R_{P_1}=q-1+q/(q-1)\) and leaf rule
\(R_F=(q-1)R_{F-v}+qR_{F-\{u,v\}}\).
The certificate includes each root polynomial and the exact recursive
state DAG. The universal identity is checked symbolically; additional
small-host and all-word samples are implementation checks, not the
proof of the theorem.

Jacobian discovery and typed inspection preceded custom finite search.
The bounded operation `graph.polynomial.independence.compute` on
\(P_4\) returned \(1+4x+3x^2\), eight independent sets, adapter exit zero.
Its exact payload and typed response, including server version 0.14.0
and protocol 2025-11-25, are in `jacobian/path4-independence.*.json`.
That computation checks conventions only; it is not evidence for the
infinite-family assertion.

## Known inputs, improvement, and originality boundary

The source assumptions in `MATH_STATE.json` identify the precise
versioned propositions, not merely the papers:

- Galashin--Lam, arXiv:2208.01175v1, Proposition 5.8 supplies (1) for
  \(R\). Conjecture 2.8 and Theorem 2.9 compare the normalized **top**
  \(a\)-degree term, and are not refuted here.
- Schwartz, arXiv:2410.00399v2, Proposition 2.1 supplies the tree
  realization baseline; Definition 3.1 supplies the forest skein
  recurrence; Lemma 4.1 supplies root invariance; Theorems 3.11 and 4.6
  identify the link polynomial and parent-count formula; Corollary 4.12
  identifies the matching slice.
  Section 2.1, Figure 5(ii), supplies the non-reduced criterion.

The earlier searches of Bencs, arXiv:1703.05409, Lemma 2.1, Theorems
2.3/2.5 and Proposition 2.7; Leake--Ryder, arXiv:1610.00805v4,
Theorems 4.1/4.7; and Hibi--Kara--Vien, arXiv:2604.18824v1,
Lemma 1.9 are retained, not repeated. Their ratio, divisibility, and
symmetric-gluing constructions were not verified to contain this
core or (7), and are not proof dependencies. Levit--Mandrescu's 2005
survey, Section 5, Figure 8 (PDF page 15 / printed page 245),
<http://www.yaroslavvb.com/papers/levit-independence.pdf>, displays a
different ten-vertex independence-equivalent pair. The unsupported
earlier attribution of this eight-vertex rooted core to that figure
remains excluded.

### Strongest rooted-replacement and coalescence comparison

The focused comparison obtained three more directly relevant primary sources:

| Source and locator | Hypotheses and strongest relevant statement | Exact overlap and limitation |
| --- | --- | --- |
| B.-X. Zhu, arXiv:1309.7673v1, Corollary 1.3 and Section 2 | For a finite simple base graph \(B\) of order \(n\) and a rooted graph \((T,t)\), the rooted-product independence polynomial is \(I_{T-t}(x)^n I_B(xI_{T-N[t]}(x)/I_{T-t}(x))\). | The independent-set selection proof gives the same formula with different rooted pieces at different sites. Equality of both root states explains every independence equality in our family. |
| S. Wagner and H. Wang, *Indistinguishable Trees and Graphs*, DOI:10.1007/s00373-013-1360-6, Theorem 3.1, its matching-count proof, and Remark 2 | The theorem's pseudo-twin hypothesis is \(G-v\cong G-w\), with \(v,w\) in different automorphism orbits. Coalescence at either vertex preserves matching and independent-set counts, among other invariants. The proof's coalescence counting identity holds for arbitrary finite rooted graphs. | Our deletion forests have different component orders, so the theorem's preservation hypothesis fails. Its general matching identity nevertheless implies our matching defect and the linear fiber bound. |
| X. Wang and K. Yeats, arXiv:1811.12344v3, Section 7, Lemma 7.2 | Characteristic-polynomial coalescence is determined by the whole graph and root-deleted graph. Rooted cospectral replacement requires both characteristic polynomials to agree. | Our root-deleted characteristic polynomials differ by \(-\lambda\). Thus rooted cospectral preservation does not apply, although the same coalescence mechanism computes a difference. |
| L. Traldi, arXiv:0808.1888v4, Theorems 13, 20 and Definition 18 | For a weighted simple graph with an unweighted, unlooped marker, Cunningham composition is determined by two weights for the full interlace polynomial. A pendant marker converts this composition to ordinary rooted coalescence. | The full transfer gives (17), not merely its independence or matching specialization. Substituting the reviewed core deletion defect gives (7) exactly, as shown in (17a)--(17b) below. |

The accessible Wagner--Wang author manuscript is
<http://math.sun.ac.za/swagner/indistinguishable.pdf>; its Theorem 3.1
proof and Remark 2 are on manuscript pages 10--11. The completed
Host-invoked publication review independently confirmed the rooted-product,
matching, and spectral comparison assumptions. The Traldi primary reading
was subsequently independently confirmed as `TRALDI20` in
`CJOINTCOMPARE`; its exact excerpt is
`literature/reviewer-traldi-composition-excerpt.txt`. These settled source
readings are reused, not sent through another unchanged lookup.

Here is the precise reduction of the quantitative claim to standard
matching coalescence. For arbitrary finite rooted graphs, grouping the
matching-count identity in Wagner--Wang's proof into generating functions gives
\[
 M_{H\cdot Q_t}
 =M_HM_{Q-t}+M_{H-h}M_Q-M_{H-h}M_{Q-t}.                 \tag{15}
\]
A matching in the coalescence cannot use an edge incident to the root
on both sides. Count those using no such edge on one side or on the
other, then subtract those using none on either side. This proves
(15) without the pseudo-twin hypothesis.
Using the already reviewed \(M_{Q-s}-M_{Q-r}=x^3\) gives
\[
 M_{H\cdot Q_r}-M_{H\cdot Q_s}
 =-x^3(M_H-M_{H-h}),\qquad
 [x^4](M_{H\cdot Q_r}-M_{H\cdot Q_s})=-\deg_H(h).        \tag{16}
\]
The last equality uses only that \([x]M_H\) is the number of edges.
Every switch in our path-decorated family has host degree two, so
the four-edge-matching count increases by two. Taking \(m+1\)
different switch counts already proves \(m+1\) distinct \(M\), hence
distinct \(C\), hence distinct full \(P\) at fixed order.
The last implication is faithful: after removing the common factor
\(a^{-N}z^N\), the substitutions \(x=z^{-2}\) and \(y=1-a^{-2}\)
are injective on \(\mathbb{Z}[x,y]\).
Neither the full defect (7) nor the chosen HOMFLY coefficient is needed
to prove this cardinality bound.

The independence side is equally standard. At site \(i\), put
\(A_i=I_{Q-t_i}\) and \(B_i=xI_{Q-N[t_i]}=I_Q-I_{Q-t_i}\).
The decorated base's polynomial is
\[
 \sum_{S\ {\rm independent\ in\ the\ base}}
       \prod_{i\notin S}A_i\prod_{i\in S}B_i,
\]
with the ordinary vertex weights at undecorated sites.
Both \(A_i\) and \(B_i\) are unchanged by our switch, as in Zhu's
rooted-product proof. Connectivity, \(8m+2\) vertices, and the
degree-four bound then follow from the specified graph gluing.

Consequently, the connected linear fiber bound is a standard-theory
corollary **once this core and its deletion data are supplied**.
This does not establish that the exact core or the resulting plabic
application was previously published. It does remove the proposed
claim that the amplification itself is a new technical mechanism.

### What the exact two-variable formula adds, and what it does not

Independence equality at \(y=1\) and matching coalescence at \(y=0\)
do not determine an arbitrary two-variable polynomial. Therefore
(7) is not logically implied by those two specializations alone.
However, the rooted-state calculation already used in its proof
gives the following four-polynomial coalescence identity:
\[
\begin{split}
 K C_{H\cdot T}
 ={}&yC_HC_T-C_HC_{T-t}-C_TC_{H-h}\\
    &+(1+xy)C_{H-h}C_{T-t}.                            \tag{17}
\end{split}
\]
Indeed, with \(D_H=C_{H-h}\) and \(D_T=C_{T-t}\), concatenating
the branch lists gives \(yC_{H\cdot T}=D_HD_T+KE_HE_T\).
Multiplying by \(K\), substituting \(KE_H=yC_H-D_H\) and
\(KE_T=yC_T-D_T\) from (8), and using \(1+K=y(1+xy)\)
proves (17) after cancelling \(y\) in the polynomial ring.
Subtract (17) at \(r,s\), insert (5), and cancel the nonzero
polynomial \(K\); the result is exactly (7).

The full law (17) is itself already a specialization of Traldi's
Theorem 20, not a newly established general coalescence result. To make
the comparison precise, use the independently reviewed forest-interlace
identification `CINTERLACE`:
\[
 \mathcal H_F(u,v)=C_F\left(u+v,\frac{v}{u+v}\right),
 \qquad \mathcal D_T=\mathcal H_{T-t}.
\]
Here \(\mathcal H_F\) is the polynomial obtained from the existing
two-variable interlace polynomial by
\(u=(s_{\rm poly}-1)^2,\ v=t_{\rm poly}-1\).
Put a new pendant marker on \(t\) in \(T\). Cunningham composition
removes that marker and the host marker \(h\), then replaces \(h\) by
\(t\); the resulting graph is \(H\cdot T\). Traldi's weights are
\[
 \alpha_T=\frac{(u+v)\mathcal D_T-v\mathcal H_T}{u-v^2},
 \qquad
 \beta_T=\frac{u\mathcal H_T-v(u+v)\mathcal D_T}{u-v^2}.
\]
Root-weight linearity gives
\(\mathcal H_{H\cdot T}=\alpha_T\mathcal H_H+
(\beta_T-\alpha_T)\mathcal D_H\).
After clearing the determinant,
\[
\begin{split}
 (u-v^2)\mathcal H_{H\cdot T}
 ={}&-v\mathcal H_H\mathcal H_T\\
 &+(u+v)\{\mathcal H_H\mathcal D_T+
 \mathcal H_T\mathcal D_H-(1+v)\mathcal D_H\mathcal D_T\}.
                                                               \tag{17a}
\end{split}
\]
Substituting \(u=x(1-y),v=xy\), with
\(u-v^2=-xK\), gives exactly (17), after cancellation of the
nonzero polynomial \(x\). This is an identity over the polynomial ring;
it does not divide by a determinant at a singular specialization.

For the already certified core, (5) becomes
\[
 \mathcal H_{Q-s}-\mathcal H_{Q-r}
       =u(u+v)(u-v^2).
\]
Subtract (17a) at its two roots. The whole-core polynomial cancels,
and this deletion defect cancels the determinant, leaving
\[
 \mathcal H_{H\cdot Q_r}-\mathcal H_{H\cdot Q_s}
 =-u(u+v)^2\{\mathcal H_H-(1+v)\mathcal D_H\}.             \tag{17b}
\]
The inverse coordinate substitution gives exactly (7). Thus the
arbitrary-host result is a factored evaluation of a published full
transfer law using the finite core data, not a consequence requiring
a new two-variable replacement principle. Formula (12) is then the
published Schwartz substitution. Its exact coefficient (11) is an
explicit refinement of the matching separation, not a different source
of the \(m+1\) cardinality bound.

One new bounded Jacobian operation,
`polynomial.multivariate.divide.compute`, divided the four-term
polynomial \(u(u+v)(u-v^2)\) by \(u-v^2\), over \(\mathbb Q[u,v]\)
in lexicographic order. It returned quotient \(u^2+uv\), remainder
zero, convention `EXACT_DIVISION_REMAINDER`, adapter exit zero, no
error or timeout, server 0.14.0, protocol 2025-11-25.
Discovery, exact contract, payload, and typed output are
`jacobian/rooted-priority.*.json`. This verifies only the new
determinant-cancellation comparison, not historical originality.
No old certificate or accepted generic transfer calculation was replayed.

For the spectral comparison, forests satisfy
\(\phi_F(\lambda)=\lambda^{|F|}M_F(-\lambda^{-2})\).
The reviewed deletion matching polynomials therefore give
\[
 \phi_{Q-r}=\lambda^7-5\lambda^5+6\lambda^3-\lambda,\qquad
 \phi_{Q-s}=\lambda^7-5\lambda^5+6\lambda^3-2\lambda.
\]
A bounded Jacobian adjacency-characteristic-polynomial operation on
the relabelled seven-vertex \(Q-s\) returned the second polynomial,
over \(\mathbb{Q}\), with adapter exit zero, no timeout, and no
structured error. The exact request, typed contract, and response
are `jacobian/root-deletion-spectrum.*.json`; server version is
0.14.0 and protocol is 2025-11-25. This checks the precise failed
rooted-cospectrality hypothesis, not originality or significance.
The reviewed point-count, skein, and disk-map certificates are unchanged.

### Schwartz's published paper and dissertation boundary

Schwartz's arXiv v2, Theorem 4.6, already supplies the full \(C\)-to-HOMFLY
translation. Section 4.2 explicitly obtains the top-\(a\) comparison
by summing the coefficients over \(j\), and Corollary 4.12 identifies
the matching/Alexander slice. Those source statements, rather than
a one-variable/two-variable type mismatch, are the comparison baseline.
The typeset IMRN article, DOI:10.1093/imrn/rnag069, again returned
HTTP 403. The accessible author research page lists that article and
arXiv:2410.00399, but does not certify that their contents are identical:
<https://sites.google.com/umich.edu/amandaschwartz/research>.

The relevant dissertation is now identified, not assumed nonexistent:
Amanda Schwartz, *Invariants of Plabic Links*, University of Michigan,
2026, DOI:10.7302/dspace/29648, handle 2027.42/202909.
Its directly accessible registration metadata is
<https://api.datacite.org/dois/10.7302/dspace/29648>.
The deposited abstract announces extensions of part of the polynomial
to some other acyclic quivers and recursive Khovanov--Rozansky
homology computations. It does not settle the three overlap questions
about rooted coalescence, independence-equivalent trees with different
HOMFLY polynomials, or an unbounded same-\(R\) family.

The official full-text bitstream exists at
<https://deepblue.lib.umich.edu/bitstreams/f9674c5b-0e08-49c3-b3b1-90a587f8bbd9/download>,
but direct retrieval returned HTTP 403. Indexed text identifies
Figure 3.22, printed page 51, as three pairs of eleven-vertex trees
with the **same** HOMFLY polynomial. This is only an indexed
figure-list entry, not a reading of that page, and it does not prove
the absence of other, relevant results. No dissertation proposition
or chapter title pertinent to (7) or the family was obtained.
The full-text overlap remains a real source-access gap.

### Revised contribution statement and publication questions

The theorem's field-level consequence is an explicit obstruction to
recovering the full HOMFLY polynomial from the normalized point count
alone, even for connected, bounded-degree tree quivers realized by
simple non-reduced plabic graphs. It supplies a closed local defect
and reconstruction ambiguities growing at least linearly with order.
It neither refutes Galashin--Lam's top-\(a\) comparison nor resolves
their different mutation-equivalence conjecture.

The correct mathematical output is a specific factored evaluation and
plabic application of known mechanisms. The proposed technical publication
basis has already been independently rejected, not merely left unreviewed:
(15)--(16) supply the separation and amplification, Traldi supplies (17a),
the finite deletion data supply (17b), and Schwartz supplies (12).
The newly explicit full-transfer comparison strengthens that diagnosis.
It does not show that the precise core or application appeared in an
earlier publication, nor rule out their usefulness in another context.
No specifically identified nonroutine advance in the presented degree-four
package has been accepted as publishable. A search miss, inaccessible
dissertation, or efficient small example cannot change that verdict.

The surviving mathematical gap is a contribution that the matching
specialization cannot already force. For example, equality of both
independence and matching polynomials with controlled separation of
the full refinement requires genuinely intermediate two-variable
information. The subsequent `joint_refinement.md` meets that mathematical
condition and has passed independent correctness review. It is a
different, stronger candidate, not evidence that this old package is
original, and its publication priority remains separately parked.

The normal Host-invoked Reviewer is asked to assess only the new
full-transfer addendum and its publication consequence:

- Do (17a)--(17b), with the cited marker hypotheses, establish the
  precise reduction of (17), (7), and (12) to the inspected full
  transfer and known translation?
- Does this addendum preserve the prior rejection of the degree-four
  package's technical publication basis? Any different acceptance
  would need an explicitly identified contribution beyond those
  reductions, not a relabelled corollary.
- Preserve unknown exact-example priority as unknown. Readable
  dissertation and final-journal bodies would still be needed to
  resolve that distinct historical question; this continuation
  obtained no new bodies and repeated no failed request.

Equations (1)--(14), both replay scripts, and both stored exact
certificates have not been changed. Their completed independent
correctness and original citation verdicts must not be relabelled as
publication approval or needlessly rebuilt. Campaign completion remains
false. The prior publication rejection is not a campaign-level
nonexistence result or permission to relabel the known-mechanism
corollary as a publishable new theorem.

The subsequent Host-invoked publication review rejected this package as
a publication basis: matching coalescence already forces the amplification,
(7) follows from (17), and (12) is the published substitution. This is a
strategy rejection, not a withdrawal of correctness or a finding that the
exact example was previously published. The ledger retires `RROOTED` for
that reason. The new candidate in `joint_refinement.md` preserves both
independence **and** matching polynomials and separates their intermediate
refinement using a compensated product switch. It gives a connected
degree-five family on \(33m+2\) vertices; its correctness and publication
status are distinct: correctness and statement fidelity have passed
independent review, while originality and publishable significance
remain uncertified because closest-source priority is unresolved.
The old matching separation is not its decisive argument.
