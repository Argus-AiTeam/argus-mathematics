# Five-day proof-timebox retirement: 2775

- Objective: Counterexample campaign 2775: Kirby 问题 2.27：辫群与右直角 Artin 群
- Campaign start: 2026-08-29T04:47:48.221644+00:00
- Retirement time: 2026-09-05T08:24:43.201324+00:00
- Final status: no completed proof or counterexample marker within five days
- Data policy: all campaign files and exact certificates are preserved

## Preserved result frontier

- 2026-08-29T10:48:00Z · search_refinement · in_progress
  Verified all five canonical P4-to-F2 maps on the pseudo-Anosov semidirect presentation and replaced the single-axis filter by the joint five-axis compatibility condition, preserving exact completeness while reducing expensive free-word products.

- 2026-08-29T12:23:51Z · targeted_search · bounded_no_candidate
  For g=A12*A23^-1, exactly exhausted kernel words through radius eight for the three smallest exponent pairs and radius seven for three additional exponent pairs; joint free-quotient compatibility produced no noncommuting twisted-norm root.

- 2026-08-29T12:23:51Z · search_refinement · complete
  Separated the w boundary from the u,v boundary, discarded commuting pairs before root lookup, used unrestricted exact free-group square extraction when m+n=0, and expanded nonzero twisted roots through radius ten.

- 2026-08-29T12:23:51Z · targeted_search · bounded_no_candidate
  Classified and searched three additional short pseudo-Anosov root directions, including the previously omitted same-sign trace-minus-six class and the base commutator class; no exact tuple was found within the recorded boundaries.

- 2026-08-29T12:23:51Z · tool_diagnostic · complete_nonsupporting
  Tested Sage's inherited nth_roots interface on an infinite braid group; LibGAP rejected it because the method requires finite-group conjugacy classes, so it supplies no braid-root decision and no mathematical evidence.

## Retirement boundary

The preserved work may contain exact partial lemmas, route exclusions,
or conditional certificates, but the campaign did not complete its main
proof/counterexample objective inside the operator's five-day API
timebox. The daemon and campaign-owned detached computations were stopped.
No mathematical nonexistence conclusion is inferred from retirement.
