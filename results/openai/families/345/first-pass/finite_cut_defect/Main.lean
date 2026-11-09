import Mathlib

set_option autoImplicit false

namespace FiniteCut

open Module

noncomputable section

variable {k V W V' : Type*} [Field k]
  [AddCommGroup V] [Module k V] [AddCommGroup W] [Module k W]
  [AddCommGroup V'] [Module k V']

abbrev sdim (S : Submodule k V) : ℤ := (finrank k S : ℤ)

theorem projection_fixed (p : V →ₗ[k] V)
    (hp : ∀ x, p (p x) = p x) {x : V} (hx : x ∈ LinearMap.range p) :
    p x = x := by
  rcases hx with ⟨y, rfl⟩
  exact hp y

theorem projected_range_le (p : V →ₗ[k] V)
    {A : Type*} [AddCommGroup A] [Module k A] (e : A →ₗ[k] V) :
    LinearMap.range (p.comp e) ≤ LinearMap.range p := by
  rintro x ⟨a, rfl⟩
  exact ⟨e a, rfl⟩

theorem projected_exact
    (p : V →ₗ[k] V) (q : W →ₗ[k] W)
    (f : V →ₗ[k] W) (g : W →ₗ[k] V')
    (hq : ∀ x, q (q x) = q x)
    (hf : ∀ x, q (f x) = f (p x))
    (he : LinearMap.range f = LinearMap.ker g) :
    (LinearMap.range p).map f = LinearMap.range q ⊓ LinearMap.ker g := by
  ext y
  constructor
  · rintro ⟨x, hx, rfl⟩
    constructor
    · rcases hx with ⟨z, rfl⟩
      exact ⟨f z, hf z⟩
    · rw [← he]
      exact ⟨x, rfl⟩
  · rintro ⟨hy, hgy⟩
    have hyf : y ∈ LinearMap.range f := by
      rwa [he]
    rcases hyf with ⟨x, hx⟩
    refine ⟨p x, ⟨x, rfl⟩, ?_⟩
    rw [← hf, hx]
    exact projection_fixed q hq hy

theorem map_dim [FiniteDimensional k V]
    (S : Submodule k V) (f : V →ₗ[k] W) :
    sdim (S.map f) + sdim (S ⊓ LinearMap.ker f) = sdim S := by
  have h := LinearMap.finrank_range_add_finrank_ker (f.domRestrict S)
  have hk : LinearMap.ker (f.domRestrict S) =
      (S ⊓ LinearMap.ker f).comap S.subtype := by
    ext x
    simp
  rw [LinearMap.range_domRestrict, hk,
    (Submodule.comapSubtypeEquivOfLe
      (show S ⊓ LinearMap.ker f ≤ S from inf_le_left)).finrank_eq] at h
  exact_mod_cast h

theorem map_dim_injective [FiniteDimensional k V]
    (S : Submodule k V) (f : V →ₗ[k] W) (hf : Function.Injective f) :
    sdim (S.map f) = sdim S := by
  have h := map_dim S f
  rw [LinearMap.ker_eq_bot.mpr hf, inf_bot_eq] at h
  simpa [sdim] using h

theorem sdim_mono [FiniteDimensional k V] {S T : Submodule k V}
    (h : S ≤ T) : sdim S ≤ sdim T := by
  exact_mod_cast Submodule.finrank_mono h

theorem sdim_nonneg (S : Submodule k V) : 0 ≤ sdim S := by
  exact_mod_cast Nat.zero_le (finrank k S)

theorem range_dim_le [FiniteDimensional k W] (f : V →ₗ[k] W) :
    sdim (LinearMap.range f) ≤ (finrank k W : ℤ) := by
  exact_mod_cast (LinearMap.range f).finrank_le

theorem rank_nullity [FiniteDimensional k V] (f : V →ₗ[k] W) :
    sdim (LinearMap.range f) + sdim (LinearMap.ker f) = (finrank k V : ℤ) := by
  exact_mod_cast LinearMap.finrank_range_add_finrank_ker f

structure Fixed (k V W V' : Type*) [Field k]
    [AddCommGroup V] [Module k V] [AddCommGroup W] [Module k W]
    [AddCommGroup V'] [Module k V'] where
  p : V →ₗ[k] V
  pw : W →ₗ[k] W
  pp : V' →ₗ[k] V'
  p_idem : ∀ x, p (p x) = p x
  pw_idem : ∀ x, pw (pw x) = pw x
  pp_idem : ∀ x, pp (pp x) = pp x
  delta : V →ₗ[k] W
  f : W →ₗ[k] V'
  i : V' →ₗ[k] V
  f_cut : ∀ x, pp (f x) = f (pw x)
  i_cut : ∀ x, p (i x) = i (pp x)
  exact_df : LinearMap.range delta = LinearMap.ker f
  exact_fi : LinearMap.range f = LinearMap.ker i
  exact_id : LinearMap.range i = LinearMap.ker delta

namespace Fixed

variable (F : Fixed k V W V')

abbrev low : Submodule k V := LinearMap.range F.p
abbrev localLow : Submodule k W := LinearMap.range F.pw
abbrev lowNew : Submodule k V' := LinearMap.range F.pp
abbrev localImage : Submodule k V' := F.localLow.map F.f

theorem low_exact :
    F.lowNew.map F.i = F.low ⊓ LinearMap.ker F.delta :=
  projected_exact F.pp F.p F.i F.delta F.p_idem F.i_cut F.exact_id

theorem low_kernel :
    F.lowNew ⊓ LinearMap.ker F.i = F.localImage :=
  (projected_exact F.pw F.pp F.f F.i F.pp_idem F.f_cut F.exact_fi).symm

theorem low_delta
    (hd : ∀ x, F.pw (F.delta x) = F.delta (F.p x)) :
    F.low.map F.delta = F.localLow ⊓ LinearMap.ker F.f :=
  projected_exact F.p F.pw F.delta F.f F.pw_idem hd F.exact_df

theorem low_dimensions [FiniteDimensional k V] [FiniteDimensional k W]
    [FiniteDimensional k V']
    (hd : ∀ x, F.pw (F.delta x) = F.delta (F.p x)) :
    sdim F.localLow = sdim F.localImage + sdim (F.low.map F.delta) ∧
      sdim F.lowNew - sdim F.low =
        sdim F.localImage - sdim (F.low.map F.delta) := by
  have hw := map_dim F.localLow F.f
  have hi := map_dim F.lowNew F.i
  have hv := map_dim F.low F.delta
  rw [← F.low_delta hd] at hw
  rw [F.low_exact, F.low_kernel] at hi
  constructor <;> linarith

theorem low_dimension_bound [FiniteDimensional k V] [FiniteDimensional k W]
    [FiniteDimensional k V'] (M : ℤ) (hM : (finrank k W : ℤ) ≤ M) :
    |sdim F.lowNew - sdim F.low| ≤ M := by
  have hi := map_dim F.lowNew F.i
  have hd := map_dim F.low F.delta
  rw [F.low_exact] at hi
  have hk : sdim (F.lowNew ⊓ LinearMap.ker F.i) ≤ M := by
    have hle : F.lowNew ⊓ LinearMap.ker F.i ≤ LinearMap.range F.f := by
      rw [F.exact_fi]
      exact inf_le_right
    have hr := rank_nullity F.f
    have hz := sdim_nonneg (LinearMap.ker F.f)
    have hm := sdim_mono hle
    linarith
  have hdk : 0 ≤ sdim (F.lowNew ⊓ LinearMap.ker F.i) := sdim_nonneg _
  have hdr : 0 ≤ sdim (F.low.map F.delta) := sdim_nonneg _
  have hdl : sdim (F.low.map F.delta) ≤ M := by
    have hl := (F.low.map F.delta).finrank_le
    have hl' : sdim (F.low.map F.delta) ≤ (finrank k W : ℤ) := by
      exact_mod_cast hl
    linarith
  apply abs_le.mpr
  constructor <;> linarith

end Fixed

variable {C A' A D : Type*}
  [AddCommGroup C] [Module k C] [AddCommGroup A'] [Module k A']
  [AddCommGroup A] [Module k A] [AddCommGroup D] [Module k D]

structure Comparison (F : Fixed k V W V') (C A' A D : Type*)
    [AddCommGroup C] [Module k C] [AddCommGroup A'] [Module k A']
    [AddCommGroup A] [Module k A] [AddCommGroup D] [Module k D] where
  left : C →ₗ[k] A'
  middle : A' →ₗ[k] A
  right : A →ₗ[k] D
  eNew : A' →ₗ[k] V'
  e : A →ₗ[k] V
  localLeft : C →ₗ[k] W
  localRight : D →ₗ[k] W
  exact_left : LinearMap.range left = LinearMap.ker middle
  exact_right : LinearMap.range middle = LinearMap.ker right
  square_left : ∀ x, eNew (left x) = F.f (localLeft x)
  square_middle : ∀ x, e (middle x) = F.i (eNew x)
  square_right : ∀ x, localRight (right x) = F.delta (e x)

namespace Comparison

variable {F : Fixed k V W V'} (Q : Comparison F C A' A D)

abbrev image : Submodule k V := LinearMap.range (F.p.comp Q.e)
abbrev imageNew : Submodule k V' := LinearMap.range (F.pp.comp Q.eNew)

structure Far : Prop where
  delta_cut : ∀ x, F.pw (F.delta x) = F.delta (F.p x)
  left_injective : Function.Injective Q.localLeft
  right_injective : Function.Injective Q.localRight
  left_range : LinearMap.range Q.localLeft = F.localLow
  right_range : LinearMap.range Q.localRight = F.localLow

theorem mixed_image_exact (h : Q.Far) :
    Q.imageNew.map F.i = Q.image ⊓ LinearMap.ker F.delta := by
  ext x
  constructor
  · rintro ⟨y, ⟨b, rfl⟩, rfl⟩
    constructor
    · refine ⟨Q.middle b, ?_⟩
      change F.p (Q.e (Q.middle b)) = F.i (F.pp (Q.eNew b))
      rw [Q.square_middle, F.i_cut]
    · rw [← F.exact_id]
      exact ⟨F.pp (Q.eNew b), rfl⟩
  · rintro ⟨⟨a, rfl⟩, ha⟩
    have hl : Q.localRight (Q.right a) ∈ F.localLow := by
      rw [← h.right_range]
      exact ⟨Q.right a, rfl⟩
    have he : F.delta (F.p (Q.e a)) = F.delta (Q.e a) := by
      rw [← h.delta_cut, ← Q.square_right]
      exact projection_fixed F.pw F.pw_idem hl
    have hz : Q.right a = 0 := by
      apply h.right_injective
      rw [map_zero, Q.square_right, ← he]
      exact ha
    have hg : a ∈ LinearMap.range Q.middle := by
      rw [Q.exact_right]
      exact hz
    rcases hg with ⟨b, hb⟩
    refine ⟨F.pp (Q.eNew b), ⟨b, rfl⟩, ?_⟩
    change F.i (F.pp (Q.eNew b)) = F.p (Q.e a)
    rw [← F.i_cut, ← Q.square_middle, hb]

theorem mixed_image_kernel (h : Q.Far) :
    Q.imageNew ⊓ LinearMap.ker F.i = F.localImage := by
  apply le_antisymm
  · intro x hx
    rw [← F.low_kernel]
    exact ⟨projected_range_le F.pp Q.eNew hx.1, hx.2⟩
  · rintro x ⟨w, hw, hx⟩
    have hl : w ∈ LinearMap.range Q.localLeft := by
      rwa [h.left_range]
    rcases hl with ⟨c, hc⟩
    constructor
    · refine ⟨Q.left c, ?_⟩
      change F.pp (Q.eNew (Q.left c)) = x
      rw [Q.square_left, hc, F.f_cut, projection_fixed F.pw F.pw_idem hw, hx]
    · rw [← F.exact_fi]
      exact ⟨w, hx⟩

theorem mixed_image_dimensions [FiniteDimensional k V] [FiniteDimensional k V']
    (h : Q.Far) :
    sdim Q.imageNew + sdim (Q.image.map F.delta) =
      sdim Q.image + sdim F.localImage := by
  have hi := map_dim Q.imageNew F.i
  have hd := map_dim Q.image F.delta
  rw [Q.mixed_image_exact h, Q.mixed_image_kernel h] at hi
  linarith

theorem image_middle :
    Q.imageNew.map F.i =
      (LinearMap.range Q.middle).map (F.p.comp Q.e) := by
  ext x
  constructor
  · rintro ⟨y, ⟨b, rfl⟩, rfl⟩
    refine ⟨Q.middle b, ⟨b, rfl⟩, ?_⟩
    change F.p (Q.e (Q.middle b)) = F.i (F.pp (Q.eNew b))
    rw [Q.square_middle, F.i_cut]
  · rintro ⟨a, ⟨b, rfl⟩, rfl⟩
    refine ⟨F.pp (Q.eNew b), ⟨b, rfl⟩, ?_⟩
    change F.i (F.pp (Q.eNew b)) = F.p (Q.e (Q.middle b))
    rw [Q.square_middle, F.i_cut]

theorem connecting_rank [FiniteDimensional k D] [FiniteDimensional k V]
    (h : Q.Far) :
    sdim (LinearMap.range Q.right) = sdim (Q.image.map F.delta) := by
  have hc : F.delta.comp (F.p.comp Q.e) = Q.localRight.comp Q.right := by
    ext a
    change F.delta (F.p (Q.e a)) = Q.localRight (Q.right a)
    rw [← h.delta_cut, ← Q.square_right]
    apply projection_fixed F.pw F.pw_idem
    change Q.localRight (Q.right a) ∈ F.localLow
    rw [← h.right_range]
    exact ⟨Q.right a, rfl⟩
  have he : Q.image.map F.delta =
      (LinearMap.range Q.right).map Q.localRight := by
    rw [← LinearMap.range_comp, hc, LinearMap.range_comp]
  rw [he, map_dim_injective _ _ h.right_injective]

theorem local_dimension [FiniteDimensional k C] (h : Q.Far) :
    (finrank k C : ℤ) = sdim F.localLow := by
  have hr := LinearMap.finrank_range_of_inj h.left_injective
  rw [h.left_range] at hr
  exact_mod_cast hr.symm

theorem actual_dimension [FiniteDimensional k C] [FiniteDimensional k A']
    [FiniteDimensional k A] {B : Type*} [AddCommGroup B] [Module k B]
    (b : B →ₗ[k] C) (hb : LinearMap.range b = LinearMap.ker Q.left) :
    (finrank k A' : ℤ) - (finrank k A : ℤ) =
      (finrank k C : ℤ) - sdim (LinearMap.range b) -
        sdim (LinearMap.range Q.right) := by
  have hl := rank_nullity Q.left
  have hm := rank_nullity Q.middle
  have hr := rank_nullity Q.right
  rw [← hb] at hl
  rw [← Q.exact_left] at hm
  rw [← Q.exact_right] at hr
  linarith

theorem deficit_change [FiniteDimensional k V] [FiniteDimensional k W]
    [FiniteDimensional k V'] (h : Q.Far) :
    (sdim F.lowNew - sdim Q.imageNew) - (sdim F.low - sdim Q.image) =
      -(sdim (F.low.map F.delta) - sdim (Q.image.map F.delta)) := by
  have hl := F.low_dimensions h.delta_cut
  have he := Q.mixed_image_dimensions h
  linarith [hl.2]

end Comparison

theorem image_loss
    {B A D : Type*} [AddCommGroup B] [Module k B]
    [AddCommGroup A] [Module k A] [AddCommGroup D] [Module k D]
    [FiniteDimensional k A]
    (e : A →ₗ[k] V) (g : B →ₗ[k] A) (d : A →ₗ[k] D)
    (he : LinearMap.range g = LinearMap.ker d) :
    sdim (LinearMap.range e) - sdim ((LinearMap.range g).map e) ≤
      sdim (LinearMap.range d) := by
  have hm := map_dim (LinearMap.range g) e
  have he' := rank_nullity e
  have hd := rank_nullity d
  rw [← he] at hd
  have hk := sdim_mono
    (show LinearMap.range g ⊓ LinearMap.ker e ≤ LinearMap.ker e from inf_le_right)
  linarith

namespace Comparison

variable {F : Fixed k V W V'} (Q : Comparison F C A' A D)

theorem image_dimension_bound [FiniteDimensional k V] [FiniteDimensional k W]
    [FiniteDimensional k V'] [FiniteDimensional k A] [FiniteDimensional k D]
    (M : ℤ) (hW : (finrank k W : ℤ) ≤ M) (hD : (finrank k D : ℤ) ≤ M) :
    |sdim Q.imageNew - sdim Q.image| ≤ M := by
  have hi := map_dim Q.imageNew F.i
  have hk : sdim (Q.imageNew ⊓ LinearMap.ker F.i) ≤ M := by
    have hle : Q.imageNew ⊓ LinearMap.ker F.i ≤ LinearMap.range F.f := by
      rw [F.exact_fi]
      exact inf_le_right
    have hr := rank_nullity F.f
    have hz := sdim_nonneg (LinearMap.ker F.f)
    have hm := sdim_mono hle
    linarith
  have hl := image_loss (F.p.comp Q.e) Q.middle Q.right Q.exact_right
  rw [← Q.image_middle] at hl
  have hr := range_dim_le Q.right
  have hz := sdim_nonneg (Q.imageNew ⊓ LinearMap.ker F.i)
  have hm : sdim (Q.imageNew.map F.i) ≤ sdim Q.image := by
    apply sdim_mono
    rw [Q.image_middle]
    rintro x ⟨a, ha, rfl⟩
    exact ⟨a, rfl⟩
  apply abs_le.mpr
  constructor <;> linarith

include Q in
theorem actual_dimension_bound [FiniteDimensional k C] [FiniteDimensional k A']
    [FiniteDimensional k A] [FiniteDimensional k D]
    (M : ℤ) (hC : (finrank k C : ℤ) ≤ M) (hD : (finrank k D : ℤ) ≤ M) :
    |(finrank k A' : ℤ) - (finrank k A : ℤ)| ≤ M := by
  have hl := rank_nullity Q.left
  have hm := rank_nullity Q.middle
  have hr := rank_nullity Q.right
  rw [← Q.exact_left] at hm
  rw [← Q.exact_right] at hr
  have hz := sdim_nonneg (LinearMap.ker Q.left)
  have hzl := sdim_nonneg (LinearMap.range Q.left)
  have hzr := sdim_nonneg (LinearMap.range Q.right)
  have hrd := range_dim_le Q.right
  apply abs_le.mpr
  constructor <;> linarith

end Comparison

def potential {B : Type*} [AddCommGroup B] [Module k B]
    (p : V →ₗ[k] V) (ePrev : B →ₗ[k] V) (e : A →ₗ[k] V) : ℤ :=
  (sdim (LinearMap.range p) - sdim (LinearMap.range (p.comp e))) +
  (sdim (LinearMap.range p) - sdim (LinearMap.range (p.comp ePrev))) +
  sdim (LinearMap.range e ⊓ LinearMap.ker p) + sdim (LinearMap.ker e)

theorem potential_formula [FiniteDimensional k A] [FiniteDimensional k V]
    {B : Type*} [AddCommGroup B] [Module k B]
    (p : V →ₗ[k] V) (ePrev : B →ₗ[k] V) (e : A →ₗ[k] V) :
    potential p ePrev e =
      2 * sdim (LinearMap.range p) -
      2 * sdim (LinearMap.range (p.comp e)) -
      sdim (LinearMap.range (p.comp ePrev)) + (finrank k A : ℤ) := by
  have he := rank_nullity e
  have hp := map_dim (LinearMap.range e) p
  rw [← LinearMap.range_comp] at hp
  unfold potential
  linarith

theorem potential_nonneg [FiniteDimensional k V]
    {B : Type*} [AddCommGroup B] [Module k B]
    (p : V →ₗ[k] V) (ePrev : B →ₗ[k] V) (e : A →ₗ[k] V) :
    0 ≤ potential p ePrev e := by
  have h0 := sdim_mono (projected_range_le p e)
  have h1 := sdim_mono (projected_range_le p ePrev)
  have h2 := sdim_nonneg (LinearMap.range e ⊓ LinearMap.ker p)
  have h3 := sdim_nonneg (LinearMap.ker e)
  unfold potential
  linarith

variable {C₀ A₀' A₀ : Type*}
  [AddCommGroup C₀] [Module k C₀] [AddCommGroup A₀'] [Module k A₀']
  [AddCommGroup A₀] [Module k A₀]

theorem far_event
    [FiniteDimensional k V] [FiniteDimensional k W] [FiniteDimensional k V']
    [FiniteDimensional k C₀] [FiniteDimensional k A₀'] [FiniteDimensional k A₀]
    [FiniteDimensional k C] [FiniteDimensional k A'] [FiniteDimensional k A]
    [FiniteDimensional k D]
    (F : Fixed k V W V')
    (Qprev : Comparison F C₀ A₀' A₀ C) (Q : Comparison F C A' A D)
    (hprev : Qprev.Far) (h : Q.Far)
    (_hlocal : Qprev.localRight = Q.localLeft)
    (hjoin : LinearMap.range Qprev.right = LinearMap.ker Q.left) :
    potential F.pp Qprev.eNew Q.eNew - potential F.p Qprev.e Q.e =
        -(sdim (F.low.map F.delta) - sdim (Q.image.map F.delta)) ∧
      potential F.pp Qprev.eNew Q.eNew - potential F.p Qprev.e Q.e ≤ 0 := by
  have hp := Qprev.mixed_image_dimensions hprev
  have hc := Q.mixed_image_dimensions h
  have hl := F.low_dimensions h.delta_cut
  have ha := Q.actual_dimension Qprev.right hjoin
  have hrp := Qprev.connecting_rank hprev
  have hrc := Q.connecting_rank h
  have hcl := Q.local_dimension h
  have hφ := potential_formula F.p Qprev.e Q.e
  have hφ' := potential_formula F.pp Qprev.eNew Q.eNew
  have hm : sdim (Q.image.map F.delta) ≤ sdim (F.low.map F.delta) :=
    sdim_mono (Submodule.map_mono (projected_range_le F.p Q.e))
  constructor <;> linarith [hl.1, hl.2]

theorem exceptional_event
    [FiniteDimensional k V] [FiniteDimensional k W] [FiniteDimensional k V']
    [FiniteDimensional k A₀] [FiniteDimensional k C]
    [FiniteDimensional k A'] [FiniteDimensional k A] [FiniteDimensional k D]
    (F : Fixed k V W V')
    (Qprev : Comparison F C₀ A₀' A₀ C) (Q : Comparison F C A' A D)
    (M : ℤ) (hW : (finrank k W : ℤ) ≤ M)
    (hC : (finrank k C : ℤ) ≤ M) (hD : (finrank k D : ℤ) ≤ M) :
    |potential F.pp Qprev.eNew Q.eNew - potential F.p Qprev.e Q.e| ≤ 6 * M := by
  have hl := abs_le.mp (F.low_dimension_bound M hW)
  have hp := abs_le.mp (Qprev.image_dimension_bound M hW hC)
  have hc := abs_le.mp (Q.image_dimension_bound M hW hD)
  have ha := abs_le.mp (Q.actual_dimension_bound M hC hD)
  have hφ := potential_formula F.p Qprev.e Q.e
  have hφ' := potential_formula F.pp Qprev.eNew Q.eNew
  apply abs_le.mpr
  constructor <;> linarith [hl.1, hl.2, hp.1, hp.2, hc.1, hc.2, ha.1, ha.2]

section RootDegrees

variable {ι κ : Type*}

def rootCut (labels : ι → ℤ) (j : ℤ) : (ι → k) →ₗ[k] (ι → k) where
  toFun x a := if labels a ≤ j then x a else 0
  map_add' x y := by
    ext a
    by_cases h : labels a ≤ j <;> simp [h]
  map_smul' c x := by
    ext a
    by_cases h : labels a ≤ j <;> simp [h]

theorem rootCut_idem (labels : ι → ℤ) (j : ℤ) (x : ι → k) :
    rootCut labels j (rootCut labels j x) = rootCut labels j x := by
  ext a
  by_cases h : labels a ≤ j <;> simp [rootCut, h]

theorem cut_matrix [Fintype ι] (vl : ι → ℤ) (wl : κ → ℤ) (j : ℤ)
    (T : Matrix κ ι k)
    (hc : ∀ b a, T b a ≠ 0 → (wl b ≤ j ↔ vl a ≤ j)) (x : ι → k) :
    rootCut wl j (T.mulVec x) = T.mulVec (rootCut vl j x) := by
  ext b
  change (if wl b ≤ j then ∑ a, T b a * x a else 0) =
    ∑ a, T b a * (if vl a ≤ j then x a else 0)
  by_cases hb : wl b ≤ j
  · rw [if_pos hb]
    apply Finset.sum_congr rfl
    intro a ha
    by_cases ht : T b a = 0
    · simp [ht]
    · simp [(hc b a ht).mp hb]
  · rw [if_neg hb]
    symm
    apply Finset.sum_eq_zero
    intro a ha
    by_cases ht : T b a = 0
    · simp [ht]
    · have hv : ¬vl a ≤ j := fun hv => hb ((hc b a ht).mpr hv)
      simp [hv]

theorem degree_zero_cut [Fintype ι] (vl : ι → ℤ) (wl : κ → ℤ) (j : ℤ)
    (T : Matrix κ ι k) (hg : ∀ b a, T b a ≠ 0 → wl b = vl a) (x : ι → k) :
    rootCut wl j (T.mulVec x) = T.mulVec (rootCut vl j x) := by
  apply cut_matrix vl wl j T
  intro b a ht
  rw [hg b a ht]

theorem degree_one_cut [Fintype ι] (vl : ι → ℤ) (wl : κ → ℤ) (j : ℤ)
    (T : Matrix κ ι k) (hg : ∀ b a, T b a ≠ 0 → wl b = vl a + 1)
    (hz : ∀ b, wl b ≠ j + 1) (x : ι → k) :
    rootCut wl j (T.mulVec x) = T.mulVec (rootCut vl j x) := by
  apply cut_matrix vl wl j T
  intro b a ht
  have hg' := hg b a ht
  have hz' := hz b
  constructor <;> intro h <;> omega

end RootDegrees

section EventCounting

variable {ι : Type*} [DecidableEq ι]

theorem one_event_bound (S T : Finset ι) (before after : ι → ℤ)
    (b : ℤ) (hb : 0 ≤ b)
    (hfar : ∀ j ∈ S, j ∉ T → after j - before j ≤ 0)
    (hnear : ∀ j ∈ S, j ∈ T → after j - before j ≤ b) :
    (∑ j ∈ S, (after j - before j)) ≤ b * (T.card : ℤ) := by
  have hcard : (S.filter (fun j => j ∈ T)).card ≤ T.card :=
    Finset.card_le_card (by
      intro j hj
      exact (Finset.mem_filter.mp hj).2)
  calc
    (∑ j ∈ S, (after j - before j)) ≤
        ∑ j ∈ S, (if j ∈ T then b else 0) := by
      apply Finset.sum_le_sum
      intro j hj
      by_cases ht : j ∈ T
      · simpa [ht] using hnear j hj ht
      · simpa [ht] using hfar j hj ht
    _ = ((S.filter (fun j => j ∈ T)).card : ℤ) * b := by
      simp only [Finset.sum_ite, Finset.sum_const, nsmul_eq_mul,
        mul_zero, add_zero]
    _ ≤ (T.card : ℤ) * b := by
      apply mul_le_mul_of_nonneg_right _ hb
      exact_mod_cast hcard
    _ = b * (T.card : ℤ) := mul_comm _ _

theorem event_sum (N K : ℕ) (S : Finset ι) (E : ℕ → Finset ι)
    (Φ : ℕ → ι → ℤ) (b : ℤ) (hb : 0 ≤ b)
    (hzero : ∀ j ∈ S, Φ 0 j = 0)
    (hfar : ∀ e < N, ∀ j ∈ S, j ∉ E e → Φ (e + 1) j - Φ e j ≤ 0)
    (hnear : ∀ e < N, ∀ j ∈ S, j ∈ E e → Φ (e + 1) j - Φ e j ≤ b)
    (hcard : ∀ e < N, (E e).card ≤ K) :
    (∑ j ∈ S, Φ N j) ≤ b * (K : ℤ) * (N : ℤ) := by
  have aux : ∀ n : ℕ, n ≤ N →
      (∑ j ∈ S, Φ n j) ≤ b * (K : ℤ) * (n : ℤ) := by
    intro n
    induction n with
    | zero =>
      intro hn
      have hz : (∑ j ∈ S, Φ 0 j) = 0 := Finset.sum_eq_zero hzero
      simp [hz]
    | succ n ih =>
      intro hn
      have hn' : n < N := by omega
      have hi := ih (by omega)
      have hs := one_event_bound S (E n) (Φ n) (Φ (n + 1)) b hb
        (hfar n hn') (hnear n hn')
      rw [Finset.sum_sub_distrib] at hs
      have hc : ((E n).card : ℤ) ≤ (K : ℤ) := by
        exact_mod_cast hcard n hn'
      have hbc := mul_le_mul_of_nonneg_left hc hb
      calc
        (∑ j ∈ S, Φ (n + 1) j) ≤ (∑ j ∈ S, Φ n j) + b * (K : ℤ) := by
          linarith
        _ ≤ b * (K : ℤ) * (n : ℤ) + b * (K : ℤ) := by linarith
        _ = b * (K : ℤ) * ((n + 1 : ℕ) : ℤ) := by
          push_cast
          ring
  exact aux N le_rfl

theorem window_card (S : Finset ℤ) (I : ℤ) (c : ℕ) :
    (S.filter (fun j => |I - 2 * j| ≤ (c : ℤ))).card ≤ 2 * c + 1 := by
  have hm : Set.MapsTo (fun j : ℤ => 2 * j)
      (S.filter (fun j => |I - 2 * j| ≤ (c : ℤ)))
      (Finset.Icc (I - (c : ℤ)) (I + (c : ℤ))) := by
    intro j hj
    have h := abs_le.mp (Finset.mem_filter.mp hj).2
    apply Finset.mem_Icc.mpr
    change I - (c : ℤ) ≤ 2 * j ∧ 2 * j ≤ I + (c : ℤ)
    constructor <;> omega
  have hinj : Function.Injective (fun j : ℤ => 2 * j) := by
    intro a b h
    change 2 * a = 2 * b at h
    omega
  have hc := Finset.card_le_card_of_injOn (fun j : ℤ => 2 * j) hm hinj.injOn
  rw [Int.card_Icc] at hc
  have hl : I + (c : ℤ) + 1 - (I - (c : ℤ)) = ((2 * c + 1 : ℕ) : ℤ) := by
    omega
  rw [hl] at hc
  simpa only [Int.toNat_natCast] using hc

theorem window_union_card (labels : Finset ι) (index : ι → ℤ)
    (S : Finset ℤ) (c : ℕ) :
    (S.filter (fun j => ∃ a ∈ labels, |index a - 2 * j| ≤ (c : ℤ))).card ≤
      labels.card * (2 * c + 1) := by
  classical
  induction labels using Finset.induction_on with
  | empty => simp
  | @insert a labels ha ih =>
    have he : (S.filter (fun j => ∃ t ∈ insert a labels,
        |index t - 2 * j| ≤ (c : ℤ))) =
        (S.filter (fun j => |index a - 2 * j| ≤ (c : ℤ))) ∪
        (S.filter (fun j => ∃ t ∈ labels, |index t - 2 * j| ≤ (c : ℤ))) := by
      ext j
      simp [and_or_left]
    rw [he]
    calc
      _ ≤ (S.filter (fun j => |index a - 2 * j| ≤ (c : ℤ))).card +
          (S.filter (fun j => ∃ t ∈ labels,
            |index t - 2 * j| ≤ (c : ℤ))).card := Finset.card_union_le _ _
      _ ≤ (2 * c + 1) + labels.card * (2 * c + 1) :=
        add_le_add (window_card S (index a) c) ih
      _ = (insert a labels).card * (2 * c + 1) := by
        rw [Finset.card_insert_of_notMem ha]
        ring

end EventCounting

end

end FiniteCut
