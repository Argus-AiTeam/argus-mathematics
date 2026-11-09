import Mathlib.Data.Finsupp.Basic
import Mathlib.Algebra.Polynomial.Inductions

namespace CoproductAudit

theorem polynomial_image_descent
    {V W : Type*} [Zero V] [Zero W]
    (T : V → W) (hT : Function.Injective T) (hzero : T 0 = 0)
    (c : ℤ → V) (q : ℕ →₀ W)
    (hcoeff : ∀ j : ℤ, T (c j) = if 0 ≤ j then q j.toNat else 0) :
    ∃ p : ℕ →₀ V,
      (∀ n : ℕ, p n = c (n : ℤ)) ∧
      (∀ j : ℤ, j < 0 → c j = 0) ∧
      Finsupp.mapRange T hzero p = q ∧
      T (p 0) = q 0 := by
  classical
  have hnegative : ∀ j : ℤ, j < 0 → c j = 0 := by
    intro j hj
    apply hT
    simpa [not_le.mpr hj, hzero] using hcoeff j
  have hvanish : ∀ n : ℕ, q n = 0 → c (n : ℤ) = 0 := by
    intro n hn
    apply hT
    simpa [hn, hzero] using hcoeff (n : ℤ)
  let p : ℕ →₀ V :=
    Finsupp.onFinset q.support (fun n => c (n : ℤ)) (by
      intro n hn
      exact Finsupp.mem_support_iff.mpr (fun hq => hn (hvanish n hq)))
  have hp : ∀ n : ℕ, p n = c (n : ℤ) := by
    intro n
    exact Finsupp.onFinset_apply
  refine ⟨p, hp, hnegative, ?_, ?_⟩
  · ext n
    change T (p n) = q n
    simpa [hp n] using hcoeff (n : ℤ)
  · simpa [hp 0] using hcoeff 0

theorem constant_lift_unique
    {V W : Type*} (T : V → W) (hT : Function.Injective T)
    (c c' : ℤ → V)
    (hcoeff : ∀ j : ℤ, T (c j) = T (c' j)) :
    c 0 = c' 0 :=
  hT (hcoeff 0)

theorem polynomial_kernel_cancellation
    {R : Type*} [CommRing R] (F : Polynomial R) :
    (-(Polynomial.X : Polynomial R)) * (-F.divX) =
      F - Polynomial.C (F.coeff 0) := by
  rw [neg_mul_neg]
  exact eq_sub_iff_add_eq.mpr (Polynomial.X_mul_divX_add F)

theorem evaluated_kernel_cancellation
    {R : Type*} [CommRing R] (F : Polynomial R) (u : R) :
    (-u) * (-(F.divX.eval u)) = F.eval u - F.coeff 0 := by
  have h := congrArg (Polynomial.eval u) (polynomial_kernel_cancellation F)
  simpa using h

end CoproductAudit
