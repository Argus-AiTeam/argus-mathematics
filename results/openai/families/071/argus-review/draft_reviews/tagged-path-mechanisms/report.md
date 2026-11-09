# Tagged-path mechanisms

## Sources, attribution and exact scope

The Argus draft is the read-only `9000071/research/tagged_jump_audit/proof.md`,
Sections 1-3, preserved digest
`13bd5180e0de0dda9999506bb95f3aa5e2503003926553b4298a3309b23254ca`.
The original statements are OpenAI's September 23, 2026 Koebe manuscript,
revision `4eaee87548250b2682affda7d05d947c05554bae`,
`build/sections/03-barriers.tex`: `lem:path-stability` (223-233),
`lem:collar-splicing` (403-426), and `lem:jump-removal` (527-542).
The quotient/dust definitions come from `01-topology.tex`; the allowed-path
and per-visit definitions are in `03-barriers.tex` (47-185).
The index contains the exact ledger statements, context hashes, source
revision comparisons and evidence-subject bindings.

The three version-1 claims are:

* **C_PATH_STABILITY:** reversal, affine reparameterization, closed restriction,
  and countable concatenation of restrictions preserve allowedness, provided
  the resulting path is continuous, has finite physical domain length, and
  has only countably many extra parameter times.
* **C_COLLAR:** for fixed path-system data, `g >= c0 > 0`, nonnegative counting
  `ell2` tolls, domain endpoints and costs converging to finite `A`, distinct
  limiting dust endpoints can be joined at endpoint-omitted cost at most
  `A+eta`, for every `eta>0`. The one-ended version requires
  `p notin closure_X(F)`. Dust avoidance is preserved away from the newly
  adjoined endpoints; hit restrictions require joining collars disjoint
  from the hit curves.
* **C_JUMP:** given finitely many old positive-toll jump levels with chain
  lower bound `beta>0`, fixed `rho,tau>0`, and `0<Delta<beta`, **every**
  sufficiently fine new dust-disk cover preserves `beta-Delta` when its
  toll is `max(rho, sup{m(s): dist_X(s,V)<tau})`. Disk closures miss the
  compact domain anchor and target collar.

These are reconstructions/supporting lemmas, not three new counterexamples.
All earlier laws, prior labels, finite deletions and permitted tag exclusions
remain in force. Replacing parameter visits by distinct images, removing
`c0>0`, or allowing an uncontrolled Cantor remainder of concatenation times
would change the statements.

## Decisive argument assessment

**Residual contacts.** The proof first extends the rational closed-interval
tests to open intervals by increasing exhaustion, then adds the two endpoint
times. A discarded constant tag exposes only one image point; countably many
such tags expose a countable image, hence an atomless-null image. In a
concatenation, residual times split into retained residual times, newly exposed
times, and countably many junction/limit times. Singleton incidence bounds and
subadditivity apply after each fixed finite deletion. Summing over the
partition of **times** does not spend the same positive parameter-time charge
twice, even if image points recur. This verifies the actual universal
constraints, not merely a finite example.

**Collars.** First/last cuts on nested smooth collars are in `G`, so they
duplicate no dust toll. Diagonal convergence is used only for cut positions
and nonnegative fragment costs. Every finite sum of limiting fragment costs
is at most `A`, hence so is their infinite sum; no unjustified lower
semicontinuity of the path-cost functional is needed. Actual fragments,
not limiting paths, are joined. Finite `g`-integral on each collar makes
short joining arcs arbitrarily cheap. Enumerating all fragment and joining
errors with allowances `eta/2^(n+1)`, `n>=1`, gives total `eta/2` and tail
`eta/2^(N+1)`. Shrinking disks ensure continuity at the added endpoints,
and `g>=c0` converts finite cost to finite domain length. The one-ended
construction retains an actual prefix from `F`; its closure separation is
essential. Collar arcs in `G` introduce no new dust visits.

**Shrinking jumps.** The common positive lower bound on old jump tolls and
`rho` bounds the number of jumps in any proposed low-cost chain. A fixed
pattern subsequence therefore suffices. If a shrinking disk collapses to
`p`, its fixed-`tau` neighborhood eventually includes `p`, so its limiting
toll is at least `m(p)`. A supremum over the disk alone would not give this
implication, but that is not the stated toll. Equal consecutive junctions
can be collapsed with nonnegative cost discarded. Distinct junctions use
the two-ended collar construction. Outer junctions use the one-ended
construction unless they lie in an old open disk; then truncation at a
nearby physical collar point reconnects the old jump. A dust point cannot
lie on the old disk boundary, since that boundary lies in `G`. The
one-junction/two-anchor intersection case uses density of `G`.

At each retained junction the new visit set has left internal visits,
one identified junction time, and right internal visits. Internal returns
and nonconsecutive repeated junctions are still separately charged.
This is the human geometric bridge to `per_visit_glue`; the Lean identity
does not construct it. Summable block errors below `Delta/2` contradict the
old lower bound. The contradiction proves the quantifier over all
sufficiently fine covers, not just the covers in a finite search.

## Prior review, checks and limitations

Version-matched old Reviewer supports are
`judgement-C_PATH_STABILITY-129c6fe0b13f`,
`judgement-C_COLLAR-fa6da7031af8`, and
`judgement-C_JUMP-877691c539df`. They agree with the present argument reading.
The historical graph's `open` labels and draft's pending-review sentence do
not erase those narrower supports. They also do not make this review accepted.

The existing exact checker replay passed for the infinite error budgets and
scalar junction formula (`research/replay/exact_checker_system_python.json`).
That checks arithmetic, not allowedness, collar existence or the visit-set
decomposition. Those remain human mathematical arguments under the stated
quotient-sphere setup and ordinary integration facts. No concrete invalid
implication was found in these three arguments within that scope; no stronger
concatenation, global manuscript or novelty conclusion is warranted. Current
native independent review is pending.
