# Manuscript dependency boundary and historical record

**Engineer assessment: contextual assertions are explicitly unexamined, not
accepted or refuted.** This unit accounts for dependency nodes; it is not
an additional substantive Argus result or a whole-manuscript error search.
Native independent acceptance of the complete review remains pending.

## Sources and exact attribution

The reference directory contains the primary manuscript *Primitive roots
for every admissible integer base* and the secondary *Simultaneous primitive
roots: a conditional lower bound for prime bases*, both labelled October 4,
2026. The supplied manuscript manifest pins revision
`4eaee87548250b2682affda7d05d947c05554bae`. All 25 listed TeX sources
match that manifest through both path locations, but the old manuscript
child directories are symlinks resolving to exactly the assigned reference
directories. They are aliases, not independent old copies. This establishes
the current reference version, not correctness or historical target bytes.
The five core Family 029 artifacts match the existing snapshot manifest;
the other 16 supporting artifacts and manuscript directory are not thereby
shown archived. No archive or provenance manifest was rebuilt.
The reference directory reaches exactly 27 files, the 25 manifest TeX
entries and two README files, when those declared manuscript links are
followed. The initial non-following directory check could see neither
manuscript; it was corrected to check the targets against the manifest
before following them, not treated as missing mathematical evidence.

The primary theorem asserts the dyadic lower bound `c_a x/(log x)^2`
for primes where a fixed integer `a!=-1`, not a square, is primitive.
The secondary theorem is explicitly conditional on four inputs and fixes
any finite list of distinct positive prime bases. Its introduction,
lines 23-47, says the companion proofs of those inputs are outside that
paper's scope. Thus the four inputs are manuscript hypotheses, not four
results established by the Argus reflection draft.

## Disposition of every contextual claim

| Old identifier | Role and disposition |
|---|---|
| `C9000029` | Historical umbrella research objective, superseded as an instruction. It does not require this review to discover a counterexample or solve a new problem. |
| `C_PRIMARY_MAIN` | Primary primitive-root lower bound. No complete proof or refutation is supplied by the reflection audit. |
| `C_PRIMARY_CONTROLLED` | Controlled-prime construction `p=crQ+1` with large `Q` and restricted factors of `r`; unexamined contextual sieve result. |
| `C_PRIMARY_SPLITTING` | Uniform splitting-prime estimate; unexamined, dependent on the zero-free chain. |
| `C_PRIMARY_ZERO_FREE` | Unrestricted finite-order Hecke zero-free assertion `Re(s)>1-10^(-6)` over the stated cyclotomic fields; not checked here. Reflection is only one dependency. |
| `C_POISSON` | Principal residue/Euler-product analysis; unexamined. The use of elementary Poisson as an arithmetic input is not a verification of this separate analytic node. |
| `C_ZERO_DETECTION` | Conductor sieve and nonprincipal-frequency zero detector; unexamined. |
| `C_MELLIN_CONTINUATION` | Comparison-integral continuation and zero exclusion; unexamined. Correct Gaussian convolution alone does not establish it. |
| `C_SECONDARY_MAIN` | Simultaneous primitive-root lower bound, conditional on the four inputs below; neither made unconditional nor refuted by this review. |
| `C_SECONDARY_RESERVOIR` | Controlled prime reservoir conditional on marked Type II, block sieve and density; unexamined. |
| `C_SECONDARY_SPLITTING` | Secondary splitting-obstruction estimate conditional on Hecke input; unexamined. |
| `C_INPUT_HECKE` | An explicit imported hypothesis of the secondary paper, linked to `C_PRIMARY_ZERO_FREE`; not a proof of that primary assertion. |
| `C_INPUT_MARKED` | Shared marked Type II uniformity/cancellation hypothesis; unexamined by the reflection draft. |
| `C_INPUT_BLOCK` | Shared block-sieve remainder hypothesis, including its `H=2` case; unexamined. |
| `C_INPUT_DENSITY` | Shared rough-density identity/error hypothesis; unexamined. |

The other 14 identifiers, including `C_REFLECTION_AUDIT`, have primary
dispositions in the three substantive unit reports. The index maps each
identifier once, rather than presenting contextual nodes as silently
verified assumptions.

## Why conclusions cannot propagate further

The old graph records primary main -> controlled primes and splitting;
splitting -> zero-free; zero-free -> reflection, Poisson, zero detection and
Mellin comparison. Controlled primes additionally use marked Type II, block
sieve and rough density. Even unconditional reflection would leave these
other obligations. A local identity would be further upstream still.

The secondary main theorem uses reservoir and splitting. The former uses
three combinatorial inputs; the latter assumes the Hecke input linked to
the primary zero-free assertion. These are conditional logical dependencies,
not a circular claim that citing a companion manuscript proves its theorem.
This review neither certifies those reductions nor opens a new attack on
their truth.

The precise unexamined obligations are the statements attached to the
identifiers above: for example, uniform control of nonprincipal Poisson
frequencies and justification of the Mellin zero-exclusion implication,
not merely access to a missing source. Their unresolved status is an
honest scope boundary, not a claim that either main theorem is correct.

## Historical opinions, routes and exclusions

There are 29 distinct old claim IDs in 41 version records and 29 graph
nodes, including `C_REFLECTION_ALGEBRA`. The repeated versions are
`C_THETA_INPUT` 1-6, `C_ARITHMETIC` 1-5,
`C_GLOBAL_FACTORIZATION` 1-3 and `C_QUADRATIC_SIEVE` 1-2.
Their assumption additions are not additional results.

All 19 old evidence records are **judgements**, not mechanical or literature
certificates. The index enumerates each record's subject, artifact and actor.
The old actor named `reviewer:copilot-independent` has historical supportive
and inconclusive opinions; none is the current Host-invoked acceptance.
The graph's open nodes and `reviewer_confirmed:false` are consistent with
not promoting these opinions into closed theorems.

The ledger has three routes, although the graph's route array is empty:
`R_THETA_NORMALIZATION` addresses cover, local values and factorization;
`R_ALL_PARAMETER_REFLECTION` addresses the whole reflection assertion;
`R_FINITE_SAMPLES_ONLY` is retired because finite primes/valuation cutoffs
cannot prove an all-parameter analytic moment. That exact reason is retained
in the active index and ledger assumption, not erased or retried.

There is no distinct exact counterexample, completed mathematical attack
or novelty-certified strengthening among the listed drafts. An unmatched
Jacobian Gauss-operation search and failed download responses are failed
tooling/retrieval, not failed mathematical proofs. The lock file is empty;
vendor TeX is build support. None is omitted or counted as a theorem.

## Active check boundary

All writes are confined to the four authorized path patterns. No active
`research/PROOF_GRAPH.json` was supplied, and creating it is outside those
patterns. The official check at the exact campaign root returned ledger
exit 0 and graph exit 2, the latter explicitly "no proof graph"; it was
not represented as a passing graph check or repaired in a sibling project.
The task is an exploratory, `stage:scope` old-draft review, not an
independent counterexample campaign or a targeted develop/certify proof.
If a higher-stage graph gate is nevertheless imposed, missing graph/write
authority is a real unresolved delivery gate, not permission to fabricate
a graph or weaken a mathematical claim. Native review must retain this
distinction.
