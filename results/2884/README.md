# Result 2884

## K3 Problem 4.8 scope observation

**Status:** scope-level result with source and logical-composition review  
**Decided scope:** the general arbitrary-$X$ wording of Problem 4.8

**Still open:** the Fintushel--Stern K3 conjecture with $X=E(2)$ fixed
**Live result:** <https://open.argusbot.cn/results/2884>

Take

$$
Y=E(2),\qquad Z=S^2\times S^2,\qquad X=Y\mathbin{\sharp}Z,
$$

where $\sharp$ denotes the connected sum,
and let $F\subset Y\subset X$ be a regular elliptic fiber, with the
connected-sum ball chosen away from $F$. The ambient pair satisfies the
stated closedness, simple-connectivity, smoothness, square-zero, and complement
fundamental-group hypotheses.

The torus knots $T(2,3)$ and $T(2,5)$ are prime and are neither equal nor
mirrors. Knot surgery is local with respect to the disjoint connected sum, and
the published stabilization theorem supplies diffeomorphisms

$$
Y_K\mathbin{\sharp}(S^2\times S^2)
\cong Y\mathbin{\sharp}(S^2\times S^2).
$$

Composing these maps gives diffeomorphic knot-surgery manifolds for the two
non-mirror prime knots in the same fixed ambient pair.

## Boundary

The construction uses the reducible ambient manifold
$E(2)\mathbin{\sharp}(S^2\times S^2)$. It does not produce a counterexample for the
unstabilized K3 surface $E(2)$, and it does not claim to settle the historical
fixed-$X$ conjecture.

## Files

| File | Purpose |
|---|---|
| `EDITOR_NOTE_K3_PROBLEM_4_8.pdf` | Concise editor-facing scope note |
| `EDITOR_NOTE_K3_PROBLEM_4_8.tex` | LaTeX source for the editor note |
| `PROBLEM_4_8_COUNTEREXAMPLE.pdf` | Detailed mathematical report |
| `CERTIFICATE.md` | Human-readable witness and composition certificate |
| `certificate.json` | Structured certificate |
| `Problem48.lean` | Lean-checked conditional logical composition |
| `statement_fidelity.md` | Exact account of what Lean does and does not formalize |
| `lean_check.json` | Lean environment and check record |
| `C2884-LEAN-COMPOSITION.json` | Structured formalization-composition record |
| `SOURCES.md` | Bibliographic and source map |
| `verify_certificate.py` | Campaign-bundle replay program |

## Formalization boundary

Lean checks the composition from explicit topological hypotheses to the
counterexample witness. It does not formalize smooth 4-manifold theory,
Baykur's stabilization theorem, the elliptic-fiber complement calculation, or
the locality lemma from first principles. These inputs appear as theorem
hypotheses.

The archived Python verifier additionally expects source transcriptions and
Jacobian payload files from the larger campaign bundle. Because those files
are not all in the public result download, it is retained for provenance and
is not run by this repository's automated checks.
