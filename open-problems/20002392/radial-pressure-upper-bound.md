# Strict radial domination of canonical Stokes pressure

## Statement and status

The analytic proof and its exact certificates were accepted in the preceding
independent review. This exposition now submits the original contribution for
separate Host-invoked novelty and significance review. It is not a
formal-kernel proof or an independently certified publication.

**Theorem.** If `H={x_3>0}` and `V` is a real smooth compactly supported field
on `closure H`, with `div V=0` and zero wall trace, then

    integral_H |x| |grad p_S[V]|^2
      <= (999/1000) integral_H |x| |Delta V|^2,                     (1)

where `grad p_S[V]=(I-Pi_H)Delta V` and `Pi_H` is the unweighted Helmholtz
projection. The constant is explicit, not asserted optimal.

Together with `radial-pressure-obstruction.md`, this gives

    13/25 < beta_star <= 999/1000 < 1.

The proof below controls every angular mode and every real Mellin frequency.
Only one bounded parameter interval uses computation. That computation uses
rational interval arithmetic and an analytic, uniform infinite-series tail,
not a grid or a truncated spectral assertion.

The proposed original result is **strict, remainder-free domination in the
prescribed three-dimensional radial norm**, on the full stated solenoidal
no-slip class. It is not an improvement of the unweighted coefficient, an
optimal weighted constant, or the invention of Mellin analysis. Section 7
compares the actual closest pressure theorems and identifies the additional
constraint that makes this result possible. The backward-profile application
is a separate corollary in `critical-alignment-exclusion.md`.

## 1. Mellin reduction and the no-slip moment

Put `s=log r`, `omega=x/r`, and take the unitary Fourier transform in `s`.
Resolve rotations about the normal axis into azimuthal modes `m`. In spherical
vector components a mode has the factor `exp(i m phi)`; it is not the same
as giving all Cartesian components that scalar factor. It suffices to write
`m>=0`, with the estimates below depending on `|k|` for the real Mellin
frequency `k`.

For a transformed velocity `v(omega)`, set

    D = (Delta_S - k^2 + i k)v,

where `Delta_S` acts on Cartesian components. The Fourier transform of
`r^2 Delta V` is `D`. Write `D=f omega + D_T`. Solenoidality gives

    i k f + div_S D_T = 0.                                        (2)

Write the pressure as `p_S=r^(-1) P(s,omega)`. In a fibre its regular angular
factor solves

    (Delta_S - k^2 - i k)P=0.

Use `t=omega_3`, `p=1-t^2`, and suppress the common azimuthal integration
factor. Let `q(t) exp(i m phi)` be the regular solution normalized by `q(0)=1`:

    (p q')' - m^2 q/p = (k^2+i k)q.                               (3)

Set

    d=q'(0),  B=integral_0^1 |q|^2,  R=-Re d,  kappa=sqrt(m^2+k^2).

Except at the single fibre `(m,k)=(0,0)`, one has

    |d|^2=kappa^2,  -d=R+i k B,
    R=integral_0^1 [p|q'|^2 + m^2|q|^2/p + k^2|q|^2].             (4)

Section 2 proves the first identity without importing a special-function
inequality. The other identities are integration by parts in (3).

Let `g=D_3|_(t=0)`. The canonical Neumann condition is
`P'(0)=g`, so `P=(g/d)q`. Its angular pressure energy is exactly

    E_P = |g|^2 (R+B)/kappa^2.                                    (5)

This includes both the radial and tangential pressure derivatives.

There is a second, essential boundary condition. The scalar component `v_3`
has both `v_3(0)=0` and `v_3'(0)=0`: the latter is the divergence equation at
the zero-trace wall. Since
`D_3=(Delta_S-k^2+i k)v_3`, Green's identity with the adjoint solution `q`
gives

    integral_0^1 conjugate(q) D_3 = 0.                            (6)

Dropping (6) would give a different, weaker problem. This proof retains it.

For compact smooth `V`, all these transforms are legitimate in `L^2(ds)`.
Near the boundary origin `V=O(r)`; at infinity it vanishes. The canonical
pressure is smooth near the origin and has `p_S=O(r^(-2))` at infinity,
by its boundary-layer formula. Thus `P=r p_S` and the derivatives used here
are square integrable on the cylinder. Equatorial traces may first be taken
for smooth Fourier truncations and then passed in their Sobolev trace norms.
The single exceptional frequency has measure zero and introduces no
additional `L^2` Mellin mode.

## 2. Exact Dirichlet-to-Neumann modulus

For a complex degree `nu`, let `Q_nu` be the pole-regular solution of

    (p Q_nu')' + [nu(nu+1)-m^2/p]Q_nu=0,

normalized so that `Q_nu / ((1-t)/(1+t))^(m/2) -> 1` at `t=1`.
For `m=0` this says `Q_nu(1)=1`. Existence, uniqueness and regularity follow
from the regular Frobenius solution at the pole; they also follow directly
from the convergent hypergeometric series in `(1-t)/2`.

The raising identity is

    p Q_nu' = (nu+1)t Q_nu - (nu+m+1) Q_(nu+1).                   (7)

For completeness, differentiate the right-hand construction
`[(nu+1)t Q_nu-p Q_nu']/(nu+m+1)`. Substitution of the equation for `Q_nu`
shows that it solves the equation of degree `nu+1`. At the pole its leading
coefficient is one, since `p Q_nu'/Q_nu -> -m`. This proves (7) by uniqueness.
The symbolic certificate checks the differential substitution for arbitrary
`nu,m,t`; the excluded divisor is `nu+m+1=0`.

Take `nu=-1+i k`. The equations and real pole normalizations show

    Q_(nu+1)=conjugate(Q_nu),

because `(nu+1)(nu+2)=conjugate(nu(nu+1))`.
At `t=0`, (7) therefore says, with `Z=Q_nu(0)`,

    d=-(m+i k) conjugate(Z)/Z.

Here `Z!=0`: a pole-regular solution with zero equatorial value would,
by the real part of its energy identity, be zero whenever `(m,k)!=(0,0)`.
This proves `|d|^2=m^2+k^2`. No gamma-function evaluation is a numerical input.

The special-value formulas in NIST DLMF 14.5.1--14.5.2 provide a source
cross-check, but are not an undischarged premise: (7) supplies the proof used.

## 3. A variational bound that retains the wall constraint

Let `q0` be the real positive regular solution

    (p q0')' - m^2 q0/p = k^2 q0,   q0(0)=1,

and put `delta=-q0'(0)>0`, `B0=integral q0^2`, `T0=integral t q0^2`.
The Dirichlet principle and (4) imply

    delta <= R <= kappa.                                         (8)

The modulus comparison for (3) gives `|q|<=q0`. One proof applies the
inequality for the modulus of a complex scalar solution to
`L_m+k^2`, where `L_m=-(p d/dt)' + m^2/p`, and then the maximum principle.
At zeros use a regularized modulus and pass to the limit. Pole regularity
removes the artificial coordinate endpoint. Consequently

    B<=B0.

Define `A_D(f,D_T)=i k f+div_S D_T` and
`A_D^*phi=(-i k phi,-grad_S phi)`. The field

    D^(0)=A_D^*((g/delta)q0)

satisfies (2), has normal component `D_3^(0)(0)=g`, and has energy
`|g|^2/delta`. It is orthogonal to every field satisfying (2) with zero
normal boundary value, by integration by parts. Hence

    ||D||^2 = |g|^2/delta + ||D-D^(0)||^2.                         (9)

Let `E=(t q,q grad_S t)`, so `<E,D>=integral conjugate(q) D_3`.
For every field `h` satisfying (2), the vector `Z1=A_D^*(t q)` is
orthogonal to `h`: its scalar potential vanishes at the equator. Put
`A=integral t^2|q|^2`. Direct integration in (3) gives

    ||E||^2=B,  ||Z1||^2=B-A,
    Re <E,Z1>=-(B+A)/2.

For example,
`integral t^2|grad_S q|^2=B-(k^2+3)A`, which proves the middle formula.
Subtracting the component of `E` along `Z1` yields the useful estimate

    |<E,h>|^2 <= (3B/4)||h||^2.                                  (10)

Indeed
`B-(B+A)^2/[4(B-A)] <= 3B/4`. The denominator `B-A` is positive.

Use (6), (9), and (10), with `h=D-D^(0)`. If `M=<E,D^(0)>`, then

    ||D||^2 >= |g|^2/delta + 4|M|^2/(3B).                         (11)

There is an exact formula for this moment:

    M = (g/(2delta)) [1-(2+i k)J],
    J = integral_0^1 t conjugate(q) q0.                           (12)

To check it, integrate the normal component
`D_3^(0)=-(g/delta)(i k t q0+p q0')` once. The second needed identity is
Green's formula for `t conjugate(q)` against `q0`:

    (2+i k)J - 2 integral_0^1 p conjugate(q')q0 = 1.

Since `|J|<=T0`, whenever `Q=1-sqrt(4+k^2)T0` is positive, (5), (8),
and (11) give

    E_P/||D||^2
      <= (kappa+B0) / [kappa + Q^2/(3B0)].                       (13)

The case `g=0` has zero pressure and needs no division by `g`.

## 4. All non-axisymmetric modes and all high frequencies

For `m>=1`, comparison with
`q_m=((1-t)/(1+t))^(m/2)` gives `q0<=q_m`. In particular

    m=1: B0 <= 2log(2)-1 < 387/1000,
         T0 <= 3/2-2log(2) < 57/500;                             (14)
    m>=2: B0 <= 1/(2m),  T0 <= 1/(4m^2).                        (15)

The second line uses `q_m<=exp(-m t)` and extends positive integrals to
`[0,infinity)`. The log bounds in (14) are proved by rational bounds for the
positive `2 atanh(1/3)` series in the certificate.

For `m=1, |k|<=2`, use `kappa<=9/4` and
`sqrt(4+k^2)<=2sqrt(2)<99/35`. Define the rational number

    C1 = [1-(99/35)(57/500)]^2 / [3(387/1000)].

It exceeds `387/1000`. Formula (13) therefore gives

    E_P/||D||^2
      <= (9/4+387/1000)/(9/4+C1)
       = 3750407325/3762360046 < 999/1000.                        (16)

For `m>=2, |k|<=2`, use `kappa<=3m/2`,
`B0<=m/8`, `sqrt(4+k^2)<=3`, and
`Q>=13/16`. The term `Q^2/(3B0)` is at least `169m/384`.
Consequently (13) gives

    E_P/||D||^2 <= 624/745 < 999/1000.                            (17)

For `|k|>=2`, this time including `m=0`, put
`a=sqrt(kappa^2-1)`. The barrier `w=exp(-a t)` satisfies

    (L_m+k^2)w/w = (a t-1)^2 + m^2 t^2/(1-t^2) >= 0.

Thus `q0<=w`. For `m>0` comparison at the pole follows from `q0(1)=0`;
for `m=0` the pole is a smooth interior point on the hemisphere.
Since `a>=4kappa/5`, this gives

    B0 <= 5/(8kappa),  T0 <= 25/(64kappa^2),
    sqrt(4+k^2) <= 3kappa/2,  Q >= 181/256.

Formula (13) now yields

    E_P/||D||^2 <= 142080/155641 < 999/1000.                       (18)

These are analytic bounds for unbounded mode and frequency ranges, not
truncation assumptions.

## 5. The complete remaining axisymmetric band

It remains to consider `m=0`, `0<k<=2`; negative `k` follows by conjugation.
Write the meridional tangential component of `D` as `a_theta` and put
`h=sqrt(1-t^2)a_theta`. Equation (2) says `h'=i k f`.
Pole regularity gives `h(1)=0`, so

    h(t)=-i k integral_t^1 f(u)du,
    g=i k integral_0^1 f,
    D_3=t f+i k integral_t^1 f(u)du.

The swirl component only increases `||D||^2`. The no-slip moment (6) becomes

    integral_0^1 F_k(t)f(t)dt=0,
    F_k(t)=t conjugate(q(t))+i k integral_0^t conjugate(q(u))du.

Projection of the constant function onto the orthogonal complement of
`conjugate(F_k)` gives

    |integral f|^2 <= theta ||f||^2,
    theta=1-|integral F_k|^2/integral |F_k|^2.

Using `||D||^2>=||f||^2`, (4), and (5), it is enough to bound

    (R+B)theta <= 1/2.                                           (19)

Here is the complete, reproducible certificate for (19). Use the unnormalized
pole-regular series

    Q(t)=sum_(n>=0) a_n ((1-t)/2)^n,
    a_0=1,
    a_n=a_(n-1)[n(n-1)+k^2+i k]/n^2.

Termwise substitution proves (3). The series and its derivatives converge
uniformly for `0<=t<=1, 0<=k<=2`.
For `n>=1` one has `|a_n|<=16`: start with `|a_1|<=sqrt(20)<5`;
the next four triangle bounds are `10,40/3,15,78/5`, and for `n>=6` the
recurrence's modulus bound `(n(n-1)+6)/n^2` is at most one.

For the truncation at `N=24`, write

    d_tail=16/2^N=1/1048576,
    e_tail=16(N+2)/2^N=13/524288.

Then `|Q-Q_N|<=d_tail` and `|Q'-Q_N'|<=e_tail` uniformly on the full
rectangle. Also `|Q_N|<=17`, `|Q_N'|<=32`.
No sign assumption on the complex coefficients is used.

Define, using `Q` instead of `q`,

    X=integral |Q|^2,  Y=integral (1-t^2)|Q'|^2,  Z=|Q(0)|^2,
    F=t conjugate(Q)+i k integral_0^t conjugate(Q),
    T=integral |F|^2,  A_F=integral F.

Normalization cancels in `theta`, and

    (R+B)theta = [Y+(1+k^2)X](T-|A_F|^2)/(Z T).                  (20)

For the truncated quantities, the rigorous absolute error bounds are

    error_X = error_Z = 34 d_tail + d_tail^2,
    error_Y = 64 e_tail + e_tail^2,
    error_T = error_|A_F|^2 = 306 d_tail + 9 d_tail^2.             (21)

Indeed `|F-F_N|<=3d_tail`, `|F_N|<=51`, and these estimates follow by
expanding differences of squared moduli.

`certify_axisymmetric_pressure.py` encloses every coefficient by exact complex
rational rectangles for a closed `k` interval. It integrates the polynomial
in `u=1-t` exactly, encloses (20) with (21), and bisects any interval not yet
certified. The initial interval is the complete `[0,2]`. Only strictly
positive lower bounds for `Z,T` permit division. The run is a failure, not
a certificate, if any leaf remains uncertified at the stated depth bound.

The completed run used **345 covering intervals**, maximum depth **9**,
and bounded every leaf strictly below `1/2`. The largest leaf bound rounded
up was `6249/12500 < 1/2`. The exact output is
`axisymmetric-pressure-certificate.json`; the durable run exited zero.
This proves (19), including the continuous limiting expression at `k=0`.
The exceptional Neumann fibre itself is not assigned an artificial pressure.

## 6. Reassembly, extension, and scope

Equations (16)--(19) cover every azimuthal mode and almost every real
Mellin frequency. Plancherel and the orthogonal azimuthal decomposition
give (1) with coefficient `999/1000`.

The estimate also extends to smooth zero-trace solenoidal `U` with

    |grad^j U(x)| <= C_j (1+|x|)^(-1-j),  j=0,1,2.                (22)

Here is a divergence-preserving approximation, including the wall. Define

    A_U(x)=-x cross integral_0^1 t U(t x)dt.

Differentiation gives `curl A_U=U`, because
`2F+(x dot grad)F=[t^2 U(tx)]_0^1` for `F=integral_0^1 tU(tx)dt`.
On the wall `A_U=0`. At infinity `A_U=O(1)`,
`grad A_U=O(r^(-1))`, `grad^2 A_U=O(r^(-2))`; these follow directly
by splitting the defining integrals at `t=1/r` and using (22).
Near zero `A_U=O(r^2)`.

Let `chi_R` be a smooth radial cutoff equal to one for `r<=R` and zero for
`r>=2R`, with its usual derivative bounds, and set
`U_R=curl(chi_R A_U)`. These fields are smooth, solenoidal and zero-trace.
All the cutoff terms in `Delta U_R-Delta U` are `O(R^(-3))` on the annulus;
outside it use (22). Hence

    ||r^(1/2)(Delta U_R-Delta U)||_2 = O(R^(-1)) -> 0.

The unweighted Laplacians also converge in `L^2`. The projected pressure
gradients consequently converge in unweighted `L^2`. Applying (1) to
differences of the compact fields makes those gradients Cauchy in weighted
`L^2`; the two limits agree locally. Thus the limit is precisely the
canonical `(I-Pi_H)Delta U`, and (1) passes to `U`.

The proof introduces no arbitrary harmonic pressure. The nonlinear profile
consequence and its remaining independent-review/novelty requirements are
stated separately in `critical-alignment-exclusion.md`.

## 7. Original contribution relative to the closest pressure theorems

### 7.1. Same pressure, different assertions

Write `||F||_r^2=integral_H r|F|^2` and `A V=-Pi_H Delta V`. On our
solenoidal class, the Laplace--Leray commutator is precisely
`[Delta,Pi_H]V=(I-Pi_H)Delta V=grad p_S[V]`. For a field that is not
solenoidal, the commutator instead equals
`(I-Pi_H)(Delta V-grad div V)`. These definitions must not be interchanged
when comparing the unrestricted and solenoidal classes.

The following are primary-source statements, not deductions from titles.
The first two were already independently checked; the later two were read
in the exact versions linked below and are newly recorded source assumptions.

| Result | Dimension, domain, and boundary | Fields and pressure | Norm and conclusion |
|---|---|---|---|
| Liu--Liu--Pego, Theorem A.1 | `N>=2`, half-space, zero trace | All `H^2 intersect H^1_0` fields; unweighted Leray commutator | Unweighted squared pressure coefficient `1/2`, no remainder |
| Cozzi--Pego, Theorem 1.4 | Two-dimensional infinite cone, no slip; half-plane included | Smooth compact fields away from the vertex, no divergence constraint; same commutator | Exact optimal coefficient for `r^(2alpha)`, `alpha!=1`; at half-plane weight `r`, this coefficient exceeds `15/8` |
| Alhomsi--Wu--Zheng, Theorem A.1 | `N>=2`, bounded connected `C^3` domain, zero trace | All `H^2 intersect H^1_0` fields; same commutator | Unweighted coefficient `1/2+epsilon` plus `C_S(epsilon)||grad V||_2^2`; explicit admissible remainder constant |
| Iyer--Pego--Zarnescu, Proposition 2.2 | `C^3` domains in the paper's bounded-domain setting, zero trace | Extended Stokes operator, without a divergence constraint | Coercivity in a constructed `H^1`-equivalent inner product, not the fixed norm `L^2(r dx)` |
| Theorem (1) here | Three-dimensional half-space, no slip | Solenoidal fields; canonical **unweighted** Helmholtz pressure | Squared pressure coefficient `999/1000<1` in `L^2(r dx)`, no remainder; extension (22) |

Precise sources:

- Liu--Liu--Pego, *Stability and convergence of efficient Navier--Stokes
  solvers via a commutator estimate*, CPAM 60 (2007), Theorem A.1,
  pp.1478--1479, and (1.17), p.1447,
  [doi:10.1002/cpa.20178](https://doi.org/10.1002/cpa.20178).
  Its unrestricted sharpness example is not solenoidal.
- Cozzi--Pego, *On optimal estimates for the Laplace--Leray commutator in
  planar domains with corners*,
  [arXiv:0912.3958v2](https://arxiv.org/pdf/0912.3958v2), Theorem 1.4,
  p.3, (1.8)--(1.9); zero trace in (3.1), p.7. The published version is
  Proc. AMS 139 (2011), 1691--1706,
  [doi:10.1090/S0002-9939-2010-10613-5](https://doi.org/10.1090/S0002-9939-2010-10613-5).
- Alhomsi--Wu--Zheng, *Viscosity in error upper bound for a consistent
  splitting scheme of the Navier--Stokes equations*,
  [arXiv:2606.28800v1](https://arxiv.org/pdf/2606.28800v1), Appendix A,
  Theorem A.1, p.27, (160)--(161); the remainder constant is on p.32.
  The comparison uses this June 2026 preprint, not the later journal issue.
- Iyer--Pego--Zarnescu, *Coercivity and stability results for an extended
  Navier--Stokes system*,
  [arXiv:1202.5671v1](https://arxiv.org/pdf/1202.5671v1), Proposition 2.2,
  p.5, and its pressure input Theorem 3.1, p.11.

These are not merely domain-label distinctions. The LLP and AWZ dimensions
include three, their pressure agrees with ours on solenoidal fields, and
their larger velocity classes can be restricted to ours. What their
statements do not supply is the prescribed weight with a strict coefficient
and no remainder. In particular, setting `epsilon=499/1000` in AWZ does
not prove (1): the lower-order term remains. For `V_R(x)=V(x/R)`, the ratio
of squared gradient to squared Laplacian norms scales as `R^2`, both with
and without the radial weight. It cannot be absorbed uniformly on the
scale-free half-space by this estimate.

Multiplying a velocity by `r^(1/2)` does not transport the unweighted theorem:
away from zero,

    div(r^(1/2)V) = (x dot V)/(2r^(3/2)),
    Delta(r^(1/2)V)
      = r^(1/2)Delta V + r^(-3/2)(x dot grad)V
        + (3/4)r^(-3/2)V.

The pressure projection also fails to commute with that multiplication.
The accepted lower bound `beta_star>13/25>1/2` is a direct obstruction to
transporting the old coefficient unchanged, even within the solenoidal class.

For comparison, IPZ use

    (u,v)_epsilon = (u,v)_2 + epsilon(grad u,grad v)_2
                   + C_epsilon(Q(u),Q(v))_2,
    grad Q(u)=(I-Pi)u,

and prove coercivity of the extended Stokes operator in this inner product.
Even on solenoidal fields, where `Q(u)=0`, this is an unweighted Sobolev
inner product, not multiplication by `r`. Their displayed Proposition 2.2
says `C^3` domain; the bounded-domain setting and bounded-domain pressure
input must not be silently promoted to a uniform half-space result. More
fundamentally, changing to an equivalent inner product does not preserve a
specified pressure-to-Laplacian constant in our fixed norm.

### 7.2. The planar weighted result does not give strict domination here

The weight alone is not new: `alpha=1/2` in Cozzi--Pego is exactly `r`.
There is a stronger distinction than dimension. Specialize their (1.9) to
`sigma=pi`, `alpha=1/2`, and put `E=exp(-pi k)`, `k>0`. Its two symbols become

    beta_hat_(+,k) or beta_hat_(-,k)
      = ((k^2+1/4)/k^2)
        (1-E^2)[(1-E^2)/2 +/- 2kE]/(1+E^2)^2.

Indeed the three complex exponentials in (1.9) reduce respectively to
`-iE`, `iE`, and `-E^2`. Taking the real part gives the displayed rational
expression, and taking `k -> 0+` gives

    beta_hat_(+,0) = pi(pi+2)/8,
    beta_hat_(-,0) = pi(pi-2)/8.

Since their optimal coefficient is the supremum of the two symbols,

    beta_(pi,1/2) >= pi(pi+2)/8 > 15/8 > 1.                      (23)

For an elementary strict bound, `sin(pi/6)=1/2<pi/6` gives `pi>3`.
Also `pi/4=integral_0^1 (1+x^2)^(-1)dx<1`. Thus `3<pi<4`, and the
polynomial `p^2+2p-8`, equal to eight times the plus-limit minus one,
is positive throughout `[3,4]`.

The two symbol identities and their exact limits are checked by
`certify_planar_comparison.py`. The retained Jacobian operation
`polynomial.box.enclosure.compute` independently returns `[7,16]` for
`p^2+2p-8` on `[3,4]`; its exact payload, typed output, server version,
protocol, and inspected contract are in `jacobian/planar-weight-*.json`.
The adapter exited zero without an error or timeout.

This is a **specialization of a known theorem**, not an original result.
It concerns the unrestricted planar no-slip commutator class. It says
nothing by itself about the planar solenoidal optimum or a
three-dimensional counterexample. Conversely, taking a product of the
half-plane with a line does not lift its pressure operator or weight:
`sqrt(x_1^2+x_3^2)` is not `sqrt(x_1^2+x_2^2+x_3^2)`, and transverse
dependence changes the harmonic-pressure equation. Thus neither the known
planar coefficient nor its failure of contraction settles (1).

### 7.3. The mechanism and the field-level consequence

The specific additional mechanism is the **normal-component moment forced
by no slip and incompressibility**, equation (6), and its quantitative use
in the three-dimensional hemisphere problem. The minimally energetic
solenoidal fibre with a fixed pressure-generating normal trace need not
belong to the Laplacian range of a no-slip solenoidal velocity. The missing
condition is `integral conjugate(q) D_3=0`. Retaining it changes the
variational denominator from `|g|^2/delta` to at least

    |g|^2/delta + 4|M|^2/(3B).

This is the gain in (11); the separate axisymmetric argument retains the
same moment instead of assuming it away. The exact Dirichlet-to-Neumann
modulus and all-mode estimates turn that constraint into a uniform strict
gap. The familiar Legendre identities, Mellin transform, and interval
arithmetic are tools used in this argument, not claimed inventions.

In particular (1) proves the prescribed-form coercivity

    <A V,-Delta V>_r
      >= (1-sqrt(999/1000)) ||Delta V||_r^2 > 0                 (24)

for every nonzero admissible `V`. This follows directly by
Cauchy--Schwarz, not by changing the inner product. General weighted
projection boundedness is not a substitute: the squared projection bound
used in the companion proof is `3/2`, which alone does not give a pressure
coefficient below one. Nor is (24) a claim of the first weighted Stokes
regularity estimate; boundedness or invertibility with an unspecified
constant is a different assertion from the strict relative pressure bound.

The significance of crossing one, rather than optimizing `999/1000`, is
that it supplies a positive viscous term in the critical weighted test of
the backward Leray equation. The logarithmic-shell drift identity then
closes a no-slip boundary exclusion under an explicit Lamb-vector depletion
condition while retaining a possibly nonzero `1/r` tail. This is the
quantitative application in the companion theorem. The two-sided result
`13/25<beta_star<=999/1000<1` is therefore the principal original-result
submission; the alignment exclusion is its Navier--Stokes consequence,
not a claim that the general idea of geometric depletion is new.

This comparison establishes the exact advances over the displayed primary
theorems. It is not an exhaustive theorem of bibliographic nonexistence.
Huang--Shen's Lemma 4, cited as an antecedent by AWZ, could not be obtained
by the source reader; no stronger claim about its contents is used. AWZ
expressly describes its own theorem as a refinement of the older unweighted
estimate. The independent Reviewer must decide whether the identified
mechanism, result, and application meet the original/publishable bar.

## Exact replay

    /home/argustest/zimo/argus-live-update/.venv/bin/python research/certify_pressure_constants.py
    /home/argustest/zimo/argus-live-update/.venv/bin/python research/certify_axisymmetric_pressure.py

The first command checks the symbolic raising identity, the algebraic
projection identities, the infinite-range barrier polynomial, and the
rational constants. The second checks the whole remaining frequency band
with its infinite-series remainder. Neither command replaces independent
review of the analytic reduction, the traces, or Plancherel reassembly.

Those accepted proofs and certificates were not rerun for this
literature-comparison revision. The new comparison alone is replayed with

    /home/argustest/zimo/argus-live-update/.venv/bin/python research/certify_planar_comparison.py
    /home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run --operation polynomial.box.enclosure.compute --payload-file research/jacobian/planar-weight-payload.json

The comparison script also checks the radial-weight differentiation and
dilation exponents in section 7.1. It does not purport to decide novelty.
