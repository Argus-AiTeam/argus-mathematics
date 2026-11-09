# Finite adaptive search

**Assessment: supported for the precisely encoded theorem; no entropy or
Fourier theorem is certified.** This is a reproduction and statement-fidelity
review of an existing Argus formalization of the manuscript's search argument,
not a new mathematical contribution or a novelty determination.

## Exact statement and source

The old ledger's `C_ER_FINITE@1` is an informal two-level search summary.
`C_ER_FINITE@2` specifies an arbitrary preordered state space, the universal
quantifiers and the logarithmic specialization. These describe one argument,
not two results. The primary source is
`9000075/research/entropy_refinement/Main.lean`, namespace `EntropyRefinement`.
Its identical `lean_certificates/Main.lean` copy counts once. The inventory
and snapshot bindings are in `DRAFT_REVIEW_INDEX.json`.

For every model, cost is nondecreasing under refinement; coordinates
`0 <= a_j <= 1` increase in index and decrease under refinement; endpoints
`0 <= L_j <= H_j <= 1` decrease under refinement and satisfy
`H_k <= L_j` for `j < k`. For arbitrary `good`, at every state and failed
index, **every** `0 < x <= eta`, with fixed `eta > 0`, admits a further state
with actual `a_j` decrease at least `x` and cost increment at most
`2(H_j-L_j)x`. No stability of `good`, exact decrease or decreasing-width
assumption is present.

For `0 < a0 < a1`, nonnegative `d0,d1`, positive `u,eta`, `0 <= eps <= 1`,
and natural `n,q,N`, the scalar hypotheses are

```
n*d0 >= 1, N*d1 >= 1, q*u > 1,
d0*exp(2*u/a0) <= eps,
(d1+eps)*((a1/(a1-a0))^q-1) <= 1.
```

`finite_search` concludes, from every initial state `s`, the existence of
`v >= s` and a zero-based `j < N*q*n` with `good(v,j)` and cost increment
at most `2*a1+2*a0 <= 4*a1`.

`manuscript_search` assumes `t >= 1`, `exp(t) >= 4`, `ell >= 5*t`,
`n = exp(ell)`, `N = exp(t)` and `2*t^2 <= q <= 2*t^2+1`.
It verifies those scalar inequalities for
`u=1/t^2`, `a0=100/(t^2*ell)`, `a1=100000/(ell*t)`,
`d0=exp(-ell/2)`, `d1=exp(-t/2)` and `eps=exp(-2*ell/5)`.
The conclusion has cost at most `4*100000/(ell*t)`.

## Decisive argument and fidelity

The source was read through both final declarations, not just its theorem
names. `index_aux` inducts on remaining target fuel, allowing overshoots.
The maintained sum of requested targets is no greater than the actual
decrease or `u`. The shifted recurrence bounds each attempt's cost by
`a0*eps`. `ordered_sweep` telescopes upper endpoints at entry against lower
endpoints at exit; thus intervening refinements and increasing widths are
allowed. In `reverse_macro_aux`, decreasing subblock indices telescope
actual target decreases; completing all `q` would force `q*u <= 1`.
An implicit recurrence, with factor `a1/(a1-a0)`, bounds the continuing
prefix; one last subblock costs at most `2*a0`. Grouping macroblocks and
applying the ordered sweep again gives the stated total.

The separate fidelity document correctly describes the encoded objects,
quantifiers and bound. The formal theorem uses the smaller permissible
target `min(eta,remaining actual target)`. This is sufficient for the
existential search proposition; it does not verify every execution of the
manuscript's larger-target algorithm. The source does not define entropy,
construct an entropy realization, translate floors/asymptotics in `d`,
or contain Fourier analysis. These limits are substantive, not compiler
defects.

## Replays and their scope

An unchanged source and fidelity copy is compiled in active-project
`replay/`, through Argus `lean_evidence verify`, **without `--claim`**.
`replay/lean_check.json`, `compiler_result.json` and `compile.log` record
the fresh compiler and axiom audit; `runner_receipt.json` preserves the
durable task handle. The compiler checks the copied old theorem, not the
review's claim. Neither copied file is edited during or after verification.
The real toolchain is Lean 4.31.0 / Lake 5.0.0-src+68218e8 with the host's
built Mathlib workspace; only `propext`, `Classical.choice`, `Quot.sound`
are reported for the two named declarations.

`replay_math.py` executes only the old checker's pure arithmetic functions,
never its old-workspace `main`, `lean_check`, or write-capable compile path.
`replay_math.json` records exact rational reproduction of all five traces,
including growing widths, overshoots, clipped targets, both skips and
equality at the strict thresholds. The three certified samples have
`(N,n,q)=(4,1024,4),(16,1048576,16),(64,1073741824,35)`.
They are finite diagnostics, not the universal theorem or entropy witnesses.

The fresh bounded Jacobian replay uses the discovered and then inspected
`polynomial.multivariate.factor.compute`. Dedicated JSON files preserve
the exact payload, contract and typed response. Server 0.14.0, MCP protocol
2025-11-25 returned `FACTORIZED`, reconstruction `EXACT`, no adapter error,
for

```
a^2*d + a*c + 2*a*d*x + 2*c*x = (a+2*x)*(c+a*d).
```

The rational checker independently multiplies the returned factors. This
identity supports only the shifted recurrence algebra. The old discovery
of no matching adaptive-search operation was not a disproof of that search.

## Historical evidence reconciliation

The two old certificates have different receipt paths/bytes but embed the
same source and fidelity text. Both bind **v2**, content hash
`d46037792ce701e75d476a049218ed163ce6c302e0a345d725013306d4f86346`,
not v1. The current working-source certificate is the non-nested one;
the nested receipt is retained as a superseded invocation.
`lean-C_ER_FINITE-496181a21cb5` and independent
`judgement-C_ER_FINITE-18396af688ef` support that v2 binding.
The engineer's separate supporting opinion is not independent review.

The graph's `status=open`, `pending_independent_reviewer` and
`reviewer_confirmed=false` are stale workflow labels relative to that
recorded independent judgement. They neither negate the actual compiler
result nor close downstream mathematics. Conversely, `R_ER_TWO_LEVEL`
still names v1's hash: its old obligation does not silently acquire v2's
mechanical evidence. We reuse the verified v2 argument explicitly and do
not rewrite the old graph or ledger.

The contribution is formal verification of a manuscript argument, not a
new search theorem claimed here. Its literary novelty remains unverified;
the comparator's proof hole does not establish novelty. Native independent
acceptance of this review remains pending.
