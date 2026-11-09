# Exact real algebraic Hessian-bridge theorem

## Result and scope

The two identities in `lem:real-vector-projections` and the upper bound
(14) in `prop:hessian-projection-cost` are valid with the staged zero-plane
manuscript's conventions. The constants are exactly `7/12`, `1/2`, and
`5/4`. In fact its bracket has the stronger bound

$$
 \frac7{12}(4+y)e-\frac54B
 \ \ge\ \left(\frac13+\frac{19}{12}y\right)e.
 \tag{HB}
$$

The coefficient `1/3` is sharp for this algebraic domain. This is an
independent exact verification and a sharp local refinement, **not** a
claim of novelty in the literature, a refutation, or a verification of any
global classification or topological gap theorem. No false assertion in the
bounded target has been identified. No `F_` refutation claim is warranted
by this result.

The source is
`research/openai_manuscript/Zero-Plane-Rigidity-for-Einstein-Four-Manifolds-October-4-2026/build/`,
Sections `02-preliminaries.tex` and `05-hessian.tex`. The global dependencies
of all three manuscripts remain open in `research/PROOF_GRAPH.json`.
The analytic Weyl gap and refined Kato antecedents are scoped separately in
`source_assumptions.md`; neither is needed for the proof below.

## Objects, hypotheses, and precise assertion

Let `V` be oriented real Euclidean four-space and
`F=Sym_0(R^3)` with its Hilbert--Schmidt metric. Choose commuting skew
orthogonal triples `I_s,J_s` with positive cyclic quaternionic product,
`I_1 I_2=I_3` and `J_1 J_2=J_3`. The two-form bases
`I_s/sqrt(2)` and `J_s/sqrt(2)` have the source's plus and minus chiralities.
Let `Sigma_s` be the speed-two action on `F`.

Define `G` directly, without a representation-theoretic assumption:

$$
 G=\{Z\in V\otimes F:\ \sum_s I_s Z_{sr}=0\text{ for each }r\}.
$$

Let `T,U` be **arbitrary real symmetric trace-free** three-by-three matrices,
`x=-lambda_min(T)`, `y=-lambda_min(U)`, and `x+y<=2`. Thus `x,y>=0`.
Set

$$
 e=|Z|^2/6,\qquad
 B=\langle B_F(T)Z,Z\rangle/6,\qquad
 B_F(T)S=(TS+ST)/2-\operatorname{tr}(TS)\operatorname{Id}/3.
$$

On `H=V tensor G`, define the type projectors and curvature operators
below. Write `P_Y=P_+P_-` and
`P=4-(5/2)Qtilde-U_D`. For **every real** `a in V` and **every** `Z in G`,

$$
 |P_+(a\otimes Z)|^2=\frac7{12}|a|^2|Z|^2,
$$
$$
 \langle\widetilde QP_+(a\otimes Z),P_+(a\otimes Z)\rangle
 =\frac12|a|^2\langle Q_{5/2}(T)Z,Z\rangle,
$$
$$
 \langle P P_Y(a\otimes Z),P_Y(a\otimes Z)\rangle
 \le 6|a|^2\left[\frac7{12}(4+y)e-\frac54B\right].
 \tag{C}
$$

These are universal real algebraic assertions. They do not assert that
arbitrary chosen curvature blocks and Bianchi gradients occur at a point of
a global Einstein manifold. Complex `a` is not covered.

## Rational coordinate reconstruction

Identify `V` with the quaternions in the oriented basis `(1,i,j,k)`.
Use left multiplication by `(i,j,k)` for `I` and **negative** right
multiplication for `J`. The latter sign makes both triples have the
source's positive cyclic product. The executable checks all squares,
cyclic products, commuting pairs, skew adjoints, and Hodge chiralities.

The rational basis of `F` is

$$
 \operatorname{diag}(1,-1,0),\quad
 \operatorname{diag}(1,1,-2),\quad
 E_{12}+E_{21},\quad E_{13}+E_{31},\quad E_{23}+E_{32}.
$$

Its metric is `W_F=diag(2,6,2,2,2)`, not the identity. All adjoints and
projectors use that metric. Tensor order is outer derivative, inner
derivative, matrix coordinate. The ambient dimensions are `20` and `80`;
the constrained dimensions are `12` and `48`.

In the speed-two axis representation
`A_s e_t=2 epsilon_stu e_u`, the matrix action is
`Sigma_s(S)=A_s S-S A_s`. Construct the Bianchi map as a `12 by 20`
matrix directly from its displayed equations. Its exact rank is `8`.
Independently form the weighted kernel projector

$$
 K(K^{\mathsf T}W_{20}K)^{-1}K^{\mathsf T}W_{20},
$$

where columns of `K` are a rational nullspace basis. It equals

$$
 P_G=(6-C)/10,\qquad C=\sum_s I_s\otimes\Sigma_s.
$$

The executable checks `(C+4)(C-6)=0`, eigenvalues `-4` on `G` and `6`
on its complement, and weighted orthogonality. It also reconstructs the
source's gradient parametrization at the fixed normalized triple
`s=(1,1,-2)`: its twelve parameter columns span **all** of `G`, and their
metric is `diag(10 Id_4,30 Id_4,6 Id_4)`. This checks the off-diagonal
multiplicity and the coefficients `5/3,5,1` in `e`.

Let `L_s=I_s(inner)+Sigma_s` on `G`. On `H`, put
`K_s=I_s(outer)+L_s` and `M_s=J_s(outer)+J_s(inner)`.
The exact Casimirs give

$$
 P_+=P_H\frac{-\sum K_s^2-24}{24}P_H,\qquad
 P_-=P_H\frac{-\sum M_s^2}{8}P_H.
$$

They are commuting weighted orthogonal projectors. Their four joint
dimensions are `(3,1):21`, `(3,0):7`, `(2,1):15`, `(2,0):5`.
The restricted trace satisfies `Tr Tr*=12 Id_F/5`, and its type
projector is `(5/12)Tr* Tr`. These checks identify the manuscript's
projectors without assuming the desired real-vector formulas.

## Curvature actions and universal coefficient comparison

For general symmetric trace-free `T`, define

$$
 Q_{5/2}(T)=P_G\frac{\sum T_{rs}L_rL_s}{40}P_G,\qquad
 \widetilde Q=P_H\frac{\sum T_{rs}K_rK_s}{60}P_H.
$$

The derivative-slot actions, before compression, are
`T_D=(1/2)sum T_rs I_r(outer) I_s(inner)` and the corresponding
`U_D=(1/2)sum U_rs J_r(outer) J_s(inner)`.
The executable checks coefficientwise on **all five** trace-free symmetric
basis matrices that

$$
 P_G B_F(T)P_G=Q_{5/2}(T),\qquad
 P_H(T_D+2B_F(T))P_H=3\widetilde Q.
$$

Thus `4-(5/6)(T_D+2B_F(T))-U_D` is exactly the source's `P`, including
orthogonal compression. Its action on the trace type is `4-B_F(T)`.
Every combined action preserves the four joint types.

For a weighted self-adjoint `80 by 80` operator `R`, the quadratic
form of `a tensor Z` is determined by the four diagonal `20 by 20`
blocks and the six sums `R_ij+R_ji`. The executable proves:

* for `R=P_+`, the diagonal blocks are `(7/12)P_G` and all six sums vanish;
* for `R=P_+ Qtilde(T) P_+`, the diagonal blocks are
  `(1/2)Q_(5/2)(T)` and all six sums vanish, for all five coefficients of `T`.

These are exact polynomial coefficient comparisons, not evaluations at
sample values of `a,Z,T`. They prove the two universal real-vector
identities. The potentially nonzero antisymmetric outer blocks explain
why this reasoning does not extend to arbitrary complex `a`.

## Positive-semidefinite certificate on the whole closed cone

On `P_+`, the generators `K_s` are skew-adjoint and
`sum K_s* K_s=48 Id`. Write `delta=2-x-y>=0` and
`A=4+y-(5/2)Qtilde`. Its exact Gram decomposition is

$$
 A=(2\delta+3y)\operatorname{Id}
   +\frac1{24}\sum_{r,s}(T+x\operatorname{Id})_{rs}K_r^*K_s.
 \tag{A}
$$

Since `T+x Id` is positive semidefinite, the last term is positive
semidefinite: apply its coefficient matrix to the triple of vectors
`(K_1 h,K_2 h,K_3 h)`. Hence `A>=0` on the **entire** high-plus space,
including the discarded minus-spin-zero summand.

Diagonalize `U` by a minus rotation. On `Y`, the three operators

$$
 E_s=P_Y(\operatorname{Id}+M_s^2/4)P_Y
$$

are mutually orthogonal weighted orthogonal projectors of rank `7`,
with sum `P_Y`, and `U_D=sum u_s E_s`. Thus
`U_D+y Id=sum (u_s+y)E_s>=0`. The executable checks this spectral
resolution on the two diagonal trace-free coefficients, and checks
covariance on all five coefficients under all three minus generators.
This proves the assertion for arbitrary, not just diagonal, `U`.
Diagonalization uses no eigenvalue gaps and is valid at repeated eigenvalues.

For `h=P_+(a tensor Z)`, set `w=P_-h` and `r=(Id-P_-)h`.
Since `A` commutes with `P_-`, the **exact** cost slack is

$$
 \langle Ah,h\rangle-\langle Pw,w\rangle
 =\langle Ar,r\rangle+
   \langle(U_D+y\operatorname{Id})w,w\rangle\ge0.
 \tag{S}
$$

All affine coefficients of (S), in `1,y,T,U`, are checked as matrix
identities. Correlations of plus and minus factors have not been
discarded. Substituting the two real-vector identities into
`<Ah,h>` gives (C), including the exact coefficient `5/4`.
Equality in (S) means exactly `Ar=0` and `(U_D+y Id)w=0`.

For completeness the same objects also give

$$
 P=2\delta\operatorname{Id}
   +\frac1{24}\sum_{r,s}(T+x\operatorname{Id})_{rs}K_r^*K_s
   +\sum_s(2y-u_s)E_s\ge0\quad\hbox{on }Y.
$$

Here `u_s<=2y` follows from trace-freeness and `u_s>=-y`.
This also verifies the lower operator inequality used in the source.

## Sharper bracket and equality faces

There is a useful exact improvement over the general Casimir bound.
On `G`, `D_s=-L_s^2` has eigenvalues `1,9,25`, each with multiplicity
`4`. The executable constructs their rational polynomial projectors

$$
 E_1=(D-9)(D-25)/192,\quad
 E_9=-(D-1)(D-25)/128,\quad
 E_{25}=(D-1)(D-9)/384.
$$

All identities here are on `G`; the executable uses `P_G` in place of
the identity off that subspace. They are weighted orthogonal projectors,
sum to `P_G`, and `D-Id=8E_9+24E_25>=0`. For diagonal `T`,

$$
 \frac45x\operatorname{Id}-Q_{5/2}(T)
 =\frac1{40}\sum_s(t_s+x)(D_s-\operatorname{Id})\ge0.
$$

The two diagonal coefficient identities and full plus covariance are
checked exactly. An arbitrary `T` is reduced to this case by an orthogonal
plus rotation; an orientation-reversing diagonalizer can be changed to a
proper one without changing the diagonal matrix. Therefore this is a
universal operator bound, not a generic-eigenvalue argument.

It follows that the bracket is exactly

$$
 \left(\frac13+\frac{19}{12}y+\delta\right)e
 +\frac54\left(\frac45xe-B\right).
$$

Both terms are nonnegative, proving (HB). In particular the bracket is
strictly positive for every nonzero algebraic `Z`, even on `x+y=2`.

An exact sharpness/equality example is
`T=diag(-2,-2,4)`, `U=0`, with derivative matrices, in order,

$$
 Z_0=\operatorname{diag}(1,1,-2),\qquad
 Z_1=-(E_{23}+E_{32}),\qquad
 Z_2=E_{13}+E_{31},\qquad Z_3=0.
$$

It satisfies all Bianchi equations, `e=5/3`, `B=8/3`, and bracket
`5/9=e/3`. For `a=(1,0,0,0)`, the slack (S) is exactly zero.
This also proves sharpness of the algebraic bound `Q_(5/2)<=4x/5`.

The certificate checks nontrivial operator equality spaces at:

* `x=2,y=0`, repeated eigenvalues in `T`, where `A=K_3* K_3/4`
  on `P_+`; its kernel has dimension `4`, and its `Y` kernel dimension `3`;
* `x=0,y=2`, the vanishing plus block and a repeated-eigenvalue minus
  block, where the `Y` kernel contains the rank-`7` maximum-eigenvalue space;
* `x=y=1`, both blocks `diag(-1,-1,2)`, where the simultaneous equality
  space has dimension `1`.

At `T=U=0`, all curvature actions vanish and the same projector identities
still apply. Every proof above includes `Z=0`. There is no division by a
block norm, a spectral gap, `x`, `y`, or `delta`.

## The actual weight and equation (14)

For the source's `v=|T|/sqrt(6)`, `b=|U|/sqrt(6)`, trace-freeness
gives `v<=x`, `b<=y`, hence `v+b<=2`. For example, diagonal eigenvalues
of a nonzero block can be written
`(-x,-x+3xr,2x-3xr)`, `0<=r<=1`, giving
`x^2-v^2=3x^2 r(1-r)>=0`; the zero block is immediate.
Consequently `M=1-(3/8)(v-b)>=1/4` and `m=M^2>0`.
At every point where the Lipschitz norms are differentiable,
`dm=-(3/4)M(p-q)`.

Put `a=dm` in (C) and divide by `24m`. The scalar factor is exactly
`(6/24)(3/4)^2=9/64`. This is equation (14) with the source's
unsymmetrized `L_m=dm tensor Z` and its `Y` projection. At norm-zero
sets the same algebraic inequality remains valid; the usual almost-everywhere
geometric specialization does not enlarge the asserted scope.

For the displayed integer Bianchi example, the formal norm-gradient
contraction is `p=(-1,0,0,0)`. With `q=0`, `v=2,b=0`,
`M=1/4`, `m=1/16`, and `dm=(3/16,0,0,0)`, both sides of (14) equal
**`5/64` exactly**. This is an algebraic equality case, not an assertion
that these data form a sec-preserving curvature first jet or a global metric.

## Replay and what is not checked

Run, from the campaign root:

```text
$WORKSPACE/argus-live-update/.venv/bin/python research/hessian_bridge/verify.py
```

Only SymPy and Python's standard library are required. The script constructs
all data afresh, checks exact rational residuals and projector certificates,
and compares its result with `exact_certificate.json`. The option
`--write-certificate` regenerates that certificate from the same checks.
No staged verification code is imported, executed, or copied.

`jacobian_payload.json`, `jacobian_result.json`, and
`jacobian_status.json` preserve the bounded adapter operation, protocol,
server version, exact request, typed answer, and successful adapter status.
It solved only the two projector coefficients `3/5,-1/10`; the independent
matrix proof does not rely on a remote verdict.

This is a universal finite-dimensional proof with rerunnable exact
identities and explicit positive-semidefinite decompositions. It is not a
Lean kernel certificate. The independent Reviewer must still assess
statement fidelity, the elementary spectral/Gram reasoning, and replay.
The Hessian commutator restriction for actual sections, integration by
parts, weak norm equation, weighted coupling, volume arguments,
classification, smoothing, compactness, and novelty are **not** certified
here.
