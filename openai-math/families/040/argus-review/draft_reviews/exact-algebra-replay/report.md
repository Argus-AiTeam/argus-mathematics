# exact-algebra-replay

**Assessment: supported as a finite exact-arithmetic replay.** The nine
saved full-integrand cases agree. This is not a kernel proof of Chow
geometry, the arbitrary-length statement, or the whole manuscript.

## Object, source, and safe execution

This supplement consists of old `verify.py`, `exact_certificate.json`, and
the four archived Jacobian JSON files under `research/marked-chow-audit/`
in campaign `9000040`. It accompanies OpenAI's September 24, 2026
`relation.tex` at revision `4eaee87548250b2682affda7d05d947c05554bae`, and
old `REPORT.md`, Section 9. It is not another independent theorem draft.

The verifier was read completely before execution. Its imports are standard
library modules. In default mode it reads the saved JSON inputs, computes
with `Fraction`, compares the entire resulting certificate to the existing
certificate, and prints one result. The only source-file write is guarded
by `--write-certificate`; that flag was **not passed**. `HERE` resolves to
the old verifier directory. No external service is called by the verifier.
`PYTHONDONTWRITEBYTECODE=1` prevents import cache writes.

The required command was executed once using
`$WORKSPACE/argus-latest/.venv/bin/python`, **Python 3.13.5**.
The durable direct run used one CPU and completed in **84.3 seconds**,
exit **0**, empty stderr. Its actual output was:

```json
{"ok": true, "claim": "C40_BRIDGE", "exact_full_integrand_cases": 9, "geometric_proof": "REPORT.md", "review": "pending"}
```

`replay_receipt.json` preserves the task/run handle and exact command;
`replay_result.json` records the measured result. The six manifest-covered
old artifacts, including the verifier and certificate, still match the
existing snapshot digests after replay. No certificate was regenerated.

## Every saved full-integrand case

For the first eight cases, \(L_1=L_2=T=H=p=m_1=m_2=0\). The fixed Euler
factors and **both ordered Ext denominators** are present. The last case
uses \(\mathbb P^2\), \(T=\mathcal O(1)=-K/3\), with all other lines zero,
\(p=0\), and extraction at \((m_1,m_2)=(2,0)\).

The output basis is \(h^2\boxtimes1,h\boxtimes h,1\boxtimes h^2\).

| Case | Lengths | Full ordinary class in that basis | Toric configurations actually enumerated | Selected \(c_*\) |
|---|---|---|---:|---:|
| zero-line 1 | (0,0) | (0,0,0) | 0 | 0 |
| zero-line 2 | (1,0) | (0,0,0) | 0 | 0 |
| zero-line 3 | (2,0) | (0,9,0) | 9 | 0 |
| zero-line 4 | (1,1) | (0,-18,0) | 9 | 0 |
| zero-line 5 | (3,0) | (0,-18,0) | 22 | 0 |
| zero-line 6 | (2,1) | (0,18,0) | 27 | 0 |
| zero-line 7 | (3,1) | (0,288,0) | 66 | 0 |
| zero-line 8 | (2,2) | (0,-504,0) | 81 | 0 |
| projective shift | (1,0) | (7/4,-17/4,7/4) | 3 | 1 |

The first two cases return zero by degree before enumerating fixed
configurations; zero is **not** the number of geometric fixed points.
There are 217 enumerated configuration pairs in the other cases.
The certificate also retains the formal output decorations, moment factors,
and per-step term counts; full JSON equality compares those, not just this
table or a success flag.

`pull_atom` implements the ideal, tautological, and two different ordered
Ext corrections. `lower_length` uses the signed Chern recurrence and
asserts strict length decrease. `normalize_graphs` records excess cycles
and retains connected-output terms before `p2_realization`. Local tests
check the surface Todd inverse, dual-line and ideal-sequence signs, and
triangular/repeated-edge excess examples.

The toric implementation enumerates partition configurations and computes
arm/leg tangent weights and the Ext character independently of the nested
rewriter and graph normalizer. It is independent in this limited algorithmic
sense, **not** an entirely separate trusted implementation: it shares
`Fraction`, series helpers, and, for the shifted case, the `Algebra` engine.
Interpreting this calculation as geometry uses the standard monomial-ideal
fixed-point, tangent-character, and torus-localization formulas. Those
geometric inputs are not proved by the numerical agreement and are not
inputs to the arbitrary-length Chow proof.

The shifted case also has a direct selected-coefficient check:
the connected contribution is \([x_1^2]x_1/(1-x_1)=1\). This is stronger
implementation coverage than tests where every selected coefficient is
zero, but only on the legitimate specified slice. It does not prove
uniqueness of the coefficient on \(\mathbb P^2\), where the diagonal is
decomposable.

## Jacobian: exact refusal, not mathematics

The archived payload is the inverse of \(1+3z+3z^2\) modulo \(z^9\).
Discovery returned a small set of candidates; the matching operation was
inspected before the one bounded execution:
`formal_series.rational.inverse.compute`.
The advertised contract takes nine canonical rational coefficients and
returns an exact inverse and product residual.

The current payload exactly matches the archived mathematical input.
The Argus isolated adapter was invoked with
`$WORKSPACE/argus-live-update/.venv/bin/python`, without importing
Jacobian into the legacy environment. Protocol **2025-11-25**, server
**0.14.0**. The current run returned exit **2**, **no timeout**, in
**3.24 seconds**, with empty stderr and the same structured refusal:
`INVALID_REQUEST`, stage `operation_validation`,
`formal_power_series.inverse_coefficient_growth`. The payload, inspected
contract, typed error, and command/status are preserved in this unit's
dedicated JSON files. No retry or adapter repair was attempted.

That refusal supplies no support or refutation. The legacy verifier
independently recomputes
\[
(1,-3,6,-9,9,0,-27,81,-162)
\]
and verifies multiplication to one modulo \(z^9\). This is a finite scalar
identity, not a projective-bundle theorem. The verifier's check of the
archived refusal does not itself contact Jacobian.

The saved `uniform_scope` field points to the prose induction. Its
`independent_review: pending` value is compared as fixed JSON metadata and
cannot report current Reviewer acceptance. No `.lean` proof or compiler
run is present in the listed artifacts.
