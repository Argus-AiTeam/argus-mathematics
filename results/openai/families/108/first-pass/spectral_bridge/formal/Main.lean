import Mathlib

noncomputable section

namespace RectangularCore

abbrev Index2 := ℕ × ℕ
abbrev Index3 := ℕ × ℕ × ℕ
abbrev BiPoly (K : Type*) [Semiring K] := AddMonoidAlgebra K Index2
abbrev TriPoly (K : Type*) [Semiring K] := AddMonoidAlgebra K Index3

def degree2 (e : Index2) : ℕ := e.1 + e.2
def degree3 (e : Index3) : ℕ := e.1 + e.2.1 + e.2.2

variable {K : Type*} [Semiring K]

def totalDegree (p : BiPoly K) : ℕ := p.coeff.support.sup degree2
def totalDegree3 (P : TriPoly K) : ℕ := P.coeff.support.sup degree3

def InRectangle (p : BiPoly K) (a b : ℕ) : Prop :=
  ∀ e ∈ p.coeff.support, e.1 ≤ a ∧ e.2 ≤ b

def IsHomogeneous (P : TriPoly K) (m : ℕ) : Prop :=
  ∀ e ∈ P.coeff.support, degree3 e = m

def liftExponent (m : ℕ) (e : Index2) : Index3 :=
  (e.1, e.2, m - (e.1 + e.2))

theorem liftExponent_injective (m : ℕ) : Function.Injective (liftExponent m) := by
  intro x y h
  exact Prod.ext (congrArg (fun z : Index3 => z.1) h)
    (congrArg (fun z : Index3 => z.2.1) h)

def homogenize (m : ℕ) (p : BiPoly K) : TriPoly K :=
  AddMonoidAlgebra.ofCoeff (Finsupp.mapDomain (liftExponent m) p.coeff)

theorem homogenize_expansion (p : BiPoly K) (m : ℕ) :
    (homogenize m p).coeff =
      ∑ e ∈ p.coeff.support, Finsupp.single (liftExponent m e) (p e) := by
  rfl

theorem homogenize_coefficient (p : BiPoly K) (m : ℕ) (e : Index2) :
    homogenize m p (liftExponent m e) = p e := by
  exact Finsupp.mapDomain_apply (liftExponent_injective m) p.coeff e

theorem support_degree_le (p : BiPoly K) (e : Index2)
    (he : e ∈ p.coeff.support) : degree2 e ≤ totalDegree p := by
  exact Finset.le_sup he

theorem exists_top_term (p : BiPoly K) (hp : p ≠ 0) :
    ∃ e ∈ p.coeff.support, degree2 e = totalDegree p := by
  classical
  have hs : p.coeff.support.Nonempty :=
    Finsupp.support_nonempty_iff.mpr (by
      intro h
      exact hp (AddMonoidAlgebra.coeff_eq_zero.mp h))
  obtain ⟨e, he, hmax⟩ := Finset.exists_max_image p.coeff.support degree2 hs
  exact ⟨e, he, le_antisymm (support_degree_le p e he) (Finset.sup_le hmax)⟩

theorem homogenize_homogeneous (p : BiPoly K) (m : ℕ)
    (hm : ∀ e ∈ p.coeff.support, degree2 e ≤ m) :
    IsHomogeneous (homogenize m p) m := by
  intro v hv
  change v ∈ (Finsupp.mapDomain (liftExponent m) p.coeff).support at hv
  rw [Finsupp.mapDomain_support_of_injective (liftExponent_injective m)] at hv
  obtain ⟨e, he, rfl⟩ := Finset.mem_image.mp hv
  have hd := hm e he
  dsimp [degree2, degree3, liftExponent] at *
  omega

theorem homogenize_actual_degree_homogeneous (p : BiPoly K) :
    IsHomogeneous (homogenize (totalDegree p) p) (totalDegree p) :=
  homogenize_homogeneous p (totalDegree p) (support_degree_le p)

theorem homogeneous_mul_monomial (P : TriPoly K) (m : ℕ)
    (hP : IsHomogeneous P m) (r : Index3) :
    IsHomogeneous (P * AddMonoidAlgebra.single r (1 : K)) (m + degree3 r) := by
  intro v hv
  obtain ⟨e, he, rfl⟩ := Finset.mem_image.mp
    (AddMonoidAlgebra.support_mul_single_subset P (1 : K) r hv)
  have hd := hP e he
  simp only [degree3, Prod.fst_add, Prod.snd_add] at *
  omega

theorem homogeneous_totalDegree (P : TriPoly K) (m : ℕ)
    (hP : IsHomogeneous P m) (hne : P ≠ 0) : totalDegree3 P = m := by
  have hs : P.coeff.support.Nonempty :=
    Finsupp.support_nonempty_iff.mpr (by
      intro h
      exact hne (AddMonoidAlgebra.coeff_eq_zero.mp h))
  obtain ⟨e, he⟩ := hs
  apply le_antisymm (Finset.sup_le (fun e he => (hP e he).le))
  rw [← hP e he]
  exact Finset.le_sup he

theorem recover_top_coefficient (p : BiPoly K) (m a b c i j : ℕ)
    (hi : i ≤ a) (hj : j ≤ b) (hij : i + j = m) :
    (homogenize m p * AddMonoidAlgebra.single (a - i, b - j, c) (1 : K))
      (a, b, c) = p (i, j) := by
  have hshift :
      liftExponent m (i, j) + (a - i, b - j, c) = (a, b, c) := by
    apply Prod.ext
    · dsimp [liftExponent]
      omega
    · apply Prod.ext <;> dsimp [liftExponent] <;> omega
  calc
    _ = homogenize m p (liftExponent m (i, j)) * 1 := by
      apply AddMonoidAlgebra.mul_single_apply_aux
      intro e _
      rw [← hshift]
      exact add_right_cancel_iff
    _ = p (i, j) := by rw [homogenize_coefficient, mul_one]

theorem complementary_product_homogeneous (p : BiPoly K) (a b c i j : ℕ)
    (hi : i ≤ a) (hj : j ≤ b) (hij : i + j = totalDegree p) :
    IsHomogeneous
      (homogenize (totalDegree p) p *
        AddMonoidAlgebra.single (a - i, b - j, c) (1 : K))
      (a + b + c) := by
  have h := homogeneous_mul_monomial (homogenize (totalDegree p) p)
    (totalDegree p) (homogenize_actual_degree_homogeneous p) (a - i, b - j, c)
  have hd : totalDegree p + degree3 (a - i, b - j, c) = a + b + c := by
    dsimp [degree3]
    omega
  rwa [hd] at h

theorem complementary_product_degree (p : BiPoly K) (a b c i j : ℕ)
    (hi : i ≤ a) (hj : j ≤ b) (hij : i + j = totalDegree p)
    (hcoeff : p (i, j) ≠ 0) :
    totalDegree3
      (homogenize (totalDegree p) p *
        AddMonoidAlgebra.single (a - i, b - j, c) (1 : K)) = a + b + c := by
  apply homogeneous_totalDegree _ _ (complementary_product_homogeneous p a b c i j hi hj hij)
  intro hz
  have h := recover_top_coefficient p (totalDegree p) a b c i j hi hj hij
  rw [hz] at h
  change (0 : K) = p (i, j) at h
  exact hcoeff h.symm

def rectangle (a b : ℕ) : Finset Index2 :=
  (Finset.range (a + 1)) ×ˢ (Finset.range (b + 1))

theorem mem_rectangle (a b : ℕ) (e : Index2) :
    e ∈ rectangle a b ↔ e.1 ≤ a ∧ e.2 ≤ b := by
  simp [rectangle]

theorem rectangle_card (a b : ℕ) : (rectangle a b).card = (a + 1) * (b + 1) := by
  simp [rectangle]

theorem zero_of_top_coefficients_vanish (p : BiPoly K) (a b c : ℕ)
    (hrect : InRectangle p a b)
    (hvanish : ∀ e ∈ rectangle a b, degree2 e = totalDegree p →
      (homogenize (totalDegree p) p *
        AddMonoidAlgebra.single (a - e.1, b - e.2, c) (1 : K)) (a, b, c) = 0) :
    p = 0 := by
  by_contra hp
  obtain ⟨e, he, htop⟩ := exists_top_term p hp
  obtain ⟨hi, hj⟩ := hrect e he
  have hzero := hvanish e ((mem_rectangle a b e).mpr ⟨hi, hj⟩) htop
  have hrec := recover_top_coefficient p (totalDegree p) a b c e.1 e.2 hi hj htop
  rw [hrec] at hzero
  exact (Finsupp.mem_support_iff.mp he) hzero

theorem all_complementary_coefficients_vanish_iff (p : BiPoly K) (a b c : ℕ)
    (hrect : InRectangle p a b) :
    (∀ e ∈ rectangle a b,
      (homogenize (totalDegree p) p *
        AddMonoidAlgebra.single (a - e.1, b - e.2, c) (1 : K)) (a, b, c) = 0) ↔
      p = 0 := by
  constructor
  · intro h
    exact zero_of_top_coefficients_vanish p a b c hrect (fun e he _ => h e he)
  · rintro rfl e _
    simp [homogenize, AddMonoidAlgebra.ofCoeff_zero]
    rfl

theorem nonzero_rectangular_detection (p : BiPoly K) (a b : ℕ)
    (hrect : InRectangle p a b) (hp : p ≠ 0) :
    ∃ e ∈ rectangle a b, degree2 e = totalDegree p ∧ p e ≠ 0 ∧
      ∀ c : ℕ,
        IsHomogeneous
          (homogenize (totalDegree p) p *
            AddMonoidAlgebra.single (a - e.1, b - e.2, c) (1 : K))
          (a + b + c) ∧
        totalDegree3
          (homogenize (totalDegree p) p *
            AddMonoidAlgebra.single (a - e.1, b - e.2, c) (1 : K)) = a + b + c ∧
        (homogenize (totalDegree p) p *
          AddMonoidAlgebra.single (a - e.1, b - e.2, c) (1 : K)) (a, b, c) = p e := by
  obtain ⟨e, he, htop⟩ := exists_top_term p hp
  obtain ⟨hi, hj⟩ := hrect e he
  have hcoeff : p e ≠ 0 := Finsupp.mem_support_iff.mp he
  refine ⟨e, (mem_rectangle a b e).mpr ⟨hi, hj⟩, htop, hcoeff, ?_⟩
  intro c
  exact ⟨complementary_product_homogeneous p a b c e.1 e.2 hi hj htop,
    complementary_product_degree p a b c e.1 e.2 hi hj htop hcoeff,
    recover_top_coefficient p (totalDegree p) a b c e.1 e.2 hi hj htop⟩

theorem square_ge_triangle (q : ℕ) : Nat.choose (q + 2) 2 ≤ (q + 1) ^ 2 := by
  rw [Nat.choose_two_right, show q + 2 - 1 = q + 1 by omega]
  have h := Nat.div_mul_le_self ((q + 2) * (q + 1)) 2
  nlinarith

theorem square_gt_triangle (q : ℕ) (hq : 0 < q) :
    Nat.choose (q + 2) 2 < (q + 1) ^ 2 := by
  rw [Nat.choose_two_right, show q + 2 - 1 = q + 1 by omega]
  have h := Nat.div_mul_le_self ((q + 2) * (q + 1)) 2
  have hpos : 0 < q * (q + 1) := Nat.mul_pos hq (by omega)
  nlinarith

end RectangularCore
