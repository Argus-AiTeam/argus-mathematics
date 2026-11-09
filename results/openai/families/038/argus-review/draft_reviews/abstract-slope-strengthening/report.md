# Abstract uniform-slope strengthening

**Engineer assessment: supported as a conditional structural generalization.**
Its scalar obstruction is formal; realization of its abstract hypotheses is
not supplied for every graded system or for center-degree-dependent slopes.

## Exact claim, hypotheses and attribution

Let a multiplicative graded system have one-dimensional Taylor leaves and
\(N_j\sim c_Xj^n\), with \(n\geq1\), \(c_X>0\). In the positive-center
construction, assume:
uniform pure-slice growth \(b_0(h)\geq\sigma h-C\) for a fixed
\(\sigma>0\); a cube \(\{0,1\}^d\) realized in a uniformly bounded degree;
nonnegative transverse weights fixed across auxiliary degrees for each
reference test; the upper tangent-variation bound \(T_m\leq d/t\);
the scaled-test comparison at the marked point with linear discrepancy
scaling; a uniform discrepancy lower bound \(a\geq0\); and a fixed-parameter
sequence approaching a positive liminf of objective values.
All growth thresholds, slopes and cube degrees are uniform across the
moving tests/centers.

Then persistence of positive-dimensional minimizers along that sequence
implies
\[
 \sigma\left(t+\frac{a}{n+2}\right)\leq n+1.
\]
The contrapositive excludes persistence if the opposite inequality is
strict. Existence of a parameter in a desired interval is an additional
condition; the `exists_parameter` theorem supplies that choice for
\(\sigma=1,a>0\), not for arbitrary small \(\sigma\).

This strengthening is old Argus `report.md`, lines 506-532, equation (28).
It is embedded in the sigma-bearing assertions of `PC9000038` versions 1-4,
not a second independent Lean proof. The original OpenAI point-center
manuscript is its geometric specialization with slope one, at the
manifest-bound September 23, 2026 revision. The claimed abstract extension
is attributable to the historical Argus draft; verified originality is not
asserted.

## Decisive argument

The same cube-thickening/Brunn-Minkowski argument as the growth unit gives
\[
 b_p(j+h)\geq b_p(j)+\sigma h-(C+\sigma h_0)
\]
for old nonempty slices once the uniform threshold is exceeded.
Fixed nonnegative weights permit power-growth summation and the same simplex
moment comparison. With \(j_i=\lfloor mi/l\rfloor\) at fixed \(l\), the
normalized increment tends to \(\sigma/l\), not \(1/l\). The assumed
scaled-test comparison, positive liminf ratio and Hilbert asymptotic therefore
give, for every \(l\geq2\),
\[
 \sigma dR_n(a/t,l)\leq d/t.
\]
The fresh `partition_obstruction` declaration supplies exactly the displayed
scalar consequence. The endpoint-moment lower bound is derived from the
cube and growth premises, not secretly assumed as the desired conclusion.

This transfer checks the homogeneity: \(\sigma\) multiplies the *whole*
\(t+a/(n+2)\), because it multiplies all partition increments.
Uniformity across reference tests is essential. A larger center-dependent
root-cardinality asymptotic with a threshold diverging along moving centers
cannot be substituted in this proof.

## Evidence and remaining scope

The exact final source and its successful historical certificate are
version-bound in `../input_bindings.json`. The fresh claim-bound scalar
certificate is shared with the universal-partition unit. No new graded
system or numerical family was constructed; no finite experiment establishes
the abstract hypotheses. The same geometric/local and Brunn-Minkowski
inputs are needed if this extension is realized by Taylor slices.

No gap was found in this implication when the stated uniform hypotheses
are admitted. The concrete obligation for any new application is to prove
its uniform pure-slice slope and bounded cube, the tangent upper variation,
and the scaled-test/positive-liminf comparison for that application.
The old geometric restriction argument proves only \(\sigma=1\) uniformly.
It does **not** establish
\(\sigma=(L^d\cdot W)^{1/d}\) with center-independent constants for
unbounded-degree moving \(W\). The native Reviewer must check this boundary,
the structural implication and the complete family coverage; no novelty or
unconditional Fujita conclusion is inherited.
