import Mathlib.Analysis.CStarAlgebra.Classes
import Mathlib.Tactic.NoncommRing

namespace FourEntryCore

variable {A : Type*} [CStarAlgebra A]

def defect (r b : A) : A := 1 - (r + b) * star (r + b)

theorem complement_annihilates {H b r : A}
    (hb : star b = b) (hb2 : b * b = 1 - H * H)
    (hHr : H * r = r) : b * r = 0 := by
  apply (CStarRing.star_mul_self_eq_zero_iff (b * r)).mp
  calc
    star (b * r) * (b * r) = star r * (b * b) * r := by
      rw [star_mul, hb]
      noncomm_ring
    _ = star r * r - star r * (H * (H * r)) := by
      rw [hb2]
      noncomm_ring
    _ = 0 := by rw [hHr, hHr, sub_self]

theorem scaling_isometry {H b r : A}
    (hb : star b = b) (hb2 : b * b = 1 - H * H)
    (hHr : H * r = r) (hrr : star r * r = H * H) :
    star (r + b) * (r + b) = 1 := by
  have hbr := complement_annihilates hb hb2 hHr
  have hrb : star r * b = 0 := by
    simpa only [star_mul, star_star, hb, star_zero] using congrArg star hbr
  calc
    star (r + b) * (r + b) =
        star r * r + star r * b + b * r + b * b := by
      rw [star_add, hb]
      noncomm_ring
    _ = 1 := by rw [hrr, hrb, hbr, hb2]; noncomm_ring

theorem scaling_orthogonal {H b r₁ r₂ : A}
    (hb : star b = b) (hb2 : b * b = 1 - H * H)
    (hHr₂ : H * r₂ = r₂) (h12 : star r₁ * r₂ = 0) :
    star (r₁ + b) * r₂ = 0 := by
  have hbr₂ := complement_annihilates hb hb2 hHr₂
  rw [star_add, hb, add_mul, h12, hbr₂, zero_add]

theorem defect_selfadjoint (r b : A) :
    star (defect r b) = defect r b := by
  simp only [defect, star_sub, star_one, star_mul, star_star]

theorem defect_idempotent {r b : A}
    (hv : star (r + b) * (r + b) = 1) :
    defect r b * defect r b = defect r b := by
  calc
    defect r b * defect r b =
        1 - (r + b) * star (r + b) - (r + b) * star (r + b) +
          (r + b) * (star (r + b) * (r + b)) * star (r + b) := by
      dsimp [defect]
      noncomm_ring
    _ = defect r b := by rw [hv]; dsimp [defect]; noncomm_ring

theorem defect_nonzero {H b r₁ r₂ : A}
    (hH : star H = H) (hHne : H ≠ 0)
    (hb : star b = b) (hb2 : b * b = 1 - H * H)
    (hHr₂ : H * r₂ = r₂) (h22 : star r₂ * r₂ = H * H)
    (h12 : star r₁ * r₂ = 0) : defect r₁ b ≠ 0 := by
  have horth := scaling_orthogonal hb hb2 hHr₂ h12
  have hPr₂ : defect r₁ b * r₂ = r₂ := by
    dsimp [defect]
    rw [sub_mul, one_mul, mul_assoc, horth, mul_zero, sub_zero]
  intro hP
  have hr₂ : r₂ = 0 := by simpa only [hP, zero_mul] using hPr₂.symm
  have hHsq : H * H = 0 := by
    rw [← h22, hr₂, star_zero, zero_mul]
  apply hHne
  exact (CStarRing.star_mul_self_eq_zero_iff H).mp (by simpa only [hH] using hHsq)

theorem cutoff_compression {H b r K : A}
    (hK : star K = K) (hb : star b = b)
    (hb2 : b * b = 1 - H * H)
    (hKH : K * H = H) (hHr : H * r = r)
    (hrK : r * K = r) (hKb : K * b = b * K) :
    K * defect r b * K = defect r b := by
  have hKr : K * r = r := by
    calc
      K * r = K * (H * r) := by rw [hHr]
      _ = (K * H) * r := (mul_assoc K H r).symm
      _ = r := by rw [hKH, hHr]
  have hKrs : K * star r = star r := by
    simpa only [star_mul, hK] using congrArg star hrK
  have hp : defect r b = H * H - r * star r - r * b - b * star r := by
    dsimp [defect]
    rw [star_add, hb]
    calc
      1 - (r + b) * (star r + b) =
          1 - r * star r - r * b - b * star r - b * b := by noncomm_ring
      _ = H * H - r * star r - r * b - b * star r := by
        rw [hb2]
        noncomm_ring
  have hleft : K * defect r b = defect r b := by
    simp only [hp, mul_sub, ← mul_assoc]
    rw [hKH, hKr, hKb]
    simp only [mul_assoc, hKrs]
  have hright : defect r b * K = defect r b := by
    simpa only [star_mul, hK, defect_selfadjoint] using congrArg star hleft
  rw [hleft, hright]

theorem two_column_obstruction {P B₃ B₄ : A} {h : Complex}
    (hh : h ≠ 0)
    (hdiag : (B₃ * star B₃) * P = h • P)
    (hsupport : P * B₄ = B₄)
    (horth : star B₃ * B₄ = 0)
    (hgram : star B₃ * B₃ = star B₄ * B₄) : P = 0 := by
  have hscalar : h • B₄ = 0 := by
    calc
      h • B₄ = h • (P * B₄) := by rw [hsupport]
      _ = (h • P) * B₄ := (smul_mul_assoc h P B₄).symm
      _ = ((B₃ * star B₃) * P) * B₄ := by rw [hdiag]
      _ = B₃ * (star B₃ * (P * B₄)) := by noncomm_ring
      _ = 0 := by rw [hsupport, horth, mul_zero]
  have hB₄ : B₄ = 0 := (smul_eq_zero.mp hscalar).resolve_left hh
  have hB₃ : B₃ = 0 := by
    apply (CStarRing.star_mul_self_eq_zero_iff B₃).mp
    simpa only [hB₄, star_zero, zero_mul] using hgram
  have hP : h • P = 0 := by
    rw [← hdiag, hB₃, zero_mul, zero_mul]
  exact (smul_eq_zero.mp hP).resolve_left hh

theorem four_entry_impossible {H b r₁ r₂ B₃ B₄ : A} {h : Complex}
    (hH : star H = H) (hHne : H ≠ 0)
    (hb : star b = b) (hb2 : b * b = 1 - H * H)
    (hHr₂ : H * r₂ = r₂)
    (h22 : star r₂ * r₂ = H * H)
    (h12 : star r₁ * r₂ = 0)
    (hh : h ≠ 0)
    (hdiag : (B₃ * star B₃) * defect r₁ b = h • defect r₁ b)
    (hsupport : defect r₁ b * B₄ = B₄)
    (horth : star B₃ * B₄ = 0)
    (hgram : star B₃ * B₃ = star B₄ * B₄) : False := by
  exact (defect_nonzero hH hHne hb hb2 hHr₂ h22 h12)
    (two_column_obstruction hh hdiag hsupport horth hgram)

theorem graph_recovery {t S X inverse : A}
    (htS : t * S = S) (hXt : X * t = X)
    (hcutoff : S * (X * inverse) = S) :
    t * S * X * t * inverse = S := by
  calc
    t * S * X * t * inverse = (t * S) * (X * t) * inverse := by noncomm_ring
    _ = S * (X * inverse) := by rw [htS, hXt]; noncomm_ring
    _ = S := hcutoff

#print axioms complement_annihilates
#print axioms scaling_isometry
#print axioms defect_nonzero
#print axioms cutoff_compression
#print axioms two_column_obstruction
#print axioms four_entry_impossible
#print axioms graph_recovery

end FourEntryCore
