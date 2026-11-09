# C55_BLOCKS: support, finite refinement, and a slicing

**Engineer assessment: `conditionally_supported_written_proof`.** The
support constant `30000000` survives the full-coordinate calculation.
The subsequent filtration, endpoint, and local-finiteness arguments use
actual bounded aisles and a full discrete numerical lattice; they are not
consequences of compiler success.

## Exact claim, hypotheses, source, and attribution

Use the actual refined aisles `V_k^eta` from the preceding unit and put

```text
V_k=V_k^0, H_k=V_k intersect V_(k+5)^perp,
S_k=V_k intersect V_(k+1)^perp.
```

The claim is that nonzero block objects have charge in the closed sector
`[k/5,(k+1)/5]`, with both the coordinate `l1` and Euclidean inequalities
`norm([E])<=30000000*abs(Z(E))`; finite block filtrations and refinements
produce a Gepner-equivariant slicing; both endpoint conventions give the
stated hearts; and every finite phase interval of width less than one is
quasi-abelian of finite length, for all four endpoint choices.

This is historical C55_BLOCKS v1, old Gepner report sections 7--9, with
reference `grid.tex` from `lem:block-filtrations` through
`prop:local-finiteness`, and `numerical.tex` for the full lattice, at
revision `4eaee87548250b2682affda7d05d947c05554bae`.
The supplied manuscript already contains the qualitative construction
and an existential support constant. The old draft proposes an explicit
constant; this review verifies that comparison, not external novelty.

Besides actual refined nesting, the proof assumes categorical
`Phi^5=[2]`, the normalized eigencharge, the earlier positivity and
zero-class exclusion, and the stated standard geometry. Weak Lefschetz,
integral Chern classes, and HRR identify the full numerical group with a
rank-four lattice in `Z x Z x (1/10)Z x (1/30)Z`. The exact checks
`det(J)=625` and determinant one for the four line-bundle vectors confirm
the linear algebra, not the external geometric theorems. In particular,
a nonzero numerical class has Euclidean norm at least `1/30`.

## Full support calculation

An object of `S_k` lies in `H_k` and `H_(k+1)[-1]`. Their correctly
oriented imaginary-part tests intersect in the closed sector of angular
width `pi/5`, together with zero.

Take the **closed** square `abs(eta_j)<=rho=1/1000000`, strictly inside
the open refinement square. Independent nesting gives
`V_k subset V_(k-1)^eta` and
`V_(k-1)^eta[1]=V_(k+4)^eta subset V_(k+1)`.
Thus the same actual block object is in all these preceding hearts.
For `k-1=2m+5j`, put `F=Phi^-m E[-j]`, `w=[F]`,
`X=abs(r(w))+abs(c(w))`, `N=d(w)+c(w)/2+uG*r(w)`,
and `Q=abs(Z(E))=abs(Z(F))`. Four corner tests imply

```text
X <= 1000000*N,       0 <= N <= (2/5)*Q.
```

The second bound uses `Im Z(F)=5*t0*N` and `t0>1/2`.
The exact real charge is
`Re Z/5=-uG*r/2-(uG+1/12)c-d/2-e`. Since `uG<7/25`,

```text
D=abs(d(w)) <= N+X/2,
Eabs=abs(e(w)) <= Q/5+X/2+D/2,
norm(w)_1 <= (9/4)X+(3/2)N+Q/5
          <= (4500004/5)Q < 1000000 Q.
```

Choosing `m` in `{0,1,2,3,4}` leaves only a harmless sign from `j`.
The exact `l1` operator norms of `M^m` are
`1,55/6,68/3,82/3,38/3`. Hence
`norm([E])_1 <= (82/3)*1000000*Q < 30000000*Q`,
and the Euclidean norm is no larger. If `Q=0`, the coordinate bounds
give `w=0`; zero-class exclusion in the actual heart gives `E=0`.
This last inference is not an assertion about arbitrary real vectors.
The preserved checker replays every numerical constant used here.

## Finite block filtrations and within-block HN

Boundedness puts each object in `V_l intersect V_h^perp` for some `l<h`.
Truncation at `V_(l+1)` removes one factor in `S_l`; the remaining
object remains orthogonal to `V_h` because
`Hom(V_h,B[-1])=Hom(V_h[1],B)=0`.
After at most `h-l` steps the remainder is zero.
This proves finite block filtration before any within-block HN assertion.

In `H_k`, the resulting torsion pair has
`T_k=<S_(k+4),...,S_(k+1)>`, `F_k=S_k`. Thus block objects are closed
under ambient subobjects. A saturated subobject has quotient also in `S_k`.
For the positive sector projection `q_k`,
support and the full lattice give `q_k(Z(E))>=1/(60*C)` on a nonzero
block object, where `C=30000000`. For saturated `F subset E`,
`norm([F])<=2*C*q_k(Z(E))`; finitely many full lattice classes are
possible. This, not discreteness of `Z(Knum)`, gives a largest phase
and, among equal phases, a largest magnitude.

The maximal subobject is block-semistable. A higher-phase saturated
subobject of its quotient would have a preimage contradicting maximal
phase; an equal-phase one contradicts maximal magnitude. The positive
additive lower bound forces this iteration to terminate.

The unsaturated test keeps the boundary that matters. An alleged
destabilizing subobject has phase `g>a=k/5`. Saturating it adds
`T_k` factors with phases in `[b,a+1]`, `b=(k+1)/5`.
Their sum with its charge lies in `[g,a+1]`, of width strictly less
than one, so is nonzero with phase at least `g`. This contradicts
saturated semistability. The strict `g>a` is what rules out antipodal
cancellation; it is not an omitted endpoint. Images and saturated
kernels now prove same-block Hom vanishing, while nesting supplies
between-block Hom vanishing.

## Slicing, endpoints, and local finiteness

Take finite extension closure of the block-semistables on each phase ray,
using **both adjacent blocks** at a shared endpoint. Splicing the finite
filtrations gives weakly decreasing phases; merging adjacent equal phases
gives strictly decreasing HN factors. `[1]` and `Phi` transport blocks,
saturated subobjects and semistability by phase `1` and `2/5`.
Support extends to a same-ray extension because the charge magnitudes add.

Both cuts `(P(>c),P(<=c))` and `(P(>=c),P(<c))` are orthogonal with
decomposition triangles and the needed shift closure. Applying Hom to
such a triangle shows the components are mutual orthogonals, not merely
orthogonal subcategories. Hence they are summand-closed bounded
t-structures, with hearts `P((c,c+1])` and `P([c,c+1))`.
A decreasing nonempty grouped filtration cannot have zero total object:
its first factor's identity survives because
`Hom(first,later[-1])=0`. This justifies interval intersections and
summand closure without an illicit cancellation argument.

For an interval `I` with endpoints `a<=b`, `b-a<1`, choose the appropriate
one of those two hearts at its lower endpoint. Cutting at the upper
endpoint makes `P(I)` a torsion-free class in that abelian heart.
For `f:A->B`, with ambient kernel `K`, image `J`, cokernel `Q`,
and torsion part `t(Q)`, the internal kernel is `K`, cokernel `Q/t(Q)`,
coimage `J`, and image the preimage of `t(Q)` in `B`.
Strict monomorphisms are ambient monomorphisms with torsion-free
cokernel; strict epimorphisms are ambient epimorphisms between these
objects. Extension closure preserves the relevant pushouts and
subobject closure preserves pullbacks, proving quasi-abelianity.

Finally the midpoint projection on `I` is at least
`cos(pi*(b-a)/2)/(30*C)>0` for every nonzero semistable, and hence for
every nonzero interval object. Strict exact sequences are ambient
short exact sequences here, so the projection is additive.
Every nonzero strict factor consumes that fixed amount; both strict
chain lengths in a fixed object are bounded. This proves finite length
and local finiteness without assuming a discrete charge image.

No unresolved internal mathematical gap was identified under the stated
premises. The critical certification boundary is that the full lattice,
actual refined aisles, all categorical filtrations, and endpoint cuts
are prose/geometric inputs, not Lean output. The conditional conclusion
awaits the native Host Reviewer and cannot independently establish its
own antecedent aisle/refinement claims.
