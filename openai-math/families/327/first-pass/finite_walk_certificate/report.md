# Proposition `prop:walks`: source-faithful universal verification

## Result and scope

Proposition `prop:walks` is kernel certified for arbitrary positive `n` and
arbitrary admissible norm. Lean 4.31.0 returned `exit_code = 0`,
`proof_holes = []`, and a successful environment axiom audit. Both the explicit
all-conditions theorem and the imported `finiteWalk` have exactly the transitive
axioms `propext`, `Classical.choice`, and `Quot.sound`; there are no additional
mathematical axioms. The ledger derives `CWalk: closed_kernel`, with no
undischarged assumptions. Independent Reviewer confirmation of statement
fidelity and replay remains pending.

The immutable official compiler certificate is
`certificates/CWalk-d0a6fb48b124f143.json`. `exact_certificate.json` records its
universal theorem and the separate bounded exact experiments.

The precise target is Proposition `prop:walks` of the staged September 23, 2026
manuscript, not the implication from nontrivial Markov type to superreflexivity.
For every spreading-invariant real norm on `c00` with contractive adjacent
merging, and every positive integer `n`, the required object has finite states,
finite oriented marked edges, stationary initial distribution, detailed balance,
odd unit-norm labels in one finite coordinate span, and

    P(N(g(E_1) + ... + g(E_n)) >= n/24) >= 3/20.

There is already a public Lean proof of this mathematical proposition. The
strongest prior input is `OAI.MarkovSuperreflexivity.finiteWalk` at OpenAI
revision `4eaee87548250b2682affda7d05d947c05554bae`, not merely a bounded
experiment or the unsigned algebraic identity. The independent contribution
here is source-fidelity analysis, an explicit all-conditions theorem, exact
adversarial replay, and recompilation of the relevant custom dependency cone
on the requested Lean 4.31.0 host. This is not a new-discovery or
`verified_new` claim. A successful bounded mission does not close the larger
publishable exploratory campaign.

## Mathematical obligations

For `L = 8(n+1)`, put `D_k = N(1,-1,...,1,-1)` with `k` pairs.
Positive definiteness gives `D_L > 0`. Spreading invariance and the triangle
inequality give `D_L <= 2 D_(L/2)`. No unconditionality or basis normalization
is used.

Finite order averaging followed by maximal coupling gives a finite stationary
chart chain. Its marked edges are triples `(C,s,C')`; reversing exchanges the
charts and inverts the letter. Both coupling marginals are the chart law, so
the edge masses balance. At every step the letter is independently uniform on
the four-letter alphabet. The stationary probability of a failed full-domain
chart match is at most `epsilon = 1/(10n)`. No independence of the matching
events is required.

For positive `s`, the raw label is the sum of
`b_(C(alpha_s+j)) - b_(C(beta_s+j))` over `0 <= j < L`.
A negative edge receives the negative of its reversed positive edge's label;
it therefore reads the **target** chart. Every label, including labels on
bad or zero-probability marked edges, has norm `D_L`. Its total coefficient
sum is zero.

On an all-good path, start at an integer `j` or at `z+j`, where `z` is the
fractional part of the word image of zero. Following inverse letters preserves
the coordinate rank. The relevant orbit points are in the finite landmark set;
for `L/4 <= j <= 3L/4`, all inverse trajectories stay strictly inside `(0,L)`.
Indeed `L/4-2n = 2` and `3L/4+1+2n = L-1`.
At a prefix cut including the coordinate of the landmark, the label
`b_alpha-b_beta` contributes the indicator of the **left-closed,
right-open** interval `[alpha,beta)`.

The inverse-arc complement identity gives the contribution of a negative step
as `indicator(A_s)-1`, not as the negative of a source-chart indicator.
Consequently the cumulative label sum at the transported cut equals the
signed cocycle `c_w`. Adjacent inverse letters cancel in this scalar
expression, while the vector sum still includes all `n` original labels.
For a reduced word with positive length `ell`, its two prefix levels are
`V = -n_minus` and `U = n_plus`, so `U-V = ell`.

Consecutive block compression at interlaced cuts yields

    (V, ell,-ell, ..., ell,-ell, -V)

with `L/2` inner pairs. The final block is nonempty because the unused cut
`t_b` lies strictly after `r_b`. Contractive merging and the triangle
inequality give `N(G) >= ell(D_(L/2)-D_1)`.
Compression at one of the two individual levels also gives
`N(G) >= (ell/2)D_1`. Combining the two estimates yields

    N(G) >= (ell/3)D_(L/2) >= (ell/6)D_L.

For independent uniform letters, the reduced length increases conditionally
in expectation by `1/2` away from zero and by `1` at zero.
Thus `E(ell) >= n/2`, and `0 <= ell <= n` gives
`P(ell >= n/4) >= 1/4`. The union bound gives probability at most `1/10`
of any bad chart match. Therefore the intersection has probability at least
`3/20`, and dividing all labels by `D_L` gives the required distance `n/24`.
The proof applies to `n=1`; there is no asymptotic or large-`n` proviso.

## Formal statement and trust boundary

`Main.lean` exposes the witness's finiteness, common coordinate support bound,
oddness, unit norm, and exact escape event. `AllConditions` additionally makes
the stationary equation for the induced state transition matrix and total
marked-path mass one explicit. Invalid path arrays have weight zero.
The correspondence of objects, hypotheses, indexing, event thresholds, and
quantifiers is fixed separately in `statement_fidelity.md`.

The downloaded Apache-2.0 public sources and their license are preserved
unmodified in `public_sources/`. Their original toolchain is Lean 4.34.1.
`build_cone.py` generates the explicitly recorded Lean 4.31 compatibility port
in `lean431/` and compiles only the 41 custom modules needed by `FiniteWalk`.
It does not execute the public monolithic Lake configuration, run its IO hooks,
fetch a new Mathlib, or build the complete public library.
The compiler log, per-module input/output records, and final transitive axiom
report, rather than a source-text scan alone, determine certification.
All 41 custom modules compiled successfully. The port changes only two import
paths and names of existing conditional, set-membership, and `Finsupp.mapDomain`
lemmas; no theorem hypothesis or conclusion was weakened. The full reproducible
edits are in `build_cone.py`, `compatibility_patches.json`, and the per-module
`build_result.json` records. The original source toolchain remains recorded as
4.34.1; the actual certificate explicitly reports 4.31.0.

## Exact adversarial replay

`verify.py` uses only Python's standard library for the mathematical
experiments. It implements rational piecewise-affine periodic homeomorphisms
with four disjoint half-open arcs. Its completed bounded checks are:

| Check | Exact scope |
|---|---|
| Inverses, periodicity, displacement, complement, signed cancellation | 156 boundary/interior/translated probes |
| Two levels, reduction invariance, reduced-word interior, both signs | All 5,460 words of lengths 1 through 6 |
| Complete transported raw labels, prefix identity, finite-window margins, endpoint compression, two admissible norms | All 84 words of lengths 1 through 3; 2,612 prefix probes |
| Reduced-length recurrence, mean, and tail bounds | Exact integer counts through time 64; enumeration cross-check through time 6 |

These are finite adversarial tests, not proofs of universal quantifiers.
The universal proof is the Lean theorem and its checked dependency cone.
The local matching trajectories test the deterministic label identities; they
do not enumerate the Ramsey chart law or constitute stationary-chain witnesses.
The tests found no counterexample to the manuscript assertions they exercise;
this is not a claim that the entire manuscript has no flaws.

The Jacobian adapter was used for one bounded typed operation,
`probability.markov_chain.stationary_distribution.compute`, on the four-state
fresh-letter process. It returned the unique uniform stationary law exactly.
The payload, typed response, operation id, server version, protocol, and adapter
exit status are preserved in dedicated `jacobian_*.json` files. Python rechecks
stationarity and detailed balance from those rationals. This auxiliary result
does not stand in for stationarity of the full chart chain.

## Reproduction and remaining dependencies

From the campaign root, use:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/finite_walk_certificate/verify.py
```

The script recompiles changed custom inputs, runs the exact tests, invokes the
official `lean_evidence verify` with `--claim CWalk`, and runs both official
campaign-local structural checks. It requires a real archived mechanical record
for `CWalk` and a derived `closed_kernel` assessment with no undischarged
assumptions. `--exact-only` is explicitly just the finite
experiment. `--formal-only` reuses the already recorded exact experiment while
performing the real formal verification; it is intended for completing this
run without repeating unchanged experiments.

The larger main theorem still requires independent certification of
`lem:ordered-norm`, its finite-representability construction, and
`lem:edge-labels` with its lattice lift. `COrdered` records the unverified
James--Enflo structural input as an assumption, not as a checked citation.
Those are outside the dependency cone used to prove `prop:walks`.
The inherited Wiki index contained no page matching this proposition or its
finite-walk formalization. No separate novelty literature survey was needed or
claimed, because no mathematical novelty is asserted.

The independent Reviewer must replay the certificate and read the statement
fidelity against the staged proposition. The Engineer does not set the
Reviewer-confirmed flag.

Both official structural checks passed against the actual campaign root
`campaigns/9000327`, with
`math_state` exit status zero and `proof_graph_check` exit status zero.
The graph deliberately retains unconfirmed review flags: compiler closure is
not independent human review and does not discharge the two other inputs to the
main theorem.
