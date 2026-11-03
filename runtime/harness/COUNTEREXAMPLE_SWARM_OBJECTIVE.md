# Objective: high-parallel counterexample swarm

The open-status audit has already produced
`outputs/open_problems_2026-08-27.csv`. Immediately pursue counterexamples for
the confirmed-open first wave. Do not wait for the remaining 757-row audit.

## Active first wave

Existing independently assigned campaigns (do not duplicate their Engineer
write paths): `1417`, `1518`, `1243`.

This Argus swarm owns these five campaigns in parallel:

- `1187` — Andrews–Curtis candidate presentations and obstruction invariants;
- `8200002` — four mutually unbiased bases in dimension six;
- `1900020` — non-eventually-periodic Jacobi–Perron witness search;
- `2457` — finite anomalies in Erdős problem 1055 prime classes;
- `20001578` — Thompson F non-amenability certificate search.

## Rules

1. Search only for counterexamples, negative witnesses, or explicit finite
   constructions that contradict the stated expectation. Do not spend a
   mission proving the conjecture true.
2. Run the five campaign Engineers concurrently. Planner and Reviewer roles may
   work concurrently where useful, up to the configured mission width eight.
3. Write only within `proofs/<ID>/**` and update the corresponding
   `proof-campaigns/<ID>.json` when the campaign state changes.
4. Every role progress file must contain `role`, `agent`, `track`, `status`,
   `progress`, `current_activity`, `updated_at`, and `artifacts`.
5. Append public operational facts to each active Engineer's `activity.jsonl`
   using fields `ts`, `role`, `agent`, `kind`, `action`, `status`, `artifact`.
   Record batch starts/completions, parameter changes, best candidates, and new
   artifacts. Never record hidden reasoning or credentials.
6. A timeout, failed search, long nonrepeating orbit, numerical near-solution,
   or finite-radius pattern is not a counterexample. Preserve honest bounded
   negative results and change strategy.
7. Any candidate must receive an independent Reviewer check with a rerunnable
   exact certificate before campaign status becomes `confirmed_counterexample`.
8. Do not edit the website source. The existing public-data builder publishes
   proof directories automatically every two seconds.

## Completion

Keep all five campaigns moving in parallel. A campaign may finish only with a
confirmed counterexample or an explicit exhausted search boundary plus a next
strategy. Continue launching the next confirmed-open candidate when a slot
becomes free.
