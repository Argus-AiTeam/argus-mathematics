# Biquadratic algebra: statement fidelity

`Biquadratic.lean` is standalone (`import Mathlib`), in namespace
`LSBiquadratic`. Both requested priorities are proved. The public divisibility
theorems require only a commutative ring, not an integral domain, maximal order,
or embedding into a field. In the signatures below, `[Fact p.Prime]` supplies
the primality hypothesis. Every coefficient tuple is an arbitrary element of
`Fin 4 → ℤ`; in particular negative coefficients and negative `d` are allowed.

## Coordinates

The definitions, with all integer coefficients cast into the ambient ring, are

```text
theta          = n₀ + n₁ a + n₂ b + n₃ ab
sigmaTheta     = n₀ - n₁ a + n₂ b - n₃ ab
sigmaTauTheta  = n₀ - n₁ a - n₂ b + n₃ ab
signedTheta s  = n₀ - n₁ a + s n₂ b - s n₃ ab.
```

Thus `signedTheta 1 = sigmaTheta` and
`signedTheta (-1) = sigmaTauTheta`.

## Priority A: exact public signatures

All names below are in `LSBiquadratic`.

```lean
theorem prime_dvd_theta_sub_signedTheta
    {R : Type*} [CommRing R] (p : ℕ) [Fact p.Prime]
    (hp2 : p ≠ 2) (d : ℤ) (a b : R)
    (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (n : Fin 4 → ℤ) :
    (p : R) ∣ theta a b n ^ p - signedTheta a b (legendreSym p 2) n

theorem prime_dvd_theta_sub_sigmaTheta
    {R : Type*} [CommRing R] (p : ℕ) [Fact p.Prime]
    (hp2 : p ≠ 2) (d : ℤ) (a b : R)
    (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (h2 : legendreSym p 2 = 1)
    (n : Fin 4 → ℤ) :
    (p : R) ∣ theta a b n ^ p - sigmaTheta a b n

theorem prime_dvd_theta_sub_sigmaTauTheta
    {R : Type*} [CommRing R] (p : ℕ) [Fact p.Prime]
    (hp2 : p ≠ 2) (d : ℤ) (a b : R)
    (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (h2 : legendreSym p 2 = -1)
    (n : Fin 4 → ℤ) :
    (p : R) ∣ theta a b n ^ p - sigmaTauTheta a b n

theorem not_dvd_of_legendre_neg_one
    (p : ℕ) [Fact p.Prime] (d : ℤ)
    (hd : legendreSym p d = -1) :
    ¬(p : ℤ) ∣ d

theorem legendre_two_eq_one_or_neg_one
    (p : ℕ) [Fact p.Prime] (hp2 : p ≠ 2) :
    legendreSym p 2 = 1 ∨ legendreSym p 2 = -1
```

There is **no assumed Frobenius or generator congruence** in these signatures.
The proof uses Mathlib's actual Euler-criterion theorem `legendreSym.eq_pow`,
not a replacement half-power hypothesis. Its generator consequence is:

```lean
theorem root_pow_eq_legendre_mul
    {R : Type*} [CommRing R] (p : ℕ) [Fact p.Prime] [CharP R p]
    (hp2 : p ≠ 2) (d : ℤ) (a : R) (ha : a ^ 2 = (d : R)) :
    a ^ p = (legendreSym p d : R) * a

theorem theta_pow_eq_signedTheta
    {R : Type*} [CommRing R] (p : ℕ) [Fact p.Prime] [CharP R p]
    (hp2 : p ≠ 2) (d : ℤ) (a b : R)
    (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (n : Fin 4 → ℤ) :
    theta a b n ^ p = signedTheta a b (legendreSym p 2) n
```

Euler's criterion is transported by the canonical ring homomorphism
`ZMod p →+* R` in characteristic `p`. Oddness gives
`p = 2 * (p / 2) + 1`; the quadratic equations then give the generator powers.
The Frobenius ring homomorphism fixes every integer coefficient.

For general `R`, the proof reduces modulo `Ideal.span {(p : R)}`. If this
quotient is subsingleton, the required equality is automatic. Otherwise,
primality and the vanishing of `p` give `CharP` on the quotient. The
characteristic-`p` equality is then converted back to divisibility by `p`.
Neither primality of that ideal nor any ideal factorization is asserted.

## Priority B: explicit projection and exact signatures

The definitions are

```lean
def basisVector (a b : ℂ) : Fin 4 → ℂ := ![1, a, b, a * b]
def kernelVector (a b : ℂ) : Fin 4 → ℂ := ![a * b, b, -a, -1]

-- This is a genuine complex-linear map, defined explicitly in the source:
conjugateProjection (a b : ℂ) :
  (Fin 4 → ℂ) →ₗ[ℂ] (Fin 3 → ℂ)
```

Its three rows are exactly `[1,a,b,ab]`, `[1,-a,b,-ab]`,
and `[1,-a,-b,ab]`. Surjectivity is proved using the preimage

```text
x = ((y₀+y₂)/2, (y₀-y₁)/(2a), (y₁-y₂)/(2b), 0).
```

The kernel proof explicitly obtains `x = (-x₃) • kernelVector a b`.

```lean
theorem conjugateProjection_int (a b : ℂ) (n : Fin 4 → ℤ) :
    conjugateProjection a b (fun i => (n i : ℂ)) =
      ![theta a b n, sigmaTheta a b n, sigmaTauTheta a b n]

theorem conjugateProjection_kernelVector (a b : ℂ) :
    conjugateProjection a b (kernelVector a b) = 0

theorem conjugateProjection_surjective
    (a b : ℂ) (ha : a ≠ 0) (hb : b ≠ 0) :
    Function.Surjective (conjugateProjection a b)

theorem conjugateProjection_eq_zero_iff
    (a b : ℂ) (ha : a ≠ 0) (hb : b ≠ 0) (x : Fin 4 → ℂ) :
    conjugateProjection a b x = 0 ↔
      ∃ t : ℂ, x = t • kernelVector a b

theorem conjugateProjection_ker
    (a b : ℂ) (ha : a ≠ 0) (hb : b ≠ 0) :
    LinearMap.ker (conjugateProjection a b) =
      Submodule.span ℂ {kernelVector a b}

theorem linearIndependent_kernelVector_iff (a b : ℂ) :
    LinearIndependent ℚ (kernelVector a b) ↔
      LinearIndependent ℚ (basisVector a b)

theorem kernelVector_rationally_independent (a b : ℂ)
    (h : LinearIndependent ℚ (![1, a, b, a * b] : Fin 4 → ℂ)) :
    LinearIndependent ℚ (kernelVector a b)

theorem explicit_projection_data
    (a b : ℂ) (ha : a ≠ 0) (hb : b ≠ 0)
    (h : LinearIndependent ℚ (![1, a, b, a * b] : Fin 4 → ℂ)) :
    Function.Surjective (conjugateProjection a b) ∧
      (∀ x, conjugateProjection a b x = 0 ↔
        ∃ t : ℂ, x = t • kernelVector a b) ∧
      LinearIndependent ℚ (kernelVector a b)
```

The independence equivalence is unconditional: reversal of the four entries
and rational unit signs suffice. Only the surjectivity and kernel-line
description need the nonvanishing hypotheses on `a,b`. The final conjunction
has exactly the three projection/kernel hypotheses needed by the interpolation
construction.

## Unproved optional implication, separately

The implication from squarefree integer `d ≠ 1,2` and the complex quadratic
equations to rational independence of `[1,a,b,ab]` is **not formalized here**.
The basis-independence hypothesis is explicit, as permitted. No algebraic
number field, analytic conductor, character, or ideal-factorization result is
claimed. There is no unproved Legendre-to-congruence implication.

## Verification

The required direct compile command was run:

```sh
cd $WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0 &&
$WORKSPACE/.elan/bin/lake env lean \
  families/003/first-pass/ls-uniform-determinant-core/Biquadratic.lean
```

**Actual compiler exit: 0.** Compiler version: Lean 4.31.0, commit
`68218e876d2a38b1985b8590fff244a83c321783`.

`biquadratic_compile.log` records the direct compilation.
`biquadratic_axioms.log` records an additional successful compilation of the
same source through standard input with signature and axiom queries appended.
The queried main results depend only on Lean's standard
`propext`, `Classical.choice`, and `Quot.sound` axioms. No `sorry`, `admit`,
`sorryAx`, or custom axiom is used.
