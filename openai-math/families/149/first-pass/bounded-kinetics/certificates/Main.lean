import Mathlib

namespace Campaign149.BoundedKinetics

open Finset Set

theorem uniform_cut_margin
    {E : Type*} [Fintype E] [DecidableEq E]
    (down : Finset E) (k upper weight : E → ℝ)
    (eta w lo up : ℝ)
    (heta : 0 ≤ eta) (hw : 0 ≤ w)
    (hk : ∀ e, 0 ≤ k e) (hku : ∀ e, k e ≤ upper e)
    (hu : ∀ e, 0 ≤ upper e)
    (hweight : ∀ e ∈ down, weight e ≤ eta * w)
    (hup : lo * w ≤ up) :
    (lo - eta * ∑ e, upper e) * w ≤
      up - ∑ e ∈ down, k e * weight e := by
  have hs : (∑ e ∈ down, upper e) ≤ ∑ e, upper e :=
    Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ down)
      (by intro e _ _; exact hu e)
  have hd : (∑ e ∈ down, k e * weight e) ≤
      (eta * w) * ∑ e, upper e := by
    calc
      (∑ e ∈ down, k e * weight e) ≤
          ∑ e ∈ down, (eta * w) * upper e := by
        apply Finset.sum_le_sum
        intro e he
        calc
          k e * weight e ≤ k e * (eta * w) :=
            mul_le_mul_of_nonneg_left (hweight e he) (hk e)
          _ ≤ upper e * (eta * w) :=
            mul_le_mul_of_nonneg_right (hku e) (mul_nonneg heta hw)
          _ = (eta * w) * upper e := mul_comm _ _
      _ = (eta * w) * ∑ e ∈ down, upper e := by rw [Finset.mul_sum]
      _ ≤ (eta * w) * ∑ e, upper e :=
        mul_le_mul_of_nonneg_left hs (mul_nonneg heta hw)
  nlinarith

theorem strict_cut_margin
    (lo eta total w up down : ℝ)
    (hrho : 0 < lo - eta * total) (hw : 0 < w)
    (hup : lo * w ≤ up) (hdown : down ≤ eta * w * total) :
    0 < (lo - eta * total) * w ∧
      (lo - eta * total) * w ≤ up - down := by
  constructor
  · exact mul_pos hrho hw
  · nlinarith

theorem positive_gap_sum
    {J : Type*} [DecidableEq J] (cuts : Finset J)
    (gap flux : J → ℝ) (H rho v : ℝ)
    (hH : 0 < H) (hrho : 0 < rho) (hv : 0 < v)
    (hgap : ∀ j ∈ cuts, 0 ≤ gap j)
    (hflux : ∀ j ∈ cuts, 0 ≤ flux j)
    (hwitness : ∃ j ∈ cuts, 2 * H ≤ gap j ∧ rho * v ≤ flux j) :
    0 < 2 * H * rho * v ∧
      2 * H * rho * v ≤ ∑ j ∈ cuts, gap j * flux j := by
  constructor
  · positivity
  · obtain ⟨j, hj, hjgap, hjflux⟩ := hwitness
    calc
      2 * H * rho * v = (2 * H) * (rho * v) := by ring
      _ ≤ gap j * flux j :=
        mul_le_mul hjgap hjflux (le_of_lt (mul_pos hrho hv)) (hgap j hj)
      _ ≤ ∑ j ∈ cuts, gap j * flux j :=
        Finset.single_le_sum
          (fun i hi => mul_nonneg (hgap i hi) (hflux i hi)) hj

theorem ceiling_invariance
    (g : ℝ → ℝ) (M s : ℝ)
    (hcap : ∀ t, s ≤ t → g t ≤ M)
    (hmono : MonotoneOn g (Ici s)) (hstart : g s = M) :
    ∀ t, s ≤ t → g t = M := by
  intro t ht
  have h := hmono (show s ∈ Ici s from le_rfl) ht ht
  exact le_antisymm (hcap t ht) (by simpa [hstart] using h)

theorem integrated_trapping
    (g : ℝ → ℝ) (M L delta s : ℝ)
    (hdelta : 0 < delta) (hLM : L ≤ M) (hstart : L ≤ g s)
    (hcap : ∀ t, s ≤ t → g t ≤ M)
    (hmono : MonotoneOn g (Ici s))
    (hgrowth : ∀ t, s ≤ t →
      (∀ u ∈ Icc s t, g u < M) →
      delta * (t - s) ≤ g t - g s) :
    ∀ t, s + (M - L + 1) / delta ≤ t → g t = M := by
  let w := s + (M - L + 1) / delta
  have hdelay : 0 ≤ (M - L + 1) / delta :=
    div_nonneg (by linarith) (le_of_lt hdelta)
  have hsw : s ≤ w := by dsimp [w]; linarith
  have hw : g w = M := by
    by_contra hn
    have hlt : g w < M := lt_of_le_of_ne (hcap w hsw) hn
    have hbelow : ∀ u ∈ Icc s w, g u < M := by
      intro u hu
      exact lt_of_le_of_lt (hmono hu.1 hsw hu.2) hlt
    have hg := hgrowth w hsw hbelow
    have hid : delta * (w - s) = M - L + 1 := by
      dsimp [w]
      field_simp
      <;> ring
    linarith
  intro t ht
  have hst : s ≤ t := le_trans hsw ht
  have hwt := hmono hsw hst ht
  exact le_antisymm (hcap t hst) (by simpa [hw] using hwt)

structure ScaleData (Omega : Type*) where
  value : ℕ → Omega → ℝ → ℝ
  box : ℕ → Omega → ℝ → Prop
  ceiling lower delta : ℕ → ℝ
  lower_le : ∀ i, lower i ≤ ceiling i
  delta_pos : ∀ i, 0 < delta i
  cap : ∀ i omega t, 0 ≤ t → value i omega t ≤ ceiling i
  lower_bound : ∀ i omega t, 0 ≤ t → box i omega t →
    lower i ≤ value i omega t
  monotone : ∀ i omega s, 0 ≤ s →
    (∀ t, s ≤ t → box i omega t) →
    MonotoneOn (value i omega) (Ici s)
  growth : ∀ i omega s t, 0 ≤ s → s ≤ t →
    (∀ u ∈ Icc s t, box i omega u) →
    (∀ u ∈ Icc s t, value i omega u < ceiling i) →
    delta i * (t - s) ≤ value i omega t - value i omega s
  refine : ∀ i omega t, 0 ≤ t →
    value i omega t = ceiling i → box (i + 1) omega t
  initial : ∀ omega t, 0 ≤ t → value 0 omega t = ceiling 0

namespace ScaleData

variable {Omega : Type*} (D : ScaleData Omega)

def delay (i : ℕ) : ℝ :=
  (D.ceiling i - D.lower i + 1) / D.delta i

def entryTime : ℕ → ℝ
  | 0 => 0
  | n + 1 => D.entryTime n + D.delay (n + 1)

theorem delay_nonneg (i : ℕ) : 0 ≤ D.delay i := by
  apply div_nonneg
  · have h := D.lower_le i
    linarith
  · exact le_of_lt (D.delta_pos i)

theorem entryTime_nonneg : ∀ n, 0 ≤ D.entryTime n := by
  intro n
  induction n with
  | zero => rfl
  | succ n ih =>
      exact add_nonneg ih (D.delay_nonneg (n + 1))

theorem uniform_absorption :
    ∀ n omega t, D.entryTime n ≤ t →
      D.value n omega t = D.ceiling n := by
  intro n
  induction n with
  | zero =>
      intro omega t ht
      exact D.initial omega t ht
  | succ n ih =>
      intro omega t ht
      let s := D.entryTime n
      have hs : 0 ≤ s := D.entryTime_nonneg n
      have hbox : ∀ u, s ≤ u → D.box (n + 1) omega u := by
        intro u hu
        exact D.refine n omega u (le_trans hs hu) (ih omega u hu)
      apply integrated_trapping
        (D.value (n + 1) omega) (D.ceiling (n + 1))
        (D.lower (n + 1)) (D.delta (n + 1)) s
        (D.delta_pos (n + 1)) (D.lower_le (n + 1))
        (D.lower_bound (n + 1) omega s hs (hbox s le_rfl))
        (fun u hu => D.cap (n + 1) omega u (le_trans hs hu))
        (D.monotone (n + 1) omega s hs hbox)
      · intro u hu hbelow
        exact D.growth (n + 1) omega s u hs hu
          (fun v hv => hbox v hv.1) hbelow
      · exact ht

end ScaleData

def logScale (q0 qP : ℝ) (n : ℕ) : ℝ :=
  max qP (q0 / (2 : ℝ) ^ n)

theorem logScale_zero (q0 qP : ℝ) (h : qP ≤ q0) :
    logScale q0 qP 0 = q0 := by
  simp [logScale, max_eq_right h]

theorem logScale_succ (q0 qP : ℝ) (hP : 0 ≤ qP) (n : ℕ) :
    logScale q0 qP (n + 1) = max qP (logScale q0 qP n / 2) := by
  have hid : q0 / (2 : ℝ) ^ (n + 1) = (q0 / (2 : ℝ) ^ n) / 2 := by
    rw [pow_succ, div_mul_eq_div_div]
  unfold logScale
  rw [hid]
  rcases le_total qP (q0 / (2 : ℝ) ^ n) with h | h
  · rw [max_eq_right h]
  · rw [max_eq_left h]
    have hhalf : q0 / (2 : ℝ) ^ n / 2 ≤ qP := by linarith
    have hp : qP / 2 ≤ qP := by linarith
    rw [max_eq_left hhalf, max_eq_left hp]

theorem real_nat_add_one_le_two_pow (n : ℕ) :
    (n : ℝ) + 1 ≤ (2 : ℝ) ^ n := by
  induction n with
  | zero => norm_num
  | succ n ih =>
      have hn : (0 : ℝ) ≤ n := Nat.cast_nonneg n
      simp only [Nat.cast_add, Nat.cast_one, pow_succ]
      nlinarith

theorem logScale_reaches_cap (q0 qP : ℝ) (hP : 0 < qP) :
    ∃ n : ℕ, logScale q0 qP n = qP := by
  obtain ⟨n, hn⟩ := exists_nat_gt (q0 / qP)
  have hpow := real_nat_add_one_le_two_pow n
  have hr : q0 / qP < (2 : ℝ) ^ n := by linarith
  have hprod : q0 < (2 : ℝ) ^ n * qP := (div_lt_iff₀ hP).mp hr
  have hbound : q0 / (2 : ℝ) ^ n ≤ qP := by
    apply (div_le_iff₀ (pow_pos (by norm_num : (0 : ℝ) < 2) n)).mpr
    nlinarith
  exact ⟨n, max_eq_left hbound⟩

#print axioms uniform_cut_margin
#print axioms strict_cut_margin
#print axioms positive_gap_sum
#print axioms ceiling_invariance
#print axioms integrated_trapping
#print axioms ScaleData.uniform_absorption
#print axioms logScale_succ
#print axioms logScale_reaches_cap

end Campaign149.BoundedKinetics
