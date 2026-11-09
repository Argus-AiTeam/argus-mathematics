import Mathlib

namespace QuantitativeProfile

noncomputable section

structure Profile where
  s0 : ℝ
  s1 : ℝ
  j0 : ℝ
  j1 : ℝ

def step (p q : ℝ) (x : Profile) : Profile :=
  ⟨p * x.s0 + x.s1 + 3 * x.j1, x.s0 + q * x.s1,
    p * x.s0 + 3 * x.j1, x.j0 + q * x.s1⟩

def profile (p q : ℝ) : ℕ → Profile
  | 0 => ⟨1, 1, 0, 0⟩
  | n + 1 => step p q (profile p q n)

def Below (x y : Profile) : Prop :=
  x.s0 ≤ y.s0 ∧ x.s1 ≤ y.s1 ∧ x.j0 ≤ y.j0 ∧ x.j1 ≤ y.j1

theorem step_mono {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q)
    {x y : Profile} (h : Below x y) : Below (step p q x) (step p q y) := by
  rcases h with ⟨h0, h1, h2, h3⟩
  dsimp [Below, step]
  constructor
  · gcongr
  constructor
  · gcongr
  constructor <;> gcongr

theorem profile_increases {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q) (n : ℕ) :
    Below (profile p q n) (profile p q (n + 1)) := by
  induction n with
  | zero => simp [Below, profile, step, hp, hq]
  | succ n ih => exact step_mono hp hq ih

theorem profile_s0_mono {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q) :
    Monotone (fun n => (profile p q n).s0) :=
  monotone_nat_of_le_succ (fun n => (profile_increases hp hq n).1)

theorem profile_s1_mono {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q) :
    Monotone (fun n => (profile p q n).s1) :=
  monotone_nat_of_le_succ (fun n => (profile_increases hp hq n).2.1)

def alpha (p q : ℝ) := p + p ^ 2 + 4 * q
def beta (p : ℝ) := 9 + 3 * p
def gamma (p q : ℝ) := p + q + q ^ 2
def delta (p : ℝ) := 3 + p

def envelope (p q : ℝ) : ℕ → ℝ × ℝ
  | 0 => (1, 0)
  | n + 1 =>
      let x := envelope p q n
      ((1 + alpha p q) * x.1 + beta p * x.2,
        gamma p q * x.1 + delta p * x.2)

def Covers (x : Profile) (u v : ℝ) : Prop :=
  x.s0 ≤ u ∧ x.s1 ≤ u ∧ x.j0 ≤ 3 * v ∧ x.j1 ≤ v

theorem envelope_nonneg {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q) (n : ℕ) :
    0 ≤ (envelope p q n).1 ∧ 0 ≤ (envelope p q n).2 := by
  induction n with
  | zero => norm_num [envelope]
  | succ n ih =>
      rcases ih with ⟨hu, hv⟩
      dsimp [envelope]
      constructor <;> dsimp [alpha, beta, gamma, delta] <;> positivity

theorem two_step_covers {p q : ℝ} (hp : 0 ≤ p) (hp1 : p ≤ 1)
    (hq : 0 ≤ q) (hq1 : q ≤ 1) {x : Profile} {u v : ℝ}
    (hu : 0 ≤ u) (hv : 0 ≤ v) (h : Covers x u v) :
    Covers (step p q (step p q x))
      ((1 + alpha p q) * u + beta p * v)
      (gamma p q * u + delta p * v) := by
  rcases h with ⟨h0, h1, h2, h3⟩
  have hp2 : p ^ 2 ≤ p := by nlinarith
  have hq2 : q ^ 2 ≤ q := by nlinarith
  dsimp only [Covers]
  constructor
  · calc
      (step p q (step p q x)).s0 =
          (1 + p ^ 2) * x.s0 + (p + 4 * q) * x.s1 +
            3 * x.j0 + 3 * p * x.j1 := by simp [step]; ring
      _ ≤ (1 + p ^ 2) * u + (p + 4 * q) * u +
            3 * (3 * v) + 3 * p * v := by gcongr
      _ = _ := by dsimp [alpha, beta]; ring
  constructor
  · have hc : (p + q) + (1 + q ^ 2) ≤ 1 + alpha p q := by
      dsimp [alpha]
      nlinarith [sq_nonneg p]
    have hb : 3 ≤ beta p := by dsimp [beta]; linarith
    calc
      (step p q (step p q x)).s1 =
          (p + q) * x.s0 + (1 + q ^ 2) * x.s1 + 3 * x.j1 := by
            simp [step]; ring
      _ ≤ (p + q) * u + (1 + q ^ 2) * u + 3 * v := by gcongr
      _ ≤ _ := by
        nlinarith [mul_le_mul_of_nonneg_right hc hu,
          mul_le_mul_of_nonneg_right hb hv]
  constructor
  · have hc : p ^ 2 + p + 3 * q ≤ 3 * gamma p q := by
      dsimp [gamma]
      nlinarith [sq_nonneg q]
    calc
      (step p q (step p q x)).j0 =
          p ^ 2 * x.s0 + (p + 3 * q) * x.s1 + 3 * x.j0 + 3 * p * x.j1 := by
            simp [step]; ring
      _ ≤ p ^ 2 * u + (p + 3 * q) * u + 3 * (3 * v) + 3 * p * v := by
            gcongr
      _ ≤ _ := by
        dsimp [delta]
        nlinarith [mul_le_mul_of_nonneg_right hc hu]
  · calc
      (step p q (step p q x)).j1 =
          (p + q) * x.s0 + q ^ 2 * x.s1 + 3 * x.j1 := by simp [step]; ring
      _ ≤ (p + q) * u + q ^ 2 * u + 3 * v := by gcongr
      _ ≤ _ := by
        dsimp [gamma, delta]
        nlinarith [mul_nonneg hp hv]

theorem envelope_covers {p q : ℝ} (hp : 0 ≤ p) (hp1 : p ≤ 1)
    (hq : 0 ≤ q) (hq1 : q ≤ 1) (n : ℕ) :
    Covers (profile p q (2 * n)) (envelope p q n).1 (envelope p q n).2 := by
  induction n with
  | zero => norm_num [Covers, profile, envelope]
  | succ n ih =>
      have he : 2 * (n + 1) = (2 * n + 1) + 1 := by omega
      rw [he]
      exact two_step_covers hp hp1 hq hq1
        (envelope_nonneg hp hq n).1 (envelope_nonneg hp hq n).2 ih

theorem weighted_envelope {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q)
    (ha : alpha p q ≤ 17 / 4 * q) (hb : beta p ≤ 10)
    (hg : gamma p q ≤ 6 / 5 * q) (hd : delta p ≤ 3 + q / 6) (n : ℕ) :
    (envelope p q n).2 + gamma p q / 2 * (envelope p q n).1 ≤
      gamma p q / 2 * (3 + 7 * q) ^ n := by
  have hg0 : 0 ≤ gamma p q := by dsimp [gamma]; positivity
  have hb0 : 0 ≤ beta p := by dsimp [beta]; positivity
  have hlambda : 0 ≤ 3 + 7 * q := by positivity
  have hc0 : 3 + alpha p q ≤ 3 + 7 * q := by nlinarith
  have hc1 : delta p + gamma p q / 2 * beta p ≤ 3 + 7 * q := by
    nlinarith [mul_le_mul_of_nonneg_right hb hg0]
  induction n with
  | zero => simp [envelope]
  | succ n ih =>
      have hu := (envelope_nonneg hp hq n).1
      have hv := (envelope_nonneg hp hq n).2
      calc
        _ = (gamma p q / 2 * (3 + alpha p q)) * (envelope p q n).1 +
            (delta p + gamma p q / 2 * beta p) * (envelope p q n).2 := by
              dsimp [envelope]; ring
        _ ≤ (gamma p q / 2 * (3 + 7 * q)) * (envelope p q n).1 +
            (3 + 7 * q) * (envelope p q n).2 := by gcongr
        _ = (3 + 7 * q) *
            ((envelope p q n).2 + gamma p q / 2 * (envelope p q n).1) := by ring
        _ ≤ (3 + 7 * q) * (gamma p q / 2 * (3 + 7 * q) ^ n) := by gcongr
        _ = _ := by rw [pow_succ]; ring

theorem envelope_bound {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q)
    (ha : alpha p q ≤ 17 / 4 * q) (hb : beta p ≤ 10)
    (hg : gamma p q ≤ 6 / 5 * q) (hd : delta p ≤ 3 + q / 6) (n : ℕ) :
    (envelope p q n).1 ≤
      (1 + 17 / 4 * q) ^ n + 3 * q * (3 + 7 * q) ^ n := by
  have ha0 : 0 ≤ alpha p q := by dsimp [alpha]; positivity
  have hb0 : 0 ≤ beta p := by dsimp [beta]; positivity
  have hg0 : 0 ≤ gamma p q := by dsimp [gamma]; positivity
  have hlambda : 1 + alpha p q + 2 ≤ 3 + 7 * q := by nlinarith
  have haux (n : ℕ) : (envelope p q n).1 ≤
      (1 + alpha p q) ^ n + (beta p * gamma p q / 4) * (3 + 7 * q) ^ n := by
    induction n with
    | zero =>
        simp only [envelope, pow_zero, mul_one]
        nlinarith [mul_nonneg hb0 hg0]
    | succ n ih =>
        have hv : (envelope p q n).2 ≤ gamma p q / 2 * (3 + 7 * q) ^ n := by
          have hw := weighted_envelope hp hq ha hb hg hd n
          have hu := (envelope_nonneg hp hq n).1
          nlinarith [mul_nonneg hg0 hu]
        calc
          _ = (1 + alpha p q) * (envelope p q n).1 +
              beta p * (envelope p q n).2 := rfl
          _ ≤ (1 + alpha p q) *
              ((1 + alpha p q) ^ n + beta p * gamma p q / 4 * (3 + 7 * q) ^ n) +
              beta p * (gamma p q / 2 * (3 + 7 * q) ^ n) := by gcongr
          _ = (1 + alpha p q) ^ (n + 1) +
              (beta p * gamma p q / 4) * (1 + alpha p q + 2) *
                (3 + 7 * q) ^ n := by rw [pow_succ]; ring
          _ ≤ (1 + alpha p q) ^ (n + 1) +
              (beta p * gamma p q / 4) * (3 + 7 * q) ^ (n + 1) := by
                rw [show (3 + 7 * q) ^ (n + 1) =
                  (3 + 7 * q) ^ n * (3 + 7 * q) from pow_succ _ _]
                have hc0 : 0 ≤ beta p * gamma p q / 4 := by positivity
                have hm := mul_le_mul_of_nonneg_left hlambda hc0
                nlinarith [mul_le_mul_of_nonneg_right hm
                  (show 0 ≤ (3 + 7 * q) ^ n by positivity)]
  have hc : beta p * gamma p q / 4 ≤ 3 * q := by
    nlinarith [mul_le_mul_of_nonneg_right hb hg0]
  calc
    _ ≤ (1 + alpha p q) ^ n + beta p * gamma p q / 4 * (3 + 7 * q) ^ n := haux n
    _ ≤ _ := by gcongr

theorem power_gap (x : ℝ) (hx : 0 ≤ x) (n : ℕ) :
    (1 + x) ^ n * (1 - (n : ℝ) * x) ≤ 1 := by
  induction n with
  | zero => norm_num
  | succ n ih =>
      have ht : 0 ≤ (1 + x) ^ n * ((n : ℝ) + 1) * x ^ 2 := by positivity
      rw [pow_succ]
      push_cast
      nlinarith

theorem nine_mul_le_pow (n : ℕ) : 9 * (n + 3) ≤ 3 ^ (n + 3) := by
  induction n with
  | zero => norm_num
  | succ n ih =>
      rw [show n + 1 + 3 = (n + 3) + 1 by omega, pow_succ]
      omega

def qDepth (h : ℕ) : ℝ := 1 / (4 * 3 ^ h)
def pDepth (h : ℕ) : ℝ := 16 * qDepth h ^ 2

theorem depth_budget {h : ℕ} (hh : 3 ≤ h) :
    0 ≤ qDepth h ∧ qDepth h ≤ 1 / 108 ∧
      (h : ℝ) * qDepth h ≤ 1 / 36 ∧ qDepth h * 3 ^ h = 1 / 4 := by
  have hq : 0 ≤ qDepth h := by unfold qDepth; positivity
  have he : h = (h - 3) + 3 := by omega
  have hn : 9 * h ≤ 3 ^ h := by
    conv_lhs => rw [he]
    conv_rhs => rw [he]
    exact nine_mul_le_pow (h - 3)
  have hr : (9 : ℝ) * (h : ℝ) ≤ (3 : ℝ) ^ h := by exact_mod_cast hn
  have hhR : (3 : ℝ) ≤ h := by exact_mod_cast hh
  have hpow : (27 : ℝ) ≤ 3 ^ h := by linarith
  have hs : qDepth h * 3 ^ h = 1 / 4 := by
    unfold qDepth
    field_simp
  refine ⟨hq, ?_, ?_, hs⟩
  · nlinarith [mul_le_mul_of_nonneg_left hpow hq]
  · nlinarith [mul_le_mul_of_nonneg_right hr hq]

theorem terminal_bound (h : ℕ) (hh : 1 ≤ h) :
    (profile (pDepth h) (qDepth h) (2 * h)).s0 ≤ 2 ∧
      (profile (pDepth h) (qDepth h) (2 * h)).s1 ≤ 2 := by
  by_cases hsmall : h < 3
  · interval_cases h <;> norm_num [pDepth, qDepth, profile, step] at *
  have hlarge : 3 ≤ h := by omega
  obtain ⟨hq, hqmax, hbudget, hscale⟩ := depth_budget hlarge
  let p := pDepth h
  let q := qDepth h
  have hp : 0 ≤ p := by dsimp [p, pDepth]; positivity
  have hpq : p ≤ q / 6 := by dsimp [p, q, pDepth]; nlinarith
  have hp1 : p ≤ 1 / 3 := by dsimp [q] at hpq; linarith
  have hq1 : q ≤ 1 := by dsimp [q]; linarith
  have ha : alpha p q ≤ 17 / 4 * q := by
    dsimp [alpha]
    nlinarith [mul_nonneg hp (show 0 ≤ 1 / 2 - p by linarith)]
  have hb : beta p ≤ 10 := by dsimp [beta]; linarith
  have hg : gamma p q ≤ 6 / 5 * q := by
    have hq30 : q ≤ 1 / 30 := by dsimp [q]; linarith
    dsimp [gamma]
    nlinarith [mul_nonneg hq (show 0 ≤ 1 / 30 - q by linarith)]
  have hd : delta p ≤ 3 + q / 6 := by dsimp [delta]; linarith
  have hbnd := envelope_bound hp hq ha hb hg hd h
  have hslow : (1 + 17 / 4 * q) ^ h ≤ 144 / 127 := by
    have hx : 0 ≤ 17 / 4 * q := by positivity
    have ht := power_gap (17 / 4 * q) hx h
    have hn : (h : ℝ) * (17 / 4 * q) ≤ 17 / 144 := by nlinarith
    have hz : 0 ≤ (1 + 17 / 4 * q) ^ h := by positivity
    nlinarith [mul_le_mul_of_nonneg_left hn hz]
  have hfast : (1 + 7 / 3 * q) ^ h ≤ 108 / 101 := by
    have hx : 0 ≤ 7 / 3 * q := by positivity
    have ht := power_gap (7 / 3 * q) hx h
    have hn : (h : ℝ) * (7 / 3 * q) ≤ 7 / 108 := by nlinarith
    have hz : 0 ≤ (1 + 7 / 3 * q) ^ h := by positivity
    nlinarith [mul_le_mul_of_nonneg_left hn hz]
  have hfactor : (3 + 7 * q) ^ h = 3 ^ h * (1 + 7 / 3 * q) ^ h := by
    rw [← mul_pow]
    congr 1
    ring
  have hfastTerm : 3 * q * (3 + 7 * q) ^ h ≤ 81 / 101 := by
    rw [hfactor]
    have he : 3 * q * (3 ^ h * (1 + 7 / 3 * q) ^ h) =
        3 / 4 * (1 + 7 / 3 * q) ^ h := by
      calc
        _ = 3 * (q * 3 ^ h) * (1 + 7 / 3 * q) ^ h := by ring
        _ = _ := by rw [hscale]; ring
    rw [he]
    nlinarith
  have hu : (envelope p q h).1 ≤ 2 := by
    linarith [hbnd]
  have hc := envelope_covers hp (by linarith) hq hq1 h
  exact ⟨hc.1.trans hu, hc.2.1.trans hu⟩

theorem uniform_profiles (h n : ℕ) (hh : 1 ≤ h) (hn : n ≤ 2 * h) :
    (profile (pDepth h) (qDepth h) n).s0 ≤ 2 ∧
      (profile (pDepth h) (qDepth h) n).s1 ≤ 2 := by
  have hp : 0 ≤ pDepth h := by unfold pDepth; positivity
  have hq : 0 ≤ qDepth h := by unfold qDepth; positivity
  obtain ⟨h0, h1⟩ := terminal_bound h hh
  exact ⟨(profile_s0_mono hp hq hn).trans h0,
    (profile_s1_mono hp hq hn).trans h1⟩

structure NatProfile where
  s0 : ℕ
  s1 : ℕ
  j0 : ℕ
  j1 : ℕ

def raw (L M r : ℕ) : ℕ → NatProfile
  | 0 => ⟨L, L * M, 0, 0⟩
  | n + 1 =>
      let x := raw L M r n
      ⟨16 * x.s0 + x.s1 + 3 * x.j1, M ^ 2 * x.s0 + r * x.s1,
        16 * x.s0 + 3 * x.j1, M ^ 2 * x.j0 + r * x.s1⟩

theorem raw_majorizes (d L M r : ℕ) (S J : ℕ → Bool → ℕ)
    (hS0 : S 0 false ≤ L) (hS1 : S 0 true ≤ L * M)
    (hJ0 : J 0 false = 0) (hJ1 : J 0 true = 0)
    (hs0 : ∀ n < d, S (n + 1) false ≤ 16 * S n false + S n true + 3 * J n true)
    (hs1 : ∀ n < d, S (n + 1) true ≤ M ^ 2 * S n false + r * S n true)
    (hj0 : ∀ n < d, J (n + 1) false ≤ 16 * S n false + 3 * J n true)
    (hj1 : ∀ n < d, J (n + 1) true ≤ M ^ 2 * J n false + r * S n true) :
    ∀ n ≤ d, S n false ≤ (raw L M r n).s0 ∧ S n true ≤ (raw L M r n).s1 ∧
      J n false ≤ (raw L M r n).j0 ∧ J n true ≤ (raw L M r n).j1 := by
  intro n
  induction n with
  | zero => intro _; simpa [raw, hJ0, hJ1] using And.intro hS0 hS1
  | succ n ih =>
      intro hn
      rcases ih (by omega) with ⟨a, b, c, e⟩
      have hnd : n < d := by omega
      refine ⟨(hs0 n hnd).trans ?_, (hs1 n hnd).trans ?_,
        (hj0 n hnd).trans ?_, (hj1 n hnd).trans ?_⟩
      all_goals dsimp [raw]; gcongr

theorem raw_scaled (L M r n : ℕ) (hM : 0 < M) :
    ((raw L M r n).s0 : ℝ) =
        (L : ℝ) * (M : ℝ) ^ n * (profile (16 / M) (r / M) n).s0 ∧
    ((raw L M r n).s1 : ℝ) =
        (L : ℝ) * (M : ℝ) ^ (n + 1) * (profile (16 / M) (r / M) n).s1 ∧
    ((raw L M r n).j0 : ℝ) =
        (L : ℝ) * (M : ℝ) ^ n * (profile (16 / M) (r / M) n).j0 ∧
    ((raw L M r n).j1 : ℝ) =
        (L : ℝ) * (M : ℝ) ^ (n + 1) * (profile (16 / M) (r / M) n).j1 := by
  have hMr : (M : ℝ) ≠ 0 := by exact_mod_cast hM.ne'
  induction n with
  | zero => norm_num [raw, profile]
  | succ n ih =>
      rcases ih with ⟨h0, h1, h2, h3⟩
      refine ⟨?_, ?_, ?_, ?_⟩
      all_goals
        simp only [raw, profile, step]
        push_cast
        simp only [h0, h1, h2, h3, pow_succ]
        field_simp
        <;> ring

def mDepth (h : ℕ) : ℕ := 16 * 3 ^ (2 * h)
def rDepth (h : ℕ) : ℕ := 4 * 3 ^ h

theorem depth_parameter_identities (h : ℕ) :
    (16 : ℝ) / mDepth h = pDepth h ∧
      (rDepth h : ℝ) / mDepth h = qDepth h ∧
      rDepth h ^ 2 = mDepth h := by
  have hn : (3 : ℝ) ^ h ≠ 0 := by positivity
  have he : 2 * h = h * 2 := by omega
  refine ⟨?_, ?_, ?_⟩
  · simp only [mDepth, Nat.cast_mul, Nat.cast_ofNat, Nat.cast_pow, pDepth, qDepth]
    rw [he, pow_mul]
    field_simp
    <;> ring
  · simp only [rDepth, mDepth, Nat.cast_mul, Nat.cast_ofNat, Nat.cast_pow, qDepth]
    rw [he, pow_mul]
    field_simp
    <;> ring
  · dsimp [rDepth, mDepth]
    rw [he, pow_mul]
    ring

theorem raw_even_bound (h L n : ℕ) (hh : 1 ≤ h) (hn : n ≤ 2 * h) :
    (raw L (mDepth h) (rDepth h) n).s0 ≤ 2 * L * mDepth h ^ n ∧
      (raw L (mDepth h) (rDepth h) n).s1 ≤ 2 * L * mDepth h ^ (n + 1) := by
  have hM : 0 < mDepth h := by dsimp [mDepth]; positivity
  obtain ⟨h0, h1, _, _⟩ := raw_scaled L (mDepth h) (rDepth h) n hM
  obtain ⟨hp, hq, _⟩ := depth_parameter_identities h
  rw [hp, hq] at h0 h1
  obtain ⟨ha, hb⟩ := uniform_profiles h n hh hn
  constructor
  · have hc : ((raw L (mDepth h) (rDepth h) n).s0 : ℝ) ≤
        2 * (L : ℝ) * (mDepth h : ℝ) ^ n := by
      rw [h0]
      nlinarith [mul_le_mul_of_nonneg_left ha
        (show 0 ≤ (L : ℝ) * (mDepth h : ℝ) ^ n by positivity)]
    exact_mod_cast hc
  · have hc : ((raw L (mDepth h) (rDepth h) n).s1 : ℝ) ≤
        2 * (L : ℝ) * (mDepth h : ℝ) ^ (n + 1) := by
      rw [h1]
      nlinarith [mul_le_mul_of_nonneg_left hb
        (show 0 ≤ (L : ℝ) * (mDepth h : ℝ) ^ (n + 1) by positivity)]
    exact_mod_cast hc

def seedM : ℕ := mDepth 10
def seedR : ℕ := rDepth 10
def seedA : ℕ := 36 * seedM ^ 21
def seedB : ℕ := seedM ^ 2 * (2 * seedM ^ 2 + 1) ^ 20

set_option exponentiation.threshold 2048 in
theorem seed_integer_exponent : seedA ^ 161 ≤ seedB ^ 80 := by
  have hc : (36 : ℕ) ^ 161 * seedM ^ 21 ≤ 2 ^ 1600 := by
    norm_num [seedM, mDepth]
  have hb : 2 ^ 20 * seedM ^ 42 ≤ seedB := by
    calc
      _ = seedM ^ 2 * (2 * seedM ^ 2) ^ 20 := by ring
      _ ≤ _ := by dsimp [seedB]; gcongr; omega
  calc
    seedA ^ 161 = (36 ^ 161 * seedM ^ 21) * seedM ^ 3360 := by
      dsimp [seedA]
      ring
    _ ≤ 2 ^ 1600 * seedM ^ 3360 := Nat.mul_le_mul_right _ hc
    _ = (2 ^ 20 * seedM ^ 42) ^ 80 := by ring
    _ ≤ seedB ^ 80 := by gcongr

end

end QuantitativeProfile
