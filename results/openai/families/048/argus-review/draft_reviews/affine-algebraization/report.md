# Affine algebraization: old-draft unit assessment

## Status, attribution and provenance

**Engineer assessment: the general isolated-germ implication is supported,
with its stated analytic hypotheses and the external propositions below.
Native independent review remains pending.** Its application to the claimed
surface uses the historical analytic input, not a new verification of that
input. This assessment does not accept the main theorem or the family.

The unit is `affine-algebraization` in `research/DRAFT_REVIEW_INDEX.json`.
The original source is **OpenAI**, *A singular normal affine surface with
free tangent sheaf*, **September 23, 2026**; the index identifies upstream
commit `4eaee87548250b2682affda7d05d947c05554bae`. Put
`OLD=campaigns/9000048` and
`SRC=OLD/research/openai_manuscript/`
`A-singular-normal-affine-surface-with-free-tangent-sheaf-September-23-2026`.

The full `SRC/build/06-algebraization.tex` and the full
`OLD/research/algebraization_audit/report.md` were read, along with the
complete verifier, certificate, controls and saved typed-Jacobian evidence.
All versions of every assigned ledger claim, the corresponding routes,
source-assumption records and graph review status were inspected. The
old audit proof is attributed to **`engineer:gpt-6-astra`**. Source excerpt
notes and nominal `reviewer:gpt-6-astra` judgment labels do not constitute
an applicable native acceptance receipt.

The index/parent provenance result authenticates the **14 core
source/certificate artifacts** against the preserved snapshot. The other
**97 artifacts have manifest size matches only**; they are not silently
represented as snapshot-hash-verified. No old file, active mathematical
ledger, proof graph, pipeline record or other unit was modified.

## 1. Claim, hypotheses and scope

For a **normal complex analytic local germ** \((X,x)\), with
\(\dim\mathcal O_{X,x}=d\ge1\), smooth away from \(x\), suppose its **full
holomorphic tangent module**, not just a pair of selected fields or a
generic frame, is free of rank \(d\). The claim is that there exist a
finitely generated **normal integral** \(\mathbb C\)-algebra \(A\) and a
maximal ideal \(\mathfrak p\), with
\[
\dim A=d,\quad A/\mathfrak p=\mathbb C,\quad
\widehat{A_{\mathfrak p}}\simeq\widehat{\mathcal O_{X,x}},\quad
\operatorname{Der}_{\mathbb C}(A)\simeq A^d,
\]
and \(\operatorname{Spec}A-\{\mathfrak p\}\) smooth.
If \(x\) is singular, \(A_{\mathfrak p}\) is nonregular.
The completion isomorphism is a continuous local \(\mathbb C\)-algebra
isomorphism. The claim does **not** identify the original analytic local
ring with an algebraic ring, or give explicit global defining equations.
The smooth case is included.

| Indexed claim | Latest | Assessment |
|---|---:|---|
| `M_algebraization` | v3 | Supported general implication, conditional on the exact hypotheses above. |
| `AG_analytic_completion` | v8 | Supported for finite analytic presentations and continuous Jacobian kernels. |
| `AG_exact_etale_model` | v7 | Supported: exact Artin solution, all identities at one pointed stage, correct completion. |
| `AG_tangent_descent` | v3 | Supported using a finite ordinary algebraic presentation before completion. |
| `AG_principal_shrink` | v7 | Supported for one principal neighborhood carrying the entire chosen basis and all ring properties. |
| `A_algebraization_literature` | v1 | Historical inventory, not a theorem; its omnibus “unexamined” role is replaced by the precise read inputs below. |

The dependency on `fixed-relation-determinacy` is substantive: its
`report.md` checks the three losses, fixed relation precision, and
convergence of both coordinate and generator changes. No
complete-intersection condition at \(x\) is inserted.

## 2. Analytic completion and the finite-support assertion

Write \(S=\mathbb C\{x_1,\ldots,x_e\}/I_{\rm an}\).
Noetherianity supplies a finite equation row \(f\) and **all** its
syzygies in a finite matrix \(D\) over the convergent ambient ring.
Exactness of completion on finite modules gives the full original
presentation over \(P=\mathbb C[[x]]\), with \(R=\widehat S=P/(f)\).

Coherence applies to the analytic conormal dual and to the cokernel of
the ambient-tangent-to-normal map. At each smooth point, analytic
coordinates for the regular embedding identify normal coordinate
functions and make this map surjective. Thus the **cokernel**
\[
T^1_{\rm an}=
\operatorname{Hom}_S(I_{\rm an}/I_{\rm an}^2,S)/
\sum S\,\overline{\partial_jf}
\]
has analytic support contained in \(\{x\}\).
It is **not** claimed that the conormal module or its dual themselves
have finite support. They generally do not.

For this finite coherent module, its annihilator has isolated zero-set
germ, unless the module is zero. The analytic local zero-set theorem
then gives radical equal to the maximal ideal; Noetherianity gives
\(\mathfrak m_S^bT^1_{\rm an}=0\) for some \(b\).
It follows that the module has finite length. Exact completion,
including the finite kernels defining Hom, identifies its completion
with the \(K/J\) required by determinacy. This is the precise reason
an isolated analytic singularity supplies the finite-length hypothesis.

The local analytic Nullstellensatz used in this step, and again for the
Fitting ideal, is an external standard input. Its exact required form
is recorded in §7 and in `verdict.json`; it is not proved by the checker.
Grauert's archived p.15 proof explicitly invokes the local
Nullstellensatz, while its p.16 supplies coherence. The archived
passage is not falsely described as a separately numbered general
Nullstellensatz statement.

The finite **holomorphic** differential presentation has generators
\(dx_j\) and relations \(df_i\). Its dual, after flat completion, is
\[
\ker(R^e\longrightarrow R^s),\qquad
(v_j)\longmapsto\sum_jv_j\overline{\partial_jf}.
\]
This is exactly \(\operatorname{Der}^{\rm cont}_{\mathbb C}(R,R)\):
the variables determine a continuous derivation, polynomial chain rule
passes to the adic limit, and the displayed conditions annihilate the
finitely generated ideal. The given **full** analytic tangent freeness
therefore gives this kernel \(R^d\).

Cutkosky **arXiv:1206.4255v3**, Proposition **2.1(1)**, applies to any
complex analytic space at any point: \(S\) is Noetherian, Henselian and
excellent. Together with its assumed normality, Tag **0C23** makes
\(R\) normal; as a local normal ring it is a domain.
Tags **07NV** and **07NY** preserve dimension and regularity status.
Neither analytic excellence nor normal completion is inferred from
the finite symbolic certificate.

## 3. Exact approximation and one pointed étale stage

Set \(Q_0=\mathbb C[x]_{(x)}\), \(H=Q_0^h\).
Tags **04GN** and **06LJ** give the same residue field and
\(\widehat H=P\); faithful flatness embeds \(H\) in its completion.
The actual **Artin Theorem 1.10** is applicable with base field
\(\mathbb C\), henselization at the indicated prime, and proper ideal
\((x)H\). Apply it to the finite polynomial system
\[
\sum_iG_iB_{i\nu}=0\quad(1\le\nu\le t)
\]
in the \(s+st\) unknown entries, with formal solution \((f,D)\).
It returns an **exact** solution \((g,B)\) in \(H\), arbitrarily close
to \((f,D)\). It does not merely produce a polynomial truncation whose
product vanishes to high order. Precision at least \(\max(n_0,N)\)
is sufficient for the checked determinacy theorem, giving
\(P/(g)\simeq P/(f)\). In particular \(g\) vanishes at the marked point.

The henselization is the filtered colimit of the pointed étale pairs
with unchanged residue field. A finite tuple is represented at one
stage, but this alone is insufficient: each of the finitely many
zero-product identities becomes zero at a later stage, and
filteredness gives **one common later pointed stage**. This uses the
equality criterion in the proof of Tag 04GN, not an unjustified
injection of each stage into the colimit.

Tag **00U2(10)** spreads an étale algebra over \(Q_0\) to one over
\(\mathbb C[x]\). Finitely many denominators represent the entries;
further denominators kill the finitely many identity numerators.
Their product is nonzero at the point. Localization/composition
preserve étaleness. Thus one finite-type affine étale algebra \(E\)
contains the represented pair with its exact identities and a marked
\(\mathbb C\)-point \(\mathfrak q\).

The equality \(\widehat{E_{\mathfrak q}}=P\) is compatible with the
chosen map to \(H\). In an étale presentation, Tag **00U9** gives an
invertible square auxiliary-variable Jacobian; unique lifts through
successive nilpotent quotients identify all Artinian local
quotients. Tag **00U4** gives
\((x)E_{\mathfrak q}=\mathfrak qE_{\mathfrak q}\), and the residue
fields coincide. Passing to inverse limits gives the asserted
pointed completion, not an identification of henselization with
completion.

For \(A'=E/(g)\), \(\mathfrak p'=\mathfrak q/(g)\),
\(T=A'_{\mathfrak p'}\), exact completion now gives
\[
\widehat T=P/(g)\simeq R,\qquad T/\mathfrak m_T=\mathbb C.
\]
The two uses of exactness--finite algebraic equations and exact
identities at a stage--are separate and both are justified.

## 4. Finite ordinary differentials, chain rule and faithful-flat descent

Because \(E\) is étale over \(\mathbb C[x]\),
\(\Omega^1_{E/\mathbb C}\) has basis \(dx_1,\ldots,dx_e\).
One may see both spanning and independence by solving for the
auxiliary \(dz\)'s with the invertible Jacobian. Quotient and
localization give a **finite ordinary algebraic** presentation of
\(\Omega^1_{T/\mathbb C}\) by the \(dg_i\).
The coordinate derivations lower the maximal-ideal filtration by at
most one, so extend to the completion and have the formal partial
derivatives as their completed coefficients.

Dualizing a finite presentation expresses Hom as a finite matrix
kernel. Flat base change preserves this kernel, giving
\[
\operatorname{Der}_{\mathbb C}(T)\otimes_T\widehat T
\simeq\operatorname{Der}^{\rm cont}_{\mathbb C}(\widehat T,\widehat T).
\]
No assertion is made that the ordinary Kähler module of the formal
power-series ring is finite or equals its continuous quotient.
Finite generation of \(\Omega_{T/\mathbb C}\) is legitimate because
\(T\) is essentially of finite type.

The generator-change term in the formal chain rule was checked, not
silently dropped. With \(f=\Phi(g)U\), \(J_f=(\partial_kf_i)\)
an \(e\)-by-\(s\) matrix and
\(A_{kj}=\partial_k\Phi(x_j)\),
\[
J_f=A\,\Phi(J_g)U+Q,\qquad
Q_{ki}=\sum_l\Phi(g_l)\partial_kU_{li}.
\]
\(Q\) is generally nonzero **before** quotienting. Modulo
\((f)=\Phi((g))\), it vanishes. Both \(A\) and \(U\) are invertible;
transport of coefficients by \(\Phi\) and \(v\mapsto vA\) give the
correct kernel correspondence. This also transports the finite
continuous differential presentations and their Fitting ideals.
The saved arity-\((4,3)\) identity is support; the indexed chain rule
is the arbitrary-arity argument.

Thus the finite module \(M=\operatorname{Der}_{\mathbb C}(T)\) has
\(M\otimes\widehat T\simeq\widehat T^d\).
Its residue dimension is \(d\). Lift a residue basis and use Nakayama
to get \(T^d\twoheadrightarrow M\). After completion this is a
surjection of free rank-\(d\) modules over a local ring, hence has
unit determinant and is an isomorphism. Flatness completes its
kernel to zero; **faithful** flatness detects its vanishing.
Therefore \(M\simeq T^d\). Individual analytic or formal coefficients
need not descend: it is freeness of this finite algebraic module
that descends.

The same faithfully flat map embeds \(T\) in its normal domain
completion. Hence \(T\) is a domain. If \(a/b\in\operatorname{Frac}T\)
is integral over \(T\), it lies in the normal \(\widehat T\), so
\(a\in b\widehat T\cap T=bT\); this proves normality of \(T\).
Dimension and \(\mathfrak m/\mathfrak m^2\) are preserved by
completion, so \(T\) has dimension \(d\) and has the original
regularity/nonregularity status. Normality of an arbitrary initial
affine algebra is not assumed.

## 5. One principal affine neighborhood with the full basis

All the following operations are localizations away from
\(\mathfrak p'\); none changes \(T\).

1. The finite module \(\operatorname{Der}_{\mathbb C}(A')\)
   localizes to \(\operatorname{Der}_{\mathbb C}(T)\), by the
   finite differential presentation. Represent **all \(d\) basis
   elements** after finitely many denominators. Their map from a
   free module has finite kernel and cokernel, both zero at
   \(\mathfrak p'\). Products of annihilators outside
   \(\mathfrak p'\) kill both modules on a principal open.
   This gives a single global frame there, not only pointwise
   local freeness.
2. The finite nilradical vanishes at \(\mathfrak p'\); kill it
   similarly. Exactly one minimal prime is contained in
   \(\mathfrak p'\), by localization to the domain \(T\).
   For each other component choose an element of its minimal prime
   outside \(\mathfrak p'\) and invert their product. The resulting
   ring \(B_0\) is reduced and irreducible, hence a domain.
3. This finite-type \(\mathbb C\)-domain has dimension \(d\) by
   **00OS**, since the retained point is closed and its local ring
   is \(T\). By **07QW** and **07QV**, its normalization is finite.
   Normalization commutes with localization, and \(T\) is normal;
   the finite quotient \(\overline{B_0}/B_0\) vanishes at the
   marked point. Kill it by another denominator. This restricts
   to an open where the original ring is normal; it does not
   replace \(T\) by a different normalization.
4. On the analytic side the zero set of
   \(\operatorname{Fitt}_d(\Omega^{\rm hol}_{S/\mathbb C})\)
   is the nonsmooth locus. Isolatedness and the analytic local
   zero-set theorem give
   \(\mathfrak m_S^b\subset\operatorname{Fitt}_d(\Omega^{\rm hol})\);
   in the smooth case the Fitting ideal is the unit ideal.
   Fitting ideals commute with base change. The finite Jacobian
   comparison, formal chain rule, and faithful-flat contraction
   give
   \[
   \mathfrak m_T^b\subset
   \operatorname{Fitt}_d(\Omega^1_{T/\mathbb C}).
   \]
   On an integral \(d\)-dimensional finite-type neighborhood,
   **00OT** gives topological \(\dim_y X=d\) for every \(y\).
   This is not the generally smaller Krull dimension of
   \(\mathcal O_{X,y}\). The minor criterion for
   \(\operatorname{Fitt}_d\), followed by the exact **00TT**
   differential-generator criterion, identifies its vanishing
   set with the nonsmooth locus.
5. Any component of this closed nonsmooth locus through the
   marked point is that singleton: its generic prime would
   localize to a prime of \(T\) containing \(\mathfrak m_T^b\),
   hence to \(\mathfrak m_T\), and therefore would already be
   \(\mathfrak p'\). Remove all components not through the point;
   in the smooth case remove all nonsmooth components.

Only finitely many elements outside \(\mathfrak p'\) have been
inverted. Clear denominators in those elements and multiply their
numerators and the already inverted factors in \(A'\). Their
product \(s\notin\mathfrak p'\) defines the **one principal affine
open** \(A=A'_s\). It simultaneously retains normal integrality,
dimension, the marked residue field and completion, the nonregular
local ring when present, smooth complement, and the full tangent
basis. Every later localization preserves the earlier basis by
the same finite differential presentation.

These checks justify the smooth case as well as the singular case.
They do not require a separate choice of incompatible neighborhoods
for different asserted properties.

## 6. Complete version history and route reconciliation

Within each claim all versions have the same natural-statement hash
and empty `formal_statement`; the changes are assumption metadata,
not new mathematical results. The following table assesses **every**
indexed version, not just the largest version number.

| Claim/version | Added source metadata and assessment |
|---|---|
| `M_algebraization` v1 | General assertion without explicit assumptions. Its statement is supported retrospectively by §§2--5, not by its original bare status. |
| v2 | Adds omnibus `Algebraization_inputs`. This alone concealed the analytic finite-length assertion, exact étale descent, finite differential comparison and shrinking obligations. Same supported statement, not an adequate stand-alone certificate. |
| v3, latest | Retires the omnibus placeholder and routes through the explicit AG obligations. Supported; foundational propositions have not been eliminated. |
| `AG_analytic_completion` v1 | Full statement introduced without proposition-level metadata. Supported retrospectively with the exact analytic hypotheses. |
| v2 | Adds `AG_completion_exact` (00MA). Necessary but alone not normal-completion support. |
| v3 | Adds `AG_completion_faithful` (00MC). Same supported statement. |
| v4 | Adds `AG_completion_dimension` (07NV). Same supported statement. |
| v5 | Adds `AG_completion_regular` (07NY). Same supported statement. |
| v6 | Adds `AG_normal_completion` (0C23); its normal-formal-fibre hypothesis still needs checking. |
| v7 | Adds `AG_analytic_excellence` (Cutkosky v3, 2.1(1)), providing that hypothesis without presupposing algebraicity. |
| v8, latest | Adds the historically reviewed `AN_analytic_local_algebra` coherence input. Supported as checked in §2; finite support is for the cokernel, not the conormal module. The local analytic zero-set input is made explicit in this assessment. |
| `AG_exact_etale_model` v1 | Exact solution and one-stage claim introduced without source-specific metadata. Supported retrospectively by §3. |
| v2 | Adds original `AG_artin_approximation` (Theorem 1.10). Exactness is in \(H\), not merely modulo an ideal. |
| v3 | Adds `AG_hensel_colimit` (04GN), including the common-stage equality criterion. |
| v4 | Adds `AG_hensel_completion` (06LJ). Does not identify \(H\) itself with \(P\). |
| v5 | Adds `AG_etale_presentation` (00U9). Supports the ambient finite Jacobian and nilpotent-lifting argument. |
| v6 | Adds `AG_etale_spread` (00U2). Only finitely many denominators/identities occur. |
| v7, latest | Adds `AG_etale_maximal_ideal` (00U4). The full package supports the marked compatible completion and the exact finite-type stage. |
| `AG_tangent_descent` v1 | Finite/continuous kernel distinction already present; supported retrospectively by §4, not by unproved descent of a chosen formal basis. |
| v2 | Adds faithful-flat completion (00MC). Same supported statement. |
| v3, latest | Adds étale presentation (00U9). Supported with the full chain-rule term before quotienting and finite-kernel base change. |
| `AG_principal_shrink` v1 | Whole one-open claim introduced; supported retrospectively by §5. |
| v2 | Adds faithful-flat completion (00MC). Necessary locally, not enough alone for normal global shrinking. |
| v3 | Adds finite-type excellence (07QW). Same supported statement. |
| v4 | Adds Nagata/finite normalization (07QV). Supports the finite quotient used to find the normal open. |
| v5 | Adds dimension at a closed point (00OS). Same supported statement. |
| v6 | Adds topological dimension at all points (00OT). Distinct from local-ring dimension. |
| v7, latest | Adds smoothness/differential-generator criterion (00TT). Supported with the Fitting ideal argument and one final product of denominators. |
| `A_algebraization_literature` v1, only | A historical list explicitly called “unexamined,” not a mathematical theorem or a reason to bypass source checking. The later exact passages discharge the usable inputs at Engineer level; 07QY/07QZ merely corroborate, and 0A1W is unnecessary. Native attribution remains pending. |

Statement hashes:

* `M_algebraization`: `1fc67f3bbd2341b79a907c880a0739fa8d8670f137121daa22405f37ea474ff8`.
* `AG_analytic_completion`: `53a5232651a2ae98f8b094ba36fc062a2c7c3b2231246e1dbdc7c6dc55aded65`.
* `AG_exact_etale_model`: `c5e38398a4f5ceb24e0d2198f601db125add55d433d2ae825d2c2ded95ae35f8`.
* `AG_tangent_descent`: `b0190a793eb06277ab98c3a6e78db7ce72e10c68e18309b247047543b995b1c8`.
* `AG_principal_shrink`: `1841107cd3bbd75cfbfe0bd141ce5e6c12281c6c9d6b2ffffd84ae80d3ea6503`.
* `A_algebraization_literature`: `0f15aa2bd0e5edb1744c526084a10b2b9965ff3a41eb271fcd8d495d70e0a032`.

The coarse `R_M_algebraization` scaffold was retired for decomposition,
not refuted. `R_AG_algebraization` explicitly needs determinacy plus
analytic completion, exact model, tangent descent and shrinking;
`R_AG_exact_model`, `R_AG_tangent` and `R_AG_shrink` expose their
dependencies. The independently checked twisted-cubic perturbation
retires `R_AG_equations_only`: it is a failed equation-only strategy,
not evidence against the actual manuscript route.

## 7. Exact external propositions actually read

Unless otherwise specified, archived passage paths below are under
`OLD/research/literature/algebraization_sources/`. The source IDs,
precise statements, locators, passage paths and application assessments
are separately machine-readable in `verdict.json`.

### Original named sources

* **Artin, doi:10.1007/BF02684596, Theorem 1.10**, printed p.26,
  PDF p.5: base ring a field or excellent DVR; henselization of a
  finite-type algebra at a prime; any proper ideal; finite
  polynomial system over that henselization; a solution in the
  corresponding completion; arbitrary prescribed approximation
  order. Conclusion: an **exact solution in the henselization**.
  Read the actual statement in `artin_1969.txt`, lines 160--175,
  and compared `artin_approximation_excerpt.txt`. The chosen field,
  local ring, ideal and finite system meet these hypotheses.
  Stacks 07QY/07QZ are not substituted for this theorem.
* **Cutkosky, arXiv:1206.4255v3, 2 December 2016, Proposition
  2.1(1), numbered/PDF p.4**: every complex analytic local ring
  is Noetherian, Henselian and excellent. Read the actual page
  in `cutkosky_excerpt.txt` and compared
  `cutkosky_excellence_excerpt.txt`. No isolatedness or
  algebraicity hypothesis is required. The manuscript bibliography
  cites the 2017 journal article, doi:10.1016/j.jpaa.2016.07.007;
  that journal version/pagination was **not** independently
  inspected. Support here is attributed to the actually read v3
  proposition, not to an uninspected journal passage.
* **Grauert, doi:10.1007/BF02684746**, §1.6 Satz 4/proof,
  p.15, and §2.1 Definition 3/properties (a)--(c), p.16,
  read in `OLD/research/literature/grauert_1960_local_algebra_pages.txt`.
  The coherent structure sheaf and closure under kernels,
  cokernels, images, tensor product and Hom apply to analytic
  presentations. The exact local zero-set consequence needed is:
  if a proper ideal of a complex analytic local ring has only
  the marked point as zero-set germ, its radical is the maximal
  ideal. Finite generation then puts a power of that maximal ideal
  in the ideal. Grauert's proof invokes the local Nullstellensatz;
  it does not state this as a separately numbered theorem.
* **Hironaka 3.3 and Artin 3.8--3.9** were read in the original
  extracted passages and `historical_equivalence_excerpt.txt`;
  exact setup, pagination and attribution are assessed in the
  companion determinacy report. They establish historical
  equation-and-relation algebraization methods. They do not
  establish novelty of the old audit or replace its finite-module
  tangent descent.

### Exact Stacks propositions

The entire archived `stacks_inputs.txt` was read. For every proposition
actually used in the proof, its current primary tag was also opened
and its statement checked (the 04GN proof additionally gives the
common-stage equality construction).

| Tag, locator | Exact scope needed and checked |
|---|---|
| **00IN**, Lemma 10.51.2 | Noetherian ring, ideal, finite submodule: Artin--Rees filtration equality for all sufficiently large orders. Used three times in the companion unit. |
| **00MA**, Lemma 10.97.1(1)--(3) | Noetherian ring and ideal: exact completion on finite modules; completed finite modules equal tensor product with the completed ring. |
| **00MC**, Lemma 10.97.3 | Ideal in the Jacobson radical of a Noetherian ring: faithfully flat completion; applies in particular to both local rings used here. |
| **07NV**, Lemma 15.44.1 | Any Noetherian local ring and its maximal-ideal completion have equal Krull dimensions. |
| **07NY**, Lemma 15.44.4 | Such a ring is regular iff its completion is regular. |
| **0C23**, Lemma 15.53.6 | Normal Noetherian local ring with normal formal fibres has normal completion; excellent/quasi-excellent is an indicated sufficient hypothesis. |
| **04GN**, Lemma 10.155.1 and proof | For a local ring, henselization is the filtered colimit of pointed étale pairs with unchanged residue field; represented equalities hold at a common later pointed stage. |
| **06LJ**, Lemma 15.46.3 and part (b) | Noetherianity of a local ring is equivalent to that of its henselization; the henselization has the same completion. |
| **00U9**, Lemma 10.143.2 | Étale maps admit a square presentation with invertible auxiliary Jacobian. |
| **00U2**, Lemma 10.143.3(1)--(3),(9)--(10) | Localization, composition and base change preserve étaleness; an étale algebra over a localization spreads to an étale algebra over the base. |
| **00U4**, Lemma 10.143.5 | At an étale point over \(\mathfrak p\), \(\mathfrak pS_{\mathfrak q}=\mathfrak qS_{\mathfrak q}\), and residue extension is finite separable. The chosen pointed pair has equal residue fields. |
| **07QW**, Proposition 15.53.3(1),(5) | Fields and their finite-type algebras are excellent. |
| **07QV**, Lemma 15.53.5 and proof | Quasi-excellent rings are Nagata; a quasi-excellent domain is N-1, so its normalization is finite. |
| **00OS**, Lemma 10.114.4 | Finite-type domain over a field: global dimension equals dimension at every maximal ideal. |
| **00OT**, Lemma 10.114.5(1)--(2) | Topological dimension at a point is the maximum dimension of components through it. |
| **00TT**, Lemma 10.140.3 | Finite-type algebra over a field: smoothness at \(y\) iff the fibre dimension of its differential module is at most \(\dim_y X\), equivalently equal to it; smooth local ring is regular. |

The old inventory also lists **07QY**, **07QZ** and **0A1W**. Their
archived statements were read: the first two corroborate approximation
for local G-rings, while the last characterizes algebraic elements
in a completion. None is needed in place of original Artin 1.10 or
for descending the finite tuple by filtered colimits. The archived
warning that 033U, 00T2, 07S9 and 00PZ were unrelated lookup results
is retained; those are not used as evidence.

## 8. Historical review, arithmetic support and limits

The actual historical native receipt
`$WORKSPACE/.argus-campaign-9000048/projects/46e84e6fea35/`
`handoffs/8ba02f2780af/round-0001.json`
was read, together with its `mission.json`.
It is a `round_reviewed_handoff`, producer role `reviewer`, status
`done`. It accepts the **bounded analytic** proposition from its two
accepted prerequisites; its mission explicitly leaves **algebraization,
originality and campaign significance open**. The graph associates it
with `AN_analytic_endpoint` v1, statement hash
`1531f89efb456f715fa8783d219c4cd52895a1b929c67ffbea4470b09d6edd25`.
That exact input supplies the genuinely singular normal analytic
surface, smooth complement and full free rank-two holomorphic tangent
module for the conditional application. It is not approval of any AG
claim. No upstream geometry was re-audited here.

The algebraization ledger's nominal reviewer judgments reference the
same report, and its literature records are JSON excerpt notes with
no receipt fields. The graph has **`AG_independent_review` open**,
`reviewer_confirmed=false`, and **`M_main` open**. The old report's
opening assertion that the proposition is valid is an Engineer
conclusion, not native approval.

Because an applicable receipt is absent, finite support was freshly
replayed once, shared with the companion unit. Evidence:
`research/draft_reviews/fixed-relation-determinacy/evidence/replay.py`
and `replay.json`. The result is **107 exact assertions, 13 symbolic
universal-inequality certificates, all 18 corrupted assertions rejected**;
the separate invalid CLI certificate exits **1** at the expected
relation-error field. Successful environment: existing
`$WORKSPACE/miniconda3/bin/python3`, **3.13.5**, **SymPy 1.14.0**,
with bytecode disabled. The initial Argus-interpreter attempt lacked
SymPy; no packages were installed, and no Argus module was invoked.
Runtime was **3.184403 s**. All new outputs/cache destinations stayed
inside the owned determinacy evidence directory; selected old inputs
have identical before/after hashes.

The saved typed product's contract/payload/output/run were read. It
only multiplies a generic two-by-two matrix \(1+C\) by its adjugate:
server **0.14.0**, protocol **2025-11-25**, adapter exit **0**, no
timeout/structured error, **26 ms**. The current replay did **not**
execute its saved-Jacobian check, import a Jacobian module, or call
an adapter. Any current adapter operation belongs to the parent.

The exact algebra supports order estimates, matrix cancellation,
the finite first-jet chain rule, a Cauchy--Binet instance, quotient
Leibniz, and the failed equation-only route. It does **not** prove
Artin approximation, analytic coherence/excellence, finite support,
all-rank descent, arbitrary formal convergence, normalization
finiteness, or the one-open argument. Those are the prose and
source-dependent checks above. No Lean compilation or kernel proof
is present or claimed.

## 9. Conclusion and concrete outstanding obligations

No mathematical gap was found in the **general implication under its
stated hypotheses**, with the external analytic local zero-set input
made explicit. This is justified support, not a blanket assertion
that the manuscript is correct. The existence of the analytic
counterexample is an upstream dependency; the conditional use of
its version-matched historical receipt does not accept the current
family's other reviews.

Two concrete recording/review obligations remain:

1. A native independent Reviewer must examine the general prose
   proof, source applications and this assessment. The nominal old
   reviewer labels, the historical analytic receipt and fresh
   arithmetic cannot close `AG_independent_review` or `M_main`.
2. The exact analytic local zero-set implication used for the finite
   support and Fitting steps should be recorded as an external input,
   not silently hidden inside a coherence assumption. Its precise
   statement and the limitation of the archived Grauert invocation
   are supplied here; this is a source-recording obligation, not a
   discovered counterexample.

The accessible Cutkosky v3 attribution, rather than a claim to have
read the journal pagination, is already explicit. No missing explicit
affine equation list is counted as a flaw in this existential
proposition. Originality, the logarithmic Kodaira corollary,
derivation blowups and family acceptance are outside this unit.

## 10. Parent's resolution of the exact zero-set source obligation

The source-recording obligation in sections 2, 7 and 9 was subsequently
resolved by a targeted primary-source lookup, not by weakening the
finite-length hypothesis. The historical hostname failed HTTPS
certificate hostname verification; verification was not disabled.
The author's current institutional hostname supplied the original PDF:
<https://www-fourier.univ-grenoble-alpes.fr/~demailly/manuscripts/agbook.pdf>.
Its title page explicitly identifies **Jean-Pierre Demailly, Complex
Analytic and Differential Geometry, version Thursday June 21, 2012**.
The downloaded PDF and its extracted text remain beside this report.

Read **Chapter II, section 4, (4.22), Hilbert's Nullstellensatz, printed
p.97**, including its proof and the distinction from real analytic
germs. It states \(I_{V(J),0}=\sqrt J\) for every ideal
\(J\subset\mathcal O_n\), where \(\mathcal O_n\) is the local ring of
holomorphic germs on \(\mathbb C^n\). The exact passage is preserved in
`demailly_nullstellensatz_excerpt.txt`.

For \(S=\mathcal O_n/I\) and a proper ideal \(\mathfrak a\subset S\)
whose zero-set germ is just the marked point, lift \(\mathfrak a\)
to \(J\subset\mathcal O_n\). The theorem gives
\(\sqrt J=(z_1,\ldots,z_n)\), hence
\(\sqrt{\mathfrak a}=\mathfrak m_S\). If its finitely many maximal-ideal
generators \(x_i\) satisfy \(x_i^{k_i}\in\mathfrak a\), every monomial
of degree \(1+\sum_i(k_i-1)\) contains one such power. Thus a single
power of \(\mathfrak m_S\) is contained in \(\mathfrak a\).
Apply this to the annihilator of the finite coherent cokernel for the
finite-length conclusion, and to the isolated Fitting locus for the
Fitting containment. These are exactly the two uses in the argument.

`verdict.json` now names this actual dated primary proposition rather
than treating Grauert's invocation as its full statement. This resolves
the specific source-recording obligation; native independent reading
remains pending. It does not certify every previously unavailable
Demailly locator or require replay of unchanged symbolic calculations.
