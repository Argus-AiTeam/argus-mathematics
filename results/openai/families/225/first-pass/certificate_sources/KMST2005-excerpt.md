# Primary-source passage read

Source: <https://arxiv.org/html/hep-th/0406190v1>, Proposition 3.1,
equations (3.8)-(3.9). The surrounding definitions (2.6), (2.10)-(2.11),
and (3.1)-(3.6) were also read.

The proposition's opening statement, transcribing its set notation, is:

> Let {lambda} satisfy the system (3.6), {mu} be generic complex numbers. Then

The lists have the same size `N`. Its scalar-product formula is

    <psi_kappa(lambda)| prod B(mu_j) |0>
      = prod d(lambda_a) * det(partial_lambda_j tau_kappa(mu_k|lambda))
        / det(1/sinh(mu_k-lambda_j)).

It also states the analogous formula with the off-shell algebraic dual on
the left. The twist is `A+kappa D`; inhomogeneities in (2.6) are arbitrary
complex numbers. Admissibility and distinctness are discussed just before the
proposition; our application uses distinct real roots with nonzero vacuum
factors and nonsingular Gaudin matrix, and obtains coincidences by analytic
continuation.

Convention translation: their anisotropy is `i*lambda`, their site parameter
is `b_j+i*lambda/2`, and their unnormalized local matrix is `s_lambda` times
the manuscript's local matrix. Reversing the ordered sites is a fixed unitary
permutation and changes neither a scalar product nor a norm. For `n` roots
both sides scale by `s_lambda^(2*L*n)`. The manuscript uses
`tau_t=exp(it)*tau_kappa` and `kappa=exp(-2it)`, hence the determinant has the
compensating factor `exp(-int)`.

This is the passage actually read by the Engineer, not an independent
attribution verdict. The Reviewer must read it and verify the convention
translation before closing assumptions `C_SCALAR/A_KMST` and
`C_NEGATIVE_FIDELITY/A_KMST_NEGATIVE`.
