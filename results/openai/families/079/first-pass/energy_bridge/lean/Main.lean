import Mathlib

open scoped BigOperators

noncomputable section

namespace EnergyBridge

abbrev Q := Quaternion ℝ

section QuaternionicWall

variable {ι : Type*} [Fintype ι]

def pair (v w : ι → Q) : Q := ∑ i, star (v i) * w i

def act (B : ι → ι → Q) (q : ι → Q) : ι → Q :=
  fun i => ∑ j, B i j * q j

def wall (B R : ι → ι → Q) (ν w : ι → Q) (t : ℝ) : ι → ι → Q :=
  fun i j => B i j + (t : Q) * R i j + ν i * star (w j) + w i * star (ν j)

theorem pair_right_mul (v w : ι → Q) (a : Q) :
    pair v (fun i => w i * a) = pair v w * a := by
  simp [pair, Finset.sum_mul, mul_assoc]

theorem act_wall (B R : ι → ι → Q) (ν w q : ι → Q) (t : ℝ) :
    act (wall B R ν w t) q =
      fun i => act B q i + (t : Q) * act R q i +
        ν i * pair w q + w i * pair ν q := by
  funext i
  simp [act, wall, pair, add_mul, mul_assoc, Finset.sum_add_distrib, Finset.mul_sum]

theorem boundary_null_pairing
    (B R : ι → ι → Q) (ν w q v : ι → Q) (t : ℝ)
    (hB : act B q = 0) (hR : act R q = 0)
    (hνq : pair ν q = 0) (hvν : pair v ν = 0) :
    pair v (act (wall B R ν w t) q) = 0 := by
  have hk : act (wall B R ν w t) q = fun i => ν i * pair w q := by
    rw [act_wall, hB, hR, hνq]
    simp
  rw [hk, pair_right_mul, hvν, zero_mul]

end QuaternionicWall

section HolomorphicFiber

variable {ι : Type*} [Fintype ι]

def squareSum (W : ι → ℂ) : ℂ := ∑ i, W i * W i

def ratioDifferential (W : ι → ℂ) (y : ℂ) (p : ι → ℂ) : ι → ℂ :=
  fun i => p i - W i * y

def passiveDifferential (W : ι → ℂ) (y : ℂ) (p : ι → ℂ) (s : ℂ) : ℂ :=
  -(squareSum W) / 2 * y + (∑ i, W i * p i) + s

theorem fiber_null_vector (W : ι → ℂ) :
    ratioDifferential W 1 W = 0 ∧
      passiveDifferential W 1 W (-(squareSum W) / 2) = 0 := by
  constructor
  · funext i
    simp [ratioDifferential]
  · simp only [passiveDifferential, squareSum, mul_one]
    ring

theorem null_vector_nonzero (W : ι → ℂ) :
    ((1 : ℂ), W, -(squareSum W) / 2) ≠ (0, 0, 0) := by
  intro h
  have hfirst : (1 : ℂ) = 0 := congrArg Prod.fst h
  exact one_ne_zero hfirst

variable [DecidableEq ι]

def scaledSpatialJacobian (W : ι → ℂ) : Matrix (ι ⊕ Unit) (ι ⊕ Unit) ℂ :=
  Matrix.fromBlocks 1 (fun i _ => -W i) (fun _ j => W j)
    (fun _ _ => 1 - squareSum W / 2)

theorem scaled_spatial_jacobian_det (W : ι → ℂ) :
    (scaledSpatialJacobian W).det = 1 + squareSum W / 2 := by
  rw [scaledSpatialJacobian, Matrix.det_fromBlocks_one₁₁]
  simp [Matrix.det_unique, Matrix.sub_apply, Matrix.mul_apply, squareSum,
    mul_neg, Finset.sum_neg_distrib]
  ring

theorem chart_denominator_nonzero (S : ℂ) (hS : ‖S‖ < 2) :
    1 + S / 2 ≠ 0 := by
  intro h
  have hs : S = -2 := by
    linear_combination 2 * h
  rw [hs] at hS
  norm_num at hS

end HolomorphicFiber

section RealCompression

variable {κ : Type*} [Fintype κ] [DecidableEq κ]

theorem real_compression_singular (M : Matrix κ κ ℝ) (q : κ → ℝ)
    (hq : q ≠ 0) (hMq : Matrix.mulVec M q = 0) : M.det = 0 := by
  exact Matrix.exists_mulVec_eq_zero_iff.mp ⟨q, hq, hMq⟩

end RealCompression

end EnergyBridge

end
