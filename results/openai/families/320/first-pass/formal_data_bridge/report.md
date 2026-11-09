# The marked-cut to formal-data bridge

## Result and limits

The calculation below verifies the mixed-endpoint assembly, including its
actual residual ideals and all products of distinct source parameters,
**conditional on the single-cut and marked-algebraicity inputs MT 4.4,
4.5, and 5.1**. It does not independently prove those substantial
inputs. Consequently this is not yet an unconditional certification of
the complete bridge required by the live objective, nor a refutation of
Proposition `for:formal-data` or either main theorem.

There is a definite, repairable citation error: `formal.tex:785` says
"Apply the nilpotent correction of [MT, Lemma 3.9]." The pinned MT
paper has no Lemma 3.9; the required result is Lemma 6.7, *Correction
over the full parameter algebra*. This observation is recorded as
`F_MT_NILPOTENT_LOCATOR`. It is a bibliographic checkpoint, not a
publishable counterexample. In particular it must not be used to
declare the campaign complete.

The strongest prior result relevant here is MT's smooth two-vertex,
three-slot calculation, with its already stated full-parameter
correction. The mathematical increment established here is an explicit
check that the signed local calculation and four-slot ideal argument
extend to arbitrary endpoint designations and the punctured form
complex. The increment is conditional, not a verified novelty claim.

## Exact source and hypotheses

The target is the October 4, 2026 manuscript in
`research/openai_manuscript/Nonhomeomorphic-closed-aspherical-four-manifolds-with-the-same-homotopy-type-October-4-2026/build/`.
The relevant statements are:

* `formal.tex:32-46`, Lemma `for:cuts`;
* `formal.tex:151-159`, Lemma `for:linear`;
* `formal.tex:246-280`, Proposition `for:formal-data`;
* `formal.tex:314-344`, Lemma `for:edge-input`;
* `formal.tex:435-451`, Lemma `for:vertex-identities`;
* `formal.tex:565-588`, the first exact-action correction;
* `formal.tex:751-826`, polynomial replacement and nilpotent correction.

MT and PD are pinned at openai/math commit
`4eaee87548250b2682affda7d05d947c05554bae`. The archived sources are in
`literature/`. Exact document URLs are obtained by appending their
preprint paths to
`https://github.com/openai/math/blob/4eaee87548250b2682affda7d05d947c05554bae/`.
Here MT means *A marked tensor obstruction to four-dimensional disk
embedding*, September 24, 2026; PD means *A PD4 group without an
aspherical manifold model*, September 24, 2026.

The input being used is not a reduced representation variety:

1. MT Lemma 4.4 and Proposition 4.5 identify, on every local Artinian
   algebra, the based flat-representation functor with the **actual**
   curvature/gradient quotient of the single-cut slice, including the
   boundary commuting equation. The internal tangent space is
   `H^1(Y, boundary Y) tensor sl_2`.
2. MT Theorem 5.1 gives a formal right equivalence with an algebraic
   central potential and algebraic lifts of marked holonomy matrix
   entries on its **whole possibly nonreduced critical scheme**. It does
   not give algebraic logarithms or off-critical `SL_2` identities.
3. PD Lemma 2.4 supplies the punctured vertex form complex, not a
   smoothing of the filled vertex. Its precise assertion and proof are
   at `literature/pd_chamber.tex:445-490`.

The source-reader checked that these propositions are present. That is
citation fidelity only. An independent Reviewer still needs to judge
both their application here and the remaining mathematical dependency.
No independent approval is being asserted.

## A. Punctures and linear data

Let a vertex piece have finite puncture set `Z`. In degree zero use
functions separately constant near each puncture, and in positive
degrees forms vanishing near each puncture. At a puncture the sheaf
stalk is the constant field in degree zero and zero otherwise. Away
from `Z` it is the ordinary de Rham complex. Partitions of unity can be
made constant on smaller disjoint puncture neighborhoods. The usual
fine-resolution argument therefore computes the **filled** cohomology.
The kernel of evaluation at one point of the outside face removes
only `H^0`, by the long exact sequence of that evaluation map.

A positive-degree coefficient in any formal expression vanishes near
`Z`. For one coefficient only finitely many wedges, contractions, and
collar extensions occur. Cut off smaller puncture neighborhoods for
that coefficient and apply ordinary smooth Stokes; the new boundary
terms vanish. This needs neither a common neighborhood for the entire
series nor smoothness at the removed points. Degree-zero gauge
constants at different ends must **not** be identified. Filling a
finite collection of interior points in dimension four does not change
the fundamental group: loops and disk homotopies can be moved off the
points in local topological balls.

For the connected pieces in `for:cuts`, Mayer--Vietoris and the graph
homotopy type give

    Delta^2 : direct_sum H^2(V_v) -> direct_sum H^2(Y_e)  an isomorphism,
    Delta^1 : direct_sum H^1(V_v) -> direct_sum H^1(Y_e)  a surjection.

The kernel of the latter is `H^1(W)/H^1(Gamma)`. Evaluations on the
named extra loops identify this kernel with their coordinate space.
Thus fixing those evaluations gives a unique kernel correction.

At a torus, the two outside longitudes are the two distinct
coordinate slopes and each bounds in its own outside face. The
half-lives/half-dies line cannot be a third line: both vertex images
would then restrict trivially, contrary to surjectivity. This determines
the plus and minus designations independently on each edge. Evaluation
on the detected coordinate comes only from the plus endpoint. Imposing
zero plus and extra evaluations consequently gives exactly the tangent
isomorphism `for:tangent-isomorphism`. In particular each individual
vertex restriction in degree two is injective. The relevant edge
duality is **relative H^1 against absolute H^2**.

These are implications from the stated connected cut decomposition,
not a new proof that a hypothetical filling admits that decomposition.

## B. Signed vertex identities, retaining the residual list

Work first in the joint local ring

    R = C[[sigma, y]][t_e : e plus at v] / (t_e^2),
    I = (r_1, ..., r_q),   m = (sigma, y, t).

Use the based punctured form complex above. Splitting its cochain
spaces gives a contraction with the usual side conditions. The
Kuranishi recursion and Bianchi identity yield

    curvature = (1 + K ad_a)^(-1) iota(r),     I subset m^2.

This is a finite **generating list**, not a regular sequence. Fixing
extra holonomies and plus-meridian holonomies is a smooth parameter
slice because their differential is the independent evaluation map
from A. Negative endpoints use the central slice: their detected
alpha loop bounds in the outside face, even when other endpoints
carry source parameters.

In the flat quotient, normalize the outside face by disjoint strips
dual to its free generators. Its form is a sum of constant matrix
coefficients times closed strip forms with disjoint supports, hence
its curvature and Chern--Simons action vanish. Its trace is `u zeta`
at a plus end and a multiple of `xi` at a minus end. Based gauges
between identical flat torus traces are the identity on the whole
torus by parallel transport, so the single-cut slice gauges glue.

Lift the coordinates and the gauge logarithms off `R/I`. Each
discrepancy is an actual sum `sum r_a gamma_a`; formal division is
coefficientwise with the same finite residual list. Extend through
collars away from the punctures and correct by these ideal multiples
to make the outside strip trace exact. This produces a connection
`a_hat` whose curvature is in `I`. The leading residual coefficient
forms differ from the original representatives only by exact forms.

For the action convention in the manuscript,

    C(a) = integral tr( a da / 2 + a [a,a] / 6 ),
    delta C = integral tr(delta a curvature)
              - integral_boundary tr(a wedge delta a) / 2,
    d CS(a) = tr(curvature wedge curvature) / 2.

Thus `C_boundary V(a_hat)` is in `I^2`. Interpolating a cut restriction
to its lifted slice changes the interior action by `I^2`, since both
the displacement and curvature are in `I`. At a minus end its
boundary term is zero: both traces are in the same `xi` polarization.
At a plus end interpolate `u zeta` to `u zeta + v xi`, with `u` fixed.
The boundary change is exactly

    -epsilon tr(u v) / 2.

The adjusted edge potential has the opposite term
`+epsilon tr(u v)/2`. Orientation of the minus face contributes
the negative central potential. Hence the signed sum satisfies
`S(M) in I^2`. This calculation is local to each boundary face;
it never sets a product of distinct source parameters to zero.

Internal differentiation pairs cut curvature with slice derivatives.
It gives an actual matrix identity

    (partial_h S)(M) = L r.

At the joint origin the matrix is the signed relative/absolute
pairing of edge tangent representatives against restricted vertex
`H^2` representatives. Exact-form changes contribute zero by Stokes
and the zero boundary trace of the relative representative.
Injectivity in degree two and perfect duality give full column rank.
A chosen `q`-row determinant is a unit. This is a calculation of
`L`, not an inference that the entries of `r` have no syzygies.
Since `I subset m^2`, lifts preserve the required first derivatives.

## C. Exact action before recentering

The following argument is included rather than treating MT Lemma 6.4
as an extra assumption. Suppose the current error is in `m^n I^2`
and the restricted gradient is `L r` with its chosen unit minor.
Write the error as `sum c_ab r_a r_b`, `c_ab in m^n`, without requiring
uniqueness. The inverse minor gives a displacement in `m^n I` whose
linear Taylor term is minus that error.

The internal Hessian at the joint origin vanishes: central edge
potentials start in degree three and other terms have a source
parameter. The Taylor remainder is consequently in
`m^(2n+1) I^2`; the gradient coefficient matrix changes by
`m^(n+1)` times a matrix. Higher Taylor terms obey the same bound
because `I subset m^2`. The chosen minor remains a unit.
Starting at `n=0`, repeat with `n -> 2n+1`. The corrections converge
in the joint maximal-ideal topology and retain the fixed functions
`r`. The limiting section satisfies `S(M)=0` and its restricted
gradient generates precisely `I`. If `q=0`, both conclusions already
hold. No step divides by an entry of `r`.

## D. Marked algebraicity and the order of recentering

Apply the *assumed* MT Theorem 5.1 separately to each central edge
potential. Transport each vertex graph by the common central coordinate
change. Choose algebraic matrix-entry lifts `G_e` with value `1` at
the original center. The logarithmic coefficient obeys

    b_form - ell(G) in Jac(F),    ell(G) = -epsilon tr(T log G).

Writing this difference as `sum c_k partial_k F`, the exact
dual-number coordinate change `x = h + t c(h)` rewrites the plus
potential as `F(x) + t ell(G(x))`. It is made only at that plus end;
at `t=0` it is the common central coordinate change. The minus end
therefore retains the same central potential. Its Jacobian is
invertible, so actual gradient ideals are transported, not radicalized.

The common graph background assigns identity to all ports and the
nine matrices `exp(a sigma e) exp(b sigma f)`, `a,b=0,1,2`, to the
identity and eight named extra conjugators. These assignments extend
over the marked graph since its generators are free. The cut frames
can be chosen along the prescribed paths; a graph cycle adds a free
generator, not a consistency relation.

The based single-cut identification makes the two central edge
coordinates of this background the same. Recenter **in the joint
sigma-adic ring**, using the positive-sigma-order background, and only
then pass to `K = C((sigma))` and complete in the new internal
coordinates. No arbitrary Laurent-coefficient series is subsequently
translated by a nonzero sigma-dependent constant.

Substituting the background in a finite algebraic presentation shows
the shifted `F` and `G` are algebraic over `K`. At the new center
`G=1`. The value of `F` there is zero because its derivative along
the original central-critical background curve is zero and its
original value is zero. The tangent and residual determinants were
units at the joint origin and remain nonzero after this substitution.
The recentered residuals may have linear terms; C must not be
reapplied on the strength of the old quadratic-order assertion.

## E. Four slots and all endpoint mixtures

In the recentered local ring fix four lifted traceless logarithms
`X_1,...,X_4` for one law set; use the **same lifts** for its whole
finite family of conjugated laws. They vanish at the background.
Let `J_L` be generated by products of one scalar coordinate from
each `X_j`. This is a finitely generated ideal, even if it is zero
or has syzygies.

The Brunnian word condition puts every law entry minus identity
in `J_L`. Its multilinear part is

    B(U1,U2,U3,U4) = [[U1,U2],[U3,U4]],
    Uj = Ad(g_aj) Xj,

and all higher terms are in `m J_L`. Here sigma is a scalar in `K`,
not part of the recentered maximal ideal. In the basis `(e,h,f)`,
the nine adjoints have determinant `512 sigma^18`, with lexicographic
order on `(a,b)` and row-major vectorization. Also

    B(h,e,h,f) = -4h.

These are exact polynomial identities, checked by `verify.py`.
For any chosen input coordinate at each slot, apply the rank-one
endomorphisms sending that coordinate to `h,e,h,f` respectively, and
then the output functional `-h_coordinate/4`. The resulting scalar
is exactly the product of those four input coordinates. Expanding
the rank-one maps in the nine adjoints expresses every generator of
`J_L` in the span of the leading law entries.

If `Q_L` is generated by the actual law entries, the disk-bounding
hypothesis gives `Q_L subset I`, while the preceding calculation gives

    Q_L subset J_L,       J_L = Q_L + m J_L.

Nakayama applied to the finitely generated module `J_L/Q_L` gives
`J_L = Q_L subset I`. It needs neither a reduced ring nor flatness
over the individual-square parameter algebra.

At a plus slot substitute `X_i = -t_i T_i modulo I`, choosing one
nonzero coordinate of `T_i`. At a minus slot, the marked central
slice identifies `exp(X_j)` with the algebraic lift `G_j(M)` modulo
`I`. Since each entry of `exp(X)-1` is in the ideal of the entries
of `X`, this yields **every** mixed-entry membership

    product_plus(t_i) product_minus((G_j-1)_(a_j,b_j)(M)) in I.

All-plus, all-minus, and mixed configurations are included. Additional
parameters outside the four slots are never specialized away.

## F. Polynomial replacement and finite correction

Set `D=G-1` and use the algebraic weight

    b = -epsilon tr(T (D - D^2/2)).

It vanishes at the recentered origin. At a plus end, set **only its
own** parameter `t` to zero in the full residual quotient. The
central slice then has both peripheral holonomies trivial: alpha is
prescribed and beta bounds in the outside face. The marking therefore
implies `D(M) in (I,t)`.

The remainder `R=ell(G)-b` has degree at least three in the matrix
entries of `D`; its internal derivative has degree at least two
in those entries. Since `t^2=0`,

    t R(M) in t I^3,       t (partial_h R)(M) in t I^2.

This is an actual ideal estimate for a complete Noetherian ring:
the relevant finitely generated ideals are closed. It does not
assume that matrix entries commute as matrices; only their scalar
coefficients commute. Differentiating a matrix word deletes one
factor and does not change the stated scalar-ideal order.

Put `J=(t_e : e plus at v)`. After replacement the value belongs
to `J I^2`; the gradient is still a matrix against the **same**
residual list, with its chosen minor changed by a `J`-multiple.
That minor remains a unit because `J` is nilpotent.

For completeness, here is the full-parameter correction, independently
of the manuscript's wrong lemma number. An error in `J^q I^2` is
`sum c_ab r_a r_b` with `c_ab in J^q`. The inverse gradient minor
gives a displacement in `J^q I` canceling its linear Taylor term.
The remainder is in `J^(2q) I^2`, and the gradient changes by
`J^q I`, so its coefficient matrix changes by a `J^q`-multiple.
The minor stays a unit. There is **no Hessian-vanishing hypothesis**
in this argument.

For `m` plus parameters, `J^(m+1)=0` by the pigeonhole principle
on products of generators with individual squares zero. Starting
with `q=1`, at most `ceil(log2(m+1))` Newton corrections suffice.
In this manuscript a vertex has twenty incident ports, so at most
five suffice, irrespective of the odd cover degree. This bound is a
direct universal nilpotent calculation, not extrapolation from tests.
With no plus ends, there is no replacement or correction.

The final section agrees with the previous one modulo `I`. Consequently
all the mixed-entry memberships in E survive. Each weight `b_j` is
a polynomial with no constant term in the entries of `G_j-1`, so
these memberships imply exactly `for:mixed-membership` in the full
individual-square ring. Every correction vanishes at `t=0`, retaining
the central tangents.

Finally choose a projection invertible on the central tangent of a
section. Its Jacobian remains a unit over `T[[y]]`, and its constant
displacement lies in the nilpotent ideal `J`. Formal substitution
with such a constant is a finite expansion in the nilpotent part;
the formal inverse theorem therefore puts the section into smooth
graph form. The inverse substitution transports the memberships.
Common central edge coordinate changes preserve the tangent difference
isomorphism.

This proves the claimed assembly **from the imported scheme-theoretic
single-cut and marked-algebraicity statements**. It does not discharge
their independent mathematical verification.

## Certificate interpretation and unresolved obligation

`verify.py` and `exact_certificate.json` distinguish exact symbolic
identities from the conditional argument above. The universal core in
`Main.lean` has a real Lean 4.31.0 compiler result with exit code zero
and no proof holes, archived by the official verifier and attached to
`C320_FORMAL_CORE`. Its separate `statement_fidelity.md` identifies
exactly the hypotheses that the compiler did and did not check.
The standalone script also checks that the current source, fidelity
document, and claim version match that successful compiler record.
This certifies the actual-ideal algebraic declarations, not the
imported MT inputs or the full four-manifold assertion.

The Jacobian adapter's
typed result is only the exact check that `t1*t2` survives modulo
`(t1^2,t2^2)`; it is not evidence for existence or nonexistence of a
filling. Its protocol, server version, exact request, runtime, and
typed outcome are preserved in `jacobian_output.json`.

No finite search bounds a conjecture here. No geometrically admissible
counterexample has been constructed. In particular an arbitrary
polynomial model with a bad residual ideal would not refute
`for:vertex-identities` unless realized by the stated marked cuts.

The live objective still requires either such a counterexample or an
independently accepted verification discharging the remaining inputs.
Their correctness cannot be inferred merely from their availability,
from the smooth two-vertex prototype, or from the compiling algebraic
core. The independent Reviewer must confirm the literal citation
refutation separately; a corrected citation by itself does not meet
the publishable completion gate.
