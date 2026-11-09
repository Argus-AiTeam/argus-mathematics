import Mathlib

set_option maxHeartbeats 1600000

namespace ExactTransitivity

abbrev M2 (K : Type*) := Matrix (Fin 2) (Fin 2) K

section Matrices

variable {K : Type*} [Field K]

def mat (a b c d : K) : M2 K := !![a, b; c, d]

theorem mat_mul (a b c d e f g h : K) :
    mat a b c d * mat e f g h =
      mat (a * e + b * g) (a * f + b * h)
        (c * e + d * g) (c * f + d * h) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [mat, Matrix.mul_apply, Fin.sum_univ_two]

def upper (x : K) : M2 K := mat 1 x 0 1
def lower (x : K) : M2 K := mat 1 0 x 1
def diagonal (x : K) : M2 K := mat x 0 0 1
def inverse (a b c d : K) : M2 K :=
  mat (d / (a * d - b * c)) (-b / (a * d - b * c))
    (-c / (a * d - b * c)) (a / (a * d - b * c))

theorem mat_inverse (a b c d : K) (hdet : a * d - b * c ≠ 0) :
    mat a b c d * inverse a b c d = 1 := by
  rw [inverse, mat_mul]
  ext i j
  fin_cases i <;> fin_cases j <;> dsimp [mat] <;>
    generalize he : a * d - b * c = e at *
  all_goals field_simp [hdet] <;> simp [← he, Matrix.one_apply] <;> ring

def phaseComm (a b c d x : K) : M2 K :=
  diagonal x * mat a b c d * diagonal x⁻¹ * inverse a b c d

def phaseCommInv (a b c d x : K) : M2 K :=
  mat a b c d * diagonal x * inverse a b c d * diagonal x⁻¹

def separator (a b c d x y : K) : M2 K :=
  phaseComm a b c d x * phaseComm a b c d y *
    phaseCommInv a b c d x * phaseCommInv a b c d y

theorem separator_lower_left (a b c d x y : K)
    (hx : x ≠ 0) (hy : y ≠ 0) (hdet : a * d - b * c ≠ 0) :
    separator a b c d x y 1 0 =
      b * c ^ 2 * d * (x - 1) * (x - y) * (y - 1) *
        (a * d * x * y - a * d * x - a * d * y + b * c) /
        (x ^ 2 * y ^ 2 * (a * d - b * c) ^ 3) := by
  simp only [separator, phaseComm, phaseCommInv, diagonal, inverse, mat_mul]
  dsimp [mat]
  generalize he : a * d - b * c = e at *
  field_simp [hx, hy, hdet]
  simp only [← he]
  ring

theorem triangular_phase_comm (a b d x : K)
    (ha : a ≠ 0) (hd : d ≠ 0) (hx : x ≠ 0) :
    phaseComm a b 0 d x = upper ((x - 1) * b / d) := by
  simp only [phaseComm, diagonal, inverse, upper, mat_mul]
  ext i j
  fin_cases i <;> fin_cases j <;> simp [mat] <;>
    field_simp [ha, hd, hx] <;> ring

theorem opposite_commutator (x y : K) :
    (upper x * lower y * upper (-x) * lower (-y)) 1 0 = x * y ^ 2 := by
  simp [upper, lower, mat_mul, mat]
  ring

def affine (l z : K) : M2 K := mat l z 0 l⁻¹
def affineInv (l z : K) : M2 K := mat l⁻¹ (-z) 0 l

def affineUnit (l z : K) (hl : l ≠ 0) : (M2 K)ˣ where
  val := affine l z
  inv := affineInv l z
  val_inv := by
    rw [affine, affineInv, mat_mul]
    ext i j
    fin_cases i <;> fin_cases j <;> simp [mat, hl] <;> ring
  inv_val := by
    rw [affine, affineInv, mat_mul]
    ext i j
    fin_cases i <;> fin_cases j <;> simp [mat, hl] <;> ring

def upperUnit (x : K) : (M2 K)ˣ := affineUnit 1 x one_ne_zero

theorem affine_commutator (l z x : K) (hl : l ≠ 0) :
    affine l z * upper x * affineInv l z * upper (-x) =
      upper ((l ^ 2 - 1) * x) := by
  simp only [affine, affineInv, upper, mat_mul]
  ext i j
  fin_cases i <;> fin_cases j <;> simp [mat] <;>
    field_simp [hl] <;> ring

theorem affineUnit_commutator (l z x : K) (hl : l ≠ 0) :
    affineUnit l z hl * upperUnit x * (affineUnit l z hl)⁻¹ *
        (upperUnit x)⁻¹ = upperUnit ((l ^ 2 - 1) * x) := by
  apply Units.ext
  change affine l z * affine 1 x * affineInv l z * affineInv 1 x =
    affine 1 ((l ^ 2 - 1) * x)
  simpa [affine, affineInv, upper] using affine_commutator l z x hl

theorem normalizing_matrix (a b c d u : K)
    (hc : c ≠ 0) (hu : u ≠ 0) (hdet : a * d - b * c ≠ 0) :
    affineInv u (((1 - u ^ 2) * (a / c)) / u) * inverse a b c d *
        affine u (((1 - u ^ 2) * (a / c)) / u) * mat a b c d =
      affine ((u⁻¹) ^ 2) ((1 - u ^ 2) * (d - a * u ^ 2) / (u ^ 2 * c)) := by
  simp only [affineInv, affine, inverse, mat_mul]
  ext i j
  fin_cases i <;> fin_cases j <;> dsimp [mat] <;>
    generalize he : a * d - b * c = e at *
  all_goals field_simp [hc, hu, hdet] <;> simp only [← he] <;> ring

theorem unit_inverse_value (p : (M2 K)ˣ) (a b c d : K)
    (hp : (p : M2 K) = mat a b c d) (hdet : a * d - b * c ≠ 0) :
    ((p⁻¹ : (M2 K)ˣ) : M2 K) = inverse a b c d := by
  have hg := mat_inverse a b c d hdet
  have hi : ((p⁻¹ : (M2 K)ˣ) : M2 K) * (p : M2 K) = 1 := p.inv_val
  calc
    ((p⁻¹ : (M2 K)ˣ) : M2 K) =
        ((p⁻¹ : (M2 K)ˣ) : M2 K) * 1 := by simp
    _ = ((p⁻¹ : (M2 K)ˣ) : M2 K) *
        (mat a b c d * inverse a b c d) := by rw [hg]
    _ = inverse a b c d := by rw [← mul_assoc, ← hp, hi, one_mul]

theorem four_shear_diagonal (s t u : K) (hu : u ≠ 0) (heq : u = 1 + s * t) :
    upper s * lower t * upper (-s / u) * lower (-t * u) =
      mat u 0 0 u⁻¹ := by
  simp only [upper, lower, mat_mul]
  ext i j
  fin_cases i <;> fin_cases j <;> dsimp [mat] <;>
    field_simp [hu] <;> simp only [heq] <;> ring

theorem normal_extract
    (H P : Subgroup ((M2 K)ˣ))
    (hnormal : ∀ h ∈ H, ∀ p ∈ P, h * p * h⁻¹ ∈ P)
    (p : (M2 K)ˣ) (hp : p ∈ P)
    (a b c d u x : K)
    (hpval : (p : M2 K) = mat a b c d)
    (hc : c ≠ 0) (hu : u ≠ 0) (hdet : a * d - b * c ≠ 0)
    (hh : affineUnit u (((1 - u ^ 2) * (a / c)) / u) hu ∈ H)
    (hxH : upperUnit x ∈ H) :
    upperUnit (((u⁻¹) ^ 4 - 1) * x) ∈ P := by
  let h := affineUnit u (((1 - u ^ 2) * (a / c)) / u) hu
  let q := h⁻¹ * p⁻¹ * h * p
  have hq : q ∈ P := by
    have ht := hnormal h⁻¹ (H.inv_mem hh) p⁻¹ (P.inv_mem hp)
    have ht' : h⁻¹ * p⁻¹ * h ∈ P := by simpa using ht
    exact P.mul_mem ht' hp
  have hqval :
      (q : M2 K) =
        affine ((u⁻¹) ^ 2) ((1 - u ^ 2) * (d - a * u ^ 2) / (u ^ 2 * c)) := by
    change affineInv u (((1 - u ^ 2) * (a / c)) / u) *
        ((p⁻¹ : (M2 K)ˣ) : M2 K) *
        affine u (((1 - u ^ 2) * (a / c)) / u) * (p : M2 K) = _
    rw [unit_inverse_value p a b c d hpval hdet, hpval]
    exact normalizing_matrix a b c d u hc hu hdet
  have hl : (u⁻¹) ^ 2 ≠ 0 := pow_ne_zero 2 (inv_ne_zero hu)
  let z := (1 - u ^ 2) * (d - a * u ^ 2) / (u ^ 2 * c)
  have hqeq : q = affineUnit ((u⁻¹) ^ 2) z hl := by
    apply Units.ext
    exact hqval
  have hstep : q * upperUnit x * q⁻¹ * (upperUnit x)⁻¹ ∈ P := by
    have ht := hnormal (upperUnit x) hxH q⁻¹ (P.inv_mem hq)
    simpa [mul_assoc] using P.mul_mem hq ht
  have heq : q * upperUnit x * q⁻¹ * (upperUnit x)⁻¹ =
      upperUnit (((u⁻¹) ^ 4 - 1) * x) := by
    have ht := affineUnit_commutator ((u⁻¹) ^ 2) z x hl
    have hpowers : (((u⁻¹) ^ 2) ^ 2 - 1) * x = ((u⁻¹) ^ 4 - 1) * x := by ring
    rw [hpowers] at ht
    simpa only [hqeq] using ht
  rwa [heq] at hstep

theorem extracted_shear_nonidentity (u x : K)
    (hu4 : u ^ 4 ≠ 1) (hx : x ≠ 0) :
    upperUnit (((u⁻¹) ^ 4 - 1) * x) ≠ 1 := by
  have hi : (u⁻¹) ^ 4 ≠ 1 := by
    intro heq
    have ht := congrArg (fun y : K => y⁻¹) heq
    apply hu4
    simpa only [← inv_pow, inv_inv, inv_one] using ht
  have hz : ((u⁻¹) ^ 4 - 1) * x ≠ 0 := mul_ne_zero (sub_ne_zero.mpr hi) hx
  intro heq
  have ht := congrArg (fun g : (M2 K)ˣ => (g : M2 K) 0 1) heq
  exact hz (by simpa [upperUnit, affineUnit, affine, mat] using ht)

end Matrices

section Groups

variable {G : Type*} [Group G]

theorem commutator_in_intersection (A B : Subgroup G)
    (hA : ∀ g : G, ∀ a ∈ A, g * a * g⁻¹ ∈ A)
    (hB : ∀ g : G, ∀ b ∈ B, g * b * g⁻¹ ∈ B)
    (a b : G) (ha : a ∈ A) (hb : b ∈ B) :
    a * b * a⁻¹ * b⁻¹ ∈ A ⊓ B := by
  constructor
  · have ht := hA b a⁻¹ (A.inv_mem ha)
    simpa [mul_assoc] using A.mul_mem ha ht
  · exact B.mul_mem (hB a b hb) (B.inv_mem hb)

end Groups

section ExactAdditiveAction

variable {D B : Type*} [DivisionRing D]

def increments (f : D → B) : AddSubgroup D where
  carrier := {y | ∀ a, f (a + y) = f a}
  zero_mem' := by intro a; simp
  add_mem' := by
    intro x y hx hy a
    calc
      f (a + (x + y)) = f ((a + x) + y) := by rw [add_assoc]
      _ = f (a + x) := hy (a + x)
      _ = f a := hx a
  neg_mem' := by
    intro x hx a
    have ht := hx (a + -x)
    simpa only [add_assoc, neg_add_cancel, add_zero] using ht.symm

theorem exact_additive_amplification
    (V : Subgroup Dˣ)
    (hspan : AddSubgroup.closure (Units.val '' (V : Set Dˣ)) = ⊤)
    (f : D → B)
    (hleft : ∀ v ∈ V, ∀ a, f ((v : D) * a) = f a)
    (y : D) (hy : y ≠ 0) (hstep : ∀ a, f (a + y) = f a) :
    ∀ a b, f a = f b := by
  let N := increments f
  let ry : D →+ D :=
    { toFun := fun z => z * y
      map_zero' := by simp
      map_add' := by intro a b; exact add_mul a b y }
  let Q := N.comap ry
  have hvalues : Units.val '' (V : Set Dˣ) ⊆ Q := by
    rintro z ⟨v, hv, rfl⟩
    change ∀ a, f (a + (v : D) * y) = f a
    intro a
    have hvi : (v : D) * ((v⁻¹ : Dˣ) : D) = 1 := v.val_inv
    calc
      f (a + (v : D) * y) =
          f ((v : D) * (((v⁻¹ : Dˣ) : D) * a + y)) := by
        rw [mul_add, ← mul_assoc, hvi, one_mul]
      _ = f (((v⁻¹ : Dˣ) : D) * a + y) := hleft v hv _
      _ = f (((v⁻¹ : Dˣ) : D) * a) := hstep _
      _ = f ((v : D) * (((v⁻¹ : Dˣ) : D) * a)) := (hleft v hv _).symm
      _ = f a := by rw [← mul_assoc, hvi, one_mul]
  have hle : AddSubgroup.closure (Units.val '' (V : Set Dˣ)) ≤ Q :=
    (AddSubgroup.closure_le Q).mpr hvalues
  have hall : ∀ z : D, z ∈ Q := by
    intro z
    apply hle
    rw [hspan]
    trivial
  have hincrement : ∀ z : D, z ∈ N := by
    intro z
    have ht := hall (z * y⁻¹)
    change (z * y⁻¹) * y ∈ N at ht
    simpa only [mul_assoc, inv_mul_cancel₀ hy, mul_one] using ht
  intro a b
  have ht := hincrement (b - a)
  change ∀ z, f (z + (b - a)) = f z at ht
  have ht' := ht a
  have hab : a + (b - a) = b := by abel
  rw [hab] at ht'
  exact ht'.symm

theorem pair_invariant_constant
    (V : Subgroup Dˣ)
    (hspan : AddSubgroup.closure (Units.val '' (V : Set Dˣ)) = ⊤)
    (f : D × D → B)
    (hfirst : ∀ v ∈ V, ∀ a c, f ((v : D) * a, c) = f (a, c))
    (hsecond : ∀ v ∈ V, ∀ a c, f (a, (v : D) * c) = f (a, c))
    (hupper : ∀ c : D, c ≠ 0 →
      ∃ y : D, y ≠ 0 ∧ ∀ a, f (a + y, c) = f (a, c))
    (hlower : ∀ a : D, a ≠ 0 →
      ∃ y : D, y ≠ 0 ∧ ∀ c, f (a, c + y) = f (a, c)) :
    ∀ a c : D, (a, c) ≠ (0, 0) → f (a, c) = f (1, 1) := by
  have hrow : ∀ c : D, c ≠ 0 → ∀ a b, f (a, c) = f (b, c) := by
    intro c hc
    obtain ⟨y, hy, hs⟩ := hupper c hc
    exact exact_additive_amplification V hspan (fun a => f (a, c))
      (fun v hv a => hfirst v hv a c) y hy hs
  have hcol : ∀ a : D, a ≠ 0 → ∀ c d, f (a, c) = f (a, d) := by
    intro a ha
    obtain ⟨y, hy, hs⟩ := hlower a ha
    exact exact_additive_amplification V hspan (fun c => f (a, c))
      (fun v hv c => hsecond v hv a c) y hy hs
  intro a c hpair
  by_cases hc : c = 0
  · have ha : a ≠ 0 := by
      intro ha
      apply hpair
      simp [ha, hc]
    exact (hcol a ha c 1).trans (hrow 1 one_ne_zero a 1)
  · exact (hrow c hc a 1).trans (hcol 1 one_ne_zero c 1)

end ExactAdditiveAction

end ExactTransitivity
