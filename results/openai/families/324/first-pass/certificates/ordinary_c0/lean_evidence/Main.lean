import CompatibleSelection

open Set Filter Topology
open scoped NNReal BigOperators ZeroAtInfty
open OAI.C0Absorption

namespace Audit324
noncomputable section

theorem no_bounded_signs_lower {Γ : Type*} {B : CylinderBases Γ}
    (locT : TagLocalization B) (locR : RadiusLocalization B)
    (m : ℕ → SourceSpace B) (M r : ℝ) (hm : SignedBound m M) (hr : 0 < r)
    (hlower : ∀ i, r ≤ ‖m i‖) : False := by
  obtain ⟨d,δ,hδ,φ,hφ,F,hF⟩ :=
    one_class_detects (sourceClasses B) c0Origin m M r hr hlower hm.initial
  have hs : SignedBound (m ∘ φ) M := hm.subsequence hφ.injective
  have hnull : PairingNull (m ∘ φ) := by
    intro f hf
    exact hf.weak_null (sourceClasses B) c0Origin (m ∘ φ) M hs.initial
  obtain ⟨ψ,hψ,h,G,δ₁,K,hδ₁,hG,hdG,hLip⟩ :=
    compatible_selection locT locR (m ∘ φ) hnull F d
      (fun i => (hF i).1) hδ (fun i => (hF i).2)
  exact OAI.C0Absorption.compatible_detectors_false (sourceClasses B) c0Origin
    ((m ∘ φ) ∘ ψ) M (hs.subsequence hψ.injective) G h K hG hLip hδ₁ hdG

theorem noLinearC0_of_localization {Γ : Type*} {B : CylinderBases Γ}
    (locT : TagLocalization B) (locR : RadiusLocalization B) :
    NoLinearC0 (SourceSpace B) := by
  intro T hT
  obtain ⟨c,hc,hcT⟩ := hT
  let m (i : ℕ) := T (atom i)
  have hm : SignedBound m ‖T‖ := by
    intro n ι hι ε
    change ‖∑ i, realSign (ε i) • T (atom (ι i))‖ ≤ ‖T‖
    rw [show (∑ i, realSign (ε i) • T (atom (ι i))) =
      T (∑ i, realSign (ε i) • atom (ι i)) by simp only [map_sum, map_smul]]
    calc
      _ ≤ ‖T‖ * ‖∑ i, realSign (ε i) • atom (ι i)‖ := T.le_opNorm _
      _ ≤ ‖T‖ * 1 := mul_le_mul_of_nonneg_left
        (atoms_signed_bound n ι hι ε) (ContinuousLinearMap.opNorm_nonneg T)
      _ = ‖T‖ := mul_one _
  exact no_bounded_signs_lower locT locR m ‖T‖ c hm hc
    (fun i => by simpa only [atom_norm, mul_one] using hcT (atom i))

theorem ordinary_c0_obstruction : NoLinearC0 ConcreteSpace :=
  noLinearC0_of_localization concreteTagLocalization concreteRadiusLocalization

theorem exact_compatible_detectors
    (m : ℕ → ConcreteSpace) (hm : WeaklyNull m)
    (F : ℕ → C0Ball → ℝ) (d : ℕ)
    (hF : ∀ i, F i ∈ sourceClasses concreteBases d)
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤
      |completedPairing (sourceClasses concreteBases) c0Origin (F i) (m i)|) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧
      ∃ (h : ℕ) (G : ℕ → C0Ball → ℝ) (δ₁ : ℝ) (C : ℕ),
        0 < δ₁ ∧ 1 ≤ C ∧ (∀ i, G i ∈ sourceClasses concreteBases h) ∧
        (∀ i, δ₁ ≤
          |completedPairing (sourceClasses concreteBases) c0Origin (G i) (m (φ i))|) ∧
        ∀ (H : Finset ℕ) (ε : ℕ → ℝ), (∀ i ∈ H, |ε i| = 1) →
          LipschitzWith C (fun s => ∑ i ∈ H, ε i * G i s) :=
  full_compatible_selection concreteTagLocalization concreteRadiusLocalization
    m hm F d hF hδ hd

#print axioms Audit324.exact_compatible_detectors
#print axioms Audit324.no_bounded_signs_lower
#print axioms Audit324.noLinearC0_of_localization
#print axioms Audit324.ordinary_c0_obstruction

end
end Audit324
