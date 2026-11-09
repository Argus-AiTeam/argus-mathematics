import Mathlib

noncomputable section

namespace RefinementAudit

def update (δ p y : ℝ) : ℝ :=
  min p (max (p / (1 + δ)) y)

def oracleDefect (c δ κ p minimum : ℝ) : ℝ :=
  max (p - (1 + δ) * minimum - κ * δ * c) 0

theorem oracleDefect_nonneg (c δ κ p minimum : ℝ) :
    0 ≤ oracleDefect c δ κ p minimum := le_max_right _ _

theorem oracleDefect_upper {c δ κ p minimum current : ℝ}
    (hδ : 0 < δ) (hm : minimum ≤ current) :
    p ≤ (1 + δ) * current + κ * δ * c +
      oracleDefect c δ κ p minimum := by
  have h := le_max_left (p - (1 + δ) * minimum - κ * δ * c) 0
  have hmul := mul_le_mul_of_nonneg_left hm (by linarith : 0 ≤ 1 + δ)
  unfold oracleDefect
  linarith

theorem oracleDefect_minimal {c δ κ p minimum ε : ℝ}
    (hε : 0 ≤ ε) (hp : p ≤ (1 + δ) * minimum + κ * δ * c + ε) :
    oracleDefect c δ κ p minimum ≤ ε := by
  unfold oracleDefect
  exact max_le (by linarith) hε

theorem update_lower {δ p y lower : ℝ}
    (hp : lower ≤ p) (hy : lower ≤ y) :
    lower ≤ update δ p y := by
  exact le_min hp (hy.trans (le_max_right _ _))

theorem update_upper (δ p y : ℝ) : update δ p y ≤ p :=
  min_le_left _ _

theorem update_zero (δ y : ℝ) : update δ 0 y = 0 := by
  simp [update]

theorem update_floor {δ p y : ℝ} (hδ : 0 < δ) (hp : 0 ≤ p) :
    p / (1 + δ) ≤ update δ p y := by
  have hd : 0 < 1 + δ := by linarith
  have hfloor : p / (1 + δ) ≤ p := by
    apply (div_le_iff₀ hd).2
    nlinarith [mul_nonneg hp (le_of_lt hδ)]
  exact le_min hfloor (le_max_left _ _)

theorem update_spatial {δ p p' y y' charge : ℝ}
    (hδ : 0 < δ) (hp' : 0 ≤ p')
    (hcone : p ≤ p' + charge) :
    update δ p y ≤ (1 + δ) * update δ p' y' + charge := by
  have hd : 0 < 1 + δ := by linarith
  have hf := update_floor (y := y') hδ hp'
  have hm := (div_le_iff₀ hd).1 hf
  have hu := update_upper δ p y
  nlinarith

theorem prefix_step {c δ κ p y previous current ε : ℝ}
    (_hc : 0 ≤ c) (hδ : 0 < δ) (hκ : 0 ≤ κ)
    (hcurrent : c ≤ current) (hdecrease : current ≤ previous)
    (hp : p ≤ previous) (hy : y ≤ current) (hε : 0 ≤ ε)
    (hgroup : p ≤ (1 + δ) * current + κ * δ * c + ε) :
    max c (update δ p y) ≤ current + κ * (previous - current) + ε := by
  have hd : 0 < 1 + δ := by linarith
  have hdec : 0 ≤ previous - current := sub_nonneg.mpr hdecrease
  have hkdec : 0 ≤ κ * (previous - current) := mul_nonneg hκ hdec
  apply max_le
  · linarith
  · by_cases hsmall : update δ p y ≤ current
    · linarith
    · have hfloor : current < p / (1 + δ) := by
        by_contra h
        have hf : p / (1 + δ) ≤ current := le_of_not_gt h
        exact hsmall ((min_le_right _ _).trans (max_le hf hy))
      have hu : update δ p y ≤ p / (1 + δ) := by
        unfold update
        rw [max_eq_left (hy.trans (le_of_lt hfloor))]
        exact min_le_right _ _
      have hmul : current * (1 + δ) < p := (lt_div_iff₀ hd).1 hfloor
      have hδc : δ * c ≤ previous - current := by
        have h := mul_le_mul_of_nonneg_left hcurrent (le_of_lt hδ)
        nlinarith
      have hκδc : κ * δ * c ≤ κ * (previous - current) := by
        simpa [mul_assoc] using mul_le_mul_of_nonneg_left hδc hκ
      have hnum :
          p ≤ (current + κ * (previous - current) + ε) * (1 + δ) := by
        nlinarith [mul_nonneg hkdec (le_of_lt hδ),
          mul_nonneg hε (le_of_lt hδ)]
      exact hu.trans ((div_le_iff₀ hd).2 hnum)

theorem crossing_step {c δ κ p y current clippedChildren ε : ℝ}
    (hc : 0 ≤ c) (hδ : 0 < δ) (hκ : 0 ≤ κ)
    (hcurrent : current < c) (hchildren : c ≤ clippedChildren)
    (hε : 0 ≤ ε)
    (hgroup : p ≤ (1 + δ) * current + κ * δ * c + ε) :
    max c (update δ p y) - clippedChildren ≤ (1 + κ) * δ * c + ε := by
  have hd : 0 ≤ 1 + δ := by linarith
  have hm := mul_le_mul_of_nonneg_left hcurrent.le hd
  have hb : 0 ≤ (1 + κ) * δ * c :=
    mul_nonneg (mul_nonneg (by linarith) (le_of_lt hδ)) hc
  have hp : p ≤ c + (1 + κ) * δ * c + ε := by nlinarith
  have hu := update_upper δ p y
  have hclip : max c (update δ p y) ≤ c + (1 + κ) * δ * c + ε :=
    max_le (by linarith) (by linarith)
  linarith

theorem after_step {c δ p y previous clippedChildren : ℝ}
    (hp : p ≤ previous) (hprevious : previous < c)
    (hchildren : c ≤ clippedChildren) :
    max c (update δ p y) - clippedChildren ≤ 0 := by
  have hu := update_upper δ p y
  rw [max_eq_left (by linarith : update δ p y ≤ c)]
  linarith

def firstCrossing {Action : Type*} (S : ℕ) (c : ℝ)
    (cost : ℕ → Action → ℝ) : ℕ := by
  classical
  exact if h : ∃ t, t < S ∧ ∃ α, cost (t + 1) α < c then Nat.find h else S

theorem firstCrossing_le {Action : Type*} (S : ℕ) (c : ℝ)
    (cost : ℕ → Action → ℝ) : firstCrossing S c cost ≤ S := by
  classical
  unfold firstCrossing
  split_ifs with h
  · exact (Nat.find_spec h).1.le
  · exact le_rfl

theorem before_firstCrossing {Action : Type*} {S t : ℕ} {c : ℝ}
    {cost : ℕ → Action → ℝ} (ht : t < firstCrossing S c cost) (α : Action) :
    c ≤ cost (t + 1) α := by
  classical
  have htS : t < S := lt_of_lt_of_le ht (firstCrossing_le S c cost)
  by_contra hbad
  have hex : ∃ u, u < S ∧ ∃ β, cost (u + 1) β < c :=
    ⟨t, htS, α, lt_of_not_ge hbad⟩
  have hfind : t < Nat.find hex := by simpa [firstCrossing, hex] using ht
  exact (Nat.find_min hex hfind) ⟨htS, α, lt_of_not_ge hbad⟩

theorem at_firstCrossing {Action : Type*} {S : ℕ} {c : ℝ}
    {cost : ℕ → Action → ℝ} (ht : firstCrossing S c cost < S) :
    ∃ α, cost (firstCrossing S c cost + 1) α < c := by
  classical
  by_cases hex : ∃ u, u < S ∧ ∃ β, cost (u + 1) β < c
  · simpa [firstCrossing, hex] using (Nat.find_spec hex).2
  · simp [firstCrossing, hex] at ht

theorem firstCrossing_step {Action : Type*} {S t : ℕ}
    {c δ κ : ℝ} (cost : ℕ → Action → ℝ)
    (pick : ℕ → Action) (cone online defect children : ℕ → ℝ)
    (hc : 0 ≤ c) (hδ : 0 < δ) (hκ : 0 ≤ κ) (ht : t < S)
    (hmono : ∀ α, Antitone (fun u => cost u α))
    (hbellman : ∀ α, cone t ≤ cost t α)
    (honline : online t ≤ cost (t + 1) (pick t))
    (hchildren : c ≤ children t) (hdefect : 0 ≤ defect t)
    (hgroup : ∀ α,
      cone t ≤ (1 + δ) * cost (t + 1) α + κ * δ * c + defect t) :
    max c (update δ (cone t) (online t)) - children t ≤
      (if t < firstCrossing S c cost then
        cost (t + 1) (pick t) + κ * (cost t (pick t) - cost (t + 1) (pick t)) -
          children t else 0) +
      (if t = firstCrossing S c cost then (1 + κ) * δ * c else 0) + defect t := by
  classical
  by_cases hbefore : t < firstCrossing S c cost
  · have hs := prefix_step hc hδ hκ (before_firstCrossing hbefore (pick t))
      (hmono (pick t) (Nat.le_succ t)) (hbellman (pick t)) honline hdefect
      (hgroup (pick t))
    simp only [if_pos hbefore, if_neg (Nat.ne_of_lt hbefore)]
    linarith
  · by_cases heq : t = firstCrossing S c cost
    · obtain ⟨α, hα⟩ := at_firstCrossing (heq ▸ ht)
      have hs := crossing_step (y := online t) hc hδ hκ
        (by simpa [heq] using hα) hchildren hdefect (hgroup α)
      simp only [if_neg hbefore, if_pos heq]
      linarith
    · have hafter : firstCrossing S c cost < t := by omega
      obtain ⟨α, hα⟩ := at_firstCrossing (lt_trans hafter ht)
      have hprev : cost t α < c :=
        lt_of_le_of_lt (hmono α (by omega)) hα
      have hs := after_step (δ := δ) (y := online t) (hbellman α) hprev hchildren
      simp only [if_neg hbefore, if_neg heq]
      linarith

theorem firstCrossing_defect_sum {Action : Type*} (S : ℕ) {c δ κ : ℝ}
    (cost : ℕ → Action → ℝ) (pick : ℕ → Action)
    (cone online defect children : ℕ → ℝ)
    (hc : 0 ≤ c) (hδ : 0 < δ) (hκ : 0 ≤ κ)
    (hmono : ∀ α, Antitone (fun u => cost u α))
    (hbellman : ∀ t < S, ∀ α, cone t ≤ cost t α)
    (honline : ∀ t < S, online t ≤ cost (t + 1) (pick t))
    (hchildren : ∀ t < S, c ≤ children t)
    (hdefect : ∀ t < S, 0 ≤ defect t)
    (hgroup : ∀ t < S, ∀ α,
      cone t ≤ (1 + δ) * cost (t + 1) α + κ * δ * c + defect t) :
    (∑ t ∈ Finset.range S,
      (max c (update δ (cone t) (online t)) - children t)) ≤
      (∑ t ∈ Finset.range S, if t < firstCrossing S c cost then
        cost (t + 1) (pick t) + κ * (cost t (pick t) - cost (t + 1) (pick t)) -
          children t else 0) +
      (if firstCrossing S c cost < S then (1 + κ) * δ * c else 0) +
      ∑ t ∈ Finset.range S, defect t := by
  classical
  have hs := Finset.sum_le_sum (s := Finset.range S) (fun t ht =>
    firstCrossing_step cost pick cone online defect children hc hδ hκ
      (Finset.mem_range.mp ht) hmono
      (hbellman t (Finset.mem_range.mp ht))
      (honline t (Finset.mem_range.mp ht))
      (hchildren t (Finset.mem_range.mp ht))
      (hdefect t (Finset.mem_range.mp ht))
      (hgroup t (Finset.mem_range.mp ht)))
  simpa only [Finset.sum_add_distrib, Finset.sum_ite_eq',
    Finset.mem_range] using hs

def mean {Ω : Type*} [Fintype Ω] (weight : Ω → ℝ) (f : Ω → ℝ) : ℝ :=
  ∑ ω, weight ω * f ω

theorem mean_mono {Ω : Type*} [Fintype Ω] {weight f g : Ω → ℝ}
    (hw : ∀ ω, 0 ≤ weight ω) (h : ∀ ω, f ω ≤ g ω) :
    mean weight f ≤ mean weight g := by
  exact Finset.sum_le_sum (fun ω _ => mul_le_mul_of_nonneg_left (h ω) (hw ω))

theorem mean_add {Ω : Type*} [Fintype Ω] (weight f g : Ω → ℝ) :
    mean weight (fun ω => f ω + g ω) = mean weight f + mean weight g := by
  simp [mean, mul_add, Finset.sum_add_distrib]

theorem mean_const {Ω : Type*} [Fintype Ω] (weight : Ω → ℝ)
    (hw : ∑ ω, weight ω = 1) (r : ℝ) :
    mean weight (fun _ => r) = r := by
  unfold mean
  rw [← Finset.sum_mul, hw, one_mul]

theorem mean_sum {Ω ι : Type*} [Fintype Ω] (weight : Ω → ℝ)
    (s : Finset ι) (f : Ω → ι → ℝ) :
    mean weight (fun ω => ∑ i ∈ s, f ω i) =
      ∑ i ∈ s, mean weight (fun ω => f ω i) := by
  unfold mean
  simp only [Finset.mul_sum]
  exact Finset.sum_comm

theorem expected_firstCrossing_defect {Ω Action : Type*} [Fintype Ω]
    (S : ℕ) {c δ κ allowance : ℝ}
    (cost : ℕ → Action → ℝ) (pick : Ω → ℕ → Action)
    (cone online defect : Ω → ℕ → ℝ) (children : ℕ → ℝ)
    (weight : Ω → ℝ) (budget : ℕ → ℝ)
    (hc : 0 ≤ c) (hδ : 0 < δ) (hκ : 0 ≤ κ) (hκupper : κ ≤ 1)
    (hw : ∀ ω, 0 ≤ weight ω) (hnorm : ∑ ω, weight ω = 1)
    (hmono : ∀ α, Antitone (fun u => cost u α))
    (hbellman : ∀ ω t, t < S → ∀ α, cone ω t ≤ cost t α)
    (honline : ∀ ω t, t < S → online ω t ≤ cost (t + 1) (pick ω t))
    (hchildren : ∀ t < S, c ≤ children t)
    (hdefect : ∀ ω t, t < S → 0 ≤ defect ω t)
    (hgroup : ∀ ω t, t < S → ∀ α,
      cone ω t ≤ (1 + δ) * cost (t + 1) α + κ * δ * c + defect ω t)
    (hprefix : mean weight (fun ω =>
      ∑ t ∈ Finset.range S, if t < firstCrossing S c cost then
        cost (t + 1) (pick ω t) +
          κ * (cost t (pick ω t) - cost (t + 1) (pick ω t)) - children t
        else 0) ≤ allowance)
    (hbudget : ∀ t < S, mean weight (fun ω => defect ω t) ≤ budget t) :
    mean weight (fun ω => ∑ t ∈ Finset.range S,
      (max c (update δ (cone ω t) (online ω t)) - children t)) ≤
      allowance + 2 * δ * c + ∑ t ∈ Finset.range S, budget t := by
  classical
  have hcharge :
      (if firstCrossing S c cost < S then (1 + κ) * δ * c else 0) ≤
        2 * δ * c := by
    have hδc : 0 ≤ δ * c := mul_nonneg (le_of_lt hδ) hc
    split_ifs
    · nlinarith [mul_le_mul_of_nonneg_right hκupper hδc]
    · nlinarith
  have hpoint : ∀ ω,
      (∑ t ∈ Finset.range S,
        (max c (update δ (cone ω t) (online ω t)) - children t)) ≤
      (∑ t ∈ Finset.range S, if t < firstCrossing S c cost then
        cost (t + 1) (pick ω t) +
          κ * (cost t (pick ω t) - cost (t + 1) (pick ω t)) - children t
        else 0) + 2 * δ * c + ∑ t ∈ Finset.range S, defect ω t := by
    intro ω
    have hs := firstCrossing_defect_sum S cost (pick ω) (cone ω) (online ω)
      (defect ω) children hc hδ hκ hmono (hbellman ω) (honline ω)
      hchildren (hdefect ω) (hgroup ω)
    linarith
  have hs := mean_mono hw hpoint
  rw [mean_add, mean_add, mean_const weight hnorm] at hs
  simp only [mean_sum] at hs hprefix ⊢
  have hb := Finset.sum_le_sum (s := Finset.range S)
    (fun t ht => hbudget t (Finset.mem_range.mp ht))
  linarith

theorem mean_scale {Ω : Type*} [Fintype Ω] (weight f : Ω → ℝ) (a : ℝ) :
    mean weight (fun ω => a * f ω) = a * mean weight f := by
  unfold mean
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro ω _
  ring

theorem mean_product_kernel {Env Ω : Type*} [Fintype Env] [Fintype Ω]
    (environment : Env → ℝ) (kernel : Env → Ω → ℝ) (f : Env → Ω → ℝ) :
    mean (fun eω : Env × Ω => environment eω.1 * kernel eω.1 eω.2)
        (fun eω => f eω.1 eω.2) =
      mean environment (fun e => mean (kernel e) (f e)) := by
  simp [mean, Fintype.sum_prod_type, Finset.mul_sum, mul_assoc]

theorem conditional_mean_bound {Env Ω : Type*} [Fintype Env] [Fintype Ω]
    (environment : Env → ℝ) (kernel : Env → Ω → ℝ)
    (f : Env → Ω → ℝ) (bound : Env → ℝ)
    (hw : ∀ e, 0 ≤ environment e)
    (hconditional : ∀ e, mean (kernel e) (f e) ≤ bound e) :
    mean (fun eω : Env × Ω => environment eω.1 * kernel eω.1 eω.2)
        (fun eω => f eω.1 eω.2) ≤ mean environment bound := by
  rw [mean_product_kernel]
  exact mean_mono hw hconditional

theorem clipped_excess (D d : ℝ) : max (d - D) 0 = max D d - D := by
  by_cases h : d ≤ D
  · rw [max_eq_left h, max_eq_right (by linarith : d - D ≤ 0)]
    ring
  · rw [max_eq_right (le_of_not_ge h), max_eq_left (by linarith : 0 ≤ d - D)]

theorem root_excess_from_node_regrets {Ω Node : Type*} [Fintype Ω] [Fintype Node]
    (S : ℕ) (hS : 0 < S) (D terminal rounding : ℝ)
    (root : Ω → ℕ → ℝ) (regret : Ω → Node → ℕ → ℝ)
    (weight : Ω → ℝ) (nodeBudget : Node → ℝ)
    (hw : ∀ ω, 0 ≤ weight ω) (hnorm : ∑ ω, weight ω = 1)
    (hmono : ∀ ω, Antitone (root ω))
    (htelescope : ∀ ω t, t < S →
      max D (root ω (t + 1)) = terminal + rounding + ∑ v, regret ω v t)
    (hnode : ∀ v, mean weight (fun ω => ∑ t ∈ Finset.range S, regret ω v t) ≤
      nodeBudget v) :
    mean weight (fun ω => max (root ω S - D) 0) ≤
      terminal - D + rounding + (∑ v, nodeBudget v) / (S : ℝ) := by
  classical
  have hpoint : ∀ ω,
      (S : ℝ) * max D (root ω S) ≤ (S : ℝ) * (terminal + rounding) +
        ∑ v, ∑ t ∈ Finset.range S, regret ω v t := by
    intro ω
    calc
      (S : ℝ) * max D (root ω S) =
          ∑ t ∈ Finset.range S, max D (root ω S) := by simp
      _ ≤ ∑ t ∈ Finset.range S, max D (root ω (t + 1)) := by
        apply Finset.sum_le_sum
        intro t ht
        exact max_le_max_left D (hmono ω (by
          have := Finset.mem_range.mp ht
          omega))
      _ = ∑ t ∈ Finset.range S,
          (terminal + rounding + ∑ v, regret ω v t) := by
        apply Finset.sum_congr rfl
        intro t ht
        exact htelescope ω t (Finset.mem_range.mp ht)
      _ = (S : ℝ) * (terminal + rounding) +
          ∑ v, ∑ t ∈ Finset.range S, regret ω v t := by
        rw [Finset.sum_add_distrib]
        simp only [Finset.sum_const, Finset.card_range, nsmul_eq_mul]
        rw [Finset.sum_comm]
  have hs := mean_mono hw hpoint
  rw [mean_scale, mean_add, mean_const weight hnorm, mean_sum] at hs
  have hb := Finset.sum_le_sum (s := Finset.univ) (fun v _ => hnode v)
  have hpos : 0 < (S : ℝ) := by exact_mod_cast hS
  have hfinal : mean weight (fun ω => max D (root ω S)) ≤
      terminal + rounding + (∑ v, nodeBudget v) / (S : ℝ) := by
    have hm : mean weight (fun ω => max D (root ω S)) * (S : ℝ) ≤
        (S : ℝ) * (terminal + rounding) + ∑ v, nodeBudget v := by
      nlinarith
    calc
      mean weight (fun ω => max D (root ω S)) ≤
          ((S : ℝ) * (terminal + rounding) + ∑ v, nodeBudget v) / (S : ℝ) :=
        (le_div_iff₀ hpos).2 hm
      _ = terminal + rounding + (∑ v, nodeBudget v) / (S : ℝ) := by
        field_simp [ne_of_gt hpos]
  have hexcess :
      mean weight (fun ω => max (root ω S - D) 0) =
        mean weight (fun ω => max D (root ω S)) - D := by
    simp_rw [clipped_excess, sub_eq_add_neg]
    rw [mean_add, mean_const weight hnorm]
  rw [hexcess]
  linarith

theorem robust_accuracy {value D ell tax : ℝ}
    (hbaseline : value ≤ (5 / 8) * (D / ell) + tax)
    (htax : tax ≤ (3 / 8) * (D / ell)) :
    value ≤ D / ell := by
  linarith

theorem root_accuracy_from_defect_budgets {Ω Node : Type*}
    [Fintype Ω] [Fintype Node]
    (S : ℕ) (hS : 0 < S) (D terminal rounding ell tax : ℝ)
    (root : Ω → ℕ → ℝ) (regret : Ω → Node → ℕ → ℝ)
    (weight : Ω → ℝ) (nodeBudget : Node → ℝ)
    (hw : ∀ ω, 0 ≤ weight ω) (hnorm : ∑ ω, weight ω = 1)
    (hmono : ∀ ω, Antitone (root ω))
    (htelescope : ∀ ω t, t < S →
      max D (root ω (t + 1)) = terminal + rounding + ∑ v, regret ω v t)
    (hnode : ∀ v, mean weight (fun ω => ∑ t ∈ Finset.range S, regret ω v t) ≤
      nodeBudget v)
    (haggregate : terminal - D + rounding + (∑ v, nodeBudget v) / (S : ℝ) ≤
      (5 / 8) * (D / ell) + tax)
    (htax : tax ≤ (3 / 8) * (D / ell)) :
    mean weight (fun ω => max (root ω S - D) 0) ≤ D / ell := by
  have hr := root_excess_from_node_regrets S hS D terminal rounding root regret
    weight nodeBudget hw hnorm hmono htelescope hnode
  exact robust_accuracy (hr.trans haggregate) htax

theorem exact_defect_example :
    ((oracleDefect 1 (1 / 10) (1 / 4) (11 / 10) 1 +
      oracleDefect 1 (1 / 10) (1 / 4) (57 / 50) 1) / 2 : ℝ) = 3 / 400 := by
  norm_num [oracleDefect]

end RefinementAudit

#print axioms RefinementAudit.firstCrossing_defect_sum
#print axioms RefinementAudit.expected_firstCrossing_defect
#print axioms RefinementAudit.oracleDefect_minimal
#print axioms RefinementAudit.root_excess_from_node_regrets
#print axioms RefinementAudit.robust_accuracy
#print axioms RefinementAudit.mean_product_kernel
#print axioms RefinementAudit.root_accuracy_from_defect_budgets
