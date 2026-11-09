import Mathlib

noncomputable section

namespace CovarianceLocality

abbrev Cube (A : Type*) := A → Bool

def bit : Bool → ℝ
  | false => 0
  | true => 1

variable {A B : Type*} [Fintype A] [Fintype B]
  [DecidableEq A] [DecidableEq B]

structure Law (A B : Type*) [Fintype A] [Fintype B]
    [DecidableEq A] [DecidableEq B] where
  mass : Cube A → Cube B → ℝ
  nonneg : ∀ x y, 0 ≤ mass x y
  normalized : ∑ x, ∑ y, mass x y = 1

def expectation (p : Law A B) (f : Cube A → Cube B → ℝ) : ℝ :=
  ∑ x, ∑ y, p.mass x y * f x y

def covariance (p : Law A B) (f : Cube A → ℝ) (g : Cube B → ℝ) : ℝ :=
  expectation p (fun x y => f x * g y) -
    expectation p (fun x _ => f x) * expectation p (fun _ y => g y)

def NegAssociated (p : Law A B) : Prop :=
  ∀ (f : Cube A → ℝ) (g : Cube B → ℝ),
    Monotone f → Monotone g → covariance p f g ≤ 0

def rank (x : Cube A) : ℝ := ∑ i, bit (x i)

def atom (a x : Cube A) : ℝ := if x = a then 1 else 0

omit [DecidableEq A] in
theorem atom_bounds (a x : Cube A) : 0 ≤ atom a x ∧ atom a x ≤ 1 := by
  classical
  unfold atom
  split_ifs <;> norm_num

omit [Fintype A] [DecidableEq A] in
theorem bit_monotone (i : A) : Monotone (fun x : Cube A => bit (x i)) := by
  intro x y h
  have hi := h i
  cases hx : x i <;> cases hy : y i <;> simp_all [bit]
  exact False.elim ((by decide : ¬ ((true : Bool) ≤ false)) hi)

theorem rank_gap {x y : Cube A} (h : x ≤ y) (hne : x ≠ y) :
    rank x + 1 ≤ rank y := by
  classical
  have hex : ∃ i, x i ≠ y i := by
    by_contra hn
    push Not at hn
    exact hne (funext hn)
  obtain ⟨i, hi⟩ := hex
  have hgap : 1 ≤ bit (y i) - bit (x i) := by
    have hxy := h i
    cases hx : x i <;> cases hy : y i <;> simp_all [bit]
    exact False.elim ((by decide : ¬ ((true : Bool) ≤ false)) hxy)
  have hs : bit (y i) - bit (x i) ≤
      ∑ j, (bit (y j) - bit (x j)) :=
    Finset.single_le_sum
      (fun j _ => sub_nonneg.mpr (bit_monotone j h)) (Finset.mem_univ i)
  rw [Finset.sum_sub_distrib] at hs
  change bit (y i) - bit (x i) ≤ rank y - rank x at hs
  linarith

theorem rank_add_bounded_monotone (f : Cube A → ℝ)
    (hf : ∀ x, 0 ≤ f x ∧ f x ≤ 1) :
    Monotone (fun x => rank x + f x) := by
  intro x y h
  by_cases he : x = y
  · subst y
    exact le_rfl
  · have hg := rank_gap h he
    obtain ⟨hfx0, hfx1⟩ := hf x
    obtain ⟨hfy0, hfy1⟩ := hf y
    linarith

theorem rank_sub_bounded_monotone (f : Cube A → ℝ)
    (hf : ∀ x, 0 ≤ f x ∧ f x ≤ 1) :
    Monotone (fun x => rank x - f x) := by
  intro x y h
  by_cases he : x = y
  · subst y
    exact le_rfl
  · have hg := rank_gap h he
    obtain ⟨hfx0, hfx1⟩ := hf x
    obtain ⟨hfy0, hfy1⟩ := hf y
    linarith

theorem covariance_add_left (p : Law A B) (f h : Cube A → ℝ)
    (g : Cube B → ℝ) :
    covariance p (fun x => f x + h x) g =
      covariance p f g + covariance p h g := by
  simp only [covariance, expectation, add_mul, mul_add, Finset.sum_add_distrib]
  ring

theorem covariance_sub_left (p : Law A B) (f h : Cube A → ℝ)
    (g : Cube B → ℝ) :
    covariance p (fun x => f x - h x) g =
      covariance p f g - covariance p h g := by
  simp only [covariance, expectation, sub_mul, mul_sub, Finset.sum_sub_distrib]
  ring

theorem covariance_add_right (p : Law A B) (f : Cube A → ℝ)
    (g h : Cube B → ℝ) :
    covariance p f (fun y => g y + h y) =
      covariance p f g + covariance p f h := by
  simp only [covariance, expectation, mul_add, Finset.sum_add_distrib]
  ring

theorem covariance_sub_right (p : Law A B) (f : Cube A → ℝ)
    (g h : Cube B → ℝ) :
    covariance p f (fun y => g y - h y) =
      covariance p f g - covariance p f h := by
  simp only [covariance, expectation, mul_sub, Finset.sum_sub_distrib]
  ring

theorem covariance_sum_left {K : Type*} (p : Law A B) (s : Finset K)
    (f : K → Cube A → ℝ) (g : Cube B → ℝ) :
    covariance p (fun x => ∑ i ∈ s, f i x) g =
      ∑ i ∈ s, covariance p (f i) g := by
  classical
  induction s using Finset.induction_on with
  | empty => simp [covariance, expectation]
  | @insert i s hi ih =>
      simp only [Finset.sum_insert hi]
      rw [covariance_add_left, ih]

theorem covariance_sum_right {K : Type*} (p : Law A B) (s : Finset K)
    (f : Cube A → ℝ) (g : K → Cube B → ℝ) :
    covariance p f (fun y => ∑ j ∈ s, g j y) =
      ∑ j ∈ s, covariance p f (g j) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp [covariance, expectation]
  | @insert j s hj ih =>
      simp only [Finset.sum_insert hj]
      rw [covariance_add_right, ih]

theorem rank_covariance (p : Law A B) :
    covariance p rank rank =
      ∑ i, ∑ j, covariance p (fun x => bit (x i)) (fun y => bit (y j)) := by
  unfold rank
  rw [covariance_sum_left]
  apply Finset.sum_congr rfl
  intro i _
  exact covariance_sum_right p Finset.univ (fun x => bit (x i))
    (fun j y => bit (y j))

theorem bounded_covariance_zero (p : Law A B) (hna : NegAssociated p)
    (hzero : covariance p rank rank = 0)
    (f : Cube A → ℝ) (g : Cube B → ℝ)
    (hf : ∀ x, 0 ≤ f x ∧ f x ≤ 1)
    (hg : ∀ y, 0 ≤ g y ∧ g y ≤ 1) :
    covariance p f g = 0 := by
  have hpp := hna (fun x => rank x + f x) (fun y => rank y + g y)
    (rank_add_bounded_monotone f hf) (rank_add_bounded_monotone g hg)
  have hpm := hna (fun x => rank x + f x) (fun y => rank y - g y)
    (rank_add_bounded_monotone f hf) (rank_sub_bounded_monotone g hg)
  have hmp := hna (fun x => rank x - f x) (fun y => rank y + g y)
    (rank_sub_bounded_monotone f hf) (rank_add_bounded_monotone g hg)
  have hmm := hna (fun x => rank x - f x) (fun y => rank y - g y)
    (rank_sub_bounded_monotone f hf) (rank_sub_bounded_monotone g hg)
  simp only [covariance_add_left, covariance_sub_left,
    covariance_add_right, covariance_sub_right] at hpp hpm hmp hmm
  linarith

theorem factorization_of_zero_rank_covariance (p : Law A B)
    (hna : NegAssociated p) (hzero : covariance p rank rank = 0) :
    ∀ x y, p.mass x y = (∑ v, p.mass x v) * (∑ u, p.mass u y) := by
  classical
  intro x y
  have hc := bounded_covariance_zero p hna hzero (atom x) (atom y)
    (atom_bounds x) (atom_bounds y)
  have he : p.mass x y - (∑ v, p.mass x v) * (∑ u, p.mass u y) = 0 := by
    simpa [covariance, expectation, atom, mul_ite, ite_mul] using hc
  exact sub_eq_zero.mp he

theorem covariance_locality (p : Law A B) (hna : NegAssociated p)
    (hpair : ∀ i j,
      covariance p (fun x => bit (x i)) (fun y => bit (y j)) = 0) :
    ∀ x y, p.mass x y = (∑ v, p.mass x v) * (∑ u, p.mass u y) := by
  apply factorization_of_zero_rank_covariance p hna
  rw [rank_covariance]
  simp [hpair]

end CovarianceLocality

#print axioms CovarianceLocality.factorization_of_zero_rank_covariance
#print axioms CovarianceLocality.covariance_locality
