import Mathlib

namespace GepnerAisle

noncomputable section

@[ext]
structure V where
  r : ℝ
  c : ℝ
  d : ℝ
  e : ℝ

def phi (v : V) : V :=
  ⟨-4 * v.r - (20 / 3) * v.c - 5 * v.d - 5 * v.e,
    v.r + v.c, v.r / 2 + v.c + v.d,
    v.r / 6 + v.c / 2 + v.d + v.e⟩

def phiInv (v : V) : V :=
  ⟨v.r + (25 / 6) * v.c + 5 * v.e,
    -v.r - (19 / 6) * v.c - 5 * v.e,
    v.r / 2 + (13 / 12) * v.c + v.d + (5 / 2) * v.e,
    -v.r / 6 - (7 / 36) * v.c - v.d + v.e / 6⟩

def cut (u : ℝ) (v : V) : ℝ := v.d + v.c / 2 + u * v.r

def uG : ℝ := (5 - Real.sqrt 5) / 10

theorem phi_inverse (v : V) : phiInv (phi v) = v := by
  ext <;> dsimp [phiInv, phi] <;> ring

theorem inverse_phi (v : V) : phi (phiInv v) = v := by
  ext <;> dsimp [phiInv, phi] <;> ring

theorem phi_period_five (v : V) :
    phi (phi (phi (phi (phi v)))) = v := by
  ext <;> dsimp [phi] <;> ring

theorem gepner_polynomial : 5 * uG ^ 2 - 5 * uG + 1 = 0 := by
  have hs := Real.sq_sqrt (show (0 : ℝ) ≤ 5 by norm_num)
  dsimp [uG]
  nlinarith

theorem gepner_bounds :
    (27 / 100 : ℝ) ≤ uG ∧ uG < (138197 / 500000 : ℝ) := by
  have hs := Real.sq_sqrt (show (0 : ℝ) ≤ 5 by norm_num)
  have hp := Real.sqrt_nonneg (5 : ℝ)
  dsimp [uG]
  constructor <;> nlinarith

theorem slope_criterion_threshold (u s : ℝ)
    (hstrip : 20 * u + 13 * s ≤ 13) (hcompare : 2 * u ≤ s) :
    u ≤ 13 / 46 := by
  linarith

theorem slope_criterion_attained :
    20 * (13 / 46 : ℝ) + 13 * (13 / 23 : ℝ) = 13 ∧
      2 * (13 / 46 : ℝ) = 13 / 23 := by
  norm_num

theorem parameter_margins (u δ : ℝ)
    (hu : 0 < u) (hub : u < 13 / 46)
    (hδ : 0 < δ) (hsmall : δ ≤ u / 4)
    (hgap : δ ≤ (13 / 46 - u) / 10) :
    0 < u - δ ∧
      0 < 3 / 10 - u - (3 / 2) * δ ∧
      0 < 13 / 46 - u - (36 / 23) * δ ∧
      0 < 1 / 2 - (23 / 13) * u - 3 * δ := by
  constructor
  · linarith
  constructor
  · linarith
  constructor <;> linarith

theorem concrete_margins (u : ℝ)
    (hl : (27 / 100 : ℝ) ≤ u)
    (hu : u ≤ (138197 / 500000 : ℝ)) :
    0 < u - 1 / 2000 ∧
      0 < 3 / 10 - u - (3 / 2) * (1 / 2000) ∧
      0 < 13 / 46 - u - (36 / 23) * (1 / 2000) ∧
      0 < 1 / 2 - (23 / 13) * u - 3 * (1 / 2000) := by
  constructor
  · linarith
  constructor
  · linarith
  constructor <;> linarith

theorem comparison_separation (s u δ C R D err : ℝ)
    (hs : 0 < s) (hu : 0 ≤ u) (hC : 0 < C)
    (hR : s * R ≤ C) (hD : D ≤ 0)
    (herr : -3 * δ * C ≤ err)
    (hmargin : 0 < s / 2 - u - 3 * δ * s) :
    0 < C / 2 - u * R - D + err := by
  have h1 := mul_nonneg hu (sub_nonneg.mpr hR)
  have h2 := mul_pos hmargin hC
  have h3 := mul_nonneg (le_of_lt hs) (show 0 ≤ err + 3 * δ * C by linarith)
  have h4 := mul_nonpos_of_nonneg_of_nonpos (le_of_lt hs) hD
  by_contra h
  have h5 := mul_nonpos_of_nonneg_of_nonpos
    (le_of_lt hs) (le_of_not_gt h)
  nlinarith

theorem four_corner_control (ε N r c : ℝ)
    (hpp : 0 ≤ N + ε * r + ε * c)
    (hpm : 0 ≤ N + ε * r - ε * c)
    (hmp : 0 ≤ N - ε * r + ε * c)
    (hmm : 0 ≤ N - ε * r - ε * c) :
    ε * (|r| + |c|) ≤ N := by
  rcases le_total 0 r with hr | hr
  · rcases le_total 0 c with hc | hc
    · rw [abs_of_nonneg hr, abs_of_nonneg hc]
      linarith
    · rw [abs_of_nonneg hr, abs_of_nonpos hc]
      linarith
  · rcases le_total 0 c with hc | hc
    · rw [abs_of_nonpos hr, abs_of_nonneg hc]
      linarith
    · rw [abs_of_nonpos hr, abs_of_nonpos hc]
      linarith

theorem four_cut_circuit (u : ℝ) (v : V)
    (hu : 5 * u ^ 2 - 5 * u + 1 = 0) :
    cut u v + (5 * u - 1) * cut u (phiInv v) +
      (5 * u - 1) * cut u (phiInv (phiInv v)) +
      cut u (phiInv (phiInv (phiInv v))) = 0 := by
  calc
    _ = -(3 * v.r + (35 / 6) * v.c + 5 * v.d + 10 * v.e) *
        (5 * u ^ 2 - 5 * u + 1) := by
      dsimp [cut, phiInv]
      ring
    _ = 0 := by rw [hu]; ring

theorem endpoint_r0 (u : ℝ) (w : V) :
    u * (phi w).r =
      u * (5 * u - 4) * w.r - w.c +
        (1 - 5 * u) * cut u w - cut u (phiInv w) := by
  dsimp [phi, phiInv, cut]
  ring

theorem endpoint_r3 (u : ℝ) (w : V) :
    u * (phiInv (phiInv w)).r =
      u * (5 * u - 4) * w.r + (5 * u - 3) * w.c +
        (3 - 5 * u) * cut u w - 3 * cut u (phiInv w) := by
  dsimp [phiInv, cut]
  ring

theorem endpoint_c3 (u : ℝ) (w : V) :
    u * (phiInv (phiInv w)).c =
      u * (3 - 5 * u) * w.r + (2 - 4 * u) * w.c +
        (5 * u - 2) * cut u w + 2 * cut u (phiInv w) := by
  dsimp [phiInv, cut]
  ring

theorem numerical_kernel_separation (u : ℝ) (w : V)
    (hu : u ≠ 0) (hr : w.r = 0) (hc : w.c = 0)
    (h1 : cut u w = 0) (h2 : cut u (phiInv w) = 0) :
    w.d = 0 ∧ w.e = 0 := by
  have hd : w.d = 0 := by simpa [cut, hr, hc] using h1
  have he : u * w.e = 0 := by
    dsimp [cut, phiInv] at h2
    rw [hr, hc, hd] at h2
    nlinarith [h2]
  exact ⟨hd, (mul_eq_zero.mp he).resolve_left hu⟩

theorem explicit_refinement_separation (a n0 n1 n2 n3 X T : ℝ)
    (ha : (7 / 20 : ℝ) ≤ a) (h1 : 0 ≤ n1) (h2 : 0 ≤ n2)
    (hX : 0 ≤ X) (hmid : X / 8000 ≤ n1)
    (hend : T ≤ 16 * X + 24 * (n1 + n2))
    (hends : -T / 500000 ≤ n0 + n3)
    (hcircuit : n0 + a * n1 + a * n2 + n3 = 0) :
    n1 = 0 ∧ n2 = 0 ∧ X = 0 := by
  have hX' : X ≤ 8000 * n1 := by linarith
  have hend' : T ≤ 128024 * (n1 + n2) := by linarith
  have hweight : (7 / 20 : ℝ) * (n1 + n2) ≤ a * n1 + a * n2 := by
    nlinarith [mul_nonneg (sub_nonneg.mpr ha) (add_nonneg h1 h2)]
  have hsum : n1 + n2 = 0 := by linarith
  have hn1 : n1 = 0 := by linarith
  have hn2 : n2 = 0 := by linarith
  exact ⟨hn1, hn2, by linarith⟩

theorem explicit_support_arithmetic (Q N X D E : ℝ)
    (hQ : 0 ≤ Q) (hN : N ≤ (2 / 5) * Q)
    (hX : X ≤ 1000000 * N)
    (hD : D ≤ N + X / 2)
    (hE : E ≤ Q / 5 + X / 2 + D / 2) :
    X + D + E ≤ 1000000 * Q := by
  linarith

theorem explicit_support_transport (Q W P : ℝ)
    (hQ : 0 ≤ Q) (hW : W ≤ 1000000 * Q)
    (hP : P ≤ (82 / 3) * W) :
    P ≤ 30000000 * Q := by
  linarith

#print axioms phi_period_five
#print axioms gepner_bounds
#print axioms comparison_separation
#print axioms four_corner_control
#print axioms four_cut_circuit
#print axioms explicit_refinement_separation
#print axioms explicit_support_transport

end

end GepnerAisle
