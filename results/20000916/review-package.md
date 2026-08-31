# Result 20000916 — the l1 obstruction to an arbitrary-norm Steinitz bound

## Claim decided

The literal formulation of AIM Problem 1.4 quantifies over an arbitrary norm
and asserts an O(sqrt(d)) bound for the ordinary zero-sum Steinitz
rearrangement constant. That uniform assertion is false.

For every integer d at least one, the Grinberg-Sevastyanov construction gives

    S(B_1^d) >= (d+1)/2.

Consequently S(B_1^d)/sqrt(d) tends to infinity.

This result does not refute the Euclidean conjecture
S(B_2^d)=O(sqrt(d)).

## Explicit family

Put r=d-1. Choose an odd integer K at least max(1,r/2), and set
tau_K=1-r/(2K). Use the first r coordinate vectors, together with K
separately indexed copies of each of

    a=(-1/(2K),...,-1/(2K), tau_K)
    b=(-1/(2K),...,-1/(2K),-tau_K).

Every vector has l1 norm one, and the indexed family sums to zero.

## Universal permutation proof

Fix any ordering and stop immediately after exactly K dense vectors have
appeared. Every one of the first r coordinates is then either 1/2 or -1/2,
so these coordinates contribute exactly r/2.

If A vectors of type a and B vectors of type b have appeared, then A+B=K.
Since K is odd, A-B is nonzero. The last coordinate therefore has absolute
value at least tau_K, and the selected partial sum has l1 norm at least

    (d+1)/2 - (d-1)/(2K).

Letting odd K tend to infinity proves the lower bound.

## Review status

An independent mathematical review checked the source quantifier, the
construction, the unit-ball and zero-sum conditions, the stopping argument,
and the Euclidean scope boundary. A separate review checked the atomic audit
integration.

## Primary references

- American Institute of Mathematics, Hereditary Discrepancy and Related
  Topics, Problem 1.4.
- V. S. Grinberg and S. V. Sevastyanov, Value of the Steinitz Constant,
  Functional Analysis and Its Applications 14 (1980), 125–126.
- G. Ambrus and R. Heck, A Note on the Steinitz Lemma,
  arXiv:2505.09465.
