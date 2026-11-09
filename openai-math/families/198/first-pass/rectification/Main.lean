import Mathlib

set_option autoImplicit false

namespace ThreeLayer

section Split

variable {K E T : Type*} [Field K]
  [AddCommGroup E] [Module K E] [AddCommGroup T] [Module K T]

theorem relation_split (j : T →ₗ[K] E) (hj : Function.Injective j) :
    ∃ l : E →ₗ[K] T, l.comp j = LinearMap.id :=
  j.exists_leftInverse_of_injective (LinearMap.ker_eq_bot.mpr hj)

end Split

section Complement

variable {K E T : Type*} [Ring K]
  [AddCommGroup E] [Module K E] [AddCommGroup T] [Module K T]

variable (j : T →ₗ[K] E) (l : E →ₗ[K] T)
  (hl : l.comp j = LinearMap.id)

def quotientProjection : E →ₗ[K] LinearMap.ker l :=
  (LinearMap.id - j.comp l).codRestrict (LinearMap.ker l) (by
    intro x
    change l (x - j (l x)) = 0
    have h : l (j (l x)) = l x := congrArg (fun f : T →ₗ[K] T => f (l x)) hl
    simpa using sub_eq_zero.mpr h.symm)

theorem quotient_projection_inclusion (w : LinearMap.ker l) :
    quotientProjection j l hl w = w := by
  apply Subtype.ext
  simp [quotientProjection, w.property]

theorem quotient_projection_relation (t : T) :
    quotientProjection j l hl (j t) = 0 := by
  apply Subtype.ext
  have h : l (j t) = t := congrArg (fun f : T →ₗ[K] T => f t) hl
  simp [quotientProjection, h]

theorem relation_decomposition (x : E) :
    (quotientProjection j l hl x : E) + j (l x) = x := by
  simp [quotientProjection]

theorem projection_surjective : Function.Surjective (quotientProjection j l hl) := by
  intro w
  exact ⟨w, quotient_projection_inclusion j l hl w⟩

theorem projection_kernel :
    LinearMap.ker (quotientProjection j l hl) = LinearMap.range j := by
  ext x
  constructor
  · intro hx
    change quotientProjection j l hl x = 0 at hx
    have he := relation_decomposition j l hl x
    rw [hx] at he
    exact ⟨l x, by simpa using he⟩
  · rintro ⟨t, rfl⟩
    exact quotient_projection_relation j l hl t

end Complement

section ScalarExtension

variable {K R M N ι κ τ : Type*} [Field K] [Ring R] [Algebra K R]
  [AddCommGroup M] [Module K M] [Module R M] [IsScalarTower K R M]
  [SMulCommClass K R M]
  [AddCommGroup N] [Module K N] [Module R N] [IsScalarTower K R N]
  [SMulCommClass K R N]
  [Fintype ι] [Fintype κ] [Fintype τ]
  [DecidableEq ι] [DecidableEq κ] [DecidableEq τ]

def extend (f : (ι → K) →ₗ[K] (κ → K)) : (ι → M) →ₗ[R] (κ → M) where
  toFun x k := ∑ i, f (Pi.single i 1) k • x i
  map_add' x y := by
    ext k
    simp [smul_add, Finset.sum_add_distrib]
  map_smul' r x := by
    funext k
    change (∑ i, f (Pi.single i 1) k • (r • x i)) =
      r • ∑ i, f (Pi.single i 1) k • x i
    rw [Finset.smul_sum]
    exact Finset.sum_congr rfl fun i _ => smul_comm _ _ _

theorem extend_single (f : (ι → K) →ₗ[K] (κ → K)) (i : ι) (x : M) (k : κ) :
    extend (R := R) f (Pi.single i x) k = f (Pi.single i 1) k • x := by
  simp [extend, Pi.single_apply]

theorem expand_coefficients (f : (ι → K) →ₗ[K] (κ → K)) (x : ι → K) (k : κ) :
    f x k = ∑ i, x i * f (Pi.single i 1) k := by
  have hx : x = ∑ i, x i • Pi.single i 1 := by
    ext j
    simp [Pi.single_apply]
  conv_lhs => rw [hx, map_sum]
  simp

theorem extend_id :
    extend (R := R) (M := M) (LinearMap.id : (ι → K) →ₗ[K] (ι → K)) =
      LinearMap.id := by
  apply LinearMap.ext
  intro x
  funext i
  simp [extend, Pi.single_apply]

theorem extend_comp (f : (ι → K) →ₗ[K] (κ → K))
    (g : (κ → K) →ₗ[K] (τ → K)) :
    extend (R := R) (M := M) (g.comp f) = (extend g).comp (extend f) := by
  apply LinearMap.ext
  intro x
  funext t
  change (∑ i, g (f (Pi.single i 1)) t • x i) =
    ∑ k, g (Pi.single k 1) t • (∑ i, f (Pi.single i 1) k • x i)
  have hg (i : ι) : g (f (Pi.single i 1)) t =
      ∑ k, f (Pi.single i 1) k * g (Pi.single k 1) t :=
    expand_coefficients g _ _
  simp_rw [hg, Finset.sum_smul, Finset.smul_sum, smul_smul]
  rw [Finset.sum_comm]
  congr 1
  ext k
  congr 1
  ext i
  rw [mul_comm]

def pointwise (f : M →ₗ[R] N) : (ι → M) →ₗ[R] (ι → N) where
  toFun x i := f (x i)
  map_add' x y := by ext i; simp
  map_smul' r x := by ext i; simp

theorem pointwise_single (d : M →ₗ[R] N) (i : ι) (x : M) :
    pointwise d (Pi.single i x) = Pi.single i (d x) := by
  funext k
  by_cases hk : k = i <;> simp [pointwise, Pi.single_apply, hk]

theorem extend_natural (f : (ι → K) →ₗ[K] (κ → K)) (d : M →ₗ[R] N)
    (x : ι → M) :
    pointwise d (extend (R := R) f x) =
      extend (R := R) f (pointwise d x) := by
  ext k
  simp [pointwise, extend, map_sum, LinearMap.map_smul_of_tower]

def fold (f : ι → M →ₗ[R] N) : (ι → M) →ₗ[R] N where
  toFun x := ∑ i, f i (x i)
  map_add' x y := by simp [Finset.sum_add_distrib]
  map_smul' r x := by simp [Finset.smul_sum]

theorem fold_single (f : ι → M →ₗ[R] N) (i : ι) (x : M) :
    fold f (Pi.single i x) = f i x := by
  simp [fold, Pi.single_apply, apply_ite]

theorem pi_linear_ext {P : Type*} [AddCommGroup P] [Module R P]
    (f g : (ι → M) →ₗ[R] P)
    (h : ∀ i x, f (Pi.single i x) = g (Pi.single i x)) : f = g := by
  apply LinearMap.ext
  intro x
  have hx : x = ∑ i, Pi.single i (x i) := by ext j; simp
  rw [hx, map_sum, map_sum]
  exact Finset.sum_congr rfl fun i _ => h i (x i)

theorem extend_split (j : (ι → K) →ₗ[K] (κ → K))
    (l : (κ → K) →ₗ[K] (ι → K)) (h : l.comp j = LinearMap.id) :
    (extend (R := R) (M := M) l).comp (extend j) = LinearMap.id := by
  rw [← extend_comp, h, extend_id]

end ScalarExtension

section Universal

variable {R M V W U T : Type*} [Ring R]
  [AddCommGroup M] [Module R M]
  [AddCommGroup V] [Module R V]
  [AddCommGroup W] [Module R W]
  [AddCommGroup U] [Module R U]
  [AddCommGroup T] [Module R T]

structure System where
  dM : M →ₗ[R] M
  dV : V →ₗ[R] V
  dW : W →ₗ[R] W
  dU : U →ₗ[R] U
  dT : T →ₗ[R] T
  A : U →ₗ[R] V
  G : V →ₗ[R] M
  J : T →ₗ[R] U
  π : U →ₗ[R] W
  s : W →ₗ[R] U
  l : U →ₗ[R] T
  H : T →ₗ[R] M
  sqM : ∀ x, dM (dM x) = 0
  sqV : ∀ x, dV (dV x) = 0
  sqW : ∀ x, dW (dW x) = 0
  sqU : ∀ x, dU (dU x) = 0
  sqT : ∀ x, dT (dT x) = 0
  cA : ∀ x, dV (A x) = A (dU x)
  cG : ∀ x, dM (G x) = G (dV x)
  cJ : ∀ x, dU (J x) = J (dT x)
  cπ : ∀ x, dW (π x) = π (dU x)
  cs : ∀ x, dU (s x) = s (dW x)
  cl : ∀ x, dT (l x) = l (dU x)
  πs : ∀ x, π (s x) = x
  πJ : ∀ x, π (J x) = 0
  lJ : ∀ x, l (J x) = x
  ls : ∀ x, l (s x) = 0
  split : ∀ x, s (π x) + J (l x) = x
  relation : ∀ x, dM (H x) + H (dT x) = G (A (J x))

abbrev Total := M × V × W × U × V × T

variable (S : System (R := R) (M := M) (V := V) (W := W) (U := U) (T := T))

def delta (x : Total (M := M) (V := V) (W := W) (U := U) (T := T)) :
    Total (M := M) (V := V) (W := W) (U := U) (T := T) :=
  (S.dM x.1 - S.G x.2.2.2.2.1 + S.H x.2.2.2.2.2,
   S.dV x.2.1 - S.A x.2.2.2.1 + x.2.2.2.2.1,
   S.dW x.2.2.1 + S.π x.2.2.2.1,
   -S.dU x.2.2.2.1 + S.J x.2.2.2.2.2,
   -S.dV x.2.2.2.2.1 + S.A (S.J x.2.2.2.2.2),
   S.dT x.2.2.2.2.2)

def incl (y : M) : Total (M := M) (V := V) (W := W) (U := U) (T := T) :=
  (y, 0, 0, 0, 0, 0)

def retract (x : Total (M := M) (V := V) (W := W) (U := U) (T := T)) : M :=
  x.1 + S.G x.2.1 + S.G (S.A (S.s x.2.2.1)) - S.H (S.l x.2.2.2.1)

def contract (x : Total (M := M) (V := V) (W := W) (U := U) (T := T)) :
    Total (M := M) (V := V) (W := W) (U := U) (T := T) :=
  (0, 0, 0, S.s x.2.2.1, x.2.1 + S.A (S.s x.2.2.1), S.l x.2.2.2.1)

theorem differential_square (x : Total (M := M) (V := V) (W := W) (U := U)
    (T := T)) : delta S (delta S x) = 0 := by
  rcases x with ⟨y, v, w, u, z, t⟩
  simp only [delta, Prod.mk.injEq, Prod.zero_eq_mk, map_add, map_sub, map_neg,
    S.sqM, S.sqV, S.sqW, S.sqU, S.sqT, S.cG, S.cA, S.cπ, S.cJ, S.πJ,
    map_zero]
  rw [← S.relation t]
  constructor
  · abel
  repeat' constructor
  all_goals abel

theorem differential_add (x y : Total (M := M) (V := V) (W := W) (U := U)
    (T := T)) : delta S (x + y) = delta S x + delta S y := by
  simp only [delta, Prod.add_def, map_add, Prod.mk.injEq]
  repeat' constructor
  all_goals abel

theorem differential_smul (r : R) (x : Total (M := M) (V := V) (W := W)
    (U := U) (T := T)) : delta S (r • x) = r • delta S x := by
  simp [delta, smul_add, smul_sub]

theorem inclusion_chain (y : M) :
    delta S (incl (V := V) (W := W) (U := U) (T := T) y) =
      incl (V := V) (W := W) (U := U) (T := T) (S.dM y) := by
  simp [delta, incl]

theorem retraction_chain (x : Total (M := M) (V := V) (W := W) (U := U)
    (T := T)) : retract S (delta S x) = S.dM (retract S x) := by
  rcases x with ⟨y, v, w, u, z, t⟩
  simp only [retract, delta, map_add, map_sub, map_neg, S.cG, S.cA, S.cs,
    S.lJ]
  have hsplit : S.G (S.A u) =
      S.G (S.A (S.s (S.π u))) + S.G (S.A (S.J (S.l u))) := by
    rw [← map_add, ← map_add, S.split u]
  rw [hsplit, ← S.relation (S.l u)]
  rw [S.cl]
  abel

theorem retraction_inclusion (y : M) :
    retract S (incl (V := V) (W := W) (U := U) (T := T) y) = y := by
  simp [retract, incl]

theorem contraction_identity (x : Total (M := M) (V := V) (W := W) (U := U)
    (T := T)) :
    delta S (contract S x) + contract S (delta S x) =
      x - incl (V := V) (W := W) (U := U) (T := T) (retract S x) := by
  rcases x with ⟨y, v, w, u, z, t⟩
  simp only [delta, contract, retract, incl, Prod.add_def, Prod.sub_def,
    Prod.mk.injEq, map_add, map_sub, map_neg, map_zero, S.cs, S.cA, S.πs,
    S.lJ, S.cl]
  have hsplit : S.A (S.s (S.π u)) + S.A (S.J (S.l u)) = S.A u := by
    rw [← map_add, S.split u]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · abel
  · abel
  · abel
  · have := S.split u
    calc
      _ = S.s (S.π u) + S.J (S.l u) := by abel
      _ = u - 0 := by simpa using this
  ·
    rw [← hsplit]
    abel
  · abel

theorem retract_add (x y : Total (M := M) (V := V) (W := W) (U := U)
    (T := T)) : retract S (x + y) = retract S x + retract S y := by
  simp only [retract, Prod.add_def, map_add]
  abel

theorem retract_smul (r : R) (x : Total (M := M) (V := V) (W := W)
    (U := U) (T := T)) : retract S (r • x) = r • retract S x := by
  simp [retract, smul_add, smul_sub]

theorem contract_add (x y : Total (M := M) (V := V) (W := W) (U := U)
    (T := T)) : contract S (x + y) = contract S x + contract S y := by
  simp only [contract, Prod.add_def, map_add, Prod.mk.injEq]
  repeat' constructor
  all_goals abel

theorem contract_smul (r : R) (x : Total (M := M) (V := V) (W := W)
    (U := U) (T := T)) : contract S (r • x) = r • contract S x := by
  simp [contract, smul_add]

theorem contraction_square (x : Total (M := M) (V := V) (W := W) (U := U)
    (T := T)) : contract S (contract S x) = 0 := by
  simp [contract, S.ls]

theorem retraction_contraction (x : Total (M := M) (V := V) (W := W) (U := U)
    (T := T)) : retract S (contract S x) = 0 := by
  simp [retract, contract, S.ls]

theorem contraction_inclusion (y : M) :
    contract S (incl (V := V) (W := W) (U := U) (T := T) y) = 0 := by
  simp [contract, incl]

def deltaMap :
    Total (M := M) (V := V) (W := W) (U := U) (T := T) →ₗ[R]
      Total (M := M) (V := V) (W := W) (U := U) (T := T) where
  toFun := delta S
  map_add' := differential_add S
  map_smul' := differential_smul S

def inclMap : M →ₗ[R] Total (M := M) (V := V) (W := W) (U := U) (T := T) where
  toFun := incl
  map_add' x y := by simp [incl]
  map_smul' r x := by simp [incl]

def retractMap :
    Total (M := M) (V := V) (W := W) (U := U) (T := T) →ₗ[R] M where
  toFun := retract S
  map_add' := retract_add S
  map_smul' := retract_smul S

def contractMap :
    Total (M := M) (V := V) (W := W) (U := U) (T := T) →ₗ[R]
      Total (M := M) (V := V) (W := W) (U := U) (T := T) where
  toFun := contract S
  map_add' := contract_add S
  map_smul' := contract_smul S

end Universal

section Build

variable {R M V U T : Type*} [Ring R]
  [AddCommGroup M] [Module R M] [AddCommGroup V] [Module R V]
  [AddCommGroup U] [Module R U] [AddCommGroup T] [Module R T]
  (dM : M →ₗ[R] M) (dV : V →ₗ[R] V)
  (dU : U →ₗ[R] U) (dT : T →ₗ[R] T)
  (A : U →ₗ[R] V) (G : V →ₗ[R] M)
  (J : T →ₗ[R] U) (l : U →ₗ[R] T) (H : T →ₗ[R] M)
  (hl : l.comp J = LinearMap.id)
  (cl : ∀ x, l (dU x) = dT (l x))

def kernelDifferential : LinearMap.ker l →ₗ[R] LinearMap.ker l :=
  (dU.comp (LinearMap.ker l).subtype).codRestrict (LinearMap.ker l) (by
    intro x
    change l (dU x) = 0
    rw [cl, x.property, map_zero])

def systemOfSplit
    (sqM : ∀ x, dM (dM x) = 0) (sqV : ∀ x, dV (dV x) = 0)
    (sqU : ∀ x, dU (dU x) = 0) (sqT : ∀ x, dT (dT x) = 0)
    (cA : ∀ x, dV (A x) = A (dU x))
    (cG : ∀ x, dM (G x) = G (dV x))
    (cJ : ∀ x, dU (J x) = J (dT x))
    (rel : ∀ x, dM (H x) + H (dT x) = G (A (J x))) :
    System (R := R) (M := M) (V := V) (W := LinearMap.ker l) (U := U) (T := T) where
  dM := dM
  dV := dV
  dW := kernelDifferential dU dT l cl
  dU := dU
  dT := dT
  A := A
  G := G
  J := J
  π := quotientProjection J l hl
  s := (LinearMap.ker l).subtype
  l := l
  H := H
  sqM := sqM
  sqV := sqV
  sqW x := by apply Subtype.ext; exact sqU x
  sqU := sqU
  sqT := sqT
  cA := cA
  cG := cG
  cJ := cJ
  cπ x := by
    apply Subtype.ext
    change dU (x - J (l x)) = dU x - J (l (dU x))
    rw [map_sub, cJ, cl]
  cs x := rfl
  cl x := (cl x).symm
  πs := quotient_projection_inclusion J l hl
  πJ := quotient_projection_relation J l hl
  lJ x := congrArg (fun f : T →ₗ[R] T => f x) hl
  ls x := x.property
  split := relation_decomposition J l hl
  relation := rel

include J hl in
theorem complement_projective [Module.Projective R U] :
    Module.Projective R (LinearMap.ker l) :=
  Module.Projective.of_split (LinearMap.ker l).subtype
    (quotientProjection J l hl) (by
      apply LinearMap.ext
      exact quotient_projection_inclusion J l hl)

end Build

section Assembly

variable {K R M0 M1 M2 AI BI RI : Type*} [Field K] [Ring R] [Algebra K R]
  [AddCommGroup M0] [Module K M0] [Module R M0] [IsScalarTower K R M0]
  [SMulCommClass K R M0]
  [AddCommGroup M1] [Module K M1] [Module R M1] [IsScalarTower K R M1]
  [SMulCommClass K R M1]
  [AddCommGroup M2] [Module K M2] [Module R M2] [IsScalarTower K R M2]
  [SMulCommClass K R M2]
  [Fintype AI] [Fintype BI] [Fintype RI]
  [DecidableEq AI] [DecidableEq BI] [DecidableEq RI]

structure Diagram where
  d0 : M0 →ₗ[R] M0
  d1 : M1 →ₗ[R] M1
  d2 : M2 →ₗ[R] M2
  f : AI → M0 →ₗ[R] M1
  g : BI → M1 →ₗ[R] M2
  h : RI → M0 →ₗ[R] M2
  j : (RI → K) →ₗ[K] ((BI × AI) → K)
  independent : Function.Injective j
  sq0 : ∀ x, d0 (d0 x) = 0
  sq1 : ∀ x, d1 (d1 x) = 0
  sq2 : ∀ x, d2 (d2 x) = 0
  cf : ∀ a x, d1 (f a x) = f a (d0 x)
  cg : ∀ b x, d2 (g b x) = g b (d1 x)
  relation : ∀ r x, d2 (h r x) + h r (d0 x) =
    ∑ b, ∑ a, j (Pi.single r 1) (b, a) • g b (f a x)

variable (D : Diagram (K := K) (R := R) (M0 := M0) (M1 := M1) (M2 := M2)
  (AI := AI) (BI := BI) (RI := RI))

noncomputable def relationRetraction : ((BI × AI) → K) →ₗ[K] (RI → K) :=
  Classical.choose (relation_split D.j D.independent)

theorem relationRetraction_split :
    (relationRetraction D).comp D.j = LinearMap.id :=
  Classical.choose_spec (relation_split D.j D.independent)

def relationInclusion : (RI → M0) →ₗ[R] ((BI × AI) → M0) :=
  extend D.j

noncomputable def relationRetractionOnModules :
    ((BI × AI) → M0) →ₗ[R] (RI → M0) :=
  extend (relationRetraction D)

theorem module_relation_split :
    (relationRetractionOnModules D).comp (relationInclusion D) = LinearMap.id :=
  extend_split D.j (relationRetraction D) (relationRetraction_split D)

def firstFold : (AI → M0) →ₗ[R] M1 := fold D.f
def secondFold : (BI → M1) →ₗ[R] M2 := fold D.g
def relationHomotopy : (RI → M0) →ₗ[R] M2 := fold D.h

def firstFoldInPaths : ((BI × AI) → M0) →ₗ[R] (BI → M1) where
  toFun x b := ∑ a, D.f a (x (b, a))
  map_add' x y := by ext b; simp [Finset.sum_add_distrib]
  map_smul' r x := by ext b; simp [Finset.smul_sum]

theorem folded_relation (x : RI → M0) :
    D.d2 (relationHomotopy D x) +
      relationHomotopy D (pointwise D.d0 x) =
    secondFold D (firstFoldInPaths D (relationInclusion D x)) := by
  let lhs : (RI → M0) →ₗ[R] M2 :=
    D.d2.comp (relationHomotopy D) + (relationHomotopy D).comp (pointwise D.d0)
  let rhs : (RI → M0) →ₗ[R] M2 :=
    (secondFold D).comp ((firstFoldInPaths D).comp (relationInclusion D))
  have hh : lhs = rhs := by
    apply pi_linear_ext
    intro r y
    change D.d2 (fold D.h (Pi.single r y)) +
      fold D.h (pointwise D.d0 (Pi.single r y)) =
      secondFold D (firstFoldInPaths D (relationInclusion D (Pi.single r y)))
    rw [fold_single, pointwise_single, fold_single]
    simpa [secondFold, firstFoldInPaths, relationInclusion, fold, extend_single,
      map_sum, LinearMap.map_smul_of_tower] using D.relation r y
  exact congrArg (fun f : (RI → M0) →ₗ[R] M2 => f x) hh

noncomputable def assembledSystem :
    System (R := R) (M := M2) (V := BI → M1)
      (W := LinearMap.ker (relationRetractionOnModules D))
      (U := (BI × AI) → M0) (T := RI → M0) :=
  systemOfSplit D.d2 (pointwise D.d1) (pointwise D.d0) (pointwise D.d0)
    (firstFoldInPaths D) (secondFold D)
    (relationInclusion D) (relationRetractionOnModules D) (relationHomotopy D)
    (module_relation_split D)
    (fun x => (extend_natural (relationRetraction D) D.d0 x).symm)
    D.sq2
    (by intro x; funext b; exact D.sq1 (x b))
    (by intro x; funext p; exact D.sq0 (x p))
    (by intro x; funext r; exact D.sq0 (x r))
    (by intro x; funext b; simp [pointwise, firstFoldInPaths, map_sum, D.cf])
    (by intro x; simp [secondFold, fold, pointwise, map_sum, D.cg])
    (by intro x; exact extend_natural D.j D.d0 x)
    (folded_relation D)

theorem first_fold_chain (x : AI → M0) :
    D.d1 (firstFold D x) = firstFold D (pointwise D.d0 x) := by
  simp [firstFold, fold, pointwise, map_sum, D.cf]

end Assembly

section FirstVertex

variable {R D X : Type*} [Ring R]
  [AddCommGroup D] [Module R D] [AddCommGroup X] [Module R X]

abbrev First := D × X × X

variable (d : D →ₗ[R] D) (dx : X →ₗ[R] X) (F : X →ₗ[R] D)

def delta1 (x : First (D := D) (X := X)) : First (D := D) (X := X) :=
  (d x.1 - F x.2.2, dx x.2.1 + x.2.2, -dx x.2.2)

def include1 (y : D) : First (D := D) (X := X) := (y, 0, 0)
def retract1 (x : First (D := D) (X := X)) : D := x.1 + F x.2.1
def contract1 (x : First (D := D) (X := X)) : First (D := D) (X := X) :=
  (0, 0, x.2.1)

theorem first_square (hd : ∀ y, d (d y) = 0) (hx : ∀ y, dx (dx y) = 0)
    (hf : ∀ y, d (F y) = F (dx y)) (x : First (D := D) (X := X)) :
    delta1 d dx F (delta1 d dx F x) = 0 := by
  simp [delta1, hd, hx, hf]

theorem first_retract_chain (hf : ∀ y, d (F y) = F (dx y))
    (x : First (D := D) (X := X)) :
    retract1 F (delta1 d dx F x) = d (retract1 F x) := by
  simp [retract1, delta1, hf]

theorem first_retract_include (y : D) :
    retract1 F (include1 (X := X) y) = y := by simp [retract1, include1]

theorem first_contract (x : First (D := D) (X := X)) :
    delta1 d dx F (contract1 x) + contract1 (delta1 d dx F x) =
      x - include1 (X := X) (retract1 F x) := by
  simp only [delta1, contract1, retract1, include1, map_zero, Prod.add_def,
    Prod.sub_def, Prod.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> abel

theorem first_include_chain (y : D) :
    delta1 d dx F (include1 (X := X) y) = include1 (X := X) (d y) := by
  simp [delta1, include1]

theorem first_add (x y : First (D := D) (X := X)) :
    delta1 d dx F (x + y) = delta1 d dx F x + delta1 d dx F y := by
  simp only [delta1, Prod.add_def, map_add, Prod.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> abel

theorem first_smul (r : R) (x : First (D := D) (X := X)) :
    delta1 d dx F (r • x) = r • delta1 d dx F x := by
  simp [delta1, smul_sub, smul_add]

def delta1Map : First (D := D) (X := X) →ₗ[R] First (D := D) (X := X) where
  toFun := delta1 d dx F
  map_add' := first_add d dx F
  map_smul' := first_smul d dx F

def include1Map : D →ₗ[R] First (D := D) (X := X) where
  toFun := include1
  map_add' x y := by simp [include1]
  map_smul' r x := by simp [include1]

def retract1Map : First (D := D) (X := X) →ₗ[R] D where
  toFun := retract1 F
  map_add' x y := by simp [retract1]; abel
  map_smul' r x := by simp [retract1, smul_add]

def contract1Map : First (D := D) (X := X) →ₗ[R] First (D := D) (X := X) where
  toFun := contract1
  map_add' x y := by simp [contract1]
  map_smul' r x := by simp [contract1]

end FirstVertex

section Arrows

variable {R D0 D1 X M V W U T : Type*} [Ring R]
  [AddCommGroup D0] [Module R D0]
  [AddCommGroup D1] [Module R D1]
  [AddCommGroup X] [Module R X]
  [AddCommGroup M] [Module R M]
  [AddCommGroup V] [Module R V]
  [AddCommGroup W] [Module R W]
  [AddCommGroup U] [Module R U]
  [AddCommGroup T] [Module R T]

variable (S : System (R := R) (M := M) (V := V) (W := W) (U := U) (T := T))
  (d0 : D0 →ₗ[R] D0) (d1 : D1 →ₗ[R] D1) (dx : X →ₗ[R] X)
  (F : X →ₗ[R] D1) (I : D0 →ₗ[R] X)
  (E : D1 →ₗ[R] V) (K : X →ₗ[R] U)

def actA (y : D0) : First (D := D1) (X := X) := (0, I y, 0)
def homA (y : D0) : First (D := D1) (X := X) := (0, 0, I y)

theorem arrowA_chain (hi : ∀ y, dx (I y) = I (d0 y)) (y : D0) :
    delta1 d1 dx F (actA (D1 := D1) I y) =
      actA (D1 := D1) I (d0 y) := by
  simp [delta1, actA, hi]

theorem arrowA_homotopy (hi : ∀ y, dx (I y) = I (d0 y)) (y : D0) :
    delta1 d1 dx F (homA (D1 := D1) I y) + homA (D1 := D1) I (d0 y) =
      actA (D1 := D1) I y - include1 (X := X) (F (I y)) := by
  simp [delta1, homA, actA, include1, hi, Prod.sub_def, Prod.add_def]

def actB (x : First (D := D1) (X := X)) :
    Total (M := M) (V := V) (W := W) (U := U) (T := T) :=
  (0, E x.1, S.π (K x.2.1), K x.2.2, 0, 0)

def homB (y : D1) :
    Total (M := M) (V := V) (W := W) (U := U) (T := T) :=
  (0, 0, 0, 0, E y, 0)

theorem arrowB_chain (he : ∀ y, S.dV (E y) = E (d1 y))
    (hk : ∀ y, S.dU (K y) = K (dx y))
    (ha : ∀ y, S.A (K y) = E (F y))
    (x : First (D := D1) (X := X)) :
    delta S (actB S E K x) = actB S E K (delta1 d1 dx F x) := by
  simp [delta, actB, delta1, he, hk, ha, S.cπ]

theorem arrowB_homotopy (he : ∀ y, S.dV (E y) = E (d1 y)) (y : D1) :
    delta S (homB (W := W) (U := U) (T := T) (M := M) E y) +
      homB (W := W) (U := U) (T := T) (M := M) E (d1 y) =
    actB S E K (include1 (X := X) y) -
      incl (V := V) (W := W) (U := U) (T := T) (S.G (E y)) := by
  simp [delta, homB, actB, include1, incl, he, Prod.sub_def, Prod.add_def]

def pathAction : U →ₗ[R] Total (M := M) (V := V) (W := W) (U := U) (T := T) where
  toFun u := (0, 0, S.π u, 0, 0, 0)
  map_add' x y := by simp
  map_smul' r x := by simp

theorem path_composition (y : D0) :
    actB S E K (actA (D1 := D1) I y) = pathAction S (K (I y)) := by
  simp [actA, actB, pathAction]

theorem strict_relation (t : T) : pathAction S (S.J t) = 0 := by
  simp [pathAction, S.πJ]

theorem arrows_right_linear
    (r : R) (x : First (D := D1) (X := X)) :
    actB S E K (r • x) = r • actB S E K x := by
  simp [actB]

theorem arrow_homotopies_right_linear (r : R) (y : D1) :
    homB (W := W) (U := U) (T := T) (M := M) E (r • y) =
      r • homB (W := W) (U := U) (T := T) (M := M) E y := by
  simp [homB]

def actAMap : D0 →ₗ[R] First (D := D1) (X := X) where
  toFun := actA I
  map_add' x y := by simp [actA]
  map_smul' r x := by simp [actA]

def homAMap : D0 →ₗ[R] First (D := D1) (X := X) where
  toFun := homA I
  map_add' x y := by simp [homA]
  map_smul' r x := by simp [homA]

def actBMap : First (D := D1) (X := X) →ₗ[R]
    Total (M := M) (V := V) (W := W) (U := U) (T := T) where
  toFun := actB S E K
  map_add' x y := by simp [actB]
  map_smul' := arrows_right_linear S E K

def homBMap : D1 →ₗ[R] Total (M := M) (V := V) (W := W) (U := U) (T := T) where
  toFun := homB E
  map_add' x y := by simp [homB]
  map_smul' := arrow_homotopies_right_linear E

end Arrows

section Finiteness

variable {K R M V W U T ι : Type*} [Field K] [Ring R] [Algebra K R]
  [AddCommGroup M] [Module K M] [Module R M] [IsScalarTower K R M]
  [Fintype ι] [DecidableEq ι]

theorem copies_projective [Module.Projective R M] : Module.Projective R (ι → M) := by
  let e : (Π₀ _ : ι, M) ≃ₗ[R] (ι → M) := DFinsupp.linearEquivFunOnFintype
  exact Module.Projective.of_equiv' e

variable [AddCommGroup V] [Module R V]
  [AddCommGroup W] [Module R W] [AddCommGroup U] [Module R U]
  [AddCommGroup T] [Module R T]

theorem total_projective [Module.Projective R M] [Module.Projective R V]
    [Module.Projective R W] [Module.Projective R U] [Module.Projective R T] :
    Module.Projective R (Total (M := M) (V := V) (W := W) (U := U) (T := T)) := by
  infer_instance

variable [Module K V] [Module K W] [Module K U] [Module K T]

theorem total_finite [FiniteDimensional K M] [FiniteDimensional K V]
    [FiniteDimensional K W] [FiniteDimensional K U] [FiniteDimensional K T] :
    FiniteDimensional K (Total (M := M) (V := V) (W := W) (U := U) (T := T)) := by
  infer_instance

theorem finite_over_finite_algebra [Module.Finite K R] [Module.Finite R M] :
    FiniteDimensional K M :=
  Module.Finite.trans R M

end Finiteness

section Insertions

variable {R M ι : Type*} [Ring R] [AddCommGroup M] [Module R M] [DecidableEq ι]

def insert (i : ι) : M →ₗ[R] (ι → M) where
  toFun x := Pi.single i x
  map_add' x y := by funext j; by_cases h : j = i <;> simp [h]
  map_smul' r x := by funext j; by_cases h : j = i <;> simp [h]

variable {AI BI : Type*} [DecidableEq BI]

def insertPath (b : BI) : (AI → M) →ₗ[R] ((BI × AI) → M) where
  toFun x p := if p.1 = b then x p.2 else 0
  map_add' x y := by funext p; by_cases h : p.1 = b <;> simp [h]
  map_smul' r x := by funext p; by_cases h : p.1 = b <;> simp [h]

end Insertions

section CanonicalArrows

variable {K R M0 M1 M2 AI BI RI : Type*} [Field K] [Ring R] [Algebra K R]
  [AddCommGroup M0] [Module K M0] [Module R M0] [IsScalarTower K R M0]
  [SMulCommClass K R M0]
  [AddCommGroup M1] [Module K M1] [Module R M1] [IsScalarTower K R M1]
  [SMulCommClass K R M1]
  [AddCommGroup M2] [Module K M2] [Module R M2] [IsScalarTower K R M2]
  [SMulCommClass K R M2]
  [Fintype AI] [Fintype BI] [Fintype RI]
  [DecidableEq AI] [DecidableEq BI] [DecidableEq RI]

variable (D : Diagram (K := K) (R := R) (M0 := M0) (M1 := M1) (M2 := M2)
  (AI := AI) (BI := BI) (RI := RI))

theorem path_fold_insertion (b : BI) (x : AI → M0) :
    firstFoldInPaths D (insertPath (R := R) b x) =
      insert (R := R) b (firstFold D x) := by
  funext b'
  by_cases hb : b' = b
  · subst b'
    simp [firstFoldInPaths, insertPath, insert, firstFold, fold]
  · simp [firstFoldInPaths, insertPath, insert, hb, Pi.single_apply]

theorem path_insertion_chain (b : BI) (x : AI → M0) :
    pointwise D.d0 (insertPath (R := R) b x) =
      insertPath (R := R) b (pointwise D.d0 x) := by
  funext p
  by_cases hb : p.1 = b <;> simp [pointwise, insertPath, hb]

theorem canonical_relation (r : RI) (x : M0) :
    (∑ b, ∑ a, D.j (Pi.single r 1) (b, a) •
      insertPath (R := R) b (insert (R := R) a x)) =
      relationInclusion D (insert (R := R) r x) := by
  funext p
  rcases p with ⟨b, a⟩
  simp [relationInclusion, extend_single, insert, insertPath, Pi.single_apply]

theorem canonical_first_arrow (a : AI) (x : M0) :
    delta1 D.d1 (pointwise D.d0) (firstFold D)
      (homA (D1 := M1) (insert (R := R) a) x) +
      homA (D1 := M1) (insert (R := R) a) (D.d0 x) =
    actA (D1 := M1) (insert (R := R) a) x -
      include1 (X := AI → M0) (D.f a x) := by
  simpa [firstFold, insert, fold_single] using
    arrowA_homotopy D.d0 D.d1 (pointwise D.d0) (firstFold D) (insert (R := R) a)
      (fun y => pointwise_single D.d0 a y) x

theorem canonical_second_arrow (b : BI) (x : M1) :
    let S := assembledSystem D
    delta S (homB (W := LinearMap.ker (relationRetractionOnModules D))
      (U := (BI × AI) → M0) (T := RI → M0) (M := M2) (insert (R := R) b) x) +
      homB (W := LinearMap.ker (relationRetractionOnModules D))
        (U := (BI × AI) → M0) (T := RI → M0) (M := M2)
        (insert (R := R) b) (D.d1 x) =
    actB S (insert (R := R) b) (insertPath (R := R) b)
      (include1 (X := AI → M0) x) -
      incl (V := BI → M1) (W := LinearMap.ker (relationRetractionOnModules D))
        (U := (BI × AI) → M0) (T := RI → M0) (D.g b x) := by
  dsimp only
  simpa [assembledSystem, systemOfSplit, secondFold, insert, fold_single] using
    arrowB_homotopy (assembledSystem D) D.d1 (insert (R := R) b)
      (insertPath (R := R) b)
      (fun y => pointwise_single D.d1 b y) x

theorem canonical_first_chain (a : AI) (x : M0) :
    delta1 D.d1 (pointwise D.d0) (firstFold D) (actA (D1 := M1) (insert (R := R) a) x) =
      actA (D1 := M1) (insert (R := R) a) (D.d0 x) :=
  arrowA_chain D.d0 D.d1 (pointwise D.d0) (firstFold D) (insert (R := R) a)
    (fun y => pointwise_single D.d0 a y) x

theorem canonical_second_chain (b : BI) (x : First (D := M1) (X := AI → M0)) :
    delta (assembledSystem D)
      (actB (assembledSystem D) (insert (R := R) b) (insertPath (R := R) b) x) =
    actB (assembledSystem D) (insert (R := R) b) (insertPath (R := R) b)
      (delta1 D.d1 (pointwise D.d0) (firstFold D) x) :=
  arrowB_chain (assembledSystem D) D.d1 (pointwise D.d0) (firstFold D)
    (insert (R := R) b) (insertPath (R := R) b)
    (fun y => pointwise_single D.d1 b y)
    (path_insertion_chain D b) (path_fold_insertion D b) x

theorem canonical_strict_relations (r : RI) (x : M0) :
    (∑ b, ∑ a, D.j (Pi.single r 1) (b, a) •
      actB (assembledSystem D) (insert (R := R) b) (insertPath (R := R) b)
        (actA (D1 := M1) (insert (R := R) a) x)) = 0 := by
  let S := assembledSystem D
  calc
    _ = pathAction S (∑ b, ∑ a, D.j (Pi.single r 1) (b, a) •
        insertPath (R := R) b (insert (R := R) a x)) := by
      simp only [map_sum, LinearMap.map_smul_of_tower, path_composition]
      rfl
    _ = pathAction S (relationInclusion D (insert (R := R) r x)) := by
      rw [canonical_relation D r x]
    _ = 0 := strict_relation S _

end CanonicalArrows

section Grading

variable {R M V W U T : Type*} [Ring R]
  [AddCommGroup M] [Module R M] [AddCommGroup V] [Module R V]
  [AddCommGroup W] [Module R W] [AddCommGroup U] [Module R U]
  [AddCommGroup T] [Module R T]
  (S : System (R := R) (M := M) (V := V) (W := W) (U := U) (T := T))

structure Grading where
  m : ℤ → Submodule R M
  v : ℤ → Submodule R V
  w : ℤ → Submodule R W
  u : ℤ → Submodule R U
  t : ℤ → Submodule R T
  dm : ∀ n x, x ∈ m n → S.dM x ∈ m (n + 1)
  dv : ∀ n x, x ∈ v n → S.dV x ∈ v (n + 1)
  dw : ∀ n x, x ∈ w n → S.dW x ∈ w (n + 1)
  du : ∀ n x, x ∈ u n → S.dU x ∈ u (n + 1)
  dt : ∀ n x, x ∈ t n → S.dT x ∈ t (n + 1)
  a : ∀ n x, x ∈ u n → S.A x ∈ v n
  g : ∀ n x, x ∈ v n → S.G x ∈ m n
  j : ∀ n x, x ∈ t n → S.J x ∈ u n
  p : ∀ n x, x ∈ u n → S.π x ∈ w n
  s : ∀ n x, x ∈ w n → S.s x ∈ u n
  l : ∀ n x, x ∈ u n → S.l x ∈ t n
  h : ∀ n x, x ∈ t n → S.H x ∈ m (n - 1)

variable (Q : Grading S)

def totalMember (n : ℤ) (x : Total (M := M) (V := V) (W := W) (U := U) (T := T)) :
    Prop :=
  x.1 ∈ Q.m n ∧ x.2.1 ∈ Q.v n ∧ x.2.2.1 ∈ Q.w n ∧
    x.2.2.2.1 ∈ Q.u (n + 1) ∧ x.2.2.2.2.1 ∈ Q.v (n + 1) ∧
    x.2.2.2.2.2 ∈ Q.t (n + 2)

abbrev TotalTerm (n : ℤ) :=
  Q.m n × Q.v n × Q.w n × Q.u (n + 1) × Q.v (n + 1) × Q.t (n + 2)

theorem differential_degree (n : ℤ)
    (x : Total (M := M) (V := V) (W := W) (U := U) (T := T))
    (hx : totalMember S Q n x) :
    totalMember S Q (n + 1) (delta S x) := by
  rcases hx with ⟨hy, hv, hw, hu, hz, ht⟩
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact (Q.m (n + 1)).add_mem
      ((Q.m (n + 1)).sub_mem (Q.dm n _ hy) (Q.g (n + 1) _ hz))
      (by simpa only [show n + 2 - 1 = n + 1 by omega] using Q.h (n + 2) _ ht)
  · exact (Q.v (n + 1)).add_mem
      ((Q.v (n + 1)).sub_mem (Q.dv n _ hv) (Q.a (n + 1) _ hu)) hz
  · exact (Q.w (n + 1)).add_mem (Q.dw n _ hw) (Q.p (n + 1) _ hu)
  · exact (Q.u (n + 1 + 1)).add_mem
      ((Q.u (n + 1 + 1)).neg_mem (Q.du (n + 1) _ hu))
      (by simpa [add_assoc] using Q.j (n + 2) _ ht)
  · exact (Q.v (n + 1 + 1)).add_mem
      ((Q.v (n + 1 + 1)).neg_mem (Q.dv (n + 1) _ hz))
      (by simpa [add_assoc] using Q.a (n + 2) _ (Q.j (n + 2) _ ht))
  · simpa [delta, add_assoc, add_comm, add_left_comm] using Q.dt (n + 2) _ ht

theorem inclusion_degree (n : ℤ) (x : M) (hx : x ∈ Q.m n) :
    totalMember S Q n (incl (V := V) (W := W) (U := U) (T := T) x) := by
  simp [totalMember, incl, hx]

theorem retraction_degree (n : ℤ)
    (x : Total (M := M) (V := V) (W := W) (U := U) (T := T))
    (hx : totalMember S Q n x) : retract S x ∈ Q.m n := by
  rcases hx with ⟨hy, hv, hw, hu, _, _⟩
  exact (Q.m n).sub_mem
    ((Q.m n).add_mem ((Q.m n).add_mem hy (Q.g n _ hv))
      (Q.g n _ (Q.a n _ (Q.s n _ hw))))
    (by simpa using Q.h (n + 1) _ (Q.l (n + 1) _ hu))

theorem contraction_degree (n : ℤ)
    (x : Total (M := M) (V := V) (W := W) (U := U) (T := T))
    (hx : totalMember S Q n x) : totalMember S Q (n - 1) (contract S x) := by
  rcases hx with ⟨_, hv, hw, hu, _, _⟩
  refine ⟨(Q.m _).zero_mem, (Q.v _).zero_mem, (Q.w _).zero_mem, ?_, ?_, ?_⟩
  · simpa [contract] using Q.s n _ hw
  · simpa [contract] using (Q.v n).add_mem hv (Q.a n _ (Q.s n _ hw))
  · simpa only [contract, show n - 1 + 2 = n + 1 by omega] using Q.l (n + 1) _ hu

theorem total_term_projective (n : ℤ)
    [Module.Projective R (Q.m n)] [Module.Projective R (Q.v n)]
    [Module.Projective R (Q.w n)] [Module.Projective R (Q.u (n + 1))]
    [Module.Projective R (Q.v (n + 1))] [Module.Projective R (Q.t (n + 2))] :
    Module.Projective R (TotalTerm S Q n) := by
  dsimp [TotalTerm]
  infer_instance

def Supported {N : Type*} [AddCommGroup N] [Module R N]
    (g : ℤ → Submodule R N) (a b : ℤ) : Prop :=
  ∀ n x, x ∈ g n → (n < a ∨ b < n) → x = 0

theorem total_bounded (a b : ℤ)
    (hm : Supported Q.m a b) (hv : Supported Q.v a b)
    (hw : Supported Q.w a b) (hu : Supported Q.u a b)
    (ht : Supported Q.t a b) (n : ℤ) (hn : n < a - 2 ∨ b < n)
    (x : Total (M := M) (V := V) (W := W) (U := U) (T := T))
    (hx : totalMember S Q n x) : x = 0 := by
  have h0 : n < a ∨ b < n := by omega
  have h1 : n + 1 < a ∨ b < n + 1 := by omega
  have h2 : n + 2 < a ∨ b < n + 2 := by omega
  rcases x with ⟨y, v, w, u, z, t⟩
  rcases hx with ⟨hy, hv', hw', hu', hz, ht'⟩
  simp only [Prod.mk.injEq, Prod.zero_eq_mk]
  exact ⟨hm n y hy h0, hv n v hv' h0, hw n w hw' h0,
    hu (n + 1) u hu' h1, hv (n + 1) z hz h1, ht (n + 2) t ht' h2⟩

end Grading

section GradeHelpers

variable {R M N ι : Type*} [Ring R]
  [AddCommGroup M] [Module R M] [AddCommGroup N] [Module R N]

def copies (p : Submodule R M) : Submodule R (ι → M) where
  carrier := {x | ∀ i, x i ∈ p}
  zero_mem' i := p.zero_mem
  add_mem' hx hy i := p.add_mem (hx i) (hy i)
  smul_mem' r x hx i := p.smul_mem r (hx i)

def copiesEquiv (p : Submodule R M) : copies (ι := ι) p ≃ₗ[R] (ι → p) where
  toFun x i := ⟨x.1 i, x.2 i⟩
  invFun x := ⟨fun i => (x i).1, fun i => (x i).2⟩
  left_inv x := rfl
  right_inv x := rfl
  map_add' x y := rfl
  map_smul' r x := rfl

def onPiece (f : M →ₗ[R] N) (p : Submodule R M) (q : Submodule R N)
    (h : ∀ x, x ∈ p → f x ∈ q) : p →ₗ[R] q where
  toFun x := ⟨f x, h x x.2⟩
  map_add' x y := Subtype.ext (f.map_add x y)
  map_smul' r x := Subtype.ext (f.map_smul r x)

variable [Fintype ι] [DecidableEq ι]

theorem copies_piece_projective (p : Submodule R M) [Module.Projective R p] :
    Module.Projective R (copies (ι := ι) p) := by
  letI : Module.Projective R (ι → p) := copies_projective
  exact Module.Projective.of_equiv' (copiesEquiv p).symm

theorem copies_supported (g : ℤ → Submodule R M) (a b : ℤ)
    (h : Supported g a b) :
    Supported (fun n => copies (ι := ι) (g n)) a b := by
  intro n x hx hn
  funext i
  exact h n (x i) (hx i) hn

variable {K κ : Type*} [Field K] [Algebra K R]
  [Module K M] [IsScalarTower K R M] [SMulCommClass K R M]
  [Fintype κ] [DecidableEq κ]

theorem extend_preserves (f : (ι → K) →ₗ[K] (κ → K)) (p : Submodule R M)
    (x : ι → M) (hx : x ∈ copies p) :
    extend (R := R) f x ∈ copies p := by
  intro k
  exact p.sum_mem fun i _ => (p.restrictScalars K).smul_mem _ (hx i)

theorem copies_piece_finite (p : Submodule R M) [FiniteDimensional K p] :
    FiniteDimensional K (copies (ι := ι) p) :=
  FiniteDimensional.of_injective ((copiesEquiv p).toLinearMap.restrictScalars K)
    (copiesEquiv p).injective

end GradeHelpers

section GradedComplement

variable {R M V W U T : Type*} [Ring R]
  [AddCommGroup M] [Module R M] [AddCommGroup V] [Module R V]
  [AddCommGroup W] [Module R W] [AddCommGroup U] [Module R U]
  [AddCommGroup T] [Module R T]
  (S : System (R := R) (M := M) (V := V) (W := W) (U := U) (T := T))
  (Q : Grading S)

theorem complement_piece_projective (n : ℤ) [Module.Projective R (Q.u n)] :
    Module.Projective R (Q.w n) := by
  apply Module.Projective.of_split
    (onPiece S.s (Q.w n) (Q.u n) (Q.s n))
    (onPiece S.π (Q.u n) (Q.w n) (Q.p n))
  apply LinearMap.ext
  intro x
  exact Subtype.ext (S.πs x)

theorem complement_supported (a b : ℤ) (hu : Supported Q.u a b) :
    Supported Q.w a b := by
  intro n x hx hn
  have h := congrArg S.π (hu n (S.s x) (Q.s n x hx) hn)
  simpa [S.πs] using h

variable {K : Type*} [Field K] [Algebra K R]
  [Module K U] [IsScalarTower K R U] [Module K W] [IsScalarTower K R W]

theorem complement_piece_finite (n : ℤ) [FiniteDimensional K (Q.u n)] :
    FiniteDimensional K (Q.w n) := by
  let i := onPiece S.s (Q.w n) (Q.u n) (Q.s n)
  apply FiniteDimensional.of_injective (i.restrictScalars K)
  intro x y h
  apply Subtype.ext
  have h' := congrArg (fun z : Q.u n => S.π z) h
  simpa [i, onPiece, S.πs] using h'

end GradedComplement

section InputGrading

variable {K R M0 M1 M2 AI BI RI : Type*} [Field K] [Ring R] [Algebra K R]
  [AddCommGroup M0] [Module K M0] [Module R M0] [IsScalarTower K R M0]
  [SMulCommClass K R M0]
  [AddCommGroup M1] [Module K M1] [Module R M1] [IsScalarTower K R M1]
  [SMulCommClass K R M1]
  [AddCommGroup M2] [Module K M2] [Module R M2] [IsScalarTower K R M2]
  [SMulCommClass K R M2]
  [Fintype AI] [Fintype BI] [Fintype RI]
  [DecidableEq AI] [DecidableEq BI] [DecidableEq RI]

variable (D : Diagram (K := K) (R := R) (M0 := M0) (M1 := M1) (M2 := M2)
  (AI := AI) (BI := BI) (RI := RI))

structure InputGrading where
  g0 : ℤ → Submodule R M0
  g1 : ℤ → Submodule R M1
  g2 : ℤ → Submodule R M2
  d0 : ∀ n x, x ∈ g0 n → D.d0 x ∈ g0 (n + 1)
  d1 : ∀ n x, x ∈ g1 n → D.d1 x ∈ g1 (n + 1)
  d2 : ∀ n x, x ∈ g2 n → D.d2 x ∈ g2 (n + 1)
  f : ∀ a n x, x ∈ g0 n → D.f a x ∈ g1 n
  g : ∀ b n x, x ∈ g1 n → D.g b x ∈ g2 n
  h : ∀ r n x, x ∈ g0 n → D.h r x ∈ g2 (n - 1)

variable (I : InputGrading D)

noncomputable def assembledGrading : Grading (assembledSystem D) where
  m := I.g2
  v n := copies (I.g1 n)
  u n := copies (I.g0 n)
  t n := copies (I.g0 n)
  w n := (copies (I.g0 n)).comap
    (LinearMap.ker (relationRetractionOnModules D)).subtype
  dm := I.d2
  dv n x hx b := I.d1 n (x b) (hx b)
  du n x hx p := I.d0 n (x p) (hx p)
  dt n x hx r := I.d0 n (x r) (hx r)
  dw n x hx p := I.d0 n (x.1 p) (hx p)
  a n x hx b := (I.g1 n).sum_mem fun a _ => I.f a n (x (b, a)) (hx (b, a))
  g n x hx := (I.g2 n).sum_mem fun b _ => I.g b n (x b) (hx b)
  j n x hx := extend_preserves D.j (I.g0 n) x hx
  l n x hx := extend_preserves (relationRetraction D) (I.g0 n) x hx
  s n x hx := hx
  p n x hx := by
    change (x - relationInclusion D (relationRetractionOnModules D x)) ∈ copies (I.g0 n)
    exact (copies (I.g0 n)).sub_mem hx
      (extend_preserves D.j (I.g0 n) _
        (extend_preserves (relationRetraction D) (I.g0 n) x hx))
  h n x hx := (I.g2 (n - 1)).sum_mem fun r _ => I.h r n (x r) (hx r)

theorem assembled_term_projective (n : ℤ)
    [∀ m, Module.Projective R (I.g0 m)]
    [∀ m, Module.Projective R (I.g1 m)]
    [∀ m, Module.Projective R (I.g2 m)] :
    Module.Projective R (TotalTerm (assembledSystem D) (assembledGrading D I) n) := by
  let Q := assembledGrading D I
  letI : Module.Projective R (Q.m n) := inferInstanceAs (Module.Projective R (I.g2 n))
  letI : Module.Projective R (Q.v n) := copies_piece_projective (I.g1 n)
  letI : Module.Projective R (Q.u n) := copies_piece_projective (I.g0 n)
  letI : Module.Projective R (Q.u (n + 1)) := copies_piece_projective (I.g0 (n + 1))
  letI : Module.Projective R (Q.v (n + 1)) := copies_piece_projective (I.g1 (n + 1))
  letI : Module.Projective R (Q.t (n + 2)) := copies_piece_projective (I.g0 (n + 2))
  letI : Module.Projective R (Q.w n) := complement_piece_projective (assembledSystem D) Q n
  exact total_term_projective (assembledSystem D) Q n

theorem assembled_term_finite (n : ℤ)
    [∀ m, FiniteDimensional K (I.g0 m)] [∀ m, FiniteDimensional K (I.g1 m)]
    [∀ m, FiniteDimensional K (I.g2 m)] :
    FiniteDimensional K (TotalTerm (assembledSystem D) (assembledGrading D I) n) := by
  let Q := assembledGrading D I
  letI : FiniteDimensional K (Q.m n) := inferInstanceAs (FiniteDimensional K (I.g2 n))
  letI : FiniteDimensional K (Q.v n) := copies_piece_finite (I.g1 n)
  letI : FiniteDimensional K (Q.u n) := copies_piece_finite (I.g0 n)
  letI : FiniteDimensional K (Q.u (n + 1)) := copies_piece_finite (I.g0 (n + 1))
  letI : FiniteDimensional K (Q.v (n + 1)) := copies_piece_finite (I.g1 (n + 1))
  letI : FiniteDimensional K (Q.t (n + 2)) := copies_piece_finite (I.g0 (n + 2))
  letI : FiniteDimensional K (Q.w n) := complement_piece_finite (assembledSystem D) Q n
  dsimp [TotalTerm]
  infer_instance

theorem assembled_bounded (a b : ℤ)
    (h0 : Supported I.g0 a b) (h1 : Supported I.g1 a b) (h2 : Supported I.g2 a b)
    (n : ℤ) (hn : n < a - 2 ∨ b < n)
    (x : Total (M := M2) (V := BI → M1)
      (W := LinearMap.ker (relationRetractionOnModules D))
      (U := (BI × AI) → M0) (T := RI → M0))
    (hx : totalMember (assembledSystem D) (assembledGrading D I) n x) : x = 0 := by
  let Q := assembledGrading D I
  have hu : Supported Q.u a b := copies_supported I.g0 a b h0
  exact total_bounded (assembledSystem D) Q a b h2 (copies_supported I.g1 a b h1)
    (complement_supported (assembledSystem D) Q a b hu) hu
    (copies_supported I.g0 a b h0) n hn x hx

def firstMember (n : ℤ) (x : First (D := M1) (X := AI → M0)) : Prop :=
  x.1 ∈ I.g1 n ∧ x.2.1 ∈ copies (I.g0 n) ∧ x.2.2 ∈ copies (I.g0 (n + 1))

abbrev FirstTerm (n : ℤ) :=
  I.g1 n × copies (ι := AI) (I.g0 n) × copies (ι := AI) (I.g0 (n + 1))

theorem first_fold_degree (n : ℤ) (x : AI → M0) (hx : x ∈ copies (I.g0 n)) :
    firstFold D x ∈ I.g1 n :=
  (I.g1 n).sum_mem fun a _ => I.f a n (x a) (hx a)

theorem first_differential_degree (n : ℤ) (x : First (D := M1) (X := AI → M0))
    (hx : firstMember D I n x) :
    firstMember D I (n + 1) (delta1 D.d1 (pointwise D.d0) (firstFold D) x) := by
  rcases hx with ⟨hy, hv, hu⟩
  refine ⟨(I.g1 (n + 1)).sub_mem (I.d1 n _ hy) (first_fold_degree D I (n + 1) _ hu),
    ?_, ?_⟩
  · intro a
    exact (I.g0 (n + 1)).add_mem (I.d0 n _ (hv a)) (hu a)
  · intro a
    exact (I.g0 (n + 1 + 1)).neg_mem (I.d0 (n + 1) _ (hu a))

theorem first_inclusion_degree (n : ℤ) (x : M1) (hx : x ∈ I.g1 n) :
    firstMember D I n (include1 (X := AI → M0) x) := by
  simp [firstMember, include1, hx, Submodule.zero_mem]

theorem first_retraction_degree (n : ℤ) (x : First (D := M1) (X := AI → M0))
    (hx : firstMember D I n x) : retract1 (firstFold D) x ∈ I.g1 n :=
  (I.g1 n).add_mem hx.1 (first_fold_degree D I n _ hx.2.1)

theorem first_contraction_degree (n : ℤ) (x : First (D := M1) (X := AI → M0))
    (hx : firstMember D I n x) :
    firstMember D I (n - 1) (contract1 x) := by
  refine ⟨(I.g1 _).zero_mem, (copies _).zero_mem, ?_⟩
  simpa only [contract1, sub_add_cancel] using hx.2.1

theorem first_term_projective (n : ℤ)
    [∀ m, Module.Projective R (I.g0 m)] [∀ m, Module.Projective R (I.g1 m)] :
    Module.Projective R (FirstTerm D I n) := by
  letI : Module.Projective R (copies (ι := AI) (I.g0 n)) := copies_piece_projective _
  letI : Module.Projective R (copies (ι := AI) (I.g0 (n + 1))) := copies_piece_projective _
  infer_instance

theorem first_term_finite (n : ℤ)
    [∀ m, FiniteDimensional K (I.g0 m)] [∀ m, FiniteDimensional K (I.g1 m)] :
    FiniteDimensional K (FirstTerm D I n) := by
  letI : FiniteDimensional K (copies (ι := AI) (I.g0 n)) := copies_piece_finite _
  letI : FiniteDimensional K (copies (ι := AI) (I.g0 (n + 1))) := copies_piece_finite _
  infer_instance

theorem first_bounded (a b : ℤ) (h0 : Supported I.g0 a b) (h1 : Supported I.g1 a b)
    (n : ℤ) (hn : n < a - 1 ∨ b < n) (x : First (D := M1) (X := AI → M0))
    (hx : firstMember D I n x) : x = 0 := by
  have hn0 : n < a ∨ b < n := by omega
  have hn1 : n + 1 < a ∨ b < n + 1 := by omega
  have hcopy : Supported (fun n => copies (ι := AI) (I.g0 n)) a b :=
    copies_supported I.g0 a b h0
  rcases x with ⟨y, v, u⟩
  exact Prod.ext (h1 n y hx.1 hn0)
    (Prod.ext (hcopy n v hx.2.1 hn0) (hcopy (n + 1) u hx.2.2 hn1))

theorem insertion_degree (a : AI) (n : ℤ) (x : M0) (hx : x ∈ I.g0 n) :
    insert (R := R) a x ∈ copies (I.g0 n) := by
  intro a'
  by_cases h : a' = a <;> simp [insert, h, hx]

theorem first_arrow_degree (a : AI) (n : ℤ) (x : M0) (hx : x ∈ I.g0 n) :
    firstMember D I n (actA (D1 := M1) (insert (R := R) a) x) := by
  exact ⟨(I.g1 n).zero_mem, insertion_degree D I a n x hx, (copies _).zero_mem⟩

theorem first_arrow_homotopy_degree (a : AI) (n : ℤ) (x : M0) (hx : x ∈ I.g0 n) :
    firstMember D I (n - 1) (homA (D1 := M1) (insert (R := R) a) x) := by
  refine ⟨(I.g1 _).zero_mem, (copies _).zero_mem, ?_⟩
  simpa only [homA, sub_add_cancel] using insertion_degree D I a n x hx

theorem second_insertion_degree (b : BI) (n : ℤ) (x : M1) (hx : x ∈ I.g1 n) :
    insert (R := R) b x ∈ copies (I.g1 n) := by
  intro b'
  by_cases h : b' = b <;> simp [insert, h, hx]

theorem path_insertion_degree (b : BI) (n : ℤ) (x : AI → M0)
    (hx : x ∈ copies (I.g0 n)) :
    insertPath (R := R) b x ∈ copies (I.g0 n) := by
  intro p
  by_cases h : p.1 = b <;> simp [insertPath, h, hx p.2]

theorem second_arrow_degree (b : BI) (n : ℤ) (x : First (D := M1) (X := AI → M0))
    (hx : firstMember D I n x) :
    totalMember (assembledSystem D) (assembledGrading D I) n
      (actB (assembledSystem D) (insert (R := R) b) (insertPath (R := R) b) x) := by
  let Q := assembledGrading D I
  exact ⟨(I.g2 n).zero_mem, second_insertion_degree D I b n x.1 hx.1,
    Q.p n _ (path_insertion_degree D I b n _ hx.2.1),
    path_insertion_degree D I b (n + 1) _ hx.2.2, (copies _).zero_mem,
    (copies _).zero_mem⟩

theorem second_arrow_homotopy_degree (b : BI) (n : ℤ) (x : M1) (hx : x ∈ I.g1 n) :
    totalMember (assembledSystem D) (assembledGrading D I) (n - 1)
      (homB (W := LinearMap.ker (relationRetractionOnModules D))
        (U := (BI × AI) → M0) (T := RI → M0) (M := M2) (insert (R := R) b) x) := by
  refine ⟨(I.g2 _).zero_mem, (copies _).zero_mem, (Submodule.comap _ _).zero_mem,
    (copies _).zero_mem, ?_, (copies _).zero_mem⟩
  simpa only [homB, assembledGrading, sub_add_cancel] using
    second_insertion_degree D I b n x hx

abbrev FullTerm (n : ℤ) :=
  I.g0 n × FirstTerm D I n × TotalTerm (assembledSystem D) (assembledGrading D I) n

theorem full_term_projective (n : ℤ)
    [∀ m, Module.Projective R (I.g0 m)] [∀ m, Module.Projective R (I.g1 m)]
    [∀ m, Module.Projective R (I.g2 m)] :
    Module.Projective R (FullTerm D I n) := by
  letI : Module.Projective R (FirstTerm D I n) := first_term_projective D I n
  letI : Module.Projective R
    (TotalTerm (assembledSystem D) (assembledGrading D I) n) :=
    assembled_term_projective D I n
  infer_instance

theorem full_term_finite (n : ℤ)
    [∀ m, FiniteDimensional K (I.g0 m)] [∀ m, FiniteDimensional K (I.g1 m)]
    [∀ m, FiniteDimensional K (I.g2 m)] :
    FiniteDimensional K (FullTerm D I n) := by
  letI : FiniteDimensional K (FirstTerm D I n) := first_term_finite D I n
  letI : FiniteDimensional K
    (TotalTerm (assembledSystem D) (assembledGrading D I) n) :=
    assembled_term_finite D I n
  infer_instance

end InputGrading

section GlobalBimodule

variable {K R M0 M1 M2 AI BI RI : Type*} [Field K] [Ring R] [Algebra K R]
  [AddCommGroup M0] [Module K M0] [Module R M0] [IsScalarTower K R M0]
  [SMulCommClass K R M0]
  [AddCommGroup M1] [Module K M1] [Module R M1] [IsScalarTower K R M1]
  [SMulCommClass K R M1]
  [AddCommGroup M2] [Module K M2] [Module R M2] [IsScalarTower K R M2]
  [SMulCommClass K R M2]
  [Fintype AI] [Fintype BI] [Fintype RI]
  [DecidableEq AI] [DecidableEq BI] [DecidableEq RI]

variable (D : Diagram (K := K) (R := R) (M0 := M0) (M1 := M1) (M2 := M2)
  (AI := AI) (BI := BI) (RI := RI))

abbrev Full :=
  M0 × First (D := M1) (X := AI → M0) ×
    Total (M := M2) (V := BI → M1) (W := LinearMap.ker (relationRetractionOnModules D))
      (U := (BI × AI) → M0) (T := RI → M0)

noncomputable def fullDifferential : Full D →ₗ[R] Full D where
  toFun x := (D.d0 x.1,
    delta1 D.d1 (pointwise D.d0) (firstFold D) x.2.1,
    delta (assembledSystem D) x.2.2)
  map_add' x y := by
    exact Prod.ext (D.d0.map_add x.1 y.1)
      (Prod.ext (first_add D.d1 (pointwise D.d0) (firstFold D) x.2.1 y.2.1)
        (differential_add (assembledSystem D) x.2.2 y.2.2))
  map_smul' r x := by
    exact Prod.ext (D.d0.map_smul r x.1)
      (Prod.ext (first_smul D.d1 (pointwise D.d0) (firstFold D) r x.2.1)
        (differential_smul (assembledSystem D) r x.2.2))

noncomputable def leftE0 : Full D →ₗ[R] Full D where
  toFun x := (x.1, 0, 0)
  map_add' x y := by simp
  map_smul' r x := by simp

noncomputable def leftE1 : Full D →ₗ[R] Full D where
  toFun x := (0, x.2.1, 0)
  map_add' x y := by simp
  map_smul' r x := by simp

noncomputable def leftE2 : Full D →ₗ[R] Full D where
  toFun x := (0, 0, x.2.2)
  map_add' x y := by simp
  map_smul' r x := by simp

noncomputable def leftA (a : AI) : Full D →ₗ[R] Full D where
  toFun x := (0, actA (D1 := M1) (insert (R := R) a) x.1, 0)
  map_add' x y := by simp [actA]
  map_smul' r x := by simp [actA]

noncomputable def leftB (b : BI) : Full D →ₗ[R] Full D where
  toFun x := (0, 0,
    actB (assembledSystem D) (insert (R := R) b) (insertPath (R := R) b) x.2.1)
  map_add' x y := by simp [actB]
  map_smul' r x := by simp [actB]

theorem global_differential_square (x : Full D) :
    fullDifferential D (fullDifferential D x) = 0 :=
  Prod.ext (D.sq0 x.1)
    (Prod.ext (first_square D.d1 (pointwise D.d0) (firstFold D) D.sq1
      (fun x => funext fun a => D.sq0 (x a)) (first_fold_chain D) x.2.1)
      (differential_square (assembledSystem D) x.2.2))

theorem left_unit (x : Full D) :
    leftE0 D x + leftE1 D x + leftE2 D x = x := by
  simp [leftE0, leftE1, leftE2, Prod.add_def]

theorem left_vertex_rules (x : Full D) :
    leftE0 D (leftE0 D x) = leftE0 D x ∧
    leftE1 D (leftE1 D x) = leftE1 D x ∧
    leftE2 D (leftE2 D x) = leftE2 D x ∧
    leftE0 D (leftE1 D x) = 0 ∧ leftE0 D (leftE2 D x) = 0 ∧
    leftE1 D (leftE0 D x) = 0 ∧ leftE1 D (leftE2 D x) = 0 ∧
    leftE2 D (leftE0 D x) = 0 ∧ leftE2 D (leftE1 D x) = 0 := by
  simp [leftE0, leftE1, leftE2]

theorem left_arrow_endpoints (a : AI) (b : BI) (x : Full D) :
    leftE1 D (leftA D a x) = leftA D a x ∧
    leftA D a (leftE0 D x) = leftA D a x ∧
    leftE2 D (leftB D b x) = leftB D b x ∧
    leftB D b (leftE1 D x) = leftB D b x := by
  simp [leftE0, leftE1, leftE2, leftA, leftB]

theorem full_first_chain (a : AI) (x : Full D) :
    fullDifferential D (leftA D a x) = leftA D a (fullDifferential D x) := by
  change (D.d0 0, delta1 D.d1 (pointwise D.d0) (firstFold D)
    (actA (D1 := M1) (insert (R := R) a) x.1), delta (assembledSystem D) 0) =
    (0, actA (D1 := M1) (insert (R := R) a) (D.d0 x.1), 0)
  simp [canonical_first_chain, delta]

theorem full_second_chain (b : BI) (x : Full D) :
    fullDifferential D (leftB D b x) = leftB D b (fullDifferential D x) := by
  change (D.d0 0, delta1 D.d1 (pointwise D.d0) (firstFold D) 0,
    delta (assembledSystem D)
      (actB (assembledSystem D) (insert (R := R) b) (insertPath (R := R) b) x.2.1)) =
    (0, 0, actB (assembledSystem D) (insert (R := R) b) (insertPath (R := R) b)
      (delta1 D.d1 (pointwise D.d0) (firstFold D) x.2.1))
  simp [canonical_second_chain, delta1]

theorem full_strict_relations (r : RI) (x : Full D) :
    (∑ b, ∑ a, D.j (Pi.single r 1) (b, a) • leftB D b (leftA D a x)) = 0 := by
  let e : Total (M := M2) (V := BI → M1)
      (W := LinearMap.ker (relationRetractionOnModules D))
      (U := (BI × AI) → M0) (T := RI → M0) →ₗ[R] Full D :=
    { toFun := fun y => (0, 0, y)
      map_add' := by intros; simp
      map_smul' := by intros; simp }
  calc
    _ = e (∑ b, ∑ a, D.j (Pi.single r 1) (b, a) •
        actB (assembledSystem D) (insert (R := R) b) (insertPath (R := R) b)
          (actA (D1 := M1) (insert (R := R) a) x.1)) := by
      simp only [map_sum, LinearMap.map_smul_of_tower]
      rfl
    _ = 0 := by rw [canonical_strict_relations, map_zero]

theorem full_vertices_chain (x : Full D) :
    fullDifferential D (leftE0 D x) = leftE0 D (fullDifferential D x) ∧
    fullDifferential D (leftE1 D x) = leftE1 D (fullDifferential D x) ∧
    fullDifferential D (leftE2 D x) = leftE2 D (fullDifferential D x) := by
  simp [fullDifferential, leftE0, leftE1, leftE2, delta1, delta]

variable (I : InputGrading D)

def fullMember (n : ℤ) (x : Full D) : Prop :=
  x.1 ∈ I.g0 n ∧ firstMember D I n x.2.1 ∧
    totalMember (assembledSystem D) (assembledGrading D I) n x.2.2

theorem full_differential_degree (n : ℤ) (x : Full D) (hx : fullMember D I n x) :
    fullMember D I (n + 1) (fullDifferential D x) :=
  ⟨I.d0 n x.1 hx.1, first_differential_degree D I n x.2.1 hx.2.1,
    differential_degree (assembledSystem D) (assembledGrading D I) n x.2.2 hx.2.2⟩

theorem full_first_degree (a : AI) (n : ℤ) (x : Full D) (hx : fullMember D I n x) :
    fullMember D I n (leftA D a x) :=
  ⟨(I.g0 n).zero_mem, first_arrow_degree D I a n x.1 hx.1,
    by simp [totalMember, assembledGrading, leftA]⟩

theorem full_second_degree (b : BI) (n : ℤ) (x : Full D) (hx : fullMember D I n x) :
    fullMember D I n (leftB D b x) :=
  ⟨(I.g0 n).zero_mem, by simp [firstMember, leftB],
    second_arrow_degree D I b n x.2.1 hx.2.1⟩

theorem full_vertices_degree (n : ℤ) (x : Full D) (hx : fullMember D I n x) :
    fullMember D I n (leftE0 D x) ∧ fullMember D I n (leftE1 D x) ∧
      fullMember D I n (leftE2 D x) := by
  refine ⟨⟨hx.1, ?_, ?_⟩, ⟨(I.g0 n).zero_mem, hx.2.1, ?_⟩,
    ⟨(I.g0 n).zero_mem, ?_, hx.2.2⟩⟩
  all_goals simp [firstMember, totalMember, leftE0, leftE1, leftE2]

theorem full_bounded (a b : ℤ)
    (h0 : Supported I.g0 a b) (h1 : Supported I.g1 a b) (h2 : Supported I.g2 a b)
    (n : ℤ) (hn : n < a - 2 ∨ b < n) (x : Full D) (hx : fullMember D I n x) :
    x = 0 := by
  apply Prod.ext (h0 n x.1 hx.1 (by omega))
  exact Prod.ext (first_bounded D I a b h0 h1 n (by omega) x.2.1 hx.2.1)
    (assembled_bounded D I a b h0 h1 h2 n hn x.2.2 hx.2.2)

structure RectificationCertificate (a b : ℤ) : Prop where
  differential_square : ∀ x, fullDifferential D (fullDifferential D x) = 0
  differential_degree : ∀ n x, fullMember D I n x →
    fullMember D I (n + 1) (fullDifferential D x)
  projective_terms : ∀ n, Module.Projective R (FullTerm D I n)
  finite_terms : ∀ n, FiniteDimensional K (FullTerm D I n)
  bounded : ∀ n, (n < a - 2 ∨ b < n) → ∀ x, fullMember D I n x → x = 0
  unit : ∀ x, leftE0 D x + leftE1 D x + leftE2 D x = x
  vertices : ∀ x,
    leftE0 D (leftE0 D x) = leftE0 D x ∧
    leftE1 D (leftE1 D x) = leftE1 D x ∧
    leftE2 D (leftE2 D x) = leftE2 D x ∧
    leftE0 D (leftE1 D x) = 0 ∧ leftE0 D (leftE2 D x) = 0 ∧
    leftE1 D (leftE0 D x) = 0 ∧ leftE1 D (leftE2 D x) = 0 ∧
    leftE2 D (leftE0 D x) = 0 ∧ leftE2 D (leftE1 D x) = 0
  endpoints : ∀ a b x,
    leftE1 D (leftA D a x) = leftA D a x ∧
    leftA D a (leftE0 D x) = leftA D a x ∧
    leftE2 D (leftB D b x) = leftB D b x ∧
    leftB D b (leftE1 D x) = leftB D b x
  vertices_chain : ∀ x,
    fullDifferential D (leftE0 D x) = leftE0 D (fullDifferential D x) ∧
    fullDifferential D (leftE1 D x) = leftE1 D (fullDifferential D x) ∧
    fullDifferential D (leftE2 D x) = leftE2 D (fullDifferential D x)
  vertices_degree : ∀ n x, fullMember D I n x →
    fullMember D I n (leftE0 D x) ∧ fullMember D I n (leftE1 D x) ∧
      fullMember D I n (leftE2 D x)
  first_arrow_chain : ∀ a x,
    fullDifferential D (leftA D a x) = leftA D a (fullDifferential D x)
  second_arrow_chain : ∀ b x,
    fullDifferential D (leftB D b x) = leftB D b (fullDifferential D x)
  first_arrow_degree : ∀ a n x, fullMember D I n x → fullMember D I n (leftA D a x)
  second_arrow_degree : ∀ b n x, fullMember D I n x → fullMember D I n (leftB D b x)
  relations : ∀ r x,
    (∑ b, ∑ a, D.j (Pi.single r 1) (b, a) • leftB D b (leftA D a x)) = 0
  first_inclusion_chain : ∀ x,
    delta1 D.d1 (pointwise D.d0) (firstFold D) (include1 (X := AI → M0) x) =
      include1 (X := AI → M0) (D.d1 x)
  first_retraction_chain : ∀ x,
    retract1 (firstFold D) (delta1 D.d1 (pointwise D.d0) (firstFold D) x) =
      D.d1 (retract1 (firstFold D) x)
  first_inverse : ∀ x, retract1 (firstFold D) (include1 (X := AI → M0) x) = x
  first_contraction : ∀ x,
    delta1 D.d1 (pointwise D.d0) (firstFold D) (contract1 x) +
      contract1 (delta1 D.d1 (pointwise D.d0) (firstFold D) x) =
    x - include1 (X := AI → M0) (retract1 (firstFold D) x)
  second_inclusion_chain : ∀ x,
    delta (assembledSystem D)
      (incl (V := BI → M1) (W := LinearMap.ker (relationRetractionOnModules D))
        (U := (BI × AI) → M0) (T := RI → M0) x) =
    incl (V := BI → M1) (W := LinearMap.ker (relationRetractionOnModules D))
      (U := (BI × AI) → M0) (T := RI → M0) (D.d2 x)
  second_retraction_chain : ∀ x,
    retract (assembledSystem D) (delta (assembledSystem D) x) =
      D.d2 (retract (assembledSystem D) x)
  second_inverse : ∀ x,
    retract (assembledSystem D)
      (incl (V := BI → M1) (W := LinearMap.ker (relationRetractionOnModules D))
        (U := (BI × AI) → M0) (T := RI → M0) x) = x
  second_contraction : ∀ x,
    delta (assembledSystem D) (contract (assembledSystem D) x) +
      contract (assembledSystem D) (delta (assembledSystem D) x) =
    x - incl (V := BI → M1) (W := LinearMap.ker (relationRetractionOnModules D))
      (U := (BI × AI) → M0) (T := RI → M0) (retract (assembledSystem D) x)
  first_inclusion_degree : ∀ n x, x ∈ I.g1 n →
    firstMember D I n (include1 (X := AI → M0) x)
  first_retraction_degree : ∀ n x, firstMember D I n x →
    retract1 (firstFold D) x ∈ I.g1 n
  first_contraction_degree : ∀ n x, firstMember D I n x →
    firstMember D I (n - 1) (contract1 x)
  second_inclusion_degree : ∀ n x, x ∈ I.g2 n →
    totalMember (assembledSystem D) (assembledGrading D I) n
      (incl (V := BI → M1) (W := LinearMap.ker (relationRetractionOnModules D))
        (U := (BI × AI) → M0) (T := RI → M0) x)
  second_retraction_degree : ∀ n x,
    totalMember (assembledSystem D) (assembledGrading D I) n x →
    retract (assembledSystem D) x ∈ I.g2 n
  second_contraction_degree : ∀ n x,
    totalMember (assembledSystem D) (assembledGrading D I) n x →
    totalMember (assembledSystem D) (assembledGrading D I) (n - 1)
      (contract (assembledSystem D) x)
  first_arrow_homotopy : ∀ a x,
    delta1 D.d1 (pointwise D.d0) (firstFold D)
      (homA (D1 := M1) (insert (R := R) a) x) +
      homA (D1 := M1) (insert (R := R) a) (D.d0 x) =
    actA (D1 := M1) (insert (R := R) a) x -
      include1 (X := AI → M0) (D.f a x)
  second_arrow_homotopy : ∀ b x,
    delta (assembledSystem D)
      (homB (W := LinearMap.ker (relationRetractionOnModules D))
        (U := (BI × AI) → M0) (T := RI → M0) (M := M2) (insert (R := R) b) x) +
    homB (W := LinearMap.ker (relationRetractionOnModules D))
      (U := (BI × AI) → M0) (T := RI → M0) (M := M2) (insert (R := R) b) (D.d1 x) =
    actB (assembledSystem D) (insert (R := R) b) (insertPath (R := R) b)
      (include1 (X := AI → M0) x) -
    incl (V := BI → M1) (W := LinearMap.ker (relationRetractionOnModules D))
      (U := (BI × AI) → M0) (T := RI → M0) (D.g b x)
  first_arrow_homotopy_degree : ∀ a n x, x ∈ I.g0 n →
    firstMember D I (n - 1) (homA (D1 := M1) (insert (R := R) a) x)
  second_arrow_homotopy_degree : ∀ b n x, x ∈ I.g1 n →
    totalMember (assembledSystem D) (assembledGrading D I) (n - 1)
      (homB (W := LinearMap.ker (relationRetractionOnModules D))
        (U := (BI × AI) → M0) (T := RI → M0) (M := M2) (insert (R := R) b) x)

theorem complete_rectification
    [∀ n, Module.Projective R (I.g0 n)] [∀ n, Module.Projective R (I.g1 n)]
    [∀ n, Module.Projective R (I.g2 n)]
    [∀ n, FiniteDimensional K (I.g0 n)] [∀ n, FiniteDimensional K (I.g1 n)]
    [∀ n, FiniteDimensional K (I.g2 n)]
    (a b : ℤ) (h0 : Supported I.g0 a b) (h1 : Supported I.g1 a b)
    (h2 : Supported I.g2 a b) : RectificationCertificate D I a b where
  differential_square := global_differential_square D
  differential_degree := full_differential_degree D I
  projective_terms n := full_term_projective D I n
  finite_terms n := full_term_finite D I n
  bounded := full_bounded D I a b h0 h1 h2
  unit := left_unit D
  vertices := left_vertex_rules D
  endpoints := left_arrow_endpoints D
  vertices_chain := full_vertices_chain D
  vertices_degree := full_vertices_degree D I
  first_arrow_chain := full_first_chain D
  second_arrow_chain := full_second_chain D
  first_arrow_degree := full_first_degree D I
  second_arrow_degree := full_second_degree D I
  relations := full_strict_relations D
  first_inclusion_chain := first_include_chain D.d1 (pointwise D.d0) (firstFold D)
  first_retraction_chain := first_retract_chain D.d1 (pointwise D.d0)
    (firstFold D) (first_fold_chain D)
  first_inverse := first_retract_include (firstFold D)
  first_contraction := first_contract D.d1 (pointwise D.d0) (firstFold D)
  second_inclusion_chain := inclusion_chain (assembledSystem D)
  second_retraction_chain := retraction_chain (assembledSystem D)
  second_inverse := retraction_inclusion (assembledSystem D)
  second_contraction := contraction_identity (assembledSystem D)
  first_inclusion_degree := first_inclusion_degree D I
  first_retraction_degree := first_retraction_degree D I
  first_contraction_degree := first_contraction_degree D I
  second_inclusion_degree := inclusion_degree (assembledSystem D) (assembledGrading D I)
  second_retraction_degree := retraction_degree (assembledSystem D) (assembledGrading D I)
  second_contraction_degree := contraction_degree (assembledSystem D) (assembledGrading D I)
  first_arrow_homotopy := canonical_first_arrow D
  second_arrow_homotopy := canonical_second_arrow D
  first_arrow_homotopy_degree := first_arrow_homotopy_degree D I
  second_arrow_homotopy_degree := second_arrow_homotopy_degree D I

end GlobalBimodule

end ThreeLayer
