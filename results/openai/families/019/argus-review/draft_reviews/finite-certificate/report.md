# Finite collar illustration: exact checker and adapter review

**Assessment:** all claimed finite controls replay successfully and the live
typed graph result equals the old result. This is a finite verification of
one example, not a universal construction of covers, analytic convergence,
or a proof of the collar lemma.

## Object, provenance, and precise scope

There is no separate old ledger claim for this example. Its evidence is
`9000019/research/collar_root_audit/exact_certificate.json`,
`verify.py`, and the four historical Jacobian JSON files. They are supporting
artifacts of the `engineer:copilot` collar draft, not another analytic
theorem. Current claim `DR019-FINITE` records their restricted finite
conclusion. The supplied snapshot identifies the old checker and exact
certificate; the other Jacobian files have no snapshot-manifest entry.

The old certificate's top-level `result_class="verification_theorem"` and
analytic conclusion are assertions about the **prose argument plus its
external inputs**. Its explicit `full_analytic_lemma_formalized=false`,
finite-scope fields, pending review, and open campaign cannot be erased.
The finite part is correctly classified here as `finite_verification`.
The original manuscript target and revision are supplied by the analytic
unit; this checker does not independently certify any manuscript revision.
The old example does not claim novelty.

## Exact graph and decisive replay

The graph has vertices `0,1` and three distinct parallel edges `b0,b1,b2`.
The submitted simple cycles are

```text
0 --b0--> 1 --b1--> 0
0 --b1--> 1 --b2--> 0
0 --b2--> 1 --b0--> 0
```

Each edge occurs twice. The inspected contract permits length-two cycles
in a loopless multigraph, distinguished by edge IDs; they are not invalid
just because a simple-graph convention would exclude parallel edges.
The old Python function checks closure, simplicity, unique edge IDs,
incidence and exact multiplicity. Independently of the adapter's cycle
verdict, it deletes each edge and traverses the remaining graph; every
deletion leaves the two vertices connected.

The typed operation therefore establishes exactly the double-cycle cover
of this graph. The deletion calculation establishes its nonseparating
edges. Neither establishes that every stable graph admits the universal
bridge/circuit construction or that any specified residue cover lifts.
Those assertions require the analytic unit's arbitrary-graph argument and
the ABBR theorem with actual residue maps.

## Exact rational and numerical controls

The old checker, using exact `Fraction` arithmetic, obtains:

| Finite control | Exact result and boundary |
|---|---|
| Binomial powers | For `ell=3,5,7`, coefficients of degrees `0..12` satisfy the `ell`-th power identity `1+z` modulo `z^13`. No coefficient of degree 13 or higher is tested. |
| Tame denominators | The coefficients tested have denominators prime to `p` for the nine pairs with `p in {2,3,5,7}` and `p != ell`. This finite integrality check is not a proof of all-degree integrality or analytic convergence. |
| Wild negative control | The first coefficient `1/ell` is not `ell`-integral. It explains why these finite tame controls cannot simply be reused in wild order; it does not prove universal nonexistence of wild roots. |
| Signed winding | For windings `-7,-1,0,1,7` and orientations `+/-ell`, the pulled-back exponent is divisible by `ell` (30 checks). This includes zero and negative exponents but does not construct analytic functions. |
| Bridge example | With `ell=3`, base genus 2, two genus-1 residue vertices and three edges, the unramified precover has genus 4; the illustrated circuit lift has genus 10. The local genus and valence balances agree with these totals. |
| Radius order | Additive interval `(1,2)` at `p=5` corresponds to the increasing radius interval `(1/25,1/5)`, not `(1/5,1/25)`. |

These are the unchanged controls in the old certificate, not an expanded
counterexample search. Universal binomial convergence, residue-map
existence, and all-sheet capture are proved or assumed separately in the
analytic review.

## Safe replay and actual toolchain

Inspection of old `verify.py` preceded execution. Its `main()` would write
the old `exact_certificate.json`; `compile_and_check()` would write old
compiler summaries and invoke a claim-bearing verifier against the old
project ledger. Neither was executed. The read-only definitions were loaded
with `runpy.run_path(..., run_name="review_read_only")`, and only
`replay_jacobian()` and `replay_exact_arithmetic()` were called.
`PYTHONDONTWRITEBYTECODE=1` prevented source-directory bytecode artifacts.
The small current `replay.py` compares those results to the old certificate
and to the live typed output; it does not replace or modify the old checker.

The exact replay command was:

```text
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-latest/.venv/bin/python research/draft_reviews/finite-certificate/replay.py
```

The actual Python executable and full runtime version are recorded in
`replay/replay_result.json`, together with the two executed function names.
It reports equality of the independently recomputed finite fields and the
historical certificate.

Jacobian was **not** imported into that Argus environment. The isolated
adapter was invoked with the machine-specific interpreter
`$WORKSPACE/argus-live-update/.venv/bin/python`.
A five-candidate discovery was preserved, then the exact input/output
contract for `graph.multigraph.cycle_multicover.check` was inspected.
Its read-only bounded contract allows at most 64 vertices, 2016 edges,
1008 cycles and target multiplicity 32; the replay uses only 2 vertices,
3 edges, 3 cycles and multiplicity 2. The payload is the exact old one.
Exactly **one** live mathematical operation was run:

```text
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run --operation graph.multigraph.cycle_multicover.check --payload-file research/draft_reviews/finite-certificate/replay/jacobian_payload.json
```

The live and old server versions are **0.14.0**, protocol **2025-11-25**,
transport **mcp-stdio**. The real adapter exited 0 and returned
`cycle_validity=[true,true,true]`, multiplicities `b0=b1=b2=2`,
empty missing/overcovered lists and `is_exact_k_cover=true`. There was no
structured error, timeout, incomplete result, or `UNKNOWN`. The server's
recorded operation runtime is 0 ms; no performance conclusion is drawn
from that resolution.

The discovery, contract, exact payload and full raw typed response are
dedicated `replay/jacobian_*.json` files. `replay/replay_result.json`
records their bindings, actual toolchain and comparison outcome. The
finite replay and adapter discovery, inspection, and execution returned success; no retry or
larger search was performed.

## Dependencies, omissions, and judgement

This unit needs only exact rational arithmetic and the specified finite
graph's incidence data. Its geometric interpretation depends on the
`collar-root` unit, not conversely. The universal Lean core is independent
of these sampled parameters; a passing finite example cannot substitute
for its quantifiers.

The six final old Reviewer supports concern the five analytic claims and
the version-2 universal core. **There is no separate historical support
judgement for a universal theorem inferred from this example.** The old
certificate's pending-review label and the later six supports describe
different layers; neither turns this example into a complete-paper
verification.

**Gap within the finite assertions: none found.** The concrete limitations
are arbitrary graphs, arbitrary residue curves, all coefficient degrees,
locally uniform convergence, the existence and etaleness of algebraic
covers, and full inverse-image geometry. This unit supplies no evidence
that refutes a manuscript, no new analytic theorem, and no improvement over
the earlier mathematical result. Its improvement is an isolated exact
replay with a fresh typed result and correct scope.

Native independent Reviewer acceptance of this unit and family coverage
remains pending.
