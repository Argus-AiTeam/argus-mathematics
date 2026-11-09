# Reflection mechanism audit

## Statement and scope

The target is the primary manuscript's `prop:reflection`, specifically

    sum_m |B_m(Z)|^2 << Z^epsilon P^(1/2) (D + D^2 P/Z),

with its fixed cyclotomic field containing `mu_12`, final fixed set `S`,
compact balanced annular row set, arbitrary dyadic `P,D >= 1`, and `Z >= 2`.
The squarefree coefficient and unrestricted cube factor may share primes.
All residue-character powers retain the nonunit mask, including zeroth powers.
A failure of a proof input does not by itself refute this bound or either
manuscript's main theorem.

The dependency graph records both main theorems. The simultaneous-base
manuscript remains explicitly conditional on its four inputs. Unexamined
dependencies are open, not accepted assumptions or verified theorems.

## Literature scope and retrieval

The primary normalization cites Kazhdan--Patterson (1984), its 1985 correction,
and Kubota (1967). The quadratic-sieve application cites Goldmakher--Louvel
(2013), Definition 1 and Theorem 1.1. Primary-source copies of the first,
the correction, and arXiv:1112.1642v2 have been obtained under `literature/`.
Their mathematical applicability is not established by retrieval alone.
The web-search-generated paraphrases are not evidence: the returned paraphrase
of Goldmakher--Louvel condition (3) differed from the obtained primary text.

The inherited Wiki index has no matching primitive-root, theta-reflection,
or quadratic-large-sieve page. No prior mathematical result from that Wiki is
being used. An attempted delegated source reader reported empty directories,
contradicted by successful exact-path reads; that report is not evidence about
the manuscripts. Direct source reads are authoritative.

Finite residue computations can diagnose a false local identity, but agreement
at finitely many primes or valuations cannot verify the all-parameter moment.

## Result classification

The result below is a **prose verification of the reflection reduction for the
declared arithmetic data**, accompanied by exact symbolic checks of its
normalization and exponent bookkeeping. It is not a counterexample, a Lean
formalization, a proof of Artin's conjecture, or a novelty claim.

The all-parameter argument does not restrict cube valuations, remove powerful
rows, replace a masked zeroth power by the constant character, or identify the
row-unit class with the independently summed frequency-unit class. No false
manuscript assertion has been established in this audit.

There are two important limits on acceptance:

1. The source comparisons and the prose argument still require the Host's
   independent Reviewer. The Engineer cannot supply that verdict.
2. The standard arithmetic foundations used in the manuscript's construction
   of the allowed generators and Gauss correction characters are not formally
   re-proved by `verify.py`. The attempted Neukirch publisher download returned
   an HTML book page rather than the textbook. The initial Numdam and journal
   attempts for Weil also failed, but the legitimate scan linked by the
   MathSciDoc archive was subsequently obtained and its Sections 27-30 and 41
   were read. The remaining textbook limitation is not a refutation. It must
   not be hidden behind a claim that every external citation is certified.

Consequently `C_REFLECTION` remains open in the public graph pending independent
review and the arithmetic-source issue. The exact algebra theorem below is
narrower than an unconditional certification of the entire proposition.

## 1. Imported representation and sieve inputs

The relevant source is the actual primary text, not its search-engine summary.

| Input | Exact source | Hypotheses in this application |
|---|---|---|
| Cover, center, compact sections | KP84, Section 0.1, pp.39-44, especially Propositions 0.1.1 and 0.1.3 | rank 2, cover degree 3; exterior residue characteristic prime to 3 |
| Exceptional subrepresentation and quotient | KP84, Theorem I.2.9(a),(b),(f), p.72; exceptional condition on p.71 | the specified central character is exceptional and unramified outside a fixed finite set |
| Local uniqueness | KP84, Corollary I.3.6, p.79 | rank 2 = 3-1 and 2(2+1) = 0 modulo 3 |
| Complex local model | KP84, Theorems I.6.4(c) and I.6.5(c), pp.104-105 | complex field and rank 2 <= cover degree 3 |
| Global residual representation and genericity | KP84, Section II.1, p.107; Theorems II.2.1 and II.2.5, pp.118,122 | compatible global inducing character; nonzero, indeed one-dimensional, tame local Whittaker spaces |
| Correction to global coefficients | KP85, p.203 | the rank-two correction has T(S) = product of (1+q_v^(-1)) at finite S-places; the withdrawn auxiliary vanishing assertion is not used |
| Quadratic large sieve | Goldmakher--Louvel, arXiv:1112.1642v2, Definition 1 and Theorem 1.1, pp.1-2, with the primitive-product convention on p.5 | full family of primitive quadratic characters of trivial infinite type, finite-class reciprocity, and exact conductor product in a common class |
| Jacobi norm lifting in the arithmetic input | Hoshi--Kanai, arXiv:2105.14872v2, Theorem 1.1, p.2 | both characters and their product nontrivial; for rho,rho of order 3 these are rho,rho,rho^2 |
| Additive duality and Poisson summation | Weil, doi:10.1007/BF02391012, Chapter II, Section 29 and Chapter III, Section 41, equation (39) | number field, nontrivial adelic character trivial on the field, self-dual measures; all non-self-dual exterior lattices excluded in S |
| Quadratic Gauss phases | Weil, same source, Chapter II, Sections 27-28 and Proposition 5 in Section 30 | nondegenerate quadratic forms over a number field of characteristic zero; conductor-zero odd exterior places |

These are source comparisons by the Engineer, not independent citation
attributions. The ledger records the distinction.

The separate retrieval-limited arithmetic assumption consists of the local
Hilbert duality and power-class dimensions, the S-unit theorem, the
class-field description of unramified extensions split at S, Hilbert
reciprocity, and compactness of the norm-one idele class group. The manuscript
locates these in Neukirch (1999), Chapter II Corollary (5.8), Chapter I
Propositions/Corollaries (11.6)-(11.7), Chapter V Proposition (3.2), and
Chapter VI Theorems (1.6), (7.3), (8.1) and Proposition (6.9). None of those
proposition numbers is treated as checked merely because the publisher's
book page was reachable.

### Cover and datum

For diagonal matrices the stated determinant-modified cocycle is

    sigma_c(diag(a,b),diag(a',b')) = (a,b')_3 (ab,a'b')_3^c.

The scalar-center exponent is `1+4c`. At `c=2` it is 9; the cocycle on
two ordinary scalar lifts is also a ninth power of a cubic symbol. Hence the
ordinary scalar subgroup is split and central. Taking its quotient is
legitimate, not a tacit identification of two noncommuting lifts.

The central character on a cube diagonal times a scalar is well-defined:
cube symbols are trivial, and two presentations have the same diagonal ratio.
It is trivial on the split scalars. On `diag(t^3,t^(-3))` it is `|t|`, the
exceptional condition. Its Weyl conjugate gives the norm exponent `-1/6`.
The modular half-character on a triple valuation contributes `q^(-3/2)`;
the Weyl-conjugate central datum contributes `q^(1/2)`. Their product is
`q^(-1)`, not 1.

For the global compatibility condition on KP84 p.107, a rational diagonal
in the adelic cube torus times scalars has ratio a cube in every completion.
If its ratio were not a cube globally, its nontrivial cyclic Kummer
extension would have a nontrivial Frobenius at an unramified prime, contradicting
local cubeness there. The product formula then makes the inducing character
trivial on the required rational intersection. Its scalar restriction is
trivial, hence unitary. KP's global construction applies with these data.
The exceptional representations inherit the trivial split-scalar action.

The actual printed Corollary I.3.6 has a congruence to zero, not a
noncongruence: `2(c+1) = 0 (mod n)`. The page image is retained because the OCR
did not reliably distinguish that symbol. It agrees with the manuscript's
choice `c=2`.

The normalized product of local Whittaker functions follows from the
nonzero global functional and local uniqueness by varying one tensor factor
at a time. This argument does not require the auxiliary spherical-functional
vanishing statement withdrawn by the 1985 correction. The exceptional
constant term has radial complex inducing characters, including after a
fixed right translation.

## 2. Exact all-valuation normalization theorem

Here is the algebraic verification claim `C_REFLECTION_ALGEBRA`.

**Theorem.** Let `q = 1 (mod 12)` be a prime power, let `chi` have exact order
6 on its residue field, and let the additive character be nontrivial. At a
conductor-zero nonarchimedean place with the declared lifts and datum:

* The normalized spherical values have support `e = 3k` or `3k+1`, and
  their shift by three nonnegative valuations is multiplication by `q^(-1)`.
* For all six row classes `j`, the nonzero-digit reflected local function has
  unit exponent `8-j` at numerator valuation zero. At positive numerator
  valuation its exponent is `4+2e` and its coefficient is zero unless `j=4`.
  The positive-valuation functions satisfy the exact triple-step recurrence.
* The valuation-one row and squarefree column interaction has exponent
  `1-4 = 3 (mod 6)`. Unrestricted cube factors do not alter this interaction.

This is an all-parameter statement. The finite-field computation at 13 below
is a separate diagnostic and is not its proof.

### 2.1 Stable Jacquet shells

Write `G_j = sum_x chi(x)^j psi(x/p)` with the nonunit mask, so

    G_0 = -1,       G_j G_(-j) = q  (j != 0 mod 6).

For the second identity, expand the product, put `x=ty`, and use the
additive-character sum over `y != 0`. Its inner sum is `q-1` when `t=-1`
and `-1` otherwise; multiplicative orthogonality leaves
`q chi(-1)^j = q`. This proves nonvanishing of every nontrivial Gauss
denominator without a numerical approximation.

In the three-dimensional inducing-torus model choose `e_j` with

    e_(j+3) = e_j,
    sigma^-(a(p^j u)) e_0 = q^(j/6) chi(u)^(2j) e_j.

The torus law and unit invariance give this formula directly. For the
Jacquet value at `a(p^e)`, put `x=p^e H`. The measure, modular factor and
inducing factor give, respectively, `q^(-e)`, `q^(e/2)` and `q^(-e/6)`.
Their product is `q^(-2e/3)`.

On `H=p^(-l)v`, `l>=1`, the lifted Bruhat decomposition gives the shell

    q^(l/3) e_(-e+2l)
        integral_units chi(v)^(-8l) conjugate(psi(p^(e-l)v)) dv.

All sufficiently deep shells vanish: the multiplicative factor is constant
on small additive unit cosets and the remaining additive character has
nontrivial oscillation. The same argument applies to each fixed smooth
right translate; this is a stable Jacquet integral, not an unjustified
absolutely convergent integral at every inducing parameter.

For `l<=e`, the integral is `1-q^(-1)` if `3|l` and zero otherwise. For
`l=e+1`, it is `G_(-2l)/q`; this includes `-1/q` when `3|l`.
For `l>e+1` it is zero by grouping the last residue digit.

Let `C_k` be the ball plus the shells `l=3,6,...,3k`. Then

    C_0 = 1,
    C_(k+1) = C_k + (1-q^(-1))q^(k+1),
    C_k = q^k.

The last equality follows by induction: its step is an exact rational
identity in `q` and `q^k`. Thus no valuation cutoff is used.

Put `T=q^(1/6)`, `U=q^k`, `A=G_2`, `B=G_4`. Then `AB=T^6=q`.
For `e=3k+r` the common factor is `U^(-2)T^(-4r)`. The combined earlier
shells contribute `U e_(-r)`, and the terminal shell contributes

    U T^(2(r+1)) I_r e_(r+2),
    (I_0,I_1,I_2) = (B/T^6, A/T^6, -1/T^6),

with basis indices taken modulo 3. Consequently, with
`J_0=e_0+(B/T^4)e_2`,

    J_(3k)   = q^(-k) J_0,
    J_(3k+1) = q^(-k-1) G_2 J_0,
    J_(3k+2) = 0.

These are precisely the symbolic three-case shell computations replayed by
`verify.py`, reduced modulo `AB-q` and `T^6-q`. The recurrence for `C_k`
and the three residue classes cover every nonnegative integer valuation.
Local uniqueness identifies these ratios with the normalized spherical
Whittaker function. Negative valuations vanish by Whittaker equivariance
under an integral upper root. Right invariance under unit diagonals gives

    W(a(p^e u)) = chi(u)^(2e) W(a(p^e)).

In particular `W_1=G_2/q`, consistent with the manuscript's
`q^(-1/2)g_2`. Replacing `p` by `pu` changes the Gauss sum by
`chi(u)^2`, exactly the same unit factor. This is not a normalization in
which the Gauss phase and torus-unit orientation can be chosen separately.

### 2.2 Masks and the local reflected functions

For `j!=0`, let `tau_j=G_(-j)` and

    alpha_j(v) = chi(v)^(-j)/tau_j  (v!=0),    alpha_j(0)=0.

For `j=0`, let `alpha_0(0)=1-1/q` and `alpha_0(v)=-1/q` on nonzero
digits. Summing `alpha_j(v)psi(tv/p)` gives the masked character
`chi(t)^j`. For `j=0` this is `1-(1/q)sum_v psi(tv/p)`, hence is zero
on a nonunit and one on a unit. The zeroth-power mask is not dispensable.

For a nonzero digit put `H=v/p`. The exact lifts give

    w n(H) = n(H^(-1)) a(H^(-2)) k_v,

where `k_v=a(-1) lower_n(p/v)` is compact. Its signs have trivial symbols
because `-1` is a sixth power. For a unit `t`, multiplication after
`a(p^(e-2)t)` supplies the cocycle

    chi(t)^4 chi(v)^(4(e-2)),

and the spherical unit factor supplies `chi(t)^(2e)chi(v)^(-4e)`.
The digit exponent is therefore `-8 = 4 (mod 6)`, independently of `e`.
The additive argument has positive sign: `psi(p^(e-1)t/v)`.
It follows that the reflected function is

    R_(j,e)(t)
      = W_e chi(t)^(4+2e)
          sum_(v!=0) alpha_j(v) chi(v)^4 psi(p^(e-1)t/v).

For `e<0` it vanishes. For `e>0`, the additive character is trivial;
orthogonality makes the digit sum vanish unless `j=4`, and the unit
exponent is `4+2e`. This assertion includes `j=0`.

For `e=0`, substitute `x=t/v`. The unit exponent is `8-j`, with scalar

    s_(j,0) = G_(j-4)/G_(-j)        (j!=0),
    s_(0,0) = -G_2/q.

The squared magnitude is `1/q` for `j=0` or `j=4`, and 1 for the other
four classes. In particular

    R_(1,0)(t) = (G_3/G_5) chi(t),

and the scalar has modulus one. For `e>0`, only class 4 survives and

    s_(4,e) = ((q-1)/G_2) W_e.

Together with the spherical triple step this proves
`R_(j,e+3)(t)=q^(-1)R_(j,e)(t)` for every `e>=1`.
The separate base `e=0` must not be included in that recurrence.

The all-valuation majorant is

    beta(0)=1,
    beta(1+3k)=q^(-k)          (k>=0),
    beta(3k)=q^(1/2-k)        (k>=1),
    beta(e)=0                otherwise.

For each positive supported valuation the squared actual magnitude divided
by `beta(e)^2` is `(1-1/q)^2 <= 1`. The exact margin
`1-(1-1/q)^2=(2q-1)/q^2` is positive for `q>=2`.
The zero digit exists only for class 0 and contributes
`(1-1/q)W(a(nu))`, with ordinary spherical support.

## 3. The global assembly, including all exceptional cases

This section uses the declared arithmetic data: the Lagrangian complement
`B`, `Gamma=U_S^6`, allowed generators, exact exterior reciprocity, and
the unitary character `L` with nontrivial complex angular type. Their
existence is separated in `C_ARITHMETIC`; it is not inferred from the
finite-field diagnostic.

For clarity, the arithmetic implication still needed for an unconditional
acceptance is precise. Local duality and the S-unit theorem give dimensions
`2s_f+2r` and `s_f+r` for each of the 2- and 3-power-class problems.
The kernel of the S-unit localization map would give an everywhere unramified
Kummer extension split at S; the trivial S-class group excludes it.
Reciprocity makes the resulting half-dimensional unit image isotropic, and
`-1 in F^(x6)` makes the pairing alternating. Symplectic linear algebra
then gives the complementary `B`. Norm-one idele compactness supplies
balanced generators modulo `U_S^6`. This is a sound conditional deduction,
but the listed textbook inputs have not received a source attribution here.

The remaining Gauss-character portion can be compared with the obtained
sources. Over `Q(omega)`, the cubic Jacobi sum is divisible by its prime,
has the matching absolute norm, and is `-1` modulo 3; these determine the
primary generator and its angular Hecke character. Hoshi--Kanai Theorem 1.1
gives its norm pullback with sign `(-1)^(f-1)`; the nontriviality hypotheses
hold for `rho,rho,rho^2`. Weil's Section 27 identifies the odd conductor-zero
quadratic Gauss sum with the normalized index at `p^(-1)`. His Section 28
gives its Hilbert-symbol multiplicative defect, and Proposition 5 gives the
global product 1. On the isotropic `B` the defect vanishes, so the remaining
quadratic signs are a finite class character. This checks the imported
formulas without inventing a globally finite character from arbitrary
prime signs. The pure angular infinity type and the finite S-conductors
required in the reflection argument follow.

### 3.1 Radial smoothing and unreflected unfolding

For the fixed finite family of row-unit classes, the finite cutoff vector
can be prescribed to have Whittaker function `1_U`, where `U` lies in the
sixth powers and all relevant finite character kernels. Indeed average
upper-root translates against the inverse additive Fourier transform of
`1_U`, after starting with a Whittaker function nonzero near one.

At a complex place the normalized inducing characters are `|.|^(1/6)` and
`|.|^(-1/6)`. The convergent Jacquet integral gives
`|y|^(1/2)K_(1/3)(c sqrt(|y|))`. A suitable first upper-root derivative
gives `|y| omega_(+/-1)(y)K_(1/3)(c sqrt(|y|))`. This cancels the angular
character of `L^(-1)`.

A fixed compact rotation of a first derivative is another first Lie
derivative of the spherical vector. The Jacquet integrand and its norm
derivatives are bounded by a constant times

    rho^(4/3) (rho^2+|x|^2)^(-4/3),

where `rho=sqrt(|y|)`. The integral is `O(rho^(2/3))` at zero.
Each integration by parts in a real Fourier direction improves the large
`rho` power by one. The resulting fixed complex profiles therefore have
small-norm power decay and arbitrary large-norm decay, also after norm
derivatives. At finite places smooth upper-root invariance gives a
large-norm cutoff. The two Bruhat constituents of the inducing Jacquet
module have triple-step magnitudes `q^(-1)` and `q^(-2)`; the associated
eventual recurrence gives small-norm decay for every fixed vector.

To pass to an S-norm sheet, use one complex norm as a dependent variable.
For any `sigma` greater than the negative small-norm exponent, the weighted
supremum of that complex factor and the weighted integrals of the other
local factors bound the absolute sheet integral by `C_sigma u^(-sigma)`.
Differentiation can be put on the dependent complex factor. Thus every
fixed rotated or unrotated sheet profile, including a bounded power-class
multiplier, has bounds

    |(u d/du)^j H(u)| <= C_(N,j) min(u^alpha,u^(-N))

for some fixed `alpha>0` and every `N,j`. This is a product-integral
argument, so neither the number of row primes nor their valuations alter
the profile family.

The unrotated radial profile has Mellin transform

    Vhat(s) = C A^s [Gamma(s+5/6)Gamma(s+7/6)]^r.

The one-place identity follows from substituting `t=|y|` in
`integral t^(s+1)K_(1/3)(c sqrt(t)) dt/t`. The finite cutoff factors are
positive constants. Set

    R(s) = exp(s^2)/Vhat(s),
    K(T) = (1/(2 pi i)) integral_(sigma) R(s) T^s ds.

Reciprocal gamma factors are entire. On any fixed vertical strip their
growth, multiplied by `exp(s^2)`, is at most a polynomial times
`exp(-Im(s)^2+pi r |Im(s)|)`. Moving the line in either direction proves
that `K` has every absolute moment. The signs in Mellin inversion give

    Khat(-s)=R(s),       integral K(T)V(uT) dT/T = P_G(u).

The same kernel applied to a rotated profile with argument `u/T` has the
two-ended profile bounds, by its absolute moments. No interchange uses a
merely conditionally convergent Gaussian average.

For a row `m`, apply all its masks to the theta expansion and integrate on
`X_l/Gamma` against `1_B([y])L(y)^(-1)`. The combined digit sums descend
under `Gamma`: reindex the digits by its unit, use rational diagonal
automorphy, and remove the resulting right compact factor. This also works
with the zero digit. The two constant terms have zero weighted integral:
rotation at one complex place preserves the class condition and their
radial inducing law, but multiplies the weight by a nontrivial angular
character.

In the plus expansion, spherical support forces an S-integer frequency.
Its S cutoff and `[y] in B` force its class to be in `B`; it is therefore
`gamma A` with `gamma in Gamma` and `A` allowed. The S cocycle is 1 on this
support. The sets `gamma Omega_l` partition the whole norm sheet. The
unfolding contributes `L(A)V(q_A l)` with no multiplicative-norm Jacobian.
Section 2 and the CRT identity give the exterior coefficient
`gamma_2(c)/(q_c^(1/2)q_n)` for `A=c n^3`, including `c,n` sharing primes.
Averaging at `l=T/Z` therefore gives exactly the stated `B_m(Z)`.

Absolute exchanges follow from the sheet bound with `sigma>1/2` and

    sum_(c,n) q_c^(-1/2-sigma) q_n^(-1-3sigma) < infinity.

Before evaluating masks, their absolute digit masses are finite for each
fixed row. They are used only to justify that row's exchanges, not as a
uniform estimate in the final moment.

### 3.2 Reflected support and phase separation

Write the row ideal as `h d`. A valuation-one prime is necessarily active.
For `p|h`, its class is `j=v_p(h) mod 6`; only class 0 admits an inactive
zero digit. If `f` is the product of active primes in `h`, then

    f | rad(h),        q_f^2 <= q_h.

The inactive factor is exactly the product of `1-1/q_p` over `p|h/f`.
It does not prohibit an inactive prime from subsequently appearing in a
squarefree column or in its cube factor.

Section 2 gives the full nonzero-frequency support

    nu = epsilon a_f c n^3/(d f)^2,
    (c n,d f)=1,

where `c` is squarefree, `n` unrestricted, `a_f` is supported on `f`
with numerator exponents 0 or 1 modulo 3, and local zero coefficients are
retained for the cases where this common support is too broad. At each
prime of `d` the numerator exponent is exactly zero. The ideals `c,n`
need not be coprime. Primes of `h` not in `f` may occur in either.
The factor `epsilon` ranges over frequency-unit classes modulo `Gamma`;
it is independent of the fixed row-unit class.

At a prime of `d`, Section 2 supplies one power of its sextic character
on the column. At a prime of `c`, the denominator `d^2` in the spherical
unit contributes power `-4`, since the valuation there is `1+3k` and its
unit exponent is 2 modulo 6. Reciprocity makes their product

    chi_d(c)^(1-4) = chi_d(c)^3.

At a prime occurring only in `n`, its spherical unit exponent is
`2(3k)=0 (mod 6)`, so there is no further row-column interaction.
At a prime shared by `c,n`, the exponent is still 2 modulo 6. These
observations cover arbitrary, not bounded, cube valuations.

All remaining exterior factors depend only on the fixed data, on the row
alone, or on the column alone. Their magnitudes are bounded, respectively,
by `beta_f(a_f)`, 1, and 1. A common prime of `d,c` gives zero through the
quadratic symbol. A common prime of `d,n` is deleted by a separate row
condition, not incorrectly entrusted to that symbol. The conditions at
`f` are separate column and frozen-ideal restrictions.

For the reflected S integral put `v=gamma nu_0/y`. Then

    [y]=[nu_0][v]^(-1),
    L(y)^(-1)=L(nu_0)^(-1)L(v),
    C_S(gamma nu_0,y^(-1))=H_S(nu_0,v)^2.

After slicing the allowed classes of `d,c`, the class of `nu_0` is fixed.
Thus the S integral is a member of a fixed finite profile family; no
continuous row or column shape remains jointly inside it. Inversion and
translation preserve the multiplicative sheet measure. At `l=T/Z` its
argument after Gaussian averaging is exactly

    Z q_(a_f) q_c q_n^3/(q_d^2 q_f^2).

This proves the separated reflected expression used in the moment
argument. Absolute orbit integrals are bounded by the absolute sheet
profile. The necessary weighted ideal majorant is finite for `sigma>1/2`,
since at an active prime

    E_p(sigma) = sum_e beta_p(e) q_p^(-sigma e)
      = 1 + (q_p^(-sigma)+q_p^(-1/2-3sigma))
                  /(1-q_p^(-1-3sigma)).

In particular `E_p(sigma)<=3+sqrt(2)` for `sigma>=0`, `q_p>=2`.
For any `xi>0`, the finite-small-prime argument gives

    product_(p|f) E_p(sigma) << q_f^xi,
    sum_(f|rad(h)) product_(p|f) E_p(sigma) << q_h^xi.

The weighted sums over `c,n` are bounded by the corresponding convergent
ideal Dirichlet series. The Gaussian kernel has the needed absolute
moments for either sign of its norm variable. This justifies the full
reflected expansion, not only a formal prime-by-prime multiplication.

## 4. Checking the quadratic large-sieve hypotheses

For each squarefree exterior ideal `c`, attach the primitive quadratic
Kummer character `Xi_c` of `F(sqrt(c))/F`, using an allowed generator.
Changing it by `U_S^6` does not change that character. Outside `S`, its
conductor is exactly `c`: an odd valuation gives tame ramification of
quadratic conductor exponent one, and a unit gives an unramified or
trivial character. The S-part of its conductor divides one fixed modulus
`q_S`, chosen sufficiently deep in the local squares. Its infinite type
is trivial because every infinite place is complex.

The primitive value on an exterior ideal `d` is `chi_d(c)^3`, including
zero at a shared prime. This is a primitive character value, not an
imprimitive character with additional deleted Euler factors.

Let `[c]_2` be the image of its allowed class in `B_2`. This is a finite
homomorphic class datum on fractional exterior ideals. It is ray-class
data: a generator congruent to 1 modulo `q_S` is locally square at `S`,
so has trivial `B_2` projection.

Exact allowed-generator reciprocity makes the finite reciprocity factor
identically 1. If coprime squarefree `c_1,c_2` have the same `B_2` class,
then `c_1/c_2` is locally square at every S-place. Their primitive product
character is trivial there, and at every exterior prime its conductor is
exactly `c_1 c_2`. This is precisely condition (3) in Definition 1,
with the primitive-product convention explicitly given on p.5.

Theorem 1.1 therefore gives

    sum_(q_d<=D, squarefree)
      |sum_(q_c<=C, squarefree) z_c chi_d(c)^3|^2
      << (C+D)(CD)^xi sum_c |z_c|^2.

It is the full family that satisfies the theorem. Individual class slices
are imposed afterwards by deleting rows or changing column coefficients.
The argument never assumes that a single slice is itself a Hecke family.
Separate factors of modulus at most one are harmless in the same way.

## 5. All-parameter moment argument

Here is a direct derivation of the stated dyadic bound from the reflected
expression, without a finite truncation hypothesis.

### 5.1 Counting and the row multiplicity

An ideal has only boundedly many generators in the fixed balanced annular
row set: divide by a balanced allowed generator and use discreteness of
`U_S` in the resulting fixed compact norm-one set. Thus one may fix a
row-unit class and count ideal rows, at fixed bounded cost.

The fixed-field bound `#{a:q_a<=t}=O(t)` also follows from the balanced
generators used here. Their finite S-components lie in fixed compact sets,
so their possible denominators in `O_F` are bounded. All complex coordinates
are bounded by a constant times `t^(1/[F:Q])`. A fixed full lattice in the
Minkowski space has `O(t)` points in that box. Distinct ideals have distinct
selected generators. Partial summation now gives all the ideal-counting
estimates below without an additional analytic counting theorem.

Every powerful ideal has the unique form `r^2 s^3` with `s` squarefree:
use the parity of each exponent for `s`. Consequently

    #{h powerful:q_h<2P}
      << P^(1/2) sum_s q_s^(-3/2) << P^(1/2).

The last series converges by the same ideal-count bound. A nonempty
annular row dyad satisfies `PD << Z^M`, `M=1033/1000`.

### 5.2 A uniform tail, including an empty retained range

Fix `h` and set

    Q=q_(a_f) q_c q_n^3,
    t_d=q_d^2 q_f^2/Z,
    L_0=8D^2P/Z,
    R_0=Z^delta L_0.

Then `t_d<=L_0`. Retain `Q<=R_0`, using a threshold common to all rows
of the dyad. If `R_0<1`, the retained range is empty; it is not assigned
an artificial large-sieve length below one.

For `Q>R_0`, both `Q/t_d>Z^delta` and `Q/t_d>=L_0^(-1)` hold. Let
`J=max(Z^delta,L_0^(-1))` and choose `N>sigma>1/2`. The profile bound gives

    1_(Q>R_0)|Phi(Q/t_d)|
      << J^(-(N-sigma)) (t_d/Q)^sigma.

The absolute weighted ideal sum is finite as in Section 3.2. After summing
active choices, squaring, and counting the rows and powerful parts, the
discarded squared mass is

    << P^(1/2+2xi_1) D L_0^(2sigma) J^(-2(N-sigma)).

On the row range `P<<Z^M` and `L_0<<Z^(2M-1)`. Take `sigma=1` and

    N = 1 + (A_0 + 2M xi_1 + 2(2M-1) + 1)/(2delta).

The remaining Z-exponent is exactly `-A_0-1`. The tail is therefore
`O(Z^(-A_0-1)P^(1/2)D)`. This proof includes `R_0<1`, where it bounds
the entire sum.

### 5.3 Retained part

Suppose `R_0>=1`. Freeze `f,a_f,n`, the frequency-unit class, and the two
allowed class slices. On a column dyad `C<=q_c<2C`, the profile depends on
the two varying norms as

    Phi(v_0 exp(x)),
    v_0=Z q_(a_f)q_n^3 C/(D^2 q_f^2),
    x=log(q_c/C)-2log(q_d/D).

The variable `x` lies in a fixed compact interval. Insert a fixed smooth
cutoff equal to one there. Two integrations by parts in its ordinary
Fourier transform give a bounded Fourier L1 norm, in fact
`O(min(v_0^alpha,v_0^(-N)))`. Fourier inversion separates the two norm
variables into independent unitary powers.

Minkowski's inequality and Section 4 then give the row L2 norm for this
column dyad, before its frozen factor, at most

    << (D+C)^(1/2)(DC)^(xi_2/2).

Here the squared column mass is `sum_(C<=q_c<2C)1/q_c=O(1)`. The retained
indicator is a column restriction after `a_f,n` are frozen. The row
restriction `(d,h n)=1` only deletes rows; the shared `d,c` primes are
already handled by the quadratic symbol.

In the retained range `C<=R_0` and `q_n<=R_0^(1/3)`. There are
`O(log(2R_0))` column dyads, and `sum_(q_n<=R_0^(1/3))1/q_n` is also
`O(log(2R_0))`. The full sum over frozen numerator exponents is at most
`product_(p|f)E_p(0)`, even though those exponents are unrestricted.
Successive Minkowski inequalities thus bound the row norm for a fixed
active product by

    << product_(p|f)E_p(0) log^2(2R_0)
         (D+R_0)^(1/2)(DR_0)^(xi_2/2).

Sum norms over active products and the fixed finite class family. Square
for this fixed `h`, and only then sum over `h`. No triangle inequality
across different powerful parts is used. The result is

    retained squared mass
      << P^(1/2+2xi_1) log^4(2R_0)
            (D+R_0)(DR_0)^xi_2.

All constants depend only on the fixed data and indicated losses.

### 5.4 Exact loss allocation

Let `t=min(epsilon,1)` and choose

    delta=t/16,
    xi_1=t/(32M),
    xi_2=t/(16(3M+1)),
    xi_3=t/16.

These are positive. Since

    D+R_0 << Z^delta (D+D^2P/Z),
    DR_0 << Z^(3M-1+delta),
    P << Z^M,
    log^4(2R_0) << Z^xi_3,

the extra Z-exponent is

    loss = delta + 2M xi_1 + (3M-1+delta)xi_2 + xi_3.

An exact rational identity, checked by the script, is

    t/4 - loss = t(32-t)/(256(3M+1)) > 0.

Thus `loss < epsilon`, for every `epsilon>0`, not just selected numerical
values. Adding the uniformly bounded tail and restoring bounded element
multiplicities proves

    sum_rows |B_m(Z)|^2
      << Z^epsilon P^(1/2)(D+D^2P/Z)

from the declared data and imported representation and sieve inputs.
No parameter, cube exponent, unit class, or dyad was omitted. An enlargement
of the compact shape set by a fixed compact norm-one set changes only the
fixed multiplicity constant.

Finally `P^(1/2)D<=PD<<Z^M` and
`P^(3/2)D^2/Z=(PD)^2/(Z P^(1/2))<<Z^(2M-1)`.
Because `M>1`, the first term is at most the latter scale. Summing the
`O(log^2 Z)` nonempty dyads with a smaller preliminary loss gives the
stated total moment.

## 6. What the executable certificate does and does not certify

Run, from any working directory:

    $WORKSPACE/argus-live-update/.venv/bin/python \
        research/reflection_audit/verify.py

The path shown assumes the command is invoked from the campaign root; with
an absolute script path the working directory is immaterial. Python with
SymPy is sufficient; the script does not import Argus or Jacobian.

The recorded run used SymPy 1.14.0. It derived the three universal Jacquet
shell classes with symbolic `q^k`, reduced 12 polynomial numerators exactly,
checked the all-residue phase identities, and checked the exact tail and
epsilon-loss formulas. It also checked 78 Fourier masks and 360 local-unit
identities in `Q(zeta_78)`, realizing the residue field `F_13`. All arithmetic
in that diagnostic is rational polynomial arithmetic, not floating point.
The certificate retains the actual Gauss-sum coefficient vectors.

The nonnegative-valuation induction and the positive-valuation triple
recurrence are the reason the local theorem is not a finite valuation
experiment. The proof of character orthogonality for arbitrary residue
fields is in Section 2, and the analytic all-parameter proof is in Sections
3-5. The program does not pretend to check those prose arguments.

Jacobian 0.14.0, protocol `2025-11-25`, was used only for the matching masked
principal-character operation `dirichlet_character.principal.compute` with
payload `{"modulus":13}`. Its complete typed output is retained beside the
payload and inspected contract under `jacobian/`. It returned zero at 0 and
one at every nonzero residue, without an adapter error or timeout. Bounded
discovery for `Gauss` returned only binary quadratic-form reduction, not a
Gauss-sum operation; that unrelated operation was not forced onto this task.
The Jacobian result verifies the finite principal mask only.

The strongest prior project artifact was an open umbrella claim with an
empty dependency graph. This work supplies a concrete all-valuation algebra
theorem and a complete conditional analytic reduction, not a new unconditional
zero-free theorem. The remaining delivery obligations are independent
reading of this proof and the imported sources, including the explicitly
unobtained arithmetic textbook passages. Until then neither a
publishable campaign result nor the unconditional proposition is marked closed.
