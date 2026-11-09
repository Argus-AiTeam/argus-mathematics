# Statement fidelity: the conditional guarded diagonal

Source: OpenAI, *Weak and strong normalization in pure type systems*,
September 25, 2026 staged release. All labels below refer to
`build/sections/relational.tex` unless another file is named.

## Statement, objects, and quantifiers

`GuardedDiagonal.terminal` proves the arbitrary proposition `B`, representing
the designated formula `F_b`, from a `Data` instance and its explicit `Laws`.
`no_false_model` specializes B to Lean's False; that corollary is not an
identification of the manuscript's terminal with semantic falsity.
Negation in this tail means implication to B. The proof does not use explosion,
excluded middle, choice, or proposition/function extensionality.

L, X, V, PL and PX are separate, universe-polymorphic carriers. PL and PX are
predicate **codes**, with evaluation relations, not function spaces. There is
no map from all functions X -> Prop into PX and no arbitrary comprehension
axiom. Only the four named code families used by the source occur:
`responseCode`, `leftCode`, `shiftCode`, and `negativeCode`. The latter two
and `wf` are fields of the data structure before any proof inputs are supplied.
This models their proof-independent definitions, not their PTS typing.

`Data.Approx`, `Equiv`, `Good`, `Rel`, `Valid`, `Ext`, `Resp`, `Ind`, `Q`,
and `RProperty` reproduce the displayed formulas in `rel-admissible`,
`rel-lifts`, `rel-ind-definition`, `rel-specialized-object`, and
`rel-contradiction`. Good includes rounded invariance and the G query.
Rel quantifies over PL codes satisfying Good; Equiv quantifies over PX codes.
Valid quantifies over pointwise-equivalent PX codes; Ext over equivalent X
objects; Ind over Valid X objects; Q over Ext PX codes.

Logical quantifiers used inside these formulas range over L, X, PL, or PX,
as in the direct-domain table at `channels.tex`, `chan-x-evaluation`.
Quantification over the carriers, operations, Laws, or an open v : V in the
Lean declarations is **metatheoretic parameterization**, not an additional
object-language quantifier constructor over V or a function space.

## Every upstream premise

These are hypotheses, not certified constructions of the PTS channels.

| Laws field | Exact source and meaning |
|---|---|
| `round_observe` | `channels.tex`, `chan-x-evaluation`: primitive observation of Round_X x at the same v equals that of x. |
| `tag_congr` | `rel-observation-equivalence`, Tag_0: x equivalent to y implies tag_0(x) related to tag_0(y). |
| `lift_congr` | `rel-lift-congruence`, LC: related L inputs give equivalent lifts. |
| `lift_valid` | `rel-lift-valid`: every lift is Valid, without a guard on its L input. |
| `lift_cancel` | `rel-lift-properties`, LP, from `lem:enc-data-cancellation`: observe(lift(a),v) iff sb(v,m,a), at the identical v and a. |
| `probe_rounded` | `rel-probe-rounded`, under the fixed admissible specialization: z_i diamond y iff i@lift(Round(y)). |
| `response_eval` | The data definition i_v in `rel-response-predicate`, using `channels.tex`, `chan-x-evaluation`: evaluate at Round_X x before tag_0, without Resp. |
| `left_eval` | The data definition i_P in `rel-specialized-object`, using `chan-x-evaluation`: P@tag_left(Round_X x). |
| `pair_left` | `rel-pair-left`: Pair(Part(v),tag_0(x))@tag_left(y) iff v diamond tag_0(y), only with Resp(v). |
| `pair_right` | `rel-pair-right`: the same code at tag_right(y) iff x equivalent to y, only with Resp(v). |
| `query_realization` | `rel-query-realization`, q_R, and `rel-specialized-object`, P_R: exactly Ext(i_P) -> forall x, Valid(x) -> P@tag_right(x) -> le(i_P,x). |
| `shift_eval` | The data definition S in `rel-shift`, using `chan-x-evaluation`: S(i)@x iff i@delta(Round_X x), without Ext. |
| `wf_cancel` | The data definition WF in `rel-wf`, with raw `lem:enc-data-cancellation`: observe(WF,v) iff Ind(i_v), without Resp(v) or Ext. This is raw evaluation, not WF validity or the induction builder. |
| `negative_eval` | The data definition j_* in `rel-contradiction`, using `chan-x-evaluation`: j_*@x iff Q(Round_X x) -> B, without a proof input. |

`part`, `pair`, and the three tags are data operations, not set-theoretic
pair encodings silently substituted for the manuscript's code. `sb`, `le`,
`delta`, and `PairAt` are definitions using precisely those operations.
The fixed A_0, m_0 and ad are represented by specializing these operations
and assuming the listed laws at that specialization. No generic admissibility
or realization theorem for arbitrary A,m is proved here.

## Every certified conclusion and its guards

| Lean declaration | Source obligation |
|---|---|
| `round_rel`, `round_equiv` | `rel-equivalence` and `rel-lift-properties`: rounding is related/equivalent; not literal data equality or idempotence. |
| `ext_congr` | `rel-query-realization`, ExtC: pointwise equivalence preserves Ext, without already assuming Ext. |
| `probe_exact`, `probe_resp` | `rel-probe-exact`: exact probe evaluation and Resp(z_i), only from Ext(i). |
| `response_exact`, `response_ext` | `rel-response-predicate`, E_h and ex_v, only from Resp(v). |
| `left_response_approx` | The rounded comparison d in `rel-response-predicate`, only from Resp(v), at the exact rounded argument. |
| `sb_law` | `rel-sb-law` and `rel-r-property-law`, only from Resp(v) and Valid(x). The query's Ext antecedent is explicitly supplied; both predicate transports use the appropriate Valid proof. |
| `delta_valid`, `delta_congr` | `rel-shift`, V_delta and DeltaC, with no validity premise on x. |
| `shift_exact`, `shift_ext`, `shift_comparison` | `rel-shift-evaluation`, `rel-shift-extensionality`, `rel-shift-comparison`, only from Ext(i). |
| `predecessor` | `rel-shift-predecessor`, requiring Ext(i) and Valid(x); no unconditional replacement inside le. |
| `ind_congr` | `rel-ind-congruence`, IndC, without Ext on either code. |
| `wf_raw` | F(i) in `rel-wf`, the instance of raw cancellation at z_i, with no Ext or Resp premise. |
| `probe_response_congr`, `wf_valid` | D(d) and V_WF in `rel-wf`, with unrestricted pointwise-equivalent codes, no Ext. Both Round_X and Round_L remain in the evaluation chain. |
| `wf_evaluation`, `ind_shift`, `induction_builder` | `rel-wf-evaluation` and `rel-induction-builder`, requiring Ext(i), and Ind(i) where used; all validity proofs are derived or supplied. |
| `q_congr`, `negative_exact`, `negative_ext` | QC, `rel-negative-evaluation`, ex_* in `rel-contradiction`, using rounded evaluation rather than replacing codes by equivalent data. |
| `negative_ind` | l_* in `rel-contradiction`, deriving rather than assuming Ind(j_*). The original Valid(x) is passed to the predecessor comparison. |
| `q_wf` | q_0 in `rel-contradiction`, applying the induction builder at S(i), not i. |
| `terminal` | `rel-contradiction`: the constructed negative predicate at WF applied to Q(WF) yields B. |
| `no_false_model` | A semantic corollary of this conditional interface only. |

## What this does not certify

Lean checks these logical implications in Prop, not a quotation of the PTS
syntax or an extraction of a labelled proof term. It does not check the
available product rules, actual wrapper macros, term sorting, erasure,
observation bounds, substitution, system-wide normalization, or novelty.
The four named coding evaluation instances and two responsive pairing laws
remain explicit hypotheses. It is not assumed that the semantic interface
has a model when B is False; the corollary proves that it cannot.
An independent reader must check this mapping against the source before
accepting the fidelity claim.
