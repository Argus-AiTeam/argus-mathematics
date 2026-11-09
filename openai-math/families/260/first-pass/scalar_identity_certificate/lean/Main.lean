import Mathlib

noncomputable section

namespace ScalarIdentityCertificate

def d (a : ℝ) : ℝ := 1 - a ^ 2
def q (k p a : ℝ) : ℝ := k + p * a ^ 2
def s (k p : ℝ) : ℝ := p + (k - 1) / 2
def chi (k p a : ℝ) : ℝ := k * d a / q k p a
def transverse (k p a : ℝ) : ℝ :=
  k * s k p - (k - 1) ^ 2 * a ^ 2 / 4
def axialX (k p a : ℝ) : ℝ := k * s k p * d a
def axialF (k : ℝ) : ℝ := (k + 1) / (2 * k)
def B (k a : ℝ) : ℝ := (k * (k + 2) + a ^ 2) / (2 * (k + 1))
def axialJ (k p a : ℝ) : ℝ := k * d a * B k a / (q k p a) ^ 2

def quadratic (k p a t0 z2 y2 F j x : ℝ) : ℝ :=
  t0 / 2 + z2 + transverse k p a * y2 + axialX k p a * x ^ 2
    - (k - 1) / (2 * k) * (F - chi k p a * j) ^ 2
    + chi k p a * j ^ 2 - chi k p a * F * j + F ^ 2
    + 2 * s k p * chi k p a * j * a * x

def completed (k p a t0 z2 y2 F j x : ℝ) : ℝ :=
  t0 / 2 + z2 + transverse k p a * y2
    + axialX k p a * (x + a / q k p a * j) ^ 2
    + axialF k * (F - chi k p a / (k + 1) * j) ^ 2
    + axialJ k p a * j ^ 2

theorem completed_axial (k p a t0 z2 y2 F j x : ℝ)
    (hk : k ≠ 0) (hk1 : k + 1 ≠ 0) (hq : q k p a ≠ 0) :
    quadratic k p a t0 z2 y2 F j x = completed k p a t0 z2 y2 F j x := by
  unfold quadratic completed transverse axialX axialF axialJ chi B s d
  field_simp [hk, hk1, hq]
  <;> simp only [q]
  <;> ring

theorem cutoff_redistribution (p1 cp a x j v y2 : ℝ) :
    p1 * cp * a * x * j - p1 * (v * y2 + cp * a * x * j) =
      -p1 * v * y2 := by
  ring

theorem graph_divergence_algebra
    (p p1 a x y2 r hnorm m2 my j ht ric : ℝ) :
    -ric + (r ^ 2 - hnorm) / 2
        + r * ((1 - a ^ 2) * j + p * a * x * (2 - a ^ 2))
        - (1 - a ^ 2) * (m2 + 2 * p * a * my + p ^ 2 * a ^ 2 * y2)
        - p * a ^ 2 * ht - (p1 + p ^ 2) * a ^ 2 * y2 =
      -((hnorm + 2 * (m2 + 2 * p * a * my + p ^ 2 * a ^ 2 * y2)
          + (j + 2 * p * a * x) ^ 2) - (r + j + 2 * p * a * x) ^ 2) / 2
        - ric
        - (p * (1 - a ^ 2) * a * (my + j * x)
          - a ^ 2 * (m2 + j ^ 2)
          - (r + j) * (p * (1 - a ^ 2) * a * x - a ^ 2 * j))
        - (p1 * a ^ 2 * y2 + p * (a ^ 2 * ht
          - (1 + a ^ 2) * a * my + r * a * x
          + p * (1 - a ^ 2) * a ^ 2 * y2)) := by
  ring

theorem shift_recovery (m c y : ℝ) :
    m ^ 2 ≤ 2 * (m + c * y) ^ 2 + 2 * c ^ 2 * y ^ 2 := by
  nlinarith only [sq_nonneg (m + 2 * c * y)]

theorem finite_shift_recovery {ι : Type*} (I : Finset ι) (m y : ι → ℝ) (c : ℝ) :
    (∑ i ∈ I, m i ^ 2) ≤
      2 * (∑ i ∈ I, (m i + c * y i) ^ 2) + 2 * c ^ 2 * (∑ i ∈ I, y i ^ 2) := by
  calc
    (∑ i ∈ I, m i ^ 2) ≤
        ∑ i ∈ I, (2 * (m i + c * y i) ^ 2 + 2 * c ^ 2 * y i ^ 2) :=
      Finset.sum_le_sum fun i _ => shift_recovery (m i) c (y i)
    _ = _ := by simp only [Finset.sum_add_distrib, Finset.mul_sum]

theorem coefficient_bounds (k p a : ℝ)
    (hk : 2 ≤ k) (hp : 0 ≤ p) (ha : a ^ 2 < 1) :
    0 < d a ∧
    (1 / 2 : ℝ) ≤ transverse k p a ∧
    d a ≤ axialX k p a ∧
    (1 / 2 : ℝ) ≤ axialF k ∧
    0 ≤ axialJ k p a ∧
    d a ≤ 2 * (1 + p) ^ 2 * axialJ k p a ∧
    (chi k p a) ^ 2 ≤ d a ∧
    (chi k p a / (k + 1)) ^ 2 ≤ d a ∧
    (a / q k p a) ^ 2 ≤ 1 ∧
    (s k p) ^ 2 * a ^ 2 ≤ k ^ 2 * (1 + p) ^ 2 := by
  have hk0 : 0 < k := by linarith
  have hk1 : 0 < k + 1 := by linarith
  have hd : 0 < d a := by unfold d; linarith
  have hd1 : d a ≤ 1 := by unfold d; nlinarith only [sq_nonneg a]
  have hq : 0 < q k p a := by unfold q; positivity
  have hqk : k ≤ q k p a := by
    unfold q
    nlinarith only [mul_nonneg hp (sq_nonneg a)]
  have hs : 0 ≤ s k p := by unfold s; linarith
  have hA : (1 / 2 : ℝ) ≤ transverse k p a := by
    have hprod := mul_nonneg (sq_nonneg (k - 1)) (le_of_lt hd)
    have hkp := mul_nonneg (le_of_lt hk0) hp
    unfold transverse s d at *
    nlinarith
  have hX : d a ≤ axialX k p a := by
    have hbase : 1 ≤ k * s k p := by
      have hprod := mul_nonneg (by linarith : 0 ≤ k - 2)
        (by linarith : 0 ≤ k + 1)
      have hkp := mul_nonneg (le_of_lt hk0) hp
      unfold s
      nlinarith
    unfold axialX
    nlinarith only [mul_nonneg (by linarith : 0 ≤ k * s k p - 1) (le_of_lt hd)]
  have hF : (1 / 2 : ℝ) ≤ axialF k := by
    unfold axialF
    apply (le_div_iff₀ (by positivity : 0 < 2 * k)).2
    linarith
  have hB : 0 < B k a := by unfold B; positivity
  have hJ : 0 ≤ axialJ k p a := by unfold axialJ; positivity
  have hpoly :
      2 * (1 + p) ^ 2 * k * B k a - (q k p a) ^ 2 =
        p * (k - a ^ 2) * (k * (1 + p) + q k p a)
          + k * (k + a ^ 2) / (k + 1) * (1 + p) ^ 2 := by
    unfold B q
    field_simp
    <;> ring
  have hpoly0 : 0 ≤
      p * (k - a ^ 2) * (k * (1 + p) + q k p a)
        + k * (k + a ^ 2) / (k + 1) * (1 + p) ^ 2 := by
    have : 0 ≤ k - a ^ 2 := by linarith
    positivity
  have hnum : (q k p a) ^ 2 ≤ 2 * (1 + p) ^ 2 * k * B k a := by
    linarith
  have hJbound : d a ≤ 2 * (1 + p) ^ 2 * axialJ k p a := by
    unfold axialJ
    have hform : 2 * (1 + p) ^ 2 * (k * d a * B k a / (q k p a) ^ 2) =
        (2 * (1 + p) ^ 2 * k * d a * B k a) / (q k p a) ^ 2 := by ring
    rw [hform]
    apply (le_div_iff₀ (sq_pos_of_pos hq)).2
    nlinarith only [mul_nonneg (le_of_lt hd) (sub_nonneg.mpr hnum)]
  have hc0 : 0 ≤ chi k p a := by unfold chi; positivity
  have hcd : chi k p a ≤ d a := by
    unfold chi
    apply (div_le_iff₀ hq).2
    nlinarith only [mul_nonneg (le_of_lt hd) (sub_nonneg.mpr hqk)]
  have hc2 : (chi k p a) ^ 2 ≤ d a := by
    nlinarith only [
      mul_nonneg (sub_nonneg.mpr hcd) (by positivity : 0 ≤ d a + chi k p a),
      mul_nonneg (le_of_lt hd) (sub_nonneg.mpr hd1)]
  have hg0 : 0 ≤ chi k p a / (k + 1) := by positivity
  have hgc : chi k p a / (k + 1) ≤ chi k p a := by
    apply (div_le_iff₀ hk1).2
    nlinarith only [mul_nonneg hc0 (le_of_lt hk0)]
  have hg2 : (chi k p a / (k + 1)) ^ 2 ≤ d a := by
    nlinarith only [hc2,
      mul_nonneg (sub_nonneg.mpr hgc)
        (by positivity : 0 ≤ chi k p a + chi k p a / (k + 1))]
  have hh2 : (a / q k p a) ^ 2 ≤ 1 := by
    rw [div_pow]
    apply (div_le_iff₀ (sq_pos_of_pos hq)).2
    nlinarith only [ha, hk, hqk, sq_nonneg (q k p a - k)]
  have hsr : s k p ≤ k * (1 + p) := by
    have hprod := mul_nonneg hp (by linarith : 0 ≤ k - 1)
    unfold s
    nlinarith
  have hss : (s k p) ^ 2 ≤ k ^ 2 * (1 + p) ^ 2 := by
    nlinarith only [
      mul_nonneg (sub_nonneg.mpr hsr)
        (by positivity : 0 ≤ k * (1 + p) + s k p)]
  have hsv : (s k p) ^ 2 * a ^ 2 ≤ k ^ 2 * (1 + p) ^ 2 := by
    nlinarith only [hss, mul_nonneg (sq_nonneg (s k p))
      (by linarith : 0 ≤ 1 - a ^ 2)]
  exact ⟨hd, hA, hX, hF, hJ, hJbound, hc2, hg2, hh2, hsv⟩

theorem reconstruction
    (k r s a d chi g h A alpha beta gamma t0 z2 y2 m2 F j x E : ℝ)
    (hk : 2 ≤ k) (hr : 1 ≤ r) (hd : 0 ≤ d)
    (ht0 : 0 ≤ t0) (hz2 : 0 ≤ z2) (hy2 : 0 ≤ y2)
    (hA : (1 / 2 : ℝ) ≤ A) (halpha : d ≤ alpha)
    (hbeta : (1 / 2 : ℝ) ≤ beta) (hgamma0 : 0 ≤ gamma)
    (hgamma : d ≤ 2 * r ^ 2 * gamma)
    (hchi : chi ^ 2 ≤ d) (hg : g ^ 2 ≤ d) (hh : h ^ 2 ≤ 1)
    (hsa : s ^ 2 * a ^ 2 ≤ k ^ 2 * r ^ 2)
    (hm : m2 ≤ 2 * z2 + 2 * s ^ 2 * a ^ 2 * y2)
    (he : E = t0 / 2 + z2 + A * y2
      + alpha * (x + h * j) ^ 2 + beta * (F - g * j) ^ 2 + gamma * j ^ 2) :
    0 ≤ E ∧
    t0 + (F - chi * j) ^ 2 / k + m2 + d * j ^ 2 + F ^ 2 + y2 + d * x ^ 2
      ≤ (32 + 4 * k ^ 2) * r ^ 2 * E := by
  have hk0 : 0 < k := by linarith
  have hA0 : 0 ≤ A := by linarith
  have halpha0 : 0 ≤ alpha := le_trans hd halpha
  have hbeta0 : 0 ≤ beta := by linarith
  have hAy : 0 ≤ A * y2 := mul_nonneg hA0 hy2
  have hax : 0 ≤ alpha * (x + h * j) ^ 2 := by positivity
  have hbf : 0 ≤ beta * (F - g * j) ^ 2 := by positivity
  have hgj : 0 ≤ gamma * j ^ 2 := by positivity
  have hE : 0 ≤ E := by linarith
  have hr2 : 1 ≤ r ^ 2 := by nlinarith only [hr, sq_nonneg (r - 1)]
  have hEr : E ≤ r ^ 2 * E := by
    nlinarith only [mul_nonneg hE (sub_nonneg.mpr hr2)]
  have htE : t0 ≤ 2 * E := by linarith
  have hzE : z2 ≤ E := by linarith
  have hyE : y2 ≤ 2 * E := by
    have := mul_le_mul_of_nonneg_right hA hy2
    linarith
  have hxE : d * (x + h * j) ^ 2 ≤ E := by
    have := mul_le_mul_of_nonneg_right halpha (sq_nonneg (x + h * j))
    linarith
  have hfE : (F - g * j) ^ 2 ≤ 2 * E := by
    have := mul_le_mul_of_nonneg_right hbeta (sq_nonneg (F - g * j))
    linarith
  have hjE : gamma * j ^ 2 ≤ E := by linarith
  have hdj : d * j ^ 2 ≤ 2 * r ^ 2 * E := by
    calc
      d * j ^ 2 ≤ (2 * r ^ 2 * gamma) * j ^ 2 :=
        mul_le_mul_of_nonneg_right hgamma (sq_nonneg j)
      _ = 2 * r ^ 2 * (gamma * j ^ 2) := by ring
      _ ≤ 2 * r ^ 2 * E :=
        mul_le_mul_of_nonneg_left hjE (by positivity)
  have hgj2 : (g * j) ^ 2 ≤ d * j ^ 2 := by
    nlinarith only [mul_le_mul_of_nonneg_right hg (sq_nonneg j)]
  have hFrec : F ^ 2 ≤ 2 * (F - g * j) ^ 2 + 2 * (g * j) ^ 2 := by
    nlinarith only [sq_nonneg (F - 2 * g * j)]
  have hFbound : F ^ 2 ≤ 8 * r ^ 2 * E := by
    nlinarith only [hFrec, hfE, hgj2, hdj, hEr]
  have hchij : (chi * j) ^ 2 ≤ d * j ^ 2 := by
    nlinarith only [mul_le_mul_of_nonneg_right hchi (sq_nonneg j)]
  have htrace : (F - chi * j) ^ 2 / k ≤ F ^ 2 + d * j ^ 2 := by
    apply (div_le_iff₀ hk0).2
    nlinarith only [sq_nonneg (F + chi * j), hchij,
      mul_nonneg (by linarith : 0 ≤ k - 2)
        (by positivity : 0 ≤ F ^ 2 + d * j ^ 2)]
  have htbound : t0 + (F - chi * j) ^ 2 / k ≤ 12 * r ^ 2 * E := by
    linarith
  have hxrec : x ^ 2 ≤ 2 * (x + h * j) ^ 2 + 2 * (h * j) ^ 2 := by
    nlinarith only [sq_nonneg (x + 2 * h * j)]
  have hhj : d * (h * j) ^ 2 ≤ d * j ^ 2 := by
    nlinarith only [
      mul_le_mul_of_nonneg_left
        (mul_le_mul_of_nonneg_right hh (sq_nonneg j)) hd]
  have hxbound : d * x ^ 2 ≤ 6 * r ^ 2 * E := by
    nlinarith only [mul_le_mul_of_nonneg_left hxrec hd, hxE, hhj, hdj, hEr]
  have hmy : s ^ 2 * a ^ 2 * y2 ≤ k ^ 2 * r ^ 2 * y2 :=
    mul_le_mul_of_nonneg_right hsa hy2
  have hyscale : k ^ 2 * r ^ 2 * y2 ≤ 2 * k ^ 2 * r ^ 2 * E := by
    nlinarith only [mul_le_mul_of_nonneg_left hyE
      (by positivity : 0 ≤ k ^ 2 * r ^ 2)]
  have hmbound : m2 ≤ (2 + 4 * k ^ 2) * r ^ 2 * E := by
    nlinarith only [hm, hzE, hmy, hyscale, hEr]
  have hybound : y2 ≤ 2 * r ^ 2 * E := by linarith
  exact ⟨hE, by nlinarith only [htbound, hmbound, hdj, hFbound, hybound, hxbound]⟩

theorem coercivity
    (k p a t0 z2 y2 m2 F j x : ℝ)
    (hk : 2 ≤ k) (hp : 0 ≤ p) (ha : a ^ 2 < 1)
    (ht0 : 0 ≤ t0) (hz2 : 0 ≤ z2) (hy2 : 0 ≤ y2)
    (hm : m2 ≤ 2 * z2 + 2 * (s k p) ^ 2 * a ^ 2 * y2) :
    0 ≤ quadratic k p a t0 z2 y2 F j x ∧
    t0 + (F - chi k p a * j) ^ 2 / k + m2 + d a * j ^ 2 + F ^ 2
      + y2 + d a * x ^ 2 ≤
      (32 + 4 * k ^ 2) * (1 + p) ^ 2 * quadratic k p a t0 z2 y2 F j x := by
  obtain ⟨hd, hA, hX, hF, hJ, hJbound, hc2, hg2, hh2, hsv⟩ :=
    coefficient_bounds k p a hk hp ha
  have hk0 : k ≠ 0 := by linarith
  have hk1 : k + 1 ≠ 0 := by linarith
  have hq : q k p a ≠ 0 := by
    have : 0 < q k p a := by unfold q; positivity
    linarith
  have he := completed_axial k p a t0 z2 y2 F j x hk0 hk1 hq
  exact reconstruction k (1 + p) (s k p) a (d a) (chi k p a)
    (chi k p a / (k + 1)) (a / q k p a) (transverse k p a)
    (axialX k p a) (axialF k) (axialJ k p a) t0 z2 y2 m2 F j x
    (quadratic k p a t0 z2 y2 F j x) hk (by linarith) (le_of_lt hd)
    ht0 hz2 hy2 hA hX hF hJ hJbound hc2 hg2 hh2 hsv hm he

theorem coercivity_in_N
    (k p N a t0 z2 y2 m2 F j x : ℝ)
    (hk : 2 ≤ k) (hp : 0 ≤ p) (hpN : p ≤ N) (ha : a ^ 2 < 1)
    (ht0 : 0 ≤ t0) (hz2 : 0 ≤ z2) (hy2 : 0 ≤ y2)
    (hm : m2 ≤ 2 * z2 + 2 * (s k p) ^ 2 * a ^ 2 * y2) :
    t0 + (F - chi k p a * j) ^ 2 / k + m2 + d a * j ^ 2 + F ^ 2
      + y2 + d a * x ^ 2 ≤
      (32 + 4 * k ^ 2) * (1 + N) ^ 2 * quadratic k p a t0 z2 y2 F j x := by
  obtain ⟨hE, hb⟩ := coercivity k p a t0 z2 y2 m2 F j x hk hp ha ht0 hz2 hy2 hm
  have hsquares : (1 + p) ^ 2 ≤ (1 + N) ^ 2 := by
    nlinarith only [mul_nonneg (sub_nonneg.mpr hpN) (by linarith : 0 ≤ 2 + p + N)]
  have hscale : 0 ≤ (32 + 4 * k ^ 2) * quadratic k p a t0 z2 y2 F j x := by
    positivity
  nlinarith only [hb, mul_le_mul_of_nonneg_right hsquares hscale]

theorem stationary_coercivity (k c t0 m2 F j : ℝ)
    (hk : 2 ≤ k) (hc0 : 0 ≤ c) (hc1 : c ≤ 1)
    (ht0 : 0 ≤ t0) (hm2 : 0 ≤ m2) :
    let E := t0 / 2 + m2 + (k + 1) / (2 * k) * (F - c / (k + 1) * j) ^ 2
      + c * (1 - k * c / (2 * (k + 1))) * j ^ 2
    (t0 + m2 + F ^ 2 + c * j ^ 2) / 16 ≤ E ∧
      E ≤ 3 * (t0 + m2 + F ^ 2 + c * j ^ 2) := by
  dsimp only
  let beta := (k + 1) / (2 * k)
  let g := c / (k + 1)
  let gamma := c * (1 - k * c / (2 * (k + 1)))
  let E := t0 / 2 + m2 + beta * (F - g * j) ^ 2 + gamma * j ^ 2
  change (t0 + m2 + F ^ 2 + c * j ^ 2) / 16 ≤ E ∧
    E ≤ 3 * (t0 + m2 + F ^ 2 + c * j ^ 2)
  have hk0 : 0 < k := by linarith
  have hk1 : 0 < k + 1 := by linarith
  have hb0 : (1 / 2 : ℝ) ≤ beta := by
    dsimp [beta]
    apply (le_div_iff₀ (by positivity : 0 < 2 * k)).2
    linarith
  have hb1 : beta ≤ 1 := by
    dsimp [beta]
    apply (div_le_iff₀ (by positivity : 0 < 2 * k)).2
    linarith
  have hg0 : 0 ≤ g := by dsimp [g]; positivity
  have hgc : g ≤ c := by
    dsimp [g]
    apply (div_le_iff₀ hk1).2
    nlinarith only [mul_nonneg hc0 (le_of_lt hk0)]
  have hg2 : g ^ 2 ≤ c := by
    nlinarith only [
      mul_nonneg (sub_nonneg.mpr hgc) (by positivity : 0 ≤ c + g),
      mul_nonneg hc0 (sub_nonneg.mpr hc1)]
  have hgam0 : c / 2 ≤ gamma := by
    dsimp [gamma]
    have hprod := mul_nonneg (mul_nonneg (le_of_lt hk0) hc0)
      (sub_nonneg.mpr hc1)
    apply (le_of_sub_nonneg ?_)
    field_simp
    nlinarith
  have hgam1 : gamma ≤ c := by
    dsimp [gamma]
    have : 0 ≤ k * c / (2 * (k + 1)) := by positivity
    nlinarith only [mul_nonneg hc0 this]
  have hbpos : 0 ≤ beta := by linarith
  have hgampos : 0 ≤ gamma := by linarith
  have hbf : 0 ≤ beta * (F - g * j) ^ 2 := by positivity
  have hgj : 0 ≤ gamma * j ^ 2 := by positivity
  have hE : 0 ≤ E := by dsimp [E]; positivity
  have htE : t0 ≤ 2 * E := by dsimp [E]; linarith
  have hmE : m2 ≤ E := by dsimp [E]; linarith
  have hfE : (F - g * j) ^ 2 ≤ 2 * E := by
    have := mul_le_mul_of_nonneg_right hb0 (sq_nonneg (F - g * j))
    dsimp [E]
    linarith
  have hcE : c * j ^ 2 ≤ 2 * E := by
    have := mul_le_mul_of_nonneg_right hgam0 (sq_nonneg j)
    dsimp [E]
    linarith
  have hgj2 : (g * j) ^ 2 ≤ c * j ^ 2 := by
    nlinarith only [mul_le_mul_of_nonneg_right hg2 (sq_nonneg j)]
  have hFrec : F ^ 2 ≤ 2 * (F - g * j) ^ 2 + 2 * (g * j) ^ 2 := by
    nlinarith only [sq_nonneg (F - 2 * g * j)]
  have hFE : F ^ 2 ≤ 8 * E := by linarith
  constructor
  · linarith
  · have hsquare : (F - g * j) ^ 2 ≤ 2 * F ^ 2 + 2 * (g * j) ^ 2 := by
      nlinarith only [sq_nonneg (F + g * j)]
    have hbeta_square := mul_le_mul_of_nonneg_right hb1 (sq_nonneg (F - g * j))
    have hgamma_square := mul_le_mul_of_nonneg_right hgam1 (sq_nonneg j)
    dsimp [E]
    nlinarith only [hsquare, hbeta_square, hgamma_square, hgj2, ht0, hm2,
      sq_nonneg F, mul_nonneg hc0 (sq_nonneg j)]

theorem quadratic_exponent_sharpness (p : ℝ)
    (hp : 0 ≤ p) :
    quadratic 2 p (1 / 2) 0 0 0 (1 / 2) (2 + p / 4) (-1 / 2) = 33 / 16 := by
  have hq : q 2 p (1 / 2) ≠ 0 := by
    unfold q
    nlinarith
  unfold quadratic transverse axialX chi s d
  field_simp [hq]
  <;> simp only [q]
  <;> ring

end ScalarIdentityCertificate
