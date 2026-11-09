# Statement fidelity: `ThorpEnergy`

`Main.lean` formalizes finite real-vector identities used in the
conditional-energy proof. It does **not** encode the entire shuffle,
sigma-fields, the path-cylinder theorem, the geometric identification of
subcube supports, or the full mixing theorem. Those connections are proved
in `report.md`; the compiler cannot check that interpretation.

All index types in the first five declarations are arbitrary finite types.
They may be empty: the identities are unnormalized sums, so division by
their cardinalities is not part of those statements.

* `deterministic_matrix_preserves_centering`: for any finite outcome set
  `B`, input/output coordinate sets `I,J`, real matrix `M`, and array `z`,
  if each input coordinate has sum zero over `B`, every coordinate of
  `Mz` also has sum zero. The matrix is fixed, not allowed to depend on
  the outcome being averaged.
* `centered_inner`: for any finite histories `A`, finite future outcomes
  `B`, finite spatial coordinates `I`, vectors `p a`, and noises
  `z a b`, assume `sum_b z a b i = 0` separately for **every** `a,i`.
  Then `sum_a sum_b sum_i p a i * z a b i = 0`.
  Thus past-dependent amplitudes are permitted; assuming merely a
  globally centered noise would not suffice.
* `centered_energy_row` and `finite_centered_energy`: under the same
  row-centering premise, the sum of squared coordinates of `p+z`
  is exactly `card(B)` times the past energy plus the summed noise
  energy, first for one history and then over arbitrary finite histories.
  This is the martingale cancellation core, not a premise that the
  manuscript's energy identity already holds. In the application,
  row-centering is established from the fresh independent switch coins.
  Finite fair-coin fibers have equal weights; division by their positive
  size converts these sum identities to conditional expectations.
* `finite_product_factorization`: arbitrary real functions on two finite
  index sets have a factorizable double sum of their product. In the
  application the two factors are the independent future switch arrays
  in different components, not the free set and the flow in one component.
* `spread_dipole_energy`: for every natural `q` and real amplitude `a`,
  there are two disjoint copies indexed by `Bool`, each with `2^q`
  coordinates indexed by `Fin (2^q)`. Each copy has constant value
  `+a/(2*2^q)` or `-a/(2*2^q)`. Their total squared norm is
  `a^2/2^(q+1)`. This includes `q=0` and `a=0`; it formalizes the
  exact coefficient after the two disjoint subcubes have been identified.
  It does not assert disjointness for arbitrary overlapping subsets.

The probabilistic proof supplies row-centering and component-local
measurability directly from cylinders in the switch product space.
The formal file does not turn finite enumeration into a universal proof
or certify novelty, publishability, independence of review, or mixing.
