# Statement fidelity

`Main.lean` formalizes two parameter-uniform cores, not the entire arithmetic
height theorem or the geometric construction of its inputs.

The declarations are `leading_residue`, `horizontal_leading_eigenpair`,
`horizontal_order_bound`, and `layer_count_uniform`, all in namespace
`SharedInterpolation`.

`SharedInterpolation.leading_residue` works over an arbitrary field and an
arbitrary finite matrix size. `A n` and `y n` denote coefficients of a formal
matrix series and vector series. Its convolution equation is exactly the
coefficient of degree `n` in `t y' = A(t)y`. If all earlier vector
coefficients vanish, the first coefficient is an eigenvector of `A 0` with
eigenvalue the field image of `n`. The theorem does not assume this coefficient
is nonzero; that hypothesis is supplied explicitly in the next declaration.

`SharedInterpolation.horizontal_leading_eigenpair` assumes all coefficient
equations and at least one nonzero vector coefficient. It produces the least
nonzero coefficient, proves every earlier coefficient zero, and proves its
residue eigenvector equality. `SharedInterpolation.horizontal_order_bound`
additionally assumes a bound on every natural-number eigenvalue having a
nonzero eigenvector. It bounds that least index. In the complex logarithmic
connection application, the coefficient equation, the nonzero quotient
section, and the spectral bound must still be established geometrically.
The compiler does not establish those application hypotheses.

`SharedInterpolation.layer_count_uniform` quantifies over all natural numbers
`k,B,B',r,L`. The geometric dimension is `k+2`. If `L>0` and
`(k+2)! B' r (2+B r+B)^k < L`, it proves

`(k+2)! B' (r L) (1+L+B(r L)+B)^k < L^(k+2)`.

This is the strict condition-count inequality required for the layered
construction at order `n=rL`, before comparing with the binomial lower
bound for the source dimension. The existence of the linear remainder map,
its polynomial degree bound, its rank bound, the binomial source-dimension
bound, and the construction of an actual-ideal certificate are not encoded.
The prose proof establishes these separately. Dimension one uses a unit
ideal and is not included in this numerical declaration.

No declaration in this source claims that absence of finite counterexamples
proves the height theorem, that branch nonidentity is a scheme-theoretic
non-zero-divisor hypothesis, or that the four manuscript applications are
verified. The formal certificate attaches only to claim `C_SHARED_FORMAL_CORE`.
