import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace SelectedBinCoefficient

theorem energy_maximum_branches {i H c : ℝ} (hi : i ≤ -2 * c) :
    (H ≤ 2 * c → max i (-H) = -H) ∧
    (2 * c < H → max i (-H) ≤ -2 * c) := by
  constructor
  · intro h
    exact max_eq_right (by linarith only [hi, h])
  · intro h
    exact max_le hi (by linarith only [h])

theorem occupation_maximum_envelope {i H c rho t : ℝ}
    (hi : i ≤ -2 * c) (hH : 2 * c ≤ H)
    (hrho : c ≤ rho) (ht : 0 ≤ t) :
    max 0 (max (i + 2 * rho + 2 * t) (-H + 2 * rho + 2 * t)) ≤
      2 * rho - 2 * c + 2 * t := by
  refine max_le ?_ (max_le ?_ ?_)
  · linarith only [hrho, ht]
  · linarith only [hi]
  · linarith only [hH]

theorem no_unsafe_selected_exponents
    {a b c z y H d : ℝ}
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c)
    (hz : 0 ≤ z) (hy : 0 ≤ y) (hH : 0 ≤ H)
    (hnorm : z + c = 1)
    (hdelta : d = (a + b + y + H) / 100000)
    (hnear : 2 * a + H / 2 + 2 * y < z + d)
    (henergy :
      (H ≤ 2 * c ∧ b < H / 2 - a + d) ∨
      (2 * c < H ∧ b < H - c - a + d))
    (hstable :
      3 / 10 < z - y → 3 / 10 < 1 - a - y →
      b < H / 2 + y + z / 500)
    (himproved :
      7 / 10 < z → 7 / 10 < 1 - a →
      (4 / 25) * z < y → (4 / 25) * (1 - a) < y →
      y < (49 / 100) * z → y < (49 / 100) * (1 - a) →
      b < H / 2 + (29 / 50) * y + d)
    (hunsafe0 : 2 * H / 3 + z / 6 - d / 3 < b)
    (hunsafe1 : b < H + 2 * y - z / 2 + d) :
    False := by
  have hd0 : 0 ≤ d := by
    linarith only [hdelta, ha, hb, hy, hH]
  have henergy_relaxed : b ≤ H - a + d := by
    rcases henergy with ⟨_, he⟩ | ⟨_, he⟩
    · linarith only [he, hH]
    · linarith only [he, hc]
  have hdsharp : d < (4 / 99995) * z := by
    linarith only [hnear, henergy_relaxed, hdelta, ha, hy]
  have hzpos : 0 < z := by
    linarith only [hd0, hdsharp]
  have hdsmall : d < z / 1000 := by
    linarith only [hdsharp, hzpos]
  have hhigh : 2 * c < H ∧ b < H - c - a + d := by
    rcases henergy with ⟨_, he⟩ | ⟨hh, he⟩
    · exfalso
      linarith only [he, hunsafe0, hdsmall, hzpos, ha, hH]
    · exact ⟨hh, he⟩
  have hHlower : (62 / 125) * z + 3 * (a + c) < H := by
    linarith only [hhigh.2, hunsafe0, hdsmall]
  have hactual_margin :
      (7 / 2) * a + (3 / 2) * c + 2 * y < (753 / 1000) * z := by
    linarith only [hnear, hHlower, hdsmall]
  have hzstage1 : 500 / 751 < z := by
    linarith only [hactual_margin, hnorm, ha, hy]
  have hyupper :
      y < (377 / 1000) * z - (7 / 4) * a - (3 / 4) * c := by
    linarith only [hactual_margin, hzpos]
  have hactual_receiver : 623 / 1000 < z - y := by
    linarith only [hyupper, hnorm, ha, hc]
  have hactual_source : 623 / 1000 < 1 - a - y := by
    linarith only [hyupper, hnorm, ha, hc]
  have hstable_far : b < H / 2 + y + z / 500 :=
    hstable
      (by linarith only [hactual_receiver])
      (by linarith only [hactual_source])
  have hmiddle : H / 3 + (41 / 125) * z < 2 * y := by
    linarith only [hstable_far, hunsafe0, hdsmall, hzpos]
  have hHupper : H < (2019 / 2500) * z := by
    linarith only [hmiddle, hnear, hdsmall, ha]
  have hasmall : a + c < (21 / 200) * z := by
    linarith only [hHlower, hHupper, hzpos]
  have hzhigh : 200 / 221 < z := by
    linarith only [hasmall, hnorm, ha]
  have hphigh : 179 / 200 < 1 - a := by
    linarith only [hasmall, hnorm, hc]
  have hylower : (19 / 100) * z < y := by
    linarith only [hunsafe0, hunsafe1, hHupper, hdsmall, hzpos]
  have hreceiver_lower : (4 / 25) * z < y := by
    linarith only [hylower, hzpos]
  have hsource_lower : (4 / 25) * (1 - a) < y := by
    linarith only [hylower, hzhigh, ha]
  have hreceiver_upper : y < (49 / 100) * z := by
    linarith only [hyupper, ha, hc, hzpos]
  have hsource_upper : y < (49 / 100) * (1 - a) := by
    linarith only [hyupper, hnorm, ha, hc, hz]
  have himproved_far : b < H / 2 + (29 / 50) * y + d :=
    himproved
      (by linarith only [hzhigh])
      (by linarith only [hphigh])
      hreceiver_lower hsource_lower hreceiver_upper hsource_upper
  have hbeta_lower : H / 3 + (33 / 100) * z < (29 / 25) * y := by
    linarith only [himproved_far, hunsafe0, hdsmall, hzpos]
  have hbeta_upper :
      (29 / 25) * y < (291 / 500) * z - (29 / 100) * H := by
    linarith only [hnear, ha, hdsmall, hzpos]
  have hHfinal : H < (378 / 935) * z := by
    linarith only [hbeta_lower, hbeta_upper]
  linarith only [hHlower, hHfinal, ha, hc, hzpos]

end SelectedBinCoefficient
