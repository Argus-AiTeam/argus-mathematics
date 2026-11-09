import Mathlib

set_option maxRecDepth 2048
set_option maxHeartbeats 800000
set_option linter.unusedSectionVars false

noncomputable section

open Finset

namespace LabelCore

variable {V : Type*} [Fintype V] [DecidableEq V] [Nonempty V]

attribute [local instance] Classical.propDecidable

abbrev Vec (V : Type*) := V → ℤ
abbrev Mass (V : Type*) := V → ℚ
abbrev Labels (V : Type*) := V → Bool

def total (m : Mass V) (S : Finset V) : ℚ := ∑ i ∈ S, m i

theorem total_mono {m : Mass V} (hm : ∀ i, 0 ≤ m i)
    {S T : Finset V} (h : S ⊆ T) : total m S ≤ total m T := by
  unfold total
  exact Finset.sum_le_sum_of_subset_of_nonneg h (by intro i _ _; exact hm i)

def vmax (v : Vec V) : ℤ := univ.sup' univ_nonempty v

theorem le_vmax (v : Vec V) (i : V) : v i ≤ vmax v :=
  Finset.le_sup' (s := univ) (f := v) (mem_univ i)

theorem vmax_le (v : Vec V) (t : ℤ) (h : ∀ i, v i ≤ t) : vmax v ≤ t := by
  exact Finset.sup'_le univ_nonempty v (by simpa using h)

theorem vmax_attained (v : Vec V) : ∃ i, v i = vmax v := by
  obtain ⟨i, _, hi⟩ := Finset.exists_max_image univ v univ_nonempty
  exact ⟨i, le_antisymm (le_vmax v i) (vmax_le v (v i) (by simpa using hi))⟩

def InBox (A : Vec V) (D : ℤ) (x : Vec V) : Prop :=
  ∀ i, A i ≤ x i ∧ x i ≤ A i + D

def Sub (F : Vec V → Vec V) (A : Vec V) (D : ℤ) (x : Vec V) : Prop :=
  InBox A D x ∧ ∀ i, A i < x i → x i ≤ F x i

def Super (F : Vec V → Vec V) (A : Vec V) (D : ℤ) (y : Vec V) : Prop :=
  InBox A D y ∧ ∀ i, y i < A i + D → F y i ≤ y i

def suppMax (A x : Vec V) : Finset V := univ.filter fun i => A i < x i
def suppMin (A : Vec V) (D : ℤ) (y : Vec V) : Finset V :=
  univ.filter fun i => y i < A i + D

def claimMax (A : Vec V) (D : ℤ) (x : Vec V) (i : V) : Prop :=
  32 * (A i + D) - D ≤ 32 * x i

def claimMin (A : Vec V) (D : ℤ) (y : Vec V) (i : V) : Prop :=
  32 * y i ≤ 32 * A i + D

def MaxWitness (F : Vec V → Vec V) (A : Vec V) (D : ℤ)
    (a : Mass V) (x : Vec V) : Prop :=
  Sub F A D x ∧ total a (suppMax A x) ≤ 1

def MinWitness (F : Vec V → Vec V) (A : Vec V) (D : ℤ)
    (b : Mass V) (y : Vec V) : Prop :=
  Super F A D y ∧ total b (suppMin A D y) ≤ 1

def Good (F : Vec V → Vec V) (A : Vec V) (D : ℤ)
    (a b : Mass V) (l : Labels V) : Prop :=
  (∀ x, MaxWitness F A D a x → ∀ i, claimMax A D x i → l i = true) ∧
  (∀ y, MinWitness F A D b y → ∀ i, claimMin A D y i → l i = false)

structure BoxInterface (V : Type*) where
  F : Vec V → Vec V
  mono : ∀ {x y}, (∀ i, x i ≤ y i) → ∀ i, F x i ≤ F y i
  shift : ∀ (x : Vec V) (t : ℤ) i, F (fun j => x j + t) i = F x i + t
  basic : Vec V → ℕ → Vec V
  basic_sub : ∀ A d, Sub F A ((2 : ℤ) ^ d) (basic A d)
  basic_super : ∀ A d, Super F A ((2 : ℤ) ^ d) (basic A d)
  compare : ∀ A D x y, Sub F A D x → Super F A D y → ∀ i, x i ≤ y i

structure Input (V : Type*) where
  A : Vec V
  d : ℕ
  a : Mass V
  b : Mass V
  apos : ∀ i, 0 < a i
  bpos : ∀ i, 0 < b i

def width (s : Input V) : ℤ := (2 : ℤ) ^ s.d
def unit (s : Input V) : ℤ := (2 : ℤ) ^ (s.d - 12)

theorem width_pos (s : Input V) : 0 < width s := by
  exact pow_pos (by norm_num) _

theorem unit_pos (s : Input V) : 0 < unit s := by
  exact pow_pos (by norm_num) _

theorem width_split (s : Input V) (h : 12 ≤ s.d) :
    width s = 4096 * unit s := by
  unfold width unit
  have hd : s.d = 12 + (s.d - 12) := by omega
  rw [hd, pow_add]
  norm_num

def rho : ℚ := 32 / 25

theorem budget_exists (t : ℚ) (ht : 0 < t) : ∃ n : ℕ, 1 < t * rho ^ n := by
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt (1 / t) (show (1 : ℚ) < rho by norm_num [rho])
  refine ⟨n, ?_⟩
  have := (div_lt_iff₀ ht).mp hn
  nlinarith

def budget (t : ℚ) (ht : 0 < t) : ℕ := Nat.find (budget_exists t ht)

theorem budget_spec (t : ℚ) (ht : 0 < t) : 1 < t * rho ^ budget t ht :=
  Nat.find_spec (budget_exists t ht)

theorem budget_zero_iff (t : ℚ) (ht : 0 < t) : budget t ht = 0 ↔ 1 < t := by
  constructor
  · intro h
    simpa [h] using budget_spec t ht
  · intro h
    apply Nat.le_zero.mp
    exact Nat.find_min' (budget_exists t ht) (by simpa using h)

theorem budget_decreases (t t' : ℚ) (ht : 0 < t) (ht' : 0 < t')
    (hbase : t ≤ 1) (hgrow : rho * t ≤ t') :
    budget t' ht' < budget t ht := by
  have hn : budget t ht ≠ 0 := by
    intro hz
    have := (budget_zero_iff t ht).mp hz
    linarith
  obtain ⟨n, hn⟩ := Nat.exists_eq_succ_of_ne_zero hn
  have hs := budget_spec t ht
  rw [hn, pow_succ] at hs
  have hp : 0 ≤ rho ^ n := pow_nonneg (by norm_num [rho]) _
  have hg := mul_le_mul_of_nonneg_right hgrow hp
  have hs' : 1 < t' * rho ^ n := by nlinarith
  have hf : budget t' ht' ≤ n := Nat.find_min' (budget_exists t' ht') hs'
  omega

def mu (s : Input V) : ℚ :=
  univ.inf' univ_nonempty (fun i => s.a i * s.b i)

theorem mu_le (s : Input V) (i : V) : mu s ≤ s.a i * s.b i :=
  Finset.inf'_le (f := fun i => s.a i * s.b i) (mem_univ i)

theorem mu_attained (s : Input V) : ∃ i, s.a i * s.b i = mu s := by
  obtain ⟨i, _, hi⟩ :=
    Finset.exists_min_image univ (fun i => s.a i * s.b i) univ_nonempty
  refine ⟨i, le_antisymm ?_ (mu_le s i)⟩
  exact Finset.le_inf' univ_nonempty _ (by simpa using hi)

theorem mu_pos (s : Input V) : 0 < mu s := by
  obtain ⟨i, hi⟩ := mu_attained s
  rw [← hi]
  exact mul_pos (s.apos i) (s.bpos i)

def massBudget (s : Input V) : ℕ := budget (mu s) (mu_pos s)
def rank (s : Input V) : ℕ := s.d + massBudget s

def massBase (s : Input V) : Prop := ∀ i, 1 < s.a i * s.b i

theorem not_massBase_mu (s : Input V) (h : ¬ massBase s) : mu s ≤ 1 := by
  by_contra hn
  apply h
  intro i
  exact lt_of_lt_of_le (lt_of_not_ge hn) (mu_le s i)

theorem rank_decreases_mass (s t : Input V) (hn : ¬ massBase s)
    (hd : t.d ≤ s.d) (hg : ∀ i, rho * (s.a i * s.b i) ≤ t.a i * t.b i) :
    rank t < rank s := by
  have hm : rho * mu s ≤ mu t := by
    apply Finset.le_inf' univ_nonempty
    intro i _
    exact le_trans (mul_le_mul_of_nonneg_left (mu_le s i) (by norm_num [rho])) (hg i)
  have hb := budget_decreases (mu s) (mu t) (mu_pos s) (mu_pos t)
    (not_massBase_mu s hn) hm
  unfold rank massBudget
  omega

def LowerPivot (lo : Vec V) := {k : Vec V // ∀ i, lo i ≤ k i}

def fallStep (lo : Vec V) (p : ℤ) (fire : Vec V → Labels V)
    (k : LowerPivot lo) : LowerPivot lo :=
  ⟨fun i => if fire k.val i then max (lo i) (k.val i - p) else k.val i,
   by intro i; dsimp; split_ifs; exact le_max_left _ _; exact k.property i⟩

def distance (lo : Vec V) (k : LowerPivot lo) : ℕ :=
  (∑ i, (k.val i - lo i)).toNat

theorem fallStep_le (lo : Vec V) (p : ℤ) (hp : 0 < p)
    (fire : Vec V → Labels V) (k : LowerPivot lo) (i : V) :
    (fallStep lo p fire k).val i ≤ k.val i := by
  dsimp [fallStep]
  split_ifs
  · exact max_le (k.property i) (by omega)
  · rfl

theorem fallStep_distance (lo : Vec V) (p : ℤ) (hp : 0 < p)
    (fire : Vec V → Labels V) (k : LowerPivot lo)
    (hne : fallStep lo p fire k ≠ k) :
    distance lo (fallStep lo p fire k) < distance lo k := by
  have he : ∃ i, (fallStep lo p fire k).val i < k.val i := by
    by_contra hn
    push Not at hn
    apply hne
    apply Subtype.ext
    funext i
    exact le_antisymm (fallStep_le lo p hp fire k i) (hn i)
  obtain ⟨i, hi⟩ := he
  have hs : (∑ j, ((fallStep lo p fire k).val j - lo j)) <
      ∑ j, (k.val j - lo j) := by
    apply Finset.sum_lt_sum
    · intro j _
      exact sub_le_sub_right (fallStep_le lo p hp fire k j) _
    · exact ⟨i, mem_univ i, sub_lt_sub_right hi _⟩
  have hz : (0 : ℤ) ≤ ∑ j, ((fallStep lo p fire k).val j - lo j) :=
    Finset.sum_nonneg (by intro j _; exact sub_nonneg.mpr ((fallStep lo p fire k).property j))
  unfold distance
  omega

def fall {V : Type*} [Fintype V] [DecidableEq V] [Nonempty V]
    (lo : Vec V) (p : ℤ) (hp : 0 < p)
    (fire : Vec V → Labels V)
    (k : LowerPivot lo) : LowerPivot lo :=
  if h : fallStep lo p fire k = k then k
  else fall lo p hp fire (fallStep lo p fire k)
termination_by distance lo k
decreasing_by exact fallStep_distance lo p hp fire k h

theorem fall_spec (lo : Vec V) (p : ℤ) (hp : 0 < p)
    (fire : Vec V → Labels V) (P : Vec V → Prop)
    (hstep : ∀ k : LowerPivot lo, P k.val → P (fallStep lo p fire k).val)
    (k : LowerPivot lo) (hk : P k.val) :
    P (fall lo p hp fire k).val ∧
      fallStep lo p fire (fall lo p hp fire k) = fall lo p hp fire k ∧
      ∀ i, (fall lo p hp fire k).val i ≤ k.val i := by
  have aux : ∀ n (k : LowerPivot lo), distance lo k = n → P k.val →
      P (fall lo p hp fire k).val ∧
      fallStep lo p fire (fall lo p hp fire k) = fall lo p hp fire k ∧
      ∀ i, (fall lo p hp fire k).val i ≤ k.val i := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
      intro k he hk
      rw [fall]
      split_ifs with hs
      · exact ⟨hk, hs, fun _ => le_rfl⟩
      · obtain ⟨hP, hstop, hle⟩ :=
          ih (distance lo (fallStep lo p fire k))
            (by simpa [← he] using fallStep_distance lo p hp fire k hs)
            (fallStep lo p fire k) rfl (hstep k hk)
        exact ⟨hP, hstop, fun i => le_trans (hle i) (fallStep_le lo p hp fire k i)⟩
  exact aux (distance lo k) k rfl hk

def peakMax (x k : Vec V) : ℤ := vmax fun i => x i - k i
def peakMin (y k : Vec V) : ℤ := vmax fun i => k i - y i
def gapMax (x k : Vec V) (i : V) : ℤ := peakMax x k - (x i - k i)
def gapMin (y k : Vec V) (i : V) : ℤ := peakMin y k - (k i - y i)

theorem gapMax_nonneg (x k : Vec V) (i : V) : 0 ≤ gapMax x k i := by
  have := le_vmax (fun j => x j - k j) i
  unfold gapMax peakMax
  omega

theorem gapMin_nonneg (y k : Vec V) (i : V) : 0 ≤ gapMin y k i := by
  have := le_vmax (fun j => k j - y j) i
  unfold gapMin peakMin
  omega

theorem peakMax_attained (x k : Vec V) : ∃ i, gapMax x k i = 0 := by
  obtain ⟨i, hi⟩ := vmax_attained (fun j => x j - k j)
  exact ⟨i, by dsimp [gapMax, peakMax]; omega⟩

theorem peakMin_attained (y k : Vec V) : ∃ i, gapMin y k i = 0 := by
  obtain ⟨i, hi⟩ := vmax_attained (fun j => k j - y j)
  exact ⟨i, by dsimp [gapMin, peakMin]; omega⟩

def translateMax (k : Vec V) (H : ℤ) (x : Vec V) : Vec V :=
  fun i => max (k i - H) (x i - peakMax x k + H)

def translateMin (k : Vec V) (H : ℤ) (y : Vec V) : Vec V :=
  fun i => min (k i + H) (y i + peakMin y k - H)

theorem translateMax_support (x k : Vec V) (H : ℤ) :
    suppMax (fun i => k i - H) (translateMax k H x) =
      univ.filter (fun i => gapMax x k i < 2 * H) := by
  ext i
  simp only [suppMax, mem_filter, mem_univ, true_and]
  dsimp [translateMax, gapMax]
  omega

theorem translateMin_support (y k : Vec V) (H : ℤ) :
    suppMin (fun i => k i - H) (2 * H) (translateMin k H y) =
      univ.filter (fun i => gapMin y k i < 2 * H) := by
  ext i
  simp only [suppMin, mem_filter, mem_univ, true_and]
  dsimp [translateMin, gapMin]
  omega

theorem translateMax_subset (A x k : Vec V) (D H : ℤ)
    (hx : InBox A D x)
    (hsep : ∀ i, x i = A i → 2 * H ≤ gapMax x k i) :
    suppMax (fun i => k i - H) (translateMax k H x) ⊆ suppMax A x := by
  intro i hi
  rw [translateMax_support] at hi
  simp only [mem_filter, mem_univ, true_and] at hi
  simp only [suppMax, mem_filter, mem_univ, true_and]
  have hb := (hx i).1
  by_contra hn
  have he : x i = A i := by omega
  have := hsep i he
  omega

theorem translateMin_subset (A y k : Vec V) (D H : ℤ)
    (hy : InBox A D y)
    (hsep : ∀ i, y i = A i + D → 2 * H ≤ gapMin y k i) :
    suppMin (fun i => k i - H) (2 * H) (translateMin k H y) ⊆ suppMin A D y := by
  intro i hi
  rw [translateMin_support] at hi
  simp only [mem_filter, mem_univ, true_and] at hi
  simp only [suppMin, mem_filter, mem_univ, true_and]
  have hb := (hy i).2
  by_contra hn
  have he : y i = A i + D := by omega
  have := hsep i he
  omega

theorem translateMax_sub (O : BoxInterface V) (A x k : Vec V) (D H : ℤ)
    (hH : 0 < H) (hx : Sub O.F A D x)
    (hsep : ∀ i, x i = A i → 2 * H ≤ gapMax x k i) :
    Sub O.F (fun i => k i - H) (2 * H) (translateMax k H x) := by
  constructor
  · intro i
    have hv := le_vmax (fun j => x j - k j) i
    dsimp [translateMax, peakMax]
    constructor
    · exact le_max_left _ _
    · apply max_le <;> omega
  · intro i hi
    have hm : i ∈ suppMax (fun j => k j - H) (translateMax k H x) := by
      simpa [suppMax] using hi
    have hs := translateMax_subset A x k D H hx.1 hsep hm
    have hp : A i < x i := by simpa [suppMax] using hs
    have hc := hx.2 i hp
    have hv : ∀ j, x j + (-peakMax x k + H) ≤ translateMax k H x j := by
      intro j
      dsimp [translateMax]
      have := le_max_right (k j - H) (x j - peakMax x k + H)
      omega
    have hf := O.mono hv i
    rw [O.shift] at hf
    dsimp [translateMax] at hi ⊢
    omega

theorem translateMin_super (O : BoxInterface V) (A y k : Vec V) (D H : ℤ)
    (hH : 0 < H) (hy : Super O.F A D y)
    (hsep : ∀ i, y i = A i + D → 2 * H ≤ gapMin y k i) :
    Super O.F (fun i => k i - H) (2 * H) (translateMin k H y) := by
  constructor
  · intro i
    have hv := le_vmax (fun j => k j - y j) i
    dsimp [translateMin, peakMin]
    constructor
    · apply le_min <;> omega
    · have := min_le_left (k i + H) (y i + vmax (fun j => k j - y j) - H)
      omega
  · intro i hi
    have hm : i ∈ suppMin (fun j => k j - H) (2 * H) (translateMin k H y) := by
      simpa [suppMin] using hi
    have hs := translateMin_subset A y k D H hy.1 hsep hm
    have hp : y i < A i + D := by simpa [suppMin] using hs
    have hc := hy.2 i hp
    have hv : ∀ j, translateMin k H y j ≤ y j + (peakMin y k - H) := by
      intro j
      dsimp [translateMin]
      have := min_le_right (k j + H) (y j + peakMin y k - H)
      omega
    have hf := O.mono hv i
    rw [O.shift] at hf
    dsimp [translateMin] at hi ⊢
    omega

theorem translateMax_claim (x k : Vec V) (H : ℤ) (i : V)
    (h : 32 * gapMax x k i ≤ 2 * H) :
    claimMax (fun j => k j - H) (2 * H) (translateMax k H x) i := by
  dsimp [claimMax, translateMax, gapMax] at *
  omega

theorem translateMin_claim (y k : Vec V) (H : ℤ) (i : V)
    (h : 32 * gapMin y k i ≤ 2 * H) :
    claimMin (fun j => k j - H) (2 * H) (translateMin k H y) i := by
  dsimp [claimMin, translateMin, gapMin] at *
  omega

def PivotBounds (A : Vec V) (h : ℤ) (k : Vec V) : Prop :=
  ∀ i, A i + 1536 * h ≤ k i ∧ k i ≤ A i + 2560 * h

theorem relevantMax_separation (A x k : Vec V) (h : ℤ) (hh : 0 < h)
    (hx : InBox A (4096 * h) x) (hk : PivotBounds A h k)
    (hr : ∃ j, claimMax A (4096 * h) x j) :
    ∀ i, x i = A i → 2048 * h < gapMax x k i := by
  obtain ⟨j, hj⟩ := hr
  have hp := le_vmax (fun j => x j - k j) j
  have hkj := (hk j).2
  dsimp [claimMax] at hj
  intro i hi
  have hki := (hk i).1
  dsimp [gapMax, peakMax]
  omega

theorem relevantMin_separation (A y k : Vec V) (h : ℤ) (hh : 0 < h)
    (hy : InBox A (4096 * h) y) (hk : PivotBounds A h k)
    (hr : ∃ j, claimMin A (4096 * h) y j) :
    ∀ i, y i = A i + 4096 * h → 2048 * h < gapMin y k i := by
  obtain ⟨j, hj⟩ := hr
  have hp := le_vmax (fun j => k j - y j) j
  have hkj := (hk j).1
  dsimp [claimMin] at hj
  intro i hi
  have hki := (hk i).2
  dsimp [gapMin, peakMin]
  omega

theorem translateMax_witness (O : BoxInterface V) (A x k : Vec V)
    (a : Mass V) (ha : ∀ i, 0 < a i) (h H : ℤ) (hh : 0 < h)
    (hH : 0 < H) (hHle : H ≤ 1024 * h)
    (hx : MaxWitness O.F A (4096 * h) a x) (hk : PivotBounds A h k)
    (hr : ∃ j, claimMax A (4096 * h) x j) :
    MaxWitness O.F (fun i => k i - H) (2 * H) a (translateMax k H x) := by
  have hsep : ∀ i, x i = A i → 2 * H ≤ gapMax x k i := by
    intro i hi
    have := relevantMax_separation A x k h hh hx.1.1 hk hr i hi
    omega
  exact ⟨translateMax_sub O A x k (4096 * h) H hH hx.1 hsep,
    le_trans (total_mono (fun i => (ha i).le)
      (translateMax_subset A x k (4096 * h) H hx.1.1 hsep)) hx.2⟩

theorem translateMin_witness (O : BoxInterface V) (A y k : Vec V)
    (b : Mass V) (hb : ∀ i, 0 < b i) (h H : ℤ) (hh : 0 < h)
    (hH : 0 < H) (hHle : H ≤ 1024 * h)
    (hy : MinWitness O.F A (4096 * h) b y) (hk : PivotBounds A h k)
    (hr : ∃ j, claimMin A (4096 * h) y j) :
    MinWitness O.F (fun i => k i - H) (2 * H) b (translateMin k H y) := by
  have hsep : ∀ i, y i = A i + 4096 * h → 2 * H ≤ gapMin y k i := by
    intro i hi
    have := relevantMin_separation A y k h hh hy.1.1 hk hr i hi
    omega
  exact ⟨translateMin_super O A y k (4096 * h) H hH hy.1 hsep,
    le_trans (total_mono (fun i => (hb i).le)
      (translateMin_subset A y k (4096 * h) H hy.1.1 hsep)) hy.2⟩

def massLabels (s : Input V) : Labels V := fun i => if 1 < s.b i then true else false
def basicLabels (O : BoxInterface V) (s : Input V) : Labels V :=
  fun i => if 2 * s.A i + width s < 2 * O.basic s.A s.d i then true else false

theorem mass_base_good (O : BoxInterface V) (s : Input V) (hb : massBase s) :
    Good O.F s.A (width s) s.a s.b (massLabels s) := by
  have hd := width_pos s
  constructor
  · intro x hx i hi
    have hmem : i ∈ suppMax s.A x := by
      simp only [suppMax, mem_filter, mem_univ, true_and]
      dsimp [claimMax] at hi
      omega
    have ha : s.a i ≤ total s.a (suppMax s.A x) :=
      Finset.single_le_sum (by intro j _; exact (s.apos j).le) hmem
    have hab := hb i
    have hap := s.apos i
    have hbp := s.bpos i
    have hbi : 1 < s.b i := by nlinarith [hx.2]
    simp [massLabels, hbi]
  · intro y hy i hi
    have hmem : i ∈ suppMin s.A (width s) y := by
      simp only [suppMin, mem_filter, mem_univ, true_and]
      dsimp [claimMin] at hi
      omega
    have hb' : s.b i ≤ total s.b (suppMin s.A (width s) y) :=
      Finset.single_le_sum (by intro j _; exact (s.bpos j).le) hmem
    have hbi : ¬ 1 < s.b i := by linarith [hy.2]
    simp [massLabels, hbi]

theorem basic_good (O : BoxInterface V) (s : Input V) :
    Good O.F s.A (width s) s.a s.b (basicLabels O s) := by
  have hd := width_pos s
  constructor
  · intro x hx i hi
    have hz := O.compare s.A (width s) x (O.basic s.A s.d)
      hx.1 (O.basic_super s.A s.d) i
    have hc : 2 * s.A i + width s < 2 * O.basic s.A s.d i := by
      dsimp [claimMax] at hi
      omega
    simp [basicLabels, hc]
  · intro y hy i hi
    have hz := O.compare s.A (width s) (O.basic s.A s.d) y
      (O.basic_sub s.A s.d) hy.1 i
    have hc : ¬ 2 * s.A i + width s < 2 * O.basic s.A s.d i := by
      dsimp [claimMin] at hi
      omega
    simp [basicLabels, hc]

def UpperPivot (hi : Vec V) := {k : Vec V // ∀ i, k i ≤ hi i}

def riseStep (hi : Vec V) (p : ℤ) (fire : Vec V → Labels V)
    (k : UpperPivot hi) : UpperPivot hi :=
  ⟨fun i => if fire k.val i then min (hi i) (k.val i + p) else k.val i,
   by intro i; dsimp; split_ifs; exact min_le_left _ _; exact k.property i⟩

def upDistance (hi : Vec V) (k : UpperPivot hi) : ℕ :=
  (∑ i, (hi i - k.val i)).toNat

theorem le_riseStep (hi : Vec V) (p : ℤ) (hp : 0 < p)
    (fire : Vec V → Labels V) (k : UpperPivot hi) (i : V) :
    k.val i ≤ (riseStep hi p fire k).val i := by
  dsimp [riseStep]
  split_ifs
  · exact le_min (k.property i) (by omega)
  · rfl

theorem riseStep_distance (hi : Vec V) (p : ℤ) (hp : 0 < p)
    (fire : Vec V → Labels V) (k : UpperPivot hi)
    (hne : riseStep hi p fire k ≠ k) :
    upDistance hi (riseStep hi p fire k) < upDistance hi k := by
  have he : ∃ i, k.val i < (riseStep hi p fire k).val i := by
    by_contra hn
    push Not at hn
    apply hne
    apply Subtype.ext
    funext i
    exact le_antisymm (hn i) (le_riseStep hi p hp fire k i)
  obtain ⟨i, hi'⟩ := he
  have hs : (∑ j, (hi j - (riseStep hi p fire k).val j)) <
      ∑ j, (hi j - k.val j) := by
    apply Finset.sum_lt_sum
    · intro j _
      exact sub_le_sub_left (le_riseStep hi p hp fire k j) _
    · exact ⟨i, mem_univ i, sub_lt_sub_left hi' _⟩
  have hz : (0 : ℤ) ≤ ∑ j, (hi j - (riseStep hi p fire k).val j) :=
    Finset.sum_nonneg (by intro j _; exact sub_nonneg.mpr ((riseStep hi p fire k).property j))
  unfold upDistance
  omega

def rise {V : Type*} [Fintype V] [DecidableEq V] [Nonempty V]
    (hi : Vec V) (p : ℤ) (hp : 0 < p) (fire : Vec V → Labels V)
    (k : UpperPivot hi) : UpperPivot hi :=
  if h : riseStep hi p fire k = k then k
  else rise hi p hp fire (riseStep hi p fire k)
termination_by upDistance hi k
decreasing_by exact riseStep_distance hi p hp fire k h

theorem rise_spec (hi : Vec V) (p : ℤ) (hp : 0 < p)
    (fire : Vec V → Labels V) (P : Vec V → Prop)
    (hstep : ∀ k : UpperPivot hi, P k.val → P (riseStep hi p fire k).val)
    (k : UpperPivot hi) (hk : P k.val) :
    P (rise hi p hp fire k).val ∧
      riseStep hi p fire (rise hi p hp fire k) = rise hi p hp fire k ∧
      ∀ i, k.val i ≤ (rise hi p hp fire k).val i := by
  have aux : ∀ n (k : UpperPivot hi), upDistance hi k = n → P k.val →
      P (rise hi p hp fire k).val ∧
      riseStep hi p fire (rise hi p hp fire k) = rise hi p hp fire k ∧
      ∀ i, k.val i ≤ (rise hi p hp fire k).val i := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
      intro k he hk
      rw [rise]
      split_ifs with hs
      · exact ⟨hk, hs, fun _ => le_rfl⟩
      · obtain ⟨hP, hstop, hle⟩ :=
          ih (upDistance hi (riseStep hi p fire k))
            (by simpa [← he] using riseStep_distance hi p hp fire k hs)
            (riseStep hi p fire k) rfl (hstep k hk)
        exact ⟨hP, hstop, fun i => le_trans (le_riseStep hi p hp fire k i) (hle i)⟩
  exact aux (upDistance hi k) k rfl hk

theorem peakMax_protected (x k k' : Vec V) (p : ℤ) (hp : 0 ≤ p)
    (hmotion : ∀ i, k i - p ≤ k' i ∧ k' i ≤ k i)
    (hfixed : ∀ i, gapMax x k i ≤ p → k' i = k i) :
    peakMax x k' = peakMax x k := by
  apply le_antisymm
  · apply vmax_le
    intro i
    by_cases h : gapMax x k i ≤ p
    · rw [hfixed i h]
      exact le_vmax _ i
    · have hmove := (hmotion i).1
      dsimp [gapMax] at h
      omega
  · obtain ⟨i, hi⟩ := peakMax_attained x k
    have hf := hfixed i (by omega)
    have hv := le_vmax (fun j => x j - k' j) i
    dsimp [gapMax] at hi
    dsimp [peakMax] at *
    omega

theorem peakMin_protected (y k k' : Vec V) (p : ℤ) (hp : 0 ≤ p)
    (hmotion : ∀ i, k i ≤ k' i ∧ k' i ≤ k i + p)
    (hfixed : ∀ i, gapMin y k i ≤ p → k' i = k i) :
    peakMin y k' = peakMin y k := by
  apply le_antisymm
  · apply vmax_le
    intro i
    by_cases h : gapMin y k i ≤ p
    · rw [hfixed i h]
      exact le_vmax _ i
    · have hmove := (hmotion i).2
      dsimp [gapMin] at h
      omega
  · obtain ⟨i, hi⟩ := peakMin_attained y k
    have hf := hfixed i (by omega)
    have hv := le_vmax (fun j => k' j - y j) i
    dsimp [gapMin] at hi
    dsimp [peakMin] at *
    omega

theorem down_step_peak (O : BoxInterface V) (A x : Vec V) (a b : Mass V)
    (ha : ∀ i, 0 < a i) (h : ℤ) (hh : 0 < h)
    (hx : MaxWitness O.F A (4096 * h) a x)
    (hr : ∃ j, claimMax A (4096 * h) x j)
    (k : LowerPivot (fun i => A i + 1536 * h))
    (hk : PivotBounds A h k.val) (l : Labels V)
    (hl : Good O.F (fun i => k.val i - 16 * h) (32 * h)
      a (fun i => (4 / 3 : ℚ) * b i) l) :
    peakMax x (fallStep (fun i => A i + 1536 * h) h
      (fun _ i => !(l i)) k).val = peakMax x k.val := by
  apply peakMax_protected x k.val _ h hh.le
  · intro i
    constructor
    · dsimp [fallStep]
      split_ifs
      · exact le_max_right _ _
      · omega
    · exact fallStep_le _ h hh _ k i
  · intro i hi
    have hw := translateMax_witness O A x k.val a ha h (16 * h) hh
      (by omega) (by omega) hx hk hr
    have hc := translateMax_claim x k.val (16 * h) i (by omega)
    have ht : l i = true := hl.1 (translateMax k.val (16 * h) x) (by convert hw using 1 <;> ring) i
      (by convert hc using 1 <;> ring)
    simp [fallStep, ht]

theorem up_step_peak (O : BoxInterface V) (A y : Vec V) (a b : Mass V)
    (hb : ∀ i, 0 < b i) (h : ℤ) (hh : 0 < h)
    (hy : MinWitness O.F A (4096 * h) b y)
    (hr : ∃ j, claimMin A (4096 * h) y j)
    (k : UpperPivot (fun i => A i + 2560 * h))
    (hk : PivotBounds A h k.val) (l : Labels V)
    (hl : Good O.F (fun i => k.val i - 16 * h) (32 * h)
      (fun i => (4 / 3 : ℚ) * a i) b l) :
    peakMin y (riseStep (fun i => A i + 2560 * h) h (fun _ => l) k).val =
      peakMin y k.val := by
  apply peakMin_protected y k.val _ h hh.le
  · intro i
    constructor
    · exact le_riseStep _ h hh _ k i
    · dsimp [riseStep]
      split_ifs
      · exact min_le_right _ _
      · omega
  · intro i hi
    have hw := translateMin_witness O A y k.val b hb h (16 * h) hh
      (by omega) (by omega) hy hk hr
    have hc := translateMin_claim y k.val (16 * h) i (by omega)
    have ht : l i = false := hl.2 (translateMin k.val (16 * h) y) (by convert hw using 1 <;> ring) i
      (by convert hc using 1 <;> ring)
    simp [riseStep, ht]

theorem total_scale (m : Mass V) (S : Finset V) (c : ℚ) :
    total (fun i => c * m i) S = c * total m S := by
  simp [total, Finset.mul_sum]

def nearMax (x k : Vec V) (h : ℤ) : Finset V :=
  univ.filter (fun i => gapMax x k i < 32 * h)
def nearMin (y k : Vec V) (h : ℤ) : Finset V :=
  univ.filter (fun i => gapMin y k i < 32 * h)

def low (A : Vec V) (h : ℤ) : Vec V := fun i => A i + 1536 * h
def center (A : Vec V) (h : ℤ) : Vec V := fun i => A i + 2048 * h
def high (A : Vec V) (h : ℤ) : Vec V := fun i => A i + 2560 * h

def downRun (A : Vec V) (h : ℤ) (hh : 0 < h) (f : Vec V → Labels V) :
    LowerPivot (low A h) :=
  fall (low A h) h hh (fun k i => !(f k i))
    ⟨center A h, by intro i; dsimp [low, center]; omega⟩

theorem downRun_spec (A : Vec V) (h : ℤ) (hh : 0 < h) (f : Vec V → Labels V) :
    fallStep (low A h) h (fun k i => !(f k i)) (downRun A h hh f) =
      downRun A h hh f ∧
    ∀ i, (downRun A h hh f).val i ≤ center A h i := by
  have hs := fall_spec (low A h) h hh (fun k i => !(f k i))
    (fun _ => True) (by intros; trivial)
    ⟨center A h, by intro i; dsimp [low, center]; omega⟩ trivial
  exact hs.2

theorem downRun_bounds (A : Vec V) (h : ℤ) (hh : 0 < h) (f : Vec V → Labels V) :
    PivotBounds A h (downRun A h hh f).val := by
  intro i
  have hl := (downRun A h hh f).property i
  have hu := (downRun_spec A h hh f).2 i
  dsimp [low, center] at *
  exact ⟨hl, by omega⟩

theorem downRun_peak (O : BoxInterface V) (A x : Vec V) (a b : Mass V)
    (ha : ∀ i, 0 < a i) (h : ℤ) (hh : 0 < h)
    (f : Vec V → Labels V)
    (hf : ∀ k, Good O.F (fun i => k i - 16 * h) (32 * h)
      a (fun i => (4 / 3 : ℚ) * b i) (f k))
    (hx : MaxWitness O.F A (4096 * h) a x)
    (hr : ∃ j, claimMax A (4096 * h) x j) :
    peakMax x (downRun A h hh f).val = peakMax x (center A h) := by
  let P : Vec V → Prop := fun k =>
    (∀ i, k i ≤ center A h i) ∧ peakMax x k = peakMax x (center A h)
  have hs := fall_spec (low A h) h hh (fun k i => !(f k i)) P
    (by
      intro k hk
      have hbounds : PivotBounds A h k.val := by
        intro i
        have hl := k.property i
        have hu := hk.1 i
        dsimp [low, center] at *
        exact ⟨hl, by omega⟩
      have hp := down_step_peak O A x a b ha h hh hx hr k hbounds (f k.val) (hf k.val)
      refine ⟨fun i => le_trans (fallStep_le _ h hh _ k i) (hk.1 i), ?_⟩
      exact hp.trans hk.2)
    ⟨center A h, by intro i; dsimp [low, center]; omega⟩
    ⟨fun _ => le_rfl, rfl⟩
  exact hs.1.2

theorem downRun_safe (O : BoxInterface V) (A x : Vec V) (a b : Mass V)
    (ha : ∀ i, 0 < a i) (h : ℤ) (hh : 0 < h)
    (f : Vec V → Labels V)
    (hf : ∀ k, Good O.F (fun i => k i - 16 * h) (32 * h)
      a (fun i => (4 / 3 : ℚ) * b i) (f k))
    (hx : MaxWitness O.F A (4096 * h) a x)
    (i : V) (hi : claimMax A (4096 * h) x i) :
    A i + 1920 * h ≤ (downRun A h hh f).val i := by
  have he := downRun_peak O A x a b ha h hh f hf hx ⟨i, hi⟩
  have hb : peakMax x (center A h) ≤ 2048 * h := by
    apply vmax_le
    intro j
    have := (hx.1.1 j).2
    dsimp [center]
    omega
  have hv := le_vmax (fun j => x j - (downRun A h hh f).val j) i
  dsimp [claimMax] at hi
  change x i - (downRun A h hh f).val i ≤ peakMax x (downRun A h hh f).val at hv
  omega

theorem down_stopped_heavy (O : BoxInterface V) (A y : Vec V) (a b : Mass V)
    (hb : ∀ i, 0 < b i) (h : ℤ) (hh : 0 < h)
    (k : LowerPivot (low A h)) (hk : PivotBounds A h k.val) (l : Labels V)
    (hl : Good O.F (fun i => k.val i - 16 * h) (32 * h)
      a (fun i => (4 / 3 : ℚ) * b i) l)
    (hstop : fallStep (low A h) h (fun _ i => !(l i)) k = k)
    (hy : MinWitness O.F A (4096 * h) b y)
    (hr : ∃ j, claimMin A (4096 * h) y j ∧ A j + 1920 * h ≤ k.val j) :
    (3 / 4 : ℚ) < total b (nearMin y k.val h) := by
  by_contra hn
  have hm : total b (nearMin y k.val h) ≤ (3 / 4 : ℚ) := le_of_not_gt hn
  obtain ⟨j, hj, hkj⟩ := hr
  have hw := translateMin_witness O A y k.val b hb h (16 * h) hh
    (by omega) (by omega) hy hk ⟨j, hj⟩
  have he : 2 * (16 * h) = 32 * h := by ring
  rw [he] at hw
  have hsupp : suppMin (fun i => k.val i - 16 * h) (32 * h)
      (translateMin k.val (16 * h) y) = nearMin y k.val h := by
    simpa only [he, nearMin] using translateMin_support y k.val (16 * h)
  have hmass : total (fun i => (4 / 3 : ℚ) * b i)
      (suppMin (fun i => k.val i - 16 * h) (32 * h) (translateMin k.val (16 * h) y)) ≤ 1 := by
    rw [total_scale, hsupp]
    linarith
  obtain ⟨i, hi⟩ := peakMin_attained y k.val
  have hc := translateMin_claim y k.val (16 * h) i (by omega)
  rw [he] at hc
  have hlabel := hl.2 (translateMin k.val (16 * h) y) ⟨hw.1, hmass⟩ i hc
  have hp := le_vmax (fun j => k.val j - y j) j
  have hiy := (hy.1.1 i).1
  have huncap : low A h i < k.val i := by
    dsimp [claimMin] at hj
    dsimp [gapMin, peakMin] at hi
    dsimp [low]
    omega
  have hstation := congrArg (fun z : LowerPivot (low A h) => z.val i) hstop
  have heq : max (low A h i) (k.val i - h) = k.val i := by
    simpa [fallStep, hlabel] using hstation
  omega

def upRun (A : Vec V) (h : ℤ) (hh : 0 < h) (f : Vec V → Labels V)
    (k : Vec V) (hk : ∀ i, k i ≤ high A h i) : UpperPivot (high A h) :=
  rise (high A h) h hh f ⟨k, hk⟩

theorem upRun_spec (A : Vec V) (h : ℤ) (hh : 0 < h) (f : Vec V → Labels V)
    (k : Vec V) (hk : ∀ i, k i ≤ high A h i) :
    riseStep (high A h) h f (upRun A h hh f k hk) = upRun A h hh f k hk ∧
    ∀ i, k i ≤ (upRun A h hh f k hk).val i := by
  exact (rise_spec (high A h) h hh f (fun _ => True) (by intros; trivial)
    ⟨k, hk⟩ trivial).2

theorem upRun_bounds (A : Vec V) (h : ℤ) (hh : 0 < h) (f : Vec V → Labels V)
    (k : Vec V) (hk : PivotBounds A h k) :
    PivotBounds A h (upRun A h hh f k (fun i => (hk i).2)).val := by
  intro i
  have hl := (upRun_spec A h hh f k (fun i => (hk i).2)).2 i
  have hu := (upRun A h hh f k (fun i => (hk i).2)).property i
  dsimp [high] at *
  exact ⟨le_trans (hk i).1 hl, hu⟩

theorem upRun_peak (O : BoxInterface V) (A y : Vec V) (a b : Mass V)
    (hb : ∀ i, 0 < b i) (h : ℤ) (hh : 0 < h)
    (f : Vec V → Labels V)
    (hf : ∀ k, Good O.F (fun i => k i - 16 * h) (32 * h)
      (fun i => (4 / 3 : ℚ) * a i) b (f k))
    (hy : MinWitness O.F A (4096 * h) b y)
    (hr : ∃ j, claimMin A (4096 * h) y j)
    (k : Vec V) (hk : PivotBounds A h k) :
    peakMin y (upRun A h hh f k (fun i => (hk i).2)).val = peakMin y k := by
  let P : Vec V → Prop := fun k' =>
    (∀ i, low A h i ≤ k' i) ∧ peakMin y k' = peakMin y k
  have hs := rise_spec (high A h) h hh f P
    (by
      intro k' hk'
      have hbounds : PivotBounds A h k'.val := by
        intro i
        exact ⟨hk'.1 i, k'.property i⟩
      have hp := up_step_peak O A y a b hb h hh hy hr k' hbounds (f k'.val) (hf k'.val)
      refine ⟨fun i => le_trans (hk'.1 i) (le_riseStep _ h hh _ k' i), ?_⟩
      exact hp.trans hk'.2)
    ⟨k, fun i => (hk i).2⟩ ⟨fun i => (hk i).1, rfl⟩
  exact hs.1.2

theorem up_stopped_heavy (O : BoxInterface V) (A x : Vec V) (a b : Mass V)
    (ha : ∀ i, 0 < a i) (h : ℤ) (hh : 0 < h)
    (k : UpperPivot (high A h)) (hk : PivotBounds A h k.val) (l : Labels V)
    (hl : Good O.F (fun i => k.val i - 16 * h) (32 * h)
      (fun i => (4 / 3 : ℚ) * a i) b l)
    (hstop : riseStep (high A h) h (fun _ => l) k = k)
    (hx : MaxWitness O.F A (4096 * h) a x)
    (hr : ∃ j, claimMax A (4096 * h) x j ∧ k.val j ≤ A j + 2176 * h) :
    (3 / 4 : ℚ) < total a (nearMax x k.val h) := by
  by_contra hn
  have hm : total a (nearMax x k.val h) ≤ (3 / 4 : ℚ) := le_of_not_gt hn
  obtain ⟨j, hj, hkj⟩ := hr
  have hw := translateMax_witness O A x k.val a ha h (16 * h) hh
    (by omega) (by omega) hx hk ⟨j, hj⟩
  have he : 2 * (16 * h) = 32 * h := by ring
  rw [he] at hw
  have hsupp : suppMax (fun i => k.val i - 16 * h)
      (translateMax k.val (16 * h) x) = nearMax x k.val h := by
    simpa only [he, nearMax] using translateMax_support x k.val (16 * h)
  have hmass : total (fun i => (4 / 3 : ℚ) * a i)
      (suppMax (fun i => k.val i - 16 * h) (translateMax k.val (16 * h) x)) ≤ 1 := by
    rw [total_scale, hsupp]
    linarith
  obtain ⟨i, hi⟩ := peakMax_attained x k.val
  have hc := translateMax_claim x k.val (16 * h) i (by omega)
  rw [he] at hc
  have hlabel := hl.1 (translateMax k.val (16 * h) x) ⟨hw.1, hmass⟩ i hc
  have hp := le_vmax (fun j => x j - k.val j) j
  have hix := (hx.1.1 i).2
  have huncap : k.val i < high A h i := by
    dsimp [claimMax] at hj
    dsimp [gapMax, peakMax] at hi
    dsimp [high]
    omega
  have hstation := congrArg (fun z : UpperPivot (high A h) => z.val i) hstop
  have heq : min (high A h i) (k.val i + h) = k.val i := by
    simpa [riseStep, hlabel] using hstation
  omega

def finalPivot (A : Vec V) (h : ℤ) (hh : 0 < h)
    (fd fu : Vec V → Labels V) : UpperPivot (high A h) :=
  upRun A h hh fu (downRun A h hh fd).val
    (fun i => (downRun_bounds A h hh fd i).2)

theorem finalPivot_bounds (A : Vec V) (h : ℤ) (hh : 0 < h)
    (fd fu : Vec V → Labels V) :
    PivotBounds A h (finalPivot A h hh fd fu).val :=
  upRun_bounds A h hh fu _ (downRun_bounds A h hh fd)

theorem finalPivot_ge_down (A : Vec V) (h : ℤ) (hh : 0 < h)
    (fd fu : Vec V → Labels V) (i : V) :
    (downRun A h hh fd).val i ≤ (finalPivot A h hh fd fu).val i :=
  (upRun_spec A h hh fu _ (fun i => (downRun_bounds A h hh fd i).2)).2 i

theorem finalPivot_min_peak (O : BoxInterface V) (A y : Vec V) (a b : Mass V)
    (hb : ∀ i, 0 < b i) (h : ℤ) (hh : 0 < h)
    (fd fu : Vec V → Labels V)
    (hfu : ∀ k, Good O.F (fun i => k i - 16 * h) (32 * h)
      (fun i => (4 / 3 : ℚ) * a i) b (fu k))
    (hy : MinWitness O.F A (4096 * h) b y)
    (hr : ∃ j, claimMin A (4096 * h) y j) :
    peakMin y (finalPivot A h hh fd fu).val = peakMin y (downRun A h hh fd).val :=
  upRun_peak O A y a b hb h hh fu hfu hy hr _ (downRun_bounds A h hh fd)

theorem finalPivot_safe (O : BoxInterface V) (A y : Vec V) (a b : Mass V)
    (hb : ∀ i, 0 < b i) (h : ℤ) (hh : 0 < h)
    (fd fu : Vec V → Labels V)
    (hfu : ∀ k, Good O.F (fun i => k i - 16 * h) (32 * h)
      (fun i => (4 / 3 : ℚ) * a i) b (fu k))
    (hy : MinWitness O.F A (4096 * h) b y)
    (i : V) (hi : claimMin A (4096 * h) y i) :
    (finalPivot A h hh fd fu).val i ≤ A i + 2176 * h := by
  have he := finalPivot_min_peak O A y a b hb h hh fd fu hfu hy ⟨i, hi⟩
  have hb' : peakMin y (downRun A h hh fd).val ≤ 2048 * h := by
    apply vmax_le
    intro j
    have hkj := (downRun_spec A h hh fd).2 j
    have hyj := (hy.1.1 j).1
    dsimp [center] at hkj
    omega
  have hv := le_vmax (fun j => (finalPivot A h hh fd fu).val j - y j) i
  dsimp [claimMin] at hi
  change (finalPivot A h hh fd fu).val i - y i ≤
    peakMin y (finalPivot A h hh fd fu).val at hv
  omega

theorem finalPivot_heavy_min (O : BoxInterface V) (A y : Vec V) (a b : Mass V)
    (hb : ∀ i, 0 < b i) (h : ℤ) (hh : 0 < h)
    (fd fu : Vec V → Labels V)
    (hfd : ∀ k, Good O.F (fun i => k i - 16 * h) (32 * h)
      a (fun i => (4 / 3 : ℚ) * b i) (fd k))
    (hfu : ∀ k, Good O.F (fun i => k i - 16 * h) (32 * h)
      (fun i => (4 / 3 : ℚ) * a i) b (fu k))
    (hy : MinWitness O.F A (4096 * h) b y)
    (hr : ∃ j, claimMin A (4096 * h) y j ∧
      A j + 1920 * h ≤ (downRun A h hh fd).val j) :
    (3 / 4 : ℚ) < total b (nearMin y (finalPivot A h hh fd fu).val h) := by
  have hd := down_stopped_heavy O A y a b hb h hh
    (downRun A h hh fd) (downRun_bounds A h hh fd) (fd (downRun A h hh fd).val)
    (hfd _) (downRun_spec A h hh fd).1 hy hr
  have he := finalPivot_min_peak O A y a b hb h hh fd fu hfu hy
    (by obtain ⟨j, hj, _⟩ := hr; exact ⟨j, hj⟩)
  have hsub : nearMin y (downRun A h hh fd).val h ⊆
      nearMin y (finalPivot A h hh fd fu).val h := by
    intro i hi
    simp only [nearMin, mem_filter, mem_univ, true_and] at hi ⊢
    have hmove := finalPivot_ge_down A h hh fd fu i
    dsimp [gapMin] at hi ⊢
    omega
  exact lt_of_lt_of_le hd (total_mono (fun i => (hb i).le) hsub)

theorem finalPivot_heavy_max (O : BoxInterface V) (A x : Vec V) (a b : Mass V)
    (ha : ∀ i, 0 < a i) (h : ℤ) (hh : 0 < h)
    (fd fu : Vec V → Labels V)
    (hfu : ∀ k, Good O.F (fun i => k i - 16 * h) (32 * h)
      (fun i => (4 / 3 : ℚ) * a i) b (fu k))
    (hx : MaxWitness O.F A (4096 * h) a x)
    (hr : ∃ j, claimMax A (4096 * h) x j ∧
      (finalPivot A h hh fd fu).val j ≤ A j + 2176 * h) :
    (3 / 4 : ℚ) < total a (nearMax x (finalPivot A h hh fd fu).val h) := by
  exact up_stopped_heavy O A x a b ha h hh (finalPivot A h hh fd fu)
    (finalPivot_bounds A h hh fd fu) (fu (finalPivot A h hh fd fu).val) (hfu _)
    (upRun_spec A h hh fu _ (fun i => (downRun_bounds A h hh fd i).2)).1 hx hr

def reweight (m : Mass V) (favorable : Labels V) : Mass V :=
  fun i => if favorable i then (4 / 5 : ℚ) * m i else (8 / 5 : ℚ) * m i

theorem reweight_pos (m : Mass V) (hm : ∀ i, 0 < m i) (l : Labels V) :
    ∀ i, 0 < reweight m l i := by
  intro i
  have hmi := hm i
  dsimp [reweight]
  split_ifs <;> positivity

theorem total_reweight (m : Mass V) (l : Labels V) (S : Finset V) :
    total (reweight m l) S =
      (8 / 5 : ℚ) * total m S - (4 / 5 : ℚ) * total m (S.filter fun i => l i = true) := by
  have hp : ∀ i, reweight m l i =
      (8 / 5 : ℚ) * m i - (4 / 5 : ℚ) * (if l i = true then m i else 0) := by
    intro i
    cases hi : l i <;> simp [reweight, hi] <;> ring
  simp only [total, hp, Finset.sum_sub_distrib, Finset.mul_sum, Finset.sum_filter]

theorem reweight_support_bound (m : Mass V) (hm : ∀ i, 0 < m i)
    (l : Labels V) (S N : Finset V) (hS : total m S ≤ 1)
    (hN : (3 / 4 : ℚ) < total m N) (hsub : N ⊆ S.filter fun i => l i = true) :
    total (reweight m l) S < 1 := by
  have hf := total_mono (fun i => (hm i).le) hsub
  rw [total_reweight]
  linarith

theorem reweight_product (a b : Mass V) (l : Labels V) (i : V) :
    reweight a l i * reweight b (fun j => !(l j)) i = rho * (a i * b i) := by
  cases hi : l i <;> simp [reweight, hi, rho] <;> ring

theorem survive_max (O : BoxInterface V) (A x k : Vec V) (a b : Mass V)
    (ha : ∀ i, 0 < a i) (h : ℤ) (hh : 0 < h) (hk : PivotBounds A h k)
    (hx : MaxWitness O.F A (4096 * h) a x)
    (hr : ∃ j, claimMax A (4096 * h) x j)
    (hheavy : (3 / 4 : ℚ) < total a (nearMax x k h))
    (l : Labels V)
    (hl : Good O.F (fun i => k i - 1024 * h) (2048 * h) a b l) :
    MaxWitness O.F A (4096 * h) (reweight a l) x := by
  have hw := translateMax_witness O A x k a ha h (1024 * h) hh
    (by omega) (by omega) hx hk hr
  have he : 2 * (1024 * h) = 2048 * h := by ring
  rw [he] at hw
  have hsub : nearMax x k h ⊆ (suppMax A x).filter (fun i => l i = true) := by
    intro i hi
    have hgap : gapMax x k i < 32 * h := by simpa [nearMax] using hi
    have hmem : i ∈ suppMax A x := by
      simp only [suppMax, mem_filter, mem_univ, true_and]
      have hbox := (hx.1.1 i).1
      by_contra hn
      have hxi : x i = A i := by omega
      have hsep := relevantMax_separation A x k h hh hx.1.1 hk hr i hxi
      omega
    have hc := translateMax_claim x k (1024 * h) i (by omega)
    rw [he] at hc
    exact mem_filter.mpr ⟨hmem, hl.1 _ hw i hc⟩
  exact ⟨hx.1, (reweight_support_bound a ha l _ _ hx.2 hheavy hsub).le⟩

theorem survive_min (O : BoxInterface V) (A y k : Vec V) (a b : Mass V)
    (hb : ∀ i, 0 < b i) (h : ℤ) (hh : 0 < h) (hk : PivotBounds A h k)
    (hy : MinWitness O.F A (4096 * h) b y)
    (hr : ∃ j, claimMin A (4096 * h) y j)
    (hheavy : (3 / 4 : ℚ) < total b (nearMin y k h))
    (l : Labels V)
    (hl : Good O.F (fun i => k i - 1024 * h) (2048 * h) a b l) :
    MinWitness O.F A (4096 * h) (reweight b (fun i => !(l i))) y := by
  have hw := translateMin_witness O A y k b hb h (1024 * h) hh
    (by omega) (by omega) hy hk hr
  have he : 2 * (1024 * h) = 2048 * h := by ring
  rw [he] at hw
  have hsub : nearMin y k h ⊆ (suppMin A (4096 * h) y).filter (fun i => (!(l i)) = true) := by
    intro i hi
    have hgap : gapMin y k i < 32 * h := by simpa [nearMin] using hi
    have hmem : i ∈ suppMin A (4096 * h) y := by
      simp only [suppMin, mem_filter, mem_univ, true_and]
      have hbox := (hy.1.1 i).2
      by_contra hn
      have hyi : y i = A i + 4096 * h := by omega
      have hsep := relevantMin_separation A y k h hh hy.1.1 hk hr i hyi
      omega
    have hc := translateMin_claim y k (1024 * h) i (by omega)
    rw [he] at hc
    have hlabel := hl.2 _ hw i hc
    exact mem_filter.mpr ⟨hmem, by simp [hlabel]⟩
  exact ⟨hy.1, (reweight_support_bound b hb (fun i => !(l i)) _ _ hy.2 hheavy hsub).le⟩

def overrides (A kd kf : Vec V) (h : ℤ) (l : Labels V) : Labels V :=
  fun i => if kd i < A i + 1920 * h then false
    else if A i + 2176 * h < kf i then true else l i

theorem stage_good (O : BoxInterface V) (A : Vec V) (a b : Mass V)
    (ha : ∀ i, 0 < a i) (hb : ∀ i, 0 < b i) (h : ℤ) (hh : 0 < h)
    (fd fu : Vec V → Labels V)
    (hfd : ∀ k, Good O.F (fun i => k i - 16 * h) (32 * h)
      a (fun i => (4 / 3 : ℚ) * b i) (fd k))
    (hfu : ∀ k, Good O.F (fun i => k i - 16 * h) (32 * h)
      (fun i => (4 / 3 : ℚ) * a i) b (fu k))
    (l0 lc : Labels V)
    (hl0 : Good O.F (fun i => (finalPivot A h hh fd fu).val i - 1024 * h)
      (2048 * h) a b l0)
    (hlc : Good O.F A (4096 * h) (reweight a l0) (reweight b (fun i => !(l0 i))) lc) :
    Good O.F A (4096 * h) a b
      (overrides A (downRun A h hh fd).val (finalPivot A h hh fd fu).val h lc) := by
  constructor
  · intro x hx i hi
    have hd := downRun_safe O A x a b ha h hh fd hfd hx i hi
    have hnd : ¬ (downRun A h hh fd).val i < A i + 1920 * h := by omega
    by_cases hu : A i + 2176 * h < (finalPivot A h hh fd fu).val i
    · simp [overrides, hnd, hu]
    · have hheavy := finalPivot_heavy_max O A x a b ha h hh fd fu hfu hx
        ⟨i, hi, by omega⟩
      have hsurvive := survive_max O A x (finalPivot A h hh fd fu).val a b ha h hh
        (finalPivot_bounds A h hh fd fu) hx ⟨i, hi⟩ hheavy l0 hl0
      have hlabel := hlc.1 x hsurvive i hi
      simp [overrides, hnd, hu, hlabel]
  · intro y hy i hi
    have hu := finalPivot_safe O A y a b hb h hh fd fu hfu hy i hi
    have hnu : ¬ A i + 2176 * h < (finalPivot A h hh fd fu).val i := by omega
    by_cases hd : (downRun A h hh fd).val i < A i + 1920 * h
    · simp [overrides, hd]
    · have hheavy := finalPivot_heavy_min O A y a b hb h hh fd fu hfd hfu hy
        ⟨i, hi, by omega⟩
      have hsurvive := survive_min O A y (finalPivot A h hh fd fu).val a b hb h hh
        (finalPivot_bounds A h hh fd fu) hy ⟨i, hi⟩ hheavy l0 hl0
      have hlabel := hlc.2 y hsurvive i hi
      simp [overrides, hd, hnu, hlabel]

def downChild (s : Input V) (k : Vec V) : Input V where
  A := fun i => k i - 16 * unit s
  d := s.d - 7
  a := s.a
  b := fun i => (4 / 3 : ℚ) * s.b i
  apos := s.apos
  bpos := fun i => mul_pos (by norm_num) (s.bpos i)

def upChild (s : Input V) (k : Vec V) : Input V where
  A := fun i => k i - 16 * unit s
  d := s.d - 7
  a := fun i => (4 / 3 : ℚ) * s.a i
  b := s.b
  apos := fun i => mul_pos (by norm_num) (s.apos i)
  bpos := s.bpos

def wideChild (s : Input V) (k : Vec V) : Input V where
  A := fun i => k i - 1024 * unit s
  d := s.d - 1
  a := s.a
  b := s.b
  apos := s.apos
  bpos := s.bpos

def continuation (s : Input V) (l : Labels V) : Input V where
  A := s.A
  d := s.d
  a := reweight s.a l
  b := reweight s.b (fun i => !(l i))
  apos := reweight_pos s.a s.apos l
  bpos := reweight_pos s.b s.bpos (fun i => !(l i))

theorem narrow_width (s : Input V) (hd : 12 ≤ s.d) :
    (2 : ℤ) ^ (s.d - 7) = 32 * unit s := by
  have he : s.d - 7 = 5 + (s.d - 12) := by omega
  rw [he, pow_add]
  norm_num [unit]

theorem wide_width (s : Input V) (hd : 12 ≤ s.d) :
    (2 : ℤ) ^ (s.d - 1) = 2048 * unit s := by
  have he : s.d - 1 = 11 + (s.d - 12) := by omega
  rw [he, pow_add]
  norm_num [unit]

theorem downChild_rank (s : Input V) (k : Vec V) (hn : ¬ massBase s) :
    rank (downChild s k) < rank s := by
  apply rank_decreases_mass s (downChild s k) hn (by dsimp [downChild]; omega)
  intro i
  have hp := mul_pos (s.apos i) (s.bpos i)
  dsimp [downChild, rho]
  nlinarith

theorem upChild_rank (s : Input V) (k : Vec V) (hn : ¬ massBase s) :
    rank (upChild s k) < rank s := by
  apply rank_decreases_mass s (upChild s k) hn (by dsimp [upChild]; omega)
  intro i
  have hp := mul_pos (s.apos i) (s.bpos i)
  dsimp [upChild, rho]
  nlinarith

theorem continuation_rank (s : Input V) (l : Labels V) (hn : ¬ massBase s) :
    rank (continuation s l) < rank s := by
  apply rank_decreases_mass s (continuation s l) hn (by rfl)
  intro i
  exact (reweight_product s.a s.b l i).ge

theorem wideChild_rank (s : Input V) (k : Vec V) (hd : 1 ≤ s.d) :
    rank (wideChild s k) < rank s := by
  have hb : massBudget (wideChild s k) = massBudget s := rfl
  unfold rank
  rw [hb]
  change s.d - 1 + massBudget s < s.d + massBudget s
  omega

theorem width_base_iff (s : Input V) : width s < 4096 ↔ s.d < 12 := by
  have he : (2 : ℤ) ^ 12 = 4096 := by norm_num
  rw [width, ← he]
  exact pow_lt_pow_iff_right₀ (by norm_num : (1 : ℤ) < 2)

attribute [irreducible] rank

def label (O : BoxInterface V) (s : Input V) : Labels V :=
  if hm : massBase s then massLabels s
  else if hw : s.d < 12 then basicLabels O s
  else
    let fd := fun k => label O (downChild s k)
    let fu := fun k => label O (upChild s k)
    let kd := downRun s.A (unit s) (unit_pos s) fd
    let kf := finalPivot s.A (unit s) (unit_pos s) fd fu
    let l0 := label O (wideChild s kf.val)
    let lc := label O (continuation s l0)
    overrides s.A kd.val kf.val (unit s) lc
termination_by rank s
decreasing_by
  · exact downChild_rank _ _ hm
  · exact upChild_rank _ _ hm
  · exact wideChild_rank _ _ (by omega)
  · exact continuation_rank _ _ hm

theorem label_good (O : BoxInterface V) (s : Input V) :
    Good O.F s.A (width s) s.a s.b (label O s) := by
  refine (measure (rank (V := V))).wf.induction
    (C := fun t : Input V => Good O.F t.A (width t) t.a t.b (label O t)) s ?_
  intro s ih
  change ∀ t : Input V, rank t < rank s →
    Good O.F t.A (width t) t.a t.b (label O t) at ih
  by_cases hm : massBase s
  · rw [label]
    simp only [hm, ↓reduceDIte, ↓reduceIte]
    exact mass_base_good O s hm
  · by_cases hw : s.d < 12
    · rw [label]
      simp only [hm, hw, ↓reduceDIte, ↓reduceIte]
      exact basic_good O s
    · rw [label]
      simp only [hm, hw, ↓reduceDIte, ↓reduceIte]
      have hd : 12 ≤ s.d := by omega
      let fd := fun k => label O (downChild s k)
      let fu := fun k => label O (upChild s k)
      let kd := downRun s.A (unit s) (unit_pos s) fd
      let kf := finalPivot s.A (unit s) (unit_pos s) fd fu
      let l0 := label O (wideChild s kf.val)
      let lc := label O (continuation s l0)
      have hfd : ∀ k, Good O.F (fun i => k i - 16 * unit s) (32 * unit s)
          s.a (fun i => (4 / 3 : ℚ) * s.b i) (fd k) := by
        intro k
        have hc := ih (downChild s k) (downChild_rank s k hm)
        change Good O.F (fun i => k i - 16 * unit s) ((2 : ℤ) ^ (s.d - 7))
          s.a (fun i => (4 / 3 : ℚ) * s.b i) (fd k) at hc
        rw [narrow_width s hd] at hc
        exact hc
      have hfu : ∀ k, Good O.F (fun i => k i - 16 * unit s) (32 * unit s)
          (fun i => (4 / 3 : ℚ) * s.a i) s.b (fu k) := by
        intro k
        have hc := ih (upChild s k) (upChild_rank s k hm)
        change Good O.F (fun i => k i - 16 * unit s) ((2 : ℤ) ^ (s.d - 7))
          (fun i => (4 / 3 : ℚ) * s.a i) s.b (fu k) at hc
        rw [narrow_width s hd] at hc
        exact hc
      have hl0 : Good O.F (fun i => kf.val i - 1024 * unit s) (2048 * unit s)
          s.a s.b l0 := by
        have hc := ih (wideChild s kf.val) (wideChild_rank s kf.val (by omega))
        change Good O.F (fun i => kf.val i - 1024 * unit s) ((2 : ℤ) ^ (s.d - 1))
          s.a s.b l0 at hc
        rw [wide_width s hd] at hc
        exact hc
      have hlc : Good O.F s.A (width s) (reweight s.a l0)
          (reweight s.b (fun i => !(l0 i))) lc := by
        exact ih (continuation s l0) (continuation_rank s l0 hm)
      rw [width_split s hd] at hlc ⊢
      exact stage_good O s.A s.a s.b s.apos s.bpos (unit s) (unit_pos s)
        fd fu hfd hfu l0 lc hl0 hlc

#print axioms label_good

end LabelCore
