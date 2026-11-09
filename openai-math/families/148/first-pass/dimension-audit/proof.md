# Verification of the entropy-rate dimension formula

## Result and provenance

For every finite nonempty indexed family
`phi_i(x)=r_i*x+t_i` on the real line, with `0<|r_i|<1`, and every
strictly positive probability vector `p`, its self-similar measure satisfies

    dim_H(mu) = min(1, h_RW/chi),
    chi = -sum_i p_i log_2 |r_i|.

Equal complete affine maps are merged before defining `h_RW`. The proof
below allows unequal signed contractions, repeated indexed maps, arbitrary
positive weights, and exact collisions. It does not impose a separation
condition, including an ineffective exponential separation condition.

This is a complete **analytic verification**, using the previously reviewed
finite-law pair theorem. The new Lean source separately proves the universal
rounding and window-counting core. It does not formally prove the analytic
dimension theorem. Independent review of the present argument is pending.
Relative to the preceding mission, the advance is the passage from one
finite-law estimate to the full dimension formula, not its smaller constant.
Originality or publication-level significance is not asserted by the Engineer.

### Source locations

All section references below are under
`research/openai_manuscript/The-entropy-rate-dimension-formula-for-self-similar-measures-on-the-line-September-24-2026/build/sections/`.

| File | Assertions verified here |
|---|---|
| `introduction.tex` | `thm:main`, `eq:rate-and-lyapunov`, `sec:upper` |
| `entropy.tex` | `lem:entropy-calculus`, `lem:entropy-dimension`, `lem:nonsaturation`, `lem:two-point` |
| `types.tex` | `lem:type-deficit`, `prop:pair-bands` |
| `windows.tex` | `lem:conditional-gain`, `lem:disjoint-windows`, `eq:final-window-count`, completion of `thm:main` |

`verify.py` records the line of each of these labels in the staged sources.
This proof supplies the implications, rather than treating those labels as
assumptions.

## 1. Objects and the two imported results

All logarithms and entropies are in bits. Put
`r_max=max_i |r_i|<1` and `T_0=max_i |t_i|`. The coding series converges
uniformly, with absolute value at most `T_0/(1-r_max)`. Its law `mu`
satisfies the self-similarity identity. Products of slopes never vanish.

Let `G_n` be the complete affine map of an iid length-`n` word, with the
probabilities of equal maps added. Independent concatenation gives
`H(G_{n+m})<=H(G_n)+H(G_m)`. Consequently
`h=lim H(G_n)/n=inf_n H(G_n)/n`: indeed, writing a length as `qn+r`
proves that the upper limit is at most `H(G_n)/n` for every fixed `n`.
Also `0<=h<=H(p)` and `0<chi<infinity`.

**Exact dimensionality.** We use only the exact-dimensional consequence of
Feng-Hu, *Dimension theory of iterated function systems*, Theorem 2.8 of
`arXiv:1002.2036v1`. The journal cross-reference is CPAM 62 (2009),
1435-1500, DOI `10.1002/cpa.20276`; the citation in the ledger is bound to
the actual version read, not an unchecked journal-version locator.
The primary text actually read is `arXiv:1002.2036v1`, printed pp. 6-7,
Definitions 2.4-2.7 and Theorem 2.8; see `feng_hu.pdf` and
`feng_hu_excerpt.txt`. The theorem is stated for an `m`-conformal `C^1`
IFS, and its ergodic conclusion is constant local dimension.

Choose `R>T_0/(1-r_max)`. Every map preserves both `[-R,R]` and its open
interior and is a smooth contracting diffeomorphism onto its image.
The derivative norm and least singular value of every word map both equal
the absolute value of its signed slope. Their logarithmic averages converge
under Bernoulli coding. Thus the system is `m`-conformal in the precise
sense of Definition 2.7. Bernoulli coding is invariant and ergodic
(independence first gives mixing for cylinders, then for measurable sets).
Negative slopes and repeated indices invalidate none of these facts.
Theorem 2.8 therefore supplies an almost-everywhere local dimension `d`.
We do **not** import its projection-entropy formula to identify `d` with
random-walk entropy. Standard ball-covering arguments, also given below,
identify `d` with either measure Hausdorff-dimension convention.

**Finite-law pair theorem.** We reuse unchanged the independently approved
`C_PAIR_BOUND`, specifically
`research/pair-bound/certificates/C_PAIR_BOUND-6724e437dd6bbb81.json`.
For every finite real law `nu`, integer `k>=1`, and `rho>0`, it gives

    k(H(nu)-H^0_rho(nu))
      <= log_2 |k supp(nu)|
         + C_k sum_{ell: 2^(-ell)<=2*rho} c_ell(nu),
    C_k=60000*k^4.

Here `c_ell` is the maximum total mixture weight of fair unordered pairs
at distances in `[2^(-ell),2^(1-ell))`, whose mixture is a submeasure
of `nu`. Its residual is positive and its total pair weight is at most
one. Actual atoms, not address labels, are used. Finiteness of the support
implies existence of a maximizer by compactness of the finite feasible
polytope. There is no lower-separation parameter in this theorem.
Its reviewed formal source proves the stronger constant `1000*k^4`;
nothing below depends on that improvement.

## 2. Entropy calculus, convexity, and measurability

For a bounded real variable `X`, define

    H^0_s(X)=H(floor(X/s)),
    Hbar_s(X)=integral_0^1 H(floor(X/s+u)) du,
    G_{s,t}=Hbar_s-Hbar_t,       Delta_s=1-G_{s,2s}.

Let `V_s` be independent uniform on `[0,s]`. Its convolution density is
`f_s(z)=P(X in [z-s,z))/s` almost everywhere. It is bounded with bounded
support, so its differential entropy is finite. Substitution
`z=(j+1-u)s` in the cell probabilities proves

    Hbar_s(X)=h(X+V_s)-log_2 s.

Translation rotates the grid shift; positive scaling changes the cell size.
Reflection preserves the entropy because `-X+V_s` has the law of a
translate of `-(X+V_s')`, with `V_s'=s-V_s` independent uniform. Thus
`Hbar_s(aX+b)=Hbar_{s/|a|}(X)` for every nonzero signed `a`.

For an integer `N>=1`, take `A` uniform on `[0,Ns)`, independent of `X`,
and put `F=floor((X+A)/s)`, `C=floor((X+A)/(Ns))`. Then
`C=floor(F/N)` and

    G_{s,Ns}(X)=H(F | C,A).

There are at most `N` fine labels in each coarse cell, so
`0<=G_{s,Ns}<=log_2 N`. For any probability mixture of laws, with mixing
variable `E`, conditioning additionally on `E` can only decrease this
conditional entropy. Therefore

    G_{s,Ns}(average lambda_E) >= average G_{s,Ns}(lambda_E).

This proves concavity for general, not just finite, mixtures. Averaging
translates proves `G_{s,Ns}(X+Y)>=G_{s,Ns}(X)` for independent `X,Y`.
In particular `Delta_s` is **convex**, and Jensen has direction

    E Delta_s(lambda_E) >= Delta_s(E lambda_E).                 (2.1)

For `z>=s`, a coarse cell meets at most `floor(z/s)+2` fine cells and
a fine cell meets at most two coarse cells. Applying the entropy chain
rule to any two grid translations and averaging proves

    Hbar_s-log_2(z/s+2) <= Hbar_z <= Hbar_s+1.

The same equal-mesh comparison proves
`|Hbar_s-H^0_s|<=1` and `|H^0_s(X+t)-H^0_s(X)|<=1`.

All kernels used later are measurable. Conditional block probabilities
are functions of finitely many types. Infinite conditional coding is a
uniform limit of measurable finite coding maps. Evaluation of the resulting
probability kernel on an interval is measurable by integration of its
indicator. At any fixed scale all laws have support in a common compact
interval and hence a common finite grid alphabet. Entropy and conditional
entropy are continuous functions of the finite probability vectors, including
at zero, and integration over grid shift preserves measurability.
The bounds on `G` and `Delta` give integrability. This justifies general
mixtures, conditional expectations, and the conditional Jensen uses below.

## 3. Entropy dimension and the upper bound

Exact dimensionality implies

    limsup_{s->0} max(Hbar_s(mu),H^0_s(mu))/log_2(1/s) <= d.     (3.1)

To prove it, fix `eta>0` and choose a measurable set `E` of mass at least
`1-eta` on which `mu(B(x,r))>=r^(d+eta)` for all sufficiently small
`r`, with one common threshold. These uniform-threshold sets exhaust a
full-mass set; rational radii suffice for measurability. From every grid
cell of mesh `s` meeting `E` choose one point of `E`. Split the indices
modulo three. Within each residue class, their radius-`s/2` balls are
disjoint; their masses are at least `(s/2)^(d+eta)`. Hence at most
`3*(2/s)^(d+eta)` cells meet `E`. Compact support gives at most `C/s`
occupied cells in total, uniformly in the grid shift. Conditioning on
`E` gives entropy at most
`(d+2*eta)*log_2(1/s)+O_eta(1)`. Let `eta` decrease to zero.
The same covering construction gives a full-mass union of sets of dimension
at most `d+eta`. Conversely, on uniform-threshold sets where
`mu(B(x,r))<=r^(d-eta)`, a ball covering of any positive-mass subset
has a positive sum of `(diameter)^(d-eta)`; use a center in the subset
and double the radius if necessary. Thus every positive-mass Borel set
has dimension at least `d-eta`. These prove the dimension conventions
used here.

Fix a word length `n`, and regard the distinct complete maps of `G_n`
as generators with their merged probabilities `q_g>0`. Their self-similar
measure is still `mu`; their mean contraction depth is `n*chi` and
their symbol entropy is `H(G_n)`. For any `0<eta<n*chi`, almost every
block address eventually has, at every length `j`, prefix probability at
least `2^(-j(H(G_n)+eta))` and contraction at most
`2^(-j(n*chi-eta))`. These are applications of the bounded iid strong law.
There are at most `2^(j(H(G_n)+eta))` such prefixes. For a fixed eventual
starting length their coding image is compact and covered, at every large
`j`, by that many intervals of diameter at most
`C*2^(-j(n*chi-eta))`. Its Hausdorff dimension is at most
`(H(G_n)+eta)/(n*chi-eta)`. The countable union of those compact images
has full mass. Zero attractor diameter is immediate. Taking `eta->0`
and then the infimum over `n` proves

    d <= min(1,h/chi).                                        (3.2)

No unrecorded dimension theorem is used in this argument. For completeness,
the needed strong law for a bounded centered iid variable `Z` follows
from `E exp(tZ)=1+O(t^2)` near zero: the bound follows directly from
Taylor's formula and boundedness. For each `eta>0`, sufficiently small
positive and negative `t` give exponentially summable upper and lower
deviation probabilities by Markov's inequality and independence.
The probability of infinitely many deviations is zero by the tail union
bound. Apply this to a countable sequence `eta->0`. It also gives the
weak law used below.

If `h=0`, (3.2) already proves the formula. Otherwise suppose, towards a
contradiction, that

    d<1 and d*chi<h.                                          (3.3)

## 4. Uniform nonsaturation, without a scale restriction

We prove `delta:=inf_{v>0} Delta_v(mu)>0`. Suppose instead that
`Delta_{v_n}(mu)->0`, with no assumption that `v_n->0`.
Let `lambda_v=Law(X+V_v)` for `X~mu`. For an independent fair bit `J`,
uniform smoothing gives

    Delta_v(mu)
      = h(X+V_{2v})-h(X+V_v)
      = I(J;X+V_v+vJ).                                      (4.1)

For two probability laws `P,Q` and any measurable event `B`, observing
membership in `B` bounds the fair-mixture information below by
`h_2((P(B)+Q(B))/2)-(h_2(P(B))+h_2(Q(B)))/2`.
Since `h_2''(u)=-1/(ln(2)*u*(1-u))<=-4/ln(2)`, this is at least
`(P(B)-Q(B))^2/(2*ln(2))`, including endpoints by continuity.
Taking the supremum over `B` in (4.1) shows

    e_v:=||lambda_v-T_v lambda_v||_TV
        <= sqrt(2*ln(2)*Delta_v(mu)).

For a fixed integer `K>=2`, let `f_i` be the densities of
`T_{iv} lambda_v`, `0<=i<K`, and `f_*=min_i f_i`. Translation and the
triangle inequality give

    1-integral f_* <= sum_{i=1}^{K-1} integral(f_0-f_i)_+
                  <= K*(K-1)*e_v/2.

All `K` component laws have this same common submeasure and residual mass.
Its common/residual flag may be sampled independently of the input label.
On the common branch the output has no information about that label;
on the residual branch it has at most `log_2 K` bits. Thus
`I(label;output) <= (1-integral f_*)*log_2 K`.
The uniform mixture is `Law(X+V_{Kv})`, so smoothing implies

    G_{v_n,Kv_n}(mu) -> log_2 K.                              (4.2)

Put `a_*=min_i |r_i|>0`. For `0<s<v`, stop the iid coding at the first
prefix with absolute contraction at most `s/v`. This is a bounded stopping
time, since `r_max<1`. Its contraction has absolute value in
`(a_*s/v,s/v]`. The remaining iid coding has law `mu`, independently of
the stopped prefix (check each of the finitely many possible stopped words).
Consequently `mu` is a finite mixture of signed affine copies of itself.
By Section 2,

    G_{s,Ks}(mu)
      >= inf_{z in [v,v/a_*]} G_{z,Kz}(mu)
      >= G_{v,Kv}(mu)-C_*,
    C_*=log_2(1/a_*+2)+1.                                   (4.3)

The last loss is independent of `K`. Choose an integer `K` with
`(1-d)*log_2 K>C_*+2`, then one of the `v_n` in (4.2) for which
`G_{v,Kv}>log_2 K-1`. By (4.3), every `s<v` has
`G_{s,Ks}>B:=log_2 K-C_*-1>d*log_2 K`.
Telescoping at `s_m=v*K^(-m)` gives
`Hbar_{s_m}(mu)-Hbar_v(mu)>m*B`, contradicting (3.1).
Thus `delta>0` uniformly over **all** positive scales.

## 5. A fair pair creates entropy gain

For any bounded `X`, independent fair `J`, and `0<s<v<t`, put `Y=X+vJ`
and `D_a=Hbar_a(Y)-Hbar_a(X)`. For independent uniform shift `U_a`,
`Z_a=floor(Y/a+U_a)`, translation invariance gives
`D_a=I(J;Z_a | U_a)`. Smoothing gives `D_v=Delta_v(X)`.

Use independent shifts `U_s,U_v` on the same sample `Y`. The information
chain rule yields

    D_v <= D_s + H(Z_v | Z_s,U_s,U_v).

A fine cell has length `s`; the conditional law in it is independent of
the unused coarse shift. Only a proportion `s/v` of coarse shifts put a
boundary in that cell, and at most two labels then occur. Thus the last
entropy is at most `s/v`. Also, adjoining `X` to the coarse observation
gives `D_t<=I(J;Z_t | X,U_t)<=v/t`, since the labels for `X` and `X+v`
differ on exactly a proportion `v/t` of shifts. Boundary coincidences
have shift measure zero, even for atomic `X`. Subtraction proves

    G_{s,t}(X+vJ)-G_{s,t}(X) >= Delta_v(X)-s/v-v/t.             (5.1)

Any signed scaled fair pair becomes a translate of `{0,v}` after ordering
its endpoints. Therefore (5.1) applies to it without an orientation
assumption. Unlike Section 2 concavity, (5.1) needs no integer scale ratio.

## 6. Type conditioning retains a linear entropy deficit

Write `m=|Lambda|`. Under (3.3), `h>0`, so `m>=2`.
Choose `alpha>chi` with `d*alpha<h` (use `alpha=chi+1` if `d=0`).
Choose a sufficiently large integer `b` and define

    A=b*alpha,   A'=b*(chi+alpha)/2,
    h_b=b*h-m*log_2(b+1),   gamma=h_b-d*A>0.

Thus `b*chi<A'<A`. Split coding into length-`b` words `W_h`.
Their types `omega_h` record the counts of each **indexed** symbol.
There are at most `(b+1)^m` types. Conditional on a type `kappa`,
all words have probability proportional to the same
`product_i p_i^(kappa_i)`, hence are uniform. Draw the types iid and,
given all types, the words independently with these uniform conditional
laws. Multiplication of finite-prefix probabilities recovers the original
coding law, including nonuniform symbol weights.

Let `F_j` record types before index `j`. Set

    r(kappa)=product_i r_i^(kappa_i),
    R_j=product_{h<j} r(omega_h),   sigma_j=-log_2 |R_j|.

The signed `R_j` is `F_j`-measurable. The positive iid increments of
`sigma_j` have mean `b*chi` and finite bound
`D=max_kappa -log_2 |r(kappa)|>0`.
Let `nu_{omega,n}` be the conditional law of
`sum_{h<n} R_h*phi_{W_h}(0)`, and `mu_omega` the infinite version.
The first depends only on `F_n`, and `E mu_omega=mu`.

Write `Omega_n=(omega_0,...,omega_{n-1})`. Given `Omega_n`, the full
length-`bn` map is

    x -> R_n*x + sum_{h<n} R_h*phi_{W_h}(0).

Its signed slope is fixed, so its translation and its complete affine
map determine one another. Equal translations within this conditioning
are merged. Therefore

    E H(nu_{omega,n}) = H(G_{bn} | Omega_n)
                      >= H(G_{bn})-H(Omega_n) >= n*h_b.       (6.1)

This does not require `Omega_n` to be a function of `G_{bn}`.

Conditioning only on `F_n`, the *unconditioned* remaining symbols still
have their original iid law and are independent of the prefix. The full
coding law is `nu_{omega,n} * D_{R_n} mu`. Fixed-grid entropy is concave;
its translation error is at most one bit. Mixing first over the tail
translation and then over `Omega_n` proves, for every `s>0`,

    E H^0_s(nu_{omega,n}) <= H^0_s(mu)+1.                     (6.2)

Put `rho_n=2^(-ceil(A*n))`,
`V_n=H(nu_{omega,n})-H^0_{rho_n}(nu_{omega,n})`,
and `E_n={sigma_n<=A'*n}`. Quantization is a function of the exact
finite translation, so `0<=V_n<=n*b*log_2 m`.
Using (3.1), (6.1), and (6.2), with `eta=gamma/(4*A)`, gives
`E V_n>=gamma*n/2` for all sufficiently large `n`.
The weak law and `b*chi<A'` imply `P(E_n^c)->0`. The displayed uniform
bound on `V_n` then gives, eventually,

    E[1_{E_n} V_n] >= epsilon*n,   epsilon=gamma/4>0.          (6.3)

In particular, no assertion about nonsaturation of individual
`mu_omega` was made.

## 7. A deterministic finite band, with no bound on its endpoint

Let `D_b={phi_w(0): |w|=b}`, so `|D_b|<=m^b`. For fixed types and
`S=supp(nu_{omega,n})`,

    k*S subset sum_{h<n} R_h*(k*D_b),
    log_2 |k*S| <= n*m^b*log_2(k+1).                         (7.1)

Indeed a `k`-fold sum of digits is specified by each digit's multiplicity
in `{0,...,k}`. Collisions and negative `R_h` only decrease the
cardinality; they cannot invalidate this upper bound.

Choose one integer `k>=1` so large that
`m^b*log_2(k+1)<k*epsilon/2`. Apply the reviewed pair theorem to each
conditional law, multiply by `1_{E_n}`, and average. Equations (6.3)
and (7.1) give

    E[1_{E_n} sum_{ell>=a_n} c_ell(nu_{omega,n})] >= c*n,
    a_n=ceil(A*n)-1,   c=k*epsilon/(2*C_k)>0.                 (7.2)

For a fixed `n` there are finitely many type prefixes and finitely many
support points in each conditional law. The dyadic band indices of their
distinct positive pair distances therefore form one finite set `J_n`.
Take `B_n=max({a_n} union J_n)`. All omitted capacities above `B_n`
vanish, including when a law is a singleton. Thus (7.2) is exactly

    E[1_{E_n} sum_{ell=a_n}^{B_n} c_ell(nu_{omega,n})] >= c*n. (7.3)

`B_n` is deterministic and finite. It may grow faster than any prescribed
function; no quantitative estimate on it will be used. This is only
finiteness of each individual set of positive distances, not an added
separation hypothesis on the IFS.

## 8. Conditional gain: average the unobserved future

Let `theta` shift the type sequence and set
`tau_j=D_{R_j} mu_{theta^j omega}`. Conditional independence of block
draws gives, for every environment,

    tau_j=(D_{R_j} nu_{theta^j omega,n}) * tau_{j+n}.           (8.1)

Choose an integer `M>4` with `5/M<delta/2`. For an integer target `L>=1`,
let `r=2^(-L)` and

    g_j=G_{r/M,Mr}(tau_j).

The scale ratio is the integer `M^2`. By (8.1) and Section 2,
`0<=g_j<=2*log_2 M`, and `g_j>=g_{j+1}`, pathwise.

Condition on **`F_{j+n}`**, not on the full environment, and put
`ell=L-ceil(sigma_j)`. The finite prefix law, `R_j`, `R_{j+n}`, and
`ell` are fixed. Choose a maximizing pair mixture for `c_ell`.
This is measurable: the conditioning has finitely many atoms, and a
maximizer can be fixed separately on each one. Every chosen unscaled
distance `u` is in `[2^(-ell),2^(1-ell))`. Its scaled distance
`v=|R_j|*u` obeys

    1 <= v/r < 4,    (r/M)/v + v/(Mr) <= 5/M.                (8.2)

The sign merely reverses pair endpoints. By (5.1), the corresponding
pair gain against `tau_{j+n}` is at least
`Delta_v(tau_{j+n})-5/M`.

Future types starting at `j+n` are independent of `F_{j+n}`. As an
identity of conditional probability measures,

    E[tau_{j+n} | F_{j+n}] = D_{R_{j+n}} mu.

For each fixed chosen `v`, (2.1) and signed scaling give

    E[Delta_v(tau_{j+n}) | F_{j+n}]
      >= Delta_v(D_{R_{j+n}} mu)
       = Delta_{v/|R_{j+n}|}(mu) >= delta.                   (8.3)

The **left** side is bounded below by the deficit of the average law.
It is not permissible to reverse this inequality or to infer the bound
for every conditional tail. `jacobian_payload.json` and the independently
replayed output give a strict diagnostic: averaging the two Dirac tail
laws at `0,1` changes the unit-scale deficit from the average `1` to
`1/2`. This is consistent with, not a proof of, (8.3).

Apply concavity of `G_{r/M,Mr}` to the scaled prefix mixture in (8.1).
Its residual positive measure, if nonzero, is normalized; convolving it
with the tail has nonnegative gain by the integer-ratio convolution
inequality. Subtract the tail entropy, multiply each pair gain by its
fixed conditional weight, and use (8.2)-(8.3). This proves

    E[g_j-g_{j+n} | F_{j+n}]
      >= (delta/2)*c_{L-ceil(sigma_j)}(nu_{theta^j omega,n}).  (8.4)

No independence after observing a coordinate sum, and no pathwise
nonsaturation of conditional tails, is used anywhere in this step.

## 9. Adaptively chosen lengths and pathwise disjointness

Fix an arbitrary positive integer `q`. Choose sufficiently large
`n_1<...<n_q` recursively so that (7.3) applies, `a_{n_i}>=1`, and

    a_{n_i}-A'*n_i-1 > B_{n_h}       for every h<i.           (9.1)

This is possible since the left side is at least
`(A-A')*n_i-2 -> infinity`; only **previously** chosen endpoints occur
on the right. All choices are deterministic. Take an even integer `T`
with `T/2>max_i B_{n_i}`. Define

    J_i={k*n_i: k=0,...,floor(T/(2*D*n_i))}.

For each target `L=1,...,T`, retain `[j,j+n_i)` exactly when

    sigma_{j+n_i}-sigma_j <= A'*n_i,
    a_{n_i} <= L-ceil(sigma_j) <= B_{n_i}.                  (9.2)

The entire event is `F_{j+n_i}`-measurable, as required for (8.4).

For a fixed environment and target, write `x_j=L-ceil(sigma_j)`.
It is nonincreasing. A retained band-`i` window satisfies

    x_{j+n_i} >= a_{n_i}-A'*n_i-1,                          (9.3)

because `ceil(t)-ceil(s)<=t-s+1`. For any retained coarser band
`h<i` starting at `k`, (9.1)-(9.3) give
`x_{j+n_i}>B_{n_h}>=x_k`. Monotonicity forces `k>j+n_i`.
Thus every finer-band window ends strictly before every retained
coarser-band start. Within one band, distinct starts are multiples of
the same positive length, so half-open windows cannot overlap.

Order all retained windows as `[u_t,v_t)`, with `v_t<=u_{t+1}`.
The monotonicity and nonnegativity of `g` give

    sum_t(g_{u_t}-g_{v_t})
      <= g_{u_1}-g_{v_N} <= 2*log_2 M.                     (9.4)

The empty sum is zero. This uses neither a terminal vanishing-tail
estimate nor independence of the windows. The new Lean source proves
the universal ceiling, ordering, and telescoping assertions.

## 10. Exact target recovery, expectation, and contradiction

For `j in J_i`, `0<=sigma_j<=D*j<=T/2`. Since `T` is even,
the integer `z=ceil(sigma_j)` is in `[0,T/2]`. Each integer
`ell in [a_{n_i},B_{n_i}]` appears exactly once as `L-z` for
`1<=L<=T`, namely at `L=ell+z`. Its lower bound is at least one,
and its upper bound is at most `B_{n_i}+T/2<T`.
This is an exact correspondence, not an asymptotic density assertion.

Take expectations in (9.4). Each retention event is measurable at the
end of its window, so the tower property applies to (8.4) after multiplying
by its indicator. Sum over `L`, and use the exact correspondence to get

    2*T*log_2 M
      >= (delta/2) sum_i sum_{j in J_i}
           E[1_{E_{n_i}}(theta^j omega)
             sum_{ell=a_{n_i}}^{B_{n_i}}
                c_ell(nu_{theta^j omega,n_i})]
      >= (delta*c/2) sum_i |J_i|*n_i
      >= delta*c*q*T/(4*D).                                (10.1)

After the target sum, the random offset `ceil(sigma_j)` has disappeared.
Each summand is just a function of the shifted environment, whose
distribution is unchanged. Therefore stationarity and (7.3) suffice;
no independence between windows or from the offset is being presumed.
The final inequality uses the exact count
`|J_i|=floor(T/(2*D*n_i))+1>=T/(2*D*n_i)`.

Cancel `T>0` in (10.1). It would imply

    delta*c*q <= 8*D*log_2 M

for every positive integer `q`, although `delta*c>0` and the right side
was fixed before choosing `q`. The Archimedean property contradicts this.
This last inference and the candidate-count lower bound are also proved
in the new Lean source. The assumption (3.3) is impossible.

Together with (3.2), this proves the universal formula stated above.
If `h=chi` or `h>chi`, a strict deficit below the predicted dimension
one would satisfy both inequalities in (3.3), so these cases require no
extra endpoint argument. A single generator and more general zero-rate
systems were already covered by (3.2). Every use of scaling took the
absolute slope only for the scale and retained the sign in the law.
Every exact entropy was taken after merging actual collisions.

The diagnostic systems called subcritical, critical, and supercritical in
`verify.py` have those regimes for reasons independent of finite enumeration.
For digits `{0,1}` and ratio `1/4`, the two first-level coding intervals are
disjoint and word maps are distinct, so `h=1`, `chi=2`. For ratio `1/2`,
the length-`n` translations are distinct binary fractions, giving
`h=chi=1`. For ratio `2/3` or `-2/3`, multiply a length-`n` translation by
`3^(n-1)`. Its first binary digit is determined modulo two; subtract it
and divide by the signed factor two to determine the next digit by induction.
Thus word maps are distinct for every `n`, `h=1`, and
`0<chi=log_2(3/2)<1`. The singleton negative-ratio system has `h=0`.
These observations label the examples; the universal theorem was proved
above, not inferred from them.

## Certification boundary and review

The load-bearing analytic estimates have been proved here, rather than
assumed in a conditional dimension theorem. The only imported specialized
results are the reviewed universal finite-law pair bound and Feng-Hu exact
dimensionality. Elementary finite entropy identities, the bounded iid law,
and the needed covering arguments are explained above.

`Main.lean` proves the rounding/disjointness/counting core, universally
and independently of upstream dimension modules. The existing pair-bound
certificate supplies its separate universal finite-law theorem.
`verify.py` is an exact executable replay of finite diagnostics and these
certificate records; its finite experiments are not a formalization of
Sections 2-8 or of Feng-Hu.

No false literal manuscript assertion was identified in this dependency
chain. Consequently no new `F_...` refutation claim is warranted.
Feng-Hu's primary source has been obtained and read, but its ledger
attribution must be performed by the independent Host-invoked Reviewer:
its filer and this Engineer are the same independence key. Reviewer must
also assess this complete proof and its statement fidelity. This document
does not manufacture either that independent approval or a novelty verdict.
