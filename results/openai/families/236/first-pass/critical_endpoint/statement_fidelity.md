# Statement fidelity: algebraic core of the critical comparison

Claim: `C_CE_ALGEBRA`. Source: `Main.lean`. Every declaration is in
namespace `CriticalEndpoint`; all scalar variables are real and all natural
indices include zero. There are no probabilistic objects in this formalization.

- `fusion_identity` proves the sign-symmetrized binary-signal fusion identity
  for arbitrary real posterior means `u,v`, assuming all three displayed
  denominators are nonzero. Application to posterior means strictly between
  -1 and 1 satisfies those hypotheses.
- `fusion_loss_lower` uses `u,v` for **squared** posterior means and `q` for
  their common upper bound. Its hypotheses are
  `0 <= u,v <= q < 1`, including `0 <= q`. It proves that the fusion loss is
  at least `2(1-q)uv`; the denominator is proved positive, not assumed away.
  At application, `q=theta^2`.
- `cavity_inverse_bound` proves the inverse two-message inequality from
  `x <= H+theta*y`, `y <= K+theta*x` and `0 <= theta < 1`.
  It does not assert that arbitrary numbers are posterior fields. The
  application takes `x,y,H,K` to be absolute differences on an edge.
- `critical_theta_lt_one` proves `theta < 1` from `b >= 2`, `theta >= 0`,
  and `b*theta^2=1`.
- `critical_moment_gap` proves, for **every** natural `n`,
  `1-theta <= 1-b*theta^(n+3)` under the same critical hypotheses.
  Thus the contraction gap is uniformly positive at every integer
  moment order `p=n+3 >= 3`. It makes no claim at order two, where the
  critical gap is zero.
- `companion_quadratic` proves the normalized edge-transfer matrix identity
  `M(x)^2-2x M(x)+I=0` for every real `x`, with
  `M(x)=[[0,-1],[1,2x]]`.
- `companion_endpoint_power` proves, for **every** natural `n`,
  `M(1)^n=[[1-n,-n],[n,1+n]]`. This checks the linear endpoint growth,
  which must not be discarded by treating the nonnormal edge operator
  as self-adjoint. The matrix is the scalar fiber of the manuscript's
  normalized transfer matrix after conjugation by `diag(1,sqrt(b))`.

The compiler certifies exactly these finite-dimensional identities and
inequalities, including the universal natural-number quantifiers. It does
**not** certify conditional independence of infinite component histories,
spectral-measure transfer, stochastic integral transport, concentration,
the field moment induction as an expectation inequality, or the absolutely
continuous Osgood argument. Those are proved separately in `PROOF.md` and
require independent mathematical review. In particular this source is not
a Lean formalization of the entire FIID threshold theorem.
