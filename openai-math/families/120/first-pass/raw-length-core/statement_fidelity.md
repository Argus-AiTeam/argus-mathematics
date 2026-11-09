# Statement fidelity: the algebraic core of raw-length transfer

The declarations in `Main.lean`, namespace `RawLength`, concern arbitrary
finite types and real coefficients. No finite search is used to prove them.
They certify claim `C_RAW_ALGEBRA`, not the complete matching algorithm and
not the existence or update complexity of the manuscript's routing structures.

`mass w x` is the weighted sum of absolute **net** coefficients. In
`projection`, `image : E -> Option I` assigns every copied coordinate either
one physical coordinate or a null image. `sign` is an arbitrary real multiplier;
in the manuscript it is a reference-orientation sign. `projection_clip`
states, for every physical coordinate and every live set, that deleting all
copies with dead physical images commutes exactly with signed projection.
Null copies are retained but never projected. `projection_add` proves
linearity for addition.

`mass_nonneg`, `mass_add`, `mass_sub`, `mass_scale`, and `mass_sum` establish
the weighted l1 inequalities for all finite families; nonnegative weights
are required where triangle inequalities need them. `linear_mass_le` is
the general column-sum operator inequality. Its hypotheses state the
nonnegative target weights and an explicit upper bound on every column's
weighted absolute sum; no circulation-ratio conclusion is assumed.

`incidence tail head x` uses incoming minus outgoing divergence. Both
endpoint functions are arbitrary, so parallel edges, loops, and repeated
physical images are allowed. `incidence_mass_le` proves its unweighted l1
norm is at most twice the edge coefficient l1 norm. `completion_cost_le`
then proves the cost of adding one unit null connector for every copied
vertex's divergence is at most three times the old-edge norm, with a
separate additive new-edge cost `n`. The edge lengths must be at least one.
The assertion that these coefficients balance the hubs follows from physical
conservation and is proved in the mathematical report; it is not encoded by
this cost-only declaration.

`walkNet` is the signed count on each edge of a list of unit oriented
traversals. `walkRaw` counts **every** list entry using that edge's weight,
not the absolute net count. `cancel_pair` proves exact signed-count
preservation and a raw-length decrease of twice the erased edge's weight
for an adjacent forward/reverse pair in any prefix and suffix.
`cancellation_nonexpansive` requires that weight to be nonnegative.
Reversing the chosen reference orientation covers the other order.
The report separately proves that reduction of a walk in a forest leaves
its unique endpoint path and that the shared-arm quotient is a forest.
`raw_score_preserved` proves the resulting score comparison for arbitrary
real gradient, nonnegative score, and parent raw length at most child raw
length.

`transfer_bound` is a universal scalar consequence of the **derived**
old-edge child norm bound `q <= (2 beta + 1) A X`, the completion bound
`v <= 3 q + Y`, the local numerator bound, and the child optimum inequality.
Here `X` and `Y` are surviving-frozen and new-edge length norms; `beta` is
the local raw-walk bound per width; `Z` is the score denominator per width;
`L` and `O` are the best local score and child optimum. The geometric
derivation of `q` and the local numerator bound is in the report, not a
hidden premise purporting to prove itself. `max_transfer` converts this
two-term bound to loss `(2 Z + 6 beta + 3) A` relative to a common upper
score `T`. It explicitly requires `A >= 1`, `Z >= 1`, nonnegative `X,Y,beta,T`,
and `L,O <= T`.

`improved_constant` specializes `beta=17(p+1)` and `Z=40(p+1)` for every real
`p >= 0` and `A >= 0`, proving loss at most `5 Z A`.
`manuscript_child_constant` checks the manuscript's looser child coefficient.
`guarded_loss` uses its literal guard `20 Z A <= b^2`.
`recursive_choice` is the max/approximation-factor induction step.
`outer_exponent_margin` proves the polynomial inequality equivalent to the
outer factor comparison after substituting `d=2a-4`, `M=2^u`,
`b=2^(u/a^2)`, and `u >= 2a^2`. Exponentiation and the source's integer
parameter conventions are handled explicitly in the report.

The compiler checks these algebraic statements, not this document's
translation, the geometric construction, the all-terminal compression
argument, external citations, novelty, significance, or algorithmic
complexity. Independent mathematical review remains necessary.
