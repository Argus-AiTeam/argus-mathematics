# Deterministic colored local limits and adaptive finite supports

## Scope and comparison

This component addresses `blocks.tex`, Lemma `lem:local-limit`, and
`walks.tex`, Lemma `lem:rare-walks`, in the staged September 26, 2026
manuscript. The manuscript's argument is sound at these two steps; no false
assertion has been identified here. The improvement over its qualitative
argument is an explicit deterministic selection rule and a finite-error
bound uniform over all finite state systems, including systems selected
after inspecting the entire graph sequence.

The strongest prior certified component is `C_SIGNED_CONTINUATION`.
Its existing independent Reviewer receipt and claim-bound compiler
certificate are reused without recompilation or renewed review. That
component does not establish a colored local limit. Conversely, the
present component does not establish the block geometry, operator
estimates, approximation property, failure of bounded approximation, or
publishable novelty of the full construction.

The inspected primary mathematical inputs are the two staged lemmas and
their proofs. Friedman's permutation model and the Benjamini--Schramm
viewpoint are background references, not propositions assumed below.
All permutation, second-moment, finite-union, and deterministic-selection
steps used here are proved below. No spectral theorem or unspecified
existence theorem is an input. The inherited Wiki index has no page about
this manuscript or its colored local limit.

A support assumed independent of fresh random graph colors would address
the wrong quantifier order. That approach is not used. Neither full
labels nor operator-selected supports are asserted to be independent.

## 1. Quantitative permutation exploration

Fix an even degree `d >= 4`, a number of colors `k >= 1`, and a radius
`r >= 0`. Write

```
U_r = sum_{i=0}^r d^i,
c_r = 2 (1 + d U_r),
eta_r(N) = c_r^2 / (N - c_r)       (N > c_r).
```

Choose `d/2` independent uniform permutations of `[N]`. The instance
`(a,v)` is the undirected edge from `v` to `sigma_a(v)`; its positive
incidence is based at `v`, and its negative incidence is based at
`sigma_a(v)`. Reversal interchanges these two *distinct* incidences.
A fixed point is a loop of degree two. A two-cycle supplies two distinct
parallel edge instances. Every vertex therefore has degree exactly `d`.
Colors are independent uniform elements of `[k]`, independently of the
permutations.

Explore one prescribed root, or two distinct prescribed roots, in
breadth-first order. Initially mark all the prescribed roots as
discovered. At every vertex at distance at most `r` from either root,
query every permutation image and inverse image. Newly discovered
vertices at distance `r+1` are recorded but are not expanded. There are
at most `2 U_r` expanded vertices, at most `2 d U_r` queries, and at most
`2 + 2 d U_r = c_r` discovered vertices. These bounds remain valid after
collisions, by the elementary degree bound on a graph ball.

Here is the conditional probability calculation, including inverse
queries. If `t_a` pairs of permutation `a` have already been exposed,
there are exactly `(N-t_a)!` possible completions of that permutation.
For an unexposed domain, fixing its image to any unused range leaves
`(N-t_a-1)!` completions. The analogous statement holds for an inverse
query at an unused range. Independence between the permutations
persists conditional on their exposed pairs. Consequently a fresh
answer is uniform on at least `N-c_r` possibilities. At most `c_r` of
these answers are previously discovered vertices. An exposed query
reuses its already identified edge instance and is not a fresh trial.

Declare a collision whenever a fresh answer is a previously discovered
vertex. Conditional on every preceding history, its probability is at
most `c_r/(N-c_r)`. Summing the indicators of collisions over at most
`c_r` query slots, including a zero indicator after exploration has
finished, proves

```
P(any collision) <= eta_r(N).
```

There is no assumption of independence between collision events.
Without collisions the exploration is a forest, one component for each
prescribed root. All non-parent fresh queries add a new vertex and one
edge; querying a parent edge reuses that instance. This also proves
that loops, parallel edges, and intersection of the two explorations
are detected. Revealing all ports at distance exactly `r` detects
edges *between boundary vertices*, not merely the breadth-first
spanning tree. Thus the induced radius-`r` balls are disjoint copies
of the regular-tree ball on the no-collision event.

The no-collision event only concerns permutations. Conditional on any
collision-free revelation, the colors on the distinct discovered
vertices retain their independent uniform law.

## 2. Frequencies and an explicit deterministic sequence

Let `T_r` contain all rooted connected colored multigraph types of
maximum degree at most `d`, radius at most `r`, and at most `U_r`
vertices. It contains every possible induced radius-`r` type and the
regular-tree ball, including types absent from a particular finite
graph. Let `q_r(t)` be their probabilities in the
independently colored regular tree. In particular `q_r(t)=0` for
non-tree types. For a random permutation graph let `X_t` denote the
fraction of roots of type `t`.

The preceding coupling gives, for distinct prescribed roots `v,w`,

```
|E I_v - q_r(t)| <= eta_r(N),
|E (I_v I_w) - q_r(t)^2| <= eta_r(N).
```

These are valid also for non-tree types: on the good event the
indicators vanish. Exchangeability and `0 <= I_v <= 1` give

```
E (X_t - q_r(t))^2
 <= 1/N + eta_r(N) + 2 q_r(t) eta_r(N)
 <= 1/N + 3 eta_r(N).
```

For completeness, the first inequality follows by expanding the square,
using
`E X_t^2 <= q_r(t)^2 + 1/N + eta_r(N)` and
`E X_t >= q_r(t)-eta_r(N)`.
For every positive `a`, the pointwise inequality
`a^2 1_{|X_t-q_r(t)| >= a} <= (X_t-q_r(t))^2`
then bounds the probability of that event by
`(1/N+3 eta_r(N))/a^2`. This is the finite counting proof of the
second-moment bound, rather than a cited concentration theorem.

An explicit overcount of the number of types is

```
Tbound_r = sum_{b=1}^{U_r} b k^b (b d + 1)^(b d).
```

Indeed label the `b` vertices, choose the root and their colors, allocate
`d` incidence slots per vertex, and map each slot either to a partner
slot or to a null symbol. Every multigraph of maximum degree at most
`d` has such an encoding; most encodings are invalid or redundant,
which only increases this bound. This includes partial boundary
degrees, loops, and parallel instances.

For `m >= 1`, put

```
A_m = sum_{r=0}^m Tbound_r,
a_m = 1 / ((m+1) A_m),
N_0 = 0,
N_m = max(N_{m-1}+1, 2 c_m+1,
          2 A_m^3 (m+1)^2 (1+6 c_m^2)+1).
```

Here `c_m` is the radius-`m` value of `c_r`, not the index of a graph.
For `r <= m` and `N=N_m`,
`eta_r(N) <= 2 c_m^2/N`.
A union bound over all radius/type pairs at radii at most `m` shows
that the probability of even one deviation at least `a_m` is at most

```
A_m^3 (m+1)^2 (1+6 c_m^2)/N_m < 1/2.
```

Hence a satisfactory realization exists.

This is also an exact deterministic construction: order the finite
tuples consisting of `d/2` permutations of `[N_m]` and a coloring
lexicographically, and choose the first tuple for which every displayed
frequency error is less than `a_m`. The comparisons are exact rational
comparisons. The tree probabilities are computed by enumerating all
`k^b` colorings of the finite regular-tree ball with `b` vertices,
canonicalizing rooted colored multigraphs, and counting each type.
Types not occurring in that enumeration have probability zero.
Enumeration of all finite bounded-degree radius-`r` types is finite.
The positive-probability argument proves that this finite search
terminates. Efficiency is not asserted or needed.

Write `mu_{m,r}` for the empirical type law of the resulting graph and
use the standard total-variation convention

```
epsilon_{m,r} = (1/2) sum_t |mu_{m,r}(t) - q_r(t)|.
```

For `r <= m`, the construction gives

```
epsilon_{m,r} < Tbound_r / (2 (m+1) A_m) <= 1/(2(m+1)).
```

Thus `N_m` increases strictly, every graph is nonempty, and all induced
colored rooted type frequencies converge to the claimed tree law.
This proves `C_LOCAL_LIMIT`, with no unproved suitable-sequence input.

## 3. Uniform finite-discrepancy transfer

Let `S` be any finite state set, with a directed transition relation
having at most `Q` successors per state. For each state `j`, choose an
allowed color set `C_j` with at most `H` elements. The relation need not
be symmetric or irreflexive, states may repeat, allowed color sets may
overlap, and `S` may be empty. All these data may be arbitrary functions
of the entire deterministic graph sequence.

For a fixed `n >= 0`, let `E_{S,n}` be the color-only event that a
nonbacktracking length-`n` walk from the root has an allowed state
sequence and the color at its `i`th vertex belongs to `C_{j_i}`.
The event is determined by the induced colored radius-`n` ball.
Incidences, not endpoint pairs, determine immediate reversal; loops
and parallel edges are retained in its rooted type.

In the regular tree a nonbacktracking walk visits `n+1` distinct
vertices. There are at most `d^n` such walks, and at most `|S| Q^n`
state sequences. For each fixed pair of witnesses, *vertex-color*
independence gives probability at most `(H/k)^(n+1)`.
Repeating a state does not repeat a source vertex. A union bound,
without independence between witnesses, gives

```
q_n(E_{S,n}) <= |S| (H/k) (d Q H/k)^n.
```

For any two probability vectors `mu,q` on a finite type set and any
subset `E`,
`mu(E) <= q(E) + (1/2) sum_t |mu(t)-q(t)|`.
For example, the sums of the positive and negative parts of `mu-q`
are equal because its total sum is zero; each is half its absolute
sum. Applying this to `E_{S,n}` proves the simultaneous bound

```
mu_{m,n}(E_{S,n})
 <= epsilon_{m,n} + |S| (H/k) (d Q H/k)^n.             (1)
```

If compatibility of a source vertex `x` and state `j` implies
`color(x) in C_j`, every genuinely matched walk is a color-only
witness. Its root fraction `beta_m(S,n)` therefore satisfies the
same bound. Nothing requires the full label compatibility test to
be measurable from the radius-`n` ball: only its dominating
color-only event is used.

The important uniformity is that `epsilon_{m,n}` does not depend
on `S`, its transition relation, or its allowed color sets. The
inequality holds for all of them at once in every fixed graph.
Consequently choosing state data by inspecting that sequence does
not condition any random variable in the proof.

## 4. Successive choices of walk length and graph

Suppose `k > 2 d Q H`, let `rho=d Q H/k < 1/2`, and fix the finite
state data and any `delta>0`. The geometric sequence
`|S| (H/k) rho^n` tends to zero. Choose `n>=2` with this quantity
less than `delta/2`. Now choose `m>=n` sufficiently large that
`1/(2(m+1)) < delta/2`. Equation (1) gives `beta_m(S,n)<delta`,
and the same holds at every larger index satisfying that bound.

The geometric assertion also covers `S` empty, `H=0`, or `Q=0`;
at `n>=2` the zero factors give zero. In the manuscript `V>0`,
so `delta=1/(20V)` proves its successive `n,m` selection.
The geometric estimate needed for `C_RARE_WALKS` is exactly that
each state has at most `Q` nearby successors and at most `H`
uncapped label coordinates. Compatibility implies membership of
the source color in those coordinates because
`h_i(x)=0` and `|h_i(x)-h_i(j)| <= D-4 < D`.
Those geometric hypotheses remain an independently open block
obligation; no operator-independence assumption is substituted for them.

Enlarging the bad set by non-tree induced radius-`(n+1)` balls
also works. Their tree-law probability is zero, so their frequency
is at most `epsilon_{m,n+1}`. The enlarged fraction is consequently
at most the right side of (1) plus `epsilon_{m,n+1}`, which also
tends to zero after `n` is fixed.

## 5. Executed certification and its boundary

The official `lean_evidence verify` run compiled `Main.lean` using
Lean **4.31.0**, with compiler exit code **0**, axiom-audit exit code
**0**, and **`proof_holes=[]`**. The principal declarations are
`AdaptiveSupport.finite_discrepancy_transfer` and
`AdaptiveSupport.successive_selection`; both report only `propext`,
`Classical.choice`, and `Quot.sound`. The claim-bound archival
certificate is
`certificates/C_ADAPTIVE_TRANSFER-6cd7576d9e877369.json`.

The proof counts actual uniformly independent vertex colorings via a
bijection to restricted and unrestricted coordinates. It also proves
completeness and the cardinality bound of the recursively generated
state paths. Its structural generalization permits any finite family
of injective vertex sequences with at most `d^n` members, arbitrary
directed state transitions, and empty or repeated states. The
statement-fidelity document spells out the type-invariance and
compatibility-to-color interface. These are not assertions of
independence from an operator.

The full permutation exploration and deterministic construction in
Sections 1--2 are a **complete prose proof**, not a claimed Lean
formalization. The compiler verifies the subsequent universal finite
transfer and selection theorem. Independent review must inspect both
that prose proof and the concrete incidence/type instantiation.

The exact finite diagnostics passed:

| Diagnostic | Count |
|---|---:|
| Partial bijections with exact completion counts | 252 |
| Fresh image/inverse conditional distributions | 676 |
| One- and two-root explorations | 4,624 |
| Collision-free explorations with induced-ball checks | 534 |
| State systems per finite case | 265 |
| Exact independently colored tree probability bounds | 1,590 |
| Finite-discrepancy transfer inequalities | 637,060 |
| Adaptive stricter-compatibility dominations | 637,060 |
| Colored-type event-invariance comparisons | 2,362,740 |

The corpus includes loops, two-cycle parallel instances, repeated loop
incidences, non-reversing parallel returns, and a triangle whose
boundary-to-boundary edge a spanning-tree-only check would miss.
There are 677 source laws with total variation strictly between zero
and one; the transfer tests are not exclusively the trivial
discrepancy-one case. Exact integer inequalities check four
deterministic diagonal-selection thresholds, and six rational
examples check the successive `n,m` choices including zero factors.
These diagnostics do not prove an asymptotic or universal statement.

Jacobian **0.14.0**, protocol **2025-11-25**, was queried and its exact
typed contract was inspected before the finite computation. The
applicable operation was
`probability.finite_distribution.raw_moment.compute`, not the old
linear-programming operation. On all 36 pairs of permutations of
three vertices, the fraction of vertices incident to a loop has
distribution

```
0: 1/9,  1/3: 5/12,  2/3: 1/6,  1: 11/36.
```

Its second raw moment is exactly `23/54`. The bounded typed run
returned that value and all four exact contributions, with adapter
exit code zero, no structured error, and no timeout. The dedicated
contract, payload, output, and status JSON files preserve this run.
This is a diagnostic of the permutation model, not an external proof
of the local limit.

Reproduce the exact diagnostics and check the recorded source-bound
compiler certificate with:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/adaptive_support/verify.py
```

The official Lean command, if a fresh compiler run is needed after a
source change, is:

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/adaptive_support/Main.lean --project-root . --claim C_ADAPTIVE_TRANSFER --statement-fidelity research/adaptive_support/statement_fidelity.md --artifact-dir research/adaptive_support
```

No manuscript assertion in the scoped two lemmas was refuted, so no
invented `F_` claim is recorded. The independently open geometric
input to the manuscript specialization is explicit in the
`C_RARE_WALKS` ledger assumption `BLOCK_SMALL_BALL_AND_COLORS`.
Independent Reviewer confirmation of this new component is pending.
No full-manuscript certification, terminal campaign acceptance, or
verified publishable novelty is claimed.
