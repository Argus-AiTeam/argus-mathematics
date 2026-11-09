# Statement fidelity: deterministic simultaneous labeling

## Principal statement and quantifiers

`LabelCore.label_good` states, for every type `V` equipped with `Fintype`,
`DecidableEq`, and `Nonempty`, every `BoxInterface V`, and every `Input V`,
that `label O s` satisfies `Good O.F s.A (width s) s.a s.b`.
`Labels V` is `V -> Bool`; `true` denotes the manuscript's positive label
and `false` its negative label. Thus every vertex receives one of the two
labels, including vertices on which neither kind of witness makes a claim.

`Vec V` consists of integer vectors. An `Input` contains an arbitrary integer
lower endpoint `A`, a natural exponent `d`, and two rational mass vectors
with proofs of strict positivity at every vertex. Its width is exactly
`width s = (2 : Int)^s.d`. There is no bound on dimension, exponent, endpoint
sign, denominator, or witness vector beyond these hypotheses.

`InBox`, `Sub`, and `Super` encode the full vectors and the support-restricted
inequalities in deterministic Section 2, not inequalities at all vertices.
`suppMax A x` is precisely `{i | A_i < x_i}`.
`suppMin A D y` is precisely `{i | y_i < A_i + D}`.
`MaxWitness` requires `Sub` and total Max support mass at most one;
`MinWitness` requires `Super` and total Min support mass at most one.
`total` is the finite sum of masses, not a normalized probability.

`claimMax` is `32*(A_i+D)-D <= 32*x_i`, and `claimMin` is
`32*y_i <= 32*A_i+D`. These integer-scaled inequalities are exactly the
manuscript's rational thresholds with `P=D/32`, including widths below 32.
They do not round a threshold. `Good` quantifies over *every* such witness
and *every* index it claims; there is one common returned label vector,
not a separate output selected for each witness.

## The explicit imported interface

`BoxInterface` is a hypothesis, not a theorem asserting that every integer
operator has comparison. Its `F` acts on the entire integer vector space.
Its `mono` field is coordinatewise monotonicity, and `shift` commutes with
every common integer translation. Its `basic` field supplies a vector in
each dyadic box, with `basic_sub` and `basic_super` proving both comparison
properties. Its `compare` field orders every subsolution below every
supersolution in the same box, at every coordinate.

This is the interface imported in deterministic `lem:accepted-box`, proved
in the staged randomized companion's Section 2, equations
`box:operator-properties` and Lemmas `lem:box-comparison` and
`lem:box-solution`. The manuscript's perturbed finite game operator satisfies
these hypotheses by those staged proofs. Ledger assumption `A104_BOX`
records this source dependency. The Lean file does not reconstruct the
game graph, perturbation, tight-cycle comparison proof, or synchronous Basic
iteration. In particular it does not claim that monotonicity and common-shift
invariance alone imply comparison.

The interface does not supply labels or the simultaneous-labeling conclusion.
Basic's output is unique under its two comparison properties: comparison in
both directions orders any two proposed outputs equally. Consequently using
this interface is extensionally the same as the imported Basic procedure,
not an oracle for the theorem being proved.

## Exact procedure represented

`width_base_iff` proves that testing `d < 12` is precisely testing `D < 4096`.
`massLabels`, `mass_base_good`, `basicLabels`, and `basic_good` implement and
prove the two base cases in their stated order. The Basic midpoint test is
`2*A_i+D < 2*z_i`, with strict inequality, also for `D=1`.

For a nonbase input, put `h=unit s=2^(d-12)`. `width_split` proves
`D=4096*h`; `h` is a positive integer. The constants in the formal code are:

| Manuscript quantity | Formal integer expression |
|---|---|
| center `c` | `A+2048*h` |
| displacement `M` | `512*h` |
| parent margin `P` | `128*h` |
| narrow width `q` | `32*h` |
| pivot step `p` | `h` |
| narrow half-width | `16*h` |
| provisional width | `2048*h` |
| provisional half-width | `1024*h` |
| negative marking threshold `c-P` | `A+1920*h` |
| positive marking threshold `c+P` | `A+2176*h` |

`fallStep` computes a simultaneous capped downward update from the old
pivot and one old-pivot label vector; `fall` repeats it until unchanged.
`downRun` starts at the center and moves exactly negatively labeled
coordinates. `riseStep`, `rise`, and `upRun` are the capped upward analogues,
moving positively labeled coordinates and starting at the stopped downward
pivot. The final unchanged update is included in both recursive loop
definitions. `finalPivot` is that upward result, with the same downward
result expressed as a pure helper expression. Repeated occurrences of a
pure helper denote the same vector; no complexity claim about evaluation
sharing is made.

`downChild` and `upChild` have exponent `d-7` and the narrow centered
endpoints. Their mass vectors are respectively `(a,4*b/3)` and
`(4*a/3,b)`. `wideChild` has exponent `d-1`, the provisional centered
endpoints, and unchanged masses. `narrow_width` and `wide_width` identify
their widths with the constants in the table.

`reweight` multiplies favorable masses by `4/5` and unfavorable masses by
`8/5`. `continuation` uses the provisional labels as Max-favorable labels
and their Boolean complements as Min-favorable labels, and preserves the
parent box. `overrides` assigns negative labels on the earlier negative
mark, positive labels on the final positive mark outside it, and otherwise
the continuation label. The negative precedence is intentional.

`label` is the actual well-founded recursive function with these base
cases, both repeated passes, the provisional recursive call, the
same-width continuation, and the final overrides. It does not choose an
output by assuming or searching for `Good`.

## Load-bearing proofs and induction

`translateMax_support` and `translateMin_support` prove exact support at
gaps strictly below the child width. `translateMax_sub`,
`translateMin_super`, the subset lemmas, and the relevant-witness
separation lemmas prove that translation and clipping preserve the required
inequalities and do not enlarge support. The claim lemmas use a
*nonstrict* gap bound. `translateMax_witness` and `translateMin_witness`
combine these facts for unchanged masses.

`fallStep_distance` and `riseStep_distance` strictly decrease finite
integer-distance measures on changing updates. `fall_spec` and `rise_spec`
prove termination, stationarity, monotone displacement, and preservation of
an arbitrary proved invariant. These establish finite loops; the tighter
`1024*n+1` call count is not a formalized conclusion here.

`peakMax_protected`, `peakMin_protected`, `down_step_peak`, `up_step_peak`,
`downRun_peak`, and `finalPivot_min_peak` prove exact peak preservation,
not just approximate displacement. `downRun_safe` and `finalPivot_safe`
exclude opposite-type claims from the two override sets.

`down_stopped_heavy` and `up_stopped_heavy` prove *strict absolute* mass
greater than `3/4` by contradicting stationarity if the translated witness
qualifies at scaled masses. Equality at `3/4` is on the contradictory side.
`finalPivot_heavy_min` proves persistence of the first mass certificate
during upward motion, and `finalPivot_heavy_max` gives the second one.

`total_reweight` and `reweight_support_bound` prove the exact mass formula
and its strict bound below one. `survive_max` and `survive_min` prove that
the original unsettled witnesses remain witnesses in the unchanged parent
box after reweighting. `stage_good` combines both passes, the provisional
child, survival, the continuation, and safe overrides.

`mu` is the minimum mass product, with positivity and attainment proved.
`budget t ht` is the least natural `j` for which
`1 < t*(32/25)^j`. `budget_exists` proves existence; it is not an
assumption. This is exactly zero for `t>1`, and for `0<t<=1` it is
`1+floor(log_(32/25)(1/t))`: minimality gives
`t*(32/25)^(j-1) <= 1 < t*(32/25)^j`.
Thus `rank s = d + massBudget s` is the manuscript's rank, expressed without
formal real logarithms. `budget_decreases` and `rank_decreases_mass`
give its strict descent. `downChild_rank`, `upChild_rank`,
`continuation_rank`, and `wideChild_rank` discharge every recursive call;
`reweight_product` proves the label-independent product factor `32/25`.
Only `wideChild` preserves the budget and decreases just the exponent.

`label_good` uses explicit well-founded induction on this rank. The
smaller-child hypotheses used in `stage_good` are discharged by that
induction, not ledgered as assumptions. Noncomputable/classical finite
maxima and decision procedures do not assert any witness-label conclusion.
The compiler's axiom audit of `label_good` is expected to contain only
`propext`, `Classical.choice`, and `Quot.sound`.

## Claims not made

This is a universal formal verification theorem for the deterministic
labeling core, conditional on the stated imported interface. It is not a
counterexample. It does not certify the winning-set reduction, the
quasipolynomial bit bound, the randomized recovery procedure, discounted
flooring, stochastic value separation, or the parity reduction.

`verify.py` also replays finite exact diagnostics. Those diagnostics are
not the proof of the universal statement. Mathematical statement fidelity,
source attribution, significance, and novelty require independent review;
compiler success alone does not certify them.
