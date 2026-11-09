import Mathlib

noncomputable section

open scoped BigOperators
open Finset Matrix

namespace UniformDeterminant

theorem replacement_weight_drop
    (a b c H p m : ℕ) (hm : 0 < m) (hp : H < p) (ha : p * m ≤ a) :
    (a - p * m) + H * (b + m + c) < a + H * (b + c) := by
  have hdrop : H * m < p * m := Nat.mul_lt_mul_of_pos_right hp hm
  simp only [Nat.mul_add]
  omega

theorem determinant_row_factors
    {R : Type*} [CommRing R] {n : ℕ}
    (B : Matrix (Fin n) (Fin n) R) (p : R) (k : Fin n → ℕ)
    (h : ∀ i j, p ^ k i ∣ B i j) :
    p ^ (∑ i, k i) ∣ B.det := by
  classical
  choose C hC using h
  have hB : B = Matrix.of (fun i j => p ^ k i * C i j) := by
    ext i j
    exact hC i j
  refine ⟨(Matrix.of C).det, ?_⟩
  rw [hB, Matrix.det_mul_column]
  rw [← Finset.prod_pow_eq_pow_sum]
  rfl

theorem determinant_prefix_replacement
    {K : Type*} [CommRing K] {n : ℕ}
    (A B C : Matrix (Fin n) (Fin n) K)
    (hc : ∀ i j, i ≤ j → C i j = 0)
    (hb : B = (1 + C) * A) :
    B.det = A.det := by
  have htri : (1 + C).BlockTriangular OrderDual.toDual := by
    intro i j hij
    have hij' : i < j := hij
    simp [Matrix.add_apply, ne_of_lt hij', hc i j hij'.le]
  have hdiag : ∀ i, (1 + C) i i = 1 := by
    intro i
    simp [hc i i le_rfl]
  rw [hb, Matrix.det_mul, Matrix.det_of_lowerTriangular _ htri]
  simp [hdiag]

theorem integral_replacement_divisibility
    {R K : Type*} [CommRing R] [CommRing K] {n : ℕ}
    (f : R →+* K) (hf : Function.Injective f)
    (A B : Matrix (Fin n) (Fin n) R)
    (C : Matrix (Fin n) (Fin n) K)
    (hc : ∀ i j, i ≤ j → C i j = 0)
    (hb : f.mapMatrix B = (1 + C) * f.mapMatrix A)
    (p : R) (k : Fin n → ℕ)
    (hentry : ∀ i j, p ^ k i ∣ B i j) :
    A.det = B.det ∧ p ^ (∑ i, k i) ∣ A.det := by
  have heq : A.det = B.det := by
    apply hf
    simpa only [RingHom.map_det] using
      (determinant_prefix_replacement (f.mapMatrix A) (f.mapMatrix B) C hc hb).symm
  refine ⟨heq, ?_⟩
  rw [heq]
  exact determinant_row_factors B p k hentry

theorem frobenius_row_factor
    {R : Type*} [CommRing R]
    (x y z p : R) (r k b : ℕ) (h : p ∣ x ^ b - y) :
    p ^ k ∣ x ^ r * (x ^ b - y) ^ k * z := by
  exact dvd_mul_of_dvd_left
    (dvd_mul_of_dvd_right (pow_dvd_pow_of_dvd h k) _) _

theorem simultaneous_coprime_factors
    {R : Type*} [CommRing R] (s : Finset ℕ) (d : ℕ → R) (z : R)
    (hcop : ∀ i ∈ s, ∀ j ∈ s, i ≠ j → IsCoprime (d i) (d j))
    (h : ∀ i ∈ s, d i ∣ z) :
    (∏ i ∈ s, d i) ∣ z := by
  classical
  exact Finset.prod_dvd_of_coprime hcop h

theorem triple_capacity
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (a b c : ι → ℕ) (B : ℕ)
    (hinj : Function.Injective fun i => (a i, b i, c i))
    (hb : ∀ i, b i ≤ B) (hc : ∀ i, c i ≤ B) (i : ι) :
    (univ.filter fun j => a j < a i).card ≤ a i * (B + 1) ^ 2 ∧
      (univ.filter fun j => a j = a i).card ≤ (B + 1) ^ 2 := by
  classical
  constructor
  · have hcard := Finset.card_le_card_of_injOn (f := fun j => (a j, b j, c j))
      (s := univ.filter fun j => a j < a i)
      (t := range (a i) ×ˢ (range (B + 1) ×ˢ range (B + 1)))
      (by
        intro j hj
        exact mem_product.mpr ⟨mem_range.mpr (mem_filter.mp hj).2,
          mem_product.mpr ⟨mem_range.mpr (Nat.lt_succ_iff.mpr (hb j)),
            mem_range.mpr (Nat.lt_succ_iff.mpr (hc j))⟩⟩)
      hinj.injOn
    simpa [Finset.card_product, pow_two, Nat.mul_assoc] using hcard
  · have hcard := Finset.card_le_card_of_injOn (f := fun j => (b j, c j))
      (s := univ.filter fun j => a j = a i)
      (t := range (B + 1) ×ˢ range (B + 1))
      (by
        intro j hj
        exact mem_product.mpr ⟨mem_range.mpr (Nat.lt_succ_iff.mpr (hb j)),
          mem_range.mpr (Nat.lt_succ_iff.mpr (hc j))⟩)
      (by
        intro j hj k hk heq
        apply hinj
        exact Prod.ext ((mem_filter.mp hj).2.trans (mem_filter.mp hk).2.symm) heq)
    simpa [pow_two] using hcard

theorem capacity_packing
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (a : ι → ℕ) (Q : ℕ)
    (hless : ∀ i, (univ.filter fun j => a j < a i).card ≤ Q * a i)
    (heq : ∀ i, (univ.filter fun j => a j = a i).card ≤ Q) :
    (Fintype.card ι) ^ 2 ≤ 2 * Q * (∑ i, a i) + Q * Fintype.card ι := by
  classical
  have hsplit : ∀ i j : ι,
      (1 : ℕ) = (if a j < a i then 1 else 0) +
        (if a i < a j then 1 else 0) + (if a j = a i then 1 else 0) := by
    intro i j
    split_ifs <;> omega
  have hpartition : (Fintype.card ι) ^ 2 =
      2 * (∑ i, (univ.filter fun j => a j < a i).card) +
        ∑ i, (univ.filter fun j => a j = a i).card := by
    simp_rw [Finset.card_filter]
    calc
      (Fintype.card ι) ^ 2 = ∑ i : ι, ∑ j : ι, (1 : ℕ) := by simp [pow_two]
      _ = ∑ i : ι, ∑ j : ι,
          ((if a j < a i then 1 else 0) +
           (if a i < a j then 1 else 0) + (if a j = a i then 1 else 0)) := by
        apply sum_congr rfl
        intro i _
        exact sum_congr rfl (fun j _ => hsplit i j)
      _ = _ := by
        simp only [sum_add_distrib]
        rw [show (∑ i : ι, ∑ j : ι, if a i < a j then 1 else 0) =
          ∑ i : ι, ∑ j : ι, if a j < a i then 1 else 0 from sum_comm]
        omega
  have hl := sum_le_sum (s := (univ : Finset ι)) (fun i _ => hless i)
  have he := sum_le_sum (s := (univ : Finset ι)) (fun i _ => heq i)
  simp only [← mul_sum, sum_const, card_univ, smul_eq_mul] at hl he
  nlinarith

theorem triple_packing
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (a b c : ι → ℕ) (B : ℕ)
    (hinj : Function.Injective fun i => (a i, b i, c i))
    (hb : ∀ i, b i ≤ B) (hc : ∀ i, c i ≤ B) :
    (Fintype.card ι) ^ 2 ≤
      2 * (B + 1) ^ 2 * (∑ i, a i) + (B + 1) ^ 2 * Fintype.card ι := by
  apply capacity_packing
  · intro i
    simpa [Nat.mul_comm] using (triple_capacity a b c B hinj hb hc i).1
  · intro i
    exact (triple_capacity a b c B hinj hb hc i).2

theorem packing_quarter_bound
    (M Q S : ℕ) (hpack : M ^ 2 ≤ 2 * Q * S + Q * M) (hlarge : 2 * Q ≤ M) :
    M ^ 2 ≤ 4 * Q * S := by
  have hMQ : 2 * Q * M ≤ M ^ 2 := by nlinarith
  nlinarith

theorem small_coordinate_sum
    {ι : Type*} [Fintype ι] (b c : ι → ℕ) (B : ℕ)
    (hb : ∀ i, b i ≤ B) (hc : ∀ i, c i ≤ B) :
    (∑ i : ι, (b i + c i)) ≤ 2 * B * Fintype.card ι := by
  classical
  calc
    (∑ i : ι, (b i + c i)) ≤ ∑ _i : ι, 2 * B :=
      sum_le_sum (s := (univ : Finset ι)) fun i _ => by
      have := hb i
      have := hc i
      omega
    _ = _ := by simp [Nat.mul_comm]

theorem uniform_core
    {R K : Type*} [CommRing R] [CommRing K] {n : ℕ}
    (f : R →+* K) (hf : Function.Injective f)
    (A : Matrix (Fin n) (Fin n) R) (hnonzero : A.det ≠ 0)
    (a b c : Fin n → ℕ) (B : ℕ)
    (hinj : Function.Injective fun i => (a i, b i, c i))
    (hb : ∀ i, b i ≤ B) (hc : ∀ i, c i ≤ B)
    (hlarge : 2 * (B + 1) ^ 2 ≤ n)
    (P : Finset ℕ) (replacement : ℕ → Matrix (Fin n) (Fin n) R)
    (coefficients : ℕ → Matrix (Fin n) (Fin n) K)
    (htri : ∀ p ∈ P, ∀ i j, i ≤ j → coefficients p i j = 0)
    (hreplace : ∀ p ∈ P,
      f.mapMatrix (replacement p) = (1 + coefficients p) * f.mapMatrix A)
    (hentry : ∀ p ∈ P, ∀ i j, (p : R) ^ (a i / p) ∣ replacement p i j) :
    A.det ≠ 0 ∧
      (∀ p ∈ P, (p : R) ^ (∑ i, a i / p) ∣ A.det) ∧
      n ^ 2 ≤ 4 * (B + 1) ^ 2 * (∑ i, a i) ∧
      (∑ i : Fin n, (b i + c i)) ≤ 2 * B * n := by
  refine ⟨hnonzero, ?_, ?_, ?_⟩
  · intro p hp
    exact (integral_replacement_divisibility f hf A (replacement p) (coefficients p)
      (htri p hp) (hreplace p hp) (p : R) (fun i => a i / p) (hentry p hp)).2
  · have hpack := triple_packing a b c B hinj hb hc
    simp only [Fintype.card_fin] at hpack
    exact packing_quarter_bound n ((B + 1) ^ 2) (∑ i, a i) hpack hlarge
  · simpa only [Fintype.card_fin] using small_coordinate_sum b c B hb hc

theorem nearest_point_sign
    {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V]
    (h v : V) (η : ℝ) :
    ‖h - η • v‖ ^ 2 =
      ‖h‖ ^ 2 - 2 * η * inner ℝ h v + η ^ 2 * ‖v‖ ^ 2 := by
  rw [norm_sub_sq_real, norm_smul, Real.norm_eq_abs, mul_pow, sq_abs, inner_smul_right]
  ring

theorem strict_distance_drop
    (hh hv hd η : ℝ) (hvpos : 0 < hv) (_hdpos : 0 < hd)
    (hη : 0 < η) (hηmax : η < 2 * hd / hv) :
    hh - 2 * η * hd + η ^ 2 * hv < hh := by
  have hbound : η * hv < 2 * hd := (lt_div_iff₀ hvpos).mp hηmax
  nlinarith [mul_pos hη (sub_pos.mpr hbound)]

theorem affine_hyperplane_lift
    {K V W : Type*} [Field K] [AddCommGroup V] [Module K V]
    [AddCommGroup W] [Module K W]
    (A : V →ₗ[K] W) (hA : Function.Surjective A)
    (c : V) (hker : ∀ x, A x = 0 ↔ ∃ t : K, x = t • c)
    (l : V →ₗ[K] K) (hl : l c ≠ 0) (k : K) (z : W) :
    ∃! x : V, A x = z ∧ l x = k := by
  obtain ⟨x, hx⟩ := hA z
  have hc : A c = 0 := (hker c).mpr ⟨1, by simp⟩
  let y := x + ((k - l x) / l c) • c
  have hyA : A y = z := by simp [y, hx, hc]
  have hyl : l y = k := by
    simp only [y, map_add, map_smul, smul_eq_mul]
    field_simp
    ring
  refine ⟨y, ⟨hyA, hyl⟩, ?_⟩
  intro v hv
  have hd : A (v - y) = 0 := by simp [map_sub, hv.1, hyA]
  obtain ⟨t, ht⟩ := (hker (v - y)).mp hd
  have ht0 : t = 0 := by
    have he := congrArg l ht
    simp only [map_sub, hv.2, hyl, sub_self, map_smul, smul_eq_mul] at he
    exact (mul_eq_zero.mp he.symm).resolve_right hl
  rw [ht0, zero_smul] at ht
  exact sub_eq_zero.mp ht

end UniformDeterminant

noncomputable section

open Set Submodule
open scoped Classical

namespace LSGenericGreedy

universe u v w

section Greedy

variable (K : Type u) [Field K]
variable {ι : Type v} [LinearOrder ι]
variable {V : Type w} [AddCommGroup V] [Module K V]

/-- The actual greedy test uses all earlier candidates, not a preselected basis. -/
def greedySet (row : ι → V) : Set ι :=
  {i | row i ∉ Submodule.span K (row '' Set.Iio i)}

variable [Fintype ι]

theorem linearIndependent_of_not_mem_earlier_span (row : ι → V)
    (h : ∀ i, row i ∉ Submodule.span K (row '' Set.Iio i)) :
    LinearIndependent K row := by
  have aux (s : Finset ι) : LinearIndepOn K row (s : Set ι) := by
    induction s using Finset.induction_on_max with
    | empty => simp
    | insert a s hlt ih =>
      have ha : a ∉ (s : Set ι) := fun has => (lt_irrefl a) (hlt a has)
      rw [Finset.coe_insert, linearIndepOn_insert ha]
      refine ⟨ih, fun hm => h a ?_⟩
      exact (Submodule.span_mono (Set.image_mono fun j hj => hlt j hj)) hm
  apply linearIndepOn_univ_iff.mp
  simpa only [Finset.coe_univ] using aux Finset.univ

theorem greedy_linearIndependent (row : ι → V) :
    LinearIndependent K (fun i : greedySet K row => row i) := by
  apply linearIndependent_of_not_mem_earlier_span
  intro i hi
  apply i.property
  exact (Submodule.span_mono (by
    rintro _ ⟨j, hji, rfl⟩
    exact ⟨j.val, hji, rfl⟩)) hi

theorem row_mem_span_greedy_le (row : ι → V) (i : ι) :
    row i ∈ Submodule.span K (row '' {j | j ∈ greedySet K row ∧ j ≤ i}) := by
  induction i using WellFoundedLT.induction with
  | ind i ih =>
    by_cases hi : i ∈ greedySet K row
    · exact Submodule.subset_span ⟨i, ⟨hi, le_rfl⟩, rfl⟩
    · have hrow : row i ∈ Submodule.span K (row '' Set.Iio i) := by
        simpa [greedySet] using hi
      apply (Submodule.span_le.mpr ?_) hrow
      rintro _ ⟨j, hji, rfl⟩
      exact (Submodule.span_mono (Set.image_mono (by
        intro k hk
        exact ⟨hk.1, hk.2.trans hji.le⟩))) (ih j hji)

theorem greedy_prefix_span (row : ι → V) (i : ι) :
    Submodule.span K (row '' (greedySet K row ∩ Set.Iio i)) =
      Submodule.span K (row '' Set.Iio i) := by
  apply le_antisymm
  · exact Submodule.span_mono (Set.image_mono Set.inter_subset_right)
  · apply Submodule.span_le.mpr
    rintro _ ⟨j, hji, rfl⟩
    exact (Submodule.span_mono (Set.image_mono (by
      intro k hk
      exact ⟨hk.1, hk.2.trans_lt hji⟩))) (row_mem_span_greedy_le K row j)

theorem greedy_span (row : ι → V) :
    Submodule.span K (Set.range (fun i : greedySet K row => row i)) =
      Submodule.span K (Set.range row) := by
  apply le_antisymm
  · apply Submodule.span_mono
    rintro _ ⟨i, rfl⟩
    exact ⟨i.val, rfl⟩
  · apply Submodule.span_le.mpr
    rintro _ ⟨i, rfl⟩
    exact (Submodule.span_mono (by
      rintro _ ⟨j, hj, rfl⟩
      exact ⟨⟨j, hj.1⟩, rfl⟩)) (row_mem_span_greedy_le K row i)

def greedyBasis (row : ι → V)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    Module.Basis (greedySet K row) K V :=
  Module.Basis.mk (greedy_linearIndependent K row) (by
    rw [greedy_span K row, hspan])

end Greedy

section SquareRows

variable (K : Type u) [Field K]
variable {ι : Type v} [LinearOrder ι] [Fintype ι] {n : ℕ}

theorem greedy_card (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    Fintype.card (greedySet K row) = n := by
  have h := Module.finrank_eq_card_basis (greedyBasis K row hspan)
  simpa only [Module.finrank_fintype_fun_eq_card, Fintype.card_fin] using h.symm

/-- Increasing enumeration of precisely the indices passing the greedy test. -/
def greedyEnumeration (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) : Fin n ↪o ι :=
  (monoEquivOfFin (greedySet K row) (greedy_card K row hspan)).toOrderEmbedding.trans
    (OrderEmbedding.subtype _)

theorem greedyEnumeration_range (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    Set.range (greedyEnumeration K row hspan) = greedySet K row := by
  let e := monoEquivOfFin (greedySet K row) (greedy_card K row hspan)
  change Set.range (fun k => (e k).val) = greedySet K row
  ext i
  constructor
  · rintro ⟨k, rfl⟩
    exact (e k).property
  · intro hi
    exact ⟨e.symm ⟨i, hi⟩, congrArg Subtype.val (e.apply_symm_apply ⟨i, hi⟩)⟩

theorem greedyEnumeration_linearIndependent (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    LinearIndependent K (row ∘ greedyEnumeration K row hspan) := by
  let e := monoEquivOfFin (greedySet K row) (greedy_card K row hspan)
  change LinearIndependent K ((fun i : greedySet K row => row i) ∘ e)
  exact (greedy_linearIndependent K row).comp e e.injective

theorem greedyEnumeration_span (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    Submodule.span K (Set.range (row ∘ greedyEnumeration K row hspan)) = ⊤ := by
  have hrange :
      Set.range (row ∘ greedyEnumeration K row hspan) =
        Set.range (fun i : greedySet K row => row i) := by
    rw [Set.range_comp, greedyEnumeration_range K row hspan]
    exact Set.image_eq_range row (greedySet K row)
  rw [hrange, greedy_span K row, hspan]

theorem greedyEnumeration_det_ne_zero (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    Matrix.det (fun i j => row (greedyEnumeration K row hspan i) j) ≠ 0 := by
  have hunit := ((Pi.basisFun K (Fin n)).is_basis_iff_det).mp
    ⟨greedyEnumeration_linearIndependent K row hspan, greedyEnumeration_span K row hspan⟩
  rw [Pi.basisFun_det_apply] at hunit
  have heq : Matrix.of (row ∘ greedyEnumeration K row hspan) =
      (fun i j => row (greedyEnumeration K row hspan i) j) := by
    ext i j
    exact Matrix.of_apply _ i j
  rw [heq] at hunit
  exact hunit.ne_zero

theorem greedyEnumeration_prefix (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤)
    (k : Fin n) (j : ι) (hjk : j < greedyEnumeration K row hspan k) :
    row j ∈ Submodule.span K ((row ∘ greedyEnumeration K row hspan) '' Set.Iio k) := by
  have hm : row j ∈ Submodule.span K
      (row '' (greedySet K row ∩ Set.Iio (greedyEnumeration K row hspan k))) := by
    rw [greedy_prefix_span K row]
    exact Submodule.subset_span ⟨j, hjk, rfl⟩
  apply (Submodule.span_mono ?_) hm
  rintro _ ⟨a, ⟨ha, hak⟩, rfl⟩
  rw [← greedyEnumeration_range K row hspan] at ha
  obtain ⟨l, rfl⟩ := ha
  exact ⟨l, (greedyEnumeration K row hspan).lt_iff_lt.mp hak, rfl⟩

theorem greedyEnumeration_prefix_span (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) (k : Fin n) :
    Submodule.span K ((row ∘ greedyEnumeration K row hspan) '' Set.Iio k) =
      Submodule.span K (row '' Set.Iio (greedyEnumeration K row hspan k)) := by
  apply le_antisymm
  · apply Submodule.span_mono
    rintro _ ⟨j, hjk, rfl⟩
    exact ⟨greedyEnumeration K row hspan j,
      (greedyEnumeration K row hspan).strictMono hjk, rfl⟩
  · apply Submodule.span_le.mpr
    rintro _ ⟨j, hjk, rfl⟩
    exact greedyEnumeration_prefix K row hspan k j hjk

theorem ordered_greedy_construction (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    Fintype.card (greedySet K row) = n ∧
    ∃ g : Fin n ↪o ι,
      StrictMono g ∧
      Set.range g = greedySet K row ∧
      LinearIndependent K (row ∘ g) ∧
      Submodule.span K (Set.range (row ∘ g)) = ⊤ ∧
      Matrix.det (fun i j => row (g i) j) ≠ 0 ∧
      ∀ k j, j < g k →
        row j ∈ Submodule.span K ((row ∘ g) '' Set.Iio k) := by
  exact ⟨greedy_card K row hspan, greedyEnumeration K row hspan,
    (greedyEnumeration K row hspan).strictMono,
    greedyEnumeration_range K row hspan,
    greedyEnumeration_linearIndependent K row hspan,
    greedyEnumeration_span K row hspan,
    greedyEnumeration_det_ne_zero K row hspan,
    greedyEnumeration_prefix K row hspan⟩

theorem greedyEnumeration_weight_bound (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤)
    {W : Type*} [Preorder W] (weight : ι → W) (bound : W)
    (hweight : ∀ i, weight i ≤ bound) (k : Fin n) :
    weight (greedyEnumeration K row hspan k) ≤ bound :=
  hweight _

end SquareRows

section TriangularReplacement

variable (K : Type u) [Field K]
variable {ρ : Type v} [LinearOrder ρ] [Fintype ρ] {κ : Type w}

def earlierReplacementCoefficients (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) (i : ρ) :
    Set.Iio i → K :=
  ((Fintype.mem_span_image_iff_exists_fun K (v := A)).mp (h i)).choose

theorem earlierReplacementCoefficients_sum (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) (i : ρ) :
    (∑ j : Set.Iio i, earlierReplacementCoefficients K A B h i j • A j) =
      B i - A i :=
  ((Fintype.mem_span_image_iff_exists_fun K (v := A)).mp (h i)).choose_spec

/-- Extend the derived earlier-row coefficients by zero on and above the diagonal. -/
def replacementCoefficients (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) : Matrix ρ ρ K :=
  fun i j => if hj : j < i then earlierReplacementCoefficients K A B h i ⟨j, hj⟩ else 0

theorem replacementCoefficients_zero (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i))
    (i j : ρ) (hij : i ≤ j) :
    replacementCoefficients K A B h i j = 0 := by
  simp [replacementCoefficients, not_lt.mpr hij]

theorem replacementCoefficients_sum (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) (i : ρ) :
    (∑ j, replacementCoefficients K A B h i j • A j) = B i - A i := by
  calc
    _ = ∑ j : Set.Iio i, earlierReplacementCoefficients K A B h i j • A j := by
      apply Finset.sum_congr_set (Set.Iio i)
      · intro j hj
        change j < i at hj
        simp [replacementCoefficients, hj]
      · intro j hj
        change ¬j < i at hj
        simp [replacementCoefficients, hj]
    _ = B i - A i := earlierReplacementCoefficients_sum K A B h i

theorem replacementCoefficients_mul (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) :
    replacementCoefficients K A B h * A = B - A := by
  ext i k
  have hs := congrFun (replacementCoefficients_sum K A B h i) k
  simpa only [Matrix.mul_apply, Matrix.sub_apply, Finset.sum_apply, Pi.smul_apply,
    smul_eq_mul, Pi.sub_apply] using hs

theorem replacement_factorization (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) :
    B = (1 + replacementCoefficients K A B h) * A := by
  rw [Matrix.add_mul, Matrix.one_mul, replacementCoefficients_mul K A B h]
  abel

theorem exists_strictLowerTriangular_replacement (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) :
    ∃ C : Matrix ρ ρ K, (∀ i j, i ≤ j → C i j = 0) ∧ B = (1 + C) * A := by
  exact ⟨replacementCoefficients K A B h,
    replacementCoefficients_zero K A B h, replacement_factorization K A B h⟩

theorem det_one_add_replacementCoefficients (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) :
    Matrix.det (1 + replacementCoefficients K A B h) = 1 := by
  have htri : (1 + replacementCoefficients K A B h).BlockTriangular OrderDual.toDual := by
    intro i j hij
    have hij' : i < j := hij
    simp [Matrix.add_apply, ne_of_lt hij',
      replacementCoefficients_zero K A B h i j hij'.le]
  rw [Matrix.det_of_lowerTriangular _ htri]
  simp [replacementCoefficients_zero K A B h]

theorem replacement_det (A B : Matrix ρ ρ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) :
    B.det = A.det := by
  rw [replacement_factorization K A B h, Matrix.det_mul,
    det_one_add_replacementCoefficients K A B h, one_mul]

end TriangularReplacement

section CombinedBridge

variable (K : Type u) [Field K]
variable {ι : Type v} [LinearOrder ι] [Fintype ι] {n : ℕ}

theorem greedy_replacement_bridge (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤)
    (B : Matrix (Fin n) (Fin n) K)
    (hB : ∀ i, B i - row (greedyEnumeration K row hspan i) ∈
      Submodule.span K (row '' Set.Iio (greedyEnumeration K row hspan i))) :
    ∃ C : Matrix (Fin n) (Fin n) K,
      (∀ i j, i ≤ j → C i j = 0) ∧
      B = (1 + C) * Matrix.of (row ∘ greedyEnumeration K row hspan) ∧
      B.det = Matrix.det (fun i j => row (greedyEnumeration K row hspan i) j) ∧
      B.det ≠ 0 := by
  let A : Matrix (Fin n) (Fin n) K :=
    fun i j => row (greedyEnumeration K row hspan i) j
  have h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i) := by
    intro i
    change B i - row (greedyEnumeration K row hspan i) ∈
      Submodule.span K ((row ∘ greedyEnumeration K row hspan) '' Set.Iio i)
    rw [greedyEnumeration_prefix_span K row hspan]
    exact hB i
  refine ⟨replacementCoefficients K A B h,
    replacementCoefficients_zero K A B h, replacement_factorization K A B h,
    replacement_det K A B h, ?_⟩
  rw [replacement_det K A B h]
  exact greedyEnumeration_det_ne_zero K row hspan

end CombinedBridge

end LSGenericGreedy

noncomputable section

open scoped BigOperators Pointwise
open Finset Matrix

set_option maxHeartbeats 800000

namespace LSLatticeGeometry

abbrev Z4 := Fin 4 → ℤ
abbrev E4 := EuclideanSpace ℝ (Fin 4)

def intBox (N : ℕ) : Finset Z4 :=
  Fintype.piFinset fun _ => Finset.Ico (0 : ℤ) (N : ℤ)

@[simp] theorem mem_intBox (N : ℕ) (n : Z4) :
    n ∈ intBox N ↔ ∀ i, 0 ≤ n i ∧ n i < (N : ℤ) := by
  simp [intBox, Fintype.mem_piFinset]

def enlargedBox (N : ℕ) : Finset Z4 := intBox (4 * (N - 1) + 1)

theorem mem_enlargedBox (N : ℕ) (n : Z4) :
    n ∈ enlargedBox N ↔
      ∀ i, 0 ≤ n i ∧ n i ≤ ((4 * (N - 1) : ℕ) : ℤ) := by
  simp only [enlargedBox, mem_intBox, Nat.cast_add, Nat.cast_one, Int.lt_add_one_iff]

def intDot (r n : Z4) : ℤ := ∑ i, r i * n i

def toE (n : Z4) : E4 := WithLp.toLp 2 fun i => (n i : ℝ)

@[simp] theorem toE_apply (n : Z4) (i : Fin 4) : toE n i = (n i : ℝ) := rfl

@[simp] theorem toE_add (a b : Z4) : toE (a + b) = toE a + toE b := by
  ext i
  simp [toE]

@[simp] theorem toE_sub (a b : Z4) : toE (a - b) = toE a - toE b := by
  ext i
  simp [toE]

theorem toE_injective : Function.Injective toE := by
  intro a b h
  funext i
  have hi : (a i : ℝ) = (b i : ℝ) := congrArg (fun x : E4 => x i) h
  exact_mod_cast hi

theorem isClosedEmbedding_toE : Topology.IsClosedEmbedding toE := by
  exact (PiLp.homeomorph 2 (fun _ : Fin 4 => ℝ)).symm.isClosedEmbedding.comp
    (Topology.IsClosedEmbedding.piMap fun _ : Fin 4 => Int.isClosedEmbedding_coe_real)

/-- Compactness of one factor and discreteness of the lattice give a global nearest pair. -/
theorem nearest_lattice_pair (K : Set E4) (hK : IsCompact K) (hKne : K.Nonempty)
    (F : Z4 → ℂ) (hF : ∃ m, F m ≠ 0) :
    ∃ (m : Z4) (y : E4), F m ≠ 0 ∧ y ∈ K ∧
      ∀ m' : Z4, F m' ≠ 0 → ∀ y' ∈ K, ‖toE m - y‖ ≤ ‖toE m' - y'‖ := by
  let T : Set E4 := toE '' {m | F m ≠ 0}
  have hT : IsClosed T :=
    isClosedEmbedding_toE.isClosedMap _ (isClosed_discrete _)
  have hTne : T.Nonempty := by
    obtain ⟨m, hm⟩ := hF
    exact ⟨toE m, m, hm, rfl⟩
  obtain ⟨y, hy, hmin⟩ :=
    hK.exists_isMinOn hKne (Metric.continuous_infDist_pt T).continuousOn
  obtain ⟨a, ha, hea⟩ := hT.exists_infDist_eq_dist hTne y
  obtain ⟨m, hm, rfl⟩ := ha
  refine ⟨m, y, hm, hy, ?_⟩
  intro m' hm' y' hy'
  rw [← dist_eq_norm, dist_comm (toE m) y, ← hea, ← dist_eq_norm,
    dist_comm (toE m') y']
  exact (hmin hy').trans
    (Metric.infDist_le_dist_of_mem (s := T) (x := y') (y := toE m') ⟨m', hm', rfl⟩)

theorem supporting_inequality {K : Set E4} (hK : Convex ℝ K)
    {a y : E4} (hy : y ∈ K)
    (hmin : ∀ z ∈ K, ‖a - y‖ ≤ ‖a - z‖) :
    ∀ z ∈ K, inner ℝ (a - y) (z - y) ≤ 0 := by
  letI : Nonempty K := ⟨⟨y, hy⟩⟩
  apply (norm_eq_iInf_iff_real_inner_le_zero hK hy).mp
  apply le_antisymm
  · exact le_ciInf fun z : K => hmin z z.property
  · exact ciInf_le (show BddBelow (Set.range fun z : K => ‖a - z‖) from
      ⟨0, by rintro _ ⟨z, rfl⟩; exact norm_nonneg _⟩) ⟨y, hy⟩

/-- An integral Gram matrix avoids any assumption that the real normal is rational. -/
theorem integer_normal_of_real_normal {ι : Type*} [Fintype ι]
    (A : Matrix ι (Fin 4) ℤ) (h : Fin 4 → ℝ) (hh : h ≠ 0)
    (hAh : (A.map (Int.castRingHom ℝ)).mulVec h = 0) :
    ∃ r : Z4, r ≠ 0 ∧ A.mulVec r = 0 := by
  classical
  let B : Matrix (Fin 4) (Fin 4) ℤ := A.transpose * A
  have hBh : (B.map (Int.castRingHom ℝ)).mulVec h = 0 := by
    simp only [B, Matrix.map_mul, Matrix.transpose_map, ← Matrix.mulVec_mulVec,
      hAh, Matrix.mulVec_zero]
  have hdetR : (B.map (Int.castRingHom ℝ)).det = 0 :=
    Matrix.exists_mulVec_eq_zero_iff.mp ⟨h, hh, hBh⟩
  have hdet : B.det = 0 := by
    change (B.map fun z : ℤ => (z : ℝ)).det = 0 at hdetR
    rw [← Int.cast_det] at hdetR
    exact_mod_cast hdetR
  obtain ⟨r, hr, hBr⟩ := Matrix.exists_mulVec_eq_zero_iff.mpr hdet
  refine ⟨r, hr, ?_⟩
  have heq : A.transpose.mulVec (A.mulVec r) = 0 := by
    simpa only [B, Matrix.mulVec_mulVec] using hBr
  have hz := congrArg (dotProduct r) heq
  rwa [dotProduct_mulVec, dotProduct_zero, vecMul_transpose,
    dotProduct_self_eq_zero] at hz

def hull (S : Finset Z4) : Set E4 := convexHull ℝ (toE '' (S : Set Z4))

def fourHull (S : Finset Z4) : Set E4 := (4 : ℝ) • hull S

theorem toE_mem_hull {S : Finset Z4} {n : Z4} (hn : n ∈ S) : toE n ∈ hull S :=
  subset_convexHull ℝ _ ⟨n, hn, rfl⟩

theorem convex_fourHull (S : Finset Z4) : Convex ℝ (fourHull S) :=
  (convex_convexHull ℝ _).smul 4

theorem compact_fourHull (S : Finset Z4) : IsCompact (fourHull S) := by
  have hp : IsCompact (hull S) :=
    ((S.finite_toSet).image toE).isCompact_convexHull ℝ
  exact hp.image (continuous_const.smul continuous_id)

theorem nonempty_fourHull {S : Finset Z4} (hS : S.Nonempty) :
    (fourHull S).Nonempty := by
  obtain ⟨u, hu⟩ := hS
  exact ⟨4 • toE u, toE u, toE_mem_hull hu, rfl⟩

theorem hull_coordinate_bounds {N : ℕ} (hN : 1 ≤ N) {S : Finset Z4}
    (hS : S ⊆ intBox N) {x : E4} (hx : x ∈ hull S) :
    ∀ i, 0 ≤ x i ∧ x i ≤ ((N - 1 : ℕ) : ℝ) := by
  have hbox : Convex ℝ {x : E4 | ∀ i, 0 ≤ x i ∧ x i ≤ ((N - 1 : ℕ) : ℝ)} := by
    intro x hx y hy a b ha hb hab i
    change 0 ≤ a * x i + b * y i ∧
      a * x i + b * y i ≤ ((N - 1 : ℕ) : ℝ)
    constructor
    · exact add_nonneg (mul_nonneg ha (hx i).1) (mul_nonneg hb (hy i).1)
    · calc
        a * x i + b * y i ≤
            a * ((N - 1 : ℕ) : ℝ) + b * ((N - 1 : ℕ) : ℝ) :=
          add_le_add (mul_le_mul_of_nonneg_left (hx i).2 ha)
            (mul_le_mul_of_nonneg_left (hy i).2 hb)
        _ = ((N - 1 : ℕ) : ℝ) := by nlinarith [hab]
  apply convexHull_min (t := {x : E4 | ∀ i, 0 ≤ x i ∧ x i ≤ ((N - 1 : ℕ) : ℝ)})
    ?_ hbox hx
  rintro _ ⟨n, hn, rfl⟩ i
  have hi := (mem_intBox N n).mp (hS hn) i
  have hcast : ((N - 1 : ℕ) : ℤ) = (N : ℤ) - 1 := by
    rw [Nat.cast_sub hN]
    norm_num
  change 0 ≤ (n i : ℝ) ∧ (n i : ℝ) ≤ ((N - 1 : ℕ) : ℝ)
  constructor
  · exact_mod_cast hi.1
  · have hh : n i ≤ ((N - 1 : ℕ) : ℤ) := by omega
    exact_mod_cast hh

theorem integer_mem_fourHull {N : ℕ} (hN : 1 ≤ N) {S : Finset Z4}
    (hS : S ⊆ intBox N) {m : Z4} (hm : toE m ∈ fourHull S) :
    m ∈ enlargedBox N := by
  obtain ⟨p, hp, heq⟩ := hm
  rw [mem_enlargedBox]
  intro i
  have hip := hull_coordinate_bounds hN hS hp i
  have hieq : (m i : ℝ) = 4 * p i := by
    simpa only [toE_apply, PiLp.smul_apply, smul_eq_mul] using
      congrArg (fun x : E4 => x i) heq.symm
  constructor
  · have hi0 : (0 : ℝ) ≤ (m i : ℝ) := by linarith
    exact_mod_cast hi0
  · have hi1 : (m i : ℝ) ≤ ((4 * (N - 1) : ℕ) : ℝ) := by
      push_cast
      linarith
    exact_mod_cast hi1

theorem support_card_le_four {ι : Type*} [Fintype ι]
    (z : ι → E4) (hz : AffineIndependent ℝ z) (h : E4) (hh : h ≠ 0)
    (c : ℝ) (hface : ∀ i, inner ℝ h (z i) = c) : Fintype.card ι ≤ 4 := by
  classical
  rcases isEmpty_or_nonempty ι with hι | hι
  · letI := hι
    simp
  letI := hι
  let i₀ : ι := Classical.choice hι
  let W : Submodule ℝ E4 := (innerₗ E4 h).ker
  have hW : W ≠ ⊤ := by
    intro htop
    have hm : h ∈ W := by rw [htop]; trivial
    have hzero : inner ℝ h h = 0 := hm
    exact hh (inner_self_eq_zero.mp hzero)
  have hdim : Module.finrank ℝ W < 4 := by
    simpa [E4] using Submodule.finrank_lt hW
  have hspan : vectorSpan ℝ (Set.range z) ≤ W := by
    rw [vectorSpan_range_eq_span_range_vsub_right ℝ z i₀]
    apply Submodule.span_le.mpr
    rintro _ ⟨i, rfl⟩
    change inner ℝ h (z i - z i₀) = 0
    rw [inner_sub_right, hface i, hface i₀, sub_self]
  have hc := hz.card_le_finrank_succ.trans
    (Nat.add_le_add_right (Submodule.finrank_mono hspan) 1)
  omega

theorem exists_weight_ge_quarter {ι : Type*} [Fintype ι] (w : ι → ℝ)
    (hw : ∑ i, w i = 1) (hc : Fintype.card ι ≤ 4) :
    ∃ a, (1 / 4 : ℝ) ≤ w a := by
  classical
  obtain ⟨a, _, _⟩ := Finset.exists_ne_zero_of_sum_ne_zero
    (show (∑ i, w i) ≠ 0 by rw [hw]; norm_num)
  letI : Nonempty ι := ⟨a⟩
  by_contra! h
  have hlt : ∑ i, w i < ∑ _i : ι, (1 / 4 : ℝ) :=
    Finset.sum_lt_sum_of_nonempty Finset.univ_nonempty fun i _ => h i
  rw [hw, Finset.sum_const, Finset.card_univ, nsmul_eq_mul] at hlt
  have hc' : (Fintype.card ι : ℝ) ≤ 4 := by exact_mod_cast hc
  nlinarith

theorem exchange_mem_four_smul {ι : Type*} [Fintype ι] {P : Set E4}
    (hP : Convex ℝ P) (z : ι → E4) (w : ι → ℝ)
    (hz : ∀ i, z i ∈ P) (hw₀ : ∀ i, 0 ≤ w i) (hw₁ : ∑ i, w i = 1)
    {p : E4} (hp : ∑ i, w i • z i = p) (a : ι) (ha : (1 / 4 : ℝ) ≤ w a)
    {n : E4} (hn : n ∈ P) :
    (4 : ℝ) • p + n - z a ∈ (4 : ℝ) • P := by
  classical
  let v : Option ι → ℝ := fun o => match o with
    | none => 1 / 4
    | some i => w i - if i = a then 1 / 4 else 0
  let q : Option ι → E4 := fun o => o.elim n z
  have hv₀ : ∀ o ∈ (univ : Finset (Option ι)), 0 ≤ v o := by
    intro o _
    cases o with
    | none => norm_num [v]
    | some i =>
      by_cases hi : i = a
      · simpa [v, hi] using (sub_nonneg.mpr ha)
      · simpa [v, hi] using hw₀ i
  have hv₁ : ∑ o, v o = 1 := by
    simp [Fintype.sum_option, v, Finset.sum_sub_distrib, hw₁]
  have hq : ∀ o ∈ (univ : Finset (Option ι)), q o ∈ P := by
    intro o _
    cases o with
    | none => exact hn
    | some i => exact hz i
  have hmem : ∑ o, v o • q o ∈ P := hP.sum_mem hv₀ hv₁ hq
  have hsum : ∑ o, v o • q o = (1 / 4 : ℝ) • n + (p - (1 / 4 : ℝ) • z a) := by
    simp [Fintype.sum_option, v, q, sub_smul, Finset.sum_sub_distrib, hp,
      ite_smul]
  refine ⟨∑ o, v o • q o, hmem, ?_⟩
  rw [hsum]
  simp only [smul_add, smul_sub, smul_smul]
  norm_num
  abel

theorem positive_convex_support {ι : Type*} [Fintype ι]
    (z : ι → E4) (w : ι → ℝ) (hw₀ : ∀ i, 0 < w i) (hw₁ : ∑ i, w i = 1)
    {p : E4} (hp : ∑ i, w i • z i = p) (h : E4)
    (hbound : ∀ i, inner ℝ h (z i) ≤ inner ℝ h p) :
    ∀ i, inner ℝ h (z i) = inner ℝ h p := by
  have hlin : ∑ i, w i * inner ℝ h (z i) = inner ℝ h p := by
    rw [← hp, inner_sum]
    simp only [inner_smul_right]
  have hsum : ∑ i, w i * (inner ℝ h p - inner ℝ h (z i)) = 0 := by
    simp_rw [mul_sub]
    rw [Finset.sum_sub_distrib, ← Finset.sum_mul, hw₁, one_mul, hlin, sub_self]
  have hall := (Finset.sum_eq_zero_iff_of_nonneg
    (fun i (_ : i ∈ (univ : Finset ι)) =>
      mul_nonneg (hw₀ i).le (sub_nonneg.mpr (hbound i)))).mp hsum
  intro i
  have heq := (mul_eq_zero.mp (hall i (mem_univ i))).resolve_left (ne_of_gt (hw₀ i))
  linarith

theorem integer_face_hyperplane (S : Finset Z4) (h : E4) (hh : h ≠ 0) (u : Z4) :
    ∃ r : Z4, r ≠ 0 ∧ ∀ n ∈ S,
      inner ℝ h (toE n) = inner ℝ h (toE u) → intDot r n = intDot r u := by
  classical
  let T := S.filter fun n => inner ℝ h (toE n) = inner ℝ h (toE u)
  let A : Matrix T (Fin 4) ℤ := fun n i => n.val i - u i
  have hh' : (fun i => h i) ≠ (0 : Fin 4 → ℝ) := by
    intro hz
    apply hh
    ext i
    exact congrFun hz i
  have hAh : (A.map (Int.castRingHom ℝ)).mulVec (fun i => h i) = 0 := by
    ext n
    have hnface := (Finset.mem_filter.mp n.property).2
    have hin : inner ℝ h (toE n.val - toE u) = 0 := by
      rw [inner_sub_right, hnface, sub_self]
    simpa [A, Matrix.mulVec, dotProduct, PiLp.inner_apply, toE, mul_comm] using hin
  obtain ⟨r, hr, hAr⟩ := integer_normal_of_real_normal A (fun i => h i) hh' hAh
  refine ⟨r, hr, ?_⟩
  intro n hn hface
  let nn : T := ⟨n, Finset.mem_filter.mpr ⟨hn, hface⟩⟩
  have hrn := congrFun hAr nn
  have heq : intDot r n - intDot r u = 0 := by
    simpa [A, nn, Matrix.mulVec, dotProduct, intDot, sub_mul, mul_sub,
      Finset.sum_sub_distrib, mul_comm] using hrn
  exact sub_eq_zero.mp heq

/-- The exact geometric interface used by the rectangular interpolation proof. -/
def LatticeFaceSelection : Prop :=
  ∀ (N : ℕ), 1 ≤ N →
    ∀ (S : Finset Z4), S.Nonempty → S ⊆ intBox N →
      ∀ (F : Z4 → ℂ), (∃ m, F m ≠ 0) →
        (∀ m ∈ enlargedBox N, F m = 0) →
        ∃ u ∈ S, ∃ (m r : Z4) (k : ℤ),
          r ≠ 0 ∧ intDot r u = k ∧ F m ≠ 0 ∧
            ∀ n ∈ S, intDot r n ≠ k → F (m + n - u) = 0

theorem latticeFaceSelection : LatticeFaceSelection := by
  classical
  intro N hN S hSne hS F hF hFzero
  obtain ⟨m, y, hm, hy, hmin⟩ :=
    nearest_lattice_pair (fourHull S) (compact_fourHull S) (nonempty_fourHull hSne) F hF
  have houtside : toE m ≠ y := by
    intro heq
    have hmK : toE m ∈ fourHull S := by rw [heq]; exact hy
    exact hm (hFzero m (integer_mem_fourHull hN hS hmK))
  let h : E4 := toE m - y
  have hh : h ≠ 0 := sub_ne_zero.mpr houtside
  have hsupport : ∀ x ∈ fourHull S, inner ℝ h (x - y) ≤ 0 :=
    supporting_inequality (convex_fourHull S) hy (fun z hz => hmin m hm z hz)
  obtain ⟨p, hp, hyp⟩ := hy
  have hy_eq : y = (4 : ℝ) • p := hyp.symm
  have hbound : ∀ n ∈ S, inner ℝ h (toE n) ≤ inner ℝ h p := by
    intro n hn
    have hs := hsupport (4 • toE n) ⟨toE n, toE_mem_hull hn, rfl⟩
    rw [hy_eq, inner_sub_right, inner_smul_right, inner_smul_right] at hs
    linarith
  obtain ⟨ι, hι, z, w, hzS, hzind, hwpos, hwsum, hpsplit⟩ :=
    eq_pos_convex_span_of_mem_convexHull hp
  letI := hι
  have hzbound : ∀ i, inner ℝ h (z i) ≤ inner ℝ h p := by
    intro i
    obtain ⟨n, hn, hen⟩ := hzS ⟨i, rfl⟩
    rw [← hen]
    exact hbound n hn
  have hfacez : ∀ i, inner ℝ h (z i) = inner ℝ h p :=
    positive_convex_support z w hwpos hwsum hpsplit h hzbound
  have hc : Fintype.card ι ≤ 4 := support_card_le_four z hzind h hh _ hfacez
  obtain ⟨a, ha⟩ := exists_weight_ge_quarter w hwsum hc
  obtain ⟨u, hu, heu⟩ := hzS ⟨a, rfl⟩
  have hueq : inner ℝ h (toE u) = inner ℝ h p := by
    rw [heu]
    exact hfacez a
  obtain ⟨r, hr, hrface⟩ := integer_face_hyperplane S h hh u
  refine ⟨u, hu, m, r, intDot r u, hr, rfl, hm, ?_⟩
  intro n hn hnr
  by_contra hFn
  have hy' : y + toE n - toE u ∈ fourHull S := by
    rw [hy_eq, heu]
    apply exchange_mem_four_smul (convex_convexHull ℝ _) z w
      (fun i => subset_convexHull ℝ _ (hzS ⟨i, rfl⟩)) (fun i => (hwpos i).le)
      hwsum hpsplit a ha (toE_mem_hull hn)
  have hdiff : toE (m + n - u) - (y + toE n - toE u) = h := by
    simp only [toE_add, toE_sub]
    dsimp [h]
    abel
  have hmin' : ∀ x ∈ fourHull S,
      ‖toE (m + n - u) - (y + toE n - toE u)‖ ≤ ‖toE (m + n - u) - x‖ := by
    intro x hx
    rw [hdiff]
    exact hmin (m + n - u) hFn x hx
  have hproj' := supporting_inequality (convex_fourHull S) hy' hmin' y
    (show y ∈ fourHull S from ⟨p, hp, hyp⟩)
  rw [hdiff] at hproj'
  have hback : y - (y + toE n - toE u) = toE u - toE n := by abel
  rw [hback, inner_sub_right] at hproj'
  have hface_n : inner ℝ h (toE n) = inner ℝ h (toE u) := by
    have hb := hbound n hn
    rw [← hueq] at hb
    linarith
  exact hnr (hrface n hn hface_n)

/-- Universally quantified export, with no geometry proposition as a hypothesis. -/
theorem lattice_face_selection
    (N : ℕ) (hN : 1 ≤ N)
    (S : Finset Z4) (hSne : S.Nonempty) (hS : S ⊆ intBox N)
    (F : Z4 → ℂ) (hF : ∃ m, F m ≠ 0)
    (hFzero : ∀ m ∈ enlargedBox N, F m = 0) :
    ∃ u ∈ S, ∃ (m r : Z4) (k : ℤ),
      r ≠ 0 ∧ intDot r u = k ∧ F m ≠ 0 ∧
        ∀ n ∈ S, intDot r n ≠ k → F (m + n - u) = 0 :=
  latticeFaceSelection N hN S hSne hS F hF hFzero

#check lattice_face_selection
#print axioms latticeFaceSelection
#print axioms lattice_face_selection

end LSLatticeGeometry

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

noncomputable section

open scoped BigOperators
open Finset

namespace LSChain

def rectangleDegrees (H : ℕ) (V : ℝ) : Fin 3 → ℕ :=
  ![⌊32 * (H : ℝ) * V⌋₊, ⌊32 * V⌋₊, ⌊32 * V⌋₊]

def weightBound (H : ℕ) (V : ℝ) : ℕ := ⌊96 * (H : ℝ) * V⌋₊

theorem rectangle_budget
    (N H : ℕ) (hN : 1 ≤ N) (hH : 1 ≤ H) (V : ℝ)
    (hV : (N : ℝ) ≤ V) (hvol : (H : ℝ) * V ^ 3 = (N : ℝ) ^ 4) :
    (∀ j, 3 * (N - 1) ≤ rectangleDegrees H V j) ∧
      (4 * N - 3) ^ 4 <
        ∏ j, (rectangleDegrees H V j - 3 * (N - 1) + 1) ∧
      rectangleDegrees H V 0 +
          H * (rectangleDegrees H V 1 + rectangleDegrees H V 2) ≤ weightBound H V := by
  have hNr : (1 : ℝ) ≤ N := by exact_mod_cast hN
  have hHr : (1 : ℝ) ≤ H := by exact_mod_cast hH
  have hVp : 0 < V := by linarith
  let T : Fin 3 → ℝ := ![32 * (H : ℝ) * V, 32 * V, 32 * V]
  have htdef : ∀ j, rectangleDegrees H V j = ⌊T j⌋₊ := by
    intro j
    fin_cases j <;> rfl
  have hT : ∀ j, 32 * (N : ℝ) ≤ T j := by
    intro j
    fin_cases j <;> simp [T]
    · nlinarith
    · linarith
    · linarith
  have hpos : ∀ j, 0 ≤ T j := fun j => by have := hT j; linarith
  have hD : ((3 * (N - 1) : ℕ) : ℝ) ≤ 3 * (N : ℝ) := by
    exact_mod_cast Nat.mul_le_mul_left 3 (Nat.sub_le N 1)
  have ht : ∀ j, 3 * (N - 1) ≤ rectangleDegrees H V j := by
    intro j
    rw [htdef]
    apply Nat.le_floor
    have := hT j
    linarith
  have hfactor : ∀ j, T j / 2 <
      ((rectangleDegrees H V j - 3 * (N - 1) + 1 : ℕ) : ℝ) := by
    intro j
    have hf := Nat.lt_floor_add_one (T j)
    rw [← htdef] at hf
    rw [Nat.cast_add, Nat.cast_one, Nat.cast_sub (ht j)]
    have := hT j
    linarith
  have hprod :
      (∏ j, T j / 2) <
        ∏ j, ((rectangleDegrees H V j - 3 * (N - 1) + 1 : ℕ) : ℝ) :=
    Finset.prod_lt_prod_of_nonempty
      (fun j _ => by have := hT j; linarith)
      (fun j _ => hfactor j) (by simp)
  have hTprod : (∏ j, T j / 2) = 4096 * (N : ℝ) ^ 4 := by
    simp only [Fin.prod_univ_succ, T, Matrix.cons_val_zero, Fin.isValue]
    dsimp
    calc
      (32 * (H : ℝ) * V / 2) * ((32 * V / 2) * ((32 * V / 2) * 1)) =
          4096 * ((H : ℝ) * V ^ 3) := by ring
      _ = _ := by rw [hvol]
  have hmargin : (4 * N - 3) ^ 4 < 4096 * N ^ 4 := by
    have hb := Nat.pow_le_pow_left (Nat.sub_le (4 * N) 3) 4
    have hnp : 0 < N ^ 4 := pow_pos (by omega) _
    rw [mul_pow] at hb
    norm_num at hb
    nlinarith
  have hbudget : (4 * N - 3) ^ 4 <
      ∏ j, (rectangleDegrees H V j - 3 * (N - 1) + 1) := by
    rw [hTprod] at hprod
    have hm : (((4 * N - 3) ^ 4 : ℕ) : ℝ) < 4096 * (N : ℝ) ^ 4 := by
      exact_mod_cast hmargin
    exact_mod_cast hm.trans hprod
  refine ⟨ht, hbudget, ?_⟩
  apply Nat.le_floor
  have h0 := Nat.floor_le (hpos 0)
  have h1 := Nat.floor_le (hpos 1)
  have h2 := Nat.floor_le (hpos 2)
  change (rectangleDegrees H V 0 : ℝ) ≤ 32 * (H : ℝ) * V at h0
  change (rectangleDegrees H V 1 : ℝ) ≤ 32 * V at h1
  change (rectangleDegrees H V 2 : ℝ) ≤ 32 * V at h2
  push_cast
  nlinarith

theorem coordinate_capacity_bound
    (N H : ℕ) (hN : 1 ≤ N) (hH : 1 ≤ H) (V : ℝ) (hV : (N : ℝ) ≤ V) :
    ((weightBound H V / H : ℕ) : ℝ) ≤ 96 * V ∧
      (((weightBound H V / H + 1) ^ 2 : ℕ) : ℝ) ≤ 97 ^ 2 * V ^ 2 := by
  have hNr : (1 : ℝ) ≤ N := by exact_mod_cast hN
  have hHr : (1 : ℝ) ≤ H := by exact_mod_cast hH
  have hVp : 0 < V := by linarith
  have hW : (weightBound H V : ℝ) ≤ 96 * (H : ℝ) * V :=
    Nat.floor_le (by positivity)
  have hdiv : ((weightBound H V / H : ℕ) : ℝ) * (H : ℝ) ≤ weightBound H V := by
    exact_mod_cast Nat.div_mul_le_self (weightBound H V) H
  have hB : ((weightBound H V / H : ℕ) : ℝ) ≤ 96 * V := by
    nlinarith
  refine ⟨hB, ?_⟩
  have hQ : ((weightBound H V / H + 1 : ℕ) : ℝ) ≤ 97 * V := by
    push_cast
    linarith
  have hs := sq_le_sq₀ (by positivity : 0 ≤ ((weightBound H V / H + 1 : ℕ) : ℝ))
    (by positivity : 0 ≤ 97 * V)
  have hh := hs.mpr hQ
  push_cast at hh ⊢
  nlinarith

theorem capacity_threshold
    (N H : ℕ) (hN : 1 ≤ N) (hH : 1 ≤ H) (V : ℝ)
    (hV : (N : ℝ) ≤ V) (hvol : (H : ℝ) * V ^ 3 = (N : ℝ) ^ 4)
    (hthreshold : 2 * 97 ^ 2 ≤ (H : ℝ) * V) :
    2 * (weightBound H V / H + 1) ^ 2 ≤ N ^ 4 := by
  have hQ := (coordinate_capacity_bound N H hN hH V hV).2
  have ht := mul_le_mul_of_nonneg_right hthreshold (sq_nonneg V)
  have hbound :
      (2 : ℝ) * (((weightBound H V / H + 1) ^ 2 : ℕ) : ℝ) ≤ (N : ℝ) ^ 4 := by
    nlinarith
  exact_mod_cast hbound

def manuscriptScale (N H : ℕ) : ℝ :=
  (H : ℝ) ^ (-(1 : ℝ) / 3) * (N : ℝ) ^ ((4 : ℝ) / 3)

theorem manuscript_scale_weight (N H : ℕ) (hH : 1 ≤ H) :
    (H : ℝ) * manuscriptScale N H =
      (H : ℝ) ^ ((2 : ℝ) / 3) * (N : ℝ) ^ ((4 : ℝ) / 3) := by
  have hHp : (0 : ℝ) < H := by exact_mod_cast (show 0 < H by omega)
  have hh : (H : ℝ) * (H : ℝ) ^ (-(1 : ℝ) / 3) =
      (H : ℝ) ^ ((2 : ℝ) / 3) := by
    calc
      (H : ℝ) * (H : ℝ) ^ (-(1 : ℝ) / 3) =
          (H : ℝ) ^ (1 : ℝ) * (H : ℝ) ^ (-(1 : ℝ) / 3) := by
        rw [Real.rpow_one]
      _ = (H : ℝ) ^ ((1 : ℝ) + (-(1 : ℝ) / 3)) := (Real.rpow_add hHp _ _).symm
      _ = _ := by norm_num
  simpa only [manuscriptScale, ← mul_assoc] using
    congrArg (fun x => x * (N : ℝ) ^ ((4 : ℝ) / 3)) hh

theorem manuscript_scale_properties (N H : ℕ) (hH : 1 ≤ H) (hHN : H ≤ N) :
    (N : ℝ) ≤ manuscriptScale N H ∧
      (H : ℝ) * manuscriptScale N H ^ 3 = (N : ℝ) ^ 4 := by
  have hHp : (0 : ℝ) < H := by exact_mod_cast (show 0 < H by omega)
  have hNp : (0 : ℝ) < N := by exact_mod_cast (show 0 < N by omega)
  have hHN' : (H : ℝ) ≤ N := by exact_mod_cast hHN
  have hHcube :
      ((H : ℝ) ^ (-(1 : ℝ) / 3)) ^ 3 = (H : ℝ)⁻¹ := by
    rw [← Real.rpow_mul_natCast hHp.le]
    norm_num [Real.rpow_neg_one]
  have hNcube : ((N : ℝ) ^ ((4 : ℝ) / 3)) ^ 3 = (N : ℝ) ^ 4 := by
    rw [← Real.rpow_mul_natCast hNp.le]
    norm_num
  have hcube : manuscriptScale N H ^ 3 = (H : ℝ)⁻¹ * (N : ℝ) ^ 4 := by
    simp only [manuscriptScale, mul_pow, hHcube, hNcube]
  have hvolume : (H : ℝ) * manuscriptScale N H ^ 3 = (N : ℝ) ^ 4 := by
    rw [hcube]
    field_simp
  refine ⟨?_, hvolume⟩
  have hVp : 0 < manuscriptScale N H := by
    exact mul_pos (Real.rpow_pos_of_pos hHp _) (Real.rpow_pos_of_pos hNp _)
  have hcube_le : (N : ℝ) ^ 3 ≤ manuscriptScale N H ^ 3 := by
    have hh := mul_le_mul_of_nonneg_right hHN' (pow_nonneg hNp.le 3)
    nlinarith
  exact (pow_le_pow_iff_left₀ hNp.le hVp.le (by norm_num : (3 : ℕ) ≠ 0)).mp hcube_le

end LSChain

noncomputable section

open scoped BigOperators

namespace LSBiquadratic

section Congruences

variable {R : Type*} [CommRing R]

def theta (a b : R) (n : Fin 4 → ℤ) : R :=
  (n 0 : R) + (n 1 : R) * a + (n 2 : R) * b + (n 3 : R) * a * b

def sigmaTheta (a b : R) (n : Fin 4 → ℤ) : R :=
  (n 0 : R) - (n 1 : R) * a + (n 2 : R) * b - (n 3 : R) * a * b

def sigmaTauTheta (a b : R) (n : Fin 4 → ℤ) : R :=
  (n 0 : R) - (n 1 : R) * a - (n 2 : R) * b + (n 3 : R) * a * b

def signedTheta (a b : R) (s : ℤ) (n : Fin 4 → ℤ) : R :=
  (n 0 : R) - (n 1 : R) * a + (s : R) * (n 2 : R) * b -
    (s : R) * (n 3 : R) * a * b

@[simp] theorem signedTheta_one (a b : R) (n : Fin 4 → ℤ) :
    signedTheta a b 1 n = sigmaTheta a b n := by
  simp [signedTheta, sigmaTheta]

@[simp] theorem signedTheta_neg_one (a b : R) (n : Fin 4 → ℤ) :
    signedTheta a b (-1) n = sigmaTauTheta a b n := by
  simp [signedTheta, sigmaTauTheta, sub_eq_add_neg]

/-- Euler's criterion transferred along the canonical map from `ZMod p`. -/
theorem root_pow_eq_legendre_mul (p : ℕ) [Fact p.Prime] [CharP R p]
    (hp2 : p ≠ 2) (d : ℤ) (a : R) (ha : a ^ 2 = (d : R)) :
    a ^ p = (legendreSym p d : R) * a := by
  have hp : p.Prime := Fact.out
  have hpodd : p % 2 = 1 := hp.mod_two_eq_one_iff_ne_two.mpr hp2
  have hexp : p = 2 * (p / 2) + 1 := by omega
  have heuler : (d : R) ^ (p / 2) = (legendreSym p d : R) := by
    have h := congrArg (ZMod.castHom (dvd_refl p) R) (legendreSym.eq_pow p d)
    simpa only [map_intCast, map_pow] using h.symm
  calc
    a ^ p = (a ^ 2) ^ (p / 2) * a := by
      rw [← pow_mul, ← pow_succ, ← hexp]
    _ = (legendreSym p d : R) * a := by rw [ha, heuler]

theorem not_dvd_of_legendre_neg_one (p : ℕ) [Fact p.Prime] (d : ℤ)
    (hd : legendreSym p d = -1) : ¬(p : ℤ) ∣ d := by
  intro h
  have hz : (d : ZMod p) = 0 := (ZMod.intCast_zmod_eq_zero_iff_dvd d p).mpr h
  have hs := (legendreSym.eq_zero_iff p d).mpr hz
  omega

/-- In characteristic `p`, the generator equations determine Frobenius on every tuple. -/
theorem theta_pow_eq_signedTheta (p : ℕ) [Fact p.Prime] [CharP R p]
    (hp2 : p ≠ 2) (d : ℤ) (a b : R)
    (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (n : Fin 4 → ℤ) :
    theta a b n ^ p = signedTheta a b (legendreSym p 2) n := by
  have hap : a ^ p = -a := by
    simpa only [hd, Int.cast_neg, Int.cast_one, neg_one_mul] using
      root_pow_eq_legendre_mul p hp2 d a ha
  have hbp : b ^ p = (legendreSym p 2 : R) * b :=
    root_pow_eq_legendre_mul p hp2 2 b (by simpa using hb)
  have hcoeff (z : ℤ) : (z : R) ^ p = (z : R) := by
    exact map_intCast (frobenius R p) z
  simp only [theta, signedTheta, add_pow_char, mul_pow, hcoeff, hap, hbp]
  ring

/-- Divisibility in any commutative ring, including nonmaximal orders and trivial quotients. -/
theorem prime_dvd_theta_sub_signedTheta (p : ℕ) [Fact p.Prime]
    (hp2 : p ≠ 2) (d : ℤ) (a b : R)
    (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (n : Fin 4 → ℤ) :
    (p : R) ∣ theta a b n ^ p - signedTheta a b (legendreSym p 2) n := by
  let I : Ideal R := Ideal.span {(p : R)}
  let Q := R ⧸ I
  let π : R →+* Q := Ideal.Quotient.mk I
  apply (Ideal.Quotient.eq_zero_iff_dvd (p : R) _).mp
  change π (theta a b n ^ p - signedTheta a b (legendreSym p 2) n) = 0
  rcases subsingleton_or_nontrivial Q with hQ | hQ
  · letI := hQ
    exact Subsingleton.elim _ _
  · letI := hQ
    have hpzero : (p : Q) = 0 := by
      rw [← map_natCast π p]
      exact Ideal.Quotient.mk_singleton_self (p : R)
    letI : CharP Q p :=
      (CharP.charP_iff_prime_eq_zero (Fact.out : p.Prime)).mpr hpzero
    have hqa : (π a) ^ 2 = (d : Q) := by
      simpa only [map_pow, map_intCast] using congrArg π ha
    have hqb : (π b) ^ 2 = (2 : Q) := by
      simpa only [map_pow, map_ofNat] using congrArg π hb
    rw [map_sub, map_pow, sub_eq_zero]
    simpa only [theta, signedTheta, map_add, map_sub, map_mul, map_intCast] using
      theta_pow_eq_signedTheta p hp2 d (π a) (π b) hqa hqb hd n

theorem prime_dvd_theta_sub_sigmaTheta (p : ℕ) [Fact p.Prime]
    (hp2 : p ≠ 2) (d : ℤ) (a b : R)
    (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (h2 : legendreSym p 2 = 1) (n : Fin 4 → ℤ) :
    (p : R) ∣ theta a b n ^ p - sigmaTheta a b n := by
  simpa only [h2, signedTheta_one] using
    prime_dvd_theta_sub_signedTheta p hp2 d a b ha hb hd n

theorem prime_dvd_theta_sub_sigmaTauTheta (p : ℕ) [Fact p.Prime]
    (hp2 : p ≠ 2) (d : ℤ) (a b : R)
    (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (h2 : legendreSym p 2 = -1) (n : Fin 4 → ℤ) :
    (p : R) ∣ theta a b n ^ p - sigmaTauTheta a b n := by
  simpa only [h2, signedTheta_neg_one] using
    prime_dvd_theta_sub_signedTheta p hp2 d a b ha hb hd n

theorem legendre_two_eq_one_or_neg_one (p : ℕ) [Fact p.Prime] (hp2 : p ≠ 2) :
    legendreSym p 2 = 1 ∨ legendreSym p 2 = -1 := by
  apply legendreSym.eq_one_or_neg_one
  have hp : p.Prime := Fact.out
  have hnot : ¬p ∣ 2 := by
    intro h
    exact hp2 ((Nat.prime_dvd_prime_iff_eq hp Nat.prime_two).mp h)
  intro hz
  exact hnot ((ZMod.natCast_eq_zero_iff 2 p).mp (by simpa using hz))

end Congruences

section Projection

def basisVector (a b : ℂ) : Fin 4 → ℂ := ![1, a, b, a * b]

def kernelVector (a b : ℂ) : Fin 4 → ℂ := ![a * b, b, -a, -1]

/-- The rows are `[1,a,b,ab]`, `[1,-a,b,-ab]`, and `[1,-a,-b,ab]`. -/
def conjugateProjection (a b : ℂ) : (Fin 4 → ℂ) →ₗ[ℂ] (Fin 3 → ℂ) where
  toFun x := ![x 0 + a * x 1 + b * x 2 + a * b * x 3,
    x 0 - a * x 1 + b * x 2 - a * b * x 3,
    x 0 - a * x 1 - b * x 2 + a * b * x 3]
  map_add' x y := by
    ext i
    fin_cases i <;> simp <;> ring
  map_smul' t x := by
    ext i
    fin_cases i <;> simp [smul_eq_mul] <;> ring

theorem conjugateProjection_int (a b : ℂ) (n : Fin 4 → ℤ) :
    conjugateProjection a b (fun i => (n i : ℂ)) =
      ![theta a b n, sigmaTheta a b n, sigmaTauTheta a b n] := by
  ext i
  fin_cases i <;> simp [conjugateProjection, theta, sigmaTheta, sigmaTauTheta] <;> ring

theorem conjugateProjection_kernelVector (a b : ℂ) :
    conjugateProjection a b (kernelVector a b) = 0 := by
  ext i
  fin_cases i <;> simp [conjugateProjection, kernelVector] <;> ring

theorem conjugateProjection_surjective (a b : ℂ) (ha : a ≠ 0) (hb : b ≠ 0) :
    Function.Surjective (conjugateProjection a b) := by
  intro y
  refine ⟨![(y 0 + y 2) / 2, (y 0 - y 1) / (2 * a),
    (y 1 - y 2) / (2 * b), 0], ?_⟩
  ext i
  fin_cases i <;> simp [conjugateProjection] <;> field_simp [ha, hb] <;> ring

theorem conjugateProjection_eq_zero_iff (a b : ℂ) (ha : a ≠ 0) (hb : b ≠ 0)
    (x : Fin 4 → ℂ) :
    conjugateProjection a b x = 0 ↔ ∃ t : ℂ, x = t • kernelVector a b := by
  constructor
  · intro hx
    have h0 : x 0 + a * x 1 + b * x 2 + a * b * x 3 = 0 :=
      congrFun hx 0
    have h1 : x 0 - a * x 1 + b * x 2 - a * b * x 3 = 0 :=
      congrFun hx 1
    have h2 : x 0 - a * x 1 - b * x 2 + a * b * x 3 = 0 :=
      congrFun hx 2
    have hx1 : x 1 + b * x 3 = 0 := by
      have h : a * (x 1 + b * x 3) = 0 := by
        linear_combination (1 / 2 : ℂ) * h0 - (1 / 2 : ℂ) * h1
      exact (mul_eq_zero.mp h).resolve_left ha
    have hx2 : x 2 - a * x 3 = 0 := by
      have h : b * (x 2 - a * x 3) = 0 := by
        linear_combination (1 / 2 : ℂ) * h1 - (1 / 2 : ℂ) * h2
      exact (mul_eq_zero.mp h).resolve_left hb
    have hx0 : x 0 + a * b * x 3 = 0 := by
      linear_combination h1 + a * hx1 - b * hx2
    refine ⟨-x 3, ?_⟩
    ext i
    fin_cases i <;> simp [kernelVector, smul_eq_mul]
    · linear_combination hx0
    · linear_combination hx1
    · linear_combination hx2
  · rintro ⟨t, rfl⟩
    simp [conjugateProjection_kernelVector]

theorem conjugateProjection_ker (a b : ℂ) (ha : a ≠ 0) (hb : b ≠ 0) :
    LinearMap.ker (conjugateProjection a b) = Submodule.span ℂ {kernelVector a b} := by
  ext x
  simp only [LinearMap.mem_ker, conjugateProjection_eq_zero_iff a b ha hb,
    Submodule.mem_span_singleton]
  constructor <;> rintro ⟨t, ht⟩ <;> exact ⟨t, ht.symm⟩

/-- This equivalence is only a signed reindexing; no number-field hypothesis is hidden. -/
theorem linearIndependent_kernelVector_iff (a b : ℂ) :
    LinearIndependent ℚ (kernelVector a b) ↔ LinearIndependent ℚ (basisVector a b) := by
  constructor
  · intro h
    have hr := h.comp Fin.rev Fin.rev_injective
    have hs := hr.units_smul (![-1, -1, 1, 1] : Fin 4 → ℚˣ)
    convert hs using 1
    ext i
    fin_cases i <;>
      norm_num [kernelVector, basisVector, Function.comp_def, Fin.rev, Pi.smul_apply,
        Units.smul_def]
  · intro h
    have hr := h.comp Fin.rev Fin.rev_injective
    have hs := hr.units_smul (![1, 1, -1, -1] : Fin 4 → ℚˣ)
    convert hs using 1
    ext i
    fin_cases i <;>
      norm_num [kernelVector, basisVector, Function.comp_def, Fin.rev, Pi.smul_apply,
        Units.smul_def]

theorem kernelVector_rationally_independent (a b : ℂ)
    (h : LinearIndependent ℚ (![1, a, b, a * b] : Fin 4 → ℂ)) :
    LinearIndependent ℚ (kernelVector a b) :=
  (linearIndependent_kernelVector_iff a b).mpr h

theorem explicit_projection_data (a b : ℂ) (ha : a ≠ 0) (hb : b ≠ 0)
    (h : LinearIndependent ℚ (![1, a, b, a * b] : Fin 4 → ℂ)) :
    Function.Surjective (conjugateProjection a b) ∧
      (∀ x, conjugateProjection a b x = 0 ↔ ∃ t : ℂ, x = t • kernelVector a b) ∧
      LinearIndependent ℚ (kernelVector a b) :=
  ⟨conjugateProjection_surjective a b ha hb,
    conjugateProjection_eq_zero_iff a b ha hb, kernelVector_rationally_independent a b h⟩

end Projection

end LSBiquadratic

noncomputable section

open Set Submodule

namespace LSScalarDescent

variable {K L : Type*} [Field K] [Field L] [Algebra K L] {n : ℕ}

def entryMap (x : Fin n → K) : Fin n → L := algebraMap K L ∘ x

local notation "emb" => (entryMap (L := L))

theorem span_forward (S : Set (Fin n → K)) {x : Fin n → K}
    (hx : x ∈ Submodule.span K S) :
    emb x ∈ Submodule.span L (emb '' S) := by
  induction hx using Submodule.span_induction with
  | mem y hy => exact Submodule.subset_span ⟨y, hy, rfl⟩
  | zero => simp [entryMap]
  | add y z hy hz ihy ihz =>
    have he : emb (y + z) = emb y + emb z := by
      ext j
      simp [entryMap]
    rw [he]
    exact (Submodule.span L (emb '' S)).add_mem ihy ihz
  | smul a y hy ih =>
    have he : emb (a • y) = algebraMap K L a • emb y := by
      ext j
      simp [entryMap, Algebra.smul_def]
    rw [he]
    exact (Submodule.span L (emb '' S)).smul_mem (algebraMap K L a) ih

theorem independent_span_descent {ι : Type*} (v : ι → Fin n → K)
    (hv : LinearIndependent K v) (x : Fin n → K) :
    x ∈ Submodule.span K (Set.range v) ↔
      emb x ∈ Submodule.span L (Set.range (fun i => emb (v i))) := by
  have hvL : LinearIndependent L (fun i => emb (v i)) :=
    linearIndependent_algebraMap_comp_iff.mpr hv
  have hop := (linearIndependent_algebraMap_comp_iff
    (R := K) (S := L) (v := fun o : Option ι => Option.casesOn' o x v))
  have hfun :
      (fun o : Option ι => algebraMap K L ∘ Option.casesOn' o x v) =
        (fun o => Option.casesOn' o (emb x) (fun i => emb (v i))) := by
    funext o
    cases o <;> rfl
  rw [hfun, linearIndependent_option', linearIndependent_option'] at hop
  simp only [hv, hvL, true_and] at hop
  exact not_iff_not.mp hop.symm

theorem span_descent (S : Set (Fin n → K)) (x : Fin n → K) :
    x ∈ Submodule.span K S ↔ emb x ∈ Submodule.span L (emb '' S) := by
  let b := Module.Basis.ofVectorSpace K (Submodule.span K S)
  let v := (Submodule.span K S).subtype ∘ b
  have hv : LinearIndependent K v :=
    b.linearIndependent.map' _ (Submodule.ker_subtype _)
  have hvspan : Submodule.span K (Set.range v) = Submodule.span K S := by
    rw [show Set.range v = (Submodule.span K S).subtype '' Set.range b from
      Set.range_comp _ _, ← Submodule.map_span, b.span_eq,
      Submodule.map_top, Submodule.range_subtype]
  have hrange :
      (emb '' Set.range v : Set (Fin n → L)) =
        Set.range (fun i => emb (v i)) := (Set.range_comp _ _).symm
  have hmapped :
      Submodule.span L (emb '' S) =
        Submodule.span L (Set.range (fun i => emb (v i))) := by
    apply le_antisymm
    · apply Submodule.span_le.mpr
      rintro _ ⟨y, hy, rfl⟩
      rw [← hrange]
      apply span_forward
      rw [hvspan]
      exact Submodule.subset_span hy
    · apply Submodule.span_le.mpr
      rintro _ ⟨i, rfl⟩
      exact span_forward S (b i).property
  rw [hmapped, ← independent_span_descent v hv x, hvspan]

theorem earlier_span_descent {ι : Type*} [LinearOrder ι]
    (row : ι → Fin n → K) (i : ι) :
    row i ∈ Submodule.span K (row '' Set.Iio i) ↔
      emb (row i) ∈
        Submodule.span L ((fun j => emb (row j)) '' Set.Iio i) := by
  simpa only [Set.image_image, Function.comp_def] using
    span_descent (L := L) (row '' Set.Iio i) (row i)

end LSScalarDescent

noncomputable section

open scoped BigOperators
open Finset Matrix

namespace LSChain

theorem interpolation_polynomial
    (N : ℕ) (hN : 1 ≤ N) (t : Fin 3 → ℕ)
    (ht : ∀ j, 3 * (N - 1) ≤ t j)
    (hdim : (4 * N - 3) ^ 4 < ∏ j, (t j - 3 * (N - 1) + 1))
    (A : LSRectInterpolation.C4 →ₗ[ℂ] LSRectInterpolation.C3)
    (hA : Function.Surjective A)
    (c : LSRectInterpolation.C4)
    (hker : ∀ x, A x = 0 ↔ ∃ z : ℂ, x = z • c)
    (hc : LinearIndependent ℚ c) (y : LSRectInterpolation.intBox N → ℂ) :
    ∃ p : LSRectInterpolation.Poly, (∀ j, p.degreeOf j ≤ t j) ∧
      ∀ n : LSRectInterpolation.intBox N,
        MvPolynomial.eval (A (LSRectInterpolation.castPoint n)) p = y n :=
  LSRectInterpolation.rectangular_interpolation_of_selection
    lattice_selection N hN t ht hdim A hA c hker hc y

theorem greedy_scalar_extension
    {K L : Type*} [Field K] [Field L] [Algebra K L]
    {ι : Type*} [LinearOrder ι] {n : ℕ} (row : ι → Fin n → K) :
    LSGenericGreedy.greedySet K row =
      LSGenericGreedy.greedySet L
        (fun i => LSScalarDescent.entryMap (L := L) (row i)) := by
  ext i
  exact not_congr (LSScalarDescent.earlier_span_descent (L := L) row i)

theorem concentration_from_capacity
    (N H : ℕ) (hN : 1 ≤ N) (hH : 1 ≤ H) (V : ℝ)
    (hV : (N : ℝ) ≤ V) (hvol : (H : ℝ) * V ^ 3 = (N : ℝ) ^ 4)
    (S₁ S₂ : ℕ)
    (hpack : (N ^ 4) ^ 2 ≤ 4 * (weightBound H V / H + 1) ^ 2 * S₁)
    (hsmall : S₂ ≤ 2 * (weightBound H V / H) * N ^ 4) :
    (N : ℝ) ^ 4 * (H : ℝ) * V / (4 * 97 ^ 2) ≤ (S₁ : ℝ) ∧
      (S₂ : ℝ) ≤ 192 * (N : ℝ) ^ 4 * V := by
  have hNr : (1 : ℝ) ≤ N := by exact_mod_cast hN
  have hVp : 0 < V := by linarith
  have hB := coordinate_capacity_bound N H hN hH V hV
  have hpackr :
      ((N : ℝ) ^ 4) ^ 2 ≤
        4 * (((weightBound H V / H + 1) ^ 2 : ℕ) : ℝ) * (S₁ : ℝ) := by
    exact_mod_cast hpack
  have hpack' : ((N : ℝ) ^ 4) ^ 2 ≤ 4 * 97 ^ 2 * V ^ 2 * (S₁ : ℝ) := by
    have hh := mul_le_mul_of_nonneg_right hB.2 (by positivity : 0 ≤ 4 * (S₁ : ℝ))
    nlinarith
  have hcancel :
      ((N : ℝ) ^ 4 * (H : ℝ) * V) * V ^ 2 ≤
        (4 * 97 ^ 2 * (S₁ : ℝ)) * V ^ 2 := by
    calc
      ((N : ℝ) ^ 4 * (H : ℝ) * V) * V ^ 2 = ((N : ℝ) ^ 4) ^ 2 := by
        rw [← hvol]
        ring
      _ ≤ _ := by nlinarith [hpack']
  have hraw := le_of_mul_le_mul_right hcancel (sq_pos_of_pos hVp)
  refine ⟨(div_le_iff₀ (by norm_num : (0 : ℝ) < 4 * 97 ^ 2)).mpr ?_, ?_⟩
  · nlinarith [hraw]
  · have hs : (S₂ : ℝ) ≤
        2 * ((weightBound H V / H : ℕ) : ℝ) * (N : ℝ) ^ 4 := by
      exact_mod_cast hsmall
    have hb := mul_le_mul_of_nonneg_right hB.1
      (by positivity : 0 ≤ 2 * (N : ℝ) ^ 4)
    nlinarith

theorem manuscript_construction
    {R : Type*} [CommRing R] (f : R →+* ℂ) (hf : Function.Injective f)
    (N H : ℕ) (hH : 1 ≤ H) (hHN : H ≤ N)
    [LinearOrder (Candidate H (weightBound H (manuscriptScale N H)))]
    (horder : ∀ a b : Candidate H (weightBound H (manuscriptScale N H)),
      weight H (candidateExponent a) < weight H (candidateExponent b) → a < b)
    (A : LSRectInterpolation.C4 →ₗ[ℂ] LSRectInterpolation.C3)
    (hA : Function.Surjective A)
    (c : LSRectInterpolation.C4)
    (hker : ∀ x, A x = 0 ↔ ∃ z : ℂ, x = z • c)
    (hc : LinearIndependent ℚ c)
    (coordinates : LSRectInterpolation.intBox N → Fin 3 → R)
    (hcoordinates : ∀ n j, f (coordinates n j) =
      A (LSRectInterpolation.castPoint n) j)
    (P : Finset ℕ) (side : ℕ → Bool)
    (hp : ∀ p ∈ P, H < p)
    (hfrob : ∀ p ∈ P, ∀ n,
      (p : R) ∣ coordinates n 0 ^ p - target (coordinates n) (side p))
    (hthreshold : 2 * 97 ^ 2 ≤ (H : ℝ) * manuscriptScale N H) :
    ∃ g : Fin (N ^ 4) ↪o Candidate H (weightBound H (manuscriptScale N H)),
      Set.range g = LSGenericGreedy.greedySet ℂ
        (fun a j => f (candidateRow (fun j => coordinates (gridEnumeration N j)) a j)) ∧
      (retainedMatrix (fun j => coordinates (gridEnumeration N j)) g).det ≠ 0 ∧
      (∀ i, (weight H (candidateExponent (g i)) : ℝ) ≤
        96 * (H : ℝ) * manuscriptScale N H) ∧
      (∀ p ∈ P, (p : R) ^ (∑ i : Fin (N ^ 4), candidateExponent (g i) 0 / p) ∣
        (retainedMatrix (fun j => coordinates (gridEnumeration N j)) g).det) ∧
      ((N : ℝ) ^ 4 * (H : ℝ) * manuscriptScale N H / (4 * 97 ^ 2) ≤
        ((∑ i : Fin (N ^ 4), candidateExponent (g i) 0) : ℝ)) ∧
      (((∑ i : Fin (N ^ 4),
          (candidateExponent (g i) 1 + candidateExponent (g i) 2)) : ℕ) : ℝ) ≤
        192 * (N : ℝ) ^ 4 * manuscriptScale N H := by
  have hN : 1 ≤ N := hH.trans hHN
  have hs := manuscript_scale_properties N H hH hHN
  have hb := rectangle_budget N H hN hH (manuscriptScale N H) hs.1 hs.2
  obtain ⟨g, hgreedy, hdet, hw, hdiv, hpack, hsmall⟩ :=
    constructed_core f hf N hN H (weightBound H (manuscriptScale N H)) hH
      horder (rectangleDegrees H (manuscriptScale N H)) hb.1 hb.2.1 hb.2.2
      (capacity_threshold N H hN hH (manuscriptScale N H) hs.1 hs.2 hthreshold)
      A hA c hker hc coordinates hcoordinates P side hp hfrob
  have hconc := concentration_from_capacity N H hN hH (manuscriptScale N H) hs.1 hs.2
    _ _ hpack hsmall
  refine ⟨g, hgreedy, hdet, ?_, hdiv, ?_, hconc.2⟩
  · intro i
    have hwr : (weight H (candidateExponent (g i)) : ℝ) ≤
        weightBound H (manuscriptScale N H) := by exact_mod_cast hw i
    exact hwr.trans (Nat.floor_le (by
      have hpos : 0 < manuscriptScale N H :=
        lt_of_lt_of_le (by exact_mod_cast (show 0 < N by omega)) hs.1
      positivity))
  · simpa only [Nat.cast_sum] using hconc.1

def biquadraticCoordinates {R : Type*} [CommRing R] (a b : R)
    (n : Fin 4 → ℤ) : Fin 3 → R :=
  ![LSBiquadratic.theta a b n, LSBiquadratic.sigmaTheta a b n,
    LSBiquadratic.sigmaTauTheta a b n]

theorem biquadratic_coordinates_map
    {R : Type*} [CommRing R] (f : R →+* ℂ) (a b : R)
    (n : Fin 4 → ℤ) (j : Fin 3) :
    f (biquadraticCoordinates a b n j) =
      LSBiquadratic.conjugateProjection (f a) (f b) (fun i => (n i : ℂ)) j := by
  rw [LSBiquadratic.conjugateProjection_int]
  fin_cases j <;>
    simp [biquadraticCoordinates, LSBiquadratic.theta, LSBiquadratic.sigmaTheta,
      LSBiquadratic.sigmaTauTheta]

def primeSymbol (p : ℕ) (d : ℤ) : ℤ :=
  if hp : p.Prime then @legendreSym p ⟨hp⟩ d else 0

def frobeniusSide (p : ℕ) : Bool := decide (primeSymbol p 2 = 1)

theorem biquadratic_frobenius
    {R : Type*} [CommRing R] (p : ℕ) [Fact p.Prime] (hp2 : p ≠ 2)
    (d : ℤ) (a b : R) (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (n : Fin 4 → ℤ) :
    (p : R) ∣ biquadraticCoordinates a b n 0 ^ p -
      target (biquadraticCoordinates a b n) (frobeniusSide p) := by
  rcases LSBiquadratic.legendre_two_eq_one_or_neg_one p hp2 with h2 | h2
  · simpa [biquadraticCoordinates, target, frobeniusSide, primeSymbol,
      (Fact.out : p.Prime), h2] using
      LSBiquadratic.prime_dvd_theta_sub_sigmaTheta p hp2 d a b ha hb hd h2 n
  · simpa [biquadraticCoordinates, target, frobeniusSide, primeSymbol,
      (Fact.out : p.Prime), h2] using
      LSBiquadratic.prime_dvd_theta_sub_sigmaTauTheta p hp2 d a b ha hb hd h2 n

theorem simultaneous_prime_powers
    {R : Type*} [CommRing R] (P : Finset ℕ) (E : ℕ → ℕ) (z : R)
    (hprime : ∀ p ∈ P, p.Prime)
    (hdiv : ∀ p ∈ P, (p : R) ^ E p ∣ z) :
    (∏ p ∈ P, (p : R) ^ E p) ∣ z := by
  apply UniformDeterminant.simultaneous_coprime_factors P (fun p => (p : R) ^ E p) z
    _ hdiv
  intro p hp q hq hne
  apply IsCoprime.pow
  apply Nat.Coprime.cast
  exact (hprime p hp).coprime_iff_not_dvd.mpr
    (fun hd => hne ((Nat.prime_dvd_prime_iff_eq (hprime p hp) (hprime q hq)).mp hd))

theorem biquadratic_manuscript_chain
    {R : Type*} [CommRing R] (f : R →+* ℂ) (hf : Function.Injective f)
    (d : ℤ) (a b : R) (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hdegree : LinearIndependent ℚ (LSBiquadratic.basisVector (f a) (f b)))
    (N H : ℕ) (hH : 1 ≤ H) (hHN : H ≤ N)
    [LinearOrder (Candidate H (weightBound H (manuscriptScale N H)))]
    (horder : ∀ a b : Candidate H (weightBound H (manuscriptScale N H)),
      weight H (candidateExponent a) < weight H (candidateExponent b) → a < b)
    (P : Finset ℕ)
    (hprime : ∀ p ∈ P, p.Prime)
    (hp2 : ∀ p ∈ P, p ≠ 2)
    (hpH : ∀ p ∈ P, H < p)
    (hd : ∀ p ∈ P, primeSymbol p d = -1)
    (hthreshold : 2 * 97 ^ 2 ≤ (H : ℝ) * manuscriptScale N H) :
    ∃ g : Fin (N ^ 4) ↪o Candidate H (weightBound H (manuscriptScale N H)),
      let Δ := (retainedMatrix
        (fun j => biquadraticCoordinates a b (gridEnumeration N j)) g).det
      Set.range g = LSGenericGreedy.greedySet ℂ
        (fun α j => f (candidateRow
          (fun j => biquadraticCoordinates a b (gridEnumeration N j)) α j)) ∧
      Δ ≠ 0 ∧
      (∀ i, (weight H (candidateExponent (g i)) : ℝ) ≤
        96 * (H : ℝ) * manuscriptScale N H) ∧
      ((∏ p ∈ P, (p : R) ^ (∑ i : Fin (N ^ 4), candidateExponent (g i) 0 / p)) ∣ Δ) ∧
      ((N : ℝ) ^ 4 * (H : ℝ) * manuscriptScale N H / (4 * 97 ^ 2) ≤
        ((∑ i : Fin (N ^ 4), candidateExponent (g i) 0) : ℝ)) ∧
      (((∑ i : Fin (N ^ 4),
          (candidateExponent (g i) 1 + candidateExponent (g i) 2)) : ℕ) : ℝ) ≤
        192 * (N : ℝ) ^ 4 * manuscriptScale N H := by
  have ha0 : f a ≠ 0 := by
    simpa [LSBiquadratic.basisVector] using hdegree.ne_zero 1
  have hb0 : f b ≠ 0 := by
    simpa [LSBiquadratic.basisVector] using hdegree.ne_zero 2
  have hdata := LSBiquadratic.explicit_projection_data (f a) (f b) ha0 hb0 hdegree
  obtain ⟨g, hgreedy, hdet, hw, hdiv, hS₁, hS₂⟩ :=
    manuscript_construction f hf N H hH hHN horder
      (LSBiquadratic.conjugateProjection (f a) (f b)) hdata.1
      (LSBiquadratic.kernelVector (f a) (f b)) hdata.2.1 hdata.2.2
      (fun n => biquadraticCoordinates a b n)
      (fun n j => biquadratic_coordinates_map f a b n j)
      P frobeniusSide hpH (by
        intro p hp n
        letI : Fact p.Prime := ⟨hprime p hp⟩
        have hdp : legendreSym p d = -1 := by
          simpa [primeSymbol, hprime p hp] using hd p hp
        exact biquadratic_frobenius p (hp2 p hp) d a b ha hb hdp n)
      hthreshold
  exact ⟨g, hgreedy, hdet, hw, simultaneous_prime_powers P _ _ hprime hdiv, hS₁, hS₂⟩

theorem simultaneous_integral_norm
    {R : Type*} [CommRing R] [IsDomain R]
    (basis : Module.Basis (Fin 4) ℤ R)
    (P : Finset ℕ) (E : ℕ → ℕ) (z : R) (hz : z ≠ 0)
    (hprime : ∀ p ∈ P, p.Prime)
    (hdiv : ∀ p ∈ P, (p : R) ^ E p ∣ z) :
    Algebra.norm ℤ z ≠ 0 ∧
      (∏ p ∈ P, (p : ℤ) ^ (4 * E p)) ∣ Algebra.norm ℤ z := by
  refine ⟨(Algebra.norm_ne_zero_iff_of_basis basis).mpr hz, ?_⟩
  apply simultaneous_prime_powers P (fun p => 4 * E p) _ hprime
  intro p hp
  obtain ⟨w, hw⟩ := hdiv p hp
  refine ⟨Algebra.norm ℤ w, ?_⟩
  rw [hw, map_mul, map_pow]
  have hnorm : Algebra.norm ℤ (p : R) = (p : ℤ) ^ 4 := by
    simpa using Algebra.norm_algebraMap_of_basis basis (p : ℤ)
  rw [hnorm, ← pow_mul]

theorem full_chain
    {R : Type*} [CommRing R] [IsDomain R]
    (basis : Module.Basis (Fin 4) ℤ R)
    (f : R →+* ℂ) (hf : Function.Injective f)
    (d : ℤ) (a b : R) (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hdegree : LinearIndependent ℚ (LSBiquadratic.basisVector (f a) (f b)))
    (N H : ℕ) (hH : 1 ≤ H) (hHN : H ≤ N)
    [LinearOrder (Candidate H (weightBound H (manuscriptScale N H)))]
    (horder : ∀ a b : Candidate H (weightBound H (manuscriptScale N H)),
      weight H (candidateExponent a) < weight H (candidateExponent b) → a < b)
    (P : Finset ℕ) (hprime : ∀ p ∈ P, p.Prime)
    (hp2 : ∀ p ∈ P, p ≠ 2) (hpH : ∀ p ∈ P, H < p)
    (hd : ∀ p ∈ P, primeSymbol p d = -1)
    (hthreshold : 2 * 97 ^ 2 ≤ (H : ℝ) * manuscriptScale N H) :
    ∃ g : Fin (N ^ 4) ↪o Candidate H (weightBound H (manuscriptScale N H)),
      let Δ := (retainedMatrix
        (fun j => biquadraticCoordinates a b (gridEnumeration N j)) g).det
      Set.range g = LSGenericGreedy.greedySet ℂ
        (fun α j => f (candidateRow
          (fun j => biquadraticCoordinates a b (gridEnumeration N j)) α j)) ∧
      Δ ≠ 0 ∧
      (∀ i, (weight H (candidateExponent (g i)) : ℝ) ≤
        96 * (H : ℝ) * manuscriptScale N H) ∧
      ((∏ p ∈ P, (p : R) ^ (∑ i : Fin (N ^ 4), candidateExponent (g i) 0 / p)) ∣ Δ) ∧
      ((N : ℝ) ^ 4 * (H : ℝ) * manuscriptScale N H / (4 * 97 ^ 2) ≤
        ((∑ i : Fin (N ^ 4), candidateExponent (g i) 0) : ℝ)) ∧
      ((((∑ i : Fin (N ^ 4),
          (candidateExponent (g i) 1 + candidateExponent (g i) 2)) : ℕ) : ℝ) ≤
        192 * (N : ℝ) ^ 4 * manuscriptScale N H) ∧
      Algebra.norm ℤ Δ ≠ 0 ∧
      (∏ p ∈ P, (p : ℤ) ^
        (4 * ∑ i : Fin (N ^ 4), candidateExponent (g i) 0 / p)) ∣ Algebra.norm ℤ Δ := by
  obtain ⟨g, hgreedy, hdet, hw, hprod, hS₁, hS₂⟩ :=
    biquadratic_manuscript_chain f hf d a b ha hb hdegree
      N H hH hHN horder P hprime hp2 hpH hd hthreshold
  have hdiv : ∀ p ∈ P,
      (p : R) ^ (∑ i : Fin (N ^ 4), candidateExponent (g i) 0 / p) ∣
        (retainedMatrix (fun j => biquadraticCoordinates a b (gridEnumeration N j)) g).det :=
    fun p hp => (Finset.dvd_prod_of_mem _ hp).trans hprod
  have hnorm := simultaneous_integral_norm basis P
    (fun p => ∑ i : Fin (N ^ 4), candidateExponent (g i) 0 / p) _ hdet hprime hdiv
  exact ⟨g, hgreedy, hdet, hw, hprod, hS₁, hS₂, hnorm.1, hnorm.2⟩

end LSChain

#print axioms LSChain.interpolation_polynomial
#print axioms LSChain.constructed_core
#print axioms LSChain.greedy_scalar_extension
#print axioms LSChain.biquadratic_manuscript_chain
#print axioms LSChain.full_chain
