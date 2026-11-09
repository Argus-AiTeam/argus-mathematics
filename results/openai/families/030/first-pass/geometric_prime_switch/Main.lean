import Mathlib

namespace GeometricPrimeSwitch

open Finset

section Cellular

variable {A : Type*} [AddCommGroup A]

def partialSum (c : ℕ → A) (i : ℕ) : A :=
  ∑ k ∈ range i, c k

theorem prefix_difference (c : ℕ → A) (i : ℕ) :
    partialSum c (i + 1) - partialSum c i = c i := by
  simp [partialSum, sum_range_succ]

theorem telescope (p : ℕ → A) (m : ℕ) :
    (∑ i ∈ range m, (p (i + 1) - p i)) = p m - p 0 := by
  induction m with
  | zero => simp
  | succ m ih =>
      rw [sum_range_succ, ih]
      abel

theorem cyclic_exact (m : ℕ) (c : ℕ → A) :
    (∑ i ∈ range m, c i) = 0 ↔
      ∃ p : ℕ → A, p 0 = 0 ∧ p m = p 0 ∧
        ∀ i < m, p (i + 1) - p i = c i := by
  constructor
  · intro h
    refine ⟨partialSum c, ?_, ?_, ?_⟩
    · simp [partialSum]
    · simpa [partialSum] using h
    · intro i _
      exact prefix_difference c i
  · rintro ⟨p, _, hp, hd⟩
    calc
      (∑ i ∈ range m, c i) =
          ∑ i ∈ range m, (p (i + 1) - p i) := by
        apply sum_congr rfl
        intro i hi
        exact (hd i (mem_range.mp hi)).symm
      _ = p m - p 0 := telescope p m
      _ = 0 := sub_eq_zero.mpr hp

def IsBoundary (m : ℕ) (a b e : ℕ → A) : Prop :=
  (∀ i < m, a i = 0 ∧ b i = 0) ∧
    ∃ p : ℕ → A, p m = p 0 ∧
      ∀ i < m, p (i + 1) - p i = e i

theorem homology_coordinates (m : ℕ) (a b e a' b' e' : ℕ → A)
    (he : (∑ i ∈ range m, e i) = 0)
    (he' : (∑ i ∈ range m, e' i) = 0) :
    IsBoundary m (fun i => a i - a' i) (fun i => b i - b' i)
        (fun i => e i - e' i) ↔
      ∀ i < m, a i = a' i ∧ b i = b' i := by
  constructor
  · intro h i hi
    exact ⟨sub_eq_zero.mp (h.1 i hi).1, sub_eq_zero.mp (h.1 i hi).2⟩
  · intro h
    refine ⟨?_, ?_⟩
    · intro i hi
      exact ⟨sub_eq_zero.mpr (h i hi).1, sub_eq_zero.mpr (h i hi).2⟩
    · have hsum : (∑ i ∈ range m, (e i - e' i)) = 0 := by
        rw [sum_sub_distrib, he, he']
        simp
      obtain ⟨p, _, hp, hd⟩ := (cyclic_exact m (fun i => e i - e' i)).mp hsum
      exact ⟨p, hp, hd⟩

end Cellular

section Differences

variable {I A : Type*} [AddCommGroup A]

def forward (s : Equiv.Perm I) (x : I → A) (i : I) : A :=
  x i - x (s i)

def backward (s : Equiv.Perm I) (x : I → A) (i : I) : A :=
  x i - x (s.symm i)

def laplacian (s : Equiv.Perm I) (x : I → A) (i : I) : A :=
  x i + x i - x (s i) - x (s.symm i)

theorem difference_composition (s : Equiv.Perm I) (x : I → A) :
    forward s (backward s x) = laplacian s x := by
  funext i
  simp only [forward, backward, laplacian, Equiv.symm_apply_apply]
  abel

def upperIntegral (s : Equiv.Perm I) (v : (I → A) × (I → A)) :
    (I → A) × (I → A) :=
  (v.1 + laplacian s v.2, v.2)

def upperIntegralInverse (s : Equiv.Perm I) (v : (I → A) × (I → A)) :
    (I → A) × (I → A) :=
  (v.1 - laplacian s v.2, v.2)

theorem integral_shear_inverse (s : Equiv.Perm I) (v : (I → A) × (I → A)) :
    upperIntegralInverse s (upperIntegral s v) = v := by
  apply Prod.ext
  · funext i
    simp [upperIntegralInverse, upperIntegral]
  · rfl

end Differences

section Evaluation

variable {R S k I J : Type*} [CommRing R] [CommRing S] [CommRing k]

theorem residual_evaluation (phi psi : R →+* S) (rho : S →+* k)
    (h : rho.comp phi = rho.comp psi) (M : I → J → R) :
    (fun i j => rho (phi (M i j))) = (fun i j => rho (psi (M i j))) := by
  funext i j
  exact congrArg (fun f : R →+* k => f (M i j)) h

theorem laplace_factor (u v : R) (huv : u * v = 1) :
    (1 - u) * (1 - v) = 2 - u - v := by
  calc
    (1 - u) * (1 - v) = 1 - u - v + u * v := by ring
    _ = 2 - u - v := by rw [huv]; ring

end Evaluation

section Fields

variable {K : Type*} [Field K]

theorem prime_power_root_is_one (p r : ℕ) [Fact p.Prime] [CharP K p]
    (z : K) (hz : z ^ (p ^ r) = 1) : z = 1 := by
  apply iterateFrobenius_inj K p r
  simpa [iterateFrobenius_def] using hz

theorem laplace_nonzero (u : K) (hu : u ≠ 0) (hne : u ≠ 1) :
    2 - u - u⁻¹ ≠ 0 := by
  rw [← laplace_factor u u⁻¹ (mul_inv_cancel₀ hu)]
  have hv : u⁻¹ ≠ 1 := by
    intro h
    have hprod := mul_inv_cancel₀ hu
    rw [h, mul_one] at hprod
    exact hne hprod
  exact mul_ne_zero (sub_ne_zero.mpr (Ne.symm hne))
    (sub_ne_zero.mpr (Ne.symm hv))

theorem no_common_invariant_line (c d x y : K) (hc : c ≠ 0) (hd : d ≠ 0)
    (hupper : x * y - (x + c * y) * y = 0)
    (hlower : x * (y + d * x) - x * y = 0) :
    x = 0 ∧ y = 0 := by
  have hcyy : c * (y * y) = 0 := by linear_combination -hupper
  have hdxx : d * (x * x) = 0 := by linear_combination hlower
  have hyy : y * y = 0 := (mul_eq_zero.mp hcyy).resolve_left hc
  have hxx : x * x = 0 := (mul_eq_zero.mp hdxx).resolve_left hd
  exact ⟨(mul_eq_zero.mp hxx).elim id id, (mul_eq_zero.mp hyy).elim id id⟩

end Fields

end GeometricPrimeSwitch
