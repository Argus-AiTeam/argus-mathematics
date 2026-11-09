import Mathlib

noncomputable section

open Module LinearMap Function

namespace BooleanCutAnnihilator

abbrev F := ZMod 2
abbrev Tensor (V : Type) [AddCommGroup V] [Module F V] := Module.Dual F V →ₗ[F] V

variable {V W U : Type}
variable [AddCommGroup V] [Module F V] [AddCommGroup W] [Module F W]
variable [AddCommGroup U] [Module F U]

def square (v : V) : Tensor V := (Module.Dual.eval F V v).smulRight v

@[simp] theorem square_apply (v : V) (φ : Module.Dual F V) :
    square v φ = φ v • v := rfl

def push (f : V →ₗ[F] W) (M : Tensor V) : Tensor W :=
  f.comp (M.comp f.dualMap)

@[simp] theorem push_apply (f : V →ₗ[F] W) (M : Tensor V) (φ : Module.Dual F W) :
    push f M φ = f (M (φ.comp f)) := rfl

def pushMap (f : V →ₗ[F] W) : Tensor V →ₗ[F] Tensor W where
  toFun := push f
  map_add' M N := by ext φ; simp [push]
  map_smul' c M := by ext φ; simp [push]

@[simp] theorem push_square (f : V →ₗ[F] W) (v : V) :
    push f (square v) = square (f v) := by ext φ; simp

def Symmetric (M : Tensor V) : Prop :=
  ∀ φ ψ : Module.Dual F V, φ (M ψ) = ψ (M φ)

theorem symmetric_square (v : V) : Symmetric (square v) := by
  intro φ ψ
  simp [mul_comm]

theorem symmetric_add {M N : Tensor V} (hM : Symmetric M) (hN : Symmetric N) :
    Symmetric (M + N) := by intro φ ψ; simp [hM φ ψ, hN φ ψ]

theorem symmetric_smul (c : F) {M : Tensor V} (hM : Symmetric M) :
    Symmetric (c • M) := by intro φ ψ; simp [hM φ ψ]

theorem symmetric_push (f : V →ₗ[F] W) {M : Tensor V} (hM : Symmetric M) :
    Symmetric (push f M) := by
  intro φ ψ
  exact hM (φ.comp f) (ψ.comp f)

theorem twice (x : V) : x + x = 0 := by
  have htwo : (2 : F) = 0 := by decide
  rw [← two_smul F x, htwo, zero_smul]

@[simp] theorem push_zero (f : V →ₗ[F] W) : push f (0 : Tensor V) = 0 := by
  ext φ
  simp

@[simp] theorem push_smul (f : V →ₗ[F] W) (c : F) (M : Tensor V) :
    push f (c • M) = c • push f M := (pushMap f).map_smul c M

@[simp] theorem push_add (f : V →ₗ[F] W) (M N : Tensor V) :
    push f (M + N) = push f M + push f N := (pushMap f).map_add M N

theorem factor_of_kernel (f : V →ₗ[F] W) (g : V →ₗ[F] U)
    (h : ker f ≤ ker g) :
    ∃ t : W →ₗ[F] U, t.comp f = g := by
  obtain ⟨s, hs⟩ :=
    f.rangeRestrict.exists_rightInverse_of_surjective f.range_rangeRestrict
  obtain ⟨r, hr⟩ :=
    (range f).subtype.exists_leftInverse_of_injective (range f).ker_subtype
  refine ⟨g.comp (s.comp r), ?_⟩
  ext x
  have hrx := LinearMap.congr_fun hr (f.rangeRestrict x)
  have hsx := congrArg Subtype.val (LinearMap.congr_fun hs (f.rangeRestrict x))
  have hk : s (f.rangeRestrict x) - x ∈ ker f := by
    rw [mem_ker, map_sub]
    exact sub_eq_zero.mpr hsx
  have hg := mem_ker.mp (h hk)
  change g (s (r (f x))) = g x
  change r (f x) = f.rangeRestrict x at hrx
  rw [hrx]
  exact sub_eq_zero.mp (by simpa only [map_sub] using hg)

theorem vanishes_on_dual_annihilator {M : Tensor V}
    (hM : Symmetric M) (S : Submodule F V) (hr : range M ≤ S) :
    ∀ φ ∈ S.dualAnnihilator, M φ = 0 := by
  intro φ hφ
  apply Module.eval_apply_injective F
  ext ψ
  change ψ (M φ) = ψ 0
  rw [map_zero]
  rw [← hM φ ψ]
  exact (Submodule.mem_dualAnnihilator φ).mp hφ (M ψ) (hr ⟨ψ, rfl⟩)

theorem rank_comp_left [FiniteDimensional F W]
    (f : V →ₗ[F] W) (g : U →ₗ[F] V) :
    finrank F (range (f.comp g)) ≤ finrank F (range f) := by
  apply Submodule.finrank_mono
  rintro _ ⟨x, rfl⟩
  exact ⟨g x, rfl⟩

theorem rank_comp_right [FiniteDimensional F V]
    (f : V →ₗ[F] W) (g : U →ₗ[F] V) :
    finrank F (range (f.comp g)) ≤ finrank F (range g) := by
  rw [range_comp]
  exact Submodule.finrank_map_le f (range g)

theorem rank_add [FiniteDimensional F V] [FiniteDimensional F W]
    (f g : V →ₗ[F] W) :
    finrank F (range (f + g)) ≤ finrank F (range f) + finrank F (range g) := by
  let a := f.rangeRestrict.prod g.rangeRestrict
  let b := (range f).subtype.coprod (range g).subtype
  have he : f + g = b.comp a := by ext x; rfl
  rw [he]
  exact (rank_comp_left b a).trans
    (b.finrank_range_le.trans_eq Module.finrank_prod)

theorem rank_from_quotients [FiniteDimensional F V]
    (M : Tensor V) (S T : Submodule F V)
    (h : ∀ φ ∈ T.dualAnnihilator, M φ ∈ S) :
    finrank F (range M) ≤ finrank F S + finrank F T := by
  obtain ⟨r, hr⟩ := T.subtype.exists_leftInverse_of_injective T.ker_subtype
  let P := T.subtype.comp r
  let N := M.comp (LinearMap.id - P).dualMap
  let Q := M.comp P.dualMap
  have hN : range N ≤ S := by
    rintro _ ⟨φ, rfl⟩
    apply h
    rw [Submodule.mem_dualAnnihilator]
    intro x hx
    change φ (x - (r x : V)) = 0
    have hrx : r x = ⟨x, hx⟩ := LinearMap.congr_fun hr ⟨x, hx⟩
    simp [hrx]
  have he : M = N + Q := by
    ext φ
    symm
    change M (φ.comp (LinearMap.id - P)) + M (φ.comp P) = M φ
    rw [← map_add]
    congr 1
    ext x
    simp
  have hP : finrank F (range P) ≤ finrank F T :=
    (rank_comp_left T.subtype r).trans
      (LinearMap.finrank_range_of_inj T.injective_subtype).le
  have hQ : finrank F (range Q) ≤ finrank F T := by
    exact (rank_comp_right M P.dualMap).trans
      ((LinearMap.finrank_range_dualMap_eq_finrank_range P).le.trans hP)
  rw [he]
  exact (rank_add N Q).trans (Nat.add_le_add (Submodule.finrank_mono hN) hQ)

section Coordinates

variable {ι : Type} [Fintype ι] [DecidableEq ι]

def coordinate (i : ι) : Module.Dual F (ι → F) := LinearMap.proj i

def BooleanMoment (o : ι) (M : Tensor (ι → F)) : Prop :=
  Symmetric M ∧ ∀ i, (M (coordinate i)) i = (M (coordinate i)) o

theorem dual_coordinate_ext (M N : Tensor (ι → F))
    (h : ∀ i j, (M (coordinate j)) i = (N (coordinate j)) i) : M = N := by
  apply (Pi.basisFun F ι).dualBasis.ext
  intro j
  funext i
  have he : (Pi.basisFun F ι).dualBasis j = coordinate j := by
    ext v
    simp [coordinate]
  simpa only [he] using h i j

theorem boolean_scalar (c v d d₀ : F)
    (h : c * v * v + v * d + d * v = c * v + d + d₀ * v) :
    d = d₀ * v := by
  revert c v d d₀
  decide

theorem boolean_ray (o : ι) (v : ι → F) (hv : v o = 1)
    (M : Tensor (ι → F)) (hM : BooleanMoment o M)
    (h : ∀ φ, φ v = 0 → M φ ∈ Submodule.span F {v}) :
    M = (M (coordinate o) o) • square v := by
  let c := M (coordinate o) o
  have hcol (i j) :
      M (coordinate j) i = v j * M (coordinate o) i +
        (M (coordinate j) o - v j * c) * v i := by
    let φ := coordinate j - v j • coordinate o
    have hφ : φ v = 0 := by simp [φ, coordinate, hv]
    obtain ⟨a, ha⟩ := Submodule.mem_span_singleton.mp (h φ hφ)
    have hi := congrFun ha i
    have ho := congrFun ha o
    change a * v i = M φ i at hi
    change a * v o = M φ o at ho
    dsimp only [φ] at hi ho
    simp only [map_sub, map_smul, Pi.sub_apply, Pi.smul_apply, smul_eq_mul] at hi ho
    rw [hv, mul_one] at ho
    rw [ho] at hi
    linear_combination -hi
  have hdiag (i) : M (coordinate i) o = c * v i := by
    have hc := hcol i i
    have hs : M (coordinate o) i = M (coordinate i) o :=
      hM.1 (coordinate i) (coordinate o)
    rw [hs, hM.2 i] at hc
    have hsq : v i * v i = v i := by
      have hvv : ∀ x : F, x * x = x := by decide
      exact hvv _
    have htwo : (2 : F) = 0 := by decide
    have hh : M (coordinate i) o = -(c * v i) := by
      calc
        M (coordinate i) o =
            2 * (v i * M (coordinate i) o) - c * (v i * v i) := by
              linear_combination hc
        _ = -(c * v i) := by rw [htwo, hsq]; ring
    have hneg : ∀ x : F, -x = x := by decide
    simpa only [hneg] using hh
  apply dual_coordinate_ext
  intro i j
  rw [hcol i j, hdiag j]
  have hs : M (coordinate o) i = M (coordinate i) o :=
    hM.1 (coordinate i) (coordinate o)
  rw [hs, hdiag i]
  simp [c, square, coordinate, mul_comm, mul_left_comm, mul_assoc]

end Coordinates

section Labels

variable {Γ A B : Type} [DecidableEq Γ]
variable [AddCommGroup A] [Module F A] [AddCommGroup B] [Module F B]

def labelSum (E : Γ → A →ₗ[F] B) (T : Finset Γ) : (T → A) →ₗ[F] B where
  toFun z := ∑ s : T, E s (z s)
  map_add' x y := by simp [Finset.sum_add_distrib]
  map_smul' c x := by simp [Finset.smul_sum]

def labelSpace (E : Γ → A →ₗ[F] B) (T : Finset Γ) : Submodule F B :=
  range (labelSum E T)

def keySum (E : Γ → A →ₗ[F] B) (v : Γ → A) (T : Finset Γ) :
    (T → F) →ₗ[F] B where
  toFun c := ∑ s : T, c s • E s (v s)
  map_add' x y := by simp [add_smul, Finset.sum_add_distrib]
  map_smul' c x := by simp [mul_smul, Finset.smul_sum]

def keySpace (E : Γ → A →ₗ[F] B) (v : Γ → A) (T : Finset Γ) : Submodule F B :=
  range (keySum E v T)

theorem key_rank (E : Γ → A →ₗ[F] B) (v : Γ → A) (T : Finset Γ) :
    finrank F (keySpace E v T) ≤ T.card := by
  calc
    finrank F (keySpace E v T) ≤ finrank F (T → F) := by
      apply LinearMap.finrank_range_le
    _ = T.card := by simp

def SparsePins (E : Γ → A →ₗ[F] B) (S : Submodule F B)
    (selected : Finset Γ) (bound : ℕ) : Prop :=
  ∀ (T : Finset Γ), T.card ≤ bound → ∀ s ∈ selected, ∀ hs : s ∈ T,
    ∀ z : T → A, labelSum E T z ∈ S → z ⟨s, hs⟩ = 0

theorem labelSum_single (E : Γ → A →ₗ[F] B) (T : Finset Γ)
    (s : T) (a : A) :
    labelSum E T (Pi.single s a) = E s a := by
  simp [labelSum, Pi.single_apply, apply_ite]

theorem extractor (E : Γ → A →ₗ[F] B) (S : Submodule F B)
    (T : Finset Γ) (s : Γ) (hs : s ∈ T)
    (h : ∀ z : T → A, labelSum E T z ∈ S → z ⟨s, hs⟩ = 0) :
    ∃ ρ : B →ₗ[F] A,
      (∀ x ∈ S, ρ x = 0) ∧
      ∀ t ∈ T, ∀ a, ρ (E t a) = if t = s then a else 0 := by
  let f := S.mkQ.comp (labelSum E T)
  let g : (T → A) →ₗ[F] A := LinearMap.proj ⟨s, hs⟩
  have hker : ker f ≤ ker g := by
    intro z hz
    rw [mem_ker]
    apply h
    exact (Submodule.Quotient.mk_eq_zero S).mp (mem_ker.mp hz)
  obtain ⟨r, hr⟩ := factor_of_kernel f g hker
  refine ⟨r.comp S.mkQ, ?_, ?_⟩
  · intro x hx
    change r (S.mkQ x) = 0
    rw [show S.mkQ x = 0 from (Submodule.Quotient.mk_eq_zero S).mpr hx, map_zero]
  · intro t ht a
    have hh := LinearMap.congr_fun hr (Pi.single (⟨t, ht⟩ : T) a : T → A)
    change r (S.mkQ (labelSum E T (Pi.single (⟨t, ht⟩ : T) a))) =
      (Pi.single (⟨t, ht⟩ : T) a : T → A) ⟨s, hs⟩ at hh
    rw [labelSum_single] at hh
    simpa [Pi.single_apply, eq_comm] using hh

theorem extract_decomposition (E : Γ → A →ₗ[F] B) (T : Finset Γ)
    (Z : Γ → Tensor A) (M : Tensor B)
    (hM : M = ∑ t ∈ T, push (E t) (Z t))
    (s : Γ) (hs : s ∈ T) (ρ σ : B →ₗ[F] A)
    (hρ : ∀ t ∈ T, ∀ a, ρ (E t a) = if t = s then a else 0)
    (hσ : ∀ a, σ (E s a) = a) :
    ∀ ψ, ρ (M (ψ.comp σ)) = Z s ψ := by
  intro ψ
  rw [hM]
  simp only [LinearMap.sum_apply, map_sum, push_apply]
  rw [Finset.sum_eq_single s]
  · have hp : (ψ.comp σ).comp (E s) = ψ := by ext a; simp [hσ]
    rw [hp, hρ s hs]
    simp
  · intro t ht hts
    simp [hρ t ht, hts]
  · simp [hs]

theorem extractor_key (E : Γ → A →ₗ[F] B) (v : Γ → A)
    (T U : Finset Γ) (hUT : U ⊆ T) (s : Γ) (ρ : B →ₗ[F] A)
    (hρ : ∀ t ∈ T, ∀ a, ρ (E t a) = if t = s then a else 0) :
    ∀ x ∈ keySpace E v U,
      ρ x ∈ (if s ∈ U then Submodule.span F {v s} else ⊥) := by
  rintro _ ⟨c, rfl⟩
  change ρ (∑ t : U, c t • E t (v t)) ∈ _
  rw [map_sum]
  by_cases hsa : s ∈ U
  · rw [if_pos hsa]
    apply Submodule.sum_mem
    intro t _
    rw [map_smul, hρ t (hUT t.property)]
    by_cases hts : (t : Γ) = s
    · rw [if_pos hts, hts]
      exact Submodule.smul_mem _ _ (Submodule.subset_span (by simp))
    · simp [hts]
  · rw [if_neg hsa]
    apply Submodule.sum_mem
    intro t _
    rw [map_smul, hρ t (hUT t.property)]
    have hts : (t : Γ) ≠ s := by intro he; exact hsa (he ▸ t.property)
    simp [hts]

theorem selected_block (o : ι) [Fintype ι] [DecidableEq ι]
    (E : Γ → (ι → F) →ₗ[F] B) (v : Γ → ι → F)
    (T active : Finset Γ) (hactive : active ⊆ T)
    (Splus Sminus : Submodule F B) (M : Tensor B) (Z : Γ → Tensor (ι → F))
    (hM : M = ∑ t ∈ T, push (E t) (Z t))
    (s : Γ) (hs : s ∈ T) (hv : v s o = 1)
    (hZ : BooleanMoment o (Z s))
    (ρ σ : B →ₗ[F] (ι → F))
    (hρS : ∀ x ∈ Splus, ρ x = 0) (hσS : ∀ x ∈ Sminus, σ x = 0)
    (hρ : ∀ t ∈ T, ∀ a, ρ (E t a) = if t = s then a else 0)
    (hσ : ∀ t ∈ T, ∀ a, σ (E t a) = if t = s then a else 0)
    (hquot : ∀ φ ∈ (Sminus ⊔ keySpace E v active).dualAnnihilator,
      M φ ∈ Splus ⊔ keySpace E v active) :
    (s ∈ active → Z s = (Z s (coordinate o) o) • square (v s)) ∧
      (s ∉ active → Z s = 0) := by
  have hx (ψ : Module.Dual F (ι → F))
      (hψ : ∀ t ∈ active, if t = s then ψ (v t) = 0 else True) :
      Z s ψ ∈ (if s ∈ active then Submodule.span F {v s} else ⊥) := by
    let φ := ψ.comp σ
    have hφ : φ ∈ (Sminus ⊔ keySpace E v active).dualAnnihilator := by
      rw [Submodule.mem_dualAnnihilator]
      intro x hx
      obtain ⟨a, ha, b, hb, rfl⟩ := Submodule.mem_sup.mp hx
      rw [map_add]
      have ha0 : φ a = 0 := by simp [φ, hσS a ha]
      have hb0 : φ b = 0 := by
        obtain ⟨c, rfl⟩ := hb
        change ψ (σ (∑ t : active, c t • E t (v t))) = 0
        simp only [map_sum, map_smul]
        apply Finset.sum_eq_zero
        intro t _
        rw [hσ t (hactive t.property)]
        by_cases he : (t : Γ) = s
        · have hz := hψ t t.property
          simp only [he, ite_true] at hz
          simp [he, hz]
        · simp [he]
      rw [ha0, hb0, zero_add]
    obtain ⟨a, ha, b, hb, he⟩ := Submodule.mem_sup.mp (hquot φ hφ)
    have hh := extractor_key E v T active hactive s ρ hρ b hb
    have hσs : ∀ a, σ (E s a) = a := by intro a; simpa using hσ s hs a
    have hZψ := extract_decomposition E T Z M hM s hs ρ σ hρ hσs ψ
    rw [← hZψ, ← he, map_add, hρS a ha, zero_add]
    exact hh
  constructor
  · intro hsa
    apply boolean_ray o (v s) hv (Z s) hZ
    intro ψ hψ
    simpa [hsa] using hx ψ (by
      intro t ht
      by_cases he : t = s
      · simp [he, hψ]
      · simp [he])
  · intro hsa
    apply LinearMap.ext
    intro ψ
    have hh := hx ψ (by
      intro t ht
      have he : t ≠ s := by intro he; exact hsa (he ▸ ht)
      simp [he])
    simpa [hsa] using hh

theorem key_coefficient (E : Γ → A →ₗ[F] B) (v : Γ → A)
    (T active : Finset Γ) (hactive : active ⊆ T) (s : active)
    (ρ : B →ₗ[F] A)
    (hρ : ∀ t ∈ T, ∀ a, ρ (E t a) = if t = (s : Γ) then a else 0)
    (c : active → F) :
    ρ (keySum E v active c) = c s • v s := by
  change ρ (∑ t : active, c t • E t (v t)) = _
  simp only [map_sum, map_smul]
  rw [Finset.sum_eq_single s]
  · simp [hρ s (hactive s.property)]
  · intro t _ hts
    have hne : (t : Γ) ≠ (s : Γ) := by
      intro he
      exact hts (Subtype.ext he)
    simp [hρ t (hactive t.property), hne]
  · simp

theorem key_unselected_disjoint {ι : Type} [Fintype ι] [DecidableEq ι]
    (o : ι) (E : Γ → (ι → F) →ₗ[F] B) (v : Γ → ι → F)
    (S : Submodule F B) (selected active L : Finset Γ) (bound : ℕ)
    (hactive : active ⊆ selected) (hL : Disjoint L selected)
    (hcard : L.card + selected.card ≤ bound)
    (hsp : SparsePins E S selected bound)
    (hv : ∀ s ∈ selected, v s o = 1) :
    Disjoint (keySpace E v active) (labelSpace E L ⊔ S) := by
  rw [Submodule.disjoint_def]
  intro x hx hxs
  obtain ⟨c, rfl⟩ := hx
  have hc : ∀ s : active, c s = 0 := by
    intro s
    let T := L ∪ selected
    have hsS := hactive s.property
    have hsT : (s : Γ) ∈ T := Finset.mem_union_right L hsS
    have hTcard : T.card ≤ bound :=
      (Finset.card_union_le L selected).trans hcard
    obtain ⟨ρ, hρS, hρ⟩ := extractor E S T s hsT
      (hsp T hTcard s hsS hsT)
    have hsL : (s : Γ) ∉ L := by
      intro hsL
      exact Finset.disjoint_left.mp hL hsL hsS
    have hρL : ∀ n ∈ labelSpace E L, ρ n = 0 := by
      rintro _ ⟨z, rfl⟩
      change ρ (∑ t : L, E t (z t)) = 0
      simp only [map_sum]
      apply Finset.sum_eq_zero
      intro t _
      have hne : (t : Γ) ≠ (s : Γ) := by intro he; exact hsL (he ▸ t.property)
      simp [hρ t (Finset.mem_union_left selected t.property), hne]
    obtain ⟨n, hn, p, hp, he⟩ := Submodule.mem_sup.mp hxs
    have hk0 : ρ (keySum E v active c) = 0 := by
      rw [← he, map_add, hρL n hn, hρS p hp, zero_add]
    have hactT : active ⊆ T := fun t ht => Finset.mem_union_right L (hactive ht)
    rw [key_coefficient E v T active hactT s ρ hρ c] at hk0
    have hh := congrFun hk0 o
    simpa [hv s hsS] using hh
  change (∑ s : active, c s • E s (v s)) = 0
  simp [hc]

end Labels

section Nominal

variable {J B H : Type} [Fintype J] [DecidableEq J]
variable [AddCommGroup B] [Module F B] [AddCommGroup H] [Module F H]

abbrev Nominal := (J → B) × (J → H)

def primal (i : J) : B →ₗ[F] (Nominal (J := J) (B := B) (H := H)) :=
  (LinearMap.single F (fun _ : J => B) i).prod 0

def primalProjection (i : J) : (Nominal (J := J) (B := B) (H := H)) →ₗ[F] B :=
  (LinearMap.proj i).comp (LinearMap.fst F (J → B) (J → H))

def channelProjection (i : J) : (Nominal (J := J) (B := B) (H := H)) →ₗ[F] H :=
  (LinearMap.proj i).comp (LinearMap.snd F (J → B) (J → H))

@[simp] theorem primal_projection (i j : J) (b : B) :
    primalProjection (H := H) j (primal i b) = if j = i then b else 0 := by
  simp [primalProjection, primal, LinearMap.single_apply, Pi.single_apply, eq_comm]

@[simp] theorem primal_channel (i j : J) (b : B) :
    channelProjection (H := H) j (primal i b) = 0 := rfl

def coordinates (K : J → Submodule F B) (T : J → Submodule F H) :
    Submodule F (Nominal (J := J) (B := B) (H := H)) where
  carrier := {x | (∀ i, x.1 i ∈ K i) ∧ ∀ i, x.2 i ∈ T i}
  zero_mem' := by simp
  add_mem' hx hy := ⟨fun i => (K i).add_mem (hx.1 i) (hy.1 i),
    fun i => (T i).add_mem (hx.2 i) (hy.2 i)⟩
  smul_mem' c x hx := ⟨fun i => (K i).smul_mem c (hx.1 i),
    fun i => (T i).smul_mem c (hx.2 i)⟩

def frozen (D : Submodule F (Nominal (J := J) (B := B) (H := H)))
    (K : J → Submodule F B) (T : J → Submodule F H) :=
  D ⊔ coordinates K (fun _ => ⊥) ⊔ coordinates (fun _ => ⊥) T

theorem projection_frozen
    (D : Submodule F (Nominal (J := J) (B := B) (H := H)))
    (K : J → Submodule F B) (T : J → Submodule F H) (i : J) :
    (frozen D K T).map (primalProjection i) ≤
      D.map (primalProjection i) ⊔ K i := by
  rintro _ ⟨x, hx, rfl⟩
  obtain ⟨d, hd, p, hp, rfl⟩ := Submodule.mem_sup.mp hx
  obtain ⟨a, ha, k, hk, rfl⟩ := Submodule.mem_sup.mp hd
  have hp0 : p.1 i = 0 := by simpa using hp.1 i
  change a.1 i + k.1 i + p.1 i ∈ _
  rw [hp0, add_zero]
  exact Submodule.add_mem _ (Submodule.mem_sup_left ⟨a, ha, rfl⟩)
    (Submodule.mem_sup_right (hk.1 i))

def liftFunctional (i : J) (φ : Module.Dual F B) :
    Module.Dual F (Nominal (J := J) (B := B) (H := H)) :=
  φ.comp (primalProjection i)

theorem lift_annihilates
    (D : Submodule F (Nominal (J := J) (B := B) (H := H)))
    (K : J → Submodule F B) (T : J → Submodule F H) (i : J)
    (φ : Module.Dual F B)
    (hφ : φ ∈ (D.map (primalProjection i) ⊔ K i).dualAnnihilator) :
    liftFunctional i φ ∈ (frozen D K T).dualAnnihilator := by
  rw [Submodule.mem_dualAnnihilator]
  intro x hx
  exact (Submodule.mem_dualAnnihilator φ).mp hφ _ (projection_frozen D K T i ⟨x, hx, rfl⟩)

def combined (M : J → Tensor B) : Tensor (Nominal (J := J) (B := B) (H := H)) :=
  ∑ i, push (primal i) (M i)

theorem combined_lift (M : J → Tensor B) (i : J) (φ : Module.Dual F B) :
    combined (H := H) M (liftFunctional i φ) = primal i (M i φ) := by
  have hcomp (j : J) : (liftFunctional (H := H) i φ).comp (primal j) =
      if j = i then φ else 0 := by
    by_cases hji : j = i
    · subst j
      ext b
      simp [liftFunctional]
    · ext b
      simp [liftFunctional, hji, Ne.symm hji]
  simp [combined, push_apply, hcomp, apply_ite]

def PureAnnihilates
    (Dplus Dminus : Submodule F (Nominal (J := J) (B := B) (H := H)))
    (Kplus Kminus : J → Submodule F B) (Tplus Tminus : J → Submodule F H)
    (M : J → Tensor B) : Prop :=
  ∀ (φ : Module.Dual F (Nominal (J := J) (B := B) (H := H))),
    φ ∈ (frozen Dminus Kminus Tminus).dualAnnihilator →
    combined (H := H) M φ ∈ frozen Dplus Kplus Tplus

theorem pure_local
    (Dplus Dminus : Submodule F (Nominal (J := J) (B := B) (H := H)))
    (Kplus Kminus : J → Submodule F B) (Tplus Tminus : J → Submodule F H)
    (M : J → Tensor B)
    (h : PureAnnihilates Dplus Dminus Kplus Kminus Tplus Tminus M) :
    ∀ i φ, φ ∈ (Dminus.map (primalProjection i) ⊔ Kminus i).dualAnnihilator →
      M i φ ∈ Dplus.map (primalProjection i) ⊔ Kplus i := by
  intro i φ hφ
  have hh := h (liftFunctional i φ) (lift_annihilates Dminus Kminus Tminus i φ hφ)
  rw [combined_lift] at hh
  simpa only [primal_projection, ite_true] using
    projection_frozen Dplus Kplus Tplus i ⟨primal i (M i φ), hh, rfl⟩

theorem pure_swap
    (Dplus Dminus : Submodule F (Nominal (J := J) (B := B) (H := H)))
    (Kplus Kminus : J → Submodule F B) (Tplus Tminus : J → Submodule F H)
    (M : J → Tensor B) (hsym : ∀ i, Symmetric (M i))
    (h : PureAnnihilates Dplus Dminus Kplus Kminus Tplus Tminus M) :
    PureAnnihilates Dminus Dplus Kminus Kplus Tminus Tplus M := by
  have hc : Symmetric (combined (H := H) M) := by
    intro φ ψ
    simp only [combined, LinearMap.sum_apply, map_sum, push_apply]
    apply Finset.sum_congr rfl
    intro i _
    exact hsym i (φ.comp (primal i)) (ψ.comp (primal i))
  intro φ hφ
  apply (Subspace.forall_mem_dualAnnihilator_apply_eq_zero_iff _ _).mp
  intro ψ hψ
  rw [← hc φ ψ]
  exact (Submodule.mem_dualAnnihilator φ).mp hφ _ (h ψ hψ)

theorem strip_nominal
    (D : Submodule F (Nominal (J := J) (B := B) (H := H)))
    (K N : J → Submodule F B) (T : J → Submodule F H)
    (hsep : ∀ i, Disjoint (K i) (N i ⊔ D.map (primalProjection i)))
    (hchannel : ∀ i, Disjoint (D.map (channelProjection i)) (T i))
    (x : Nominal (J := J) (B := B) (H := H))
    (hx : x ∈ frozen D K T) (hN : ∀ i, x.1 i ∈ N i)
    (hxH : x.2 = 0) : x ∈ D := by
  obtain ⟨dk, hdk, p, hp, he⟩ := Submodule.mem_sup.mp hx
  obtain ⟨d, hd, k, hk, hdk⟩ := Submodule.mem_sup.mp hdk
  have he' : d + k + p = x := by rw [hdk]; exact he
  have hk0 : k = 0 := by
    apply Prod.ext
    · funext i
      have hpi : p.1 i = 0 := by simpa using hp.1 i
      have hi := congrFun (congrArg Prod.fst he') i
      change d.1 i + k.1 i + p.1 i = x.1 i at hi
      rw [hpi, add_zero] at hi
      have heq : k.1 i = x.1 i - d.1 i :=
        eq_sub_iff_add_eq.mpr (by simpa only [add_comm] using hi)
      have hki : k.1 i ∈ N i ⊔ D.map (primalProjection i) := by
        rw [heq]
        exact Submodule.sub_mem _ (Submodule.mem_sup_left (hN i))
          (Submodule.mem_sup_right ⟨d, hd, rfl⟩)
      exact (Submodule.disjoint_def.mp (hsep i)) _ (hk.1 i) hki
    · funext i
      simpa using hk.2 i
  have hp0 : p = 0 := by
    apply Prod.ext
    · funext i
      simpa using hp.1 i
    · funext i
      have hi := congrFun (congrArg Prod.snd he') i
      rw [hk0, hxH] at hi
      change d.2 i + 0 + p.2 i = 0 at hi
      have heq : p.2 i = -d.2 i :=
        eq_neg_iff_add_eq_zero.mpr (by simpa only [add_zero, zero_add, add_comm] using hi)
      have hdT : p.2 i ∈ D.map (channelProjection i) := by
        rw [heq]
        exact Submodule.neg_mem _ ⟨d, hd, rfl⟩
      exact (Submodule.disjoint_def.mp (hchannel i)) _ hdT (hp.2 i)
  have hex : d = x := by simpa only [hk0, hp0, add_zero] using he'
  exact hex ▸ hd

def DerivativeAnnihilates
    (source : Submodule F (Nominal (J := J) (B := B) (H := H)))
    (baseline : (Nominal (J := J) (B := B) (H := H)) →ₗ[F] H)
    (Hprot : Submodule F H) (M : J → Tensor B) : Prop :=
  ∀ (φ : Module.Dual F (Nominal (J := J) (B := B) (H := H))),
    φ ∈ source.dualAnnihilator → ∀ c ∈ Hprot.dualAnnihilator,
    c (baseline (combined (H := H) M φ)) = 0

theorem unselected_effective
    (Dplus Dminus : Submodule F (Nominal (J := J) (B := B) (H := H)))
    (Kplus Kminus N : J → Submodule F B) (Tplus Tminus : J → Submodule F H)
    (baseline : (Nominal (J := J) (B := B) (H := H)) →ₗ[F] H)
    (Hprot : Submodule F H) (M : J → Tensor B)
    (hsym : ∀ i, Symmetric (M i)) (hN : ∀ i, range (M i) ≤ N i)
    (hpure : PureAnnihilates Dplus Dminus Kplus Kminus Tplus Tminus M)
    (hderiv : DerivativeAnnihilates (frozen Dminus Kminus Tminus) baseline Hprot M)
    (hsep : ∀ i, Disjoint (Kplus i) (N i ⊔ Dplus.map (primalProjection i)))
    (hsepminus : ∀ i, Disjoint (Kminus i) (N i ⊔ Dminus.map (primalProjection i)))
    (hchannel : ∀ i, Disjoint (Dplus.map (channelProjection i)) (Tplus i))
    (hinject : ∀ i d, primal i d ∈ Dplus →
      baseline (primal i d) ∈ Hprot → d = 0) :
    ∀ i, range (M i) ≤ Dminus.map (primalProjection i) := by
  have hz (i : J) (φ : Module.Dual F B)
      (hφ : φ ∈ (Dminus.map (primalProjection i) ⊔ Kminus i).dualAnnihilator) :
      M i φ = 0 := by
    let ψ := liftFunctional (H := H) i φ
    have hψ := lift_annihilates Dminus Kminus Tminus i φ hφ
    have hh := hpure ψ hψ
    rw [combined_lift] at hh
    have hd : primal (H := H) i (M i φ) ∈ Dplus := by
      apply strip_nominal Dplus Kplus N Tplus hsep hchannel _ hh
      · intro j
        change primalProjection (H := H) j (primal i (M i φ)) ∈ N j
        rw [primal_projection]
        split_ifs with hji
        · subst j
          exact hN i ⟨φ, rfl⟩
        · exact (N j).zero_mem
      · rfl
    apply hinject i (M i φ) hd
    apply (Subspace.forall_mem_dualAnnihilator_apply_eq_zero_iff _ _).mp
    intro c hc
    have hdv := hderiv ψ hψ c hc
    simpa only [ψ, combined_lift] using hdv
  intro i d hd
  have hS : d ∈ Dminus.map (primalProjection i) ⊔ Kminus i := by
    apply (Subspace.forall_mem_dualAnnihilator_apply_eq_zero_iff _ _).mp
    intro φ hφ
    obtain ⟨ψ, rfl⟩ := hd
    rw [hsym i φ ψ, hz i φ hφ, map_zero]
  obtain ⟨s, hs, k, hk, he⟩ := Submodule.mem_sup.mp hS
  have hki : k ∈ N i ⊔ Dminus.map (primalProjection i) := by
    have heq : k = d - s := eq_sub_iff_add_eq.mpr (by simpa only [add_comm] using he)
    rw [heq]
    exact Submodule.sub_mem _ (Submodule.mem_sup_left (hN i hd))
      (Submodule.mem_sup_right hs)
  have hk0 := (Submodule.disjoint_def.mp (hsepminus i)) k hk hki
  have hsd : s = d := by simpa only [hk0, add_zero] using he
  exact hsd ▸ hs

end Nominal

section CutDomain

variable {Tag Γ ι B : Type} [DecidableEq Tag] [DecidableEq Γ]
variable [Fintype ι] [DecidableEq ι] [AddCommGroup B] [Module F B]

abbrev Profile (Tag B : Type) [AddCommGroup B] [Module F B] :=
  Tag → Tag → Tensor B

def cutSpace (W : Tag → Submodule F (Tensor B)) : Submodule F (Profile Tag B) where
  carrier := {x | ∃ w : Tag → Tensor B, (∀ t, w t ∈ W t) ∧
    ∀ a b, x a b = w a + w b}
  zero_mem' := ⟨0, by simp, by simp⟩
  add_mem' := by
    rintro x y ⟨w, hw, hx⟩ ⟨z, hz, hy⟩
    refine ⟨w + z, fun t => (W t).add_mem (hw t) (hz t), ?_⟩
    intro a b
    simp only [Pi.add_apply, hx, hy]
    abel
  smul_mem' := by
    rintro c x ⟨w, hw, hx⟩
    refine ⟨c • w, fun t => (W t).smul_mem c (hw t), ?_⟩
    intro a b
    simp [hx, smul_add]

theorem cut_triangle (W : Tag → Submodule F (Tensor B))
    (x : Profile Tag B) (hx : x ∈ cutSpace W) :
    ∀ a b c, x a b + x b c + x c a = 0 := by
  obtain ⟨w, hw, hx⟩ := hx
  intro a b c
  rw [hx, hx, hx]
  calc
    w a + w b + (w b + w c) + (w c + w a) =
        (w a + w a) + (w b + w b) + (w c + w c) := by abel
    _ = 0 := by simp only [twice, add_zero]

def star (t : Tag) (M : Tensor B) : Profile Tag B :=
  fun a b => (if a = t then M else 0) + (if b = t then M else 0)

theorem star_in_cut (W : Tag → Submodule F (Tensor B)) (t : Tag)
    (M : Tensor B) (hM : M ∈ W t) : star t M ∈ cutSpace W := by
  refine ⟨fun a => if a = t then M else 0, ?_, ?_⟩
  · intro a
    by_cases ha : a = t
    · subst a
      simpa using hM
    · simp [ha]
  · intro a b
    rfl

def activeLabels (selected : Finset Γ) (tag : Γ → Tag) (a b : Tag) : Finset Γ :=
  selected.filter (fun s => a ≠ b ∧ (tag s = a ∨ tag s = b))

structure Decomposition (o : ι) (E : Γ → (ι → F) →ₗ[F] B)
    (M : Tensor B) (R : ℕ) where
  support : Finset Γ
  card : support.card ≤ R
  block : Γ → Tensor (ι → F)
  off_support : ∀ s ∉ support, block s = 0
  boolean : ∀ s, BooleanMoment o (block s)
  equation : M = ∑ s ∈ support, push (E s) (block s)

theorem decomposition_on (o : ι) (E : Γ → (ι → F) →ₗ[F] B)
    (M : Tensor B) (R : ℕ) (d : Decomposition o E M R)
    (T : Finset Γ) (hT : d.support ⊆ T) :
    M = ∑ s ∈ T, push (E s) (d.block s) := by
  apply d.equation.trans
  apply Finset.sum_subset hT
  intro s hs hsnot
  simp [d.off_support s hsnot]

theorem decomposition_range (o : ι) (E : Γ → (ι → F) →ₗ[F] B)
    (M : Tensor B) (R : ℕ) (d : Decomposition o E M R) :
    range M ≤ labelSpace E d.support := by
  rintro _ ⟨φ, rfl⟩
  have hm := congrArg (fun N : Tensor B => N φ) d.equation
  rw [hm]
  simp only [LinearMap.sum_apply, push_apply]
  apply Submodule.sum_mem
  intro s hs
  exact ⟨Pi.single (⟨s, hs⟩ : d.support) (d.block s (φ.comp (E s))),
    labelSum_single E d.support ⟨s, hs⟩ _⟩

theorem decomposition_triangle (o : ι) (E : Γ → (ι → F) →ₗ[F] B)
    (R : ℕ) (M₁ M₂ M₃ : Tensor B)
    (d₁ : Decomposition o E M₁ R) (d₂ : Decomposition o E M₂ R)
    (d₃ : Decomposition o E M₃ R)
    (hind : ∀ T : Finset Γ, T.card ≤ 3 * R → Injective (labelSum E T))
    (htri : M₁ + M₂ + M₃ = 0) :
    ∀ s, d₁.block s + d₂.block s + d₃.block s = 0 := by
  let T := d₁.support ∪ d₂.support ∪ d₃.support
  have h₁ : d₁.support ⊆ T := fun s hs =>
    Finset.mem_union_left _ (Finset.mem_union_left _ hs)
  have h₂ : d₂.support ⊆ T := fun s hs =>
    Finset.mem_union_left _ (Finset.mem_union_right _ hs)
  have h₃ : d₃.support ⊆ T := fun s hs => Finset.mem_union_right _ hs
  have hcard : T.card ≤ 3 * R := by
    have h12 := Finset.card_union_le d₁.support d₂.support
    have h123 := Finset.card_union_le (d₁.support ∪ d₂.support) d₃.support
    have hc1 := d₁.card
    have hc2 := d₂.card
    have hc3 := d₃.card
    dsimp only [T]
    omega
  intro s
  by_cases hs : s ∈ T
  · have hsparse : ∀ z : T → ι → F, labelSum E T z ∈ (⊥ : Submodule F B) →
        z ⟨s, hs⟩ = 0 := by
      intro z hz
      have hz0 : labelSum E T z = labelSum E T 0 := by simpa using hz
      have he := hind T hcard hz0
      exact congrFun he ⟨s, hs⟩
    obtain ⟨ρ, hρ0, hρ⟩ := extractor E ⊥ T s hs hsparse
    have hρs : ∀ a, ρ (E s a) = a := by intro a; simpa using hρ s hs a
    apply LinearMap.ext
    intro ψ
    have hh := congrArg (fun M : Tensor B => ρ (M (ψ.comp ρ))) htri
    simp only [LinearMap.add_apply, map_add, LinearMap.zero_apply, map_zero] at hh
    rw [extract_decomposition E T d₁.block M₁ (decomposition_on o E M₁ R d₁ T h₁)
      s hs ρ ρ hρ hρs,
      extract_decomposition E T d₂.block M₂ (decomposition_on o E M₂ R d₂ T h₂)
      s hs ρ ρ hρ hρs,
      extract_decomposition E T d₃.block M₃ (decomposition_on o E M₃ R d₃ T h₃)
      s hs ρ ρ hρ hρs] at hh
    exact hh
  · have hs₁ : s ∉ d₁.support := fun h => hs (h₁ h)
    have hs₂ : s ∉ d₂.support := fun h => hs (h₂ h)
    have hs₃ : s ∉ d₃.support := fun h => hs (h₃ h)
    simp [d₁.off_support s hs₁, d₂.off_support s hs₂, d₃.off_support s hs₃]

theorem star_coefficients [Nontrivial Tag] (t : Tag) (c : Tag → Tag → F)
    (htri : ∀ a b d, c a b + c b d + c d a = 0)
    (hoff : ∀ a b, ¬(a ≠ b ∧ (t = a ∨ t = b)) → c a b = 0) :
    ∃ k : F, ∀ a b, c a b =
      (if a = t then k else 0) + (if b = t then k else 0) := by
  have heq : ∀ x y : F, x + y = 0 → x = y := by decide
  have hsym (a b) : c a b = c b a := by
    have hh := htri a b a
    rw [hoff a a (by simp), add_zero] at hh
    exact heq _ _ hh
  obtain ⟨u, hu⟩ := exists_ne t
  have htu (a) (ha : a ≠ t) : c t a = c t u := by
    have hh := htri t a u
    rw [hoff a u (by simp [Ne.symm ha, Ne.symm hu]), hsym u t, add_zero] at hh
    exact heq _ _ hh
  refine ⟨c t u, ?_⟩
  intro a b
  by_cases ha : a = t
  · subst a
    by_cases hb : b = t
    · subst b
      simp [hoff t t (by simp), twice]
    · simpa [hb] using htu b hb
  · by_cases hb : b = t
    · subst b
      simpa [ha, hsym a t] using htu a ha
    · simp [ha, hb, hoff a b (by simp [Ne.symm ha, Ne.symm hb])]

theorem decomposition_selected (o : ι) (E : Γ → (ι → F) →ₗ[F] B)
    (v : Γ → ι → F) (R : ℕ) (M : Tensor B) (d : Decomposition o E M R)
    (selected active : Finset Γ) (hactive : active ⊆ selected)
    (Splus Sminus : Submodule F B)
    (hsp : SparsePins E Splus selected (R + selected.card))
    (hsm : SparsePins E Sminus selected (R + selected.card))
    (hv : ∀ s ∈ selected, v s o = 1)
    (hquot : ∀ φ ∈ (Sminus ⊔ keySpace E v active).dualAnnihilator,
      M φ ∈ Splus ⊔ keySpace E v active) :
    ∀ s ∈ selected,
      (s ∈ active → d.block s = (d.block s (coordinate o) o) • square (v s)) ∧
      (s ∉ active → d.block s = 0) := by
  intro s hs
  let T := d.support ∪ selected
  have hT : d.support ⊆ T := Finset.subset_union_left
  have hsel : selected ⊆ T := Finset.subset_union_right
  have hcard : T.card ≤ R + selected.card := by
    exact (Finset.card_union_le _ _).trans (Nat.add_le_add_right d.card _)
  obtain ⟨ρ, hρS, hρ⟩ :=
    extractor E Splus T s (hsel hs) (hsp T hcard s hs (hsel hs))
  obtain ⟨σ, hσS, hσ⟩ :=
    extractor E Sminus T s (hsel hs) (hsm T hcard s hs (hsel hs))
  exact selected_block o E v T active (hactive.trans hsel) Splus Sminus M d.block
    (decomposition_on o E M R d T hT) s (hsel hs) (hv s hs) (d.boolean s)
    ρ σ hρS hσS hρ hσ hquot

theorem selected_atoms [Nontrivial Tag] (o : ι)
    (E : Γ → (ι → F) →ₗ[F] B) (v : Γ → ι → F)
    (selected : Finset Γ) (tag : Γ → Tag)
    (W : Tag → Submodule F (Tensor B)) (R : ℕ)
    (x : Profile Tag B) (hx : x ∈ cutSpace W)
    (d : ∀ a b, Decomposition o E (x a b) R)
    (hind : ∀ T : Finset Γ, T.card ≤ 3 * R → Injective (labelSum E T))
    (hblock : ∀ a b s, s ∈ selected →
      (s ∈ activeLabels selected tag a b →
        (d a b).block s = ((d a b).block s (coordinate o) o) • square (v s)) ∧
      (s ∉ activeLabels selected tag a b → (d a b).block s = 0)) :
    ∃ c : Γ → F, ∀ a b s, s ∈ selected →
      push (E s) ((d a b).block s) =
        c s • star (tag s) (square (E s (v s))) a b := by
  have hc : ∀ s ∈ selected, ∃ k : F, ∀ a b,
      (d a b).block s (coordinate o) o =
        (if a = tag s then k else 0) + (if b = tag s then k else 0) := by
    intro s hs
    apply star_coefficients (tag s)
    · intro a b c
      have hh := decomposition_triangle o E R _ _ _ (d a b) (d b c) (d c a)
        hind (cut_triangle W x hx a b c) s
      have ht := congrArg (fun Z : Tensor (ι → F) => Z (coordinate o) o) hh
      simpa using ht
    · intro a b hab
      have hnot : s ∉ activeLabels selected tag a b := by
        simpa [activeLabels, hs] using hab
      simp [(hblock a b s hs).2 hnot]
  choose c hc using fun s : selected => hc s s.property
  refine ⟨fun s => if hs : s ∈ selected then c ⟨s, hs⟩ else 0, ?_⟩
  intro a b s hs
  have hc' := hc (⟨s, hs⟩ : selected) a b
  by_cases ha : a = tag s <;> by_cases hb : b = tag s
  · subst a
    subst b
    have hnot : s ∉ activeLabels selected tag (tag s) (tag s) := by simp [activeLabels]
    simp [(hblock _ _ s hs).2 hnot, star, twice]
  · have hact : s ∈ activeLabels selected tag a b := by
      simp [activeLabels, hs, ha, hb, Ne.symm hb]
    rw [(hblock a b s hs).1 hact, push_smul, push_square]
    simp only [ha, ite_true, hb, ite_false, add_zero] at hc'
    simp [hc', hs, star, ha, hb]
  · have hact : s ∈ activeLabels selected tag a b := by
      simp [activeLabels, hs, ha, hb, Ne.symm ha]
    rw [(hblock a b s hs).1 hact, push_smul, push_square]
    simp only [ha, ite_false, hb, ite_true, zero_add] at hc'
    simp [hc', hs, star, ha, hb]
  · have hnot : s ∉ activeLabels selected tag a b := by
      simp [activeLabels, ha, hb, Ne.symm ha, Ne.symm hb]
    simp [(hblock a b s hs).2 hnot, star, ha, hb]

theorem decomposition_split (o : ι) (E : Γ → (ι → F) →ₗ[F] B)
    (M : Tensor B) (R : ℕ) (d : Decomposition o E M R)
    (selected : Finset Γ) :
    M = (∑ s ∈ selected, push (E s) (d.block s)) +
      ∑ s ∈ d.support \ selected, push (E s) (d.block s) := by
  apply d.equation.trans
  rw [← Finset.sum_inter_add_sum_sdiff d.support selected]
  congr 1
  apply Finset.sum_subset Finset.inter_subset_right
  intro s hs hnot
  have hns : s ∉ d.support := by
    intro hh
    exact hnot (Finset.mem_inter.mpr ⟨hh, hs⟩)
  simp [d.off_support s hns]

end CutDomain

section Response

variable {J Tag B H : Type} [Fintype J] [DecidableEq J] [DecidableEq Tag]
variable [AddCommGroup B] [Module F B] [AddCommGroup H] [Module F H]

@[simp] theorem combined_zero :
    combined (J := J) (B := B) (H := H) 0 = 0 := by
  simp only [combined, Pi.zero_apply, push_zero, Finset.sum_const_zero]

theorem combined_add (M N : J → Tensor B) :
    combined (H := H) (M + N) = combined (H := H) M + combined (H := H) N := by
  simp only [combined, Pi.add_apply, push_add, Finset.sum_add_distrib]

theorem combined_smul (c : F) (M : J → Tensor B) :
    combined (H := H) (c • M) = c • combined (H := H) M := by
  simp only [combined, Pi.smul_apply, push_smul, Finset.smul_sum]

def responseKernel
    (Dplus Dminus : Tag → Tag → Submodule F (Nominal (J := J) (B := B) (H := H)))
    (Kplus Kminus : Tag → Tag → J → Submodule F B)
    (Tplus Tminus : Tag → Tag → J → Submodule F H)
    (fplus fminus : Tag → Tag → Nominal (J := J) (B := B) (H := H) →ₗ[F] H)
    (Hplus Hminus : Tag → Tag → Submodule F H) : Submodule F (J → Profile Tag B) where
  carrier := {x | ∀ a b,
    PureAnnihilates (Dplus a b) (Dminus a b) (Kplus a b) (Kminus a b)
      (Tplus a b) (Tminus a b)
      (fun i => x i a b) ∧
    DerivativeAnnihilates (frozen (Dminus a b) (Kminus a b) (Tminus a b))
      (fplus a b) (Hplus a b)
      (fun i => x i a b) ∧
    DerivativeAnnihilates (frozen (Dplus a b) (Kplus a b) (Tplus a b))
      (fminus a b) (Hminus a b)
      (fun i => x i a b)}
  zero_mem' := by
    intro a b
    refine ⟨?_, ?_, ?_⟩
    · intro φ hφ
      change combined (H := H) (0 : J → Tensor B) φ ∈ _
      simp
    · intro φ hφ c hc
      change c (fplus a b (combined (H := H) (0 : J → Tensor B) φ)) = 0
      simp
    · intro φ hφ c hc
      change c (fminus a b (combined (H := H) (0 : J → Tensor B) φ)) = 0
      simp
  add_mem' := by
    intro x y hx hy a b
    have he : (fun i => (x + y) i a b) =
        (fun i => x i a b) + (fun i => y i a b) := rfl
    refine ⟨?_, ?_, ?_⟩
    · intro φ hφ
      rw [he, combined_add, LinearMap.add_apply]
      exact (frozen (Dplus a b) (Kplus a b) (Tplus a b)).add_mem
        ((hx a b).1 φ hφ) ((hy a b).1 φ hφ)
    · intro φ hφ c hc
      rw [he, combined_add, LinearMap.add_apply, map_add, map_add,
        (hx a b).2.1 φ hφ c hc, (hy a b).2.1 φ hφ c hc, zero_add]
    · intro φ hφ c hc
      rw [he, combined_add, LinearMap.add_apply, map_add, map_add,
        (hx a b).2.2 φ hφ c hc, (hy a b).2.2 φ hφ c hc, zero_add]
  smul_mem' := by
    intro k x hx a b
    have he : (fun i => (k • x) i a b) = k • (fun i => x i a b) := rfl
    refine ⟨?_, ?_, ?_⟩
    · intro φ hφ
      rw [he, combined_smul, LinearMap.smul_apply]
      exact (frozen (Dplus a b) (Kplus a b) (Tplus a b)).smul_mem k ((hx a b).1 φ hφ)
    · intro φ hφ c hc
      rw [he, combined_smul, LinearMap.smul_apply, map_smul, map_smul,
        (hx a b).2.1 φ hφ c hc, smul_zero]
    · intro φ hφ c hc
      rw [he, combined_smul, LinearMap.smul_apply, map_smul, map_smul,
        (hx a b).2.2 φ hφ c hc, smul_zero]

def pairedAtom (i : J) (t : Tag) (v : B) : J → Profile Tag B :=
  Pi.single i (star t (square v))

theorem primal_key_frozen
    (D : Submodule F (Nominal (J := J) (B := B) (H := H)))
    (K : J → Submodule F B) (T : J → Submodule F H)
    (i : J) (v : B) (hv : v ∈ K i) :
    primal i v ∈ frozen D K T := by
  apply Submodule.mem_sup_left
  apply Submodule.mem_sup_right
  constructor
  · intro j
    change primalProjection (H := H) j (primal i v) ∈ K j
    rw [primal_projection]
    split_ifs with h
    · subst j
      exact hv
    · exact (K j).zero_mem
  · intro j
    simp [primal]

theorem atom_contraction
    (D : Tag → Tag → Submodule F (Nominal (J := J) (B := B) (H := H)))
    (K : Tag → Tag → J → Submodule F B) (T : Tag → Tag → J → Submodule F H)
    (i : J) (t : Tag) (v : B)
    (hkey : ∀ a b, a ≠ b → (t = a ∨ t = b) → v ∈ K a b i) :
    ∀ a b (φ : Module.Dual F (Nominal (J := J) (B := B) (H := H))),
      φ ∈ (frozen (D a b) (K a b) (T a b)).dualAnnihilator →
      combined (H := H) (fun j => pairedAtom i t v j a b) φ = 0 := by
  intro a b φ hφ
  have hcombined :
      combined (H := H) (fun j => pairedAtom i t v j a b) =
        push (primal i) (star t (square v) a b) := by
    unfold combined
    rw [Finset.sum_eq_single i]
    · simp [pairedAtom]
    · intro j hj hji
      simp [pairedAtom, hji, Ne.symm hji]
    · simp
  rw [hcombined]
  by_cases hab : a = b
  · subst b
    simp [star, twice]
  · by_cases ha : a = t <;> by_cases hb : b = t
    · exact False.elim (hab (ha.trans hb.symm))
    · have hp := primal_key_frozen (D a b) (K a b) (T a b) i v
        (hkey a b hab (Or.inl ha.symm))
      have hz := (Submodule.mem_dualAnnihilator φ).mp hφ _ hp
      simpa [star, ha, hb, push_square, hz]
    · have hp := primal_key_frozen (D a b) (K a b) (T a b) i v
        (hkey a b hab (Or.inr hb.symm))
      have hz := (Submodule.mem_dualAnnihilator φ).mp hφ _ hp
      simpa [star, ha, hb, push_square, hz]
    · simp [star, ha, hb]

theorem atom_in_response
    (Dplus Dminus : Tag → Tag → Submodule F (Nominal (J := J) (B := B) (H := H)))
    (Kplus Kminus : Tag → Tag → J → Submodule F B)
    (Tplus Tminus : Tag → Tag → J → Submodule F H)
    (fplus fminus : Tag → Tag → Nominal (J := J) (B := B) (H := H) →ₗ[F] H)
    (Hplus Hminus : Tag → Tag → Submodule F H)
    (i : J) (t : Tag) (v : B)
    (hkp : ∀ a b, a ≠ b → (t = a ∨ t = b) → v ∈ Kplus a b i)
    (hkm : ∀ a b, a ≠ b → (t = a ∨ t = b) → v ∈ Kminus a b i) :
    pairedAtom i t v ∈ responseKernel Dplus Dminus Kplus Kminus Tplus Tminus
      fplus fminus Hplus Hminus := by
  intro a b
  refine ⟨?_, ?_, ?_⟩
  · intro φ hφ
    rw [atom_contraction Dminus Kminus Tminus i t v hkm a b φ hφ]
    exact Submodule.zero_mem _
  · intro φ hφ c hc
    rw [atom_contraction Dminus Kminus Tminus i t v hkm a b φ hφ]
    simp
  · intro φ hφ c hc
    rw [atom_contraction Dplus Kplus Tplus i t v hkp a b φ hφ]
    simp

end Response

section ActualDomain

variable {J Tag Γ ι B H : Type}
variable [Fintype J] [DecidableEq J] [DecidableEq Tag] [Nontrivial Tag] [DecidableEq Γ]
variable [Fintype ι] [DecidableEq ι]
variable [AddCommGroup B] [Module F B] [FiniteDimensional F B]
variable [AddCommGroup H] [Module F H]

def momentSpace (o : ι) (E : Γ → (ι → F) →ₗ[F] B) :
    Submodule F (Tensor B) :=
  Submodule.span F {M | ∃ s v, v o = 1 ∧ M = square (E s v)}

def tagMomentSpace (o : ι) (E : Γ → (ι → F) →ₗ[F] B)
    (allowed : Tag → Γ → (ι → F) → Prop) (t : Tag) : Submodule F (Tensor B) :=
  Submodule.span F {M | ∃ s v, allowed t s v ∧ v o = 1 ∧ M = square (E s v)}

theorem tag_moment_le (o : ι) (E : Γ → (ι → F) →ₗ[F] B)
    (allowed : Tag → Γ → (ι → F) → Prop) (t : Tag) :
    tagMomentSpace o E allowed t ≤ momentSpace o E := by
  apply Submodule.span_le.mpr
  rintro M ⟨s, v, hv, ho, rfl⟩
  exact Submodule.subset_span ⟨s, v, ho, rfl⟩

theorem cut_component_moment (o : ι) (E : Γ → (ι → F) →ₗ[F] B)
    (allowed : Tag → Γ → (ι → F) → Prop)
    (x : Profile Tag B) (hx : x ∈ cutSpace (tagMomentSpace o E allowed))
    (a b : Tag) : x a b ∈ momentSpace o E := by
  obtain ⟨w, hw, hx⟩ := hx
  rw [hx a b]
  exact (momentSpace o E).add_mem
    (tag_moment_le o E allowed a (hw a)) (tag_moment_le o E allowed b (hw b))

structure PairedBooleanData where
  origin : ι
  embed : J → Γ → (ι → F) →ₗ[F] B
  allowed : J → Tag → Γ → (ι → F) → Prop
  selected : J → Finset Γ
  tag : J → Γ → Tag
  point : J → Γ → ι → F
  affine : ∀ i s, s ∈ selected i → point i s origin = 1
  admissible : ∀ i s, s ∈ selected i → allowed i (tag i s) s (point i s)
  pinBound : ℕ
  rankBound : ℕ
  rank_parameter : rankBound = 2 * (pinBound + 20)
  selected_count : ∀ i, (selected i).card ≤ 14
  Dplus : Tag → Tag → Submodule F (Nominal (J := J) (B := B) (H := H))
  Dminus : Tag → Tag → Submodule F (Nominal (J := J) (B := B) (H := H))
  Tplus : Tag → Tag → J → Submodule F H
  Tminus : Tag → Tag → J → Submodule F H
  baselinePlus : Tag → Tag → Nominal (J := J) (B := B) (H := H) →ₗ[F] H
  baselineMinus : Tag → Tag → Nominal (J := J) (B := B) (H := H) →ₗ[F] H
  protectedPlus : Tag → Tag → Submodule F H
  protectedMinus : Tag → Tag → Submodule F H
  label_support : ∀ i M, M ∈ momentSpace origin (embed i) →
    finrank F (range M) ≤ rankBound →
    Nonempty (Decomposition origin (embed i) M rankBound)
  interpolation : ∀ i T, T.card ≤ 3 * rankBound → Injective (labelSum (embed i) T)
  sparsePlus : ∀ a b i, SparsePins (embed i) ((Dplus a b).map (primalProjection i))
    (selected i) (rankBound + (selected i).card)
  sparseMinus : ∀ a b i, SparsePins (embed i) ((Dminus a b).map (primalProjection i))
    (selected i) (rankBound + (selected i).card)
  pinPlus : ∀ a b i, finrank F ((Dplus a b).map (primalProjection i)) ≤ pinBound
  pinMinus : ∀ a b i, finrank F ((Dminus a b).map (primalProjection i)) ≤ pinBound
  privatePlus : ∀ a b i,
    Disjoint ((Dplus a b).map (channelProjection i)) (Tplus a b i)
  privateMinus : ∀ a b i,
    Disjoint ((Dminus a b).map (channelProjection i)) (Tminus a b i)
  injectingPlus : ∀ a b i d, primal i d ∈ Dplus a b →
    baselinePlus a b (primal i d) ∈ protectedPlus a b → d = 0
  injectingMinus : ∀ a b i d, primal i d ∈ Dminus a b →
    baselineMinus a b (primal i d) ∈ protectedMinus a b → d = 0

namespace PairedBooleanData

variable (data : PairedBooleanData (J := J) (Tag := Tag) (Γ := Γ) (ι := ι)
  (B := B) (H := H))

def keys (a b : Tag) (i : J) : Submodule F B :=
  keySpace (data.embed i) (data.point i) (activeLabels (data.selected i) (data.tag i) a b)

def cuts (i : J) : Submodule F (Profile Tag B) :=
  cutSpace (tagMomentSpace data.origin (data.embed i) (data.allowed i))

def kernel : Submodule F (J → Profile Tag B) :=
  responseKernel data.Dplus data.Dminus data.keys data.keys data.Tplus data.Tminus
    data.baselinePlus data.baselineMinus data.protectedPlus data.protectedMinus

def atoms (c : J → Γ → F) : J → Profile Tag B :=
  ∑ i, ∑ s ∈ data.selected i,
    c i s • pairedAtom i (data.tag i s) (data.embed i s (data.point i s))

theorem rank_budget (a b : Tag) (i : J) :
    finrank F (((data.Dplus a b).map (primalProjection i) ⊔ data.keys a b i) :
      Submodule F B) +
    finrank F (((data.Dminus a b).map (primalProjection i) ⊔ data.keys a b i) :
      Submodule F B) ≤ data.rankBound := by
  have hk : finrank F (data.keys a b i) ≤ 14 := by
    have hactive := Finset.card_le_card
      (Finset.filter_subset (fun s => a ≠ b ∧ (data.tag i s = a ∨ data.tag i s = b))
        (data.selected i))
    have hh : finrank F (data.keys a b i) ≤
        (activeLabels (data.selected i) (data.tag i) a b).card := by
      exact key_rank (data.embed i) (data.point i)
        (activeLabels (data.selected i) (data.tag i) a b)
    exact hh.trans (hactive.trans (data.selected_count i))
  have hp := Submodule.finrank_add_le_finrank_add_finrank
    ((data.Dplus a b).map (primalProjection i))
    (data.keys a b i)
  have hm := Submodule.finrank_add_le_finrank_add_finrank
    ((data.Dminus a b).map (primalProjection i))
    (data.keys a b i)
  have hpinp := data.pinPlus a b i
  have hpinm := data.pinMinus a b i
  rw [data.rank_parameter]
  omega

theorem atoms_apply (c : J → Γ → F) (i : J) (a b : Tag) :
    data.atoms c i a b = ∑ s ∈ data.selected i,
      c i s • star (data.tag i s) (square (data.embed i s (data.point i s))) a b := by
  unfold atoms
  simp only [Finset.sum_apply]
  rw [Finset.sum_eq_single i]
  · simp [pairedAtom]
  · intro j hj hji
    simp [pairedAtom, hji, Ne.symm hji]
  · simp

theorem key_member (a b : Tag) (i : J) (s : Γ) (hs : s ∈ data.selected i)
    (hab : a ≠ b) (ht : data.tag i s = a ∨ data.tag i s = b) :
    data.embed i s (data.point i s) ∈ data.keys a b i := by
  let active := activeLabels (data.selected i) (data.tag i) a b
  have hsa : s ∈ active := Finset.mem_filter.mpr ⟨hs, hab, ht⟩
  refine ⟨Pi.single (⟨s, hsa⟩ : active) 1, ?_⟩
  change (∑ t : active, Pi.single (⟨s, hsa⟩ : active) 1 t •
    data.embed i t (data.point i t)) = _
  simp [Pi.single_apply, apply_ite]

theorem atoms_in_kernel (c : J → Γ → F) : data.atoms c ∈ data.kernel := by
  apply Submodule.sum_mem
  intro i hi
  apply Submodule.sum_mem
  intro s hs
  apply Submodule.smul_mem
  exact atom_in_response data.Dplus data.Dminus data.keys data.keys data.Tplus data.Tminus
    data.baselinePlus data.baselineMinus data.protectedPlus data.protectedMinus
    i (data.tag i s) (data.embed i s (data.point i s))
    (fun a b hab ht => data.key_member a b i s hs hab ht)
    (fun a b hab ht => data.key_member a b i s hs hab ht)

theorem atoms_in_cuts (c : J → Γ → F) : ∀ i, data.atoms c i ∈ data.cuts i := by
  intro i
  have he : data.atoms c i = ∑ s ∈ data.selected i,
      c i s • star (data.tag i s) (square (data.embed i s (data.point i s))) := by
    funext a b
    simpa only [Finset.sum_apply, Pi.smul_apply] using data.atoms_apply c i a b
  rw [he]
  apply Submodule.sum_mem
  intro s hs
  apply Submodule.smul_mem
  apply star_in_cut
  exact Submodule.subset_span
    ⟨s, data.point i s, data.admissible i s hs, data.affine i s hs, rfl⟩

theorem paired_boolean_annihilator (x : J → Profile Tag B)
    (hcut : ∀ i, x i ∈ data.cuts i) (hresponse : x ∈ data.kernel) :
    ∃ (c : J → Γ → F) (r : J → Profile Tag B),
      (∀ i, r i ∈ data.cuts i) ∧
      (∀ a b i, range (r i a b) ≤ (data.Dplus a b).map (primalProjection i) ∧
        range (r i a b) ≤ (data.Dminus a b).map (primalProjection i)) ∧
      x = r + data.atoms c := by
  have hlocal (a b : Tag) :=
    pure_local (data.Dplus a b) (data.Dminus a b) (data.keys a b) (data.keys a b)
      (data.Tplus a b) (data.Tminus a b) (fun i => x i a b) ((hresponse a b).1)
  have hdecomp : ∀ i a b, Nonempty
      (Decomposition data.origin (data.embed i) (x i a b) data.rankBound) := by
    intro i a b
    apply data.label_support i (x i a b)
    · exact cut_component_moment data.origin (data.embed i) (data.allowed i)
        (x i) (hcut i) a b
    · exact (rank_from_quotients (x i a b) _ _ (hlocal a b i)).trans
        (data.rank_budget a b i)
  let d := fun i a b => Classical.choice (hdecomp i a b)
  have hselected : ∀ i a b s, s ∈ data.selected i →
      (s ∈ activeLabels (data.selected i) (data.tag i) a b →
        (d i a b).block s =
          ((d i a b).block s (coordinate data.origin) data.origin) • square (data.point i s)) ∧
      (s ∉ activeLabels (data.selected i) (data.tag i) a b → (d i a b).block s = 0) := by
    intro i a b
    exact decomposition_selected data.origin (data.embed i) (data.point i) data.rankBound
      (x i a b) (d i a b) (data.selected i)
      (activeLabels (data.selected i) (data.tag i) a b) (Finset.filter_subset _ _)
      ((data.Dplus a b).map (primalProjection i))
      ((data.Dminus a b).map (primalProjection i))
      (data.sparsePlus a b i) (data.sparseMinus a b i) (data.affine i) (hlocal a b i)
  have hc : ∀ i, ∃ c : Γ → F, ∀ a b s, s ∈ data.selected i →
      push (data.embed i s) ((d i a b).block s) =
        c s • star (data.tag i s) (square (data.embed i s (data.point i s))) a b := by
    intro i
    exact selected_atoms data.origin (data.embed i) (data.point i) (data.selected i)
      (data.tag i) _ data.rankBound (x i) (hcut i) (d i) (data.interpolation i)
      (hselected i)
  choose c hc using hc
  let r := x - data.atoms c
  have hrkernel : r ∈ data.kernel := data.kernel.sub_mem hresponse (data.atoms_in_kernel c)
  have hrcut : ∀ i, r i ∈ data.cuts i :=
    fun i => (data.cuts i).sub_mem (hcut i) (data.atoms_in_cuts c i)
  let L : Tag → Tag → J → Finset Γ :=
    fun a b i => (d i a b).support \ data.selected i
  let N : Tag → Tag → J → Submodule F B :=
    fun a b i => labelSpace (data.embed i) (L a b i)
  have hremainder (i : J) (a b : Tag) :
      r i a b = ∑ s ∈ L a b i, push (data.embed i s) ((d i a b).block s) := by
    have hh := decomposition_split data.origin (data.embed i) (x i a b)
      data.rankBound (d i a b) (data.selected i)
    have hs : (∑ s ∈ data.selected i, push (data.embed i s) ((d i a b).block s)) =
        data.atoms c i a b := by
      rw [data.atoms_apply]
      exact Finset.sum_congr rfl (fun s hs => hc i a b s hs)
    apply sub_eq_iff_eq_add.mpr
    simpa only [hs, add_comm] using hh
  have hsym (a b : Tag) : ∀ i, Symmetric (r i a b) := by
    intro i φ ψ
    rw [hremainder]
    simp only [LinearMap.sum_apply, map_sum]
    apply Finset.sum_congr rfl
    intro s hs
    exact symmetric_push (data.embed i s) ((d i a b).boolean s).1 φ ψ
  have hN (a b : Tag) : ∀ i, range (r i a b) ≤ N a b i := by
    intro i y hy
    obtain ⟨φ, rfl⟩ := hy
    rw [hremainder]
    simp only [LinearMap.sum_apply, push_apply]
    apply Submodule.sum_mem
    intro s hs
    exact ⟨Pi.single (⟨s, hs⟩ : L a b i)
      ((d i a b).block s (φ.comp (data.embed i s))),
      labelSum_single (data.embed i) (L a b i) ⟨s, hs⟩ _⟩
  have hseparate (a b : Tag) (i : J) (S : Submodule F B)
      (hsp : SparsePins (data.embed i) S (data.selected i)
        (data.rankBound + (data.selected i).card)) :
      Disjoint (data.keys a b i) (N a b i ⊔ S) := by
    apply key_unselected_disjoint data.origin (data.embed i) (data.point i) S
      (data.selected i) (activeLabels (data.selected i) (data.tag i) a b) (L a b i)
      (data.rankBound + (data.selected i).card) (Finset.filter_subset _ _)
    · exact Finset.sdiff_disjoint
    · exact Nat.add_le_add_right
        ((Finset.card_le_card Finset.sdiff_subset).trans (d i a b).card) _
    · exact hsp
    · exact data.affine i
  refine ⟨c, r, hrcut, ?_, ?_⟩
  · intro a b i
    have hp := unselected_effective (data.Dplus a b) (data.Dminus a b)
      (data.keys a b) (data.keys a b) (N a b) (data.Tplus a b) (data.Tminus a b)
      (data.baselinePlus a b) (data.protectedPlus a b) (fun i => r i a b)
      (hsym a b) (hN a b) ((hrkernel a b).1) ((hrkernel a b).2.1)
      (fun i => hseparate a b i _ (data.sparsePlus a b i))
      (fun i => hseparate a b i _ (data.sparseMinus a b i))
      (data.privatePlus a b) (data.injectingPlus a b)
    have hm := unselected_effective (data.Dminus a b) (data.Dplus a b)
      (data.keys a b) (data.keys a b) (N a b) (data.Tminus a b) (data.Tplus a b)
      (data.baselineMinus a b) (data.protectedMinus a b) (fun i => r i a b)
      (hsym a b) (hN a b)
      (pure_swap _ _ _ _ _ _ _ (hsym a b) ((hrkernel a b).1)) ((hrkernel a b).2.2)
      (fun i => hseparate a b i _ (data.sparseMinus a b i))
      (fun i => hseparate a b i _ (data.sparsePlus a b i))
      (data.privateMinus a b) (data.injectingMinus a b)
    exact ⟨hm i, hp i⟩
  · exact (sub_add_cancel x (data.atoms c)).symm

def contraction (_data : PairedBooleanData (J := J) (Tag := Tag) (Γ := Γ) (ι := ι)
    (B := B) (H := H)) (a b : Tag)
    (φ : Module.Dual F (Nominal (J := J) (B := B) (H := H))) :
    (J → Profile Tag B) →ₗ[F] Nominal (J := J) (B := B) (H := H) where
  toFun x := combined (H := H) (fun i => x i a b) φ
  map_add' x y := by
    change combined (H := H) ((fun i => x i a b) + (fun i => y i a b)) φ = _
    rw [combined_add, LinearMap.add_apply]
  map_smul' c x := by
    change combined (H := H) (c • (fun i => x i a b)) φ = _
    rw [combined_smul, LinearMap.smul_apply]
    rfl

def responses : Submodule F (Module.Dual F (J → Profile Tag B)) :=
  Submodule.span F
    ({t | ∃ a b φ ψ,
      φ ∈ (frozen (data.Dplus a b) (data.keys a b) (data.Tplus a b)).dualAnnihilator ∧
      ψ ∈ (frozen (data.Dminus a b) (data.keys a b) (data.Tminus a b)).dualAnnihilator ∧
      t = φ.comp (data.contraction a b ψ)} ∪
    ({t | ∃ a b c ψ,
      c ∈ (data.protectedPlus a b).dualAnnihilator ∧
      ψ ∈ (frozen (data.Dminus a b) (data.keys a b) (data.Tminus a b)).dualAnnihilator ∧
      t = c.comp ((data.baselinePlus a b).comp (data.contraction a b ψ))} ∪
    {t | ∃ a b c φ,
      c ∈ (data.protectedMinus a b).dualAnnihilator ∧
      φ ∈ (frozen (data.Dplus a b) (data.keys a b) (data.Tplus a b)).dualAnnihilator ∧
      t = c.comp ((data.baselineMinus a b).comp (data.contraction a b φ))}))

theorem response_kernel_exact (x : J → Profile Tag B) :
    x ∈ data.kernel ↔ ∀ t ∈ data.responses, t x = 0 := by
  constructor
  · intro hx
    have hspan : data.responses ≤ ker (Module.Dual.eval F (J → Profile Tag B) x) := by
      unfold responses
      apply Submodule.span_le.mpr
      rintro t (hp | hp | hm)
      · obtain ⟨a, b, φ, ψ, hφ, hψ, rfl⟩ := hp
        exact (Submodule.mem_dualAnnihilator φ).mp hφ _ ((hx a b).1 ψ hψ)
      · obtain ⟨a, b, c, ψ, hc, hψ, rfl⟩ := hp
        exact (hx a b).2.1 ψ hψ c hc
      · obtain ⟨a, b, c, φ, hc, hφ, rfl⟩ := hm
        exact (hx a b).2.2 φ hφ c hc
    exact fun t ht => hspan ht
  · intro hx a b
    refine ⟨?_, ?_, ?_⟩
    · intro ψ hψ
      apply (Subspace.forall_mem_dualAnnihilator_apply_eq_zero_iff _ _).mp
      intro φ hφ
      exact hx (φ.comp (data.contraction a b ψ)) (Submodule.subset_span
        (Or.inl ⟨a, b, φ, ψ, hφ, hψ, rfl⟩))
    · intro ψ hψ c hc
      exact hx (c.comp ((data.baselinePlus a b).comp (data.contraction a b ψ)))
        (Submodule.subset_span (Or.inr (Or.inl ⟨a, b, c, ψ, hc, hψ, rfl⟩)))
    · intro φ hφ c hc
      exact hx (c.comp ((data.baselineMinus a b).comp (data.contraction a b φ)))
        (Submodule.subset_span (Or.inr (Or.inr ⟨a, b, c, φ, hc, hφ, rfl⟩)))

def pairedCuts : Submodule F (J → Profile Tag B) where
  carrier := {x | ∀ i, x i ∈ data.cuts i}
  zero_mem' := fun i => (data.cuts i).zero_mem
  add_mem' hx hy := fun i => (data.cuts i).add_mem (hx i) (hy i)
  smul_mem' c x hx := fun i => (data.cuts i).smul_mem c (hx i)

theorem target_annihilates_kernel (t : Module.Dual F (J → Profile Tag B))
    (heffective : ∀ r : J → Profile Tag B, (∀ i, r i ∈ data.cuts i) →
      (∀ a b i, range (r i a b) ≤ (data.Dplus a b).map (primalProjection i) ∧
        range (r i a b) ≤ (data.Dminus a b).map (primalProjection i)) → t r = 0)
    (hatoms : ∀ c : J → Γ → F, t (data.atoms c) = 0) :
    ∀ x ∈ data.pairedCuts ⊓ data.kernel, t x = 0 := by
  intro x hx
  obtain ⟨c, r, hrcut, hre, he⟩ := data.paired_boolean_annihilator x hx.1 hx.2
  rw [he, map_add, heffective r hrcut hre, hatoms c, zero_add]

theorem target_in_response [Fintype Tag]
    (t : Module.Dual F (J → Profile Tag B))
    (heffective : ∀ r : J → Profile Tag B, (∀ i, r i ∈ data.cuts i) →
      (∀ a b i, range (r i a b) ≤ (data.Dplus a b).map (primalProjection i) ∧
        range (r i a b) ≤ (data.Dminus a b).map (primalProjection i)) → t r = 0)
    (hatoms : ∀ c : J → Γ → F, t (data.atoms c) = 0) :
    ∃ q ∈ data.responses, ∀ x ∈ data.pairedCuts, t x = q x := by
  have hkernel : data.kernel = data.responses.dualCoannihilator := by
    ext x
    simpa only [Submodule.mem_dualCoannihilator] using data.response_kernel_exact x
  have ht : t ∈ (data.pairedCuts ⊓ data.kernel).dualAnnihilator :=
    (Submodule.mem_dualAnnihilator t).mpr (data.target_annihilates_kernel t heffective hatoms)
  have hdual : data.kernel.dualAnnihilator = data.responses := by
    rw [hkernel]
    exact Subspace.dualCoannihilator_dualAnnihilator_eq
  rw [Subspace.dualAnnihilator_inf_eq, hdual] at ht
  obtain ⟨p, hp, q, hq, he⟩ := Submodule.mem_sup.mp ht
  refine ⟨q, hq, ?_⟩
  intro x hx
  have hp0 := (Submodule.mem_dualAnnihilator p).mp hp x hx
  have hh := LinearMap.congr_fun he x
  simpa only [LinearMap.add_apply, hp0, zero_add] using hh.symm

end PairedBooleanData

end ActualDomain

end BooleanCutAnnihilator
