# An explicit eleven-point distortion gap in real l1^5

## Result and provenance

**Theorem.** For any eleven distinct points in real five-dimensional l1,

```
max_{i<k} ||x_i-x_k||_1 / min_{i<k} ||x_i-x_k||_1
    > 3089/3084 > 1001/1000.
```

This is a universal lower bound, not an exact minimum or a matching
construction. The accepted rational upper bound remains `115/106`.
The proof below is self-contained in ordinary real analysis. Its arithmetic
is replayed by `python3 research/check_robust_clipping_gap.py`.
That replay is an exact algebraic certificate, not a Lean verification of
the entire analytic proof. Independent mathematical, novelty, and
publication-significance review is still required.

The starting method is Gallinger, *Kusner's Conjecture in l1^5 and l1^6*,
September 2026 v1, DOI
[10.5281/zenodo.22984024](https://doi.org/10.5281/zenodo.22984024):
Proposition 2.2, Lemmas 3.3-3.4, Propositions 4.1 and 5.3, and Remark 6.3.
In particular, the clipping method, reciprocal masses, test function, span
majorant, and exact-case margin `1709/882 < 2` are **not new** here.
The additional assertion is stability under nonnegative pair-distance
errors, leading to the displayed explicit distortion gap. The source's
exact-star hypotheses are not assumed for the perturbed configuration.
The accepted source compilation is reused, not repeated or extended to
cover this proof.

## 1. Stable terminal clipping

Let `n >= 2`, `m=2n+1`, and suppose

```
1 <= d_1(x_i,x_k) <= 1+epsilon        (i != k),
0 <= epsilon < 1/(2n).
```

For each coordinate, sort the original values with multiplicity and project
all values simultaneously onto the interval from the second to the
penultimate value. Denote the resulting points by `y_i`, and put

```
s_i = sum_j |x_ij-y_ij|,    r_i=1/2-s_i,
eta_ik=d_1(x_i,x_k)-1       (i != k).
```

A positive removed gap separates its unique extremal label from every other
label. Thus every pair loses exactly its two labels' displacements:

```
d_1(y_i,y_k)=r_i+r_k+eta_ik,    0 <= eta_ik <= epsilon.       (1)
```

This identity is not an exact star identity unless all the errors vanish.
Every clipped coordinate extremum is attained by at least two labels; an
original extremal label remains at the corresponding clipped extremum.
At most two labels move in each coordinate, so at least one label `p` is
untouched and `r_p=1/2`. These facts allow ties and constant coordinates.

For any three distinct labels `i,a,b`, the full triangle excess is

```
d_1(y_i,y_a)+d_1(y_i,y_b)-d_1(y_a,y_b)
    =2r_i+eta_ia+eta_ib-eta_ab.
```

Its nonnegativity first gives `r_i >= -epsilon`. Each coordinate triangle
excess is nonnegative and no larger than the full excess. If `y_ij` is not
the maximum in coordinate `j`, choose two distinct labels attaining that
maximum; neither is `i`. The coordinate excess is twice the distance from
`y_ij` to that maximum, and is at most `2r_i+2epsilon`. If `y_ij` is itself
the maximum, the same bound follows from `r_i+epsilon >= 0`.
The minimum is handled identically. Consequently,

```
|y_ij-y_kj| <= min(r_i,r_k)+epsilon.                         (2)
```

For `i != p`, (1), (2), and nonnegativity of `eta_ip` give

```
r_i+1/2 <= d_1(y_i,y_p) <= n(r_i+epsilon).
```

The same resulting lower bound also holds for `i=p`. Since `s_i >= 0`,

```
(1-2n*epsilon)/(2(n-1)) <= r_i <= 1/2.                     (3)
```

In particular all radii are strictly positive. Write

```
mu_i=1/r_i,    T=sum_i mu_i,    M=max_i mu_i.
```

Then

```
2 <= mu_i <= 2(n-1)/(1-2n*epsilon),
T <= 2(2n+1)(n-1)/(1-2n*epsilon).                           (4)
```

## 2. Endpoint accounting survives the perturbation

For each of the `2n` signed **original** coordinate ends `e`, assign `u_e`
equal to `mu_i` if that end has the unique original owner `i`, and equal to
`2` otherwise. Thus `2 <= u_e <= M`. If `mu_i>2`, then `s_i>0`, so `i`
moved and uniquely owned at least one original end. An end has at most one
owner; a label may own several ends. Counting the nonnegative excesses
`mu_i-2` therefore gives

```
T = 2(2n+1)+sum_i(mu_i-2)
  <= 2(2n+1)+sum_e(u_e-2) = sum_e u_e+2.                  (5)
```

The corresponding clipped endpoint group has mass at least `u_e+2`:
a unique owner remains there together with a second label of mass at
least `2`; a repeated original end supplies at least two labels of mass
at least `2`. For a constant coordinate the group is the whole family.
No disjointness of the two endpoint groups, or bound by `T/2`, is needed.

Let `L_j=max_i y_ij-min_i y_ij`. For either end `e=(j,+/-)`, apply (2) to
its owner and a label at the opposite clipped end. For a repeated original
end use `r_i<=1/2`. If the span vanishes the same bounds are immediate.
This proves

```
L_j <= 1/u_e+epsilon.                                      (6)
```

Choose a label of mass `M` and apply the endpoint-distance bounds proved
before (2) to both clipped ends. Their sum gives

```
L_j <= 2/M+2epsilon.                                       (7)
```

These are geometric inequalities; (5) alone does not assert an embedding.

## 3. Signed quadratic-error control

This section applies more generally to any `m>=2` points and positive
radii satisfying (1). In each coordinate choose an order, let `delta_jk`
be its nonnegative successive gaps, let `C_jk` be the prefix cuts, and
let `t_jk=sum_{i in C_jk} mu_i`. Zero gaps are retained or discarded
without changing any formula. Put

```
q_T(t)=t(T-t)/T,
E_j=sum_k delta_jk*q_T(t_jk).
```

Counting each separated pair gives, without a star assumption,

```
sum_j E_j = (1/T) sum_{i<k} mu_i*mu_k*d_1(y_i,y_k)
          = m-1 + (1/T) sum_{i<k} mu_i*mu_k*eta_ik
          >= m-1.                                         (8)
```

For real `f_i` with `sum_i mu_i*f_i=0`, write

```
a_i=mu_i*f_i,    N=sum_i mu_i*f_i^2,
Q=sum_{j,k} delta_jk*(sum_{i in C_jk} a_i)^2.
```

For a cut `C`, the signed sum over separated pairs is
`(sum_C a_i)(sum_notC a_i)=-(sum_C a_i)^2`. On the other hand,
the contribution from `r_i+r_k` to the signed pair sum is `-N`.
Expanding (1) in these two ways gives the exact identity

```
Q = N - sum_{i<k} a_i*a_k*eta_ik.                          (9)
```

Let `P=sum_{a_i>0} a_i=-sum_{a_i<0} a_i`.
Same-sign products contribute nonnegatively to the last sum in (9);
opposite-sign products give

```
sum_{i<k} a_i*a_k*eta_ik >= -epsilon*P^2.
```

Weighted Cauchy-Schwarz, with zero terms allowed, gives

```
4P^2 = (sum_i mu_i*|f_i|)^2 <= T*N.
```

Equivalently, the difference on the right is the nonnegative sum
`sum_{i<k} mu_i*mu_k*(|f_i|-|f_k|)^2`.
Combining these observations proves the stable quadratic inequality

```
Q <= (1+epsilon*T/4)*N.                                   (10)
```

The sign restriction `eta_ik>=0` is essential to this particular constant.
Replacing it by an absolute-error hypothesis without changing the
argument would not be justified.

## 4. The stable coordinate test and its span bound

Let `K=1+epsilon*T/4`. For any continuous piecewise-C1 function `F` on
`[0,T]` with `F(0)=F(T)=0`, define `f_i` in a chosen coordinate order
as the slope of `F` over the mass interval belonging to label `i`.
Telescoping gives weighted mean zero and prefix sum `F(t_jk)`.
Retaining that coordinate in the nonnegative sum (10), and applying
Cauchy-Schwarz to each mass interval, gives

```
sum_k delta_jk*F(t_jk)^2
    <= K*sum_k (F(t_jk)-F(t_j,k-1))^2/(t_jk-t_j,k-1)
    <= K*integral_0^T F'(t)^2 dt.                          (11)
```

Here the slopes include all `m` mass intervals, including the last one
ending at `T`; the gap sum has only `m-1` terms.

For completeness, the span test used in the cited source is verified
directly. Fix `R>1` and put

```
d=(R-1)/(R+1),    lambda=T*(1-d^2)/4,    tau=2*lambda.
```

Thus `0<d<1` and `0<tau<T/2`. Define

```
F(t) = d*t/(2*sqrt(lambda))                 on [0,tau],
       sqrt(q_T(t)-lambda)                 on [tau,T-tau],
       d*(T-t)/(2*sqrt(lambda))            on [T-tau,T].
```

On the central interval `q_T(t)-lambda >= lambda*d^2 > 0`.
Values and first derivatives agree at both junctions. On the central
interval `F^2+lambda=q_T`; on the left terminal interval,

```
F(t)^2+lambda-q_T(t)=(t-2*lambda)^2/(4*lambda) >= 0,
```

and reflection proves the same on the right interval.
The terminal Dirichlet energies sum to `d^2`. In the central integral,
substitute `u=(2t/T-1)/d` to obtain

```
integral_tau^(T-tau) F'(t)^2 dt
  = (d/2)*integral_-d^d u^2/(1-u^2) du
  = (d/2)*log((1+d)/(1-d))-d^2.
```

Therefore, writing

```
a(R)=(R-1)*log(R)/(2(R+1)),    b(R)=R/(R+1)^2,
```

we have `integral_0^T F'^2=a(R)` and `lambda=b(R)*T`.
Combining the pointwise bound with (11) proves

```
E_j <= K*a(R)+b(R)*T*L_j.                                 (12)
```

Only the Dirichlet term is multiplied by `K`; the additive span term
comes from the pointwise comparison and is not an exact-star assertion.
A constant coordinate has zero energy and satisfies the same estimate.

## 5. Average spans, including negative shifted spans

Return to the clipped `2n+1`-point configuration. Define

```
Lhat_j=L_j-2epsilon,    z=(sum_e u_e)/(2n),    w=z/M,
h(v)=min(2,3-2v),       Phi_n(M,w)=(2n*w+2/M)*h(w).
```

We have `2<=z<=M` and `0<w<=1`. Equations (6), (7) imply
`Lhat_j<=1/u_e` and `Lhat_j<=2/M`. A shifted span may be negative;
none of the following steps assumes otherwise.

For `0<v<=1`, `min(2,1/v)<=h(v)`: below `1/2` use the constant `2`,
and above `1/2` use
`3-2v-1/v=(2v-1)(1-v)/v>=0`. Hence

```
M*Lhat_j <= h(u_e/M).
```

Summing over the `2n` ends counts every shifted span twice. The sum of
minima is no larger than either affine sum, so

```
(M/n)*sum_j Lhat_j
  <= (1/(2n))*sum_e h(u_e/M) <= h(w).
```

Multiply by `T/M>0`, then apply (5), using `h(w)>=1>0`:

```
(T/n)*sum_j L_j <= Phi_n(M,w)+2epsilon*T.                  (13)
```

Finally `h(w)<=3-2w` and completing the square give

```
Phi_n(M,w)
 <= (2n*w+2/M)*(3-2w)
  = (3n+2/M)^2/(4n)
      -4n*(w-(3n-2/M)/(4n))^2
 <= (3n+2/M)^2/(4n)
 <= (3n+1)^2/(4n),                                        (14)
```

where the last step uses `M>=2`.
For `n=5`, (4), (13), (14) imply

```
T <= 88/(1-10epsilon),
(T/5)*sum_j L_j <= 64/5+176epsilon/(1-10epsilon).           (15)
```

## 6. Quantitative obstruction and exact threshold

Equations (8), (12)-(14) give the more general stability theorem

```
2 <= a(R)+b(R)*(3n+1)^2/(4n)
       +epsilon*T*(a(R)/4+2b(R)),
T <= 2(2n+1)(n-1)/(1-2n*epsilon).                          (16)
```

Now set `n=5` and `R=20`. The rigorous source bound `log(20)<3`
also has the elementary exact certificate

```
exp(3) > sum_{k=0}^8 3^k/k! = 89641/4480 > 20.
```

Thus `a(20)<19/14` and `b(20)=20/441`. Since `K>0`, (15)
and the average of (12) yield the **strict** inequality

```
2 < (1+22epsilon/(1-10epsilon))*(19/14)
      +(20/441)*(64/5+176epsilon/(1-10epsilon))
  = 1709/882+(16687/441)*epsilon/(1-10epsilon).
```

Multiplying by the positive denominator gives

```
55*(1-10epsilon) < 33374epsilon,
55 < 33924epsilon,
epsilon > 55/33924 = 5/3084.                              (17)
```

For eleven distinct real points, the smallest pair distance is positive.
Scale it to one and let `epsilon` be the actual aspect ratio minus one.
If `epsilon>=1/10`, the theorem is immediate. Otherwise all hypotheses
above apply and (17) proves it, including strict exclusion at the
endpoint `epsilon=5/3084`.
Finally `5/3084-1/1000=479/771000>0`.

No endpoint-incidence class is omitted: the proof uses actual coordinates,
not an endpoint-only relaxation, and neither enumerates nor assumes
anything about the 61 previously live endpoint cases. Arbitrary choices
within tied order blocks affect only zero-weight gaps. Constant
coordinates, coincident clipped points if they were to occur before
positivity is proved, and repeated original endpoint owners require no
generic-position assumption.

## Scope of the improvement

Gallinger excludes exact equilateral configurations and already supplies
the exact-case span margin. The previous campaign's elementary consequence
was `Delta >= 1+1/11^26`, conditional on equilateral exclusion. Here (17)
instead yields the explicit dimension-five lower bound directly from a
stable analytic obstruction, without invoking the equilateral-exclusion
theorem as a black box. The accepted upper bound `Delta<=115/106` is
unchanged. Neither this proof nor the bounded literature comparison
settles the exact value of `Delta`, maximality of the displayed constant,
or publication-level originality and significance.
