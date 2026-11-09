import Mathlib.Algebra.CharZero.Defs
import Mathlib.Algebra.Field.Basic
import Mathlib.Algebra.Module.LinearMap.End
import Mathlib.Tactic.Module
import Lean.Elab.Tactic.Omega

namespace SquareStabilization

variable {K M : Type*} [Field K] [AddCommGroup M] [Module K M]

/-- Applying the lowering operator `n` times lowers the weight by `2 * n`. -/
theorem weight_lowering_power
    (D H : Module.End K M)
    (hHD : ∀ u : M, H (D u) = D (H u) - (2 : K) • D u)
    {v : M} {w : K} (hv : H v = w • v) (n : ℕ) :
    H ((D ^ n) v) = (w - 2 * (n : K)) • ((D ^ n) v) := by
  induction n with
  | zero => simpa using hv
  | succ n ih =>
      rw [pow_succ', Module.End.mul_apply, hHD, ih, map_smul]
      simp only [Nat.cast_succ]
      module

/-- The exact raising/lowering power identity, for an arbitrary scalar weight. -/
theorem raising_lowering_power
    (D E H : Module.End K M)
    (hED : ∀ u : M, E (D u) = D (E u) + H u)
    (hHD : ∀ u : M, H (D u) = D (H u) - (2 : K) • D u)
    {v : M} {w : K} (hv : H v = w • v) (n : ℕ) :
    E ((D ^ (n + 1)) v) =
      (D ^ (n + 1)) (E v) +
        (((n : K) + 1) * (w - (n : K))) • ((D ^ n) v) := by
  induction n with
  | zero => simpa [hv] using hED v
  | succ n ih =>
      calc
        E ((D ^ (n + 1 + 1)) v) =
            D (E ((D ^ (n + 1)) v)) + H ((D ^ (n + 1)) v) := by
              rw [pow_succ', Module.End.mul_apply, hED]
        _ = D ((D ^ (n + 1)) (E v) +
              (((n : K) + 1) * (w - (n : K))) • ((D ^ n) v)) +
            (w - 2 * ((n + 1 : ℕ) : K)) • ((D ^ (n + 1)) v) := by
              rw [ih, weight_lowering_power D H hHD hv (n + 1)]
        _ = _ := by
          simp only [map_add, map_smul, pow_succ', Module.End.mul_apply, Nat.cast_succ]
          module

variable [CharZero K]

/-- A primitive vector of natural weight `w` is not killed by `D ^ L` for `L ≤ w`,
unless the vector itself is zero. -/
theorem primitive_power_injective
    (D E H : Module.End K M)
    (hED : ∀ u : M, E (D u) = D (E u) + H u)
    (hHD : ∀ u : M, H (D u) = D (H u) - (2 : K) • D u)
    {v : M} {w : ℕ} (hv : H v = (w : K) • v) (hEv : E v = 0) :
    ∀ L : ℕ, L ≤ w → (D ^ L) v = 0 → v = 0 := by
  intro L
  induction L with
  | zero =>
      intro _ hD
      simpa using hD
  | succ n ih =>
      intro hL hD
      have hscalar : ((n : K) + 1) * ((w : K) - (n : K)) ≠ 0 := by
        apply mul_ne_zero (Nat.cast_add_one_ne_zero n)
        apply sub_ne_zero.mpr
        intro heq
        have hne : w ≠ n := by omega
        exact hne (Nat.cast_injective heq)
      have hstring := raising_lowering_power D E H hED hHD hv n
      rw [hD, map_zero, hEv, map_zero, zero_add] at hstring
      have hDn : (D ^ n) v = 0 := by
        have hcancel := congrArg
          (fun u : M => ((((n : K) + 1) * ((w : K) - (n : K)))⁻¹) • u)
          hstring.symm
        simpa only [smul_smul, inv_mul_cancel₀ hscalar, one_smul, smul_zero] using hcancel
      exact ih (by omega) hDn

/-- Power-injectivity with an explicit, vector-specific raising-nilpotence bound.
No finite-dimensionality or semisimplicity is assumed. -/
theorem sl2_power_injective_of_nilpotent_bound
    (D E H : Module.End K M)
    (hED : ∀ u : M, E (D u) = D (E u) + H u)
    (hHD : ∀ u : M, H (D u) = D (H u) - (2 : K) • D u)
    (hHE : ∀ u : M, H (E u) = E (H u) + (2 : K) • E u)
    (N : ℕ) :
    ∀ {v : M} {w L : ℕ},
      L ≤ w → H v = (w : K) • v →
      (E ^ N) v = 0 → (D ^ L) v = 0 → v = 0 := by
  induction N with
  | zero =>
      intro v w L _ _ hnil _
      simpa using hnil
  | succ N ih =>
      intro v w L hL hv hnil hD
      have hEv_weight : H (E v) = ((w + 2 : ℕ) : K) • E v := by
        rw [hHE, hv, map_smul]
        simp only [Nat.cast_add, Nat.cast_ofNat]
        module
      have hEv_nil : (E ^ N) (E v) = 0 := by
        simpa only [pow_succ, Module.End.mul_apply] using hnil
      have hDnext : (D ^ (L + 1)) v = 0 := by
        rw [pow_succ', Module.End.mul_apply, hD, map_zero]
      have hEv_D : (D ^ (L + 1)) (E v) = 0 := by
        have hstring := raising_lowering_power D E H hED hHD hv L
        rw [hDnext, map_zero, hD, smul_zero, add_zero] at hstring
        exact hstring.symm
      have hEv : E v = 0 :=
        ih (v := E v) (w := w + 2) (L := L + 1)
          (by omega) hEv_weight hEv_nil hEv_D
      exact primitive_power_injective D E H hED hHD hv hEv L hL hD

/-- The universal `sl₂` whole-power kernel theorem: local nilpotence is required
only at the vector under consideration. -/
theorem sl2_power_injective
    (D E H : Module.End K M)
    (hED : ∀ u : M, E (D u) = D (E u) + H u)
    (hHD : ∀ u : M, H (D u) = D (H u) - (2 : K) • D u)
    (hHE : ∀ u : M, H (E u) = E (H u) + (2 : K) • E u)
    {v : M} {w L : ℕ}
    (hL : L ≤ w) (hv : H v = (w : K) • v)
    (hnil : ∃ N : ℕ, (E ^ N) v = 0) (hD : (D ^ L) v = 0) :
    v = 0 := by
  obtain ⟨N, hN⟩ := hnil
  exact sl2_power_injective_of_nilpotent_bound D E H hED hHD hHE N hL hv hN hD

end SquareStabilization
