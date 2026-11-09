# Statement fidelity: the exact-penalty reduction

The source `Main.lean` formalizes the universal scalar core of claim
`C_LC_PENALTY_ALG`, not the complete geometric claims
`C_LC_EXACT_BRIDGE`, `C_COMP_EXACT`, or `C_CART_EXACT`.

The declarations are `exact_penalty`, `common_budget`, and
`minimizer_defect_zero`, all in namespace `LCSliceAudit`.

`LCSliceAudit.exact_penalty` quantifies over nine independent real
numbers `e, lam, C, D, B, b, h, R, V`. Its hypotheses are positive
defect `e`, positive parameter `lam`, nonnegative constants `C,D,B`,
positive retracted height `b`, the uniform upper bound `b <= B`,
positive retracted volume root `R`, the error bound `h >= b-D*e`,
the volume-root comparison `V >= R/(1+C*e)`, and the one fixed
budget `lam*(D+C*B)<1`. The conclusion is the strict comparison
`lam*b*R < (e+lam*h)*V`. This is exactly the strict inequality
required to exclude an off-constraint global minimizer.

The ledger's extra hypothesis `e+lam*h>0` is redundant: the formal
theorem proves the conclusion without it. It is valid in the
geometric application because the perturbed pair is klt.

`LCSliceAudit.common_budget` says that for all real `S>=0` and
`0<lam<=1/(2*(1+S))`, one has `lam*S<1/2`. Substituting
`S=D+C*B` makes the threshold independent of individual competitors
and yields a margin strictly larger than one half.

`LCSliceAudit.minimizer_defect_zero` quantifies over an arbitrary
type `T`, arbitrary functions `e,h,root : T -> Real`, an arbitrary
map `r : T -> T`, a point `u`, and real uniform constants. It
assumes a nonnegative defect at `u`, zero defect at `r u`, the
height and root-volume comparisons for this pair, and that `u`
is a global minimizer against every `w : T`. It concludes `e u=0`.
Thus there is no finite enumeration of competitors in the formal
argument.

In the geometric interpretation `T` is the set of centred competing
valuations, `e` is lc discrepancy, `h` the chosen height, `root`
the ordinary valuation-volume root, and `r` monomial retraction.
The proof note establishes the comparisons uniformly for every
relevant sublevel competitor and proves that an actual global
minimizer belongs to that sublevel set. The compiler does not
establish that valuations, log discrepancies, volume limits,
resolution charts, or the two manuscript encodings have been
correctly constructed. It does not check the external cited
theorems, the proof note, statement fidelity itself, originality,
or publishable significance. Those are independent review
obligations, not consequences of the Lean exit status.
