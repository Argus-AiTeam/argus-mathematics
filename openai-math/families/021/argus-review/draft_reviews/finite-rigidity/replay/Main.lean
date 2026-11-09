import Mathlib

open Finset

noncomputable section

namespace PartialIncidence

attribute [local instance] Classical.propDecidable

variable {Point Cell PrimeIndex : Type*}

def rowCount (X : Finset Point) (rel : Cell → Point → Prop) (c : Cell) : ℕ := by
  classical
  exact (X.filter (rel c)).card

def mass (C : Finset Cell) (X : Finset Point) (rel : Cell → Point → Prop) : ℕ :=
  ∑ c ∈ C, rowCount X rel c

def overlap (C : Finset Cell) (rel : Cell → Point → Prop) (x y : Point) : ℕ := by
  classical
  exact (C.filter (fun c => rel c x ∧ rel c y)).card

theorem transpose_mass (C : Finset Cell) (X : Finset Point)
    (rel : Cell → Point → Prop) :
    (∑ x ∈ X, rowCount C (fun x c => rel c x) x) = mass C X rel := by
  classical
  simp only [rowCount, mass, Finset.card_filter]
  exact Finset.sum_comm

theorem row_square (X : Finset Point) (rel : Cell → Point → Prop) (c : Cell) :
    rowCount X rel c ^ 2 =
      ∑ x ∈ X, ∑ y ∈ X, if rel c x ∧ rel c y then 1 else 0 := by
  classical
  simp only [rowCount, Finset.card_filter, pow_two, Finset.sum_mul, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro x hx
  apply Finset.sum_congr rfl
  intro y hy
  split_ifs <;> simp_all

theorem energy_identity (C : Finset Cell) (X : Finset Point)
    (rel : Cell → Point → Prop) :
    (∑ c ∈ C, rowCount X rel c ^ 2) =
      ∑ x ∈ X, ∑ y ∈ X, overlap C rel x y := by
  classical
  simp_rw [row_square]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro x hx
  rw [Finset.sum_comm]
  simp only [overlap, Finset.card_filter]

theorem energy_bound (C : Finset Cell) (X : Finset Point)
    (rel : Cell → Point → Prop) (B : ℕ)
    (hpair : ∀ x ∈ X, ∀ y ∈ X, x ≠ y → overlap C rel x y ≤ B) :
    (∑ c ∈ C, rowCount X rel c ^ 2) ≤
      B * X.card * (X.card - 1) + mass C X rel := by
  classical
  rw [energy_identity]
  calc
    (∑ x ∈ X, ∑ y ∈ X, overlap C rel x y) ≤
        ∑ x ∈ X, (B * (X.card - 1) +
          rowCount C (fun x c => rel c x) x) := by
      apply Finset.sum_le_sum
      intro x hx
      rw [← Finset.sum_erase_add X (fun y => overlap C rel x y) hx]
      have hdiag : overlap C rel x x =
          rowCount C (fun x c => rel c x) x := by
        simp [overlap, rowCount]
      rw [hdiag]
      apply Nat.add_le_add_right
      calc
        (∑ y ∈ X.erase x, overlap C rel x y) ≤ ∑ _y ∈ X.erase x, B := by
          apply Finset.sum_le_sum
          intro y hy
          exact hpair x hx y (Finset.mem_of_mem_erase hy)
            (Ne.symm (Finset.ne_of_mem_erase hy))
        _ = B * (X.card - 1) := by simp [Finset.card_erase_of_mem hx, Nat.mul_comm]
    _ = B * X.card * (X.card - 1) + mass C X rel := by
      rw [Finset.sum_add_distrib, transpose_mass]
      simp only [Finset.sum_const, nsmul_eq_mul, Nat.cast_id]
      ring

theorem partial_collision_bound (C : Finset Cell) (X : Finset Point)
    (rel : Cell → Point → Prop) (B : ℕ)
    (hpair : ∀ x ∈ X, ∀ y ∈ X, x ≠ y → overlap C rel x y ≤ B) :
    mass C X rel ^ 2 ≤
      C.card * (B * X.card * (X.card - 1) + mass C X rel) := by
  have hCS := Finset.sum_mul_sq_le_sq_mul_sq C (fun _ => (1 : ℕ))
    (rowCount X rel)
  have hCS' : mass C X rel ^ 2 ≤
      C.card * (∑ c ∈ C, rowCount X rel c ^ 2) := by
    simpa [mass] using hCS
  exact hCS'.trans (Nat.mul_le_mul_left _ (energy_bound C X rel B hpair))

theorem partial_collision_bound_loose (C : Finset Cell) (X : Finset Point)
    (rel : Cell → Point → Prop) (B : ℕ)
    (hpair : ∀ x ∈ X, ∀ y ∈ X, x ≠ y → overlap C rel x y ≤ B) :
    mass C X rel ^ 2 ≤ C.card * (B * X.card ^ 2 + mass C X rel) := by
  have h := partial_collision_bound C X rel B hpair
  have hN : X.card - 1 ≤ X.card := Nat.sub_le _ _
  calc
    mass C X rel ^ 2 ≤ C.card * (B * X.card * (X.card - 1) + mass C X rel) := h
    _ ≤ C.card * (B * X.card ^ 2 + mass C X rel) := by
      apply Nat.mul_le_mul_left C.card
      apply Nat.add_le_add_right
      simpa [pow_two, Nat.mul_assoc] using Nat.mul_le_mul_left (B * X.card) hN

theorem degree_le (C : Finset Cell) (X : Finset Point)
    (rel : Cell → Point → Prop) :
    mass C X rel ≤ C.card * X.card := by
  classical
  calc
    mass C X rel ≤ ∑ _c ∈ C, X.card := by
      exact Finset.sum_le_sum (fun c hc => Finset.card_le_card (Finset.filter_subset _ _))
    _ = C.card * X.card := by simp

theorem point_cover_bound [DecidableEq PrimeIndex]
    (P A E : Finset PrimeIndex) (C : Finset Cell)
    (primeOf : Cell → PrimeIndex) (full : PrimeIndex → Prop) (rel : Cell → Prop)
    (hcover : ∀ p ∈ P, full p → p ∈ A ∨ p ∈ E ∨
      ∃ c ∈ C, primeOf c = p ∧ rel c) :
    (P.filter full).card ≤ A.card + E.card + (C.filter rel).card := by
  classical
  have hsub : P.filter full ⊆ A ∪ E ∪ (C.filter rel).image primeOf := by
    intro p hp
    obtain hpP := (Finset.mem_filter.mp hp).1
    obtain hpF := (Finset.mem_filter.mp hp).2
    rcases hcover p hpP hpF with ha | he | ⟨c, hc, hcp, hcr⟩
    · simp [ha]
    · simp [he]
    · apply Finset.mem_union.mpr
      right
      exact Finset.mem_image.mpr ⟨c, Finset.mem_filter.mpr ⟨hc, hcr⟩, hcp⟩
  calc
    (P.filter full).card ≤ (A ∪ E ∪ (C.filter rel).image primeOf).card :=
      Finset.card_le_card hsub
    _ ≤ (A ∪ E).card + ((C.filter rel).image primeOf).card := Finset.card_union_le _ _
    _ ≤ A.card + E.card + (C.filter rel).card :=
      Nat.add_le_add (Finset.card_union_le _ _) (Finset.card_image_le)

theorem partial_incidence_forces_alignment [DecidableEq PrimeIndex]
    (P A E : Finset PrimeIndex) (C : Finset Cell) (X : Finset Point)
    (primeOf : Cell → PrimeIndex) (full : PrimeIndex → Point → Prop)
    (rel : Cell → Point → Prop) (B r t : ℕ)
    (hpair : ∀ x ∈ X, ∀ y ∈ X, x ≠ y → overlap C rel x y ≤ B)
    (hcover : ∀ x ∈ X, ∀ p ∈ P, full p x → p ∈ A ∨ p ∈ E ∨
      ∃ c ∈ C, primeOf c = p ∧ rel c x)
    (hrich : ∀ x ∈ X, r ≤ rowCount P (fun x p => full p x) x)
    (hbudget : mass C X rel ≤ P.card * X.card)
    (hgap : E.card + t ≤ r)
    (hmargin : C.card * (B * X.card ^ 2 + P.card * X.card) <
      ((r - E.card - t) * X.card) ^ 2) :
    t < A.card := by
  classical
  by_contra hA
  have hAt : A.card ≤ t := Nat.le_of_not_gt hA
  have hlower : r * X.card ≤
      ∑ x ∈ X, rowCount P (fun x p => full p x) x := by
    calc
      r * X.card = ∑ _x ∈ X, r := by simp [Nat.mul_comm]
      _ ≤ _ := Finset.sum_le_sum hrich
  have hupper : (∑ x ∈ X, rowCount P (fun x p => full p x) x) ≤
      (A.card + E.card) * X.card + mass C X rel := by
    calc
      _ ≤ ∑ x ∈ X, (A.card + E.card + rowCount C (fun x c => rel c x) x) := by
        apply Finset.sum_le_sum
        intro x hx
        exact point_cover_bound P A E C primeOf (fun p => full p x)
          (fun c => rel c x) (hcover x hx)
      _ = _ := by
        rw [Finset.sum_add_distrib, transpose_mass]
        simp [Nat.mul_comm]
  have hr : r - E.card - t + E.card + t = r := by omega
  have hsmall : (r - E.card - t) * X.card ≤ mass C X rel := by
    nlinarith [Nat.mul_le_mul_right X.card hAt]
  have hsq := Nat.pow_le_pow_left hsmall 2
  have hcollision := partial_collision_bound_loose C X rel B hpair
  have hbound : mass C X rel ^ 2 ≤
      C.card * (B * X.card ^ 2 + P.card * X.card) :=
    hcollision.trans (Nat.mul_le_mul_left _ (Nat.add_le_add_left hbudget _))
  exact (not_lt_of_ge (hsq.trans hbound)) hmargin

theorem fixed_list_packing (P : Finset PrimeIndex) (L : Finset Point)
    (align : PrimeIndex → Point → Prop) (B t : ℕ)
    (hpair : ∀ x ∈ L, ∀ y ∈ L, x ≠ y → overlap P align x y ≤ B)
    (hdegree : ∀ x ∈ L, t ≤ rowCount P (fun x p => align p x) x)
    (hscale : 2 * P.card * B ≤ t ^ 2) :
    L.card * t ^ 2 ≤ 2 * P.card ^ 2 := by
  have hlower : L.card * t ≤ mass P L align := by
    rw [← transpose_mass]
    calc
      L.card * t = ∑ _x ∈ L, t := by simp
      _ ≤ _ := Finset.sum_le_sum hdegree
  have hupper := degree_le P L align
  have hcoll := partial_collision_bound_loose P L align B hpair
  have hbound : mass P L align ^ 2 ≤
      P.card * (B * L.card ^ 2 + P.card * L.card) :=
    hcoll.trans (Nat.mul_le_mul_left _ (Nat.add_le_add_left hupper _))
  have hlowersq := Nat.pow_le_pow_left hlower 2
  have hscalemul := Nat.mul_le_mul_right (L.card ^ 2) hscale
  by_cases hL : L.card = 0
  · simp [hL]
  have hcancel : L.card * (L.card * t ^ 2) ≤ L.card * (2 * P.card ^ 2) := by
    nlinarith only [hbound, hlowersq, hscalemul]
  exact Nat.le_of_mul_le_mul_left hcancel (Nat.pos_of_ne_zero hL)

theorem no_rich_nonstructured_line [DecidableEq PrimeIndex]
    (P A E : Finset PrimeIndex) (C : Finset Cell) (X : Finset Point)
    (primeOf : Cell → PrimeIndex) (full : PrimeIndex → Point → Prop)
    (rel : Cell → Point → Prop) (B r t : ℕ)
    (hpair : ∀ x ∈ X, ∀ y ∈ X, x ≠ y → overlap C rel x y ≤ B)
    (hcover : ∀ x ∈ X, ∀ p ∈ P, full p x → p ∈ A ∨ p ∈ E ∨
      ∃ c ∈ C, primeOf c = p ∧ rel c x)
    (hrich : ∀ x ∈ X, r ≤ rowCount P (fun x p => full p x) x)
    (hbudget : mass C X rel ≤ P.card * X.card)
    (hgap : E.card + t ≤ r)
    (hmargin : C.card * (B * X.card ^ 2 + P.card * X.card) <
      ((r - E.card - t) * X.card) ^ 2)
    (hlist : t < A.card → ∀ x ∈ X, ∀ p ∈ A, ¬full p x) :
    False := by
  have hA := partial_incidence_forces_alignment P A E C X primeOf full rel B r t
    hpair hcover hrich hbudget hgap hmargin
  have hcover' : ∀ x ∈ X, ∀ p ∈ P, full p x →
      p ∈ (∅ : Finset PrimeIndex) ∨ p ∈ E ∨ ∃ c ∈ C, primeOf c = p ∧ rel c x := by
    intro x hx p hp hfull
    rcases hcover x hx p hp hfull with ha | he | hc
    · exact (hlist hA x hx p ha hfull).elim
    · exact Or.inr (Or.inl he)
    · exact Or.inr (Or.inr hc)
  have hmargin' : C.card * (B * X.card ^ 2 + P.card * X.card) <
      ((r - E.card - 0) * X.card) ^ 2 := by
    apply lt_of_lt_of_le hmargin
    exact Nat.pow_le_pow_left (Nat.mul_le_mul_right X.card (by omega)) 2
  have hz := partial_incidence_forces_alignment P ∅ E C X primeOf full rel B r 0
    hpair hcover' hrich hbudget (by omega) hmargin'
  simp at hz

theorem common_alignment_determinant (p ap A₁ D₁ A₂ D₂ : ℤ)
    (h₁ : p ∣ D₁ * ap - A₁) (h₂ : p ∣ D₂ * ap - A₂) :
    p ∣ A₁ * D₂ - A₂ * D₁ := by
  have hid : A₁ * D₂ - A₂ * D₁ =
      D₁ * (D₂ * ap - A₂) - D₂ * (D₁ * ap - A₁) := by ring
  rw [hid]
  exact dvd_sub (dvd_mul_of_dvd_right h₂ D₁) (dvd_mul_of_dvd_right h₁ D₂)

theorem same_slope_same_residue {F : Type*} [Field F]
    (d a b ap s x₁ y₁ x₂ y₂ : F)
    (hunaligned : d * ap ≠ b)
    (hline₁ : d * y₁ = a * x₁ + b)
    (hline₂ : d * y₂ = a * x₂ + b)
    (hhit₁ : y₁ + s * x₁ = ap)
    (hhit₂ : y₂ + s * x₂ = ap) :
    x₁ = x₂ := by
  have h₁ : (a + d * s) * x₁ = d * ap - b := by
    linear_combination d * hhit₁ - hline₁
  have h₂ : (a + d * s) * x₂ = d * ap - b := by
    linear_combination d * hhit₂ - hline₂
  have hne : a + d * s ≠ 0 := by
    intro hz
    rw [hz, zero_mul] at h₁
    exact hunaligned (sub_eq_zero.mp h₁.symm)
  exact mul_left_cancel₀ hne (h₁.trans h₂.symm)

theorem line_g_divides_q (g D A a q b : ℤ)
    (hcoprime : IsCoprime g a)
    (hline : (g * D) * b = a * q + g * A) :
    g ∣ q := by
  have hmul : g ∣ a * q := by
    use D * b - A
    linear_combination -hline
  exact hcoprime.dvd_of_dvd_mul_left hmul

theorem line_nonaligned_prime_divides_g (g D A a q b ell : ℤ)
    (hell : Prime ell) (hdiv : ell ∣ q)
    (hline : (g * D) * b = a * q + g * A)
    (hnonaligned : ¬ell ∣ D * b - A) :
    ell ∣ g := by
  have hmul : ell ∣ g * (D * b - A) := by
    have hid : g * (D * b - A) = a * q := by linear_combination hline
    rw [hid]
    exact dvd_mul_of_dvd_right hdiv a
  exact (hell.dvd_or_dvd hmul).resolve_right hnonaligned

theorem squarefree_exception_product (E : Finset ℤ) (g D A a q b : ℤ)
    (hprime : ∀ ell ∈ E, Prime ell)
    (hcoprime : (↑E : Set ℤ).Pairwise (Function.onFun IsCoprime id))
    (hdiv : ∀ ell ∈ E, ell ∣ q)
    (hbad : ∀ ell ∈ E, ¬ell ∣ D * b - A)
    (hline : (g * D) * b = a * q + g * A) :
    (∏ ell ∈ E, ell) ∣ g := by
  apply Finset.prod_dvd_of_coprime hcoprime
  intro ell he
  exact line_nonaligned_prime_divides_g g D A a q b ell
    (hprime ell he) (hdiv ell he) hline (hbad ell he)

theorem squarefree_exception_height (E : Finset ℤ) (g D A a q b : ℤ)
    (hprime : ∀ ell ∈ E, Prime ell)
    (hcoprime : (↑E : Set ℤ).Pairwise (Function.onFun IsCoprime id))
    (hdiv : ∀ ell ∈ E, ell ∣ q)
    (hbad : ∀ ell ∈ E, ¬ell ∣ D * b - A)
    (hline : (g * D) * b = a * q + g * A)
    (hg : 0 < g) (hD : 0 ≤ D) :
    D * (∏ ell ∈ E, ell) ≤ g * D := by
  have hprod := squarefree_exception_product E g D A a q b
    hprime hcoprime hdiv hbad hline
  have hle := Int.le_of_dvd hg hprod
  nlinarith

theorem prime_product_forces_zero (P : Finset ℤ) (value : ℤ)
    (hcoprime : (↑P : Set ℤ).Pairwise (Function.onFun IsCoprime id))
    (hdiv : ∀ p ∈ P, p ∣ value)
    (hsmall : value.natAbs < (∏ p ∈ P, p).natAbs) :
    value = 0 := by
  exact Int.eq_zero_of_dvd_of_natAbs_lt_natAbs
    (Finset.prod_dvd_of_coprime hcoprime hdiv) hsmall

theorem marked_abscissa_constant (d : ℕ) (hd : 2 ≤ d) :
    5 * d ^ 2 + 4 * d + 2 ≤ 8 * d ^ 2 := by
  nlinarith

theorem structural_exponent_margin (alpha : ℚ) (ha : alpha < 1 / 5) :
    (10 * alpha - 2) / 3 < 0 ∧ 3 * alpha - 2 < 0 ∧ 2 - 2 * alpha > 0 := by
  constructor
  · linarith
  constructor <;> linarith

end PartialIncidence
