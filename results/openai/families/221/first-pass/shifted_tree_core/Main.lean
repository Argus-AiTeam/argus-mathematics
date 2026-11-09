import Mathlib

open scoped BigOperators

namespace ShiftedTree

set_option autoImplicit false

inductive Tree where
  | leaf (isProtected : Bool)
  | node (arity : ℕ) (children : Fin arity → Tree)

def Full (L d : ℕ) : Tree → Prop
  | .leaf _ => d = L
  | .node n f => d < L ∧ 0 < n ∧ ∀ i, Full L (d + 1) (f i)

def unused : Tree → Prop
  | .leaf p => p = false
  | .node _ f => ∀ i, unused (f i)

def leaves : Tree → ℕ
  | .leaf _ => 1
  | .node _ f => ∑ i, leaves (f i)

def oldLeaves : Tree → ℕ
  | .leaf p => if p then 0 else 1
  | .node _ f => ∑ i, oldLeaves (f i)

noncomputable def freshSigned (m : ℕ → ℝ) (d : ℕ) : Tree → ℝ
  | .leaf _ => 0
  | .node n f =>
      (m d - (n : ℝ) * m (d + 1)) + ∑ i, freshSigned m (d + 1) (f i)

noncomputable def choiceSigned (m : ℕ → ℝ) (d : ℕ) (t : Tree) : ℝ :=
  (oldLeaves t : ℝ) + freshSigned m d t

noncomputable def freshAbsolute (m : ℕ → ℝ) (d : ℕ) : Tree → ℝ
  | .leaf _ => 0
  | .node n f =>
      |m d - (n : ℝ) * m (d + 1)| + ∑ i, freshAbsolute m (d + 1) (f i)

theorem oldLeaves_le (t : Tree) : oldLeaves t ≤ leaves t := by
  induction t with
  | leaf p => cases p <;> simp [oldLeaves, leaves]
  | node n f ih =>
      exact Finset.sum_le_sum (fun i _ => ih i)

theorem unused_oldLeaves (t : Tree) (h : unused t) : oldLeaves t = leaves t := by
  induction t with
  | leaf p => simp_all [unused, oldLeaves, leaves]
  | node n f ih =>
      exact Finset.sum_congr rfl (fun i _ => ih i (h i))

theorem full_fresh_signed (m : ℕ → ℝ) (L : ℕ) (hm : m L = 1)
    (t : Tree) : ∀ d, Full L d t →
      freshSigned m d t = m d - (leaves t : ℝ) := by
  induction t with
  | leaf p =>
      intro d h
      simp only [Full] at h
      subst d
      simp [freshSigned, leaves, hm]
  | node n f ih =>
      intro d h
      have hs : ∀ i, freshSigned m (d + 1) (f i) =
          m (d + 1) - (leaves (f i) : ℝ) :=
        fun i => ih i (d + 1) (h.2.2 i)
      simp only [freshSigned, leaves, hs, Finset.sum_sub_distrib,
        Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul,
        Nat.cast_sum]
      ring

theorem reference_free_total (m : ℕ → ℝ) (L d : ℕ) (hm : m L = 1)
    (t : Tree) (hf : Full L d t) (hu : unused t) :
    choiceSigned m d t = m d := by
  rw [choiceSigned, unused_oldLeaves t hu, full_fresh_signed m L hm t d hf]
  ring

theorem reference_total (m : ℕ → ℝ) (L d n : ℕ) (hm : m L = 1)
    (f : Fin n → Tree) (refs : Finset (Fin n))
    (hf : ∀ i, Full L (d + 1) (f i))
    (hu : ∀ i ∈ Finset.univ \ refs, unused (f i)) :
    (m d - (n : ℝ) * m (d + 1)) +
        ∑ i ∈ Finset.univ \ refs, choiceSigned m (d + 1) (f i) =
      m d - (refs.card : ℝ) * m (d + 1) := by
  have hs : (∑ i ∈ Finset.univ \ refs, choiceSigned m (d + 1) (f i)) =
      ((Finset.univ \ refs).card : ℝ) * m (d + 1) := by
    calc
      _ = ∑ _i ∈ Finset.univ \ refs, m (d + 1) :=
        Finset.sum_congr rfl (fun i hi =>
          reference_free_total m L (d + 1) hm (f i) (hf i) (hu i hi))
      _ = _ := by simp
  have hc : ((Finset.univ \ refs).card : ℝ) + (refs.card : ℝ) = n := by
    have hc' : (Finset.univ \ refs).card + refs.card = n := by
      simpa using Finset.card_sdiff_add_card_eq_card (Finset.subset_univ refs)
    exact_mod_cast hc'
  rw [hs]
  rw [← hc]
  ring

theorem fresh_absolute (m : ℕ → ℝ) (L : ℕ) (hm : m L = 1)
    (hnonneg : ∀ i, 0 ≤ m i)
    (hmono : ∀ d < L, m d ≤ m (d + 1)) (t : Tree) :
    ∀ d, Full L d t →
      freshAbsolute m d t = (leaves t : ℝ) - m d := by
  induction t with
  | leaf p =>
      intro d h
      simp only [Full] at h
      subst d
      simp [freshAbsolute, leaves, hm]
  | node n f ih =>
      intro d h
      have hn : (1 : ℝ) ≤ n := by exact_mod_cast h.2.1
      have hg : m d - (n : ℝ) * m (d + 1) ≤ 0 := by
        have := mul_le_mul_of_nonneg_right hn (hnonneg (d + 1))
        linarith [hmono d h.1]
      have hs : ∀ i, freshAbsolute m (d + 1) (f i) =
          (leaves (f i) : ℝ) - m (d + 1) :=
        fun i => ih i (d + 1) (h.2.2 i)
      simp only [freshAbsolute, leaves, abs_of_nonpos hg, hs,
        Finset.sum_sub_distrib, Finset.sum_const, Finset.card_univ,
        Fintype.card_fin, nsmul_eq_mul, Nat.cast_sum]
      ring

theorem unrestricted_absolute_le (m : ℕ → ℝ) (L : ℕ)
    (hm : m L = 1) (hzero : m 0 = 0)
    (hnonneg : ∀ i, 0 ≤ m i)
    (hmono : ∀ d < L, m d ≤ m (d + 1))
    (t : Tree) (hf : Full L 0 t) :
    (oldLeaves t : ℝ) + freshAbsolute m 0 t ≤ 2 * (leaves t : ℝ) := by
  rw [fresh_absolute m L hm hnonneg hmono t 0 hf, hzero]
  have ho : (oldLeaves t : ℝ) ≤ leaves t := by exact_mod_cast oldLeaves_le t
  linarith

theorem leaves_positive (L : ℕ) (t : Tree) :
    ∀ d, Full L d t → 0 < leaves t := by
  induction t with
  | leaf p => simp [leaves]
  | node n f ih =>
      intro d h
      have hs : (∑ _i : Fin n, 1) ≤ ∑ i, leaves (f i) :=
        Finset.sum_le_sum (fun i _ => ih i (d + 1) (h.2.2 i))
      simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin,
        smul_eq_mul, mul_one] at hs
      exact lt_of_lt_of_le h.2.1 hs

def unaryAt : ℕ → Tree → ℕ
  | 0, .leaf _ => 0
  | 0, .node n _ => if n = 1 then 1 else 0
  | _ + 1, .leaf _ => 0
  | r + 1, .node _ f => ∑ i, unaryAt r (f i)

theorem unaryAt_le (L : ℕ) (t : Tree) :
    ∀ d, Full L d t → ∀ r, unaryAt r t ≤ leaves t := by
  induction t with
  | leaf p => intro d h r; cases r <;> simp [unaryAt, leaves]
  | node n f ih =>
      intro d h r
      cases r with
      | zero =>
          simp only [unaryAt]
          split
          · exact leaves_positive L (.node n f) d h
          · exact Nat.zero_le _
      | succ r =>
          exact Finset.sum_le_sum (fun i _ => ih i (d + 1) (h.2.2 i) r)

theorem charged_row_le (L : ℕ) (t : Tree) (hf : Full L 0 t)
    (D : Finset ℕ) (δ : ℝ) (hδ : 0 ≤ δ) :
    (∑ r ∈ D, (unaryAt r t : ℝ) * δ) ≤
      (D.card : ℝ) * (leaves t : ℝ) * δ := by
  calc
    _ ≤ ∑ _r ∈ D, (leaves t : ℝ) * δ :=
      Finset.sum_le_sum (fun r _ =>
        mul_le_mul_of_nonneg_right (by exact_mod_cast unaryAt_le L t 0 hf r) hδ)
    _ = _ := by simp [mul_assoc]

inductive History : ℕ → Type where
  | done : History 0
  | step {k : ℕ} (arity : ℕ) (weight : Fin arity → ℝ)
      (charged : Fin arity → Bool) (next : Fin arity → History k) :
      History (k + 1)

noncomputable def mass : {k : ℕ} → History k → ℝ
  | _, .done => 1
  | _, .step _ w _ f => ∑ i, w i * mass (f i)

def constantRows : {k : ℕ} → History k → (Fin k → ℝ) → Prop
  | _, .done, _ => True
  | _, .step _ w _ f, a =>
      (∑ i, w i) = a 0 ∧ ∀ i, constantRows (f i) (fun j => a j.succ)

theorem iterated_reference_product {k : ℕ} (h : History k) :
    ∀ a, constantRows h a → mass h = ∏ j, a j := by
  induction h with
  | done => intro a ha; simp [mass]
  | step n w charged f ih =>
      intro a ha
      simp only [constantRows] at ha
      simp only [mass]
      simp_rw [fun i => ih i (fun j => a j.succ) (ha.2 i)]
      rw [← Finset.sum_mul, ha.1, Fin.prod_univ_succ]

def enoughCharges : {k : ℕ} → History k → ℕ → Prop
  | _, .done, b => b = 0
  | _, .step _ _ charged f, b =>
      ∀ i, enoughCharges (f i) (b - if charged i then 1 else 0)

def boundedRows (δ C : ℝ) : {k : ℕ} → History k → Prop
  | _, .done => True
  | _, .step _ w charged f =>
      (∀ i, 0 ≤ w i) ∧
      (∑ i, if charged i then w i / δ else w i) ≤ C ∧
      ∀ i, boundedRows δ C (f i)

theorem charge_power (δ w : ℝ) (hδ : 0 < δ) (hδone : δ ≤ 1)
    (hw : 0 ≤ w) (b : ℕ) (charged : Bool) :
    w * δ ^ (b - if charged then 1 else 0) ≤
      (if charged then w / δ else w) * δ ^ b := by
  cases charged with
  | false => simp
  | true =>
      cases b with
      | zero =>
          simp only [↓reduceIte, Nat.zero_sub, pow_zero, mul_one]
          apply (le_div_iff₀ hδ).2
          nlinarith
      | succ b =>
          simp only [↓reduceIte, Nat.add_sub_cancel, pow_succ]
          apply le_of_eq
          field_simp

theorem charging_history_bound (δ C : ℝ) (hδ : 0 < δ)
    (hδone : δ ≤ 1) (hC : 0 ≤ C) {k : ℕ} (h : History k) :
    ∀ b, boundedRows δ C h → enoughCharges h b →
      mass h ≤ C ^ k * δ ^ b := by
  induction h with
  | done =>
      intro b hr he
      simp only [enoughCharges] at he
      subst b
      simp [mass]
  | @step k n w charged f ih =>
      intro b hr he
      have hp : 0 ≤ C ^ k := pow_nonneg hC k
      have hd : 0 ≤ δ ^ b := pow_nonneg hδ.le b
      calc
        mass (.step n w charged f)
            ≤ ∑ i, w i * (C ^ k * δ ^ (b - if charged i then 1 else 0)) := by
              exact Finset.sum_le_sum (fun i _ =>
                mul_le_mul_of_nonneg_left
                  (ih i _ (hr.2.2 i) (he i)) (hr.1 i))
        _ ≤ ∑ i, (if charged i then w i / δ else w i) * (C ^ k * δ ^ b) := by
              apply Finset.sum_le_sum
              intro i hi
              have hc := mul_le_mul_of_nonneg_left
                (charge_power δ (w i) hδ hδone (hr.1 i) b (charged i)) hp
              nlinarith
        _ = (∑ i, if charged i then w i / δ else w i) * (C ^ k * δ ^ b) := by
              rw [Finset.sum_mul]
        _ ≤ C * (C ^ k * δ ^ b) :=
              mul_le_mul_of_nonneg_right hr.2.1 (mul_nonneg hp hd)
        _ = C ^ (k + 1) * δ ^ b := by rw [pow_succ]; ring

theorem normalized_row_bound (δ s t U M : ℝ) (hδ : 0 < δ)
    (hU : U ≤ 2 * s) (hM : M ≤ t * s * δ) :
    U + M / δ ≤ (2 + t) * s := by
  have hm : M / δ ≤ t * s := (div_le_iff₀ hδ).2 hM
  linarith

theorem retained_class_factor {α : Type*} [Fintype α]
    (c : α → ℝ) (g : ℝ) :
    (∑ h, c h * g) = (∑ h, c h) * g := by
  rw [Finset.sum_mul]

theorem prune_normalized_kernel {α β : Type*} [Fintype β]
    (p : α → β → ℝ) (hnorm : ∀ x, ∑ y, p x y = 1) (g : α → ℝ) (x : α) :
    (∑ y, p x y * g x) = g x := by
  rw [← Finset.sum_mul, hnorm, one_mul]

theorem prefix_class_coefficients (δ J : ℝ) (d r : ℕ) :
    (-δ * J) -
        (-((d : ℝ) + 2) * δ * J + (r : ℝ) * (-δ * J)) =
      ((d : ℝ) + (r : ℝ) + 1) * δ * J := by
  ring

theorem multiway_factor_lower (δ η x : ℝ) (hδ : 0 < δ)
    (hη : 0 < η) (hx : η ≤ x) (j : ℕ) :
    η ≤ |x - ((j : ℝ) + 2) * (x + δ)| := by
  have hj : 0 ≤ (j : ℝ) := Nat.cast_nonneg j
  have hx0 : 0 ≤ x := le_trans hη.le hx
  have hprod : 0 ≤ (j : ℝ) * (x + δ) := mul_nonneg hj (by linarith)
  have hneg : x - ((j : ℝ) + 2) * (x + δ) ≤ 0 := by nlinarith
  rw [abs_of_nonpos hneg]
  nlinarith

noncomputable def branchFactor (δ x : ℝ) (extra : ℕ) : ℝ :=
  (-δ) * ∏ j : Fin extra, (x - ((j.val : ℝ) + 2) * (x + δ))

theorem branch_factor_bound (δ η x : ℝ) (hδ : 0 < δ)
    (hη : 0 < η) (hx : η ≤ x) (extra : ℕ) :
    δ * η ^ extra ≤ |branchFactor δ x extra| := by
  have hp : (∏ _j : Fin extra, η) ≤
      ∏ j : Fin extra, |x - ((j.val : ℝ) + 2) * (x + δ)| := by
    exact Finset.prod_le_prod (fun _ _ => hη.le)
      (fun j _ => multiway_factor_lower δ η x hδ hη hx j.val)
  simpa [branchFactor, abs_mul, abs_of_pos hδ, Finset.abs_prod] using
    mul_le_mul_of_nonneg_left hp hδ.le

theorem full_denominator_bound {V : Type*} [Fintype V]
    (δ η : ℝ) (hδ : 0 < δ) (hη : 0 < η)
    (x : V → ℝ) (extra : V → ℕ) (hx : ∀ v, η ≤ x v) :
    δ ^ Fintype.card V * (∏ v, η ^ extra v) ≤
      |∏ v, branchFactor δ (x v) (extra v)| := by
  have hp : (∏ v, δ * η ^ extra v) ≤
      ∏ v, |branchFactor δ (x v) (extra v)| := by
    exact Finset.prod_le_prod
      (fun v _ => mul_nonneg hδ.le (pow_nonneg hη.le _))
      (fun v _ => branch_factor_bound δ η (x v) hδ hη (hx v) (extra v))
  simpa [Finset.prod_mul_distrib, Finset.abs_prod] using hp

theorem normalized_absolute_bound (A J D B C : ℝ) (hD : 0 < D)
    (hB : 0 < B) (hC : 0 ≤ C)
    (hA : A ≤ C * D) (hJ : D * B ≤ |J|) :
    A / |J| ≤ C / B := by
  have hJpos : 0 < |J| := lt_of_lt_of_le (mul_pos hD hB) hJ
  apply (div_le_div_iff₀ hJpos hB).2
  calc
    A * B ≤ (C * D) * B := mul_le_mul_of_nonneg_right hA hB.le
    _ = C * (D * B) := by ring
    _ ≤ C * |J| := mul_le_mul_of_nonneg_left hJ hC

structure Move (State : Type*) where
  update : State → State
  weight : State → ℝ

noncomputable def evaluate {State : Type*} : List (Move State) → State → State × ℝ
  | [], s => (s, 1)
  | m :: rest, s =>
      let result := evaluate rest (m.update s)
      (result.1, m.weight s * result.2)

def stationaryOld {State : Type*} : Move State := ⟨id, fun _ => 1⟩

theorem commute_old_selection {State : Type*}
    (before after : List (Move State)) (s : State) :
    evaluate (before ++ stationaryOld :: after) s =
      evaluate (before ++ after) s := by
  induction before generalizing s with
  | nil => simp [evaluate, stationaryOld]
  | cons m rest ih => simp [evaluate, ih]

theorem absolute_from_reuse_normal_form {H : Type*} [Fintype H]
    (c : H → ℝ) (P : Finset H) (K T : ℝ)
    (hK : 0 ≤ K) (hpos : ∀ h ∈ P, c h = K)
    (hneg : ∀ h ∉ P, c h ≤ 0) (htotal : (∑ h, c h) = T * K) :
    (∑ h, |c h|) = (2 * (P.card : ℝ) - T) * K := by
  classical
  have hp : (∑ h ∈ P, c h) = (P.card : ℝ) * K := by
    calc
      _ = ∑ _h ∈ P, K := Finset.sum_congr rfl hpos
      _ = _ := by simp
  have hi : ∀ h, |c h| = 2 * (if h ∈ P then c h else 0) - c h := by
    intro h
    by_cases hmem : h ∈ P
    · rw [if_pos hmem, hpos h hmem, abs_of_nonneg hK]
      ring
    · rw [if_neg hmem, abs_of_nonpos (hneg h hmem)]
      ring
  simp_rw [hi]
  rw [Finset.sum_sub_distrib, ← Finset.mul_sum]
  have hs : (∑ h, if h ∈ P then c h else 0) = ∑ h ∈ P, c h := by simp
  rw [hs, hp, htotal]
  ring

theorem reference_free_exact_absolute {H : Type*} [Fintype H]
    (c : H → ℝ) (P : Finset H) (q r : ℕ) (K x : ℝ)
    (hK : 0 ≤ K) (hcard : P.card = q * r)
    (hpos : ∀ h ∈ P, c h = K) (hneg : ∀ h ∉ P, c h ≤ 0)
    (htotal : (∑ h, c h) = x * K) :
    (∑ h, |c h|) = (2 * (q : ℝ) * (r : ℝ) - x) * K := by
  rw [absolute_from_reuse_normal_form c P K x hK hpos hneg htotal, hcard]
  push_cast
  ring

theorem shifted_exact_absolute {H : Type*} [Fintype H]
    (c : H → ℝ) (P : Finset H) (s : ℕ) (δ J : ℝ)
    (hJ : 0 < J) (hcard : P.card = s * s)
    (hpos : ∀ h ∈ P, c h = J) (hneg : ∀ h ∉ P, c h ≤ 0)
    (htotal : (∑ h, c h) = -δ * J) :
    (∑ h, |c h|) / J = 2 * (s : ℝ) ^ 2 + δ := by
  have ht : (∑ h, c h) = (-δ) * J := htotal
  rw [absolute_from_reuse_normal_form c P J (-δ) hJ.le hpos hneg ht, hcard]
  push_cast
  field_simp; ring

theorem uniform_fresh_negative (δ : ℝ) (hδ : 0 < δ)
    (d n : ℕ) (hn : 0 < n) :
    (d : ℝ) * δ - (n : ℝ) * ((d : ℝ) + 1) * δ < 0 := by
  have hn' : (1 : ℝ) ≤ n := by exact_mod_cast hn
  have hd : 0 ≤ (d : ℝ) + 1 := by positivity
  have hh : (d : ℝ) + 1 ≤ (n : ℝ) * ((d : ℝ) + 1) := by
    simpa using mul_le_mul_of_nonneg_right hn' hd
  have hm := mul_le_mul_of_nonneg_right hh hδ.le
  nlinarith

end ShiftedTree
