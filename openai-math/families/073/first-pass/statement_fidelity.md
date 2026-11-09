# Statement fidelity: C_ENGINE and the scheduled recursion core

This document describes the declarations in `Main.lean`, namespace
`FalconerCore`, against Sections 05, 08 and 09 of OpenAI, *The Falconer
distance conjecture in all dimensions*, September 23, 2026. The principal
declaration is `manuscript_closure`; its general form is `maxplus_closure`.
The machine-checked claim is C_ENGINE. C_SCHEDULE, C_PAYMENT,
C_TERMINATION and C_TELESCOPING describe its constituent obligations.

## Objects and quantifiers

All depths are natural numbers. `N` is finite and positive. The profile
`A : Nat -> Real` is arbitrary except for a Lipschitz bound when the final
saving is asserted. Extending a manuscript profile outside `[0,N]` is
harmless: every scheduled origin and state depth used by the theorem is in
`[0,N]`. The extension is not an extra regularity hypothesis.

`Representatives A q r` says that `r b` is a minimizer of `A` in the full
integer block `[b*q,(b+1)*q-1]`. It includes both membership and minimization
against every index of that block. `representatives_exist` proves existence.
`Eligible q a t b` says exactly that this entire block lies inside
`[a+q,t-q]`. The last truncated block of `[0,N]` cannot be eligible:
its last index is `N`, whereas an eligible block ends at most `N-q`.
Consequently using full blocks in these definitions does not change any
manuscript policy choice.

`BlockSelection A N q r choice` specifies the actual fixed policy:
for each nonterminal `[a,t]` with `t <= N`, `choice a t` is a representative
of an eligible block and has profile value no larger than every eligible
block representative. Ties are arbitrary but fixed by the functions.
The theorem quantifies over every such pair of representative and choice
functions, not a favorable tie rule.

`selected_policy` and `fixed_selection_valid` derive `Policy` and
`ValidPolicy` from these block minima. They do not assume the manuscript's
payment lemma. In particular, `Policy` supplies
`a+q <= p`, `p+q <= t`, and the two domination statements

- `a+2*q <= n <= p` implies `A p <= A n`;
- `p <= n` and `n+2*q <= t` imply `A p <= A n`.

These are weaker consequences of the manuscript's eligible-block inner
interval and suffice for every replacement argument. `eligible_exists`
and `actual_policy_exists` prove that the finite selection is possible.
`Anchors` is the image of the finitely many block indices under `r`.
`anchors_card` and `actual_anchor_bound` prove its required size bound.

## Descriptors, lists and origins

A `Descriptor` is the triple `(type, anchor, nominal length)`. `false`
denotes a parallel descriptor, so `(false,p,L)` means `[p-L,p]`;
`true` denotes a projection descriptor, so `(true,p,L)` means `[p,p+L]`.
Generation always forces positive lengths and legal endpoints.

`Generates` is precisely the list contributed by one origin: all parallel
lengths from 1 through `min(p-a,t-p)`, and, for a suffix choice only,
the projection length `t-p`. `Scheduled` is the union over all nonterminal
subintervals of the stated base. `schedule` takes that union inside the
finite descriptor universe, thus removing duplicates separately by type.
`scheduled_mem` proves that this finite universe omits no generated
membership.

`scheduled_nested`, `schedule_nested`, `schedule_card`, `scheduled_origin`
and `parallel_completion` prove containment, the polynomial bound
`2*(N+1)^2`, membership-specific origins, their symmetric extension by the
nominal length, and the required parallel completions. No single origin
is assigned globally to a deduplicated descriptor.

`remaining` filters the retained base's exact list by anchors strictly
greater than the current start. `longest` is its maximum nominal length,
zero for an empty list. `remaining_stable` proves that crossing no global
anchor leaves this list unchanged.

## States and legal transitions

`State` carries current start, finish, smoothing index and kind. An angular
kind also carries the retained base. `Valid` includes nesting inside
`[0,N]` and the retained-end slack. A positive kind has no retained base.

`Row` has exactly the six kinds suffix, low, high, direct, near and far.
`Step` requires a valid, nonterminal parent and one such row. Costs are
the actual profile expressions using `Minimum`, whose existence is
proved by `minimum_exists`; they are not arbitrary costs constrained by
an assumed payment inequality. Suffix, low and far increase the index
by one, while high, direct and near keep it.

`manuscript_closure` sets
`q = ceil(kappa*N)`, `s = ceil(sigma*N)` and
`f = ceil(10*sigma*N)`. Its hypotheses are
`N > 0`, `0 < sigma <= kappa <= 1`.
`ceiling_parameters` proves the positivity and inequalities needed by
the general integer formulation. The manuscript's smaller parameters
are included in these hypotheses.

High and low use the respective integer conditions `t < v+s` and
`v+s <= t`. These are exactly the integer-depth versions of
`t-v < sigma*N` and `t-v >= sigma*N`. The angular base contract is
weakened, safely, from `u <= v+sigma*N` to `u <= v+s`.
This admits at most one extra endpoint depth; the proof covers the
larger class and therefore every manuscript state.
The low row also permits these zero-cost truncations when the parent's
policy is a suffix choice; the manuscript uses them only at prefix
choices. This is another safe enlargement, not an asserted analytic
reduction at those extra parents.

Direct steps choose an actual remaining descriptor of maximal length.
`direct_descriptor_exists` proves that such a descriptor exists in
direct mode. `direct_geometry` proves that the floor is inactive, the
chosen anchor is strictly deeper than the start, the child potential
is defined, and a valid membership-specific origin is available.
`parallel_completion` supplies the exact remaining parallel test needed
by that origin, including the length corresponding to
`g = max(a,p-L)`.

Near steps use exactly `h = v-2*max(L,f)` in the near regime. Far steps
allow every `a < b < v`, rather than the smaller analytic range
`b <= h+O_d(1)`. This is a safe enlargement for the combinatorial theorem:
no actual far child is excluded, and no analytic inequality for the extra
children is asserted. Cell separation, symbols, derivative budgets and
Fourier operations are not formalized. Their numerical reduction
inequalities are the explicit analytic premise below.

## Payment, termination and telescoping are conclusions

`Potential A q a t V` says that `V` is an attained minimum of
`A i + A j` over **current** depths satisfying
`a <= i`, `i+10*q <= j`, `j <= t`.
`potential_exists` proves existence whenever `a+10*q <= t`.
It is not defined by the origin or retained base.

`suffix_payment`, `high_payment` and `inherited_origin_payment` prove
the replacement inequalities. In the last theorem, the origin `[b,u]`
need not contain the current interval `[a,v]`. When the cost is positive,
its minimizing depth `r` is proved to satisfy `r < b+2*q`; the direct
geometry then gives `v < u+2*q`. This places the earlier member of any
admissible child pair in the origin's domination range. The replacement
pair stays in the actual parent.

`step_payment` covers all six rows. `short_child_zero_cost` proves that
a child too short for the potential can only have zero cost.
`step_nested` proves preservation of validity and strict decrease of
current width. `scheduled_wellFounded` consequently proves genuine
termination, without a termination hypothesis.

For quantitative termination, `credit` is 0 for positive and terminal
states, 2 for nonterminal near-mode angular states, and 1 for
nonterminal direct-mode angular states. `tokens` is three times the
number of unreached global anchors plus this credit. `resource` is
`q*tokens + finish`. `step_resources` proves a drop of at least `q`
for a non-low step and at least `s` for a low step. In a near step
crossing no anchor, list stability forces the child into direct mode
or terminality; it is not assumed to do so.

`Run` is an arbitrary finite legal branch, recording non-low count `n`,
low count `m` and total cost `C`. `run_resources`, `run_integer_budget`,
`real_budgets`, `smoothing_room` and `scheduled_recursion_core` prove
`n <= 20/kappa`, `m <= 1/sigma` and
`final index + 1 < J0` for every prefix from initial index zero.
This covers the next support level needed by masks, not just state
indices.

`ProfileLipschitz A D` means `D >= 0` and
`|A i-A j| <= D*|i-j|`. For the manuscript take `D=d/N`.
`potential_near_point` and `run_profile_saving` prove

`2*A(start_root)-2*A(start_final)+C
 <= 2*A(start_root)-V(root)+20*D*q`.

The proof handles a last move to a width below `10*q` by proving its
cost zero and using the last defined potential. No potential on a
shorter interval is silently assigned. A branch may stop at a
nonterminal low-frequency stopping term as well.

## Exact conditional closure and its boundary

`branch_extraction` derives a stopping branch from local max-plus
inequalities by the proved well-founded relation; global branch
domination is not an assumption.

`maxplus_closure` and `manuscript_closure` quantify over an arbitrary
real-valued function `value` on states. Its sole analytic premise is:
for every valid state whose index is below `J0`, either `value <= B`,
or a legal child has

`value(parent) <= 2*A(old start)-2*A(new start)+cost
                 + (eta if low else epsilon) + value(child)`.

For nonnegative `epsilon` and `eta`, the proved conclusion is

`value(root) <= 2*A(start_root)-V(root)+20*D*q+B
                +(20/kappa)*epsilon+(1/sigma)*eta`.

This is an exact, universal **conditional** theorem. Interpreting `value`
as a base-`R` main-term exponent envelope, the analytic reductions give
`epsilon = C_d*sigma+o(1)`, `eta=o(1)` and
`B=C_d*(kappa+sigma)+o(1)`. With `D=d/N` the conclusion is the saving
and `O_d(kappa+sigma/kappa)+o(1)` loss of `ledger:bound`.

The local analytic premise includes absorbing the polynomial child
sums into the subpower overhead. It is not a claim that the actual
Fourier energies satisfy it. Arbitrary-power analytic errors and their
absorption are also not Lean statements about integrals: they remain
part of the Section 08 analytic hypothesis recorded in the ledger.
The proved uniform finite depth and bounded profile increments permit
the usual choice of error accuracy before taking `N` large.

The compiler checks these encoded statements and their proofs. It
does not check this document's translation, the analytic premise,
publishability or novelty. No theorem about the positive Lebesgue
measure of a distance set is encoded or claimed here.
