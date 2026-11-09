import Mathlib

noncomputable section

namespace RelatorAlignment

abbrev RingOf (G : Type*) [Group G] := MonoidAlgebra ℤ G
abbrev FreeModule (G : Type*) [Group G] (J : Type*) := J →₀ RingOf G

variable {W G M J K : Type*} [Group W] [Group G]
variable [AddCommGroup M] [Module (RingOf G) M]

def delta (g : G) : RingOf G := MonoidAlgebra.single g 1

@[simp] theorem delta_one : delta (1 : G) = 1 := rfl

@[simp] theorem delta_mul (g h : G) : delta (g * h) = delta g * delta h := by
  simp [delta, MonoidAlgebra.single_mul_single]

structure PathChain (e : W →* G) (M : Type*) [AddCommGroup M]
    [Module (RingOf G) M] where
  chain : W → M
  mul_chain : ∀ a b, chain (a * b) = chain a + delta (e a) • chain b

variable {e : W →* G} (d : PathChain e M)

@[simp] theorem chain_one : d.chain 1 = 0 := by
  have h := d.mul_chain 1 1
  simpa using (add_left_cancel (show d.chain 1 + d.chain 1 = d.chain 1 + 0 by
    simpa using h.symm))

theorem chain_mul_closed {a b : W} (ha : e a = 1) :
    d.chain (a * b) = d.chain a + d.chain b := by
  simp [d.mul_chain, ha]

def kernelChain : e.ker →* Multiplicative M where
  toFun a := Multiplicative.ofAdd (d.chain a)
  map_one' := by simp
  map_mul' a b := by
    change d.chain ((a : W) * (b : W)) = d.chain a + d.chain b
    exact chain_mul_closed d (MonoidHom.mem_ker.mp a.property)

theorem chain_zpow_closed {a : W} (ha : e a = 1) (n : ℤ) :
    d.chain (a ^ n) = n • d.chain a := by
  have h := (kernelChain d).map_zpow (⟨a, ha⟩ : e.ker) n
  exact congrArg Multiplicative.toAdd h

theorem chain_conjugate {a : W} (ha : e a = 1) (v : W) :
    d.chain (v * a * v⁻¹) = delta (e v) • d.chain a := by
  have h := d.mul_chain v v⁻¹
  have hz : d.chain v + delta (e v) • d.chain v⁻¹ = 0 := by
    simpa using h.symm
  rw [d.mul_chain, d.mul_chain]
  simp only [map_mul, ha, mul_one]
  rw [add_right_comm, hz, zero_add]

structure Term (W J : Type*) where
  conjugator : W
  index : J
  exponent : ℤ

def termWord (b : J → W) (t : Term W J) : W :=
  t.conjugator * b t.index ^ t.exponent * t.conjugator⁻¹

def word (b : J → W) (l : List (Term W J)) : W :=
  (l.map (termWord b)).prod

def counts (e : W →* G) (l : List (Term W J)) : FreeModule G J :=
  (l.map fun t => Finsupp.single t.index
    (MonoidAlgebra.single (e t.conjugator) t.exponent)).sum

@[simp] theorem word_nil (b : J → W) : word b [] = 1 := rfl

@[simp] theorem word_cons (b : J → W) (t : Term W J) (l : List (Term W J)) :
    word b (t :: l) = termWord b t * word b l := rfl

@[simp] theorem word_append (b : J → W) (l k : List (Term W J)) :
    word b (l ++ k) = word b l * word b k := by
  simp [word]

def inverseTerms (l : List (Term W J)) : List (Term W J) :=
  l.reverse.map fun t => { t with exponent := -t.exponent }

theorem word_inverseTerms (b : J → W) (l : List (Term W J)) :
    word b (inverseTerms l) = (word b l)⁻¹ := by
  induction l with
  | nil => simp [inverseTerms]
  | cons t l ih =>
    simp only [inverseTerms, List.reverse_cons, List.map_append, List.map_cons,
      List.map_nil, word_append, word_cons, word_nil, mul_one]
    change word b (inverseTerms l) *
      (t.conjugator * b t.index ^ (-t.exponent) * t.conjugator⁻¹) =
        (termWord b t * word b l)⁻¹
    rw [ih]
    simp [termWord, mul_assoc]

def conjugateTerms (v : W) (l : List (Term W J)) : List (Term W J) :=
  l.map fun t => { t with conjugator := v * t.conjugator }

theorem word_conjugateTerms (b : J → W) (v : W) (l : List (Term W J)) :
    word b (conjugateTerms v l) = v * word b l * v⁻¹ := by
  induction l with
  | nil => simp [conjugateTerms]
  | cons t l ih =>
    change (v * t.conjugator * b t.index ^ t.exponent * (v * t.conjugator)⁻¹) *
      word b (conjugateTerms v l) = v * (termWord b t * word b l) * v⁻¹
    rw [ih]
    simp [termWord, mul_assoc]

def finiteNormalWords (b : J → W) : Subgroup W where
  carrier := { w | ∃ l : List (Term W J), word b l = w }
  one_mem' := ⟨[], rfl⟩
  mul_mem' := by
    rintro x y ⟨l, rfl⟩ ⟨k, rfl⟩
    exact ⟨l ++ k, word_append b l k⟩
  inv_mem' := by
    rintro x ⟨l, rfl⟩
    exact ⟨inverseTerms l, word_inverseTerms b l⟩

instance finiteNormalWords_normal (b : J → W) : (finiteNormalWords b).Normal where
  conj_mem := by
    rintro n ⟨l, rfl⟩ v
    exact ⟨conjugateTerms v l, word_conjugateTerms b v l⟩

theorem finite_normal_expression (b : J → W) {w : W}
    (hw : w ∈ Subgroup.normalClosure (Set.range b)) :
    ∃ l : List (Term W J), word b l = w := by
  apply (Subgroup.normalClosure_le_normal (N := finiteNormalWords b) ?_) hw
  rintro x ⟨j, rfl⟩
  exact ⟨[⟨1, j, 1⟩], by simp [termWord]⟩

@[simp] theorem counts_nil : counts e ([] : List (Term W J)) = 0 := rfl

@[simp] theorem counts_cons (t : Term W J) (l : List (Term W J)) :
    counts e (t :: l) = Finsupp.single t.index
      (MonoidAlgebra.single (e t.conjugator) t.exponent) + counts e l := rfl

@[simp] theorem counts_append (l k : List (Term W J)) :
    counts e (l ++ k) = counts e l + counts e k := by
  simp [counts]

theorem counts_surjective (he : Function.Surjective e) :
    Function.Surjective (counts e : List (Term W J) → FreeModule G J) := by
  intro x
  induction x using Finsupp.induction_linear with
  | zero => exact ⟨[], rfl⟩
  | add x y hx hy =>
    obtain ⟨l, rfl⟩ := hx
    obtain ⟨k, rfl⟩ := hy
    exact ⟨l ++ k, counts_append _ _⟩
  | single j a =>
    induction a using MonoidAlgebra.induction_linear with
    | zero => exact ⟨[], by simp⟩
    | add a b ha hb =>
      obtain ⟨l, hl⟩ := ha
      obtain ⟨k, hk⟩ := hb
      exact ⟨l ++ k, by simp [hl, hk, Finsupp.single_add]⟩
    | single g n =>
      obtain ⟨v, hv⟩ := he g
      exact ⟨[⟨v, j, n⟩], by simp [hv]⟩

theorem eval_termWord (b : J → W) (hb : ∀ j, e (b j) = 1) (t : Term W J) :
    e (termWord b t) = 1 := by
  simp [termWord, hb]

theorem eval_word (b : J → W) (hb : ∀ j, e (b j) = 1) (l : List (Term W J)) :
    e (word b l) = 1 := by
  induction l with
  | nil => simp
  | cons t l ih => simp [eval_termWord, hb, ih]

theorem single_smul_chain (g : G) (n : ℤ) (m : M) :
    (MonoidAlgebra.single g n : RingOf G) • m = delta g • (n • m) := by
  have h : (MonoidAlgebra.single g n : RingOf G) = n • delta g := by
    simp [delta, zsmul_eq_mul, MonoidAlgebra.intCast_def,
      MonoidAlgebra.single_mul_single]
  rw [h, smul_assoc, smul_comm]

theorem chain_termWord (b : J → W) (hb : ∀ j, e (b j) = 1) (t : Term W J) :
    d.chain (termWord b t) =
      (MonoidAlgebra.single (e t.conjugator) t.exponent : RingOf G) •
        d.chain (b t.index) := by
  rw [termWord, chain_conjugate d (by simp [hb]),
    chain_zpow_closed d (hb t.index), single_smul_chain]

theorem chain_word (b : J → W) (hb : ∀ j, e (b j) = 1) (l : List (Term W J)) :
    d.chain (word b l) = Finsupp.linearCombination (RingOf G) (d.chain ∘ b) (counts e l) := by
  induction l with
  | nil => simp
  | cons t l ih =>
    rw [word_cons, chain_mul_closed d (eval_termWord b hb t), chain_termWord d b hb, ih]
    simp

theorem word_mem_normal (b : J → W) (l : List (Term W J)) (N : Subgroup W)
    [N.Normal] (hb : ∀ j, b j ∈ N) : word b l ∈ N := by
  induction l with
  | nil => exact N.one_mem
  | cons t l ih =>
    apply N.mul_mem _ ih
    exact Subgroup.Normal.conj_mem inferInstance _ (N.zpow_mem (hb t.index) t.exponent) _

abbrev closurePair (a : J → W) (b : K → W) : Subgroup W :=
  Subgroup.normalClosure (Set.range a ∪ Set.range b)

theorem normalClosure_shear (a : J → W) (b : K → W) (l : J → List (Term W K)) :
    closurePair (fun j => a j * word b (l j)) b = closurePair a b := by
  apply le_antisymm
  · apply Subgroup.normalClosure_le_normal
    rintro w (⟨j, rfl⟩ | ⟨k, rfl⟩)
    · apply (closurePair a b).mul_mem
      · exact Subgroup.subset_normalClosure (Or.inl ⟨j, rfl⟩)
      · exact word_mem_normal b (l j) _ (fun k =>
          Subgroup.subset_normalClosure (Or.inr ⟨k, rfl⟩))
    · exact Subgroup.subset_normalClosure (Or.inr ⟨k, rfl⟩)
  · apply Subgroup.normalClosure_le_normal
    rintro w (⟨j, rfl⟩ | ⟨k, rfl⟩)
    · have hnew : a j * word b (l j) ∈ closurePair (fun j => a j * word b (l j)) b :=
        Subgroup.subset_normalClosure (Or.inl ⟨j, rfl⟩)
      have hc : word b (l j) ∈ closurePair (fun j => a j * word b (l j)) b :=
        word_mem_normal b (l j) _ (fun k =>
          Subgroup.subset_normalClosure (Or.inr ⟨k, rfl⟩))
      simpa using (closurePair (fun j => a j * word b (l j)) b).mul_mem hnew
        ((closurePair (fun j => a j * word b (l j)) b).inv_mem hc)
    · exact Subgroup.subset_normalClosure (Or.inr ⟨k, rfl⟩)

theorem closurePair_comm (a : J → W) (b : K → W) :
    closurePair a b = closurePair b a := by
  simp only [closurePair, Set.union_comm]

theorem presentation_expression (a : J → W) (b : K → W)
    (hp : closurePair a b = e.ker) {z : W} (hz : e z = 1) :
    ∃ l : List (Term W (J ⊕ K)), word (Sum.elim a b) l = z := by
  have hr : Set.range (Sum.elim a b) = Set.range a ∪ Set.range b := by
    ext w
    constructor
    · rintro ⟨j | k, rfl⟩
      · exact Or.inl ⟨j, rfl⟩
      · exact Or.inr ⟨k, rfl⟩
    · rintro (⟨j, rfl⟩ | ⟨k, rfl⟩)
      · exact ⟨Sum.inl j, rfl⟩
      · exact ⟨Sum.inr k, rfl⟩
  apply finite_normal_expression
  rw [hr]
  change z ∈ closurePair a b
  rw [hp]
  exact hz

theorem shear_first (he : Function.Surjective e)
    (a : J → W) (b : K → W) (ha : ∀ j, e (a j) = 1) (hb : ∀ k, e (b k) = 1)
    (c : J → FreeModule G K) :
    ∃ a' : J → W, (∀ j, e (a' j) = 1) ∧
      (∀ j, d.chain (a' j) = d.chain (a j) +
        Finsupp.linearCombination (RingOf G) (d.chain ∘ b) (c j)) ∧
      closurePair a' b = closurePair a b := by
  choose l hl using fun j => counts_surjective (J := K) he (c j)
  refine ⟨fun j => a j * word b (l j), ?_, ?_, normalClosure_shear a b l⟩
  · intro j
    simp [ha, eval_word b hb]
  · intro j
    rw [chain_mul_closed d (ha j), chain_word d b hb, hl]

theorem shear_second (he : Function.Surjective e)
    (a : J → W) (b : K → W) (ha : ∀ j, e (a j) = 1) (hb : ∀ k, e (b k) = 1)
    (c : K → FreeModule G J) :
    ∃ b' : K → W, (∀ k, e (b' k) = 1) ∧
      (∀ k, d.chain (b' k) = d.chain (b k) +
        Finsupp.linearCombination (RingOf G) (d.chain ∘ a) (c k)) ∧
      closurePair a b' = closurePair a b := by
  obtain ⟨b', hv, hd, hn⟩ := shear_first d he b a hb ha c
  exact ⟨b', hv, hd, by simpa only [closurePair_comm a] using hn⟩

theorem linearCombination_eq (L : FreeModule G J →ₗ[RingOf G] M)
    (f : J → M) (hf : ∀ j, f j = L (Finsupp.single j 1)) :
    Finsupp.linearCombination (RingOf G) f = L := by
  apply Finsupp.lhom_ext
  intro j c
  rw [Finsupp.linearCombination_single, hf]
  simpa [Finsupp.smul_single] using (L.map_smul c (Finsupp.single j 1)).symm

variable {R I D T : Type*}

def alignedEquiv (A : FreeModule G R ≃ₗ[RingOf G] FreeModule G I) :
    (FreeModule G R × FreeModule G I) ≃ₗ[RingOf G]
      (FreeModule G I × FreeModule G I) where
  toFun x := (x.2, -A x.1)
  invFun y := (-A.symm y.2, y.1)
  left_inv x := by simp
  right_inv y := by simp
  map_add' x y := by simp [add_comm]
  map_smul' c x := by simp

def ordinaryEquiv (A : FreeModule G R ≃ₗ[RingOf G] FreeModule G I) :
    (FreeModule G T × FreeModule G R) ≃ₗ[RingOf G]
      (FreeModule G T × FreeModule G I) where
  toFun x := (x.1, -A x.2)
  invFun y := (y.1, -A.symm y.2)
  left_inv x := by simp
  right_inv y := by simp
  map_add' x y := by simp [add_comm]
  map_smul' c x := by simp

theorem three_word_shears
    (d : PathChain e M)
    (he : Function.Surjective e)
    (A : FreeModule G R ≃ₗ[RingOf G] FreeModule G I)
    (C : (FreeModule G I × FreeModule G I) →ₗ[RingOf G] M)
    (a : R → W) (b : I → W)
    (ha : ∀ r, e (a r) = 1) (hb : ∀ i, e (b i) = 1)
    (hda : ∀ r, d.chain (a r) = C (A (Finsupp.single r 1), 0))
    (hdb : ∀ i, d.chain (b i) = C (0, Finsupp.single i 1)) :
    ∃ a' : R → W, ∃ b' : I → W,
      (∀ r, e (a' r) = 1) ∧ (∀ i, e (b' i) = 1) ∧
      (∀ r, d.chain (a' r) = C (0, -A (Finsupp.single r 1))) ∧
      (∀ i, d.chain (b' i) = C (Finsupp.single i 1, 0)) ∧
      closurePair a' b' = closurePair a b := by
  have hla : Finsupp.linearCombination (RingOf G) (d.chain ∘ a) =
      C.comp (A.toLinearMap.prod (0 : FreeModule G R →ₗ[RingOf G] FreeModule G I)) :=
    linearCombination_eq _ _ hda
  obtain ⟨b₁, hb₁, hdb₁, hn₁⟩ := shear_second d he a b ha hb
    (fun i => A.symm (Finsupp.single i 1))
  have hdb₁' : ∀ i, d.chain (b₁ i) = C (Finsupp.single i 1, Finsupp.single i 1) := by
    intro i
    rw [hdb₁, hdb, hla]
    change C (0, Finsupp.single i 1) + C (A (A.symm (Finsupp.single i 1)), 0) = _
    rw [← map_add]
    simp
  have hlb₁ : Finsupp.linearCombination (RingOf G) (d.chain ∘ b₁) =
      C.comp ((LinearMap.id : FreeModule G I →ₗ[RingOf G] FreeModule G I).prod
        LinearMap.id) :=
    linearCombination_eq _ _ hdb₁'
  obtain ⟨a₂, ha₂, hda₂, hn₂⟩ := shear_first d he a b₁ ha hb₁
    (fun r => -A (Finsupp.single r 1))
  have hda₂' : ∀ r, d.chain (a₂ r) = C (0, -A (Finsupp.single r 1)) := by
    intro r
    rw [hda₂, hda, hlb₁]
    change C (A (Finsupp.single r 1), 0) +
      C (-A (Finsupp.single r 1), -A (Finsupp.single r 1)) = _
    rw [← map_add]
    simp
  have hla₂ : Finsupp.linearCombination (RingOf G) (d.chain ∘ a₂) =
      C.comp ((0 : FreeModule G R →ₗ[RingOf G] FreeModule G I).prod
        (-A.toLinearMap)) :=
    linearCombination_eq _ _ hda₂'
  obtain ⟨b₃, hb₃, hdb₃, hn₃⟩ := shear_second d he a₂ b₁ ha₂ hb₁
    (fun i => A.symm (Finsupp.single i 1))
  refine ⟨a₂, b₃, ha₂, hb₃, hda₂', ?_, hn₃.trans (hn₂.trans hn₁)⟩
  intro i
  rw [hdb₃, hdb₁', hla₂]
  change C (Finsupp.single i 1, Finsupp.single i 1) +
    C (0, -A (A.symm (Finsupp.single i 1))) = _
  rw [← map_add]
  simp

theorem exact_translated_counts
    (b : J → W) (hb : ∀ j, e (b j) = 1)
    (hinj : Function.Injective (Finsupp.linearCombination (RingOf G) (d.chain ∘ b)))
    (l : List (Term W J)) (z : W) (j₀ : J)
    (hword : word b l = z) (hchain : d.chain z = d.chain (b j₀)) :
    counts e l = Finsupp.single j₀ 1 := by
  apply hinj
  rw [← chain_word d b hb, hword, hchain]
  simp

@[simp] theorem split_single_inl (j : J) (c : RingOf G) :
    Finsupp.sumFinsuppLEquivProdFinsupp (RingOf G)
      (Finsupp.single (Sum.inl j : J ⊕ K) c) = (Finsupp.single j c, 0) := by
  classical
  apply Prod.ext
  · ext k
    simp [Finsupp.single_apply]
  · ext k
    simp

@[simp] theorem split_single_inr (k : K) (c : RingOf G) :
    Finsupp.sumFinsuppLEquivProdFinsupp (RingOf G)
      (Finsupp.single (Sum.inr k : J ⊕ K) c) = (0, Finsupp.single k c) := by
  classical
  apply Prod.ext
  · ext j
    simp
  · ext j
    simp [Finsupp.single_apply]

def fullEquiv (A : FreeModule G R ≃ₗ[RingOf G] FreeModule G I) :
    FreeModule G (R ⊕ I) ≃ₗ[RingOf G] (FreeModule G I × FreeModule G I) :=
  (Finsupp.sumFinsuppLEquivProdFinsupp (RingOf G)).trans (alignedEquiv A)

theorem complete_boundary_isomorphism
    (d : PathChain e M)
    (A : FreeModule G R ≃ₗ[RingOf G] FreeModule G I)
    (C : (FreeModule G I × FreeModule G I) →ₗ[RingOf G] M)
    (a : R → W) (b : I → W)
    (ha : ∀ r, d.chain (a r) = C (0, -A (Finsupp.single r 1)))
    (hb : ∀ i, d.chain (b i) = C (Finsupp.single i 1, 0)) :
    Finsupp.linearCombination (RingOf G) (d.chain ∘ Sum.elim a b) =
      C.comp (fullEquiv A).toLinearMap := by
  apply linearCombination_eq
  intro j
  cases j with
  | inl r => simp [ha, fullEquiv, alignedEquiv]
  | inr i => simp [hb, fullEquiv, alignedEquiv]

theorem complete_boundary_basis
    (A : FreeModule G R ≃ₗ[RingOf G] FreeModule G I)
    (C : (FreeModule G I × FreeModule G I) →ₗ[RingOf G] M)
    (hC : Function.Injective C) :
    Function.Injective (C.comp (fullEquiv A).toLinearMap) ∧
      LinearMap.range (C.comp (fullEquiv A).toLinearMap) = LinearMap.range C := by
  refine ⟨hC.comp (fullEquiv A).injective, ?_⟩
  ext m
  constructor
  · rintro ⟨x, hx⟩
    exact ⟨fullEquiv A x, hx⟩
  · rintro ⟨x, hx⟩
    exact ⟨(fullEquiv A).symm x, by simpa using hx⟩

def projectOrdinary :
    (FreeModule G (D ⊕ T) × FreeModule G (D ⊕ T)) →ₗ[RingOf G]
      (FreeModule G T × FreeModule G (D ⊕ T)) where
  toFun x := ((Finsupp.sumFinsuppLEquivProdFinsupp (RingOf G) x.1).2, x.2)
  map_add' x y := by
    change ((Finsupp.sumFinsuppLEquivProdFinsupp (RingOf G) (x.1 + y.1)).2,
      x.2 + y.2) = _
    rw [map_add]
    rfl
  map_smul' c x := by simp

def ordinaryWords (a : R → W) (b : D ⊕ T → W) : T ⊕ R → W :=
  Sum.elim (fun t => b (Sum.inr t)) a

theorem ordinary_projection_isomorphism
    (d : PathChain e M)
    (A : FreeModule G R ≃ₗ[RingOf G] FreeModule G (D ⊕ T))
    (C : (FreeModule G (D ⊕ T) × FreeModule G (D ⊕ T)) →ₗ[RingOf G] M)
    (p : M →ₗ[RingOf G] (FreeModule G T × FreeModule G (D ⊕ T)))
    (hp : p.comp C = projectOrdinary)
    (a : R → W) (b : D ⊕ T → W)
    (ha : ∀ r, d.chain (a r) = C (0, -A (Finsupp.single r 1)))
    (hb : ∀ i, d.chain (b i) = C (Finsupp.single i 1, 0)) :
    Finsupp.linearCombination (RingOf G)
      (p ∘ d.chain ∘ ordinaryWords a b) =
      ((Finsupp.sumFinsuppLEquivProdFinsupp (RingOf G)).trans
        (ordinaryEquiv A)).toLinearMap := by
  apply linearCombination_eq
  have hpc (x) : p (C x) = projectOrdinary x :=
    congrArg (fun f : _ →ₗ[RingOf G] _ => f x) hp
  intro j
  cases j with
  | inl t =>
    simp [Function.comp_def, ordinaryWords, hb, hpc, projectOrdinary, ordinaryEquiv]
  | inr r =>
    simp [Function.comp_def, ordinaryWords, ha, hpc, projectOrdinary, ordinaryEquiv]

theorem presentation_alignment
    (d : PathChain e M)
    (he : Function.Surjective e)
    (A : FreeModule G R ≃ₗ[RingOf G] FreeModule G (D ⊕ T))
    (C : (FreeModule G (D ⊕ T) × FreeModule G (D ⊕ T)) →ₗ[RingOf G] M)
    (hC : Function.Injective C)
    (p : M →ₗ[RingOf G] (FreeModule G T × FreeModule G (D ⊕ T)))
    (hp : p.comp C = projectOrdinary)
    (a : R → W) (b : D ⊕ T → W)
    (ha : ∀ r, e (a r) = 1) (hb : ∀ i, e (b i) = 1)
    (hda : ∀ r, d.chain (a r) = C (A (Finsupp.single r 1), 0))
    (hdb : ∀ i, d.chain (b i) = C (0, Finsupp.single i 1))
    (hpres : closurePair a b = e.ker) :
    ∃ a' : R → W, ∃ b' : D ⊕ T → W,
      (∀ r, e (a' r) = 1) ∧ (∀ i, e (b' i) = 1) ∧
      (∀ r, d.chain (a' r) = C (0, -A (Finsupp.single r 1))) ∧
      (∀ i, d.chain (b' i) = C (Finsupp.single i 1, 0)) ∧
      closurePair a' b' = e.ker ∧
      Finsupp.linearCombination (RingOf G) (d.chain ∘ Sum.elim a' b') =
        C.comp (fullEquiv A).toLinearMap ∧
      Function.Injective (Finsupp.linearCombination (RingOf G)
        (d.chain ∘ Sum.elim a' b')) ∧
      LinearMap.range (Finsupp.linearCombination (RingOf G)
        (d.chain ∘ Sum.elim a' b')) = LinearMap.range C ∧
      Finsupp.linearCombination (RingOf G)
        (p ∘ d.chain ∘ ordinaryWords a' b') =
        ((Finsupp.sumFinsuppLEquivProdFinsupp (RingOf G)).trans
          (ordinaryEquiv A)).toLinearMap ∧
      (∀ (l : List (Term W (R ⊕ (D ⊕ T)))) (z : W) (j₀ : R ⊕ (D ⊕ T)),
        word (Sum.elim a' b') l = z →
        d.chain z = d.chain (Sum.elim a' b' j₀) →
        counts e l = Finsupp.single j₀ 1) := by
  obtain ⟨a', b', ha', hb', hda', hdb', hn⟩ :=
    three_word_shears d he A C a b ha hb hda hdb
  have hfull := complete_boundary_isomorphism d A C a' b' hda' hdb'
  obtain ⟨hinj, hrange⟩ := complete_boundary_basis A C hC
  refine ⟨a', b', ha', hb', hda', hdb', hn.trans hpres, hfull,
    hfull ▸ hinj, hfull ▸ hrange,
    ordinary_projection_isomorphism d A C p hp a' b' hda' hdb', ?_⟩
  intro l z j₀ hw hc
  apply exact_translated_counts d (Sum.elim a' b') _ _ l z j₀ hw hc
  · intro j
    cases j with
    | inl r => exact ha' r
    | inr i => exact hb' i
  · rw [hfull]
    exact hinj

#print axioms presentation_alignment
#print axioms exact_translated_counts

end RelatorAlignment
