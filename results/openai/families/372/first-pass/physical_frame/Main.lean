import Mathlib

namespace PhysicalFrame

structure CompatibilityData (A V W : Type*) [AddCommGroup A]
    [AddCommGroup V] [AddCommGroup W] where
  R : A →+ V
  Rlead : A →+ V
  S : A →+ W
  Slead : A →+ W
  divV : V →+ W
  normalV : V →+ W
  normalA : A →+ W
  defect : A →+ W
  P : W →+ W
  Plead : W →+ W
  augmented : ∀ u, divV (R u) - S u = P (defect u)
  compatibility : ∀ u, divV (Rlead u) + normalV (R u) - Slead u =
    P (normalA u) + Plead (defect u)
  leading_normal : ∀ u, normalV (Rlead u) = Plead (normalA u)

section Compatibility

variable {A V W : Type*} [AddCommGroup A] [AddCommGroup V] [AddCommGroup W]
variable (C : CompatibilityData A V W)

theorem normal_source_of_leading (u : A)
    (hR : C.Rlead u = 0) (hS : C.Slead u = 0) (hN : C.normalA u = 0) :
    C.normalV (C.R u) = C.Plead (C.defect u) := by
  simpa [hR, hS, hN] using C.compatibility u

theorem normal_source_of_step (previous current : A)
    (hR : C.Rlead current = -C.R previous)
    (hS : C.Slead current = -C.S previous)
    (hN : C.normalA current = -C.defect previous) :
    C.normalV (C.R current) = C.Plead (C.defect current) := by
  have balance : C.divV (C.Rlead current) - C.Slead current =
      C.P (C.normalA current) := by
    calc
      C.divV (C.Rlead current) - C.Slead current =
          -(C.divV (C.R previous) - C.S previous) := by
        rw [hR, hS, map_neg]
        abel
      _ = -C.P (C.defect previous) := by rw [C.augmented previous]
      _ = C.P (C.normalA current) := by rw [hN, map_neg]
  have combined : (C.divV (C.Rlead current) - C.Slead current) +
      C.normalV (C.R current) =
      C.P (C.normalA current) + C.Plead (C.defect current) := by
    calc
      (C.divV (C.Rlead current) - C.Slead current) + C.normalV (C.R current) =
          C.divV (C.Rlead current) + C.normalV (C.R current) - C.Slead current := by
        abel
      _ = C.P (C.normalA current) + C.Plead (C.defect current) :=
        C.compatibility current
  rw [balance] at combined
  exact add_left_cancel combined

theorem normal_source_all_orders (u : ℕ → A)
    (hR0 : C.Rlead (u 0) = 0) (hS0 : C.Slead (u 0) = 0)
    (hN0 : C.normalA (u 0) = 0)
    (hR : ∀ j, C.Rlead (u (j + 1)) = -C.R (u j))
    (hS : ∀ j, C.Slead (u (j + 1)) = -C.S (u j))
    (hN : ∀ j, C.normalA (u (j + 1)) = -C.defect (u j)) :
    ∀ j, C.normalV (C.R (u j)) = C.Plead (C.defect (u j)) := by
  intro j
  cases j with
  | zero => exact normal_source_of_leading C (u 0) hR0 hS0 hN0
  | succ j => exact normal_source_of_step C (u j) (u (j + 1)) (hR j) (hS j) (hN j)

theorem particular_source_tangent (u particular : A)
    (compatible : C.normalV (C.R u) = C.Plead (C.defect u))
    (normal_prescribed : C.normalA particular = -C.defect u) :
    C.normalV (-C.R u - C.Rlead particular) = 0 := by
  rw [map_sub, map_neg, C.leading_normal particular, normal_prescribed, map_neg,
    compatible]
  abel

end Compatibility

section Telescoping

variable {K V A : Type*} [CommRing K] [AddCommGroup V] [Module K V]
variable [AddCommGroup A] [Module K A]

theorem residual_sum_telescope (h : K) (r t : ℕ → V)
    (initial : t 0 = 0) (recursion : ∀ j, t (j + 1) = -r j) (N : ℕ) :
    (∑ j ∈ Finset.range (N + 1), (h ^ (j + 1) • r j + h ^ j • t j)) =
      h ^ (N + 1) • r N := by
  induction N with
  | zero => simp [initial]
  | succ N ih =>
    rw [Finset.sum_range_succ, ih, recursion N]
    simp only [smul_neg]
    abel

theorem normal_sum_telescope (h : K) (q n : ℕ → V)
    (initial : n 0 = 0) (recursion : ∀ j, n (j + 1) = -q j) (N : ℕ) :
    (∑ j ∈ Finset.range (N + 1), (h ^ j • n j + h ^ (j + 1) • q j)) =
      h ^ (N + 1) • q N := by
  calc
    (∑ j ∈ Finset.range (N + 1), (h ^ j • n j + h ^ (j + 1) • q j)) =
        ∑ j ∈ Finset.range (N + 1), (h ^ (j + 1) • q j + h ^ j • n j) := by
      apply Finset.sum_congr rfl
      intro j _
      exact add_comm _ _
    _ = h ^ (N + 1) • q N := residual_sum_telescope h q n initial recursion N

def truncated (h : K) (u : ℕ → A) (N : ℕ) : A :=
  ∑ j ∈ Finset.range (N + 1), h ^ j • u j

theorem vector_telescope (h : K) (R Rt : A →ₗ[K] V) (u : ℕ → A)
    (initial : Rt (u 0) = 0) (recursion : ∀ j, Rt (u (j + 1)) = -R (u j))
    (N : ℕ) :
    h • R (truncated h u N) + Rt (truncated h u N) =
      h ^ (N + 1) • R (u N) := by
  calc
    h • R (truncated h u N) + Rt (truncated h u N) =
        ∑ j ∈ Finset.range (N + 1),
          (h ^ (j + 1) • R (u j) + h ^ j • Rt (u j)) := by
      simp only [truncated, map_sum, map_smul, Finset.smul_sum, smul_smul,
        Finset.sum_add_distrib, pow_succ']
    _ = h ^ (N + 1) • R (u N) :=
      residual_sum_telescope h (fun j => R (u j)) (fun j => Rt (u j))
        initial recursion N

theorem divergence_telescope (h : K) (q n : A →ₗ[K] V) (u : ℕ → A)
    (initial : n (u 0) = 0) (recursion : ∀ j, n (u (j + 1)) = -q (u j))
    (N : ℕ) :
    n (truncated h u N) + h • q (truncated h u N) =
      h ^ (N + 1) • q (u N) := by
  calc
    n (truncated h u N) + h • q (truncated h u N) =
        ∑ j ∈ Finset.range (N + 1),
          (h ^ j • n (u j) + h ^ (j + 1) • q (u j)) := by
      simp only [truncated, map_sum, map_smul, Finset.smul_sum, smul_smul,
        Finset.sum_add_distrib, pow_succ']
    _ = h ^ (N + 1) • q (u N) :=
      normal_sum_telescope h (fun j => q (u j)) (fun j => n (u j))
        initial recursion N

end Telescoping

#print axioms normal_source_all_orders
#print axioms vector_telescope
#print axioms divergence_telescope

end PhysicalFrame
