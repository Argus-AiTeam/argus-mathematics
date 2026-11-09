# Statement fidelity: exact finite core of the pin-transfer proof

The declarations are in namespace `PinnedTransfer`. This source formalizes
two universal algebraic/combinatorial ingredients, not the full analytic
Gaussian-field limit theorem `lem:profile-pins`.

`gram x y` is the Kronecker orthogonality kernel for Walsh characters:
one for identical finite sign-support masks and zero otherwise.
`two_sample_gram` quantifies over any finite coefficient index type, any
mask type with decidable equality, two injective mask maps with disjoint
ranges, and arbitrary real coefficients. Its conclusion is that the
double-sum Gram norm of the difference of the two samples is exactly
twice the sum of coefficient squares.

`oldMask`, `freshMask`, `oldMask_injective`,
`freshMask_injective`, and `resampled_masks_separated` justify the
orthogonality assumptions for sign resampling. A mask labels each cluster
by its identity and a Boolean old/fresh tag. Only clusters in `large`
receive fresh signs. The index map `pairs` is injective and every indexed
support touches `large`. The theorem does not require support cardinality
two: it holds more generally for arbitrary distinct affected supports.
In the manuscript application the supports are precisely unordered pairs
of distinct clusters. Unaffected supports cancel before this theorem is
applied.

`sign_resampling_exact` instantiates `two_sample_gram` with these masks.
Its coefficients in the band application are
`lambda * sum_d |d| M_C(d) M_D(d)`. Independence and fairness identify the
Walsh Gram norm with the mean squared change of log band weight; that
probabilistic interpretation is proved in the mathematical report, not
encoded as a probability space in this source.

`cubic_reach` quantifies over real `c,p,e,s,M,m,H`. It assumes only
`c >= 0`, `p >= 0`, `M >= 0`,
`c*p <= e`, `e^3 <= M*s^2`, and `c^2*s^2 <= m*M*H`. It proves
`c^5*p^3 <= m*M^2*H`, including boundary values without division.
For the reach application `p` is an iterated limiting reach probability,
`e` the exposed second mass, `s` the first mass through the comparison
cells, `M` a common bound for second moments of squared mass sums,
`m` the number of cells, and `H` their summed nonnegative cross mass.
The Hölder estimates and variance deficits furnishing the three
hypotheses are analytic obligations proved in the report; they are not
silently formalized by this declaration.

`cubic_slack_identity` is the exact polynomial identity decomposing the
conclusion's slack into those three hypothesis slacks.

No theorem here asserts a Bessel-law counterexample, a continuum limit,
an external citation's correctness, novelty, or independent review.
