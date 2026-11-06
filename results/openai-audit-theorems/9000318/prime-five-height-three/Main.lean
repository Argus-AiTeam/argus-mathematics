import Mathlib

namespace HeightThreeFiltration

section FilteredComparison

variable {R V W : Type*} [CommRing R]
  [AddCommGroup V] [Module R V]
  [AddCommGroup W] [Module R W]

theorem filtered_kernel
    (F : ℕ → Submodule R V) (G : ℕ → Submodule R W)
    (f : V →ₗ[R] W) (n : ℕ) (hF0 : F 0 = ⊥)
    (down : ∀ i < n, ∀ v ∈ F (i + 1), f v ∈ G i → v ∈ F i) :
    ∀ i ≤ n, ∀ v ∈ F i, f v = 0 → v = 0 := by
  intro i
  induction i with
  | zero =>
      intro _ v hv _
      simpa [hF0] using hv
  | succ i ih =>
      intro hi v hv hz
      have hin : i < n := by omega
      have hile : i ≤ n := by omega
      have hlower : v ∈ F i := down i hin v hv (by
        rw [hz]
        exact (G i).zero_mem)
      exact ih hile v hlower hz

theorem filtered_lifting
    (F : ℕ → Submodule R V) (G : ℕ → Submodule R W)
    (f : V →ₗ[R] W) (n : ℕ) (hG0 : G 0 = ⊥)
    (monoF : Monotone F)
    (up : ∀ i < n, ∀ w ∈ G (i + 1),
      ∃ v ∈ F (i + 1), w - f v ∈ G i) :
    ∀ i ≤ n, ∀ w ∈ G i, ∃ v ∈ F i, f v = w := by
  intro i
  induction i with
  | zero =>
      intro _ w hw
      have hz : w = 0 := by simpa [hG0] using hw
      subst w
      exact ⟨0, (F 0).zero_mem, f.map_zero⟩
  | succ i ih =>
      intro hi w hw
      have hin : i < n := by omega
      have hile : i ≤ n := by omega
      obtain ⟨v, hv, hrem⟩ := up i hin w hw
      obtain ⟨a, ha, heq⟩ := ih hile (w - f v) hrem
      refine ⟨a + v, (F (i + 1)).add_mem
        (monoF (Nat.le_succ i) ha) hv, ?_⟩
      rw [map_add, heq]
      exact sub_add_cancel w (f v)

theorem finite_filtered_bijective
    (F : ℕ → Submodule R V) (G : ℕ → Submodule R W)
    (f : V →ₗ[R] W) (n : ℕ)
    (hF0 : F 0 = ⊥) (hG0 : G 0 = ⊥)
    (hFn : F n = ⊤) (hGn : G n = ⊤)
    (monoF : Monotone F)
    (down : ∀ i < n, ∀ v ∈ F (i + 1), f v ∈ G i → v ∈ F i)
    (up : ∀ i < n, ∀ w ∈ G (i + 1),
      ∃ v ∈ F (i + 1), w - f v ∈ G i) :
    Function.Bijective f := by
  constructor
  · intro v w heq
    have hmem : v - w ∈ F n := by
      rw [hFn]
      exact Submodule.mem_top
    have hz : f (v - w) = 0 := by
      rw [map_sub, heq, sub_self]
    exact sub_eq_zero.mp
      (filtered_kernel F G f n hF0 down n (le_refl n) (v - w) hmem hz)
  · intro w
    have hmem : w ∈ G n := by
      rw [hGn]
      exact Submodule.mem_top
    obtain ⟨v, _, heq⟩ :=
      filtered_lifting F G f n hG0 monoF up n (le_refl n) w hmem
    exact ⟨v, heq⟩

end FilteredComparison

theorem degree_three_differential_window (r : ℕ) (hr : 2 ≤ r) :
    r - 1 < 7 ∨ 9 < 3 + r := by
  omega

theorem degree_three_positive_row_outside
    (r s : ℕ) (hr : 7 ≤ r) (hs : s = r + 3) : 9 < s := by
  omega

theorem degree_one_boundary_is_not_excluded :
    1 + 8 = (9 : ℕ) ∧ 8 - 1 = (7 : ℕ) := by
  decide

end HeightThreeFiltration
