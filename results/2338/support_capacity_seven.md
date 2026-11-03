# Seven-prime support and exact primary offsets

For `a>=2`, let

`P(a)={(n,k):1<=k<=floor(n/2), C(n,k)=a}`,

`S(a)=P(a)\{(a,1)}`, `m(a)=|P(a)|`, and

`K(a)=max{k:(n,k) in S(a)}`.

Write

`a=product_{j=1}^s q_j^{e_j}`, `s=omega(a)`,

and set

`R(a)=max_j q_j^{e_j}`.

The two conclusions proved here are:

1. `m(a)=5 => omega(a)>=7`;
2. if `m(a)=5`, `q|a`, and `q>K(a)`, then the full primary
   component `q^v_q(a)` occurs at one unique exact offset in each of
   the four numerator blocks belonging to `S(a)`.

The first conclusion uses the previously reviewed theorems
`m(a)=5 => K(a)>=7`, the all-primary row window, and the exact search
result `a<=10^18 => m(a)!=5`.  The last result is reused here as the
existing certificate `research/t5_collision_search.json`; it is not
recomputed or enlarged.

## A monotonicity lemma

For fixed `k>6`, put

`F_k(x)=C(x,k)/x^6`.

For integers `x>=2k`,

`F_k(x+1)/F_k(x)
 = ((x+1)/(x+1-k)) (x/(x+1))^6`.

Bernoulli's inequality gives

`(x/(x+1))^6=(1-1/(x+1))^6
 >=1-6/(x+1)
 >1-k/(x+1)`.

Therefore `F_k(x+1)>F_k(x)`: for every fixed `k>6`, `F_k` is strictly
increasing on the integer range `x>=2k`.

We will also use that

`G(k)=C(2k,k)/(2k)^6`

is strictly increasing for integers `k>=17`.  Indeed,

`G(k+1)/G(k)
 = (2(2k+1)/(k+1)) (k/(k+1))^6
 >3(5/6)^6
 =46875/46656
 >1`.

Here `2(2k+1)/(k+1)>3` and
`k/(k+1)>=17/18>5/6`.

## Reduction under at most six prime divisors

Assume for contradiction that

`m(a)=5` and `s=omega(a)<=6`.                                (1)

Every primary component is at most `R=R(a)`, so

`a=product_j q_j^{e_j}<=R^s<=R^6`.                          (2)

Let `(n,K)` be the nontrivial occurrence with maximum lower index
`K=K(a)`.  The all-primary row window gives `R<=n`, while the
left-half convention gives `2K<=n`.  Fixed-column monotonicity and
(2) therefore give

`C(max(R,2K),K)<=C(n,K)=a<=R^6
                         <=max(R,2K)^6`.                    (3)

### First threshold: `K<=16`

If `K>=17`, monotonicity of `F_K` and then of `G` gives

`F_K(max(R,2K))>=F_K(2K)=G(K)>=G(17)>1`,

because the exact endpoint inequality is

`C(34,17)=2333606220 > 34^6=1544804416`.

This contradicts (3), so `K<=16`.  The reviewed lower-index theorem
gives `K>=7`.

### The reviewed search forces `R>1000`

The exact bounded search already proves that (1) implies
`a>10^18`.  If `R<=1000`, then (2) would instead give

`a<=1000^6=10^18`.

Hence

`R>1000`.                                                    (4)

In particular `R>2K`, so (3) becomes

`C(R,K)<=R^6`.                                               (5)

### Second threshold: `K=7`

Suppose `8<=K<=16`.  Since `R>=1001`, all these lower indices are in
the increasing half of row `R`, and

`C(R,K)>=C(R,8)`.

The monotonicity lemma and the exact endpoint calculation give

`C(R,8)/R^6>=C(1001,8)/1001^6>1`,

where

`C(1001,8)=24309361133156224125`

and

`1001^6=1006015020015006001`.

This contradicts (5).  Therefore

`K=7`.                                                       (6)

### Third threshold: `R<=5060` and `n<=5060`

With `K=7`, equation (5) says `F_7(R)<=1`.  The monotonicity lemma
applies to `F_7`, and the exact adjacent endpoint calculations are

`C(5060,7)=16781079746074800361920
 <5060^6=16784294883374656000000`,

`C(5061,7)=16804322238797895653280
 >5061^6=16804207045079784404361`.

Thus

`1000<R<=5060`.                                              (7)

For the maximum-lower-index occurrence, `a=C(n,7)`.  If `n>=5061`,
then (2) and (7) would give

`C(5061,7)<=C(n,7)=a<=R^6<=5060^6`,

contrary to the displayed endpoint inequalities.  Together with the
all-primary lower row bound, this proves

`1001<=n<=5060`.                                             (8)

## Exact finite kernel

The rerunnable program
`research/support_capacity_seven_certificate.py` factors every one of
the 4060 integers

`C(n,7)`, `1001<=n<=5060`.

It constructs the complete prime basis through 5060 by an exact
Eratosthenes sieve, computes every exponent with Legendre's formula,
checks every listed prime again by deterministic trial division, and
checks that every prime-power product equals the exact binomial
coefficient.  The full factorization of every row is stored in
`research/support_capacity_seven_certificate.json`.

The certificate has no row with at most six distinct prime factors;
its minimum is seven.  This contradicts (1) after (6)-(8), and proves

`m(a)=5 => omega(a)>=7`.                                     (9)

The already inspected Jacobian contract
`integer.compute.prime_factorization` was reused for one bounded
cross-check.  Through the required pinned executable it returned
status `COMPLETE` for

`C(1439,7)=2498317294565308967
 =41*239*359*479*719*1433*1439`

in 473 ms, exactly matching the certificate's row 1439.  The reused
contract records Jacobian 0.14.0 and protocol `2025-11-25`; the exact
payload, typed output, and successful non-timeout process status are
stored in
`research/jacobian/support_seven_factor_payload.json`,
`research/jacobian/support_seven_factor_result.json`, and
`research/jacobian/support_seven_factor_execution.json`.  This sample
is not used to establish any other row or the finite kernel's
completeness.

This is a universal implication obtained from analytic reduction plus
an exhausted finite kernel.  It is not the claim that a larger
unstructured search failed to find `m(a)=5`, and it does not settle
`C-T5`.

## Unique exact primary offsets

Assume `m(a)=5`, and enumerate the four nontrivial occurrences as

`S(a)={(n_i,k_i):1<=i<=4}`.

Fix a prime `q|a` with `q>K(a)`, and put `e=v_q(a)>=1`.  For every
`i`, the denominator `k_i!` is coprime to `q`, while the numerator
block

`B_i={n_i-k_i+1,...,n_i}`

has length `k_i<q`.  Consequently `B_i` contains at most one multiple
of `q`.  Since

`v_q(C(n_i,k_i))=v_q(a)=e>0`,

it contains exactly one such term.  All other numerator terms and the
denominator have valuation zero, so that unique term has valuation
exactly `e`.

Equivalently, there is a unique offset

`d_i in {0,...,k_i-1}`

such that

`q^e | n_i-d_i` and `q^(e+1) does not divide n_i-d_i`.        (10)

Moreover `d_i<k_i<q<=q^e`, so (10) identifies the offset exactly:

`d_i = n_i mod q^e`, with `0<=d_i<k_i`.                      (11)

Thus the complete primary component `q^e`, not merely one factor
`q`, is placed at one unique exact offset in each of all four
numerator blocks.

As immediate support-count consequences of (9), if `K(a)<=10` then
at most the four primes `2,3,5,7` are at most `K(a)`, so at least
three prime divisors of `a` exceed `K(a)`.  If `K(a)<=12`, at most
`2,3,5,7,11` are at most `K(a)`, so at least two prime divisors
exceed `K(a)`.  Each such prime obeys (10)-(11) simultaneously in the
four blocks.
