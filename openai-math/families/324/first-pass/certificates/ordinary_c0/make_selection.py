#!/usr/bin/env python3
"""Re-abstract the upstream detection induction over its two actual inputs."""

from pathlib import Path
import re


HERE = Path(__file__).resolve().parent
UPSTREAM = Path("openai-math/lean")
PREFIX = Path("OAI/Analysis/C0Absorption")

HEADER = r"""import OAI.Analysis.C0Absorption.Tags

open Set Filter Topology
open scoped NNReal BigOperators ZeroAtInfty
open OAI.C0Absorption

namespace Audit324
noncomputable section

variable {Γ : Type*} {B : CylinderBases Γ}

def PairingNull (m : ℕ → SourceSpace B) : Prop :=
  ∀ f : C0Ball → ℝ, BoundedTest (sourceClasses B) c0Origin f →
    Tendsto (fun i => completedPairing (sourceClasses B) c0Origin f (m i))
      atTop (nhds 0)

def CompatibleSubsequence (m : ℕ → SourceSpace B) : Prop :=
  ∃ φ : ℕ → ℕ, StrictMono φ ∧
    ∃ (h : ℕ) (F : ℕ → C0Ball → ℝ) (δ : ℝ) (K : ℝ≥0),
      0 < δ ∧ (∀ i, F i ∈ sourceClasses B h) ∧
      (∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m (φ i))|) ∧
      ∀ n (ε : Fin n → ℝ), (∀ i, |ε i| = 1) →
        LipschitzWith K (fun s => ∑ i, ε i * F i s)

def NoCompatible (m : ℕ → SourceSpace B) : Prop :=
  ¬ CompatibleSubsequence m

theorem PairingNull.subsequence {m : ℕ → SourceSpace B} (hm : PairingNull m)
    {φ : ℕ → ℕ} (hφ : StrictMono φ) : PairingNull (m ∘ φ) := by
  intro f hf
  exact (hm f hf).comp hφ.tendsto_atTop

theorem NoCompatible.subsequence {m : ℕ → SourceSpace B} (hn : NoCompatible m)
    {φ : ℕ → ℕ} (hφ : StrictMono φ) : NoCompatible (m ∘ φ) := by
  rintro ⟨ψ, hψ, h, F, δ, K, hδ, hF, hd, hLip⟩
  exact hn ⟨φ ∘ ψ, hφ.comp hψ, h, F, δ, K, hδ, hF, hd, hLip⟩

theorem compatible_detectors_false
    (m : ℕ → SourceSpace B) (_hm : PairingNull m) (hn : NoCompatible m)
    (F : ℕ → C0Ball → ℝ) (h : ℕ) (K : ℝ≥0)
    (hF : ∀ i, F i ∈ sourceClasses B h)
    (hLip : ∀ n (ε : Fin n → ℝ), (∀ i, |ε i| = 1) →
      LipschitzWith K (fun s => ∑ i, ε i * F i s))
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|) :
    False :=
  hn ⟨id, strictMono_id, h, F, δ, K, hδ, hF, hd, hLip⟩

theorem VClass_compatible_false
    (m : ℕ → SourceSpace B) (hm : PairingNull m) (hn : NoCompatible m)
    (F : ℕ → C0Ball → ℝ) (h : ℕ) (K : ℝ≥0)
    (hF : ∀ i, F i ∈ VClass B h)
    (hLip : ∀ n (ε : Fin n → ℝ), (∀ i, |ε i| = 1) →
      LipschitzWith K (fun s => ∑ i, ε i * F i s))
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|) :
    False := by
  apply compatible_detectors_false m hm hn F (2*h+1) K ?_ hLip hδ hd
  intro i
  simpa only [sourceClasses_odd] using VClass_mono (Nat.le_succ h) (hF i)

theorem VClass_disjoint_false
    (m : ℕ → SourceSpace B) (hm : PairingNull m) (hn : NoCompatible m)
    (F : ℕ → C0Ball → ℝ) (h : ℕ) (hF : ∀ i, F i ∈ VClass B h)
    (hdisj : Pairwise (fun i j => Disjoint (tsupport (F i)) (tsupport (F j))))
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|) :
    False := by
  refine VClass_compatible_false m hm hn F h
    (4^h*B.L0+h*4^h*B.A) hF ?_ hδ hd
  intro n ε hε
  apply disjoint_supports_signed_lipschitz (convex_closedBall (0 : C0) 1)
    (fun i : Fin n => F i) (4^h*B.L0+h*4^h*B.A)
    (fun i => VClass_lipschitz B h (hF i)) ?_ ε hε
  intro i j hij
  exact hdisj (show (i : ℕ) ≠ (j : ℕ) from fun he => hij (Fin.ext he))

theorem tail_escape_false
    (F : ℕ → C0Ball → ℝ) (m : ℕ → SourceSpace B)
    (h : ℕ) (hF : ∀ i, F i ∈ VClass B h)
    (hm : PairingNull m) (hn : NoCompatible m)
    {δ cstar : ℝ} (hδ : 0 < δ) (hcstar : 0 < cstar)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|)
    (N : ℕ → ℕ) (hN : Tendsto N atTop atTop)
    (hs : ∀ i s, s ∈ tsupport (F i) → cstar ≤ tau (N i) s.val) : False := by
  obtain ⟨H,φ,hφ,G,hG,hdG,hdis⟩ :=
    tail_separation F m hF hδ hcstar hd N hN hs
  exact VClass_disjoint_false (m ∘ φ) (hm.subsequence hφ) (hn.subsequence hφ)
    G H hG hdis (half_pos hδ) hdG

"""

FOOTER = r"""

theorem compatible_selection (locT : TagLocalization B) (locR : RadiusLocalization B)
    (m : ℕ → SourceSpace B) (hm : PairingNull m)
    (F : ℕ → C0Ball → ℝ) (d : ℕ) (hF : ∀ i, F i ∈ sourceClasses B d)
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|) :
    CompatibleSubsequence m := by
  by_contra hn
  exact source_detectors_false locT locR m hm hn F d hF hδ hd

def WeaklyNull (m : ℕ → SourceSpace B) : Prop :=
  ∀ u : SourceSpace B →L[ℝ] ℝ, Tendsto (fun i => u (m i)) atTop (nhds 0)

theorem weaklyNull_pairingNull {m : ℕ → SourceSpace B} (hm : WeaklyNull m) :
    PairingNull m := by
  intro f hf
  obtain ⟨A,hA⟩ := hf
  have hh := hm (completedTest (sourceClasses B) c0Origin f A hA)
  simpa only [completedTest_eq] using hh

theorem weakly_null_compatible_selection
    (locT : TagLocalization B) (locR : RadiusLocalization B)
    (m : ℕ → SourceSpace B) (hm : WeaklyNull m)
    (F : ℕ → C0Ball → ℝ) (d : ℕ) (hF : ∀ i, F i ∈ sourceClasses B d)
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|) :
    CompatibleSubsequence m :=
  compatible_selection locT locR m (weaklyNull_pairingNull hm) F d hF hδ hd

theorem finite_signed_lipschitz {X : Type*} [PseudoMetricSpace X]
    (F : ℕ → X → ℝ) (K : ℝ≥0)
    (h : ∀ n (ε : Fin n → ℝ), (∀ i, |ε i| = 1) →
      LipschitzWith K (fun x => ∑ i, ε i * F i x))
    (H : Finset ℕ) (ε : ℕ → ℝ) (hε : ∀ i ∈ H, |ε i| = 1) :
    LipschitzWith K (fun x => ∑ i ∈ H, ε i * F i x) := by
  classical
  let n := H.sup id + 1
  have hH : H ⊆ Finset.range n := by
    intro i hi
    apply Finset.mem_range.mpr
    exact Nat.lt_succ_of_le (Finset.le_sup (f := id) hi)
  let a (i : Fin n) : ℝ := if (i : ℕ) ∈ H then ε i else 1
  let b (i : Fin n) : ℝ := if (i : ℕ) ∈ H then ε i else -1
  have ha : ∀ i, |a i| = 1 := by
    intro i
    dsimp [a]
    split_ifs with hi
    · exact hε i hi
    · norm_num
  have hb : ∀ i, |b i| = 1 := by
    intro i
    dsimp [b]
    split_ifs with hi
    · exact hε i hi
    · norm_num
  let A (x : X) := ∑ i : Fin n, a i * F i x
  let D (x : X) := ∑ i : Fin n, b i * F i x
  let S (x : X) := ∑ i ∈ H, ε i * F i x
  have he (x : X) : A x + D x = 2 * S x := by
    calc
      _ = ∑ i : Fin n, (if (i : ℕ) ∈ H then 2 * (ε i * F i x) else 0) := by
        rw [← Finset.sum_add_distrib]
        apply Finset.sum_congr rfl
        intro i _
        dsimp [a, b]
        split_ifs <;> ring
      _ = ∑ i ∈ Finset.range n, (if i ∈ H then 2 * (ε i * F i x) else 0) :=
        (Finset.sum_range
          (fun i : ℕ => if i ∈ H then 2 * (ε i * F i x) else 0)).symm
      _ = ∑ i ∈ H, 2 * (ε i * F i x) := by
        calc
          _ = ∑ i ∈ H, (if i ∈ H then 2 * (ε i * F i x) else 0) :=
            (Finset.sum_subset hH (by intro i _ hi; simp only [hi, ↓reduceIte])).symm
          _ = _ := Finset.sum_congr rfl (by intro i hi; simp only [hi, ↓reduceIte])
      _ = _ := (Finset.mul_sum H (fun i => ε i * F i x) 2).symm
  apply LipschitzWith.of_dist_le_mul
  intro x y
  have hA := (h n a ha).dist_le_mul x y
  have hD := (h n b hb).dist_le_mul x y
  change |A x - A y| ≤ (K : ℝ) * dist x y at hA
  change |D x - D y| ≤ (K : ℝ) * dist x y at hD
  have hid : (A x - A y) + (D x - D y) = 2 * (S x - S y) := by
    linarith [he x, he y]
  have hab := abs_add_le (A x - A y) (D x - D y)
  rw [hid, abs_mul, abs_of_pos (by norm_num : (0 : ℝ) < 2)] at hab
  change |S x - S y| ≤ (K : ℝ) * dist x y
  linarith

theorem full_compatible_selection
    (locT : TagLocalization B) (locR : RadiusLocalization B)
    (m : ℕ → SourceSpace B) (hm : WeaklyNull m)
    (F : ℕ → C0Ball → ℝ) (d : ℕ) (hF : ∀ i, F i ∈ sourceClasses B d)
    {δ : ℝ} (hδ : 0 < δ)
    (hd : ∀ i, δ ≤ |completedPairing (sourceClasses B) c0Origin (F i) (m i)|) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧
      ∃ (h : ℕ) (G : ℕ → C0Ball → ℝ) (δ₁ : ℝ) (C : ℕ),
        0 < δ₁ ∧ 1 ≤ C ∧ (∀ i, G i ∈ sourceClasses B h) ∧
        (∀ i, δ₁ ≤ |completedPairing (sourceClasses B) c0Origin (G i) (m (φ i))|) ∧
        ∀ (H : Finset ℕ) (ε : ℕ → ℝ), (∀ i ∈ H, |ε i| = 1) →
          LipschitzWith C (fun s => ∑ i ∈ H, ε i * G i s) := by
  obtain ⟨φ,hφ,h,G,δ₁,K,hδ₁,hG,hdG,hLip⟩ :=
    weakly_null_compatible_selection locT locR m hm F d hF hδ hd
  obtain ⟨C,hC⟩ := exists_nat_gt (K : ℝ)
  have hCpos : 0 < (C : ℝ) := lt_of_le_of_lt K.coe_nonneg hC
  have hCN : 1 ≤ C := by exact_mod_cast hCpos
  have hKC : K ≤ (C : ℝ≥0) := by exact_mod_cast hC.le
  refine ⟨φ,hφ,h,G,δ₁,C,hδ₁,hCN,hG,hdG,?_⟩
  intro H ε hε
  exact (finite_signed_lipschitz G K hLip H ε hε).weaken hKC

end
end Audit324
"""


def source(name):
    exact = HERE / "manuscript_src" / PREFIX / (name + ".lean")
    local = HERE / "compat" / PREFIX / (name + ".lean")
    path = exact if exact.exists() else local if local.exists() else UPSTREAM / PREFIX / (name + ".lean")
    return path.read_text()


def section(text, start, stop):
    return start + text.split(start, 1)[1].split(stop, 1)[0]


def abstract_inputs(text):
    text = text.replace(
        "(M : ℝ) (hm : SignedBound m M)",
        "(hm : PairingNull m) (hNo : NoCompatible m)",
    )
    text = text.replace(
        "(M : ℝ), SignedBound m M →",
        ", PairingNull m → NoCompatible m →",
    )
    text = text.replace(
        "(hf.weak_null (sourceClasses B) c0Origin m M hm.initial).abs",
        "(hm f hf).abs",
    )
    text = re.sub(
        r" M\s+\(hm\.subsequence ([^\n]+?)\.injective\)",
        lambda match: (
            f" (hm.subsequence {match[1]}) (hNo.subsequence {match[1]})"
        ),
        text,
    )
    text = text.replace(" M hm", " hm hNo")
    text = text.replace(
        "compatible_detectors_false (sourceClasses B) c0Origin",
        "compatible_detectors_false",
    )
    if "SignedBound" in text or re.search(r"\bM\b", text):
        remaining = [
            line for line in text.splitlines()
            if "SignedBound" in line or re.search(r"\bM\b", line)
        ]
        raise RuntimeError("Unabstracted induction inputs: " + repr(remaining))
    return text


def main():
    operations = source("Operations")
    detection = source("Detection")
    small = section(
        operations, "theorem small_remainders_false", "\nend\nend C0Absorption"
    )
    tail = section(
        detection, "theorem constant_detector_false", "\nend\nend C0Absorption"
    )
    fixed = section(
        detection, "theorem fixed_cylinder_tails_false {", "\nend\nend C0Absorption"
    )
    repeated = section(
        detection, "theorem repeated_label_false_aux", "\nend\nend C0Absorption"
    )
    general = section(
        detection, "theorem bounded_band_detectors_false",
        "\ntheorem source_no_bounded_signs_lower",
    )
    text = HEADER + "\n\n".join(
        abstract_inputs(part)
        for part in [small, tail, fixed, "variable {γ : Γ}\n\n" + repeated, general]
    ) + FOOTER
    destination = HERE / "CompatibleSelection.lean"
    if not destination.exists() or destination.read_text() != text:
        destination.write_text(text)
    print(f"Generated {destination.name}: {len(text.splitlines())} lines")


if __name__ == "__main__":
    main()
