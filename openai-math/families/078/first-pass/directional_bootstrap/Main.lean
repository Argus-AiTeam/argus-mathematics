import Mathlib

open scoped BigOperators

namespace DirectionalBootstrap

def blockMass {A B : Type*} (p : A → B → ℝ)
    (I : Finset A) (J : Finset B) : ℝ :=
  ∑ a ∈ I, ∑ b ∈ J, p a b

theorem two_sided_core
    {A B : Type*} [Fintype A] [Fintype B]
    [DecidableEq A] [DecidableEq B]
    (p : A → B → ℝ) (mu : A → ℝ) (nu : B → ℝ)
    (hp : ∀ a b, 0 ≤ p a b)
    (hmu : ∀ a, 0 ≤ mu a) (hnu : ∀ b, 0 ≤ nu b)
    (hmu_sum : ∑ a, mu a = 1) (hnu_sum : ∑ b, nu b = 1)
    (delta : ℝ) (hdelta : 0 ≤ delta) :
    ∃ I : Finset A, ∃ J : Finset B,
      0 ≤ blockMass p I J ∧
      blockMass p Finset.univ Finset.univ - 2 * delta ≤ blockMass p I J ∧
      (∀ a ∈ I, delta * mu a ≤ ∑ b ∈ J, p a b) ∧
      (∀ b ∈ J, delta * nu b ≤ ∑ a ∈ I, p a b) := by
  classical
  let potential : Finset A × Finset B → ℝ := fun ij =>
    blockMass p ij.1 ij.2 -
      delta * (∑ a ∈ ij.1, mu a) - delta * (∑ b ∈ ij.2, nu b)
  obtain ⟨ij, _, hmax⟩ :=
    Finset.exists_max_image
      (Finset.univ : Finset (Finset A × Finset B)) potential
      (by exact ⟨(∅, ∅), Finset.mem_univ _⟩)
  rcases ij with ⟨I, J⟩
  refine ⟨I, J, ?_, ?_, ?_, ?_⟩
  · exact Finset.sum_nonneg fun a _ =>
      Finset.sum_nonneg fun b _ => hp a b
  · have hfull := hmax (Finset.univ, Finset.univ) (Finset.mem_univ _)
    dsimp [potential] at hfull
    rw [hmu_sum, hnu_sum] at hfull
    have hleft : 0 ≤ delta * (∑ a ∈ I, mu a) :=
      mul_nonneg hdelta (Finset.sum_nonneg fun a _ => hmu a)
    have hright : 0 ≤ delta * (∑ b ∈ J, nu b) :=
      mul_nonneg hdelta (Finset.sum_nonneg fun b _ => hnu b)
    linarith
  · intro a ha
    have hcompare := hmax (I.erase a, J) (Finset.mem_univ _)
    dsimp [potential] at hcompare
    have hmass :
        blockMass p (I.erase a) J =
          blockMass p I J - (∑ b ∈ J, p a b) := by
      have h := Finset.sum_erase_add I (fun x => ∑ b ∈ J, p x b) ha
      dsimp [blockMass]
      linarith only [h]
    have hweight :
        (∑ x ∈ I.erase a, mu x) = (∑ x ∈ I, mu x) - mu a := by
      have h := Finset.sum_erase_add I mu ha
      linarith only [h]
    rw [hmass, hweight] at hcompare
    nlinarith only [hcompare]
  · intro b hb
    have hcompare := hmax (I, J.erase b) (Finset.mem_univ _)
    dsimp [potential] at hcompare
    have hsplit :
        blockMass p I (J.erase b) + (∑ a ∈ I, p a b) =
          blockMass p I J := by
      dsimp [blockMass]
      rw [← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro a _
      exact Finset.sum_erase_add J (p a) hb
    have hmass :
        blockMass p I (J.erase b) =
          blockMass p I J - (∑ a ∈ I, p a b) := by
      linarith only [hsplit]
    have hweight :
        (∑ y ∈ J.erase b, nu y) = (∑ y ∈ J, nu y) - nu b := by
      have h := Finset.sum_erase_add J nu hb
      linarith only [h]
    rw [hmass, hweight] at hcompare
    nlinarith only [hcompare]

theorem reciprocal_retained_cap
    {A B : Type*} [Fintype B]
    (g : A → B → ℝ) (mu : A → ℝ) (I : Finset A)
    (cap r v : ℝ)
    (hparent : 0 < ∑ a ∈ I, mu a) (hr : 0 < r) (hv : 0 < v)
    (hrows : ∀ a ∈ I, (∑ b, g a b) ≤ cap * mu a) :
    blockMass g I Finset.univ / ((∑ a ∈ I, mu a) * r * v) ≤
      cap / (r * v) := by
  have hsum : blockMass g I Finset.univ ≤ cap * (∑ a ∈ I, mu a) := by
    calc
      blockMass g I Finset.univ ≤ ∑ a ∈ I, cap * mu a :=
        Finset.sum_le_sum fun a ha => hrows a ha
      _ = cap * (∑ a ∈ I, mu a) := (Finset.mul_sum I mu cap).symm
  apply (div_le_div_iff₀ (mul_pos (mul_pos hparent hr) hv) (mul_pos hr hv)).2
  calc
    blockMass g I Finset.univ * (r * v) ≤
        (cap * (∑ a ∈ I, mu a)) * (r * v) :=
      mul_le_mul_of_nonneg_right hsum (le_of_lt (mul_pos hr hv))
    _ = cap * ((∑ a ∈ I, mu a) * r * v) := by ring

theorem fiber_cap_from_core
    (eventMass rowMass referenceMass cap delta : ℝ)
    (hrow : 0 < rowMass) (hdelta : 0 < delta) (hcap : 0 ≤ cap)
    (hfloor : delta * referenceMass ≤ rowMass)
    (hevent : eventMass ≤ cap * referenceMass) :
    eventMass / rowMass ≤ cap / delta := by
  apply (div_le_div_iff₀ hrow hdelta).2
  calc
    eventMass * delta ≤ (cap * referenceMass) * delta :=
      mul_le_mul_of_nonneg_right hevent (le_of_lt hdelta)
    _ = cap * (delta * referenceMass) := by ring
    _ ≤ cap * rowMass := mul_le_mul_of_nonneg_left hfloor hcap

theorem mesh_exponent_loss
    (s a eLeft eRight eChild mesh : ℝ)
    (hs : 0 ≤ s) (hsone : s ≤ 1)
    (hleft : eLeft ≤ mesh) (hright : eRight ≤ mesh)
    (hchild : eChild ≤ mesh) :
    s * a - 4 * mesh ≤
      s * (a + eLeft - eChild) - 2 * (eLeft + eRight) := by
  have h1 := mul_nonneg (by linarith : 0 ≤ 2 - s) (sub_nonneg.mpr hleft)
  have h2 := mul_nonneg (by norm_num : (0 : ℝ) ≤ 2) (sub_nonneg.mpr hright)
  have h3 := mul_nonneg hs (sub_nonneg.mpr hchild)
  nlinarith only [h1, h2, h3]

end DirectionalBootstrap
