# Statement fidelity: algebra and valuation core, not the analytic theorem

The declarations below are in namespace `ToroidalVolumeAudit` in `Main.lean`.
The natural-language claim they formalize is `C_TV_FORMAL_CORE`.
They do **not** encode the entire claim `C_G_VOLUME`.

`cleared_logarithmic_determinant` quantifies over every finite index type,
every commutative ring, every square matrix `A`, row `k`, row vector `m`,
and scalar `t`. Replacing row `k` by `m + t * A k` makes the determinant
exactly `det(updateRow A k m) + t * det A`. In particular, as a polynomial
in a uniformizer, there is no term of degree greater than one. This is
the cancellation behind the logarithmic-top-form argument in report.md.

`at_most_simple_logarithmic_pole` quantifies over every field and the
same finite matrix data, with `t != 0`. Its exact identity says that
multiplying a determinant whose only polar row is `A k + m/t` by `t`
clears its denominator. Passing from this identity to an order along
a geometric divisor still requires the regularity of the other
coefficients, supplied in the prose proof by writing rational
characters as powers of a uniformizer times units.

`correction`, `room`, `correction_nonnegative`, and `room_identity` use
rational numbers: `correction lam = max(0, lam-1)` and
`room lam = min(lam, 1) = lam-correction lam`.

`correction_bounded_by_jacobian` quantifies over rational `a,e,lam`,
assuming `a >= 0`, `e >= 1`, and `e*lam <= a+1`. It proves
`e*correction lam <= a`, equivalently the manuscript boundary
coefficient `-a+e*correction lam <= 0`. The geometric multiplicities
are positive integers; the formal result allows all rational `e >= 1`,
so it covers, rather than weakens, that case.

`nonexceptional_branch_forces_zero` assumes `e >= 1` and
`e*lam <= 1` and proves the correction is zero. In the geometric
application this is the branch with Jacobian discrepancy `a=0`.

`minimum_positive` quantifies over any index type, rational functions
`a,e` with `a(i)>=0`, `e(i)>0`, and an index attaining
`e(i)*lam = a(i)+1`. It proves `lam>0`. `positive_room` then proves
that the allowed perturbation interval has positive length.

`sharp_prime_threshold` quantifies over any index type and rational
`a,e,lam,b`. All `e(i)` are positive; every
`e(i)*lam <= a(i)+1`, with equality at at least one index. It proves
the exact equivalence

    (for every i, a(i)-e(i)*(correction lam+b) > -1)
        if and only if b < room lam.

The existence of a minimizing branch, not finite numerical sampling,
is a formal hypothesis. Geometrically it follows from the finite
nonempty collection of components over a fixed base prime. The formal
equivalence does not need `b>=0`; the metric perturbation theorem
separately imposes that condition for semipositivity.

`full_support_discrepancy` quantifies over an arbitrary valuation index
type and rational-valued functions `lc,cartier`. Its hypotheses are
nonnegativity of both functions and strict positivity of `cartier`
where `lc=0`; its conclusion is strict positivity of their sum at
every index. The prose proof, not Lean, verifies the geometric
identification `A_Theta = A_D + v(D-Theta)`, rational Cartierness,
effectivity, and the full-support property for all divisorial valuations,
including non-toric valuations.

`klt_type_monotonicity` proves the analogous universal implication
with a strictly positive initial discrepancy and a nonnegative
effective-Cartier contribution. This is the numerical core of the
non-toroidal, locally-klt-type extension in report.md; Lean does not
construct a klt boundary on a variety.

`blowup_endpoint` proves for all rational `codim,s` that the corrected
exponent `(codim-1)-(codim-1+s)` is greater than `-1` exactly when
`s<1`. The geometric example separately has integer codimension at
least two and verifies all model, metric, rank, and strictness hypotheses.

No declaration formalizes Berndtsson's theorem, plurisubharmonic
removability, fiber integration, resolution of singularities, or
the equality between analytic integrability and discrepancies.
Those are proved or explicitly cited in report.md. A compiler success
certifies exactly this algebraic core, not a fully formalized
anticanonical nonvanishing theorem, novelty, or publication significance.
