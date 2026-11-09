# Statement fidelity: OrderedMatrix190

The source is `Main.lean`, namespace `OrderedMatrix190`, using Lean 4.31.0
and the host's built Mathlib workspace. This document describes the formal
statements, not an assertion that the whole host theorem is formalized.
All formal declarations have explicit universally quantified parameters;
there are no axioms or admitted mathematical hypotheses hidden as global
constants.

## Radix selection core

`radix_unique` quantifies over natural numbers `m q a b c`. It assumes
`q` divides `m`, `b<m`, `c<m`, equality of the quotients by `q` of
`(a+b) mod m` and `(a+c) mod m`, and equality of `b mod q` and `c mod q`.
It concludes `b=c`. The shift `a` is unrestricted. In particular the
statement includes the valid positive-divisor cases used in the report.
`cyclic_radix_injective` packages this as injectivity on `Fin m` of the
pair of natural coordinates. It does not itself encode the target
coordinate bounds or surjectivity; their elementary derivation and the
association with protected host cells are in Section 1 of the report.
No statistical independence is assumed.

## Four-body propagation, at every depth

`AvoidP a b c d` means that the ordered two-by-two Boolean matrix
`((a,b),(c,d))` is not `((true,false),(true,true))`. Thus it is exactly
avoidance of the manuscript's literal body, with zeros matched.
`avoid_vertical_iff` and `avoid_horizontal_iff` prove the corresponding
Boolean implications.

`shared_leaf_obstruction` quantifies over any natural depth `h` and four
functions from naturals to Booleans. `plus i` and `minus i` encode the
selected level-i diagonal values; `crossPlus i` and `crossMinus i` encode
the row-child/column-parent entries between levels i and i+1. It assumes
plus root true, minus root false, and avoidance of each of the four raw
two-by-two bodies for every `i<h`, with the exact row/column orientations
shown in Section 2. It also assumes equality of the terminal plus and
minus values. It concludes `False`.

The raw forbidden bodies, rather than a desired inductive conclusion,
are its hypotheses. The host translation still requires the report's
proof that an uncontaminated selection has actual ordered mode anchors,
unit signatures, and dummy ones. It does not assume either the disputed
edit-distance theorem or global anchor rigidity.

## All-index mode classification

`v_plus_exclusion` and `v_minus_exclusion` quantify over arbitrary
natural child, parent-row, and parent-column indices. Their inequalities
are precisely the necessary row-order and body-entry inequalities for
the two vertical modes. They exclude the incompatible third inequality.

`parity_parent_order` proves that common parity and ordered parent
indices imply ordered child indices. `w_plus_exclusion` and
`w_minus_nonleaf_exclusion` apply this to the two horizontal non-leaf
thresholds, with the reversed minus-column order.
`w_minus_leaf_classification` uses the inclusive shared-leaf threshold
and concludes `p=q` and `b=p/2`. These statements are unbounded in the
indices and do not enumerate a finite set of depths.

The translation of actual ordered bodies into these inequalities, and
the converse construction and counting of all terminal bodies, are in
Section 4 of the report. Anchor rigidity is not a hypothesis of an
alleged fully formal host theorem: there is no such declaration here.

## Signature suppression and exact arithmetic

`unitSignature j` is the Boolean unit word on `Fin 64` with its unique
one at `j`. Formal indices are zero-based, so `0` and `1` denote the
manuscript's first and second anchor groups. `unit_deletion_no_new_role`
says that a word obtained by deleting ones from a unit word cannot
equal a different unit word. `suppress_first_unit` proves that deleting
the first coordinate of the first unit word gives the zero word.
Neither declaration replaces the report's global deletion-stability
argument, whose dummy-preserving and whole-group hypotheses are essential.

`two_rectangles` counts two disjoint t-by-2t rectangles algebraically.
`repair_power_count` specializes this to actual depths `h=r+1>=1`.
It proves the number of edited cells is `(2^h)^2`, not that arbitrary
overlapping rectangles have that cardinality. The disjointness and
original value one of the specified rectangles are established in
Section 5.

`exact_copy_count_identity` proves
`m*m*2*m^128 = 2*m^130`. The enumeration of the independent choices is
in Section 4. `squared_power` proves `(2^h)^2=4^h` for every natural h.
`retained_copy_bound` proves `2*m^130 <= m*n^130` assuming `2<=m<=n`.

## Remaining host-level proof and review

The following parts are proved in prose in `research/AUDIT_REPORT.md`,
not encoded in Lean: the entire literal host and pattern, finite-anchor
distinctness and density, the all-depth suffix trace argument, stable
global anchor localization, protected-cell selection bookkeeping,
the minimum over all binary repairs, and the exact enumeration's
identification with ordered copies. The standard-library Python
certificate independently checks their finite numerical ingredients
and explicit witnesses, not the universal host theorem by exhaustion.

Accordingly a successful compiler run certifies the unbounded core
claim `C_LEAN_CORE`, not `C_EXACT_DISTANCE` or the whole paper. The
latter is supported by the complete prose proof and requires independent
Reviewer reading and replay. No independent review is claimed here.
