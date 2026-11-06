# A missing left-endpoint hypothesis in boundary-cursor rollback

## Assertion and scope

The September manuscript, `build/sections/finite-rules.tex`,
Lemma `fr:rollback`, lines 580-581, says:

> A boundary-cursor region can always be released inside its acquired interval.

Taken to include the truncated regions explicitly permitted at word ends, this
sentence is false. The counterexample below concerns this unqualified sentence,
not the preceding assertion about a **complete** full-head region.
If "boundary-cursor region" is instead defined to include the known first
position, the example identifies an omitted hypothesis, not a counterexample
under that stronger interpretation.

This is a scope correction, not a refutation of `fr:faithful`,
`fr:token-normalization`, the hierarchy proposition, or either group theorem.
In particular, an interval between two actual cuts has a left endpoint that
the example lacks. No publishability or novelty claim is made for this erratum.

## Parameter-uniform witness

Fix any legal sufficiently large parameter of the manuscript, with
`D >= 2`, `c = 10000`, `q = 2^h`, `cDh <= q`, and `q >= 3`.
Use the one-letter word consisting of this letter:

| Field | Value |
|---|---|
| Structural type | `C(2)` |
| Transaction marker | `B` |
| Intended block count `l` | `1` |
| Task `tau` | `rep` |
| Relative block number `b` | `1` |
| Committed side | `0` |
| Data slots zero and one | `0`, `0` |
| Certificate bit | `0` |
| Verifier phase and reading bits | absent |
| Palette-checker fields | absent/idle, as required for a core cell |
| Other and unused fields | zero |

These are named fields of the manuscript's bit-string alphabet. This specifies
a letter independently of the unprinted choice of their disjoint physical
slots. The witness is a family at every legal sufficiently large parameter;
it does not assert that a guessed numerical parameter exceeds the unspecified
fixed-point threshold `h_0`.

The data slots exist since `2 <= cDh`. The metadata are in range and a boundary
cursor has a committed-side bit but no verifier control or registers. The
letter is neither at its known first position (`C(1)`, `b=1`) nor its known
last position (`S`, `b=l`). It is not a forbidden endpoint wing marker. The
word has no neighboring pairs. Both the structural and transaction syntax
expressly leave missing word-end neighbors unchecked.

It is the length-one truncated `L*B` boundary-cursor region with no `L` cells.
No reachability-from-acquisition premise is part of the unqualified assertion.

## Complete exclusion of replacements

Every elementary replacement has positive length and preserves length. A
replacement supported in a singleton must therefore be unary. The complete
list of possible unary sources is:

1. Cursor creation or its inverse: idle or `B` at `C(1)`.
2. Boundary/full conversion or its inverse: `B` or `F` at the known last
   position, which has structural type `S`.
3. Reading-tour entry, turn, or exit; either gate direction; undo-tour entry,
   turn, or exit; interclause edges; the success interface; and a committed-side
   change: all have marker `F` on both sides.

All palette replacements and all other acquisition, release, and transport
moves are binary. There are no additional elementary entries at lengths
`3,...,k` at a legal large parameter. Semantic zero declarations do not remove
or add any replacement edge.

The letter `B` at `C(2)` matches none of the unary sources, in either
orientation. Its replacement component is therefore the singleton consisting
of itself. In particular it cannot reach idle data, even if an operation outside
the alleged acquired interval were desired: the whole word has only one cell.

## Nonzero premise, independently of rollback

The letter satisfies all unary formats and none of the unary semantic zeros:
the endpoint zeros require `R` or `L`, the register/gate/success zeros require
`F`, and the passed-color zero requires a palette cell. There are no pairs on
which to apply a binary zero.

There is also a direct algebra certificate that does not assume rollback or
faithfulness. Over any field `K`, map this single alphabet letter to

```
N = [[0, 1],
     [0, 0]]
```

and every other alphabet letter to the zero matrix; map the identity to the
identity matrix. All relations of length at least two evaluate to zero because
`N^2=0`. There is no unary zero or unary replacement involving the chosen
letter; every other unary relation evaluates to zero on both sides. Thus this
map factors through the presented algebra. The chosen letter maps to the
nonzero matrix `N`. The witness is consequently nonzero over every field.

This establishes a nonzero, locally legal, irreleasable truncated
boundary-cursor region for all legal sufficiently large parameters, not a
bounded failure to find a release.

## Minimal repair and the remaining core

Add the hypothesis that the boundary-cursor region contains its known first
position and its entire acquired prefix. In a syntactically admissible such
prefix, every cell before the cursor is `L`. The inverse acquisition on the
last `L,B` pair decreases the number of acquired cells by one, transports the
side bit to the previous cell, and restores the selected data on the released
cell. Induction reaches `B` at `C(1)`; inverse creation then releases it.
All these operations stay within the prefix. This proves the corrected
boundary-cursor assertion without assuming verification soundness.

The counterexample does not obstruct that induction for cut intervals:
`fr:token-normalization` starts its transaction at `C(1)` with `b=1`.
The open, substantive obligations remain preservation under arbitrary
clean-start interleavings, complete-region verifier rollback for forged states,
and isolated normalization for every nonzero consecutive-cut interval.

## Machine-checking boundary

`verify.py` checks the source passages, every unary-source category, every
relevant zero category, the witness fields, and the exact matrix certificate.
`Main.lean` proves a parameter-uniform isolation/nonzero/nonrelease theorem in
an explicitly described **overapproximation**: arbitrary length-at-least-two
rules are allowed, and all full-head unary control changes and zeros are
allowed. These enlargements cannot help a singleton boundary cursor.
`statement_fidelity.md` states the precise translation and the manual
source-exhaustiveness obligation. This is not a formalization of the entire
hierarchy or an unconditional formal proof of either target lemma.
