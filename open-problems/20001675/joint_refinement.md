# Intermediate forest refinement beyond point counts and Alexander data

The previous obstruction in `rooted_obstruction.md` remains correct but was
rejected as a publication basis: matching coalescence already forces its
separation. The present route requires equality of both endpoint invariants,
not another example distinguished by matching counts. No novelty or
publication-level verdict is asserted in this note.

## The full invariant is an interlace polynomial

For a forest \(F\), let
\[
 H_F(u,v)=\sum_{A\subseteq V(F)}
       u^{r(A)/2}v^{|A|-r(A)},
 \qquad r(A)=\operatorname{rank}_{\mathbb F_2} A(F[A]).
                                                               \tag{18}
\]
The adjacency matrix of a loopless graph is alternating in characteristic
two, so its rank is even. This is Arratia--Bollobas--Sorkin's two-variable
interlace polynomial in coordinates
\[
 q(F;s,t)=H_F((s-1)^2,t-1).
                                                               \tag{19}
\]
Here \(q(F;s,t)\) is an interlace polynomial, not the finite-field point-count
variable in \(R_F(q)\).

**Proposition.** The full Schwartz refinement satisfies
\[
 C_F(x,y)=H_F(x(1-y),xy),\qquad
 H_F(u,v)=C_F\left(u+v,\frac{v}{u+v}\right).
                                                               \tag{20}
\]
The inverse expression simplifies to a polynomial. In particular
\[
 I_F(x)=H_F(0,x),\qquad M_F(x)=H_F(x,0).
                                                               \tag{21}
\]
Thus the new target is to preserve both axis restrictions of \(H_F\) while
changing its mixed coefficients.

**Proof.** Let \(b\) be a leaf with neighbor \(a\). Partition the vertex
subsets in (18) according to whether they contain \(b\), and then \(a\).
Subsets omitting \(b\) contribute \(H_{F-b}\). Subsets containing \(b\)
but not \(a\) have an isolated selected vertex, contributing
\(vH_{F-a-b}\). For subsets containing both, eliminate the adjacency
matrix's leaf-neighbor block. Its matrix is
\(\begin{pmatrix}0&1\\1&0\end{pmatrix}\); symmetric row/column elimination
shows that it contributes rank two and leaves the residual adjacency
matrix on the other selected vertices. Nullity is unchanged, so these
subsets contribute \(uH_{F-a-b}\). Consequently
\[
 H_F=H_{F-b}+(u+v)H_{F-a-b},\qquad H_{P_1}=1+v.
                                                               \tag{22}
\]
The invariant is multiplicative on components. Substituting
\((u,v)=(x(1-y),xy)\) gives the reviewed leaf recurrence
\(C_F=C_{F-b}+xC_{F-a-b}\), with singleton \(1+xy\).
Induction proves the first equality in (20); the rational inverse
substitution proves the second. Equation (21) follows.

This identification is a comparison with an existing invariant, not a
claim that a reparametrization is itself a new theorem.

## Exact source baseline

Arratia, Bollobas, and Sorkin, *A Two-Variable Interlace Polynomial*,
arXiv:math/0209054v3 (13 August 2004), equation (1), defines the rank-nullity
polynomial over \(\mathbb F_2\). Theorem 3, Proposition 9, and Corollary 7
give the pivot recurrence, disjoint-union product, and edgeless initial
values. The direct rank argument above proves the needed leaf case
without requiring a convention-dependent pivot calculation.

Anderson, Cutler, Radcliffe, and Traldi, *On the interlace polynomials of
forests*, DOI:10.1016/j.disc.2009.07.027, has a related earlier-sibling-cover
formula. In the 17 July 2009 author manuscript
<https://sites.lafayette.edu/traldil/files/2010/06/escovrev2.pdf>,
Definitions 3--4 and Theorems 5--6 give root/order independence and
\[
 q(T;s,t)=\sum_{i,j}e_{i,j}(T)
       t^{i-j}\bigl(t-1+(s-1)^2\bigr)^j.
                                                               \tag{23}
\]
The counts \(e_{i,j}\) in (23) are earlier-sibling-cover counts, not
Schwartz's parent-count coefficients \(c_{i,j}\).
Under (20), (23) becomes
\(C_T(x,y)=\sum e_{i,j}(T)(1+xy)^{i-j}x^j\).
The paper's Figure 3 example preserves the vertex-nullity specialization
but has different independent-set sizes, so it does not supply the
joint-endpoint separation sought here.

The bounded primary-source lookup did not verify a theorem that the two
axis restrictions determine \(H_F\), or a published connected
joint-endpoint-separating family. Neither observation establishes
originality. The exact interlace antecedent must be included in any
subsequent publication comparison.

## A product switch that preserves both endpoints

Put \(K=y-1+xy^2\). For a rooted tree \((T,t)\), write
\[
 D_t=C_{T-t},\qquad
 E_t=(yC_T-D_t)/K,\qquad
 F_t=(D_t-E_t)/y.
                                                               \tag{24}
\]
These are polynomials: \(E_t\) is the product of root-excluded child
states, and the numerator defining \(F_t\) counts configurations with
at least one selected child root. The rooted recurrence gives
\[
 C_T=(1+xy)E_t+F_t,\quad D_t=E_t+yF_t,\quad
 C_{H\cdot T_t}=E_tC_H+F_tC_{H-h}.                              \tag{25}
\]
Here the dot identifies the two marked vertices.

**Product-switch lemma.** Let \(A,B\) be trees with marked vertices
\(r,s\) in \(A\) and \(u,v\) in \(B\). Set
\(\delta_A=C_{A-r}-C_{A-s}\) and
\(\delta_B=C_{B-u}-C_{B-v}\).
Form a rooted tree \(S_0\) by joining a new root \(z\) by two edges to
the identified roots of \(A_r\cdot B_u\) and \(A_s\cdot B_v\), using
disjoint copies. In \(S_1\), use \(A_s\cdot B_u\) and \(A_r\cdot B_v\)
instead. Then
\[
 C_{S_0}-C_{S_1}
 =C_{S_0-z}-C_{S_1-z}
 =D:=\frac{C_AC_B\delta_A\delta_B}{K}.                          \tag{26}
\]
Each deletion difference \(\delta\) is divisible by \(K\), so the
display is a polynomial identity. If \(\delta_A(x,1)=0\) and
\(\delta_B(x,0)=0\), the two rooted pieces have equal whole and
root-deleted independence **and** matching polynomials.

**Proof.** From (24), \(\delta_A=-K(E_r-E_s)\), and similarly for \(B\).
In particular \(E_rF_s-E_sF_r=-C_A\delta_A/K\).
For the coalescence \(W=A_t\cdot B_b\),
\[
 C_W=E_tC_B+F_tD_b,\qquad
 O_W:=C_W-xyE_tE_b=E_tO_b+F_tD_b,
\]
where \(O_b=C_B-xyE_b\) is the root-excluded state.
Deleting \(z\) in \(S_i\) gives the product of the two \(C_W\)'s.
Taking its two-by-two determinant yields
\[
 C_{S_0-z}-C_{S_1-z}=C_AC_B\delta_A\delta_B/K.
 \]
The difference of the products of the two \(O_W\)'s is
\(D(y-1)/K\), since
\[
 O_uD_v-D_uO_v=-C_B\delta_B(y-1)/K.
\]
At the new root, \(yC_{S_i}=C_{S_i-z}+K E_{S_i}\).
Thus \(y(C_{S_0}-C_{S_1})=D+K D(y-1)/K=yD\),
proving (26). These calculations may be performed in the rational
function field and then read as polynomial identities; no specialization
at a zero of a denominator is used. At \(y=1\), \(K=x\) is nonzero
in \(\mathbb Z[x]\), and at \(y=0\), \(K=-1\); the asserted endpoint
equalities follow.

This lemma combines two different endpoint cancellations. Unlike the
previous route, the resulting separation cannot be inferred from unequal
matching counts.

## Explicit atoms and the 33-vertex rooted pair

Use the reviewed eight-vertex tree \(A\) with edges
\[
 01,\ 05,\ 12,\ 14,\ 23,\ 56,\ 67,\qquad r=2,\ s=5.
\]
Use the nine-vertex tree \(B\) with edges
\[
 01,\ 05,\ 12,\ 23,\ 34,\ 56,\ 58,\ 67,\qquad u=1,\ v=6.
\]
The second tree is the spider with arm lengths \(1,2,5\), centered at
vertex 5. Exact leaf recurrence gives
\[
 \delta_A=-x^3(y-1)K,\qquad
 \delta_B=x^3y(x+1)K.                                         \tag{27}
\]
The first identity is the previously reviewed atom; its use here does
not revive the rejected matching-separation route. The second identity
is a different, matching-invisible root switch. Its endpoint data are
\[
\begin{aligned}
 I_{B-u}&=1+8x+22x^2+25x^3+12x^4+2x^5,\\
 I_{B-v}&=1+8x+22x^2+25x^3+11x^4+x^5,\\
 M_{B-u}&=M_{B-v}=1+6x+10x^2+4x^3.
\end{aligned}
\]
Thus the atoms cancel at opposite endpoints. Neither individual switch
alone supplies the new obstruction.

The pieces \(S_0,S_1\) in the lemma have 33 vertices and root degree two.
Their maximum degree is five. Equations (26)--(27) give
\[
 D=-x^6y(y-1)(x+1)K C_AC_B.                                  \tag{28}
\]
This is nonzero but vanishes at both \(y=0\) and \(y=1\).
The whole and deleted rooted endpoint states agree exactly, not merely
their totals at a numerical value.

For **every** rooted tree host \((H,h)\), (25)--(26) give the full defect
\[
 C_{H\cdot S_0}-C_{H\cdot S_1}
 =-x^6y(y-1)(x+1)C_AC_B
       \bigl((y-1)C_H+xyC_{H-h}\bigr).                        \tag{29}
\]
There are no restrictions on host size or root degree. All terms below
\(x^6\) vanish, and the \(x^6\)-coefficient is
\[
 -y(y-1)^2.                                                  \tag{30}
\]
In particular the separation is nonzero even for an isolated host root.
Both endpoint invariants remain equal for every host.

Equivalently, the exact full two-variable HOMFLY defect is
\[
\begin{split}
 P_{H\cdot S_0}-P_{H\cdot S_1}
 ={}&a^{-18}(z^2+1)(1-a^{-2})P_AP_B\\
 &\quad\cdot\bigl((1-a^{-2})P_{H-h}-a^{-1}zP_H\bigr).
\end{split}                                                     \tag{30a}
\]
As in the reviewed forest convention, \(P_{H-h}\) is multiplicative
on forest components, not the polynomial of a disjoint link union.
For the isolated host root this becomes
\[
 P_{S_0}-P_{S_1}
 =a^{-18}(z^2+1)(1-a^{-2})
       \bigl((1-a^{-2})^2-a^{-2}z^2\bigr)P_AP_B.                \tag{30b}
\]
The factor \(1-a^{-2}\) explicitly removes the Alexander difference;
the different top-\(a\) normalization is already accounted for by (28).

The bounded Jacobian operation `graph.polynomial.matching.compute` on
the relabelled \(B-v=P_7\sqcup P_1\) returned
\(\lambda^8-6\lambda^6+10\lambda^4-4\lambda^2\).
This operation uses the signed characteristic matching convention,
not the unsigned generating convention of \(M\).
The forest relation
\(\mu_F(\lambda)=\lambda^{|F|}M_F(-\lambda^{-2})\)
recovers \(1+6x+10x^2+4x^3\).
The exact discovery, typed contract, payload, and response are
`jacobian/joint-matching.*.json`; server 0.14.0, protocol 2025-11-25,
adapter exit zero, no timeout, no structured error. This bounded atom
check is not proof of the family or of novelty.

## A connected family invisible to both point counts and Alexander

**Candidate theorem.** For every \(m\geq1\), there are connected trees
\(U_{m,\epsilon}\), \(\epsilon\in\{0,1\}^m\), on
\(N=33m+2\) vertices, of maximum degree at most five, such that:

1. Both \(I_{U_{m,\epsilon}}\) and \(M_{U_{m,\epsilon}}\) are independent
   of \(\epsilon\). Hence their normalized quiver point counts and
   Alexander polynomials are identical.
2. There is an integer \(b_m\), independent of \(\epsilon\), with
   \[
   [a^{-(N+4)}z^{N-12}]P_{U_{m,\epsilon}}=b_m+|\epsilon|.
                                                               \tag{31}
   \]
   In particular the joint point-count/Alexander invariant has a fiber
   containing at least \(m+1\) different full HOMFLY polynomials.
3. Every family member has the explicit connected simple non-reduced
   plabic realization previously proved in `rooted_obstruction.md`.

**Proof.** Start with a path on vertices \(v_0,\ldots,v_{m+1}\) and
identify the root of \(S_{\epsilon_i}\) with \(v_i\) at each internal
site. This is a tree, adds 32 vertices per site, and has \(33m+2\)
vertices. The new path-site degrees are four; the other degrees are
at most five.

The two rooted endpoint states are identical by (26)--(28).
The usual independence and matching coalescence identities therefore
preserve both endpoint polynomials at each replacement, irrespective
of the other sites. This part is standard rooted replacement and is
not claimed as a new method.

For one replacement, remove the 32 non-root vertices at that site;
the rest is a connected rooted host, regardless of the other bits.
Equation (30) shows that the change from bit zero to bit one has
\(x^6\)-coefficient \(y(y-1)^2\). Under Schwartz's full substitution,
\[
 y(y-1)^2\big|_{y=1-a^{-2}}=a^{-4}-a^{-6}.
\]
The coefficient in (31) therefore increases by exactly one. Terms
of other \(x\)-degrees have other \(z\)-degrees, so they cannot affect
this coefficient. Telescoping gives (31) for every \(m\).
Taking switch counts \(0,\ldots,m\) proves the stated fiber bound.
The general polygon-cell realization and forbidden boundary-face leaf
apply to each input tree without changing the quiver or its invariant.

The result is an unbounded sequence of finite fibers as \(m\) varies,
not an infinite fiber of a fixed rational function, and does not
assert that all \(2^m\) words are distinct.

## Exact replay and contribution boundary

The independently rerunnable new certificate is
`joint_certificate.json`, checked by

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python research/joint_refinement.py --check research/joint_certificate.json
```

The program independently enumerates independent sets of both atoms at
every root, enumerates their induced-subset adjacency ranks over
\(\mathbb F_2\), evaluates the new pair by an integer parent-count
program and a separate leaf recurrence, and evaluates the HOMFLY
skein recurrence directly in Laurent variables. It also checks the
point-count recurrence in the polynomial numerator
\[
 S_F(q)=(q-1)^{|F|}R_F(q),\quad
 S_{P_1}=q^2-q+1,\quad
 S_F=(q-1)^2S_{F-b}+q(q-1)^2S_{F-a-b}.
\]
The result agrees with the independence substitution, without comparing
floating-point evaluations. The stored certificate contains both
33-vertex edge lists, all four equal rooted endpoint vectors, full
refinements and HOMFLY polynomials, point-count numerators, leaf-state
DAGs, and new explicit disk maps. Small-host and \(m=1,2\) samples
check the implementation; (26)--(31), not those samples, prove the
unbounded family. The old reviewed certificate files and code are unchanged.

The mathematical improvement over the rejected theorem is precise:
the old family changes the four-edge-matching count, whereas the new
family preserves the **entire** matching polynomial and Alexander
polynomial. Its separation lies in mixed rank-nullity coefficients
of the full interlace polynomial. It shows that adding Alexander data
to normalized point counts still does not recover full forest-quiver
HOMFLY, within connected bounded-degree simple non-reduced realizations.
The stronger equality costs \(33m+2\) rather than \(8m+2\) vertices and
degree five rather than four; it is not an improved size bound for the
old single-invariant problem.

## Primary-source contribution comparison

The independent review recorded in `roles/reviewer/progress.json`
accepts the mathematics and statement fidelity of (18)--(31), including
a fresh replay of the unchanged certificate. It does not accept
historical novelty or publication significance. The following comparison
separates that remaining question from correctness.

| Inspected primary statement | Hypotheses and strongest relevant conclusion | Boundary of the present contribution |
| --- | --- | --- |
| Traldi, `arxiv:0808.1888v4`, Definition 18 and Theorems 13, 20 | Weighted simple graph with an unweighted, unlooped marker; Cunningham composition deletes the marker and joins the two neighbor sets. A whole-graph and marker-deleted pair determines a universal two-weight substitution for the full interlace polynomial. | A pendant marker gives exactly (25). Rooted transfer, determinant algebra, and repeated substitution are known mechanisms, not new results here. The cited theorem supplies the transfer once its inputs are given; it does not supply the particular equal-axis, unequal-full inputs in (27)--(28). |
| Zhu, `arxiv:1309.7673v1`, Corollary 1.3 and Section 2; Wagner--Wang, `doi:10.1007/s00373-013-1360-6`, Theorem 3.1 and Remarks 2--3 | Finite simple rooted products; matching and independence coalescence. Wagner--Wang's pseudo-twin theorem assumes isomorphic root deletions and different automorphism orbits; its counting formulas hold more generally. | These results propagate endpoint equality. Pseudo-twin replacement also preserves the full forest refinement, so that hypothesis cannot itself give this separator. The old family was already separated by matching counts; the new family is not. |
| Anderson--Cutler--Radcliffe--Traldi, `doi:10.1016/j.disc.2009.07.027`, Definitions 3--4 and Theorems 5--6, 17 July 2009 author manuscript | Rooted ordered trees; root/order-independent earlier-sibling-cover counts give the full two-variable interlace polynomial. | The full graph invariant and forest combinatorial formulas predate this work. Its Section 4, Figure 3 concerns equal vertex-nullity polynomials of a tree and a pivot with different independent-set sizes, not equal independence and matching polynomials of two trees. |
| Schwartz, `arxiv:2410.00399v2`, Theorems 3.11, 4.6; Corollary 4.12 | Forest quiver; connected plabic graph for link identification. The full parent refinement gives HOMFLY, and all matching counts give Alexander. Section 4.2, Theorem 4.11 reproduces Galashin--Lam's top-\(a\)-degree comparison for simple leaf-recurrent plabic graphs. | The invariant translations and top-degree comparison are inputs, not advances here. These formulas do not assert reconstruction of the full invariant from the two endpoints and do not themselves construct an equal-endpoint separator. No cited theorem or mutation-equivalence conjecture is refuted. |
| Schwartz, same version, Remark 3.7 and Figure 9 | The connectedness hypothesis is dropped: disjoint union and connected sum of two positive Hopf links give different full HOMFLY polynomials for the same quiver. | This is a disconnected-normalization example, not the present joint obstruction. Its two HOMFLY polynomials differ by \((a-a^{-1})/z\); at \(a=1\), one is zero and the other is \(z^2\), so Alexander equality fails as well. |

For clarity, the Traldi overlap can be written without conflating
Cunningham composition with vertex identification. Let \(J\) be a
rooted tree \(T_t\) with a new pendant marker \(p\) adjacent to \(t\).
Composition of \(J\) with a graph marked at \(h\) removes \(p,h\) and
replaces \(h\) by \(t\), hence gives ordinary rooted coalescence.
With \(u=(s-1)^2\), \(v=t_{\mathrm{poly}}-1\), leaf elimination gives
\[
 H_J=H_T+(u+v)H_{T-t},\qquad H_{J-p}=H_T.
\]
Theorem 20 therefore gives the weights
\[
 \alpha=\frac{(u+v)H_{T-t}-vH_T}{u-v^2},\qquad
 \beta=\frac{uH_T-v(u+v)H_{T-t}}{u-v^2}.
\]
Under \(x=u+v,\ y=v/(u+v)\), these are \(E_t\) and \(E_t+F_t\).
Linearity in the root weights gives
\[
 H_{H\cdot T}=\alpha H_H+(\beta-\alpha)H_{H-h},
\]
exactly (25). These are rational-function identities, or polynomial
identities after clearing denominators; no evaluation at a pole is
required. The independently inspected primary passage and comparison
are in `literature/reviewer-traldi-composition-excerpt.txt`, and the
complete versioned HTML is `literature/traldi-0808.1888v4.html`.

The candidate new **conclusion**, rather than a new invariant or
transfer law, is this: on connected maximum-degree-five trees, the
pair consisting of the entire independence polynomial and the entire
matching polynomial does not determine the full two-variable
interlace polynomial; on \(33m+2\) vertices its joint fibers contain
at least \(m+1\) distinct full polynomials. In the plabic interpretation
the same statement concerns normalized point counts and Alexander
versus full HOMFLY. In graph-theoretic terms it also says that the
complete adjacency spectrum of a tree, even together with its complete
independence polynomial, does not reconstruct that full invariant.
This follows from the already cited forest characteristic/matching
relation, not a new spectral formula.

Why this is more than substituting Schwartz's formulas is a
realizability issue. Arbitrary bivariate polynomials can share both
axis restrictions while differing in mixed terms, but not every such
polynomial, or proposed pair of rooted states, comes from a tree.
Equations (27)--(28) provide actual connected trees, equal whole and
deleted endpoint states, and the nonzero full defect; (30)--(31)
make that difference survive arbitrary hosts and give the quantitative
connected-fiber bound. The explicit compatible separating objects
and the joint-information obstruction are the candidate contribution.
The known transfer and the subsequent translations alone cannot replace
those objects. This identifies the improvement over the inspected
statements, not a claim that the construction is historically first.

One bounded typed Jacobian operation separately factored the primitive
reviewed defect
\[
 uv(u+v)^3(u+v+1)(v^2-u).
\]
`polynomial.multivariate.factor.compute` returned `FACTORIZED` with
`product_reconstruction=EXACT`. Its discovery, exact contract, payload,
and typed output are `jacobian/joint-comparison.*.json`; server 0.14.0,
protocol 2025-11-25, adapter exit zero, no error or timeout. This checks
the mixed-term cancellation displayed by the reviewed polynomial,
not priority or publication significance. No original certificate
was rebuilt or rerun for this comparison-only change.

### Unresolved closest-source overlap

The readable Schwartz v2 paper supplies the precise statements above.
The dissertation *Invariants of Plabic Links*, University of Michigan,
2026, `doi:10.7302/dspace/29648`, remains a distinct, unresolved primary
source. The deposited metadata has no alternative content URL or related
full-text identifier. A bounded alternate-location lookup did not obtain
a readable mathematical passage; the distinct public bitstream-content
endpoint also returned HTTP 403. The already failed download and metadata
endpoints were not retried. No author contact, credential changes, or
paid access were attempted.

The indexed Figure 3.22 caption describes eleven-vertex trees with
the same **full** HOMFLY polynomial. Such a collision, if confirmed in
the body, would have the same two specializations and would not itself
give an unequal-full joint-endpoint obstruction. Only the caption was
indexed: it neither establishes the dissertation's strongest theorem
nor excludes another overlapping result elsewhere in it. The journal
version's additions are also uninspected.

The complete readable 2009 author manuscript is archived as
`literature/forest-interlace-2009-primary.pdf` and `.txt`.
An automatically generated search answer assigned it a joint-equality
example in nonexistent "Proposition 1", "Table 1", and a discussion
after "Theorem 8". Direct reading rejects those locators; the actual
Figure 3 is the different example identified above. A subsequent
bounded search produced no verifiable primary joint-separator
statement. Neither that retrieval result nor an automated assertion
of literature absence establishes novelty.

Publication acceptance therefore remains open. An independent
publication-level verdict must distinguish novelty of this precise
joint obstruction and its quantitative connected realization from
the known invariant, known rooted transfer, and elementary amplification,
and must address the unresolved closest-source priority. The proof and
certificates remain accepted; project completion remains false.
