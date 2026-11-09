import Mathlib

open scoped BigOperators

namespace FamilyOrbitLocalization

theorem finite_geometric_remainder {A : Type*} [CommRing A] (x : A) (N : ℕ) :
    (1 - x) * (∑ j ∈ Finset.range N, x ^ j) = 1 - x ^ N := by
  induction N with
  | zero => simp
  | succ N ih =>
      rw [Finset.sum_range_succ, mul_add, ih, pow_succ]
      ring

def nilpotentResolvent {A : Type*} [CommRing A] (u ν : A) (N : ℕ) : A :=
  u * ∑ j ∈ Finset.range N, (-ν * u) ^ j

theorem nilpotent_resolvent_inverse {A : Type*} [CommRing A]
    (t u ν : A) (N : ℕ) (hu : t * u = 1) (hν : ν ^ N = 0) :
    (t + ν) * nilpotentResolvent u ν N = 1 := by
  have hx : (-ν * u) ^ N = 0 := by
    calc
      (-ν * u) ^ N = ((-1 : A) * ν * u) ^ N := by congr 1 <;> ring
      _ = 0 := by simp only [mul_pow, hν, mul_zero, zero_mul]
  have ht : (t + ν) * u = 1 - (-ν * u) := by
    rw [add_mul, hu]
    ring
  rw [nilpotentResolvent, ← mul_assoc, ht, finite_geometric_remainder, hx]
  simp

theorem nilpotent_resolvent_unique {A : Type*} [CommRing A]
    (t u ν v : A) (N : ℕ) (hu : t * u = 1) (hν : ν ^ N = 0)
    (hv : (t + ν) * v = 1) :
    v = nilpotentResolvent u ν N := by
  have hr := nilpotent_resolvent_inverse t u ν N hu hν
  calc
    v = v * 1 := (mul_one v).symm
    _ = v * ((t + ν) * nilpotentResolvent u ν N) := by rw [hr]
    _ = ((t + ν) * v) * nilpotentResolvent u ν N := by ring
    _ = nilpotentResolvent u ν N := by rw [hv, one_mul]

section LinearMoments

variable {K V W U J : Type*} [CommRing K]
variable [AddCommGroup V] [Module K V]
variable [AddCommGroup W] [Module K W]
variable [AddCommGroup U] [Module K U] [Fintype J]

theorem joint_moment_naturality
    (P : V →ₗ[K] W) (L : W →ₗ[K] U) (c : J → K) (h : J → V) :
    L (∑ j, c j • P (h j)) = ∑ j, c j • (L.comp P) (h j) := by
  simp only [map_sum, map_smul, LinearMap.comp_apply]

theorem joint_dressing_naturality
    (L : W →ₗ[K] U) (D : J → V →ₗ[K] W) (h : J → V) :
    L (∑ j, D j (h j)) = ∑ j, (L.comp (D j)) (h j) := by
  simp only [map_sum, LinearMap.comp_apply]

end LinearMoments

section MultilinearContractions

variable {K I : Type*} [CommRing K] [Fintype I] [DecidableEq I]
variable {V : I → Type*} [∀ i, AddCommGroup (V i)] [∀ i, Module K (V i)]
variable {W : Type*} [AddCommGroup W] [Module K W]
variable {J : I → Type*} [∀ i, Fintype (J i)]

theorem all_flag_contraction
    (F : MultilinearMap K V W) (c : ∀ i, J i → K)
    (h : ∀ i, J i → V i) :
    F (fun i => ∑ j, c i j • h i j) =
      ∑ choice : ∀ i, J i,
        (∏ i, c i (choice i)) • F (fun i => h i (choice i)) := by
  rw [F.map_sum]
  apply Finset.sum_congr rfl
  intro choice _
  exact F.map_smul_univ (fun i => c i (choice i)) (fun i => h i (choice i))

end MultilinearContractions

end FamilyOrbitLocalization
