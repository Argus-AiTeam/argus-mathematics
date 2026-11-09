import Mathlib

noncomputable section

open scoped BigOperators
open Finset MvPolynomial

namespace LSRectInterpolation

abbrev Z4 := Fin 4 → ℤ
abbrev C4 := Fin 4 → ℂ
abbrev C3 := Fin 3 → ℂ
abbrev Poly := MvPolynomial (Fin 3) ℂ

def intBox (N : ℕ) : Finset Z4 :=
  Fintype.piFinset fun _ => Finset.Ico (0 : ℤ) (N : ℤ)

@[simp] theorem mem_intBox (N : ℕ) (n : Z4) :
    n ∈ intBox N ↔ ∀ i, 0 ≤ n i ∧ n i < (N : ℤ) := by
  simp [intBox, Fintype.mem_piFinset]

theorem card_intBox (N : ℕ) : (intBox N).card = N ^ 4 := by
  simp [intBox, Fintype.card_piFinset]

def enlargedBox (N : ℕ) : Finset Z4 := intBox (4 * (N - 1) + 1)

theorem mem_enlargedBox (N : ℕ) (n : Z4) :
    n ∈ enlargedBox N ↔
      ∀ i, 0 ≤ n i ∧ n i ≤ ((4 * (N - 1) : ℕ) : ℤ) := by
  simp only [enlargedBox, mem_intBox, Nat.cast_add, Nat.cast_one, Int.lt_add_one_iff]

theorem card_enlargedBox (N : ℕ) (hN : 1 ≤ N) :
    (enlargedBox N).card = (4 * N - 3) ^ 4 := by
  rw [enlargedBox, card_intBox]
  congr 1
  omega

def intDot (r n : Z4) : ℤ := ∑ i, r i * n i

def castPoint (n : Z4) : C4 := fun i => (n i : ℂ)

/-- The only geometric assumption used by the interpolation argument. -/
def LatticeFaceSelection : Prop :=
  ∀ (N : ℕ), 1 ≤ N →
    ∀ (S : Finset Z4), S.Nonempty → S ⊆ intBox N →
      ∀ (F : Z4 → ℂ), (∃ m, F m ≠ 0) →
        (∀ m ∈ enlargedBox N, F m = 0) →
        ∃ u ∈ S, ∃ (m r : Z4) (k : ℤ),
          r ≠ 0 ∧ intDot r u = k ∧ F m ≠ 0 ∧
            ∀ n ∈ S, intDot r n ≠ k → F (m + n - u) = 0

abbrev RectIndex (t : Fin 3 → ℕ) := ∀ j, Fin (t j + 1)

def exponent {t : Fin 3 → ℕ} (a : RectIndex t) : Fin 3 →₀ ℕ :=
  Finsupp.equivFunOnFinite.symm fun j => (a j).val

@[simp] theorem exponent_apply {t : Fin 3 → ℕ} (a : RectIndex t) (j : Fin 3) :
    exponent a j = (a j).val := by
  simp [exponent]

theorem exponent_injective (t : Fin 3 → ℕ) :
    Function.Injective (exponent (t := t)) := by
  intro a b h
  funext j
  apply Fin.ext
  simpa using congrArg (fun d : Fin 3 →₀ ℕ => d j) h

def rectMonomial {t : Fin 3 → ℕ} (a : RectIndex t) : Poly :=
  monomial (exponent a) 1

def rectPolynomial {t : Fin 3 → ℕ} (b : RectIndex t → ℂ) : Poly :=
  ∑ a, C (b a) * rectMonomial a

theorem coeff_rectPolynomial {t : Fin 3 → ℕ} (b : RectIndex t → ℂ)
    (a : RectIndex t) :
    coeff (exponent a) (rectPolynomial b) = b a := by
  classical
  simp [rectPolynomial, rectMonomial, coeff_sum, coeff_C_mul, coeff_monomial,
    (exponent_injective t).eq_iff]

theorem rectPolynomial_injective (t : Fin 3 → ℕ) :
    Function.Injective (rectPolynomial (t := t)) := by
  intro b d h
  funext a
  simpa only [coeff_rectPolynomial] using congrArg (coeff (exponent a)) h

theorem degreeOf_rectPolynomial {t : Fin 3 → ℕ} (b : RectIndex t → ℂ)
    (j : Fin 3) :
    (rectPolynomial b).degreeOf j ≤ t j := by
  apply (degreeOf_sum_le j _ _).trans
  apply Finset.sup_le
  intro a _
  apply (degreeOf_C_mul_le _ j _).trans
  rw [rectMonomial, degreeOf_monomial_eq _ _ one_ne_zero, exponent_apply]
  exact Nat.le_of_lt_succ (a j).isLt

def rectPolynomialLinear (t : Fin 3 → ℕ) :
    (RectIndex t → ℂ) →ₗ[ℂ] Poly where
  toFun := rectPolynomial
  map_add' b d := by
    simp [rectPolynomial, map_add, add_mul, Finset.sum_add_distrib]
  map_smul' c b := by
    simp [rectPolynomial, MvPolynomial.smul_eq_C_mul, map_mul,
      Finset.mul_sum, mul_assoc]

def rectEvaluation (t : Fin 3 → ℕ) (A : C4 →ₗ[ℂ] C3) (B : Finset Z4) :
    (RectIndex t → ℂ) →ₗ[ℂ] (B → ℂ) :=
  LinearMap.pi fun n =>
    (MvPolynomial.aeval (A (castPoint n))).toLinearMap.comp (rectPolynomialLinear t)

theorem exists_vanishing_rectPolynomial
    (t : Fin 3 → ℕ) (A : C4 →ₗ[ℂ] C3) (B : Finset Z4)
    (hdim : B.card < ∏ j, (t j + 1)) :
    ∃ R : Poly, R ≠ 0 ∧ (∀ j, R.degreeOf j ≤ t j) ∧
      ∀ n ∈ B, eval (A (castPoint n)) R = 0 := by
  have hker : (rectEvaluation t A B).ker ≠ ⊥ := by
    apply LinearMap.ker_ne_bot_of_finrank_lt
    simpa [Module.finrank_fintype_fun_eq_card, Fintype.card_pi] using hdim
  obtain ⟨b, hb, hb0⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hker
  refine ⟨rectPolynomial b, ?_, degreeOf_rectPolynomial b, ?_⟩
  · intro hz
    apply hb0
    apply rectPolynomial_injective t
    simpa [rectPolynomial] using hz
  · intro n hn
    exact congrFun (LinearMap.mem_ker.mp hb) ⟨n, hn⟩

theorem exists_enlargedBox_vanishing_polynomial
    (N : ℕ) (hN : 1 ≤ N) (t : Fin 3 → ℕ) (A : C4 →ₗ[ℂ] C3)
    (hdim : (4 * N - 3) ^ 4 < ∏ j, (t j - 3 * (N - 1) + 1)) :
    ∃ R : Poly, R ≠ 0 ∧ (∀ j, R.degreeOf j ≤ t j - 3 * (N - 1)) ∧
      ∀ n ∈ enlargedBox N, eval (A (castPoint n)) R = 0 := by
  apply exists_vanishing_rectPolynomial
  rwa [card_enlargedBox N hN]

def linearPolynomial {d : ℕ} (l : (Fin d → ℂ) →ₗ[ℂ] ℂ) :
    MvPolynomial (Fin d) ℂ :=
  ∑ i, C (l (Pi.single i 1)) * X i

@[simp] theorem eval_linearPolynomial {d : ℕ}
    (l : (Fin d → ℂ) →ₗ[ℂ] ℂ) (x : Fin d → ℂ) :
    eval x (linearPolynomial l) = l x := by
  have hx : (∑ i, x i • Pi.single i (1 : ℂ)) = x := by
    ext j
    simp [Pi.single_apply]
  calc
    _ = l (∑ i, x i • Pi.single i (1 : ℂ)) := by
      simp [linearPolynomial, map_sum, map_smul, smul_eq_mul, mul_comm]
    _ = _ := congrArg l hx

theorem totalDegree_linearPolynomial {d : ℕ}
    (l : (Fin d → ℂ) →ₗ[ℂ] ℂ) :
    (linearPolynomial l).totalDegree ≤ 1 := by
  apply totalDegree_finsetSum_le
  intro i _
  exact (totalDegree_mul _ _).trans (by simp)

theorem eval_substitution {a b : ℕ}
    (q : Fin a → MvPolynomial (Fin b) ℂ)
    (p : MvPolynomial (Fin a) ℂ) (x : Fin b → ℂ) :
    eval x (eval₂Hom C q p) = eval (fun j => eval x (q j)) p := by
  induction p using MvPolynomial.induction_on with
  | C c => simp only [eval₂Hom_C, eval_C]
  | add p r hp hr => simp only [map_add, hp, hr]
  | mul_X p j hp => simp only [map_mul, eval₂Hom_X', eval_X, hp]

def linearPullback (A : C4 →ₗ[ℂ] C3) : Poly →+* MvPolynomial (Fin 4) ℂ :=
  eval₂Hom C fun j => linearPolynomial ((LinearMap.proj j).comp A)

@[simp] theorem eval_linearPullback (A : C4 →ₗ[ℂ] C3) (p : Poly) (x : C4) :
    eval x (linearPullback A p) = eval (A x) p := by
  rw [linearPullback, eval_substitution]
  simp only [eval_linearPolynomial, LinearMap.comp_apply, LinearMap.proj_apply]

theorem integer_grid_funext {d : ℕ} {p q : MvPolynomial (Fin d) ℂ}
    (h : ∀ n : Fin d → ℤ, eval (fun i => (n i : ℂ)) p =
      eval (fun i => (n i : ℂ)) q) :
    p = q := by
  apply MvPolynomial.funext_set (fun _ => Set.range fun z : ℤ => (z : ℂ))
    (fun _ => Set.infinite_range_of_injective Int.cast_injective)
  intro x hx
  have hex : ∀ i, ∃ n : ℤ, (n : ℂ) = x i := fun i => hx i (Set.mem_univ i)
  choose n hn using hex
  have heq : x = fun i => (n i : ℂ) := funext fun i => (hn i).symm
  rw [heq]
  exact h n

theorem exists_integer_eval_ne_zero
    (A : C4 →ₗ[ℂ] C3) (hA : Function.Surjective A)
    (R : Poly) (hR : R ≠ 0) :
    ∃ m : Z4, eval (A (castPoint m)) R ≠ 0 := by
  by_contra! h
  have hp : linearPullback A R = 0 := by
    apply integer_grid_funext
    intro n
    rw [eval_linearPullback, map_zero]
    exact h n
  apply hR
  apply MvPolynomial.funext
  intro z
  obtain ⟨x, rfl⟩ := hA z
  have hh := eval_linearPullback A R x
  simpa [hp] using hh.symm

def translate (v : C3) (p : Poly) : Poly :=
  eval₂Hom C (fun j => X j + C (v j)) p

@[simp] theorem eval_translate (v : C3) (p : Poly) (z : C3) :
    eval z (translate v p) = eval (z + v) p := by
  rw [translate, eval_substitution]
  simp only [map_add, eval_X, eval_C, Pi.add_def]

theorem degreeOf_translate_monomial (v : C3) (d : Fin 3 →₀ ℕ) (c : ℂ)
    (i : Fin 3) :
    (translate v (monomial d c)).degreeOf i ≤ d i := by
  classical
  rw [translate, eval₂Hom_monomial, Finsupp.prod_fintype _ _ (by simp)]
  apply (degreeOf_C_mul_le _ i c).trans
  apply (degreeOf_prod_le i _ _).trans
  calc
    _ ≤ ∑ j : Fin 3, d j * (if i = j then 1 else 0) := by
      apply Finset.sum_le_sum
      intro j _
      apply (degreeOf_pow_le _ _ _).trans
      apply Nat.mul_le_mul_left
      exact (degreeOf_add_le _ _ _).trans (by simp [degreeOf_X])
    _ = d i := by simp

theorem degreeOf_translate (v : C3) (p : Poly) (i : Fin 3) :
    (translate v p).degreeOf i ≤ p.degreeOf i := by
  classical
  conv_lhs => rw [p.as_sum]
  simp only [translate, map_sum]
  apply (degreeOf_sum_le i _ _).trans
  apply Finset.sup_le
  intro d hd
  exact (degreeOf_translate_monomial v d _ i).trans (monomial_le_degreeOf i hd)

theorem degreeOf_translate_mul
    (t : Fin 3 → ℕ) (D : ℕ) (ht : ∀ j, D ≤ t j)
    (R Q : Poly) (hR : ∀ j, R.degreeOf j ≤ t j - D)
    (hQ : Q.totalDegree ≤ D) (v : C3) (j : Fin 3) :
    (translate v R * Q).degreeOf j ≤ t j := by
  apply (degreeOf_mul_le j _ _).trans
  have hRj := (degreeOf_translate v R j).trans (hR j)
  have hQj := (degreeOf_le_totalDegree Q j).trans hQ
  have htj := ht j
  omega

def normal (r : Z4) : C4 →ₗ[ℂ] ℂ :=
  ∑ i, (r i : ℂ) • LinearMap.proj i

@[simp] theorem normal_apply (r : Z4) (x : C4) :
    normal r x = ∑ i, (r i : ℂ) * x i := by
  simp [normal, smul_eq_mul]

@[simp] theorem normal_castPoint (r n : Z4) :
    normal r (castPoint n) = (intDot r n : ℂ) := by
  simp [normal_apply, castPoint, intDot]

theorem normal_ne_zero_of_rational_independence
    (c : C4) (hc : LinearIndependent ℚ c) (r : Z4) (hr : r ≠ 0) :
    normal r c ≠ 0 := by
  intro hz
  have hrel : (∑ i, (r i : ℚ) • c i) = 0 := by
    simpa [Algebra.smul_def] using hz
  have hall := Fintype.linearIndependent_iff.mp hc (fun i => (r i : ℚ)) hrel
  apply hr
  ext i
  exact_mod_cast hall i

theorem affine_inverse_formula
    (A : C4 →ₗ[ℂ] C3) (J : C3 →ₗ[ℂ] C4)
    (hJ : A.comp J = LinearMap.id)
    (c : C4) (hker : ∀ x, A x = 0 ↔ ∃ s : ℂ, x = s • c)
    (r : Z4) (hrc : normal r c ≠ 0) (k : ℂ)
    (x : C4) (hx : normal r x = k) :
    J (A x) + ((k - normal r (J (A x))) / normal r c) • c = x := by
  have hAJ (z : C3) : A (J z) = z :=
    congrArg (fun f : C3 →ₗ[ℂ] C3 => f z) hJ
  have hd : A (x - J (A x)) = 0 := by
    rw [map_sub, hAJ, sub_self]
  obtain ⟨s, hs⟩ := (hker _).mp hd
  have hn := congrArg (normal r) hs
  simp only [map_sub, map_smul, smul_eq_mul, hx] at hn
  have hs' : (k - normal r (J (A x))) / normal r c = s :=
    (div_eq_iff hrc).mpr hn
  rw [hs', ← hs]
  abel

def affineCoordinate
    (J : C3 →ₗ[ℂ] C4) (c : C4) (r : Z4) (k : ℤ) (i : Fin 4) : Poly :=
  linearPolynomial ((LinearMap.proj i).comp J) +
    C (c i / normal r c) *
      (C (k : ℂ) - linearPolynomial ((normal r).comp J))

theorem totalDegree_affineCoordinate
    (J : C3 →ₗ[ℂ] C4) (c : C4) (r : Z4) (k : ℤ) (i : Fin 4) :
    (affineCoordinate J c r k i).totalDegree ≤ 1 := by
  apply (totalDegree_add _ _).trans
  apply max_le (totalDegree_linearPolynomial _)
  apply (totalDegree_mul _ _).trans
  simp only [totalDegree_C, zero_add]
  exact (totalDegree_sub _ _).trans
    (max_le (by rw [totalDegree_C]; omega) (totalDegree_linearPolynomial _))

theorem eval_affineCoordinate
    (A : C4 →ₗ[ℂ] C3) (J : C3 →ₗ[ℂ] C4)
    (hJ : A.comp J = LinearMap.id)
    (c : C4) (hker : ∀ x, A x = 0 ↔ ∃ s : ℂ, x = s • c)
    (r : Z4) (hrc : normal r c ≠ 0) (k : ℤ)
    (x : C4) (hx : normal r x = (k : ℂ)) (i : Fin 4) :
    eval (A x) (affineCoordinate J c r k i) = x i := by
  have hh := congrFun (affine_inverse_formula A J hJ c hker r hrc (k : ℂ) x hx) i
  simpa only [affineCoordinate, map_add, map_mul, map_sub, eval_C,
    eval_linearPolynomial, LinearMap.comp_apply, LinearMap.proj_apply,
    Pi.add_apply, Pi.smul_apply, smul_eq_mul,
    div_eq_mul_inv, mul_comm, mul_left_comm, mul_assoc] using hh

def gridFactor (N : ℕ) (u : ℤ) (p : Poly) : Poly :=
  ∏ a ∈ (Finset.Ico (0 : ℤ) (N : ℤ)).erase u,
    C (((u - a : ℤ) : ℂ)⁻¹) * (p - C (a : ℂ))

theorem totalDegree_gridFactor
    (N : ℕ) (u : ℤ) (hu : 0 ≤ u ∧ u < (N : ℤ))
    (p : Poly) (hp : p.totalDegree ≤ 1) :
    (gridFactor N u p).totalDegree ≤ N - 1 := by
  apply (totalDegree_finsetProd _ _).trans
  calc
    _ ≤ ∑ _a ∈ (Finset.Ico (0 : ℤ) (N : ℤ)).erase u, 1 := by
      apply Finset.sum_le_sum
      intro a _
      exact (totalDegree_mul _ _).trans (by
        simpa using (totalDegree_sub_C_le p (a : ℂ)).trans hp)
    _ = N - 1 := by
      rw [Finset.sum_const, Finset.card_erase_of_mem (Finset.mem_Ico.mpr hu)]
      simp

theorem eval_gridFactor_self
    (N : ℕ) (u : ℤ) (p : Poly) (z : C3) (hp : eval z p = (u : ℂ)) :
    eval z (gridFactor N u p) = 1 := by
  classical
  rw [gridFactor, map_prod]
  apply Finset.prod_eq_one
  intro a ha
  have hau : a ≠ u := (Finset.mem_erase.mp ha).1
  have hden : (u : ℂ) - (a : ℂ) ≠ 0 := by
    apply sub_ne_zero.mpr
    exact_mod_cast Ne.symm hau
  simpa only [map_mul, eval_C, map_sub, hp, Int.cast_sub] using inv_mul_cancel₀ hden

theorem eval_gridFactor_other
    (N : ℕ) (u v : ℤ) (hv : 0 ≤ v ∧ v < (N : ℤ)) (hvu : v ≠ u)
    (p : Poly) (z : C3) (hp : eval z p = (v : ℂ)) :
    eval z (gridFactor N u p) = 0 := by
  classical
  rw [gridFactor, map_prod]
  apply Finset.prod_eq_zero (Finset.mem_erase.mpr ⟨hvu, Finset.mem_Ico.mpr hv⟩)
  simp only [map_mul, eval_C, map_sub, hp, sub_self, mul_zero]

theorem eq_of_intDot_eq_of_eq_off
    (r n u : Z4) (i₀ : Fin 4) (hr : r i₀ ≠ 0)
    (hdot : intDot r n = intDot r u)
    (heq : ∀ i, i ≠ i₀ → n i = u i) :
    n = u := by
  have hsum : (∑ i, r i * (n i - u i)) = r i₀ * (n i₀ - u i₀) := by
    apply Finset.sum_eq_single i₀
    · intro i _ hi
      rw [heq i hi, sub_self, mul_zero]
    · simp
  have hz : (∑ i, r i * (n i - u i)) = 0 := by
    simp only [mul_sub, Finset.sum_sub_distrib]
    exact sub_eq_zero.mpr hdot
  rw [hsum] at hz
  have hi₀ := sub_eq_zero.mp ((mul_eq_zero.mp hz).resolve_left hr)
  funext i
  by_cases hi : i = i₀
  · simpa only [hi] using hi₀
  · exact heq i hi

def facePolynomial
    (N : ℕ) (J : C3 →ₗ[ℂ] C4) (c : C4) (r : Z4) (k : ℤ)
    (u : Z4) (i₀ : Fin 4) : Poly :=
  ∏ i ∈ (Finset.univ : Finset (Fin 4)).erase i₀,
    gridFactor N (u i) (affineCoordinate J c r k i)

theorem totalDegree_facePolynomial
    (N : ℕ) (J : C3 →ₗ[ℂ] C4) (c : C4) (r : Z4) (k : ℤ)
    (u : Z4) (hu : u ∈ intBox N) (i₀ : Fin 4) :
    (facePolynomial N J c r k u i₀).totalDegree ≤ 3 * (N - 1) := by
  apply (totalDegree_finsetProd _ _).trans
  calc
    _ ≤ ∑ _i ∈ (Finset.univ : Finset (Fin 4)).erase i₀, (N - 1) := by
      apply Finset.sum_le_sum
      intro i _
      exact totalDegree_gridFactor N (u i) ((mem_intBox N u).mp hu i) _
        (totalDegree_affineCoordinate _ _ _ _ _)
    _ = _ := by simp

/-- Polynomial separation on the whole grid section of a rational hyperplane. -/
theorem face_interpolation
    (N : ℕ) (A : C4 →ₗ[ℂ] C3) (hA : Function.Surjective A)
    (c : C4) (hker : ∀ x, A x = 0 ↔ ∃ s : ℂ, x = s • c)
    (hc : LinearIndependent ℚ c)
    (r : Z4) (hr : r ≠ 0) (k : ℤ)
    (u : Z4) (hu : u ∈ intBox N) (huface : intDot r u = k) :
    ∃ Q : Poly, Q.totalDegree ≤ 3 * (N - 1) ∧
      eval (A (castPoint u)) Q = 1 ∧
      ∀ n ∈ intBox N, intDot r n = k → n ≠ u →
        eval (A (castPoint n)) Q = 0 := by
  have hrc := normal_ne_zero_of_rational_independence c hc r hr
  obtain ⟨J, hJ⟩ := A.exists_rightInverse_of_surjective (LinearMap.range_eq_top.mpr hA)
  have hex : ∃ i, r i ≠ 0 := by
    by_contra! h
    exact hr (funext h)
  obtain ⟨i₀, hi₀⟩ := hex
  refine ⟨facePolynomial N J c r k u i₀,
    totalDegree_facePolynomial N J c r k u hu i₀, ?_, ?_⟩
  · rw [facePolynomial, map_prod]
    apply Finset.prod_eq_one
    intro i _
    apply eval_gridFactor_self
    exact eval_affineCoordinate A J hJ c hker r hrc k (castPoint u)
      (by rw [normal_castPoint, huface]) i
  · intro n hn hnface hnu
    have hdiff : ∃ i, i ≠ i₀ ∧ n i ≠ u i := by
      by_contra! h
      apply hnu
      exact eq_of_intDot_eq_of_eq_off r n u i₀ hi₀
        (hnface.trans huface.symm) h
    obtain ⟨i, hi, hni⟩ := hdiff
    rw [facePolynomial, map_prod]
    apply Finset.prod_eq_zero (Finset.mem_erase.mpr ⟨hi, Finset.mem_univ i⟩)
    apply eval_gridFactor_other N (u i) (n i) ((mem_intBox N n).mp hn i) hni
    exact eval_affineCoordinate A J hJ c hker r hrc k (castPoint n)
      (by rw [normal_castPoint, hnface]) i

@[simp] theorem eval_rectMonomial {t : Fin 3 → ℕ} (a : RectIndex t) (z : C3) :
    eval z (rectMonomial a) = ∏ j, z j ^ (a j).val := by
  rw [rectMonomial, eval_monomial, Finsupp.prod_fintype _ _ (by simp)]
  simp only [one_mul, exponent_apply]

theorem eval_rectPolynomial {t : Fin 3 → ℕ} (b : RectIndex t → ℂ) (z : C3) :
    eval z (rectPolynomial b) = ∑ a, b a * ∏ j, z j ^ (a j).val := by
  simp only [rectPolynomial, map_sum, map_mul, eval_C, eval_rectMonomial]

def monomialRow (A : C4 →ₗ[ℂ] C3) (N : ℕ) (t : Fin 3 → ℕ)
    (a : RectIndex t) : intBox N → ℂ :=
  fun n => ∏ j, (A (castPoint n) j) ^ (a j).val

def evaluationOnBox (A : C4 →ₗ[ℂ] C3) (N : ℕ) :
    Poly →ₗ[ℂ] (intBox N → ℂ) :=
  LinearMap.pi fun n => (MvPolynomial.aeval (A (castPoint n))).toLinearMap

@[simp] theorem evaluationOnBox_apply
    (A : C4 →ₗ[ℂ] C3) (N : ℕ) (p : Poly) (n : intBox N) :
    evaluationOnBox A N p n = eval (A (castPoint n)) p := rfl

theorem bounded_evaluation_mem_monomial_span
    (A : C4 →ₗ[ℂ] C3) (N : ℕ) (t : Fin 3 → ℕ)
    (p : Poly) (hp : ∀ j, p.degreeOf j ≤ t j) :
    evaluationOnBox A N p ∈
      Submodule.span ℂ (Set.range (monomialRow A N t)) := by
  classical
  have heq : evaluationOnBox A N p =
      ∑ d ∈ p.support, evaluationOnBox A N (monomial d (coeff d p)) := by
    conv_lhs => rw [p.as_sum]
    exact map_sum _ _ _
  rw [heq]
  apply Submodule.sum_mem
  intro d hd
  let a : RectIndex t := fun j =>
    ⟨d j, Nat.lt_succ_of_le ((monomial_le_degreeOf j hd).trans (hp j))⟩
  have hrow :
      evaluationOnBox A N (monomial d (coeff d p)) =
        coeff d p • monomialRow A N t a := by
    ext n
    rw [evaluationOnBox_apply, eval_monomial,
      Finsupp.prod_fintype _ _ (by simp)]
    rfl
  rw [hrow]
  exact Submodule.smul_mem _ _ (Submodule.subset_span ⟨a, rfl⟩)

theorem eval_translated_lattice
    (A : C4 →ₗ[ℂ] C3) (m n u : Z4) (R : Poly) :
    eval (A (castPoint n)) (translate (A (castPoint (m - u))) R) =
      eval (A (castPoint (m + n - u))) R := by
  have hpoint : A (castPoint n) + A (castPoint (m - u)) =
      A (castPoint (m + n - u)) := by
    rw [← map_add]
    congr 1
    ext i
    simp only [castPoint, Pi.add_apply, Pi.sub_apply, Int.cast_add, Int.cast_sub]
    ring
  rw [eval_translate, hpoint]

/-- No nonzero weights can annihilate the rectangular polynomial evaluations. -/
theorem annihilator_contradiction_of_selection
    (hselect : LatticeFaceSelection)
    (N : ℕ) (hN : 1 ≤ N) (t : Fin 3 → ℕ)
    (ht : ∀ j, 3 * (N - 1) ≤ t j)
    (hdim : (4 * N - 3) ^ 4 < ∏ j, (t j - 3 * (N - 1) + 1))
    (A : C4 →ₗ[ℂ] C3) (hA : Function.Surjective A)
    (c : C4) (hker : ∀ x, A x = 0 ↔ ∃ s : ℂ, x = s • c)
    (hc : LinearIndependent ℚ c)
    (w : Z4 → ℂ) (hw : ∃ n ∈ intBox N, w n ≠ 0)
    (hann : ∀ p : Poly, (∀ j, p.degreeOf j ≤ t j) →
      ∑ n ∈ intBox N, w n * eval (A (castPoint n)) p = 0) :
    False := by
  classical
  obtain ⟨R, hR0, hRdeg, hRvan⟩ :=
    exists_enlargedBox_vanishing_polynomial N hN t A hdim
  let F : Z4 → ℂ := fun m => eval (A (castPoint m)) R
  have hF : ∃ m, F m ≠ 0 := exists_integer_eval_ne_zero A hA R hR0
  let S : Finset Z4 := (intBox N).filter fun n => w n ≠ 0
  have hSne : S.Nonempty := by
    obtain ⟨n, hn, hwn⟩ := hw
    exact ⟨n, Finset.mem_filter.mpr ⟨hn, hwn⟩⟩
  have hSbox : S ⊆ intBox N := Finset.filter_subset _ _
  obtain ⟨u, huS, m, r, k, hr, huface, hFm, hout⟩ :=
    hselect N hN S hSne hSbox F hF hRvan
  have hu : u ∈ intBox N := hSbox huS
  have hwu : w u ≠ 0 := (Finset.mem_filter.mp huS).2
  obtain ⟨Q, hQdeg, hQu, hQother⟩ :=
    face_interpolation N A hA c hker hc r hr k u hu huface
  let H : Poly := translate (A (castPoint (m - u))) R * Q
  have hHdeg : ∀ j, H.degreeOf j ≤ t j :=
    degreeOf_translate_mul t (3 * (N - 1)) ht R Q hRdeg hQdeg _
  have hsum : (∑ n ∈ intBox N, w n * eval (A (castPoint n)) H) = w u * F m := by
    calc
      _ = w u * eval (A (castPoint u)) H := by
        apply Finset.sum_eq_single u
        · intro n hn hnu
          by_cases hwn : w n = 0
          · rw [hwn, zero_mul]
          have hnS : n ∈ S := Finset.mem_filter.mpr ⟨hn, hwn⟩
          by_cases hnface : intDot r n = k
          · have hQn := hQother n hn hnface hnu
            simp only [H, map_mul, hQn, mul_zero]
          · have hRn := hout n hnS hnface
            simp only [H, map_mul, eval_translated_lattice]
            change w n * (F (m + n - u) * eval (A (castPoint n)) Q) = 0
            rw [hRn, zero_mul, mul_zero]
        · intro hnot
          exact (hnot hu).elim
      _ = w u * F m := by
        simp only [H, map_mul, eval_translated_lattice, hQu, mul_one,
          add_sub_cancel_right]
        rfl
  have hz := hann H hHdeg
  rw [hsum] at hz
  exact (mul_ne_zero hwu hFm) hz

def extendWeight (B : Finset Z4) (v : B → ℂ) (n : Z4) : ℂ :=
  if hn : n ∈ B then v ⟨n, hn⟩ else 0

@[simp] theorem extendWeight_coe (B : Finset Z4) (v : B → ℂ) (n : B) :
    extendWeight B v n = v n := by
  simp [extendWeight, n.property]

theorem functional_eq_sum (B : Finset Z4)
    (l : (B → ℂ) →ₗ[ℂ] ℂ) (x : B → ℂ) :
    l x = ∑ n, x n * l (Pi.single n 1) := by
  have hx : (∑ n, x n • Pi.single n (1 : ℂ)) = x := by
    ext j
    simp [Pi.single_apply]
  calc
    l x = l (∑ n, x n • Pi.single n (1 : ℂ)) := congrArg l hx.symm
    _ = _ := by simp [map_sum, map_smul, smul_eq_mul]

theorem exists_single_ne_zero (B : Finset Z4)
    (l : (B → ℂ) →ₗ[ℂ] ℂ) (hl : l ≠ 0) :
    ∃ n, l (Pi.single n 1) ≠ 0 := by
  classical
  by_contra! h
  apply hl
  apply LinearMap.ext
  intro x
  change l x = 0
  rw [functional_eq_sum]
  simp only [h, mul_zero, Finset.sum_const_zero]

/-- Conditional only on the stated lattice-face-selection principle. -/
theorem projected_box_monomial_span_of_selection
    (hselect : LatticeFaceSelection)
    (N : ℕ) (hN : 1 ≤ N) (t : Fin 3 → ℕ)
    (ht : ∀ j, 3 * (N - 1) ≤ t j)
    (hdim : (4 * N - 3) ^ 4 < ∏ j, (t j - 3 * (N - 1) + 1))
    (A : C4 →ₗ[ℂ] C3) (hA : Function.Surjective A)
    (c : C4) (hker : ∀ x, A x = 0 ↔ ∃ s : ℂ, x = s • c)
    (hc : LinearIndependent ℚ c) :
    Submodule.span ℂ (Set.range (monomialRow A N t)) = ⊤ := by
  classical
  let W := Submodule.span ℂ (Set.range (monomialRow A N t))
  by_contra hW
  have hdual : W.dualAnnihilator ≠ ⊥ := by
    intro hz
    exact hW (Submodule.dualAnnihilator_eq_bot_iff.mp hz)
  obtain ⟨l, hl, hl0⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hdual
  let v : intBox N → ℂ := fun n => l (Pi.single n 1)
  let w := extendWeight (intBox N) v
  have hw : ∃ n ∈ intBox N, w n ≠ 0 := by
    obtain ⟨n, hn⟩ := exists_single_ne_zero (intBox N) l hl0
    refine ⟨n, n.property, ?_⟩
    change extendWeight (intBox N) v n ≠ 0
    rw [extendWeight_coe]
    exact hn
  apply annihilator_contradiction_of_selection
    hselect N hN t ht hdim A hA c hker hc w hw
  intro p hp
  have hzero : l (evaluationOnBox A N p) = 0 :=
    (Submodule.mem_dualAnnihilator l).mp hl _ (bounded_evaluation_mem_monomial_span A N t p hp)
  have hsum : (∑ n ∈ intBox N, w n * eval (A (castPoint n)) p) =
      l (evaluationOnBox A N p) := by
    rw [← Finset.sum_coe_sort, functional_eq_sum]
    apply Finset.sum_congr rfl
    intro n _
    change extendWeight (intBox N) v n * eval (A (castPoint n)) p =
      eval (A (castPoint n)) p * l (Pi.single n 1)
    rw [extendWeight_coe]
    exact mul_comm _ _
  exact hsum.trans hzero

/-- Every prescribed complex function on the box has a rectangular-degree interpolant,
provided the sole geometric selector is supplied. -/
theorem rectangular_interpolation_of_selection
    (hselect : LatticeFaceSelection)
    (N : ℕ) (hN : 1 ≤ N) (t : Fin 3 → ℕ)
    (ht : ∀ j, 3 * (N - 1) ≤ t j)
    (hdim : (4 * N - 3) ^ 4 < ∏ j, (t j - 3 * (N - 1) + 1))
    (A : C4 →ₗ[ℂ] C3) (hA : Function.Surjective A)
    (c : C4) (hker : ∀ x, A x = 0 ↔ ∃ s : ℂ, x = s • c)
    (hc : LinearIndependent ℚ c) (y : intBox N → ℂ) :
    ∃ p : Poly, (∀ j, p.degreeOf j ≤ t j) ∧
      ∀ n : intBox N, eval (A (castPoint n)) p = y n := by
  have hspan := projected_box_monomial_span_of_selection
    hselect N hN t ht hdim A hA c hker hc
  have hy : y ∈ Submodule.span ℂ (Set.range (monomialRow A N t)) := by
    rw [hspan]
    exact Submodule.mem_top
  obtain ⟨b, hb⟩ := (Submodule.mem_span_range_iff_exists_fun ℂ).mp hy
  refine ⟨rectPolynomial b, degreeOf_rectPolynomial b, ?_⟩
  intro n
  rw [eval_rectPolynomial]
  have hh := congrFun hb n
  simpa only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul, monomialRow] using hh

end LSRectInterpolation

#print axioms LSRectInterpolation.projected_box_monomial_span_of_selection
#print axioms LSRectInterpolation.rectangular_interpolation_of_selection
