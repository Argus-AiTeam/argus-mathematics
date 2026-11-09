import Mathlib

namespace EntropyRefinement

variable {S : Type*} [Preorder S]

structure Model (S : Type*) [Preorder S] where
  cost : S → ℝ
  a : S → ℕ → ℝ
  hi : S → ℕ → ℝ
  lo : S → ℕ → ℝ
  cost_mono : Monotone cost
  a_nonneg : ∀ s j, 0 ≤ a s j
  a_le_one : ∀ s j, a s j ≤ 1
  a_index : ∀ s, Monotone (a s)
  a_time : ∀ {s t}, s ≤ t → ∀ j, a t j ≤ a s j
  lo_nonneg : ∀ s j, 0 ≤ lo s j
  lo_hi : ∀ s j, lo s j ≤ hi s j
  hi_le_one : ∀ s j, hi s j ≤ 1
  hi_time : ∀ {s t}, s ≤ t → ∀ j, hi t j ≤ hi s j
  lo_time : ∀ {s t}, s ≤ t → ∀ j, lo t j ≤ lo s j
  separated : ∀ s j k, j < k → hi s k ≤ lo s j

def Skip (M : Model S) (alpha delta : ℝ) (s t : S) (j : ℕ) : Prop :=
  M.hi s j - M.lo t j > (M.cost t - M.cost s) / alpha + delta

def IndexWin (M : Model S) (good : S → ℕ → Prop) (u : ℝ)
    (s t : S) (j : ℕ) : Prop :=
  good t j ∨ u ≤ M.a s j - M.a t j

theorem lo_below_hi (M : Model S) (s : S) {j k : ℕ} (h : j ≤ k) :
    M.lo s k ≤ M.hi s j := by
  rcases eq_or_lt_of_le h with rfl | h
  · exact M.lo_hi s j
  · exact le_trans (M.lo_hi s k) (le_trans (M.separated s j k h) (M.lo_hi s j))

theorem hi_antitone (M : Model S) (s : S) :
    Antitone (M.hi s) := by
  intro j k h
  rcases eq_or_lt_of_le h with rfl | h
  · rfl
  · exact le_trans (M.separated s j k h) (M.lo_hi s j)

theorem lo_antitone (M : Model S) (s : S) :
    Antitone (M.lo s) := by
  intro j k h
  rcases eq_or_lt_of_le h with rfl | h
  · rfl
  · exact le_trans (M.lo_hi s k) (M.separated s j k h)

theorem skip_bounds (M : Model S) {alpha delta : ℝ}
    (ha : 0 < alpha) (hd : 0 ≤ delta) {s t : S} {j : ℕ}
    (hst : s ≤ t) (h : Skip M alpha delta s t j) :
    M.cost t - M.cost s ≤ alpha * (M.hi s j - M.lo t j) ∧
      delta < M.hi s j - M.lo t j := by
  have hc : 0 ≤ M.cost t - M.cost s := sub_nonneg.mpr (M.cost_mono hst)
  have hdiv : 0 ≤ (M.cost t - M.cost s) / alpha := div_nonneg hc ha.le
  have hraw : (M.cost t - M.cost s) / alpha <
      (M.hi s j - M.lo t j) - delta := by
    unfold Skip at h
    linarith
  have hmul := (div_lt_iff₀ ha).mp hraw
  constructor
  · nlinarith [mul_nonneg ha.le hd]
  · unfold Skip at h
    linarith

theorem sweep_raw (M : Model S) (Win : S → S → ℕ → Prop)
    {alpha delta B : ℝ} (ha : 0 < alpha) (hd : 0 ≤ delta)
    (visit : ∀ s j, ∃ t, s ≤ t ∧
      ((Win s t j ∧ M.cost t - M.cost s ≤ B) ∨ Skip M alpha delta s t j))
    (n b : ℕ) (s : S) (hn : 0 < n) :
    ∃ t, s ≤ t ∧
      (((∃ j v, s ≤ v ∧ v ≤ t ∧ b ≤ j ∧ j < b + n ∧ Win v t j) ∧
          M.cost t - M.cost s ≤
            alpha * (M.hi s b - M.lo t (b + n - 1)) + B) ∨
        (M.cost t - M.cost s ≤ alpha * (M.hi s b - M.lo t (b + n - 1)) ∧
          (n : ℝ) * delta < M.hi s b - M.lo t (b + n - 1))) := by
  induction n generalizing b s with
  | zero => omega
  | succ n ih =>
      rcases visit s b with ⟨t, hst, hvisit⟩
      have hlast : b + (n + 1) - 1 = b + n := by omega
      rcases hvisit with hwin | hskip
      · refine ⟨t, hst, Or.inl ?_⟩
        constructor
        · exact ⟨b, s, le_rfl, hst, le_rfl, by omega, hwin.1⟩
        · have hspan' : 0 ≤ M.hi s b - M.lo t (b + n) := by
            have hl := le_trans (M.lo_time hst (b + n))
              (lo_below_hi M s (show b ≤ b + n by omega))
            linarith
          rw [hlast]
          nlinarith [mul_nonneg ha.le hspan']
      · obtain ⟨hcost, hwidth⟩ := skip_bounds M ha hd hst hskip
        by_cases hz : n = 0
        · subst n
          refine ⟨t, hst, Or.inr ?_⟩
          simpa using And.intro hcost hwidth
        · have hn' : 0 < n := by omega
          rcases ih (b + 1) t hn' with ⟨v, htv, hv⟩
          have hnext := M.separated t b (b + 1) (by omega)
          have hnext_mul := mul_le_mul_of_nonneg_left hnext ha.le
          have hind : b + 1 + n - 1 = b + n := by omega
          rw [hind] at hv
          refine ⟨v, le_trans hst htv, ?_⟩
          rw [hlast]
          rcases hv with ⟨⟨j, w, htw, hwv, hjlo, hjhi, hjwin⟩, hvcost⟩ |
            ⟨hvcost, hvwidth⟩
          · left
            constructor
            · exact ⟨j, w, le_trans hst htw, hwv, by omega, by omega, hjwin⟩
            · nlinarith
          · right
            constructor
            · nlinarith
            · push_cast
              nlinarith

theorem ordered_sweep (M : Model S) (Win : S → S → ℕ → Prop)
    {alpha delta B : ℝ} (ha : 0 < alpha) (hd : 0 ≤ delta)
    (visit : ∀ s j, ∃ t, s ≤ t ∧
      ((Win s t j ∧ M.cost t - M.cost s ≤ B) ∨ Skip M alpha delta s t j))
    (n b : ℕ) (s : S) (hcount : 1 ≤ (n : ℝ) * delta) :
    ∃ t j v, s ≤ v ∧ v ≤ t ∧ b ≤ j ∧ j < b + n ∧ Win v t j ∧
      M.cost t - M.cost s ≤ alpha * (M.hi s b - M.lo t (b + n - 1)) + B := by
  have hn : 0 < n := by
    by_contra h
    have : n = 0 := by omega
    subst n
    norm_num at hcount
  rcases sweep_raw M Win ha hd visit n b s hn with ⟨t, hst, h⟩
  rcases h with ⟨⟨j, v, hsv, hvt, hjlo, hjhi, hw⟩, hc⟩ | ⟨_, hp⟩
  · exact ⟨t, j, v, hsv, hvt, hjlo, hjhi, hw, hc⟩
  · have hlo := M.lo_nonneg t (b + n - 1)
    have hhi := M.hi_le_one s b
    linarith

theorem shifted_step {alpha delta c c' x : ℝ} (ha : alpha ≠ 0)
    (hc : c' ≤ c + 2 * (c / alpha + delta) * x) :
    c' + alpha * delta ≤ (c + alpha * delta) * (1 + 2 * x / alpha) := by
  have hid : (c + alpha * delta) * (1 + 2 * x / alpha) =
      c + alpha * delta + 2 * (c / alpha + delta) * x := by
    field_simp
  rw [hid]
  linarith

theorem index_cost {alpha delta u eps b c : ℝ}
    (ha : 0 < alpha) (hd : 0 ≤ delta) (hb : b ≤ u)
    (hscale : delta * Real.exp (2 * u / alpha) ≤ eps)
    (hpot : c + alpha * delta ≤ alpha * delta * Real.exp (2 * b / alpha)) :
    c ≤ alpha * eps := by
  have he : Real.exp (2 * b / alpha) ≤ Real.exp (2 * u / alpha) := by
    apply Real.exp_le_exp.mpr
    gcongr
  calc
    c ≤ c + alpha * delta := le_add_of_nonneg_right (mul_nonneg ha.le hd)
    _ ≤ alpha * delta * Real.exp (2 * b / alpha) := hpot
    _ ≤ alpha * delta * Real.exp (2 * u / alpha) :=
      mul_le_mul_of_nonneg_left he (mul_nonneg ha.le hd)
    _ = alpha * (delta * Real.exp (2 * u / alpha)) := by ring
    _ ≤ alpha * eps := mul_le_mul_of_nonneg_left hscale ha.le

theorem index_aux (M : Model S) (good : S → ℕ → Prop)
    {alpha delta u eta eps : ℝ}
    (ha : 0 < alpha) (hd : 0 ≤ delta) (heta : 0 < eta)
    (hscale : delta * Real.exp (2 * u / alpha) ≤ eps)
    (offer : ∀ s j, ¬ good s j → ∀ x, 0 < x → x ≤ eta →
      ∃ t, s ≤ t ∧ x ≤ M.a s j - M.a t j ∧
        M.cost t - M.cost s ≤ 2 * (M.hi s j - M.lo s j) * x)
    (s : S) (j k : ℕ) (v : S) (b : ℝ)
    (hsv : s ≤ v) (hb : 0 ≤ b) (hbu : b ≤ u)
    (hbdrop : b ≤ M.a s j - M.a v j)
    (hrem : u - (M.a s j - M.a v j) ≤ (k : ℝ) * eta)
    (hpot : M.cost v - M.cost s + alpha * delta ≤
      alpha * delta * Real.exp (2 * b / alpha)) :
    ∃ t, v ≤ t ∧ M.cost t - M.cost s ≤ alpha * eps ∧
      (IndexWin M good u s t j ∨ Skip M alpha delta s t j) := by
  induction k generalizing v b with
  | zero =>
      refine ⟨v, le_rfl, index_cost ha hd hbu hscale hpot, Or.inl (Or.inr ?_)⟩
      simpa using hrem
  | succ k ih =>
      by_cases hg : good v j
      · exact ⟨v, le_rfl, index_cost ha hd hbu hscale hpot, Or.inl (Or.inl hg)⟩
      by_cases ht : u ≤ M.a s j - M.a v j
      · exact ⟨v, le_rfl, index_cost ha hd hbu hscale hpot, Or.inl (Or.inr ht)⟩
      by_cases hs : Skip M alpha delta s v j
      · exact ⟨v, le_rfl, index_cost ha hd hbu hscale hpot, Or.inr hs⟩
      have hr : 0 < u - (M.a s j - M.a v j) := by linarith
      let x := min eta (u - (M.a s j - M.a v j))
      have hx : 0 < x := lt_min heta hr
      have hxe : x ≤ eta := min_le_left _ _
      have hxr : x ≤ u - (M.a s j - M.a v j) := min_le_right _ _
      rcases offer v j hg x hx hxe with ⟨w, hvw, hdrop, hstep⟩
      have hp : M.hi s j - M.lo v j ≤
          (M.cost v - M.cost s) / alpha + delta := le_of_not_gt hs
      have hhi := M.hi_time hsv j
      have hstep' : M.cost w - M.cost s ≤
          (M.cost v - M.cost s) +
            2 * ((M.cost v - M.cost s) / alpha + delta) * x := by
        have h1 := mul_le_mul_of_nonneg_right hhi (show 0 ≤ 2 * x by positivity)
        have h2 := mul_le_mul_of_nonneg_right hp (show 0 ≤ 2 * x by positivity)
        nlinarith
      have hshift := shifted_step ha.ne' hstep'
      have hfac : 0 ≤ 1 + 2 * x / alpha := by positivity
      have hexp : 1 + 2 * x / alpha ≤ Real.exp (2 * x / alpha) := by
        simpa [add_comm] using Real.add_one_le_exp (2 * x / alpha)
      have hcoef : 0 ≤ alpha * delta * Real.exp (2 * b / alpha) := by positivity
      have hpot' : M.cost w - M.cost s + alpha * delta ≤
          alpha * delta * Real.exp (2 * (b + x) / alpha) := by
        calc
          _ ≤ (M.cost v - M.cost s + alpha * delta) * (1 + 2 * x / alpha) :=
            hshift
          _ ≤ (alpha * delta * Real.exp (2 * b / alpha)) * (1 + 2 * x / alpha) :=
            mul_le_mul_of_nonneg_right hpot hfac
          _ ≤ (alpha * delta * Real.exp (2 * b / alpha)) *
              Real.exp (2 * x / alpha) := mul_le_mul_of_nonneg_left hexp hcoef
          _ = alpha * delta * Real.exp (2 * (b + x) / alpha) := by
            rw [mul_assoc, ← Real.exp_add]
            congr 2
            ring
      have hrem' : u - (M.a s j - M.a w j) ≤ (k : ℝ) * eta := by
        rcases le_total eta (u - (M.a s j - M.a v j)) with h | h
        · have hxeq : x = eta := min_eq_left h
          push_cast at hrem
          nlinarith
        · have hxeq : x = u - (M.a s j - M.a v j) := min_eq_right h
          have hk : 0 ≤ (k : ℝ) * eta := by positivity
          linarith
      rcases ih w (b + x) (le_trans hsv hvw) (by linarith)
          (by linarith) (by linarith) hrem' hpot' with ⟨t, hwt, htc, hstop⟩
      exact ⟨t, le_trans hvw hwt, htc, hstop⟩

theorem index_visit (M : Model S) (good : S → ℕ → Prop)
    {alpha delta u eta eps : ℝ}
    (ha : 0 < alpha) (hd : 0 ≤ delta) (hu : 0 < u) (heta : 0 < eta)
    (hscale : delta * Real.exp (2 * u / alpha) ≤ eps)
    (offer : ∀ s j, ¬ good s j → ∀ x, 0 < x → x ≤ eta →
      ∃ t, s ≤ t ∧ x ≤ M.a s j - M.a t j ∧
        M.cost t - M.cost s ≤ 2 * (M.hi s j - M.lo s j) * x)
    (s : S) (j : ℕ) :
    ∃ t, s ≤ t ∧
      ((IndexWin M good u s t j ∧ M.cost t - M.cost s ≤ alpha * eps) ∨
        Skip M alpha delta s t j) := by
  obtain ⟨k, hk⟩ := exists_nat_gt (u / eta)
  have hrem : u ≤ (k : ℝ) * eta := le_of_lt ((div_lt_iff₀ heta).mp hk)
  rcases index_aux M good ha hd heta hscale offer s j k s 0 le_rfl
      (by norm_num) hu.le (by simp) (by simpa using hrem) (by simp)
      with ⟨t, hst, hc, h⟩
  refine ⟨t, hst, ?_⟩
  rcases h with hw | hs
  · exact Or.inl ⟨hw, hc⟩
  · exact Or.inr hs

theorem subblock_visit (M : Model S) (good : S → ℕ → Prop)
    {alpha delta u eta eps : ℝ}
    (ha : 0 < alpha) (hd : 0 ≤ delta) (hu : 0 < u) (heta : 0 < eta)
    (hscale : delta * Real.exp (2 * u / alpha) ≤ eps)
    (offer : ∀ s j, ¬ good s j → ∀ x, 0 < x → x ≤ eta →
      ∃ t, s ≤ t ∧ x ≤ M.a s j - M.a t j ∧
        M.cost t - M.cost s ≤ 2 * (M.hi s j - M.lo s j) * x)
    (n b : ℕ) (s : S) (hcount : 1 ≤ (n : ℝ) * delta) :
    ∃ t, s ≤ t ∧
      M.cost t - M.cost s ≤ alpha * (M.hi s b - M.lo t (b + n - 1) + eps) ∧
      ((∃ j, b ≤ j ∧ j < b + n ∧ good t j) ∨
        u ≤ M.a s (b + n) - M.a t b) := by
  rcases ordered_sweep M (IndexWin M good u) ha hd
      (index_visit M good ha hd hu heta hscale offer) n b s hcount
      with ⟨t, j, v, hsv, hvt, hjlo, hjhi, hwin, hc⟩
  refine ⟨t, le_trans hsv hvt, by nlinarith, ?_⟩
  rcases hwin with hg | ht
  · exact Or.inl ⟨j, hjlo, hjhi, hg⟩
  · right
    have h1 := M.a_time hsv j
    have h2 := M.a_index s (show j ≤ b + n by omega)
    have h3 := M.a_index t hjlo
    linarith

theorem implicit_step {a0 a1 d c c' : ℝ}
    (ha0 : 0 < a0) (ha : a0 < a1)
    (h : c' ≤ c + a0 * (c' / a1 + d)) :
    c' + a1 * d ≤ (a1 / (a1 - a0)) * (c + a1 * d) := by
  have ha1 : 0 < a1 := lt_trans ha0 ha
  have hden : 0 < a1 - a0 := sub_pos.mpr ha
  have hm := mul_le_mul_of_nonneg_left h ha1.le
  have hid : a1 * (c + a0 * (c' / a1 + d)) =
      a1 * c + a0 * c' + a1 * a0 * d := by
    field_simp
    ring
  rw [hid] at hm
  calc
    c' + a1 * d ≤ a1 * (c + a1 * d) / (a1 - a0) := by
      apply (le_div_iff₀ hden).mpr
      nlinarith
    _ = (a1 / (a1 - a0)) * (c + a1 * d) := by ring

theorem prefix_budget {a d R c : ℝ} {k q : ℕ}
    (ha : 0 ≤ a) (hd : 0 ≤ d) (hR : 1 ≤ R) (hk : k ≤ q)
    (hgeo : d * (R ^ q - 1) ≤ 1)
    (hpot : c + a * d ≤ a * d * R ^ k) : c ≤ a := by
  have hpow : R ^ k ≤ R ^ q := pow_le_pow_right₀ hR hk
  have hp := mul_le_mul_of_nonneg_left hpow (mul_nonneg ha hd)
  have hg := mul_le_mul_of_nonneg_left hgeo ha
  nlinarith

theorem reverse_macro_aux (M : Model S) (good : S → Prop)
    (A : S → ℕ → ℝ) (P : S → ℝ)
    {a0 a1 delta eps u : ℝ} {q : ℕ}
    (ha0 : 0 < a0) (ha : a0 < a1) (hd : 0 ≤ delta)
    (he0 : 0 ≤ eps) (he1 : eps ≤ 1)
    (hq : 1 < (q : ℝ) * u)
    (hgeo : (delta + eps) * ((a1 / (a1 - a0)) ^ q - 1) ≤ 1)
    (s : S)
    (hA0 : ∀ t i, 0 ≤ A t i) (hA1 : ∀ t i, A t i ≤ 1)
    (hP : ∀ t, s ≤ t → P t ≤ 1)
    (visit : ∀ t, s ≤ t → ∀ i, i < q →
      ∃ v, t ≤ v ∧ M.cost v - M.cost t ≤ a0 * (P v + eps) ∧
        (good v ∨ u ≤ A t (i + 1) - A v i))
    (k : ℕ) (v : S) (hk : k ≤ q) (hsv : s ≤ v)
    (hdrop : ((q - k : ℕ) : ℝ) * u ≤ A s q - A v k)
    (hpot : M.cost v - M.cost s + a1 * (delta + eps) ≤
      a1 * (delta + eps) * (a1 / (a1 - a0)) ^ (q - k)) :
    ∃ t, v ≤ t ∧
      ((good t ∧ M.cost t - M.cost s ≤ a1 + 2 * a0) ∨
        P t > (M.cost t - M.cost s) / a1 + delta) := by
  have ha1 : 0 < a1 := lt_trans ha0 ha
  have hden : 0 < a1 - a0 := sub_pos.mpr ha
  have hR : 1 ≤ a1 / (a1 - a0) := by
    apply (le_div_iff₀ hden).mpr
    linarith
  have hR0 : 0 ≤ a1 / (a1 - a0) := le_trans zero_le_one hR
  have hd' : 0 ≤ delta + eps := add_nonneg hd he0
  induction k generalizing v with
  | zero =>
      have h := hA1 s q
      have h' := hA0 v 0
      simp only [Nat.sub_zero] at hdrop
      linarith
  | succ k ih =>
      by_cases hs : P v > (M.cost v - M.cost s) / a1 + delta
      · exact ⟨v, le_rfl, Or.inr hs⟩
      have hc : M.cost v - M.cost s ≤ a1 :=
        prefix_budget ha1.le hd' hR (Nat.sub_le _ _) hgeo hpot
      rcases visit v hsv k (by omega) with ⟨w, hvw, hwc, hw⟩
      rcases hw with hg | ht
      · refine ⟨w, hvw, Or.inl ⟨hg, ?_⟩⟩
        have hpw := hP w (le_trans hsv hvw)
        have hlast : M.cost w - M.cost v ≤ 2 * a0 := by
          nlinarith [mul_le_mul_of_nonneg_left (add_le_add hpw he1) ha0.le]
        linarith
      · by_cases hs' : P w > (M.cost w - M.cost s) / a1 + delta
        · exact ⟨w, hvw, Or.inr hs'⟩
        have hpw : P w ≤ (M.cost w - M.cost s) / a1 + delta :=
          le_of_not_gt hs'
        have hrec : M.cost w - M.cost s ≤ (M.cost v - M.cost s) +
            a0 * ((M.cost w - M.cost s) / a1 + (delta + eps)) := by
          have hmul := mul_le_mul_of_nonneg_left hpw ha0.le
          nlinarith
        have hshift := implicit_step ha0 ha hrec
        have hcnt : q - k = q - (k + 1) + 1 := by omega
        have hpot' : M.cost w - M.cost s + a1 * (delta + eps) ≤
            a1 * (delta + eps) * (a1 / (a1 - a0)) ^ (q - k) := by
          calc
            _ ≤ (a1 / (a1 - a0)) *
                (M.cost v - M.cost s + a1 * (delta + eps)) := hshift
            _ ≤ (a1 / (a1 - a0)) *
                (a1 * (delta + eps) * (a1 / (a1 - a0)) ^ (q - (k + 1))) :=
              mul_le_mul_of_nonneg_left hpot hR0
            _ = a1 * (delta + eps) * (a1 / (a1 - a0)) ^ (q - k) := by
              rw [hcnt, pow_succ]
              ring
        have hdrop' : ((q - k : ℕ) : ℝ) * u ≤ A s q - A w k := by
          rw [hcnt]
          push_cast
          linarith
        rcases ih w (by omega) (le_trans hsv hvw) hdrop' hpot'
            with ⟨t, hwt, hresult⟩
        exact ⟨t, le_trans hvw hwt, hresult⟩

theorem reverse_macro (M : Model S) (good : S → Prop)
    (A : S → ℕ → ℝ) (P : S → ℝ)
    {a0 a1 delta eps u : ℝ} {q : ℕ}
    (ha0 : 0 < a0) (ha : a0 < a1) (hd : 0 ≤ delta)
    (he0 : 0 ≤ eps) (he1 : eps ≤ 1)
    (hq : 1 < (q : ℝ) * u)
    (hgeo : (delta + eps) * ((a1 / (a1 - a0)) ^ q - 1) ≤ 1)
    (s : S)
    (hA0 : ∀ t i, 0 ≤ A t i) (hA1 : ∀ t i, A t i ≤ 1)
    (hP : ∀ t, s ≤ t → P t ≤ 1)
    (visit : ∀ t, s ≤ t → ∀ i, i < q →
      ∃ v, t ≤ v ∧ M.cost v - M.cost t ≤ a0 * (P v + eps) ∧
        (good v ∨ u ≤ A t (i + 1) - A v i)) :
    ∃ t, s ≤ t ∧
      ((good t ∧ M.cost t - M.cost s ≤ a1 + 2 * a0) ∨
        P t > (M.cost t - M.cost s) / a1 + delta) := by
  exact reverse_macro_aux M good A P ha0 ha hd he0 he1 hq hgeo s
    hA0 hA1 hP visit q s le_rfl le_rfl (by simp) (by simp)

theorem macro_visit (M : Model S) (good : S → ℕ → Prop)
    {a0 a1 d0 d1 u eta eps : ℝ} {n q : ℕ}
    (ha0 : 0 < a0) (ha : a0 < a1)
    (hd0 : 0 ≤ d0) (hd1 : 0 ≤ d1) (hu : 0 < u) (heta : 0 < eta)
    (he0 : 0 ≤ eps) (he1 : eps ≤ 1)
    (hn : 1 ≤ (n : ℝ) * d0) (hq : 1 < (q : ℝ) * u)
    (hscale : d0 * Real.exp (2 * u / a0) ≤ eps)
    (hgeo : (d1 + eps) * ((a1 / (a1 - a0)) ^ q - 1) ≤ 1)
    (offer : ∀ s j, ¬ good s j → ∀ x, 0 < x → x ≤ eta →
      ∃ t, s ≤ t ∧ x ≤ M.a s j - M.a t j ∧
        M.cost t - M.cost s ≤ 2 * (M.hi s j - M.lo s j) * x)
    (s : S) (b : ℕ) :
    ∃ t, s ≤ t ∧
      (((∃ j, b ≤ j ∧ j < b + q * n ∧ good t j) ∧
          M.cost t - M.cost s ≤ a1 + 2 * a0) ∨
        M.hi s b - M.lo t (b + q * n - 1) >
          (M.cost t - M.cost s) / a1 + d1) := by
  have hn0 : 0 < n := by
    by_contra h
    have : n = 0 := by omega
    subst n
    norm_num at hn
  have hq0 : 0 < q := by
    by_contra h
    have : q = 0 := by omega
    subst q
    norm_num at hq
  let A := fun t i => M.a t (b + i * n)
  let P := fun t => M.hi s b - M.lo t (b + q * n - 1)
  let G := fun t => ∃ j, b ≤ j ∧ j < b + q * n ∧ good t j
  apply reverse_macro M G A P ha0 ha hd1 he0 he1 hq hgeo s
    (fun t i => M.a_nonneg t _) (fun t i => M.a_le_one t _)
  · intro t hst
    dsimp [P]
    have h1 := M.hi_le_one s b
    have h2 := M.lo_nonneg t (b + q * n - 1)
    linarith
  · intro v hsv i hi
    rcases subblock_visit M good ha0 hd0 hu heta hscale offer n (b + i * n) v hn
      with ⟨w, hvw, hwc, hw⟩
    have hend : b + i * n + n ≤ b + q * n := by
      have hmul := Nat.mul_le_mul_right n (show i + 1 ≤ q by omega)
      simp only [Nat.add_mul, one_mul] at hmul
      omega
    have hlo := lo_antitone M w
      (show b + i * n + n - 1 ≤ b + q * n - 1 by omega)
    have hhi : M.hi v (b + i * n) ≤ M.hi s b :=
      le_trans (M.hi_time hsv _) (hi_antitone M s (by omega))
    have hspan : M.hi v (b + i * n) - M.lo w (b + i * n + n - 1) ≤ P w := by
      dsimp [P]
      linarith
    refine ⟨w, hvw, ?_, ?_⟩
    · have hmul := mul_le_mul_of_nonneg_left hspan ha0.le
      linarith
    · rcases hw with ⟨j, hj0, hj1, hg⟩ | ht
      · exact Or.inl ⟨j, by omega, by omega, hg⟩
      · right
        simpa [A, Nat.add_mul, Nat.add_assoc] using ht

def grouped (M : Model S) (width : ℕ) (hw : 0 < width) : Model S where
  cost := M.cost
  a := fun s j => M.a s (j * width)
  hi := fun s j => M.hi s (j * width)
  lo := fun s j => M.lo s ((j + 1) * width - 1)
  cost_mono := M.cost_mono
  a_nonneg := fun s j => M.a_nonneg s _
  a_le_one := fun s j => M.a_le_one s _
  a_index := fun s j k h => M.a_index s (Nat.mul_le_mul_right width h)
  a_time := fun h j => M.a_time h _
  lo_nonneg := fun s j => M.lo_nonneg s _
  lo_hi := by
    intro s j
    apply lo_below_hi M s
    simp only [Nat.add_mul, one_mul]
    omega
  hi_le_one := fun s j => M.hi_le_one s _
  hi_time := fun h j => M.hi_time h _
  lo_time := fun h j => M.lo_time h _
  separated := by
    intro s j k h
    apply M.separated s
    have hmul := Nat.mul_le_mul_right width (show j + 1 ≤ k by omega)
    have hpos : 0 < (j + 1) * width := Nat.mul_pos (by omega) hw
    omega

theorem finite_search (M : Model S) (good : S → ℕ → Prop)
    {a0 a1 d0 d1 u eta eps : ℝ} {n q N : ℕ}
    (ha0 : 0 < a0) (ha : a0 < a1)
    (hd0 : 0 ≤ d0) (hd1 : 0 ≤ d1) (hu : 0 < u) (heta : 0 < eta)
    (he0 : 0 ≤ eps) (he1 : eps ≤ 1)
    (hn : 1 ≤ (n : ℝ) * d0) (hN : 1 ≤ (N : ℝ) * d1)
    (hq : 1 < (q : ℝ) * u)
    (hscale : d0 * Real.exp (2 * u / a0) ≤ eps)
    (hgeo : (d1 + eps) * ((a1 / (a1 - a0)) ^ q - 1) ≤ 1)
    (offer : ∀ s j, ¬ good s j → ∀ x, 0 < x → x ≤ eta →
      ∃ t, s ≤ t ∧ x ≤ M.a s j - M.a t j ∧
        M.cost t - M.cost s ≤ 2 * (M.hi s j - M.lo s j) * x)
    (s : S) :
    ∃ t j, s ≤ t ∧ j < N * q * n ∧ good t j ∧
      M.cost t - M.cost s ≤ 2 * a1 + 2 * a0 ∧
      M.cost t - M.cost s ≤ 4 * a1 := by
  have hn0 : 0 < n := by
    by_contra h
    have : n = 0 := by omega
    subst n
    norm_num at hn
  have hq0 : 0 < q := by
    by_contra h
    have : q = 0 := by omega
    subst q
    norm_num at hq
  have hw : 0 < q * n := Nat.mul_pos hq0 hn0
  let G := grouped M (q * n) hw
  let Win := fun (_ : S) t i =>
    ∃ j, i * (q * n) ≤ j ∧ j < (i + 1) * (q * n) ∧ good t j
  have hvisit : ∀ v i, ∃ t, v ≤ t ∧
      ((Win v t i ∧ G.cost t - G.cost v ≤ a1 + 2 * a0) ∨
        Skip G a1 d1 v t i) := by
    intro v i
    rcases macro_visit M good ha0 ha hd0 hd1 hu heta he0 he1 hn hq
        hscale hgeo offer v (i * (q * n)) with ⟨t, hvt, h⟩
    refine ⟨t, hvt, ?_⟩
    simpa [Win, G, grouped, Skip, Nat.add_mul, Nat.add_assoc] using h
  rcases ordered_sweep G Win (lt_trans ha0 ha) hd1 hvisit N 0 s hN
    with ⟨t, i, v, hsv, hvt, _, hi, ⟨j, hj0, hj1, hjg⟩, hc⟩
  have hmul := Nat.mul_le_mul_right (q * n) (show i + 1 ≤ N by omega)
  have hj : j < N * q * n := by
    rw [Nat.mul_assoc]
    omega
  have hspan : G.hi s 0 - G.lo t (0 + N - 1) ≤ 1 := by
    have h1 := G.hi_le_one s 0
    have h2 := G.lo_nonneg t (0 + N - 1)
    linarith
  have hbudget : M.cost t - M.cost s ≤ 2 * a1 + 2 * a0 := by
    have hm := mul_le_mul_of_nonneg_left hspan (lt_trans ha0 ha).le
    change M.cost t - M.cost s ≤ a1 * _ + _ at hc
    nlinarith
  exact ⟨t, j, le_trans hsv hvt, hj, hjg, hbudget, by linarith⟩

theorem paper_scale {t ell : ℝ} (ht : 0 < t) (hl : 0 < ell) :
    Real.exp (-ell / 2) *
        Real.exp (2 * (1 / t ^ 2) / (100 / (t ^ 2 * ell))) ≤
      Real.exp (-2 * ell / 5) := by
  have hid : 2 * (1 / t ^ 2) / (100 / (t ^ 2 * ell)) = ell / 50 := by
    field_simp
    ring
  rw [hid, ← Real.exp_add]
  apply Real.exp_le_exp.mpr
  linarith

theorem paper_ratio {t ell : ℝ} (ht : 1 ≤ t) (hl : 0 < ell) :
    (100000 / (ell * t)) /
        (100000 / (ell * t) - 100 / (t ^ 2 * ell)) =
      1 / (1 - 1 / (1000 * t)) := by
  have ht0 : 0 < t := by linarith
  have hA : (100000 / (ell * t) : ℝ) ≠ 0 := by positivity
  have hprod : 100 / (t ^ 2 * ell) =
      (100000 / (ell * t)) * (1 / (1000 * t)) := by
    field_simp
    ring
  rw [hprod]
  calc
    _ = (100000 / (ell * t)) /
        ((100000 / (ell * t)) * (1 - 1 / (1000 * t))) := by
      congr 1
      ring
    _ = _ := by rw [div_mul_eq_div_div, div_self hA]

theorem paper_geometric {t ell : ℝ} {q : ℕ}
    (ht : 1 ≤ t) (h4 : 4 ≤ Real.exp t) (hl : 5 * t ≤ ell)
    (hq : (q : ℝ) ≤ 2 * t ^ 2 + 1) :
    (Real.exp (-t / 2) + Real.exp (-2 * ell / 5)) *
        ((1 / (1 - 1 / (1000 * t))) ^ q - 1) ≤ 1 := by
  have ht0 : 0 < t := by linarith
  let beta : ℝ := 1 / (1000 * t)
  have hb0 : 0 ≤ beta := by dsimp [beta]; positivity
  have hb : beta ≤ 1 / 2 := by
    dsimp [beta]
    apply (div_le_iff₀ (show 0 < 1000 * t by positivity)).mpr
    linarith
  have hden : 0 < 1 - beta := by linarith
  have hR0 : 0 ≤ 1 / (1 - beta) := by positivity
  have hlin : 1 / (1 - beta) ≤ 1 + 2 * beta := by
    apply (div_le_iff₀ hden).mpr
    nlinarith
  have hexp : 1 / (1 - beta) ≤ Real.exp (2 * beta) :=
    le_trans hlin (by simpa [add_comm] using Real.add_one_le_exp (2 * beta))
  have hpow : (1 / (1 - beta)) ^ q ≤ Real.exp (2 * beta) ^ q := by
    gcongr
  have hqb : (q : ℝ) * (2 * beta) ≤ 3 * t / 500 := by
    have hmul := mul_le_mul_of_nonneg_right hq
      (show 0 ≤ 2 * beta by positivity)
    have hid : (2 * t ^ 2 + 1) * (2 * beta) =
        (4 * t ^ 2 + 2) / (1000 * t) := by
      dsimp [beta]
      ring
    rw [hid] at hmul
    have hfrac : (4 * t ^ 2 + 2) / (1000 * t) ≤ 3 * t / 500 := by
      apply (div_le_iff₀ (show 0 < 1000 * t by positivity)).mpr
      nlinarith [sq_nonneg (t - 1)]
    exact le_trans hmul hfrac
  have hpow' : (1 / (1 - beta)) ^ q ≤ Real.exp (3 * t / 500) := by
    calc
      _ ≤ Real.exp ((q : ℝ) * (2 * beta)) := by
        simpa [Real.exp_nat_mul] using hpow
      _ ≤ _ := Real.exp_le_exp.mpr hqb
  have hneg : Real.exp (-t) ≤ 1 / 4 := by
    have hp : Real.exp (-t) * Real.exp t = 1 := by
      rw [← Real.exp_add]
      simp
    have hm := mul_le_mul_of_nonneg_left h4 (Real.exp_nonneg (-t))
    nlinarith
  have hquarter : Real.exp (-t / 4) ≤ 3 / 4 := by
    have hp : Real.exp (-t / 4) ^ 4 ≤ 1 / 4 := by
      have hid : Real.exp (-t / 4) ^ 4 = Real.exp (-t) := by
        rw [← Real.exp_nat_mul]
        congr 1
        norm_num
        ring
      rw [hid]
      exact hneg
    by_contra h
    have hx : (3 / 4 : ℝ) ≤ Real.exp (-t / 4) := by linarith
    have hpx : (3 / 4 : ℝ) ^ 4 ≤ Real.exp (-t / 4) ^ 4 := by
      gcongr
    norm_num at hpx
    linarith
  have hfirst : Real.exp (-t / 2) * Real.exp (3 * t / 500) ≤ 3 / 4 := by
    rw [← Real.exp_add]
    exact le_trans (Real.exp_le_exp.mpr (by linarith)) hquarter
  have hsecond : Real.exp (-2 * ell / 5) * Real.exp (3 * t / 500) ≤ 1 / 4 := by
    rw [← Real.exp_add]
    exact le_trans (Real.exp_le_exp.mpr (by linarith)) hneg
  have hs : 0 ≤ Real.exp (-t / 2) + Real.exp (-2 * ell / 5) := by positivity
  have hm := mul_le_mul_of_nonneg_left hpow' hs
  change (Real.exp (-t / 2) + Real.exp (-2 * ell / 5)) *
    ((1 / (1 - beta)) ^ q - 1) ≤ 1
  nlinarith

theorem manuscript_search (M : Model S) (good : S → ℕ → Prop)
    {t ell eta : ℝ} {n N q : ℕ}
    (ht : 1 ≤ t) (h4 : 4 ≤ Real.exp t) (hl : 5 * t ≤ ell)
    (hnexp : (n : ℝ) = Real.exp ell) (hNexp : (N : ℝ) = Real.exp t)
    (hq0 : 2 * t ^ 2 ≤ (q : ℝ)) (hq1 : (q : ℝ) ≤ 2 * t ^ 2 + 1)
    (heta : 0 < eta)
    (offer : ∀ s j, ¬ good s j → ∀ x, 0 < x → x ≤ eta →
      ∃ v, s ≤ v ∧ x ≤ M.a s j - M.a v j ∧
        M.cost v - M.cost s ≤ 2 * (M.hi s j - M.lo s j) * x)
    (s : S) :
    ∃ v j, s ≤ v ∧ j < N * q * n ∧ good v j ∧
      M.cost v - M.cost s ≤ 4 * (100000 / (ell * t)) := by
  have ht0 : 0 < t := by linarith
  have hl0 : 0 < ell := by linarith
  have ha0 : 0 < 100 / (t ^ 2 * ell) := by positivity
  have ha : 100 / (t ^ 2 * ell) < 100000 / (ell * t) := by
    apply (div_lt_div_iff₀ (show 0 < t ^ 2 * ell by positivity)
      (show 0 < ell * t by positivity)).mpr
    have hp := mul_pos (mul_pos hl0 ht0) (show 0 < 1000 * t - 1 by linarith)
    nlinarith
  have hu : 0 < 1 / t ^ 2 := by positivity
  have he1 : Real.exp (-2 * ell / 5) ≤ 1 := by
    calc
      _ ≤ Real.exp 0 := Real.exp_le_exp.mpr (by linarith)
      _ = 1 := by simp
  have hn : 1 ≤ (n : ℝ) * Real.exp (-ell / 2) := by
    rw [hnexp, ← Real.exp_add]
    calc
      1 = Real.exp 0 := by simp
      _ ≤ _ := Real.exp_le_exp.mpr (by linarith)
  have hN : 1 ≤ (N : ℝ) * Real.exp (-t / 2) := by
    rw [hNexp, ← Real.exp_add]
    calc
      1 = Real.exp 0 := by simp
      _ ≤ _ := Real.exp_le_exp.mpr (by linarith)
  have hq : 1 < (q : ℝ) * (1 / t ^ 2) := by
    rw [mul_one_div]
    apply (lt_div_iff₀ (show 0 < t ^ 2 by positivity)).mpr
    nlinarith
  have hgeo : (Real.exp (-t / 2) + Real.exp (-2 * ell / 5)) *
      (((100000 / (ell * t)) /
        (100000 / (ell * t) - 100 / (t ^ 2 * ell))) ^ q - 1) ≤ 1 := by
    rw [paper_ratio ht hl0]
    exact paper_geometric ht h4 hl hq1
  rcases finite_search M good ha0 ha
      (Real.exp_nonneg _) (Real.exp_nonneg _) hu heta
      (Real.exp_nonneg _) he1 hn hN hq (paper_scale ht0 hl0) hgeo offer s
      with ⟨v, j, hsv, hj, hg, _, hc⟩
  exact ⟨v, j, hsv, hj, hg, hc⟩

#print axioms finite_search
#print axioms manuscript_search

end EntropyRefinement
