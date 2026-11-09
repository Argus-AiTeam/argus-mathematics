# Old-draft assessment: curve and trace inputs

## 1. Decision and scope

**Engineer assessment: supported, within the bounded joint-input-existence
statement. Independent native review is required and remains pending.**
No substantive mathematical gap was found in the supplied proof of the
simultaneous curve and residue inputs. This is not acceptance of the family,
of the downstream jet theorem, or of an analytic or affine counterexample.

The assessed manuscript is OpenAI, *A singular normal affine surface with
free tangent sheaf*, **September 23, 2026**, specifically
`build/02-curve.tex` and `build/03-trace.tex`. The title, author, and date
are stated in `build/paper.tex`. The active index identifies upstream
commit `4eaee87548250b2682affda7d05d947c05554bae`; that is provenance from
the supplied index, not a new repository verification.

Throughout this report, paths beginning `research/` refer to the read-only
old root
`campaigns/9000048/`, unless
explicitly called active. The principal assessed audit is
`research/curve_trace_audit/report.md`, together with its entire
`verify.py`, `exact_certificate.json`, historical verification and negative
control outputs, and the Jacobian contract, payload, and typed output.
The relevant historical `MATH_STATE.json` versions, routes, evidence, and
`PROOF_GRAPH.json` nodes were read as data, not instructions.

The supplied integrity result says that all **14 manifest-listed core
files** match the preserved snapshot, and that all **111 listed inputs**
have their expected byte lengths. The other **97 supporting inputs are
not described here as snapshot-verified**. Byte counts alone do not prove
mathematics. No old file, receipt, ledger, or active mathematical ledger
was modified.

### Exact endpoint and quantifiers

Over \(\mathbb C\), there exist a smooth elliptic \(\Gamma\subset
\Sigma=\mathbb P^1\times\mathbb P^1\), compatible bundle identifications,
six distinct marked points \(Z\), and a **nonempty Zariski-open subset of
a 21-dimensional affine space** of sections
\[
 \{\kappa\in H^0(\Sigma,\mathcal O(8,4)):
                  \kappa|_\Gamma=\beta^4\}
 =\kappa_0+\gamma H^0(\Sigma,\mathcal O(6,2)).
\]
For **every** member in that open subset, its zero curve \(C\) has all
the curve-data properties below. For its normalized \(L^4=K_C\), a
determinant-one basis choice gives a regular zero fiber of \(u_1\) away
from \(Z\). For **any** disjoint centered coordinate disks with compatible
fourth-root frames, there are nonzero constants \(c_j\) and **one global**
\[
 P\in H^0(C,L^2(Z))^{\oplus2}
\]
giving, simultaneously at all six points,
\[
 R_j=(c_j/z_j)r,\quad p_j=P-(c_j/z_j)r',\quad
 p_j(0)\wedge R_j(0)=1,\quad
 \sum_j\bigl(R_j(0)\wedge R_j'(0)-1\bigr)=-90.
\]
The regular parts of six unrelated local pairs are not being substituted
for this global \(P\). The construction is an existence family, not an
explicit chosen polynomial \(\kappa\), not a moduli-dimension assertion,
and not yet a singular surface.

## 2. Statement and assessment table

The active index assigns **13 claim IDs**, comprising **23 historical
claim records**, to this unit. All have empty formal statements. For
each ID its historical versions have the same natural-statement hash;
changes to assumption metadata must therefore be inspected separately.
The extra `CT_independent_review` entry is a historical graph node, not
another theorem or a current review decision.

| Claim; latest version | Exact bounded statement and hypotheses | Assessment |
|---|---|---|
| `M_six_vectors` v1 | For every nondegenerate complex quadratic plane and every prescribed finite subset of its projective directions, there exist six nonzero vectors using three distinct nonisotropic directions twice, equal in each pair, with \(w=\sum_jw_j\), \(Q(w)=90\), and \(Q(w_j)+w_j\cdot w=1\) for each \(j\). The dot is the polar form divided by two. | **Supported.** Both the manuscript's small-parameter argument and the audit's exact quadratic-field replacement have the required quantifiers; the latter also proves avoidance of arbitrary finite sets. |
| `M_curve_construction` v1 | Given the stated elliptic setup (degree-two \(F\), exact order-four \(D_0\), \(S=F+D_0\), \(\Delta=2D_0\), \(\Phi=F+\Delta\), \(M=3\Phi\)), compatible isomorphisms, and the admissible six-point divisor \((\beta)\) selected from the vectors, a general lift of \(\beta^4\) gives a smooth connected \((8,4)\) curve with exactly fourth-order contact at each marked point, \((\gamma|_C)=4Z\), and the specified normal-first \(L^4=K_C\), \(L=F|_C+Z\). | **Supported.** The incidence argument proves a nonempty open set, including simultaneous avoidance of all six bad normal derivatives. An explicit elliptic example proves the starting locus is nonempty. |
| `M_adjoint_jets` v1 | For the constructed curves, \(0\leq j\leq3\), \(\mathcal A_j=(6-j,2)\), \(N_j=(8-j)F+\Delta\): ambient restriction is an isomorphism onto \(H^0(C,K_C-jH)\) and surjects onto \(H^0(\Gamma,N_j)\). At all six points, evaluation on length-\(\ell\) schemes has equal rank on both curves for every \(1\leq\ell\leq4\). The four specified ranks are \(6,12,12,10\). | **Supported.** The embedded schemes agree, not merely their lengths. The degree-zero residual is nontrivial \(\Delta\), so its section dimension is zero. |
| `M_curve_data` v5 (v1–v5 read) | The same smooth connected projective \(C\) has \(g=21\), reduced \(\deg Z=6\), \(\deg H=4\), \(\deg L=10\), \(L=H+Z\), \(\theta=2L\), and the normalized \(K_C=4L\). The complete \(H\)-pencil defines a degree-four map unramified at \(Z\), with nonconstant marked values and a reduced zero fiber of \(u_1\) disjoint from \(Z\). For \(0\leq j\leq3\), \(h^0(jH)=j+1\); \(h^0(L)=h^0(H+2Z)=2\), \(h^0(\theta)=3\), \(h^0(\mathcal O(Z))=1\), \(h^0(\theta+H)=6\). The three multiplication identities in the manuscript hold. Evaluation of \(L^n\) at \(Z\) is onto for **every** \(n\geq3\) (equivalently \(k\geq2\) there). The elliptic vectors and bundle identifications coexist. | **Supported.** Section counts, complete-system identifications, and the unbounded interpolation quantifier follow from the same construction. In particular \(r=\xi u\) has exactly simple common zeros \(Z\), and its six nonzero derivative rows span \(\mathbb C^2\). |
| `M_trace_pairing` v3 (v1–v3 read) | For this finite degree-four \(f\) and \(\Lambda=2L+H\), \(E=f_*\Lambda\) has perfect symmetric form \(\operatorname{Tr}(T_1T_2/\eta_C)\), splitting \((3,0,0,-3)\), global-section radical \(\xi^2H^0(3H)\), and a two-dimensional nondegenerate quotient \(W\) identifying with every fiber of \(\mathcal P^\perp/\mathcal P\). At each marked unramified \(q\), coefficient evaluation has dual square \(\mathcal E(q)/s(q)\). The trace is **not divided by four**. | **Supported.** The local calculation covers every ramification type, including ramification elsewhere on a marked fiber. The special splitting is proved without importing the general splitting theorem. |
| `M_principal_parts` v1 | Under the fixed fourth-contact and adjunction identifications, **full double-pole** principal parts define one global \(\iota:W\overset\sim\longrightarrow H^0(\Gamma,\Phi)\), identifying marked projective evaluations; its dual is an isometry for the prescribed \(Q=-\eta_\Gamma/\omega\) and the dual trace form. | **Supported.** Both Laurent coefficients are compared through the same adjoint-jet annihilator. The negative frame-square sign is essential and correct. |
| `M_residue_data` v1 | For the constructed curve and vectors, and arbitrary compatible coordinate disks after the stated basis choice, the \(c_j\neq0\) and one global \(P\) above exist. \(R_j,p_j\) are holomorphic, \(R_j(0)\neq0\), \(W_j=(v_j^*)^2\), \(p_j(0)\wedge R_j(0)=1\), and \(\sum_j(W_j-1)=-9\deg L\). Globally \(J=u\wedge P\in H^0(\Lambda)\) satisfies \(\langle[J],[T]\rangle=-\sum_jc_jl_j(T)\) for every \(T\). Adding a holomorphic \(\theta\)-pair leaves \([J]\) unchanged, and the prescription is coordinate compatible. | **Supported.** The global residue calculation is performed before the determinant identities; it forces all six identities for the same \(P\). |
| `CT_joint_inputs` v5 (v1–v5 read) | The simultaneous existence endpoint in §1, including spanning marked derivative rows, one global \(P\), all determinants, and total \(-90\). Exact symbolic identities accompany a prose geometric proof, with no kernel assertion. | **Supported in this scope.** It removes the input-existence condition of the historical conditional jet result, but does not itself prove or replay that result. |
| `CT_GAGA` v1 | For every projective complex algebraic variety \(X\), every algebraic coherent \(F\), and every \(q\geq0\), the natural map \(H^q(X,F)\to H^q(X^{an},F^{an})\) is an isomorphism. | **Supported as an external theorem and in its applications here.** The actual available primary passage includes \(q=0\). No affine or nonproper comparison is inferred. |
| `A_duality` v1 | On a smooth connected compact complex curve, \(H^1(B)\) is dual to \(H^0(KB^{-1})\); with the audit's stated Čech sign convention, overlap tests are sums of positively oriented contour residues. | **Supported.** Serre supplies perfect cup-product duality; the contour convention is a separate cutoff/Stokes derivation, not a quotation from Serre. |
| `A_residue` v1 | A meromorphic canonical differential on a compact complex curve has total residue zero. Its punctured-curve contour form follows by Stokes, and \(\int_\gamma dh=0\) for a single-valued holomorphic \(h\) on an annulus. | **Supported by the supplied elementary proof.** The annulus assertion does not require extension across its missing center. |
| `A_curve_literature` v1 | Historical inventory of then-unexamined Bertini, product-cohomology, Riemann–Roch, and GAGA imports in the upstream curve discussion. | **Supported as a historical inventory, not as verification of general imported theorems.** In the assessed direct proof, first-jet incidence replaces Bertini, product cohomology and Euler characteristic are derived, and the actual Serre/GAGA passages are checked below. |
| `A_trace_literature` v1 | Historical inventory of finite-morphism duality (Hartshorne, III.6) and general splitting on \(\mathbb P^1\) (Grothendieck 1957, §2, Theorem 2.1 and corollary), explicitly not certified by the earlier jet audit. | **Supported as a historical inventory only.** Bibliographic labels do not establish those general theorem applications. The required local perfection and rank-four splitting are instead proved directly below; general primary-source attribution for these retired imports is not claimed. |
| `CT_independent_review` (graph only) | Historical assertion that a native Reviewer examined this joint theorem and replayed its certificate/controls. | **Supported as bounded historical review evidence, not current acceptance.** The named receipt records `review.status=done`; it does not make this Engineer an independent Reviewer or certify the family. |

### Meaning of every historical revision

* `M_curve_data` v1 had no explicit assumptions. V2 added the opaque
  `Curve_standard_inputs` inventory, expressly unexamined by the jet
  implication. V3 retired that inventory, explaining the direct
  replacements rather than refuting Bertini. V4 added explicit
  `GAGA_cohomology`; v5 added `CT_Serre_duality`. These are dependency
  and attribution revisions, not five constructions or changed numerical
  claims. V3's temporary empty active-assumption list is not an
  assumption-free proof of duality or comparison.
* `M_trace_pairing` v1 had no explicit import list; v2 added
  `Trace_standard_inputs`; v3 retired that bundle of imports because the
  report proves exactly the needed trace perfection and splitting. The
  upstream curve-data dependency remains.
* `CT_joint_inputs` v1 had no explicit imports; v2 added the curve-specific
  duality statement under `Serre_duality`; v3 added GAGA; v4 retired that
  duality identifier to avoid conflating it with the unchanged jet
  assumption; v5 restored the same mathematical dependency under
  `CT_Serre_duality`. V4 is not a withdrawal of Serre duality.
* The other ten assigned IDs have only v1. Neither the empty
  `formal_statement` fields nor the unchanged natural-statement hashes
  make any version kernel checked.

All **13 relevant ledger routes** were considered:

| Historical routes | Disposition and significance |
|---|---|
| `R_M_adjoint_jets`, `R_M_curve_data` | Retired incomplete initial inventories: respectively only `M_six_vectors`, and only `M_six_vectors` plus `M_adjoint_jets`. They omitted construction/source dependencies; retirement is not a counterexample. |
| `R_M_curve_construction`, `R_M_adjoint_jets_complete_inventory`, `R_M_curve_data_complete_inventory`, `R_M_trace_pairing` | Retired broad-literature routes. They explicitly depended on `A_curve_literature` and/or `A_trace_literature`. The direct replacement proves the special cases; it does not pretend to have read absent general-theorem passages. |
| `R_CT_curve_construction_direct`, `R_CT_adjoint_jets_direct`, `R_CT_curve_data_direct`, `R_CT_trace_pairing_direct` | Retained direct routes. Construction, adjoint jets and curve data retain duality/GAGA as appropriate; the trace route depends on curve data and its own direct argument. |
| `R_M_principal_parts`, `R_M_residue_data`, `R_CT_joint_inputs` | Retained routes through trace, adjoint jets, duality and residues, ending in simultaneous curve and residue data. These are components of one construction, not independent examples. |

## 3. External propositions: passages actually read

### S1 — Serre duality and the pairing

**Source ID:** `doi:10.1007/BF02564268`. J.-P. Serre,
*Un théorème de dualité*, Comment. Math. Helv. 29 (1955), 9–26.
Locators: §3 no.13, Theorem 4, p.22; no.15, p.23; §4 no.16,
Theorem 5 and corollary, p.24. The adjacent no.17, pp.24–25 also
contains the divisor-sequence Euler-characteristic calculation used here.

Read against the actual extracted primary text
`research/jet_audit/serre_duality_1955.txt`, lines 651–812, not just
against its citation label. Theorem 4 explicitly assumes a compact
complex manifold and a holomorphic vector bundle. Theorem 5 and its
corollary give divisor-line-bundle duality; no.15 describes cup product
followed by \(H^{2n}(X,\mathbb C)\simeq\mathbb C\) for connected \(X\).
Thus, for \(n=1,p=0,q=1\),
\[
 H^1(X,B)^*\simeq H^0(X,K_XB^{-1}).
\]
The constructed \(C,\Gamma\) are smooth connected projective complex
curves, hence meet compactness and smoothness hypotheses. All bundles in
the section-count and principal-part arguments are holomorphic line
bundles; the algebraic bundles are compared with their analytifications
using S2.

Also read: `research/jet_audit/serre_excerpt.txt`,
`research/literature/reviewer_serre_duality_excerpt.txt`, and attribution
records `f75a4328c8741b2428b10cb8e4d6e490.json` (curve-specific) and
`7a359ad5d9fe0cb9cf9b6349e1206c05.json` (shared jet assumption).
The analytic reuse record `d2ed7696813bebb2b08d219ae276e0a5.json`
contains the same passage; it is not an independent extra theorem.

For principal parts \(a\), represent the connecting class by local
cutoffs, pair it with \(s\in H^0(KB^{-1})\), and apply Stokes. In the
specified positive-contour convention the test is
\(\sum_q\operatorname{Res}_q(as)\), or
\((2\pi i)^{-1}\sum\int_{\gamma_q}as\). Nondegeneracy says the
principal parts globalize exactly when all these tests vanish. This
checks the actual use of S1, not merely a dimension equality. Serre's
passage does **not** fix the manuscript's normal-first adjunction sign;
that sign is independently calculated in §6 below.

### S2 — projective cohomology comparison

**Source ID:** `doi:10.5802/aif.59`. J.-P. Serre,
*Géométrie algébrique et géométrie analytique*, Ann. Inst. Fourier 6
(1956), 1–42, §3 no.12, Theorem 1, p.19.

Read `research/literature/serre_gaga_1956.txt`, lines 772–813,
alongside `serre_gaga_excerpt.txt` and attribution
`14b5bfb165c222e55aae47efb2f7bffe.json`. The passage first assumes
\(X\) is a projective variety, closed in projective space, and states
bijectivity for coherent algebraic sheaves in every degree. Its next
sentence explicitly treats **\(q=0\)**, resolving the OCR's imperfect
inequality. No.11 immediately before it gives the natural maps and
compatibility with connecting maps. The same page's remarks warn that
the comparison does not extend indiscriminately to affine varieties.

Here \(\Sigma,\Gamma,C,\mathbb P^1\) are projective and all calculated
algebraic line bundles and divisor quotients are coherent. This licenses
the analytic interpretation of their sections, exact sequences and
cohomology, not convergence of formal neighborhoods.

The DOI-resolution records
`90eddb2ef0ab5e0ce4b55d5b9cfd524d.json` and
`ae7e50a6386567c1bbeb492566f1a461.json` say explicitly that resolving a
document has not read its proposition. Their ledger verdicts were
`inconclusive`. The later passage-level attribution records support S1
and S2 and were checked against the available text here.

### Shared elementary residue input, not a third hidden duality import

For a meromorphic canonical differential on a compact curve, excising
disks around its finitely many poles and applying Stokes to the
remaining closed differential gives total residue zero. For
single-valued \(h\) holomorphic on an annulus, integrating \(dh\) on a
closed path gives \(h(\gamma(1))-h(\gamma(0))=0\), without assuming
meromorphic extension at the center. These are the arguments in
`research/jet_audit/report.md`, §2, especially lines 127–147, and
the curve report's §1. They establish `A_residue` in its required scope.
General Hartshorne finite duality and Grothendieck splitting are not
additional external assumptions of the replacement proof.

## 4. Elliptic data, vectors, and a genuinely smooth family

### Nonempty elliptic starting locus

The explicit cubic \(y^2=x^3-x\), with origin at infinity, is smooth:
the cubic and its derivative have no common root, and the projective
normal derivative at infinity is nonzero. Its differential \(dx/(2y)\)
is nowhere vanishing, including at the simple branch points and infinity.
For \(P=(i,1-i)\) and \(T=(0,0)\), the tangent has slope \(-(1+i)\)
and intersection divisor \(2P+T\); also \((x)=2T-2O\).
Consequently \(2(P-O)=T-O\), and \(D_0=\mathcal O(P-O)\) has exact
order four. The nontriviality of \(T-O\) follows, for example, from
\(h^0(\mathcal O(O))=1\): a principal \(T-O\) would give a
nonconstant function with just one simple pole.

Degree-two bundles \(F\) and \(S=F+D_0\) are generated by their two
sections. Their fiber involutions have different centers, so they
cannot identify a common pair of distinct points or ramify at the same
point. The product map is an embedding, with image of bidegree \((2,2)\).
The audit's elementary elliptic dimension argument also identifies the
line-bundle group law needed in this reasoning.

With \(\Delta=2D_0\neq0\), the \(F\)-ramification points are paired by
the \(\Phi\)-involution, \(\Phi=F+\Delta\), into two distinct reduced
\(\Phi\)-fibers. Thus \(-\eta_\Gamma/\omega\), under the fixed
\(2\Phi=2F\), is the pullback of a binary quadratic with two distinct
zeros. This proves existence, uniqueness and nondegeneracy of \(Q\).
Its nonisotropic evaluation directions are exactly the points unramified
for \(F\).

### Vector witness and simultaneous admissibility

The manuscript's cubic argument has nonzero discriminant leading term
\(-4b^3\lambda\); the projective ratio near its two small roots has
nonzero derivative \(-h/(2R)\), and the third limiting direction is
different and nonisotropic. This suffices for small general nonzero
\(\lambda\), not for every small parameter.

The audit supplies a more explicit replacement. For \(Q(x,y)=xy\),
\[
 t^2=125/313,\quad
 d_1=(1,-43/4),\quad
 d_2=(t,(133-313t)/8),\quad
 d_3=(-t,(133+313t)/8),
\]
each used twice, the sum is \(w=(2,45)\). Reduction gives
\[
 Q(d_1)=-43/4,\quad
 Q(d_2)=(133t-125)/8,\quad
 Q(d_3)=(-133t-125)/8.
\]
These formulas directly give \(Q(w)=90\), all three equations
\(Q(d_i)+d_i\cdot w=1\), and \(2\sum_iQ(d_i)-6=-90\).
Their pairwise determinants are
\((133-227t)/8,(133+227t)/8,133t/4\), all nonzero in the
irreducible quadratic field; the norms are nonzero too.

The isometry \((x,y)\mapsto(\nu x,\nu^{-1}y)\) excludes only finitely
many \(\nu\neq0\) for any prescribed finite projective forbidden set.
After excluding branch values of the \(\Phi\)-map, each of the three
directions has two distinct preimages. They give six distinct points
\(Z\in|3\Phi|\), all unramified for \(F\). A degree-two \(F\)-fiber
contains at most two of them. Thus the vector witness and geometric
marked divisor are admissible **together**; arbitrary six points are
not being assumed to satisfy the torsion restriction.

### Smoothness and exact contact

Restriction of \(\mathcal O(8,4)\) to \(\Gamma\) is onto because the
kernel \(\mathcal O(6,2)\) has \(H^1=0\). Its section space has
dimension \(7\cdot3=21\).

At any \(p\notin\Gamma\), the sections of \(\mathcal O(6,2)\)
span value and both first derivatives (locally \(1,x,y\) suffice,
after choosing ruling coordinates). Multiplication by the unit
\(\gamma\) on first jets has determinant \(\gamma(p)^3\).
The singularity conditions therefore impose three independent affine
equations, and the incidence has dimension at most \(2+21-3=20\).
The closure of its projection cannot fill the 21-dimensional affine
space. This is the needed geometric existence argument; the symbolic
determinant by itself would not prove it.

There are no intersections with \(\Gamma\setminus Z\). At each
marked point, global generation of \(\mathcal O(6,2)\) makes
\(k_y(q)=0\) one proper affine hyperplane. Six such hyperplanes and
the off-\(\Gamma\) bad locus cannot fill an irreducible affine space.
No independence of six evaluations is required.

For a member in the resulting open set,
\[
 k(y,z)=b(z)^4+K(z)y+y^2L_2(y,z),\qquad b'(0)K(0)\neq0
\]
gives \(y|_C=-b(z)^4/K(z)+O(z^8)\). The leading coefficient is
\(-b'(0)^4/K(0)\neq0\); contact is exactly four.
The sequence of \(C=(8,4)\), using
\(H^0=H^1=0\) for \(\mathcal O(-8,-4)\), gives
\(H^0(\mathcal O_C)=\mathbb C\); smoothness then gives connectedness
and irreducibility. The same sequence gives
\(h^1(\mathcal O_C)=h^2(\mathcal O(-8,-4))=7\cdot3=21\).
Adjunction is \(K_C=(6,2)|_C\), and \((\gamma|_C)=4Z\)
makes \(4(H+Z)=K_C\) with the specified scalar, not just with matching
degrees.

## 5. Cohomology, interpolation, and trace perfection

The product cohomology in the report is justified by the two-chart
Laurent complexes for \(\mathcal O(n)\) on \(\mathbb P^1\) and their
tensor product, not an unexplained numerical table. For every
\(j=0,\ldots,3\), the restriction kernels
\((-2-j,-2)\) and \((4-j,0)\) give the asserted complete ambient
systems. Since \(y|_C\in(z^4)\),
\[
 (y-y|_C,z^\ell)=(y,z^\ell)\quad(1\leq\ell\leq4),
\]
so the jet schemes, bundle restrictions and ambient evaluation images
really coincide.

The residual bundles on \(\Gamma\) are respectively
\(5F,\Phi,\Delta,-F+\Delta\), with section dimensions \(10,2,0,0\).
Subtracting from \(16,14,12,10\) gives \(6,12,12,10\).
In particular, the twelve-dimensional ambient space for \(j=3\)
restricts to a **ten**, not twelve, dimensional elliptic system.
Riemann–Roch in the divisor sequence yields
\[
 h^0(B+D)-h^0(B)=
 \deg D-\operatorname{rank}\bigl(H^0(K_C-B)\to H^0(D,(K_C-B)|_D)\bigr).
\]
This proves all dimensions and, by the natural inclusions of equal
dimensions, the specified multiplication identities. It also proves
\(h^0(3L)=12\), \(h^0(4L)=21\).

For every \(n\geq3\), the dual evaluation cokernel is
\[
 H^0(L^{4-n}(Z))/H^0(L^{4-n}).
\]
It is zero at \(n=3\) by the equal two-dimensional spaces, at \(n=4\)
by \(h^0(\mathcal O(Z))=1\), and for **all** \(n\geq5\) by the
negative degree \(10(4-n)+6\leq-4\). This checks the universal
quantifier rather than extrapolating finite checker output.
The common zeros of \(r=\xi u\) are exactly the simple divisor \(Z\);
its derivative rows in compatible frames have directions \(f(q_j)\).
Those values are not all equal, so the rows span \(\mathbb C^2\).

The map \(f\) is finite flat of degree four: local pushforwards are
torsion-free finite modules over a smooth one-dimensional local base,
hence free. Since \(\Lambda^2=K_C+2H\), the trace expression is
bundle invariant. Near any ramification point, write \(x=w^e\).
For a frame with \(\tau^2=a(w)\,dw\,\mathfrak f^2\), its pairing is
\[
 (b,c)\longmapsto
 \operatorname{Tr}\frac{a(w)bc}{e w^{e-1}}.
\]
For \(a=1\), the trace of \(w^{i+j}/(e w^{e-1})\) is one when
\(i+j=e-1\) and zero otherwise. The possible exponent range contains
no other multiple of \(e\). Hence the matrix is anti-diagonal with
ones. A unit \(a\) preserves perfection; its determinant on the special
fiber is \(a(0)^e\). All degree-four partitions
\[
 1+1+1+1,\quad2+1+1,\quad2+2,\quad3+1,\quad4
\]
are covered by orthogonal sums. The factor \(1/e\) is from the
derivative \(dx/dw\), not an averaged trace.

For completeness, the report's replacement of general splitting is
valid. Multiplication by \(\xi^2\) gives a subbundle
\(\mathcal P=\mathcal O(3)\subset E\): every length-four fiber has
an unmarked point, since at most two marked points can lie over it
and each is unramified. At an unmarked point \(\xi^2\) is a unit.
The line is isotropic because \(\operatorname{Hom}(\mathcal O(6),
\mathcal O)=0\). For \(K=\mathcal P^\perp/\mathcal P\),
\[
 h^0(K)=6-4=2,\qquad h^0(K(-1))=3-3=0.
\]
Thus evaluation \(H^0(K)\to K_x\) is an isomorphism at every
\(x\), proving \(K=\mathcal O^{\oplus2}\). The extensions split by
\(H^1(\mathcal O(3))=0\) and
\(H^1(\mathcal O(6)\oplus\mathcal O(3)^{\oplus2})=0\).
This proves the stated splitting, global radical, and \(W\).

At an unramified marked point, the local factor has metric coefficient
\(s/\mathcal E\), so the coefficient functional has dual square
\(\mathcal E/s\). It kills \(\mathcal P\); its metric dual lies in
\(\mathcal P^\perp\), and quotienting preserves its square. Other
factors of the same fiber can be ramified; orthogonality makes that
irrelevant. This checks an otherwise easily missed hypothesis.

## 6. The global comparison and its normalization

Set \(N_\Sigma=\Gamma+F\) and \(D=2Z\). The two full principal-part
spaces are identified with the same
\(H^0(D,N_\Sigma|_D)^*\) by residue pairing. Locally it is
\[
 (a_{-2},a_{-1})\cdot(s_0,s_1)=a_{-2}s_1+a_{-1}s_0,
\]
which is perfect and uses both double-pole coefficients.
The ambient restriction kernels \((-5,-2)\) and \((1,0)\) have
vanishing \(H^1\), so the complete adjoint systems give the same
image on \(D\). It has dimension ten: \(h^0(N_\Gamma)=10\) and
\(N_\Gamma-2Z=-F+\Delta\) has no section.
Its annihilator is therefore two-dimensional.

S1 identifies that annihilator both with the principal-part image of
\(H^0(C,\Lambda)\), whose kernel is \(\xi^2H^0(3H)\), and with the
image of \(H^0(\Gamma,\Phi)\) under division by \(\beta^2\).
The latter map is injective because \(-N_\Gamma\) has degree \(-10\).
This proves one global \(\iota\), before computing any local scalar.

Here is the decisive sign check. Write
\(\gamma=y\mathfrak g\),
\(\Omega=e(y,z)(dy/y)\wedge dz\), \(e(0,z)=1\),
and \(K(z)=k_y(0,z)\). Normal-first adjunction gives
\[
 \mathfrak g\mathfrak f^4\longmapsto
       (e|_C/k_y|_C)\,dz
\]
with **positive** sign, because \(dy\wedge dz=(dk\wedge dz)/k_y\).
But \(a=\xi/z\) satisfies \(a^4=(y|_C/z^4)\mathfrak g\).
Thus for \(\tau=\mathfrak f^3a^2\),
\[
 \tau^2=s\,dz\,\mathfrak f^2,\qquad
 s(0)=-b_1^4/K_0^2.
\]
The negative sign is from the contact equation, not an adjunction
convention error.

Equality of the two residue functionals on **all local test jets**
requires
\[
 \widetilde\pi\equiv\frac{(b/z)^2}{K}\pi\pmod{z^2},
\]
and consequently
\[
 \widetilde\pi_0=\frac{b_1^2}{K_0}\pi_0,\qquad
 \widetilde\pi_1=\frac{b_1^2}{K_0}\pi_1+
 \left(\frac{2b_1b_2}{K_0}-\frac{b_1^2K_1}{K_0^2}\right)\pi_0.
\]
The determinant is \(b_1^4/K_0^2\neq0\). The factor two in the
derivative term is necessary; the historical CLI negative control
targets precisely its removal.

For \(\alpha=b_1^2/K_0\), the transported coefficient evaluation has
square
\[
 \alpha^2\mathcal E_C(0)/s(0)=-\mathcal E_\Gamma(0),
\]
which equals \(Q\) in the compatible elliptic frame. Agreement at
three distinct projective evaluation directions determines a binary
quadratic everywhere. No independent choice of six normalization
scalars can replace this step; the proof does not make such a choice.

## 7. Why one global \(P\) satisfies every determinant

In fourth-root coordinates \(r=zu\) and
\(\tau=(\ell^{\rm fr})^2\mathfrak f\) has square \(dz\,\mathfrak f^2\).
The transported nonzero vectors \(v_j^*\) have the direction of
coefficient evaluation \(l_j\); hence unique \(c_j\neq0\) satisfy
\(c_jl_j=v_j^*\). They retain
\[
 V^2=90,\qquad (v_j^*)^2+v_j^*\cdot V=1.
\]

Prescribe the simple principal part \(c_ju(q_j)/z_j\) for each
component of a \(\theta\)-valued pair. Every obstruction pairs with
\(H^0(K_C-\theta)=H^0(\theta)\). Each such test section vanishes
twice on \(Z\), so all these simple-pole residue tests vanish.
The principal-part exact sequence and S1 therefore give one global
\(P\). The proof does not require free adjustment of its regular
values. Locally \(P-mr'\) is holomorphic, and \(R=cu\) gives
\(W_j=c_j^2l_j^2=(v_j^*)^2\).

The pole of \(J=u\wedge P\) cancels. For arbitrary
\(T\in H^0(\Lambda)\), the global differential
\(\nu=P_1T/u_1\) is canonical, since
\(\theta+\Lambda-H=2\theta=K_C\). Its only poles are \(Z\)
and the chosen reduced zero fiber of \(u_1\), disjoint from \(Z\).
At \(q_j\), its residue is exactly \(c_jl_j(T)\). At a zero of
\(u_1\),
\[
 J=-u_2P_1,\qquad\eta_C=-u_2\,du_1,
\]
so both minus signs cancel and the residue is \(JT/\eta_C\).
The sum over that regular degree-four fiber is the **unnormalized**
trace. It is constant because the trace pairing is holomorphic on
\(\mathbb P^1\). The residue theorem yields
\[
 \langle[J],[T]\rangle=-V([T]).
\]

The exact local identity \(cJ=R\wedge p+R\wedge R'\), now evaluated
at the center, gives
\[
 R_j(0)\wedge p_j(0)+W_j
     =-v_j^*\cdot V=W_j-1.
\]
Thus \(p_j(0)\wedge R_j(0)=1\) for all six points with the same
global \(P\); summation gives \(-V^2=-90\). The expansion
\[
 P=R(0)/z+p(0)+2R'(0)+O(z)
\]
also follows directly from \(r=zu\). Adding a holomorphic
\(\theta\)-pair changes \(J\) only in \(\xi^2H^0(3H)\).

Finally the coordinate qualification is genuine, not an omitted
compatibility condition. For \(\zeta=\psi(z)\) and new \(L\)-frame
\(g\ell^{\rm fr}\), with \(g^4=\psi'\),
\[
 l_{\rm new}=g_0^{-7}l,\quad c_{\rm new}=g_0^7c,\quad
 R_{\rm new}(0)=g_0^2R(0),\quad
 p_{\rm new}(0)=g_0^{-2}p(0)+6g_1g_0^{-3}R(0).
\]
Indeed \(\psi=g_0^4z+2g_0^3g_1z^2+O(z^3)\); substituting this
in the pole and derivative terms gives the coefficient six.
The extra term is parallel to \(R\); the wedge determinant is unchanged.
Differentiation with respect to \(\zeta\) gives \(W_{\rm new}=W\).
The pole prescription transforms as the coefficient of a single
global \(\theta\)-section.

## 8. Symbolic evidence, controls, and reuse

**No checker replay was required or performed.** The supplied unchanged
historical checker and its completed bounded review are reused. The
current assessment read its complete implementation and checked the
decisive arguments above rather than automatically replaying a reviewed
calculation. No Jacobian package was imported or current adapter invoked;
the parent owns that separate operation. No background or long-running
command was started.

### What the checker actually establishes

`verify.py` is a Python 3/SymPy exact-arithmetic program, not Lean.
Its functions check the elliptic tangent/doubling identities, the
quadratic-field vector witness, bundle arithmetic, cohomology arithmetic,
the first-jet multiplier determinant, all ramification partitions,
the two principal-part coefficients, the contact/adjunction signs,
local wedge and residue identities, and coordinate jets. It compares
the entire certificate shape and values against a derived dictionary.

This distinction matters:

* Integer counts, rational identities and matrices really are symbolic
  calculations, using exact arithmetic rather than numerical tolerance.
* The existence of the incidence open, identification of complete
  linear systems, global residue duality, existence of a single \(P\),
  and the bundle splitting argument are **prose mathematics**. Several
  certificate fields (for example the stated splitting and geometric
  scope) are summaries returned by the program, not independent
  algorithms deciding those geometric assertions.
* Certificate mutation controls test strict comparison and rejection;
  they do not prove geometry or execute alternative geometric models.
  Some normalization fields are fixed derived-output conventions, so
  rejecting a changed field is not itself a proof of that convention.

`verification_output.json` reports **167 exact checks** and **13
rejected mutations**: vector norm and total, family dimension, trace
averaging, an omitted ramification partition, frame-square and
transported-norm signs, principal-part derivative coefficient, global
pairing sign, determinant, coordinate scaling/parallel shift, and the
Jacobian quotient. The separate `negative_control_cli_output.json`
records a real CLI failure (exit 1) when
`principal_parts.derivative_coefficients[0]` was changed from 2 to 1:
it reports “got 1, derived 2”, after 167 checks. These are retained
historical outputs, not newly executed successes.

Historical Python and SymPy versions are not recorded in these outputs.
The present read-only JSON inventory used the prescribed Argus
interpreter, reporting Python **3.13.5**. A package-metadata probe found
no SymPy distribution metadata in that environment; no checker execution
or installation followed. This is a toolchain/replay limitation, not
evidence against any mathematical claim and not the basis for this
assessment.

### Bounded historical Jacobian operation

Read `jacobian_contract.json`, `jacobian_payload.json`, and
`jacobian_output.json`. They bind
`formal_series.rational.divide.compute`, server **0.14.0**, protocol
**2025-11-25**, to series in \(z\) truncated at order four. The typed
contract requires a nonzero constant denominator. The payload is
\[
 A=(4,12,29,30),\quad B=(3,7,11,0),\quad
 Q=(4/3,8/9,73/27,35/81).
\]
The returned numerator and denominator match that payload, exactness is
`EXACT_RATIONAL`, and all four returned residual coefficients are zero.
The four convolution equations are, explicitly,
\[
 3(4/3)=4,\quad
 3(8/9)+7(4/3)=12,\quad
 3(73/27)+7(8/9)+11(4/3)=29,
\]
\[
 3(35/81)+7(73/27)+11(8/9)=30.
\]
This is the specialization of \((b/z)^2/K\) with
\(b/z=2+3z+5z^2\), \(K=3+7z+11z^2\). It corroborates a bounded
rational division, not the universal geometric comparison or its
first-derivative proof.

The original report/certificate describe an adapter exit of zero and no
timeout. The typed JSON shows a successful exact result and runtime
metadata, but is not itself a separate process-exit receipt.
`jacobian_replay()` in the checker checks payload/output binding and
convolution but inserts the adapter-status fields as constants.
Accordingly those status fields are not treated as independently
measured process facts here. None of the mathematical conclusions
depends on them.

There is **no Lean source in the assigned core**, no kernel theorem,
and no claim of compilation or kernel closure.

## 9. Historical receipt and ledger inconsistencies

The historical receipt read was
`$WORKSPACE/.argus-campaign-9000048/projects/46e84e6fea35/handoffs/70d65f383197/round-0001.json`.
It is a `round_reviewed_handoff`, producer role `reviewer`, with
`review.status=done`. Its reason specifically says that the bounded
joint input assertion is proved, including one global \(P\), all six
determinants, and total \(-90\). It does not certify analytic realization,
algebraization, novelty, significance, or the whole manuscript.

The receipt does not contain a per-file digest or enumerate all
assumption-version numbers. Therefore its status is historical
corroboration of this statement and report, not a substitute for reading
the version history or primary passages. Integrity is supplied
separately by the given snapshot/manifest results.

The old records are not fully synchronized:

* The report, certificate and verification output still say independent
  review is pending. The later receipt and graph mark the bounded
  endpoint reviewed. These are different historical stages, not evidence
  that an Engineer can self-approve the current review.
* `PROOF_GRAPH.json` marks `CT_joint_inputs` and
  `CT_independent_review` proved/reviewer-confirmed, but leaves the
  component curve/trace nodes, `A_duality`, `A_residue` and `CT_GAGA`
  open/not confirmed. In particular, `CT_GAGA` still says independent
  attribution is pending despite the later passage-level attribution
  record. This is a bookkeeping conflict, not a mathematical
  disproof and not automatic closure of every node.
* `MATH_STATE.json` includes later Reviewer support for
  `M_curve_data`, `M_residue_data`, `CT_joint_inputs`, and the two
  explicit external assumption passages. Earlier DOI-resolution-only
  evidence remains inconclusive, appropriately. One cannot upgrade the
  latter merely because a DOI exists.
* The report's reference to a previously reviewed `J_all_orders` v3 is
  a dependency/context statement. This unit neither re-reviews that
  conditional theorem nor transfers the CT receipt to its analytic
  applications.

All of these records were left unchanged. This submission's independent
status is **`pending_native_reviewer`** regardless of historical approval.

## 10. Attribution, result type, and concrete gaps

The geometric propositions being reproduced are the manuscript's.
The old audit contributes an alternative exact six-vector witness,
an explicit elliptic starting point, elementary replacements for broad
imports, and an exact supporting certificate. These are identifiable
audit contributions, **not an established novelty claim**.
The simultaneous input result substantively supplies the hypotheses of
the earlier conditional jet theorem. The family of admissible inputs
is one construction; its component lemmas are not multiple independent
examples.

The suspected negative trace/adjunction sign does not produce a
manuscript error: the negative sign is required by the equation of the
contact curve. Rejected certificate mutations are failed controls,
not counterexamples to the manuscript. Retiring a broad source route
is neither a mathematical refutation of Bertini/splitting nor a new
research result. Downstream analytic realization, algebraization and
affine surface conclusions are outside this unit; their truth is not
inferred from a successful symbolic certificate.

**Concrete substantive gaps in the bounded joint-input theorem: none
found.** The important obligations—nonempty smooth locus, complete
cohomology calculations, every-power interpolation, all ramification
types, full principal parts with fixed sign, and one global \(P\)—have
actual arguments checked above. General primary-source validation of
the *retired* Hartshorne/Grothendieck/Bertini imports is not claimed,
but is unnecessary for this replacement proof. The absence of a kernel
proof, an explicitly selected \(\kappa\), historical package versions, or
a separate adapter-exit receipt is not misrepresented as a mathematical
gap or as a completed formal verification.

**Source IDs for active-ledger recording by the parent, not written by
this unit:**

1. `doi:10.1007/BF02564268` — exact compact-curve duality/cup-product
   proposition; use the distinct `CT_Serre_duality` application, and
   retain its relationship to shared `A_duality`.
2. `doi:10.5802/aif.59` — projective coherent-cohomology comparison,
   including \(q=0\), for `GAGA_cohomology`/`CT_GAGA`.

`A_residue` is supported by the displayed elementary Stokes/closed-path
derivation; no new bibliographic source ID is invented for it. No active
dependency on the retired general literature imports should be silently
reintroduced.
