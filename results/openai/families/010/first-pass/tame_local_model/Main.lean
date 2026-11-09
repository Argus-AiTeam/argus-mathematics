import Mathlib

namespace TameLocalModel

theorem normal_monomial_exponents_injective
    (eps j k l m eps' j' k' l' m' : ℕ)
    (he : eps ≤ 1) (he' : eps' ≤ 1)
    (hn : j = 0 ∨ m = 0) (hn' : j' = 0 ∨ m' = 0)
    (ha : eps + 2 * (k + m) = eps' + 2 * (k' + m'))
    (hb : (j : ℤ) - (k : ℤ) - 2 * (m : ℤ) =
      (j' : ℤ) - (k' : ℤ) - 2 * (m' : ℤ))
    (hc : l + m = l' + m') :
    eps = eps' ∧ j = j' ∧ k = k' ∧ l = l' ∧ m = m' := by
  rcases hn with hj | hm <;> rcases hn' with hj' | hm' <;> omega

theorem saturated_principal_intersection
    {R : Type*} [CommRing R] (J C : Ideal R) (t : R)
    (hJC : J ≤ C)
    (hsat : ∀ r : R, t * r ∈ C → r ∈ C) :
    C ⊓ (J ⊔ Ideal.span {t}) = J ⊔ Ideal.span {t} * C := by
  ext x
  constructor
  · intro hx
    rcases Submodule.mem_sup.mp hx.2 with ⟨j, hj, y, hy, hsum⟩
    rcases Ideal.mem_span_singleton.mp hy with ⟨r, rfl⟩
    have htr : t * r ∈ C := by
      have hsub := C.sub_mem hx.1 (hJC hj)
      have heq : x - j = t * r := by
        rw [← hsum]
        ring
      simpa only [heq] using hsub
    have hr : r ∈ C := hsat r htr
    exact Submodule.mem_sup.mpr
      ⟨j, hj, t * r,
        Ideal.mul_mem_mul (Ideal.subset_span (by simp)) hr, hsum⟩
  · intro hx
    rcases Submodule.mem_sup.mp hx with ⟨j, hj, y, hy, hsum⟩
    rcases Ideal.mem_span_singleton_mul.mp hy with ⟨r, hr, rfl⟩
    constructor
    · rw [← hsum]
      exact C.add_mem (hJC hj) (C.mul_mem_left t hr)
    · exact Submodule.mem_sup.mpr
        ⟨j, hj, t * r, Ideal.mem_span_singleton.mpr ⟨r, rfl⟩, hsum⟩

theorem tame_nilpotent_relations
    {R : Type*} [CommRing R] (a b c t : R)
    (hF : a ^ 2 + b * c = 0) (hbt : b * t = 0) (hct : c * t = 0) :
    (a * t) ^ 2 = 0 ∧ a * (a * t) = 0 ∧
      b * (a * t) = 0 ∧ c * (a * t) = 0 := by
  have hsquare : (a * t) ^ 2 =
      (a ^ 2 + b * c) * t ^ 2 - (b * t) * (c * t) := by ring
  have ha : a * (a * t) = (a ^ 2 + b * c) * t - c * (b * t) := by ring
  have hb : b * (a * t) = a * (b * t) := by ring
  have hc : c * (a * t) = a * (c * t) := by ring
  constructor
  · rw [hsquare, hF, hbt]
    simp
  constructor
  · rw [ha, hF, hbt]
    simp
  constructor
  · rw [hb, hbt]
    simp
  · rw [hc, hct]
    simp

end TameLocalModel
