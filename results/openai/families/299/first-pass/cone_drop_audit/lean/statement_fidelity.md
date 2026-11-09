# Statement fidelity: universal supporting core

The declarations in `Main.lean` certify the following supporting
statements, not the complete C*-algebra proposition.

`projection_relations`, `partialFlip_unitary`, and the two
`partialFlip_*` endpoint statements quantify over every complex algebra
with the indicated ring and compatible involution structures. They use
the actual polynomials P=(1+F)/2, Q=(1-F)/2, U=P+zQ. The hypotheses are
F^2=1, F*=F and conjugate(z)z=1, not a sampled set of phases.
`conjugation_mul` and `conjugation_star` verify the required algebra
relations for arbitrary elements of a possibly noncommutative algebra.
`phase_unitary` proves the unit-circle condition for the actual source
phase exp(i pi s), for every real s. `actualPath_initial`,
`actualPath_terminal`, `actualPath_unitary`, and
`actualPath_continuous` therefore check the endpoints, unitarity, and
continuity of the manuscript's actual exponential path, not a
replacement rational parametrization.

`flip_involution`, `flip_selfadjoint`, `flip_swap`, and
`matrix_partialFlip_unitary` concern the actual permutation matrix for
(i,j) -> (j,i), on every finite index type. Thus the results cover all
matrix sizes, not just M2. `flip_swap` uses the ordinary Kronecker
product and proves F(a tensor 1)F=1 tensor a.

`uniform_conjugation_bound` quantifies over every normed *-ring with
isometric involution and all u,F,a satisfying norm(u),norm(F)<=1.
It proves the uniform bound 2 norm(a) norm(u-F). Application to the
recursive simplex's terminal vertex also uses contractivity of unital
C*-homomorphisms; that application is explained in the prose proof.

`gap_bounds`, `cut_gap_zero`, `cut_positive`, and `gap_positive` concern
the exact real positive-part formulas, for every positive delta and
every real t, with t>=0 where the bound requires it.
`finite_maximum`, `weight_at_max`, `denominator_bound`, `weights_sum`,
`zero_face`, and `axis_weights` quantify over arbitrary finite index
types. The latter proves the exact normalized vertex, not merely
closeness to a vertex, under delta<t_j and t_i<delta/2 for i!=j.
The denominator lower bound is 1/2 whenever the positive maximum d is
attained. These are precisely the support and face inputs to the
recursive construction.

`product_defect_bound` and `cube_origin_bound` quantify over every
finite coordinate set. They prove 0<=H<=(2/delta) sum_i t_i for the
actual product H=1-product_i max(1-2t_i/delta,0). The empty set is
allowed in these auxiliary inequalities; the construction uses k>=1.
The norm bounds for a_i and v then give continuity at the origin.

`amplification_parameters` proves existence of finite positive L with
d^L>=N and positivity of k=N^L and m=k+L, for every d>=2,N>=1.
It chooses the valid, not necessarily economical, value L=N.
`tensor_word_count` proves the exact d^L count of tensor words.
`tensor_absorption` quantifies over arbitrary preordered additive
commutative monoids and an order-preserving bilinear additive map T.
Its hypotheses are exactly u<=k e, k x<=N y, and N e<=u. Its conclusion
is T(x,u)<=T(y,u). It assumes no cancellation, strict comparison,
division in an ordered monoid, or stable rank.

The compiler does not check the cubical-section C*-algebra
identification, the analytic full-cut argument, the induction producing
the entire continuous simplex family, or the identification of the
abstract ordered monoids with Cuntz classes in maximal tensor products.
The report supplies those arguments. In particular this source must
not be described as a Lean formalization of arbitrary C*-algebras, of
the upstream full-cone construction, or of Jiang-Su absorption.
