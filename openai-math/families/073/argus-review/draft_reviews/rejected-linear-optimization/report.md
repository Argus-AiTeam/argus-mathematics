# Rejected Jacobian requests

## Intended claim and exact historical evidence

This unit assesses two unsuccessful tool requests, not a mathematical
counterexample. The old campaign attempted to bound `v-u` in the positive-cost
inherited-origin geometry, normalized to `q=1`. The relevant rows are

```text
a-b <= 2,       v-a-2*L <= 0,       b+2*L-u <= 0.
```

They are the closed relaxation of the escape and direct-mode/origin
inequalities used in the scheduled-recursion argument. The full policy-to-
escape implication is a separate substantive part of the payment proof.
Its source is OpenAI's manuscript, Section 09, `ledger:payment`, at the pinned
revision `4eaee87548250b2682affda7d05d947c05554bae`. The requests and their
finite-dimensional encoding are Argus work, not an OpenAI solver claim.

`historical_requests.json` preserves exactly the old
`exact_certificate.json:jacobian` object, with its source path:
operation `optimization.linear.rational_general_optimum.compute`,
Jacobian server `0.14.0`, protocol `2025-11-25`, both payloads and both typed
structured errors. The five variables are `a, origin_b, L, origin_u, v`,
with lower bounds zero except `L>=51`; the objective maximizes `v-origin_u`.
The four labeled constraints include the three displayed rows and the
nonterminal width `v-a>=101`.

The initial request imposes upper bound 1000 on every variable. The second
removes those upper bounds; it does not change the three geometric rows or
turn the problem into a smaller-dimensional proof. Both adapter exits are 2,
with `adapter_status="error"`, `ok=false`, code `-32602`, stage
`operation_validation`, and error
`general_linear_program.normalization_admission`. The messages state that
the possible simplex bases exceed the 1,000,000-candidate admission limit.

Thus neither request produced an optimum, feasible point, infeasibility
witness or recession certificate. Rejection by an admission guard is not
mathematical infeasibility. No timeout or UNKNOWN is interpreted as evidence.
The default old checker, replayed in the finite-experiment unit, confirms
the exact historical payloads and structured rejection fields.

## Bounded adapter check of the already-used algebra

The historical LPs were **not retried, repaired or broadened**. To verify the
elementary coefficient step already present in the draft's argument, the
current review used a different, bounded exact-linear-system contract.
Discovery and inspection are preserved in `adapter_discovery.json` and
`adapter_contract.json`. The isolated adapter was invoked only with

```text
$WORKSPACE/argus-live-update/.venv/bin/python -B -m argus_skill.tools.jacobian
```

The executed operation is `linear.rational_solution.compute`. Its exact
5-by-3 rational system is in `coefficient_payload.json`; its columns are the
first three historical row coefficient vectors, and its right side is the
historical objective vector `(0,0,0,-1,1)`. It asks for multipliers, not an
LP optimum or a counterexample. `coefficient_output.json` retains the typed
source-bound answer, server `0.14.0` and protocol `2025-11-25`.
`adapter_execution.json` records exit 0, complete output, no timeout and no
stderr.

The typed status is `SOLUTION`, with multipliers `(1,1,1)`.
`coefficient_replay.json` independently checks the echoed payload, the
historical variable order and rows, exact multiplication over
`fractions.Fraction`, and nonnegativity of the returned weights. The identity
is simply

```text
(a-b)+(v-a-2*L)+(b+2*L-u) = v-u,
```

so the three weak inequalities imply `v-u<=2`. This is a replay of a supplied
algebraic implication, not a new optimization route or a new theorem.
It establishes neither the strict positive-cost escape premise nor the
actual descriptor geometry. Those are assessed in the composite engine.
The successful small coefficient check does not retroactively convert either
historical rejection into a solver certificate.

## Verdict and novelty

The historical route supplies **no mathematical support or refutation**.
Its failure is specifically normalization admission, not a failed
mathematical argument, a manuscript flaw or the absence of a witness.
The draft honestly makes this distinction. The current bounded coefficient
check supports only the displayed arithmetic and is not counted as another
draft result.

The associated policy/payment mathematics is attributed to the manuscript;
the rejected payloads are Argus attempts. There is no successful optimization
result whose novelty could be assessed. No global novelty is claimed, and
no search of broader programs or geometric objects was run. Native independent
Reviewer acceptance of the assessment remains pending.
