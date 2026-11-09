import Mathlib

namespace TorInjection

abbrev Laurent (V : Type*) [Zero V] := ℤ →₀ V

def cutAbove {V : Type*} [Zero V] (n : ℤ) (f : Laurent V) : Laurent V :=
  f.filter (fun j => n ≤ j)

def Above {V : Type*} [Zero V] (n : ℤ) (f : Laurent V) : Prop :=
  ∀ j, j < n → f j = 0

def AtFloor {V : Type*} [Zero V] (n : ℤ) (f : Laurent V) : Prop :=
  ∀ j, j ≠ n → f j = 0

theorem cutAbove_above {V : Type*} [Zero V] (n : ℤ) (f : Laurent V) :
    Above n (cutAbove n f) := by
  intro j hj
  simp [cutAbove, not_le.mpr hj]

theorem cutAbove_eq {V : Type*} [Zero V] {n : ℤ} {f : Laurent V}
    (hf : Above n f) : cutAbove n f = f := by
  ext j
  by_cases hj : n ≤ j
  · simp [cutAbove, hj]
  · have hz := hf j (lt_of_not_ge hj)
    simp [cutAbove, hj, hz]

variable {R V W : Type*} [Ring R]
  [AddCommGroup V] [Module R V] [AddCommGroup W] [Module R W]

def RaisesOne (d : Laurent V →ₗ[R] Laurent W) : Prop :=
  ∃ δ : ℤ → V →ₗ[R] W, ∀ f j, (d f) (j + 1) = δ j (f j)

theorem cutAbove_commutes (d : Laurent V →ₗ[R] Laurent W)
    (hd : RaisesOne d) (n : ℤ) (f : Laurent V) :
    d (cutAbove n f) = cutAbove (n + 1) (d f) := by
  obtain ⟨δ, hδ⟩ := hd
  ext j
  obtain ⟨a, rfl⟩ : ∃ a : ℤ, j = a + 1 := ⟨j - 1, by omega⟩
  by_cases ha : n ≤ a
  · simp [cutAbove, hδ, ha]
  · simp [cutAbove, hδ, ha]

theorem boundary_above (d : Laurent V →ₗ[R] Laurent W)
    (hd : RaisesOne d) {n : ℤ} {f : Laurent V} (hf : Above n f) :
    Above (n + 1) (d f) := by
  rw [← cutAbove_eq hf, cutAbove_commutes d hd]
  exact cutAbove_above (n + 1) (d f)

variable {V₀ V₁ V₂ : Type*}
  [AddCommGroup V₀] [Module R V₀]
  [AddCommGroup V₁] [Module R V₁]
  [AddCommGroup V₂] [Module R V₂]

theorem fill_above_floor
    (d₁ : Laurent V₁ →ₗ[R] Laurent V₀)
    (d₂ : Laurent V₂ →ₗ[R] Laurent V₁)
    (hd₂ : RaisesOne d₂)
    (hexact : ∀ z, d₁ z = 0 → ∃ y, d₂ y = z)
    (n : ℤ) (z : Laurent V₁)
    (hz : d₁ z = 0) (hs : Above (n + 1) z) :
    ∃ y, Above n y ∧ d₂ y = z := by
  obtain ⟨y, hy⟩ := hexact z hz
  refine ⟨cutAbove n y, cutAbove_above n y, ?_⟩
  rw [cutAbove_commutes d₂ hd₂, hy, cutAbove_eq hs]

theorem floor_representative
    (d₁ : Laurent V₁ →ₗ[R] Laurent V₀)
    (d₂ : Laurent V₂ →ₗ[R] Laurent V₁)
    (hd₁ : RaisesOne d₁) (hd₂ : RaisesOne d₂)
    (hexact : ∀ z, d₁ z = 0 → ∃ y, d₂ y = z)
    (n : ℤ) (z : Laurent V₁)
    (hz : d₁ z = 0) (hs : Above n z) :
    ∃ f y, AtFloor n f ∧ d₁ f = 0 ∧ Above n y ∧ z = f + d₂ y := by
  have hcycle : d₁ (cutAbove (n + 1) z) = 0 := by
    rw [cutAbove_commutes d₁ hd₁, hz]
    ext j
    simp [cutAbove, Finsupp.filter_apply]
  obtain ⟨y, hys, hy⟩ :=
    fill_above_floor d₁ d₂ hd₂ hexact n (cutAbove (n + 1) z)
      hcycle (cutAbove_above (n + 1) z)
  refine ⟨z - cutAbove (n + 1) z, y, ?_, ?_, hys, ?_⟩
  · intro j hj
    by_cases h : j < n
    · have hzero := hs j h
      have hcut : ¬n < j := by omega
      simp [cutAbove, hzero, hcut]
    · have hcut : n < j := by omega
      simp [cutAbove, hcut]
  · rw [map_sub, hz, hcycle, sub_self]
  · rw [hy, sub_add_cancel]

theorem floor_boundary_zero
    (d₂ : Laurent V₂ →ₗ[R] Laurent V₁)
    (hd₂ : RaisesOne d₂)
    (n : ℤ) (f : Laurent V₁)
    (hf : AtFloor n f)
    (hb : ∃ y, Above n y ∧ d₂ y = f) :
    f = 0 := by
  obtain ⟨y, hy, rfl⟩ := hb
  have h := boundary_above d₂ hd₂ hy
  ext j
  by_cases hj : j = n
  · subst j
    exact h n (by omega)
  · exact hf j hj

end TorInjection
