import Mathlib

namespace CausalExposure

section Translation

variable {V A : Type*} [AddCommGroup V]

def install (anchor : V) (q : A → V) (i l : A) : V :=
  anchor + q l - q i

theorem install_gauge_invariant (anchor c : V) (q : A → V) (i l : A) :
    install anchor (fun j => c + q j) i l = install anchor q i l := by
  change anchor + (c + q l) - (c + q i) = anchor + q l - q i
  simp only [sub_eq_add_neg, neg_add_rev]
  abel

theorem install_recovers (anchor c : V) (q : A → V) (i l : A)
    (contact : anchor = c + q i) :
    install anchor q i l = c + q l := by
  unfold install
  rw [contact]
  abel

theorem relative_merge_recovers (a b normal qa qb ql : V)
    (contact : b + qb = a + normal + qa) :
    a + (normal + qa - qb) + ql = b + ql := by
  have hb : b = a + normal + qa - qb := by
    rw [← contact]
    abel
  rw [hb]
  abel

end Translation

section Dependency

variable {I Ω X Y : Type*}

def AgreesOn (S : Set I) (u v : I → Ω) : Prop :=
  ∀ i ∈ S, u i = v i

def SupportedBy (S : Set I) (f : (I → Ω) → X) : Prop :=
  ∀ u v, AgreesOn S u v → f u = f v

theorem supported_mono {S T : Set I} {f : (I → Ω) → X}
    (hST : S ⊆ T) (hf : SupportedBy S f) : SupportedBy T f := by
  intro u v huv
  exact hf u v (fun i hi => huv i (hST hi))

theorem supported_map {S : Set I} {f : (I → Ω) → X}
    (hf : SupportedBy S f) (g : X → Y) :
    SupportedBy S (fun u => g (f u)) := by
  intro u v huv
  change g (f u) = g (f v)
  rw [hf u v huv]

theorem supported_install {V A : Type*} [AddCommGroup V]
    {S : Set I} (anchor : (I → Ω) → V) (q : (I → Ω) → A → V)
    (ha : SupportedBy S anchor) (hq : SupportedBy S q) (i l : A) :
    SupportedBy S (fun u => install (anchor u) (q u) i l) := by
  intro u v huv
  change install (anchor u) (q u) i l = install (anchor v) (q v) i l
  rw [ha u v huv, hq u v huv]

structure Update (I Ω X : Type*) where
  reads : Set I
  act : (I → Ω) → X → X
  depends_only_on_reads : ∀ u v x, AgreesOn reads u v → act u x = act v x

def allReads : List (Update I Ω X) → Set I
  | [] => ∅
  | e :: es => e.reads ∪ allReads es

def run (initial : (I → Ω) → X) : List (Update I Ω X) → (I → Ω) → X
  | [] => initial
  | e :: es => run (fun u => e.act u (initial u)) es

theorem update_supported {S : Set I} {initial : (I → Ω) → X}
    (h : SupportedBy S initial) (e : Update I Ω X) :
    SupportedBy (S ∪ e.reads) (fun u => e.act u (initial u)) := by
  intro u v huv
  change e.act u (initial u) = e.act v (initial v)
  have hs : initial u = initial v := h u v (fun i hi => huv i (Or.inl hi))
  rw [hs]
  exact e.depends_only_on_reads u v (initial v) (fun i hi => huv i (Or.inr hi))

theorem run_supported (es : List (Update I Ω X)) :
    ∀ (S : Set I) (initial : (I → Ω) → X),
      SupportedBy S initial →
      SupportedBy (S ∪ allReads es) (run initial es) := by
  induction es with
  | nil =>
      intro S initial h
      simpa [allReads, run] using h
  | cons e es ih =>
      intro S initial h
      have hnext := update_supported h e
      have htail := ih (S ∪ e.reads) (fun u => e.act u (initial u)) hnext
      simpa [allReads, run, Set.union_assoc] using htail

end Dependency

section Counting

variable {I : Type*} [DecidableEq I]

def cover : List (Finset I) → Finset I
  | [] => ∅
  | B :: Bs => B ∪ cover Bs

theorem fresh_disjoint (seen requested : Finset I) :
    Disjoint (requested \ seen) seen := by
  apply Finset.disjoint_left.mpr
  intro i hi hseen
  exact (Finset.mem_sdiff.mp hi).2 hseen

theorem fresh_cap (seen requested : Finset I) (h : requested.card ≤ 2) :
    (requested \ seen).card ≤ 2 :=
  le_trans (Finset.card_le_card Finset.sdiff_subset) h

theorem cover_card_le_two_mul (Bs : List (Finset I))
    (h : ∀ B ∈ Bs, B.card ≤ 2) :
    (cover Bs).card ≤ 2 * Bs.length := by
  induction Bs with
  | nil => simp [cover]
  | cons B Bs ih =>
      have hB : B.card ≤ 2 := h B (by simp)
      have hBs : ∀ C ∈ Bs, C.card ≤ 2 := by
        intro C hC
        exact h C (by simp [hC])
      calc
        (cover (B :: Bs)).card ≤ B.card + (cover Bs).card :=
          Finset.card_union_le B (cover Bs)
        _ ≤ 2 + 2 * Bs.length := Nat.add_le_add hB (ih hBs)
        _ = 2 * (B :: Bs).length := by simp; omega

theorem exposure_count (K : Finset I) (Bs : List (Finset I))
    (hcover : K ⊆ cover Bs) (hcap : ∀ B ∈ Bs, B.card ≤ 2) :
    K.card ≤ 2 * Bs.length :=
  le_trans (Finset.card_le_card hcover) (cover_card_le_two_mul Bs hcap)

end Counting

section Flux

variable {R : Type*} [CommRing R]

def det3 (a b c d e f g h i : R) : R :=
  a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)

theorem contact_flux_numerator (e u v x y z : R) :
    det3
      x (2 * e * (1 - u ^ 2 + v ^ 2)) (-4 * e * u * v)
      y (-4 * e * u * v) (2 * e * (1 + u ^ 2 - v ^ 2))
      z (-4 * e * u) (-4 * e * v)
      = 4 * e ^ 2 * (1 + u ^ 2 + v ^ 2) *
        (2 * u * x + 2 * v * y + (1 - u ^ 2 - v ^ 2) * z) := by
  unfold det3
  ring

end Flux

section PowerComplexity

noncomputable def powerEta (B alpha : ℝ) : ℝ :=
  alpha / (800 * (3 * B + 1))

theorem power_eta_pos (B alpha : ℝ) (hB : 1 ≤ B) (ha : 0 < alpha) :
    0 < powerEta B alpha := by
  unfold powerEta
  have hden : 0 < 800 * (3 * B + 1) := by linarith
  exact div_pos ha hden

theorem power_eta_budget (B alpha : ℝ) (hB : 1 ≤ B) :
    (3 * B + 1) * powerEta B alpha = alpha / 800 := by
  have hden : 3 * B + 1 ≠ 0 := by linarith
  unfold powerEta
  field_simp

theorem power_budget_bounds (B alpha eta : ℝ)
    (hB : 1 ≤ B) (ha : alpha ≤ 1) (he : 0 ≤ eta)
    (hbudget : (3 * B + 1) * eta ≤ alpha / 800) :
    (23 : ℝ) / 2400 ≤ 1 / 100 - B * eta ∧
    (239 : ℝ) / 2400 ≤ 1 / 10 - B * eta ∧
    (2 * B + alpha * B / 2) * eta - alpha / 200 ≤ -3 * alpha / 800 := by
  have hBe : 0 ≤ B * eta := mul_nonneg (by linarith) he
  have hcross : 0 ≤ (1 - alpha) * (B * eta) :=
    mul_nonneg (by linarith) hBe
  have hsmall : B * eta ≤ (1 : ℝ) / 2400 := by nlinarith
  constructor
  · nlinarith
  constructor
  · nlinarith
  · nlinarith

end PowerComplexity

end CausalExposure
