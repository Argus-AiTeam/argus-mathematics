# Primary comparison

The bounded comparison below is not an exhaustive novelty search. A research
reader inspected the first six documents; the Engineer additionally inspected
the September 23, 2026 revision cited by the staged October paper. No identical
prior theorem was located. This establishes the improvement over the inspected
statements, not an absolute priority claim.

| Primary statement | What it supplies | What the present theorem adds |
|---|---|---|
| OpenAI, October 5, 2026, Theorem 1.1 | One compact convex invariant absorber per class, fixed positive rates, pointwise finite entrance | One set for the whole rate box; measurable schedules; compact-initial-set-uniform entrance |
| OpenAI public Lean endpoint at commit `4eaee87548250b2682affda7d05d947c05554bae`, `MassAction/Main.lean`, lines 59-80 | Fixed `kappa : Reaction N -> Real`; initial-point-dependent invariant polytope and bounds | The full bounded-kinetics theorem is not among those inspected exports |
| Craciun, arXiv:1901.02544v1, Theorem 4.1 | Variable-k weakly reversible systems embed in a toric differential inclusion | Embedding alone is not permanence, classwise absorption, or compact-uniform entrance |
| Gopalkrishnan--Miller--Shiu, arXiv:1305.5303v2, Theorem 1.1; Definitions 3.1, 3.14 and permanence definition | Permanence for strongly endotactic networks with compact positive reaction temperings | Arbitrary weakly reversible networks, without strong endotacticity or a single linkage class; the exact stronger invariant-convex/measurable/uniform-time conjunction |
| Craciun--Nazarov--Pantea, arXiv:1010.3050v2, Theorem 19 and definition of kappa-variable kinetics | Two-species endotactic permanence with bounded piecewise differentiable rates and invariant polygons | Arbitrary dimension and measurable schedules |
| Pantea, arXiv:1103.0603v3, Corollary 5.1 and definition of kappa-variable kinetics | Persistence of bounded weakly reversible trajectories with two-dimensional stoichiometric subspace | No a priori boundedness or dimension restriction, plus classwise absorption |
| Craciun, arXiv:1501.02860v3, Section 8, final Remark | Persistence of **bounded** variable-k weakly reversible trajectories | Global upper bounds and a common compact classwise absorber, with a compact-uniform entrance bound |

Relevant short source passages:

* October Theorem 1.1: "fix positive rate constants".
* Craciun 2019, Theorem 4.1: "can be embedded into a toric differential inclusion".
* Gopalkrishnan--Miller--Shiu: "Every strongly endotactic reaction network is permanent."
* Craciun--Nazarov--Pantea, Theorem 19: "Any two-species endotactic
  kappa-variable reaction system is permanent."
* Craciun 2026, Section 8, final Remark: "any bounded trajectory of a
  variable-k weakly reversible ... system is persistent." The adjacent footnote
  also allows endotactic systems through embedding. Boundedness is expressly
  part of the conclusion's hypothesis.

Primary URLs:

* https://github.com/openai/math/blob/4eaee87548250b2682affda7d05d947c05554bae/preprints/Uniform-Permanence-in-Weakly-Reversible-Mass-Action-Systems-October-5-2026/build/sections/introduction.tex
* https://github.com/openai/math/blob/4eaee87548250b2682affda7d05d947c05554bae/lean/OAI/Analysis/MassAction/Main.lean
* https://arxiv.org/src/1901.02544v1
* https://arxiv.org/src/1305.5303v2
* https://arxiv.org/src/1010.3050v2
* https://arxiv.org/src/1103.0603v3
* https://arxiv.org/html/1501.02860v3

The staged October introduction also cites Boros--Hofbauer,
doi:10.1137/19M1248431, Theorem 4.2, for a single-linkage-class invariant
absorber with variable rates. That source was not independently obtained in
this bounded lookup; it is not used as a proof input or as evidence that the
complete present theorem was already known. The cited primary statements
above suffice for the stated, explicitly bounded comparison.

The proof here is an extension of the October construction, not a new affine
approximation construction. Its extra mathematical content is a common
positive rate-box margin, the almost-everywhere minimum argument, uniform
compact continuation for measurable schedules, and a sum of scale delays
uniform over compact initial sets. Novelty and publishable significance remain
for independent Reviewer assessment.
