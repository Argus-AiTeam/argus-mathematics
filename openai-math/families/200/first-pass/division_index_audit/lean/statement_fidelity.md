# Statement fidelity: the nilpotent core of the division-index bridge

The ledger claim is `C_DIA_FORMAL_CORE`. The principal declaration is
`constant_zero_of_truncated_bezout` in namespace `DivisionIndexAudit`.

Its coefficient ring `R` is an arbitrary commutative ring, including rings
with zero divisors. The scalar `p` is an element of `R`, not a formally
assumed prime. The five objects `A,D,T,U,Q` are univariate polynomials over
that same ring. The parameters `nu,v,h` are arbitrary natural numbers.
`C p` means the constant polynomial with coefficient `p`, and `X` is the
polynomial variable.

The hypotheses are exactly:

1. `p^v = 0` in the coefficient ring.
2. `nu*v <= h`.
3. `X^(h+1)` divides `A*Q` as a polynomial.
4. The polynomial identity
   `X^nu = A*D + C(p)*T + X^(h+1)*U`.

The conclusion is that the constant coefficient `Q.coeff 0` is zero in
`R`. There is no assumption that `A`, `p`, or `X` is a non-zero-divisor.
The proof uses the quotient by `(X^(h+1))`, not cancellation by `A` or `p`.

The subsidiary declaration `nilpotent_lift` in that namespace states,
over any commutative ring, that `a*q=0`, `x^nu=a*d+p*c`, and `p^v=0`
imply `x^(nu*v)*q=0`. The declaration
`power_mul_eq_of_mul_eq` proves the required power
identity by induction. `determinant_weights` proves
the integer identity for the scalar weights `(-1,0)` for every integer
genus parameter `g`.

To apply the principal declaration to the manuscript, take
`R = Z/(p^v)`. An integer polynomial `A` of exact order `nu` modulo
the prime `p` admits the displayed truncated Bezout identity: invert
the unit factor of `A mod p` to the required finite order and lift
coefficients to integers. This construction is proved in the mathematical
report and implemented in `verify.py`; its existence is NOT a conclusion
of the Lean declaration. Reduction to `R` makes the scalar nilpotent,
and zero constant coefficient means `p^v` divides the original integer
constant coefficient.

The source does NOT formalize complex varieties, determinant functors,
Galois descent, Picard varieties, topological K-theory, Hilbert series,
or the assertion that the constructed algebra is division. Those parts
of the report require mathematical reading and independent Reviewer
approval. In particular, a successful compile of this source alone
must not be recorded as a kernel proof of `C_DIA_DIVISION`.
