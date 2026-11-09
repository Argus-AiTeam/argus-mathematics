# Statement fidelity: deterministic adaptive cut core

`Main.lean` uses Lean real numbers and an arbitrary finite index type, not a
bounded list of sample matrices. `signPlus` is +1 at zero and -1 on negative
inputs. `response X` is the unnormalized column best-response energy
`sum_k |sum_i X(i,k)|`.

The declarations describing claim `C_CUT_FINITE_CORE` are:

- `adaptive_response_bound`: for every real matrix, every column test with
  absolute value at most one, and every real row-estimate vector, the optimal
  row-response energy is at most the column-response energy of the estimated
  row signs plus twice their total estimation error. The column vector can be
  a realized optimizer; the assertion is uniform over all such vectors.
- `good_configuration_lipschitz`: two arbitrary arrays that agree outside
  ordered pairs incident to a specified set J, and whose separate row and
  column absolute masses are at most d, have response energies differing by
  at most `4*d*card(J)`. There is no assumption about a path of good
  configurations, connectedness, probability, or intermediate arrays.
- `adaptive_deleted_response_bound`: combines the adaptive response inequality
  with deletion of every ordered pair incident to J, costing
  `2*d*card(J)`, not a change to the cut-norm normalization.

The auxiliary declarations prove the scalar sign loss, absolute response
difference, incident mass bound and deletion estimate. Symmetry is not needed
inside these declarations because both row and column mass hypotheses are
explicit. In the probabilistic application they follow from the same
symmetric envelope, including when its entries are multiplied by row signs.
Dividing the response estimates by the positive integer M gives precisely the
manuscript normalization 1/M.

This formalization does NOT encode independence, conditional expectations,
the sampling-without-replacement variance formula, the capped infimum
extension, its probability tail, the finite-size transfer theorem, or any
arithmetic property of the manuscript's kernels. Those parts are proved in
`report.md`; `verify.py` additionally replays exact finite adaptive
optimizations, conditioning and disconnected-good-set extension tests.
Accordingly a successful compiler run certifies `C_CUT_FINITE_CORE`, not the
whole proposition, its arithmetic hypotheses, or the joint Dickman law.
