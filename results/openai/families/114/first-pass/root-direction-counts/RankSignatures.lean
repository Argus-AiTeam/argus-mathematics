import Mathlib

/-!
The finite-minimum proof works for arbitrary integral submodular functions and
integer baselines.  Monotonicity and nonnegative baselines are unnecessary:
complementing the minimization variable implements deletion directly.
-/

noncomputable section

open Finset

namespace RankSignatures

set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false

attribute [local instance] Classical.propDecidable

variable {E P I : Type*} [Fintype E] [DecidableEq E]
  [Fintype P] [DecidableEq P] [Fintype I] [DecidableEq I]

def Submodular (f : Finset E → ℤ) : Prop :=
  ∀ A B, f (A ∪ B) + f (A ∩ B) ≤ f A + f B

def minimizer (h : Finset E → ℤ) : Finset E :=
  Classical.choose (Finset.exists_min_image univ h univ_nonempty)

def minimum (h : Finset E → ℤ) : ℤ := h (minimizer h)

theorem minimum_le (h : Finset E → ℤ) (A : Finset E) :
    minimum h ≤ h A :=
  (Classical.choose_spec (Finset.exists_min_image univ h univ_nonempty)).2 A
    (mem_univ A)

theorem minimum_mono {h k : Finset E → ℤ} (hk : ∀ A, h A ≤ k A) :
    minimum h ≤ minimum k :=
  (minimum_le h (minimizer k)).trans (hk _)

theorem minimum_add_const (h : Finset E → ℤ) (c : ℤ) :
    minimum (fun A => h A + c) = minimum h + c := by
  apply le_antisymm
  · exact (minimum_le _ (minimizer h))
  · have := minimum_le h (minimizer (fun A => h A + c))
    dsimp [minimum] at *
    omega

def hits (g : P → E) (T : Finset P) (A : Finset E) : ℤ :=
  ∑ p ∈ T, if g p ∈ A then 0 else 1

theorem hits_univ (g : P → E) (T : Finset P) (A : Finset E) :
    hits g T A = ∑ p, if p ∈ T ∧ g p ∉ A then (1 : ℤ) else 0 := by
  calc
    hits g T A = ∑ p ∈ T, if p ∈ T ∧ g p ∉ A then (1 : ℤ) else 0 := by
      apply sum_congr rfl
      intro p hp
      by_cases ha : g p ∈ A <;> simp [hits, hp, ha]
    _ = ∑ p, if p ∈ T ∧ g p ∉ A then (1 : ℤ) else 0 :=
      sum_subset (subset_univ T) (by intros; simp_all)

theorem hits_joint (g : P → E) (S T : Finset P) (A B : Finset E) :
    hits g (S ∪ T) (A ∪ B) + hits g (S ∩ T) (A ∩ B) ≤
      hits g S A + hits g T B := by
  simp only [hits_univ, ← sum_add_distrib]
  apply sum_le_sum
  intro p _
  by_cases hs : p ∈ S <;> by_cases ht : p ∈ T <;>
    by_cases ha : g p ∈ A <;> by_cases hb : g p ∈ B <;>
    simp [hs, ht, ha, hb]

theorem hits_insert_bounds (g : P → E) (T : Finset P) (p : P)
    (A : Finset E) :
    hits g T A ≤ hits g (insert p T) A ∧
      hits g (insert p T) A ≤ hits g T A + 1 := by
  by_cases hp : p ∈ T
  · simp [insert_eq_of_mem hp]
  · simp only [hits, sum_insert hp]
    split_ifs <;> omega

def contractedRank (h : Finset E → ℤ) (g : P → E) (T : Finset P) : ℤ :=
  minimum (fun A => h A + hits g T A) - minimum h

structure RankLike (r : Finset P → ℤ) : Prop where
  empty : r ∅ = 0
  submod : Submodular r
  insert_lower : ∀ T p, r T ≤ r (insert p T)
  insert_upper : ∀ T p, r (insert p T) ≤ r T + 1

theorem contractedRank_rankLike (h : Finset E → ℤ) (hh : Submodular h)
    (g : P → E) : RankLike (contractedRank h g) := by
  constructor
  · simp [contractedRank, hits]
  · intro S T
    let A := minimizer (fun A => h A + hits g S A)
    let B := minimizer (fun A => h A + hits g T A)
    have hu := minimum_le (fun A => h A + hits g (S ∪ T) A) (A ∪ B)
    have hi := minimum_le (fun A => h A + hits g (S ∩ T) A) (A ∩ B)
    have h₁ := hh A B
    have h₂ := hits_joint g S T A B
    dsimp [contractedRank, minimum, A, B] at *
    omega
  · intro T p
    dsimp [contractedRank]
    have := minimum_mono (fun A => (show h A + hits g T A ≤
      h A + hits g (insert p T) A from
      add_le_add_right (hits_insert_bounds g T p A).1 _))
    omega
  · intro T p
    have hle := minimum_mono (fun A => (show h A + hits g (insert p T) A ≤
      (h A + hits g T A) + 1 from by
      have := (hits_insert_bounds g T p A).2
      omega))
    rw [minimum_add_const] at hle
    dsimp [contractedRank]
    omega

theorem RankLike.mono {r : Finset P → ℤ} (hr : RankLike r)
    {S T : Finset P} (hST : S ⊆ T) : r S ≤ r T := by
  have hall : ∀ D, r S ≤ r (S ∪ D) := by
    intro D
    induction D using Finset.induction_on with
    | empty => simp
    | insert p D hp ih =>
      simpa only [union_insert] using ih.trans (hr.insert_lower (S ∪ D) p)
  simpa only [union_eq_right.mpr hST] using hall T

theorem RankLike.singleton {r : Finset P → ℤ} (hr : RankLike r) (p : P) :
    r {p} = 0 ∨ r {p} = 1 := by
  have hl := hr.insert_lower ∅ p
  have hu := hr.insert_upper ∅ p
  simp only [hr.empty, insert_empty_eq] at hl hu
  omega

theorem RankLike.pair_bounds {r : Finset P → ℤ} (hr : RankLike r) (p q : P) :
    max (r {p}) (r {q}) ≤ r {p, q} ∧ r {p, q} ≤ r {p} + r {q} := by
  constructor
  · exact max_le
      (hr.mono (by intro a ha; simp_all))
      (hr.mono (by intro a ha; simp_all))
  · by_cases hpq : p = q
    · subst q
      have := hr.singleton p
      simp_all
      omega
    · have := hr.submod {p} {q}
      have he : ({p} : Finset P) ∩ {q} = ∅ := by
        ext a
        simp
        aesop
      simpa [he, hr.empty] using this

def Parallel (r : Finset P → ℤ) (p q : P) : Prop :=
  r {p} = 1 ∧ r {q} = 1 ∧ r {p, q} = 1

theorem parallel_symm {r : Finset P → ℤ} {p q : P}
    (h : Parallel r p q) : Parallel r q p := by
  simpa [Parallel, pair_comm, and_left_comm, and_assoc] using h

theorem parallel_trans {r : Finset P → ℤ} (hr : RankLike r) {p q s : P}
    (hpq : Parallel r p q) (hqs : Parallel r q s) : Parallel r p s := by
  refine ⟨hpq.1, hqs.2.1, ?_⟩
  have hsub := hr.submod {p, q} {q, s}
  have hi : r {q} ≤ r ({p, q} ∩ {q, s}) :=
    hr.mono (by intro a ha; simp_all)
  have hu : r {p, s} ≤ r ({p, q} ∪ {q, s}) :=
    hr.mono (by intro a ha; simp_all; aesop)
  have hl := (hr.pair_bounds p s).1
  simp only [Parallel] at hpq hqs
  omega

theorem pair_defect {r : Finset P → ℤ} (hr : RankLike r) (p q : P) :
    r {p} + r {q} - r {p, q} = if Parallel r p q then 1 else 0 := by
  classical
  have hp := hr.singleton p
  have hq := hr.singleton q
  have hb := hr.pair_bounds p q
  by_cases h : Parallel r p q
  · simp only [if_pos h]
    rcases h with ⟨h₁, h₂, h₃⟩
    omega
  · simp only [if_neg h]
    simp only [Parallel, not_and] at h
    omega

def outside (v : E → ℤ) (A : Finset E) : ℤ :=
  ∑ e, if e ∈ A then 0 else v e

theorem outside_modular (v : E → ℤ) (A B : Finset E) :
    outside v (A ∪ B) + outside v (A ∩ B) = outside v A + outside v B := by
  simp only [outside, ← sum_add_distrib]
  apply sum_congr rfl
  intro e _
  by_cases ha : e ∈ A <;> by_cases hb : e ∈ B <;> simp [ha, hb]

def rankMinimum (f : Finset E → ℤ) (v : E → ℤ) : ℤ :=
  minimum (fun A => f A + outside v A)

theorem cost_submodular (f : Finset E → ℤ) (hf : Submodular f) (v : E → ℤ) :
    Submodular (fun A => f A + outside v A) := by
  intro A B
  have := hf A B
  have := outside_modular v A B
  dsimp
  omega

theorem Submodular.compl {h : Finset E → ℤ} (hh : Submodular h) :
    Submodular (fun A => h Aᶜ) := by
  intro A B
  simpa only [compl_union, compl_inter, add_comm] using hh Aᶜ Bᶜ

theorem minimum_compl (h : Finset E → ℤ) :
    minimum (fun A => h Aᶜ) = minimum h := by
  apply le_antisymm
  · have := minimum_le (fun A => h Aᶜ) (minimizer h)ᶜ
    simpa [minimum] using this
  · exact minimum_le h _

def copyRank (h : Finset E → ℤ) (g : I → E) :
    Finset (I × Bool) → ℤ :=
  contractedRank h (fun p => g p.1)

theorem copyRank_single (h : Finset E → ℤ) (g : I → E)
    (i : I) (a b : Bool) :
    copyRank h g {(i, a)} = copyRank h g {(i, b)} := by
  simp [copyRank, contractedRank, hits]

theorem copyRank_pair (h : Finset E → ℤ) (g : I → E)
    (p q p' q' : I × Bool) (hpq : p ≠ q) (hpq' : p' ≠ q')
    (hp : p.1 = p'.1) (hq : q.1 = q'.1) :
    copyRank h g {p, q} = copyRank h g {p', q'} := by
  simp [copyRank, contractedRank, hits, hpq, hpq', hp, hq]

def CountParallel (h : Finset E → ℤ) (g : I → E) (i j : I) : Prop :=
  Parallel (copyRank h g) (i, false) (j, true)

theorem countParallel_symm (h : Finset E → ℤ) (g : I → E)
    {i j : I} (hij : CountParallel h g i j) : CountParallel h g j i := by
  rcases hij with ⟨hi, hj, hp⟩
  refine ⟨?_, ?_, ?_⟩
  · simpa only [copyRank_single h g j true false] using hj
  · simpa only [copyRank_single h g i false true] using hi
  · rw [pair_comm (j, false) (i, true)]
    rw [copyRank_pair h g (i, true) (j, false) (i, false) (j, true)
      (by simp) (by simp) rfl rfl]
    exact hp

theorem countParallel_trans (h : Finset E → ℤ) (hh : Submodular h) (g : I → E)
    {i j k : I} (hij : CountParallel h g i j) (hjk : CountParallel h g j k) :
    CountParallel h g i k := by
  by_cases he : i = j
  · subst j
    exact hjk
  · have hij' : Parallel (copyRank h g) (i, false) (j, false) := by
      refine ⟨hij.1, ?_, ?_⟩
      · simpa only [copyRank_single h g j true false] using hij.2.1
      · rw [copyRank_pair h g (i, false) (j, false) (i, false) (j, true)
          (by simpa using he) (by simp) rfl rfl]
        exact hij.2.2
    exact parallel_trans (contractedRank_rankLike h hh _) hij' hjk

def PartialSetoid (R : I → I → Prop)
    (hs : ∀ i j, R i j → R j i)
    (ht : ∀ i j k, R i j → R j k → R i k) : Setoid I where
  r i j := i = j ∨ R i j
  iseqv := ⟨fun _ => Or.inl rfl,
    fun h => h.elim (fun h => Or.inl h.symm) (fun h => Or.inr (hs _ _ h)),
    fun h₁ h₂ => by
      rcases h₁ with rfl | h₁
      · exact h₂
      rcases h₂ with rfl | h₂
      · exact Or.inr h₁
      exact Or.inr (ht _ _ _ h₁ h₂)⟩

def classFeature (R : I → I → Prop)
    (hs : ∀ i j, R i j → R j i)
    (ht : ∀ i j k, R i j → R j k → R i k)
    (c : Quotient (PartialSetoid R hs ht)) (i : I) : ℝ :=
  if R i i ∧ Quotient.mk (PartialSetoid R hs ht) i = c then 1 else 0

noncomputable instance partialSetoidFintype (R : I → I → Prop)
    (hs : ∀ i j, R i j → R j i)
    (ht : ∀ i j k, R i j → R j k → R i k) :
    Fintype (Quotient (PartialSetoid R hs ht)) :=
  Fintype.ofFinite _

theorem partial_relation_gram (R : I → I → Prop)
    (hs : ∀ i j, R i j → R j i)
    (ht : ∀ i j k, R i j → R j k → R i k) (i j : I) :
    (if R i j then (1 : ℝ) else 0) =
      ∑ c : Quotient (PartialSetoid R hs ht),
        classFeature R hs ht c i * classFeature R hs ht c j := by
  classical
  have hclass : Quotient.mk (PartialSetoid R hs ht) i =
      Quotient.mk (PartialSetoid R hs ht) j ↔ i = j ∨ R i j :=
    Quotient.eq
  by_cases hij : R i j
  · have hii := ht i j i hij (hs i j hij)
    have hjj := ht j i j (hs i j hij) hij
    have hc := hclass.mpr (Or.inr hij)
    simp [classFeature, hii, hjj, ← hc, hij]
  · by_cases hii : R i i
    · have hc : Quotient.mk (PartialSetoid R hs ht) i ≠
          Quotient.mk (PartialSetoid R hs ht) j := by
        intro he
        rcases hclass.mp he with rfl | he
        · exact hij hii
        · exact hij he
      have hz : ∀ c, classFeature R hs ht c i * classFeature R hs ht c j = 0 := by
        intro c
        by_cases hic : Quotient.mk (PartialSetoid R hs ht) i = c
        · by_cases hjc : Quotient.mk (PartialSetoid R hs ht) j = c
          · exact False.elim (hc (hic.trans hjc.symm))
          · simp [classFeature, hjc]
        · simp [classFeature, hic]
      simp [hij, hz]
    · simp [classFeature, hii, hij]

theorem partial_relation_nonneg (R : I → I → Prop)
    (hs : ∀ i j, R i j → R j i)
    (ht : ∀ i j k, R i j → R j k → R i k) (x : I → ℝ) :
    0 ≤ ∑ i, ∑ j, x i * (if R i j then (1 : ℝ) else 0) * x j := by
  classical
  have he : (∑ i, ∑ j, x i * (if R i j then (1 : ℝ) else 0) * x j) =
      ∑ c : Quotient (PartialSetoid R hs ht),
        (∑ i, x i * classFeature R hs ht c i) ^ 2 := by
    simp only [partial_relation_gram R hs ht, sum_mul, mul_sum]
    calc
      _ = ∑ i, ∑ c : Quotient (PartialSetoid R hs ht), ∑ j,
          x i * (classFeature R hs ht c i * classFeature R hs ht c j) * x j := by
        apply sum_congr rfl
        intro i _
        exact sum_comm
      _ = ∑ c : Quotient (PartialSetoid R hs ht), ∑ i, ∑ j,
          x i * (classFeature R hs ht c i * classFeature R hs ht c j) * x j :=
        sum_comm
      _ = _ := by
        apply sum_congr rfl
        intro c _
        simp only [pow_two, sum_mul, mul_sum]
        rw [sum_comm]
        apply sum_congr rfl
        intro i _
        apply sum_congr rfl
        intro j _
        ring
  rw [he]
  exact sum_nonneg (by intro c _; exact sq_nonneg _)

def sign (s : Bool) : ℤ := if s then 1 else -1

def step (v : E → ℤ) (e : E) (s : Bool) : E → ℤ :=
  v + Pi.single e (sign s)

theorem outside_add (v w : E → ℤ) (A : Finset E) :
    outside (v + w) A = outside v A + outside w A := by
  simp only [outside, ← sum_add_distrib, Pi.add_apply]
  apply sum_congr rfl
  intro e _
  split_ifs <;> simp

theorem outside_single (e : E) (a : ℤ) (A : Finset E) :
    outside (Pi.single e a) A = if e ∈ A then 0 else a := by
  unfold outside
  rw [sum_eq_single e]
  · simp
  · intro b _ hbe
    simp [Pi.single_apply, hbe]
  · simp

theorem outside_step (v : E → ℤ) (e : E) (s : Bool) (A : Finset E) :
    outside (step v e s) A = outside v A + if e ∈ A then 0 else sign s := by
  exact (outside_add v (Pi.single e (sign s)) A).trans (by rw [outside_single])

def orientedCost (f : Finset E → ℤ) (v : E → ℤ) (s : Bool) (A : Finset E) : ℤ :=
  if s then f A + outside v A else f Aᶜ + outside v Aᶜ

theorem orientedCost_submodular (f : Finset E → ℤ) (hf : Submodular f)
    (v : E → ℤ) (s : Bool) : Submodular (orientedCost f v s) := by
  cases s
  · exact (cost_submodular f hf v).compl
  · exact cost_submodular f hf v

theorem minimum_orientedCost (f : Finset E → ℤ) (v : E → ℤ) (s : Bool) :
    minimum (orientedCost f v s) = rankMinimum f v := by
  cases s
  · exact minimum_compl (fun A : Finset E => f A + outside v A)
  · rfl

theorem orientedCost_step (f : Finset E → ℤ) (v : E → ℤ)
    (e : E) (s : Bool) (A : Finset E) :
    orientedCost f (step v e s) s A + (if s then 0 else 1) =
      orientedCost f v s A + (if e ∈ A then 0 else 1) := by
  cases s <;> by_cases he : e ∈ A <;>
    simp [orientedCost, outside_step, sign, he] <;> ring

def localRank (f : Finset E → ℤ) (v : E → ℤ) (g : I → E) (s : Bool) :
    Finset (I × Bool) → ℤ :=
  copyRank (orientedCost f v s) g

theorem localRank_single (f : Finset E → ℤ) (v : E → ℤ) (g : I → E)
    (s : Bool) (i : I) (a : Bool) :
    localRank f v g s {(i, a)} =
      rankMinimum f (step v (g i) s) - rankMinimum f v + (if s then 0 else 1) := by
  have he : (fun A => orientedCost f v s A + hits (fun p : I × Bool => g p.1)
      {(i, a)} A) =
      (fun A => orientedCost f (step v (g i) s) s A + (if s then 0 else 1)) := by
    funext A
    simpa [hits] using (orientedCost_step f v (g i) s A).symm
  dsimp [localRank, copyRank, contractedRank]
  rw [he, minimum_add_const, minimum_orientedCost, minimum_orientedCost]
  ring

theorem localRank_pair (f : Finset E → ℤ) (v : E → ℤ) (g : I → E)
    (s : Bool) (i j : I) :
    localRank f v g s {(i, false), (j, true)} =
      rankMinimum f (step (step v (g i) s) (g j) s) - rankMinimum f v +
        2 * (if s then 0 else 1) := by
  have he : (fun A => orientedCost f v s A + hits (fun p : I × Bool => g p.1)
      {(i, false), (j, true)} A) =
      (fun A => orientedCost f (step (step v (g i) s) (g j) s) s A +
        2 * (if s then 0 else 1)) := by
    funext A
    have h₁ := orientedCost_step f v (g i) s A
    have h₂ := orientedCost_step f (step v (g i) s) (g j) s A
    simp only [hits, sum_pair (by simp : (i, false) ≠ (j, true))]
    omega
  dsimp [localRank, copyRank, contractedRank]
  rw [he, minimum_add_const, minimum_orientedCost, minimum_orientedCost]
  ring

def relation (f : Finset E → ℤ) (v : E → ℤ) (g : I → E) (s : Bool) : I → I → Prop :=
  CountParallel (orientedCost f v s) g

theorem rank_defect (f : Finset E → ℤ) (hf : Submodular f)
    (v : E → ℤ) (g : I → E) (s : Bool) (i j : I) :
    rankMinimum f (step v (g i) s) + rankMinimum f (step v (g j) s) -
        rankMinimum f (step (step v (g i) s) (g j) s) - rankMinimum f v =
      if relation f v g s i j then 1 else 0 := by
  have hr : RankLike (localRank f v g s) :=
    contractedRank_rankLike _ (orientedCost_submodular f hf v s) _
  have hd := pair_defect hr (i, false) (j, true)
  change _ = if Parallel (localRank f v g s) (i, false) (j, true) then 1 else 0
  rw [localRank_single, localRank_single, localRank_pair] at hd
  omega

def penalty (f : Finset E → ℤ) (v : E → ℤ) : ℤ :=
  (∑ e, v e) + f univ - 2 * rankMinimum f v

def weight (f : Finset E → ℤ) (H : ℝ) (v : E → ℤ) : ℝ :=
  Real.exp (-H * (penalty f v : ℝ))

theorem weight_pos (f : Finset E → ℤ) (H : ℝ) (v : E → ℤ) :
    0 < weight f H v := Real.exp_pos _

theorem sum_step (v : E → ℤ) (e : E) (s : Bool) :
    (∑ a, step v e s a) = (∑ a, v a) + sign s := by
  simp [step, sum_add_distrib]

theorem penalty_defect (f : Finset E → ℤ) (hf : Submodular f)
    (v : E → ℤ) (g : I → E) (s : Bool) (i j : I) :
    penalty f v + penalty f (step (step v (g i) s) (g j) s) -
      penalty f (step v (g i) s) - penalty f (step v (g j) s) =
        2 * (if relation f v g s i j then 1 else 0) := by
  have := rank_defect f hf v g s i j
  simp only [penalty, sum_step]
  omega

/-- The auxiliary unboxed normalization. Invalid first-step rows are never
zeroed here; box truncation is performed only on the raw matrix. -/
def normalized (f : Finset E → ℤ) (H : ℝ) (v : E → ℤ)
    (g : I → E) (s : Bool) : Matrix I I ℝ :=
  fun i j => if relation f v g s i j then Real.exp (-2 * H) else 1

theorem weight_pair (f : Finset E → ℤ) (hf : Submodular f) (H : ℝ)
    (v : E → ℤ) (g : I → E) (s : Bool) (i j : I) :
    weight f H (step (step v (g i) s) (g j) s) =
      weight f H (step v (g i) s) * normalized f H v g s i j *
        weight f H (step v (g j) s) / weight f H v := by
  apply (eq_div_iff (ne_of_gt (weight_pos f H v))).mpr
  have hd : (penalty f v : ℝ) +
      (penalty f (step (step v (g i) s) (g j) s) : ℝ) -
      (penalty f (step v (g i) s) : ℝ) -
      (penalty f (step v (g j) s) : ℝ) =
        2 * (if relation f v g s i j then (1 : ℝ) else 0) := by
    exact_mod_cast penalty_defect f hf v g s i j
  by_cases hr : relation f v g s i j
  · simp only [normalized, if_pos hr, weight, ← Real.exp_add]
    congr 1
    simp only [if_pos hr] at hd
    linear_combination -H * hd
  · simp only [normalized, if_neg hr, weight, mul_one, ← Real.exp_add]
    congr 1
    simp only [if_neg hr] at hd
    linear_combination -H * hd

abbrev Form (X : Type*) [AddCommGroup X] [Module ℝ X] :=
  LinearMap.BilinForm ℝ X

def Signature {X : Type*} [AddCommGroup X] [Module ℝ X] (B : Form X) : Prop :=
  ∀ u v, 0 < B u u → B v u = 0 → B v v ≤ 0

theorem signature_of_kernel {X : Type*} [AddCommGroup X] [Module ℝ X]
    (B : Form X) (hB : ∀ x y, B x y = B y x)
    (L : X →ₗ[ℝ] ℝ) (hL : ∀ x, L x = 0 → B x x ≤ 0) : Signature B := by
  intro u v hu hv
  have hLu : L u ≠ 0 := by
    intro he
    have := hL u he
    linarith
  let c := L v / L u
  have hc : L (v - c • u) = 0 := by
    simp only [map_sub, map_smul, smul_eq_mul]
    dsimp [c]
    field_simp
    ring
  have hn := hL (v - c • u) hc
  have huv : B u v = 0 := by rw [hB, hv]
  simp only [map_sub, map_smul, LinearMap.sub_apply,
    LinearMap.smul_apply, smul_eq_mul, hv, huv] at hn
  nlinarith [sq_nonneg c]

def commonLinear (d : I → ℝ) : (I → ℝ) →ₗ[ℝ] ℝ :=
  ∑ i, d i • LinearMap.proj i

theorem commonLinear_apply (d x : I → ℝ) :
    commonLinear d x = ∑ i, d i * x i := by
  simp [commonLinear]

theorem matrix_symmetric (M : Matrix I I ℝ) (hM : ∀ i j, M i j = M j i)
    (x y : I → ℝ) : M.toBilin' x y = M.toBilin' y x := by
  simp only [Matrix.toBilin'_apply]
  rw [sum_comm]
  apply sum_congr rfl
  intro i _
  apply sum_congr rfl
  intro j _
  rw [hM j i]
  ring

theorem normalized_nonnegative (f : Finset E → ℤ) (H : ℝ) (v : E → ℤ)
    (g : I → E) (s : Bool) (i j : I) : 0 ≤ normalized f H v g s i j := by
  unfold normalized
  split_ifs
  · exact (Real.exp_pos _).le
  · norm_num

theorem normalized_symmetric (f : Finset E → ℤ) (H : ℝ) (v : E → ℤ)
    (g : I → E) (s : Bool) (i j : I) :
    normalized f H v g s i j = normalized f H v g s j i := by
  have he : relation f v g s i j ↔ relation f v g s j i :=
    ⟨countParallel_symm _ _, countParallel_symm _ _⟩
  simp only [normalized, he]

theorem normalized_kernel (f : Finset E → ℤ) (hf : Submodular f)
    (H : ℝ) (hH : 0 ≤ H) (v : E → ℤ) (g : I → E) (s : Bool)
    (x : I → ℝ) (hx : ∑ i, x i = 0) :
    (normalized f H v g s).toBilin' x x ≤ 0 := by
  let R := relation f v g s
  let K : Matrix I I ℝ := fun i j => if R i j then 1 else 0
  let J : Matrix I I ℝ := fun _ _ => 1
  let c : ℝ := 1 - Real.exp (-2 * H)
  have hc : 0 ≤ c := by
    have he : Real.exp (-2 * H) ≤ 1 := Real.exp_le_one_iff.mpr (by linarith)
    dsimp [c]
    linarith
  have hK : 0 ≤ K.toBilin' x x := by
    simpa only [Matrix.toBilin'_apply, K] using partial_relation_nonneg R
      (fun i j h => countParallel_symm _ _ h)
      (fun i j k h₁ h₂ =>
        countParallel_trans _ (orientedCost_submodular f hf v s) _ h₁ h₂) x
  have hJ : J.toBilin' x x = 0 := by
    simp only [Matrix.toBilin'_apply, J, mul_one, ← mul_sum, ← sum_mul, hx, mul_zero,
      sum_const_zero]
  have he : normalized f H v g s = J - c • K := by
    ext i j
    by_cases hr : R i j <;> simp [normalized, J, K, c, R] at hr ⊢ <;>
      simp [hr]
  rw [he, map_sub, map_smul]
  simp only [LinearMap.sub_apply, LinearMap.smul_apply, smul_eq_mul, hJ]
  exact sub_nonpos.mpr (mul_nonneg hc hK)

theorem normalized_J_sub_psd (f : Finset E → ℤ) (hf : Submodular f)
    (H : ℝ) (hH : 0 ≤ H) (v : E → ℤ) (g : I → E) (s : Bool)
    (x : I → ℝ) :
    0 ≤ (∑ i, ∑ j, x i * (1 - normalized f H v g s i j) * x j) := by
  let R := relation f v g s
  have hn := partial_relation_nonneg R
    (fun i j h => countParallel_symm _ _ h)
    (fun i j k h₁ h₂ =>
      countParallel_trans _ (orientedCost_submodular f hf v s) _ h₁ h₂) x
  have hc : 0 ≤ 1 - Real.exp (-2 * H) :=
    sub_nonneg.mpr (Real.exp_le_one_iff.mpr (by linarith))
  have he : ∀ i j, 1 - normalized f H v g s i j =
      (1 - Real.exp (-2 * H)) * (if R i j then (1 : ℝ) else 0) := by
    intro i j
    by_cases h : R i j <;> simp [normalized, R] at h ⊢ <;> simp [h]
  simp_rw [he]
  have hs : (∑ i, ∑ j, x i *
      ((1 - Real.exp (-2 * H)) * (if R i j then (1 : ℝ) else 0)) * x j) =
      (1 - Real.exp (-2 * H)) *
        (∑ i, ∑ j, x i * (if R i j then (1 : ℝ) else 0) * x j) := by
    simp only [mul_sum]
    apply sum_congr rfl
    intro i _
    apply sum_congr rfl
    intro j _
    ring
  rw [hs]
  exact mul_nonneg hc hn

theorem step_comm (v : E → ℤ) (e d : E) (s : Bool) :
    step (step v e s) d s = step (step v d s) e s := by
  simp only [step]
  abel

def rawTest (f : Finset E → ℤ) (H : ℝ) (v : E → ℤ) (g : I → E)
    (s : Bool) (active twice : I → Prop) : Matrix I I ℝ :=
  fun i j => if active i ∧ active j ∧ (i ≠ j ∨ twice i) then
    weight f H (step (step v (g i) s) (g j) s) else 0

def rawLinear (f : Finset E → ℤ) (H : ℝ) (v : E → ℤ) (g : I → E)
    (s : Bool) (active : I → Prop) : (I → ℝ) →ₗ[ℝ] ℝ :=
  commonLinear (fun i => if active i then weight f H (step v (g i) s) else 0)

theorem rawTest_symmetric (f : Finset E → ℤ) (H : ℝ) (v : E → ℤ) (g : I → E)
    (s : Bool) (active twice : I → Prop) (i j : I) :
    rawTest f H v g s active twice i j = rawTest f H v g s active twice j i := by
  by_cases hij : i = j
  · subst j
    rfl
  · simp only [rawTest, hij, Ne.symm hij, true_or, and_true]
    rw [step_comm]
    simp [hij, Ne.symm hij, and_comm]

theorem rawTest_kernel (f : Finset E → ℤ) (hf : Submodular f)
    (H : ℝ) (hH : 0 ≤ H) (v : E → ℤ) (g : I → E) (s : Bool)
    (active twice : I → Prop) (x : I → ℝ)
    (hx : rawLinear f H v g s active x = 0) :
    (rawTest f H v g s active twice).toBilin' x x ≤ 0 := by
  let y : I → ℝ := fun i =>
    (if active i then weight f H (step v (g i) s) else 0) * x i
  have hy : ∑ i, y i = 0 := by
    simpa only [rawLinear, commonLinear_apply, y] using hx
  have hn := normalized_kernel f hf H hH v g s y hy
  have hs : ∀ i j,
      x i * rawTest f H v g s active twice i j * x j ≤
        y i * normalized f H v g s i j * y j / weight f H v := by
    intro i j
    by_cases ha : active i
    · by_cases hb : active j
      · by_cases hv : i ≠ j ∨ twice i
        · simp only [rawTest, ha, hb, hv, and_self, if_true, y, if_pos]
          rw [weight_pair f hf]
          apply le_of_eq
          ring
        · have hij : i = j := by tauto
          subst j
          have htw : ¬ twice i := by tauto
          simp only [rawTest, ha, ne_eq, not_true_eq_false, htw, or_self,
            and_false, if_false, mul_zero, zero_mul, y, if_pos]
          apply div_nonneg
          · convert mul_nonneg (sq_nonneg (weight f H (step v (g i) s) * x i))
              (normalized_nonnegative f H v g s i i) using 1
            ring
          · exact (weight_pos f H v).le
      · simp [rawTest, hb, y]
    · simp [rawTest, ha, y]
  have hle : (rawTest f H v g s active twice).toBilin' x x ≤
      (normalized f H v g s).toBilin' y y / weight f H v := by
    simp only [Matrix.toBilin'_apply, sum_div]
    exact sum_le_sum (fun i _ => sum_le_sum (fun j _ => hs i j))
  exact hle.trans (div_nonpos_of_nonpos_of_nonneg hn (weight_pos f H v).le)

theorem grouped_rank_signature (f : Finset E → ℤ) (hf : Submodular f)
    (H : ℝ) (hH : 0 ≤ H) (v : E → ℤ) (g : I → E) (s : Bool)
    (active twice : I → Prop) :
    Signature (rawTest f H v g s active twice).toBilin' :=
  signature_of_kernel _ (matrix_symmetric _ (rawTest_symmetric f H v g s active twice))
    (rawLinear f H v g s active)
    (fun x hx => rawTest_kernel f hf H hH v g s active twice x hx)

theorem kernel_of_J_sub_psd (Q : Matrix I I ℝ)
    (hQ : ∀ x : I → ℝ, 0 ≤ ∑ i, ∑ j, x i * (1 - Q i j) * x j)
    (x : I → ℝ) (hx : ∑ i, x i = 0) : Q.toBilin' x x ≤ 0 := by
  let J : Matrix I I ℝ := fun _ _ => 1
  have hJ : J.toBilin' x x = 0 := by
    simp only [Matrix.toBilin'_apply, J, mul_one, ← mul_sum, ← sum_mul, hx,
      mul_zero, sum_const_zero]
  have hn : 0 ≤ (J - Q).toBilin' x x := by
    simpa only [Matrix.toBilin'_apply, Matrix.sub_apply, J] using hQ x
  rw [map_sub] at hn
  simp only [LinearMap.sub_apply, hJ] at hn
  linarith

def cutMatrix (W : Matrix I I ℝ) (active twice : I → Prop) : Matrix I I ℝ :=
  fun i j => if active i ∧ active j ∧ (i ≠ j ∨ twice i) then W i j else 0

theorem cutMatrix_symmetric (W : Matrix I I ℝ) (hW : ∀ i j, W i j = W j i)
    (active twice : I → Prop) (i j : I) :
    cutMatrix W active twice i j = cutMatrix W active twice j i := by
  by_cases hij : i = j
  · subst j
    rfl
  · simp [cutMatrix, hij, Ne.symm hij, hW i j, and_comm]

theorem cutMatrix_kernel (W₀ : ℝ) (hW₀ : 0 < W₀) (W₁ : I → ℝ)
    (W₂ Q : Matrix I I ℝ)
    (hpair : ∀ i j, W₂ i j = W₁ i * Q i j * W₁ j / W₀)
    (hdiag : ∀ i, 0 ≤ Q i i)
    (hQ : ∀ x : I → ℝ, 0 ≤ ∑ i, ∑ j, x i * (1 - Q i j) * x j)
    (active twice : I → Prop) (x : I → ℝ)
    (hx : commonLinear (fun i => if active i then W₁ i else 0) x = 0) :
    (cutMatrix W₂ active twice).toBilin' x x ≤ 0 := by
  let y : I → ℝ := fun i => (if active i then W₁ i else 0) * x i
  have hy : ∑ i, y i = 0 := by simpa only [commonLinear_apply, y] using hx
  have hn := kernel_of_J_sub_psd Q hQ y hy
  have hs : ∀ i j, x i * cutMatrix W₂ active twice i j * x j ≤
      y i * Q i j * y j / W₀ := by
    intro i j
    by_cases ha : active i
    · by_cases hb : active j
      · by_cases hv : i ≠ j ∨ twice i
        · simp only [cutMatrix, ha, hb, hv, and_self, if_true, y, if_pos]
          rw [hpair]
          apply le_of_eq
          ring
        · have hij : i = j := by tauto
          subst j
          have htw : ¬twice i := by tauto
          simp only [cutMatrix, ha, ne_eq, not_true_eq_false, htw, or_self,
            and_false, if_false, mul_zero, zero_mul, y, if_pos]
          apply div_nonneg
          · convert mul_nonneg (sq_nonneg (W₁ i * x i)) (hdiag i) using 1
            ring
          · exact hW₀.le
      · simp [cutMatrix, hb, y]
    · simp [cutMatrix, ha, y]
  have hle : (cutMatrix W₂ active twice).toBilin' x x ≤ Q.toBilin' y y / W₀ := by
    simp only [Matrix.toBilin'_apply, sum_div]
    exact sum_le_sum (fun i _ => sum_le_sum (fun j _ => hs i j))
  exact hle.trans (div_nonpos_of_nonpos_of_nonneg hn hW₀.le)

theorem cutMatrix_signature (W₀ : ℝ) (hW₀ : 0 < W₀) (W₁ : I → ℝ)
    (W₂ Q : Matrix I I ℝ) (hW₂ : ∀ i j, W₂ i j = W₂ j i)
    (hpair : ∀ i j, W₂ i j = W₁ i * Q i j * W₁ j / W₀)
    (hdiag : ∀ i, 0 ≤ Q i i)
    (hQ : ∀ x : I → ℝ, 0 ≤ ∑ i, ∑ j, x i * (1 - Q i j) * x j)
    (active twice : I → Prop) : Signature (cutMatrix W₂ active twice).toBilin' :=
  signature_of_kernel _ (matrix_symmetric _ (cutMatrix_symmetric _ hW₂ active twice))
    (commonLinear (fun i => if active i then W₁ i else 0))
    (fun x hx => cutMatrix_kernel W₀ hW₀ W₁ W₂ Q hpair hdiag hQ active twice x hx)

variable {K : Type*} [Fintype K] [DecidableEq K]

def blockNormalized (a : I → K) (Q : K → Matrix I I ℝ) : Matrix I I ℝ :=
  fun i j => if a i = a j then Q (a i) i j else 1

theorem blockNormalized_J_sub_psd (a : I → K) (Q : K → Matrix I I ℝ)
    (hQ : ∀ k (x : I → ℝ), 0 ≤ ∑ i, ∑ j, x i * (1 - Q k i j) * x j)
    (x : I → ℝ) :
    0 ≤ ∑ i, ∑ j, x i * (1 - blockNormalized a Q i j) * x j := by
  have he : ∀ i j, x i * (1 - blockNormalized a Q i j) * x j =
      ∑ k, (if a i = k then x i else 0) * (1 - Q k i j) *
        (if a j = k then x j else 0) := by
    intro i j
    rw [sum_eq_single (a i)]
    · by_cases hij : a i = a j <;> simp [blockNormalized, hij, eq_comm]
    · intro k _ hk
      simp [Ne.symm hk]
    · simp
  simp_rw [he]
  have hs : (∑ i, ∑ j, ∑ k,
      (if a i = k then x i else 0) * (1 - Q k i j) *
        (if a j = k then x j else 0)) =
      ∑ k, ∑ i, ∑ j,
        (if a i = k then x i else 0) * (1 - Q k i j) *
          (if a j = k then x j else 0) := by
    calc
      _ = ∑ i, ∑ k, ∑ j,
          (if a i = k then x i else 0) * (1 - Q k i j) *
            (if a j = k then x j else 0) := by
        apply sum_congr rfl
        intro i _
        exact sum_comm
      _ = _ := sum_comm
  rw [hs]
  exact sum_nonneg (fun k _ => hQ k _)

def productWeight (f : K → Finset E → ℤ) (H : K → ℝ) (V : K → E → ℤ) : ℝ :=
  ∏ k, weight (f k) (H k) (V k)

theorem productWeight_pos (f : K → Finset E → ℤ) (H : K → ℝ) (V : K → E → ℤ) :
    0 < productWeight f H V :=
  prod_pos (fun _k _ => weight_pos _ _ _)

def productStep (V : K → E → ℤ) (a : I → K) (g : I → E)
    (s : K → Bool) (i : I) : K → E → ℤ :=
  fun k => if a i = k then step (V k) (g i) (s k) else V k

theorem productStep_comm (V : K → E → ℤ) (a : I → K) (g : I → E)
    (s : K → Bool) (i j : I) :
    productStep (productStep V a g s i) a g s j =
      productStep (productStep V a g s j) a g s i := by
  funext k
  by_cases hi : a i = k <;> by_cases hj : a j = k <;>
    simp only [productStep, hi, hj, if_true, if_false]
  exact step_comm _ _ _ _

theorem productWeight_pair (f : K → Finset E → ℤ)
    (hf : ∀ k, Submodular (f k)) (H : K → ℝ) (V : K → E → ℤ)
    (a : I → K) (g : I → E) (s : K → Bool) (i j : I) :
    productWeight f H (productStep (productStep V a g s i) a g s j) =
      productWeight f H (productStep V a g s i) *
        blockNormalized a (fun k => normalized (f k) (H k) (V k) g (s k)) i j *
        productWeight f H (productStep V a g s j) / productWeight f H V := by
  let Q := fun k => normalized (f k) (H k) (V k) g (s k)
  have hp : ∀ k,
      weight (f k) (H k) (productStep (productStep V a g s i) a g s j k) *
        weight (f k) (H k) (V k) =
      weight (f k) (H k) (productStep V a g s i k) *
        (if a i = k ∧ a j = k then Q k i j else 1) *
        weight (f k) (H k) (productStep V a g s j k) := by
    intro k
    by_cases hi : a i = k <;> by_cases hj : a j = k
    · simp only [productStep, hi, hj, and_self, if_true]
      exact (eq_div_iff (ne_of_gt (weight_pos (f k) (H k) (V k)))).mp
        (weight_pair (f k) (hf k) (H k) (V k) g (s k) i j)
    all_goals simp [productStep, hi, hj] <;> ring
  have hq : (∏ k, if a i = k ∧ a j = k then Q k i j else 1) =
      blockNormalized a Q i j := by
    rw [prod_eq_single (a i)]
    · by_cases hij : a i = a j <;> simp [blockNormalized, hij, eq_comm]
    · intro k _ hk
      simp [Ne.symm hk]
    · simp
  apply (eq_div_iff (ne_of_gt (productWeight_pos f H V))).mpr
  calc
    _ = ∏ k,
        weight (f k) (H k) (productStep (productStep V a g s i) a g s j k) *
          weight (f k) (H k) (V k) := by
      simp only [productWeight, prod_mul_distrib]
    _ = ∏ k,
        weight (f k) (H k) (productStep V a g s i k) *
          (if a i = k ∧ a j = k then Q k i j else 1) *
          weight (f k) (H k) (productStep V a g s j k) :=
      prod_congr rfl (fun k _ => hp k)
    _ = _ := by
      simp only [prod_mul_distrib, hq, productWeight, Q]

def productRawTest (f : K → Finset E → ℤ) (H : K → ℝ) (V : K → E → ℤ)
    (a : I → K) (g : I → E) (s : K → Bool)
    (active twice : I → Prop) : Matrix I I ℝ :=
  cutMatrix (fun i j =>
    productWeight f H (productStep (productStep V a g s i) a g s j)) active twice

theorem disjoint_product_grouped_signature (f : K → Finset E → ℤ)
    (hf : ∀ k, Submodular (f k)) (H : K → ℝ) (hH : ∀ k, 0 ≤ H k)
    (V : K → E → ℤ) (a : I → K) (g : I → E) (s : K → Bool)
    (active twice : I → Prop) :
    Signature (productRawTest f H V a g s active twice).toBilin' := by
  apply cutMatrix_signature (productWeight f H V) (productWeight_pos f H V)
    (fun i => productWeight f H (productStep V a g s i)) _
    (blockNormalized a (fun k => normalized (f k) (H k) (V k) g (s k)))
  · intro i j
    rw [productStep_comm]
  · exact productWeight_pair f hf H V a g s
  · intro i
    simpa [blockNormalized] using
      normalized_nonnegative (f (a i)) (H (a i)) (V (a i)) g (s (a i)) i i
  · intro x
    exact blockNormalized_J_sub_psd a _
      (fun k y => normalized_J_sub_psd (f k) (hf k) (H k) (hH k) (V k) g (s k) y) x

def InBase (f : Finset E → ℤ) (v : E → ℤ) : Prop :=
  (∑ e, v e) = f univ ∧ ∀ A : Finset E, (∑ e ∈ A, v e) ≤ f A

theorem inside_add_outside (v : E → ℤ) (A : Finset E) :
    (∑ e ∈ A, v e) + outside v A = ∑ e, v e := by
  have hi : (∑ e ∈ A, v e) = ∑ e, if e ∈ A then v e else 0 := by
    symm
    rw [← sum_filter]
    simp
  rw [hi]
  simp only [outside, ← sum_add_distrib]
  apply sum_congr rfl
  intro e _
  split_ifs <;> simp

theorem penalty_nonnegative (f : Finset E → ℤ) (hf₀ : f ∅ = 0) (v : E → ℤ) :
    0 ≤ penalty f v := by
  have h₀ := minimum_le (fun A => f A + outside v A) ∅
  have hE := minimum_le (fun A => f A + outside v A) univ
  simp [outside, hf₀] at h₀
  simp [outside] at hE
  change rankMinimum f v ≤ _ at h₀ hE
  dsimp [penalty]
  omega

theorem penalty_zero_iff (f : Finset E → ℤ) (hf₀ : f ∅ = 0) (v : E → ℤ) :
    penalty f v = 0 ↔ InBase f v := by
  have h₀ : rankMinimum f v ≤ ∑ e, v e := by
    simpa [rankMinimum, outside, hf₀] using
      minimum_le (fun A => f A + outside v A) ∅
  have hE : rankMinimum f v ≤ f univ := by
    simpa [rankMinimum, outside] using
      minimum_le (fun A => f A + outside v A) univ
  constructor
  · intro hp
    have ht : (∑ e, v e) = f univ := by dsimp [penalty] at hp; omega
    have hm : rankMinimum f v = ∑ e, v e := by dsimp [penalty] at hp; omega
    refine ⟨ht, fun A => ?_⟩
    have hA := minimum_le (fun A => f A + outside v A) A
    change rankMinimum f v ≤ f A + outside v A at hA
    have := inside_add_outside v A
    omega
  · rintro ⟨ht, hA⟩
    have hm : (∑ e, v e) ≤ rankMinimum f v := by
      apply le_trans _ (le_refl (rankMinimum f v))
      change (∑ e, v e) ≤
        f (minimizer (fun A => f A + outside v A)) +
          outside v (minimizer (fun A => f A + outside v A))
      have h := hA (minimizer (fun A => f A + outside v A))
      have := inside_add_outside v (minimizer (fun A => f A + outside v A))
      omega
    dsimp [penalty]
    omega

theorem weight_limit (f : Finset E → ℤ) (hf₀ : f ∅ = 0) (v : E → ℤ) :
    Filter.Tendsto (fun H : ℝ => weight f H v) Filter.atTop
      (nhds (if InBase f v then (1 : ℝ) else 0)) := by
  by_cases hb : InBase f v
  · have hp := (penalty_zero_iff f hf₀ v).mpr hb
    simp [weight, hp, hb]
  · have hp : 0 < (penalty f v : ℝ) := by
      have hn := penalty_nonnegative f hf₀ v
      have hz : penalty f v ≠ 0 := fun h => hb ((penalty_zero_iff f hf₀ v).mp h)
      exact_mod_cast (show 0 < penalty f v by omega)
    have he := Real.tendsto_exp_neg_atTop_nhds_zero.comp
      (Filter.tendsto_id.const_mul_atTop hp)
    simpa [weight, hb, Function.comp_def, mul_comm, neg_mul] using he

def effectiveSign (orientation direction : Bool) : Bool :=
  if orientation then direction else !direction

def orientedCount (caps : I → ℤ) (orientation : Bool) (z : I → ℤ) (i : I) : ℤ :=
  if orientation then z i else caps i - z i

theorem orientedCount_step (caps : I → ℤ) (orientation direction : Bool)
    (z : I → ℤ) (i j : I) :
    orientedCount caps orientation (step z i direction) j =
      orientedCount caps orientation z j +
        if j = i then sign (effectiveSign orientation direction) else 0 := by
  cases orientation <;> cases direction <;> by_cases he : j = i <;>
    simp [orientedCount, step, Pi.single_apply, effectiveSign, sign, he] <;> ring

def groupedVector (b : K → E → ℤ) (caps : I → ℤ) (a : I → K) (g : I → E)
    (orientation : K → Bool) (z : I → ℤ) : K → E → ℤ :=
  fun k e => b k e + ∑ i,
    if a i = k ∧ g i = e then orientedCount caps (orientation k) z i else 0

theorem groupedVector_step (b : K → E → ℤ) (caps : I → ℤ)
    (a : I → K) (g : I → E) (orientation : K → Bool)
    (z : I → ℤ) (i : I) (direction : Bool) :
    groupedVector b caps a g orientation (step z i direction) =
      productStep (groupedVector b caps a g orientation z) a g
        (fun k => effectiveSign (orientation k) direction) i := by
  funext k e
  have he : ∀ j,
      (if a j = k ∧ g j = e then
        orientedCount caps (orientation k) (step z i direction) j else 0) =
      (if a j = k ∧ g j = e then orientedCount caps (orientation k) z j else 0) +
        (if j = i then
          (if a i = k ∧ g i = e then
            sign (effectiveSign (orientation k) direction) else 0) else 0) := by
    intro j
    rw [orientedCount_step]
    by_cases hji : j = i
    · subst j
      by_cases hc : a i = k ∧ g i = e <;> simp [hc]
    · simp [hji]
  change b k e + ∑ j, _ = _
  simp_rw [he]
  rw [sum_add_distrib]
  simp only [sum_ite_eq', mem_univ, if_true]
  by_cases ha : a i = k
  · simp [productStep, ha, step, Pi.single_apply, groupedVector, eq_comm]
    ring
  · simp [productStep, ha, groupedVector]

def groupedWeight (f : K → Finset E → ℤ) (H : K → ℝ)
    (b : K → E → ℤ) (caps : I → ℤ) (a : I → K) (g : I → E)
    (orientation : K → Bool) (z : I → ℤ) : ℝ :=
  productWeight f H (groupedVector b caps a g orientation z)

def InBox (caps z : I → ℤ) : Prop :=
  ∀ i, 0 ≤ z i ∧ z i ≤ caps i

def boxedWeight (G : (I → ℤ) → ℝ) (caps : I → ℤ) (z : I → ℤ) : ℝ :=
  if InBox caps z then G z else 0

def quadraticMatrix (G : (I → ℤ) → ℝ) (z : I → ℤ) (direction : Bool) :
    Matrix I I ℝ :=
  fun i j => G (step (step z i direction) j direction)

theorem quadraticMatrix_symmetric (G : (I → ℤ) → ℝ) (z : I → ℤ)
    (direction : Bool) (i j : I) :
    quadraticMatrix G z direction i j = quadraticMatrix G z direction j i := by
  unfold quadraticMatrix
  rw [step_comm]

theorem box_first_of_pair (caps z : I → ℤ) (hz : InBox caps z)
    (i j : I) (direction : Bool)
    (hpair : InBox caps (step (step z i direction) j direction)) :
    InBox caps (step z i direction) := by
  intro p
  have hz' := hz p
  have hp := hpair p
  cases direction <;> by_cases hi : p = i <;> by_cases hj : p = j <;>
    subst_vars <;> simp_all [step, Pi.single_apply, sign] <;> omega

theorem box_pair_iff (caps z : I → ℤ) (hz : InBox caps z)
    (i j : I) (direction : Bool) :
    InBox caps (step (step z i direction) j direction) ↔
      InBox caps (step z i direction) ∧ InBox caps (step z j direction) ∧
        (i ≠ j ∨ InBox caps (step (step z i direction) i direction)) := by
  constructor
  · intro hp
    refine ⟨box_first_of_pair caps z hz i j direction hp, ?_, ?_⟩
    · apply box_first_of_pair caps z hz j i direction
      simpa only [step_comm] using hp
    · by_cases hij : i = j
      · subst j
        exact Or.inr hp
      · exact Or.inl hij
  · rintro ⟨hi, hj, hlast⟩
    by_cases hij : i = j
    · subst j
      exact hlast.resolve_left (by simp)
    · intro p
      have hz' := hz p
      have hi' := hi p
      have hj' := hj p
      cases direction <;> by_cases hpi : p = i <;> by_cases hpj : p = j <;>
        subst_vars <;> simp_all [step, Pi.single_apply, sign]

theorem boxed_quadratic_eq_cut (G : (I → ℤ) → ℝ) (caps z : I → ℤ)
    (hz : InBox caps z) (direction : Bool) :
    quadraticMatrix (boxedWeight G caps) z direction =
      cutMatrix (quadraticMatrix G z direction)
        (fun i => InBox caps (step z i direction))
        (fun i => InBox caps (step (step z i direction) i direction)) := by
  ext i j
  simp only [quadraticMatrix, boxedWeight, cutMatrix]
  have hb := box_pair_iff caps z hz i j direction
  by_cases hp : InBox caps (step (step z i direction) j direction)
  · rw [if_pos hp, if_pos (hb.mp hp)]
  · rw [if_neg hp, if_neg (mt hb.mpr hp)]

theorem boxed_signature_outside (G : (I → ℤ) → ℝ) (caps z : I → ℤ)
    (hz : ¬InBox caps z) (direction : Bool) :
    Signature (quadraticMatrix (boxedWeight G caps) z direction).toBilin' := by
  obtain ⟨p, hp⟩ := not_forall.mp hz
  apply signature_of_kernel _
    (matrix_symmetric _ (quadraticMatrix_symmetric _ _ _)) (LinearMap.proj p)
  intro x hx
  have hterm : ∀ i j,
      x i * quadraticMatrix (boxedWeight G caps) z direction i j * x j = 0 := by
    intro i j
    by_cases hi : i = p
    · subst i
      simp only [LinearMap.proj_apply] at hx
      simp [hx]
    · by_cases hj : j = p
      · subst j
        simp only [LinearMap.proj_apply] at hx
        simp [hx]
      · have hb : ¬InBox caps (step (step z i direction) j direction) := by
          intro hb
          have h := hb p
          simp only [step, Pi.add_apply, Pi.single_apply, Ne.symm hi, Ne.symm hj,
            if_false, add_zero] at h
          exact hp h
        simp [quadraticMatrix, boxedWeight, hb]
  have he : (quadraticMatrix (boxedWeight G caps) z direction).toBilin' x x = 0 := by
    simp only [Matrix.toBilin'_apply, hterm, sum_const_zero]
  exact he.le

theorem boxed_disjoint_grouped_signature (f : K → Finset E → ℤ)
    (hf : ∀ k, Submodular (f k)) (H : K → ℝ) (hH : ∀ k, 0 ≤ H k)
    (b : K → E → ℤ) (caps : I → ℤ) (a : I → K) (g : I → E)
    (orientation : K → Bool) (z : I → ℤ) (direction : Bool) :
    Signature (quadraticMatrix
      (boxedWeight (groupedWeight f H b caps a g orientation) caps) z direction).toBilin' := by
  by_cases hz : InBox caps z
  · rw [boxed_quadratic_eq_cut _ caps z hz]
    have he : cutMatrix (quadraticMatrix (groupedWeight f H b caps a g orientation) z direction)
        (fun i => InBox caps (step z i direction))
        (fun i => InBox caps (step (step z i direction) i direction)) =
        productRawTest f H (groupedVector b caps a g orientation z) a g
          (fun k => effectiveSign (orientation k) direction)
          (fun i => InBox caps (step z i direction))
          (fun i => InBox caps (step (step z i direction) i direction)) := by
      ext i j
      simp only [cutMatrix, quadraticMatrix, groupedWeight, productRawTest,
        groupedVector_step]
    rw [he]
    exact disjoint_product_grouped_signature f hf H hH _ a g _ _ _
  · exact boxed_signature_outside _ caps z hz direction

theorem productWeight_rpow (f : K → Finset E → ℤ) (H : K → ℝ)
      (V : K → E → ℤ) (t : ℝ) :
      productWeight f H V ^ t = productWeight f (fun k => t * H k) V := by
    unfold productWeight weight
    rw [← Real.exp_sum, ← Real.exp_sum, ← Real.exp_mul]
    congr 1
    rw [sum_mul]
    apply sum_congr rfl
    intro k _
    ring

theorem boxed_disjoint_grouped_power_signature (f : K → Finset E → ℤ)
      (hf : ∀ k, Submodular (f k)) (H : K → ℝ) (hH : ∀ k, 0 ≤ H k)
      (b : K → E → ℤ) (caps : I → ℤ) (a : I → K) (g : I → E)
      (orientation : K → Bool) (z : I → ℤ) (direction : Bool)
      (t : ℝ) (ht : 0 ≤ t) :
      Signature (quadraticMatrix
        (boxedWeight (fun z => groupedWeight f H b caps a g orientation z ^ t) caps)
        z direction).toBilin' := by
    have he : (fun z => groupedWeight f H b caps a g orientation z ^ t) =
        groupedWeight f (fun k => t * H k) b caps a g orientation := by
      funext z
      exact productWeight_rpow f H _ t
    rw [he]
    exact boxed_disjoint_grouped_signature f hf _ (fun k => mul_nonneg ht (hH k))
      b caps a g orientation z direction

theorem productWeight_limit (f : K → Finset E → ℤ) (hf₀ : ∀ k, f k ∅ = 0)
      (V : K → E → ℤ) :
      Filter.Tendsto (fun H : ℝ => productWeight f (fun _ => H) V) Filter.atTop
        (nhds (if ∀ k, InBase (f k) (V k) then (1 : ℝ) else 0)) := by
    have ht := tendsto_finsetProd (univ : Finset K)
      (fun k _ => weight_limit (f k) (hf₀ k) (V k))
    have he : (∏ k, if InBase (f k) (V k) then (1 : ℝ) else 0) =
        if ∀ k, InBase (f k) (V k) then 1 else 0 := by
      by_cases hb : ∀ k, InBase (f k) (V k)
      · simp [hb]
      · obtain ⟨k, hk⟩ := not_forall.mp hb
        rw [if_neg hb]
        apply prod_eq_zero (mem_univ k)
        simp [hk]
    simpa only [productWeight, he] using ht

theorem boxed_groupedWeight_limit (f : K → Finset E → ℤ)
      (hf₀ : ∀ k, f k ∅ = 0) (b : K → E → ℤ) (caps : I → ℤ)
      (a : I → K) (g : I → E) (orientation : K → Bool) (z : I → ℤ) :
      Filter.Tendsto
        (fun H : ℝ => boxedWeight
          (groupedWeight f (fun _ => H) b caps a g orientation) caps z) Filter.atTop
        (nhds (if InBox caps z ∧
          ∀ k, InBase (f k) (groupedVector b caps a g orientation z k)
          then (1 : ℝ) else 0)) := by
    by_cases hz : InBox caps z
    · simpa [boxedWeight, groupedWeight, hz] using
        productWeight_limit f hf₀ (groupedVector b caps a g orientation z)
    · simp [boxedWeight, hz]

def modularShift (f : Finset E → ℤ) (c : E → ℤ) (A : Finset E) : ℤ :=
    f A + ∑ e ∈ A, c e

theorem modularShift_submodular (f : Finset E → ℤ) (hf : Submodular f)
      (c : E → ℤ) : Submodular (modularShift f c) := by
    intro A B
    have h₁ := inside_add_outside c A
    have h₂ := inside_add_outside c B
    have h₃ := inside_add_outside c (A ∪ B)
    have h₄ := inside_add_outside c (A ∩ B)
    have h₅ := outside_modular c A B
    have h₆ := hf A B
    dsimp [modularShift]
    omega

theorem exists_monotone_modular_shift (f : Finset E → ℤ) (b : E → ℤ) :
      ∃ c : E → ℤ, (∀ e, 0 ≤ b e + c e) ∧
        ∀ A B : Finset E, A ⊆ B → modularShift f c A ≤ modularShift f c B := by
    let c : E → ℤ := fun e =>
      max (-b e) (-minimum (fun A : Finset E => f (insert e A) - f A))
    have hc : ∀ e A, f A - f (insert e A) ≤ c e := by
      intro e A
      have hm := minimum_le (fun A : Finset E => f (insert e A) - f A) A
      have hm' := le_max_right (-b e)
        (-minimum (fun A : Finset E => f (insert e A) - f A))
      dsimp [c]
      omega
    have hins : ∀ A e, modularShift f c A ≤ modularShift f c (insert e A) := by
      intro A e
      by_cases he : e ∈ A
      · simp [insert_eq_of_mem he]
      · simp only [modularShift, sum_insert he]
        have := hc e A
        omega
    refine ⟨c, ?_, ?_⟩
    · intro e
      have := le_max_left (-b e) (-minimum (fun A : Finset E => f (insert e A) - f A))
      change 0 ≤ b e + max (-b e) (-minimum (fun A : Finset E => f (insert e A) - f A))
      omega
    · intro A B hAB
      have hall : ∀ D, modularShift f c A ≤ modularShift f c (A ∪ D) := by
        intro D
        induction D using Finset.induction_on with
        | empty => simp
        | insert e D he ih =>
          simpa only [union_insert] using ih.trans (hins (A ∪ D) e)
      simpa only [union_eq_right.mpr hAB] using hall B

theorem modularShift_base (f : Finset E → ℤ) (v c : E → ℤ) :
      InBase (modularShift f c) (v + c) ↔ InBase f v := by
    simp only [InBase, modularShift, Pi.add_apply, sum_add_distrib]
    constructor
    · rintro ⟨ht, hA⟩
      refine ⟨by omega, fun A => ?_⟩
      have := hA A
      omega
    · rintro ⟨ht, hA⟩
      refine ⟨by omega, fun A => ?_⟩
      have := hA A
      omega

theorem rankMinimum_modularShift (f : Finset E → ℤ) (v c : E → ℤ) :
      rankMinimum (modularShift f c) (v + c) = rankMinimum f v + ∑ e, c e := by
    have he : (fun A => modularShift f c A + outside (v + c) A) =
        (fun A => (f A + outside v A) + ∑ e, c e) := by
      funext A
      rw [outside_add]
      have := inside_add_outside c A
      dsimp [modularShift]
      omega
    unfold rankMinimum
    rw [he, minimum_add_const]

theorem penalty_modularShift (f : Finset E → ℤ) (v c : E → ℤ) :
      penalty (modularShift f c) (v + c) = penalty f v := by
    simp only [penalty, rankMinimum_modularShift, modularShift, Pi.add_apply,
      sum_add_distrib]
    ring

def totalSlice (G : (I → ℤ) → ℝ) (n : ℤ) (z : I → ℤ) : ℝ :=
    if ∑ i, z i = n then G z else 0

theorem signature_totalSlice (G : (I → ℤ) → ℝ)
      (hG : ∀ z direction, Signature (quadraticMatrix G z direction).toBilin')
      (n : ℤ) (z : I → ℤ) (direction : Bool) :
      Signature (quadraticMatrix (totalSlice G n) z direction).toBilin' := by
    by_cases ht : (∑ i, z i) + sign direction + sign direction = n
    · have he : quadraticMatrix (totalSlice G n) z direction =
          quadraticMatrix G z direction := by
        ext i j
        simp only [quadraticMatrix, totalSlice, sum_step, if_pos ht]
      rw [he]
      exact hG z direction
    · have he : quadraticMatrix (totalSlice G n) z direction = 0 := by
        ext i j
        simp only [quadraticMatrix, totalSlice, sum_step, if_neg ht, Matrix.zero_apply]
      rw [he]
      intro u v _ _
      simp only [map_zero, LinearMap.zero_apply, le_refl]

theorem boxed_disjoint_grouped_slice_signature (f : K → Finset E → ℤ)
      (hf : ∀ k, Submodular (f k)) (H : K → ℝ) (hH : ∀ k, 0 ≤ H k)
      (b : K → E → ℤ) (caps : I → ℤ) (a : I → K) (g : I → E)
      (orientation : K → Bool) (n : ℤ) (z : I → ℤ) (direction : Bool) :
      Signature (quadraticMatrix
        (totalSlice (boxedWeight (groupedWeight f H b caps a g orientation) caps) n)
        z direction).toBilin' :=
    signature_totalSlice _ (fun z direction =>
      boxed_disjoint_grouped_signature f hf H hH b caps a g orientation z direction)
      n z direction

end RankSignatures
