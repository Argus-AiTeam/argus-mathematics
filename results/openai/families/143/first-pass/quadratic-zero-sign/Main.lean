import Mathlib

namespace QuadraticZeroSign

noncomputable section

def K (z : ℝ) : ℝ := z ^ 2 * (z + 1)
def N (z l : ℝ) : ℝ := l * z ^ 3 * (z - 2) + 2 * z - 1
def W (z l : ℝ) : ℝ := 2 * N z l
def B (z l : ℝ) : ℝ := z - 2 + l * z * (2 * z - 1)
def T (z l : ℝ) : ℝ := 2 * l * z ^ 3 - l * z ^ 2 - z + 2
def A (z l : ℝ) : ℝ := 2 * l * z ^ 3 - 3 * l * z ^ 2 + 3 * z - 2
def J (z l : ℝ) : ℝ := W z l + z * B z l
def S0 (z l : ℝ) : ℝ := (3 / 2 : ℝ) * (l ^ 2 * z ^ 2 - 1)

def schwarzian (z l d b : ℝ) : ℝ :=
  2 * b * z ^ 2 * (z + l ^ 2) +
  d ^ 2 / 2 * (l ^ 2 - 1) * z ^ 2 -
  d * (z + l ^ 2 * z ^ 2) + S0 z l

def F (z l s v : ℝ) : ℝ :=
  v ^ 2 + 2 * z * B z l * v + 2 * z ^ 2 * (z ^ 2 - 1) * s

def Delta (z l : ℝ) : ℝ := z * (z + 1) - l * K z - W z l

def Riccati (z l d b v : ℝ) : Prop :=
  d < 0 → 4 * b * z ≤ d ^ 2 →
    ∃ r : ℝ, 0 ≤ r ∧ r ^ 2 = d ^ 2 - 4 * b * z ∧
      v ≤ z * (z + 1) + (d * l - l - r) * K z

lemma delta_factor (z l : ℝ) :
    Delta z l = -(z - 1) * T z l := by
  unfold Delta K W N T
  ring

lemma f_difference (z l s v : ℝ) :
    F z l s v = F z l s (W z l) +
      (v - W z l) * (v - W z l + 2 * J z l) := by
  unfold F J
  ring

lemma f_baseline (z l s : ℝ) :
    F z l s (W z l) = (z ^ 2 - 1) * A z l * T z l +
      2 * z ^ 2 * (z ^ 2 - 1) * (s - S0 z l) := by
  unfold F W N B A T S0
  ring

lemma schwarzian_improvement (z l d b : ℝ) :
    schwarzian z l d b - S0 z l =
      -(d ^ 2 - 4 * b * z) * z ^ 2 / 2 +
      l ^ 2 * z ^ 2 * (2 * b + d ^ 2 / 2 - d) - d * z := by
  unfold schwarzian
  ring

lemma schwarzian_last (z l d b : ℝ) :
    schwarzian z l d b =
      -(d ^ 2 - 4 * b * z) * z ^ 2 / 2 +
      l ^ 2 * z ^ 2 * (2 * b + d ^ 2 / 2 - d + 3 / 2) -
      d * z - 3 / 2 := by
  unfold schwarzian S0
  ring

lemma threshold_pos {z l : ℝ} (hz : 1 < z) (hl : 0 < l) (hl1 : l < 1) :
    0 < W z l := by
  have htwo : 0 < 2 * z - 1 := by linarith only [hz]
  have heq : N z l =
      (1 - l) * (2 * z - 1) + l * (z - 1) ^ 3 * (z + 1) := by
    unfold N
    ring
  have h1 : 0 < (1 - l) * (2 * z - 1) := by positivity
  have h2 : 0 < l * (z - 1) ^ 3 * (z + 1) := by positivity
  unfold W
  rw [heq]
  linarith

lemma threshold_neg {z l : ℝ} (hz : 0 < z) (hz1 : z < 1) (hl : 1 < l) :
    W z l < 0 := by
  have htwo : 0 < 2 - z := by linarith only [hz1]
  have heq : N z l =
      -(1 - z) ^ 3 * (z + 1) - (l - 1) * z ^ 3 * (2 - z) := by
    unfold N
    ring
  have h1 : 0 < (1 - z) ^ 3 * (z + 1) := by positivity
  have h2 : 0 < (l - 1) * z ^ 3 * (2 - z) := by positivity
  unfold W
  rw [heq]
  linarith

lemma j_pos {z l : ℝ} (hz : 1 < z) (hl : 0 < l) (hl1 : l < 1) :
    0 < J z l := by
  have heq : J z l =
      (1 - l) * ((z - 1) ^ 2 + 4 * (z - 1) + 1) +
      l * (2 * (z - 1) * (z + 1) * ((z - 1) ^ 2 + (z - 1) + 1)) := by
    unfold J W N B
    ring
  rw [heq]
  positivity

lemma a_pos {z l : ℝ} (hz : 1 < z) (hl : 0 < l) (hl1 : l < 1) :
    0 < A z l := by
  have heq : A z l =
      (1 - l) * (3 * (z - 1) + 1) +
      l * (z - 1) * (2 * (z - 1) ^ 2 + 3 * (z - 1) + 3) := by
    unfold A
    ring
  rw [heq]
  positivity

lemma riccati_delta {z l d v r : ℝ}
    (hz : 0 < z) (hl : 0 < l) (hd : d < 0)
    (hvw : W z l ≤ v)
    (hric : v ≤ z * (z + 1) + (d * l - l - r) * K z) :
    r * K z < Delta z l := by
  have hd0 : 0 < -d := neg_pos.mpr hd
  have hk : 0 < K z := by unfold K; positivity
  have hp : 0 < -d * l * K z := by positivity
  have hle : r * K z - d * l * K z ≤ Delta z l := by
    unfold Delta
    nlinarith only [hvw, hric]
  linarith only [hp, hle]

lemma large_l_s_pos {z l d b : ℝ}
    (hz : 1 < z) (hl : 1 ≤ l) (hd : d < 0) (hb : 0 < b) :
    0 < schwarzian z l d b := by
  have hd0 : 0 < -d := neg_pos.mpr hd
  have hz0 : 0 < z := by linarith
  have hl0 : 0 < l := by linarith
  have hz2 : 0 < z ^ 2 - 1 := by nlinarith only [hz]
  have hl2 : 0 ≤ l ^ 2 - 1 := by nlinarith only [hl]
  have hlz : 0 < l ^ 2 * z ^ 2 - 1 := by
    have hp : 0 ≤ (l ^ 2 - 1) * z ^ 2 := by positivity
    nlinarith only [hp, hz2]
  have h1 : 0 < 2 * b * z ^ 2 * (z + l ^ 2) := by positivity
  have h2 : 0 ≤ d ^ 2 / 2 * (l ^ 2 - 1) * z ^ 2 := by positivity
  have h3 : 0 < -d * (z + l ^ 2 * z ^ 2) := by positivity
  have h4 : 0 < (3 / 2 : ℝ) * (l ^ 2 * z ^ 2 - 1) := by positivity
  unfold schwarzian S0
  nlinarith only [h1, h2, h3, h4]

lemma large_l_f_pos {z l d b v : ℝ}
    (hz : 1 < z) (hl : 1 ≤ l) (hd : d < 0) (hb : 0 < b) (hv : 0 ≤ v) :
    0 < F z l (schwarzian z l d b) v := by
  have hz0 : 0 < z := by linarith
  have hz2 : 0 < z ^ 2 - 1 := by nlinarith only [hz]
  have hB : 0 < B z l := by
    have hlm : 0 ≤ l - 1 := sub_nonneg.mpr hl
    have htwo : 0 < 2 * z - 1 := by linarith only [hz]
    have heq : B z l = (l - 1) * z * (2 * z - 1) + 2 * (z ^ 2 - 1) := by
      unfold B
      ring
    rw [heq]
    positivity
  have hs := large_l_s_pos hz hl hd hb
  have h1 : 0 ≤ v ^ 2 := sq_nonneg v
  have h2 : 0 ≤ 2 * z * B z l * v := by positivity
  have h3 : 0 < 2 * z ^ 2 * (z ^ 2 - 1) * schwarzian z l d b := by positivity
  unfold F
  linarith only [h1, h2, h3]

lemma t_negative_slope {z l d : ℝ}
    (hz : 1 < z) (hl : 0 < l) (ht : T z l < 0)
    (hx : d * z * (1 + l) < l - z) :
    2 < z ∧ 2 < -d * z := by
  have htwo : 0 < 2 * z - 1 := by linarith only [hz]
  have heq : T z l = l * z ^ 2 * (2 * z - 1) - (z - 2) := by
    unfold T
    ring
  rw [heq] at ht
  have hp : 0 < l * z ^ 2 * (2 * z - 1) := by positivity
  have hz2 : 2 < z := by linarith only [ht, hp]
  have hmargin : 3 < z ^ 2 * (2 * z - 1) := by
    have hprod : 0 < (z ^ 2 - 1) * (2 * z - 1) := by
      have : 0 < z ^ 2 - 1 := by nlinarith only [hz]
      positivity
    nlinarith only [hprod, hz2]
  have hmul : 0 < l * (z ^ 2 * (2 * z - 1) - 3) := by positivity
  have hstrong : 2 + 3 * l < z := by nlinarith only [ht, hmul]
  have hdz : 2 < -d * z := by
    by_contra! h
    have hp2 : 0 ≤ (d * z + 2) * (1 + l) := by
      apply mul_nonneg
      · linarith only [h]
      · positivity
    nlinarith only [hp2, hx, hstrong]
  exact ⟨hz2, hdz⟩

lemma obstruction {z l d b v : ℝ}
    (hz : 1 < z) (hl : 0 < l) (hl1 : l < 1)
    (hd : d < 0) (hb : 0 < b)
    (hx : d * z * (1 + l) < l - z)
    (hric : Riccati z l d b v) (hvw : W z l ≤ v) :
    0 < F z l (schwarzian z l d b) v := by
  have hz0 : 0 < z := by linarith
  have hd0 : 0 < -d := neg_pos.mpr hd
  have htwo : 0 < 2 * z - 1 := by linarith only [hz]
  have hbracket : 0 < 2 * b + d ^ 2 / 2 - d := by
    nlinarith only [hb, hd, sq_nonneg d]
  have hbracket2 : 0 < 2 * b + d ^ 2 / 2 - d + 3 / 2 := by
    linarith only [hbracket]
  have hk : 0 < K z := by unfold K; positivity
  have hz2 : 0 < z ^ 2 - 1 := by nlinarith only [hz]
  have hw := threshold_pos hz hl hl1
  have hv : 0 < v := lt_of_lt_of_le hw hvw
  by_cases ht : 0 ≤ T z l
  · have hdisc : d ^ 2 < 4 * b * z := by
      by_contra! h
      obtain ⟨r, hr, _, hbound⟩ := hric hd h
      have hdel := riccati_delta hz0 hl hd hvw hbound
      have hrk : 0 ≤ r * K z := by positivity
      have hnonpos : Delta z l ≤ 0 := by
        rw [delta_factor]
        have : 0 ≤ (z - 1) * T z l := by positivity
        linarith only [this]
      linarith only [hdel, hrk, hnonpos]
    have hs : 0 < schwarzian z l d b - S0 z l := by
      rw [schwarzian_improvement]
      have hq : 0 < -(d ^ 2 - 4 * b * z) := by linarith only [hdisc]
      have h1 : 0 < -(d ^ 2 - 4 * b * z) * z ^ 2 / 2 := by positivity
      have h2 : 0 ≤ l ^ 2 * z ^ 2 * (2 * b + d ^ 2 / 2 - d) := by positivity
      have h3 : 0 < -d * z := by positivity
      linarith only [h1, h2, h3]
    have ha := a_pos hz hl hl1
    have hbase : 0 < F z l (schwarzian z l d b) (W z l) := by
      rw [f_baseline]
      have h1 : 0 ≤ (z ^ 2 - 1) * A z l * T z l := by positivity
      have h2 : 0 < 2 * z ^ 2 * (z ^ 2 - 1) *
          (schwarzian z l d b - S0 z l) := by positivity
      linarith only [h1, h2]
    have hj := j_pos hz hl hl1
    have hrem : 0 ≤ (v - W z l) * (v - W z l + 2 * J z l) := by
      have : 0 ≤ v - W z l := by linarith only [hvw]
      positivity
    rw [f_difference]
    linarith only [hbase, hrem]
  · have htneg : T z l < 0 := lt_of_not_ge ht
    obtain ⟨hzgt2, hdz⟩ := t_negative_slope hz hl htneg hx
    have hpositive : 0 < l ^ 2 * z ^ 2 *
        (2 * b + d ^ 2 / 2 - d + 3 / 2) := by positivity
    have hs : 0 < schwarzian z l d b := by
      by_cases hdisc : d ^ 2 ≤ 4 * b * z
      · rw [schwarzian_last]
        have hq : 0 ≤ -(d ^ 2 - 4 * b * z) := by linarith only [hdisc]
        have h1 : 0 ≤ -(d ^ 2 - 4 * b * z) * z ^ 2 / 2 := by positivity
        linarith only [h1, hpositive, hdz]
      · have hdiscgt : 4 * b * z < d ^ 2 := lt_of_not_ge hdisc
        obtain ⟨r, hr, hr2, hbound⟩ := hric hd (le_of_lt hdiscgt)
        have hdel := riccati_delta hz0 hl hd hvw hbound
        have hupper : Delta z l < z * (z + 1) := by
          have hlk : 0 < l * K z := by positivity
          unfold Delta
          linarith only [hlk, hw]
        have hrz : r * z < 1 := by
          by_contra! h
          have hmul := mul_le_mul_of_nonneg_right h
            (show 0 ≤ z * (z + 1) by positivity)
          have hbad : z * (z + 1) ≤ r * K z := by
            unfold K
            nlinarith only [hmul]
          linarith only [hbad, hdel, hupper]
        have hrz0 : 0 ≤ r * z := by positivity
        have hsq : (r * z) ^ 2 < 1 := by nlinarith only [hrz, hrz0]
        have hidentity : (d ^ 2 - 4 * b * z) * z ^ 2 = (r * z) ^ 2 := by
          rw [← hr2]
          ring
        have hq : (d ^ 2 - 4 * b * z) * z ^ 2 < 1 := by
          rw [hidentity]
          exact hsq
        rw [schwarzian_last]
        linarith only [hq, hpositive, hdz]
    have hB : 0 < B z l := by
      unfold B
      have hp : 0 < l * z * (2 * z - 1) := by positivity
      linarith only [hzgt2, hp]
    have h1 : 0 ≤ v ^ 2 := sq_nonneg v
    have h2 : 0 < 2 * z * B z l * v := by positivity
    have h3 : 0 < 2 * z ^ 2 * (z ^ 2 - 1) * schwarzian z l d b := by positivity
    unfold F
    linarith only [h1, h2, h3]

theorem endpoint_zero_sign
    (z l d b v : ℝ) (hz : 0 < z) (hl : 0 < l) (hb : 0 < b)
    (hx : d * z * (1 + l) < l - z)
    (hsmall : z ≤ 1 → 1 < l ∧ 0 < v)
    (hnegative : 1 < z → d < 0)
    (hlarge : 1 < z → 1 ≤ l → 0 ≤ v)
    (hric : Riccati z l d b v)
    (hzero : F z l (schwarzian z l d b) v = 0) :
    z ≠ 1 ∧ 0 < (W z l - v) / (z - 1) := by
  have hne : z ≠ 1 := by
    intro heq
    subst z
    obtain ⟨hll, hv⟩ := hsmall le_rfl
    have hformula : F 1 l (schwarzian 1 l d b) v =
        v * (v + 2 * (l - 1)) := by
      unfold F B
      ring
    have hp : 0 < v * (v + 2 * (l - 1)) := by positivity
    rw [hformula] at hzero
    linarith only [hp, hzero]
  refine ⟨hne, ?_⟩
  by_cases hzlt : z < 1
  · obtain ⟨hll, hv⟩ := hsmall (le_of_lt hzlt)
    have hw := threshold_neg hz hzlt hll
    apply div_pos_of_neg_of_neg
    · linarith only [hw, hv]
    · linarith only [hzlt]
  · have hzgt : 1 < z := lt_of_le_of_ne (le_of_not_gt hzlt) (Ne.symm hne)
    have hd := hnegative hzgt
    by_cases hll : 1 ≤ l
    · have hp := large_l_f_pos hzgt hll hd hb (hlarge hzgt hll)
      linarith only [hp, hzero]
    · have hl1 : l < 1 := lt_of_not_ge hll
      have hvw : v < W z l := by
        by_contra! h
        have hp := obstruction hzgt hl hl1 hd hb hx hric h
        linarith only [hp, hzero]
      exact div_pos (sub_pos.mpr hvw) (sub_pos.mpr hzgt)

theorem endpoint_gamma_positive
    (z l d b v a : ℝ) (hz : 0 < z) (hl : 0 < l) (hb : 0 < b)
    (ha : 0 < a) (hx : d * z * (1 + l) < l - z)
    (hsmall : z ≤ 1 → 1 < l ∧ 0 < v)
    (hnegative : 1 < z → d < 0)
    (hlarge : 1 < z → 1 ≤ l → 0 ≤ v)
    (hric : Riccati z l d b v)
    (hzero : F z l (schwarzian z l d b) v = 0) :
    0 < a ^ 2 * (l * (z + 1) ^ 2 / ((1 + l) * z ^ 2 * K z)) *
      ((W z l - v) / (z - 1)) := by
  have hsign := (endpoint_zero_sign z l d b v hz hl hb hx hsmall
    hnegative hlarge hric hzero).2
  have hp : 0 < a ^ 2 * (l * (z + 1) ^ 2 / ((1 + l) * z ^ 2 * K z)) := by
    unfold K
    positivity
  exact mul_pos hp hsign

#print axioms endpoint_zero_sign
#print axioms endpoint_gamma_positive

end

end QuadraticZeroSign
