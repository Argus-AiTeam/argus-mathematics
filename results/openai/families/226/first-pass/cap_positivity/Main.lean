import Mathlib

namespace CapPositivity

noncomputable section

def head0 : List ℝ → ℝ
  | [] => 0
  | x :: _ => x

def alternating : List ℝ → ℝ
  | [] => 0
  | x :: xs => x - alternating xs

def Decays (r : ℝ) : List ℝ → Prop
  | [] => True
  | x :: xs => 0 ≤ x ∧ Decays r xs ∧ head0 xs ≤ r * x

theorem alternating_bounds {r : ℝ} (hr0 : 0 ≤ r) (hr1 : r ≤ 1)
    (xs : List ℝ) (h : Decays r xs) :
    0 ≤ alternating xs ∧
      (1 - r) * head0 xs ≤ alternating xs ∧ alternating xs ≤ head0 xs := by
  induction xs with
  | nil => simp [alternating, head0]
  | cons x xs ih =>
    rcases h with ⟨hx, ht, hstep⟩
    rcases ih ht with ⟨ha0, _, ha1⟩
    change 0 ≤ x - alternating xs ∧
      (1 - r) * x ≤ x - alternating xs ∧ x - alternating xs ≤ x
    have hrx : r * x ≤ x := by nlinarith
    constructor
    · linarith
    constructor <;> nlinarith

def us (xs : List (ℝ × ℝ)) : List ℝ := xs.map Prod.fst
def vs (xs : List (ℝ × ℝ)) : List ℝ := xs.map Prod.snd
def Good (r : ℝ) (xs : List (ℝ × ℝ)) : Prop :=
  Decays r (us xs) ∧ Decays r (vs xs)

def within : List (ℝ × ℝ) → ℝ
  | [] => 0
  | x :: xs =>
      (x.1 * alternating (vs xs) + x.2 * alternating (us xs)) / 4 + within xs

def twoChains (xs ys : List (ℝ × ℝ)) : ℝ :=
  within xs + within ys +
    (alternating (us xs) * alternating (vs ys) +
      alternating (us ys) * alternating (vs xs)) / 4

theorem good_tail {r : ℝ} {x : ℝ × ℝ} {xs : List (ℝ × ℝ)}
    (h : Good r (x :: xs)) : Good r xs := by
  exact ⟨h.1.2.1, h.2.2.1⟩

theorem within_nonneg {r : ℝ} (hr0 : 0 ≤ r) (hr1 : r ≤ 1)
    (xs : List (ℝ × ℝ)) (h : Good r xs) : 0 ≤ within xs := by
  induction xs with
  | nil => simp [within]
  | cons x xs ih =>
    have ht := good_tail h
    have hu := (alternating_bounds hr0 hr1 (us xs) ht.1).1
    have hv := (alternating_bounds hr0 hr1 (vs xs) ht.2).1
    have hx : 0 ≤ x.1 := h.1.1
    have hy : 0 ≤ x.2 := h.2.1
    have hw := ih ht
    dsimp [within]
    positivity

theorem twoChains_nonneg {r : ℝ} (hr0 : 0 ≤ r) (hr1 : r ≤ 1)
    (xs ys : List (ℝ × ℝ)) (hx : Good r xs) (hy : Good r ys) :
    0 ≤ twoChains xs ys := by
  have hxu := (alternating_bounds hr0 hr1 (us xs) hx.1).1
  have hxv := (alternating_bounds hr0 hr1 (vs xs) hx.2).1
  have hyu := (alternating_bounds hr0 hr1 (us ys) hy.1).1
  have hyv := (alternating_bounds hr0 hr1 (vs ys) hy.2).1
  have hxw := within_nonneg hr0 hr1 xs hx
  have hyw := within_nonneg hr0 hr1 ys hy
  dsimp [twoChains]
  positivity

theorem alternating_threshold {r q : ℝ} (hr0 : 0 ≤ r) (hr1 : r ≤ 1)
    (xs : List ℝ) (h : Decays r xs) (hq : q ≤ head0 xs) :
    (1 - r) * q ≤ alternating xs := by
  have hb := (alternating_bounds hr0 hr1 xs h).2.1
  have hm := mul_le_mul_of_nonneg_left hq (sub_nonneg.mpr hr1)
  exact hm.trans hb

theorem twoChains_cross_detection {r q : ℝ}
    (hr0 : 0 ≤ r) (hr1 : r ≤ 1) (hq0 : 0 ≤ q)
    (xs ys : List (ℝ × ℝ)) (hx : Good r xs) (hy : Good r ys)
    (hxu : q ≤ head0 (us xs)) (hxv : q ≤ head0 (vs xs))
    (hyu : q ≤ head0 (us ys)) (hyv : q ≤ head0 (vs ys)) :
    (1 - r)^2 * q^2 / 2 ≤ twoChains xs ys := by
  let k := (1 - r) * q
  have hk : 0 ≤ k := mul_nonneg (sub_nonneg.mpr hr1) hq0
  have au : k ≤ alternating (us xs) := alternating_threshold hr0 hr1 _ hx.1 hxu
  have av : k ≤ alternating (vs xs) := alternating_threshold hr0 hr1 _ hx.2 hxv
  have bu : k ≤ alternating (us ys) := alternating_threshold hr0 hr1 _ hy.1 hyu
  have bv : k ≤ alternating (vs ys) := alternating_threshold hr0 hr1 _ hy.2 hyv
  have hab : k * k ≤ alternating (us xs) * alternating (vs ys) :=
    mul_le_mul au bv hk (hk.trans au)
  have hba : k * k ≤ alternating (us ys) * alternating (vs xs) :=
    mul_le_mul bu av hk (hk.trans bu)
  have hxw := within_nonneg hr0 hr1 xs hx
  have hyw := within_nonneg hr0 hr1 ys hy
  dsimp [twoChains]
  have hk2 : k * k = (1 - r)^2 * q^2 := by dsimp [k]; ring
  nlinarith

theorem within_head_detection {r q : ℝ}
    (hr0 : 0 ≤ r) (hr1 : r ≤ 1) (hq0 : 0 ≤ q)
    (x y : ℝ × ℝ) (xs : List (ℝ × ℝ))
    (h : Good r (x :: y :: xs))
    (hxu : q ≤ x.1) (hxv : q ≤ x.2)
    (hyu : q ≤ y.1) (hyv : q ≤ y.2) :
    (1 - r) * q^2 / 2 ≤ within (x :: y :: xs) := by
  have ht := good_tail h
  have au : (1 - r) * q ≤ alternating (us (y :: xs)) :=
    alternating_threshold hr0 hr1 _ ht.1 hyu
  have av : (1 - r) * q ≤ alternating (vs (y :: xs)) :=
    alternating_threshold hr0 hr1 _ ht.2 hyv
  have hk : 0 ≤ (1 - r) * q := mul_nonneg (sub_nonneg.mpr hr1) hq0
  have huv : q * ((1 - r) * q) ≤ x.1 * alternating (vs (y :: xs)) :=
    mul_le_mul hxu av hk (hq0.trans hxu)
  have hvu : q * ((1 - r) * q) ≤ x.2 * alternating (us (y :: xs)) :=
    mul_le_mul hxv au hk (hq0.trans hxv)
  have hw := within_nonneg hr0 hr1 (y :: xs) ht
  change _ ≤
    (x.1 * alternating (vs (y :: xs)) +
      x.2 * alternating (us (y :: xs))) / 4 + within (y :: xs)
  nlinarith

theorem same_loop_nonneg (u v : ℤ)
    (hlo : -1 ≤ u - v) (hhi : u - v ≤ 1) : 0 ≤ u * v := by
  by_cases hu : 0 ≤ u
  · by_cases hz : u = 0
    · simp [hz]
    · have hv : 0 ≤ v := by omega
      exact mul_nonneg hu hv
  · have hv : v ≤ 0 := by omega
    exact mul_nonneg_of_nonpos_of_nonpos (by omega) hv

theorem same_loop_detection (u v : ℤ)
    (hlo : -1 ≤ u - v) (hhi : u - v ≤ 1)
    (hu : u ≠ 0) (hv : v ≠ 0) : 1 ≤ u * v := by
  by_cases hp : 0 ≤ u
  · have hu1 : 1 ≤ u := by omega
    have hv1 : 1 ≤ v := by omega
    nlinarith
  · have hu1 : u ≤ -1 := by omega
    have hv1 : v ≤ -1 := by omega
    nlinarith

theorem same_sink_sign (e a b : ℝ) (he : e^2 = 1) :
    -(e * a) * (-e * b) = a * b := by
  calc
    -(e * a) * (-e * b) = e^2 * (a * b) := by ring
    _ = a * b := by rw [he]; ring

theorem same_color_sum {α β : Type*} (s : Finset α) (t : Finset β)
    (a : α → ℝ) (b : β → ℝ) :
    (∑ i ∈ s, ∑ j ∈ t, a i * b j / 2) =
      (∑ i ∈ s, a i) * (∑ j ∈ t, b j) / 2 := by
  simp_rw [← Finset.sum_div]
  rw [Finset.sum_mul]
  congr 1
  apply Finset.sum_congr rfl
  intro i hi
  rw [Finset.mul_sum]

theorem distinct_color_sum {α β : Type*} (s : Finset α) (t : Finset β)
    (a : α → ℝ) (b : β → ℝ) :
    (∑ i ∈ s, ∑ j ∈ t, -(a i * b j) / 4) =
      -((∑ i ∈ s, a i) * (∑ j ∈ t, b j)) / 4 := by
  simp_rw [← Finset.sum_div, Finset.sum_neg_distrib]
  rw [Finset.sum_mul]
  congr 2
  apply Finset.sum_congr rfl
  intro i hi
  rw [Finset.mul_sum]

def source : Matrix (Fin 2) (Fin 2) ℚ := !![0, 0; 1, 0]
def sink : Matrix (Fin 2) (Fin 2) ℚ := !![0, 1; 0, 0]

theorem one_source_one_sink : Matrix.trace (source * sink) = 1 := by
  norm_num [source, sink, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two]

theorem alternating_sources_sinks :
    Matrix.trace (source * sink * source * sink) = 1 := by
  norm_num [source, sink, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two]

theorem adjacent_sources :
    Matrix.trace (source * source * sink * sink) = 0 := by
  norm_num [source, sink, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two]

theorem adjacent_sinks :
    Matrix.trace (source * sink * sink * source) = 0 := by
  norm_num [source, sink, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two]

end

end CapPositivity
