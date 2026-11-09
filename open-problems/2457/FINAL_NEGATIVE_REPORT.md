# Final negative report: campaign 2457

## Result

No counterexample was found.

For the frozen finite target and the exact Erdos-Selfridge plus-class
definitions in `research/MATH_STATE.json`, the existing certificates establish
both of the facts needed to determine the first exact-class-17 prime:

1. `T = 1833174628057` is prime and has exact plus-class 17.
2. No prime `q` with `2 <= q < T` has exact plus-class 17.

Therefore the finite equality in OEIS A005113 revision 53 is verified:

```text
A005113(17) = 1833174628057.
```

Equivalently, every branch of the frozen counterexample claim
`C-NEG-A005113-17` was ruled out. This is an exhausted counterexample boundary,
not a counterexample.

## Statement sources and fidelity

The frozen target is the revision-53 OEIS assertion, not the open infinitude or
growth alternatives in Erdős Problem #1055. The source roles are:

| Source | Role in this report |
|---|---|
| OEIS A005113, internal revision #53 (2026-05-23), `%N`, `%S-%U`, final `%C`, and final `%E` entries | Defines `a(n)` as the least plus-class-`n` prime and records the finite target `a(17)=1833174628057`; the entry is the assertion under audit, not proof of it. |
| T. F. Bloom, *Erdős Problem #1055* (accessed 2026-08-27), problem text and additional text | Supplies the recursive class problem and the OPEN status of the infinitude and growth questions; those questions are excluded from the finite conclusion. |
| `google-deepmind/formal-conjectures`, commit `ab7989605ff82ae5680812b2a70bfbf52c33fa87`, `FormalConjectures/ErdosProblems/1055.lean`, lines 23-89 | Corroborates the exact, rather than cumulative, class interpretation and records the open declarations with proof holes; it is a statement artifact, not proof. |
| P. Erdős (1977), MR 532690, and R. K. Guy, *Unsolved Problems in Number Theory*, Problem A18, MR 2076335 | Bibliographic lineage only. No proposition from either source is used as a premise of the finite certificate argument. |

The exact definitions, source identifiers, locators, and source-scope caveats
are frozen in context `ctx-2457` of `research/MATH_STATE.json`. Once that finite
target is fixed, the equality proved here depends only on the two local
certificate results below; it does not assume an external theorem.

## Reviewed evidence

The result is carried by four sealed `round_reviewed_handoff` records, each
produced by an independent Reviewer with `review.status = "done"`:

| Scope | Sealed handoff | Local public record |
|---|---|---|
| Corrected bounded scope and certificate contracts | `/home/argustest/zimo/.argus-campaign-2457-run3/projects/90f44b3681b7/handoffs/3a2554ee7225/round-0002.json` | `activity.jsonl`, `2026-08-27T13:47:38.333Z`, `scope_review` |
| Deterministic target audit: `T` is prime of exact class 17 | `/home/argustest/zimo/.argus-campaign-2457-run3/projects/90f44b3681b7/handoffs/2e5cc3753a4b/round-0001.json` | `activity.jsonl`, `2026-08-27T14:05:52.193Z`, `review_verdict` |
| Complete strict-below-`T` exhaustion | `/home/argustest/zimo/.argus-campaign-2457-run3/projects/90f44b3681b7/handoffs/d9eda6aaa2d0/round-0001.json` | `activity.jsonl`, `2026-08-27T14:42:25.939Z`, `review_verdict` |
| Integration of the two finite components into `A005113(17)=T` | `/home/argustest/zimo/.argus-campaign-2457-run3/projects/90f44b3681b7/handoffs/f22df7861ba4/round-0001.json` | `activity.jsonl`, `2026-08-27T15:05:57.889Z`, `review_verdict` |

The target audit is independently rerunnable from:

- `research/target_audit/certificate.json`
- `research/target_audit/verify_certificate.py`
- `research/target_audit/logs/03_verify_certificate.out`
- `research/target_audit/test_tampering.py`
- `research/target_audit/logs/04_tamper_tests.out`

Its integer-only verifier accepted 19 complete plus-class nodes and 44
recursive Lucas primality nodes, and computed `class(T) = 17`.

The strict-lower-bound exhaustion is independently rerunnable from:

- `research/smaller_class17_search/exhaustion_certificate.json`
- `research/smaller_class17_search/verify_exhaustion.py`
- `research/smaller_class17_search/verify_exhaustion.cpp`
- `research/smaller_class17_search/logs/10_independent_verify.out`
- `research/smaller_class17_search/test_search.py`
- `research/smaller_class17_search/logs/11_control_and_tamper_tests.out`

The independent reconstruction covered all 17 levels and 358263863
multipliers, reproduced every recorded bound, seed, count, and extremum, and
ended with an empty level-17 set. The strong probable-prime predicate is used
only as an overapproximation: a pseudoprime can add a survivor but cannot
remove a genuine prime, so the empty final set is an exact exhaustion result.

## Final-review checklist

The dedicated final-submission Reviewer can assess the four required questions
directly from the following artifacts:

| Question | Evidence |
|---|---|
| Goal achievement | `research/PROOF_GRAPH.json` uses the exact persisted campaign goal as its root; its only dependency is the reviewed finite equality. |
| Statement fidelity | Context `ctx-2457` in `research/MATH_STATE.json` fixes the exact plus-class definition, target, counterexample branches, certificate contracts, and exclusions. |
| Argument correctness | The reviewed claims `C-T-CLASS17` and `C-EXHAUST-BELOW-T` imply `C-A005113-17-EQUALITY`; the sealed integration review is `f22df7861ba4/round-0001.json`. |
| Outcome honesty | This report says no counterexample was found, identifies an exactly exhausted finite boundary, and expressly leaves infinitude and asymptotic growth open. |

## Rerun commands

From the campaign root, replay the independent target verifier and its mutation
controls:

```sh
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/target_audit/verify_certificate.py \
  research/target_audit/certificate.json
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/target_audit/test_tampering.py
```

Replay the independent full-domain reconstruction and its boundary and mutation
controls:

```sh
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/smaller_class17_search/verify_exhaustion.py \
  research/smaller_class17_search/exhaustion_certificate.json --threads 32
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/smaller_class17_search/test_search.py
```

Check the integrated ledger and proof-gap structure:

```sh
/home/argustest/zimo/argus-latest/.venv/bin/python \
  -m argus_skill.verticals.math.math_state check \
  --project-root /home/argustest/zimo/counterexample-batch-1
/home/argustest/zimo/argus-latest/.venv/bin/python \
  -m argus_skill.verticals.math.proof_graph_check gap \
  --project-root /home/argustest/zimo/counterexample-batch-1/campaigns/2457
```

## Scope boundary

This report settles only the frozen finite counterexample domain for the
revision-53 equality at index 17. It does not prove or refute that every class
contains infinitely many primes, and it does not decide either asymptotic
alternative in Erdos Problem #1055. Those questions remain open.

The two mathematical components and their campaign-level linkage have
independent Reviewer approval. Under the current final-submission contract, the
Manager-owned campaign root remains in progress until a new independent
review-stage sealed handoff explicitly certifies exploratory project completion
and rules on all four checklist items above.
This report does not self-certify that final verdict.
