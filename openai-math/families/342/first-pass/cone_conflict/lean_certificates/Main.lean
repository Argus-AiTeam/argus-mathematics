import Mathlib

namespace ConeConflict

abbrev Vector4 := ℝ × ℝ × ℝ × ℝ

def scale (a : ℝ) (v : Vector4) : Vector4 :=
  (a * v.1, a * v.2.1, a * v.2.2.1, a * v.2.2.2)

def dot (u v : Vector4) : ℝ :=
  u.1 * v.1 + u.2.1 * v.2.1 + u.2.2.1 * v.2.2.1 + u.2.2.2 * v.2.2.2

def K (f k : ℝ) (v : Vector4) : Vector4 :=
  (-v.2.1 - f * v.2.2.1 - k * v.2.2.2,
   v.1 - k * v.2.2.1 + f * v.2.2.2,
   f * v.1 + k * v.2.1 - v.2.2.2,
   k * v.1 - f * v.2.1 + v.2.2.1)

theorem K_scale (f k a : ℝ) (v : Vector4) :
    K f k (scale a v) = scale a (K f k v) := by
  rcases v with ⟨x, y, z, w⟩
  dsimp [K, scale]
  ext <;> ring

theorem scale_scale (a b : ℝ) (v : Vector4) :
    scale a (scale b v) = scale (a * b) v := by
  rcases v with ⟨x, y, z, w⟩
  dsimp [scale]
  ext <;> ring

theorem K_squared (f k : ℝ) (v : Vector4) :
    K f k (K f k v) = scale (-(1 + f^2 + k^2)) v := by
  rcases v with ⟨x, y, z, w⟩
  dsimp [K, scale]
  ext <;> ring

theorem K_norm (f k : ℝ) (v : Vector4) :
    dot (K f k v) (K f k v) = (1 + f^2 + k^2) * dot v v := by
  rcases v with ⟨x, y, z, w⟩
  dsimp [K, dot]
  ring

noncomputable def J (f k r : ℝ) (v : Vector4) : Vector4 :=
  scale r⁻¹ (K f k v)

theorem J_squared (f k r : ℝ) (hr : r ≠ 0)
    (hn : r^2 = 1 + f^2 + k^2) (v : Vector4) :
    J f k r (J f k r v) = scale (-1) v := by
  unfold J
  rw [K_scale, scale_scale, K_squared, scale_scale]
  have hc : r⁻¹ * r⁻¹ * (-(1 + f^2 + k^2)) = -1 := by
    rw [← hn]
    field_simp [hr]
  rw [hc]

structure TwoForm where
  a12 : ℝ
  a13 : ℝ
  a14 : ℝ
  a23 : ℝ
  a24 : ℝ
  a34 : ℝ

def wedge (a b : TwoForm) : ℝ :=
  a.a12 * b.a34 - a.a13 * b.a24 + a.a14 * b.a23 +
  a.a23 * b.a14 - a.a24 * b.a13 + a.a34 * b.a12

def numerator (f k : ℝ) : TwoForm := ⟨1, f, k, k, -f, 1⟩
def eta (f k : ℝ) : TwoForm := ⟨1, 2*f, 0, 2*k, 0, 1⟩
def betaPlus : TwoForm := ⟨1, 1, 0, 0, -1, 1⟩
def betaMinus : TwoForm := ⟨1, -1, 0, 0, 1, 1⟩

theorem numerator_square (f k : ℝ) :
    wedge (numerator f k) (numerator f k) = 2 * (1 + f^2 + k^2) := by
  dsimp [wedge, numerator]
  ring

theorem eta_square (f k : ℝ) : wedge (eta f k) (eta f k) = 2 := by
  norm_num [wedge, eta]

theorem tamers_square :
    wedge betaPlus betaPlus = 4 ∧ wedge betaMinus betaMinus = 4 := by
  norm_num [wedge, betaPlus, betaMinus]

theorem tamers_zero_intersection : wedge betaPlus betaMinus = 0 := by
  norm_num [wedge, betaPlus, betaMinus]

theorem eta_tamer_pairings (f k : ℝ) :
    wedge (eta f k) betaPlus = 2 * (1 + f) ∧
    wedge (eta f k) betaMinus = 2 * (1 - f) := by
  constructor <;> dsimp [wedge, eta, betaPlus, betaMinus] <;> ring

theorem eigenvalue_positive (r s : ℝ) (hr : 0 < r) (hs : 0 ≤ s)
    (hn : r^2 = 1 + s^2) : 0 < r - s := by
  by_contra h
  have hd : r - s ≤ 0 := le_of_not_gt h
  have hp : (r - s) * (r + s) ≤ 0 :=
    mul_nonpos_of_nonpos_of_nonneg hd (add_nonneg (le_of_lt hr) hs)
  nlinarith

theorem taming_coefficients_positive (f r : ℝ) (hr : 0 < r)
    (hf : -1 < f ∧ f < 1) :
    0 < (1 + f) / r ∧ 0 < (1 - f) / r := by
  constructor
  · exact div_pos (by linarith [hf.1]) hr
  · exact div_pos (by linarith [hf.2]) hr

theorem positive_trace_pairing (c t : ℝ) (hc : 0 < c) (ht : 0 < t) :
    0 < c * t / 2 := by
  exact div_pos (mul_pos hc ht) (by norm_num)

end ConeConflict
