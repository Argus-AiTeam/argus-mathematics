import Mathlib

set_option maxHeartbeats 4000000
set_option maxRecDepth 4096

noncomputable section

namespace ThreeGain

abbrev Vec3 := Fin 3 → ℝ
abbrev Vec7 := Fin 7 → ℝ

def cross (a b : Vec3) : Vec3 :=
  ![a 1 * b 2 - a 2 * b 1,
    a 2 * b 0 - a 0 * b 2,
    a 0 * b 1 - a 1 * b 0]

def axis (a : ℝ) : Vec3 := ![0, 0, a]

def collide (v : Vec3) (a : ℝ) (l : Vec3) : Vec3 :=
  v + cross (v - axis a) l

theorem witness_first_collision (R Z a : ℝ) (hR : R ≠ 0) :
    collide ![R, 0, Z] a ![0, 0, -(1 / R)] = ![R, 1, Z] := by
  ext i
  fin_cases i <;> simp [collide, cross, axis, hR]

theorem witness_second_collision (R Z a : ℝ) :
    collide ![R, 1, Z] a ![0, 0, 1] = ![R + 1, 1 - R, Z] := by
  ext i
  fin_cases i <;> simp [collide, cross, axis] <;> ring

theorem witness_third_collision (v : Vec3) (a : ℝ) :
    collide v a 0 = v := by
  ext i
  fin_cases i <;> simp [collide, cross, axis]

def firstVariation (R Z b1 b2 b3 T1 T2 T3 p1 p2 p3 : ℝ) (q : Vec7) : Vec7 :=
  let v0 : Vec3 := ![R, 0, Z]
  let v1 : Vec3 := ![R, 1, Z]
  let v2 : Vec3 := ![R + 1, 1 - R, Z]
  let n1 : Vec3 := ![R, 0, b1]
  let n2 : Vec3 := ![R, 1, b2]
  let n3 : Vec3 := ![R + 1, 1 - R, b3]
  let dx1 := q 0 • v0
  let dv1 := cross (-axis p1) ![0, 0, -(1 / R)] + cross n1 ![0, q 3, 0]
  let dx2 := dx1 - (q 0 - q 1) • v1 - (T1 - T2) • dv1
  let dv2 := dv1 + cross (dv1 - axis p2) ![0, 0, 1] + cross n2 ![0, 0, q 4]
  let dx3 := dx2 - (q 1 - q 2) • v2 - (T2 - T3) • dv2
  let dv3 := dv2 + cross (dv2 - axis p3) 0 + cross n3 ![0, q 5, q 6]
  ![q 2, dx3 0, dx3 1, dx3 2, dv3 0, dv3 1, dv3 2]

def minor (R Z b1 b3 D E : ℝ) : Matrix (Fin 7) (Fin 7) ℝ :=
  !![0, 0, 1, 0, 0, 0, 0;
     0, -1, R + 1, b1 * D, -E, 0, 0;
     -1, R, 1 - R, -b1 * E, R * E, 0, 0;
     0, 0, Z, -R * D, 0, 0, 0;
     0, 0, 0, -b1, 1, -b3, 1 - R;
     0, 0, 0, b1, -R, 0, -R - 1;
     0, 0, 0, R, 0, R + 1, 0]

theorem firstVariation_eq_minor
    (R Z b1 b2 b3 T1 T2 T3 p1 p2 p3 : ℝ) (q : Vec7) :
    firstVariation R Z b1 b2 b3 T1 T2 T3 p1 p2 p3 q =
      (minor R Z b1 b3 (T1 - T3) (T2 - T3)).mulVec q := by
  ext i
  fin_cases i <;>
    simp [firstVariation, cross, axis, minor, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ] <;> ring

theorem minor_det (R Z b1 b3 D E : ℝ) :
    (minor R Z b1 b3 D E).det = R * D * (R + 1) * (R ^ 2 + 1) := by
  simp [minor, Matrix.det_succ_row_zero, Fin.sum_univ_succ, Matrix.submatrix,
    Fin.succAbove]
  <;> ring

theorem minor_det_positive (R Z b1 b3 T1 T2 T3 : ℝ)
    (hR : 0 < R) (hT : T3 < T1) :
    0 < (minor R Z b1 b3 (T1 - T3) (T2 - T3)).det := by
  rw [minor_det]
  have hD : 0 < T1 - T3 := sub_pos.mpr hT
  positivity

theorem plane_kernel (n : Vec3) : cross n n = 0 := by
  ext i
  fin_cases i <;> simp [cross] <;> ring

theorem zero_normal_kernel (l : Vec3) : cross 0 l = 0 := by
  ext i
  fin_cases i <;> simp [cross]

end ThreeGain
