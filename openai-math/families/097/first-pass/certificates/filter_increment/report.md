# A saturating relative-gain theorem and the weighted increment lemma

## 1. Scope and result

The source under audit is the staged OpenAI release dated September 24,
2026, `build/matrix.tex`, especially `lem:scalar-comparison`,
`lem:endpoint-comparison`, `lem:direct-gain`, and `lem:increment`.
The filter hypotheses are those of `build/assembly.tex`,
`prop:filtered`: square invertible real contractions, one fresh coefficient
per step, `C_i C_i^T+b_i b_i^T=I`, and positive diagonal `Q`.
The Gaussian-survival and adaptive-shift arguments are not certified here.
The local Wiki index supplied no relevant entry and the campaign ledger
contained no prior mathematical certificate.

**Verification theorem.** Lemma `lem:increment` holds, in every dimension
and for every finite length, with the explicit, deliberately loose constants

    e_0 = 1/24,       C = 2^33.

No commuting-matrix hypothesis, condition-number bound, minimum contraction
singular value, length bound, or restriction on the positive entries of `Q`
is added. An interval of zero energy has exactly zero increment.

The main independent result below is a stronger, global relative-gain
inequality. It allows arbitrary-rank positive semidefinite gains, singular
contractions, and every exponent `1<a<=2`. At `a=3/2` it replaces the
manuscript's small-energy bootstrap and halves its relative-gain constant:
the manuscript uses `(a 2^a E)^(1/a)`, whereas the result below gives
`(a E)^(1/a)`. The global Schatten bound has optimal coefficient `a`.
No false manuscript assertion was found in the audited dependency chain.

These are analytic proofs with machine-checked algebra, not a full Lean
formalization of the analytic theorem. Independent review is pending.
Novelty is **not** certified by the Engineer: a targeted literature query
returned no relevant primary theorem, but its generated answer confused a
potential with its derivative and cited an unrelated paper, so it is not
evidence of absence. No external theorem from that search is used.

## 2. Global transported-gain theorem

Fix a finite-dimensional real Euclidean space and `1<a<=2`. Put

    psi_a(x) = integral_0^x u^(a-1)/(1+u)^a du,       x>=0.

Start with `Z=Y>=0` and `V=0`. Allow any finite sequence of:

1. simultaneous congruences `(Z,V) -> (C Z C^T,C V C^T)` with
   `C C^T<=I`, including singular `C`;
2. additions `V -> V+B` with arbitrary `B>=0`.

Write `D=Z+V`. Let `B_a` denote the sum, over the additions only, of

    tr psi_a(D_after) - tr psi_a(D_before).

Every summand is nonnegative. At any endpoint define

    S=I+Z,  J=I+D,
    A=S^(-1/2) V S^(-1/2),  H=J^(-1/2) V J^(-1/2).

Then

    tr psi_a(A) <= B_a,                    (2.1)
    tr H^a <= a B_a.                      (2.2)

In particular, for all budgets, not only small ones,

    V <= (a B_a)^(1/a) (I+D).              (2.3)

The theorem has no invertibility assumption on `Y`, the gains, or the
contractions. The regularizations `S` and `J` are always positive definite.

### Proof: contractions

After a contraction let `S'=I+C Z C^T` and
`T_c=(S')^(-1/2) C S^(1/2)`. Direct expansion gives

    S' - C S C^T = I-C C^T >=0.

Thus `T_c T_c^T<=I`, and the new relative matrix is
`A'=T_c A T_c^T`. Its ordered eigenvalues do not exceed those of `A`.
Indeed `A'` and `A^(1/2) T_c^T T_c A^(1/2)` have the same eigenvalues
(the squared singular values of `T_c A^(1/2)`), and the latter matrix
is at most `A`. The min-max characterization gives the eigenvalue
comparison. Since `psi_a` is increasing, `tr psi_a(A')<=tr psi_a(A)`.
This argument does not assert operator monotonicity of `psi_a`.

### Proof: gains and the saturated conjugation

Interpolate one addition linearly. Here `S` is fixed and `dot V=B>=0`.
Set `T=S^(-1/2) J^(1/2)`. Then

    T^T T=(I-H)^(-1),     A=T H T^T.

In the polar decomposition `T=U (I-H)^(-1/2)`, `U` is orthogonal.
All functions of `H` commute, so

    A=U [H(I-H)^(-1)] U^T,
    T^T psi_a'(A) T = H^(a-1).             (2.4)

For clarity, if `h` is an eigenvalue of `H`, then the corresponding
eigenvalue of `A` is `h/(1-h)`, and

    (1-h)^(-1) psi_a'(h/(1-h)) = h^(a-1).

Equation (2.4) therefore contains no commutation of `Z` and `V`.
Its noncommutative product cancellation at `a=3/2` is the Lean theorem
`FilterIncrement.saturated_conjugation`, with the precise interpretation
in `statement_fidelity.md`.

Also `V<=D`, hence

    H <= D(I+D)^(-1).

For `0<beta<1`, fractional powers preserve positive semidefinite order.
Here is the needed proof rather than an unexamined citation:

    M^beta = c_beta
             integral_0^infinity t^(beta-1) M(tI+M)^(-1) dt,
    c_beta = 1 / integral_0^infinity u^(beta-1)/(1+u) du > 0.

The scalar formula follows by substituting `t=mu`; the normalization
integral is positive and finite since `0<beta<1`. Spectral diagonalization
gives the matrix formula. Each integrand
preserves order because `M(tI+M)^(-1)=I-t(tI+M)^(-1)` and inversion
reverses positive definite order. The integral converges at both
endpoints, including zero eigenvalues. Inversion reverses order by
conjugating to `0<P<=I`, whose inverse has eigenvalues at least one.
For `beta=1` the assertion is immediate. Taking `beta=a-1` and
conjugating (2.4) gives

    S^(-1/2) psi_a'(A) S^(-1/2)
      <= (I+D)^(-1/2) [D(I+D)^(-1)]^(a-1) (I+D)^(-1/2)
       = psi_a'(D).

For a continuously differentiable scalar function `f` and a differentiable
symmetric path `M`, `d tr f(M)/dt=tr(f'(M) dot M)`. One justification
covering repeated and zero eigenvalues is to approximate `f'` uniformly
by polynomials on a compact spectral interval, integrate the polynomial
trace identities along the path, and pass to the limit uniformly.
The resulting integral identity has a continuous integrand, so it
differentiates. The derivative of `psi_a` is continuous at zero since
`a>1`. Pairing the last matrix inequality with `dot V>=0` proves

    d tr psi_a(A)/dt <= d tr psi_a(D)/dt.

Integrate over every gain, discard the nonpositive contraction changes,
and use the initial value zero. This proves (2.1), at every intermediate
stage as well as at the endpoint.

Finally the eigenvalues of `A` are `h/(1-h)`, with `0<=h<1`, and

    psi_a(h/(1-h))
      = integral_0^h t^(a-1)/(1-t) dt
      >= h^a/a.

Summing proves (2.2). Its largest-eigenvalue consequence gives
`H<=(a B_a)^(1/a) I`; congruence by `J^(1/2)` proves (2.3).
All arguments are dimension- and length-independent.

### Optimality of the coefficient

In one dimension take `Y=0`, one gain `v>0`, and no contraction.
Then `B_a=psi_a(v)` and `H=v/(1+v)`. The elementary bounds

    v^a/[a(1+v)^a] <= psi_a(v) <= v^a/a

show that `H^a/B_a -> a` as `v ->0+`. Thus the coefficient `a` in
(2.2) cannot be reduced. Strictly positive initial states do not improve
it: take `Y=v^2` and a fixed nonzero scalar contraction; the same limit
holds. This can be an admissible manuscript filter: choose
`C=3/5`, `b=4/5`, `Q_old=v^2`, and `Q_new=25v/16`.

## 3. Explicit scalar and endpoint constants

For this section `a=3/2`, `w(x)=min(x^a,x^(-1))`, and
`p(x)=integral_0^x w(u)/u du`, as in the manuscript.
Let `f_0` be its specified cutoff. We give constants to avoid numerical
sampling of unspecified absolute constants.

The logarithmic Lipschitz bound on `w` is
`|log w(x)-log w(y)|<=a |log x-log y|`.
For `r=y/x<1`, integrate the maximum of the two lower endpoint cones;
for `r>1`, integrate the minimum of the two upper endpoint cones.
The cones cross in the interval by this same Lipschitz bound.
Their integrals are respectively

    [w(x)+w(y)-2 sqrt(w(x)w(y)) r^(a/2)]/a,
    [2 sqrt(w(x)w(y)) r^(a/2)-w(x)-w(y)]/a.

Using `2 sqrt(w(x)w(y))<=w(x)+w(y)` yields

    J(x,y) >= (w(x)+w(y)) B(r)/2,
    r J(y,x) >= (w(x)+w(y)) r B(1/r)/2,
    B(r)=r+1/3-(4/3)r^(3/4).

Both remainders have exact factorizations, with `u=r^(1/4)>0`:

    3 B(r)       = (u-1)^2(3u^2+2u+1),
    3 r B(1/r)   = (u-1)^2(u^2+2u+3).

Each remainder is at least `1/1024` times, respectively, `1`,
`(r-1)^2`, and `r` on the ranges `r<=1/2`, `1/2<=r<=2`,
and `r>=2`. Here are entirely rational bounds:

- On the first range, `u<=7/8`, giving lower bounds `1/192` and `1/64`.
- In the middle range `1/2<=u<=2` and
  `u^3+u^2+u+1<=15`; both remainders are at least
  `(r-1)^2/675`.
- On the last range `u>=9/8`; divide the factorizations by `u^4`
  and use `1-1/u>=1/9`. The lower bounds are `r/81` and `r/243`.

If cutoff values differ, at least one argument is in `[1/2,4]`.
In the middle range both are in `[1/4,8]`,
`(w(x)+w(y))/2>=1/8`, and

    (1+y)|f_0(x)-f_0(y)|^2 <= 2304(r-1)^2.

This uses `|f_0(x)-f_0(y)|<=2x|r-1|` and `x<=8`.
On the first and last ranges the same weighted square is at most
`5` and `5r`, respectively, and the average of the `w` values is
again at least `1/8`. Equal cutoff values need only nonnegative
remainders. Consequently both scalar comparisons hold with

    c=2^(-25).                              (3.1)

We also use the direct cutoff bounds

    f_0(u)^2<=4w(u),
    (1+u)f_0(u)^2<=20w(u),
    u f_0(u)^2<=16w(u).

They follow from support in `[1/2,4]`, where `w>=1/4`.

### Exact endpoint expansion and orientation

Let `Y=X_s`, `X=X_t`, `C=C_t ... C_(s+1)`,
`Z=C Y C^T`, and `V=X-Z>=0`. All three endpoint matrices are
positive definite because this application retains invertibility.
Split coefficient space into coordinates already read at `s` and new
ones. Its old/new covariance identities are exactly

    R_t R_s^T=C,             R_t Q_old R_s^T=C Y,
    R_t Q_old R_t^T=Z,       R_t Q_new R_t^T=V,
    F_s Q_new=0,

where `Q_old` and `Q_new` include the factor `1/theta`.
Put `Ftilde=R_t^T f_0(Z) R_t`.

In eigenbases of `Z,Y`, set `m_ij=|C_ij|^2` and
`n_ij=m_ij y_j/z_i`. Row and column sums of `m` are at most one.
Both sums of `n` are one: use `Z=CYC^T` for rows and
`C^T Z^(-1) C=Y^(-1)` for columns. If `d_i,h_j` are the deficits of `m`,
the two expansions are

    ||(Ftilde-F_s)(I+Q_old)^(1/2)||_HS^2
      = sum_ij m_ij(1+y_j)(f_0(z_i)-f_0(y_j))^2
        + sum_i d_i f_0(z_i)^2
        + sum_j h_j(1+y_j) f_0(y_j)^2,

    P_loss:=tr(p(Y)-p(Z))
      = sum_ij n_ij J(y_j,z_i)
        + (sum_i d_i w(z_i)+sum_j h_j w(y_j))/2.

The **reversed** scalar comparison (3.1), with factor `y_j/z_i`,
controls the double sum. This orientation is essential. The remaining
terms use the direct cutoff bounds. The squared distance is at most
`2^25 P_loss`.

In eigenbases of `X,Z`, let `m_ij` be the squared orthogonal overlaps
and `n_ij=m_ij z_j/x_i`. The matrix `m` is doubly stochastic and `n`
is doubly substochastic; the latter uses both `Z<=X` and
`X^(-1)<=Z^(-1)`. Let `d'_i,h'_j` be its deficits. Then

    P_gain:=tr(p(X)-p(Z))
      = sum_ij m_ij J(x_i,z_j)
        + (sum_i d'_i w(x_i)+sum_j h'_j w(z_j))/2,

    ||(F_t-Ftilde)(I+Q_old)^(1/2)||_HS^2
      = sum_ij m_ij(1+z_j)(f_0(x_i)-f_0(z_j))^2
      <= 2^25 P_gain.

Here it is the **forward** scalar comparison that is needed.
The new-coordinate squared distance is exactly
`tr(f_0(X)^2 V)=sum_i x_i d'_i f_0(x_i)^2<=32 P_gain`.
The old-weight squared triangle inequality, followed by addition of
the new-weight term, therefore proves

    ||(F_t-F_s)(I+Q/theta)^(1/2)||_HS^2
      <= 2^27 (P_loss+P_gain).             (3.2)

The two deficit expansions are algebraic consequences of the stated
row/column sums; no equality of noncommuting products was inserted.

## 4. Completion of the weighted increment theorem

In the manuscript path apply Section 2 with `a=3/2`. Its gain-only
budget `B_a` is the gain part of the `p_1` energy, and hence is at most
the full nonnegative energy `E`. Put `q=(3E/2)^(2/3)`.
By (2.3), `V<=q(I+X)`. For `E<=1/24`,
`q^3< (1/4)^3`, so `q<1/4`.

If `E=0`, (2.2) gives `V=0`, and total variation gives
`P_loss=P_gain=0`; (3.2) gives the exact zero-increment conclusion.
Suppose `E>0`. Ordered endpoint eigenvalues satisfy

    x>=z>0,     z>=(1-q)x-q.

If `x<=4q<1`, then

    p(x)-p(z)<=x^a/a <= (4/a)q phi(x).

If `x>4q`, then `z>=x/2` and `x-z<=q(1+x)`.
For `x/2<=u<=x`,
`w(u)<=2^a w(x)` and `1/u<=2/x`, so

    p(x)-p(z)
      <= 2^(a+1) q(1+1/x)w(x)
      <= 2^(a+2)q phi(x)
      <=16q phi(x).

Here `(1+1/x)w(x)<=2phi(x)` on either side of one.
Summing proves `P_gain<=16q k_t`.
The total variation of `tr p` along the separate contraction and gain
steps is at most `E`; therefore

    P_loss+P_gain
      = tr p(Y)-tr p(X)+2P_gain
      <= E+32q k_t
      <=64(1+k_t) E^(2/3).

We used `E<=1` and `(3/2)^(2/3)<=2`. Combining with (3.2) gives
the asserted constant `C=2^33`. This proves the live target, but does
not settle any subsequent Gaussian or signing assertion.

## 5. Exact replay, formal boundary, and review

Run `python verify.py` from this directory, or pass its absolute path.
It uses SymPy for polynomial identities, rational inequalities, an exact
noncommuting relative-gain example, and all old/new support identities
on a rational admissible filter with nonsymmetric and noncommuting
contractions. It also checks the saved typed Jacobian spectrum output.
The example is evidence against orientation mistakes, not a proof by
finite sampling. The universal conclusion rests on Sections 2--4.

`exact_certificate.json` identifies the theorem, constants, algebraic
certificate, and limitations. `Main.lean` and its separate fidelity
document encode the load-bearing noncommutative cancellation, contraction
defect, scalar factorization, and finite budget telescoping. The official
Lean evidence records the real compiler outcome and source binding.
It must not be interpreted as formalizing operator monotonicity, trace
calculus, or the complete increment theorem.

The independent Reviewer must check the analytic proof, replay the
certificate, inspect the formal statement's reading, and decide significance
and novelty. The Engineer does not write a Reviewer judgement. No
`F_<LABEL>` claim is warranted in this audited chain because no false
assertion has been identified; if independent review finds one, it must
be quoted literally and separately recorded with `refutes`.
