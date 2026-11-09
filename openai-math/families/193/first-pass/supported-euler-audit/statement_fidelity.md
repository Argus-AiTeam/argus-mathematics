# Statement fidelity: C193_IMAGE_CORE

`Main.lean` formalizes a module-theoretic core of the idempotent-image
argument in `as:base-equality`, not the complete proposition.

All declarations below are in the namespace `SupportedEuler`. All theorems
quantify over an arbitrary ring `R` and arbitrary additive
commutative groups `M`, `N`, and `Q` with `R`-module structures. Every map
displayed as a linear map is `R`-linear. A projector is expressed by the
literal equality `p.comp p = p`; its image is `LinearMap.range p`.
No finite dimension, freeness, faithful length, or chosen basis is assumed.

* `fixed_of_mem_range`: an idempotent fixes every element of
  its range.
* `range_inter_eq_map`: for a submodule `F` invariant under
  an idempotent `p`, the submodule `range(p) intersect F` is exactly `p(F)`.
  This is the filtration-intersection identity used on the abutment.
* `exact_on_ranges`: assume `im(f) = ker(g)`, expressed by
  `g y = 0 iff there exists x with f x = y`, and `f a = b f` with `b`
  idempotent. For every `y` in `range(b)`, `g y = 0` holds exactly when it
  has an `f`-preimage in `range(a)`. This is exactness at the middle of
  the image sequence. The theorem is slightly stronger than the intended
  use: `a` need not itself be idempotent.
* `surjective_on_ranges`: if `g` is surjective, `g b = c g`,
  and `c` is idempotent, every element of `range(c)` has a preimage under
  `g` in `range(b)`. Again `b` need not be idempotent for this conclusion.
* `injective_on_range`: an injective linear map remains
  injective when restricted to the range of any linear map. Together
  with the preceding two results this covers short exact image sequences
  for compatible projectors.
* `invariant_quotient_fixed_lift`: if `G` is invariant under
  an idempotent `p`, `x` belongs to `G`, and `p(x)-x` belongs to a submodule
  `F`, there is a fixed element `y` of `p` in `G` with `y-x` in `F`.
  With invariant `F <= G`, this is the surjectivity part of identifying
  the projected graded quotient with `p(G)/p(F)`. The formal theorem
  itself is stronger and does not require `F <= G` or invariance of `F`.

These are statements about projectors already present in an abelian
module target. They neither assume nor assert that a Verdier-quotient
projector lifts to a chain map. Their use in the report is only after the
spectral-data functor has actually been localized.

The following are **not formalized**: the general abelian/Serre-quotient
version of these module arguments, the manuscript's supported-roof
lemma, construction and boundedness of the homology evaluations, the
spectral sequences with their natural filtered abutments, their
localization, length additivity and ultralimits, or any of the manuscript's
descent or positivity arguments. These remain mathematical arguments in
`report.md` and separate obligations for independent review.
