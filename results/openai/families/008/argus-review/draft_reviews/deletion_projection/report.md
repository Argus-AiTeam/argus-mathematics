# Deletion representation, kernel, and leading projection

**Engineer assessment: the auxiliary boundary independence is exactly
verified; the old package only partially certifies the general deletion
and projection argument. No source counterexample is established.**

## Exact claims, hypotheses, and attribution

This unit assesses old `L_PROJECTION` and its supporting assertions in the
pinned manuscript's Section 4, revision
`4eaee87548250b2682affda7d05d947c05554bae`.

`prop:deletion-representation` (`04-deletion.tex:53-62`) says the
paper-defined integral deletion operators `T_H` represent the arrangement
Lie algebra: for every codimension-two flat they satisfy

    [T_H, sum(T_H' : H' contains that flat)] = 0.

The construction extends to the enveloping algebra over the integers and
after reduction. It is not a statement about an arbitrary matrix assignment.

`lem:deletion-kernel` (`202-206`) concerns a leading symbol `chi` in the
preceding solution/leading-pentagon setting. If `chi(0,C,B)=0`, it belongs
to the ordinary free Lie algebra on `A,B`, with the specified `m` copies
of `A` and `r` copies of `B`. The solution and leading-relation hypotheses
are essential; a kernel statement for all polynomials would be a different
claim.

`prop:projection-injective` (`299-308`) states that, for every weight `n>2`
and natural count `r`, the projection
`chi(A,C,B) -> chi(0,C,B)` is injective on the associated graded of the
embedded rational-solution reduction. A nonzero component has
`n=2m+r`, with `m` a nonnegative integer; incompatible counts are zero.
It is not injectivity on the full free Lie algebra in three generators.

## Decisive source arguments

The representation proof (`64-121`) constructs a matrix-valued logarithmic
form, cancels nonadjacent deletion terms, checks the adjacent triangle
identity, and takes successive residues to obtain the flat relations.
The kernel proof (`208-290`) uses the least nonzero `A`-count, explicit
deletion-slot coefficients and the scalar leading-pentagon relation to
eliminate mixed `A,C` terms; reversal treats the residual word shape.
These are real derivations, not missing proofs.

The projection proof (`310-390`) then reduces a kernel element to `P(A,B)`
and applies the **reduced rational special identity**. Its coefficient
exchange gives a factor `3`, equal to `1` in characteristic two, for the
general case, with `m=1` and the small count boundaries treated separately.
It would be invalid to omit the special identity and extend the conclusion
to all modular solutions.

## What the boundary computation actually proves

In the ordered associative-word basis `ABB,BAB,BBA`,

    [B,[A,B]] = 2BAB-BBA-ABB

has mod-two vector `(1,0,1)`. The other tested boundary expression
`ABB+BAB+BBA` has vector `(1,1,1)`. The two columns form

    [[1,1],
     [0,1],
     [1,1]]  over F2.

The first two rows have determinant `1`, so the rank is exactly two.
This is a complete elementary calculation of this boundary independence.
It is the `m=1,r=2` word calculation (original weight four), **not** the
rational weight-zero/one/two proof.

The old typed Jacobian result is consistent with this computation. Its
status has `exit_code=0`; `timeout_exit_code=124` names the timeout exit
convention, not an observed timeout. The earlier broad receipt reading's
suggestion of a timeout is resolved by the exact status preserved in
`../upper_bound_certificate/reuse_check.json`.

For the required current bounded adapter use, discovery selected
`prime_field.matrix.rank.compute`; its exact input/output schemas were
inspected before execution. The dedicated current files
`jacobian_payload.json`, `jacobian_output.json`, and `jacobian_status.json`
retain the operation, source matrix, typed rank `2`, adapter exit `0`,
`timed_out=false`, and empty stderr. Server version is `0.14.0`, protocol
`2025-11-25`. Discovery and contract files are retained separately. The
independent minor is also recorded by the current algebra replay.

## Scope and concrete remaining obligations

Rank two of these columns neither verifies all codimension-two flat
relations nor proves the deletion-slot induction for arbitrary `m,r`.
The 21 source-action identities are likewise not checks of this geometric
representation. To certify this literal route separately, the unresolved
checks are the all-flat operator relations, the least-`A` coefficient
elimination/reversal argument under the leading relation, and the general
special-identity coefficient exchange together with *all* its boundary
cases. The source contains proofs of them; the old certificate does not
provide a separate independent receipt for these steps.

Thus `AUX_BOUNDARY_RANK` is supported and `L_PROJECTION` has partial
independent support at the literal-argument level. Neither a false
manuscript assertion nor a new mathematical contribution follows from
this limitation. The direct rational dimension theorem remains separately
supported; current native independent acceptance remains pending.
