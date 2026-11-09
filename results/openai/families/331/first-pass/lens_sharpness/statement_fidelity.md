# Statement fidelity: the exact rooted-star certificate

`Main.lean` formalizes a finite polar-norm certificate, not the unresolved
universal upper estimate and not an infinite-dimensional Banach-space theorem.

The objects are three real coordinates, ordered as a root and two distinct
children. `LensSharpness.starEnergy u v w` is the maximum of the squared
segment-test energies for the three partitions of this star into disjoint
segments: all singletons, root joined to the first child, and root joined to
the second child. Every smaller disjoint family extends to one of these
partitions by adding unused singletons.

`HasSquaredDualNorm a b c n` asserts nonnegativity of `n`, the bound
`(a*u+b*v+c*w)^2 <= n*starEnergy u v w` for every real test, and equality
at a test of strictly positive energy. Since the singleton partition makes
the energy positive definite and homogeneous of degree two, this is exactly
a squared polar-norm certificate, rather than a bound on a sampled set.

`center_squared_norm`, `tail_squared_norm`, `plus_squared_norm`, and
`minus_squared_norm`, combined in `exact_star_certificate`, certify respectively
the coefficient vectors `(4,0,0)`, `(0,3,-3)`, `(4,3,-3)`, and `(4,-3,3)`
with squared dual norms `16`, `18`, `25`, and `25`. The equality witnesses
are `(1,0,0)`, `(0,3,-3)`, `(4,0,-3)`, and `(4,-3,0)`.
There are no restrictions on the universally quantified primal tests.
`exact_lens_ratio` and `excludes_smaller_constant` certify the resulting
ratio `18/(25-16)=2` and exclusion of every real `k<2`.

The transfer to the two manuscript spaces is a separate prose argument in
`report.md`: the star is finite ancestral in each ambient tree, restriction
of an arbitrary disjoint segment family to it consists of disjoint segments,
and therefore its coordinate projection is contractive. This is what
identifies the finite polar norm with the inherited ambient dual norm.
Lean does not encode that transfer, the ambient completions, arbitrary
ancestral heads, arbitrary displacement heads, or a universal upper bound.

`joint_scalar_bound` proves the last scalar estimate of the manuscript's
existing budget argument. Its real variables satisfy only
`a^2+b^2=2*c^2`; no nonnegativity is needed for that squared estimate.
`joint_scalar_coefficient_not_two` refutes the proposed improvement of
that scalar estimate to coefficient two, even with nonnegative variables.
It concerns our attempted shortcut, not an assertion made by the manuscript.

The formal certificate supplies neither independent review of this
translation nor a novelty or publishability verdict.
