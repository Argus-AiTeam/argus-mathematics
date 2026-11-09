import Mathlib

noncomputable section

open Module LinearMap Function

namespace ProtectedChannels

variable {K : Type} [Field K]
variable {L R H X V W : Type}
variable [AddCommGroup L] [Module K L]
variable [AddCommGroup R] [Module K R]
variable [AddCommGroup H] [Module K H]
variable [AddCommGroup X] [Module K X]
variable [AddCommGroup V] [Module K V]
variable [AddCommGroup W] [Module K W]

theorem finrank_comp_left [FiniteDimensional K W]
    (f : V →ₗ[K] W) (g : X →ₗ[K] V) :
    finrank K (range (f.comp g)) ≤ finrank K (range f) := by
  apply Submodule.finrank_mono
  rintro _ ⟨x, rfl⟩
  exact ⟨g x, rfl⟩

theorem finrank_comp_right [FiniteDimensional K V]
    (f : V →ₗ[K] W) (g : X →ₗ[K] V) [FiniteDimensional K X] :
    finrank K (range (f.comp g)) ≤ finrank K (range g) := by
  rw [range_comp]
  exact Submodule.finrank_map_le f (range g)

theorem finrank_add [FiniteDimensional K V] [FiniteDimensional K W]
    (f g : V →ₗ[K] W) :
    finrank K (range (f + g)) ≤ finrank K (range f) + finrank K (range g) := by
  let a := f.rangeRestrict.prod g.rangeRestrict
  let b := (range f).subtype.coprod (range g).subtype
  have he : f + g = b.comp a := by ext x; rfl
  rw [he]
  calc
    finrank K (range (b.comp a)) ≤ finrank K (range b) := finrank_comp_left b a
    _ ≤ finrank K (range f × range g) := b.finrank_range_le
    _ = finrank K (range f) + finrank K (range g) := Module.finrank_prod

theorem response_solvable [FiniteDimensional K X]
    (response : V →ₗ[K] Module.Dual K X) (target : Module.Dual K X)
    (h : ∀ x, (∀ v, response v x = 0) → target x = 0) :
    ∃ v, response v = target := by
  have ht : target ∈ (range response).dualCoannihilator.dualAnnihilator := by
    rw [Submodule.mem_dualAnnihilator]
    intro x hx
    apply h x
    intro v
    exact (Submodule.mem_dualCoannihilator x).mp hx (response v) ⟨v, rfl⟩
  rw [Subspace.dualCoannihilator_dualAnnihilator_eq] at ht
  exact ht

theorem response_solvable_from_isolation [FiniteDimensional K X]
    (response : V →ₗ[K] Module.Dual K X) (target : Module.Dual K X)
    (effective selected : Submodule K X)
    (hisolation : (range response).dualCoannihilator ≤ effective ⊔ selected)
    (heffective : ∀ x ∈ effective, target x = 0)
    (hselected : ∀ x ∈ selected, target x = 0) :
    ∃ v, response v = target := by
  apply response_solvable response target
  intro x hx
  have hmem : x ∈ (range response).dualCoannihilator := by
    rw [Submodule.mem_dualCoannihilator]
    rintro _ ⟨v, rfl⟩
    exact hx v
  obtain ⟨a, ha, b, hb, hab⟩ := Submodule.mem_sup.mp (hisolation hmem)
  rw [← hab, map_add, heffective a ha, hselected b hb, zero_add]

theorem compression [FiniteDimensional K V] [FiniteDimensional K W]
    (U : Submodule K V) (f : V →ₗ[K] W) :
    ∃ C : V →ₗ[K] V,
      (∀ u : U, C u = u) ∧ f.comp C = f ∧
      finrank K (range C) ≤ finrank K U + finrank K (range f) := by
  obtain ⟨r, hr⟩ := U.subtype.exists_leftInverse_of_injective U.ker_subtype
  obtain ⟨s, hs⟩ :=
    f.rangeRestrict.exists_rightInverse_of_surjective f.range_rangeRestrict
  let P : V →ₗ[K] V := U.subtype.comp r
  let a : V →ₗ[K] U × range f :=
    r.prod (f.rangeRestrict.comp (LinearMap.id - P))
  let b : U × range f →ₗ[K] V := U.subtype.coprod s
  let C : V →ₗ[K] V := b.comp a
  have hru (u : U) : r u = u := LinearMap.congr_fun hr u
  have hsf (v : range f) : f (s v) = (v : W) :=
    congrArg Subtype.val (LinearMap.congr_fun hs v)
  refine ⟨C, ?_, ?_, ?_⟩
  · intro u
    change (r (u : V) : V) + s (f.rangeRestrict ((u : V) - P u)) = u
    have hz : (u : V) - P u = 0 := by simp [P, hru]
    rw [hz]
    simp [hru]
  · ext v
    simp [C, b, a, P, hsf, map_sub]
  · calc
      finrank K (range C) ≤ finrank K (range b) := finrank_comp_left b a
      _ ≤ finrank K (U × range f) := b.finrank_range_le
      _ = finrank K U + finrank K (range f) := Module.finrank_prod

theorem factor_through_pairing [FiniteDimensional K L] [FiniteDimensional K R]
    [FiniteDimensional K V] [FiniteDimensional K W]
    (pair : V →ₗ[K] W →ₗ[K] K) (B : L →ₗ[K] R →ₗ[K] K)
    (hrank : finrank K (range B) ≤ finrank K (range pair)) :
    ∃ F : L →ₗ[K] V, ∃ G : R →ₗ[K] W,
      ∀ x y, pair (F x) (G y) = B x y := by
  let E : Submodule K (Module.Dual K R) := range B
  let S : Submodule K (Module.Dual K W) := range pair
  letI : AddCommGroup E := inferInstance
  letI : AddCommGroup S := inferInstance
  letI : Module.Free K E := Module.Free.of_divisionRing K E
  letI : Module.Free K S := Module.Free.of_divisionRing K S
  obtain ⟨j, hj⟩ : ∃ j : E →ₗ[K] S, Function.Injective j :=
    finrank_le_iff_exists_linearMap.mp hrank
  have hjker : LinearMap.ker j = ⊥ := by
    apply eq_bot_iff.mpr
    intro x hx
    have hz : j x = j 0 := (mem_ker.mp hx).trans j.map_zero.symm
    have hx0 : x = 0 := hj hz
    simp [hx0]
  obtain ⟨l, hl⟩ : ∃ l : S →ₗ[K] E, l.comp j = LinearMap.id :=
    LinearMap.exists_leftInverse_of_injective j hjker
  obtain ⟨s, hs⟩ :=
    pair.rangeRestrict.exists_rightInverse_of_surjective pair.range_rangeRestrict
  let ev : W →ₗ[K] Module.Dual K S :=
    S.dualRestrict.comp (Module.Dual.eval K W)
  have hev : Function.Surjective ev :=
    (Subspace.dualRestrict_surjective (W := S)).comp
      (Module.bijective_dual_eval K W).surjective
  obtain ⟨t, ht⟩ := ev.exists_rightInverse_of_surjective (range_eq_top.mpr hev)
  let T : R →ₗ[K] Module.Dual K S := (E.subtype.comp l).flip
  refine ⟨s.comp (j.comp B.rangeRestrict), t.comp T, ?_⟩
  intro x y
  have hsx := LinearMap.congr_fun hs (j (B.rangeRestrict x))
  have hty := LinearMap.congr_fun ht (T y)
  have hlx := LinearMap.congr_fun hl (B.rangeRestrict x)
  change l (j (B.rangeRestrict x)) = B.rangeRestrict x at hlx
  change pair (s (j (B.rangeRestrict x))) (t (T y)) = B x y
  have hp : pair (s (j (B.rangeRestrict x))) =
      (j (B.rangeRestrict x) : Module.Dual K W) :=
    congrArg Subtype.val hsx
  rw [hp]
  have he := LinearMap.congr_fun hty (j (B.rangeRestrict x))
  change (j (B.rangeRestrict x) : Module.Dual K W) (t (T y)) =
    (l (j (B.rangeRestrict x)) : Module.Dual K R) y at he
  rw [he, hlx]
  rfl

theorem restricted_pairing_rank [FiniteDimensional K H]
    (pair : H →ₗ[K] H →ₗ[K] K) (hp : Function.Injective pair)
    (A B : Submodule K H) :
    finrank K A + finrank K B ≤
      finrank K (range (pair.compl₁₂ A.subtype B.subtype)) + finrank K H := by
  let q := pair.compl₁₂ A.subtype B.subtype
  let k := ker q
  let j : k →ₗ[K] B.dualAnnihilator :=
    (pair.comp (A.subtype.comp k.subtype)).codRestrict B.dualAnnihilator (by
      intro x
      rw [Submodule.mem_dualAnnihilator]
      intro y hy
      have hx := x.property
      have hxy := LinearMap.congr_fun (mem_ker.mp hx) ⟨y, hy⟩
      exact hxy)
  have hj : Function.Injective j := by
    intro x y hxy
    apply Subtype.ext
    apply Subtype.ext
    apply hp
    exact congrArg Subtype.val hxy
  have hd := LinearMap.finrank_le_finrank_of_injective hj
  have hn := q.finrank_range_add_finrank_ker
  have ha := Subspace.finrank_add_finrank_dualAnnihilator_eq B
  change finrank K k ≤ finrank K B.dualAnnihilator at hd
  change finrank K (range q) + finrank K k = finrank K A at hn
  change finrank K B + finrank K B.dualAnnihilator = finrank K H at ha
  dsimp only [q] at hn
  omega

theorem factor_with_codimensions [FiniteDimensional K H]
    [FiniteDimensional K L] [FiniteDimensional K R]
    (pair : H →ₗ[K] H →ₗ[K] K) (hp : Function.Injective pair)
    (A B : Submodule K H) (M : L →ₗ[K] R →ₗ[K] K) (cA cB : ℕ)
    (hA : finrank K H ≤ finrank K A + cA)
    (hB : finrank K H ≤ finrank K B + cB)
    (hbudget : finrank K (range M) + cA + cB ≤ finrank K H) :
    ∃ F : L →ₗ[K] A, ∃ G : R →ₗ[K] B,
      ∀ x y, pair (F x) (G y) = M x y := by
  have hr := restricted_pairing_rank pair hp A B
  have hm : finrank K (range M) ≤
      finrank K (range (pair.compl₁₂ A.subtype B.subtype)) := by omega
  exact factor_through_pairing (pair.compl₁₂ A.subtype B.subtype) M hm

def pull (a : V →ₗ[K] L) (b : W →ₗ[K] R) :
    (L →ₗ[K] R →ₗ[K] K) →ₗ[K] (V →ₗ[K] W →ₗ[K] K) where
  toFun M := M.compl₁₂ a b
  map_add' M N := by ext x y; simp
  map_smul' c M := by ext x y; simp

theorem compressed_rank [FiniteDimensional K L] [FiniteDimensional K R]
    (M : L →ₗ[K] R →ₗ[K] K) (C : L →ₗ[K] L) (D : R →ₗ[K] R) :
    finrank K (range (M.compl₁₂ C D)) ≤ finrank K (range C) := by
  have he : M.compl₁₂ C D = D.dualMap.comp (M.comp C) := by ext x y; rfl
  rw [he]
  exact (finrank_comp_right D.dualMap (M.comp C)).trans (finrank_comp_right M C)

section Completion

variable {P Q : Type} [AddCommGroup P] [Module K P] [AddCommGroup Q] [Module K Q]

theorem protected_realization
    [FiniteDimensional K L] [FiniteDimensional K R]
    [FiniteDimensional K H] [FiniteDimensional K X]
    (pair : H →ₗ[K] H →ₗ[K] K) (hp : Function.Injective pair)
    (A B : Submodule K H) (frozenL : Submodule K V) (frozenR : Submodule K W)
    (qL : V →ₗ[K] L) (qR : W →ₗ[K] R)
    (iL : P →ₗ[K] V) (iR : Q →ₗ[K] W)
    (F₀ : P →ₗ[K] H) (G₀ : Q →ₗ[K] H)
    (eval : (P →ₗ[K] Q →ₗ[K] K) →ₗ[K] Module.Dual K X)
    (target : Module.Dual K X) (M₀ : L →ₗ[K] R →ₗ[K] K)
    (C : L →ₗ[K] L) (D : R →ₗ[K] R) (CX : X →ₗ[K] X)
    (cA cB : ℕ)
    (hqL : ∀ x ∈ frozenL, qL x = 0)
    (hqR : ∀ y ∈ frozenR, qR y = 0)
    (horthA : ∀ a : A, ∀ y, pair a (G₀ y) = 0)
    (horthB : ∀ x, ∀ b : B, pair (F₀ x) b = 0)
    (hA : finrank K H ≤ finrank K A + cA)
    (hB : finrank K H ≤ finrank K B + cB)
    (hbudget : finrank K (range M₀) + finrank K (range C) + cA + cB ≤ finrank K H)
    (hnatural : ∀ M : L →ₗ[K] R →ₗ[K] K,
      eval (pull (qL.comp iL) (qR.comp iR) (M.compl₁₂ C D)) =
        (eval (pull (qL.comp iL) (qR.comp iR) M)).comp CX)
    (hinvariant :
      (target - eval (pair.compl₁₂ F₀ G₀) -
        eval (pull (qL.comp iL) (qR.comp iR) M₀)).comp CX =
      target - eval (pair.compl₁₂ F₀ G₀) -
        eval (pull (qL.comp iL) (qR.comp iR) M₀))
    (hann : ∀ x,
      (∀ M : L →ₗ[K] R →ₗ[K] K,
        eval (pull (qL.comp iL) (qR.comp iR) M) x = 0) →
      (target - eval (pair.compl₁₂ F₀ G₀) -
        eval (pull (qL.comp iL) (qR.comp iR) M₀)) x = 0) :
    ∃ dF : V →ₗ[K] H, ∃ dG : W →ₗ[K] H,
      (∀ x ∈ frozenL, dF x = 0) ∧
      (∀ y ∈ frozenR, dG y = 0) ∧
      (∀ x, dF x ∈ A) ∧ (∀ y, dG y ∈ B) ∧
      eval (pair.compl₁₂ (F₀ + dF.comp iL) (G₀ + dG.comp iR)) = target := by
  let response : (L →ₗ[K] R →ₗ[K] K) →ₗ[K] Module.Dual K X :=
    eval.comp (pull (qL.comp iL) (qR.comp iR))
  let residual : Module.Dual K X := target - eval (pair.compl₁₂ F₀ G₀) -
    eval (pull (qL.comp iL) (qR.comp iR) M₀)
  have hann' : ∀ x, (∀ M, response M x = 0) → residual x = 0 := by
    intro x hx
    exact hann x hx
  obtain ⟨M, hM⟩ := response_solvable
    (K := K) (V := L →ₗ[K] R →ₗ[K] K) (X := X) response residual hann'
  let MC := M.compl₁₂ C D
  have hMC : response MC = residual := by
    change eval (pull (qL.comp iL) (qR.comp iR) (M.compl₁₂ C D)) = residual
    rw [hnatural]
    change (response M).comp CX = residual
    rw [hM]
    exact hinvariant
  let MT := M₀ + MC
  have hr : finrank K (range MT) + cA + cB ≤ finrank K H := by
    have hsum := finrank_add M₀ MC
    have hc := compressed_rank M C D
    change finrank K (range MC) ≤ finrank K (range C) at hc
    change finrank K (range (M₀ + MC)) + cA + cB ≤ finrank K H
    omega
  obtain ⟨F, G, hFG⟩ := factor_with_codimensions pair hp A B MT cA cB hA hB hr
  let dF := A.subtype.comp (F.comp qL)
  let dG := B.subtype.comp (G.comp qR)
  refine ⟨dF, dG, ?_, ?_, ?_, ?_, ?_⟩
  · intro x hx
    simp [dF, hqL x hx]
  · intro y hy
    simp [dG, hqR y hy]
  · intro x
    exact (F (qL x)).property
  · intro y
    exact (G (qR y)).property
  · have he :
        pair.compl₁₂ (F₀ + dF.comp iL) (G₀ + dG.comp iR) =
        pair.compl₁₂ F₀ G₀ + pull (qL.comp iL) (qR.comp iR) MT := by
      ext x y
      change pair (F₀ x + (F (qL (iL x)) : H))
          (G₀ y + (G (qR (iR y)) : H)) =
        pair (F₀ x) (G₀ y) + MT (qL (iL x)) (qR (iR y))
      simp only [map_add, LinearMap.add_apply]
      rw [horthA, horthB, hFG]
      ring
    rw [he, map_add]
    have ht : eval (pull (qL.comp iL) (qR.comp iR) MT) =
        eval (pull (qL.comp iL) (qR.comp iR) M₀) + residual := by
      change response (M₀ + MC) = response M₀ + residual
      rw [map_add, hMC]
    rw [ht]
    dsimp only [residual]
    abel

end Completion

section Assembly

variable {I J : Type} [Fintype I] [Fintype J]

def assemble (pair : H →ₗ[K] H →ₗ[K] K)
    (F : J → V →ₗ[K] H) (G : I → W →ₗ[K] H)
    (cL : I → V →ₗ[K] H) (cR : J → W →ₗ[K] H) :
    V →ₗ[K] W →ₗ[K] K :=
  (∑ j, pair.compl₁₂ (F j) (cR j)) +
    ∑ i, pair.compl₁₂ (cL i) (G i)

theorem assemble_frozen
    (pair : H →ₗ[K] H →ₗ[K] K)
    (F : J → V →ₗ[K] H) (G : I → W →ₗ[K] H)
    (cL : I → V →ₗ[K] H) (cR : J → W →ₗ[K] H)
    (DL : Submodule K V) (DR : Submodule K W)
    (hF : ∀ j x, x ∈ DL → F j x = 0)
    (hG : ∀ i y, y ∈ DR → G i y = 0)
    (hleft : ∀ i x, x ∈ DL → ∀ y, pair (cL i x) (G i y) = 0)
    (hright : ∀ j y, y ∈ DR → ∀ x, pair (F j x) (cR j y) = 0) :
    (∀ x ∈ DL, ∀ y, assemble pair F G cL cR x y = 0) ∧
      (∀ y ∈ DR, ∀ x, assemble pair F G cL cR x y = 0) := by
  constructor
  · intro x hx y
    simp [assemble, hF _ x hx, hleft _ x hx y]
  · intro y hy x
    simp [assemble, hG _ y hy, hright _ y hy x]

theorem assemble_primal_channel [DecidableEq J]
    (pair : H →ₗ[K] H →ₗ[K] K)
    (F : J → V →ₗ[K] H) (G : I → W →ₗ[K] H)
    (cL : I → V →ₗ[K] H) (cR : J → W →ₗ[K] H)
    (primal : X →ₗ[K] V) (channel : J → H →ₗ[K] W)
    (hprimal : ∀ i x, cL i (primal x) = 0)
    (hchannel : ∀ j c k, cR k (channel j c) = if k = j then c else 0) :
    ∀ x j c, assemble pair F G cL cR (primal x) (channel j c) =
      pair (F j (primal x)) c := by
  intro x j c
  simp [assemble, hprimal, hchannel, apply_ite]

theorem assemble_channel_primal [DecidableEq I]
    (pair : H →ₗ[K] H →ₗ[K] K)
    (F : J → V →ₗ[K] H) (G : I → W →ₗ[K] H)
    (cL : I → V →ₗ[K] H) (cR : J → W →ₗ[K] H)
    (primal : X →ₗ[K] W) (channel : I → H →ₗ[K] V)
    (hprimal : ∀ j x, cR j (primal x) = 0)
    (hchannel : ∀ i c k, cL k (channel i c) = if k = i then c else 0) :
    ∀ x i c, assemble pair F G cL cR (channel i c) (primal x) =
      pair c (G i (primal x)) := by
  intro x i c
  simp [assemble, hprimal, hchannel, apply_ite, ite_apply]

theorem gram_completion [DecidableEq I] [DecidableEq J]
    (pair : H →ₗ[K] H →ₗ[K] K) (K₀ : V →ₗ[K] W →ₗ[K] K)
    (F : J → V →ₗ[K] H) (G : I → W →ₗ[K] H)
    (cL : I → V →ₗ[K] H) (cR : J → W →ₗ[K] H)
    (DL : Submodule K V) (DR : Submodule K W)
    (primalL : L →ₗ[K] V) (primalR : R →ₗ[K] W)
    (channelL : I → H →ₗ[K] V) (channelR : J → H →ₗ[K] W)
    (hF : ∀ j x, x ∈ DL → F j x = 0)
    (hG : ∀ i y, y ∈ DR → G i y = 0)
    (hleft : ∀ i x, x ∈ DL → ∀ y, pair (cL i x) (G i y) = 0)
    (hright : ∀ j y, y ∈ DR → ∀ x, pair (F j x) (cR j y) = 0)
    (hpL : ∀ i x, cL i (primalL x) = 0)
    (hpR : ∀ j x, cR j (primalR x) = 0)
    (hcL : ∀ i c k, cL k (channelL i c) = if k = i then c else 0)
    (hcR : ∀ j c k, cR k (channelR j c) = if k = j then c else 0) :
    ∃ K₁ : V →ₗ[K] W →ₗ[K] K,
      (∀ x ∈ DL, ∀ y, K₁ x y = K₀ x y) ∧
      (∀ y ∈ DR, ∀ x, K₁ x y = K₀ x y) ∧
      (∀ x j c, K₁ (primalL x) (channelR j c) =
        K₀ (primalL x) (channelR j c) + pair (F j (primalL x)) c) ∧
      (∀ x i c, K₁ (channelL i c) (primalR x) =
        K₀ (channelL i c) (primalR x) + pair c (G i (primalR x))) := by
  let Δ := assemble pair F G cL cR
  have hf := assemble_frozen pair F G cL cR DL DR hF hG hleft hright
  refine ⟨K₀ + Δ, ?_, ?_, ?_, ?_⟩
  · intro x hx y
    simp only [LinearMap.add_apply, Δ, hf.1 x hx y, add_zero]
  · intro y hy x
    simp only [LinearMap.add_apply, Δ, hf.2 y hy x, add_zero]
  · intro x j c
    simp only [LinearMap.add_apply]
    rw [show Δ (primalL x) (channelR j c) = pair (F j (primalL x)) c from
      assemble_primal_channel pair F G cL cR primalL channelR hpL hcR x j c]
  · intro x i c
    simp only [LinearMap.add_apply]
    rw [show Δ (channelL i c) (primalR x) = pair c (G i (primalR x)) from
      assemble_channel_primal pair F G cL cR primalR channelL hpR hcL x i c]

end Assembly

theorem boolean_moment_scalar (c v d d₀ : ZMod 2)
    (h : c * v * v + v * d + d * v = c * v + d + d₀ * v) :
    d = d₀ * v := by
  revert c v d d₀
  decide

theorem boolean_ray_isolation {ι : Type} (o : ι) (v d : ι → ZMod 2) (c : ZMod 2)
    (hv : v o = 1)
    (hmoment : ∀ i,
      c * v i * v i + v i * d i + d i * v i =
        c * v o * v i + v o * d i + d o * v i) :
    ∀ i j, c * v i * v j + v i * d j + d i * v j = c * v i * v j := by
  have hd (i) : d i = d o * v i :=
    boolean_moment_scalar c (v i) (d i) (d o) (by simpa [hv] using hmoment i)
  intro i j
  rw [hd i, hd j]
  have htwo : (2 : ZMod 2) = 0 := by decide
  calc
    c * v i * v j + v i * (d o * v j) + d o * v i * v j =
        c * v i * v j + (v i * v j * d o) * 2 := by ring
    _ = c * v i * v j := by rw [htwo]; simp

section MixedPins

variable {P : Type} [AddCommGroup P] [Module K P]

theorem mixed_pin_strip
    (D : Submodule K (P × H)) (S N A : Submodule K P)
    (H₀ H₁ : Submodule K H)
    (hD : ∀ d ∈ D, d.1 ∈ S ∧ d.2 ∈ H₀)
    (hA : Disjoint A (N ⊔ S)) (hH : Disjoint H₀ H₁)
    (n : P) (hn : n ∈ N) (d : P × H) (hd : d ∈ D)
    (a : P) (ha : a ∈ A) (b : H) (hb : b ∈ H₁)
    (hx : (n, 0) = d + (a, 0) + (0, b)) :
    (n, 0) ∈ D := by
  have hp : n = d.1 + a := by
    simpa using congrArg Prod.fst hx
  have hc : (0 : H) = d.2 + b := by
    simpa using congrArg Prod.snd hx
  have haNS : a ∈ N ⊔ S := by
    have he : a = n - d.1 := by rw [hp]; abel
    rw [he]
    exact Submodule.sub_mem _ (Submodule.mem_sup_left hn)
      (Submodule.mem_sup_right (hD d hd).1)
  have ha0 : a = 0 := (Submodule.disjoint_def.mp hA) a ha haNS
  have hdH₁ : d.2 ∈ H₁ := by
    have he : d.2 = -b := by rw [eq_neg_iff_add_eq_zero]; exact hc.symm
    rw [he]
    exact H₁.neg_mem hb
  have hd0 : d.2 = 0 := (Submodule.disjoint_def.mp hH) d.2 (hD d hd).2 hdH₁
  have hb0 : b = 0 := by simpa [hd0] using hc.symm
  have he : (n, 0) = d := by
    rw [ha0, hb0] at hx
    change (n, 0) = d + 0 + 0 at hx
    simpa only [add_zero] using hx
  exact he.symm ▸ hd

end MixedPins

end ProtectedChannels
