# Conditional global reflection estimate

**Engineer assessment: the all-parameter analytic implication is supported
under its declared arithmetic, representation and profile inputs.** It is
not certified by the executable identities, and is not an unconditional
verification of either manuscript. Native independent acceptance is pending.

## Exact claim and provenance

This unit covers `C_REFLECTION`, `C_REFLECTED_EXPANSION`,
`C_QUADRATIC_SIEVE`, `C_MOMENT_SUMMATION` and the historical
`C_REFLECTION_AUDIT` goal. The old draft is `REPORT.md`, Sections 3.2-5.
Its primary source is the primary manuscript's
`02a-coefficient-family.tex`, definition `reflection-B-definition` and
Proposition `reflection`, and `04-reflection.tex`, at reference revision
`4eaee87548250b2682affda7d05d947c05554bae`.
These manuscript paths are links to the assigned sources. The snapshot
preserves the old report/checker, not independent historical manuscript
copies; the analysis here is against that declared reference version.

The precise desired estimate is, for each fixed field `F` containing
`mu_12`, final fixed `S`, finite-order character `eta`, compact balanced
annular shape set `K`, every `epsilon>0`, `Z>=2` and dyadic `P,D>=1`,

```text
sum_(m in B_Z(K), P<=q_h(m)<2P, D<=q_d(m)<2D) |B_m(Z)|^2
  <<_(F,S,eta,K,epsilon) Z^epsilon P^(1/2) (D+D^2 P/Z).
```

Here `(m)_S=h d`, with `h` powerful and `d` squarefree and coprime to `h`.
The coefficient sum is over squarefree `c` and unrestricted `n`,
`A=c n^3`, with coefficient
`gamma_2(c) vartheta(A)/(q_c^(1/2) q_n)` and Gaussian `P_G(q_A/Z)`.
The factors `c,n` may share primes. Every residue power retains its
nonunit mask. The row set is `R intersect ell_(Z^M) K`, `M=1033/1000`;
nonempty dyads satisfy `PD << Z^M`. This is not a claim for arbitrary
unbalanced rows, arbitrary coefficients or varying-field constants.

## Reflected support and separation

At a valuation-one row prime the nonzero digit is compulsory. At a
powerful row prime only residue class zero permits an inactive zero digit.
If `f` is the active prime product in `h`, then `f|rad(h)` and `q_f^2<=q_h`.
The inactive factor is precisely the product of `1-1/q` over the inactive
primes; it does not ban those primes from later columns or cubes.

The common nonzero-frequency support is

```text
nu = frequency_unit * a_f * c * n^3 / (d f)^2,
(c n,d f)=1.
```

The ideal `a_f` is supported on `f` with exponents zero or one modulo
three; local vanishing coefficients are still imposed. The fixed row-unit
class and the independently summed frequency-unit class must not be
identified. The manuscript's reflected-expansion lemma (lines 625-657)
has exactly these separate indices and bounded row/column factors.

At a row prime the local exponent is one; at a squarefree column prime
the denominator `d^2` supplies exponent `-4`. Exact allowed-generator
reciprocity gives exponent `1-4=3 mod 6`, hence `chi_d(c)^3`.
Primes only in the cube have exponent zero modulo six, even at arbitrarily
large valuation; primes shared by `c,n` still have column exponent two
before the denominator contribution. Shared `d,c` gives a zero quadratic
symbol; shared `d,n` requires a separate row restriction. The latter is
not encoded by that symbol.

After fixing the finite allowed classes, substitution in the full norm-sheet
integral eliminates continuous joint row/column shape, leaving one fixed
finite family of profiles at argument
`Z q_(a_f) q_c q_n^3/(q_d^2 q_f^2)`. This uses the global automorphic
unfolding, constant-term cancellation and measure conventions assessed
in the representation unit; it does not follow from matching local phases
alone. Absolute exchanges use `sigma>1/2` and the convergent weighted
column/cube series. At an active prime the numerator majorant is

```text
E_p(sigma) =
1 + (q^(-sigma)+q^(-1/2-3sigma))/(1-q^(-1-3sigma)).
```

For `sigma>=0`, `E_p<=3+sqrt(2)` for `q>=2`. The finite-small-prime
argument bounds its product, and the sum over active products, by arbitrarily
small powers of `q_h`. Thus neither unrestricted exponents nor the number
of row primes creates an unrecorded fixed cutoff.

## Exact quadratic-sieve hypotheses

Goldmakher-Louvel, `arxiv:1112.1642v2` (31 May 2012),
Definition 1 and Theorem 1.1, pp.1-2, require a **full family** of primitive
quadratic Hecke characters of trivial infinite type, finite-class reciprocity,
and, for coprime same-class indices, primitive product of conductor exactly
their product. The p.5 convention takes the primitive inducing character
of a product. In particular condition (3) is not merely a conductor upper
bound or a reciprocity identity. This primary wording supersedes the
inaccurate old search paraphrase.

Given the allowed-generator arithmetic, attach to squarefree `c` the
primitive character of `F(sqrt(c))/F`. Its exterior conductor is exactly
`c`: odd valuations give tame conductor one, units give unramified or
trivial characters. The S-conductor divides a fixed modulus `q_S` deep
inside local squares. All infinite places are complex. Its exterior value
is the masked `chi_d(c)^3`. The class `[c]_2 in B_2` is finite homomorphic
ray-class data. For coprime `c_1,c_2` in the same class, `c_1/c_2` is
square at `S`, so the primitive product is trivial there and has conductor
exactly `c_1 c_2` globally. This verifies the difficult axiom under the
declared arithmetic input.

The full-family theorem consequently gives
`sum_d |sum_c z_c chi_d(c)^3|^2 << (C+D)(CD)^xi sum_c |z_c|^2`.
Only after this application are class slices, row deletions, column
restrictions or separate bounded factors inserted. A single slice is
not asserted to satisfy Definition 1 on its own.

## Analytic summation, not just exponent algebra

Balanced annular rows have bounded element multiplicity per ideal, by
discreteness of S-units in a fixed compact norm-one region. Counting
balanced generators in a fixed Minkowski lattice gives `O(T)` ideals
of norm at most `T`. Every powerful ideal has the unique form `r^2 s^3`
with `s` squarefree, hence there are `O(P^(1/2))` such `h` below `2P`.

For fixed `h` put
`Q=q_(a_f) q_c q_n^3`, `t_d=q_d^2 q_f^2/Z`,
`L_0=8D^2P/Z`, `R_0=Z^delta L_0`. On the discarded range `Q>R_0`,
`Q/t_d` exceeds both `Z^delta` and `L_0^(-1)`. With
`J=max(Z^delta,L_0^(-1))`, the profile gives
`|Phi(Q/t_d)| << J^(-(N-sigma))(t_d/Q)^sigma`.
The weighted ideal sums converge. Squaring after active-product summation
gives tail at most
`P^(1/2+2xi_1) D L_0^(2sigma) J^(-2(N-sigma))`.
Taking `sigma=1` and the draft's
`N=1+(A_0+2M xi_1+2(2M-1)+1)/(2delta)` makes its residual Z-exponent
`-A_0-1`. **If R_0<1, the retained range is empty and this tail estimate
bounds the whole expression.** No sieve length below one is introduced.

For `R_0>=1`, freeze `f,a_f,n` and the finite classes. On a column dyad,
the norm dependence is `Phi(v_0 exp(x))` with
`x=log(q_c/C)-2log(q_d/D)` in a fixed compact interval.
Two integrations by parts after a smooth cutoff give a uniformly bounded
Fourier L1 norm. Fourier inversion separates the row and column norms
by unitary powers. Minkowski and the large sieve then give row norm
`(D+C)^(1/2)(DC)^(xi_2/2)`, since
`sum_(q_c~C) 1/q_c=O(1)`.

The retained indicator is a column restriction after freezing; `(d,h n)=1`
only deletes rows. Summing cube weights `1/q_n` and column dyads costs
two logarithms in norm. The unrestricted `a_f` sum is controlled by
the product of `E_p(0)`. Square for each `h`, then count `h`; do not
take a triangle inequality across the powerful ideals. The result is

```text
retained mass << P^(1/2+2xi_1) log^4(2R_0) (D+R_0)(D R_0)^xi_2.
```

For `t=min(epsilon,1)`, choose
`delta=t/16`, `xi_1=t/(32M)`,
`xi_2=t/(16(3M+1))`, `xi_3=t/16`.
The bounds `D+R_0 << Z^delta(D+D^2P/Z)`,
`D R_0 << Z^(3M-1+delta)` and
`log^4(2R_0) << Z^xi_3` give loss
`delta+2M xi_1+(3M-1+delta)xi_2+xi_3`.
Its gap below `t/4` is `t(32-t)/(256(3M+1))>0`.
This supplies every positive epsilon, not a few numerical choices.
The total dyadic sum is bounded by `Z^(2M-1+epsilon)`, because
`M>1` and there are only logarithmically many nonempty dyads.

## Evidence, limits and exact disposition

The successful replay recorded in `../local-normalization/replay.json`
checks the loss and tail identities as well as local algebra. It does
**not** check the counting, profile estimates, Fourier separation, Hecke
family construction, infinite exchanges or large sieve. Those implications
were assessed in prose above against the exact source hypotheses.

No separate new analytic gap was found in the summation **given the stated
inputs**. The precise remaining unconditional obligation is to realize,
with compatible additive/lift conventions, the generator complement,
Gauss correction characters and fixed profile/Whittaker expansion whose
properties were just used. The representation report spells out the
localization and global-compatibility premises rather than treating missing
access as a mathematical disproof. Independently attributing the imported
sources and reading this assembly remain native review obligations.

This is a conditional verification/reproduction of the supplied reduction,
not a new bound, a refuted manuscript, a proof of zero-freeness or a
publishable novelty claim. It is the strongest mathematically justified
reading of the old argument, narrower than unconditional closure of
`C_REFLECTION` and far narrower than either primitive-root main theorem.
