# Engineer review: bounded symmetric bootstrap

**Assessment:** supported conditional analytical verification of the literal finite-test proposition. This is an exploratory old-draft review, not a new theorem, repair, novelty claim, or acceptance decision.

## Contribution classification and attribution rationale

**Classification: `confirmed_reproduction`.** `DB_MAIN` restates
OpenAI's `prop:directional-bootstrap` at `07-rate-transfer.tex:841-860`,
and `DB_RECIPROCAL` reconstructs its reciprocal improvement in the
following proof through line 993. The original proposition already
claims uniform trims and heredity. The old report's explicit common
core supplies a detailed re-proof of that conclusion, not a newly
claimed symmetric rate. The theorem is attributed to OpenAI, its
external projection input to Ren and Wang, and the detailed
reconstruction to Argus. This classification confirms the conditional
statement only; it neither erases the common-event/good-parent
hypotheses nor resolves the abbreviated RW41 dependency's separate
attribution boundary.

## Exact source and version history

The read-only index `research/DRAFT_REVIEW_INDEX.json` is the version/evidence authority. The old shared draft is `families/078/first-pass/directional_bootstrap/report.md`, SHA-256 `c3eab989a35afcd706fad01623931037846c46544ffd7f6d9b527cb77cee6cbe`. The primary passages are section 1, lines 71–107, and sections 6–7, lines 293–403; the inspected analytical dependencies are in sections 3–5 and 8, lines 172–292 and 404–473.

The literal target is `prop:directional-bootstrap`, `build/sections/07-rate-transfer.tex:841–993`, at manuscript revision `4eaee87548250b2682affda7d05d947c05554bae`. The resolved manuscript root is `openai-math/preprints/Bochner-Riesz-Multipliers-in-Three-Dimensions-September-24-2026`. The file hash is `74cabf96002ba34d49cd2cc0b79fa6141c15fbe1561c9ee535b10c3f46d0d910`. The exact projection dependency is `build/sections/03-projection.tex:23–206`, hash `265cf9b94bde9fc85fab47d26f05cab2fe5446f14a38ab8b2b59c85703fed217`. The old Ren–Wang excerpt records Theorem 4.1/Definition 3.1 of arXiv:2308.08819v3. The index's source/snapshot matches are reused, not treated as multiple results.

Both claim ids use `DB_CTX` v1, hash `df998bc708f752f5c69865c573c82a008e6b9ec2baf0e1a0905d37bd8260eda8`.

| Claim | All indexed versions | Natural-statement hash | Recorded external assumption |
|---|---|---|---|
| `DB_MAIN` | v1 | `d9d96056272f11ed54f04ce39b5a3ce6168ff76ce0e3b15c0c4513436a5da0a3` | None registered; projection input remains implicit |
| `DB_MAIN` | v2 | same | `RW41`: `1d5e25e2664a55b01aa708fb684c01ed1119522f2f2d5f1592d0cec72f619fa8` |
| `DB_MAIN` | v3 | same | `RW41`: `95d5f6fb8ffa3609af348397524a6ef9e63ceaad7add890ca4f5ecd22f839606` |
| `DB_RECIPROCAL` | v1 | `d3e9211172276643de0b46427681ad383625f0bb405a795d1533c3f2376d78de` | None registered; analytical dependencies include projection input |

Attribution is to the literal manuscript proposition and the old Argus Engineer's analytical reconstruction, with Ren–Wang supplying an external planar theorem. The finite core is a separate algebraic dependency. The contribution is conditional verification, not a novel theorem; both old claims' mathematical novelty is **not established**.

## Claims and hypotheses without silent strengthening

`DB_MAIN` v1–3 asserts: for fixed \(0<s\le1\), a sequence of bounded planar pair laws \(P\) is dominated with subpower loss by two named populations with conditional child rate \(s\). Both named populations have polynomial no-strip decay at every fixed positive depth. Original direction bins conditional on **either full pin** are homogenized on one common original subpower-mass event for every finite test, over simultaneous tested good-parent fibers. Then uniform trims give conditional direction prefix ball dimension at least \(s\) under either pin, hereditary under subpower restrictions retaining these hypotheses.

The comparison populations are not assumed to be the actual marginals. Child bounds belong to their named conditionals on the tested good-parent fibers, not automatically to every subsequently conditioned law. Separate one-sided homogenizations, separate high-mass events or unquantified intersections do not meet the common-event hypothesis.

`DB_RECIPROCAL` v1 asserts: if the same original profiles obey \(F_A(d),F_B(d)\ge ud\), for fixed \(0<u\le s\), retained-marginal transfer and the weighted projection bound imply \(F_A',F_B'\ge(s+u)/2\) almost everywhere. Integration and finitely many repetitions approach \(s\).

No-strip is uniform in strip centers/lines at each fixed width exponent, but no uniform \(\kappa_t\) is required as \(t\downarrow0\). All finite tested depths, positive increments, meshes, repetitions and loss choices precede the precision limit. All-radius projection caps are obtained by appropriately fine finite meshes, not assumed for free from one entropy value. The external assumption is the precise recorded Ren–Wang Theorem 4.1/Definition 3.1, with output loss preceding admissible input loss.

## Decisive argument checks

### `DB_RECIPROCAL`: one actual law supplies all projection inputs

The two-pin dependency gives \(F_A(d),F_B(d)\ge sd/2\). To improve a current common lower rate \(u\), fix a differentiability point \(j>0\) and fixed \(0<a<j\), \(j+a\le1\). On a tested good \(A_j\) parent, first retain the common original event \(H\), then separate the pin from its center. Denote retentions \(r_c,v_c\), and the normalized pre-core law by \(G_c\).

The original cap given full \(A\), averaged against **\(P_A(\cdot\mid A_j=c)\)** before normalization, yields the actual pin-direction cap
\[
 (G_c)_B(I)\le C(r_cv_c)^{-1}\rho^{ur-o(1)},\qquad 0<r\le a.
\]
The numerator contains \(P(A_j=c)\), which cancels the identical factor in the normalization. Averaging the named comparison measure instead would not justify this result.

Take an actual-marginal core of \(G_c\) with raw mass \(M\ge1/2\), marginals \(\alpha,\beta\), and product comparison \(q\le16D\alpha\otimes\beta\). The pin estimate is preserved by \(\beta\le M^{-1}(G_c)_B\), while the child estimate is preserved by \(\alpha\le(D/M)\mu_A(\cdot\mid c)\). Its support graph has product mass at least \(1/(16D)\). The original \(B\)-conditioned parent/child bins still provide the projection support count
\[
 L\le\rho^{-[F_B(j+a)-F_B(j)]-o(1)}.
\]
These are the point cap, slope cap, graph mass and per-tag count required on **one** law. Conditioning the named \(\mu_B\) on \(A_j\) is neither needed nor justified.

At \(\delta=\rho^a\), fixed subpower losses in \(\rho\) remain subpower in \(\delta\). For each desired projection output error, choose the admissible input loss from the precise theorem and then a sufficiently fine radius mesh; its fixed interpolation error must be smaller than that allowance. Take \(\rho\) small only afterwards. The weighted tagged theorem, including its incomplete-graph reduction, gives
\[
 F_B'(j)\ge\min\{1,s,(s+u)/2\}=(s+u)/2.
\]
The reverse argument on the same original law gives the identical bound for \(F_A'\). No new child, common-bin or product hypothesis is manufactured at an iteration.

### `DB_MAIN`: finite recurrence on the original profiles

Nested angular grids make the limiting original profiles monotone and 1-Lipschitz, vanishing at zero and hence absolutely continuous. Therefore each almost-everywhere derivative improvement integrates on those profiles. Auxiliary local cores prove inequalities about them; the iteration does not substitute the cores' newly normalized entropy profiles.

With \(u_0=s/2\) and \(u_{n+1}=(s+u_n)/2\),
\[
 u_n=s(1-2^{-(n+1)}).
\]
Every prescribed positive rate error needs only finitely many steps. For a finite depth list the integration and projection losses can be budgeted within that error. The limit assertion is obtained by sending precision to zero after each fixed finite choice, and subsequently letting the output error go to zero. There is no infinitely iterated finite-scale restriction and no claim of a uniform finite rate as the increments or profiles vary.

### One common uniform trim, not two exceptional-pin populations

For the finite output test retain the already specified original event \(H\), of mass \(m\). Its original bin numerators have the desired upper caps under each pin by the profile bounds. Apply the two-sided finite core to the **raw measure** \(\mathbf1_HP\), using references \(P_A,P_B\) and threshold \(m/4\). It retains raw original mass at least \(m/2\), with surviving row and column masses at least \((m/4)\) times those original references.

Further support deletion cannot increase any original bin numerator. Dividing each by its core row/column floor gives every actual conditional cap at **every surviving full pin**, simultaneously, with additional factor \(4/m\). Normalizing the one common core does not change these within-fiber conditional probabilities. Its support remains in \(H\), hence in the original good-parent filters, and named product domination only acquires another subpower mass factor.

This existing old-report section 7 argument is important for statement fidelity. The literal manuscript's last paragraph, lines 986–992, instead gives two typical-pin bounds on the same \(R=P(\cdot\mid H)\), without normalizing an intersection. That paragraph alone does not display an all-surviving-pin common trim. The old draft supplies that construction using the finite core, without adding a positive per-fiber retention hypothesis. This is an exposition/support distinction, not a counterexample to the proposition and not a repair performed by this review.

### Heredity is quantified

Let a further weighted support restriction of the uniform law have relative mass \(z\), with \(0\le f\le1\) and subpower \(z^{-1}\). Apply the two-sided core to \(f q\), with references the previous actual marginals and threshold \(z/4\). The raw retained relative mass is at least \(z/2\); every conditional cap costs at most another \(4/z\). Original support counts and good-parent membership persist by deletion, and named product domination persists under subpower normalization.

Thus one can obtain another common uniform trim after the restriction. This is not the false assertion that arbitrary normalized intersections preserve every conditional bound. If restrictions are made before the proof, the literal proposition still requires the stated named child comparisons and simultaneous original-bin/good-parent hypotheses; their availability is not inferred from a mass condition alone.

## Precise dependency provenance and reused evidence

`judgement-DB_MAIN-ca1db2f4cd9d` and `judgement-DB_RECIPROCAL-10e855106e52` are exact matching `reviewer:copilot-independent` supports judgements. The first matches the common conclusion hash of all three `DB_MAIN` versions. They are reused, not erased because a historical graph says “open” or a report says “pending.”

Analytical dependency support is reused from `judgement-DB_RETAINED_MARGINAL-35c3badb8353`, `judgement-DB_GEOMETRY-97ac7ebced77`, `judgement-DB_TWO_PIN-cb2ce5a3b431`, and `judgement-DB_PROJECTION_INPUT-fbf8a583b9ce`. The finite-core v2 input has `judgement-DB_FINITE_CORE-b195a60f0949` and `lean-DB_FINITE_CORE-ae96dd262933`.

The two `RW41` hashes must not be collapsed:

* Detailed hash `95d5f6fb8ffa3609af348397524a6ef9e63ceaad7add890ca4f5ecd22f839606` states the dimension ranges, output-before-input quantifiers, nice configuration, selected tube families and count. It is used by `DB_PROJECTION_INPUT` v2 and `DB_MAIN` v3 and has exact old literature evidence `citation-RW41-17b7e6e7b8e1`.
* Abbreviated hash `1d5e25e2664a55b01aa708fb684c01ed1119522f2f2d5f1592d0cec72f619fa8`, used by `DB_MAIN` v2, names the same theorem but also says the weighted tagged reduction is proved in old section 8. The index records **no exact assumption-hash literature evidence** for this formulation.

The shared precise theorem can be used conditionally, and the weighted reduction has its separate inspected analytical argument. The literature citation does not automatically bind the abbreviated sentence or certify its additional reduction. Likewise a judgement matching the bootstrap conclusion does not certify all versions' dependency registrations. None of these observations is a mathematical contradiction between the theorem formulations.

## Supported scope, concrete remaining gaps and exclusions

Support covers the literal symmetric proposition under its existing hypotheses, the finite recurrence, one common all-surviving-pin trim using the old core construction, and quantified heredity. It does not establish the hypotheses for a concrete no-strip branch or prove any surrounding manuscript theorem.

Remaining scope-qualified obligations:

1. **External/provenance scope:** the precise `RW41` is an external assumption; the v2 abbreviated registration lacks an exact old citation binding. Its extra weighted-reduction assertion needs the analytical dependency, not literature evidence alone.
2. **Application scope:** subpower domination alone does not produce simultaneous original bins, good-parent child caps or no-strip decay. `ONE_LABEL_OUTPUT` and `NO_STRIP_BRANCH` are outside this unit and not discharged.
3. **Literal-source-only scope:** the final manuscript paragraph gives typical-pin estimates, not the explicit common core; the stronger all-surviving-pin conclusion relies on old section 7 and the finite-core dependency. Normalizing two pin filters' intersection is not an alternative proof.
4. **Uniformity scope:** finite mesh errors and projection losses need an output-first budget. There is no uniform finite iteration theorem for parameters varying arbitrarily with precision.
5. **Formal scope:** `DB_MAIN` v1–3 and `DB_RECIPROCAL` v1 have no indexed formal source. Historical Lean 4.31.0/Mathlib compilation concerns finite core/cap/mesh algebra, not absolute continuity, geometric projection input, or the bootstrap theorem.

The parent's shared existing finite replay is finite supporting evidence only; no `verify.py`, Lean, compiler or literature search was rerun here. Old certificates are reading material, not certificates of this exploratory review. The Engineer does not self-accept, and no shared or old file was edited.
