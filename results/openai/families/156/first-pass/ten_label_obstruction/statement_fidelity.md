# Statement fidelity: the exact abstract ten-label obstruction

The declarations described here are in namespace `TenLabel` in `Main.lean`.
The principal claim is `C9000156_COMB`, not the continuum projector-cover
theorem. The source uses no `sorry`, `native_decide`, `bv_decide`, or newly
postulated axiom.

## Objects and quantifiers

The labels are positions zero through nine of a ten-bit mask. Adding one to
each position gives the manuscript's labels. `allMasks k` filters every
integer in `List.range 1024` by its ten-bit population count. It therefore
represents every label subset of cardinality `k`, not a sample.

`facets`, `triangles`, and `pairs` are explicit, increasing lists of masks.
The three `*_complete` theorems identify them with `allMasks 4`, `allMasks 3`,
and `allMasks 2`. `row_shapes` includes their respective lengths 210, 120,
and 45. There are no repeated masks because the defining range is increasing.

An arbitrary `a : Nat -> Bool` encodes a family by its values at indices
0 through 209, in `facets` order. Values at indices 210 through 329 encode
the triangle indicators in `triangles` order. All other values are irrelevant.
Every family of four-subsets and every triangle indicator have such an
assignment. The theorem quantifies over all these assignments, without
symmetry breaking, a facet-count cutoff, or a completeness assumption on the
one-skeleton.

## Incidence data and the exact predicate

`subset a b` is the mask subset test. The following are kernel-checked
equalities, not assumed encoding or transport lemmas:

- `incidenceRows_complete` identifies each triangle's row with exactly the
  seven facet indices containing it.
- `complementRows_complete` identifies each facet's row with every ordered
  pair of complementary triples in its six-label complement. Both orders
  occur because the definition tests every triple.
- `pairRows_complete` identifies, for each pair in each facet complement,
  exactly the four triangle indices containing that pair there.

`row_shapes` checks every row count and row length. `row_indices` checks
every facet index below 210 and triangle index below 120.

`gates` is the concatenation of the nonempty gate, all incidence-row gates,
all parity gates, all complement-row gates, and all pair-row gates.
`model a` requires the Boolean evaluation of every entry to be true.
Its five kinds of constraint are:

1. `.nonempty`: at least one of the 210 facet bits is true.
2. `.down`: a triangle bit equals the disjunction of its seven containing
   facet bits. Thus the triangle indicators are exactly the downward closure,
   not an independently postulated compatible triangle system.
3. `.parity`: the XOR of those seven facet bits is false. This is even
   triangle incidence, including absent triples of incidence zero.
4. `.complement`: when the facet is present, exactly one of each complementary
   pair of triangles is present.
5. `.two`: when the facet is present, exactly two of the four triangles
   containing each pair in its complement are present.

`exactlyTwo_spec` identifies the Boolean test for kind 5 with the sum of four
Boolean indicators being two. The `.bad` evaluation is false, not permissive.
The row lengths checked by `row_shapes` ensure that every `downGate`,
`parityGate`, and `twoGate` has its intended constructor, not `.bad`.
The data checks and gate constructors represent every stated condition.
No triangulation, orientability, connectedness, manifold structure,
admissible map, or manuscript structural lemma is an additional hypothesis.

## Formal proof and computation

`encode_correct` proves the CNF encoding of each arbitrary gate equivalent
to its Boolean semantics. Its finite Boolean cases are ordinary kernel
proofs, not solver axioms. `disj a c` is the disjunction of the equalities
`a i = b` for the literals `(i,b)` in `c`; its empty case is `False`.
`disj_correct` proves equivalence with Boolean clause evaluation.
`encoded_consequence` therefore derives each encoded clause from its gate.

The five `*_member` lemmas prove that an actual gate belongs to `gates`,
using precisely the relevant original row membership. The generated `gate_*`
theorems instantiate these lemmas. Every selected input clause is then proved
from its actual gate and kernel-checked membership in that gate's encoding.
There is no assumed table-to-formula or clause-selection transport lemma.

`Inputs a` is a conjunction of 19,189 such input clauses, in the order of
`core_indices.json`. The `ib*` blocks and `inode*` declarations merely share
this conjunction in a balanced tree; they impose no extra mathematical
conditions. `model_entails_inputs` proves `model a = true -> Inputs a`.
Removing unselected clauses weakens the formula, so refuting this conjunction
refutes the entire model without imposing an extra hypothesis on the family.

`core_refutation.lrat` contains 4,695 additions and 113,449 propagation hints.
The Python generator is untrusted preprocessing: it reconstructs ordinary
Lean declarations, not a native-evaluation certificate. Each `input_*`
theorem projects one clause from `Inputs`. The generic `unit_*` and
`conflict_*` lemmas use only disjunction elimination. `flip_false` proves that
opposite Boolean equalities are inconsistent.

Each `step_*` theorem negates its proposed disjunction, propagates using
earlier proved clauses and these generic lemmas, and derives a contradiction.
The last step has conclusion `disj a []`, definitionally `False`.
`core_unsat` consequently proves `not (Inputs a)` for every assignment,
independently of `model`. Composing it with `model_entails_inputs` is the
entire obstruction proof. No SAT answer, LRAT-parser result, symmetry
argument, or unproved transport theorem is a logical assumption.

The closed mask, row, and membership checks use `decide +kernel`.
All propagation steps are explicit kernel-checked logical proofs.
Large constant data are marked `noncomputable` solely to skip unnecessary
native code generation; their kernel-reducible definitions are unchanged.
There is no native-evaluation oracle, `cbv` certificate, newly introduced
native-result axiom, or reliance on the timed-out whole-checker approach.
Standard Lean foundations such as propositional extensionality, choice,
and quotient soundness remain the usual foundations.

## Conclusion and limits

`no_nonempty_good_family` states, for every `a : Nat -> Bool`,
`model a = false`. `no_model` states that no assignment has `model a = true`.
These exclude precisely a nonempty four-uniform family with even triangle
incidences and the specified six-label systems on every facet complement.
Equivalently, any family satisfying the two conditions is empty.

The kernel checks the encoded theorem, not this interpretation document.
Independent statement-fidelity review must check the mask representation,
quantifiers, conditions, and the reading above.

These declarations do not prove the cover-to-map reduction, the equality-case
facet-cycle theorem, or the map-to-complement-system implication. They do
not prove Borsuk's conjecture false in dimension nine. They make no novelty
or independent Reviewer acceptance claim.
