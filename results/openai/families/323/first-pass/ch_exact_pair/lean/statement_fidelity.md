# Statement fidelity: the grouped-recursion kernel

This source formalizes **C_CH_KERNEL**, not the whole separable quotient
construction or the existence of the manuscript's block windows.

`ExactPair.power_sum_at_most_one` quantifies over every finite index type,
every real exponent other than zero, and every real family with at most
one nonzero entry. It proves the exact identity for the power of the
absolute value of the sum.

`ExactPair.disjoint_sum_norm` and `ExactPair.disjoint_sum_bound` quantify
over every finite real coordinate space, every finite group of vectors,
and every finite exponent `p : ENNReal` with `1 <= p` and `p != infinity`.
The norm is Mathlib's actual `PiLp` norm, with real exponent `p.toReal`.
The support hypothesis is pointwise: for distinct children, at least
one of their entries at every coordinate is zero. The first declaration
proves exact addition of the pth powers of the norms. The second derives
the cardinality-to-the-1/p bound from individual norm bounds `K >= 0`.
There is no bound on dimension, cardinality, or exponent.

`ExactPair.grouped_bound` allows a different finite child type in each
finite group and arbitrary nonnegative real group coefficients. It
bounds the norm of the weighted recombination by
`K * sum_g a_g * card(H_g)^(1/p)`. Its only disjointness hypothesis is
within each group. Vectors belonging to different groups may coincide.
This is the manuscript's contraction with groups indexed by distinct
active weights, `a_g = abs(path coefficient)/m_j`, and at most `L_j`
children. It does not assert disjointness across weights.

`ExactPair.assignments_give_disjointness` derives the pointwise hypothesis
from disjoint finite assigned sets and support on those sets.
`ExactPair.supported_recombine` proves that recombination stays supported
on the parent assigned set whenever every child set is contained in it.
Iterating this declaration preserves the hypothesis needed when charge
vectors, rather than original evaluations, are substituted.

`ExactPair.product_crop_between` quantifies over arbitrary points, an
arbitrary index family of linearly ordered attributes, arbitrary
order-convex coordinate sets, and a block family strictly successive in
every attribute. If the crop meets an earlier and a later block, it
contains the entire intermediate block. The convexity hypothesis is
written out as the between-points property, rather than hidden in an
interval type. `ExactPair.at_most_two_partial` proves that a finite set
of partial hits has cardinality at most two when an intermediate partial
hit cannot lie between two hits. `ExactPair.product_crop_partial_bound`
formally composes these statements: for any finite assigned index set,
the filter of blocks met but not wholly contained in the product crop
has cardinality at most two. It uses precisely the convexity and
simultaneous strict-succession hypotheses above, not an assumed bound
on the number of partial hits.

`ExactPair.smallBudget_le` proves, for **every natural cutoff depth**,
the bound `sigma/(1-c) + c^d K` for the recurrence starting at `K` and
iterating `sigma + c * previous`, assuming `0 <= c < 1` and `sigma >= 0`.
`ExactPair.chargeNodes_le` proves the complete b-ary tree bound
`chargeNodes b d <= (1+b)^d` for all natural `b,d`, including `b=0`.
These declarations prove the norm and counting majorants; they do not
identify a manuscript expression with those majorants.

`ExactPair.uniform_budget_closed`, `ExactPair.manuscript_small_budget`,
and `ExactPair.final_constant` check the strengthened rational constants:
the uniform bound `130/7`, the small-plus-residual coefficient `1682/7`,
and the final coefficient `1794/7`. The cutoff theorem assumes
`c^d <= theta`, which follows in the manuscript from `c <= 1/8` and its
depth condition. It does not assume the desired evaluation estimate.

The human mathematical work still to be checked is the bridge in
`../theorem.md`: decomposing each actual cropped pure or mixed expression,
proving the six-mark and boundary-incidence estimates, and associating
its cut tree with these formal majorants. The compiler does not verify
that bridge, path coding, Ramsey thinning, Banach-space compactness,
parameter existence, or Proposition `path:weak-cauchy`. In particular,
this certificate must not be described as a Lean proof of `C_CH_EST`,
`C_CH_WINDOWS`, or the CH counterexample.
