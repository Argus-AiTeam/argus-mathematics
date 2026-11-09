# Cubic ramification: Engineer evidence replay

**Unit:** `cubic_ramification`. **Assessment:** supported exact cubic model,
not a descent counterexample or a geometric descent certificate.
**Old ledger claims:** none. **Novelty:** not applicable to this review.
**Final acceptance:** native independent Reviewer pending.

## Nonledger assertions and mathematics

The fixed input is `f(z,t)=z^3-t` over `QQ`, interpreted geometrically over
`C`. Its discriminant in **z** is `-27*t^2`. Indeed the Sylvester resultant
of `f` and `3*z^2` is `27*t^2`; the monic degree-three discriminant is its
negative. This is an exact polynomial identity, not numerical sampling,
but it concerns this one fixed polynomial and exponent.

The affine total curve is smooth: `partial f/partial t=-1` is a unit.
It is exactly parametrized by `z -> (z,z^3)`, with inverse projection to
`z`. Thus at the origin the base parameter pulls back to `z^3`, of order
3 in the smooth source parameter, so the projection to the `t`-line has
ramification index 3. A ramified projection of a smooth total space is
consistent; the multiple special fibre is not a singularity of that total
space. No contact-manifold, global sheet, or descent hypotheses are
verified by this example. The example is known elementary local algebra,
reproduced by the old Argus work, not a novel obstruction.

## What the inspected checker really does

The complete old `verify.py` was read **before execution**. It uses only
the standard library (`Fraction`, polynomial dictionaries, signed
permutations, JSON, hashing, and read-only `Path` operations). It has no
file-write call and invokes **neither Lean nor Lake nor Jacobian**.
Its only output is printed JSON. With `PYTHONDONTWRITEBYTECODE=1`, the
unmodified direct replay has no Python bytecode writes to the old tree.

It computes a 5-by-5 Sylvester determinant exactly over `QQ[t]`; checks
the sparse input is exactly `z^3-t`; computes the `t` derivative; and
substitutes the declared parametrization. The order-label comparison is
against the literal support `{3:1}`, not a general ramification algorithm.
The parameter argument above supplies the elementary mathematical
interpretation of that check.

It additionally validates the stored typed Jacobian request, operation,
server/protocol, success/timeout/error status, canonical rational result,
and equality with its determinant. It checks the **stored** Lean compiler
and axiom-audit outcomes, proof-hole fields, actual source/fidelity hashes,
and equality with the claim-bound arithmetic archive. This is validation
of records, not another compiler run. It reads the proof and fidelity only
for nonemptiness and checks scope flags; it does not verify their
geometric content. No old report sections 2–7 were substantively read here.

The old archive therefore remains a trust boundary: status JSON and
compiled-library provenance are not recreated by this Python checker.
The fresh, separately claim-bound Lean replay is documented in
`../integer_order/report.md`, not attributed to this cubic computation.

## Actual unmodified replay

Command:
`PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-latest/.venv/bin/python research/contact_value_descent/verify.py`
with cwd
`campaigns/9000062`.
It exited **0** in **0.027478 seconds**, stderr empty.
`exact_checker_replay.json` preserves the exact command, cwd, exit status,
stdout/stderr, duration, and parsed output. Every assigned old file's
SHA-256 was unchanged by the replay; `old_artifact_bindings.json`
distinguishes preserved-manifest bindings from supplementary records.
No snapshot was rebuilt and no original check was changed.

All three returned checks passed: polynomial replay, stored typed Jacobian
cross-check, and stored arithmetic-certificate validation. The return
explicitly says `compiler_rerun_by_this_script=false` and
`full_geometric_theorem_machine_checked=false`.
`verification_result.json` is an earlier copy of this narrow result.
The old report mentions seven negative controls but supplies no listed
per-control transcripts; those controls were not claimed as freshly replayed.

## Exactly one fresh typed Jacobian operation

The exact adapter was
`$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian`.
A bounded discovery requested three matches for “polynomial discriminant”;
then `polynomial.compute.discriminant` was inspected. Its exact input is
`PolynomialDiscriminantRequest`: a sparse rational polynomial over `QQ`
and a named variable. Reduced rational coefficients, exponent-vector order,
and the selected variable matter. Its output is a
`PolynomialDiscriminantResult` with `STANDARD_UNIVARIATE` convention and
`SCALAR` or `POLYNOMIAL` value. The operation declares itself read-only.
There is no geometric-descent contract in this inspected operation.

`jacobian_payload.json` is a byte-exact copy of the old payload:
variables `["z","t"]`, terms `1*z^3` and `-1*t`, variable `"z"`.
Exactly one `run` was executed, with a 30-second adapter bound. It exited
**0** in **3.250843 seconds**, timed out **false**, stderr empty,
structured error **null**. Server **jacobian 0.14.0**, MCP protocol
**2025-11-25**, transport **mcp-stdio** returned the complete typed
`POLYNOMIAL` over `QQ`, variables `["t"]`, sole term coefficient
`{"num":"-27","den":"1"}`, exponent `[2]`. Request and result match.
There was no retry, UNKNOWN, or incomplete result.

`jacobian_discovery.json`, `jacobian_contract.json`, and `jacobian_run.json`
preserve the full contracts and actual transcripts separately from this
report. This operation establishes only the discriminant, not smoothness,
ramification theory, universal integer order, or geometric descent.

## Status reconciliation and remaining boundary

The old `exact_certificate.json` requires `independent_review=pending`,
and the frozen checker repeats that flag. Later old ledger evidence,
including integer v3 judgment
`judgement-C_DES_INTEGER_ORDER-6defe1c7950a` and descent judgment
`judgement-C_DES_DESCENT-d7c9f5a33fb1` by
`reviewer:copilot-cb07e28d5d45`, must not be ignored because of that stale
label. The latter is bound to the old descent subject
`b17eb9f67a66d233a0406439f46c91a72e2ddcdad48633d18673cb7713ff8b08`;
its substantive geometric assessment belongs to the parent worker.
Neither judgment is an independent current acceptance of this unit.

The finite evidence supports only this symbolic cubic model. A universal
ramification argument and the geometric hypotheses needed to apply an
integer-order obstruction are different obligations. No counterexample,
new mathematical project, or manuscript-wide conclusion is claimed.
The local cubic assertions have no remaining mathematical gap; current
native independent review remains required.

After the final current replay ledger write, official `math_state check`
and `proof_graph_check check` both exited 0 at explicit current project
root `campaigns/9200062`,
using `$WORKSPACE/argus-latest/.venv/bin/python`.
The former returned no issues; the latter validated six nodes. Both actual
commands and outcomes are recorded in the tool record.
