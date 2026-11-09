import Mathlib

open scoped BigOperators

namespace BackwardCharge

noncomputable section

attribute [local instance] Classical.propDecidable

theorem invariant_fiber_average
    {T C : Type*} [Fintype T] [Fintype C] [AddGroup C] [DecidableEq C]
    (color : T → C) (weight : T → ℝ) (move : C → T ≃ T)
    (hcolor : ∀ c t, color (move c t) = c + color t)
    (hweight : ∀ c t, weight (move c t) = weight t) :
    (∑ t, if color t = 0 then weight t else 0) =
      (∑ t, weight t) / (Fintype.card C : ℝ) := by
  classical
  have hfiber (c : C) :
      (∑ t, if color t = c then weight t else 0) =
        ∑ t, if color t = 0 then weight t else 0 := by
    calc
      _ = ∑ t, if color (move c t) = c then weight (move c t) else 0 :=
        (Equiv.sum_comp (move c) _).symm
      _ = _ := by simp_rw [hcolor, hweight]; simp
  have htotal :
      (∑ t, weight t) =
        (Fintype.card C : ℝ) *
          (∑ t, if color t = 0 then weight t else 0) := by
    calc
      _ = ∑ t, ∑ c, if color t = c then weight t else 0 := by simp
      _ = ∑ c, ∑ t, if color t = c then weight t else 0 :=
        Finset.sum_comm
      _ = _ := by simp_rw [hfiber]; simp
  have hn : (Fintype.card C : ℝ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  apply (eq_div_iff hn).2
  simpa [mul_comm] using htotal.symm

theorem lift_individual_digits
    {T I : Type*} [Fintype I] [DecidableEq I]
    {D : I → Type*} [∀ i, AddCommGroup (D i)]
    (color : T → ∀ i, D i) (weight : T → ℝ)
    (move : ∀ i, D i → T ≃ T)
    (hcolor : ∀ i d t, color (move i d t) = Pi.single i d + color t)
    (hweight : ∀ i d t, weight (move i d t) = weight t)
    (target : ∀ i, D i) :
    ∃ e : T ≃ T,
      (∀ t, color (e t) = target + color t) ∧
      (∀ t, weight (e t) = weight t) := by
  classical
  have aux (s : Finset I) :
      ∃ e : T ≃ T,
        (∀ t, color (e t) =
          (∑ i ∈ s, Pi.single i (target i)) + color t) ∧
        (∀ t, weight (e t) = weight t) := by
    induction s using Finset.induction_on with
    | empty =>
        refine ⟨Equiv.refl T, ?_, ?_⟩ <;> simp
    | @insert i s hi ih =>
        rcases ih with ⟨e, he, hw⟩
        refine ⟨e.trans (move i (target i)), ?_, ?_⟩
        · intro t
          change color (move i (target i) (e t)) = _
          rw [hcolor, he, Finset.sum_insert hi]
          simp only [add_assoc]
        · intro t
          change weight (move i (target i) (e t)) = weight t
          rw [hweight, hw]
  rcases aux Finset.univ with ⟨e, he, hw⟩
  refine ⟨e, ?_, hw⟩
  have hs : (∑ i, Pi.single i (target i)) = target := by
    ext i
    simp
  intro t
  simpa only [hs] using he t

theorem digit_average
    {T I : Type*} [Fintype T] [Fintype I] [DecidableEq I]
    {D : I → Type*} [∀ i, AddCommGroup (D i)] [∀ i, Fintype (D i)]
    (color : T → ∀ i, D i) (weight : T → ℝ)
    (move : ∀ i, D i → T ≃ T)
    (hcolor : ∀ i d t, color (move i d t) = Pi.single i d + color t)
    (hweight : ∀ i d t, weight (move i d t) = weight t) :
    (∑ t, if color t = 0 then weight t else 0) =
      (∑ t, weight t) / (Fintype.card (∀ i, D i) : ℝ) := by
  classical
  choose moves hc hw using lift_individual_digits color weight move hcolor hweight
  exact invariant_fiber_average color weight moves hc hw

theorem residue_space_card
    {I : Type*} [Fintype I] [DecidableEq I] (q : I → ℕ) [∀ i, NeZero (q i)] :
    Fintype.card (∀ i, ZMod (q i)) = ∏ i, q i := by
  simp [Fintype.card_pi]

theorem unit_digit_lift {q : ℕ} [NeZero q] (u : (ZMod q)ˣ) (digit : ZMod q) :
    ∃ k : ZMod q, (u : ZMod q) * k = digit := by
  refine ⟨(↑u⁻¹ : ZMod q) * digit, ?_⟩
  simp [← mul_assoc]

theorem raw_minus_update
    {A : Type*} [Fintype A] (w q : ℝ) (m indicator : A → ℝ) :
    (w - ∑ a, m a) * (1 - q) + (∑ a, m a * (1 - indicator a)) =
      (1 - q) * w - ((∑ a, m a * indicator a) - q * ∑ a, m a) := by
  simp_rw [mul_sub, mul_one, Finset.sum_sub_distrib]
  ring

theorem raw_minus_nonnegative
    {A : Type*} [Fintype A] (w q : ℝ) (m indicator : A → ℝ)
    (hm : ∀ a, 0 ≤ m a) (hcap : (∑ a, m a) ≤ w)
    (hq : q ≤ 1) (hi : ∀ a, indicator a ≤ 1) :
    0 ≤ (w - ∑ a, m a) * (1 - q) +
      (∑ a, m a * (1 - indicator a)) := by
  exact add_nonneg
    (mul_nonneg (sub_nonneg.mpr hcap) (sub_nonneg.mpr hq))
    (Finset.sum_nonneg fun a _ => mul_nonneg (hm a) (sub_nonneg.mpr (hi a)))

theorem linked_success_mean
    {G A : Type*} [Fintype G] [Fintype A]
    (q : ℝ) (m : A → ℝ) (indicator : A → G → ℝ)
    (hbalanced : ∀ a, (∑ g, indicator a g) = (Fintype.card G : ℝ) * q) :
    (∑ g, ∑ a, m a * indicator a g) =
      (Fintype.card G : ℝ) * q * (∑ a, m a) := by
  rw [Finset.sum_comm]
  simp_rw [← Finset.mul_sum, hbalanced]
  rw [← Finset.sum_mul]
  ring

theorem correlated_covariance
    {G : Type*} [Fintype G]
    (q wx wy mx my : ℝ) (dx dy : G → ℝ)
    (hx : (∑ g, dx g) = (Fintype.card G : ℝ) * q * mx)
    (hy : (∑ g, dy g) = (Fintype.card G : ℝ) * q * my) :
    (∑ g, ((1 - q) * wx - (dx g - q * mx)) *
      ((1 - q) * wy - (dy g - q * my))) =
      (Fintype.card G : ℝ) * ((1 - q) ^ 2 * wx * wy) +
        (∑ g, dx g * dy g) -
        (Fintype.card G : ℝ) * q ^ 2 * mx * my := by
  let ax := (1 - q) * wx + q * mx
  let ay := (1 - q) * wy + q * my
  have he (g : G) :
      ((1 - q) * wx - (dx g - q * mx)) *
        ((1 - q) * wy - (dy g - q * my)) =
      ax * ay - ax * dy g - ay * dx g + dx g * dy g := by
    dsimp [ax, ay]
    ring
  simp_rw [he, Finset.sum_add_distrib, Finset.sum_sub_distrib]
  simp only [← Finset.mul_sum, Finset.sum_const, nsmul_eq_mul]
  rw [hx, hy]
  dsimp [ax, ay]
  ring

theorem correlated_step_bound
    {G : Type*} [Fintype G]
    (q wx wy mx my : ℝ) (dx dy : G → ℝ)
    (hx : (∑ g, dx g) = (Fintype.card G : ℝ) * q * mx)
    (hy : (∑ g, dy g) = (Fintype.card G : ℝ) * q * my)
    (hmx : 0 ≤ mx) (hmy : 0 ≤ my) :
    (∑ g, ((1 - q) * wx - (dx g - q * mx)) *
      ((1 - q) * wy - (dy g - q * my))) ≤
      (Fintype.card G : ℝ) * ((1 - q) ^ 2 * wx * wy) +
        (∑ g, dx g * dy g) := by
  rw [correlated_covariance q wx wy mx my dx dy hx hy]
  have h : 0 ≤ (Fintype.card G : ℝ) * q ^ 2 * mx * my := by positivity
  linarith

theorem matched_currency
    (probability residual weight q success : ℝ) :
    probability * (residual * weight) * q +
        probability * (residual * weight) * (1 - q) =
      probability * (residual * weight) * success +
        probability * (residual * weight) * (1 - success) := by
  ring

theorem residual_mask_transition
    (probability residual weight q : ℝ) :
    (q * residual * probability) * weight =
      probability * (residual * weight) * q := by
  ring

def broadKernel {F K : Type*} (outer : F → K) (probability : K → ℝ)
    (f g : F) : ℝ :=
  probability (outer f) * probability (outer g)

def clippingKernel {F K : Type*} [DecidableEq K]
    (outer : F → K) (probability : K → ℝ) (f g : F) : ℝ :=
  if outer f = outer g then probability (outer f) else 0

theorem broadKernel_nonnegative
    {F K : Type*} (outer : F → K) (probability : K → ℝ)
    (hp : ∀ k, 0 ≤ probability k) (f g : F) :
    0 ≤ broadKernel outer probability f g :=
  mul_nonneg (hp _) (hp _)

theorem clippingKernel_nonnegative
    {F K : Type*} [DecidableEq K]
    (outer : F → K) (probability : K → ℝ)
    (hp : ∀ k, 0 ≤ probability k) (f g : F) :
    0 ≤ clippingKernel outer probability f g := by
  unfold clippingKernel
  split_ifs
  · exact hp _
  · exact le_rfl

theorem preserved_currency
    {X Y A B F H : Type*}
    (fx : X → F) (fa : A → F) (fy : Y → H) (fb : B → H)
    (m : X → A → ℝ) (n : Y → B → ℝ)
    (hm : ∀ x a, m x a ≠ 0 → fx x = fa a)
    (hn : ∀ y b, n y b ≠ 0 → fy y = fb b)
    (kernel : F → H → ℝ) (x : X) (y : Y) (a : A) (b : B) :
    kernel (fx x) (fy y) * m x a * n y b =
      kernel (fa a) (fb b) * m x a * n y b := by
  by_cases hx : m x a = 0
  · simp [hx]
  by_cases hy : n y b = 0
  · simp [hy]
  rw [hm x a hx, hn y b hy]

theorem projection_no_multiplicity
    {Current Origin : Type*} [Fintype Current] [Fintype Origin]
    (ancestor : Current → Origin) (injective : Function.Injective ancestor)
    (mass : Origin → ℝ) (hmass : ∀ x, 0 ≤ mass x) :
    (∑ x, mass (ancestor x)) ≤ ∑ x, mass x := by
  classical
  calc
    _ = ∑ x ∈ Finset.univ.image ancestor, mass x :=
      (Finset.sum_image fun x _ y _ h => injective h).symm
    _ ≤ _ := Finset.sum_le_sum_of_subset_of_nonneg
      (Finset.subset_univ _) (fun x _ _ => hmass x)

abbrev Tuple (X Y A B : Type*) := (A × B) × (X × Y)

def tupleWeight
    {X Y A B : Type*} (kernel : A → B → ℝ)
    (m : X → A → ℝ) (n : Y → B → ℝ) (t : Tuple X Y A B) : ℝ :=
  kernel t.1.1 t.1.2 * m t.2.1 t.1.1 * n t.2.2 t.1.2

theorem tupleWeight_sum
    {X Y A B : Type*} [Fintype X] [Fintype Y] [Fintype A] [Fintype B]
    (kernel : A → B → ℝ) (m : X → A → ℝ) (n : Y → B → ℝ) :
    (∑ t : Tuple X Y A B, tupleWeight kernel m n t) =
      ∑ a, ∑ b, kernel a b * (∑ x, m x a) * (∑ y, n y b) := by
  simp only [Fintype.sum_prod_type, tupleWeight]
  simp_rw [← Finset.mul_sum, ← Finset.sum_mul]
  simp_rw [← Finset.mul_sum]

theorem capacity_bound
    {X Y A B : Type*} [Fintype X] [Fintype Y] [Fintype A] [Fintype B]
    (kernel : A → B → ℝ) (m : X → A → ℝ) (n : Y → B → ℝ)
    (u : A → ℝ) (v : B → ℝ)
    (hk : ∀ a b, 0 ≤ kernel a b)
    (_hm : ∀ x a, 0 ≤ m x a) (hn : ∀ y b, 0 ≤ n y b)
    (hu : ∀ a, 0 ≤ u a) (_hv : ∀ b, 0 ≤ v b)
    (hcm : ∀ a, (∑ x, m x a) ≤ u a)
    (hcn : ∀ b, (∑ y, n y b) ≤ v b) :
    (∑ t : Tuple X Y A B, tupleWeight kernel m n t) ≤
      ∑ a, ∑ b, kernel a b * u a * v b := by
  rw [tupleWeight_sum]
  apply Finset.sum_le_sum
  intro a _
  apply Finset.sum_le_sum
  intro b _
  have hn0 : 0 ≤ ∑ y, n y b := Finset.sum_nonneg fun y _ => hn y b
  calc
    _ ≤ (kernel a b * u a) * (∑ y, n y b) :=
      mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_left (hcm a) (hk a b)) hn0
    _ ≤ _ :=
      mul_le_mul_of_nonneg_left (hcn b) (mul_nonneg (hk a b) (hu a))

theorem projected_transport
    {X Y A B C : Type*}
    [Fintype X] [Fintype Y] [Fintype A] [Fintype B]
    [Fintype C] [AddGroup C]
    (kernel : A → B → ℝ) (m : X → A → ℝ) (n : Y → B → ℝ)
    (u : A → ℝ) (v : B → ℝ)
    (color : Tuple X Y A B → C)
    (move : C → Tuple X Y A B ≃ Tuple X Y A B)
    (allowed : Tuple X Y A B → Prop) [DecidablePred allowed]
    (hcolor : ∀ c t, color (move c t) = c + color t)
    (hweight : ∀ c t,
      tupleWeight kernel m n (move c t) = tupleWeight kernel m n t)
    (hk : ∀ a b, 0 ≤ kernel a b)
    (hm : ∀ x a, 0 ≤ m x a) (hn : ∀ y b, 0 ≤ n y b)
    (hu : ∀ a, 0 ≤ u a) (hv : ∀ b, 0 ≤ v b)
    (hcm : ∀ a, (∑ x, m x a) ≤ u a)
    (hcn : ∀ b, (∑ y, n y b) ≤ v b) :
    (∑ t, if color t = 0 then tupleWeight kernel m n t else 0) =
        (∑ t, tupleWeight kernel m n t) / (Fintype.card C : ℝ) ∧
      (∑ t, if allowed t ∧ color t = 0 then tupleWeight kernel m n t else 0) ≤
        (∑ a, ∑ b, kernel a b * u a * v b) / (Fintype.card C : ℝ) := by
  classical
  have hw (t : Tuple X Y A B) : 0 ≤ tupleWeight kernel m n t :=
    mul_nonneg (mul_nonneg (hk _ _) (hm _ _)) (hn _ _)
  have havg := invariant_fiber_average color (tupleWeight kernel m n) move hcolor hweight
  refine ⟨havg, ?_⟩
  calc
    _ ≤ ∑ t, if color t = 0 then tupleWeight kernel m n t else 0 := by
      apply Finset.sum_le_sum
      intro t _
      by_cases ha : allowed t <;> by_cases hc : color t = 0 <;> simp [ha, hc, hw]
    _ = _ := havg
    _ ≤ _ := div_le_div_of_nonneg_right
      (capacity_bound kernel m n u v hk hm hn hu hv hcm hcn) (by positivity)

structure Chronology (V : Type*) where
  connected : ℕ → V → V → Prop
  reflexive : ∀ t x, connected t x x
  symmetric : ∀ {t x y}, connected t x y → connected t y x
  transitive : ∀ {t x y z}, connected t x y → connected t y z → connected t x z
  growing : ∀ {s t x y}, s ≤ t → connected s x y → connected t x y

def First {V : Type*} (history : Chronology V) (epoch : ℕ) (x y : V) : Prop :=
  history.connected epoch x y ∧ ∀ t, t < epoch → ¬history.connected t x y

theorem first_epoch_preserved
    {V : Type*} (history : Chronology V) {epoch past : ℕ} {x y a b : V}
    (hfirst : First history epoch x y) (hpast : past < epoch)
    (hx : history.connected past x a) (hy : history.connected past y b) :
    First history epoch a b := by
  constructor
  · exact history.transitive
      (history.symmetric (history.growing (Nat.le_of_lt hpast) hx))
      (history.transitive hfirst.1 (history.growing (Nat.le_of_lt hpast) hy))
  · intro t ht hab
    have hmax : max t past < epoch := max_lt ht hpast
    have hxa := history.growing (le_max_right t past) hx
    have hyb := history.growing (le_max_right t past) hy
    have hab' := history.growing (le_max_left t past) hab
    exact hfirst.2 (max t past) hmax
      (history.transitive hxa (history.transitive hab' (history.symmetric hyb)))

theorem first_epoch_unique
    {V : Type*} (history : Chronology V) {s t : ℕ} {x y : V}
    (hs : First history s x y) (ht : First history t x y) : s = t := by
  rcases lt_trichotomy s t with h | h | h
  · exact False.elim (ht.2 s h hs.1)
  · exact h
  · exact False.elim (hs.2 t h ht.1)

structure ChargeData where
  X : Type
  Y : Type
  A : Type
  B : Type
  C : Type
  [finiteX : Fintype X]
  [finiteY : Fintype Y]
  [finiteA : Fintype A]
  [finiteB : Fintype B]
  [finiteC : Fintype C]
  [groupC : AddGroup C]
  kernel : A → B → ℝ
  m : X → A → ℝ
  n : Y → B → ℝ
  u : A → ℝ
  v : B → ℝ
  color : Tuple X Y A B → C
  move : C → Tuple X Y A B ≃ Tuple X Y A B
  allowed : Tuple X Y A B → Prop
  color_shift : ∀ c t, color (move c t) = c + color t
  weight_invariant : ∀ c t,
    tupleWeight kernel m n (move c t) = tupleWeight kernel m n t
  kernel_nonnegative : ∀ a b, 0 ≤ kernel a b
  m_nonnegative : ∀ x a, 0 ≤ m x a
  n_nonnegative : ∀ y b, 0 ≤ n y b
  u_nonnegative : ∀ a, 0 ≤ u a
  v_nonnegative : ∀ b, 0 ≤ v b
  m_capacity : ∀ a, (∑ x, m x a) ≤ u a
  n_capacity : ∀ b, (∑ y, n y b) ≤ v b

attribute [instance] ChargeData.finiteX ChargeData.finiteY
  ChargeData.finiteA ChargeData.finiteB ChargeData.finiteC ChargeData.groupC

def ChargeData.loss (d : ChargeData) : ℝ := by
  classical
  exact ∑ t, if d.allowed t ∧ d.color t = 0 then tupleWeight d.kernel d.m d.n t else 0

def ChargeData.charge (d : ChargeData) : ℝ :=
  (∑ a, ∑ b, d.kernel a b * d.u a * d.v b) / (Fintype.card d.C : ℝ)

theorem ChargeData.loss_le_charge (d : ChargeData) : d.loss ≤ d.charge := by
  classical
  exact (projected_transport d.kernel d.m d.n d.u d.v d.color d.move d.allowed
    d.color_shift d.weight_invariant d.kernel_nonnegative d.m_nonnegative
    d.n_nonnegative d.u_nonnegative d.v_nonnegative d.m_capacity d.n_capacity).2

theorem ChargeData.charge_nonnegative (d : ChargeData) : 0 ≤ d.charge := by
  apply div_nonneg
  · exact Finset.sum_nonneg fun a _ =>
      Finset.sum_nonneg fun b _ =>
        mul_nonneg (mul_nonneg (d.kernel_nonnegative a b) (d.u_nonnegative a))
          (d.v_nonnegative b)
  · positivity

def carriedProduct : List (ℝ × ChargeData) → ℝ
  | [] => 1
  | (r, _) :: rest => r * carriedProduct rest

def chargedStops : List (ℝ × ChargeData) → ℝ
  | [] => 0
  | (r, d) :: rest => d.charge + r * chargedStops rest

def chargedTerms : List (ℝ × ChargeData) → List ℝ
  | [] => []
  | (r, d) :: rest => d.charge :: (chargedTerms rest).map (r * ·)

inductive BackwardTrace : ℝ → List (ℝ × ChargeData) → ℝ → Prop
  | stop (terminal : ℝ) : BackwardTrace terminal [] terminal
  | step {current preWeight terminal : ℝ} {r : ℝ} {d : ChargeData}
      {rest : List (ℝ × ChargeData)}
      (factor_nonnegative : 0 ≤ r)
      (local_update : current ≤ r * preWeight + d.loss)
      (tail : BackwardTrace preWeight rest terminal) :
      BackwardTrace current ((r, d) :: rest) terminal

theorem complete_backward_charge
    {current terminal : ℝ} {stages : List (ℝ × ChargeData)}
    (trace : BackwardTrace current stages terminal) :
    current ≤ carriedProduct stages * terminal + chargedStops stages := by
  induction trace with
  | stop terminal => simp [carriedProduct, chargedStops]
  | @step current preWeight terminal r d rest hr hstep tail ih =>
      calc
        current ≤ r * preWeight + d.loss := hstep
        _ ≤ r * (carriedProduct rest * terminal + chargedStops rest) + d.charge :=
          add_le_add (mul_le_mul_of_nonneg_left ih hr) d.loss_le_charge
        _ = _ := by simp only [carriedProduct, chargedStops]; ring

theorem sum_left_scaled (r : ℝ) (values : List ℝ) :
    (values.map (r * ·)).sum = r * values.sum := by
  induction values with
  | nil => simp
  | cons x xs ih => simp [ih, mul_add]

theorem chargedTerms_sum (stages : List (ℝ × ChargeData)) :
    (chargedTerms stages).sum = chargedStops stages := by
  induction stages with
  | nil => rfl
  | cons s rest ih =>
      rcases s with ⟨r, d⟩
      simp only [chargedTerms, chargedStops, List.sum_cons, sum_left_scaled, ih]

theorem chargedTerms_length (stages : List (ℝ × ChargeData)) :
    (chargedTerms stages).length = stages.length := by
  induction stages with
  | nil => rfl
  | cons s rest ih =>
      rcases s with ⟨r, d⟩
      simp [chargedTerms, ih]

theorem chargedTerms_nonnegative
    {current terminal : ℝ} {stages : List (ℝ × ChargeData)}
    (trace : BackwardTrace current stages terminal) :
    ∀ z ∈ chargedTerms stages, 0 ≤ z := by
  induction trace with
  | stop terminal => simp [chargedTerms]
  | @step current preWeight terminal r d rest hr hstep tail ih =>
      intro z hz
      simp only [chargedTerms, List.mem_cons, List.mem_map] at hz
      rcases hz with h | ⟨v, hv, h⟩
      · simpa only [h] using d.charge_nonnegative
      · subst z
        exact mul_nonneg hr (ih v hv)

end

end BackwardCharge

#print axioms BackwardCharge.digit_average
#print axioms BackwardCharge.correlated_covariance
#print axioms BackwardCharge.projected_transport
#print axioms BackwardCharge.first_epoch_preserved
#print axioms BackwardCharge.complete_backward_charge
