# Statement fidelity for `Main.lean`

The source imports Mathlib in the host's Lean 4.31.0 workspace. Its namespace
is `Rigidity`. A letter is a pair `(label, sign)` with `sign : Bool`;
`true` means a generator and `false` its inverse. Labels have no assumed
distinctness.

## Universal sign theorem

`admissible p w` checks that the preceding sign or the next sign is positive
at every step and that the final preceding sign is positive.
`Good w := admissible false w` therefore means exactly: `w` is nonempty,
its first and last signs are positive, and it has no adjacent negative
signs.

`good_of_red` quantifies over every type of labels, every pair of finite
words, and every `FreeGroup.Red` derivation, and proves preservation of
`Good`. `FreeGroup.Red` is Mathlib's reflexive transitive closure of deletion
of adjacent letters `(a,b),(a,!b)` at any position. This is the actual
free-group cancellation relation, not deletion in a commuting monoid.
`good_reduce` specializes this theorem to Mathlib's computable maximal
reduction when the label type has decidable equality.

`block a pairs` represents every original expansion term of
`z(z*z)^d`: its first letter is `(a,true)` and each list entry `(i,j)`
adds the two letters `(i,false),(j,true)`. The length of `pairs` is
arbitrary. `ordered bs` concatenates an arbitrary finite ordered list
of these blocks; no factors are commuted.

`ordered_reduction_endpoints` quantifies over every label type with
decidable equality and every nonempty block list. It proves that the
maximal free reduction is nonempty and has a positive first and last
letter, expressed by explicit list decompositions. `ordered_good` and
`good_reduce` additionally establish the stronger `Good` invariant.
There is no bound on block count, block length, or alphabet size.

## Universal coefficient-fiber theorem

`insertPair w i a b` inserts the inverse pair `(a,b),(a,!b)` at a cut
of `w`. `insertions L w` allows all `L+1` cuts indexed by `Fin(L+1)`,
all labels `Fin r`, and both signs. A cut beyond the end simply
inserts at the end; these duplicates only enlarge the enumeration.
`expansions L p w` enumerates `p` successive such insertions.

`red_mem_expansions` quantifies over all natural `r,L`, all words `u,v`
over `Fin r`, a proof of `FreeGroup.Red u v`, and the bound `|u|<=L`.
It proves the existence of `p` with `|u|=|v|+2p` and membership in
`expansions L p v`. Thus coverage of arbitrary cancellations is proved,
not imposed as a hypothesis about a guessed matching.

`reduction_fiber_bound` quantifies over all natural `r,L,p`, every finite
set `T` of original words, and every target word `w`. Its hypotheses are
`L=|w|+2p`, `|u|=L` for every `u in T`, and `FreeGroup.Red u w` for every
`u in T`. Its conclusion is

    |T| <= ((L+1)*r*2)^p.

No reducedness of `w`, sign pattern of `u`, or distinctness of original
labels is required. In the application, assignments of the original
unsigned labels for a fixed sign pattern correspond bijectively to
distinct original words, so this is a bound on coefficient multiplicity.
After multiplication by `r^(-L/2)` it gives the required power
`r^(-|w|/2)` with a constant depending only on `L`.

The source does **not** prove the sharper `3^L` matching constant.
That constant has a separate noncrossing-code proof in `report.md`.
The insertion bound suffices independently for the limiting argument.

## Universal repeated-survivor theorem

`collisionSlice_card` proves that functions `Fin q -> Fin r` equating
two distinct fixed coordinates number at most `r^(q-1)`, by restriction
to all but one coordinate. The equal-coordinate slice is deliberately
empty. `repeated_labels_count` takes the union over ordered coordinate
pairs, proving the upper bound `q*q*r^(q-1)` for noninjective functions.

`signed_repeated_labels_count` includes all independent Boolean signs
and proves that the number of signed strings with repeated unsigned
indices is at most

    2^q * (q*q*r^(q-1)).

It quantifies over all natural `q,r`, including zero. The exponent is
natural truncated subtraction. The noninjective count is zero for
`q=0,1`, so these boundary cases cause no false exception.
The theorem counts all signed strings, a superset of reduced strings.
It uses `q^2` rather than the sharper `binomial(q,2)` in the report.

## What this source does not certify

The source has no von Neumann algebra, trace, norm, linear map, Haar
family, or operator-valued limit. It does not formalize the length
inequality, scalar coefficient normalization, Catalan moment calculation,
zero spectral mass at zero, polynomial approximation, ultrapower
continuity, finite-trace compression, or the conclusion `a=b`.
Those steps are mathematical proofs in `report.md`, awaiting independent
Reviewer assessment. Consequently a compiler success supports the
combinatorial claim `C_BLOCK_CORE`, not a kernel proof of `C_RIGIDITY`
or the full Kadison--Ringrose conjecture.

The source uses no `sorry`, `admit`, new axiom, or `native_decide`.
The printed axiom reports for its principal declarations use only
the ordinary Mathlib foundations `propext`, `Classical.choice`,
and `Quot.sound` (the endpoint theorem needs only `propext`).
