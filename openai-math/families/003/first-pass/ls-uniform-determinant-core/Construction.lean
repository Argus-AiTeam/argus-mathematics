import Mathlib

noncomputable section

open scoped BigOperators
open Finset Matrix LSRectInterpolation

namespace LSChain

theorem lattice_selection : LSRectInterpolation.LatticeFaceSelection := by
  exact LSLatticeGeometry.latticeFaceSelection

theorem interpolation
    (N : ℕ) (hN : 1 ≤ N) (t : Fin 3 → ℕ)
    (ht : ∀ j, 3 * (N - 1) ≤ t j)
    (hdim : (4 * N - 3) ^ 4 < ∏ j, (t j - 3 * (N - 1) + 1))
    (A : C4 →ₗ[ℂ] C3) (hA : Function.Surjective A)
    (c : C4) (hker : ∀ x, A x = 0 ↔ ∃ s : ℂ, x = s • c)
    (hc : LinearIndependent ℚ c) :
    Submodule.span ℂ (Set.range (monomialRow A N t)) = ⊤ :=
  projected_box_monomial_span_of_selection lattice_selection N hN t ht hdim A hA c hker hc

def weight (H : ℕ) (a : Fin 3 → ℕ) : ℕ := a 0 + H * (a 1 + a 2)

def Candidate (H W : ℕ) :=
  {a : Fin 3 → Fin (W + 1) // weight H (fun j => (a j).val) ≤ W}

instance (H W : ℕ) : Fintype (Candidate H W) := inferInstanceAs (Fintype (Subtype _))

def candidateExponent {H W : ℕ} (a : Candidate H W) : Fin 3 → ℕ :=
  fun j => (a.val j).val

def candidateKey {H W : ℕ} (a : Candidate H W) :
    ℕ ×ₗ Lex (Fin 3 → Fin (W + 1)) :=
  toLex (weight H (candidateExponent a), toLex a.val)

theorem candidateKey_injective (H W : ℕ) : Function.Injective (@candidateKey H W) := by
  intro a b h
  apply Subtype.ext
  exact congrArg (fun x => ofLex (ofLex x).2) h

instance (H W : ℕ) : LinearOrder (Candidate H W) :=
  LinearOrder.lift' candidateKey (candidateKey_injective H W)

theorem candidate_lt_of_weight_lt {H W : ℕ} (a b : Candidate H W)
    (h : weight H (candidateExponent a) < weight H (candidateExponent b)) : a < b := by
  exact Prod.Lex.left _ _ h

def makeCandidate {H W : ℕ} (a : Fin 3 → ℕ)
    (ha : ∀ j, a j ≤ W) (hw : weight H a ≤ W) : Candidate H W :=
  ⟨fun j => ⟨a j, Nat.lt_succ_iff.mpr (ha j)⟩, hw⟩

@[simp] theorem exponent_makeCandidate {H W : ℕ} (a : Fin 3 → ℕ)
    (ha : ∀ j, a j ≤ W) (hw : weight H a ≤ W) :
    candidateExponent (makeCandidate a ha hw) = a := rfl

theorem coordinate_le_weight (H : ℕ) (hH : 1 ≤ H) (a : Fin 3 → ℕ) (j : Fin 3) :
    a j ≤ weight H a := by
  have h1 : a 1 + a 2 ≤ H * (a 1 + a 2) := Nat.le_mul_of_pos_left _ hH
  fin_cases j
  · change a 0 ≤ a 0 + H * (a 1 + a 2)
    omega
  · change a 1 ≤ a 0 + H * (a 1 + a 2)
    omega
  · change a 2 ≤ a 0 + H * (a 1 + a 2)
    omega

def row {R : Type*} [CommMonoid R] {X : Type*} (x : X → Fin 3 → R)
    (a : Fin 3 → ℕ) : X → R :=
  fun n => x n 0 ^ a 0 * x n 1 ^ a 1 * x n 2 ^ a 2

def candidateRow {R : Type*} [CommMonoid R] {X : Type*} {H W : ℕ}
    (x : X → Fin 3 → R) (a : Candidate H W) : X → R :=
  row x (candidateExponent a)

theorem row_eq_product {R : Type*} [CommMonoid R] {X : Type*}
    (x : X → Fin 3 → R) (a : Fin 3 → ℕ) (n : X) :
    row x a n = ∏ j, x n j ^ a j := by
  simp [row, Fin.prod_univ_succ, mul_assoc]

theorem bounded_candidate_span
    (N H W : ℕ) (hH : 1 ≤ H) (t : Fin 3 → ℕ)
    (A : C4 →ₗ[ℂ] C3)
    (hspan : Submodule.span ℂ (Set.range (monomialRow A N t)) = ⊤)
    (hweight : t 0 + H * (t 1 + t 2) ≤ W) :
    Submodule.span ℂ
      (Set.range (candidateRow (H := H) (W := W)
        (fun n : intBox N => A (castPoint n)))) = ⊤ := by
  apply top_unique
  rw [← hspan]
  apply Submodule.span_mono
  rintro _ ⟨a, rfl⟩
  let e : Fin 3 → ℕ := fun j => (a j).val
  have he : weight H e ≤ W := by
    have h0 := (a 0).isLt
    have h1 := (a 1).isLt
    have h2 := (a 2).isLt
    dsimp [weight, e]
    nlinarith
  let q := makeCandidate e
    (fun j => (coordinate_le_weight H hH e j).trans he) he
  refine ⟨q, ?_⟩
  funext n
  exact row_eq_product _ _ _

def gridEnumeration (N : ℕ) : Fin (N ^ 4) ≃ intBox N :=
  (Fintype.equivFinOfCardEq (by simpa using card_intBox N)).symm

theorem enumerate_span
    {ι X : Type*} [Fintype X] (r : ι → X → ℂ) {n : ℕ} (e : Fin n ≃ X)
    (h : Submodule.span ℂ (Set.range r) = ⊤) :
    Submodule.span ℂ (Set.range fun i j => r i (e j)) = ⊤ := by
  let L : (X → ℂ) ≃ₗ[ℂ] (Fin n → ℂ) :=
    LinearEquiv.funCongrLeft ℂ ℂ e
  have hm := congrArg (Submodule.map L.toLinearMap) h
  have hset : L.toLinearMap '' Set.range r = Set.range (fun i j => r i (e j)) := by
    ext y
    constructor
    · rintro ⟨_, ⟨i, rfl⟩, rfl⟩
      exact ⟨i, rfl⟩
    · rintro ⟨i, rfl⟩
      exact ⟨r i, ⟨i, rfl⟩, rfl⟩
  rw [Submodule.map_span, hset, Submodule.map_top,
    LinearMap.range_eq_top.mpr L.surjective] at hm
  exact hm

theorem bounded_greedy_construction
    (N : ℕ) (hN : 1 ≤ N) (H W : ℕ) (hH : 1 ≤ H)
    [LinearOrder (Candidate H W)]
    (t : Fin 3 → ℕ) (ht : ∀ j, 3 * (N - 1) ≤ t j)
    (hdim : (4 * N - 3) ^ 4 < ∏ j, (t j - 3 * (N - 1) + 1))
    (hweight : t 0 + H * (t 1 + t 2) ≤ W)
    (A : C4 →ₗ[ℂ] C3) (hA : Function.Surjective A)
    (c : C4) (hker : ∀ x, A x = 0 ↔ ∃ s : ℂ, x = s • c)
    (hc : LinearIndependent ℚ c) :
    ∃ g : Fin (N ^ 4) ↪o Candidate H W,
      Set.range g = LSGenericGreedy.greedySet ℂ
        (fun a j => candidateRow (fun n : intBox N => A (castPoint n)) a
          (gridEnumeration N j)) ∧
      Matrix.det (Matrix.of fun i j =>
        candidateRow (fun n : intBox N => A (castPoint n)) (g i)
          (gridEnumeration N j)) ≠ 0 ∧
      (∀ i, weight H (candidateExponent (g i)) ≤ W) ∧
      ∀ i a, a < g i →
        (fun j => candidateRow (fun n : intBox N => A (castPoint n)) a
          (gridEnumeration N j)) ∈
        Submodule.span ℂ ((fun k j =>
          candidateRow (fun n : intBox N => A (castPoint n)) (g k)
            (gridEnumeration N j)) '' Set.Iio i) := by
  let r := candidateRow (H := H) (W := W)
    (fun n : intBox N => A (castPoint n))
  have hs := bounded_candidate_span N H W hH t A
    (interpolation N hN t ht hdim A hA c hker hc) hweight
  have he := enumerate_span r (gridEnumeration N) hs
  obtain ⟨_, g, _, hg, _, _, hdet, hprefix⟩ :=
    LSGenericGreedy.ordered_greedy_construction ℂ
      (fun a j => r a (gridEnumeration N j)) he
  exact ⟨g, hg, hdet, fun i => (g i).property, hprefix⟩

def target {R : Type*} (x : Fin 3 → R) (side : Bool) : R :=
  if side then x 1 else x 2

def shift (a : Fin 3 → ℕ) (p m : ℕ) (side : Bool) : Fin 3 → ℕ :=
  ![a 0 - p * m, a 1 + (if side then m else 0), a 2 + (if side then 0 else m)]

@[simp] theorem shift_zero (a : Fin 3 → ℕ) (p : ℕ) (side : Bool) :
    shift a p 0 side = a := by
  ext j
  fin_cases j <;> simp [shift]

theorem shift_weight_lt (H : ℕ) (a : Fin 3 → ℕ) (p m : ℕ) (side : Bool)
    (hp : H < p) (hm : 0 < m) (ha : p * m ≤ a 0) :
    weight H (shift a p m side) < weight H a := by
  cases side <;> simp only [shift, weight, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Bool.false_eq_true, if_false, if_true, add_zero]
  · have hh := UniformDeterminant.replacement_weight_drop (a 0) (a 2) (a 1) H p m hm hp ha
    simpa [add_comm, add_left_comm, add_assoc] using hh
  · exact UniformDeterminant.replacement_weight_drop (a 0) (a 1) (a 2) H p m hm hp ha

def replacementRow {R : Type*} [CommRing R] {X : Type*}
    (x : X → Fin 3 → R) (a : Fin 3 → ℕ) (p : ℕ) (side : Bool) : X → R :=
  fun n => x n 0 ^ (a 0 % p) * (x n 0 ^ p - target (x n) side) ^ (a 0 / p) *
    x n 1 ^ a 1 * x n 2 ^ a 2

set_option maxRecDepth 2048 in
theorem replacement_expansion {R : Type*} [CommRing R] {X : Type*}
    (x : X → Fin 3 → R) (a : Fin 3 → ℕ) (p : ℕ) (side : Bool) :
    replacementRow x a p side =
      ∑ m ∈ range (a 0 / p + 1),
        ((-1 : R) ^ m * ((a 0 / p).choose m : R)) • row x (shift a p m side) := by
  classical
  funext n
  simp only [replacementRow, Finset.sum_apply, Pi.smul_apply, smul_eq_mul]
  have hbase : x n 0 ^ p - target (x n) side =
      -target (x n) side + x n 0 ^ p := by ring
  rw [hbase, add_pow, Finset.mul_sum, Finset.sum_mul, Finset.sum_mul]
  apply sum_congr rfl
  intro m hm
  have hmk : m ≤ a 0 / p := by simpa only [Finset.mem_range, Nat.lt_succ_iff] using hm
  have hpm : p * m ≤ p * (a 0 / p) := Nat.mul_le_mul_left p hmk
  have hdiv := Nat.mod_add_div (a 0) p
  have hsub : a 0 - p * m = a 0 % p + p * (a 0 / p - m) := by
    rw [Nat.mul_sub_left_distrib]
    omega
  have hneg : (-target (x n) side) ^ m =
      (-1 : R) ^ m * target (x n) side ^ m := by
    rw [neg_eq_neg_one_mul, mul_pow]
  rw [hneg]
  cases side <;> simp only [target, Bool.false_eq_true, if_false, if_true, shift,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two, row,
    add_zero, hsub, pow_add, pow_mul]
  all_goals dsimp only [Matrix.vecHead, Matrix.vecTail, Function.comp_apply]
  all_goals simp only [Matrix.cons_val_succ, Matrix.cons_val_zero, pow_add]
  all_goals ring

theorem shifted_candidate {H W : ℕ} [LinearOrder (Candidate H W)]
    (horder : ∀ a b : Candidate H W,
      weight H (candidateExponent a) < weight H (candidateExponent b) → a < b)
    (hH : 1 ≤ H) (a : Candidate H W)
    (p m : ℕ) (side : Bool) (hp : H < p) (hm : 0 < m)
    (hmk : m ≤ candidateExponent a 0 / p) :
    ∃ b : Candidate H W, b < a ∧
      candidateExponent b = shift (candidateExponent a) p m side := by
  have hpm : p * m ≤ candidateExponent a 0 :=
    (Nat.mul_le_mul_left p hmk).trans (Nat.mul_div_le _ _)
  have hlt := shift_weight_lt H (candidateExponent a) p m side hp hm hpm
  have hw : weight H (shift (candidateExponent a) p m side) ≤ W :=
    hlt.le.trans a.property
  let b := makeCandidate (shift (candidateExponent a) p m side)
    (fun j => (coordinate_le_weight H hH _ j).trans hw) hw
  exact ⟨b, horder b a hlt, rfl⟩

theorem replacement_difference_mem
    {H W n : ℕ} [LinearOrder (Candidate H W)]
    (horder : ∀ a b : Candidate H W,
      weight H (candidateExponent a) < weight H (candidateExponent b) → a < b)
    (hH : 1 ≤ H) (x : Fin n → Fin 3 → ℂ)
    (g : Fin n ↪o Candidate H W)
    (hprefix : ∀ i a, a < g i →
      candidateRow x a ∈
        Submodule.span ℂ ((fun k => candidateRow x (g k)) '' Set.Iio i))
    (p : ℕ) (side : Bool) (hp : H < p) (i : Fin n) :
    replacementRow x (candidateExponent (g i)) p side - candidateRow x (g i) ∈
      Submodule.span ℂ ((fun k => candidateRow x (g k)) '' Set.Iio i) := by
  classical
  let a := candidateExponent (g i)
  let T (m : ℕ) : Fin n → ℂ :=
    ((-1 : ℂ) ^ m * ((a 0 / p).choose m : ℂ)) • row x (shift a p m side)
  have h0 : T 0 = candidateRow x (g i) := by simp [T, a, candidateRow]
  have heq : replacementRow x a p side - candidateRow x (g i) =
      ∑ m ∈ (range (a 0 / p + 1)).erase 0, T m := by
    rw [replacement_expansion]
    change (∑ m ∈ range (a 0 / p + 1), T m) - candidateRow x (g i) = _
    rw [← sum_erase_add _ _ (by simp : 0 ∈ range (a 0 / p + 1)), h0]
    abel
  rw [heq]
  apply Submodule.sum_mem
  intro m hm
  have hm0 : 0 < m := Nat.pos_of_ne_zero (mem_erase.mp hm).1
  have hmk : m ≤ a 0 / p := by
    simpa only [Finset.mem_range, Nat.lt_succ_iff] using (mem_erase.mp hm).2
  obtain ⟨b, hbi, hb⟩ := shifted_candidate horder hH (g i) p m side hp hm0 hmk
  have hmem := hprefix i b hbi
  have hrow : row x (shift a p m side) = candidateRow x b := by
    rw [candidateRow, hb]
  change ((-1 : ℂ) ^ m * ((a 0 / p).choose m : ℂ)) • _ ∈ _
  exact Submodule.smul_mem _ _ (hrow ▸ hmem)

theorem row_coordinate_bound {H W : ℕ} (hH : 1 ≤ H) (a : Candidate H W)
    (j : Fin 3) (hj : j = 1 ∨ j = 2) :
    candidateExponent a j ≤ W / H := by
  have hmul : candidateExponent a j * H ≤ W := by
    rcases hj with rfl | rfl
    · have h := a.property
      change candidateExponent a 0 + H *
        (candidateExponent a 1 + candidateExponent a 2) ≤ W at h
      nlinarith
    · have h := a.property
      change candidateExponent a 0 + H *
        (candidateExponent a 1 + candidateExponent a 2) ≤ W at h
      nlinarith
  exact (Nat.le_div_iff_mul_le hH).mpr hmul

@[simp] theorem map_row
    {R S : Type*} [CommRing R] [CommRing S] {X : Type*}
    (f : R →+* S) (x : X → Fin 3 → R) (a : Fin 3 → ℕ) (n : X) :
    f (row x a n) = row (fun n j => f (x n j)) a n := by
  simp [row]

@[simp] theorem map_replacementRow
    {R S : Type*} [CommRing R] [CommRing S] {X : Type*}
    (f : R →+* S) (x : X → Fin 3 → R)
    (a : Fin 3 → ℕ) (p : ℕ) (side : Bool) (n : X) :
    f (replacementRow x a p side n) =
      replacementRow (fun n j => f (x n j)) a p side n := by
  cases side <;> simp [replacementRow, target]

def retainedMatrix {R : Type*} [CommRing R] {H W n : ℕ}
    [LinearOrder (Candidate H W)]
    (x : Fin n → Fin 3 → R) (g : Fin n ↪o Candidate H W) :
    Matrix (Fin n) (Fin n) R :=
  Matrix.of fun i => candidateRow x (g i)

theorem constructed_core
    {R : Type*} [CommRing R]
    (f : R →+* ℂ) (hf : Function.Injective f)
    (N : ℕ) (hN : 1 ≤ N) (H W : ℕ) (hH : 1 ≤ H)
    [LinearOrder (Candidate H W)]
    (horder : ∀ a b : Candidate H W,
      weight H (candidateExponent a) < weight H (candidateExponent b) → a < b)
    (t : Fin 3 → ℕ) (ht : ∀ j, 3 * (N - 1) ≤ t j)
    (hdim : (4 * N - 3) ^ 4 < ∏ j, (t j - 3 * (N - 1) + 1))
    (hweight : t 0 + H * (t 1 + t 2) ≤ W)
    (hlarge : 2 * (W / H + 1) ^ 2 ≤ N ^ 4)
    (A : C4 →ₗ[ℂ] C3) (hA : Function.Surjective A)
    (c : C4) (hker : ∀ x, A x = 0 ↔ ∃ s : ℂ, x = s • c)
    (hc : LinearIndependent ℚ c)
    (coordinates : intBox N → Fin 3 → R)
    (hcoordinates : ∀ n j, f (coordinates n j) = A (castPoint n) j)
    (P : Finset ℕ) (side : ℕ → Bool)
    (hp : ∀ p ∈ P, H < p)
    (hcongruence : ∀ p ∈ P, ∀ n,
      (p : R) ∣ coordinates n 0 ^ p - target (coordinates n) (side p)) :
    ∃ g : Fin (N ^ 4) ↪o Candidate H W,
      let x := fun j => coordinates (gridEnumeration N j)
      Set.range g = LSGenericGreedy.greedySet ℂ
        (fun a j => f (candidateRow x a j)) ∧
      (retainedMatrix x g).det ≠ 0 ∧
      (∀ i, weight H (candidateExponent (g i)) ≤ W) ∧
      (∀ p ∈ P, (p : R) ^ (∑ i, candidateExponent (g i) 0 / p) ∣
        (retainedMatrix x g).det) ∧
      (N ^ 4) ^ 2 ≤ 4 * (W / H + 1) ^ 2 *
        (∑ i, candidateExponent (g i) 0) ∧
      (∑ i, (candidateExponent (g i) 1 + candidateExponent (g i) 2)) ≤
        2 * (W / H) * N ^ 4 := by
  classical
  obtain ⟨g, hgreedy, hdetC, hweights, hprefix⟩ :=
    bounded_greedy_construction N hN H W hH t ht hdim hweight A hA c hker hc
  let x : Fin (N ^ 4) → Fin 3 → R := fun j => coordinates (gridEnumeration N j)
  let xC : Fin (N ^ 4) → Fin 3 → ℂ := fun j k => f (x j k)
  let D := retainedMatrix x g
  have hxC : xC = fun j => A (castPoint (gridEnumeration N j)) := by
    funext j k
    exact hcoordinates (gridEnumeration N j) k
  have hmap : f.mapMatrix D = retainedMatrix xC g := by
    ext i j
    simp [D, retainedMatrix, candidateRow, xC]
  have hmapC : retainedMatrix xC g =
      Matrix.of (fun i j => candidateRow (fun n : intBox N => A (castPoint n))
        (g i) (gridEnumeration N j)) := by
    rw [hxC]
    rfl
  have hdet : D.det ≠ 0 := by
    intro hz
    have he := f.map_det D
    rw [hz, map_zero, hmap, hmapC] at he
    exact hdetC he.symm
  have hpre : ∀ i a, a < g i →
      candidateRow xC a ∈
        Submodule.span ℂ ((fun k => candidateRow xC (g k)) '' Set.Iio i) := by
    intro i a hai
    rw [hxC]
    exact hprefix i a hai
  let replacement (p : ℕ) : Matrix (Fin (N ^ 4)) (Fin (N ^ 4)) R :=
    Matrix.of fun i => replacementRow x (candidateExponent (g i)) p (side p)
  have hC : ∀ p ∈ P, ∃ C : Matrix (Fin (N ^ 4)) (Fin (N ^ 4)) ℂ,
      (∀ i j, i ≤ j → C i j = 0) ∧
        f.mapMatrix (replacement p) = (1 + C) * f.mapMatrix D := by
    intro p hpp
    have hBmap : f.mapMatrix (replacement p) =
        Matrix.of (fun i => replacementRow xC (candidateExponent (g i)) p (side p)) := by
      ext i j
      simp [replacement, xC]
    rw [hBmap, hmap]
    apply LSGenericGreedy.exists_strictLowerTriangular_replacement ℂ
    intro i
    have hh := replacement_difference_mem horder hH xC g hpre p (side p) (hp p hpp) i
    exact hh
  let coefficients (p : ℕ) : Matrix (Fin (N ^ 4)) (Fin (N ^ 4)) ℂ :=
    if hpp : p ∈ P then Classical.choose (hC p hpp) else 0
  have htri : ∀ p ∈ P, ∀ i j, i ≤ j → coefficients p i j = 0 := by
    intro p hpp
    dsimp only [coefficients]
    rw [dif_pos hpp]
    exact (Classical.choose_spec (hC p hpp)).1
  have hreplace : ∀ p ∈ P,
      f.mapMatrix (replacement p) = (1 + coefficients p) * f.mapMatrix D := by
    intro p hpp
    dsimp only [coefficients]
    rw [dif_pos hpp]
    exact (Classical.choose_spec (hC p hpp)).2
  have hentry : ∀ p ∈ P, ∀ i j,
      (p : R) ^ (candidateExponent (g i) 0 / p) ∣ replacement p i j := by
    intro p hpp i j
    simpa [replacement, replacementRow, mul_assoc] using
      UniformDeterminant.frobenius_row_factor (x j 0)
        (target (x j) (side p)) (x j 1 ^ candidateExponent (g i) 1 *
          x j 2 ^ candidateExponent (g i) 2) (p : R)
        (candidateExponent (g i) 0 % p) (candidateExponent (g i) 0 / p) p
        (hcongruence p hpp (gridEnumeration N j))
  have hinj : Function.Injective (fun i : Fin (N ^ 4) =>
      (candidateExponent (g i) 0, candidateExponent (g i) 1,
        candidateExponent (g i) 2)) := by
    intro i j hij
    apply g.injective
    apply Subtype.ext
    ext k
    fin_cases k
    · exact congrArg Prod.fst hij
    · exact congrArg (fun z => z.2.1) hij
    · exact congrArg (fun z => z.2.2) hij
  have hcore := UniformDeterminant.uniform_core f hf D hdet
    (fun i => candidateExponent (g i) 0)
    (fun i => candidateExponent (g i) 1)
    (fun i => candidateExponent (g i) 2) (W / H) hinj
    (fun i => row_coordinate_bound hH (g i) 1 (Or.inl rfl))
    (fun i => row_coordinate_bound hH (g i) 2 (Or.inr rfl))
    hlarge P replacement coefficients htri hreplace hentry
  refine ⟨g, ?_, hcore.1, hweights, hcore.2.1, hcore.2.2.1, hcore.2.2.2⟩
  simpa [candidateRow, row, x, hcoordinates] using hgreedy

end LSChain
