# Family report: the supplied manuscripts and Argus's earlier work

**The reviewed old drafts support both manuscripts' assessed constructions and three scope extensions; they do not certify every manuscript assertion or establish global novelty.** This synthesis uses the seven existing assessments and their native reviews, not a new mathematical investigation. Source identity, complete coverage and detailed qualifications are in [OLD_ROUND_REVIEW.md](OLD_ROUND_REVIEW.md) and [DRAFT_REVIEW_INDEX.json](DRAFT_REVIEW_INDEX.json).

## The two constructions

| Manuscript | Bottom line in the checked scope | Why the argument holds |
|---|---|---|
| OpenAI, October 5, 2026, *A stable coordinate that is not a coordinate in four variables* | The exact degree-five polynomial is not a coordinate, becomes one after adjoining one independent variable, and has affine-three-space fibres with nonrectifiable embeddings. | The [literal presentation and stabilization assessment](draft_reviews/october-polynomial-stabilization/report.md) checks polynomial inverses and treats zero and nonzero fibres separately. The [unrestricted obstruction assessment](draft_reviews/october-unrestricted-obstruction/report.md) transfers a hypothetical coordinate to a nonzero locally nilpotent derivation, lifts the action to the determinant bundle, and contradicts rigidity. |
| OpenAI, September 24, 2026, *An explicit noncoordinate polynomial with affine three-space zero fibre* | The specified zero fibre is affine three-space, but the polynomial is not a coordinate even after any finite polynomial extension. | The [September assessment](draft_reviews/september-construction-critical-point/report.md) gives explicit inverses for the lifting algebra and cusp construction. An exact critical point has zero gradient; the inverse chain rule excludes stable coordinateness. This is a proof, not merely the finite gradient evaluation. |

These are distinct constructions, not successive versions of one polynomial. September's critical-point obstruction persists under stabilization; October requires the stronger all-derivations obstruction precisely because its polynomial is one-stable. Their common lesson is that an affine-space fibre need not be an ambient coordinate hyperplane.

## What Argus actually achieved

The October and September assessments are **confirmed reproductions in their stated scope**, with substantive prose arguments as well as retained computational and formal checks. The three extensions below are supported beyond the inspected October statements; their global originality remains undetermined.

| Extension | Exact improvement and dependency |
|---|---|
| [Universal principalization](draft_reviews/universal-principalization/report.md) | The ideal identity holds for arbitrary \(t\) in every commutative unital ring, including zero divisors and the zero ring. Integral witnesses prove both inclusions without cancellation. |
| [Lower-perturbation rigidity](draft_reviews/lower-perturbation-rigidity/report.md) | Over a characteristic-zero field, the fixed perturbation is replaced by every \(W\) with actual auxiliary degrees at most one. Fibre-weight preservation remains essential; arbitrary-sign leading shifts are allowed. |
| [Uniform surface family](draft_reviews/uniform-surface-family/report.md) | For every polynomial \(\psi\), including zero and repeated roots, the exact embedded subscheme has quotient \(\mathbb C[X,R,V]/(RV-\psi(X))\) and is preserved by no nonzero ambient locally nilpotent derivation. This uses the preceding two cores and the unconditional action lift, not an extrapolation from finitely many \(\psi\). |

The most consequential findings are the scope-qualified support for the constructions, followed by these relative strengthenings. The [provenance assessment](draft_reviews/provenance-known-status/report.md) also corrects Argus's reading of the Kaliman-Makar-Limanov domain convention; the actual domain proof is unaffected. The historical v2 compiler artifact is **invalid**, but its failure is not a refutation of the natural-language theorem or either manuscript.

## Evidence and limits

The index covers all **239 artifacts and 24 historical claim versions across seven units**; copies, compiled dependencies and job records are not additional results. The retained evidence includes 81 exact algebra checks, a successful eight-declaration Lean wrapper replay against cached imports, and one bounded Jacobian gcd calculation. These are not an enumeration of all derivations or a fresh rebuild of all formal dependencies. September, the arbitrary surface family and the complete fibre/embedding package have substantive prose support, not direct coverage by the eight printed Lean declarations.

The five corrected ledger attachments are report-backed judgments by the native reconciliation Reviewer, not compiler certificates. The prior whole-project acceptance and bounded correction are distinguished in [OLD_ROUND_REVIEW.md](OLD_ROUND_REVIEW.md); renewed acceptance of this corrected submission and Host certification remain pending. No blanket manuscript correctness, publication significance or global originality is claimed; the family result's novelty is not applicable.
