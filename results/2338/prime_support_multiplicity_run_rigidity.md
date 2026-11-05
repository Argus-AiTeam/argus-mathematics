# Two-row primary rigidity and an eventual uniform support bound

This is an Engineer proof submitted for independent review, not an accepted
publication or a kernel certificate. The proposed conclusion is unconditional:
there is an absolute `A0` such that

`a>=A0 => m(a)<=omega(a)`.                                      (T)

In particular it implies the live statement with `m(a)>=6`. Originality and
publishable significance remain unverified. The argument does not exclude
either surviving `K=8` system or prove multiplicity-five nonrealizability.

## 1. Definitions and the inherited baseline

For `a>=2`, let

`H={k>=1: C(n,k)=a for an integer n>=2k}`, `K=max H`,

`m=|H|`, `s=omega(a)`, `a=C(N,K)`, `L=log a`, `ell=log L`.

All logarithms are natural. Rows are unique within each column, so this `m`
is the required half-triangle multiplicity. A *violation* means `m>s`.
In particular `s<=K-1`. No support size is held fixed.

The only external analytic input is the already retained Kane bound: there
are absolute `M>0, A_K` such that

`m <= M*L*log(ell)/ell^3` for `a>=A_K`.                         (1)

The exact full-to-half correction and the primary source are in
`prime_support_multiplicity_vacancy.md`, Sections 1-2: Daniel M. Kane,
*Improved Bounds on the Number of Ways of Expressing t as a Binomial
Coefficient*, Integers 7 (2007), A53, DOI `10.5281/zenodo.8337164`,
Sections 5-7, equations (6)-(9) and the concluding bound on p.7.
This is a cited known theorem, not a new estimate.

We also use the reviewed elementary facts

`p^v_p(a)<=N` for every prime `p|a`, and `K<=L` for `a>=81`.     (2)

For completeness, the first follows directly from the factorial valuation
formula: each summand
`floor(N/p^j)-floor(K/p^j)-floor((N-K)/p^j)` is zero or one and is
zero when `p^j>N`. The second is the elementary central-binomial estimate
already proved in Section 2 of the retained vacancy note.

The new arithmetic step below is a polynomial ceiling on `N` for a
violation, in place of a support-dependent factorial ceiling.

## 2. Exact identities with arbitrary row gaps

For consecutive hit indices write

`C(n_i,k_i)=C(n_(i+1),k_i+1)=a`, `d_i=n_i-n_(i+1)>0`.

Strict decrease of the rows follows from strict increase in the lower
index within a fixed half-row and strict increase down a column. Dividing
the two complete factorial expressions gives, without a gap restriction,

`(n_i-k_i)_(d_i+1) = (k_i+1)*(n_i)_(d_i)`,                    (3)

where `x_r=x*(x-1)*...*(x-r+1)`. The legal next row gives
`n_i-d_i>=2(k_i+1)`, so every factorial used in the division is defined.
Factors appearing on both sides of (3) must not be counted as new prime
support. The argument below instead keeps every primary component of
the common coefficient `a`.

For every prime `p|a`, put `Q_p=p^v_p(a)`. When `p>K`, in each occurrence
`a=C(n,k)`, `k<=K`, the denominator is a `p`-unit, and the numerator
interval has length less than `p`. Consequently there is exactly one
`r_p in {0,...,k-1}` with

`Q_p | n-r_p`.                                                 (4)

The analogous statement holds in the complete maximum-index interval
`[N-K+1,N]`. This uses the full exponent in `a`, not merely a selected
prime or a congruence modulo its first power.

## 3. A two-interval rigidity lemma

**Lemma.** Let `k,K,N,n` be positive integers with `1<=k<=K`, `N>=2K`,
and `n>N+K`. A collection of pairwise coprime integers
`Q>sqrt(4*K*n)`, each dividing a number in both
`[n-k+1,n]` and `[N-K+1,N]`, has size at most `ceil(K/2)`.

**Proof.** Choose offsets `0<=r_Q<k`, `0<=s_Q<K` and positive integers

`b_Q=(n-r_Q)/Q`, `c_Q=(N-s_Q)/Q`.

For two members `Q,R`, the integer `b_Q*c_R-b_R*c_Q` has numerator

`n*(s_Q-s_R)+N*(r_R-r_Q)+r_Q*s_R-r_R*s_Q`.

Its absolute value is less than `3*K*n`, whereas `Q*R>4*K*n`.
Thus this integer is zero. All positive vectors `(b_Q,c_Q)` therefore
lie on one rational ray. Dividing one vector by the gcd of its entries
gives coprime positive integers `u,v`; Euclid's lemma then gives

`b_Q=u*h_Q`, `c_Q=v*h_Q`, `h_Q` a positive integer.             (5)

Distinct members have distinct offsets in each interval: otherwise their
coprime product, which exceeds `4*K*n>n`, would divide the same positive
integer at most `n`.

If there were more than `ceil(K/2)` members, the first interval would
contain more than `ceil(K/2)` distinct multiples of `u`. Since its
length is `k<=K`, this forces `u=1`. The second interval likewise
forces `v=1`. Equation (5) now says

`n-r_Q=N-s_Q`,

contrary to `n-N>K` and `r_Q-s_Q<K`. QED.

This is an exact integer determinant argument. It makes no assumption on
the row gap, on how the primes were chosen, or on an interpolation curve.
The auxiliary resultant described in Section 7 checks only the linear
elimination in (5), not the universally quantified lemma.

## 4. Row separation

If `K>=2`, `N>=4*K^2`, and `C(n,k)=C(N,K)` with `1<=k<K`, then

`n>N+K`.                                                       (6)

Indeed, monotonicity in the lower index gives
`C(N+K,k)<=C(N+K,K-1)`, and

`C(N+K,K-1)/C(N,K)`
` = K/(N-K+1) * product_(j=0)^(K-2) (1+K/(N-j))`
` <= K/(N-K+1) * (1+2*K/N)^(K-1)`
` <= 2*K/(N-K+1) < 1`.

The penultimate inequality uses `(K-1)*2*K/N<=1/2` and
`(1+x)^r<=1/(1-r*x)` for an integer `r>=0`, `x>=0`, `r*x<1`.
The latter follows by bounding each binomial coefficient by `r^j`
and summing a geometric series. Column monotonicity proves (6).

## 5. A polynomial maximum-row ceiling for every violation

**Proposition.** If `m>s`, then

`K>=2`, `N<K^100`, `L<100*K*log K`.                            (7)

**Proof.** A violation has `1<=s<m<=K`, so `K>=2`. The exact product
formula and (2) give

`(N/K)^K < a = product_(p|a) Q_p <= N^s`.                     (8)

The first inequality is strict since `K>=2` and `N>K`. If `K<=100`,
(8) gives `(K-s)*log N<K*log K`, hence `N<K^K<=K^100`.

Suppose instead that `K>=100` and `N>=K^100`. We show that these
conditions preclude a violation. First, (8) gives

`s >= 99*K/100`.                                               (9)

Fix any possible second hit `k` with `ceil(3*K/4)<=k<K`, with row
`n`. The product bound `C(n,k)>=(n/k)^k` gives

`n <= k*a^(1/k) <= K*N^(K/k) <= K*N^(4/3)`.                  (10)

Put `T=sqrt(4*K*n)`, and let `b` count *all* prime components
`Q_p<=T`, including those with `p<=K`. Since every `Q_p<=N`,

`L <= (s-b)*log N+b*log T`.

Meanwhile

`log T <= (2/3)*log N+log(2*K)`
`       <= (2/3)*log N+2*log K`
`       <= (103/150)*log N < (7/10)*log N`.

Combining this with (8) and `s<=K` yields

`b <= K*log K/(log N-log T) <= K/30`.                         (11)

Nothing has been dropped from the support product in this estimate.

There are at most `pi(K)<=K/3+2` primes of base at most `K`:
apart from 2 and 3, prime bases occupy only residues 1 and 5 modulo 6.
Thus the set

`G={p|a: p>K and Q_p>T}`

satisfies

`|G| >= s-b-pi(K) >= (187/300)*K-2 > ceil(K/2)`               (12)

for `K>=100`. These components are pairwise coprime and satisfy (4)
in both complete numerator intervals. Also `N>=K^100>=4*K^2`,
so (6) applies. The two-interval lemma contradicts (12).

Therefore no such second hit `k` exists. All hit indices belong to

`{1,...,ceil(3*K/4)-1} union {K}`.

It follows that

`m<=ceil(3*K/4)<=3*K/4+1<99*K/100<=s`,

again contradicting a violation. We conclude `N<K^100` in every
case. Finally `L<=s*log N<100*K*log K`, proving (7). QED.

The discarded components in (11)-(12) are explicitly charged: every
small component uses the bound `T`, every other component uses `N`,
and all excluded small prime bases are charged through `pi(K)`.
This is not a fixed-prime or partial-support relaxation.

## 6. Absolute cutoff, the requested run statement, and the squeeze

**Theorem.** There is an absolute `A0` such that (T) holds.

**Proof.** Enlarge `A_K` if necessary so that `A_K>=81`. At a violation
with `a>=A_K`, (7) and the stronger support version of (8) give

`L<=s*log N<100*s*log K<=100*s*ell`.

Together with `s<m` and (1), this implies

`ell^2 < 100*M*log ell`.                                       (13)

Let

`E=max(2,200*M,loglog A_K)`, `A0=ceil(exp(exp E))`.

For `ell>=E`, `log ell<ell` and `100*M*ell<=ell^2/2`,
contradicting (13). All constants and cutoffs depend only on the
absolute constants in the published multiplicity bound. They do not
depend on `s`, a row, or a chosen prime set. QED.

This proves the requested violation-conditioned run statement as a
corollary with `B=1` and this same absolute `E`: there are no violating
systems at all once `ell>=E`. It is explicitly a consequence of the
stronger two-row theorem, not an independent nonvacuous run estimate
for an existing survivor. No universal vacancy bound is claimed.

The reviewed squeeze supplies another direct closure, if retained in
its original form: writing `q=M*log(ell)/ell^2` and enlarging an
absolute `M` to cover both reviewed estimates, one has
`m>=K*(1-q)`. Equation (7) and (1) give `m<=100*q*K`.
Hence a violation would require `1<=101*q`, impossible eventually.
The prescribed run transfer
`N_window-V<=(V+1)*B*ell`, where
`N_window=K-ceil(K/2)+1`, remains a valid supporting implication;
it is not needed after the stronger polynomial row ceiling.

Compared with the strongest prior result in the retained vacancy note,
the new proposed improvement is (7), not the old conditional transfer
or the scalar squeeze. It removes the varying-support obstruction by
controlling the actual simultaneous numerator intervals.

## 7. Exact replay and review boundary

The dedicated `prime_support_multiplicity_run_jacobian_resultant_*.json`
files retain the inspected typed contract, exact payload, typed output,
and adapter execution status for `polynomial.multivariate.resultant.compute`.
The payload eliminates `t` from `u*t+r-n` and `v*t+s-N`; the expected
result is `u*(s-N)-v*(r-n)`, and the typed output agrees exactly.
The adapter exited zero in 3.472 seconds, with no outer timeout,
empty stderr and no structured error; server version is `0.14.0`,
protocol `2025-11-25`. This is only an algebraic corroboration of
the primitive-ray relation, not a certificate for (T).

The nonwriting replay command is

```bash
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/prime_support_multiplicity_run_verify.py
```

Its exact scope is the rational constant arithmetic, the cached linear
resultant and regression instances of (3) with gaps 104, 6 and 1.
It is not a finite search for a witness and does not infer a global
theorem from a bounded experiment. The universally quantified proof
is Sections 3-6 and requires an independent mathematical reading.

The focused lookup for an existing uniform `N_full<=2*omega` theorem
returned unrelated binomial-theorem material and even changed the
meaning of the multiplicity parameter. It supplied no usable primary
source and is not a dependency, a novelty check, or evidence of
absence. The previously retained AEH and King--Williams comparison
remains the known-result baseline; it is not replayed here.
Independent source attribution, proof review, originality assessment
and publishable-significance acceptance remain required.
