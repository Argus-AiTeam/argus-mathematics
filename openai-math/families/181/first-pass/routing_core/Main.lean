import Mathlib

open Finset

noncomputable section

namespace RoutingCore

variable {r : ℕ}

def boundary (P : SimpleGraph (Fin r)) (B : Finset (Fin r)) :
    Finset (Fin r × Fin r) := by
  classical
  exact (B ×ˢ (univ \ B)).filter fun e => P.Adj e.1 e.2

def CutExpansion (P : SimpleGraph (Fin r)) (h : ℝ) : Prop :=
  ∀ B : Finset (Fin r),
    h * min (B.card : ℝ) ((r : ℝ) - B.card) ≤ (boundary P B).card

def ball (P : SimpleGraph (Fin r)) (F : Finset (Sym2 (Fin r)))
    (W : Fin r → Finset (Fin r)) (s : Fin r) : ℕ → Finset (Fin r)
  | 0 => {s}
  | t + 1 => by
    classical
    exact ball P F W s t ∪ univ.filter (fun w =>
      w ∉ W s ∧ ∃ v ∈ ball P F W s t, P.Adj v w ∧ s(v, w) ∉ F)

def unionBall (P : SimpleGraph (Fin r)) (F : Finset (Sym2 (Fin r)))
    (W : Fin r → Finset (Fin r)) (A : Finset (Fin r)) (t : ℕ) :
    Finset (Fin r) := by
  classical
  exact A.biUnion fun s => ball P F W s t

lemma boundary_mem {P : SimpleGraph (Fin r)} {B : Finset (Fin r)}
    {e : Fin r × Fin r} :
    e ∈ boundary P B ↔ e.1 ∈ B ∧ e.2 ∉ B ∧ P.Adj e.1 e.2 := by
  classical
  simp [boundary, and_assoc]

lemma ball_mono (P : SimpleGraph (Fin r)) (F : Finset (Sym2 (Fin r)))
    (W : Fin r → Finset (Fin r)) (s : Fin r) :
    Monotone (ball P F W s) := by
  apply monotone_nat_of_le_succ
  intro t
  exact subset_union_left

lemma unionBall_mono (P : SimpleGraph (Fin r)) (F : Finset (Sym2 (Fin r)))
    (W : Fin r → Finset (Fin r)) (A : Finset (Fin r)) :
    Monotone (unionBall P F W A) := by
  intro t u htu v hv
  classical
  obtain ⟨s, hs, hv⟩ := mem_biUnion.mp hv
  exact mem_biUnion.mpr ⟨s, hs, ball_mono P F W s htu hv⟩

@[simp] lemma unionBall_zero (P : SimpleGraph (Fin r))
    (F : Finset (Sym2 (Fin r))) (W : Fin r → Finset (Fin r))
    (A : Finset (Fin r)) : unionBall P F W A 0 = A := by
  classical
  ext v
  simp [unionBall, ball]

lemma unionBall_roots_mono (P : SimpleGraph (Fin r))
    (F : Finset (Sym2 (Fin r))) (W : Fin r → Finset (Fin r))
    {A D : Finset (Fin r)} (hAD : A ⊆ D) (t : ℕ) :
    unionBall P F W A t ⊆ unionBall P F W D t := by
  classical
  intro v hv
  obtain ⟨s, hs, hv⟩ := mem_biUnion.mp hv
  exact mem_biUnion.mpr ⟨s, hAD hs, hv⟩

lemma ball_extend (P : SimpleGraph (Fin r)) (F : Finset (Sym2 (Fin r)))
    (W : Fin r → Finset (Fin r)) {s v w : Fin r} {t : ℕ}
    (hv : v ∈ ball P F W s t) (ha : P.Adj v w)
    (hf : s(v, w) ∉ F) (hw : w ∉ W s) :
    w ∈ ball P F W s (t + 1) := by
  classical
  simp only [ball, mem_union, mem_filter, mem_univ, true_and]
  exact Or.inr ⟨hw, v, hv, ha, hf⟩

lemma ball_avoids (P : SimpleGraph (Fin r)) (F : Finset (Sym2 (Fin r)))
    (W : Fin r → Finset (Fin r)) {s : Fin r} (hs : s ∉ W s)
    (t : ℕ) : ∀ v ∈ ball P F W s t, v ∉ W s := by
  classical
  induction t with
  | zero => simpa [ball] using hs
  | succ t ih =>
    intro v hv
    rcases mem_union.mp hv with hv | hv
    · exact ih v hv
    · exact (mem_filter.mp hv).2.1

lemma deleted_boundary_card (P : SimpleGraph (Fin r))
    (F : Finset (Sym2 (Fin r))) (B : Finset (Fin r)) :
    ((boundary P B).filter fun e => s(e.1, e.2) ∈ F).card ≤ F.card := by
  classical
  let D := (boundary P B).filter fun e => s(e.1, e.2) ∈ F
  have hinj : Set.InjOn (fun e : Fin r × Fin r => s(e.1, e.2)) D := by
    intro a ha b hb hab
    have haB := boundary_mem.mp (mem_filter.mp ha).1
    have hbB := boundary_mem.mp (mem_filter.mp hb).1
    rcases Sym2.eq_iff.mp hab with hab | hab
    · exact Prod.ext hab.1 hab.2
    · exact False.elim (hbB.2.1 (hab.1 ▸ haB.1))
  calc
    D.card = (D.image fun e => s(e.1, e.2)).card :=
      (card_image_iff.mpr hinj).symm
    _ ≤ F.card := card_le_card (by
      intro e he
      obtain ⟨a, ha, rfl⟩ := mem_image.mp he
      exact (mem_filter.mp ha).2)

theorem union_growth (P : SimpleGraph (Fin r))
    (F : Finset (Sym2 (Fin r))) (W : Fin r → Finset (Fin r))
    (h : ℝ) (_hh : 0 < h) (hr : 0 < r)
    (hexp : CutExpansion P h) (A : Finset (Fin r)) (hA : A.Nonempty)
    (hW : ∀ s ∈ A, (W s).card ≤ h / 4) (t : ℕ)
    (hsmall : ((unionBall P F W A t).card : ℝ) ≤ (r : ℝ) / 2)
    (hF : (F.card : ℝ) ≤ h * (unionBall P F W A t).card / 4) :
    (1 + h / (2 * r)) * (unionBall P F W A t).card ≤
      ((unionBall P F W A (t + 1)).card : ℝ) := by
  classical
  let B := unionBall P F W A t
  let N := unionBall P F W A (t + 1)
  obtain ⟨s0, hs0⟩ := hA
  let label : Fin r → Fin r := fun v =>
    if hv : v ∈ B then (mem_biUnion.mp hv).choose else s0
  have hl (v : Fin r) (hv : v ∈ B) :
      label v ∈ A ∧ v ∈ ball P F W (label v) t := by
    simpa only [label, dif_pos hv] using (mem_biUnion.mp hv).choose_spec
  let C := boundary P B
  let D := C.filter fun e => s(e.1, e.2) ∈ F
  let K := B.biUnion fun v => (W (label v)).image fun w => (v, w)
  let U := C \ (D ∪ K)
  have hD : D.card ≤ F.card := deleted_boundary_card P F B
  have hKnat : K.card ≤ ∑ v ∈ B, (W (label v)).card := by
    exact (card_biUnion_le).trans (sum_le_sum fun v _ => card_image_le)
  have hK : (K.card : ℝ) ≤ (h / 4) * B.card := by
    calc
      (K.card : ℝ) ≤ ∑ v ∈ B, ((W (label v)).card : ℝ) := by
        exact_mod_cast hKnat
      _ ≤ ∑ _v ∈ B, h / 4 := sum_le_sum fun v hv => hW _ (hl v hv).1
      _ = (h / 4) * B.card := by simp [mul_comm]
  have hUN : U ⊆ B ×ˢ (N \ B) := by
    intro e he
    have heC := boundary_mem.mp (mem_sdiff.mp he).1
    have hnot := mem_sdiff.mp he
    have hf : s(e.1, e.2) ∉ F := by
      intro hf
      exact hnot.2 (mem_union_left K (mem_filter.mpr ⟨hnot.1, hf⟩))
    have hw : e.2 ∉ W (label e.1) := by
      intro hw
      exact hnot.2 (mem_union_right D (mem_biUnion.mpr
        ⟨e.1, heC.1, mem_image.mpr ⟨e.2, hw, rfl⟩⟩))
    have hn : e.2 ∈ N := mem_biUnion.mpr
      ⟨label e.1, (hl e.1 heC.1).1,
        ball_extend P F W (hl e.1 heC.1).2 heC.2.2 hf hw⟩
    exact mem_product.mpr ⟨heC.1, mem_sdiff.mpr ⟨hn, heC.2.1⟩⟩
  have hBcard : B.card ≤ r := by
    simpa using card_le_univ B
  have hU : (U.card : ℝ) ≤ (r : ℝ) * (N \ B).card := by
    have hc : U.card ≤ r * (N \ B).card := calc
      U.card ≤ (B ×ˢ (N \ B)).card := card_le_card hUN
      _ = B.card * (N \ B).card := card_product _ _
      _ ≤ r * (N \ B).card := Nat.mul_le_mul_right _ hBcard
    exact_mod_cast hc
  have hcover : C ⊆ (D ∪ K) ∪ U := by
    intro e he
    by_cases hd : e ∈ D ∪ K
    · exact mem_union_left U hd
    · exact mem_union_right (D ∪ K) (mem_sdiff.mpr ⟨he, hd⟩)
  have hcountNat : C.card ≤ D.card + K.card + U.card :=
    (card_le_card hcover).trans
      ((card_union_le _ _).trans (Nat.add_le_add_right (card_union_le _ _) _))
  have hcount : (C.card : ℝ) ≤ (F.card : ℝ) + (h / 4) * B.card +
      (r : ℝ) * (N \ B).card := by
    have hc : (C.card : ℝ) ≤ (D.card : ℝ) + K.card + U.card := by
      exact_mod_cast hcountNat
    have hd : (D.card : ℝ) ≤ F.card := by exact_mod_cast hD
    linarith
  have he : h * B.card ≤ (C.card : ℝ) := by
    have hm : min (B.card : ℝ) ((r : ℝ) - B.card) = B.card :=
      min_eq_left (by dsimp [B]; linarith)
    simpa only [hm] using hexp B
  have hBN : B ⊆ N := unionBall_mono P F W A (Nat.le_succ t)
  have hdiffNat := card_sdiff_add_card_eq_card hBN
  have hdiff : ((N \ B).card : ℝ) + B.card = N.card := by
    exact_mod_cast hdiffNat
  have hrR : (0 : ℝ) < r := by exact_mod_cast hr
  have hx : h * (B.card : ℝ) / 2 ≤ (r : ℝ) * (N.card - B.card) := by
    have hF' : (F.card : ℝ) ≤ h * B.card / 4 := hF
    nlinarith
  have hx' : h / (2 * r) * (B.card : ℝ) ≤ (N.card : ℝ) - B.card := by
    calc
      h / (2 * r) * (B.card : ℝ) = (h * B.card / 2) / r := by ring
      _ ≤ (N.card : ℝ) - B.card := (div_le_iff₀ hrR).mpr (by nlinarith)
  dsimp [B, N] at *
  nlinarith

def growthRadius (r : ℕ) (h : ℝ) : ℕ :=
  ⌈8 * ((r : ℝ) / h) * Real.logb 2 (2 * r)⌉₊

lemma expansion_le_order (P : SimpleGraph (Fin r)) (h : ℝ)
    (hr : 2 ≤ r) (hexp : CutExpansion P h) : h ≤ r := by
  classical
  let v : Fin r := ⟨0, by omega⟩
  have hrR : (2 : ℝ) ≤ r := by exact_mod_cast hr
  have hm : min (1 : ℝ) ((r : ℝ) - 1) = 1 := min_eq_left (by linarith)
  have he := hexp {v}
  simp only [card_singleton, Nat.cast_one, hm, mul_one] at he
  have hsub : boundary P {v} ⊆ {v} ×ˢ univ := by
    intro e he
    exact mem_product.mpr ⟨(boundary_mem.mp he).1, mem_univ _⟩
  have hc : (boundary P {v}).card ≤ r := by
    simpa using card_le_card hsub
  exact he.trans (by exact_mod_cast hc)

lemma log_growth_lower (h : ℝ) (hr : 0 < r) (hh : 0 < h)
    (hhr : h ≤ r) :
    h / (4 * r) ≤ Real.log (1 + h / (2 * r)) := by
  have hrR : (0 : ℝ) < r := by exact_mod_cast hr
  let a := h / (2 * r)
  have ha : 0 ≤ a := by dsimp [a]; positivity
  have ha1 : a ≤ 1 := by
    dsimp [a]
    apply (div_le_iff₀ (by positivity : (0 : ℝ) < 2 * r)).mpr
    linarith
  have hden : 0 < a + 2 := by linarith
  calc
    h / (4 * r) = a / 2 := by dsimp [a]; ring
    _ ≤ 2 * a / (a + 2) := (le_div_iff₀ hden).mpr (by nlinarith)
    _ ≤ Real.log (1 + a) := Real.le_log_one_add_of_nonneg ha

lemma radius_log_bound (P : SimpleGraph (Fin r)) (h : ℝ)
    (hr : 2 ≤ r) (hh : 0 < h) (hexp : CutExpansion P h) :
    Real.log (2 * r) <
      (growthRadius r h : ℝ) * Real.log (1 + h / (2 * r)) := by
  have hrN : 0 < r := by omega
  have hrR : (0 : ℝ) < r := by exact_mod_cast hrN
  have hr2 : (2 : ℝ) ≤ r := by exact_mod_cast hr
  have hL : 0 < Real.log (2 * r) := Real.log_pos (by linarith)
  have h2 : 0 < Real.log (2 : ℝ) := Real.log_pos (by norm_num)
  have h2le : Real.log (2 : ℝ) ≤ 1 := by
    have H := Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 2)
    norm_num at H ⊢
    exact H
  have hlog : Real.log (2 * r) ≤ Real.logb 2 (2 * r) := by
    rw [Real.logb]
    exact (le_div_iff₀ h2).mpr (by nlinarith)
  have hg : 8 * ((r : ℝ) / h) * Real.log (2 * r) ≤
      (growthRadius r h : ℝ) := by
    exact (mul_le_mul_of_nonneg_left hlog (by positivity)).trans (Nat.le_ceil _)
  have hmul : 2 * Real.log (2 * r) ≤
      (growthRadius r h : ℝ) * (h / (4 * r)) := by
    calc
      2 * Real.log (2 * r) =
          (8 * ((r : ℝ) / h) * Real.log (2 * r)) * (h / (4 * r)) := by
        field_simp
        ring
      _ ≤ (growthRadius r h : ℝ) * (h / (4 * r)) :=
        mul_le_mul_of_nonneg_right hg (by positivity)
  have hglog := mul_le_mul_of_nonneg_left
    (log_growth_lower h hrN hh (expansion_le_order P h hr hexp))
    (Nat.cast_nonneg (growthRadius r h) : (0 : ℝ) ≤ growthRadius r h)
  linarith

lemma unionBall_card_mono (P : SimpleGraph (Fin r))
    (F : Finset (Sym2 (Fin r))) (W : Fin r → Finset (Fin r))
    (A : Finset (Fin r)) {t u : ℕ} (htu : t ≤ u) :
    ((unionBall P F W A t).card : ℝ) ≤ (unionBall P F W A u).card := by
  exact_mod_cast card_le_card (unionBall_mono P F W A htu)

theorem growth_block (P : SimpleGraph (Fin r))
    (F : Finset (Sym2 (Fin r))) (W : Fin r → Finset (Fin r))
    (h : ℝ) (hh : 0 < h) (hr : 2 ≤ r)
    (hexp : CutExpansion P h) (A : Finset (Fin r)) (hA : A.Nonempty)
    (hW : ∀ s ∈ A, (W s).card ≤ h / 4) (t : ℕ)
    (hF : (F.card : ℝ) ≤ h * (unionBall P F W A t).card / 4) :
    (r : ℝ) / 2 < (unionBall P F W A (t + growthRadius r h)).card := by
  classical
  have hrN : 0 < r := by omega
  have hrR : (0 : ℝ) < r := by exact_mod_cast hrN
  let g := growthRadius r h
  let a := h / (2 * r)
  have ha : 0 < 1 + a := by dsimp [a]; positivity
  by_contra hn
  have hfinal : ((unionBall P F W A (t + g)).card : ℝ) ≤ (r : ℝ) / 2 :=
    le_of_not_gt hn
  have hind : ∀ i : ℕ, i ≤ g →
      (1 + a) ^ i * (unionBall P F W A t).card ≤
        ((unionBall P F W A (t + i)).card : ℝ) := by
    intro i
    induction i with
    | zero => intro _; simp
    | succ i ih =>
      intro hi
      have hii : i ≤ g := by omega
      have hsmall := (unionBall_card_mono P F W A
        (Nat.add_le_add_left hii t)).trans hfinal
      have hstart := unionBall_card_mono P F W A (Nat.le_add_right t i)
      have hFi : (F.card : ℝ) ≤ h * (unionBall P F W A (t + i)).card / 4 := by
        nlinarith
      have hstep := union_growth P F W h hh hrN hexp A hA hW (t + i) hsmall hFi
      calc
        (1 + a) ^ (i + 1) * (unionBall P F W A t).card =
            (1 + a) * ((1 + a) ^ i * (unionBall P F W A t).card) := by ring
        _ ≤ (1 + a) * (unionBall P F W A (t + i)).card :=
          mul_le_mul_of_nonneg_left (ih hii) ha.le
        _ ≤ ((unionBall P F W A (t + (i + 1))).card : ℝ) := by
          simpa only [Nat.add_assoc] using hstep
  have hstartNat : 1 ≤ (unionBall P F W A t).card := by
    have H := card_le_card (unionBall_mono P F W A (Nat.zero_le t))
    rw [unionBall_zero] at H
    exact (Nat.succ_le_iff.mpr (card_pos.mpr hA)).trans H
  have hstartR : (1 : ℝ) ≤ (unionBall P F W A t).card := by
    exact_mod_cast hstartNat
  have hpow : (1 + a) ^ g ≤ (r : ℝ) / 2 := by
    have H := hind g le_rfl
    have Hp : (0 : ℝ) ≤ (1 + a) ^ g := (pow_pos ha g).le
    nlinarith
  have hlog := Real.log_le_log (pow_pos ha g) hpow
  rw [Real.log_pow] at hlog
  have hcomp : Real.log ((r : ℝ) / 2) ≤ Real.log (2 * r) :=
    Real.log_le_log (by positivity) (by linarith)
  have hstrict := radius_log_bound P h hr hh hexp
  dsimp [g, a] at hlog
  linarith

lemma unionBall_union (P : SimpleGraph (Fin r))
    (F : Finset (Sym2 (Fin r))) (W : Fin r → Finset (Fin r))
    (A D : Finset (Fin r)) (t : ℕ) :
    unionBall P F W (A ∪ D) t =
      unionBall P F W A t ∪ unionBall P F W D t := by
  classical
  ext v
  simp [unionBall, or_and_right, exists_or]

theorem halve_large_union (P : SimpleGraph (Fin r))
    (F : Finset (Sym2 (Fin r))) (W : Fin r → Finset (Fin r))
    (h : ℝ) (hh : 0 < h) (hr : 2 ≤ r) (hexp : CutExpansion P h)
    (S : Finset (Fin r)) (hW : ∀ s ∈ S, (W s).card ≤ h / 4)
    (hF : (F.card : ℝ) ≤ h * r / 64) :
    ∀ (m : ℕ) (A : Finset (Fin r)), A ⊆ S → A.Nonempty →
      A.card ≤ 2 ^ m → ∀ t : ℕ,
      (r : ℝ) / 2 < (unionBall P F W A t).card →
      ∃ s ∈ A, (r : ℝ) / 2 < (ball P F W s (t + m * growthRadius r h)).card := by
  classical
  have hrN : 0 < r := by omega
  have hrR : (0 : ℝ) < r := by exact_mod_cast hrN
  intro m
  induction m with
  | zero =>
    intro A hAS hA hcard t hlarge
    have hc : A.card = 1 := by
      have hp := card_pos.mpr hA
      simp only [pow_zero] at hcard
      omega
    obtain ⟨s, rfl⟩ := card_eq_one.mp hc
    exact ⟨s, by simp, by simpa [unionBall] using hlarge⟩
  | succ m ih =>
    intro A hAS hA hcard t hlarge
    obtain ⟨C, hCA, hCcard⟩ :=
      exists_subset_card_eq (min_le_left A.card (2 ^ m))
    let D := A \ C
    have hCbound : C.card ≤ 2 ^ m := by
      rw [hCcard]
      exact min_le_right _ _
    have hDbound : D.card ≤ 2 ^ m := by
      have hd := card_sdiff_add_card_eq_card hCA
      rw [hCcard] at hd
      rw [pow_succ] at hcard
      dsimp [D]
      omega
    have hDA : D ⊆ A := sdiff_subset
    have hsplit : A = C ∪ D := (union_sdiff_of_subset hCA).symm
    have hcover : ((unionBall P F W A t).card : ℝ) ≤
        (unionBall P F W C t).card + (unionBall P F W D t).card := by
      rw [hsplit, unionBall_union]
      exact_mod_cast card_union_le (unionBall P F W C t) (unionBall P F W D t)
    have hchoice : (r : ℝ) / 4 < (unionBall P F W C t).card ∨
        (r : ℝ) / 4 < (unionBall P F W D t).card := by
      by_contra hn
      push Not at hn
      linarith
    have hE : ∃ E : Finset (Fin r), E ⊆ A ∧ E.card ≤ 2 ^ m ∧
        (r : ℝ) / 4 < (unionBall P F W E t).card := by
      rcases hchoice with hC | hD
      · exact ⟨C, hCA, hCbound, hC⟩
      · exact ⟨D, hDA, hDbound, hD⟩
    obtain ⟨E, hEA, hEcard, hEquarter⟩ := hE
    have hEnonempty : E.Nonempty := by
      by_contra hn
      have he : E = ∅ := not_nonempty_iff_eq_empty.mp hn
      simp only [he, unionBall, biUnion_empty, card_empty, Nat.cast_zero] at hEquarter
      linarith
    have hES : E ⊆ S := hEA.trans hAS
    have hFE : (F.card : ℝ) ≤ h * (unionBall P F W E t).card / 4 := by
      have H := mul_lt_mul_of_pos_left hEquarter hh
      nlinarith [mul_pos hh hrR]
    have hgrown := growth_block P F W h hh hr hexp E hEnonempty
      (fun s hs => hW s (hES hs)) t hFE
    obtain ⟨s, hs, hball⟩ := ih E hES hEnonempty hEcard
      (t + growthRadius r h) hgrown
    refine ⟨s, hEA hs, ?_⟩
    have ht : (t + growthRadius r h) + m * growthRadius r h =
        t + (m + 1) * growthRadius r h := by ring
    rw [ht] at hball
    exact hball

theorem root_growth_and_halving (P : SimpleGraph (Fin r))
    (F : Finset (Sym2 (Fin r))) (W : Fin r → Finset (Fin r))
    (h : ℝ) (hh : 0 < h) (hr : 2 ≤ r) (hexp : CutExpansion P h)
    (S : Finset (Fin r)) (hS : S.Nonempty)
    (_hroot : ∀ s ∈ S, s ∉ W s)
    (hW : ∀ s ∈ S, (W s).card ≤ h / 4)
    (hFS : (F.card : ℝ) ≤ h * S.card / 4)
    (hFr : (F.card : ℝ) ≤ h * r / 64) :
    ∃ s ∈ S, (r : ℝ) / 2 <
      (ball P F W s (growthRadius r h * (1 + Nat.clog 2 S.card))).card := by
  have hstart : (F.card : ℝ) ≤ h * (unionBall P F W S 0).card / 4 := by
    simpa using hFS
  have hlarge := growth_block P F W h hh hr hexp S hS hW 0 hstart
  obtain ⟨s, hs, hball⟩ := halve_large_union P F W h hh hr hexp S hW hFr
    (Nat.clog 2 S.card) S (Subset.refl _) hS (Nat.le_pow_clog (by norm_num) _)
    (growthRadius r h) (by simpa using hlarge)
  refine ⟨s, hs, ?_⟩
  have ht : growthRadius r h + Nat.clog 2 S.card * growthRadius r h =
      growthRadius r h * (1 + Nat.clog 2 S.card) := by ring
  rw [ht] at hball
  exact hball

def rootGraph (P : SimpleGraph (Fin r)) (F : Finset (Sym2 (Fin r)))
    (W : Fin r → Finset (Fin r)) (s : Fin r) : SimpleGraph (Fin r) where
  Adj v w := P.Adj v w ∧ s(v, w) ∉ F ∧ v ∉ W s ∧ w ∉ W s
  symm := ⟨by
    intro v w hvw
    exact ⟨hvw.1.symm, by simpa only [Sym2.eq_swap] using hvw.2.1,
      hvw.2.2.2, hvw.2.2.1⟩⟩
  loopless := ⟨by
    intro v hv
    exact P.loopless.irrefl v hv.1⟩

lemma ball_walk_witness (P : SimpleGraph (Fin r))
    (F : Finset (Sym2 (Fin r))) (W : Fin r → Finset (Fin r))
    {s : Fin r} (hs : s ∉ W s) (t : ℕ) :
    ∀ v ∈ ball P F W s t,
      ∃ p : (rootGraph P F W s).Walk s v, p.length ≤ t := by
  classical
  induction t with
  | zero =>
    intro v hv
    have hv' : v = s := by simpa [ball] using hv
    subst v
    exact ⟨SimpleGraph.Walk.nil, by simp⟩
  | succ t ih =>
    intro w hw
    rcases mem_union.mp hw with hw | hw
    · obtain ⟨p, hp⟩ := ih w hw
      exact ⟨p, hp.trans (Nat.le_succ t)⟩
    · obtain ⟨hwW, v, hv, hva, hvF⟩ := (mem_filter.mp hw).2
      obtain ⟨p, hp⟩ := ih v hv
      have he : (rootGraph P F W s).Adj v w :=
        ⟨hva, hvF, ball_avoids P F W hs t v hv, hwW⟩
      exact ⟨p.concat he, by simpa using Nat.add_le_add_right hp 1⟩

lemma walk_mem_ball (P : SimpleGraph (Fin r)) (F : Finset (Sym2 (Fin r)))
    (W : Fin r → Finset (Fin r)) (s : Fin r) {v w : Fin r}
    (p : (rootGraph P F W s).Walk v w) (t : ℕ)
    (hv : v ∈ ball P F W s t) :
    w ∈ ball P F W s (t + p.length) := by
  induction p generalizing t with
  | nil => simpa
  | @cons v u w he p ih =>
    have hu := ball_extend P F W hv he.1 he.2.1 he.2.2.2
    have H := ih (t + 1) hu
    simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using H

theorem mem_ball_iff_walk (P : SimpleGraph (Fin r))
    (F : Finset (Sym2 (Fin r))) (W : Fin r → Finset (Fin r))
    {s v : Fin r} (hs : s ∉ W s) (t : ℕ) :
    v ∈ ball P F W s t ↔
      ∃ p : (rootGraph P F W s).Walk s v, p.length ≤ t := by
  constructor
  · exact ball_walk_witness P F W hs t v
  · rintro ⟨p, hp⟩
    have hv := walk_mem_ball P F W s p 0 (by simp [ball])
    exact ball_mono P F W s hp (by simpa using hv)

def walkBall (P : SimpleGraph (Fin r)) (F : Finset (Sym2 (Fin r)))
    (W : Fin r → Finset (Fin r)) (s : Fin r) (t : ℕ) : Finset (Fin r) := by
  classical
  exact univ.filter fun v => ∃ p : (rootGraph P F W s).Walk s v, p.length ≤ t

lemma ball_eq_walkBall (P : SimpleGraph (Fin r))
    (F : Finset (Sym2 (Fin r))) (W : Fin r → Finset (Fin r))
    {s : Fin r} (hs : s ∉ W s) (t : ℕ) :
    ball P F W s t = walkBall P F W s t := by
  classical
  ext v
  simpa only [walkBall, mem_filter, mem_univ, true_and] using
    mem_ball_iff_walk P F W hs t (v := v)

theorem routing_root (P : SimpleGraph (Fin r))
    (F : Finset (Sym2 (Fin r))) (W : Fin r → Finset (Fin r))
    (h : ℝ) (hh : 0 < h) (hr : 2 ≤ r) (hexp : CutExpansion P h)
    (S : Finset (Fin r)) (hS : S.Nonempty)
    (hroot : ∀ s ∈ S, s ∉ W s)
    (hW : ∀ s ∈ S, (W s).card ≤ h / 4)
    (hFS : (F.card : ℝ) ≤ h * S.card / 4)
    (hFr : (F.card : ℝ) ≤ h * r / 64) :
    ∃ s ∈ S, (r : ℝ) / 2 <
      (walkBall P F W s
        (⌈8 * ((r : ℝ) / h) * Real.logb 2 (2 * r)⌉₊ *
          (1 + ⌈Real.logb 2 (S.card : ℝ)⌉₊))).card := by
  obtain ⟨s, hs, hb⟩ := root_growth_and_halving P F W h hh hr hexp S hS
    hroot hW hFS hFr
  refine ⟨s, hs, ?_⟩
  have hclog : ⌈Real.logb 2 (S.card : ℝ)⌉₊ = Nat.clog 2 S.card := by
    simpa using Real.natCeil_logb_natCast 2 S.card
  rw [hclog]
  simpa only [growthRadius, ball_eq_walkBall P F W (hroot s hs)] using hb

theorem obstruction_budgets (x k b z h n a R f w : ℝ)
    (hx : 0 ≤ x) (hk : 0 ≤ k) (hb : 0 ≤ b) (hz : 0 ≤ z)
    (ha : 0 ≤ a) (hR : 0 ≤ R)
    (hc : 64 * (x * (k + b) + z) ≤ h)
    (hf : f ≤ 2 * x * n) (hp : n ≤ 4 * k * a)
    (hend : 2 * n ≤ k * R) (hw : w ≤ z + 4 * b * x) :
    w ≤ h / 4 ∧ f ≤ h * a / 4 ∧ f ≤ h * R / 64 := by
  have hxb := mul_nonneg hx hb
  have hxk := mul_nonneg hx hk
  have hweak : w ≤ h / 4 := by nlinarith
  have hi : 8 * k * x ≤ h / 4 := by nlinarith
  have hg : k * x ≤ h / 64 := by nlinarith
  have hfinit : f ≤ (8 * k * x) * a := by
    have H := mul_le_mul_of_nonneg_left hp (show 0 ≤ 2 * x by positivity)
    nlinarith
  have hfglob : f ≤ (k * x) * R := by
    have H := mul_le_mul_of_nonneg_left hend hx
    nlinarith
  constructor
  · exact hweak
  constructor
  · have H := mul_le_mul_of_nonneg_right hi ha
    nlinarith
  · have H := mul_le_mul_of_nonneg_right hg hR
    nlinarith

#print axioms RoutingCore.union_growth
#print axioms RoutingCore.routing_root

end RoutingCore
