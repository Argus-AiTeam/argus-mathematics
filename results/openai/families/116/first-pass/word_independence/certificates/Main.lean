import Mathlib

open scoped BigOperators
open scoped RatFunc
open Polynomial

noncomputable section

namespace WordIndependence

variable {K : Type*} [Field K]

def polyScale (τ : K) : K[X] →+* K[X] :=
  Polynomial.compRingHom (Polynomial.C τ * Polynomial.X)

@[simp] theorem polyScale_C (τ a : K) :
    polyScale τ (Polynomial.C a) = Polynomial.C a := by
  simp [polyScale]

@[simp] theorem polyScale_X (τ : K) :
    polyScale τ Polynomial.X = Polynomial.C τ * Polynomial.X := by
  simp [polyScale]

theorem polyScale_comp (τ υ : K) :
    (polyScale τ).comp (polyScale υ) = polyScale (τ * υ) := by
  apply Polynomial.ringHom_ext
  · intro a
    simp
  · simp
    ring

@[simp] theorem polyScale_one : polyScale (1 : K) = RingHom.id _ := by
  apply Polynomial.ringHom_ext
  · intro a
    simp
  · simp

theorem polyScale_injective (τ : K) (hτ : τ ≠ 0) :
    Function.Injective (polyScale τ) := by
  have he : (polyScale τ⁻¹).comp (polyScale τ) = RingHom.id _ := by
    rw [polyScale_comp, inv_mul_cancel₀ hτ, polyScale_one]
  intro p q hpq
  have := congrArg (polyScale τ⁻¹) hpq
  simpa only [← RingHom.comp_apply, he, RingHom.id_apply] using this

def rationalScale (τ : K) (hτ : τ ≠ 0) : RatFunc K →+* RatFunc K :=
  IsFractionRing.lift (K := RatFunc K)
    (g := (algebraMap K[X] (RatFunc K)).comp (polyScale τ))
    ((RatFunc.algebraMap_injective K).comp (polyScale_injective τ hτ))

def RegularAt (r : RatFunc K) (a : K) : Prop :=
  ∃ p q : K[X], q.eval a ≠ 0 ∧
    r = algebraMap K[X] (RatFunc K) p / algebraMap K[X] (RatFunc K) q

theorem regularAt_of_denom (r : RatFunc K) (a : K)
    (h : r.denom.eval a ≠ 0) : RegularAt r a :=
  ⟨r.num, r.denom, h, (RatFunc.num_div_denom r).symm⟩

theorem regularAt_zero (a : K) : RegularAt (0 : RatFunc K) a := by
  exact ⟨0, 1, by simp, by simp⟩

theorem regularAt_add {r s : RatFunc K} {a : K}
    (hr : RegularAt r a) (hs : RegularAt s a) : RegularAt (r + s) a := by
  obtain ⟨p, q, hq, rfl⟩ := hr
  obtain ⟨u, v, hv, rfl⟩ := hs
  refine ⟨p * v + u * q, q * v, by simpa using mul_ne_zero hq hv, ?_⟩
  have hq0 : algebraMap K[X] (RatFunc K) q ≠ 0 :=
    (map_ne_zero_iff _ (RatFunc.algebraMap_injective K)).mpr (by
      intro hz
      simp [hz] at hq)
  have hv0 : algebraMap K[X] (RatFunc K) v ≠ 0 :=
    (map_ne_zero_iff _ (RatFunc.algebraMap_injective K)).mpr (by
      intro hz
      simp [hz] at hv)
  simp only [map_add, map_mul]
  simpa only [mul_comm] using
    div_add_div (algebraMap K[X] (RatFunc K) p)
      (algebraMap K[X] (RatFunc K) u) hq0 hv0

theorem regularAt_neg {r : RatFunc K} {a : K}
    (hr : RegularAt r a) : RegularAt (-r) a := by
  obtain ⟨p, q, hq, rfl⟩ := hr
  exact ⟨-p, q, hq, by simp [neg_div]⟩

theorem regularAt_mul {r s : RatFunc K} {a : K}
    (hr : RegularAt r a) (hs : RegularAt s a) : RegularAt (r * s) a := by
  obtain ⟨p, q, hq, rfl⟩ := hr
  obtain ⟨u, v, hv, rfl⟩ := hs
  refine ⟨p * u, q * v, by simpa using mul_ne_zero hq hv, ?_⟩
  simp only [map_mul]
  exact div_mul_div_comm _ _ _ _

theorem regularAt_constant (a c : K) :
    RegularAt (algebraMap K (RatFunc K) c) a := by
  refine ⟨Polynomial.C c, 1, by simp, ?_⟩
  simp

theorem regularAt_sum {ι : Type*} (s : Finset ι) (f : ι → RatFunc K) (a : K)
    (hf : ∀ i ∈ s, RegularAt (f i) a) : RegularAt (∑ i ∈ s, f i) a := by
  classical
  induction s using Finset.induction_on with
  | empty => simpa using regularAt_zero a
  | @insert i s hi ih =>
      rw [Finset.sum_insert hi]
      exact regularAt_add (hf i (by simp))
        (ih (fun j hj => hf j (by simp [hj])))

theorem regularAt_fraction_iff (p q : K[X]) (a : K) (hq : q ≠ 0)
    (hpq : p.eval a ≠ 0 ∨ q.eval a ≠ 0) :
    RegularAt (algebraMap K[X] (RatFunc K) p /
      algebraMap K[X] (RatFunc K) q) a ↔ q.eval a ≠ 0 := by
  constructor
  · rintro ⟨u, v, hv, he⟩ hqa
    have hq' := (map_ne_zero_iff _ (RatFunc.algebraMap_injective K)).mpr hq
    have hv' : algebraMap K[X] (RatFunc K) v ≠ 0 :=
      (map_ne_zero_iff _ (RatFunc.algebraMap_injective K)).mpr (by
        intro hz
        simp [hz] at hv)
    have hpv : p * v = u * q :=
      RatFunc.algebraMap_injective K (by
        simpa only [map_mul] using (div_eq_div_iff hq' hv').mp he)
    have heval := congrArg (Polynomial.eval a) hpv
    simp only [Polynomial.eval_mul, hqa, mul_zero] at heval
    exact mul_ne_zero (hpq.resolve_right (not_not.mpr hqa)) hv heval
  · intro h
    exact ⟨p, q, h, rfl⟩

theorem regularAt_iff_denom (r : RatFunc K) (a : K) :
    RegularAt r a ↔ r.denom.eval a ≠ 0 := by
  have hpq := ((RatFunc.isCoprime_num_denom r).map
    (Polynomial.evalRingHom a)).ne_zero_or_ne_zero
  simpa only [RatFunc.num_div_denom] using
    regularAt_fraction_iff r.num r.denom a (RatFunc.denom_ne_zero r) hpq

@[simp] theorem rationalScale_poly (τ : K) (hτ : τ ≠ 0) (p : K[X]) :
    rationalScale τ hτ (algebraMap K[X] (RatFunc K) p) =
      algebraMap K[X] (RatFunc K) (polyScale τ p) := by
  exact IsFractionRing.lift_algebraMap _ _

@[simp] theorem eval_polyScale (τ a : K) (p : K[X]) :
    (polyScale τ p).eval a = p.eval (τ * a) := by
  have he : (Polynomial.evalRingHom a).comp (polyScale τ) =
      Polynomial.evalRingHom (τ * a) := by
    apply Polynomial.ringHom_ext <;> simp
  exact DFunLike.congr_fun he p

theorem regularAt_scale_iff (τ : K) (hτ : τ ≠ 0) (r : RatFunc K) (a : K) :
    RegularAt (rationalScale τ hτ r) a ↔ RegularAt r (τ * a) := by
  have he : rationalScale τ hτ r =
      algebraMap K[X] (RatFunc K) (polyScale τ r.num) /
        algebraMap K[X] (RatFunc K) (polyScale τ r.denom) := by
    calc
      rationalScale τ hτ r =
          rationalScale τ hτ (algebraMap K[X] (RatFunc K) r.num /
            algebraMap K[X] (RatFunc K) r.denom) :=
        congrArg _ (RatFunc.num_div_denom r).symm
      _ = _ := by rw [map_div₀, rationalScale_poly, rationalScale_poly]
  have hq : polyScale τ r.denom ≠ 0 :=
    (map_ne_zero_iff _ (polyScale_injective τ hτ)).mpr (RatFunc.denom_ne_zero r)
  have hpq : r.num.eval (τ * a) ≠ 0 ∨ r.denom.eval (τ * a) ≠ 0 :=
    ((RatFunc.isCoprime_num_denom r).map
      (Polynomial.evalRingHom (τ * a))).ne_zero_or_ne_zero
  rw [he, regularAt_fraction_iff _ _ _ hq (by simpa using hpq),
    eval_polyScale, regularAt_iff_denom]

def laurentScaleFun (τ : K) (f : LaurentSeries K) : LaurentSeries K where
  coeff j := τ ^ j * f.coeff j
  isPWO_support' := f.isPWO_support.mono (by
    intro j hj
    exact (mul_ne_zero_iff.mp hj).2)

@[simp] theorem laurentScale_coeff (τ : K) (f : LaurentSeries K) (j : ℤ) :
    (laurentScaleFun τ f).coeff j = τ ^ j * f.coeff j := rfl

theorem laurentScale_support (τ : K) (hτ : τ ≠ 0) (f : LaurentSeries K) :
    (laurentScaleFun τ f).support = f.support := by
  ext j
  simp [HahnSeries.support, laurentScaleFun, Function.support, zpow_ne_zero _ hτ]

theorem laurentScale_mul (τ : K) (hτ : τ ≠ 0) (f g : LaurentSeries K) :
    laurentScaleFun τ (f * g) =
      laurentScaleFun τ f * laurentScaleFun τ g := by
  apply HahnSeries.ext
  funext j
  simp only [laurentScale_coeff, HahnSeries.coeff_mul]
  simp only [laurentScale_support τ hτ]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro p hp
  have hj := (Finset.mem_addAntidiagonal.mp hp).2.2
  rw [← hj, zpow_add₀ hτ]
  ring

def laurentScale (τ : K) (hτ : τ ≠ 0) : LaurentSeries K →+* LaurentSeries K where
  toFun := laurentScaleFun τ
  map_zero' := by
    apply HahnSeries.ext
    funext j
    simp
  map_one' := by
    apply HahnSeries.ext
    funext j
    by_cases hj : j = 0 <;> simp [HahnSeries.coeff_one, hj]
  map_add' f g := by
    apply HahnSeries.ext
    funext j
    simp [mul_add]
  map_mul' := laurentScale_mul τ hτ

theorem laurent_fixed (τ : K) (hτ : τ ≠ 0)
    (hinf : ∀ j : ℤ, j ≠ 0 → τ ^ j ≠ 1) (f : LaurentSeries K) :
    laurentScale τ hτ f = f ↔
      f = HahnSeries.single 0 (f.coeff 0) := by
  constructor
  · intro hf
    apply HahnSeries.ext
    funext j
    by_cases hj : j = 0
    · subst j
      simp
    · have he := congrArg (fun g : LaurentSeries K => g.coeff j) hf
      change τ ^ j * f.coeff j = f.coeff j at he
      have hz : f.coeff j = 0 := by
        have : (τ ^ j - 1) * f.coeff j = 0 := by linear_combination he
        exact (mul_eq_zero.mp this).resolve_left (sub_ne_zero.mpr (hinf j hj))
      simp [hj, hz]
  · intro hf
    apply HahnSeries.ext
    funext j
    by_cases hj : j = 0
    · subst j
      simp [laurentScale]
    · have hz : f.coeff j = 0 := by
        rw [hf]
        simp [hj]
      simp [laurentScale, hz]

def expansion : RatFunc K →+* LaurentSeries K := algebraMap _ _

def seriesExpansion : PowerSeries K →+* LaurentSeries K :=
  HahnSeries.ofPowerSeries ℤ K

@[simp] theorem expansion_poly (p : K[X]) :
    expansion (algebraMap K[X] (RatFunc K) p) =
      seriesExpansion (algebraMap K[X] (PowerSeries K) p) :=
  (RatFunc.coe_coe p).symm

@[simp] theorem expansion_constant (c : K) :
    expansion (algebraMap K (RatFunc K) c) = HahnSeries.single 0 c := by
  simp only [RatFunc.algebraMap_eq_C]
  rw [← RatFunc.algebraMap_C, expansion_poly]
  change seriesExpansion (Polynomial.C c : PowerSeries K) = _
  rw [Polynomial.coe_C]
  apply HahnSeries.ext
  funext j
  simp [seriesExpansion]

@[simp] theorem rescale_constant (τ c : K) :
    PowerSeries.rescale τ (PowerSeries.C c) = PowerSeries.C c := by
  ext r
  cases r <;> simp [PowerSeries.coeff_rescale]

@[simp] theorem polynomialSeries_C (c : K) :
    algebraMap K[X] (PowerSeries K) (Polynomial.C c) = PowerSeries.C c :=
  Polynomial.coe_C c

@[simp] theorem polynomialSeries_X :
    algebraMap K[X] (PowerSeries K) Polynomial.X = PowerSeries.X :=
  Polynomial.coe_X

theorem polyScale_series (τ : K) (p : K[X]) :
    algebraMap K[X] (PowerSeries K) (polyScale τ p) =
      PowerSeries.rescale τ (algebraMap K[X] (PowerSeries K) p) := by
  change (polyScale τ p : PowerSeries K) = PowerSeries.rescale τ (p : PowerSeries K)
  ext r
  rw [PowerSeries.coeff_rescale]
  simp only [Polynomial.coeff_coe, polyScale, Polynomial.coe_compRingHom,
    Polynomial.comp_C_mul_X_coeff]
  exact mul_comm _ _

theorem laurentScale_series (τ : K) (hτ : τ ≠ 0) (f : PowerSeries K) :
    laurentScale τ hτ (seriesExpansion f) =
      seriesExpansion (PowerSeries.rescale τ f) := by
  apply HahnSeries.ext
  funext j
  change τ ^ j * ((HahnSeries.ofPowerSeries ℤ K) f).coeff j = _
  by_cases hj : j < 0
  · simp [seriesExpansion, PowerSeries.coeff_coe, hj]
  · simp only [seriesExpansion, PowerSeries.coeff_coe, if_neg hj,
      PowerSeries.coeff_rescale]
    have he : (j.natAbs : ℤ) = j := Int.natAbs_of_nonneg (by omega)
    have hp : τ ^ j = τ ^ j.natAbs := by
      calc
        τ ^ j = τ ^ (j.natAbs : ℤ) := congrArg (fun r : ℤ => τ ^ r) he.symm
        _ = _ := zpow_natCast _ _
    rw [hp]

theorem laurentScale_expansion (τ : K) (hτ : τ ≠ 0) (r : RatFunc K) :
    laurentScale τ hτ (expansion r) = expansion (rationalScale τ hτ r) := by
  have he (p q : K[X]) :
      laurentScale τ hτ
          (expansion (algebraMap K[X] (RatFunc K) p /
            algebraMap K[X] (RatFunc K) q)) =
        expansion (rationalScale τ hτ
          (algebraMap K[X] (RatFunc K) p / algebraMap K[X] (RatFunc K) q)) := by
    simp only [map_div₀, expansion_poly, rationalScale_poly,
      laurentScale_series, polyScale_series]
  simpa only [RatFunc.num_div_denom] using he r.num r.denom

theorem laurentScale_inverse (τ : K) (hτ : τ ≠ 0) (f : LaurentSeries K) :
    laurentScale τ⁻¹ (inv_ne_zero hτ) (laurentScale τ hτ f) = f := by
  apply HahnSeries.ext
  funext j
  change (τ⁻¹) ^ j * (τ ^ j * f.coeff j) = f.coeff j
  rw [← mul_assoc, ← mul_zpow, inv_mul_cancel₀ hτ, one_zpow, one_mul]

theorem rationalScale_inverse (τ : K) (hτ : τ ≠ 0) (r : RatFunc K) :
    rationalScale τ⁻¹ (inv_ne_zero hτ) (rationalScale τ hτ r) = r := by
  apply (expansion (K := K)).injective
  rw [← laurentScale_expansion, ← laurentScale_expansion, laurentScale_inverse]

theorem rational_fixed (τ : K) (hτ : τ ≠ 0)
    (hinf : ∀ j : ℤ, j ≠ 0 → τ ^ j ≠ 1) (r : RatFunc K)
    (hr : rationalScale τ hτ r = r) :
    ∃ c : K, algebraMap K (RatFunc K) c = r := by
  have he : laurentScale τ hτ (expansion r) = expansion r := by
    rw [laurentScale_expansion, hr]
  have hf := (laurent_fixed τ hτ hinf (expansion r)).mp he
  refine ⟨(expansion r).coeff 0, ?_⟩
  apply (expansion (K := K)).injective
  rw [expansion_constant]
  exact hf.symm

theorem regularAt_sub {r s : RatFunc K} {a : K}
    (hr : RegularAt r a) (hs : RegularAt s a) : RegularAt (r - s) a := by
  simpa only [sub_eq_add_neg] using regularAt_add hr (regularAt_neg hs)

theorem regularAt_constant_mul_iff (c : K) (hc : c ≠ 0)
    (r : RatFunc K) (a : K) :
    RegularAt (algebraMap K (RatFunc K) c * r) a ↔ RegularAt r a := by
  constructor
  · intro h
    have := regularAt_mul (regularAt_constant a c⁻¹) h
    have hc' : algebraMap K (RatFunc K) c ≠ 0 :=
      (map_ne_zero_iff _ (algebraMap K (RatFunc K)).injective).mpr hc
    simpa only [map_inv₀, ← mul_assoc, inv_mul_cancel₀ hc', one_mul] using this
  · exact regularAt_mul (regularAt_constant a c)

theorem no_isolated_difference_pole (τ : K) (hτ : τ ≠ 0)
    (x : ℤ → K) (hx : Function.Injective x)
    (hxs : ∀ j, τ * x j = x (j + 1)) (r : RatFunc K)
    (hpole : ¬RegularAt (rationalScale τ hτ r - r) (x 0))
    (hregular : ∀ j : ℤ, j ≠ 0 →
      RegularAt (rationalScale τ hτ r - r) (x j)) : False := by
  classical
  let S : Set ℤ := {j | ¬RegularAt r (x j)}
  have hS : S.Finite := by
    have hf := (Polynomial.finite_setOf_isRoot (RatFunc.denom_ne_zero r)).preimage
      hx.injOn
    simpa [S, regularAt_iff_denom, Polynomial.IsRoot] using hf
  have hs : S.Nonempty := by
    by_cases h0 : RegularAt r (x 0)
    · refine ⟨1, ?_⟩
      intro h1
      apply hpole
      apply regularAt_sub ?_ h0
      rw [regularAt_scale_iff, hxs]
      exact h1
    · exact ⟨0, h0⟩
  let s := hS.toFinset
  have hs' : s.Nonempty := by simpa [s] using hs
  let lo := s.min' hs'
  let hi := s.max' hs'
  have hlo : ¬RegularAt r (x lo) := by
    exact (hS.mem_toFinset).mp (Finset.min'_mem s hs')
  have hhi : ¬RegularAt r (x hi) := by
    exact (hS.mem_toFinset).mp (Finset.max'_mem s hs')
  have hbefore : RegularAt r (x (lo - 1)) := by
    by_contra hh
    have hm : lo - 1 ∈ s := hS.mem_toFinset.mpr hh
    have := Finset.min'_le s (lo - 1) hm
    dsimp [lo] at *
    omega
  have hafter : RegularAt r (x (hi + 1)) := by
    by_contra hh
    have hm : hi + 1 ∈ s := hS.mem_toFinset.mpr hh
    have := Finset.le_max' s (hi + 1) hm
    dsimp [hi] at *
    omega
  have hlo0 : lo - 1 = 0 := by
    by_contra hh
    have hg := regularAt_add (hregular (lo - 1) hh) hbefore
    have hσ : RegularAt (rationalScale τ hτ r) (x (lo - 1)) := by
      simpa only [sub_add_cancel] using hg
    rw [regularAt_scale_iff, hxs] at hσ
    exact hlo (by simpa using hσ)
  have hhi0 : hi = 0 := by
    by_contra hh
    have hσ : RegularAt (rationalScale τ hτ r) (x hi) := by
      rw [regularAt_scale_iff, hxs]
      exact hafter
    have hg := regularAt_sub hσ (hregular hi hh)
    apply hhi
    convert hg using 1
    ring
  have hle : lo ≤ hi := Finset.min'_le s hi (Finset.max'_mem s hs')
  omega

section TranscendentalParameter

variable {F : Type*} [Field F]

def parameter : RatFunc F := RatFunc.X

theorem parameter_ne_zero : parameter (F := F) ≠ 0 := by
  exact (map_ne_zero_iff _ (RatFunc.algebraMap_injective F)).mpr Polynomial.X_ne_zero

theorem one_add_parameter_ne_zero : 1 + parameter (F := F) ≠ 0 := by
  have hp : (1 + Polynomial.X : F[X]) ≠ 0 := by
    intro he
    have := congrArg (Polynomial.eval (0 : F)) he
    simpa using this
  simpa [parameter] using
    (map_ne_zero_iff _ (RatFunc.algebraMap_injective F)).mpr hp

theorem parameter_nat_pow_ne_one (r : ℕ) (hr : r ≠ 0) :
    parameter (F := F) ^ r ≠ 1 := by
  intro he
  have hp : (Polynomial.X : F[X]) ^ r = 1 :=
    RatFunc.algebraMap_injective F (by simpa [parameter] using he)
  have hd := congrArg Polynomial.natDegree hp
  simp at hd
  exact hr hd

theorem parameter_zpow_ne_one (r : ℤ) (hr : r ≠ 0) :
    parameter (F := F) ^ r ≠ 1 := by
  cases r with
  | ofNat m =>
      exact parameter_nat_pow_ne_one m (by intro hm; exact hr (by simp [hm]))
  | negSucc m =>
      intro he
      rw [zpow_negSucc] at he
      have he' : parameter (F := F) ^ (m + 1) = 1 := by
        simpa using congrArg (fun x : RatFunc F => x⁻¹) he
      exact parameter_nat_pow_ne_one (m + 1) (by omega) he'

theorem parameter_power_separation (r i k : ℕ)
    (he : parameter (F := F) ^ r * (1 + parameter) ^ i =
      (1 + parameter) ^ k) : r = 0 ∧ i = k := by
  have hp : (Polynomial.X : F[X]) ^ r * (1 + Polynomial.X) ^ i =
      (1 + Polynomial.X) ^ k :=
    RatFunc.algebraMap_injective F (by simpa [parameter] using he)
  have hr : r = 0 := by
    by_contra hr
    have hz := congrArg (Polynomial.eval (0 : F)) hp
    simpa [hr] using hz
  subst r
  refine ⟨rfl, ?_⟩
  have hd := congrArg Polynomial.natDegree hp
  have hdeg : (1 + Polynomial.X : F[X]).natDegree = 1 := by
    simpa [add_comm] using Polynomial.natDegree_X_add_C (1 : F)
  simpa only [pow_zero, one_mul, Polynomial.natDegree_pow, hdeg, mul_one] using hd

def alpha (i : ℕ) : RatFunc F := ((1 + parameter) ^ (i + 1))⁻¹

def orbit (i : ℕ) (j : ℤ) : RatFunc F := parameter ^ j * alpha i

theorem alpha_ne_zero (i : ℕ) : alpha (F := F) i ≠ 0 :=
  inv_ne_zero (pow_ne_zero _ one_add_parameter_ne_zero)

theorem orbit_ne_zero (i : ℕ) (j : ℤ) : orbit (F := F) i j ≠ 0 :=
  mul_ne_zero (zpow_ne_zero _ parameter_ne_zero) (alpha_ne_zero i)

theorem orbit_meets_alpha (i k : ℕ) (j : ℤ)
    (he : orbit (F := F) i j = alpha k) : j = 0 ∧ i = k := by
  have hi : (1 + parameter (F := F)) ^ (i + 1) ≠ 0 :=
    pow_ne_zero _ one_add_parameter_ne_zero
  have hk : (1 + parameter (F := F)) ^ (k + 1) ≠ 0 :=
    pow_ne_zero _ one_add_parameter_ne_zero
  cases j with
  | ofNat m =>
      have hm : parameter (F := F) ^ m * (1 + parameter) ^ (k + 1) =
          (1 + parameter) ^ (i + 1) := by
        have he' : parameter (F := F) ^ m / (1 + parameter) ^ (i + 1) =
            1 / (1 + parameter) ^ (k + 1) := by
          simpa [orbit, alpha, div_eq_mul_inv] using he
        simpa using (div_eq_div_iff hi hk).mp he'
      obtain ⟨hm0, hki⟩ := parameter_power_separation m (k + 1) (i + 1) hm
      exact ⟨by simp [hm0], by omega⟩
  | negSucc m =>
      have hm : parameter (F := F) ^ (m + 1) * (1 + parameter) ^ (i + 1) =
          (1 + parameter) ^ (k + 1) := by
        have ht : parameter (F := F) ^ (m + 1) ≠ 0 :=
          pow_ne_zero _ parameter_ne_zero
        dsimp [orbit, alpha] at he
        rw [zpow_negSucc] at he
        field_simp at he
        linear_combination -he
      have := (parameter_power_separation (m + 1) (i + 1) (k + 1) hm).1
      omega

theorem orbit_injective (i : ℕ) : Function.Injective (orbit (F := F) i) := by
  intro j k he
  have hp : parameter (F := F) ^ j = parameter ^ k :=
    mul_right_cancel₀ (alpha_ne_zero i) he
  by_contra hjk
  apply parameter_zpow_ne_one (F := F) (j - k) (sub_ne_zero.mpr hjk)
  rw [zpow_sub₀ (parameter_ne_zero (F := F)), hp,
    div_self (zpow_ne_zero _ (parameter_ne_zero (F := F)))]

theorem orbit_succ (i : ℕ) (j : ℤ) :
    parameter (F := F) * orbit i j = orbit i (j + 1) := by
  simp only [orbit, zpow_add₀ (parameter_ne_zero (F := F)), zpow_one]
  ring

def letterRat (i : ℕ) : RatFunc (RatFunc F) :=
  algebraMap (RatFunc F)[X] (RatFunc (RatFunc F)) Polynomial.X /
    algebraMap (RatFunc F)[X] (RatFunc (RatFunc F))
      (1 - Polynomial.C ((1 + parameter) ^ (i + 1)) * Polynomial.X)

theorem letterRat_regular (i : ℕ) (x : RatFunc F) (hx : x ≠ 0) :
    RegularAt (letterRat i) x ↔ x ≠ alpha i := by
  have hq : (1 - Polynomial.C ((1 + parameter (F := F)) ^ (i + 1)) *
      Polynomial.X) ≠ 0 := by
    intro he
    have := congrArg (Polynomial.eval (0 : RatFunc F)) he
    simpa using this
  rw [letterRat, regularAt_fraction_iff _ _ _ hq (by simpa using Or.inl hx)]
  simp only [Polynomial.eval_sub, Polynomial.eval_one, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X]
  have ha : (1 + parameter (F := F)) ^ (i + 1) ≠ 0 :=
    pow_ne_zero _ one_add_parameter_ne_zero
  constructor
  · intro h he
    subst x
    exact h (by simp [alpha, ha])
  · intro h he
    apply h
    apply mul_left_cancel₀ ha
    rw [alpha, mul_inv_cancel₀ ha]
    linear_combination -he

theorem word_pole_obstruction (n : ℕ) (c : Fin n → RatFunc F)
    (r : RatFunc (RatFunc F))
    (he : ∑ i, algebraMap (RatFunc F) (RatFunc (RatFunc F)) (c i) * letterRat i.val =
      rationalScale parameter parameter_ne_zero r - r) :
    ∀ i, c i = 0 := by
  classical
  intro i
  by_contra hci
  let g : RatFunc (RatFunc F) :=
    ∑ k : Fin n, algebraMap (RatFunc F) (RatFunc (RatFunc F)) (c k) * letterRat k.val
  have hother (j : ℤ) (k : Fin n) (hk : j ≠ 0 ∨ k ≠ i) :
      RegularAt (letterRat (F := F) k.val) (orbit i.val j) := by
    rw [letterRat_regular _ _ (orbit_ne_zero _ _)]
    intro hh
    obtain ⟨hj, hki⟩ := orbit_meets_alpha i.val k.val j hh
    rcases hk with hk | hk
    · exact hk hj
    · exact hk (Fin.ext hki.symm)
  have hg (j : ℤ) (hj : j ≠ 0) : RegularAt g (orbit i.val j) := by
    exact regularAt_sum Finset.univ _ _ (fun k _ =>
      regularAt_mul (regularAt_constant _ (c k)) (hother j k (Or.inl hj)))
  have hgpole : ¬RegularAt g (orbit i.val 0) := by
    intro hreg
    have hrest : RegularAt
        (∑ k ∈ Finset.univ.erase i,
          algebraMap (RatFunc F) (RatFunc (RatFunc F)) (c k) * letterRat k.val)
        (orbit i.val 0) := by
      apply regularAt_sum
      intro k hk
      exact regularAt_mul (regularAt_constant _ (c k))
        (hother 0 k (Or.inr (Finset.ne_of_mem_erase hk)))
    have hterm : RegularAt
        (algebraMap (RatFunc F) (RatFunc (RatFunc F)) (c i) * letterRat i.val)
        (orbit i.val 0) := by
      have hs := Finset.sum_erase_add (s := Finset.univ)
        (fun k : Fin n =>
          algebraMap (RatFunc F) (RatFunc (RatFunc F)) (c k) * letterRat k.val)
        (Finset.mem_univ i)
      have hh := regularAt_sub hreg hrest
      convert hh using 1
      dsimp [g]
      simp only [RatFunc.algebraMap_eq_C] at hs ⊢
      linear_combination hs
    have hi := (regularAt_constant_mul_iff (c i) hci _ _).mp hterm
    rw [letterRat_regular _ _ (orbit_ne_zero _ _)] at hi
    exact hi (by simp [orbit])
  apply no_isolated_difference_pole parameter parameter_ne_zero
    (orbit i.val) (orbit_injective i.val) (orbit_succ i.val) r
  · simpa only [← he] using hgpole
  · intro j hj
    simpa only [← he] using hg j hj

def letterSeries (i : ℕ) : PowerSeries (RatFunc F) :=
  PowerSeries.X *
    (1 - PowerSeries.C ((1 + parameter) ^ (i + 1)) * PowerSeries.X)⁻¹

@[simp] theorem letterSeries_constant (i : ℕ) :
    PowerSeries.constantCoeff (letterSeries (F := F) i) = 0 := by
  simp [letterSeries]

theorem letterSeries_denominator (i : ℕ) :
    letterSeries (F := F) i *
        (1 - PowerSeries.C ((1 + parameter) ^ (i + 1)) * PowerSeries.X) =
      PowerSeries.X := by
  let d : PowerSeries (RatFunc F) :=
    1 - PowerSeries.C ((1 + parameter) ^ (i + 1)) * PowerSeries.X
  have hd : PowerSeries.constantCoeff d ≠ 0 := by simp [d]
  have hi := PowerSeries.mul_inv_cancel d hd
  dsimp [letterSeries]
  change PowerSeries.X * d⁻¹ * d = PowerSeries.X
  calc
    _ = PowerSeries.X * (d * d⁻¹) := by ring
    _ = _ := by rw [hi, mul_one]

theorem letterSeries_expansion (i : ℕ) :
    expansion (letterRat (F := F) i) = seriesExpansion (letterSeries i) := by
  rw [letterRat, map_div₀, expansion_poly, expansion_poly]
  simp only [map_sub, map_one, map_mul, polynomialSeries_C, polynomialSeries_X]
  let d : PowerSeries (RatFunc F) :=
    1 - PowerSeries.C ((1 + parameter) ^ (i + 1)) * PowerSeries.X
  have hd : seriesExpansion d ≠ 0 := by
    intro hh
    have h0 := congrArg (fun f : LaurentSeries (RatFunc F) => f.coeff 0) hh
    change ((HahnSeries.ofPowerSeries ℤ (RatFunc F)) d).coeff 0 = 0 at h0
    rw [PowerSeries.coeff_coe] at h0
    simpa [PowerSeries.coeff_zero_eq_constantCoeff, d] using h0
  rw [div_eq_iff (by simpa only [d, map_sub, map_one, map_mul] using hd)]
  have hm := congrArg (seriesExpansion (K := RatFunc F)) (letterSeries_denominator i)
  simpa only [map_mul, map_sub, map_one] using hm.symm

def integrate (i : ℕ) (g : PowerSeries (RatFunc F)) : PowerSeries (RatFunc F) :=
  PowerSeries.mk (fun r => if r = 0 then 0 else
    PowerSeries.coeff r (letterSeries i * g) / (parameter ^ r - 1))

@[simp] theorem integrate_constant (i : ℕ) (g : PowerSeries (RatFunc F)) :
    PowerSeries.constantCoeff (integrate i g) = 0 := by
  simp [integrate]

@[simp] theorem rescale_constantCoeff (τ : K) (f : PowerSeries K) :
    PowerSeries.constantCoeff (PowerSeries.rescale τ f) =
      PowerSeries.constantCoeff f := by
  simp [← PowerSeries.coeff_zero_eq_constantCoeff, PowerSeries.coeff_rescale]

theorem integrate_equation (i : ℕ) (g : PowerSeries (RatFunc F)) :
    PowerSeries.rescale parameter (integrate i g) - integrate i g =
      letterSeries i * g := by
  ext r
  by_cases hr : r = 0
  · subst r
    simp [PowerSeries.coeff_zero_eq_constantCoeff, letterSeries]
  · have hd : parameter (F := F) ^ r - 1 ≠ 0 :=
      sub_ne_zero.mpr (parameter_nat_pow_ne_one r hr)
    simp only [map_sub, PowerSeries.coeff_rescale, integrate,
      PowerSeries.coeff_mk, if_neg hr]
    field_simp

theorem integrate_unique (i : ℕ) (g h : PowerSeries (RatFunc F))
    (h0 : PowerSeries.constantCoeff h = 0)
    (he : PowerSeries.rescale parameter h - h = letterSeries i * g) :
    h = integrate i g := by
  ext r
  by_cases hr : r = 0
  · subst r
    simpa only [PowerSeries.coeff_zero_eq_constantCoeff, integrate_constant] using h0
  · have hd : parameter (F := F) ^ r - 1 ≠ 0 :=
      sub_ne_zero.mpr (parameter_nat_pow_ne_one r hr)
    simp only [integrate, PowerSeries.coeff_mk, if_neg hr]
    apply (eq_div_iff hd).mpr
    have hc := congrArg (PowerSeries.coeff r) he
    simp only [map_sub, PowerSeries.coeff_rescale] at hc
    linear_combination hc

theorem integrate_add (i : ℕ) (g h : PowerSeries (RatFunc F)) :
    integrate i (g + h) = integrate i g + integrate i h := by
  ext r
  by_cases hr : r = 0 <;>
    simp [integrate, hr, mul_add, add_div]

theorem integrate_smul (i : ℕ) (c : RatFunc F) (g : PowerSeries (RatFunc F)) :
    integrate i (c • g) = c • integrate i g := by
  ext r
  by_cases hr : r = 0 <;>
    simp [integrate, hr, smul_eq_mul, mul_div_assoc]

theorem integrate_raises (i j : ℕ) (g : PowerSeries (RatFunc F))
    (hg : ∀ r < j, PowerSeries.coeff r g = 0) :
    ∀ r < j + 1, PowerSeries.coeff r (integrate i g) = 0 := by
  intro r hr
  by_cases hr0 : r = 0
  · simp [integrate, hr0]
  have hc : PowerSeries.coeff r (letterSeries i * g) = 0 := by
    rw [PowerSeries.coeff_mul]
    apply Finset.sum_eq_zero
    intro p hp
    have hp' := Finset.mem_antidiagonal.mp hp
    by_cases h0 : p.1 = 0
    · simp [h0, PowerSeries.coeff_zero_eq_constantCoeff]
    · rw [hg p.2 (by omega), mul_zero]
  simp [integrate, hr0, hc]

def wordSeries {n : ℕ} : List (Fin n) → PowerSeries (RatFunc F)
  | [] => 1
  | i :: w => integrate i.val (wordSeries w)

@[simp] theorem wordSeries_nil (n : ℕ) :
    wordSeries (F := F) ([] : List (Fin n)) = 1 := rfl

theorem wordSeries_equation {n : ℕ} (i : Fin n) (w : List (Fin n)) :
    PowerSeries.rescale parameter (wordSeries (F := F) (i :: w)) =
      wordSeries (i :: w) + letterSeries i.val * wordSeries w := by
  have he := integrate_equation i.val (wordSeries (F := F) w)
  simpa only [wordSeries, add_comm] using sub_eq_iff_eq_add.mp he

end TranscendentalParameter

section FiniteWords

variable (A : Type*) [Fintype A] [DecidableEq A]

def words : ℕ → Finset (List A)
  | 0 => {[]}
  | m + 1 => insert [] (Finset.univ.biUnion (fun a => (words m).image (List.cons a)))

@[simp] theorem mem_words (m : ℕ) (w : List A) :
    w ∈ words A m ↔ w.length ≤ m := by
  induction m generalizing w with
  | zero => simp [words]
  | succ m ih =>
      cases w with
      | nil => simp [words]
      | cons a w => simp [words, ih]

theorem words_mono {m M : ℕ} (hm : m ≤ M) : words A m ⊆ words A M := by
  intro w hw
  exact (mem_words A M w).mpr (le_trans ((mem_words A m w).mp hw) hm)

theorem sum_words_succ {B : Type*} [AddCommMonoid B] (m : ℕ) (f : List A → B) :
    ∑ w ∈ words A (m + 1), f w =
      f [] + ∑ a : A, ∑ w ∈ words A m, f (a :: w) := by
  rw [words, Finset.sum_insert (by simp)]
  congr 1
  rw [Finset.sum_biUnion]
  · apply Finset.sum_congr rfl
    intro a _
    rw [Finset.sum_image]
    exact fun _ _ _ _ he => List.cons_injective he
  · intro a _ b _ hab
    apply Finset.disjoint_left.mpr
    intro w hwa hwb
    obtain ⟨u, _, hu⟩ := Finset.mem_image.mp hwa
    obtain ⟨v, _, hv⟩ := Finset.mem_image.mp hwb
    exact hab (List.cons.inj (hu.trans hv.symm)).1

theorem sum_drop_head {B : Type*} [AddCommMonoid B]
    (m : ℕ) (f : A → List A → B)
    (hf : ∀ a w, m ≤ w.length → f a w = 0) :
    (∑ w ∈ words A m, match w with | [] => 0 | a :: v => f a v) =
      ∑ w ∈ words A m, ∑ a : A, f a w := by
  cases m with
  | zero =>
      simp [words, hf]
  | succ m =>
      rw [sum_words_succ]
      simp only [zero_add]
      rw [Finset.sum_comm]
      apply Finset.sum_subset (words_mono A (Nat.le_succ m))
      intro w hw hnot
      apply Finset.sum_eq_zero
      intro a _
      apply hf
      have hlen := (mem_words A (m + 1) w).mp hw
      have hn : ¬w.length ≤ m := by simpa using hnot
      omega

end FiniteWords

section DifferenceCriterion

variable {A E L : Type*} [Fintype A] [DecidableEq A] [Field E] [Field L]

def wordDelta (s : E →+* E) (b : A → E) (R : List A → E) (w : List A) : E :=
  s (R w) - R w + ∑ a : A, b a * s (R (a :: w))

omit [DecidableEq A] in
theorem wordDelta_bound (s : E →+* E) (b : A → E) (m : ℕ) (R : List A → E)
    (hR : ∀ w, m < w.length → R w = 0) :
    ∀ w, m < w.length → wordDelta s b R w = 0 := by
  intro w hw
  simp [wordDelta, hR w hw, hR (w := _ :: w) (by simp; omega)]

omit [DecidableEq A] in
theorem wordDelta_top (s : E →+* E) (b : A → E) (m : ℕ) (R : List A → E)
    (hR : ∀ w, m < w.length → R w = 0) (w : List A) (hw : w.length = m) :
    wordDelta s b R w = s (R w) - R w := by
  have hp (a : A) : R (a :: w) = 0 := hR _ (by simp [hw])
  simp [wordDelta, hp]

theorem wordDelta_relation
    (e : E →+* L) (s : E →+* E) (S : L →+* L)
    (hcompat : ∀ r, S (e r) = e (s r))
    (b : A → E) (h : List A → L)
    (hnil : h [] = 1)
    (hcons : ∀ a w, S (h (a :: w)) = h (a :: w) + e (b a) * h w)
    (m : ℕ) (R : List A → E)
    (hR : ∀ w, m < w.length → R w = 0)
    (hrel : ∑ w ∈ words A m, e (R w) * h w = 0) :
    ∑ w ∈ words A m, e (wordDelta s b R w) * h w = 0 := by
  let tail : List A → L := fun w =>
    match w with | [] => 0 | a :: v => e (b a) * h v
  have hshift (w : List A) : S (h w) = h w + tail w := by
    cases w with
    | nil => simp [hnil, tail]
    | cons a w => exact hcons a w
  have hsum :
      (∑ w ∈ words A m, e (s (R w)) * tail w) =
        ∑ w ∈ words A m, ∑ a : A, e (b a * s (R (a :: w))) * h w := by
    have he := sum_drop_head A m
      (fun a w => e (b a * s (R (a :: w))) * h w)
      (by intro a w hw; simp [hR (a :: w) (by simp; omega)])
    rw [← he]
    apply Finset.sum_congr rfl
    intro w _
    cases w with
    | nil => simp [tail]
    | cons a w => simp only [tail, map_mul]; ring
  have hshiftrel :
      ∑ w ∈ words A m, e (s (R w)) * (h w + tail w) = 0 := by
    have hh := congrArg S hrel
    simpa only [map_sum, map_mul, hcompat, hshift, map_zero] using hh
  calc
    (∑ w ∈ words A m, e (wordDelta s b R w) * h w) =
        ((∑ w ∈ words A m, e (s (R w)) * h w) -
          ∑ w ∈ words A m, e (R w) * h w) +
            ∑ w ∈ words A m, ∑ a : A, e (b a * s (R (a :: w))) * h w := by
      simp only [wordDelta, map_add, map_sub, map_sum, add_mul, sub_mul,
        Finset.sum_add_distrib, Finset.sum_sub_distrib, Finset.sum_mul]
    _ = (∑ w ∈ words A m, e (s (R w)) * (h w + tail w)) -
          ∑ w ∈ words A m, e (R w) * h w := by
      rw [← hsum]
      simp only [mul_add, Finset.sum_add_distrib]
      ring
    _ = 0 := by rw [hshiftrel, hrel, sub_self]

def topSupport (m : ℕ) (R : List A → E) : Finset (List A) := by
  classical
  exact (words A m).filter (fun w => w.length = m ∧ R w ≠ 0)

@[simp] theorem mem_topSupport (m : ℕ) (R : List A → E) (w : List A) :
    w ∈ topSupport m R ↔ w.length = m ∧ R w ≠ 0 := by
  classical
  simp only [topSupport, Finset.mem_filter, mem_words]
  constructor
  · exact fun h => h.2
  · rintro ⟨hl, hn⟩
    exact ⟨by omega, hl, hn⟩

theorem difference_word_independent
    (e : E →+* L) (κ : K →+* E) (s : E →+* E) (S : L →+* L)
    (hcompat : ∀ r, S (e r) = e (s r))
    (hfixed : ∀ r, s r = r → ∃ c : K, κ c = r)
    (b : A → E)
    (hpoles : ∀ (c : A → K) (r : E),
      (∑ a, κ (c a) * b a) = s r - r → ∀ a, c a = 0)
    (h : List A → L) (hnil : h [] = 1)
    (hcons : ∀ a w, S (h (a :: w)) = h (a :: w) + e (b a) * h w) :
    ∀ (m : ℕ) (R : List A → E),
      (∀ w, m < w.length → R w = 0) →
      (∑ w ∈ words A m, e (R w) * h w) = 0 → ∀ w, R w = 0 := by
  classical
  intro m
  induction m with
  | zero =>
      intro R hR hrel w
      have h0 : R [] = 0 := by
        have he : e (R []) = 0 := by simpa [words, hnil] using hrel
        exact e.injective (by simpa using he)
      cases w with
      | nil => exact h0
      | cons a w => exact hR _ (by simp)
  | succ m ihm =>
      have inner : ∀ k (R : List A → E),
          (topSupport (m + 1) R).card = k →
          (∀ w, m + 1 < w.length → R w = 0) →
          (∑ w ∈ words A (m + 1), e (R w) * h w) = 0 → ∀ w, R w = 0 := by
        intro k
        induction k using Nat.strong_induction_on with
        | h k ih =>
          intro R hk hR hrel
          by_cases htop : (topSupport (m + 1) R).Nonempty
          · obtain ⟨w₀, hw₀⟩ := htop
            have hw₀' := (mem_topSupport _ _ _).mp hw₀
            have hlen : w₀.length = m + 1 := hw₀'.1
            have hnonzero : R w₀ ≠ 0 := hw₀'.2
            let T : List A → E := fun w => R w / R w₀
            have hT : ∀ w, m + 1 < w.length → T w = 0 := by
              intro w hw
              simp [T, hR w hw]
            have hT₀ : T w₀ = 1 := div_self hnonzero
            have hTrel : ∑ w ∈ words A (m + 1), e (T w) * h w = 0 := by
              calc
                _ = (∑ w ∈ words A (m + 1), e (R w) * h w) / e (R w₀) := by
                  simp only [T, map_div₀, Finset.sum_div]
                  apply Finset.sum_congr rfl
                  intro w _
                  ring
                _ = 0 := by rw [hrel, zero_div]
            let U := wordDelta s b T
            have hU : ∀ w, m + 1 < w.length → U w = 0 :=
              wordDelta_bound s b (m + 1) T hT
            have hUrel : ∑ w ∈ words A (m + 1), e (U w) * h w = 0 :=
              wordDelta_relation e s S hcompat b h hnil hcons (m + 1) T hT hTrel
            have htopU (w : List A) (hw : w.length = m + 1) :
                U w = s (T w) - T w :=
              wordDelta_top s b (m + 1) T hT w hw
            have hU₀ : U w₀ = 0 := by rw [htopU _ hlen, hT₀, map_one, sub_self]
            have hsub : topSupport (m + 1) U ⊆ topSupport (m + 1) R := by
              intro w hw
              obtain ⟨hwlen, hwU⟩ := (mem_topSupport _ _ _).mp hw
              apply (mem_topSupport _ _ _).mpr
              refine ⟨hwlen, ?_⟩
              intro hwR
              apply hwU
              rw [htopU _ hwlen]
              simp [T, hwR]
            have hstrict : topSupport (m + 1) U ⊂ topSupport (m + 1) R := by
              apply Finset.ssubset_iff_subset_ne.mpr
              refine ⟨hsub, ?_⟩
              intro he
              have hw : w₀ ∈ topSupport (m + 1) U := he.symm ▸ hw₀
              exact ((mem_topSupport _ _ _).mp hw).2 hU₀
            have hlt : (topSupport (m + 1) U).card < k := by
              rw [← hk]
              exact Finset.card_lt_card hstrict
            have hUz : ∀ w, U w = 0 :=
              ih _ hlt U rfl hU hUrel
            have hfixedT (w : List A) (hw : w.length = m + 1) : s (T w) = T w :=
              sub_eq_zero.mp (by simpa only [htopU w hw] using hUz w)
            cases w₀ with
            | nil => simp at hlen
            | cons a v =>
                have hv : v.length = m := by simpa using hlen
                choose c hc using (fun a' : A =>
                  hfixed (T (a' :: v)) (hfixedT _ (by simp [hv])))
                have hsum :
                    (∑ a', κ (c a') * b a') =
                      ∑ a', b a' * s (T (a' :: v)) := by
                  apply Finset.sum_congr rfl
                  intro a' _
                  rw [hc, hfixedT _ (by simp [hv])]
                  ring
                have hcz : ∀ a', c a' = 0 := hpoles c (-T v) (by
                  rw [hsum, map_neg]
                  have hu := hUz v
                  change s (T v) - T v + ∑ a', b a' * s (T (a' :: v)) = 0 at hu
                  linear_combination hu)
                have htzero : T (a :: v) = 0 := by rw [← hc a, hcz a, map_zero]
                rw [hT₀] at htzero
                exact (one_ne_zero htzero).elim
          · have htop0 : topSupport (m + 1) R = ∅ := Finset.not_nonempty_iff_eq_empty.mp htop
            have hRm : ∀ w, m < w.length → R w = 0 := by
              intro w hw
              by_cases hlen : m + 1 < w.length
              · exact hR w hlen
              · by_contra hn
                have hm : w ∈ topSupport (m + 1) R :=
                  (mem_topSupport _ _ _).mpr ⟨by omega, hn⟩
                simp [htop0] at hm
            apply ihm R hRm
            have he := Finset.sum_subset (words_mono A (Nat.le_succ m))
              (f := fun w => e (R w) * h w) (by
                intro w _ hw
                have hlen : m < w.length := by simpa using hw
                simp [hRm w hlen])
            rw [he, hrel]
      intro R hR hrel
      exact inner (topSupport (m + 1) R).card R rfl hR hrel

end DifferenceCriterion

section Instantiation

variable {F : Type*} [Field F]

theorem parameter_fixed_field (f : LaurentSeries (RatFunc F)) :
    laurentScale parameter parameter_ne_zero f = f ↔
      f = HahnSeries.single 0 (f.coeff 0) :=
  laurent_fixed parameter parameter_ne_zero parameter_zpow_ne_one f

theorem word_series_finite_relation (n : ℕ) (_hn : 1 ≤ n)
    (s : Finset (List (Fin n))) (R : List (Fin n) → RatFunc (RatFunc F))
    (hrel : ∑ w ∈ s, expansion (R w) * seriesExpansion (wordSeries (F := F) w) = 0) :
    ∀ w ∈ s, R w = 0 := by
  classical
  let m := s.sup List.length
  let T : List (Fin n) → RatFunc (RatFunc F) := fun w => if w ∈ s then R w else 0
  have hs : s ⊆ words (Fin n) m := by
    intro w hw
    exact (mem_words _ _ _).mpr (Finset.le_sup hw)
  have hT : ∀ w, m < w.length → T w = 0 := by
    intro w hw
    have hnot : w ∉ s := by
      intro hh
      have hlen : w.length ≤ m := Finset.le_sup hh
      omega
    simp [T, hnot]
  have hTrel :
      ∑ w ∈ words (Fin n) m,
        expansion (T w) * seriesExpansion (wordSeries (F := F) w) = 0 := by
    have he := Finset.sum_subset hs
      (f := fun w => expansion (T w) * seriesExpansion (wordSeries (F := F) w))
      (by intro w _ hw; simp [T, hw])
    rw [← he]
    calc
      _ = ∑ w ∈ s, expansion (R w) * seriesExpansion (wordSeries (F := F) w) := by
        apply Finset.sum_congr rfl
        intro w hw
        simp only [T, if_pos hw]
      _ = 0 := hrel
  have hcons (a : Fin n) (w : List (Fin n)) :
      laurentScale parameter parameter_ne_zero
          (seriesExpansion (wordSeries (F := F) (a :: w))) =
        seriesExpansion (wordSeries (a :: w)) +
          expansion (letterRat a.val) * seriesExpansion (wordSeries w) := by
    rw [laurentScale_series, wordSeries_equation, map_add, map_mul,
      ← letterSeries_expansion]
  have hz : ∀ w, T w = 0 :=
    difference_word_independent
      (K := RatFunc F) (E := RatFunc (RatFunc F)) (L := LaurentSeries (RatFunc F))
      expansion (algebraMap (RatFunc F) (RatFunc (RatFunc F)))
      (rationalScale parameter parameter_ne_zero)
      (laurentScale parameter parameter_ne_zero)
      (laurentScale_expansion parameter parameter_ne_zero)
      (rational_fixed parameter parameter_ne_zero parameter_zpow_ne_one)
      (fun a : Fin n => letterRat a.val) (word_pole_obstruction n)
      (fun w => seriesExpansion (wordSeries (F := F) w))
      (by simp) hcons m T hT hTrel
  intro w hw
  simpa only [T, if_pos hw] using hz w

theorem word_series_linearIndependent (n : ℕ) (hn : 1 ≤ n) :
    LinearIndependent (RatFunc (RatFunc F))
      (fun w : List (Fin n) => seriesExpansion (wordSeries (F := F) w)) := by
  rw [linearIndependent_iff']
  intro s R hrel
  apply word_series_finite_relation n hn s R
  simpa only [Algebra.smul_def, expansion] using hrel

#print axioms word_series_linearIndependent
#print axioms parameter_fixed_field
#print axioms word_pole_obstruction
#print axioms integrate_unique

end Instantiation

end WordIndependence
