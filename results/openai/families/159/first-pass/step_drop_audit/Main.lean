import Mathlib

namespace StepDropAudit

theorem common_fiber
    {H G : Type*} [Group H] [Group G]
    (π : H →* G) (U : Subgroup H) {x y : H}
    (hx : x ∈ U) (hy : y ∈ U) (hxy : π x = π y) :
    x * y⁻¹ ∈ U ⊓ π.ker := by
  constructor
  · exact U.mul_mem hx (U.inv_mem hy)
  · change π (x * y⁻¹) = 1
    simp [hxy]

section Cocycle

variable {G A : Type*} [Group G] [AddCommGroup A] [DistribMulAction G A]
variable (Y : G → A) (hY : ∀ x y, Y (x * y) = Y x + x • Y y)

include hY in
theorem common_derivative
    (a b d : G) (e m u z v : A)
    (h : Y (a * b * d) - e - (a * b * d) • m =
      u + a • z + (a * b) • v) :
    Y b = a⁻¹ • (e + u - Y a) + b • (v + d • m - Y d) + z := by
  have h' := congrArg (fun q : A => a⁻¹ • q) h
  simp only [hY, smul_sub, smul_add, mul_smul, inv_smul_smul] at h'
  calc
    Y b =
        (a⁻¹ • Y a + Y b + b • Y d - a⁻¹ • e - b • (d • m)) -
          a⁻¹ • Y a - b • Y d + a⁻¹ • e + b • (d • m) := by abel
    _ = (a⁻¹ • u + z + b • v) -
          a⁻¹ • Y a - b • Y d + a⁻¹ • e + b • (d • m) := by rw [h']
    _ = _ := by
      simp only [smul_sub, smul_add]
      abel

include hY in
theorem transformed_derivative
    (a c b : G) (s r z : A)
    (h : Y (a * c * b) = s + (a * c * b) • r + z) :
    Y c = a⁻¹ • (s - Y a) + c • (b • r - Y b) + a⁻¹ • z := by
  have h' := congrArg (fun q : A => a⁻¹ • q) h
  simp only [hY, smul_add, mul_smul, inv_smul_smul] at h'
  calc
    Y c = (a⁻¹ • Y a + Y c + c • Y b) -
        a⁻¹ • Y a - c • Y b := by abel
    _ = (a⁻¹ • s + c • (b • r) + a⁻¹ • z) -
        a⁻¹ • Y a - c • Y b := by rw [h']
    _ = _ := by
      simp only [smul_sub]
      abel

theorem transformed_lift
    (a c b : G) (s r : A)
    (h : s = (a * c * b) • r) :
    a⁻¹ • s = c • (b • r) := by
  simp only [h, mul_smul, inv_smul_smul]

theorem absorption
    {K : Type*} [AddCommGroup K]
    (B : G) (S R : K →+ A) (hSR : ∀ k, S k = B • R k)
    (y s r : A) (k ks kr : K)
    (h : y = s + B • r + S k) :
    y = (s - S ks) + B • (r - R kr) + S (k + ks + kr) := by
  rw [h]
  simp only [map_add, smul_sub]
  rw [hSR kr]
  abel

end Cocycle

theorem bracket_correction
    {E A : Type*} [AddCommGroup E] [AddCommGroup A]
    (Q : E →+ A) (p a b : E) (s r : A)
    (hp : Q p = s - r) (ha : Q a = s) (hb : Q b = -r) :
    Q (p - a - b) = 0 := by
  simp only [map_sub, hp, ha, hb]
  abel

end StepDropAudit
