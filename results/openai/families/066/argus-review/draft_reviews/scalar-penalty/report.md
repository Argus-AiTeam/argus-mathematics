# Scalar exact penalty and its formalization

**Assessment:** the scalar claim is supported. The unchanged v3 formal source
also compiles in a fresh run. Neither fact certifies the geometric bridge.
This is an Engineer assessment for the native independent Reviewer, not acceptance.

## Statement, versions and attribution

The old ledger's `C_LC_PENALTY_ALG` v1-v3 says: for independent real
`e,lambda,C,D,B,b,h,R,V`, assume

```
e>0, lambda>0, C,D,B>=0, R>0, 0<b<=B,
h>=b-D*e, e+lambda*h>0, V>=R/(1+C*e),
lambda*(D+C*B)<1.
```

Then `(e+lambda*h)*V > lambda*b*R`. The comparison is universal over
these variables; a fixed bound on `D+C*B` gives a competitor-independent
threshold. There is no valuation or geometric object in this assertion.

The exact version hashes are in `DRAFT_REVIEW_INDEX.json`. v1 has no formal
source. v2 records all three Lean declarations. v3 preserves their theorem
statements but replaces the budget-comparison proof with explicit `hcb`
and `hsum` steps. Only v3 is the subject of the retained mechanical
certificate (`8990d052...3c0af61`). A successful v3 run is not a compiler
verdict on the historical v2 proof text. It does establish the unchanged
natural scalar assertion of v1 and v2.

This is an elementary scalar reduction in the old Argus draft. It is not a
new manuscript theorem or a demonstrated novel inequality. The two
manuscripts already use this kind of exact-penalty comparison.

## Decisive argument and statement fidelity

Put `K=1+C*e>0`. From `b<=B`, `C>=0` and the budget,
`lambda*(D+C*b)<1`. Therefore

```
(e+lambda*h)-lambda*b*K
  >= e*(1-lambda*(D+C*b)) > 0.
```

Also `V>=R/K>0`. Multiplying the strict inequality by `V` and using
`K*V>=R` proves the claim. In particular `e+lambda*h>0` follows from
the other hypotheses. Lean's omission of that hypothesis is a genuine,
valid strengthening, not a mistranslation. The unused-argument warnings
for `hD` and `hB` do not indicate proof holes: nonnegativity of `D` is not
needed for this scalar argument, and `B>=0` already follows from `0<b<=B`.

The other declarations have narrower, explicit roles:

* `LCSliceAudit.common_budget`: for real `S>=0` and
  `0<lambda<=1/(2*(1+S))`, `lambda*S<1/2`.
* `LCSliceAudit.minimizer_defect_zero`: on an arbitrary type, with arbitrary
  `e,h,root` and map `r`, if the stated comparisons hold at `u,r(u)`,
  `e(u)>=0`, `e(r(u))=0`, and `u` globally minimizes
  `(e+lambda*h)*root`, then `e(u)=0`.

The last declaration uses minimality only against `r(u)`. It constructs
neither a minimizer nor a geometric retraction. The old fidelity document
correctly separates this conditional reduction from the geometric
uniformity, centering, volume and boundary-encoding obligations.

## Replayed evidence and real toolchain

The old source SHA-256 is
`b620d6f367634a49efa6817079668791a90c4e072d80c4fc8adb7525585d06b0`;
the fidelity SHA-256 is
`0ccfea1275942b12c87d013aa307c9eceb8cc50b199909bc8e3e18f36f122c66`.
Both match the archived certificate and remain unchanged.

`replay/compiler_replay.json` records a fresh direct compilation of that
read-only source: exit 0 in 4.144668 seconds, Lean 4.31.0, commit
`68218e876d2a38b1985b8590fff244a83c321783`, using the existing
`mathlib-v4.31.0` workspace, Mathlib revision
`fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`. The old certificate records
both source compilation and a separate axiom audit with exit 0 and no
proof holes. The fresh replay did not repeat that axiom audit or mint an
official certificate for the current review.

The certificate, `lean_check.json`, and `compile.log` describe the same
historical compilation and audit; `lean_submit.json` is only its
submission receipt. `replay/historical_alignment.json` checks these
bindings. They are not four independent proofs.

`replay/arithmetic_replay.json` records exact `Fraction`-based replay of
four polynomial identities, all with zero residual terms. The inspected
old verifier functions were executed without its writing CLI or its
ledger-checking entry point. The geometric premises were not generated
by this replay.

The original discovery output is retained in `replay/jacobian_find.json`
without repeating the lookup. Exactly one current Jacobian operation,
`polynomial.box.enclosure.compute`, was inspected and executed through the
isolated adapter. Its retained
payload and complete typed outputs are `replay/jacobian_payload.json`,
`jacobian_inspect.json`, and `jacobian_run.json`. Server 0.14.0, protocol
2025-11-25, `mcp-stdio`; exit 0, no timeout or structured error. It returns
the enclosure `[1/2,1]` for `1-t` on `[0,1/2]`. This is a bounded arithmetic
sanity check, not the proof of the universal nine-variable inequality.

## Supported scope and remaining obligations

No unresolved scalar step was found. Prior reviewer
`reviewer:dccb8f343ba8` supports the exact v3 certificate
(`judgement-C_LC_PENALTY_ALG-a4b50f34f449`); it is applicable reading
evidence here, not mechanical support for `C_REVIEW_066`.

Uniform geometric constants, the admissibility of `r(u)`, existence and
quasi-monomiality of an actual minimizer, and the manuscript encodings
remain separate arguments assessed in their own units. No novelty or
full-paper conclusion follows from compilation.
