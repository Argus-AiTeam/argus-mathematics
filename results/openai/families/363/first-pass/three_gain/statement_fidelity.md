# Reading of `Main.lean`

The source imports Mathlib and works over the real numbers with coordinate
vectors `Fin 3 -> Real` and `Fin 7 -> Real`. `ThreeGain.cross` is the standard
right-handed cross product: its first coordinate is a_y b_z - a_z b_y.
`axis a=(0,0,a)`. `collide v a l = v + (v-axis a) cross l`, exactly the
manuscript's collision update, not its negative.

`witness_first_collision` quantifies over all real R,Z,a, assumes R != 0,
and proves that v0=(R,0,Z), L1=(0,0,-1/R) give v1=(R,1,Z).
`witness_second_collision` quantifies over all real R,Z,a and proves that
L2=(0,0,1) gives v2=(R+1,1-R,Z) from that v1, independently of a.
`witness_third_collision` states that L3=0 leaves every velocity unchanged.
These establish the baseline velocities used by the first-variation formula.

`firstVariation` is the seven-column first variation of the *recursive*
history map at this witness, in input order

    q=(dt1,dt2,dt3,dL1_y,dL2_z,dL3_y,dL3_z).

It uses dx1=dt1 v0 and, for the later flights,

    dx_i=dx_{i-1}-(dt_{i-1}-dt_i)v_{i-1}
                       -(T_{i-1}-T_i)dv_{i-1}.

Its collision differentials are

    dv_i=dv_{i-1}+(dv_{i-1}-p_i e3) cross L_i+n_i cross dL_i.

Here n1=(R,0,b1), n2=(R,1,b2), n3=(R+1,1-R,b3).
In the analytic map b_i=Z-a_i(T_i,(x_i)_3). Each p_i is the *total*
profile differential a_{i,t}dt_i+a_{i,z}(dx_i)_3, or the corresponding
full-spatial differential. The Lean statement quantifies over arbitrary real
p1,p2,p3 as well as arbitrary q. Consequently it covers those dependent
choices too; it does not freeze the profiles or omit their chain rule.
All these p_i terms cancel because L_i is axial or zero.
The output order is (dt3,dx3_x,dx3_y,dx3_z,dv3_x,dv3_y,dv3_z).

`firstVariation_eq_minor` proves for all real R,Z,b1,b2,b3,T1,T2,T3,
p1,p2,p3 and every q that this recursive variation equals the displayed
matrix `minor R Z b1 b3 (T1-T3) (T2-T3)` applied to q. No analytic or
nondegeneracy hypothesis is needed for this algebraic identity.
Although the formula contains 1/R, the term containing it vanishes; its
identification with the *baseline collision* requires R != 0, as supplied
by `witness_first_collision`.

`minor_det` proves universally over real R,Z,b1,b3,D,E that its determinant
is R D (R+1)(R^2+1). `minor_det_positive` assumes R>0 and T3<T1 and
proves this determinant strictly positive with D=T1-T3, E=T2-T3.
The actual witness has the stronger time order 0<T3<T2<T1<T0. Neither
T0 nor x0 enters the determinant. The entries and coordinate order coincide
with `verify.py` and `exact_certificate.json`.

`plane_kernel` proves n cross n=0 for every real vector n.
`zero_normal_kernel` proves 0 cross l=0 for every l.
These are the local algebra used in the two-gain obstruction; the
disjoint-block independence and rank-nullity argument are proved in prose.

The compiler certifies these exact algebraic declarations only. It does
**not** certify differentiability or the chain rule, the analytic-null-set
theorem, connectedness, change of variables, rotation equivariance, the
two-gain rank-nullity argument, the compact uniform-pullback theorem,
the manuscript profile's implicit-function analyticity, any PDE claim,
or novelty/significance. Their precise mathematical bridges are in
`theorem.md` and `scope.md` and require independent human review.
