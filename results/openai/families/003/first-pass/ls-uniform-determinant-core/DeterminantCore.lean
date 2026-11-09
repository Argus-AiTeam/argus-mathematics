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
