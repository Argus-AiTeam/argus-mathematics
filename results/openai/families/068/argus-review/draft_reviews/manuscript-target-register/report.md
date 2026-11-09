# Manuscript-target register: bounded old-draft assessment

## Result and evidentiary boundary

**Coverage: all 22 assigned claim IDs, all 29 recorded versions.** This is a
statement-attribution and dependency-boundary assessment, not an independent
correctness review of the seven manuscripts. Their mathematical truth and
novelty remain **unreviewed/unassessed**. All 22 inherited graph nodes are open
and have `reviewer_confirmed=false`; this assessment does not close them.
Current-review novelty is `not_applicable`; native independent acceptance is
`pending`.

The read-only `research/DRAFT_REVIEW_INDEX.json` supplies the complete historical
records, evidence subjects, graph and reference metadata. Of its 24 evidence
records, **zero have any of these 22 IDs as their subject**. All 29 registrations
have empty formal statements. Their graph evidence points to manuscript
passages, except the administrative goal, which points to the old objective.
The inventory's one substantive old prose draft declared verification limited
to G's volume theorem and two proposed extensions; its computations and formal
core belong to the other four review units. Thus none of the present 21
mathematical targets has a substantive independent old proof or computation in
the 22-artifact inventory. This is not a claim that the source manuscripts lack
proofs, nor that those proofs are correct.

The seven manuscript directories are **reference inputs, not seven completed
Argus papers**. Here their actual principal TeX statements were read through the
old symlinks. No old ledger, formal artifact, excluded literature source or
`toroidal-volume.tex` was reopened; no proof, computational replay, new error
search, literature/novelty adjudication or native acceptance was attempted.

## Source key

All sources below declare **OpenAI, September 26, 2026**, at the indexed immutable
revision `4eaee87548250b2682affda7d05d947c05554bae`. Directory names are relative to
`families/068/first-pass/openai_manuscript/`.
File locations in the register are relative to each directory's
`build/source/sections/`. Exact source roots and manifest pointers are also in
`verdict.json`.

| Key | Manuscript directory |
|---|---|
| H | `Anticanonical-nonvanishing-from-smooth-semipositivity-September-26-2026` |
| I | `Invariant-anticanonical-indices-and-conversion-of-twisted-differentials-September-26-2026` |
| B | `Bounded-anticanonical-metrics-on-klt-pairs-and-torus-quotients-September-26-2026` |
| C | `Cohomological-transfer-and-equivariant-anticanonical-sections-September-26-2026` |
| G | `Metric-descent-and-rank-preserving-contractions-September-26-2026` |
| E | `Integrable-metrics-and-effectivity-with-controlled-boundary-September-26-2026` |
| V | `Exact-orders-and-invariant-anticanonical-linear-systems-September-26-2026` |

“Source target” below means an identified theorem or lemma, **not an accepted
theorem**. Seventeen IDs have such direct statement counterparts. Four are
synthesized proof/route/interface obligations, and one is an administrative old
goal. Registered wording is preserved separately from source-faithful scope in
the verdict.

## Target register and retained hypotheses

### Historical objective and H

- **C9000068 v1 — administrative old goal.** Indexed
  `MATH_STATE.json#/claims/0`, context `CTX9000068`, describes a historical
  family-wide adversarial audit/certification mission. It is neither a
  manuscript theorem nor the current instruction. Its graph edge to
  `C_TV_AUDIT` does not certify the family. Novelty is `not_applicable`;
  historical completion/acceptance is not established by this unit.

- **C_H_MAIN v1 — source theorem target.** H `introduction.tex:14–18`,
  `thm:headline`: smooth connected projective complex \(X\), with a **smooth**
  semipositive Hermitian metric on \(-K_X\), has
  \(H^0(X,-mK_X)\ne0\) for some integer \(m>0\). Neither nefness alone nor a
  first-power section is asserted. An independent complete argument along a
  chosen route, including descent, remains outside this review.

- **C_H_FINITE_VOLUME v1–2 — source theorem target.** H
  `introduction.tex:129–144`, `thm:finite-volume`: smooth connected projective
  \(Z\), no holomorphic \(q\)-forms for \(1\le q\le\dim Z\), effective integral
  \(D\), and \(J=-K_Z+D\) with semipositive singular metric satisfying
  \(\int_Z|s_D|_{h_J}^2<\infty\). A **separate** line \(L\) has semipositive
  singular metric with locally bounded weights on both sides. The conclusion
  is \(H^0(Z,aL+bD)\ne0\), integers \(a>0,b\ge0\), with no uniform pole bound.
  The dimension induction, slope and two-metric lifting are unreviewed.

- **C_H_SLOPE v1 — synthesized proof obligation.** Its descriptive registration
  is not the literal theorem. H `slope.tex:198–217`,
  `h:slope:cotangent` / `thm:finite-volume-slope`, assumes smooth projective
  \(Z\), effective integral \(D\), and the same finite adjoint volume, but
  **does not require the no-forms hypothesis**. For positive dimension and
  every nonzero real movable \(\alpha\),
  \(\mu_{\min,\alpha}(T_Z)\ge-D\cdot\alpha\). For \(k\ge0\) and a nonzero
  \(M\to(\Omega_Z^1)^{\otimes k}\), \(-M+kD\) is pseudoeffective; for a rank
  \(r\) subsheaf, \(-\det E+krD\) is pseudoeffective.
  `h:slope:face`, lines 294–312, additionally assumes \(L\) pseudoeffective
  and \(L+D\) not big to obtain \(L\cdot\alpha=D\cdot\alpha=0\) and the stated
  zero degrees for \(N_i\sim M+m_iL\). The finite-volume-to-slope argument,
  not merely a numerical nef inference, remains unreviewed.

- **C_H_INVARIANT v1 — source theorem target with mechanism summary.** H
  `torus.tex:84–95`, `thm:invariant`: smooth connected projective no-forms
  \(Z\), smoothly semipositive \(L=-K_Z\), and a compact connected real torus
  acting continuously by holomorphic automorphisms give
  \(H^0(Z,mL)^T\ne0\) for some \(m>0\), for the **natural** linearization.
  The separate `prop:invariant-transfer`, lines 21–40, uses smooth invariant
  metrics, \(D=0\), and invariant adjoint dimensions one for every
  \(j=0,1,\ldots\). Its averaging/quotient positivity is not the full-rank
  singular-volume theorem and is not independently checked here.

- **C_H_STRUCTURE v1–3 — source theorem target.** H `cover.tex:14–70`,
  `thm:structure`: under the headline metric hypotheses a connected finite
  étale cover has universal cover \(\mathbb C^a\times F\times Z\), with compact
  simply connected factors, a parallel canonical frame on Ricci-flat \(F\),
  and smoothly semipositive, no-forms \(Z\), rationally connected if
  positive-dimensional. The cover is
  \((\mathbb C^a\times F\times Z)/\Lambda\), with
  \(\lambda(z,f,v)=(z+\lambda,f,\rho(\lambda)v)\). The closure of the residual
  action is a compact connected torus, extending to an algebraic torus;
  natural anticanonical invariants agree, and the other canonical frames are
  deck-invariant. **This is not a finite-cover global product.** The
  literature-based structure and residual action construction remain unchecked.

- **C_H_NORM v1 — source lemma target, not a new Argus contribution.** H
  `cover.tex:274–286`, `lem:etale-norm`: for a finite étale morphism of degree
  \(d>0\) between smooth connected projective complex varieties, nonzero
  \(s\in H^0(S,\nu^*A)\) has nonzero norm in \(H^0(X,A^{\otimes d})\).
  An anticanonical section of degree \(m>0\) upstairs gives degree \(md\)
  downstairs. This elementary source argument was not an independent old
  inventory proof; its global norm application is not adjudicated here.

### I, B and C

- **C_I_INDEX v1 — source theorem target.** I `introduction.tex:17–37`,
  `thm:index`: a holomorphic compact-real-torus action on a compact complex
  manifold \(F\), with the **natural** anticanonical linearization, gives
  \(a>0\) and \(P\in\mathbb Q[t]\) with
  \(I_T(m)=\sum_q(-1)^q\dim H^q(F,(-K_F)^m)^T=P(m)\) for **every positive
  multiple** of \(a\), and \(P(0)=I_T(0)\), the actual invariant Euler
  characteristic. There is no positivity, Kähler or projectivity premise.
  Neither eventual polynomiality nor an arbitrary character twist is the
  statement. The zero-endpoint index calculation remains unreviewed.

- **C_I_CONVERSION v1 — source theorem target.** I
  `introduction.tex:98–107`, `thm:conversion`; implementation begins in
  `conversion.tex`, `sec:conversion`. Smooth connected projective \(S\),
  smoothly semipositive \(L=-K_S\), fixed pseudoeffective Cartier \(D\), and
  nonzero \(H^0(S,m_jL-D)\) along a strictly increasing positive integer
  sequence imply \(H^0(S,kL)\ne0\) for some \(k>0\). The error need not be
  effective; no group, rational-connectedness or Euler premise is imposed.
  The normalized base metric and exponent-zero conversion remain unchecked.

- **C_B_KLT v1 — source theorem target.** B `introduction.tex:15–22`,
  `thm:klt`: projective **\(\mathbb Q\)-factorial klt** \((W,D)\), effective
  rational boundary, nef \(P=-(K_W+D)\), and a smooth projective resolution
  \(\rho\) on which \(\rho^*P\) has locally bounded semipositive weights and
  \(\chi(\widetilde W,\mathcal O_{\widetilde W})\ne0\) imply a section of some
  positive Cartier multiple \(mP\). These hypotheses are retained, not
  replaced by “nef klt nonvanishing.” Their use in the source argument remains
  unreviewed.

- **C_B_INVARIANT v1 — source theorem target.** B
  `introduction.tex:27–33`, `thm:equivariant`: smooth rationally connected
  projective \(Z\) with smoothly semipositive \(-K_Z\) has a nonzero naturally
  invariant positive anticanonical multiple for **every algebraic torus**
  action. Constructing the stable quotient, its effective klt boundary,
  bounded metric and nonzero resolution Euler characteristic, then extending
  the section without changing its natural character, are separate unreviewed
  obligations.

- **C_C_TRANSFER v1 — source theorem target.** C
  `introduction.tex:8–22`, `inj:transfer`; the proof section is
  `transfer.tex`, `inj:character-transfer`. Smooth connected projective \(X\),
  smoothly semipositive ordinary \(L=-K_X\), an algebraic torus, linearized
  \(P,M\) with \(P=L\) as ordinary lines and \(-M\) pseudoeffective, and
  nonzero \(H^0(X,M+iP)^T\) for an **unbounded**
  \(I\subset\mathbb Z_{>0}\), imply \(H^0(X,mP)^T\ne0\) for some \(m>0\).
  \(P\)'s linearization may be character-shifted; the conclusion preserves
  that linearization. Character-sensitive transfer with its fixed multiplier
  ideal is unreviewed; natural-index input must not be used indiscriminately
  for shifted \(P\).

- **C_C_HARMONIC v1 — source theorem target, alternative mechanism.** C
  `harmonic-restriction.tex:40–53`, `har:thm:kernel`: \(f:V\to Y\) is a
  surjective morphism of smooth connected projective complex varieties,
  \(D_V\) has a smooth semipositive metric of curvature \(\theta\), and \(Q\)
  has a positive continuous Hermitian metric with psh weights. On a nonempty
  ordinary submersion open, require \(\ker\theta\subseteq\ker df\). Then
  \(H^p(Y,R^qf_*(K_V+D_V)\otimes Q^k)=0\) for every \(p>0,q,k\ge0\).
  Neither the kernel condition nor a decomposition theorem for a merely
  continuous upstairs coefficient is supplied automatically. The harmonic
  argument is unreviewed and is not a prerequisite for G's volume theorem.

### G and E

- **C_G_TRANSFER v1 — source lemma target.** G
  `analytic-input.tex:64–92`, `g:transfer` / `rb:transfer`: finite canonical
  section volume for semipositive singular \(-K_V+D\), a separate bounded
  semipositive \(L\), a dominant rational map with connected general fibers,
  its normal equidimensional model over smooth \(Y\) with
  \(0<\dim Y\le\dim V\), and rational \(\rho\) of \(kL\), \(k>0\), without
  horizontal poles, are required. The two functions
  \(-\log g_0\) (pushforward density) and \(-\log S_\rho\) (fiber essential
  supremum) must have psh representatives. The output is bounded semipositive
  \(B\), effective integral \(D_Y\), finite adjoint measure on
  \(-K_Y+D_Y\), a regular map \(f^*B\to bk\,p^*L\), and lifting of
  \(aB+cD_Y\) sections to \(abkL\) with poles only on \(D\).
  `g:moments`, lines 183–195, supplies a sufficient **full** generic adjoint
  rank-one condition for every \(m\ge0\); its invariant alternative requires
  \(D=0\), smooth invariant metrics and invariant \(\rho\). These are not
  interchangeable. Normalization, psh input and lifting remain unchecked.

- **C_G_CONTRACTION v1 — source theorem target.** G
  `contraction.tex:13–38`, `g:cf:contraction-theorem`: smooth connected
  projective no-forms \(X\), smoothly semipositive \(L=-K_X\), natural
  algebraic-torus action and invariant dominant rational \(f:X\dashrightarrow Z\)
  to smooth connected projective \(Z\), with \(\mathbb C(Z)\) relatively
  algebraically closed in \(\mathbb C(X)\). On a resolution, require a
  nonzero invariant section of \(pL_Y\), \(p>0\), on the generic fiber, and
  invariant adjoint dimension one for every positive multiple of some
  \(a>0\). Either there is a global invariant \(rL\) section, or contraction
  to a strictly smaller smooth projective base retains **both** conditions
  and relative algebraic closedness. This is not full generic rank one;
  preservation under contraction remains unreviewed.

- **C_E_BOUNDARY v1–2 — source theorem target.** E
  `introduction.tex:24–36`, `thm:controlled-boundary`: positive-dimensional
  smooth projective \(Y\), effective integral \(C\), and a metric on
  \(-K_Y+C\) whose curvature **globally dominates a Kähler form** and whose
  multiplier ideal contains \(\mathcal O_Y(-C)\). Every pseudoeffective
  rational \(M\) then has an effective rational correction \(C_0\), supported
  on \(C\), with \(M+C_0\) rationally linearly effective. Weighted
  canonical-section integrability is not unweighted frame integrability.
  The effective big klt boundary and nonvanishing invocation remain unchecked.

- **C_E_RING v1–2 — source theorem target.** E
  `correction-ring.tex:81–97`, `thm:correction-ring`: smooth
  positive-dimensional projective \(Y\), rational \(A_0\), and a semipositive
  singular metric on \(-K_Y+A_0\) with **unweighted locally integrable
  squared frame norms**, smooth and strictly positive on a nonempty ordinary
  open. For any finite list of rational \(P_i\), some common
  \(\epsilon\in\mathbb Q_{>0}\) and integer \(k_0>0\) make the actual
  \(B_i=k_0(A_0+\epsilon P_i)\) Cartier with finitely generated multigraded
  section ring. Numerical equivalence or the preceding weighted hypothesis
  is insufficient. The adjoint-ring identification remains unreviewed.

- **C_E_CONVERSION v1 — synthesized route summary.** Its precise ordinary
  section counterpart is E `conversion.tex:10–16`, `conv:fixed-error`:
  smooth connected projective \(X\), smoothly semipositive \(L=-K_X\),
  fixed pseudoeffective Cartier \(P\), and effective integral
  \(N_j\sim m_jL-P\) for unbounded positive integers \(m_j\), imply a positive
  anticanonical section. The main singular globally-strict metric route and
  `conv:toroidal-alternative` are alternatives, as distinguished also in
  `introduction.tex:153–211`. Constructing the chosen metric and removing its
  exceptional correction remain unchecked. Failure of the smooth
  volume-dependent route would not by itself refute this theorem.

### V

- **C_V_EXACT v1 — source theorem target.** V `introduction.tex:27–62`,
  `V:null-functional`, `V:exact`: \(n=\dim X>0\), smooth connected projective
  \(X\), fixed smooth semipositive curvature \(\alpha\) of \(L=-K_X\),
  maximum rank \(\nu\), and ample \(G_0\). Set
  \(\ell(D)=D\cdot L^\nu\cdot G_0^{n-\nu-1}\) if \(\nu<n\), and zero if
  \(\nu=n\). For **any fixed line** \(M\) and a centered discrete valuation
  of \(\mathbb C(X)\), **or the zero valuation**, effective integral
  \(N_j\sim m_jL+M\), \(m_j\to\infty\), \(\ell(N_j)=0\), and
  \(v(N_j)/m_j\to0\) imply effective rational \(N\sim_{\mathbb Q}L\) with
  \(v(N)=0\). No Euler assumption or pseudoeffectivity of \(-M\) is in this
  theorem. The actual rational-linear conclusion, not numerical limiting
  effectivity, requires the entire unreviewed application chain.

- **C_V_NULL_FIELD v1–3 — synthesized application interface.** V
  `null-field.tex`, `V:polar-field` (10–17), `V:null-rank` /
  `V:ample-null` / `V:zero-rank` (50–59), model subsection (91–128), and
  `V:strict-patch` / `V:correction` (130–181), are several distinct source
  steps. For the preceding curvature functional, the null-polar field
  \(k=\{0\}\cup\{h:\ell((h)_\infty)=0\}\) is claimed finitely generated and
  relatively algebraically closed. The source claims
  \(\ell(\pi_*g^*H)=0\) for every very ample \(H\), **full**
  \(\dim_{\mathbb C(Y)}H^0(Z_\eta,\mathcal O(K_{Z/X})|_{Z_\eta})=1\),
  a birational normal equidimensional toroidal model without changing \(k\),
  and, when \(\dim Y>0\), a patch away from the Jacobian divisor with
  \(\pi^*\alpha\ge c\,g^*\omega_H\), \(c>0\).
  These assertions are not automatic consequences of toroidalization or of
  the conditional G theorem. Their application-level verification remains
  open; reduced fibers after alteration are a different construction.

- **C_V_ENDPOINT v1 — synthesized endpoint/geometry obligation.** V
  `endpoint.tex:19–38`, `lem:endpoint`, concerns a finitely generated
  \(\mathbb N^2\)-graded \(R\subset K[x,y]\), \(R_{0,0}=\mathbb C\), and a
  real valuation trivial on \(\mathbb C^\times\). For homogeneous
  \(f_jx^{a_j}y^{b_j}\) with \(d_j=a_j+b_j>0\),
  \(a_j/d_j\to0\) and \(v(f_j)/d_j\to\gamma\in\mathbb R\), every finite
  homogeneous generating set contains \(fx^0y^b\), \(b>0\), with
  \(v(f)/b\le\gamma\). **The lemma alone does not assert zero order.**
  `prop:geometric`, lines 142–186, additionally requires a normal
  equidimensional birational diagram, centered discrete or zero valuation,
  effective rational \(A\) with \(p_*f^*A=0\), an affine interval of
  vertical-minimum divisors \(P(t)\), actual base rational corrections
  \(N_j=D(t_j)+\operatorname{div}(h_j)\ge0\) with \(t_j\to0\) and
  \(v(N_j)\to0\), and finite generation for the specified Cartier
  \(k(A+\epsilon P(1)),k(A+\epsilon P(0))\). It concludes
  \(N\ge0\), \(N\sim_{\mathbb Q}D_0\), \(v(N)=0\).
  Affine minima, correction removal and the final centered-valuation
  comparison are unreviewed. One must not assume \(v(A)=0\).

- **C_V_INVARIANT v1 — source theorem target.** V
  `introduction.tex:144–150`, `V:invariant-main`: smooth connected projective
  \(X\), smoothly semipositive \(-K_X\), and
  \(H^i(X,\mathcal O_X)=0\) for **every** \(i>0\), give a naturally invariant
  positive anticanonical multiple for every algebraic torus action. The
  passage from exact orders along orbit arcs to natural characters remains
  unreviewed; ordinary nonvanishing alone does not supply invariance.

## Historical version coverage

All other IDs have v1 only. The seven additional records change recorded
external-assumption sets, **not** their natural statements:

| Claim | Complete version/old-claim-array locations | Recorded assumption change |
|---|---|---|
| C_H_FINITE_VOLUME | v1 `/claims/4`; v2 `/claims/39` | none → `A_HARD_LEFSCHETZ` (DPS, `arxiv:math/0006205v2`, Theorem 2.1.1) |
| C_H_STRUCTURE | v1 `/claims/7`; v2 `/claims/35`; v3 `/claims/36` | none → `A_DPS_STRUCTURE` → additionally `A_CDP_RATIONAL_CONNECTEDNESS` (`arxiv:1210.2092v3`, Theorem 1.4) |
| C_E_BOUNDARY | v1 `/claims/22`; v2 `/claims/37` | none → `A_BCHM_NONVANISHING`, retaining effective, big, klt premises |
| C_E_RING | v1 `/claims/23`; v2 `/claims/38` | none → `A_ADJOINT_FINITE_GENERATION`, actual adjoint rings and finite-index Veronese passage |
| C_V_NULL_FIELD | v1 `/claims/26`; v2 `/claims/33`; v3 `/claims/34` | none → `A_BIRATIONAL_TOROIDALIZATION` (ADK) → additionally `A_TOROIDAL_EQUIDIMENSIONAL_REFINEMENT` (AK, `alg-geom/9707012v1`, Proposition 4.4 and Lemma 4.1) |

Empty early assumption arrays mean “not recorded there,” not
“assumption-free proof.” The verdict preserves all 29 index pointers, original
statement hashes and flags, exact registered wording, all seven assumption
records and each version's assumption set. No retired assumptions were
recorded for these targets.

## Dependencies are route-local, not a conjunction of seven papers

The indexed graph and ledger give three **untried OR routes** to `C_H_MAIN`:

1. `R_H_FINITE_VOLUME`: H finite-volume theorem **and** H invariant transfer,
   with H structure and norm.
2. `R_B_STABLE_QUOTIENT`: B klt criterion **and** B invariant quotient
   application, with the same H structure and norm.
3. `R_C_COHOMOLOGICAL`: I natural invariant index **and** C
   character-sensitive transfer, with H structure and norm. Cofactors such as
   hard Lefschetz and determinant conversion must still meet their own
   hypotheses; the abbreviated route is not an exhaustive proof.

An individual route needs its own listed interfaces; the three routes are
**not AND prerequisites of one another**. H's finite-volume node records the
slope and G two-metric-transfer interfaces. That is not an edge requiring
G's toroidal-volume theorem. B's stable quotient does not inherit that theorem
either. C's harmonic mechanism is a separate alternative, not a mandatory
part of its character-sensitive transfer or an input to toroidal volume.

`R_V_EXACT_ORDER` is a different, explicitly volume-dependent chain:
`C_V_NULL_FIELD` + `C_G_VOLUME` + `C_E_RING` + `C_V_ENDPOINT` → `C_V_EXACT`;
the graph then connects exact orders to `C_V_INVARIANT`. Verifying G's
conditional theorem would not establish V's full generic rank, horizontal
patch, finite generation, endpoint hypotheses or natural-character argument.
Conversely, an application gap in V would not refute G's conditional statement.
E's singular globally-strict and smooth toroidal/unweighted conversions are
alternatives. G's own reading guide (`introduction.tex:227–249`) likewise
separates direct allowed-pole/orbit routes from rank-preserving contraction
and from the reduced-flat alteration/norm alternative.

## Registration/source comparison and disposition

**No contradictory mathematical mismatch was found between the inherited
registrations and the statement passages read.** This is a bounded attribution
finding, not a correctness verdict. Location refinements matter: I conversion
and C transfer are stated in their introductions even though graph evidence
points to proof-section files; C harmonic vanishing is stated in
`harmonic-restriction.tex`. H slope, E conversion-route summary, V null-field
interface and V endpoint synthesis must not be quoted as single exact source
theorems. Those are classification/locator refinements, not manuscript repairs.

The concrete unreviewed obligations are identified above and per claim in
`verdict.json`. None is silently discharged by another unit's volume proof,
conditional arithmetic certificate, an inherited support judgement, a
numerical limit or a status label. This completes the requested bounded
register assessment only; it neither settles manuscript truth/novelty nor
self-accepts the larger old-draft review.
