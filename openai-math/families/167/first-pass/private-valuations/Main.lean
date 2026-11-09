import Mathlib

open scoped BigOperators

namespace PrivateValuations

theorem private_orders_exclude_squares
    {I G : Type*} [DecidableEq I] [CommGroup G]
    (D : I → G) (v : I → G →* Multiplicative ℤ)
    (hv : ∀ i j, (v i (D j)).toAdd = if i = j then 1 else 0)
    (s : Finset I) (hs : s.Nonempty) :
    ¬ ∃ x : G, x * x = s.prod D := by
  obtain ⟨i, hi⟩ := hs
  rintro ⟨x, hx⟩
  have hp : (v i (s.prod D)).toAdd = 1 := by
    rw [map_prod, toAdd_prod]
    simp [hv, hi]
  have hh := congrArg (fun y : G => (v i y).toAdd) hx
  rw [map_mul, toAdd_mul, hp] at hh
  omega

section Field

variable {E : Type*} [Field E] [CharZero E]

theorem sign_changes_separate
    {I : Type*} [Fintype I] [DecidableEq I]
    (r c : I → E) (σ : I → E ≃+* E)
    (hrn : ∀ i, r i ≠ 0)
    (hc : ∀ i k, σ i (c k) = c k)
    (hr : ∀ i k, σ i (r k) = if k = i then -r k else r k)
    (h : ∑ k, c k * r k = 0) : ∀ i, c i = 0 := by
  intro i
  have hh := congrArg (σ i) h
  simp only [map_sum, map_mul, map_zero, hc, hr] at hh
  have he :
      (∑ k, c k * (if k = i then -r k else r k)) =
        (∑ k, c k * r k) - 2 * (c i * r i) := by
    calc
      _ = ∑ k, (c k * r k - if k = i then 2 * (c i * r i) else 0) := by
        apply Finset.sum_congr rfl
        intro k _
        by_cases hk : k = i
        · subst k
          simp only [ite_true]
          ring
        · simp only [hk, ite_false, sub_zero]
      _ = _ := by
        rw [Finset.sum_sub_distrib]
        simp
  rw [he, h] at hh
  have hz : (2 : E) * (c i * r i) = 0 := by
    linear_combination -hh
  have hcr : c i * r i = 0 :=
    (mul_eq_zero.mp hz).resolve_left (by norm_num)
  exact (mul_eq_zero.mp hcr).resolve_right (hrn i)

theorem unused_sign_forces
    (σ : E ≃+* E) (q r A t : E)
    (hq : σ q = q) (hA : σ A = A) (ht : σ t = t)
    (hr : σ r = -r) (hrn : r ≠ 0)
    (h : q = r * (A - t)) : A = t := by
  have hh := congrArg σ h
  simp only [map_mul, map_sub, hq, hA, ht, hr] at hh
  have hz : (2 : E) * (r * (A - t)) = 0 := by
    linear_combination hh - h
  have hrt : r * (A - t) = 0 :=
    (mul_eq_zero.mp hz).resolve_left (by norm_num)
  exact sub_eq_zero.mp ((mul_eq_zero.mp hrt).resolve_left hrn)

def delta3 (a₀ a₁ a₂ b₀ b₁ b₂ r₀ r₁ r₂ : E) : E :=
  (a₁ * b₂ - a₂ * b₁) * r₀ +
  (a₂ * b₀ - a₀ * b₂) * r₁ +
  (a₀ * b₁ - a₁ * b₀) * r₂

theorem three_rows_unique
    {a₀ a₁ a₂ b₀ b₁ b₂ r₀ r₁ r₂ x y A : E}
    (hd : delta3 a₀ a₁ a₂ b₀ b₁ b₂ r₀ r₁ r₂ ≠ 0)
    (h₀ : a₀ * x + b₀ * y - r₀ * A = 0)
    (h₁ : a₁ * x + b₁ * y - r₁ * A = 0)
    (h₂ : a₂ * x + b₂ * y - r₂ * A = 0) :
    x = 0 ∧ y = 0 ∧ A = 0 := by
  have hx : delta3 a₀ a₁ a₂ b₀ b₁ b₂ r₀ r₁ r₂ * x = 0 := by
    dsimp [delta3]
    linear_combination
      (b₁ * r₂ - b₂ * r₁) * h₀ +
      (b₂ * r₀ - b₀ * r₂) * h₁ +
      (b₀ * r₁ - b₁ * r₀) * h₂
  have hy : delta3 a₀ a₁ a₂ b₀ b₁ b₂ r₀ r₁ r₂ * y = 0 := by
    dsimp [delta3]
    linear_combination
      (a₂ * r₁ - a₁ * r₂) * h₀ +
      (a₀ * r₂ - a₂ * r₀) * h₁ +
      (a₁ * r₀ - a₀ * r₁) * h₂
  have hA : delta3 a₀ a₁ a₂ b₀ b₁ b₂ r₀ r₁ r₂ * A = 0 := by
    dsimp [delta3]
    linear_combination
      -(a₁ * b₂ - a₂ * b₁) * h₀ -
      (a₂ * b₀ - a₀ * b₂) * h₁ -
      (a₀ * b₁ - a₁ * b₀) * h₂
  exact ⟨(mul_eq_zero.mp hx).resolve_left hd,
    (mul_eq_zero.mp hy).resolve_left hd,
    (mul_eq_zero.mp hA).resolve_left hd⟩

theorem rank_two_obstruction
    (a b d t r : Fin 4 → E) (σ : Fin 4 → E ≃+* E)
    (ha : ∀ i k, σ i (a k) = a k)
    (hb : ∀ i k, σ i (b k) = b k)
    (hd : ∀ i k, σ i (d k) = d k)
    (ht : ∀ i k, σ i (t k) = t k)
    (hr : ∀ i k, σ i (r k) = if k = i then -r k else r k)
    (hrn : ∀ i, r i ≠ 0)
    (hminor :
      a 1 * b 2 - a 2 * b 1 ≠ 0 ∨
      a 2 * b 0 - a 0 * b 2 ≠ 0 ∨
      a 0 * b 1 - a 1 * b 0 ≠ 0)
    (x y A : E)
    (heq : ∀ k, a k * x + b k * y - r k * A = d k - r k * t k)
    (hne : A ≠ t 3) : False := by
  let c : Fin 4 → E := ![
    a 1 * b 2 - a 2 * b 1,
    a 2 * b 0 - a 0 * b 2,
    a 0 * b 1 - a 1 * b 0, 0]
  have hc : ∀ i k, σ i (c k) = c k := by
    intro i k
    fin_cases k <;> simp [c, ha, hb]
  have hdelta : delta3 (a 0) (a 1) (a 2) (b 0) (b 1) (b 2)
      (r 0) (r 1) (r 2) ≠ 0 := by
    intro hz
    have hs : ∑ k, c k * r k = 0 := by
      simpa [c, Fin.sum_univ_succ, delta3, add_assoc] using hz
    have hzero := sign_changes_separate r c σ hrn hc hr hs
    rcases hminor with h | h | h
    · exact h (by simpa [c] using hzero 0)
    · exact h (by simpa [c] using hzero 1)
    · exact h (by simpa [c] using hzero 2)
  have htrans (k : Fin 4) (hk : k ≠ 3) :
      a k * σ 3 x + b k * σ 3 y - r k * σ 3 A = d k - r k * t k := by
    have hh := congrArg (σ 3) (heq k)
    simpa [ha, hb, hd, ht, hr, hk] using hh
  have h₀ :
      a 0 * (σ 3 x - x) + b 0 * (σ 3 y - y) -
        r 0 * (σ 3 A - A) = 0 := by
    linear_combination (htrans 0 (by decide)) - heq 0
  have h₁ :
      a 1 * (σ 3 x - x) + b 1 * (σ 3 y - y) -
        r 1 * (σ 3 A - A) = 0 := by
    linear_combination (htrans 1 (by decide)) - heq 1
  have h₂ :
      a 2 * (σ 3 x - x) + b 2 * (σ 3 y - y) -
        r 2 * (σ 3 A - A) = 0 := by
    linear_combination (htrans 2 (by decide)) - heq 2
  obtain ⟨hx, hy, hA⟩ := three_rows_unique hdelta h₀ h₁ h₂
  have hxf : σ 3 x = x := sub_eq_zero.mp hx
  have hyf : σ 3 y = y := sub_eq_zero.mp hy
  have hAf : σ 3 A = A := sub_eq_zero.mp hA
  have hq : σ 3 (a 3 * x + b 3 * y - d 3) =
      a 3 * x + b 3 * y - d 3 := by
    simp [ha, hb, hd, hxf, hyf]
  have he : a 3 * x + b 3 * y - d 3 = r 3 * (A - t 3) := by
    linear_combination heq 3
  exact hne (unused_sign_forces (σ 3) _ _ _ _ hq hAf (ht 3 3)
    (by simpa using hr 3 3) (hrn 3) he)

theorem two_rows_unique
    {a₀ a₁ r₀ r₁ x A : E}
    (hd : a₁ * r₀ - a₀ * r₁ ≠ 0)
    (h₀ : a₀ * x - r₀ * A = 0)
    (h₁ : a₁ * x - r₁ * A = 0) : x = 0 ∧ A = 0 := by
  have hx : (a₁ * r₀ - a₀ * r₁) * x = 0 := by
    linear_combination -r₁ * h₀ + r₀ * h₁
  have hA : (a₁ * r₀ - a₀ * r₁) * A = 0 := by
    linear_combination -a₁ * h₀ + a₀ * h₁
  exact ⟨(mul_eq_zero.mp hx).resolve_left hd,
    (mul_eq_zero.mp hA).resolve_left hd⟩

theorem rank_one_obstruction
    (a d t r : Fin 3 → E) (σ : Fin 3 → E ≃+* E)
    (ha : ∀ i k, σ i (a k) = a k)
    (hd : ∀ i k, σ i (d k) = d k)
    (ht : ∀ i k, σ i (t k) = t k)
    (hr : ∀ i k, σ i (r k) = if k = i then -r k else r k)
    (hrn : ∀ i, r i ≠ 0)
    (hcoeff : a 0 ≠ 0 ∨ a 1 ≠ 0)
    (x A : E)
    (heq : ∀ k, a k * x - r k * A = d k - r k * t k)
    (hne : A ≠ t 2) : False := by
  let c : Fin 3 → E := ![a 1, -a 0, 0]
  have hc : ∀ i k, σ i (c k) = c k := by
    intro i k
    fin_cases k <;> simp [c, ha]
  have hdelta : a 1 * r 0 - a 0 * r 1 ≠ 0 := by
    intro hz
    have hs : ∑ k, c k * r k = 0 := by
      simpa [c, Fin.sum_univ_succ, sub_eq_add_neg] using hz
    have hzero := sign_changes_separate r c σ hrn hc hr hs
    rcases hcoeff with h | h
    · exact h (by simpa [c] using hzero 1)
    · exact h (by simpa [c] using hzero 0)
  have htrans (k : Fin 3) (hk : k ≠ 2) :
      a k * σ 2 x - r k * σ 2 A = d k - r k * t k := by
    have hh := congrArg (σ 2) (heq k)
    simpa [ha, hd, ht, hr, hk] using hh
  have h₀ : a 0 * (σ 2 x - x) - r 0 * (σ 2 A - A) = 0 := by
    linear_combination (htrans 0 (by decide)) - heq 0
  have h₁ : a 1 * (σ 2 x - x) - r 1 * (σ 2 A - A) = 0 := by
    linear_combination (htrans 1 (by decide)) - heq 1
  obtain ⟨hx, hA⟩ := two_rows_unique hdelta h₀ h₁
  have hxf : σ 2 x = x := sub_eq_zero.mp hx
  have hAf : σ 2 A = A := sub_eq_zero.mp hA
  have hq : σ 2 (a 2 * x - d 2) = a 2 * x - d 2 := by
    simp [ha, hd, hxf]
  have he : a 2 * x - d 2 = r 2 * (A - t 2) := by
    linear_combination heq 2
  exact hne (unused_sign_forces (σ 2) _ _ _ _ hq hAf (ht 2 2)
    (by simpa using hr 2 2) (hrn 2) he)

theorem fractional_discriminant (b : E) :
    (4 - 2 * b) ^ 2 - 4 * b * b = 16 * (1 - b) := by
  ring

theorem excluded_unit_circle_square (z : E) (hz : z ≠ 0) :
    (-(z - 1) ^ 2 / z) * (-(z - 1) ^ 2 / z - 4) =
      ((z ^ 2 - 1) / z) ^ 2 := by
  field_simp
  <;> ring

end Field

end PrivateValuations
