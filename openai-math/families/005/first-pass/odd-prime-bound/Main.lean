import Mathlib

open scoped BigOperators

namespace OddPrimeBound

theorem loss_cap (n R S r s : ℕ)
    (hn : r + s ≤ n) (hr : r ≤ R) (hs : s ≤ S) :
    2 * r + s ≤ min (2 * n) (min (n + R) (2 * R + S)) := by
  apply le_min
  · omega
  · apply le_min <;> omega

theorem pair_loss (n d q k : ℕ) (hk : d - q ≤ k) :
    2 * n - k ≤ 2 * n - (d - q) := by
  omega

theorem retained_count (A b J K : ℤ)
    (_hb : 0 ≤ b) (hA : b ≤ A) (hK : K ≤ J) :
    max K 0 + max (J - b) 0 - max (min A K - b) 0 =
      max K 0 + max (K - A) 0 + max (J - max b K) 0 := by
  omega

section Ring

variable {k ι : Type*} [CommRing k]

theorem central_residue (s t : Finset ι) (V Y a sign : ι → k) (x : k)
    (hx : x = -((∑ l ∈ s, a l * V l) + ∑ l ∈ t, a l * V l))
    (hY : ∀ l ∈ s, Y l = sign l * V l)
    (hSign : ∀ l ∈ s, sign l * sign l = 1) :
    x + (∑ l ∈ s, (sign l * a l) * Y l) = -∑ l ∈ t, a l * V l := by
  have hsum : (∑ l ∈ s, (sign l * a l) * Y l) =
      ∑ l ∈ s, a l * V l := by
    apply Finset.sum_congr rfl
    intro l hl
    rw [hY l hl]
    calc
      (sign l * a l) * (sign l * V l) =
          (sign l * sign l) * (a l * V l) := by ring
      _ = a l * V l := by rw [hSign l hl, one_mul]
  rw [hx, hsum]
  ring

theorem scaled_shear (s : Finset ι) (p x : k) (a Y : ι → k) :
    p * (x + p * ∑ l ∈ s, a l * Y l) =
      p * x + ∑ l ∈ s, a l * (p ^ 2 * Y l) := by
  simp only [mul_add, Finset.mul_sum]
  congr 1
  apply Finset.sum_congr rfl
  intro l hl
  ring

end Ring

section Field

variable {k : Type*} [Field k]

theorem secondary_terms (p y0 y1 y2 : k) (hp : p ≠ 0) :
    p * (y0 / p ^ 2 + y1 / p + y2) = y0 / p + y1 + p * y2 := by
  field_simp [hp]

theorem paired_terms (p a b c d e : k) (hp : p ≠ 0) :
    p * ((a / p ^ 2 + b / p + c) + (-a / p ^ 2 + d / p + e)) =
      b + d + p * (c + e) := by
  field_simp [hp]
  ring

end Field

section Determinant

variable {k ι : Type*} [CommRing k] [Fintype ι] [DecidableEq ι]

theorem weighted_det (p : k) (w : ι → ℕ) (M : Matrix ι ι k) :
    Matrix.det (fun i j => p ^ w j * M i j) =
      p ^ (∑ j, w j) * M.det := by
  rw [← Finset.prod_pow_eq_pow_sum]
  exact Matrix.det_mul_row (fun j => p ^ w j) M

theorem det_mem (S : Subring k) (M : Matrix ι ι k)
    (hM : ∀ i j, M i j ∈ S) : M.det ∈ S := by
  let B : Matrix ι ι S := fun i j => ⟨M i j, hM i j⟩
  have hdet : (B.det : k) = M.det := by
    calc
      (B.det : k) = Matrix.det (S.subtype.mapMatrix B) := S.subtype.map_det B
      _ = M.det := by
        apply congrArg Matrix.det
        ext i j
        rfl
  rw [← hdet]
  exact (B.det).property

theorem scaled_det_mem (S : Subring k) (p : k) (w : ι → ℕ)
    (M : Matrix ι ι k) (hM : ∀ i j, p ^ w j * M i j ∈ S) :
    p ^ (∑ j, w j) * M.det ∈ S := by
  have h := det_mem S (fun i j => p ^ w j * M i j) hM
  rwa [weighted_det] at h

theorem bounded_denominator (S : Subring k) (p : k) (hp : p ∈ S)
    (w : ι → ℕ) (M : Matrix ι ι k) (D : ℕ)
    (hD : (∑ j, w j) ≤ D) (hM : ∀ i j, p ^ w j * M i j ∈ S) :
    p ^ D * M.det ∈ S := by
  have h := S.mul_mem (S.pow_mem hp (D - ∑ j, w j))
    (scaled_det_mem S p w M hM)
  rw [← mul_assoc, ← pow_add, Nat.sub_add_cancel hD] at h
  exact h

end Determinant

end OddPrimeBound
