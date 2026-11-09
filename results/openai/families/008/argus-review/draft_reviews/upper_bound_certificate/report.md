# Rational upper bound: endpoint, fidelity, and all-weight assembly

**Engineer assessment: supported as a reproduction with reused formal evidence
and explicit prose base cases; not a new all-weight Lean certificate.**

## Exact result and attribution

Write `OLD` for `campaigns/9000008`
and `CERT` for `OLD/research/upper_bound_certificate`. All historical paths
below are read-only.

The claim is

    for every n >= 0, dim_Q W_n <= dim_Q F_n,

where `W_n` consists of weight-n elements of the ordinary rational free Lie
algebra on `x,y` satisfying precisely

    p(x,y) + p(y,x) = 0,
    p(x,y) + p(y,-x-y) + p(-x-y,x) = 0,
    p(t12,t23+t24) + p(t13+t23,t34)
      = p(t23,t34) + p(t12+t13,t24+t34) + p(t12,t23).

The last equality is in the infinitesimal four-strand braid Lie algebra.
`F_n` is the weight-n part of the ordinary free Lie algebra on generators of
weights `3,5,7,...`. These are weights, not lengths in the odd generators.
There is no extra special-identity assumption on the rational solution space.

This is the manuscript's `cor:dimension-bound`, not a new Argus theorem.
The source is OpenAI, *The Deligne-Drinfeld conjecture*, September 23, 2026,
revision `4eaee87548250b2682affda7d05d947c05554bae`, Sections 1-5. The
reference sweep matched all thirteen TeX/figure bindings in the supplied
`9100008/MANUSCRIPTS.json`. The imported implementation is
`OAI.DeligneDrinfeld.RationalBound.finrank_Wn_le`, in `Ihara.lean:1259-1278`
at that revision.

## Decisive evidence and statement fidelity

`CERT/Main.lean` proves only

    upper_bound_gt_two (n : Nat) (hn : 2 < n) :
      Module.finrank Q (Wn n) <= Module.finrank Q (Fn n).

It invokes the upstream theorem, rather than assuming it as a new axiom.
The two `rfl` proofs identify the wrapper's displayed three-equation predicate
with `IsSolution` and membership in `W`. They do not prove that the manuscript
was translated correctly. That additional reading is supported by the
accepted fidelity document, the printed definitions in the compiler output,
the reference comparison, and the historical independent fidelity judgment.
Strands `0,1,2,3` are the paper's `1,2,3,4`; `Wn` intersects `W` with the
ordinary weight piece; `Fn` assigns weight `2*k+3` to generator `k`.

The finite-dimensional interpretation is substantive. At fixed weight there
are finitely many ordinary bracket trees on the two generators. On the right
only finitely many indices with `2*k+3 <= n` occur. The upstream proof also
establishes finite-dimensionality by injective coordinates
(`Ihara.lean:1183-1195`). The bound is not exploiting `finrank`'s value on an
infinite-dimensional space.

The accepted certificate
`CERT/certificates/C_UB_GT2-2c372ff5ea7abe86.json` records compiler exit 0,
proof-hole audit exit 0, no proof holes, and exactly `propext`,
`Classical.choice`, and `Quot.sound` in the printed axiom closure. It binds
the exact wrapper and fidelity text. This is historical **Lean 4.34.1**
evidence, with Mathlib revision
`d13f23b723b8a846827a245b89c10fc7d3f11612`, not Lean/Mathlib 4.31 evidence.
Six OAI dependencies were compiled: Foundations, Ordering, Grading, Transport,
Reduction, and Ihara. Their source pins, build exits and binary bindings are
recorded separately; submission receipts and empty logs alone prove nothing.

The current `reuse_check.json` establishes that the wrapper, accepted fidelity
document, all six upstream source files, and all six compiled OAI binaries
still match the historical bindings. The live executable reports Lean 4.34.1,
commit `5045d0056413266e57c625dcd7c365b10e377c52`. The old matching Mathlib
workspace `CERT/.lake/packages/mathlib` is **absent**. No fresh compilation,
dependency restoration, or whole-Mathlib rebuild was performed or claimed.
This limits immediate replayability, not the content of the preserved
source-bound compiler result. No Lean source was introduced into this project.
The check does not claim to rehash the entire historical Mathlib cache.

## All weights and the apparent historical conflict

The complete argument is the `n>2` theorem plus the exhaustive proof of
`W_0=W_1=W_2=0` in [the low-weight assessment](../low_weights/report.md).
Consequently `C_UB_ALL` has mixed formal/prose support. The flag
`all_weights=true` in the old package is not evidence that Lean proved the
three base cases or that `C_UB_ALL` itself earned kernel closure.

The old ledger contains later `reviewer:gpt-6.1-sol` support for `C_UB_GT2`,
`L_UPSTREAM_FIDELITY`, `L_LOW_WEIGHTS`, and `C_UB_ALL`; in particular its
judgment identifiers end in `c93c9279064b`, `819fc1655f9b`, `4f51b0196ca2`,
and `23d50c25b04b`. The report, exact package, and proof graph retain
pending/open labels. Both sets of records match the preserved snapshot where
listed. There is no need to choose one label as mathematical authority:
the source-bound compiler evidence supports `n>2`, the explicit base-case
argument supports the remaining cases, and the later judgments document a
historical review that did not propagate into the older summaries. They do
not constitute this mission's native independent acceptance.

The failed 4.31 attempt reports incompatible dependency APIs, not a false
theorem. The earlier `attempt_fidelity` actually compiled but was refused for
declaration-name documentation; it has a different fidelity hash and the same
source hash. The later accepted receipt followed a real compiler run with
the corrected document. Neither attempt is a second mathematical result.

## Supported scope and limits

The old work is a reproduction of an existing universal upper bound, plus
Argus's wrapper, base-case explanation, auxiliary checker and provenance
work. Originality and novelty of a mathematical theorem are not established.
The bound alone does not certify every literal intermediate lemma, the
category/holonomy/induction construction, or the whole manuscript. The
separate assessments explain exactly what the detailed route's local checks
do and do not support. A free odd-generator lower bound is an independent
known result; it is not supplied by this compiler endpoint.

No unresolved mathematical obligation remains for this stated inequality
when the unchanged historical formal receipt and the explicit base-case
proof are taken on their stated terms. The remaining delivery obligation is
the native independent Reviewer's examination of this coverage and
assessment. A request for a *new* compiler certificate would additionally
require an authorized matching dependency setup; the current review does not
silently substitute a version probe for such a run.
