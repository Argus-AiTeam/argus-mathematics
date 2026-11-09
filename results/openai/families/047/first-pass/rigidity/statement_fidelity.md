# Statement fidelity: campaign 9000047 polynomial-orbit core

## Scope and ledger relationship

`research/rigidity/Main.lean` formalizes the decisive polynomial-orbit core of
`C_RIGIDITY047`, rational-function nonsquareness over the original kind of
coefficient field, and two determinant coefficient identities. It is **not**
a full formalization of arbitrary locally nilpotent derivations, gradings,
highest auxiliary components, localization/coefficient intersection, or
cancellation. No assertion about full cancellation, novelty, or Reviewer
acceptance is made.

The natural-language claim `C_RIGIDITY047` remains the homogeneous-derivation
rigidity claim in `CTX_RIGIDITY047`. Its explicit external assumption
`A_PROSE_BRIDGE047` must remain: the passage from that claim to this
polynomial-orbit problem, together with the determinant-ring domain/chart and
localization-intersection arguments, is prose rather than Lean. Attaching
this formal file records exactly this core, not a fully formal proof of the
entire natural-language claim.

## All declarations

All seven declarations below are in namespace `Rigidity047`.

1. **`determinant_coefficients`**: for any commutative ring `R` and elements
   `a d b c x y`, from `a*c-b*d=1` and `a*y=d*x`, proves
   `a*(c*x-b*y)=x` and `d*(c*x-b*y)=y`. This needs no field or domain
   hypothesis and does not by itself prove a localization-intersection
   assertion.

2. **`ratFunc_neg_X_cube_not_square`**: for every field `F`, proves
   `¬ IsSquare (-(RatFunc.X : RatFunc F)^3)`. This is stronger than the
   requested characteristic-zero statement. The proof uses the actual
   rational-function integer degree: a nonzero square has degree twice an
   integer, whereas `-X^3` has degree three. There is no algebraic-closure
   hypothesis.

3. **`low_degree_coprime`**: for a field `K` and `A D U : K[X]`, assuming
   `D ≠ 0`, `D^2+A^2*U^3 ≠ 0`, and
   `(D^2+A^2*U^3).natDegree ≤ 1`, proves `IsCoprime D (A*U)`.
   If `g = gcd D (A*U)`, then `g^2` divides the displayed nonzero sum.
   The degree bound forces `g.natDegree=0`, hence `g` is a unit.
   Coprimality is therefore derived, not assumed.

4. **`radical_mul_degree_le`**: for all field polynomials `P Q`, proves
   `natDegree(radical(P*Q)) ≤ natDegree(radical P)+natDegree(radical Q)`
   using radical divisibility and nonvanishing.

5. **`orbit_radical_degree_le`**: for all field polynomials `A D U N`, proves
   `natDegree(radical(D^2*(A^2*U^3)*(-N)))`
   `≤ D.natDegree+A.natDegree+U.natDegree+N.natDegree`.
   It uses the preceding radical bound, invariance under positive powers
   and negation, and `natDegree(radical P) ≤ P.natDegree`.

6. **`orbit_polynomials_constant`**: for **any characteristic-zero field**
   `K`, nonzero `A D U : K[X]`, and `u0 : K`, assuming only
   ```
   U.eval 0 = u0
   ¬ IsSquare (-u0^3)
   D^2+A^2*U^3 ≠ 0
   (D^2+A^2*U^3).natDegree ≤ 1,
   ```
   proves
   ```
   A.natDegree = 0 ∧ D.natDegree = 0 ∧ U.natDegree = 0.
   ```
   These conclusions say that all three polynomials are constant. The
   theorem does **not** assume orbit constancy, vanishing of a derivation,
   coprimality, or any numerical polynomial-abc inequality.

   Its proof invokes the proved Mathlib theorem `Polynomial.abc`, imported
   from `Mathlib.NumberTheory.FLT.MasonStothers`, on
   `D^2`, `A^2*U^3`, and `-(D^2+A^2*U^3)`. Coprimality comes from
   `low_degree_coprime`. In the derivative-zero branch, characteristic zero
   implies that the degrees vanish. In the degree-bound branch,
   Mason--Stothers and the radical bound force `U.natDegree=0` and
   `D.natDegree=A.natDegree`. Thus `U=C u0`. Cancellation of the two leading
   coefficients would make
   `-u0^3 = (D.leadingCoeff/A.leadingCoeff)^2`, contrary to nonsquareness.
   Their sum therefore has the same degree as `D^2`; the assumed degree
   bound then forces both remaining degrees to be zero.

7. **`ratFunc_orbit_polynomials_constant`**: for any characteristic-zero
   field `F` and nonzero `A D U : (RatFunc F)[X]`, assuming
   ```
   U.eval 0 = RatFunc.X
   D^2+A^2*U^3 ≠ 0
   (D^2+A^2*U^3).natDegree ≤ 1,
   ```
   proves that the three natural degrees are zero. This applies the two
   main theorems without a supplied nonsquareness assumption. Taking
   `F = C(a,d,b)` gives the intended coefficient field `F(u)`, with
   `RatFunc.X` representing `u`. This mathematical identification is not a
   formal determinant-ring/fraction-field construction in this file.

## Formal trust boundary

The source contains no new axioms or proof placeholders and uses Mathlib's
proved Mason--Stothers theorem, rather than a postulated abc bound.
Classical choice is used for ordinary field-polynomial gcd/radical
instances; it is not an algebraic-closure assumption. Lean certification
checks the displayed universal theorems and their auxiliary lemmas.
It does not discharge `A_PROSE_BRIDGE047` or certify the unformalized
derivation-to-orbit bridge.
