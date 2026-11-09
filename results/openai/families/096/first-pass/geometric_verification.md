# Exact verification of the Gaussian propeller geometric core

## Scope and theorem

This audit excludes the kernel-clustering application. It separates the
finite-dimensional algebraic obstruction from the analytic reduction and
its two external theorem inputs. The upstream comparator's proof placeholder
is not used as either support or refutation.

The kernel-certified strengthened algebraic obstruction is as follows.
Let `m >= 5`, and let `r_1 >= ... >= r_m > 0`, with
`sum r_i^2 = 1`, `r_i <= 2/3`. Let `sum P_i = 1` and
`P_i >= A r_i^2`, `P_i >= .415 r_i + .15 r_i^2`.
Use `A=.929` for `m=5` and `A=.884` for `m>=6`.
Put `t=r_m`, `u=r_3`, and `L=r_1^2+r_2^2`.
Then the following two *weaker* determinant constraints are inconsistent:

```
(u^2-t^2)(L-u^2-2t^2) <= 8 (23/25) t^2,
(3/2)(u^2-t^2)^2       <= 10 (23/25) t^2.
```

In particular this implies the manuscript's obstruction, because
`(3/pi)^2 < 23/25`. All decimals here denote exact rationals.
The exact script checks arithmetic, identities, and the freshness of the
archived compiler result; it does not itself rerun Lean. Universal
quantifiers are certified by the completed Lean theorem. The official
Lean 4.31.0 run returned `exit_code=0`, `audit_exit_code=0`, and
`proof_holes=[]`, and the ledger derives `C_OBSTRUCTION: closed_kernel`.
Independent mathematical Reviewer acceptance is a separate requirement.

## Analytical bridge from arbitrary partitions

**Attainment and dimension.** Given a finite partition of `R^d` with `k`
cells, set `n=max(d,k-1,4)`, take its product with `R^(n-d)`, and append
empty cells to obtain `n+1` labels. Orthogonal Gaussian products preserve
the first moments and their squared-norm sum. For this fixed optimization
problem let `C` be the supremum. Cellwise Cauchy--Schwarz gives `C<=n`.
Norm duality and assigning each point to a maximum linear score give

```
sqrt(C) = max_{sum ||v_i||^2=1} E max_i <v_i,g>.
```

The expectation is continuous on the compact sphere of lists: the
difference of maxima is bounded by `||g|| max_i ||v_i-w_i||`, which is
integrable. A maximizing list's score partition has moment norm at least
`sqrt(C)`, so the supremum is attained. For every shorter list, the same
score-partition argument and Cauchy--Schwarz give
`E max_i <v_i,g> <= sqrt(C) (sum ||v_i||^2)^(1/2)`.
This statement involves the fixed supremum `C`, not the desired bound.

Choose an extremizer with the least number `m` of positive-measure cells.
Merging cells changes its objective by `2<z_i,z_j>`, so
`<z_i,z_j><0` for distinct active cells. In particular every active
centroid is nonzero. We have `sum z_i=0`, `sum ||z_i||^2=C`, and
`E max_i <z_i,g>=C`; the nonnegative difference between the maximum and
the assigned score therefore vanishes almost everywhere. Distinct score
ties lie in Gaussian-null hyperplanes. Thus the active cells have
representatives `K_i={x:<z_i-z_j,x> >=0 for all j}`.

The Gram matrix `Q` has zero row sums and

```
a^T Q a = sum_{i<j} (-<z_i,z_j>)(a_i-a_j)^2.
```

Its kernel consists precisely of constant vectors. Hence the centroid
span `V` has dimension `m-1`, every proper centroid subset is independent,
and the differences from any fixed centroid form a basis. Orthogonal
Gaussian decomposition projects the partition to `V` without changing
moments. If `m<=4`, extend it to `R^3`; HJN Theorem 1.1 then gives the
desired bound. Thus a counterexample with `C>B^2=9/(8pi)` has `m>=5`.
The source actually read for this external input is arXiv:1112.2993v2,
Theorem 1.1, p. 2; its exact statement and Gaussian normalization are
preserved in `research/literature/`.

**The scalar inequalities.** Normalize `r_i=||z_i||/sqrt(C)` and set
`P_i=gamma(K_i)`. All radii and probabilities are positive, both relevant
sums equal one, and `P_i<=1/2`: on a winning cell the winning score is
nonnegative because the scores sum to zero.

For a fixed direction `e=z/||z||`, the upper halfspace of mass `P`
maximizes the first moment in that direction. Subtracting its threshold
times the equal masses makes this the pointwise inequality
`(<e,x>-a)(1_K-1_H)<=0`. Consequently `||z||<=phi(a)` and `r<2/3`.
Also
`P/r^2 >= (9/4)exp(a^2)Phi(-a)`.
For `M(a)=phi(a)/Phi(-a)`, differentiation gives
`M'=1-Var(Z|Z>a)<1`. The logarithmic derivative `2a-M(a)` is strictly
increasing; its certified opposite signs at `.6119,.6121` locate the
unique minimum. The exact appendix enclosures give a global minimum
larger than `.8843837`, hence `P>=.884 r^2`.

When `m=5`, the span is four-dimensional. Write `g=RU` with `U` uniform
on `S^3`, independent radius with `E R=3 sqrt(2pi)/4`. Spherical upper-cap
rearrangement yields

```
p(x)=1/2-(arcsin(x)+x sqrt(1-x^2))/pi,
P/r^2 >= R(x)=(9/4)p(x)/(1-x^2)^3,  0<=x<1.
```

For `F=6xp-(2/pi)(1-x^2)^(3/2)` and
`H=p-(x/pi)sqrt(1-x^2)`, one has
`R'=(9/4)F/(1-x^2)^4`, `F'=6H`,
`H'=(4x^2-3)/(pi sqrt(1-x^2))`.
The signs and endpoint values imply one interior zero of `F`, the
minimum of `R`. It lies in `(.29,.294)`. The certified value and
derivative bound imply `min R>.9311326>.929`.

For the deletion estimate set `alpha=m/(m-1)`.
Deleting `z_i` and recentering the remaining scores changes their
squared norm sum to `C-alpha||z_i||^2`. The shorter-list inequality gives

```
E (X_i-max_{j!=i}X_j)_+ >= C(1-sqrt(1-alpha r_i^2)).
```

The differences `z_i-z_j` form a basis, so there is a unique `h` in `V`
with `<h,z_i-z_j>=1`. Summing these equations gives
`<h,z_i>=1/alpha`. The probability of a gap at least `v` is
`p_i(v)=gamma(K_i+v h)`, with
`p_i'(0)=-integral_K <h,x> dgamma=-1/alpha`.
Differentiation under the translated Gaussian integral is justified by
a Gaussian integrable majorant on each bounded translation interval.
The cone is proper, closed, convex, and full-dimensional (the difference
map is invertible), so every translate has measure in `(0,1)`.

Borell's published Theorem 1.1, p. 663, supplies Ehrhard's inequality.
Convexity gives the exact identity
`lambda(K+x)+(1-lambda)(K+y)=K+lambda x+(1-lambda)y`.
Thus `Phi^(-1)(p_i(v))` is concave. Its tangent at zero implies
`p_i(v)<=Phi(q-v/(alpha phi(q)))` for `v>=0`,
where `q=Phi^(-1)(P_i)`. Integration gives

```
E (X_i-max_{j!=i}X_j)_+
 <= alpha phi(q)(q Phi(q)+phi(q)).
```

Define `G(q)=phi(q)(q Phi(q)+phi(q))/Phi(q)^2`.
The resulting constraint is
`P_i^2 G(Phi^(-1)(P_i)) >= B^2 r_i^2/(1+sqrt(1-r_i^2))`.
Here rationalization uses `alpha>=1`, not a reversed inequality.

For completeness, write `lambda=phi(q)/Phi(q)` and
`V=1-q lambda-lambda^2=Var(Z|Z<=q)`. Then `G=1-V` lies in `(0,1)`.
For `U=q-Z` conditioned on `Z<=q`, the survival function is
`S(v)=Phi(q-v)/Phi(q)`. Log-concavity of `Phi` implies
`S(v+w)<=S(v)S(w)`. Tonelli's theorem yields
`E U^2/2 <= (E U)^2`, hence `V<=(q+lambda)^2`.
Differentiating gives
`V'=lambda((q+lambda)^2-V)>=0`, so `G` is nonincreasing.
For `q<=0`, both positive factors of
`phi(q)(q Phi(q)+phi(q))` are increasing. Therefore
`P^2G(Phi^(-1)(P))` is increasing for `P<=1/2`.
The ten exact intervals and nine quantile brackets in `exact_certificate.json`
prove, on the full interval `0<r<=2/3`, that the test value
`P_0=(.415+.15r)r` violates the implicit constraint strictly.
It follows that `P_i>P_0(r_i)`. These are interval covers, not samples.

**Residual determinants, including nondegeneracy.** Choose the smallest
centroid, put `e=z_m/||z_m||`,
`a_j=-<z_m,z_j>/||z_m||^2`, and
`w_j=z_j/sqrt(C)+a_j t e`. Then `a_j>0`, `sum a_j=1`,
`w_j` is orthogonal to `e`, and `sum w_j=0`. With
`T=<e,g>`, `Y_j=<w_j,g>`, the residual vector is independent of `T`, and

```
X_j/sqrt(C) = -a_j t T+Y_j,
H_jk = <z_j,z_k>/C-a_j a_k t^2.
```

In particular the off-diagonal entries are strictly negative and the
row sums vanish. A dependence between two residual vectors would give
a dependence between the corresponding two centroids and `z_m`,
contradicting proper-subset independence. Thus
`D_jk=sqrt(H_jj H_kk-H_jk^2)>0`.

The smallest cell `K` satisfies
`E[1_K T]=sqrt(C)t>Bt`, `E[1_K Y_j]=0`.
It lies in `T>=0, Y_j<=(1+a_j)tT`. Put
`U=Y_j/((1+a_j)t)`, `W=Y_k/((1+a_k)t)`.
Their joint density is at most
`M=t^2(1+a_j)(1+a_k)/(2pi D_jk)`.
Adding the two zero moment identities and taking a positive part gives

```
E[1_K T] <= E[1_{T>=0,U<=T,W<=T}(T+U+W)_+].
```

For `T=s>=0` the unweighted planar integral is
`integral_{a,b>=0}(3s-a-b)_+ da db=(3s)^3/6`.
Using independence and `E T_+^3=2/sqrt(2pi)` therefore proves
`D_jk<(3/pi)t(1+a_j)(1+a_k)`.
No sign of a covariance is discarded before its use, and no singular
Gaussian density is invoked.

Set `h_j=H_jj`. Zero row sums and negative off-diagonals imply
`H_31^2+H_32^2<=h_3^2`, so
`D_31^2+D_32^2>=h_3(h_1+h_2-h_3)`.
Using `h_3>=u^2-t^2` and
`h_1+h_2-h_3>=L-u^2-2t^2` proves the first lower bound when the
second factor is nonnegative; otherwise the claimed lower bound is
nonpositive and automatic. The pair upper bounds sum to at most
`8(3/pi)^2 t^2`, by
`8-(1+x)^2((2-x)^2+1)=(1-x)^2(3-x^2)>=0`.

For the first three standardized residuals, positivity of the covariance
matrix gives `sum rho_jk>=-3/2`. Since `-1<=rho_jk<=0`,
`sum rho_jk^2<=3/2`. Therefore
`sum_{j<k<=3}D_jk^2 >=(3/2)(u^2-t^2)^2`.
The corresponding pair upper-bound coefficients sum to less than ten:
with elementary symmetric functions `s_1,s_2,s_3` in `a_1,a_2,a_3`,

```
sum_{j<k}(1+a_j)^2(1+a_k)^2
=3+4s_1+2s_1^2+2s_1s_2+s_2^2-(6+2s_1)s_3
<=88/9<10.
```

Here `0<=s_1<=1`, `0<=s_2<=1/3`, and `s_3>=0`.
This gives precisely both determinant constraints used by the obstruction.

## A rational, root-free elimination

Let `delta_i=P_i-A r_i^2>=max(0,e(r_i))`, where
`e(x)=.415x-(A-.15)x^2`, and let `b=1-A`.
The total excess is `b`.

First use the weaker common coefficient `.884`, for which the excess
budget is `.116`. Summing over `j>=3` gives
`(1-L)(.415-.734u)<=.116u`. Since `L<=8/9`, this implies `u>.23`;
at `u=.23` the contradiction margin before multiplying by `u`
is exactly `101/34500`.
If `t<=.066` and `u>=.44`, normalization and ordering give
`L>=2u^2`, contradicting the first determinant constraint.
If `.23<u<.44`, the four intervals in the certificate give
positive uniform bounds for `L-u^2-2t^2`; multiplying by the positive
lower bound for `u^2-t^2` contradicts that determinant constraint.
These comparisons remain strict for `23/25`. Hence `t>.066`.

The following rational parameters avoid the manuscript's quadratic-root
localizations altogether:

| A | k | K | v | R | T |
|---|---|---|---|---|---|
| .929 | 2 | .341 | .2837 | .533 | .108 |
| .884 | 3 | .31 | .319 | .566 | .118 |

For all `x>=.42`, `delta>=K(v-x^2)` whenever
`delta>=0` and `delta>=e(x)`. On `[.42,R]` this follows because
`e(x)-K(v-x^2)` is a concave quadratic, positive at both endpoints.
For `x>=R`, use `R^2>v`.
If the fourth radius exceeded `.42`, apply this bound to the first
four radii. Each of `k-1` further radii is at least `t>.066` and at
most `1/sqrt(5)<.448`. On `[.066,.448]`,
`e(x)>=e(.066)`, since `.415 >= (A-.15)(.066+.448)`.
Normalization and the excess budget then imply

```
b >= K(4v-1+(k-1)(.066)^2)+(k-1)e(.066) > b,
```

a contradiction. Thus every radius after the first three is at most
`.42`. There are at least `k` such radii.
Both `k e(T)>b` and `k e(.42)>b`. Concavity excludes `t>=T`.
Also `e` is increasing on `[0,T]` and `e(.42)>e(T)`, so each of
those `k` tail radii has excess at least `e(t)`.

If `u^2<=2.6t`, let `w=sqrt(2.6t)`. Then `.23<u<=w`.
Both `e(.23)+k e(t)>b` and `e(w)+k e(t)>b` throughout
`.066<=t<=T`. For the latter, use the affine chord joining rational
lower enclosures `.4142` of `sqrt(2.6*.066)` and respectively
`.5299` or `.5538` of `sqrt(2.6T)`. The chord lies below the square
root. Substitution leaves a concave quadratic in `t` with positive
endpoint margins, all checked exactly by the script.
Concavity of `e` on `[.23,w]` now gives `e(u)+k e(t)>b`,
contradicting the budget. Therefore `u^2>2.6t`.

Finally `0<t<.12` yields

```
(3/2)(u^2-t^2)^2 > (3/2)(2.6-.12)^2 t^2
                 = (10(23/25)+16/625)t^2.
```

The second relaxed determinant bound says the left side is at most
`10(23/25)t^2`. The positive margin `16/625` is exact.
This is the universal obstruction, not a bounded cell-count search.

## Evidence boundaries

`verify.py` uses only the Python standard library: rational intervals,
integer square roots, finite Taylor bounds with signed remainders,
Machin's formula, and exact polynomial coefficients. It validates the
analytic interval cover and the rational elimination margins. The
Jacobian adapter's separate typed result is an exact determinant
calculation; it is not itself a universal inequality proof.

The complete all-dimensional partition conclusion additionally uses
the analytic arguments above and the two explicitly cited literature
theorems. Lean certification of the obstruction is not certification
of Gaussian measure theory or a proof of either external theorem.
No refuted manuscript assertion has been established by the current
audit, and no independent Reviewer judgement is fabricated here.

The certificate also includes two exact hypothesis sanity checks, neither
presented as a partition. Five explicit rational radii on the unit sphere
admit probabilities satisfying all scalar bounds (even `P_i<=1/2`), but
violate both determinant constraints. Conversely, nine equal radii `1/3`
with probabilities `1/9` make both determinant left sides zero but violate
the linear-quadratic bound. Thus the obstruction genuinely combines
scalar and geometric information; the proof does not hide a contradictory
scalar-only premise or exclude equal-radius boundary cases by definition.

## Reproduction

From the campaign directory, `python3 verify.py` replays the exact
arithmetic and validates the current source/fidelity bindings of
`research/lean/certificates/C_OBSTRUCTION-c85a5dd2f266a26e.json`.
It explicitly reports that it has not rerun the compiler.
To reproduce the compiler check itself on this host:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify Main.lean \
  --statement-fidelity research/statement_fidelity.md \
  --claim C_OBSTRUCTION --project-root . --artifact-dir research/lean
```

The official adapter copies the supplied source and fidelity document
into `research/lean/` before compiling; the portable replay checks that
both copies are byte-for-byte identical to the supplied originals and
to the archived, compiler-hashed texts. The compiler's only reported
axiom dependencies are `propext`, `Classical.choice`, and `Quot.sound`.
The analytic argument and mathematical significance/novelty assessment
still await the Host-invoked independent Reviewer. No campaign-final
acceptance or independently verified novelty is claimed by this handoff.
