# Statement fidelity: universal divergence-expansion resource core

This document describes `research/divergence_audit/Main.lean`, namespace
`DivergenceAudit`, for claim `C_DIV_LEAN_CORE`. The source uses only the installed
Lean standard library (`Lean.Elab.Tactic.Omega`), not additional packages. The
intended compiler is Lean 4.31.0. These are universal inductive proofs, not
numerical evaluations, sampled histories, or fixed-size computations.

## Objects and transition semantics

`DivergenceAudit.State` has four natural-number fields: `a` is the number of
remaining adjoints, `e` is the number of derivatives added to primary factors,
`h` is the number of derivatives added to Hessian factors, and `v` is the number
of Hessian births. The fixed number of labeled primary factors is an external
natural number `n`. `DivergenceAudit.initial n` is `(n, 0, 0, 0)`.

`DivergenceAudit.Step` is an inductively generated relation on states. For all
natural numbers `a, e, h, v`, its three constructors give exactly

* `Step.primary`: `(a+1,e,h,v)` to `(a,e+1,h,v)`;
* `Step.hessian`: `(a+1,e,h,v)` to `(a,e,h+1,v)`;
* `Step.birth`: `(a+2,e,h,v)` to `(a,e,h,v+1)`.

Thus a birth consumes two adjoints and each other step consumes one. The
constructors do not assume resource conservation or any desired exponent bound.
The history abstraction deliberately over-approximates target availability:
`Step.hessian` itself permits `v=0`. The more restrictive expansion-tree model
below has no Hessian targets when `v=0`.

For every natural `n`, `DivergenceAudit.History n depth r` is the proposition
generated only by `History.start` at depth zero and `initial n`, and by
`History.next`, which appends one `Step` and increments depth by one. No bound on
depth or on any resource is supplied as a history hypothesis.

For every `n` and state `r`, `DivergenceAudit.Target n r` has three disjoint
families of constructors:

* `Target.primary` is indexed by `Fin n`;
* `Target.hessian` is indexed by `Fin r.v`;
* `Target.pair` is indexed by `Fin (r.a - 1)`.

These are the target slots after one active adjoint has been selected by a
fixed rule: the primary factors, the existing Hessians, and the other active
adjoints. Choosing the active adjoint itself is not another branching choice
in this model. `DivergenceAudit.nextState` applies the respective derivative or
birth update, using natural-number subtraction. For all `n, r` and targets,
`DivergenceAudit.target_is_step` proves that this update is a `Step` whenever
`0 < r.a`; a pair target's `Fin` bound guarantees at least two active adjoints.

`DivergenceAudit.targetCount n r` is `n + r.v + (r.a - 1)`, with truncated natural
subtraction. `DivergenceAudit.sumFin m f` sums the values of any
`f : Fin m -> Nat` recursively, by visiting zero and then the successor indices.
`DivergenceAudit.targetSum` sums over all three target families.

`DivergenceAudit.Expansion n r` is a finite inductive tree indexed by its current
state. `Expansion.terminal` requires `r.a=0`. `Expansion.branch` requires
`0<r.a` and exactly one child `Expansion n (nextState target)` for each
`target : Target n r`. It assumes neither a bound on the number of targets nor
a bound on depth or leaves. Each child is counted once, even when two distinct
targets have the same resource update.

`DivergenceAudit.fullExpansion n r` constructs such a tree for every natural
`n` and every state `r`, without a reachability hypothesis. Its well-founded
recursion uses the strictly decreasing number of active adjoints. Consequently
the initial-state tree bounds are not assertions about an uninhabited tree
type. `DivergenceAudit.Expansion.leaves` counts terminal leaves recursively,
summing over all target children at a branch.

## Proved statements and all hypotheses

All numbers below are arbitrary natural numbers; all states have the four
natural fields above. There is no upper bound on `n`, parity restriction, or
positivity assumption unless explicitly stated.

For all states `x,y` and a proof of `Step x y`:

* `DivergenceAudit.Step.conservation` proves
  `y.a+y.e+y.h+2*y.v = x.a+x.e+x.h+2*x.v`;
* `DivergenceAudit.Step.count_increment` proves
  `y.e+y.h+y.v = x.e+x.h+x.v+1`;
* `DivergenceAudit.Step.adjoints_decrease` proves `y.a+1 <= x.a`.

For all `n, depth, r`, with the sole hypothesis
`history : History n depth r`, the following declarations prove:

* `DivergenceAudit.History.resource_invariant`:
  `r.a+r.e+r.h+2*r.v = n`;
* `DivergenceAudit.History.depth_identity`:
  `depth = r.e+r.h+r.v`;
* `DivergenceAudit.History.depth_budget`:
  `depth+r.a+r.v = n`;
* `DivergenceAudit.History.depth_le`: `depth <= n`;
* `DivergenceAudit.History.resource_bounds`:
  `r.e+r.h <= n`, `r.e+r.h+r.v <= n`, `r.a <= n`, and `r.v <= n`;
* `DivergenceAudit.History.target_count_le`: `targetCount n r <= 3*n`.

With the same universally quantified history and the additional terminal
hypothesis `r.a=0`:

* `DivergenceAudit.History.terminal_conservation` proves
  `r.e+r.h+2*r.v = n`;
* `DivergenceAudit.History.terminal_depth_identity` proves `depth+r.v = n`.

For every such history and every natural `k,j`,
`DivergenceAudit.History.primary_exponent_le` proves

`n*(k+j)+r.e+r.h <= n*(k+j+1)`.

For every such history and every natural `j`,
`DivergenceAudit.History.dimension_exponent_le` proves

`n*(j+1)+r.e+r.h+r.v <= 2*n*(j+1)`.

These two inequalities hold at intermediate states as well as at terminal
states. They do not assume the conclusion or a terminal resource identity.

The auxiliary sum results have the following exact scope:

* `DivergenceAudit.sumFin_le`: for all `m,b`, `f : Fin m -> Nat`, and the
  pointwise hypothesis `forall i, f i <= b`, the sum is at most `m*b`;
* `DivergenceAudit.sumFin_const`: for all `m,b`, the sum of the constant `b` is
  `m*b`;
* `DivergenceAudit.targetSum_const`: for all `n,r,b`, the constant target sum
  equals `targetCount n r * b`;
* `DivergenceAudit.targetSum_le`: for all `n,r,b` and
  `f : Target n r -> Nat`, if every value is at most `b`, the target sum is at
  most `targetCount n r * b`.

`DivergenceAudit.Expansion.leaves_le` quantifies over every `n,r`,
`tree : Expansion n r`, natural `depth`, and proof of `History n depth r`, and
proves `tree.leaves <= (3*n)^r.a`. The proof inducts on the tree, derives the
target budget from the history invariant, and propagates reachability through
`target_is_step`. Positivity of `3*n` at a reachable branch is derived, not
assumed.

`DivergenceAudit.root_leaf_bound` quantifies over every natural `n` and every
`tree : Expansion n (initial n)` and proves `tree.leaves <= (3*n)^n`.
`DivergenceAudit.full_expansion_leaf_bound` states this bound for the explicitly
constructed `fullExpansion n (initial n)`, for every `n`. In particular `n=0`
is included, with one terminal leaf and `0^0=1`. All root-to-node transition
histories obey `History.depth_le`; no fixed-size tree enumeration is used.

`DivergenceAudit.high_trace_moment_core` quantifies over all natural
`s,k,j,depth`, all states `r`, a proof of `History (2*s) depth r`, and `r.a=0`.
It simultaneously concludes

1. `r.e+r.h+2*r.v = 2*s`;
2. `(2*s)*(k+j)+r.e+r.h <= (2*s)*(k+j+1)`;
3. `(2*s)*(j+1)+r.e+r.h+r.v <= 2*(2*s)*(j+1)`;
4. `depth <= 2*s`.

Thus the resource and formal polynomial-exponent bounds apply for arbitrary
high trace-moment order, not merely for finitely many tested orders.

## Correspondence and explicit limits

This is a count-level model of the combinatorial resource consumption and of
the target branching for a fixed active-adjoint selection rule. It has no
ambient dimension or logarithm. Its universal quantifiers permit substituting
any natural moment order, including orders chosen as functions of dimension;
it does not itself prove a logarithmic-order analytic moment estimate.

The source does not identify this abstract tree with an analytically valid
expansion of a tensor expression. It does not formalize coefficients or their
magnitudes, weighted sums, cancellations, persistent adjoint identities,
tensor slots, graph edges, the original trace cycle, an earliest/latest-neighbor
placement, incoming/outgoing orientation, or a no-Hessian-to-Hessian-edge
property. The target model only enforces availability by counts and a distinct
other-adjoint slot for a birth. Accordingly the leaf theorem bounds unit-counted
target branches, not analytic coefficients or tensor norms.

Analytic integration by parts, operator-norm network composition, Holder
(Hölder), conditional Poincare (Poincaré), manuscript jets, material-derivative
identities and the sampling theorem are **NOT Lean-proved by this core**.
No regularity, integrability, density, split-norm, or functional-inequality
hypotheses are represented in this source. In particular it establishes no
novel or unconditional sampling result and does not certify the full manuscript
or the full contextual analytic claim. No independent Reviewer verdict is
provided by this implementation.
