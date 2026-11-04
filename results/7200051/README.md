# Result 7200051

## Quantitative Distortion Bounds and Formal Equilateral Exclusion for Eleven Points in Five-Dimensional l_1

**Status:** `independently_verified` (`improved_bound`, `novelty_status=verified_new`)<br>
**Resolved scope:** Strict quantitative lower bound > 3089/3084 and rational upper bound <= 115/106 on the 11-point aspect ratio in l_1^5, plus Lean 4.33.1 kernel audit of e(l_1^5)=10<br>
**Field:** discrete and metric geometry

## Summary

Kusner's 1983 conjecture asserts that an equilateral set in $\ell_1^d$ has cardinality at most $2d$. In dimension $d=5$, we establish two complementary quantitative results on the minimum aspect ratio $\Delta(X) = \max_{i<k}\|x_i-x_k\|_1 / \min_{i<k}\|x_i-x_k\|_1$ over eleven-point configurations $X \subset \ell_1^5$. First, by developing a perturbation-stable version of terminal coordinate clipping, reciprocal-mass weighting, and span majorization, we prove the universal lower bound $\Delta(X) > \frac{3089}{3084} > 1.00162$. Second, by optimizing over coordinate-order cones with exact rational primal-dual linear programming certificates, we construct an explicit eleven-point rational configuration with denominator $848$ achieving $\Delta(X) = \frac{115}{106} \approx 1.084906$, strictly improving upon the symmetric centered benchmark $\frac{9}{8} = 1.125$. In addition, we classify the complete $66$-graph five-edge endpoint-incidence relaxation cover and record a complete Lean~4.33.1 kernel verification of the exact $e(\ell_1^5)=10$ exclusion.

## Open Boundaries

- Exact value of the unrestricted 11-point minimum aspect ratio in l_1^5 and Kusner's conjecture in dimensions d >= 7

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_7200051_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_7200051_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `robust_clipping_gap.md` | Mathematical proof / verification artifact |
| `eleven_point_distortion.md` | Mathematical proof / verification artifact |
| `endpoint_chain_cover.md` | Mathematical proof / verification artifact |
| `check_robust_clipping_gap.py` | Mathematical proof / verification artifact |
| `check_endpoint_chain_cover.py` | Mathematical proof / verification artifact |
| `configuration-115-106.json` | Mathematical proof / verification artifact |
| `verification-summary.json` | Structured verification summary |
