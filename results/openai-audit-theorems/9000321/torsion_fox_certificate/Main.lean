import Mathlib

open scoped BigOperators

noncomputable section

namespace TorsionFox

abbrev Word (n : ℕ) := FreeGroup (Fin n)
abbrev Vec (n : ℕ) := Fin n → ℂ

variable {n m : ℕ}

abbrev GroupOf (r : Fin m → Word n) := PresentedGroup (Set.range r)

def quotient (r : Fin m → Word n) : Word n →* GroupOf r :=
  PresentedGroup.mk (Set.range r)

def basis {k : ℕ} (i : Fin k) : Vec k := Pi.single i 1

section Differential

variable (r : Fin m → Word n) (ρ : GroupOf r →* ℂˣ)

def evalGroup : GroupOf r →* ℂ := (Units.coeHom ℂ).comp ρ
def evalWord : Word n →* ℂ := (evalGroup r ρ).comp (quotient r)

@[simp] theorem eval_mul_inv (w : Word n) :
    evalWord r ρ w * evalWord r ρ w⁻¹ = 1 := by
  rw [← map_mul, mul_inv_cancel, map_one]

@[simp] theorem eval_inv_mul (w : Word n) :
    evalWord r ρ w⁻¹ * evalWord r ρ w = 1 := by
  rw [← map_mul, inv_mul_cancel, map_one]

theorem eval_inv_one {w : Word n} (h : evalWord r ρ w = 1) :
    evalWord r ρ w⁻¹ = 1 := by
  simpa only [h, one_mul] using eval_mul_inv r ρ w

@[simp] theorem quotient_relator (j : Fin m) : quotient r (r j) = 1 :=
  PresentedGroup.one_of_mem ⟨j, rfl⟩

@[simp] theorem eval_relator (j : Fin m) : evalWord r ρ (r j) = 1 := by
  change evalGroup r ρ (quotient r (r j)) = 1
  rw [quotient_relator, map_one]

def action : GroupOf r →* MulAut (Multiplicative (Vec n)) where
  toFun g :=
    { toFun := fun v => Multiplicative.ofAdd (evalGroup r ρ g • v.toAdd)
      invFun := fun v => Multiplicative.ofAdd (evalGroup r ρ g⁻¹ • v.toAdd)
      left_inv := by
        intro v
        change evalGroup r ρ g⁻¹ • (evalGroup r ρ g • v.toAdd) = v.toAdd
        rw [smul_smul, ← map_mul, inv_mul_cancel, map_one, one_smul]
      right_inv := by
        intro v
        change evalGroup r ρ g • (evalGroup r ρ g⁻¹ • v.toAdd) = v.toAdd
        rw [smul_smul, ← map_mul, mul_inv_cancel, map_one, one_smul]
      map_mul' := by
        intro v w
        change evalGroup r ρ g • (v.toAdd + w.toAdd) =
          evalGroup r ρ g • v.toAdd + evalGroup r ρ g • w.toAdd
        exact smul_add _ _ _ }
  map_one' := by
    apply MulEquiv.ext
    intro v
    change evalGroup r ρ 1 • v.toAdd = v.toAdd
    rw [map_one, one_smul]
  map_mul' := by
    intro g h
    apply MulEquiv.ext
    intro v
    change evalGroup r ρ (g * h) • v.toAdd =
      evalGroup r ρ g • (evalGroup r ρ h • v.toAdd)
    rw [map_mul, mul_smul]

abbrev PathGroup := Multiplicative (Vec n) ⋊[action r ρ] GroupOf r

def path : Word n →* PathGroup r ρ :=
  FreeGroup.lift fun i =>
    ⟨Multiplicative.ofAdd (basis i), quotient r (FreeGroup.of i)⟩

theorem path_right (w : Word n) : (path r ρ w).right = quotient r w := by
  have h : (SemidirectProduct.rightHom : PathGroup r ρ →* GroupOf r).comp
      (path r ρ) = quotient r :=
    FreeGroup.ext_hom _ _ (by intro i; simp [path])
  exact congrArg (fun f : Word n →* GroupOf r => f w) h

def fox (w : Word n) : Vec n := (path r ρ w).left.toAdd

@[simp] theorem fox_one : fox r ρ 1 = 0 := by simp [fox]

@[simp] theorem fox_generator (i : Fin n) : fox r ρ (FreeGroup.of i) = basis i := by
  simp [fox, path]

theorem fox_mul (u v : Word n) :
    fox r ρ (u * v) = fox r ρ u + evalWord r ρ u • fox r ρ v := by
  simp [fox, action, evalWord, path_right]

theorem fox_inv (w : Word n) :
    fox r ρ w⁻¹ = -(evalWord r ρ w⁻¹ • fox r ρ w) := by
  simp [fox, action, evalWord, path_right, smul_neg]

def norm (q : ℕ) (a : ℂ) : ℂ := ∑ k ∈ Finset.range q, a ^ k

theorem fox_pow (w : Word n) (q : ℕ) :
    fox r ρ (w ^ q) = norm q (evalWord r ρ w) • fox r ρ w := by
  induction q with
  | zero => simp [norm]
  | succ q ih =>
      rw [pow_succ, fox_mul, ih, map_pow]
      simp [norm, Finset.sum_range_succ, add_smul]

def boundary : Vec m →ₗ[ℂ] Vec n where
  toFun c := ∑ j, c j • fox r ρ (r j)
  map_add' c d := by simp [add_smul, Finset.sum_add_distrib]
  map_smul' a c := by simp [Finset.smul_sum, smul_smul]

@[simp] theorem boundary_basis (j : Fin m) :
    boundary r ρ (basis j) = fox r ρ (r j) := by
  classical
  simp [boundary, basis, Pi.single_apply, ite_smul]

def firstBoundary : Vec n →ₗ[ℂ] ℂ where
  toFun v := ∑ i, v i * (evalWord r ρ (FreeGroup.of i) - 1)
  map_add' v w := by simp [add_mul, Finset.sum_add_distrib]
  map_smul' a v := by simp [Finset.mul_sum, mul_assoc]

@[simp] theorem firstBoundary_basis (i : Fin n) :
    firstBoundary r ρ (basis i) = evalWord r ρ (FreeGroup.of i) - 1 := by
  classical
  simp [firstBoundary, basis, Pi.single_apply, ite_mul]

theorem fox_fundamental (w : Word n) :
    firstBoundary r ρ (fox r ρ w) = evalWord r ρ w - 1 := by
  refine FreeGroup.induction_on w ?_ ?_ ?_ ?_
  · simp
  · intro i
    simp
  · intro i hi
    simp only [fox_inv, map_neg, map_smul, hi, smul_eq_mul]
    linear_combination -(eval_inv_mul r ρ (FreeGroup.of i))
  · intro u v hu hv
    rw [fox_mul, map_add, map_smul, hu, hv, map_mul]
    simp only [smul_eq_mul]
    ring

theorem firstBoundary_boundary (c : Vec m) :
    firstBoundary r ρ (boundary r ρ c) = 0 := by
  change firstBoundary r ρ (∑ j, c j • fox r ρ (r j)) = 0
  simp [map_sum, map_smul, fox_fundamental]

theorem fox_conjugate {v : Word n} (hv : evalWord r ρ v = 1) (u : Word n) :
    fox r ρ (u * v * u⁻¹) = evalWord r ρ u • fox r ρ v := by
  simp only [fox_mul, fox_inv, map_mul, hv, mul_one, smul_neg,
    smul_smul, eval_mul_inv, one_smul]
  abel

end Differential

structure Factor (n m : ℕ) where
  index : Fin m
  conjugator : Word n
  positive : Bool

def factorWord (r : Fin m → Word n) (f : Factor n m) : Word n :=
  f.conjugator * (if f.positive then r f.index else (r f.index)⁻¹) * f.conjugator⁻¹

def witnessWord (r : Fin m → Word n) : List (Factor n m) → Word n
  | [] => 1
  | f :: fs => factorWord r f * witnessWord r fs

def invertFactor (f : Factor n m) : Factor n m :=
  ⟨f.index, f.conjugator, !f.positive⟩

def invertWitness : List (Factor n m) → List (Factor n m)
  | [] => []
  | f :: fs => invertWitness fs ++ [invertFactor f]

def conjugateFactor (u : Word n) (f : Factor n m) : Factor n m :=
  ⟨f.index, u * f.conjugator, f.positive⟩

theorem witnessWord_append (r : Fin m → Word n) (fs gs : List (Factor n m)) :
    witnessWord r (fs ++ gs) = witnessWord r fs * witnessWord r gs := by
  induction fs with
  | nil => simp [witnessWord]
  | cons f fs ih => simp [witnessWord, ih, mul_assoc]

theorem factorWord_invert (r : Fin m → Word n) (f : Factor n m) :
    factorWord r (invertFactor f) = (factorWord r f)⁻¹ := by
  cases h : f.positive <;> simp [factorWord, invertFactor, h, mul_assoc]

theorem witnessWord_invert (r : Fin m → Word n) (fs : List (Factor n m)) :
    witnessWord r (invertWitness fs) = (witnessWord r fs)⁻¹ := by
  induction fs with
  | nil => simp [invertWitness, witnessWord]
  | cons f fs ih =>
      simp [invertWitness, witnessWord_append, witnessWord, ih, factorWord_invert]

theorem factorWord_conjugate (r : Fin m → Word n) (u : Word n) (f : Factor n m) :
    factorWord r (conjugateFactor u f) = u * factorWord r f * u⁻¹ := by
  simp [factorWord, conjugateFactor, mul_assoc]

theorem witnessWord_conjugate (r : Fin m → Word n) (u : Word n)
    (fs : List (Factor n m)) :
    witnessWord r (fs.map (conjugateFactor u)) = u * witnessWord r fs * u⁻¹ := by
  induction fs with
  | nil => simp [witnessWord]
  | cons f fs ih =>
      simp [witnessWord, factorWord_conjugate, ih, mul_assoc]

def witnessSubgroup (r : Fin m → Word n) : Subgroup (Word n) where
  carrier w := ∃ fs, witnessWord r fs = w
  one_mem' := ⟨[], rfl⟩
  mul_mem' := by
    rintro a b ⟨fs, rfl⟩ ⟨gs, rfl⟩
    exact ⟨fs ++ gs, witnessWord_append r fs gs⟩
  inv_mem' := by
    rintro a ⟨fs, rfl⟩
    exact ⟨invertWitness fs, witnessWord_invert r fs⟩

instance witnessSubgroup_normal (r : Fin m → Word n) : (witnessSubgroup r).Normal where
  conj_mem := by
    rintro a ⟨fs, rfl⟩ u
    exact ⟨fs.map (conjugateFactor u), witnessWord_conjugate r u fs⟩

theorem exists_witness (r : Fin m → Word n) {w : Word n}
    (hw : quotient r w = 1) : ∃ fs, witnessWord r fs = w := by
  have hle : Subgroup.normalClosure (Set.range r) ≤ witnessSubgroup r := by
    apply Subgroup.normalClosure_le_normal
    rintro _ ⟨j, rfl⟩
    exact ⟨[⟨j, 1, true⟩], by simp [witnessWord, factorWord]⟩
  exact hle (PresentedGroup.mk_eq_one_iff.mp hw)

section Certificates

variable (r : Fin m → Word n) (ρ : GroupOf r →* ℂˣ)

def factorChain (f : Factor n m) : Vec m :=
  (if f.positive then evalWord r ρ f.conjugator
    else -evalWord r ρ f.conjugator) • basis f.index

def witnessChain : List (Factor n m) → Vec m
  | [] => 0
  | f :: fs => factorChain r ρ f + witnessChain fs

@[simp] theorem eval_factor (f : Factor n m) : evalWord r ρ (factorWord r f) = 1 := by
  unfold factorWord
  split_ifs
  · rw [map_mul, map_mul, eval_relator, mul_one, eval_mul_inv]
  · rw [map_mul, map_mul, eval_inv_one r ρ (eval_relator r ρ f.index),
      mul_one, eval_mul_inv]

theorem boundary_factor (f : Factor n m) :
    boundary r ρ (factorChain r ρ f) = fox r ρ (factorWord r f) := by
  cases h : f.positive <;>
    simp [factorChain, factorWord, h, fox_conjugate, eval_relator,
      eval_inv_one r ρ (eval_relator r ρ f.index), fox_inv, neg_smul]

theorem boundary_witness (fs : List (Factor n m)) :
    boundary r ρ (witnessChain r ρ fs) = fox r ρ (witnessWord r fs) := by
  induction fs with
  | nil => simp [witnessChain, witnessWord]
  | cons f fs ih =>
      simp [witnessChain, witnessWord, map_add, fox_mul, boundary_factor, ih]

end Certificates

theorem norm_mul_sub (q : ℕ) (a : ℂ) :
    norm q a * (a - 1) = a ^ q - 1 := by
  induction q with
  | zero => simp [norm]
  | succ q ih =>
      have hs : norm (q + 1) a = norm q a + a ^ q := by
        simp [norm, Finset.sum_range_succ]
      rw [hs, pow_succ]
      calc
        (norm q a + a ^ q) * (a - 1) =
            norm q a * (a - 1) + a ^ q * a - a ^ q := by ring
        _ = a ^ q * a - 1 := by rw [ih]; ring

theorem norm_zero {q : ℕ} {a : ℂ} (ha : a ≠ 1) (hq : a ^ q = 1) :
    norm q a = 0 := by
  have h := norm_mul_sub q a
  rw [hq, sub_self] at h
  exact (mul_eq_zero.mp h).resolve_right (sub_ne_zero.mpr ha)

section Torsion

variable (r : Fin m → Word n) (ρ : GroupOf r →* ℂˣ)

theorem torsion_fox_zero {w : Word n} {q : ℕ}
    (hq : (quotient r w) ^ q = 1) (hρ : ρ (quotient r w) ≠ 1) :
    fox r ρ (w ^ q) = 0 := by
  have ha : evalWord r ρ w ≠ 1 := by
    intro h
    apply hρ
    apply Units.ext
    simpa [evalWord, evalGroup] using h
  have hp : (evalWord r ρ w) ^ q = 1 := by
    have h := congrArg (fun g : GroupOf r => evalGroup r ρ g) hq
    simpa [evalWord] using h
  rw [fox_pow, norm_zero ha hp, zero_smul]

theorem torsion_witness_in_kernel {w : Word n} {q : ℕ}
    (hq : (quotient r w) ^ q = 1) (hρ : ρ (quotient r w) ≠ 1)
    (fs : List (Factor n m)) (hfs : witnessWord r fs = w ^ q) :
    boundary r ρ (witnessChain r ρ fs) = 0 := by
  rw [boundary_witness, hfs]
  exact torsion_fox_zero r ρ hq hρ

theorem injective_boundary_forces_zero_certificate {w : Word n} {q : ℕ}
    (hinj : Function.Injective (boundary r ρ))
    (hq : (quotient r w) ^ q = 1) (hρ : ρ (quotient r w) ≠ 1)
    (fs : List (Factor n m)) (hfs : witnessWord r fs = w ^ q) :
    witnessChain r ρ fs = 0 := by
  apply hinj
  rw [torsion_witness_in_kernel r ρ hq hρ fs hfs, map_zero]

theorem torsion_has_certificate {w : Word n} {q : ℕ}
    (hq : (quotient r w) ^ q = 1) :
    ∃ fs, witnessWord r fs = w ^ q :=
  exists_witness r (by simpa only [map_pow] using hq)

theorem torsion_element_has_certificate (g : GroupOf r) (q : ℕ) (hq : g ^ q = 1) :
    ∃ (w : Word n) (fs : List (Factor n m)),
      quotient r w = g ∧ witnessWord r fs = w ^ q := by
  obtain ⟨w, hw⟩ := PresentedGroup.mk_surjective (Set.range r) g
  have hw' : quotient r w = g := hw
  obtain ⟨fs, hfs⟩ :=
    torsion_has_certificate r (w := w) (q := q) (by rw [hw']; exact hq)
  exact ⟨w, fs, hw, hfs⟩

end Torsion

def UniversalTorsionStatement : Prop :=
  ∀ (n m : ℕ) (r : Fin m → Word n) (ρ : GroupOf r →* ℂˣ),
    Function.Injective (boundary r ρ) →
    ∀ (g : GroupOf r) (q : ℕ), 0 < q → g ^ q = 1 → ρ g = 1

namespace Cancellation

def x : Word 1 := FreeGroup.of 0
def relator : Fin 1 → Word 1 := fun _ => x ^ 6
def witness : List (Factor 1 1) :=
  [⟨0, 1, true⟩, ⟨0, x, false⟩, ⟨0, x ^ 2, true⟩]

def zeta : ℂ := (1 + (Real.sqrt 3 : ℂ) * Complex.I) / 2

theorem zeta_quadratic : zeta ^ 2 - zeta + 1 = 0 := by
  have hs : (Real.sqrt 3) ^ 2 = 3 := Real.sq_sqrt (by norm_num)
  apply Complex.ext <;> norm_num [zeta, Complex.mul_re, Complex.mul_im, pow_two] <;>
    nlinarith

theorem zeta_sixth_power : zeta ^ 6 = 1 := by
  linear_combination (zeta ^ 4 + zeta ^ 3 - zeta - 1) * zeta_quadratic

theorem zeta_ne_zero : zeta ≠ 0 := by
  intro h
  have hz := zeta_quadratic
  norm_num [h] at hz

theorem zeta_ne_one : zeta ≠ 1 := by
  intro h
  have hz := zeta_quadratic
  norm_num [h] at hz

def zetaUnit : ℂˣ := Units.mk0 zeta zeta_ne_zero

theorem zetaUnit_sixth_power : zetaUnit ^ 6 = 1 := by
  apply Units.ext
  exact zeta_sixth_power

def character : GroupOf relator →* ℂˣ :=
  PresentedGroup.toGroup (f := fun _ : Fin 1 => zetaUnit) (by
    rintro w ⟨j, rfl⟩
    simpa [relator, x] using zetaUnit_sixth_power)

@[simp] theorem character_generator : character (quotient relator x) = zetaUnit := by
  exact PresentedGroup.toGroup.of _

@[simp] theorem eval_generator : evalWord relator character x = zeta := by
  change (character (quotient relator x) : ℂ) = zeta
  rw [character_generator]
  rfl

theorem word_identity : witnessWord relator witness = x ^ 6 := by
  simp [witnessWord, witness, factorWord, relator]
  group

theorem coefficient_zero (ρ : GroupOf relator →* ℂˣ)
    (hζ : (evalWord relator ρ x) ^ 2 - evalWord relator ρ x + 1 = 0) :
    witnessChain relator ρ witness = 0 := by
  ext i
  fin_cases i
  simpa [witnessChain, witness, factorChain, basis, sub_eq_add_neg, add_comm,
    add_left_comm, add_assoc] using hζ

theorem exact_zero_certificate :
    (quotient relator x) ^ 6 = 1 ∧
      character (quotient relator x) ≠ 1 ∧
      witnessWord relator witness = x ^ 6 ∧
      witnessChain relator character witness = 0 := by
  refine ⟨?_, ?_, word_identity, ?_⟩
  · simpa only [relator, map_pow] using quotient_relator relator (0 : Fin 1)
  · rw [character_generator]
    intro h
    apply zeta_ne_one
    exact congrArg (fun u : ℂˣ => (u : ℂ)) h
  · apply coefficient_zero
    simpa using zeta_quadratic

theorem boundary_not_injective : ¬ Function.Injective (boundary relator character) := by
  intro h
  have hz : fox relator character (x ^ 6) = 0 :=
    torsion_fox_zero relator character exact_zero_certificate.1
      exact_zero_certificate.2.1
  have he : boundary relator character (basis (0 : Fin 1)) =
      boundary relator character 0 := by
    rw [boundary_basis, map_zero]
    exact hz
  have hc := congrFun (h he) (0 : Fin 1)
  norm_num [basis] at hc

end Cancellation

end TorsionFox

namespace FoxTower

open TorsionFox

variable {n m : ℕ} {V : Type}

structure RightAction (n : ℕ) (V : Type) where
  act : Word n → V → V
  one : ∀ v, act 1 v = v
  mul : ∀ u w v, act (u * w) v = act w (act u v)

namespace RightAction

variable (A : RightAction n V)

@[simp] theorem act_one (v : V) : A.act 1 v = v := A.one v

theorem act_mul (u w : Word n) (v : V) :
    A.act (u * w) v = A.act w (A.act u v) := A.mul u w v

@[simp] theorem act_inv_act (w : Word n) (v : V) :
    A.act w⁻¹ (A.act w v) = v := by
  rw [← A.act_mul, mul_inv_cancel, A.act_one]

@[simp] theorem act_act_inv (w : Word n) (v : V) :
    A.act w (A.act w⁻¹ v) = v := by
  rw [← A.act_mul, inv_mul_cancel, A.act_one]

def shiftAction : Word n →* MulAut (Multiplicative (V → ℚ)) where
  toFun w :=
    { toFun := fun f => Multiplicative.ofAdd (fun v => f.toAdd (A.act w v))
      invFun := fun f => Multiplicative.ofAdd (fun v => f.toAdd (A.act w⁻¹ v))
      left_inv := by
        intro f
        change (fun v => f.toAdd (A.act w (A.act w⁻¹ v))) = f.toAdd
        simp
      right_inv := by
        intro f
        change (fun v => f.toAdd (A.act w⁻¹ (A.act w v))) = f.toAdd
        simp
      map_mul' := by intros; rfl }
  map_one' := by
    apply MulEquiv.ext
    intro f
    change (fun v => f.toAdd (A.act 1 v)) = f.toAdd
    simp
  map_mul' := by
    intro u w
    apply MulEquiv.ext
    intro f
    change (fun v => f.toAdd (A.act (u * w) v)) =
      (fun v => f.toAdd (A.act w (A.act u v)))
    simp [A.act_mul]

abbrev VoltageGroup := Multiplicative (V → ℚ) ⋊[A.shiftAction] Word n

def voltagePath (a : V → Fin n → ℚ) : Word n →* A.VoltageGroup :=
  FreeGroup.lift fun i =>
    ⟨Multiplicative.ofAdd (fun v => a v i), FreeGroup.of i⟩

theorem voltagePath_right (a : V → Fin n → ℚ) (w : Word n) :
    (A.voltagePath a w).right = w := by
  have h : (SemidirectProduct.rightHom : A.VoltageGroup →* Word n).comp
      (A.voltagePath a) = MonoidHom.id (Word n) :=
    FreeGroup.ext_hom _ _ (by intro i; simp [voltagePath])
  exact congrArg (fun f : Word n →* Word n => f w) h

def voltage (a : V → Fin n → ℚ) (w : Word n) (v : V) : ℚ :=
  (A.voltagePath a w).left.toAdd v

@[simp] theorem voltage_one (a : V → Fin n → ℚ) (v : V) :
    A.voltage a 1 v = 0 := by simp [voltage]

@[simp] theorem voltage_generator (a : V → Fin n → ℚ) (v : V) (i : Fin n) :
    A.voltage a (FreeGroup.of i) v = a v i := by
  simp [voltage, voltagePath]

theorem voltage_mul (a : V → Fin n → ℚ) (u w : Word n) (v : V) :
    A.voltage a (u * w) v =
      A.voltage a u v + A.voltage a w (A.act u v) := by
  simp [voltage, shiftAction, voltagePath_right]

theorem voltage_inv (a : V → Fin n → ℚ) (w : Word n) (v : V) :
    A.voltage a w⁻¹ v = -A.voltage a w (A.act w⁻¹ v) := by
  simp [voltage, shiftAction, voltagePath_right]

def lift (a : V → Fin n → ℚ) : RightAction n (V × ℚ) where
  act w p := (A.act w p.1, p.2 + A.voltage a w p.1)
  one p := by simp
  mul u w p := by simp [A.act_mul, A.voltage_mul, add_assoc]

theorem lift_act (a : V → Fin n → ℚ) (w : Word n) (p : V × ℚ) :
    (A.lift a).act w p = (A.act w p.1, p.2 + A.voltage a w p.1) := rfl

@[simp] theorem lift_fst (a : V → Fin n → ℚ) (w : Word n) (p : V × ℚ) :
    ((A.lift a).act w p).1 = A.act w p.1 := rfl

@[simp] theorem lift_snd (a : V → Fin n → ℚ) (w : Word n) (p : V × ℚ) :
    ((A.lift a).act w p).2 = p.2 + A.voltage a w p.1 := rfl

theorem voltage_pow_of_fixed (a : V → Fin n → ℚ) (w : Word n) (v : V)
    (hw : A.act w v = v) (q : ℕ) :
    A.voltage a (w ^ q) v = (q : ℚ) * A.voltage a w v := by
  induction q with
  | zero => simp
  | succ q ih =>
      rw [pow_succ', A.voltage_mul, hw, ih]
      push_cast
      ring

theorem inv_fixed {w : Word n} {v : V} (h : A.act w v = v) :
    A.act w⁻¹ v = v := by
  simpa only [h] using A.act_inv_act w v

theorem conjugate_fixed (u w : Word n) (v : V)
    (h : A.act w (A.act u v) = A.act u v) :
    A.act (u * w * u⁻¹) v = v := by
  rw [A.act_mul, A.act_mul, h, A.act_inv_act]

theorem prod_fixed (ws : List (Word n)) (v : V)
    (h : ∀ w ∈ ws, A.act w v = v) :
    A.act ws.prod v = v := by
  induction ws with
  | nil => simp
  | cons w ws ih =>
      rw [List.prod_cons, A.act_mul, h w (by simp)]
      exact ih (by intro z hz; exact h z (by simp [hz]))

theorem lift_relator_fixed (a : V → Fin n → ℚ) (u r : Word n) (v : V)
    (hr : A.act r (A.act u v) = A.act u v)
    (ha : A.voltage a r (A.act u v) = 0) :
    (A.lift a).act r ((A.lift a).act u (v, 0)) =
      (A.lift a).act u (v, 0) := by
  ext <;> simp [hr, ha]

theorem lift_factor_fixed (a : V → Fin n → ℚ) (r : Fin m → Word n)
    (v : V) (f : Factor n m)
    (hr : A.act (r f.index) (A.act f.conjugator v) = A.act f.conjugator v)
    (ha : A.voltage a (r f.index) (A.act f.conjugator v) = 0) :
    (A.lift a).act (factorWord r f) (v, 0) = (v, 0) := by
  apply (A.lift a).conjugate_fixed
  have h := A.lift_relator_fixed a f.conjugator (r f.index) v hr ha
  cases hp : f.positive
  · exact (A.lift a).inv_fixed h
  · exact h

theorem lift_witness_fixed (a : V → Fin n → ℚ) (r : Fin m → Word n)
    (v : V) (fs : List (Factor n m))
    (hr : ∀ f ∈ fs, A.act (r f.index) (A.act f.conjugator v) = A.act f.conjugator v)
    (ha : ∀ f ∈ fs, A.voltage a (r f.index) (A.act f.conjugator v) = 0) :
    (A.lift a).act (witnessWord r fs) (v, 0) = (v, 0) := by
  induction fs with
  | nil => simp [witnessWord]
  | cons f fs ih =>
      rw [witnessWord, (A.lift a).act_mul,
        A.lift_factor_fixed a r v f (hr f (by simp)) (ha f (by simp))]
      exact ih (by intro z hz; exact hr z (by simp [hz]))
        (by intro z hz; exact ha z (by simp [hz]))

theorem torsion_voltage_zero (a : V → Fin n → ℚ) (r : Fin m → Word n)
    (v : V) (w : Word n) (q : ℕ) (hq : 0 < q)
    (hw : A.act w v = v) (fs : List (Factor n m))
    (hfs : witnessWord r fs = w ^ q)
    (hr : ∀ f ∈ fs, A.act (r f.index) (A.act f.conjugator v) = A.act f.conjugator v)
    (ha : ∀ f ∈ fs, A.voltage a (r f.index) (A.act f.conjugator v) = 0) :
    A.voltage a w v = 0 := by
  have h := congrArg Prod.snd (A.lift_witness_fixed a r v fs hr ha)
  simp only [lift_snd, zero_add, hfs, A.voltage_pow_of_fixed a w v hw q] at h
  exact (mul_eq_zero.mp h).resolve_left (by exact_mod_cast (Nat.ne_of_gt hq))

theorem torsion_lifts (a : V → Fin n → ℚ) (r : Fin m → Word n)
    (v : V) (w : Word n) (q : ℕ) (hq : 0 < q)
    (hw : A.act w v = v) (fs : List (Factor n m))
    (hfs : witnessWord r fs = w ^ q)
    (hr : ∀ f ∈ fs, A.act (r f.index) (A.act f.conjugator v) = A.act f.conjugator v)
    (ha : ∀ f ∈ fs, A.voltage a (r f.index) (A.act f.conjugator v) = 0) :
    (A.lift a).act w (v, 0) = (v, 0) := by
  ext
  · exact hw
  · simpa using A.torsion_voltage_zero a r v w q hq hw fs hfs hr ha

end RightAction

abbrev Letter (n : ℕ) := Fin n × Bool

def letterWord (l : Letter n) : Word n :=
  cond l.2 (FreeGroup.of l.1) (FreeGroup.of l.1)⁻¹

def lettersWord (ls : List (Letter n)) : Word n :=
  (ls.map letterWord).prod

theorem lettersWord_toWord (w : Word n) : lettersWord w.toWord = w := by
  have hi : FreeGroup.lift (fun i : Fin n => FreeGroup.of i) =
      MonoidHom.id (Word n) :=
    FreeGroup.ext_hom _ _ (by intro i; simp)
  have h := FreeGroup.lift_mk (f := fun i : Fin n => FreeGroup.of i) (L := w.toWord)
  rw [hi, MonoidHom.id_apply, FreeGroup.mk_toWord] at h
  exact h.symm

def walkEdges (A : RightAction n V) : V → List (Letter n) → List (V × Fin n)
  | _, [] => []
  | v, l :: ls =>
      (cond l.2 (v, l.1) (A.act (FreeGroup.of l.1)⁻¹ v, l.1)) ::
        walkEdges A (A.act (letterWord l) v) ls

theorem walkEdges_length (A : RightAction n V) (ls : List (Letter n)) (v : V) :
    (walkEdges A v ls).length = ls.length := by
  induction ls generalizing v with
  | nil => rfl
  | cons l ls ih => simp [walkEdges, ih]

theorem walkEdges_natural {W : Type} (A : RightAction n V) (B : RightAction n W)
    (f : W → V) (hf : ∀ w v, f (B.act w v) = A.act w (f v))
    (ls : List (Letter n)) (v : W) :
    (walkEdges B v ls).map (fun e => (f e.1, e.2)) = walkEdges A (f v) ls := by
  induction ls generalizing v with
  | nil => rfl
  | cons l ls ih =>
      cases hb : l.2 <;> simp [walkEdges, letterWord, hb, ih, hf]

def sourcePaths (r : Fin m → Word n) (w : Word n) (fs : List (Factor n m)) :
    List (Word n × List (Letter n)) :=
  (1, w.toWord) :: fs.flatMap (fun f =>
    [(1, f.conjugator.toWord), (f.conjugator, (r f.index).toWord)])

def sourceEdges (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) : List (V × Fin n) :=
  ps.flatMap fun p => walkEdges A (A.act p.1 v) p.2

def sourceVertices (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) : List V :=
  v :: (sourceEdges A v ps).flatMap (fun e => [e.1, A.act (FreeGroup.of e.2) e.1])

noncomputable def vertexSet (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) : Finset V := by
  classical
  exact (sourceVertices A v ps).toFinset

def sourceBudget (ps : List (Word n × List (Letter n))) : ℕ :=
  1 + 2 * (ps.map (fun p => p.2.length)).sum

theorem sourceEdges_length (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) :
    (sourceEdges A v ps).length = (ps.map (fun p => p.2.length)).sum := by
  simp [sourceEdges, List.length_flatMap, walkEdges_length]

theorem sourceVertices_length (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) :
    (sourceVertices A v ps).length = sourceBudget ps := by
  have h : ∀ es : List (V × Fin n),
      (es.flatMap (fun e => [e.1, A.act (FreeGroup.of e.2) e.1])).length =
        2 * es.length := by
    intro es
    induction es with
    | nil => simp
    | cons e es ih => simp [ih]; omega
  simp only [sourceVertices, List.length_cons, h, sourceEdges_length, sourceBudget]
  omega

theorem vertexSet_bound (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) :
    (vertexSet A v ps).card ≤ sourceBudget ps := by
  classical
  simpa only [vertexSet, sourceVertices_length] using
    (List.toFinset_card_le (sourceVertices A v ps))

theorem sourceEdges_natural {W : Type} (A : RightAction n V) (B : RightAction n W)
    (f : W → V) (hf : ∀ w v, f (B.act w v) = A.act w (f v))
    (ps : List (Word n × List (Letter n))) (v : W) :
    (sourceEdges B v ps).map (fun e => (f e.1, e.2)) = sourceEdges A (f v) ps := by
  simp only [sourceEdges, List.map_flatMap]
  congr 1
  funext p
  rw [walkEdges_natural A B f hf, hf]

theorem sourceVertices_natural {W : Type} (A : RightAction n V) (B : RightAction n W)
    (f : W → V) (hf : ∀ w v, f (B.act w v) = A.act w (f v))
    (ps : List (Word n × List (Letter n))) (v : W) :
    (sourceVertices B v ps).map f = sourceVertices A (f v) ps := by
  simp only [sourceVertices, List.map_cons, List.map_flatMap]
  rw [← sourceEdges_natural A B f hf ps v, List.flatMap_map]
  congr 2
  funext e
  simp [hf]

theorem vertexSet_natural {W : Type} [DecidableEq V]
    (A : RightAction n V) (B : RightAction n W)
    (f : W → V) (hf : ∀ w v, f (B.act w v) = A.act w (f v))
    (ps : List (Word n × List (Letter n))) (v : W) :
    (vertexSet B v ps).image f = vertexSet A (f v) ps := by
  classical
  ext x
  simp only [vertexSet, Finset.mem_image, List.mem_toFinset]
  rw [← sourceVertices_natural A B f hf ps v]
  exact List.mem_map.symm

theorem edge_source_mem (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) (e : V × Fin n)
    (he : e ∈ sourceEdges A v ps) : e.1 ∈ vertexSet A v ps := by
  classical
  simp only [vertexSet, List.mem_toFinset, sourceVertices, List.mem_cons]
  right
  exact List.mem_flatMap.mpr ⟨e, he, by simp⟩

theorem edge_target_mem (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) (e : V × Fin n)
    (he : e ∈ sourceEdges A v ps) :
    A.act (FreeGroup.of e.2) e.1 ∈ vertexSet A v ps := by
  classical
  simp only [vertexSet, List.mem_toFinset, sourceVertices, List.mem_cons]
  right
  exact List.mem_flatMap.mpr ⟨e, he, by simp⟩

def IsGradient (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) (a : V → Fin n → ℚ) : Prop :=
  ∃ b : V → ℚ, ∀ e ∈ sourceEdges A v ps,
    a e.1 e.2 = b (A.act (FreeGroup.of e.2) e.1) - b e.1

theorem equal_count_implies_gradient (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) (a : V → Fin n → ℚ)
    (hc : (vertexSet (A.lift a) (v, 0) ps).card = (vertexSet A v ps).card) :
    IsGradient A v ps a := by
  classical
  let S := vertexSet (A.lift a) (v, 0) ps
  have hp : S.image Prod.fst = vertexSet A v ps :=
    vertexSet_natural A (A.lift a) Prod.fst (by intros; rfl) ps (v, 0)
  have hinj : Set.InjOn Prod.fst (S : Set (V × ℚ)) := by
    apply Finset.card_image_iff.mp
    rw [hp]
    exact hc.symm
  let b : V → ℚ := fun x =>
    if h : ∃ t : ℚ, (x, t) ∈ S then Classical.choose h else 0
  have hb : ∀ x t, (x, t) ∈ S → b x = t := by
    intro x t ht
    have hex : ∃ s : ℚ, (x, s) ∈ S := ⟨t, ht⟩
    change (if h : ∃ s : ℚ, (x, s) ∈ S then Classical.choose h else 0) = t
    rw [dif_pos hex]
    exact congrArg Prod.snd
      (hinj (Classical.choose_spec hex) ht rfl)
  refine ⟨b, ?_⟩
  intro e he
  have he' : e ∈ (sourceEdges (A.lift a) (v, 0) ps).map
      (fun z => (z.1.1, z.2)) := by
    rw [sourceEdges_natural A (A.lift a) Prod.fst (by intros; rfl)]
    exact he
  obtain ⟨d, hd, hde⟩ := List.mem_map.mp he'
  subst e
  have hs := edge_source_mem (A.lift a) (v, 0) ps d hd
  have ht := edge_target_mem (A.lift a) (v, 0) ps d hd
  have hbs : b d.1.1 = d.1.2 := hb _ _ hs
  have hbt : b (A.act (FreeGroup.of d.2) d.1.1) = d.1.2 + a d.1.1 d.2 := by
    simpa only [RightAction.lift_fst, RightAction.lift_snd,
      RightAction.voltage_generator] using hb _ _ ht
  dsimp
  rw [hbt, hbs]
  ring

theorem voltage_strict_growth (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) (a : V → Fin n → ℚ)
    (ha : ¬ IsGradient A v ps a) :
    (vertexSet A v ps).card < (vertexSet (A.lift a) (v, 0) ps).card := by
  classical
  have hp := vertexSet_natural A (A.lift a) Prod.fst (by intros; rfl) ps (v, 0)
  have hle : (vertexSet A v ps).card ≤ (vertexSet (A.lift a) (v, 0) ps).card := by
    rw [← hp]
    exact Finset.card_image_le
  refine lt_of_le_of_ne hle ?_
  intro heq
  exact ha (equal_count_implies_gradient A v ps a heq.symm)

theorem square_mulVec_injective_of_det_ne_zero {R J : Type}
    [CommRing R] [IsDomain R] [Fintype J] [DecidableEq J]
    (B : Matrix J J R) (hB : B.det ≠ 0) : Function.Injective B.mulVec := by
  intro x y h
  have ha := congrArg B.adjugate.mulVec h
  rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, Matrix.adjugate_mul] at ha
  simp only [Matrix.smul_mulVec, Matrix.one_mulVec] at ha
  funext j
  exact mul_left_cancel₀ hB (congrFun ha j)

theorem specialization_injective {R I J : Type}
    [CommRing R] [IsDomain R] [Fintype I] [Fintype J]
    [DecidableEq I] [DecidableEq J]
    (ε : R →+* ℂ) (ι : ℂ →+* R) (hει : ∀ z, ε (ι z) = z)
    (B : Matrix I J R) (hB : Function.Injective (B.map ε).mulVec) :
    Function.Injective B.mulVec := by
  obtain ⟨g, hg⟩ := LinearMap.exists_leftInverse_of_injective
    (Matrix.toLin' (B.map ε)) (LinearMap.ker_eq_bot.mpr hB)
  let L : Matrix J I ℂ := LinearMap.toMatrix' g
  have hL : L * B.map ε = 1 := by
    have h := congrArg LinearMap.toMatrix' hg
    simpa [LinearMap.toMatrix'_comp, L] using h
  let C : Matrix J J R := L.map ι * B
  have hC : C.map ε = 1 := by
    ext i j
    have h := congrArg (fun M : Matrix J J ℂ => M i j) hL
    simpa [C, Matrix.mul_apply, hει] using h
  have hdet : C.det ≠ 0 := by
    have h : ε C.det = 1 := by
      rw [RingHom.map_det]
      change (C.map ε).det = 1
      rw [hC, Matrix.det_one]
    intro hz
    rw [hz, map_zero] at h
    exact zero_ne_one h
  intro x y h
  apply square_mulVec_injective_of_det_ne_zero C hdet
  change (L.map ι * B).mulVec x = (L.map ι * B).mulVec y
  rw [← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec, h]

namespace RightAction

variable (A : RightAction n V)

theorem voltage_add (a b : V → Fin n → ℚ) (w : Word n) (v : V) :
    A.voltage (a + b) w v = A.voltage a w v + A.voltage b w v := by
  have h : ∀ v, A.voltage (a + b) w v = A.voltage a w v + A.voltage b w v := by
    refine FreeGroup.induction_on w ?_ ?_ ?_ ?_
    · intro v; simp
    · intro i v; simp
    · intro i hi v
      simp only [A.voltage_inv, hi]
      ring
    · intro u z hu hz v
      simp only [A.voltage_mul, hu, hz]
      ring
  exact h v

theorem voltage_smul (c : ℚ) (a : V → Fin n → ℚ) (w : Word n) (v : V) :
    A.voltage (c • a) w v = c * A.voltage a w v := by
  have h : ∀ v, A.voltage (c • a) w v = c * A.voltage a w v := by
    refine FreeGroup.induction_on w ?_ ?_ ?_ ?_
    · intro v; simp
    · intro i v; simp
    · intro i hi v
      simp [A.voltage_inv, hi]
    · intro u z hu hz v
      simp only [A.voltage_mul, hu, hz]
      ring
  exact h v

def voltageLinear (w : Word n) (v : V) : (V → Fin n → ℚ) →ₗ[ℚ] ℚ where
  toFun a := A.voltage a w v
  map_add' a b := A.voltage_add a b w v
  map_smul' c a := A.voltage_smul c a w v

section Weighted

variable {K : Type} [CommRing K] (κ : Word n →* Kˣ)

abbrev EdgeChain := (V × Fin n) →₀ K
abbrev VertexChain := V →₀ K

def chainAction : Word n →* MulAut (Multiplicative (V → EdgeChain (n := n) (V := V) (K := K))) where
  toFun w :=
    { toFun := fun f => Multiplicative.ofAdd
        (fun v => (κ w : K) • f.toAdd (A.act w v))
      invFun := fun f => Multiplicative.ofAdd
        (fun v => (κ w⁻¹ : K) • f.toAdd (A.act w⁻¹ v))
      left_inv := by
        intro f
        change (fun v => (κ w⁻¹ : K) •
          ((κ w : K) • f.toAdd (A.act w (A.act w⁻¹ v)))) = f.toAdd
        simp [smul_smul, ← Units.val_mul]
      right_inv := by
        intro f
        change (fun v => (κ w : K) •
          ((κ w⁻¹ : K) • f.toAdd (A.act w⁻¹ (A.act w v)))) = f.toAdd
        simp [smul_smul, ← Units.val_mul]
      map_mul' := by
        intro f g
        change (fun v => (κ w : K) • (f.toAdd (A.act w v) + g.toAdd (A.act w v))) =
          (fun v => (κ w : K) • f.toAdd (A.act w v) + (κ w : K) • g.toAdd (A.act w v))
        simp [smul_add] }
  map_one' := by
    apply MulEquiv.ext
    intro f
    change (fun v => (κ 1 : K) • f.toAdd (A.act 1 v)) = f.toAdd
    simp
  map_mul' := by
    intro u w
    apply MulEquiv.ext
    intro f
    change (fun v => (κ (u * w) : K) • f.toAdd (A.act (u * w) v)) =
      (fun v => (κ u : K) • ((κ w : K) • f.toAdd (A.act w (A.act u v))))
    simp [A.act_mul, smul_smul]

abbrev ChainPathGroup :=
  Multiplicative (V → EdgeChain (n := n) (V := V) (K := K)) ⋊[A.chainAction κ] Word n

def chainPath : Word n →* A.ChainPathGroup κ :=
  FreeGroup.lift fun i =>
    ⟨Multiplicative.ofAdd (fun v => Finsupp.single (v, i) 1), FreeGroup.of i⟩

theorem chainPath_right (w : Word n) : (A.chainPath κ w).right = w := by
  have h : (SemidirectProduct.rightHom : A.ChainPathGroup κ →* Word n).comp
      (A.chainPath κ) = MonoidHom.id (Word n) :=
    FreeGroup.ext_hom _ _ (by intro i; simp [chainPath])
  exact congrArg (fun f : Word n →* Word n => f w) h

def chain (w : Word n) (v : V) : EdgeChain (n := n) (V := V) (K := K) :=
  (A.chainPath κ w).left.toAdd v

@[simp] theorem chain_one (v : V) : A.chain κ 1 v = 0 := by
  simp [chain]

@[simp] theorem chain_generator (v : V) (i : Fin n) :
    A.chain κ (FreeGroup.of i) v = Finsupp.single (v, i) 1 := by
  simp [chain, chainPath]

theorem chain_mul (u w : Word n) (v : V) :
    A.chain κ (u * w) v =
      A.chain κ u v + (κ u : K) • A.chain κ w (A.act u v) := by
  simp [chain, chainAction, chainPath_right]

theorem chain_inv (w : Word n) (v : V) :
    A.chain κ w⁻¹ v = -((κ w⁻¹ : K) • A.chain κ w (A.act w⁻¹ v)) := by
  simp [chain, chainAction, chainPath_right]

theorem chain_zero_off_walk (ls : List (Letter n)) (v : V) (e : V × Fin n)
    (he : e ∉ walkEdges A v ls) : A.chain κ (lettersWord ls) v e = 0 := by
  classical
  induction ls generalizing v with
  | nil => simp [lettersWord]
  | cons l ls ih =>
      have hfirst : e ≠ cond l.2 (v, l.1) (A.act (FreeGroup.of l.1)⁻¹ v, l.1) :=
        fun h => he (by simp [walkEdges, h])
      have hrest : e ∉ walkEdges A (A.act (letterWord l) v) ls :=
        fun h => he (by simp [walkEdges, h])
      have ht := ih (A.act (letterWord l) v) hrest
      simp only [lettersWord, List.map_cons, List.prod_cons, A.chain_mul,
        Finsupp.add_apply, Finsupp.smul_apply, smul_eq_mul] at *
      rw [ht, mul_zero, add_zero]
      cases hb : l.2 <;>
        simp only [hb, cond_false, cond_true] at hfirst <;>
        simp [letterWord, hb, A.chain_inv, hfirst]

def edgeBoundary : EdgeChain (n := n) (V := V) (K := K) →ₗ[K] VertexChain (V := V) (K := K) :=
  Finsupp.linearCombination K fun e =>
    (κ (FreeGroup.of e.2) : K) • Finsupp.single (A.act (FreeGroup.of e.2) e.1) 1 -
      Finsupp.single e.1 1

theorem edgeBoundary_generator (v : V) (i : Fin n) :
    A.edgeBoundary κ (Finsupp.single (v, i) 1) =
      (κ (FreeGroup.of i) : K) • Finsupp.single (A.act (FreeGroup.of i) v) 1 -
        Finsupp.single v 1 := by
  simp [edgeBoundary]

theorem chain_fundamental (w : Word n) (v : V) :
    A.edgeBoundary κ (A.chain κ w v) =
      (κ w : K) • Finsupp.single (A.act w v) 1 - Finsupp.single v 1 := by
  have h : ∀ v, A.edgeBoundary κ (A.chain κ w v) =
      (κ w : K) • Finsupp.single (A.act w v) 1 - Finsupp.single v 1 := by
    refine FreeGroup.induction_on w ?_ ?_ ?_ ?_
    · intro v; simp
    · intro i v; simp [A.edgeBoundary_generator]
    · intro i hi v
      rw [A.chain_inv, map_neg, map_smul, hi]
      simp only [A.act_act_inv, smul_sub, smul_smul]
      have hc : (κ (FreeGroup.of i)⁻¹ : K) * (κ (FreeGroup.of i) : K) = 1 := by
        rw [← Units.val_mul, ← map_mul, inv_mul_cancel, map_one, Units.val_one]
      rw [hc, one_smul]
      abel
    · intro u z hu hz v
      rw [A.chain_mul, map_add, map_smul, hu, hz]
      simp only [map_mul, Units.val_mul, A.act_mul, smul_sub, smul_smul]
      abel
  exact h v

end Weighted

end RightAction

structure Weights {K : Type} [CommRing K] (A : RightAction n V) where
  val : Word n → V → Kˣ
  one : ∀ v, val 1 v = 1
  mul : ∀ u w v, val (u * w) v = val u v * val w (A.act u v)

namespace Weights

variable {K : Type} [CommRing K] {A : RightAction n V} (L : Weights (K := K) A)

@[simp] theorem val_one (v : V) : L.val 1 v = 1 := L.one v

theorem val_mul (u w : Word n) (v : V) :
    L.val (u * w) v = L.val u v * L.val w (A.act u v) := L.mul u w v

@[simp] theorem val_inv_mul (w : Word n) (v : V) :
    L.val w⁻¹ v * L.val w (A.act w⁻¹ v) = 1 := by
  rw [← L.val_mul, inv_mul_cancel, L.val_one]

@[simp] theorem val_mul_inv (w : Word n) (v : V) :
    L.val w v * L.val w⁻¹ (A.act w v) = 1 := by
  rw [← L.val_mul, mul_inv_cancel, L.val_one]

def action : Word n →* MulAut (Multiplicative (V → K)) where
  toFun w :=
    { toFun := fun f => Multiplicative.ofAdd
        (fun v => (L.val w v : K) * f.toAdd (A.act w v))
      invFun := fun f => Multiplicative.ofAdd
        (fun v => (L.val w⁻¹ v : K) * f.toAdd (A.act w⁻¹ v))
      left_inv := by
        intro f
        change (fun v => (L.val w⁻¹ v : K) *
          ((L.val w (A.act w⁻¹ v) : K) * f.toAdd (A.act w (A.act w⁻¹ v)))) = f.toAdd
        simp [← mul_assoc, ← Units.val_mul]
      right_inv := by
        intro f
        change (fun v => (L.val w v : K) *
          ((L.val w⁻¹ (A.act w v) : K) * f.toAdd (A.act w⁻¹ (A.act w v)))) = f.toAdd
        simp [← mul_assoc, ← Units.val_mul]
      map_mul' := by
        intro f g
        change (fun v => (L.val w v : K) * (f.toAdd (A.act w v) + g.toAdd (A.act w v))) =
          (fun v => (L.val w v : K) * f.toAdd (A.act w v) +
            (L.val w v : K) * g.toAdd (A.act w v))
        simp [mul_add] }
  map_one' := by
    apply MulEquiv.ext
    intro f
    change (fun v => (L.val 1 v : K) * f.toAdd (A.act 1 v)) = f.toAdd
    simp
  map_mul' := by
    intro u w
    apply MulEquiv.ext
    intro f
    change (fun v => (L.val (u * w) v : K) * f.toAdd (A.act (u * w) v)) =
      (fun v => (L.val u v : K) * ((L.val w (A.act u v) : K) *
        f.toAdd (A.act w (A.act u v))))
    simp [A.act_mul, L.val_mul, mul_assoc]

abbrev IntegralGroup := Multiplicative (V → K) ⋊[L.action] Word n

def integralPath (a : V → Fin n → K) : Word n →* L.IntegralGroup :=
  FreeGroup.lift fun i =>
    ⟨Multiplicative.ofAdd (fun v => a v i), FreeGroup.of i⟩

theorem integralPath_right (a : V → Fin n → K) (w : Word n) :
    (L.integralPath a w).right = w := by
  have h : (SemidirectProduct.rightHom : L.IntegralGroup →* Word n).comp
      (L.integralPath a) = MonoidHom.id (Word n) :=
    FreeGroup.ext_hom _ _ (by intro i; simp [integralPath])
  exact congrArg (fun f : Word n →* Word n => f w) h

def integral (a : V → Fin n → K) (w : Word n) (v : V) : K :=
  (L.integralPath a w).left.toAdd v

@[simp] theorem integral_one (a : V → Fin n → K) (v : V) :
    L.integral a 1 v = 0 := by simp [integral]

@[simp] theorem integral_generator (a : V → Fin n → K) (v : V) (i : Fin n) :
    L.integral a (FreeGroup.of i) v = a v i := by
  simp [integral, integralPath]

theorem integral_mul (a : V → Fin n → K) (u w : Word n) (v : V) :
    L.integral a (u * w) v =
      L.integral a u v + (L.val u v : K) * L.integral a w (A.act u v) := by
  simp [integral, action, integralPath_right]

theorem integral_inv (a : V → Fin n → K) (w : Word n) (v : V) :
    L.integral a w⁻¹ v = -(L.val w⁻¹ v : K) * L.integral a w (A.act w⁻¹ v) := by
  simp [integral, action, integralPath_right]

theorem integral_add (a b : V → Fin n → K) (w : Word n) (v : V) :
    L.integral (a + b) w v = L.integral a w v + L.integral b w v := by
  have h : ∀ v, L.integral (a + b) w v = L.integral a w v + L.integral b w v := by
    refine FreeGroup.induction_on w ?_ ?_ ?_ ?_
    · intro v; simp
    · intro i v; simp
    · intro i hi v
      simp only [L.integral_inv, hi]
      ring
    · intro u z hu hz v
      simp only [L.integral_mul, hu, hz]
      ring
  exact h v

theorem integral_smul (c : K) (a : V → Fin n → K) (w : Word n) (v : V) :
    L.integral (c • a) w v = c * L.integral a w v := by
  have h : ∀ v, L.integral (c • a) w v = c * L.integral a w v := by
    refine FreeGroup.induction_on w ?_ ?_ ?_ ?_
    · intro v; simp
    · intro i v; simp
    · intro i hi v
      simp only [L.integral_inv, hi]
      ring
    · intro u z hu hz v
      simp only [L.integral_mul, hu, hz]
      ring
  exact h v

def integralLinear (w : Word n) (v : V) : (V → Fin n → K) →ₗ[K] K where
  toFun a := L.integral a w v
  map_add' a b := L.integral_add a b w v
  map_smul' c a := L.integral_smul c a w v

def gradient (b : V → K) : V → Fin n → K :=
  fun v i => (L.val (FreeGroup.of i) v : K) * b (A.act (FreeGroup.of i) v) - b v

theorem integral_gradient (b : V → K) (w : Word n) (v : V) :
    L.integral (L.gradient b) w v = (L.val w v : K) * b (A.act w v) - b v := by
  have h : ∀ v, L.integral (L.gradient b) w v =
      (L.val w v : K) * b (A.act w v) - b v := by
    refine FreeGroup.induction_on w ?_ ?_ ?_ ?_
    · intro v; simp
    · intro i v; simp [gradient]
    · intro i hi v
      rw [L.integral_inv, hi, A.act_act_inv]
      have hc : (L.val (FreeGroup.of i)⁻¹ v : K) *
          (L.val (FreeGroup.of i) (A.act (FreeGroup.of i)⁻¹ v) : K) = 1 := by
        rw [← Units.val_mul, L.val_inv_mul, Units.val_one]
      linear_combination -b v * hc
    · intro u z hu hz v
      rw [L.integral_mul, hu, hz, L.val_mul, A.act_mul, Units.val_mul]
      ring
  exact h v

theorem integral_local (a b : V → Fin n → K) (ls : List (Letter n)) (v : V)
    (hab : ∀ e ∈ walkEdges A v ls, a e.1 e.2 = b e.1 e.2) :
    L.integral a (lettersWord ls) v = L.integral b (lettersWord ls) v := by
  induction ls generalizing v with
  | nil => simp [lettersWord]
  | cons l ls ih =>
      have ht := ih (A.act (letterWord l) v)
        (by intro e he; exact hab e (by simp [walkEdges, he]))
      have hh := hab (cond l.2 (v, l.1) (A.act (FreeGroup.of l.1)⁻¹ v, l.1))
        (by simp [walkEdges])
      simp only [lettersWord, List.map_cons, List.prod_cons, L.integral_mul] at *
      rw [ht]
      congr 1
      cases hb : l.2 <;> simpa [letterWord, hb, L.integral_inv] using hh

def ofCharacter (A : RightAction n V) (κ : Word n →* Kˣ) : Weights (K := K) A where
  val w _ := κ w
  one _ := map_one κ
  mul u w _ := map_mul κ u w

@[simp] theorem ofCharacter_val (κ : Word n →* Kˣ) (w : Word n) (v : V) :
    (ofCharacter A κ).val w v = κ w := rfl

theorem rational_integral_eq_voltage (A : RightAction n V)
    (a : V → Fin n → ℚ) (w : Word n) (v : V) :
    (ofCharacter A (1 : Word n →* ℚˣ)).integral a w v = A.voltage a w v := by
  have h : ∀ v, (ofCharacter A (1 : Word n →* ℚˣ)).integral a w v = A.voltage a w v := by
    refine FreeGroup.induction_on w ?_ ?_ ?_ ?_
    · intro v; simp
    · intro i v; simp
    · intro i hi v
      simp [integral_inv, A.voltage_inv, hi]
    · intro u z hu hz v
      simp [integral_mul, A.voltage_mul, hu, hz]
  exact h v

end Weights

noncomputable def edgeSet (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) : Finset (V × Fin n) := by
  classical
  exact (sourceEdges A v ps).toFinset

@[simp] theorem mem_edgeSet (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) (e : V × Fin n) :
    e ∈ edgeSet A v ps ↔ e ∈ sourceEdges A v ps := by
  classical
  exact List.mem_toFinset

noncomputable def faceSet (A : RightAction n V) (v : V)
    (fs : List (Factor n m)) : Finset (V × Fin m) := by
  classical
  exact (fs.map (fun f => (A.act f.conjugator v, f.index))).toFinset

def extendFinite {X K : Type} [Semiring K] (S : Finset X) : (S → K) →ₗ[K] (X → K) := by
  classical
  exact
    { toFun := fun c x => if h : x ∈ S then c ⟨x, h⟩ else 0
      map_add' := by
        intro c d
        funext x
        by_cases h : x ∈ S <;> simp [h]
      map_smul' := by
        intro c d
        funext x
        by_cases h : x ∈ S <;> simp [h] }

@[simp] theorem extendFinite_apply {X K : Type} [Semiring K] (S : Finset X)
    (c : S → K) (x : S) : extendFinite S c x = c x := by
  simp [extendFinite, x.property]

def edgeExtend {K : Type} [Semiring K] (E : Finset (V × Fin n)) :
    (E → K) →ₗ[K] (V → Fin n → K) where
  toFun c v i := extendFinite E c (v, i)
  map_add' c d := by funext v i; exact congrFun (map_add (extendFinite E) c d) (v, i)
  map_smul' c d := by funext v i; exact congrFun (map_smul (extendFinite E) c d) (v, i)

@[simp] theorem edgeExtend_apply {K : Type} [Semiring K] (E : Finset (V × Fin n))
    (c : E → K) (e : E) : edgeExtend E c e.1.1 e.1.2 = c e :=
  extendFinite_apply E c e

def constraints {K : Type} [CommRing K] (A : RightAction n V)
    (L : Weights (K := K) A) (E : Finset (V × Fin n))
    (T : Finset (V × Fin m)) (r : Fin m → Word n) :
    (E → K) →ₗ[K] (T → K) where
  toFun c f := L.integral (edgeExtend E c) (r f.1.2) f.1.1
  map_add' c d := by
    funext f
    rw [map_add, L.integral_add]
    rfl
  map_smul' c d := by
    funext f
    rw [map_smul, L.integral_smul]
    rfl

def gradientMap {K : Type} [CommRing K] (A : RightAction n V)
    (L : Weights (K := K) A) (E : Finset (V × Fin n)) (S : Finset V) :
    (S → K) →ₗ[K] (E → K) where
  toFun b e := L.gradient (extendFinite S b) e.1.1 e.1.2
  map_add' b c := by
    funext e
    simp only [Weights.gradient, map_add, Pi.add_apply]
    ring
  map_smul' b c := by
    funext e
    simp only [Weights.gradient, map_smul, Pi.smul_apply, smul_eq_mul, RingHom.id_apply]
    ring

theorem walk_mem_source (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) (p : Word n × List (Letter n))
    (hp : p ∈ ps) (e : V × Fin n) (he : e ∈ walkEdges A (A.act p.1 v) p.2) :
    e ∈ sourceEdges A v ps :=
  List.mem_flatMap.mpr ⟨p, hp, he⟩

theorem initial_walk_mem (A : RightAction n V) (v : V)
    (r : Fin m → Word n) (w : Word n) (fs : List (Factor n m))
    (e : V × Fin n) (he : e ∈ walkEdges A v w.toWord) :
    e ∈ sourceEdges A v (sourcePaths r w fs) := by
  apply walk_mem_source A v _ (1, w.toWord) (by simp [sourcePaths]) e
  simpa using he

theorem stem_walk_mem (A : RightAction n V) (v : V)
    (r : Fin m → Word n) (w : Word n) (fs : List (Factor n m))
    (f : Factor n m) (hf : f ∈ fs) (e : V × Fin n)
    (he : e ∈ walkEdges A v f.conjugator.toWord) :
    e ∈ sourceEdges A v (sourcePaths r w fs) := by
  have hp : (1, f.conjugator.toWord) ∈ sourcePaths r w fs := by
    simp only [sourcePaths, List.mem_cons]
    right
    exact List.mem_flatMap.mpr ⟨f, hf, by simp⟩
  exact walk_mem_source A v _ (1, f.conjugator.toWord) hp e (by simpa using he)

theorem face_walk_mem (A : RightAction n V) (v : V)
    (r : Fin m → Word n) (w : Word n) (fs : List (Factor n m))
    (f : V × Fin m) (hf : f ∈ faceSet A v fs) (e : V × Fin n)
    (he : e ∈ walkEdges A f.1 (r f.2).toWord) :
    e ∈ sourceEdges A v (sourcePaths r w fs) := by
  classical
  obtain ⟨d, hd, rfl⟩ := List.mem_map.mp (List.mem_toFinset.mp hf)
  apply walk_mem_source A v _ (d.conjugator, (r d.index).toWord) ?_ e he
  simp only [sourcePaths, List.mem_cons]
  right
  exact List.mem_flatMap.mpr ⟨d, hd, by simp⟩

namespace Weights

variable {K : Type} [Field K] {A : RightAction n V} (L : Weights (K := K) A)

theorem integral_zero_on_walk (a : V → Fin n → K) (ls : List (Letter n)) (v : V)
    (ha : ∀ e ∈ walkEdges A v ls, a e.1 e.2 = 0) :
    L.integral a (lettersWord ls) v = 0 := by
  rw [L.integral_local a 0 ls v (by simpa using ha)]
  exact map_zero (L.integralLinear (lettersWord ls) v)

theorem zero_along_walk (b : V → K) (ls : List (Letter n)) (v : V)
    (hv : b v = 0)
    (ha : ∀ e ∈ walkEdges A v ls, L.gradient b e.1 e.2 = 0) :
    b (A.act (lettersWord ls) v) = 0 ∧
      ∀ e ∈ walkEdges A v ls, b e.1 = 0 ∧ b (A.act (FreeGroup.of e.2) e.1) = 0 := by
  induction ls generalizing v with
  | nil => simp [walkEdges, lettersWord, hv]
  | cons l ls ih =>
      let e : V × Fin n :=
        cond l.2 (v, l.1) (A.act (FreeGroup.of l.1)⁻¹ v, l.1)
      have he : e ∈ walkEdges A v (l :: ls) := by simp [walkEdges, e]
      have hg := ha e he
      have hedge : b e.1 = 0 ∧ b (A.act (FreeGroup.of e.2) e.1) = 0 := by
        cases hb : l.2
        · have hs : b (A.act (FreeGroup.of l.1)⁻¹ v) = 0 := by
            simpa [e, hb, gradient, hv] using hg
          simpa [e, hb, hv] using hs
        · have ht : b (A.act (FreeGroup.of l.1) v) = 0 := by
            have hm : (L.val (FreeGroup.of l.1) v : K) *
                b (A.act (FreeGroup.of l.1) v) = 0 := by
              simpa [e, hb, gradient, hv] using hg
            exact (mul_eq_zero.mp hm).resolve_left (Units.ne_zero _)
          simpa [e, hb, hv] using ht
      have hnext : b (A.act (letterWord l) v) = 0 := by
        cases hb : l.2
        · simpa [letterWord, e, hb] using hedge.1
        · simpa [letterWord, e, hb] using hedge.2
      have ht := ih (A.act (letterWord l) v) hnext
        (by intro d hd; exact ha d (by simp [walkEdges, hd]))
      constructor
      · simpa [lettersWord, A.act_mul] using ht.1
      · intro d hd
        simp only [walkEdges, List.mem_cons] at hd
        rcases hd with hd | hd
        · simpa [hd, e] using hedge
        · exact ht.2 d hd

end Weights

theorem source_gradient_injective {K : Type} [Field K]
    (A : RightAction n V) (L : Weights (K := K) A) (v : V)
    (r : Fin m → Word n) (w : Word n) (fs : List (Factor n m))
    (hw : A.act w v = v) (hL : (L.val w v : K) ≠ 1) :
    Function.Injective (gradientMap A L
      (edgeSet A v (sourcePaths r w fs)) (vertexSet A v (sourcePaths r w fs))) := by
  classical
  let ps := sourcePaths r w fs
  let S := vertexSet A v ps
  let E := edgeSet A v ps
  let G := gradientMap A L E S
  apply (injective_iff_map_eq_zero G).mpr
  intro b hb
  let B : V → K := extendFinite S b
  have hg : ∀ e ∈ sourceEdges A v ps, L.gradient B e.1 e.2 = 0 := by
    intro e he
    exact congrFun hb ⟨e, List.mem_toFinset.mpr he⟩
  have hroot : B v = 0 := by
    have h := L.integral_zero_on_walk (L.gradient B) w.toWord v
      (by intro e he; exact hg e (initial_walk_mem A v r w fs e he))
    rw [lettersWord_toWord, L.integral_gradient, hw] at h
    have hm : ((L.val w v : K) - 1) * B v = 0 := by linear_combination h
    exact (mul_eq_zero.mp hm).resolve_left (sub_ne_zero.mpr hL)
  have hstarts : ∀ p ∈ ps, B (A.act p.1 v) = 0 := by
    intro p hp
    simp only [ps, sourcePaths, List.mem_cons] at hp
    rcases hp with rfl | hp
    · simpa using hroot
    obtain ⟨f, hf, hp⟩ := List.mem_flatMap.mp hp
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hp
    rcases hp with rfl | rfl
    · simpa using hroot
    · have h := (L.zero_along_walk B f.conjugator.toWord v hroot
        (by intro e he; exact hg e (stem_walk_mem A v r w fs f hf e he))).1
      simpa only [lettersWord_toWord] using h
  have hedges : ∀ e ∈ sourceEdges A v ps,
      B e.1 = 0 ∧ B (A.act (FreeGroup.of e.2) e.1) = 0 := by
    intro e he
    obtain ⟨p, hp, he⟩ := List.mem_flatMap.mp he
    exact (L.zero_along_walk B p.2 (A.act p.1 v) (hstarts p hp)
      (by intro d hd; exact hg d (walk_mem_source A v ps p hp d hd))).2 e he
  funext x
  have hx : x.1 ∈ sourceVertices A v ps := List.mem_toFinset.mp x.property
  have hbx : B x.1 = 0 := by
    simp only [sourceVertices, List.mem_cons] at hx
    rcases hx with hx | hx
    · simpa [hx] using hroot
    obtain ⟨e, he, hx⟩ := List.mem_flatMap.mp hx
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hx
    rcases hx with hx | hx
    · rw [hx]; exact (hedges e he).1
    · rw [hx]; exact (hedges e he).2
  change extendFinite S b x = 0 at hbx
  simpa using hbx

theorem source_constraints_gradient_zero {K : Type} [CommRing K]
    (A : RightAction n V) (L : Weights (K := K) A) (v : V)
    (r : Fin m → Word n) (w : Word n) (fs : List (Factor n m))
    (hfaces : ∀ f ∈ faceSet A v fs,
      A.act (r f.2) f.1 = f.1 ∧ L.val (r f.2) f.1 = 1)
    (b : vertexSet A v (sourcePaths r w fs) → K) :
    constraints A L (edgeSet A v (sourcePaths r w fs)) (faceSet A v fs) r
      (gradientMap A L (edgeSet A v (sourcePaths r w fs))
        (vertexSet A v (sourcePaths r w fs)) b) = 0 := by
  classical
  let ps := sourcePaths r w fs
  let E := edgeSet A v ps
  let S := vertexSet A v ps
  let G := gradientMap A L E S
  funext f
  change L.integral (edgeExtend E (G b)) (r f.1.2) f.1.1 = 0
  have hl := L.integral_local (edgeExtend E (G b)) (L.gradient (extendFinite S b))
    (r f.1.2).toWord f.1.1 (by
      intro e he
      have heE : e ∈ E := List.mem_toFinset.mpr (face_walk_mem A v r w fs f f.property e he)
      exact edgeExtend_apply E (G b) ⟨e, heE⟩)
  rw [lettersWord_toWord] at hl
  rw [hl, L.integral_gradient, (hfaces f f.property).1, (hfaces f f.property).2]
  simp

theorem source_count_inequality {K : Type} [Field K]
    (A : RightAction n V) (L : Weights (K := K) A) (v : V)
    (r : Fin m → Word n) (w : Word n) (fs : List (Factor n m))
    (hw : A.act w v = v) (hL : (L.val w v : K) ≠ 1)
    (hfaces : ∀ f ∈ faceSet A v fs,
      A.act (r f.2) f.1 = f.1 ∧ L.val (r f.2) f.1 = 1)
    (hC : Function.Surjective (constraints A L (edgeSet A v (sourcePaths r w fs))
      (faceSet A v fs) r)) :
    (faceSet A v fs).card + (vertexSet A v (sourcePaths r w fs)).card ≤
      (edgeSet A v (sourcePaths r w fs)).card := by
  classical
  let E := edgeSet A v (sourcePaths r w fs)
  let S := vertexSet A v (sourcePaths r w fs)
  let T := faceSet A v fs
  let C := constraints A L E T r
  let G := gradientMap A L E S
  have hG : Function.Injective G := source_gradient_injective A L v r w fs hw hL
  have hsub : G.range ≤ C.ker := by
    rintro z ⟨b, rfl⟩
    exact source_constraints_gradient_zero A L v r w fs hfaces b
  have hrG := G.finrank_range_add_finrank_ker
  have hrC := C.finrank_range_add_finrank_ker
  have hm := Submodule.finrank_mono hsub
  rw [LinearMap.ker_eq_bot.mpr hG] at hrG
  rw [LinearMap.range_eq_top.mpr hC] at hrC
  simp at hrG hrC
  change T.card + S.card ≤ E.card
  omega

theorem exists_kernel_outside_range {I J H : Type} [Fintype I] [Fintype J] [Fintype H]
    (C : (I → ℚ) →ₗ[ℚ] (J → ℚ)) (G : (H → ℚ) →ₗ[ℚ] (I → ℚ))
    (hcount : Fintype.card J + Fintype.card H ≤ Fintype.card I)
    (b : H → ℚ) (hb : b ≠ 0) (hGb : G b = 0) :
    ∃ a : I → ℚ, C a = 0 ∧ a ∉ G.range := by
  have hker : G.ker ≠ ⊥ := by
    intro h
    apply hb
    exact LinearMap.ker_eq_bot'.mp h b hGb
  have hpos : 0 < Module.finrank ℚ G.ker := Nat.pos_of_ne_zero
    (fun h => hker (Submodule.finrank_eq_zero.mp h))
  have hG := G.finrank_range_add_finrank_ker
  have hC := C.finrank_range_add_finrank_ker
  have hCr := Submodule.finrank_le C.range
  simp only [Module.finrank_pi] at hG hC hCr
  by_contra hn
  push Not at hn
  have hsub : C.ker ≤ G.range := fun a ha => hn a ha
  have hm := Submodule.finrank_mono hsub
  omega

theorem source_constant_gradient_zero (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) :
    gradientMap A (Weights.ofCharacter A (1 : Word n →* ℚˣ))
      (edgeSet A v ps) (vertexSet A v ps) 1 = 0 := by
  classical
  funext e
  have hs := edge_source_mem A v ps e (List.mem_toFinset.mp e.property)
  have ht := edge_target_mem A v ps e (List.mem_toFinset.mp e.property)
  simp [gradientMap, Weights.gradient, extendFinite, hs, ht]

theorem source_voltage_exists (A : RightAction n V) (κ : Word n →* ℂˣ) (v : V)
    (r : Fin m → Word n) (w : Word n) (fs : List (Factor n m))
    (hκ : ∀ j, κ (r j) = 1)
    (hw : A.act w v = v) (hL : (κ w : ℂ) ≠ 1)
    (hr : ∀ f ∈ fs, A.act (r f.index) (A.act f.conjugator v) = A.act f.conjugator v)
    (hC : Function.Surjective (constraints A (Weights.ofCharacter A κ)
      (edgeSet A v (sourcePaths r w fs)) (faceSet A v fs) r)) :
    ∃ a : V → Fin n → ℚ,
      (∀ f ∈ fs, A.voltage a (r f.index) (A.act f.conjugator v) = 0) ∧
      ¬ IsGradient A v (sourcePaths r w fs) a := by
  classical
  let ps := sourcePaths r w fs
  let E := edgeSet A v ps
  let S := vertexSet A v ps
  let T := faceSet A v fs
  let LQ := Weights.ofCharacter A (1 : Word n →* ℚˣ)
  let CQ := constraints A LQ E T r
  let GQ := gradientMap A LQ E S
  have hfaces : ∀ f ∈ T,
      A.act (r f.2) f.1 = f.1 ∧ (Weights.ofCharacter A κ).val (r f.2) f.1 = 1 := by
    intro f hf
    obtain ⟨d, hd, rfl⟩ := List.mem_map.mp (List.mem_toFinset.mp hf)
    exact ⟨hr d hd, hκ d.index⟩
  have hcount := source_count_inequality A (Weights.ofCharacter A κ) v r w fs hw hL hfaces hC
  have hroot : v ∈ S := by simp [S, vertexSet, sourceVertices]
  have hone : (1 : S → ℚ) ≠ 0 := by
    intro h
    have h' := congrFun h ⟨v, hroot⟩
    norm_num at h'
  obtain ⟨a, ha, hag⟩ := exists_kernel_outside_range CQ GQ
    (by simpa only [Fintype.card_coe] using hcount) 1 hone
    (source_constant_gradient_zero A v ps)
  refine ⟨edgeExtend E a, ?_, ?_⟩
  · intro f hf
    have hmem : (A.act f.conjugator v, f.index) ∈ T := by
      apply List.mem_toFinset.mpr
      exact List.mem_map.mpr ⟨f, hf, rfl⟩
    have h := congrFun ha ⟨(A.act f.conjugator v, f.index), hmem⟩
    change (Weights.ofCharacter A (1 : Word n →* ℚˣ)).integral
      (edgeExtend E a) (r f.index) (A.act f.conjugator v) = 0 at h
    simpa only [Weights.rational_integral_eq_voltage] using h
  · rintro ⟨b, hb⟩
    apply hag
    refine ⟨fun x => b x.1, ?_⟩
    funext e
    have he := List.mem_toFinset.mp e.property
    have hs := edge_source_mem A v ps e he
    have ht := edge_target_mem A v ps e he
    change e.1.1 ∈ S at hs
    change A.act (FreeGroup.of e.1.2) e.1.1 ∈ S at ht
    have h := hb e he
    change (edgeExtend E a) e.1.1 e.1.2 =
      b (A.act (FreeGroup.of e.1.2) e.1.1) - b e.1.1 at h
    rw [edgeExtend_apply] at h
    simpa [GQ, gradientMap, LQ, Weights.gradient, extendFinite, hs, ht] using h.symm

def coordinate {X K : Type} [Zero K] [One K] (x : X) : X → K := by
  classical
  exact Pi.single x 1

def constraintMatrix {K : Type} [CommRing K] (A : RightAction n V)
    (L : Weights (K := K) A) (E : Finset (V × Fin n))
    (T : Finset (V × Fin m)) (r : Fin m → Word n) : Matrix T E K := by
  classical
  exact LinearMap.toMatrix' (constraints A L E T r)

theorem constraintMatrix_apply {K : Type} [CommRing K] (A : RightAction n V)
    (L : Weights (K := K) A) (E : Finset (V × Fin n))
    (T : Finset (V × Fin m)) (r : Fin m → Word n) (f : T) (e : E) :
    constraintMatrix A L E T r f e =
      L.integral (edgeExtend E (coordinate e)) (r f.1.2) f.1.1 := by
  classical
  unfold constraintMatrix
  rw [LinearMap.toMatrix'_apply]
  change L.integral (edgeExtend E (Pi.single e 1)) (r f.1.2) f.1.1 =
    L.integral (edgeExtend E (coordinate e)) (r f.1.2) f.1.1
  apply congrArg (fun c : E → K => L.integral (edgeExtend E c) (r f.1.2) f.1.1)
  funext d
  by_cases h : d = e <;> simp [coordinate, h]

theorem constraintMatrix_mulVec {K : Type} [CommRing K] (A : RightAction n V)
    (L : Weights (K := K) A) (E : Finset (V × Fin n))
    (T : Finset (V × Fin m)) (r : Fin m → Word n) (a : E → K) :
    (constraintMatrix A L E T r).mulVec a = constraints A L E T r a := by
  classical
  exact congrArg (fun f : (E → K) →ₗ[K] (T → K) => f a)
    (Matrix.toLin'_toMatrix' (constraints A L E T r))

theorem transpose_injective_of_surjective {K I J : Type}
    [Field K] [Fintype I] [Fintype J] [DecidableEq I] [DecidableEq J]
    (M : Matrix I J K) (hM : Function.Surjective M.mulVec) :
    Function.Injective M.transpose.mulVec := by
  obtain ⟨g, hg⟩ := LinearMap.exists_rightInverse_of_surjective
    (Matrix.toLin' M) (LinearMap.range_eq_top.mpr hM)
  let N := LinearMap.toMatrix' g
  have hMN : M * N = 1 := by
    have h := congrArg LinearMap.toMatrix' hg
    simpa [LinearMap.toMatrix'_comp, N] using h
  have ht : N.transpose * M.transpose = 1 := by
    rw [← Matrix.transpose_mul, hMN, Matrix.transpose_one]
  intro x y h
  have he := congrArg N.transpose.mulVec h
  simpa only [Matrix.mulVec_mulVec, ht, Matrix.one_mulVec] using he

theorem surjective_of_transpose_injective {K I J : Type}
    [Field K] [Fintype I] [Fintype J] [DecidableEq I] [DecidableEq J]
    (M : Matrix I J K) (hM : Function.Injective M.transpose.mulVec) :
    Function.Surjective M.mulVec := by
  obtain ⟨g, hg⟩ := LinearMap.exists_leftInverse_of_injective
    (Matrix.toLin' M.transpose) (LinearMap.ker_eq_bot.mpr hM)
  let N := LinearMap.toMatrix' g
  have hNM : N * M.transpose = 1 := by
    have h := congrArg LinearMap.toMatrix' hg
    simpa [LinearMap.toMatrix'_comp, N] using h
  have ht : M * N.transpose = 1 := by
    rw [← Matrix.transpose_transpose M, ← Matrix.transpose_mul, hNM, Matrix.transpose_one]
  intro x
  refine ⟨N.transpose.mulVec x, ?_⟩
  rw [Matrix.mulVec_mulVec, ht, Matrix.one_mulVec]

namespace Weights

variable {K K' : Type} [CommRing K] [CommRing K'] {A : RightAction n V}

theorem integral_map (L : Weights (K := K) A) (L' : Weights (K := K') A)
    (φ : K →+* K') (hL : ∀ w v, (L'.val w v : K') = φ (L.val w v : K))
    (a : V → Fin n → K) (w : Word n) (v : V) :
    L'.integral (fun x i => φ (a x i)) w v = φ (L.integral a w v) := by
  have h : ∀ v, L'.integral (fun x i => φ (a x i)) w v = φ (L.integral a w v) := by
    refine FreeGroup.induction_on w ?_ ?_ ?_ ?_
    · intro v; simp
    · intro i v; simp
    · intro i hi v
      simp [integral_inv, hi, hL]
    · intro u z hu hz v
      simp [integral_mul, hu, hz, hL]
  exact h v

end Weights

theorem constraintMatrix_map {K K' : Type} [CommRing K] [CommRing K']
    (A : RightAction n V) (L : Weights (K := K) A) (L' : Weights (K := K') A)
    (φ : K →+* K') (hL : ∀ w v, (L'.val w v : K') = φ (L.val w v : K))
    (E : Finset (V × Fin n)) (T : Finset (V × Fin m)) (r : Fin m → Word n) :
    constraintMatrix A L' E T r = (constraintMatrix A L E T r).map φ := by
  classical
  ext f e
  simp only [constraintMatrix_apply, Matrix.map_apply]
  have h := Weights.integral_map L L' φ hL
    (edgeExtend E (coordinate e)) (r f.1.2) f.1.1
  convert h using 1
  congr 2
  funext v i
  by_cases hv : (v, i) ∈ E <;>
    simp [edgeExtend, extendFinite, coordinate, Pi.single_apply, hv]

abbrev DeckRing := AddMonoidAlgebra ℂ ℚ

def coeff : ℂ →+* DeckRing where
  toFun z := AddMonoidAlgebra.single 0 z
  map_one' := rfl
  map_mul' z z' := by simp [AddMonoidAlgebra.single_mul_single]
  map_zero' := AddMonoidAlgebra.single_zero 0
  map_add' z z' := AddMonoidAlgebra.single_add 0 z z'

def monomial (t : ℚ) : DeckRing := AddMonoidAlgebra.single t 1

@[simp] theorem monomial_zero : monomial 0 = 1 := rfl

theorem monomial_add (s t : ℚ) : monomial (s + t) = monomial s * monomial t := by
  simp [monomial, AddMonoidAlgebra.single_mul_single]

theorem monomial_coeff (t : ℚ) (z : ℂ) :
    monomial t * coeff z = AddMonoidAlgebra.single t z := by
  simp [monomial, coeff, AddMonoidAlgebra.single_mul_single]

def monomialUnit (t : ℚ) : DeckRingˣ where
  val := monomial t
  inv := monomial (-t)
  val_inv := by rw [← monomial_add, add_neg_cancel, monomial_zero]
  inv_val := by rw [← monomial_add, neg_add_cancel, monomial_zero]

@[simp] theorem monomialUnit_val (t : ℚ) : (monomialUnit t : DeckRing) = monomial t := rfl

@[simp] theorem monomialUnit_zero : monomialUnit 0 = 1 := by
  apply Units.ext
  rfl

theorem monomialUnit_add (s t : ℚ) :
    monomialUnit (s + t) = monomialUnit s * monomialUnit t := by
  apply Units.ext
  exact monomial_add s t

def augmentation : DeckRing →+* ℂ :=
  ((AddMonoidAlgebra.lift ℂ ℂ ℚ) (1 : Multiplicative ℚ →* ℂ)).toRingHom

@[simp] theorem augmentation_single (t : ℚ) (z : ℂ) :
    augmentation (AddMonoidAlgebra.single t z) = z := by
  simp [augmentation, AddMonoidAlgebra.lift_single]

@[simp] theorem augmentation_coeff (z : ℂ) : augmentation (coeff z) = z :=
  augmentation_single 0 z

@[simp] theorem augmentation_monomial (t : ℚ) : augmentation (monomial t) = 1 :=
  augmentation_single t 1

def deckCharacter (κ : Word n →* ℂˣ) : Word n →* DeckRingˣ :=
  (Units.map coeff.toMonoidHom).comp κ

@[simp] theorem deckCharacter_val (κ : Word n →* ℂˣ) (w : Word n) :
    (deckCharacter κ w : DeckRing) = coeff (κ w : ℂ) := rfl

def deckWeights (A : RightAction n V) (κ : Word n →* ℂˣ)
    (a : V → Fin n → ℚ) : Weights (K := DeckRing) A where
  val w v := deckCharacter κ w * monomialUnit (A.voltage a w v)
  one v := by simp
  mul u w v := by
    simp [map_mul, A.voltage_mul, monomialUnit_add, mul_assoc, mul_comm, mul_left_comm]

@[simp] theorem deckWeights_val (A : RightAction n V) (κ : Word n →* ℂˣ)
    (a : V → Fin n → ℚ) (w : Word n) (v : V) :
    ((deckWeights A κ a).val w v : DeckRing) =
      coeff (κ w : ℂ) * monomial (A.voltage a w v) := rfl

theorem integral_lift_monomial (A : RightAction n V) (κ : Word n →* ℂˣ)
    (a : V → Fin n → ℚ) (b : V → Fin n → DeckRing) (w : Word n) (v : V) (t : ℚ) :
    (Weights.ofCharacter (A.lift a) (deckCharacter κ)).integral
        (fun p i => monomial p.2 * b p.1 i) w (v, t) =
      monomial t * (deckWeights A κ a).integral b w v := by
  have h : ∀ v t, (Weights.ofCharacter (A.lift a) (deckCharacter κ)).integral
      (fun p i => monomial p.2 * b p.1 i) w (v, t) =
      monomial t * (deckWeights A κ a).integral b w v := by
    refine FreeGroup.induction_on w ?_ ?_ ?_ ?_
    · intro v t; simp
    · intro i v t; simp
    · intro i hi v t
      simp only [Weights.integral_inv, Weights.ofCharacter_val, deckCharacter_val,
        RightAction.lift_act, hi, deckWeights_val, monomial_add]
      ring
    · intro u z hu hz v t
      simp only [Weights.integral_mul, Weights.ofCharacter_val, deckCharacter_val,
        RightAction.lift_act, hu, hz, deckWeights_val, monomial_add]
      ring
  exact h v t

theorem edgeSet_projection [DecidableEq V] (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) (a : V → Fin n → ℚ) :
    (edgeSet (A.lift a) (v, 0) ps).image (fun e => (e.1.1, e.2)) = edgeSet A v ps := by
  classical
  ext e
  simp only [edgeSet, Finset.mem_image, List.mem_toFinset]
  rw [← sourceEdges_natural A (A.lift a) Prod.fst (by intros; rfl) ps (v, 0)]
  exact List.mem_map.symm

theorem faceSet_projection [DecidableEq V] (A : RightAction n V) (v : V)
    (fs : List (Factor n m)) (a : V → Fin n → ℚ) :
    (faceSet (A.lift a) (v, 0) fs).image (fun f => (f.1.1, f.2)) = faceSet A v fs := by
  classical
  ext f
  simp only [faceSet, Finset.mem_image, List.mem_toFinset, List.mem_map]
  constructor
  · rintro ⟨z, ⟨d, hd, rfl⟩, rfl⟩
    exact ⟨d, hd, rfl⟩
  · rintro ⟨d, hd, rfl⟩
    exact ⟨((A.lift a).act d.conjugator (v, 0), d.index), ⟨d, hd, rfl⟩, rfl⟩

def projectEdge (A : RightAction n V) (v : V)
    (ps : List (Word n × List (Letter n))) (a : V → Fin n → ℚ)
    (e : edgeSet (A.lift a) (v, 0) ps) : edgeSet A v ps := by
  classical
  refine ⟨(e.1.1.1, e.1.2), ?_⟩
  rw [← edgeSet_projection A v ps a]
  exact Finset.mem_image.mpr ⟨e, e.property, rfl⟩

def projectFace (A : RightAction n V) (v : V) (fs : List (Factor n m))
    (a : V → Fin n → ℚ) (f : faceSet (A.lift a) (v, 0) fs) : faceSet A v fs := by
  classical
  refine ⟨(f.1.1.1, f.1.2), ?_⟩
  rw [← faceSet_projection A v fs a]
  exact Finset.mem_image.mpr ⟨f, f.property, rfl⟩

theorem projectFace_height_injective (A : RightAction n V) (v : V)
    (fs : List (Factor n m)) (a : V → Fin n → ℚ)
    (f g : faceSet (A.lift a) (v, 0) fs)
    (hp : projectFace A v fs a f = projectFace A v fs a g)
    (ht : f.1.1.2 = g.1.1.2) : f = g := by
  have h := congrArg Subtype.val hp
  change ((f.1.1.1, f.1.2) : V × Fin m) = (g.1.1.1, g.1.2) at h
  have hs : f.1.1.1 = g.1.1.1 := congrArg (fun z : V × Fin m => z.1) h
  have hi : f.1.2 = g.1.2 := congrArg (fun z : V × Fin m => z.2) h
  apply Subtype.ext
  exact Prod.ext (Prod.ext hs ht) hi

theorem lifted_constraint_column (A : RightAction n V) (κ : Word n →* ℂˣ) (v : V)
    (r : Fin m → Word n) (w : Word n) (fs : List (Factor n m))
    (a : V → Fin n → ℚ) (e : edgeSet A v (sourcePaths r w fs))
    (f : faceSet (A.lift a) (v, 0) fs) :
    constraints (A.lift a) (Weights.ofCharacter (A.lift a) (deckCharacter κ))
        (edgeSet (A.lift a) (v, 0) (sourcePaths r w fs))
        (faceSet (A.lift a) (v, 0) fs) r
        (fun d => monomial d.1.1.2 *
          edgeExtend (edgeSet A v (sourcePaths r w fs)) (coordinate e) d.1.1.1 d.1.2) f =
      monomial f.1.1.2 *
        constraintMatrix A (deckWeights A κ a) (edgeSet A v (sourcePaths r w fs))
          (faceSet A v fs) r (projectFace A v fs a f) e := by
  classical
  let E := edgeSet A v (sourcePaths r w fs)
  let E' := edgeSet (A.lift a) (v, 0) (sourcePaths r w fs)
  let b := edgeExtend E (coordinate (K := DeckRing) e)
  let c : E' → DeckRing := fun d => monomial d.1.1.2 * b d.1.1.1 d.1.2
  let U := Weights.ofCharacter (A.lift a) (deckCharacter κ)
  change U.integral (edgeExtend E' c) (r f.1.2) f.1.1 = _
  have hl := U.integral_local (edgeExtend E' c) (fun p i => monomial p.2 * b p.1 i)
    (r f.1.2).toWord f.1.1 (by
      intro d hd
      have hdE : d ∈ E' := (mem_edgeSet (A.lift a) (v, 0) (sourcePaths r w fs) d).mpr
        (face_walk_mem (A.lift a) (v, 0) r w fs f f.property d hd)
      exact edgeExtend_apply E' c ⟨d, hdE⟩)
  rw [lettersWord_toWord] at hl
  rw [hl, integral_lift_monomial, constraintMatrix_apply]
  rfl

def coefficientAt (t : ℚ) : DeckRing →+ ℂ :=
  (Finsupp.applyAddHom t).comp AddMonoidAlgebra.coeffAddEquiv.toAddMonoidHom

@[simp] theorem coefficientAt_single (t s : ℚ) (z : ℂ) :
    coefficientAt t (AddMonoidAlgebra.single s z) = if s = t then z else 0 := by
  exact AddMonoidAlgebra.single_apply

theorem source_constraints_lift_surjective (A : RightAction n V) (κ : Word n →* ℂˣ)
    (v : V) (r : Fin m → Word n) (w : Word n) (fs : List (Factor n m))
    (a : V → Fin n → ℚ)
    (hC : Function.Surjective (constraints A (Weights.ofCharacter A κ)
      (edgeSet A v (sourcePaths r w fs)) (faceSet A v fs) r)) :
    Function.Surjective (constraints (A.lift a) (Weights.ofCharacter (A.lift a) κ)
      (edgeSet (A.lift a) (v, 0) (sourcePaths r w fs)) (faceSet (A.lift a) (v, 0) fs) r) := by
  classical
  let ps := sourcePaths r w fs
  let E := edgeSet A v ps
  let T := faceSet A v fs
  let E' := edgeSet (A.lift a) (v, 0) ps
  let T' := faceSet (A.lift a) (v, 0) fs
  let pF : T' → T := projectFace A v fs a
  let C := constraintMatrix A (Weights.ofCharacter A κ) E T r
  let Ct := constraintMatrix A (deckWeights A κ a) E T r
  let U := constraintMatrix (A.lift a) (Weights.ofCharacter (A.lift a) κ) E' T' r
  let Ut := constraintMatrix (A.lift a) (Weights.ofCharacter (A.lift a) (deckCharacter κ)) E' T' r
  let J : Matrix T T' DeckRing := fun f g =>
    (Pi.single (pF g) (monomial g.1.1.2) : T → DeckRing) f
  let P : Matrix E' E DeckRing := fun d e =>
    monomial d.1.1.2 * edgeExtend E (coordinate e) d.1.1.1 d.1.2
  have hUt : Ut = U.map coeff := constraintMatrix_map (A.lift a)
    (Weights.ofCharacter (A.lift a) κ)
    (Weights.ofCharacter (A.lift a) (deckCharacter κ)) coeff (by intros; rfl) E' T' r
  have hCt : Ct.map augmentation = C := by
    symm
    apply constraintMatrix_map
    intro z x
    simp
  have hCtinj : Function.Injective Ct.transpose.mulVec := by
    apply specialization_injective augmentation coeff augmentation_coeff Ct.transpose
    change Function.Injective (Ct.map augmentation).transpose.mulVec
    rw [hCt]
    apply transpose_injective_of_surjective
    intro b
    obtain ⟨c, hc⟩ := hC b
    exact ⟨c, (constraintMatrix_mulVec A (Weights.ofCharacter A κ) E T r c).trans hc⟩
  have hintertwine : Ct.transpose * J = P.transpose * Ut.transpose := by
    ext e f
    have hc : (Ut.mulVec (P.col e)) f = monomial f.1.1.2 * Ct (pF f) e := by
      rw [constraintMatrix_mulVec]
      exact lifted_constraint_column A κ v r w fs a e f
    have hl : (Ct.transpose * J) e f = Ct (pF f) e * monomial f.1.1.2 := by
      simp [J, Matrix.mul_apply, Pi.single_apply, mul_ite]
    have hr : (P.transpose * Ut.transpose) e f = (Ut.mulVec (P.col e)) f := by
      simp [Matrix.mul_apply, Matrix.mulVec, dotProduct, mul_comm]
    rw [hl, hr, hc, mul_comm]
  have hUinj : Function.Injective U.transpose.mulVec := by
    apply (injective_iff_map_eq_zero (Matrix.mulVecLin U.transpose)).mpr
    intro x hx
    change U.transpose.mulVec x = 0 at hx
    let xR : T' → DeckRing := fun f => coeff (x f)
    have hxR : Ut.transpose.mulVec xR = 0 := by
      funext e
      have h := congrArg coeff (congrFun hx e)
      simpa [hUt, Matrix.mulVec, dotProduct, xR] using h
    have hj : J.mulVec xR = 0 := by
      apply hCtinj
      rw [Matrix.mulVec_mulVec, hintertwine, ← Matrix.mulVec_mulVec, hxR,
        Matrix.mulVec_zero, Matrix.mulVec_zero]
    funext f
    have hcoeff : coefficientAt f.1.1.2 ((J.mulVec xR) (pF f)) = x f := by
      simp only [Matrix.mulVec, dotProduct, J, xR, Pi.single_apply, ite_mul,
        zero_mul, monomial_coeff, map_sum, apply_ite, map_zero, coefficientAt_single]
      rw [Finset.sum_eq_single f]
      · simp
      · intro g _ hgf
        by_cases hp : pF f = pF g
        · have ht : g.1.1.2 ≠ f.1.1.2 := by
            intro ht
            exact hgf (projectFace_height_injective A v fs a g f hp.symm ht)
          simp [hp, ht]
        · simp [hp]
      · simp
    have hz := congrArg (fun z : T → DeckRing => coefficientAt f.1.1.2 (z (pF f))) hj
    rw [hcoeff] at hz
    simpa using hz
  intro b
  obtain ⟨c, hc⟩ := surjective_of_transpose_injective U hUinj b
  exact ⟨c, (constraintMatrix_mulVec (A.lift a) (Weights.ofCharacter (A.lift a) κ)
    E' T' r c).symm.trans hc⟩

def roseAction (n : ℕ) : RightAction n Unit where
  act _ _ := ()
  one v := by cases v; rfl
  mul _ _ _ := rfl

theorem rose_integral_functional (r : Fin m → Word n) (ρ : GroupOf r →* ℂˣ)
    (ℓ : Vec n →ₗ[ℂ] ℂ) (w : Word n) :
    (Weights.ofCharacter (roseAction n) (ρ.comp (quotient r))).integral
        (fun _ i => ℓ (basis i)) w () = ℓ (fox r ρ w) := by
  refine FreeGroup.induction_on w ?_ ?_ ?_ ?_
  · simp
  · intro i; simp
  · intro i hi
    rw [Weights.integral_inv, fox_inv, map_neg, map_smul]
    change -(evalWord r ρ (FreeGroup.of i)⁻¹) *
        (Weights.ofCharacter (roseAction n) (ρ.comp (quotient r))).integral
          (fun _ i => ℓ (basis i)) (FreeGroup.of i) () =
      -((evalWord r ρ (FreeGroup.of i)⁻¹) * ℓ (fox r ρ (FreeGroup.of i)))
    rw [hi]
    ring
  · intro u z hu hz
    rw [Weights.integral_mul, fox_mul, map_add, map_smul]
    change (Weights.ofCharacter (roseAction n) (ρ.comp (quotient r))).integral
        (fun _ i => ℓ (basis i)) u () +
        (evalWord r ρ u) *
          (Weights.ofCharacter (roseAction n) (ρ.comp (quotient r))).integral
            (fun _ i => ℓ (basis i)) z () =
      ℓ (fox r ρ u) + (evalWord r ρ u) * ℓ (fox r ρ z)
    rw [hu, hz]

def dotFunctional {k : ℕ} (a : Vec k) : Vec k →ₗ[ℂ] ℂ where
  toFun c := ∑ i, a i * c i
  map_add' c d := by simp [mul_add, Finset.sum_add_distrib]
  map_smul' c d := by simp [Finset.mul_sum, mul_left_comm]

@[simp] theorem dotFunctional_basis {k : ℕ} (a : Vec k) (i : Fin k) :
    dotFunctional a (basis i) = a i := by
  classical
  simp [dotFunctional, basis, Pi.single_apply, mul_ite]

theorem initial_constraints_surjective (r : Fin m → Word n) (ρ : GroupOf r →* ℂˣ)
    (w : Word n) (fs : List (Factor n m)) (hinj : Function.Injective (boundary r ρ)) :
    Function.Surjective (constraints (roseAction n)
      (Weights.ofCharacter (roseAction n) (ρ.comp (quotient r)))
      (edgeSet (roseAction n) () (sourcePaths r w fs)) (faceSet (roseAction n) () fs) r) := by
  classical
  let A := roseAction n
  let E := edgeSet A () (sourcePaths r w fs)
  let T := faceSet A () fs
  let L := Weights.ofCharacter A (ρ.comp (quotient r))
  obtain ⟨s, hs⟩ := LinearMap.exists_leftInverse_of_injective (boundary r ρ)
    (LinearMap.ker_eq_bot.mpr hinj)
  intro b
  let d : Vec m := fun j => extendFinite T b ((), j)
  let ℓ : Vec n →ₗ[ℂ] ℂ := (dotFunctional d).comp s
  have hℓ : ∀ j, ℓ (fox r ρ (r j)) = d j := by
    intro j
    rw [← boundary_basis r ρ j]
    change dotFunctional d (s (boundary r ρ (basis j))) = d j
    have h := congrArg (fun f : Vec m →ₗ[ℂ] Vec m => f (basis j)) hs
    change s (boundary r ρ (basis j)) = basis j at h
    rw [h, dotFunctional_basis]
  let c : E → ℂ := fun e => ℓ (basis e.1.2)
  refine ⟨c, ?_⟩
  funext f
  change L.integral (edgeExtend E c) (r f.1.2) f.1.1 = b f
  have hl := L.integral_local (edgeExtend E c) (fun _ i => ℓ (basis i))
    (r f.1.2).toWord f.1.1 (by
      intro e he
      have heE : e ∈ E := (mem_edgeSet A () (sourcePaths r w fs) e).mpr
        (face_walk_mem A () r w fs f f.property e he)
      exact edgeExtend_apply E c ⟨e, heE⟩)
  rw [lettersWord_toWord] at hl
  rw [hl]
  have hu : f.1.1 = () := Subsingleton.elim _ _
  rw [hu, rose_integral_functional, hℓ]
  change extendFinite T b ((), f.1.2) = b f
  have hf : (((), f.1.2) : Unit × Fin m) = f.1 := Prod.ext hu.symm rfl
  rw [hf]
  exact extendFinite_apply T b f

theorem finite_source_tower_contradiction (r : Fin m → Word n) (κ : Word n →* ℂˣ)
    (w : Word n) (q : ℕ) (hq : 0 < q) (fs : List (Factor n m))
    (hfs : witnessWord r fs = w ^ q) (hκ : ∀ j, κ (r j) = 1)
    (hkw : (κ w : ℂ) ≠ 1)
    (hstart : Function.Surjective (constraints (roseAction n)
      (Weights.ofCharacter (roseAction n) κ)
      (edgeSet (roseAction n) () (sourcePaths r w fs)) (faceSet (roseAction n) () fs) r)) :
    False := by
  let ps := sourcePaths r w fs
  have hbound : ∀ k : ℕ, ∀ (X : Type) (A : RightAction n X) (v : X),
      A.act w v = v →
      (∀ f ∈ fs, A.act (r f.index) (A.act f.conjugator v) = A.act f.conjugator v) →
      Function.Surjective (constraints A (Weights.ofCharacter A κ)
        (edgeSet A v ps) (faceSet A v fs) r) →
      k + (vertexSet A v ps).card ≤ sourceBudget ps := by
    intro k
    induction k with
    | zero =>
        intro X A v _ _ _
        simpa using vertexSet_bound A v ps
    | succ k ih =>
        intro X A v hw hr hC
        obtain ⟨a, ha, hag⟩ := source_voltage_exists A κ v r w fs hκ hw hkw hr hC
        have hw' := A.torsion_lifts a r v w q hq hw fs hfs hr ha
        have hr' : ∀ f ∈ fs,
            (A.lift a).act (r f.index) ((A.lift a).act f.conjugator (v, 0)) =
              (A.lift a).act f.conjugator (v, 0) := by
          intro f hf
          exact A.lift_relator_fixed a f.conjugator (r f.index) v (hr f hf) (ha f hf)
        have hC' := source_constraints_lift_surjective A κ v r w fs a hC
        have hnext := ih (X × ℚ) (A.lift a) (v, 0) hw' hr' hC'
        have hstrict := voltage_strict_growth A v ps a hag
        omega
  have h := hbound (sourceBudget ps + 1) Unit (roseAction n) () rfl
    (by intro f hf; rfl) hstart
  omega

theorem universal_torsion_statement : TorsionFox.UniversalTorsionStatement := by
  intro n m r ρ hinj g q hq hg
  by_contra hρ
  obtain ⟨w, hw⟩ := PresentedGroup.mk_surjective (Set.range r) g
  have hw' : quotient r w = g := hw
  obtain ⟨fs, hfs⟩ := torsion_has_certificate r (w := w) (q := q)
    (by rw [hw']; exact hg)
  let κ := ρ.comp (quotient r)
  have hκ : ∀ j, κ (r j) = 1 := by
    intro j
    simp [κ]
  have hkw : (κ w : ℂ) ≠ 1 := by
    intro h
    apply hρ
    apply Units.ext
    change (ρ g : ℂ) = 1
    simpa [κ, hw'] using h
  exact finite_source_tower_contradiction r κ w q hq fs hfs hκ hkw
    (initial_constraints_surjective r ρ w fs hinj)

end FoxTower
