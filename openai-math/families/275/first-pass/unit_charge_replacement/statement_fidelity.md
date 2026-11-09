# Statement fidelity for C_UCR_CORE

The declarations are in namespace `UnitChargeReplacement` in `Main.lean`.
They formalize exact algebraic components, not the analytic Coulomb theorem.

`twoPoint_exact` quantifies over every real `t` with `t^2 = 1/3` and
every natural `p <= 3`. The average of the powers at `t` and `-t`
equals `intervalMoment p`, which is defined as zero for odd powers and
`1/(p+1)` for even powers. These are the normalized Lebesgue moments
of `[-1,1]`; identifying them with integrals is a mathematical reading,
not a measure-theory theorem in this file. Either sign of `t` gives
the same two nodes; zero cannot satisfy the hypothesis.

`tensorRule` explicitly lists all eight triples of these two nodes,
each with weight `1/8`. `tensor_factorization` is its exact product
factorization. `tensor_cubic_exact` quantifies over all natural
`a,b,c <= 3` individually and all such real `t`. Its conclusion equates
the eight-node monomial average to the product of the interval moments.
This includes every monomial of total degree at most three and also
some higher-total-degree monomials. Affine change to a grid cube,
Taylor's theorem, and the transported integrand are not formalized.

`square_completion_identity` quantifies over arbitrary real
`alpha,beta,x,y` with `alpha > 0`. Its conclusion is the exact identity
used in (K) of `proof.md`. `normalized_complement_bound` additionally
quantifies over an arbitrary real `energy`, assumes `x^2 <= 1` and
`alpha*y^2 - 2*beta*x*y <= energy`, and concludes
`-(beta^2/alpha) <= energy`. No sign condition on `beta,x,y` is needed;
the intended norms are a special case. Neither a Hilbert-space
decomposition nor the analytic block estimates are assumptions smuggled
into the formal statement: they are absent from this algebraic theorem
and must be proved separately before it is applicable.

`rounding_denominator` quantifies over all nonnegative real `H,S` and
proves `H^3*S^2 <= (1+H)^3*(1+S)^2`.
`rounding_ratio` assumes both are strictly positive and proves
`H^2*S/((1+H)^3*(1+S)^2) <= 1/(H*S)`. This is the denominator
inequality in (H). The factors `8*rho/lambda^3`, the ceiling
`H=ceil(lambda^5)`, `S>=1`, and the Coulomb/Hardy rounding bound
are not formalized.

There are no analytic claims, QMA-hardness claims, new axioms, `sorry`,
or `admit` in the formal source. A successful compiler run certifies
C_UCR_CORE alone. The field differentiation, uniform sums, Sobolev
arguments, flow construction, and upstream inputs (6) and (M) remain
outside the formalization and require independent mathematical review.
