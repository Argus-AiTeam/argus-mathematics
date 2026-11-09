import Mathlib

open Filter Finset Topology

namespace SupportSeparation

noncomputable section

def ConvexSeq (F : ℕ → ℝ) : Prop :=
  ∀ n, 2 * F (n + 1) ≤ F n + F (n + 2)

def slope (F : ℕ → ℝ) (n : ℕ) : ℝ :=
  F (n + 1) - F n

def Minorant (S : Set ℕ) (f F : ℕ → ℝ) : Prop :=
  F 0 = 0 ∧ ConvexSeq F ∧ ∀ n ∈ S, F n ≤ f n

def GreatestMinorant (S : Set ℕ) (f F : ℕ → ℝ) : Prop :=
  Minorant S f F ∧ ∀ G, Minorant S f G → ∀ n, G n ≤ F n

theorem slopes_monotone {F : ℕ → ℝ} (hF : ConvexSeq F) :
    Monotone (slope F) := by
  apply monotone_nat_of_le_succ
  intro n
  have h := hF n
  dsimp [slope]
  convert (by linarith : F (n + 1) - F n ≤ F (n + 2) - F (n + 1)) using 1

theorem convex_max {F G : ℕ → ℝ} (hF : ConvexSeq F) (hG : ConvexSeq G) :
    ConvexSeq (fun n => max (F n) (G n)) := by
  intro n
  change 2 * max (F (n + 1)) (G (n + 1)) ≤
    max (F n) (G n) + max (F (n + 2)) (G (n + 2))
  rcases le_total (F (n + 1)) (G (n + 1)) with h | h
  · rw [max_eq_right h]
    have h₁ := le_max_right (F n) (G n)
    have h₂ := le_max_right (F (n + 2)) (G (n + 2))
    have h₃ := hG n
    linarith
  · rw [max_eq_left h]
    have h₁ := le_max_left (F n) (G n)
    have h₂ := le_max_left (F (n + 2)) (G (n + 2))
    have h₃ := hF n
    linarith

theorem convex_nonnegative_monotone {F : ℕ → ℝ} (hF : ConvexSeq F)
    (h₀ : F 0 = 0) (hpos : ∀ n, 0 ≤ F n) : Monotone F := by
  apply monotone_nat_of_le_succ
  intro n
  have h := slopes_monotone hF (Nat.zero_le n)
  have h₁ := hpos 1
  dsimp [slope] at h
  simp only [h₀] at h
  linarith

theorem minorant_bound {S : Set ℕ} {f F : ℕ → ℝ}
    (hf : ∀ n ∈ S, 0 ≤ f n) (hF : Minorant S f F)
    {n k : ℕ} (hnk : n ≤ k) (hk : k ∈ S) : F n ≤ f k := by
  let H : ℕ → ℝ := fun i => max (F i) 0
  have hH : ConvexSeq H :=
    convex_max hF.2.1 (by intro i; norm_num)
  have hm : Monotone H :=
    convex_nonnegative_monotone hH (by simp [H, hF.1])
      (fun i => le_max_right _ _)
  calc
    F n ≤ H n := le_max_left _ _
    _ ≤ H k := hm hnk
    _ ≤ f k := max_le (hF.2.2 k hk) (hf k hk)

theorem greatest_minorant_exists {S : Set ℕ} {f G : ℕ → ℝ}
    (hf : ∀ n ∈ S, 0 ≤ f n)
    (hcofinal : ∀ n, ∃ k, n ≤ k ∧ k ∈ S)
    (hG : Minorant S f G) :
    ∃ F, GreatestMinorant S f F ∧ ∀ n, G n ≤ F n := by
  classical
  let I := {H : ℕ → ℝ // Minorant S f H}
  haveI : Nonempty I := ⟨⟨G, hG⟩⟩
  let F : ℕ → ℝ := fun n => ⨆ H : I, H.1 n
  have hb (n : ℕ) : BddAbove (Set.range (fun H : I => H.1 n)) := by
    obtain ⟨k, hnk, hk⟩ := hcofinal n
    refine ⟨f k, ?_⟩
    rintro _ ⟨H, rfl⟩
    exact minorant_bound hf H.2 hnk hk
  have hle (H : I) (n : ℕ) : H.1 n ≤ F n := le_ciSup (hb n) H
  have h₀ : F 0 = 0 := by
    apply le_antisymm
    · exact ciSup_le (fun H => le_of_eq H.2.1)
    · have h := hle ⟨G, hG⟩ 0
      simpa only [hG.1] using h
  have hconv : ConvexSeq F := by
    intro n
    have hmid : F (n + 1) ≤ (F n + F (n + 2)) / 2 := by
      apply ciSup_le
      intro H
      have h₁ := hle H n
      have h₂ := hle H (n + 2)
      have h₃ := H.2.2.1 n
      linarith
    linarith
  have hbelow : ∀ n ∈ S, F n ≤ f n := by
    intro n hn
    exact ciSup_le (fun H => H.2.2.2 n hn)
  refine ⟨F, ⟨⟨h₀, hconv, hbelow⟩, ?_⟩, hle ⟨G, hG⟩⟩
  intro H hH n
  exact hle ⟨H, hH⟩ n

def bump (F : ℕ → ℝ) (p : ℕ) (ε : ℝ) (n : ℕ) : ℝ :=
  F n + if n = p then ε else 0

theorem bump_ge (F : ℕ → ℝ) (p n : ℕ) {ε : ℝ} (hε : 0 ≤ ε) :
    F n ≤ bump F p ε n := by
  unfold bump
  split_ifs <;> linarith

theorem convex_bump {F : ℕ → ℝ} (hF : ConvexSeq F) (m : ℕ)
    {ε : ℝ} (hε : 0 ≤ ε)
    (hgap : 2 * ε ≤ F m + F (m + 2) - 2 * F (m + 1)) :
    ConvexSeq (bump F (m + 1) ε) := by
  intro n
  by_cases hn : n = m
  · subst n
    simp [bump]
    linarith
  · have hmid : n + 1 ≠ m + 1 := by omega
    have h₁ := bump_ge F (m + 1) n hε
    have h₂ := bump_ge F (m + 1) (n + 2) hε
    have h₃ := hF n
    have hm : bump F (m + 1) ε (n + 1) = F (n + 1) := by
      simp [bump, hn]
    rw [hm]
    linarith

theorem envelope_contact {S : Set ℕ} {f F : ℕ → ℝ}
    (hF : GreatestMinorant S f F) (m : ℕ)
    (hcurv : 0 < F m + F (m + 2) - 2 * F (m + 1)) :
    m + 1 ∈ S ∧ F (m + 1) = f (m + 1) := by
  classical
  by_contra hc
  have hroom : ∃ ε : ℝ, 0 < ε ∧
      2 * ε ≤ F m + F (m + 2) - 2 * F (m + 1) ∧
      (m + 1 ∈ S → F (m + 1) + ε ≤ f (m + 1)) := by
    by_cases hs : m + 1 ∈ S
    · have hne : F (m + 1) ≠ f (m + 1) := by
        intro he
        exact hc ⟨hs, he⟩
      have hlt : F (m + 1) < f (m + 1) :=
        lt_of_le_of_ne (hF.1.2.2 _ hs) hne
      let ε := min ((F m + F (m + 2) - 2 * F (m + 1)) / 4)
        ((f (m + 1) - F (m + 1)) / 2)
      have hepos : 0 < ε := lt_min (by linarith) (by linarith)
      have he₁ := min_le_left ((F m + F (m + 2) - 2 * F (m + 1)) / 4)
        ((f (m + 1) - F (m + 1)) / 2)
      have he₂ := min_le_right ((F m + F (m + 2) - 2 * F (m + 1)) / 4)
        ((f (m + 1) - F (m + 1)) / 2)
      refine ⟨ε, hepos, ?_, ?_⟩
      · dsimp [ε]
        linarith
      · intro _
        dsimp [ε]
        linarith
    · refine ⟨(F m + F (m + 2) - 2 * F (m + 1)) / 4,
        by linarith, by linarith, ?_⟩
      exact fun h => (hs h).elim
  obtain ⟨ε, hε, hgap, hobs⟩ := hroom
  have hminor : Minorant S f (bump F (m + 1) ε) := by
    refine ⟨?_, convex_bump hF.1.2.1 m (le_of_lt hε) hgap, ?_⟩
    · simp [bump, hF.1.1]
    · intro n hn
      by_cases hp : n = m + 1
      · subst n
        simpa [bump] using hobs hn
      · simpa [bump, hp] using hF.1.2.2 n hn
  have hmax := hF.2 _ hminor (m + 1)
  simp [bump] at hmax
  linarith

theorem slope_match (γ : ℕ → ℝ) (t : ℝ) (h₀ : γ 0 ≤ t)
    (hcofinal : ∀ x : ℝ, ∃ n, x < γ n) :
    ∃ p, γ p ≤ t ∧ t < γ (p + 1) := by
  classical
  have hex : ∃ n, t < γ n := hcofinal t
  let N := Nat.find hex
  have hN : t < γ N := Nat.find_spec hex
  have hpos : 0 < N := by
    by_contra h
    have hz : N = 0 := by omega
    rw [hz] at hN
    linarith
  refine ⟨N - 1, ?_, ?_⟩
  · by_contra h
    have hlt : t < γ (N - 1) := lt_of_not_ge h
    have hmin : N ≤ N - 1 := Nat.find_min' hex hlt
    omega
  · convert hN using 1
    congr 1
    omega

theorem slopes_cofinal (F : ℕ → ℝ) (h₀ : F 0 = 0)
    (hsuper : ∀ L : ℝ, ∃ n : ℕ, (n : ℝ) * L < F n) :
    ∀ L : ℝ, ∃ n, L < slope F n := by
  intro L
  by_contra h
  have hs : ∀ n, slope F n ≤ L := by
    intro n
    by_contra hn
    exact h ⟨n, lt_of_not_ge hn⟩
  have hb : ∀ n, F n ≤ (n : ℝ) * L := by
    intro n
    induction n with
    | zero => simp [h₀]
    | succ n ih =>
        have hstep := hs n
        dsimp [slope] at hstep
        push_cast
        linarith
  obtain ⟨n, hn⟩ := hsuper L
  linarith [hb n]

theorem slope_match_above (γ : ℕ → ℝ) (hmono : Monotone γ)
    (hcofinal : ∀ x : ℝ, ∃ n, x < γ n) (K : ℕ) (t : ℝ)
    (ht : γ K ≤ t) :
    ∃ p, K ≤ p ∧ γ p ≤ t ∧ t < γ (p + 1) := by
  obtain ⟨p, hlo, hhi⟩ := slope_match γ t ((hmono (Nat.zero_le K)).trans ht) hcofinal
  refine ⟨p, ?_, hlo, hhi⟩
  by_contra hp
  have hpk : p + 1 ≤ K := by omega
  have h := hmono hpk
  linarith

theorem matched_gaps {a a' g g' ell : ℝ}
    (hcurv : 2 * ell < a' - a)
    (hlo : g ≤ a + ell) (hhi : a + ell < g') :
    ell < g' - a ∧ ell < a' - g ∧ g < g' := by
  constructor
  · linarith
  constructor <;> linarith

theorem finite_descent (F : ℕ → ℝ) (ell : ℝ) (N : ℕ)
    (hstep : ∀ n < N, F (n + 1) - F n ≤ -ell) :
    ∀ n ≤ N, F n ≤ F 0 - (n : ℝ) * ell := by
  intro n hn
  induction n with
  | zero => simp
  | succ n ih =>
      have hprev := ih (by omega)
      have hs := hstep n (by omega)
      push_cast
      linarith

theorem finite_descent_exp (F : ℕ → ℝ) (ell : ℝ) (N : ℕ)
    (hstep : ∀ n < N, F (n + 1) - F n ≤ -ell) (n : ℕ) (hn : n ≤ N) :
    Real.exp (F n) ≤ Real.exp (F 0) * Real.exp (-(n : ℝ) * ell) := by
  have h := Real.exp_le_exp.mpr (finite_descent F ell N hstep n hn)
  simpa only [sub_eq_add_neg, neg_mul, Real.exp_add] using h

theorem quadratic_upper_of_curvature (F : ℕ → ℝ) (ell : ℝ)
    (hcurv : ∀ n, F n + F (n + 2) - 2 * F (n + 1) ≤ 2 * ell) :
    ∀ n, F n ≤ ell * (n : ℝ) ^ 2 +
      (slope F 0 - ell) * (n : ℝ) + F 0 := by
  have hs : ∀ n, slope F n ≤ slope F 0 + 2 * ell * (n : ℝ) := by
    intro n
    induction n with
    | zero => simp
    | succ n ih =>
        have h := hcurv n
        dsimp [slope] at *
        push_cast
        convert (by linarith :
          F (n + 2) - F (n + 1) ≤ F 1 - F 0 + 2 * ell * ((n : ℝ) + 1))
          using 1
  intro n
  induction n with
  | zero => simp
  | succ n ih =>
      have h := hs n
      dsimp [slope] at h ih ⊢
      push_cast
      nlinarith

theorem curvature_or_quadratic_bound (F : ℕ → ℝ) (ell : ℝ) (N : ℕ) :
    (∃ n, N ≤ n ∧ 2 * ell < F n + F (n + 2) - 2 * F (n + 1)) ∨
      ∀ k, F (N + k) ≤ ell * (k : ℝ) ^ 2 +
        (slope F N - ell) * (k : ℝ) + F N := by
  by_cases h : ∃ n, N ≤ n ∧ 2 * ell < F n + F (n + 2) - 2 * F (n + 1)
  · exact Or.inl h
  · right
    have hc : ∀ k, F (N + k) + F (N + k + 2) - 2 * F (N + k + 1) ≤
        2 * ell := by
      intro k
      by_contra hk
      exact h ⟨N + k, by omega, lt_of_not_ge hk⟩
    have hb := quadratic_upper_of_curvature (fun k => F (N + k)) ell
      (by simpa only [Nat.add_assoc] using hc)
    simpa [slope, Nat.add_assoc] using hb

def middle (A B : ℕ → ℝ) (p m n : ℕ) : ℝ :=
  -B (p + n) - A (m - n)

theorem middle_step {A B : ℕ → ℝ} (hA : ConvexSeq A) (hB : ConvexSeq B)
    (p m n : ℕ) (hn : n < m) (ell : ℝ)
    (hgap : slope A (m - 1) - slope B p ≤ -ell) :
    middle A B p m (n + 1) - middle A B p m n ≤ -ell := by
  have ha := slopes_monotone hA (show m - (n + 1) ≤ m - 1 by omega)
  have hb := slopes_monotone hB (show p ≤ p + n by omega)
  dsimp [slope] at ha hb hgap
  rw [show m - (n + 1) + 1 = m - n by omega,
    show m - 1 + 1 = m by omega] at ha
  rw [show m - 1 + 1 = m by omega] at hgap
  dsimp [middle]
  rw [show p + (n + 1) = p + n + 1 by omega]
  linarith

theorem middle_bound {A B : ℕ → ℝ} (hA : ConvexSeq A) (hB : ConvexSeq B)
    (p m n : ℕ) (hn : n ≤ m) (ell : ℝ)
    (hgap : slope A (m - 1) - slope B p ≤ -ell) :
    Real.exp (-B (p + n) - A (m - n)) ≤
      Real.exp (-B p - A m) * Real.exp (-(n : ℝ) * ell) := by
  have hsteps := fun k hk => middle_step hA hB p m k hk ell hgap
  simpa only [middle, Nat.add_zero, Nat.sub_zero] using
    finite_descent_exp (middle A B p m) ell m hsteps n hn

theorem matched_contacts {S T : Set ℕ} {f g A B : ℕ → ℝ}
    (hA : GreatestMinorant S f A) (hB : GreatestMinorant T g B)
    (m p : ℕ) (hm : 1 ≤ m) (hp : 1 ≤ p) (ell : ℝ) (hell : 0 < ell)
    (hcurv : 2 * ell < slope A m - slope A (m - 1))
    (hlo : slope B (p - 1) ≤ slope A (m - 1) + ell)
    (hhi : slope A (m - 1) + ell < slope B p) :
    (m ∈ S ∧ A m = f m) ∧ (p ∈ T ∧ B p = g p) := by
  have hm₁ : m - 1 + 1 = m := by omega
  have hm₂ : m - 1 + 2 = m + 1 := by omega
  have hp₁ : p - 1 + 1 = p := by omega
  have hp₂ : p - 1 + 2 = p + 1 := by omega
  have hma : 0 < A (m - 1) + A (m - 1 + 2) - 2 * A (m - 1 + 1) := by
    dsimp [slope] at hcurv
    rw [hm₁] at hcurv
    rw [hm₁, hm₂]
    linarith
  have hpb : 0 < B (p - 1) + B (p - 1 + 2) - 2 * B (p - 1 + 1) := by
    dsimp [slope] at hlo hhi
    rw [hp₁] at hlo
    rw [hp₁, hp₂]
    linarith
  constructor
  · simpa only [hm₁] using envelope_contact hA (m - 1) hma
  · simpa only [hp₁] using envelope_contact hB (p - 1) hpb

theorem matched_middle_bounds {A B : ℕ → ℝ}
    (hA : ConvexSeq A) (hB : ConvexSeq B) (m p : ℕ) (ell : ℝ)
    (hcurv : 2 * ell < slope A m - slope A (m - 1))
    (hlo : slope B (p - 1) ≤ slope A (m - 1) + ell)
    (hhi : slope A (m - 1) + ell < slope B p) :
    (∀ n ≤ m, Real.exp (-B (p + n) - A (m - n)) ≤
      Real.exp (-B p - A m) * Real.exp (-(n : ℝ) * ell)) ∧
    (∀ n ≤ p, Real.exp (-A (m + n) - B (p - n)) ≤
      Real.exp (-A m - B p) * Real.exp (-(n : ℝ) * ell)) := by
  constructor
  · intro n hn
    exact middle_bound hA hB p m n hn ell (by linarith)
  · intro n hn
    exact middle_bound hB hA m p n hn ell (by linarith)

def ratio (v : ℕ → ℝ) (n : ℕ) : ℝ :=
  v (n + 1) / v n

def kernel (v : ℕ → ℝ) (q k : ℕ) : ℝ :=
  v (q + k) / (v q * v k)

theorem kernel_pos {v : ℕ → ℝ} (hv : ∀ n, 0 < v n) (q k : ℕ) :
    0 < kernel v q k := div_pos (hv _) (mul_pos (hv _) (hv _))

theorem kernel_comm (v : ℕ → ℝ) (q k : ℕ) :
    kernel v q k = kernel v k q := by
  simp [kernel, Nat.add_comm, mul_comm]

theorem kernel_step_le {v : ℕ → ℝ} (hv : ∀ n, 0 < v n)
    (hr : Antitone (ratio v)) (q k : ℕ) :
    kernel v (q + 1) k ≤ kernel v q k := by
  have hr' := hr (show q ≤ q + k by omega)
  dsimp [ratio] at hr'
  have hc := (div_le_div_iff₀ (hv (q + k)) (hv q)).mp hr'
  unfold kernel
  apply (div_le_div_iff₀ (mul_pos (hv _) (hv _))
    (mul_pos (hv _) (hv _))).mpr
  rw [show q + 1 + k = q + k + 1 by omega]
  calc
    v (q + k + 1) * (v q * v k) =
        (v (q + k + 1) * v q) * v k := by ring
    _ ≤ (v (q + 1) * v (q + k)) * v k :=
      mul_le_mul_of_nonneg_right hc (le_of_lt (hv k))
    _ = v (q + k) * (v (q + 1) * v k) := by ring

theorem kernel_antitone {v : ℕ → ℝ} (hv : ∀ n, 0 < v n)
    (hr : Antitone (ratio v)) (k : ℕ) :
    Antitone (fun q => kernel v q k) :=
  antitone_nat_of_succ_le (fun q => kernel_step_le hv hr q k)

theorem kernel_le_ratio_right {v : ℕ → ℝ} (hv : ∀ n, 0 < v n)
    (hr : Antitone (ratio v)) (q k : ℕ) (hq : 1 ≤ q) :
    kernel v q k ≤ ratio v k / v 1 := by
  have h := kernel_antitone hv hr k hq
  simpa [kernel, ratio, div_div, Nat.add_comm, mul_comm] using h

theorem kernel_le_ratio_left {v : ℕ → ℝ} (hv : ∀ n, 0 < v n)
    (hr : Antitone (ratio v)) (q k : ℕ) (hk : 1 ≤ k) :
    kernel v q k ≤ ratio v q / v 1 := by
  rw [kernel_comm]
  exact kernel_le_ratio_right hv hr k q hk

theorem normalized_tail_summable {v : ℕ → ℝ} (hv : ∀ n, 0 < v n)
    (hr : Antitone (ratio v)) (hs : Summable (ratio v))
    (q : ℕ) (hq : 1 ≤ q) :
    Summable (fun k => kernel v q (k + 1)) := by
  have hb : Summable (fun k => ratio v (k + 1) / v 1) :=
    ((summable_nat_add_iff 1).mpr hs).div_const _
  apply hb.of_norm_bounded
  intro k
  rw [Real.norm_eq_abs, abs_of_pos (kernel_pos hv _ _)]
  exact kernel_le_ratio_right hv hr q (k + 1) hq

theorem normalized_tail_tendsto_zero {v : ℕ → ℝ} (hv : ∀ n, 0 < v n)
    (hr : Antitone (ratio v)) (hs : Summable (ratio v)) :
    Tendsto (fun q => ∑' k, kernel v q (k + 1)) atTop (𝓝 0) := by
  have hb : Summable (fun k => ratio v (k + 1) / v 1) :=
    ((summable_nat_add_iff 1).mpr hs).div_const _
  have hzero : Tendsto (fun q => ratio v q / v 1) atTop (𝓝 0) := by
    simpa using hs.tendsto_atTop_zero.div_const (v 1)
  have hpoint (k : ℕ) :
      Tendsto (fun q => kernel v q (k + 1)) atTop (𝓝 (0 : ℝ)) := by
    exact squeeze_zero (fun q => le_of_lt (kernel_pos hv _ _))
      (fun q => kernel_le_ratio_left hv hr q (k + 1) (by omega)) hzero
  have hbound : ∀ᶠ q : ℕ in atTop,
      ∀ k, ‖kernel v q (k + 1)‖ ≤ ratio v (k + 1) / v 1 := by
    filter_upwards [eventually_ge_atTop 1] with q hq k
    rw [Real.norm_eq_abs, abs_of_pos (kernel_pos hv _ _)]
    exact kernel_le_ratio_right hv hr q (k + 1) hq
  simpa using tendsto_tsum_of_dominated_convergence hb hpoint hbound

theorem both_normalized_tails {v z : ℕ → ℝ}
    (hv : ∀ n, 0 < v n) (hz : ∀ n, 0 < z n)
    (hrv : Antitone (ratio v)) (hrz : Antitone (ratio z))
    (hsv : Summable (ratio v)) (hsz : Summable (ratio z)) :
    Tendsto (fun q => (∑' k, kernel v q (k + 1)) +
      (∑' k, kernel z q (k + 1))) atTop (𝓝 0) := by
  simpa using (normalized_tail_tendsto_zero hv hrv hsv).add
    (normalized_tail_tendsto_zero hz hrz hsz)

theorem central_margin (z x y t : ℂ) (M C εL εR : ℝ)
    (hz : ‖z‖ = M) (hx : ‖x‖ ≤ M * C)
    (hy : ‖y‖ ≤ M * εL) (ht : ‖t‖ ≤ M * εR) :
    M * (1 - C - εL - εR) ≤ ‖z + x + y + t‖ := by
  have hrev : ‖z‖ ≤ ‖z + x + y + t‖ + ‖x‖ + ‖y‖ + ‖t‖ := by
    calc
      ‖z‖ = ‖(z + x + y + t) + (-x) + (-y) + (-t)‖ := by
        congr 1
        ring
      _ ≤ ‖(z + x + y + t) + (-x) + (-y)‖ + ‖-t‖ := norm_add_le _ _
      _ ≤ (‖(z + x + y + t) + (-x)‖ + ‖-y‖) + ‖-t‖ :=
        by
          gcongr
          exact norm_add_le _ _
      _ ≤ ((‖z + x + y + t‖ + ‖-x‖) + ‖-y‖) + ‖-t‖ := by
        gcongr
        exact norm_add_le _ _
      _ = ‖z + x + y + t‖ + ‖x‖ + ‖y‖ + ‖t‖ := by simp
  nlinarith

theorem eventual_relative_margin {v w : ℕ → ℝ}
    (hv : ∀ n, 0 < v n) (hw : ∀ n, 0 < w n)
    (hrv : Antitone (ratio v)) (hrw : Antitone (ratio w))
    (hsv : Summable (ratio v)) (hsw : Summable (ratio w))
    (Q : ℕ → ℕ) (hQ : Tendsto Q atTop atTop)
    (z x y t : ℕ → ℂ) (M : ℕ → ℝ) (C : ℝ)
    (hM : ∀ q, 0 < M q) (hz : ∀ q, ‖z q‖ = M q)
    (hx : ∀ q, ‖x q‖ ≤ M q * C)
    (hy : ∀ q, ‖y q‖ ≤ M q * (∑' k, kernel v (Q q) (k + 1)))
    (ht : ∀ q, ‖t q‖ ≤ M q * (∑' k, kernel w (Q q) (k + 1)))
    (ε : ℝ) (hε : 0 < ε) :
    ∀ᶠ q : ℕ in atTop,
      M q * (1 - C - ε) ≤ ‖z q + x q + y q + t q‖ := by
  have hsmall : ∀ᶠ q : ℕ in atTop,
      (∑' k, kernel v (Q q) (k + 1)) +
        (∑' k, kernel w (Q q) (k + 1)) < ε :=
    ((both_normalized_tails hv hw hrv hrw hsv hsw).comp hQ).eventually
      (Iio_mem_nhds hε)
  filter_upwards [hsmall] with q hq
  have hmargin := central_margin (z q) (x q) (y q) (t q) (M q) C
    (∑' k, kernel v (Q q) (k + 1)) (∑' k, kernel w (Q q) (k + 1))
    (hz q) (hx q) (hy q) (ht q)
  have hm := mul_le_mul_of_nonneg_left (le_of_lt hq) (le_of_lt (hM q))
  nlinarith

theorem eventual_nonzero {v w : ℕ → ℝ}
    (hv : ∀ n, 0 < v n) (hw : ∀ n, 0 < w n)
    (hrv : Antitone (ratio v)) (hrw : Antitone (ratio w))
    (hsv : Summable (ratio v)) (hsw : Summable (ratio w))
    (Q : ℕ → ℕ) (hQ : Tendsto Q atTop atTop)
    (z x y t : ℕ → ℂ) (M : ℕ → ℝ) (C : ℝ)
    (hM : ∀ q, 0 < M q) (hC : C < 1)
    (hz : ∀ q, ‖z q‖ = M q) (hx : ∀ q, ‖x q‖ ≤ M q * C)
    (hy : ∀ q, ‖y q‖ ≤ M q * (∑' k, kernel v (Q q) (k + 1)))
    (ht : ∀ q, ‖t q‖ ≤ M q * (∑' k, kernel w (Q q) (k + 1))) :
    ∀ᶠ q : ℕ in atTop, z q + x q + y q + t q ≠ 0 := by
  have he : 0 < (1 - C) / 2 := by linarith
  filter_upwards [eventual_relative_margin hv hw hrv hrw hsv hsw Q hQ z x y t M C
    hM hz hx hy ht ((1 - C) / 2) he] with q hq
  intro hzsum
  rw [hzsum, norm_zero] at hq
  have hp := mul_pos (hM q) (show 0 < 1 - C - (1 - C) / 2 by linarith)
  linarith

theorem endpoint_strict_of_zero_pairing (b c : ℤ → ℂ) (t h : ℤ)
    (hb : b t ≠ 0) (hc : c h ≠ 0)
    (hmax : ∀ j, t < j → b j = 0)
    (hmin : ∀ j, j < h → c j = 0)
    (horder : t ≤ h) (hzero : (∑' j, b j * c j) = 0) :
    t < h := by
  by_contra hn
  have heq : t = h := by omega
  subst h
  have hsingle : (∑' j, b j * c j) = b t * c t := by
    apply tsum_eq_single t
    intro j hj
    rcases lt_or_gt_of_ne hj with hlt | hgt
    · rw [hmin j hlt, mul_zero]
    · rw [hmax j hgt, zero_mul]
  have hnonzero := mul_ne_zero hb hc
  exact hnonzero (hsingle.symm.trans hzero)

theorem margin_identity {x : ℝ} (hx : 3 < x) :
    0 < 1 - 2 / (x - 1) ∧
    1 - 2 / (x - 1) = (x - 3) / (x - 1) := by
  have hd : 0 < x - 1 := by linarith
  have he : 1 - 2 / (x - 1) = (x - 3) / (x - 1) := by
    field_simp
    ring
  exact ⟨he ▸ div_pos (by linarith) hd, he⟩

end

end SupportSeparation
