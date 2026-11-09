# Interrupted direct and polynomial-module certificates

**Assessment: incomplete explicit certificate routes, not refutations or
route exclusions.** Their common projection machinery has partial support.
The completed rank proof establishes the numerical theorem without
delivering the explicit coefficient outputs promised by these claims.

All old paths below are relative to
`families/067/first-pass/pseudoindex-five-audit/`.
The code, each listed log, every execution receipt, dependency manifests,
and structural contents of `linear_data.json` were inspected read-only.
No superseded search was restarted.

## Exact old claims

| Claim | Exact promised content | Assessment |
|---|---|---|
| `C67_DIRECT_LIFT` v1 | "Explicit rational row operations on A produce selected-coordinate relations with exact lifts to the geometric row families." | Code/progress supports a partial construction, but the listed artifacts do not contain a completed emitted lift trace and its replay. |
| `C67_DIRECT_CUBIC` v1 | "An explicit rational linear combination of quadratic invariant multiples of the lifted relations equals the target cubic functional." | No completed explicit combination was delivered by this route. |
| `C67_MODULE_IDENTITY` v1 | "Explicit degree-two rational polynomial cofactors of lifted selected-coordinate relations sum to the target degree-three module element." | No completed explicit polynomial cofactors were delivered. |

The target is the **homogeneous** cubic coordinate functional
`32 v_(0,000)-20 v_(0,001)+3 v_(0,011)`. Evaluation on a normalized
product vector gives `32-20u+3u^2`. Confusing these two forms would
misstate the cofactor task.

## What the actual artifacts show

`derive.py` constructs the rational polynomial row system and computes
`K` and `N`; `derive.log` reaches completion and the resulting
`linear_data.json` contains exact matrices `A:1785 x 581`,
`K:581 x 65`, `N:69 x 129`, 581 monomials, 129 selected coordinates,
11 base monomials, 18 invariant monomials and 15 selected indices.
Its seven description labels represent the six mathematical row groups,
with the two GRR polynomials labelled separately. This data does not
contain a final cubic cofactor witness.

`direct_certificate.py`, lines 27--118 and 321--347, implements exact
rational/integer row elimination and replayable operation nodes. Logs
show projection and selection of 69 relations. That is meaningful
construction progress, not the missing persisted end-to-end certificate.
`direct_certificate.py`, lines 429--501, then seeks the cubic target
dependence. `direct_certificate.log` reaches 4800 pivots without a
target identity or final certificate.

The module branch, lines 195--300, seeks extended polynomial-module
normal forms carrying the cofactor expressions. `module.log` reaches
400 normal forms, basis 399 and degree three, but records no identity.
`native.log`, `saturated.log` and `short_basis.log` likewise stop in
cubic elimination, with saturation/LLL variants; none is a separate
completed mathematical result.

The direct, module, native, saturated and short-basis receipts have
`state: submitted`. They are submission records, not terminal exit
receipts. The report says the last native/module processes were
deliberately terminated with exit 143 after the rank proof passed;
the listed progress logs/receipts do not independently authenticate
that terminal status. These two documentary facts are kept distinct.
Neither establishes impossibility of cofactors.

`requirements-build.txt` adds `python-flint==0.8.0` to
`sympy==1.14.0`, `numpy==2.5.2`. The optional saturation branch
imports FLINT; ordinary direct/module logic and the standalone completed
verifier do not require it. This review ran no FLINT/LLL/module search
and asserts no new runtime, resource-use or bottleneck measurement.
The old report's coefficient/fill-growth explanation is the recorded
reason for stopping, not a new performance diagnosis.

## Explicit outputs versus existence

There is a useful distinction that prevents overstating the unresolved
mathematics. For the **certified** `A,P,N`, `ker N=im P`, so each
extended selected relation annihilates `ker A` and therefore belongs to
the rational row space of `A`. Likewise, the completed rank proof
shows `Phi` annihilates the entire rational cubic kernel, hence belongs
to the row space of its double-slice matrix. Those rows are quadratic
invariant multiples of the selected relations.

Thus elementary finite-dimensional duality supplies **existence** of
rational lifts and degree-two cofactors for the certified full relation
system. It does not supply their explicit coefficients, a trace for the
particular relations selected by the unfinished code, or a replay of
the promised direct/module certificate. The old claims explicitly ask
for those outputs, so they remain incomplete as constructive certificates.
The issue is not unresolved nonexistence of identities, and does not
justify a renewed search as part of this review.

## Route disposition and attribution

`R67_DIRECT_CERT` was retired because exact cubic elimination was
interrupted without a target identity after reported coefficient/fill
growth, including reduced and saturated bases. `R67_MODULE_CERT`
was retired because explicit cofactors had not been produced when
the computation was stopped after `R67_RANK_CERT` passed. The old
ledger gives both reasons and explicitly disclaims mathematical
nonexistence; the historical graph parks the corresponding two routes.
These reasons are preserved in the coverage index, not rewritten into
refutations.

The missing constructive obligation is precise: emit the exact rational
lift coefficients and either the explicit cubic row combination or
degree-two polynomial cofactors, then replay their equality with the
target and the original row families. That obligation is **not required
to salvage the finite theorem**, which already has the alternative
completed proof. There is no separate novelty or completed original
mathematical result to count for these attempts.
