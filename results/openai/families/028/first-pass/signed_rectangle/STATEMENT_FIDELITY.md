# Statement fidelity

## Mathematical claim

`C_RECTANGLE` is the literal fixed-rectangle assertion at
`build/geometry.tex`, `lem:rectangle`, lines 84--230 of the staged
September 26, 2026 manuscript. `C_RECTANGLE_SHARP` is theorem (T) in
`PROOF.md`, with the same objects and hypotheses and the stronger bound
\[
 \Pr\{Q\cap(\prod_i\pi_i)\mathbb Z[i]\ne\{0\}\}
 \leq\min\{1,3e^{-d^2r/32}\}.
\]

The quantified objects are every positive integer \(r\), every real
\(T\geq5\), every list of distinct rational primes \(p_i\equiv1\bmod4\)
in \([T,2T]\), every choice of conjugate norm-\(p_i\) Gaussian factors,
every real \(d\) with \(0<d<1/4\), and every fixed origin-centered
rectangle of any real orientation and half-lengths \(R\geq W\geq1\)
satisfying \(RW\leq(\prod_i p_i)^{1-d}\).
The probability space is exactly the \(2^r\) fair independent conjugate
choices. The event concerns a nonzero **multiple** of the whole signed
product, not merely the product itself.

The rectangle and primes are fixed before the signs. The constants
are uniform in those fixed data. The statement does not assert that
one outcome avoids all admissible rectangles simultaneously. The
explicit construction in the last section of `PROOF.md` explains why
that different quantifier order would be false.

The original condition \(d^3r\geq C_0\) is not dropped from the
manuscript by reinterpretation: the stronger theorem proves a bound
for all \(r\), which implies the original with
\((C,c,C_0)=(3,1/32,1)\). The substantive improvement over the staged
source is a quadratic rather than cubic exponent in \(d\), not merely
an explicit choice of constants.

## What is proved and what the program checks

`PROOF.md` is a complete analytical proof of a universal theorem.
It proves the Gaussian divisibility and primitive-direction inputs,
the fair-bit exponential-moment inequality, the fixed-line tail,
the common-factor determinant separation, the Lipschitz cube
exponential moment, the two-set product estimate, and the arbitrary
finite separated-class aggregation. It never assumes the rectangle
bound or an equivalent many-direction assertion.

`verify.py` checks exact symbolic identities, nonnegative polynomial
coefficient certificates, rational constants, and the archived typed
Jacobian result. The factorial recurrence is an induction certificate
valid for every nonnegative integer, not a factorial table up to a
cutoff. The normalized rectangle determinant is multi-affine, so its
vertex certificate bounds its entire real box by multilinear
interpolation, not just the vertices.

The verifier separately checks a small Gaussian-integer example and
fair-sign distribution. Those checks are regression/adversarial tests,
not the proof of the universal theorem. The program does not formalize
Euclidean-domain theory, convergent series, conditional expectation,
Markov's inequality, or the greedy partition argument. Those
mathematical steps are exposed in `PROOF.md` for independent reading.
There is no Lean source, compiler certificate, or claim of
`closed_kernel` status in this deliverable.

The Jacobian operation is
`matrix.symbolic.multiply.compute`, inspected before execution, and
multiplies the one-entry symbolic matrices \(r\lambda-2s\) by
themselves over \(\mathbb Q(r,s,\lambda)\).
It checks the completing-square numerator in the universal two-set
estimate. The exact payload, typed output, server/protocol identifiers,
exit status, and stderr are preserved in the adjacent Jacobian JSON
files. It is not a probabilistic oracle.
The discovered finite Fourier, graph-boundary, and squarefree
operations do not prove this universal rectangle theorem and were
not substituted for it.

## Independence and remaining boundaries

The concentration ingredients and Gaussian Euclidean arithmetic are
standard; their elementary proofs are included, so the new bound has
no outstanding external-theorem assumption. Conrad's notes were
obtained and the manuscript's Gaussian-integer locators were read as
a comparison, not as a substitute for those proofs.
The Hoeffding DOI page was inaccessible (HTTP 403); its unread
statement is not used as an assumption. Preliminary search did not
establish global novelty of the strengthened application.

The main sieve, entropy, coverage, scheduling, information, and
periodicity claims are decomposed in the campaign ledger and graph,
but remain unaudited. The reported incomplete public Lean comparator
was not re-inspected and provides no evidence for any claim here.
No false assertion of the staged rectangle lemma has been established,
so no manuscript refutation is claimed.

Engineer replay is not independent Reviewer acceptance. Review must
read the whole proof, replay the exact certificate, and assess both
the strengthened theorem and its significance/novelty. All graph
reviewer flags remain false until that happens.
