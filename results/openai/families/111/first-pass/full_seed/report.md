# Full-seed source-fidelity audit

## Statement and scope

The target is the staged September 23, 2026 manuscript, not an arbitrary
algorithm satisfying a similar comparator. For every finite labeled matroid
and deterministic nonnegative real weight vector, its constructed rule must
be feasible and satisfy

    E_R[min_pi reward(w, R, pi)] >= 2^(-293) OPT_M(w).

Its one-sample simulation must use exactly one independent sample per label,
no distributional information, and a seed independent of samples and online
values. An ordering adversary sees all of them. The claimed consequence is
the bound 2^(-310), with finite expected optimum. The minimum cannot be moved
outside the expectation. Measurability and implementability are obligations,
not inferred from a theorem's name.

## Prior result being examined

At openai/math commit `4eaee87548250b2682affda7d05d947c05554bae`,
`lean/OAI/Probability/MatroidProphet/Main.lean` contains proof bodies for
`complete_hidden_guarantee`, `hidden_vector`, and `one_sample`.
At intake this was only an availability observation, not an independently
checked proof or correspondence theorem. The actual dependency closure and
local correspondence theorems have now compiled, as recorded below.
The staged `sections/setup.tex` proves the sample/value gluing argument
directly; its external references describe antecedents, not a needed black-box
reduction.

The existing ledger supplied no certified prior mathematical result.

## Current source correspondence

`Model.lean` defines `hiddenWorstReward` as the minimum over the finite,
nonempty set of all label permutations. Its seed argument remains inside
the integral in `HiddenVectorChallenge`. `OneSampleChallenge` universally
quantifies over measurable orders on the underlying probability space,
after samples, values, and the complete seed have been specified.
`OnlineRule.decide` receives only the initial observations, complete seed,
and arriving prefix; it does not receive the future permutation.

`Algorithm/Rule.lean` uses exactly four label masks and two extra bits.
`Seed.lean` proves that their joint law is the product with rates
`1/2, 1/4, t, t`, fair parity, and a fair branch bit.
The maximum branch reuses the fair `H` mask; this is consistent with the
manuscript, which does not require independent coins for mutually exclusive
branches. `Algorithm/Observed.lean:preprocessing_congr` proves that the
group list, paths, births, and eligibility use only `H union D union C`.
`Algorithm/Selection.lean:hiddenAccepted_eq_selection` identifies the
history-based execution with the full-vector analytical greedy set.

If the paper's unused branch coins are instead retained independently,
the same correspondence holds after projecting to the active branch:
conditional on either branch, its used masks have exactly the stated
product law. For every fixed used seed, the reward function on the set
of all permutations ignores the unused coins. Its minimum therefore
ignores them too. Extra bits used to generate a sparse biased mask can
likewise be exposed without changing this minimum. This is a projection
argument, not a claim that the two complete seed spaces are bijective.

`Simulation.lean` proves fixed-mask gluing, the joint product law with
the complete seed, and equality of accepted sets at every prefix for
every fixed sample/value/seed/order tuple.
`Gluing.lean:oneSample_of_hidden` takes the order minimum pointwise before
integration, controls integrability by the feasible optimum, and does
not assume independence of the order.

The actual implementation dependencies supporting these source readings
have now all compiled.
The pinned toolchain file specifies **Lean 4.34.1**, whereas the required
assigned workspace is **Lean 4.31.0** (confirmed by a real version probe).
A separate compatibility copy replaces specific Mathlib imports by
`import Mathlib`; the pristine pinned proof bodies are retained for comparison.
Import translation alone was not taken as evidence; every dependency and
the final certification source were subsequently checked by the compiler.

The bounded safety/transfer investigation is in
`safety_transfer_analysis.md`. It found no substantive false assertion
within that scope and explicitly records its remaining density/path
interfaces. It is not a Reviewer verdict.

The Jacobian rank operation checks a boundary matroid presentation with a
loop, two parallel columns, and a second independent direction. It is only
a supporting exact finite calculation, not evidence for the universal
competitive guarantee.

## Mathematical correspondence, not just theorem names

The identification of the two rules proceeds in the following order.

1. Normalize the finite totally ordered label set by its increasing
   enumeration. Relabel independence by inverse image. This preserves rank,
   closure, weights of independent sets, and histories, and conjugates the
   set of all permutations bijectively. Thus it preserves the minimum over
   permutations as well as feasibility and the product mask laws. There is
   no representability assumption.
2. `roundedLevel` is `none` at zero and the integer floor of the base-`B`
   logarithm at a positive coordinate; `levelWeight` is zero or `B^i`.
   `Priority` orders larger levels first and smaller labels first on ties.
   `Algorithm/Rule.lean:candidate` uses exactly the higher-priority
   observed `H` closure, and `listed` sorts levels seen in `D` increasingly.
3. `Density/Basic.lean:densityExpansion` chooses the **largest** flat
   maximizing sample cardinality minus `kappa` times rank. Its uniqueness
   as the largest maximizer makes classical choice immaterial.
   `Density/Guarded.lean` defines the same nominal and guarded recursions
   as the manuscript. Its zero-based group index `h` has activation
   `-3*(h+1)`, exactly the paper's one-based `a_h=-3h`.
4. `Algorithm/Observed.lean:preprocessing_congr` proves the full path,
   birth, and assignment functions unchanged by altering unseen weights.
   Therefore the use of a full vector in the analytical definitions does
   **not** make future coordinates available to the online implementation.
   `eligible` has all three sacrifice exclusions, the positive candidate
   and listed-level tests, the test mask, the activation gap, the selected
   parity, and exclusion from the preceding final flat.
5. There is a genuine representational difference in the online scan:
   `layerKeyDecision` contracts all earlier eligible labels in its layer,
   whereas the paper contracts only earlier accepted labels. The new
   `prior_closure_eq_accepted` theorem proves equality of these closures.
   For an earlier eligible label, the upstream prefix-spanning theorem
   puts it in the closure of earlier retained labels at times at most its
   own, hence strictly before the current time. Conversely, every earlier
   retained label was eligible. Adding the same base and closing proves
   both inclusions. `singleton_rank_one_iff` then proves that the resulting
   closure exclusion is precisely the paper's conditional-rank-one test.
   `manuscript_greedy_decision_iff` combines the two; this step is not
   supplied by merely renaming `one_sample`.
6. `hiddenAccepted_eq_selection` identifies the observed-history execution
   with the analytical set for each fixed seed and permutation. The
   concrete mask identity in the new source also shows explicitly that
   the sacrificed set contains no weight-dependent choice.
7. All decisions factor through finitely many labels and countably many
   rounded levels. Every function on the resulting countable discrete
   key space is measurable; `discreteOnlineRule` composes it with the
   measurable rounding map. Choosing density maximizers, integer births,
   and history scans does not require measurability of an arbitrary
   real-valued oracle. Prefix feasibility is established before integrating.

The remaining quantitative proof follows actual imported declarations:

| Manuscript obligation | Implementation interface |
|---|---|
| Candidate mass and priority optimality | `Candidates`, `GreedyOptimal`, `CandidateFilter`, `AnalyzedMass` |
| Largest density optimizer, activation, common generators | `Density.Basic`, `Density.Guarded`, `Density.Birth`, `Residual.Generators`, `CommonBudget` |
| Adaptive guard exposure and safe births | `Certificates.Execution`, `Certificates.Budget`, `Reverse.BirthSafety`, `SafeSamples`, `SafeParity` |
| Marked-pivot residual family and uniform tail | `Pivots.ResidualFamily`, `Pivots.PhasePattern`, `Residual.Nominal`, `Residual.Probability`, `Residual.Tail` |
| Every-order rank and conditional thinning | `Algorithm.Statistics:trueLambda_le_count`, `RankCost`, `Thinning`, `GroupPayoff:true_group_payoff` |
| Weighted minimum before expectation | `Algorithm.Worst:weighted_trueLambda_le_mainWorstRounded`, `Algorithm.WeightedPayoff:conditional_main_payoff` |
| Branch mixture and rounding | `Constants:branch_mixture_lower`, `CompletePayoff:integrated_branch_lower`, `Main:complete_hidden_guarantee` |
| Arbitrary full-information one-sample order | `Simulation:glue_seed_joint_law`, `sampleSimulation_acceptedThrough`, `Gluing:oneSample_of_hidden` |

This table describes the proof interfaces; `upstream/import_closure.json`
is the full 125-module transitive OAI import closure rather than a selected
list of favorable theorem names. The bounded safety/transfer analysis
also checks that the manuscript's analytical exposure filtration is not
being confused with information concealed from the adversary.

## Exact guarantee and probability quantifiers

For each fixed complete seed, the weighted rank accounting is simultaneous
over every permutation. Therefore the minimum can be taken **before**
averaging any of the test or guard coins. With rounded optimum `W`, the
main branch handles `m_* <= W/(8*kappa)` and the maximum branch handles
the other case. A fair mixture yields

    E[min_pi rounded_reward] >= t*gamma/(32*kappa) * W.

Since `OPT(w) <= B*W`, the final factor is

    t*gamma/(32*kappa*B) = 2^(-140-16-5-100-32) = 2^(-293).

The empty or zero-optimum case is included by nonnegativity. The rank
argument does not require individual loop values to be integrable.

For any seed `r`, let the glued coordinate be the sample on its sacrificed
mask and the value off that mask. Because the complete seed is independent
of the entire pair of vectors, conditioning on it fixes the selector
without changing any coordinate law. Coordinate independence and equal
sample/value laws give the same product vector law for every selector.
Consequently the **joint** law is the product of the seed law and the
online vector law, not merely equality of the glued vector's marginal.
Prefix-by-prefix execution equality holds for every tuple and every
permutation. The reward at any adversarial permutation is pointwise at
least the corresponding minimum. Nonnegative integration and domination
by the feasible optimum justify the integrability statements.

The new concrete one-sample statement keeps the stronger `2^-293`
constant and fixes both the algorithm and seed law. The upstream public
statement with `2^-310` is also checked; its weaker constant follows
arithmetically. Neither statement restricts the adversary to a fixed order
or to an order independent of samples, values, or any seed bit.
The new minimum/adversary equivalence also supplies a seed-dependent
minimizing order function, so the interface is exact in both directions.

## Compiler result and replay

The official `lean_evidence verify` run returned `exit_code=0`,
`proof_holes=[]`, and axiom-audit exit code zero under **Lean 4.31.0**.
All six printed certification declarations depend only on `propext`,
`Classical.choice`, and `Quot.sound`. The actual 125-module OAI closure
also compiled successfully. The ledger derives `closed_kernel` for
`V_ONE_SAMPLE_ALMIGHTY`, with no undischarged external assumptions.
The provisional assumption that the implementation proofs were correct
was discharged by compiling them, not by accepting an unchecked citation.

The archived compiler certificate is
`certificates/V_ONE_SAMPLE_ALMIGHTY-a12b28434690e741.json`.
`exact_certificate.json` records its claim binding, the two exact
guarantees, foundational axioms, supporting arithmetic, Jacobian result,
and both campaign-local validation commands and zero exit statuses.
The authoritative root is
`campaigns/9000111`.

The compatibility translation is reproducible in `build_compat.py`.
Besides the import and package-option normalization, it renames seven
Mathlib APIs. Its proof-only repairs disambiguate set inclusion in
`Density.Path` and `Density.Guarded`, close an instance-equality goal
by reflexivity in `Pivots.Entropy`, derive existing probability-map
instances in `Gluing` and `Algorithm.SeedLaw`, and replace the newer
optional-list-index injection lemma by explicit valid-index proofs in
`GroupSafety`. It changes no algorithm, constant, probability law, or
mathematical hypothesis. Pristine pinned sources remain alongside the
generated compatibility copies.

Replay from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/full_seed/verify.py
```

The independent Reviewer has since accepted the bounded verification.
The accepted handoff is
`$WORKSPACE/.argus-campaign-9000111/projects/f41b1aae4bcd/handoffs/5c06c917dc7d/round-0001.json`:
its review status is `done`, with the explicit finding that both universal
guarantees are source-faithful. The current ledger also contains independent
supporting judgements for `V_ONE_SAMPLE_ALMIGHTY`,
`L_SCAN_CORRESPONDENCE`, and `L_ORDER_QUANTIFIER_EQUIVALENCE`.
These findings are retained, not replaced by a fresh engineering opinion.
They establish bounded correctness support, not final certification of
publication-level significance. The campaign goal remains open.

The final-submission ledger check now reports a review-record blocker.
At the campaign root, `math_state check` exits **1**, with
`judgement_certificate_retired` for the two subsidiary claims
`L_SCAN_CORRESPONDENCE` and `L_ORDER_QUANTIFIER_EQUIVALENCE`;
`proof_graph_check check` exits **0** with 11 valid nodes. Their Reviewer
judgements cite the primary theorem's compiler certificate, but neither
subsidiary claim has a non-judgement certificate bound to its own statement.
The checker's message suggests a rewritten fidelity note; that is not
what happened here: the existing source and fidelity document still match
both recorded compiler bindings, and neither was edited or recompiled.
The primary theorem's mechanical evidence and independent supporting
judgement remain intact. The zero statuses in `exact_certificate.json`
describe the earlier replay, not this later ledger state.
The independent Reviewer must correct or re-attest its own subsidiary
evidence references before campaign acceptance; Engineer has preserved
those records rather than impersonating their author.

## Classification and independence

The deliverable is an exact **formal verification theorem** with
an additional explicit implementation-to-manuscript greedy-decision
correspondence. It is not a new counterexample, a finite verification of
the main bound, or a claim that the numerical ratio improves the staged
manuscript. The manuscript already states that its proof gives `2^-293`.
The improvement over the supplied project state is a checked dependency
closure and explicit source correspondence, not a better prophet ratio.
That project-state improvement must also be compared with the strongest
prior result: the pinned upstream implementation already contains the
quantitative proof, not merely comparator declarations.

| Mathematical content | Strongest prior result | Contribution of this certification |
|---|---|---|
| Fixed-vector expected minimum, factor `2^-293` | Upstream `complete_hidden_guarantee`, with the concrete rule and seed law | Checks its actual dependency closure under Lean 4.31.0 and exposes feasibility and adversary quantifiers explicitly |
| One-sample full-information adversary | Upstream `one_sample` and the general transfer `oneSample_of_hidden` | Instantiates that transfer at the concrete rule with `2^-293`; this is not a new competitive ratio |
| Previously eligible versus previously accepted labels | Upstream `layerGreedy_spans_prefix` supplies the spanning fact | Adds the explicit closure equality and conditional-rank decision correspondence |
| Minimum inside expectation versus seed-dependent orders | Finite minimization supplies a minimizing permutation for each seed | Encodes both directions of the equivalence and connects them to the concrete guarantee |

Thus the quantitative argument is reused from upstream; this is not an
independently discovered replacement proof. No stronger bound, new
construction, broader input family, or field-level originality of the
correspondence lemmas is claimed. In particular, compilation, portability,
and routine finite-minimum or matroid-closure consequences do not by
themselves establish a mathematical breakthrough.

The existing theorem and its accepted correctness evidence are submitted
as the final candidate under the operator-authorized exact-verification
alternative. The publication-level question is whether this source-faithful
independent certification is a sufficiently substantive contribution
despite the upstream proof. Neither the compiler certificate nor the
bounded handoff answers that question. Novelty and significance therefore
remain `not_assessed`, and the engineering judgement on campaign goal
`C9000111` is inconclusive pending the Host-invoked independent Reviewer.
Final acceptance must address technical substance, source fidelity,
independent contribution, originality where claimed, and field-level
significance. If it is denied, the substantive deficit is the absence of
an established new or independently publication-worthy mathematical
advance over the upstream formalization; recompilation or repackaging
would not cure it.
