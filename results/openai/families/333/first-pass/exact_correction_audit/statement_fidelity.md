# Exact statement fidelity

The declarations are in namespace `ExactCorrectionAudit`, in `Main.lean`.
The scalar field is the real numbers; sequence indices are natural numbers.
All displayed variables are universally quantified unless an existential
conclusion is explicitly stated.

`metric_transfer_identity` is the bilinear, single-ambient-component
expansion of equation (27) in `theorem.md`. Here `g_1,g_2` are derivatives
of the unsmoothed map, `s_1,s_2` those of the smoothed map, and `u_1,u_2`
those of the increment. `h,hs,ht` represent a target component, a smoothed
normalized-defect component, and a smoothed-target component. `d,e`
represent the old and new amplitudes. The old defect times `d^2` has
already been replaced by `h-g_1*g_2`. There are no positivity or
nonzero-amplitude hypotheses because this is an identity without division.
Summing the component identity gives the Euclidean metric identity; that
finite-dimensional interpretation is not encoded here.

`summable_increment_margin` assumes real `k >= 10` and `2*m <= k` and
proves `1 < k+(6/5)*(1-m)`. For the analytic application, use the integer
order `m=floor(k/2)`. The declaration does not encode weighted norms,
real powers, summability, or any manifold.

`step_to_affine_bound` assumes `B >= 1`, `x >= 0`, `c <= 1/4`, and
`y <= B/4+c*(1+x)`, and proves `y <= B/2+x/4`. No positivity of `c`
is required by this implication.

`block_bound` assumes `B >= 0` and the affine inequality
`x(n+1) <= B/2+x(n)/4` for every natural index. It proves, for every
index, `x(n) <= (2/3)*B+(1/4)^n*x(0)`. The initial value has no
upper bound and need not be nonnegative for this declaration.

`finite_waiting` assumes `B >= 1`, nonnegative `x(n)`, coefficients
`c(n) <= 1/4`, and the recurrence
`x(n+1) <= B/4+c(n)*(1+x(n))`, at every index. It proves that some
finite index has `x(n) < B`. There is no uniform bound on that index.
The proof uses the Archimedean decay of the geometric sequence, not a
finite search.

`retained_bound_persists` adds `x <= B` to the scalar step hypotheses
and proves `y < B`.

`finite_waiting_after` weakens the coefficient hypothesis to an
eventual bound: there exists `n_0` after which every coefficient is
at most `1/4`. It proves that for every natural `start` there exists
`n >= start` with `x(n) < B`. Together with persistence this justifies
waiting for arbitrarily late finite scale thresholds. Convergence of
the analytic coefficients to zero is proved in the prose argument,
not assumed to be verified by the compiler.

These declarations certify the transfer algebra and the universal scalar
finite-waiting mechanism. They do not formalize smooth sections,
smoothing, the finite mode solver, positivity of phase decompositions,
the full variable-order construction, or the analytic correction
theorem. The latter requires the independent mathematical reading of
`theorem.md`; a successful compile must not be reported as a kernel
proof of that theorem.
