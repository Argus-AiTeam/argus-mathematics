# Statement fidelity: universal Schur-resolvent core

The central declaration is `ReciprocalKernel.schur_resolvent_psd`.
Its index type is arbitrary with a `Fintype` instance: it covers every finite
matrix size, not a list of tested matrices. Entries and scalars are real.
`U.PosSemidef` means that U is symmetric and its quadratic form is
nonnegative on every real vector. The hypotheses are exactly `a > 0`,
`c >= 0`, and `U i i < a` for every index. The conclusion is positive
semidefiniteness of the matrix

    V_ij = U_ij / ((1 + c*a) * (1 + c*a - c*U_ij)).

`psd_abs_entry_lt` derives the strict entry bound from the diagonal bounds
and positive semidefiniteness; it does not assume entrywise nonnegativity.
`scalar_schur_series` proves the convergent scalar series for V, including
negative entries and c = 0. `psd_entrywise_power` uses Schur products, not
ordinary matrix powers. `psd_of_entrywise_limit` proves closure under
entrywise limits of fixed-size real matrices.

`normalized_column_update_psd` is the directly usable form: for a real
matrix H, if `a - H_ij` is positive semidefinite, `a > 0`, `c >= 0`,
and every `H_ii > 0`, then

    a/(1+c*a) - H_ij/(1+c*H_ij)

is positive semidefinite. `update_defect_identity` connects this expression
to V. In the analytic proof, H is the positive diagonal normalization of
an entrywise reciprocal matrix and a is its constant anchored row value.
Thus this verifies the delicate Schur-series implication used in the
manuscript's column-update lemma, for all dimensions and parameters.

This source does NOT encode a disk, a measure, a PDE Green function,
positive quadrature, the number of positive eigenvalues, boundary
asymptotics, or the full conditional-negative boundary-kernel theorem.
Those connections and the singular-measure extension are proved in the
separate mathematical report and require independent mathematical review.
No compiler result for this source should be described as a formal proof
of those analytic statements or of the hot-spots conjecture.
