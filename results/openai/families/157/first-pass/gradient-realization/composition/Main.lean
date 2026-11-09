import «research».«gradient-realization».Main
import «research».«gradient-realization».annihilator.Main

set_option autoImplicit false

noncomputable section

open Module LinearMap Function
open BooleanCutAnnihilator

namespace BooleanCutCompression

abbrev Base (m n : ℕ) := Option (Fin m × Fin n) → F
abbrev Primal (p m n : ℕ) := (Fin p × Option (Fin m × Fin n)) → F
abbrev Block (n : ℕ) := Fin n → F

variable {p m n : ℕ}

def slice (s : Fin p) (b : Fin m) : Primal p m n →ₗ[F] Block n :=
  LinearMap.pi fun k => LinearMap.proj (s, some (b, k))

def insertBlock (s : Fin p) (b : Fin m) : Block n →ₗ[F] Primal p m n where
  toFun v q := if q.1 = s then
    match q.2 with
    | none => 0
    | some (c, k) => if c = b then v k else 0
    else 0
  map_add' v w := by
    funext ⟨t, q⟩
    cases q with
    | none => simp
    | some q =>
      by_cases ht : t = s <;> by_cases hb : q.1 = b <;> simp [ht, hb]
  map_smul' a v := by
    funext ⟨t, q⟩
    cases q with
    | none => simp
    | some q =>
      by_cases ht : t = s <;> by_cases hb : q.1 = b <;> simp [ht, hb]

def compressBase (T : Fin m → Block n →ₗ[F] Block n) :
    Base m n →ₗ[F] Base m n where
  toFun v q := match q with
    | none => v none
    | some (b, k) => T b (fun j => v (some (b, j))) k
  map_add' v w := by
    ext q
    cases q with
    | none => rfl
    | some q =>
      exact congrFun ((T q.1).map_add
        (fun j => v (some (q.1, j))) (fun j => w (some (q.1, j)))) q.2
  map_smul' a v := by
    ext q
    cases q with
    | none => rfl
    | some q =>
      exact congrFun ((T q.1).map_smul a (fun j => v (some (q.1, j)))) q.2

def compressPrimal (T : Fin m → Block n →ₗ[F] Block n) :
    Primal p m n →ₗ[F] Primal p m n where
  toFun v q := match q.2 with
    | none => v (q.1, none)
    | some (b, k) => T b (slice q.1 b v) k
  map_add' v w := by
    ext ⟨s, q⟩
    cases q with
    | none => rfl
    | some q => simp [map_add]
  map_smul' a v := by
    ext ⟨s, q⟩
    cases q with
    | none => rfl
    | some q => simp [map_smul]

@[simp] theorem slice_insertBlock (s t : Fin p) (b c : Fin m) (v : Block n) :
    slice t c (insertBlock s b v) = if t = s ∧ c = b then v else 0 := by
  ext k
  by_cases ht : t = s <;> by_cases hb : c = b <;>
    simp [slice, insertBlock, ht, hb]

@[simp] theorem slice_constant (s t : Fin p) (a : F) (b : Fin m) :
    slice t b (Pi.single (s, none) a : Primal p m n) = 0 := by
  ext k
  simp [slice, Pi.single_apply]

@[simp] theorem compress_constant (T : Fin m → Block n →ₗ[F] Block n)
    (s : Fin p) (a : F) :
    compressPrimal T (Pi.single (s, none) a : Primal p m n) =
      Pi.single (s, none) a := by
  ext ⟨t, q⟩
  cases q with
  | none => rfl
  | some q => simp [compressPrimal, Pi.single_apply]

@[simp] theorem compress_insertBlock (T : Fin m → Block n →ₗ[F] Block n)
    (s : Fin p) (b : Fin m) (v : Block n) :
    compressPrimal T (insertBlock s b v) = insertBlock s b (T b v) := by
  ext ⟨t, q⟩
  cases q with
  | none => simp [compressPrimal, insertBlock]
  | some q =>
    rcases q with ⟨c, k⟩
    change T c (slice t c (insertBlock s b v)) k =
      if t = s then if c = b then T b v k else 0 else 0
    rw [slice_insertBlock]
    by_cases ht : t = s <;> by_cases hc : c = b <;> simp [ht, hc]

@[simp] theorem insertBlock_single (s : Fin p) (b : Fin m) (k : Fin n) (a : F) :
    insertBlock s b (Pi.single k a) = Pi.single (s, some (b, k)) a := by
  ext ⟨t, q⟩
  cases q with
  | none => simp [insertBlock, Pi.single_apply]
  | some q =>
    rcases q with ⟨c, j⟩
    by_cases ht : t = s
    · subst t
      by_cases hc : c = b
      · subst c
        simp [insertBlock, Pi.single_apply]
      · simp [insertBlock, Pi.single_apply, hc]
    · simp [insertBlock, Pi.single_apply, ht]

theorem fixes_vector (T : Fin m → Block n →ₗ[F] Block n) (v : Primal p m n)
    (h : ∀ s b, T b (slice s b v) = slice s b v) :
    compressPrimal T v = v := by
  ext ⟨s, q⟩
  cases q with
  | none => rfl
  | some q => exact congrFun (h s q.1) q.2

theorem preserves_form (T : Fin m → Block n →ₗ[F] Block n)
    (f : Module.Dual F (Primal p m n))
    (h : ∀ s b, (f.comp (insertBlock s b)).comp (T b) = f.comp (insertBlock s b)) :
    f.comp (compressPrimal T) = f := by
  apply LinearMap.pi_ext
  rintro ⟨s, q⟩ a
  change f (compressPrimal T (Pi.single (s, q) a)) = f (Pi.single (s, q) a)
  cases q with
  | none => rw [compress_constant]
  | some q =>
    rcases q with ⟨b, k⟩
    rw [← insertBlock_single, compress_insertBlock]
    exact LinearMap.congr_fun (h s b) (Pi.single k a)

section Construction

variable {U A : Type} [Fintype U] [Fintype A]

def expandedVectors (v : U → Primal p m n) (b : Fin m) :
    (U × Fin p → F) →ₗ[F] Block n :=
  ∑ q, (LinearMap.proj q).smulRight (slice q.2 b (v q.1))

def expandedForms (f : A → Module.Dual F (Primal p m n)) (b : Fin m) :
    Block n →ₗ[F] (A × Fin p → F) :=
  LinearMap.pi fun q => (f q.1).comp (insertBlock q.2 b)

theorem blockwise_compression
    (v : U → Primal p m n) (f : A → Module.Dual F (Primal p m n)) :
    ∃ T : Fin m → Block n →ₗ[F] Block n,
      (∀ u, compressPrimal T (v u) = v u) ∧
      (∀ a, (f a).comp (compressPrimal T) = f a) ∧
      (∀ b, finrank F (range (T b)) ≤ p * (Fintype.card U + Fintype.card A)) := by
  classical
  have hb (b : Fin m) :
      ∃ T : Block n →ₗ[F] Block n,
        (∀ x : range (expandedVectors v b), T x = x) ∧
        (expandedForms f b).comp T = expandedForms f b ∧
        finrank F (range T) ≤ p * (Fintype.card U + Fintype.card A) := by
    obtain ⟨T, hfix, hforms, hr⟩ :=
      ProtectedChannels.compression (range (expandedVectors v b)) (expandedForms f b)
    have hv : finrank F (range (expandedVectors v b)) ≤ Fintype.card U * p := by
      simpa using (expandedVectors v b).finrank_range_le
    have hf : finrank F (range (expandedForms f b)) ≤ Fintype.card A * p := by
      simpa using (Submodule.finrank_le (range (expandedForms f b)))
    refine ⟨T, hfix, hforms, ?_⟩
    calc
      finrank F (range T) ≤ Fintype.card U * p + Fintype.card A * p :=
        hr.trans (Nat.add_le_add hv hf)
      _ = p * (Fintype.card U + Fintype.card A) := by ring
  choose T hfix hforms hr using hb
  refine ⟨T, ?_, ?_, hr⟩
  · intro u
    apply fixes_vector
    intro s b
    have hm : slice s b (v u) ∈ range (expandedVectors v b) := by
      refine ⟨Pi.single (u, s) 1, ?_⟩
      simp [expandedVectors, LinearMap.smulRight_apply, Pi.single_apply]
    exact hfix b ⟨_, hm⟩
  · intro a
    apply preserves_form
    intro s b
    apply LinearMap.ext
    intro x
    exact congrFun (LinearMap.congr_fun (hforms b) x) (a, s)

theorem primal_rank (T : Fin m → Block n →ₗ[F] Block n) (d : ℕ)
    (h : ∀ b, finrank F (range (T b)) ≤ d) :
    finrank F (range (compressPrimal (p := p) T)) ≤ p * (1 + m * d) := by
  let Z := Fin p → F × (∀ b, range (T b))
  let a : Primal p m n →ₗ[F] Z :=
    LinearMap.pi fun s =>
      (LinearMap.proj (s, none)).prod
        (LinearMap.pi fun b => (T b).rangeRestrict.comp (slice s b))
  let b : Z →ₗ[F] Primal p m n := {
    toFun := fun z q => match q.2 with
      | none => (z q.1).1
      | some (c, k) => ((z q.1).2 c : Block n) k
    map_add' := by intros z w; funext ⟨s, q⟩; cases q <;> rfl
    map_smul' := by intros c z; funext ⟨s, q⟩; cases q <;> rfl }
  have he : compressPrimal (p := p) T = b.comp a := by
    apply LinearMap.ext
    intro x
    funext ⟨s, q⟩
    cases q <;> rfl
  have hs : ∑ b, finrank F (range (T b)) ≤ m * d := by
    calc
      (∑ b, finrank F (range (T b))) ≤ ∑ _ : Fin m, d :=
        Finset.sum_le_sum (fun b _ => h b)
      _ = m * d := by simp
  rw [he]
  calc
    finrank F (range (b.comp a)) ≤ finrank F Z :=
      (ProtectedChannels.finrank_comp_left b a).trans b.finrank_range_le
    _ = p * (1 + ∑ b, finrank F (range (T b))) := by
      simp [Z, Module.finrank_pi_fintype, Module.finrank_prod]
    _ ≤ p * (1 + m * d) := Nat.mul_le_mul_left _ (Nat.add_le_add_left hs _)

end Construction

section Domain

variable {Tag Γ : Type} [DecidableEq Tag] [DecidableEq Γ]

def embed (selectors : Γ → Fin p → F) (s : Γ) :
    Base m n →ₗ[F] Primal p m n where
  toFun v q := selectors s q.1 * v q.2
  map_add' v w := by ext q; simp [mul_add]
  map_smul' c v := by ext q; simp [mul_left_comm]

def allowed (blocked : Tag → Fin m → Prop) :
    Tag → Γ → Base m n → Prop :=
  fun t _ v => ∀ b, blocked t b → ∀ k, v (some (b, k)) = 0

theorem compress_embed (T : Fin m → Block n →ₗ[F] Block n)
    (selectors : Γ → Fin p → F) (s : Γ) (v : Base m n) :
    compressPrimal T (embed selectors s v) =
      embed selectors s (compressBase T v) := by
  ext ⟨a, q⟩
  cases q with
  | none => rfl
  | some q =>
    rcases q with ⟨b, k⟩
    change T b (selectors s a • (fun j => v (some (b, j)))) k = _
    rw [map_smul]
    rfl

theorem compress_allowed (T : Fin m → Block n →ₗ[F] Block n)
    (blocked : Tag → Fin m → Prop) (t : Tag) (s : Γ) (v : Base m n)
    (h : allowed blocked t s v) : allowed blocked t s (compressBase T v) := by
  intro b hb k
  have hz : (fun j => v (some (b, j))) = 0 := funext (h b hb)
  change T b (fun j => v (some (b, j))) k = 0
  rw [hz, map_zero]
  rfl

def moments (selectors : Γ → Fin p → F) (blocked : Tag → Fin m → Prop) :
    Tag → Submodule F (Tensor (Primal p m n)) :=
  tagMomentSpace none (embed selectors) (allowed blocked)

def cuts (selectors : Γ → Fin p → F) (blocked : Tag → Fin m → Prop) :
    Submodule F (Profile Tag (Primal p m n)) :=
  cutSpace (moments selectors blocked)

theorem preserves_moments (T : Fin m → Block n →ₗ[F] Block n)
    (selectors : Γ → Fin p → F) (blocked : Tag → Fin m → Prop)
    (t : Tag) (M : Tensor (Primal p m n))
    (hM : M ∈ moments selectors blocked t) :
    push (compressPrimal T) M ∈ moments selectors blocked t := by
  change M ∈ Submodule.span F _ at hM
  induction hM using Submodule.span_induction with
  | mem M h =>
    obtain ⟨s, v, hv, ho, rfl⟩ := h
    rw [push_square, compress_embed]
    exact Submodule.subset_span
      ⟨s, compressBase T v, compress_allowed T blocked t s v hv, ho, rfl⟩
  | zero => simp
  | add M N hM hN ihM ihN =>
    rw [push_add]
    exact Submodule.add_mem _ ihM ihN
  | smul a M hM ihM =>
    rw [push_smul]
    exact Submodule.smul_mem _ a ihM

def compressProfile (T : Fin m → Block n →ₗ[F] Block n) :
    Profile Tag (Primal p m n) →ₗ[F] Profile Tag (Primal p m n) where
  toFun x a b := push (compressPrimal T) (x a b)
  map_add' x y := by funext a b; exact push_add _ _ _
  map_smul' c x := by funext a b; exact push_smul _ _ _

theorem preserves_cuts (T : Fin m → Block n →ₗ[F] Block n)
    (selectors : Γ → Fin p → F) (blocked : Tag → Fin m → Prop)
    (x : Profile Tag (Primal p m n)) (hx : x ∈ cuts selectors blocked) :
    compressProfile T x ∈ cuts selectors blocked := by
  obtain ⟨w, hw, hx⟩ := hx
  refine ⟨fun t => push (compressPrimal T) (w t),
    fun t => preserves_moments T selectors blocked t (w t) (hw t), ?_⟩
  intro a b
  change push (compressPrimal T) (x a b) = _
  rw [hx a b, push_add]

def rankOneResponse (f g : Module.Dual F (Primal p m n)) :
    Tensor (Primal p m n) →ₗ[F] F where
  toFun M := f (M g)
  map_add' M N := by simp
  map_smul' c M := by simp

theorem residual_atom_invariant (T : Fin m → Block n →ₗ[F] Block n)
    (f g : Module.Dual F (Primal p m n))
    (hf : f.comp (compressPrimal T) = f) (hg : g.comp (compressPrimal T) = g)
    (M : Tensor (Primal p m n)) :
    rankOneResponse f g (push (compressPrimal T) M) = rankOneResponse f g M := by
  change f (compressPrimal T (M (g.comp (compressPrimal T)))) = f (M g)
  rw [hg]
  exact LinearMap.congr_fun hf (M g)

end Domain

section NominalCompression

variable {B H : Type} [AddCommGroup B] [Module F B]
variable [AddCommGroup H] [Module F H]

def onPrimals (C : Fin 2 → B →ₗ[F] B) : (Fin 2 → B) →ₗ[F] (Fin 2 → B) :=
  LinearMap.pi fun i => (C i).comp (LinearMap.proj i)

def onNominal (C : Fin 2 → B →ₗ[F] B) :
    Nominal (J := Fin 2) (B := B) (H := H) →ₗ[F]
      Nominal (J := Fin 2) (B := B) (H := H) :=
  ((onPrimals C).comp (LinearMap.fst F _ _)).prod (LinearMap.snd F _ _)

theorem fixes_span {A : Type} (C : B →ₗ[F] B) (v : A → B)
    (h : ∀ a, C (v a) = v a) :
    ∀ x ∈ Submodule.span F (Set.range v), C x = x := by
  have hs : Submodule.span F (Set.range v) ≤ ker (C - LinearMap.id) := by
    apply Submodule.span_le.mpr
    rintro _ ⟨a, rfl⟩
    simp [h a]
  intro x hx
  exact sub_eq_zero.mp (mem_ker.mp (hs hx))

theorem fixes_nominal (C : Fin 2 → B →ₗ[F] B)
    (x : Nominal (J := Fin 2) (B := B) (H := H))
    (h : ∀ i, C i (x.1 i) = x.1 i) :
    onNominal C x = x := by
  apply Prod.ext
  · exact funext h
  · rfl

theorem fixes_frozen (C : Fin 2 → B →ₗ[F] B)
    (D : Submodule F (Nominal (J := Fin 2) (B := B) (H := H)))
    (keys : Fin 2 → Submodule F B) (Tpriv : Fin 2 → Submodule F H)
    (hD : ∀ x ∈ D, ∀ i, C i (x.1 i) = x.1 i)
    (hkeys : ∀ i x, x ∈ keys i → C i x = x) :
    ∀ x ∈ frozen D keys Tpriv, onNominal C x = x := by
  intro x hx
  obtain ⟨d, hd, t, ht, rfl⟩ := Submodule.mem_sup.mp hx
  obtain ⟨a, ha, k, hk, rfl⟩ := Submodule.mem_sup.mp hd
  have ha' := fixes_nominal C a (hD a ha)
  have hk' := fixes_nominal C k (fun i => hkeys i _ (hk.1 i))
  have ht' : onNominal C t = t := by
    apply fixes_nominal
    intro i
    have hz : t.1 i = 0 := ht.1 i
    simp [hz]
  rw [map_add, map_add, ha', hk', ht']

def quotientCompression
    (S : Submodule F (Nominal (J := Fin 2) (B := B) (H := H)))
    (C : Fin 2 → B →ₗ[F] B)
    (h : ∀ x ∈ S, onNominal C x ∈ S) :
    (Nominal (J := Fin 2) (B := B) (H := H) ⧸ S) →ₗ[F]
      (Nominal (J := Fin 2) (B := B) (H := H) ⧸ S) :=
  S.mapQ S (onNominal C) h

theorem quotient_natural
    (S : Submodule F (Nominal (J := Fin 2) (B := B) (H := H)))
    (C : Fin 2 → B →ₗ[F] B) (h : ∀ x ∈ S, onNominal C x ∈ S) :
    (quotientCompression S C h).comp S.mkQ = S.mkQ.comp (onNominal C) := by
  apply LinearMap.ext
  intro x
  exact S.mapQ_apply S (onNominal C) (h := h) x

theorem primals_rank [FiniteDimensional F B]
    (C : Fin 2 → B →ₗ[F] B) (d : ℕ)
    (h : ∀ i, finrank F (range (C i)) ≤ d) :
    finrank F (range (onPrimals C)) ≤ 2 * d := by
  let a : (Fin 2 → B) →ₗ[F] (∀ i, range (C i)) :=
    LinearMap.pi fun i => (C i).rangeRestrict.comp (LinearMap.proj i)
  let b : (∀ i, range (C i)) →ₗ[F] (Fin 2 → B) :=
    LinearMap.pi fun i => (range (C i)).subtype.comp (LinearMap.proj i)
  have he : onPrimals C = b.comp a := rfl
  rw [he]
  calc
    finrank F (range (b.comp a)) ≤ finrank F (∀ i, range (C i)) :=
      (ProtectedChannels.finrank_comp_left b a).trans b.finrank_range_le
    _ = ∑ i, finrank F (range (C i)) := Module.finrank_pi_fintype F
    _ ≤ ∑ _ : Fin 2, d := Finset.sum_le_sum (fun i _ => h i)
    _ = 2 * d := by simp

theorem quotient_rank [FiniteDimensional F B] [FiniteDimensional F H]
    (S : Submodule F (Nominal (J := Fin 2) (B := B) (H := H)))
    (C : Fin 2 → B →ₗ[F] B) (hS : ∀ x ∈ S, onNominal C x ∈ S)
    (Tpriv : Submodule F (Fin 2 → H)) (d k : ℕ)
    (hprivate : ∀ x ∈ Tpriv, ((0, x) : Nominal (J := Fin 2) (B := B) (H := H)) ∈ S)
    (hC : ∀ i, finrank F (range (C i)) ≤ d)
    (hchannel : finrank F ((Fin 2 → H) ⧸ Tpriv) ≤ k) :
    finrank F (range (quotientCompression S C hS)) ≤ 2 * d + k := by
  let P := Fin 2 → B
  let Q := Fin 2 → H
  let f : P →ₗ[F] ((P × Q) ⧸ S) :=
    S.mkQ.comp ((LinearMap.inl F P Q).comp (onPrimals C))
  let g : Q →ₗ[F] ((P × Q) ⧸ S) := S.mkQ.comp (LinearMap.inr F P Q)
  have hg : Tpriv ≤ ker g := by
    intro x hx
    exact (Submodule.Quotient.mk_eq_zero S).mpr (hprivate x hx)
  let gbar := Tpriv.liftQ g hg
  have hgbar : g = gbar.comp Tpriv.mkQ := by apply LinearMap.ext; intro x; rfl
  have hgr : finrank F (range g) ≤ k := by
    rw [hgbar]
    exact (ProtectedChannels.finrank_comp_left gbar Tpriv.mkQ).trans
      (gbar.finrank_range_le.trans hchannel)
  have hfr : finrank F (range f) ≤ 2 * d := by
    change finrank F (range ((S.mkQ.comp (LinearMap.inl F P Q)).comp (onPrimals C))) ≤ _
    exact (ProtectedChannels.finrank_comp_right
      (S.mkQ.comp (LinearMap.inl F P Q)) (onPrimals C)).trans (primals_rank C d hC)
  have he : S.mkQ.comp (onNominal C) =
      f.comp (LinearMap.fst F P Q) + g.comp (LinearMap.snd F P Q) := by
    apply LinearMap.ext
    intro x
    change S.mkQ (onPrimals C x.1, x.2) =
      S.mkQ (onPrimals C x.1, 0) + S.mkQ (0, x.2)
    rw [← map_add]
    simp
  have hr : range (quotientCompression S C hS) = range (S.mkQ.comp (onNominal C)) := by
    rw [← quotient_natural S C hS, range_comp, S.range_mkQ, Submodule.map_top]
  rw [hr, he]
  have hsum := ProtectedChannels.finrank_add
    (f.comp (LinearMap.fst F P Q)) (g.comp (LinearMap.snd F P Q))
  have hf' := ProtectedChannels.finrank_comp_left f (LinearMap.fst F P Q)
  have hg' := ProtectedChannels.finrank_comp_left g (LinearMap.snd F P Q)
  exact hsum.trans (Nat.add_le_add (hf'.trans hfr) (hg'.trans hgr))

theorem channel_quotient_bound [FiniteDimensional F H]
    (Pprot Tpriv : Submodule F (Fin 2 → H)) (k : ℕ)
    (h : IsCompl Tpriv Pprot) (hd : finrank F Pprot ≤ k) :
    finrank F ((Fin 2 → H) ⧸ Tpriv) ≤ k := by
  exact (Submodule.quotientEquivOfIsCompl Tpriv Pprot h).finrank_eq.le.trans hd

def channelProduct (T : Fin 2 → Submodule F H) : Submodule F (Fin 2 → H) where
  carrier := {x | ∀ i, x i ∈ T i}
  zero_mem' := fun i => (T i).zero_mem
  add_mem' hx hy := fun i => (T i).add_mem (hx i) (hy i)
  smul_mem' c x hx := fun i => (T i).smul_mem c (hx i)

theorem product_channel_quotient_bound [FiniteDimensional F H]
    (Pprot Tpriv : Fin 2 → Submodule F H) (K : ℕ)
    (hcompl : ∀ i, IsCompl (Tpriv i) (Pprot i))
    (hd : ∀ i, finrank F (Pprot i) ≤ K) :
    finrank F ((Fin 2 → H) ⧸ channelProduct Tpriv) ≤ 2 * K := by
  let t := channelProduct Tpriv
  let q : (Fin 2 → H) →ₗ[F] (∀ i, H ⧸ Tpriv i) :=
    LinearMap.pi fun i => (Tpriv i).mkQ.comp (LinearMap.proj i)
  have hq : t ≤ ker q := by
    intro x hx
    apply (mem_ker).mpr
    funext i
    exact (Submodule.Quotient.mk_eq_zero (Tpriv i)).mpr (hx i)
  let j := t.liftQ q hq
  have hj : Function.Injective j := by
    intro x y hxy
    obtain ⟨a, rfl⟩ := t.mkQ_surjective x
    obtain ⟨b, rfl⟩ := t.mkQ_surjective y
    apply sub_eq_zero.mp
    rw [← map_sub]
    apply (Submodule.Quotient.mk_eq_zero t).mpr
    intro i
    apply (Submodule.Quotient.mk_eq_zero (Tpriv i)).mp
    change (Tpriv i).mkQ (a i - b i) = 0
    rw [map_sub]
    exact sub_eq_zero.mpr (congrFun hxy i)
  calc
    finrank F ((Fin 2 → H) ⧸ t) ≤ finrank F (∀ i, H ⧸ Tpriv i) :=
      LinearMap.finrank_le_finrank_of_injective hj
    _ = ∑ i, finrank F (H ⧸ Tpriv i) := Module.finrank_pi_fintype F
    _ ≤ ∑ _ : Fin 2, K := by
      apply Finset.sum_le_sum
      intro i hi
      exact (Submodule.quotientEquivOfIsCompl (Tpriv i) (Pprot i) (hcompl i)).finrank_eq.le.trans (hd i)
    _ = 2 * K := by simp

theorem push_comp {U V W : Type}
    [AddCommGroup U] [Module F U] [AddCommGroup V] [Module F V]
    [AddCommGroup W] [Module F W]
    (f : U →ₗ[F] V) (g : V →ₗ[F] W) (M : Tensor U) :
    push g (push f M) = push (g.comp f) M := by
  apply LinearMap.ext
  intro φ
  rfl

theorem quotient_tensor_natural
    (S : Submodule F (Nominal (J := Fin 2) (B := B) (H := H)))
    (C : Fin 2 → B →ₗ[F] B) (hS : ∀ x ∈ S, onNominal C x ∈ S)
    (M : Tensor (Nominal (J := Fin 2) (B := B) (H := H))) :
    push (quotientCompression S C hS) (push S.mkQ M) =
      push S.mkQ (push (onNominal C) M) := by
  rw [push_comp, quotient_natural, push_comp]

theorem nominal_primal_natural (C : Fin 2 → B →ₗ[F] B) (i : Fin 2) :
    (onNominal (H := H) C).comp (primal i) = (primal i).comp (C i) := by
  apply LinearMap.ext
  intro x
  apply Prod.ext
  · funext j
    by_cases h : j = i
    · subst j
      simp [onNominal, onPrimals, primal]
    · simp [onNominal, onPrimals, primal, Pi.single_apply, h, Ne.symm h]
  · rfl

theorem combined_natural (C : Fin 2 → B →ₗ[F] B) (x : Fin 2 → Tensor B) :
    push (onNominal (H := H) C) (combined x) =
      combined (H := H) (fun i => push (C i) (x i)) := by
  change (pushMap (onNominal (H := H) C)) (∑ i, push (primal (H := H) i) (x i)) = _
  rw [map_sum]
  apply Finset.sum_congr rfl
  intro i hi
  change push (onNominal C) (push (primal (H := H) i) (x i)) =
    push (primal (H := H) i) (push (C i) (x i))
  rw [push_comp, nominal_primal_natural, push_comp]

end NominalCompression

section Residual

variable {Tag E : Type} [Fintype E]

def pairedProfileCompression (T : Fin 2 → Fin m → Block n →ₗ[F] Block n) :
    (Fin 2 → Profile Tag (Primal p m n)) →ₗ[F]
      (Fin 2 → Profile Tag (Primal p m n)) :=
  LinearMap.pi fun i => (compressProfile (T i)).comp (LinearMap.proj i)

def residual {r : ℕ} (ends : E → Tag × Tag)
    (f g : Fin 2 → E → Fin r → Module.Dual F (Primal p m n)) :
    Module.Dual F (Fin 2 → Profile Tag (Primal p m n)) where
  toFun x := ∑ i, ∑ e, ∑ a, rankOneResponse (f i e a) (g i e a)
    (x i (ends e).1 (ends e).2)
  map_add' x y := by simp [rankOneResponse, Finset.sum_add_distrib]
  map_smul' c x := by simp [rankOneResponse, Finset.mul_sum, mul_add]

theorem residual_invariant {r : ℕ} (ends : E → Tag × Tag)
    (f g : Fin 2 → E → Fin r → Module.Dual F (Primal p m n))
    (T : Fin 2 → Fin m → Block n →ₗ[F] Block n)
    (hf : ∀ i e a, (f i e a).comp (compressPrimal (T i)) = f i e a)
    (hg : ∀ i e a, (g i e a).comp (compressPrimal (T i)) = g i e a) :
    (residual ends f g).comp (pairedProfileCompression T) = residual ends f g := by
  apply LinearMap.ext
  intro x
  change (∑ i, ∑ e, ∑ a, rankOneResponse (f i e a) (g i e a)
    (push (compressPrimal (T i)) (x i (ends e).1 (ends e).2))) =
      ∑ i, ∑ e, ∑ a, rankOneResponse (f i e a) (g i e a)
        (x i (ends e).1 (ends e).2)
  apply Finset.sum_congr rfl
  intro i hi
  apply Finset.sum_congr rfl
  intro e he
  apply Finset.sum_congr rfl
  intro a ha
  exact residual_atom_invariant (T i) _ _ (hf i e a) (hg i e a) _

end Residual

def Blin (K : ℕ) := 3 * K + 28
def Rres (K : ℕ) := 14 * K + 140
def Dblk (p E K : ℕ) := 2 * p * E * (K + 14 + Rres K)
def Dquo (p g E K : ℕ) := 2 * p * (1 + (g * g + 3) * Dblk p E K) + 2 * K

theorem residual_rank_arithmetic (K : ℕ) :
    2 * K + 28 + 4 * Blin K = Rres K := by simp [Blin, Rres]; omega

theorem manuscript_channel_budget (p g E K J r₀ : ℕ)
    (h : 970 * r₀ > 28 * J * E + Dquo p g E K + 2 * K + 4 * Blin K) :
    30 * r₀ + 28 * J * E + Dquo p g E K +
      (K + 2 * Blin K) + (K + 2 * Blin K) ≤ 1000 * r₀ := by omega

section ManuscriptCompression

variable {Tag Γ H : Type} [DecidableEq Tag] [DecidableEq Γ]
variable [AddCommGroup H] [Module F H] [FiniteDimensional F H]
variable {g E K : ℕ}

abbrev PinIndex (E K : ℕ) := Bool × Fin E × Fin (K + 14)
abbrev FormIndex (E K : ℕ) := Bool × Fin E × Fin (Rres K)

theorem manuscript_cut_compression
    (selectors : Fin 2 → Γ → Fin p → F)
    (blocked : Tag → Fin (g * g + 3) → Prop)
    (ends : Fin E → Tag × Tag)
    (v : Fin 2 → PinIndex E K → Primal p (g * g + 3) n)
    (f h : Fin 2 → Fin E → Fin (Rres K) →
      Module.Dual F (Primal p (g * g + 3) n))
    (D : Bool → Fin E →
      Submodule F (Nominal (J := Fin 2) (B := Primal p (g * g + 3) n) (H := H)))
    (keys : Bool → Fin E → Fin 2 → Submodule F (Primal p (g * g + 3) n))
    (Pprot Tpriv : Bool → Fin E → Fin 2 → Submodule F H)
    (hD : ∀ mode e x, x ∈ D mode e → ∀ i,
      x.1 i ∈ Submodule.span F (Set.range (v i)))
    (hkeys : ∀ mode e i x, x ∈ keys mode e i →
      x ∈ Submodule.span F (Set.range (v i)))
    (hcompl : ∀ mode e i, IsCompl (Tpriv mode e i) (Pprot mode e i))
    (hprotected : ∀ mode e i, finrank F (Pprot mode e i) ≤ K) :
    ∃ T : Fin 2 → Fin (g * g + 3) → Block n →ₗ[F] Block n,
      (∀ i b, finrank F (range (T i b)) ≤ Dblk p E K) ∧
      (∀ i x, x ∈ cuts (selectors i) blocked →
        compressProfile (T i) x ∈ cuts (selectors i) blocked) ∧
      (residual ends f h).comp (pairedProfileCompression T) = residual ends f h ∧
      (∀ mode e x, x ∈ frozen (D mode e) (keys mode e) (Tpriv mode e) →
        onNominal (fun i => compressPrimal (T i)) x = x) ∧
      (∀ mode e, ∃ Q :
          (Nominal (J := Fin 2) (B := Primal p (g * g + 3) n) (H := H) ⧸
            frozen (D mode e) (keys mode e) (Tpriv mode e)) →ₗ[F]
          (Nominal (J := Fin 2) (B := Primal p (g * g + 3) n) (H := H) ⧸
            frozen (D mode e) (keys mode e) (Tpriv mode e)),
        Q.comp (frozen (D mode e) (keys mode e) (Tpriv mode e)).mkQ =
          (frozen (D mode e) (keys mode e) (Tpriv mode e)).mkQ.comp
            (onNominal (fun i => compressPrimal (T i))) ∧
        finrank F (range Q) ≤ Dquo p g E K) := by
  classical
  let forms (i : Fin 2) (a : FormIndex E K) :=
    if a.1 then f i a.2.1 a.2.2 else h i a.2.1 a.2.2
  have hc (i : Fin 2) := blockwise_compression (v i) (forms i)
  choose T hfix hform hr using hc
  have hcount : p * (Fintype.card (PinIndex E K) + Fintype.card (FormIndex E K)) =
      Dblk p E K := by simp [PinIndex, FormIndex, Dblk]; ring
  have hbound : ∀ i b, finrank F (range (T i b)) ≤ Dblk p E K := by
    intro i b
    exact (hr i b).trans_eq hcount
  have hf : ∀ i e a, (f i e a).comp (compressPrimal (T i)) = f i e a := by
    intro i e a
    simpa [forms] using hform i (true, e, a)
  have hh : ∀ i e a, (h i e a).comp (compressPrimal (T i)) = h i e a := by
    intro i e a
    simpa [forms] using hform i (false, e, a)
  have hfreeze : ∀ mode e x, x ∈ frozen (D mode e) (keys mode e) (Tpriv mode e) →
      onNominal (fun i => compressPrimal (T i)) x = x := by
    intro mode e
    apply fixes_frozen
    · intro x hx i
      exact fixes_span _ (v i) (hfix i) _ (hD mode e x hx i)
    · intro i x hx
      exact fixes_span _ (v i) (hfix i) _ (hkeys mode e i x hx)
  refine ⟨T, hbound, ?_, residual_invariant ends f h T hf hh, hfreeze, ?_⟩
  · intro i x hx
    exact preserves_cuts (T i) (selectors i) blocked x hx
  · intro mode e
    let S := frozen (D mode e) (keys mode e) (Tpriv mode e)
    let C : Fin 2 → Primal p (g * g + 3) n →ₗ[F] Primal p (g * g + 3) n :=
      fun i => compressPrimal (T i)
    have hS : ∀ x ∈ S, onNominal C x ∈ S := by
      intro x hx
      rw [hfreeze mode e x hx]
      exact hx
    refine ⟨quotientCompression S C hS, quotient_natural S C hS, ?_⟩
    simp only [Dquo, Nat.mul_assoc]
    apply quotient_rank S C hS (channelProduct (Tpriv mode e))
      (p * (1 + (g * g + 3) * Dblk p E K)) (2 * K)
    · intro x hx
      apply Submodule.mem_sup_right
      exact ⟨by simp, hx⟩
    · intro i
      exact primal_rank (T i) (Dblk p E K) (hbound i)
    · exact product_channel_quotient_bound (Pprot mode e) (Tpriv mode e) K
        (hcompl mode e) (hprotected mode e)

end ManuscriptCompression

section PinFamilies

variable {B : Type} [AddCommGroup B] [Module F B] [FiniteDimensional F B]

theorem finite_spanning_family (S : Submodule F B) (d : ℕ)
    (hd : finrank F S ≤ d) :
    ∃ v : Fin d → B, Submodule.span F (Set.range v) = S := by
  classical
  let b := Module.finBasis F S
  let v : Fin d → B := fun i =>
    if h : i.val < finrank F S then (b ⟨i.val, h⟩ : B) else 0
  refine ⟨v, le_antisymm ?_ ?_⟩
  · apply Submodule.span_le.mpr
    rintro _ ⟨i, rfl⟩
    dsimp only [v]
    split
    · exact (b _).property
    · exact S.zero_mem
  · intro x hx
    have he : (∑ j, (b.repr ⟨x, hx⟩) j • (b j : B)) = x := by
      simpa only [map_sum, map_smul, Submodule.subtype_apply] using
        congrArg S.subtype (b.sum_repr ⟨x, hx⟩)
    rw [← he]
    apply Submodule.sum_mem
    intro j hj
    apply Submodule.smul_mem
    apply Submodule.subset_span
    refine ⟨⟨j.val, j.isLt.trans_le hd⟩, ?_⟩
    simp [v, j.isLt]

theorem pin_key_generators
    {E K : ℕ}
    (S A : Bool → Fin E → Fin 2 → Submodule F B)
    (hS : ∀ mode e i, finrank F (S mode e i) ≤ K)
    (hA : ∀ mode e i, finrank F (A mode e i) ≤ 14) :
    ∃ v : Fin 2 → PinIndex E K → B,
      (∀ mode e i, S mode e i ≤ Submodule.span F (Set.range (v i))) ∧
      (∀ mode e i, A mode e i ≤ Submodule.span F (Set.range (v i))) := by
  have hd : ∀ mode e i, finrank F ((S mode e i ⊔ A mode e i) : Submodule F B) ≤ K + 14 := by
    intro mode e i
    exact (Submodule.finrank_add_le_finrank_add_finrank _ _).trans
      (Nat.add_le_add (hS mode e i) (hA mode e i))
  choose w hw using fun mode e i =>
    finite_spanning_family (S mode e i ⊔ A mode e i) (K + 14) (hd mode e i)
  let v : Fin 2 → PinIndex E K → B := fun i a => w a.1 a.2.1 i a.2.2
  have hm : ∀ mode e i, S mode e i ⊔ A mode e i ≤
      Submodule.span F (Set.range (v i)) := by
    intro mode e i
    rw [← hw mode e i]
    apply Submodule.span_mono
    rintro _ ⟨j, rfl⟩
    exact ⟨(mode, e, j), rfl⟩
  exact ⟨v, fun mode e i => le_sup_left.trans (hm mode e i),
    fun mode e i => le_sup_right.trans (hm mode e i)⟩

end PinFamilies

section TensorEvaluation

variable {V : Type} [AddCommGroup V] [Module F V] [FiniteDimensional F V]

def contraction (M : V →ₗ[F] V →ₗ[F] F) : Tensor V →ₗ[F] F where
  toFun x := LinearMap.trace F (Module.Dual F V) (M.comp x)
  map_add' x y := by simp [LinearMap.comp_add]
  map_smul' c x := by
    have he : M.comp (c • x) = c • (M.comp x) := by ext φ; simp
    rw [he, map_smul]
    rfl

theorem contraction_rankOne (f g : Module.Dual F V) (x : Tensor V) :
    contraction (f.smulRight g) x = f (x g) := by
  change LinearMap.trace F (Module.Dual F V) ((f.comp x).smulRight g) = _
  exact LinearMap.trace_smulRight _ _

theorem contraction_natural (M : V →ₗ[F] V →ₗ[F] F) (C : V →ₗ[F] V)
    (x : Tensor V) :
    contraction (M.compl₁₂ C C) x = contraction M (push C x) := by
  change LinearMap.trace F (Module.Dual F V)
      (C.dualMap.comp ((M.comp C).comp x)) =
    LinearMap.trace F (Module.Dual F V) (((M.comp C).comp x).comp C.dualMap)
  exact LinearMap.trace_comp_comm' _ _

theorem quotient_contraction_natural
    {L R : Type} [AddCommGroup L] [Module F L] [AddCommGroup R] [Module F R]
    (qL : V →ₗ[F] L) (qR : V →ₗ[F] R)
    (CL : L →ₗ[F] L) (CR : R →ₗ[F] R) (C : V →ₗ[F] V)
    (hL : CL.comp qL = qL.comp C) (hR : CR.comp qR = qR.comp C)
    (M : L →ₗ[F] R →ₗ[F] F) (x : Tensor V) :
    contraction (ProtectedChannels.pull qL qR (M.compl₁₂ CL CR)) x =
      contraction (ProtectedChannels.pull qL qR M) (push C x) := by
  have he : ProtectedChannels.pull qL qR (M.compl₁₂ CL CR) =
      (ProtectedChannels.pull qL qR M).compl₁₂ C C := by
    ext u v
    change M (CL (qL u)) (CR (qR v)) = M (qL (C u)) (qR (C v))
    have hl : CL (qL u) = qL (C u) := LinearMap.congr_fun hL u
    have hr : CR (qR v) = qR (C v) := LinearMap.congr_fun hR v
    rw [hl, hr]
  rw [he, contraction_natural]

end TensorEvaluation

section RecipeAgreement

variable {J Tag Γ ι B H : Type}
variable [Fintype J] [DecidableEq J] [Fintype Tag] [DecidableEq Tag] [Nontrivial Tag]
variable [DecidableEq Γ] [Fintype ι] [DecidableEq ι]
variable [AddCommGroup B] [Module F B] [FiniteDimensional F B]
variable [AddCommGroup H] [Module F H]

theorem recipe_target_in_response
    (data : PairedBooleanData (J := J) (Tag := Tag) (Γ := Γ) (ι := ι) (B := B) (H := H))
    (a T actual baseline : Module.Dual F (J → Profile Tag B))
    (keyValue : J → Γ → F)
    (hrecipe : ∀ r : J → Profile Tag B, (∀ i, r i ∈ data.cuts i) →
      (∀ u v i, range (r i u v) ≤ (data.Dplus u v).map (primalProjection i) ∧
        range (r i u v) ≤ (data.Dminus u v).map (primalProjection i)) →
      T r = a r + actual r)
    (hpins : ∀ r : J → Profile Tag B, (∀ i, r i ∈ data.cuts i) →
      (∀ u v i, range (r i u v) ≤ (data.Dplus u v).map (primalProjection i) ∧
        range (r i u v) ≤ (data.Dminus u v).map (primalProjection i)) →
      baseline r = actual r)
    (hprescriptions : ∀ i s, s ∈ data.selected i →
      (a + T) (pairedAtom i (data.tag i s) (data.embed i s (data.point i s))) = keyValue i s)
    (hmatched : ∀ i s, s ∈ data.selected i →
      baseline (pairedAtom i (data.tag i s) (data.embed i s (data.point i s))) = keyValue i s) :
    ∃ q ∈ data.responses, ∀ x ∈ data.pairedCuts, ((a + T) - baseline) x = q x := by
  apply data.target_in_response
  · intro r hr he
    change a r + T r - baseline r = 0
    rw [hrecipe r hr he, hpins r hr he]
    have hz := twice (a r)
    linear_combination hz
  · intro c
    unfold PairedBooleanData.atoms
    simp only [map_sum, map_smul]
    apply Finset.sum_eq_zero
    intro i hi
    apply Finset.sum_eq_zero
    intro s hs
    rw [LinearMap.sub_apply, hprescriptions i s hs, hmatched i s hs, sub_self, smul_zero]

end RecipeAgreement

section DerivativeReduction

variable {P Q H : Type}
variable [AddCommGroup P] [Module F P] [FiniteDimensional F P]
variable [AddCommGroup Q] [Module F Q] [FiniteDimensional F Q]
variable [AddCommGroup H] [Module F H] [FiniteDimensional F H]

theorem reduce_derivative
    (pair : H →ₗ[F] H →ₗ[F] F) (E : Submodule F H)
    (baseline : P →ₗ[F] H) (delta : Q →ₗ[F] E) (B : ℕ)
    (hB : finrank F (range baseline) ≤ B) :
    ∃ delta' : Q →ₗ[F] E,
      finrank F (range delta') ≤ B ∧
      ∀ x y, pair (delta' x) (baseline y) = pair (delta x) (baseline y) := by
  let obs := baseline.dualMap.comp (pair.comp E.subtype)
  obtain ⟨C, hfix, hc, hr⟩ := ProtectedChannels.compression (⊥ : Submodule F E) obs
  have ho : finrank F (range obs) ≤ B := by
    exact (ProtectedChannels.finrank_comp_left baseline.dualMap (pair.comp E.subtype)).trans
      ((LinearMap.finrank_range_dualMap_eq_finrank_range baseline).le.trans hB)
  have hC : finrank F (range C) ≤ B := by
    have hr' : finrank F (range C) ≤ finrank F (range obs) := by simpa using hr
    exact hr'.trans ho
  refine ⟨C.comp delta, (ProtectedChannels.finrank_comp_left C delta).trans hC, ?_⟩
  intro x y
  exact LinearMap.congr_fun (LinearMap.congr_fun hc (delta x)) y

def channelObservation
    (pair : H →ₗ[F] H →ₗ[F] F) (H₀ : Submodule F H)
    (G₀ Gd : P →ₗ[F] H) :
    H →ₗ[F] Module.Dual F H₀ ×
      (Module.Dual F (range G₀) × Module.Dual F (range Gd)) :=
  (H₀.subtype.dualMap.comp pair).prod
    (((range G₀).subtype.dualMap.comp pair).prod
      ((range Gd).subtype.dualMap.comp pair))

def protectedValues
    (pair : H →ₗ[F] H →ₗ[F] F) (H₀ : Submodule F H)
    (G₀ Gd : P →ₗ[F] H) : Submodule F H :=
  ker (channelObservation pair H₀ G₀ Gd)

theorem protected_value_codimension
    (pair : H →ₗ[F] H →ₗ[F] F) (H₀ : Submodule F H)
    (G₀ Gd : P →ₗ[F] H) (K B : ℕ)
    (hH : finrank F H₀ ≤ K)
    (hG₀ : finrank F (range G₀) ≤ B) (hGd : finrank F (range Gd) ≤ B) :
    finrank F H ≤ finrank F (protectedValues pair H₀ G₀ Gd) + (K + 2 * B) := by
  have hr := Submodule.finrank_le (range (channelObservation pair H₀ G₀ Gd))
  have hn := (channelObservation pair H₀ G₀ Gd).finrank_range_add_finrank_ker
  have hc : finrank F (Module.Dual F H₀ ×
      (Module.Dual F (range G₀) × Module.Dual F (range Gd))) ≤ K + 2 * B := by
    simp only [Module.finrank_prod, Subspace.dual_finrank_eq]
    omega
  change finrank F H ≤ finrank F (ker (channelObservation pair H₀ G₀ Gd)) + _
  omega

theorem protected_value_vanishes
    (pair : H →ₗ[F] H →ₗ[F] F) (H₀ : Submodule F H)
    (G₀ Gd : P →ₗ[F] H) (a : protectedValues pair H₀ G₀ Gd) :
    (∀ y ∈ H₀, pair a y = 0) ∧ (∀ x, pair a ((G₀ + Gd) x) = 0) := by
  have ha := mem_ker.mp a.property
  constructor
  · intro y hy
    exact congrArg (fun z => z.1 ⟨y, hy⟩) ha
  · intro x
    have h₀ : pair a (G₀ x) = 0 :=
      congrArg (fun z => z.2.1 ⟨G₀ x, ⟨x, rfl⟩⟩) ha
    have hd : pair a (Gd x) = 0 :=
      congrArg (fun z => z.2.2 ⟨Gd x, ⟨x, rfl⟩⟩) ha
    simp only [LinearMap.add_apply, map_add, h₀, hd, add_zero]

end DerivativeReduction

section ActualResponse

variable {Tag E H : Type} [Fintype E] [DecidableEq Tag]
variable [AddCommGroup H] [Module F H] [FiniteDimensional F H]

def quotientResponse (ends : E → Tag × Tag)
    (Splus Sminus : E →
      Submodule F (Nominal (J := Fin 2) (B := Primal p m n) (H := H)))
    (M : ∀ e,
      (Nominal (J := Fin 2) (B := Primal p m n) (H := H) ⧸ Splus e) →ₗ[F]
      (Nominal (J := Fin 2) (B := Primal p m n) (H := H) ⧸ Sminus e) →ₗ[F] F) :
    Module.Dual F (Fin 2 → Profile Tag (Primal p m n)) where
  toFun x := ∑ e, contraction
    (ProtectedChannels.pull (Splus e).mkQ (Sminus e).mkQ (M e))
    (combined (H := H) (fun i => x i (ends e).1 (ends e).2))
  map_add' x y := by
    change (∑ e, _) = _
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro e he
    change contraction _ (combined (H := H)
      ((fun i => x i (ends e).1 (ends e).2) + (fun i => y i (ends e).1 (ends e).2))) =
        contraction _ _ + contraction _ _
    rw [combined_add, map_add]
  map_smul' c x := by
    change (∑ e, _) = _
    rw [Finset.smul_sum]
    apply Finset.sum_congr rfl
    intro e he
    change contraction _ (combined (H := H) (c • (fun i => x i (ends e).1 (ends e).2))) =
      c • contraction _ _
    rw [combined_smul, map_smul]

theorem actual_response_natural (ends : E → Tag × Tag)
    (Splus Sminus : E →
      Submodule F (Nominal (J := Fin 2) (B := Primal p m n) (H := H)))
    (T : Fin 2 → Fin m → Block n →ₗ[F] Block n)
    (Qplus : ∀ e,
      (Nominal (J := Fin 2) (B := Primal p m n) (H := H) ⧸ Splus e) →ₗ[F]
      (Nominal (J := Fin 2) (B := Primal p m n) (H := H) ⧸ Splus e))
    (Qminus : ∀ e,
      (Nominal (J := Fin 2) (B := Primal p m n) (H := H) ⧸ Sminus e) →ₗ[F]
      (Nominal (J := Fin 2) (B := Primal p m n) (H := H) ⧸ Sminus e))
    (hplus : ∀ e, (Qplus e).comp (Splus e).mkQ =
      (Splus e).mkQ.comp (onNominal (fun i => compressPrimal (T i))))
    (hminus : ∀ e, (Qminus e).comp (Sminus e).mkQ =
      (Sminus e).mkQ.comp (onNominal (fun i => compressPrimal (T i))))
    (M : ∀ e,
      (Nominal (J := Fin 2) (B := Primal p m n) (H := H) ⧸ Splus e) →ₗ[F]
      (Nominal (J := Fin 2) (B := Primal p m n) (H := H) ⧸ Sminus e) →ₗ[F] F) :
    quotientResponse ends Splus Sminus
      (fun e => (M e).compl₁₂ (Qplus e) (Qminus e)) =
      (quotientResponse ends Splus Sminus M).comp (pairedProfileCompression T) := by
  apply LinearMap.ext
  intro x
  apply Finset.sum_congr rfl
  intro e he
  rw [quotient_contraction_natural
    (Splus e).mkQ (Sminus e).mkQ _ _ _
    (hplus e) (hminus e),
    combined_natural]
  rfl

end ActualResponse

section BoundedSolution

variable {Tag Γ H : Type} [DecidableEq Tag] [DecidableEq Γ]
variable [AddCommGroup H] [Module F H] [FiniteDimensional F H]
variable {g E K : ℕ}

theorem bounded_pure_solution
    (selectors : Fin 2 → Γ → Fin p → F)
    (blocked : Tag → Fin (g * g + 3) → Prop)
    (ends : Fin E → Tag × Tag)
    (f h : Fin 2 → Fin E → Fin (Rres K) →
      Module.Dual F (Primal p (g * g + 3) n))
    (D : Bool → Fin E →
      Submodule F (Nominal (J := Fin 2) (B := Primal p (g * g + 3) n) (H := H)))
    (keys : Bool → Fin E → Fin 2 → Submodule F (Primal p (g * g + 3) n))
    (Pprot Tpriv : Bool → Fin E → Fin 2 → Submodule F H)
    (hpin : ∀ mode e i, finrank F ((D mode e).map (primalProjection i)) ≤ K)
    (hkey : ∀ mode e i, finrank F (keys mode e i) ≤ 14)
    (hcompl : ∀ mode e i, IsCompl (Tpriv mode e i) (Pprot mode e i))
    (hprotected : ∀ mode e i, finrank F (Pprot mode e i) ≤ K)
    (M : ∀ e,
      (Nominal (J := Fin 2) (B := Primal p (g * g + 3) n) (H := H) ⧸
        frozen (D false e) (keys false e) (Tpriv false e)) →ₗ[F]
      (Nominal (J := Fin 2) (B := Primal p (g * g + 3) n) (H := H) ⧸
        frozen (D true e) (keys true e) (Tpriv true e)) →ₗ[F] F)
    (hsolve : ∀ x : Fin 2 → Profile Tag (Primal p (g * g + 3) n),
      (∀ i, x i ∈ cuts (selectors i) blocked) →
      quotientResponse ends
        (fun e => frozen (D false e) (keys false e) (Tpriv false e))
        (fun e => frozen (D true e) (keys true e) (Tpriv true e)) M x = residual ends f h x) :
    ∃ MC : ∀ e,
      (Nominal (J := Fin 2) (B := Primal p (g * g + 3) n) (H := H) ⧸
        frozen (D false e) (keys false e) (Tpriv false e)) →ₗ[F]
      (Nominal (J := Fin 2) (B := Primal p (g * g + 3) n) (H := H) ⧸
        frozen (D true e) (keys true e) (Tpriv true e)) →ₗ[F] F,
      (∀ e, finrank F (range (MC e)) ≤ Dquo p g E K) ∧
      ∀ x : Fin 2 → Profile Tag (Primal p (g * g + 3) n),
        (∀ i, x i ∈ cuts (selectors i) blocked) →
        quotientResponse ends
          (fun e => frozen (D false e) (keys false e) (Tpriv false e))
          (fun e => frozen (D true e) (keys true e) (Tpriv true e)) MC x = residual ends f h x := by
  obtain ⟨v, hD, hkeys⟩ := pin_key_generators
    (fun mode e i => (D mode e).map (primalProjection i)) keys hpin hkey
  have hD' : ∀ mode e x, x ∈ D mode e → ∀ i,
      x.1 i ∈ Submodule.span F (Set.range (v i)) := by
    intro mode e x hx i
    exact hD mode e i ⟨x, hx, rfl⟩
  obtain ⟨T, hr, hcuts, hinv, hfreeze, hQ⟩ :=
    manuscript_cut_compression selectors blocked ends v f h D keys Pprot Tpriv
      hD' (fun mode e i x hx => hkeys mode e i hx) hcompl hprotected
  choose Q hnatural hQr using hQ
  let MC := fun e => (M e).compl₁₂ (Q false e) (Q true e)
  refine ⟨MC, ?_, ?_⟩
  · intro e
    exact (ProtectedChannels.compressed_rank (M e) (Q false e) (Q true e)).trans (hQr false e)
  · intro x hx
    have hn := actual_response_natural ends
      (fun e => frozen (D false e) (keys false e) (Tpriv false e))
      (fun e => frozen (D true e) (keys true e) (Tpriv true e))
      T (Q false) (Q true) (hnatural false) (hnatural true) M
    calc
      quotientResponse ends _ _ MC x =
          quotientResponse ends _ _ M (pairedProfileCompression T x) :=
        LinearMap.congr_fun hn x
      _ = residual ends f h (pairedProfileCompression T x) :=
        hsolve _ (fun i => hcuts i (x i) (hx i))
      _ = residual ends f h x := LinearMap.congr_fun hinv x

end BoundedSolution

section BudgetExactification

variable {P Q L R H : Type}
variable [AddCommGroup P] [Module F P] [FiniteDimensional F P]
variable [AddCommGroup Q] [Module F Q] [FiniteDimensional F Q]
variable [AddCommGroup L] [Module F L] [FiniteDimensional F L]
variable [AddCommGroup R] [Module F R] [FiniteDimensional F R]
variable [AddCommGroup H] [Module F H] [FiniteDimensional F H]

theorem manuscript_budget_exactification
    (pair : H →ₗ[F] H →ₗ[F] F) (hp : Function.Injective pair)
    (Hplus Hminus : Submodule F H)
    (F₀ Fd : P →ₗ[F] H) (G₀ Gd : Q →ₗ[F] H)
    (M₀ MC : L →ₗ[F] R →ₗ[F] F) (p g E K J r₀ : ℕ)
    (hplus : finrank F Hplus ≤ K) (hminus : finrank F Hminus ≤ K)
    (hF₀ : finrank F (range F₀) ≤ Blin K) (hFd : finrank F (range Fd) ≤ Blin K)
    (hG₀ : finrank F (range G₀) ≤ Blin K) (hGd : finrank F (range Gd) ≤ Blin K)
    (hM₀ : finrank F (range M₀) ≤ 30 * r₀ + 28 * J * E)
    (hMC : finrank F (range MC) ≤ Dquo p g E K)
    (hdim : finrank F H = 1000 * r₀)
    (hbudget : 970 * r₀ > 28 * J * E + Dquo p g E K + 2 * K + 4 * Blin K) :
    ∃ A : L →ₗ[F] H, ∃ B : R →ₗ[F] H,
      (∀ x y, pair (A x) (B y) = M₀ x y + MC x y) ∧
      (∀ x y, y ∈ Hminus → pair (A x) y = 0) ∧
      (∀ x y, x ∈ Hplus → pair x (B y) = 0) ∧
      (∀ x y, pair (A x) ((G₀ + Gd) y) = 0) ∧
      (∀ x y, pair ((F₀ + Fd) x) (B y) = 0) := by
  let A := protectedValues pair Hminus G₀ Gd
  let B := protectedValues pair.flip Hplus F₀ Fd
  have hA := protected_value_codimension pair Hminus G₀ Gd K (Blin K) hminus hG₀ hGd
  have hB := protected_value_codimension pair.flip Hplus F₀ Fd K (Blin K) hplus hF₀ hFd
  have hr : finrank F (range (M₀ + MC)) + (K + 2 * Blin K) + (K + 2 * Blin K) ≤
      finrank F H := by
    have hm := ProtectedChannels.finrank_add M₀ MC
    have hb := manuscript_channel_budget p g E K J r₀ hbudget
    omega
  obtain ⟨a, b, hab⟩ := ProtectedChannels.factor_with_codimensions pair hp A B (M₀ + MC)
    (K + 2 * Blin K) (K + 2 * Blin K) hA hB hr
  refine ⟨A.subtype.comp a, B.subtype.comp b, hab, ?_, ?_, ?_, ?_⟩
  · intro x y hy
    exact (protected_value_vanishes pair Hminus G₀ Gd (a x)).1 y hy
  · intro x y hx
    exact (protected_value_vanishes pair.flip Hplus F₀ Fd (b y)).1 x hx
  · intro x y
    exact (protected_value_vanishes pair Hminus G₀ Gd (a x)).2 y
  · intro x y
    exact (protected_value_vanishes pair.flip Hplus F₀ Fd (b y)).2 x

end BudgetExactification

section NominalGram

variable {B H : Type} [AddCommGroup B] [Module F B]
variable [AddCommGroup H] [Module F H]

def stored (D : Submodule F (Nominal (J := Fin 2) (B := B) (H := H)))
    (keys : Fin 2 → Submodule F B) :=
  D ⊔ coordinates keys (fun _ => ⊥)

def channel (i : Fin 2) : H →ₗ[F] (Nominal (J := Fin 2) (B := B) (H := H)) :=
  (0 : H →ₗ[F] (Fin 2 → B)).prod (LinearMap.single F (fun _ : Fin 2 => H) i)

theorem stored_channel_projection
    (D : Submodule F (Nominal (J := Fin 2) (B := B) (H := H)))
    (keys : Fin 2 → Submodule F B) (i : Fin 2)
    (x : Nominal (J := Fin 2) (B := B) (H := H)) (hx : x ∈ stored D keys) :
    channelProjection i x ∈ D.map (channelProjection i) := by
  obtain ⟨d, hd, k, hk, rfl⟩ := Submodule.mem_sup.mp hx
  have hz : k.2 i = 0 := hk.2 i
  change d.2 i + k.2 i ∈ _
  rw [hz, add_zero]
  exact ⟨d, hd, rfl⟩

theorem nominal_gram_completion
    (pair : H →ₗ[F] H →ₗ[F] F)
    (DL DR : Submodule F (Nominal (J := Fin 2) (B := B) (H := H)))
    (keysL keysR : Fin 2 → Submodule F B)
    (privateL privateR : Fin 2 → Submodule F H)
    (K₀ : Nominal (J := Fin 2) (B := B) (H := H) →ₗ[F]
      Nominal (J := Fin 2) (B := B) (H := H) →ₗ[F] F)
    (Fmap : Fin 2 →
      (Nominal (J := Fin 2) (B := B) (H := H) ⧸ frozen DL keysL privateL) →ₗ[F] H)
    (Gmap : Fin 2 →
      (Nominal (J := Fin 2) (B := B) (H := H) ⧸ frozen DR keysR privateR) →ₗ[F] H)
    (hF : ∀ j x y, y ∈ DR.map (channelProjection j) → pair (Fmap j x) y = 0)
    (hG : ∀ i x y, x ∈ DL.map (channelProjection i) → pair x (Gmap i y) = 0) :
    ∃ K₁ : Nominal (J := Fin 2) (B := B) (H := H) →ₗ[F]
      Nominal (J := Fin 2) (B := B) (H := H) →ₗ[F] F,
      (∀ x ∈ stored DL keysL, ∀ y, K₁ x y = K₀ x y) ∧
      (∀ y ∈ stored DR keysR, ∀ x, K₁ x y = K₀ x y) ∧
      (∀ x j c, K₁ (x, 0) (channel j c) =
        K₀ (x, 0) (channel j c) +
          pair (Fmap j ((frozen DL keysL privateL).mkQ (x, 0))) c) ∧
      (∀ x i c, K₁ (channel i c) (x, 0) =
        K₀ (channel i c) (x, 0) +
          pair c (Gmap i ((frozen DR keysR privateR).mkQ (x, 0)))) := by
  let F' := fun j => (Fmap j).comp (frozen DL keysL privateL).mkQ
  let G' := fun i => (Gmap i).comp (frozen DR keysR privateR).mkQ
  apply ProtectedChannels.gram_completion pair K₀ F' G'
    (fun i => channelProjection i) (fun j => channelProjection j)
    (stored DL keysL) (stored DR keysR)
    (LinearMap.inl F (Fin 2 → B) (Fin 2 → H))
    (LinearMap.inl F (Fin 2 → B) (Fin 2 → H))
    channel channel
  · intro j x hx
    have hq : (frozen DL keysL privateL).mkQ x = 0 :=
      (Submodule.Quotient.mk_eq_zero _).mpr (Submodule.mem_sup_left hx)
    change Fmap j ((frozen DL keysL privateL).mkQ x) = 0
    rw [hq, map_zero]
  · intro i x hx
    have hq : (frozen DR keysR privateR).mkQ x = 0 :=
      (Submodule.Quotient.mk_eq_zero _).mpr (Submodule.mem_sup_left hx)
    change Gmap i ((frozen DR keysR privateR).mkQ x) = 0
    rw [hq, map_zero]
  · intro i x hx y
    exact hG i _ _ (stored_channel_projection DL keysL i x hx)
  · intro j y hy x
    exact hF j _ _ (stored_channel_projection DR keysR j y hy)
  · intro i x
    rfl
  · intro j x
    rfl
  · intro i c k
    simp [channelProjection, channel, Pi.single_apply, eq_comm]
  · intro j c k
    simp [channelProjection, channel, Pi.single_apply, eq_comm]

end NominalGram

end BooleanCutCompression
