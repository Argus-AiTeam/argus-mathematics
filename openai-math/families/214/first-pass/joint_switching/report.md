# Code-free joint undo for separated switching histories

## Scope and retrieved source facts

The target is the assertion at `amplification.tex:433-435`:

> We claim that, at fixed $z_1,z_2$ and all seeds, joint undoing is injective
> without retaining either code.

All manuscript locations in this report refer to
`research/openai_manuscript/Nonuniqueness-of-percolation-on-nonamenable-quasi-transitive-graphs-September-24-2026/build/sections/amplification.tex`.
The manuscript is not modified.

The defining rules have been read, not inferred from the target assertion:

* `amp:splicing-section`, lines 151-184: the entire old trajectory is
  determined from the auxiliary input fields, the endpoint, and the old-map
  seeds. At each switch choose the largest eligible index whose whole old
  cluster meets the current root set. Subsequent indices must be larger.
  The inserted piece is the component of the indexed endpoint in the old
  field with the current root set deleted. Choose a contact using its fixed
  priority ordering and contact uniform. Exchange that contact and every
  edge incident to the piece with both endpoints outside the current set.
* `amp:splicing`, lines 186-216: the inserted pieces form a chain with
  single bridge seams. This supplies the geometric interpretation of a
  valid inverse; it is not an assumption that replay is stable.
* `amp:coding`, lines 224-277: a code records selected indices and positive
  bridge gaps. A valid code is checked by undoing its masks and replaying
  the old rules and the original greedy procedure. Fresh contact uniforms
  are integrated, whereas old-map seeds and contact priorities are fixed
  during inverse reconstruction.
* Lines 279-295 localize successful comparisons to a deterministic finite
  bit space. A capped test must stop on exceeding its cap. Thus finite
  graph statements need no assumption about the behavior of an unbounded
  exploration.
* `amp:second-moment`, lines 411-493: the two hanging sets must be disjoint
  and nonadjacent in the **underlying graph**, not merely disconnected by
  open edges. Both inverse families share one distinguished output field.
  Joint restoration must retain the auxiliary fields, all seeds, and the
  fixed endpoints, but not the inverse codes.

The proposed virtual replay deletes the other hanging set from every
current root set. The necessary obligations are equality of the greedy
index, slit component, contact list, chosen contact, exchange mask, and
stopping decision. None of these equalities is being assumed as a replay
axiom.

The probability conclusion sought here is finite Bernoulli-product-weight
preservation **and** injectivity. Conservation of the total number of open
bits alone is insufficient. Independence is used only in the unrestricted
reference experiment after this comparison, as the manuscript specifies.

No external theorem is needed for this finite combinatorial core. Weighted
mass transport, critical finiteness, goodness, the scale selection, and
trajectory-hit bounds are downstream dependencies, not conclusions of this
audit. The supplied cross-campaign Wiki index has no entry matching
percolation, this manuscript family, or joint replay. No new literature
claim or novelty claim follows from that negative local lookup.

## Coverage limits

A no-collision search, a generic swap identity, and a proof conditional on
replay stability do not settle this assertion. No such result will be
reported as a refutation or universal verification. A counterexample in a
stronger finite abstraction would require an admissible realization before
being attributed to the manuscript.

The independent Reviewer has not yet assessed this work. Verification of
this dependency cannot by itself establish the second-moment bound, the
efficient-map proposition, critical operator boundedness, or the full
nonuniqueness conjecture.

## Universal recovery theorem

Fix a graph, two endpoints, and all old-map and contact seeds. Suppose
two valid nonempty switching inverses have the same distinguished output
field. Denote their hanging sets by `H1,H2`. If these sets are disjoint
and no underlying edge joins them, the complete jointly restored bit
tuple uniquely determines the common output, both auxiliary output
families, both actual greedy switching histories, and both inverse
codes. For every finite localization and every Bernoulli parameter
`0 <= p <= 1`, this map preserves each tuple's product weight.
Consequently it compares the entire separated coded mass with the
unrestricted reference product experiment without a code-multiplicity
factor.

The theorem does not need cluster goodness, bounds on the number or size
of pieces, unimodularity, criticality, or a heavy tail for its
injectivity conclusion. Those conditions are used elsewhere. The
formal version even permits edge-labelled multigraphs and replaces a
single open attachment edge by the weaker condition that all open
boundary edges of a hanging set have one exterior endpoint.

### Single-inverse bridge

Here is an independent justification of the geometric interface used
by `SingleValid` in the formal theorem. It does not assume the joint
claim.

At a successful ordinary step, the indexed tip lies outside the current
root set `S`. If it were already in `S` and were not the final endpoint,
the next old cluster would meet `S` and contradict maximality; the final
endpoint is excluded by the stopping rule. The chosen whole old
cluster is connected and meets `S`, so the tip's slit component `B`
has a nonempty open contact list.

Every distinguished edge leaving `S` is closed before the step.
The chosen contact is imported open. All other edges between `S` and
`B` are left untouched and closed. Inside the complement of `S`, all
edges incident to `B` are imported from the old field; its internal
connections make `B` connected, and its exterior boundary is closed
because `B` is a whole slit component. Edges internal to `S` do not
change. Thus the new exact root is `S union B`, with the chosen seam
its only open contact with the previous root.

After selecting index `i`, every larger index missed the entire
pre-switch root. Its original auxiliary field is still unchanged,
because indices only increase. The next selected whole cluster
therefore contacts the enlarged root through the newly inserted piece
only. Repeating this argument gives the chain of pieces, with no later
open bypass of an earlier seam. In particular their union `H` has
only its first open seam to the original root. The final root is the
disjoint union of the original root and `H`; a nonempty run's endpoint
lies in `H`.

All forward operations are literal two-coordinate swaps. Applying the
recorded masks in reverse reconstructs the original bit tuple,
including every original auxiliary field. With the fixed seeds that
tuple determines the entire original old trajectory, which is exactly
the decoder in `Rules.chain`; the successful-chain predicate records
its original successes. This proves every field of `SingleValid` for
the actual manuscript inverse. It introduces no extra replay
hypothesis.

The kernel checks the recovery theorem **on this explicit geometric
interface**. This paragraph's translation from the manuscript's raw
program to that interface, including its ordinary single-inverse
geometry, remains a prose proof for independent review. This boundary
is intentional and is recorded in `statement_fidelity.md`.

### Joint root and physical fields

Every mask edge touches its inserted piece, including the seam.
An edge cannot touch both `H1` and `H2`: the sets are disjoint and
underlying-graph-nonadjacent. Therefore the two families of masks have
disjoint edge support. Swapping the other family changes neither the
first restored auxiliary family nor any bit on its support. Both
original old chains are recovered from the joint tuple.

Write `R` for the common output root. Each single inverse restores
`R minus Ha`. The root of the joint tuple is exactly
`R minus (H1 union H2)`. For connectivity, erase every excursion of
an output-open path into a hanging set by collapsing that excursion
to its unique exterior attachment vertex. Apply this successively
to the two sets. The resulting path to any remaining vertex stays
in the complement of both sets, where no bit has changed. For the
boundary, an edge into `Ha` has its corresponding single-restoration
bit and is closed; other exterior edges retain their closed output
bits. The formal theorem `joint_root` proves both inclusions by
these path and boundary arguments. It does not postulate the
joint-root identity.

### Adaptive virtual replay

Consider the first original run with current root `S`, and delete
`T=H2`. Its originally selected seam has a piece-side vertex in
`H1`. The other endpoint cannot lie in `T`, by graph nonadjacency.
The original selected cluster therefore still meets `S minus T`;
all larger eligible clusters still miss it, since they missed `S`.
The greedy index is unchanged.

A path enlarging the original slit component after deletion of `T`
would have a first vertex in `T`. The preceding vertex belongs to
the original slit component, hence `H1`, contradicting graph
nonadjacency. The slit component is unchanged. No incident edge of
that piece touches `T`, so both its entire open contact list and its
entire exchange mask are unchanged. The fixed priority and uniform
then select exactly the same contact. This argument concerns the
entire masks, including closed edges; open-edge nonadjacency would
not suffice.

The next current root is again the original next root minus `T`.
The stopping tests agree because the first endpoint belongs to
`H1`, not `T`. Induction proves the same complete history, including
indices, pieces, contacts and masks. It does not matter whether an
unused whole old cluster meets `T`, or the original `y0` belongs to
`T`. Both situations occur in the executable regression cases.

Repeat with the second family. The virtual runs are unique: two
different maximal eligible indices contradict each other's
maximality; once the index is fixed, the component, seeded contact
and mask are fixed. Hence the joint tuple recovers both histories.
Inverting the two reverse swap sequences now recovers the complete
common output. The bridge-gap code has no residual freedom:
at a fixed output and endpoint, the separating bridges have one
order from endpoint toward root, and the recovered selected seams
determine their positive gaps. `code_free_joint_undo` formalizes
this conclusion for every deterministic history encoder, so it
does not assume the code encoder itself is injective.

### Product comparison and the reference event

There are `N=(1+2k)|E|` localized Boolean coordinates. Every swap is
a coordinate transposition, so it preserves the total number `a`
of open coordinates, even though its mask was chosen adaptively.
The exact tuple weight is `p^a (1-p)^(N-a)`.
`bernoulliWeight_eq_product` also identifies this expression with
the coordinatewise Bernoulli product, including `p=0,1`.

The proved injection, not weight conservation alone, permits summing
these weights without multiplicity. For any finite coded domain
the sum equals its image's weight and is at most the weight of an
unrestricted target event containing that image.

In the jointly restored tuple both decoded old chains are still
successful. Each trajectory hits the restored root: its first
virtual seam is a genuine open contact to that initial root, so
the corresponding whole old cluster meets it. Also
`A00 = A1 minus H2`. If `n <= |A1| < 2n` and `|H2| <= v`,
then `n-v <= |A00| < 2n`. The formal theorem
`bernoulli_reference_comparison` **derives** these image
conditions, and sums over every reference tuple with just these
conditions. It does not condition the switched output families to
be independent.

Multiplying by the source factor `1/n^2` preserves the inequality.
Integrating the pointwise-in-seeds inequality against the independent
seed law does too. After localization the sums are finite, so this
uses only finite-sum linearity and monotonicity of integration.
The two auxiliary families are independent in the target reference
product law, which is exactly where the manuscript subsequently
squares its trajectory-hit bound.

### Finite localization and dependency consequence

The original successful chain connects an endpoint to `A` in at
most `kM` edges and `A` has fewer than `2n` vertices. The old rule
has a fixed query radius. Capped whole-cluster and goodness tests
expose their boundary or stop on exceeding the cap. A deterministic
larger ball therefore contains all possible successful endpoints,
queries, boundary tests, masks and inverse checks.

The finite edge universe must include boundary edges and their
endpoints, not merely the open edges. A root of size less than
`2n` cannot reach the boundary of a ball whose radius is larger
than that size; otherwise its connecting path alone exceeds the
size bound. The same observation applies to capped auxiliary
clusters from their bounded-distance starting points. Conditioning
on the exterior bits then gives the exact finite model. Virtual
replay introduces no new trajectory or mask, as proved above, so
the same localization works for recovery.

This resolves the code-free-injection and reference-product
comparison dependency at lines 433-493. In particular the
separated contribution need not carry `W^(2k)`. The later
trajectory-hit estimate, its transport proof, the scale-bin bound,
the other two second-moment classes, and every later percolation
conclusion remain outside this certificate.

The explicit downstream chain is `amp:second-moment` to
`amp:efficient-maps` to the neighboring `moments.tex` proposition
`mom:critical-moments` (lines 139-145), whose conclusion is
`sup_v E_pc s_v^alpha < infinity` for every `0 < alpha < 1/2`,
and then to the full operator argument. None of those downstream
nodes is marked proved by this work.

## Evidence classification and review boundary

The mathematical deliverable is a universal recovery and comparison
theorem with a Lean formalization of its adaptive core, physical
joint restoration, and finite probability comparison. The Python
examples are exact regression checks of the manuscript's forward
and bridge-gap inverse semantics, not an exhaustive search and
not the reason the universal assertion is accepted.

The Jacobian bridge-block operation on a seven-vertex example is
only an auxiliary geometry check. Its dedicated JSON discovery,
contract, payload and typed output preserve server version 0.14.0
and protocol 2025-11-25. It supplies neither a collision nor
universal evidence.

No false assertion of the staged manuscript has been identified in
this node, so no `F_AMP_JOINT_UNDO` refutation judgement is warranted.
No claim of a new proof of nonuniqueness, or of verified mathematical
novelty, is made. The improvement over the supplied untested
hypothesis is a derived adaptive replay theorem and machine-checked
finite comparison, not a larger finite no-collision bound.
Independent manuscript-fidelity, significance, and novelty review
remain pending.

## Reproduction

From the campaign root run:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/joint_switching/verify.py
```

This replays three exact seeded examples, including skipped old
indices, `y0` in the other hanging set, two open contact choices, and
overlapping masks within one family. It reconstructs the literal
positive-bridge-gap codes and checks each by original forward replay.
It checks complete bit tuples and rational Bernoulli products, not
only the distinguished root. A closed underlying cross edge is
explicitly rejected by the separation test.

The script then invokes the official `lean_evidence verify` with
`--claim C_AMP_JOINT_UNDO`, the actual source and fidelity document,
and the campaign root. The installed CLI accepts the source as a
positional argument. The compiler result, axiom audit, claim-bound
archival certificate, and both campaign-local official check results
are recorded in `exact_certificate.json` and the official artifacts
beside `Main.lean`. A finite regression pass without a successful
compiler run cannot produce the script's verified status.

The geometric interface is still the separate fidelity obligation
described above. A successful script run does not impersonate an
independent Reviewer. The two uncited internal assumptions recorded
on the *whole* second-moment claim concern the other classes,
transport, and scales; the official citation status found no
blocking citation lookup on this core theorem.

## Recorded outcome

The end-to-end run completed on 2026-11-05 at 18:05:01 UTC with
exit code zero. Lean 4.31.0 and its official axiom audit both
exited zero, with `proof_holes=[]`. The two principal declarations
depend only on the standard axioms `propext`, `Classical.choice`,
and `Quot.sound`; no user axiom is present. The official
claim-bound certificate is
`certificates/C_AMP_JOINT_UNDO-95ab782aa0860fb2.json` beside this
report. All three literal forward/inverse regressions passed.

Both official structural checks exited zero against the exact
campaign root
`campaigns/9000214`.
The generated `exact_certificate.json` records those measured
results and the complete compiler answer. Independent review is
still pending, especially the single-inverse manuscript-fidelity
bridge and the significance of this independent formal
certification. No Reviewer acceptance or verified-new novelty
verdict is claimed.
