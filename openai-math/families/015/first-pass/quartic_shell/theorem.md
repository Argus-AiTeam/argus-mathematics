# Sharp intrinsic conductor support for quadratic shell kernels

## Result and scope

We prove the literal `lem:fourier-shell-estimates` in the staged quartic
manuscript, including dyadic and ramified factors and unbounded order depth.
We also improve its conductor support, prove the improved odd-prime exponent
optimal, and reduce the exponent 24 in its global denominator-profile bound
to 3. No false assertion in the audited lemma is claimed. In particular,
these results do **not** verify the subsequent nonscalar Poisson estimates,
sieve, or any of the three global equidistribution theorems.

The uniform assertions below have mathematical proofs, not finite-search
proofs. `verify.py` supplies independent exact algebra and finite Fourier
replay, including wild examples and arbitrarily large parameters on request.
It is not a formal checker for the measure-theoretic proof. No Lean
formalization or kernel-checked status is claimed.

### Source and known status

All manuscript references are to
`research/openai_manuscript/Equidistribution-of-Primitive-Quartic-Torus-Packets-for-Arbitrary-Orders-October-5-2026/build/manuscript/`.
The hypotheses are `local-fourier.tex`, "Quadratic data and the trace
marginal"; the assertions audited are `lem:fourier-shell-estimates`,
equations `eq:fourier-shell-decay`, `eq:fourier-inverse-support`,
`eq:fourier-boundary-support`, and `eq:fourier-boundary-decay`.
The application hypotheses are identified in `exterior.tex`,
`lem:ext-quadratic-structure`. The global comparison is `additive.tex`,
`lem:add-profile-bounds`, equations `eq:add-profile-norm` and
`eq:add-profile-support`, and its displayed product
`prod p^(12(g_p+1)) <= 30^12 G_0^24`.

Quadratic Gaussian Fourier transformation and finite-field quadratic Gauss
sums are classical. We give their required proofs below instead of importing
the lemma under audit. The manuscript cites Weil, *Acta Math.* 111 (1964),
143-211, DOI `10.1007/BF02391012`; its DOI landing page was inaccessible
behind an anti-bot interstitial. That unread source is not an axiom here.

The primary source ELMV, *Ann. of Math.* 173 (2011), 815-885,
DOI `10.4007/annals.2011.173.2.5`, Proposition 9.9, pp. 853-854, was
retrieved in `literature/ELMV2011.pdf`. It estimates a multiplicative
local period integral of a Schwartz function with a unitary multiplicative
character. It is prior local harmonic analysis, not a quoted proof of this
rank-two quadratic inverse-shell support assertion. Neither the inherited
Wiki subject search nor a targeted literature search located the sharp
quotient-exponent theorem below. This limited negative retrieval does not
establish publication novelty. That question remains for independent review.
A search suggestion concerning Kedlaya's rigid-cohomological Weil II paper
was not used: its primary abstract concerns overconvergent isocrystals,
not the local lattice problem.

## 1. Precise statement

Let `E = product E_nu` be a cubic etale algebra over `Q_p`, with maximal
order `R`, different `d`, ramification degrees `e_nu`, and residue
cardinalities `q_nu`. Let `W` be free of rank two over `E`, with faithful
unital action `rho`. Let `B` be a nondegenerate symmetric `Q_p`-bilinear
form, self-adjoint for this action. Let `L` be a full self-dual `Z_p`
lattice for `B`, and require

    Q_1(x) = B(x,x)/2 in Z_p for every x in L.

The division is in `Q_p`; self-duality alone is not substituted for this
integrality hypothesis at 2. Define

    Q_A(x) = B(rho(A)x,x)/2,
    C = {a in E : rho(a)L subset L},
    C_sharp = Z_p + 2 C.

Fix a character `psi` of `Q_p` of conductor `Z_p`. Give `W` its
`B`-self-dual Haar measure, so `vol(L)=1`, and give `E` the self-dual
measure for `psi(Tr(Az))`. Thus `vol(R)=product q_nu^(-d_nu/2)`.
For an integral ideal `h = product q_nu^(h_nu)`, put

    S_h = product_(h_nu=0) R_nu
          times product_(h_nu>0) pi_nu^(-h_nu) R_nu^times,
    H = Norm(h),
    g = log_p [h : h intersect C],
    c = min {n >= 0 : p^n h subset C}.

In particular `0 <= c <= g`, and `c=0` if and only if `g=0`. The
integer `c` is the exponent, not the logarithm of the cardinality, of the
finite additive group `h/(h intersect C)`. Define

    gamma(A) = average_(u in Z_p^times) integral_L psi(u Q_A(x)) dx,
    K_h(z) = integral_(S_h) gamma(A) psi(-Tr(Az)) dA.

**Theorem A (uniform verification).** All assertions of the cited
intrinsic shell lemma hold with exactly these hypotheses and conventions.
In particular, for every allowed scalar shift `alpha=A+s` in that lemma,
with `beta=alpha^(-1)` and
`j=min{n>=0:p^n beta in C}`, one has

    |gamma(A)| <= p^(3 iota) H^(-1) p^(-j/2),
    ||K_h||_infinity <= p^(3 iota) vol(R),
    supp K_h subset (C_sharp)^vee,

where `iota=1` for `p<=5`, and zero otherwise. The coarse support
`p^(-4(g+1)) h d^(-1)` holds whenever `g>0` or `p<=5`.

**Theorem B (stronger intrinsic support).**

* At every odd prime, `||K_h||_infinity <= vol(R)`. If `c>0`, then

      supp K_h subset p^(-c) h d^(-1).                  (B1)

* If `c=0`, the componentwise boundary support and the bound

      |K_h(z)| <= 8 vol(R) product_(nu in boundary) q_nu^(-1/2)

  hold at **every odd prime**, including 3 and 5, with precisely the
  boundary definition in the manuscript.
* At 2, put `N_2=max(c+3,4)`. Then

      supp K_h subset 2^(-N_2) h d^(-1).               (B2)

  No optimality claim is made for this dyadic additive constant.

**Theorem C (unbounded sharpness).** For every prime `p`, every `k>=1`,
and every `c>=2`, put `m=k+c`. There are data satisfying even the
stronger split scalar-form hypothesis of the manuscript, with

    E=Q_p^3,  C={(a1,a2,a3) in Z_p^3 : a1-a2 in p^m Z_p},
    h=(p^k Z_p, p^k Z_p, Z_p),  g=c,

such that

    K_h(p^(k-c), -p^(k-c), epsilon)
      = (1-p^(-1))^2 p^(-c) > 0  (epsilon in Z_p).       (C1)

The evaluation point is outside `p^(-(c-1)) h`; taking `epsilon=1`
makes all its components nonzero. Thus the exponent in
(B1) cannot be lowered, even for split cubic algebras with split scalar
form. This family is not a counterexample to the manuscript.

## 2. Fourier and lattice facts, with proofs

For any full additive lattice `J` of `E`, a function with period `J`
has inverse transform supported on `J^perp`. Indeed translating the
integral by `t in J` multiplies its value at `z` by `psi(Tr(tz))`.
If this is not 1 for some `t`, that value is zero. For ideals the
annihilator is `J^(-1)d^(-1)`, by the defining trace-dual property of
the different. Fourier inversion here reduces to finite-group character
orthogonality after choosing a compact support and an open period lattice;
there is no improper pointwise inversion in this argument.

For `r in Z_p, a in C` and `x in L`,

    Q_(r+2a)(x) = r Q_1(x) + B(rho(a)x,x) in Z_p.

The stabilizer `C` is a full order: clearing denominators in the matrices
of an integral basis of `R` puts `p^n R` in `C` for some `n`, and an
element preserving `L` satisfies the monic integral characteristic
polynomial of its action. Faithfulness then implies that the element is
integral in `E`, hence lies in `R`. It is a unital ring by its definition.
In particular `c` exists, and `C_sharp` is an open additive lattice.

Thus `gamma` has period `C_sharp`. Every denominator shell has period `R`.
Its zero-extended restriction still has the open period `C_sharp` and
compact support; it and its Fourier inverse are Schwartz--Bruhat.
The preceding orthogonality proves the claimed support in
`(C_sharp)^vee`, and its integral-trace consequence follows from
`1 in C_sharp`.

Here is a direct proof of the reciprocal Gaussian identity, at 2 as well
as at odd primes. Work in a self-dual lattice `L_0` for a symmetric form
`B_0`, and let `P` be invertible and self-adjoint. Write
`q_P(x)=B_0(Px,x)/2`. Choose a small lattice `U` with
`q_P(U) subset Z_p`. Integration on a coset of `U` gives

    integral_(x+U) psi(q_P)
      = psi(q_P(x)) vol(U) 1_(P x in U^perp).

Consequently the integral over any sufficiently large lattice is stable:
only cosets in the fixed compact lattice `P^(-1)U^perp` contribute.
Let its stable value be `G(P)`. For `B_N=p^(-N)L_0`, differencing gives

    |integral_(B_N) psi(q_P)|^2
      = vol(B_N) integral_(B_N intersect P^(-1) B_N^perp) psi(q_P(h)) dh.

For large `N` the intersection is `P^(-1)p^N L_0`, on which `q_P`
is integral. The right side is `|det P|_p^(-1)`. It follows that
`G(P)=omega(P)|det P|_p^(-1/2)`, with `|omega(P)|=1`.
Completing the square, uniformly for `y in L_0` once `N` is large, gives

    integral_(B_N) psi(q_P(x)+B_0(x,y)) dx
      = G(P) psi(-q_(P^(-1))(y)).

Integrate this identity over `y in L_0`. Orthogonality on the left,
using self-duality and `B_N superset L_0`, yields

    integral_(L_0) psi(q_P)
      = omega(P)|det P|_p^(-1/2)
        integral_(L_0) psi(-q_(P^(-1))).                 (2.1)

This proof used neither diagonalization over `Z_p` nor division by 2
inside `Z_p`. Changing variables in the stable integral shows
`omega(T^* P T)=omega(P)` for every invertible `T`; the determinant
normalization cancels its Jacobian. For `P=u rho(alpha)` this becomes

    integral_L psi(u Q_alpha)
      = omega(u,alpha) |Norm alpha|_p^(-1)
        integral_L psi(-u^(-1) Q_(alpha^(-1))).          (2.2)

Here `det rho(alpha)=(Norm alpha)^2`, since the module has rank two.
Taking `T=rho(r)` proves
`omega(u,alpha r^2)=omega(u,alpha)`. No preservation of `L` by `r`
is required.

Finally, for `I_beta(u)=integral_L psi(-u^(-1)Q_beta)`, differencing
and self-duality give

    |I_beta(u)|^2
      = integral_(h in L, rho(beta)h in L)
          psi(-u^(-1)Q_beta(h)) dh.

Its absolute value is at most the mass of that sublattice. The finite
group `(L+rho(beta)L)/L` has exponent exactly `p^j`: this is the
definition of `j`. It therefore has at least `p^j` elements. The kernel
of `h -> rho(beta)h mod L` is the sublattice in the integral. Hence

    |I_beta(u)| <= p^(-j/2).                            (2.3)

This also proves the index estimate without assumptions about repeated
elementary divisors or diagonalizability of the integral lattice.

## 3. Scalar shifts and literal decay

For `p>5`, among `s=0,1,2,3` each integral field component forbids
at most one scalar residue if `A_nu+s` is required to be a unit.
There are at most three such components, so one choice works.
For `p<=5`, distinct numbers on this list have
`v_p(s-s')<=1`. Two choices cannot both satisfy
`v_nu(A_nu+s)>e_nu` for a fixed component, by the ultrametric inequality.
Again a choice remains. Negative component valuations do not change
under integral shifts. Thus this allowed choice satisfies

    beta=(A+s)^(-1) in p^(-iota) h,
    p^(-3 iota) H <= |Norm(A+s)|_p <= H.

The finite group `h/(h intersect C)` is killed by `p^c`, hence by
`p^g`, so `p^g h subset C` and in fact `j<=c+iota<=g+iota`.
Integrality of `Q_1` makes the original integral invariant under the
shift, for each unit `u`. Apply (2.2), (2.3) and the displayed norm
bound, then average `u`. This proves the literal decay.
Since `vol(S_h)<=H vol(R)`, integration gives its literal inverse
sup norm.

For later use note an improvement: if `p` is odd and at least one
`h_nu>0`, there are at most two integral components. The three
distinct residues `0,1,2` suffice even at `p=3`, and give
`beta in h` and `|Norm(A+s)|_p=H`. Thus
`|gamma(A)|<=H^(-1)` at all odd primes on such a shell. If there are
no poles, `H=1` and this bound follows directly from probability
normalization. This proves the improved odd-prime inverse sup norm.

## 4. Improved conductor support, with no depth bound

First let `p` be odd and `c>0`. If all `h_nu=0`, then `h=R` and
`p^c R subset C`; `Q_t(L)` is integral for `t in C` because 2 is a
unit. Therefore the shell restriction has period `p^c R`, proving
(B1) in this case.

Otherwise use the improved shift at the end of Section 3, so that
`alpha=A+s`, `beta=alpha^(-1) in h`. For any
`t in p^c h^(-1)`, translation preserves the shell and

    zeta=t beta in p^c R,
    alpha+t=alpha(1+zeta),
    (alpha+t)^(-1)-beta = -t beta^2/(1+zeta) in p^c h subset C.

Every `1+zeta_nu` is a square unit at odd residue characteristic.
For clarity this elementary square-root assertion follows by Newton
iteration at 1: the derivative 2 is a unit, the error is in the maximal
ideal, and each correction squares its valuation. This works over every
ramified factor. The norm in (2.2) is unchanged, its phase is unchanged
by square-isometry invariance, and its inverse integral is unchanged
by the displayed element of `C`. These assertions hold for each `u`,
not just on average. Consequently the zero-extended shell function has
period `p^c h^(-1)`; its annihilator proves (B1).

At `p=2` take `N=max(c+3,4)` and use the original scalar shift, for
which `beta in 2^(-1)h`. If `t in 2^N h^(-1)`, then

    t beta in 2^(N-1) R subset 8R,
    (alpha+t)^(-1)-beta in 2^(N-2) h subset 2C.

The same shift still has its required valuations. The first inclusion
ensures that `1+t beta` is a square unit, including in wildly ramified
factors. Indeed for `f(Y)=Y^2-(1+t beta)`, the error at 1 has normalized
valuation at least 3. Newton's correction has valuation at least 2,
keeps the iterate a unit, and changes an error of valuation `v>=3`
to one of valuation at least `2v-2>v`. It converges to a square root.
The second inclusion makes the inverse quadratic difference integral,
since `Q_(2a)(x)=B(rho(a)x,x)` for `a in C`. Applying (2.2) as before
proves period `2^N h^(-1)` and hence (B2).

These are uniform arguments: `c` is an arbitrary nonnegative integer,
and no compactness over a collection of orders, tame-ramification
assumption, or bound on the different was used.

## 5. The boundary when c=0

This argument works at every odd prime. Now `h subset C`. For a factor
with `h_nu=0`, its idempotent and entire component ring are contained in
`h`, and hence preserve `L`. These self-adjoint projections split `L`
orthogonally; each summand is self-dual. The integral frequency on such a
summand contributes 1, since 2 is a unit.

On the complementary summand consisting of all positive `h_nu`, the
inverse frequency, extended by zero, belongs to `h subset C`. Its
quadratic integral on the right of (2.1) is 1. Thus the frequency
function on the positive factors is `H^(-1)` times a unit-average
of phases of modulus 1. Changing the unit in any factor by a square
does not change that phase. At odd residue characteristic principal
units are squares, by the Newton argument above. Fourier expansion
on the product of the residue unit square-class groups therefore gives
at most `2^r<=8` terms, with coefficients of modulus at most 1, each
the product of either a trivial or quadratic residue unit character.
The common average over `u` causes no independence assumption.

For one factor with `h>0`, the inverse of the trivial character,
including its factor `q^(-h)`, is

    vol(R_nu) (1_(q_nu^h d_nu^(-1))
                  - q_nu^(-1) 1_(q_nu^(h-1) d_nu^(-1))).

The nontrivial quadratic character has inverse supported on exactly
the intervening boundary, where its modulus is
`vol(R_nu) q_nu^(-1/2)`. To verify this, it is invariant under residue
cosets, its residue sum is zero at the trivial additive character,
and at a nontrivial additive character `eta` its Gauss sum satisfies

    |sum_(a in k^times) chi(a) eta(a)|^2
      = sum_(t in k^times) chi(t) sum_(b in k^times) eta((t-1)b)
      = q.

For `h=0` the inverse is
`vol(R_nu) 1_(d_nu^(-1))`. Multiplication of these component
formulae and the at most eight coefficients proves both the stated
boundary support and boundary bound, retaining the different in
every component.

The manuscript's coarse support follows from Sections 4-5. If `g>0`
and `p` is odd, `c<=g<=4(g+1)`. At 2,
`max(c+3,4)<=4(g+1)`. If `g=0` and `p=3` or 5, the boundary support
is contained in `p^(-1) h d^(-1)`, and thus in `p^(-4) h d^(-1)`.
For `g=0,p>5` Section 5 is exactly the required stronger assertion.
This completes the proof of every assertion in Theorem A.

## 6. Exact sharpness family

Use the dot product trace pairing on `E=Q_p^3`. Let

    T = [[1,0,0], [1,p^m,0], [0,0,1]],
    M = T Z_p^3,
    W = E plus E,
    B((x,y),(x',y')) = x dot y' + x' dot y,
    L = M plus M^*,   M^* = T^(-transpose) Z_p^3.

The action is componentwise multiplication on both copies of `E`.
In lattice coordinates `(a,b)`, `B` is the standard hyperbolic form
and `Q_1=a dot b`; changing the sign of one second coordinate gives
the manuscript's signed split expression. This proves integrality and
self-duality, at 2 as well. The ring `M` contains 1 and is precisely
the displayed order `C`. A multiplier preserving `M` belongs to `M`
by evaluation at 1, while every element of that ring preserves `M`.
Self-adjointness shows that its stabilizer on the dual lattice is
the same order. Thus this is the actual `C_L`, not a chosen substitute.

For `h=(p^k,p^k,1)` with `m=k+c`, the only congruence in
`h intersect C` is
`p^k(a1-a2)=0 mod p^m`. Its quotient has cardinality and exponent
`p^c`, proving `g=c`.

Write `A=(p^(-k)a,p^(-k)b,A3)` on the shell, so `a,b` are units
and `A3` is integral. On the first copy of `E`, multiplication in
lattice coordinates is

    T^(-1) diag(A) T
      = [[p^(-k)a, 0, 0],
         [p^(-m-k)(b-a), p^(-k)b, 0],
         [0,0,A3]].

Put `w=v_p(a-b)`, allowing `w=infinity`. The first two Smith
exponents are `-k-d` and `-k+d`, with `d=max(0,m-w)`, because
the minimum entry valuation and the determinant valuation determine
them. Integration in the second hyperbolic variable is additive
orthogonality, independent of the unit `u`. It gives exactly

    gamma(A)=p^(-2k) F_c(a-b),
    F_c(d)=p^(-max(0,c-v_p(d))).                         (6.1)

Evaluate the inverse at `z=(p^(k-c),-p^(k-c),epsilon)` with
`epsilon in Z_p`. The integral over `A3 in Z_p` is 1. The measure
change in the two pole coordinates cancels `p^(-2k)`, and

    K_h(z)=integral_(a,b in Z_p^times)
               F_c(a-b) psi(-(a-b)/p^c) da db.           (6.2)

For a fixed difference `d`, the permitted `b` have mass
`1-p^(-1)` if `p|d`, and `1-2p^(-1)` otherwise.
For each valuation `r<c-1`, the integral of `psi(-d/p^c)` on that
valuation shell is zero, by subtraction of two ball integrals.
On the shell `r=c-1` it is `-p^(-c)`, and on `p^c Z_p`
it is `p^(-c)`. Because `c>=2`, the two surviving pieces both have
the first difference mass `1-p^(-1)`. The value of `F_c` on them
is respectively `p^(-1)` and 1. Consequently

    K_h(z)=(1-p^(-1))(p^(-c)-p^(-1)p^(-c))
          =(1-p^(-1))^2 p^(-c).

This proves (C1) for unbounded `k,c`, including at 2, without
extrapolating a finite computation.

## 7. A cubic global profile corollary: 24 becomes 3

Let `F` be any cubic number field with absolute discriminant `D_F`,
and let a finite set `S` carry local data as above. Write
`h=product h_p`, `H=Norm(h)`, `G_exp=product_(p in S) p^(c_p)`.
For a nonzero `z in F`, integral outside `S`, with
`product K_(p,h_p)(z) != 0`, let `T_boundary` be the product of
the norms of its actual boundary primes at **odd** `p` with `c_p=0`.
If `|Norm(z)|<=M`, then

    H <= 2^12 M D_F G_exp^3 T_boundary,
    G_exp <= G_0 = product p^(g_p).                      (7.1)

All such `z` belong, after dropping `h_p` and the nonnegative
boundary ideal exponents, to a fractional ideal `a_h` with

    Norm(a_h)^(-1) <= 2^12 D_F G_exp^3.                 (7.2)

Proof: the local supports put `z` in the ideal

    b = h d_F^(-1)
        times product_(odd p, c_p>0) (pR_F)^(-c_p)
        times (2R_F)^(-N_2)
        times product_(odd boundary q) q^(-1),

where the dyadic factor is omitted if `2 notin S`. Thus
`Norm(b)=H/(D_F T_boundary 2^(3N_2)
product_(odd p,c_p>0) p^(3c_p))`. Because `(z) subset b`,
the positive integer `[b:(z)]` shows `|Norm(z)|>=Norm(b)`.
Use `N_2=max(c_2+3,4)<=c_2+4` to obtain (7.1).
For (7.2), omit `h`; at boundary factors the exponent `h_nu-1`
is nonnegative, so omitting those remaining positive powers enlarges
support. The same norm calculation applies.

For comparison with the manuscript's *unchanged* boundary convention,
keep its `T_boundary` only at `g_p=0,p>5` and apply the coarser
`p^(-1)h_p d_p^(-1)` bound at `p=3,5` when `c_p=0`.
Then both bounds (7.1)-(7.2) hold with `2^12` replaced by
`2^12 * 3^3 * 5^3`. Thus this also improves the precise
`G_0^24` power in `lem:add-profile-bounds` to `G_0^3` with
its original boundary definition, not merely a renamed profile.
No improvement of the later global equidistribution exponents is asserted.

## 8. Exact replay and limitations

Run `python3 research/quartic_shell/verify.py`. The default replay reads
`exact_certificate.json`, checks its full expected contents, replays the
typed Jacobian residue sum, verifies the sharpness-family finite Fourier
identities exactly, and tests explicitly constructed ramified lattices.
There are no floating-point comparisons or random seeds.

The construction tests use `L=M plus M^dual` with the trace-dual
computed from the actual multiplication table, not a self-duality
assumption that forgets the different. Their actual stabilizer is
the unital ring `M=Z_p 1+p^m R`. They include Eisenstein
quadratic and cubic factors at 2 and 3, unramified controls, split
products, zero integral components and depths through 12.
These are tests of a subclass (hyperbolic over `E`), not exhaustive
coverage of all quadratic `E`-spaces. Sections 2-5, not these tests,
cover all the forms, primes, ramification types and depths in Theorems A-B.
The exact family identity in Section 6 proves sharpness at unbounded
parameters; default finite instances merely replay it.

Independent review must read these proofs and the precise source
statements, rerun the certificate, independently assess the new bounds
and significance, and confirm any eventual acceptance in the ledger.
Until that happens the result is an Engineer theorem submission, not an
independently certified publication-level campaign completion.
