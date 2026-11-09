# Center-independent coordinate-flat density extension

**Assessment:** the extension has a substantive written sufficiency argument, not just grid examples or an algebraic certificate. Its weight quantifiers and descending-flat proof are consistent with the claimed scope. The strict overcrowding obstruction is separately justified; equality and novelty remain unclaimed.

## Precise proposed strengthening

Old claim `C_K1_FLAT_DENSITY` occurs in A01, A04 sections 1 and 5, and A05. It is an Argus proposed strengthening of the OpenAI interpolation theorem, not an assertion made in that original theorem. The reference manuscript version is `4eaee87548250b2682affda7d05d947c05554bae`, September 24, 2026. The strongest relevant old statement is already this extension; the present work assesses it rather than claiming a new improvement.

Fix `m,K>=1`, positive rational `w0,v0,theta`, `0<theta<1`, and

    K (w0/v0) theta^m < 1.

For every nonempty `T` contained in `{1,...,m}`, fix an integer `nT>=1` with `nT theta^|T|<1`. There are successive thresholds for positive rational weights `w1,...,wm`, depending on these data and preceding weights **but not on centers**, such that the logarithmic weighted packet map is eventually surjective at any `K` distinct centers `(bj,cj)`, `bj!=0`, satisfying:

    Every flat Y=b, Xi=di (i outside T), b!=0,
    contains at most nT centers.

Here packet substitution is `Y=bj(1+t)`, `Xi=cji+ui+log(1+t)`, and the source/target cutoffs remain `deg_W P<=H` and `V.alpha<H`. Eventuality means every sufficiently large multiple of an integer depending only on weights; the final size threshold may depend on centers.

Conversely, if any such `d`-dimensional flat contains `n` centers with `n theta^d>1`, surjectivity fails for every sufficiently large `H`, for **any** positive coordinate weights. There is no conclusion at `n theta^d=1` or equality of the ambient volume ratio.

## Why the weights really are center-independent

The finitely many strict density inequalities and the ambient inequality permit a rational `sigma>0` such that

    (1+3sigma)^(m+1) K(w0/v0)theta^m < 1,
    (1+3sigma)^|T| nT theta^|T| < 1 for every nonempty T.

This is chosen before any center coordinates. Then fix `L0=m+2` and its multiplicity constant and impose the same complete oriented basis-product separations as in the original proof.

For a largest differing positive index `i` on the degree side, the separation ratio is `wi` times a positive expression in earlier weights and fixed data. Common higher indices contribute `wj/vj=theta`, so they introduce no future weight dependence. There are finitely many inequalities. Choosing `wi` above their finite maximum at each step proves the uniform successive choice; it is not inferred from the particular numerical weights in A05.

The report's universal choice `nT=ceil(theta^(-|T|))-1` is the largest integer strictly below `theta^(-|T|)`. It is positive because `theta<1`. Any integer occupancy satisfying the strict density inequality is no larger than this value, so thresholds can be chosen without inspecting either the centers or a more restrictive occupancy array.

## Sufficiency and the center-collision issue

Assume a violating curve with positive total contact. The ambient coefficient count uses the total `K(w0/v0)theta^m` slack. The same local frame holds for every nonzero `bj`, since `D0` becomes `(1+t)partial_t` in `t=Y/bj-1`. Persistence and the normal-basis/residue argument first force the curve into a constant nonzero-Y fiber.

Suppose the curve lies in a coordinate flat with free set `T`. Only centers on that flat can lie on the curve. Fixed coordinates have no poles and, after subtracting a center on the flat, infinite order; hence the original `D,S` equal the quantities in the free coordinates. The count in `|T|` variables uses at most `nT` centers and the corresponding displayed sigma slack.

If `|T|>1`, the derivative-component argument produces a proper component in that free-coordinate affine space. The restricted basis sets are subsets of the original index set, so their separation is inherited **without choosing weights again**. The fiber version of the geometric lemma fixes another coordinate; the curve lies in a flat with a strictly smaller free set. Its applicable occupancy bound is precisely the bound already imposed for that smaller set.

If `|T|=1`, the count would produce a nonzero univariate polynomial vanishing identically on a curve in the affine line, which is impossible. Thus the descent terminates. This replaces the original single-center coordinate comparison: when centers collide, one cannot use coordinatewise distinctness to claim there is only one center. The report instead uses a fresh dimension count with the prechosen occupancy bound at each flat, which addresses that precise obstruction.

The resulting strict curve inequality passes through the separately assessed [curve-to-jet bridge](../curve-to-jet/report.md). No numerical occupancy example substitutes for the argument.

## Necessity is a quotient-dimension argument

In an overcrowded flat, set `t=0` and the fixed-coordinate displacements to zero in the corresponding target packets. This is a genuine quotient of the original target. The image factors through polynomials in the `d` free coordinates of weighted degree at most `H`, of dimension

    H^d/(d! product_(i in T) wi) + O(H^(d-1)).

The `n` strict target packets have dimension

    n theta^d H^d/(d! product_(i in T) wi) + O(H^(d-1)).

Translations do not increase weighted degree, and the rational weighted-simplex counts give the stated leading terms. If `n theta^d>1`, the target quotient is larger for every sufficiently large `H`; this obstruction survives arbitrary divisibility requirements. Equality cancels the leading comparison and is therefore genuinely undecided by this argument.

## Evidence and certification limits

Dependencies and external inputs are the multiplicity, normal-basis and curve-to-jet units. The grid and mixed-Y configurations in A05 satisfy the reported occupancies; [the exact replay](../exact-examples/replay.json) checks those hypotheses, not their universal eventual surjectivity. The Lean core proves neither the descending-flat argument nor the sheaf-theoretic bridge.

Compared with the original manuscript, the proposal allows controlled coordinate collisions and multiple nonzero-Y fibers, including an example with `K theta^m>1` although each fiber obeys its own bound. Compared with the strongest old Argus result, this review makes no new mathematical strengthening. A05's `research_target_level=publishable` and `result_class=new_reduction` are historical labels, not current conclusions. Novelty has not been established.

No concrete gap was found in the proposed theorem under its strict inequalities and named inputs. Equality cases, independent geometric/citation review, and any novelty claim remain outside what is supported here. The native Reviewer alone decides acceptance of the assessment.
