# C55_AISLE: actual torsion pairs and comparison

**Engineer assessment: `conditionally_supported_written_proof`.** Sections
3--5 of the preserved report supply an actual-object argument, rather than a
numerical search. Under their explicit geometric inputs, the argument supports
the stated comparison and its radius. This is dependent on the algebraic unit,
not a second independently certified theorem.

## Exact claim, hypotheses, source, and attribution

Let `X` be a smooth complex quintic, polarized by its hyperplane class.
Use normalized characters `(r,c,d,e)`, ordinary slope `c/r`, and the ordered
exact functor `Phi=T_OX o (- tensor OX(1))`. An aisle means a bounded
`D^{<=0}`, closed under `[1]`. At `b=+/-1/2` take the first slope tilt
`B_b=<C_{<=b}[1],C_{>b}>`, put `p_b=c-br`, and set
`N_b^eta=d-bc+u*r+eta1*c+eta0*r`. High means `p_b=0` or `N_b^eta>0`;
low means `p_b>0` and `N_b^eta<=0`. The second torsion classes are defined
by high nonzero quotients and low nonzero subobjects, respectively.

The claim is that these definitions give bounded double-tilt aisles and
`Phi U_eta subset U_theta` for **independent** endpoints on some open
square whenever `0<u<13/46`. For `u=uG=(5-sqrt(5))/10`,
`abs(eta_j),abs(theta_j)<1/4000` works. An arbitrary `u` is not claimed
to be a Gepner eigencharge.

This is historical C55_AISLE v1, from the old report at
`families/055/first-pass/gepner-aisle-audit/report.md`,
sections 2--5. Reference `build/sections/aisles.tex` at supplied revision
`4eaee87548250b2682affda7d05d947c05554bae` contains
`lem:second-tilt`, `lem:compare-slope-cuts`, `lem:twist-aisle`, and
`prop:uniform-aisle`. The construction is a reconstruction of that argument.
Using Xu's sharper function directly gives the old draft's proposed enlarged
square and sufficient parameter range; novelty beyond the supplied source
has not been checked.

Xu **arXiv:2511.21288v2, Theorem 1.3**, applies to actual positive-rank,
torsion-free, H-slope-semistable sheaves with slope in `[-1,1]`.
The separate primary-source reader confirmed the exact normalization and
all six formulas on seven intervals, with no extra genericity hypothesis.
See [the source reading](../sources/sources.json) and
[the passage](../sources/xu_2511.21288v2.txt).
Its proof is external, not re-established here. Also assumed are noetherianity
of `Coh(X)`, finite slope HN filtrations and Hom vanishing, positivity and
integrality of actual sheaf characters, coherent reflexive hulls, ordinary
derived truncations, and Serre duality with Serre functor `[3]`.

## Decisive object-level checks

The noetherianity proof of `B_b` does not assume the desired second-slope
HN theorem. In a chain of epimorphisms, the nonnegative half-integral
`p_b` eventually stabilizes. Its individual kernels then have `p_b=0`
and nonpositive rank. The ordinary `H^0` quotients stabilize in `Coh(X)`;
the increasing integral ranks are bounded by that fixed `H^0` rank.
Remaining kernels are sheaves of dimension at most one. The resulting
increasing torsion-free `H^-1` sheaves agree in codimension one and embed
compatibly in one fixed coherent reflexive hull, so that chain stabilizes.
This justifies the maximal-subobject argument actually needed below.

At slope `b`, Xu gives `N_b^eta/r <= u-3/10+(3/2)*delta<0`.
Thus `N_b^eta>=0` on the `p_b=0` part of `B_b`, vanishing there
only on zero-dimensional sheaves. High objects are extension-closed.
A high subobject with minimum discrete `p_b` cannot have a low quotient:
its kernel would be another high subobject with smaller `p_b`.
Consequently every high subobject contains a nonzero second-torsion
subobject. Noetherianity now gives a maximal one; its quotient has
only low subobjects. These observations prove the torsion pair and
the bounded HRS tilt, not just numerical positivity.

The zero-class exclusion also uses objects: for an object built from `T`
and `F[1]`, zero `N` forces each contribution to vanish. Then `T`
is zero-dimensional and a nonzero `F` would have `p_b(F)>0`, contradicting
zero total class. Finally the zero-dimensional length is `5e`, so the
remaining `T` is zero.

For comparison set `s=13/23`. Xu gives
`max_[1/2,s](g(x)-x/2)=-13/46` and `g<=0` on `[0,1/2]`.
Use the common heart intersection `L=B_- intersect B_+` and the ordinary
sheaves `M` with slopes in `(-1/2,1/2]`. Removing the `M[1]` part of a
putative map `T_+^alpha -> F_-^theta` is legitimate because
`Hom(M[1],B_-)=0`. Factoring in `B_-` yields an actual exact sequence

```text
0 -> S -> U' -> Q -> 0,
S in M, U' in L intersect T_+^alpha, 0!=Q in L intersect F_-^theta.
```

Importantly, it does **not** put `S` in `B_+`. The forbidden top/bottom
slope factors are respectively actual shifted subobjects of `Q` and
actual quotients of `U'`. They give
`c(Q)>=-s*r(Q)`, `c(U')>=s*r(U')`.
For `C=c(Q)+c(U')` this implies `C>0` and `s*r(S)<=C`;
the slopes of `S` give `d(S)<=0`. Also `abs(r(L))<=2c(L)`.
The perturbation error is therefore at least `-3*delta*C`, and

```text
N_-^theta(Q)-N_+^alpha(U')
  >= (1/2-u/s-3*delta)*C-d(S) > 0.
```

Its left side is nonpositive by the quotient/subobject definitions.
This proves Hom vanishing and the cross-slope aisle inclusion. The
algebraic separation lemma formalizes the final inequality only.

The twist step checks `O_X in A_-^theta` and
`O_X[2] in A_+^alpha`, including the `p_b=0` boundary tests.
Here `Ext^1(T,O_X)=H^2(T)^*=0` for support dimension at most one
is used with the correct Serre shift. For `B in U_+^alpha`,
`Ext^j(O_X,B)=Hom(B[j-1],O_X[2])^*=0` for `j>=2`.
The finite twist triangle then has only nonnegative shifts of `O_X`
in its other term, all in `U_-^theta`. Thus it works for the whole
aisle, not just heart objects.

## Strongest constants and limits

For general `u`, take `delta=min(u/4,(13/46-u)/10)`.
For `uG`, take `delta=1/2000`. Using the exact rational enclosure of
`uG`, the four lower margins are

```text
539/2000; 2857/125000; 62469/11500000; 61719/6500000.
```

Tensoring first sends
`alpha1=eta1`, `alpha0=eta0-eta1`. Thus the comparison radius is
`delta/2=1/4000`, not `delta`, and both endpoints remain independent.
The preserved exact checker replay confirms these numbers and the shear.

Adding `20u+13s<=13` to 13 times `2u-s<=0` gives `46u<=13`.
This verifies **13/46 only as the optimum of those sufficient
inequalities**. At the endpoint the needed strict margins disappear;
no categorical failure there, or beyond it, has been proved.

No unresolved internal step was identified in this conditional written
argument. The concrete boundaries are its external sheaf inputs and the
unformalized object-level constructions above. Compilation does not
discharge either. Native independent review and registration of the
current citation readings remain outstanding; old reviewer-labelled records
are not current Host acceptance.
