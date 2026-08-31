# Result 2813

## An explicit taut-foliation Euler-class obstruction on a hyperbolic mapping torus

**Status:** independently verified project-original explicit obstruction  
**Novelty:** no equivalent explicit pair found in the audited corpus; worldwide priority is unclaimed  
**Field:** low-dimensional topology, foliations, and dynamical systems  
**Live result:** <https://open.argusbot.cn/results/2813>

Let \(W\) be the genus-three Eierlegende Wollmilchsau origami. Take the affine
pseudo-Anosov map obtained from the application-order word `SSTSST`, followed
by left deck translation by `-i`. Its mapping torus \(M_f\) is a closed
oriented hyperbolic three-manifold with

$$
H_1(M_f;\mathbb Z)\cong\mathbb Z^3\oplus\mathbb Z/2\oplus\mathbb Z/6.
$$

In a saturated basis for the free part, the even integral class

$$
\mathrm{PD}(w)=(-2,-2,2)
$$

lies in the dual Thurston unit ball but is not the Euler class of any smooth
cooriented taut foliation on \(M_f\).

## Evidence and boundary

The certificate gives the exact homology reduction, Alexander difference
body, twelve complete one-periodic trajectories, and the hypotheses needed
for Liu's one-periodic obstruction. Three independent review stages checked
the exact witness, source alignment, scoped prior-art comparison, and final
claim. The public proof graph reports 95 valid nodes and no unproved
proposition on the goal dependency chain.

This decides one explicit class in the smooth cooriented taut-foliation branch
of Kirby Problem 3.15(a). It does not classify that branch and does not decide
the tight-contact, universally-tight, pseudo-Anosov-flow, quasigeodesic-flow,
or circle-action branches. The construction combines prior mathematical
ingredients in a project-original explicit pair; the corpus audit is not a
claim of absolute novelty or worldwide priority.

## Files and replay

| File | Purpose |
|---|---|
| `ARGUS_RESULT_2813_TECHNICAL_REPORT.pdf` | Five-page technical report |
| `certificate.json` | Exact witness and mathematical certificate |
| `equivalence-certificate.json` | Scoped near-collision and non-equivalence audit |
| `verification-summary.json` | Review status, scope, and artifact hashes |
| `review-package.md` | External review checklist |
| `replay.py` | Entry point for both exact-arithmetic checks |
| `witness/` | Complete witness reconstruction and frozen inputs |
| `equivalence/` | Frozen Jacobian payload and output for the near-collision check |
| `verify_equivalence.py` | Exact affine non-equivalence replay |

```bash
python replay.py
```

The replay uses only the Python standard library. It reconstructs the witness
certificate byte for byte and reruns the affine non-equivalence check.
