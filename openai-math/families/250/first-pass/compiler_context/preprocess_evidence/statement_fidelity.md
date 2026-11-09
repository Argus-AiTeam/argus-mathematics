# Statement fidelity: primitive preprocessing

`CompilerPreprocess` encodes all headed sectors with raw, quota, or cleanup
heads. `alpha` and `omega` are independently arbitrary Booleans. The `left`
list is a stack with the cell immediately left of the head first; `right`
is in ordinary left-to-right order. Empty stacks, missing boundaries, dirty
tags, and arbitrary nonanchor cells are included.

`Base A` has arbitrary anchors, the two distinct cuts, and workspace.
`Tag A D` distinguishes the completely clean tag from a dirty tag carrying
an arbitrary decoration of type `D` and an optional output mark. The decoration
retains all other tag data, not merely a clean/nonclean quotient. This is
source-faithful for these operations: raw slides and quota tests require the
entire tag clean, and cleanup tests only anchor status and the output mark.
No finiteness hypothesis is needed, so every finite tag set in the compiler
is included. The clean tag necessarily has no output mark.

`slide`, `trim`, `quotaResult`, `emit`, `cleanLeft`, and `preprocess` implement
exactly the source's preprocessing on those three head types. `raw_slide`,
`quota_insertion`, `merge`, `cleanup_cell`, and `cleanup_boundary` prove equality
of the **literal preprocessed sector lists** on the two sides of each source
equation, for every cell context and every choice of outer boundary flags.
`merge` permits incomplete and dirty outer sectors. The cleanup theorem covers
both marked-anchor replacement and deletion of every other tagged cell.

`cellGrade` assigns two to the first cut, zero to workspace, and one to all
other cells; every head and each present boundary has grade one. `slide_grade`
and `trim_grade` give exact grade conservation. `emit_grade` and
`cleanLeft_grade` give cleanup nonincrease. `quotaResult_grade` checks the
four-grade unmerge exactly, including its two new interior boundaries.
`preprocess_grade` proves grade nonincrease for arbitrary sectors of these
three head types.

`raw_slide_step_grade`, `quota_step_grade`, `merge_step_grade`,
`cleanup_cell_step_grade`, and `cleanup_boundary_step_grade` additionally check
the grades of the elementary presentation steps themselves. Thus the recursive
slide, quota-removal, unmerge, and cleanup paths stay within the original grade,
not merely their final outputs.

The claim `C_COMPILER_PRIMITIVE_PREPROCESS` does not include validator or
machine heads, entry-component search, the equation from a quota head to an
entry, or `q_ok omega = Z omega`. These are separate obligations; this source
does not certify the full bounded compiler or the expansion of its scan program.
