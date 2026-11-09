import Mathlib

set_option autoImplicit false

namespace UniformConnectivity

variable {A R : Type*} [CommRing R]

def koszulSign (parity : A → Bool) (a b : A) : R :=
  if parity a && parity b then -1 else 1

def unitParity (parity : A → Bool) : Option A → Bool
  | none => false
  | some a => parity a

def Signed (parity : A → Bool) (f : List A → R) : Prop :=
  ∀ (pre : List A) (a b : A) (post : List A),
    f (pre ++ a :: b :: post) =
      koszulSign parity a b * f (pre ++ b :: a :: post)

theorem Signed.zero (parity : A → Bool) :
    Signed parity (fun _ => (0 : R)) := by
  intro pre a b post
  simp

theorem Signed.add {parity : A → Bool} {f g : List A → R}
    (hf : Signed parity f) (hg : Signed parity g) :
    Signed parity (fun w => f w + g w) := by
  intro pre a b post
  dsimp only
  rw [hf, hg, mul_add]

theorem Signed.smul {parity : A → Bool} {f : List A → R}
    (hf : Signed parity f) (c : R) :
    Signed parity (fun w => c * f w) := by
  intro pre a b post
  dsimp only
  rw [hf]
  ring

inductive KoszulPermutation (parity : A → Bool) :
    List A → List A → R → Prop
  | nil : KoszulPermutation parity [] [] 1
  | cons (a : A) {v w : List A} {s : R}
      (h : KoszulPermutation parity v w s) :
      KoszulPermutation parity (a :: v) (a :: w) s
  | swap (a b : A) (w : List A) :
      KoszulPermutation parity (b :: a :: w) (a :: b :: w)
        (koszulSign parity b a)
  | trans {u v w : List A} {s t : R}
      (h : KoszulPermutation parity u v s)
      (k : KoszulPermutation parity v w t) :
      KoszulPermutation parity u w (s * t)

theorem KoszulPermutation.isPerm {parity : A → Bool}
    {v w : List A} {s : R} (h : KoszulPermutation parity v w s) :
    v.Perm w := by
  induction h with
  | nil => exact List.Perm.nil
  | cons a h ih => exact ih.cons a
  | swap a b w => exact List.Perm.swap a b w
  | trans h k ih ik => exact ih.trans ik

theorem koszulPermutation_lift (parity : A → Bool) {v w : List A}
    (h : v.Perm w) :
    ∃ s : R, KoszulPermutation parity v w s := by
  induction h with
  | nil => exact ⟨1, .nil⟩
  | cons a h ih =>
    obtain ⟨s, hs⟩ := ih
    exact ⟨s, .cons a hs⟩
  | swap a b w => exact ⟨koszulSign parity b a, .swap a b w⟩
  | trans h k ih ik =>
    obtain ⟨s, hs⟩ := ih
    obtain ⟨t, ht⟩ := ik
    exact ⟨s * t, .trans hs ht⟩

theorem Signed.respects {parity : A → Bool} {f : List A → R}
    (hf : Signed parity f) {v w : List A} {s : R}
    (h : KoszulPermutation parity v w s) :
    ∀ pre : List A, f (pre ++ v) = s * f (pre ++ w) := by
  induction h with
  | nil => intro pre; simp
  | cons a h ih =>
    intro pre
    simpa [List.append_assoc] using ih (pre ++ [a])
  | swap a b w => intro pre; exact hf pre b a w
  | trans h k ih ik =>
    intro pre
    rw [ih pre, ik pre, mul_assoc]

theorem signed_permutation_invariance {parity : A → Bool} {f : List A → R}
    (hf : Signed parity f) {v w : List A} {s : R}
    (h : KoszulPermutation parity v w s) :
    f v = s * f w := by
  simpa using hf.respects h []

def blankCount : List (Option A) → ℕ
  | [] => 0
  | none :: w => blankCount w + 1
  | some _ :: w => blankCount w

theorem occupied_add_blank (w : List (Option A)) :
    w.reduceOption.length + blankCount w = w.length := by
  induction w with
  | nil => simp [blankCount]
  | cons a w ih => cases a <;> simp [blankCount] <;> omega

def pad (n : ℕ) (v : List A) : List (Option A) :=
  v.map some ++ List.replicate (n - v.length) none

@[simp] theorem reduceOption_map_some (v : List A) :
    (v.map some).reduceOption = v := by
  induction v <;> simp_all

@[simp] theorem reduceOption_pad (n : ℕ) (v : List A) :
    (pad n v).reduceOption = v := by
  simp [pad, List.reduceOption_append]

theorem pad_injective (n : ℕ) : Function.Injective (pad (A := A) n) := by
  intro v w h
  simpa using congrArg List.reduceOption h

theorem length_pad (n : ℕ) (v : List A) (h : v.length ≤ n) :
    (pad n v).length = n := by
  simp only [pad, List.length_append, List.length_map, List.length_replicate]
  omega

theorem pad_eq_normal (w : List (Option A)) :
    pad w.length w.reduceOption =
      w.reduceOption.map some ++ List.replicate (blankCount w) none := by
  have h := occupied_add_blank w
  have hc : w.length - w.reduceOption.length = blankCount w := by omega
  simp [pad, hc]

theorem perm_pad (w : List (Option A)) :
    w.Perm (pad w.length w.reduceOption) := by
  rw [pad_eq_normal]
  induction w with
  | nil => simp [blankCount]
  | cons a w ih =>
    cases a with
    | none =>
      have h := (ih.cons none).trans
        (List.perm_middle.symm :
          (none :: (w.reduceOption.map some ++
            List.replicate (blankCount w) none)).Perm
          (w.reduceOption.map some ++ none ::
            List.replicate (blankCount w) none))
      simpa [blankCount, List.replicate_succ] using h
    | some a => simpa [blankCount] using ih.cons (some a)

theorem slide_unit {parity : A → Bool} {f : List (Option A) → R}
    (hf : Signed (unitParity parity) f)
    (pre mid post : List (Option A)) :
    f (pre ++ (none :: mid) ++ post) =
      f (pre ++ mid ++ none :: post) := by
  induction mid generalizing pre with
  | nil => simp
  | cons b mid ih =>
    calc
      f (pre ++ (none :: b :: mid) ++ post) =
          f ((pre ++ [b]) ++ (none :: mid) ++ post) := by
        simpa [koszulSign, unitParity, List.append_assoc] using
          hf pre none b (mid ++ post)
      _ = f ((pre ++ [b]) ++ mid ++ none :: post) := ih (pre ++ [b])
      _ = f (pre ++ (b :: mid) ++ none :: post) := by
        simp [List.append_assoc]

theorem compact_units {parity : A → Bool} {f : List (Option A) → R}
    (hf : Signed (unitParity parity) f)
    (w pre post : List (Option A)) :
    f (pre ++ w ++ post) =
      f (pre ++ w.reduceOption.map some ++
        List.replicate (blankCount w) none ++ post) := by
  induction w generalizing pre post with
  | nil => simp [blankCount]
  | cons a w ih =>
    cases a with
    | none =>
      calc
        f (pre ++ (none :: w) ++ post) =
            f (pre ++ w ++ none :: post) := slide_unit hf pre w post
        _ = f (pre ++ w.reduceOption.map some ++
            List.replicate (blankCount w) none ++ none :: post) :=
          ih pre (none :: post)
        _ = f (pre ++ (none :: w).reduceOption.map some ++
            List.replicate (blankCount (none :: w)) none ++ post) := by
          simp [blankCount, List.replicate_succ', List.append_assoc]
    | some a =>
      simpa [blankCount, List.append_assoc] using ih (pre ++ [some a]) post

theorem signed_determined_by_occupied {parity : A → Bool}
    {f : List (Option A) → R} (hf : Signed (unitParity parity) f)
    (w : List (Option A)) :
    f w = f (pad w.length w.reduceOption) := by
  simpa [pad_eq_normal] using compact_units hf w [] []

def InvariantCoefficients (parity : A → Bool) (allowed : ℕ → Prop) :
    Submodule R (List A →₀ R) where
  carrier := {f | (∀ w, ¬ allowed w.length → f w = 0) ∧ Signed parity f}
  zero_mem' := ⟨by simp, Signed.zero parity⟩
  add_mem' := by
    intro f g hf hg
    refine ⟨?_, ?_⟩
    · intro w hw
      simp [hf.1 w hw, hg.1 w hw]
    · simpa only [Signed, Finsupp.add_apply] using hf.2.add hg.2
  smul_mem' := by
    intro c f hf
    refine ⟨?_, ?_⟩
    · intro w hw
      simp [hf.1 w hw]
    · simpa only [Signed, Finsupp.smul_apply, smul_eq_mul] using hf.2.smul c

abbrev TensorInvariants (parity : A → Bool) (n : ℕ) :=
  InvariantCoefficients (R := R) (unitParity parity) (· = n)

abbrev OccupiedInvariants (parity : A → Bool) (n : ℕ) :=
  InvariantCoefficients (R := R) parity (· ≤ n)

abbrev PureInvariants (parity : A → Bool) (r : ℕ) :=
  InvariantCoefficients (R := R) parity (· = r)

def expandFun (n : ℕ) (g : List A → R) (w : List (Option A)) : R :=
  if w.length = n then g w.reduceOption else 0

theorem expandFun_finite (n : ℕ) (g : List A →₀ R) :
    (Function.support (expandFun n g)).Finite := by
  classical
  let s : Finset (List (Option A)) :=
    g.support.biUnion fun v => (pad n v).permutations.toFinset
  apply s.finite_toSet.subset
  intro w hw
  have hlen : w.length = n := by
    by_contra hn
    exact hw (by simp [expandFun, hn])
  have hg : g w.reduceOption ≠ 0 := by
    simpa [expandFun, hlen] using hw
  apply Finset.mem_biUnion.mpr
  refine ⟨w.reduceOption, Finsupp.mem_support_iff.mpr hg, ?_⟩
  apply List.mem_toFinset.mpr
  apply List.mem_permutations.mpr
  simpa [hlen] using perm_pad w

noncomputable def expandFinsupp (n : ℕ) (g : List A →₀ R) :
    List (Option A) →₀ R :=
  Finsupp.ofSupportFinite (expandFun n g) (expandFun_finite n g)

@[simp] theorem expandFinsupp_apply (n : ℕ) (g : List A →₀ R)
    (w : List (Option A)) :
    expandFinsupp n g w = if w.length = n then g w.reduceOption else 0 := by
  rfl

theorem expand_signed {parity : A → Bool} {g : List A → R}
    (hg : Signed parity g) (n : ℕ) :
    Signed (unitParity parity) (expandFun n g) := by
  intro pre a b post
  have hlen : (pre ++ a :: b :: post).length =
      (pre ++ b :: a :: post).length := by simp
  by_cases hn : (pre ++ a :: b :: post).length = n
  · have hn' : (pre ++ b :: a :: post).length = n := hlen.symm.trans hn
    simp only [expandFun, if_pos hn, if_pos hn']
    cases a with
    | none =>
      cases b <;> simp [koszulSign, unitParity, List.reduceOption_append]
    | some a =>
      cases b with
      | none => simp [koszulSign, unitParity, List.reduceOption_append]
      | some b =>
        simpa [koszulSign, unitParity, List.reduceOption_append] using
          hg pre.reduceOption a b post.reduceOption
  · have hn' : (pre ++ b :: a :: post).length ≠ n := by omega
    simp only [expandFun, if_neg hn, if_neg hn', mul_zero]

noncomputable def extend (parity : A → Bool) (n : ℕ) :
    OccupiedInvariants (R := R) parity n →ₗ[R]
      TensorInvariants (R := R) parity n where
  toFun g := ⟨expandFinsupp n g.val, by
    refine ⟨?_, ?_⟩
    · intro w hw
      simp [hw]
    · exact expand_signed g.property.2 n⟩
  map_add' := by
    intro g h
    apply Subtype.ext
    ext w
    by_cases hw : w.length = n <;> simp [hw]
  map_smul' := by
    intro c g
    apply Subtype.ext
    ext w
    by_cases hw : w.length = n <;> simp [hw]

@[simp] theorem extend_apply (parity : A → Bool) (n : ℕ)
    (g : OccupiedInvariants (R := R) parity n) (w : List (Option A)) :
    (extend parity n g).val w =
      if w.length = n then g.val w.reduceOption else 0 := by rfl

theorem restrict_signed {parity : A → Bool} {f : List (Option A) → R}
    (hf : Signed (unitParity parity) f) (n : ℕ) :
    Signed parity (fun v => f (pad n v)) := by
  intro pre a b post
  simpa [pad, List.map_append, List.append_assoc, koszulSign, unitParity] using
    hf (pre.map some) (some a) (some b)
      (post.map some ++
        List.replicate (n - (pre ++ a :: b :: post).length) none)

noncomputable def restrict (parity : A → Bool) (n : ℕ) :
    TensorInvariants (R := R) parity n →ₗ[R]
      OccupiedInvariants (R := R) parity n where
  toFun f := ⟨Finsupp.comapDomain (pad n) f.val (pad_injective n).injOn, by
    refine ⟨?_, ?_⟩
    · intro v hv
      change f.val (pad n v) = 0
      apply f.property.1
      simp only [pad, List.length_append, List.length_map, List.length_replicate]
      omega
    · exact restrict_signed f.property.2 n⟩
  map_add' := by
    intro f g
    apply Subtype.ext
    ext v
    simp [Finsupp.comapDomain_apply]
  map_smul' := by
    intro c f
    apply Subtype.ext
    ext v
    simp [Finsupp.comapDomain_apply]

@[simp] theorem restrict_apply (parity : A → Bool) (n : ℕ)
    (f : TensorInvariants (R := R) parity n) (v : List A) :
    (restrict parity n f).val v = f.val (pad n v) := by rfl

theorem restrict_extend (parity : A → Bool) (n : ℕ)
    (g : OccupiedInvariants (R := R) parity n) :
    restrict parity n (extend parity n g) = g := by
  apply Subtype.ext
  ext v
  by_cases hv : v.length ≤ n
  · simp [length_pad n v hv]
  · have hpad : (pad n v).length ≠ n := by
      simp only [pad, List.length_append, List.length_map, List.length_replicate]
      omega
    simp [hpad, g.property.1 v hv]

theorem extend_restrict (parity : A → Bool) (n : ℕ)
    (f : TensorInvariants (R := R) parity n) :
    extend parity n (restrict parity n f) = f := by
  apply Subtype.ext
  ext w
  by_cases hw : w.length = n
  · simp only [extend_apply, if_pos hw, restrict_apply]
    simpa [hw] using (signed_determined_by_occupied f.property.2 w).symm
  · simp [hw, f.property.1 w hw]

noncomputable def occupiedEquiv (parity : A → Bool) (n : ℕ) :
    TensorInvariants (R := R) parity n ≃ₗ[R]
      OccupiedInvariants (R := R) parity n where
  toFun := restrict parity n
  invFun := extend parity n
  left_inv := extend_restrict parity n
  right_inv := restrict_extend parity n
  map_add' := (restrict parity n).map_add
  map_smul' := (restrict parity n).map_smul

def selectLengths (keep : ℕ → Prop) [DecidablePred keep] (g : List A →₀ R) :
    List A →₀ R :=
  g.filter (fun v => keep v.length)

@[simp] theorem selectLengths_apply (keep : ℕ → Prop) [DecidablePred keep]
    (g : List A →₀ R)
    (v : List A) :
    selectLengths keep g v = if keep v.length then g v else 0 := by
  exact Finsupp.filter_apply _ _ _

theorem selectLengths_signed {parity : A → Bool} {g : List A →₀ R}
    (hg : Signed parity g) (keep : ℕ → Prop) [DecidablePred keep] :
    Signed parity (selectLengths keep g) := by
  intro pre a b post
  have hlen : (pre ++ a :: b :: post).length =
      (pre ++ b :: a :: post).length := by simp
  simp only [selectLengths_apply, ← hlen]
  by_cases hk : keep (pre ++ a :: b :: post).length
  · simp only [if_pos hk]
    exact hg pre a b post
  · simp only [if_neg hk, mul_zero]

noncomputable def truncate (parity : A → Bool) (n : ℕ) :
    OccupiedInvariants (R := R) parity (n + 1) →ₗ[R]
      OccupiedInvariants (R := R) parity n where
  toFun g := ⟨selectLengths (· ≤ n) g.val, by
    refine ⟨?_, selectLengths_signed g.property.2 _⟩
    intro v hv
    simp [hv]⟩
  map_add' := by
    intro g h
    apply Subtype.ext
    ext v
    by_cases hv : v.length ≤ n <;> simp [hv]
  map_smul' := by
    intro c g
    apply Subtype.ext
    ext v
    by_cases hv : v.length ≤ n <;> simp [hv]

@[simp] theorem truncate_apply (parity : A → Bool) (n : ℕ)
    (g : OccupiedInvariants (R := R) parity (n + 1)) (v : List A) :
    (truncate parity n g).val v = if v.length ≤ n then g.val v else 0 := by
  exact selectLengths_apply (· ≤ n) g.val v

theorem append_unit_injective :
    Function.Injective (fun w : List (Option A) => w ++ [none]) := by
  intro v w h
  exact List.append_cancel_right h

noncomputable def augment (parity : A → Bool) (n : ℕ) :
    TensorInvariants (R := R) parity (n + 1) →ₗ[R]
      TensorInvariants (R := R) parity n where
  toFun f := ⟨Finsupp.comapDomain (fun w => w ++ [none]) f.val
    append_unit_injective.injOn, by
    refine ⟨?_, ?_⟩
    · intro w hw
      change f.val (w ++ [none]) = 0
      apply f.property.1
      simp only [List.length_append, List.length_singleton]
      omega
    · intro pre a b post
      change f.val ((pre ++ a :: b :: post) ++ [none]) =
        koszulSign (unitParity parity) a b *
          f.val ((pre ++ b :: a :: post) ++ [none])
      simpa only [List.append_assoc, List.cons_append] using
        f.property.2 pre a b (post ++ [none])⟩
  map_add' := by
    intro f g
    apply Subtype.ext
    ext w
    simp [Finsupp.comapDomain_apply]
  map_smul' := by
    intro c f
    apply Subtype.ext
    ext w
    simp [Finsupp.comapDomain_apply]

@[simp] theorem augment_apply (parity : A → Bool) (n : ℕ)
    (f : TensorInvariants (R := R) parity (n + 1)) (w : List (Option A)) :
    (augment parity n f).val w = f.val (w ++ [none]) := by rfl

theorem pad_succ (n : ℕ) (v : List A) (hv : v.length ≤ n) :
    pad (n + 1) v = pad n v ++ [none] := by
  have he : n + 1 - v.length = (n - v.length) + 1 := by omega
  simp [pad, he, List.replicate_succ', List.append_assoc]

theorem restriction_augmentation (parity : A → Bool) (n : ℕ)
    (f : TensorInvariants (R := R) parity (n + 1)) :
    restrict parity n (augment parity n f) =
      truncate parity n (restrict parity (n + 1) f) := by
  classical
  apply Subtype.ext
  ext v
  by_cases hv : v.length ≤ n
  · simp only [restrict_apply, augment_apply, truncate_apply, if_pos hv]
    rw [pad_succ n v hv]
  · have hz := (restrict parity n (augment parity n f)).property.1 v hv
    simpa only [truncate_apply, if_neg hv] using hz

theorem augmentation_extension (parity : A → Bool) (n : ℕ)
    (g : OccupiedInvariants (R := R) parity (n + 1)) :
    augment parity n (extend parity (n + 1) g) =
      extend parity n (truncate parity n g) := by
  apply (occupiedEquiv parity n).injective
  change restrict parity n (augment parity n (extend parity (n + 1) g)) =
    restrict parity n (extend parity n (truncate parity n g))
  rw [restriction_augmentation, restrict_extend, restrict_extend]

noncomputable def includeOccupied (parity : A → Bool) (n : ℕ) :
    OccupiedInvariants (R := R) parity n →ₗ[R]
      OccupiedInvariants (R := R) parity (n + 1) where
  toFun g := ⟨g.val, by
    refine ⟨?_, g.property.2⟩
    intro v hv
    exact g.property.1 v (by omega)⟩
  map_add' := by intros; rfl
  map_smul' := by intros; rfl

@[simp] theorem includeOccupied_apply (parity : A → Bool) (n : ℕ)
    (g : OccupiedInvariants (R := R) parity n) (v : List A) :
    (includeOccupied parity n g).val v = g.val v := by rfl

theorem truncate_include (parity : A → Bool) (n : ℕ)
    (g : OccupiedInvariants (R := R) parity n) :
    truncate parity n (includeOccupied parity n g) = g := by
  classical
  apply Subtype.ext
  ext v
  by_cases hv : v.length ≤ n <;> simp [hv, g.property.1 v]

noncomputable def augmentSection (parity : A → Bool) (n : ℕ) :
    TensorInvariants (R := R) parity n →ₗ[R]
      TensorInvariants (R := R) parity (n + 1) :=
  (extend parity (n + 1)).comp
    ((includeOccupied parity n).comp (restrict parity n))

theorem augment_section (parity : A → Bool) (n : ℕ)
    (f : TensorInvariants (R := R) parity n) :
    augment parity n (augmentSection parity n f) = f := by
  change augment parity n
    (extend parity (n + 1) (includeOccupied parity n (restrict parity n f))) = f
  rw [augmentation_extension, truncate_include, extend_restrict]

theorem augmentation_surjective (parity : A → Bool) (n : ℕ) :
    Function.Surjective (augment (R := R) parity n) :=
  fun f => ⟨augmentSection parity n f, augment_section parity n f⟩

noncomputable def pureToOccupied (parity : A → Bool) (n r : ℕ) (hr : r ≤ n) :
    PureInvariants (R := R) parity r →ₗ[R]
      OccupiedInvariants (R := R) parity n where
  toFun g := ⟨g.val, by
    refine ⟨?_, g.property.2⟩
    intro v hv
    apply g.property.1
    omega⟩
  map_add' := by intros; rfl
  map_smul' := by intros; rfl

@[simp] theorem pureToOccupied_apply (parity : A → Bool) (n r : ℕ)
    (hr : r ≤ n) (g : PureInvariants (R := R) parity r) (v : List A) :
    (pureToOccupied parity n r hr g).val v = g.val v := by rfl

noncomputable def homogeneousPart (parity : A → Bool) (n r : ℕ) :
    OccupiedInvariants (R := R) parity n →ₗ[R]
      PureInvariants (R := R) parity r where
  toFun g := ⟨selectLengths (· = r) g.val, by
    refine ⟨?_, selectLengths_signed g.property.2 _⟩
    intro v hv
    simp [hv]⟩
  map_add' := by
    intro g h
    apply Subtype.ext
    ext v
    by_cases hv : v.length = r <;> simp [hv]
  map_smul' := by
    intro c g
    apply Subtype.ext
    ext v
    by_cases hv : v.length = r <;> simp [hv]

@[simp] theorem homogeneousPart_apply (parity : A → Bool) (n r : ℕ)
    (g : OccupiedInvariants (R := R) parity n) (v : List A) :
    (homogeneousPart parity n r g).val v =
      if v.length = r then g.val v else 0 := by
  exact selectLengths_apply (· = r) g.val v

abbrev Occupations (parity : A → Bool) (n : ℕ) :=
  (r : Fin (n + 1)) → PureInvariants (R := R) parity r.val

noncomputable def decompose (parity : A → Bool) (n : ℕ) :
    OccupiedInvariants (R := R) parity n →ₗ[R] Occupations (R := R) parity n where
  toFun g r := homogeneousPart parity n r.val g
  map_add' := by
    intro g h
    funext r
    exact (homogeneousPart parity n r.val).map_add g h
  map_smul' := by
    intro c g
    funext r
    exact (homogeneousPart parity n r.val).map_smul c g

@[simp] theorem decompose_apply (parity : A → Bool) (n : ℕ)
    (g : OccupiedInvariants (R := R) parity n) (r : Fin (n + 1)) :
    decompose parity n g r = homogeneousPart parity n r.val g := by rfl

noncomputable def assemble (parity : A → Bool) (n : ℕ) :
    Occupations (R := R) parity n →ₗ[R] OccupiedInvariants (R := R) parity n where
  toFun h := ∑ r : Fin (n + 1),
    pureToOccupied parity n r.val (Nat.le_of_lt_succ r.isLt) (h r)
  map_add' := by
    intro h k
    simp only [Pi.add_apply, map_add, Finset.sum_add_distrib]
  map_smul' := by
    intro c h
    simp only [Pi.smul_apply, map_smul, Finset.smul_sum, RingHom.id_apply]

@[simp] theorem assemble_apply (parity : A → Bool) (n : ℕ)
    (h : Occupations (R := R) parity n) (v : List A) :
    (assemble parity n h).val v = ∑ r : Fin (n + 1), (h r).val v := by
  simp [assemble]

theorem decompose_assemble (parity : A → Bool) (n : ℕ)
    (h : Occupations (R := R) parity n) :
    decompose parity n (assemble parity n h) = h := by
  funext r
  apply Subtype.ext
  ext v
  simp only [decompose_apply, homogeneousPart_apply, assemble_apply]
  by_cases hv : v.length = r.val
  · rw [if_pos hv]
    apply Finset.sum_eq_single r
    · intro s hs hsr
      apply (h s).property.1
      intro he
      apply hsr
      apply Fin.ext
      omega
    · simp
  · rw [if_neg hv, (h r).property.1 v hv]

theorem assemble_decompose (parity : A → Bool) (n : ℕ)
    (g : OccupiedInvariants (R := R) parity n) :
    assemble parity n (decompose parity n g) = g := by
  apply Subtype.ext
  ext v
  simp only [assemble_apply, decompose_apply, homogeneousPart_apply]
  by_cases hv : v.length ≤ n
  · let r : Fin (n + 1) := ⟨v.length, Nat.lt_succ_of_le hv⟩
    have hsum :
        (∑ s : Fin (n + 1), if v.length = s.val then g.val v else 0) =
          (if v.length = r.val then g.val v else 0) := by
      apply Finset.sum_eq_single r
      · intro s hs hsr
        have he : v.length ≠ s.val := by
          intro he
          apply hsr
          apply Fin.ext
          exact he.symm
        simp only [if_neg he]
      · simp
    simpa [r] using hsum
  · simp [g.property.1 v hv]

noncomputable def gradedEquiv (parity : A → Bool) (n : ℕ) :
    OccupiedInvariants (R := R) parity n ≃ₗ[R] Occupations (R := R) parity n where
  toFun := decompose parity n
  invFun := assemble parity n
  left_inv := assemble_decompose parity n
  right_inv := decompose_assemble parity n
  map_add' := (decompose parity n).map_add
  map_smul' := (decompose parity n).map_smul

noncomputable def splitEquiv (parity : A → Bool) (n : ℕ) :
    TensorInvariants (R := R) parity n ≃ₗ[R] Occupations (R := R) parity n :=
  (occupiedEquiv parity n).trans (gradedEquiv parity n)

@[simp] theorem splitEquiv_apply (parity : A → Bool) (n : ℕ)
    (f : TensorInvariants (R := R) parity n) (r : Fin (n + 1)) (v : List A) :
    (splitEquiv parity n f r).val v =
      if v.length = r.val then f.val (pad n v) else 0 := by
  change (homogeneousPart parity n r.val (restrict parity n f)).val v = _
  simp

def dropLast (parity : A → Bool) (n : ℕ) :
    Occupations (R := R) parity (n + 1) →ₗ[R] Occupations (R := R) parity n where
  toFun h r := h r.castSucc
  map_add' := by intros; rfl
  map_smul' := by intros; rfl

@[simp] theorem dropLast_apply (parity : A → Bool) (n : ℕ)
    (h : Occupations (R := R) parity (n + 1)) (r : Fin (n + 1)) :
    dropLast parity n h r = h r.castSucc := by rfl

theorem split_augmentation (parity : A → Bool) (n : ℕ)
    (f : TensorInvariants (R := R) parity (n + 1)) :
    splitEquiv parity n (augment parity n f) =
      dropLast parity n (splitEquiv parity (n + 1) f) := by
  change decompose parity n (restrict parity n (augment parity n f)) =
    dropLast parity n (decompose parity (n + 1) (restrict parity (n + 1) f))
  rw [restriction_augmentation]
  funext r
  apply Subtype.ext
  ext v
  change (homogeneousPart parity n r.val
      (truncate parity n (restrict parity (n + 1) f))).val v =
    (homogeneousPart parity (n + 1) r.val (restrict parity (n + 1) f)).val v
  simp only [homogeneousPart_apply, truncate_apply]
  by_cases hv : v.length = r.val
  · have hvn : v.length ≤ n := by have := r.isLt; omega
    simp only [if_pos hv, if_pos hvn]
  · simp only [if_neg hv]

noncomputable def tensorDirectSumEquiv (parity : A → Bool) (n : ℕ) :
    TensorInvariants (R := R) parity n ≃ₗ[R]
      DirectSum (Fin (n + 1))
        (fun r => PureInvariants (R := R) parity r.val) :=
  (splitEquiv parity n).trans
    (DirectSum.linearEquivFunOnFintype R (Fin (n + 1))
      (fun r => PureInvariants (R := R) parity r.val)).symm

theorem truncate_pure (parity : A → Bool) (n r : ℕ) (hr : r ≤ n)
    (g : PureInvariants (R := R) parity r) :
    truncate parity n
      (pureToOccupied parity (n + 1) r (by omega) g) =
        pureToOccupied parity n r hr g := by
  apply Subtype.ext
  ext v
  by_cases hv : v.length ≤ n
  · simp [hv]
  · have he : v.length ≠ r := by omega
    simp [hv, g.property.1 v he]

theorem augment_lower_summand (parity : A → Bool) (n r : ℕ) (hr : r ≤ n)
    (g : PureInvariants (R := R) parity r) :
    augment parity n
      (extend parity (n + 1)
        (pureToOccupied parity (n + 1) r (by omega) g)) =
      extend parity n (pureToOccupied parity n r hr g) := by
  rw [augmentation_extension, truncate_pure parity n r hr]

theorem truncate_top (parity : A → Bool) (n : ℕ)
    (g : PureInvariants (R := R) parity (n + 1)) :
    truncate parity n
      (pureToOccupied parity (n + 1) (n + 1) le_rfl g) = 0 := by
  apply Subtype.ext
  ext v
  by_cases hv : v.length ≤ n
  · have he : v.length ≠ n + 1 := by omega
    simp [hv, g.property.1 v he]
  · simp [hv]

noncomputable def topInclusion (parity : A → Bool) (n : ℕ) :
    PureInvariants (R := R) parity (n + 1) →ₗ[R]
      TensorInvariants (R := R) parity (n + 1) :=
  (extend parity (n + 1)).comp
    (pureToOccupied parity (n + 1) (n + 1) le_rfl)

theorem augment_top (parity : A → Bool) (n : ℕ)
    (g : PureInvariants (R := R) parity (n + 1)) :
    augment parity n (topInclusion parity n g) = 0 := by
  change augment parity n
    (extend parity (n + 1)
      (pureToOccupied parity (n + 1) (n + 1) le_rfl g)) = 0
  rw [augmentation_extension, truncate_top, map_zero]

theorem homogeneousPart_pure (parity : A → Bool) (n r : ℕ) (hr : r ≤ n)
    (g : PureInvariants (R := R) parity r) :
    homogeneousPart parity n r (pureToOccupied parity n r hr g) = g := by
  apply Subtype.ext
  ext v
  by_cases hv : v.length = r
  · simp [hv]
  · simp [hv, g.property.1 v hv]

theorem top_part_of_truncate_zero (parity : A → Bool) (n : ℕ)
    (g : OccupiedInvariants (R := R) parity (n + 1))
    (hg : truncate parity n g = 0) :
    pureToOccupied parity (n + 1) (n + 1) le_rfl
      (homogeneousPart parity (n + 1) (n + 1) g) = g := by
  apply Subtype.ext
  ext v
  by_cases hv : v.length = n + 1
  · simp [hv]
  · have hz : g.val v = 0 := by
      by_cases hvn : v.length ≤ n
      · have he := congrArg
          (fun h : OccupiedInvariants (R := R) parity n => h.val v) hg
        simpa [hvn] using he
      · exact g.property.1 v (by omega)
    simp [hv, hz]

noncomputable def augmentationKernelEquiv (parity : A → Bool) (n : ℕ) :
    (augment (R := R) parity n).ker ≃ₗ[R]
      PureInvariants (R := R) parity (n + 1) where
  toFun f := homogeneousPart parity (n + 1) (n + 1)
    (restrict parity (n + 1) f.val)
  invFun g := ⟨topInclusion parity n g, augment_top parity n g⟩
  left_inv := by
    intro f
    apply Subtype.ext
    change extend parity (n + 1)
      (pureToOccupied parity (n + 1) (n + 1) le_rfl
        (homogeneousPart parity (n + 1) (n + 1)
          (restrict parity (n + 1) f.val))) = f.val
    have hz : truncate parity n (restrict parity (n + 1) f.val) = 0 := by
      rw [← restriction_augmentation, LinearMap.mem_ker.mp f.property, map_zero]
    rw [top_part_of_truncate_zero parity n _ hz, extend_restrict]
  right_inv := by
    intro g
    change homogeneousPart parity (n + 1) (n + 1)
      (restrict parity (n + 1)
        (extend parity (n + 1)
          (pureToOccupied parity (n + 1) (n + 1) le_rfl g))) = g
    rw [restrict_extend, homogeneousPart_pure]
  map_add' := by
    intro f g
    change homogeneousPart parity (n + 1) (n + 1)
        (restrict parity (n + 1) (f.val + g.val)) = _
    rw [map_add, map_add]
  map_smul' := by
    intro c f
    change homogeneousPart parity (n + 1) (n + 1)
        (restrict parity (n + 1) (c • f.val)) = _
    rw [map_smul, map_smul]
    rfl

theorem augmentation_kernel_iff (parity : A → Bool) (n : ℕ)
    (f : TensorInvariants (R := R) parity (n + 1)) :
    augment parity n f = 0 ↔
      ∃ g : PureInvariants (R := R) parity (n + 1),
        topInclusion parity n g = f := by
  constructor
  · intro hf
    let k : (augment (R := R) parity n).ker := ⟨f, hf⟩
    refine ⟨augmentationKernelEquiv parity n k, ?_⟩
    exact congrArg Subtype.val
      ((augmentationKernelEquiv parity n).symm_apply_apply k)
  · rintro ⟨g, rfl⟩
    exact augment_top parity n g

#print axioms signed_permutation_invariance
#print axioms tensorDirectSumEquiv
#print axioms split_augmentation
#print axioms augment_lower_summand
#print axioms augment_top
#print axioms augmentationKernelEquiv
#print axioms augment_section

end UniformConnectivity
