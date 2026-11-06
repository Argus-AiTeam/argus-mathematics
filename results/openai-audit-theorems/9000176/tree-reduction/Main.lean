import Mathlib

set_option autoImplicit false
set_option maxRecDepth 2048
set_option maxHeartbeats 1600000

noncomputable section
open scoped BigOperators
attribute [local instance] Classical.propDecidable

namespace TreeReduction

abbrev Mask (n : ℕ) := Fin n → Bool

def cons {n : ℕ} (b : Bool) (w : Mask n) : Mask (n + 1) := Fin.cases b w
def tail {n : ℕ} (w : Mask (n + 1)) : Mask n := fun i => w i.succ

@[simp] theorem cons_zero {n : ℕ} (b : Bool) (w : Mask n) :
    cons b w 0 = b := rfl

@[simp] theorem cons_succ {n : ℕ} (b : Bool) (w : Mask n) (i : Fin n) :
    cons b w i.succ = w i := rfl

@[simp] theorem tail_cons {n : ℕ} (b : Bool) (w : Mask n) :
    tail (cons b w) = w := rfl

theorem cons_tail {n : ℕ} (w : Mask (n + 1)) : cons (w 0) (tail w) = w := by
  funext i
  refine Fin.cases ?_ (fun j => ?_) i <;> rfl

def card : {n : ℕ} → Mask n → ℕ
  | 0, _ => 0
  | _ + 1, w => (if w 0 then 1 else 0) + card (tail w)

def Sub {n : ℕ} (a b : Mask n) : Prop := ∀ i, a i = true → b i = true
def Disj {n : ℕ} (a b : Mask n) : Prop := ∀ i, a i = true → b i = false
def union {n : ℕ} (a b : Mask n) : Mask n := fun i => a i || b i
def inter {n : ℕ} (a b : Mask n) : Mask n := fun i => a i && b i
def diff {n : ℕ} (a b : Mask n) : Mask n := fun i => a i && !b i

@[simp] theorem sub_cons {n : ℕ} (a b : Bool) (u v : Mask n) :
    Sub (cons a u) (cons b v) ↔ (a = true → b = true) ∧ Sub u v := by
  simp [Sub, Fin.forall_fin_succ]

@[simp] theorem card_cons {n : ℕ} (a : Bool) (u : Mask n) :
    card (cons a u) = (if a then 1 else 0) + card u := rfl

@[simp] theorem union_cons {n : ℕ} (a b : Bool) (u v : Mask n) :
    union (cons a u) (cons b v) = cons (a || b) (union u v) := by
  funext i
  refine Fin.cases ?_ (fun j => ?_) i <;> rfl

@[simp] theorem inter_cons {n : ℕ} (a b : Bool) (u v : Mask n) :
    inter (cons a u) (cons b v) = cons (a && b) (inter u v) := by
  funext i
  refine Fin.cases ?_ (fun j => ?_) i <;> rfl

@[simp] theorem diff_cons {n : ℕ} (a b : Bool) (u v : Mask n) :
    diff (cons a u) (cons b v) = cons (a && !b) (diff u v) := by
  funext i
  refine Fin.cases ?_ (fun j => ?_) i <;> rfl

theorem sub_refl {n : ℕ} (a : Mask n) : Sub a a := fun _ h => h

theorem sub_trans {n : ℕ} {a b c : Mask n} (hab : Sub a b) (hbc : Sub b c) :
    Sub a c := fun i hi => hbc i (hab i hi)

theorem sub_inter {n : ℕ} (j a b : Mask n) :
    Sub j (inter a b) ↔ Sub j a ∧ Sub j b := by
  simp [Sub, inter, Bool.and_eq_true, forall_and]

theorem sub_diff_union {n : ℕ} (a b w : Mask n) :
    Sub a (union w b) ↔ Sub (diff a b) w := by
  constructor
  · intro h i hi
    have hh : a i = true ∧ b i = false := by simpa [diff] using hi
    obtain ⟨ha, hb⟩ := hh
    simpa [union, hb] using h i ha
  · intro h i hi
    cases hb : b i
    · have hw := h i (by simp [diff, hi, hb])
      simp [union, hw]
    · simp [union, hb]

theorem diff_sub_inter {n : ℕ} {a b w : Mask n} (h : Sub a (union w b)) :
    Sub (diff a w) (inter a b) := by
  intro i hi
  have hh : a i = true ∧ w i = false := by simpa [diff] using hi
  obtain ⟨ha, hw⟩ := hh
  have hb : b i = true := by simpa [union, hw] using h i ha
  simp [inter, ha, hb]

theorem card_mono {n : ℕ} {a b : Mask n} (h : Sub a b) : card a ≤ card b := by
  induction n with
  | zero => simp [card]
  | succ n ih =>
    have ht : Sub (tail a) (tail b) := fun i hi => h i.succ hi
    have hc := ih ht
    have hh : (if a 0 then 1 else 0 : ℕ) ≤ (if b 0 then 1 else 0) := by
      have hh := h 0
      cases ha : a 0 <;> cases hb : b 0 <;> simp_all
    exact Nat.add_le_add hh hc

theorem card_partition {n : ℕ} (a b : Mask n) :
    card a = card (diff a b) + card (inter a b) := by
  induction n with
  | zero => simp [card]
  | succ n ih =>
    have ht := ih (tail a) (tail b)
    rw [← cons_tail a, ← cons_tail b]
    cases a 0 <;> cases b 0 <;> simp_all [card] <;> omega

def avg (ρ : ℝ) : {n : ℕ} → (Mask n → ℝ) → ℝ
  | 0, f => f (fun i => Fin.elim0 i)
  | _ + 1, f =>
      (1 - ρ) * avg ρ (fun w => f (cons false w)) +
      ρ * avg ρ (fun w => f (cons true w))

def sumMasks : {n : ℕ} → (Mask n → ℝ) → ℝ
  | 0, f => f (fun i => Fin.elim0 i)
  | _ + 1, f =>
      sumMasks (fun w => f (cons false w)) +
      sumMasks (fun w => f (cons true w))

theorem avg_congr {n : ℕ} (ρ : ℝ) {f g : Mask n → ℝ} (h : ∀ w, f w = g w) :
    avg ρ f = avg ρ g := congrArg (avg ρ) (funext h)

@[simp] theorem avg_const {n : ℕ} (ρ c : ℝ) :
    avg ρ (fun _ : Mask n => c) = c := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [avg, ih]; ring

theorem avg_add {n : ℕ} (ρ : ℝ) (f g : Mask n → ℝ) :
    avg ρ (fun w => f w + g w) = avg ρ f + avg ρ g := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [avg, ih]; ring

theorem avg_mul {n : ℕ} (ρ c : ℝ) (f : Mask n → ℝ) :
    avg ρ (fun w => c * f w) = c * avg ρ f := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [avg, ih]; ring

theorem avg_sum {n : ℕ} {B : Type} (ρ : ℝ) (s : Finset B)
    (f : B → Mask n → ℝ) :
    avg ρ (fun w => ∑ b ∈ s, f b w) = ∑ b ∈ s, avg ρ (f b) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert b s hb ih => simp [Finset.sum_insert, hb, avg_add, ih]

theorem avg_nonneg {n : ℕ} {ρ : ℝ} (hρ : 0 ≤ ρ) (hρ' : ρ ≤ 1)
    {f : Mask n → ℝ} (hf : ∀ w, 0 ≤ f w) : 0 ≤ avg ρ f := by
  induction n with
  | zero => exact hf _
  | succ n ih =>
    exact add_nonneg
      (mul_nonneg (sub_nonneg.mpr hρ') (ih (fun w => hf (cons false w))))
      (mul_nonneg hρ (ih (fun w => hf (cons true w))))

theorem avg_mono {n : ℕ} {ρ : ℝ} (hρ : 0 ≤ ρ) (hρ' : ρ ≤ 1)
    {f g : Mask n → ℝ} (h : ∀ w, f w ≤ g w) : avg ρ f ≤ avg ρ g := by
  induction n with
  | zero => exact h _
  | succ n ih =>
    exact add_le_add
      (mul_le_mul_of_nonneg_left (ih (fun w => h (cons false w)))
        (sub_nonneg.mpr hρ'))
      (mul_le_mul_of_nonneg_left (ih (fun w => h (cons true w))) hρ)

theorem sumMasks_congr {n : ℕ} {f g : Mask n → ℝ} (h : ∀ w, f w = g w) :
    sumMasks f = sumMasks g := congrArg sumMasks (funext h)

theorem sumMasks_add {n : ℕ} (f g : Mask n → ℝ) :
    sumMasks (fun w => f w + g w) = sumMasks f + sumMasks g := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [sumMasks, ih]; ring

theorem sumMasks_mul {n : ℕ} (c : ℝ) (f : Mask n → ℝ) :
    sumMasks (fun w => c * f w) = c * sumMasks f := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [sumMasks, ih]; ring

@[simp] theorem sumMasks_zero {n : ℕ} : sumMasks (fun _ : Mask n => (0 : ℝ)) = 0 := by
  induction n with
  | zero => rfl
  | succ n ih => simp [sumMasks, ih]

theorem sumMasks_sum {n : ℕ} {B : Type} (s : Finset B) (f : B → Mask n → ℝ) :
    sumMasks (fun w => ∑ b ∈ s, f b w) = ∑ b ∈ s, sumMasks (f b) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert b s hb ih => simp [Finset.sum_insert, hb, sumMasks_add, ih]

theorem sumMasks_mono {n : ℕ} {f g : Mask n → ℝ} (h : ∀ w, f w ≤ g w) :
    sumMasks f ≤ sumMasks g := by
  induction n with
  | zero => exact h _
  | succ n ih =>
    exact add_le_add (ih (fun w => h (cons false w)))
      (ih (fun w => h (cons true w)))

theorem sum_subsets {n : ℕ} (a : Mask n) (x : ℝ) :
    sumMasks (fun j => if Sub j a then x ^ card j else 0) = (1 + x) ^ card a := by
  classical
  induction n with
  | zero => simp [sumMasks, Sub, card]
  | succ n ih =>
    rw [← cons_tail a]
    cases ha : a 0
    · simp [sumMasks, sub_cons, ih]
    · simp only [sumMasks, sub_cons, Bool.false_eq_true, false_implies,
        true_and, true_implies, card_cons, ite_true, ite_false, zero_add]
      have hfactor :
          (fun j : Mask n => if Sub j (tail a) then x ^ (1 + card j) else 0) =
          (fun j : Mask n => x * (if Sub j (tail a) then x ^ card j else 0)) := by
        funext j
        split_ifs <;> simp [pow_add]
      rw [hfactor, sumMasks_mul, ih]
      rw [pow_add]
      ring

structure Law (B : Type) [Fintype B] where
  weight : B → ℝ
  positive : ∀ b, 0 < weight b
  total : ∑ b, weight b = 1

instance {B : Type} [Fintype B] : CoeFun (Law B) (fun _ => B → ℝ) :=
  ⟨Law.weight⟩

def Spread {n : ℕ} {B : Type} [Fintype B] (p : Law B)
    (labels : B → Mask n) (a : ℝ) : Prop :=
  ∀ j, (∑ b, if Sub j (labels b) then p b else 0) ≤ a ^ card j

theorem intersection_expansion {n : ℕ} (a c : Mask n) (q : ℝ) :
    q ^ card (inter a c) =
      sumMasks (fun j => if Sub j a ∧ Sub j c then (q - 1) ^ card j else 0) := by
  simpa only [sub_inter, show 1 + (q - 1) = q by ring] using
    (sum_subsets (inter a c) (q - 1)).symm

theorem moment_bound {n : ℕ} {B : Type} [Fintype B] (p : Law B)
    (labels : B → Mask n) {a q K : ℝ} {m : ℕ}
    (ha : 0 ≤ a) (hq : 1 ≤ q) (hK : 1 ≤ K)
    (hs : Spread p labels a) (hbase : 1 + a * (q - 1) ≤ K)
    (target : Mask n) (hm : card target ≤ m) :
    (∑ b, p b * q ^ card (inter target (labels b))) ≤ K ^ m := by
  classical
  calc
    (∑ b, p b * q ^ card (inter target (labels b))) =
        ∑ b, p b * sumMasks (fun j =>
          if Sub j target ∧ Sub j (labels b) then (q - 1) ^ card j else 0) := by
            simp_rw [intersection_expansion]
    _ = sumMasks (fun j =>
        if Sub j target then
          (q - 1) ^ card j * (∑ b, if Sub j (labels b) then p b else 0)
        else 0) := by
          simp_rw [← sumMasks_mul]
          rw [← sumMasks_sum]
          apply sumMasks_congr
          intro j
          by_cases hj : Sub j target
          · simp only [hj, true_and, ite_true, Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro b _
            split_ifs <;> ring
          · simp [hj]
    _ ≤ sumMasks (fun j =>
        if Sub j target then ((q - 1) * a) ^ card j else 0) := by
          apply sumMasks_mono
          intro j
          split_ifs
          · rw [mul_pow]
            exact mul_le_mul_of_nonneg_left (hs j) (pow_nonneg (sub_nonneg.mpr hq) _)
          · rfl
    _ = (1 + (q - 1) * a) ^ card target := sum_subsets _ _
    _ ≤ K ^ card target := by
      apply pow_le_pow_left₀
      · positivity
      · nlinarith
    _ ≤ K ^ m := pow_le_pow_right₀ hK hm

def Avoids {n : ℕ} (a : Mask n) (f : Mask n → ℝ) : Prop :=
  ∀ w w', (∀ i, a i = false → w i = w' i) → f w = f w'

theorem avoids_tail {n : ℕ} {a : Mask (n + 1)} {f : Mask (n + 1) → ℝ}
    (hf : Avoids a f) (b : Bool) :
    Avoids (tail a) (fun w => f (cons b w)) := by
  intro w w' h
  apply hf
  intro i
  refine Fin.cases ?_ (fun j => ?_) i
  · intro _
    rfl
  · intro hi
    exact h j hi

theorem avoids_head {n : ℕ} {a : Mask (n + 1)} {f : Mask (n + 1) → ℝ}
    (hf : Avoids a f) (ha : a 0 = true) (w : Mask n) :
    f (cons false w) = f (cons true w) := by
  apply hf
  intro i
  refine Fin.cases ?_ (fun j => ?_) i
  · intro hi
    simp [ha] at hi
  · intro _
    rfl

theorem avoids_mono {n : ℕ} {a b : Mask n} {f : Mask n → ℝ}
    (hf : Avoids a f) (hab : Sub b a) : Avoids b f := by
  intro w w' h
  apply hf
  intro i hi
  have hb : b i = false := by
    cases hbi : b i
    · rfl
    · have := hab i hbi
      simp [hi] at this
  exact h i hb

theorem diff_sub {n : ℕ} (a b : Mask n) : Sub (diff a b) a := by
  intro i hi
  have h : a i = true ∧ b i = false := by simpa [diff] using hi
  exact h.1

theorem avg_subset_factor {n : ℕ} (ρ : ℝ) (a : Mask n)
    (f : Mask n → ℝ) (hf : Avoids a f) :
    avg ρ (fun w => if Sub a w then f w else 0) = ρ ^ card a * avg ρ f := by
  classical
  induction n with
  | zero => simp [avg, Sub, card]
  | succ n ih =>
    have hf0 := avoids_tail hf false
    have hf1 := avoids_tail hf true
    have hi0 := ih (tail a) (fun w => f (cons false w)) hf0
    have hi1 := ih (tail a) (fun w => f (cons true w)) hf1
    cases ha : a 0
    · have hsub0 : ∀ w : Mask n, Sub a (cons false w) ↔ Sub (tail a) w := by
        intro w
        rw [← cons_tail a]
        simp [ha]
      have hsub1 : ∀ w : Mask n, Sub a (cons true w) ↔ Sub (tail a) w := by
        intro w
        rw [← cons_tail a]
        simp [ha]
      simp only [avg, hsub0, hsub1, card, ha, Bool.false_eq_true, ite_false, zero_add]
      rw [hi0, hi1]
      ring
    · have hsub0 : ∀ w : Mask n, ¬Sub a (cons false w) := by
        intro w h
        simpa [ha] using h 0 ha
      have hsub1 : ∀ w : Mask n, Sub a (cons true w) ↔ Sub (tail a) w := by
        intro w
        rw [← cons_tail a]
        simp [ha]
      have hcross : avg ρ (fun w => f (cons false w)) =
          avg ρ (fun w => f (cons true w)) :=
        avg_congr ρ (avoids_head hf ha)
      simp only [avg, hsub0, hsub1, ite_false, avg_const, mul_zero, zero_add,
        card, ha, ite_true]
      rw [hi1, hcross, pow_add]
      simp only [pow_one]
      ring

theorem avg_plant {n : ℕ} {ρ : ℝ} (hρ : ρ ≠ 0) (a : Mask n)
    (f : Mask n → ℝ) :
    avg ρ (fun w => f (union w a)) =
      avg ρ (fun y => if Sub a y then (ρ⁻¹) ^ card a * f y else 0) := by
  classical
  induction n with
  | zero =>
    simp only [avg, card, pow_zero, one_mul]
    simp [Sub]
    congr 1
    funext i
    exact Fin.elim0 i
  | succ n ih =>
    have hi0 := ih (tail a) (fun w => f (cons false w))
    have hi1 := ih (tail a) (fun w => f (cons true w))
    rw [← cons_tail a]
    cases ha : a 0
    · simpa [avg, ha, union_cons, sub_cons, card_cons] using
        congrArg₂ (fun x y : ℝ => (1 - ρ) * x + ρ * y) hi0 hi1
    · have hfactor :
          (fun y : Mask n =>
            if Sub (tail a) y then (ρ⁻¹) ^ (1 + card (tail a)) *
              f (cons true y) else 0) =
          (fun y : Mask n =>
            ρ⁻¹ * (if Sub (tail a) y then
              (ρ⁻¹) ^ card (tail a) * f (cons true y) else 0)) := by
        funext y
        split_ifs <;> simp [pow_add] <;> ring
      simp only [avg, union_cons, Bool.false_or, Bool.true_or, sub_cons,
        Bool.false_eq_true, false_and, false_implies, true_implies,
        true_and, ite_false, card_cons, ite_true, avg_const, mul_zero,
        add_zero]
      rw [hfactor, avg_mul, ← hi1]
      field_simp
      ring

def score {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ) (p : Law B)
    (labels : B → Mask n) (y : Mask n) (b : B) : ℝ :=
  if Sub (labels b) y then p b * (ρ⁻¹) ^ card (labels b) else 0

def partition {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ) (p : Law B)
    (labels : B → Mask n) (y : Mask n) : ℝ := ∑ b, score ρ p labels y b

def joint {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ) (p : Law B)
    (labels : B → Mask n) (w : Mask n) (c b : B) : ℝ :=
  p c * score ρ p labels (union w (labels c)) b /
    partition ρ p labels (union w (labels c))

theorem score_nonneg {n : ℕ} {B : Type} [Fintype B] {ρ : ℝ} (hρ : 0 < ρ)
    (p : Law B) (labels : B → Mask n) (y : Mask n) (b : B) :
    0 ≤ score ρ p labels y b := by
  unfold score
  split_ifs
  · exact mul_nonneg (p.positive b).le (pow_nonneg (inv_nonneg.mpr hρ.le) _)
  · exact le_rfl

theorem partition_pos {n : ℕ} {B : Type} [Fintype B] {ρ : ℝ} (hρ : 0 < ρ)
    (p : Law B) (labels : B → Mask n) (w : Mask n) (c : B) :
    0 < partition ρ p labels (union w (labels c)) := by
  have hc : Sub (labels c) (union w (labels c)) := by
    intro i hi
    simp [union, hi]
  have hp : 0 < score ρ p labels (union w (labels c)) c := by
    simp only [score, hc, ite_true]
    exact mul_pos (p.positive c) (pow_pos (inv_pos.mpr hρ) _)
  exact lt_of_lt_of_le hp
    (Finset.single_le_sum (fun b _ => score_nonneg hρ p labels _ b) (Finset.mem_univ c))

theorem joint_nonneg {n : ℕ} {B : Type} [Fintype B] {ρ : ℝ} (hρ : 0 < ρ)
    (p : Law B) (labels : B → Mask n) (w : Mask n) (c b : B) :
    0 ≤ joint ρ p labels w c b := by
  exact div_nonneg
    (mul_nonneg (le_of_lt (p.positive c)) (score_nonneg hρ p labels _ b))
    (le_of_lt (partition_pos hρ p labels w c))

theorem joint_source {n : ℕ} {B : Type} [Fintype B] {ρ : ℝ} (hρ : 0 < ρ)
    (p : Law B) (labels : B → Mask n) (w : Mask n) (c : B) :
    (∑ b, joint ρ p labels w c b) = p c := by
  unfold joint
  rw [← Finset.sum_div, ← Finset.mul_sum]
  change p c * partition ρ p labels (union w (labels c)) /
    partition ρ p labels (union w (labels c)) = p c
  exact mul_div_cancel_right₀ _ (ne_of_gt (partition_pos hρ p labels w c))

theorem planted_density {n : ℕ} {B : Type} [Fintype B] {ρ : ℝ}
    (hρ : ρ ≠ 0) (p : Law B) (labels : B → Mask n) (f : Mask n → ℝ) :
    avg ρ (fun w => ∑ c, p c * f (union w (labels c))) =
      avg ρ (fun y => partition ρ p labels y * f y) := by
  classical
  rw [avg_sum]
  simp_rw [avg_mul, avg_plant hρ]
  simp_rw [← avg_mul]
  rw [← avg_sum]
  apply avg_congr
  intro y
  simp only [partition, Finset.sum_mul, score]
  apply Finset.sum_congr rfl
  intro b _
  split_ifs <;> ring

def highJoint {n : ℕ} {B : Type} [Fintype B] (ρ cut : ℝ) (p : Law B)
    (labels : B → Mask n) (w : Mask n) (c b : B) : ℝ :=
  if cut ≤ partition ρ p labels (union w (labels c))
  then joint ρ p labels w c b else 0

theorem highJoint_nonneg {n : ℕ} {B : Type} [Fintype B] {ρ : ℝ}
    (hρ : 0 < ρ) (cut : ℝ) (p : Law B) (labels : B → Mask n)
    (w : Mask n) (c b : B) : 0 ≤ highJoint ρ cut p labels w c b := by
  unfold highJoint
  split_ifs
  · exact joint_nonneg hρ p labels w c b
  · exact le_rfl

theorem highJoint_bound {n : ℕ} {B : Type} [Fintype B] {ρ cut : ℝ}
    (hρ : 0 < ρ) (hcut : 0 < cut) (p : Law B) (labels : B → Mask n)
    (w : Mask n) (c b : B) :
    highJoint ρ cut p labels w c b ≤
      cut⁻¹ * p c * score ρ p labels (union w (labels c)) b := by
  unfold highJoint
  split_ifs with h
  · have hn := mul_nonneg (p.positive c).le
      (score_nonneg hρ p labels (union w (labels c)) b)
    have hd := div_le_div_of_nonneg_left hn hcut h
    change p c * score ρ p labels (union w (labels c)) b /
      partition ρ p labels (union w (labels c)) ≤ _
    calc
      _ ≤ (p c * score ρ p labels (union w (labels c)) b) / cut := hd
      _ = _ := by rw [div_eq_mul_inv]; ring
  · exact mul_nonneg
      (mul_nonneg (inv_nonneg.mpr hcut.le) (p.positive c).le)
      (score_nonneg hρ p labels _ b)

theorem cancel_fragment_power {n : ℕ} {ρ : ℝ} (hρ : ρ ≠ 0)
    (a c : Mask n) :
    (ρ⁻¹) ^ card a * ρ ^ card (diff a c) = (ρ⁻¹) ^ card (inter a c) := by
  calc
    (ρ⁻¹) ^ card a * ρ ^ card (diff a c) =
        ((ρ⁻¹) ^ card (diff a c) * ρ ^ card (diff a c)) *
          (ρ⁻¹) ^ card (inter a c) := by
            rw [card_partition a c, pow_add]
            ring
    _ = _ := by rw [← mul_pow, inv_mul_cancel₀ hρ, one_pow, one_mul]

theorem outside_pair_bound {n : ℕ} {B : Type} [Fintype B] {ρ cut : ℝ}
    (hρ : 0 < ρ) (hρ' : ρ ≤ 1) (hcut : 0 < cut)
    (p : Law B) (labels : B → Mask n) (c b : B)
    (f : Mask n → ℝ) (hf : ∀ w, 0 ≤ f w) (hout : Avoids (labels b) f) :
    avg ρ (fun w => highJoint ρ cut p labels w c b * f w) ≤
      cut⁻¹ * p c * p b * (ρ⁻¹) ^ card (inter (labels b) (labels c)) *
        avg ρ f := by
  calc
    avg ρ (fun w => highJoint ρ cut p labels w c b * f w) ≤
        avg ρ (fun w =>
          (cut⁻¹ * p c * score ρ p labels (union w (labels c)) b) * f w) := by
            apply avg_mono hρ.le hρ'
            intro w
            exact mul_le_mul_of_nonneg_right (highJoint_bound hρ hcut p labels w c b)
              (hf w)
    _ = avg ρ (fun w =>
        (cut⁻¹ * p c * p b * (ρ⁻¹) ^ card (labels b)) *
          (if Sub (diff (labels b) (labels c)) w then f w else 0)) := by
            apply avg_congr
            intro w
            simp only [← sub_diff_union, score]
            split_ifs <;> ring
    _ = (cut⁻¹ * p c * p b * (ρ⁻¹) ^ card (labels b)) *
        (ρ ^ card (diff (labels b) (labels c)) * avg ρ f) := by
          rw [avg_mul, avg_subset_factor ρ _ f (avoids_mono hout (diff_sub _ _))]
    _ = (cut⁻¹ * p c * p b) *
        ((ρ⁻¹) ^ card (labels b) * ρ ^ card (diff (labels b) (labels c))) *
        avg ρ f := by ring
    _ = _ := by rw [cancel_fragment_power hρ.ne']

theorem outside_kernel_bound {n : ℕ} {B : Type} [Fintype B] {ρ cut : ℝ}
    (hρ : 0 < ρ) (hρ' : ρ ≤ 1) (hcut : 0 < cut)
    (p : Law B) (labels : B → Mask n) (b : B)
    (u : B → ℝ) (hu : ∀ c, 0 ≤ u c)
    (f : Mask n → ℝ) (hf : ∀ w, 0 ≤ f w) (hout : Avoids (labels b) f) :
    avg ρ (fun w => ∑ c, u c * (highJoint ρ cut p labels w c b * f w)) ≤
      cut⁻¹ * p b * avg ρ f *
        (∑ c, u c * p c * (ρ⁻¹) ^ card (inter (labels b) (labels c))) := by
  calc
    avg ρ (fun w => ∑ c, u c * (highJoint ρ cut p labels w c b * f w)) =
        ∑ c, u c * avg ρ (fun w => highJoint ρ cut p labels w c b * f w) := by
          rw [avg_sum]
          simp_rw [avg_mul]
    _ ≤ ∑ c, u c * (cut⁻¹ * p c * p b *
        (ρ⁻¹) ^ card (inter (labels b) (labels c)) * avg ρ f) := by
          apply Finset.sum_le_sum
          intro c _
          exact mul_le_mul_of_nonneg_left
            (outside_pair_bound hρ hρ' hcut p labels c b f hf hout) (hu c)
    _ = _ := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro c _
      ring

theorem two_le_exp_one : (2 : ℝ) ≤ Real.exp 1 := by
  have h := Real.add_one_le_exp (1 : ℝ)
  linarith

theorem inverse_one_le {ρ : ℝ} (hρ : 0 < ρ) (hρ' : ρ ≤ 1) : 1 ≤ ρ⁻¹ := by
  simpa only [one_div] using (le_div_iff₀ hρ).mpr (show (1 : ℝ) * ρ ≤ 1 by simpa)

theorem moment_exp {n : ℕ} {B : Type} [Fintype B] {ρ a : ℝ} {m : ℕ}
    (hρ : 0 < ρ) (hρ' : ρ ≤ 1) (ha : 0 ≤ a)
    (hratio : a / ρ ≤ Real.exp (-50))
    (p : Law B) (labels : B → Mask n) (hs : Spread p labels a)
    (target : Mask n) (hm : card target ≤ m) :
    (∑ c, p c * (ρ⁻¹) ^ card (inter target (labels c))) ≤ Real.exp (m : ℝ) := by
  have hr : a * ρ⁻¹ ≤ 1 := le_trans
    (by simpa only [div_eq_mul_inv] using hratio)
    (Real.exp_le_one_iff.mpr (by norm_num))
  have hb : 1 + a * (ρ⁻¹ - 1) ≤ Real.exp 1 := by
    nlinarith [two_le_exp_one]
  have h := moment_bound p labels ha (inverse_one_le hρ hρ')
    (le_trans (by norm_num : (1 : ℝ) ≤ 2) two_le_exp_one) hs hb target hm
  simpa only [← Real.exp_nat_mul, mul_one] using h

theorem tail_moment {n : ℕ} {B : Type} [Fintype B] {ρ a : ℝ} {m : ℕ}
    (hρ : 0 < ρ) (hρ' : ρ ≤ 1) (ha : 0 ≤ a)
    (hratio : a / ρ ≤ Real.exp (-50))
    (p : Law B) (labels : B → Mask n) (hs : Spread p labels a)
    (target : Mask n) (hm : card target ≤ m) :
    (∑ c, (if m < 2 * card (inter target (labels c)) then (1 : ℝ) else 0) *
      p c * (ρ⁻¹) ^ card (inter target (labels c))) ≤
      Real.exp (-(25 : ℝ) * m) * 2 ^ m := by
  let q : ℝ := Real.exp 50 * ρ⁻¹
  have he : 1 ≤ Real.exp (50 : ℝ) := by
    simpa using Real.exp_le_exp.mpr (show (0 : ℝ) ≤ 50 by norm_num)
  have hq : 1 ≤ q := one_le_mul_of_one_le_of_one_le he (inverse_one_le hρ hρ')
  have haq : a * q ≤ 1 := by
    calc
      a * q = Real.exp 50 * (a / ρ) := by dsimp [q]; ring
      _ ≤ Real.exp 50 * Real.exp (-50) :=
        mul_le_mul_of_nonneg_left hratio (Real.exp_pos _).le
      _ = 1 := by rw [← Real.exp_add]; norm_num
  have hmoment : (∑ c, p c * q ^ card (inter target (labels c))) ≤ 2 ^ m :=
    moment_bound p labels ha hq (by norm_num) hs (by nlinarith) target hm
  have hpoint : ∀ r : ℕ,
      (if m < 2 * r then (1 : ℝ) else 0) * (ρ⁻¹) ^ r ≤
        Real.exp (-(25 : ℝ) * m) * q ^ r := by
    intro r
    by_cases hr : m < 2 * r
    · have hmr : (m : ℝ) ≤ 2 * (r : ℝ) := by exact_mod_cast hr.le
      have hx : 1 ≤ Real.exp (-(25 : ℝ) * m) * Real.exp 50 ^ r := by
        rw [← Real.exp_nat_mul, ← Real.exp_add]
        calc
          1 = Real.exp 0 := (Real.exp_zero).symm
          _ ≤ _ := Real.exp_le_exp.mpr (by nlinarith)
      simpa only [hr, ite_true, one_mul, q, mul_pow, mul_assoc] using
        mul_le_mul_of_nonneg_right hx (pow_nonneg (inv_nonneg.mpr hρ.le) r)
    · simp only [hr, ite_false, zero_mul]
      exact mul_nonneg (Real.exp_pos _).le (pow_nonneg (le_trans (by norm_num) hq) _)
  calc
    _ ≤ ∑ c, p c * (Real.exp (-(25 : ℝ) * m) *
          q ^ card (inter target (labels c))) := by
      apply Finset.sum_le_sum
      intro c _
      convert mul_le_mul_of_nonneg_left
        (hpoint (card (inter target (labels c)))) (p.positive c).le using 1 <;> ring
    _ = Real.exp (-(25 : ℝ) * m) * (∑ c, p c *
        q ^ card (inter target (labels c))) := by
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro c _
          ring
    _ ≤ _ := mul_le_mul_of_nonneg_left hmoment (Real.exp_pos _).le

theorem distortion {n : ℕ} {B : Type} [Fintype B] {ρ a : ℝ} {m : ℕ}
    (hρ : 0 < ρ) (hρ' : ρ ≤ 1) (ha : 0 ≤ a)
    (hratio : a / ρ ≤ Real.exp (-50))
    (p : Law B) (labels : B → Mask n) (hs : Spread p labels a)
    (hm : ∀ b, card (labels b) ≤ m) (b : B)
    (f : Mask n → ℝ) (hf : ∀ w, 0 ≤ f w) (hout : Avoids (labels b) f) :
    avg ρ (fun w => (∑ c,
      highJoint ρ (Real.exp (-(10 : ℝ) * m)) p labels w c b) * f w) ≤
        Real.exp ((11 : ℝ) * m) * p b * avg ρ f := by
  have hb := outside_kernel_bound (cut := Real.exp (-(10 : ℝ) * m))
    hρ hρ' (Real.exp_pos _) p labels b
    (fun _ => 1) (fun _ => by norm_num) f hf hout
  simp only [one_mul, ← Finset.sum_mul] at hb
  have hcoef : 0 ≤ (Real.exp (-(10 : ℝ) * m))⁻¹ * p b * avg ρ f :=
    mul_nonneg
      (mul_nonneg (inv_nonneg.mpr (Real.exp_pos _).le) (p.positive b).le)
      (avg_nonneg hρ.le hρ' hf)
  have ht := le_trans hb
    (mul_le_mul_of_nonneg_left (moment_exp hρ hρ' ha hratio p labels hs _ (hm b)) hcoef)
  have hid : (Real.exp (-(10 : ℝ) * m))⁻¹ * Real.exp (m : ℝ) =
      Real.exp ((11 : ℝ) * m) := by
    rw [← Real.exp_neg, ← Real.exp_add]
    congr 1
    ring
  calc
    _ ≤ (Real.exp (-(10 : ℝ) * m))⁻¹ * p b * avg ρ f *
        Real.exp (m : ℝ) := ht
    _ = ((Real.exp (-(10 : ℝ) * m))⁻¹ * Real.exp (m : ℝ)) *
        p b * avg ρ f := by ring
    _ = _ := by rw [hid]

def passes {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ) (m : ℕ)
    (p : Law B) (labels : B → Mask n) (w : Mask n) (c b : B) : Prop :=
  Real.exp (-(10 : ℝ) * m) ≤ partition ρ p labels (union w (labels c)) ∧
    2 * card (diff (labels b) w) ≤ m

def mass {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ) (m : ℕ)
    (p : Law B) (labels : B → Mask n) (w : Mask n) (b : B) : ℝ :=
  ∑ c, if passes ρ m p labels w c b then joint ρ p labels w c b else 0

def failure {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ) (m : ℕ)
    (p : Law B) (labels : B → Mask n) (w : Mask n) : ℝ :=
  ∑ c, ∑ b, if passes ρ m p labels w c b then 0 else joint ρ p labels w c b

theorem mass_nonneg {n : ℕ} {B : Type} [Fintype B] {ρ : ℝ}
    (hρ : 0 < ρ) (m : ℕ) (p : Law B) (labels : B → Mask n) (w : Mask n) (b : B) :
    0 ≤ mass ρ m p labels w b := by
  apply Finset.sum_nonneg
  intro c _
  split_ifs
  · exact joint_nonneg hρ p labels w c b
  · exact le_rfl

theorem failure_nonneg {n : ℕ} {B : Type} [Fintype B] {ρ : ℝ}
    (hρ : 0 < ρ) (m : ℕ) (p : Law B) (labels : B → Mask n) (w : Mask n) :
    0 ≤ failure ρ m p labels w := by
  apply Finset.sum_nonneg
  intro c _
  apply Finset.sum_nonneg
  intro b _
  split_ifs
  · exact le_rfl
  · exact joint_nonneg hρ p labels w c b

theorem local_normalization {n : ℕ} {B : Type} [Fintype B] {ρ : ℝ}
    (hρ : 0 < ρ) (m : ℕ) (p : Law B) (labels : B → Mask n) (w : Mask n) :
    failure ρ m p labels w + ∑ b, mass ρ m p labels w b = 1 := by
  classical
  unfold failure mass
  rw [Finset.sum_comm (f := fun b c =>
    if passes ρ m p labels w c b then joint ρ p labels w c b else 0)]
  rw [← Finset.sum_add_distrib]
  calc
    _ = ∑ c, ∑ b, joint ρ p labels w c b := by
      apply Finset.sum_congr rfl
      intro c _
      rw [← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro b _
      split_ifs <;> ring
    _ = 1 := by simp_rw [joint_source hρ]; exact p.total

theorem mass_le_high {n : ℕ} {B : Type} [Fintype B] {ρ : ℝ}
    (hρ : 0 < ρ) (m : ℕ) (p : Law B) (labels : B → Mask n) (w : Mask n) (b : B) :
    mass ρ m p labels w b ≤
      ∑ c, highJoint ρ (Real.exp (-(10 : ℝ) * m)) p labels w c b := by
  apply Finset.sum_le_sum
  intro c _
  unfold highJoint
  by_cases hp : passes ρ m p labels w c b
  · simp only [hp, hp.1, ite_true, le_refl]
  · simp only [hp, ite_false]
    split_ifs
    · simpa only [one_mul] using joint_nonneg hρ p labels w c b
    · simp only [zero_mul, le_refl]

theorem mass_distortion {n : ℕ} {B : Type} [Fintype B] {ρ a : ℝ} {m : ℕ}
    (hρ : 0 < ρ) (hρ' : ρ ≤ 1) (ha : 0 ≤ a)
    (hratio : a / ρ ≤ Real.exp (-50))
    (p : Law B) (labels : B → Mask n) (hs : Spread p labels a)
    (hm : ∀ b, card (labels b) ≤ m) (b : B)
    (f : Mask n → ℝ) (hf : ∀ w, 0 ≤ f w) (hout : Avoids (labels b) f) :
    avg ρ (fun w => mass ρ m p labels w b * f w) ≤
        Real.exp ((11 : ℝ) * m) * p b * avg ρ f :=
  le_trans
    (avg_mono hρ.le hρ' (fun w =>
      mul_le_mul_of_nonneg_right (mass_le_high hρ m p labels w b) (hf w)))
    (distortion hρ hρ' ha hratio p labels hs hm b f hf hout)

def smallMass {n : ℕ} {B : Type} [Fintype B] (ρ cut : ℝ)
    (p : Law B) (labels : B → Mask n) (w : Mask n) : ℝ :=
  ∑ c, if partition ρ p labels (union w (labels c)) < cut then p c else 0

def largeMass {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ) (m : ℕ)
    (p : Law B) (labels : B → Mask n) (w : Mask n) : ℝ :=
  ∑ b, ∑ c,
    (if m < 2 * card (inter (labels b) (labels c)) then (1 : ℝ) else 0) *
      highJoint ρ (Real.exp (-(10 : ℝ) * m)) p labels w c b

theorem smallMass_bound {n : ℕ} {B : Type} [Fintype B] {ρ cut : ℝ}
    (hρ : 0 < ρ) (hρ' : ρ ≤ 1) (hcut : 0 ≤ cut)
    (p : Law B) (labels : B → Mask n) :
    avg ρ (smallMass ρ cut p labels) ≤ cut := by
  have hd := planted_density hρ.ne' p labels
    (fun y => if partition ρ p labels y < cut then 1 else 0)
  have heq : avg ρ (smallMass ρ cut p labels) =
      avg ρ (fun y => if partition ρ p labels y < cut then
        partition ρ p labels y else 0) := by
    convert hd using 1
    · apply avg_congr
      intro w
      apply Finset.sum_congr rfl
      intro c _
      split_ifs <;> ring
    · apply avg_congr
      intro y
      split_ifs <;> ring
  rw [heq]
  calc
    _ ≤ avg ρ (fun _ : Mask n => cut) := by
      apply avg_mono hρ.le hρ'
      intro y
      split_ifs with h
      · exact h.le
      · exact hcut
    _ = _ := avg_const _ _

theorem failure_decomposition {n : ℕ} {B : Type} [Fintype B] {ρ : ℝ}
    (hρ : 0 < ρ) (m : ℕ) (p : Law B) (labels : B → Mask n) (w : Mask n) :
    failure ρ m p labels w ≤
      smallMass ρ (Real.exp (-(10 : ℝ) * m)) p labels w +
      largeMass ρ m p labels w := by
  classical
  have hpoint : ∀ c b,
      (if passes ρ m p labels w c b then 0 else joint ρ p labels w c b) ≤
      (if partition ρ p labels (union w (labels c)) <
          Real.exp (-(10 : ℝ) * m) then joint ρ p labels w c b else 0) +
      (if m < 2 * card (inter (labels b) (labels c)) then (1 : ℝ) else 0) *
        highJoint ρ (Real.exp (-(10 : ℝ) * m)) p labels w c b := by
    intro c b
    by_cases hz : Real.exp (-(10 : ℝ) * m) ≤
        partition ρ p labels (union w (labels c))
    · have hnot := not_lt.mpr hz
      by_cases hl : 2 * card (diff (labels b) w) ≤ m
      · simp only [passes, hz, hl, and_self, ite_true, hnot, ite_false,
          highJoint, zero_add]
        split_ifs
        · simpa only [one_mul] using joint_nonneg hρ p labels w c b
        · simp only [zero_mul, le_refl]
      · by_cases hc : Sub (labels b) (union w (labels c))
        · have hm := Nat.mul_le_mul_left 2 (card_mono (diff_sub_inter hc))
          have hr : m < 2 * card (inter (labels b) (labels c)) := by omega
          simp only [passes, hz, hl, and_false, ite_false, hnot, hr, ite_true,
            highJoint, one_mul, zero_add, le_refl]
        · simp [passes, hz, hl, hnot, highJoint, joint, score, hc]
    · have hlt := lt_of_not_ge hz
      simp only [passes, hz, false_and, ite_false, hlt, ite_true, highJoint,
        mul_zero, add_zero, le_refl]
  calc
    _ ≤ ∑ c, ∑ b,
        ((if partition ρ p labels (union w (labels c)) <
            Real.exp (-(10 : ℝ) * m) then joint ρ p labels w c b else 0) +
        (if m < 2 * card (inter (labels b) (labels c)) then (1 : ℝ) else 0) *
          highJoint ρ (Real.exp (-(10 : ℝ) * m)) p labels w c b) := by
            apply Finset.sum_le_sum
            intro c _
            exact Finset.sum_le_sum (fun b _ => hpoint c b)
    _ = _ := by
      simp only [Finset.sum_add_distrib]
      congr 1
      · apply Finset.sum_congr rfl
        intro c _
        by_cases hz : partition ρ p labels (union w (labels c)) <
            Real.exp (-(10 : ℝ) * m)
        · simp only [hz, ite_true]
          exact joint_source hρ p labels w c
        · simp only [hz, ite_false, Finset.sum_const_zero]
      · exact Finset.sum_comm

theorem largeMass_bound {n : ℕ} {B : Type} [Fintype B] {ρ a : ℝ} {m : ℕ}
    (hρ : 0 < ρ) (hρ' : ρ ≤ 1) (ha : 0 ≤ a)
    (hratio : a / ρ ≤ Real.exp (-50))
    (p : Law B) (labels : B → Mask n) (hs : Spread p labels a)
    (hm : ∀ b, card (labels b) ≤ m) :
    avg ρ (largeMass ρ m p labels) ≤ Real.exp (-(14 : ℝ) * m) := by
  let cut := Real.exp (-(10 : ℝ) * m)
  have hlocal : ∀ b, avg ρ (fun w => ∑ c,
        (if m < 2 * card (inter (labels b) (labels c)) then (1 : ℝ) else 0) *
        highJoint ρ cut p labels w c b) ≤
      cut⁻¹ * p b * (Real.exp (-(25 : ℝ) * m) * 2 ^ m) := by
    intro b
    have hb := outside_kernel_bound (cut := cut) hρ hρ' (Real.exp_pos _) p labels b
      (fun c => if m < 2 * card (inter (labels b) (labels c)) then 1 else 0)
      (fun c => by split_ifs <;> norm_num) (fun _ => 1)
      (fun _ => by norm_num) (fun _ _ _ => rfl)
    simp only [mul_one, avg_const] at hb
    exact le_trans hb
      (mul_le_mul_of_nonneg_left (tail_moment hρ hρ' ha hratio p labels hs _ (hm b))
        (mul_nonneg (inv_nonneg.mpr (Real.exp_pos _).le) (p.positive b).le))
  have htwo : (2 : ℝ) ^ m ≤ Real.exp (m : ℝ) := by
    simpa only [← Real.exp_nat_mul, mul_one] using
      pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 2) two_le_exp_one m
  calc
    _ = ∑ b, avg ρ (fun w => ∑ c,
        (if m < 2 * card (inter (labels b) (labels c)) then (1 : ℝ) else 0) *
        highJoint ρ cut p labels w c b) := avg_sum _ _ _
    _ ≤ ∑ b, cut⁻¹ * p b * (Real.exp (-(25 : ℝ) * m) * 2 ^ m) :=
      Finset.sum_le_sum (fun b _ => hlocal b)
    _ = cut⁻¹ * (Real.exp (-(25 : ℝ) * m) * 2 ^ m) := by
      calc
        _ = cut⁻¹ * (Real.exp (-(25 : ℝ) * m) * 2 ^ m) * (∑ b, p b) := by
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro b _
          ring
        _ = _ := by rw [p.total, mul_one]
    _ ≤ cut⁻¹ * (Real.exp (-(25 : ℝ) * m) * Real.exp (m : ℝ)) := by
      gcongr
    _ = _ := by
      dsimp [cut]
      rw [← Real.exp_neg, ← Real.exp_add, ← Real.exp_add]
      congr 1
      ring

theorem local_failure {n : ℕ} {B : Type} [Fintype B] {ρ a : ℝ} {m : ℕ}
    (hρ : 0 < ρ) (hρ' : ρ ≤ 1) (ha : 0 ≤ a) (hmpos : 1 ≤ m)
    (hratio : a / ρ ≤ Real.exp (-50))
    (p : Law B) (labels : B → Mask n) (hs : Spread p labels a)
    (hm : ∀ b, card (labels b) ≤ m) :
    avg ρ (failure ρ m p labels) ≤ Real.exp (-(9 : ℝ) * m) := by
  have he : Real.exp (-(14 : ℝ) * m) ≤ Real.exp (-(10 : ℝ) * m) :=
    Real.exp_le_exp.mpr (by nlinarith [show (0 : ℝ) ≤ m from Nat.cast_nonneg m])
  have htwo : (2 : ℝ) ≤ Real.exp (m : ℝ) :=
    le_trans two_le_exp_one
      (Real.exp_le_exp.mpr (by exact_mod_cast hmpos))
  calc
    _ ≤ avg ρ (fun w =>
        smallMass ρ (Real.exp (-(10 : ℝ) * m)) p labels w +
        largeMass ρ m p labels w) :=
      avg_mono hρ.le hρ' (failure_decomposition hρ m p labels)
    _ = _ := avg_add _ _ _
    _ ≤ Real.exp (-(10 : ℝ) * m) + Real.exp (-(14 : ℝ) * m) :=
      add_le_add (smallMass_bound hρ hρ' (Real.exp_pos _).le p labels)
        (largeMass_bound hρ hρ' ha hratio p labels hs hm)
    _ ≤ Real.exp (-(10 : ℝ) * m) * Real.exp (m : ℝ) := by
      nlinarith [Real.exp_pos (-(10 : ℝ) * m)]
    _ = _ := by rw [← Real.exp_add]; congr 1; ring

theorem inter_sub_right {n : ℕ} (a b : Mask n) : Sub (inter a b) b := by
  intro i hi
  have h : a i = true ∧ b i = true := by simpa [inter] using hi
  exact h.2

theorem card_zero {n : ℕ} {a : Mask n} (h : card a = 0) :
    ∀ i, a i = false := by
  induction n with
  | zero => intro i; exact Fin.elim0 i
  | succ n ih =>
    have ht : card (tail a) = 0 := by
      simp only [card] at h
      omega
    have hh : a 0 = false := by
      cases ha : a 0
      · rfl
      · simp [card, ha] at h
    intro i
    refine Fin.cases hh (fun j => ih ht j) i

theorem sub_of_card_zero {n : ℕ} {a : Mask n} (h : card a = 0) (b : Mask n) :
    Sub a b := by
  intro i hi
  have hh := card_zero h i
  simp [hh] at hi

theorem mass_capacity {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ) (m : ℕ)
    (p : Law B) (labels : B → Mask n) (w : Mask n) (b : B)
    (hpos : 0 < mass ρ m p labels w b) :
    card (diff (labels b) w) ≤ m / 2 := by
  by_contra h
  have hz : mass ρ m p labels w b = 0 := by
    apply Finset.sum_eq_zero
    intro c _
    have hp : ¬passes ρ m p labels w c b := by
      intro hp
      have := hp.2
      omega
    simp only [hp, ite_false]
  rw [hz] at hpos
  exact (lt_irrefl 0) hpos

theorem mass_spread_raw {n : ℕ} {B : Type} [Fintype B] {ρ : ℝ}
    (hρ : 0 < ρ) (m : ℕ) (p : Law B) (labels : B → Mask n)
    (w j : Mask n) :
    (∑ b, if Sub j (diff (labels b) w) then mass ρ m p labels w b else 0) ≤
      ∑ c, if Sub j (labels c) then p c else 0 := by
  classical
  have hpoint : ∀ c b,
      (if Sub j (diff (labels b) w) then
        (if passes ρ m p labels w c b then joint ρ p labels w c b else 0)
        else 0) ≤
      (if Sub j (labels c) then joint ρ p labels w c b else 0) := by
    intro c b
    by_cases hsc : Sub j (labels c)
    · simp only [hsc, ite_true]
      split_ifs <;> first | exact le_rfl | exact joint_nonneg hρ p labels w c b
    · by_cases hj : Sub j (diff (labels b) w)
      · by_cases hc : Sub (labels b) (union w (labels c))
        · have hs := sub_trans hj
            (sub_trans (diff_sub_inter hc) (inter_sub_right _ _))
          exact False.elim (hsc hs)
        · simp only [joint, score, hc, ite_false, mul_zero, zero_div]
          simp
      · simp only [hj, hsc, ite_false, le_refl]
  calc
    _ = ∑ b, ∑ c, if Sub j (diff (labels b) w) then
        (if passes ρ m p labels w c b then joint ρ p labels w c b else 0)
        else 0 := by
      apply Finset.sum_congr rfl
      intro b _
      by_cases hj : Sub j (diff (labels b) w)
      · simp only [hj, ite_true, mass]
      · simp only [hj, ite_false, Finset.sum_const_zero]
    _ ≤ ∑ b, ∑ c, if Sub j (labels c) then joint ρ p labels w c b else 0 := by
      apply Finset.sum_le_sum
      intro b _
      exact Finset.sum_le_sum (fun c _ => hpoint c b)
    _ = _ := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro c _
      by_cases hj : Sub j (labels c)
      · simp only [hj, ite_true]
        exact joint_source hρ p labels w c
      · simp only [hj, ite_false, Finset.sum_const_zero]

def AgreeOutside {n : ℕ} (a w w' : Mask n) : Prop :=
  ∀ i, a i = false → w i = w' i

theorem diff_invariant {n : ℕ} {a l w w' : Mask n}
    (hl : Disj l a) (hw : AgreeOutside a w w') : diff l w = diff l w' := by
  funext i
  cases hi : l i
  · simp [diff, hi]
  · simp only [diff, hi, Bool.true_and]
    rw [hw i (hl i hi)]

theorem sub_union_invariant {n : ℕ} {a l c w w' : Mask n}
    (hl : Disj l a) (hw : AgreeOutside a w w') :
    Sub l (union w c) ↔ Sub l (union w' c) := by
  constructor
  · intro h i hi
    simpa only [union, ← hw i (hl i hi)] using h i hi
  · intro h i hi
    simpa only [union, hw i (hl i hi)] using h i hi

theorem score_invariant {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ)
    (p : Law B) (labels : B → Mask n) {a w w' : Mask n}
    (hl : ∀ b, Disj (labels b) a) (hw : AgreeOutside a w w') (c b : B) :
    score ρ p labels (union w (labels c)) b =
      score ρ p labels (union w' (labels c)) b := by
  simp only [score, sub_union_invariant (hl b) hw]

theorem partition_invariant {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ)
    (p : Law B) (labels : B → Mask n) {a w w' : Mask n}
    (hl : ∀ b, Disj (labels b) a) (hw : AgreeOutside a w w') (c : B) :
    partition ρ p labels (union w (labels c)) =
      partition ρ p labels (union w' (labels c)) := by
  apply Finset.sum_congr rfl
  intro b _
  exact score_invariant ρ p labels hl hw c b

theorem joint_invariant {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ)
    (p : Law B) (labels : B → Mask n) {a w w' : Mask n}
    (hl : ∀ b, Disj (labels b) a) (hw : AgreeOutside a w w') (c b : B) :
    joint ρ p labels w c b = joint ρ p labels w' c b := by
  simp only [joint, score_invariant ρ p labels hl hw,
    partition_invariant ρ p labels hl hw]

theorem passes_invariant {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ) (m : ℕ)
    (p : Law B) (labels : B → Mask n) {a w w' : Mask n}
    (hl : ∀ b, Disj (labels b) a) (hw : AgreeOutside a w w') (c b : B) :
    passes ρ m p labels w c b ↔ passes ρ m p labels w' c b := by
  simp only [passes, partition_invariant ρ p labels hl hw,
    diff_invariant (hl b) hw]

theorem mass_invariant {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ) (m : ℕ)
    (p : Law B) (labels : B → Mask n) {a w w' : Mask n}
    (hl : ∀ b, Disj (labels b) a) (hw : AgreeOutside a w w') (b : B) :
    mass ρ m p labels w b = mass ρ m p labels w' b := by
  apply Finset.sum_congr rfl
  intro c _
  simp only [passes_invariant ρ m p labels hl hw,
    joint_invariant ρ p labels hl hw]

theorem failure_invariant {n : ℕ} {B : Type} [Fintype B] (ρ : ℝ) (m : ℕ)
    (p : Law B) (labels : B → Mask n) {a w w' : Mask n}
    (hl : ∀ b, Disj (labels b) a) (hw : AgreeOutside a w w') :
    failure ρ m p labels w = failure ρ m p labels w' := by
  apply Finset.sum_congr rfl
  intro c _
  apply Finset.sum_congr rfl
  intro b _
  simp only [passes_invariant ρ m p labels hl hw,
    joint_invariant ρ p labels hl hw]

inductive Tree (n : ℕ) : ℕ → Type 1 where
  | leaf : Tree n 0
  | node {h : ℕ} {B : Type} [Fintype B] (p : Law B)
      (labels : B → Mask n) (children : B → Tree n h) : Tree n (h + 1)

def treeAvoids {n h : ℕ} (t : Tree n h) (a : Mask n) : Prop :=
  match t with
  | .leaf => True
  | @Tree.node _ _ B inst _ labels children =>
      letI : Fintype B := inst
      (∀ b, Disj (labels b) a) ∧ ∀ b, treeAvoids (children b) a

def treeDisjoint {n h : ℕ} (t : Tree n h) : Prop :=
  match t with
  | .leaf => True
  | @Tree.node _ _ B inst _ labels children =>
      letI : Fintype B := inst
      ∀ b, treeAvoids (children b) (labels b) ∧ treeDisjoint (children b)

def Valid {n h : ℕ} (t : Tree n h) (m : ℕ → ℕ) (α : ℕ → ℝ) : Prop :=
  match t with
  | .leaf => True
  | @Tree.node _ _ B inst p labels children =>
      letI : Fintype B := inst
      (∀ b, card (labels b) ≤ m 0) ∧ Spread p labels (α 0) ∧
        ∀ b, Valid (children b) (fun j => m (j + 1)) (fun j => α (j + 1))

def potential {n h : ℕ} (t : Tree n h) (ρ : ℝ) (m : ℕ → ℕ)
    (w : Mask n) : ℝ :=
  match t with
  | .leaf => 0
  | @Tree.node _ _ B inst p labels children =>
      letI : Fintype B := inst
      Real.exp (m 0 : ℝ) * (failure ρ (m 0) p labels w +
        ∑ b, mass ρ (m 0) p labels w b *
          potential (children b) ρ (fun j => m (j + 1)) w)

def good {n h : ℕ} (t : Tree n h) (ρ : ℝ) (m : ℕ → ℕ) (w : Mask n) : Prop :=
  match t with
  | .leaf => True
  | @Tree.node _ _ B inst p labels children =>
      letI : Fintype B := inst
      1 - Real.exp (-(m 0 : ℝ)) ≤
        ∑ b, if good (children b) ρ (fun j => m (j + 1)) w
          then mass ρ (m 0) p labels w b else 0

theorem potential_nonneg {n h : ℕ} (t : Tree n h) {ρ : ℝ}
    (hρ : 0 < ρ) (m : ℕ → ℕ) (w : Mask n) : 0 ≤ potential t ρ m w := by
  induction t generalizing m with
  | leaf => exact le_rfl
  | node p labels children ih =>
    simp only [potential]
    apply mul_nonneg (Real.exp_pos _).le
    apply add_nonneg (failure_nonneg hρ _ p labels w)
    apply Finset.sum_nonneg
    intro b _
    exact mul_nonneg (mass_nonneg hρ _ p labels w b) (ih b _)

theorem potential_avoids {n h : ℕ} (t : Tree n h) (ρ : ℝ)
    (m : ℕ → ℕ) (a : Mask n) (ha : treeAvoids t a) :
    Avoids a (potential t ρ m) := by
  induction t generalizing m with
  | leaf => intro _ _ _; rfl
  | node p labels children ih =>
    obtain ⟨hl, hc⟩ := ha
    intro w w' hw
    simp only [potential]
    rw [failure_invariant ρ (m 0) p labels hl hw]
    congr 2
    apply Finset.sum_congr rfl
    intro b _
    rw [mass_invariant ρ (m 0) p labels hl hw b,
      ih b _ (hc b) w w' hw]

theorem expected_recurrence {n h : ℕ} {B : Type} [Fintype B]
    (p : Law B) (labels : B → Mask n) (children : B → Tree n h)
    {ρ : ℝ} (hρ : 0 < ρ) (hρ' : ρ ≤ 1) (m : ℕ → ℕ) (α : ℕ → ℝ)
    (hmpos : 1 ≤ m 0) (hα : 0 ≤ α 0) (hratio : α 0 / ρ ≤ Real.exp (-50))
    (hm : ∀ b, card (labels b) ≤ m 0) (hs : Spread p labels (α 0))
    (hd : treeDisjoint (.node p labels children)) :
    avg ρ (potential (.node p labels children) ρ m) ≤
      Real.exp (-(8 : ℝ) * m 0) +
        Real.exp ((12 : ℝ) * m 0) *
          (∑ b, p b * avg ρ (potential (children b) ρ (fun j => m (j + 1)))) := by
  have heq : avg ρ (potential (.node p labels children) ρ m) =
      Real.exp (m 0 : ℝ) *
        (avg ρ (failure ρ (m 0) p labels) +
          ∑ b, avg ρ (fun w => mass ρ (m 0) p labels w b *
            potential (children b) ρ (fun j => m (j + 1)) w)) := by
    simp only [potential, avg_mul, avg_add, avg_sum]
  rw [heq]
  calc
    _ ≤ Real.exp (m 0 : ℝ) *
        (Real.exp (-(9 : ℝ) * m 0) +
          ∑ b, Real.exp ((11 : ℝ) * m 0) * p b *
            avg ρ (potential (children b) ρ (fun j => m (j + 1)))) := by
      apply mul_le_mul_of_nonneg_left _ (Real.exp_pos _).le
      apply add_le_add (local_failure hρ hρ' hα hmpos hratio p labels hs hm)
      apply Finset.sum_le_sum
      intro b _
      exact mass_distortion hρ hρ' hα hratio p labels hs hm b _
        (potential_nonneg (children b) hρ _)
        (potential_avoids (children b) ρ _ (labels b) (hd b).1)
    _ = _ := by
      have h1 : Real.exp (m 0 : ℝ) * Real.exp (-(9 : ℝ) * m 0) =
          Real.exp (-(8 : ℝ) * m 0) := by
        rw [← Real.exp_add]
        congr 1
        ring
      have h2 : Real.exp (m 0 : ℝ) * Real.exp ((11 : ℝ) * m 0) =
          Real.exp ((12 : ℝ) * m 0) := by
        rw [← Real.exp_add]
        congr 1
        ring
      rw [mul_add, h1]
      congr 1
      rw [Finset.mul_sum, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro b _
      calc
        _ = (Real.exp (m 0 : ℝ) * Real.exp ((11 : ℝ) * m 0)) * p b *
            avg ρ (potential (children b) ρ (fun j => m (j + 1))) := by ring
        _ = _ := by rw [h2]; ring

theorem two_le_exp_nat {m : ℕ} (hm : 1 ≤ m) : (2 : ℝ) ≤ Real.exp (m : ℝ) :=
  le_trans two_le_exp_one (Real.exp_le_exp.mpr (by exact_mod_cast hm))

theorem barrier_step {m l : ℕ} (hm : 1 ≤ m) (hl : 3 * m ≤ l) :
    Real.exp (-(8 : ℝ) * m) +
      Real.exp ((12 : ℝ) * m) * Real.exp (-(7 : ℝ) * l) ≤
        Real.exp (-(7 : ℝ) * m) := by
  have hl' : 3 * (m : ℝ) ≤ (l : ℝ) := by exact_mod_cast hl
  have he : Real.exp ((12 : ℝ) * m) * Real.exp (-(7 : ℝ) * l) ≤
      Real.exp (-(8 : ℝ) * m) := by
    rw [← Real.exp_add]
    apply Real.exp_le_exp.mpr
    nlinarith [show (0 : ℝ) ≤ m from Nat.cast_nonneg m]
  calc
    _ ≤ Real.exp (-(8 : ℝ) * m) * Real.exp (m : ℝ) := by
      nlinarith [two_le_exp_nat hm, Real.exp_pos (-(8 : ℝ) * m)]
    _ = _ := by rw [← Real.exp_add]; congr 1; ring

theorem expected_bound {n h : ℕ} (t : Tree n h) {ρ : ℝ}
    (hρ : 0 < ρ) (hρ' : ρ ≤ 1) (m : ℕ → ℕ) (α : ℕ → ℝ)
    (hv : Valid t m α) (hd : treeDisjoint t)
    (hm : ∀ j, j < h → 1 ≤ m j) (hα : ∀ j, j < h → 0 ≤ α j)
    (hratio : ∀ j, j < h → α j / ρ ≤ Real.exp (-50))
    (hsep : ∀ j, j + 1 < h → 3 * m j ≤ m (j + 1)) :
    avg ρ (potential t ρ m) ≤
      if h = 0 then 0 else Real.exp (-(7 : ℝ) * m 0) := by
  induction t generalizing m α with
  | leaf => simp [potential]
  | @node h B inst p labels children ih =>
    simp only [Nat.succ_ne_zero, ite_false]
    have ht : ∀ b,
        avg ρ (potential (children b) ρ (fun j => m (j + 1))) ≤
          if h = 0 then 0 else Real.exp (-(7 : ℝ) * m 1) := by
      intro b
      exact ih b _ _ (hv.2.2 b) (hd b).2
        (fun j hj => hm (j + 1) (by omega))
        (fun j hj => hα (j + 1) (by omega))
        (fun j hj => hratio (j + 1) (by omega))
        (fun j hj => hsep (j + 1) (by omega))
    have hsum : (∑ b, p b *
        avg ρ (potential (children b) ρ (fun j => m (j + 1)))) ≤
          if h = 0 then 0 else Real.exp (-(7 : ℝ) * m 1) := by
      calc
        _ ≤ ∑ b, p b * (if h = 0 then 0 else Real.exp (-(7 : ℝ) * m 1)) :=
          Finset.sum_le_sum (fun b _ =>
            mul_le_mul_of_nonneg_left (ht b) (p.positive b).le)
        _ = _ := by rw [← Finset.sum_mul, p.total, one_mul]
    have hr := expected_recurrence p labels children hρ hρ' m α
      (hm 0 (by omega)) (hα 0 (by omega)) (hratio 0 (by omega)) hv.1 hv.2.1 hd
    by_cases hz : h = 0
    · simp only [hz, ite_true] at hsum
      calc
        _ ≤ Real.exp (-(8 : ℝ) * m 0) := by
          nlinarith [Real.exp_pos ((12 : ℝ) * m 0)]
        _ ≤ _ := Real.exp_le_exp.mpr (by
          nlinarith [show (0 : ℝ) ≤ m 0 from Nat.cast_nonneg _])
    · simp only [hz, ite_false] at hsum
      calc
        _ ≤ Real.exp (-(8 : ℝ) * m 0) +
            Real.exp ((12 : ℝ) * m 0) * Real.exp (-(7 : ℝ) * m 1) := by
          exact le_trans hr (add_le_add (le_refl _)
            (mul_le_mul_of_nonneg_left hsum (Real.exp_pos _).le))
        _ ≤ _ := barrier_step (hm 0 (by omega)) (hsep 0 (by omega))

theorem bad_potential {n h : ℕ} (t : Tree n h) {ρ : ℝ}
    (hρ : 0 < ρ) (m : ℕ → ℕ) (w : Mask n) (hg : ¬good t ρ m w) :
    1 < potential t ρ m w := by
  induction t generalizing m with
  | leaf => exact False.elim (hg trivial)
  | node p labels children ih =>
    have hbad :
        (∑ b, if good (children b) ρ (fun j => m (j + 1)) w then 0
          else mass ρ (m 0) p labels w b) ≤
        ∑ b, mass ρ (m 0) p labels w b *
          potential (children b) ρ (fun j => m (j + 1)) w := by
      apply Finset.sum_le_sum
      intro b _
      by_cases hb : good (children b) ρ (fun j => m (j + 1)) w
      · simp only [hb, ite_true]
        exact mul_nonneg (mass_nonneg hρ _ p labels w b)
          (potential_nonneg (children b) hρ _ w)
      · simp only [hb, ite_false]
        simpa only [mul_one] using mul_le_mul_of_nonneg_left
          (ih b _ hb).le (mass_nonneg hρ _ p labels w b)
    have hsplit : (∑ b, mass ρ (m 0) p labels w b) =
        (∑ b, if good (children b) ρ (fun j => m (j + 1)) w
          then mass ρ (m 0) p labels w b else 0) +
        (∑ b, if good (children b) ρ (fun j => m (j + 1)) w
          then 0 else mass ρ (m 0) p labels w b) := by
      rw [← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro b _
      split_ifs <;> ring
    have hnorm := local_normalization hρ (m 0) p labels w
    rw [hsplit] at hnorm
    have hsmall : (∑ b, if good (children b) ρ (fun j => m (j + 1)) w
          then mass ρ (m 0) p labels w b else 0) < 1 - Real.exp (-(m 0 : ℝ)) :=
      lt_of_not_ge hg
    have hnum : Real.exp (-(m 0 : ℝ)) <
        failure ρ (m 0) p labels w +
        ∑ b, mass ρ (m 0) p labels w b *
          potential (children b) ρ (fun j => m (j + 1)) w := by
      linarith
    have heps : Real.exp (m 0 : ℝ) * Real.exp (-(m 0 : ℝ)) = 1 := by
      rw [← Real.exp_add]
      simp
    have hmul := mul_lt_mul_of_pos_left hnum (Real.exp_pos (m 0 : ℝ))
    simpa only [heps, potential] using hmul

theorem bad_indicator_bound {n h : ℕ} (t : Tree n h) {ρ : ℝ}
    (hρ : 0 < ρ) (m : ℕ → ℕ) (w : Mask n) :
    (if good t ρ m w then (0 : ℝ) else 1) ≤ potential t ρ m w := by
  by_cases hg : good t ρ m w
  · simp only [hg, ite_true]
    exact potential_nonneg t hρ m w
  · simp only [hg, ite_false]
    exact (bad_potential t hρ m w hg).le

theorem root_success {n h : ℕ} (t : Tree n h) (hh : 1 ≤ h) {ρ : ℝ}
    (hρ : 0 < ρ) (hρ' : ρ ≤ 1) (m : ℕ → ℕ) (α : ℕ → ℝ)
    (hv : Valid t m α) (hd : treeDisjoint t)
    (hm : ∀ j, j < h → 1 ≤ m j) (hα : ∀ j, j < h → 0 ≤ α j)
    (hratio : ∀ j, j < h → α j / ρ ≤ Real.exp (-50))
    (hsep : ∀ j, j + 1 < h → 3 * m j ≤ m (j + 1)) :
    (3 : ℝ) / 4 ≤ avg ρ (fun w => if good t ρ m w then 1 else 0) := by
  have he := expected_bound t hρ hρ' m α hv hd hm hα hratio hsep
  simp only [show h ≠ 0 by omega, ite_false] at he
  have hb : avg ρ (fun w => if good t ρ m w then (0 : ℝ) else 1) ≤
      Real.exp (-(7 : ℝ) * m 0) :=
    le_trans (avg_mono hρ.le hρ' (bad_indicator_bound t hρ m)) he
  have hsum : avg ρ (fun w => if good t ρ m w then (1 : ℝ) else 0) +
      avg ρ (fun w => if good t ρ m w then (0 : ℝ) else 1) = 1 := by
    rw [← avg_add]
    calc
      _ = avg ρ (fun _ : Mask n => (1 : ℝ)) := by
        apply avg_congr
        intro w
        split_ifs <;> ring
      _ = _ := avg_const _ _
  have hm0 : (1 : ℝ) ≤ m 0 := by exact_mod_cast hm 0 (by omega)
  have hlow : (4 : ℝ) ≤ Real.exp ((7 : ℝ) * m 0) := by
    nlinarith [Real.add_one_le_exp ((7 : ℝ) * m 0)]
  have hprod : Real.exp ((7 : ℝ) * m 0) * Real.exp (-(7 : ℝ) * m 0) = 1 := by
    rw [← Real.exp_add]
    have hzero : (7 : ℝ) * m 0 + -(7 : ℝ) * m 0 = 0 := by ring
    rw [hzero, Real.exp_zero]
  have hsmall := mul_le_mul_of_nonneg_right hlow
    (Real.exp_pos (-(7 : ℝ) * m 0)).le
  rw [hprod] at hsmall
  linarith

theorem sum_subtype_ite {B : Type} [Fintype B] (keep : B → Prop)
    [DecidablePred keep] [Fintype {b // keep b}] (f : B → ℝ) :
    (∑ b : {b // keep b}, f b) = ∑ b, if keep b then f b else 0 := by
  classical
  rw [← Finset.sum_subtype (Finset.univ.filter keep) (by simp) f]
  exact Finset.sum_filter _ _

def keptTotal {B : Type} [Fintype B] (weight : B → ℝ) (keep : B → Prop) : ℝ :=
  ∑ b, if keep b then weight b else 0

theorem sum_selected {B : Type} [Fintype B] (weight : B → ℝ) (keep : B → Prop)
    (hw : ∀ b, 0 ≤ weight b) :
    (∑ b : {b // keep b ∧ 0 < weight b}, weight b) = keptTotal weight keep := by
  calc
    _ = ∑ b, if keep b ∧ 0 < weight b then weight b else 0 :=
      sum_subtype_ite (fun b => keep b ∧ 0 < weight b) weight
    _ = _ := ?_
  apply Finset.sum_congr rfl
  intro b _
  by_cases hk : keep b
  · by_cases hp : 0 < weight b
    · simp [hk, hp]
    · have hz : weight b = 0 := by linarith [hw b]
      simp [hk, hz]
  · simp [hk]

def retainedLaw {B : Type} [Fintype B] (weight : B → ℝ) (keep : B → Prop)
    (hw : ∀ b, 0 ≤ weight b) (hγ : 0 < keptTotal weight keep) :
    Law {b // keep b ∧ 0 < weight b} where
  weight b := weight b / keptTotal weight keep
  positive b := div_pos b.property.2 hγ
  total := by
    rw [← Finset.sum_div, sum_selected weight keep hw]
    exact div_self hγ.ne'

theorem retained_event_bound {B : Type} [Fintype B] (weight : B → ℝ)
    (keep event : B → Prop) (hw : ∀ b, 0 ≤ weight b)
    (hγ : 0 < keptTotal weight keep) :
    (∑ b : {b // keep b ∧ 0 < weight b},
      if event b then retainedLaw weight keep hw hγ b else 0) ≤
      (∑ b, if event b then weight b else 0) / keptTotal weight keep := by
  classical
  change (∑ b : {b // keep b ∧ 0 < weight b},
    if event b then weight b / keptTotal weight keep else 0) ≤ _
  calc
    _ = (∑ b : {b // keep b ∧ 0 < weight b},
        if event b then weight b else 0) / keptTotal weight keep := by
      rw [Finset.sum_div]
      apply Finset.sum_congr rfl
      intro b _
      split_ifs <;> simp
    _ ≤ _ := by
      apply div_le_div_of_nonneg_right _ hγ.le
      calc
        _ = ∑ b, if keep b ∧ 0 < weight b then
            (if event b then weight b else 0) else 0 :=
          sum_subtype_ite (fun b => keep b ∧ 0 < weight b)
            (fun b => if event b then weight b else 0)
        _ ≤ _ := ?_
      apply Finset.sum_le_sum
      intro b _
      split_ifs <;> first | exact le_rfl | exact hw b

theorem delta_pos {m : ℕ} (hm : 1 ≤ m) :
    0 < 1 - Real.exp (-(m : ℝ)) := by
  have hm' : (0 : ℝ) < m := by exact_mod_cast (show 0 < m by omega)
  have h := Real.exp_lt_exp.mpr (show -(m : ℝ) < 0 by linarith)
  simpa using h

theorem conditioning_power {a δ : ℝ} {r : ℕ}
    (ha : 0 ≤ a) (hδ : 0 < δ) (hδ' : δ ≤ 1) (hr : 1 ≤ r) :
    a ^ r / δ ≤ (a / δ) ^ r := by
  have hp : δ⁻¹ ≤ (δ⁻¹) ^ r := by
    simpa only [pow_one] using pow_le_pow_right₀ (inverse_one_le hδ hδ') hr
  simpa only [div_eq_mul_inv, mul_pow] using
    mul_le_mul_of_nonneg_left hp (pow_nonneg ha r)

theorem retained_spread {n : ℕ} {B : Type} [Fintype B] {ρ a : ℝ} {m : ℕ}
    (hρ : 0 < ρ) (ha : 0 ≤ a) (hm : 1 ≤ m)
    (p : Law B) (labels : B → Mask n) (hs : Spread p labels a)
    (w : Mask n) (keep : B → Prop)
    (hg : 1 - Real.exp (-(m : ℝ)) ≤ keptTotal (mass ρ m p labels w) keep) :
    Spread (retainedLaw (mass ρ m p labels w) keep
      (mass_nonneg hρ m p labels w) (lt_of_lt_of_le (delta_pos hm) hg))
      (fun b => diff (labels b) w) (a / (1 - Real.exp (-(m : ℝ)))) := by
  classical
  intro j
  by_cases hj : card j = 0
  · simp only [sub_of_card_zero hj, ite_true, hj, pow_zero]
    exact le_of_eq (Law.total _)
  · have hjpos : 1 ≤ card j := by omega
    have hγ := lt_of_lt_of_le (delta_pos hm) hg
    calc
      _ ≤ (∑ b, if Sub j (diff (labels b) w) then mass ρ m p labels w b else 0) /
          keptTotal (mass ρ m p labels w) keep :=
        retained_event_bound _ keep (fun b => Sub j (diff (labels b) w)) _ hγ
      _ ≤ a ^ card j / keptTotal (mass ρ m p labels w) keep :=
        div_le_div_of_nonneg_right
          (le_trans (mass_spread_raw hρ m p labels w j) (hs j)) hγ.le
      _ ≤ a ^ card j / (1 - Real.exp (-(m : ℝ))) :=
        div_le_div_of_nonneg_left (pow_nonneg ha _) (delta_pos hm) hg
      _ ≤ _ := conditioning_power ha (delta_pos hm)
        (by linarith [Real.exp_pos (-(m : ℝ))]) hjpos

def reduce {n h : ℕ} (t : Tree n h) (ρ : ℝ) (hρ : 0 < ρ)
    (m : ℕ → ℕ) (hm : ∀ j, j < h → 1 ≤ m j) (w : Mask n)
    (hg : good t ρ m w) : Tree n h :=
  match t with
  | .leaf => .leaf
  | @Tree.node _ d B inst p labels children =>
      letI : Fintype B := inst
      let keep : B → Prop := fun b => good (children b) ρ (fun j => m (j + 1)) w
      let wt := mass ρ (m 0) p labels w
      let hw := mass_nonneg hρ (m 0) p labels w
      let hγ : 0 < keptTotal wt keep :=
        lt_of_lt_of_le (delta_pos (hm 0 (Nat.zero_lt_succ d))) hg
      .node (retainedLaw wt keep hw hγ)
        (fun b => diff (labels b) w)
        (fun b => reduce (children b) ρ hρ (fun j => m (j + 1))
          (fun j hj => hm (j + 1) (by omega)) w b.property.1)

theorem reduced_valid {n h : ℕ} (t : Tree n h) {ρ : ℝ} (hρ : 0 < ρ)
    (m : ℕ → ℕ) (hm : ∀ j, j < h → 1 ≤ m j) (w : Mask n)
    (hg : good t ρ m w) (α : ℕ → ℝ) (hv : Valid t m α)
    (hα : ∀ j, j < h → 0 ≤ α j) :
    Valid (reduce t ρ hρ m hm w hg) (fun j => m j / 2)
      (fun j => α j / (1 - Real.exp (-(m j : ℝ)))) := by
  induction t generalizing m α with
  | leaf => trivial
  | @node d B inst p labels children ih =>
    simp only [reduce, Valid]
    refine ⟨?_, ?_, ?_⟩
    · intro b
      exact mass_capacity ρ (m 0) p labels w b b.property.2
    · exact retained_spread hρ (hα 0 (by omega)) (hm 0 (by omega))
        p labels hv.2.1 w _ hg
    · intro b
      exact ih b.val (fun j => m (j + 1))
        (fun j hj => hm (j + 1) (by omega)) b.property.1
        (fun j => α (j + 1)) (hv.2.2 b.val)
        (fun j hj => hα (j + 1) (by omega))

theorem disj_mono_left {n : ℕ} {a l l' : Mask n}
    (hsub : Sub l' l) (hd : Disj l a) : Disj l' a :=
  fun i hi => hd i (hsub i hi)

theorem disj_mono_right {n : ℕ} {a a' l : Mask n}
    (hsub : Sub a' a) (hd : Disj l a) : Disj l a' := by
  intro i hi
  cases hai : a' i
  · rfl
  · have hh := hsub i hai
    have hf := hd i hi
    simp [hh] at hf

theorem treeAvoids_mono {n h : ℕ} (t : Tree n h) {a a' : Mask n}
    (hsub : Sub a' a) (ha : treeAvoids t a) : treeAvoids t a' := by
  induction t with
  | leaf => trivial
  | node p labels children ih =>
    exact ⟨fun b => disj_mono_right hsub (ha.1 b), fun b => ih b (ha.2 b)⟩

theorem reduced_avoids {n h : ℕ} (t : Tree n h) {ρ : ℝ} (hρ : 0 < ρ)
    (m : ℕ → ℕ) (hm : ∀ j, j < h → 1 ≤ m j) (w : Mask n)
    (hg : good t ρ m w) (a : Mask n) (ha : treeAvoids t a) :
    treeAvoids (reduce t ρ hρ m hm w hg) a := by
  induction t generalizing m with
  | leaf => trivial
  | node p labels children ih =>
    simp only [reduce, treeAvoids]
    constructor
    · intro b
      exact disj_mono_left (diff_sub _ _) (ha.1 b.val)
    · intro b
      exact ih b.val _ _ b.property.1 (ha.2 b.val)

theorem reduced_disjoint {n h : ℕ} (t : Tree n h) {ρ : ℝ} (hρ : 0 < ρ)
    (m : ℕ → ℕ) (hm : ∀ j, j < h → 1 ≤ m j) (w : Mask n)
    (hg : good t ρ m w) (hd : treeDisjoint t) :
    treeDisjoint (reduce t ρ hρ m hm w hg) := by
  induction t generalizing m with
  | leaf => trivial
  | node p labels children ih =>
    simp only [reduce, treeDisjoint]
    intro b
    constructor
    · exact treeAvoids_mono _ (diff_sub _ _)
        (reduced_avoids (children b.val) hρ _ _ w b.property.1 _ (hd b.val).1)
    · exact ih b.val _ _ b.property.1 (hd b.val).2

def Path {n h : ℕ} (t : Tree n h) : Type :=
  match t with
  | .leaf => PUnit
  | @Tree.node _ _ B _ _ _ children => (b : B) × Path (children b)

def pathUnion {n h : ℕ} (t : Tree n h) (q : Path t) : Mask n :=
  match t with
  | .leaf => fun _ => false
  | @Tree.node _ _ _ _ _ labels children =>
      union (labels q.1) (pathUnion (children q.1) q.2)

theorem label_recovery {n : ℕ} (a w : Mask n) : Sub a (union w (diff a w)) := by
  intro i hi
  cases hw : w i <;> simp [union, diff, hi, hw]

theorem union_recovery {n : ℕ} {w a a' c c' : Mask n}
    (ha : Sub a (union w a')) (hc : Sub c (union w c')) :
    Sub (union a c) (union w (union a' c')) := by
  intro i hi
  have h : a i = true ∨ c i = true := by simpa [union] using hi
  have hleft := ha i
  have hright := hc i
  simp only [union, Bool.or_eq_true] at hleft hright ⊢
  tauto

theorem reduced_recovery {n h : ℕ} (t : Tree n h) {ρ : ℝ} (hρ : 0 < ρ)
    (m : ℕ → ℕ) (hm : ∀ j, j < h → 1 ≤ m j) (w : Mask n)
    (hg : good t ρ m w) (q : Path (reduce t ρ hρ m hm w hg)) :
    ∃ p : Path t, Sub (pathUnion t p)
      (union w (pathUnion (reduce t ρ hρ m hm w hg) q)) := by
  induction t generalizing m with
  | leaf =>
    exact ⟨PUnit.unit, fun i hi => by simp [pathUnion] at hi⟩
  | node p labels children ih =>
    obtain ⟨b, qchild⟩ := q
    obtain ⟨pchild, hp⟩ := ih b.val _ _ b.property.1 qchild
    refine ⟨⟨b.val, pchild⟩, ?_⟩
    exact union_recovery (label_recovery (labels b.val) w) hp

def procedure {n h : ℕ} (t : Tree n h) (ρ : ℝ) (hρ : 0 < ρ)
    (m : ℕ → ℕ) (hm : ∀ j, j < h → 1 ≤ m j) (w : Mask n) : Option (Tree n h) :=
  if hg : good t ρ m w then some (reduce t ρ hρ m hm w hg) else none

theorem original_ratio {a ρ α : ℝ} (ha : 0 < a) (hα : α ≤ a)
    (hrho : ρ = Real.exp 50 * a) : α / ρ ≤ Real.exp (-50) := by
  have hρ : 0 < ρ := by rw [hrho]; exact mul_pos (Real.exp_pos _) ha
  calc
    α / ρ ≤ a / ρ := div_le_div_of_nonneg_right hα hρ.le
    _ = (Real.exp 50)⁻¹ := by
      rw [hrho]
      field_simp
    _ = _ := (Real.exp_neg (50 : ℝ)).symm

theorem three_separated_reduction {n k : ℕ} (t : Tree n k) (hk : 1 ≤ k)
    (m : ℕ → ℕ) (α : ℕ → ℝ) (a ρ : ℝ)
    (hd : treeDisjoint t) (hv : Valid t m α)
    (hm : ∀ j, j < k → 1 ≤ m j)
    (hsep : ∀ j, j + 1 < k → 3 * m j ≤ m (j + 1))
    (hα : ∀ j, j < k → 0 < α j ∧ α j ≤ a)
    (hrho : ρ = Real.exp 50 * a) (hrho' : ρ < 1) :
    ∃ proc : Mask n → Option (Tree n k),
      (3 : ℝ) / 4 ≤ avg ρ (fun w => if (proc w).isSome then 1 else 0) ∧
      ∀ w t', proc w = some t' →
        Valid t' (fun j => m j / 2)
          (fun j => α j / (1 - Real.exp (-(m j : ℝ)))) ∧
        treeDisjoint t' ∧
        ∀ q : Path t', ∃ p : Path t,
          Sub (pathUnion t p) (union w (pathUnion t' q)) := by
  have ha : 0 < a := lt_of_lt_of_le (hα 0 (by omega)).1 (hα 0 (by omega)).2
  have hρ : 0 < ρ := by rw [hrho]; exact mul_pos (Real.exp_pos _) ha
  have hαnonneg : ∀ j, j < k → 0 ≤ α j := fun j hj => (hα j hj).1.le
  have hratio : ∀ j, j < k → α j / ρ ≤ Real.exp (-50) :=
    fun j hj => original_ratio ha (hα j hj).2 hrho
  refine ⟨procedure t ρ hρ m hm, ?_, ?_⟩
  · have heq : avg ρ (fun w =>
        if (procedure t ρ hρ m hm w).isSome then (1 : ℝ) else 0) =
        avg ρ (fun w => if good t ρ m w then 1 else 0) := by
      apply avg_congr
      intro w
      by_cases hg : good t ρ m w <;> simp [procedure, hg]
    rw [heq]
    exact root_success t hk hρ hrho'.le m α hv hd hm hαnonneg hratio hsep
  · intro w t' hp
    by_cases hg : good t ρ m w
    · have heq : reduce t ρ hρ m hm w hg = t' := by
        simpa [procedure, hg] using hp
      subst t'
      exact ⟨reduced_valid t hρ m hm w hg α hv hαnonneg,
        reduced_disjoint t hρ m hm w hg hd,
        reduced_recovery t hρ m hm w hg⟩
    · simp [procedure, hg] at hp

theorem reduction {n k : ℕ} (t : Tree n k) (hk : 1 ≤ k)
    (m : ℕ → ℕ) (α : ℕ → ℝ) (a ρ : ℝ)
    (hd : treeDisjoint t) (hv : Valid t m α)
    (hm : ∀ j, j < k → 1 ≤ m j)
    (hsep : ∀ j, j + 1 < k → 16 * m j ≤ m (j + 1))
    (hα : ∀ j, j < k → 0 < α j ∧ α j ≤ a)
    (hrho : ρ = Real.exp 50 * a) (hrho' : ρ < 1) :
    ∃ proc : Mask n → Option (Tree n k),
      (3 : ℝ) / 4 ≤ avg ρ (fun w => if (proc w).isSome then 1 else 0) ∧
      ∀ w t', proc w = some t' →
        Valid t' (fun j => m j / 2)
          (fun j => α j / (1 - Real.exp (-(m j : ℝ)))) ∧
        treeDisjoint t' ∧
        ∀ q : Path t', ∃ p : Path t,
          Sub (pathUnion t p) (union w (pathUnion t' q)) := by
  exact three_separated_reduction t hk m α a ρ hd hv hm
    (fun j hj => by have h := hsep j hj; omega) hα hrho hrho'

theorem card_eq_sum {n : ℕ} (a : Mask n) :
    card a = ∑ i : Fin n, if a i then (1 : ℕ) else 0 := by
  induction n with
  | zero => simp [card]
  | succ n ih =>
    simp only [card, Fin.sum_univ_succ, ih, tail]
    congr 1

theorem indexed_plant_density {n : ℕ} {B : Type} [Fintype B] {ρ : ℝ}
    (hρ : ρ ≠ 0) (p : Law B) (labels : B → Mask n) (c : B)
    (f : Mask n → ℝ) :
    avg ρ (fun w => p c * f (union w (labels c))) =
      avg ρ (fun y => score ρ p labels y c * f y) := by
  rw [avg_mul, avg_plant hρ, ← avg_mul]
  apply avg_congr
  intro y
  unfold score
  split_ifs <;> ring

theorem spread_iff_nonempty {n : ℕ} {B : Type} [Fintype B]
    (p : Law B) (labels : B → Mask n) (a : ℝ) :
    Spread p labels a ↔
      ∀ j, 0 < card j →
        (∑ b, if Sub j (labels b) then p b else 0) ≤ a ^ card j := by
  constructor
  · intro hs j _
    exact hs j
  · intro hs j
    by_cases hj : card j = 0
    · simp only [sub_of_card_zero hj, ite_true, hj, pow_zero]
      exact p.total.le
    · exact hs j (Nat.pos_of_ne_zero hj)

def productWeight (ρ : ℝ) : {n : ℕ} → Mask n → ℝ
  | 0, _ => 1
  | _ + 1, w => (if w 0 then ρ else 1 - ρ) * productWeight ρ (tail w)

theorem avg_product_law {n : ℕ} (ρ : ℝ) (f : Mask n → ℝ) :
    avg ρ f = sumMasks (fun w => productWeight ρ w * f w) := by
  induction n with
  | zero => simp [avg, sumMasks, productWeight]
  | succ n ih =>
    simp only [avg, sumMasks, productWeight, cons_zero, tail_cons,
      Bool.false_eq_true, ite_false, ite_true]
    rw [ih, ih]
    rw [← sumMasks_mul, ← sumMasks_mul]
    congr 1 <;> apply sumMasks_congr <;> intro w <;> ring

theorem law_nonempty {B : Type} [Fintype B] (p : Law B) : Nonempty B := by
  by_contra h
  haveI : IsEmpty B := ⟨fun b => h ⟨b⟩⟩
  have ht := p.total
  simp at ht

theorem path_nonempty {n h : ℕ} (t : Tree n h) : Nonempty (Path t) := by
  induction t with
  | leaf => exact ⟨PUnit.unit⟩
  | node p labels children ih =>
    obtain ⟨b⟩ := law_nonempty p
    obtain ⟨q⟩ := ih b
    exact ⟨⟨b, q⟩⟩

def pathLabels {n h : ℕ} (t : Tree n h) (q : Path t) : List (Mask n) :=
  match t with
  | .leaf => []
  | @Tree.node _ _ _ _ _ labels children =>
      labels q.1 :: pathLabels (children q.1) q.2

theorem disj_symm {n : ℕ} {a b : Mask n} (hd : Disj a b) : Disj b a := by
  intro i hi
  cases hai : a i
  · rfl
  · have hf := hd i hai
    simp [hi] at hf

theorem treeAvoids_paths {n h : ℕ} (t : Tree n h) (a : Mask n) :
    treeAvoids t a ↔ ∀ q : Path t, ∀ l ∈ pathLabels t q, Disj l a := by
  induction t with
  | leaf => simp [treeAvoids, pathLabels]
  | node p labels children ih =>
    constructor
    · intro ha q l hl
      obtain ⟨b, q⟩ := q
      simp only [pathLabels, List.mem_cons] at hl
      obtain rfl | hl := hl
      · exact ha.1 b
      · exact (ih b).mp (ha.2 b) q l hl
    · intro ha
      constructor
      · intro b
        obtain ⟨q⟩ := path_nonempty (children b)
        exact ha ⟨b, q⟩ (labels b) (by simp [pathLabels])
      · intro b
        apply (ih b).mpr
        intro q l hl
        exact ha ⟨b, q⟩ l (by simp [pathLabels, hl])

theorem treeDisjoint_iff_pathwise {n h : ℕ} (t : Tree n h) :
    treeDisjoint t ↔
      ∀ q : Path t, (pathLabels t q).Pairwise (fun a b => Disj a b) := by
  induction t with
  | leaf => simp [treeDisjoint, pathLabels]
  | node p labels children ih =>
    constructor
    · intro hd q
      obtain ⟨b, q⟩ := q
      apply List.pairwise_cons.mpr
      constructor
      · intro l hl
        exact disj_symm ((treeAvoids_paths (children b) (labels b)).mp (hd b).1 q l hl)
      · exact (ih b).mp (hd b).2 q
    · intro hd b
      constructor
      · apply (treeAvoids_paths (children b) (labels b)).mpr
        intro q l hl
        exact disj_symm ((List.pairwise_cons.mp (hd ⟨b, q⟩)).1 l hl)
      · exact (ih b).mpr (fun q => (List.pairwise_cons.mp (hd ⟨b, q⟩)).2)

theorem pathwise_reduction {n k : ℕ} (t : Tree n k) (hk : 1 ≤ k)
    (m : ℕ → ℕ) (α : ℕ → ℝ) (a ρ : ℝ)
    (hd : ∀ q : Path t, (pathLabels t q).Pairwise (fun a b => Disj a b))
    (hv : Valid t m α)
    (hm : ∀ j, j < k → 1 ≤ m j)
    (hsep : ∀ j, j + 1 < k → 16 * m j ≤ m (j + 1))
    (hα : ∀ j, j < k → 0 < α j ∧ α j ≤ a)
    (hrho : ρ = Real.exp 50 * a) (hrho' : ρ < 1) :
    ∃ proc : Mask n → Option (Tree n k),
      (3 : ℝ) / 4 ≤ avg ρ (fun w => if (proc w).isSome then 1 else 0) ∧
      ∀ w t', proc w = some t' →
        Valid t' (fun j => m j / 2)
          (fun j => α j / (1 - Real.exp (-(m j : ℝ)))) ∧
        (∀ q : Path t', (pathLabels t' q).Pairwise (fun a b => Disj a b)) ∧
        ∀ q : Path t', ∃ p : Path t,
          Sub (pathUnion t p) (union w (pathUnion t' q)) := by
  obtain ⟨proc, hp, hout⟩ := reduction t hk m α a ρ
    ((treeDisjoint_iff_pathwise t).mpr hd) hv hm hsep hα hrho hrho'
  refine ⟨proc, hp, ?_⟩
  intro w t' heq
  obtain ⟨hv', hd', hr'⟩ := hout w t' heq
  exact ⟨hv', (treeDisjoint_iff_pathwise t').mp hd', hr'⟩

theorem pathwise_three_reduction {n k : ℕ} (t : Tree n k) (hk : 1 ≤ k)
    (m : ℕ → ℕ) (α : ℕ → ℝ) (a ρ : ℝ)
    (hd : ∀ q : Path t, (pathLabels t q).Pairwise (fun a b => Disj a b))
    (hv : Valid t m α)
    (hm : ∀ j, j < k → 1 ≤ m j)
    (hsep : ∀ j, j + 1 < k → 3 * m j ≤ m (j + 1))
    (hα : ∀ j, j < k → 0 < α j ∧ α j ≤ a)
    (hrho : ρ = Real.exp 50 * a) (hrho' : ρ < 1) :
    ∃ proc : Mask n → Option (Tree n k),
      (3 : ℝ) / 4 ≤ avg ρ (fun w => if (proc w).isSome then 1 else 0) ∧
      ∀ w t', proc w = some t' →
        Valid t' (fun j => m j / 2)
          (fun j => α j / (1 - Real.exp (-(m j : ℝ)))) ∧
        (∀ q : Path t', (pathLabels t' q).Pairwise (fun a b => Disj a b)) ∧
        ∀ q : Path t', ∃ p : Path t,
          Sub (pathUnion t p) (union w (pathUnion t' q)) := by
  obtain ⟨proc, hp, hout⟩ := three_separated_reduction t hk m α a ρ
    ((treeDisjoint_iff_pathwise t).mpr hd) hv hm hsep hα hrho hrho'
  refine ⟨proc, hp, ?_⟩
  intro w t' heq
  obtain ⟨hv', hd', hr'⟩ := hout w t' heq
  exact ⟨hv', (treeDisjoint_iff_pathwise t').mp hd', hr'⟩

#print axioms TreeReduction.reduction
#print axioms TreeReduction.pathwise_reduction
#print axioms TreeReduction.pathwise_three_reduction
#print axioms TreeReduction.expected_bound
#print axioms TreeReduction.local_failure
#print axioms TreeReduction.distortion
#print axioms TreeReduction.potential_avoids
#print axioms TreeReduction.expected_recurrence
#print axioms TreeReduction.reduced_valid
#print axioms TreeReduction.reduced_recovery

end TreeReduction
