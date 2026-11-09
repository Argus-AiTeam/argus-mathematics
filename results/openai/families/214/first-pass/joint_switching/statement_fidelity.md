# Statement fidelity: code-free joint undo

## What is encoded

`Main.lean` imports Mathlib under Lean 4.31.0. Its namespace is
`JointSwitching`. The principal declarations are
`code_free_joint_undo` and `bernoulli_reference_comparison`.
There are no user axioms, admissions, or assumed replay/injectivity
hypotheses. The final axiom printouts audit both declarations.

The combinatorial part quantifies over arbitrary vertex and edge types
`V`, `E`, a natural number `k`, and endpoint maps `Geometry.left/right`.
An edge has its own identity: parallel edges are allowed. Open adjacency
uses either orientation of an edge whose Boolean field bit is true.
`Reach` is a finite open path avoiding a specified vertex set;
`component` is exactly the resulting slit component, not a supplied
component oracle. No bound on a search is used.

`Rules` fixes both endpoints, the old-map seeds through a deterministic
whole-chain decoder `chain`, the successful-chain predicate `success`,
and contact seeds through `choose`. Each decoder reads only its family's
restored auxiliary input fields, never the distinguished field. A
contact selector can be any deterministic function of the indexed
contact set. This includes fixed priority orders and fixed fresh
contact uniforms. Invalid seeds or failed chains are outside the valid
domain, not silently declared successful.

Indices `Fin k` are zero-based; source index `i` is formal index
`i - 1`. The initial eligibility lower bound is zero, and selecting a
formal index advances that bound to its value plus one.

`Step` is the relational semantics of an actual successful switch:
the endpoint is not already in the current root set; the selected
index is eligible and maximal among whole old clusters meeting that
set; its indexed tip is outside the set; its piece is the actual slit
component; its contact is the seed-selected member of the actual open
contact list; and its mask is precisely the chosen contact together
with all incident-piece edges whose endpoints are outside the current
set. `ValidRun` repeats these steps until, and only until, the endpoint
is in the current set. A `Move` records index, seam, piece, and mask.
These records are constrained by `Step`; they are not free decorations.

`component_strip`, `contacts_strip`, `mask_strip`, `Step.strip`, and
`ValidRun.strip` **prove** stability under deletion of the other hanging
set. `Step.unique` and `ValidRun.unique` prove determinism from
maximality and the fixed seeds. They do not assume a replay map or a
stable sequence of selected indices.

## Physical inverse domain and its manuscript interpretation

`Bits E k` has one distinguished field and two families of `k`
auxiliary fields, all on the same edge set. `flip`, `swapBits`,
`forward`, and `undo` implement genuine swaps of the two bit
coordinates on each recorded mask. `jointUndo` reverses the first
history and then the second. Its result contains only bits; neither
history, either code, nor a hanging-set label is appended to it.
Endpoints and seeds remain fixed parameters.

`SingleValid` makes explicit the ordinary single-inverse invariants:
the original input is `undo` of the output; the decoded old chain
succeeds; the original greedy run is valid; the original root is the
output root minus the inserted pieces; the endpoint lies in their
union; and that union is hanging. Here `Hanging` means all open edges
from the union to its complement have the same exterior endpoint.
This is weaker than the manuscript's single open first seam.

These are not new restrictions on the manuscript's valid inverses.
Their independent derivation from its switching rule and
`amp:splicing` geometry is given in `report.md`, under "Single-inverse
bridge". The kernel theorem takes these geometric single-inverse
invariants as the definition of its admissible inverse domain; it does
not formalize the manuscript's text parser, capped old-rule program,
or the derivation of all those single-inverse invariants from that
program. Reading that bridge is a statement-fidelity obligation for
the independent Reviewer, not something the compiler checked.

`ValidPair` requires two such valid inverses of a common output, and
`Geometry.Separated` requires both disjointness and absence of an edge
of the **underlying graph** between their inserted unions. Absence of
an open edge would not satisfy it.

The following facts are proved inside Lean, not added to `ValidPair`:
mask support and disjointness consequences; restoration of both
auxiliary families; the exact jointly restored root
`root(output) \ (H1 union H2)`; the virtual runs from that actual root;
their uniquely recovered histories; and reconstruction of the entire
common output bit tuple. `Reach.erase_hanging` proves the connectivity
needed for the joint-root formula by collapsing excursions into a
single-attachment hanging set.

## Codes, quantifiers, and conclusions

`EncodedData` adds two values of an arbitrary code type.
`ValidEncoded` requires each to equal a fixed deterministic encoder of
the common output and its actual switching history.
`code_free_joint_undo` proves injectivity on this domain. It first
recovers histories, rather than assuming anything injective about that
encoder. The manuscript's selected indices and positive bridge gaps
are such an encoder: once the output, endpoints, and ordered seams
are known, those gaps have unique values. The finite executable
regressions also reconstruct these literal bridge-gap codes.

`bernoulliWeight_eq_product` proves that the encoded weight is exactly
the product of the Bernoulli factors of all coordinates, including
parameters zero and one. `openCount_jointUndo` and
`bernoulliWeight_jointUndo` prove weight preservation despite adaptive
masks. `bernoulli_product_comparison` combines the proved injection
with finite sums, rather than assuming a multiplicity bound.

The reference-experiment theorem additionally quantifies over finite
vertex and edge types, every real `p` with `0 <= p <= 1`, every finite
set of valid coded pairs, natural numbers `n,v`, original first-root
sizes in `[n,2n)`, and second hanging-set sizes at most `v`.
`bernoulli_reference_comparison` bounds the complete coded source
weight by the unrestricted bit-product experiment restricted only to:
the actual restored root size in `[n-v,2n)`, successful decoded chains,
and each chain's whole-cluster trajectory meeting that root.
`ValidPair.reference` and `ValidPair.root_window` derive these image
conditions; they are not assumed as a replay condition.

No exponential code factor occurs. Multiplication by `1/n^2` and
integration over the fixed independent seed law preserve the
inequality. Those elementary measure operations, the finite
localization in the manuscript, and the identification of canonical
bridge-gap encoders are explained in the report, not formalized as a
full infinite percolation model.

## What this does not prove

This is a universal formal verification of the stated joint-switching
core with the explicit single-inverse geometric interface above, not
a finite search and not a counterexample. It does not formalize or
certify the other second-moment classes, mass transport,
critical finiteness, goodness estimates, efficient-map iteration,
critical fractional moments, operator boundedness, or the full
nonuniqueness conjecture. Compilation verifies the encoded theorem;
the independent Reviewer must still assess its manuscript fidelity
and mathematical significance.
