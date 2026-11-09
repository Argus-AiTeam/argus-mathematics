# Statement fidelity: square-zero top-power algebra

Claim: `C343_SQUARE_ZERO`.

The declaration `square_zero_binomial` in namespace `HandlePackingAudit`
quantifies over every type `R`
with a commutative-ring structure, every `a b : R`, and every natural
number `n`, including zero. Its sole extra hypothesis is `b * b = 0`.
Its conclusion is exactly
`(a+b)^(n+1) = a^(n+1) + (n+1)*a^n*b`,
where the natural coefficient is cast into `R`. It assumes neither a
characteristic-zero field nor a bound on dimension.

The declaration `square_zero_top_power` in the same namespace adds the hypothesis
`a^(m+1) = 0` and concludes
`(a+b)^(m+1) = (m+1)*a^m*b`.

In the analytic report, these identities apply to the commutative
even-degree subalgebra of differential forms, with `a` the vertical
symplectic two-form and `b = c ds wedge dt + eta wedge dt`.
Both summands of `b` contain `dt`, so `b*b = 0`; vertical dimension
`2m` gives `a^(m+1) = 0`. The remaining vertical-degree argument
eliminating `a^m wedge eta` is in the report, not this formal source.

The Lean declarations do not encode manifolds, exterior algebras,
Hamiltonian isotopies, compactness, axes, Moser flows, thin planar
embeddings, or the packing theorem. Compilation certifies only the
displayed universal ring identities. The applicability of the
even-degree algebra and the analytic interpretation require independent
mathematical review. There are no assumptions about comparison
existence or the main ball-packing conjecture in these Lean statements.
