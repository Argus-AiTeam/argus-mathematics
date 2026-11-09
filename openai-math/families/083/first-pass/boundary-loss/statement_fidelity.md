# Statement fidelity: BoundaryLoss

`Main.lean` formalizes the finite algebraic, order, and normed-vector core of
the boundary-weight removal argument, for claim `C_BOUNDARY_CORE`.
All natural-number depth and offset variables are universally quantified;
there is no numerical depth cap. It imports the installed Mathlib and uses
the real numbers and arbitrary real normed vector spaces.

`partialSum a k` means the sum of `a i` over `0 <= i < k`.
`offset_telescope` is the unrestricted shifted finite-sum identity.
`prefix_truncate` and `stopped_telescope` assume exactly that `a i = 0`
for every `i >= k`. Their conclusion is
`sum_{i<k}(a i-a(i+r))=sum_{j<min(r,k)}a j`.
This includes zero depth, zero offset, an offset equal to the depth, and
an offset larger than the depth. Positivity is not needed for this identity.
For the manuscript application, `a i` is `log(M_i(epsilon)/h_T)` before
`k_T` and zero at and after it; it is not the possibly undefined logarithm
of an ineligible top's later mass.

`geometric_layers` proves the exact finite geometric-layer formula (8) in
`proof.md`, including the terminal tail `q^k * partialSum a k`.
`stopped_layers` substitutes the exact stopped telescope into that formula.
These identities hold for every real `q`; the identities themselves need no
positivity hypothesis. `geometric_sum_identity` and `geometric_sum_finite`
give the finite geometric sum, the latter under `q < 1`.
`geometric_sum_uniform` requires `0 <= q < 1` and bounds every such finite
sum by `1/(1-q)`.
`potential_finite` assumes `a i <= A` for `i < k` and `0 <= q < 1`,
and proves the finite-depth bound
`sum_{i<k} q^i*a i <= A*(1-q^k)/(1-q)`.
`potential_uniform` additionally assumes `0 <= A` and proves the
depth-independent bound `A/(1-q)`.
In the application, `q=1/G` and `A=log(n/h_T) >= 0`.

`boundary_log_compare` takes arbitrary real masses `0 < u <= x` and
`0 <= e <= v-u`, and proves
`log((x+e)/x) <= log(v/u)`.
Here `x` is the full eligible parent mass, `e` is extra boundary mass,
`u=M_i(b)`, and `v=M_i(epsilon)`. Thus it does not replace the parent
denominator by an unrelated mass.

`central_log_cancel` proves the telescoping equality between the logarithm
of the root/terminal normalization and the sum of consecutive-mass
transition logarithms, and the sum of the boundary logarithms.
It is a real additive identity involving `Real.log`; it does not assert
an exponential or real-power identity without positivity. The application
to the positive masses, exponential, and real powers in `eq:src-30` is
justified in (9) of `proof.md` and checked on exact rational products by
`verify.py`.

`abel_suffix` is the exact finite triangular exchange:
the sum of packet vectors `x l` weighted by `sum_{j<=l} e j` equals the
sum of `e j` times the suffix from `j` through `n-1`. It holds in any real
module whose additive group is commutative.
`abel_suffix_bound` is its norm bound in any real normed vector space:
if `e j >= 0`, all those suffix norms are at most `H >= 0`, and
`sum_{j<n}e j <= D`, the weighted sum has norm at most `D*H`.
`monotone_deficit_bound` specializes this to `delta 0=0`,
`delta j <= delta(j+1)` for every `j<n`, and the same suffix bound;
it proves `norm(sum_{l<n}delta(l+1) * x l) <= delta n * H`.
In the manuscript, the group of packets stopped at zero has deficit zero
and is omitted; `x l` in this last theorem is the group stopped at `l+1`,
`n=k_T`, and `delta l=1-kappa_l`. Empty groups are permitted. A complex
Hilbert space can be viewed as a real normed vector space, so this statement
does not impose a dimension restriction.

The Lean file does **not** encode the slopes, interval geometry, eligibility
sets, Lebesgue measure, common translated grids, or the analytic upstream
top-interval/mass estimates. It proves the uniform stopped cancellation,
finite-layer integration algebra, logarithmic comparison, and packet
summation lemma used after those objects are supplied. Equations (2)-(7)
and (9)-(14) of `proof.md` supply the source-faithful geometric and analytic
application. In particular, the matching marginal distribution under a
single common translation is a prose proof, not a Lean theorem. Neither
this formal core nor a compiler result certifies the main Hilbert-transform
theorem or novelty. Independent review of this correspondence is required.
