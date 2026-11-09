import Mathlib

noncomputable section

open scoped BigOperators

namespace LatentRadicals

abbrev RootPolynomial (σ : Type*) := MvPolynomial σ (ZMod 2)

abbrev RootField (σ : Type*) := FractionRing (RootPolynomial σ)

def squareSubfield (σ : Type*) : Subfield (RootField σ) :=
  (frobenius (RootField σ) 2).fieldRange

abbrev SquarefreeExponent (σ : Type*) :=
  { d : σ →₀ ℕ // ∀ i, d i < 2 }

def radical {σ : Type*} (d : SquarefreeExponent σ) : RootField σ :=
  algebraMap (RootPolynomial σ) (RootField σ) (MvPolynomial.monomial d.val 1)

def root {σ : Type*} (i : σ) : RootField σ :=
  algebraMap (RootPolynomial σ) (RootField σ) (MvPolynomial.X i)

def squareVariable {σ : Type*} (i : σ) : squareSubfield σ :=
  ⟨root i ^ 2, RingHom.mem_fieldRange.mpr ⟨root i, rfl⟩⟩

theorem mem_squareSubfield_iff {σ : Type*} (z : RootField σ) :
    z ∈ squareSubfield σ ↔ ∃ q : RootField σ, q ^ 2 = z :=
  Iff.rfl

theorem even_add_squarefree_injective {σ : Type*} {a b u v : σ →₀ ℕ}
    (hu : ∀ i, u i < 2) (hv : ∀ i, v i < 2)
    (h : 2 • a + u = 2 • b + v) : a = b ∧ u = v := by
  have hpoint (i : σ) : a i = b i ∧ u i = v i := by
    have he := DFunLike.congr_fun h i
    simp only [Finsupp.add_apply, Finsupp.smul_apply, smul_eq_mul] at he
    have hui := hu i
    have hvi := hv i
    omega
  exact ⟨Finsupp.ext (fun i => (hpoint i).1), Finsupp.ext (fun i => (hpoint i).2)⟩

theorem coeff_expand_mul_squarefree {σ R : Type*} [CommSemiring R] [DecidableEq σ]
    (u v : SquarefreeExponent σ) (m : σ →₀ ℕ) (p : MvPolynomial σ R) :
    (MvPolynomial.expand 2 p * MvPolynomial.monomial v.val 1).coeff (2 • m + u.val) =
      if u = v then p.coeff m else 0 := by
  classical
  induction p using MvPolynomial.induction_on' with
  | monomial a c =>
      simp only [MvPolynomial.expand_monomial, MvPolynomial.monomial_mul, mul_one,
        MvPolynomial.coeff_monomial]
      by_cases huv : u = v
      · subst v
        have he : (2 • a + u.val = 2 • m + u.val) ↔ a = m := by
          constructor
          · intro h
            exact (even_add_squarefree_injective u.property u.property h).1
          · rintro rfl
            rfl
        simp [he]
      · have he : 2 • a + v.val ≠ 2 • m + u.val := by
          intro h
          exact huv (Subtype.ext
            (even_add_squarefree_injective v.property u.property h).2.symm)
        simp only [if_neg huv, if_neg he]
  | add p q hp hq =>
      simp only [map_add, add_mul, MvPolynomial.coeff_add, hp, hq]
      split_ifs <;> simp

theorem polynomial_parity_separation {σ ι R : Type*} [CommSemiring R]
    (d : ι → SquarefreeExponent σ) (hd : Function.Injective d)
    (s : Finset ι) (p : ι → MvPolynomial σ R)
    (h : ∑ i ∈ s, MvPolynomial.expand 2 (p i) * MvPolynomial.monomial (d i).val 1 = 0) :
    ∀ i ∈ s, p i = 0 := by
  classical
  intro i hi
  ext m
  have hc := congrArg (MvPolynomial.coeff (2 • m + (d i).val)) h
  rw [MvPolynomial.coeff_sum, MvPolynomial.coeff_zero] at hc
  have hs : (∑ j ∈ s,
      (MvPolynomial.expand 2 (p j) * MvPolynomial.monomial (d j).val 1).coeff
        (2 • m + (d i).val)) = (p i).coeff m := by
    rw [Finset.sum_eq_single i]
    · rw [coeff_expand_mul_squarefree]
      simp
    · intro j hj hji
      rw [coeff_expand_mul_squarefree]
      have hne : d i ≠ d j := fun h => hji (hd h).symm
      simp only [if_neg hne]
    · exact fun hni => (hni hi).elim
  exact hs.symm.trans hc

theorem polynomial_square_separation {σ ι : Type*}
    (d : ι → SquarefreeExponent σ) (hd : Function.Injective d)
    (s : Finset ι) (p : ι → RootPolynomial σ)
    (h : ∑ i ∈ s, (p i) ^ 2 * MvPolynomial.monomial (d i).val 1 = 0) :
    ∀ i ∈ s, p i = 0 :=
  polynomial_parity_separation d hd s p (by
    simpa only [MvPolynomial.expand_zmod] using h)

theorem squarefree_linearIndependent (σ : Type*) :
    LinearIndependent (squareSubfield σ) (radical (σ := σ)) := by
  classical
  apply linearIndependent_iff'.2
  intro s c hrel i hi
  let P := RootPolynomial σ
  let F := RootField σ
  let emb : P →+* F := algebraMap P F
  have hroots : ∀ d : SquarefreeExponent σ, ∃ q : F, q ^ 2 = (c d : F) := by
    intro d
    exact RingHom.mem_fieldRange.mp (c d).property
  choose q hq using hroots
  obtain ⟨a, ha⟩ :=
    IsLocalization.exist_integer_multiples (nonZeroDivisors P) s q
  have ha' : ∀ d ∈ s, ∃ p : P, emb p = emb (a : P) * q d := by
    intro d hd
    obtain ⟨p, hp⟩ := ha d hd
    exact ⟨p, by simpa only [Algebra.smul_def] using hp⟩
  choose! p hp using ha'
  have hzero : ∑ d ∈ s, (p d) ^ 2 * MvPolynomial.monomial d.val 1 = 0 := by
    apply IsFractionRing.injective P F
    rw [map_zero, map_sum]
    calc
      (∑ d ∈ s, emb ((p d) ^ 2 * MvPolynomial.monomial d.val 1)) =
          emb (a : P) ^ 2 * ∑ d ∈ s, c d • radical d := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro d hd
        rw [map_mul, map_pow, hp d hd, mul_pow, hq d]
        change ((emb (a : P)) ^ 2 * (c d : F)) *
            emb (MvPolynomial.monomial d.val 1) =
          (emb (a : P)) ^ 2 * ((c d : F) * emb (MvPolynomial.monomial d.val 1))
        exact mul_assoc _ _ _
      _ = 0 := by rw [hrel, mul_zero]
  have hpi : p i = 0 :=
    polynomial_square_separation id Function.injective_id s p hzero i hi
  have hmult : emb (a : P) * q i = 0 := by
    rw [← hp i hi, hpi, map_zero]
  have hane : emb (a : P) ≠ 0 :=
    (map_ne_zero_iff emb (IsFractionRing.injective P F)).mpr
      (nonZeroDivisors.coe_ne_zero a)
  have hqi : q i = 0 := (mul_eq_zero.mp hmult).resolve_left hane
  apply Subtype.ext
  change (c i : F) = 0
  rw [← hq i, hqi, zero_pow (by decide)]

def tripleExponent {r : ℕ} (t : Fin r × Fin r × Fin r) :
    SquarefreeExponent (Fin 3 × Fin r) :=
  ⟨Finsupp.single (0, t.1) 1 + Finsupp.single (1, t.2.1) 1 +
      Finsupp.single (2, t.2.2) 1, by
    rintro ⟨row, col⟩
    fin_cases row <;> simp [Finsupp.single_apply, Prod.mk.injEq] <;>
      split_ifs <;> omega⟩

theorem tripleExponent_injective (r : ℕ) :
    Function.Injective (tripleExponent (r := r)) := by
  intro t u h
  have he := congrArg Subtype.val h
  have h0 : t.1 = u.1 := by
    by_contra hne
    have ht := DFunLike.congr_fun he (0, t.1)
    simp [tripleExponent, Prod.mk.injEq, Ne.symm hne] at ht
  have h1 : t.2.1 = u.2.1 := by
    by_contra hne
    have ht := DFunLike.congr_fun he (1, t.2.1)
    simp [tripleExponent, Prod.mk.injEq, Ne.symm hne] at ht
  have h2 : t.2.2 = u.2.2 := by
    by_contra hne
    have ht := DFunLike.congr_fun he (2, t.2.2)
    simp [tripleExponent, Prod.mk.injEq, Ne.symm hne] at ht
  exact Prod.ext h0 (Prod.ext h1 h2)

def tripleRadical {r : ℕ} (t : Fin r × Fin r × Fin r) :
    RootField (Fin 3 × Fin r) :=
  root (0, t.1) * root (1, t.2.1) * root (2, t.2.2)

theorem radical_tripleExponent {r : ℕ} (t : Fin r × Fin r × Fin r) :
    radical (tripleExponent t) = tripleRadical t := by
  unfold radical tripleExponent tripleRadical root
  rw [← map_mul, ← map_mul]
  congr 1
  simp only [MvPolynomial.X, MvPolynomial.monomial_mul, mul_one]

theorem triple_linearIndependent (r : ℕ) :
    LinearIndependent (squareSubfield (Fin 3 × Fin r)) (tripleRadical (r := r)) := by
  have h := (squarefree_linearIndependent (Fin 3 × Fin r)).comp
    (tripleExponent (r := r)) (tripleExponent_injective r)
  simpa only [Function.comp_def, radical_tripleExponent] using h

theorem tripleRadical_sq {r : ℕ} (t : Fin r × Fin r × Fin r) :
    tripleRadical t ^ 2 =
      (squareVariable ((0 : Fin 3), t.1) : RootField (Fin 3 × Fin r)) *
        (squareVariable ((1 : Fin 3), t.2.1) : RootField (Fin 3 × Fin r)) *
        (squareVariable ((2 : Fin 3), t.2.2) : RootField (Fin 3 × Fin r)) := by
  simp only [tripleRadical, mul_pow, squareVariable]

#print axioms squarefree_linearIndependent
#print axioms triple_linearIndependent
#print axioms tripleRadical_sq

end LatentRadicals
