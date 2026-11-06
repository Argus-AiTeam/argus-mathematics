# Statement fidelity for C_CC_FORMAL_CORE

The declarations in namespace `CircuitComparison` formalize the algebraic
orientation and support-reordering core of Sections 4--6 of
`../comparison.md`. They are not a formalization of the full analytic bound,
of the existence of the flags, or of either manuscript's main theorem.

`descendingProduct f n` is the product `f (n-1) ... f 0`; `n=0` gives the
identity. `descendingProduct_commute` quantifies over every monoid, every
sequence, every element, and every finite length. It moves that element
past the product when it commutes with each factor.

`interleaved_product` quantifies over every monoid and every pair of
sequences `k,m`. Its hypothesis is precisely that `k i` commutes with
`m j` for every `i<j`. It proves
`(k(n-1)m(n-1))...(k0 m0) = (k(n-1)...k0)(m(n-1)...m0)`
for every natural length. In the actual circuit, `k` denotes the corrected
arrival-level unitaries and `m` the frame-aligned layers. Their commutation
is derived from the genuine next-departure projections in the prose
proof, not certified by this declaration alone.

`exchange` is the two-by-two matrix with off-diagonal entries `c,s`.
`post_error` quantifies over every possibly noncommutative ring and all
entries `c,ci,si,s`, requiring only `c*ci=1`. It proves that the new
exchange times the old inverse exchange is diagonal with entries
`1,si*s`. With `si=S3^{-1}`, `s=S2`, `ci=C^{-1}`, this is exactly
equation (12). The lower, arrival block is the priority discrepancy;
the formal statement does not reverse their order or assume the
exchanges are involutions.

`commute_of_annihilating_errors` applies to every ring. Both ordered
products of `k-1` and `m-1` must vanish, and the conclusion is `k*m=m*k`.
For the actual operators these annihilations follow from exact fixation
of the next departure and invariant orthogonal complements. One-sided
annihilation alone is not encoded as sufficient.

`errorSum` is the corresponding descending sum of `k i-1`.
`mul_errorSum_zero` and `disjoint_error_product` quantify over every ring
and every natural length. The latter requires
`(k i-1)*(k j-1)=0` for all distinct indices, and proves that the
product is `1+errorSum k n`. Orthogonal-level support gives exactly
this hypothesis. The Hilbert-space norm of that direct sum is a
maximum rather than a sum; this additional norm statement is proved
in prose, not encoded here.

`common_right_cancel` is the cancellation identity for every group.
It does not assert that the common factors can be extracted from the
actual circuits; the F1 support argument proving extraction is in
the prose proof.

`rational_constants` proves the four exact rational arithmetic bounds
used for the Schur map and truncation. `truncation_budget` proves the
last error estimate for all real `h,z` with `h>=0` and `z<=1/4`.
These statements make no assertion about spectral calculus.

There are no external mathematical axioms or admitted obligations in
this source. A successful compiler record certifies these declarations
under their displayed hypotheses, not the unencoded analytic
translation. That translation and the correctness of this fidelity
document require independent human mathematical review.
