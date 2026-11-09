import OAI.LinearAlgebra.CirculantHadamard.LocalComparison

namespace SharpCharacterComparison

open OAI.CirculantHadamard OAI.CirculantHadamard.CyclicRing
open OAI.CirculantHadamard.LocalComparison
open Polynomial

noncomputable section

universe uA uS

variable (A : Type uA) [CommRing A]

def root (p r : ℕ) : RamifiedLocal.Extension A p r :=
  AdjoinRoot.root (cyclotomic (p ^ (r + 1)) A)

theorem root_pow (p r d : ℕ) : root A p r ^ (p ^ (r + d + 1)) = 1 := by
  have h : root A p r ^ (p ^ (r + 1)) = 1 :=
    cyclotomicAdjoinRoot_pow (R := A) (p ^ (r + 1))
  calc
    root A p r ^ (p ^ (r + d + 1)) =
        root A p r ^ (p ^ (r + 1) * p ^ d) :=
      congrArg (fun n : ℕ => root A p r ^ n)
        (by rw [show r + d + 1 = (r + 1) + d by omega, pow_add])
    _ = (root A p r ^ (p ^ (r + 1))) ^ (p ^ d) := pow_mul _ _ _
    _ = 1 := by rw [h, one_pow]

def value (p r d : ℕ) [NeZero p] :
    Elem A (p ^ (r + d + 1)) →ₐ[A] RamifiedLocal.Extension A p r :=
  evaluateAt _ (root A p r) (root_pow A p r d)

@[simp] theorem value_scalar (p r d : ℕ) [NeZero p] (a : A) :
    value A p r d (scalar _ a) =
      algebraMap A (RamifiedLocal.Extension A p r) a :=
  (value A p r d).commutes a

theorem value_projection (p r d : ℕ) [NeZero p]
    (F : Elem A (p ^ (r + d + 2))) :
    value A p r d
        (cyclicProjection A (pow_dvd_pow p (Nat.le_succ (r + d + 1))) F) =
      value A p r (d + 1) F :=
  evaluateAt_cyclicProjection _ _ _ _ F

def Compared (p r d : ℕ) [NeZero p] (F : Elem A (p ^ (r + d + 1))) : Prop :=
  ∃ u : (RamifiedLocal.Extension A p r)ˣ,
    value A p r d F = (u : RamifiedLocal.Extension A p r) *
      algebraMap A (RamifiedLocal.Extension A p r) (augmentation _ F) ∧
    (u : RamifiedLocal.Extension A p r) - 1 ∈
      Ideal.span {RamifiedLocal.uniformizer A p r}

variable {A}

theorem projected_factor_at_valuation {p k s D : ℕ} [NeZero p] (hp : p.Prime)
    [IsDomain (AdjoinRoot (cyclotomic (p ^ (k + 2)) A))]
    [IsDiscreteValuationRing (AdjoinRoot (cyclotomic (p ^ (k + 2)) A))]
    (hpS : (p : AdjoinRoot (cyclotomic (p ^ (k + 2)) A)) ≠ 0)
    (hD : 0 < D)
    (hpval : IsDiscreteValuationRing.addVal
      (AdjoinRoot (cyclotomic (p ^ (k + 2)) A))
      (p : AdjoinRoot (cyclotomic (p ^ (k + 2)) A)) = (D : ℕ∞))
    (hs : 2 ≤ s) (b : Aˣ) (F K : Elem A (p ^ (k + 2)))
    (hFK : F * K = scalar _ ((p : A) ^ s * (b : A))) :
    (∃ F', cyclicProjection A (pow_dvd_pow p (Nat.le_succ (k + 1))) F =
      scalar _ (p : A) * F') ∨
    (∃ K', cyclicProjection A (pow_dvd_pow p (Nat.le_succ (k + 1))) K =
      scalar _ (p : A) * K') := by
  let v := cyclicCyclotomicEvaluation A (p ^ (k + 2))
  have hscalar : ∀ a : A, v (scalar _ a) =
      algebraMap A (AdjoinRoot (cyclotomic (p ^ (k + 2)) A)) a :=
    fun a => v.commutes a
  have hv : v F * v K =
      (p : AdjoinRoot (cyclotomic (p ^ (k + 2)) A)) ^ s *
        algebraMap A (AdjoinRoot (cyclotomic (p ^ (k + 2)) A)) (b : A) := by
    simpa only [map_mul, hscalar, map_pow, map_natCast] using congrArg v hFK
  have hb : IsUnit (algebraMap A (AdjoinRoot (cyclotomic (p ^ (k + 2)) A))
      (b : A)) := b.isUnit.map _
  rcases LocalDVR.dvd_or_dvd_of_mul_eq_pow_mul_unit hpS hD hpval hs hb hv with hF | hK
  · left
    simpa only [scalar_natCast] using
      cyclicProjection_divisible_of_cyclotomicEvaluation (e := k + 1) hp F hF
  · right
    simpa only [scalar_natCast] using
      cyclicProjection_divisible_of_cyclotomicEvaluation (e := k + 1) hp K hK

variable {S : Type uS} [CommRing S] [IsDomain A] [IsDomain S] [IsLocalRing S]

omit [IsDomain S] in
theorem comparison_step (p k s : ℕ) (φ : A →+* S) (hp : (p : A) ≠ 0)
    (v : Elem A (p ^ (k + 1)) →+* S)
    (v' : Elem A (p ^ (k + 2)) →+* S)
    (vscalar : ∀ a : A, v (scalar _ a) = φ a)
    (vq : ∀ F, v (cyclicProjection A (pow_dvd_pow p (Nat.le_succ (k + 1))) F) = v' F)
    (b : Aˣ) (F K : Elem A (p ^ (k + 2)))
    (hFK : F * K = scalar _ ((p : A) ^ (s + 1) * (b : A)))
    (F' : Elem A (p ^ (k + 1)))
    (hF : cyclicProjection A (pow_dvd_pow p (Nat.le_succ (k + 1))) F =
      scalar _ (p : A) * F')
    (ih : ∀ U V : Elem A (p ^ (k + 1)),
      U * V = scalar _ ((p : A) ^ s * (b : A)) →
        ResidueOneAssociated (IsLocalRing.residue S) (v U) (φ (augmentation _ U)) ∧
        ResidueOneAssociated (IsLocalRing.residue S) (v V) (φ (augmentation _ V))) :
    ResidueOneAssociated (IsLocalRing.residue S) (v' F) (φ (augmentation _ F)) ∧
    ResidueOneAssociated (IsLocalRing.residue S) (v' K) (φ (augmentation _ K)) := by
  let q := cyclicProjection A (pow_dvd_pow p (Nat.le_succ (k + 1)))
  have hdiv : F' * q K = scalar _ ((p : A) ^ s * (b : A)) :=
    quotient_scalar_norm_division q (fun a => cyclicProjection_single_zero _ a)
      (p : A) hp s (b : A) F K F' hFK hF
  obtain ⟨hiF, hiK⟩ := ih F' (q K) hdiv
  have heval : v' F = φ (p : A) * v F' := by
    rw [← vq F, hF, map_mul, vscalar]
  have haug : augmentation _ F = (p : A) * augmentation _ F' := by
    rw [← augmentation_cyclicProjection (pow_dvd_pow p (Nat.le_succ (k + 1))) F,
      hF, map_mul, augmentation_scalar]
  constructor
  · rw [heval, haug, map_mul]
    exact hiF.mul_left (φ (p : A))
  · simpa only [q, vq, augmentation_cyclicProjection] using hiK

variable (A) [CharZero A] [IsDiscreteValuationRing A]

theorem comparison_at_boundary (p : ℕ) [NeZero p] (hp : p.Prime)
    (hmax : IsLocalRing.maximalIdeal A = Ideal.span {(p : A)})
    (r d : ℕ) (b : Aˣ) (F K : Elem A (p ^ (r + d + 1)))
    (hFK : F * K = scalar _ ((p : A) ^ (d + 1) * (b : A))) :
    Compared A p r d F ∧ Compared A p r d K := by
  let : IsDomain (RamifiedLocal.Extension A p r) :=
    RamifiedLocal.isDomain A hp r hmax
  let : IsLocalRing (RamifiedLocal.Extension A p r) :=
    RamifiedLocal.isLocalRing A hp r hmax
  have hpA : Prime (p : A) :=
    ((IsDiscreteValuationRing.irreducible_iff_uniformizer (p : A)).mpr hmax).prime
  have hpS : algebraMap A (RamifiedLocal.Extension A p r) (p : A) ≠ 0 := by
    intro h
    exact hpA.ne_zero (RamifiedLocal.algebraMap_injective A hp r
      (by simpa only [map_zero] using h))
  have hroot : IsLocalRing.residue (RamifiedLocal.Extension A p r) (root A p r) = 1 := by
    have hpi : RamifiedLocal.uniformizer A p r ∈
        IsLocalRing.maximalIdeal (RamifiedLocal.Extension A p r) := by
      rw [RamifiedLocal.maximalIdeal_eq_span A hp r hmax]
      exact Ideal.subset_span (Set.mem_singleton _)
    have hz := (IsLocalRing.residue_eq_zero_iff _).mpr hpi
    simpa only [RamifiedLocal.uniformizer, root, map_sub, map_one, sub_eq_zero] using hz
  have hc : ∀ d (b : Aˣ) (F K : Elem A (p ^ (r + d + 1))),
      F * K = scalar _ ((p : A) ^ (d + 1) * (b : A)) →
      ResidueOneAssociated (IsLocalRing.residue (RamifiedLocal.Extension A p r))
        (value A p r d F) (algebraMap A _ (augmentation _ F)) ∧
      ResidueOneAssociated (IsLocalRing.residue (RamifiedLocal.Extension A p r))
        (value A p r d K) (algebraMap A _ (augmentation _ K)) := by
    intro d
    induction d with
    | zero =>
        intro b F K hFK
        exact comparison_base _ p (algebraMap A _) hpA hpS
          (value A p r 0).toRingHom (value_scalar A p r 0)
          (by
            intro U
            change IsLocalRing.residue _ (value A p r 0 U) =
              IsLocalRing.residue _ (algebraMap A _ (augmentation _ U))
            simp only [value, evaluateAt_apply, augmentation_apply,
              map_sum, map_mul, map_pow, hroot, one_pow, mul_one])
          b F K (by simpa only [Nat.zero_add, pow_one] using hFK)
    | succ d ih =>
        intro b F K hFK
        let : IsDomain (RamifiedLocal.Extension A p (r + d + 1)) :=
          RamifiedLocal.isDomain A hp (r + d + 1) hmax
        let : IsLocalRing (RamifiedLocal.Extension A p (r + d + 1)) :=
          RamifiedLocal.isLocalRing A hp (r + d + 1) hmax
        let : IsDiscreteValuationRing (RamifiedLocal.Extension A p (r + d + 1)) :=
          RamifiedLocal.isDiscreteValuationRing A hp (r + d + 1) hmax
        have hpR : (p : RamifiedLocal.Extension A p (r + d + 1)) ≠ 0 := by
          intro h
          apply hpA.ne_zero
          apply RamifiedLocal.algebraMap_injective A hp (r + d + 1)
          simpa only [map_natCast, map_zero] using h
        have hchoose := projected_factor_at_valuation (p := p) (k := r + d)
          hp hpR
          (Nat.mul_pos (Nat.sub_pos_of_lt hp.one_lt) (pow_pos hp.pos (r + d + 1)))
          (RamifiedLocal.addVal_prime A hp (r + d + 1) hmax)
          (by omega : 2 ≤ d + 2) b F K hFK
        rcases hchoose with ⟨F', hF⟩ | ⟨K', hK⟩
        · exact comparison_step p (r + d) (d + 1) (algebraMap A _) hpA.ne_zero
            (value A p r d).toRingHom (value A p r (d + 1)).toRingHom
            (value_scalar A p r d) (value_projection A p r d)
            b F K hFK F' hF (ih b)
        · have hKF : K * F = scalar _ ((p : A) ^ (d + 2) * (b : A)) := by
            simpa only [mul_comm] using hFK
          exact (comparison_step p (r + d) (d + 1) (algebraMap A _) hpA.ne_zero
            (value A p r d).toRingHom (value A p r (d + 1)).toRingHom
            (value_scalar A p r d) (value_projection A p r d)
            b K F hKF K' hK (ih b)).symm
  have toCompared {U : Elem A (p ^ (r + d + 1))}
      (hU : ResidueOneAssociated (IsLocalRing.residue (RamifiedLocal.Extension A p r))
        (value A p r d U) (algebraMap A _ (augmentation _ U))) :
      Compared A p r d U := by
    obtain ⟨u, hu, hres⟩ := hU
    refine ⟨u, hu, ?_⟩
    rw [← RamifiedLocal.maximalIdeal_eq_span A hp r hmax]
    apply (IsLocalRing.residue_eq_zero_iff _).mp
    rw [map_sub, hres, map_one, sub_self]
  exact ⟨toCompared (hc d b F K hFK).1, toCompared (hc d b F K hFK).2⟩

theorem sharp_character_comparison (p : ℕ) [NeZero p] (hp : p.Prime)
    (hmax : IsLocalRing.maximalIdeal A = Ideal.span {(p : A)})
    (r d s : ℕ) (hs : s ≤ d + 1) (b : Aˣ) (F K : Elem A (p ^ (r + d + 1)))
    (hFK : F * K = scalar _ ((p : A) ^ s * (b : A))) :
    Compared A p r d F ∧ Compared A p r d K := by
  let K' := scalar (p ^ (r + d + 1)) ((p : A) ^ (d + 1 - s)) * K
  have hFK' : F * K' = scalar _ ((p : A) ^ (d + 1) * (b : A)) := by
    calc
      F * K' = scalar _ ((p : A) ^ (d + 1 - s)) * (F * K) := by
        dsimp [K']
        ac_rfl
      _ = scalar _ ((p : A) ^ (d + 1 - s)) *
          scalar _ ((p : A) ^ s * (b : A)) := by rw [hFK]
      _ = scalar _ ((p : A) ^ (d + 1) * (b : A)) := by
        simp only [scalar, AddMonoidAlgebra.single_mul_single, zero_add]
        congr 1
        rw [← mul_assoc, ← pow_add, Nat.sub_add_cancel hs]
  obtain ⟨hF, hK⟩ := comparison_at_boundary A p hp hmax r d b F K' hFK'
  refine ⟨hF, ?_⟩
  let : IsDomain (RamifiedLocal.Extension A p r) :=
    RamifiedLocal.isDomain A hp r hmax
  let : IsLocalRing (RamifiedLocal.Extension A p r) :=
    RamifiedLocal.isLocalRing A hp r hmax
  have hpA : (p : A) ≠ 0 := Nat.cast_ne_zero.mpr hp.ne_zero
  have hpS : algebraMap A (RamifiedLocal.Extension A p r) (p : A) ≠ 0 := by
    intro h
    exact hpA (RamifiedLocal.algebraMap_injective A hp r
      (by simpa only [map_zero] using h))
  have hc : algebraMap A (RamifiedLocal.Extension A p r)
      ((p : A) ^ (d + 1 - s)) ≠ 0 := by
    rw [map_pow]
    exact pow_ne_zero _ hpS
  obtain ⟨u, hu, hres⟩ := hK
  refine ⟨u, ?_, hres⟩
  apply mul_left_cancel₀ hc
  have hv : value A p r d K' =
      algebraMap A _ ((p : A) ^ (d + 1 - s)) * value A p r d K := by
    simp only [K', map_mul, value_scalar]
  have ha : augmentation _ K' = (p : A) ^ (d + 1 - s) * augmentation _ K := by
    simp only [K', map_mul, augmentation_scalar]
  rw [hv, ha, map_mul] at hu
  exact hu.trans (by ac_rfl)

omit [CharZero A] in
theorem comparison_denominators (p n s : ℕ) (hp : (p : A) ≠ 0) (b : Aˣ)
    (F K : Elem A n) (hFK : F * K = scalar n ((p : A) ^ s * (b : A))) :
    augmentation n F ≠ 0 ∧ augmentation n K ≠ 0 := by
  have haug : augmentation n F * augmentation n K = (p : A) ^ s * (b : A) := by
    simpa only [map_mul, augmentation_scalar] using congrArg (augmentation n) hFK
  apply mul_ne_zero_iff.mp
  rw [haug]
  exact mul_ne_zero (pow_ne_zero _ hp) b.ne_zero

end

end SharpCharacterComparison

#print axioms SharpCharacterComparison.sharp_character_comparison
#print axioms SharpCharacterComparison.comparison_denominators
