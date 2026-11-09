# Source facts and scope

The target is `geo:local-injectivity` in the staged foundation manuscript
`build/sections/geometry.tex`, not the downstream global-support theorem.
The ambient assumptions are smooth connected compact boundaryless Riemannian
geometry, dimension at least two, and weak MTW on the open injectivity domain.
The potential has an arbitrary continuous representing datum.

The source explicitly allows moving active logarithms and zero weights. The
number of slots is fixed at `n+1` by Caratheodory, while their targets are not
fixed. The branch at time `t` is a nonconjugate local geodesic branch, not an
assumption of cut avoidance. At the later time `s`, only original minimizing
active rays are shortened. No assertion about `s * partial u` is needed.

The source ingredients to be checked in the bridge are `geo:prelim`
(compact active graph and active hull), `geo:radial-index` (strict radial
divided-action decrease), and `geo:slack` (transverse Jensen plus a branch
limit from earlier scales). The local proof does not use
`prop:segment-nonconjugacy`: nonconjugacy at time `t` is already a hypothesis
of this lemma. That proposition is used later by the global continuation.

At upstream commit `4eaee87548250b2682affda7d05d947c05554bae`,
`lean/docs/360.md` explicitly distinguishes the finite-family geometric
integration from the arbitrary-potential local-injectivity assertion.
The upstream generic `MovingTaylor.collision_limits` already treats moving
parameters and vanishing weights. A new elementary cancellation lemma alone
would therefore not establish mathematical novelty. The additional obligation
here is the direct arbitrary-continuous-datum geometric bridge, without using
downstream global support or the arbitrary-potential global projection API.

The staged transport manuscript imports the foundation geometry and adds
spectral comparison, scale selection, jet selection, determinant estimates,
and a final matrix contradiction. These are separate open assertions in the
campaign decomposition, not conclusions of this local certificate.

The supplied cross-campaign Wiki index was searched for MTW, optimal
transport, injectivity, Taylor, Jacobi, and squared distance; it supplied no
relevant established result for this mission.

No false manuscript assertion has been established at this point. In
particular, a bare matrix example without the geometric hypotheses would not
refute this local lemma.

The official checker rejects even a retired route whose goal reference
names a superseded claim version. After making connectedness explicit in
the fiber-local goal, the retired route's stale goal reference was rebound
to that clarified current goal as the checker requires. Its retirement
reason and obligations were preserved. No mathematical statement, evidence
tier, or derived status was weakened or assigned by this repair.
