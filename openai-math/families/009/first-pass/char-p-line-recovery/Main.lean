import Mathlib
import ReviewedIntersection

open scoped TensorProduct

noncomputable section

namespace CharPLineRecovery

variable (F : Type*) [Field F] (p : ℕ) [Fact p.Prime] [CharP F p]

local instance : Algebra (ZMod p) F := ZMod.algebra F p

def powers : AddSubgroup (Additive Fˣ) :=
  (nsmulAddMonoidHom p : Additive Fˣ →+ Additive Fˣ).range

abbrev V := Additive Fˣ ⧸ powers F p

noncomputable instance : Module (ZMod p) (V F p) :=
  QuotientAddGroup.zmodModule (fun x => ⟨x, rfl⟩)

def point (f : Fˣ) : V F p :=
  QuotientAddGroup.mk (Additive.ofMul f)

@[simp] theorem point_mul (f g : Fˣ) :
    point F p (f * g) = point F p f + point F p g := by
  exact map_add (QuotientAddGroup.mk' (powers F p)) _ _

@[simp] theorem point_one : point F p 1 = 0 := by
  exact map_zero (QuotientAddGroup.mk' (powers F p))

@[simp] theorem point_pow (f : Fˣ) (n : ℕ) :
    point F p (f ^ n) = n • point F p f := by
  exact map_nsmul (QuotientAddGroup.mk' (powers F p)) n (Additive.ofMul f)

theorem point_surjective : Function.Surjective (point F p) := by
  intro v
  obtain ⟨f, hf⟩ := QuotientAddGroup.mk'_surjective (powers F p) v
  exact ⟨f.toMul, hf⟩

theorem point_eq_iff (f g : Fˣ) :
    point F p f = point F p g ↔ ∃ h : Fˣ, f / g = h ^ p := by
  rw [point, point, QuotientAddGroup.eq_iff_sub_mem]
  change (∃ h : Additive Fˣ, p • h = Additive.ofMul (f / g)) ↔ _
  constructor
  · rintro ⟨h, hh⟩
    exact ⟨h.toMul, (congrArg Additive.toMul hh).symm⟩
  · rintro ⟨h, hh⟩
    exact ⟨Additive.ofMul h, congrArg Additive.ofMul hh.symm⟩

variable {F p}

def logHom (D : Derivation (ZMod p) F F) : Additive Fˣ →+ F where
  toFun f := D (f.toMul : F) / (f.toMul : F)
  map_zero' := by simp
  map_add' f g := by
    change D ((f.toMul : F) * (g.toMul : F)) /
      ((f.toMul : F) * (g.toMul : F)) =
      D (f.toMul : F) / (f.toMul : F) + D (g.toMul : F) / (g.toMul : F)
    rw [D.leibniz]
    simp only [smul_eq_mul]
    field_simp
    ring

noncomputable def logLinear (D : Derivation (ZMod p) F F) :
    V F p →ₗ[ZMod p] F :=
  (QuotientAddGroup.lift (powers F p) (logHom D) (by
    rintro x ⟨y, rfl⟩
    change logHom D (p • y) = 0
    rw [map_nsmul, nsmul_eq_mul, CharP.cast_eq_zero F p, zero_mul]
  )).toZModLinearMap p

@[simp] theorem logLinear_point (D : Derivation (ZMod p) F F) (f : Fˣ) :
    logLinear D (point F p f) = D (f : F) / (f : F) := rfl

noncomputable def beta (D E : Derivation (ZMod p) F F) :
    V F p →ₗ[ZMod p] V F p →ₗ[ZMod p] F :=
  LinearMap.mk₂ (ZMod p)
    (fun x y => logLinear D x * logLinear E y - logLinear E x * logLinear D y)
    (by intros; simp only [map_add]; ring)
    (by intros; simp only [map_smul, Algebra.smul_def]; ring)
    (by intros; simp only [map_add]; ring)
    (by intros; simp only [map_smul, Algebra.smul_def]; ring)

def steinbergSet (F : Type*) [Field F] (p : ℕ) [Fact p.Prime] [CharP F p] :
    Set (V F p ⊗[ZMod p] V F p) :=
  {z | ∃ (f : F) (h0 : f ≠ 0) (h1 : f ≠ 1),
    z = point F p (Units.mk0 f h0) ⊗ₜ[ZMod p]
      point F p (Units.mk0 (1 - f) (sub_ne_zero.mpr (Ne.symm h1)))}

def relations (F : Type*) [Field F] (p : ℕ) [Fact p.Prime] [CharP F p] :
    Submodule (ZMod p) (V F p ⊗[ZMod p] V F p) :=
  Submodule.span (ZMod p) (steinbergSet F p)

abbrev W (F : Type*) [Field F] (p : ℕ) [Fact p.Prime] [CharP F p] :=
  (V F p ⊗[ZMod p] V F p) ⧸ relations F p

def symbol (f g : Fˣ) : W F p :=
  Submodule.Quotient.mk (point F p f ⊗ₜ[ZMod p] point F p g)

theorem beta_kills_relations (D E : Derivation (ZMod p) F F) :
    relations F p ≤ LinearMap.ker (TensorProduct.lift (beta D E)) := by
  apply Submodule.span_le.mpr
  rintro z ⟨f, h0, h1, rfl⟩
  change beta D E (point F p (Units.mk0 f h0))
    (point F p (Units.mk0 (1-f) (sub_ne_zero.mpr (Ne.symm h1)))) = 0
  simp only [beta, LinearMap.mk₂_apply, logLinear_point, Units.val_mk0,
    map_sub, Derivation.map_one_eq_zero, zero_sub]
  ring

noncomputable def differentialSymbol (D E : Derivation (ZMod p) F F) :
    W F p →ₗ[ZMod p] F :=
  (relations F p).liftQ (TensorProduct.lift (beta D E)) (beta_kills_relations D E)

@[simp] theorem differentialSymbol_symbol (D E : Derivation (ZMod p) F F)
    (f g : Fˣ) :
    differentialSymbol D E (symbol f g) =
      D (f : F) / (f : F) * (E (g : F) / (g : F)) -
      E (f : F) / (f : F) * (D (g : F) / (g : F)) := rfl

theorem symbol_nonzero_of_euler (D E : Derivation (ZMod p) F F)
    (s t : Fˣ)
    (hDs : D (s : F) = s) (hDt : D (t : F) = 0)
    (hEs : E (s : F) = 0) (hEt : E (t : F) = t) :
    symbol (p := p) s t ≠ 0 := by
  intro h
  have hh := congrArg (differentialSymbol D E) h
  simp [hDs, hDt, hEs, hEt] at hh

def Compatible {K L : Type*} [Field K] [Field L]
    [CharP K p] [CharP L p] (e : V K p ≃ₗ[ZMod p] V L p) : Prop :=
  Submodule.map (TensorProduct.map e.toLinearMap e.toLinearMap) (relations K p) =
    relations L p

theorem compatible_symbol_zero_iff {K L : Type*} [Field K] [Field L]
    [CharP K p] [CharP L p] (e : V K p ≃ₗ[ZMod p] V L p)
    (he : Compatible e) (x y : V K p) :
    x ⊗ₜ[ZMod p] y ∈ relations K p ↔
      e x ⊗ₜ[ZMod p] e y ∈ relations L p := by
  let t := TensorProduct.congr e e
  have ht : t.toLinearMap = TensorProduct.map e.toLinearMap e.toLinearMap := rfl
  constructor
  · intro h
    rw [← he]
    exact ⟨_, h, TensorProduct.map_tmul _ _ _ _⟩
  · intro h
    rw [← he] at h
    obtain ⟨z, hz, heq⟩ := h
    have heq' : t z = t (x ⊗ₜ[ZMod p] y) := by
      change TensorProduct.map e.toLinearMap e.toLinearMap z =
        TensorProduct.map e.toLinearMap e.toLinearMap (x ⊗ₜ[ZMod p] y)
      simpa only [TensorProduct.map_tmul, LinearEquiv.coe_coe,
        LinearEquiv.coe_toLinearMap] using heq
    exact t.injective heq' ▸ hz

end CharPLineRecovery

namespace InseparableDerivations

open Polynomial

variable {C E F : Type*} [Field C] [Field E] [Field F]
variable [Algebra C E] [Algebra E F] [Algebra C F] [IsScalarTower C E F]
variable {p : ℕ} [Fact p.Prime] [CharP E p] [CharP F p]

theorem minpoly_pth {x : F} {a : E}
    (hx : x ^ p = algebraMap E F a)
    (houtside : ∀ b : E, algebraMap E F b ≠ x) :
    minpoly E x = X ^ p - Polynomial.C a := by
  have hirr : Irreducible (X ^ p - Polynomial.C a) := by
    apply X_pow_sub_C_irreducible_of_prime (Fact.out : p.Prime)
    intro b hb
    apply houtside b
    apply (frobenius F p).injective
    change (algebraMap E F b) ^ p = x ^ p
    rw [← map_pow, hb, hx]
  symm
  apply minpoly.eq_of_irreducible_of_monic hirr
  · simp [hx]
  · exact monic_X_pow_sub_C a (Fact.out : p.Prime).ne_zero

def coefficientDerivation (D : Derivation C E E) : Derivation C E[X] E[X] :=
  PolynomialModule.equivPolynomialSelf.compDer D.mapCoeffs

@[simp] theorem coefficientDerivation_C (D : Derivation C E E) (a : E) :
    coefficientDerivation D (Polynomial.C a) = Polynomial.C (D a) := by
  simp [coefficientDerivation]

@[simp] theorem coefficientDerivation_X (D : Derivation C E E) :
    coefficientDerivation D X = 0 := by
  simp [coefficientDerivation]

def polynomialDerivation (D : Derivation C E E) (v : E[X]) :
    Derivation C E[X] E[X] :=
  coefficientDerivation D + v • Polynomial.derivative'.restrictScalars C

@[simp] theorem polynomialDerivation_C (D : Derivation C E E) (v : E[X]) (a : E) :
    polynomialDerivation D v (Polynomial.C a) = Polynomial.C (D a) := by
  simp [polynomialDerivation]

@[simp] theorem polynomialDerivation_X (D : Derivation C E E) (v : E[X]) :
    polynomialDerivation D v X = v := by
  simp [polynomialDerivation]

theorem extend_powerBasis (pb : PowerBasis E F) (D : Derivation C E E)
    (v : E[X]) (a : E)
    (hmin : minpoly E pb.gen = X ^ p - Polynomial.C a) (ha : D a = 0) :
    ∃ D' : Derivation C F F,
      (∀ b : E, D' (algebraMap E F b) = algebraMap E F (D b)) ∧
      D' pb.gen = aeval pb.gen v := by
  let f : E[X] →ₐ[C] F := (aeval pb.gen).restrictScalars C
  have hf : Function.Surjective f := by
    intro y
    obtain ⟨q, _, hq⟩ := pb.exists_eq_aeval y
    exact ⟨q, hq.symm⟩
  let d := polynomialDerivation D v
  have hdmin : d (minpoly E pb.gen) = 0 := by
    rw [hmin, map_sub, d.leibniz_pow]
    simp [d, ha, CharP.cast_eq_zero E p]
  have hd : ∀ q, f q = 0 → f (d q) = 0 := by
    intro q hq
    obtain ⟨r, hr⟩ := minpoly.dvd E pb.gen hq
    rw [hr, d.leibniz]
    simp [hdmin, Algebra.smul_def, f, minpoly.aeval]
  let D' : Derivation C F F := Derivation.liftOfSurjective hf hd
  refine ⟨D', ?_, ?_⟩
  · intro b
    have h := Derivation.liftOfSurjective_apply hf hd (Polynomial.C b)
    simpa [D', f, d] using h
  · have h := Derivation.liftOfSurjective_apply hf hd X
    simpa [D', f, d] using h

def transport (e : E ≃ₐ[C] F) (D : Derivation C E E) : Derivation C F F where
  toFun x := e (D (e.symm x))
  map_add' x y := by simp
  map_smul' c x := by simp
  map_one_eq_zero' := by simp
  leibniz' x y := by simp [D.leibniz, smul_eq_mul]

theorem extend_finite {C : Type*} [Field C] {E F : Type u}
    [Field E] [Field F] [Algebra C E] [Algebra E F] [Algebra C F]
    [IsScalarTower C E F] {p : ℕ} [Fact p.Prime] [CharP E p] [CharP F p]
    [FiniteDimensional E F]
    (hpowers : ∀ x : F, ∃ c : C, x ^ p = algebraMap C F c)
    (D : Derivation C E E) :
    ∃ D' : Derivation C F F,
      ∀ b : E, D' (algebraMap E F b) = algebraMap E F (D b) := by
  generalize hd : Module.finrank E F = d
  induction d using Nat.strongRecOn generalizing E with
  | ind d IH =>
    by_cases hsurj : Function.Surjective (algebraMap E F)
    · let e : E ≃ₐ[C] F :=
        AlgEquiv.ofBijective (IsScalarTower.toAlgHom C E F)
          ⟨(algebraMap E F).injective, hsurj⟩
      refine ⟨transport e D, ?_⟩
      intro b
      change e (D (e.symm (e b))) = e (D b)
      rw [e.symm_apply_apply]
    · obtain ⟨t, ht⟩ : ∃ t : F, ∀ b : E, algebraMap E F b ≠ t := by
        simpa only [Function.Surjective, not_forall, not_exists] using hsurj
      let A := IntermediateField.adjoin E ({t} : Set F)
      letI : Algebra C A :=
        ((algebraMap E A).comp (algebraMap C E)).toAlgebra
      letI : IsScalarTower C E A := IsScalarTower.of_algebraMap_eq (fun _ => rfl)
      letI : IsScalarTower C A F := IsScalarTower.of_algebraMap_eq (fun c => by
        change algebraMap C F c =
          algebraMap A F (algebraMap E A (algebraMap C E c))
        rw [← IsScalarTower.algebraMap_apply E A F]
        exact IsScalarTower.algebraMap_apply C E F c)
      let pb : PowerBasis E A :=
        IntermediateField.adjoin.powerBasis (Algebra.IsIntegral.isIntegral t)
      obtain ⟨c, hc⟩ := hpowers t
      let a : E := algebraMap C E c
      have hmin : minpoly E pb.gen = X ^ p - Polynomial.C a := by
        apply minpoly_pth
        · apply Subtype.ext
          simpa [pb, a, IsScalarTower.algebraMap_apply C E F] using hc
        · intro b hb
          apply ht b
          exact congrArg (fun z : A => (z : F)) hb
      obtain ⟨D1, hD1, _⟩ := extend_powerBasis pb D (0 : E[X]) a hmin
        (by simp [a])
      have hdim : Module.finrank E A = p := by
        rw [pb.finrank, ← pb.natDegree_minpoly, hmin, natDegree_X_pow_sub_C]
      have htotal : Module.finrank E F = p * Module.finrank A F := by
        rw [← Module.finrank_mul_finrank E A F, hdim]
      have hlt : Module.finrank A F < d := by
        rw [← hd, htotal]
        have hpos : 0 < Module.finrank A F := Module.finrank_pos
        have hp : 1 < p := (Fact.out : p.Prime).one_lt
        nlinarith
      obtain ⟨D2, hD2⟩ := IH (Module.finrank A F) hlt (E := A) D1 rfl
      refine ⟨D2, ?_⟩
      intro b
      have h := hD2 (algebraMap E A b)
      rw [hD1 b] at h
      simpa only [← IsScalarTower.algebraMap_apply E A F] using h

theorem euler_pair {C F : Type u} [Field C] [Field F] [Algebra C F]
    {p : ℕ} [Fact p.Prime] [CharP C p] [CharP F p]
    [FiniteDimensional C F]
    (hpowers : ∀ x : F, ∃ c : C, x ^ p = algebraMap C F c)
    {s t : F}
    (hs : ∀ c : C, algebraMap C F c ≠ s)
    (ht : t ∉ IntermediateField.adjoin C ({s} : Set F)) :
    ∃ D E : Derivation C F F, D s = s ∧ D t = 0 ∧ E s = 0 ∧ E t = t := by
  let S := IntermediateField.adjoin C ({s} : Set F)
  let pbS : PowerBasis C S :=
    IntermediateField.adjoin.powerBasis (Algebra.IsIntegral.isIntegral s)
  obtain ⟨cs, hcs⟩ := hpowers s
  have hminS : minpoly C pbS.gen = X ^ p - Polynomial.C cs := by
    apply minpoly_pth
    · apply Subtype.ext
      simpa [pbS] using hcs
    · intro c hc
      apply hs c
      exact congrArg (fun z : S => (z : F)) hc
  obtain ⟨Ds, _, hDs⟩ :=
    extend_powerBasis pbS (0 : Derivation C C C) X cs hminS (by simp)
  have hDs' : Ds pbS.gen = pbS.gen := by simpa using hDs
  let A := IntermediateField.adjoin S ({t} : Set F)
  letI : Algebra C A := ((algebraMap S A).comp (algebraMap C S)).toAlgebra
  letI : IsScalarTower C S A := IsScalarTower.of_algebraMap_eq (fun _ => rfl)
  letI : IsScalarTower C A F := IsScalarTower.of_algebraMap_eq (fun c => by
    change algebraMap C F c =
      algebraMap A F (algebraMap S A (algebraMap C S c))
    rw [← IsScalarTower.algebraMap_apply S A F]
    exact IsScalarTower.algebraMap_apply C S F c)
  let pbA : PowerBasis S A :=
    IntermediateField.adjoin.powerBasis (Algebra.IsIntegral.isIntegral t)
  obtain ⟨ct, hct⟩ := hpowers t
  let ctS : S := algebraMap C S ct
  have hminA : minpoly S pbA.gen = X ^ p - Polynomial.C ctS := by
    apply minpoly_pth
    · apply Subtype.ext
      change t ^ p = algebraMap S F (algebraMap C S ct)
      exact hct.trans (IsScalarTower.algebraMap_apply C S F ct)
    · intro b hb
      apply ht
      have hbt : (b : F) = t := congrArg (fun z : A => (z : F)) hb
      exact hbt ▸ b.property
  obtain ⟨D1, hD1, hD1t⟩ :=
    extend_powerBasis pbA Ds 0 ctS hminA (by simp [ctS])
  obtain ⟨E1, hE1, hE1t⟩ :=
    extend_powerBasis pbA (0 : Derivation C S S) X ctS hminA (by simp)
  obtain ⟨D, hD⟩ := extend_finite hpowers D1
  obtain ⟨E, hE⟩ := extend_finite hpowers E1
  refine ⟨D, E, ?_, ?_, ?_, ?_⟩
  · have h := hD (algebraMap S A pbS.gen)
    rw [hD1, hDs'] at h
    simpa [pbS] using h
  · have h := hD pbA.gen
    rw [hD1t] at h
    simpa [pbA] using h
  · have h := hE (algebraMap S A pbS.gen)
    rw [hE1] at h
    simpa [pbS] using h
  · have h := hE pbA.gen
    rw [hE1t] at h
    simpa [pbA] using h

theorem low_degree_vanishes
    (hpowers : ∀ x : F, ∃ c : E, x ^ p = algebraMap E F c)
    {x : F} (hx : ∀ c : E, algebraMap E F c ≠ x)
    (q : E[X]) (hdegree : q.natDegree < p) (hroot : aeval x q = 0) :
    q = 0 := by
  obtain ⟨a, ha⟩ := hpowers x
  have hmin := minpoly_pth ha hx
  by_contra hq
  have h := natDegree_le_of_dvd (minpoly.dvd E x hroot) hq
  rw [hmin, natDegree_X_pow_sub_C] at h
  exact (not_le_of_gt hdegree) h

theorem affine_nonmonomial
    (hpowers : ∀ x : F, ∃ c : E, x ^ p = algebraMap E F c)
    {x : F} (hx : ∀ c : E, algebraMap E F c ≠ x)
    (a : E) (ha : a ≠ 0) :
    ∀ (i : Fin p) (c : E),
      x + algebraMap E F a ≠ algebraMap E F c * x ^ i.val := by
  intro i c he
  let q : E[X] := X + Polynomial.C a - Polynomial.C c * X ^ i.val
  have hdeg : q.natDegree ≤ max 1 i.val := by
    apply (natDegree_sub_le _ _).trans
    apply max_le
    · exact (natDegree_add_le _ _).trans (by simpa using (le_max_left 1 i.val))
    · exact natDegree_mul_le.trans (by simpa using (le_max_right 1 i.val))
  have hq : q = 0 := low_degree_vanishes hpowers hx q
    (hdeg.trans_lt (max_lt (Fact.out : p.Prime).one_lt i.isLt)) (by
      simp only [q, map_sub, map_add, map_mul, map_pow, aeval_X, aeval_C]
      rw [he]
      ring)
  by_cases hi : i.val = 0
  · have h := congrArg (fun f : E[X] => f.coeff 1) hq
    simpa [q, hi] using h
  · have h := congrArg (fun f : E[X] => f.coeff 0) hq
    have haz : a = 0 := by simpa [q, hi, Ne.symm hi] using h
    exact ha haz

theorem scalar_affine_rigidity
    (hpowers : ∀ x : F, ∃ c : E, x ^ p = algebraMap E F c)
    {x : F} (hx : ∀ c : E, algebraMap E F c ≠ x)
    {r : ℕ} (hr : 0 < r) (hrp : r < p)
    (a b : E)
    (he : (x + 1) ^ r = algebraMap E F a + algebraMap E F b * x ^ r) :
    r = 1 := by
  by_contra hne
  have hr1 : 1 < r := by omega
  let q : E[X] := (X + 1) ^ r - Polynomial.C a - Polynomial.C b * X ^ r
  have hX : (X + 1 : E[X]).natDegree = 1 := by
    change (X + Polynomial.C (1 : E)).natDegree = 1
    exact natDegree_X_add_C _
  have hdeg : q.natDegree ≤ r := by
    apply (natDegree_sub_le _ _).trans
    apply max_le
    · exact (natDegree_sub_le _ _).trans (by simp [hX])
    · exact natDegree_mul_le.trans (by simp)
  have hq : q = 0 := low_degree_vanishes hpowers hx q (hdeg.trans_lt hrp) (by
    simp only [q, map_sub, map_pow, map_add, aeval_X, map_one, aeval_C, map_mul]
    rw [he]
    ring)
  have h := congrArg (fun f : E[X] => f.coeff 1) hq
  have hz : (r : E) = 0 := by
    simpa [q, coeff_X_add_one_pow, Ne.symm hne] using h
  have heq : r = 0 := (CharP.natCast_injOn_Iio E p) hrp
    (Fact.out : p.Prime).pos (by simpa using hz)
  omega

end InseparableDerivations

namespace CharPLineRecovery

variable (F : Type*) [Field F] (p : ℕ) [Fact p.Prime] [CharP F p]

local instance : Algebra (ZMod p) F := ZMod.algebra F p

abbrev PthPowers : Subfield F := (frobenius F p).fieldRange

theorem point_eq_zero_iff (f : Fˣ) :
    point F p f = 0 ↔ (f : F) ∈ PthPowers F p := by
  constructor
  · intro h
    obtain ⟨g, hg⟩ := (point_eq_iff F p f 1).mp (h.trans (point_one F p).symm)
    change ∃ x : F, x ^ p = (f : F)
    refine ⟨g, ?_⟩
    have hv := congrArg (fun u : Fˣ => (u : F)) hg
    simpa using hv.symm
  · intro h
    obtain ⟨x, hx⟩ : ∃ x : F, x ^ p = (f : F) := h
    have hx0 : x ≠ 0 := by
      intro hz
      simp [hz, (Fact.out : p.Prime).ne_zero] at hx
      exact f.ne_zero hx.symm
    have hq : point F p f = point F p 1 := by
      apply (point_eq_iff F p f 1).mpr
      refine ⟨Units.mk0 x hx0, ?_⟩
      apply Units.ext
      simpa using hx.symm
    exact hq.trans (point_one F p)

theorem zero_symbol [FiniteDimensional (PthPowers F p) F] (s t : Fˣ)
    (hs : (s : F) ∉ PthPowers F p) (hz : symbol (p := p) s t = 0) :
    (t : F) ∈ IntermediateField.adjoin (PthPowers F p) ({(s : F)} : Set F) := by
  by_contra ht
  let C := PthPowers F p
  letI : Algebra (ZMod p) C := ZMod.algebra C p
  have hpowers : ∀ x : F, ∃ c : C, x ^ p = algebraMap C F c := by
    intro x
    exact ⟨⟨x ^ p, ⟨x, rfl⟩⟩, rfl⟩
  have hs' : ∀ c : C, algebraMap C F c ≠ (s : F) := by
    intro c hc
    exact hs (hc ▸ c.property)
  obtain ⟨D, E, hDs, hDt, hEs, hEt⟩ :=
    InseparableDerivations.euler_pair hpowers hs' ht
  exact symbol_nonzero_of_euler
    (D.restrictScalars (ZMod p)) (E.restrictScalars (ZMod p))
    s t hDs hDt hEs hEt hz

@[simp] theorem point_div (f g : Fˣ) :
    point F p (f / g) = point F p f - point F p g :=
  map_sub (QuotientAddGroup.mk' (powers F p)) _ _

theorem point_eq_iff_ratio_mem (f g : Fˣ) :
    point F p f = point F p g ↔ (f : F) / (g : F) ∈ PthPowers F p := by
  rw [← sub_eq_zero, ← point_div, point_eq_zero_iff]
  simp

theorem powers_exist (x : F) :
    ∃ c : PthPowers F p, x ^ p = algebraMap (PthPowers F p) F c :=
  ⟨⟨x ^ p, ⟨x, rfl⟩⟩, rfl⟩

theorem simple_minpoly {x : F} (hx : x ∉ PthPowers F p) :
    (minpoly (PthPowers F p) x).natDegree = p := by
  obtain ⟨c, hc⟩ := powers_exist F p x
  rw [InseparableDerivations.minpoly_pth hc (by
    intro b hb
    exact hx (hb ▸ b.property)), Polynomial.natDegree_X_pow_sub_C]

theorem simple_degree [FiniteDimensional (PthPowers F p) F]
    {x : F} (hx : x ∉ PthPowers F p) :
    Module.finrank (PthPowers F p)
      (IntermediateField.adjoin (PthPowers F p) ({x} : Set F)) = p := by
  rw [IntermediateField.adjoin.finrank (Algebra.IsIntegral.isIntegral x)]
  exact simple_minpoly F p hx

theorem adjoin_eq_of_point_eq (f g : Fˣ) (h : point F p f = point F p g) :
    IntermediateField.adjoin (PthPowers F p) ({(f : F)} : Set F) =
      IntermediateField.adjoin (PthPowers F p) ({(g : F)} : Set F) := by
  have forward (u v : Fˣ) (h : point F p u = point F p v) :
      IntermediateField.adjoin (PthPowers F p) ({(u : F)} : Set F) ≤
        IntermediateField.adjoin (PthPowers F p) ({(v : F)} : Set F) := by
    apply IntermediateField.adjoin_le_iff.mpr
    intro z hz
    rcases Set.mem_singleton_iff.mp hz with rfl
    have hc := (point_eq_iff_ratio_mem F p u v).mp h
    have hm := mul_mem
      ((IntermediateField.adjoin (PthPowers F p) ({(v : F)} : Set F)).algebraMap_mem
        ⟨(u : F) / (v : F), hc⟩)
      (IntermediateField.subset_adjoin (PthPowers F p) _ (Set.mem_singleton _))
    change (u : F) / (v : F) * (v : F) ∈
      IntermediateField.adjoin (PthPowers F p) ({(v : F)} : Set F) at hm
    simpa using hm
  exact le_antisymm (forward f g h) (forward g f h.symm)

theorem adjoin_eq_iff_mem [FiniteDimensional (PthPowers F p) F]
    {x y : F} (hx : x ∉ PthPowers F p) (hy : y ∉ PthPowers F p) :
    IntermediateField.adjoin (PthPowers F p) ({x} : Set F) =
      IntermediateField.adjoin (PthPowers F p) ({y} : Set F) ↔
      y ∈ IntermediateField.adjoin (PthPowers F p) ({x} : Set F) := by
  constructor
  · intro h
    rw [h]
    exact IntermediateField.subset_adjoin _ _ (Set.mem_singleton _)
  · intro h
    have hle : IntermediateField.adjoin (PthPowers F p) ({y} : Set F) ≤
        IntermediateField.adjoin (PthPowers F p) ({x} : Set F) :=
      IntermediateField.adjoin_le_iff.mpr (by simpa using h)
    exact (IntermediateField.eq_of_le_of_finrank_eq hle
      (by rw [simple_degree F p hy, simple_degree F p hx])).symm

theorem independent_degree [FiniteDimensional (PthPowers F p) F]
    {x y : F} (hx : x ∉ PthPowers F p)
    (hy : y ∉ IntermediateField.adjoin (PthPowers F p) ({x} : Set F)) :
    Module.finrank (PthPowers F p)
      (IntermediateField.adjoin (PthPowers F p) ({x, y} : Set F)) = p ^ 2 := by
  let C := PthPowers F p
  let S := IntermediateField.adjoin C ({x} : Set F)
  obtain ⟨c, hc⟩ := powers_exist F p y
  have hmin : (minpoly S y).natDegree = p := by
    have hpow : y ^ p = algebraMap S F (algebraMap C S c) :=
      hc.trans (IsScalarTower.algebraMap_apply C S F c)
    rw [InseparableDerivations.minpoly_pth hpow (by
      intro b hb
      exact hy (hb ▸ b.property)), Polynomial.natDegree_X_pow_sub_C]
  have hdim : Module.finrank S (IntermediateField.adjoin S ({y} : Set F)) = p := by
    rw [IntermediateField.adjoin.finrank (Algebra.IsIntegral.isIntegral y)]
    exact hmin
  rw [← IntermediateField.adjoin_simple_adjoin_simple]
  change Module.finrank C (IntermediateField.adjoin S ({y} : Set F)) = p ^ 2
  letI : Module.Free S (IntermediateField.adjoin S ({y} : Set F)) :=
    Module.Free.of_divisionRing S _
  rw [← Module.finrank_mul_finrank C S (IntermediateField.adjoin S ({y} : Set F)),
    hdim, simple_degree F p hx]
  ring

theorem intersection_constants [FiniteDimensional (PthPowers F p) F]
    {x y z : F} (hx : x ∉ PthPowers F p) (hy : y ∉ PthPowers F p)
    (hne : IntermediateField.adjoin (PthPowers F p) ({x} : Set F) ≠
      IntermediateField.adjoin (PthPowers F p) ({y} : Set F))
    (hzx : z ∈ IntermediateField.adjoin (PthPowers F p) ({x} : Set F))
    (hzy : z ∈ IntermediateField.adjoin (PthPowers F p) ({y} : Set F)) :
    z ∈ PthPowers F p := by
  by_contra hz
  exact hne ((adjoin_eq_iff_mem F p hx hz).mpr hzx |>.trans
    ((adjoin_eq_iff_mem F p hy hz).mpr hzy).symm)

def shift (x : Fˣ) (hx : (x : F) ∉ PthPowers F p) (a : PthPowers F p) : Fˣ :=
  Units.mk0 ((x : F) + (a : F)) (by
    intro h
    have he : (x : F) = -(a : F) := eq_neg_of_add_eq_zero_left h
    exact hx (he ▸ (PthPowers F p).neg_mem a.property))

theorem shift_not_power (x : Fˣ) (hx : (x : F) ∉ PthPowers F p)
    (a : (PthPowers F p)ˣ) :
    ∀ i : Fin p, point F p (shift F p x hx a) ≠ i.val • point F p x := by
  intro i hi
  have hq : point F p (shift F p x hx a) = point F p (x ^ i.val) := by
    simpa using hi
  have hc := (point_eq_iff_ratio_mem F p _ _).mp hq
  let c : PthPowers F p := ⟨(shift F p x hx a : F) / (x : F) ^ i.val, hc⟩
  apply InseparableDerivations.affine_nonmonomial (x := (x : F)) (powers_exist F p)
    (by intro b hb; exact hx (hb ▸ b.property)) (a : PthPowers F p) a.ne_zero i c
  change (x : F) + (a : F) =
    ((x : F) + (a : F)) / (x : F) ^ i.val * (x : F) ^ i.val
  rw [div_mul_cancel₀ _ (pow_ne_zero _ x.ne_zero)]

theorem affine_symbol (t u : Fˣ) (c d : PthPowers F p) (hc : c ≠ 0) (hd : d ≠ 0)
    (hu : (u : F) = (c : F) + (d : F) * (t : F)) :
    symbol (p := p) t u = 0 := by
  have hc0 : (c : F) ≠ 0 := by intro h; exact hc (Subtype.ext h)
  have hd0 : (d : F) ≠ 0 := by intro h; exact hd (Subtype.ext h)
  let q : F := -(d : F) * (t : F) / (c : F)
  have hq0 : q ≠ 0 := div_ne_zero (mul_ne_zero (neg_ne_zero.mpr hd0) t.ne_zero) hc0
  have hquot : 1 - q = (u : F) / (c : F) := by
    rw [hu]
    dsimp [q]
    field_simp
    ring
  have hq1 : q ≠ 1 := by
    intro h
    have hu0 := div_ne_zero u.ne_zero hc0
    rw [← hquot, h, sub_self] at hu0
    exact hu0 rfl
  let q0 := Units.mk0 q hq0
  let q1 := Units.mk0 (1-q) (sub_ne_zero.mpr (Ne.symm hq1))
  have hp0 : point F p q0 = point F p t := by
    apply (point_eq_iff_ratio_mem F p _ _).mpr
    have he : q / (t : F) = -(d : F) / (c : F) := by
      dsimp [q]
      field_simp
    change q / (t : F) ∈ PthPowers F p
    rw [he]
    exact (PthPowers F p).div_mem ((PthPowers F p).neg_mem d.property) c.property
  have hp1 : point F p q1 = point F p u := by
    apply (point_eq_iff_ratio_mem F p _ _).mpr
    have he : (1-q) / (u : F) = (c : F)⁻¹ := by
      rw [hquot]
      field_simp
    change (1-q) / (u : F) ∈ PthPowers F p
    rw [he]
    exact (PthPowers F p).inv_mem c.property
  apply (Submodule.Quotient.mk_eq_zero (relations F p)).mpr
  have hg : point F p q0 ⊗ₜ[ZMod p] point F p q1 ∈ relations F p :=
    Submodule.subset_span ⟨q, hq0, hq1, rfl⟩
  simpa only [hp0, hp1] using hg

def representative (v : V F p) : Fˣ := (point_surjective F p v).choose

@[simp] theorem point_representative (v : V F p) :
    point F p (representative F p v) = v := (point_surjective F p v).choose_spec

variable {K L : Type*} [Field K] [Field L] [CharP K p] [CharP L p]

theorem compatible_symbols (e : V K p ≃ₗ[ZMod p] V L p) (he : Compatible e)
    (x y : Kˣ) (X Y : Lˣ)
    (hx : e (point K p x) = point L p X) (hy : e (point K p y) = point L p Y)
    (hz : symbol (p := p) x y = 0) : symbol (p := p) X Y = 0 := by
  have hm : point K p x ⊗ₜ[ZMod p] point K p y ∈ relations K p :=
    (Submodule.Quotient.mk_eq_zero (relations K p)).mp hz
  have h := (compatible_symbol_zero_iff e he _ _).mp hm
  rw [hx, hy] at h
  exact (Submodule.Quotient.mk_eq_zero (relations L p)).mpr h

theorem transfer_nonmonomial (e : V K p ≃ₗ[ZMod p] V L p)
    (x u : Kˣ) (X U : Lˣ)
    (hx : e (point K p x) = point L p X) (hu : e (point K p u) = point L p U)
    (hn : ∀ i : Fin p, point K p u ≠ i.val • point K p x) :
    CharPIntersection.Nonmonomial (k := PthPowers L p) (p := p) (X : L) (U : L) := by
  intro i c h
  have hq : point L p U = point L p (X ^ i.val) := by
    apply (point_eq_iff_ratio_mem L p _ _).mpr
    have hr : (U : L) / (X : L) ^ i.val = (c : L) := by
      rw [h]
      field_simp
      rfl
    change (U : L) / (X : L) ^ i.val ∈ PthPowers L p
    rw [hr]
    exact c.property
  apply hn i
  apply e.injective
  rw [map_nsmul, hx, hu]
  simpa using hq

theorem local_exponent
    [FiniteDimensional (PthPowers K p) K] [FiniteDimensional (PthPowers L p) L]
    (e : V K p ≃ₗ[ZMod p] V L p) (he : Compatible e)
    (x y : Kˣ) (X Y U V' : Lˣ)
    (hx : (x : K) ∉ PthPowers K p) (hy : (y : K) ∉ PthPowers K p)
    (hX : (X : L) ∉ PthPowers L p) (hY : (Y : L) ∉ PthPowers L p)
    (ex : e (point K p x) = point L p X) (ey : e (point K p y) = point L p Y)
    (hne : IntermediateField.adjoin (PthPowers L p) ({(X : L)} : Set L) ≠
      IntermediateField.adjoin (PthPowers L p) ({(Y : L)} : Set L))
    (a b : (PthPowers K p)ˣ)
    (eu : e (point K p (shift K p x hx a)) = point L p U)
    (ev : e (point K p (shift K p y hy b)) = point L p V') :
    CharPIntersection.ExponentConclusion (k := PthPowers L p) (p := p)
      (X : L) (Y : L) (U : L) (V' : L) := by
  let u := shift K p x hx a
  let v := shift K p y hy b
  have ha0 : (a : K) ≠ 0 := by exact_mod_cast a.ne_zero
  have hb0 : (b : K) ≠ 0 := by exact_mod_cast b.ne_zero
  have hz0 : (b : K) * (x : K) - (a : K) * (y : K) ≠ 0 := by
    intro hz
    have hr : (x : K) / (y : K) = (a : K) / (b : K) := by
      apply (div_eq_div_iff y.ne_zero hb0).mpr
      linear_combination hz
    have hq : point K p x = point K p y := by
      apply (point_eq_iff_ratio_mem K p _ _).mpr
      rw [hr]
      exact (PthPowers K p).div_mem (a : PthPowers K p).property
        (b : PthPowers K p).property
    have hXY : point L p X = point L p Y := ex.symm.trans ((congrArg e hq).trans ey)
    exact hne (adjoin_eq_of_point_eq L p X Y hXY)
  let z : Kˣ := Units.mk0 ((b : K) * (x : K) - (a : K) * (y : K)) hz0
  let Z := representative L p (e (point K p z))
  have ez : e (point K p z) = point L p Z := (point_representative L p _).symm
  have hxu : symbol (p := p) x u = 0 := affine_symbol K p x u a 1 a.ne_zero
    one_ne_zero (by simp [u, shift, add_comm])
  have hyv : symbol (p := p) y v = 0 := affine_symbol K p y v b 1 b.ne_zero
    one_ne_zero (by simp [v, shift, add_comm])
  have hU := zero_symbol L p X U hX (compatible_symbols p e he x u X U ex eu hxu)
  have hV := zero_symbol L p Y V' hY (compatible_symbols p e he y v Y V' ey ev hyv)
  have hnu := transfer_nonmonomial p e x u X U ex eu (shift_not_power K p x hx a)
  have hnv := transfer_nonmonomial p e y v Y V' ey ev (shift_not_power K p y hy b)
  have hYX : ((Y / X : Lˣ) : L) ∉ PthPowers L p := by
    intro h
    have hq : point L p Y = point L p X := (point_eq_iff_ratio_mem L p Y X).mpr
      (by simpa using h)
    exact hne (adjoin_eq_of_point_eq L p X Y hq.symm)
  have hVU : ((V' / U : Lˣ) : L) ∉ PthPowers L p := by
    intro h
    have hi : (U : L) / (V' : L) ∈ PthPowers L p := by
      simpa only [Units.val_div_eq_div_val, inv_div] using (PthPowers L p).inv_mem h
    have hUy : (U : L) ∈ IntermediateField.adjoin (PthPowers L p) ({(Y : L)} : Set L) := by
      have hm := mul_mem
        ((IntermediateField.adjoin (PthPowers L p) ({(Y : L)} : Set L)).algebraMap_mem
          ⟨(U : L) / (V' : L), hi⟩) hV
      change (U : L) / (V' : L) * (V' : L) ∈
        IntermediateField.adjoin (PthPowers L p) ({(Y : L)} : Set L) at hm
      simpa using hm
    have hc := intersection_constants L p hX hY hne hU hUy
    exact hnu ⟨0, (Fact.out : p.Prime).pos⟩ ⟨(U : L), hc⟩ (by
      simp only [pow_zero, mul_one]
      rfl)
  have hratio1 : symbol (p := p) (y / x) (z / x) = 0 :=
    affine_symbol K p (y / x) (z / x) b (-(a : PthPowers K p)) b.ne_zero
      (neg_ne_zero.mpr a.ne_zero) (by
        simp only [Units.val_div_eq_div_val, Subfield.coe_neg]
        change ((b : K) * (x : K) - (a : K) * (y : K)) / (x : K) =
          (b : K) + (-(a : K)) * ((y : K) / (x : K))
        field_simp [x.ne_zero]
        ring)
  have hratio2 : symbol (p := p) (v / u) (z / u) = 0 :=
    affine_symbol K p (v / u) (z / u) b (-(a : PthPowers K p)) b.ne_zero
      (neg_ne_zero.mpr a.ne_zero) (by
        simp only [Units.val_div_eq_div_val, Subfield.coe_neg]
        change ((b : K) * (x : K) - (a : K) * (y : K)) / (u : K) =
          (b : K) + (-(a : K)) * ((v : K) / (u : K))
        field_simp [u.ne_zero]
        dsimp [u, v, shift]
        ring)
  have hs := zero_symbol L p (Y / X) (Z / X) hYX
    (compatible_symbols p e he (y / x) (z / x) (Y / X) (Z / X)
      (by simp only [point_div, map_sub, ey, ex])
      (by simp only [point_div, map_sub, ez, ex]) hratio1)
  have ht := zero_symbol L p (V' / U) (Z / U) hVU
    (compatible_symbols p e he (v / u) (z / u) (V' / U) (Z / U)
      (by simp only [point_div, map_sub]; exact congrArg₂ (· - ·) ev eu)
      (by simp only [point_div, map_sub]; exact congrArg₂ (· - ·) ez eu) hratio2)
  apply CharPIntersection.prop_intersection
    (independent_degree L p hX (fun h => hne ((adjoin_eq_iff_mem L p hX hY).mpr h)))
    X.ne_zero Y.ne_zero U.ne_zero V'.ne_zero hU hV hnu hnv Z.ne_zero
    (by simpa only [Units.val_div_eq_div_val] using hs)
    (by simpa only [Units.val_div_eq_div_val] using ht)
    (div_ne_zero Z.ne_zero X.ne_zero) (div_ne_zero Z.ne_zero U.ne_zero)
    (by field_simp) (by field_simp)

theorem two_parts [FiniteDimensional (PthPowers F p) F]
    (hd : p ^ 2 ≤ Module.finrank (PthPowers F p) F) :
    ∃ x y : Fˣ, (x : F) ∉ PthPowers F p ∧ (y : F) ∉ PthPowers F p ∧
      IntermediateField.adjoin (PthPowers F p) ({(x : F)} : Set F) ≠
        IntermediateField.adjoin (PthPowers F p) ({(y : F)} : Set F) := by
  have hp : 1 < p := (Fact.out : p.Prime).one_lt
  obtain ⟨x, hx⟩ : ∃ x : F, x ∉ PthPowers F p := by
    by_contra! h
    have hsurj : Function.Surjective (algebraMap (PthPowers F p) F) :=
      fun z => ⟨⟨z, h z⟩, rfl⟩
    have hdim : Module.finrank (PthPowers F p) F = 1 :=
      Algebra.finrank_eq_one_iff_bijective_algebraMap.mpr
        ⟨(algebraMap (PthPowers F p) F).injective, hsurj⟩
    nlinarith
  let S := IntermediateField.adjoin (PthPowers F p) ({x} : Set F)
  obtain ⟨y, hy⟩ : ∃ y : F, y ∉ S := by
    by_contra! h
    have htop : S = ⊤ := SetLike.ext (fun z => by simp [h z])
    have heq : Module.finrank (PthPowers F p) F = p := by
      rw [← IntermediateField.finrank_top', ← htop]
      exact simple_degree F p hx
    nlinarith
  have hyC : y ∉ PthPowers F p := by
    intro h
    exact hy (S.algebraMap_mem ⟨y, h⟩)
  have hx0 : x ≠ 0 := by intro h; exact hx (h ▸ (PthPowers F p).zero_mem)
  have hy0 : y ≠ 0 := by intro h; exact hy (h ▸ S.zero_mem)
  refine ⟨Units.mk0 x hx0, Units.mk0 y hy0, hx, hyC, ?_⟩
  intro heq
  exact hy ((adjoin_eq_iff_mem F p hx hyC).mp heq)

end CharPLineRecovery



namespace LineGlue

theorem global_parameter {I P A N : Type*}
    (part : I → P) (hparts : ∃ i j, part i ≠ part j)
    (a0 : A) (good : I → A → N → Prop)
    (hlocal : ∀ i j, part i ≠ part j → ∀ a b,
      ∃ n, good i a n ∧ good j b n)
    (hunique : ∀ i a n m, good i a n → good i a m → n = m) :
    ∃! n, ∀ i a, good i a n := by
  obtain ⟨i0, j0, hij⟩ := hparts
  obtain ⟨n, hni, hnj⟩ := hlocal i0 j0 hij a0 a0
  refine ⟨n, ?_, ?_⟩
  · intro i a
    by_cases hi : part i = part i0
    · have hji : part j0 ≠ part i := by
        intro he
        exact hij (hi.symm.trans he.symm)
      obtain ⟨m, hmj, hmi⟩ := hlocal j0 i hji a0 a
      exact hunique j0 a0 m n hmj hnj ▸ hmi
    · obtain ⟨m, hmi, hma⟩ := hlocal i0 i (Ne.symm hi) a0 a
      exact hunique i0 a0 m n hmi hni ▸ hma
  · intro m hm
    exact hunique i0 a0 m n (hm i0 a0) hni

theorem global_parameter_local_unique {I P A N : Type*}
    (part : I → P) (hparts : ∃ i j, part i ≠ part j)
    (a0 : A) (good : I → A → N → Prop)
    (hlocal : ∀ i j, part i ≠ part j → ∀ a b,
      ∃ n, good i a n ∧ good j b n ∧
        ∀ m, good i a m ∨ good j b m → m = n) :
    ∃! n, ∀ i a, good i a n := by
  have hneighbor : ∀ i, ∃ j, part i ≠ part j := by
    obtain ⟨i0, j0, hij⟩ := hparts
    intro i
    by_cases h : part i = part i0
    · exact ⟨j0, h ▸ hij⟩
    · exact ⟨i0, h⟩
  apply global_parameter part hparts a0 good
  · intro i j hij a b
    obtain ⟨n, hi, hj, _⟩ := hlocal i j hij a b
    exact ⟨n, hi, hj⟩
  · intro i a n m hn hm
    obtain ⟨j, hij⟩ := hneighbor i
    obtain ⟨r, _, _, hr⟩ := hlocal i j hij a a0
    exact (hr n (Or.inl hn)).trans (hr m (Or.inl hm)).symm

def TakesLines {A B : Type*} (linesA : Set (Set A)) (linesB : Set (Set B))
    (f : A → B) : Prop :=
  ∀ ell ∈ linesA, ∃ ell' ∈ linesB, f '' ell ⊆ ell'

theorem takesLines_comp {A B C : Type*}
    {linesA : Set (Set A)} {linesB : Set (Set B)} {linesC : Set (Set C)}
    {f : A → B} {g : B → C}
    (hf : TakesLines linesA linesB f) (hg : TakesLines linesB linesC g) :
    TakesLines linesA linesC (g ∘ f) := by
  intro ell hell
  obtain ⟨ell', hell', hfell⟩ := hf ell hell
  obtain ⟨ell'', hell'', hgell⟩ := hg ell' hell'
  refine ⟨ell'', hell'', ?_⟩
  rintro _ ⟨a, ha, rfl⟩
  exact hgell ⟨f a, hfell ⟨a, ha, rfl⟩, rfl⟩

theorem onto_of_inverse_containment {A B : Type*}
    (linesA : Set (Set A)) (linesB : Set (Set B)) (f : A ≃ B)
    (hanti : ∀ ell ∈ linesA, ∀ ell' ∈ linesA, ell ⊆ ell' → ell = ell')
    (hf : TakesLines linesA linesB f) (hb : TakesLines linesB linesA f.symm) :
    ∀ ell ∈ linesA, ∃ ell' ∈ linesB, f '' ell = ell' := by
  intro ell hell
  obtain ⟨ell', hell', hforward⟩ := hf ell hell
  obtain ⟨ell'', hell'', hback⟩ := hb ell' hell'
  have hsub : ell ⊆ ell'' := by
    intro a ha
    exact hback ⟨f a, hforward ⟨a, ha, rfl⟩, f.symm_apply_apply a⟩
  have heq : ell = ell'' := hanti ell hell ell'' hell'' hsub
  refine ⟨ell', hell', Set.Subset.antisymm hforward ?_⟩
  intro b hb
  have hpre : f.symm b ∈ ell := by
    rw [heq]
    exact hback ⟨b, hb, rfl⟩
  exact ⟨f.symm b, hpre, f.apply_symm_apply b⟩

end LineGlue

namespace CharPLineRecovery

variable {p : ℕ} [Fact p.Prime]
variable {K L : Type*} [Field K] [Field L] [CharP K p] [CharP L p]

theorem image_not_constant (e : V K p ≃ₗ[ZMod p] V L p) (x : Kˣ)
    (hx : (x : K) ∉ PthPowers K p) :
    (representative L p (e (point K p x)) : L) ∉ PthPowers L p := by
  intro h
  have hz : e (point K p x) = 0 := by
    rw [← point_representative L p (e (point K p x))]
    exact (point_eq_zero_iff L p _).mpr h
  have hxz : point K p x = 0 := e.injective (by simpa using hz)
  exact hx ((point_eq_zero_iff K p x).mp hxz)

theorem global_affine
    [FiniteDimensional (PthPowers K p) K] [FiniteDimensional (PthPowers L p) L]
    (e : V K p ≃ₗ[ZMod p] V L p) (he : Compatible e)
    (hdL : p ^ 2 ≤ Module.finrank (PthPowers L p) L) :
    ∃ n : ℕ, 0 < n ∧ n < p ∧
      ∀ (x : Kˣ) (hx : (x : K) ∉ PthPowers K p) (a : (PthPowers K p)ˣ),
        CharPIntersection.AffinePower (k := PthPowers L p)
          (representative L p (e (point K p x)) : L)
          (representative L p (e (point K p (shift K p x hx a))) : L) n := by
  let I := {x : Kˣ // (x : K) ∉ PthPowers K p}
  let N := {n : ℕ // 0 < n ∧ n < p}
  let part : I → IntermediateField (PthPowers L p) L := fun i =>
    IntermediateField.adjoin (PthPowers L p)
      ({(representative L p (e (point K p i.val)) : L)} : Set L)
  let good : I → (PthPowers K p)ˣ → N → Prop := fun i a n =>
    CharPIntersection.AffinePower (k := PthPowers L p)
      (representative L p (e (point K p i.val)) : L)
      (representative L p (e (point K p (shift K p i.val i.property a))) : L) n.val
  have hparts : ∃ i j, part i ≠ part j := by
    obtain ⟨X, Y, hX, hY, hXY⟩ := two_parts L p hdL
    let i : I := ⟨representative K p (e.symm (point L p X)), image_not_constant e.symm X hX⟩
    let j : I := ⟨representative K p (e.symm (point L p Y)), image_not_constant e.symm Y hY⟩
    have hi : part i = IntermediateField.adjoin (PthPowers L p) ({(X : L)} : Set L) :=
      adjoin_eq_of_point_eq L p _ X (by simp [part, i])
    have hj : part j = IntermediateField.adjoin (PthPowers L p) ({(Y : L)} : Set L) :=
      adjoin_eq_of_point_eq L p _ Y (by simp [part, j])
    exact ⟨i, j, by simpa only [hi, hj] using hXY⟩
  have hlocal : ∀ i j, part i ≠ part j → ∀ a b,
      ∃ n, good i a n ∧ good j b n ∧ ∀ m, good i a m ∨ good j b m → m = n := by
    intro i j hij a b
    obtain ⟨n, hn, hnp, hU, hV, huniq⟩ := local_exponent p e he i.val j.val
      (representative L p (e (point K p i.val))) (representative L p (e (point K p j.val)))
      (representative L p (e (point K p (shift K p i.val i.property a))))
      (representative L p (e (point K p (shift K p j.val j.property b))))
      i.property j.property (image_not_constant e _ i.property) (image_not_constant e _ j.property)
      (point_representative L p _).symm (point_representative L p _).symm hij a b
      (point_representative L p _).symm (point_representative L p _).symm
    obtain ⟨A, B, _, _, hUeq⟩ := hU
    obtain ⟨D, E, _, _, hVeq⟩ := hV
    refine ⟨⟨n, hn, hnp⟩, ⟨A, B, hUeq⟩, ⟨D, E, hVeq⟩, ?_⟩
    intro m hm
    exact Subtype.ext (huniq m.val m.property.1 m.property.2 hm)
  obtain ⟨n, hn, _⟩ :=
    LineGlue.global_parameter_local_unique part hparts 1 good hlocal
  exact ⟨n.val, n.property.1, n.property.2, fun x hx a => hn ⟨x, hx⟩ a⟩

end CharPLineRecovery

namespace CharPLineRecovery

variable (F : Type*) [Field F] (p : ℕ) [Fact p.Prime] [CharP F p]

def ZeroInc (x y : V F p) : Prop :=
  ∃ s u : Fˣ, point F p s = x ∧ point F p u = y ∧
    ∃ a b : PthPowers F p, (u : F) = (a : F) + (b : F) * (s : F)

theorem zeroInc_iff (s u : Fˣ) :
    ZeroInc F p (point F p s) (point F p u) ↔
      ∃ a b : PthPowers F p, (u : F) = (a : F) + (b : F) * (s : F) := by
  constructor
  · rintro ⟨S, U, hS, hU, a, b, he⟩
    have hcs := (point_eq_iff_ratio_mem F p S s).mp hS
    have hcu := (point_eq_iff_ratio_mem F p u U).mp hU.symm
    let cs : PthPowers F p := ⟨(S : F) / (s : F), hcs⟩
    let cu : PthPowers F p := ⟨(u : F) / (U : F), hcu⟩
    refine ⟨cu * a, cu * b * cs, ?_⟩
    change (u : F) = (u : F) / (U : F) * (a : F) +
      ((u : F) / (U : F) * (b : F) * ((S : F) / (s : F))) * (s : F)
    calc
      (u : F) = (u : F) / (U : F) * (U : F) :=
        (div_mul_cancel₀ _ U.ne_zero).symm
      _ = _ := by rw [he]; field_simp [s.ne_zero]
  · rintro ⟨a, b, he⟩
    exact ⟨s, u, rfl, rfl, a, b, he⟩

theorem zeroInc_zero (x : V F p) : ZeroInc F p x 0 := by
  obtain ⟨s, rfl⟩ := point_surjective F p x
  exact ⟨s, 1, rfl, point_one F p, 1, 0, by simp⟩

theorem zeroInc_self (x : V F p) : ZeroInc F p x x := by
  obtain ⟨s, rfl⟩ := point_surjective F p x
  exact ⟨s, s, rfl, rfl, 0, 1, by simp⟩

def line (a b : V F p) : Set (V F p) :=
  {c | ZeroInc F p (b-a) (c-a)}

theorem line_iff_coefficients (s t u : Fˣ) :
    point F p u ∈ line F p (point F p s) (point F p t) ↔
      ∃ a b : PthPowers F p, (u : F) = (a : F) * (s : F) + (b : F) * (t : F) := by
  change ZeroInc F p (point F p t - point F p s) (point F p u - point F p s) ↔ _
  rw [← point_div, ← point_div, zeroInc_iff]
  simp only [Units.val_div_eq_div_val]
  constructor
  · rintro ⟨a, b, he⟩
    refine ⟨a, b, ?_⟩
    have h := congrArg (fun z : F => z * (s : F)) he
    field_simp [s.ne_zero] at h
    linear_combination h
  · rintro ⟨a, b, he⟩
    refine ⟨a, b, ?_⟩
    rw [he]
    field_simp [s.ne_zero]

def PreservesZero {G : Type*} [Field G] [CharP G p] (e : V F p ≃ₗ[ZMod p] V G p) : Prop :=
  ∀ x, x ≠ 0 → ∀ y, ZeroInc F p x y → ZeroInc G p (e x) (e y)

def LineOnto {G : Type*} [Field G] [CharP G p] (e : V F p ≃ₗ[ZMod p] V G p) : Prop :=
  ∀ a b, a ≠ b → e '' line F p a b = line G p (e a) (e b)

def scale {G : Type*} [Field G] [CharP G p]
    (e : V F p ≃ₗ[ZMod p] V G p) (n : (ZMod p)ˣ) : V F p ≃ₗ[ZMod p] V G p :=
  e.trans (LinearEquiv.smulOfUnit n)

@[simp] theorem scale_apply {G : Type*} [Field G] [CharP G p]
    (e : V F p ≃ₗ[ZMod p] V G p) (n : (ZMod p)ˣ) (x : V F p) :
    scale F p e n x = (n : ZMod p) • e x := rfl

theorem lineOnto_of_both {G : Type*} [Field G] [CharP G p]
    (e : V F p ≃ₗ[ZMod p] V G p)
    (he : PreservesZero F p e) (hi : PreservesZero G p e.symm) :
    LineOnto F p e := by
  intro a b hab
  ext c
  constructor
  · rintro ⟨d, hd, rfl⟩
    change ZeroInc G p (e b - e a) (e d - e a)
    simpa only [map_sub] using he (b-a) (sub_ne_zero.mpr (Ne.symm hab)) (d-a) hd
  · intro hc
    refine ⟨e.symm c, ?_, e.apply_symm_apply c⟩
    have hba : e b - e a ≠ 0 := sub_ne_zero.mpr (e.injective.ne (Ne.symm hab))
    have h := hi (e b - e a) hba (c - e a) hc
    change ZeroInc F p (b-a) (e.symm c-a)
    simpa only [map_sub, e.symm_apply_apply] using h

theorem preservesZero_of_lineOnto {G : Type*} [Field G] [CharP G p]
    (e : V F p ≃ₗ[ZMod p] V G p) (he : LineOnto F p e) :
    PreservesZero F p e := by
  intro x hx y hy
  have hl := he 0 x (Ne.symm hx)
  have hmem : y ∈ line F p 0 x := by simpa [line] using hy
  have h := hl ▸ Set.mem_image_of_mem e hmem
  simpa only [line, map_zero, sub_zero, Set.mem_setOf_eq] using h

theorem preservesZero_comp {G J : Type*} [Field G] [Field J] [CharP G p] [CharP J p]
    (e : V F p ≃ₗ[ZMod p] V G p) (f : V G p ≃ₗ[ZMod p] V J p)
    (he : PreservesZero F p e) (hf : PreservesZero G p f) :
    PreservesZero F p (e.trans f) := by
  intro x hx y hy
  exact hf (e x) (by intro h; exact hx (e.injective (h.trans e.map_zero.symm)))
    (e y) (he x hx y hy)

theorem scale_symm_apply {G : Type*} [Field G] [CharP G p]
    (e : V F p ≃ₗ[ZMod p] V G p) (n : (ZMod p)ˣ) (y : V G p) :
    (scale F p e n).symm y = ((n⁻¹ : (ZMod p)ˣ) : ZMod p) • e.symm y := by
  apply (scale F p e n).injective
  rw [LinearEquiv.apply_symm_apply]
  change y = (n : ZMod p) • e (((n⁻¹ : (ZMod p)ˣ) : ZMod p) • e.symm y)
  rw [map_smul, e.apply_symm_apply, smul_smul, ← Units.val_mul, mul_inv_cancel,
    Units.val_one, one_smul]

variable {K L : Type*} [Field K] [Field L] [CharP K p] [CharP L p]

theorem compatible_symm (e : V K p ≃ₗ[ZMod p] V L p) (he : Compatible e) :
    Compatible e.symm := by
  let t := TensorProduct.congr e e
  change Submodule.map t.toLinearMap (relations K p) = relations L p at he
  change Submodule.map t.symm.toLinearMap (relations L p) = relations K p
  rw [← he]
  ext z
  constructor
  · rintro ⟨w, ⟨v, hv, rfl⟩, rfl⟩
    change t.symm (t v) ∈ relations K p
    rw [t.symm_apply_apply]
    exact hv
  · intro hz
    exact ⟨t z, ⟨z, hz, rfl⟩, t.symm_apply_apply z⟩

theorem containment
    [FiniteDimensional (PthPowers K p) K] [FiniteDimensional (PthPowers L p) L]
    (e : V K p ≃ₗ[ZMod p] V L p) (he : Compatible e)
    (hdL : p ^ 2 ≤ Module.finrank (PthPowers L p) L) :
    ∃ n : (ZMod p)ˣ, PreservesZero K p (scale K p e n) := by
  obtain ⟨r, hr, hrp, hglobal⟩ := global_affine e he hdL
  have hr0 : (r : ZMod p) ≠ 0 := by
    intro h
    have heq : r = 0 := (CharP.natCast_injOn_Iio (ZMod p) p) hrp
      (Fact.out : p.Prime).pos (by simpa using h)
    omega
  let n : (ZMod p)ˣ := Units.mk0 (r : ZMod p) hr0
  refine ⟨n, ?_⟩
  intro x hx y hy
  obtain ⟨s, u, hs, hu, c, d, heq⟩ := hy
  have hsC : (s : K) ∉ PthPowers K p := by
    intro h
    exact hx (hs.symm.trans ((point_eq_zero_iff K p s).mpr h))
  by_cases hd : d = 0
  · have hy0 : y = 0 := hu.symm.trans ((point_eq_zero_iff K p u).mpr (by
      rw [heq, hd]
      simpa using c.property))
    rw [hy0, map_zero]
    exact zeroInc_zero L p _
  by_cases hc : c = 0
  · have hqus : point K p u = point K p s := by
      apply (point_eq_iff_ratio_mem K p u s).mpr
      rw [heq, hc]
      simpa using d.property
    have hyx : y = x := hu.symm.trans (hqus.trans hs)
    rw [hyx]
    exact zeroInc_self L p _
  let a : (PthPowers K p)ˣ := Units.mk0 (c / d) (div_ne_zero hc hd)
  let w := shift K p s hsC a
  have hd0 : (d : K) ≠ 0 := by intro h; exact hd (Subtype.ext h)
  have hquw : point K p u = point K p w := by
    apply (point_eq_iff_ratio_mem K p u w).mpr
    have huw : (u : K) = (d : K) * (w : K) := by
      change (u : K) = (d : K) * ((s : K) + (c : K) / (d : K))
      rw [heq]
      field_simp [hd0]
      ring
    rw [huw]
    simpa using d.property
  obtain ⟨A, B, hAB⟩ := hglobal s hsC a
  let X := representative L p (e (point K p s))
  let U := representative L p (e (point K p w))
  refine ⟨X ^ r, U ^ r, ?_, ?_, A, B, ?_⟩
  · simp only [point_pow, X, point_representative, scale_apply, n, Units.val_mk0,
      Nat.cast_smul_eq_nsmul, hs]
  · simp only [point_pow, U, point_representative, scale_apply, n, Units.val_mk0,
      Nat.cast_smul_eq_nsmul]
    rw [← hquw, hu]
  · have hA : algebraMap (PthPowers L p) L A = (A : L) := rfl
    have hB : algebraMap (PthPowers L p) L B = (B : L) := rfl
    simpa only [hA, hB, Units.val_pow_eq_pow_val, U, X, w] using hAB

theorem scalar_rigidity [FiniteDimensional (PthPowers F p) F]
    (hdF : p ^ 2 ≤ Module.finrank (PthPowers F p) F)
    (n : (ZMod p)ˣ)
    (hn : PreservesZero F p (scale F p (LinearEquiv.refl (ZMod p) (V F p)) n)) :
    n = 1 := by
  obtain ⟨x, _, hx, _, _⟩ := two_parts F p hdF
  let u := shift F p x hx 1
  have hxu : ZeroInc F p (point F p x) (point F p u) :=
    ⟨x, u, rfl, rfl, 1, 1, by simp [u, shift, add_comm]⟩
  have hx0 : point F p x ≠ 0 := fun h => hx ((point_eq_zero_iff F p x).mp h)
  have h := hn _ hx0 _ hxu
  let r := (n : ZMod p).val
  have hr0 : 0 < r := by
    apply Nat.pos_of_ne_zero
    intro h0
    have hcast := ZMod.natCast_zmod_val (n : ZMod p)
    rw [show (n : ZMod p).val = 0 from h0] at hcast
    exact n.ne_zero (by simpa using hcast.symm)
  have hrp : r < p := ZMod.val_lt _
  have hpoint (v : Fˣ) : point F p (v ^ r) =
      scale F p (LinearEquiv.refl (ZMod p) (V F p)) n (point F p v) := by
    simp only [point_pow, scale_apply, LinearEquiv.refl_apply]
    rw [← ZMod.natCast_zmod_val (n : ZMod p), Nat.cast_smul_eq_nsmul]
  rw [← hpoint x, ← hpoint u] at h
  obtain ⟨A, B, hAB⟩ := (zeroInc_iff F p (x ^ r) (u ^ r)).mp h
  have hr1 : r = 1 := InseparableDerivations.scalar_affine_rigidity (powers_exist F p)
    (x := (x : F)) (by
      intro c hc
      apply hx
      rw [← hc]
      exact c.property) hr0 hrp A B (by
      change ((x : F) + 1)^r = (A : F) + (B : F) * (x : F)^r
      simpa [u, shift] using hAB)
  apply Units.ext
  rw [← ZMod.natCast_zmod_val (n : ZMod p)]
  change (r : ZMod p) = 1
  rw [hr1, Nat.cast_one]

theorem prop_lines
    [FiniteDimensional (PthPowers K p) K] [FiniteDimensional (PthPowers L p) L]
    (hdK : p ^ 2 ≤ Module.finrank (PthPowers K p) K)
    (hdL : p ^ 2 ≤ Module.finrank (PthPowers L p) L)
    (e : V K p ≃ₗ[ZMod p] V L p) (he : Compatible e) :
    ∃! n : (ZMod p)ˣ, LineOnto K p (scale K p e n) := by
  obtain ⟨n, hn⟩ := containment p e he hdL
  obtain ⟨m, hm⟩ := containment p e.symm (compatible_symm p e he) hdK
  let psi := scale K p e n
  let phi := scale L p e.symm m
  have hcomp : psi.trans phi =
      scale K p (LinearEquiv.refl (ZMod p) (V K p)) (m*n) := by
    ext x
    simp [psi, phi, scale_apply, map_smul, smul_smul, mul_comm]
  have hmn : m*n = 1 := scalar_rigidity K p hdK (m*n)
    (hcomp ▸ preservesZero_comp K p psi phi hn hm)
  have hphi : phi = psi.symm := by
    ext y
    have h := LinearEquiv.congr_fun hcomp (psi.symm y)
    simpa only [LinearEquiv.trans_apply, LinearEquiv.apply_symm_apply, hmn,
      scale_apply, Units.val_one, one_smul, LinearEquiv.refl_apply] using h
  have hi : PreservesZero L p psi.symm := hphi ▸ hm
  refine ⟨n, lineOnto_of_both K p psi hn hi, ?_⟩
  intro k hk
  have hpres := preservesZero_of_lineOnto K p (scale K p e k) hk
  have heq : psi.symm.trans (scale K p e k) =
      scale L p (LinearEquiv.refl (ZMod p) (V L p)) (k*n⁻¹) := by
    ext x
    simp only [LinearEquiv.trans_apply, psi, scale_symm_apply, scale_apply, map_smul,
      LinearEquiv.apply_symm_apply, LinearEquiv.refl_apply, smul_smul, Units.val_mul]
    rw [mul_comm]
  have hkn : k*n⁻¹ = 1 := scalar_rigidity L p hdL (k*n⁻¹)
    (heq ▸ preservesZero_comp L p psi.symm (scale K p e k) hi hpres)
  exact (mul_inv_eq_one.mp hkn)

theorem mem_line_left (a b : V F p) : a ∈ line F p a b := by
  change ZeroInc F p (b-a) (a-a)
  rw [sub_self]
  exact zeroInc_zero F p _

theorem mem_line_right (a b : V F p) : b ∈ line F p a b :=
  zeroInc_self F p _

theorem line_iff_span (s t u : Fˣ) :
    point F p u ∈ line F p (point F p s) (point F p t) ↔
      (u : F) ∈ Submodule.span (PthPowers F p) ({(s : F), (t : F)} : Set F) := by
  rw [line_iff_coefficients, Submodule.mem_span_pair]
  constructor
  · rintro ⟨a, b, he⟩
    exact ⟨a, b, he.symm⟩
  · rintro ⟨a, b, he⟩
    exact ⟨a, b, he.symm⟩

theorem span_pair_finrank (s t : Fˣ) (hst : point F p s ≠ point F p t) :
    Module.finrank (PthPowers F p)
      (Submodule.span (PthPowers F p) ({(s : F), (t : F)} : Set F)) = 2 := by
  have hi : LinearIndependent (PthPowers F p) ![(s : F), (t : F)] := by
    apply linearIndependent_fin2.mpr
    refine ⟨t.ne_zero, ?_⟩
    intro a ha
    apply hst
    apply (point_eq_iff_ratio_mem F p s t).mpr
    change (a : F) * (t : F) = (s : F) at ha
    rw [← ha]
    simpa using a.property
  have hr : Set.range (![(s : F), (t : F)] : Fin 2 → F) =
      ({(s : F), (t : F)} : Set F) := by
    ext z
    simp [or_comm]
  rw [← hr]
  exact finrank_span_eq_card hi

theorem line_eq_of_two_mem [FiniteDimensional (PthPowers F p) F]
    (a b c d : V F p) (hab : a ≠ b) (hcd : c ≠ d)
    (hc : c ∈ line F p a b) (hd : d ∈ line F p a b) :
    line F p c d = line F p a b := by
  obtain ⟨s, rfl⟩ := point_surjective F p a
  obtain ⟨t, rfl⟩ := point_surjective F p b
  obtain ⟨u, rfl⟩ := point_surjective F p c
  obtain ⟨v, rfl⟩ := point_surjective F p d
  have hle : Submodule.span (PthPowers F p) ({(u : F), (v : F)} : Set F) ≤
      Submodule.span (PthPowers F p) ({(s : F), (t : F)} : Set F) := by
    apply Submodule.span_le.mpr
    intro z hz
    rcases Set.mem_insert_iff.mp hz with rfl | hz
    · exact (line_iff_span F p s t u).mp hc
    · rw [Set.mem_singleton_iff.mp hz]
      exact (line_iff_span F p s t v).mp hd
  have heq := Submodule.eq_of_le_of_finrank_eq hle
    ((span_pair_finrank F p u v hcd).trans (span_pair_finrank F p s t hab).symm)
  ext z
  obtain ⟨w, rfl⟩ := point_surjective F p z
  rw [line_iff_span, line_iff_span, heq]

def SendsLinesOnto {G : Type*} [Field G] [CharP G p]
    (e : V F p ≃ₗ[ZMod p] V G p) : Prop :=
  ∀ a b, a ≠ b → ∃ c d, c ≠ d ∧ e '' line F p a b = line G p c d

theorem lineOnto_iff_sendsLinesOnto {G : Type*} [Field G] [CharP G p]
    [FiniteDimensional (PthPowers G p) G] (e : V F p ≃ₗ[ZMod p] V G p) :
    LineOnto F p e ↔ SendsLinesOnto F p e := by
  constructor
  · intro h a b hab
    exact ⟨e a, e b, e.injective.ne hab, h a b hab⟩
  · intro h a b hab
    obtain ⟨c, d, hcd, he⟩ := h a b hab
    have ha : e a ∈ line G p c d :=
      he ▸ Set.mem_image_of_mem e (mem_line_left F p a b)
    have hb : e b ∈ line G p c d :=
      he ▸ Set.mem_image_of_mem e (mem_line_right F p a b)
    exact he.trans (line_eq_of_two_mem G p c d (e a) (e b)
      hcd (e.injective.ne hab) ha hb).symm

theorem prop_lines_source
    [FiniteDimensional (PthPowers K p) K] [FiniteDimensional (PthPowers L p) L]
    (hdK : p ^ 2 ≤ Module.finrank (PthPowers K p) K)
    (hdL : p ^ 2 ≤ Module.finrank (PthPowers L p) L)
    (e : V K p ≃ₗ[ZMod p] V L p) (he : Compatible e) :
    ∃! n : (ZMod p)ˣ, SendsLinesOnto K p (scale K p e n) := by
  obtain ⟨n, hn, hu⟩ := prop_lines p hdK hdL e he
  refine ⟨n, (lineOnto_iff_sendsLinesOnto K p _).mp hn, ?_⟩
  intro k hk
  exact hu k ((lineOnto_iff_sendsLinesOnto K p _).mpr hk)

#print axioms zero_symbol
#print axioms global_affine
#print axioms prop_lines_source

end CharPLineRecovery
