# Reading of `Main.lean`

The claim is `C_LPP_ALGEBRA`. The file proves a universal finite algebraic
core, not a discretization theorem for Brownian motion or a theorem about a
Bose gas. All sums range over arbitrary finite types, not over a tested list
of examples. Scalars are real. Empty finite types are permitted when the
displayed hypotheses permit them.

The declarations in namespace `LongPalmProduct` are:

- `marginal_product_identity`: for arbitrary real weights and functions on
  shared coordinates `A`, private coordinates `B`, and private coordinates
  `C`, the full product integral equals the integral of the product of the
  two shared-coordinate marginals. No independence of coordinates *within*
  either function is assumed. The product reference weights are explicit.
- `shared_output_bound`: if the first shared-coordinate marginal is at most
  `G`, the second function has weighted total mass at most one, and its
  weights and values are nonnegative, the full integral is at most `G`.
  The shared weight and `G` are nonnegative. The first function and its
  private weights need not be nonnegative for this stronger algebraic
  statement, although they are nonnegative in the application. Substitute
  `G = G_D^q`. `A` is the product space of shared outputs, not the set of
  shared labels. A singleton `A` represents disjoint changed sets.
- `source_mixture_bound`: a pointwise latent-source domination
  `mu <= C * rho` transfers through any nonnegative kernel whose `rho`
  mixture is at most `R * b`, giving the bound `C * R * b`.
  Only `C` is required to be nonnegative by the encoded implication.
  The kernel can be deterministic. In particular no independence of a pin
  and its own latent source is postulated.
- `cross_source_bound`: `mu` is a nonnegative latent-source weight, `k` is
  an own-output kernel with row sums at most one, `g` is a nonnegative
  *opposing* output weight with total mass at most one, and `cost(x,w)` is
  nonnegative. If its `mu` integral is uniformly at most `H >= 0` for
  every opposing output `w`, the complete integral, including the
  own-output kernel, is at most `H`. The expression multiplies `mu` and
  `g`; this encodes separation between protocols as a hypothesis. It
  does not prove that the manuscript's separate protocols are independent.
  Kernel nonnegativity is not needed for this upper inequality; in the
  application the kernels are subprobability kernels and are nonnegative.
- `deleted_check_tag_error`: for nonnegative base weights, reference
  weights `a <= aMinus`, a tag `0 <= h <= 1`, and positive original
  normalizer, the normalized nonnegative tag error after check deletion is
  at most the deleted/original normalizer ratio minus one.
- `routeMass` and `selected_route_bound`: an arbitrary finite list of
  nonnegative transition matrices, with nonnegative history-uniform row
  caps, has total path mass at most the product of those caps. The type
  `H` can retain the complete preceding history and auxiliary variables.
  After fixing the latent input and selected outputs, their primary
  constraints can be incorporated in the transition matrices. An
  unselected subprobability stage has cap one; a selected stage has the
  cap furnished by its primary marginal. Thus no factor is charged for
  the number of unselected stages. The finite theorem does not prove the
  corresponding analytic kernel hypotheses.

The prose proof in `report.md` supplies the measurable-kernel extension
using nonnegative integration, the normalizer insertion argument, the
Gaussian source-cost estimate, and the source-faithful application. Those
arguments, the actual Brownian input estimates, source-map correctness,
novelty, and publishable significance are not checked by the Lean compiler.
The formalization contains no axioms specific to this project, no `sorry`,
and no claimed equivalence between a finite fixture and the Brownian gas.
