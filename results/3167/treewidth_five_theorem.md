# Quartic graphs of treewidth at most five

## Statement and status

**Theorem (computer-assisted proof submitted for independent review).**
Every finite simple 4-regular Hamiltonian graph of treewidth at most five
has at least two distinct undirected Hamiltonian cycles.

A Hamiltonian cycle means a spanning connected 2-regular edge set; rotation
and reversal do not create different cycles. Decompositions may branch
arbitrarily. There is no graph-order bound or restriction to pathwidth.

The finite closure certificate below completed with exit zero on
2026-11-04. The proof combines that certificate with the elementary
normal-form and completion-profile arguments in `normal_forms.md` and
`hamilton_liveness.md`. Host independent correctness review, originality
verification and publishable-significance assessment remain pending.
No independent acceptance or `verified_new` designation is asserted.

## Certificate and its exact meaning

The input is
`profile_certificate/runs/batch-feedback2-full/frontier.snapshot.json`.
Its SHA-256 is
`e60b440f0cf4f67777e73cdc9854ced621b08decacd0fa89a4b2b278a57b657e`.
It is a stable read-only construction DAG, not a live producer checkpoint.
The recorded result is
`profile_certificate/runs/batch-feedback2-full/exact-result.json`, SHA-256
`372427e968302402e370c03326ed2350b5dff9fcaf3936bba084cd017df0680b`.
The durable task `tw5-batch-feedback2-full-scan`, run
`tw5-batch-feedback2-full-scan-1793795570247102595`, finished normally;
its original receipt and completion record are beside the result.

| Exact obligation | Completed result |
| --- | ---: |
| Construction rows, including inactive ancestors | 809,003 |
| Active pointed rows | 152,441 |
| Full positive entries replayed, including closed entries | 88,107,797 |
| Positive closed entries replayed | 4,511,409 |
| Legal unary operations | 1,879,078 |
| Same-boundary bundle pairs accounted | 209,969,712 |
| Required proper-adhesion pairs completed | 35,112,499 |
| Required relative boundary orders accounted | 25,209,843,635 |
| Uncovered unary or binary targets | 0 |
| Empty-boundary closed unit markers | 0 |

Leaf coverage also passes. The routing catalog sizes for zero through six
terminals are `2,3,6,15,44,143,500`. Every construction uses actual simple
boundary edges, degree-four forgetting and disjoint interiors at joins.
Clipped counts in `{0,1,2}` are independently reconstructed, not inferred
from producer flags. Here two means at least two. Every row's full positive
support and its genuine count-one marker are verified, including inactive
ancestors. No positive closed routing is discarded.

The largest witness graph has 19 vertices. This is a property of the
finite representatives, **not** a graph-order bound in the theorem.

The checker derives its own DSU routing tensor, unary images, completion
relation, coverage index, boundary actions and relative-order orbit covers.
It imports catalog descriptors, checking their validity, distinctness and
complete cardinalities, not producer transition or dominance routines.
Full-support symmetries transport individually realized unit markers;
they are not assumed to preserve a single witness's whole count vector.
Boundary-only and closed-marked operands remain in the binary domain.
All smaller-boundary unary feedback is unrestricted.

The required join domain contains every relative order whenever at least
one operand has an isolated boundary vertex. The other 174,857,213 bundle
pairs are dense pairs outside this sufficient operation domain, not
silently checked joins. Their sufficiency follows from the normal-form
lemma, not from a computational assertion about their outputs.
Within the required domain, illegal degrees and repeated actual edges
are explicitly accounted. Validated orbit representatives account for
every remaining order with its exact orbit size.

## All-orders deduction

Write a pointed state as `(g,A,q,S)`: underlying boundary degrees, actual
boundary edges, a routing of count one, and the full positive live support.
For exterior routing type `t`, let `K(q,t)` mean that the two routings
join into one spanning cycle. Put

    N(S) = union of {t : K(r,t)} over r in S,
    U(q,S) = {t : K(q,t) and not K(r,t) for every r in S except q}.

A representative at the same `g,q` has `A' subset A`,
`N(S') subset N(S)` and `U(q,S) subset U(q,S')`, up to boundary relabeling.
These are comparisons of full supports, not replacements of supports
by their completion masks.

For a nonnegative exterior count vector `w`, the marked continuation is
unique precisely when some `t in U(q,S)` has `w[t]=1` and every other
entry of `w` on `N(S)` is zero. Thus the representative relation preserves
every unique marked continuation. A missing original unique neighbor
or a new positive neighbor is detected by a singleton or two-entry
exterior vector, respectively, so this interpretation yields both
profile inclusions after composition.

More explicitly, at a unary operation or join with a unit marked output
having nonempty `U`, absorb the operation and any other operand into an
exterior vector for one input. Nonnegative edge-set counting forces a
unit input contribution. Replacing that input preserves every unique
marked completion; at a join, repeat for the other input. The original
marked routing contribution survives. A singleton unique exterior
forces its new coefficient to remain one. Varying the exterior gives
the output-profile inclusions. Fixed underlying degrees and actual-edge
inclusion preserve operation legality, and every contribution used by
a quartic completion survives the live projection. This is the
composition lemma proved in `hamilton_liveness.md`.

Suppose now that a graph in the theorem had exactly one Hamiltonian
cycle. Contract every decomposition edge whose bags are contained one
in the other. Adjacent remaining bags are incomparable. Lift a child
bag `Y` to its parent bag `X` by first forgetting `Y \ X`, then
introducing `X \ Y`. Running intersection makes the forgotten vertices
already degree four and the introduced vertices isolated. Since
`X \ Y` is nonempty, joining this child to the accumulated parent is a
proper-adhesion join. Assign graph edges once to containing bags and
combine children successively. Every bag has at most six vertices;
at the root, forget the remaining vertices at degree four. This is
an exact construction of the original graph, including arbitrary
branching, as proved in `normal_forms.md`.

At every construction subtree the restriction of the unique cycle has
count one and nonempty `U`: its actual exterior witnesses a unique
completion, and any second interior selection of the same routing
would yield a second full cycle. The leaf is covered. Inductively replace
child restrictions by carrier representatives using the composition
lemma; the certified unary or proper-adhesion join coverage supplies
the next representative. All boundary relabelings are accounted for.
At the root this supplies an empty-boundary closed unit marker in the
carrier. The exact certificate excludes that marker, a contradiction.
This proves the stated all-orders implication from the verified finite
certificate. QED.

## Reproduction

The actual successful checker command, run from
`profile_certificate/runs/batch-feedback2-full`, was:

```bash
ROOT=/home/argustest/zimo/counterexample-batch-1/campaigns/3167
PY=/home/argustest/zimo/argus-live-update/.venv/bin/python
PYTHONPATH="$ROOT" "$PY" -B -m research.treewidth_five.profile_certificate \
  --input frontier.snapshot.json --output exact-result.json \
  --collect-gaps 32768 --certify-if-closed
```

The optional gap collector certified only its fresh complete zero-gap
in-memory scan after all mandatory prerequisites. Its cap was not reached.
No old diagnostic was relabeled, no generator cursor was trusted, and no
unchanged full scan was repeated. Elapsed replay-plus-check time was
561.501 seconds; this is one scoped observation, not a performance bound.

For an independent rerun, preserve the original result and use a separate
run directory. The standard no-collection checker checks the same
mathematical obligations without the single-pass wrapper:

```bash
ROOT=/home/argustest/zimo/counterexample-batch-1/campaigns/3167
PY=/home/argustest/zimo/argus-live-update/.venv/bin/python
mkdir -p "$ROOT/research/treewidth_five/profile_certificate/runs/independent-final"
cd "$ROOT/research/treewidth_five/profile_certificate/runs/independent-final"
"$PY" -B -m argus_skill.tools.subagent submit \
  --task-id tw5-independent-final --mode direct --timeout 7200 --cwd "$PWD" \
  --command "PYTHONPATH=$ROOT $PY -B -m research.treewidth_five.profile_certificate --input ../batch-feedback2-full/frontier.snapshot.json --output exact-result.json"
```

Preserve the returned task/run/check-with receipt. A runner timeout or
unfinished schedule is not a mathematical conclusion. Exit zero requires
the full finite operation certificate, not an accepted theorem verdict.

The checked implementation SHA-256 values are:

| Source | SHA-256 |
| --- | --- |
| `profile_certificate/bulk.cpp` | `07f02f1de08a028c6792588604ef36948a9b59d40b898041595708604809c01b` |
| `profile_certificate/bulk.py` | `1ede33a1d47bd6d14a78a9b0cc62ec763d2070bc2d26dcbefec99b3c044feadd` |
| `profile_certificate/__main__.py` | `11caede1dcbcbb52a172b621e167d284426507cfd41da6261544b5d09deda6f1` |

## Comparison and remaining review

The strongest independently accepted campaign theorem excluded treewidth
at most four. The present argument raises that bound to five for arbitrary
branching, rather than only adding a pathwidth-five corollary. The 3-by-3
rook graph and arbitrarily large quartic chains in `pathwidth_five.md`
have exact treewidth five, showing that the added parameter class is
genuine; they are not counterexamples or novelty evidence.

The immediately preceding complete carrier scan found 58 distinct binary
gaps. Literal feedback for all 58, plus every consequent unary operation,
created 77 construction rows and produced this closed carrier. Earlier
marker 342 is covered; neither its numerical label nor insertion of one
marker was treated as closure of an entire output family.

The accepted treewidth-four proof and Reviewer verdicts remain unchanged.
The prior Sanders and Arnborg--Proskurowski source-access limitations are
not resolved by this computation. No absence-of-literature inference,
originality certificate or claim about unrestricted Sheehan's conjecture
is made. Independent correctness and publication review are the next
obligations, not further producer search on this unchanged closed carrier.
