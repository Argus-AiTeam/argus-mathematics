# Companion trace: source correspondence, not maximality verification

**Unit:** `companion-trace`. **Historical claim:** `C_RS_TRACE`, version 1.
**Assessment:** supported as a limited source/dependency comparison.
**Reviewer acceptance:** `pending_native_independent_review`.

This is an Engineer assessment and a distinct source-text reading by
`reader:source-trace-engineer`, not the final independent Reviewer's decision.
The positive-characteristic nodal/transfer/composition proof is assessed in
other units; it is not re-audited here.

## Read-only inputs and version correspondence

The historical claim is in
`families/039/first-pass/MATH_STATE.json`,
`claims[claim_id=C_RS_TRACE,version=1]`, content hash
`928142eb39a56d61e324967132fd1cf41e0ef72f9fb1ccc4a0b4f14fa6ef978d`.
Its exact statement is:

> The complex higher-dimensional and polarized-surface companions use the corresponding nodal-bound, lattice-change and compression constructions with backward finite jet transfer; their maximality conclusions are downstream assertions, not hypotheses of this audit.

The historical `research/PROOF_GRAPH.json`, `nodes.C_RS_TRACE`, remains
`open`, with `reviewer_confirmed=false`. Historical ledger judgments by
`engineer:reshaping-audit` and `reviewer:reshaping-audit` are historical evidence,
not native acceptance of the present review.

The old prose source is
`families/039/first-pass/reshaping_audit/report.md`:
lines 3–33 identify the target and eliminated attacks; 35–52 already claim
the stronger `dw<1/3` theorem and mixed-order maximum-rank transfer;
273–311 supply the companion/downstream trace; 312–364 delimit the evidence.
Nothing in this unit is a newly discovered strengthening or a novelty claim.

All source paths below use this **read-only staged root**:

`families/039/first-pass/openai_manuscript/`

Its cited files resolve under:

`openai-math/preprints/`

with the same manuscript-relative paths. Abbreviations are:

* **PC** = `Maximal-multipoint-Seshadri-constants-in-positive-characteristic-October-5-2026/build/build/sections/`
* **HD** = `Maximal-Multipoint-Seshadri-Constants-in-Higher-Dimensions-October-5-2026/build/sections/`
* **S** = `Maximal-Seshadri-Constants-on-Arbitrary-Polarized-Surfaces-September-23-2026/build/sections/`

The existing, unmodified manifest is
`campaigns/9100039/MANUSCRIPTS.json`,
revision **`4eaee87548250b2682affda7d05d947c05554bae`**.
Direct SHA-256 comparisons found the following actual files byte-identical
to its entries:

| Used source | Actual SHA-256 = existing manifest SHA-256 |
|---|---|
| PC `01-introduction.tex` | `45910663c5b97ba5ae498d807915cf2664fe44a5d325de917076e5993d7a9b95` |
| PC `02-transfer.tex` | `0ca30b7d733c18f61d634c82f03f8e9953461bd0bc3e75e1476ed67bdcd6c5cc` |
| PC `04-reshape.tex` | `0e85d7a93a2fc35237335ac1f7990a616fed988f820e41b846b855b247d58c1a` |
| HD `reshaping.tex` | `64e6504afb1173ec4af708f9ccb7c8f5b5b981efcdf4f7bc89821806a77345e3` |
| HD `transfers.tex` | `fa80a3d305623562e872d36e45db0f4a9706777afe858da31842752021c4f0b5` |
| S `node.tex` | `20f4ef9773e8ed4cba5532da064f1ef909cb4fa6ae807bbddc86983253331527` |
| S `compression.tex` | `fc219b3471382efe3a0f67e512dd5fe82b0031a8520d7de0ad949798da6984b9` |
| S `jets.tex` | `03f0d6efba54b2682ee0ff6490d87c7fc60cbacc0f13ae1ff7ad180987ca6863` |

This is a scoped byte comparison, not a rebuilt/extended manifest or a
claim to have verified an entire checkout's revision. No git operation
was used. There is **no source/version mismatch** for these files.

## Exact positive-characteristic target and conventions

PC `04-reshape.tex:14–28`, **`prop:reshape`**, takes `n>=2`, positive
real simplex intercepts `A,B,a_3,...,a_n`, and finite supports `S_N`
for **every** integer `N>=1`, with
`S_N ⊂ N Delta(A,B,a_3,...,a_n)`. With
`H=AB`, `d=max(3/A,2/B)`, and `w>0`, the source hypothesis is
**`dw<1/16`**, not `dw<1/3`. It asserts supports in
`N Delta(w,H/w,a_3,...,a_n)`, exact cardinality in every degree,
gradedness, and backward jet transfer in every degree. For `n=2` the
remaining intercept list is empty. The input need not fill its simplex.

PC `01-introduction.tex:131–135` defines
`Delta(a_1,...,a_n)={x in R_{\ge0}^n: sum x_i/a_i<=1}`; lines
144–151 explicitly describe a prescribed **real** `w`. No rationality
restriction is imposed. PC `02-transfer.tex:39–48`, **`def:graded`**,
means `S_N+S_M ⊂ S_{N+M}` for all positive `N,M`.

PC `02-transfer.tex:11–19,31–48` supplies the exact jet convention:
`k` is algebraically closed; that section explicitly works in every
characteristic; `J_y^m(A)=A_y/m_y^{m+1}A_y`, `m>=0`; separation means
**surjectivity**. For every fixed `N,r>=1,m>=0`, existence of a distinct
`k`-torus tuple separating the output jets implies existence for the
input, **possibly at a different tuple**. This is not a single tuple
working simultaneously in every degree, and the definition uses a
common order `m` at its finitely many points. It does not itself state
the old Argus mixed-order maximum-rank strengthening.

PC `04-reshape.tex:46–59`, **`lem:nodal-bound`**, and 73–84 use
**`g=y^2+xy-x^3`**, with roots `0,-1` of `Z^2+Z-x` modulo `x`
and independent linear terms `y,y+x`, expressly also in characteristic
two. This is not the complex companion's node. PC
`02-transfer.tex:225–238`, **`lem:compression`**, replaces a Laurent
row by its possible orders at `z=1`, retaining the other labels; a
row in a real interval of length `b` has new orders in `[0,b]`.
Lines 252–259 explicitly permit gaps, giving `Span{1,z^p}` with
orders `0,p` in characteristic `p`.

PC `04-reshape.tex:238–295` fixes the choices across degrees, carries
coordinates `3,...,n` as labels and uses real residual degree
`kappa=N-sum gamma_h/a_h>=0`; its completion explicitly treats
`kappa=0`. These are source-text observations, not a second assessment
of the universal proof. The manuscript's *main maximality theorem*
still has positive-characteristic hypotheses; textual generality of
its auxiliary transfer section does not certify main theorems in
other characteristics.

Thus characteristic-two coincidence for the **different** complex node,
or an objection requiring consecutive compressed orders, attacks a
statement the PC source does not make. Rejecting those Argus objections
is neither a refutation nor a verification of an original manuscript.

## Complex higher-dimensional correspondence

The old report's locators identify the correct staged construction.
More complete statement boundaries are:

| Source locator | Supported source correspondence |
|---|---|
| HD `reshaping.tex:16–34`, `prop:reshape` | Positive real intercepts, arbitrary graded finite supports, original `dw<1/16`, all-degree cardinality/gradedness, backward surjective finite jets. The old 16–29 locator omits the explicit jet implication at 31–33. |
| `reshaping.tex:45–57`, `eq:residual-degree` | Unchanged labels, residual `kappa>=0`, empty label for `n=2`, and the zero residual case. Old 42–49 points nearby but is incomplete. |
| `reshaping.tex:61–75`, `eq:node-polynomial`, `eq:node-parametrization`, `eq:node-coordinates` | Over `C`, node `y^2-x^2(1+x)`, parametrization `x=v^2-1,y=v(v^2-1)`, and analytic square-root coordinates. Old 61–70 does not include the coordinate formula. |
| `reshaping.tex:131–156`, `eq:node-envelope`, `eq:node-area` | Nodal quadrilateral, `c=1/d`, `a+b=dH`, area `H/2`. |
| `reshaping.tex:185–204`, `eq:compressed-triangle` | Integral shear and coordinate compression to `P=conv{(-b,0),(a,0),(0,c)}`. |
| `reshaping.tex:214–252`, `eq:primitive-interval`, `eq:vertex-heights` | Primitive-direction tuning; shape and lattice map fixed for all degrees. |
| `reshaping.tex:250–276`, particularly 254–271, `eq:tent-triangle` | The old final-tent locator is correct: unimodular coordinates, horizontal compression, then vertical compression to `Delta(w,H/w)`. |
| HD `transfers.tex:122–139`, `lem:weighted-limit`; 155–167, `lem:rank-transfer` | Convergent complex series, a common exposing positive weight, unchanged Laurent factors, and persistence for a fixed finite jet test. Old 155–169 identifies this lemma, not its weighted-limit hypotheses by itself. |
| `transfers.tex:190–195`, `lem:unimodular`; 222–234 and proof through 263, `lem:compression` | Torus-coordinate changes and order-at-one compression preserve the stated graded/cardinality/jet implications. |

These are complex analytic finite-degree transfers. The statement of
the auxiliary reshaping proposition allows `n=2`; that is not the
dimension hypothesis of the complex **main theorem**, which is `n>=3`.
The trace does not transplant this complex node to characteristic two.

## Surface correspondence and a necessary distinction

S `node.tex:15–21`, **`lem:node`**, concerns a smooth integral complex
projective surface, an ample `L`, and an **integral global divisor**
`V in |dL|` with two transverse analytic branches. It is not the
assertion that every surface has one of the planar polynomial equations
above. In `node.tex:77–108`, `H=L^2`, the local defining section is
`u(x,z)xz`, `u(0,0)!=0`, and `T>1` is chosen so
`(1+t)^2>d^2Ht` for all `t>T`. Its parameters are
`c=1/d`, `a=dHt/(1+t)`, `b=dH/(1+t)`.

S `node.tex:110–120`, **`prop:quadrilateral`**, asserts the bound for
every `k>=1` and every nonzero **actual section** of `kL`, with a
distinct-initial-exponent basis. The old 110–151 locator correctly
identifies that proposition and part of its intersection argument.
It does not say all lattice monomials in the quadrilateral are initial
sections.

S `compression.tex:1–13` explicitly works with the **full monomial
spaces** `M(kQ_t)` and `M(kP_t)`, not an arbitrary sparse support.
Its `P_t=conv{(-b,0),(a,0),(0,c)}` has area `H/2`.
**`prop:compression`**, lines 57–62, with construction at 64–134,
gives backward **injectivity**, and **`cor:surface-transfer`**,
137–142 (proof 144–157), passes the test back to `H^0(S,kL)`.
The old 57–121 and 138–155 ranges correctly locate the constructions,
but omit their endpoints. S `jets.tex:7–24` defines order-`m` by
`O/m^m`, i.e. vanishing of terms of degree **less than** `m`, and
injectivity is full column rank. This differs from PC/HD
surjectivity onto jets through degree `m`, using `O/m^{m+1}`.

S `nef.tex:206–220`, cited by the old report, is indeed a downstream
use of the torus test and section transfer. It is not part of the
source-trace conclusion. The separate uniform subgroup interpolation,
very-general-locus, and all-curves nefness obligations are itemized
in `../downstream-boundaries/report.md`.

## Attribution results and evidence boundary

All four requested source-text attributions were filed with the official
`citation_check attribute`, actor **`reader:source-trace-engineer`**,
distinct from their filer `engineer:old-draft-review`. Each returned
`ok=true`, `verdict=supports`, citation status `confirmed`, and no refusals:

| Active claim / assumption | Exact local excerpt | Recorded evidence / official archive |
|---|---|---|
| `C_REVIEW` / `A_PC_TARGET` | `pc-target-excerpts.tex` | `citation-A_PC_TARGET-9b401a226270`; `research/literature/98053a18d09eb77a25395191f5b57042.json` |
| `C_REVIEW_SCOPE` / `A_PC_SCOPE` | `pc-scope-excerpts.tex` | `citation-A_PC_SCOPE-d5d414229a1d`; `research/literature/e7635e2510421af4dc00f83cb881c3d6.json` |
| `C_REVIEW_TRACE` / `A_HD_TRACE` | `hd-trace-excerpts.tex` | `citation-A_HD_TRACE-d0f0633a60e5`; `research/literature/a62ac52c9ff0d93dd3605bc21f638ae1.json` |
| `C_REVIEW_TRACE` / `A_SURFACE_TRACE` | `surface-trace-excerpts.tex` | `citation-A_SURFACE_TRACE-ea640e3800e8`; `research/literature/4c7752d546ad244992f4689d185b1e50.json` |

The four filed source IDs and locators are accurate; **no assumption
correction is required**. The fuller line ranges above are precision
improvements to old prose locators, not source/version changes.
The module itself created the literature archives; no other active
claims or graph statuses were changed.

“Supports” here means that the primary text says the attributed thing.
It does **not** endorse every proof in those files, any maximality
theorem, priority, or the full old Argus strengthening. The genuine
contribution of this unit is reproducible attribution and separation of
these evidence types; the construction belongs to the cited manuscripts.

## Validation and remaining obligations

All **26** exact excerpt blocks in the four companion files were checked
against their declared source lines; together with the downstream excerpt,
the check passed **31 blocks in five files**. Eight core source files
are detailed here; the cited downstream `nef.tex` is detailed in the
downstream unit. Eighteen unique relevant files across both units were
compared to the existing manifest, all matching. No unrelated source
files were hashed, and no new manuscript-error search was performed.

After the four ledger attributions, the official checks used
`$WORKSPACE/argus-latest/.venv/bin/python` and explicit root
`campaigns/9200039`:

* `-m argus_skill.verticals.math.math_state check --project-root <root>`:
  **exit 0**, `{"ok":true,"issues":[]}`.
* `-m argus_skill.verticals.math.proof_graph_check check --project-root <root>`:
  **exit 0**, `proof graph valid: 12 node(s)`.

These are structural checks on the active review project, not proofs.
The unresolved mathematical boundary is concrete: a source trace supplies
neither a universal proof assessment of the PC/HD reshaping argument nor
the surface section/intersection geometry and subgroup/nefness chain;
it supplies no verification of the eight downstream/umbrella nodes.
The parent units and the native independent Reviewer must make the
appropriate separate decisions. No node is marked proved or
reviewer-confirmed by this delivery.
