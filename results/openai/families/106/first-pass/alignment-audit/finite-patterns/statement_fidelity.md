# Fidelity of the finite-pattern reduction

The claim is `A_PATTERNS`. This source proves a finite-universe
representative version of the manuscript's occupied-slot argument.
It is a general finite-family theorem, not a bounded experiment.

The indexing type `iota` is any finite type. For the manuscript it can
be the nonempty subsets of `[r]` of size at most `s`; alternatively
one may use all subsets and give excluded indices empty lists.
The label type `M` is completely arbitrary. The only size hypothesis
is `card (A i) <= d` for each indexed finite list.

`finite_relabeling` produces a map

    phi : M -> Fin (d * card iota + 1).

The target size depends only on the number of lists and their size
bound, not on `M` or the particular labels. The proof bounds the union
of all lists by `d * card iota`, embeds that union in the finite
target, and sends unused labels to a default value. The extra one
ensures that this default always exists, including for empty unions.

The conclusion proves all of the following:

- Every list has exactly the same cardinality after relabeling.
- Two relabeled lists are disjoint if and only if the original lists
  are disjoint.
- For any two labels appearing in any indexed lists,
  `phi x = phi y` if and only if `x = y`.
- Alignment on every nonempty target `B` is equivalent before and
  after relabeling, for every chosen subfamily of constraints.

`AlignedFamily A T C B` means a map from the whole label universe into
`B` sends labels on list `A i` into `C i` for each `i` in `T`.
Taking `T` to be all nonempty subsets of a sampled `B`, and `C I = I`,
recovers the exact manuscript conclusion. The arbitrary finite
subfamily `T` makes the equivalence valid after every restriction.
The nonemptiness hypothesis on `B` is precisely the manuscript's
`s >= 1`, not an extra restriction on its application.

`representative_space_finite` establishes that the type of all
families with this finite target is finite. Thus every actual family
has a representative in one fixed finite space preserving all
occupied-slot equalities, lengths, separation, and badness. One may
keep each list's arbitrary slot order when applying `phi`; injectivity
on the used labels preserves that order's equality pattern.

The relabeling may depend on the input lists. This does not change the
sampling quantifiers: a law chosen to work for **every** family in the
fixed finite representative space consequently works for every
original family in every universe. No sampler is constructed by this
file, and no minimax, Ramsey, probability-extension, or invariant-cut
statement is assumed or proved here.

The file introduces no project axioms. Its dependencies are ordinary
Mathlib finite-set cardinalities, finite-type equivalences, images,
classical choice, and function composition.
