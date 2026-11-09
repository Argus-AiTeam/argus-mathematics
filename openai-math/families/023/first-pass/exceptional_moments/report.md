# Exceptional cubic-character moments: independent certification

## Scope and pre-existing inputs

The object under audit is Proposition `prop:dual` in OpenAI, *An
unconditional first moment for cubic Gauss sums*, September 25, 2026,
`build/sections/dual.tex`. The claim concerns independently smooth,
bounded-prime convolutions, not arbitrary coefficients. Its two limiting
configurations are `(log_Y P, log_Y Q) = (1,0)` and `(1/3,1/3)`.
Certification of this proposition is not certification of the complete
prime asymptotic or its angular extension.

The published sieve input is Heath-Brown's squarefree cubic large
sieve. The original article, DOI `10.1007/s11856-000-1273-y`, could not
be inspected: the publisher sent the source reader to a subscription
page and Oxford ORA returned HTTP 403. Instead the exact statement
actually read is its explicit reproduction in Dunn--Radziwill,
arXiv `2109.07463v3`, Section 1.4, equation (1.11), page 6.
Cubic reciprocity and supplementary laws are (1.4)--(1.5) in that
version, and the Gauss evaluation is (2.1)--(2.2). Its Section 2
explicitly refers back to (1.4)--(1.5). Watkins,
DOI `10.5802/pmb.a-138`, Section 3.6, supplies the primitive Hecke
functional equation; dividing his completion by the constant 2 gives
the completion used here. Nonprincipal completed entireness is also
stated in Thorner--Zaman, DOI `10.2140/ant.2019.13.1039`,
Section 2C, (2-15), page 1049. These are imported dependencies, not
results established by a computer search.

The ordinary character sieve, both nonsquarefree extensions, finite
Hilbert-space Gram inequality, Poisson/CRT separation, and limiting
exponent reduction require independent derivations below. In particular,
the unrestricted-inner extension has the factor **Z**, not the
coefficient square norm; replacing it by the square norm is not justified.
The manuscript does not make that replacement.

The unstructured sieve bounds at both exceptional endpoints have
exponent `7/3`. Thus these bounds alone cannot prove a positive saving.
Sampling exponent vectors or increasing a finite search bound cannot
establish the required universal reduction. Those routes are excluded,
not treated as counterexamples to the manuscript.

The inherited Wiki index was searched for Patterson, cubic-character,
Gauss-sum, exceptional-moment and Gram results. It supplied no relevant
prior result. No novelty conclusion follows from that local search.

## Theorems and improvement over the staged argument

**Theorem 1 (universal exponent obstruction).** Let a finite family of
nonnegative real lengths have sum one. At the first configuration the
unsaved lower bound, all repeated/omitted-factor cubic-sieve
inequalities, the off-diagonal Gram inequality derived below, and the
full-sum alternative are inconsistent. At the second configuration
the unsaved lower bound, cardinality, the ordinary fourth moment,
one repeated factor, and the full-sum alternative are inconsistent.
Zero length exponents and negative value exponents are allowed.

**Theorem 2 (uniform sharp interval gap).** Every `0 < a <= 1/2` has an
integer multiple in `[7/5,19/10)`. Throughout the closed interval
`[7/5,19/10]`, both terms on the right of the normalized Gram
inequality are below the target exponent by at least `1/30`.
Among covering intervals of width at least `1/2`, this common gap is
optimal for these diagonal and off-diagonal inequalities.

**Theorem 3 (analytic consequence).** Subject to the named classical
inputs above and Poisson summation, Proposition `prop:dual` holds with
its full stated independent coefficient class, both exceptional
configurations, the height range `1+|u| <= Y^(0.36)`, and fixed
positive uniform neighborhood size and saving. The proof does not
import either the disputed Gram estimate or the exceptional moment
as an assumption.

The staged manuscript has a qualitative, factor-dependent choice
`4/3 < z < 2`. Theorem 2 replaces this by a common gap `1/30`.
There is a further effective degree observation: with at most `M`
factors, either a full factor has length exponent at least `19/20`,
when the estimates below give gaps at least `9/100` and `4/25`,
or a positive short length is at least `1/(20M)` and the selected
copy multiplicity is at most `28M`. Thus the first configuration
needs only a finite, uniformly bounded collection of moment
inequalities. This last finite-degree observation and the analytic
bridges are prose proofs; the compiler certifies the unrestricted
finite-family exponent theorem and Theorem 2.

This is an independent verification and quantitative sharpening of
the central reduction, not a claim that the underlying conjecture
was previously unknown. Publication-level significance and novelty
remain for independent review. No false mathematical assertion of the
staged manuscript was established in this audit; no `F_` refutation
claim is manufactured.

## 1. Coefficient norms and both sieve extensions

Write `H(P,S) = P + S + (PS)^(2/3)`. The imported squarefree sieve is
`sum_a |sum_s c_s chi_a(s)|^2 << (PS)^epsilon H(P,S) sum_s |c_s|^2`.
Both variables here are primary and squarefree.

The ideal count `#{n: Nn <= T} = O(T)` follows from the Eisenstein
lattice. It gives the harmonic ideal bound `O(log T)`. A fixed power
of the divisor function is dominated by a fixed higher divisor
function, so every fixed coefficient square norm of a
divisor-bounded polynomial of norm length `S` is `S Y^o(1)`.
Fixed convolutions, omissions and fixed repeated copies retain this
property. The notation `Y^o(1)` throughout means that each prescribed
positive power loss is available with a constant depending on the
fixed data; it is not a logarithmic saving.

For unrestricted inner coefficients, write uniquely
`n = s t^2 c^3`, with `s,t` coprime squarefree, and dyadically
`Ns ~ S`, `Nt ~ V`, `Nc ~ C`. Fix `t,c`. Their character values
have modulus at most one, so multiplication by these values contracts
the outer square-sum norm. The squarefree sieve on `s`, followed by
the triangle inequality over the `O(VC)` pairs, gives

`Y^epsilon (VC)^2 S [P + S + (PS)^(2/3)]`.                 (1)

Since `SV^2C^3 ~ Z`, `(VC)^2 S << Z` and `S << Z`.
Summing the logarithmically many norm dyads proves

`sum_a |sum_n c_n chi_a(n)|^2 << Y^epsilon Z H(P,Z)`.     (2)

No squarefree restriction remains on `n`. The factor in front is
the **length** `Z`, not an asserted unrestricted operator bound
with `sum |c_n|^2` in its place.

For the unrestricted outer argument, use the same factorization.
If `S >= V`, fix `t,c` and apply the squarefree sieve in `s` to get
`VC [S+P+(SP)^(2/3)] sum |u_b|^2`.
Here `SVC <= J`, `VC <= J^(1/3)`, and
`VC S^(2/3) <= J^(2/3)`.
If `S < V`, fix `s,c`, conjugate the cubic character on `t` if
necessary, and get `SC [V+P+(VP)^(2/3)] sum |u_b|^2`.
Now `SVC <= J`, `SC <= J^(1/3)`, and
`SC V^(2/3) <= J^(2/3)`.
These inequalities follow directly from `SV^2C^3 <= O(J)`,
`S,V,C >= 1`, and the indicated ordering. They prove the stated
outer extension. Unit factors and exact powers of `lambda` are
separated; each is a rowwise scalar or a fixed coefficient twist.
This also permits full-lattice inner coefficients in (2), after
splitting the finitely many unit classes and the logarithmically
many ramified powers on each norm dyad.

The ordinary character sieve needed at the second endpoint does not
use a cubic extension. For primitive characters modulo `r`, Gauss
expansion and orthogonality bound their square sum by
`phi(r)/Nr` times the sum over reduced additive fractions `h/r`.
Reduced fractions with denominator norms `O(Q)` are separated by
`>> Q^(-1)` on the trace-dual torus: a nonzero difference has an
integral numerator and complex denominator of size `O(Q)`.
A Schwartz majorant at radius `sqrt Z`, Poisson summation and
annular packing bound each additive Gram row by `O(Z+Q^2)`.
Indeed its kernel is bounded by
`C_A Z sum_l (1+sqrt Z |x-x'+l|)^(-A)`; summing a
`Q^(-1)`-separated planar set gives `O(Z+Q^2)`.
Thus the character bound is `(Z+Q^2) sum |c_n|^2`.
No conductor power loss has been inserted. At a bounded ramified
modulus there are only boundedly many classes. Local exponents
one and two at the coprime primes in `pq` distinguish the primitive
cubic characters, so indexing by `(p,q)` has no hidden
positive-power multiplicity.

## 2. Independent Poisson derivation of the Gram bound

Fix squarefree primary `p,p'`, `p' != p`, of norm length `P`.
Write `k=(p,p')`, `p=ka`, `p'=kb`, with
`K=Nk`, `Na,Nb ~ P/K`. The common local factors give exactly

`chi_p(n) conj(chi_p'(n)) = 1_(n,k)=1 chi_a(n) conj(chi_b(n))`.

The remaining character `psi=chi_a conj(chi_b)` is primitive modulo
`c=ab`: its nontrivial local cubic characters occur on disjoint
squarefree prime factors. It is nonprincipal, since otherwise
both `a,b` would be one and `p=p'`. This argument also covers
one of `a,b` equal to one. The general primitive Gauss evaluation used here also has an elementary
proof, so the mixed local exponents are not silently identified with
the single symbol in the cited formula (2.2). For a unit frequency,
change variables to obtain the Fourier coefficient
`conj(psi(h)) g(psi)`. For a nonunit frequency choose a unit
equal to one modulo the smaller additive conductor but with
nontrivial `psi` value; multiplication by that unit proves
the coefficient is zero. Such a unit exists because the
local character at every prime in `c` is nontrivial.
Finite additive Parseval now gives
`phi(c)|g(psi)|^2 = Nc phi(c)`.
Thus `|g(psi)|^2 = Nc`, with additive character `e(Tr(x/c))`.

Remove `1_(n,k)=1` by Mobius inversion. For `m|k`, `M=Nm`,
substitute `n=mx`. The primary condition remains `x=1 (mod 3)`
because the chosen divisor `m` is primary. Also `(m,ab)=1`,
so `psi(m)` is only a unit-modulus scalar. The radial weight
has scale `Z/M`.

For clarity, here is the complete finite Fourier calculation, not
an assumption of a varying-modulus coefficient separation. On
`O/(3c)`, the primary residue classes are `x=c+3s`, `s mod c`.
At frequency `h` the finite coefficient is

`sum_s psi(c+3s) e(Tr((c+3s)h/(3c lambda)))`

`= e(Tr(h/(3lambda))) psi(3lambda) conj(psi(h)) g(psi)`

`= e(Tr(h/(3lambda))) conj(psi(h)) g(psi)`.              (3)

For a nonunit `h mod c`, both sides of the Gauss evaluation vanish
by primitivity. For a unit, the equality follows by changing
variables in the Gauss sum. The scalar is one because
`3lambda=(-lambda)^3`. If `h=x+y omega`, then
`Tr(h/lambda)=y`, so the extra phase is simply `omega^y`;
it has fixed bounded modulus and is independent of `b`.
Changing the sign convention for Fourier transforms replaces `h`
by `-h` everywhere and changes no estimate. Formula (3) is also
the finite coefficient in the primary-coset Poisson formula
of Dunn--Radziwill v3, Section 4.

Planar Poisson now gives amplitude

`Z/(M sqrt(Nc)) ~ ZK/(MP)`

and natural frequency norm

`J0 ~ Nc M/Z ~ P^2 M/(K^2 Z)`.                          (4)

The zero frequency is zero. The radial Fourier transform depends
on the variable modulus `b` only through `Nb`, not its argument.
On a dyad `Nh ~ J`, Mellin separation in the compact scaled
variables `Nh/J` and `Nb/(P/K)` gives coefficients independent
of `b`, against a common majorant of mass
`O_A((1+J/J0)^(-A))`. This follows by repeated integration by
parts for a fixed smooth radial compactly supported weight;
its differentiated versions have the same rapid decay after
increasing `A`. The frequency character left inside the sum is
`conj(chi_a(h)) chi_b(h)`. The Gauss factor and all CRT unit
factors are outside it. Restrictions on the set of `b` may be
dropped after taking a nonnegative square sum.

Apply (2) to this frequency polynomial. The resulting squared
row contribution is at most

`(PZ)^epsilon (ZK/(MP))^2
 J [P/K + J + (PJ/K)^(2/3)] (1+J/J0)^(-A)`.           (5)

The ramified and unit splits mentioned in Section 1 do not
reintroduce row-dependent frequency coefficients. The three
powers of `J` in (5) are `1,2,5/3`. Their dyadic sums are
`O(J0^q)` for each power `q`, including `J0<1`. To see the
last point, use
`J^q(1+J/J0)^(-A) <= J0^A J^(q-A)` for `J>=1`,
then sum a geometric series and use `J0^A <= J0^q`.
For `J0>=1`, split at `J0`. This is why a spurious unsmoothed
term at natural length below one is unnecessary.

Substitute (4). The three monomials are exactly

`ZP/(MK)`, `P^2/K^2`, `P^2 Z^(1/3)/(K^2 M^(1/3))`.     (6)

They are bounded by `ZP + P^2 Z^(1/3)` because `Z,K,M>=1`.
There are divisor-boundedly many choices `k|p`, `m|k`.
The triangle/Cauchy cost in summing these choices is absorbed
by a rechoice of epsilon. Consequently

`sum_(p'!=p) |T_(p,p')|^2
 << (PZ)^epsilon [ZP + P^2 Z^(1/3)]`.                 (7)

Subsets can only decrease the left side. This proves the
manuscript's Gram lemma independently from Poisson and the
proved inner extension, rather than assuming it.

The verifier checks (3) exactly in the quotient rings of norms
28, 49 and 91, for **all** frequency residue classes there.
It uses integer polynomials modulo cyclotomic polynomials, not
floating-point complex numbers. It also checks the primitive
Gauss norm and the common-factor exclusion at norm 196.
These are adversarial finite checks of the calculation, not
the proof of the universal analytic estimate (7).

## 3. Full smooth sums, coefficient independence and missing factors

For a primitive nonprincipal finite-order Hecke character of
conductor norm `D`, the completion is

`Lambda(s,chi) = (sqrt(3D)/(2pi))^s Gamma(s) L(s,chi)`.

The functional equation and completed entireness are the imported
statements specified above. For a full smooth ideal sum of
length `Z` and twist height `t`, Mellin inversion and the
functional equation give dual dyads

`J <= Y^epsilon D(1+|t|)^2/Z`

with amplitude `Y^epsilon sqrt(Z/J)`. Here is the uniformity
point needed for averaging. Move the original contour far left,
where the dual series is absolutely convergent; Stirling and
rapid Mellin decay first discard the long dyads. Move only the
retained finite polynomials back to real part `1/2`. The
character-dependent multiplier there is a constant field-scale
phase times

`epsilon(chi) D^(i(t-tau)) Z^(i tau)
 Gamma(1/2-i(tau-t))/Gamma(1/2+i(tau-t))`.

Its absolute value is one. The remaining polynomial has character
`conj(chi)`, coefficient `Nn^(-1/2+i(tau-t))` and a fixed
smooth dyadic cutoff. Extracting `J^(-1/2)` gives the asserted
amplitude. The common Mellin majorant is integrable with mass
`Y^epsilon`; gamma poles lie to the right of this contour move.
The largest conductor gives a common permissible dyadic cutoff.
Thus Minkowski applies with the same shifts for every row.
No root number or conductor phase is placed in a polynomial
coefficient depending on its summation index.

A full ideal sum is not the same as a sum over primary ideals
prime to 3 with further deleted Euler factors. This difference
must be removed before the functional equation. Let `S` be the
primes dividing `3ve`. In a limiting unsaved sequence their
radical norm is `Y^o(1)`. Fix the parts of `p,q` at `S`
and their resulting local cubic characters. Their number,
all their divisor norms, and their multiplicities are subpower.
Outside `S`, the primitive variable character has exactly
exponents one on `p0` and two on `q0`, up to conjugation.
Its remaining local part is fixed on each class. Inclusion--
exclusion for every missing Euler factor, including the prime
above 3 when it is unramified in the primitive character,
replaces the restricted sum by full ideal sums rescaled by
subpower divisors. Their coefficient twists remain fixed.
The primitive conductor is at most `Y^(1+o(1))` or
`Y^(2/3+o(1))` in the respective configurations.

The character is nonprincipal: after removing these subpower
parts, `p0` in the first configuration, or `p0 q0` in the
second, still has positive-power norm. Its disjoint local
exponents are nonzero modulo three and cannot be cancelled by
the fixed local character. This explicitly justifies using a
pole-free full-sum functional equation.

Here the conductor assertion is derived, not inferred from a
finite-character statement with different hypotheses. On ideals
prime to 3, choose the unique primary generator. Cubic reciprocity
makes the resulting ideal character periodic at every tame
prime in the numerator's cube-free part. The supplementary
laws make its remaining dependence periodic modulo the fixed
modulus 9. Consequently it is a finite-order ray character
of modulus dividing 9 times that tame radical.
Chinese remaindering against this fixed ramified modulus
shows that a nontrivial exponent one or two at a tame
prime cannot disappear in the primitive character; each
such prime occurs to conductor exponent one. Thus the
primitive conductor outside `S` is exactly `p0 q0`,
and its remaining norm is subpower. The primitive
character's values at an unramified prime above 3 are
handled by the deleted Euler factor, not discarded.

For a full factor of exponent `a`, the other factors have
trivial total exponent at most `1-a`. The extra Mellin shifts
can be cut off below `Y^epsilon`; take this epsilon small
enough that the total height is at most `Y^(37/100)`.
At the first endpoint put `j=87/50-a`. From amplitude
`Y^(a/2) J^(-1/2)` and (2), its full contribution has upper
exponent

`E1(a) = 2-a + max(1,j,2(1+j)/3)`.

At the second endpoint a trivial dual bound gives
`|full sum| <= Y^(1/3+37/100+o(1))`, and hence

`E2(a) = 4/3 + 37/50 + 2(1-a)`.

For `19/20 <= a <= 1`, exact arithmetic gives

`E1(a) <= 7/3 - 9/100`,
`E2(a) <= 7/3 - 4/25`.                                (8)

At `a=1` these exponents are `54/25` and `311/150`.
Both are strictly below `7/3`. These calculations include
the dominant-full-sum alternative; it is not an unexamined
boundary of the subsequent simplex argument.

## 4. Faithful reduction from the prime coefficients

The coefficient class is exactly the ordered convolution in
`eq:prime-convolution`, with `k<=k0`, each prime norm at least
`Y^c`, fixed compact supports, and uniform logarithmic derivative
bounds. There is no coupled least-prime or product cutoff.
This independence is essential.

Removing the squarefree condition and replacing each prime
weight by its smooth `Lambda/log N` analogue changes a
divisor-bounded sequence only on repeated primes and prime
powers of exponent at least two. For a prime power `pi^j`
of supported norm at least `Y^c`, `j>=2`, its square divisor
`pi^floor(j/2)` has norm at least `Y^(c/4)`.
Also in the canonical decomposition `b=st^2d^3`,
`N(b/s) >= N(pi^j)^(1/2)`. The same conclusions hold for
a repeated prime of norm at least `Y^c`.
The lattice ideal count therefore bounds the discrepancy
support by `Y^(1-theta)` and its squarefree part by
`Y^(1-theta')` for some fixed positive `theta,theta'`.
For example these exponents may be decreased to absorb all
fixed logarithms; only their positivity is used.

At the first endpoint fix `q`, at subpower cost. In (1),
`SV^2C^3 ~ Y` gives `(VC)^2 S <= O(Y)` and the discrepancy
has `S <= Y^(1-theta')`. Its moment is at most

`Y^(1+o(1)) [Y + Y^(1-theta') + Y^((4-2theta')/3)]`,

which is strictly below exponent `7/3`. Fixed extra twists
and exclusions are coefficients independent of the row.
At the second endpoint, the square of a discrepancy
polynomial has support size at most `Y^(2-2theta)`,
length `Y^2`, and divisor-bounded coefficients. The
ordinary sieve with conductor norm `Y^(2/3+o(1))`
gives fourth moment `Y^(4-2theta+o(1))`. Cauchy over
`Y^(2/3+o(1))` rows gives second moment
`Y^(7/3-theta+o(1))`. Thus both discrepancies may be
removed in an unsaved sequence.

For completeness the short convolution identity is exact.
For a prime dyad with upper endpoint `F'`, let
`m=mu 1_(N<=sqrt(F'))` and let `eps` be the convolution
identity. Then `eps-m*1` vanishes up to `sqrt(F')`,
so `(eps-m*1)^2 * Lambda` vanishes up to `F'`.
Using `1*Lambda=log N` yields

`Lambda=(2m-m*m*1)*log N`                              (9)

on the dyad. Apply (9) separately to each prime factor.
Smooth partitions and Mellin inversion separate the
original weights, with subpower total mass and number
of pieces. Fixed logarithmic factors cause only the
stated derivative costs. Truncate the extra shifts
below `Y^epsilon`; arbitrary rapid decay and trivial
bounds make the tails negligible.

In this initial separation the masses and number of
pieces can in fact be bounded by fixed powers of
`log Y`: finitely many of the assumed logarithmic
derivative bounds suffice for an integrable Mellin
majorant. Fix a truncation exponent smaller than
`1/100` in advance; larger fixed derivative orders
make its tails arbitrarily small. The selected
product therefore loses only `Y^o(1)` in its
moment, not an already-fixed positive power whose
size might depend on a later copy multiplicity.
Subsequent sieve losses may be chosen after that
multiplicity is fixed. This separates the two
different uses of a small epsilon in the argument.

The exact row-independent factors after this operation
are divisor-bounded character polynomials, in number at
most `4k0`. Minkowski shows some product would retain
second-moment exponent at least `7/3` if the original
moment were unsaved. On a subsequence their lengths
have exponents `a_i>=0`, `sum a_i=1`.
Every truncated Mobius factor has exponent at most
`1/2`. Thus any factor of exponent one, or at least
`19/20`, is genuinely full, subject only to the
missing-factor removal in Section 3. This supplies
the hypothesis needed for (8), rather than assuming
a full-sum theorem for an arbitrary polynomial.

Discard individual values below `Y^(-10)` using the
trivial bounds for the other factors and the number
of rows. Dyadic value pigeonholing then gives `R`
rows with values `Y^(v_i+o(1))`, `v_i<=a_i`, and

`r + 2v >= 7/3`,  `v=sum v_i`, `r=log_Y R` in the limit. (10)

The value exponents lie in a fixed compact interval.
The same fixed shifts and fixed coefficient factors
are retained across all rows, which is indispensable
when (2) is subsequently applied to copied products.

## 5. The second exceptional configuration

Cardinality gives `r<=2/3`. The ordinary sieve on the
square of the full product gives `r+4v<=4`.
Together with (10), these force exactly

`r=2/3`, `v=5/6`.                                     (11)

The four nonnegative linear-combination certificates
for this forcing are in `exact_certificate.json`.

After excluding a full factor by (8), every `a_i<1`.
There is a positive `a_i` with `v_i>=5a_i/6`.
Indeed otherwise each positive length has strictly
negative defect `v_i-5a_i/6`, and each zero length
has nonpositive defect by the trivial value bound.
Their sum could not be zero. Repeat this factor
in the full product. Its length is `z=1+a_i` in
`(1,2)` and value at least `5z/6`.
The ordinary sieve gives

`r <= max(4/3,z)-2z/3 < 2/3`.

For `z<=4/3` the gap is `2(z-1)/3`; for `z>=4/3`
it is `(2-z)/3`. Both are strictly positive in
their stated intervals. This contradicts (11).
There is no sampled-exponent step.

## 6. The first exceptional configuration

Fix `q`, at subpower cost, so the rows are distinct
squarefree `p` of norm exponent one. Set
`d_i=v_i-5a_i/6`. For every fixed nonnegative
integer vector `k` with `z=sum k_i a_i` in `[1/2,2]`,
(2) applied to the copied product gives

`r <= 2/3 - 2 sum k_i d_i`.                           (12)

The exact identity used here is
`z+max(1,z,2(1+z)/3)=2/3+5z/3` on that whole interval.
The all-ones vector has `z=1`; its right side equals
the lower bound from (10).

Increasing the multiplicity of any factor by one
keeps `z<=2` and proves `d_i<=0`.
If `a_i<=1/2`, omitting it keeps `z>=1/2`
and proves `d_i>=0`; hence every short defect,
including every zero-length defect, is zero.
A positive short length exists: if one length is
greater than `1/2`, the positive remaining total
`1-a_i` contains a positive short length; if none
is greater than `1/2`, use `sum a_i=1`.
Take copies of this short factor until their length
lies in `[7/5,19/10)`. Its defect is zero, so (12)
gives `r<=2/3`. Then (10) forces `sum d_i>=0`.
Since every defect is nonpositive, all are zero.
Consequently

`v_i=5a_i/6` for every `i`, and `r=2/3`.                (13)

This proof uses neither positivity of the `v_i`
nor a positive lower bound for all nonzero lengths.
It is the universal `extremal_forcing` theorem
checked by Lean.

For a copied factor with length `Z=Y^(z+o(1))`,
choose a nonnegative smooth radial majorant at
least one on its fixed-ratio support.
The coefficient square norm is `Z Y^o(1)`.
For finite rows, weighted Cauchy and the elementary
Hermitian row-sum bound give

`R Y^(5z/3+o(1))
 <= Z Y^o(1) [O(Z) + max_p sum_(p'!=p) |T_(p,p')|]`.

To see this without importing an unexamined Hilbert
inequality, expand the squared norm of an arbitrary
linear combination of the row vectors and use
`2|alpha_p alpha_p'| <= |alpha_p|^2+|alpha_p'|^2`.
The absolute Gram matrix is symmetric, so its
maximum row sum bounds the quadratic form.
Duality followed by Cauchy gives the displayed
inequality. Its diagonal is `O(Z)`. By (7) and
Cauchy the off-diagonal row sum is at most
`sqrt(R) Y^o(1) sqrt(Z[Y+Y^2 Z^(-2/3)])`.
Divide by `ZR` and use (13). A necessary inequality
for an unsaved contribution would be

`2z/3 <= max(z-2/3,
 (z+max(1,2-2z/3)-2/3)/2)`.                           (14)

The diagonal gap is `(2-z)/3`. The off-diagonal
gap is `(3z-4)/6` for `z<=3/2`, and `(z-1)/6`
for `z>=3/2`. On `[7/5,19/10]` their common
lower bound is `1/30`, so (14) is impossible.

The integer choice is constructive:
`k=ceil((7/5)/a)` gives `7/5 <= ka < 7/5+a <=19/10`.
For sharpness of the common interval gap, write its
endpoints `l,u` and guaranteed gap `g`.
The necessary covering and endpoint constraints are
`u-l>=1/2`, `u+3g<=2`, and `-3l+6g<=-4`.
Adding their `<=` forms with multipliers
`1/5,1/5,1/15` gives `g<=1/30`.
The pair `l=7/5,u=19/10` attains it and also
satisfies the high-branch gap constraint.
Jacobian returned this exact primal/dual optimum;
the verifier independently replays every rational
feasibility, sign, balance and complementarity condition.
The first request's simplex-admission refusal is
preserved separately and is not mathematical evidence.

For the bounded-degree refinement, suppose there
are at most `M` factors and every length is at most
`19/20`. If there is a length exceeding `1/2`,
the other, short lengths total at least `1/20`.
If not, all lengths are short and total one.
In either case some short length is at least
`1/(20M)`. The chosen ceiling is at most `28M`.
The raising and omitting vectors and this single
copy vector therefore all have coordinates at
most `28M`. Only finitely many such vectors occur
for fixed `M`, even when some lengths approach zero.

## 7. Fixed neighborhoods, power savings and uniformity

The limiting proof is sufficient for the actual
quantifiers in the proposition, but the diagonal
argument must be spelled out. Suppose no fixed
positive neighborhood and saving work uniformly
for the stated coefficient class. Choose
`delta_j,eta_j -> 0`, and then counterexamples
with arbitrarily large `Y_j` and moment at least
`Y_j^(7/3-eta_j)`. Such arbitrarily large examples
exist if no implied constant works: for bounded
`Y` the fixed support and derivative bounds give
a uniform finite trivial bound. Choose `Y_j -> infinity`.
One exceptional configuration occurs on a subsequence.
Then `Nv,Ne=Y_j^o(1)` and its length exponents
tend to exactly that endpoint.

The prime-power error bounds, Mellin masses,
local-factor partitions and discarded tails
are uniform in the fixed data. The bounded
number of identity factors can be fixed on a
subsequence. Compactness of their length simplex
and of their pigeonholed value exponents supplies
all the real limits used above. If a length limit
is one, apply Section 3; otherwise apply the
appropriate endpoint theorem. Every selected
integer multiplicity, coefficient divisor bound
and small power loss is fixed before taking
the resulting subsequence to infinity.
Each contradiction has a strictly positive
exponent gap, so small fixed losses can be
chosen below that gap. This contradicts the
unsaved limiting moment.

Alternatively, (8) removes a fixed near-full
region. On its complement the finite-degree
refinement shows explicitly that unbounded
copy degree cannot obstruct uniformity.
Continuity on each of finitely many maximum
branches and compactness then preserve the
strict infeasibility under sufficiently small
perturbations of the conductor/length exponents.
This is not an assertion that the final saving
`eta` equals `1/30`: identity, Mellin and
neighborhood losses must still be absorbed.
It proves existence of some fixed `delta,eta>0`,
depending only on the fixed data, with precisely
the uniformity asserted in `prop:dual`.

## 8. Reproduction and limits of the certificate

Run the standalone exact replay with:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/exceptional_moments/verify.py
```

It uses only the Python standard library. The default run requires a
successful, hole-free, fresh Lean record and checks both source and
fidelity digests against that actual compiler record. The optional
`--arithmetic-only` mode is explicitly a development checkpoint, not a
universal formal certificate.

Recompile through the supported positional-source interface on this
host:

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/exceptional_moments/Main.lean --project-root . --claim C_EXPONENTS --statement-fidelity research/exceptional_moments/statement_fidelity.md
```

No Lake project was added: the prebuilt host workspace supplies
Mathlib. Lean 4.31.0 accepted the universal exponent source with
`exit_code=0`, `proof_holes=[]`. The declared main theorems use only
the standard axioms `propext`, `Classical.choice`, and `Quot.sound`.
The earlier type-error run is retained as inconclusive evidence,
not a refutation. `statement_fidelity.md` was unchanged between runs.

The source excerpts and full retrieved primary PDFs/text are under
`sources/`. Official citation attribution archives are fixed to
`research/literature/`, outside this mission's writable paths, so
no such archive was created here and the citation-attribution queue
has not been represented as cleared. The Host-invoked Reviewer must
read the actual cited propositions and the analytic bridges, and
decide statement fidelity, significance and novelty. All graph
nodes requiring such review remain open; only the algebraic claim
has mechanical support. The complete prime asymptotic, corrected
dispersion, prime decomposition outside this proposition, cutoff
removal and angular theorem remain unresolved by this mission.
