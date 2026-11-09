# Statement fidelity: universal exact offset projection

The declarations described here are
`ProjectionAudit.VariableWL.Blocks.full_projection_certificate` and
`ProjectionAudit.VariableWL.Blocks.manuscript_projection_certificate`
in `Main.lean`. Their proof dependencies are included in that same file;
the only import is Mathlib. The original OpenAI theorem is not a hypothesis,
axiom, external binary, or import.

## Objects and hypotheses

`m`, `r`, and `n` are arbitrary natural numbers. `P` and `E` are arbitrary
types of real types and oriented comparison schemas. A
`ProductImages.Instance m r P E` specifies:

* an arbitrary finite vector dimension `dimension p` for every real type;
* arbitrary source and target maps `E -> P`, with equality permitted;
* a finite coordinate domain inside `Fin m` and a coordinate map injective
  on that domain, separately for every schema and coordinate in `Fin r`;
* two arbitrary scalar linear forms on the endpoint vector spaces over
  `Bit = ZMod 2`, together with two arbitrary scalar constants.

There is **no** nonzero-form, positive-dimension, distinct-endpoint,
nonparallel-schema, full-domain, or nonempty-coordinate-domain hypothesis.
In particular, different elements of `E` may have the same endpoints,
forms, and coordinate data, but their internal types remain private.

An address is `Fin r -> Fin m`. `J.Consistent` means there exists a
`J.Witness`. This assigns an arbitrary nonempty **set** of vectors to
each real type and address. The only constraint is equality of the two
individual affine scalar images at every allowed source address and its
coordinatewise mapped target address. Witness sets need not be subspaces,
cosets, convex, or jointly consistent across different comparisons.
For a loop, its two endpoint occurrences may use different vectors from
the same witness set.

The row hypothesis is `3 <= r`. `marked : Fin r` selects a single seam;
the manuscript choice is the last cyclic row. The general theorem assumes
`0 < n` and `r+1 < n+1`. A wire has `n` private internal types and `n+1`
links. The manuscript specialization sets `n = 4*(r+1)` and discharges
both inequalities arithmetically.

## Construction and quantifiers

Corners, named horizontal and vertical readouts, site and square blocks,
and their allowed labels are defined by `Horizontal`, `Vertical`,
`Square`, `Valid`, `HasReadout`, `end0`, and `end1`. A square uses the
same consecutive coordinate matches as in the manuscript. No artificial
new shared readouts are added by meeting at a corner.

`Valuation J marked 1 b` is the affine legal fiber of block `b`.
`LegalValue` is exactly the square equation with the seam constant and
the two link endpoint forms; a site has zero boundary map and admits
every vector.

The conclusion existentially produces **one family function H** for all
finite block sets simultaneously. For every set `U` with
`U.card <= r+1`, the family `H U` is nonempty and every member has equal
values on all shared named readouts. For **every** `V` contained in such
a `U`, the image under `restrictList` is **equal** to `H V`. Equality,
not mere nonempty intersection or existence of one pair of lists, forces
every previously selected list in `H V` to have an extension in `H U`.
This includes empty sets, equality of sets, arbitrary multi-block additions,
and deletions.

The families are `OffsetLists`, represented by component-wise admissible
shifts and arbitrary corner potentials. They are selected subfamilies,
not a claim that every legal compatible list extends. Address constraints
are imposed by wrapping **r-block** subcollections only. No address
restriction is silently added to a component first wrapping at r+1.
Different old corner components may carry different shifts at a common
type. The extension proof adjusts each old component's potentials before
gluing, rather than assuming old shifts already agree after a merger.

## Source correspondence and generalization

The variable-dimension source is
`../openai_manuscript/Variable-dimension-Weisfeiler-Leman-equivalence-on-general-and-subcubic-graphs-September-25-2026/build/sections/04-blocks-projection.tex`,
Proposition `prop:exact-projection`. Choose `m=2`, identify its two labels
with `Fin 2`, retain its dimensions one or two and nonempty domains,
and choose the last row as seam. All its hypotheses are special cases
of those above.

The fixed-dimension counterpart is
`../openai_manuscript/Unconditional-time-lower-bounds-for-Weisfeiler-Leman-equivalence-September-25-2026/build/sections/02-compression.tex`,
Lemma `comp:projection`. Choose its arbitrary `m>=2`, its fixed finite
value dimensions and coordinate tables, and the same seam. Empty
coordinate domains, if present, remain permitted.

The upstream binary-address proof required dimensions one or two and
nonempty coordinate domains in its instance structure. This port drops
both unused restrictions and replaces address `Bool` by arbitrary `Fin m`.
Crucially, the upstream binary shortcut that two permutations agreeing
at one point are equal is **not** generalized: it is removed.
`alignment_link` is instead proved by the four structural first/interior/
last-link cases. This works even for empty domains and does not infer a
permutation from one of its values.

The report's finite experiments are separate evidence and do not stand in
for any universal quantifier in these declarations. The Lean theorem does
not certify the complexity, graph-realization, or game-equivalence theorems
of all four papers, nor does compilation alone certify this translation.
Independent Reviewer approval of this document remains required.
