# Full P=W and the outstanding operator route: Engineer assessment

**Disposition:** the full composite-rank P=W target is not established by
the old determinant-transfer work. Its separate operator/comparison route
is genuinely unresolved in this evidence, not refuted. Known results and
administrative goals are not counted as new mathematical contributions.

## Exact target, versions, and known baselines

Old `C_PW_FULL` v1 refers to `thm:main` of the OpenAI manuscript dated
2026-09-24, registry-reported revision
`4eaee87548250b2682affda7d05d947c05554bae`.
`build/sections/01-introduction.tex`, lines 39-54, asserts for a smooth
projective complex curve of genus \(g\ge2\), composite \(n\ge4\),
\(\gcd(n,d)=1\), and fixed degree-\(d\) determinant:
\[
P_kH^m(X,\mathbb Q)
=W_{2k}H^m(X^B,\mathbb Q)
=W_{2k+1}H^m(X^B,\mathbb Q),
\]
under the manuscript's nonabelian-Hodge identification, for every \(k,m\).
It expressly concerns **full cohomology**, including the nontrivial
\(\Gamma=\operatorname{Pic}^0(C)[n]\)-character summands.
The \(P\)-index is compared with **half** the actual weight.

The old background claims are `A_KNOWN_GL_PW` v1-2 and
`A_KNOWN_PRIME_REDUCTION` v1-2. The following are external known results,
not Argus discoveries:

| Result | Source/version and locator | Exact boundary |
|---|---|---|
| All-rank GL\(_n\) P=W for \(g\ge2\) | Maulik--Shen, published 2024, `doi:10.4007/annals.2024.200.2.3`, abstract; smooth coprime setup read in `arxiv:2209.02568v2` opening | Does not itself prove full fixed-determinant composite-rank variant P=W |
| Prime-rank variant P=W | de Cataldo--Maulik--Shen, `arxiv:2002.03336v1`, Theorem 0.2 | Prime rank, not arbitrary composite rank |
| Invariant reduction from GL\(_n\) | Same v1, Proposition 1.2 | The invariant SL summand only |

Primary readings and the published-abstract/full-text access distinction
are recorded in `../full-betti-lefschetz/primary_sources.md`. Combining
GL P=W with the prime-rank variant result gives the prime-rank full
conclusion; it does not supply composite-rank variant comparison.

Old `C9000043` v1 is an administrative disjunction: find and certify a
manuscript flaw, or independently verify/repair/generalize a theorem
with an accepted certificate. It is not a theorem about the spaces and
not the current task's acceptance contract. The old graph keeps it open.
This review neither revives its attack instruction nor invents a flaw to
satisfy it.

## What the positive result actually supplies

The strongest supported old result relevant here is full-cohomology
**Betti curious Lefschetz**, not just an invariant restriction. The
transfer, flag splitting, low-degree argument, and tensor cancellation
are assessed in `../full-betti-lefschetz/report.md`.
They establish a Lefschetz structure on the weight-graded side under the
specified inputs. Relative hard Lefschetz for the proper Hitchin map
gives the separate perverse-side Lefschetz structure with center
\(R=(n^2-1)(g-1)\), in the manuscript's normalization.

Two individually Lefschetz filtrations need not be equal merely because
their centers and raising class agree. The manuscript's comparison
criterion in `build/sections/02-lefschetz.tex` requires a **common**
lowerer with specific compatibility. The old algebraic certificate
checks neither that operator nor this identification of filtrations.

## The concrete obligations still standing

Old `L_COMMON_LOWERING` v1 requires an actual degree-\(-2\) endomorphism
\(f\) of the same full cohomology satisfying
\[
fP_k\subset P_{k-2},\qquad
fW_j\subset W_{j-4},\qquad
[[f,e],e]=-2e.
\]
Here \(e\) means cup product by the distinguished degree-two class.
A lowerer obtained only for one associated graded, one filtration, or the
invariant quotient is not this assertion. The required map and equations
must hold on the nontrivial \(\Gamma\)-summands too.

The manuscript source tree records the intended geometric construction,
not a separate old transfer certificate for it:

| Reference source | Mathematical duty for this route |
|---|---|
| `04-diagram.tex` | Control the diagram filtration/weights on the classes and correspondences that produce the same full-cohomology operator |
| `05-logarithmic.tex` | Establish the logarithmic-family restriction comparisons with the actual ordinary cohomology and relevant filtrations |
| `06-translation.tex` | Define moving-pole translation/monodromy and identify the resulting lowerer on that space |
| `07-specialization.tex` | Carry this operator through Hitchin-base specialization, with the normalized perverse lowering bound |
| `08-commutator.tex` | Identify the lattice Riemann--Roch commutator, including its sign and normalization, as \([[f,e],e]=-2e\) after all comparisons |
| `02-lefschetz.tex`, `09-conclusion.tex` | Check and apply the two-filtration criterion to these exact full-cohomology maps and all indices |

The concrete missing support in the **old Argus draft family** is a
checked passage through these identifications and simultaneous bounds.
Its transfer proof deals with the Betti eigenvalue family, not every
logarithmic or Hitchin-base family. Smoothness of a nonproper family
does not by itself fill those restriction/base-change duties.
The \(2\times2\) Koszul homotopy contracts monodromy cochains when one
coefficient is invertible; it is not a construction of \(f\) on moduli
cohomology, and its relation \(Dh+hD=I\) is not the stated double
commutator. This is the precise reason that replaying it cannot close
`L_COMMON_LOWERING`.

Old `L_COMPARISON` v1 states the conditional assembly once this lowerer
and the Betti input are available. The conditional implication is not
evidence that its hypotheses have been met. Route
`R_PW_COMMON_LOWERING` therefore retains the AND-obligations
`C_BETTI_CHL`, `L_COMMON_LOWERING`, and `L_COMPARISON`.
It is not retired as false and is not pursued here as new proof research.

## Assessment rather than a new attack

The manuscript reference tree has thirteen enumerated files; its assembly,
notation and bibliography are support, not independent mathematical
results. The mathematical sections above give provenance for the
unresolved claims. This unit is not a promised fresh lemma-by-lemma
audit of the entire reference manuscript, and it makes no claim that an
unchecked geometric step is wrong merely because the old audit did not
certify it.

The historical ledger has no supporting judgment for `C_PW_FULL`,
`L_COMMON_LOWERING`, `L_COMPARISON`, or `C9000043`; the proof graph leaves
them open and reviewer-unconfirmed. Those labels agree with the explicit
boundary in the old report's introduction and closing paragraphs.
Conversely the historical positive Betti judgments are not discarded:
they support a genuinely narrower mathematical conclusion.

No Lean source exists among these inputs and no formal proof is claimed.
The successful original exact replay is irrelevant to closing these
operator obligations. The applicable known results are credited to their
authors; the proposed composite-rank strengthening remains unresolved in
this review's evidence and its novelty is unverified.

Relative to the strongest prior result, this review supplies no stronger
theorem. Its improvement is complete provenance-aware assessment and a
specific separation of a supported Betti theorem from the remaining full-P=W
requirements. Family-wide acceptance is for the native Host-invoked
independent Reviewer, not the Engineer.
