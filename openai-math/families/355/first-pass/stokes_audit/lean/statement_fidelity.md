# Statement fidelity: exact weighted translator recurrence

`Main.lean` uses Lean 4.31.0 and Mathlib over the real numbers. It
formalizes the following algebraic part of `../proof.md`, not its
complex-analysis conclusions.

`positiveCompositions n k` is the finite set of functions from `Fin k`
to `Fin (n+1)` whose values are strictly positive natural numbers and
sum to `n`. Thus it is exactly the ordered positive compositions of
degree `n` and length `k`, with no multiplicity quotient.
`compositionCoefficient b n k` sums the products of the `b` values
over these compositions.

`HasRecurrence m b` means `b 0 = 0`, `b 1 = 1`, and for every natural
`n >= 1`,

    b (n+1) = sum_{k=1}^n (2*n - m*k + 1)
                        sum_{i_1+...+i_k=n, i_j>=1} product_j b i_j.

Here `m` and all `b n` are real numbers, and natural indices are cast
to the reals in the weights. This is precisely equation (7) of the
proof. No recurrence is merely replaced by its leading summand.
The recurrence is a hypothesis; the formal file does not construct
the formal solution or prove formal-power-series coefficient
extraction. Those steps are proved in Section 2 of the prose.

`compositionCoefficient_one` identifies the entire length-one term.
`weight_ge_one`, `compositionCoefficient_nonneg`, and
`recurrence_nonneg` prove positivity of the weights and
nonnegativity of every coefficient whenever `m <= 2`.
`recurrence_leading_lower` and `recurrence_lower` derive the
leading-summand inequalities from the full recurrence, rather than
assuming inequalities for an unspecified tail.

`recurrence_factorial_lower` states, for every real `m <= 2`, every
real sequence satisfying `HasRecurrence m b`, and every natural `n`,

    2^n * n! <= (n+1) * b (n+1).

On reindexing this is the lower bound in (8) for all positive indices.
The formal bound actually needs no lower bound `1 <= m`; that
restriction is needed for the uniform upper majorant in the prose.
`surface_factorial_lower` gives the sharper universal bound
`2^n * n! <= b (n+1)` at `m = 1`.

`q_defect_identity` is the universal polynomial identity relating
the two defect expressions in (6). `translator_q_identity` encodes
the chain-rule substitution `tau = y^2/(2*m)`,
`l = y/m*(1-q)` with `d` representing `dq/dtau`. Its hypotheses
exclude `m = 0` and `y = 0`; its conclusion is the exact scaled
ODE residual identity (5), not the existence of differentiable
solutions.

`slope_difference_identity` is the exact factorization in (21).
`momentum_residual_identity` is equation (25), the algebraic
numerator of `P_m' - L_m` after using the translator equation and
the square-root relation. `finite_scale_momentum_identity`
includes the Gaussian correction and proves the numerator of
`P_epsilon' - (1-2*epsilon*h)*L_epsilon` is zero.
These last polynomial/rational identities are universally
quantified over real arguments. Algebraic identities extend to
the complex numbers by the identical ring calculation; complex
branches and differentiation of powers and square roots are
handled in the prose, not silently formalized by these statements.

**Coverage limits.** The compiler does not prove the factorial
upper bound, sectorial existence or uniqueness, analytic
remainders, the inverse-Laplace/positive-series contradiction,
nonvanishing or continuity of `c_m`, the boundary integral limit,
surface-family compatibility, or tangent-flow uniqueness.
They must not be reported as kernel-certified consequences of
this file. The analytic weighted theorem is a separate
independently reviewable proof in `../proof.md`.

The source contains no additional axioms or admitted declarations.
The printed axiom reports make the standard Mathlib foundations
visible; statement fidelity itself still requires human review.
