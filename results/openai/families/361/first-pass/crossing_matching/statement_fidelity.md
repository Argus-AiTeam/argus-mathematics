# Statement fidelity: the infinite matching core

The claim is `C_CM_FORMAL_CORE`, not the complete analytic theorem
`C_CM_UNIFORM`.

All four declarations below are in the namespace `CrossingMatching`.
The definition `clamp` is exactly the real function
`x -> max(-1,min(1,x))`.

`product_fixedPoint_of_finite` quantifies over an arbitrary
index type `I`, a family of compact Hausdorff topological spaces `K i`, and a
continuous self-map of their full product with the product topology. Its
explicit hypothesis says that **every finite collection of coordinate
fixed-point equations has a solution in the same full product**. Its conclusion
is one point satisfying all coordinate equations simultaneously. In the
application, the factors are the closed column and control intervals.
Finite-dimensional Brouwer proves the finite-solvability hypothesis in the
mathematical report; the Lean theorem does not prove Brouwer or assume a
uniform-norm continuity statement. The index need not be finite or countable.

`clamp_fixed_forces_zero` concerns arbitrary real numbers
`z,d`. It assumes `-1 <= z <= 1`, the implications
`z=1 -> d>0` and `z=-1 -> d<0`, and the equation
`z=max(-1,min(1,z-d))`. It concludes `d=0`. The endpoint signs are
hypotheses, not consequences of compilation. This is precisely the control
equation used at every incoming crossing cut.

`normalized_line_iff` quantifies over every finite real
square matrix, distinguished coordinate, two real columns, and a nonzero
real multiplier. It assumes that the target column has distinguished
coordinate one and that the multiplier equals the corresponding coordinate
of the image column. Exact line invariance is equivalent to all the other
normalized coordinate equations. The source column need not itself have
distinguished coordinate one, so the lemma also covers the manuscript's
normalized source columns. Positivity of the multiplier is supplied by the
analytic estimates, not by this lemma.

The source has no custom axioms, `sorry`, `admit`, or deferred obligations.
The compiler checks these infinite compactness and algebraic implications.
It does **not** check the PDE freezing estimates, the Gaussian weight
estimates, spectral perturbation theory, the applicability of Brouwer,
the angular-program existence, Ricci curvature, novelty, or the full
harmonic-dimension comparison counterexample. Those distinctions are part
of the claim, not exceptions to it.
