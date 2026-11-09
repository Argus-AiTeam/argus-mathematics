import Mathlib

set_option autoImplicit false

noncomputable section

namespace ChordObstruction

structure Plane where
  n : ℝ → ℝ → ℝ
  nonneg : ∀ a b, 0 ≤ n a b
  add_le : ∀ a b c d, n (a + c) (b + d) ≤ n a b + n c d
  scale : ∀ k a b, 0 ≤ k → n (k * a) (k * b) = k * n a b
  neg : ∀ a b, n (-a) (-b) = n a b
  axis_v : ∀ a, n a 0 = |a|
  axis_y : ∀ b, n 0 b = |b|

def ofVectors {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (v y : E) (hv : ‖v‖ = 1) (hy : ‖y‖ = 1) : Plane where
  n a b := ‖a • v + b • y‖
  nonneg _ _ := norm_nonneg _
  add_le a b c d := by
    simpa only [add_smul, add_add_add_comm] using
      norm_add_le (a • v + b • y) (c • v + d • y)
  scale k a b hk := by
    rw [mul_smul, mul_smul, ← smul_add, norm_smul, Real.norm_eq_abs,
      abs_of_nonneg hk]
  neg a b := by simp only [neg_smul, ← neg_add, norm_neg]
  axis_v a := by simp [norm_smul, hv]
  axis_y b := by simp [norm_smul, hy]

namespace Plane

theorem combine_le (P : Plane) (l m a b c d : ℝ) (hl : 0 ≤ l) (hm : 0 ≤ m) :
    P.n (l * a + m * c) (l * b + m * d) ≤ l * P.n a b + m * P.n c d := by
  calc
    _ ≤ P.n (l * a) (l * b) + P.n (m * c) (m * d) := P.add_le _ _ _ _
    _ = _ := by rw [P.scale l a b hl, P.scale m c d hm]

theorem scaled_n (P : Plane) {l : ℝ} (hl : 0 < l) (a b : ℝ) :
    P.n a (l * b) = l * P.n (a / l) b := by
  have h := P.scale l (a / l) b hl.le
  have heq : l * (a / l) = a := by field_simp
  rwa [heq] at h

def flip (P : Plane) : Plane where
  n a b := P.n (-a) b
  nonneg a b := P.nonneg (-a) b
  add_le a b c d := by simpa only [neg_add] using P.add_le (-a) b (-c) d
  scale k a b hk := by simpa only [mul_neg] using P.scale k (-a) b hk
  neg a b := by simpa only [neg_neg] using P.neg (-a) b
  axis_v a := by simpa only [abs_neg] using P.axis_v (-a)
  axis_y b := by simpa only [neg_zero] using P.axis_y b

theorem flip_eq (P : Plane) (a b : ℝ) : P.flip.n a b = P.n a (-b) := by
  change P.n (-a) b = P.n a (-b)
  simpa only [neg_neg] using P.neg a (-b)

theorem inward (P : Plane) {c h : ℝ} (hc : 0 < c) (hh : 0 < h)
    (hn : P.n c h < c) :
    0 < h / c ∧ P.n 1 (h / c) < 1 := by
  refine ⟨div_pos hh hc, ?_⟩
  have heq : c * (h / c) = h := by field_simp
  have hscale := P.scale c 1 (h / c) hc.le
  rw [mul_one, heq] at hscale
  nlinarith

theorem inward_segment (P : Plane) {δ p η : ℝ}
    (hδ : 0 < δ) (_hp : 0 < p) (hη : 0 < η) (hηp : η ≤ p * δ)
    (hn : P.n 1 δ < 1) : P.n p η < p := by
  have hcoef : 0 ≤ p - η / δ := by
    have := (div_le_iff₀ hδ).2 hηp
    linarith
  have hsum := P.combine_le (η / δ) (p - η / δ) 1 δ 1 0
    (div_pos hη hδ).le hcoef
  have h1 : η / δ * 1 + (p - η / δ) * 1 = p := by ring
  have h2 : η / δ * δ + (p - η / δ) * 0 = η := by field_simp; ring
  rw [h1, h2, P.axis_v, abs_one] at hsum
  have := mul_lt_mul_of_pos_left hn (div_pos hη hδ)
  nlinarith

theorem outward (P : Plane) {δ s η : ℝ}
    (hδ : 0 < δ) (hs : 0 < s) (hη : 0 < η)
    (hn : P.n 1 (-δ) < 1) : s < P.n s η := by
  have hsum := P.combine_le δ η s η 1 (-δ) hδ.le hη.le
  have h1 : δ * s + η * 1 = δ * s + η := by ring
  have h2 : δ * η + η * (-δ) = 0 := by ring
  rw [h1, h2, P.axis_v, abs_of_pos (by positivity : 0 < δ * s + η)] at hsum
  have := mul_lt_mul_of_pos_left hn hη
  nlinarith

end Plane

structure Configuration (P Q : Plane) where
  t : ℝ
  p : ℝ
  r : ℝ
  s : ℝ
  u : ℝ
  M : ℝ
  t_pos : 0 < t
  t_lt_one : t < 1
  p_pos : 0 < p
  r_pos : 0 < r
  s_pos : 0 < s
  u_pos : 0 < u
  M_pos : 0 < M
  sp : s = p + M
  ru : r = u + M
  diameter : p + r ≤ 2
  x_unit : P.n p t = 1
  z_unit : P.n r (-t) = 1
  fx_unit : Q.n s t = 1
  fz_unit : Q.n u (-t) = 1
  x_dist : P.n p (t - 1) = Q.n s (t - 1)
  z_dist : P.n r (1 - t) = Q.n u (1 - t)
  positive : ∀ q : ℝ, 0 ≤ q → q ≤ 1 → Q.n s (t - q) - P.n p (t - q) ≤ M
  negative : ∀ q : ℝ, 0 ≤ q → q ≤ 1 → P.n r (q - t) - Q.n u (q - t) ≤ M

namespace Configuration

variable {P Q : Plane}

def d (C : Configuration P Q) := C.p + C.r
def e (C : Configuration P Q) := 1 - C.t
def A (C : Configuration P Q) := C.p / C.d
def B (C : Configuration P Q) := C.u / C.d
def a (C : Configuration P Q) := C.p / C.s
def c (C : Configuration P Q) := C.r / C.u
def h (C : Configuration P Q) := min (C.t / C.s) (C.e / C.u)
def k (C : Configuration P Q) := if C.B ≤ C.e then 1 - C.B else C.B

theorem d_pos (C : Configuration P Q) : 0 < C.d := add_pos C.p_pos C.r_pos
theorem e_pos (C : Configuration P Q) : 0 < C.e := sub_pos.mpr C.t_lt_one
theorem balance (C : Configuration P Q) : C.s + C.u = C.d := by
  dsimp [d]
  linarith [C.sp, C.ru]

theorem B_pos (C : Configuration P Q) : 0 < C.B := div_pos C.u_pos C.d_pos
theorem A_pos (C : Configuration P Q) : 0 < C.A := div_pos C.p_pos C.d_pos
theorem B_lt_one (C : Configuration P Q) : C.B < 1 := by
  apply (div_lt_iff₀ C.d_pos).2
  linarith [C.balance, C.s_pos]

theorem sum_lt_one (C : Configuration P Q) : C.A + C.B < 1 := by
  rw [A, B, ← add_div]
  apply (div_lt_iff₀ C.d_pos).2
  dsimp [d]
  linarith [C.ru, C.M_pos]

theorem one_sub_B (C : Configuration P Q) : 1 - C.B = C.s / C.d := by
  dsimp [B]
  field_simp [ne_of_gt C.d_pos]
  linarith [C.balance]

theorem a_pos (C : Configuration P Q) : 0 < C.a := div_pos C.p_pos C.s_pos
theorem c_pos (C : Configuration P Q) : 0 < C.c := div_pos C.r_pos C.u_pos

theorem cross (C : Configuration P Q) :
    C.s * C.r - C.p * C.u = C.M * C.d := by
  dsimp [d]
  rw [C.sp, C.ru]
  ring

theorem a_lt_c (C : Configuration P Q) : C.a < C.c := by
  apply (div_lt_div_iff₀ C.s_pos C.u_pos).2
  have := mul_pos C.M_pos C.d_pos
  nlinarith [C.cross]

theorem c_sub_a (C : Configuration P Q) :
    C.c - C.a = C.M * C.d / (C.s * C.u) := by
  dsimp [c, a]
  field_simp [ne_of_gt C.s_pos, ne_of_gt C.u_pos]
  nlinarith [C.cross]

theorem slope_small (C : Configuration P Q) :
    (1 - C.B) * (C.c - C.a) = C.M / C.u := by
  rw [C.one_sub_B, C.c_sub_a]
  field_simp [ne_of_gt C.s_pos, ne_of_gt C.u_pos, ne_of_gt C.d_pos]

theorem slope_large (C : Configuration P Q) :
    C.B * (C.c - C.a) = C.M / C.s := by
  rw [B, C.c_sub_a]
  field_simp [ne_of_gt C.s_pos, ne_of_gt C.u_pos, ne_of_gt C.d_pos]

theorem phase (C : Configuration P Q) :
    C.t / C.s ≤ C.e / C.u ↔ C.B ≤ C.e := by
  rw [div_le_div_iff₀ C.s_pos C.u_pos, B, div_le_iff₀ C.d_pos]
  rw [← C.balance]
  dsimp [e] at *
  constructor <;> intro H <;> nlinarith

theorem h_bounds (C : Configuration P Q) :
    0 < C.h ∧ C.s * C.h ≤ C.t ∧ C.u * C.h ≤ C.e := by
  refine ⟨lt_min (div_pos C.t_pos C.s_pos) (div_pos C.e_pos C.u_pos), ?_, ?_⟩
  · have := (le_div_iff₀ C.s_pos).1 (min_le_left (C.t / C.s) (C.e / C.u))
    simpa only [h, mul_comm] using this
  · have := (le_div_iff₀ C.u_pos).1 (min_le_right (C.t / C.s) (C.e / C.u))
    simpa only [h, mul_comm] using this

def inverse (C : Configuration P Q) : Configuration Q.flip P.flip where
  t := C.t
  p := C.u
  r := C.s
  s := C.r
  u := C.p
  M := C.M
  t_pos := C.t_pos
  t_lt_one := C.t_lt_one
  p_pos := C.u_pos
  r_pos := C.s_pos
  s_pos := C.r_pos
  u_pos := C.p_pos
  M_pos := C.M_pos
  sp := C.ru
  ru := C.sp
  diameter := by
    have hb := C.balance
    dsimp [d] at hb
    linarith [C.diameter]
  x_unit := by simpa only [Plane.flip_eq] using C.fz_unit
  z_unit := by simpa only [Plane.flip_eq, neg_neg] using C.fx_unit
  fx_unit := by simpa only [Plane.flip_eq] using C.z_unit
  fz_unit := by simpa only [Plane.flip_eq, neg_neg] using C.x_unit
  x_dist := by simpa only [Plane.flip_eq, neg_sub] using C.z_dist.symm
  z_dist := by simpa only [Plane.flip_eq, neg_sub] using C.x_dist.symm
  positive q hq hq' := by
    simpa only [Plane.flip_eq, neg_sub] using C.negative q hq hq'
  negative q hq hq' := by
    simpa only [Plane.flip_eq, neg_sub] using C.positive q hq hq'

theorem inverse_d (C : Configuration P Q) : C.inverse.d = C.d := by
  change C.u + C.s = C.d
  linarith [C.balance]

theorem inverse_A (C : Configuration P Q) : C.inverse.A = C.B := by
  simp only [A, inverse_d]
  rfl

theorem inverse_B (C : Configuration P Q) : C.inverse.B = C.A := by
  simp only [B, inverse_d]
  rfl

theorem secant (C : Configuration P Q) :
    C.e ≤ C.p * C.k ∧
      P.n C.a C.h ≤ C.h + C.a * C.k ∧
      P.n C.c C.h - P.n C.a C.h ≤ C.k * (C.c - C.a) := by
  obtain ⟨hh, hsh, huh⟩ := C.h_bounds
  have nx := P.scaled_n C.s_pos C.p C.h
  have nz := P.scaled_n C.u_pos C.r C.h
  have wx := Q.scaled_n C.s_pos C.s C.h
  have wz := Q.scaled_n C.u_pos C.u C.h
  simp only [div_self (ne_of_gt C.s_pos)] at wx
  simp only [div_self (ne_of_gt C.u_pos)] at wz
  have dx := C.positive (C.t - C.s * C.h) (by linarith)
    (by linarith [C.t_lt_one, mul_pos C.s_pos hh])
  have dz := C.negative (C.t + C.u * C.h)
    (by linarith [C.t_pos, mul_pos C.u_pos hh])
    (by dsimp [e] at huh; linarith)
  have hx : C.t - (C.t - C.s * C.h) = C.s * C.h := by ring
  have hz : C.t + C.u * C.h - C.t = C.u * C.h := by ring
  rw [hx, nx, wx] at dx
  rw [hz, nz, wz] at dz
  change C.s * Q.n 1 C.h - C.s * P.n C.a C.h ≤ C.M at dx
  change C.u * P.n C.c C.h - C.u * Q.n 1 C.h ≤ C.M at dz
  have hslope :
      P.n C.c C.h - P.n C.a C.h ≤ C.k * (C.c - C.a) := by
    by_cases hB : C.B ≤ C.e
    · have hmin : C.h = C.t / C.s := min_eq_left ((C.phase).2 hB)
      have hsh_eq : C.s * C.h = C.t := by
        rw [hmin]
        field_simp [ne_of_gt C.s_pos]
      have hzero : Q.n C.s (C.s * C.h) - P.n C.p (C.s * C.h) = 0 := by
        rw [hsh_eq, C.fx_unit, C.x_unit]
        ring
      rw [nx, wx] at hzero
      have hsame : Q.n 1 C.h = P.n C.a C.h := by
        change C.s * Q.n 1 C.h - C.s * P.n C.a C.h = 0 at hzero
        nlinarith [C.s_pos]
      rw [k, if_pos hB, C.slope_small]
      apply (le_div_iff₀ C.u_pos).2
      rw [hsame] at dz
      nlinarith
    · have hmin : C.h = C.e / C.u := min_eq_right (le_of_not_ge ((C.phase).not.2 hB))
      have huh_eq : C.u * C.h = C.e := by
        rw [hmin]
        field_simp [ne_of_gt C.u_pos]
      have hzero : P.n C.r (C.u * C.h) - Q.n C.u (C.u * C.h) = 0 := by
        rw [huh_eq]
        exact sub_eq_zero.mpr C.z_dist
      rw [nz, wz] at hzero
      have hsame : P.n C.c C.h = Q.n 1 C.h := by
        change C.u * P.n C.c C.h - C.u * Q.n 1 C.h = 0 at hzero
        nlinarith [C.u_pos]
      rw [k, if_neg hB, C.slope_large]
      apply (le_div_iff₀ C.s_pos).2
      rw [← hsame] at dx
      nlinarith
  have hcone := P.combine_le (C.c - C.a) C.a 0 C.h C.c C.h
    (sub_pos.mpr C.a_lt_c).le C.a_pos.le
  have hc1 : (C.c - C.a) * 0 + C.a * C.c = C.c * C.a := by ring
  have hc2 : (C.c - C.a) * C.h + C.a * C.h = C.c * C.h := by ring
  rw [hc1, hc2, P.scale C.c C.a C.h C.c_pos.le,
    P.axis_y, abs_of_pos hh] at hcone
  have hstart : P.n C.a C.h ≤ C.h + C.a * C.k := by
    have hmul := mul_le_mul_of_nonneg_left hslope C.a_pos.le
    have hprod :
        (C.c - C.a) * (P.n C.a C.h - (C.h + C.a * C.k)) ≤ 0 := by
      nlinarith
    by_contra hn
    have := mul_pos (sub_pos.mpr C.a_lt_c) (sub_pos.mpr (lt_of_not_ge hn))
    linarith
  have htriangle := P.add_le C.p (C.s * C.h) 0 (C.t - C.s * C.h)
  have ht1 : C.p + 0 = C.p := by ring
  have ht2 : C.s * C.h + (C.t - C.s * C.h) = C.t := by ring
  rw [ht1, ht2, C.x_unit, nx, P.axis_y,
    abs_of_nonneg (sub_nonneg.mpr hsh)] at htriangle
  change 1 ≤ C.s * P.n C.a C.h + (C.t - C.s * C.h) at htriangle
  have hscaled : C.s * P.n C.a C.h ≤ C.s * C.h + C.p * C.k := by
    calc
      _ ≤ C.s * (C.h + C.a * C.k) :=
        mul_le_mul_of_nonneg_left hstart C.s_pos.le
      _ = _ := by dsimp [a]; field_simp [ne_of_gt C.s_pos]
  refine ⟨?_, hstart, hslope⟩
  dsimp [e]
  linarith

theorem support_secant (C : Configuration P Q) (lv ly : ℝ)
    (hdom : ∀ a b : ℝ, a * lv + b * ly ≤ P.n a b)
    (heq : C.a * lv + C.h * ly = P.n C.a C.h) :
    C.e / C.p ≤ lv ∧
      lv ≤ (P.n C.c C.h - P.n C.a C.h) / (C.c - C.a) ∧
      (P.n C.c C.h - P.n C.a C.h) / (C.c - C.a) ≤ C.k := by
  have hly := hdom 0 1
  rw [P.axis_y, abs_one] at hly
  have hly' : ly ≤ 1 := by linarith
  have hca := sub_pos.mpr C.a_lt_c
  have hsa : C.s * C.a = C.p := by
    dsimp [a]
    field_simp [ne_of_gt C.s_pos]
  obtain ⟨hh, hsh, _⟩ := C.h_bounds
  have htriangle := P.add_le C.p (C.s * C.h) 0 (C.t - C.s * C.h)
  have hcoord : C.s * C.h + (C.t - C.s * C.h) = C.t := by ring
  rw [add_zero, hcoord, C.x_unit, P.scaled_n C.s_pos,
    P.axis_y, abs_of_nonneg (sub_nonneg.mpr hsh)] at htriangle
  change 1 ≤ C.s * P.n C.a C.h + (C.t - C.s * C.h) at htriangle
  rw [← heq] at htriangle
  have hscaled : C.s * (C.a * lv + C.h * ly) = C.p * lv + C.s * C.h * ly := by
    calc
      _ = (C.s * C.a) * lv + C.s * C.h * ly := by ring
      _ = _ := by rw [hsa]
  rw [hscaled] at htriangle
  have hmul := mul_le_mul_of_nonneg_left hly' (mul_pos C.s_pos hh).le
  have hlower : C.e / C.p ≤ lv := by
    apply (div_le_iff₀ C.p_pos).2
    dsimp [e]
    nlinarith
  have hdc := hdom C.c C.h
  have hmiddle : lv ≤ (P.n C.c C.h - P.n C.a C.h) / (C.c - C.a) := by
    apply (le_div_iff₀ hca).2
    nlinarith
  have hupper :
      (P.n C.c C.h - P.n C.a C.h) / (C.c - C.a) ≤ C.k := by
    apply (div_le_iff₀ hca).2
    simpa only [mul_comm] using C.secant.2.2
  exact ⟨hlower, hmiddle, hupper⟩

theorem large_geometry (C : Configuration P Q) (hB : C.e < C.B) :
    C.e < C.A ∧ ∃ δ : ℝ, 0 < δ ∧ P.n 1 δ < 1 := by
  obtain ⟨hlower, hstart, hslope⟩ := C.secant
  have hk : C.k = C.B := if_neg (not_le.mpr hB)
  rw [hk] at hlower hstart hslope
  have hmin : C.h = C.e / C.u :=
    min_eq_right (le_of_not_ge ((C.phase).not.2 (not_le.mpr hB)))
  have hh := C.h_bounds.1
  have ha : C.a * (1 - C.B) = C.p / C.d := by
    rw [C.one_sub_B, a]
    field_simp [ne_of_gt C.s_pos, ne_of_gt C.d_pos]
  have hh_le : C.h ≤ C.a * (1 - C.B) := by
    rw [hmin, ha]
    apply (div_le_div_iff₀ C.u_pos C.d_pos).2
    have := (le_div_iff₀ C.d_pos).1
      (show C.e ≤ C.p * C.u / C.d by simpa only [B, mul_div_assoc] using hlower)
    nlinarith
  have hx : P.n C.a C.h ≤ C.a := by nlinarith
  have hz : P.n C.c C.h < C.c := by
    have := mul_pos (sub_pos.mpr C.a_lt_c) (sub_pos.mpr C.B_lt_one)
    nlinarith
  have hsum := P.combine_le C.h C.t C.r (-C.t) C.c C.h hh.le C.t_pos.le
  have h1 : C.h * C.r + C.t * C.c = C.h * C.r + C.t * C.c := rfl
  have h2 : C.h * (-C.t) + C.t * C.h = 0 := by ring
  rw [h1, h2, P.axis_v, C.z_unit,
    abs_of_pos (add_pos (mul_pos hh C.r_pos) (mul_pos C.t_pos C.c_pos))] at hsum
  have hr : C.r < 1 := by
    have := mul_lt_mul_of_pos_left hz C.t_pos
    nlinarith
  have hu : C.u < 1 := by linarith [C.ru, C.M_pos]
  have hA : C.e < C.A := by
    have hAu : C.e ≤ C.A * C.u := by
      calc
        C.e ≤ C.p * C.B := hlower
        _ = C.A * C.u := by dsimp [A, B]; ring
    have := mul_lt_mul_of_pos_left hu C.A_pos
    linarith
  exact ⟨hA, C.h / C.c, (P.inward C.c_pos hh hz).1, (P.inward C.c_pos hh hz).2⟩

theorem not_large_B (C : Configuration P Q) : C.B ≤ C.e := by
  by_contra hB
  obtain ⟨hA, δ, hδ, hn⟩ := C.large_geometry (lt_of_not_ge hB)
  have hBi : C.inverse.e < C.inverse.B := by
    rw [C.inverse_B]
    exact hA
  obtain ⟨_, δ', hδ', hn'⟩ := C.inverse.large_geometry hBi
  have hnQ : Q.n 1 (-δ') < 1 := by
    simpa only [Plane.flip_eq] using hn'
  let η := min C.t (C.p * δ) / 2
  have hη : 0 < η := by
    exact div_pos (lt_min C.t_pos (mul_pos C.p_pos hδ)) (by norm_num)
  have hηt : η ≤ C.t := by
    have := min_le_left C.t (C.p * δ)
    dsimp [η]
    linarith [C.t_pos]
  have hηp : η ≤ C.p * δ := by
    have := min_le_right C.t (C.p * δ)
    have := mul_pos C.p_pos hδ
    dsimp [η]
    linarith
  have hp := P.inward_segment hδ C.p_pos hη hηp hn
  have hs := Q.outward hδ' C.s_pos hη hnQ
  have hdef := C.positive (C.t - η) (by linarith) (by linarith [C.t_lt_one])
  have heq : C.t - (C.t - η) = η := by ring
  rw [heq] at hdef
  linarith [C.sp]

theorem not_large_A (C : Configuration P Q) : C.A ≤ C.e := by
  have := C.inverse.not_large_B
  rw [C.inverse_B] at this
  exact this

theorem small_half (C : Configuration P Q)
    (hleft : C.e ≤ C.d * C.A * (1 - C.B))
    (hright : C.e ≤ C.d * C.B * (1 - C.A)) : C.e < 1 / 2 := by
  have hd : C.d ≤ 2 := C.diameter
  have hsum := C.sum_lt_one
  have hA := C.A_pos
  have hB := C.B_pos
  by_cases hab : C.A ≤ C.B
  · have ha : C.A < 1 / 2 := by linarith
    have hprod : C.A * (1 - C.B) < 1 / 4 := by
      nlinarith [sq_pos_of_pos (sub_pos.mpr ha)]
    have hnonneg : 0 ≤ C.A * (1 - C.B) :=
      mul_nonneg hA.le (sub_pos.mpr C.B_lt_one).le
    have := mul_le_mul_of_nonneg_right hd hnonneg
    nlinarith
  · have hb : C.B < 1 / 2 := by linarith
    have hprod : C.B * (1 - C.A) < 1 / 4 := by
      nlinarith [sq_pos_of_pos (sub_pos.mpr hb)]
    have hnonneg : 0 ≤ C.B * (1 - C.A) := by
      have ha1 : C.A < 1 := by linarith
      positivity
    have := mul_le_mul_of_nonneg_right hd hnonneg
    nlinarith

theorem no_configuration (C : Configuration P Q) : False := by
  have hB := C.not_large_B
  have hA := C.not_large_A
  have hleft := C.secant.1
  have hright := C.inverse.secant.1
  have hk : C.k = 1 - C.B := if_pos hB
  have hki : C.inverse.k = 1 - C.A := by
    rw [k, C.inverse_B]
    exact if_pos hA
  rw [hk] at hleft
  rw [hki] at hright
  change C.e ≤ C.u * (1 - C.A) at hright
  have hleft' : C.e ≤ C.d * C.A * (1 - C.B) := by
    have heq : C.d * C.A = C.p := by dsimp [A]; field_simp [ne_of_gt C.d_pos]
    rwa [heq]
  have hright' : C.e ≤ C.d * C.B * (1 - C.A) := by
    have heq : C.d * C.B = C.u := by dsimp [B]; field_simp [ne_of_gt C.d_pos]
    rwa [heq]
  have hhalf := C.small_half hleft' hright'
  have hat : C.A < C.t := by dsimp [e] at *; linarith
  have hcoefX : 0 ≤ C.r * C.t - C.p * C.e := by
    have := (div_lt_iff₀ C.d_pos).1 hat
    dsimp [d, e] at *
    nlinarith
  have hcoefY : 0 ≤ C.s * C.e - C.u * C.t := by
    have := (div_le_iff₀ C.d_pos).1 hB
    dsimp [e] at *
    nlinarith [C.balance]
  let D := P.n C.r C.e
  have hx := P.combine_le C.p (C.r * C.t - C.p * C.e)
    C.r C.e 0 1 C.p_pos.le hcoefX
  have hx1 : C.p * C.r + (C.r * C.t - C.p * C.e) * 0 = C.r * C.p := by ring
  have hx2 : C.p * C.e + (C.r * C.t - C.p * C.e) * 1 = C.r * C.t := by ring
  rw [hx1, hx2, P.scale C.r C.p C.t C.r_pos.le,
    C.x_unit, P.axis_y, abs_one] at hx
  have hy := Q.combine_le C.u (C.s * C.e - C.u * C.t)
    C.s C.t 0 1 C.u_pos.le hcoefY
  have hy1 : C.u * C.s + (C.s * C.e - C.u * C.t) * 0 = C.s * C.u := by ring
  have hy2 : C.u * C.t + (C.s * C.e - C.u * C.t) * 1 = C.s * C.e := by ring
  rw [hy1, hy2, Q.scale C.s C.u C.e C.s_pos.le,
    C.fx_unit, Q.axis_y, abs_one] at hy
  have hdist : Q.n C.u C.e = D := C.z_dist.symm
  rw [hdist] at hy
  change C.r * 1 ≤ C.p * D + (C.r * C.t - C.p * C.e) * 1 at hx
  have heX : C.e * C.d ≤ C.p * D := by dsimp [e, d] at *; nlinarith
  have heY : C.s * D ≤ C.e * C.d := by
    have hb := C.balance
    dsimp [e] at *
    nlinarith
  have hD : 0 < D := by
    have := mul_pos C.e_pos C.d_pos
    nlinarith [C.p_pos]
  have := mul_pos C.M_pos hD
  nlinarith [C.sp]

end Configuration

theorem chord_obstruction (P Q : Plane) : ¬ Nonempty (Configuration P Q) := by
  rintro ⟨C⟩
  exact C.no_configuration

theorem arbitrary_normed_spaces
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [NormedAddCommGroup F] [NormedSpace ℝ F]
    (v y : E) (w b : F)
    (hv : ‖v‖ = 1) (hy : ‖y‖ = 1) (hw : ‖w‖ = 1) (hb : ‖b‖ = 1) :
    ¬ Nonempty (Configuration (ofVectors v y hv hy) (ofVectors w b hw hb)) :=
  chord_obstruction _ _

theorem manuscript_chords_impossible
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [NormedAddCommGroup F] [NormedSpace ℝ F]
    (v y x z : E) (w b fx fz : F) (t p r s u M : ℝ)
    (hv : ‖v‖ = 1) (hy : ‖y‖ = 1) (hw : ‖w‖ = 1) (hb : ‖b‖ = 1)
    (ht : 0 < t) (ht1 : t < 1)
    (hp : 0 < p) (hr : 0 < r) (hs : 0 < s) (hu : 0 < u) (hM : 0 < M)
    (hsp : s = p + M) (hru : r = u + M) (hd : p + r ≤ 2)
    (hx : x = p • v + t • y) (hz : z = t • y - r • v)
    (hfx : fx = s • w + t • b) (hfz : fz = t • b - u • w)
    (hxn : ‖x‖ = 1) (hzn : ‖z‖ = 1) (hfxn : ‖fx‖ = 1) (hfzn : ‖fz‖ = 1)
    (hxd : ‖x - y‖ = ‖fx - b‖) (hzd : ‖y - z‖ = ‖b - fz‖)
    (hdx : ∀ q : ℝ, 0 ≤ q → q ≤ 1 →
      |‖fx - q • b‖ - ‖x - q • y‖| ≤ M)
    (hdz : ∀ q : ℝ, 0 ≤ q → q ≤ 1 →
      |‖fz - q • b‖ - ‖z - q • y‖| ≤ M) : False := by
  let P := ofVectors v y hv hy
  let Q := ofVectors w b hw hb
  have hxn' : P.n p t = 1 := by
    change ‖p • v + t • y‖ = 1
    rwa [← hx]
  have hzn' : P.n r (-t) = 1 := by
    have heq : r • v + (-t) • y = -z := by rw [hz]; module
    change ‖r • v + (-t) • y‖ = 1
    rw [heq, norm_neg, hzn]
  have hfxn' : Q.n s t = 1 := by
    change ‖s • w + t • b‖ = 1
    rwa [← hfx]
  have hfzn' : Q.n u (-t) = 1 := by
    have heq : u • w + (-t) • b = -fz := by rw [hfz]; module
    change ‖u • w + (-t) • b‖ = 1
    rw [heq, norm_neg, hfzn]
  have hxd' : P.n p (t - 1) = Q.n s (t - 1) := by
    have he : p • v + (t - 1) • y = x - y := by rw [hx]; module
    have hf : s • w + (t - 1) • b = fx - b := by rw [hfx]; module
    change ‖p • v + (t - 1) • y‖ = ‖s • w + (t - 1) • b‖
    rwa [he, hf]
  have hzd' : P.n r (1 - t) = Q.n u (1 - t) := by
    have he : r • v + (1 - t) • y = y - z := by rw [hz]; module
    have hf : u • w + (1 - t) • b = b - fz := by rw [hfz]; module
    change ‖r • v + (1 - t) • y‖ = ‖u • w + (1 - t) • b‖
    rwa [he, hf]
  have hpos : ∀ q : ℝ, 0 ≤ q → q ≤ 1 →
      Q.n s (t - q) - P.n p (t - q) ≤ M := by
    intro q hq hq1
    have he : p • v + (t - q) • y = x - q • y := by rw [hx]; module
    have hf : s • w + (t - q) • b = fx - q • b := by rw [hfx]; module
    change ‖s • w + (t - q) • b‖ - ‖p • v + (t - q) • y‖ ≤ M
    rw [he, hf]
    exact (abs_le.mp (hdx q hq hq1)).2
  have hneg : ∀ q : ℝ, 0 ≤ q → q ≤ 1 →
      P.n r (q - t) - Q.n u (q - t) ≤ M := by
    intro q hq hq1
    have he : r • v + (q - t) • y = -(z - q • y) := by rw [hz]; module
    have hf : u • w + (q - t) • b = -(fz - q • b) := by rw [hfz]; module
    change ‖r • v + (q - t) • y‖ - ‖u • w + (q - t) • b‖ ≤ M
    rw [he, hf, norm_neg, norm_neg]
    have := (abs_le.mp (hdz q hq hq1)).1
    linarith
  exact Configuration.no_configuration
    { t := t, p := p, r := r, s := s, u := u, M := M,
      t_pos := ht, t_lt_one := ht1, p_pos := hp, r_pos := hr,
      s_pos := hs, u_pos := hu, M_pos := hM, sp := hsp, ru := hru,
      diameter := hd, x_unit := hxn', z_unit := hzn', fx_unit := hfxn',
      fz_unit := hfzn', x_dist := hxd', z_dist := hzd',
      positive := hpos, negative := hneg }

end ChordObstruction

#print axioms ChordObstruction.Configuration.support_secant
#print axioms ChordObstruction.Configuration.no_configuration
#print axioms ChordObstruction.manuscript_chords_impossible
