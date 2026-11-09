# Statement fidelity: confined Snaky policy

The claim is `C9000187_FINITE_BOARD`. Its main declarations are
`SnakyFinite.fixed_confined_policy` and
`SnakyFinite.finite_board_corollaries` in `Main.lean`.

## Objects and quantifiers

`Cell` is the integer lattice, not a bounded array. `HasSnaky M` means that
`M` contains a translation of one of the eight signed coordinate-permutation
images of the six distinct cells
`{(0,0),(1,0),(2,0),(3,0),(3,1),(4,1)}`.

The six `base` cards use the unshifted shape, as does the staged short
checker. `sourceCode` converts its bit-coded placement convention to the
coordinate convention used by `orient`. Declarations `card6` through
`card727` are direct transcriptions of the
corresponding immutable certificate expressions, including compositions in
nested frames. Each reference names an earlier declaration; there are no
default-card fallbacks. Child vectors store the inline children eagerly.
`cacheCard` normalizes each node's three data fields, retaining the original
validity proof through the equality-transport definition `cached`. Its
metaprogram evaluates the card only to propose finite data. The unsafe
cast reads the runtime-erased multiset wrappers as lists only inside
that metaprogram; it is never applied to a proof, and no logical declaration
depends on `unsafeCast`.
For each representative, a named kernel-checked equality with the original
multiset transports the original distinctness proof through `copyFinset`.
`copyFinset_eq` supplies the finite-set equality. The height equality is also
kernel checked. Native evaluation is not accepted as a proof of any equality
or proposition. No previously proved
infinite-board winning theorem is imported.

`endpoint` asserts that `card727.A` is empty, its height is 21, its actual
envelope has 251 cells, and both coordinates of every envelope cell lie between
0 and 16 inclusive. `T727` is that envelope, not an arbitrary set of the same
cardinality. `verify.py` compares the entire generated certificate suffix in
`Main.lean` to a new parse of the staged text.

`fixed_confined_policy` puts **one** `Policy Cell` outside both the universal
Breaker sequence and the legality hypothesis. A policy takes the remaining
claim budget and the two ownership sets. Its value need not be fresh in
unreachable, already-won, or exhausted positions.

## Legal play, stopping, and the conclusion

`WinIn` is a bounded winning proposition with fresh supported claims.
Its `last` constructor proves victory immediately after a Maker claim and
does not quantify over a Breaker reply. Its `step` constructor requires at
least one further Maker claim. Consequently its zero-budget case can only be
an actual victory; absence of a legal reply is not a last-move proof.

`Forces` strengthens this proposition by using the same fixed policy at every
node. `fixed_policy` proves extraction from `WinIn`.

`Legal` checks a sequence only at replies that are actually requested. It
stops checking as soon as Maker has won and never requests a reply after the
last permitted claim. In particular it imposes no condition on the unused
tail of the sequence, and it never requires Breaker to stay inside `T727`.

`Execution` records an actual early-stopping play. Its nonterminal
constructors require a fresh Maker cell in `T727`, disjoint ownership before
the claim, and a fresh legal Breaker reply. Its `finish` constructor requests
no reply. Its `stop` constructor makes no additional claim.
`Forces.executes` proves existence against every `Legal` sequence.
`Execution.summary` proves the terminal victory, disjointness, confinement,
and exact cardinality increments.

Thus the main theorem gives, for every legal sequence, an execution with final
Maker and Breaker sets `F,G` and actual claim counts `c,d`, satisfying:

- `HasSnaky F`, `Disjoint F G`, and `F` is a subset of the actual `T727`;
- `F.card = c`, `G.card = d`, `c <= 21`, `d <= 20`, and `c = d + 1`.

Freshness is part of every claim in the execution, not just of the final set.
All earlier ownership sets are subsets of the final sets. An already-owned
pivot is handled by a different, fresh envelope cell in `compose_valid`;
this is an ordinary claim and consumes one unit of budget.

## Finite-board interpretation and nonvacuity

`finite_board_corollaries` uses the same policy for every finite superboard
`Q` of `T727`, in particular `T727` itself and `board17 = [0,16]^2`, whose
cardinalities are 251 and 289. The theorem is stronger than restriction to
legal replies in `Q`: it permits all legal lattice replies. Restricting
Breaker to `Q` therefore preserves its conclusion.

The game is not required to run on an exhausted finite board.
`finite_board_has_room` proves a fresh envelope cell exists whenever at most
40 cells in total have been claimed. Before Maker's 21st claim there are at
most 20 Maker and 20 Breaker cells; before any requested reply there are at
most 20 Maker and 19 Breaker cells. Every requested move on either stated
finite board therefore exists. No extra reply after victory is assumed.

## Trust and limits

The generic algebraic, resource-sensitive, and policy proofs use ordinary Lean
proof terms. Every normalization equality is certified by reflexivity
checked by Lean's kernel, or by ordinary `of_decide_eq_true` with a
kernel-checked reflexivity proof when definitional equality does not suffice.
Auxiliary theorems retain these checked proofs rather than recomputing them.
`endpoint` and the 289-cell board count use `decide +kernel`, not
native-computation axioms. The independent Python replay is a second
exact source-data check, not a replacement for the quantified semantic proof.

The compiler checks these declarations, not the English interpretation.
Independent Reviewer confirmation of this interpretation and source binding
is pending. No new 21-move construction, improvement of the move bound,
or refutation of a manuscript assertion is claimed.
