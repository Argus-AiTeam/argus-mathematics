# Three-direction sequential compactness

Write \(P=\mathbb R\times\mathbb R\), with
\(\|(u,v)\|_\infty=\max(|u|,|v|)\). Let
\[
 [x,y]_t=(1-t)x+ty,\qquad 0\leq t\leq1.
\]
The three line families are the level sets of
\[
 c_h(u,v)=v,\quad c_v(u,v)=u,\quad c_d(u,v)=u-v.
\]

## Exact theorem

`ThreeDirection.sequential_compactness_of_moving` proves the following.
Suppose \(F_n:P\to P\) are continuous, \(H\geq0\) is fixed,
\(F_n(0)=0\), and \(\|F_n(1,0)\|_\infty=1\). Suppose
\[
 \|F_n([x,y]_t)-F_n(x)\|_\infty
 \leq H\|F_n(y)-F_n(x)\|_\infty
\]
on every horizontal, vertical, and slope-one segment. Suppose also, for
each \(c\in\{c_h,c_v,c_d\}\), that for every strictly increasing
\(s:\mathbb N\to\mathbb N\), every two moving source sequences \(x_n,y_n\)
with \(c(x_n)=c(y_n)\), and every two finite image limits
\[
 F_{s(n)}(x_n)\longrightarrow a,\qquad
 F_{s(n)}(y_n)\longrightarrow b,
\]
one has \(c(a)=c(b)\). The common source line may depend on \(n\), and
there is no bound on the source sequences.

Then for every strictly increasing \(s\) there are a strictly increasing
\(r\) and \(\sigma\in\{-1,1\}\) such that
\[
 F_{s(r(n))}\longrightarrow \sigma\,\mathrm{id}_P
 \quad\text{locally uniformly on }P.
\]
Here locally uniform convergence is Mathlib's
`TendstoLocallyUniformly`, and therefore implies uniform convergence on
every compact subset.

The anchored strengthening `ThreeDirection.anchored_convergence_of_moving`
replaces the unit normalization by
\(F_n(1,0)\to(\sigma,0)\) and proves full-sequence locally uniform
convergence to \(\sigma\,\mathrm{id}\), for any real \(\sigma\), including
zero. The corresponding bounded-image formulations are
`ThreeDirection.sequential_compactness` and
`ThreeDirection.anchored_convergence`.

No injectivity, homeomorphism property, equicontinuity, local image
bound, finite-stage exact line preservation, or pointwise convergence
is a hypothesis.

## The moving-limit hypothesis and uniform defects are equivalent

`ThreeDirection.movingDirections_iff_vanishingDefect` proves the exact
equivalence with the following condition: for every \(R,\varepsilon>0\),
eventually in \(n\), all source pairs with
\(\|F_n(x)\|_\infty,\|F_n(y)\|_\infty\leq R\) satisfy
\[
 c(x)=c(y)\ \Longrightarrow\
 |c(F_n(y))-c(F_n(x))|\leq\varepsilon
\]
for all three functionals \(c\), with one common eventual threshold.
The functionals need not be normalized: normalizing \(c_d\) by a fixed
nonzero factor gives the same vanishing condition.

The more general theorem
`ThreeDirection.movingDirection_iff_uniformDirection` proves this
equivalence for any continuous \(c:P\to\mathbb R\). In one direction,
convergent image sequences are eventually bounded, so the uniform
defect tends to zero. Conversely, failure at fixed \(R,\varepsilon\)
selects strictly increasing bad indices and bounded bad image pairs.
Compactness of the product of two closed image balls provides a
further subsequence on which both images converge. The moving-limit
condition makes the limiting defect zero, contradicting its lower
bound \(\varepsilon>0\). This equivalence does not require continuity
of \(F_n\).

## Finite-radius triangle bootstrap

Call \(x\) bounded if \(\|F_n(x)\|_\infty\) is eventually bounded.
This is the predicate `ThreeDirection.EventuallyBounded`; it is a
derived predicate, not an extra assumption. Bounded turning gives
\[
 \|F_n([x,y]_t)\|_\infty\leq (1+2H)B
\]
whenever both endpoint image norms are at most \(B\).

Suppose \(x\) and \(x+(a,0)\) are bounded, where \(a\) may have either
sign. Choose an eventual common image bound \(B\geq0\), and put
\[
 C=(1+2H)B,\qquad R=C+2B+3.
\]
Eventually the image defect on the radius-\(R\) ball is at most one.
If the diagonal endpoint \(x+(a,a)\) had image norm larger than \(R\),
continuity would supply a parameter \(t\in[0,1]\) with
\[
 p=x+(ta,ta),\qquad \|F_n(p)\|_\infty=R.
\]
The comparison point \(q=x+(ta,0)\) has image norm at most \(C\).
The vertical pair \(q,p\) controls the first image coordinate to within
one, while the diagonal pair \(x,p\) controls the difference of the
two image coordinates to within one. Consequently
\[
 \|F_n(p)\|_\infty\leq C+2B+2<R,
\]
a contradiction. Thus the diagonal endpoint is bounded. Exchanging
the axes proves the same statement from a bounded vertical edge.

Given a bounded diagonal edge, compare an axis exit point to the
corresponding point on the bounded diagonal segment. Horizontal and
vertical defects separately control its two image coordinates. With
the same \(C\), the choice \(R=C+B+3\) contradicts the bound
\(C+B+2\). Both other corners are therefore bounded.

These are the signed completion theorems
`ThreeDirection.complete_horizontal` and
`ThreeDirection.complete_vertical`. A radius-attaining point from the
intermediate value theorem suffices; no first-exit uniqueness is used.

## Propagation to all bounded source regions

Starting with bounded \(0,(r,0)\), complete the horizontal square and
then the vertical square based at \((r,0)\). This yields bounded
\((2r,0)\). Completing the reversed horizontal edge based at \((r,0)\)
and then a vertical edge based at zero gives bounded \((-r,0)\).
Interpolation between zero and \((2r,0)\) inductively bounds all
positive integer axis points; sign reversal and interpolation then
bound every real horizontal axis point.

For \(r>0\), complete the horizontal edge from \((-r,0)\) to \((r,0)\)
and its reverse. This bounds all four corners
\[
 (-r,-2r),\quad(r,-2r),\quad(-r,2r),\quad(r,2r).
\]
Two successive bounded-turning estimates bound the whole rectangle.
Taking \(r=|M|+1\) bounds every source point with
\(\|p\|_\infty\leq M\), uniformly and eventually in \(n\).
This is `ThreeDirection.eventually_bounded_on_ball`.

## Compactness and scalar rigidity

For the anchored theorem, all fixed source points are now eventually
bounded. Each finite initial exceptional sequence can also be bounded,
giving numbers \(C(p)\) with
\(\|F_n(p)\|_\infty\leq C(p)\) for every \(n\).
Tychonoff's theorem makes
\[
 \prod_{p\in P}\overline B(0,C(p))
\]
compact in the pointwise topology. Every cluster map inherits exact
preservation of the three line families from the vanishing defects,
inherits bounded turning by passing inequalities to the limit, and
satisfies the two anchored values.

Exact horizontal and vertical preservation imply
\(f(x,y)=(g(x),h(y))\). Diagonals through zero give \(g=h\), and the
diagonal from \((x,0)\) to \((x+y,y)\) gives
\(g(x+y)=g(x)+g(y)\). Bounded turning along the anchored unit segment
bounds \(g\) on \([0,1]\), hence by oddness on a neighborhood of zero.
A bounded additive real map is continuous and therefore real-linear.
Thus \(g(t)=\sigma t\) and \(f=\sigma\,\mathrm{id}\).
This is `ThreeDirection.exact_rigidity`.

All cluster maps coincide, so compactness implies full pointwise
convergence, proved in `ThreeDirection.pointwise_convergence`.
The proof uses compactness of the full product rather than a
countable-grid diagonal argument; no sequential compactness of an
uncountable product is asserted.

## Upgrade to locally uniform convergence

Fix \(p\) and an arbitrarily small \(\delta>0\). Pointwise convergence
at the four corners of the square \(p+[-\delta,\delta]^2\) eventually
gives
\[
 \|F_n(q)-\sigma p\|_\infty\leq (|\sigma|+1)\delta
\]
at those corners. Apply the two-interpolation rectangle estimate to
the translated target maps \(F_n-\sigma p\). Throughout the square,
\[
 \|F_n(y)-\sigma p\|_\infty
 \leq (1+2H)^2(|\sigma|+1)\delta.
\]
Since \(\|\sigma y-\sigma p\|_\infty\leq|\sigma|\delta\), taking
\(\delta\) sufficiently small proves uniform error below any prescribed
\(\varepsilon>0\) on a neighborhood of \(p\). This proves
`ThreeDirection.locallyUniform_of_pointwise` and completes the
anchored theorem without assuming equicontinuity.

Finally extract a convergent subsequence of the unit-norm anchor
images. The horizontal direction condition and \(F_n(0)=0\) make its
second limiting coordinate zero. Its limiting norm remains one,
so its first limiting coordinate is \(1\) or \(-1\). Apply the anchored
theorem to this further subsequence.
