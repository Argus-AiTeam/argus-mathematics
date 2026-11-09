# Statement fidelity: finite one-sided equal-marginal coupling

The claim is `C_FINITE127`. The public declarations are
`ShiftedCoupling.finite_envelope` and `ShiftedCoupling.finite_mad` in
`Main.lean`. They quantify over every finite type `iota`, every real
coordinate function `x : iota -> R`, every real joint mass
`w : iota -> iota -> R`, every real `a >= 0`, and every real center `c`.
The coordinates need not be distinct and the finite type may be empty.

The hypotheses are:

- Every `w i j` is nonnegative.
- For every index `i`, the row sum `sum_j w i j` equals the column sum
  `sum_j w j i`. This is equality of marginals, not pointwise symmetry
  of the joint mass.
- Whenever `w i j != 0`, `x j <= x i + a`. This is precisely the
  one-sided condition `V-U <= a` on positive mass. No reverse bound
  or exchangeability is assumed.

No normalization is needed: the statements are homogeneous in total mass.
For total mass one, interpret `w i j` as `P(U=x i,V=x j)` (or as an
indexed presentation when coordinates repeat). The conclusion of
`finite_envelope` is

    sum_ij w_ij (x_i-x_j)^2
      <= sum_i (sum_j w_ij) H_a(x_i-c),

where the source definition is exactly

    H_a(z) = 4 [z^2 - max(|z|-a/2,0)^2].

The conclusion of `finite_mad` is

    sum_ij w_ij (x_i-x_j)^2
      <= 4 a sum_i (sum_j w_ij) |x_i-c|.

`primitive_increment` proves the univariate quadratic increment inequality
for `g(z)=z|z|/2`. `envelope_primitive` proves the identity
`H_a(z)=4(g(z+a/2)-g(z-a/2))-a^2`. `pointwise_dual` proves the
one-sided pointwise transport inequality whose potential terms cancel
under equal marginals. All of these are proved from Mathlib, with no
additional axioms or proof holes.

The formalization does **not** encode arbitrary probability spaces,
measure-theoretic integrability, optimality or construction of the lattice
and binomial couplings, the limiting sharpness argument, the weighted
grading/edge recovery theorem, or sensitivity of polynomial threshold
functions. Those are distinct prose claims in `report.md`; the downstream
operator result is an explicitly cited assumption. The exact rational
fixture verifier is separate evidence, not a Lean theorem and not a
replacement for the all-parameter construction proof. A successful compiler
run certifies only the finite statements above. This document's translation
of those statements still requires independent human review.
