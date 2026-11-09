# Exact certification of the prescribed-probability order trial

## Statement and source

The target is Proposition `prop:order-trial` in the staged September 25,
2026 manuscript, not its complete factoring theorem. Its parameters are
integers `n >= 128`, `B = 2^n`, `Q = B^16`, `2 <= m < B`, and a unit `a`
modulo `m`, with true multiplicative order `r`. The claimed output is either
absent or a positive multiple `d < B` of `r`, and

    Pr(output = r) = phi(r) 2^(-ceil(log2(r))-10).

All probabilities include the actual ancillary-success probability.
Postselection and normalization of the selected branch are not permitted.

Source paths below are relative to
`research/openai_manuscript/Exact-quantum-factoring-over-a-fixed-finite-gate-set-September-25-2026/build/sections/`:

| Assertion | Source locator | Scope |
|---|---|---|
| Parameters and finite gates | `02-model.tex`, equation `eq:parameters-n` | Definition |
| Selected-branch matrix | `03-order-transform.tex`, `lem:transform`, `eq:phase-overlap` | Proved below |
| Unique rounded rational labels | `03-order-transform.tex`, `lem:bins` | Proved below |
| Residue-class mass | `03-order-transform.tex`, `eq:residue-probability` | Proved below |
| Exact arithmetic and majorant | `04-dyadic-order.tex`, `lem:majorant` | Proved below |
| Three-mode probability correction | `04-dyadic-order.tex`, completion of `prop:order-trial` | Proved below |
| Full factorization theorem | `01-introduction.tex`, `thm:main` | Not certified here |
| Factoring process | `05-factor-process.tex`, `prop:process` | Separate open dependency |
| Deferred tests | `06-exactness.tex`, `prop:known-probability` | Separate open dependency |
| Deterministic primality | `appendix-primality.tex`, `lem:primality` | Separate open dependency |

## Prior knowledge and proof boundary

The preexisting ledger contains only the open campaign goal; it contains no
stronger certified mathematical result. The shared Wiki search found no
applicable order-trial result. The manuscript's references to phase kickback,
Shor sampling, and approximate power sums explain ancestry, but none is
needed as an unproved theorem in this verification. The circuit, arithmetic
identities, and correction calculation will be derived directly. The
elementary finite-group order argument and rational-label recovery will
also be given directly, rather than importing a continued-fraction theorem.

Testing a small artificial `Q`, or a numerator not tied to
`k = floor(jQ/d + 1/2)`, cannot refute the manuscript. A bounded no-witness
search cannot establish its universal claim.

## Verification theorem

**Theorem.** On every original admissible input, the three-mode construction
in Sections 3-4 implements Proposition `prop:order-trial`, using the stated
fixed gates with polynomial worst-case bit, gate, and workspace costs. Its
arithmetic does not enumerate the residues modulo a candidate denominator.
In fact its integral envelope satisfies the stronger universal bounds

    |I(u)| >= 1/(2d),       S(d,j) >= 1/(8d).

The constant `1/2` in the corresponding interval-average inequality is
sharp. This is an independent verification theorem and an algebraic
strengthening, not a counterexample. Novelty and publishable significance
remain for independent review; they are not established by compilation.

The proof is universal. The finite replays at the end diagnose the
implementation and do not supply any universal inference.

## 1. The selected branch, including its probability

Put `b=16n` and `Q=2^b`. Let

    chi = Q^(-1/2) sum_y i^floor(4y/Q) |y>.

Hadamards, `Z=S^2` on the most significant bit, and `S` on the next bit
prepare this state exactly. For a forward modular shift `T_D`, write
`D=qQ/4+s (mod Q)`, `0<=q<4`, `0<=s<Q/4`. Exactly `4s` of the `Q`
starting positions cross `q+1` quarter bins and the other `Q-4s` cross
`q` bins. Therefore

    <chi|T_D|chi> = (1-4s/Q)(-i)^q + (4s/Q)(-i)^(q+1)
                 = g(D/Q).

The sign is negative imaginary at `D=Q/4`; this uses a forward shift and
the conjugate phase at the final position.

Run the Hadamards and controlled shifts in the manuscript's order, with
logical output `k_j` on the physical input bit `x_(b-1-j)`. For fixed input
and output labels, that bit passes through one Hadamard, so its matrix
element is `2^(-1/2)(-1)^(x_(b-1-j) k_j)`. The unprocessed bits `x_i`
are still available as controls. The shifts commute and add. Consequently
the data matrix element and auxiliary shift are exactly

    Q^(-1/2)(-1)^h,    h = sum_(i+j=b-1) x_i k_j,
    D = sum_(i+j<b-1) 2^(i+j) x_i k_j.

Expanding the binary product partitions all terms into `i+j<b-1`,
`i+j=b-1`, and `i+j>=b`. The last group is divisible by `Q`; thus
`xk = D+(Q/2)h (mod Q)`. Since `g(z+1/2)=-g(z)`, unpreparing `chi`
and testing zero gives the **unnormalized** matrix entry

    Q^(-1/2)(-1)^h <chi|T_D|chi> = Q^(-1/2)g(kx/Q).

This is a block of a specified unitary circuit, not an assumed Fourier
matrix or a normalized conditional transform. The zero test may fail.

Prepare `Q^(-1/2) sum_x |x>|a^x mod m>` by modular powering with temporary
arithmetic work uncomputed. For a selected output `k`, the second-register
vector is

    (1/Q) sum_x g(kx/Q)|a^x mod m>.

If `r` is the order, two powers are equal exactly when their exponents
are congruent modulo `r`. For the nontrivial direction, divide their
exponent difference by the least positive period; a nonzero remainder
would contradict minimality of `r`. Different residue classes therefore
give orthogonal basis states. At `k=k(r,j)` the actual joint probability is

    sum_(t=0)^(r-1) P(r,j,t).

No division by the phase-register success probability occurs. No claim
identifies `P(d,j,t)` with a physical probability when `d != r`.

## 2. Recovering a rounded label

For `0<=k<Q`, run the Euclidean continued-fraction recurrence on `k/Q`.
Take its last convergent `p/v` with `v<B`. This includes the terminal
convergent if its denominator is below `B`. Consecutive pairs have
determinant of magnitude one, by their recurrence. If the chosen
convergent is not terminal, its next denominator is at least `B`; writing
the positive remaining tail as `theta` gives

    |k/Q-p/v| = 1/[v(v theta+v')] <= 1/(vB).

For the first convergent the formal preceding pair is `(1,0)`. A terminal
convergent has zero error. If a rounded reduced label `j/d` differs from
`p/v`, its integral cross-product gives

    |j/d-p/v| >= 1/(dv) >= 1/[(B-1)v]
                          > 1/(vB)+1/(2Q).

The strict inequality follows from `2Q>vB(B-1)`, since `v<B` and
`Q=B^16`. This contradicts the preceding estimate and the rounded-bin
bound. Hence every valid label equals `p/v`. Testing `0<=p<v<B` and the
exact integer equation `k=floor(pQ/v+1/2)` accepts precisely the valid
labels, and proves uniqueness. At zero this recovers `(d,j)=(1,0)`.
The code implements this recurrence without searching denominators.

## 3. Sharp algebraic interval-average bound

**Lemma.** For every real `z` and `|eta|<=1/2`,

    |H(z,eta)| >= 1/2,    H(z,eta)=integral_0^1 g(z+eta v) dv.

For `eta=0`, the point lies on a side of the diamond, so its squared
modulus is `t^2+(1-t)^2 >= 1/2`. For negative `eta`, reverse the interval:
`H(z,eta)=H(z+eta,-eta)`. For positive `eta`, use `w=4z` and
`a=4eta`, so `0<a<=2`. Quarter-turn covariance
`g((q+w)/4)=(-i)^q g(w/4)` reduces the interval start to `s in [0,1]`.
Only the following three sectors can occur.

If `s+a<=1`, integration of the first affine side gives

    R0=a(1-s)-a^2/2,    I0=-as-a^2/2,
    R0^2+I0^2-a^2/4
      = 2[a(s+a/2-1/2)]^2+(a/2)^2 >= 0.

If `1<=s+a<=2`, set `x=1-s`, `y=s+a-1`; then `x,y in [0,1]`,
`a=x+y`. Integration before and after the vertex gives

    R1=(x^2-y^2)/2,    I1=(x^2+y^2)/2-x-y.

Put `E=x(1-x)+y(1-y)>=0`. The exact certificate is

    R1^2+I1^2-a^2/4 = R1^2+aE/2+E^2/4 >= 0.

If `2<=s+a<=3`, set `x=1-s`, `y=s+a-2`. Now `x,y>=0`,
`p=x+y<=1`, `a=1+p`, and `zeta=1-p>=0`. Integration over two partial
sides and the intervening complete side gives

    R2=(x^2+y^2)/2-y-1/2,    I2=(x^2+y^2)/2-x-1/2,
    R2^2+I2^2-a^2/4
      = 2x^2 y^2+2 zeta pxy+zeta/4+3 zeta p/4+p^2 zeta^2/2 >= 0.

Dividing the integral by `a` proves the lemma. Endpoint sectors agree
because the phase and its primitive are continuous. At `z=0,eta=1/2`
the average is `-i/2`, giving equality. Sharpness is for the stated
all-real interval lemma; it does not assert that a finite rounded bin has
`eta=1/2`.

`Main.lean` proves these three polynomial inequalities, their equality
example, and the power sums below with zero proof holes. The compiler does
not formalize the interval-to-sector identification: that is the preceding
explicit calculation, independently checked symbolically by integrating
the actual affine sides in `verify.py`.

## 4. Progression sums and a uniform error estimate

Fix a reduced label and put `eta=k-jQ/d`. If `x=t+ld` and
`u=jt mod d`, periodicity gives the exact equality

    g(kx/Q) = g(u/d+eta x/Q).

The last argument moves monotonically through distance strictly less than
`1/2`; it crosses at most two quarter-integer boundaries. Split the
integer index range at the ceilings of their exact rational crossing
indices. The value on each of at most three parts is affine in `l`, and
the sum is its constant times the count plus its slope times
`(lo+hi-1)(hi-lo)/2`. At an exact crossing either affine formula has the
same value. The implementation uses each part's midpoint to choose its
affine side; this also handles decreasing arguments without an orientation
error. This computes `P` without iterating through the progression.

Write `h=d/Q<1` and `f(v)=g(u/d+eta v)`. In the complex coordinate
`l1` norm the phase has norm exactly one and Lipschitz constant eight.
Thus `f` has Lipschitz constant at most four. The intervals of length `h`
starting at the progression points form one interval starting in `[0,h)`
and ending in `[1,1+h)`. Their total length is at most `1+h`. On each,
the integrated left-rectangle error is at most `2h^2`. The two endpoint
discrepancies contribute at most `2h`. Therefore, with

    A_t = (1/Q) sum_(x=t mod d) g(kx/Q),
    I(u) = (1/d) integral_0^1 f(v) dv,

the Euclidean norm, bounded by the coordinate `l1` norm, satisfies

    |A_t-I(u)| <= [2h(1+h)+2h]/d <= 6/Q.

Also `|A_t|<=1/d+1/Q` and `|I(u)|<=1/d`. Consequently

    |P(d,j,t)-|I(u)|^2| <= (6/Q)(2/d+1/Q) <= 18/Q <= 32/Q.

This proves the manuscript's estimate without a transcendental
interpolation estimate. The interval lemma further gives
`1/(2d)<=|I(u)|<=1/d` for every real `0<=u<d`.

The original summands have real and imaginary denominators dividing `Q`.
The amplitude denominator divides `Q^2`; hence `P` has denominator
dividing `Q^4=2^(64n)`. Intermediate rational computations need not be
dyadic, but this final value is.

## 5. Coefficient rounding, boundary ownership, and exact summation

The zero-mean phase has a continuous, periodic quadratic-piece primitive
`G` with `G(0)=0`. For `eta != 0`,

    I(u)=[G(u/d+eta)-G(u/d)]/(d eta).

For `eta=0` use `g(u/d)/d`. Splits occur only when `u/d` or
`u/d+eta` is a quarter-integer. The first list has three interior
boundaries; the second has at most four. Thus there are at most **eight**
pieces. On each, `I` is quadratic or affine and `J=|I|^2` has degree at
most four. These assertions are exact identities, including at a boundary.

For definiteness the implementation owns the pieces as `[L,H)`: every
internal boundary belongs to its right-hand piece, and `u=d` is excluded.
The integer residues of a piece are exactly

    ceil(L) <= u < ceil(H).

Thus a boundary integer is never counted twice or omitted. Rounding can
make the two envelope polynomials disagree at the boundary, but both
approximate the same `J` within the stated bound. The same ownership is
used to evaluate `U` and to compute `S`.

Set `D=QB^8=2^(24n)`. For each coefficient `a_q`, replace it by
`ceil(Da_q)/D`. Since all evaluation points are nonnegative,

    0 <= Jtilde(u)-J(u) < (1+u+u^2+u^3+u^4)/D <= 1/Q.

Indeed `u<B`, and `B^8 > sum_(q=0)^4 B^q` for `B>=2`. The checker
certifies the latter polynomial after substituting `B=2+w`: every
coefficient is nonnegative and its constant coefficient is positive.
Negative original coefficients cause no sign reversal, because the
basis powers `u^q` are nonnegative.

Define `U=Jtilde+64/Q`. The preceding error estimate proves

    32/Q <= U(d,j,jt mod d)-P(d,j,t) <= 97/Q <= 128/Q.

In particular `U` is nonnegative. Summing the pointwise lower and upper
bounds on `J` gives

    1/(8d) <= S=(1/2)sum_u U <= 1/(2d)+65d/(2Q) <= 2.

The last inequality follows from `d>=1`, `d<B` and
`65<=3B^15`. Its universal polynomial certificate is again checked after
`B=2+w`. This implies the manuscript's weaker `S>=1/(128d)`.

For exact nonenumerative summation, let
`F_q(M)=sum_(u=0)^(M-1) u^q`. The five formulas are

    F0=M,
    F1=M(M-1)/2,
    F2=M(M-1)(2M-1)/6,
    F3=[M(M-1)/2]^2,
    F4=M(M-1)(2M-1)(3M^2-3M-1)/30.

Each has zero value at zero and satisfies
`F_q(M+1)-F_q(M)=M^q`. Checking these polynomial identities proves the
formulas for every natural `M` by induction, not by testing values of
`M`. The last four are also proved in Lean. On each piece sum the rounded
polynomial using `F_q(ceil(H))-F_q(ceil(L))` and add its constant offset.
This takes at most eight pieces times five powers, independently of `d`.
Although these closed formulas use exact divisions by odd integers, their
results are integer power sums. Consequently `U` has denominator dividing
`D` and `S` has denominator dividing `2D`; both are dyadic.

## 6. The actual three correction modes

Let `ell=(d-1).bit_length()=ceil(log2 d)`, including `ell=0` at `d=1`,
and `lambda=2^(-ell-10)`. Then `lambda<=1/(1024d)`. Put

    c=B^(-10) floor(B^10 lambda/S),    rho=lambda-cS.

Integer Euclidean division proves, without assuming `lambda/S` dyadic,

    0<=c<=1/8,    0<=rho<S/B^10<=2/B^10.

All **sampled** quantities are dyadic. Choose modes with probabilities
`1/2,1/4,1/4`. First reject invalid `d,j`, and reject unless
`a^d=1 (mod m)`. Mode 2 also rejects `t>=d` before evaluating `P`.

Mode 1 retains a selected, decoded quantum outcome with probability `c`.
Mode 2 draws `d,j,t` as independent uniform `n`-bit strings and retains
with probability `2B^3(U-P)c`. Mode 3 draws independent uniform `d,j`
and retains with probability `4B^2 rho`. These are nonnegative and at most

    256 B^(-13) <= 1,    8 B^(-8) <= 1,

respectively, already for `B>=2`. The checker verifies the exact
polynomial inequalities `B^13>=256`, `B^8>=8` on this full range. Every
original admissible `n` is therefore covered.

Now fix **the true order** `d=r` and one reduced numerator `j`. With
`T=sum_t P(d,j,t)` and `V=sum_u U(d,j,u)=2S`, the three actual,
unconditional masses are

    Mode 1: (1/2)cT,
    Mode 2: (1/4)B^(-3) sum_t 2B^3(U(d,j,jt mod d)-P(d,j,t))c
            = (1/2)c(V-T),
    Mode 3: (1/4)B^(-2) 4B^2 rho = rho.

For `d>1`, the extended Euclidean recurrence maintains each remainder as
an integer linear combination of `j,d` and ends at their gcd, one. Thus
it gives an inverse for `j` modulo `d`, so
`t -> jt mod d` is a permutation; for `d=1` it is the one-point
permutation even though `j=0`. The total is

    cT/2+c(V-T)/2+rho = cS+rho = lambda.

The unique bins and retained classical mode/label records separate the
`phi(r)` reduced numerators. Hence the probability of returning `r` is
**exactly** `phi(r)2^(-ceil(log2 r)-10)`. This includes `r=1`.

Finally a unit modulo `m` has a positive period below `m`: its powers
lie in the finite set of at most `m-1` units, and cancellation gives a
positive period. If any accepted candidate has `a^d=1`, division
`d=qr+s`, `0<=s<r`, gives `a^s=1`; minimality forces `s=0`.
Every returned candidate is therefore a positive order multiple below
`B`. Its being a false candidate never requires a physical interpretation
of its artificial `P(d,j,t)`.

## 7. Bit complexity, gates, and retained records

All loop bounds in the production arithmetic are polynomial in bit length
or absolute constants, never a candidate's value. Euclidean continued
fractions take `O(n)` divisions on `O(n)`-bit integers. Progression sums use
at most three affine parts; envelopes use at most eight quartic parts.
The power-sum integers have at most `5n+O(1)` bits.

Write `e=kd-jQ`, so `eta=e/d`, `|e|<=d/2`, and a nonzero `eta` has
`|eta|>=1/d`. All rational boundaries and coefficients consequently have
`O(n)` bits. In fact the envelope boundaries are `dq/4` or `dq/4-e`.
The integer count of progression terms can be exponential, but is used
only as an `O(n)`-bit integer in closed affine sums. There is no iteration
through its terms.

The denominator exponent of `P` is at most `64n`, of `U` at most `24n`,
and of `S` at most `24n+1`. The exponent of `c` is at most `10n`;
that of `rho` is at most `34n+1`, since `n>=128` and
`ell+10<=n+10`. Thus the retention exponents have linear bounds as well
(the loose common bound `74n+2` suffices). Intermediate numerators,
including scaled floors and modular-power exponents, also have `O(n)`
bits. Schoolbook integer arithmetic and Euclidean division therefore give
polynomial bit-time bounds, with no factorization of `d` or `r`.

There are `O(b^2)` controlled shifts. Each is a modular binary addition
on `b` bits with polynomial gate cost; a ripple-carry realization gives
`O(b)` cost per shift. The controls are an already produced output bit
and an unprocessed input bit. Their conjunction is computed by Toffoli,
used as a control, then uncomputed. The shift scratch is uncomputed.
The initial modular-powering computation and the classical arithmetic
also have uniformly bounded polynomial Boolean circuits: compute their
intermediates, copy the result, and reverse to clear temporary scratch.
NOT, CNOT, and Toffoli implement those Boolean steps. All required
Hadamards and `S`, inverse, or controlled phases belong to the stated
fixed gate set.

To sample `A/2^T` exactly, prepare `T` Hadamard bits and retain exactly
those integers below `A`. This uses a comparator, not an approximate
rotation. A common polynomial `T` can pad shorter denominators. Two fair
bits implement the three-mode choice; fresh `n`-bit labels implement its
uniform guesses. Keep the random labels and copies of measured/control
outcomes so distinct classical histories are orthogonal. No copy of the
exponent label is made before the selected transform's interference.
No failed flag is projected away and renormalized. Storing all temporary
histories still uses polynomial space and permits a unitary implementation
and its inverse.

## 8. Certificate scope and reproduction

From the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/order_trial/verify.py

Only Python, its standard library, and SymPy are needed for that replay.
The script checks 50 exact symbolic identities/positive-coefficient
conditions, including the three integrated sectors, all five power-sum
recurrences, every global `B` inequality, and the correction identity.
It independently replays the saved Jacobian SOS coefficient identity.
This is the universal certificate; none of those checks ranges over the
input values `n,d,j`.

The supplemental diagnostics compare 363 progression sums and 1,360
selected-transform entries at artificial small precision. These are
implementation checks, **not** manuscript counterexamples or universal
proofs. Original-domain replays use 16 labels at `n=128,129,256`, including
`d=1`, exact quarter boundaries, zero `eta`, near-extremal positive and
negative `eta`, and denominators of 256 bits. They check 87 residues,
ten direct small-residue sums against the nonenumerative sum, and attain
the eight-piece and three-piece limits. Seven original-domain group
inputs additionally verify the actual three mode weights and the exact
`phi(r)lambda(r)` mass, with 15 reduced true numerators. These finite
checks remain supplemental.

The typed Jacobian operation was inspected before use. The floor-sum
operation's `m,a,b<=1,000,000` contract cannot represent the original
large parameters and was not substituted for this problem. The selected
operation is `polynomial.sos.decomposition.check`, server `0.14.0`,
protocol `2025-11-25`. Its exact payload and complete typed response are
`jacobian_payload.json` and `jacobian_output.json`; the adapter exit code
is zero and its verdict is `is_valid=true`. It certifies the zero-sector
identity only, not the whole order trial. No UNKNOWN or timeout is used.

The fresh official Lean run is recorded in `lean_verification.json` and
`lean_check.json`, with source and statement-fidelity binding. It reports
Lean **4.31.0**, `exit_code=0`, `audit_exit_code=0`, and `proof_holes=[]`.
The claim-bound archive is
`certificates/C_SECTOR_BOUND-6221f222ac30967c.json`. The separate fidelity
document explicitly limits the formal claim. The first elaboration run
needed the standard `noncomputable section` for real division; it was
recorded inconclusive, not as a mathematical refutation, then superseded.

**Limitations.** The compiler verifies the encoded algebra, not the full
quantum semantics, analytic reduction, or statement fidelity. Those are
the universal arguments in this report and require independent review.
No literal false manuscript assertion was found in the target sections,
so no `F_...` refutation claim is warranted. The full factoring theorem,
the process caps, deferred-filter equivalence, and primality appendix
remain open in this audit. Independent review, novelty assessment, and
campaign acceptance have not been performed by the Engineer.
