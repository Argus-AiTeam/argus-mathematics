# Analytic invariants: dualizing sheaf, discrepancy, and genus window

## Assessment and attribution

**Engineer assessment: supported, conditional on the realized proper analytic contraction and the stated curve data. Current native independent review remains pending.**

The supported conclusions are
\[
\omega_X\simeq\mathcal O_X,\qquad
K_Y=\pi^*K_X-5C,\qquad
33\leq p_g(X,x)\leq39,
\]
and stabilization of the \(I\)-adic \(H^1\) tower **by** \(5C\). Neither an exact value of \(p_g\) nor the earliest stabilization index is proved. There is no inference of convergence of an infinite formal jet.

Throughout, `O` denotes the read-only old workspace
`campaigns/9000048`.
The manuscript source is
`O/research/openai_manuscript/A-singular-normal-affine-surface-with-free-tangent-sheaf-September-23-2026`,
revision September-23-2026 (reference commit in the active index:
`4eaee87548250b2682affda7d05d947c05554bae`).
The manuscript's `build/05-analytic.tex`, remark `analytic:invariants`, and the numerical discussion in `build/01-introduction.tex` assert trivial dualizing sheaf, discrepancy \(-5\), \(p_g\geq33\), and \(p_g-g-b\geq12\). The old Argus report `research/analytic_audit/report.md`, §9, adds the upper bound 39 and the explicit \(5C\) stabilization argument. Those are strengthenings of the manuscript's stated bound, not an independently established novelty claim.

This unit is separate from, and imports the analytic existence implication assessed in `../analytic-realization/report.md`. It does not count the same germ as another construction. The parent's established match of all 14 preserved core artifacts is reused; the other 97 manifested inputs are not falsely treated as snapshot-verified. No old file, ledger, graph, snapshot, or cache was changed.

## 1. Exact hypotheses, quantifiers, and claim coverage

Let \(\pi:Y\to X\) be the proper contraction on a sufficiently small representative constructed in the analytic-realization unit:

- \(Y\) is a smooth Hausdorff complex surface and \(X\) is a normal complex surface with an isolated singular point \(x\).
- Its entire reduced exceptional fiber is one smooth connected curve \(C\), with \(g(C)=21\) and \(C^2=-10\); \(\pi\) is a biholomorphism off \(C\), and \(\pi_*\mathcal O_Y=\mathcal O_X\).
- \(I=\mathcal O_Y(-C)\), \(L=I/I^2\), \(\deg L=10\), \(L^4\simeq K_C\), \(h^0(C,L)=2\), and \(h^0(C,L^2)=3\). The last two dimensions are imported from the separate curve/trace unit, not inferred from genus and degree alone.
- The **actual** holomorphic fields produced by lifting have ordinary wedge
  \[
  v_1\wedge v_2=t^5u(t,z)\,\partial_t\wedge\partial_z
  \]
  in normalized divisor charts, where \(u\) is a unit on one common neighborhood of \(C\). They descend to a frame on \(X^\circ=X\setminus\{x\}\).
- For \(J=\mathfrak m_x\mathcal O_Y\), one uniform integer \(a\geq1\) satisfies \(I^a\subseteq J\subseteq I\), and consequently \(I^{ar}\subseteq J^r\subseteq I^r\) for **every** \(r\geq1\). These are ordinary ideal powers, not symbolic powers.

For **every** contraction satisfying these hypotheses, the claims below follow. Existential application to the manuscript uses the upstream nonempty curve and finite-jet data, not a numerical sample.

| Indexed claim | Latest version | Precise conclusion and verdict |
|---|---:|---|
| `M_analytic_invariants` | 2 | **supported**: the dualizing sheaf of the germ is trivial; with \(K_X=0\) in the actual frame trivialization, the discrepancy coefficient of \(C\) in \(K_Y-\pi^*K_X\) is \(-5\); \(p_g\geq33\) and \(p_g-g-b\geq12\). |
| `AN_genus_window` | 4 | **supported**: \((R^1\pi_*\mathcal O_Y)_x\simeq H^1(\mathcal O_{5C})\) as complex vector spaces; \(33\leq p_g\leq39\); all transition maps \(H^1(\mathcal O_{(n+1)C})\to H^1(\mathcal O_{nC})\) are isomorphisms for every \(n\geq5\). No later connecting map is presumed zero. |

Cross-assessment of `M_graded_vanishing` v2: the uniform logarithmic lifting threshold is \(n\geq9\), and the \(n=8\) group has dimension one. That assertion belongs to the realization unit and is checked again in §4 only to distinguish it from the scalar \(5C\) stabilization. `AN_analytic_endpoint` packages these invariants and is not another invariant theorem to be counted.

## 2. Dualizing sheaf and discrepancy: actual form, not a numerical surrogate

The form \(\omega^\circ\) dual to the descended frame on \(X^\circ\) is holomorphic and nowhere zero. The normal-surface criterion in **Flenner–Zaidenberg, arXiv:math/0109221v1**, §2.4, Definition 2.18 and the following paragraph, applies directly: a normal surface singularity is Cohen–Macaulay, and is Gorenstein with trivial dualizing module exactly when its puncture has a nowhere-zero holomorphic two-form. This is the unrestricted local paragraph on printed p.19, not Theorem 2.20 about affine surfaces with a good \(\mathbb C^*\)-action.

Normality in dimension two also implies Cohen–Macaulayness by the \(S_2\) depth condition. Thus the reflexive canonical extension here is the dualizing sheaf. The conclusion is an **actual trivialization** \(\omega_X\simeq\mathcal O_X\), not merely numerical triviality of a canonical divisor. Choose \(K_X=0\) in that trivialization.

Under the birational identification off \(C\), its pullback is
\[
\omega=t^{-5}u(t,z)^{-1}\,dt\wedge dz.
\]
The unit condition holds on the already selected common neighborhood. These expressions glue because they are dual to the actual global wedge. They define a meromorphic form with divisor exactly \(-5C\); there are no other zeros or poles near the exceptional fiber. Thus
\[
K_Y=\pi^*K_X-5C.
\]
Here pullback means the birational pullback of the canonical form, shown meromorphic by its local expression; one is not assuming that an arbitrary dualizing generator on a singular target pulls back as a regular differential.

The sign convention is explicit: in \(K_Y=\pi^*K_X+a_CC\), \(a_C=-5\). An independent intersection check agrees:
\[
(-5C)\cdot C=50,\qquad
K_Y\cdot C=2g(C)-2-C^2=40+10=50.
\]
The ordinary/logarithmic distinction is essential. The logarithmic wedge vanishes to order four, but \(E_t=t\partial_t\) supplies one additional factor in the ordinary wedge and hence the fifth-order pole of the volume. Replacing \(-5\) by \(-4\) or \(+5\) would not match the actual wedge or adjunction.

The fixed coordinate expression \(t^{-5}dt\wedge dz\) need not glue under every allowed positive-order modification: the illustrative flow \(T=t/(1-t),\,Z=z\) multiplies it by \((1-t)^3\). The inverse-unit factor in the actual dual wedge resolves this. The example rejects an unjustified shortcut, not the manuscript's chosen transitions.

## 3. Geometric genus: where the numbers are justified

### 3.1 The graded cohomology dimensions

Let \(\mathcal O_{nC}=\mathcal O_Y/I^n\). Since \(h^0(L)=2\), a nonzero section supplies a divisor of degree 10; the divisor exact sequences give
\[
\chi(L)=\chi(\mathcal O_C)+10=1-21+10=-10.
\]
Thus \(h^1(L)=2-(-10)=12\). This is the elementary Euler-characteristic form of curve Riemann–Roch; no unjustified vanishing of a connecting map is used in this calculation.

Curve duality, the fixed \(L^4=K_C\), and the supplied section counts now give
\[
\begin{array}{c|rrrrrr}
n&0&1&2&3&4&n\geq5\\ \hline
h^1(C,L^n)&21&12&3&2&1&0 .
\end{array}
\]
For example \(h^1(L^2)=h^0(L^2)=3\), \(h^1(L^3)=h^0(L)=2\), and \(h^1(L^4)=h^0(\mathcal O_C)=1\). For **every** \(n\geq5\), the dual bundle \(L^{4-n}\) has negative degree and no section. These are geometric uses of duality and degree, not dimensions computed by the polynomial checker.

### 3.2 The double curve gives exactly 33

The Cartier filtration gives, for every \(n\geq1\),
\[
0\longrightarrow L^n\longrightarrow\mathcal O_{(n+1)C}
\longrightarrow\mathcal O_{nC}\longrightarrow0.
\]
At \(n=1\), the connecting map
\[
H^0(\mathcal O_C)=\mathbb C\longrightarrow H^1(L)
\]
is zero because every constant lifts to \(\mathcal O_{2C}\). Since \(H^2(C,L)=0\), the \(H^1\) sequence is short exact, and
\[
h^1(\mathcal O_{2C})=h^1(L)+h^1(\mathcal O_C)=12+21=33.
\]
This does not require the neighborhood or the double curve to split.

### 3.3 Later extensions give a window, not an exact genus

Write \(\delta_n:H^0(\mathcal O_{nC})\to H^1(L^n)\) for the later connecting maps. Curve cohomological dimension one implies that
\[
H^1(\mathcal O_{(n+1)C})\longrightarrow H^1(\mathcal O_{nC})
\]
is surjective for every \(n\geq1\), and its kernel has dimension \(h^1(L^n)-\operatorname{rank}\delta_n\). In particular the next three possible increments, from \(2C\) to \(5C\), are bounded by \(3,2,1\). Therefore
\[
33\leq h^1(\mathcal O_{5C})\leq33+3+2+1=39.
\]
More explicitly,
\[
h^1(\mathcal O_{5C})
=39-\operatorname{rank}\delta_2-\operatorname{rank}\delta_3-
\operatorname{rank}\delta_4.
\]
The report does not compute these ranks, and constants lifting at \(n=1\) does not make them zero. This is the concrete unresolved obligation for any proposed **exact** \(p_g\), not a gap in the bounded claim.

For every \(n\geq5\), \(H^1(L^n)=0\), so the transition in question is an isomorphism. The inverse system is consequently constant up to these natural isomorphisms from \(5C\) onward:
\[
\varprojlim_n H^1(\mathcal O_{nC})\simeq H^1(\mathcal O_{5C}).
\]
“Stabilizes at \(5C\)” here means **by \(5C\)**. It does not prove that the transition \(5C\to4C\) fails to be an isomorphism: \(\delta_4\) might surject onto the one-dimensional \(H^1(L^4)\). A sharp earliest-stabilization claim would need information the report does not supply.

### 3.4 Formal functions identifies the invariant, not just a formal approximation

Set
\[
A_r=H^1(Y,\mathcal O_Y/I^r),\qquad
B_r=H^1(Y,\mathcal O_Y/J^r).
\]
The uniform inclusions give natural maps \(B_r\to A_r\) and \(A_{ar}\to B_r\). On inverse limits these are inverse: their composites are exactly the transition maps from index \(ar\) to \(r\). Thus
\[
\varprojlim_r B_r\simeq\varprojlim_r A_r.
\]
This argument compares limits, **not individual groups at the same index**. The exponent \(a\) must be uniform along all \(C\), as established in the realization unit using nilpotence on the compact nonreduced fiber.

Proper coherence and the corrected analytic formal-functions theorem, with \(E=\mathcal O_Y\), now give
\[
\widehat{(R^1\pi_*\mathcal O_Y)_x}
\simeq\varprojlim_r B_r
\simeq H^1(\mathcal O_{5C}).
\]
The direct image is coherent and supported only at \(x\), because the map is an isomorphism off \(x\). Its stalk is a finite-length module over \(\mathcal O_{X,x}\): the radical of its annihilator is \(\mathfrak m_x\), and some power of that finitely generated maximal ideal kills it. A finite-length module equals its completion. With the standard resolution definition
\[
p_g(X,x)=\dim_\mathbb C(R^1\pi_*\mathcal O_Y)_x,
\]
this proves the claimed vector-space isomorphism and the window \(33\leq p_g\leq39\).

No flatness, reduced scheme fiber, termwise base change, Stein resolution, or analytic realization of infinitely prescribed coefficients enters this identification.

### 3.5 The numerical comparison is bounded in scope

There is one exceptional component, so the sum of its genera is \(g=21\); the dual graph has one vertex and no edges, so \(b=0\). Therefore \(p_g-g-b\geq12\). With the given discrepancy convention \(-5<-1\), this germ is also outside the log-canonical range.

The historical Bergner–Graf source excerpt gives the restricted positive criterion \(p_g-g-b\leq2\). The calculation shows only that this criterion does not apply to the stated germ. It does not establish a general theorem or novelty by numerical distance from known cases. This unit does not undertake a fresh literature-completeness search.

## 4. Distinguishing the two vanishing thresholds

The scalar ideal filtration for \(\mathcal O_{nC}\) has graded term \(L^n\), whose \(H^1\) vanishes for \(n\geq5\). This explains stabilization by \(5C\).

The logarithmic field filtration is different:
\[
0\longrightarrow L^n\longrightarrow
\mathcal T_Y(-\log C)|_C\otimes L^n
\longrightarrow L^{n-4}\longrightarrow0.
\]
The two dual obstruction spaces are \(H^0(L^{4-n})\) and \(H^0(L^{8-n})\). Both vanish for every \(n\geq9\); at \(n=8\), the middle \(H^1\) is exactly \(H^1(L^4)\simeq\mathbb C\). Thus `M_graded_vanishing` has the sharp uniform boundary nine, not five or eight. Neither the scalar bound nor the field bound says that an arbitrary infinite compatible formal system converges.

## 5. Source applications and version-specific fidelity

All relative passage paths below are under `O/research/literature/`. These are external propositions, not consequences of the finite certificate.

| Proposition | Exact statement/source and locator | What was actually read and why the application fits |
|---|---|---|
| `AN_surface_dualizing` | Flenner–Zaidenberg, *Rational curves and rational singularities*, **arXiv:math/0109221v1**, 28 September 2001, §2.4 Definition 2.18 and following paragraph, printed p.19: a normal surface singularity is Cohen–Macaulay, and is Gorenstein with \(\omega_{X,x}\simeq\mathcal O_{X,x}\) iff its puncture admits a nowhere-vanishing holomorphic two-form. | `flenner_zaidenberg_2001v1_criterion_page.txt`, `analytic_gorenstein_excerpt.txt`, and the relevant paragraph/context in the full v1 text were read. The paragraph has the local normal-surface hypothesis and no good-action hypothesis. The latter occurs in Theorem 2.20 and is not imported. The actual frame supplies the required form. |
| `AN_normal_depth` | Stacks Project Tag `031S`, Lemma 10.157.4, archived access 2026-11-05: Noetherian normal rings satisfy \(R_1\) and \(S_2\); a normal local domain of dimension two has depth two. | `analytic_normality_excerpt.txt` read. Applies to the analytic Noetherian local ring; dimension two then gives Cohen–Macaulayness. It is not being repurposed as an unproved general analytic Hartogs theorem. |
| `AN_curve_duality` | Serre (1955), DOI `10.1007/BF02564268`, §3 no.13 Theorem 4, p.22, and §4 no.16 Theorem 5/corollary, p.24: \(H^1(C,B)^*\simeq H^0(C,K_CB^{-1})\) on a compact smooth curve. | `reviewer_serre_duality_excerpt.txt` read; the unchanged upstream primary reading is reused. The supplied \(C,L\) meet the compactness/smoothness and line-bundle hypotheses. The section counts 2 and 3 remain geometric inputs, not consequences of duality alone. |
| `AN_analytic_local_algebra` | Grauert (1960), DOI `10.1007/BF02684746`, §1.6 Satz 4 and proof, p.15, gives uniform nilpotence on relatively compact subsets, and §2.1, p.16, gives analytic coherence operations, including for nonreduced spaces. | `grauert_1960_local_algebra_pages.txt` read. Used through the realization unit to obtain one exponent \(a\) on \((C,\mathcal O_Y/J)\), whose nilradical is \(I/J\), and for coherent point-supported modules. |
| `AN_direct_image_coherence` | Grauert (1960), introduction (I), p.7, and §6.5 Hauptsatz I, p.59: proper holomorphic map of complex spaces, coherent source sheaf, coherent higher direct images; no flatness. | The original-page `grauert_1960_intro_page.txt`, `grauert_1960_formal_functions_page.txt`, and p.59 raster `reviewer_grauert_1960_formal_functions.png` were read. The raster's source/target printing error is resolved by the unambiguous introduction, not silently quoted as correct. This makes the point-supported stalk finite. |
| `AN_formal_functions` | Same source, ideals preceding Hauptsatz II and Hauptsatz IIa, p.59, with the 1963 correction: the completed stalk of \(R^q\pi_*E\) equals the inverse limit of higher-direct-image stalks of \(E/J^rE\) for ordinary pulled-back maximal-ideal powers. | Primary p.59 text and raster plus `reviewer_grauert_formal_functions_excerpt.txt` read. The theorem is applied to \(\mathcal O_Y\) for the proper contraction. Compact infinitesimal support identifies the quotient cohomology with the stalks in the source formula. Only inverse limits are compared. |
| `AN_correction_scope` | Grauert, *Berichtigung* (1963), DOI `10.1007/BF02684291`, items 1–2, pp.35–36: corrected estimates/inductions, and withdrawal of closedness for the §7 Satz 2 fiberwise failure locus. | Entire `grauert_1963.txt` read, with `grauert_analytic_sources.md`. Hauptsätze I/IIa are not withdrawn, and no flatness hypothesis is added. Neither the withdrawn assertion nor termwise base change is used. |

Grauert's 1962 contraction/reduction assumptions are checked against the reader contraction excerpt in the realization unit; the invariant proof imports that actual proper normal contraction, not only a negative self-intersection number. The manuscript's unexamined Demailly source does not become an assumption of this replacement proof.

The elementary divisor Euler-characteristic calculation, adjunction, finite-length completion, and the two-sided cofinal-limit comparison are given explicitly above. None is claimed to be a new externally sourced theorem or a kernel formalization.

## 6. Historical versions, graph dependencies, and conflicting labels

All versions were read in the old ledger; later versions preserve the natural statement while annotating its external premises.

- `M_analytic_invariants` **v1** is the manuscript remark, with the descriptive warning “not an independently verified theorem” and no annotated external assumption. **v2** adds `AN_surface_dualizing` with the exact Flenner–Zaidenberg v1 paragraph, expressly not the good-action Theorem 2.20. The numerical statement is unchanged.
- `AN_genus_window` **v1** states the vector-space identification, window, and \(5C\) stabilization without external annotations. **v2** adds the corrected Grauert formal-functions proposition. **v3** also records Serre duality. **v4** adds proper direct-image coherence, necessary for the finite-length/completion step. No version evaluates the later connecting maps or asserts an exact genus.
- `M_graded_vanishing` **v1–v2** retain the \(n\geq9\) assertion; v2 adds curve duality. The exact \(n=8\) boundary is in the old report and has been checked directly in §4.

`R_AN_genus_window` depends on `CT_joint_inputs`, `M_actual_lifting`, and `M_analytic_counterexample`; the needed numerical section counts and actual contraction are not discarded. `M_analytic_invariants` also depends on the genus node. The retired initial endpoint decomposition did not explicitly list the additional genus upper bound; `R_AN_analytic_endpoint_with_genus` repairs this by including `AN_genus_window`.

The old graph leaves `AN_genus_window` and `M_analytic_invariants` open while recording `AN_analytic_endpoint` as proved. The old ledger includes both Engineer and Reviewer support records for the invariant arguments. The receipt
`$WORKSPACE/.argus-campaign-9000048/projects/46e84e6fea35/handoffs/8ba02f2780af/round-0001.json`
was read directly: `review.status=done`, and its reason accepts the bounded analytic proposition, including the source applications and no claim-critical gap. This explains the historical endpoint acceptance despite stale supporting flags and pending/submission prose. It does not automatically accept every open node today, nor does the hedging sentence in the original claim disprove its mathematics. The proofs, rather than these labels, ground this assessment.

## 7. Evidence boundaries, failed strengthenings, and remaining obligations

The old analytic checker, certificate, positive output, separate CLI negative control, and typed determinant payload/output/contract/run were read. Their details are also recorded in the realization assessment. No replay was called for: these are unchanged reviewed checkers and no finite-identity conflict or dependency change was found. This unit's contributor did not import or run an adapter. The parent separately executed the one bounded ordinary-wedge determinant documented in the realization assessment, section 8; it is not an invariant or cohomology oracle.

The historical checker is Python with SymPy; exact historical interpreter/SymPy versions are not recorded. It reports 67 non-integrity checks (26 symbolic, 31 arithmetic, 10 order equalities), 117 input-integrity checks, and 16 rejected mutations. The typed historical determinant operation uses server `0.14.0`, protocol `2025-11-25`, `SYMPY_BAREISS`, and the universal \(2\times2\) wedge perturbation over eight independent variables. This supports finite identities and numerical consistency, not a machine proof of a canonical sheaf, compact-curve cohomology, properness, Grauert theory, or the genus of a constructed germ. There is no Lean or kernel evidence.

In particular:

- Rejecting a mutated “upper bound 40” or “lower bound 32” certifies that the submitted data changed, not that those weaker inequalities are mathematically false.
- The “premature stabilization” mutation to 4 rejects a different recorded sufficient bound. It does **not** show that the actual tower cannot stabilize earlier than \(5C\). The rank of \(\delta_4\) would decide the last possible nontrivial step.
- Summing all graded \(h^1\)'s gives **an upper bound**, not an equality: the later connecting maps are genuinely unevaluated.
- The \(5C\) scalar stabilization does not lower the logarithmic lifting threshold to five, and the nonzero \(n=8\) logarithmic group does not obstruct the already established \(I^9F\) lifting.
- A non-invariant initial coordinate volume is not a counterexample to the actual dual-volume construction.
- Being outside a cited positive Lipman–Zariski criterion is not a novelty proof, nor does this unit alone establish the global affine main theorem.

**Concrete unresolved obligations for stronger claims:** an exact \(p_g\) requires computing \(\operatorname{rank}\delta_2,\operatorname{rank}\delta_3,\operatorname{rank}\delta_4\) for the actual realized neighborhood; the earliest stabilization index also needs those maps. Neither stronger claim is required for either indexed invariant assertion, so no additional local mathematical gap was found in the window or discrepancy conclusions. Convergence of arbitrary infinite jets remains unasserted and is not needed. Current upstream unit assessments and native independent review remain outstanding at the family level; this Engineer report cannot discharge them.

For proposition-level external attribution, retain `AN_surface_dualizing` with the exact arXiv v1 paragraph, `AN_normal_depth`, `AN_curve_duality`, `AN_analytic_local_algebra`, `AN_direct_image_coherence`, `AN_formal_functions`, and `AN_correction_scope`. The restricted positive-criterion baseline is contextual evidence, not a premise proving the invariants or an exhaustive novelty check.
