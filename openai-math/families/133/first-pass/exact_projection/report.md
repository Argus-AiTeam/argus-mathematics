# Exact projection for compressed Weisfeiler--Leman constructions

## Scope and source findings

The question is whether **every selected retained offset** extends to every
larger permitted block set, with exact restriction in both directions. It is
not whether some compatible list exists, and it is not the assertion that all
compatible lists extend.

The variable-dimension source is
`research/openai_manuscript/Variable-dimension-Weisfeiler-Leman-equivalence-on-general-and-subcubic-graphs-September-25-2026/build/sections/04-blocks-projection.tex`.
Its Proposition `prop:exact-projection` starts at line 171 (label at 172);
the explicit universal interpretation follows its statement. The fixed-dimension
source is
`research/openai_manuscript/Unconditional-time-lower-bounds-for-Weisfeiler-Leman-equivalence-September-25-2026/build/sections/02-compression.tex`,
Lemma `comp:projection` at line 390, with its family construction in the
preceding subsection.

Both use r >= 3, at most r+1 blocks, binary vector values, and 4(r+1)
private internal types per wire. The variable-dimension version has binary
address coordinates and real value dimension one or two. The fixed-dimension
version permits any finite address alphabet [m], m >= 2, and arbitrary fixed
finite real value dimensions.

Individual scalar-image consistency is strictly weaker than global
satisfiability. In particular, witnesses Q can be arbitrary nonempty sets,
endpoint linear forms can vanish, original schemas can be loops or parallel,
and each coordinate injection can be partial. A component containing a real
type does not impose image restrictions on arms whose full address is
unavailable. Restrictions are imposed only by wrapping r-block
subcollections, not by components first wrapping at r+1 blocks.

The source proof decomposes into small tree supports, recovered addresses,
existence and surjectivity of admissible shifts on retained wrapping
components, and a gauge adjustment on every nonwrapping retained component.
The adjustment must be component-wise even when old components share types
or merge after the final block is added.

The pinned checkout contains
`lean/OAI/Combinatorics/VariableWL/ExactProjection.lean`, including
`offsetFamily_exact_projection` and `exact_projection`. This is source
evidence, not a local kernel result. Its transitive dependencies and the
translation from manuscript objects still require checking. The upstream
`lean/docs/133.md` reports broader formalization than the initial
"partially/comparator formalized" campaign label. Intentional comparator
placeholders are outside this mathematical claim and are not refutations.
The Lean source is Apache-2.0 licensed.

The inherited Wiki was searched for Weisfeiler--Leman, scalar-image, and
exact-projection results. No page on this particular projection theorem was
found; a page on a different Weisfeiler--Leman paper is not used as a premise.

## Four-manuscript dependency map

The ledger and proof graph distinguish manuscript assertions from checked
facts. No complexity theorem is inferred from checking the projection core.

| Manuscript | Main assertion | Load-bearing path |
|---|---|---|
| Parity lifts | `thm:choice-reduction`; conditional `thm:eth` | `lem:lift-duality`, `lem:choice-witness`, `lem:extract-choice`, `lem:hom-implies-wl`, `lem:test-detected`, then sparse-SAT grouping |
| Identification | `thm:main` (binary/unary dimension EXPTIME-completeness) | `prop:mate`, `prop:image-consistency`, `prop:exact-projection`, `thm:special-twist`, `prop:acceptance`, `prop:rejection` |
| Fixed dimension | unconditional n^(c k) time lower bounds in the stated sequential models | `comp:reduction` from necessity and exact-projection sufficiency; `circ:simulation`, `circ:computation`, `diag:simulation`, `diag:language` |
| Variable dimension | `thm:main` (general and connected subcubic EXPTIME-completeness) | dimension cap/membership, computation and scalar images, exact projection, general/subcubic realization, game reduction, uniform construction |

Primary locators for the dependency nodes are recorded in the proof graph.
The four-manuscript map is a source decomposition, not independent verification
of those main results. For this bounded mission, the source-level strongest
prior result is an upstream formal proof; a genuinely checked result must add
a real kernel run and a faithful statement, rather than relabel that source
discovery as a new theorem.

## Jacobian scope

The installed isolated bridge reports Jacobian 0.14.0, protocol 2025-11-25.
Discovery and inspection found an exact finite-field rank operation, which
does not decide non-affine image witnesses or the universal family theorem.
The bounded `sat.solve` contract accepts a canonical CNF with at most 1024
variables, 8192 clauses, and timeout at most 10000 milliseconds. It can check
a precisely specified finite extension obligation but cannot prove the
universal theorem. Any SAT assignment will be independently replayed.
UNKNOWN, timeout, transport failure, or incomplete output is a non-conclusion.

## Universal verification theorem

For arbitrary finite address alphabet `Fin m` (including m=0), arbitrary
finite real value dimensions (including zero), r >= 3, and any number n of
private internal types per wire with n > r, individual scalar-image
consistency implies the exact-projection conclusion. Coordinate domains may
be empty. Real types and schemas need not themselves form finite types: the
theorem quantifies over finite active block sets. The manuscript cases use
n=4(r+1), with m=2 for the variable-dimension paper and arbitrary m>=2 for the
fixed-dimension paper.

The theorem produces a single family function U -> H_U for all finite block
sets, not separately chosen families depending on the requested extension.
For every |U|<=r+1 the family is nonempty and consists of legal affine
valuations agreeing on shared named readouts. For every V contained in U,
the image under deletion is exactly H_V.

### Proof

**Small supports and alignment.** A block introduces at most one wire link.
Since n+1>r+1, each wire has a missing link in any permitted active support.
Cut each wire at one such link. The remaining layout is a forest of private
arms attached to real types; every connected support has at most one real
type. A connected support with no real type stays inside a single wire.
Extend each partial coordinate injection to a permutation of the finite
ambient alphabet. This also works for the empty injection. Align internal
labels with the first endpoint before the cut and with the second endpoint
after it. Actual vertical matches preserve aligned labels.

This port proves the permutation identity `alignment_link` directly from
the first/interior/last link cases. In particular it does not use the binary
fact that agreement of permutations at one point implies their equality.
That fact is true for the upstream binary alphabet but would be false for a
general alphabet; it is not asserted or used in the generalized proof.

**Wrapping.** Mark seam horizontals by one and all other edges by zero.
On a closed walk, incidence parity at every boundary implies equal
horizontal parity in every row. A marker-one walk therefore uses at least r
blocks. With exactly r blocks there is one block per row, whose two
horizontal endpoint labels determine its aligned coordinate pair. Incidence
parity separately at each boundary/label forces agreement of adjacent
pairs, hence a unique full address. Any two r-block wrapping subcollections
of a set of size at most r+1 share at least r-1 distinct rows. Every
coordinate has an incident common row when r>=3, so their addresses agree.
In a real-free support every recovered coordinate is an internal allowed
label, and the recovered address belongs to the entire wire domain.

**Admissible shifts.** In a real-free component, link equations identify
all internal scalar shifts. A wrapping r-block witness restricts this
scalar to the nonempty image set D at its recovered address. Without such
a witness any scalar is allowed. In a component with one real type, choose
a vector at that type, restricted to its nonempty Q only if an r-block
wrapping witness exists. Each arm scalar is its corresponding endpoint
affine image. Different arms need not admit the recovered full address,
and no additional image condition is imposed on them. These choices prove
existence without requiring affine Q, nonzero forms, or a global solution.

**A retained wrapping component.** If V is proper in U, |V|<=r. A wrapping
old component uses all r old blocks, so there is at most one. If both old
and new supports contain a real type, the same allowed real vector
parameterizes both. If neither does, the same allowed scalar does.
If the old support is internal but the new support reaches a real
endpoint, its recovered internal address is in the wire domain. Transport
therefore agrees with the actual endpoint coordinate map. Equality of the
individual affine images says that every allowed old scalar has a
preimage in the required real Q. After choosing it, the other arm scalars
are determined. This proves surjectivity of shift restriction, not just
existence of a new shift. The argument treats the two arms of a loop
separately.

**Every nonwrapping component.** Let h and h' satisfy its link equations
and put g=h'+h. Then L_t g_t=L_u g_u on each link. Nonwrapping makes the
marker sum path-independent, so there are bits s_v with
s_v+s_w equal to the edge marker. Replacing the corner potential by
M'_v=M_v+s_v g_t preserves a horizontal readout because its change is
(s_v+s_w+delta_i)g_t=0. On a vertical, s_v=s_w and the change is
s_v(L_t g_t+L_u g_u)=0. These are characteristic-two vector identities;
zero endpoint forms cause no exception.

**Exact restriction and extension.** Restricting a represented large list
restricts its potentials and shifts; a retained wrapping component retains
its admissibility by the shift restriction result. Conversely, fix
**any** selected list in H_V and any representation of it. Choose new
admissible shifts, extending the unique old wrapping shift if one is
present. On each nonwrapping old component apply the gauge adjustment.
The old corner sets are disjoint, even if they share type names or merge
in the new diagram. Thus these adjustments coexist. Assign arbitrary
potentials to new corners. Potential cancellation proves all new square
equations, and every old named readout is unchanged. This gives an
extension of the prescribed list, completing both inclusions.

The Lean declarations `full_projection_certificate` and
`manuscript_projection_certificate` encode this conclusion, including
nonemptiness and shared-readout agreement. `Main.lean` includes the
necessary proof closure from nine upstream modules, under the retained
Apache-2.0 license, without the unrelated machine, refinement, numbering,
or scalar-circuit code. The only import is Mathlib.

## Exact adversarial experiments

`verify.py` constructs the manuscript's actual named readouts, corner
components, r-block wrapping conditions, admissible shifts, and potential
linear images. It enumerates complete selected families for each tested
block set and compares restriction images as sets. This tests **every**
selected retained list, not one representative or nonemptiness alone.
Every enumerated large offset is also checked against every square
equation. The finite experiments do not establish the universal theorem;
the Lean proof does.

The completed replay covers 20 cases and 1,512 exact restriction equalities,
including 51,264 retained-list obligations counted across the tested
(case,U,V) triples. These are finite measurements, not counts of distinct
universal instances or an inference from a bounded search.

The cases use r=3, sixteen internal types per wire, alphabets of size two
and three, and real dimensions two, three, and zero. They cover lifting
from both endpoint occurrences, zero linear forms, a constant loop,
parallel arms with distinct private wires, partial nonidentity injections,
non-affine address-dependent witnesses, an arm whose full address is
unavailable, merging components with independent shifts at a common type,
and a component that first wraps at four blocks without a wrapping triple.
There is also a schema with an empty coordinate domain and unequal
constant endpoint forms: its individual comparisons are vacuous, while its
locally present blocks still require checking.

An additional identity-address loop compares a scalar form with its
complement. Its individual images are equal on the non-affine witnesses,
although no single vector can satisfy the comparison with itself. Thus the
test instances are genuinely globally unsatisfiable, rather than silently
using global satisfiability in place of image consistency. This is **not**
a counterexample to any manuscript assertion.

The bounded Jacobian SAT predicate is a retained three-site ring with
offsets (1,0,0), internal shift one, a two-dimensional real witness
Q={00,01,10}, and the endpoint parity form. Its six variables express the
retained potential equations and an admissible real preimage. New corner
potentials are free; the new square equation follows by cancellation.
`verify.py` compares the CNF with this predicate on all 64 Boolean
assignments and replays the returned satisfying assignment. The initial
request was rejected with `INVALID_REQUEST` because clause ordering was
not canonical (adapter exit 2). That exact payload and error are retained;
they are not mathematical evidence. The inspected canonicalizer fixed
only ordering, after which `sat.solve` returned SAT (adapter exit 0).
Exact successful requests, responses, server version, and protocol are
preserved in the dedicated Jacobian JSON files.

## Result and replay

The native Lean 4.31.0 run succeeded with exit_code=0, proof_holes=[] and
axiom-audit exit code zero. Its archived claim-bound certificate is
`research/exact_projection/certificates/EP-4c4d31c5bc6f8f93.json`.
The exported theorems use only the standard propext, Classical.choice,
and Quot.sound axioms. The failed development compiles remain archived as
inconclusive evidence, not refutations; their issues were conditional-lemma
names and the local port, not manuscript counterexamples.

From the campaign root, replay the exact certificate with
`$WORKSPACE/argus-live-update/.venv/bin/python research/exact_projection/verify.py`.
It checks the complete finite restriction equalities, the source/fidelity
binding of the successful native archive, and the exact Jacobian assignment.
It does not pretend that reading a stored compiler answer is a fresh compile.
For an independent kernel replay, use the `recompile_command` in
`exact_certificate.json`, then run both official campaign-local checks.
Do not edit `Main.lean` or `statement_fidelity.md` during that run.

There are no external mathematical assumptions on claim EP and
`citation_check status` reports no outstanding cited assumptions.
No false assertion of the staged manuscripts has been established.
This closes the universal projection core mechanically, not the four
complexity theorems. Compared with the strongest prior source-level result,
it adds an actual kernel/axiom audit and covers the arbitrary-alphabet,
arbitrary-dimension fixed counterpart in the same formal theorem.
Mathematical priority, publishable significance, and statement fidelity
still require independent Reviewer assessment. This is an Engineer
handoff, not a declaration that the entire campaign has completed.
