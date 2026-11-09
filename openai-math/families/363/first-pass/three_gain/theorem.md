# A sharp three-gain submersion theorem for axial collision partners

## Statement

Fix t0 > 0, x0 in R^3, and v0 with nonzero horizontal component. For
i = 1,2,3, let a_i:(0,infinity) x R -> R be arbitrary real-analytic
functions. On the connected open domain

    O3 = {0 < t3 < t2 < t1 < t0} x (R^3)^3

define, with e3=(0,0,1),

    x_i = x_{i-1} - (t_{i-1}-t_i) v_{i-1},
    n_i = v_{i-1} - a_i(t_i,(x_i)_3) e3,
    v_i = v_{i-1} + n_i cross L_i,
    Phi3 = (t3,x3,v3).

**Theorem.** Phi3 has rank seven almost everywhere on O3. Two gains have
rank at most six everywhere, even for merely differentiable profiles.
Thus three is the sharp universal gain count in this nonaxial setting.
The same rank theorem holds if the scalar axial profiles depend analytically
on all three spatial coordinates: every derivative of a scalar profile still
contributes only in the e3 direction.

This is a theorem about the history map, not a proof of either manuscript's
nonuniqueness theorem. It improves their stated five-gain rank count to three.
The original five-gain assertions are not contradicted. Novelty relative to
the wider literature and publishable significance require independent review.

## An ordered witness and its actual first variation

A fixed proper rotation about e3 sends v0 to (R,0,Z), R>0. Cross products,
flights, and the profiles a_i(t,z) are equivariant under this rotation.
Such changes of input/output coordinates preserve rank. For full-spatial
profiles, rotate their spatial arguments as well; their analytic class is
preserved.

Choose any strictly ordered positive times, for example
t1=3t0/4, t2=t0/2, t3=t0/4, and set

    L1=(0,0,-1/R), L2=(0,0,1), L3=0.

Direct substitution in the recursive map gives

    k1=(0,1,0),       v1=(R,1,Z),
    k2=(1,-R,0),      v2=v3=(R+1,1-R,Z),
    (x_i)_3 = (x0)_3-(t0-t_i) Z.

This is an interior, ordered witness. All n_i have nonzero horizontal
components. There is no assumption on a_i or its derivatives at these points.

For arbitrary variations write da_i for the *total* scalar profile variation.
It includes a_{i,t} dt_i + a_{i,z} (dx_i)_3 (or the full spatial gradient).
The recursive chain rule, without treating profiles as constants, is

    dx_i = dx_{i-1} - v_{i-1}(dt_{i-1}-dt_i)
                         -(t_{i-1}-t_i)dv_{i-1},
    dv_i = dv_{i-1} + (dv_{i-1}-da_i e3) cross L_i
                         + n_i cross dL_i.

At this witness every L_i is axial or zero. Hence the term
(-da_i e3) cross L_i vanishes identically, whatever dependencies da_i has.
This cancellation is why arbitrary analytic axial profiles are allowed.

Restrict to the seven input columns

    (dt1,dt2,dt3,dL1_y,dL2_z,dL3_y,dL3_z).

Put D=t1-t3, E=t2-t3, b1=Z-a1(t1,(x1)_3),
b3=Z-a3(t3,(x3)_3). In output order (t3,x3_x,x3_y,x3_z,v3_x,v3_y,v3_z),
the resulting matrix is

```text
 0   0    1       0       0       0       0
 0  -1   R+1    b1 D    -E       0       0
-1   R   1-R   -b1 E    R E      0       0
 0   0    Z     -R D     0       0       0
 0   0    0     -b1      1      -b3     1-R
 0   0    0      b1     -R       0      -R-1
 0   0    0       R      0       R+1      0
```

Its determinant is

    R D (R+1)(R^2+1) > 0.

For example, expand first along the final-time row, then the two earlier
time columns in the horizontal position block, and finally the vertical
position row. The remaining velocity block has determinant
(R+1)(R^2+1), independently of b3. No profile value or derivative needs
to be selected, bounded, or adjusted. The entry b1 in the remaining
column does not affect the determinant.

`verify.py` differentiates the complete recursive map using independent
affine profile 1-jets about the actual three evaluation points. This is
sufficient for arbitrary differentiable profiles: the differential of a finite
composition depends only on those first jets. The values and both partial
derivatives at each evaluation point are free symbols, not sampled numbers.
It checks the resulting matrix and determinant and independently checks the
two-gain kernel using the full recursive first variation. `Main.lean`
formalizes the witness collisions, cancellation of arbitrary total profile
variations, the full seven-column linear map, and this determinant.

## From one witness to almost-everywhere rank

The recursive map is real analytic on O3. In particular the determinant of
the same seven coordinate columns is an analytic scalar function f on O3.
The witness proves f is not identically zero. O3 is connected (an open
simplex times a Euclidean space). Its rank-failure set is contained in {f=0}.

Here is the analytic-null-set bridge, including the identity principle it
needs. For an analytic function on a connected open set, the points at which
all derivatives vanish form both a closed set (continuity of all derivatives)
and an open set (the Taylor series vanishes in a neighborhood, with all its
derivatives there). Nontriviality and connectedness therefore imply this
set is empty. At any zero of f, take a nonzero derivative of least order;
its order is positive. Delete one differentiation from its multiindex,
obtaining an analytic derivative g with g=0 and some first partial derivative
of g nonzero at that point. The implicit-function theorem makes the nearby
zero set of g a C1 hypersurface, which is Lebesgue null. A countable cover
of these regular zero sets, over all derivative multiindices and coordinate
charts, covers {f=0}; hence {f=0} is null. The countable charts exist by
second countability. This is the standard argument of Mityagin,
arXiv:1512.07276v1, Proposition 0, supplied here so no unproved special
zero-set assertion is required.

It follows that Phi3 is a submersion almost everywhere. No claim is made
that it is a submersion at *every* history.

## Extension to the original five-gain map

The same conclusion holds for every fixed m>=3, with arbitrary analytic
axial partners at every step. Keep the first three witness planes above,
set L4=...=Lm=0, and choose strictly ordered times. Then vm=v3 and

    xm=x3-(t3-tm)v3.

Hold t3,...,t_{m-1} fixed and select the columns
(t1,t2,tm,L1_y,L2_z,L3_y,L3_z). For the six nonfinal-time columns,
the row operation dxm -> dxm+(t3-tm)dvm recovers the three-gain position
rows. The final-time column has leading entry one and so its other entries
do not affect the determinant. The resulting determinant is exactly the
same R(t1-t3)(R+1)(R^2+1). All later profile derivatives are killed by
their zero base planes. The same analytic-null-set argument on the
connected m-gain ordered domain proves a.e. rank seven.

In particular this verifies the rank assertion of the manuscripts' actual
five-gain map, not merely a different three-step model. `verify.py` also
differentiates that complete five-step recursion with arbitrary first jets
at all five partner evaluation points and verifies this row reduction and
the identical determinant. The m-gain extension is a prose/algebraic
corollary; the Lean declarations themselves concern the three-gain core.

## Two gains: an everywhere obstruction, including zero normals

For m gains the redundant input dimension is 4m. At an arbitrary history,
if n_i != 0, vary only L_i by n_i. This changes neither the increment
n_i cross L_i nor any previous state, so it leaves the entire subsequent
history, and the output, unchanged to first order. If n_i=0, *any* variation
of L_i has the same property. Choose one nonzero vector in that block
in either case. The m chosen input vectors have disjoint plane-coordinate
blocks, so are linearly independent. Rank-nullity gives rank <= 4m-m=3m.
For m=2 this is at most six, regardless of time order or endpoint.
This proof does not divide by |n_i| and does not overlook zero normals.

The nonaxial assumption is essential to a statement uniform over all
profiles: with axial v0=Z e3 and every a_i identically Z, all n_i vanish
and v_i=v0. Then Phi_m depends only on t_m and has rank one for every m.
This boundary example is not a counterexample to a staged manuscript claim.

## Uniform pullback and perturbation bridge

Let O be open in R^k, k>=7, and Psi_n -> Psi in C1_loc, with rank DPsi=7
almost everywhere. Let K compactly contained in O and B compact in R^7.
Suppose |w_n|<=A and supp w_n subset K, and |F_n|<=M,
supp F_n subset B, with F_n -> 0 in measure. Then

    integral_O |F_n(Psi_n(q)) w_n(q)| dq -> 0.

For completeness, boundedness and convergence in measure on the finite-volume
set B give ||F_n||_1 -> 0: for any eta>0 the integral is at most
eta |B| + M |{|F_n|>eta}|.
Enclose the null critical subset of K in an open set G of volume <epsilon.
The compact regular set K\G has a finite cover by small convex coordinate
boxes U_j. In each choose complementary input coordinates s_j so that

    H(q)=(Psi(q),s_j(q))

has invertible derivative at the center. Shrink the box until DH stays
sufficiently close to that fixed invertible matrix. C1 convergence ensures
the same bound for H_n=(Psi_n,s_j), uniformly for all large n. Integration
along line segments in the convex box proves a uniform lower Lipschitz
bound for H_n. Thus H_n is injective there, is a C1 local diffeomorphism,
and its inverse Jacobian is uniformly bounded. Change variables to
(y,s_j); the s_j-projection of the box has bounded volume. Consequently

    integral_{U_j} |F_n(Psi_n(q))| dq <= C_j ||F_n||_1.

Summing the finite cover and estimating the part in G by AM epsilon proves
the assertion, first taking n to infinity and then epsilon to zero.
This argument explains both chart injectivity and the required uniform
constants; no convergence of w_n is assumed.

Apply this with Psi=Phi3. Additional spectator variables are allowed:
the limiting map can ignore them. Its rank stays seven almost everywhere
by Fubini, and the same compact-chart proof applies. This is a uniformity
statement along a C1-convergent sequence, **not** a uniform lower bound for
the determinant at all histories, all endpoints, or all unbounded scales.

For endpoint sequences converging to a nonaxial endpoint and profile
sequences converging in C1 on compact sets visited by the recursive maps,
finite composition and the product/chain rules give C1 convergence of
the history maps on each compact history set. A positive lower bound on
the visited times keeps them inside the profile domain. Profile convergence
must actually hold; it is not supplied by analyticity of the limit alone.

## Manuscript specialization and limits of the result

The exact recursion, cross-product orientation, final-time output, and
three-dimensional redundant plane parameters agree with equation
`nc:rank-map` in both staged versions; see `scope.md` for source locations.
Their profiles are analytic by the monotone implicit equation verified there.
Their profile scales must stay bounded away from zero when taking the
prelimit compact C1 limit. The finite-temperature spectator variables and
their compact-density hypotheses enter exactly through the preceding bridge.

The source's redundant-plane density is supported in bounded L after
the small-normal and large-increment cutoffs. The nonzero witness need not
be in that density's support: the analytic determinant is nontrivial on the
whole connected domain, so its zero set is null on every measurable subset
where a bounded density is integrated. At n_i=0 the polynomial history map
itself is still defined; singular Carleman weights require the manuscript's
separate truncation/estimate and are not declared bounded by this theorem.

The new map theorem replaces the rank/pullback *input* in the manuscript's
five-gain nonaxial argument. It does not by itself prove a three-gain version
of their complete nonconcentration estimate: all kernel weights, cutoff
removals, stopping conditions, and hot/cold bounds still need their own
justification. Nor does it verify compactness, cap separation, branching,
entropy admissibility, nonzero limiting mass, or local conservation.

## Replay

From the campaign root, run

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/three_gain/verify.py --check
```

This needs SymPy but no live Jacobian service: it recomputes the derivative,
checks the exact stored certificate and payload, and checks the archived
typed adapter response and its successful exit status. The adapter operation
is `matrix.symbolic.determinant.compute`, server version 0.14.0, protocol
2025-11-25; its returned method is `SYMPY_BAREISS`. The adapter check is an
exact symbolic calculation, not the independent Reviewer.

The separate real Lean compiler command is

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/three_gain/Main.lean --statement-fidelity research/three_gain/statement_fidelity.md --claim C3_ALG --project-root .
```

Its source and statement-fidelity files must not be edited during compilation.
The host's prebuilt Mathlib workspace is used; no project Lake file is needed.
