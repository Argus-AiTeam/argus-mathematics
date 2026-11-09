# Statement fidelity: selector reconstruction and counting core

Source: `research/selector_certificate/Main.lean`.
Namespace: `SelectorCertificate`. Claim: `SEL_CORE175`.

## Objects and quantifiers

`X` is an arbitrary finite type, not a fixed enumerated example. Colors are
natural numbers. `a`, `b`, and `z` are arbitrary maps from `X` to natural
numbers. A genuine feasible move in `HasWitness` has every final color at
least 1, and `FeasibleWith` requires `z(x)<=a(x)`. Thus, when the original
coloring has colors in `1,...,s+1`, the same is true of its feasible moves.
In particular, the minimization does not permit the extra color zero.

The witness type `T` and validity predicate `valid` are arbitrary.
`weight h` is a real-valued function on `X`. The reconstruction proof does
not require positivity, normalization, distinct weights, or full support.
For the manuscript specialization, `T` consists of family members,
`valid` is membership in the family, and `weight h=lambda_h`. Its usual
probability-mass assumptions are stronger than those of this core.

`crossings a z i` is the real sum of indicators of `z(x)<=i<a(x)`;
it equals the cardinality of `A_i(z) \ A_i(a)` when `z<=a`.
`slack` is the captured capped mass minus `(1-d_i)` times the total
capped mass minus that crossing count times the cutoff.
`FeasibleWith` includes both inequalities `0<=u_i<=1`, the strict
high-weight inclusion, and nonnegative slack for every `1<=i<=s`.
It is the manuscript's actual feasibility condition, not a reconstruction
bound postulated as an assumption.

`ChangesIn H0 a z` means every changed vertex belongs to the prescribed
member `H0`. `moveLength` is the natural-number sum of `a(x)-z(x)`.
`Minimal` requires feasibility, the changed-set restriction, and minimum
length over every feasible move satisfying that same restriction.
The minimum's existence is established by the finite-coloring argument in
`proof.md`; it is not asserted as a separate Lean existence theorem.
No minimality with respect to a fixed witness is substituted for the
manuscript's unrestricted-witness minimization.

## Checked reconstruction declarations

* `capturedCap_delay`, `crossings_delay`, and `moveLength_delay` prove the
  exact changes caused by increasing one final color from `i` to `i+1`.
  The original color may be exactly `i+1`.
* `feasible_delay` proves that a moved vertex of weight at most the cutoff
  can be delayed using **the same** witness and the same entire cutoff
  vector. Other scale tests are preserved.
* `minimal_forces_high` derives strict high-weight membership from
  minimality by that shorter-move contradiction. High-weight membership
  is a conclusion, not an input.
* `profile` is the cardinality of the actual cell
  `{x:z(x)=j and a(x)=h}`. Only its entries `j<h` are compared.
  `crossings_eq_profile` and `same_profile_crossings` prove the crossing
  count identity by finite fiber summation, assuming a common finite
  upper bound `B` on the colorings.
* `feasible_same_crossings` proves transport of a fixed witness and cutoff
  vector once the crossing counts agree.
* `common_witness_reconstruction` combines these statements. For **any**
  bounded `a,b,z` with equal changed-cell profiles, any witness feasible
  for `(a,z)` is also feasible for `(b,z)` when `z<=b`; if `z` is a
  selected minimum for `b,H0`, every vertex moved from `b(x)>z(x)` to
  color `z(x)` in `1,...,s` has weight strictly greater than its cutoff.
  It quantifies over all original colorings and all feasible common
  witnesses. It does not choose a different witness for each scale.
* `encoding_injective` proves that the changed cells, with `z` fixed,
  determine the entire original coloring. It does not assume disjoint
  high-weight candidate sets.

## Checked truncation and summation declarations

`cutoffSet` is the intersection of `[0,1]`, the inequalities
`w(x)<=u` outside `A`, and nonnegative truncated slack with charge `m`.
`maximal_cutoff_exists` proves that every nonempty such set has a
greatest cutoff using closedness and compactness.
`maximal_cutoff_count` proves

    d * |{x:w(x)>u}| <= m

for a greatest cutoff, `w(x)<=1`, and `m>=0`. It proves the right-hand
perturbation using the next finite weight breakpoint, rather than
assuming a derivative or a candidate-set size bound. The theorem actually
allows arbitrary real `d`; the manuscript uses `0<d<1`.
`capScore_cumulative`, `untruncation_capture`, and `unchanged_capture`
prove the identity with the feasibility slack and the implication from
unchanged feasibility to simultaneous mass capture. The untruncation
step assumes total weight one and nonnegative deficits, not strict
positivity of individual weights.

`factorial_profile_sum` proves the finite multinomial identity underlying
factorial full-profile summation, using Mathlib's proved multinomial
theorem, with arbitrary finite cell set and real cell weights.
Its coefficients are written as `t^t/t!` times the multinomial
coefficient. The conversion from actual encoding multiplicities to
these coefficients is shown algebraically in `proof.md`, not represented
by an additional Lean counting theorem.
`power_ratio_le_three`, `factorial_majorant`, `finite_geometric_bound`,
and `profile_polynomial_bound` prove the universal coefficient and
finite-series estimates. They are not finite checks up to a fixed
degree. `original_palette_bound` and `improved_palette_bound` prove
the exact rational calibrations `R<1/127 => bad<1/62` and
`R<1/23 => bad<1/10`, **conditional** on
`bad<=2R/(1-3R)`.

## Limits of this formalization

The complete universal arbitrary-palette selector theorem, including
existence of selected minima, the integral-cover inequality, the
cardinality upper bound on the encoding space, the exact product-coloring
likelihood identity, and the conversion to a probability bound, is proved
in `proof.md`. These final assemblages are not a single Lean theorem in
this source. In particular, the conditional rational calibrations are
not themselves formal proofs of the selector probability bound.
The main delicate reconstruction is fully derived in Lean, rather than
assumed in those assemblages. The threshold-rounding consequence is also
a prose consequence, not a Lean theorem.

The finite exact-arithmetic replay in `verify.py` separately covers zero
masses, equal weights, cutoffs zero and one and interior breakpoints,
repeated changed sets before deduplication, multi-original profile
fibers, one-level delays, and `s=0`. Those computations are neither the
universal proof nor evidence that a conjecture holds beyond the stated
finite checks. No independent review or verified novelty is claimed by
this document.
