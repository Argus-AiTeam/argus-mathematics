# Statement fidelity: the finite-volume core of Theorem k:range

The declarations in `Main.lean`, all in namespace `RangeAudit`, are real-algebra and finite-sum results. They
are not a formalization of continuum Gibbs integration or of thermodynamic
limits. The all-parameter analytic pressure comparison is proved separately
in `report.md`; the compiler is not being asked to certify that report.

- `symmetric_kernel_domination` quantifies over every finite type,
  every real vector of counts, and every nonnegative symmetric real kernel.
  A common upper bound `r` on its row sums bounds the quadratic form by
  `r * sum_i n_i^2`. In the pressure proof use the block kernel `K+`; adding
  diagonal self terms and interpreting particle counts are analytic steps
  outside this declaration.
- `count_cutoff_bound` quantifies over an arbitrary finite sum.
  Each retained summand is bounded by `cap >= 1`, and the entire omitted
  tail is at most one. The total is at most `(number retained + 1) * cap`.
  Substituting exponential grand weights, taking logarithms, and establishing
  the uniform grand-tail bound are outside the formal statement.
- `independent_pair_lower` bounds a finite constant-density
  pair sum from below using lower row sums. It applies after independence
  of distinct whole boxes has replaced pair expectations by products of
  means. Independence, the diagonal omission, boundary-row restriction,
  volume normalizations, and the large-volume limit are not encoded here.
- `arbitrary_box_density_lower` has arbitrary real box density
  `d`, active shift `u`, and a bound `d^2 <= D^2`. Its coefficient `c >= 0`
  represents `beta * a`. Given the Jensen lower bound `hbase`, the finite-box
  comparison `hbox`, and the active-value identity `hactive`, it proves the
  pressure lower bound with deletion error `2*delta` and kernel error
  `c*eta*D^2/2`. It assumes neither `d = u` nor convergence of `d`, and allows
  `c = 0`. Its premises, not the compiler, carry the continuum probability.
- `balanced_ratios` has arbitrary positive reals `r,p` and any
  real `s` between `r*p/2` and `r*p`. It proves
  `r/s + s/(r*p^2) <= 3/p`. For the manuscript take `r=R0`,
  `p=sqrt(R/R0)`. Constructing the aligned rounded side satisfying these
  inequalities and absorbing the count entropy are proved in the report.
- `two_sided_pressure_balance` takes the same scale conditions
  and two-sided pressure inequalities as explicit hypotheses. It concludes
  an absolute pressure error at most `3*C/p`. The analytic upper and lower
  inequalities are not silently discharged by this statement.
- `small_mass_crossover` has arbitrary reals `e,a,epsilon,L,B`,
  with positive `a,epsilon`, `L >= 1`, and `B >= 0`. From `e <= B*a` and,
  whenever `L*epsilon <= a`, `e <= B*sqrt(a*epsilon)`, it concludes
  `e <= B*sqrt(L)*min(a,sqrt(a*epsilon))`. The report supplies these two
  hypotheses for the absolute pressure error. It makes no claim about
  novelty, phase transitions, or the companion manuscript.

No result here assumes pressure differentiability, an active density lower
bound, a lower bound on the positive added mass, or a bound on the number of
reference interactions. No declaration purports to formalize either
manuscript's main phase-transition theorem.
