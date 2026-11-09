# Formal statement fidelity

`Main.lean` is an independently authored exact core, not a formalization of
the entire mass-action theorem. All declarations below are in
`Campaign149.BoundedKinetics`.

`uniform_cut_margin` quantifies over an arbitrary finite reaction-index type,
an arbitrary subset of downward reactions, real rates, real upper bounds,
real weights, and an arbitrary nonnegative comparison factor and chosen
upward-source weight. Nonnegative rates bounded by their upper bounds and
the individual downward weight comparisons imply the uniform cut estimate

    up - sum_down k_e w_e >= (lo - eta sum_all upper_e) w.

The hypothesis `lo*w <= up` is supplied by one upward edge. The finite-graph
return-path argument supplying that edge, the level-cut decomposition,
and monomial comparisons are proved in the report, not encoded here.
`strict_cut_margin` proves positivity when both this margin and weight
are positive. `positive_gap_sum` quantifies over arbitrary finite cuts;
it proves the explicit positive bound `2*H*rho*v` if every cut term is
nonnegative and one cut has gap at least `2*H` and flux at least `rho*v`.
These statements do not assume any continuity of kinetic schedules.

`ceiling_invariance` proves that a scalar function bounded above by M and
nondecreasing after s stays equal to M if it equals M at s.
`integrated_trapping` quantifies over every real scalar function g, real
ceiling M, lower bound L, positive delta, and start time s. It assumes
L <= M, L <= g(s), a ceiling and monotonicity on all times >=s, and an
integrated growth bound on each interval [s,t] where g remains strictly
below M. It concludes equality to M at every
t >= s+(M-L+1)/delta. It assumes neither differentiability nor a
right derivative. The positive slack 1 avoids a limiting-time argument.

`ScaleData Omega` has arbitrary parameter type Omega, with no topology,
finiteness, or compactness requirement on Omega. A parameter represents the
pair (initial state, measurable schedule). Its scalar functions and box
predicates are indexed by natural-number scales. It assumes positive
scale-dependent delta, scale-dependent lower and upper scalar bounds,
monotonicity/growth while confined to a box, containment of plateau i
in box i+1, and initial confinement to plateau 0. No nesting of plateaux
is assumed. `ScaleData.uniform_absorption` concludes that every parameter
is in plateau n at every time >= `entryTime n`, where `entryTime` adds
the delays of scales 1 through n and is independent of the parameter.
The theorem proves the scale induction and the uniform scalar entry
argument; it does not merely assume absorption or its uniformity.

`logScale_zero`, `logScale_succ`, and `logScale_reaches_cap` concern
`q_n = max(qP, q0/2^n)`. For 0<qP<=q0 these are exactly the logarithmic
coordinates q=-log h of the capped square-root scales in the report.
The recurrence and finite attainment of qP are proved for arbitrary
positive real qP; the natural-number estimate used in the proof is
unbounded and is not a finite numerical experiment.

Outside this formal boundary are: the already independently certified
affine lemma; finite-dimensional plateau geometry; the elementary
return-path/cut identity; monomial positivity and degree lower bounds;
Lebesgue integration and the absolutely continuous finite-minimum
argument; local Caratheodory existence/uniqueness; the topological
no-first-exit argument and compact continuation; and the translation
between logarithmic scales and boxes. The complete proofs and cited
standard analytic inputs appear in `report.md`. Consequently a compiler
success closes `C149_BK_CORE`, not `C149_BOUNDED_KINETICS`.
