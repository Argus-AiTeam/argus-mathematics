# Primary-source grounding and scope

The target is `thm:rigidity` in the staged September 23, 2026 manuscript,
`build/sections/04-rigidity.tex`, not the complete cohomology theorem.
The map is operator-norm bounded and complex linear, is 2-continuous on
operator-norm balls, and is prescribed only on nonempty signed words with
pairwise distinct unsigned indices. The multipliers are arbitrary elements
of the containing finite faithfully tracial von Neumann algebra. Neither
freeness from the multipliers nor prescriptions on all reduced words is
assumed.

## Popa grounding supplied to this mission

Source opened: Sorin Popa, *Independence properties in subalgebras of
ultraproduct II_1 factors*, arXiv:1308.3982v3, Theorem 0.1(a).
The version was identified at https://arxiv.org/abs/1308.3982, whose HTML
link is https://arxiv.org/html/1308.3982v3. The text was read at
https://arxiv.org/html/1308.3982.

The relevant hypotheses are an ultraproduct of finite factors
`M = product_omega M_n` with dimensions tending to infinity and
`Q = product_omega Q_n`, where
`Q_n not-prec_{M_n} (Q_n' intersect M_n)` for every coordinate.
For a separable subspace `X` orthogonal to `Q' intersect M`, the conclusion
is a diffuse abelian algebra `A subset Q` free from `X` relative to that
commutant. The displayed vanishing condition in the source is

> E_{Q' intersect M}(x_0 product_{i=1}^n a_i x_i) = 0

for `n >= 1`, `x_0 in X union {1}`, `x_i in X`, and
`a_i in A minus C1`.

The next paragraph explicitly includes II_1 coordinate factors with
atomic relative commutant. Taking `M_n = Q_n = M` for a II_1 factor
reduces the commutant to the scalars and gives the factor-ultrapower
specialization used by the manuscript. This is grounding for the walk
dependency; the present rigidity proof assumes an exact free Haar family
and does not invoke Popa's theorem.

Independent citation attribution is reserved for the Host-invoked Reviewer.
This Engineer has not manufactured an independent reading by changing
reader names.

## Other literature boundaries

The manuscript cites Haagerup's length estimate, circular-variable polar
decomposition results, and basic spectral calculus. The intended verification
reproves the length estimate, moment count, and polar passage rather than
treating circular-limit convergence as a black box. Spectral calculus and
the construction of the finite tracial ultrapower remain ordinary analytic
foundations, not assertions certified by the combinatorial Lean source.

A targeted search of the inherited project Wiki found no directly relevant
rigidity, Haagerup-length, or Popa-ultraproduct page. No novelty conclusion
follows from that negative local search.
