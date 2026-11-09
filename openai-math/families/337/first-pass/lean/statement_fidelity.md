# Statement fidelity: critical compactness and square saturation

Claim `L_MASS_CLOSURE` is the universal real-variable closure used in
Sections 4 and 5 of `research/sobolev_verification.md`. It is not the
geometric Sobolev theorem and does not formalize Sobolev spaces, integrals,
weak derivatives, curvature comparison, balancing, or zero extension.

All five declarations below are in namespace `SobolevAudit`. Their
unqualified names are `critical_constants`, `critical_mass_exponent`,
`no_mass_loss`, `coordinate_bound`, and `square_rigidity`.

`critical_constants` quantifies over every real `m>2` and
proves positivity of `c=4/(m-2)` and the three coefficient identities
`q-2=c`, `c*alpha=2`, `c*alpha^2=m-2`, with
`q=2*m/(m-2)` and `alpha=(m-2)/2`.

`critical_mass_exponent` proves
`0<(m-2)/m<1` for every real `m>2`. The exponent `(m-2)/m` is `2/q`
in the application; the corresponding rational identity is also replayed
by `verify.py`.

`no_mass_loss` quantifies over real `p,Y,B,t`. Its hypotheses
are `p<=1`, `0<=Y<B`, `0<=t<=1`, and
`Y*t^p+B*(1-t)^p<=Y`. Its conclusion is `t=1`.
Here `B` is the sharp Euclidean threshold `Y_m`, `Y` is the Dirichlet
infimum, and `t` is the limiting critical mass. Real powers are Mathlib's
real powers. Positivity of `p`, although true in the application, is not
needed for this stronger implication. In particular `Y=0` is included;
no division by `Y` or strict-concavity shortcut is hidden.

`coordinate_bound` quantifies over real `c,q,Y,E`.
If `c>0`, `c=q-2`, and `(q-2)*Y<=c*E`, then `Y<=E`.
The analytic argument, not Lean, produces this scalar inequality by
summing the balanced coordinate variations.

`square_rigidity` quantifies over real `c,Y,E,D`.
If `c>0`, `D>=0`, `E+c*D<=Y`, and `Y<=E`, then `D=0`.
In the application `D` is the integral of
`|grad psi-alpha*psi*grad u|^2` and `E` is the weighted map energy.
The analytic identification of that integral and the inference of
almost-everywhere vanishing are outside this formalization.

These are implications with explicitly stated input inequalities, not
axioms asserting that a geometric minimizer exists. The compilation
record can close only `L_MASS_CLOSURE`. It cannot confer a kernel status
on `C_EXTRINSIC_SOB`, its arbitrary-codimension extension, or the
manuscript's downstream comparison and equality theorems.
