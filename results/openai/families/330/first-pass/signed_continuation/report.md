# Signed continuation core

## Scope and prior result

The target is the implication in `walks.tex`, Lemma
`lem:exceptional-directions`, and `tests.tex`, Lemma `lem:edge-test` and
equations `eq:edge-lower`--`eq:average-error`, in the staged September 26,
2026 manuscript. This is a component verification, not a verification of
the AP-without-BAP theorem.

The initial campaign ledger contains no prior certified mathematical
result. The inherited Wiki index has no page about this manuscript or
Lipschitz-free approximation. The strongest relevant prior argument is
therefore the manuscript's own deterministic continuation and signed
variation proof. The intended improvement is a parameter-uniform,
machine-checked theorem whose hypotheses explicitly include the actual
matched-walk definition, rather than a finite experiment or an assumed
exceptional-set covering property.

The finite scalar extension used here is the classical McShane
construction, not a claimed new extension theorem: E. J. McShane,
*Extension of range of functions*, Bull. AMS 40 (1934), 837--842,
doi:10.1090/S0002-9904-1934-05978-0. Its finite formula is also proved in
the staged `tests.tex`. The present proof will not require an unproved
external extension theorem. The comparison to Ben-David et al. in
`walks.tex` is historical motivation only; no result from their graph
algorithm is an input.

## Exact boundary

Source edges are distinct instances with two reversing incidences, even
for loops. Immediate reversal, not vertex repetition, is forbidden.
States may repeat. State adjacency is the closed condition `d <= 2 L`;
the scalar-test cross-pair argument splits at `d < 2 L` versus
`2 L <= d`. A record of zero does not assert compatibility. A tied
maximum is not exceptional. Measures have arbitrary real signed
coefficients; positivity and total mass one are not needed for this
component.

The remaining manuscript dependencies are the block geometry, common
finite-support perturbation, signed measure/bump estimates, colored
local-limit construction and adaptive-support rare-walk selection, and
the block-to-wedge/approximation reductions. They remain open in the
proof graph.

## Verification theorem

Let a nonempty finite source multigraph have degree `Delta > 0`, represented
by the incidence set `Vtx x Fin Delta` and a fixed-point-free reversal
involution. Let `S` be a finite subset of any metric space `X`. The label
space may be any pseudometric space. Assume:

1. State labels are 1-Lipschitz and source labels at the ends of each
   incidence have distance at most one.
2. `L >= 0`; each source bump is 1-Lipschitz, takes values in `[0,L]`,
   and is positive only at label distance strictly less than `K`.
3. Compatibility means membership in `S` and label distance at most
   `K+2L+1`. State steps use the closed condition `d <= 2L`.
4. For some integer `n >= 1`, define bad vertices, continuation records,
   and exceptional incidences from actual matched walks as in the
   manuscript. Let `beta` be the fraction of bad vertices.
5. Real signed coefficients `mu_x(j)` satisfy
   `sum_j |mu_x(j)| <= V` and `sum_j b_x(j) mu_x(j) >= a0`, with
   `V >= 0`. Every bounded 1-Lipschitz scalar test has absolute
   incidence pairing at most `Lambda`.

Then there are opposing scalar tests on **all of `X`**, with the
manuscript's prescriptions and range `[-L,L]`, and

`2 a0 - 4 L V (1 / Delta + beta) <= Lambda`.

There is no positivity, mass-one, distinct-state, simple-graph, or
distinct-vertex hypothesis. The theorem allows arbitrary positive
degree and `n >= 1`; the manuscript only needs `Delta >= 4`, `n >= 2`.
It does not need integer or capped labels, colors, or a limiting graph
sequence. These are structural extensions of the setting, not a claim
that the elementary continuation principle is a novel literature result.

### Proof

A matched walk of length at least `n` has a matched prefix of length `n`.
At a good root all positive realized lengths are consequently less than
`n`. The maximum found among lengths `0,...,n-1` is therefore the actual,
untruncated continuation record. A positive record has an actual walk
witness. Zero makes no assertion about compatibility.

Consider a compatible state transition across `e:x->y`. The edge alone
is a matched walk. If neither incidence is exceptional at its state,
choose another outgoing incidence at each end whose record is at least
the record toward the other end. These competing records are positive
because the single-edge records are at least one. Prepending `e` to
the competitor at `y`, and its reverse to the competitor at `x`,
produces valid nonbacktracking matched walks. The source join is by
incidence identity, not vertex distinctness. The two inequalities say
simultaneously `r_x >= 1+r_y` and `r_y >= 1+r_x`, a contradiction.
A bad endpoint is exceptional by definition. Strict maxima at good
vertices are unique.

If a positive bump at a state `j` is opposed to a prescription at `k`
with `d(j,k) <= 2L`, the label triangle inequality gives

`labeldist(y,k) <= 1 + labeldist(x,j) + d(j,k) < 1+K+2L`.

Both endpoint-state pairs are compatible. The derived covering property
therefore forbids these two nonexceptional prescriptions. The symmetric
argument handles a positive bump at the other end. Thus nearby cross
prescriptions must both be zero, even at the **closed** threshold
`d=2L`. More distant cross pairs have sum at most `2L <= d`.
Within each prescription set the bump Lipschitz bound applies. Taking
`j=k` also proves consistency on the intersection.

This gives 1-Lipschitz real data on their union. A real-valued
Lipschitz extension, clipped to `[-L,L]`, preserves the data. The
empty union is allowed. The formal proof uses Mathlib's kernel-proved
`LipschitzOnWith.extend_real`; no unproved McShane assertion remains an
assumption in the ledger.

For arbitrary real coefficients, the two differences `f_e-b_x` and
`-f_e-b_y` vanish off their exceptional sets and have absolute value
at most `2L`. The inequality `-|u| |c| <= u*c`, valid for either
sign of `c`, gives

`pairing_e >= 2 a0 - 2L (loss_e + loss_reverse(e))`,

where `loss_e = sum_{j exceptional at e} |mu_x(j)|`. This is a
variation estimate, not a positivity argument.

At a good vertex each state contributes to at most one direction;
the sum of outgoing losses is at most `V`. At a bad vertex it is at
most `Delta V`. Summing the slightly weaker bound
`V + Delta V * indicator_bad` gives

`sum_e loss_e <= |Vtx| V + Delta V #bad`.

Reversal is a bijection of all oriented incidences, including the two
incidences of every loop, so its loss sum is identical. Sum the
per-edge inequality, use the upper bound, and divide by the positive
number `|Vtx| Delta`. This is the asserted result.

### Manuscript specialization

The manuscript substitutes `a0 = 3L/4`, `Lambda = 2p`,
`L = 10p`, `p >= 1`. The two small quantities are
**`V/Delta < 1/20` and `V beta < 1/20`**. Consequently the loss term
is less than `4L/10`, and the lower bound is strictly greater than
`11L/10 = 11p`, contradicting `Lambda = 2p`.
`SignedContinuation.manuscript_margin` proves this strict numerical
contradiction for all real parameters satisfying these hypotheses.

## Executed evidence

`Main.lean` was compiled by the official `lean_evidence verify`
entrypoint, using Lean **4.31.0**, with `exit_code=0`,
`audit_exit_code=0`, and `proof_holes=[]`. The axiom audit reports only
`propext`, `Classical.choice`, and `Quot.sound` for the core, opposing
tests, continuation covering, and numerical specialization.
`lean_check.json` binds that run to both the source and the statement
fidelity document. The claim-bound archival certificate is in
`certificates/`. The public Engineer record does not substitute for
independent Reviewer judgement.

The exact finite adversarial experiment passed:

| Exact check | Count |
|---|---:|
| Labeled incidence graphs | 128 |
| Continuation contexts | 26,496 |
| Zero good-vertex records | 136,368 |
| Positive tied good-vertex records | 788 |
| Opposing scalar tests | 3,456 |
| Signed one-sided variation inequalities | 864,000 |
| Averaged obstruction instances | 108 |
| Nonempty prescriptions with both endpoints good | 1,344 |

The graph corpus contains every labeled reversal pairing for
`(vertices,degree)=(1,2),(1,4),(2,2),(2,4),(3,2)`, and one
four-cycle. All compatibility patterns for zero, one, or two states
and all reflexive symmetric near relations on those state sets are
tested at cutoffs `1,2,3,4`. Explicit walks repeat a loop incidence
and return along a different parallel edge with a repeated state.

The scalar corpus uses exact rational line metrics, cycle source
graphs, label bumps, actual records, zero and nonzero heights, and
all coefficient triples in `{-2,-1,0,1,2}^3`. There are 9,216 strict,
8,064 equal, and 13,824 greater-than threshold pairs. The separate
averaging examples use genuinely signed mass-one vectors, not
probability vectors. The finite counts are diagnostics only; the
universal conclusion is supplied by Lean.

Jacobian 0.14.0, protocol `2025-11-25`, was used through the authorized
adapter. Discovery and typed-contract inspection found a matching
exact rational LP operation,
`optimization.linear.rational_general_optimum.compute`, for a bounded
scalar-extension subproblem. The original three-variable formulation
was rejected by its simplex-basis admission limit. That structured
`INVALID_REQUEST` is preserved and is **not** a mathematical conclusion.
Eliminating the two fixed endpoints gave a one-variable formulation;
the exact typed output is `OPTIMAL` with midpoint zero, reconstructing
the tight scalar extension `(1,0,-1)`. `verify.py` replays primal
feasibility, dual signs, stationarity, complementary slackness, and
primal-dual equality, including the omitted constant in the original
signed objective. Dedicated JSON files preserve both payloads,
the inspected contract, and both outputs.

## Source limitations and reproducibility

The McShane DOI metadata resolved, but attempts to obtain the original
theorem text met HTTP 403 and an anti-bot page. The proposed original
paper locator was therefore withdrawn rather than treated as checked.
The finite formula in the staged manuscript was available; the
formal extension proof discharges that temporary dependency. No
external literature theorem is an undischarged assumption of the
certified core. No mathematical refutation was identified in this
component, so there is no invented `F_` claim.

Run the exact replay with:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/signed_continuation/verify.py
```

For a fresh real compiler run, use:

```bash
ARGUS_SKILL_MATHLIB_WORKSPACE=$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0 \
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/signed_continuation/Main.lean --project-root . \
  --claim C_SIGNED_CONTINUATION \
  --statement-fidelity research/signed_continuation/statement_fidelity.md
```

The installed CLI takes the source as a positional argument, not the
`--source` spelling in the mission's example. No project lakefile
was added; the existing built Mathlib workspace is used.

`exact_certificate.json` records the deterministic replay result.
Independent Reviewer replay and statement-fidelity approval remain
required. The full campaign remains open: neither publishable novelty
nor the manuscript's local-limit and infinite-dimensional dependencies
are claimed certified by this component.

The official campaign-local checks both returned zero against
`campaigns/9000330`:
`math_state check` and `proof_graph_check check`. The derived status
of `C_SIGNED_CONTINUATION` is `closed_kernel`, with no undischarged
assumptions or stale evidence. Graph nodes remain open pending the
independent Reviewer; no reviewer-confirmation flag was manufactured.
The default standalone certificate replay also returned zero.
