# Statement fidelity: the noncommutative increment core

The source `Main.lean` formalizes exact algebra used in Sections 2--4 of
`report.md`. It does **not** encode the entire analytic weighted-increment
theorem. In particular a successful compiler run must not be reported as a
kernel proof of `C_FILTER_INCREMENT` or `C_FILTER_SATURATING_GAIN`.
The mechanical claim is `C_FILTER_ALGEBRA`.

The declaration names inside the namespace are `contraction_defect`,
`unsaturated_conjugation`, `saturated_conjugation`,
`matrix_saturated_conjugation`, `quartic_forward`, `quartic_reverse`,
`budget_telescope`, and `energy_threshold`.

`FilterIncrement.contraction_defect` quantifies over every ring and arbitrary
elements `c`, `ct`, and `z`. Its conclusion is
`(1+c*z*ct)-c*(1+z)*ct = 1-c*ct`. For real square matrices take `ct` to be
the transpose of `c`. This is the exact identity making the relative
normalization contractive; positivity of its right side is a hypothesis
of the analytic application, not a conclusion of this declaration.

`FilterIncrement.unsaturated_conjugation` and
`FilterIncrement.saturated_conjugation` quantify over every monoid, units
`u,r`, and an element `b` commuting with `r`. They make no commutativity
assumption on `u` and `b` or on `u` and `r`. Unit inverses are actual
two-sided inverses. The declarations prove the displayed conjugation
identities for those objects. Their real-matrix interpretation is:

- `u = U`, the orthogonal factor of `T = U (I-H)^(-1/2)`;
- `r = (I-H)^(-1/2)` and `b = H^(1/2)`;
- `u^(-1) = U^T`, `r^(-1) = (I-H)^(1/2)`;
- `A^(1/2) = U b r U^T` and `(I+A)^(-1/2) = U r^(-1) U^T`.

Consequently the first identity is the manuscript's
`T^T A^(1/2) T = H^(1/2)(I-H)^(-3/2)`. The second is the improved exact
identity
`T^T [A^(1/2)(I+A)^(-3/2)] T = H^(1/2)`.
The commuting pair consists only of two functions of the **same** symmetric
matrix `H`; the proof does not commute the old covariance and the gain.
`FilterIncrement.matrix_saturated_conjugation` explicitly specializes the
second identity to real `d`-by-`d` matrices for every natural number `d`.
The units and commutation hypothesis are still explicit in this specialization.

`FilterIncrement.quartic_forward` and `FilterIncrement.quartic_reverse`
prove polynomial identities for every real `u`. Substituting
`u=r^(1/4)>0` gives the scalar remainders used in both orientations of
the cutoff comparison. These declarations do not by themselves prove
the inequalities or the validity of that substitution.

`FilterIncrement.budget_telescope` quantifies over arbitrary real sequences,
every natural length `N`, an initial value zero, and the explicit stepwise
budget hypothesis. It proves the finite sum bound, without assuming
nonnegative budgets. The analytic proof establishes the stepwise
hypothesis using matrix order and trace differentiation.

`FilterIncrement.energy_threshold` proves the rational numerical inequality
used to infer `q<1/4` when `E<=1/24` and `q^3=(3E/2)^2`.

The following remain outside this Lean source and require mathematical
review: spectral calculus and polar decomposition; positivity and
eigenvalue comparison under contractions; operator monotonicity of
fractional powers; trace differentiation and integration; scalar cutoff
inequalities; and the lifted Hilbert--Schmidt endpoint expansion. They are
proved in the report, not postulated as a machine-checked result. The
standalone Python replay checks exact identities and constants and exact
noncommuting examples, not arbitrary-dimensional analytic inequalities
by sampling. No claim is made here about the Gaussian-survival,
adaptive-shift, signed-prefix, or rearrangement theorems.
