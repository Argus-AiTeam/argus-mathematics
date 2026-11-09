import Mathlib

universe u

namespace ReversalAudit

def SamePattern {I A B : Type*} [LT A] [LT B]
    (x : I → A) (y : I → B) : Prop :=
  ∀ i j, x i < x j ↔ y i < y j

theorem equality_transport {I A B : Type*} [LinearOrder A] [LinearOrder B]
    {x : I → A} {y : I → B} (h : SamePattern x y) (i j : I) :
    x i = x j ↔ y i = y j := by
  constructor
  · intro hx
    apply le_antisymm
    · apply le_of_not_gt
      intro hj
      have hh := (h j i).mpr hj
      simpa [hx] using hh
    · apply le_of_not_gt
      intro hi
      have hh := (h i j).mpr hi
      simpa [hx] using hh
  · intro hy
    apply le_antisymm
    · apply le_of_not_gt
      intro hj
      have hh := (h j i).mp hj
      simpa [hy] using hh
    · apply le_of_not_gt
      intro hi
      have hh := (h i j).mp hi
      simpa [hy] using hh

def LeadingLT {I A C : Type*} [LT A] [LT C]
    (positions : I → A) (c d : I → C) : Prop :=
  ∃ i, c i < d i ∧ ∀ j, positions i < positions j → c j = d j

theorem leadingLT_transport {I A B C : Type*} [LT A] [LT B] [LT C]
    {x : I → A} {y : I → B} (h : SamePattern x y) (c d : I → C) :
    LeadingLT x c d ↔ LeadingLT y c d := by
  constructor
  · rintro ⟨i, hi, htail⟩
    exact ⟨i, hi, fun j hj => htail j ((h i j).mpr hj)⟩
  · rintro ⟨i, hi, htail⟩
    exact ⟨i, hi, fun j hj => htail j ((h i j).mp hj)⟩

def NestedLT {I A J : Type*} [LT A]
    (positions : I → A) (ranks : J → I → ℤ) (c d : J → ℚ) : Prop :=
  ∃ i, c i < d i ∧ ∀ j, LeadingLT positions (ranks i) (ranks j) → c j = d j

theorem nestedLT_transport {I A B J : Type*} [LT A] [LT B]
    {x : I → A} {y : I → B} (h : SamePattern x y)
    (ranks : J → I → ℤ) (c d : J → ℚ) :
    NestedLT x ranks c d ↔ NestedLT y ranks c d := by
  constructor
  · rintro ⟨i, hi, htail⟩
    exact ⟨i, hi, fun j hj => htail j ((leadingLT_transport h _ _).mpr hj)⟩
  · rintro ⟨i, hi, htail⟩
    exact ⟨i, hi, fun j hj => htail j ((leadingLT_transport h _ _).mp hj)⟩

def InSlot {I A J P : Type*} [LT A]
    (positions : I → A) (ranks : J → I → ℤ)
    (parameters : P → J → ℚ) (lower : P → Prop) (w : J → ℚ) : Prop :=
  (∀ p, lower p → NestedLT positions ranks (parameters p) w) ∧
    (∀ p, ¬ lower p → NestedLT positions ranks w (parameters p))

theorem slot_transport {I A B J P : Type*} [LT A] [LT B]
    {x : I → A} {y : I → B} (h : SamePattern x y)
    (ranks : J → I → ℤ) (parameters : P → J → ℚ)
    (lower : P → Prop) (w : J → ℚ) :
    InSlot x ranks parameters lower w ↔ InSlot y ranks parameters lower w := by
  constructor
  · rintro ⟨hl, hu⟩
    exact ⟨fun p hp => (nestedLT_transport h _ _ _).mp (hl p hp),
      fun p hp => (nestedLT_transport h _ _ _).mp (hu p hp)⟩
  · rintro ⟨hl, hu⟩
    exact ⟨fun p hp => (nestedLT_transport h _ _ _).mpr (hl p hp),
      fun p hp => (nestedLT_transport h _ _ _).mpr (hu p hp)⟩

theorem bounded_stages {T : Type u} {δ : Ordinal.{u}}
    (hcard : Cardinal.mk T < δ.cof) (stage : T → Ordinal.{u})
    (hstage : ∀ t, stage t < δ) :
    ∃ i, i < δ ∧ ∀ t, stage t ≤ i :=
  ⟨⨆ t, stage t, Ordinal.iSup_lt_of_lt_cof hcard hstage,
    Ordinal.le_iSup stage⟩

theorem tuple_capture {T : Type u} {X : Type*} {δ : Ordinal.{u}}
    (hcard : Cardinal.mk T < δ.cof) (A : Ordinal.{u} → Set X)
    (hmono : Monotone A) (tuple : T → X)
    (hcover : ∀ t, ∃ i, i < δ ∧ tuple t ∈ A i) :
    ∃ i, i < δ ∧ ∀ t, tuple t ∈ A i := by
  classical
  choose stage hstage hmem using hcover
  obtain ⟨i, hi, hbound⟩ := bounded_stages hcard stage hstage
  exact ⟨i, hi, fun t => hmono (hbound t) (hmem t)⟩

def Excluded {Q : Type*} (R : Q → Q → Prop) (p q : Q) : Prop :=
  ¬ R q p

theorem excluded_forward {Q : Type*} {R : Q → Q → Prop}
    (htrans : Transitive R) {p q q' : Q} (h : Excluded R p q)
    (hstep : R q q') : Excluded R p q' :=
  fun hback => h (htrans hstep hback)

theorem eliminate_orbit {Q : Type*} {R : Q → Q → Prop}
    (hrefl : Reflexive R) (htrans : Transitive R)
    {p r : Q} (hpr : R p r) (hrp : ¬ R r p) (q : Q) :
    ∃ q', R q q' ∧ Excluded R p q' := by
  classical
  by_cases hqp : R q p
  · exact ⟨r, htrans hqp hpr, hrp⟩
  · exact ⟨q, hrefl q, hqp⟩

theorem limit_persistence {I Q : Type*} [Preorder I]
    {R : Q → Q → Prop} (htrans : Transitive R)
    (name : I → Q)
    (transition : ∀ i j, i ≤ j → R (name i) (name j))
    {i : I} {p : Q} (h : Excluded R p (name i)) :
    ∀ j, i ≤ j → Excluded R p (name j) :=
  fun j hij => excluded_forward htrans h (transition i j hij)

theorem covered_union_exclusion {I T Q : Type*}
    {R : Q → Q → Prop} (htrans : Transitive R)
    (p : Q) (contains : I → T → Prop)
    (processed aligned : I → T → Q) (finalName : T → Q)
    (capture : ∀ t, ∃ i, contains i t)
    (cleared : ∀ i t, contains i t → Excluded R p (processed i t))
    (handoff : ∀ i t, contains i t →
      ∃ j, R (processed i t) (aligned j t) ∧ R (aligned j t) (finalName t)) :
    ∀ t, Excluded R p (finalName t) := by
  intro t
  obtain ⟨i, hi⟩ := capture t
  obtain ⟨j, hlarge, hsmall⟩ := handoff i t hi
  exact excluded_forward htrans (cleared i t hi) (htrans hlarge hsmall)

theorem elimination_contradiction {I T Q : Type*}
    {R : Q → Q → Prop} (hrefl : Reflexive R) (htrans : Transitive R)
    (p : Q) (contains : I → T → Prop)
    (processed aligned : I → T → Q) (finalName : T → Q)
    (capture : ∀ t, ∃ i, contains i t)
    (cleared : ∀ i t, contains i t → Excluded R p (processed i t))
    (handoff : ∀ i t, contains i t →
      ∃ j, R (processed i t) (aligned j t) ∧ R (aligned j t) (finalName t))
    (realized : ∃ t, finalName t = p) : False := by
  obtain ⟨t, ht⟩ := realized
  have h := covered_union_exclusion htrans p contains processed aligned finalName
    capture cleared handoff t
  rw [ht] at h
  exact h (hrefl p)

theorem ordinal_elimination_contradiction
    {C : Type u} {X T Q : Type*} {δ : Ordinal.{u}}
    {R : Q → Q → Prop} (hrefl : Reflexive R) (htrans : Transitive R)
    (hcard : Cardinal.mk C < δ.cof)
    (A : Ordinal.{u} → Set X) (hmono : Monotone A)
    (coordinates : T → C → X)
    (hcover : ∀ t c, ∃ i, i < δ ∧ coordinates t c ∈ A i)
    (p : Q)
    (processed aligned : {i : Ordinal.{u} // i < δ} → T → Q)
    (finalName : T → Q)
    (cleared : ∀ i t, (∀ c, coordinates t c ∈ A i.val) →
      Excluded R p (processed i t))
    (handoff : ∀ i t, (∀ c, coordinates t c ∈ A i.val) →
      ∃ j, R (processed i t) (aligned j t) ∧ R (aligned j t) (finalName t))
    (realized : ∃ t, finalName t = p) : False := by
  have capture : ∀ t, ∃ i : {i : Ordinal.{u} // i < δ},
      ∀ c, coordinates t c ∈ A i.val := by
    intro t
    obtain ⟨i, hi, hmem⟩ := tuple_capture hcard A hmono (coordinates t) (hcover t)
    exact ⟨⟨i, hi⟩, hmem⟩
  exact elimination_contradiction hrefl htrans p
    (fun i t => ∀ c, coordinates t c ∈ A i.val)
    processed aligned finalName capture cleared handoff realized

end ReversalAudit
