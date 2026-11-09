import Mathlib

namespace PartialPathCore

inductive Shape where
  | node (arity : Nat) (children : Fin arity → Shape)

def point : Shape := .node 0 Fin.elim0

def Cell : Nat → Shape → Type
  | 0, .node p _ => Fin (p + 1)
  | k + 1, .node p children => (i : Fin p) × Cell k (children i)

def spine : Nat → Shape → Shape
  | 0, .node p _ => .node p (fun _ => point)
  | m + 1, .node p children => .node p (fun i => spine m (children i))

def source : (k : Nat) → (s : Shape) → Cell (k + 1) s → Cell k s
  | 0, .node _ _, x => ⟨x.1.val, by omega⟩
  | k + 1, .node _ children, x => ⟨x.1, source k (children x.1) x.2⟩

def target : (k : Nat) → (s : Shape) → Cell (k + 1) s → Cell k s
  | 0, .node _ _, x => ⟨x.1.val + 1, by omega⟩
  | k + 1, .node _ children, x => ⟨x.1, target k (children x.1) x.2⟩

theorem source_globular (k : Nat) (s : Shape) (x : Cell (k + 2) s) :
    source k s (source (k + 1) s x) = source k s (target (k + 1) s x) := by
  induction k generalizing s with
  | zero => cases s; rfl
  | succ k ih =>
      cases s with
      | node p children =>
          rcases x with ⟨i, x⟩
          simp only [source, target]
          rw [ih]

theorem target_globular (k : Nat) (s : Shape) (x : Cell (k + 2) s) :
    target k s (source (k + 1) s x) = target k s (target (k + 1) s x) := by
  induction k generalizing s with
  | zero => cases s; rfl
  | succ k ih =>
      cases s with
      | node p children =>
          rcases x with ⟨i, x⟩
          simp only [source, target]
          rw [ih]

def retain : (k m : Nat) → (s : Shape) → k ≤ m → Cell k s → Cell k (spine m s)
  | 0, 0, .node _ _, _, x => x
  | 0, _ + 1, .node _ _, _, x => x
  | _ + 1, 0, _, h, _ => False.elim (by omega)
  | k + 1, m + 1, .node _ children, h, x =>
      ⟨x.1, retain k m (children x.1) (by omega) x.2⟩

def recover : (k m : Nat) → (s : Shape) → k ≤ m → Cell k (spine m s) → Cell k s
  | 0, 0, .node _ _, _, x => x
  | 0, _ + 1, .node _ _, _, x => x
  | _ + 1, 0, _, h, _ => False.elim (by omega)
  | k + 1, m + 1, .node _ children, h, x =>
      ⟨x.1, recover k m (children x.1) (by omega) x.2⟩

theorem recover_retain (k m : Nat) (s : Shape) (h : k ≤ m) (x : Cell k s) :
    recover k m s h (retain k m s h x) = x := by
  induction k generalizing m s with
  | zero =>
      cases m <;> cases s <;> rfl
  | succ k ih =>
      cases m with
      | zero => omega
      | succ m =>
          cases s with
          | node p children =>
              rcases x with ⟨i, x⟩
              simp only [retain, recover]
              rw [ih]

theorem retain_recover (k m : Nat) (s : Shape) (h : k ≤ m)
    (x : Cell k (spine m s)) :
    retain k m s h (recover k m s h x) = x := by
  induction k generalizing m s with
  | zero =>
      cases m <;> cases s <;> rfl
  | succ k ih =>
      cases m with
      | zero => omega
      | succ m =>
          cases s with
          | node p children =>
              rcases x with ⟨i, x⟩
              simp only [retain, recover]
              rw [ih]

def lowCellEquiv (k m : Nat) (s : Shape) (h : k ≤ m) :
    Cell k s ≃ Cell k (spine m s) where
  toFun := retain k m s h
  invFun := recover k m s h
  left_inv := recover_retain k m s h
  right_inv := retain_recover k m s h

theorem retain_source (k m : Nat) (s : Shape) (h : k + 1 ≤ m)
    (x : Cell (k + 1) s) :
    source k (spine m s) (retain (k + 1) m s h x) =
      retain k m s (by omega) (source k s x) := by
  induction k generalizing m s with
  | zero =>
      cases m with
      | zero => omega
      | succ m => cases s <;> rfl
  | succ k ih =>
      cases m with
      | zero => omega
      | succ m =>
          cases s with
          | node p children =>
              rcases x with ⟨i, x⟩
              simp only [spine, retain, source]
              rw [ih]

theorem retain_target (k m : Nat) (s : Shape) (h : k + 1 ≤ m)
    (x : Cell (k + 1) s) :
    target k (spine m s) (retain (k + 1) m s h x) =
      retain k m s (by omega) (target k s x) := by
  induction k generalizing m s with
  | zero =>
      cases m with
      | zero => omega
      | succ m => cases s <;> rfl
  | succ k ih =>
      cases m with
      | zero => omega
      | succ m =>
          cases s with
          | node p children =>
              rcases x with ⟨i, x⟩
              simp only [spine, retain, target]
              rw [ih]

theorem noHighCell (m k : Nat) (s : Shape) (h : m + 1 < k) :
    Cell k (spine m s) → False := by
  induction m generalizing k s with
  | zero =>
      cases k with
      | zero => omega
      | succ k =>
          cases k with
          | zero => omega
          | succ k =>
              cases s with
              | node p children =>
                  intro x
                  exact Fin.elim0 x.2.1
  | succ m ih =>
      cases k with
      | zero => omega
      | succ k =>
          cases s with
          | node p children =>
              intro x
              exact ih k (children x.1) (by omega) x.2

theorem uniqueFillerOperation {A B C : Type*} (boundary : C → B)
    (bijective : Function.Bijective boundary) (b : A → B) :
    ∃! operation : A → C, boundary ∘ operation = b := by
  classical
  let operation : A → C := fun a => Classical.choose (bijective.2 (b a))
  have fills : boundary ∘ operation = b := by
    funext a
    exact Classical.choose_spec (bijective.2 (b a))
  refine ⟨operation, fills, ?_⟩
  intro other other_fills
  funext a
  apply bijective.1
  have h₁ := congrFun other_fills a
  have h₂ := congrFun fills a
  exact h₁.trans h₂.symm

theorem naturality_comp {A B C A' B' C' : Type*}
    (f : A → B) (g : B → C) (f' : A' → B') (g' : B' → C')
    (a : A → A') (b : B → B') (c : C → C')
    (hf : b ∘ f = f' ∘ a) (hg : c ∘ g = g' ∘ b) :
    c ∘ (g ∘ f) = (g' ∘ f') ∘ a := by
  funext x
  exact (congrFun hg (f x)).trans (congrArg g' (congrFun hf x))

theorem naturality_of_jointly_injective_legs
    {I : Type*} {A T : Type*} {B : I → Type*}
    (legs : T → (i : I) → B i) (injective : Function.Injective legs)
    (f g : A → T) (h : ∀ a i, legs (f a) i = legs (g a) i) :
    f = g := by
  funext a
  apply injective
  funext i
  exact h a i

open CategoryTheory

universe u v

structure WeakRules {C : Type u} [Category.{v} C]
    (W : ∀ {X Y : C}, (X ⟶ Y) → Prop) : Prop where
  identity : ∀ X, W (𝟙 X)
  composition : ∀ {X Y Z} (f : X ⟶ Y) (g : Y ⟶ Z), W f → W g → W (f ≫ g)
  cancelFirst : ∀ {X Y Z} (f : X ⟶ Y) (g : Y ⟶ Z), W f → W (f ≫ g) → W g
  cancelSecond : ∀ {X Y Z} (f : X ⟶ Y) (g : Y ⟶ Z), W g → W (f ≫ g) → W f

theorem generatorPromotion {C : Type u} [Category.{v} C]
    (W : ∀ {X Y : C}, (X ⟶ Y) → Prop) (rules : WeakRules W)
    {A Q : C} (a₀ a₁ : A ⟶ Q) (r h : Q ⟶ A) (gf : A ⟶ A)
    (wa₀ : W a₀) (ra₀ : a₀ ≫ r = 𝟙 A) (ra₁ : a₁ ≫ r = 𝟙 A)
    (ha₀ : a₀ ≫ h = 𝟙 A) (ha₁ : a₁ ≫ h = gf) :
    W gf := by
  have wr : W r := rules.cancelFirst a₀ r wa₀ (by rw [ra₀]; exact rules.identity A)
  have wa₁ : W a₁ := rules.cancelSecond a₁ r wr (by rw [ra₁]; exact rules.identity A)
  have wh : W h := rules.cancelFirst a₀ h wa₀ (by rw [ha₀]; exact rules.identity A)
  rw [← ha₁]
  exact rules.composition a₁ h wa₁ wh

def DomainRetractClosed {C : Type u} [Category.{v} C]
    (W : ∀ {X Y : C}, (X ⟶ Y) → Prop) : Prop :=
  ∀ {X Y Z} (f : X ⟶ Z) (g : Y ⟶ Z) (i : X ⟶ Y) (r : Y ⟶ X),
    i ≫ r = 𝟙 X → i ≫ g = f → r ≫ f = g → W g → W f

theorem expansionRetract {C : Type u} [Category.{v} C]
    (W : ∀ {X Y : C}, (X ⟶ Y) → Prop) (rules : WeakRules W)
    (retractClosed : DomainRetractClosed W) {X Y : C}
    (i : X ⟶ Y) (r : Y ⟶ X) (u : X ⟶ X)
    (ri : i ≫ r = 𝟙 X) (wu : W u) (wv : W (r ≫ u ≫ i)) :
    W i := by
  have wui : W (u ≫ i) := by
    apply retractClosed (u ≫ i) (r ≫ u ≫ i) i r ri
    · rw [← Category.assoc, ri, Category.id_comp]
    · rfl
    · exact wv
  exact rules.cancelFirst u i wu wui

end PartialPathCore
