# Arbitrary-depth full-HOMFLY fibers among plabic knots

**Theorem (CKNOTJETFIBER).** For every pair of integers \(r,m\geq1\), set
\[
 q_r=2^{\lfloor\log_2r\rfloor},\qquad
 n(r)=\frac{98q_r(3r-2q_r)+1}{3}\leq37r^2,\qquad
 h=n(r)m+4,\qquad N=2h=2n(r)m+8.                         \tag{K1}
\]
There are explicitly constructed connected ordinary-simple trees
\(T^+_\epsilon\), indexed by \(\epsilon\in\{0,1\}^m\), on \(N\)
vertices, of maximum degree at most six. Their connected simple
non-reduced plabic realizations have **knot** links. All \(2^m\) full
two-variable HOMFLY polynomials are distinct, while sharing the entire
normalized point count, Alexander polynomial, first \(r\) normalized
top-\(a\) layers, and all derivatives of orders less than \(r\) at \(a=1\),
for normalized and full HOMFLY. The derivative of order \(r\) alone
distinguishes every word. In fact the common normalized point count is
a polynomial, and
\[
 \log_2|\text{fiber}|=m=\frac{N-8}{2n(r)}
                            \geq\frac{N-8}{74r^2}.       \tag{K2}
\]

This is an ordinary all-\(r\), all-\(m\) theorem with an exact rerunnable
delta certificate, not a finite-search inference or a formal-kernel
certificate. Its four mathematical claims are independently accepted
by `reviewer:copilot-knot-jet-review`, as recorded in the current
ledger and sealed handoff `23df2f269510/round-0001.json`.
Historical originality and publication-level significance remain
uncertified; mathematical acceptance does not complete the campaign.

## Scope and the unchanged reviewed construction

The current ledger independently supports `CFULLJETCOEFF`,
`CFULLJETSPECTRUM`, `CFULLJETDECODE`, and `CFULLJETFIBER` by
`reviewer:copilot-full-jet-scalar-review`. Use its actual trees
\[
 T_\epsilon=\operatorname{family}(r,\epsilon,\text{"path"}),
 \qquad A_\epsilon=C_{T_\epsilon},
                                                               \tag{K3}
\]
from the unchanged `polarized_jet_fibers.py`. Each has \(h\) vertices
and degree at most five. The reviewed switches start with the two
explicit 33-vertex edge lists in `joint_certificate.json`. For \(r>1\),
with \(a=\lfloor r/2\rfloor,b=\lceil r/2\rceil\), a fresh root has the
two coalesced children
\[
 S_{r,0}:(S_{a,0}\mathbin{\cdot}S_{b,0},
          S_{a,1}\mathbin{\cdot}S_{b,1}),\quad
 S_{r,1}:(S_{a,0}\mathbin{\cdot}S_{b,1},
          S_{a,1}\mathbin{\cdot}S_{b,0}).
\]
All copies are fresh and the dot identifies only the roots. Coalesce
these switches at the \(m\) internal sites of a path with \(m+2\)
vertices, then append a two-edge path at its left endpoint.
This specifies (K3) without a search or marker choice.

For every pair of words, the reviewed conclusions are
\[
 A_\epsilon-A_\eta\in y^r(y-1)^r\mathbb Z[x,y],\qquad
 \epsilon\longmapsto[y^r]A_\epsilon\text{ is injective}.   \tag{K4}
\]
We reuse these conclusions and their existing exact decoder, not a
new proof or replay of them. `CPOLARSEED`, `CPOLARDATA`, `CINTERLACE`,
and `CPLABIC` are also unchanged independently accepted inputs.

The known pendant elimination used below is Traldi,
*Weighted interlace polynomials*, `arxiv:0808.1888v4`, Section 3,
Theorem 13. Its precise weights were already independently read and
attributed under `CJOINTCOMPARE:TRALDI20`; the retained excerpt is
`literature/reviewer-traldi-composition-excerpt.txt`. We checked that
statement against the retained primary HTML. The forest interlace
identification and link normalization are the reviewed `CINTERLACE`
and `CPLABIC`, using Schwartz `arxiv:2410.00399v2`, Definition 3.1
and Theorems 3.11 and 4.6. The oriented skein normalization is already
part of `CTX20001675`, and agrees with Section 2.2, equations (2.5)
and (2.7), of that retained source. No new unproved topological
criterion or external proposition is imported below.

Pendant elimination, the endpoint corona formulas, and the transfer
mechanism are known inputs or elementary consequences, not originality
claims. Accepted certificates, citation judgements, and retired routes
are preserved. No denied source was retried, and the earlier search
claim whose DOI identifies an unrelated K-theory paper is not used.
The unread closest dissertation and final-journal bodies still limit
historical-priority assessment.

## Corona identity and injectivity (CKNOTCORONA)

For a forest \(T\) on \(h\) vertices, its corona \(T^+\) adds a new
vertex \(v'\) and edge \(vv'\) for every \(v\in V(T)\).
The executable construction labels \(v'=h+v\). Put
\[
 d=1+x,\qquad f=\frac{x(1+xy)}{d^2},\qquad
 g=\frac{yd}{1+xy}.
\]
Then
\[
 C_{T^+}(x,y)=d^h C_T(f,g).                              \tag{K5}
\]

**Proof from the reviewed pendant theorem.** Write the rank-nullity
polynomial as
\[
 H_T(u,v)=\sum_{S\subseteq V(T)}
             u^{\operatorname{rank}(S)/2}
             v^{|S|-\operatorname{rank}(S)} .
\]
For an unlooped pendant vertex with initial weights one, Theorem 13
keeps its neighbor's selected weight \(\alpha=1\) and changes its
unselected weight to \(\beta=1+u+v\). Removing all fresh leaves
changes no other neighbor's weights. With \(D=1+u+v\), this gives
\[
 H_{T^+}(u,v)
  =\sum_S D^{h-|S|}u^{\operatorname{rank}(S)/2}
                       v^{|S|-\operatorname{rank}(S)}
  =D^h H_T(u/D^2,v/D).                                  \tag{K6}
\]
Indeed \(|S|=2(\operatorname{rank}(S)/2)
+(|S|-\operatorname{rank}(S))\), which accounts for both denominators.
Use the reviewed identity
\(C_T(x,y)=H_T(x(1-y),xy)\), with inverse coordinates
\(x=u+v,y=v/(u+v)\). Then \(D=d\), \(u/D^2+v/D=f\), and
\((v/D)/(u/D^2+v/D)=g\), proving (K5).

The apparent rational expression is polynomial. A parent-count monomial
\(x^iy^j\) has \(0\leq j\leq i\) and \(2i-j\leq h\): its selected
independent \(i\)-set and its \(i-j\) distinct parents are disjoint.
Its image, including the prefactor, is
\[
 d^h f^i g^j
   =x^iy^j(1+xy)^{i-j}d^{h-2i+j}.                       \tag{K7}
\]
Both exponents on the right are nonnegative.

The substitution is injective on \(\mathbb Q[x,y]\). In
\(\mathbb Q(y)[[x]]\), \(f=x+O(x^2)\), \(g=y+O(x)\), and \(d^h=1+O(x)\).
If a nonzero polynomial has first \(x\)-term \(x^k p(y)\), its
image has the same first term \(x^k p(y)\). Thus it cannot vanish.
This proves injectivity, rather than assuming it from a nonzero
Jacobian determinant.

At the endpoints, (K5) gives the required entire-polynomial formulas
\[
 I_{T^+}(x)=d^h I_T(x/d),\qquad
 M_{T^+}(x)=d^h M_T(x/d^2).                              \tag{K8}
\]
There are also direct combinatorial checks: selecting an independent
\(i\)-set of original vertices leaves \(h-i\) freely selectable leaves;
selecting \(i\) original matching edges leaves \(h-2i\) freely selectable
leaf edges. These give the two sums in (K8).

## Endpoint jets and the omitted coefficient (CKNOTJETS)

Let \(\Delta=C_T-C_U\) for equal-order forests, and assume
\(y^r(y-1)^r\mid\Delta\). The exact identities
\[
 g=\frac{yd}{1+xy},\qquad
 g-1=\frac{y-1}{1+xy}                                    \tag{K9}
\]
show that the lifted difference \(\Delta^+=d^h\Delta(f,g)\)
is divisible by \(y^r(y-1)^r\) in the localization at \(d(1+xy)\).
It is an actual polynomial by (K5). Neither denominator has a factor
\(y\) or \(y-1\); these prime factors therefore survive cancellation,
proving divisibility in \(\mathbb Z[x,y]\) itself.

If all coefficients below \(y^r\) in \(\Delta\) vanish, expansion at
\(y=0\) in \(\mathbb Q(x)[[y]]\) gives
\[
 [y^r]\Delta^+
    =d^{h+r}([y^r]\Delta)(x/d^2).                        \tag{K10}
\]
Only the original coefficient of order \(r\) contributes:
\(g=dy+O(y^2)\) and \(f=x/d^2+O(y)\).
The transformation \(p(x)\mapsto d^{h+r}p(x/d^2)\) is injective,
since \(x/d^2=x+O(x^2)\) and the prefactor is an \(x\)-adic unit.
Thus (K4) implies injectivity of \(\epsilon\mapsto[y^r]C_{T^+_\epsilon}\).

For completeness, if the original first coefficient at \(y=1\) has
order \(k\), the corresponding lifted coefficient is
\[
 [(y-1)^k]\Delta^+
     =d^{h-k}([(y-1)^k]\Delta)(x/d).                    \tag{K11}
\]
Here \(g-1=(y-1)/d+O((y-1)^2)\). The substitution \(x/d\) is also
injective. Thus either endpoint's actual vanishing order is preserved;
we do not assert that every pair is distinguished by its first omitted
top-\(a\) layer.

At common order \(N=2h\), the reviewed full polynomial is
\[
 P^+_\epsilon(a,z)=a^{-N}z^N
          C_{T^+_\epsilon}(z^{-2},1-a^{-2}).             \tag{K12}
\]
With \(t=a^{-2}\), the normalized differences are divisible by
\(t^r(1-t)^r\), proving equality of their first \(r\) top layers.
Since \(1-a^{-2}=2(a-1)+O((a-1)^2)\), all derivatives below order
\(r\) agree for both normalizations, whereas
\[
 \left.\partial_a^r(P^+_\epsilon-P^+_\eta)\right|_{a=1}
  =r!\,2^r z^{2h}(1+z^{-2})^{h+r}
       ([y^r](A_\epsilon-A_\eta))
          \left(\frac{z^{-2}}{(1+z^{-2})^2}\right).       \tag{K13}
\]
This is nonzero for distinct words by (K10) and injectivity of
substitution \(x=z^{-2}\). It proves the requested first omitted
derivative statement, not just distinct full polynomials.

An exact decoder is inherited without solving a new spectral problem.
The reviewed insertion polynomials \(f_i\) in (F28) satisfy
\(H_0-H_\epsilon=\sum_i\epsilon_i f_i\), where
\(H_\epsilon=[y^r]A_\epsilon\), and are rationally linearly independent.
Replace each column by
\[
 f_i^+(x)=d^{h+r} f_i(x/d^2).
\]
These columns remain independent by (K10). Use the actual lifted
zero-word coefficient as reference, equate all \(x\)-coefficients,
and solve the full-rank rational system. Reconstructing the entire
input coefficient, rather than only pivot equations, recovers every word.

## Knotness from the skein relation (CKNOTNESS)

Every fresh leaf has its original vertex as its only neighbor. Any
perfect matching of \(T^+\) must therefore contain every \(vv'\).
These \(h\) edges are disjoint and cover all \(2h\) vertices, proving
existence and uniqueness. Consequently \(M_{T^+}\) has degree \(h\)
with coefficient one at \(x^h\), and
\[
 \nabla_{L^+}(z)=P^+(1,z)=z^{2h}M_{T^+}(z^{-2})
    =(1+z^2)^h M_T\left(\frac{z^2}{(1+z^2)^2}\right)     \tag{K14}
\]
has constant coefficient one. The last expression is polynomial:
an original matching of size \(i\) contributes
\(z^{2i}(1+z^2)^{h-2i}\).

Here is the topological implication, with no assumed matching criterion.
The oriented normalization gives
\(\nabla_{L_+}-\nabla_{L_-}=z\nabla_{L_0}\) and
\(\nabla_{\text{unknot}}=1\). Apply this relation to a Reidemeister-I
curl on one component of an unlink. The positive and negative diagrams
are isotopic to that unlink, and their oriented smoothing adds a
split trivial component. Hence every unlink with at least two
components has Conway polynomial zero, by cancellation of the
nonzero Laurent polynomial \(z\).

Induct on the number of crossings to show both that \(\nabla_L\)
is a polynomial in \(z\) and that its constant is one for a knot,
zero for a multi-component link. The crossing-free case is the unlink
case just proved. Order the components and choose a basepoint on each.
Change crossings so that an earlier component always passes over a
later one, and on each component the first encounter with a crossing
is the overpass. This descending diagram is an unlink: successively
lift the traversed arcs, starting at each basepoint, to remove their
crossings and separate the ordered components. The changes do not
change the number of components. At every changed crossing its
oriented smoothing has fewer crossings, so its Conway polynomial
is a polynomial by induction. Telescoping the skein relation
expresses \(\nabla_L-\nabla_{\text{unlink}}\) as \(z\) times a sum
of such polynomials. This proves polynomiality and equality of
constants, completing the induction. Thus the nonzero constant in
(K14) forces the realized link to have exactly one component.

This proof does not equate knotness with a matrix-rank criterion or
infer topology from a numerical computation.

## Point counts, realizations, and the subclass improvement

With \(S=q^2-q+1\), (K8) gives the entire normalized count
\[
 R_{T^+}(q)=(q-1)^{2h}
      I_{T^+}\left(\frac{q}{(q-1)^2}\right)
       =S^h I_T(q/S)\in\mathbb Z[q].                    \tag{K15}
\]
The last expression is polynomial because \(\deg I_T\leq h\).
The common original \(I_T\) and \(M_T\) imply equality of (K15)
and (K14) for all words, hence also equality of their Alexander
polynomials in the usual variable. This is the reviewed normalized
quiver count, not a relabelled unnormalized variety-count polynomial.

The corona preserves tree connectivity and ordinary simplicity.
Old degrees increase by one and new degrees are one, giving the
degree-six bound and the exact order (K1). Apply the unchanged
`CPLABIC` construction to each new tree. It supplies \(N\) interior
faces, \(6N-2\) black degree-one boundary vertices, a specified cyclic
disk map, the tree quiver, and an opposite-color interior leaf with
neighbor degree at least four certifying non-reducedness.
Connectedness supplies the forest-link identification hypothesis;
(K14) then proves these actual plabic links are knots. The degree
bound is on the tree quiver, not on the disk graph. No
non-alternating or mutation-equivalence assertion is added.

The strongest accepted unrestricted-link result has \(2^m\) values
on \(h=n(r)m+4\) vertices and rate \(1/(37r^2)\).
The present result guarantees knot links, with doubled order, degree
increased from five to six, and rate \(1/(74r^2)\). It is a
subclass improvement, not an improvement over that accepted rate.
The accepted depth-one rate \(1/33\) for unrestricted links is unchanged.

## Exact delta replay and its scope

```sh
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python research/knot_jet_fibers.py --check research/knot_jet_fibers.json
```

The new certificate checks the generic coordinate, weight, endpoint,
Laurent, and count identities exactly. Small forests compare the entire
lifted refinement with both the independent parent-count recurrence
and exhaustive induced-subset adjacency ranks. Actual depth-one knots
carry full sparse HOMFLY polynomials and exact leaf skein/count checks.
New corona graphs check complete independence/matching polynomials,
forced perfect matchings, all-\(x\) Taylor jets at both endpoints, the
omitted-coefficient identity, and exact word decoding. New disk maps
use the unchanged reviewed realization algorithm on new inputs.
All enumerations and Taylor depths are bounded implementation checks;
(K5)--(K15) and the accepted all-parameter input prove the quantifiers.
No unchanged reviewed certificate program is invoked.

The durable Engineer run exited zero in 63.4 seconds and persisted
3,176,252 bytes with exact JSON readback. All 186 residuals are zero:
38 generic or typed identities, 30 small-forest checks, 20 explicit
full-knot checks, 39 all-\(x\) endpoint checks, 54 word/decoder checks,
and five structural checks. The decoder recovers all 24 enumerated
words at \((r,m)=(1,2),(2,1),(2,2),(2,3),(3,1),(3,2)\).
Actual corona graphs on 74, 270, and 662 vertices agree with the
complete-\(x\) Taylor substitution through orders one, two, and three
at \(y=0\), and have equal lower jets at both endpoints.
Their entire independence/matching polynomials are checked independently.
Actual structural samples have orders 140, 532, 1316, 1838, and 2622,
all with maximum degree six and the explicit forced perfect matching.

The two complete 74-vertex examples include full sparse HOMFLY
polynomials and exact leaf skein/count certificates. Their omitted
coefficient difference starts with \(-x^6\), so
\([z^{62}]\left.\partial_a(P^+_0-P^+_1)\right|_{a=1}=-2\).
Equal-weight words \(01,10\) have lifted order-\(r\) coefficient
differences beginning \(8x^{17}\) at \((r,N)=(2,532)\) and
\(32x^{25}\) at \((3,1316)\), exercising positional decoding rather
than word weight alone. These remain bounded implementation checks;
the universal theorem is the proof above and its accepted input.
This run is Engineer evidence, not independent acceptance.

Jacobian discovery and exact-contract inspection preceded custom
certificate code. One bounded
`matrix.symbolic.determinant.compute` operation evaluated the
cleared Jacobian numerator matrix of
\((u,v)\mapsto(u/(1+u+v)^2,v/(1+u+v))\):
\[
 \det\begin{pmatrix}1-u+v&-2u\\-v&1+u\end{pmatrix}
       =(1-u)(1+u+v).
\]
The retained exact payload and complete typed `SYMPY_BAREISS` output
have server version 0.14.0, protocol 2025-11-25, adapter exit zero,
no timeout, and no structured error, in dedicated
`jacobian/knot-jet-*.json` files. This supplies a determinant only,
not a theorem or injectivity verdict. The \(x\)-adic argument above
proves injectivity independently.

`CKNOTCORONA`, `CKNOTJETS`, `CKNOTNESS`, and `CKNOTJETFIBER`
have independent mathematical acceptance. Their statements, proof
identities, and certificates are unchanged by the comparison below;
no accepted certificate is replayed this cycle. Mathematical
acceptance and structural ledger checks do not certify historical
originality or publication significance.

## Publication comparison: known endpoints, candidate finite-jet core

The publication candidate is the simultaneous arbitrary-depth
non-recovery theorem and uniform first-omitted-coefficient decoder
stated in `full_jet_scalar_fibers.md`, restricted here to knots.
It is not the corona substitution, forced matching, or familiar
Conway/Alexander conversion taken separately. The unrestricted
degree-five bound is \((N-4)/(37r^2)\); the degree-six knot bound
is \((N-8)/(74r^2)\). The latter adds knotness, not a rate improvement.
Neither result contradicts Galashin--Lam's published top-\(a\)
comparison.

The complete author-hosted Stoimenow plumbing manuscript has now been
read. Its Lemma 4.1 gives the already known matching endpoint
\(\nabla_{L(G)}(z)=z^{|G|}M_G(z^{-2})\) for a tree of ordinary
positive Hopf bands. Its independence polynomial is that of
the **line graph**, not \(I_G\) of the tree quiver. Its
Corollary 5.2 gives coefficient-shape inequalities for alternating
tree plumbing links, not finite-jet families or a full HOMFLY decoder.
The actual source, version limits, and exact hypotheses are recorded
in `full_jet_scalar_fibers.md` and
`literature/stoimenow-plumbing-excerpt.txt`. No topological
identification with a plumbing link is added to this proof.

The endpoint overlap can be made explicit without claiming a new
surgery formula. In the Alexander variable \(t\), set
\[
 S(t)=t^2-t+1,\qquad u=t/S(t),\qquad
 v=t(t-1)^2/S(t)^2=u(1-u).
 \tag{K16}
\]
The known conversion \(z^2=(t-1)^2/t\), applied to (K14), yields
\[
 \Delta_{T^+}(t)=(S(t)/t)^h M_T(v)
                  =u^{-h}M_T(u(1-u)),\qquad
 R_{T^+}(t)=S(t)^h I_T(u).
 \tag{K17}
\]
These are rational identities with the existing normalizations.
Their shared cyclotomic factor does not identify \(I_T\) with \(M_T\),
and neither one-variable expression reconstructs the omitted
two-variable coefficient. They illustrate the inherited endpoint
mechanism rather than supplying a publication contribution.

The source-comparison cycle's dedicated Jacobian payload names this
dummy variable \(q\) and returns the exact identity
\[
 \operatorname{Res}_q\bigl(uS(q)-q,\,
                 vS(q)^2-q(q-1)^2\bigr)=(u^2-u+v)^2.
 \tag{K18}
\]
Discovery and exact-contract inspection preceded this one bounded
`polynomial.multivariate.resultant.compute` operation. Server 0.14.0,
protocol 2025-11-25 returned a complete typed
`SYLVESTER_DETERMINANT` result, runtime 19 ms, adapter exit zero,
no timeout, and no structured error. The exact payload, output,
inspection, discovery, and status are in dedicated
`literature/jet-publication-jacobian-*.json` files.
This concerns the cleared endpoint-coordinate comparison only; it is
not an all-depth proof, a knotness test, or originality evidence.

The new full-text lookup obtained neither Schwartz's 2026
dissertation nor the final IMRN article, and no provenance-verified
equivalent. Detailed results are appended to the existing
`literature/cited_propositions.txt`; no previously denied endpoint
was retried. Historical overlap with those closest bodies is still
unknown. The uniform theorem remains independently accepted, but
publishable certification is blocked on that source gap and
independent originality/significance assessment.
