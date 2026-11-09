# Ordinary-Lie image and filtered dimension assembly

**Engineer assessment: the final retraction and dimension implication are
supported; the old package only partially certifies the literal image-bound
argument that feeds them.**

## Exact assertions and source

Old `L_IMAGE` and `L_FILTERED_BOUND` refer to `prop:image-bound` and
`cor:dimension-bound` in Section 5 of the manuscript at revision
`4eaee87548250b2682affda7d05d947c05554bae`.

For weight `n>2` and each leading `B`-count `r`, the projected associated
graded of the embedded rational-solution reduction is claimed to lie in
the **ordinary** free Lie algebra on

    g_k=ad_C^k B, k>=1, weight(g_k)=2k+1, length(g_k)=1,

in weight `n` and length `r`; its `r=0` piece vanishes. This is stronger
than primitive membership in a characteristic-two enveloping algebra.
The source statement is `05-image.tex:244-254`.

`L_FILTERED_BOUND` is the implication from this image statement,
projection injectivity, and the integral dimension comparison to the
rational `n>2` upper bound. Its endpoint is a duplicate of `C_UB_GT2`,
not a second mathematical result.

## Decisive argument and what is supported

The paper first proves shift invariance with an Ore-extension construction
and a `B`-degree argument (`59-241`). The subsequent proof uses independent
scalar indeterminates to obtain a Vandermonde system over a rational-function
field, then consecutive divisibility of the encoded gap coefficients
(`256-301`). This is not a Vandermonde argument using only the two elements
of `F2`: algebraic independence makes the determinant nonzero even in
characteristic two.

The passage from associative gap coefficients to ordinary Lie membership
uses independence of the gap monomials and an explicit ordinary-Lie
retraction (`302-371`). Its final mechanism is sound: in the ordinary free
Lie algebra on `g_0,g_1,...`, send `g_0` to zero and fix all `g_k`, `k>=1`.
If an element's associative expression contains no `g_0`, this
endomorphism fixes it, while its image belongs to the ordinary Lie algebra
on the positive-index generators. This requires known ordinary Lie
membership first; primitive membership alone would not justify the step.

The dimension assembly (`386-420`) is also a genuine conditional argument.
At weight `n` the positive-weight `B`-count filtration is finite. Thus

    dim(reduced W_n) = sum_r dim(gr_r reduced W_n).

Inject each summand into the corresponding **length-r** part of the
weight-n odd-generator Lie algebra. Distinct lengths are graded summands,
so summing does not count the same target dimension repeatedly. The
saturated-lattice dimension identity and characteristic-independent
ordinary free-Lie dimensions then give the rational bound. No limiting
argument or inference from a finite range of weights is involved.

## Evidence limit and concrete obligations

The source supplies detailed derivations of shift invariance, the
Vandermonde/divisibility step, and the retraction; these are not mere
assertions. But neither the old rank-two boundary calculation nor its 21
source-action expansions verifies the Ore-extension shift argument, the
coefficient equations, or the absence of `g_0` in every projected image.
The old endpoint certificate establishes the rational inequality without
separately binding all those prose assertions to checked declarations.

Separate certification of the literal image route therefore still needs
the following concrete checks: the shift construction preserves exactly the
required leading-solution constraints; its coefficient equations are the
claimed independent-indeterminate Vandermonde system; consecutive
divisibility rules out each forbidden gap, with the original weight and
length tracked; and the element to which the retraction is applied is
already an ordinary Lie element, including the zero-count case.

Accordingly `L_IMAGE` has partial independent support in this package.
`L_FILTERED_BOUND` has a supported conditional dimension argument, and its
conclusion has the separate historical formal support assessed in
[upper_bound_certificate](../upper_bound_certificate/report.md).
These evidence limits are not identified errors in the paper and do not
reopen an error search. This is an existing-proof reconstruction, not an
original theorem or verified novelty claim. Native independent review of
the assessment remains required.
