import Mathlib

namespace LongPalmProduct

open Finset

theorem marginal_product_identity
    {A B C : Type*} [Fintype A] [Fintype B] [Fintype C]
    (wa : A → ℝ) (wb : B → ℝ) (wc : C → ℝ)
    (f : A → B → ℝ) (g : A → C → ℝ) :
    (∑ a, ∑ b, ∑ c, wa a * wb b * wc c * f a b * g a c) =
      ∑ a, wa a * (∑ b, wb b * f a b) * (∑ c, wc c * g a c) := by
  calc
    _ = ∑ a, ∑ b, (wa a * (wb b * f a b)) * (∑ c, wc c * g a c) := by
      apply sum_congr rfl
      intro a _
      apply sum_congr rfl
      intro b _
      rw [mul_sum]
      apply sum_congr rfl
      intro c _
      ring
    _ = ∑ a, (∑ b, wa a * (wb b * f a b)) * (∑ c, wc c * g a c) := by
      simp only [sum_mul]
    _ = _ := by simp only [mul_sum]

theorem shared_output_bound
    {A B C : Type*} [Fintype A] [Fintype B] [Fintype C]
    (wa : A → ℝ) (wb : B → ℝ) (wc : C → ℝ)
    (f : A → B → ℝ) (g : A → C → ℝ) (G : ℝ)
    (hwa : ∀ a, 0 ≤ wa a) (hwc : ∀ c, 0 ≤ wc c)
    (hg : ∀ a c, 0 ≤ g a c) (hG : 0 ≤ G)
    (hf : ∀ a, (∑ b, wb b * f a b) ≤ G)
    (hmass : (∑ a, wa a * (∑ c, wc c * g a c)) ≤ 1) :
    (∑ a, ∑ b, ∑ c, wa a * wb b * wc c * f a b * g a c) ≤ G := by
  have hgmargin (a : A) : 0 ≤ ∑ c, wc c * g a c :=
    sum_nonneg fun c _ => mul_nonneg (hwc c) (hg a c)
  rw [marginal_product_identity]
  calc
    _ ≤ ∑ a, wa a * G * (∑ c, wc c * g a c) := by
      apply sum_le_sum
      intro a _
      exact mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_left (hf a) (hwa a)) (hgmargin a)
    _ = G * (∑ a, wa a * (∑ c, wc c * g a c)) := by
      rw [mul_sum]
      apply sum_congr rfl
      intro a _
      ring
    _ ≤ G := by
      simpa using mul_le_mul_of_nonneg_left hmass hG

theorem source_mixture_bound
    {X Z : Type*} [Fintype X]
    (mu rho : X → ℝ) (k : X → Z → ℝ) (b : Z → ℝ) (C R : ℝ)
    (hC : 0 ≤ C) (hmu : ∀ x, mu x ≤ C * rho x)
    (hk : ∀ x z, 0 ≤ k x z)
    (hmix : ∀ z, (∑ x, rho x * k x z) ≤ R * b z) :
    ∀ z, (∑ x, mu x * k x z) ≤ C * R * b z := by
  intro z
  calc
    _ ≤ ∑ x, (C * rho x) * k x z := by
      exact sum_le_sum fun x _ =>
        mul_le_mul_of_nonneg_right (hmu x) (hk x z)
    _ = C * (∑ x, rho x * k x z) := by
      rw [mul_sum]
      apply sum_congr rfl
      intro x _
      ring
    _ ≤ C * R * b z := by
      simpa [mul_assoc] using mul_le_mul_of_nonneg_left (hmix z) hC

theorem cross_source_bound
    {X Z W : Type*} [Fintype X] [Fintype Z] [Fintype W]
    (mu : X → ℝ) (k : X → Z → ℝ) (g : W → ℝ)
    (cost : X → W → ℝ) (H : ℝ)
    (hmu : ∀ x, 0 ≤ mu x) (hg : ∀ w, 0 ≤ g w)
    (hcost : ∀ x w, 0 ≤ cost x w)
    (hrow : ∀ x, (∑ z, k x z) ≤ 1)
    (hsource : ∀ w, (∑ x, mu x * cost x w) ≤ H)
    (hmass : (∑ w, g w) ≤ 1) (hH : 0 ≤ H) :
    (∑ w, g w * (∑ x, mu x * cost x w * (∑ z, k x z))) ≤ H := by
  have hinner (w : W) :
      (∑ x, mu x * cost x w * (∑ z, k x z)) ≤ H := by
    calc
      _ ≤ ∑ x, mu x * cost x w := by
        apply sum_le_sum
        intro x _
        simpa using mul_le_mul_of_nonneg_left
          (hrow x) (mul_nonneg (hmu x) (hcost x w))
      _ ≤ H := hsource w
  calc
    _ ≤ ∑ w, g w * H := by
      exact sum_le_sum fun w _ =>
        mul_le_mul_of_nonneg_left (hinner w) (hg w)
    _ = (∑ w, g w) * H := by rw [sum_mul]
    _ ≤ H := by
      simpa using mul_le_mul_of_nonneg_right hmass hH

theorem deleted_check_tag_error
    {X : Type*} [Fintype X]
    (w a aMinus h : X → ℝ)
    (hw : ∀ x, 0 ≤ w x) (ha : ∀ x, a x ≤ aMinus x)
    (hh : ∀ x, 0 ≤ h x ∧ h x ≤ 1)
    (hZ : 0 < ∑ x, w x * a x) :
    0 ≤ (∑ x, w x * h x * (aMinus x - a x)) / (∑ x, w x * a x) ∧
      (∑ x, w x * h x * (aMinus x - a x)) / (∑ x, w x * a x) ≤
        (∑ x, w x * aMinus x) / (∑ x, w x * a x) - 1 := by
  have hnum : 0 ≤ ∑ x, w x * h x * (aMinus x - a x) :=
    sum_nonneg fun x _ =>
      mul_nonneg (mul_nonneg (hw x) (hh x).1) (sub_nonneg.mpr (ha x))
  have hsum :
      (∑ x, w x * h x * (aMinus x - a x)) ≤
        (∑ x, w x * aMinus x) - (∑ x, w x * a x) := by
    calc
      _ ≤ ∑ x, w x * (aMinus x - a x) := by
        apply sum_le_sum
        intro x _
        calc
          _ = (w x * (aMinus x - a x)) * h x := by ring
          _ ≤ (w x * (aMinus x - a x)) * 1 :=
            mul_le_mul_of_nonneg_left (hh x).2
              (mul_nonneg (hw x) (sub_nonneg.mpr (ha x)))
          _ = _ := mul_one _
      _ = _ := by simp only [mul_sub, sum_sub_distrib]
  refine ⟨div_nonneg hnum (le_of_lt hZ), ?_⟩
  calc
    _ ≤ ((∑ x, w x * aMinus x) - (∑ x, w x * a x)) /
        (∑ x, w x * a x) :=
      div_le_div_of_nonneg_right hsum (le_of_lt hZ)
    _ = _ := by rw [sub_div, div_self (ne_of_gt hZ)]

def routeMass {H : Type*} [Fintype H] :
    List ((H → H → ℝ) × ℝ) → H → ℝ
  | [], _ => 1
  | step :: rest, h => ∑ h', step.1 h h' * routeMass rest h'

theorem selected_route_bound
    {H : Type*} [Fintype H] :
    ∀ steps : List ((H → H → ℝ) × ℝ),
      (∀ step ∈ steps, 0 ≤ step.2) →
      (∀ step ∈ steps, ∀ h h', 0 ≤ step.1 h h') →
      (∀ step ∈ steps, ∀ h, (∑ h', step.1 h h') ≤ step.2) →
      0 ≤ (steps.map Prod.snd).prod ∧
        ∀ h, 0 ≤ routeMass steps h ∧
          routeMass steps h ≤ (steps.map Prod.snd).prod := by
  intro steps
  induction steps with
  | nil =>
      intro _ _ _
      simp [routeMass]
  | cons step rest ih =>
      intro hcap hk hrow
      have hcapRest : ∀ s ∈ rest, 0 ≤ s.2 :=
        fun s hs => hcap s (List.mem_cons_of_mem _ hs)
      have hkRest : ∀ s ∈ rest, ∀ h h', 0 ≤ s.1 h h' :=
        fun s hs => hk s (List.mem_cons_of_mem _ hs)
      have hrowRest : ∀ s ∈ rest, ∀ h, (∑ h', s.1 h h') ≤ s.2 :=
        fun s hs => hrow s (List.mem_cons_of_mem _ hs)
      obtain ⟨hprod, htail⟩ := ih hcapRest hkRest hrowRest
      have hmem : step ∈ step :: rest := List.mem_cons_self
      constructor
      · simpa using mul_nonneg (hcap step hmem) hprod
      · intro h
        constructor
        · exact sum_nonneg fun h' _ =>
            mul_nonneg (hk step hmem h h') (htail h').1
        · change (∑ h', step.1 h h' * routeMass rest h') ≤
            step.2 * (rest.map Prod.snd).prod
          calc
            _ ≤ ∑ h', step.1 h h' * (rest.map Prod.snd).prod := by
              exact sum_le_sum fun h' _ =>
                mul_le_mul_of_nonneg_left (htail h').2 (hk step hmem h h')
            _ = (∑ h', step.1 h h') * (rest.map Prod.snd).prod := by
              rw [sum_mul]
            _ ≤ _ := mul_le_mul_of_nonneg_right (hrow step hmem h) hprod

end LongPalmProduct
