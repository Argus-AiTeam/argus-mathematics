# Scalar identity and weighted coercivity

## Scope and source

This work addresses only `prop:scalar:identity` and
`prop:scalar:coercivity` in
`research/openai_manuscript/The-spacetime-Penrose-inequality-and-enclosing-area-September-27-2026/build/sections/scalar-identity.tex`.
It does not assume the coupled equations, an energy condition, existence of
global solutions, the height enclosure, or a Penrose inequality.

The local variables are those of equations `eq:scalar:implicit`,
`eq:scalar:variables`, and `eq:scalar:differential`. In particular,
`n = k + 1 >= 3`, `d = 1 - v > 0`, `q = k + p v`,
`chi = k d / q`, and `s = p + (k - 1)/2`. The scalar identity is
tested for an arbitrary positive smooth warping function `l(t)`, with
`p = (log l)'` and with `p'` retained. Coercivity uses `0 <= p <= N`.

The manuscript explicitly distinguishes its algebraic identities from global
analytic solvability. This distinction is maintained here. A finite list of
successful substitutions will not be treated as a universal verification.
There was no earlier mathematical certificate in the campaign ledger at the
start of this task. The supplied Wiki index contained no relevant entry for
these scalar propositions.

The manuscript names the Schoen--Yau and Bray--Khuri identities as models,
not as proofs of its redistributed identity. The independent derivation below
uses the Riemannian graph and coordinate curvature calculus instead of the
manuscript's stationary Lorentzian slicing. Any literature used as a proof
dependency must be separately recorded in the claim ledger; a reference
appearing in the manuscript is not thereby an assumed theorem.

## Result and qualification

The two stated local propositions are correct. More explicitly, writing
`E = mathcal T`, their coercivity estimate holds with

```
C_k = 32 + 4 k^2.
```

The exponent two on `1+N` is necessary, already in dimension three at the
fixed nondegenerate weight `v=1/4`. The stationary comparison holds with
constants `1/16` and `3`, independent even of the dimension. These are local
verification and sharpness statements, not a proof of the Penrose inequality.
The universal scalar algebra has passed a real Lean 4.31.0 compiler run and
axiom audit: both exit codes are zero and `proof_holes=[]`.
Independent Reviewer acceptance, novelty, and publishable significance remain
unestablished. No false literal manuscript assertion has been identified in
the two audited propositions, so there is no justified `F_` refutation claim.

## 1. Independent curvature calculation

Write `H=H^f`, `A=I-w tensor w`, `b=w(t)`, and
`div_u X = u^(-1) div_g(u X)`. The calculation can be made without the
stationary Lorentz metric in the manuscript.

Consider the **Riemannian** warped product

```
G_+ = g + l(t)^2 dz^2
```

and the graph `z=f`. Its induced metric is `bar g`. Relative to a unit
vertical vector its unit normal is `nu=sqrt(d) vertical - w`.
In normal coordinates for `g`, the additional ambient connection coefficients
are

```
Gamma^z_iz = p t_i,       Gamma^i_zz = -l^2 p t^i.
```

Substitution in the definition
`Ric_ij = partial_h Gamma^h_ij - partial_j Gamma^h_ih
          + Gamma^h_hm Gamma^m_ij - Gamma^h_jm Gamma^m_ih`
gives

```
R_+ = R_g - 2 l^(-1) Delta_g l,
Ric_+(X,Y) = Ric_g(X,Y) - l^(-1) Hess_g l(X,Y),
Ric_+(vertical,vertical) = -l^(-1) Delta_g l.
```

These are coordinate identities, not imported assumptions about a warped
Jang equation. They also follow by computing the mixed curvature from the
two displayed connection coefficients; all other coefficients are those of
`g`. Here

```
l^(-1) Hess_g l = p Hess_g t + (p' + p^2) dt tensor dt.
```

Differentiating `G_+(nu,partial_i+f_i partial_z)=0` shows that the
second form, with convention `G_+(nabla_X nu,Y)`, is `-C`, where

```
C = H + p(dt tensor w + w tensor dt) + (p/d) b w tensor w.
```

For clarity, the hypersurface scalar formula used here follows by expanding
`nabla^+_X Y = nabla^bar_X Y - second(X,Y) nu` in the curvature
definition, then contracting tangent indices. It is
`R_bar = R_+ - 2 Ric_+(nu,nu) + (tr_A C)^2 - |C|_(A tensor A)^2`.
Thus, with `S_A(C)=((tr_A C)^2-|C|_(A tensor A)^2)/2`,

```
R_bar/2 = R_g/2 - Ric_g(w,w) + S_A(C)
          - p [v Delta_g t - Hess_g t(w,w)]
          - (p' + p^2) [v |dt|^2 - b^2].                 (1)
```

This formula retains the cutoff derivative before any redistribution.

The conformal formula follows independently from the connection difference
`Gamma_hat^h_ij-Gamma_bar^h_ij
 = delta^h_i t_j + delta^h_j t_i - bar g_ij t^h`.
Differentiation and contraction give

```
e^(2t) R_hat/2 = R_bar/2 - k Delta_bar t
                             - k(k-1)|dt|_A^2/2.         (2)
```

In particular there is no choice of timelike normal or Lorentzian Gauss sign
hidden in this derivation.

## 2. Independent divergence calculation

Differentiating the definitions, including `D`, gives

```
nabla_i w_j = H_ij - H_iw w_j + p d t_i w_j,
d log U = p(1+v) dt + H(w,.),
d log u = [k-1+p(1+v)] dt + H(w,.).
```

Consequently

```
Delta_bar t = tr_A Hess_g t - b tr_A H
                           + p [v |dt|^2 - (2-v)b^2],   (3)
div_u w = tr_g H + 2s b = tr_g L - tau + 2s b.           (4)
```

For a symmetric tensor `B`, put
`P_B=B-(tr_g B)g` and
`mathsf B(B,C)=<B,C>-(tr_g B)(tr_g C)`.
Set `C0=H+p(dt tensor w+w tensor dt)` and `Q=K+C0`.
The product rule, using the three differential expressions above, yields

```
div_u(P_Q w)
 = (div_g P_Q)(w) + mathsf B(Q,C0) + (k-1)P_Q(w,dt),     (5)
div_u(k A grad t)
 = k Delta_bar t + k(p+k-1)|dt|_A^2.                    (6)
```

The derivatives of `H` in (5) can be eliminated without assuming a field
equation. If `alpha=l/sqrt(D)`, then
`d log alpha = p d dt-H(w,.)`. Commuting derivatives of the scalar `f`
in the curvature convention specified above gives

```
(div_g P_H)(w)
 = Ric_g(w,w) + P_H(p d dt-H(w,.), w).                   (7)
```

To see precisely what remains when `p` varies, choose a unit gradient axis,
write `H=[[T_H,M_H],[M_H^T,j_H]]`, let
`r=tr T_H`, `h_T=tr_(axis perpendicular) Hess_g t`,
and `dt=(y,x)`, `w=a e`. Direct differentiation of
`P_(p(dt tensor w+w tensor dt))` gives

```
(div_g P_(p(dt tensor w+w tensor dt)))(w)
 = p' v |y|^2
   + p [v h_T - (1+v)a <M_H,y> + r a x + p d v |y|^2].  (8)
```

The contraction in (1), with the same notation, is

```
S_A(C) = (r^2-|T_H|^2)/2
          + r[d j_H + p a x(2-v)] - d |M_H+p a y|^2.
```

Equations (7)-(8) and this expression satisfy the exact identity

```
R_bar/2 = R_g/2 - mathsf B(C0,C0)/2
                       - (div_g P_C0)(w).              (9)
```

`graph_divergence_algebra` in Lean and
`riemannian_graph_vs_expanded_divergence` in `verify.py` check this
polynomial equality with arbitrary real contraction variables and arbitrary
`p'`. No dimension is substituted for `k`.

Use `mu=R_g/2-mathsf B(K,K)/2`, `J=div_g P_K`, and the bilinear identity

```
-mathsf B(K,K)/2 + mathsf B(Q,Q)/2 - mathsf B(Q,C0)
    = -mathsf B(C0,C0)/2.
```

Combining (2), (5), (6), and (9) now proves the invariant preidentity
`eq:scalar:invariant-preidentity` in the manuscript.

Finally `k dZ=q dt+H(w,.)` implies that `V/u` has transverse and axial
components

```
a M+q y,       chi a j+k d x.
```

The components of `P_Q w+k A grad t` are
`a M+q y` and `-a tr T+k d x`. Since `tr T=F-chi j`,
these vectors differ by `F w`. Equation (4) and the product rule therefore
give the literal scalar identity

```
e^(2t) R_hat/2
 = mu+J(w)+E+w(F)-F tau-div_u(V/u),
```

where `div_u(V/u)=u^(-1)div_g V`. The smooth invariant expression for `E`
is precisely

```
E = mathsf B(Q,Q)/2 + (k-1)P_Q(w,dt) + k s |dt|_A^2
                          + F(tr_g L+2s b).
```

Expanding its blocks gives `eq:scalar:quadratic`; the symbolic certificate
checks that identity with `|T^0|^2`, `|M|^2`, `<M,y>`, and `|y|^2`
left as arbitrary scalar contraction variables.

## 3. Cutoff transitions and zero slope

Holding the pointwise values of `t,dt,df,H,K` fixed for differentiation
in `p`, one has `chi_p=-chi v/q`. The two contributions in the final
redistribution are

```
w(F):          p' chi_p a x j,
div_g V/u:     p'[v |y|^2 + chi_p a x j].
```

Their difference is exactly `-p' v |y|^2`, agreeing with (1).
Neither the argument nor the certificate sets `p'` to zero or bounds it by a
constant independent of `N`.

At `df=0`, use the smooth invariant expression rather than differentiating
an arbitrarily chosen axis. Then `w=0`, `d=chi=1`, `F=tr L`, and

```
E = (|L|^2+F^2)/2 + k s |dt|^2.
```

This is axis independent. In evaluating the divergence at such a point it is
essential to keep `nabla w=H` and
`Hess Z=Hess t+H^2/k`. In normal coordinates this gives

```
div_g V/u = k Delta_g t + |H|^2 + <K,H>
                                + k(k-1+p)|dt|^2.
```

Substitution reduces both sides of the scalar identity to
`R_g/2+((tr H)^2-|H|^2)/2-k Delta_g t-k(k-1)|dt|^2/2`.
The certificate checks this reduction exactly. Smoothness then follows
directly from the invariant tensor definitions, whose only denominators are
positive `D` and `q`; there is no division by `|df|`.

## 4. Universal coercivity with a single quadratic loss

Let `R=1+p`, `A=k s-(k-1)^2 v/4`, and

```
alpha = k s d,   beta=(k+1)/(2k),
B = [k(k+2)+v]/[2(k+1)],   gamma=k d B/q^2.
```

The exact square completion is

```
E = |T^0|^2/2 + |M+s a y|^2 + A |y|^2
      + alpha (x+a j/q)^2
      + beta (F-chi j/(k+1))^2 + gamma j^2.              (10)
```

It holds for every real `k>=2`, not just integers, and requires no positive
lower bound on `d`. The following coefficient estimates hold:

```
A >= 1/2,       alpha >= d,       beta >= 1/2,
gamma >= 0,     d <= 2 R^2 gamma,
chi^2 <= d,     [chi/(k+1)]^2 <= d,
(a/q)^2 <= 1,   s^2 v <= k^2 R^2.
```

Here are explicit positive identities behind the potentially delicate
estimates:

```
A-(k^2-1)/4 = k p + (k-1)^2 d/4,
k s-1 = k p + (k-2)(k+1)/2,
2 R^2 k B-q^2
 = p(k-v)(k R+q) + k(k+v)R^2/(k+1),
d-chi^2 = d v(k^2+2kp+p^2 v)/q^2.
```

All their factors have the required signs under the literal hypotheses.
These identities and all ten coefficient estimates are also Lean theorems.

Put `z2=|M+s a y|^2`, `y2=|y|^2`, `t0=|T^0|^2`, and
`m2=|M|^2`. Summing the scalar square inequality
`m_i^2 <= 2(m_i+s a y_i)^2+2s^2 v y_i^2` gives
`m2 <= 2z2+2s^2 v y2`. Equation (10) and the estimates above imply

| Quantity | Upper bound |
|---|---|
| `d j^2` | `2 R^2 E` |
| `F^2` | `8 R^2 E` |
| `|T|^2=t0+(F-chi j)^2/k` | `12 R^2 E` |
| `d x^2` | `6 R^2 E` |
| `|y|^2` | `2 R^2 E` |
| `|M|^2` | `(2+4k^2) R^2 E` |

For example `F^2 <= 2(F-chi j/(k+1))^2+2d j^2`, while
`(F-chi j)^2/k <= F^2+d j^2`. The corresponding inequality for
`x` uses `x=(x+a j/q)-a j/q`. Thus the recovery of one variable
does not multiply an already incurred `R^2` loss by another such loss.
Summing the table proves exactly

```
|T|^2+|M|^2+d j^2+F^2+|y|^2+d x^2
    <= (32+4k^2)(1+p)^2 E
    <= (32+4k^2)(1+N)^2 E.
```

This is the manuscript's required polynomial degree, not merely an unspecified
polynomial in `N`.

When `dt=0`, (10) instead reads

```
E_0 = t0/2+m2+beta(F-chi j/(k+1))^2
                         + chi[1-k chi/(2(k+1))]j^2.
```

Since `1/2 <= beta <= 1`, the last coefficient is between `chi/2`
and `chi`, and `[chi/(k+1)]^2 <= chi`, elementary two-square estimates
give

```
(t0+m2+F^2+chi j^2)/16 <= E_0
    <= 3(t0+m2+F^2+chi j^2).
```

The constants are independent of `p`, `N`, and `k>=2`.

## 5. Sharpness and the degenerating axial weight

For `k=2`, choose

```
p >= 0,   a=1/2,   d=3/4,   q=2+p/4,
T=-I_2/2,   M=y=0,   j=q,   x=-1/2,   F=1/2.
```

The trace constraint is satisfied, and both completed axial squares in
`x` and `F` vanish. Exact substitution gives

```
E=33/16,
(|T|^2+|M|^2+d j^2+F^2+|dt|_A^2)/E
    = p^2/44+4p/11+21/11.
```

Taking integer `p=N` arbitrarily large rules out any uniform replacement
of `(1+N)^2` by `(1+N)^alpha` with `alpha<2`. This is a sharpness
family for the **valid** proposition, not a counterexample to it.

The factors `d` cannot be removed either. At `k=2,p=0`, choose
`j=1`, `x=-a/2`, `F=d/3`, `T^0=M=y=0`, with
`a^2=v<1`. Equation (10) gives `E=d(8+v)/12`, which tends to zero
as `v` tends to one while `j^2=1`. All these algebraic choices obey the
stated trace constraint. They can be realized by smooth local `f,t,K`
jets because `K` is unrestricted in these two propositions.

## 6. Reproduction and limits of evidence

From the campaign directory:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/scalar_identity_certificate/verify.py
```

The standalone script compares its computed exact results with
`exact_certificate.json`, replays the retained typed Jacobian determinant,
and independently computes scalar curvature directly from metric two-jets in
dimensions three and four, at zero and nonzero graph slope. The finite
coordinate checks retain nonzero `p'`, mixed Hessian entries, third
derivatives of `f`, first derivatives of `K`, and nonzero background curvature.
They are regression checks, not the proof of the universal assertions.

The Jacobian discovery, inspected contract, payload, output, and adapter
status are retained as JSON. The first, larger polynomial payload exceeded
the operation's expansion budget. Its exact rejected payload and structured
error are preserved separately and have no mathematical verdict. The accepted
payload keeps `chi,s,d` as independent variables, after which `verify.py`
checks their exact specialization. A determinant by itself is not used to
infer the quantitative bound.

`lean/Main.lean` and `lean/statement_fidelity.md` encode the universal scalar
algebra, the actual quadratic-in-`N` bound, the stationary bounds, and the
geometric contraction polynomial. The official successful run is attached to
`C_SCALAR_FORMAL_CORE`, with its archived certificate at
`lean/certificates/C_SCALAR_FORMAL_CORE-fe0c9623d19e9ee4.json`
relative to this directory. Compilation and the separate axiom audit both
returned zero, there were no proof holes, and the measured duration was
39,036 milliseconds. The only compiler messages were style warnings about
tactic sequencing; no source was changed after this successful run.
The separate
statement-fidelity document spells out the tensor-to-scalar translation and
the differential geometry not formalized by the kernel.

The exact command for a new independent compiler replay is:

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/scalar_identity_certificate/lean/Main.lean --statement-fidelity research/scalar_identity_certificate/lean/statement_fidelity.md --artifact-dir research/scalar_identity_certificate/lean --claim C_SCALAR_FORMAL_CORE --project-root .
```

The `lean/` directory is the canonical source location because the evidence
command copied its input into the chosen artifact directory. The redundant
input copies were removed after byte-for-byte comparison, so every remaining
Lean source has its own recorded compiler result. Neither the certified
source nor its fidelity document was modified.

The original durable execution receipt is
`task_id=scalar-core-lean-v1`,
`run_id=scalar-core-lean-v1-1793903930761745278`; its final state is `done`.
The original submission was `state=submitted`, and its `check_with`
command was
`$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.subagent status --task-id scalar-core-lean-v1`.
It was a direct compiler process, not an independent mathematical Reviewer.

No external literature proposition is assumed in this proof: the geometric
identities used above were derived from the connection and curvature
definitions. The model references in the manuscript are not presented as
unread support for this result. This verification does not establish a novel
research theorem or permit the campaign to stop under its publishability gate.
