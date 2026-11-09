# Statement fidelity: the compatible recursion algebra

The formal claim is `C_PF_ALGEBRA`, not analytic existence of elasticity
solutions and not global inverse uniqueness. `Main.lean` has two independent
families of universally quantified algebraic theorems.

`CompatibilityData A V W` contains arbitrary additive commutative groups of
amplitude pairs, vectors, and scalars. All operator fields are additive maps.
Its three laws are explicit hypotheses, not axioms asserted about elasticity:

1. `augmented` is div(R U) - S U = P(q U).
2. `compatibility` is div(Rlead U) + normal(R U) - Slead U
   = P(normalA U) + Plead(q U).
3. `leading_normal` is normal(Rlead U) = Plead(normalA U).

For the application, U=(a,b), q U=div(a)-b, normalA U=theta dot a,
normal V=theta dot V, Rlead=R^theta, Slead=S^theta, and
Plead=2m D+(Dm). These are complex-linear, hence additive, operators
on smooth functions on the cylinder. The first law is the manuscript's
`eq:augmented-identity`, the second `eq:transport-compatibility`, and
the third `eq:normal-transport-component`. The universal smooth-jet
identities establishing these hypotheses are checked separately by
`verify.py`; Lean does not encode differentiation of smooth functions.

`normal_source_of_leading` proves the base compatibility for every amplitude
annihilated by Rlead, Slead, and normalA. `normal_source_of_step` proves
compatibility for a current amplitude from the three previous-step equations.
`normal_source_all_orders` quantifies over every natural-number-indexed
amplitude sequence satisfying those equations; there is no truncation bound.
`particular_source_tangent` proves that subtracting a particular amplitude
with normalA=-q leaves a vector source with zero normal component. It does
not assert the existence of that particular amplitude or solve a PDE.

The telescoping declarations quantify over every commutative ring K, every
K-module, every scalar h, and every natural number N, including h=0 and N=0.
`residual_sum_telescope` and `normal_sum_telescope` prove the finite sum
identities under the displayed consecutive-term recursion.
`vector_telescope` proves

    h R(sum_(j=0)^N h^j U_j) + Rlead(sum_(j=0)^N h^j U_j)
      = h^(N+1) R(U_N).

`divergence_telescope` proves

    normalA(sum_(j=0)^N h^j U_j) + h q(sum_(j=0)^N h^j U_j)
      = h^(N+1) q(U_N).

Their application to the manuscript uses K=C and h=1/tau>0.
Dividing these equations by h gives respectively the conjugated vector
residual and the actual-divergence defect. Division is only part of that
application; the formal sum identities require no nonzero hypothesis.

No Carleman estimate, planar frame, support property, coefficient positivity,
Sobolev estimate, Borel summation, physical right inverse, or novelty claim
is formalized here. These are treated, with their actual assumptions, in
`verification.md`. The compiler certifies the conditional algebra just
described; applying it to elasticity and reading the complete analytic proof
remain independent-review obligations.
