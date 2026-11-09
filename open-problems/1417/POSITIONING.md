# Scientific positioning of the uniform edge-deficit bound

The mathematical argument in [PROOF.md](PROOF.md) is unchanged. Its seven
claims have independent mathematical acceptance from the reviewed handoff
`a2e353069ea9`, recorded in `roles/reviewer/progress.json` and
`research/MATH_STATE.json`. This note assesses originality and significance;
it does not turn those scientific assessments into a formal theorem or a
publication verdict.

## The contribution being assessed

For every finite simple undirected graph of minimum degree at least three,
with no proper subgraph of minimum degree at least three **even when
non-induced subgraphs are allowed**, and with no simple \(C_4\) or \(C_8\),
the accepted theorem gives, for \(d=2n-m\),
\[
 n\leq4d^2,\qquad
 n\leq\max\{8d,4d^2-8d\}\quad\text{if }G\ne\varnothing.
\]
Cycles need not be induced. The theorem excludes every order-unbounded
family with a fixed edge deficit under these hypotheses. It does not bound
\(d\) above and consequently does not give an absolute order bound.

For a minimum-order, then minimum-size Erdos-Gyarfas counterexample, the
same theorem applies without any additional mathematical assumption.
Combining it with the earlier independently reviewed campaign bound
\(d\geq7\) gives
\[
 m\leq2n-\max\left\{7,
   \left\lceil1+\frac{\sqrt{n+4}}2\right\rceil\right\}.
\]
The reviewed comparison already establishes that deficit seven forces
\(n\leq140\), and that this improves \(m\leq2n-7\) for every \(n\geq141\).
The \(d\geq7\) comparison is an accepted campaign result, not a claimed
published external benchmark.

## Contemporary primary-source comparison

The comparison uses the specified versions, not later revisions. The
source reader inspected relevant proof passages as well as statements.
Original TeX or PDF text is retained below so the new scientific assessment
can be reviewed without repeating the accepted mathematical proof.

| Source and exact locus | Hypotheses and result | Comparison with the accepted theorem |
|---|---|---|
| Ducoffe and Dumitru, arXiv:2609.28594v1, Sections 3.1-3.3; Lemma 3.2, Theorem 3.3, Proposition 3.4, Lemma 3.5, Theorems 3.7-3.8 | Minimum-order, then minimum-size counterexamples avoiding all power-of-two cycle lengths. They obtain strong non-induced criticality, \(m\leq2n-2\), \(\ell\geq2n/3+1\), a doubling projection, and exclusion of every \(2^j\)-subdivision of a multigraph of minimum degree at least three. | This is a contemporary structural baseline, not the strongest inspected edge restriction: the excess-sensitive antecedent below must also be retained. The stated edge restriction is a constant deficit. The cubic proportion and subdivision exclusion are different constraints, not superseded by our edge bound. The projection's 2-degeneracy and the general subdivision exclusion use global counterexample minimality and avoidance of all dyadic lengths. Our theorem assumes only strong criticality and exclusion of \(C_4,C_8\). No order-deficit derivation was found in these inspected passages. |
| HayosoAi, *Excess-Degree Bounds for Minimal Counterexamples to the Erdos-Gyarfas Conjecture*, printed Version 1, Theorem 4 and Corollary 5, printed pages 3-4; Lemmas 1-3, pages 2-3 | For a minimum-order, then minimum-size counterexample, \(A=L\), \(h=|H|\), and \(s=\sum_{v\in H}(\deg(v)-4)\), Theorem 4 gives \(|A|\geq2h+s+4\). Corollary 5 gives \(m\leq2n-h-2\), equivalently \(d\geq h+2\). If \(h=1\), it gives the sharper \(d\geq4+\lceil s/2\rceil\). | This is already a nonconstant, high-vertex-sensitive deficit bound. It is not superseded uniformly by our order-only bound. The general proof obtains 2-degeneracy of the branch graph from global counterexample minimality and all-dyadic avoidance, then uses the cut identity and parity. It does not state the uniform theorem for strongly critical \(C_4,C_8\)-free graphs. Its special \(h=1\) square-free argument is an additional antecedent, not a novelty claim of this campaign. |
| Narins, Pokrovskiy and Szabo, arXiv:1408.5289v1, introduction and Section 4; Theorems 1.4 and 4.1 | The principal degree 3-critical definition fixes \(m=2n-2\) and excludes proper **induced** subgraphs. Section 4 separately characterizes the **non-induced** critical class at that same fixed density: wheels and two connector-identified \(H_i,H_j\) pieces. These graphs are pancyclic. | The non-induced characterization settles the extremal endpoint \(d=2\), not arbitrary \(d\). Its pancyclicity already rules out that endpoint in our \(C_4,C_8\)-free class. The induced-critical \(C_{23}\)-free examples are neither counterexamples to our theorem nor priority for its stronger-criticality, variable-deficit assertion. |
| Di Braccio, Katsamaktsis, Ma, Malekshahian and Zhao, arXiv:2504.11656v1, Section 1, Theorems 1-5 and relevant proofs | Degree 3-critical again means \(m=2n-2\) and induced criticality. Theorem 1 gives at least \(\log_2 n/(3+\log_2 3)+O(1)\) distinct cycle lengths. Theorem 2 counts leaf-to-leaf lengths in a tree in terms of its maximum degree and number of leaves. Theorem 4 requires \(n\geq2^{N/2}\); the lower bound in Theorem 5 excludes degree-two vertices. | Counting distinct lengths does not force either particular forbidden length 4 or 8, or bound multiplicities of paths with the same endpoint labels. Their cycle proof uses a saturated deletion ordering whose exact forward degrees come from the fixed edge-count equality, followed by vines or shared-leaf trees. Stronger criticality does not supply that missing equality for arbitrary deficit. No variable-deficit conclusion was found in those inspected proofs. |

This is a statement-and-method comparison, not an argument from unsuccessful
keyword retrieval. Neither a constant-deficit comparison nor numerical
nonimplication establishes originality.

## Exact relationship to the excess-degree antecedent

The notation translates without changing any graph hypothesis:
\[
 2m=3\ell+4h+s,\qquad n=\ell+h,\qquad 2d=\ell-s.
\]
Thus HayosoAi's \(\ell\geq2h+s+4\) is exactly \(d\geq h+2\).
For \(h\geq2\), its proof puts
\[
 \delta_{\rm aux}=2h-3-a_1\geq0,\qquad
 \ell=2h+s+3+\delta_{\rm aux}+a_3.
\]
The degree sum in \(G[L]\) makes \(\delta_{\rm aux}+a_3\) positive and
odd. This is the additional unit beyond the projection's degeneracy
bound; it is not an order estimate.

On globally minimal counterexamples the cited antecedent and the accepted
campaign results can be retained together:
\[
 d\geq
 \max\left\{7,\ h+2,\
       \left\lceil1+\frac{\sqrt{n+4}}2\right\rceil\right\}.       \tag{P}
\]
This is a comparison of existing restrictions, not a new independently
certified claim. For integer \(h\geq2\), the order term alone is strictly
larger than \(h+2\) exactly when \(n>4h(h+2)\). The high-vertex term is
strictly larger than the order term when \(n\leq4h^2-4\); between these
thresholds the two integer bounds agree. The common floor seven in (P)
can mask either improvement. Asymptotically the high-vertex restriction
is stronger when \(h\) is much larger than \(\sqrt n\), and the order-only
restriction is stronger when \(2\leq h=o(\sqrt n)\).
These comparisons do not assert that either parameter regime contains
counterexample graphs.
The threshold identities follow by comparing the ceiling with the
integers \(h+1,h+2\) and squaring nonnegative quantities; no graph
construction or finite search is used.

The exceptional cases must not be hidden by that general comparison.
For \(h=0\), cubicity already gives \(d=n/2\), so the uniform bound is
weak. For \(h=1\), HayosoAi's sharper estimate and \(s=n-1-2d\) imply
\(n\leq4d-7\), with a possible additional parity unit. This is stronger
than a quadratic fixed-deficit order bound. Its proof uses the square
obstruction and the basic criticality consequences, not the global
branch-graph minimality argument used for \(h\geq2\).

The different hypotheses explain why the general antecedent cannot
simply be applied to the full uniform-theorem class. Strong non-induced
criticality controls actual proper subgraphs of \(G\). The branch graph
on \(H\) is not such a subgraph: its edges represent two-edge paths
through cubic vertices. A subgraph of that branch graph of minimum
degree three yields a *smaller counterexample* only when it avoids every
dyadic cycle. Under just \(C_4,C_8\) exclusion in \(G\), a projected
\(C_8\) would lift to an allowed \(C_{16}\). Consequently the source's
contradiction to global minimum order, and hence its general
2-degeneracy step, are unavailable under the broader hypotheses.
This identifies the exact missing premise; it is not a claim that a
branch graph with a 3-core has been realized in the uniform class.

Our proof instead needs only that the branch graph is simple and
\(C_4\)-free. It counts incidences meeting vertices of degree at least
five, budgets their number by \(d\), and cancels the remaining
degree-four high vertices. It never assumes \(h\leq d-2\) or branch-graph
2-degeneracy. That is a substantive difference in the argument, rather
than a numerical example offered as evidence of novelty.

## Attribution of methods

High-vertex independence, deletion/degeneracy reductions and cubic
incidence counting are inherited structural tools. The leaf-incidence
projection is the same construction as HayosoAi's Lemma 2, the
additive-density draft's Lemma 4, and the September paper's Lemma 3.5:
cubic vertices with two high neighbours become high-high edges.
Simplicity follows by lifting parallel edges to a \(C_4\), and a
projected \(C_4\) lifts to a \(C_8\). The identity
\(4h+s=2a_1+a_2\), its equivalent form \(a_1-a_3=4h-2d\),
and parity counting are also inherited. We do **not** claim originality
for the projection, cycle doubling, or those incidence identities.

The distinctive supplied argument combines three further ingredients:

1. The component-sponsor count bounds \(p+t\leq d\), where \(p\) counts
   vertices of degree at least five and \(t\) is the cycle rank of the
   cubic-vertex induced graph. This is a global deficit budget, with no
   assumption that low components are trees.
2. The global count permits at most five low two-edge paths per unordered
   pair of distinct high endpoint labels. Disjoint paths force \(C_8\);
   all remaining overlaps are controlled by a five-vertex neighbourhood.
   This controls multiplicity across all components, not the number of
   distinct path lengths in a selected tree.
3. Exact boundary-incidence substitution cancels the number of degree-four
   high vertices and gives \(n\leq8d+4p^2-16p\). Combining this with
   \(p\leq d\) produces the explicit quadratic order bound.

The earlier campaign four-defect proof is also a direct antecedent of
the incidence and sponsorship arguments. The improvement is their
parameter-uniform extension with global packing and cancellation,
not independent rediscovery of those earlier identities.

## The provisional additive-density draft

The separately retained manuscript *Additive Cubic-Density Constraints
on Minimal Counterexamples to the Erdos-Gyarfas Conjecture*, printed
16 August 2026, explicitly describes its Theorems 1-2 as **candidate**
AI-assisted results. Its Status states that no independent human expert
verification has been completed and that no priority claim is made.
The headline assertions are \(\ell\geq2h+8\) and, for \(h\geq14\),
\(\ell\geq2h+10\). Recording what this draft asserts does not accept its
finite computations or promote these assertions to verified theorems.

Its symbol \(d\) means the *auxiliary* defect \(2h-a_1\), not our
\(2n-m\). Writing that defect as \(\Delta\) avoids conflation:
\[
 \ell=2h+\Delta+s+a_3,\qquad
 \Delta\equiv a_3\pmod2,\qquad
 d=h+\frac{\Delta+a_3}{2}.
\]
The draft's large-\(h\) fixed-defect bounds and parity also yield
candidate excess-sensitive restrictions: \(d\geq h+4\) for \(h\geq11\)
from equation (6) and Section 5.1, and \(d\geq h+5\) for \(h\geq16\)
from equation (10). These remain conditional on its unaccepted finite
inputs; even at face value they are high-vertex-sensitive restrictions,
not a uniform order-only bound.

There is genuine overlap of method, which must be attributed. Sections
5.2-5.4 and 6.1-6.2 use labelled low components, exact high-neighbour
capacities, local cycle lifts, and charging summed over components.
Their endpoint-budget certificates bound the number of internal
vertices in a *whole path* with two fixed endpoint tokens, after
reducing specified exceptional auxiliary cores to path-only cases.
The source's Lemma 7 concerns 1,943 such labelled cases at \(h=14,15\),
with auxiliary defect eight, \(a_3=0\), and \(s\in\{0,1\}\).
The local lift checks there forbid \(C_4,C_8,C_{16}\).

In contrast, the supplied uniform proof bounds the number of
*two-edge paths sharing an unordered pair of high-neighbour labels*.
It uses only \(C_4,C_8\): disjoint paths force \(C_8\), and intersecting
paths have at most five possible middle vertices in a maximum-degree-two
graph. The count applies globally at arbitrary order and deficit,
without selecting an auxiliary core, certifying a finite endpoint
budget, or excluding cyclic low components. Boundary incidences account
for branching components. Thus the draft is a relevant precedent for
component charging, not a source we can dismiss merely because its
headline constants differ. No version of the uniform same-label
multiplicity estimate or its degree-four cancellation was found in
the inspected proof passages.

Both new documents are publicly accessible sources. HayosoAi's
"Version 1 - August 2026" and the additive draft's printed date are
reported as text in the documents, **not independently established
initial-publication dates**. No publication priority, author identity
beyond the printed attribution, peer-review status, or human
verification is inferred from self-dating or repository availability.

## Focused historical follow-through

Four directly relevant antecedents were considered; this is not a survey.

**Carr, arXiv:2605.22844v1.** Lemma 0.1, Corollary 0.1 and Theorem 0.1
give strong criticality, cubic domination, high-vertex independence and a
\(4/7\) cubic proportion for minimal counterexamples. These are deletion
and incidence precedents. The September paper's stronger proportion is
the current comparison; neither proportion is itself an order-deficit
bound.

**Carr, arXiv:2508.19302v1.** The main theorem forces \(C_4\) or \(C_8\)
under the additional hypothesis of diameter two. Our graph class has no
diameter restriction, so that theorem is not a full-family exclusion or
an order-deficit estimate for the present hypotheses.

**Erdos, Faudree, Gyarfas and Schelp, Ars Combinatoria 25B (1988),
195-201.** The original scan was obtained. Theorems 2-3 concern short
cycles or girth at fixed edge deficits, while Theorem 5 uses saturated
ordering and forward paths. A superficially conflicting antecedent is
Theorem 4's order-unbounded, fixed-deficit high-girth construction.
Its proof explicitly preserves a degree-two vertex in the last rim.
It therefore does not satisfy our minimum-degree hypothesis, regardless
of the historical induced/non-induced terminology. Narins et al.'s
introduction expressly documents that terminology problem. Their
Lemma 2.1 is also a genuine antecedent for converting one or two disjoint
leaf paths into even cycles, but not the supplied global, overlap-aware
same-label packing bound.

**Bollobas and Brightwell, Long cycles in graphs with no subgraphs of
minimal degree 3 (1989), DOI 10.1016/0012-365X(89)90077-0.** Bibliographic
identity and the modern vine attribution are verified in the 2025
primary source. Its introduction attributes their degree-critical
results to a fixed-density class. The historical primary proof was not
obtained, so we do not assert that all its auxiliary arguments have been
checked or that it contains no relevant variable-deficit lemma. The
source reader reported publisher HTTP 403 and failed proposed copy
locations. One distinct Semantic Scholar DOI-record request on
2026-11-03 returned HTTP 429 and supplied no open-access URL; it was not
retried. This access limitation is not evidence of novelty.

## Significance and scientific assessment

The independently supported publication-level case is an **unbounded
order-only square-root edge-deficit restriction** and a
**parameter-uniform near-extremal structural obstruction**. Compared
with a constant-deficit restriction it gives an unbounded improvement;
compared with HayosoAi's \(d\geq h+2\) it supplies the complementary
order restriction in (P), not a uniformly stronger bound. It also
applies to the broader strongly critical \(C_4,C_8\)-free class, where
the antecedent's general degeneracy argument is unavailable.
The global deficit budget, same-label multiplicity bound and exact
degree-four cancellation supply the argument missing from the inspected
antecedents. They handle cyclic and branching low components without an
essential finite computation. These are mathematical grounds for
significance, not a claim to have resolved Erdos-Gyarfas.

The improvement is sublinear: the upper bound on \(m/n\) still tends to
two. The constants, quadratic exponent and boundary terms are not
claimed sharp. On cubic graphs the bound is weak, since \(d=n/2\).
No algorithmic complexity, practical search-speed benefit, unrestricted
family classification, counterexample, or conjecture resolution is
asserted.

**Engineer recommendation:** retain `improved_bound` and the already
supported publication-level significance assessment. The revised
originality case rests on the broader hypotheses and the uniform
budget, multiplicity and cancellation argument absent from the inspected
antecedents, not on arithmetic nonimplication or an assertion of priority.
The earlier independent mathematical and significance judgments are
preserved. `novelty_status=verified_new` and publication acceptance
remain reserved for the normal independent Reviewer decision.
Unexamined literature and the historical primary-proof access gap remain
explicit limits of this focused assessment.

The former citation-write allocation blocker is resolved. The separate
reader `reader:Copilot:uniform-deficit-citations` opened and natively
attributed all **nine** source propositions of
`C_UED_SOURCE_COMPARISON`, current version 11, with supporting
source-specific archives under `research/literature/`. Native citation
status exited **zero**, with no remaining work or blocking entries.
This was a genuinely separate reader, not a relabelled confirmation by
either citation filer.

After every attribution both official checks exited zero against exactly
`/home/argustest/zimo/counterexample-batch-1/campaigns/1417`.
The seven accepted mathematical claims and
`C_UED_SIGNIFICANCE_ASSESSMENT` remain version 1 with their existing
supporting independent Reviewer judgments. Literature-tier attribution
verifies what a source states, including the candidate draft's
disclaimers; it does not certify that draft's proofs or settle the
uniform theorem's originality. The remaining publication gate is the
normal independent Reviewer's judgment of this revised originality case
and source comparison, reusing the accepted mathematics and significance.

## Sources available for replay

- [Ducoffe and Dumitru v1](https://arxiv.org/src/2609.28594v1):
  `sources/ducoffe-dumitru-2609.28594v1.tex`, lines 290-445;
  bibliography retained alongside it.
- [Narins, Pokrovskiy and Szabo v1](https://arxiv.org/abs/1408.5289v1):
  existing campaign `research/minimal_counterexample_edge_bound/sources/`
  `narins-pokrovskiy-szabo-1408.5289v1.txt` and `.pdf`; text lines 56-116,
  169-209, 659-860.
- [Di Braccio et al. v1](https://arxiv.org/src/2504.11656v1):
  `sources/di-braccio-et-al-2504.11656v1.tex`, lines 104-180,
  213-295, 356-386, 640-689, 700-714 and 832-970; original `.bbl`
  retained alongside it.
- [Carr's predominantly cubic theorem v1](https://arxiv.org/abs/2605.22844v1):
  existing campaign `research/minimal_counterexample_edge_bound/sources/`
  `carr-2605.22844v1.txt` and `.pdf`, text lines 67-158.
- [Carr's diameter-two theorem v1](https://arxiv.org/src/2508.19302v1):
  `sources/carr-2508.19302v1.tex`, main theorem at lines 38-41.
- [Original EFGS 1988 scan](https://users.renyi.hu/~p_erdos/1988-06.pdf):
  `sources/efgs-1988.pdf` and layout extraction `sources/efgs-1988.txt`;
  Theorem 4 and its degree-two invariant at text lines 220-284,
  printed pages 199-200.
- [Bollobas-Brightwell DOI](https://doi.org/10.1016/0012-365X(89)90077-0):
  original proof unavailable; bibliographic and vine attributions only
  in the retained 2025 source, not a purported copy of the 1989 proof.
- [HayosoAi's excess-degree manuscript](https://zackaryloevseth.github.io/research-portfolio/assets/publications/erdos64/manuscript.pdf):
  `sources/hayosoai-excess-degree-version1.pdf` and `.txt`;
  Lemmas 1-3 and Theorem 4/Corollary 5, printed pages 2-4.
- [Provisional additive-density draft v1](https://airaxiv.com/papers/pdf/2608.0018/?v=1&t=1786961842):
  `sources/additive-cubic-density-2608.0018v1.pdf` and `.txt`;
  Status and Theorems 1-2, printed pages 1-2; auxiliary-defect identity,
  Section 3; fixed-defect and component-budget arguments, Sections 4-6.

The adjacent `*-excerpt.txt` files contain short primary passages with
their precise locators. They are not replacements for the original sources.
