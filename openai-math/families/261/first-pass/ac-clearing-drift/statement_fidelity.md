# Statement fidelity: noncommuting normalization identities

The declarations in `Main.lean` quantify over every type `R` with a
`Ring R` instance. In particular they apply to square complex matrices
of every finite size. Multiplication need not commute. The symbol `1`
denotes the ring identity; it is the identity matrix in that application.

`inverse_linear_right` and `inverse_linear_left` assume the indicated
one-sided inverse identity for `T` and `1+D` and prove, respectively,
`T*D=1-T` and `D*T=1-T`.

`total_leverage_identity` quantifies over `Q,D,T`, assumes both inverse
identities, and proves the matrix identity

    (Q+D)*T-Q = (1-Q)*T*D.

In the report, `Q=U^*U`, `D=W^*W-Q`, and `T=(I+D)^{-1}`.
Taking traces gives exactly the normalized total-leverage increment.
No commutation of `D` with `Q`, the old Gram matrix, or the ridge is assumed.

`inverse_quadratic_remainder` assumes only `(1+D)*T=1` and proves

    T-1 = -D+D*D*T.

`congruence_inverse` assumes `L*J=J*L=1` and `K*T=T*K=1`.
It proves both inverse identities between `L*K*L` and `J*T*J`.
The matrix application takes `L=G^(1/2)`, `J=G^(-1/2)` and `K=I+D`.
It justifies the order of factors when the normalized Gram congruence
is inverted.

This formal claim is **C_AC_NONCOMM**, not C_AC_DRIFT. The file does not
formalize the norm inequalities, conditional expectations, unitarity
cancellation, balanced-ridge order condition, residual moments, exponent
conditions, or spectral assertions. Those are addressed by the separate
analytic proof and exact computations. A successful compiler run must not
be described as a kernel verification of the full drift theorem.
