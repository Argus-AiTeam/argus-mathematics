# Ledger-only manuscript obligations: Engineer assessment

**Disposition:** six distinct ledger-only claims remain **unverified by the inventoried Argus work**. This is a substantive assessment of the boundary of that work, not a finding that the manuscript is false, and not a new attempt to prove or disprove its remaining sections. Native independent review is outstanding.

## Source, identity, and attribution

The exact records are in the read-only `9000022/research/MATH_STATE.json`; their version pointers and dependency/evidence relations are mapped in the active `research/DRAFT_REVIEW_INDEX.json`. The old proof graph labels all six open and not reviewer-confirmed. That label is not the reason for the conclusion: the certificate domains and missing implications are identified below.

The source is *The weak inhomogeneous Duffin-Schaeffer conjecture*, September 25, 2026, **revision `4eaee87548250b2682affda7d05d947c05554bae`**, pinned by campaign 9100022 `MANUSCRIPTS.json`. The statements below were checked against `build/sections/introduction.tex:1-21`, `tables.tex:324-442,963-1028`, `direct.tex:47-75`, and the separately assessed remaining-first-join proposition. These manuscript assertions and proposed proofs belong to the manuscript authors. A reference to them is not an original Argus result or an independent verification of their complete proofs.

All six claim records have no standalone Argus formal source or proof/checker assigned to them in the complete inventory. They are **included as one assessed dependency unit**, not omitted because there is no separate directory. This unit is not six new failed attacks.

## Exact targets and concrete missing implications

| Exact old claim/version | Mathematical assertion and hypotheses | Assessment of the old work |
|---|---|---|
| **C_DSC v1**, `/claims/10` | For each fixed \(\gamma\in\mathbb R\) and finite-valued \(\psi:\mathbb N\to[0,\infty)\), divergence of \(\sum_q\phi(q)\psi(q)/q\) implies \(\|qx-\gamma\|<\psi(q)\) for infinitely many positive \(q\), for Lebesgue-almost every \(x\in\mathbb R\). The null set may depend on both data. No monotonicity or Diophantine condition on \(\gamma\), and no numerator coprimality, is imposed. | **Unresolved by these drafts.** BC is a finite conditional transport statement; RFJ is a remaining-comparisons estimate conditional on selected data and histories. Neither constructs the full approximation scheme or supplies the final almost-everywhere/tail argument. |
| **C_FIRST_JOIN v1**, `/claims/11` | For selected finite blocks there is a static additional birth test on row data/squarefree low numerator moduli, independent of running tables, with arbitrarily small relative hard-birth first-mass loss. Total first-sharing broad currency is \(O(1)\); same-width/same-mask new-cell currency is \(O(W)+O_{k_0}(W^{1+c})\), excluding same-old-child pairs and **including newborn self/diagonal contributions**. Constants are uniform in block/history and independent of \(N_0\). | **Partial dependency support only.** RFJ v5 addresses remaining comparisons, not the direct static test or adjacent simultaneous-birth/self terms. A bound for the excluded-comparison complement is not a proof of the complete first-sharing input. |
| **C_DIRECT_JOIN v1**, `/claims/12` | Under retained one-type/colour centres, good masks, birth prescriptions and fixed hierarchy, direct broad counts are \(O(1)\), and exact same-width one-law direct counts at scale \(r e^{-E_gX_0}\) are \(O(W)+O_{k_0}(W^{1+c})\). Each ordered centre pair is counted once at common birth. The additional static discard has loss at most \(\delta W\) after fixed \(\lambda_0\) is chosen, uses squarefree low numerator moduli, and does not depend on running deletions. | **Unverified by the inventoried drafts.** The necessary static selection/loss and direct birth bounds are not conclusions of BC or RFJ. Further nonincreasing thinning preserves a valid direct bound, but it does not prove that initial bound or existence of the static rule. |
| **C_SPARSE_INPUT v1**, `/claims/16` | At each sparse step in bin \(Y\), an equivariant exceptional selection exists in the same-width successful-plus range \(r_i e^{-\frac12 e^{\sigma_gY}}\); nonexceptional retained pairs coarsen classes. Three sums over steps/components/pairs/masks/locations are bounded uniformly: actual simultaneous successes in the intermediate-to-broad distance range, weighted by \(r^-_{xy}\) and raw arrivals/two after-mask laws; pre-prime plus pairs at broad distance, weighted by \(r^-_{xy}/p^2\) and preweights/two after laws; selected exceptional actual successes in the relaxed same-width range with product-law currency. | **Unverified by these drafts.** A first-sharing bound counts an epoch, not all subsequent sparse steps. Neither the deterministic exceptional selection nor any of these three all-step sums follows just from the two column capacities or the RFJ shell sum. |
| **C_PARTITION_INPUT v1**, `/claims/17` | For every selected finite block, chronological cells/classes can be constructed with current-core equivariance, source spans/padding, unsplit inherited classes, and at most one surviving old cell of each old child per new cell. Clipping caps raw load per remaining mask at \(N_0\). Apart from separately bounded clipping, total first-mass loss is arbitrarily small relative to selected mass; expected loss over finite jitters suffices, while structural assertions hold for every realization. | **Unverified existence/loss obligation.** BC/RFJ assume appropriate realized histories and cell spans. Proving a property for every admissible history does not prove there is such a history, or that its construction has the required non-clipping losses. The narrow estimate can bound clipping **after** such cells exist, not supply all partition properties. |
| **C_SECOND_MOMENT_REDUCTION v1**, `/claims/18` | Assuming centre selections, birth prescriptions, and the full first-sharing, sparse and partition inputs, no measurable positive-measure set can avoid original approximation intervals on a whole tail; hence the main theorem follows. The reduction must transfer virtual first mass to realized true grids, control cumulative losses and energy, and make the almost-everywhere conclusion. | **Unverified by the old Argus certificates.** `tables.tex:963-1028` explicitly needs all three inputs, hard first-mass retention, a soft-loss estimate against actual virtual mass, non-soft loss budgets, and an energy bound. The two assessed draft units do not prove this complete reduction or discharge those premises. |

For the sparse input, the first distance range is
\[
 r_{xy}^+e^{-e^{\sigma_gY}}\le |x-y|\le C r_{xy}^+,
\]
the second range is \(|x-y|\le C r_{xy}^+\), and the third is the relaxed same-width range stated in the table. The first and third may use actual raw arrivals before coarsening. Their after-prime probability factors are **two** factors; they must not be relabelled as the narrow common-mask currency. These are actual quantitative obligations, not synonyms for BC's algebraic capacity inequality.

## Why the existing results do not close this unit

The ledger's intended decomposition is

\[
 C_{\rm FIRST\_JOIN}\Leftarrow
 C_{\rm DIRECT\_JOIN}\ \&\ C_{\rm REMAINING\_JOIN},
\]
\[
 C_{\rm DSC}\Leftarrow
 C_{\rm FIRST\_JOIN}\ \&\ C_{\rm SPARSE\_INPUT}\ \&
 C_{\rm PARTITION\_INPUT}\ \&\ C_{\rm SECOND\_MOMENT\_REDUCTION}.
\]

These are plans, not proof-producing rules. Even conditional support for RFJ v5 closes only the remaining-comparison part, under its data hypotheses. The direct branch remains distinct, as do the other three inputs and the reduction. The finite Lean source proves neither the displayed totient-divergence implication nor a construction of these inputs; its compiler verdict is not a manuscript-level certificate.

The distinction between an implication and existence is decisive. A universal estimate on histories in a class \(\mathcal H\) does not imply \(\mathcal H\) is nonempty, preserves a fixed share of first mass, or can be built chronologically with specified losses. This is the concrete missing inference if the conditional units are presented as a proof of C_DSC.

Likewise, source-faithful BHV background does not fill the gap: BHV14 applies to rational shifts, and BHV18 has an existential \(f\)-dependent Liouville shift plus extra divergence. Neither gives the arbitrary prescribed real shift under bare totient divergence.

The manuscript itself contains proposed arguments for the direct, sparse, partition and reduction statements. Those references are not absent sources. Their complete proofs were **not** independently audited in the inventoried Argus drafts, and this bounded review does not turn them into a new paper-wide verification or launch a new error search.

## Disposition, duplicates, and exclusions

All **six v1 versions** are mapped; none has been silently promoted from open to proved. C_FIRST_JOIN has conditional support for one branch, not complete support. The other five retain the exact unresolved obligations above. No false manuscript assertion, counterexample, or novelty result is certified.

The same reference statements in the ledger, graph and manuscript are duplicate representations, not three proofs. R_DSC_CONSTRUCTION and R_FIRST_JOIN_SPLIT remain unclosed dependency plans. The graph's “complete manuscript analytic construction” route is untried in this inventory, not refuted.

**C9000022 v1** is explicitly excluded from the mathematical result count: it is the old malformed, HTML-containing audit mission, not a well-formed conjecture or a theorem. Its dependencies on BC and RFJ are retained in the coverage index as historical task metadata. It is not silently identified with C_DSC.

This completes the Engineer **assessment of what this inventory does and does not establish**, not the proof of these six claims. Native independent Reviewer acceptance of this assessment and family-wide coverage remains required.
