# Direct certification of the moving-active collision argument

## Result and scope

The argument of `geo:local-injectivity` is valid for an arbitrary continuous
representing datum, including moving active logarithms and weights tending
to zero. The decisive cancellation is at each finite stage, before division
by the squared separation. No convergence rate of the weights is required.
Here is a complete direct proof, with its scalar limit/cancellation core in
`Main.lean`. The Riemannian hypothesis bridge below is a prose proof, not a
claim that the geometry has been formalized in Lean.

The proof gives the following stronger, fiber-local criterion.

**Theorem (fiber-local projection criterion).** Let \(M\) be a smooth connected
compact Riemannian manifold without boundary, with squared-distance cost
\(c=d^2/2\), and let
\[
 u(q)=\max_y\{-c(q,y)-v(y)\},\qquad v\in C(M).
\]
Fix \((x,p)\in\Gamma_u\) and \(0<t<1\). Suppose

1. \(tp\) is nonconjugate;
2. \(rq\in I(x)\) for every \(q\in\partial u(x)\) and \(0<r<t\);
3. for every such \(r\), every vector \(\xi\), and every segment in
   \(r\partial u(x)\) perpendicular to \(\xi\), the function
   \(w\mapsto A_x(w)(\xi,\xi)\) is concave on that segment.

Then \(F_t:\Gamma_u\to M\), \(F_t(q,a)=\exp_q(ta)\), is locally injective
at \((x,p)\). In particular, weak MTW implies condition 3, and the literal
manuscript lemma follows. Neither subcritical interiority at other base
points nor nonconjugacy of other critical graph vectors is needed for this
local conclusion. The theorem does not assume global weak MTW away from
these specified segments. Connectedness ensures finite geodesic distance
and diameter; the dimension restriction in the manuscript is not used in
this local argument.

The improvement over the strongest relevant prior formal result is a
**direct geometric bridge for arbitrary continuous representing data** and
the above pointwise hypothesis reduction. It is not a claim that moving
parameter Taylor calculus or vanishing-weight cancellation is new:
the upstream `MovingTaylor.collision_limits` already proves those facts.
Mathematical novelty and publishable significance remain questions for
independent review, not consequences of compilation.

## 1. Active logarithms: no finite target or duality assumption

Let \(G_q=\{a:d(q,\exp_q a)=|a|\}\), and put \(D=\operatorname{diam}M\).
The total set \(\mathcal C=\{(q,a):a\in G_q\}\) is closed and lies in the
closed radius-\(D\) disk bundle over a compact base, hence is compact.
Every proper shortening \(sa\), \(0<s<1\), is in \(I(q)\): the original
minimizing geodesic gives a minimizing extension beyond the shortened
endpoint. Such a segment has no conjugate endpoint and has a unique
minimizer, by the index-form argument and the no-corner argument,
respectively. The inverse function theorem and compactness of
\(\mathcal C\) make the total injectivity domain open and the true cost
smooth near every resulting pair.

For an active \(a\in G_q\), write \(y=\exp_q a\) and \(y_s=\exp_q(sa)\).
The energy/concatenation inequality gives, for every \(q'\),
\[
 c(q',y)\le c(q',y_s)/s+(1-s)|a|^2/2.
\]
Activity at \(q\) therefore gives the global lower support
\[
 u(q')\ \ge\
 u(q)+c(q,y_s)/s-c(q',y_s)/s.                 \tag{1}
\]
It touches at \(q\), has gradient \(a\), and Hessian \(-H_s(a)\), where
\(H_s(a)=A_q(sa)/s\). The values of \(v\) enter only an additive constant.
There is no differentiation of \(v\), no fixed target family, and no
replacement of the representing datum by a dual transform.

Taking \(s=1/2\), compactness of the shortened family gives one common
cost-support Hessian bound and neighborhood size. Consequently \(u\) is
uniformly semiconvex and \(D\)-Lipschitz. Its active-log graph is the closed
subset of \(\mathcal C\) defined by
\[
 u(q)+c(q,\exp_q a)+v(\exp_q a)=0,
\]
so is compact.

For completeness, its ordinary subdifferential is exactly the convex
hull of these active logs. The lower directional-derivative bound follows
from (1). For the upper bound along \(q_h=\exp_q(h\xi)\), select a
maximizing target and a minimizing active log at \(q_h\). Apply its
uniform shortened cost support at the point \(q\). After division by
\(h>0\), the resulting upper bound is the pairing of that moving log
with \(\xi\), up to \(O(h)\). Every subsequential active-log limit is active
at \(q\), by the contact equality and continuity of \(u,c,v\). Thus
\[
 u'(q;\xi)=\max_{a\ {\rm active\ at}\ q}\langle a,\xi\rangle .
\]
For a semiconvex function, the ordinary subdifferential is characterized
by these directional inequalities (subtract a common negative quadratic
term in a coordinate chart). Equality of the corresponding support
functions gives
\[
 \partial u(q)=\operatorname{conv}\mathcal V_u(q).       \tag{2}
\]
Finite-dimensional Caratheodory gives at most \(n+1\) terms. Pad with
zero weights and repeated active logs. This pads a **local
representation**, not the representing family of targets.

## 2. A collision produces uniform normalized remainders

Suppose the conclusion fails at \((x,p)\). In shrinking tangent-bundle
neighborhoods choose distinct colliding graph points
\[
 (x_j,p_j),(\widetilde x_j,\widetilde p_j)\longrightarrow(x,p),
 \qquad
 z_j=\exp_{x_j}(tp_j)=\exp_{\widetilde x_j}(t\widetilde p_j).
\]
Nonconjugacy at \((x,tp)\) gives a smooth inverse of
\((q,w)\mapsto(q,\exp_q w)\) near that velocity and a smooth branch cost
\(\widehat c\) on a product neighborhood of \((x,\exp_x(tp))\).
Both velocity sequences are in this same inverse branch eventually.
If their base points were equal, their velocities would be equal.
Thus, after omitting finitely many terms,
\[
 \ell_j=\log_{x_j}\widetilde x_j,\quad
 l_j=|\ell_j|>0,\quad e_j=\ell_j/l_j,\quad l_j\longrightarrow0.
\]
Take a subsequence with \(e_j\to e\), \(|e|=1\), in a local bundle
trivialization. Exchange the two graph points at each stage if needed so
that
\[
 \Delta_j=u(\widetilde x_j)+\widehat c(\widetilde x_j,z_j)/t
            -u(x_j)-\widehat c(x_j,z_j)/t\le0.           \tag{3}
\]
None of these choices requires minimizing behavior of \(tp_j\) or
\(t\widetilde p_j\) at the moving base points. A nonminimizing smooth
geodesic branch still has its ordinary first-variation gradient.

By (2), choose \(N=n+1\) slots
\[
 p_j=\sum_i m_{ji}a_{ji},\qquad m_{ji}\ge0,\quad\sum_i m_{ji}=1,
 \quad a_{ji}\in\mathcal V_u(x_j).
\]
Compactness permits a simultaneous subsequence with
\[
 m_{ji}\to m_i,\quad a_{ji}\to a_i\in\mathcal V_u(x),\quad
 p=\sum_i m_i a_i.                                    \tag{4}
\]
These targets are allowed to move at every stage.

Fix \(t<s<1\). For all possible active logarithms, the family
\[
 \{(q,\exp_q(sa)):(q,a)\in\mathcal C\}
\]
is a compact subset of the open smooth-cost set. A slightly enlarged
neighborhood therefore has bounded third source derivatives and a
common source-neighborhood radius. The fixed branch \(\widehat c\) has
the same properties on a smaller compact product neighborhood of its
limit pair. The short geodesics joining the two poles lie in these
neighborhoods eventually. Taylor's integral remainder, along these
geodesics and with the endpoint held fixed, is bounded by \(C l_j^3\)
with one constant for **all** slots, including zero-weight slots.

Apply (1) at \(x_j\), and add the branch increment in (3). First
variation gives the gradients \(a_{ji}\) and \(-p_j\), and the covariant
Hessians are \(-H_s(a_{ji})\) and \(H_t(p_j)\). Therefore
\[
 \Delta_j\ge l_j d_{ji}+\tfrac12 l_j^2 B_{ji}
                       +l_j^2\epsilon_{ji},            \tag{5}
\]
\[
 d_{ji}=\langle a_{ji}-p_j,e_j\rangle,\qquad
 B_{ji}=[H_t(p_j)-H_s(a_{ji})](e_j,e_j),\qquad
 |\epsilon_{ji}|\le C l_j.                             \tag{6}
\]
No rate for (4) has entered the Taylor estimate. Normalized remainders
tend uniformly to zero because \(l_j\to0\), not because the target or
weight sequences approach their limits quickly.

The Hessians in (6) converge: the critical term is in the one fixed
smooth inverse branch; the shortened term is in the compact smooth-cost
family. Thus \(B_{ji}\to B_i\), and in particular they are uniformly
bounded. Also \(d_{ji}\to d_i=\langle a_i-p,e\rangle\).

## 3. The limiting transverse face

From (3) and (5), division by the positive \(l_j\) gives
\[
 d_{ji}+\tfrac12 l_j B_{ji}+l_j\epsilon_{ji}\le0,
 \qquad\text{hence }d_i\le0.                           \tag{7}
\]
At every stage, not merely in the limit,
\[
 \sum_i m_{ji}d_{ji}
 =\left\langle\sum_i m_{ji}a_{ji}-p_j,e_j\right\rangle=0. \tag{8}
\]
Taking limits in this finite sum gives \(\sum_i m_i d_i=0\).
All summands are nonpositive. Hence \(d_i=0\) whenever \(m_i>0\).
With
\[
 P=\{i:m_i>0\},\qquad E=\operatorname{span}\{a_i-p:i\in P\},
\]
we have \(e\perp E\), \(\sum_{i\in P}m_i=1\), and
\(p=\sum_{i\in P}m_i a_i\). No orthogonality is asserted or needed for
zero-weight limiting vertices.

## 4. The strictly positive gap uses only the limiting fiber

Put \(K=\operatorname{conv}\{a_i:i\in P\}\). By (2),
\(K\subset\partial u(x)\). Hypothesis 2 gives \(rK\subset I(x)\)
for every \(0<r<t\). Hypothesis 3 (or the manuscript's weak MTW
condition with its stated sign convention) gives transverse Jensen:
\[
 H_r(p)(e,e)\ge\sum_{i\in P}m_iH_r(a_i)(e,e).             \tag{9}
\]
Indeed, all chords of \(K\) are in \(E\), perpendicular to \(e\).
This argument never assumes convexity of \(I(x)\); only the specified
contracted hull is used.

The original active velocities \(a_i\) are minimizing. Along a minimizing
ray with velocity \(a\), use parallel orthonormal frames and Jacobi
tensors \(S(0)=0,S'(0)=\mathrm{Id}\) and
\(C(0)=\mathrm{Id},C'(0)=0\). The endpoint-zero index minimizer has
initial derivative \(-S(r)^{-1}C(r)\xi\). Thus
\(H_r(a)=S(r)^{-1}C(r)\); the Wronskian identity gives
\[
 \frac{d}{dr}H_r(a)=-S(r)^{-1}S(r)^{-T}.                \tag{10}
\]
There is a common upper bound \(L\ge1\) on \(\|S(r)\|\) for all
\(|a|\le D\), \(0\le r\le1\), from the smooth Jacobi equation on
the compact velocity disk bundle. For \(r<1\) along a minimizing ray
there is no conjugacy, so (10) gives
\[
 H_r(a)-H_s(a)\ge L^{-2}(s-r)\mathrm{Id},
 \qquad 0<r<s<1.                                    \tag{11}
\]
In particular this sign is a decrease with duration, not an increase.
The zero velocity gives \(H_r(0)=\mathrm{Id}/r\) and is consistent
with the same inequality.

Combining (9) and (11) gives
\[
 [H_r(p)-\sum_{i\in P}m_iH_s(a_i)](e,e)
       \ge L^{-2}(s-r).                              \tag{12}
\]
As \(r\uparrow t\), the center has the prescribed nonconjugate inverse
branch. Its Hessian is continuous along \(rp\); the true-cost Hessians
on the proper contractions converge to this branch Hessian. Thus
\[
 \delta_*=[H_t(p)-\sum_{i\in P}m_iH_s(a_i)](e,e)
             \ge L^{-2}(s-t)>0.                     \tag{13}
\]
Only the **center** needs a branch limit. No assertion about \(sp\),
\(sK\), or \(s\partial u(x)\) is used. Nor is the segment-nonconjugacy
theorem used: nonconjugacy at \(tp\) is a hypothesis of this local proof.

## 5. Exact cancellation precedes normalization

Multiply (5) by \(m_{ji}\) and sum. Nonnegativity preserves the
inequalities; their unit sum makes the left side exactly \(\Delta_j\).
By (8),
\[
 \Delta_j\ge \tfrac12 l_j^2\sum_i m_{ji}B_{ji}
                      +l_j^2\sum_i m_{ji}\epsilon_{ji}.
\]
Consequently
\[
 0\ge\Delta_j/l_j^2
 \ge\tfrac12\sum_i m_{ji}B_{ji}
                    +\sum_i m_{ji}\epsilon_{ji}.       \tag{14}
\]
The absolute last term is at most \(C l_j\), since the weights are
nonnegative and have sum one. For each \(m_i=0\), boundedness alone gives
\(m_{ji}B_{ji}\to0\), regardless of the rate of \(m_{ji}\to0\).
The other terms converge ordinarily, so the first sum tends to (13).
Equation (14) implies \(0\ge\delta_*/2>0\), a contradiction.

This proves the fiber-local criterion and, by its hypotheses, the literal
manuscript lemma. It proves an open-neighborhood injectivity conclusion,
not just the absence of one selected collision sequence: failure of
local injectivity in the metrizable graph produces exactly the shrinking
collision pairs used above.

For clarity, replacing (8) by cancellation only in the limit would be
invalid. A one-slot scalar example is \(l_j>0\), \(l_j\to0\),
\(d_j=-l_j\), \(B_j=1\), \(\epsilon_j=0\),
\(\Delta_j=-l_j^2/2\). It satisfies (5), has limiting \(d=0\) and a
positive quadratic gap, but its finite-stage linear term does not cancel.
This illustrates why the manuscript's exact (8) matters. It is **not**
a counterexample to any manuscript assertion, because that assertion
includes the exact barycentric cancellation.

## 6. Formal and executable evidence

`Main.lean` proves the normalized cancellation theorem for arbitrary
sequences of finite slot types, with no cardinality bound. This is stronger
than imposing one fixed numerical number of slots. It also proves the
first-order limiting inequality, the positive-weight transverse-face
inference, convergence of finite weighted sums, and disappearance of
bounded factors under vanishing weights. The exact upstream moving Taylor
proof is reused for a smooth-parameter version of the contradiction.
There are no geometric imports and no global-support shortcut.

`statement_fidelity.md` specifies every encoded hypothesis and what
remains in the analytic proof above. The authoritative compiler record
is `lean_check.json` and the claim-bound certificate is archived
by `lean_evidence` in this directory's `certificates/`. The installed
adapter takes the source as a positional argument, rather than the
obsolete `--source` spelling in the example mission command.

`verify.py` checks the compiler record against the current source and
fidelity text and replays exact rational stress cases for cancellation,
very slowly vanishing weights relative to squared collision distance,
variable slot counts, and the flat radial sign. These finite cases are
regression illustrations, not the proof of the universally quantified
theorem. The universal mathematical evidence is the Lean proof plus
the analytic argument above. `exact_certificate.json` records that
distinction and leaves independent review pending.

The final real Lean 4.31.0 compiler run returned `exit_code=0` and
`proof_holes=[]`; its separate axiom audit also returned zero. To replay
from the campaign root, run the following, regenerating the exact
certificate if a new compiler run creates a new archived record:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify \
  --project-root . --claim C_LOCAL_INJECTIVITY_CORE \
  --statement-fidelity research/local_injectivity_certificate/statement_fidelity.md \
  research/local_injectivity_certificate/Main.lean > research/local_injectivity_certificate/lean_verification.json
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root "$(pwd -P)"
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root "$(pwd -P)"
$WORKSPACE/argus-live-update/.venv/bin/python research/local_injectivity_certificate/verify.py
```

With the persisted compiler evidence unchanged,
`verify.py --check` instead compares the exact certificate without compiling.

The Jacobian adapter was discovered and a typed symbolic characteristic
polynomial contract was inspected. It is not a limit/Taylor/local-geometry
operation; `jacobian_capability.json` records the mismatch. No unrelated
finite operation was forced onto the claim, and no transport/UNKNOWN/
timeout result was interpreted as mathematical evidence.

## 7. Upstream comparison and remaining frontier

The reused upstream sources are at commit
`4eaee87548250b2682affda7d05d947c05554bae`, under
`lean/OAI/Geometry/WeakMTW/Variations/` and
`lean/OAI/Geometry/WeakMTW/Support/CollisionCalculus.lean`.
Their dependency closure is generic real analysis, ending at Mathlib.
The exact originals, `lean/docs/360.md`, and Apache-2.0 license are
preserved in `upstream_sources/`.
The provisional black-box upstream-calculus assumption is discharged:
the actual proof bodies are incorporated, their equality to the preserved
originals is checked by `verify.py`, and they are kernel-checked as part of
`Main.lean`. Their fixed-commit citation remains provenance, not an
undischarged theorem premise.

The source-research comparison identified
`segment_nonconjugacy`, `convexHull_nonconjugate`,
`transverse_face_jensen`, `critical_jensen`, and
`critical_hessian_gap` as relevant upstream geometric results.
None is reproved or imported here. The first two are not needed for this
conditional local lemma; their role in the full foundation theorem remains
the separate first-cut nonconjugacy step.

Upstream's completed arbitrary-potential global projection theorem uses
finite reduction after the finite-family global theory. Using it to
certify this manuscript's direct continuation proof would bypass the
specific dependency being audited. This report does not do so.

No false literal manuscript assertion was found in the audited mechanism;
there is therefore no refuted `F_` claim to file. The proof does not certify
the full foundation theorem or the spectral/jet/determinant steps of the
transport manuscript. Their load-bearing assertions remain open in the
existing proof graph.

Independent Reviewer replay, statement-fidelity approval, and an assessment
of novelty/significance remain required before campaign acceptance.
