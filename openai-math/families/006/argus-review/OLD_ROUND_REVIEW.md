# Family 006: review of the old Argus drafts

**Engineer assessment:** both existing mathematical draft units have substantive
assessments. The trace-character argument supports its abstract algebra theorem;
the weighted-genus argument supports its stated conditional comparison, with a
specific qualification to one finite fixture. Neither establishes the reference
manuscripts' main theorems. **The native independent Reviewer accepted complete
coverage and both assessments in the bounded review. Final exploratory
certification of the operator objective is pending.**

The accepted native handoff is
`$WORKSPACE/.argus-campaign-9200006/projects/385b282f5de1/handoffs/98ee7941ee4f/round-0001.json`.
It explicitly finds the missing active proof graph nonblocking for that bounded
review. The earlier standalone proof-graph check exited 2 because the file is
absent; no passing standalone graph check is claimed, and no graph is created
for the obsolete mathematical objective.

## Inventory and scope

The controlling inputs are `OBJECTIVE.md` and `PRIOR_DRAFTS.json`.
`DRAFT_REVIEW_INDEX.json` maps all **31 artifact entries**, the **one reference
input entry**, **30 distinct historical claims / 38 claim versions**, three
contexts, 12 evidence records, and 20 routes. It accounts for every node of the
old proof graph. These are **two draft arguments**, not 38 results.

The old workspace is
`campaigns/9000006`.
All 31 listed file sizes match the input manifest. All **14 Family 006 files**
listed in the preserved cross-campaign snapshot manifest match its SHA-256
values. The snapshot copies are not extra drafts. Other families in that
manifest are outside this objective.

The two zero-byte lock files are excluded as infrastructure. The two trace
fidelity spellings are byte-identical copies of one document. Compiler logs,
receipts, typed-operation discovery and contracts, fixtures, excerpts, and
judgments are supporting artifacts, not independent mathematical contributions.
Every artifact has an explicit index disposition.

The reference input `research/openai_manuscript` is a directory containing
symlinks, not a third Argus draft. Only the source passages needed for these old
arguments were inspected. The three relevant TeX files match the manuscript
reference manifest at revision
`4eaee87548250b2682affda7d05d947c05554bae`:
`06-traces.tex`, `01-arithmetic-transfer.tex`, and `05-coefficients.tex`.
The symlinks do not pin the entire historical source tree. No Git operation,
snapshot rebuild, old-file modification, or new manuscript-error search was
performed.

## The two mathematical assessments

| Unit | Supported scope and decisive argument | Limits |
|---|---|---|
| [Trace character](draft_reviews/trace-character/report.md) | Under the universally quantified characteristic-two trace identities, split vanishing, root squares, two-simple product vanishing, and a residual order-three element, construct an exponent-dividing-two unit-valued character agreeing with the trace on roots. The proof constructs the elementary residual-kernel quotient, both lifts, the kernel character, and the extension; it retains nilpotents. | The operator identities, arithmetic valuation bounds, and a common finite continuous unramified Galois quotient are inputs. Agreement on nonroots, nontriviality, uniqueness, and arbitrary-group continuity are not asserted. |
| [Weighted genus reduction](draft_reviews/weighted-genus-reduction/report.md) | Under oriented CM reduction and exact source covariance, termwise Picard transport retains the genus character; all \(2^{\omega(N)+1}\) orientation contributions agree; integral stabilizer mass \(c_0/2\) gives \(a_M(D)=c_0 2^{\omega(N)}\zeta_M(D)\lambda_M(\operatorname{red}_{\ell}(LP_D))\pmod{2^M}\). | Fundamental coprime odd discriminants, maximal conductor-one order, split primes dividing \(2N\), the detecting-prime individual sign, and the exact local weights matter. No modularity, detecting-prime existence, analytic nonvanishing, or general geometry is computed by the finite checker. |

Both `verdict.json` files distinguish proof scope, finite experiments,
attribution, source fidelity, and remaining obligations. They are Engineer
assessments, not native Reviewer verdicts.

### Trace character: proof versus formalization

The supported formal theorem is
`RootCharacter.root_character_of_class`. Its ring has `CharP A 2`, with
nilpotents allowed; the literal hypothesis excludes the zero ring. Its group
need not be finite. A homomorphism to `DihedralGroup 3` whose image contains
`r 1` covers both cyclic and symmetric residual image. A supplied elementary
kernel, normalizing transposition lift, or character is **not** smuggled into
the final hypotheses.

Split-square trace invariance produces a quotient with elementary residual
kernel. In that quotient \(R=g^4\) is an order-three lift. The character
\(\beta(a)=t(aR)\) is multiplicative and invariant under the required
conjugations. A corrected transposition preimage normalizes \(R\); it need not
be an involution. The two-simple identity proves \(\beta(s^2)=1\), killing the
section defect and permitting the character extension.

The historical Lean certificate binds the preserved source and fidelity text,
has compiler/audit exits 0 and no proof holes, and uses Lean 4.31.0 with
Mathlib. The audited axioms are `propext`, `Classical.choice`, and `Quot.sound`.
The report records the full available toolchain and the missing independent
Mathlib commit identifier. **No fresh compilation is claimed.** No new or
modified Lean source was introduced. Source translation was assessed separately:
`pullback_unramified` preserves a supplied inertia-killing condition; it does
not construct the arithmetic quotient, topology, or Galois interpretation.

### Weighted comparison: general argument versus fixtures

This is a general **conditional proof**, not an inference from matching finite
counts. The report checks nilpotent determinant-character descent, the norm
genus character, the two split-level types at every prime-power exponent
(including two), global Picard torsors over all order classes, the two inert
residue orientations, exact stabilizers, matching signs under right
normalizers, and the uniform integral multiplier.

In particular, inertness alone is insufficient for the orientation sign:
the source supplies \(\ell\equiv3\pmod4\) and
\(\chi_{h_*}(\ell)=-\sigma\). Conductor one and the unnormalized class-group
sum prevent an extra multiplicity or class-number denominator. Division by two
is done as an integer mass calculation after clearing unit denominators, not
in the residue ring. Covariance is required in the coefficient module actually
used; arbitrary integer lifts are not asserted to satisfy it.

The replay reproduces the old certificate but exposes a precise fixture
qualification. At \(m=2^5=32\), the code chooses \(r=1\) from
\(r^2+319\equiv0\pmod{2m}\) and calls eigenvalues \(1,0\) the integral generator
of discriminant \(-319\). Its polynomial \(T^2-T+80\) has residual **16** at
both eigenvalues modulo 32. The missing root-depth condition is modulo
**\(4m\)**. Thus that coded case supports a generic split-eigensummand check,
not the claimed quadratic-order instance. The separate all-exponent argument
uses an actual 2-adic root and is unaffected. The old checker was neither
changed nor replaced by a repaired computation.

## Versions, dependencies, and known-status inputs

`V_TRACE_CHARACTER` v1 and v2 have the same natural statement, but v1 has no
formal source. The mechanical record
`lean-V_TRACE_CHARACTER-199c5fb5b450` and independent judgment
`judgement-V_TRACE_CHARACTER-016f1d822e6f` both bind **v2**, content hash
`a6feb70abd47185b638ce227c8600086105516b6aa81d97b140f61189fc0b3ac`.
The embedded source and fidelity hashes match the preserved files. The old
graph's pending labels do not erase this support; neither does it certify
other graph nodes.

`D_TRACE_INPUTS` v1-v4 successively expose `A_TRACE_IDENTITIES`,
`A_PARITY_BOUNDS`, and `A_UNRAMIFIED_QUOTIENT`, without a new mathematical
statement or a proof of those arithmetic inputs.

`V_WEIGHTED_GENUS_IDENTITY` v1-v5 retains statement hash
`c24cad0812644458b590104c4307caa4070a869ab675233f672f28d141810b9c`.
Its versions expose the external assumptions and correct provenance, not five
different results. `A_SOURCE_PARAMETRIZATION` is retired because its genus-data
locator incorrectly names `01-preliminaries.tex`; v5's
`A_PARAMETRIZATION_DATA` correctly names `01-arithmetic-transfer.tex`, without
changing the mathematical input.

The exact known CM input is Cornut--Jetchev, *Liftings of Reduction Maps for
Quaternion Algebras*, **arXiv:1012.0725v1**, Theorem 3.1, Corollary 3.2,
Section 3.6 Remark 1, and Sections 4.6-4.10. The assessment reads the archived
actual hypotheses, fixed-orientation restriction, ideal action, and geometric
specialization. For \(F=\mathbb Q\), source algebra \(M_2(\mathbb Q)\),
\(S=\{\ell\}\), unchanged conductor one, and level prime to \(\ell\), the
theorem multiplicity is one. It describes **one fixed inert residue
orientation**, not both. The other orientation is handled by the draft's
separate right-uniformizer transport.

Historical independent literature record
`citation-A_ORIENTED_CM_REDUCTION-489687b00424` supports assumption hash
`aded6821c48038b948fe43ed5cf04f4e3e8fcf52c549fc727f63754e4b80a4d3`,
unchanged through the old v2-v5 and in the current review. Its subject,
producer, tier, and verdict were preserved in the current ledger; only the
artifact path is absolute to the original read-only excerpt. This is reuse of
an existing attribution, **not a new independent judgment**. Official citation
status reports it confirmed and reports no blocking citations.

The parametrization covariance and genus-point definition remain explicit
source-data assumptions, recorded as `A_PARAMETRIZATION_DATA` with the corrected
prose locator. They report as **uncited**, not as a registry-checked external
theorem. The reduced parametrization, Kummer/Frobenius law, and geometric
compatibility are not proved by the finite fixtures. A supported CM citation
must not be promoted into independent approval of the entire weighted proof,
which previously had only an Engineer opinion.

The current ledger also retires both known failed shortcuts with reasons:
residue-field reduction loses \(1+\epsilon\ne1\) in
\(\mathbb F_2[\epsilon]/(\epsilon^2)\); unweighted embedding counts lose the
genus character and fixed inert orientation. Rejecting either shortcut is not
a counterexample to the manuscript.

## Every remaining historical claim

The following **20 ledger-only goals/obligations** are part of coverage but
have no separate completed Argus argument in the listed drafts. They do not
justify inventing a third draft unit or expanding this assignment into their
solution. Here **not established** means *not established by the reviewed old
Argus work*, not false, refuted, or absent from the source manuscript. Statements
and version numbers below are those of the historical ledger; fuller source
theorem hypotheses were not silently verified.

| Historical claim/version | Recorded assertion | Concrete unsupported step or scope boundary |
|---|---|---|
| `C9000006` v1 | Broad adversarial family audit: certify a flaw or independently verify/repair/generalize a core theorem. | The old local-algebra route is not proof of either entire paper; its historical objective is not the current review contract. |
| `D_TRACE_INPUTS` v1-v4 | The coefficient construction supplies full-orbit trace identities, parity vanishings, root-square identity, and a finite unramified quotient. | Neither local group examples nor the algebra theorem construct the coefficient action, uniform valuation bounds, or common finite continuous quotient. |
| `D_COEFFICIENTS` v1 | Even/odd coefficient sources have the claimed integral bounds, fixed-weight uniformity, and unit-symbol detection. | The weighted identity is only one odd-source comparison. Even-source construction, modularity, recurrence, detecting primes, genus-index bound, and analytic detection remain unverified here. |
| `D_SUBSTITUTION` v1 | Rational contraction and irreducible deletion/substitution hold with omitted-prime unramifiedness. | Applying the abstract character needs the unproved arithmetic inputs; the full substitution and support conclusions are not independently certified. |
| `D_INTERPOLATION` v1 | Cyclotomic/Heegner determinant-coordinate interpolation and uniform integral bounds transfer nonvanishing to the missing vertex. | No listed Argus proof establishes the determinant identities, uniform bounds, or this arithmetic transfer. |
| `D_RATIONAL_CUBES` v1 | Prime graphs provide simultaneous nonzero coefficient tests on punctured binary cubes, including the fixed odd companion. | Requires the coefficient and substitution inputs and a compatible prime-graph/nonvanishing construction, not supplied by either local result. |
| `D_IRREDUCIBLE_CUBES` v1 | Corrected local Selmer matrices, ordered profiles, root calibration, and bounded companions provide punctured nonvanishing cubes. | The listed drafts provide no independent verification of those matrix/profile/cube constructions. |
| `D_RATIONAL_CONVERSE` v1 | For rational two-torsion, full two-power Selmer corank zero or one equals analytic rank. | Requires substitution, interpolation, and rational cube obligations, not just trace algebra. |
| `D_IRREDUCIBLE_CONVERSE` v1 | For irreducible \(E[2]\), full two-power Selmer corank zero or one equals analytic rank. | Requires irreducible cube constructions and interpolation; neither is discharged here. |
| `D_CONVERSE` v1 | For every rational elliptic curve with \(c_2\in\{0,1\}\), analytic rank = Mordell--Weil rank = \(c_2\), and the whole Tate--Shafarevich group is finite. | The two residual cases and rank/finiteness implications remain outside the old certificates. Here \(c_2\) is the stated full two-power Selmer corank. |
| `D_ARITHMETIC_INPUTS` v1 | Invoked rank/finiteness implications and Smith full two-power Selmer distribution apply in the asserted unrestricted scope. | The old ledger gives no independently verified hypothesis match for that unrestricted application. This is not treated as a trusted premise of the present review. |
| `D_DENSITY` v1 | Signed squarefree twists have analytic ranks zero and one with density one half each. | Depends on the converse, arithmetic distribution inputs, and squarefree counting, not established by either draft. |
| `D_SQUAREFREE_COUNT` v1 | Square-invariant integer densities transfer to signed squarefree densities by Mobius inversion. | A ledger target, without a separate supplied Argus counting proof; no transfer is inferred from local algebra or weighted CM transport. |
| `M_MOMENTS` v1 | The finite admissible family satisfies analytic second moments, Dirichlet-polynomial moments, and Euler-factor bounds with fixed arithmetic losses. | Neither bundle proves or tests the asserted uniform moment inequalities. |
| `M_MODEL` v1 | Independent-model mollifier estimates hold uniformly for \(k_0\le k\le(\log X)^{3/5}\). | No independent-model proof appears in the listed mathematical drafts. |
| `M_COMPARISON` v1 | `analytic:comparison` transfers model mean-square estimates to admissible integer twists through the asserted derivative range. | The moment/model bounds and their analytic-to-arithmetic uniform comparison are not certified. |
| `M_COUNT` v1 | `tail:count` bounds the number of admissible twists of rank \(>k\) by \(CX/k^2\) for \(k_0+1\le k\le(\log X)^{3/5}\). | Requires the model/comparison estimates and the rank-counting implication, absent from these local certificates. |
| `M_JENSEN` v1 | Each admissible twist of height at most \(X\) has analytic rank \(O_E(\log(3X))\). | No listed Argus argument checks the individual-rank/Jensen bound or its uniformity. |
| `M_TAIL` v1 | The rank-weighted tail has limsup, normalized by \(Y\), at most \(C_E/R\) for ranks \(>R\). | Requires the counting estimate and individual bound, with uniform tail control; no such conclusion follows from either bundle. |
| `M_MEAN` v1 | Mean analytic rank over all signed squarefree twists of every rational elliptic curve tends to one half. | Requires the tail estimate, density theorem, and squarefree counting. Density alone would not give the needed uniform integrability. |

The remaining **10 distinct ledger assertions** are the two principal results
and their eight internal lemmas. `L_TRACE_SQUARES`, `L_TRACE_ELEMENTARY`,
`L_TRACE_LIFTS`, and `L_TRACE_CHARACTER` are assessed in the trace report.
`L_WEIGHTED_DESCENT`, `L_WEIGHTED_PICARD`, `L_WEIGHTED_ORIENTATION`, and
`L_WEIGHTED_MASS` are assessed in the weighted report. All eight are v1 and are
steps of their parent argument, not eight additional original contributions.

## Fresh computations and unchanged reviewed evidence

| Evidence | Actual outcome | What it does not establish |
|---|---|---|
| Trace replay, `draft_reviews/trace-character/finite-replay.json` | Exit 0; six groups over \(\mathbb F_2[\epsilon]/(\epsilon^2)\), 624 candidate class functions, 13 valid traces, including an 11-trace matching subset; exact historical certificate reproduced. | No universal theorem by finite enumeration; no fresh Lean run or arithmetic trace representation. |
| Weighted replay, `draft_reviews/weighted-genus-reduction/replay.json` | Exit 0; exact historical certificate reproduced; 40 embedding generators, 20 orbits, ten level cases, 181 projective lines; the dyadic polynomial defect is explicitly recorded. | No explicit ideal-class-to-embedding bijection, actual elliptic-curve genus point, modular parametrization, or CM reduction computation. The \(N=1\) fixture is not a full elliptic-curve instance. |
| Isolated Jacobian replay, weighted review's four `jacobian-*.json` files | Inspected operation `number_theory.compute.legendre_symbol`; exact payload `{"a":-1,"prime":7}`; typed output `{"a":-1,"prime":7,"symbol":-1}`; server 0.14.0, protocol 2025-11-25, adapter exit 0, no error/timeout, complete output. | Only the elementary local negation sign of the existing fixture, not the general orientation proof or geometry. |
| Historical Lean and independent trace judgment | Unchanged source/fidelity/claim binding confirmed; source compilation and arithmetic applicability kept separate. | No blanket recertification and no native acceptance of the present family review. |

The fresh replays use unchanged old code with bytecode disabled and write
results only in the active review directories. Low weighted precisions \(M=1,6\)
give zero comparisons; the report records nonvacuous negative controls at
\(M=12\). The weighted free-module test prescribes covariance, so its successful
transport is not an independently calculated Heegner sum.

Compared with the strongest prior result, this review retains the already
independently supported abstract trace theorem rather than claiming a new
mathematical advance. The improvement is exhaustive version/provenance
reconciliation and a precise evidence limitation for the weighted fixture.
The arbitrary-group trace formulation and arbitrary-module weighted formulation
are possible abstractions under their stated hypotheses, not verified-new
results. Old serialized labels such as `new_theorem` are not adopted as
novelty judgments.

## Final exploratory submission

The retained review checks were run against the exact campaign root
`campaigns/9200006`,
using `$WORKSPACE/argus-latest/.venv/bin/python`, never the batch
root. These earlier measured results are reused, not rerun:

| Check | Exit | Interpretation |
|---|---:|---|
| Exact inventory/deliverable/typed-output reconciliation | 0 | All 31 artifacts, one reference entry, 30 claims / 38 versions, three contexts, 12 evidence records, 20 routes, 30 graph nodes, and six assumption identifiers (including retired) are accounted for; both complete unit reports/verdicts/replays exist. |
| `argus_skill.verticals.math.math_state check --project-root <campaign-root>` | 0 | No ledger structural issues. |
| `argus_skill.verticals.math.citation_check status --project-root <campaign-root>` | 0 | Exact old CM attribution confirmed; no blocking citations; source parametrization data explicitly uncited. |
| `argus_skill.verticals.math.proof_graph_check check --project-root <campaign-root>` | 2 | `no proof graph at .../9200006/research/PROOF_GRAPH.json`. |

The final submission reuses `research/DRAFT_REVIEW_INDEX.json`, both units'
`report.md` and `verdict.json`, their existing replay evidence, this family
summary, the current claim ledger, and the accepted native handoff above.
The index and unit assessments remain unchanged. Their pending-acceptance
fields describe the original Engineer handoff; the later bounded native
acceptance is recorded separately, not fabricated in those artifacts.

The current native review-stage completion check was run at the campaign root
above with `stage_completion_issues("review", campaign_root)`. It resolved the
persisted objective as exploratory but exited **1** with one issue:
`judgement_certificate_retired` for `C_TRACE_REVIEW`. The native trace-review
judgment cites the old `V_TRACE_CHARACTER` certificate, although the current
review claim has no matching mechanical certificate. The checker rejects that
cross-claim artifact reference; its generic fidelity-rewrite wording is not
evidence of a historical proof defect. No old source or fidelity text was
edited.

This specific gate needs the native Reviewer to reaffirm its reading of the
unchanged trace assessment and replace its judgment's artifact through
`math_state judge`, using the same producer key and the current trace report.
That supported update supersedes the misbound judgment. Engineer does not
record an opinion under the Reviewer's identity, modify the mathematical claim,
or fabricate a mechanical certificate. Final certification remains blocked
until the native judgment is corrected and the completion check passes.

**Requested final decision:** does this complete package satisfy every
old-draft-review requirement in `OBJECTIVE.md` at the persisted
`research_target_level=exploratory`? The conditional mathematical conclusions,
dyadic fixture qualification, and concrete historical obligations above remain
part of the submission. Reviewing those obligations does not require solving
them or certifying either reference manuscript.

The current Host mission has `scope=final_submission`, not bounded scope.
Its normal Engineer handoff to the native independent Reviewer is the supported
final-submission mechanism: a final Reviewer `done` verdict is recorded by the
Host as certification bound to the submitted project state. The earlier
bounded verdict and Engineer preparation alone do not certify final completion.
No certification status, project-completion flag, or artifact signature is
written by Engineer.
