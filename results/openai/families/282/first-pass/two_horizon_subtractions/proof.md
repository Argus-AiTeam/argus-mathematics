# A conditional verification of the two-horizon subtraction lemma

## Statement and boundary of the result

The target is `D:subtractions` and `D:two-horizon` in the staged manuscript,
`build/sections/04-dispersion.tex`, at those labels. The following theorem
verifies that implication, not the physical premises used to reach it.

**Theorem.** Assume the full finite Lorentz tensor family has the common
covariant causal splitting, fixed-virtuality restrictions, common gap
values, jump signs, and uniform finite growth asserted in
`D:causal-continuation`. Assume its two jumps are `D:jump`, with the same
nonzero normalization, the stated finite polarization waves, and the
bounded Fourier transforms of the positive measure. Then the cutoff
regularization in the manuscript is continuous in the internal Hilbert
space and satisfies `D:two-horizon`, with uniformly finite separated
polynomial ambiguities. No semi-local zero-jump term satisfying these
premises can escape that class.

Here all identities are weak identities on compact subsets of `M_o>0`,
`b>0`, `q,r` are arbitrary real two-vectors, and `z0>0`. Set
`R=|r|^2` and `H=L^2(R_+,M dM)` with the finite polarization labels.
The conclusion is

    (M_o^2+|q+r|^2) A_z - (|q+r|^2-M_o^2) B_z
      + 2 M_o (q_i+r_i) B_i = P_q+P_r,

where `P_q` is polynomial in `q` and `P_r` is polynomial in `r`.
Their coefficients can depend arbitrarily on the other transverse
variable. This is not a claim that the remainder is a polynomial jointly
in both variables.

The manuscript's `ass:framework`, `D:plane-matrix`,
`D:causal-continuation`, `D:jump`, and `D:measure-input` remain unreviewed
manuscript dependencies. In particular, the theorem does **not** derive
the fixed-normal pullback, common covariant splitting, or jump formula
from the QFT assumptions. Existence of local causal extensions alone
would not establish those premises. No physical QFT counterexample, main
theorem verification, or novelty claim is made here.

## 1. One-variable remainder and a common subtraction

Keep the full finite tensor family until after subtraction. Choose one
integer `d>=2` exceeding its growth and distribution-order requirements.
The polynomial exponent is uniform: it is chosen for the original finite
family of tempered distributions, not separately at each `q,r` or for
each contracted component. More explicitly, its Fourier-Laplace bound
has fixed exponents in momentum and inverse tube distance. The
`D:tube-distance` estimate substitutes a constant times
`|Im z|/(1+|z|)^2` for that distance; it changes those exponents by fixed
amounts. There are only finitely many tensor harmonics. Thus neither
varying nonzero `X` nor changing the output mass forces a new exponent.
Constants can depend on nonzero `X` and on compact positive output-mass
ranges, and can diverge at the excluded boundary `X=0`. This is not a
claim of a uniform bound on those constants.

At fixed `X>0`, subtract the distributional Cauchy transform with kernel

    K_d(z,z') = (z-z0)^d / ((z'-z0)^d (z'-z)).

It has the prescribed jump. The remaining upper and lower boundary
values therefore agree. The half-plane Fourier-Laplace support theorem
puts their boundary Fourier transforms in opposite closed half-lines,
so the common transform is supported at zero. A finite-order
distribution supported at a point is a finite delta jet: subtract the
Taylor jet of a test function through its distribution order; its
remainder is annihilated by that point-supported distribution.
Fourier transformation consequently makes the remainder a polynomial.
Let `e` be one uniform bound for its degree in `z`.

The Fourier-Laplace theorem used here is precisely the cone/tube
equivalence in Bros-Iagolnitzer, Section 1, pp. 155-156. It is not being
used to justify the additional fixed-null-normal restriction. Its
primary source is included, with an excerpt for independent attribution.
The polynomial statement follows for distributions, not just for
absolutely convergent spectral integrals.

## 2. Why its transverse coefficients are polynomials

Use the null basis `(n,bar n,e1,e2)` and metric

    G = [[0,1,0,0],[1,0,0,0],[0,0,-1,0],[0,0,0,-1]].

The null rotation fixing `n` is the following matrix on components:

    L(beta) = [[1, |beta|^2/2, beta1, beta2],
               [0, 1,            0,     0],
               [0, beta1,        1,     0],
               [0, beta2,        0,     1]].

It satisfies

    L(beta)^T G L(beta)=G,
    L(beta)L(gamma)=L(beta+gamma),   L(beta)^(-1)=L(-beta).

Every entry, including every entry of its inverse, has degree at most
two. A tensor representation with a finite total of `t` Lorentz indices,
covariant or contravariant, therefore has polynomial entries of degree
at most `2t`. This statement is independent of the dispersion variable.

The kinematics are

    a=(M_o^2+|q+r|^2)/(2b),   a_x=a+(z-|r|^2)/(2b),
    p=(a,b,q+r),             k=(a_x,0,q).

Direct multiplication shows that `L(beta)` takes these vectors to the
same formulas with `r` replaced by `r+b beta`. It leaves
`q,X=|q|^2,z,M_o,b` fixed. These are rational-function identities, not an
asymptotic null-rotation argument.

Let `F(q,r;z)` denote the raw covariant tensor family and `C_d J` its
Cauchy transform. Covariance says

    F(q,r+b beta;z) = rho(beta) F(q,r;z).

The jump transforms by the same `rho(beta)`. Since this matrix is
independent of `z,z'`, componentwise distributional Cauchy integration
gives

    (C_d J)(q,r+b beta;z) = rho(beta) (C_d J)(q,r;z).

Thus the polynomial remainder transforms in exactly the same way.
Choosing any fixed admissible `r_*` and
`beta=(r-r_*)/b` proves it is polynomial in `r`, with coefficients
depending on `q,z`. This conclusion applies to every remainder from a
common covariant splitting; it is not an assumption of polynomial
transverse coefficients. Equivalently, comparison of the coefficients
of `z^j` proves that each coefficient has this orbit property.

For the spin-one output, the adapted vectors can be written

    e_z^(n)(p)=(M_o/b)n-p/M_o,
    e_i^(n)(p)=e_i+(q_i+r_i)n/b.

At fixed `b,M_o,q` they are polynomial of degree at most two in `r`.
Contracting the raw remainder therefore adds at most two to the degree.
Evaluating the polynomial in `z` at `z=|r|^2` gives the conservative bound

    deg_r <= 2t+2+2e.

The reversed horizon gives the same conclusion with `q` and `r`
interchanged. There is no assumption that a nonpolynomial function of
`X` must itself become a polynomial: it remains an allowed coefficient.

This explains the semi-local boundary. A term `f(X) z^j`, including a
nonpolynomial `f`, becomes `f(|q|^2)|r|^(2j)` and is separated.
Decorating it by a finite covariant tensor only raises the finite degree.
A term with a genuine nonzero `z` jump belongs to the spectral input, not
to the zero-jump subtraction ambiguity. An arbitrarily assigned
nonpolynomial function of `r` multiplying a zero-jump term would violate
the orbit identity above unless it is part of the permitted finite
polynomial tensor action. None is a counterexample to this theorem.

## 3. Continuous Hilbert-space regularization

Write `D=M^2+R`. With the manuscript's finite labels,

    chi = D l/3
        + (R-5M^2+6M^4/D) s_z
        + (-4M+8M^3/D) r_i s_zi
        + 4M^2 r_i r_j s_ij^TF/D.

This is the exact expansion of `D(l/3+d_A d_B s_AB)` with

    d_z=(R-M^2)/D,    d_i=-2M r_i/D,    |d|^2=1.

In particular, `s_11+s_22=-s_z`; the trace-free transverse tensor is
`s_ij^TF=s_ij+delta_ij s_z/2`. Both the trace contribution and the
factor two in the mixed `s_zi` term matter.

Choose any smooth cutoff `zeta` equal to zero on `M<=1` and one on
`M>=2`. Put

    S = D l/3 + (M^2-5R)s_z
        + (4M-8R/M) r_i s_zi + 4 r_i r_j s_ij^TF,
    chi_reg=chi-zeta S.

There is no singular small-mass subtraction: `zeta/M` vanishes there.
For `M>=2`, its **exact**, rather than asymptotic, remainder is

    chi_reg = 6R^2 s_z/D
            + 8R^2 r_i s_zi/(M D)
            - 4R r_i r_j s_ij^TF/D.

On any compact `r` set this is `O(M^-2)`, with its vector term
`O(M^-3)`. Its squared norm is integrable against `M dM`. At small
mass `|d|=1` gives `||chi||<=C(M^2+R)`. These estimates give one
integrable square majorant on every compact `r` set, so dominated
convergence proves continuity into `H`, including `r=0`.
They also give a global, nonoptimal bound
`||chi_reg(r)||_H<=C(1+|r|^5)`. The prescription respects transverse
orthogonal changes of frame, including `diag(-1,1)`, and the same cutoff
can be used on both horizons.

It remains important to compare **every** Cauchy order, not a few
expansion coefficients. Define

    x=R-z0,   y=-M^2-z0,   x-y=D,
    N=D chi,
    Q_d(x,y)=sum_(j=0)^(d-1) x^(d-1-j)y^j.

The all-order polynomial identity

    (x-y)Q_d=x^d-y^d

has base `Q_1=1` and induction step `Q_(d+1)=x Q_d+y^d`.
Since `N` is polynomial of transverse degree at most four, it gives

    chi_C,d := chi (x/y)^d,
    chi_C,d-chi_reg = N Q_d(x,y)/y^d + zeta S.             (1)

The right side is a polynomial in `r` of degree at most `2d+2`.
For every fixed integer `d>=2`, `chi_C,d` is also in `H`:
at infinity it is `O(M^(2-2d))`, and at zero `y` is bounded away
from zero. Both waves in the left side of (1) are continuous `H`
vectors. Finite polynomial interpolation therefore expresses every
coefficient of the right side as a finite linear combination of `H`
values. Its coefficients really are in `H`; no norm is being assigned
to the individually divergent, unregularized coefficients.

Application of the bounded operator `mu_n(q)` preserves this
polynomial in `r`, with arbitrary `q`-dependent coefficients.
The same statement holds on the other horizon.

## 4. Gap comparison, denominator clearing and transverse axes

At `z=R`, the factor `(M^2+R)^2` in `D:jump` divided by the Cauchy
denominator `-M^2-R` is `-(M^2+R)`. Thus, up to the **same**
nonzero normalization on both horizons, its Cauchy integral is precisely
`mu_n(q)chi_C,d(r)`. Section 3 replaces this by
`mu_n(q)chi_reg(r)` at the cost of a polynomial in `r`.

Let `G_A^n` and `G_A^bar n` be the contracted common gap values. The
preceding sections give, absorbing the common nonzero constant,

    G_A^n = A_A + R_A,       R_A polynomial in r,
    G_A^bar n = B_A + Q_A,   Q_A polynomial in q.

The degrees are bounded by
`K=max(2t+2+2e,2d+2,3)`. The tensor contraction
`T_nn T_bar n bar n` has zero total boost weight. Also the ratios
`n/b` and `bar n/a` in the adapted frames are invariant under opposite
rescalings of the null basis. The second channel can therefore be
written at the same `b`; no extra boost-dependent factor is introduced.

Put `w=q+r` and `D_o=M_o^2+|w|^2`. The exact output-frame relation is

    G_z^n=((|w|^2-M_o^2)/D_o) G_z^bar n
           -(2M_o w_i/D_o) G_i^bar n.

Multiplication by the strictly positive `D_o` gives `D:two-horizon`.
Every resulting remainder is still separated: multiplication by
`D_o`, `|w|^2-M_o^2` or `w_i` raises the degree in either selected
variable by at most two. One uniform conservative bound is therefore

    N_sep = max(2t+2+2e,2d+2,3)+2.                         (2)

Nothing in this bound depends on the values of `q,r`. Coefficients and
norm bounds may depend on the compact positive output-mass test.

Initially the two gap calculations give this identity off `q=0,r=0`.
The left side is continuous, weakly on output-mass tests: the regularized
waves are continuous, and `mu_n(q)` is strongly continuous. For the latter,
positive-measure Cauchy-Schwarz bounds the square of
`||(mu(q)-mu(q0))psi||` by
`integral |exp(iq.z)-exp(iq0.z)|^2 d<psi,mu(z)psi>`;
dominated convergence applies since `mu(1)=id`.
Projection-valuedness is not needed.

Take total-degree polynomial interpolation operators `I_q,I_r` onto
polynomials of degree at most `N_sep`, with all nodes away from the zero
vector. Such a projection exists at every order, not just orders
checked by computation: use nodes `(i+1,j+1)` for `i+j<=N_sep` and the
Newton basis
`binom(x1-1,i)binom(x2-1,j)`. Order pairs by increasing `i+j`.
The evaluation matrix is triangular with diagonal one, since a
nonzero entry at node `(k+1,l+1)` requires `i<=k,j<=l`. These are
polynomials, interpreting the binomials by falling factorials.
The two projections commute, acting on different variables.
Off both axes the separated form implies

    (1-I_q)(1-I_r)F=0.

Every interpolation value used here is also off the relevant axes.
By continuity this identity holds on the axes as well. Hence

    F=I_q F+(1-I_q)I_r F

is a global separated polynomial decomposition. Interpolation gives
continuous, distribution-valued coefficients. This proves existence
of the asserted extension, rather than assuming an arbitrary singular
axis term vanishes.

Finally, integration of any polynomial in one Fourier variable
against the Fourier transform of an annular position test is a finite
combination of that test's derivatives at zero and is zero. Thus both
ambiguity classes are annihilated by the stated pair of annular tests.
Deriving the later charge and critical-tail assertions is outside this
conditional verification.

## 5. Evidence and literature status

`verify.py` replays the null-rotation metric, group and kinematic
identities; the complete polarization expansion; the exact large-mass
remainder; reflection compatibility; the base and generic step of the
all-order division identity; the finite degree facts; the actual
adapted-tetrad relation and horizon signs; and the denominator clearing
in `D:two-horizon`. It compares these conclusions
with `exact_certificate.json`. The all-order argument is symbolic
induction, not bounded enumeration. Analytic dominated-convergence,
distributional and interpolation arguments are supplied above, not
mislabelled as compiler-checked facts.

The bounded Jacobian operation is
`matrix.symbolic.multiply.compute`, the exact product
`L(beta)L(gamma)`. Its typed contract was inspected before the local
symbolic verifier was written. The exact payload and full adapter
response are in `jacobian_request.json` and `jacobian_result.json`.
No timeout, transport failure or incomplete result is mathematical
evidence.

The external propositions relevant to scope are recorded separately:

- Epstein-Glaser, *The role of locality in perturbation theory* (1973),
  Section 5.1, pp. 231-237: tempered cone splitting and finite local
  ambiguity. The source supports this limited statement, not the
  manuscript's additional fixed-output and covariance constructions.
- Bros-Iagolnitzer, *Causality and local analyticity: mathematical study*
  (1973), Section 1, pp. 155-156: the tempered cone/tube equivalence.
- Bzowski-Skenderis, arXiv:1402.3208v4, Section 1: the known semi-local
  obstruction to the on-shell-amplitude shortcut. It is not a
  counterexample to the covariant orbit argument.

The primary sources have been read by the Engineer; independent citation
attribution and mathematical review remain the host Reviewer's work.
No false staged assertion has been established in this scoped argument,
so no manuscript `F_` refutation is manufactured.

Compared with the initial unresolved semi-local concern, the improvement
is an arbitrary-parameter derivation with the explicit uniform bound
(2), all-order regularization identity (1), and an exact algebra replay.
The unresolved frontier is upstream: whether `D:causal-continuation`
and `D:jump` actually follow from `ass:framework`. This result is a
bounded checkpoint, not completion of the publishable campaign.
