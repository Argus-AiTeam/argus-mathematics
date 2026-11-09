# Statement fidelity: continuation core

The declarations in `Main.lean`, namespace `Continuation`, formalize universal
algebraic, order-theoretic, and compactness facts used in the independent
corank-one continuation alternative in `report.md`. This is not a Lean
formalization of the entire schedule theorem or of type-D saturation.

`interior_integer_hit` quantifies over real `s,d` and integer `z`. With
`0<s<1`, `|d|<=1`, and `(1-s)d=z`, it concludes `d=0`. Both coefficient
and gap strictness use exactly this arithmetic statement.

`root_sum_time_strict_between` concerns arbitrary strictly increasing real
functions `f,g`, their zeros `a,b`, and a zero `c` of their sum. For `a<b`
it proves `a<c<b`. `root_sum_time_tie` proves that coincident zeros force
the sum's zero to be the same. `root_sum_median_order` combines these into
the two strict orders or the all-equal case. No differentiability or
linearity is assumed, so these results apply across polygonal shape
breaks. Existence of candidate zeros and orientation of the root level
functions are established in the mathematical report, not assumed
consequences of these Lean declarations.

`a2_diamond_descent` takes that median order for candidate times `i,j,h`
and proves the eight first-time inequalities for the four manuscript
diamonds, in both directions. The implications are listed in this order:
`ij -> jh`, `jh -> ij`, `ih -> ji`, `ji -> ih`,
`ji -> hj`, `hj -> ji`, `ij -> hi`, `hi -> ij`.
The antecedent in each implication is inversion of the old pair's times;
the conclusion says that the new pair's first time is strictly earlier.
The admissible S3 diamond classification and root coefficient maps are
independently checked by `verify.py` and proved in `report.md`; the Lean
theorem does not itself classify Bruhat intervals.

`pair_replacement_lex` allows arbitrary unchanged real-list prefix and
suffix and arbitrary old and new second times. If the new first time
is earlier, the whole new time list is strictly smaller in `List.Lex`.

`finite_sorting_normal_form` quantifies over any finite state type `A`,
any linearly ordered score type `V`, and any relation whose steps
strictly decrease the score. From every starting state it proves
existence of a reachable state with no further step. When every
unsorted state has an allowed decreasing step, this is a sorted state.
`strict_descent_card_bound` proves that a strictly score-decreasing
sequence of `m+1` such states has `m+1<=card(A)`. The report identifies
the finite root-word states and the lexicographic score; that
identification and the bound on their number are not hidden hypotheses
about arbitrary real time lists.

`orthogonal_parity_singularity` quantifies over matrices on an arbitrary
finite index type, over the real field. It assumes `P P^T=I` and
`(-1)^card(I) det(P)=-1` and concludes `det(I-P)=0`. A product of `n+1`
root reflections in dimension `n` satisfies exactly that parity condition.
The determinant-zero-to-fixed-vector implication is ordinary linear
algebra used explicitly in the report, not a separately formalized
existence conclusion of this declaration.

`common_potential_of_fixed_vector` quantifies over real vector spaces
`E,V` and linear maps `B:V->E`, `G:E->V`, `P:E->E`. Its hypotheses are
`B G=I-P`, injectivity of `G`, that every vector in `ker(B)` is a
scalar multiple of a specified `d`, and a nonzero fixed vector `x` of
`P`. It concludes `G L=d` for some `L`. In the schedule application
`B` has position-root columns, `G` is pairing with velocity roots,
and `d` is the primitive half-relation. The report proves these
hypotheses from full root-lattice generation and corank one.

`endpoint_of_compact_right_extension` concerns an arbitrary nonempty
compact subset `S` of the real line bounded above by one. If every
`s` in it below one has a strictly larger point still in `S`, it
proves `1` belongs to `S`. The report constructs this compact
feasibility set from finitely many discrete root words and bounded
integral extrapolations. Lean checks the conclusion given those
topological hypotheses, not the schedule-to-set construction.

All hypotheses above are explicit in the formal statements. None is
an assumption that a schedule continues, that a sorted state exists,
or that the manuscript's main theorem holds. Signed-graph minor bounds,
rank-two geometric admissibility, and assembly of these core facts
remain mathematical proof obligations for independent human review.
