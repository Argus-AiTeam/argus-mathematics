import Mathlib

open scoped BigOperators

namespace FrobeniusCore

theorem weight_reduction {A : Type*} [CommMonoid A]
    (z c : A) (p j : ℕ) (hz : z ^ p = c) :
    z ^ j = c ^ (j / p) * z ^ (j % p) := by
  calc
    z ^ j = z ^ (j % p + p * (j / p)) := by rw [Nat.mod_add_div]
    _ = z ^ (j % p) * (z ^ p) ^ (j / p) := by rw [pow_add, pow_mul]
    _ = c ^ (j / p) * z ^ (j % p) := by rw [hz, mul_comm]

def reducedWeight {A : Type*} [Zero A] [Pow A ℕ]
    (p j : ℕ) (c : A) : Fin p → A :=
  fun r => if r.val = j % p then c ^ (j / p) else 0

theorem constant_weight_projection {A : Type*} [Zero A] [Pow A ℕ]
    (p j : ℕ) (hp : 0 < p) (c : A) :
    reducedWeight p j c ⟨0, hp⟩ =
      if p ∣ j then c ^ (j / p) else 0 := by
  simp only [reducedWeight, Nat.dvd_iff_mod_eq_zero]
  by_cases h : j % p = 0 <;> simp [h, eq_comm]

theorem coordinate_surjective {A X : Type*} {p : ℕ}
    (hp : 0 < p) (f : X → (Fin p → A)) (hf : Function.Surjective f) :
    Function.Surjective (fun x => f x ⟨0, hp⟩) := by
  intro a
  obtain ⟨x, hx⟩ := hf (fun _ => a)
  exact ⟨x, congrFun hx ⟨0, hp⟩⟩

def complement {n p : ℕ} (a : Fin n → Fin p) : Fin n → Fin p :=
  fun i => Fin.rev (a i)

theorem complement_involutive {n p : ℕ} :
    Function.Involutive (@complement n p) := by
  intro a
  funext i
  simp [complement]

theorem exponent_pair {n p : ℕ} (a : Fin n → Fin p) (i : Fin n) :
    (a i).val + (complement a i).val = p - 1 := by
  have h := (a i).isLt
  simp only [complement, Fin.val_rev]
  omega

theorem degree_pair {n p : ℕ} (a : Fin n → Fin p) :
    (∑ i, (a i).val) + (∑ i, (complement a i).val) = n * (p - 1) := by
  rw [← Finset.sum_add_distrib]
  simp [exponent_pair]

theorem truncated_rank (n p : ℕ) :
    Fintype.card (Fin n → Fin p) = p ^ n := by
  simp

theorem coordinate_exponent_sum {n p : ℕ} (i : Fin n) :
    2 * (∑ a : Fin n → Fin p, ((a i).val : ℚ)) =
      (p : ℚ) ^ n * ((p - 1 : ℕ) : ℚ) := by
  let e : (Fin n → Fin p) ≃ (Fin n → Fin p) :=
    { toFun := complement
      invFun := complement
      left_inv := complement_involutive
      right_inv := complement_involutive }
  have hs :
      (∑ a : Fin n → Fin p, ((complement a i).val : ℚ)) =
      ∑ a : Fin n → Fin p, ((a i).val : ℚ) :=
    by simpa [e] using e.sum_comp (fun a => ((a i).val : ℚ))
  have hpairs :
      (∑ a : Fin n → Fin p,
        (((a i).val : ℚ) + ((complement a i).val : ℚ))) =
        (p : ℚ) ^ n * ((p - 1 : ℕ) : ℚ) := by
    calc
      _ = ∑ _a : Fin n → Fin p, ((p - 1 : ℕ) : ℚ) := by
        apply Finset.sum_congr rfl
        intro a _
        exact_mod_cast exponent_pair a i
      _ = _ := by simp
  rw [Finset.sum_add_distrib, hs] at hpairs
  linarith

theorem jet_threshold (n k p : ℕ) (hk : 0 < k)
    (hp : (2 * n + 2) * (k - 1) ≤ p) :
    (2 * n + 1) * (p - 1) ≤ (2 * n + 2) * (k * (p / k)) := by
  have hrem : p % k ≤ k - 1 := by
    have := Nat.mod_lt p hk
    omega
  have hm := Nat.mul_le_mul_left (2 * n + 2) hrem
  have hd := Nat.mod_add_div p k
  have hdiff : (2 * n + 2) * (p % k) ≤ p := le_trans hm hp
  have hprod :
      (2 * n + 2) * (k * (p / k)) +
          (2 * n + 2) * (p % k) =
        (2 * n + 2) * p := by
    rw [← Nat.mul_add]
    congr 1
    omega
  have hlast : (2 * n + 1) * (p - 1) ≤ (2 * n + 1) * p :=
    Nat.mul_le_mul_left _ (Nat.sub_le _ _)
  nlinarith

theorem chord_step_identity (a b A B t Y : ℚ) :
    a * A + t * ((a + b) * B - a * A) - (a + b * t) * Y =
      (a + b * t) * (A + t * (B - A) - Y) +
        b * (B - A) * t * (1 - t) := by
  ring

theorem product_chord {ι : Type*} (s : Finset ι) (a b : ι → ℚ)
    (ha : ∀ i ∈ s, 0 ≤ a i) (hb : ∀ i ∈ s, 0 ≤ b i)
    (t : ℚ) (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    (∏ i ∈ s, (a i + b i * t)) ≤
      (∏ i ∈ s, a i) +
        t * ((∏ i ∈ s, (a i + b i)) - ∏ i ∈ s, a i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert i s hi ih =>
    have hai := ha i (by simp)
    have hbi := hb i (by simp)
    have has : ∀ j ∈ s, 0 ≤ a j := fun j hj => ha j (by simp [hj])
    have hbs : ∀ j ∈ s, 0 ≤ b j := fun j hj => hb j (by simp [hj])
    have hab :
        (∏ j ∈ s, a j) ≤ ∏ j ∈ s, (a j + b j) := by
      apply Finset.prod_le_prod has
      intro j hj
      linarith [hbs j hj]
    have hfac : 0 ≤ a i + b i * t := by positivity
    have hslack := sub_nonneg.mpr (ih has hbs)
    simp only [Finset.prod_insert hi]
    apply sub_nonneg.mp
    rw [chord_step_identity]
    exact add_nonneg (mul_nonneg hfac hslack)
      (mul_nonneg (mul_nonneg (mul_nonneg hbi (sub_nonneg.mpr hab)) ht0)
        (sub_nonneg.mpr ht1))

theorem explicit_uniform_error {ι : Type*} (s : Finset ι) (a b : ι → ℚ)
    (ha : ∀ i ∈ s, 0 ≤ a i) (hb : ∀ i ∈ s, 0 ≤ b i)
    (p : ℚ) (hp : 1 ≤ p) :
    (∏ i ∈ s, (a i + b i / p)) ≤
      (∏ i ∈ s, a i) +
        ((∏ i ∈ s, (a i + b i)) - ∏ i ∈ s, a i) / p := by
  have hp0 : 0 < p := by linarith
  have ht0 : 0 ≤ 1 / p := le_of_lt (one_div_pos.mpr hp0)
  have ht1 : 1 / p ≤ 1 := (div_le_iff₀ hp0).mpr (by simpa using hp)
  simpa only [div_eq_mul_inv, one_mul, mul_one, mul_comm] using
    product_chord s a b ha hb (1 / p) ht0 ht1

theorem explicit_rank_threshold {ι : Type*} (s : Finset ι) (a b : ι → ℚ)
    (ha : ∀ i ∈ s, 0 ≤ a i) (hb : ∀ i ∈ s, 0 ≤ b i)
    (p L : ℚ) (hp : 1 ≤ p)
    (hgap : (∏ i ∈ s, a i) < L)
    (hthreshold :
      ((∏ i ∈ s, (a i + b i)) - ∏ i ∈ s, a i) /
        (L - ∏ i ∈ s, a i) < p) :
    (∏ i ∈ s, (a i + b i / p)) < L := by
  have hp0 : 0 < p := by linarith
  have he := (div_lt_iff₀ (sub_pos.mpr hgap)).mp hthreshold
  have he' :
      ((∏ i ∈ s, (a i + b i)) - ∏ i ∈ s, a i) / p <
        L - ∏ i ∈ s, a i :=
    (div_lt_iff₀ hp0).mpr (by nlinarith [he])
  linarith [explicit_uniform_error s a b ha hb p hp]

theorem filtration_sum_bound {ι : Type*} (s : Finset ι)
    (e h : ι → ℚ) (P : ℚ) (hh : ∀ i ∈ s, h i ≤ e i * P) :
    (∑ i ∈ s, h i) ≤ (∑ i ∈ s, e i) * P := by
  calc
    _ ≤ ∑ i ∈ s, e i * P := Finset.sum_le_sum hh
    _ = _ := (Finset.sum_mul s e P).symm

theorem evaluation_dimension_bound {K V : Type*} [Field K]
    [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (e m : ℕ) (f : V →ₗ[K] (Fin e → Fin m → K))
    (hf : Function.Injective f) :
    Module.finrank K V ≤ e * m := by
  have h := LinearMap.finrank_le_finrank_of_injective hf
  simpa [Module.finrank_pi_fintype] using h

theorem evaluated_filtration_dimension_bound {K ι V : Type*} [Field K]
    [Fintype ι] [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (pieces : ι → Type*) [∀ i, AddCommGroup (pieces i)]
    [∀ i, Module K (pieces i)] [∀ i, FiniteDimensional K (pieces i)]
    (e : ι → ℕ) (m : ℕ) (f : V →ₗ[K] (∀ i, pieces i))
    (hf : Function.Injective f)
    (g : ∀ i, pieces i →ₗ[K] (Fin (e i) → Fin m → K))
    (hg : ∀ i, Function.Injective (g i)) :
    Module.finrank K V ≤ (∑ i, e i) * m := by
  have h := LinearMap.finrank_le_finrank_of_injective hf
  rw [Module.finrank_pi_fintype] at h
  calc
    Module.finrank K V ≤ ∑ i, Module.finrank K (pieces i) := h
    _ ≤ ∑ i, e i * m := Finset.sum_le_sum
      (fun i _ => evaluation_dimension_bound (e i) m (g i) (hg i))
    _ = _ := (Finset.sum_mul _ _ _).symm

theorem floor_count_factor (p a b : ℚ) (hp : 0 < p)
    (ha : 0 ≤ a) (hb : 1 ≤ b) :
    ((Nat.floor (p * a + b - 1) + 1 : ℕ) : ℚ) ≤
      p * (a + b / p) := by
  have hx : 0 ≤ p * a + b - 1 := by nlinarith
  have hfloor := Nat.floor_le hx
  calc
    ((Nat.floor (p * a + b - 1) + 1 : ℕ) : ℚ) ≤ p * a + b := by
      push_cast
      linarith
    _ = p * (a + b / p) := by field_simp [ne_of_gt hp]

def flagCount {n : ℕ} (p : ℕ) (a b : Fin n → ℚ) : ℕ :=
  ∏ i, (Nat.floor ((p : ℚ) * a i + b i - 1) + 1)

theorem flag_count_bound {n : ℕ} (p : ℕ) (hp : 0 < p)
    (a b : Fin n → ℚ) (ha : ∀ i, 0 ≤ a i) (hb : ∀ i, 1 ≤ b i) :
    (flagCount p a b : ℚ) ≤
      (p : ℚ) ^ n * ∏ i, (a i + b i / (p : ℚ)) := by
  have hpq : (0 : ℚ) < p := by exact_mod_cast hp
  calc
    (flagCount p a b : ℚ) =
        ∏ i, ((Nat.floor ((p : ℚ) * a i + b i - 1) + 1 : ℕ) : ℚ) := by
      simp [flagCount]
    _ ≤ ∏ i, ((p : ℚ) * (a i + b i / (p : ℚ))) := by
      apply Finset.prod_le_prod
      · intro i _
        positivity
      · intro i _
        exact floor_count_factor p (a i) (b i) hpq (ha i) (hb i)
    _ = _ := by rw [Finset.prod_mul_distrib]; simp

theorem rank_from_evaluations {K ι V : Type*} [Field K] [Fintype ι]
    [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (pieces : ι → Type*) [∀ i, AddCommGroup (pieces i)]
    [∀ i, Module K (pieces i)] [∀ i, FiniteDimensional K (pieces i)]
    {n : ℕ} (p : ℕ) (hp : 0 < p) (e : ι → ℕ)
    (he : (∑ i, e i) = p ^ n) (a b : Fin n → ℚ)
    (ha : ∀ i, 0 ≤ a i) (hb : ∀ i, 1 ≤ b i)
    (f : V →ₗ[K] (∀ i, pieces i)) (hf : Function.Injective f)
    (g : ∀ i, pieces i →ₗ[K] (Fin (e i) → Fin (flagCount p a b) → K))
    (hg : ∀ i, Function.Injective (g i)) :
    (Module.finrank K V : ℚ) ≤
      (p : ℚ) ^ (2 * n) * ∏ i, (a i + b i / (p : ℚ)) := by
  have hdim := evaluated_filtration_dimension_bound pieces e
    (flagCount p a b) f hf g hg
  rw [he] at hdim
  have hdimq :
      (Module.finrank K V : ℚ) ≤ (p : ℚ) ^ n * (flagCount p a b : ℚ) := by
    exact_mod_cast hdim
  have hcount := mul_le_mul_of_nonneg_left (flag_count_bound p hp a b ha hb)
    (show (0 : ℚ) ≤ (p : ℚ) ^ n by positivity)
  calc
    (Module.finrank K V : ℚ) ≤ (p : ℚ) ^ n * (flagCount p a b : ℚ) := hdimq
    _ ≤ (p : ℚ) ^ n * ((p : ℚ) ^ n *
        ∏ i, (a i + b i / (p : ℚ))) := hcount
    _ = _ := by rw [two_mul, pow_add]; ring

theorem product_mem_ideal_power {A ι : Type*} [CommRing A]
    (I : Ideal A) (f : ι → A) (s : Finset ι) :
    (∀ i ∈ s, f i ∈ I) → (∏ i ∈ s, f i) ∈ I ^ s.card := by
  classical
  induction s using Finset.induction_on with
  | empty => intro _; simp
  | @insert i s hi ih =>
    intro h
    rw [Finset.prod_insert hi, Finset.card_insert_of_notMem hi, pow_succ']
    exact Ideal.mul_mem_mul (h i (by simp))
      (ih (fun j hj => h j (by simp [hj])))

theorem det_mem_power_of_columns {A : Type*} [CommRing A] {N : ℕ}
    (I : Ideal A) (M : Matrix (Fin N) (Fin N) A)
    (Z : Finset (Fin N)) (hZ : ∀ j ∈ Z, ∀ i, M i j ∈ I) :
    M.det ∈ I ^ Z.card := by
  classical
  have hterm (σ : Equiv.Perm (Fin N)) :
      (∏ i, M (σ i) i) ∈ I ^ Z.card := by
    have hzprod :=
      product_mem_ideal_power I (fun i => M (σ i) i) Z
        (fun i hi => hZ i hi (σ i))
    rw [← Finset.prod_sdiff (Finset.subset_univ Z)]
    exact (I ^ Z.card).mul_mem_left _ hzprod
  rw [Matrix.det_apply']
  apply Ideal.sum_mem
  intro σ _
  exact (I ^ Z.card).mul_mem_left _ (hterm σ)

theorem det_mem_power_of_rows {A : Type*} [CommRing A] {N : ℕ}
    (I : Ideal A) (M : Matrix (Fin N) (Fin N) A)
    (Z : Finset (Fin N)) (hZ : ∀ i ∈ Z, ∀ j, M i j ∈ I) :
    M.det ∈ I ^ Z.card := by
  have h := det_mem_power_of_columns I M.transpose Z hZ
  simpa using h

theorem explicit_order_threshold (epsilon E p : ℚ) (hp : 0 < p)
    (hgap : 80 * epsilon < 3 / 4)
    (hthreshold : 2 * E / (3 / 4 - 80 * epsilon) < p) :
    80 * epsilon + 2 * E / p < 3 / 4 := by
  have he := (div_lt_iff₀ (sub_pos.mpr hgap)).mp hthreshold
  have he' : 2 * E / p < 3 / 4 - 80 * epsilon :=
    (div_lt_iff₀ hp).mpr (by nlinarith [he])
  linarith

theorem multiplicity_contradiction (R rank order B U : ℚ)
    (hR : 0 < R) (hB : B < 1 / 4) (hU : U < 3 / 4)
    (hrank : rank ≤ R * B) (hlower : R - rank ≤ order)
    (hupper : order ≤ R * U) : False := by
  have hr := mul_lt_mul_of_pos_left hB hR
  have ho := mul_lt_mul_of_pos_left hU hR
  nlinarith

theorem finite_data_algebraic_obstruction {ι : Type*}
    (s : Finset ι) (a b : ι → ℚ)
    (ha : ∀ i ∈ s, 0 ≤ a i) (hb : ∀ i ∈ s, 0 ≤ b i)
    (p epsilon E R rank order : ℚ)
    (hp : 1 ≤ p) (hR : 0 < R)
    (hsmall : (∏ i ∈ s, a i) < 1 / 4)
    (hsmallOrder : 80 * epsilon < 3 / 4)
    (hrankThreshold :
      ((∏ i ∈ s, (a i + b i)) - ∏ i ∈ s, a i) /
        (1 / 4 - ∏ i ∈ s, a i) < p)
    (horderThreshold : 2 * E / (3 / 4 - 80 * epsilon) < p)
    (hrank : rank ≤ R * (∏ i ∈ s, (a i + b i / p)))
    (hlower : R - rank ≤ order)
    (hupper : order ≤ R * (80 * epsilon + 2 * E / p)) : False := by
  exact multiplicity_contradiction R rank order _ _ hR
    (explicit_rank_threshold s a b ha hb p (1 / 4) hp hsmall hrankThreshold)
    (explicit_order_threshold epsilon E p (by linarith) hsmallOrder horderThreshold)
    hrank hlower hupper

end FrobeniusCore
