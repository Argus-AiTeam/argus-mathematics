# Beyond the strong-L3 half-space exclusion: exact kinematic separation

## What this comparison establishes

The alignment hypothesis in `critical-alignment-exclusion.md` is not contained
in the strong spatial `L^3` hypothesis of the applicable half-space exclusion.
It admits smooth solenoidal no-slip fields with a genuine nonzero `1/r` tail.
More strongly, it admits such fields with **arbitrary tail amplitude and
arbitrarily large weak-L3 norm**.

These are **kinematic comparison fields, not solutions of the profile
equation**. Their purpose is to separate sufficient hypotheses. No nonzero
backward Navier--Stokes solution is constructed, and no counterexample to
Seregin's theorem is claimed.

The new profile theorem therefore supplies a different sufficient exclusion
condition in a critical-tail regime where strong-L3 exclusion does not apply.
It does not replace Seregin's theorem on its entire solution class: our theorem
retains H1 (spatial derivative decay), H2 (canonical pressure), and the
quantitative alignment condition. This is a demonstrated gain in the range of
admissible **hypotheses**, not a strict inclusion between sets of nonzero
solutions, both of which the respective theorems exclude.

## 1. The closest applicable primary statements

### Seregin's endpoint theorem is strong spatial L3

G. A. Seregin, *On Smoothness of L_(3,infinity)-Solutions to the Navier--Stokes
Equations up to Boundary*, version
[arXiv:math/0410056v1](https://arxiv.org/pdf/math/0410056v1), Theorem 1.1,
p.2, equations (1.1)--(1.4); mixed-norm definition on p.3.
Published reference: Math. Ann. 332 (2005), 219--238,
<https://doi.org/10.1007/s00208-004-0625-z>.
The locators here are to the versioned primary preprint actually read.

On `Q^+=B_1^+ x (-1,0)`, the theorem assumes

    v in L_(2,infinity) intersect W_2^(1,0)
         intersect W_(9/8,3/2)^(2,1),
    p in W_(9/8,3/2)^(1,0),

the Navier--Stokes equations almost everywhere, and zero velocity on the flat
wall. If, in addition, `v in L_(3,infinity)(Q^+)`, then `v` is Holder
continuous on `closure Q^+(1/2)`.
The source's mixed-norm definition is

    ||v||_(3,infinity,Q^+) =
      ess sup_(-1<t<0) ||v(.,t)||_(L^3(B_1^+)).

It is **not** the spatial Lorentz norm `L^{3,infinity}`. The source also
explains that its displayed differentiability conditions hold for weak
Leray--Hopf solutions and their associated pressure.

For a backward similarity ansatz with coefficient `a>0`,

    u(x,t)=[2a(-t)]^(-1/2) U(x/sqrt(2a(-t))),

the exact change of variables gives

    integral_(B_R^+) |u(x,t)|^3 dx
      = integral_(B_(R/sqrt(2a(-t)))^+) |U(y)|^3 dy.                (1.1)

Thus strong global `L^3` of the profile gives the local endpoint bound.
In the solution class of the cited theorem, boundary regularity and
self-similarity force the profile to vanish: along
`x=sqrt(2a(-t))y`, a nonzero fixed `U(y)` would contradict boundedness near
the space-time origin. The source's differentiability assumptions are not
silently deleted from this implication.

### The half-space comparison is explicit in Bradshaw--Tsai

Z. Bradshaw and T.-P. Tsai, *Rotationally corrected scaling invariant
solutions to the Navier--Stokes equations*,
[arXiv:1610.05680v1](https://arxiv.org/pdf/1610.05680v1), Appendix 5,
p.22, paragraph preceding Open Problem 5.3 and reference [19].
That paragraph explicitly excludes backward half-space scaling-invariant
solutions in `L^infinity((-1,0);L^3(R^3_+))` by Seregin's theorem.

Open Problem 5.3 separately considers no-slip backward self-similar profiles
with `|U(y)|<=C/(1+|y|)`, using (5.5) and (5.7). The forward existence results
in the main body are not backward exclusion results.
This is the historical distinction in the identified 2016 version, **not**
a claim that no later theorem addresses any critical-tail subclass.

Both PDFs and their extracted text are retained in `literature/` as
`seregin-math-0410056v1.*` and `bradshaw-tsai-1610.05680v1.*`.
The previous independent Reviewer also read these exact statements; see
`literature/reviewer-primary-excerpts.txt`.
The ledger assumptions `SEREGIN11` and `BT_HALFSPACE` record this comparison
on `CWP_NOVELTY`; both citations and this construction were independently
accepted in Round 2. The earlier five confirmed citations are unchanged.
The original-result submission now uses this settled comparison together
with the pressure-specific and geometric-criterion comparisons in
`radial-pressure-upper-bound.md`, section 7, and
`critical-alignment-exclusion.md`, section 5.

## 2. A closed-form critical tail and its exact norms

Let `y=(x_1,x_2,z)`, `r=|y|`, `q=1+r^2`, and define

    S(y)=z(-x_2,x_1,0)/q^(3/2),  U_epsilon=epsilon S,  epsilon>0.  (2.1)

The denominator is positive everywhere. The field is smooth on all of `R^3`,
vanishes at `z=0`, and is divergence-free: it is an axisymmetric azimuthal
field, and direct Cartesian differentiation gives the same conclusion.
Every Cartesian derivative of order `j<=2` is `O(r^(-1-j))` at infinity
and bounded near zero. Hence the precise H1 hypotheses hold.

Writing `rho^2=x_1^2+x_2^2`, the exact identities are

    curl S =
      (-x_1(1+rho^2-2z^2), -x_2(1+rho^2-2z^2),
        z(2+2z^2-rho^2)) / q^(5/2),

    Delta S = -3(7+2r^2)z(-x_2,x_1,0)/q^(7/2),
    S+y dot grad S = 3z(-x_2,x_1,0)/q^(5/2),
    (S dot grad)S = -z^2(x_1,x_2,0)/q^3.                         (2.2)

In particular `S dot curl S=0`. The small-amplitude example below is a
smallness example for the **weighted Lamb-vector ratio**, not a claim that
the tail itself is geometrically near Beltrami. Section 3 supplies genuinely
large-norm examples by a different mechanism.

Use the norm `||F||_r^2=integral_H r|F|^2 dy`. Direct integration over the
entire half-space gives

    ||Delta U_epsilon||_r^2 = (29 pi/10) epsilon^2,
    ||U_epsilon cross curl U_epsilon||_r^2
                            = (64 pi/3675) epsilon^4.             (2.3)

Here are the exact reductions used by the certificate. Set `t=z/r`,
`h=r^2`, `p=1-t^2`. Azimuthal integration contributes `2pi` and the radial
substitution contributes `1/2`:

    ||Delta S||_r^2/pi
      = 9 integral_0^1 t^2 p dt
          integral_0^infinity h^3(7+2h)^2/(1+h)^7 dh
      = 29/10,

    ||S cross curl S||_r^2/pi
      = integral_0^infinity h^4/(1+h)^8
          integral_0^1 t^2 p[1+3t^2+(2h+h^2)(1-3t^2)^2]dt dh
      = 64/3675.

For each term `h^n/(1+h)^m`, the change `u=h/(1+h)` converts the infinite
integral into the exact polynomial integral
`integral_0^1 u^n(1-u)^(m-n-2)du`. All appearing exponents are nonnegative.
Thus no tail truncation or numerical quadrature is used.

Consequently

    ||U_epsilon cross curl U_epsilon||_r / ||Delta U_epsilon||_r
      = epsilon sqrt(128/21315).                                (2.4)

For every `nu>0` and `0<epsilon<=nu/200`, this is **strictly below**
`nu/2500`. With `b=epsilon/nu`, the exact squared comparison is

    21315-800000000 b^2 >= 1315 > 0,  0<=b<=1/200.                (2.5)

The Jacobian adapter certifies the entire interval in (2.5), not selected
amplitudes.

### Strong L3 fails, including the local-in-space endpoint after rescaling

Uniformly in angle,

    r U_epsilon(r omega)
      -> epsilon omega_3(-omega_2,omega_1,0).                     (2.6)

The limit is nonzero on a set of positive hemispherical measure.
More precisely,

    integral_(B_R^+) |U_epsilon|^3
      = (4pi epsilon^3/35) [atanh(w)-w-w^3/3-w^5/5-w^7/7],
    w=R/sqrt(1+R^2).                                             (2.7)

The angular factor follows from
`integral_0^1 t^3(1-t^2)^(3/2)dt=2/35`; substitute
`v=sqrt(1-t^2)` to obtain `integral_0^1(v^4-v^6)dv`.
The radial substitution `w=r/sqrt(1+r^2)` leaves
`integral w^8/(1-w^2)dw`, whose derivative is certified exactly.
Since `atanh(w)=asinh(R)=log(R+sqrt(1+R^2))`,

    integral_(B_R^+) |U_epsilon|^3
      = (4pi epsilon^3/35) log R + O(1) -> infinity.              (2.8)

Thus `U_epsilon` is not in strong `L^3` for **any** positive amplitude.
It is in weak `L^3`, since `|U_epsilon|<=epsilon/(2r)` for `r>0`.
Applying (1.1) to the kinematic similarity rescaling shows that its local
strong spatial L3 norm is not uniformly bounded as `t` approaches zero:
the cubed norm grows as
`(4pi epsilon^3/35)log(R/sqrt(2a(-t)))+O(1)`.
Merely replacing global L3 by Seregin's local mixed norm does not remove
the distinction.

## 3. Arbitrary tails and arbitrarily large weak-L3 norm

The preceding family already meets the Reviewer-requested non-L3 separation.
The following strengthening ensures that the comparison is not just
small-data exclusion in a different notation.

For `k>0` put

    phi(y)=z^2 exp(-r^2),
    B_k(y)=(cos(kz),sin(kz),0),  J B_k=(-sin(kz),cos(kz),0),
    C_k=-curl(phi B_k),
    U_(k,epsilon)=C_k+epsilon S.                                 (3.1)

Both `phi` and `grad phi` vanish on the wall. Thus `C_k` is smooth,
solenoidal and zero-trace. All its derivatives decay faster than any power,
for each fixed `k`. The sum satisfies H1, with constants allowed to depend
on `k,epsilon`, exactly as H1 permits.

For every `epsilon,nu>0`, it suffices to take

    k >= 100 + 32epsilon + 120000(1+epsilon)/nu.                   (3.2)

Then the sum satisfies

    ||U_(k,epsilon) cross curl U_(k,epsilon)||_r
      <= (nu/2500)||Delta U_(k,epsilon)||_r,                      (3.3)

is outside strong L3, and has weak-L3 quasi-norm at least

    k/(24 times 16^(1/3)).                                       (3.4)

There is no upper bound on the positive tail amplitude `epsilon` in this
statement, and `k` may be arbitrarily large.

### Exact differential identities and global constants

The following formulas hold for every smooth scalar envelope `phi`, not only
the chosen Gaussian:

    C_k = k phi B_k - grad phi cross B_k,
    curl C_k + k C_k
      = B_k Delta phi - (Hess phi) B_k + k phi_z J B_k =: Q_k,

    Delta C_k =
      -k^3 phi B_k
      + k^2(2 phi_z J B_k + grad phi cross B_k)
      + k(B_k Delta phi - 2 partial_z grad phi cross J B_k)
      - grad Delta phi cross B_k.                               (3.5)

The symbolic certificate differentiates the defining curl and checks (3.5)
identically, with an arbitrary scalar function and arbitrary `k>0`.

For our Gaussian the exact squared weighted norms, divided by `pi`, are

| Quantity | Squared norm divided by pi |
|---|---:|
| `phi` | `3/40` |
| `grad phi` | `1/3` |
| `phi_z` | `17/105` |
| `Hess phi` (Frobenius norm) | `77/30` |
| `Delta phi` | `67/30` |
| `grad Delta phi` | `124/5` |

These are whole-half-space integrals. Each derivative is a polynomial times
`exp(-r^2)`. For a monomial `x_1^(2i)x_2^(2j)z^(2l)exp(-2r^2)`,
its weighted integral divided by `pi` is exactly

    (2i-1)!! (2j-1)!! (2l-1)!! (i+j+l+1)!
    -----------------------------------------------------------,
          (2(i+j+l)+1)!! 2^(i+j+l+2)

with `(-1)!!=1`. This follows from spherical integration and elementary
Gaussian moments, and is the formula used by the certificate.

We only need the loose consequences

    sqrt(pi)/4 <= ||phi||_r <= sqrt(pi),
    ||grad phi||_r, ||phi_z||_r <= sqrt(pi),
    ||Hess phi||_r, ||Delta phi||_r <= 10sqrt(pi),
    ||grad Delta phi||_r <= 100sqrt(pi).                          (3.6)

Also `||phi||_infinity<=1` and `||grad phi||_infinity<=5`.
Indeed `s^j exp(-s)<=j!` follows from the positive exponential series, and
`2r+2r^3 <= 1+2s+s^2`, where `s=r^2`.
Finally `||S||_infinity<=1`, `||curl S||_infinity<=4`.
The latter two inequalities are certified by clearing the positive
denominators in (2.1)--(2.2): the resulting polynomials in
`rho^2,z^2` have nonnegative coefficients on the entire nonnegative quadrant.

### Bounds including all interaction terms

Equations (3.5)--(3.6) give

    ||Delta C_k+k^3 phi B_k||_r
      <= sqrt(pi)(3k^2+30k+100).

For all `k>=100`, the right side is at most `sqrt(pi)k^3/8`.
Since `|B_k|=1`, it follows that
`||Delta C_k||_r>=sqrt(pi)k^3/8`.
From (2.3), `||Delta(epsilon S)||_r<2epsilon sqrt(pi)`.
As (3.2) implies `k^3>=k>=32epsilon`,

    ||Delta U_(k,epsilon)||_r >= sqrt(pi)k^3/16 > 0.              (3.7)

The leading Beltrami term cancels in
`C_k cross curl C_k=C_k cross Q_k`. Thus

    ||C_k cross curl C_k||_r
      <= sqrt(pi)(k+5)(k+20) <= 2sqrt(pi)k^2,
    ||C_k||_r <= sqrt(pi)(k+1),
    ||curl C_k||_r <= sqrt(pi)(k^2+2k+20).

We do not omit the interactions with the noncompact tail. The triangle
inequality and the global sup bounds give, together,

    epsilon ||S cross curl C_k + C_k cross curl S||_r
      <= epsilon sqrt(pi)(k^2+6k+24)
      <= 2epsilon sqrt(pi)k^2.

The pure tail contributes at most `epsilon^2 sqrt(pi)` by (2.3).
Since (3.2) implies `epsilon<=k`,

    ||U_(k,epsilon) cross curl U_(k,epsilon)||_r
      <= 3sqrt(pi)(1+epsilon)k^2.                               (3.8)

Dividing (3.8) by (3.7) gives the bound `48(1+epsilon)/k`,
which is at most `nu/2500` under (3.2).
Every polynomial inequality asserted for `k>=100` is checked by substituting
`k=100+v` and checking nonnegative rational coefficients for all `v>=0`;
no finite frequency search is used.

### Critical tail and large norm occur in the same fields

For fixed `k`, `C_k` belongs to strong L3 and decays exponentially.
If `C_k+epsilon S` were in strong L3, subtracting `C_k` would contradict
(2.8). In fact it has the same tail (2.6) and logarithmic coefficient (2.8):
the difference of the two cubed magnitudes is integrable, by

    ||A+B|^3-|A|^3|
      <= 3|A|^2|B| + 3|A||B|^2 + |B|^3

with `A=epsilon S`, `B=C_k`.
It remains in weak L3 by the pointwise `O(1/r)` bound.

For the quantitative lower norm bound, use the box

    E={|x_1|<=1/4, |x_2|<=1/4, 1/2<=z<=3/4},
    |E|=1/16.

There `r^2<=11/16<1` and `phi>1/12`, since `exp(1)<3`.
The latter elementary bound follows, for example, by majorizing the positive
exponential series with a geometric series, strictly after the second term.
The exact identity `C_k dot B_k=k phi` and `|S|<=1` give

    |U_(k,epsilon)| >= U_(k,epsilon) dot B_k
      > k/12-epsilon >= k/12-k/32 > k/24   on E.

This proves (3.4) for the convention
`||U||_(3,infinity)=sup_(lambda>0) lambda |{|U|>lambda}|^(1/3)`.
It also gives `sup r|U|>=k/48`.
Consequently the same non-L3 fields are outside every fixed small weak-L3
or small `sup r|U|` class as `k` increases.

## 4. Pressure admissibility and the exact scope of the gain

For either family, `Delta U` and `(U dot grad)U` belong to unweighted and
`r`-weighted L2. Therefore one may define the canonical pressure gradient by

    grad P=(I-Pi_H)[nu Delta U-(U dot grad)U].                    (4.1)

The unweighted Helmholtz decomposition supplies a gradient uniquely, and
its scalar potential is fixed up to an additive constant. This is exactly
H2; no arbitrary harmonic or affine addition is used. It is a pressure
**definition for comparison**, not a claim that the remaining solenoidal
part of the Leray equation vanishes.

For the simple tail there is even a direct check that it is not a backward
profile. Its wall shear has zero tangential divergence, so its canonical
Stokes pressure gradient vanishes. The nonlinear canonical pressure is
axisymmetric, hence has no azimuthal component. The nonlinear velocity term
in (2.2) also has no azimuthal component. The azimuthal part of the linear
profile residual is

    3epsilon z rho [nu(7+2r^2)+a(1+r^2)]/(1+r^2)^(7/2),

which is strictly positive wherever `z,rho>0` for `nu,a,epsilon>0`.
For the core-plus-tail family no equation-solving assertion is made either;
the independently supported alignment exclusion would preclude it.

The comparison now addresses the previous defect: compactly supported
Beltrami cutoffs alone were in the already-covered strong-L3 class, regardless
of their norm. In contrast, (2.1) and (3.1) fail that class exactly, including
the local-in-space mixed endpoint under similarity rescaling, while satisfying
the new kinematic and alignment hypotheses. The large-core version also
rules out explaining this separation solely by a small critical norm.

This establishes the requested mathematical separation from the inspected
Seregin/Bradshaw--Tsai statements. It does not show that the full new theorem
is a logical strengthening of every earlier result, that any nonzero profile
exists, or that all later literature has been exhausted. Independent novelty
and publishable-significance certification remain the Host-invoked
Reviewer's responsibility.

## 5. Exact replay and evidence limits

    /home/argustest/zimo/argus-live-update/.venv/bin/python research/certify_critical_tail.py

The output `critical-tail-certificate.json` records exact Cartesian
identities, rational full-domain integrals, Gaussian moments, and uniform
polynomial inequalities. The proof of the analytic decay, positive logarithmic
divergence, comparison of hypotheses, and pressure interpretation is the
prose above; it is not mislabeled as formal-kernel evidence.

Jacobian discovery selected `polynomial.box.enclosure.compute`, whose exact
typed contract was inspected before the custom certificate was written.
Files `jacobian/critical-tail-contract.json`,
`jacobian/critical-tail-gap-payload.json`, and
`jacobian/critical-tail-gap-output.json` retain the contract, exact payload,
and typed result. Server `0.14.0`, protocol `2025-11-25`, returned
`[1315,21315]` for the whole interval in (2.5), with adapter exit zero and no
timeout or structured error. This validates precisely that polynomial
margin, not a Navier--Stokes solution.

No unchanged pressure, drift, or axisymmetric-band certificate was rerun for
this comparison-only revision.
