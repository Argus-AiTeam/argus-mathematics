import Mathlib

open scoped BigOperators
open Module

namespace PruningAudit

variable {K : Type*} [Field K]

theorem perturbation_kernel_product
    {U V : Type*} [AddCommGroup U] [Module K U]
    [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (D : U →ₗ[K] V) (q : U →ₗ[K] K) (z : V) (y : V →ₗ[K] K)
    (x : U) (hx : D x = 0) (hy : ∀ w, y (D w) = 0)
    (hrank : finrank K (D + q.smulRight z).range ≤ finrank K D.range) :
    q x * y z = 0 := by
  by_cases hqx : q x = 0
  · simp [hqx]
  let E := D + q.smulRight z
  have hEx : E x = q x • z := by simp [E, hx]
  have hz : z ∈ E.range := by
    refine ⟨(q x)⁻¹ • x, ?_⟩
    rw [map_smul, hEx, smul_smul, inv_mul_cancel₀ hqx, one_smul]
  have hle : D.range ≤ E.range := by
    rintro _ ⟨w, rfl⟩
    have hw : E w ∈ E.range := ⟨w, rfl⟩
    convert E.range.sub_mem hw (E.range.smul_mem (q w) hz) using 1
    simp [E]
  have heq : D.range = E.range := Submodule.eq_of_le_of_finrank_le hle hrank
  have hzold : z ∈ D.range := by
    rw [heq]
    exact hz
  obtain ⟨w, hw⟩ := hzold
  rw [← hw, hy, mul_zero]

noncomputable def pairing {S : Type*} [Fintype S] (y : S → K) :
    (S → K) →ₗ[K] K where
  toFun w := ∑ s, y s * w s
  map_add' u v := by simp [mul_add, Finset.sum_add_distrib]
  map_smul' c w := by simp [Finset.mul_sum, mul_left_comm]

def Supported {S J : Type*} (T : S → J → Prop) (D : Matrix S J K) : Prop :=
  ∀ s j, ¬ T s j → D s j = 0

theorem support_maximal_kernel
    {S J : Type*} [Fintype S] [Fintype J] [DecidableEq S] [DecidableEq J]
    (T : S → J → Prop) (D : Matrix S J K) (hD : Supported T D)
    (hmax : ∀ E : Matrix S J K, Supported T E →
      finrank K (Matrix.toLin' E).range ≤ finrank K (Matrix.toLin' D).range)
    (x : J → K) (y : S → K) (hx : D.mulVec x = 0)
    (hy : D.transpose.mulVec y = 0) (s : S) (j : J) (hsj : T s j) :
    x j * y s = 0 := by
  let E := D + Matrix.single s j 1
  have hE : Supported T E := by
    intro a b hab
    have hne : ¬ (s = a ∧ j = b) := by
      rintro ⟨rfl, rfl⟩
      exact hab hsj
    simp [E, hD a b hab, hne]
  have hlin : Matrix.toLin' E =
      Matrix.toLin' D + (LinearMap.proj j).smulRight (Pi.single s (1 : K)) := by
    apply LinearMap.ext
    intro w
    funext a
    change ((D + Matrix.single s j 1).mulVec w) a =
      (D.mulVec w) a + ((w j) • Pi.single s (1 : K)) a
    simp [Matrix.add_mulVec, Matrix.single_mulVec, Function.update_apply,
      Pi.single_apply, eq_comm]
  have hpair : ∀ w, pairing y ((Matrix.toLin' D) w) = 0 := by
    intro w
    change dotProduct y (D.mulVec w) = 0
    rw [Matrix.dotProduct_mulVec, ← Matrix.mulVec_transpose, hy]
    simp
  have hrank := hmax E hE
  rw [hlin] at hrank
  have h := perturbation_kernel_product (Matrix.toLin' D) (LinearMap.proj j)
    (Pi.single s (1 : K)) (pairing y) x (by simpa using hx) hpair hrank
  simpa [pairing, Pi.single_apply, mul_ite] using h

section Restriction

variable {P I S J : Type*} [Fintype S] [Fintype J]
    [DecidableEq S] [DecidableEq J]
variable (first : P → I → Prop) (second : S → J → Prop)
    (R : P → J → Prop) (C : I → S → Prop)

def H (p : P) (s : S) : Prop :=
  ∃ i j, R p j ∧ C i s ∧ first p i ∧ second s j

def Z (i : I) (j : J) : Prop :=
  ∃ p s, R p j ∧ C i s ∧ first p i ∧ second s j

noncomputable def localMatrix (b : S → J → K) (p : P) (i : I) : Matrix S J K := by
  classical
  exact fun s j => if C i s ∧ R p j then b s j else 0

theorem conflict_kernel
    (b : S → J → K) (hb : ∀ s j, ¬ second s j → b s j = 0)
    (u : P → J → K) (v : I → S → K)
    (hu : ∀ p j, ¬ R p j → u p j = 0)
    (hv : ∀ i s, ¬ C i s → v i s = 0)
    (hB : ∀ p s, H first second R C p s → ∑ j, b s j * u p j = 0)
    (hNt : ∀ i j, Z first second R C i j → ∑ s, b s j * v i s = 0)
    (hmax : ∀ p i, first p i → ∀ E : Matrix S J K,
      Supported (fun s j => C i s ∧ R p j ∧ second s j) E →
      finrank K (Matrix.toLin' E).range ≤
        finrank K (Matrix.toLin' (localMatrix R C b p i)).range)
    (p : P) (i : I) (s : S) (j : J)
    (hR : R p j) (hC : C i s) (hfirst : first p i) (hsecond : second s j) :
    u p j * v i s = 0 := by
  classical
  let D := localMatrix R C b p i
  have hsupport : Supported (fun s j => C i s ∧ R p j ∧ second s j) D := by
    intro a d had
    by_cases hc : C i a
    · by_cases hr : R p d
      · have hs : ¬ second a d := fun hs => had ⟨hc, hr, hs⟩
        simp [D, localMatrix, hc, hr, hb a d hs]
      · simp [D, localMatrix, hr]
    · simp [D, localMatrix, hc]
  have hright : D.mulVec (u p) = 0 := by
    ext a
    change (∑ d, D a d * u p d) = 0
    by_cases hc : C i a
    · by_cases hh : H first second R C p a
      · convert hB p a hh using 1
        apply Finset.sum_congr rfl
        intro d _
        by_cases hr : R p d
        · simp [D, localMatrix, hc, hr]
        · simp [D, localMatrix, hc, hr, hu p d hr]
      · apply Finset.sum_eq_zero
        intro d _
        by_cases hr : R p d
        · have hs : ¬ second a d := fun hs => hh ⟨i, d, hr, hc, hfirst, hs⟩
          simp [D, localMatrix, hc, hr, hb a d hs]
        · simp [D, localMatrix, hr]
    · simp [D, localMatrix, hc]
  have hleft : D.transpose.mulVec (v i) = 0 := by
    ext d
    change (∑ a, D a d * v i a) = 0
    by_cases hr : R p d
    · by_cases hz : Z first second R C i d
      · convert hNt i d hz using 1
        apply Finset.sum_congr rfl
        intro a _
        by_cases hc : C i a
        · simp [D, localMatrix, hc, hr]
        · simp [D, localMatrix, hc, hr, hv i a hc]
      · apply Finset.sum_eq_zero
        intro a _
        by_cases hc : C i a
        · have hs : ¬ second a d := fun hs => hz ⟨p, a, hr, hc, hfirst, hs⟩
          simp [D, localMatrix, hc, hr, hb a d hs]
        · simp [D, localMatrix, hc]
    · simp [D, localMatrix, hr]
  exact support_maximal_kernel _ D hsupport (hmax p i hfirst)
    (u p) (v i) hright hleft s j ⟨hC, hR, hsecond⟩

end Restriction

section Lifts

variable {R C H Z M : Type*} [Fintype R] [Fintype C] [Fintype H]
    [Fintype Z] [Fintype M] [DecidableEq M]
variable (B : (R → K) →ₗ[K] (H → K)) (Nt : (C → K) →ₗ[K] (Z → K))
    (r : M → R) (c : M → C) (u : M → R → K) (v : M → C → K)

omit [Fintype R] [Fintype C] [Fintype H] [Fintype Z] in
theorem lift_images_independent
    (hcontrol : ∀ x y, B x = 0 → Nt y = 0 → ∀ m, x (r m) * y (c m) = 0)
    (hdual : ∀ m, Nt (v m) = 0) (hv : ∀ m, v m (c m) = 1)
    (hu : ∀ m n, u m (r n) = if m = n then 1 else 0) :
    LinearIndependent K (fun m => B (u m)) := by
  have hzero : ∀ x, B x = 0 → ∀ m, x (r m) = 0 := by
    intro x hx m
    simpa [hv m] using hcontrol x (v m) hx (hdual m) m
  apply Fintype.linearIndependent_iff.mpr
  intro theta htheta m
  have hsum : B (∑ q, theta q • u q) = 0 := by
    simpa only [map_sum, map_smul] using htheta
  have hz := hzero _ hsum m
  simpa [Finset.sum_apply, hu, mul_ite] using hz

omit [Fintype R] [Fintype C] [Fintype Z] in
theorem kernel_lifts_dimension
    (L : (R → K) →ₗ[K] (Z → K)) (N : (Z → K) →ₗ[K] (C → K))
    (A : (H → K) →ₗ[K] (C → K)) (hcomm : A.comp B = N.comp L)
    (hcontrol : ∀ x y, B x = 0 → Nt y = 0 → ∀ m, x (r m) * y (c m) = 0)
    (hdual : ∀ m, Nt (v m) = 0) (hv : ∀ m, v m (c m) = 1)
    (hu : ∀ m n, u m (r n) = if m = n then 1 else 0)
    (hLu : ∀ m, L (u m) = 0) :
    Fintype.card M ≤ finrank K A.ker := by
  let w : M → A.ker := fun m => ⟨B (u m), by
    change (A.comp B) (u m) = 0
    rw [hcomm]
    simp [hLu m]⟩
  have hli : LinearIndependent K w := by
    apply LinearIndependent.of_comp A.ker.subtype
    simpa [w, Function.comp_def] using
      lift_images_independent B Nt r c u v hcontrol hdual hv hu
  exact hli.fintype_card_le_finrank

end Lifts

theorem composition_rank_bound
    {U V W : Type*} [AddCommGroup U] [Module K U]
    [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    [AddCommGroup W] [Module K W]
    (L : U →ₗ[K] V) (N : V →ₗ[K] W) :
    finrank K L.range + finrank K N.range ≤
      finrank K V + finrank K (N.comp L).range := by
  let f := N.domRestrict L.range
  let inclusion : f.ker →ₗ[K] N.ker :=
    { toFun := fun x => ⟨x.val.val, x.property⟩
      map_add' := by intros; rfl
      map_smul' := by intros; rfl }
  have hinj : Function.Injective inclusion := by
    intro x y h
    apply Subtype.ext
    apply Subtype.ext
    exact congrArg (fun z : N.ker => (z : V)) h
  have hker := LinearMap.finrank_le_finrank_of_injective hinj
  have hrange : f.range = (N.comp L).range := by
    rw [LinearMap.range_domRestrict, LinearMap.range_comp]
  have hf := f.finrank_range_add_finrank_ker
  rw [hrange] at hf
  have hn := N.finrank_range_add_finrank_ker
  lia

theorem augmented_rank_bound
    {R C H Z M : Type*} [Fintype R] [Fintype C] [Fintype H]
    [Fintype Z] [Fintype M] [DecidableEq M]
    (L : (R → K) →ₗ[K] (Z → K)) (N : (Z → K) →ₗ[K] (C → K))
    (B : (R → K) →ₗ[K] (H → K)) (A : (H → K) →ₗ[K] (C → K))
    (Nt : (C → K) →ₗ[K] (Z → K)) (hcomm : A.comp B = N.comp L)
    (r : M → R) (c : M → C) (u : M → R → K) (v : M → C → K)
    (hcontrol : ∀ x y, B x = 0 → Nt y = 0 → ∀ m, x (r m) * y (c m) = 0)
    (hdual : ∀ m, Nt (v m) = 0) (hv : ∀ m, v m (c m) = 1)
    (hu : ∀ m n, u m (r n) = if m = n then 1 else 0)
    (hLu : ∀ m, L (u m) = 0) :
    Fintype.card M + finrank K L.range + finrank K N.range ≤
      Fintype.card H + Fintype.card Z := by
  have hk := kernel_lifts_dimension B Nt r c u v L N A hcomm hcontrol hdual hv hu hLu
  have hs := composition_rank_bound L N
  have hle : (N.comp L).range ≤ A.range := by
    rintro _ ⟨x, rfl⟩
    exact ⟨B x, congrArg (fun f => f x) hcomm⟩
  have ha := Submodule.finrank_mono hle
  have hn := A.finrank_range_add_finrank_ker
  have hH : finrank K (H → K) = Fintype.card H := by simp
  have hZ : finrank K (Z → K) = Fintype.card Z := by simp
  lia

end PruningAudit

#print axioms PruningAudit.conflict_kernel
#print axioms PruningAudit.lift_images_independent
#print axioms PruningAudit.augmented_rank_bound
