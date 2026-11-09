import OAI.MeasureTheory.DyadicAvoidance.FixedScaleProbability
import OAI.MeasureTheory.DyadicAvoidance.ExposureUnionBound
import OAI.MeasureTheory.DyadicAvoidance.GridSeparation
import OAI.MeasureTheory.DyadicAvoidance.GridGeometry
import OAI.MeasureTheory.DyadicAvoidance.MonotoneRepresentatives
import OAI.MeasureTheory.DyadicAvoidance.FiniteLocalPredicate
import OAI.MeasureTheory.DyadicAvoidance.FiniteLocalHit
import OAI.MeasureTheory.DyadicAvoidance.CenterRouteExposure
import OAI.MeasureTheory.DyadicAvoidance.RoutedAddressInjectivity
import OAI.MeasureTheory.DyadicAvoidance.ConcreteLabelMeasures

noncomputable section

open scoped BigOperators
open MeasureTheory
open OAI.Problem310

namespace GeometricBridge

def gridFactor (q : ℝ) : ℝ := 4 / (1 - q)

def target (q : ℝ) (b : ℕ) : ℝ := gridFactor q / q ^ b

def exponent (q : ℝ) (b : ℕ) : ℕ :=
  ⌈Real.logb 2 (target q b)⌉₊

def resolution (q : ℝ) (b : ℕ) : ℕ := 2 ^ exponent q b

def level (q : ℝ) (b : ℕ) : ℕ := exponent q b - 2

def gridKey (q : ℝ) (b : ℕ) (x : ℝ) : ℤ :=
  GridSeparation.periodicKey (resolution q b) x

lemma gridFactor_pos {q : ℝ} (hq : q < 1) : 0 < gridFactor q := by
  unfold gridFactor
  positivity

lemma target_four {q : ℝ} (hq0 : 0 < q) (hq1 : q < 1) (b : ℕ) :
    4 < target q b := by
  have hp : 0 < q ^ b := pow_pos hq0 b
  have hp1 : q ^ b ≤ 1 := pow_le_one₀ hq0.le hq1.le
  have hc : 4 < gridFactor q := by
    unfold gridFactor
    apply (lt_div_iff₀ (by linarith : 0 < 1 - q)).2
    nlinarith
  have hcle : gridFactor q ≤ target q b := by
    unfold target
    exact (le_div_iff₀ hp).2 (by nlinarith [gridFactor_pos hq1])
  linarith

theorem resolution_bounds {q : ℝ} (hq0 : 0 < q) (hq1 : q < 1) (b : ℕ) :
    target q b ≤ (resolution q b : ℝ) ∧
      (resolution q b : ℝ) < 2 * target q b := by
  have ht : 0 < target q b := lt_trans (by norm_num) (target_four hq0 hq1 b)
  have hlog : 0 ≤ Real.logb 2 (target q b) :=
    Real.logb_nonneg (by norm_num) (by linarith [target_four hq0 hq1 b])
  constructor
  · have h := (Real.logb_le_iff_le_rpow (by norm_num : (1 : ℝ) < 2) ht).1
      (Nat.le_ceil (Real.logb 2 (target q b)))
    simpa [resolution, exponent, Real.rpow_natCast] using h
  · have h := (Real.rpow_lt_rpow_left_iff (by norm_num : (1 : ℝ) < 2)).2
      (Nat.ceil_lt_add_one hlog)
    rw [Real.rpow_add (by norm_num : (0 : ℝ) < 2),
      Real.rpow_logb (by norm_num : (0 : ℝ) < 2) (by norm_num : (2 : ℝ) ≠ 1) ht,
      Real.rpow_one] at h
    simpa [resolution, exponent, Real.rpow_natCast, mul_comm] using h

lemma exponent_two {q : ℝ} (hq0 : 0 < q) (hq1 : q < 1) (b : ℕ) :
    2 ≤ exponent q b := by
  have hl : (2 : ℝ) < Real.logb 2 (target q b) := by
    apply (Real.lt_logb_iff_rpow_lt (by norm_num : (1 : ℝ) < 2)
      (lt_trans (by norm_num) (target_four hq0 hq1 b))).2
    norm_num
    exact target_four hq0 hq1 b
  have hc := Nat.le_ceil (Real.logb 2 (target q b))
  unfold exponent
  exact_mod_cast (show (2 : ℝ) ≤ (⌈Real.logb 2 (target q b)⌉₊ : ℝ) by linarith)

lemma exponent_as_integer_ceiling {q : ℝ} (hq0 : 0 < q) (hq1 : q < 1)
    (b : ℕ) :
    (exponent q b : ℤ) = ⌈Real.logb 2 (target q b)⌉ := by
  have hlog : 0 ≤ Real.logb 2 (target q b) :=
    Real.logb_nonneg (by norm_num) (by linarith [target_four hq0 hq1 b])
  symm
  apply Int.ceil_eq_iff.2
  constructor
  · have h := Nat.ceil_lt_add_one hlog
    change (⌈Real.logb 2 (target q b)⌉₊ : ℝ) - 1 < Real.logb 2 (target q b)
    linarith
  · exact Nat.le_ceil _

lemma level_add_two {q : ℝ} (hq0 : 0 < q) (hq1 : q < 1) (b : ℕ) :
    level q b + 2 = exponent q b := by
  exact Nat.sub_add_cancel (exponent_two hq0 hq1 b)

theorem exponent_mono {q : ℝ} (hq0 : 0 < q) (hq1 : q < 1) :
    Monotone (exponent q) := by
  intro a b hab
  apply Nat.ceil_mono
  apply Real.logb_le_logb_of_le (by norm_num)
  · exact lt_trans (by norm_num) (target_four hq0 hq1 a)
  · unfold target
    exact div_le_div_of_nonneg_left (gridFactor_pos hq1).le (pow_pos hq0 b)
      (pow_le_pow_of_le_one hq0.le hq1.le hab)

lemma level_mono {q : ℝ} (hq0 : 0 < q) (hq1 : q < 1) :
    Monotone (level q) :=
  fun _ _ hab => Nat.sub_le_sub_right (exponent_mono hq0 hq1 hab) 2

lemma gridKey_eq_periodic {q : ℝ} (hq0 : 0 < q) (hq1 : q < 1)
    (b : ℕ) (x : ℝ) :
    gridKey q b x =
      GridSeparation.periodicKey ((2 : ℝ) ^ (level q b + 2)) x := by
  simp [gridKey, resolution, level_add_two hq0 hq1]

theorem key_eq_of_finer {q : ℝ} (hq0 : 0 < q) (hq1 : q < 1)
    {a b : ℕ} (hab : a ≤ b) {x y : ℝ}
    (hxy : gridKey q b x = gridKey q b y) :
    gridKey q a x = gridKey q a y := by
  rw [gridKey_eq_periodic hq0 hq1, gridKey_eq_periodic hq0 hq1] at hxy ⊢
  rw [GridSeparation.periodicKey_dyadic_refine (level_mono hq0 hq1 hab) x,
    GridSeparation.periodicKey_dyadic_refine (level_mono hq0 hq1 hab) y, hxy]

lemma mul_resolution_lower {q : ℝ} (hq0 : 0 < q) (hq1 : q < 1)
    (b : ℕ) :
    4 ≤ (resolution q b : ℝ) * ((1 - q) * q ^ b) := by
  have h := (resolution_bounds hq0 hq1 b).1
  have hp : 0 < (1 - q) * q ^ b := by positivity
  have heq : target q b * ((1 - q) * q ^ b) = 4 := by
    unfold target gridFactor
    have hq : q ≠ 0 := ne_of_gt hq0
    have h1 : 1 - q ≠ 0 := by linarith
    field_simp [hq, h1]
  nlinarith

theorem center_key_ne {q t x : ℝ} (hq0 : 0 < q) (hq1 : q < 1)
    {a n b : ℕ} (han : a ≤ n) (hnb : n ≤ b)
    (ha : 2 * q ^ a ≤ 1 / 4) (ht : t ∈ Set.Icc (1 : ℝ) 2) :
    gridKey q b x ≠ gridKey q b (x + t * q ^ n) := by
  have hN : (4 : ℝ) ≤ resolution q b := by
    linarith [(resolution_bounds hq0 hq1 b).1, target_four hq0 hq1 b]
  have hnp : 0 < q ^ n := pow_pos hq0 n
  have hn : q ^ n ≤ q ^ a := pow_le_pow_of_le_one hq0.le hq1.le han
  have hb : q ^ b ≤ q ^ n := pow_le_pow_of_le_one hq0.le hq1.le hnb
  have hlo := mul_resolution_lower hq0 hq1 b
  have hNb : 0 ≤ (resolution q b : ℝ) := by positivity
  have hqb : 0 < q ^ b := pow_pos hq0 b
  have hgap : (1 - q) * q ^ b ≤ t * q ^ n := by nlinarith [ht.1]
  exact GridSeparation.periodicKey_ne_of_small_shift hN
    (by nlinarith) (by nlinarith [ht.2])

theorem window_keys_ne {q t x : ℝ} (hq0 : 0 < q) (hq1 : q < 1)
    {a n m b : ℕ} (han : a ≤ n) (hnm : n < m) (hmb : m ≤ b)
    (ha : 2 * q ^ a ≤ 1 / 4) (ht : t ∈ Set.Icc (1 : ℝ) 2) :
    gridKey q b (x + t * q ^ n) ≠ gridKey q b (x + t * q ^ m) := by
  have hN : (4 : ℝ) ≤ resolution q b := by
    linarith [(resolution_bounds hq0 hq1 b).1, target_four hq0 hq1 b]
  have hn : q ^ n ≤ q ^ a := pow_le_pow_of_le_one hq0.le hq1.le han
  have hnb : q ^ b ≤ q ^ n := pow_le_pow_of_le_one hq0.le hq1.le (by omega)
  have hmn : q ^ m ≤ q ^ (n + 1) :=
    pow_le_pow_of_le_one hq0.le hq1.le hnm
  have hgap : (1 - q) * q ^ b ≤ q ^ n - q ^ m := by
    rw [pow_succ] at hmn
    nlinarith [pow_pos hq0 n]
  have hp : 0 < q ^ n - q ^ m := by
    have := mul_pos (sub_pos.mpr hq1) (pow_pos hq0 b)
    linarith
  have hlo := mul_resolution_lower hq0 hq1 b
  have hNb : 0 ≤ (resolution q b : ℝ) := by positivity
  have hlow : 1 ≤ (resolution q b : ℝ) * (t * (q ^ n - q ^ m)) := by
    have : (1 - q) * q ^ b ≤ t * (q ^ n - q ^ m) := by nlinarith [ht.1]
    nlinarith
  have hhigh : t * (q ^ n - q ^ m) ≤ 1 / 4 := by
    nlinarith [ht.2, pow_pos hq0 m]
  have h := GridSeparation.periodicKey_ne_of_small_shift
    (x := x + t * q ^ m) hN hlow hhigh
  have heq : x + t * q ^ m + t * (q ^ n - q ^ m) = x + t * q ^ n := by ring
  rw [heq] at h
  exact Ne.symm h

theorem stable_key {q x t : ℝ} (hq0 : 0 < q) (hq1 : q < 1)
    {a n b B : ℕ} (han : a ≤ n) (hbB : b ≤ B)
    (ht : t ∈ Set.Icc (1 : ℝ) 2)
    (hstable : ∀ k : ℤ, (k : ℝ) / resolution q B ∉
      Set.Ioc x (x + 2 * q ^ a)) :
    gridKey q b (x + t * q ^ n) = gridKey q b x := by
  have hp : 0 < resolution q B := by unfold resolution; positivity
  have hn : q ^ n ≤ q ^ a := pow_le_pow_of_le_one hq0.le hq1.le han
  have hshift : 0 < t * q ^ n := mul_pos (by linarith [ht.1]) (pow_pos hq0 n)
  have hbound : t * q ^ n ≤ 2 * q ^ a := by
    nlinarith [ht.2, pow_pos hq0 n]
  have heq := periodicGridKey_eq_of_no_crossing (resolution q B) hp
    (show x ≤ x + t * q ^ n by linarith)
    (fun k hk => hstable k ⟨hk.1, by linarith [hk.2]⟩)
  exact key_eq_of_finer hq0 hq1 hbB heq.symm

theorem slope_bound {q : ℝ} (hq0 : 0 < q) (hq1 : q < 1)
    {a n B r : ℕ} (han : a ≤ n) (hspan : B + 1 ≤ a + 2 * r) :
    (resolution q B : ℝ) * q ^ n < 2 * gridFactor q / q ^ (2 * r) := by
  have hpow : q ^ (n + 2 * r) ≤ q ^ B :=
    pow_le_pow_of_le_one hq0.le hq1.le (by omega)
  rw [pow_add] at hpow
  have hc : 0 < gridFactor q := gridFactor_pos hq1
  have hn : 0 < q ^ n := pow_pos hq0 n
  have hB : 0 < q ^ B := pow_pos hq0 B
  have hr : 0 < q ^ (2 * r) := pow_pos hq0 (2 * r)
  have hcancel : (gridFactor q / q ^ B) * q ^ n ≤ gridFactor q / q ^ (2 * r) := by
    apply (le_div_iff₀ hr).2
    rw [div_mul_eq_mul_div, div_mul_eq_mul_div]
    apply (div_le_iff₀ hB).2
    nlinarith
  have h := mul_lt_mul_of_pos_right (resolution_bounds hq0 hq1 B).2 hn
  unfold target at h
  calc
    (resolution q B : ℝ) * q ^ n < 2 * (gridFactor q / q ^ B) * q ^ n := h
    _ = 2 * ((gridFactor q / q ^ B) * q ^ n) := by ring
    _ ≤ 2 * (gridFactor q / q ^ (2 * r)) := by linarith
    _ = 2 * gridFactor q / q ^ (2 * r) := by ring

theorem geometric_representatives {ι : Type*} [Fintype ι]
    {q : ℝ} (hq0 : 0 < q) (hq1 : q < 1) (x : ℝ)
    (a n B : ι → ℕ) (r : ℕ)
    (han : ∀ i, a i ≤ n i)
    (hspan : ∀ i, B i + 1 ≤ a i + 2 * r) :
    ∃ R : Finset ℝ,
      (∀ t ∈ R, t ∈ Set.Icc (1 : ℝ) 2) ∧
      (R.card : ℝ) ≤
        1 + Fintype.card ι * (1 + 2 * gridFactor q / q ^ (2 * r)) ∧
      ∀ t ∈ Set.Icc (1 : ℝ) 2, ∃ s ∈ R,
        ∀ i, gridKey q (B i) (x + s * q ^ n i) =
          gridKey q (B i) (x + t * q ^ n i) := by
  classical
  let u : ι → ℝ := fun i => (resolution q (B i) : ℝ) * x
  let v : ι → ℝ := fun i => (resolution q (B i) : ℝ) * q ^ n i
  have hv : ∀ i, 0 ≤ v i := by
    intro i
    dsimp [v]
    positivity
  obtain ⟨R, hR, hcard, hcover⟩ :=
    ScaleDiscretization.exists_affine_floor_representatives
      (1 : ℝ) 2 (by norm_num) u v hv
  have hceil : ∀ i, (⌈v i⌉ : ℝ) ≤ 1 + 2 * gridFactor q / q ^ (2 * r) := by
    intro i
    have h := Int.ceil_lt_add_one (v i)
    have hs := slope_bound hq0 hq1 (han i) (hspan i)
    dsimp [v] at h
    linarith
  have hL : (0 : ℤ) ≤ 1 + ∑ i, ⌈v i⌉ := by
    have hs : (0 : ℤ) ≤ ∑ i, ⌈v i⌉ :=
      Finset.sum_nonneg (fun i _ => Int.ceil_nonneg (hv i))
    omega
  have hcard' : (R.card : ℝ) ≤ 1 + ∑ i, (⌈v i⌉ : ℝ) := by
    simp only [show (2 : ℝ) - 1 = 1 by norm_num, mul_one] at hcard
    have ht : (R.card : ℤ) ≤ 1 + ∑ i, ⌈v i⌉ := by
      have h := (Int.ofNat_le).2 hcard
      simpa only [Int.toNat_of_nonneg hL] using h
    exact_mod_cast ht
  have hsum : ∑ i, (⌈v i⌉ : ℝ) ≤
      Fintype.card ι * (1 + 2 * gridFactor q / q ^ (2 * r)) := by
    calc
      ∑ i, (⌈v i⌉ : ℝ) ≤ ∑ _i : ι, (1 + 2 * gridFactor q / q ^ (2 * r)) :=
        Finset.sum_le_sum (fun i _ => hceil i)
      _ = Fintype.card ι * (1 + 2 * gridFactor q / q ^ (2 * r)) := by simp [mul_add]
  refine ⟨R, hR, by linarith, ?_⟩
  intro t ht
  obtain ⟨s, hs, hfloor⟩ := hcover t ht
  refine ⟨s, hs, ?_⟩
  intro i
  have hf :
      ⌊(2 : ℝ) ^ exponent q (B i) * (x + s * q ^ n i)⌋ =
      ⌊(2 : ℝ) ^ exponent q (B i) * (x + t * q ^ n i)⌋ := by
    convert hfloor i using 1 <;> dsimp [u, v, resolution] <;> push_cast <;>
      congr 1 <;> ring
  have hp := ScaleDiscretization.periodic_floor_eq_of_floor_eq
    (exponent q (B i)) hf
  simpa [gridKey, resolution, GridSeparation.periodicKey] using hp

open FiniteTableModel

lemma finite_key_eq_iff {q : ℝ} (hq0 : 0 < q) (hq1 : q < 1)
    (b : ℕ) (x y : ℝ) :
    GridSeparation.dyadicKey (level q b) x =
      GridSeparation.dyadicKey (level q b) y ↔
      gridKey q b x = gridKey q b y := by
  rw [GridSeparation.dyadicKey_eq_iff]
  rw [gridKey_eq_periodic hq0 hq1, gridKey_eq_periodic hq0 hq1]

theorem finite_window_keys_injective {q t x : ℝ}
    (hq0 : 0 < q) (hq1 : q < 1) {a b r : ℕ}
    (hlen : a + r = b + 1) (ha : 2 * q ^ a ≤ 1 / 4)
    (ht : t ∈ Set.Icc (1 : ℝ) 2) :
    Function.Injective (fun j : Fin r =>
      GridSeparation.dyadicKey (level q b) (x + t * q ^ (a + j.val))) := by
  intro i j hij
  apply Fin.ext
  have heq := (finite_key_eq_iff hq0 hq1 b _ _).1 hij
  by_contra hne
  rcases lt_or_gt_of_ne hne with hlt | hgt
  · exact window_keys_ne hq0 hq1 (by omega) (by omega) (by omega) ha ht heq
  · exact window_keys_ne hq0 hq1 (by omega) (by omega) (by omega) ha ht heq.symm

structure LocalWindows (q : ℝ) (m d r : ℕ) (U : Node m d) where
  start : Fin m → ℕ
  selectorEnd : Node m d → Fin m → ℕ
  terminalEnd : Leaf m d → ℕ
  blockEnd : Fin m → ℕ
  window_length : ∀ i, start i + r = selectorEnd U i + 1
  small_shift : ∀ i, 2 * q ^ start i ≤ 1 / 4
  edge_le_block : ∀ i, selectorEnd U i ≤ blockEnd i
  block_span : ∀ i, blockEnd i + 1 ≤ start i + 2 * r
  subtree_selector : ∀ i (P : Node m d),
    (U.val ++ [i.castSucc]).IsPrefix P.val →
      ∀ j, selectorEnd P j ≤ blockEnd i
  subtree_terminal : ∀ i (L : Leaf m d),
    (U.val ++ [i.castSucc]).IsPrefix L.val →
      selectorEnd U i ≤ terminalEnd L ∧ terminalEnd L ≤ blockEnd i

namespace LocalWindows

variable {q : ℝ} {m d r : ℕ} {U : Node m d}

def selectorLevels (G : LocalWindows q m d r U) : Node m d → Fin m → ℕ :=
  fun P i => level q (G.selectorEnd P i)

def terminalLevels (G : LocalWindows q m d r U) : Leaf m d → ℕ :=
  fun L => level q (G.terminalEnd L)

abbrev Trial (G : LocalWindows q m d r U) := Fin m × Fin r

abbrev Outcome (G : LocalWindows q m d r U) :=
  SelectorTable G.selectorLevels × TerminalTable G.terminalLevels

def index (G : LocalWindows q m d r U) (j : G.Trial) : ℕ :=
  G.start j.1 + j.2.val

def point (G : LocalWindows q m d r U) (x t : ℝ) (j : G.Trial) : ℝ :=
  x + t * q ^ G.index j

def centerAddress (G : LocalWindows q m d r U) (x : ℝ)
    (c : Node m d × Fin m) : SelectorAddress G.selectorLevels :=
  selectorAddress G.selectorLevels c.1 c.2 x

def freshAddress (G : LocalWindows q m d r U) (x t : ℝ)
    (j : G.Trial) : SelectorAddress G.selectorLevels :=
  selectorAddress G.selectorLevels U j.1 (G.point x t j)

def leaf (G : LocalWindows q m d r U)
    (s : SelectorTable G.selectorLevels) (x t : ℝ) (j : G.Trial) : Leaf m d :=
  FiniteLocalPredicate.localLeaf
    (RoutedSetDensity.selectorChoice G.selectorLevels s)
    (d - U.val.length - 1) (U.val ++ [j.1.castSucc])
    (by have := U.property; simp only [List.length_append, List.length_singleton]; omega)
    (G.point x t j)

def terminalAddress (G : LocalWindows q m d r U)
    (s : SelectorTable G.selectorLevels) (x t : ℝ) (j : G.Trial) :
    TerminalAddress G.terminalLevels :=
  FiniteTableModel.terminalAddress G.terminalLevels (G.leaf s x t j) (G.point x t j)

def test (G : LocalWindows q m d r U) (ω : G.Outcome) (x t : ℝ)
    (j : G.Trial) : Bool :=
  ω.1 (G.freshAddress x t j) && ω.2 (G.terminalAddress ω.1 x t j)

theorem center_injective (G : LocalWindows q m d r U) (x : ℝ) :
    Function.Injective (G.centerAddress x) := by
  intro a b hab
  exact congrArg Sigma.fst hab

theorem fresh_injective (G : LocalWindows q m d r U)
    (hq0 : 0 < q) (hq1 : q < 1) (x : ℝ)
    {t : ℝ} (ht : t ∈ Set.Icc (1 : ℝ) 2) :
    Function.Injective (G.freshAddress x t) := by
  rintro ⟨i, n⟩ ⟨j, k⟩ h
  have hi : i = j := congrArg (fun z : SelectorAddress G.selectorLevels => z.1.2) h
  subst j
  have hval := congrArg (fun z : SelectorAddress G.selectorLevels => z.2.val) h
  have hk :
      GridSeparation.dyadicKey (level q (G.selectorEnd U i))
        (x + t * q ^ (G.start i + n.val)) =
      GridSeparation.dyadicKey (level q (G.selectorEnd U i))
        (x + t * q ^ (G.start i + k.val)) := by
    apply Fin.ext
    exact hval
  have hn := finite_window_keys_injective hq0 hq1
    (G.window_length i) (G.small_shift i) ht hk
  subst k
  rfl

theorem center_fresh_disjoint (G : LocalWindows q m d r U)
    (hq0 : 0 < q) (hq1 : q < 1) (x : ℝ)
    {t : ℝ} (ht : t ∈ Set.Icc (1 : ℝ) 2) :
    ∀ c j, G.centerAddress x c ≠ G.freshAddress x t j := by
  intro c j h
  have hc : c = (U, j.1) := congrArg Sigma.fst h
  subst c
  have hval := congrArg (fun z : SelectorAddress G.selectorLevels => z.2.val) h
  have hk :
      GridSeparation.dyadicKey (level q (G.selectorEnd U j.1)) x =
      GridSeparation.dyadicKey (level q (G.selectorEnd U j.1)) (G.point x t j) :=
    Fin.ext hval
  have heq := (finite_key_eq_iff hq0 hq1 _ _ _).1 hk
  exact center_key_ne hq0 hq1 (by dsimp [index]; omega)
    (by have := G.window_length j.1; have := j.2.isLt; dsimp [index]; omega)
    (G.small_shift j.1) ht heq

theorem combined_selector_injective (G : LocalWindows q m d r U)
    (hq0 : 0 < q) (hq1 : q < 1) (x : ℝ)
    {t : ℝ} (ht : t ∈ Set.Icc (1 : ℝ) 2) :
    Function.Injective (Sum.elim (G.centerAddress x) (G.freshAddress x t)) :=
  CenterExposure.injective_sum_addresses
    (G.centerAddress x) (G.freshAddress x t)
    (G.center_injective x) (G.fresh_injective hq0 hq1 x ht)
    (G.center_fresh_disjoint hq0 hq1 x ht)

theorem leaf_prefix (G : LocalWindows q m d r U)
    (s : SelectorTable G.selectorLevels) (x t : ℝ) (j : G.Trial) :
    (U.val ++ [j.1.castSucc]).IsPrefix (G.leaf s x t j).val :=
  RoutingPath.prefix_routeFrom _ _ _ _

theorem terminal_injective (G : LocalWindows q m d r U)
    (hq0 : 0 < q) (hq1 : q < 1) (x : ℝ)
    {t : ℝ} (ht : t ∈ Set.Icc (1 : ℝ) 2)
    (s : SelectorTable G.selectorLevels) :
    Function.Injective (G.terminalAddress s x t) := by
  intro i j h
  have hL : G.leaf s x t i = G.leaf s x t j := congrArg Sigma.fst h
  have hj : (U.val ++ [j.1.castSucc]).IsPrefix (G.leaf s x t i).val := by
    rw [hL]
    exact G.leaf_prefix s x t j
  have hchild := AddressInjectivity.child_eq_of_common_descendant
    (G.leaf_prefix s x t i) hj
  have hi : i.1 = j.1 :=
    Fin.ext (congrArg (fun c : Fin (m + 1) => c.val) hchild)
  rcases i with ⟨a, n⟩
  rcases j with ⟨b, k⟩
  dsimp only at hi
  subst b
  have hval := congrArg (fun z : TerminalAddress G.terminalLevels => z.2.val) h
  have hk :
      GridSeparation.dyadicKey (G.terminalLevels (G.leaf s x t (a, k)))
        (G.point x t (a, n)) =
      GridSeparation.dyadicKey (G.terminalLevels (G.leaf s x t (a, k)))
        (G.point x t (a, k)) := by
    apply Fin.ext
    change (GridSeparation.dyadicKey (G.terminalLevels (G.leaf s x t (a, n)))
        (G.point x t (a, n))).val =
      (GridSeparation.dyadicKey (G.terminalLevels (G.leaf s x t (a, k)))
        (G.point x t (a, k))).val at hval
    have hend := congrArg G.terminalLevels hL
    change G.terminalLevels (G.leaf s x t (a, n)) =
      G.terminalLevels (G.leaf s x t (a, k)) at hend
    rw [hend] at hval
    exact hval
  have hgrid := (finite_key_eq_iff hq0 hq1 _ _ _).1 hk
  have hbase := key_eq_of_finer hq0 hq1
    (G.subtree_terminal a (G.leaf s x t (a, k)) (G.leaf_prefix s x t (a, k))).1
    hgrid
  have hfinite := (finite_key_eq_iff hq0 hq1 _ _ _).2 hbase
  have hn := finite_window_keys_injective hq0 hq1
    (G.window_length a) (G.small_shift a) ht hfinite
  exact Prod.ext rfl hn

def law (G : LocalWindows q m d r U) (νs νt : Measure Bool) : Measure G.Outcome :=
  (Measure.pi (fun _ : SelectorAddress G.selectorLevels => νs)).prod
    (Measure.pi (fun _ : TerminalAddress G.terminalLevels => νt))

instance law_probability (G : LocalWindows q m d r U) (νs νt : Measure Bool)
    [IsProbabilityMeasure νs] [IsProbabilityMeasure νt] :
    IsProbabilityMeasure (G.law νs νt) := by
  dsimp [law]
  infer_instance

def atom (G : LocalWindows q m d r U) (x : ℝ)
    (ξ : Node m d × Fin m → Bool) : Set G.Outcome :=
  {ω | ∀ c, ω.1 (G.centerAddress x c) = ξ c}

def selectorAtomMass (G : LocalWindows q m d r U) (νs : Measure Bool) (x : ℝ)
    (ξ : Node m d × Fin m → Bool) : ENNReal :=
  (Measure.pi (fun _ : SelectorAddress G.selectorLevels => νs))
    {s | ∀ c, s (G.centerAddress x c) = ξ c}

lemma atom_mass (G : LocalWindows q m d r U) (νs νt : Measure Bool)
    [IsProbabilityMeasure νs] [IsProbabilityMeasure νt]
    (x : ℝ) (ξ : Node m d × Fin m → Bool) :
    G.law νs νt (G.atom x ξ) = G.selectorAtomMass νs x ξ := by
  have hset : G.atom x ξ =
      {s | ∀ c, s (G.centerAddress x c) = ξ c} ×ˢ
        (Set.univ : Set (TerminalTable G.terminalLevels)) := by
    ext ω
    simp [atom]
  rw [hset, law, Measure.prod_prod]
  simp [selectorAtomMass]

def failures (G : LocalWindows q m d r U) (x t : ℝ) : Set G.Outcome :=
  {ω | ∀ j, G.test ω x t j = false}

theorem fixed_failure_mass (G : LocalWindows q m d r U)
    (hq0 : 0 < q) (hq1 : q < 1) (x : ℝ)
    (ξ : Node m d × Fin m → Bool) {t : ℝ} (ht : t ∈ Set.Icc (1 : ℝ) 2)
    (νs νt : Measure Bool) [IsProbabilityMeasure νs] [IsProbabilityMeasure νt]
    (hfalse : νs {false} = 1 / 2) (htrue : νs {true} = 1 / 2)
    (p : ℝ) (hp1 : p ≤ 1) (hterminal : νt {false} = ENNReal.ofReal (1 - p)) :
    G.law νs νt (G.failures x t ∩ G.atom x ξ) =
      ENNReal.ofReal (1 - p / 2) ^ (m * r) * G.law νs νt (G.atom x ξ) := by
  have hset : G.failures x t ∩ G.atom x ξ =
      {ω : G.Outcome | (∀ c, ω.1 (G.centerAddress x c) = ξ c) ∧
        ∀ j, ω.1 (G.freshAddress x t j) = true →
          ω.2 (G.terminalAddress ω.1 x t j) = false} := by
    ext ω
    constructor
    · rintro ⟨hf, ha⟩
      refine ⟨ha, ?_⟩
      intro j hj
      simpa [test, hj] using hf j
    · rintro ⟨ha, hf⟩
      refine ⟨?_, ha⟩
      intro j
      cases hA : ω.1 (G.freshAddress x t j) with
      | false => simp [test, hA]
      | true => simpa [test, hA] using hf j hA
  rw [G.atom_mass νs νt x ξ, hset, law]
  have h := FixedScaleProbability.measure_fixed_scale_eq_atom_mass
    νs νt hfalse htrue (G.centerAddress x) (G.freshAddress x t)
    (G.combined_selector_injective hq0 hq1 x ht) ξ
    (fun s => G.terminalAddress s x t)
    (fun s => G.terminal_injective hq0 hq1 x ht s) p hp1 hterminal
  simpa [Trial, Fintype.card_prod, selectorAtomMass, mul_comm] using h

theorem uniform_representatives (G : LocalWindows q m d r U)
    (hq0 : 0 < q) (hq1 : q < 1) (x : ℝ) :
    ∃ R : Finset ℝ,
      (∀ t ∈ R, t ∈ Set.Icc (1 : ℝ) 2) ∧
      (R.card : ℝ) ≤ 1 + (m * r : ℕ) * (1 + 2 * gridFactor q / q ^ (2 * r)) ∧
      ∀ t ∈ Set.Icc (1 : ℝ) 2, ∃ s ∈ R,
        ∀ ω : G.Outcome, ∀ j, G.test ω x s j = G.test ω x t j := by
  classical
  obtain ⟨R, hR, hcard, hcover⟩ := geometric_representatives hq0 hq1 x
    (fun j : G.Trial => G.start j.1) G.index (fun j => G.blockEnd j.1) r
    (by intro j; dsimp [index]; omega) (fun j => G.block_span j.1)
  refine ⟨R, hR, ?_, ?_⟩
  · simpa [Trial, Fintype.card_prod] using hcard
  · intro t ht
    obtain ⟨s, hs, hkeys⟩ := hcover t ht
    refine ⟨s, hs, ?_⟩
    intro ω j
    apply FiniteLocalPredicate.finite_local_predicate_factors
      G.selectorLevels G.terminalLevels ω.1 ω.2
      (RoutedSetDensity.selectorChoice G.selectorLevels ω.1)
      (fun _ bits => OrderedRouting.chooseChild bits)
      (by intros; rfl)
      (d - U.val.length - 1) (U.val ++ [j.1.castSucc])
      (by have := U.property; simp only [List.length_append, List.length_singleton]; omega)
      U j.1 (level q (G.blockEnd j.1))
    · intro P hP i
      exact level_mono hq0 hq1 (G.subtree_selector j.1 P hP i)
    · intro L hL
      exact level_mono hq0 hq1 (G.subtree_terminal j.1 L hL).2
    · exact level_mono hq0 hq1 (G.edge_le_block j.1)
    · have h := hkeys j
      rw [gridKey_eq_periodic hq0 hq1, gridKey_eq_periodic hq0 hq1] at h
      exact h

def localMiss (G : LocalWindows q m d r U) (x : ℝ) : Set G.Outcome :=
  {ω | ∃ t ∈ Set.Icc (1 : ℝ) 2, ∀ j, G.test ω x t j = false}

def sharpCount (q : ℝ) (m r : ℕ) : ℝ :=
  1 + (m * r : ℕ) * (1 + 2 * gridFactor q / q ^ (2 * r))

theorem local_all_scales_mass (G : LocalWindows q m d r U)
    (hq0 : 0 < q) (hq1 : q < 1) (x : ℝ)
    (ξ : Node m d × Fin m → Bool)
    (νs νt : Measure Bool) [IsProbabilityMeasure νs] [IsProbabilityMeasure νt]
    (hfalse : νs {false} = 1 / 2) (htrue : νs {true} = 1 / 2)
    (p : ℝ) (hp1 : p ≤ 1) (hterminal : νt {false} = ENNReal.ofReal (1 - p)) :
    G.law νs νt (G.localMiss x ∩ G.atom x ξ) ≤
      ENNReal.ofReal (sharpCount q m r) *
        ENNReal.ofReal (1 - p / 2) ^ (m * r) * G.law νs νt (G.atom x ξ) := by
  classical
  obtain ⟨R, hR, hcard, hcover⟩ := G.uniform_representatives hq0 hq1 x
  have hcover' : G.localMiss x ∩ G.atom x ξ ⊆
      ⋃ s ∈ R, G.failures x s ∩ G.atom x ξ := by
    rintro ω ⟨⟨t, ht, hfail⟩, ha⟩
    obtain ⟨s, hs, hsame⟩ := hcover t ht
    refine Set.mem_iUnion.2 ⟨s, Set.mem_iUnion.2 ⟨hs, ?_⟩⟩
    exact ⟨fun j => (hsame ω j).trans (hfail j), ha⟩
  have hbound := ExposureUnionBound.measure_inter_le_of_finite_cover
    (G.law νs νt) (G.localMiss x) (G.atom x ξ) R (G.failures x)
    (ENNReal.ofReal (1 - p / 2) ^ (m * r)) hcover'
    (fun s hs => (G.fixed_failure_mass hq0 hq1 x ξ (hR s hs)
      νs νt hfalse htrue p hp1 hterminal).le)
  have hcard' : (R.card : ENNReal) ≤ ENNReal.ofReal (sharpCount q m r) := by
    simpa only [ENNReal.ofReal_natCast, sharpCount] using ENNReal.ofReal_le_ofReal hcard
  exact hbound.trans
    (mul_le_mul_right' (mul_le_mul_right' hcard'
      (ENNReal.ofReal (1 - p / 2) ^ (m * r))) _)

structure Predecessors (G : LocalWindows q m d r U) where
  previous : Fin m → ℕ
  noninitial : Fin m → Prop
  sibling : ∀ i j, j < i →
    noninitial i ∧ G.selectorEnd U j ≤ previous i
  ancestor : ∀ i (P : Node m d) (c : Child m),
    (P.val ++ [c]).IsPrefix U.val → ∀ j : Fin m, j.castSucc ≤ c →
      noninitial i ∧ G.selectorEnd P j ≤ previous i

def Predecessors.Stable {G : LocalWindows q m d r U} (A : Predecessors G)
    (x : ℝ) : Prop :=
  ∀ i, A.noninitial i → ∀ k : ℤ,
    (k : ℝ) / resolution q (A.previous i) ∉
      Set.Ioc x (x + 2 * q ^ G.start i)

def firstDefaultOnAtom (G : LocalWindows q m d r U) (x : ℝ)
    (ξ : Node m d × Fin m → Bool) : Prop :=
  ∀ s : SelectorTable G.selectorLevels,
    (∀ c, s (G.centerAddress x c) = ξ c) →
    RoutingPath.routeFrom (RoutedSetDensity.selectorChoice G.selectorLevels s)
        U.val.length [] x = U.val ∧
      (∀ l < U.val.length,
        RoutedSetDensity.selectorChoice G.selectorLevels s
          (RoutingPath.routeFrom
            (RoutedSetDensity.selectorChoice G.selectorLevels s) l [] x) x ≠
          Fin.last m) ∧
      RoutedSetDensity.selectorChoice G.selectorLevels s U.val x = Fin.last m

lemma selectorValue_eq_of_grid (G : LocalWindows q m d r U)
    (hq0 : 0 < q) (hq1 : q < 1)
    (s : SelectorTable G.selectorLevels) (P : Node m d) (i : Fin m)
    {x y : ℝ} (hkey : gridKey q (G.selectorEnd P i) x =
      gridKey q (G.selectorEnd P i) y) :
    selectorValue G.selectorLevels s P.val i x =
      selectorValue G.selectorLevels s P.val i y := by
  have hk := (finite_key_eq_iff hq0 hq1 _ _ _).2 hkey
  unfold selectorValue
  rw [dif_pos P.property, dif_pos P.property]
  apply congrArg s
  exact congrArg
    (fun z => (⟨(P, i), z⟩ : SelectorAddress G.selectorLevels)) hk

lemma chosen_prefix {α X : Type*} (choose : List α → X → α) (x : X)
    {l k : ℕ} (hl : l < k) :
    (RoutingPath.routeFrom choose l [] x ++
      [choose (RoutingPath.routeFrom choose l [] x) x]).IsPrefix
      (RoutingPath.routeFrom choose k [] x) := by
  have hp := RoutingPath.prefix_routeFrom choose (k - (l + 1))
    (RoutingPath.routeFrom choose (l + 1) [] x) x
  have heq : RoutingPath.routeFrom choose k [] x =
      RoutingPath.routeFrom choose (k - (l + 1))
        (RoutingPath.routeFrom choose (l + 1) [] x) x := by
    conv_lhs => rw [show k = (l + 1) + (k - (l + 1)) by omega]
    rw [RoutingPath.routeFrom_add]
  rw [← heq] at hp
  simpa only [RoutingPath.routeFrom_succ] using hp

theorem local_hit (G : LocalWindows q m d r U) (A : Predecessors G)
    (hq0 : 0 < q) (hq1 : q < 1) (x : ℝ)
    (ξ : Node m d × Fin m → Bool) (hstable : A.Stable x)
    (hfirst : G.firstDefaultOnAtom x ξ)
    (ω : G.Outcome) (ha : ω ∈ G.atom x ξ)
    {t : ℝ} (ht : t ∈ Set.Icc (1 : ℝ) 2)
    (j : G.Trial) (hlocal : G.test ω x t j = true) :
    G.point x t j ∈ RoutedSetDensity.routedSet
      G.selectorLevels G.terminalLevels ω := by
  obtain ⟨hU, hnd, hdefault⟩ := hfirst ω.1 ha
  refine FiniteLocalHit.local_test_mem_routedSet
    G.selectorLevels G.terminalLevels ω.1 ω.2
    U.val.length (d - U.val.length - 1) U j.1 x (G.point x t j)
    (by have := U.property; simp only [List.length_append, List.length_singleton]; omega)
    hU hnd ?_ hdefault ?_ hlocal
  · intro l hl i hi
    let choose := RoutedSetDensity.selectorChoice G.selectorLevels ω.1
    let P := RoutingPath.routeFrom choose l [] x
    have hP : P.length < d := by
      have hlen := RoutingPath.length_routeFrom choose l [] x
      have hUd := U.property
      dsimp [P]
      simp only [List.length_nil, zero_add] at hlen
      omega
    have hpref :
        (P ++ [choose P x]).IsPrefix U.val := by
      have hp := chosen_prefix choose x hl
      rw [hU] at hp
      exact hp
    obtain ⟨hinit, hend⟩ := A.ancestor j.1 ⟨P, hP⟩ (choose P x) hpref i hi
    have hk := stable_key hq0 hq1
      (show G.start j.1 ≤ G.index j by dsimp [index]; omega)
      hend ht (hstable j.1 hinit)
    exact G.selectorValue_eq_of_grid hq0 hq1 ω.1 ⟨P, hP⟩ i hk.symm
  · intro i hi
    obtain ⟨hinit, hend⟩ := A.sibling j.1 i hi
    have hk := stable_key hq0 hq1
      (show G.start j.1 ≤ G.index j by dsimp [index]; omega)
      hend ht (hstable j.1 hinit)
    exact G.selectorValue_eq_of_grid hq0 hq1 ω.1 U i hk.symm

def miss (G : LocalWindows q m d r U) (indices : Finset ℕ) (x : ℝ) :
    Set G.Outcome :=
  {ω | ∃ t ∈ Set.Icc (1 : ℝ) 2, ∀ n ∈ indices,
    x + t * q ^ n ∉ RoutedSetDensity.routedSet G.selectorLevels G.terminalLevels ω}

theorem miss_subset_local (G : LocalWindows q m d r U) (A : Predecessors G)
    (hq0 : 0 < q) (hq1 : q < 1) (x : ℝ)
    (ξ : Node m d × Fin m → Bool) (hstable : A.Stable x)
    (hfirst : G.firstDefaultOnAtom x ξ)
    (indices : Finset ℕ) (hindices : ∀ j : G.Trial, G.index j ∈ indices) :
    G.miss indices x ∩ G.atom x ξ ⊆ G.localMiss x ∩ G.atom x ξ := by
  rintro ω ⟨⟨t, ht, hmiss⟩, ha⟩
  refine ⟨⟨t, ht, ?_⟩, ha⟩
  intro j
  cases htest : G.test ω x t j with
  | false => rfl
  | true =>
    exact False.elim (hmiss (G.index j) (hindices j)
      (G.local_hit A hq0 hq1 x ξ hstable hfirst ω ha ht j htest))

theorem conditional_geometric_power (G : LocalWindows q m d r U)
    (A : Predecessors G) (hq0 : 0 < q) (hq1 : q < 1) (x : ℝ)
    (ξ : Node m d × Fin m → Bool) (hstable : A.Stable x)
    (hfirst : G.firstDefaultOnAtom x ξ)
    (indices : Finset ℕ) (hindices : ∀ j : G.Trial, G.index j ∈ indices)
    (νs νt : Measure Bool) [IsProbabilityMeasure νs] [IsProbabilityMeasure νt]
    (hfalse : νs {false} = 1 / 2) (htrue : νs {true} = 1 / 2)
    (p : ℝ) (hp1 : p ≤ 1) (hterminal : νt {false} = ENNReal.ofReal (1 - p))
    (hpositive : G.law νs νt (G.atom x ξ) ≠ 0) :
    G.law νs νt (G.miss indices x ∩ G.atom x ξ) /
        G.law νs νt (G.atom x ξ) ≤
      ENNReal.ofReal (sharpCount q m r) *
        ENNReal.ofReal (1 - p / 2) ^ (m * r) := by
  apply (ENNReal.div_le_iff hpositive (measure_ne_top _ _)).2
  exact (measure_mono
      (G.miss_subset_local A hq0 hq1 x ξ hstable hfirst indices hindices)).trans
    (G.local_all_scales_mass hq0 hq1 x ξ νs νt hfalse htrue p hp1 hterminal)

def manuscriptCount (q : ℝ) (m r : ℕ) : ℝ :=
  4 + 2 * (m * r : ℕ) * (1 + 2 * gridFactor q / q ^ (2 * r))

lemma power_le_exp (p : ℝ) (hp1 : p ≤ 1) (k : ℕ) :
    ENNReal.ofReal (1 - p / 2) ^ k ≤
      ENNReal.ofReal (Real.exp (-p * k / 2)) := by
  have hp : 0 ≤ 1 - p / 2 := by linarith
  have hpow := pow_le_pow_left₀ hp (Real.one_sub_le_exp_neg (p / 2)) k
  have heq : Real.exp (-(p / 2)) ^ k = Real.exp (-p * k / 2) := by
    rw [← Real.exp_nat_mul]
    congr 1
    ring
  rw [heq] at hpow
  simpa only [ENNReal.ofReal_pow hp] using ENNReal.ofReal_le_ofReal hpow

theorem conditional_scales_sharp (G : LocalWindows q m d r U)
    (A : Predecessors G) (hq0 : 0 < q) (hq1 : q < 1) (x : ℝ)
    (ξ : Node m d × Fin m → Bool) (hstable : A.Stable x)
    (hfirst : G.firstDefaultOnAtom x ξ)
    (indices : Finset ℕ) (hindices : ∀ j : G.Trial, G.index j ∈ indices)
    (νs νt : Measure Bool) [IsProbabilityMeasure νs] [IsProbabilityMeasure νt]
    (hfalse : νs {false} = 1 / 2) (htrue : νs {true} = 1 / 2)
    (p : ℝ) (hp1 : p < 1)
    (hterminal : νt {false} = ENNReal.ofReal (1 - p))
    (hpositive : G.law νs νt (G.atom x ξ) ≠ 0) :
    G.law νs νt (G.miss indices x ∩ G.atom x ξ) /
        G.law νs νt (G.atom x ξ) ≤
      ENNReal.ofReal (sharpCount q m r * Real.exp (-p * (m * r : ℕ) / 2)) := by
  have hnonneg : 0 ≤ sharpCount q m r := by
    have hc := gridFactor_pos hq1
    unfold sharpCount
    positivity
  calc
    G.law νs νt (G.miss indices x ∩ G.atom x ξ) /
        G.law νs νt (G.atom x ξ) ≤
        ENNReal.ofReal (sharpCount q m r) * ENNReal.ofReal (1 - p / 2) ^ (m * r) :=
      G.conditional_geometric_power A hq0 hq1 x ξ hstable hfirst indices hindices
        νs νt hfalse htrue p hp1.le hterminal hpositive
    _ ≤ ENNReal.ofReal (sharpCount q m r) *
        ENNReal.ofReal (Real.exp (-p * (m * r : ℕ) / 2)) :=
      mul_le_mul_left' (power_le_exp p hp1.le (m * r)) _
    _ = _ := (ENNReal.ofReal_mul hnonneg).symm

theorem conditional_scales (G : LocalWindows q m d r U)
    (A : Predecessors G) (hq0 : 0 < q) (hq1 : q < 1) (x : ℝ)
    (ξ : Node m d × Fin m → Bool) (hstable : A.Stable x)
    (hfirst : G.firstDefaultOnAtom x ξ)
    (indices : Finset ℕ) (hindices : ∀ j : G.Trial, G.index j ∈ indices)
    (νs νt : Measure Bool) [IsProbabilityMeasure νs] [IsProbabilityMeasure νt]
    (hfalse : νs {false} = 1 / 2) (htrue : νs {true} = 1 / 2)
    (p : ℝ) (hp0 : 0 < p) (hp1 : p < 1)
    (hterminal : νt {false} = ENNReal.ofReal (1 - p))
    (hpositive : G.law νs νt (G.atom x ξ) ≠ 0) :
    G.law νs νt (G.miss indices x ∩ G.atom x ξ) /
        G.law νs νt (G.atom x ξ) ≤
      ENNReal.ofReal (manuscriptCount q m r * Real.exp (-p * (m * r : ℕ) / 2)) := by
  have hcount : sharpCount q m r ≤ manuscriptCount q m r := by
    have hc := gridFactor_pos hq1
    have hprod : 0 ≤ (m * r : ℝ) * (1 + 2 * gridFactor q / q ^ (2 * r)) := by
      positivity
    dsimp [sharpCount, manuscriptCount]
    push_cast
    nlinarith
  have hnonneg : 0 ≤ manuscriptCount q m r := by
    have hc := gridFactor_pos hq1
    unfold manuscriptCount
    positivity
  calc
    G.law νs νt (G.miss indices x ∩ G.atom x ξ) /
        G.law νs νt (G.atom x ξ) ≤
        ENNReal.ofReal (sharpCount q m r) * ENNReal.ofReal (1 - p / 2) ^ (m * r) :=
      G.conditional_geometric_power A hq0 hq1 x ξ hstable hfirst indices hindices
        νs νt hfalse htrue p hp1.le hterminal hpositive
    _ ≤ ENNReal.ofReal (manuscriptCount q m r) *
        ENNReal.ofReal (1 - p / 2) ^ (m * r) :=
      mul_le_mul_right' (ENNReal.ofReal_le_ofReal hcount) _
    _ ≤ ENNReal.ofReal (manuscriptCount q m r) *
        ENNReal.ofReal (Real.exp (-p * (m * r : ℕ) / 2)) :=
      mul_le_mul_left' (power_le_exp p hp1.le (m * r)) _
    _ = _ := (ENNReal.ofReal_mul hnonneg).symm

end LocalWindows

#print axioms LocalWindows.conditional_scales
#print axioms LocalWindows.conditional_scales_sharp

end GeometricBridge
