# Exact payment experiment

## Claim, attribution and scope

The old campaign's `verify.py` and `exact_certificate.json` claim a deterministic
finite replay of descriptor scheduling and payment inequalities, with no
violating case. This is an Argus experiment about the combinatorial objects
of OpenAI's *The Falconer distance conjecture in all dimensions* (2026-09-23),
not a theorem about distance sets. The reference version is revision
`4eaee87548250b2682affda7d05d947c05554bae`, pinned in
`9100073/MANUSCRIPTS.json`. The supporting manuscript contracts are
`test:descriptor-properties` in Section 05 and `ledger:payment` in Section 09.
All fourteen pinned TeX files match both the reference source and old staged
source; the measurement is in `../scheduled-recursion/binding_replay.json`.

There is no separate old ledger claim ID for this experiment. It supports
the scheduled-recursion unit but is counted neither as C_ENGINE nor as
another universal mathematical result.

## What the checker actually tests

`verify.py:170-333` implements the block policy, schedules, potential and test
loops. For each of `(q,N)=(1,128)` and `(2,256)`, it uses ten specified
integer profiles: increasing, decreasing, flat, boundary valleys, late valley,
early valley, central valley, inherited-boundary notch, triangular and
sawtooth. There is no random sampling or enumeration of all profiles.

The block representative minimizes `(profile value, index)`, and interval
selection uses that same deterministic tie rule. The schedule for base
`[0,N]` unions descriptors over all its nonterminal origins of width greater
than `100*q`. Descriptor identity includes its type. Every stored origin is
checked for symmetric extension by the nominal length, and every shorter
parallel completion is checked to be present. The potential is computed in
integer arithmetic as the minimum of `A(i)+A(j)` on the current interval
with separation at least `10*q`. It raises an error rather than inventing a
value below that width.

Suffix/high tests cover the specified nonterminal intervals; high endpoints
range over the last `q` admissible depths. Direct tests use the schedule of
the single base `[0,N]`, current finishes in `[N-q,N]`, and each maximal
remaining descriptor when its direct-mode width test holds. Thus these are
not all possible retained bases, endpoint slacks, tie policies or legal
recursion branches. For each stored origin of such a descriptor, inherited
means `b<a` or `u>v`: the origin is not contained in the current interval.
For positive costs the checker also tests `r<b+2*q` and `v<u+2*q`, the
decisive escape inequalities used by the general payment proof.

The integer profiles test payment beyond any claimed realization by
Frostman measures. They are not certified Frostman profiles, and no
geometric counterexample or analytic estimate follows from them.

## Read-only replay and exact results

The command was run from the current campaign, with neither `--write` nor
`--lean`:

```text
$WORKSPACE/argus-latest/.venv/bin/python -B campaigns/9000073/verify.py
```

`replay.json` preserves the command, current working directory, exit status,
stdout, stderr and parsed counts. It returned exit 0 in 3.460675 seconds,
without a timeout or stderr. The measured counts equal the stored certificate:

| Recorded field | Count | Actual meaning |
| --- | ---: | --- |
| `profiles` | 20 | Ten named profiles at each of two parameter pairs |
| `positive_cost_cases` | 29,624 | Suffix/high cost-row checks, **including zero costs** |
| `direct_cases` | 437 | Selected direct descriptor/parent checks |
| `positive_direct_cases` | 7 | Direct checks with strictly positive cost |
| `inherited_origin_cases` | 485 | Inherited memberships, possibly several origins per direct check |
| `positive_inherited_origin_cases` | 6 | Such memberships with strictly positive cost |
| `descriptor_memberships` | 1,704 | Sum of deduplicated descriptor-dictionary sizes, not the number of origins |

No inequality assertion failed. In particular, six positive inherited
memberships prevent the inherited-origin checks from being entirely vacuous,
but do not constitute six independent universal results.

The default checker also validates the stored Jacobian errors and the current
formal source/fidelity/compiler/claim binding. Its output
`formal_verification="success"` is a **reused historical compiler verdict**:
this invocation does not compile Lean. Source binding and toolchain details
are assessed in the scheduled-recursion unit.

## Assessment and limitations

The finite claim is supported exactly as bounded above. Deterministic
integer arithmetic and the replayed count comparison are substantive evidence;
they are not just a missing-access or run-status assessment. The universal
payment/termination result instead depends on the separate Lean argument,
including arbitrary fixed ties and all legal runs. No new parameter range,
profile family or counterexample search was introduced.

Attribution of the schedule and payment proposition is to the manuscript;
the finite implementation and selected profile suite are Argus work.
No originality or publishability assessment of that implementation was
performed. Global mathematical novelty is unverified and not claimed.
Open analytic and assembly obligations are unaffected. Native independent
Reviewer acceptance of this assessment and the complete inventory is pending.
