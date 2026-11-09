# Balanced simultaneous torsor gluing

**Assessment: supported conditional construction, not an unconditional
arithmetic theorem.** This is `L_ABG_GLUE@1`, old `theorem.md` Section 5.
The distinction between the gluing argument and construction of its inputs
is necessary to reconcile its old support receipt with the open lift.

## Exact statement and input hypotheses

Take the two supplied characteristic-zero component systems, compatible
finite right \(Q_r=J/J_r\)-torsor towers, and prescribed semilinear
arithmetic actions. At every node suppose the actual fiber identifications
are reductions of fixed \(P_i\in J\), satisfying
\[
 P_i\exp(-eaN_i)P_i^{-1}=\exp(aN_i),\qquad
 P_{\pi i}B_i=B_iP_i .
\]
The marked points have matching residue fields and compatible tangent
parameters. Choose divisible root orders killing all finite-stage inertia,
balanced proper twisted models of one simultaneous projective nodal
smoothing, and the compatible arithmetic action on those models.
Then the component torsors glue at all nodes and lift through the models,
retaining transitions, transports, and the entire tower. Disconnected
torsors are allowed; there is no extra dual-graph cycle relation.

These are input hypotheses of the conditional assertion, not consequences
of a finite matrix certificate. Their construction from the original
finite-field parameter still depends on
[the unresolved arithmetic lift](../arithmetic_tower_lift/report.md).

## Decisive argument

The nodal curve is proper lci. The global-to-local deformation map and
algebraization permit prescribing the completed local equations
\(a_i b_i=s\) with all specified tangent units. The balanced chart is
\[
 [\,u_i v_i=s_b\;/\mu_b\,],\quad
 a_i=u_i^b,\quad b_i=v_i^b,\quad s_b^b=s,
 \quad\zeta(u_i,v_i)=(\zeta u_i,\zeta^{-1}v_i).
\]
These characteristic-zero traits make the chosen stabilizer orders
invertible. Equality is needed in the completed local models, not as a
claim that the original algebraic local rings equal those completions.

The common gerbe generator acts on the first branch by \(u_{i,r}\)
and on the second by \(u_{i,r}^{-e}\): the negative sign is branch
orientation, while \(e\) is the cover's ramification. Left multiplication
by \(P_{i,r}\) on a **right** torsor is right-equivariant. The first
display makes it inertia-equivariant, and the transported square makes
it arithmetic-equivariant, including at permuted nodes.

Identifying these actual fibers glues constant etale covers across the
local nodal chart, equivariantly for \(\mu_b\). Distinct nodes are disjoint.
Their independent identifications specify the graph transports; cycles
do not impose an additional relation on these choices. Using reductions
of fixed \(P_i\)'s retains compatibility throughout the tower.

Proper henselian invariance lifts the glued special covers. Provided the
stated base/model action is supplied, full faithfulness lifts their right
actions, semilinear maps, transitions, inverses, and all equations after
passage to common divisible indices. Restricting to the common smooth
geometric generic curve and taking the inverse limit gives a continuous
\(J\)-valued parameter. This conditional argument does not require each
finite torsor to be connected.

## External inputs and attribution

`A_CURVE_DEFORM` is the Stacks Project `examples-defos.tex` lci-curve
deformation and smoothing argument, including the prescribed local
deformations and algebraization, as read on 2026-11-05.
`A_OLSSON_BALANCED` is Olsson, *(Log) twisted curves*, final Compositio
Math.143 (2007), Theorems 1.9-1.10, Remark 1.11, Proposition 2.2(ii),
Definition 2.3, `doi:10.1112/S0010437X06002442`. It supplies balanced
geometry and base-change compatibility, **not** arithmetic equivariance.
`A_RYDH_PROPER` is the dated Rydh Theorem 4.5 for proper finite-diagonal
stacks over a henselian local ring.

The independent source receipts are
`judgement-A_CURVE_DEFORM-16d280e3d1ff`,
`citation-A_OLSSON_BALANCED-120d4e093390`, and
`judgement-A_RYDH_PROPER-f4ec4daf5e32`.
The inherited mathematical support is
`judgement-L_ABG_GLUE-ac30fd84ea62`; `...-ea30a54eb72b` is the author
opinion. The reference manuscript `prop:nodal-parameter` already supplies
the one-node regular arithmetic mechanism, while the several-point
`con:parameter` supplies geometric multi-node gluing without Frobenius.
The old draft proposes their parameter-level combination; novelty is not
established by these comparisons.

## Scope and remaining dependency

The [replay](../computation/replay.json) verifies the requisite signs and
transport equations for selected fixtures and finite congruence stages,
not general torsor descent, smoothing, or the infinite tower. There is
no Lean proof. No separate defect is identified in the conditional
gluing mechanism. **F1 remains a prerequisite for its unconditional
arithmetic application**, including the comparison of the chosen base
action and frames. The old support is retained at this conditional scope;
it cannot be promoted to support for `C_ABG`. Native review is pending.
