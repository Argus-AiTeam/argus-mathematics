# Formal statement fidelity

The declarations in namespace `ReplicaSymbol` formalize only
`C_SYMBOL_FORMAL_CORE`. They do not formalize the full analytic theorem
`C_SYMBOL_UNIFORM` or the identification of a tensor-sector representation
in `C_SYMBOL_HALF_SHARP`.

`complement_product_bounds` quantifies over every finite list `xs` of real
numbers. Its sole hypothesis says each entry lies in the closed interval
[0,1]. It proves both nonnegativity of the product of the complements and
the lower bound `1 - sum xs <= product (1 - xs)`. This is the arbitrary
finite-family union bound used for the donor-collision estimate, not a
finite enumeration of list lengths.

`nilpotent` is the real 2-by-2 matrix [[0,0],[a,0]] for an arbitrary real
parameter `a`. `nilpotent_square` proves its square is zero.
`nilpotent_self_commutator` proves that its product with its transpose,
minus the reverse product, equals diag(-a^2,a^2).
`nilpotent_not_normal` proves that matrix is nonzero whenever `a` is
nonzero. All matrix identities quantify over every real `a`; they do not
assume its sign. Transpose here agrees with adjoint because all entries
are real. In the analytic application, `a=alpha_k` is positive.

`scalar_self_commutator` quantifies over arbitrary complex scalars `a,b`
and proves `a*b-b*a=0`. Thus the polynomial obstruction is genuinely
noncommutative, not a sign convention about a real adjoint.

The compiler does not verify the Schur labels of the symmetric tensor
states, the gamma-weight formula for `alpha_k`, its nonzero limit, the
Husimi measure, inverse-power estimates, or Bernstein approximation.
Those links and the application of these formal identities are given
in `theorem.md` and must be checked by the independent Reviewer.
