import Mathlib

namespace LocalizationAudit

def chi (q : ℤ) : ℤ := q ^ 2
def surfaceSquare (q : ℤ) : ℤ := 8 * chi q
def t (q : ℤ) : ℤ := 25 * chi q - 1
def nu (q : ℤ) : ℤ := t q - 1
def lengthN (q : ℤ) : ℤ := nu q + 3 * surfaceSquare q
def virtualRank (q : ℤ) : ℤ := 2 * t q + chi q - 3

theorem chi_lower_bound (q : ℤ) (hq : 4 ≤ q) : 16 ≤ chi q := by
  dsimp [chi]
  nlinarith

theorem rank_gap (q : ℤ) (hq : 4 ≤ q) : 2 * t q < virtualRank q := by
  have hc := chi_lower_bound q hq
  dsimp [virtualRank]
  omega

theorem numerical_parameters (q : ℤ) :
    lengthN q = 49 * chi q - 2 ∧
    virtualRank q = 51 * chi q - 5 ∧
    chi q + 3 * surfaceSquare q - 1 = t q := by
  dsimp [lengthN, nu, virtualRank, t, surfaceSquare]
  constructor
  · ring
  constructor <;> ring

theorem branch_thresholds (q : ℤ) (hq : 4 ≤ q) :
    t q ≤ lengthN q ∧ nu q < t q ∧ nu q - surfaceSquare q < t q := by
  have hc := chi_lower_bound q hq
  dsimp [lengthN, nu, surfaceSquare]
  omega

theorem high_index_exists (a b s : ℚ) (hs : 0 < s) (h : a + b = 3 * s) :
    s < a ∨ s < b := by
  by_contra! hn
  linarith

theorem support_factorization (q p : ℚ) :
    (p - 2 * q) * (8 * q ^ 2 - 2 * q - p) =
      8 * q ^ 2 * p - p ^ 2 - 16 * q ^ 3 + 4 * q ^ 2 := by
  ring

theorem integral_support_bound (q n : ℤ) (p : ℚ)
    (hq : 1 ≤ q)
    (hp0 : 2 * (q : ℚ) ≤ p)
    (hp1 : p ≤ 8 * (q : ℚ) ^ 2 - 2 * (q : ℚ))
    (hH : 8 * (q : ℚ) ^ 2 * (2 * (n : ℚ) + p) ≤ p ^ 2) :
    n ≤ -q := by
  have hqQ : (1 : ℚ) ≤ (q : ℚ) := by exact_mod_cast hq
  have hqpos : (0 : ℚ) < (q : ℚ) := by linarith
  have hq2 : (0 : ℚ) < (q : ℚ) ^ 2 := by positivity
  have hprod :
      0 ≤ (p - 2 * (q : ℚ)) *
        (8 * (q : ℚ) ^ 2 - 2 * (q : ℚ) - p) :=
    mul_nonneg (by linarith) (by linarith)
  have hscaled :
      16 * (q : ℚ) ^ 2 * ((n : ℚ) + (q : ℚ)) ≤
        4 * (q : ℚ) ^ 2 := by
    nlinarith [hprod]
  by_contra hn
  have hnI : 1 ≤ n + q := by omega
  have hnQ : (1 : ℚ) ≤ (n : ℚ) + (q : ℚ) := by exact_mod_cast hnI
  have hmul := mul_le_mul_of_nonneg_left hnQ
    (show (0 : ℚ) ≤ 16 * (q : ℚ) ^ 2 by positivity)
  nlinarith

theorem short_length_exclusion (t n k : ℤ) (hn : n < t) :
    4 * t - 2 * k < 2 * (3 * t - k - n) := by
  omega

def blockCost (k : ℕ) : ℤ :=
  if k = 1 then 2 else if k = 2 then 4 else 2 * ((k : ℤ) - 1)

theorem block_budget (k : ℕ) (hk : 1 ≤ k) :
    4 * (k : ℤ) ≤ 3 * blockCost k ∧
    (4 * (k : ℤ) = 3 * blockCost k ↔ k = 3) := by
  unfold blockCost
  split_ifs with h1 h2
  · subst k
    norm_num
  · subst k
    norm_num
  · have hk3 : 3 ≤ k := by omega
    constructor
    · omega
    · constructor <;> intro h <;> omega

def slack (k : ℕ) : ℤ := 3 * blockCost k - 4 * (k : ℤ)

theorem slack_sum_nonneg (ks : List ℕ)
    (hp : ∀ k ∈ ks, 1 ≤ k) : 0 ≤ (ks.map slack).sum := by
  induction ks with
  | nil => simp
  | cons a ks ih =>
    have ha := (block_budget a (hp a (by simp))).1
    have ht := ih (fun k hk => hp k (by simp [hk]))
    simp only [List.map_cons, List.sum_cons]
    dsimp [slack]
    linarith

theorem zero_slack_only_triples (ks : List ℕ)
    (hp : ∀ k ∈ ks, 1 ≤ k) (hz : (ks.map slack).sum = 0) :
    ∀ k ∈ ks, k = 3 := by
  induction ks with
  | nil => simp
  | cons a ks ih =>
    have hpa : 1 ≤ a := hp a (by simp)
    have hpt : ∀ k ∈ ks, 1 ≤ k := fun k hk => hp k (by simp [hk])
    have hsa : 0 ≤ slack a := by
      dsimp [slack]
      linarith [(block_budget a hpa).1]
    have hst := slack_sum_nonneg ks hpt
    simp only [List.map_cons, List.sum_cons] at hz
    have hza : slack a = 0 := by linarith
    have hzt : (ks.map slack).sum = 0 := by linarith
    have ha : a = 3 := (block_budget a hpa).2.mp (by
      dsimp [slack] at hza
      linarith)
    intro k hk
    simp only [List.mem_cons] at hk
    rcases hk with hka | hkt
    · simpa [hka] using ha
    · exact ih hpt hzt k hkt

theorem based_trace_cancellation (a : ℚ) : -a - (1 - a) = -1 := by
  ring

theorem riemann_roch_rank (nu l1d l2d kd dsq chi : ℚ) :
    (2 * (nu + l1d - dsq / 2) - (kd + l1d + l2d) + dsq) + chi - 1 =
      2 * nu + (l1d - l2d - kd) + chi - 1 := by
  ring

end LocalizationAudit
