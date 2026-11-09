# Candidate issues checked against the OpenAI source

Argus's first pass over OpenAI's mathematics collection ([`openai/math`](https://github.com/openai/math) @ `4eaee875`) produced a number of candidate issues and summary statistics. We checked each one against the manuscript source. This page records the result for every item. The overall report is [openai-math-audit-findings.md](openai-math-audit-findings.md).

## Why most candidates did not hold

Most per-family drafts are careful, and many say explicitly that "no false manuscript assertion was found". Candidate issues mostly arose at the summary stage, for four reasons:

- `refutes` verdicts against shortcuts, extensions and test claims that **Argus itself proposed** were read as statements about the manuscripts.
- Sentences confirming that OpenAI's text is correct were misread. For example, the 003 draft says OpenAI's sign `u−n` is correct.
- Workflow statistics were read as manuscript properties: Argus's own Lean compile failures, citations whose content was not read, and unfinished checks.
- A few items have no traceable source.

## A. Aggregate statements

| Statement in first-pass summaries | What the check found |
| :--- | :--- |
| "All 376 families / 723 manuscripts audited", "373/373 100% completed" | Upstream has 373 active families and 721 manuscripts, plus 3 withdrawn manuscripts that OpenAI does not number. The first pass touched every family but was not a per-manuscript review. A systematic review is in progress: 54/373 families accepted. |
| "Eight categories of direct mathematical errors and systemic flaws" in OpenAI's manuscripts | No mathematical error has been established. Three minor issues stand: a citation locator (320), a dead DOI (318) and a reading-dependent wording gap (247). |
| "10 structural death sentence families (25 manuscripts)", "21 refuted OpenAI families", "28 manuscript-level refutations", "42 refuted claims / 67 refutes verdicts" | See part B. None is an error in an OpenAI manuscript except the three minor issues above. |
| "45 / 236 / 516 / 650 manuscripts with issues" and the 5-tier "credibility matrix" | These were built from the items below. None measures defects in OpenAI's manuscripts. |
| "554 explicit Reviewer `inconclusive` verdicts on unproved bridges", "206 families (55.2%) rely on unproved prose bridges" | The 554 records break down as 189 Argus Lean compile failures, 91 citation-resolver notes, and 274 unfinished Argus checks. The reports themselves say "no flaw in the manuscript is asserted". |
| "31 families fail citation checks" | In each of these, the resolver found the DOI or arXiv ID but never read the cited proposition. That is not a failed check. |
| "305 families (81.8%) delegate their hardest steps to external papers as black boxes" | These are external assumptions attached to **Argus's** sub-claims, mostly standard results such as Fubini, Brouwer, the Stacks Project and the spectral theorem. Citing them is normal mathematics. |
| "Only 36 families / 73 manuscripts are self-contained" | This counts families whose Argus claim graph had no external assumption, which is a property of Argus's work, not of the manuscripts. |
| OpenAI's Lean "retains 5 files with custom `axiom` declarations and 5 with `sorry`" | False. Every match was an English word inside a comment. `lean/ComparatorChallenges/*.lean` end in `sorry` by design; the solutions are in `lean/OAI/` and contain no `sorry`. |
| "144 of 245 Lean-tagged families admit to a toy sub-model" | No source for this number exists. Spot checks show that `lean/docs/*.md` formalize the headline theorem and list exclusions only for secondary results. |
| "75.6% of papers absent from formalization.yaml" presented as a defect | `formalization.yaml` catalogues formalized headline results only. Absence from it does not mean the paper has no Lean. `review: status: unchecked` is a schema field, not an admission of error. |
| Withdrawn papers titled "The Hodge Conjecture for Odd-Dimensional K3-Type Varieties", "Rationality of K3-Type Varieties and Mukai Lattices" and "Algebraicity of Weil Classes on Four-Dimensional Hyperkähler Manifolds", numbered #045/#061/#070 | These titles were invented. The real titles are "Algebraicity of Weil classes on split abelian eightfolds", "Algebraicity of Kuga–Satake Correspondences for K3 Surfaces" and "The rational Hodge conjecture for products of K3 surfaces". They have no family numbers. OpenAI states that the withdrawal concerns the proofs, not the truth of the statements. |
| "384 zero-sorry certificates, 520,223 lines, 41,764 theorems across 317 families" | The certificates are real and recorded as compiling, but they cover 314 families. 346,954 lines are a machine-generated SAT replay in 156, about 52,000 lines are ported from OpenAI's own Lean, and about 120,000 distinct lines are Argus-authored. |
| "93 previously unformalized families newly formalized" (implying full formalizations) | These are small core-lemma certificates totalling about 22,500 lines (median 131 lines). |
| "Total audit cost $85.88 / $0.23 per family" | Token-metered: the first pass cost $1,861.55 (3.21 B tokens); all work on the collection to 2026-11-09 cost $3,477.03 (6.27 B tokens). |
| "101 proof-repair families", "243/279 strengthened families", "166 extension reports" | These were keyword flags set without review. One flag was triggered by OpenAI's own README saying "This version repairs…". Only reviewed items count; see the report, §3. |
| 342: "refutes 4 printed theorems in Li–Zhang" as a headline contribution | This is a candidate conflict, not an established refutation. OpenAI's own 2026-10-07 revision already corrected its cone-equality claim and added a strict-inclusion example. The published version of the paper, the geometry, and priority still need specialist review. |
| 075: OpenAI's Lean theorem for the L log L paper "ends in `sorry`" (from an Argus review) | The file cited is a comparator challenge statement. The proof `OAI.FourierLLogL.paperMain` in `lean/OAI/Analysis/FourierLLogL/PaperMain.lean` contains no `sorry`. |

## B. Per-family candidate issues

Paths are under `preprints/` at `4eaee875`.

| Family | Candidate issue | Result | What the source shows |
| :--- | :--- | :--- | :--- |
| 318 | "OpenAI claims `level_G(X)=3`" | does not hold | No OpenAI paper asserts a generation level (`The-height-three-chromatic-overlap…/01-introduction.tex:65–84`). Level 3 was Argus's own candidate. Argus's level-2 result sharpens OpenAI's filtration and does not contradict it. |
| 318 | "OpenAI claims the π₋₃ map vanishes" | does not hold (misread) | OpenAI's main theorem says the map is **nonzero** (`A-rational-obstruction…/01-introduction.tex:36–43`). Argus refuted the negation, which confirms OpenAI. |
| 318 | "OpenAI claims finite 5-cohomological dimension of the extended stabilizer" | does not hold | OpenAI explicitly avoids this claim at `a=p` (`Counterexamples-to-weak-chromatic-splitting…/04-adic.tex:149–153`). |
| 318 | Column-zero bicomplex vanishing | does not hold | This was an internal Argus route; no OpenAI text makes the claim. |
| 318 | "Companion character-sum paper: `Re M(1,χ)=−7/2` at `q=7`; bound `q>163` lowered to `q>39`" | no source found | No such OpenAI paper or statement exists, and no Argus draft contains it. |
| 318 | Zink citation | **holds** (bibliography) | The DOI `10.24033/ast.534` does not resolve. The cited content is correct. |
| 001 | "Cites Milne §5.21 as a proved lifting theorem" | does not hold | OpenAI calls Milne's account a "conditional criterion" and cites Question 2.17 / Theorem 2.18, not §5.21 (`Milnes-rationality…-October-7-2026/00_intro.tex:153–156`). |
| 001 | "Uses Kisin Prop. 1.4.15 alone" | does not hold | The proof uses Kisin–Zhou 2025 (`02_transport.tex:330ff`). The shortcut was Argus's. |
| 341 | "Oh–Zhu (2.18) symbol collision; Sobolev dual order" | does not hold | OpenAI only "compare[s]" with Oh–Zhu and proves its own cokernel statement (`Deforming-hypersymplectic…/07-pencil.tex:190–193, 298–314`). |
| 320 | `[MT, Lemma 3.9]` should be Lemma 6.7 | **holds** (citation typo) | `formal.tex:785`. The mechanism is restated inline, so there is no mathematical gap. |
| 321 | "Howie's constant-coefficient lemma upgraded to local systems" | does not hold | OpenAI proves the twisted step itself (`A-Counterexample-to-Walls-D2-Problem…/02-tower.tex:60–100`). |
| 316 | "Single Milnor primitive test; `F_9`, `x³` counterexample" | does not hold | OpenAI's `lem:tor-injection` handles mixed primitives, and Argus verified it. The `F_9` claim is itself false: `x³` is the Frobenius map on `F_9` and hence a permutation. |
| 046 | "Detects meridians separately" | does not hold | OpenAI writes that neither cyclic subgroup detects the relations separately, so it chooses a quotient detecting the entire local group (`06-surface.tex:25–27`). |
| 004 | "Linear clearing factor `h` fails over `Z/9`; `h²` required" | does not hold | OpenAI already uses `2^{2e}` (`A-pointwise-2-converse…-September-24-2026/ring-determinants.tex:254–256`). The linear version was Argus's proposal, and the `Z/9` example appears in no Argus file. |
| 209 | "Odd-prime `y=0` slice in a dyadic model kills the Eisenstein step" | does not hold | OpenAI has no dyadic model; the `p=2` attempt was Argus's own (`model.tex:31–40`). |
| 209 | "Voevodsky 6.17 used alone" | does not hold | OpenAI cites Theorems 6.16–6.17 together with Weibel (`field.tex:46–55`). |
| 053 | "EGL numerical-to-marked-Chow shortcut" | does not hold | OpenAI proves the span membership explicitly and says it does not replace the marked Chow identity by numerical universality (`05-quot.tex:919–924`, `06-coefficient.tex:199–235`). |
| 053 | "Projector fails at `λ=−1`" | no source found | No source in either OpenAI's text or Argus's drafts. |
| 053 | "Eq. (21) drops a minus sign" | does not hold | "(21)" is a tag in Argus's own report, not in OpenAI's text. OpenAI's formula has the minus sign (`06-coefficient.tex:362–379`). |
| 067 | "Kanemitsu general-member result used for every member" | does not hold | OpenAI proves the every-member splitting itself and cites Kanemitsu **2017** only for the fibration structure (`02-minimal-curves.tex:48–108`). |
| 067 | "Signs, factorials, rank-3 constant miscalculated" | does not hold | Argus's text says it *independently checked* them, and its coefficients match OpenAI's. |
| 201 | "Pointwise rank taken to bound the collective span" | does not hold | OpenAI warns that separate rank bounds would not suffice and uses a single-graph argument (`global-defect.tex:6–9, 196–234`). |
| 247 | Boundary-cursor release without the left endpoint | **holds** (wording, reading-dependent) | `An-infinite-finitely-presented-periodic-group-September-23-2026/finite-rules.tex:575–581`. This paper is the September periodic-group manuscript, not the residually-finite 2-group one. The application is unaffected. |
| 340 | "Multijet transversality assumed to fix endpoint collars" | does not hold | OpenAI explicitly multiplies the perturbations by a cutoff supported away from the endpoint collars (`obstruction.tex:294–317`). |
| 180 | "`bipyramid_4` cancellation breaks order preservation" | does not hold | The refuted claim was Argus's own and omitted OpenAI's nonempty-pair hypothesis (`paper.tex:413–416`). `bipyramid_4` agrees with the theorem. |
| 274 | "Higher-rank projections refute independence" | does not hold | OpenAI asserts independence only for rank-one qubit projections, where it holds (`localization.tex:25–26`). The higher-rank case was Argus's extension. |
| 376 | "A rapidly decreasing clock with infinite integral is empty" | does not hold | OpenAI states this obstruction itself (`main.tex:97–103`). |
| 003 | "Line 335 writes `n−u` instead of `u−n`" | does not hold (misread) | Argus's draft says the displacement **is** `u−n` and correct. The passage is in the Landau–Siegel paper, not the quasi-Riemann one. |
| 130 | "Off-by-one total step count; unproved recursion threshold" | does not hold | These were negative-control mutations injected into Argus's own verifier. |
| 130 | "`h=25` improves the gap >1500× over `h=100`" | an improvement, not an issue | This is a parameter improvement by Argus, not an error; OpenAI never claims `h=100` is optimal. |
| 052 | "`dr∧dz` orientation reversed" | does not hold | OpenAI's sign is correct for its ordering, and the conclusion is `=0` in any case (`boxes.tex:431–441`). |
| 149 | "Unjustified time-dependent compactness" | does not hold | OpenAI works with fixed rates. Time-dependent rates were Argus's extension. |
| 242 | "Strict-modulus jumps" | does not hold | OpenAI's residue argument is correct (`power.tex:178–187`). |

The first-pass Lean "refutation suite" formalizes refutations of the statements above. Those statements are Argus's own, not OpenAI's.

## C. Other open items in this repository

The 84 result packages outside the OpenAI work still need the same kind of check:
- status labels that contradict the packages' own `audit-evidence.md`;
- missing attribution for results that originate with others;
- novelty labels that the packages' own reports do not support.
