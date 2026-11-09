# Statement fidelity: universal weighted arrow pinning

## Principal declarations

`WeightedPinning.weighted_pinning_split` proves the following quantified
theorem. K, L and I are arbitrary finite types. K and L may be empty.
The assumptions on probabilities imply that I is nonempty.

- a and beta are real, a > 0 and beta >= 12.
- `positive : K -> R` is pointwise nonnegative.
- `negative : L -> R` is pointwise nonpositive.
- `p : I -> R` is pointwise nonnegative and sums to 1.
- `g : K + L -> R` and `child : I -> K + L -> R` are arbitrary real
  couplings, satisfying, for every deletion coordinate j,
  `sum_i p_i * child_i(j)^2 = g(j)^2`.

The matrix `arrow c g pole` has index type `Option (K + L)`. Its first
coordinate is `none`, its first diagonal entry is c, its two coupling
entries at j are g(j), and its deletion matrix is `diagonal pole`.
Here `pole = Sum.elim positive negative`. There are no restrictions on
the number, multiplicity, size, separation, or nonvanishing of the poles.
In particular, zero poles can be put in either block. Repeated poles
remain distinct coordinates. Couplings and probabilities can vanish.

Write H for the arrow with first entry -a, and H_i for the arrow with
first entry -beta*a and coupling child_i. The conclusion is the existence
of an i with p_i > 0 and

    positiveTrace(H_i) - positiveTrace(H) <= 23 * posPart(H)(none,none).

`WeightedPinning.manuscript_arrow_assignment` specializes to beta=80,
uniform probabilities on an arbitrary nonempty finite color type I, and
the bound 24 times the same rooted mass. Its hypothesis is precisely
the coordinatewise arithmetic mean of the squared child couplings.
No contraction, weight bound, or initial largest-root condition is
assumed: these are unnecessary for this stronger arrow theorem.

## Actual spectral meaning, not surrogate costs

`posPart`, `negPart`, and `posProjection` use Mathlib's proved
finite-dimensional spectral theorem. They are not arbitrary matrices
whose desired properties are axioms.
`positiveTrace_eq_sum` proves that `positiveTrace` is the sum of positive
eigenvalues, with multiplicity.
`posPart_diag_eq` proves that its first diagonal entry is exactly
`sum_j max(eigenvalue_j,0) * eigenvector_j(none)^2`, the positive first
moment of the first-coordinate spectral probability measure.

Real symmetric arrows suffice for the original complex Hermitian data:
the deletion roots are real, and the nonnegative residues can be realized
by their nonnegative real square roots. An arbitrary finite real deletion
spectrum can be split into K and L by its sign and reindexed; this
normal-form change does not restrict the quantified estimate.

## Obligations proved within Lean

The source proves, rather than assumes:

- positive/negative spectral decomposition, PSD Cauchy--Schwarz, and
  the PSD quadratic-form bound by the trace;
- positive-trace variational domination, subadditivity, and the
  rank-one diagonal perturbation bound;
- codimension-one positive-eigenvalue uniqueness and the side-arrow
  secular root bounds, including the singular zero-pole boundary;
- the two residue tests from the old spectral parts;
- two-test probability selection, including zero mean statistics and
  zero probability colors;
- finite exact selection from arbitrarily small positive error.

In the main proof the nonpositive test is evaluated at e_minus+epsilon
with epsilon>0. `finite_exact` removes epsilon using finiteness of the
positive-probability color support. Thus there is no division by a zero
pole and no assumption that a nonzero residue stays away from zero.

No positive-trace comparison, residue-test estimate, selection conclusion,
manuscript theorem, custom axiom, or proof hole is a hypothesis.

## Boundary of the compiler claim

This is a universal machine-checked finite spectral theorem, not an
enumeration. The reduction from the manuscript's expected determinants to
arrows and its rooted measure is explained in `report.md`; the stable
multivariate polynomial theory and the original coloring construction
are not themselves encoded in Lean here. Neither unrestricted paving
theorem, nor any infinite-dimensional passage, is a compiler-checked
consequence of this source.
