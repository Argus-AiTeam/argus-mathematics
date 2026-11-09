# A reconstruction of the uniform cubical cutoff

## Result and scope

The two assertions audited here are `hp:immersed-skeleton` and `hp:cutoff`
in the high-exponent manuscript, `build/sections/05-high-preparation.tex`,
lines 937-1365. The reconstruction below proves their quantitative core,
including the fixed image, the fibre description and the stated relative
opening. It finds no false assertion in this dependency cone.

The important constants are fixed by a finite collection of smooth
reference maps **before** the input homeomorphism or the scale is used.
Neither an explicit numerical value for these constants nor global
injectivity of the sampling immersion is required. In particular, a
finite collection of numerical energy ratios could not settle this
question.

This is a mathematical proof using the classical topological results
specified below. `verify.py` checks exact algebra and an all-depth
induction used by the proof. `Main.lean` formalizes only the declarations
listed in `statement_fidelity.md`. Neither program checks the topology
or the whole cutoff theorem. Independent Reviewer acceptance and a
novelty/significance assessment are separate from this reconstruction.
Neither manuscript's main approximation theorem follows from this local
verification alone.

Use the Euclidean vector norm, the operator norm for chart bounds and
the Frobenius norm for Sobolev derivatives. Write

    B = [-1,1]^3,  t(x) = max_j |x_j|-1,  B_r = {t<r}.

Here and below `s>0` is a sufficiently small dyadic number. There exist
absolute `C>2,c>0` such that, if `h` is a homeomorphism on a neighborhood
of `closure(B_Cs)`, belongs to `W^{1,p}_loc`, `1<=p<infinity`, and
`|h(x)-x|<=cs` for `|t(x)|<=Cs`, there is a continuous Sobolev replacement
`F` on `B_2s` with

    F = Id on B;  F = h near boundary(B_2s);
    F(B_2s) = h(B_2s);
    integral_{0<t<2s} |DF|^p <= C_p integral_{|t|<=Cs} |Dh|^p.

Its only nonsingleton fibres are a countable null family of tame closed
balls; their target values accumulate only on `boundary(B)`. They admit
the relative topological opening described in Section 7. If `h` has
volume Lusin property N, so does `F`.

## 1. Exactly which literature results are used

Hirsch, *Immersions of manifolds*, Trans. AMS 93 (1959), 242-276,
DOI `10.1090/S0002-9947-1959-0119214-4`, Theorem 5.7, p.265, has
standing assumptions on p.264: `dim M=k<dim N=n`, `N` is boundaryless,
and `M` has a smooth triangulation. An actual `M`-immersion on a
subcomplex `K` extends over a subcomplex `L` when its equivariant tangent
frame map extends. The resulting immersion equals the prescribed one
on `K`, with differential homotopic to the formal extension relative
`K`. Section 3, pp.252-253, defines an `M`-immersion using an actual
immersion on a neighborhood of the prescribed subset.

In the applications here `M=L` is an interval or a planar disk, `K`
contains closed positive-width end collars or a boundary annulus, and
`N` is an **open** three-ball. Thus `k=1` or `2`, strictly less than `3`.
An adapted finite smooth triangulation makes `K` a subcomplex. A bundle
monomorphism over a continuous base map is precisely the required
equivariant frame map. On `K` it is the actual differential. Choosing
only `K=boundary(M)` would not be enough to claim exact agreement on a
collar; that shortcut is not used.

Brown, *A proof of the generalized Schoenflies theorem*, Bull. AMS 66
(1960), 74-76, DOI `10.1090/S0002-9904-1960-10400-4`, Theorem 5, p.76,
says that an embedding of `S^{n-1} x [0,1]` in `S^n` makes the closures
of both complementary domains of its middle sphere into `n`-cells.
Here an actual two-sided collar supplies that product embedding, and
`R^3` is compactified to `S^3`. No assertion about a wild sphere or
Sobolev energy of a ball filling is inferred.

Separation and openness use Hatcher, *Algebraic Topology* (2002),
ISBN `9780521795401`, Proposition 2B.1(b) and Theorem 2B.3, Section 2.B,
pp.170-172. They give the two complementary components of an embedded
sphere and invariance of domain. The specified boundary parametrization
of a Brown ball extends by the explicit coning argument in Section 5.

The primary PDFs, readable extracts and normalized proposition excerpts
are in `research/literature/`. The source-reader's examination of Hirsch
and Brown was not an independent campaign review. All three literature
dependencies remain available for independent attribution in the ledger.

## 2. A compatible finite reference atlas

### The source triangulation

Let `lambda_k=2^(-k)s`, `k>=0`. Tile
`{lambda_k<t<2lambda_k}` by axis-aligned cubes of side `lambda_k`.
The coordinates `1`, `s` and `lambda_k` are dyadic, so their boundary
planes align. Neighbor sizes have ratio at most two. Subdivide interface
faces to match their finer neighbors, use the same subdivision on both
sides, triangulate those faces, and cone to cube centers. On remaining
faces insert all incident edge subdivision points before coning to a
face center. On a coarse/fine interface use the finer-face
triangulations instead. This determines a conforming triangulation.

Only finitely many relative positions and subdivision patterns occur;
each resulting tetrahedron is nondegenerate. Their minimum normalized
volume is therefore a number `v>0`. With scale label
`ell_D=lambda_k`, all tetrahedra satisfy

    volume(D)>=v lambda_k^3,  diam(D)<=d lambda_k,
    D subset {0<t<b lambda_k},  lambda_k<=rho(x)<=2lambda_k,

where `rho=min(s,t)` and one may use `b=d=2`. At an interface the
finitely many incident scale labels remain comparable. Local finiteness
holds inside the open shell. Reserve a fixed-width outer subband of
the `k=0` layer for the identity.

### Vertex and edge data

At a vertex choose a representative incident scale by a fixed rule and
an anchor on the nearest `s`-grid, resolving ties by a fixed rule.
Prescribe the positive scalar affine map with derivative `s/ell_v`.
On the reserved outer band prescribe the identity. Its normalized
scale ratios belong to a finite set. The source vertices there are on
a fixed rational subdivision of the `s`-grid.

Normalize source coordinates by an incident scale and target
coordinates by `s`, translating the target by the first anchor.
Endpoint anchor differences are bounded integer vectors, incident
scale ratios form a finite set, and source configurations form a finite
set. Hence the edge data, including their end collars, form a finite
set. An arbitrary smooth base curve connecting the prescribed end
germs stays in a fixed open ball. The positive scalar end derivatives
extend as a nonzero formal tangent field parallel to the source edge.
Hirsch 5.7 supplies a regular curve in that ball, exactly fixed on the
retained end collars, whose tangent is homotopic to that formal field
relative those collars.

Here is an elementary way to lift this tangent homotopy to a full
positive frame homotopy. It avoids leaving a framing class implicit.
For nonzero `w` and `v dot w>0`, put

    T(v,w) = Id + (v-w) w^T/(w dot w).

Direct calculation gives

    T(v,w)w=v,     det T(v,w)=(v dot w)/(w dot w)>0.       (2.1)

A continuous nonzero tangent homotopy on a compact rectangle has a
finite subdivision of its homotopy parameter such that successive
tangent vectors have positive scalar product, uniformly along the
edge. On each subinterval use `T(v_current,v_start)` to transport the
previous full frame. Start with the scalar frame. Where the tangent
homotopy is fixed, transport is the identity. This produces a full
positive frame homotopy, fixed on the end collars. Smooth its final
transverse columns relative those collars; positivity is open, so a
sufficiently close smoothing preserves it and the homotopy class.

Thicken the regular curve using those transverse columns. On the end
collars the formula is exactly the prescribed affine germ. On a
sufficiently thin neighborhood its differential remains positive.
There are finitely many edge types; make these choices once for each
type. Reversal or relabeling of a shared edge refers to the same
chosen map, not a separately chosen extension.

### Face data and compatibility

For a face, take a rounded disk whose boundary annulus is inside the
already defined vertex/edge region. In fixed ambient source
coordinates the prescribed full derivative frame on the perimeter is
null-homotopic: each edge frame has the just-constructed homotopy to
positive scalar frames relative its endpoints, and the scalar vertex
frames contract within the positive scalar matrices. The rounded
annulus is homotopic to that perimeter inside the old region, so its
inner frame loop has the same null class.

Extend this full frame continuously over the disk, retaining the actual
frame on a smaller closed boundary annulus. Extend the base map into
a fixed open target ball by convex interpolation. Restrict the full
frame to the two fixed tangent directions of the planar face. This is
a formal immersion that equals the actual differential on the retained
annulus. Hirsch 5.7, with that annulus as `K`, supplies an immersed
disk into the ball equal to the old map there.

Choose a transverse column `nu`, positive relative to the oriented
tangent pair and equal to the old normal derivative on a smaller
annulus. Such a choice exists: over a fixed tangent pair the allowable
columns form a convex open half-space. Extend by interpolation with
the positive cross-product normal. The formula

    phi(u)+r nu(u)

has positive differential near `r=0`. On the matching annulus its
difference from the old three-dimensional formula vanishes to first
order in the normal variable: it is `O(r^2)` with differential
`O(|r|)`. A fixed cutoff in `u` blends the two formulas. Taking the
normal width small preserves the positive determinant and leaves the
old map exactly unchanged on a smaller retained neighborhood.

The source neighborhoods of distinct truncated face cores are
disjoint. Their only overlaps with the earlier construction are the
matching collars. Thus these are compatible maps on a joint open
neighborhood, not independent germs that are merely close to agreeing.

There are finitely many face data, since all previously chosen edge
maps came from finite lists. Choose their disk, normal, cutoff and
width data once per labeled face type. This completes the finite
reference atlas. Every map stays within a fixed normalized distance of
its anchor; the anchors are within `O(s)` of their source configurations.
Consequently `|i(x)-x|<=C_0 s`.

## 3. Uniform inverse margins and the lift

Take compact subneighborhoods strictly inside each of the finitely many
chosen normalized chart neighborhoods. Reduce their widths uniformly,
retaining a neighborhood of the entire skeleton. There are constants

    m>0, L>=1, M>=1, eta>0

such that the least singular value of every normalized derivative is
at least `m`, its norm is at most `L`, its second derivative is at most
`M`, and each smaller chart has distance at least `eta` to its larger
chart boundary. These are minima and maxima of finitely many compact
sets, not constants obtained separately for each `s`.

Choose `0<r<=min(eta/4,m/(4M),1/4)`. On a normalized ball of radius
`2r` around any point in the smaller neighborhood, the derivative
differs from its central value by at most `m/2`. Integrating along
segments gives

    |I(z)-I(z')| >= (m/2)|z-z'|.

It is injective there, and its image of the radius-`r` ball contains
the radius-`mr/2` ball about the central image. This last assertion
follows from openness and the boundary distance lower bound: a
segment starting at the central image cannot first leave the image
before meeting the image of the source boundary. Scaling back gives
source radii `r lambda`, target radii `(mr/2)s`, and

    ||Di|| <= L s/lambda,
    ||(Di)^(-1)|| <= lambda/(m s),
    ||D^2i|| <= M s/lambda^2.                            (3.1)

Use a sufficiently small absolute `c`; in particular take
`c<=mr/100`, `c<=m/100` and `c<=1/100`, and later reduce it for the fixed hole
and outer-band margins. Since `|h(i(x))-i(x)|<=cs`, the inverse
chart defines the near-`x` solution

    i(H(x))=h(i(x)),     |H(x)-x|<=(2c/m)lambda
                                   <=delta rho(x),     delta=2c/m. (3.2)

Increase `C` first so all these target charts lie in `|t|<Cs`.
The inverse-chart construction does not use a Sobolev estimate for `h`.
It uses only its stated uniform displacement.

On overlaps two candidate solutions lie in the same injectivity
ball after the fixed reductions of `c`; they solve the same equation
and therefore coincide. Thus `H` is a well-defined continuous local
homeomorphism. It is also globally injective on the smaller skeleton
neighborhood. If `H(x)=H(x')`, the 1-Lipschitz property of `rho` gives

    |x-x'| <= delta(rho(x)+rho(x'))
             <= delta(2rho(x)+|x-x'|),

so, for `delta<1/10`, the distance is at most `3delta rho(x)`.
The scales are comparable, and `rho(x)<=2lambda`. Our choice
`delta<=r/50` puts `x,x'` in the same radius-`r lambda` chart.
Injectivity of `h` in the lift equation gives `i(x)=i(x')`, and that
chart's injectivity gives `x=x'`. Near the outer boundary both the
points and their lifts stay in the identity band, so `H=h`.

The local weak chain rule is legitimate here: on a relatively compact
chart, pre- and postcomposition are by smooth diffeomorphisms with
bounded derivatives; approximating `h` by smooth maps proves the
usual weak chain formula. From (3.1) in this same chart,

    DH=Di(H)^(-1) Dh(i(x)) Di(x),
    |DH| <= (L/m)|Dh(i(x))|.                            (3.3)

The scale at `H(x)` need not be guessed from another simplex: both
derivatives in (3.3) are controlled inside the same normalized chart.
This is where a scale-dependent conjugation constant is excluded.

## 4. A quantitative overlap bound at every depth

Let `J` be a uniform finite bound for the number of injective chart
pieces covering the used part of one simplex. Such a bound follows
by finite subcovers of the finite compact reference configurations.
The determinant lower bound is

    |det Di| >= m^3 (s/lambda)^3.

Every used image lies in `B(x_D,As)`, where `x_D` is any chosen point
of `D` and `A` is a fixed constant. Change variables only in injective
chart pieces. For nonnegative measurable `g`,

    integral_{D used} g(i(x))
      <= J m^(-3)(lambda/s)^3
           integral_{B(x_D,As) intersect {|t|<=Cs}} g.   (4.1)

This inequality does not assume global injectivity of `i` or bound
its unweighted total multiplicity.

Fix `y` and one depth `lambda<=s`. If `y` belongs to the sampling ball
of a scale-`lambda` simplex, that simplex is contained in the ball of
radius `(A+d)s` about `y`. It also lies in `0<t<b lambda`.
This part of the cubical layer is covered by six coordinate slabs
of thickness `b lambda`; the two tangential projection lengths in
each slab are at most `2(A+d)s`. Thus its volume is at most

    6 (b lambda) [2(A+d)s]^2
      = 24 b (A+d)^2 s^2 lambda.

The simplex interiors are disjoint and each has volume at least
`v lambda^3`. Therefore the number of such simplices is at most

    K_pack(s/lambda)^2,   K_pack=24 b (A+d)^2/v.        (4.2)

The slab argument includes cube edges and corners; double counting
slabs only enlarges the upper bound.

Multiplying (4.2) by `(lambda/s)^3` and summing over
`lambda=2^(-k)s` gives a pointwise overlap bound `2 K_pack`, since

    (lambda/s)^3 (s/lambda)^2 = 2^(-k),
    sum_{k<N} 2^(-k) = 2-2^(1-N) <= 2                (4.3)

for every `N>=0`. The exact nonnegative tail tends to zero, so the
infinite sum is also `2`. This is not a bounded-depth experiment.
Integrating the pointwise bound, or applying Tonelli, proves (4.1)
summed over every simplex with constant `2J m^(-3)K_pack`.
Combining it with (3.3) gives

    integral_{lift region} |DH|^p
       <= 2J m^(-3)K_pack (L/m)^p
             integral_{|t|<=Cs} |Dh|^p.               (4.4)

In particular no factor depending on `s`, the number of dyadic
layers, the positions of anchors, or the input homeomorphism remains.

## 5. Filling holes without assigning them an energy bound

For each normalized simplex choose nested smooth convex homothetic
balls `V_D compactly_in V_D^+ compactly_in U_D compactly_in D`.
They can be chosen so close to the simplex that the complement of
`V_D`, and a two-sided collar of its boundary, lie in the lift region.
Indeed a small inner smoothing of a convex simplex, followed by
three sufficiently close homothetic factors, has this property.
Finitely many simplex shapes allow all margins to be chosen as fixed
positive multiples of `lambda`.

Reduce `c` against these margins. Equation (3.2) gives
`H(boundary V_D) subset V_D^+`. This sphere is bicollared: `H` is
an embedding on a two-sided source neighborhood. Brown's theorem
therefore makes its bounded complementary closure a topological
closed ball `K_D`. It lies in `V_D^+`, since the complement of that
convex ball is connected to infinity and misses the sphere.

The specified boundary map, not merely some parametrization, extends
to a homeomorphism `closure(V_D)->K_D`. To see this, choose arbitrary
ball parametrizations of source and target. Their boundary mismatch
is a homeomorphism `theta:S^2->S^2`. The map
`r u -> r theta(u)`, with `0->0`, is a ball homeomorphism with inverse
given by the analogous formula for `theta^(-1)`. Composing corrects
the boundary mismatch exactly. No regularity estimate for this map
has been asserted.

The retained shell with closed holes removed is connected: within
each simplex its outer collar connects to its faces, and the
two-skeleton connects these collars to the outer band. Its image
under `H` misses every boundary sphere by injectivity. For each
fixed `D` it has an outer-band point outside `V_D^+`, so the whole
connected image is on that sphere's exterior side. Distinct `K_D`
lie in distinct simplex interiors. The hole extensions consequently
fit together injectively with `H`.

Call the filled map `G` and extend it by the identity on `B`.
On the retained region `|G(x)-x|<=delta rho(x)`; within a hole,
source and image lie in the same simplex and differ by `O(lambda)`.
Thus `G(x)-x` tends to zero at the inner boundary. Retained points
stay outside `B` because their displacement is less than `t(x)/2`,
and filled points lie in `K_D subset D`, also outside `B`. This
proves continuity and injectivity on `closure(B_2s)`.

Compactness makes this map a homeomorphism onto its compact image.
Invariance of domain makes its interior image open; separation by
the boundary sphere identifies it as the bounded component. Since
its boundary values are `h`, that component is exactly `h(B_2s)`.
This also permits gluing `G` to `h` outside `B_2s`.

## 6. Collapse, the energy estimate, and the limiting seam

All `U_D` can be kept a fixed relative distance from the outer
boundary: this is a finite reference choice in the outer layer;
all deeper layers have an even larger outer-boundary margin.
The near-identity boundary values give
`B_{2s-cs} subset h(B_2s)` without requiring a degree calculation.
Indeed `t(h(z))>=(2-c)s` for `z` on the outer boundary, so this
smaller connected cube misses `h(boundary B_2s)`. It contains
`h(1,0,0)`, since `t(h(1,0,0))<=cs<(2-c)s`. That point belongs
to the bounded complementary component `h(B_2s)`, so the whole
smaller cube belongs to that component. Further reduce `c` so every `U_D` lies in
this smaller cube. Thus all collapse supports are in the fixed
image and a whole outer band is untouched.

Use the smooth convex gauge of `U_D`, with radial coordinate `r`
normalized to equal `1` on its boundary. The inner buffer has
radius `a`, and choose `a<b<1`. Define

    psi(r)=0                          for 0<=r<=a,
    psi(r)=b(r-a)/(b-a)                for a<=r<=b,
    psi(r)=r                          for b<=r.

The resulting radial map `Q_D` collapses `closure(V_D^+)` to its
center, is identity near `boundary U_D`, maps `U_D` onto itself,
and is a homeomorphism off the collapsed ball onto the punctured
`U_D`. It is Lipschitz: the radial slope is bounded and
`0<=psi(r)/r<=1`; the convex gauges have uniformly bounded aspect
ratios. All radii and shapes come from finite reference lists.
Let `P>=1` bound these Lipschitz constants.

The `U_D` are disjoint. Defining `Q=Q_D` there and `Id` elsewhere
is globally `P`-Lipschitz. For two points in different supports,
use the exit and entry points of their joining segment; at those
points `Q=Id`, and the intermediate segment needs no modification.
The same argument covers a point outside the supports. There is
no assumption that a segment meets only finitely many supports.
Set `F=Q composed with G`.

On every filled hole `F` is constant, since `K_D subset V_D^+`.
It is constant also on a two-sided neighborhood of the hole boundary,
by compactness and continuity of `H` there. Elsewhere it is `QH`.
The Lipschitz composition rule (equivalently, composition on absolutely
continuous coordinate lines) gives `|DF|<=P|DH|` there. Finite local
gluing is valid at each hole boundary and simplex face, so (4.4) gives

    C_p = 2 J K_pack m^(-3) (P L/m)^p.                 (6.1)

All symbols in (6.1) are constants of the fixed reference construction
and `p`, not `h` or `s`. Every collapse maps its support onto itself,
so `F(B_2s)=h(B_2s)`. The supports avoid `B` and the outer band, giving
the two exact agreement assertions. More explicitly, narrow the source
outer band and take `c` below one quarter of the output free-band width
in units of `s`. The displacement of `h` then keeps the image of that
source band inside the band where `Q=Id`, so `Qh=h` there.

There is no hidden derivative concentrated at `boundary B`.
The shell energy is finite. For almost every coordinate line,
Fubini gives an integrable derivative on each shell interval, and
the restriction is locally absolutely continuous there. Integrating
that derivative and using the continuous endpoint value extends
absolute continuity to the endpoint. Apart from the null family of
lines contained in a cube face, there are only finitely many
intersections with the inner and outer cube boundaries. The identity
inside and the unchanged map outside therefore glue absolutely
continuously along almost every line. This proves the claimed weak
Sobolev regularity, including `p=1`.

## 7. Fibres, relative opening and property N

Let `a_D` be the collapse center. Since `G` is a homeomorphism,

    F^(-1)(a_D)=G^(-1)(closure(V_D^+)).

It is a tame closed ball: its boundary has a two-sided collar obtained
from the convex sphere by `G^(-1)`. All other fibres are singletons.
There are finitely many simplices at each depth and only finitely
many away from `boundary B`, so the exceptional values are countable
and accumulate only there.

For completeness, a point outside the filled holes with
`G(x) in V_D^+` satisfies
`|x-G(x)|<=delta rho(x)` and
`|t(x)-t(G(x))|<=delta rho(x)`. Hence its scale is comparable to
`lambda_D` and it is within `O(lambda_D)` of `D`. A point in a filled
hole mapping there must belong to hole `D`, because the other hole
images lie in their own disjoint simplices. Thus the entire displayed
fibre has diameter `O(lambda_D)`. This proves the required null-size
assertion, not merely null size of the output buffers.

Take any mutually disjoint neighborhoods of the values `a_D` within
their supports and shrink centered convex radial balls into them.
For one such radius `epsilon`, choose `r_0>a` with
`psi(r_0)=epsilon/2`. Replace `psi` on `[0,r_0]` by
`r psi(r_0)/r_0` and leave it unchanged above `r_0`.
This is continuous and strictly increasing, agrees with the old map
on a neighborhood of the boundary of `Q_D^(-1)(W_D)`, and differs
only inside that preimage. It is a homeomorphism on `U_D`.
Perform this in every support and compose with `G`. Both the new
map and its inverse are continuous at the accumulating inner boundary
because they preserve each shrinking `U_D` setwise. This yields exactly
the relative topological opening, changing `F` only on
`F^(-1)(union W_D)`. No Sobolev or energy claim is made for it.

Finally suppose `h` has property N. On the lift region its local
expression is `i^(-1) h i` in smooth diffeomorphic charts; charts
and inverse charts are locally Lipschitz, so this expression preserves
null sets. Lipschitz postcomposition by `Q` preserves this property.
Hole neighborhoods map to countably many points, `B` maps identically,
and the inner boundary has zero volume and maps to itself. A countable
chart cover proves property N for `F`.

## 8. Dependency impact and the remaining task

The earlier campaign state contained only the undecomposed audit goal.
This reconstruction separates compatible finite templates, their inverse
margins, the small global lift, geometric packing, the exact dyadic
sum, image-preserving filling/collapse, and the limiting Sobolev seam.
It supplies a proof of this whole local core rather than a conditional
estimate assuming unspecified uniform charts.

There is no refutation judgement to file: no false manuscript assertion
was identified here. The topological opening still supplies no energy
bound, exactly as the manuscript states. In particular this work must
not be used as approval of later applications to carrier fibres,
smooth openings, rank-deficient data, wall realization, assembly, or
either main approximation theorem. Those remain open graph nodes.
The next mathematical gate is independent reading of this proof,
attribution of the three cited propositions, and replay of the exact
and Lean evidence.

## 9. Reproduction

The exact replay uses Python 3 and SymPy (the available interpreter has
SymPy 1.14.0):

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/cubical_cutoff/verify.py
```

The real compiler command, run from the campaign root, is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/cubical_cutoff/Main.lean --statement-fidelity research/cubical_cutoff/statement_fidelity.md --claim C_EXACT_ALGEBRA --project-root .
```

Use the host's durable runner for a potentially long compile. The
source and fidelity document must remain unchanged during `verify`.
A successful algebra replay or compiler run does not replace reading
the geometric and topological proof above.
