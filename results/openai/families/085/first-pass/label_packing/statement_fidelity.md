# Statement fidelity: the universal finite-state and birth-aware core

`Main.lean` uses Lean 4.31.0 and Mathlib. Its declarations are in namespace
`LabelPacking`. This is a formalization of the finite algebraic/probabilistic
core, not a formalization of differentiation of tents, essential suprema,
vector-measure integration, or the endpoint Sobolev theorem.

`particle_fill` quantifies over real parent mass M, total child capacity S,
and individual child capacity t. Under 0 <= M <= S, S > 0, and t >= 0,
it proves nonnegativity and exact filling by inherited mass M*t/S plus
newborn mass t-M*t/S. `zero_capacity` proves that every member of an
arbitrary finite family of nonnegative capacities summing to zero is zero.
Together these cover the zero-capacity branch without division by zero.
They do not require positive mass at ancestors.

`unit_chord_identity` is the exact two-dimensional defect identity for
arbitrary real unit-vector coordinates; zero parent mass does not occur
in its hypotheses. `switch_square_bound` proves the scalar squared
triangle estimate used with the Lipschitz square root of the switch
probability. The actual threshold formula and spatial tent bounds are
proved in REPORT.md rather than silently assumed to be formalized.

`stochastic_contraction` quantifies over arbitrary finite input and output
state types, arbitrary signed real input weights, and nonnegative
row-normalized matrices. `markov_one_step` additionally compares an
arbitrary second matrix and nonnegative probability weights at the
reference point. A bound on each individual row's l1 difference implies
the marginal perturbation bound. No marginal-comparison conclusion is
a hypothesis. `observable_perturbation` controls a nonnegative,
uniformly bounded row observable under the two old-state distributions.
Its hypotheses are individual-row bounds, not a spatial-packing or
marginal-comparison assumption.

`discount c n` is the half-discounted sum after n inputs, with initial
state zero and update e_(n+1) = e_n/2 + c_n. Indices in Lean start at
zero: manuscript level s corresponds to input c_(s-1). The second
filter has inputs e_(n+1). All inputs are real and nonnegative; all
depths and birth indices are arbitrary natural numbers.

`inherited_cost_bound` assumes only c_k <= H before the arbitrary
birth index b, with H >= 0. It proves e_b <= 2H and f_b <= 4H.
`birth_convolution` requires also c_(b+n) = 0, the zero extension
after the terminal level, and proves

    sum_(j<n) (e_(b+j+1) + e_(b+j+2) + f_(b+j+1))
       <= 8 sum_(j<n) c_(b+j) + 12H.

It includes arbitrary births, zero active length, and costs inherited
from before birth. It does not assume their summability or the desired
packing estimate. The manuscript application takes H=5 and n=m-B+1.
The unused nonnegative e_(m+1) only enlarges the last-level bound;
the actual final sentinel R_(m+1)=1 is charged separately exactly once.

`scaled_marginal_bound` derives a bound on a nonnegative-cost driven
marginal discrepancy from an additive row perturbation recurrence,
starting with d_0=0. The step sizes alpha double at successive levels.
`spatial_observable_bound` combines that result with the individual-row
observable estimate. For alpha_k <= 2 and K >= A, K >= 2FD it concludes
cost <= K e_(k+1). Its premises are the row-derived recurrence and
observable bound, neither the spatial-comparison conclusion nor packing.
The concrete tent/P(d) estimates supplying those premises, the first-row
embedding, and the conversion to uniform and essential suprema are
discharged in REPORT.md.

`finite_weighted_transfer` quantifies over an arbitrary finite particle
type and nonnegative real masses. It is the final finite-sum integration
step once the independently proved per-particle and occupancy bounds
have been substituted. It does not certify those geometric premises.

The compiler establishes precisely these finite real identities and
inequalities. The remaining statement-fidelity and geometric bridge
are mathematical proofs in REPORT.md and require independent human/
Reviewer reading; a successful compile alone must not be reported
as formal certification of Proposition prop:label-packing or thm:main.
