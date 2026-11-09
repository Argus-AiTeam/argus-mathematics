# Statement fidelity: the ordered coefficient / positive-block core

Claim: `V_DIRECT_CORE`. Source: `Main.lean`, namespace `CrouzeixCore`.
This is a universally quantified **conditional verification theorem**.
It is not a formal proof of conformal mapping, the Faber kernel construction,
or the complete Crouzeix conjecture without analytic hypotheses.

## Exact formal objects and elementary declarations

`hsSq A` is the real part of `trace(A* A)`, where the first factor is the
conjugate transpose. `hsSq_eq_sum` proves it equals the sum of squared complex
entry magnitudes, with no normalization by dimension.

`tensor_pairing` quantifies over independent finite base and coefficient
index types, arbitrary complex matrices `A,C,X,Y`, and proves the tensor
evaluation identity. Vectors are flattened as `(base,coefficient)`.
The result pairs `(Y* A X)[i,j]` with `C[i,j]` **bilinearly**.
There is no transpose or adjoint of the coefficient array in that pairing.
The theorem concerns one arbitrary tensor term; finite summation gives the
polynomial identity in manuscript `eq:pairing`.

`ordered_tensor_terms` proves that multiplying evaluated terms in their given
order multiplies the coefficient matrices in that same order. Interchanging
its input terms proves the reversed product; it does not assert commutativity.

`finite_pair_cauchy` is complex Cauchy--Schwarz for the bilinear pairing.
`finite_pair_of_total_energy` replaces its first finite energy by any larger
real total energy. For a finite polynomial and a square-summable resolvent
sequence, the omitted squared magnitudes are nonnegative, giving this cap.

`weighted_dual` quantifies over **every finite coordinate type**, arbitrary
complex coefficients, and arbitrary strictly positive real weights.
Its premise bounds the squared magnitude of the bilinear functional on
**all** test arrays by `b` times their weighted energy, with `b>=0`.
Its conclusion is the reciprocal-weight energy bound. Its proof constructs
the entrywise-conjugate reciprocal-weight test; it does not assume duality.
Finite coordinate types include `(coefficient index, row, column)`.

`positive_block` allows independently sized diagonal blocks and an arbitrary
rectangular complex off-diagonal block. Its only mathematical premise is that
`fromBlocks U Z* Z V` is positive semidefinite. It derives
`2 hsSq Z <= hsSq U + hsSq V` by sign conjugation and positivity of the real
trace of a product of positive matrices. No entrywise positivity,
invertibility, normality, symmetry of a kernel, or commutativity is assumed.
`integrated_positive_block` derives the same inequality for integrals from
pointwise positivity, with explicit integrability of the three squared norms.

## Main declaration

`ordered_coefficient_positive_block` quantifies over:

- an arbitrary type `E` of tests, a finite coordinate type `K`, an arbitrary
  measure space `T`, and independently sized finite complex matrix blocks;
- complex functionals `off,dp,dq`, real squared coefficient and boundary
  energies, **separate** left and right multiplication maps, and a constructor
  supplying every finite coefficient test of every length `N`;
- arbitrary countably infinite complex coordinate sequences `p,q`;
- `gamma>0`, nonnegative `mzero,mtail,ltail`, and
  `mzero+mtail>0`.

The algebraic hypotheses are the off-diagonal coefficient Cauchy bound,
the lower coefficient estimate, the two ordered multiplication identities,
the two boundary multiplier inequalities, the bilinear entry formulas for
the two diagonal functionals, and the upper coefficient estimate with weight
one at index zero and weight two at every positive index.
The weighted diagonal dual bounds are **not** hypotheses:
`ordered_functional_bound` and `ordered_dual_partial` derive them.

The analytic hypotheses are:

1. The finite reciprocal-weight energies of `p,q` converge to reals `P,Q`.
   The arrays are indexed by all natural numbers, and the premises range
   over every `N`, not a fixed cut-off.
2. The three boundary squared norms are integrable; their block is positive
   at every point.
3. Their exact Parseval energies are `4P`, `4Q`, and
   `4*mzero+mtail+ltail`, respectively.

For the manuscript application, `mzero=||M_0||_HS^2`,
`mtail=sum_{k>=1}||M_k||_HS^2`, and
`ltail=sum_{k>=1}||L_k||_HS^2`.
The constant term is counted four times in the cross Parseval identity.
`p,q` are the flattened `P_k,Q_k` matrices, and `P,Q` their full
reciprocal-weight energies. The pointwise fields are `P+P*`, `Q+Q*`,
and `M+L*`.

The conclusion is `gamma<=2`. The proof uses all finite conjugate tests,
passes to their limits, derives the integrated block comparison from
positivity, and only then cancels the positive off-diagonal energy.
The zero-norm case is immediate separately; the formal theorem addresses
the nonzero singular-pair case.

## Quantitative generalization and boundary of certification

`weighted_frame_constant` proves the real-energy conclusion
`gamma^2 <= max 4 (2*beta)` for any `beta>0`, from the corresponding two
reciprocal-weight inequalities, nonnegative coefficient energies, and the
cross/block comparisons. The preceding general `weighted_dual` and
`positive_block` prove those algebraic operations independently.
Unlike the weight-two main declaration, this auxiliary scalar declaration
does not package the entire ordered-test derivation for general `beta`.

Applying the main declaration to an actual domain still requires an exterior
collar; the Faber coefficient sandwich; a positive resolvent with constant
coefficient identity and convergent Fourier series; Parseval; and finite
singular-pair extraction. The report proves the interface from these
premises, but the Lean file does not construct that analytic data.
Those are explicit premises, not hidden axioms or a constant-two result.
Only Mathlib is imported. The final compiler commands print the transitive
logical axioms of the core declarations; no upstream Crouzeix module is used.

Compilation checks these declarations. Independent review must still confirm
this reading and the manuscript-to-interface application. No refutation,
novelty determination, or independent acceptance is asserted here.
