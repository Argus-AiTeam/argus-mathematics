# Failed attacks and excluded conclusions

**Assessment:** the equal-coordinate construction is a genuine eventual rank obstruction with inadmissible manuscript hypotheses. The other two retired approaches cannot settle the original interpolation theorem. None is a manuscript counterexample.

## Exact collision obstruction

Old A04 section 7 and A05 `excluded_collision_obstruction` use `m=2`, `theta=3/5` and the distinct points `(1,0,0),(1,1,0)`. The original OpenAI theorem, September 24, 2026 revision `4eaee87548250b2682affda7d05d947c05554bae`, requires coordinatewise distinctness. Both points have `X2=0`, so that hypothesis fails even though the points themselves are distinct and the ambient volume condition may hold.

Set `t=0,u2=0` in the two target packets. The image factors through the restriction of the polynomial to `Y=1,X2=0`, in the single free coordinate `X1`. For `H=5 l w1`, the source has dimension `5l+1`, while each strict packet has exponents

    a (w1/theta) < 5 l w1, or a < 3l,

so its dimension is `3l`. The two-packet quotient has dimension `6l`; the rank defect is `l-1>0` for every integer `l>=2`. Choosing `l` along suitable multiples meets any fixed divisibility requirement. This is an exact argument on an infinite ray, not a bounded rank experiment.

The construction exhibits density `2 theta=6/5>1` on a one-dimensional flat. It illustrates the necessity side of the extension, which does not admit this occupancy. It cannot refute the original theorem because its decisive collision is expressly excluded there.

## The two old retired routes

The complete route ledger A01 records `R_K1_BOUNDED_RANK_ONLY` as retired because a finite-degree defect, or finitely many full ranks, cannot decide **all sufficiently large divisible** degrees. A finite defect can lie below the permitted threshold. Finitely many successes do not control later degrees. The old exact obstruction above is stronger than a finite sample, but still fails the original center hypothesis.

The ledger also retires `R_K1_CARELLA_COMPARATOR`: a reported sign objection concerns an unused external comparator already acknowledged in the manuscript wrapper. Even granting that objection, it does not negate the separate multiplicity/curve/interpolation proof. This review does not newly verify, refute or repair Carella's result. The decisive point is logical relevance, not a second error search in an external paper.

The current ledger records these inherited failures with their reasons, plus the inadmissible equal-coordinate route. The citations are to A01's route records and A04 section 7; the exact numerical construction is A05. The old objective and stopping rules are not imported.

## Replay and conclusion

The unchanged checker replay (Python 3.13.5, Argus-latest interpreter, exit 0; [output](../exact-examples/replay.json)) explicitly tests failure of the original hypotheses and verifies the dimension polynomials and their positivity for the whole asserted integer ray. It does not re-run a new search for other centers.

Current claim `C_FAILED_ATTACKS_017` therefore supports the obstruction **and** the scope exclusion. No original `geom:*` statement receives a refutation from it. The final pi claim is also untouched. The native independent Reviewer must assess this attribution boundary rather than inherit a historical route label.
