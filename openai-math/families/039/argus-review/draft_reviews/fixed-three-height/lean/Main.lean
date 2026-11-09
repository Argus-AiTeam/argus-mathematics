import Mathlib

namespace ReshapingAudit

theorem primitive_three_in_interval (L U : ℝ) (h : 2 < U - L) :
    ∃ i p q : ℤ, L < (i : ℝ) ∧ (i : ℝ) < U ∧ i * q - 3 * p = 1 := by
  let n : ℤ := ⌊L⌋ + 1
  have hnL : L < (n : ℝ) := by
    simpa [n] using Int.lt_floor_add_one L
  have hnupper : (n : ℝ) ≤ L + 1 := by
    have hf := Int.floor_le L
    dsimp [n]
    push_cast
    linarith
  have hnU : (n : ℝ) < U := by linarith
  have hn1U : ((n + 1 : ℤ) : ℝ) < U := by
    push_cast
    linarith
  by_cases hn0 : n % 3 = 0
  · refine ⟨n + 1, n / 3, 1, ?_, hn1U, ?_⟩
    · push_cast
      linarith
    · omega
  · have hm : n % 3 = 1 ∨ n % 3 = 2 := by omega
    rcases hm with hm | hm
    · exact ⟨n, n / 3, 1, hnL, hnU, by omega⟩
    · exact ⟨n, -(n / 3) - 1, -1, hnL, hnU, by omega⟩

theorem fixed_three_height (H d w : ℝ)
    (hH : 0 < H) (hd : 0 < d) (hw : 0 < w)
    (hT : 6 ≤ d ^ 2 * H) (hsmall : d * w < 1 / 3) :
    let W := d * H
    let R := H / w
    let T := d * W
    let a0 := W * T / (1 + T)
    ∃ (i p q : ℤ) (a b t : ℝ),
      i * q - 3 * p = 1 ∧
      a0 < a ∧ a < W ∧ b = W - a ∧ 0 < b ∧
      t = a / b ∧ T < t ∧
      a = W * t / (1 + t) ∧ b = W / (1 + t) ∧
      -3 * a < 3 * b ∧ 3 * b < (i : ℝ) / d ∧
      (i : ℝ) / d + 3 * a = R := by
  let W := d * H
  let R := H / w
  let T := d * W
  let a0 := W * T / (1 + T)
  change ∃ (i p q : ℤ) (a b t : ℝ),
    i * q - 3 * p = 1 ∧
    a0 < a ∧ a < W ∧ b = W - a ∧ 0 < b ∧
    t = a / b ∧ T < t ∧
    a = W * t / (1 + t) ∧ b = W / (1 + t) ∧
    -3 * a < 3 * b ∧ 3 * b < (i : ℝ) / d ∧
    (i : ℝ) / d + 3 * a = R
  have hW : 0 < W := mul_pos hd hH
  have hT' : 6 ≤ T := by
    simpa [T, W, pow_two, mul_assoc] using hT
  have hden : 0 < 1 + T := by linarith
  have hR : 3 * W < R := by
    apply (lt_div_iff₀ hw).2
    have hmul := mul_lt_mul_of_pos_left (show 3 * (d * w) < 1 by linarith) hH
    dsimp [W]
    nlinarith [hmul]
  have hlen_eq :
      d * (R - 3 * a0) - d * (R - 3 * W) = 3 * T / (1 + T) := by
    dsimp [a0]
    field_simp
    dsimp [T]
    ring
  have hlen : 2 < d * (R - 3 * a0) - d * (R - 3 * W) := by
    rw [hlen_eq]
    apply (lt_div_iff₀ hden).2
    linarith
  obtain ⟨i, p, q, hiL, hiU, hbez⟩ :=
    primitive_three_in_interval (d * (R - 3 * W)) (d * (R - 3 * a0)) hlen
  let a := (R - (i : ℝ) / d) / 3
  let b := W - a
  let t := a / b
  have haeq : 3 * a = R - (i : ℝ) / d := by dsimp [a]; ring
  have hiupper : (i : ℝ) / d < R - 3 * a0 := by
    apply (div_lt_iff₀ hd).2
    nlinarith [hiU]
  have hilower : R - 3 * W < (i : ℝ) / d := by
    apply (lt_div_iff₀ hd).2
    nlinarith [hiL]
  have ha0 : a0 < a := by linarith
  have haW : a < W := by linarith
  have hb : 0 < b := by dsimp [b]; linarith
  have ht : T < t := by
    apply (lt_div_iff₀ hb).2
    have hs : W * T < a * (1 + T) := (div_lt_iff₀ hden).1 ha0
    dsimp [b]
    nlinarith [hs]
  have htden : 0 < 1 + t := by linarith
  have hbt : b * t = a := by
    dsimp [t]
    field_simp
  have hat : a = W * t / (1 + t) := by
    apply (eq_div_iff (ne_of_gt htden)).2
    dsimp [b] at hbt
    nlinarith [hbt]
  have hbf : b = W / (1 + t) := by
    apply (eq_div_iff (ne_of_gt htden)).2
    dsimp [b] at *
    nlinarith [hbt]
  refine ⟨i, p, q, a, b, t, hbez, ha0, haW, rfl, hb, rfl, ht, hat, hbf, ?_, ?_, ?_⟩
  · dsimp [b]
    linarith
  · dsimp [b]
    linarith
  · linarith

theorem tent_slice_length (q0 q1 q2 w h : ℝ) :
    (q2 + (q1 - q2) * (h / w)) - (q0 + (q1 - q0) * (h / w)) =
      (q2 - q0) * (1 - h / w) := by ring

theorem compressed_tent_inside_simplex (R w h z : ℝ)
    (hR : 0 < R) (hw : 0 < w) (hh : 0 ≤ h) (hhw : h ≤ w)
    (hz : 0 ≤ z) (hbound : z ≤ R * (1 - h / w)) :
    0 ≤ h ∧ 0 ≤ z ∧ h / w + z / R ≤ 1 := by
  have hzR : z / R ≤ 1 - h / w := by
    apply (div_le_iff₀ hR).2
    nlinarith [hbound]
  exact ⟨hh, hz, by linarith⟩

end ReshapingAudit
