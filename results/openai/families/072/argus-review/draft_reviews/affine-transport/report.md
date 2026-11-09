# Weighted affine transport: substantive review

**Assessment:** the stated transport chain has a coherent prose proof,
conditional on the explicitly inherited classical foundations. The replay
checks its algebra, not the analytic premises. No counterexample or false
manuscript assertion is established. Native independent review is pending.

## Claim, version, and attribution

The source is the snapshot-matching old
`9000072/research/affine_transport/report.md`, Sections 1-4 and the moment
calculation in Section 5. The old ledger versions are `C_AT_LAW` v1,
`C_AT_ESCAPE` v1, `C_AT_PAIR` v1, `C_AT_COMPARE` v1, and
`C_AT_TRANSPORT` v1-4. The last four versions have the same natural statement;
v2-v4 successively disclose Koebe, measure-theoretic, and planar foundations.
They are not four independently proved results.

Here B and I denote the two OpenAI manuscripts dated September 24, 2026,
whose complete paths and revision provenance are in
[`DRAFT_REVIEW_INDEX.json`](../../DRAFT_REVIEW_INDEX.json). All nineteen TeX
files listed in the supplied manuscript manifest match that manifest.
The source symlinks are nevertheless live references, not snapshot members.
B Sections 2-5 and I Sections 2-5 supply the underlying constructions.
The old draft's general positive-power formulation is a proposed
generalization; the p=1,2 cases, including I's strict pairing, are
reconstructions, not newly discovered manuscript flaws.

Let K be the holomorphic injective maps on H normalized by F(i)=0 and
F'(i)=1, with locally uniform topology; Q=1/F' and
T_z F(w)=(F(x+yw)-F(z))/(y F'(z)). The exact law is

\[
 E[|Q_F(x+iy)|^p\Phi(T_{x+iy}F)]
       =y^{-\beta}E[\Phi(F)]
\]

for every x real, y>0, and nonnegative Borel Phi. For p>0, beta>=0 put
s=p+2 and k=(beta+p+1)/(p+2)>1/2. With
G=F-iy F'/k and J=det(DG)/|F'|^2, the conclusion is E[J(i)]<=0,
with equality forcing J identically zero for almost every F.
The law-construction subclaim has the **additional strict spectral
hypothesis** beta>max(0,p-1).

## Decisive arguments checked

| Obligation | Evidence and assessment |
|---|---|
| Law, `C_AT_LAW` | Old Section 1; B `02-weighted-law.tex`, `lem:weighted-law`; I `02-weighted-law.tex`, `prop:law`. The resolvent is norm-convergent above the spectral radius; positivity yields M_tau >= tau/(tau-rho). Normalized resolvent evaluations have mass one and converge weakly to a left eigenmeasure. Right composition shifts the dyadic grid one cell, leaving only two endpoints. Its error is O(2^(n(p-1-beta))), so the stated strict threshold is necessary for this argument. Horizontal averaging and a full logarithmic scale period then give all positive scales. Equality of finite weighted measures, not a continuity claim about arbitrary Phi, extends the law to Borel tests. |
| Escape, `C_AT_ESCAPE` | Old Section 2; I `03-escape.tex`, `lem:area-tail`, `lem:infinity`, `prop:compact-levels`; corresponding B Section 3. The inverse coordinate is the affine involution (-x/y,1/y), whose absolute determinant is y^-3. It preserves S0. The transformed inverse-area weight is exactly y^(beta+p-1). Injectivity bounds the original image-area integral by 2 pi c^(-p)/p, finite because p>0. Tonelli and submean give a tail of one integrable function, not a uniform-in-F tail assumption. |
| Real-boundary escape | The horizontal preimage-length bound comes from twice integrating H'' and conformal change of variables, bounded by Y_psi times the L1 norm of Delta psi. Delta psi need not be nonnegative. At height h each marked cell has length h inside a fixed compact target preimage, so there are O(1/h) cells. Radius O(h^k) target disks have total area O(h^(2k-1)); the dyadic sum converges because k>1/2. This supplies almost-every-omitted-target boundary escape. Interior targets are handled by a compact inverse disk. Neither finite image area nor global properness is assumed. |
| Generic targets and count, `C_AT_PAIR` | Old Section 3; I `04-strict-pairing.tex`, `lem:good`, `lem:count`, `prop:pair`. The singular-value cover has O(h^-2) pieces of image area O(h^3). For two distinct inverse branches, the target differentials Re(v/(F(z_j)-xi)) differ by injectivity; tied critical values thus lie on local curves. Compact superlevels make the regular fibers finite above every positive height. Strict superharmonicity excludes holes in positive superlevels. The gradient index gives components = finite maxima - saddles + poles; the pole contributes +1, and at most one pole lies in a component. This gives the required cumulative count. |
| Measurability and equivariance | Compact source boxes make the relevant closed parameter projections closed. Rational tests detect escape from boxes. Countably many local nonsingular root branches, with earlier duplicates deactivated, give Borel finite ranks. Equal-rank pairing is fiberwise injective; exclusion of ties makes it strict. Rebasings multiply all critical heights on a fiber by one positive factor, preserving ranks. B's original pairing allows ties and is non-strict; the strict version is supplied by I's argument, not assumed for free. |
| Root exception and comparison, `C_AT_COMPARE` | Old Section 4; B `05-transport.tex`, `lem:root-exception`, `prop:transfer-bound`; I `05-strict-transport.tex`, `lem:base-good`, `prop:strict-transport`. The root target is fixed at -i/k, so area-genericity alone is insufficient. Applying the local area formula to bad targets in a positive-area box, and then the exact law, gives E[J_+(i) 1_bad]=0 because the box has dx dy/y mass 2 log 2. This is precisely a weighted null assertion, not unweighted almost-sure goodness. |

For orientation, direct differentiation and the existing exact checker give

\[
 k^2J=k(k-1)+(2k-1)a+|q|^2,\quad
 q=-iyF''/F'=a+ib,\quad
 \det\operatorname{Hess}\log V=-k^4J/y^4.
\]

Thus positive J labels saddles, not maxima. On each sign locus the actual
local change of variables has absolute Jacobian |F'|^2 |J|. Its target
weight is y^(beta-1)|Q|^(p+2)=(V/k)^(p+2). The pairing compares these
target sums; it does **not** assert that the pairing map preserves area.

On the displacement cutoff D_N, multiply the saddle weight by its strict
partner ratio c>1. Fiberwise injectivity gives the finite-box inequality.
The law produces the actual spatial density dx dy/y. At fixed N the box
ratio with R=Y^2 is

\[
 (1+N/Y)(1+2\log N/\log Y)\longrightarrow1.
\]

Only afterwards is N allowed to increase. This proves integrability of
the previously potentially unbounded gain: its increasing cutoff
expectations are bounded by d=E[J_-(i)]<infinity. Root exceptional mass
has already been removed, so b=E[J_+(i)]<=A<=d. If b=d, the nonnegative
excess J_+(c-1) has integral zero; its pointwise strict positivity where
J_+>0 gives b=d=0. No uniform positive lower bound on c-1 is needed.
The exact law transfers vanishing from i to each fixed point; a countable
dense set and continuity then give J identically zero almost surely.
These passages establish the analytic hypotheses of the abstract Lean
lemmas rather than following from those lemmas.

## Moments, supported scope, and invalid interpretations

Uniform interior upper/lower bounds and derivatives of Q justify
differentiation under expectation, including nonintegral p. The old
Section 5 identities are

\[
 E[a]=-\beta/p,\quad E[b]=0,\quad
 E[|q|^2]=\beta(\beta+1)/p^2,\qquad
 k^2E[J]=\frac{(\beta+p+1)(4\beta-p^2)}
                    {p^2(p+2)^2}.
\]

For B, p=2 and the contrary beta>1 meet the law threshold.
For I, p=1 and beta>=1/4 also meet it. The resulting equality
obstruction is assessed separately in
[`zero-jacobian-rigidity`](../zero-jacobian-rigidity/report.md).

The retired `R_AT_MODULAR_ONLY` attack is invalid as a refutation:
nonunimodularity does not contradict the displayed density or box limit.
Likewise, substituting a reciprocal-map determinant y^-4, taking N to
infinity before the spatial limits, or inferring unweighted root goodness
would be invalid arguments, but they are **not** the arguments in this
draft. At p=2,beta=1 the dyadic cancellation bound is merely O(1);
the law-construction proof does not establish that boundary case. The
old endpoint theorem instead starts with an exact law as a hypothesis and
constructs its example directly. This distinction prevents a hidden
circular endpoint argument.

## Evidence limits and remaining obligations

The read-only replay in
[`symbolic_replay.json`](../formal-core/replay/symbolic_replay.json)
passed all 38 old exact checks (Python 3.13.5, SymPy 1.14.0).
The fresh bounded Jacobian replay agrees with the old typed determinant,
using server 0.14.0 and protocol 2025-11-25, adapter exit 0, no timeout
or structured error. These facts support the displayed identities only.
The Lean subset and its precise hypotheses are reviewed in
[`formal-core`](../formal-core/report.md).

No unfilled mathematical step was identified in the stated prose chain
after retaining the classical inputs. This is an Engineer judgement, not
a kernel proof or native acceptance. A claimed **fully formal** transport
theorem would still need formal constructions of the exact law, compact
superlevels, the finite index count, Borel strict pairing, weighted
root-exception transfer, and the geometric area comparison; none is a
declaration in Main.lean. Calling the existing local certificate such a
theorem is unsupported, not evidence that the analytic conclusion is false.

Original Duren/Folland/Munkres/Hopf/Lee passages remain unverified
foundational attributions. They are explicitly inherited assumptions in
the current review ledger, rather than silently discharged dependencies.
Broader disk/area/Sobolev consequences of the original papers are outside
the old draft's claimed transport verification and are not certified here.
Proposed novelty of the general-p extension remains unestablished;
the p=1,2 machinery must be credited to the staged manuscripts.
