import Mathlib

namespace SharedSeed

structure Shifts (a b : ℕ) (Δ : Type*) where
  ea : Δ → ZMod a
  eb : Δ → ZMod b
  orderA : Δ ≃ ZMod b × ZMod a
  orderB : Δ ≃ ZMod a × ZMod b
  orderA_fst : ∀ δ, (orderA δ).1 = eb δ
  orderB_fst : ∀ δ, (orderB δ).1 = ea δ

namespace Shifts

variable {a b : ℕ} {Δ : Type*} (d : Shifts a b Δ)

def rhoA (δ : Δ) : ZMod a := (d.orderA δ).2 - d.ea δ
def rhoB (δ : Δ) : ZMod b := (d.orderB δ).2 - d.eb δ

def aMap (x : ℤ) (v : Δ × ZMod a) :
    (ZMod a × ZMod b) × ZMod a :=
  ((v.2 + d.ea v.1, d.eb v.1), v.2 + (x : ZMod a) - d.rhoA v.1)

def aInverse (x : ℤ) (v : (ZMod a × ZMod b) × ZMod a) :
    Δ × ZMod a :=
  let δ := d.orderA.symm (v.1.2, v.1.1 + (x : ZMod a) - v.2)
  (δ, v.1.1 - d.ea δ)

theorem a_left (x : ℤ) : Function.LeftInverse (d.aInverse x) (d.aMap x) := by
  rintro ⟨δ, y⟩
  have hp :
      (d.eb δ, y + d.ea δ + (x : ZMod a) -
        (y + (x : ZMod a) - d.rhoA δ)) = d.orderA δ := by
    apply Prod.ext
    · exact (d.orderA_fst δ).symm
    · dsimp [rhoA]
      ring
  simp only [aInverse, aMap, hp, Equiv.symm_apply_apply]
  simp

theorem a_right (x : ℤ) : Function.RightInverse (d.aInverse x) (d.aMap x) := by
  rintro ⟨⟨α, ξ⟩, q⟩
  let δ := d.orderA.symm (ξ, α + (x : ZMod a) - q)
  have he := d.orderA.apply_symm_apply (ξ, α + (x : ZMod a) - q)
  have hb : d.eb δ = ξ := by
    simpa only [δ, d.orderA_fst] using congrArg Prod.fst he
  have hq : (d.orderA δ).2 = α + (x : ZMod a) - q :=
    congrArg Prod.snd he
  change ((α - d.ea δ + d.ea δ, d.eb δ),
    α - d.ea δ + (x : ZMod a) - d.rhoA δ) = ((α, ξ), q)
  rw [hb]
  apply Prod.ext
  · simp
  · dsimp [rhoA]
    rw [hq]
    ring

def aEquiv (x : ℤ) : Δ × ZMod a ≃ (ZMod a × ZMod b) × ZMod a where
  toFun := d.aMap x
  invFun := d.aInverse x
  left_inv := d.a_left x
  right_inv := d.a_right x

def bMap (x : ℤ) (v : Δ × ZMod b) :
    (ZMod a × ZMod b) × ZMod b :=
  ((d.ea v.1, v.2 + d.eb v.1), v.2 + (x : ZMod b) - d.rhoB v.1)

def bInverse (x : ℤ) (v : (ZMod a × ZMod b) × ZMod b) :
    Δ × ZMod b :=
  let δ := d.orderB.symm (v.1.1, v.1.2 + (x : ZMod b) - v.2)
  (δ, v.1.2 - d.eb δ)

theorem b_left (x : ℤ) : Function.LeftInverse (d.bInverse x) (d.bMap x) := by
  rintro ⟨δ, y⟩
  have hp :
      (d.ea δ, y + d.eb δ + (x : ZMod b) -
        (y + (x : ZMod b) - d.rhoB δ)) = d.orderB δ := by
    apply Prod.ext
    · exact (d.orderB_fst δ).symm
    · dsimp [rhoB]
      ring
  simp only [bInverse, bMap, hp, Equiv.symm_apply_apply]
  simp

theorem b_right (x : ℤ) : Function.RightInverse (d.bInverse x) (d.bMap x) := by
  rintro ⟨⟨α, ξ⟩, q⟩
  let δ := d.orderB.symm (α, ξ + (x : ZMod b) - q)
  have he := d.orderB.apply_symm_apply (α, ξ + (x : ZMod b) - q)
  have ha : d.ea δ = α := by
    simpa only [δ, d.orderB_fst] using congrArg Prod.fst he
  have hq : (d.orderB δ).2 = ξ + (x : ZMod b) - q :=
    congrArg Prod.snd he
  change ((d.ea δ, ξ - d.eb δ + d.eb δ),
    ξ - d.eb δ + (x : ZMod b) - d.rhoB δ) = ((α, ξ), q)
  rw [ha]
  apply Prod.ext
  · simp
  · dsimp [rhoB]
    rw [hq]
    ring

def bEquiv (x : ℤ) : Δ × ZMod b ≃ (ZMod a × ZMod b) × ZMod b where
  toFun := d.bMap x
  invFun := d.bInverse x
  left_inv := d.b_left x
  right_inv := d.b_right x

end Shifts

def attach {B L Δ P : Type*} (e : Δ × L ≃ P × L) :
    (B × L) × Δ ≃ P × (B × L) where
  toFun v := let w := e (v.2, v.1.2); (w.1, (v.1.1, w.2))
  invFun w := let v := e.symm (w.1, w.2.2); ((w.2.1, v.2), v.1)
  left_inv := by
    rintro ⟨⟨b, y⟩, δ⟩
    simp
  right_inv := by
    rintro ⟨p, b, q⟩
    simp

abbrev Blocks (a b : ℕ) (A B : Type*) := (A × ZMod a) ⊕ (B × ZMod b)

def useful {a b : ℕ} {K A B : Type*} (chart : K ≃ Blocks a b A B)
    (k : K) : ZMod a × ZMod b :=
  match chart k with
  | .inl (_, y) => (y, 0)
  | .inr (_, y) => (0, y)

def blockRotate {a b : ℕ} {K A B : Type*} (chart : K ≃ Blocks a b A B)
    (t : ℤ) (k : K) : K :=
  chart.symm (match chart k with
    | .inl (c, y) => .inl (c, y + (t : ZMod a))
    | .inr (c, y) => .inr (c, y + (t : ZMod b)))

def blockEquiv {a b : ℕ} {K A B Δ : Type*} (d : Shifts a b Δ)
    (chart : K ≃ Blocks a b A B) (x : ℤ) :
    K × Δ ≃ (ZMod a × ZMod b) × K :=
  (Equiv.prodCongr chart (Equiv.refl Δ)).trans
    ((Equiv.sumProdDistrib (A × ZMod a) (B × ZMod b) Δ).trans
      ((Equiv.sumCongr (attach (d.aEquiv x)) (attach (d.bEquiv x))).trans
        ((Equiv.prodSumDistrib (ZMod a × ZMod b)
          (A × ZMod a) (B × ZMod b)).symm.trans
          (Equiv.prodCongr (Equiv.refl _) chart.symm))))

theorem block_lift_independent {a b : ℕ} {K A B Δ : Type*}
    (d : Shifts a b Δ) (chart : K ≃ Blocks a b A B)
    (x : ℤ) (H : K × Δ → ℤ)
    (ha : ∀ v, (H v : ZMod a) = d.rhoA v.2)
    (hb : ∀ v, (H v : ZMod b) = d.rhoB v.2) (v : K × Δ) :
    (useful chart v.1 + (d.ea v.2, d.eb v.2),
      blockRotate chart (x - H v) v.1) = blockEquiv d chart x v := by
  rcases v with ⟨k, δ⟩
  rcases hk : chart k with ⟨c, y⟩ | ⟨c, y⟩
  · simp [useful, blockRotate, blockEquiv, attach, Shifts.aEquiv,
      Shifts.aMap, hk, Int.cast_sub, ha, add_sub_assoc]
  · simp [useful, blockRotate, blockEquiv, attach, Shifts.bEquiv,
      Shifts.bMap, hk, Int.cast_sub, hb, add_sub_assoc]

def inactiveEquiv {K Δ L P B : Type*} (e : Δ × L ≃ P × L)
    (r : B ≃ B) : (K × Δ) × (B × L) ≃ (P × K) × (B × L) where
  toFun v := let w := e (v.1.2, v.2.2); ((w.1, v.1.1), (r v.2.1, w.2))
  invFun w := let v := e.symm (w.1.1, w.2.2)
             ((w.1.2, v.1), (r.symm w.2.1, v.2))
  left_inv := by
    rintro ⟨⟨k, δ⟩, b, y⟩
    simp
  right_inv := by
    rintro ⟨⟨p, k⟩, b, q⟩
    simp

def seedEquiv {a b : ℕ} {K A B Δ U W : Type*}
    (d : Shifts a b Δ) (chart : K ≃ Blocks a b A B) (x : ℤ)
    (ar : U ≃ U) (ir : W ≃ W) :
    (K × Δ) × (U ⊕ (W × ZMod a)) ≃
      ((ZMod a × ZMod b) × K) × (U ⊕ (W × ZMod a)) :=
  (Equiv.prodSumDistrib (K × Δ) U (W × ZMod a)).trans
    ((Equiv.sumCongr (Equiv.prodCongr (blockEquiv d chart x) ar)
      (inactiveEquiv (d.aEquiv x) ir)).trans
        (Equiv.prodSumDistrib ((ZMod a × ZMod b) × K) U (W × ZMod a)).symm)

def translate {n : ℕ} (t : ZMod n) : ZMod n ≃ ZMod n where
  toFun y := y + t
  invFun y := y - t
  left_inv := by intro y; simp
  right_inv := by intro y; simp

abbrev World (a c : ℕ) (C₁ C₂ C₀ : Type*) :=
  (C₁ × ZMod c) ⊕ ((C₂ × ZMod a) ⊕ (C₀ × (ZMod a × ZMod c)))

def worldRotate {a c : ℕ} {C₁ C₂ C₀ : Type*} (t : ℤ) :
    World a c C₁ C₂ C₀ ≃ World a c C₁ C₂ C₀ :=
  Equiv.sumCongr (Equiv.prodCongr (Equiv.refl C₁) (translate (t : ZMod c)))
    (Equiv.sumCongr (Equiv.prodCongr (Equiv.refl C₂) (translate (t : ZMod a)))
      (Equiv.prodCongr (Equiv.refl C₀)
        (Equiv.prodCongr (translate (t : ZMod a)) (translate (t : ZMod c)))))

def viewOne {a c : ℕ} {C₁ C₂ C₀ : Type*} :
    World a c C₁ C₂ C₀ ≃
      (C₁ × ZMod c) ⊕ ((C₂ ⊕ (C₀ × ZMod c)) × ZMod a) where
  toFun s := match s with
    | .inl u => .inl u
    | .inr (.inl (r, y)) => .inr (.inl r, y)
    | .inr (.inr (r, y, z)) => .inr (.inr (r, z), y)
  invFun s := match s with
    | .inl u => .inl u
    | .inr (.inl r, y) => .inr (.inl (r, y))
    | .inr (.inr (r, z), y) => .inr (.inr (r, y, z))
  left_inv := by rintro (u | (⟨r, y⟩ | ⟨r, y, z⟩)) <;> rfl
  right_inv := by
    rintro (u | ⟨w, y⟩)
    · rfl
    · rcases w with r | ⟨r, z⟩ <;> rfl

def viewTwo {a c : ℕ} {C₁ C₂ C₀ : Type*} :
    World a c C₁ C₂ C₀ ≃
      (C₂ × ZMod a) ⊕ ((C₁ ⊕ (C₀ × ZMod a)) × ZMod c) where
  toFun s := match s with
    | .inl (r, z) => .inr (.inl r, z)
    | .inr (.inl u) => .inl u
    | .inr (.inr (r, y, z)) => .inr (.inr (r, y), z)
  invFun s := match s with
    | .inl u => .inr (.inl u)
    | .inr (.inl r, z) => .inl (r, z)
    | .inr (.inr (r, y), z) => .inr (.inr (r, y, z))
  left_inv := by rintro (⟨r, z⟩ | (u | ⟨r, y, z⟩)) <;> rfl
  right_inv := by
    rintro (u | ⟨w, z⟩)
    · rfl
    · rcases w with r | ⟨r, y⟩ <;> rfl

def activeRotation {n : ℕ} {C : Type*} (x : ℤ) :
    C × ZMod n ≃ C × ZMod n :=
  Equiv.prodCongr (Equiv.refl C) (translate (x : ZMod n))

def inactiveRotation {n : ℕ} {C B : Type*} (x : ℤ) :
    B ⊕ (C × ZMod n) ≃ B ⊕ (C × ZMod n) :=
  Equiv.sumCongr (Equiv.refl B) (activeRotation x)

theorem world_view_one {a c : ℕ} {C₁ C₂ C₀ : Type*}
    (x h : ℤ) (ρ : ZMod a) (s : World a c C₁ C₂ C₀)
    (ha : (h : ZMod a) = ρ) (hc : (h : ZMod c) = 0) :
    viewOne (worldRotate (x - h) s) =
      match viewOne s with
      | .inl u => .inl (activeRotation x u)
      | .inr (w, y) => .inr (inactiveRotation x w, y + (x : ZMod a) - ρ) := by
  rcases s with (⟨r, z⟩ | (⟨r, y⟩ | ⟨r, y, z⟩))
  all_goals
    simp [viewOne, worldRotate, translate, activeRotation, inactiveRotation,
      Int.cast_sub, ha, hc, add_sub_assoc]

theorem world_view_two {a c : ℕ} {C₁ C₂ C₀ : Type*}
    (x h : ℤ) (ρ : ZMod c) (s : World a c C₁ C₂ C₀)
    (hc : (h : ZMod c) = ρ) (ha : (h : ZMod a) = 0) :
    viewTwo (worldRotate (x - h) s) =
      match viewTwo s with
      | .inl u => .inl (activeRotation x u)
      | .inr (w, y) => .inr (inactiveRotation x w, y + (x : ZMod c) - ρ) := by
  rcases s with (⟨r, z⟩ | (⟨r, y⟩ | ⟨r, y, z⟩))
  all_goals
    simp [viewTwo, worldRotate, translate, activeRotation, inactiveRotation,
      Int.cast_sub, ha, hc, add_sub_assoc]

def seedOneEquiv {a b c : ℕ} {K A B Δ C₁ C₂ C₀ : Type*}
    (d : Shifts a b Δ) (chart : K ≃ Blocks a b A B) (x : ℤ) :
    (K × Δ) × World a c C₁ C₂ C₀ ≃
      ((ZMod a × ZMod b) × K) × World a c C₁ C₂ C₀ :=
  (Equiv.prodCongr (Equiv.refl _) viewOne).trans
    ((seedEquiv d chart x (activeRotation x) (inactiveRotation x)).trans
      (Equiv.prodCongr (Equiv.refl _) viewOne.symm))

def seedTwoEquiv {a b c : ℕ} {K A B Δ C₁ C₂ C₀ : Type*}
    (d : Shifts c b Δ) (chart : K ≃ Blocks c b A B) (x : ℤ) :
    (K × Δ) × World a c C₁ C₂ C₀ ≃
      ((ZMod c × ZMod b) × K) × World a c C₁ C₂ C₀ :=
  (Equiv.prodCongr (Equiv.refl _) viewTwo).trans
    ((seedEquiv d chart x (activeRotation x) (inactiveRotation x)).trans
      (Equiv.prodCongr (Equiv.refl _) viewTwo.symm))

def seedOneRaw {a b c : ℕ} {K A B Δ C₁ C₂ C₀ : Type*}
    (d : Shifts a b Δ) (chart : K ≃ Blocks a b A B) (x : ℤ)
    (H : (K × Δ) × World a c C₁ C₂ C₀ → ℤ)
    (v : (K × Δ) × World a c C₁ C₂ C₀) :
    ((ZMod a × ZMod b) × K) × World a c C₁ C₂ C₀ :=
  (match viewOne v.2 with
    | .inl _ => (useful chart v.1.1 + (d.ea v.1.2, d.eb v.1.2),
        blockRotate chart (x - H v) v.1.1)
    | .inr (_, y) => ((y + d.ea v.1.2, d.eb v.1.2), v.1.1),
   worldRotate (x - H v) v.2)

def seedTwoRaw {a b c : ℕ} {K A B Δ C₁ C₂ C₀ : Type*}
    (d : Shifts c b Δ) (chart : K ≃ Blocks c b A B) (x : ℤ)
    (H : (K × Δ) × World a c C₁ C₂ C₀ → ℤ)
    (v : (K × Δ) × World a c C₁ C₂ C₀) :
    ((ZMod c × ZMod b) × K) × World a c C₁ C₂ C₀ :=
  (match viewTwo v.2 with
    | .inl _ => (useful chart v.1.1 + (d.ea v.1.2, d.eb v.1.2),
        blockRotate chart (x - H v) v.1.1)
    | .inr (_, y) => ((y + d.ea v.1.2, d.eb v.1.2), v.1.1),
   worldRotate (x - H v) v.2)

theorem seedOne_lift_independent {a b c : ℕ} {K A B Δ C₁ C₂ C₀ : Type*}
    (d : Shifts a b Δ) (chart : K ≃ Blocks a b A B) (x : ℤ)
    (H : (K × Δ) × World a c C₁ C₂ C₀ → ℤ)
    (ha : ∀ v, (H v : ZMod a) = d.rhoA v.1.2)
    (hb : ∀ v, (H v : ZMod b) = d.rhoB v.1.2)
    (hc : ∀ v, (H v : ZMod c) = 0)
    (v : (K × Δ) × World a c C₁ C₂ C₀) :
    seedOneRaw d chart x H v = seedOneEquiv d chart x v := by
  rcases v with ⟨⟨k, δ⟩, s⟩
  rcases s with (⟨r, z⟩ | (⟨r, y⟩ | ⟨r, y, z⟩))
  · rcases hk : chart k with ⟨q, w⟩ | ⟨q, w⟩
    all_goals
      simp [seedOneRaw, seedOneEquiv, seedEquiv, viewOne, worldRotate,
        translate, activeRotation, inactiveRotation, blockEquiv, attach,
        useful, blockRotate, Shifts.aEquiv, Shifts.aMap, Shifts.bEquiv,
        Shifts.bMap, hk, Int.cast_sub, ha, hb, hc, add_sub_assoc]
  all_goals
    simp [seedOneRaw, seedOneEquiv, seedEquiv, viewOne, worldRotate,
      translate, activeRotation, inactiveRotation, inactiveEquiv,
      Shifts.aEquiv, Shifts.aMap, Int.cast_sub, ha, hc, add_sub_assoc]

theorem seedTwo_lift_independent {a b c : ℕ} {K A B Δ C₁ C₂ C₀ : Type*}
    (d : Shifts c b Δ) (chart : K ≃ Blocks c b A B) (x : ℤ)
    (H : (K × Δ) × World a c C₁ C₂ C₀ → ℤ)
    (hc : ∀ v, (H v : ZMod c) = d.rhoA v.1.2)
    (hb : ∀ v, (H v : ZMod b) = d.rhoB v.1.2)
    (ha : ∀ v, (H v : ZMod a) = 0)
    (v : (K × Δ) × World a c C₁ C₂ C₀) :
    seedTwoRaw d chart x H v = seedTwoEquiv d chart x v := by
  rcases v with ⟨⟨k, δ⟩, s⟩
  rcases s with (⟨r, z⟩ | (⟨r, y⟩ | ⟨r, y, z⟩))
  · simp [seedTwoRaw, seedTwoEquiv, seedEquiv, viewTwo, worldRotate,
      translate, activeRotation, inactiveRotation, inactiveEquiv,
      Shifts.aEquiv, Shifts.aMap, Int.cast_sub, ha, hc, add_sub_assoc]
  · rcases hk : chart k with ⟨q, w⟩ | ⟨q, w⟩
    all_goals
      simp [seedTwoRaw, seedTwoEquiv, seedEquiv, viewTwo, worldRotate,
        translate, activeRotation, inactiveRotation, blockEquiv, attach,
        useful, blockRotate, Shifts.aEquiv, Shifts.aMap, Shifts.bEquiv,
        Shifts.bMap, hk, Int.cast_sub, ha, hb, hc, add_sub_assoc]
  · simp [seedTwoRaw, seedTwoEquiv, seedEquiv, viewTwo, worldRotate,
      translate, activeRotation, inactiveRotation, inactiveEquiv,
      Shifts.aEquiv, Shifts.aMap, Int.cast_sub, ha, hc, add_sub_assoc]

def reflection {K : Type*} [AddCommGroup K] (k : K) : K ≃ K where
  toFun l := k - l
  invFun l := k - l
  left_inv := by intro l; exact sub_sub_cancel k l
  right_inv := by intro l; exact sub_sub_cancel k l

def ordinaryEquiv {a b : ℕ} {K A B Δ : Type*} [AddCommGroup K]
    (d : Shifts a b Δ) (chart : K ≃ Blocks a b A B) (x : ℤ) (k : K) :
    K × Δ ≃ (ZMod a × ZMod b) × K :=
  (Equiv.prodCongr (reflection k) (Equiv.refl Δ)).trans (blockEquiv d chart x)

def ordinaryMap {a b : ℕ} {K A B Δ : Type*} [AddCommGroup K]
    (d : Shifts a b Δ) (chart : K ≃ Blocks a b A B)
    (x : ℤ) (k : K) (H : K × Δ → ℤ) (v : K × Δ) :
    (ZMod a × ZMod b) × K :=
  (useful chart (k - v.1) + (d.ea v.2, d.eb v.2),
    blockRotate chart (x - H v) (k - v.1))

theorem ordinary_eq_equiv {a b : ℕ} {K A B Δ : Type*} [AddCommGroup K]
    (d : Shifts a b Δ) (chart : K ≃ Blocks a b A B)
    (x : ℤ) (k : K) (H : K × Δ → ℤ)
    (ha : ∀ v, (H v : ZMod a) = d.rhoA v.2)
    (hb : ∀ v, (H v : ZMod b) = d.rhoB v.2) :
    ordinaryMap d chart x k H = ordinaryEquiv d chart x k := by
  funext v
  rcases v with ⟨l, δ⟩
  have h := block_lift_independent d chart x
    (fun w => H (k - w.1, w.2))
    (fun w => ha (k - w.1, w.2)) (fun w => hb (k - w.1, w.2))
    (k - l, δ)
  simpa [ordinaryMap, ordinaryEquiv, reflection] using h

theorem ordinary_inverse_compositions {a b : ℕ} {K A B Δ : Type*}
    [AddCommGroup K] (d : Shifts a b Δ) (chart : K ≃ Blocks a b A B)
    (x : ℤ) (k : K) (H : K × Δ → ℤ)
    (ha : ∀ v, (H v : ZMod a) = d.rhoA v.2)
    (hb : ∀ v, (H v : ZMod b) = d.rhoB v.2) :
    Function.LeftInverse (ordinaryEquiv d chart x k).symm
      (ordinaryMap d chart x k H) ∧
    Function.RightInverse (ordinaryEquiv d chart x k).symm
      (ordinaryMap d chart x k H) := by
  rw [ordinary_eq_equiv d chart x k H ha hb]
  exact ⟨(ordinaryEquiv d chart x k).left_inv,
    (ordinaryEquiv d chart x k).right_inv⟩

def sourceReindex {a c : ℕ} {K Δ S C₁ C₂ C₀ : Type*}
    [AddCommGroup K] [AddCommGroup S]
    (layout : S ≃ World a c C₁ C₂ C₀) (k : K) (s : S) :
    (K × Δ) × S ≃ (K × Δ) × World a c C₁ C₂ C₀ :=
  Equiv.prodCongr (Equiv.prodCongr (reflection k) (Equiv.refl Δ))
    ((reflection s).trans layout)

def targetReindex {a c D : ℕ} {K P S C₁ C₂ C₀ : Type*}
    (layout : S ≃ World a c C₁ C₂ C₀) (label : S ≃ ZMod D) :
    (P × K) × World a c C₁ C₂ C₀ ≃ (P × K) × ZMod D :=
  Equiv.prodCongr (Equiv.refl _) (layout.symm.trans label)

def sharedOutput {a c D : ℕ} {S C₁ C₂ C₀ : Type*}
    (layout : S ≃ World a c C₁ C₂ C₀) (label : S ≃ ZMod D)
    (t : ℤ) (s : S) : ZMod D :=
  label (layout.symm (worldRotate t (layout s)))

def manuscriptOneEquiv {a b c D : ℕ} {K A B Δ S C₁ C₂ C₀ : Type*}
    [AddCommGroup K] [AddCommGroup S]
    (d : Shifts a b Δ) (chart : K ≃ Blocks a b A B)
    (layout : S ≃ World a c C₁ C₂ C₀) (label : S ≃ ZMod D)
    (x : ℤ) (k : K) (s : S) : (K × Δ) × S ≃ ((ZMod a × ZMod b) × K) × ZMod D :=
  (sourceReindex layout k s).trans
    ((seedOneEquiv d chart x).trans (targetReindex layout label))

def manuscriptTwoEquiv {a b c D : ℕ} {K A B Δ S C₁ C₂ C₀ : Type*}
    [AddCommGroup K] [AddCommGroup S]
    (d : Shifts c b Δ) (chart : K ≃ Blocks c b A B)
    (layout : S ≃ World a c C₁ C₂ C₀) (label : S ≃ ZMod D)
    (x : ℤ) (k : K) (s : S) : (K × Δ) × S ≃ ((ZMod c × ZMod b) × K) × ZMod D :=
  (sourceReindex layout k s).trans
    ((seedTwoEquiv d chart x).trans (targetReindex layout label))

def manuscriptOneMap {a b c D : ℕ} {K A B Δ S C₁ C₂ C₀ : Type*}
    [AddCommGroup K] [AddCommGroup S]
    (d : Shifts a b Δ) (chart : K ≃ Blocks a b A B)
    (layout : S ≃ World a c C₁ C₂ C₀) (label : S ≃ ZMod D)
    (x : ℤ) (k : K) (s : S) (H : (K × Δ) × S → ℤ)
    (v : (K × Δ) × S) : ((ZMod a × ZMod b) × K) × ZMod D :=
  (match viewOne (layout (s - v.2)) with
    | .inl _ => (useful chart (k - v.1.1) + (d.ea v.1.2, d.eb v.1.2),
        blockRotate chart (x - H v) (k - v.1.1))
    | .inr (_, y) => ((y + d.ea v.1.2, d.eb v.1.2), k - v.1.1),
   sharedOutput layout label (x - H v) (s - v.2))

def manuscriptTwoMap {a b c D : ℕ} {K A B Δ S C₁ C₂ C₀ : Type*}
    [AddCommGroup K] [AddCommGroup S]
    (d : Shifts c b Δ) (chart : K ≃ Blocks c b A B)
    (layout : S ≃ World a c C₁ C₂ C₀) (label : S ≃ ZMod D)
    (x : ℤ) (k : K) (s : S) (H : (K × Δ) × S → ℤ)
    (v : (K × Δ) × S) : ((ZMod c × ZMod b) × K) × ZMod D :=
  (match viewTwo (layout (s - v.2)) with
    | .inl _ => (useful chart (k - v.1.1) + (d.ea v.1.2, d.eb v.1.2),
        blockRotate chart (x - H v) (k - v.1.1))
    | .inr (_, y) => ((y + d.ea v.1.2, d.eb v.1.2), k - v.1.1),
   sharedOutput layout label (x - H v) (s - v.2))

theorem manuscript_one_eq_equiv {a b c D : ℕ} {K A B Δ S C₁ C₂ C₀ : Type*}
    [AddCommGroup K] [AddCommGroup S]
    (d : Shifts a b Δ) (chart : K ≃ Blocks a b A B)
    (layout : S ≃ World a c C₁ C₂ C₀) (label : S ≃ ZMod D)
    (x : ℤ) (k : K) (s : S) (H : (K × Δ) × S → ℤ)
    (ha : ∀ v, (H v : ZMod a) = d.rhoA v.1.2)
    (hb : ∀ v, (H v : ZMod b) = d.rhoB v.1.2)
    (hc : ∀ v, (H v : ZMod c) = 0) :
    manuscriptOneMap d chart layout label x k s H =
      manuscriptOneEquiv d chart layout label x k s := by
  funext v
  let e := sourceReindex (Δ := Δ) layout k s
  have he := seedOne_lift_independent d chart x (fun w => H (e.symm w))
    (fun w => ha (e.symm w)) (fun w => hb (e.symm w))
    (fun w => hc (e.symm w)) (e v)
  simp only [seedOneRaw, Equiv.symm_apply_apply] at he
  have h := congrArg (targetReindex (K := K) (P := ZMod a × ZMod b) layout label) he
  simpa [e, manuscriptOneMap, manuscriptOneEquiv, seedOneRaw, sourceReindex,
    targetReindex, sharedOutput, reflection] using h

theorem manuscript_two_eq_equiv {a b c D : ℕ} {K A B Δ S C₁ C₂ C₀ : Type*}
    [AddCommGroup K] [AddCommGroup S]
    (d : Shifts c b Δ) (chart : K ≃ Blocks c b A B)
    (layout : S ≃ World a c C₁ C₂ C₀) (label : S ≃ ZMod D)
    (x : ℤ) (k : K) (s : S) (H : (K × Δ) × S → ℤ)
    (hc : ∀ v, (H v : ZMod c) = d.rhoA v.1.2)
    (hb : ∀ v, (H v : ZMod b) = d.rhoB v.1.2)
    (ha : ∀ v, (H v : ZMod a) = 0) :
    manuscriptTwoMap d chart layout label x k s H =
      manuscriptTwoEquiv d chart layout label x k s := by
  funext v
  let e := sourceReindex (Δ := Δ) layout k s
  have he := seedTwo_lift_independent d chart x (fun w => H (e.symm w))
    (fun w => hc (e.symm w)) (fun w => hb (e.symm w))
    (fun w => ha (e.symm w)) (e v)
  simp only [seedTwoRaw, Equiv.symm_apply_apply] at he
  have h := congrArg (targetReindex (K := K) (P := ZMod c × ZMod b) layout label) he
  simpa [e, manuscriptTwoMap, manuscriptTwoEquiv, seedTwoRaw, sourceReindex,
    targetReindex, sharedOutput, reflection] using h

def shear (r : ℕ) (x : ℤ) (k β : ZMod r) : ZMod (r * r) :=
  (x : ZMod (r * r)) + ((k - (x : ZMod r)).val : ℕ) +
    (r : ZMod (r * r)) * (β.val : ℕ)

theorem shear_carry (r : ℕ) (x h : ℤ) (k l β : ZMod r)
    (hl : (h : ZMod r) = l) :
    shear r (x - h) (k - l) β + (h : ZMod (r * r)) = shear r x k β := by
  have hk : k - l - ((x - h : ℤ) : ZMod r) = k - (x : ZMod r) := by
    rw [Int.cast_sub, hl]
    ring
  unfold shear
  rw [hk]
  simp only [Int.cast_sub]
  ring

def horizontalResidue (m : ℕ) (x₁ x₂ : ℤ) : ZMod m × ZMod m :=
  ((x₁ : ZMod m), (x₂ : ZMod m))

theorem horizontal_source (m : ℕ) (x₁ x₂ h₁ h₂ : ℤ)
    (τ : ZMod m × ZMod m) (hτ : horizontalResidue m h₁ h₂ = τ) :
    horizontalResidue m (x₁ - h₁) (x₂ - h₂) =
      horizontalResidue m x₁ x₂ - τ := by
  rw [← hτ]
  ext <;> simp [horizontalResidue, Int.cast_sub]

def rectangleShifts (a b : ℕ) : Shifts a b (ZMod a × ZMod b) where
  ea δ := (Equiv.swap (1, 0) (0, 1) δ).1
  eb δ := δ.2
  orderA := Equiv.prodComm _ _
  orderB := Equiv.swap (1, 0) (0, 1)
  orderA_fst := by intro δ; rfl
  orderB_fst := by intro δ; rfl

theorem ordinary_bijective {a b : ℕ} {K A B Δ : Type*} [AddCommGroup K]
    (d : Shifts a b Δ) (chart : K ≃ Blocks a b A B)
    (x : ℤ) (k : K) (H : K × Δ → ℤ)
    (ha : ∀ v, (H v : ZMod a) = d.rhoA v.2)
    (hb : ∀ v, (H v : ZMod b) = d.rhoB v.2) :
    Function.Bijective (ordinaryMap d chart x k H) := by
  rw [ordinary_eq_equiv d chart x k H ha hb]
  exact (ordinaryEquiv d chart x k).bijective

theorem line_invariance {J : Type*} (f : ℤ → J) (n x₁ x₂ h : ℤ) :
    f ((x₂ + n * h) + n * (x₁ - h)) = f (x₂ + n * x₁) := by
  congr 1
  ring

section Simultaneous

variable {a c b₁ b₂ D : ℕ}
  {K₁ K₂ A₁ B₁ A₂ B₂ Δ₁ Δ₂ S C₁ C₂ C₀ : Type*}
  [AddCommGroup K₁] [AddCommGroup K₂] [AddCommGroup S]
  (d₁ : Shifts a b₁ Δ₁) (d₂ : Shifts c b₂ Δ₂)
  (chart₁ : K₁ ≃ Blocks a b₁ A₁ B₁) (chart₂ : K₂ ≃ Blocks c b₂ A₂ B₂)
  (layout : S ≃ World a c C₁ C₂ C₀) (label : S ≃ ZMod D)
  (x : ℤ) (k₁ : K₁) (k₂ : K₂) (s : S)
  (H₁ : (K₁ × Δ₁) × S → ℤ) (H₂ : (K₂ × Δ₂) × S → ℤ)
  (h₁a : ∀ v, (H₁ v : ZMod a) = d₁.rhoA v.1.2)
  (h₁b : ∀ v, (H₁ v : ZMod b₁) = d₁.rhoB v.1.2)
  (h₁c : ∀ v, (H₁ v : ZMod c) = 0)
  (h₂c : ∀ v, (H₂ v : ZMod c) = d₂.rhoA v.1.2)
  (h₂b : ∀ v, (H₂ v : ZMod b₂) = d₂.rhoB v.1.2)
  (h₂a : ∀ v, (H₂ v : ZMod a) = 0)

include h₁a h₁b h₁c h₂c h₂b h₂a

theorem simultaneous_activation :
    Function.Bijective (manuscriptOneMap d₁ chart₁ layout label x k₁ s H₁) ∧
    Function.Bijective (manuscriptTwoMap d₂ chart₂ layout label x k₂ s H₂) ∧
    (Function.LeftInverse (manuscriptOneEquiv d₁ chart₁ layout label x k₁ s).symm
        (manuscriptOneMap d₁ chart₁ layout label x k₁ s H₁) ∧
      Function.RightInverse (manuscriptOneEquiv d₁ chart₁ layout label x k₁ s).symm
        (manuscriptOneMap d₁ chart₁ layout label x k₁ s H₁)) ∧
    (Function.LeftInverse (manuscriptTwoEquiv d₂ chart₂ layout label x k₂ s).symm
        (manuscriptTwoMap d₂ chart₂ layout label x k₂ s H₂) ∧
      Function.RightInverse (manuscriptTwoEquiv d₂ chart₂ layout label x k₂ s).symm
        (manuscriptTwoMap d₂ chart₂ layout label x k₂ s H₂)) := by
  rw [manuscript_one_eq_equiv d₁ chart₁ layout label x k₁ s H₁ h₁a h₁b h₁c,
    manuscript_two_eq_equiv d₂ chart₂ layout label x k₂ s H₂ h₂c h₂b h₂a]
  exact ⟨(manuscriptOneEquiv d₁ chart₁ layout label x k₁ s).bijective,
    (manuscriptTwoEquiv d₂ chart₂ layout label x k₂ s).bijective,
    ⟨(manuscriptOneEquiv d₁ chart₁ layout label x k₁ s).left_inv,
      (manuscriptOneEquiv d₁ chart₁ layout label x k₁ s).right_inv⟩,
    ⟨(manuscriptTwoEquiv d₂ chart₂ layout label x k₂ s).left_inv,
      (manuscriptTwoEquiv d₂ chart₂ layout label x k₂ s).right_inv⟩⟩

end Simultaneous

theorem manuscript_specialization {p b₁ b₂ r₁ r₂ : ℕ}
    {A₁ B₁ A₂ B₂ Δ₁ Δ₂ : Type*}
    (d₁ : Shifts 2 b₁ Δ₁) (d₂ : Shifts 3 b₂ Δ₂)
    (chart₁ : ZMod r₁ ≃ Blocks 2 b₁ A₁ B₁)
    (chart₂ : ZMod r₂ ≃ Blocks 3 b₂ A₂ B₂)
    (layout : (ZMod (p ^ 2) × ZMod (p ^ 2)) ≃
      World 2 3 PUnit (Fin 2) (Fin ((p ^ 4 - 7) / 6)))
    (label : (ZMod (p ^ 2) × ZMod (p ^ 2)) ≃ ZMod (p ^ 4))
    (x : ℤ) (k₁ : ZMod r₁) (k₂ : ZMod r₂)
    (s : ZMod (p ^ 2) × ZMod (p ^ 2))
    (H₁ : (ZMod r₁ × Δ₁) × (ZMod (p ^ 2) × ZMod (p ^ 2)) → ℤ)
    (H₂ : (ZMod r₂ × Δ₂) × (ZMod (p ^ 2) × ZMod (p ^ 2)) → ℤ)
    (h₁a : ∀ v, (H₁ v : ZMod 2) = d₁.rhoA v.1.2)
    (h₁b : ∀ v, (H₁ v : ZMod b₁) = d₁.rhoB v.1.2)
    (h₁c : ∀ v, (H₁ v : ZMod 3) = 0)
    (h₂c : ∀ v, (H₂ v : ZMod 3) = d₂.rhoA v.1.2)
    (h₂b : ∀ v, (H₂ v : ZMod b₂) = d₂.rhoB v.1.2)
    (h₂a : ∀ v, (H₂ v : ZMod 2) = 0) :
    Function.Bijective (manuscriptOneMap d₁ chart₁ layout label x k₁ s H₁) ∧
    Function.Bijective (manuscriptTwoMap d₂ chart₂ layout label x k₂ s H₂) ∧
    (Function.LeftInverse (manuscriptOneEquiv d₁ chart₁ layout label x k₁ s).symm
        (manuscriptOneMap d₁ chart₁ layout label x k₁ s H₁) ∧
      Function.RightInverse (manuscriptOneEquiv d₁ chart₁ layout label x k₁ s).symm
        (manuscriptOneMap d₁ chart₁ layout label x k₁ s H₁)) ∧
    (Function.LeftInverse (manuscriptTwoEquiv d₂ chart₂ layout label x k₂ s).symm
        (manuscriptTwoMap d₂ chart₂ layout label x k₂ s H₂) ∧
      Function.RightInverse (manuscriptTwoEquiv d₂ chart₂ layout label x k₂ s).symm
        (manuscriptTwoMap d₂ chart₂ layout label x k₂ s H₂)) :=
  simultaneous_activation d₁ d₂ chart₁ chart₂ layout label x k₁ k₂ s H₁ H₂
    h₁a h₁b h₁c h₂c h₂b h₂a

end SharedSeed
