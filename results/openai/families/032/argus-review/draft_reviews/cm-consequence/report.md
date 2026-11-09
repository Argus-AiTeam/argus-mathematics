# Conditional CM input and all-powers consequence

**Unit:** `cm-consequence`. **Engineer assessment:** the stated conditional
deduction is valid, but the unconditional old `CM-INPUT` assertion is not
established by the supplied evidence. Independent acceptance of this
assessment remains with the native Host Reviewer.

## Source, attribution, version and exact scope

The Argus draft is Campaign 9000032's November 5, 2026
`research/cm_dependency_audit/report.tex`, Sections 1 and 5, against
old `CM-CONTEXT` v1 and `CM-INPUT` v1. It imports the OpenAI
`MainSolution.hodge_conjecture_for_cm_abelian_varieties` source at
commit `4eaee87548250b2682affda7d05d947c05554bae`,
Lean 4.34.1, Mathlib `d13f23b723b8a846827a245b89c10fc7d3f11612`.
Its imported declaration and ordinary-geometric reading are assessed in
the two neighboring CM units, rather than counted as new results here.

The strongest relevant prior mathematical result is the **all-degree**
`DS-UNIVERSAL` v1, supported by historical
`judgement-DS-UNIVERSAL-2f3fe694c61c`, with actual-group prerequisite
`AG-UNIVERSAL` v1 and
`judgement-AG-UNIVERSAL-e61885343dda`. A larger finite calculation would
not strengthen it. The current reports reassess that precise prose result,
not a sampled substitute.

For a complex abelian variety \(A\) with a **unital** imaginary-quadratic
action, the allowed families are:

1. \(\dim A\leq5\), with no separate signature restriction; or
2. \(\dim A=6\) and an **actual compatible polarization** has a rational
   homological Hermitian form hyperbolic of signature \((3,3)\).

Mere complex signature is insufficient in the second family. The
conclusion is all self-powers \(A^m\), \(m\geq1\), in every codimension
\(p\geq0\). There is no assertion of saturation after adjoining an
arbitrary CM companion, nor of supplying the full cohomology of \(A\).

## The exact conditional theorem and its decisive argument

Assume the reviewed DS supply-and-Hodge-lift theorem, with its explicitly
stated imports, and assume **ordinary rational Hodge algebraicity on
every CM source in every codimension**. Then the rational Hodge
conjecture holds on every allowed self-power in every codimension.

Indeed, for a rational Hodge class \(\alpha\in H^{2p}(A^m,\mathbb Q)\),
DS supplies a rational Hodge lift through finitely many correspondence
maps
\[
\bigoplus_\nu H^{2p-2j_\nu}(B_\nu,\mathbb Q)(-j_\nu)
 \longrightarrow H^{2p}(A^m,\mathbb Q),\qquad
\Gamma_\nu\in
\mathrm{CH}^{\dim B_\nu+j_\nu}(B_\nu\times A^m)_{\mathbb Q},
\]
where \(B_\nu\) is an ordinary CM abelian variety, possibly a point.

It is crucial that DS supplies a **rational Hodge lift**, not merely an
arbitrary cohomological preimage. Its \(\nu\)-th component before the
Tate twist has type
\((p-j_\nu,p-j_\nu)\) and degree \(2(p-j_\nu)\).
Nonexistent cohomological degrees contribute zero. For any nonzero
component, the ordinary CM hypothesis gives a rational cycle
\(z_\nu\in\mathrm{CH}^{p-j_\nu}(B_\nu)_{\mathbb Q}\).
Algebraic correspondence composition and pushforward give target
codimension
\[
(p-j_\nu)+(\dim B_\nu+j_\nu)-\dim B_\nu=p.
\]
The finite sum of these target cycles represents \(\alpha\).
Negative correspondence shifts \(j_\nu\) cause no error in this formula;
only existing source degrees and cycle groups are used. Degree zero is
covered by a point. This proves the conditional statement for every
\(m,p\), not a bounded-degree experiment.

The imported formal CM conclusion, **if valid with the ordinary
interpretation**, provides exactly this input: finite rational spans of
ordinary codimension-\(r\) component classes on every ordinary CM source.
It need not algebraize every cohomology class. An untwisted source Hodge
class is the specific object to which it is applied.

## External assumptions and dependencies

The DS theorem uses actual derived-group independence, classical
all-degree invariant spanning, its algebraic operations/Hodge lifts,
fixed-list integral balance, and polarized padding. Its direct external
inputs are:

| Input | Canonical proposition |
|---|---|
| MARKMAN-WEIL | `arxiv:2502.03415v2`, Theorem 1.5.1 and Section 1.1 |
| MEYER | Peters--Sterk, Version JUNE 2024 / September 16, 2024, Corollary 3.3.4, printed p.77; author-hosted PDF |
| HERMITIAN-CONVENTION | `doi:10.1007/978-3-540-49046-3_5`, author-version Lemma 5.2(2)--(5), pp.6--7 |
| FFT-SP | `doi:10.4171/JEMS/558`, Theorem 4.1 and Corollary 4.2, p.2325 |
| FFT-SO | `doi:10.4171/LEM/63-1/2-6`, Theorem 2.1, Remark 2.2, Example 4.1 and Corollary 4.2 |
| FFT-SL | `doi:10.1016/j.jalgebra.2007.10.039`, author PDF Section 5 p.10, definitions pp.1,3--4 |

AG contributes the ALBERT, HODGE-GROUP, DYNKIN and
MINUSCULE-DIMENSION inputs documented in its own report. The exact
statements, hypotheses and historical independently read excerpts are
preserved there and in the index. This conditional deduction additionally
uses ordinary cycle-class functoriality and correspondence calculus.
It does not independently verify Markman's theorem or the Weil
manuscript's different geometric-tail reconstruction of it.

**Ordinary CM algebraicity is an explicit premise here, not a discharged
external assumption.** The current ledger records the conditional theorem
and the separate open `CM-INPUT` claim; it does not mark the latter
closed because the conditional implication is sound.

## Why the unconditional input remains open

The old route `CM-PUBLISHED-REUSE` is an AND:
`CM-KERNEL` **and** `CM-APPLICABILITY` are both required. Neither is
replaced by the other.

The applicability assessment supports the source-level ordinary-CM
construction and identifies the actual coefficient/filtration/component
maps. It is not a kernel check. The kernel assessment verifies local
source integrity and identifies the precise source proof, but finds no
completed target replay, no extant local wrapper/native certificate,
and no actual elaborated target or axiom output. Its fresh pinned import
diagnostic fails before target elaboration; that failure neither proves
nor refutes the CM Hodge theorem.

Consequently the word **if** in the old corollary must remain. The
concrete unresolved obligation is the exact-pin source-bound target
verification and axiom/statement output, together with independent
ordinary-geometric fidelity judgement. No additional determinant search,
finite balance calculation, arbitrary-companion strengthening or new
manuscript-error campaign is needed to state this assessment.

This is an old Argus conditional composition of reviewed reductions and
an imported OpenAI claim, not a new unconditional proof, a formal
all-powers theorem, a refutation, or a verified novelty claim. The
mathematical improvement made by this review is clarification of precisely
what the strongest prior result still needs, not a stronger theorem.
