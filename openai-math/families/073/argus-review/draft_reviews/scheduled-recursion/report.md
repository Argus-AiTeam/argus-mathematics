# Scheduled recursion: engineering assessment

## Sources, versions and exact scope

This is an engineering assessment, not independent Reviewer acceptance. Old
source references below are relative to the read-only workspace
`campaigns/9000073`:
`Main.lean`, `research/statement_fidelity.md` (F), and
`research/AUDIT_REPORT.md` (A). T05, T08 and T09 denote the correspondingly
numbered TeX sections under
`openai-math/preprints/The-Falconer-distance-conjecture-in-all-dimensions-September-23-2026/build/sections/`.
The manuscript is OpenAI, *The Falconer distance conjecture in all dimensions*,
2026-09-23, at revision `4eaee87548250b2682affda7d05d947c05554bae`, pinned
by campaign 9100073's `MANUSCRIPTS.json`. `binding_replay.json` confirms all
four substantive listed artifacts against the preserved snapshot manifest
and all fourteen reference and staged TeX files against that pinned version.
The fifth listed artifact is an empty, nonmathematical lock.

The unit comprises C_SCHEDULE@1, C_PAYMENT@1, C_TERMINATION@1,
C_TELESCOPING@1 and C_ENGINE@1/@2/@3, not seven independent results.
C_ENGINE@3 is the full-source conditional formulation. Versions 1 and 2
are source-free superseded bookkeeping, not failed proofs; version 1's
prose was already conditional, while version 2 explicitly recorded
A_ANALYTIC_REDUCTIONS.

`manuscript_closure` (`Main.lean:1109–1130`) assumes:
`N>0`, `0<sigma<=kappa<=1`; fixed block representatives and an actual
eligible-block-minimum selection; `ProfileLipschitz A D`; a valid root
of index zero; an attained root potential V; nonnegative epsilon and eta;
and the local max-plus stopping/transition disjunction for every valid
state with index below J0. Here
`q=ceil(kappa*N)`, `s=ceil(sigma*N)`, `f=ceil(10*sigma*N)` and
`J0=ceil(100*(1/kappa+1/sigma)+100)`. The conclusion is exactly

```text
value(root) <= 2*A(start_root)-V(root)+20*D*q+B
               +(20/kappa)*epsilon+(1/sigma)*eta.
```

In particular, a valid root alone is insufficient: the root potential
requires width at least `10*q`. A:39–43 omits this qualification in its
informal “every valid initial state” wording. The manuscript's nonterminal
root meets it. No Frostman lower bound or distance-set conclusion is part
of this abstract theorem.

## C_SCHEDULE@1: actual policy, not assumed payment

T05:468–488 fixes block minima and interval choices once, then unions
descriptors over every nonterminal subinterval, deduplicating by type.
`Representatives` includes minimization against every depth in a full
block (`Main.lean:13–28`). `Eligible` uses the full-block endpoint
condition (`30–31`), and `BlockSelection` quantifies over every eligible
competitor (`1070–1074`). Consequently arbitrary ties are allowed but
cannot be changed when an origin is reused in another containing list.
The last truncated manuscript block cannot be eligible, since eligibility
ends before the outer right endpoint; the full-block formulation therefore
does not exclude a manuscript choice (F:18–32).

`selected_policy` (`39–80`) derives, rather than assumes, the two domination
strips `a+2*q<=n<=p` and `p<=n, n+2*q<=t`. `fixed_selection_valid`
(`1076–1089`) connects those consequences to every fixed legal selection.
Finite minimizers and eligible blocks are supplied at `17–28`, `82–99`
and `106–137`.

The descriptor type is part of its identity (`143–164`). Nesting reuses
the same existential origin (`166–178`); it does not select a new policy
for the containing interval. `scheduled_origin` (`187–214`) obtains an
origin for the particular membership, proves `b+L<=p`, `p+L<=u`, and
supplies every shorter positive parallel length. `scheduled_mem`
(`786–798`) checks that the finite universe discards no generated member,
and `parallel_completion` (`800–809`) keeps those completions in the
remaining list. Thus the needed `g=max(a,p-L)` test is available, without
claiming a globally assigned origin. These are the mechanisms required by
T05:490–542 and T08:85–102. The formal descriptor bound `2*(N+1)^2`
(`180–185`) is weaker than T05:530–532 but remains polynomial; anchor
cardinality is separately controlled (`139–141`, `942–960`).

## C_PAYMENT@1: definedness and the decisive inherited-origin case

The natural statement specifically says that every legal **suffix, high
or inherited-origin direct** child has a defined potential; other zero-cost
nested children are covered only when defined. `step_payment`
(`530–554`) alone does not establish this: it explicitly assumes both
parent and child potentials. Reading that signature alone would
understate, not refute, the composite argument.

Definedness is supplied independently. `suffix_width` (`266–271`) uses
the suffix inequality and nonterminal parent. `high_width` (`288–293`)
uses the prefix inequality, `s<=q`, and the high-shell endpoint condition.
`direct_geometry` (`462–492`) rules out an active floor in direct mode,
uses retained-end slack and the selected maximal descriptor, and proves
`p+10*q<=v`. Combined with `potential_exists` (`223–237`), these cover
all three rows even when their numerical cost happens to be zero.
`short_child_zero_cost` (`556–582`) explicitly excludes a short child in
each of those three cases. Its low/near/far cases return zero cost
instead; they do not assign a potential on an empty admissible-pair set.
There is therefore no conflict with C_PAYMENT@1's stated qualification,
nor support for extending its definedness clause to every transition.

`Potential` is an attained minimum on the **current** interval with
separation `10*q`, not on the retained base or chosen origin (`216–240`;
T09:13–38). Suffix replacement retains the earlier depth and substitutes a
minimizer on `[p,t]` for the later depth (`273–286`). High replacement
retains the later depth and substitutes a minimizer on `[a,p]`
(`295–308`).

The nontrivial direct proof is `inherited_origin_payment`
(`316–341`), matching T09:82–116. Its origin `[b,u]` need not contain
`[a,v]`. If the minimizing r has positive cost, domination forces
`a<=r<b+2*q`. Together with `b+L<=p`, `p+L<=u` and `v<=a+2*L`,
this gives `v<u+2*q`. Any separated child pair has earlier member
`p<=i<=v-10*q`, hence `i+2*q<=u`; origin domination gives `A(p)<=A(i)`.
Replacing i by r stays inside the actual parent and preserves separation.
The zero-cost case uses containment. Thus the origin/current-interval
distinction is genuinely addressed, not hidden in a payment hypothesis.

## C_TERMINATION@1: width and weighted resource

Every step preserves validity and strictly decreases current width
(`494–528`), giving `scheduled_wellFounded` (`830–837`) independently
of costs or an assumed terminating run.

The quantitative argument is stronger than merely well-foundedness.
Credit is zero for positive/terminal states, two for nonterminal near-mode
angular states, and one for direct-mode states. Tokens are three times
the number of unreached fixed anchors plus credit; resource is
`q*tokens+finish` (`584–598`). `step_resources` (`622–717`) proves a
drop of at least q on non-low steps and s on low steps. High/direct
steps pass an anchor. Suffix/low steps lower the finish. Far steps spend
angular credit. A near step either crosses an anchor or preserves the
remaining list (`384–401`), so recomputing the split makes its child
direct-mode or terminal (`670–706`).

For any legal finite run, `run_integer_budget` (`768–784`) proves

```text
q*n <= q*(3*K+2)+N,       s*m <= N,
```

where K is the fixed anchor-set cardinality. The corresponding
`n<=3*K+2+N/q` appears with real quotient at `912–915`.
This is an internal quantitative strengthening of T09:147–175's charging
argument, not another draft unit. `real_budgets` (`899–927`) obtains the
weaker manuscript budgets `20/kappa` and `1/sigma`; `smoothing_room`
and `scheduled_recursion_core` (`929–940`, `962–986`) cover the next mask
support level as well as each state's index.

## C_TELESCOPING@1 and conditional closure

`potential_near_point` (`842–866`) constructs an admissible pair within
`10*q` of the final start. `run_profile_saving` (`868–897`) combines
payment with exact start normalization. Its short-child branch invokes
zero cost and `terminal_run`, then compares with the last defined
potential. This checks T09:222–254 without inventing a short-interval
potential or requiring that a stopping term occur only at terminal width.

`branch_extraction` (`1003–1037`) really derives a stopping branch by
well-founded induction. Its hypothesis is local, not global branch
domination. `maxplus_closure` (`1039–1068`) supplies smoothing room at
every reachable prefix and combines nonnegative overheads with the proved
budgets. This supports C_ENGINE@3's exact abstract implication.

## Fidelity limits, attribution and outstanding obligations

The rounding enlargement `u<=v+s` admits at most one extra endpoint
depth; high/low integer thresholds themselves match the manuscript.
Allowing low truncations at suffix parents and all far depths `a<b<v`
enlarges the transition relation safely for this combinatorial proof
(`415–454`; F:95–120). This does **not** assert analytic estimates for
extra transitions: the local premise existentially chooses a child.

Actual energies also contain cells, laws, symbols and derivative budgets
(T08:18–83), absent from `State`. Application requires finite, uniform
shape-wise envelopes, treatment of unrealized shapes and zero values,
polynomial child aggregation, supremum bounds without an assumed
maximizing symbol, and additive-error absorption. None is supplied by
arbitrary `value : State -> Real`. These are concrete analytic obligations,
not evidence that the conditional theorem is false.

The schedule, two-depth potential and manuscript inequalities belong to
OpenAI. Argus supplied the formal encoding, explicit weighted resource,
and integer-budget strengthening. Global originality or publishability
has not been verified and is not claimed.

## Compiler reuse and provenance reconciliation

`binding_replay.json` verifies the current source against `lean_check.json`,
the embedded formal statement of C_ENGINE@3, and the source text in
`certificates/C_ENGINE-2f43cd4b82da3f6c.json`. The research and root fidelity
copies, archived fidelity, receipt hashes and claim/evidence subject all
agree. The old default checker independently replays these bindings and
the finite experiment; see the finite-experiment unit's `replay.json`.

The historical compiler and environment axiom audit both exited zero, with
`proof_holes=[]`. Their recorded Lean version is 4.31.0, commit
`68218e876d2a38b1985b8590fff244a83c321783`, through Lake 5.0.0-src and
elan 4.2.3 in `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
A current `lake env lean --version` probe in that workspace returned the
same Lean build. The principal declarations' printed dependencies are
only `propext`, `Classical.choice`, and `Quot.sound`.
This review reuses the archived run; it does not claim a fresh compilation
or an exhaustive re-audit of current dependency files. No changed dependency
or source conflict was identified that would warrant recompilation.

`old_claim_status.json`, produced by the read-only installed ledger command,
derives **conditional_kernel** for C_ENGINE@3, with
A_ANALYTIC_REDUCTIONS undischarged and no stale evidence. The archived
certificate is reading material here, not mechanical evidence for a new
review theorem.

`provenance_reconciliation.json` identifies five current-subject-bound
supporting judgements by `reviewer:copilot:f37ea3c4566f`: the four constituent
claims and C_ENGINE@3. The same reviewer records an inconclusive judgement,
not support, for A_ANALYTIC_REDUCTIONS. Accordingly the old graph's
`reviewer_confirmed=false`/open labels and A's pending-review sentence
cannot justify pretending the ledger has no reviewer evidence. Conversely,
these five scoped judgements do not accept the complete manuscript or this
new review. The evidence records contain no timestamps from which to infer
an acceptance date.

The earlier `C_ENGINE-fef4023a61a8342a.json` has identical formal source but
a different fidelity document. The current document adds four lines
explaining the safely enlarged low-row relation at suffix parents. Its
old certificate is absent from current ledger evidence. This is a
translation/certificate revision, not a failed Lean argument or another
mathematical result.

There is a narrower bookkeeping inconsistency worth retaining:
R_SCHEDULED_CORE's retirement explanation says its goal uses a superseded
source-free digest, but its stored goal already matches C_ENGINE@3.
R_CERTIFIED_SCHEDULED_CORE retains the same decomposition. The retired
route stays retired; neither the inconsistent explanation nor a graph's
open label refutes the proved implication. R_FALCONER, in contrast, really
does retain the source-free engine obligation and was replaced by
R_FALCONER_CURRENT. Its analytic and assembly obligations remain open.

Independent native Host Reviewer assessment of this complete review
remains pending.
