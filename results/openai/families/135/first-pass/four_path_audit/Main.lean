import Mathlib

open scoped BigOperators

namespace FourPathAudit

abbrev Labels (w : ℕ) := (Fin w × Fin w) × (Fin w × Fin w)

def paired (a : Bool) {w : ℕ} (x : Labels w) : Prop :=
  if a then x.1.1 = x.2.1 ∧ x.1.2 = x.2.2
  else x.1.1 = x.1.2 ∧ x.2.1 = x.2.2

abbrev Vertex (w : ℕ) (a b : Bool) :=
  {x : Labels w // paired a x ∧ paired b x}

instance (w : ℕ) (a : Bool) (x : Labels w) : Decidable (paired a x) := by
  unfold paired
  infer_instance

def vertexSwap (w : ℕ) (a b : Bool) : Vertex w a b ≃ Vertex w b a where
  toFun x := ⟨x.1, x.2.symm⟩
  invFun x := ⟨x.1, x.2.symm⟩
  left_inv _ := rfl
  right_inv _ := rfl

def nnEquiv (w : ℕ) : Vertex w false false ≃ Fin w × Fin w where
  toFun x := (x.1.1.1, x.1.2.1)
  invFun x := ⟨((x.1, x.1), (x.2, x.2)), by simp [paired]⟩
  left_inv := by
    rintro ⟨⟨⟨p, q⟩, ⟨r, s⟩⟩, h⟩
    apply Subtype.ext
    change (p = q ∧ r = s) ∧ (p = q ∧ r = s) at h
    rcases h.1 with ⟨rfl, rfl⟩
    rfl
  right_inv _ := rfl

def ddEquiv (w : ℕ) : Vertex w true true ≃ Fin w × Fin w where
  toFun x := x.1.1
  invFun x := ⟨(x, x), by simp [paired]⟩
  left_inv := by
    rintro ⟨⟨⟨p, q⟩, ⟨r, s⟩⟩, h⟩
    apply Subtype.ext
    change (p = r ∧ q = s) ∧ (p = r ∧ q = s) at h
    rcases h.1 with ⟨rfl, rfl⟩
    rfl
  right_inv _ := rfl

def ndEquiv (w : ℕ) : Vertex w false true ≃ Fin w where
  toFun x := x.1.1.1
  invFun x := ⟨((x, x), (x, x)), by simp [paired]⟩
  left_inv := by
    rintro ⟨⟨⟨p, q⟩, ⟨r, s⟩⟩, h⟩
    apply Subtype.ext
    change (p = q ∧ r = s) ∧ (p = r ∧ q = s) at h
    rcases h with ⟨⟨hpq, hrs⟩, ⟨hpr, hqs⟩⟩
    subst q
    subst r
    subst s
    rfl
  right_inv _ := rfl

theorem vertex_card (w : ℕ) (a b : Bool) :
    Fintype.card (Vertex w a b) = if a = b then w ^ 2 else w := by
  cases a <;> cases b
  · simpa [pow_two] using Fintype.card_congr (nnEquiv w)
  · simpa using Fintype.card_congr (ndEquiv w)
  · simpa using Fintype.card_congr ((vertexSwap w true false).trans (ndEquiv w))
  · simpa [pow_two] using Fintype.card_congr (ddEquiv w)

abbrev Assignments (w : ℕ) {n : ℕ} (tau : Fin (n + 1) → Bool) :=
  (j : Fin n) → Vertex w (tau j.castSucc) (tau j.succ)

def switches {n : ℕ} (tau : Fin (n + 1) → Bool) : ℕ :=
  ∑ j : Fin n, if tau j.castSucc = tau j.succ then 0 else 1

theorem exponent_identity {n : ℕ} (tau : Fin (n + 1) → Bool) :
    (∑ j : Fin n, if tau j.castSucc = tau j.succ then 2 else 1) =
      2 * n - switches tau := by
  have h : (∑ j : Fin n, if tau j.castSucc = tau j.succ then 2 else 1) +
      switches tau = 2 * n := by
    unfold switches
    rw [← Finset.sum_add_distrib]
    calc
      _ = ∑ _j : Fin n, 2 := by
        apply Finset.sum_congr rfl
        intro j _
        split_ifs <;> rfl
      _ = 2 * n := by simp [Nat.mul_comm]
  omega

theorem relaxed_assignment_count (w : ℕ) {n : ℕ} (tau : Fin (n + 1) → Bool) :
    Fintype.card (Assignments w tau) = w ^ (2 * n - switches tau) := by
  rw [Fintype.card_pi]
  simp_rw [vertex_card]
  calc
    _ = ∏ j : Fin n, w ^ (if tau j.castSucc = tau j.succ then 2 else 1) := by
      apply Finset.prod_congr rfl
      intro j _
      split_ifs <;> simp
    _ = w ^ (∑ j : Fin n, if tau j.castSucc = tau j.succ then 2 else 1) :=
      Finset.prod_pow_eq_pow_sum _ _ _
    _ = w ^ (2 * n - switches tau) := by rw [exponent_identity]

def endpoint (w : ℕ) (hw : 0 < w) : Labels w :=
  let z : Fin w := ⟨0, hw⟩
  ((z, z), (z, z))

def assemble {w n : ℕ} (hw : 0 < w) {tau : Fin (n + 1) → Bool}
    (x : Assignments w tau) : Fin (n + 2) → Labels w :=
  Fin.cases (endpoint w hw) (Fin.lastCases (endpoint w hw) (fun j => (x j).1))

theorem assemble_internal {w n : ℕ} (hw : 0 < w)
    {tau : Fin (n + 1) → Bool} (x : Assignments w tau) (j : Fin n) :
    assemble hw x j.castSucc.succ = (x j).1 := by
  simp [assemble]

theorem assemble_last {w n : ℕ} (hw : 0 < w)
    {tau : Fin (n + 1) → Bool} (x : Assignments w tau) :
    assemble hw x (Fin.last (n + 1)) = endpoint w hw := by
  change assemble hw x (Fin.last n).succ = _
  simp only [assemble, Fin.cases_succ, Fin.lastCases_last]

abbrev FixedQuadruples (w n : ℕ) (hw : 0 < w) (tau : Fin (n + 1) → Bool) :=
  {q : Fin (n + 2) → Labels w //
    q 0 = endpoint w hw ∧ q (Fin.last (n + 1)) = endpoint w hw ∧
      ∀ t, paired (tau t) (q t.castSucc) ∧ paired (tau t) (q t.succ)}

noncomputable instance (w n : ℕ) (hw : 0 < w) (tau : Fin (n + 1) → Bool) :
    Fintype (FixedQuadruples w n hw tau) := by
  classical
  unfold FixedQuadruples
  infer_instance

theorem assemble_valid {w n : ℕ} (hw : 0 < w)
    {tau : Fin (n + 1) → Bool} (x : Assignments w tau) :
    assemble hw x 0 = endpoint w hw ∧
    assemble hw x (Fin.last (n + 1)) = endpoint w hw ∧
    ∀ t, paired (tau t) (assemble hw x t.castSucc) ∧
      paired (tau t) (assemble hw x t.succ) := by
  constructor
  · simp [assemble]
  constructor
  · exact assemble_last hw x
  intro t
  constructor
  · refine Fin.cases ?_ (fun j => ?_) t
    · simp [assemble, endpoint, paired]
    · change paired (tau j.succ) (assemble hw x j.castSucc.succ)
      rw [assemble_internal]
      exact (x j).2.2
  · refine Fin.lastCases ?_ (fun j => ?_) t
    · change paired (tau (Fin.last n)) (assemble hw x (Fin.last (n + 1)))
      rw [assemble_last]
      simp [endpoint, paired]
    · rw [assemble_internal]
      exact (x j).2.1

def fixedQuadruplesEquiv {w n : ℕ} (hw : 0 < w) (tau : Fin (n + 1) → Bool) :
    FixedQuadruples w n hw tau ≃ Assignments w tau where
  toFun q j := ⟨q.1 j.castSucc.succ, by
    constructor
    · exact (q.2.2.2 j.castSucc).2
    · exact (q.2.2.2 j.succ).1⟩
  invFun x := ⟨assemble hw x, assemble_valid hw x⟩
  left_inv q := by
    apply Subtype.ext
    funext j
    refine Fin.cases ?_ (fun t => ?_) j
    · simpa [assemble] using q.2.1.symm
    · refine Fin.lastCases ?_ (fun i => ?_) t
      · change assemble hw _ (Fin.last (n + 1)) = q.1 (Fin.last (n + 1))
        rw [assemble_last]
        exact q.2.2.1.symm
      · simp [assemble]
  right_inv x := by
    funext j
    apply Subtype.ext
    exact assemble_internal hw x j

theorem fixed_quadruple_count {w n : ℕ} (hw : 0 < w) (tau : Fin (n + 1) → Bool) :
    Fintype.card (FixedQuadruples w n hw tau) = w ^ (2 * n - switches tau) := by
  rw [Fintype.card_congr (fixedQuadruplesEquiv hw tau)]
  exact relaxed_assignment_count w tau

def average {X : Type*} [Fintype X] (f : X → ℚ) : ℚ :=
  (∑ x, f x) / Fintype.card X

theorem average_equiv {X Y : Type*} [Fintype X] [Fintype Y]
    (e : X ≃ Y) (f : Y → ℚ) :
    average (fun x => f (e x)) = average f := by
  simp only [average, e.sum_comp, Fintype.card_congr e]

theorem average_pi {I : Type*} [Fintype I] [DecidableEq I]
    (X : I → Type*) [∀ i, Fintype (X i)] (f : ∀ i, X i → ℚ) :
    average (fun x : ∀ i, X i => ∏ i, f i (x i)) =
      ∏ i, average (f i) := by
  simp only [average, ← Fintype.prod_sum, Fintype.card_pi, Nat.cast_prod,
    Finset.prod_div_distrib]

def diagonalEquiv {J : Type*} (w : ℕ) :
    {x : J → Fin w × Fin w // ∀ j, (x j).1 = (x j).2} ≃ (J → Fin w) where
  toFun x j := (x.1 j).1
  invFun x := ⟨fun j => (x j, x j), fun _ => rfl⟩
  left_inv x := by
    apply Subtype.ext
    funext j
    exact Prod.ext rfl (x.2 j)
  right_inv _ := rfl

theorem diagonal_sum {J : Type*} [Fintype J] [DecidableEq J] (w : ℕ) :
    (∑ x : J → Fin w × Fin w,
      if ∀ j, (x j).1 = (x j).2 then (1 : ℚ) else 0) =
      (w : ℚ) ^ Fintype.card J := by
  classical
  have hcard := Fintype.card_congr (diagonalEquiv (J := J) w)
  have hs : (∑ x : J → Fin w × Fin w,
      if ∀ j, (x j).1 = (x j).2 then (1 : ℚ) else 0) =
      (Fintype.card {x : J → Fin w × Fin w // ∀ j, (x j).1 = (x j).2} : ℚ) := by
    simp [Fintype.card_subtype]
  rw [hs, hcard]
  simp

theorem diagonal_block_average {J : Type*} [Fintype J] [DecidableEq J]
    (w : ℕ) (hw : 0 < w) (c : ℚ) :
    average (fun x : J → Fin w × Fin w =>
      1 + c * (if ∀ j, (x j).1 = (x j).2 then 1 else 0)) =
      1 + c / (w : ℚ) ^ Fintype.card J := by
  classical
  have hwq : (w : ℚ) ≠ 0 := by exact_mod_cast (ne_of_gt hw)
  simp only [average, Finset.sum_add_distrib, ← Finset.mul_sum, diagonal_sum,
    Finset.sum_const, Finset.card_univ, nsmul_eq_mul, mul_one, Fintype.card_fun,
    Fintype.card_prod, Fintype.card_fin, Nat.cast_pow, Nat.cast_mul]
  rw [mul_pow]
  field_simp

def regroup {I J X : Type*} (owner : J → I) :
    (J → X) ≃ ((i : I) → {j : J // owner j = i} → X) where
  toFun x _ j := x j.1
  invFun x j := x (owner j) ⟨j, rfl⟩
  left_inv _ := rfl
  right_inv x := by
    funext i j
    rcases j with ⟨j, h⟩
    cases h
    rfl

theorem owner_factorization {I J : Type*} [Fintype I] [DecidableEq I]
    [Fintype J] [DecidableEq J]
    (owner : J → I) (w : ℕ) (hw : 0 < w) (c : I → ℚ) :
    average (fun x : J → Fin w × Fin w =>
      ∏ i, (1 + c i * (if ∀ j : {j // owner j = i},
        (x j.1).1 = (x j.1).2 then 1 else 0))) =
      ∏ i, (1 + c i / (w : ℚ) ^ Fintype.card {j // owner j = i}) := by
  classical
  let f := fun (i : I) (x : {j // owner j = i} → Fin w × Fin w) =>
    1 + c i * (if ∀ j, (x j).1 = (x j).2 then 1 else 0)
  change average (fun x => (fun y => ∏ i, f i (y i)) (regroup owner x)) = _
  rw [average_equiv (regroup (X := Fin w × Fin w) owner) (fun y => ∏ i, f i (y i))]
  rw [average_pi]
  apply Finset.prod_congr rfl
  intro i _
  exact diagonal_block_average w hw (c i)

noncomputable def chooseOwner {I J : Type*} (s : I → Finset J) (j : J) : Option I := by
  classical
  exact if h : ∃ i, j ∈ s i then some h.choose else none

theorem chooseOwner_iff {I J : Type*} (s : I → Finset J)
    (hs : Pairwise fun i j => Disjoint (s i) (s j)) (j : J) (i : I) :
    chooseOwner s j = some i ↔ j ∈ s i := by
  classical
  by_cases h : ∃ i, j ∈ s i
  · rw [chooseOwner, dif_pos h]
    constructor
    · intro hi
      have heq : h.choose = i := Option.some.inj hi
      simpa [heq] using h.choose_spec
    · intro hj
      have heq : h.choose = i := by
        by_contra hne
        exact (Finset.disjoint_left.mp (hs hne)) h.choose_spec hj
      simp [heq]
  · have hj : j ∉ s i := fun hi => h ⟨i, hi⟩
    simp [chooseOwner, h, hj]

theorem disjoint_support_factorization {I J : Type*}
    [Fintype I] [Fintype J] [DecidableEq J] (s : I → Finset J)
    (hs : Pairwise fun i j => Disjoint (s i) (s j))
    (w : ℕ) (hw : 0 < w) (c : I → ℚ) :
    average (fun x : J → Fin w × Fin w =>
      ∏ i, (1 + c i * (if ∀ j ∈ s i, (x j).1 = (x j).2 then 1 else 0))) =
      ∏ i, (1 + c i / (w : ℚ) ^ (s i).card) := by
  classical
  let owner := chooseOwner s
  let coeff : Option I → ℚ := fun i => i.elim 0 c
  have hevent (x : J → Fin w × Fin w) (i : I) :
      (∀ j : {j // owner j = some i}, (x j.1).1 = (x j.1).2) ↔
        ∀ j ∈ s i, (x j).1 = (x j).2 := by
    constructor
    · intro h j hj
      exact h ⟨j, (chooseOwner_iff s hs j i).mpr hj⟩
    · intro h j
      exact h j.1 ((chooseOwner_iff s hs j.1 i).mp j.2)
  have hcard (i : I) : Fintype.card {j // owner j = some i} = (s i).card := by
    calc
      _ = Fintype.card {j // j ∈ s i} :=
        Fintype.card_congr (Equiv.subtypeEquivRight fun j => chooseOwner_iff s hs j i)
      _ = _ := Fintype.card_coe _
  have h := owner_factorization owner w hw coeff
  simp only [Fintype.prod_option, coeff, Option.elim_none, Option.elim_some,
    zero_mul, zero_div, add_zero, one_mul] at h
  simp_rw [hevent, hcard] at h
  exact h

theorem nonadjacent_supports {J : Type*} (v : Finset ℕ)
    (hv : ∀ t ∈ v, t + 1 ∉ v) (position : J → ℕ)
    (s : {t // t ∈ v} → Finset J)
    (hends : ∀ t j, j ∈ s t → position j = t.1 ∨ position j = t.1 + 1) :
    Pairwise fun i j => Disjoint (s i) (s j) := by
  classical
  intro i j hij
  have hne : i.1 ≠ j.1 := fun h => hij (Subtype.ext h)
  have hnext : i.1 + 1 ≠ j.1 := by
    intro h
    apply hv i.1 i.2
    rw [h]
    exact j.2
  have hprev : j.1 + 1 ≠ i.1 := by
    intro h
    apply hv j.1 j.2
    rw [h]
    exact i.2
  apply Finset.disjoint_left.mpr
  intro x hxi hxj
  have hi := hends i x hxi
  have hj := hends j x hxj
  omega

theorem nonadjacent_factorization {J : Type*} [Fintype J] [DecidableEq J] (v : Finset ℕ)
    (hv : ∀ t ∈ v, t + 1 ∉ v) (position : J → ℕ)
    (s : {t // t ∈ v} → Finset J)
    (hends : ∀ t j, j ∈ s t → position j = t.1 ∨ position j = t.1 + 1)
    (w : ℕ) (hw : 0 < w) (c : {t // t ∈ v} → ℚ) :
    average (fun x : J → Fin w × Fin w =>
      ∏ t, (1 + c t * (if ∀ j ∈ s t, (x j).1 = (x j).2 then 1 else 0))) =
      ∏ t, (1 + c t / (w : ℚ) ^ (s t).card) :=
  disjoint_support_factorization s (nonadjacent_supports v hv position s hends) w hw c

def diagonal {w : ℕ} (x : Labels w) : Prop := x.1.1 = x.2.1

theorem vertex_diagonal_iff {w : ℕ} {a b : Bool} (x : Vertex w a b) :
    diagonal x.1 ↔ (a = false ∧ b = false → diagonal x.1) := by
  cases a <;> cases b
  · simp
  · have hx : diagonal x.1 := x.2.2.1
    simp [hx]
  · have hx : diagonal x.1 := x.2.1.1
    simp [hx]
  · have hx : diagonal x.1 := x.2.1.1
    simp [hx]

abbrev NNSite {n : ℕ} (tau : Fin (n + 1) → Bool) :=
  {j : Fin n // tau j.castSucc = false ∧ tau j.succ = false}

abbrev Residual (w : ℕ) {n : ℕ} (tau : Fin (n + 1) → Bool) :=
  (j : {j : Fin n // ¬(tau j.castSucc = false ∧ tau j.succ = false)}) →
    Vertex w (tau j.1.castSucc) (tau j.1.succ)

def nnSiteEquiv {w n : ℕ} (tau : Fin (n + 1) → Bool) (j : NNSite tau) :
    Vertex w (tau j.1.castSucc) (tau j.1.succ) ≃ Fin w × Fin w :=
  (Equiv.subtypeEquivRight fun _ => by simp only [j.2.1, j.2.2]).trans (nnEquiv w)

def nnSplit {w n : ℕ} (tau : Fin (n + 1) → Bool) :
    Assignments w tau ≃ (NNSite tau → Fin w × Fin w) × Residual w tau :=
  (Equiv.piEquivPiSubtypeProd
    (fun j : Fin n => tau j.castSucc = false ∧ tau j.succ = false)
    (fun j => Vertex w (tau j.castSucc) (tau j.succ))).trans
      (Equiv.prodCongr (Equiv.piCongrRight (fun j => nnSiteEquiv tau j)) (Equiv.refl _))

theorem nnSplit_quad_apply {w n : ℕ} (hw : 0 < w)
    (tau : Fin (n + 1) → Bool) (q : FixedQuadruples w n hw tau) (j : NNSite tau) :
    ((((fixedQuadruplesEquiv hw tau).trans (nnSplit tau)) q).1 j) =
      ((q.1 j.1.castSucc.succ).1.1, (q.1 j.1.castSucc.succ).2.1) := rfl

def coincidenceSupport {n : ℕ} (tau : Fin (n + 1) → Bool) (t : ℕ) :
    Finset (NNSite tau) :=
  Finset.univ.filter fun j => j.1.val + 1 = t ∨ j.1.val + 1 = t + 1

def layerCoincidence {w n : ℕ} (q : Fin (n + 2) → Labels w) (t : Fin (n + 1)) :
    Prop := diagonal (q t.castSucc) ∧ diagonal (q t.succ)

instance {w n : ℕ} (q : Fin (n + 2) → Labels w) (t : Fin (n + 1)) :
    Decidable (layerCoincidence q t) := by
  unfold layerCoincidence diagonal
  infer_instance

theorem layerCoincidence_iff {w n : ℕ} (hw : 0 < w)
    (tau : Fin (n + 1) → Bool) (q : FixedQuadruples w n hw tau) (t : Fin (n + 1)) :
    layerCoincidence q.1 t ↔
      ∀ j ∈ coincidenceSupport tau t.val, diagonal (q.1 j.1.castSucc.succ) := by
  constructor
  · intro h j hj
    have hp : j.1.val + 1 = t.val ∨ j.1.val + 1 = t.val + 1 := by
      simpa only [coincidenceSupport, Finset.mem_filter, Finset.mem_univ, true_and] using hj
    rcases hp with hp | hp
    · have heq : j.1.castSucc.succ = t.castSucc := Fin.ext hp
      rw [heq]
      exact h.1
    · have heq : j.1.castSucc.succ = t.succ := Fin.ext hp
      rw [heq]
      exact h.2
  · intro h
    constructor
    · revert h
      refine Fin.cases ?_ (fun j => ?_) t
      · intro h
        change diagonal (q.1 0)
        rw [q.2.1]
        rfl
      · intro h
        apply (vertex_diagonal_iff ((fixedQuadruplesEquiv hw tau) q j)).mpr
        intro hj
        exact h ⟨j, hj⟩ (by simp [coincidenceSupport])
    · revert h
      refine Fin.lastCases ?_ (fun j => ?_) t
      · intro h
        change diagonal (q.1 (Fin.last (n + 1)))
        rw [q.2.2.1]
        rfl
      · intro h
        apply (vertex_diagonal_iff ((fixedQuadruplesEquiv hw tau) q j)).mpr
        intro hj
        exact h ⟨j, hj⟩ (by simp [coincidenceSupport])

theorem average_fst {X Y : Type*} [Fintype X] [Fintype Y]
    [Nonempty X] [Nonempty Y] (f : X → ℚ) :
    average (fun x : X × Y => f x.1) = average f := by
  classical
  have hx : (Fintype.card X : ℚ) ≠ 0 := by exact_mod_cast Fintype.card_ne_zero
  have hy : (Fintype.card Y : ℚ) ≠ 0 := by exact_mod_cast Fintype.card_ne_zero
  simp only [average, Fintype.sum_prod_type, Finset.sum_const, Finset.card_univ,
    nsmul_eq_mul, Fintype.card_prod, Nat.cast_mul]
  rw [← Finset.mul_sum]
  field_simp

theorem fixed_quadruple_factorization {w n : ℕ} (hw : 0 < w)
    (tau : Fin (n + 1) → Bool) (v : Finset ℕ)
    (hbound : ∀ t ∈ v, t < n + 1) (hv : ∀ t ∈ v, t + 1 ∉ v)
    (c : {t // t ∈ v} → ℚ) :
    average (fun q : FixedQuadruples w n hw tau =>
      ∏ t, (1 + c t * (if layerCoincidence q.1 ⟨t.1, hbound t.1 t.2⟩ then 1 else 0))) =
      ∏ t, (1 + c t / (w : ℚ) ^ (coincidenceSupport tau t.1).card) := by
  classical
  letI : NeZero w := ⟨ne_of_gt hw⟩
  letI : Nonempty (Residual w tau) :=
    ⟨fun _ => ⟨endpoint w hw, by simp [paired, endpoint]⟩⟩
  let e := (fixedQuadruplesEquiv hw tau).trans (nnSplit tau)
  let g := fun x : NNSite tau → Fin w × Fin w =>
    ∏ t : {t // t ∈ v}, (1 + c t *
      (if ∀ j ∈ coincidenceSupport tau t.1, (x j).1 = (x j).2 then 1 else 0))
  let f := fun z : (NNSite tau → Fin w × Fin w) × Residual w tau => g z.1
  have heq (q : FixedQuadruples w n hw tau) :
      (∏ t, (1 + c t *
        (if layerCoincidence q.1 ⟨t.1, hbound t.1 t.2⟩ then 1 else 0))) = f (e q) := by
    change (∏ t, _) = ∏ t : {t // t ∈ v}, _
    apply Finset.prod_congr rfl
    intro t _
    have hpair (j : NNSite tau) : (e q).1 j =
        ((q.1 j.1.castSucc.succ).1.1, (q.1 j.1.castSucc.succ).2.1) :=
      nnSplit_quad_apply hw tau q j
    have hfree :
        (∀ j ∈ coincidenceSupport tau t.1, diagonal (q.1 j.1.castSucc.succ)) ↔
          ∀ j ∈ coincidenceSupport tau t.1, ((e q).1 j).1 = ((e q).1 j).2 := by
      simp only [hpair, diagonal]
    exact congrArg (fun z : ℚ => 1 + c t * z)
      (ite_congr (propext ((layerCoincidence_iff hw tau q ⟨t.1, hbound t.1 t.2⟩).trans hfree))
        (fun _ => rfl) (fun _ => rfl))
  calc
    _ = average (fun q => f (e q)) := congrArg average (funext heq)
    _ = average f := average_equiv e f
    _ = average g := average_fst (Y := Residual w tau) g
    _ = _ := nonadjacent_factorization v hv (fun j : NNSite tau => j.1.val + 1)
      (fun t => coincidenceSupport tau t.1) (by
        intro t j hj
        simpa only [coincidenceSupport, Finset.mem_filter, Finset.mem_univ, true_and] using hj)
      w hw c

theorem repeated_v_expansion (z : ℚ) : z ^ 2 = z * (z - 1) + z := by ring

theorem repeated_u_expansion (z : ℚ) :
    (z + 1) ^ 2 = z * (z - 1) + 3 * z + 1 := by ring

theorem normalized_v_repeated (a : ℚ) (ha : a ≠ 0) :
    (2 * a ^ 2 + a) / a ^ 2 = 1 + (a + 1) / a := by
  field_simp
  ring

theorem normalized_v_different (a : ℚ) (ha : a ≠ 0) :
    a * (a + 1) / a ^ 2 = (a + 1) / a := by
  field_simp

theorem normalized_u_repeated (b : ℚ) (hb : b + 1 ≠ 0) :
    (2 * b ^ 2 + 3 * b + 1) / (b + 1) ^ 2 = 1 + b / (b + 1) := by
  field_simp
  ring

theorem normalized_u_different (b : ℚ) (hb : b + 1 ≠ 0) :
    (b + 1) * b / (b + 1) ^ 2 = b / (b + 1) := by
  field_simp

end FourPathAudit
