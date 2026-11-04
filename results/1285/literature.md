# Primary-literature comparison

The primary-source comparisons below credit the classical ingredients and
distinguish them from the combined adaptive shell-bank, actual-arithmetic,
common-input lower bound in `analysis.md`. The independent publication
Reviewer subsequently resolved the closest Brown/Riesel comparison and
accepted originality and publishable significance in
`1245a1519b6b/round-0001.json`. That existing scientific assessment is
referenced here, not reissued by the Engineer; Host-recognized final
project certification remains a separate delivery obligation.

## Closest ECM precedents

H. W. Lenstra Jr., *Factoring integers with elliptic curves*, Annals of
Mathematics 126 (1987), 649-673, DOI `10.2307/1971363`.
[Author paper](https://pub.math.leidenuniv.nl/~lenstrahw/PUBLICATIONS/1987c/art.pdf).
Section 2.3 explicitly warns that encountering a factor during scalar
multiplication depends on the addition chain. Sections 2.9-2.10 supply
bit-cost upper accounting and a conjectural ECM runtime based on
smoothness in square-root-length intervals, not a time lower bound.
Sections 1.5, 1.9(a), and 1.16 supply the exact weighted trace and
model-point facts used here. The sampler and trace propositions, together
with their hypotheses, already have independent citation attributions in
the campaign ledger; this work has not replayed those unchanged sources.

P. L. Montgomery, *Speeding the Pollard and Elliptic Curve Methods of
Factorization*, Mathematics of Computation 48 (1987), 243-264,
DOI `10.1090/S0025-5718-1987-0866113-7`.
[Primary text](https://cr.yp.to/bib/1987/montgomery.pdf).
Section 1, printed p. 244, discusses gcd batches and backtracking.
Sections 8-9.1, printed p. 256, describe continuation coverage through
nonzero elements of coefficient sets `D1 +/- D2`.
Section 9.2, printed p. 257, extends coverage using polynomially
transformed coefficients. Section 10.3.1, printed pp. 260-261, uses signed
scalar arithmetic and alternative coordinates. These are close prior
ingredients. Coefficient sums/differences, signed scalar arithmetic,
batching, and a continuation are not new contributions of this work.
The present arithmetic grammar does not encompass every Montgomery or
other ECM coordinate/continuation extension.

## Smooth-number precedents

E. R. Canfield, P. Erdos, C. Pomerance, *On a problem of Oppenheim
concerning "Factorisatio Numerorum"*, Journal of Number Theory 17 (1983),
1-28.
[Primary text](https://math.dartmouth.edu/~carlp/PDF/paper39.pdf).
The corollary to Theorem 3.1, printed p. 15, gives the classical
smooth-density asymptotic for
`3 <= v < (1-epsilon)*log(x)/log log(x)`, for fixed positive `epsilon`.
Theorem 3.1 alone is a lower bound; it must not be cited as the
upper-bound direction. The arbitrary-support injection into the first
`k` primes immediately reduces the present counting problem to this
classical smooth-number setting. In the intended regime
`log x = Theta(n)` and `log k = Theta(sqrt(n log n))`,
the resulting `exp(-(1+o(1))*v*log v)` scarcity is classical.

J. D. Lichtman, C. Pomerance, *Explicit estimates for the distribution of
numbers free of large prime factors*, Journal of Number Theory 183
(2018), 1-23, DOI `10.1016/j.jnt.2017.08.039`.
[Author manuscript, 2017-09-25](https://math.dartmouth.edu/~carlp/smoothfinal.pdf).
Equation (1.2), manuscript p. 2, states Rankin's Euler-product inequality.
Theorem 5.1, manuscript pp. 17-18, credits Granville-Soundararajan for a
refinement under `3 <= y <= x` and `1/log y <= sigma <= 1`.
The proof here uses a less sharp self-contained prime-density bound;
neither Rankin's inequality nor its arbitrary-support application is
claimed as an original analytic-number-theory result.

The DOI of the Hildebrand-Tenenbaum 1986 smooth-number paper was found,
but its full text could not be obtained during the bounded search.
No proposition or unverified locator from it is used.

## Related but different lower-bound and order results

V. Shoup, *Lower bounds for discrete logarithms and related problems*,
EUROCRYPT 1997, 256-266, DOI `10.1007/3-540-69053-0_18`.
[Revised author version](https://www.shoup.net/papers/dlbounds1.pdf).
Theorem 1, revised PDF p. 4, bounds generic discrete-log success by
`O(m^2/p)` under random injective group encodings and random inputs.
Its adaptive formal-polynomial collision argument is a methodological
comparison. Explicit ECM coordinates, composite-modulus gcds, and random
curve orders do not satisfy that theorem's hypotheses.

C. Pomerance, I. E. Shparlinski, *Smooth Orders and Cryptographic
Applications*, ANTS-V, LNCS 2369 (2002), 338-348.
[Primary text](https://math.dartmouth.edu/~carlp/PDF/paper128.pdf).
Theorem 3, printed p. 344, gives unconditional scarcity of primes with
smooth order of the fixed multiplicative base 2 for
`exp(sqrt(log x log log x)) <= y <= x`.
This is relevant precedent for order-smoothness scarcity, but not an
adaptive ECM lower bound.

H. W. Lenstra Jr., J. Pila, C. Pomerance, *A hyperelliptic smoothness
test, II*, Proceedings of the London Mathematical Society 84 (2002),
105-146, DOI `10.1112/plms/84.1.105`.
[Primary text](https://math.dartmouth.edu/~carlp/PDF/paper129.pdf).
Theorem 1.1, printed p. 106, gives effective genus-two Jacobian
order-fibre lower bounds outside an explicit exceptional set.
Those orders are near `p^2` with intervals of length `p^(3/2)`,
not the elliptic square-root Hasse windows relevant here.

## Contribution and independent comparison

### Additional primary comparisons for publication

R. P. Brent, *Some integer factorization algorithms using elliptic curves*,
Australian Computer Science Communications 8 (1986), 149-163;
`arxiv:1004.3366v1`. The inspected author text is the corrected 1998 retyping,
not a claim that the arXiv transcription has identical pagination:
[author text](https://maths-people.anu.edu.au/~brent/pd/rpb102.pdf).
Sections 4 and 6, reprint pp. 4 and 6-7, explicitly use Lenstra's
heuristic hypothesis for random curve orders. The birthday continuation
assumes a stage-one residual point of prime order `n1`; its generated
doubling/doubling-plus-point sequence is treated as essentially random.
The predicted collision probability is
`1-exp(-r^2/(2*n1))`, with an inverse-pair correction for x comparisons.
This is a performance prediction under a sampling model, not an
unconditional success upper bound or factoring-time lower bound.
Point order is approximated by curve order in that analysis. Neither its
collision estimate nor its bit-cost postscript supplies the common-input
and necessary-arithmetic-event conclusions of the present theorem.
Random birthday continuation, inverse-pair comparisons, and batching
are prior art, not new mechanisms here.

H. W. Lenstra Jr. and C. Pomerance, *A rigorous time bound for factoring
integers*, Journal of the American Mathematical Society 5 (1992), 483-516,
JSTOR stable document `2152702`;
[author scan](https://pub.math.leidenuniv.nl/~lenstrahw/PUBLICATIONS/1992c/art.pdf).
The main theorem and Theorem 10.5, printed pp. 483 and 510, give an
unconditional expected-time **upper** bound for a quadratic-class-group
relation algorithm. Section 11 is a much closer obstruction precedent.
Theorem 11.1, printed p. 511, counts integers `m<x` such that every
negative discriminant divisible by `m` has class number with a prime
factor exceeding `y`, for `c11<y<x^(1/9)`; the theorem says `c11` is
ineffective. The proof constructs bad integers using prime-square
divisibility, not balanced squarefree semiprimes. Its discussion identifies
a flaw in a heuristic random-class-groups analysis, not a proved
time lower bound for arbitrary adaptive elliptic-curve schedules.
Thus a rigorous obstruction to treating group invariants as random
integers is an established strategy. The contribution claimed here
must be the elliptic arithmetic, quantitative program-class, and
common-squarefree-input theorem, not that general strategy.

D. J. Bernstein, P. Birkner, T. Lange, and C. Peters, *ECM using Edwards
curves*, Mathematics of Computation 82 (2013), 1139-1179;
IACR ePrint `2008/016`, inspected author version dated 2011-10-08:
[author text](https://eecm.cr.yp.to/eecm-20111008.pdf).
Section 5.4, manuscript p. 16, argues that curve operations are not
negligible in an optimized higher-degree baby/giant-step continuation.
It assumes uniform step parameters modulo the residual prime when
comparing coverage probabilities. This is not an absolute factoring
lower bound. Section 9.3, manuscript pp. 30 and 33, labels the sequence
from point-order powersmoothness through curve-order powersmoothness
and random-integer/Dickman estimates as heuristic approximations.
Section 10, manuscript pp. 34-35, instead measures modular work divided
by measured success probabilities on specified prime sets.
The paper also selects curves with deliberately large rational torsion,
outside the uniform model-point sampler in Section 1 of `analysis.md`.
Its optimized coordinates and higher-degree continuations must not
be advertised as included by the present arithmetic grammar.

P. Zimmermann, *The Elliptic Curve Method for Factoring*, author entry
dated 2009-09-17, revised 2010-09-25:
[primary text](https://members.loria.fr/PZimmermann/papers/ecm-entry2.pdf).
The "Theory" paragraph on PDF p. 2 expressly calls
`O(L(p)^(sqrt(2)+o(1))*M(log N))` the **conjectured expected** running
time, where `L(p)=exp(sqrt(log p*log log p))`.
The "Open Problems" paragraph on p. 3 says that improvements to either
phase are not known. This supplies context for a restricted lower-bound
question; it does not prove that no such lower bound has ever appeared.
The p. 2 continuation description already uses two point families and
nontrivial scalar differences, and distinguishes random birthday from
deterministic prime coverage.

The accessible primary comparisons above were read directly or by the
read-only primary-source researcher. An automated search summary's
"end of Section 8" locator in Lenstra 1987 and its purported closing
quotation were rejected: the inspected paper has no such locator.
Automated search synthesis is not source evidence.

The full text of R. D. Silverman and S. S. Wagstaff Jr., *A practical
analysis of the elliptic curve factoring algorithm*, Mathematics of
Computation 61 (1993), 445-462, AMS identifier
`S0025-5718-1993-1122078-7`, remains unavailable after the primary URL
returned HTTP 403 and alternative retrieval did not yield readable text.
Semantic Scholar discovery also returned HTTP 429. No theorem, quotation,
or equivalence finding from that inaccessible paper is asserted.

### Resolved straight-line lower-bound comparison

D. R. L. Brown, *Lower Bounds for Straight Line Factoring*, IACR ePrint
`2010/047`, original paper dated May 31, 2010;
[primary record](https://eprint.iacr.org/2010/047) and
[public archived primary PDF](https://web.archive.org/web/20260216143605id_/https://eprint.iacr.org/2010/047.pdf).
Earlier direct retrieval did not obtain the text; the independent
publication Reviewer subsequently read the complete 12-page primary
paper and recorded the comparison in `roles/reviewer/progress.json`.
No new retrieval or arithmetic replay was needed for this final submission.

Definitions 1-4, printed p. 3, describe a fixed input-independent ring
program beginning with `1`, using addition, subtraction and multiplication,
and returning `gcd(P(),n)`. Its ECM variant in Section 3.3, pp. 5-6,
fixes curves, points and scalar parameters and removes division.
Section 5.1, p. 7, equation (5), gives an abstract minimization of integer
straight-line length at a prescribed success rate. Sections 5.2-5.3,
p. 8, discuss independently sampled primes in `(2^s,2^(s+1))`, success
rate `1/2`, and an approximate linear-in-`s` length bound; Section 6,
p. 9, describes a quadratic bit-operation consequence. These approximations
are not promoted here to an exact quantitative theorem.

Neither that minimization nor the weak linear estimate supplies
`exp(Omega(sqrt(n log n)))` factoring time. The fixed branchless ring
grammar also does not supply the submitted sample-dependent affine
control within a shell bank, actual curve-point weights, or an effective
balanced squarefree input at every exact length before all randomness.
Section 5.3 explicitly distinguishes an almost-everywhere integer-length
bound from a universal exponential factoring bound. The primary abstract
alone would not establish any of these precise non-implications.

H. Riesel, *Prime Numbers and Computer Methods for Factorization*,
second edition (1994), printed pp. 223-224, is the predecessor precisely
identified and reproduced in Brown Section 1.2, printed p. 2.
The independent Reviewer read that reproduced passage and checked matching
public original-book snippets for the
[ideal prime generator](https://books.google.com/books?jscmd=SearchWithinVolume2&q=%22ideal%20prime%20generator%22&vid=5cIN7kemQgYC),
[polynomial time context](https://books.google.com/books?jscmd=SearchWithinVolume2&q=%22polynomial%20time%20performance%22&vid=5cIN7kemQgYC),
and [continuation on p. 224](https://books.google.com/books?jscmd=SearchWithinVolume2&q=%22the%20ideal%20could%20be%22&vid=5cIN7kemQgYC).
This is not a claim to have read the full book or every edition.
The passage supposes an ideal prime generator reaching an exponential
prime range after `i` steps and discusses its hypothetical `O(log p)`
arithmetic-step and polynomial bit performance. Even an informal linear-step
interpretation does not imply the adaptive ECM subexponential obstruction,
weighted sampling bound, or common exact-length hard-semiprime theorem.

Riesel, *Modern factorization methods*, BIT 25 (1985), 205-222,
[public primary scan](https://cr.yp.to/bib/1985/riesel-modern.html),
was independently read as a separate 1985 lead. It discusses trial division,
Pollard rho, continued fractions, quadratic sieving, Pollard `p-1` and
`p+1`, and portfolio strategies. Sections 22-23 concern smoothness-based
success mechanisms; Section 26 leaves general polynomial-time factoring
possible. It does not state the submitted theorem and is not substituted
for Brown's exactly located second-edition attribution.

The primary abstract of M. Hhan, *A New Approach to Generic Lower Bounds:
Classical/Quantum MDL, Quantum Factoring, and More*, IACR ePrint
`2024/268`, [record](https://eprint.iacr.org/2024/268), was also inspected
to triage an automated generic-ring comparison. It announces logarithmic
quantum-generic-ring bounds for order finding and a certain small-output
factoring algorithm, alongside classical generic-group results.
That abstract does not state a subexponential classical actual-coordinate
ECM lower bound. No uninspected theorem from it, or unsupported automated
Bach/Maurer bibliographic suggestion, is used in this submission.

The independently accepted new statement is the combined theorem: an effective
common hard semiprime at every sufficiently large length for adaptive
programs drawn from a polynomial shell bank, including all reviewed
dual-chain tuples, at a growing `exp(c*sqrt(n log n))` bit cutoff.
Its proof combines complete signed arithmetic containment, a
budget-uniform inventory, classical smooth-number scarcity, and
selector-tape averaging before prime selection under actual sampler
weights.

The accepted fixed-tuple obstruction did not establish that program-class
lower bound. Conversely this theorem, even if correct, says nothing about
unrestricted factoring or every ECM implementation. The inspected statements, including the subsequently obtained Brown paper
and precisely located Riesel passage, do not imply this conjunction.
The independent Reviewer accepted verified originality and publishable
significance in `1245a1519b6b/round-0001.json`, on that proposition-level
comparison and the growing-budget/adaptive/common-input improvement,
not on search silence. The publication argument and scope limits are in
`analysis.md` Sections 7-10. The unchanged result now awaits the distinct
Host-recognized final-submission certification; neither this comparison
nor an Engineer progress flag replaces that receipt.
