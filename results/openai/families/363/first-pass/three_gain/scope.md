# Scope and sources

The comparison result is the **five-gain** rank-seven lemma in both staged
manuscripts, not a purported three-gain assertion. October:
`research/openai_manuscript/Nonuniqueness-with-local-conservation-for-the-hard-sphere-Boltzmann-equation-October-5-2026/build/paper/10-nonconcentration.tex`,
Lemma `lem:five-gain-rank`, equations `nc:rank-map`. September:
`research/openai_manuscript/Nonuniqueness-for-the-periodic-hard-sphere-Boltzmann-equation-September-23-2026/build/sections/08-nonconcentration.tex`,
the same lemma and recursion. The preceding lemma `nc:uniform-pullback`
assumes a.e. full rank of a limiting map, local C1 convergence, uniformly bounded
densities on a common compact parameter set, and uniformly bounded target
functions on a common compact set converging to zero in measure.

The partner profile is the unique solution of

    u = sigma + alpha tanh(gamma (z - t u) / rho).

Here z is the third spatial coordinate, rho > 0, and sigma is a sign.
The manuscript parameters have alpha gamma >= 0. For t > 0 the derivative
with respect to u of the left side minus the right side is

    1 + (alpha gamma t / rho) sech^2(gamma (z - t u) / rho) >= 1.

The signs at infinity give existence, strict monotonicity gives uniqueness,
and the analytic implicit-function theorem gives a globally well-defined
real-analytic profile on (0,infinity) x R. The theorem under investigation
requires only this analyticity and axial direction, not the implicit formula.

B. S. Mityagin, *The Zero Set of a Real Analytic Function*,
arXiv:1512.07276v1 (2015), Proposition 0, is the standard analytic-null-set
bridge. Primary source obtained at https://arxiv.org/abs/1512.07276v1.
Its hypotheses are a connected open domain, real analyticity, and a function
not identically zero. A self-contained proof of the required implication
will also be included in the theorem proof.

A bounded web search on 2026-11-05 did not locate a primary source explicitly
stating the precise sharp three-gain theorem for arbitrary analytic axial
partner profiles. Search-generated claims that general BBGKY collision-history
machinery implies it were not verified and are **not** assumptions or novelty
evidence. Generic velocity regularization is not the same assertion.
Novelty and publishable significance remain unverified.

The five-gain proof uses coincident times: three earlier time columns supply
three spatial directions, and later angular columns supply velocity directions.
Trying to reuse that witness with only three gains fails: after the final-time
row is removed, only two independent time columns remain and all angular
position columns vanish at coincident times. This is an obstruction to that
proof route, not a counterexample to three gains or to either manuscript.

No staged false assertion has been established. In particular neither
manuscript claims that five gains are necessary. Their main PDE theorems,
compactness, cap separation, nonzero limiting mass, branching, entropy
admissibility, and local conservation are not certified by a rank theorem.
