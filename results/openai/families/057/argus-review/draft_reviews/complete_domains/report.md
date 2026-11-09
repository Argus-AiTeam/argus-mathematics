# Complete differential domains and Hilbert-complex exactness

**Assessment:** `L_SWI_DOMAINS@1` is supported at its stated conditional
scope. This is a prose mathematical assessment, not an analytic Lean proof
or native independent acceptance.

## Statement and source

The old subject hash is
`5693c238d04a18d034d6c23f564b337ecc0b084c0c9b3802aeb1e5588fc2aed3`.
The argument is old `proof.md`, Section 2, in context `CTX_SWI@1`.
It expands the domain statements already in the compact manuscript's
`spectral.tex:71-97,438-447`. That staged source matches reference revision
`4eaee87548250b2682affda7d05d947c05554bae`.

For each fixed `B=exp(b)<infinity`, the same smooth scalar multiplier in
each bundle degree satisfies

\[
 \|w\|_0^2\le\|w\|_h^2\le B\|w\|_0^2.
\]

The claim is equality as sets of the corresponding closed differential
domains, kernels and images, preservation of closed ranges and any already
established exactness, and compactly supported smooth form cores on the
specified complete orbifold. It expressly does **not** identify weighted and
unweighted Hilbert-adjoint domains. Positivity of the unweighted gaps and
completeness are separate hypotheses, not consequences of equivalence of
norms alone.

## Differential domains and inherited topology

For the maximal distributional `d_q=barpartial`, domain membership is exactly
that both `w` and `d_q w` belong to the relevant degree Hilbert spaces.
The inequalities above apply to each of those two terms, so the sets of
maximal-domain elements are identical and the graph norms are equivalent.
The minimal closures also have the same domain sets: they are closures of
the same compact-support operator in equivalent graph norms.

The operators have the same values on those domains. Their kernels and
images therefore agree as subsets, and equivalent Hilbert topologies have
the same closed subsets. This proves range-closedness preservation and
exactness preservation. It would be invalid to conclude exactness from norm
equivalence without unweighted exactness; the old argument does not do so.
The equivalence constants depend on `b`, which is harmless for this
fixed-parameter topological step. Uniform final estimates are derived later.

## What the unweighted gap supplies

Here is the Hilbert-complex argument behind the asserted primitive estimate.
Assume the form gap `Q_0(v)>=delta*||v||_0^2` in every degree, for fixed
`delta>0`. For `u in Dom d_q` orthogonal to `ker d_q`, the complex identity
implies `u` is orthogonal to `im d_(q-1)`. It is consequently in
`Dom d_(q-1)^*`, with that adjoint zero. The gap yields
`||d_q u||_0^2>=delta*||u||_0^2`.

Projecting any primitive off `ker d_q` preserves the differential domain.
The displayed inequality makes the minimal lifts of a Cauchy sequence in
`im d_q` Cauchy. Closedness of `d_q` then makes its image closed. If a
closed vector is orthogonal to that preceding image, both its differential
and preceding adjoint vanish, so the gap kills it. Hence
`ker d_q=im d_(q-1)`. In degree zero the preceding image is zero, so
the kernel is zero; the same reasoning includes the terminal degree.

An unweighted minimal primitive `T_0 eta` of a closed positive-degree
`eta` therefore satisfies

\[
 dT_0\eta=\eta,\qquad
 \|T_0\eta\|_0^2\le\delta^{-1}\|\eta\|_0^2.
\]

It is an admissible weighted primitive. Orthogonal minimization in the
weighted closed affine solution set gives the weighted minimal inverse `V`
and the coarse estimate

\[
 \|V\eta\|_h^2
 \le\|T_0\eta\|_h^2
 \le(B/\delta)\|\eta\|_0^2
 \le(B/\delta)\|\eta\|_h^2.
\]

This existence/coarse-bound step precedes every use of `A^(-1)` in the
spectral-band proof. It eliminates a possible circularity concern.

## Complete form cores, including unbounded weight derivatives

The specified complete lifted `Omega_1` metric has smooth compactly supported
cutoffs tending to one with gradient tending uniformly to zero. Since
`Omega_S>=Omega_1`, its inverse metric gives no larger gradient norm for
`S>=1`. For any fixed `h`, the commutators with `d`, its weighted formal
adjoint and the Chern differential are exterior multiplication or
contraction by that gradient.

The zeroth-order coefficient terms, including derivatives of `log h`,
commute with the scalar cutoff and cancel from the commutator. Its norm
bound uses the **same** weighted fiber metric on input and output.
Thus multiplying an element of
`Dom d intersect Dom d_h^*` by these cutoffs converges in its form norm.
There is no need to estimate the full derivative of `h` uniformly.

On the resulting compact sets the coefficients are smooth with bounded
derivatives on each chart. Friedrichs approximation applied to the
first-order system `(d,d_h^*)` gives simultaneous approximation of the two
derivatives, not just separate unrelated approximations. A finite partition
of unity and averaging over the finite uniformizing groups preserve
invariance; commutators with the partition are also local zeroth-order
operators. This supplies compactly supported smooth invariant sections as
the form core. The same cutoff/local argument for `d` alone identifies
minimal and maximal differentials.

Completeness and smooth local coefficients are doing real work here.
Identifying minimal and maximal domains on an arbitrary incomplete domain
would be false in general. No such extension is made by this draft.

## Disposition, attribution and remaining scope

No concrete gap was identified in the argument at these hypotheses.
It is standard norm-equivalence and complete-Hilbert-complex reasoning,
with domain details supplied by the old Argus draft; novelty is not claimed.
The checks are mathematical reading. The six scalar Lean declarations
contain none of these domain facts.

The old Reviewer judgement
`judgement-L_SWI_DOMAINS-d95423e19ced` names the same subject and
`proof.md` artifact. The graph's pending label does not erase that record,
and the record does not substitute for the argument above or final native
review. The proof file currently matches the preserved core manifest;
the old prose judgement does not independently bind its historical bytes.

Gap existence and its geometric product specialization are assessed/assumed
elsewhere. This unit does not claim regularity bounds uniform in all
derivatives of `h`, equality of adjoint domains, an incomplete-domain theorem,
or a downstream manuscript result. There is no unresolved internal domain
obligation identified here; current independent assessment/acceptance remains
pending.
