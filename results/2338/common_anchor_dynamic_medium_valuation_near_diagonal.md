# Dynamic medium-prime valuation: near-diagonal boundary

## Result and scope

Write

```text
H_t=sum_(j<=t) a_j,  D_t=sum_(j<=t) b_j,
S_t=H_t+D_t,         H=H_3, D=D_3, S=S_3.
```

For every fixed real `epsilon` with `0<epsilon<121/50`, consider an
unbounded sequence of legal three-block integer tuples satisfying

```text
S -> infinity,  S/L -> 0,
0 <= Y-L <= (121/50-epsilon)S,
```

and the three reviewed upper logarithmic slope-window inequalities. For all
sufficiently large members, define non-circularly

```text
Q=product_(r=D+1)^S (Y+r),
p=P(Q),
```

where `P` is greatest prime factor. Then

```text
p>S  and  Phi_(p,3)>0.                              (1)
```

This excludes every fixed subcritical near-diagonal band from a family that
balances `Phi_(p,t)` for all `p>S`. In particular, the reviewed six-endpoint
pseudomodel with `Y=L=n^3` cannot satisfy the new valuation condition.

This is a partial positive theorem, not the full requested dichotomy. It
does not select a mismatch throughout the remaining region
`Y-L >= (121/50-o(1))S`, and it does not construct an all-`p>S` balanced
pseudomodel there. Exact common-anchor chains and the multiplicity
counterexample remain open.

## Complete prefix valuation

For

```text
c_q(u,m)=floor((u+m)/q)-floor(u/q),
```

the complete prefix difference is

```text
Phi_(p,t)=sum_(e>=1) [
  c_(p^e)(Y,S_t)
 -c_(p^e)(L-H_t,H_t)
 -c_(p^e)(Y+L,D_t)
].
```

Thus `Phi_(p,t)` is the full `p`-adic valuation of the middle prefix
product minus those of the low and high prefix products. No `v_p=1`
restriction or layerwise matching is imposed.

The previously reviewed six endpoint congruences are reused rather than
reproved. Claim
`K-COMMON-ANCHOR-FULL-PREFIX-CONGRUENCE-NONCLOSURE` already has independent
Reviewer support in `research/MATH_STATE.json`; its proof and exact replay
remain in `research/common_anchor_full_prefix_congruences_*`.

## 1. The high block has negligible cumulative length

Put

```text
Delta=Y-L,  x=S/L,  C=221/50.
```

The hypothesis gives `Delta+2S<(221/50)S`. At step `j`,

```text
Delta_j=Y_j-L_j
       =Delta+S_(j-1)+H_(j-1)
       <CS.
```

The reviewed upper slope window is

```text
b_j/a_j
 <= log((Y_j+a_j)/(L_j-a_j+1))
    / log((Y_j+L_j+b_j)/(Y_j+a_j+b_j)).            (2)
```

For `x<=1/100`, the numerator in (2) is at most

```text
(321/50) S/(L-S).
```

Indeed, its `log(1+z)` numerator is
`Delta_j+2a_j-1<(321/50)S`, while its denominator is greater than
`L-S`.

For the denominator in (2),

```text
(L_j-a_j)/(Y_j+a_j+b_j)
 >= (L-S)/(L+(171/50)S)
 >= 9/10.
```

The elementary bound `log(1+z)>=z/(1+z)` therefore makes that logarithm
at least `9/19`. Exact rational simplification gives

```text
b_j/a_j
 <= (2033/150) x/(1-x)
 < 14x.                                             (3)
```

Summing (3) yields

```text
D<14xH,  H>S/(1+14x),  D/S -> 0.                   (4)
```

This uses only the already reviewed upper windows; no original product
failure is consulted.

## 2. Elementary uniform prime escape

The replacement input is proved here, without the imported `4.42k`
assertion. It is an elementary repair, not a new publishable research
claim.

**Lemma (`K-COMMON-ANCHOR-SUFFIX-PRIME-ESCAPE`).** For every real `C>0`,
put

```text
d=max(1,C),  r=ceil(36d),  T=2^r.
```

For all integers `N>=k>=T` with `N/k>=T`,

```text
P(product_(j=0)^(k-1)(N-j))>Ck.                    (5)
```

Thus, for every fixed `C>0` and every sequence of integer pairs
`N_i>=k_i>=1` with `k_i->infinity` and `N_i/k_i->infinity`, (5) holds
eventually. The two thresholds depend only on `C`, not on `N` or on the
sequence. No assertion for merely `N>4k`, or for a varying `C`, is used.

### 2.1 An elementary prime-counting bound

Write `theta(x)=sum_(p<=x) log p` and `pi(x)=#{p<=x}`. For every integer
`j>=1`, each prime in `(2^(j-1),2^j]` divides
`binomial(2^j,2^(j-1))<2^(2^j)`. Hence, if `x>=2` and `m` is the least
integer with `2^m>=x`,

```text
theta(x)<=theta(2^m)
        <=sum_(j=1)^m 2^j log 2
        <2^(m+1) log 2
        <4x.
```

Split the primes at `sqrt(x)`. There are at most `sqrt(x)` below that
point, and every prime above it contributes more than `(log x)/2` to
`theta(x)`. Consequently

```text
pi(x)<=sqrt(x)+2theta(x)/log x<=9x/log x.           (6)
```

Here `log x<=sqrt(x)` for `x>=2`: the minimum of
`sqrt(x)-log x` is `2-log 4>0`, since `log 2<1`. Both
`1/2<log 2<1` follow directly by integrating `1/t` over `[1,2]`.
This proves (6); no prime number theorem or unproved prime interval
estimate is being imported.

### 2.2 The binomial primary-component bound

Let `B=binomial(N,k)`, where `N>=k>=1` are integers. For each prime `p`,

```text
v_p(B)=sum_(e>=1) [
 floor(N/p^e)-floor((N-k)/p^e)-floor(k/p^e)
].
```

Every summand is zero or one and vanishes when `p^e>N`. Therefore
`p^v_p(B)<=p^floor(log_p N)<=N`. Also,

```text
B=product_(j=0)^(k-1) (N-j)/(k-j)>=(N/k)^k,
```

because each factor is at least `N/k`. If the numerator product has no
prime above `dk`, neither does its integer divisor `B`, so, with
`q=pi(dk)`,

```text
(N/k)^k<=B<=N^q.                                  (7)
```

These are complete primary components, not squarefree parts; higher
prime powers have not been discarded.

### 2.3 Uniform thresholds

Suppose that (5) fails. Its numerator product then has all primes at
most `Ck<=dk`. Since `k>=T` and `d>=1`, (6) gives

```text
log k>=r log 2>r/2>=18d,
q<=9dk/log(dk)<=9dk/log k<k/2.
```

Taking logarithms in (7) and writing `R=N/k` yields

```text
(k-q)log R<=q log k,
log R<=q log k/(k-q)<18d<log T.
```

This contradicts `R>=T` and proves the lemma with the stated uniform
quantifiers.

### 2.4 Eventual applicability at the suffix

Use the lemma with `C=221/50`, `k=H`, and `N=Y+S`. Indeed,
`Q=product_(j=0)^(H-1)(N-j)`. Formula (4) and the original hypotheses
give the two required limits separately:

```text
H>S/(1+14S/L)->infinity,
(Y+S)/H>=L/S->infinity.
```

The first follows from `S->infinity` and `S/L->0`; the second uses
`Y>=L` and `H<=S`. Here `r=ceil(36*221/50)=160`. Thus eventually
`H>=2^160` and `(Y+S)/H>=2^160`, regardless of how slowly either limit
diverges. The lemma gives

```text
p=P(Q)>(221/50)H.
```

If additionally

```text
x<25 epsilon/1547,
```

then (4) gives

```text
p>(221/50)(1-14x)S
  >(221/50-epsilon)S
  >=Delta+2S.                                      (8)
```

As `x=S/L->0`, both explicit smallness conditions hold eventually.

Choose `r` with `D<r<=S` and `p | Y+r`. If `p` divided a low factor
`L-u`, where `0<=u<H`, then it would divide the positive difference

```text
(Y+r)-(L-u)=Delta+r+u,
```

which is strictly below `Delta+2S<p`. This is impossible.

If `p` divided a high factor `Y+L+d`, where `1<=d<=D`, then it would
divide

```text
2(Y+r)-(Y+L+d)=Delta+2r-d.
```

Because `r>D>=d`, this integer is positive, and it is again strictly below
`Delta+2S<p`. Thus `p` divides neither right-hand prefix interval. It
divides exactly one middle factor because `p>S`, and with its complete
exponent, so

```text
Phi_(p,3)=v_p(Y+r)>0.
```

This proves (1), including all higher `p`-adic powers.

## 3. Retired imports and their exact counterexamples

Neither of the following imported formulations is a dependency:

```text
SHOREY-TIJDEMAN-2016-NAIR-SHOREY-4.42:
  n>4k implies P(n(n+1)...(n+k-1))>(221/50)k.
SHOREY-TIJDEMAN-2016-NAIR-SHOREY-4.42-KGE3:
  k>=3 and n>4k imply the same inequality.
```

Both are false as stated. Independent Reviewer handoff
`608a1fbefc11/round-0001.json` and the unchanged
`research/literature/reviewer_prime_factor_domain_check.txt` give

```text
n=14, k=3: 14*15*16=3360=2^5*3*5*7,
           50*7=350<663=221*3.
n=24, k=4: 24*25*26*27=421200=2^4*3^4*5^2*13,
           50*13=650<884=221*4.
```

Each example satisfies `k>=3` and `n>4k`, and therefore refutes both
formulations. Their source-attribution and refutation records remain in
the ledger history. A source printing a statement does not prove that
statement. Section 2 instead supplies the restricted-domain input actually
needed: both the length and the endpoint-to-length ratio tend to
infinity. No missing hypothesis of the inaccessible Nair--Shorey
original is guessed, and there is no remaining external prime-factor
assumption on this claim.

The separately reviewed `C-PRIME-SUPPORT-EVENTUAL-UNIFORM`, its proof,
independent acceptance, verified originality and publishable significance
are unchanged. It does not depend on either retired formulation. This
repair asserts neither new publishable research nor campaign completion.

## 4. Exact replay and the fixed-constant boundary

For the reviewed `n=200` six-endpoint family,

```text
Y=L=8000000, S=120000, D=2400, H=117600.
```

The first suffix integer is `8002401`; the concrete factor

```text
p=8002409=Y+2409
```

is prime, exceeds `S`, and has exact prefix differences

```text
(Phi_(p,1),Phi_(p,2),Phi_(p,3))=(1,1,1).
```

Jacobian operation `integer.factor.certified_compute` returned `COMPLETE`
with the one factor `8002409^1` and a Pratt certificate. The inspected
contract, exact payload, typed output, server `0.14.0`, protocol
`2025-11-25`, and adapter status are preserved in
`research/common_anchor_dynamic_medium_valuation_jacobian_*.json`. This
bounded call is only a sample cross-check.

The additional bounded Jacobian call factors `3360`, the first retained
counterexample. Its exact discovery, inspected contract, payload, typed
output and adapter status are in
`research/literature/common_anchor_suffix_escape_jacobian_*.json`.
It checks that integer only, not the asymptotic lemma.

Run the directly affected replay with

```text
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/common_anchor_dynamic_medium_valuation_certificate.py \
  --dependencies-only
```

This checks the two refutations, exact primary-component and dyadic
binomial regressions, uniform-threshold constants, and current proof
dependencies. It preserves the accepted rational-bound, `n=200` sample,
and original Jacobian certificate fields without replaying them.
Without that flag the original checks are also available. The finite
checks do not prove the universal lemma; its proof is Sections 2.1--2.3,
and independent mathematical review is required.

For this note's fixed choice `C=221/50`, the lower bound alone does not
select a mismatch when `Delta >= (121/50-o(1))S`: either possible
common-divisor difference `Delta+r+u` or `Delta+2r-d` can reach the
comparison bound `(221/50)H`. The elementary lemma also permits other
fixed constants, so this is not an intrinsic upper limit on all uses
of prime escape. It does not permit substituting a parameter-dependent
`C` into an eventual assertion without checking its thresholds. No
exclusion for arbitrary growing `Delta/S`, balanced far-center family,
or full common-anchor exclusion is claimed here.
