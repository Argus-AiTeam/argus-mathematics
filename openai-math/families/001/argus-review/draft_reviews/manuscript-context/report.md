# Manuscript context and dependency classification

**Contribution type:** `source_context_and_dependency_classification`  
**Novelty status:** `not_claimed`  
**Independent review:** `pending_native_reviewer`  
**Role:** Engineer contributor, not independent Reviewer. No finding or family completion is self-accepted.

## Scope and evidence

This unit explicitly classifies all 16 assigned graph/ledger IDs. It does not undertake a new manuscript-error search or certify the whole paper. The developed Argus prescribed-filtration realization argument and the finite-descent/source-failure assessments belong to the other assigned units. Mathematical obligations below describe what would be needed for independent theorem verification; they are **not requirements to prove additional source-context claims before completing this old-draft review**.

Locator abbreviations:

- **O** = `campaigns/9000001`, read-only.
- **G** = `O/research/PROOF_GRAPH.json`.
- **L** = `O/research/MATH_STATE.json`.
- **S** = `O/research/openai_manuscript/Milnes-rationality-conjecture-for-abelian-varieties-October-7-2026`.
- Section filenames below mean `S/build/sections/<filename>`.
- **A** = `O/research/prescribed-filtration-audit/realization_proof.md`.
- **I** = current `research/DRAFT_REVIEW_INDEX.json`.
- **V** = `campaigns/9100001/MANUSCRIPTS.json`.

All 15 mathematical MR statements are attributed to **OpenAI, _Milne's rationality conjecture for abelian varieties_, October 7, 2026**, revision **`4eaee87548250b2682affda7d05d947c05554bae`**, except that MR-CM-HODGE-EXTERNAL is the assertion used from a separately cited companion. `S/README.md:3-5` and `S/build/main.tex:51-53` establish author/date. All nine local TeX files match their existing SHA-256 entries in V; no new manifest or archive was made. The companion's bibliography entry is OpenAI, _The rational Hodge conjecture for CM abelian varieties_, **October 6, 2026** (`references.tex:236-241`); its text was not supplied in this reference tree or independently verified here. C9000001 is an Argus historical goal, not an OpenAI theorem. Every assigned ledger record is version 1.

L contains **30 versioned entries, 23 distinct claim IDs**. G has **25 nodes**: these 16, seven PF IDs, and two failed-shortcut IDs. The 16 assigned records have empty formal statements. The **20 historical evidence entries** in `L:535-775` concern PF claims or six external geometric/admissibility assumptions, not any of these 16 IDs. G's file pointers and the R-MR decompositions locate source context; they do not supply independent proofs. A explicitly restricts its result to realization, not Milne rationality (`A:3-23`), and assumes a fixed strongly admissible auxiliary datum (`A:54-77`).

### Actual reference-directory inventory

The named manuscript subdirectory is a symlink to the source directory already identified in V. Inventorying its target through the named input, excluding `.git`, `__pycache__`, and `.pyc`, gives exactly **10 regular files**, all already named in `I:125-133`. There are **no additional files absent from that initial inventory and no additional Argus drafts**.

| File relative to S | Purpose |
|---|---|
| `README.md` | OpenAI attribution, October 7 date, citation, and bibliographic previous-version link. |
| `build/main.tex` | TeX build driver, theorem environments, title/author/date, abstract, six section inputs and bibliography input. |
| `build/references.tex` | Bibliography and versioned citations, including the separate CM Hodge companion. Not proof evidence for its cited theorems by itself. |
| `build/figures/two-transports.tex` | Diagram distinguishing CM transport from prescribed-filtration transport; no extra theorem or certificate. |
| `build/sections/00_intro.tex` | Exact main pairing theorem, scope, antecedents and distinction from algebraic specialization. |
| `build/sections/01_preliminaries.tex` | Comparison conventions, rational Lefschetz space, pairing pullback and prescribed-map lifting. |
| `build/sections/02_transport.tex` | Auxiliary datum, both transport alternatives, realization input and common rational normalization. |
| `build/sections/03_filtration.tex` | Constrained weakly admissible filtration construction and its admissibility/divisor-condition corollaries. |
| `build/sections/04_weil.tex` | Balanced Weil space, orthogonality/invertibility dichotomy, group, divisor span and assembly. |
| `build/sections/05_reduction.tex` | CM-to-Weil reduction, main-proof assembly and specialization consequences. |

No PDF is present in this inventory. `README.md:1` links to `paper.pdf`, and V's `pdf` field names it, but V records no PDF source. This limits artifact availability, not access to the mathematical statements: the version-matched TeX is available evidence. The September 23 PDF at `README.md:21` is only a previous-version link, not an extra inventoried draft. The figure's two branches (`two-transports.tex:8-28`) are explanatory source material, not separate Argus results.

### Common mathematical conventions

Fix a prime \(p\), \(\overline{\mathbb Q}\subset\mathbb C\), and a \(p\)-adic place \(w\). Put \(\mathbb F=\overline{\mathbb F}_p\), \(K_0=\operatorname{Frac}W(\mathbb F)\), and \(C_w=\widehat{\overline{\mathbb Q}}_w\). Good reduction allows finite number-field/local extensions. Prime-to-\(p\) realizations have coefficients \(k_\ell=\mathbb Q_\ell\); the crystalline component used in the pairing statements is extended to \(k_p=C_w\). Traces include the top Tate twist and send a zero-cycle class to its degree (`00_intro.tex:18-56`; `01_preliminaries.tex:10-45`).

\(\operatorname{Lef}^r(X)\) is the rational divisor-product space modulo numerical equivalence. A tuple \(\alpha=(\alpha_v)_v\) has the **Lefschetz pairing property** if, for each fixed \(\delta\in\operatorname{Lef}^{\dim X-r}(X)\), all \(\operatorname{Tr}_v(\alpha_v\delta_v)\) are the images of one rational number. A **simultaneous rational Lefschetz class** is the tuple from one element of \(\operatorname{Lef}^r(X)\), not merely a tuple lying in each local divisor span (`01_preliminaries.tex:86-115`).

Finite local-field descent means descent of the isocrystal **and indicated tensors** to the maximal unramified subfield \(H_0\) of some finite \(H/\mathbb Q_p\), and of its filtration to \(H\), before extension to \(K_0H\) (`02_transport.tex:25-33`). This hypothesis must not be silently replaced by existence over an arbitrary finite extension of \(K_0\).

## Classification of every assigned ID

The following are normalized mathematical transcriptions of the source assertions, not claims that Argus independently established them. OpenAI attribution and the October 7 source revision above apply to each local MR assertion. Each entry states the particular obligation not discharged by existing Argus evidence.

### 1. C9000001 — historical campaign goal

**Records:** `G:37-48`; `L:28-42`, CTX9000001 v1 at `L:3-12`.

**Exact scope of the record.** The old campaign sought either (a) a certified explicit mathematical flaw, sign/orientation error, intermediate counterexample, or statement-fidelity/citation gap in OpenAI Family 001, with a deterministic `verify.py`/`exact_certificate.json` certificate, or (b) independent verification, repair or generalization of the manuscript's core theorem with a standalone machine-checkable certificate and independent Reviewer certification. The old mention of an unformalized manuscript is historical metadata, not a current instruction.

**Classification:** `historical_campaign_goal`. Its recorded dependency is MR-MAIN; `R9000001-VERIFY-MAIN` is a plan for that goal, not a theorem proof. The record is attributable to the old Argus campaign describing OpenAI's manuscript.

**Undischarged obligation/scope limitation.** No evidence item in L certifies this campaign-wide disjunction or the whole main theorem. Local PF algebra/geometry and a failed shortcut cannot by themselves fulfill that old goal. This review instead classifies the existing work under the current OBJECTIVE; it does not inherit the old requirement to find a fresh error or prove the paper.

### 2. MR-MAIN — common rational Hodge–divisor pairing

**Records:** `G:49-65`; `L:325-338` v1.  
**Source:** `00_intro.tex:29-56`, `thm:main`; explanatory scope `58-63`; assembly `05_reduction.tex:226-253`.

**Statement.** If \(A/\overline{\mathbb Q}\) has dimension \(d\) and good reduction \(A_0/\mathbb F\) at \(w\), \(0\leq r\leq d\), and \(\gamma\in H^{2r}(A(\mathbb C),\mathbb Q(r))\) is a rational Hodge class, then for every list of Cartier divisors \(D_1,\dots,D_{d-r}\) on \(A_0\) there is one \(q\in\mathbb Q\) such that
\[
 \operatorname{Tr}_v\!\left(\gamma_{0,v}\prod_i c_{1,v}(D_i)\right)=q
 \quad\text{for all }\ell\ne p\text{ and for }v=p.
\]
The crystalline equality is after extension to \(C_w\). For \(r=d\) the product is 1. The rational number depends on the fixed data; there is no assertion comparing different places.

**Classification:** `undeveloped_source_context`, not an independently developed Argus theorem or certified reproduction. G correctly records MR-CM-TRANSPORT, MR-CM-REDUCTION, MR-WEIL and MR-PULLBACK. The source inserts `cor:cm-pairing` (`05_reduction.tex:207-223`) between reduction/Weil and the main theorem, with elementary treatment of codimension zero/top.

**Undischarged obligation.** The full CM transport → balanced Weil reduction → Weil dichotomy → rational pullback assembly, with common realizations, is not certified by the local PF evidence. The companion CM Hodge theorem is **not** an assumption of this statement or its proof (`00_intro.tex:105-113`; `05_reduction.tex:370-373`). No refutation follows from the absence of an Argus proof.

### 3. MR-CM-TRANSPORT — CM branch, not prescribed filtration

**Records:** `G:66-79`; `L:339-352` v1.  
**Source:** `02_transport.tex:777-793`, `cor:cm-transport`; proof `795-814`; proposition's CM clause `35-63`; special-point step `681-692`.

**Statement.** For positive-dimensional good-reduction \(A/\overline{\mathbb Q}\) and rational Hodge \(\gamma\) of codimension \(0\leq r\leq\dim A\), there exist \(n>0\), a good-reduction CM abelian variety \(B/\overline{\mathbb Q}\), a rational Hodge class \(\kappa\) of codimension \(r\) on \(B\), and one special-fiber quasi-isogeny \(a:A_0^n\to B_0\) such that
\[
 \gamma_0=(aj)^*\kappa_0,
\]
simultaneously in every prime-to-\(p\) and extended crystalline realization; \(j\) is first-factor inclusion.

**Classification:** `undeveloped_source_context`. The recorded Aux/Normalization dependencies are only a compressed account. The source also uses the Mumford–Tate Hodge embedding, the trace-tensor construction, Kisin–Zhou **Theorem 2.2.7** for a tensor-preserving quasi-isogeny to a special-point lift, and algebraicity of special points. It does **not** obtain this branch from MR-PRESCRIBED-TRANSPORT or PF-REALIZATION.

**Undischarged obligation.** Existing Argus evidence does not verify this special-point-lifting application, its starting integral-model point, or its normalized common Hodge-class equality. Local marked realization of an admissible filtration is a different result. No same-dimensional CM lift or generic-fiber map from \(A\) is asserted.

### 4. MR-PRESCRIBED-TRANSPORT — downstream of local realization

**Records:** `G:80-95`; `L:353-366` v1.  
**Source:** `02_transport.tex:35-94`, `prop:transport(2)`, `eq:transport-class`, `eq:transport-prescribed-filtration`; application `694-711`; normalization `713-775`; full-tensor descent `662-679`.

**Statement.** Let \(A/\overline{\mathbb Q}\) be positive-dimensional with good reduction, \(V=H_1(A(\mathbb C),\mathbb Q)\), and \(G\subset\operatorname{GSp}(V,\psi)\) connected reductive with a Hodge embedding giving \(A\)'s Hodge structure. Let a rational Hodge class \(\gamma\) of codimension \(r\) be represented by an alternating form of multiplier \(c^r\). Suppose a degrees-\(0,1\) filtration \(\mathcal F_A\) on \(D_A=H^1_{\rm cris}(A_0)[1/p]\), over a finite extension of \(K_0\), is weakly admissible, has finite local-field descent with the specialized \(G\)-structure tensors, and geometrically lies in the original \(G\)-orbit under a tensor-preserving identification. Then for some \(n>0\), finite \(K/K_0\), auxiliary good-reduction \(B/K\), class \(\kappa\), and one \(a:A_0^n\to B_0\),
\[
 (aj)^*\kappa_0=\gamma_0,\qquad
 a^*\operatorname{Fil}^1H^1_{\rm dR}(B/K)
       =(\mathcal F_A^1)^{\oplus n},
\]
after a common finite extension. The first equality holds simultaneously. Hodge classes on the local lift use the specified complex embedding; realizations use canonical tensors and polarization.

**Classification:** `downstream_source_dependency_with_local_Argus_inputs`, not a separate Argus proof. G lists MR-AUX-DATUM, PF-WA, PF-REALIZATION and MR-NORMALIZATION. The source additionally constructs the starting isogeny, trace tensor, complete tensor descent and diagonal \(G\)-to-\(J\) orbit compatibility.

**Undischarged obligation.** Even a successful local realization audit would not itself establish that global preparation or the common rational normalization. Weak admissibility must be upgraded using the stated descent, not by omitting it. This unit leaves the other contributors' precise realization/descent assessments intact.

### 5. MR-AUX-DATUM — a source dependency assumed by local Argus geometry

**Records:** `G:96-106`; `L:367-380` v1.  
**Source:** `02_transport.tex:116-150`, `lem:auxiliary-datum`; definition `105-114`; construction/proof `152-249`.

**Statement.** Given a Hodge embedding \((G,X)\hookrightarrow(\operatorname{GSp}(V,\psi),X_{\rm Siegel})\), with connected \(G\) and multiplier \(c\), for every prime \(p\) there are a totally real \(P\), connected reductive \(J\), and Hodge embedding on \(W\) such that:

1. \(G\to J\to\operatorname{Res}_{P/\mathbb Q}G_P\), with \(G\) diagonal and \(J\) the equal-multiplier subgroup;
2. \(J_{\mathbb Q_p}\) is quasi-split and has a full connected stabilizer \(\mathcal J\) making the datum strongly admissible;
3. \(W\simeq(V\otimes_{\mathbb Q}P)^{\oplus m}\) for some \(m>0\), with common multiplier \(c\), and \(\mathcal J\) has a closed embedding on a self-dual \(\mathbb Z_p\)-lattice.

Strong admissibility includes \(R\)-smoothness of the relevant split-torus centralizer and a reduced relative root system when \(p=2\).

**Classification:** `source_dependency_of_local_realization`. A begins with this kind of fixed datum; it does not construct it from arbitrary \(G\). G's empty dependency list is not proof or absence of external input: the source uses splitting-field approximation, Kisin–Zhou earlier Lemma 4.2.4/Proposition 2.4.6 and 2025 Definition 2.1.6/Proposition 2.1.9, with explicit strong-admissibility checks.

**Undischarged obligation.** The isotypic restriction-of-scalars construction, connected full stabilizer, and adapted closed self-dual embedding uniformly including \(p=2\) remain source-level prerequisites, not consequences of the Argus matrix certificate. Novelty of this construction is not assessed.

### 6. MR-NORMALIZATION — a conditional intersection-number calculation

**Records:** `G:107-117`; `L:381-394` v1.  
**Source:** `02_transport.tex:713-775`, especially `eq:transport-local-similitudes`, `eq:transport-rational-similitude`, `eq:transport-eta-scaling`; tensors `643-658` and trace restriction `635-641`.

**Statement.** In the already constructed transport situation, write \(f_0:A_0^n\to C_x\), \(a=bf_0:A_0^n\to B_0\), \(\theta_*=f_0^*\theta_{C,0}\) rational ample, and \(D=n\dim A>0\). Preservation of \(u_\psi=\psi_W\otimes\psi_W^{-1}\) and \(u_\eta=\eta\otimes(\psi_W^{-1})^{\otimes r}\) gives local nonzero scalars \(a^*\theta_{B,0}=\lambda_v\theta_*\). They all equal
\[
 \lambda=
 \frac{\deg(a^*\theta_{B,0}\,\theta_*^{D-1})}
      {\deg(\theta_*^D)}\in\mathbb Q^\times.
\]
Consequently \(a^*\eta_{B,0}=\lambda^r f_0^*\eta_{C,0}\) in every realization; \(\kappa=\lambda^{-r}\eta_B/[P:\mathbb Q]\) gives the desired first-factor equality.

**Classification:** `undeveloped_source_context`, with an explicit elementary source derivation, not a newly reproduced Argus theorem. Its empty graph dependency list conceals its conditional input: the same algebraic quasi-isogeny, genuine rational divisor classes and preserved untwisted tensors in all realizations.

**Undischarged obligation.** The ratio calculation is displayed in the source; the existing Argus certificates do not establish its geometric inputs or identify the transported tensors with these algebraic polarizations. This is not a claim that the displayed arithmetic calculation is invalid or an open conjecture.

### 7. MR-FILTRATION — existence on the fixed isocrystal

**Records:** `G:210-220`; `L:395-408` v1.  
**Source:** `03_filtration.tex:38-79`, `thm:filtration`; weak-admissibility convention `15-35`; stable-subobject argument `208-245`; Frobenius-permuted blocks `315-356`.

**Statement.** Let \(A_0/\mathbb F\) have a rational CM-field action \(E\), polarization with Rosati conjugation on \(E\), and \(D=H^1_{\rm cris}(A_0)[1/p]\) of \(E\otimes K_0\)-rank \(2s\), \(s\geq1\). Suppose \(u\in\operatorname{End}^0(A_0)\) is invertible, \(u^\dagger=u\), and \(ue=\bar e u\). For the dual slope-one polarization pairing \(\beta\), there are finite \(K/K_0\) and \(L\subset D_K\) such that the one-step filtration is weakly admissible, \(L\) is \(E,u\)-stable and \(\beta\)-Lagrangian, and \(\dim L_\tau=s\) for every geometric embedding \(\tau\). The isocrystal, indicated tensors and filtration have finite local-field descent. Geometrically it lies in the single balanced polarized orbit for
\[
 G_D=\{g\in\operatorname{GSp}(D,\beta)\cap
             \operatorname{GL}_{E\otimes K_0}(D):
             \det_{E\otimes K_0}(g)=c(g)^s\}.
\]

**Classification:** `undeveloped_source_context`. The source supplies its own constrained construction, using bounded-degree avoidance and Lagrangian-intersection lemmas; Fontaine–Rapoport is identified as an antecedent (`03_filtration.tex:6-13`), not a certificate of this entire strengthened statement.

**Undischarged obligation.** Argus realization assumes an admissible filtration; it does not construct this \(E,u\)-stable one or prove \(t_H(D)=t_N(D)\) and \(t_H(P)\leq t_N(P)\) for every subisocrystal. The source's maximum-defect reduction and slope-graded argument, including when Frobenius permutes embedding blocks, are distinct obligations. Admissibility is a subsequent Colmez–Fontaine corollary (`437-448`), not the same assertion as filtration existence.

### 8. MR-WEIL — balanced-Weil dichotomy

**Records:** `G:221-238`; `L:409-422` v1.  
**Source:** `04_weil.tex:3-61`, `def:weil-space`, `eq:weil-U`, `prop:weil`; assembly `328-439`.

**Statement.** Let \(A/\overline{\mathbb Q}\) have good reduction and CM-field action \(E\), with compatible Rosati polarization, \(\dim_EH_1(A)=2s\), \(s\geq1\), and Hodge multiplicities \((s,s)\) at every embedding. Its rational Weil space \(W_E^s(A)\subset H^{2s}(A,\mathbb Q(s))\) has geometric support \(\bigoplus_\tau\bigwedge^{2s}V_\tau^\vee\). Set
\[
 \mathcal U=\{u\in\operatorname{End}^0(A_0):
               u^\dagger=u,\ ue=\bar e u\ \forall e\in E\}.
\]
Every \(\gamma\in W_E^s(A)\) has the Lefschetz pairing property. If \(\mathcal U\) has no invertible element, all complementary pairings vanish. If it has an invertible element, \(\gamma_0\) is one simultaneous rational Lefschetz class.

**Classification:** `undeveloped_source_context`. G records Orthogonality, Group, Filtration, Prescribed-Transport, Lift-Hom and Divisor-Span: the right main spine. The source also uses the unnumbered-in-G **`cor:filtration-divisor`**, `03_filtration.tex:450-482`, full Hodge-type tensor descent (`04_weil.tex:348-356`), the rational summand/projector construction, and comparison-compatible specialization of a rational divisor identity.

**Undischarged obligation.** Existing Argus work does not verify this dichotomy or the simultaneous lifting of the first-factor projector, \(E\)-action and extra divisor on one \(B\), followed by rational divisor-span descent. Neither rational admissibility alone nor abstract tensor-equality propagation proves these steps. No companion CM Hodge theorem enters this argument.

### 9. MR-WEIL-ORTHOGONALITY — the no-invertible-element branch

**Records:** `G:239-249`; `L:423-436` v1.  
**Source:** `04_weil.tex:70-74`, `lem:weil-orthogonality`; proof `76-182`; hypotheses/space `3-53`.

**Statement.** Under the balanced \(E\)-action, polarization and good-reduction hypotheses in entry 8, if \(\mathcal U\) contains no invertible rational endomorphism, then the specialization of every class of \(W_E^s(A)\) pairs to zero with every complementary Lefschetz class in each realization.

**Classification:** `undeveloped_source_context`. The source proves a contrapositive: Lefschetz hard Lefschetz reduces a nonzero pairing to a nondegenerate same-embedding divisor restriction; block projection and rational density produce \(u\in\mathcal U\); a nonzero \(E\)-stable algebraic kernel would have a nonzero component at every embedding, contradicting that restriction's nondegeneracy.

**Undischarged obligation.** G's leaf status does not certify the use of Milne's Lefschetz correspondences or the kernel/characteristic-polynomial argument in all realizations. No existing Argus certificate checks that passage from a single nonzero pairing to a globally invertible algebraic endomorphism. The unrelated \(p=2\) lattice-projector obstruction is not a counterexample to this lemma.

### 10. MR-WEIL-GROUP — geometric orbit and multiplier

**Records:** `G:250-260`; `L:437-450` v1.  
**Source:** `04_weil.tex:267-289`, `eq:weil-group`, `lem:weil-group`; proof `291-326`.

**Statement.** For the balanced polarized \(E\)-representation \(V\) in entry 8, define
\[
 G=\{a\in\operatorname{GSp}(V,\psi)\cap\operatorname{GL}_E(V):
                      \det_E(a)=c(a)^s\},
\]
with the scalar embedded diagonally. This is connected reductive; the Hodge homomorphism factors through it and defines a Shimura datum of Hodge type in the displayed embedding. Its geometric filtration orbit on \(H^1\) is exactly the \(E\)-stable dual-polarization Lagrangians of dimension \(s\) at each embedding. Every pure determinant alternating form defining the Weil space transforms by \(c^s\).

**Classification:** `undeveloped_source_context`. The source computes \(\ker(c)_\Omega\simeq\prod_{\{\tau,\bar\tau\}}\operatorname{SL}_{2s}\), checks Shimura axioms and uses its transitive action. It refers back to the orbit calculation in MR-FILTRATION; that shared calculation is not an assumption of the full weak-admissibility existence theorem.

**Undischarged obligation.** The local Argus matrix identities do not verify this group's Shimura-datum conditions or identify its entire geometric flag orbit. In particular geometric transitivity is not itself existence of a weakly admissible flag or its realization.

### 11. MR-LIFT-HOM — lift the specified algebraic map

**Records:** `G:261-271`; `L:465-478` v1.  
**Source:** `01_preliminaries.tex:153-169`, `lem:lift-hom`; proof `171-217`.

**Statement.** Let \(R\) be a complete mixed-characteristic DVR finite over \(W(\mathbb F)\), and let \(\mathcal X,\mathcal Y/R\) be abelian schemes. If the **specified rational algebraic** \(f_0\in\operatorname{Hom}^0(X_0,Y_0)\) has contravariant crystalline map preserving their Hodge filtrations, then it lifts uniquely to a rational homomorphism \(\mathcal X\to\mathcal Y\). A symmetric such \(X_0\to X_0^\vee\) lifts to a rational divisor class on the generic fiber (after finite extension for that identification if necessary), and finite algebraic identities among lifted maps remain valid.

**Classification:** `undeveloped_source_context`, with a source derivation explicitly using classical filtered Dieudonné, Tate extension, Serre–Tate deformation, formal algebraization and rigidity results. This is not an independently reproduced Argus lifting theorem. It does not lift arbitrary cohomological linear maps.

**Undischarged obligation.** Existing Argus evidence does not check the fixed-denominator passage from the rational filtered map to compatible marked algebraic maps at all finite orders and their algebraization, nor apply it to the projector/action/divisor required by MR-WEIL. The source's classical citations are actual dependencies despite G's empty edge list.

### 12. MR-DIVISOR-SPAN — rational pure determinants from a divisor

**Records:** `G:272-282`; `L:451-464` v1.  
**Source:** `04_weil.tex:205-225`, `lem:weil-divisor-span`; proof `227-262`, `eq:weil-coefficient-polynomial`.

**Statement.** Let \(B/\mathbb C\) be abelian, \(R\in\operatorname{End}^0(B)\) idempotent, and \(E\to R\operatorname{End}^0(B)R\) a CM-field action whose unit is \(R\). On \(T=\operatorname{im}R\subset H_1(B,\mathbb Q)\), suppose \(\dim_E T=2s\). Let \(D\) be a rational divisor with \(R^*D=D\), whose split form is \(\sum_\tau D_\tau\), each \(D_\tau\in\bigwedge^2T_\tau^\vee\otimes\mathbb Q(1)\) nondegenerate and supported on its own embedding. Then the rational subspace with scalar extension
\(\bigoplus_\tau\bigwedge^{2s}T_\tau^\vee\otimes\mathbb Q(s)\), zero on the complementary summand, consists of rational Lefschetz classes.

**Classification:** `undeveloped_source_context`, with a complete elementary source argument, not an extra Argus proof. The coefficient of \(x_\tau^{2s}\) in \((\sum_\xi x_\xi^2D_\xi)^s\) is \(D_\tau^s\). Rational density of \(E\) puts these coefficients in the scalar extension of the rational span of \((\widetilde b^*D)^s\); faithful scalar extension descends the inclusion.

**Undischarged obligation.** The old Argus calculations do not supply this projector/action/divisor or check the rational polynomial-span descent for its pure determinant subspace. The statement does not assert that every Weil class is always a divisor product, nor that each individual embedding line is rationally defined.

### 13. MR-CM-REDUCTION — source-supported adaptation of a known reduction

**Records:** `G:283-293`; `L:479-492` v1.  
**Source:** `05_reduction.tex:11-35`, `lem:cm-reduction`, `eq:cm-pullback-decomposition`; proof `37-205`, including good reduction/specialization `190-205`.

**Statement.** If \(A/\overline{\mathbb Q}\) is CM with good reduction and \(r>0\), every rational Hodge \(\gamma\in H^{2r}(A,\mathbb Q(r))\) is a finite sum \(\gamma=\sum_i f_i^*\eta_i\), where \(f_i:A\to B_i\) are rational homomorphisms, \(B_i/\overline{\mathbb Q}\) have good reduction, and \(\eta_i\) are rational Weil classes. Each \(B_i\) has CM-field action \(K\), homology of \(K\)-rank \(2r\), balanced signatures \((r,r)\), and a polarization inducing conjugation on \(K\). The equality specializes with the same rational coefficients in all stated realizations.

**Classification:** `undeveloped_source_context`; the **known-reduction attribution is supported by existing source**. Lines 11-16 explicitly attribute a stronger split-Weil reduction to Deligne–André, cite André 1992 and Milne 2020, and present this balanced, good-reduction version directly with rational idempotents. This is a source reproduction/adaptation, not a novel Argus contribution or a newly verified reproduction.

**Undischarged obligation.** Argus evidence does not verify the rational span of the constructed pullback spaces, balanced conjugate components, or extension of the rational-idempotent factors/maps with good reduction. This reduction concerns Hodge **classes**, not algebraicity of CM Hodge classes; it needs no companion CM Hodge assertion.

### 14. MR-PULLBACK — pairing-property functoriality

**Records:** `G:294-304`; `L:493-506` v1.  
**Source:** `01_preliminaries.tex:119-122`, `lem:pairing-functorial`; proof `124-142`; Lefschetz inputs `86-115`; rational pullback `10-18`.

**Statement.** For abelian \(X,Y/\mathbb F\), a tuple \(\alpha_v\in H_v^{2r}(Y)(r)\) with the Lefschetz pairing property and any \(f\in\operatorname{Hom}^0(X,Y)\), the tuple \(f^*\alpha\) has that property on \(X\). If the codimension exceeds either relevant dimension, the corresponding class is zero. For \(h=Nf\) an actual homomorphism, \(f^*=N^{-2r}h^*\).

**Classification:** `undeveloped_source_context`, explicitly derived in the source from cited established Lefschetz facts, not an independently reproduced Argus result. For actual \(f\), pushforward preserves local divisor spans. The perfect rational intersection matrix \(M_{ij}=\deg(a_i b_j)\) and equations \(\sum_i c_{i,v}M_{ij}=\deg(\delta f^*b_j)\) make the pushforward coefficients rational and independent of \(v\); the projection formula finishes the argument.

**Undischarged obligation.** The dependencies are the perfect pairing, Lefschetz pushforward and normalized projection formula in every realization (Milne 1999, with correction, as cited at `101-104`), not another PF matrix identity. Their application to arbitrary rational homomorphisms is not independently certified in the Argus evidence. This local linear-system proof is present in the manuscript; lack of an Argus receipt is not a defect in it.

### 15. MR-CM-HODGE-EXTERNAL — unverified companion assertion

**Records:** `G:305-315`; `L:507-520` v1.  
**Source:** `05_reduction.tex:370-373,411-419`; `S/build/references.tex:236-241`, `OpenAICMHodge2026`, cited **Theorem 1.1**.

**Assertion used here.** For a CM abelian variety \(B/\mathbb C\), every rational Hodge class \(\kappa\in H^{2r}(B,\mathbb Q(r))\) is the Betti class of a rational algebraic cycle. The application takes \(B/\overline{\mathbb Q}\), first obtains a cycle over \(\mathbb C\), then spreads it to \(\overline{\mathbb Q}\). This states the assertion used by this manuscript, not a claim to have checked all wording/hypotheses of the unseen companion theorem.

**Classification:** `unverified_external_companion_assertion`. Attribution is OpenAI's **October 6 companion**, not an Argus result, not a verified known theorem, and not an additional inventoried draft. L's empty external-assumptions array must not be mistaken for verification of this externally cited assertion.

**Undischarged obligation.** The companion theorem itself has no proof or independent verification in the old Argus evidence or this reference inventory. It is an input **only to MR-ALGEBRAIC-SPECIALIZATION**, not to MR-MAIN, PF-REALIZATION, either filtration existence or the balanced-Weil dichotomy. No new companion-theorem investigation is undertaken.

### 16. MR-ALGEBRAIC-SPECIALIZATION — explicitly conditional stronger consequence

**Records:** `G:316-331`; `L:521-534` v1.  
**Source:** `05_reduction.tex:375-399`, `cor:algebraic-specialization`; proof `401-441`; limitations `443-448`.

**Statement.** For every prime including \(2\), fixed \(w\), good-reduction \(A/\overline{\mathbb Q}\) of dimension \(d\), \(0\leq r\leq d\), and rational Hodge \(\gamma\), there is **one** \(z_\gamma\in\operatorname{CH}^r(A_0)_{\mathbb Q}\) whose \(\ell\)-adic classes equal \(\gamma_{0,\ell}\) for all \(\ell\ne p\) and whose crystalline class equals \(\gamma_{0,p}\) after extension to \(C_w\). Pairing with any \(y\in\operatorname{CH}^{d-r}(A_0)_{\mathbb Q}\) then gives the common rational number \(\deg(z_\gamma y)\).

**Classification:** `conditional_undeveloped_source_context`: the source states a corollary, but the reviewed evidence leaves its companion input unverified. G correctly lists MR-CM-TRANSPORT and MR-CM-HODGE-EXTERNAL. Given those inputs, the source chooses \(Z\) on CM \(B\), specializes it to \(Z_0\), and for \(h=Nb\), \(b=aj\), defines \(z_\gamma=N^{-2r}h^*Z_0\). Chow pullback is graph/refined-intersection pullback; neither separability nor \(p\nmid N\) is required.

**Undischarged obligation.** Existing PF evidence establishes neither the companion algebraicity input nor the combined cycle spreading/specialization and rational-pullback construction. Even rationality of all complementary divisor pairings alone would not prove this stronger algebraicity statement. The conclusion is only at the fixed special fiber: it does not prove the Hodge conjecture for arbitrary generic fibers, lift the cycle to original \(A\), assert uniqueness modulo rational equivalence, or compare places.

## Dependency and coverage corrections, without changing old data

1. **The main graph spine is a decomposition, not a certificate.** `R-MR-MAIN` (`L:858-888`), `R-MR-WEIL` (`889-929`), `R-MR-PRESCRIBED` (`930-960`) and `R-MR-ALGEBRAIC` (`961-981`) list obligations. Together with `R9000001-VERIFY-MAIN` (`842-857`), these are five historical plans, not five additional mathematical proofs. No status is promoted from those plans.
2. **CM versus prescribed transport:** MR-CM-TRANSPORT actually uses `prop:transport(1)` and Kisin–Zhou Theorem 2.2.7; PF-REALIZATION is used in clause (2). The old graph does not record every classical/model-theoretic input. Its omission of an edge from CM transport to prescribed transport is not itself a missing logical proof: the source has distinct branches.
3. **Empty edge/assumption lists are not evidence of independence.** Aux, Normalization, Filtration, Orthogonality, Group, Lift-Hom, Divisor-Span, CM-Reduction and Pullback all have explicit source inputs or internal helper arguments. Particularly, MR-WEIL uses the divisor-filtration corollary and full-family tensor descent not separately represented as graph nodes.
4. **No companion leakage:** MR-CM-HODGE-EXTERNAL is used only for the algebraic-cycle consequence. Its absence from MR-MAIN/PF dependencies is correct. Neither the good-theory context nor the known CM-to-Weil reduction supplies the missing companion algebraicity theorem.
5. **Locator corrections:** the initial index's MR-MAIN slice `00_intro:36-65` omits its hypotheses at `29-35`; Aux begins at `116`, not `125`; CM transport's actual statement/proof is `02_transport:777-814`, not `788-821` (the file has only 814 lines). Lift-Hom's proof ends at `01_preliminaries:217`, not `214`; the Weil assembly ends at `04_weil:439`, not `435`; algebraic specialization's proof ends at `05_reduction:441`, with scope limitations through `448`, beyond the indexed `430`. These are **source-locator coverage corrections, not extra drafts or newly discovered mathematical errors**. The report supplies the expanded locators; I, G and L were not edited.

## Unit outcome and validation

All **16/16 IDs** are explicitly covered: **1 historical goal; 11 undeveloped source-context results; 1 source dependency assumed by local realization; 1 downstream source result using local Argus inputs; 1 unverified external companion assertion; 1 conditional source consequence**. There are **0 independently developed Argus proofs for these 16**, **0 new refutations**, and **0 novelty claims**. Fourteen assertions have local manuscript development; the companion is cited-only; the goal is not mathematics.

Checks performed: bounded source/label reads; exact theorem-environment and proof-boundary extraction; all assigned graph/ledger records and historical evidence-subject accounting; inventory comparison against I; and nine digest comparisons against existing V. No new symbolic/formal claim requires a computation replay in this unit. Historical inputs were read only; no graph, ledger or current index was modified. No skill body, wiki editing or Git metadata was used. The output JSON is checked for parseability, 16 unique covered IDs, source-locator existence and inventory/count consistency.

An undeveloped Argus claim is not an invalid manuscript proof. These classifications complete this contributor's assigned source-context unit only; the native Host-invoked independent Reviewer still decides substantive review sufficiency and family coverage.
