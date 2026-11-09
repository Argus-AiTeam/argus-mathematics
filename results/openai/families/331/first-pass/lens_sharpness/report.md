# Exact lower bound and unresolved sharp lens constant

**Status.** The optimal universal squared constant has not been determined.
The justified bracket remains

\[
                         2\le K_*\le4.
\]

The upper bound is the staged manuscript's theorem, with its hypotheses
checked below. The lower bound is now attained by an exact three-coordinate
example in each actual ambient space, rather than only approached by the
proposed two-coordinate family. This is an exact lower-bound certificate,
not a manuscript refutation, a proof of the conjectural universal upper
bound two, or a claim of publishable novelty. Independent review is pending.
Neither retired shortcut below is a staged manuscript assertion.

## 1. Models, finite restriction, and the actual dual norm

Let the underlying tree system be either the forest of separate countably
branching trees of finite unbounded heights or the infinite countably
branching rooted tree. Its real primal norm is

\[
 \rho(u)^2=\sup_{\mathcal S}\sum_{S\in\mathcal S}u(S)^2,
\]

where the finite segments are nonempty order intervals and the members of
each family are pairwise vertex-disjoint. Use the full forest dual in the
first case and the norm-closed coordinate span in the infinite-tree dual
in the second case. These two completions are not identified with each other.

For any finite ancestral set \(K\), a segment intersects \(K\) in a segment
or the empty set. Intersections of disjoint segments remain disjoint.
Consequently \(\rho(P_Ku)\le\rho(u)\) for every finite primal test, and by
completion for every primal vector. If a coefficient functional \(a\) is
supported on \(K\), then

\[
 \|a\|_{\rm ambient}
 =\sup_{\rho(u)\le1}|a(P_Ku)|
 =\sup_{\substack{v=P_Kv\\\rho(v)\le1}}|a(v)|.
\]

The reverse inequality uses the inclusion of the supported tests.
Thus finite polar norms below are the inherited **ambient dual norms**.
This argument quantifies over arbitrary ambient segments; it is not inferred
from a bounded-depth simulation. Finite coefficient functionals belong to
the specified closed coordinate predual as well as to the forest dual.

For a disjoint segment family, Cauchy--Schwarz gives

\[
 \left\|\sum_i c_i d_{S_i}\right\|^2\le\sum_i c_i^2.
\]

Accordingly a convex combination of such represented functionals, all
with coefficient energy at most \(N\), has squared norm at most \(N\).
A primal test \(v\ne0\) gives the matching lower bound
\(a(v)^2/\rho(v)^2\). These two checks, not a coordinate Euclidean norm
substitution, are used by `verify.py`.

## 2. A lens with ratio exactly two

Choose a component root \(o\) and two distinct children \(c_1,c_2\).
In the forest one may use the component of height one. Let

\[
 H=\{o\},\quad
 x=4e_o^*,\quad y=3e_{c_1}^*-3e_{c_2}^*,\quad R=5.
\]

Both \(H\) and \(K=\{o,c_1,c_2\}\) are finite ancestral sets.
The support and endpoint signs are explicit, \(P_Hx=x\), and \(Q_Hy=y\).
There are exactly three full segment partitions of \(K\), so for a test
\((u,v,w)\),

\[
 E(u,v,w)=\rho(u,v,w)^2
 =\max\{u^2+v^2+w^2,\ (u+v)^2+w^2,\ (u+w)^2+v^2\}.
\]

Every smaller disjoint family extends to one of these by adding unused
singletons. The following are exact norm certificates.

| Functional | Squared norm | Equality test | Test energy | Pairing |
|---|---:|---|---:|---:|
| \(x=(4,0,0)\) | 16 | \((1,0,0)\) | 1 | 4 |
| \(y=(0,3,-3)\) | 18 | \((0,3,-3)\) | 18 | 18 |
| \(x+y=(4,3,-3)\) | 25 | \((4,0,-3)\) | 25 | 25 |
| \(x-y=(4,-3,3)\) | 25 | \((4,-3,0)\) | 25 | 25 |

For the endpoint upper bound, write

\[
 x+y=\tfrac34(4d_{[o,c_1]}-3d_{\{c_2\}})
       +\tfrac14(4d_{\{o\}}-3d_{\{c_2\}}).
\]

Each represented vector has disjoint segments and coefficient energy
\(4^2+3^2=25\). Interchanging the children gives the other endpoint.
The center and tail use respectively the singleton root and the two
disjoint child singletons. The equality tests in the table prove that
none of these upper bounds is slack.

Therefore

\[
  \frac{\|Q_Hy\|^2}{R^2-\|x\|^2}
       =\frac{18}{25-16}=2.
\]

This rules out every \(K<2\) in each manuscript model, including the
quantification allowing arbitrary displacement heads, since that
quantification includes this pure-tail displacement.

More generally, for \(r\ge q>0\), the same construction
\(x=re_o^*\), \(y=q(e_{c_1}^*-e_{c_2}^*)\) has squared endpoint norms
\(r^2+q^2\) and squared tail norm \(2q^2\).
Use weights \(q/r\) and \(1-q/r\), coefficient lists \((r,-q)\), and
equality tests \((r,0,-q)\), \((r,-q,0)\).
For example \(E(r,0,-q)=r^2+q^2\), because \(rq\ge0\).
Thus there is an attained family of ratio-two examples, not just a limit.

## 3. The proposed nonzero-head family is also correct

On a root-child chain the squared primal norm is
\(\max(u^2+v^2,(u+v)^2)\). Its squared polar norm at \((a,b)\) is

\[
 \|(a,b)\|^2=
 \begin{cases}
 \max(a^2,b^2),&ab\ge0,\\
 a^2+b^2,&ab\le0.
 \end{cases}
\]

For coefficients of the same sign, represent the functional by convex
combinations of the root singleton, child singleton, and the segment
indicator, after dividing by \(\max(|a|,|b|)\).
The coordinate tests give equality. For coefficients of opposite signs,
the disjoint-singleton coefficient bound is attained by the proportional
test \((a,b)\), whose energy is \(a^2+b^2\). This proves the formula,
including zeros. The ancestral restriction argument in Section 1
identifies it with the ambient norm.

For \(0<q\le1\), set \(x=(1,0)\), \(y=(q^2/4,q)\), and
\(R=1+q^2/4\). The positive endpoint has same-sign coordinates and
\(R\ge q\), while the negative endpoint has opposite-sign coordinates:

\[
 \|x+y\|^2=R^2,\qquad
 \|x-y\|^2=(1-q^2/4)^2+q^2=R^2.
\]

Also \(\|x\|=1\), \(\|Q_Hy\|=q\), and

\[
 \frac{q^2}{R^2-1}=\frac{16}{8+q^2}\longrightarrow2.
\]

Thus the supplied calculation did not require a repair. Section 2 improves
it to exact attainment and removes the limiting argument.

## 4. What the existing upper-bound argument actually proves

Primary local source: staged `Midpoint-lenses-in-segment-spaces-September-27-2026`,
`build/sections/introduction.tex`, Theorem `thm:main-tail`, and
`build/sections/joint-budget.tex`, its proof. The norm, atomic hull, and
cone hypotheses were read in `forest-definition.tex`,
`forest-foundations.tex`, `infinite-foundations.tex`, and `atomic.tex`.

For a supported center of norm \(r>0\), finite endpoint laws have
coefficients \(a_i\), head sums \(b_i=rp(S_i)\), error
\(V=\sum_i(a_i-b_i)^2\), and slack \(L=r^2-\sum_i b_i^2\).
Pooling the laws equally, including their endpoint sign, gives

\[
 \eta+\theta:=\mathbb EV+\mathbb EL\le R^2-r^2.
\]

An original segment meets at most one exterior gate. Gate coordinates of
the coefficient error therefore have squared mean at most \(\eta\).
The opposite-sign crossing comparison cuts the longer of two nested
head segments. Distinct crossings use distinct segments, so the cuts are
simultaneous and preserve disjointness. Averaging this comparison yields

\[
 \|\mathbb E|b(g)|\|_2^2
 \le\|\mathbb Eb(g)\|_2^2+2\theta\le\eta+2\theta.
\]

The actual exterior dual norm is the square sum of the cone restriction
norms. Each corrected crossing tail is a segment indicator of norm one
times its coefficient. Reconstruction, with the endpoint sign retained,
and the coefficient error bound give

\[
 \|Q_Hy\|\le\sqrt\eta+\sqrt{\eta+2\theta}
           \le2\sqrt{\eta+\theta}.
\]

These are squared constant **four**, not two. The last scalar estimate
is valid: the two squared summands add to \(2(\eta+\theta)\), and
their product is at most \(\eta+\theta\).
`Main.lean` also certifies this scalar core.

The argument neither sets \(P_Hy=0\) nor assumes a full infinite-tree
dual identification. Finite laws are taken after a finite ancestral
projection. Empty heads, \(r=0\), and \(R=0\) satisfy the bound directly.
For completed displacements, increasing ancestral projections converge
in the specified coordinate completions, and their endpoint norms remain
at most \(R\). Untouched forest components are separate cones.
No height or branching bound enters. No false assertion in this
load-bearing argument has been established here.

A bounded companion-source lookup found the same displayed estimate
\(\|Q_Hy\|\le2\sqrt{R^2-\|x\|^2}\) in the diamond manuscript.
That is again squared constant four; the lookup's verbal description of
it as squared constant two was an arithmetic misreading, not a manuscript
error. No companion source established optimality.

The literature search did not establish a sharper theorem or novelty.
Girardi, arXiv:math/0004166v1, Sections 2--3 and Theorem 3, was opened:
its tree is binary and its quantitative predual statement is an AUC
bound of power three. It is not a sharp lens theorem for these two
countably branching models, and no argument here depends on it.
An automated search summary incorrectly described the staged constant
as optimal; the primary manuscript explicitly disclaims optimality.
That secondary assertion is not accepted as a cited mathematical result.

## 5. Two retired proof routes, with exact obstructions

**Scalar-only optimization.** Setting \(\eta=1,\theta=0\) gives
\((\sqrt\eta+\sqrt{\eta+2\theta})^2=4\), whereas
\(2(\eta+\theta)=2\). No optimization of just the final scalar
inequality can turn this argument into \(K=2\). These parameters need
not be realizable by an extremal actual lens: this obstruction only
refutes the scalar shortcut, not the conjecture. Route `R_SCALAR_ONLY`
is retired for this reason.

**Full lattice submodularity of cumulative energy.** Another possible
shortcut would assert
\(E(F\vee G)+E(F\wedge G)\le E(F)+E(G)\), where the energy is the
squared segment norm of edge increments of a cumulative potential.
This assertion is false already on the seven-vertex binary tree with
parent array `[-1,0,0,1,1,2,2]`. Take

```
F = [-2,  4, -1, 3,  1, -4,  4]
G = [-2, -3, -2, 2, -2, -3, -1].
```

Enumerating all 27 full path partitions gives

\[
 E(F\vee G)+E(F\wedge G)=134>132=E(F)+E(G).
\]

`verify.py` records the individual energies, increments, and maximizing
partitions, with exact integers. Route `R_LATTICE_ENERGY` is retired.
This is our proposed shortcut, not a manuscript lemma. It does not
refute \(K=2\), and it does not refute the weaker positive/negative
cumulative-clip energy splitting tested separately.

## 6. The precise remaining upper-bound obligation

A materially different route would prove the following coupled primal
extension estimate. For every finite ancestral \(K\supset H\), every
head test \(p=P_Hp\), and every tail test \(v=Q_Hv\), show

\[
 \inf_{\substack{w=Q_Hw\\\operatorname{supp}w\subset K}}
 \frac{\rho(p+v+w)+\rho(p-v+w)}2
       \le\sqrt{\rho(p)^2+2\rho(v)^2}.                 \tag{E2}
\]

This statement has **not** been proved. Its sufficiency is elementary
and keeps arbitrary displacement heads:
choose unit head and tail normers for \(x\) and \(Q_Hy\), with pairings
\(r=\|x\|\) and \(t=\|Q_Hy\|\). Apply (E2) to these tests multiplied
by \(a,b\ge0\). Testing the endpoints on the two proposed extensions
and averaging cancels both the head evaluation of \(y\) and the common
tail correction:

\[
 ar+bt\le R\inf_w
       \frac{\rho(ap+bv+w)+\rho(ap-bv+w)}2
       \le R\sqrt{a^2+2b^2}.
\]

Taking \(a=r,b=t/2\) gives \(r^2+t^2/2\le R^2\);
zero pairings are immediate. Finite normers exist after restriction
to \(K\); completed tails follow by norm approximation.
Thus (E2) would close the conjectured sharp theorem together with
Section 2. Repeating either retired scalar or lattice shortcut will not.
The proof graph leaves this universal extension estimate open.
The separate 4,000-attempt finite extension diagnostic completed 3,976
cases and records 24 unresolved `AlmostSolved` statuses in
`extension_diagnostic.json`. Its largest apparent excess over two is
within numerical error; it establishes neither (E2) nor its negation.

## 7. Computation, formal scope, and replay

`diagnose.py` performs floating-point SOCP diagnostics using the full
finite atomic ball, not the coordinate Euclidean norm. It minimizes
the lens radius over the displacement head in a single conic program.
The stored deterministic 4,000-attempt run completed 3,996 cases and
records four `AlmostSolved` cases as unresolved, not as evidence.
Values within numerical error of two are not counterexamples.
The run supplied no certified violation or universal conclusion.
Earlier nested SLSQP attempts were numerically unreliable and were
replaced by the direct conic formulation; they are not evidence.

`verify.py` uses exact rational atomic decompositions, exhaustive finite
segment combinatorics, and exact symbolic identities. Replay with:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/lens_sharpness/verify.py
```

`jacobian_payload.json`, `jacobian_contract.json`, and
`jacobian_result.json` preserve one inspected and executed bounded
Argus-adapter operation: exact factorization of the Cauchy residual
\((r^2+q^2)(s^2+t^2)-(rs-qt)^2=(qs+rt)^2\).
The adapter reported `FACTORIZED`, exact reconstruction, exit zero,
and no timeout. This is one algebraic move, not a proof strategy or
a universal norm certificate.

`Main.lean` and `statement_fidelity.md` encode all-real finite-star
polar inequalities with exact equality witnesses and the scalar
budget obstruction. The real Lean 4.31.0 compiler and axiom audit both exited zero, with
`proof_holes=[]`; `lean_result.json` and the archived claim certificate
record this fresh run. The durable run completed with exit zero.
The ambient restriction proof above remains prose requiring independent
review. A successful compiler run cannot establish (E2), optimality of
the universal constant, statement fidelity, novelty, or publishability.

**Handoff boundary:** review the exact lower bound and the two route
obstructions, but do not accept this as completion of the sharp-constant
mission. The campaign must continue on (E2) or another unresolved route.
