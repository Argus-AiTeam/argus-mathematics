import research.latent_separation.genericity.Main
import research.latent_separation.radicals.Main

noncomputable section

open scoped BigOperators
open LatentGenericity LatentRadicals

namespace LatentAlignment

abbrev Variables (r : ℕ) := Fin 3 × Fin r
abbrev Polynomial (r : ℕ) := RootPolynomial (Variables r)
abbrev FunctionField (r : ℕ) := RootField (Variables r)
abbrev SquareField (r : ℕ) : Type := ↥(squareSubfield (Variables r))

variable {r : ℕ} {E : Type*}

def column (point : E → Fin r → Bool) (ij : Variables r) : E → SquareField r :=
  fun e => ∑ k : Fin r, (squareVariable (ij.1, k) : SquareField r) *
    coordinate (K := SquareField r) point ij.2 e *
      coordinate (K := SquareField r) point k e

theorem weighted_pairs_quadratic {K : Type*} [Field K]
    (point : E → Fin r → Bool) (weights : Fin r → K) (j : Fin r) :
    (fun e => ∑ k : Fin r, weights k * coordinate (K := K) point j e *
      coordinate (K := K) point k e) ∈ evaluationSpan point 2 := by
  have heq : (fun e => ∑ k : Fin r, weights k * coordinate (K := K) point j e *
      coordinate (K := K) point k e) =
      ∑ k : Fin r, weights k •
        (coordinate (K := K) point j * coordinate (K := K) point k) := by
    ext e
    simp [mul_assoc]
  rw [heq]
  apply (evaluationSpan (K := K) point 2).sum_mem
  intro k _
  apply Submodule.smul_mem
  simpa only [monomial, mul_one] using
    monomial_mem_evaluationSpan (K := K) point (m := [j, k]) (by simp) (by simp)

theorem column_quadratic (point : E → Fin r → Bool) (ij : Variables r) :
    column point ij ∈ evaluationSpan point 2 :=
  weighted_pairs_quadratic point (fun k => squareVariable (ij.1, k)) ij.2

def linearPolynomial (point : E → Fin r → Bool) (i : Fin 3) (e : E) :
    Polynomial r :=
  ∑ j : Fin r, MvPolynomial.X (i, j) * (if point e j then 1 else 0)

def zPolynomial (point : E → Fin r → Bool) (i : Fin 3) (e : E) :
    Polynomial r :=
  ∑ j : Fin r, MvPolynomial.X (i, j) ^ 2 * (if point e j then 1 else 0)

def matrixPolynomial (point : E → Fin r → Bool) (e : E) (ij : Variables r) :
    Polynomial r :=
  (if point e ij.2 then 1 else 0) * zPolynomial point ij.1 e

def responsePolynomial (point : E → Fin r → Bool) (e : E) : Polynomial r :=
  linearPolynomial point 0 e * linearPolynomial point 1 e * linearPolynomial point 2 e

def response (point : E → Fin r → Bool) : E → FunctionField r :=
  fun e => algebraMap (Polynomial r) (FunctionField r) (responsePolynomial point e)

theorem linearPolynomial_sq (point : E → Fin r → Bool) (i : Fin 3) (e : E) :
    linearPolynomial point i e ^ 2 = zPolynomial point i e := by
  unfold linearPolynomial zPolynomial
  rw [CharTwo.sum_sq]
  apply Finset.sum_congr rfl
  intro j _
  cases point e j <;> simp

theorem responsePolynomial_sq (point : E → Fin r → Bool) (e : E) :
    responsePolynomial point e ^ 2 =
      zPolynomial point 0 e * zPolynomial point 1 e * zPolynomial point 2 e := by
  simp only [responsePolynomial, mul_pow, linearPolynomial_sq]

theorem matrixPolynomial_map (point : E → Fin r → Bool) (e : E) (ij : Variables r) :
    algebraMap (Polynomial r) (FunctionField r) (matrixPolynomial point e ij) =
      scalarExtend (A := FunctionField r) (column point ij) e := by
  classical
  simp only [matrixPolynomial, zPolynomial, column, scalarExtend, coordinate,
    map_mul, map_sum, map_pow, apply_ite, map_one, map_zero, squareVariable, root]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  cases point e ij.2 <;> cases point e j <;> simp
  rfl

theorem response_eq_radicalCombination (point : E → Fin r → Bool) :
    response point =
      radicalCombination (K := SquareField r) tripleRadical (cubicEvaluation point) := by
  classical
  ext e
  simp only [response, responsePolynomial, linearPolynomial, map_mul, map_sum,
    apply_ite, map_one, map_zero, radicalCombination, cubicEvaluation, monomial,
    coordinate, Pi.mul_apply, mul_one, Fintype.sum_prod_type,
    Algebra.smul_def, tripleRadical, root]
  rw [Fintype.sum_mul_sum, Finset.sum_mul]
  simp only [Fintype.sum_mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  apply Finset.sum_congr rfl
  intro k _
  apply Finset.sum_congr rfl
  intro l _
  cases point e j <;> cases point e k <;> cases point e l <;> simp

theorem actual_matrix_nonmembership [Fintype E]
    (point : E → Fin r → Bool) (hinjective : Function.Injective point)
    (hnonzero : ∀ e, ∃ j, point e j = true) (hlarge : 3 * r < Fintype.card E) :
    response point ∉ Submodule.span (FunctionField r)
      (Set.range (fun ij : Variables r =>
        fun e => algebraMap (Polynomial r) (FunctionField r) (matrixPolynomial point e ij))) := by
  have hsmall : Fintype.card (Variables r) < Fintype.card E := by
    simpa [Variables, Fintype.card_prod] using hlarge
  have h := cubic_radical_not_in_small_quadratic_column_span point hinjective hnonzero
    (column point) (column_quadratic point) hsmall tripleRadical
    (triple_linearIndependent r)
  rw [← response_eq_radicalCombination] at h
  simpa only [matrixPolynomial_map] using h

#print axioms actual_matrix_nonmembership

section Minors

variable {K : Type*} [Field K] {J : Type*} [Fintype J] [DecidableEq J] [Fintype E]

theorem independent_has_minor (v : J → E → K) (hv : LinearIndependent K v) :
    ∃ rows : J → E, (Matrix.of (fun i j => v j (rows i))).det ≠ 0 := by
  classical
  let M : Matrix E J K := fun e j => v j e
  have hrank : M.rank = Fintype.card J := by
    rw [← Matrix.rank_transpose]
    exact hv.rank_matrix
  obtain ⟨κ, a, ha, hspan, hli⟩ := exists_linearIndependent' K M.row
  letI : Finite κ := Finite.of_injective a ha
  letI : Fintype κ := Fintype.ofFinite κ
  have hcard : Fintype.card κ = Fintype.card J := by
    calc
      Fintype.card κ = Module.finrank K
          (Submodule.span K (Set.range (M.row ∘ a))) :=
        linearIndependent_iff_card_eq_finrank_span.mp hli
      _ = M.rank := by rw [hspan, Matrix.rank_eq_finrank_span_row]
      _ = Fintype.card J := hrank
  let e : J ≃ κ := Fintype.equivOfCardEq hcard.symm
  let B : Matrix J J K := fun i j => M (a (e i)) j
  have hB : LinearIndependent K B.row := hli.comp e e.injective
  exact ⟨a ∘ e,
    (B.isUnit_iff_isUnit_det.mp (Matrix.linearIndependent_rows_iff_isUnit.mp hB)).ne_zero⟩

end Minors

section AugmentedDeterminants

variable {S : Type*} [CommRing S] {J : Type*} [Fintype J] [DecidableEq J]

def augmentedSquare (w : J → E → S) (rows : Option J → E) (v : E → S) :
    Matrix (Option J) (Option J) S :=
  fun i j => j.elim (v (rows i)) (fun k => w k (rows i))

omit [Fintype J] in
theorem augmentedSquare_update (w : J → E → S) (rows : Option J → E) (v : E → S) :
    augmentedSquare w rows v =
      (augmentedSquare w rows 0).updateCol none (fun i => v (rows i)) := by
  ext i j
  cases j <;> simp [augmentedSquare]

def augmentedDet (w : J → E → S) (rows : Option J → E) : (E → S) →ₗ[S] S where
  toFun v := (augmentedSquare w rows v).det
  map_add' u v := by
    rw [augmentedSquare_update w rows (u + v), augmentedSquare_update w rows u,
      augmentedSquare_update w rows v]
    exact Matrix.det_updateCol_add _ none _ _
  map_smul' a v := by
    rw [augmentedSquare_update w rows (a • v), augmentedSquare_update w rows v]
    simpa only [RingHom.id_apply, Pi.smul_def, smul_eq_mul] using
      Matrix.det_updateCol_smul (augmentedSquare w rows 0) none a (fun i => v (rows i))

theorem augmentedDet_column (w : J → E → S) (rows : Option J → E) (j : J) :
    augmentedDet w rows (w j) = 0 := by
  apply Matrix.det_zero_of_column_eq (i := none) (j := some j) (by simp)
  intro i
  rfl

theorem augmentedDet_of_mem (w : J → E → S) (rows : Option J → E) {v : E → S}
    (hv : v ∈ Submodule.span S (Set.range w)) : augmentedDet w rows v = 0 := by
  have hspan : Submodule.span S (Set.range w) ≤ LinearMap.ker (augmentedDet w rows) := by
    refine Submodule.span_le.mpr ?_
    rintro _ ⟨j, rfl⟩
    exact augmentedDet_column w rows j
  exact hspan hv

theorem map_augmentedDet {S' : Type*} [CommRing S'] (f : S →+* S')
    (w : J → E → S) (rows : Option J → E) (v : E → S) :
    f (augmentedDet w rows v) =
      augmentedDet (fun j e => f (w j e)) rows (fun e => f (v e)) := by
  change f (augmentedSquare w rows v).det = _
  rw [f.map_det]
  congr 1
  ext i j
  cases j <;> rfl

end AugmentedDeterminants

section Degrees

theorem linearPolynomial_degree (point : E → Fin r → Bool) (i : Fin 3) (e : E) :
    (linearPolynomial point i e).totalDegree ≤ 1 := by
  apply MvPolynomial.totalDegree_finsetSum_le
  intro j _
  cases point e j <;> simp

theorem zPolynomial_degree (point : E → Fin r → Bool) (i : Fin 3) (e : E) :
    (zPolynomial point i e).totalDegree ≤ 2 := by
  apply MvPolynomial.totalDegree_finsetSum_le
  intro j _
  cases point e j <;> simp

theorem matrixPolynomial_degree (point : E → Fin r → Bool) (e : E) (ij : Variables r) :
    (matrixPolynomial point e ij).totalDegree ≤ 2 := by
  cases h : point e ij.2 <;> simp [matrixPolynomial, h, zPolynomial_degree]

theorem responsePolynomial_degree (point : E → Fin r → Bool) (e : E) :
    (responsePolynomial point e).totalDegree ≤ 3 := by
  have h0 := linearPolynomial_degree point (0 : Fin 3) e
  have h1 := linearPolynomial_degree point (1 : Fin 3) e
  have h2 := linearPolynomial_degree point (2 : Fin 3) e
  have h01 := MvPolynomial.totalDegree_mul
    (linearPolynomial point 0 e) (linearPolynomial point 1 e)
  have h012 := MvPolynomial.totalDegree_mul
    (linearPolynomial point 0 e * linearPolynomial point 1 e) (linearPolynomial point 2 e)
  unfold responsePolynomial
  omega

theorem determinant_degree {σ N : Type*} [Fintype N] [DecidableEq N]
    (M : Matrix N N (MvPolynomial σ (ZMod 2))) (bounds : N → ℕ)
    (hdegree : ∀ i j, (M i j).totalDegree ≤ bounds j) :
    M.det.totalDegree ≤ ∑ j : N, bounds j := by
  rw [Matrix.det_apply]
  apply MvPolynomial.totalDegree_finsetSum_le
  intro p _
  rw [Units.smul_def]
  apply (MvPolynomial.totalDegree_smul_le (p.sign : ℤ) _).trans
  apply (MvPolynomial.totalDegree_finsetProd _ _).trans
  exact Finset.sum_le_sum fun j _ => hdegree (p j) j

theorem augmentedDet_degree {J : Type*} [Fintype J] [DecidableEq J]
    (w : J → E → Polynomial r) (rows : Option J → E) (v : E → Polynomial r)
    {D d : ℕ} (hw : ∀ j e, (w j e).totalDegree ≤ D)
    (hv : ∀ e, (v e).totalDegree ≤ d) :
    (augmentedDet w rows v).totalDegree ≤ Fintype.card J * D + d := by
  have h := determinant_degree (augmentedSquare w rows v)
    (fun j => j.elim d (fun _ => D)) (by
      intro i j
      cases j with
      | none => exact hv (rows i)
      | some j => exact hw j (rows i))
  simpa [augmentedDet, Fintype.sum_option, Nat.mul_comm, Nat.add_comm] using h

end Degrees

def Aligned {S : Type*} [CommRing S] (point : E → Fin r → Bool)
    (f : Polynomial r →+* S) : Prop :=
  (fun e => f (responsePolynomial point e)) ∈ Submodule.span S
    (Set.range (fun ij : Variables r => fun e => f (matrixPolynomial point e ij)))

theorem exists_alignment_polynomial [Fintype E]
    (point : E → Fin r → Bool) (hinjective : Function.Injective point)
    (hnonzero : ∀ e, ∃ j, point e j = true) (hlarge : 3 * r < Fintype.card E) :
    ∃ P : Polynomial r, P ≠ 0 ∧ P.totalDegree ≤ 6 * r + 3 ∧
      ∀ (S : Type*) [CommRing S] (f : Polynomial r →+* S),
        Aligned point f → f P = 0 := by
  classical
  let emb : Polynomial r →+* FunctionField r := algebraMap _ _
  let v : Variables r → E → FunctionField r :=
    fun ij e => emb (matrixPolynomial point e ij)
  obtain ⟨J, a, ha, hspan, hli⟩ := exists_linearIndependent' (FunctionField r) v
  letI : Finite J := Finite.of_injective a ha
  letI : Fintype J := Fintype.ofFinite J
  let w : J → E → Polynomial r := fun j e => matrixPolynomial point e (a j)
  have hc : response point ∉
      Submodule.span (FunctionField r) (Set.range (v ∘ a)) := by
    rw [hspan]
    exact actual_matrix_nonmembership point hinjective hnonzero hlarge
  let b : Option J → E → FunctionField r :=
    fun j => j.casesOn' (response point) (v ∘ a)
  have hb : LinearIndependent (FunctionField r) b := hli.option hc
  obtain ⟨rows, hminor⟩ := independent_has_minor b hb
  let P : Polynomial r := augmentedDet w rows (responsePolynomial point)
  have hP : P ≠ 0 := by
    intro hzero
    have hnonzero : augmentedDet (fun j e => emb (w j e)) rows
        (fun e => emb (responsePolynomial point e)) ≠ 0 := by
      change (augmentedSquare (fun j e => emb (w j e)) rows
        (fun e => emb (responsePolynomial point e))).det ≠ 0
      have heq : augmentedSquare (fun j e => emb (w j e)) rows
          (fun e => emb (responsePolynomial point e)) =
          Matrix.of (fun i j => b j (rows i)) := by
        ext i j
        cases j <;> rfl
      rw [heq]
      exact hminor
    apply hnonzero
    rw [← map_augmentedDet]
    exact congrArg emb hzero |>.trans (map_zero emb)
  have hcard : Fintype.card J ≤ 3 * r := by
    calc
      Fintype.card J ≤ Fintype.card (Variables r) := Fintype.card_le_of_injective a ha
      _ = 3 * r := by simp [Variables]
  have hdegree : P.totalDegree ≤ 6 * r + 3 := by
    have hbound := augmentedDet_degree w rows (responsePolynomial point)
      (D := 2) (d := 3) (fun j e => matrixPolynomial_degree point e (a j))
      (responsePolynomial_degree point)
    change P.totalDegree ≤ _ at hbound
    omega
  have hzero : ∀ ij : Variables r,
      augmentedDet w rows (fun e => matrixPolynomial point e ij) = 0 := by
    intro ij
    apply IsFractionRing.injective (Polynomial r) (FunctionField r)
    rw [map_augmentedDet, map_zero]
    apply augmentedDet_of_mem
    change v ij ∈ Submodule.span (FunctionField r) (Set.range (v ∘ a))
    rw [hspan]
    exact Submodule.subset_span (Set.mem_range_self ij)
  refine ⟨P, hP, hdegree, ?_⟩
  intro S _ f haligned
  change f (augmentedDet w rows (responsePolynomial point)) = 0
  rw [map_augmentedDet]
  have hker : Submodule.span S
      (Set.range (fun ij : Variables r => fun e => f (matrixPolynomial point e ij))) ≤
      LinearMap.ker (augmentedDet (fun j e => f (w j e)) rows) := by
    refine Submodule.span_le.mpr ?_
    rintro _ ⟨ij, rfl⟩
    change augmentedDet (fun j e => f (w j e)) rows
      (fun e => f (matrixPolynomial point e ij)) = 0
    rw [← map_augmentedDet, hzero ij, map_zero]
  exact hker haligned

def specialize {S : Type*} [CommRing S] [CharP S 2] (T : Variables r → S) :
    Polynomial r →+* S :=
  MvPolynomial.eval₂Hom (ZMod.castHom (dvd_refl 2) S) T

theorem specialize_matrix {S : Type*} [CommRing S] [CharP S 2]
    (T : Variables r → S) (point : E → Fin r → Bool) (e : E) (ij : Variables r) :
    specialize T (matrixPolynomial point e ij) =
      (if point e ij.2 then 1 else 0) *
        ∑ k : Fin r, T (ij.1, k) ^ 2 * (if point e k then 1 else 0) := by
  cases h : point e ij.2 <;>
    simp [specialize, matrixPolynomial, zPolynomial, h, apply_ite]

theorem specialize_response {S : Type*} [CommRing S] [CharP S 2]
    (T : Variables r → S) (point : E → Fin r → Bool) (e : E) :
    specialize T (responsePolynomial point e) =
      (∑ j : Fin r, T (0, j) * (if point e j then 1 else 0)) *
        (∑ j : Fin r, T (1, j) * (if point e j then 1 else 0)) *
        (∑ j : Fin r, T (2, j) * (if point e j then 1 else 0)) := by
  simp [specialize, responsePolynomial, linearPolynomial, apply_ite]

theorem specialized_response_unique_square_root {S : Type*} [Field S] [CharP S 2]
    (T : Variables r → S) (point : E → Fin r → Bool) (e : E) (y : S) :
    y ^ 2 = specialize T (zPolynomial point 0 e) *
        specialize T (zPolynomial point 1 e) * specialize T (zPolynomial point 2 e) ↔
      y = specialize T (responsePolynomial point e) := by
  have hc := congrArg (specialize T) (responsePolynomial_sq point e)
  simp only [map_pow, map_mul] at hc
  constructor
  · intro hy
    apply (frobenius S 2).injective
    exact hy.trans hc.symm
  · rintro rfl
    exact hc

theorem exists_alignment_polynomial_specialization [Fintype E]
    (point : E → Fin r → Bool) (hinjective : Function.Injective point)
    (hnonzero : ∀ e, ∃ j, point e j = true) (hlarge : 3 * r < Fintype.card E) :
    ∃ P : Polynomial r, P ≠ 0 ∧ P.totalDegree ≤ 6 * r + 3 ∧
      ∀ (S : Type*) [CommRing S] [CharP S 2] (T : Variables r → S),
        (∃ weights : Variables r → S, ∀ e,
          (∑ ij : Variables r, weights ij *
            ((if point e ij.2 then 1 else 0) *
              ∑ k : Fin r, T (ij.1, k) ^ 2 * (if point e k then 1 else 0))) =
            (∑ j : Fin r, T (0, j) * (if point e j then 1 else 0)) *
              (∑ j : Fin r, T (1, j) * (if point e j then 1 else 0)) *
              (∑ j : Fin r, T (2, j) * (if point e j then 1 else 0))) →
        specialize T P = 0 := by
  obtain ⟨P, hP, hdegree, hvanish⟩ :=
    exists_alignment_polynomial point hinjective hnonzero hlarge
  refine ⟨P, hP, hdegree, ?_⟩
  intro S _ _ T hweights
  apply hvanish S (specialize T)
  obtain ⟨weights, hweights⟩ := hweights
  apply (Submodule.mem_span_range_iff_exists_fun S).mpr
  refine ⟨weights, ?_⟩
  ext e
  simpa only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul, specialize_matrix,
    specialize_response] using hweights e

#print axioms independent_has_minor
#print axioms specialized_response_unique_square_root
#print axioms exists_alignment_polynomial
#print axioms exists_alignment_polynomial_specialization

end LatentAlignment
