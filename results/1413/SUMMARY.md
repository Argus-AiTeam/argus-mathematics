# Five-day proof-timebox retirement: 1413

- Objective: Counterexample campaign 1413: 57 度 Moore 图的存在性
- Campaign start: 2026-08-29T04:53:24.950055+00:00
- Retirement time: 2026-09-05T08:24:43.201324+00:00
- Final status: no completed proof or counterexample marker within five days
- Data policy: all campaign files and exact certificates are preserved

## Preserved result frontier

- 2026-08-29T12:59:57Z · candidate_search · exhausted
  The corrected fail-first arm consumed all 1,024 frozen nodes with 541 Hall failures, 169 sampled-branch exhaustions, and 710 rollback decisions. Twelve Hall failures certified one-level nonchronological backjumps, but the deepest valid prefix remains the same 77-edge K13-minus-{2,12} concentration and no complete candidate was produced.

- 2026-08-29T13:07:20Z · clean_replay · done
  Replayed all 3,868 corrected fail-first events, 1,024 selections, 541 Hall certificates, and 148,247 selected blocking paths; its deepest 77-matching prefix is bijective and has no triangle or four-cycle. Replayed all 3,337 one-factorization events and 1,024 selections; its deepest 256-matching prefix is bijective and has no triangle or four-cycle, and the 55-round schedule covers every base edge exactly once.

- 2026-08-29T13:07:20Z · final_checks · done
  Recorded the frozen ablation as inconclusive evidence for C1 and C3 and retired only this bounded route. The pinned math-state check reports no issues; the proof graph is structurally valid and still reports C7 and C8 as the two open gaps. No degree-57 candidate exists, so no strict 3,250-vertex verification was available.

- 2026-08-29T13:07:20Z · handoff · done
  Handed the retrospective Hall-core certificates, frozen experiment contract, controls, complete traces, exact audits, and bounded comparison to the required independent Reviewer. This is an exhausted finite experiment, not a graph or nonexistence certificate.

- 2026-08-29T13:10:08Z · review_start · in_progress
  Started independent replay of all retrospective Hall cores, fresh policy controls, both frozen degree-57 traces, the K56 one-factorization, and both deepest-prefix graph scans.

## Retirement boundary

The preserved work may contain exact partial lemmas, route exclusions,
or conditional certificates, but the campaign did not complete its main
proof/counterexample objective inside the operator's five-day API
timebox. The daemon and campaign-owned detached computations were stopped.
No mathematical nonexistence conclusion is inferred from retirement.
