import Mathlib

/- The D4 coordinate conventions agree with the upstream SnakyTwentyOne Model
and Geometry files. The finite-support semantics and policy theorem below are
independent of its unrestricted WinsIn theorem. -/
namespace SnakyFinite

abbrev Cell := ℤ × ℤ

def snaky : Finset Cell := {(0,0), (1,0), (2,0), (3,0), (3,1), (4,1)}

def orient (r : Fin 8) (p : Cell) : Cell :=
  match r.val with
  | 0 => (p.1, p.2)
  | 1 => (p.2, p.1)
  | 2 => (p.1, -p.2)
  | 3 => (-p.2, p.1)
  | 4 => (-p.1, p.2)
  | 5 => (p.2, -p.1)
  | 6 => (-p.1, -p.2)
  | _ => (-p.2, -p.1)

def place (r : Fin 8) (t p : Cell) : Cell := orient r p + t

def HasSnaky (M : Finset Cell) : Prop :=
  ∃ (r : Fin 8) (t : Cell), snaky.image (place r t) ⊆ M

def inverse (r : Fin 8) : Fin 8 :=
  if r = 3 then 5 else if r = 5 then 3 else r

def orientEquiv (r : Fin 8) : Cell ≃ Cell where
  toFun := orient r
  invFun := orient (inverse r)
  left_inv := by
    intro p
    fin_cases r <;> rcases p with ⟨x,y⟩ <;> simp [orient, inverse]
  right_inv := by
    intro p
    fin_cases r <;> rcases p with ⟨x,y⟩ <;> simp [orient, inverse]

def shiftEquiv (t : Cell) : Cell ≃ Cell where
  toFun := fun p => p + t
  invFun := fun p => p - t
  left_inv := fun p => add_sub_cancel_right p t
  right_inv := fun p => sub_add_cancel p t

def placeEquiv (r : Fin 8) (t : Cell) : Cell ≃ Cell :=
  (orientEquiv r).trans (shiftEquiv t)

def comp (r s : Fin 8) : Fin 8 :=
  ![![0,1,2,3,4,5,6,7], ![1,0,3,2,5,4,7,6],
    ![2,5,0,7,6,1,4,3], ![3,4,1,6,7,0,5,2],
    ![4,3,6,1,0,7,2,5], ![5,2,7,0,1,6,3,4],
    ![6,7,4,5,2,3,0,1], ![7,6,5,4,3,2,1,0]] r s

theorem orient_comp (r s : Fin 8) (p : Cell) :
    orient r (orient s p) = orient (comp r s) p := by
  fin_cases r <;> fin_cases s <;> rcases p with ⟨x,y⟩ <;> simp [orient, comp]

theorem orient_add (r : Fin 8) (p q : Cell) :
    orient r (p + q) = orient r p + orient r q := by
  fin_cases r <;> rcases p with ⟨x,y⟩ <;> rcases q with ⟨u,v⟩ <;>
    simp [orient, add_comm]

theorem place_comp (r s : Fin 8) (t u p : Cell) :
    place r t (place s u p) = place (comp r s) (orient r u + t) p := by
  simp only [place, orient_add, orient_comp, add_assoc]

theorem hasSnaky_place (r : Fin 8) (t : Cell) {M : Finset Cell}
    (h : HasSnaky M) : HasSnaky (M.image (placeEquiv r t)) := by
  obtain ⟨s,u,hu⟩ := h
  refine ⟨comp r s, orient r u + t, ?_⟩
  intro z hz
  obtain ⟨p,hp,hpz⟩ := Finset.mem_image.mp hz
  refine Finset.mem_image.mpr ⟨place s u p,
    hu (Finset.mem_image_of_mem _ hp), ?_⟩
  exact (place_comp r s t u p).trans hpz

section Abstract
variable {α : Type*} [DecidableEq α]

/- Unlike an unrestricted reply-only recursion, the last constructor proves
victory before requesting a reply. This remains meaningful on a finite board. -/
inductive WinIn (win : Finset α → Prop) (S : Finset α) :
    ℕ → Finset α → Finset α → Prop
  | done {n M B} (hw : win M) : WinIn win S n M B
  | last {n M B} (x : α) (hxS : x ∈ S) (hxM : x ∉ M) (hxB : x ∉ B)
      (hw : win (insert x M)) : WinIn win S (n+1) M B
  | step {n M B} (x : α) (hxS : x ∈ S) (hxM : x ∉ M) (hxB : x ∉ B)
      (next : ∀ b, b ∉ insert x M → b ∉ B →
        WinIn win S (n+1) (insert x M) (insert b B)) :
      WinIn win S (n+2) M B

theorem WinIn.weaken {win : Finset α → Prop} {S : Finset α}
    {n M B} (h : WinIn win S n M B) (k : ℕ) :
    WinIn win S (n+k) M B := by
  induction h with
  | done hw => exact .done hw
  | last x hxS hxM hxB hw =>
    simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using
      (WinIn.last (n := _ + k) x hxS hxM hxB hw)
  | @step n M B x hxS hxM hxB next ih =>
    simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using
      (WinIn.step (n := n+k) x hxS hxM hxB (fun b hbM hbB => by
        simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using ih b hbM hbB))

theorem WinIn.mono {win : Finset α → Prop} {S : Finset α}
    {n m M B} (h : WinIn win S n M B) (hnm : n ≤ m) :
    WinIn win S m M B := by
  obtain ⟨k,rfl⟩ := Nat.exists_eq_add_of_le hnm
  exact h.weaken k

theorem WinIn.transport {win : Finset α → Prop} {S : Finset α}
    {n M B} (h : WinIn win S n M B) (e : α ≃ α)
    (hwin : ∀ X, win X → win (X.image e)) :
    WinIn win (S.image e) n (M.image e) (B.image e) := by
  induction h with
  | done hw => exact .done (hwin _ hw)
  | last x hxS hxM hxB hw =>
    apply WinIn.last (e x) (Finset.mem_image_of_mem e hxS)
    · intro hx
      obtain ⟨y,hy,he⟩ := Finset.mem_image.mp hx
      exact hxM (e.injective he ▸ hy)
    · intro hx
      obtain ⟨y,hy,he⟩ := Finset.mem_image.mp hx
      exact hxB (e.injective he ▸ hy)
    · simpa only [Finset.image_insert] using hwin _ hw
  | @step n M B x hxS hxM hxB next ih =>
    apply WinIn.step (e x) (Finset.mem_image_of_mem e hxS)
    · intro hx
      obtain ⟨y,hy,he⟩ := Finset.mem_image.mp hx
      exact hxM (e.injective he ▸ hy)
    · intro hx
      obtain ⟨y,hy,he⟩ := Finset.mem_image.mp hx
      exact hxB (e.injective he ▸ hy)
    · intro b hbM hbB
      have hbM' : e.symm b ∉ insert x M := by
        intro hb
        apply hbM
        simpa [Finset.image_insert] using Finset.mem_image_of_mem e hb
      have hbB' : e.symm b ∉ B := by
        intro hb
        apply hbB
        simpa using Finset.mem_image_of_mem e hb
      simpa [Finset.image_insert] using ih (e.symm b) hbM' hbB'

def Valid (win : Finset α → Prop) (n : ℕ) (A T : Finset α) : Prop :=
  ∀ S M B, T ⊆ S → Disjoint M B → A ⊆ M → Disjoint B T →
    M.card + B.card + 2*n ≤ S.card + 1 → WinIn win S n M B

theorem Valid.mono {win : Finset α → Prop} {n m} {A T : Finset α}
    (h : Valid win n A T) (hnm : n ≤ m) : Valid win m A T := by
  intro S M B hTS hMB hAM hBT hcap
  apply (h S M B hTS hMB hAM hBT (by omega)).mono hnm

theorem image_disjoint (e : α ≃ α) {M B : Finset α} (h : Disjoint M B) :
    Disjoint (M.image e) (B.image e) := by
  refine Finset.disjoint_left.mpr ?_
  intro z hzM hzB
  obtain ⟨x,hx,hxz⟩ := Finset.mem_image.mp hzM
  obtain ⟨y,hy,hyz⟩ := Finset.mem_image.mp hzB
  have : x = y := e.injective (hxz.trans hyz.symm)
  exact Finset.disjoint_left.mp h hx (this.symm ▸ hy)

theorem Valid.transport {win : Finset α → Prop} {n} {A T : Finset α}
    (h : Valid win n A T) (e : α ≃ α)
    (hwin : ∀ X, win X → win (X.image e)) :
    Valid win n (A.image e) (T.image e) := by
  intro S M B hTS hMB hAM hBT hcap
  have hTS' : T ⊆ S.image e.symm := by
    intro z hz
    exact Finset.mem_image.mpr ⟨e z, hTS (Finset.mem_image_of_mem e hz), by simp⟩
  have hAM' : A ⊆ M.image e.symm := by
    intro z hz
    exact Finset.mem_image.mpr ⟨e z, hAM (Finset.mem_image_of_mem e hz), by simp⟩
  have hBT' : Disjoint (B.image e.symm) T := by
    refine Finset.disjoint_left.mpr ?_
    intro z hzB hzT
    obtain ⟨x,hx,he⟩ := Finset.mem_image.mp hzB
    apply Finset.disjoint_left.mp hBT hx
    exact Finset.mem_image.mpr ⟨z,hzT, by rw [← he]; simp⟩
  have hc : (M.image e.symm).card + (B.image e.symm).card + 2*n ≤
      (S.image e.symm).card + 1 := by
    simpa only [Finset.card_image_of_injective _ e.symm.injective] using hcap
  have hw := (h (S.image e.symm) (M.image e.symm) (B.image e.symm)
    hTS' (image_disjoint e.symm hMB) hAM' hBT' hc).transport e hwin
  simpa [Finset.image_image, Function.comp_def] using hw

theorem fresh_in (S M B : Finset α) (h : M.card + B.card < S.card) :
    ∃ x ∈ S, x ∉ M ∧ x ∉ B := by
  classical
  by_contra hn
  have hs : S ⊆ M ∪ B := by
    intro x hxS
    by_contra hx
    have hxM : x ∉ M := fun hm => hx (Finset.mem_union_left _ hm)
    have hxB : x ∉ B := fun hb => hx (Finset.mem_union_right _ hb)
    exact hn ⟨x,hxS,hxM,hxB⟩
  have hle := (Finset.card_le_card hs).trans (Finset.card_union_le M B)
  omega

theorem base_valid (win : Finset α → Prop) (T : Finset α) (p : α)
    (hp : p ∈ T) (hwin : ∀ M, T ⊆ M → win M) :
    Valid win 1 (T.erase p) T := by
  intro S M B hTS _ hAM hBT _
  have ht : T ⊆ insert p M := by
    intro y hy
    by_cases hyp : y = p
    · simp [hyp]
    · exact Finset.mem_insert_of_mem (hAM (Finset.mem_erase.mpr ⟨hyp,hy⟩))
  by_cases hpM : p ∈ M
  · exact .done (hwin M (by simpa [Finset.insert_eq_of_mem hpM] using ht))
  · exact .last p (hTS hp) hpM
      (fun hpB => Finset.disjoint_left.mp hBT hpB hp) (hwin _ ht)

theorem disjoint_round {M B : Finset α} {x b : α} (h : Disjoint M B)
    (hxB : x ∉ B) (hbM : b ∉ insert x M) :
    Disjoint (insert x M) (insert b B) := by
  refine Finset.disjoint_left.mpr ?_
  intro y hyM hyB
  rcases Finset.mem_insert.mp hyB with rfl | hyB
  · exact hbM hyM
  · rcases Finset.mem_insert.mp hyM with rfl | hyM
    · exact hxB hyB
    · exact Finset.disjoint_left.mp h hyM hyB

theorem compose_valid {ι : Type*} [Nonempty ι]
    (win : Finset α → Prop) (n : ℕ) (hn : 0 < n)
    (C D : ι → Finset α) (hc : ∀ j, Valid win n (C j) (D j))
    (p : α) (A T : Finset α) (hp : p ∈ T)
    (hC : ∀ j, C j ⊆ insert p A) (hD : ∀ j, D j ⊆ T)
    (hcommon : ∀ b, (∀ j, b ∈ D j) → b ∈ insert p A) :
    Valid win (n+1) A T := by
  classical
  intro S M B hTS hMB hAM hBT hcap
  have hpB : p ∉ B := fun hb => Finset.disjoint_left.mp hBT hb hp
  obtain ⟨x,hxS,hxM,hxB,hpx⟩ :
      ∃ x ∈ S, x ∉ M ∧ x ∉ B ∧ p ∈ insert x M := by
    by_cases hpM : p ∈ M
    · obtain ⟨x,hxS,hxM,hxB⟩ := fresh_in S M B (by omega)
      exact ⟨x,hxS,hxM,hxB,Finset.mem_insert_of_mem hpM⟩
    · exact ⟨p,hTS hp,hpM,hpB,Finset.mem_insert_self _ _⟩
  have howned : insert p A ⊆ insert x M := by
    intro y hy
    rcases Finset.mem_insert.mp hy with rfl | hy
    · exact hpx
    · exact Finset.mem_insert_of_mem (hAM hy)
  obtain ⟨k,hk⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : n ≠ 0)
  subst n
  apply WinIn.step x hxS hxM hxB
  intro b hbM hbB
  have hex : ∃ j, b ∉ D j := by
    by_contra h
    push Not at h
    exact hbM (howned (hcommon b h))
  obtain ⟨j,hj⟩ := hex
  have hBD : Disjoint (insert b B) (D j) := by
    refine Finset.disjoint_left.mpr ?_
    intro y hy hyD
    rcases Finset.mem_insert.mp hy with rfl | hyB
    · exact hj hyD
    · exact Finset.disjoint_left.mp hBT hyB (hD j hyD)
  apply hc j S (insert x M) (insert b B) ((hD j).trans hTS)
    (disjoint_round hMB hxB hbM) ((hC j).trans howned) hBD
  rw [Finset.card_insert_of_notMem hxM, Finset.card_insert_of_notMem hbB]
  omega
end Abstract

structure Card where
  A : Finset Cell
  T : Finset Cell
  h : ℕ
  positive : 0 < h
  subset : A ⊆ T
  valid : Valid HasSnaky h A T

def basePoint (j : Fin 6) : Cell := ![(0,0),(1,0),(2,0),(3,0),(3,1),(4,1)] j

def base (j : Fin 6) : Card where
  A := snaky.erase (basePoint j)
  T := snaky
  h := 1
  positive := by decide
  subset := Finset.erase_subset _ _
  valid := by
    apply base_valid HasSnaky snaky (basePoint j)
    · fin_cases j <;> decide
    · intro M hM
      refine ⟨0,(0,0),?_⟩
      have he : place 0 (0,0) = id := by
        funext p
        rcases p with ⟨x,y⟩
        simp [place, orient]
      rw [he, Finset.image_id]
      exact hM

def sourceCode (s : Fin 8) : Fin 8 := ![0,1,4,5,2,3,6,7] s

def placed (s : Fin 8) (t : Cell) (c : Card) : Card where
  A := c.A.map (placeEquiv (sourceCode s) t).toEmbedding
  T := c.T.map (placeEquiv (sourceCode s) t).toEmbedding
  h := c.h
  positive := c.positive
  subset := by
    simpa [Finset.map_eq_image] using
      Finset.image_subset_image (f := placeEquiv (sourceCode s) t) c.subset
  valid := by
    simpa [Finset.map_eq_image] using
      c.valid.transport (placeEquiv (sourceCode s) t) (fun _ hw => hasSnaky_place _ _ hw)

def common {r : ℕ} (D : Fin (r+1) → Finset Cell) : Finset Cell :=
  (D 0).filter (fun b => ∀ j, b ∈ D j)

def combinedA {r : ℕ} (p : Cell) (cs : Fin (r+1) → Card) : Finset Cell :=
  ((Finset.univ.biUnion (fun j => (cs j).A)) ∪ common (fun j => (cs j).T)).erase p

def combinedT {r : ℕ} (p : Cell) (cs : Fin (r+1) → Card) : Finset Cell :=
  insert p (Finset.univ.biUnion (fun j => (cs j).T))

def maxHeight {r : ℕ} (cs : Fin (r+1) → Card) : ℕ :=
  Finset.univ.sup (fun j => (cs j).h)

theorem height_le {r : ℕ} (cs : Fin (r+1) → Card) (j) :
    (cs j).h ≤ maxHeight cs :=
  Finset.le_sup (f := fun j => (cs j).h) (Finset.mem_univ j)

theorem child_A {r : ℕ} (p : Cell) (cs : Fin (r+1) → Card) (j) :
    (cs j).A ⊆ insert p (combinedA p cs) := by
  intro x hx
  by_cases hxp : x = p
  · simp [hxp]
  · exact Finset.mem_insert_of_mem (Finset.mem_erase.mpr ⟨hxp,
      Finset.mem_union_left _ (Finset.mem_biUnion.mpr ⟨j,Finset.mem_univ j,hx⟩)⟩)

theorem child_T {r : ℕ} (p : Cell) (cs : Fin (r+1) → Card) (j) :
    (cs j).T ⊆ combinedT p cs := by
  intro x hx
  exact Finset.mem_insert_of_mem (Finset.mem_biUnion.mpr ⟨j,Finset.mem_univ j,hx⟩)

theorem child_common {r : ℕ} (p : Cell) (cs : Fin (r+1) → Card) (b)
    (hb : ∀ j, b ∈ (cs j).T) : b ∈ insert p (combinedA p cs) := by
  by_cases hbp : b = p
  · simp [hbp]
  · exact Finset.mem_insert_of_mem (Finset.mem_erase.mpr ⟨hbp,
      Finset.mem_union_right _ (Finset.mem_filter.mpr ⟨hb 0,hb⟩)⟩)

def combine {r : ℕ} (p : Cell) (children : Vector Card (r+1)) : Card :=
  let cs := children.get
  { A := combinedA p cs
    T := combinedT p cs
    h := maxHeight cs + 1
    positive := by omega
    subset := by
      intro x hx
      obtain ⟨_,hx⟩ := Finset.mem_erase.mp hx
      rcases Finset.mem_union.mp hx with hc | ht
      · obtain ⟨j,_,hj⟩ := Finset.mem_biUnion.mp hc
        exact child_T p cs j ((cs j).subset hj)
      · exact child_T p cs 0 (Finset.mem_filter.mp ht).1
    valid := compose_valid HasSnaky (maxHeight cs)
      (lt_of_lt_of_le (cs 0).positive (height_le cs 0))
      (fun j => (cs j).A) (fun j => (cs j).T)
      (fun j => (cs j).valid.mono (height_le cs j))
      p (combinedA p cs) (combinedT p cs) (Finset.mem_insert_self _ _)
      (child_A p cs) (child_T p cs) (child_common p cs) }

section Policy
variable {α : Type*} [DecidableEq α] [Inhabited α]

abbrev Policy (α : Type*) := ℕ → Finset α → Finset α → α

def Good (win : Finset α → Prop) (S : Finset α) (n : ℕ)
    (M B : Finset α) (x : α) : Prop :=
  x ∈ S ∧ x ∉ M ∧ x ∉ B ∧
    (win (insert x M) ∨ (0 < n ∧
      ∀ b, b ∉ insert x M → b ∉ B → WinIn win S n (insert x M) (insert b B)))

omit [Inhabited α] in
theorem exists_good {win : Finset α → Prop} {S : Finset α}
    {n M B} (h : WinIn win S (n+1) M B) (hnw : ¬win M) :
    ∃ x, Good win S n M B x := by
  cases h with
  | done hw => exact False.elim (hnw hw)
  | last x hxS hxM hxB hw => exact ⟨x,hxS,hxM,hxB,Or.inl hw⟩
  | step x hxS hxM hxB next => exact ⟨x,hxS,hxM,hxB,Or.inr ⟨by omega,next⟩⟩

noncomputable def policy (win : Finset α → Prop) (S : Finset α)
    (r : ℕ) (M B : Finset α) : α := by
  classical
  exact if h : ∃ x, Good win S (r-1) M B x then Classical.choose h else default

theorem policy_good {win : Finset α → Prop} {S : Finset α} {n M B}
    (h : WinIn win S (n+1) M B) (hnw : ¬win M) :
    Good win S n M B (policy win S (n+1) M B) := by
  classical
  have hex := exists_good h hnw
  unfold policy
  simp only [Nat.add_sub_cancel]
  rw [dif_pos hex]
  exact Classical.choose_spec hex

/- The same policy occurs at every node, outside the universal reply
quantifier. No freshness is asserted on arbitrary exhausted positions. -/
inductive Forces (σ : Policy α) (win : Finset α → Prop) (S : Finset α) :
    ℕ → Finset α → Finset α → Prop
  | done {n M B} (hw : win M) : Forces σ win S n M B
  | last {n M B}
      (hxS : σ (n+1) M B ∈ S) (hxM : σ (n+1) M B ∉ M)
      (hxB : σ (n+1) M B ∉ B)
      (hw : win (insert (σ (n+1) M B) M)) : Forces σ win S (n+1) M B
  | step {n M B}
      (hxS : σ (n+2) M B ∈ S) (hxM : σ (n+2) M B ∉ M)
      (hxB : σ (n+2) M B ∉ B)
      (next : ∀ b, b ∉ insert (σ (n+2) M B) M → b ∉ B →
        Forces σ win S (n+1) (insert (σ (n+2) M B) M) (insert b B)) :
      Forces σ win S (n+2) M B

theorem fixed_policy {win : Finset α → Prop} {S : Finset α}
    {n M B} (h : WinIn win S n M B) :
    Forces (policy win S) win S n M B := by
  classical
  induction n generalizing M B with
  | zero => cases h with | done hw => exact .done hw
  | succ n ih =>
    by_cases hw : win M
    · exact .done hw
    have hg := policy_good h hw
    obtain ⟨hxS,hxM,hxB,hn⟩ := hg
    rcases hn with hw' | ⟨hn,next⟩
    · exact .last hxS hxM hxB hw'
    · obtain ⟨k,rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : n ≠ 0)
      exact .step hxS hxM hxB (fun b hbM hbB => ih (next b hbM hbB))

noncomputable def Legal (σ : Policy α) (win : Finset α → Prop)
    (β : ℕ → α) : ℕ → ℕ → Finset α → Finset α → Prop := by
  classical
  exact fun n => match n with
  | 0 => fun _ _ _ => True
  | n+1 => fun t M B =>
    if win M then True else
    let M' := insert (σ (n+1) M B) M
    if win M' ∨ n = 0 then True else
      β t ∉ M' ∧ β t ∉ B ∧ Legal σ win β n (t+1) M' (insert (β t) B)

inductive Execution (σ : Policy α) (win : Finset α → Prop) (S : Finset α)
    (β : ℕ → α) :
    ℕ → ℕ → Finset α → Finset α → Finset α → Finset α → ℕ → ℕ → Prop
  | stop {n t M B} (hw : win M) (hd : Disjoint M B) :
      Execution σ win S β n t M B M B 0 0
  | finish {n t M B} (hnw : ¬win M) (hd : Disjoint M B)
      (hxS : σ (n+1) M B ∈ S) (hxM : σ (n+1) M B ∉ M)
      (hxB : σ (n+1) M B ∉ B) (hw : win (insert (σ (n+1) M B) M)) :
      Execution σ win S β (n+1) t M B (insert (σ (n+1) M B) M) B 1 0
  | reply {n t M B F G c d} (hnw : ¬win M) (hd : Disjoint M B)
      (hxS : σ (n+2) M B ∈ S) (hxM : σ (n+2) M B ∉ M)
      (hxB : σ (n+2) M B ∉ B) (hnw' : ¬win (insert (σ (n+2) M B) M))
      (hbM : β t ∉ insert (σ (n+2) M B) M) (hbB : β t ∉ B)
      (next : Execution σ win S β (n+1) (t+1)
        (insert (σ (n+2) M B) M) (insert (β t) B) F G c d) :
      Execution σ win S β (n+2) t M B F G (c+1) (d+1)

omit [Inhabited α] in
theorem Forces.executes {σ : Policy α} {win : Finset α → Prop} {S : Finset α}
    {n M B} (h : Forces σ win S n M B) (β : ℕ → α) (t : ℕ)
    (hd : Disjoint M B) (hl : Legal σ win β n t M B) :
    ∃ F G c d, Execution σ win S β n t M B F G c d := by
  classical
  induction h generalizing t with
  | done hw => exact ⟨_,_,_,_,.stop hw hd⟩
  | @last n M B hxS hxM hxB hw =>
    by_cases hnw : win M
    · exact ⟨_,_,_,_,.stop hnw hd⟩
    · exact ⟨_,_,_,_,.finish hnw hd hxS hxM hxB hw⟩
  | @step n M B hxS hxM hxB next ih =>
    by_cases hw : win M
    · exact ⟨_,_,_,_,.stop hw hd⟩
    by_cases hw' : win (insert (σ (n+2) M B) M)
    · exact ⟨_,_,_,_,.finish hw hd hxS hxM hxB hw'⟩
    have hl' : β t ∉ insert (σ (n+2) M B) M ∧ β t ∉ B ∧
        Legal σ win β (n+1) (t+1) (insert (σ (n+2) M B) M) (insert (β t) B) := by
      change (if win M then True else
        if win (insert (σ (n+2) M B) M) ∨ n+1 = 0 then True else
          β t ∉ insert (σ (n+2) M B) M ∧ β t ∉ B ∧
          Legal σ win β (n+1) (t+1) (insert (σ (n+2) M B) M)
            (insert (β t) B)) at hl
      have hcond : ¬(win (insert (σ (n+2) M B) M) ∨ n+1 = 0) := by
        rintro (hc | hc)
        · exact hw' hc
        · omega
      rw [if_neg hw, if_neg hcond] at hl
      exact hl
    obtain ⟨F,G,c,d,he⟩ := ih (β t) hl'.1 hl'.2.1 (t+1)
      (disjoint_round hd hxB hl'.1) hl'.2.2
    exact ⟨F,G,c+1,d+1,.reply hw hd hxS hxM hxB hw' hl'.1 hl'.2.1 he⟩

omit [Inhabited α] in
theorem Execution.summary {σ : Policy α} {win : Finset α → Prop} {S : Finset α}
    {β n t M B F G c d} (h : Execution σ win S β n t M B F G c d) :
    win F ∧ Disjoint F G ∧ M ⊆ F ∧ B ⊆ G ∧ F ⊆ M ∪ S ∧
      F.card = M.card + c ∧ G.card = B.card + d ∧
      c ≤ n ∧ d ≤ n-1 ∧ (win M ∨ c = d+1) := by
  induction h with
  | stop hw hd =>
    exact ⟨hw,hd,Finset.Subset.refl _,Finset.Subset.refl _,
      Finset.subset_union_left,by omega,by omega,by omega,by omega,Or.inl hw⟩
  | finish hnw hd hxS hxM hxB hw =>
    refine ⟨hw,Finset.disjoint_insert_left.mpr ⟨hxB,hd⟩,
      Finset.subset_insert _ _,Finset.Subset.refl _,?_,
      by simp [Finset.card_insert_of_notMem hxM],by omega,by omega,by omega,
      Or.inr (by omega)⟩
    intro y hy
    rcases Finset.mem_insert.mp hy with rfl | hy
    · exact Finset.mem_union_right _ hxS
    · exact Finset.mem_union_left _ hy
  | @reply n t M B F G c d hnw hd hxS hxM hxB hnw' hbM hbB next ih =>
    obtain ⟨hw,hFG,hMF,hBG,hFS,hMc,hBd,hcn,hdn,hcd⟩ := ih
    have hcd' : c = d+1 := hcd.resolve_left hnw'
    refine ⟨hw,hFG,(Finset.subset_insert _ _).trans hMF,
      (Finset.subset_insert _ _).trans hBG,?_,?_,?_,by omega,by omega,
      Or.inr (by omega)⟩
    · intro y hy
      rcases Finset.mem_union.mp (hFS hy) with hy | hy
      · rcases Finset.mem_insert.mp hy with rfl | hy
        · exact Finset.mem_union_right _ hxS
        · exact Finset.mem_union_left _ hy
      · exact Finset.mem_union_right _ hy
    · rw [Finset.card_insert_of_notMem hxM] at hMc
      omega
    · rw [Finset.card_insert_of_notMem hbB] at hBd
      omega
end Policy

def cached (c : Card) (A T : Finset Cell) (h : ℕ)
    (ha : c.A = A) (ht : c.T = T) (hh : c.h = h) : Card where
  A := A
  T := T
  h := h
  positive := by simpa only [hh] using c.positive
  subset := by simpa only [ha, ht] using c.subset
  valid := by simpa only [ha, ht, hh] using c.valid

def copyFinset (s : Finset Cell) (points : List Cell)
    (h : s.val = (points : Multiset Cell)) : Finset Cell where
  val := points
  nodup := h ▸ s.nodup

theorem copyFinset_eq (s : Finset Cell) (points : List Cell)
    (h : s.val = (points : Multiset Cell)) : s = copyFinset s points h := by
  apply Finset.ext
  intro p
  change p ∈ s.val ↔ p ∈ (points : Multiset Cell)
  rw [h]

open Lean Meta Elab Term in
def literalFinset (source : Expr) (points : List Cell) : MetaM (Expr × Expr) := do
  let ms ← mkAppM ``Multiset.ofList #[toExpr points]
  let original ← mkAppM ``Finset.val #[source]
  let statement ← mkEq original ms
  let proof ←
    if ← withTransparency .all (isDefEq original ms) then mkEqRefl original
    else mkDecideProof statement
  let proof ← mkAuxTheorem statement proof
  let result ← mkAppM ``copyFinset #[source,toExpr points,proof]
  let equality ← mkAppM ``copyFinset_eq #[source,toExpr points,proof]
  let equality ← mkAuxTheorem (← mkEq source result) equality
  return (result,equality)

syntax (name := cachedCardTerm) "cacheCard " term : term

/- Runtime representatives propose data only. Named kernel-checked equalities
transport both distinctness and the original semantic proof. -/
open Lean Meta Elab Term in
@[term_elab cachedCardTerm] unsafe def elabCacheCard : TermElab := fun stx _ => do
  let c ← elabTerm stx[1] (some (mkConst ``Card))
  synthesizeSyntheticMVarsNoPostponing
  let c ← instantiateMVars c
  let value ← evalExpr Card (mkConst ``Card) c
  -- Quotient wrappers are erased at runtime. These are witness proposals,
  -- never casts of proofs; every representative equality is kernel checked.
  let a : List Cell := unsafeCast value.A.val
  let t : List Cell := unsafeCast value.T.val
  let (ae,pa) ← literalFinset (mkProj ``Card 0 c) a
  let (te,pt) ← literalFinset (mkProj ``Card 1 c) t
  let he := toExpr value.h
  let statement ← mkEq (mkProj ``Card 2 c) he
  let ph ← mkAuxTheorem statement (← mkDecideProof statement)
  mkAppM ``cached #[c,ae,te,he,pa,pt,ph]

/- BEGIN SOURCE-BOUND CERTIFICATE DATA -/

set_option maxHeartbeats 2000000
set_option maxRecDepth 65536
def card0 : Card := cacheCard (base 0)
def card1 : Card := cacheCard (base 1)
def card2 : Card := cacheCard (base 2)
def card3 : Card := cacheCard (base 3)
def card4 : Card := cacheCard (base 4)
def card5 : Card := cacheCard (base 5)
def card6 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,0) card4)), (cacheCard (placed 1 (0,1) card5))]))
def card7 : Card := (cacheCard (combine (0,5) #v[(cacheCard (placed 0 (0,1) card6)), (cacheCard (placed 4 (0,5) card6))]))
def card8 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 1 (0,1) card6)), (cacheCard (placed 3 (0,1) card6))]))
def card9 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 0 (1,1) card6)), (cacheCard (placed 6 (1,5) card6))]))
def card10 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 1 (0,1) card8))]))
def card11 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 3 (0,5) card0)), (cacheCard (placed 3 (0,4) card5))]))
def card12 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 6 (1,6) card7)), (cacheCard (placed 1 (0,2) card8)), (cacheCard (placed 6 (2,6) card9))]))
def card13 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 2 (1,1) card7)), (cacheCard (placed 1 (0,2) card8)), (cacheCard (placed 6 (2,6) card9))]))
def card14 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 6 (1,6) card7)), (cacheCard (placed 1 (0,2) card8)), (cacheCard (placed 0 (0,1) card9))]))
def card15 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 7 (1,5) card0))]))
def card16 : Card := (cacheCard (combine (0,4) #v[(cacheCard (placed 3 (0,4) card4)), (cacheCard (placed 0 (0,0) card6))]))
def card17 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (1,0) card6)), (cacheCard (placed 2 (1,1) card16))]))
def card18 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card4)), (cacheCard (placed 1 (0,1) card8))]))
def card19 : Card := (cacheCard (combine (0,1) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 0 (0,1) card18))]))
def card20 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,5) card0)), (cacheCard (placed 0 (1,0) card6))]))
def card21 : Card := (cacheCard (combine (0,4) #v[(cacheCard (placed 3 (0,4) card5)), (cacheCard (placed 0 (0,0) card6))]))
def card22 : Card := (cacheCard (combine (0,3) #v[(cacheCard (placed 3 (0,5) card0)), (cacheCard (placed 3 (0,4) card5))]))
def card23 : Card := (cacheCard (combine (0,4) #v[(cacheCard (placed 3 (0,5) card0)), (cacheCard (placed 3 (0,4) card5))]))
def card24 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 6 (4,1) card4)), (cacheCard (placed 1 (0,1) card6))]))
def card25 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 3 (2,4) card2)), (cacheCard (placed 4 (0,1) card5))]))
def card26 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 1 (0,1) card6)), (cacheCard (placed 3 (0,1) card7))]))
def card27 : Card := (cacheCard (combine (0,4) #v[(cacheCard (placed 3 (0,4) card5)), (cacheCard (placed 0 (0,1) card16))]))
def card28 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (placed 7 (1,4) card5))]))
def card29 : Card := (cacheCard (combine (0,4) #v[(cacheCard (placed 3 (0,5) card0)), (cacheCard (placed 0 (0,0) card6))]))
def card30 : Card := (cacheCard (combine (0,2) #v[(cacheCard (placed 3 (0,4) card0)), (cacheCard (placed 1 (0,0) card5))]))
def card31 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 1 (0,2) card8)), (cacheCard (placed 3 (0,5) card8))]))
def card32 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 3 (2,4) card0)), (cacheCard (placed 4 (0,1) card5))]))
def card33 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 2 (1,1) card7)), (cacheCard (placed 3 (0,5) card8)), (cacheCard (placed 2 (2,1) card9))]))
def card34 : Card := (cacheCard (combine (0,3) #v[(cacheCard (placed 1 (0,1) card5)), (cacheCard (placed 3 (0,4) card5))]))
def card35 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 7 (3,4) card1)), (cacheCard (placed 0 (0,1) card5))]))
def card36 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,0) card2)), (cacheCard (placed 7 (1,4) card2))]))
def card37 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 0 (1,0) card6))]))
def card38 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 7 (3,4) card0)), (cacheCard (placed 0 (0,1) card5))]))
def card39 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 1 (0,1) card8))]))
def card40 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 1 (1,1) card5)), (cacheCard (placed 7 (1,4) card5))]))
def card41 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (1,0) card6)), (cacheCard (placed 1 (0,1) card24))]))
def card42 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 1 (0,1) card24))]))
def card43 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,5) card0)), (cacheCard (placed 7 (1,4) card3))]))
def card44 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 0 (0,1) card43))]))
def card45 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card5)), (cacheCard (placed 2 (3,0) card23))]))
def card46 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 4 (0,2) card5)), (cacheCard (placed 0 (0,0) card45))]))
def card47 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 1 (0,2) card7)), (cacheCard (placed 3 (0,3) card9)), (cacheCard (placed 0 (1,0) card46))]))
def card48 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 1 (0,1) card24))]))
def card49 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 3 (0,1) card6)), (cacheCard (placed 1 (0,0) card9))]))
def card50 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 1 (0,1) card8))]))
def card51 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,5) card0)), (cacheCard (placed 1 (0,0) card3))]))
def card52 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 0 (0,1) card51))]))
def card53 : Card := (cacheCard (combine (0,1) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 0 (0,1) card51))]))
def card54 : Card := (cacheCard (combine (0,2) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 0 (0,1) card51))]))
def card55 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (0,3) card5)), (cacheCard (placed 0 (2,0) card53))]))
def card56 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (0,3) card5)), (cacheCard (placed 6 (3,6) card53))]))
def card57 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (0,3) card52)), (cacheCard (placed 6 (3,6) card53))]))
def card58 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (0,2) card2)), (cacheCard (placed 0 (3,0) card52))]))
def card59 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 5 (4,2) card28)), (cacheCard (placed 0 (2,0) card31)), (cacheCard (placed 0 (0,1) card58))]))
def card60 : Card := (cacheCard (combine (0,3) #v[(cacheCard (placed 2 (4,2) card0)), (cacheCard (placed 2 (1,0) card52))]))
def card61 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 0 (0,1) card51))]))
def card62 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 4 (1,5) card6)), (cacheCard (placed 6 (1,5) card6))]))
def card63 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (1,1) card16)), (cacheCard (placed 1 (0,1) card24)), (cacheCard (placed 4 (0,5) card62))]))
def card64 : Card := (cacheCard (combine (0,2) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 0 (0,1) card43))]))
def card65 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 0 (0,2) card20)), (cacheCard (placed 4 (0,5) card20))]))
def card66 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,5) card0)), (cacheCard (placed 3 (1,4) card5))]))
def card67 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 1 (0,1) card8)), (cacheCard (placed 3 (0,4) card32))]))
def card68 : Card := (cacheCard (combine (0,2) #v[(cacheCard (placed 7 (1,6) card0)), (cacheCard (placed 1 (0,0) card1))]))
def card69 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 4 (0,2) card5)), (cacheCard (placed 2 (3,0) card15))]))
def card70 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 7 (1,4) card2)), (cacheCard (placed 1 (0,0) card3))]))
def card71 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 2 (4,1) card0)), (cacheCard (placed 2 (2,0) card10))]))
def card72 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 1 (0,1) card20)), (cacheCard (placed 3 (0,2) card29)), (cacheCard (placed 0 (0,0) card46))]))
def card73 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 6 (4,3) card0)), (cacheCard (placed 0 (1,0) card52))]))
def card74 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 0 (0,0) card30)), (cacheCard (placed 2 (1,0) card30)), (cacheCard (placed 0 (0,0) card36)), (cacheCard (placed 2 (1,0) card36))]))
def card75 : Card := (cacheCard (combine (0,4) #v[(cacheCard (placed 0 (0,2) card20)), (cacheCard (placed 6 (1,5) card23))]))
def card76 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card4)), (cacheCard (placed 3 (1,4) card5))]))
def card77 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 0 (0,1) card3)), (cacheCard (placed 3 (1,4) card5))]))
def card78 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (placed 5 (4,0) card77))]))
def card79 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (2,1) card8)), (cacheCard (placed 7 (4,4) card78))]))
def card80 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (placed 7 (1,4) card5))]))
def card81 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (placed 0 (2,0) card42))]))
def card82 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (3,0) card52)), (cacheCard (placed 1 (0,2) card64))]))
def card83 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (placed 7 (1,4) card5))]))
def card84 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 6 (1,5) card6)), (cacheCard (placed 0 (0,2) card17))]))
def card85 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 6 (2,6) card15)), (cacheCard (placed 4 (1,7) card65)), (cacheCard (placed 3 (0,5) card72))]))
def card86 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (1,5) card2)), (cacheCard (placed 7 (4,4) card78))]))
def card87 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (3,0) card11)), (cacheCard (placed 7 (4,4) card35))]))
def card88 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (0,3) card52)), (cacheCard (placed 0 (2,0) card53))]))
def card89 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card4)), (cacheCard (placed 0 (1,0) card7))]))
def card90 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 3 (0,1) card6)), (cacheCard (placed 1 (1,0) card37))]))
def card91 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card4)), (cacheCard (placed 0 (1,1) card16))]))
def card92 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card5)), (cacheCard (placed 0 (0,0) card69))]))
def card93 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 1 (0,1) card6)), (cacheCard (placed 3 (1,1) card21))]))
def card94 : Card := (cacheCard (combine (0,3) #v[(cacheCard (placed 3 (0,4) card0)), (cacheCard (placed 1 (0,0) card5))]))
def card95 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 0 (0,2) card19)), (cacheCard (placed 4 (0,7) card19)), (cacheCard (placed 1 (0,3) card49)), (cacheCard (placed 3 (0,6) card49))]))
def card96 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 5 (3,0) card4)), (cacheCard (placed 4 (0,1) card5))]))
def card97 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 1 (0,1) card24))]))
def card98 : Card := (cacheCard (combine (0,2) #v[(cacheCard (placed 3 (0,4) card5)), (cacheCard (placed 0 (0,1) card16))]))
def card99 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 4 (0,3) card5)), (cacheCard (placed 2 (3,0) card44))]))
def card100 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 4 (0,2) card2)), (cacheCard (placed 2 (4,0) card10))]))
def card101 : Card := (cacheCard (combine (0,3) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 0 (0,1) card51))]))
def card102 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 7 (1,5) card0)), (cacheCard (placed 3 (1,4) card5))]))
def card103 : Card := (cacheCard (combine (0,4) #v[(cacheCard (placed 0 (0,0) card6)), (cacheCard (placed 0 (0,0) card11))]))
def card104 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (0,2) card10)), (cacheCard (placed 4 (0,6) card10)), (cacheCard (placed 2 (1,2) card52)), (cacheCard (placed 6 (1,6) card52))]))
def card105 : Card := (cacheCard (combine (0,3) #v[(cacheCard (placed 1 (0,1) card5)), (cacheCard (placed 0 (0,0) card11))]))
def card106 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 7 (1,4) card4)), (cacheCard (placed 0 (1,0) card7))]))
def card107 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (1,4) card3)), (cacheCard (placed 0 (0,1) card18))]))
def card108 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 0 (1,0) card15)), (cacheCard (placed 3 (0,3) card102))]))
def card109 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 4 (0,3) card5)), (cacheCard (placed 2 (3,0) card44))]))
def card110 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 2 (4,0) card12)), (cacheCard (placed 5 (4,2) card28)), (cacheCard (placed 0 (0,1) card58)), (cacheCard (placed 0 (0,1) card100))]))
def card111 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (1,2) card17)), (cacheCard (placed 2 (4,0) card55))]))
def card112 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 3 (0,3) card34)), (cacheCard (placed 0 (1,0) card44))]))
def card113 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 0 (0,2) card23))]))
def card114 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (0,3) card5)), (cacheCard (placed 0 (2,0) card14))]))
def card115 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 4 (0,3) card5)), (cacheCard (placed 0 (0,0) card114))]))
def card116 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (0,3) card7)), (cacheCard (placed 1 (0,2) card9)), (cacheCard (placed 2 (4,0) card115))]))
def card117 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,3) card7)), (cacheCard (placed 3 (0,4) card9)), (cacheCard (placed 2 (4,0) card115))]))
def card118 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,3) card7)), (cacheCard (placed 1 (0,2) card9)), (cacheCard (placed 0 (1,0) card115))]))
def card119 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 4 (0,3) card5)), (cacheCard (placed 0 (0,0) card114))]))
def card120 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 3 (0,3) card44)), (cacheCard (placed 3 (0,3) card52)), (cacheCard (placed 0 (0,0) card116))]))
def card121 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 3 (2,4) card1)), (cacheCard (placed 4 (0,1) card5))]))
def card122 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (1,1) card8)), (cacheCard (placed 3 (0,4) card46))]))
def card123 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 2 (4,1) card4)), (cacheCard (placed 6 (4,1) card4))]))
def card124 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (placed 1 (0,1) card123))]))
def card125 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 0 (0,0) card124))]))
def card126 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 1 (0,1) card123))]))
def card127 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 4 (1,6) card7)), (cacheCard (placed 1 (0,2) card24)), (cacheCard (placed 0 (0,1) card124))]))
def card128 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 4 (0,6) card9)), (cacheCard (placed 2 (1,2) card16)), (cacheCard (placed 0 (0,1) card124))]))
def card129 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (1,5) card0)), (cacheCard (placed 7 (1,4) card3))]))
def card130 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,0) card3)), (cacheCard (placed 0 (0,0) card129))]))
def card131 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 2 (4,2) card0)), (cacheCard (placed 0 (0,0) card15))]))
def card132 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 2 (4,2) card5)), (cacheCard (placed 0 (1,0) card131))]))
def card133 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 6 (4,2) card5)), (cacheCard (placed 0 (0,0) card132))]))
def card134 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 1 (1,2) card16)), (cacheCard (placed 4 (1,3) card24)), (cacheCard (placed 2 (5,0) card133))]))
def card135 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 0 (2,1) card7)), (cacheCard (placed 6 (3,6) card9)), (cacheCard (placed 1 (0,1) card133))]))
def card136 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 2 (2,1) card21)), (cacheCard (placed 0 (1,1) card37)), (cacheCard (placed 3 (0,5) card133))]))
def card137 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 1 (0,2) card7)), (cacheCard (placed 3 (0,3) card9)), (cacheCard (placed 2 (5,0) card133))]))
def card138 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,0) card3)), (cacheCard (placed 7 (1,4) card3))]))
def card139 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 0 (0,1) card138))]))
def card140 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 0 (0,1) card43))]))
def card141 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (0,0) card53)), (cacheCard (placed 6 (1,6) card53)), (cacheCard (placed 1 (0,2) card76))]))
def card142 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 6 (4,3) card5)), (cacheCard (placed 0 (1,0) card141))]))
def card143 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 1 (0,1) card6)), (cacheCard (placed 3 (0,1) card11))]))
def card144 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (0,0) card46)), (cacheCard (placed 3 (0,2) card103)), (cacheCard (placed 0 (0,1) card143))]))
def card145 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (placed 0 (2,0) card10))]))
def card146 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (placed 3 (1,4) card5))]))
def card147 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (placed 0 (2,0) card39))]))
def card148 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card4)), (cacheCard (placed 0 (1,1) card21))]))
def card149 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 0 (0,0) card124))]))
def card150 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 0 (1,0) card7))]))
def card151 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (3,1) card21)), (cacheCard (placed 7 (4,4) card35))]))
def card152 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 4 (1,3) card5)), (cacheCard (placed 2 (4,0) card99))]))
def card153 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card4)), (cacheCard (placed 2 (4,3) card5))]))
def card154 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 7 (1,5) card0)), (cacheCard (placed 7 (1,4) card3))]))
def card155 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 3 (0,2) card7)), (cacheCard (placed 1 (0,1) card9)), (cacheCard (placed 0 (1,0) card46))]))
def card156 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 3 (2,4) card2)), (cacheCard (placed 4 (0,1) card5))]))
def card157 : Card := (cacheCard (combine (4,0) #v[(cacheCard (placed 4 (0,1) card4)), (cacheCard (placed 0 (1,0) card156))]))
def card158 : Card := (cacheCard (combine (0,4) #v[(cacheCard (placed 0 (0,1) card6)), (cacheCard (placed 4 (0,5) card6))]))
def card159 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 1 (0,1) card23)), (cacheCard (placed 0 (1,0) card66))]))
def card160 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 4 (1,5) card11))]))
def card161 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (0,3) card6)), (cacheCard (placed 0 (0,0) card142))]))
def card162 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,3) card6)), (cacheCard (placed 0 (0,0) card142))]))
def card163 : Card := (cacheCard (combine (0,2) #v[(cacheCard (placed 1 (0,0) card3)), (cacheCard (placed 0 (0,0) card129))]))
def card164 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 6 (4,3) card0)), (cacheCard (placed 0 (0,0) card55))]))
def card165 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (3,0) card44)), (cacheCard (placed 1 (0,2) card64))]))
def card166 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 2 (4,0) card14)), (cacheCard (placed 5 (4,2) card28)), (cacheCard (placed 0 (0,1) card58)), (cacheCard (placed 0 (0,1) card100))]))
def card167 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (placed 3 (0,5) card152))]))
def card168 : Card := (cacheCard (combine (2,2) #v[(cacheCard (placed 6 (4,2) card5)), (cacheCard (placed 0 (1,0) card131))]))
def card169 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,0) card1)), (cacheCard (placed 7 (1,6) card1))]))
def card170 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 2 (4,2) card2)), (cacheCard (placed 7 (1,4) card3))]))
def card171 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,3) card6)), (cacheCard (placed 4 (1,4) card26)), (cacheCard (placed 0 (1,0) card116))]))
def card172 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (0,0) card142)), (cacheCard (placed 6 (5,6) card142))]))
def card173 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (0,0) card142)), (cacheCard (placed 2 (5,0) card142))]))
def card174 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 1 (0,2) card116)), (cacheCard (placed 3 (0,6) card117)), (cacheCard (placed 0 (1,1) card135)), (cacheCard (placed 6 (5,7) card135)), (cacheCard (placed 3 (0,6) card173)), (cacheCard (placed 5 (6,2) card173))]))
def card175 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 2 (1,1) card7)), (cacheCard (placed 1 (0,2) card32)), (cacheCard (placed 4 (0,6) card60))]))
def card176 : Card := (cacheCard (combine (2,2) #v[(cacheCard (placed 2 (4,2) card0)), (cacheCard (placed 2 (4,0) card60))]))
def card177 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 6 (4,2) card0)), (cacheCard (placed 0 (0,0) card23))]))
def card178 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 6 (4,2) card5)), (cacheCard (placed 0 (1,0) card177))]))
def card179 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 2 (4,2) card5)), (cacheCard (placed 0 (0,0) card178))]))
def card180 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 1 (1,2) card16)), (cacheCard (placed 4 (1,3) card24)), (cacheCard (placed 2 (5,0) card179))]))
def card181 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 1 (0,2) card7)), (cacheCard (placed 3 (0,3) card9)), (cacheCard (placed 2 (5,0) card179))]))
def card182 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 4 (2,6) card7)), (cacheCard (placed 0 (1,1) card9)), (cacheCard (placed 1 (0,1) card179))]))
def card183 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (1,2) card5)), (cacheCard (placed 2 (5,0) card178))]))
def card184 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 2 (4,0) card99)), (cacheCard (placed 6 (5,5) card179))]))
def card185 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,1) card5)), (cacheCard (placed 0 (0,0) card113))]))
def card186 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 6 (1,5) card6)), (cacheCard (placed 0 (1,0) card185))]))
def card187 : Card := (cacheCard (combine (0,6) #v[(cacheCard (placed 0 (0,2) card6)), (cacheCard (placed 0 (0,2) card7)), (cacheCard (placed 4 (0,7) card185))]))
def card188 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 1 (1,2) card8)), (cacheCard (placed 5 (3,2) card26)), (cacheCard (placed 3 (0,6) card133)), (cacheCard (placed 4 (1,7) card186)), (cacheCard (placed 0 (2,0) card187))]))
def card189 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 1 (0,2) card8)), (cacheCard (placed 1 (0,2) card26)), (cacheCard (placed 4 (0,6) card62)), (cacheCard (placed 6 (2,7) card186)), (cacheCard (placed 2 (1,0) card187))]))
def card190 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 1 (1,2) card8)), (cacheCard (placed 1 (1,2) card26)), (cacheCard (placed 3 (0,6) card179)), (cacheCard (placed 6 (3,7) card186)), (cacheCard (placed 2 (2,0) card187))]))
def card191 : Card := (cacheCard (combine (0,1) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 0 (0,1) card89))]))
def card192 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 0 (0,1) card9)), (cacheCard (placed 6 (2,6) card9)), (cacheCard (placed 0 (0,0) card186)), (cacheCard (placed 0 (1,0) card187)), (cacheCard (placed 0 (0,1) card191))]))
def card193 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 6 (1,6) card7)), (cacheCard (placed 5 (2,2) card26)), (cacheCard (placed 0 (0,1) card191))]))
def card194 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card4)), (cacheCard (placed 2 (2,0) card9))]))
def card195 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 0 (1,0) card7))]))
def card196 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (placed 0 (1,0) card143))]))
def card197 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 3 (0,1) card6)), (cacheCard (placed 0 (1,0) card8)), (cacheCard (placed 0 (1,0) card26)), (cacheCard (placed 0 (0,0) card196))]))
def card198 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 7 (1,6) card0)), (cacheCard (placed 4 (1,5) card6))]))
def card199 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 5 (1,0) card0)), (cacheCard (placed 0 (0,0) card198))]))
def card200 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 1 (0,0) card3)), (cacheCard (placed 7 (1,4) card3))]))
def card201 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (placed 5 (4,0) card146))]))
def card202 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (placed 2 (3,0) card27))]))
def card203 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (placed 1 (0,1) card202))]))
def card204 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 4 (1,6) card52)), (cacheCard (placed 1 (0,2) card203))]))
def card205 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 4 (1,5) card6)), (cacheCard (placed 2 (1,2) card23))]))
def card206 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 5 (1,0) card0)), (cacheCard (placed 0 (0,0) card205))]))
def card207 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (placed 5 (4,0) card77))]))
def card208 : Card := (cacheCard (combine (4,0) #v[(cacheCard (placed 4 (0,1) card4)), (cacheCard (placed 0 (1,0) card207))]))
def card209 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,5) card0)), (cacheCard (placed 6 (1,4) card138))]))
def card210 : Card := (cacheCard (combine (0,0) #v[(cacheCard (placed 7 (1,4) card1)), (cacheCard (placed 6 (4,1) card4))]))
def card211 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 6 (3,6) card7)), (cacheCard (placed 1 (2,2) card8)), (cacheCard (placed 0 (0,1) card151))]))
def card212 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 0 (0,1) card76))]))
def card213 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (2,0) card53)), (cacheCard (placed 4 (1,6) card53)), (cacheCard (placed 3 (0,4) card212))]))
def card214 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (0,3) card5)), (cacheCard (placed 4 (1,6) card213))]))
def card215 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 4 (0,2) card5)), (cacheCard (placed 2 (3,0) card11))]))
def card216 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (3,0) card52)), (cacheCard (placed 1 (0,2) card54))]))
def card217 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 2 (2,1) card21)), (cacheCard (placed 0 (1,1) card37)), (cacheCard (placed 3 (0,5) card179))]))
def card218 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (1,4) card0)), (cacheCard (placed 4 (0,4) card83))]))
def card219 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 7 (1,4) card4)), (cacheCard (placed 6 (1,5) card11))]))
def card220 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 2 (4,1) card0)), (cacheCard (placed 3 (2,4) card5))]))
def card221 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 5 (2,0) card5)), (cacheCard (placed 4 (0,4) card220))]))
def card222 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 5 (2,1) card5)), (cacheCard (placed 0 (0,0) card220))]))
def card223 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (placed 0 (3,0) card6))]))
def card224 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (placed 7 (3,4) card5))]))
def card225 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 6 (1,5) card6)), (cacheCard (placed 5 (2,2) card26))]))
def card226 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 2 (4,1) card4)), (cacheCard (placed 0 (1,0) card32))]))
def card227 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 2 (2,0) card53))]))
def card228 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 3 (0,3) card52)), (cacheCard (placed 0 (1,0) card227))]))
def card229 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card5)), (cacheCard (placed 0 (0,0) card215))]))
def card230 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 3 (0,2) card7)), (cacheCard (placed 1 (0,1) card9)), (cacheCard (placed 0 (1,0) card229))]))
def card231 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (1,2) card8)), (cacheCard (placed 2 (4,0) card55))]))
def card232 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 5 (2,1) card26))]))
def card233 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 1 (0,1) card6)), (cacheCard (placed 3 (1,1) card27))]))
def card234 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (placed 2 (2,1) card148))]))
def card235 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (placed 1 (0,1) card226))]))
def card236 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 6 (1,5) card6)), (cacheCard (placed 1 (0,2) card32))]))
def card237 : Card := (cacheCard (combine (0,1) #v[(cacheCard (placed 6 (4,2) card0)), (cacheCard (placed 0 (0,0) card10))]))
def card238 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 7 (2,5) card0)), (cacheCard (placed 3 (0,5) card133))]))
def card239 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 6 (3,5) card11)), (cacheCard (placed 7 (4,4) card25))]))
def card240 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 6 (4,3) card0)), (cacheCard (placed 2 (3,0) card52))]))
def card241 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (placed 2 (2,1) card91))]))
def card242 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 2 (4,2) card5)), (cacheCard (placed 0 (1,0) card69))]))
def card243 : Card := (cacheCard (combine (2,2) #v[(cacheCard (placed 2 (2,1) card10)), (cacheCard (placed 0 (0,0) card242))]))
def card244 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (4,3) card5)), (cacheCard (placed 7 (1,4) card5))]))
def card245 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (placed 1 (0,1) card32))]))
def card246 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 1 (0,1) card25))]))
def card247 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (3,0) card11)), (cacheCard (placed 7 (4,4) card35))]))
def card248 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 6 (2,6) card44)), (cacheCard (placed 3 (0,6) card47)), (cacheCard (placed 0 (1,1) card127))]))
def card249 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 2 (4,1) card17)), (cacheCard (placed 7 (4,4) card35))]))
def card250 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 5 (1,0) card0)), (cacheCard (placed 0 (0,0) card195))]))
def card251 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (0,1) card4)), (cacheCard (placed 0 (1,0) card224))]))
def card252 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 4 (0,6) card55)), (cacheCard (placed 4 (0,6) card56)), (cacheCard (placed 1 (1,2) card91))]))
def card253 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,3) card6)), (cacheCard (placed 1 (1,2) card18)), (cacheCard (placed 0 (0,0) card252))]))
def card254 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 2 (1,1) card11)), (cacheCard (placed 0 (0,0) card75)), (cacheCard (placed 6 (1,5) card103))]))
def card255 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 4 (0,3) card5)), (cacheCard (placed 0 (2,0) card254))]))
def card256 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (0,3) card5)), (cacheCard (placed 0 (0,0) card255))]))
def card257 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (0,3) card7)), (cacheCard (placed 3 (0,4) card9)), (cacheCard (placed 0 (1,0) card256))]))
def card258 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card8)), (cacheCard (placed 4 (0,6) card161)), (cacheCard (placed 4 (0,6) card162)), (cacheCard (placed 0 (0,0) card256))]))
def card259 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 0 (1,1) card15)), (cacheCard (placed 4 (0,5) card159))]))
def card260 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (placed 5 (4,0) card208))]))
def card261 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 1 (0,0) card3)), (cacheCard (placed 0 (0,0) card129))]))
def card262 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 0 (1,0) card15)), (cacheCard (placed 3 (0,3) card66))]))
def card263 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (3,0) card7)), (cacheCard (placed 2 (4,0) card9)), (cacheCard (placed 5 (4,1) card78))]))
def card264 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,1) card8)), (cacheCard (placed 3 (0,4) card201))]))
def card265 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card4)), (cacheCard (placed 1 (0,1) card93))]))
def card266 : Card := (cacheCard (combine (0,6) #v[(cacheCard (placed 0 (0,2) card6)), (cacheCard (placed 0 (0,3) card16)), (cacheCard (placed 4 (0,7) card113))]))
def card267 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 1 (1,2) card8)), (cacheCard (placed 0 (1,2) card17)), (cacheCard (placed 0 (1,0) card75)), (cacheCard (placed 3 (0,6) card179)), (cacheCard (placed 2 (2,0) card266))]))
def card268 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 6 (1,6) card7)), (cacheCard (placed 1 (0,2) card8)), (cacheCard (placed 6 (2,6) card9))]))
def card269 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 4 (1,6) card7)), (cacheCard (placed 2 (1,2) card21))]))
def card270 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 7 (4,2) card70)), (cacheCard (placed 1 (0,1) card106)), (cacheCard (placed 1 (1,0) card122)), (cacheCard (placed 1 (0,1) card269))]))
def card271 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 4 (0,3) card5)), (cacheCard (placed 2 (3,0) card52))]))
def card272 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (placed 0 (2,0) card39))]))
def card273 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,3) card2)), (cacheCard (placed 0 (3,0) card206))]))
def card274 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (2,0) card13)), (cacheCard (placed 3 (0,3) card44)), (cacheCard (placed 5 (4,2) card83))]))
def card275 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 3 (1,2) card16)), (cacheCard (placed 0 (1,1) card24)), (cacheCard (placed 2 (5,0) card179))]))
def card276 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 6 (2,6) card44)), (cacheCard (placed 6 (2,6) card52)), (cacheCard (placed 3 (0,6) card155)), (cacheCard (placed 1 (0,2) card275))]))
def card277 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 2 (5,2) card0)), (cacheCard (placed 2 (4,0) card69))]))
def card278 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 3 (0,2) card6)), (cacheCard (placed 0 (0,0) card277))]))
def card279 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,3) card6)), (cacheCard (placed 0 (1,0) card141))]))
def card280 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (1,4) card3)), (cacheCard (placed 0 (1,2) card6))]))
def card281 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 2 (4,3) card2)), (cacheCard (placed 1 (0,0) card3))]))
def card282 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 3 (0,3) card20)), (cacheCard (placed 1 (0,2) card29)), (cacheCard (placed 0 (0,0) card92))]))
def card283 : Card := (cacheCard (combine (2,2) #v[(cacheCard (placed 0 (0,2) card1)), (cacheCard (placed 0 (2,0) card282))]))
def card284 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 1 (0,3) card8)), (cacheCard (placed 0 (0,3) card17)), (cacheCard (placed 4 (0,7) card19)), (cacheCard (placed 0 (0,1) card75))]))
def card285 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (0,3) card6)), (cacheCard (placed 0 (1,2) card26)), (cacheCard (placed 0 (1,0) card117))]))
def card286 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 7 (4,4) card35)), (cacheCard (placed 5 (6,1) card253))]))
def card287 : Card := (cacheCard (combine (1,6) #v[(cacheCard (placed 6 (1,6) card169)), (cacheCard (placed 5 (5,2) card230))]))
def card288 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 3 (0,5) card54)), (cacheCard (placed 0 (0,0) card68))]))
def card289 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 0 (0,0) card22)), (cacheCard (placed 4 (0,5) card28)), (cacheCard (placed 6 (2,5) card126))]))
def card290 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 2 (4,1) card5)), (cacheCard (placed 0 (0,0) card203))]))
def card291 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 2 (3,0) card7)), (cacheCard (placed 5 (4,1) card25))]))
def card292 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (0,3) card6)), (cacheCard (placed 1 (0,2) card19)), (cacheCard (placed 0 (0,0) card214))]))
def card293 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (1,2) card17)), (cacheCard (placed 2 (4,0) card56))]))
def card294 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (0,2) card10)), (cacheCard (placed 1 (0,2) card48)), (cacheCard (placed 3 (0,6) card165))]))
def card295 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 5 (5,1) card34)), (cacheCard (placed 5 (6,0) card180))]))
def card296 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 7 (2,5) card0)), (cacheCard (placed 3 (0,5) card132))]))
def card297 : Card := (cacheCard (combine (5,3) #v[(cacheCard (placed 7 (6,4) card9)), (cacheCard (placed 0 (1,0) card142)), (cacheCard (placed 4 (2,6) card162))]))
def card298 : Card := (cacheCard (combine (5,3) #v[(cacheCard (placed 7 (6,3) card7)), (cacheCard (placed 0 (1,0) card142)), (cacheCard (placed 4 (2,6) card161))]))
def card299 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 4 (2,7) card12)), (cacheCard (placed 0 (0,2) card165)), (cacheCard (placed 2 (4,2) card264))]))
def card300 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 6 (2,6) card44)), (cacheCard (placed 6 (2,6) card52)), (cacheCard (placed 0 (1,1) card128)), (cacheCard (placed 3 (0,6) card155))]))
def card301 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 3 (0,3) card23)), (cacheCard (placed 0 (0,0) card55))]))
def card302 : Card := (cacheCard (combine (5,3) #v[(cacheCard (placed 7 (5,3) card6)), (cacheCard (placed 4 (1,6) card214))]))
def card303 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 4 (1,6) card55)), (cacheCard (placed 3 (0,4) card234))]))
def card304 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (1,1) card7)), (cacheCard (placed 1 (0,2) card8)), (cacheCard (placed 6 (2,6) card9))]))
def card305 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 4 (0,5) card124))]))
def card306 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 2 (4,1) card18)), (cacheCard (placed 7 (4,4) card207))]))
def card307 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 6 (4,2) card5)), (cacheCard (placed 0 (1,0) card131))]))
def card308 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 6 (1,6) card44)), (cacheCard (placed 6 (1,6) card52)), (cacheCard (placed 0 (0,2) card63)), (cacheCard (placed 6 (1,6) card158))]))
def card309 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (0,2) card19)), (cacheCard (placed 3 (0,4) card19)), (cacheCard (placed 2 (4,0) card115))]))
def card310 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 0 (0,1) card76))]))
def card311 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 4 (0,1) card4)), (cacheCard (combine (4,1) #v[(cacheCard (placed 4 (1,1) card5)), (cacheCard (placed 1 (0,1) card6))]))]))
def card312 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (placed 4 (0,2) card311))]))
def card313 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (placed 5 (4,0) card312))]))
def card314 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 3 (0,1) card6)), (cacheCard (placed 0 (1,0) card8)), (cacheCard (placed 1 (1,0) card17)), (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (placed 1 (1,0) card20))]))]))
def card315 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 1 (0,1) card314))]))
def card316 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 3 (0,5) card8)), (cacheCard (placed 1 (0,2) card314))]))
def card317 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 1 (0,4) card44)), (cacheCard (placed 2 (4,2) card60)), (cacheCard (placed 0 (2,0) card316))]))
def card318 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 4 (0,6) card10)), (cacheCard (placed 2 (1,2) card52)), (cacheCard (placed 6 (1,6) card52)), (cacheCard (placed 0 (0,2) card315))]))
def card319 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 3 (0,5) card52)), (cacheCard (placed 0 (2,0) card318))]))
def card320 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 0 (0,4) card5)), (cacheCard (placed 0 (2,0) card316))]))
def card321 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 4 (0,4) card5)), (cacheCard (placed 0 (0,0) card320))]))
def card322 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 3 (0,4) card7)), (cacheCard (placed 1 (0,3) card9)), (cacheCard (placed 0 (1,0) card321))]))
def card323 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 7 (5,4) card11)), (cacheCard (placed 2 (4,0) card320))]))
def card324 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 4 (0,6) card60)), (cacheCard (placed 0 (0,2) card237)), (cacheCard (placed 0 (0,2) card307)), (cacheCard (placed 2 (2,0) card316))]))
def card325 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 2 (4,4) card5)), (cacheCard (placed 0 (1,0) card321))]))
def card326 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 6 (4,4) card3)), (cacheCard (placed 0 (2,0) card321))]))
def card327 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 0 (1,3) card32)), (cacheCard (placed 2 (4,0) card321))]))
def card328 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (0,4) card7)), (cacheCard (placed 3 (0,5) card9)), (cacheCard (placed 0 (1,0) card321))]))
def card329 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 4 (0,6) card10)), (cacheCard (placed 2 (1,2) card52)), (cacheCard (placed 6 (1,6) card52)), (cacheCard (placed 0 (0,2) card315))]))
def card330 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 3 (0,4) card7)), (cacheCard (placed 1 (0,3) card9)), (cacheCard (placed 0 (1,0) card321))]))
def card331 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (0,3) card5)), (cacheCard (combine (3,2) #v[(cacheCard (placed 4 (0,3) card5)), (cacheCard (combine (3,5) #v[(cacheCard (placed 0 (2,2) card20)), (cacheCard (placed 6 (3,5) card29))]))]))]))
def card332 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (0,2) card9)), (cacheCard (placed 1 (0,3) card11)), (cacheCard (placed 2 (4,0) card331))]))
def card333 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,4) card3)), (cacheCard (combine (0,2) #v[(cacheCard (placed 7 (1,5) card0)), (cacheCard (placed 1 (0,0) card3))]))]))
def card334 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 0 (0,1) card101)), (cacheCard (placed 6 (1,6) card101)), (cacheCard (placed 0 (0,2) card333)), (cacheCard (placed 6 (1,5) card333))]))
def card335 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (0,2) card52)), (cacheCard (placed 2 (3,0) card334))]))
def card336 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (1,0) card6)), (cacheCard (placed 0 (0,1) card18)), (cacheCard (combine (2,3) #v[(cacheCard (placed 1 (1,0) card5)), (cacheCard (combine (1,5) #v[(cacheCard (placed 7 (1,5) card4)), (cacheCard (placed 2 (2,2) card37))]))]))]))
def card337 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 4 (1,6) card7)), (cacheCard (placed 3 (0,5) card143)), (cacheCard (placed 0 (0,2) card336))]))
def card338 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 6 (2,6) card44)), (cacheCard (placed 3 (0,6) card47)), (cacheCard (placed 0 (1,0) card337))]))
def card339 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 7 (4,4) card35)), (cacheCard (placed 2 (4,1) card336))]))
def card340 : Card := (cacheCard (combine (0,6) #v[(cacheCard (placed 2 (1,2) card139)), (cacheCard (placed 4 (0,6) card148)), (cacheCard (combine (1,6) #v[(cacheCard (placed 5 (1,3) card5)), (cacheCard (placed 0 (0,3) card91))]))]))
def card341 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 7 (6,4) card53)), (cacheCard (placed 5 (6,2) card57)), (cacheCard (placed 0 (2,0) card340))]))
def card342 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 4 (0,2) card5)), (cacheCard (combine (3,4) #v[(cacheCard (placed 2 (3,0) card11)), (cacheCard (placed 5 (4,1) card78))]))]))
def card343 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card5)), (cacheCard (placed 0 (0,0) card342))]))
def card344 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 2 (4,2) card5)), (cacheCard (placed 0 (1,0) card343))]))
def card345 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (1,1) card8)), (cacheCard (placed 1 (0,2) card11)), (cacheCard (placed 0 (0,0) card344))]))
def card346 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 6 (4,3) card0)), (cacheCard (placed 4 (0,5) card342))]))
def card347 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 0 (0,0) card20)), (cacheCard (placed 2 (1,0) card29)), (cacheCard (combine (0,3) #v[(cacheCard (placed 5 (1,0) card5)), (cacheCard (combine (2,3) #v[(cacheCard (placed 1 (1,0) card5)), (cacheCard (placed 3 (0,3) card94))]))]))]))
def card348 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (placed 1 (2,0) card311))]))]))
def card349 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 2 (4,1) card12)), (cacheCard (placed 0 (0,2) card165)), (cacheCard (placed 4 (0,6) card216)), (cacheCard (combine (4,3) #v[(cacheCard (placed 2 (4,2) card10)), (cacheCard (placed 3 (0,4) card54))]))]))
def card350 : Card := (cacheCard (combine (4,0) #v[(cacheCard (placed 4 (0,1) card4)), (cacheCard (combine (4,1) #v[(cacheCard (placed 3 (3,4) card1)), (cacheCard (placed 4 (1,1) card5))]))]))
def card351 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (placed 0 (0,0) card350))]))
def card352 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (0,1) card4)), (cacheCard (placed 0 (1,0) card351))]))
def card353 : Card := (cacheCard (combine (4,6) #v[(cacheCard (placed 6 (5,9) card95)), (cacheCard (placed 1 (0,2) card352))]))
def card354 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (placed 2 (3,0) card70))]))]))
def card355 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (2,1) card8)), (cacheCard (placed 7 (4,4) card354))]))
def card356 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 4 (3,6) card7)), (cacheCard (placed 1 (2,2) card8)), (cacheCard (combine (2,3) #v[(cacheCard (placed 2 (3,2) card21)), (cacheCard (placed 7 (4,5) card121))]))]))
def card357 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 5 (3,0) card5)), (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (3,0) card5)), (cacheCard (combine (1,3) #v[(cacheCard (placed 6 (4,3) card4)), (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,0) card3)), (cacheCard (placed 2 (4,3) card5))]))]))]))]))
def card358 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (1,1) card5)), (cacheCard (placed 3 (0,4) card357))]))
def card359 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 4 (0,6) card10)), (cacheCard (placed 2 (1,2) card52)), (cacheCard (placed 6 (1,6) card52)), (cacheCard (combine (1,6) #v[(cacheCard (placed 7 (1,6) card5)), (cacheCard (placed 2 (2,2) card9))]))]))
def card360 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 2 (2,0) card22)), (cacheCard (placed 1 (0,1) card347)), (cacheCard (combine (2,3) #v[(cacheCard (placed 7 (2,4) card5)), (cacheCard (placed 3 (0,4) card45))]))]))
def card361 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 2 (3,0) card15)), (cacheCard (placed 1 (0,0) card57)), (cacheCard (placed 1 (1,1) card360))]))
def card362 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 0 (0,3) card2)), (cacheCard (combine (1,4) #v[(cacheCard (placed 6 (4,4) card2)), (cacheCard (placed 6 (1,6) card53))]))]))
def card363 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 0 (3,1) card44)), (cacheCard (placed 0 (0,0) card362))]))
def card364 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 0 (3,1) card52)), (cacheCard (placed 0 (0,0) card362))]))
def card365 : Card := (cacheCard (combine (1,6) #v[(cacheCard (placed 0 (1,2) card6)), (cacheCard (combine (0,3) #v[(cacheCard (placed 7 (1,6) card5)), (cacheCard (combine (0,4) #v[(cacheCard (placed 5 (1,0) card0)), (cacheCard (placed 7 (1,7) card0))]))]))]))
def card366 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 6 (1,5) card6)), (cacheCard (placed 2 (2,0) card365))]))
def card367 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 1 (0,2) card8)), (cacheCard (placed 6 (2,6) card9)), (cacheCard (placed 0 (0,0) card366))]))
def card368 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 4 (3,7) card14)), (cacheCard (placed 4 (3,7) card31)), (cacheCard (placed 5 (6,2) card181)), (cacheCard (placed 0 (3,1) card189)), (cacheCard (placed 5 (7,2) card257)), (cacheCard (placed 4 (1,6) card355)), (cacheCard (placed 6 (5,7) card367))]))
def card369 : Card := (cacheCard (combine (1,6) #v[(cacheCard (placed 6 (1,7) card7)), (cacheCard (placed 0 (0,2) card19)), (cacheCard (placed 6 (1,8) card187)), (cacheCard (combine (1,7) #v[(cacheCard (placed 2 (1,3) card6)), (cacheCard (placed 1 (0,4) card8)), (cacheCard (placed 0 (0,2) card365))]))]))
def card370 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 3 (0,1) card6)), (cacheCard (combine (1,2) #v[(cacheCard (placed 1 (1,1) card16)), (cacheCard (placed 0 (0,0) card210))]))]))
def card371 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 1 (0,1) card6)), (cacheCard (placed 0 (1,0) card8)), (cacheCard (placed 0 (1,0) card370)), (cacheCard (combine (5,1) #v[(cacheCard (placed 3 (1,1) card6)), (cacheCard (combine (2,2) #v[(cacheCard (placed 0 (1,0) card210)), (cacheCard (combine (3,2) #v[(cacheCard (placed 2 (6,1) card0)), (cacheCard (placed 0 (0,1) card5))]))]))]))]))
def card372 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 3 (0,4) card96)), (cacheCard (combine (4,4) #v[(cacheCard (placed 1 (0,1) card81)), (cacheCard (placed 0 (1,0) card351))]))]))
def card373 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (placed 0 (0,0) card372))]))
def card374 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (0,1) card4)), (cacheCard (combine (4,1) #v[(cacheCard (placed 7 (4,4) card1)), (cacheCard (placed 0 (1,1) card5))]))]))
def card375 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (placed 0 (0,0) card374))]))
def card376 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (combine (2,4) #v[(cacheCard (placed 3 (2,4) card2)), (cacheCard (placed 5 (4,0) card77))]))]))
def card377 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (1,0) card7)), (cacheCard (placed 0 (0,0) card9)), (cacheCard (placed 1 (0,1) card376))]))
def card378 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 4 (0,2) card5)), (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card5)), (cacheCard (placed 0 (2,0) card18))]))]))
def card379 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 3 (0,2) card21)), (cacheCard (placed 1 (0,1) card37)), (cacheCard (placed 0 (0,0) card378))]))
def card380 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (placed 1 (1,0) card379))]))]))
def card381 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (combine (4,0) #v[(cacheCard (placed 4 (0,1) card4)), (cacheCard (combine (4,1) #v[(cacheCard (placed 3 (3,4) card0)), (cacheCard (placed 4 (1,1) card5))]))]))]))
def card382 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (1,0) card22)), (cacheCard (placed 5 (4,1) card381))]))
def card383 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 4 (0,2) card5)), (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card5)), (cacheCard (placed 4 (2,5) card219))]))]))
def card384 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (2,1) card8)), (cacheCard (placed 7 (5,4) card383))]))
def card385 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (0,1) card115)), (cacheCard (placed 7 (5,4) card383))]))
def card386 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 4 (0,2) card5)), (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card5)), (cacheCard (combine (3,4) #v[(cacheCard (placed 5 (3,1) card5)), (cacheCard (placed 2 (3,0) card11))]))]))]))
def card387 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 1 (0,1) card200)), (cacheCard (placed 1 (1,0) card376)), (cacheCard (placed 1 (0,0) card386))]))
def card388 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 2 (2,0) card11)), (cacheCard (placed 0 (0,1) card387))]))
def card389 : Card := (cacheCard (combine (0,4) #v[(cacheCard (placed 0 (0,0) card6)), (cacheCard (placed 0 (0,1) card21)), (cacheCard (placed 0 (0,1) card27)), (cacheCard (combine (1,3) #v[(cacheCard (placed 1 (0,0) card5)), (cacheCard (placed 0 (0,1) card23))]))]))
def card390 : Card := (cacheCard (combine (1,7) #v[(cacheCard (placed 2 (1,3) card11)), (cacheCard (placed 0 (0,4) card17)), (cacheCard (placed 6 (1,7) card389))]))
def card391 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (1,1) card5)), (cacheCard (combine (2,1) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (combine (3,1) #v[(cacheCard (placed 2 (4,1) card0)), (cacheCard (placed 4 (2,4) card36))]))]))]))
def card392 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 6 (4,3) card0)), (cacheCard (placed 0 (0,0) card391))]))
def card393 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (1,0) card11)), (cacheCard (placed 0 (0,1) card20)), (cacheCard (placed 4 (0,5) card391))]))
def card394 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (0,1) card17)), (cacheCard (placed 0 (0,0) card241)), (cacheCard (placed 0 (0,0) card392))]))
def card395 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card5)), (cacheCard (combine (3,1) #v[(cacheCard (placed 4 (0,2) card5)), (cacheCard (placed 0 (1,0) card217))]))]))
def card396 : Card := (cacheCard (combine (2,6) #v[(cacheCard (placed 2 (2,2) card7)), (cacheCard (placed 2 (3,2) card9)), (cacheCard (placed 3 (0,6) card395))]))
def card397 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card8)), (cacheCard (placed 0 (0,0) card161)), (cacheCard (placed 0 (0,0) card162)), (cacheCard (placed 0 (0,1) card395))]))
def card398 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,0) card171)), (cacheCard (placed 0 (0,2) card197)), (cacheCard (placed 4 (0,4) card197)), (cacheCard (placed 0 (0,0) card285)), (cacheCard (placed 0 (0,1) card395))]))
def card399 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 0 (1,1) card12)), (cacheCard (placed 0 (0,1) card135)), (cacheCard (placed 1 (0,2) card181)), (cacheCard (placed 0 (0,0) card396)), (cacheCard (placed 4 (0,8) card396))]))
def card400 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 6 (4,2) card5)), (cacheCard (placed 0 (1,0) card395))]))
def card401 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 6 (4,4) card3)), (cacheCard (placed 4 (2,7) card397))]))
def card402 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 3 (0,4) card38)), (cacheCard (combine (2,4) #v[(cacheCard (placed 5 (3,0) card0)), (cacheCard (placed 1 (1,1) card5))]))]))
def card403 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 0 (0,0) card86)), (cacheCard (combine (2,5) #v[(cacheCard (placed 5 (3,1) card4)), (cacheCard (placed 5 (4,2) card381))]))]))
def card404 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (1,1) card5)), (cacheCard (combine (2,1) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (combine (3,1) #v[(cacheCard (placed 2 (4,1) card0)), (cacheCard (placed 0 (0,0) card354))]))]))]))
def card405 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 7 (1,5) card0)), (cacheCard (placed 0 (0,0) card404))]))
def card406 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (0,0) card199)), (cacheCard (placed 4 (0,6) card199)), (cacheCard (placed 0 (0,1) card405)), (cacheCard (placed 4 (0,5) card405))]))
def card407 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (1,0) card7)), (cacheCard (placed 1 (0,1) card8)), (cacheCard (placed 2 (2,0) card9)), (cacheCard (combine (0,4) #v[(cacheCard (placed 5 (1,1) card5)), (cacheCard (placed 4 (0,5) card404))]))]))
def card408 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 6 (1,6) card44)), (cacheCard (placed 0 (0,1) card127)), (cacheCard (placed 4 (0,6) card407))]))
def card409 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 6 (1,6) card44)), (cacheCard (placed 0 (0,1) card127)), (cacheCard (placed 4 (0,6) card407))]))
def card410 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 0 (0,2) card10)), (cacheCard (placed 2 (2,1) card12)), (cacheCard (placed 4 (0,7) card12)), (cacheCard (placed 4 (0,6) card407))]))
def card411 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 6 (1,6) card15)), (cacheCard (placed 4 (0,7) card65)), (cacheCard (placed 4 (0,6) card407))]))
def card412 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (combine (3,1) #v[(cacheCard (placed 2 (4,1) card0)), (cacheCard (placed 0 (0,0) card358))]))]))
def card413 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (1,1) card5)), (cacheCard (combine (2,3) #v[(cacheCard (placed 7 (2,4) card5)), (cacheCard (placed 1 (0,1) card45))]))]))
def card414 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 3 (1,5) card0)), (cacheCard (placed 0 (0,0) card413))]))
def card415 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 4 (0,2) card2)), (cacheCard (placed 2 (5,0) card414))]))
def card416 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card5)), (cacheCard (combine (3,1) #v[(cacheCard (placed 4 (0,2) card5)), (cacheCard (placed 4 (0,5) card239))]))]))
def card417 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 2 (4,2) card0)), (cacheCard (placed 0 (0,0) card416))]))
def card418 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (2,0) card8)), (cacheCard (placed 5 (4,0) card25)), (cacheCard (placed 0 (2,0) card41)), (cacheCard (combine (2,2) #v[(cacheCard (placed 0 (0,2) card5)), (cacheCard (placed 2 (3,0) card29))]))]))]))]))
def card419 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (placed 1 (0,1) card418))]))
def card420 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 2 (4,1) card0)), (cacheCard (placed 0 (0,0) card418))]))
def card421 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,1) card8)), (cacheCard (placed 0 (1,0) card11)), (cacheCard (placed 0 (0,0) card419))]))
def card422 : Card := (cacheCard (combine (2,2) #v[(cacheCard (placed 0 (0,2) card0)), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (1,0) card69)), (cacheCard (placed 5 (5,1) card413))]))]))
def card423 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 4 (1,5) card383)), (cacheCard (combine (1,2) #v[(cacheCard (placed 6 (4,3) card5)), (cacheCard (placed 0 (0,0) card244))]))]))
def card424 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (3,0) card7)), (cacheCard (placed 5 (4,1) card25)), (cacheCard (combine (4,2) #v[(cacheCard (placed 4 (0,3) card2)), (cacheCard (placed 0 (3,0) card11))]))]))
def card425 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 6 (4,3) card2)), (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (0,2) card2)), (cacheCard (placed 0 (3,0) card44))]))]))
def card426 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 2 (2,0) card11)), (cacheCard (combine (3,3) #v[(cacheCard (placed 6 (5,3) card0)), (cacheCard (placed 2 (4,1) card221))]))]))
def card427 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (1,1) card5)), (cacheCard (combine (0,4) #v[(cacheCard (placed 5 (1,1) card5)), (cacheCard (combine (0,1) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (combine (3,1) #v[(cacheCard (placed 3 (0,2) card17)), (cacheCard (placed 3 (0,4) card357)), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (0,1) card4)), (cacheCard (combine (4,1) #v[(cacheCard (placed 0 (1,1) card5)), (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,4) card70)), (cacheCard (placed 0 (1,0) card226))]))]))])), (cacheCard (combine (3,0) #v[(cacheCard (placed 3 (0,1) card52)), (cacheCard (combine (2,3) #v[(cacheCard (placed 3 (2,4) card2)), (cacheCard (combine (3,3) #v[(cacheCard (placed 2 (4,3) card0)), (cacheCard (placed 5 (3,0) card2))]))]))]))]))]))]))]))]))
def card428 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (1,0) card7)), (cacheCard (placed 1 (0,1) card8)), (cacheCard (placed 2 (2,0) card9)), (cacheCard (placed 4 (0,5) card427))]))
def card429 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 2 (3,0) card7)), (cacheCard (placed 1 (2,1) card8)), (cacheCard (placed 0 (2,0) card9)), (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (0,2) card2)), (cacheCard (placed 5 (5,1) card46))]))]))
def card430 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 4 (2,7) card14)), (cacheCard (placed 4 (2,7) card31)), (cacheCard (placed 0 (0,2) card58)), (cacheCard (placed 4 (0,6) card100)), (cacheCard (placed 0 (0,2) card429))]))
def card431 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 7 (5,4) card160)), (cacheCard (placed 2 (5,0) card243)), (cacheCard (placed 0 (1,1) card429))]))
def card432 : Card := (cacheCard (combine (4,0) #v[(cacheCard (placed 4 (0,1) card4)), (cacheCard (combine (4,1) #v[(cacheCard (placed 4 (1,1) card5)), (cacheCard (placed 5 (5,0) card146))]))]))
def card433 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (0,0) card86)), (cacheCard (placed 5 (4,1) card432))]))
def card434 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 5 (5,1) card80)), (cacheCard (combine (5,1) #v[(cacheCard (placed 4 (1,2) card1)), (cacheCard (placed 2 (5,0) card10))])), (cacheCard (combine (4,4) #v[(cacheCard (placed 5 (5,1) card8)), (cacheCard (placed 0 (3,1) card41)), (cacheCard (placed 1 (1,1) card253)), (cacheCard (placed 5 (7,1) card256)), (cacheCard (placed 0 (3,1) card336))]))]))
def card435 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 3 (1,3) card130)), (cacheCard (placed 3 (0,3) card140)), (cacheCard (placed 4 (0,5) card183)), (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (0,3) card52)), (cacheCard (placed 5 (4,2) card76)), (cacheCard (combine (3,2) #v[(cacheCard (placed 4 (0,3) card0)), (cacheCard (placed 2 (4,1) card212))])), (cacheCard (combine (3,5) #v[(cacheCard (placed 2 (4,2) card76)), (cacheCard (placed 4 (3,5) card130)), (cacheCard (combine (3,2) #v[(cacheCard (placed 3 (3,5) card5)), (cacheCard (placed 2 (3,1) card11))]))]))]))]))
def card436 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 0 (2,2) card10)), (cacheCard (placed 3 (1,6) card47)), (cacheCard (placed 6 (3,6) card52)), (cacheCard (placed 5 (6,2) card435))]))
def card437 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (2,2) card10)), (cacheCard (placed 3 (1,6) card47)), (cacheCard (placed 6 (3,6) card52)), (cacheCard (placed 5 (6,2) card435))]))
def card438 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 7 (6,4) card10)), (cacheCard (placed 6 (6,5) card47)), (cacheCard (placed 0 (2,0) card436))]))
def card439 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 4 (0,4) card5)), (cacheCard (combine (3,2) #v[(cacheCard (placed 7 (4,5) card251)), (cacheCard (placed 7 (4,5) card432)), (cacheCard (combine (4,2) #v[(cacheCard (placed 6 (4,2) card2)), (cacheCard (placed 3 (3,5) card5))])), (cacheCard (combine (2,1) #v[(cacheCard (placed 7 (3,5) card4)), (cacheCard (combine (3,1) #v[(cacheCard (placed 7 (3,4) card5)), (cacheCard (combine (4,1) #v[(cacheCard (placed 3 (3,4) card5)), (cacheCard (placed 2 (4,1) card5))]))]))]))]))]))
def card440 : Card := (cacheCard (combine (0,1) #v[(cacheCard (placed 0 (0,1) card18)), (cacheCard (combine (1,1) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (placed 7 (5,4) card439))]))]))
def card441 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (0,2) card28)), (cacheCard (placed 2 (4,1) card58)), (cacheCard (placed 0 (0,0) card440))]))
def card442 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 7 (5,4) card40)), (cacheCard (placed 7 (5,4) card149)), (cacheCard (placed 0 (0,0) card440))]))
def card443 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (combine (0,1) #v[(cacheCard (placed 7 (1,4) card5)), (cacheCard (combine (3,1) #v[(cacheCard (placed 0 (0,1) card4)), (cacheCard (combine (4,0) #v[(cacheCard (placed 4 (0,1) card4)), (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (1,1) card5)), (cacheCard (combine (4,1) #v[(cacheCard (placed 4 (1,1) card5)), (cacheCard (combine (3,3) #v[(cacheCard (placed 5 (4,0) card5)), (cacheCard (combine (5,3) #v[(cacheCard (placed 2 (5,3) card3)), (cacheCard (placed 1 (4,0) card5))]))]))]))]))]))]))]))]))
def card444 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (1,0) card7)), (cacheCard (placed 1 (0,1) card8)), (cacheCard (placed 2 (2,0) card9)), (cacheCard (placed 4 (0,5) card443))]))
def card445 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (2,0) card20)), (cacheCard (placed 2 (3,0) card29)), (cacheCard (placed 0 (1,0) card221))]))]))
def card446 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 3 (1,6) card5)), (cacheCard (combine (2,4) #v[(cacheCard (placed 3 (1,7) card0)), (cacheCard (placed 4 (0,5) card72))]))]))
def card447 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (1,1) card5)), (cacheCard (combine (2,3) #v[(cacheCard (placed 1 (1,0) card0)), (cacheCard (placed 1 (0,1) card445))]))]))
def card448 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 6 (4,6) card56)), (cacheCard (placed 1 (0,2) card447))]))
def card449 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (1,4) card10)), (cacheCard (placed 1 (1,3) card27)), (cacheCard (placed 3 (1,4) card48)), (cacheCard (placed 3 (1,4) card63)), (cacheCard (placed 0 (0,0) card448))]))
def card450 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 6 (5,4) card0)), (cacheCard (placed 4 (0,7) card448))]))
def card451 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (1,0) card11)), (cacheCard (combine (2,3) #v[(cacheCard (placed 6 (4,3) card0)), (cacheCard (placed 0 (0,0) card402))]))]))
def card452 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 7 (6,4) card52)), (cacheCard (placed 0 (2,0) card317)), (cacheCard (combine (6,4) #v[(cacheCard (placed 6 (6,4) card5)), (cacheCard (placed 0 (3,1) card55))]))]))
def card453 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (combine (3,3) #v[(cacheCard (placed 2 (3,0) card21)), (cacheCard (placed 0 (2,0) card37)), (cacheCard (placed 5 (4,0) card354))]))]))]))
def card454 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 1 (1,1) card5)), (cacheCard (placed 3 (0,4) card453))]))
def card455 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 0 (0,0) card8)), (cacheCard (placed 1 (0,1) card16)), (cacheCard (placed 4 (0,2) card24)), (cacheCard (placed 0 (0,0) card453))]))
def card456 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (1,1) card5)), (cacheCard (placed 3 (0,4) card453))]))
def card457 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (1,0) card7)), (cacheCard (placed 1 (0,1) card8)), (cacheCard (placed 2 (2,0) card9)), (cacheCard (placed 4 (0,5) card456))]))
def card458 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (1,0) card7)), (cacheCard (placed 0 (0,0) card9)), (cacheCard (placed 0 (0,0) card62)), (cacheCard (placed 0 (0,0) card456))]))
def card459 : Card := (cacheCard (combine (1,6) #v[(cacheCard (placed 2 (2,2) card12)), (cacheCard (placed 2 (2,2) card13)), (cacheCard (placed 6 (2,8) card33)), (cacheCard (placed 2 (2,2) card189)), (cacheCard (placed 4 (0,8) card192)), (cacheCard (placed 2 (2,1) card369)), (cacheCard (placed 0 (0,3) card457)), (cacheCard (placed 4 (0,7) card458))]))
def card460 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (0,1) card13)), (cacheCard (placed 2 (2,1) card14)), (cacheCard (placed 0 (0,1) card33)), (cacheCard (placed 4 (0,6) card457)), (cacheCard (placed 0 (0,2) card458))]))
def card461 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 5 (4,1) card28)), (cacheCard (placed 0 (0,0) card100)), (cacheCard (placed 0 (0,0) card429)), (cacheCard (placed 0 (2,0) card457))]))
def card462 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 2 (2,1) card13)), (cacheCard (placed 6 (2,7) card14)), (cacheCard (placed 4 (0,7) card31)), (cacheCard (placed 2 (2,1) card189)), (cacheCard (placed 4 (0,7) card367)), (cacheCard (placed 4 (0,6) card428)), (cacheCard (placed 0 (0,2) card457))]))
def card463 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 1 (0,2) card147)), (cacheCard (placed 1 (0,2) card167)), (cacheCard (combine (2,6) #v[(cacheCard (placed 1 (1,2) card4)), (cacheCard (placed 1 (0,3) card348))])), (cacheCard (placed 0 (0,0) card353)), (cacheCard (placed 4 (3,8) card460))]))
def card464 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 2 (1,1) card15)), (cacheCard (combine (2,2) #v[(cacheCard (placed 2 (4,2) card0)), (cacheCard (combine (1,1) #v[(cacheCard (placed 5 (1,0) card0)), (cacheCard (placed 0 (1,0) card11))]))])), (cacheCard (combine (1,5) #v[(cacheCard (placed 2 (1,2) card29)), (cacheCard (placed 3 (0,5) card38))]))]))
def card465 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 3 (0,4) card25)), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (3,1) card39)), (cacheCard (placed 0 (3,1) card42)), (cacheCard (combine (0,4) #v[(cacheCard (placed 5 (1,1) card5)), (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (1,1) card5)), (cacheCard (combine (3,4) #v[(cacheCard (placed 4 (0,4) card4)), (cacheCard (placed 0 (0,4) card4))]))]))]))]))]))
def card466 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (1,0) card7)), (cacheCard (placed 1 (0,1) card8)), (cacheCard (placed 0 (0,0) card9)), (cacheCard (placed 0 (0,0) card465))]))
def card467 : Card := (cacheCard (combine (4,6) #v[(cacheCard (placed 6 (5,8) card31)), (cacheCard (placed 1 (1,4) card398)), (cacheCard (placed 6 (5,7) card444)), (cacheCard (placed 6 (5,7) card466))]))
def card468 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (0,3) card28)), (cacheCard (placed 1 (0,3) card126)), (cacheCard (placed 3 (0,5) card126)), (cacheCard (combine (3,5) #v[(cacheCard (placed 3 (0,5) card54)), (cacheCard (combine (3,3) #v[(cacheCard (placed 6 (4,6) card71)), (cacheCard (placed 2 (4,2) card71)), (cacheCard (placed 6 (4,6) card73)), (cacheCard (placed 2 (4,2) card73))])), (cacheCard (combine (3,3) #v[(cacheCard (placed 2 (4,2) card71)), (cacheCard (placed 6 (4,6) card73)), (cacheCard (placed 6 (5,6) card426)), (cacheCard (combine (3,6) #v[(cacheCard (placed 1 (2,3) card8)), (cacheCard (placed 2 (4,3) card17)), (cacheCard (placed 2 (4,1) card75)), (cacheCard (placed 0 (3,1) card266)), (cacheCard (placed 0 (2,2) card447))]))]))]))]))
def card469 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 3 (0,4) card78)), (cacheCard (combine (2,3) #v[(cacheCard (placed 3 (0,3) card101)), (cacheCard (placed 5 (2,1) card314))]))]))
def card470 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (1,0) card319)), (cacheCard (placed 4 (1,7) card335)), (cacheCard (combine (2,3) #v[(cacheCard (placed 6 (3,6) card54)), (cacheCard (placed 6 (4,6) card78))])), (cacheCard (combine (3,6) #v[(cacheCard (placed 4 (1,8) card56)), (cacheCard (combine (2,3) #v[(cacheCard (placed 7 (3,6) card2)), (cacheCard (placed 6 (4,6) card78))]))]))]))
def card471 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card5)), (cacheCard (combine (3,4) #v[(cacheCard (placed 2 (3,0) card11)), (cacheCard (placed 5 (4,1) card354))]))]))
def card472 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (1,2) card5)), (cacheCard (placed 2 (4,0) card471))]))
def card473 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 6 (4,2) card5)), (cacheCard (placed 0 (0,0) card472))]))
def card474 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 1 (0,2) card7)), (cacheCard (placed 0 (1,1) card8)), (cacheCard (placed 3 (0,3) card9)), (cacheCard (placed 2 (5,0) card473))]))
def card475 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 4 (1,7) card13)), (cacheCard (placed 6 (3,7) card14)), (cacheCard (placed 4 (1,7) card31)), (cacheCard (placed 4 (0,8) card396)), (cacheCard (placed 1 (0,2) card474))]))
def card476 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 0 (2,1) card12)), (cacheCard (placed 2 (4,1) card12)), (cacheCard (placed 4 (2,7) card12)), (cacheCard (placed 2 (4,2) card264)), (cacheCard (placed 3 (1,6) card474))]))
def card477 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 1 (0,2) card7)), (cacheCard (placed 1 (0,1) card9)), (cacheCard (placed 1 (0,1) card62)), (cacheCard (placed 0 (0,0) card473))]))
def card478 : Card := (cacheCard (combine (2,2) #v[(cacheCard (placed 6 (4,2) card5)), (cacheCard (placed 0 (0,0) card472))]))
def card479 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 6 (4,7) card14)), (cacheCard (placed 4 (2,7) card31)), (cacheCard (placed 1 (1,2) card181)), (cacheCard (placed 4 (2,7) card367)), (cacheCard (combine (3,2) #v[(cacheCard (placed 7 (4,5) card8)), (cacheCard (placed 5 (5,2) card386))])), (cacheCard (placed 5 (6,2) card435)), (cacheCard (placed 1 (1,2) card474))]))
def card480 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 4 (2,7) card13)), (cacheCard (placed 4 (2,7) card14)), (cacheCard (placed 2 (4,1) card192)), (cacheCard (placed 1 (0,1) card298)), (cacheCard (placed 7 (6,6) card435)), (cacheCard (placed 7 (5,6) card474)), (cacheCard (placed 5 (5,2) card477))]))
def card481 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 0 (1,1) card13)), (cacheCard (placed 2 (3,1) card14)), (cacheCard (placed 0 (1,1) card33)), (cacheCard (placed 4 (1,6) card457)), (cacheCard (placed 1 (0,2) card477))]))
def card482 : Card := (cacheCard (combine (2,2) #v[(cacheCard (placed 1 (0,2) card7)), (cacheCard (placed 0 (1,1) card24)), (cacheCard (placed 1 (0,1) card124)), (cacheCard (placed 0 (0,0) card472))]))
def card483 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 0 (1,1) card13)), (cacheCard (placed 2 (3,1) card14)), (cacheCard (placed 0 (1,1) card33)), (cacheCard (placed 0 (1,2) card458)), (cacheCard (placed 3 (0,6) card474))]))
def card484 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 1 (0,2) card81)), (cacheCard (placed 4 (0,8) card204)), (cacheCard (combine (3,2) #v[(cacheCard (combine (2,2) #v[(cacheCard (placed 3 (1,5) card5)), (cacheCard (placed 3 (0,5) card96))])), (cacheCard (combine (4,4) #v[(cacheCard (placed 0 (3,2) card18)), (cacheCard (placed 4 (3,7) card33)), (cacheCard (placed 6 (4,5) card130))])), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (3,1) card39)), (cacheCard (placed 2 (5,0) card268)), (cacheCard (combine (2,2) #v[(cacheCard (placed 3 (1,5) card5)), (cacheCard (placed 3 (0,5) card223))]))]))])), (cacheCard (combine (2,4) #v[(cacheCard (placed 5 (2,2) card314)), (cacheCard (combine (4,4) #v[(cacheCard (placed 0 (1,2) card58)), (cacheCard (placed 6 (5,6) card168)), (cacheCard (placed 6 (4,5) card357))]))]))]))
def card485 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,5) card313)), (cacheCard (placed 0 (0,1) card469)), (cacheCard (combine (4,5) #v[(cacheCard (placed 1 (0,2) card81)), (cacheCard (placed 4 (0,8) card204)), (cacheCard (placed 0 (0,0) card353)), (cacheCard (placed 4 (2,8) card481))])), (cacheCard (combine (4,5) #v[(cacheCard (placed 1 (0,2) card81)), (cacheCard (placed 1 (0,2) card167)), (cacheCard (combine (4,4) #v[(cacheCard (placed 2 (5,1) card14)), (cacheCard (placed 0 (3,1) card189)), (cacheCard (placed 2 (5,1) card192)), (cacheCard (placed 2 (5,1) card193)), (cacheCard (placed 0 (3,2) card457)), (cacheCard (placed 3 (2,6) card477))])), (cacheCard (combine (2,4) #v[(cacheCard (placed 0 (1,1) card166)), (cacheCard (placed 5 (2,2) card314))]))])), (cacheCard (placed 0 (0,0) card484))]))
def card486 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (0,2) card19)), (cacheCard (placed 1 (0,2) card84)), (cacheCard (placed 0 (1,2) card314)), (cacheCard (combine (1,2) #v[(cacheCard (placed 6 (4,3) card5)), (cacheCard (combine (4,2) #v[(cacheCard (placed 4 (1,3) card5)), (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (4,3) card5)), (cacheCard (placed 3 (0,4) card156))]))]))]))]))
def card487 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 5 (3,0) card5)), (cacheCard (placed 0 (0,0) card486))]))
def card488 : Card := (cacheCard (combine (4,6) #v[(cacheCard (placed 6 (5,9) card95)), (cacheCard (combine (2,6) #v[(cacheCard (placed 1 (1,2) card4)), (cacheCard (combine (1,6) #v[(cacheCard (placed 1 (1,3) card5)), (cacheCard (placed 3 (0,6) card34))]))])), (cacheCard (combine (4,4) #v[(cacheCard (placed 0 (4,2) card7)), (cacheCard (placed 2 (5,2) card9)), (cacheCard (placed 0 (1,3) card357))]))]))
def card489 : Card := (cacheCard (combine (3,8) #v[(cacheCard (placed 2 (5,4) card313)), (cacheCard (placed 4 (1,10) card470)), (cacheCard (combine (5,6) #v[(cacheCard (placed 0 (2,5) card5)), (cacheCard (combine (5,7) #v[(cacheCard (placed 0 (4,4) card10)), (cacheCard (placed 6 (5,8) card44)), (cacheCard (placed 0 (4,4) card63)), (cacheCard (placed 3 (2,8) card486))]))])), (cacheCard (combine (5,8) #v[(cacheCard (placed 0 (2,4) card81)), (cacheCard (placed 0 (2,4) card167)), (cacheCard (placed 5 (8,6) card481)), (cacheCard (placed 1 (0,4) card488))]))]))
def card490 : Card := (cacheCard (combine (5,7) #v[(cacheCard (placed 0 (2,3) card321)), (cacheCard (placed 4 (2,11) card321)), (cacheCard (placed 1 (0,6) card485)), (cacheCard (placed 3 (0,8) card485)), (cacheCard (placed 0 (0,2) card489)), (cacheCard (placed 4 (0,12) card489))]))
def card491 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 2 (4,0) card44)), (cacheCard (placed 0 (1,1) card270)), (cacheCard (combine (5,3) #v[(cacheCard (placed 3 (2,4) card60)), (cacheCard (placed 7 (6,4) card60)), (cacheCard (placed 4 (3,4) card83)), (cacheCard (placed 1 (1,2) card106))])), (cacheCard (combine (5,3) #v[(cacheCard (placed 3 (2,4) card60)), (cacheCard (placed 7 (5,3) card70)), (cacheCard (placed 4 (2,5) card345))]))]))
def card492 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (4,4) card78)), (cacheCard (combine (1,3) #v[(cacheCard (placed 7 (1,5) card0)), (cacheCard (combine (2,3) #v[(cacheCard (placed 6 (4,3) card0)), (cacheCard (placed 5 (4,1) card32))]))]))]))
def card493 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,0) card87)), (cacheCard (placed 5 (4,1) card197)), (cacheCard (placed 0 (0,0) card492))]))
def card494 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (3,0) card7)), (cacheCard (placed 0 (0,0) card87)), (cacheCard (placed 0 (0,0) card286)), (cacheCard (placed 0 (0,0) card492))]))
def card495 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 0 (1,2) card10)), (cacheCard (placed 2 (2,2) card52)), (cacheCard (placed 6 (2,6) card52)), (cacheCard (combine (2,2) #v[(cacheCard (placed 5 (2,2) card5)), (cacheCard (placed 4 (0,5) card221))]))]))
def card496 : Card := (cacheCard (combine (1,1) #v[(cacheCard (placed 3 (0,4) card5)), (cacheCard (combine (1,2) #v[(cacheCard (placed 3 (0,5) card0)), (cacheCard (placed 1 (0,1) card30))]))]))
def card497 : Card := (cacheCard (combine (0,3) #v[(cacheCard (placed 1 (0,1) card5)), (cacheCard (placed 0 (0,0) card496))]))
def card498 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (1,1) card114)), (cacheCard (placed 2 (4,0) card496))]))
def card499 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 2 (2,0) card15)), (cacheCard (combine (4,3) #v[(cacheCard (placed 6 (4,3) card1)), (cacheCard (placed 0 (1,1) card347))])), (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (0,2) card43)), (cacheCard (placed 0 (2,0) card52))]))]))
def card500 : Card := (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (1,5) card0)), (cacheCard (combine (1,1) #v[(cacheCard (placed 5 (1,1) card5)), (cacheCard (placed 0 (0,0) card146))]))]))
def card501 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 2 (4,3) card2)), (cacheCard (placed 0 (0,0) card500))]))
def card502 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (0,3) card7)), (cacheCard (placed 4 (1,5) card69)), (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (0,3) card11)), (cacheCard (placed 4 (2,6) card53))]))]))
def card503 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 4 (0,3) card0)), (cacheCard (placed 0 (0,0) card502))]))
def card504 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 7 (4,4) card32)), (cacheCard (combine (3,5) #v[(cacheCard (placed 0 (3,1) card6)), (cacheCard (placed 0 (2,2) card18)), (cacheCard (combine (2,3) #v[(cacheCard (placed 7 (3,6) card0)), (cacheCard (placed 1 (0,1) card56))]))]))]))
def card505 : Card := (cacheCard (combine (4,1) #v[(cacheCard (placed 3 (0,1) card6)), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (1,1) card5)), (cacheCard (placed 0 (1,0) card350))])), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (1,1) card5)), (cacheCard (combine (4,3) #v[(cacheCard (placed 7 (4,4) card5)), (cacheCard (placed 0 (4,1) card6))]))]))]))
def card506 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 4 (1,6) card44)), (cacheCard (placed 0 (0,1) card67)), (cacheCard (combine (1,2) #v[(cacheCard (placed 4 (1,6) card7)), (cacheCard (placed 3 (0,5) card32))]))]))
def card507 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (0,3) card44)), (cacheCard (placed 0 (0,0) card274)), (cacheCard (placed 2 (4,0) card506)), (cacheCard (combine (3,5) #v[(cacheCard (placed 6 (4,7) card33)), (cacheCard (placed 6 (3,6) card44)), (cacheCard (placed 3 (1,6) card47))]))]))
def card508 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (0,2) card12)), (cacheCard (placed 1 (0,2) card13)), (cacheCard (placed 1 (0,2) card14)), (cacheCard (placed 0 (0,0) card297)), (cacheCard (placed 0 (0,0) card298)), (cacheCard (placed 4 (1,5) card474)), (cacheCard (placed 0 (1,0) card507))]))
def card509 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,4) card12)), (cacheCard (placed 1 (0,2) card127)), (cacheCard (placed 1 (0,2) card128)), (cacheCard (placed 0 (1,1) card474)), (cacheCard (placed 0 (1,0) card507))]))
def card510 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (1,4) card10)), (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (5,3) card0)), (cacheCard (placed 5 (4,3) card138))])), (cacheCard (placed 0 (1,0) card507))]))
def card511 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 6 (1,5) card15)), (cacheCard (combine (3,4) #v[(cacheCard (placed 2 (4,0) card13)), (cacheCard (placed 2 (4,0) card14)), (cacheCard (placed 0 (0,1) card240)), (cacheCard (combine (4,4) #v[(cacheCard (placed 6 (4,4) card2)), (cacheCard (placed 0 (3,1) card44))])), (cacheCard (combine (2,4) #v[(cacheCard (placed 6 (4,4) card0)), (cacheCard (combine (3,5) #v[(cacheCard (placed 0 (3,1) card7)), (cacheCard (placed 2 (4,1) card9)), (cacheCard (placed 0 (1,2) card221))]))]))]))]))
def card512 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (1,3) card74)), (cacheCard (placed 0 (0,1) card108)), (cacheCard (combine (3,3) #v[(cacheCard (placed 2 (4,1) card69)), (cacheCard (placed 0 (1,1) card416))])), (cacheCard (combine (4,4) #v[(cacheCard (placed 3 (1,4) card30)), (cacheCard (placed 4 (1,7) card59)), (cacheCard (placed 0 (1,1) card511)), (cacheCard (combine (4,5) #v[(cacheCard (combine (3,4) #v[(cacheCard (placed 6 (5,4) card0)), (cacheCard (placed 0 (1,4) card5))])), (cacheCard (combine (3,6) #v[(cacheCard (placed 4 (3,6) card18)), (cacheCard (placed 0 (1,2) card382))]))]))]))]))
def card513 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (1,0) card7)), (cacheCard (placed 0 (0,0) card9)), (cacheCard (combine (0,4) #v[(cacheCard (placed 5 (1,1) card5)), (cacheCard (placed 5 (5,1) card439))]))]))
def card514 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 7 (5,2) card34)), (cacheCard (placed 5 (5,1) card149)), (cacheCard (placed 0 (0,0) card513))]))
def card515 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 7 (2,4) card2)), (cacheCard (combine (3,1) #v[(cacheCard (placed 6 (4,1) card0)), (cacheCard (placed 0 (0,0) card78))]))]))
def card516 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (3,0) card52)), (cacheCard (combine (2,3) #v[(cacheCard (placed 6 (4,3) card3)), (cacheCard (placed 6 (4,4) card83))])), (cacheCard (placed 1 (0,1) card515))]))
def card517 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 3 (1,4) card74)), (cacheCard (combine (3,4) #v[(cacheCard (placed 6 (5,4) card0)), (cacheCard (placed 1 (0,3) card404))])), (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (1,3) card30)), (cacheCard (placed 0 (1,0) card59)), (cacheCard (placed 4 (1,6) card346)), (cacheCard (combine (4,5) #v[(cacheCard (placed 6 (5,7) card14)), (cacheCard (placed 4 (1,6) card79)), (cacheCard (placed 4 (3,7) card367)), (cacheCard (placed 2 (5,2) card513)), (cacheCard (placed 0 (1,2) card516))]))])), (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (1,4) card36)), (cacheCard (placed 4 (1,7) card59)), (cacheCard (placed 4 (1,6) card346)), (cacheCard (combine (4,5) #v[(cacheCard (placed 4 (3,7) card14)), (cacheCard (placed 0 (1,2) card58)), (cacheCard (placed 4 (1,6) card79)), (cacheCard (placed 0 (1,2) card429))]))]))]))
def card518 : Card := (cacheCard (combine (4,6) #v[(cacheCard (placed 0 (3,2) card61)), (cacheCard (placed 6 (4,6) card89)), (cacheCard (placed 1 (1,2) card183)), (cacheCard (combine (3,6) #v[(cacheCard (placed 1 (3,3) card5)), (cacheCard (combine (3,7) #v[(cacheCard (placed 2 (3,3) card6)), (cacheCard (placed 5 (6,4) card213)), (cacheCard (placed 1 (1,4) card278))]))]))]))
def card519 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 0 (2,2) card10)), (cacheCard (placed 3 (1,6) card47)), (cacheCard (placed 6 (3,6) card52)), (cacheCard (placed 2 (6,0) card518))]))
def card520 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 3 (2,6) card10)), (cacheCard (placed 6 (6,9) card317)), (cacheCard (placed 2 (6,2) card519))]))
def card521 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (1,1) card5)), (cacheCard (combine (2,3) #v[(cacheCard (placed 1 (0,1) card45)), (cacheCard (placed 3 (0,4) card45))]))]))]))
def card522 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (1,1) card8)), (cacheCard (placed 1 (0,2) card11)), (cacheCard (combine (1,3) #v[(cacheCard (placed 2 (4,2) card5)), (cacheCard (placed 0 (1,0) card416))]))]))
def card523 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 0 (2,1) card14)), (cacheCard (placed 0 (1,2) card122)), (cacheCard (placed 4 (1,6) card136)), (cacheCard (placed 2 (4,1) card367)), (cacheCard (placed 7 (5,6) card522))]))
def card524 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 3 (0,6) card88)), (cacheCard (placed 1 (0,2) card213)), (cacheCard (placed 0 (2,1) card254)), (cacheCard (placed 7 (5,6) card522))]))
def card525 : Card := (cacheCard (combine (3,0) #v[(cacheCard (placed 4 (0,1) card5)), (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (combine (3,3) #v[(cacheCard (placed 2 (3,0) card21)), (cacheCard (placed 0 (2,0) card37)), (cacheCard (placed 5 (4,0) card78))]))]))]))
def card526 : Card := (cacheCard (combine (3,1) #v[(cacheCard (placed 2 (4,1) card0)), (cacheCard (placed 0 (0,0) card525))]))
def card527 : Card := (cacheCard (combine (2,2) #v[(cacheCard (placed 0 (1,0) card206)), (cacheCard (combine (2,5) #v[(cacheCard (placed 2 (2,2) card23)), (cacheCard (placed 4 (1,6) card198))])), (cacheCard (placed 4 (1,5) card405)), (cacheCard (combine (2,5) #v[(cacheCard (placed 0 (2,1) card7)), (cacheCard (placed 2 (2,2) card23)), (cacheCard (combine (3,3) #v[(cacheCard (placed 4 (1,6) card392)), (cacheCard (placed 0 (1,1) card417)), (cacheCard (placed 0 (1,2) card420)), (cacheCard (placed 0 (1,1) card521)), (cacheCard (placed 4 (0,5) card522)), (cacheCard (placed 0 (1,2) card526))]))]))]))
def card528 : Card := (cacheCard (combine (0,7) #v[(cacheCard (placed 2 (1,3) card61)), (cacheCard (combine (1,3) #v[(cacheCard (placed 5 (1,3) card4)), (cacheCard (placed 7 (2,6) card49))])), (cacheCard (combine (1,7) #v[(cacheCard (placed 5 (1,4) card5)), (cacheCard (placed 0 (0,1) card446))]))]))
def card529 : Card := (cacheCard (combine (5,6) #v[(cacheCard (placed 2 (6,2) card12)), (cacheCard (placed 1 (3,3) card181)), (cacheCard (placed 2 (6,2) card189)), (cacheCard (placed 2 (6,1) card369)), (cacheCard (placed 1 (3,3) card474)), (cacheCard (placed 0 (4,0) card528)), (cacheCard (combine (5,3) #v[(cacheCard (placed 3 (3,7) card133)), (cacheCard (combine (6,6) #v[(cacheCard (placed 1 (5,3) card5)), (cacheCard (combine (4,6) #v[(cacheCard (placed 5 (5,3) card5)), (cacheCard (combine (7,5) #v[(cacheCard (combine (3,6) #v[(cacheCard (placed 6 (6,6) card4)), (cacheCard (placed 4 (3,6) card4))])), (cacheCard (combine (7,3) #v[(cacheCard (placed 3 (4,6) card38)), (cacheCard (placed 4 (4,7) card351))]))]))]))])), (cacheCard (placed 7 (6,6) card505))]))]))
def card530 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 4 (0,5) card72)), (cacheCard (placed 4 (0,5) card360)), (cacheCard (placed 0 (0,1) card499)), (cacheCard (combine (2,2) #v[(cacheCard (placed 6 (2,5) card23)), (cacheCard (combine (3,2) #v[(cacheCard (placed 3 (0,3) card51)), (cacheCard (combine (2,5) #v[(cacheCard (placed 3 (2,5) card5)), (cacheCard (placed 0 (1,2) card20))]))]))]))]))
def card531 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 0 (0,0) card530))]))
def card532 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 0 (2,2) card44)), (cacheCard (placed 0 (2,2) card52)), (cacheCard (placed 3 (0,6) card134)), (cacheCard (combine (2,6) #v[(cacheCard (placed 2 (3,2) card19)), (cacheCard (placed 2 (3,2) card84)), (cacheCard (placed 5 (3,3) card314)), (cacheCard (placed 4 (1,7) card521))]))]))
def card533 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,3) card11)), (cacheCard (placed 0 (1,0) card279)), (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (2,0) card53)), (cacheCard (placed 4 (1,6) card55)), (cacheCard (placed 7 (5,4) card392))]))]))
def card534 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 4 (2,6) card44)), (cacheCard (placed 4 (2,6) card52)), (cacheCard (placed 3 (0,5) card388)), (cacheCard (combine (3,6) #v[(cacheCard (placed 0 (2,2) card139)), (cacheCard (combine (2,6) #v[(cacheCard (placed 1 (2,3) card5)), (cacheCard (placed 1 (0,3) card177))])), (cacheCard (combine (3,5) #v[(cacheCard (placed 1 (2,2) card0)), (cacheCard (placed 7 (5,6) card239))]))]))]))
def card535 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 4 (0,7) card345)), (cacheCard (placed 3 (0,6) card421)), (cacheCard (placed 4 (0,7) card522)), (cacheCard (placed 4 (1,8) card530)), (cacheCard (placed 0 (0,0) card532)), (cacheCard (placed 0 (0,2) card533)), (cacheCard (placed 4 (0,8) card534))]))
def card536 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 2 (4,1) card14)), (cacheCard (placed 7 (6,6) card88)), (cacheCard (placed 5 (6,2) card213)), (cacheCard (placed 3 (0,6) card534))]))
def card537 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (1,3) card74)), (cacheCard (placed 0 (0,1) card108)), (cacheCard (combine (3,3) #v[(cacheCard (placed 6 (4,5) card45)), (cacheCard (placed 0 (1,2) card418))])), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (1,1) card166)), (cacheCard (placed 4 (1,7) card464)), (cacheCard (combine (2,5) #v[(cacheCard (placed 6 (2,6) card15)), (cacheCard (placed 0 (1,2) card425))])), (cacheCard (combine (4,4) #v[(cacheCard (placed 2 (5,1) card13)), (cacheCard (placed 3 (1,4) card30)), (cacheCard (combine (3,6) #v[(cacheCard (placed 2 (4,2) card139)), (cacheCard (placed 0 (1,2) card382)), (cacheCard (combine (3,5) #v[(cacheCard (placed 5 (4,2) card0)), (cacheCard (combine (2,5) #v[(cacheCard (placed 1 (2,2) card0)), (cacheCard (placed 2 (2,2) card23))]))]))]))]))]))]))
def card538 : Card := (cacheCard (combine (5,6) #v[(cacheCard (placed 0 (4,1) card459)), (cacheCard (combine (5,7) #v[(cacheCard (placed 0 (3,3) card190)), (cacheCard (placed 2 (7,3) card190)), (cacheCard (placed 5 (8,5) card258)), (cacheCard (placed 4 (1,9) card273)), (cacheCard (placed 0 (1,4) card415)), (cacheCard (placed 1 (2,4) card507))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 4 (1,6) card2)), (cacheCard (placed 4 (3,9) card512))])), (cacheCard (combine (5,4) #v[(cacheCard (placed 4 (3,7) card136)), (cacheCard (combine (5,7) #v[(cacheCard (placed 0 (5,3) card7)), (cacheCard (placed 2 (6,3) card9)), (cacheCard (placed 5 (6,4) card354))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 4 (1,6) card2)), (cacheCard (placed 2 (5,3) card15))])), (cacheCard (combine (5,7) #v[(cacheCard (placed 1 (4,4) card8)), (cacheCard (placed 7 (6,7) card505))]))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 4 (1,6) card2)), (cacheCard (placed 0 (3,2) card517))])), (cacheCard (combine (5,7) #v[(cacheCard (placed 3 (2,8) card116)), (cacheCard (placed 5 (7,4) card180)), (cacheCard (placed 5 (8,5) card258)), (cacheCard (placed 4 (1,9) card273)), (cacheCard (placed 1 (3,4) card275)), (cacheCard (placed 0 (1,4) card415)), (cacheCard (placed 2 (8,2) card518))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 4 (1,6) card2)), (cacheCard (placed 4 (3,9) card527))])), (cacheCard (placed 0 (0,1) card529)), (cacheCard (placed 4 (3,10) card535)), (cacheCard (combine (4,6) #v[(cacheCard (placed 4 (1,6) card2)), (cacheCard (placed 4 (3,9) card537))]))]))
def card539 : Card := (cacheCard (combine (1,9) #v[(cacheCard (placed 0 (1,5) card6)), (cacheCard (combine (0,5) #v[(cacheCard (placed 7 (1,8) card5)), (cacheCard (combine (2,5) #v[(cacheCard (placed 3 (1,9) card4)), (cacheCard (combine (2,1) #v[(cacheCard (combine (3,4) #v[(cacheCard (placed 7 (3,4) card5)), (cacheCard (combine (3,5) #v[(cacheCard (placed 4 (0,5) card5)), (cacheCard (placed 4 (3,5) card6))]))])), (cacheCard (combine (3,4) #v[(cacheCard (placed 7 (3,4) card5)), (cacheCard (combine (3,5) #v[(cacheCard (placed 4 (0,5) card5)), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (0,1) card1)), (cacheCard (placed 2 (4,2) card153))]))]))])), (cacheCard (combine (1,1) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (combine (1,2) #v[(cacheCard (placed 2 (4,1) card0)), (cacheCard (placed 7 (1,5) card2))]))])), (cacheCard (combine (4,1) #v[(cacheCard (placed 0 (2,0) card83)), (cacheCard (placed 5 (4,1) card281))]))]))]))]))]))
def card540 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 4 (3,6) card44)), (cacheCard (combine (2,3) #v[(cacheCard (placed 1 (1,2) card237)), (cacheCard (placed 5 (4,3) card281))])), (cacheCard (combine (0,6) #v[(cacheCard (placed 2 (1,6) card16)), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (0,3) card170)), (cacheCard (combine (4,4) #v[(cacheCard (placed 3 (1,5) card164)), (cacheCard (placed 4 (3,7) card199)), (cacheCard (placed 0 (0,1) card283))]))]))]))]))
def card541 : Card := (cacheCard (combine (1,8) #v[(cacheCard (placed 2 (1,4) card6)), (cacheCard (combine (1,9) #v[(cacheCard (placed 0 (1,5) card6)), (cacheCard (combine (0,4) #v[(cacheCard (placed 7 (1,8) card4)), (cacheCard (combine (2,5) #v[(cacheCard (placed 3 (1,9) card4)), (cacheCard (combine (3,5) #v[(cacheCard (placed 6 (4,5) card0)), (cacheCard (combine (3,4) #v[(cacheCard (placed 4 (3,5) card6)), (cacheCard (placed 0 (0,0) card86)), (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (0,1) card170)), (cacheCard (combine (4,2) #v[(cacheCard (placed 3 (3,6) card0)), (cacheCard (placed 7 (4,4) card35))]))]))]))]))]))]))]))]))
def card542 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 7 (1,5) card3)), (cacheCard (combine (2,1) #v[(cacheCard (placed 7 (3,4) card5)), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (0,1) card1)), (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (3,1) card29)), (cacheCard (combine (5,2) #v[(cacheCard (placed 6 (6,2) card0)), (cacheCard (placed 4 (1,3) card1))]))]))]))]))]))
def card543 : Card := (cacheCard (combine (2,9) #v[(cacheCard (placed 1 (1,6) card8)), (cacheCard (placed 0 (1,3) card280)), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (1,2) card433)), (cacheCard (combine (5,7) #v[(cacheCard (placed 0 (4,3) card261)), (cacheCard (placed 1 (1,6) card370))])), (cacheCard (combine (2,10) #v[(cacheCard (placed 2 (2,6) card6)), (cacheCard (combine (1,6) #v[(cacheCard (placed 7 (2,10) card4)), (cacheCard (combine (3,7) #v[(cacheCard (placed 0 (2,7) card16)), (cacheCard (combine (5,7) #v[(cacheCard (placed 6 (5,7) card1)), (cacheCard (combine (5,5) #v[(cacheCard (placed 0 (4,3) card154)), (cacheCard (placed 0 (1,3) card170))]))]))]))]))])), (cacheCard (combine (2,10) #v[(cacheCard (placed 2 (2,6) card6)), (cacheCard (placed 0 (1,2) card539))])), (cacheCard (placed 0 (1,0) card540)), (cacheCard (placed 0 (1,2) card541)), (cacheCard (combine (4,6) #v[(cacheCard (placed 0 (4,2) card7)), (cacheCard (placed 0 (1,2) card86)), (cacheCard (placed 0 (1,2) card542))]))])), (cacheCard (combine (3,8) #v[(cacheCard (placed 1 (0,6) card278)), (cacheCard (combine (2,5) #v[(cacheCard (placed 7 (2,7) card3)), (cacheCard (placed 1 (2,5) card5))]))]))]))
def card544 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 4 (2,5) card23)), (cacheCard (combine (4,3) #v[(cacheCard (placed 5 (5,3) card15)), (cacheCard (placed 1 (0,2) card259)), (cacheCard (combine (5,3) #v[(cacheCard (placed 2 (6,3) card0)), (cacheCard (placed 7 (6,4) card62))]))]))]))
def card545 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 4 (1,6) card27)), (cacheCard (placed 0 (1,2) card52)), (cacheCard (placed 6 (2,9) card284)), (cacheCard (combine (1,6) #v[(cacheCard (placed 2 (2,2) card19)), (cacheCard (placed 2 (2,2) card84)), (cacheCard (placed 5 (2,3) card314)), (cacheCard (placed 4 (0,7) card419))]))]))
def card546 : Card := (cacheCard (combine (1,6) #v[(cacheCard (placed 2 (2,3) card10)), (cacheCard (placed 4 (1,7) card44)), (cacheCard (placed 2 (2,3) card63)), (cacheCard (combine (1,3) #v[(cacheCard (placed 4 (0,7) card19)), (cacheCard (placed 6 (2,7) card19)), (cacheCard (placed 4 (0,7) card62)), (cacheCard (combine (2,3) #v[(cacheCard (placed 3 (1,6) card5)), (cacheCard (combine (2,6) #v[(cacheCard (placed 1 (1,3) card5)), (cacheCard (combine (0,6) #v[(cacheCard (placed 5 (1,3) card5)), (cacheCard (combine (3,6) #v[(cacheCard (placed 4 (0,7) card25)), (cacheCard (placed 3 (0,6) card27)), (cacheCard (placed 1 (0,5) card37))]))]))]))]))]))]))
def card547 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (0,0) card19)), (cacheCard (placed 5 (2,1) card314)), (cacheCard (combine (1,5) #v[(cacheCard (placed 6 (1,5) card6)), (cacheCard (placed 2 (2,2) card17))])), (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (1,1) card5)), (cacheCard (placed 3 (0,4) card525))]))]))
def card548 : Card := (cacheCard (combine (1,7) #v[(cacheCard (placed 2 (2,4) card10)), (cacheCard (placed 4 (1,8) card52)), (cacheCard (placed 0 (0,3) card189)), (cacheCard (placed 4 (0,8) card547))]))
def card549 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 6 (2,6) card10)), (cacheCard (placed 0 (1,2) card52)), (cacheCard (placed 4 (0,6) card63)), (cacheCard (placed 0 (0,2) card547))]))
def card550 : Card := (cacheCard (combine (5,6) #v[(cacheCard (placed 3 (0,6) card390)), (cacheCard (placed 5 (8,3) card544)), (cacheCard (placed 6 (6,10) card545)), (cacheCard (placed 2 (6,1) card546)), (cacheCard (placed 2 (6,0) card548))]))
def card551 : Card := (cacheCard (combine (6,4) #v[(cacheCard (placed 3 (3,5) card52)), (cacheCard (placed 0 (3,1) card523)), (cacheCard (combine (6,3) #v[(cacheCard (placed 4 (5,6) card10)), (cacheCard (placed 2 (6,2) card44)), (cacheCard (placed 4 (5,6) card63)), (cacheCard (combine (6,6) #v[(cacheCard (placed 0 (5,2) card19)), (cacheCard (placed 0 (5,2) card84)), (cacheCard (placed 1 (5,3) card314)), (cacheCard (combine (5,6) #v[(cacheCard (placed 5 (6,3) card5)), (cacheCard (combine (2,5) #v[(cacheCard (placed 0 (2,5) card1)), (cacheCard (combine (5,3) #v[(cacheCard (placed 7 (6,6) card5)), (cacheCard (combine (7,3) #v[(cacheCard (placed 3 (6,6) card5)), (cacheCard (combine (4,3) #v[(cacheCard (placed 2 (7,2) card25)), (cacheCard (combine (3,3) #v[(cacheCard (placed 7 (7,3) card6)), (cacheCard (placed 2 (4,2) card78))])), (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (2,3) card4)), (cacheCard (placed 7 (5,3) card6))]))]))]))]))]))]))]))]))]))
def card552 : Card := (cacheCard (combine (8,6) #v[(cacheCard (placed 1 (4,4) card188)), (cacheCard (placed 0 (6,3) card258)), (cacheCard (placed 4 (3,10) card326)), (cacheCard (placed 3 (0,8) card543)), (cacheCard (combine (7,7) #v[(cacheCard (placed 1 (4,4) card544)), (cacheCard (placed 4 (6,11) card545)), (cacheCard (placed 0 (6,2) card546)), (cacheCard (combine (5,6) #v[(cacheCard (placed 2 (7,6) card3)), (cacheCard (placed 1 (5,6) card389))])), (cacheCard (placed 0 (6,1) card548))])), (cacheCard (placed 0 (2,1) card551))]))
def card553 : Card := (cacheCard (combine (7,6) #v[(cacheCard (placed 3 (3,7) card107)), (cacheCard (placed 3 (3,7) card163)), (cacheCard (placed 0 (2,1) card538)), (cacheCard (placed 0 (0,0) card552)), (cacheCard (combine (5,4) #v[(cacheCard (placed 3 (2,7) card433)), (cacheCard (combine (5,6) #v[(cacheCard (placed 2 (7,6) card3)), (cacheCard (combine (5,5) #v[(cacheCard (placed 6 (6,7) card10)), (cacheCard (placed 6 (5,7) card52)), (cacheCard (placed 0 (5,3) card52)), (cacheCard (combine (5,7) #v[(cacheCard (placed 4 (3,7) card3)), (cacheCard (placed 7 (5,7) card5))]))]))])), (cacheCard (combine (6,7) #v[(cacheCard (placed 4 (3,7) card2)), (cacheCard (combine (7,4) #v[(cacheCard (placed 2 (7,3) card54)), (cacheCard (placed 3 (2,4) card158)), (cacheCard (combine (6,4) #v[(cacheCard (placed 7 (7,4) card6)), (cacheCard (placed 0 (4,3) card145))]))]))])), (cacheCard (combine (5,6) #v[(cacheCard (placed 2 (7,6) card3)), (cacheCard (combine (4,3) #v[(cacheCard (placed 6 (5,7) card54)), (cacheCard (placed 3 (2,7) card247))]))]))]))]))
def card554 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 1 (0,1) card5)), (cacheCard (combine (1,3) #v[(cacheCard (placed 1 (0,0) card0)), (cacheCard (placed 0 (0,3) card515))]))]))
def card555 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 6 (4,7) card13)), (cacheCard (placed 2 (4,1) card14)), (cacheCard (placed 0 (2,1) card31)), (cacheCard (placed 7 (5,6) card230)), (cacheCard (placed 0 (2,1) card367)), (cacheCard (placed 0 (2,2) card428)), (cacheCard (combine (2,2) #v[(cacheCard (placed 6 (3,6) card61)), (cacheCard (placed 0 (2,2) card194)), (cacheCard (placed 0 (0,1) card224))]))]))
def card556 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 6 (4,4) card3)), (cacheCard (combine (5,4) #v[(cacheCard (placed 4 (2,7) card115)), (cacheCard (placed 4 (2,7) card171)), (cacheCard (placed 4 (2,5) card197)), (cacheCard (placed 0 (2,3) card197)), (cacheCard (placed 4 (2,7) card285))]))]))
def card557 : Card := (cacheCard (combine (4,6) #v[(cacheCard (placed 0 (1,3) card110)), (cacheCard (placed 0 (1,3) card119)), (cacheCard (placed 0 (1,2) card430)), (cacheCard (placed 0 (1,4) card461)), (cacheCard (placed 0 (1,1) card555)), (cacheCard (combine (4,7) #v[(cacheCard (placed 6 (5,9) card13)), (cacheCard (placed 7 (5,7) card28)), (cacheCard (placed 4 (1,8) card58))])), (cacheCard (combine (3,6) #v[(cacheCard (placed 4 (1,6) card5)), (cacheCard (combine (4,3) #v[(cacheCard (placed 4 (3,7) card42)), (cacheCard (placed 1 (1,2) card152)), (cacheCard (combine (2,2) #v[(cacheCard (combine (1,5) #v[(cacheCard (placed 3 (1,6) card2)), (cacheCard (placed 6 (4,6) card5))])), (cacheCard (combine (3,3) #v[(cacheCard (placed 3 (0,3) card11)), (cacheCard (placed 1 (1,2) card41)), (cacheCard (combine (3,4) #v[(cacheCard (placed 7 (3,6) card1)), (cacheCard (placed 7 (5,4) card392))]))]))]))]))]))]))
def card558 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (0,1) card8)), (cacheCard (placed 1 (0,2) card16)), (cacheCard (placed 4 (0,3) card24)), (cacheCard (combine (3,1) #v[(cacheCard (placed 4 (0,2) card5)), (cacheCard (placed 0 (0,0) card471))]))]))
def card559 : Card := (cacheCard (combine (6,1) #v[(cacheCard (placed 4 (3,2) card8)), (cacheCard (placed 5 (7,0) card236)), (cacheCard (combine (4,0) #v[(cacheCard (placed 3 (3,4) card0)), (cacheCard (placed 1 (3,0) card17))])), (cacheCard (combine (3,4) #v[(cacheCard (placed 3 (3,4) card5)), (cacheCard (combine (5,0) #v[(cacheCard (placed 5 (6,0) card244)), (cacheCard (combine (6,4) #v[(cacheCard (placed 0 (3,0) card35)), (cacheCard (combine (4,4) #v[(cacheCard (placed 1 (3,1) card5)), (cacheCard (combine (2,3) #v[(cacheCard (placed 6 (6,4) card1)), (cacheCard (combine (1,3) #v[(cacheCard (placed 6 (4,3) card0)), (cacheCard (placed 0 (0,3) card0))]))]))]))]))]))]))]))
def card560 : Card := (cacheCard (combine (5,4) #v[(cacheCard (placed 3 (1,5) card67)), (cacheCard (placed 0 (2,1) card228)), (cacheCard (placed 4 (2,5) card373)), (cacheCard (placed 4 (2,7) card435)), (cacheCard (placed 0 (3,1) card531)), (cacheCard (combine (3,1) #v[(cacheCard (placed 1 (3,1) card5)), (cacheCard (combine (6,5) #v[(cacheCard (placed 7 (6,5) card153)), (cacheCard (combine (4,1) #v[(cacheCard (placed 3 (3,4) card5)), (cacheCard (combine (5,1) #v[(cacheCard (placed 5 (6,1) card44)), (cacheCard (placed 5 (6,1) card52)), (cacheCard (combine (5,2) #v[(cacheCard (placed 1 (2,1) card44)), (cacheCard (placed 4 (3,5) card156))]))]))]))]))])), (cacheCard (combine (5,3) #v[(cacheCard (placed 0 (3,1) card227)), (cacheCard (placed 7 (6,5) card245)), (cacheCard (placed 4 (2,7) card274))])), (cacheCard (placed 4 (0,5) card559))]))
def card561 : Card := (cacheCard (combine (2,7) #v[(cacheCard (placed 0 (1,3) card154)), (cacheCard (placed 4 (0,10) card319)), (cacheCard (placed 0 (0,3) card335)), (cacheCard (combine (2,4) #v[(cacheCard (placed 7 (2,7) card1)), (cacheCard (placed 0 (0,2) card57))]))]))
def card562 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 3 (0,4) card52)), (cacheCard (placed 6 (4,7) card506)), (cacheCard (combine (3,5) #v[(cacheCard (placed 2 (4,1) card13)), (cacheCard (placed 0 (2,1) card14)), (cacheCard (placed 2 (4,1) card33)), (cacheCard (placed 0 (1,2) card122)), (cacheCard (placed 4 (1,6) card388))]))]))
def card563 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 4 (0,7) card134)), (cacheCard (placed 4 (0,7) card180)), (cacheCard (placed 4 (1,8) card258)), (cacheCard (placed 4 (0,8) card435)), (cacheCard (placed 0 (0,2) card507)), (cacheCard (combine (4,5) #v[(cacheCard (placed 1 (1,4) card18)), (cacheCard (combine (2,4) #v[(cacheCard (placed 6 (5,5) card0)), (cacheCard (combine (2,6) #v[(cacheCard (placed 7 (2,7) card0)), (cacheCard (placed 4 (1,7) card393))]))])), (cacheCard (combine (4,4) #v[(cacheCard (placed 4 (1,5) card5)), (cacheCard (combine (3,4) #v[(cacheCard (placed 4 (0,5) card0)), (cacheCard (combine (3,6) #v[(cacheCard (placed 4 (3,7) card15)), (cacheCard (combine (3,3) #v[(cacheCard (placed 6 (3,7) card11)), (cacheCard (placed 7 (4,6) card38))]))]))]))]))])), (cacheCard (placed 0 (0,0) card561)), (cacheCard (placed 0 (0,1) card562))]))
def card564 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 1 (1,1) card119)), (cacheCard (placed 2 (4,0) card497)), (cacheCard (placed 0 (0,0) card498)), (cacheCard (combine (5,4) #v[(cacheCard (placed 1 (1,3) card12)), (cacheCard (placed 3 (1,5) card12)), (cacheCard (placed 1 (2,1) card79)), (cacheCard (placed 1 (1,2) card135)), (cacheCard (placed 3 (1,6) card182)), (cacheCard (combine (5,5) #v[(cacheCard (placed 1 (2,4) card44)), (cacheCard (combine (2,4) #v[(cacheCard (placed 0 (2,4) card5)), (cacheCard (placed 2 (5,3) card453))])), (cacheCard (combine (5,6) #v[(cacheCard (placed 2 (6,2) card67)), (cacheCard (placed 5 (7,3) card134)), (cacheCard (placed 5 (7,3) card180)), (cacheCard (placed 7 (9,7) card327)), (cacheCard (placed 0 (2,2) card504)), (cacheCard (placed 5 (7,4) card558)), (cacheCard (combine (5,7) #v[(cacheCard (placed 2 (5,4) card16)), (cacheCard (placed 6 (6,8) card235)), (cacheCard (combine (4,5) #v[(cacheCard (placed 7 (5,8) card0)), (cacheCard (combine (2,5) #v[(cacheCard (placed 5 (6,4) card102)), (cacheCard (combine (3,5) #v[(cacheCard (placed 0 (2,5) card5)), (cacheCard (placed 2 (5,2) card55))])), (cacheCard (combine (2,4) #v[(cacheCard (placed 2 (5,4) card5)), (cacheCard (placed 2 (5,2) card342))]))]))]))]))])), (cacheCard (placed 1 (1,1) card560)), (cacheCard (placed 1 (0,3) card563))]))]))]))
def card565 : Card := (cacheCard (combine (5,2) #v[(cacheCard (placed 3 (1,3) card140)), (cacheCard (combine (5,3) #v[(cacheCard (placed 4 (2,3) card5)), (cacheCard (placed 0 (1,1) card179))])), (cacheCard (combine (1,3) #v[(cacheCard (placed 4 (1,3) card4)), (cacheCard (placed 0 (0,0) card142))]))]))
def card566 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 1 (0,2) card116)), (cacheCard (placed 3 (0,6) card116)), (cacheCard (placed 1 (0,2) card172)), (cacheCard (placed 3 (0,6) card172)), (cacheCard (placed 0 (1,1) card182)), (cacheCard (placed 5 (6,1) card565))]))
def card567 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 4 (3,6) card27)), (cacheCard (placed 0 (3,2) card44)), (cacheCard (placed 0 (0,1) card560)), (cacheCard (placed 0 (2,0) card563)), (cacheCard (combine (5,5) #v[(cacheCard (placed 3 (1,6) card67)), (cacheCard (placed 4 (2,7) card134)), (cacheCard (placed 4 (2,7) card180)), (cacheCard (placed 6 (6,9) card327)), (cacheCard (placed 1 (1,2) card504)), (cacheCard (placed 4 (3,7) card558)), (cacheCard (combine (6,5) #v[(cacheCard (placed 3 (3,5) card16)), (cacheCard (placed 7 (7,6) card235)), (cacheCard (combine (4,4) #v[(cacheCard (placed 6 (7,5) card0)), (cacheCard (combine (4,2) #v[(cacheCard (placed 4 (3,5) card94)), (cacheCard (placed 4 (3,6) card102)), (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (4,2) card5)), (cacheCard (placed 7 (6,5) card92))]))]))]))]))]))]))
def card568 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 1 (1,1) card110)), (cacheCard (placed 2 (4,0) card497)), (cacheCard (combine (4,3) #v[(cacheCard (placed 5 (7,1) card255)), (cacheCard (placed 2 (4,0) card496))])), (cacheCard (combine (5,4) #v[(cacheCard (placed 1 (2,1) card79)), (cacheCard (placed 3 (1,5) card189)), (cacheCard (placed 3 (0,7) card518)), (cacheCard (combine (3,5) #v[(cacheCard (placed 5 (6,4) card52)), (cacheCard (combine (6,4) #v[(cacheCard (placed 4 (3,5) card24)), (cacheCard (placed 3 (2,5) card77))])), (cacheCard (combine (3,3) #v[(cacheCard (placed 3 (3,5) card3)), (cacheCard (combine (3,6) #v[(cacheCard (placed 5 (4,3) card8)), (cacheCard (placed 2 (5,3) card387)), (cacheCard (combine (3,7) #v[(cacheCard (placed 0 (3,3) card6)), (cacheCard (placed 5 (5,3) card132))])), (cacheCard (combine (3,7) #v[(cacheCard (placed 2 (3,3) card6)), (cacheCard (placed 2 (4,3) card124))]))]))]))])), (cacheCard (placed 4 (1,7) card565)), (cacheCard (placed 1 (0,1) card567))]))]))
def card569 : Card := (cacheCard (combine (5,5) #v[(cacheCard (placed 1 (0,2) card287)), (cacheCard (placed 4 (2,9) card322)), (cacheCard (placed 1 (2,4) card457)), (cacheCard (combine (6,5) #v[(cacheCard (placed 0 (3,4) card8)), (cacheCard (combine (5,3) #v[(cacheCard (placed 1 (0,2) card68)), (cacheCard (combine (6,6) #v[(cacheCard (placed 0 (3,5) card5)), (cacheCard (placed 0 (5,2) card54))]))])), (cacheCard (combine (6,3) #v[(cacheCard (placed 7 (6,3) card169)), (cacheCard (placed 4 (3,6) card202))]))])), (cacheCard (combine (5,3) #v[(cacheCard (placed 1 (0,2) card68)), (cacheCard (placed 0 (3,0) card495))])), (cacheCard (combine (6,5) #v[(cacheCard (placed 3 (2,6) card9)), (cacheCard (combine (6,3) #v[(cacheCard (placed 0 (3,2) card99)), (cacheCard (placed 7 (6,3) card169))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 1 (2,5) card11)), (cacheCard (placed 1 (0,2) card288))]))]))]))
def card570 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 4 (3,7) card150)), (cacheCard (placed 0 (0,1) card283)), (cacheCard (combine (4,5) #v[(cacheCard (placed 5 (4,3) card5)), (cacheCard (placed 4 (3,9) card446))])), (cacheCard (combine (2,3) #v[(cacheCard (placed 0 (0,3) card1)), (cacheCard (combine (5,3) #v[(cacheCard (placed 3 (2,4) card20)), (cacheCard (placed 1 (2,3) card29)), (cacheCard (placed 0 (2,0) card331))]))]))]))
def card571 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 4 (3,7) card250)), (cacheCard (placed 0 (0,1) card569)), (cacheCard (combine (4,7) #v[(cacheCard (placed 7 (4,7) card2)), (cacheCard (combine (5,6) #v[(cacheCard (placed 1 (0,3) card287)), (cacheCard (placed 1 (0,3) card288)), (cacheCard (placed 0 (2,4) card345)), (cacheCard (placed 1 (2,5) card457))]))])), (cacheCard (combine (4,5) #v[(cacheCard (placed 7 (4,7) card0)), (cacheCard (combine (4,3) #v[(cacheCard (placed 5 (4,3) card5)), (cacheCard (placed 4 (3,9) card446))]))])), (cacheCard (combine (4,5) #v[(cacheCard (placed 7 (4,7) card0)), (cacheCard (combine (4,3) #v[(cacheCard (placed 5 (4,3) card5)), (cacheCard (placed 0 (0,1) card283))]))])), (cacheCard (placed 0 (0,0) card570)), (cacheCard (combine (2,3) #v[(cacheCard (placed 0 (0,3) card1)), (cacheCard (combine (4,5) #v[(cacheCard (placed 7 (4,7) card0)), (cacheCard (combine (4,3) #v[(cacheCard (placed 4 (4,7) card7)), (cacheCard (combine (5,3) #v[(cacheCard (placed 3 (4,6) card5)), (cacheCard (placed 1 (2,3) card29))])), (cacheCard (placed 4 (3,9) card446))]))]))]))]))
def card572 : Card := (cacheCard (combine (4,6) #v[(cacheCard (placed 3 (0,7) card97)), (cacheCard (placed 1 (0,6) card98)), (cacheCard (combine (2,6) #v[(cacheCard (placed 2 (4,6) card5)), (cacheCard (placed 4 (1,7) card78))])), (cacheCard (placed 0 (0,0) card571))]))
def card573 : Card := (cacheCard (combine (3,6) #v[(cacheCard (placed 0 (0,2) card384)), (cacheCard (placed 0 (0,2) card385)), (cacheCard (placed 0 (0,2) card493)), (cacheCard (placed 0 (0,2) card494)), (cacheCard (combine (3,5) #v[(cacheCard (placed 1 (2,3) card8)), (cacheCard (placed 1 (0,3) card115)), (cacheCard (placed 5 (4,3) card197)), (cacheCard (placed 0 (0,2) card286)), (cacheCard (placed 0 (0,2) card339))])), (cacheCard (combine (3,5) #v[(cacheCard (placed 0 (3,2) card7)), (cacheCard (placed 1 (2,3) card8)), (cacheCard (placed 2 (4,2) card9)), (cacheCard (placed 3 (1,7) card473))])), (cacheCard (combine (3,5) #v[(cacheCard (placed 1 (2,3) card8)), (cacheCard (placed 0 (0,2) card403)), (cacheCard (placed 0 (0,3) card487)), (cacheCard (placed 0 (0,2) card492))])), (cacheCard (combine (3,5) #v[(cacheCard (placed 0 (0,2) card87)), (cacheCard (placed 0 (0,3) card487))])), (cacheCard (combine (1,7) #v[(cacheCard (placed 0 (0,3) card107)), (cacheCard (placed 0 (0,0) card572))])), (cacheCard (combine (3,5) #v[(cacheCard (placed 2 (4,2) card9)), (cacheCard (placed 0 (0,2) card249)), (cacheCard (placed 7 (5,6) card383)), (cacheCard (placed 0 (0,2) card403))]))]))
def card574 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 2 (5,2) card184)), (cacheCard (placed 1 (0,2) card384)), (cacheCard (placed 1 (0,2) card385)), (cacheCard (placed 1 (0,2) card493)), (cacheCard (placed 1 (0,2) card494)), (cacheCard (combine (3,2) #v[(cacheCard (placed 1 (1,2) card130)), (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (1,2) card43)), (cacheCard (placed 6 (4,6) card64))])), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (1,2) card5)), (cacheCard (combine (4,4) #v[(cacheCard (placed 7 (4,5) card5)), (cacheCard (placed 0 (1,1) card223))]))])), (cacheCard (combine (4,4) #v[(cacheCard (placed 0 (3,2) card18)), (cacheCard (placed 6 (4,6) card61)), (cacheCard (combine (4,2) #v[(cacheCard (placed 7 (4,5) card5)), (cacheCard (placed 6 (5,6) card236))]))]))]))]))
def card575 : Card := (cacheCard (combine (5,4) #v[(cacheCard (placed 0 (2,1) card257)), (cacheCard (placed 0 (0,0) card326)), (cacheCard (combine (2,4) #v[(cacheCard (placed 6 (4,4) card3)), (cacheCard (placed 0 (2,3) card8))])), (cacheCard (combine (6,4) #v[(cacheCard (combine (2,4) #v[(cacheCard (placed 6 (4,4) card3)), (cacheCard (placed 3 (2,4) card6))])), (cacheCard (placed 5 (7,4) card554))])), (cacheCard (combine (6,4) #v[(cacheCard (placed 1 (0,3) card280)), (cacheCard (placed 5 (7,4) card554))]))]))
def card576 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 6 (7,4) card5)), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (4,1) card52)), (cacheCard (placed 6 (5,5) card246)), (cacheCard (combine (4,5) #v[(cacheCard (combine (5,5) #v[(cacheCard (placed 2 (8,4) card0)), (cacheCard (placed 1 (4,2) card5))])), (cacheCard (combine (3,2) #v[(cacheCard (placed 7 (4,5) card5)), (cacheCard (placed 3 (0,5) card87))]))])), (cacheCard (combine (3,2) #v[(cacheCard (placed 3 (0,5) card87)), (cacheCard (placed 0 (1,0) card215))]))]))]))
def card577 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (1,2) card5)), (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card0)), (cacheCard (combine (3,1) #v[(cacheCard (placed 0 (3,0) card15)), (cacheCard (placed 2 (4,0) card393))]))]))]))
def card578 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (1,2) card26)), (cacheCard (placed 4 (1,4) card49)), (cacheCard (placed 0 (1,0) card117)), (cacheCard (placed 0 (0,1) card577))]))
def card579 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (0,1) card118)), (cacheCard (placed 4 (0,6) card137)), (cacheCard (placed 0 (0,1) card172)), (cacheCard (placed 0 (0,1) card173)), (cacheCard (placed 4 (0,6) card181)), (cacheCard (placed 4 (0,7) card435)), (cacheCard (placed 0 (0,1) card507)), (cacheCard (placed 0 (0,1) card578)), (cacheCard (placed 4 (0,7) card578))]))
def card580 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (1,1) card24)), (cacheCard (placed 4 (1,3) card49)), (cacheCard (placed 1 (1,1) card194)), (cacheCard (placed 0 (0,0) card577))]))
def card581 : Card := (cacheCard (combine (4,6) #v[(cacheCard (placed 0 (2,2) card188)), (cacheCard (placed 2 (6,2) card188)), (cacheCard (placed 5 (7,4) card258)), (cacheCard (placed 7 (7,7) card309)), (cacheCard (placed 1 (1,3) card578)), (cacheCard (placed 5 (7,3) card578))]))
def card582 : Card := (cacheCard (combine (4,6) #v[(cacheCard (placed 3 (1,7) card184)), (cacheCard (placed 3 (1,7) card423)), (cacheCard (placed 0 (1,0) card572)), (cacheCard (combine (4,5) #v[(cacheCard (placed 1 (2,2) card133)), (cacheCard (combine (5,6) #v[(cacheCard (placed 1 (4,3) card5)), (cacheCard (placed 3 (1,7) card160))]))])), (cacheCard (combine (3,6) #v[(cacheCard (placed 3 (0,7) card12)), (cacheCard (placed 3 (0,7) card14)), (cacheCard (placed 1 (1,3) card109)), (cacheCard (placed 1 (1,3) card424))])), (cacheCard (combine (4,5) #v[(cacheCard (placed 7 (6,6) card383)), (cacheCard (placed 5 (5,3) card432))]))]))
def card583 : Card := (cacheCard (combine (7,6) #v[(cacheCard (placed 0 (3,2) card401)), (cacheCard (placed 4 (0,12) card552)), (cacheCard (placed 0 (3,2) card556)), (cacheCard (placed 0 (3,2) card575)), (cacheCard (combine (5,6) #v[(cacheCard (placed 6 (7,6) card3)), (cacheCard (combine (8,6) #v[(cacheCard (placed 4 (5,7) card8)), (cacheCard (placed 4 (5,10) card321)), (cacheCard (combine (9,6) #v[(cacheCard (placed 1 (5,6) card6)), (cacheCard (placed 4 (2,10) card576))])), (cacheCard (combine (9,6) #v[(cacheCard (placed 3 (5,6) card6)), (cacheCard (placed 4 (2,10) card576))]))]))])), (cacheCard (placed 4 (5,10) card579)), (cacheCard (combine (6,8) #v[(cacheCard (placed 2 (7,5) card184)), (cacheCard (placed 2 (7,5) card423)), (cacheCard (combine (5,8) #v[(cacheCard (placed 1 (2,8) card7)), (cacheCard (placed 1 (2,5) card86)), (cacheCard (placed 1 (2,5) card542))])), (cacheCard (placed 1 (0,5) card572)), (cacheCard (combine (6,7) #v[(cacheCard (placed 2 (7,5) card48)), (cacheCard (placed 0 (3,5) card109)), (cacheCard (placed 2 (7,5) card246))]))])), (cacheCard (placed 1 (0,4) card582))]))
def card584 : Card := (cacheCard (combine (2,1) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (2,0) card39)), (cacheCard (combine (4,1) #v[(cacheCard (placed 2 (4,1) card4)), (cacheCard (placed 0 (1,0) card121))])), (cacheCard (combine (1,2) #v[(cacheCard (placed 2 (4,1) card0)), (cacheCard (placed 0 (0,0) card203))]))]))]))
def card585 : Card := (cacheCard (combine (1,3) #v[(cacheCard (placed 2 (4,2) card5)), (cacheCard (combine (1,1) #v[(cacheCard (placed 6 (4,2) card5)), (cacheCard (combine (4,1) #v[(cacheCard (placed 4 (1,2) card5)), (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (1,0) card11)), (cacheCard (placed 1 (0,1) card358))]))]))]))]))
def card586 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (1,1) card8)), (cacheCard (placed 0 (0,0) card179)), (cacheCard (placed 0 (0,0) card585))]))
def card587 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 0 (1,1) card12)), (cacheCard (placed 2 (3,1) card12)), (cacheCard (placed 4 (1,7) card12)), (cacheCard (placed 6 (3,7) card12)), (cacheCard (placed 1 (0,2) card586)), (cacheCard (placed 3 (0,6) card586))]))
def card588 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (0,2) card42)), (cacheCard (placed 3 (0,3) card289)), (cacheCard (placed 0 (1,0) card291)), (cacheCard (placed 1 (2,0) card586))]))
def card589 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 1 (0,2) card7)), (cacheCard (placed 0 (1,1) card8)), (cacheCard (placed 3 (0,3) card9)), (cacheCard (placed 2 (5,0) card585))]))
def card590 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 0 (1,0) card52)), (cacheCard (placed 0 (0,0) card588))]))
def card591 : Card := (cacheCard (combine (4,6) #v[(cacheCard (placed 1 (0,5) card42)), (cacheCard (placed 0 (1,2) card430)), (cacheCard (combine (3,6) #v[(cacheCard (placed 6 (4,6) card5)), (cacheCard (placed 1 (1,5) card265))])), (cacheCard (combine (4,4) #v[(cacheCard (placed 4 (3,8) card12)), (cacheCard (placed 4 (3,8) card13)), (cacheCard (placed 4 (3,8) card14)), (cacheCard (placed 3 (0,6) card289)), (cacheCard (placed 3 (1,7) card435))])), (cacheCard (combine (4,4) #v[(cacheCard (placed 0 (3,2) card13)), (cacheCard (placed 0 (1,2) card356)), (cacheCard (combine (4,3) #v[(cacheCard (placed 4 (1,6) card109)), (cacheCard (placed 7 (5,6) card157)), (cacheCard (combine (3,5) #v[(cacheCard (placed 4 (3,6) card17)), (cacheCard (placed 7 (5,6) card80))]))])), (cacheCard (placed 1 (2,3) card586)), (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (3,6) card8)), (cacheCard (placed 2 (5,2) card19)), (cacheCard (placed 4 (1,6) card271))]))]))]))
def card592 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 4 (0,5) card22)), (cacheCard (placed 6 (1,4) card36)), (cacheCard (placed 0 (0,0) card150)), (cacheCard (combine (1,5) #v[(cacheCard (placed 1 (0,1) card1)), (cacheCard (placed 4 (1,6) card158))]))]))
def card593 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (0,2) card2)), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (3,2) card36)), (cacheCard (placed 0 (3,1) card105)), (cacheCard (placed 4 (3,6) card250)), (cacheCard (placed 4 (3,6) card592))]))]))
def card594 : Card := (cacheCard (combine (6,4) #v[(cacheCard (placed 7 (8,4) card53)), (cacheCard (combine (5,5) #v[(cacheCard (placed 5 (5,3) card5)), (cacheCard (placed 0 (4,3) card91))])), (cacheCard (combine (2,6) #v[(cacheCard (placed 5 (6,3) card272)), (cacheCard (placed 7 (6,7) card290)), (cacheCard (combine (2,3) #v[(cacheCard (placed 0 (2,3) card1)), (cacheCard (combine (2,5) #v[(cacheCard (placed 6 (2,7) card7)), (cacheCard (placed 1 (1,3) card208)), (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (2,6) card4)), (cacheCard (combine (5,1) #v[(cacheCard (placed 3 (1,5) card375)), (cacheCard (combine (5,5) #v[(cacheCard (placed 5 (5,3) card5)), (cacheCard (combine (5,2) #v[(cacheCard (placed 1 (5,1) card5)), (cacheCard (placed 4 (5,5) card6))]))]))]))]))]))])), (cacheCard (combine (2,3) #v[(cacheCard (placed 0 (2,3) card1)), (cacheCard (placed 0 (1,1) card268))])), (cacheCard (placed 5 (7,3) card593))]))]))
def card595 : Card := (cacheCard (combine (6,5) #v[(cacheCard (placed 0 (2,4) card4)), (cacheCard (combine (6,4) #v[(cacheCard (placed 0 (3,4) card5)), (cacheCard (combine (6,3) #v[(cacheCard (placed 4 (3,4) card5)), (cacheCard (combine (6,2) #v[(cacheCard (placed 7 (7,5) card8)), (cacheCard (combine (2,1) #v[(cacheCard (placed 0 (0,1) card5)), (cacheCard (combine (5,1) #v[(cacheCard (placed 7 (6,5) card4)), (cacheCard (combine (5,0) #v[(cacheCard (placed 7 (6,4) card3)), (cacheCard (combine (4,1) #v[(cacheCard (placed 4 (1,1) card4)), (cacheCard (placed 4 (2,1) card5))]))]))]))])), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (0,1) card2)), (cacheCard (placed 7 (7,5) card208))])), (cacheCard (combine (5,2) #v[(cacheCard (placed 7 (6,5) card5)), (cacheCard (combine (4,2) #v[(cacheCard (placed 6 (6,2) card5)), (cacheCard (placed 1 (3,1) card153))]))])), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (0,1) card2)), (cacheCard (placed 7 (7,5) card157))]))]))]))]))]))
def card596 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 4 (1,5) card197)), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (0,1) card2)), (cacheCard (combine (4,5) #v[(cacheCard (placed 7 (4,5) card2)), (cacheCard (placed 0 (1,4) card5))]))])), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (0,1) card2)), (cacheCard (combine (4,3) #v[(cacheCard (placed 7 (4,5) card0)), (cacheCard (placed 4 (1,4) card5))]))])), (cacheCard (combine (5,4) #v[(cacheCard (placed 3 (1,4) card6)), (cacheCard (placed 0 (0,0) card595)), (cacheCard (combine (4,2) #v[(cacheCard (placed 0 (0,1) card2)), (cacheCard (placed 1 (2,1) card82))]))]))]))
def card597 : Card := (cacheCard (combine (5,5) #v[(cacheCard (placed 1 (1,2) card272)), (cacheCard (placed 3 (1,6) card290)), (cacheCard (placed 1 (0,2) card593)), (cacheCard (combine (5,4) #v[(cacheCard (placed 6 (6,7) card13)), (cacheCard (placed 0 (2,2) card109)), (cacheCard (placed 0 (2,2) card291))])), (cacheCard (combine (5,4) #v[(cacheCard (combine (5,2) #v[(cacheCard (placed 4 (5,6) card7)), (cacheCard (combine (4,2) #v[(cacheCard (placed 7 (5,5) card5)), (cacheCard (placed 2 (5,2) card5))]))])), (cacheCard (combine (4,2) #v[(cacheCard (placed 6 (5,6) card140)), (cacheCard (combine (5,2) #v[(cacheCard (placed 2 (5,2) card5)), (cacheCard (combine (6,1) #v[(cacheCard (placed 4 (2,2) card4)), (cacheCard (placed 3 (5,5) card4))]))]))])), (cacheCard (placed 1 (1,2) card596))]))]))
def card598 : Card := (cacheCard (combine (3,5) #v[(cacheCard (combine (3,6) #v[(cacheCard (placed 1 (3,4) card5)), (cacheCard (combine (4,5) #v[(cacheCard (placed 3 (3,8) card0)), (cacheCard (combine (5,5) #v[(cacheCard (placed 2 (6,5) card5)), (cacheCard (placed 2 (7,3) card133))]))]))])), (cacheCard (combine (3,6) #v[(cacheCard (placed 1 (3,4) card5)), (cacheCard (combine (4,5) #v[(cacheCard (placed 3 (3,8) card0)), (cacheCard (combine (5,5) #v[(cacheCard (placed 2 (6,5) card5)), (cacheCard (placed 6 (7,7) card133))]))]))])), (cacheCard (placed 1 (2,4) card584)), (cacheCard (placed 4 (2,10) card591)), (cacheCard (placed 2 (8,1) card594)), (cacheCard (combine (3,6) #v[(cacheCard (placed 1 (3,4) card5)), (cacheCard (combine (4,5) #v[(cacheCard (placed 3 (3,8) card0)), (cacheCard (combine (5,5) #v[(cacheCard (placed 2 (6,5) card5)), (cacheCard (placed 3 (2,6) card413))]))]))])), (cacheCard (placed 0 (1,2) card597))]))
def card599 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,4) card107)), (cacheCard (placed 3 (0,4) card163)), (cacheCard (placed 4 (0,7) card401)), (cacheCard (combine (3,4) #v[(cacheCard (placed 4 (0,4) card2)), (cacheCard (combine (3,5) #v[(cacheCard (placed 2 (4,2) card10)), (cacheCard (placed 0 (3,2) card27)), (cacheCard (placed 2 (4,2) card48)), (cacheCard (placed 2 (4,2) card63)), (cacheCard (combine (3,2) #v[(cacheCard (placed 6 (4,6) card9)), (cacheCard (placed 7 (4,5) card251)), (cacheCard (combine (4,5) #v[(cacheCard (placed 1 (3,2) card5)), (cacheCard (combine (2,5) #v[(cacheCard (placed 5 (3,2) card5)), (cacheCard (combine (5,5) #v[(cacheCard (placed 0 (2,4) card8)), (cacheCard (placed 1 (2,4) card17)), (cacheCard (placed 1 (2,4) card41)), (cacheCard (combine (5,6) #v[(cacheCard (placed 0 (2,5) card5)), (cacheCard (placed 0 (4,2) card64))])), (cacheCard (combine (6,5) #v[(cacheCard (placed 3 (2,5) card6)), (cacheCard (placed 3 (3,5) card16)), (cacheCard (combine (4,4) #v[(cacheCard (placed 6 (7,5) card0)), (cacheCard (placed 0 (4,2) card44))]))]))]))]))]))]))]))]))]))
def card600 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 6 (3,5) card23)), (cacheCard (combine (3,5) #v[(cacheCard (placed 0 (2,2) card20)), (cacheCard (placed 3 (0,5) card55))]))]))
def card601 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (0,1) card247)), (cacheCard (combine (4,4) #v[(cacheCard (combine (3,5) #v[(cacheCard (placed 0 (3,2) card29)), (cacheCard (placed 7 (4,5) card35))])), (cacheCard (placed 1 (1,2) card499)), (cacheCard (placed 0 (0,1) card501))])), (cacheCard (combine (4,4) #v[(cacheCard (placed 4 (3,6) card406)), (cacheCard (placed 1 (1,2) card499)), (cacheCard (combine (2,4) #v[(cacheCard (placed 2 (4,4) card3)), (cacheCard (combine (6,3) #v[(cacheCard (placed 2 (6,3) card1)), (cacheCard (combine (4,2) #v[(cacheCard (placed 4 (3,5) card15)), (cacheCard (combine (5,2) #v[(cacheCard (placed 0 (3,1) card66)), (cacheCard (placed 1 (3,2) card94))]))]))]))])), (cacheCard (placed 4 (1,7) card600)), (cacheCard (combine (2,4) #v[(cacheCard (placed 2 (4,4) card3)), (cacheCard (placed 0 (2,2) card72))]))])), (cacheCard (combine (4,4) #v[(cacheCard (placed 4 (3,6) card406)), (cacheCard (placed 0 (0,1) card501))]))]))
def card602 : Card := (cacheCard (combine (6,7) #v[(cacheCard (placed 0 (0,1) card553)), (cacheCard (combine (6,8) #v[(cacheCard (placed 4 (3,11) card59)), (cacheCard (placed 3 (2,8) card497)), (cacheCard (combine (5,8) #v[(cacheCard (placed 0 (3,4) card320)), (cacheCard (placed 3 (2,8) card496))])), (cacheCard (placed 0 (3,3) card555))])), (cacheCard (combine (7,7) #v[(cacheCard (placed 3 (3,8) card107)), (cacheCard (placed 3 (3,8) card163)), (cacheCard (placed 4 (3,11) card556)), (cacheCard (combine (6,8) #v[(cacheCard (placed 4 (3,8) card2)), (cacheCard (placed 4 (5,12) card545))]))])), (cacheCard (placed 0 (2,2) card557)), (cacheCard (placed 1 (2,4) card564)), (cacheCard (placed 1 (2,4) card568)), (cacheCard (placed 3 (0,8) card573)), (cacheCard (placed 4 (2,10) card574)), (cacheCard (placed 4 (0,13) card583)), (cacheCard (placed 4 (0,12) card598)), (cacheCard (placed 0 (3,4) card599)), (cacheCard (combine (6,8) #v[(cacheCard (placed 0 (3,5) card119)), (cacheCard (placed 3 (2,8) card497)), (cacheCard (placed 1 (2,4) card498)), (cacheCard (combine (5,5) #v[(cacheCard (combine (6,5) #v[(cacheCard (placed 0 (3,4) card157)), (cacheCard (placed 2 (6,3) card383))])), (cacheCard (combine (6,6) #v[(cacheCard (placed 0 (5,5) card18)), (cacheCard (placed 7 (7,8) card381))])), (cacheCard (combine (5,7) #v[(cacheCard (placed 0 (5,4) card64)), (cacheCard (placed 3 (2,8) card500))])), (cacheCard (placed 3 (1,8) card601))]))]))]))
def card603 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 2 (2,1) card13)), (cacheCard (placed 6 (2,7) card14)), (cacheCard (placed 4 (0,7) card31)), (cacheCard (placed 2 (2,1) card189)), (cacheCard (placed 4 (0,7) card367)), (cacheCard (placed 0 (0,2) card457)), (cacheCard (combine (1,2) #v[(cacheCard (placed 4 (1,6) card7)), (cacheCard (placed 3 (0,5) card8)), (cacheCard (placed 6 (2,6) card9)), (cacheCard (placed 4 (0,6) card427))]))]))
def card604 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 4 (0,3) card5)), (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (0,3) card5)), (cacheCard (placed 0 (1,0) card267))]))]))
def card605 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (0,2) card12)), (cacheCard (placed 1 (0,1) card135)), (cacheCard (placed 3 (0,5) card182)), (cacheCard (placed 0 (1,1) card474)), (cacheCard (combine (1,3) #v[(cacheCard (placed 2 (4,0) card115)), (cacheCard (placed 0 (0,1) card585)), (cacheCard (placed 0 (1,0) card604))]))]))
def card606 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (0,2) card28)), (cacheCard (placed 0 (0,1) card168)), (cacheCard (combine (3,4) #v[(cacheCard (placed 4 (3,6) card53)), (cacheCard (placed 2 (4,1) card240))]))]))
def card607 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 6 (5,7) card13)), (cacheCard (placed 4 (1,7) card211)), (cacheCard (combine (4,2) #v[(cacheCard (placed 3 (3,5) card8)), (cacheCard (placed 5 (6,2) card383))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 6 (4,7) card7)), (cacheCard (placed 5 (5,3) card8)), (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (5,6) card352)), (cacheCard (combine (2,5) #v[(cacheCard (placed 5 (5,3) card25)), (cacheCard (placed 6 (2,6) card42))]))]))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 5 (5,3) card197)), (cacheCard (placed 0 (1,2) card363)), (cacheCard (placed 5 (5,3) card371)), (cacheCard (placed 2 (5,2) card606))]))]))
def card608 : Card := (cacheCard (combine (4,6) #v[(cacheCard (placed 4 (3,8) card13)), (cacheCard (placed 4 (3,8) card31)), (cacheCard (placed 4 (1,7) card355)), (cacheCard (placed 0 (1,2) card364)), (cacheCard (placed 0 (0,3) card434)), (cacheCard (combine (1,2) #v[(cacheCard (combine (5,3) #v[(cacheCard (placed 2 (5,3) card18)), (cacheCard (placed 7 (5,6) card375))])), (cacheCard (combine (2,5) #v[(cacheCard (placed 7 (5,6) card28)), (cacheCard (placed 6 (2,6) card42))])), (cacheCard (combine (2,5) #v[(cacheCard (placed 6 (2,6) card42)), (cacheCard (placed 0 (1,3) card58))]))]))]))
def card609 : Card := (cacheCard (combine (3,1) #v[(cacheCard (combine (2,1) #v[(cacheCard (placed 3 (1,4) card5)), (cacheCard (placed 3 (0,2) card48))])), (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (0,1) card25)), (cacheCard (placed 0 (3,0) card54))]))]))
def card610 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 0 (0,1) card19)), (cacheCard (placed 5 (2,2) card197)), (cacheCard (placed 0 (0,1) card225)), (cacheCard (placed 4 (0,6) card609))]))
def card611 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 2 (2,3) card27)), (cacheCard (placed 3 (0,7) card47)), (cacheCard (combine (2,3) #v[(cacheCard (placed 4 (2,7) card7)), (cacheCard (placed 0 (1,3) card17)), (cacheCard (placed 3 (1,6) card93))]))]))
def card612 : Card := (cacheCard (combine (1,4) #v[(cacheCard (placed 6 (1,4) card36)), (cacheCard (placed 0 (0,0) card50)), (cacheCard (placed 0 (0,0) card54)), (cacheCard (combine (1,5) #v[(cacheCard (combine (1,2) #v[(cacheCard (placed 0 (1,1) card6)), (cacheCard (placed 2 (1,1) card6))])), (cacheCard (combine (0,2) #v[(cacheCard (placed 7 (1,6) card0)), (cacheCard (placed 1 (0,1) card3))])), (cacheCard (combine (1,2) #v[(cacheCard (placed 7 (1,5) card4)), (cacheCard (placed 0 (1,1) card6))]))]))]))
def card613 : Card := (cacheCard (combine (2,5) #v[(cacheCard (placed 0 (1,0) card104)), (cacheCard (placed 2 (2,0) card329)), (cacheCard (placed 4 (1,8) card409)), (cacheCard (placed 0 (1,2) card612)), (cacheCard (placed 4 (1,6) card612)), (cacheCard (placed 6 (2,6) card612))]))
def card614 : Card := (cacheCard (combine (5,5) #v[(cacheCard (placed 1 (0,4) card68)), (cacheCard (placed 4 (3,7) card558)), (cacheCard (combine (5,3) #v[(cacheCard (placed 4 (3,8) card276)), (cacheCard (combine (2,4) #v[(cacheCard (placed 0 (0,4) card1)), (cacheCard (placed 4 (2,6) card425))])), (cacheCard (placed 4 (3,9) card611)), (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,4) card68)), (cacheCard (placed 4 (3,8) card495))])), (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,4) card68)), (cacheCard (combine (4,4) #v[(cacheCard (placed 4 (3,6) card66)), (cacheCard (placed 0 (3,2) card66))]))])), (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,4) card68)), (cacheCard (placed 4 (4,6) card612))]))]))]))
def card615 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (0,1) card362)), (cacheCard (placed 0 (0,0) card614)), (cacheCard (combine (5,5) #v[(cacheCard (placed 2 (6,2) card116)), (cacheCard (placed 4 (2,7) card134)), (cacheCard (placed 4 (2,7) card180)), (cacheCard (placed 4 (2,8) card435)), (cacheCard (placed 4 (3,7) card558)), (cacheCard (placed 0 (2,0) card561)), (cacheCard (combine (4,6) #v[(cacheCard (placed 0 (3,3) card43)), (cacheCard (placed 4 (2,8) card57)), (cacheCard (combine (6,4) #v[(cacheCard (placed 3 (2,5) card139)), (cacheCard (placed 5 (6,4) card148)), (cacheCard (combine (6,5) #v[(cacheCard (placed 4 (3,5) card5)), (cacheCard (combine (4,4) #v[(cacheCard (placed 6 (7,5) card0)), (cacheCard (combine (4,3) #v[(cacheCard (placed 4 (4,7) card11)), (cacheCard (placed 4 (3,6) card20)), (cacheCard (placed 0 (3,2) card402))]))]))]))]))]))]))]))
def card616 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,1) card345)), (cacheCard (placed 1 (0,2) card421)), (cacheCard (placed 0 (0,1) card522)), (cacheCard (placed 0 (1,0) card530)), (cacheCard (placed 4 (0,6) card533)), (cacheCard (placed 0 (0,0) card534)), (cacheCard (combine (2,5) #v[(cacheCard (placed 0 (2,1) card11)), (cacheCard (combine (2,6) #v[(cacheCard (placed 0 (2,2) card6)), (cacheCard (placed 5 (3,3) card123))])), (cacheCard (placed 0 (1,1) card521))]))]))
def card617 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 6 (5,7) card14)), (cacheCard (placed 4 (2,6) card136)), (cacheCard (placed 7 (7,6) card332)), (cacheCard (placed 0 (2,1) card616))]))
def card618 : Card := (cacheCard (combine (5,5) #v[(cacheCard (placed 1 (2,3) card398)), (cacheCard (placed 0 (1,2) card434)), (cacheCard (placed 2 (6,1) card610)), (cacheCard (combine (5,6) #v[(cacheCard (placed 0 (5,2) card7)), (cacheCard (placed 1 (4,3) card8)), (cacheCard (placed 2 (6,2) card9)), (cacheCard (combine (3,4) #v[(cacheCard (placed 7 (6,6) card25)), (cacheCard (combine (3,5) #v[(cacheCard (placed 6 (3,7) card53)), (cacheCard (placed 1 (3,3) card378))]))]))])), (cacheCard (combine (5,6) #v[(cacheCard (placed 0 (5,2) card7)), (cacheCard (placed 1 (4,3) card8)), (cacheCard (placed 2 (6,2) card9)), (cacheCard (placed 1 (2,3) card604))])), (cacheCard (combine (5,6) #v[(cacheCard (placed 2 (6,2) card9)), (cacheCard (placed 1 (2,3) card171)), (cacheCard (placed 3 (3,7) card577)), (cacheCard (placed 6 (6,7) card609))])), (cacheCard (combine (5,6) #v[(cacheCard (placed 2 (6,2) card9)), (cacheCard (placed 5 (8,3) card256)), (cacheCard (placed 3 (3,7) card577))])), (cacheCard (placed 0 (2,0) card615)), (cacheCard (combine (4,4) #v[(cacheCard (placed 5 (6,3) card80)), (cacheCard (placed 1 (2,2) card111)), (cacheCard (placed 0 (3,1) card616)), (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (2,4) card5)), (cacheCard (combine (6,4) #v[(cacheCard (placed 6 (6,4) card4)), (cacheCard (placed 1 (1,4) card113))]))]))]))]))
def card619 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (1,2) card8)), (cacheCard (placed 0 (1,2) card26)), (cacheCard (placed 0 (1,2) card49)), (cacheCard (placed 0 (1,0) card115)), (cacheCard (placed 0 (1,0) card292)), (cacheCard (combine (2,2) #v[(cacheCard (placed 2 (4,0) card56)), (cacheCard (placed 0 (1,0) card253))]))]))
def card620 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 5 (6,3) card57)), (cacheCard (placed 7 (6,7) card57)), (cacheCard (placed 5 (6,3) card293)), (cacheCard (placed 7 (6,7) card293)), (cacheCard (combine (3,3) #v[(cacheCard (placed 6 (4,6) card17)), (cacheCard (placed 6 (4,6) card37)), (cacheCard (placed 5 (4,3) card233))]))]))
def card621 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 1 (0,3) card206)), (cacheCard (placed 5 (5,2) card238)), (cacheCard (placed 7 (5,5) card414)), (cacheCard (placed 6 (4,6) card417)), (cacheCard (combine (2,3) #v[(cacheCard (placed 7 (5,4) card15)), (cacheCard (placed 1 (1,2) card159)), (cacheCard (placed 6 (4,6) card164))])), (cacheCard (combine (1,4) #v[(cacheCard (placed 4 (0,4) card0)), (cacheCard (placed 4 (0,6) card133))]))]))
def card622 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 7 (6,6) card57)), (cacheCard (combine (3,6) #v[(cacheCard (placed 2 (4,3) card41)), (cacheCard (placed 7 (6,6) card56))])), (cacheCard (combine (2,2) #v[(cacheCard (placed 6 (3,6) card61)), (cacheCard (combine (3,6) #v[(cacheCard (placed 7 (3,6) card4)), (cacheCard (placed 2 (4,3) card41))])), (cacheCard (combine (3,2) #v[(cacheCard (placed 7 (3,5) card5)), (cacheCard (placed 4 (3,6) card11))]))])), (cacheCard (combine (4,5) #v[(cacheCard (placed 4 (3,6) card23)), (cacheCard (placed 2 (7,1) card621))]))]))
def card623 : Card := (cacheCard (combine (5,6) #v[(cacheCard (placed 6 (9,11) card467)), (cacheCard (placed 1 (0,3) card602)), (cacheCard (placed 2 (6,3) card603)), (cacheCard (placed 5 (8,4) card605)), (cacheCard (placed 6 (9,11) card607)), (cacheCard (placed 6 (9,11) card608)), (cacheCard (combine (5,5) #v[(cacheCard (placed 2 (7,3) card188)), (cacheCard (placed 0 (4,4) card444)), (cacheCard (placed 4 (4,9) card606)), (cacheCard (placed 4 (4,9) card610))])), (cacheCard (placed 6 (10,10) card618)), (cacheCard (combine (5,5) #v[(cacheCard (placed 7 (7,8) card137)), (cacheCard (placed 7 (7,8) card181)), (cacheCard (placed 6 (8,9) card363)), (cacheCard (placed 7 (7,8) card474)), (cacheCard (placed 4 (4,9) card606))])), (cacheCard (combine (5,8) #v[(cacheCard (placed 2 (6,4) card12)), (cacheCard (placed 2 (7,4) card188)), (cacheCard (placed 2 (8,4) card211)), (cacheCard (combine (5,9) #v[(cacheCard (placed 4 (4,10) card9)), (cacheCard (placed 2 (8,5) card151)), (cacheCard (placed 2 (6,4) card186)), (cacheCard (placed 2 (5,4) card187)), (cacheCard (combine (4,7) #v[(cacheCard (placed 2 (5,6) card27)), (cacheCard (placed 3 (4,9) card35))]))])), (cacheCard (placed 1 (2,5) card619)), (cacheCard (combine (5,5) #v[(cacheCard (placed 3 (3,9) card179)), (cacheCard (placed 3 (4,8) card371)), (cacheCard (placed 4 (4,9) card443))])), (cacheCard (placed 2 (8,2) card620))])), (cacheCard (combine (5,8) #v[(cacheCard (placed 0 (4,4) card12)), (cacheCard (placed 1 (1,5) card322)), (cacheCard (placed 4 (4,11) card369)), (cacheCard (placed 1 (2,5) card435)), (cacheCard (combine (5,5) #v[(cacheCard (placed 3 (3,9) card179)), (cacheCard (placed 3 (4,8) card197)), (cacheCard (placed 0 (4,4) card465))])), (cacheCard (placed 6 (8,11) card622))]))]))
def card624 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (0,4) card54)), (cacheCard (placed 0 (2,0) card545)), (cacheCard (combine (3,3) #v[(cacheCard (placed 6 (4,6) card10)), (cacheCard (placed 0 (3,2) card52)), (cacheCard (placed 4 (0,6) card82)), (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,4) card64)), (cacheCard (placed 2 (4,2) card315))]))]))]))
def card625 : Card := (cacheCard (combine (3,2) #v[(cacheCard (placed 3 (0,3) card50)), (cacheCard (placed 3 (0,3) card125)), (cacheCard (placed 5 (5,1) card454)), (cacheCard (placed 0 (1,1) card455)), (cacheCard (combine (3,3) #v[(cacheCard (placed 3 (0,3) card54)), (cacheCard (placed 5 (6,1) card294)), (cacheCard (placed 1 (0,0) card449)), (cacheCard (combine (3,4) #v[(cacheCard (placed 2 (4,1) card10)), (cacheCard (placed 0 (0,1) card82)), (cacheCard (combine (3,1) #v[(cacheCard (placed 7 (6,4) card56)), (cacheCard (placed 2 (4,0) card73))]))]))]))]))
def card626 : Card := (cacheCard (combine (5,6) #v[(cacheCard (placed 2 (6,2) card323)), (cacheCard (placed 0 (2,2) card430)), (cacheCard (placed 7 (6,6) card592)), (cacheCard (combine (4,5) #v[(cacheCard (placed 4 (2,9) card317)), (cacheCard (combine (2,5) #v[(cacheCard (placed 0 (2,5) card5)), (cacheCard (placed 6 (5,6) card38))])), (cacheCard (placed 0 (2,2) card519))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 3 (1,6) card11)), (cacheCard (placed 1 (2,5) card336)), (cacheCard (combine (2,5) #v[(cacheCard (placed 6 (5,6) card5)), (cacheCard (placed 1 (1,5) card412))]))]))]))
def card627 : Card := (cacheCard (combine (5,4) #v[(cacheCard (placed 7 (7,4) card34)), (cacheCard (placed 0 (2,2) card478)), (cacheCard (combine (4,4) #v[(cacheCard (placed 4 (3,4) card5)), (cacheCard (placed 2 (7,2) card472))])), (cacheCard (combine (5,6) #v[(cacheCard (combine (5,5) #v[(cacheCard (placed 3 (5,7) card0)), (cacheCard (combine (5,3) #v[(cacheCard (placed 7 (6,6) card38)), (cacheCard (placed 6 (6,7) card205))]))])), (cacheCard (combine (5,5) #v[(cacheCard (placed 3 (5,7) card0)), (cacheCard (combine (5,3) #v[(cacheCard (placed 7 (6,6) card38)), (cacheCard (placed 3 (3,7) card179))]))])), (cacheCard (combine (5,7) #v[(cacheCard (placed 2 (6,3) card50)), (cacheCard (placed 2 (6,3) card97)), (cacheCard (placed 0 (5,3) card98)), (cacheCard (placed 4 (4,8) card454)), (cacheCard (placed 1 (4,4) card455)), (cacheCard (placed 5 (10,3) card624))])), (cacheCard (placed 1 (0,1) card626)), (cacheCard (combine (5,5) #v[(cacheCard (placed 3 (5,7) card0)), (cacheCard (combine (5,3) #v[(cacheCard (placed 7 (6,6) card38)), (cacheCard (placed 0 (4,2) card413))]))])), (cacheCard (combine (6,6) #v[(cacheCard (placed 5 (9,3) card59)), (cacheCard (placed 2 (6,2) card105)), (cacheCard (placed 3 (2,7) card323)), (cacheCard (placed 1 (2,5) card603))]))]))]))
def card628 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (0,2) card126)), (cacheCard (placed 4 (1,5) card270)), (cacheCard (combine (3,2) #v[(cacheCard (placed 7 (4,3) card36)), (cacheCard (placed 0 (3,0) card53))])), (cacheCard (combine (3,4) #v[(cacheCard (placed 7 (5,4) card34)), (cacheCard (placed 2 (4,0) card464))])), (cacheCard (combine (2,3) #v[(cacheCard (placed 6 (4,3) card5)), (cacheCard (placed 3 (1,4) card265))]))]))
def card629 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 2 (5,1) card190)), (cacheCard (placed 2 (7,2) card295)), (cacheCard (placed 2 (6,1) card364)), (cacheCard (placed 0 (0,0) card518)), (cacheCard (placed 4 (2,7) card628))]))
def card630 : Card := (cacheCard (combine (4,6) #v[(cacheCard (placed 2 (8,3) card368)), (cacheCard (placed 6 (8,10) card368)), (cacheCard (combine (4,8) #v[(cacheCard (placed 0 (3,4) card12)), (cacheCard (placed 6 (5,10) card13)), (cacheCard (placed 6 (7,9) card355)), (cacheCard (placed 6 (7,10) card356)), (cacheCard (placed 2 (8,5) card434)), (cacheCard (placed 5 (7,5) card435)), (cacheCard (placed 4 (3,10) card441))])), (cacheCard (placed 6 (8,11) card467)), (cacheCard (placed 0 (1,3) card627)), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (3,3) card13)), (cacheCard (placed 0 (3,4) card112)), (cacheCard (placed 6 (7,9) card363)), (cacheCard (placed 6 (7,9) card364))])), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (3,4) card112)), (cacheCard (placed 5 (6,4) card181)), (cacheCard (placed 3 (2,8) card181)), (cacheCard (placed 6 (8,8) card295)), (cacheCard (placed 0 (3,4) card466))])), (cacheCard (placed 4 (1,10) card629)), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (3,4) card112)), (cacheCard (placed 3 (1,8) card257)), (cacheCard (placed 7 (7,7) card398)), (cacheCard (combine (5,7) #v[(cacheCard (placed 6 (5,8) card10)), (cacheCard (placed 3 (3,7) card34))])), (cacheCard (placed 0 (3,3) card628))]))]))
def card631 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 4 (3,6) card44)), (cacheCard (placed 4 (3,6) card52)), (cacheCard (placed 2 (4,2) card63)), (cacheCard (combine (4,2) #v[(cacheCard (placed 4 (3,5) card43)), (cacheCard (placed 4 (3,5) card51)), (cacheCard (combine (3,2) #v[(cacheCard (placed 7 (5,5) card45)), (cacheCard (placed 1 (2,2) card418))]))]))]))
def card632 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 3 (0,4) card50)), (cacheCard (placed 3 (0,4) card125)), (cacheCard (placed 5 (5,2) card454)), (cacheCard (placed 0 (1,2) card455)), (cacheCard (combine (3,4) #v[(cacheCard (placed 3 (0,4) card54)), (cacheCard (placed 5 (6,2) card294)), (cacheCard (combine (3,5) #v[(cacheCard (placed 2 (4,2) card10)), (cacheCard (placed 4 (3,6) card52)), (cacheCard (placed 0 (0,2) card82)), (cacheCard (combine (3,2) #v[(cacheCard (placed 3 (1,5) card92)), (cacheCard (placed 1 (1,2) card378))]))])), (cacheCard (placed 0 (0,0) card631))]))]))
def card633 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 6 (6,6) card47)), (cacheCard (placed 6 (5,6) card144)), (cacheCard (combine (5,6) #v[(cacheCard (placed 2 (5,3) card27)), (cacheCard (placed 6 (5,7) card52)), (cacheCard (placed 3 (3,6) card144)), (cacheCard (combine (5,3) #v[(cacheCard (placed 1 (4,3) card8)), (cacheCard (placed 3 (4,6) card93))]))]))]))
def card634 : Card := (cacheCard (combine (5,5) #v[(cacheCard (placed 0 (0,1) card438)), (cacheCard (placed 0 (0,1) card452)), (cacheCard (placed 4 (3,8) card587)), (cacheCard (placed 7 (6,5) card612)), (cacheCard (placed 0 (0,0) card633))]))
def card635 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 4 (1,7) card14)), (cacheCard (placed 6 (3,7) card33)), (cacheCard (placed 3 (0,6) card181)), (cacheCard (placed 3 (0,6) card589)), (cacheCard (combine (2,6) #v[(cacheCard (placed 2 (2,2) card7)), (cacheCard (placed 0 (1,2) card9)), (cacheCard (placed 1 (0,3) card395))]))]))
def card636 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 3 (0,5) card125)), (cacheCard (placed 5 (5,3) card454)), (cacheCard (combine (4,5) #v[(cacheCard (placed 4 (2,8) card399)), (cacheCard (placed 0 (3,1) card408)), (cacheCard (placed 4 (2,8) card475)), (cacheCard (placed 1 (1,2) card509)), (cacheCard (placed 0 (2,1) card587)), (cacheCard (combine (3,5) #v[(cacheCard (placed 7 (5,5) card22)), (cacheCard (placed 6 (5,7) card108)), (cacheCard (placed 0 (2,1) card512))])), (cacheCard (placed 4 (2,9) card635)), (cacheCard (combine (4,6) #v[(cacheCard (placed 0 (3,3) card10)), (cacheCard (placed 6 (4,7) card44)), (cacheCard (placed 0 (3,3) card63)), (cacheCard (placed 3 (1,7) card117))])), (cacheCard (combine (5,4) #v[(cacheCard (placed 0 (2,1) card332)), (cacheCard (placed 4 (2,6) card474)), (cacheCard (placed 0 (2,2) card522)), (cacheCard (combine (3,5) #v[(cacheCard (placed 4 (1,5) card1)), (cacheCard (combine (5,5) #v[(cacheCard (placed 0 (3,1) card85)), (cacheCard (placed 0 (3,2) card164)), (cacheCard (placed 4 (2,7) card262))]))])), (cacheCard (combine (6,4) #v[(cacheCard (placed 3 (2,4) card7)), (cacheCard (placed 1 (2,4) card11)), (cacheCard (placed 2 (6,1) card331))]))]))])), (cacheCard (combine (5,4) #v[(cacheCard (placed 0 (2,1) card118)), (cacheCard (placed 1 (1,2) card188)), (cacheCard (placed 3 (1,6) card188)), (cacheCard (placed 1 (1,3) card192)), (cacheCard (placed 1 (1,3) card193)), (cacheCard (placed 5 (8,2) card396))]))]))
def card637 : Card := (cacheCard (combine (4,2) #v[(cacheCard (placed 1 (1,2) card21)), (cacheCard (placed 3 (1,3) card41)), (cacheCard (placed 3 (1,3) card48)), (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (1,2) card5)), (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (0,2) card0)), (cacheCard (combine (4,4) #v[(cacheCard (placed 6 (4,5) card15)), (cacheCard (placed 1 (1,3) card44))]))]))]))]))
def card638 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 4 (0,6) card57)), (cacheCard (placed 3 (0,5) card136)), (cacheCard (placed 3 (0,5) card217)), (cacheCard (placed 0 (1,0) card530)), (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (0,3) card15)), (cacheCard (placed 4 (1,7) card85))])), (cacheCard (placed 0 (0,1) card637))]))
def card639 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (0,3) card50)), (cacheCard (placed 1 (0,3) card125)), (cacheCard (placed 0 (0,2) card478)), (cacheCard (placed 0 (0,2) card482)), (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (0,3) card54)), (cacheCard (placed 1 (0,2) card638)), (cacheCard (combine (3,5) #v[(cacheCard (placed 2 (4,2) card71)), (cacheCard (placed 6 (4,6) card73)), (cacheCard (combine (3,6) #v[(cacheCard (placed 0 (3,3) card21)), (cacheCard (placed 2 (4,3) card37)), (cacheCard (placed 6 (4,7) card62))])), (cacheCard (placed 6 (4,6) card451))])), (cacheCard (combine (3,5) #v[(cacheCard (placed 2 (4,2) card71)), (cacheCard (placed 6 (4,6) card73)), (cacheCard (placed 5 (6,2) card435)), (cacheCard (placed 6 (4,6) card451))]))]))]))
def card640 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (3,2) card10)), (cacheCard (placed 3 (2,6) card47)), (cacheCard (placed 6 (4,6) card52)), (cacheCard (combine (3,6) #v[(cacheCard (placed 2 (4,2) card61)), (cacheCard (placed 4 (3,6) card89)), (cacheCard (placed 5 (6,2) card183)), (cacheCard (combine (4,6) #v[(cacheCard (placed 5 (4,3) card5)), (cacheCard (combine (2,6) #v[(cacheCard (placed 3 (1,6) card44)), (cacheCard (placed 5 (5,3) card260)), (cacheCard (combine (5,6) #v[(cacheCard (placed 1 (4,3) card5)), (cacheCard (placed 0 (2,5) card90))]))]))]))]))]))
def card641 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 3 (0,3) card52)), (cacheCard (placed 0 (1,1) card144)), (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (2,0) card14)), (cacheCard (placed 1 (0,3) card44)), (cacheCard (placed 2 (4,1) card60))]))]))
def card642 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 0 (0,1) card299)), (cacheCard (placed 0 (0,1) card349)), (cacheCard (placed 0 (0,1) card476)), (cacheCard (placed 0 (1,1) card587)), (cacheCard (placed 4 (1,8) card587)), (cacheCard (placed 3 (0,5) card612)), (cacheCard (placed 0 (0,2) card641))]))
def card643 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 4 (0,8) card299)), (cacheCard (placed 4 (0,8) card349)), (cacheCard (placed 4 (0,8) card476)), (cacheCard (placed 0 (1,1) card587)), (cacheCard (placed 4 (1,8) card587)), (cacheCard (placed 1 (0,4) card612)), (cacheCard (placed 4 (0,7) card641))]))
def card644 : Card := (cacheCard (combine (6,4) #v[(cacheCard (placed 6 (7,7) card120)), (cacheCard (placed 3 (1,6) card338)), (cacheCard (placed 3 (1,7) card437)), (cacheCard (placed 3 (0,6) card611)), (cacheCard (placed 1 (1,3) card613)), (cacheCard (placed 0 (1,0) card634)), (cacheCard (combine (6,5) #v[(cacheCard (placed 1 (1,4) card104)), (cacheCard (placed 1 (1,4) card359)), (cacheCard (placed 0 (1,1) card452)), (cacheCard (placed 4 (3,8) card476)), (cacheCard (placed 0 (3,1) card479)), (cacheCard (combine (5,5) #v[(cacheCard (placed 5 (7,4) card10)), (cacheCard (placed 0 (3,1) card317)), (cacheCard (placed 4 (2,8) card640))]))])), (cacheCard (placed 0 (3,0) card642)), (cacheCard (placed 0 (3,0) card643))]))
def card645 : Card := (cacheCard (combine (6,4) #v[(cacheCard (placed 6 (7,7) card120)), (cacheCard (placed 3 (1,6) card276)), (cacheCard (placed 3 (1,6) card338)), (cacheCard (placed 3 (1,7) card437)), (cacheCard (placed 3 (0,6) card611)), (cacheCard (placed 0 (1,0) card634)), (cacheCard (placed 0 (3,0) card642)), (cacheCard (placed 0 (3,0) card643)), (cacheCard (combine (5,4) #v[(cacheCard (placed 5 (7,4) card44)), (cacheCard (placed 5 (7,4) card52)), (cacheCard (placed 3 (2,5) card128)), (cacheCard (placed 6 (6,6) card144))])), (cacheCard (combine (6,5) #v[(cacheCard (placed 1 (1,4) card104)), (cacheCard (placed 1 (1,4) card359)), (cacheCard (placed 4 (1,8) card438)), (cacheCard (placed 0 (1,1) card452)), (cacheCard (placed 4 (3,8) card476)), (cacheCard (placed 0 (3,1) card479))]))]))
def card646 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 0 (1,1) card361)), (cacheCard (placed 5 (6,1) card361)), (cacheCard (placed 1 (0,3) card411)), (cacheCard (placed 5 (7,1) card600)), (cacheCard (placed 3 (0,7) card621)), (cacheCard (combine (4,2) #v[(cacheCard (placed 2 (4,1) card15)), (cacheCard (placed 1 (2,2) card72)), (cacheCard (placed 7 (6,5) card262))]))]))
def card647 : Card := (cacheCard (combine (5,4) #v[(cacheCard (placed 7 (8,6) card399)), (cacheCard (placed 3 (1,5) card408)), (cacheCard (placed 3 (1,5) card410)), (cacheCard (placed 5 (9,1) card480)), (cacheCard (placed 1 (0,3) card546)), (cacheCard (placed 3 (1,6) card587)), (cacheCard (placed 7 (9,6) card635)), (cacheCard (placed 1 (1,1) card646)), (cacheCard (combine (5,5) #v[(cacheCard (placed 5 (8,2) card600)), (cacheCard (placed 4 (2,8) card600)), (cacheCard (placed 1 (1,1) card621)), (cacheCard (combine (6,5) #v[(cacheCard (placed 7 (7,5) card15)), (cacheCard (placed 5 (8,4) card65)), (cacheCard (placed 6 (6,7) card282))]))]))]))
def card648 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 0 (1,1) card174)), (cacheCard (placed 0 (2,1) card475)), (cacheCard (placed 0 (1,0) card480)), (cacheCard (placed 2 (7,0) card480)), (cacheCard (placed 4 (2,8) card483)), (cacheCard (placed 0 (1,1) card566)), (cacheCard (placed 0 (2,1) card587)), (cacheCard (placed 4 (2,8) card587)), (cacheCard (placed 1 (1,2) card605)), (cacheCard (placed 0 (2,0) card635)), (cacheCard (placed 0 (0,0) card644)), (cacheCard (placed 0 (0,0) card647))]))
def card649 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 3 (1,5) card52)), (cacheCard (placed 0 (1,1) card523)), (cacheCard (combine (4,3) #v[(cacheCard (placed 4 (3,6) card10)), (cacheCard (placed 2 (4,2) card44)), (cacheCard (placed 4 (3,6) card63)), (cacheCard (combine (4,6) #v[(cacheCard (placed 0 (3,2) card19)), (cacheCard (placed 0 (3,2) card84)), (cacheCard (placed 1 (3,3) card314)), (cacheCard (combine (3,6) #v[(cacheCard (placed 5 (4,3) card5)), (cacheCard (combine (3,3) #v[(cacheCard (placed 7 (4,6) card5)), (cacheCard (combine (2,6) #v[(cacheCard (placed 5 (5,5) card15)), (cacheCard (combine (3,4) #v[(cacheCard (placed 5 (3,3) card5)), (cacheCard (combine (2,3) #v[(cacheCard (placed 7 (3,6) card5)), (cacheCard (combine (1,3) #v[(cacheCard (placed 0 (0,3) card0)), (cacheCard (placed 2 (4,2) card78))]))]))]))]))]))]))]))]))]))
def card650 : Card := (cacheCard (combine (5,5) #v[(cacheCard (placed 1 (1,4) card13)), (cacheCard (placed 1 (1,4) card14)), (cacheCard (placed 4 (2,8) card257)), (cacheCard (placed 4 (2,8) card435)), (cacheCard (placed 0 (2,2) card507)), (cacheCard (placed 4 (1,10) card649)), (cacheCard (combine (5,4) #v[(cacheCard (placed 3 (2,5) card52)), (cacheCard (placed 2 (6,0) card545))]))]))
def card651 : Card := (cacheCard (combine (3,6) #v[(cacheCard (combine (3,5) #v[(cacheCard (placed 5 (6,3) card55)), (cacheCard (placed 7 (6,6) card56))])), (cacheCard (combine (3,5) #v[(cacheCard (placed 2 (4,3) card20)), (cacheCard (placed 0 (3,3) card29)), (cacheCard (placed 5 (5,3) card46))])), (cacheCard (combine (4,3) #v[(cacheCard (placed 7 (7,5) card85)), (cacheCard (placed 2 (4,3) card94))]))]))
def card652 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 2 (5,3) card0)), (cacheCard (combine (2,5) #v[(cacheCard (placed 2 (3,2) card10)), (cacheCard (placed 1 (0,3) card558)), (cacheCard (combine (4,4) #v[(cacheCard (placed 3 (0,5) card222)), (cacheCard (combine (4,5) #v[(cacheCard (placed 1 (1,4) card36)), (cacheCard (placed 6 (4,6) card44)), (cacheCard (combine (3,5) #v[(cacheCard (placed 6 (5,5) card0)), (cacheCard (placed 2 (5,2) card245))]))]))]))]))]))
def card653 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 3 (0,4) card53)), (cacheCard (placed 5 (6,3) card53)), (cacheCard (placed 0 (1,0) card652)), (cacheCard (combine (4,4) #v[(cacheCard (placed 1 (0,3) card206)), (cacheCard (placed 0 (2,1) card301)), (cacheCard (placed 5 (5,3) card405))]))]))
def card654 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 1 (0,2) card248)), (cacheCard (placed 1 (0,2) card300)), (cacheCard (placed 1 (0,1) card436)), (cacheCard (placed 4 (1,7) card449)), (cacheCard (placed 0 (1,1) card509)), (cacheCard (placed 4 (1,7) card510)), (cacheCard (placed 3 (0,7) card653)), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (3,1) card53)), (cacheCard (placed 6 (4,7) card53)), (cacheCard (placed 6 (7,8) card651)), (cacheCard (combine (4,6) #v[(cacheCard (placed 7 (4,7) card0)), (cacheCard (placed 3 (1,7) card502))]))]))]))
def card655 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 4 (2,6) card10)), (cacheCard (placed 2 (3,2) card52)), (cacheCard (placed 7 (6,6) card435)), (cacheCard (combine (3,6) #v[(cacheCard (placed 5 (5,2) card179)), (cacheCard (placed 1 (2,3) card314)), (cacheCard (placed 7 (5,7) card344))]))]))
def card656 : Card := (cacheCard (combine (6,6) #v[(cacheCard (placed 0 (3,3) card508)), (cacheCard (placed 4 (3,9) card508)), (cacheCard (placed 0 (3,3) card605)), (cacheCard (placed 4 (3,9) card605)), (cacheCard (placed 5 (10,2) card644)), (cacheCard (placed 5 (10,2) card645)), (cacheCard (placed 5 (10,2) card647)), (cacheCard (placed 0 (2,1) card650)), (cacheCard (placed 4 (2,11) card650)), (cacheCard (combine (5,5) #v[(cacheCard (placed 6 (7,9) card248)), (cacheCard (placed 6 (7,9) card300)), (cacheCard (placed 6 (8,9) card436)), (cacheCard (placed 3 (2,8) card449)), (cacheCard (placed 3 (2,8) card510)), (cacheCard (combine (5,4) #v[(cacheCard (placed 1 (2,3) card117)), (cacheCard (placed 3 (3,7) card134)), (cacheCard (placed 3 (3,7) card180)), (cacheCard (placed 6 (6,9) card337)), (cacheCard (placed 6 (8,9) card341)), (cacheCard (placed 3 (2,7) card435)), (cacheCard (placed 3 (3,6) card558))])), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (2,5) card1)), (cacheCard (placed 1 (1,2) card651))])), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (2,5) card1)), (cacheCard (placed 4 (3,9) card652))]))])), (cacheCard (placed 5 (9,3) card654))]))
def card657 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (1,2) card50)), (cacheCard (placed 1 (1,2) card125)), (cacheCard (placed 0 (1,1) card478)), (cacheCard (placed 0 (1,1) card482)), (cacheCard (combine (4,4) #v[(cacheCard (placed 1 (1,1) card510)), (cacheCard (placed 0 (1,0) card631)), (cacheCard (placed 1 (1,0) card653)), (cacheCard (combine (2,4) #v[(cacheCard (placed 3 (1,4) card54)), (cacheCard (placed 2 (5,1) card79))])), (cacheCard (combine (4,2) #v[(cacheCard (placed 1 (1,2) card54)), (cacheCard (placed 2 (5,1) card71)), (cacheCard (placed 1 (2,1) card345))])), (cacheCard (combine (5,4) #v[(cacheCard (placed 5 (8,2) card85)), (cacheCard (placed 4 (3,7) card85)), (cacheCard (placed 4 (4,7) card411)), (cacheCard (placed 5 (8,2) card537)), (cacheCard (combine (3,4) #v[(cacheCard (placed 3 (2,4) card15)), (cacheCard (placed 1 (1,3) card65)), (cacheCard (combine (6,4) #v[(cacheCard (placed 1 (3,3) card20)), (cacheCard (placed 3 (3,4) card29)), (cacheCard (combine (6,3) #v[(cacheCard (placed 4 (3,4) card5)), (cacheCard (placed 4 (3,5) card445))]))]))]))]))]))]))
def card658 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 6 (2,6) card27)), (cacheCard (placed 2 (2,2) card52)), (cacheCard (placed 4 (1,9) card284)), (cacheCard (combine (2,6) #v[(cacheCard (placed 1 (1,3) card314)), (cacheCard (placed 3 (0,6) card378))]))]))
def card659 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 4 (0,5) card5)), (cacheCard (placed 0 (1,0) card658))]))
def card660 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 5 (7,4) card13)), (cacheCard (placed 2 (6,3) card137)), (cacheCard (placed 6 (6,8) card332)), (cacheCard (combine (6,5) #v[(cacheCard (placed 3 (2,6) card9)), (cacheCard (combine (7,5) #v[(cacheCard (placed 5 (7,5) card6)), (cacheCard (placed 1 (4,4) card18))])), (cacheCard (placed 0 (3,0) card659)), (cacheCard (combine (7,5) #v[(cacheCard (placed 5 (7,5) card6)), (cacheCard (placed 0 (3,2) card252))]))]))]))
def card661 : Card := (cacheCard (combine (4,6) #v[(cacheCard (placed 0 (3,2) card13)), (cacheCard (placed 2 (5,2) card14)), (cacheCard (placed 0 (3,2) card33)), (cacheCard (placed 1 (1,3) card116)), (cacheCard (combine (4,3) #v[(cacheCard (placed 6 (5,7) card9)), (cacheCard (placed 7 (7,6) card115)), (cacheCard (placed 7 (7,7) card302)), (cacheCard (placed 7 (7,7) card303))]))]))
def card662 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 3 (1,5) card52)), (cacheCard (placed 0 (2,0) card658)), (cacheCard (combine (1,5) #v[(cacheCard (placed 4 (1,5) card5)), (cacheCard (placed 2 (4,2) card141))]))]))
def card663 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 4 (1,7) card134)), (cacheCard (placed 4 (1,7) card180)), (cacheCard (placed 4 (1,8) card435)), (cacheCard (placed 0 (1,2) card507)), (cacheCard (placed 4 (2,7) card558)), (cacheCard (placed 4 (1,9) card562)), (cacheCard (placed 0 (1,3) card580)), (cacheCard (placed 0 (0,0) card662))]))
def card664 : Card := (cacheCard (combine (6,5) #v[(cacheCard (placed 4 (3,7) card134)), (cacheCard (placed 4 (3,7) card180)), (cacheCard (placed 2 (7,2) card309)), (cacheCard (placed 4 (3,8) card435)), (cacheCard (placed 4 (4,7) card558)), (cacheCard (placed 0 (3,3) card580)), (cacheCard (placed 0 (2,0) card662))]))
def card665 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (3,1) card459)), (cacheCard (placed 3 (1,7) card588)), (cacheCard (combine (4,7) #v[(cacheCard (placed 6 (4,7) card70)), (cacheCard (placed 0 (3,3) card106)), (cacheCard (placed 0 (3,3) card269)), (cacheCard (placed 1 (0,4) card322))])), (cacheCard (combine (4,7) #v[(cacheCard (placed 6 (4,7) card70)), (cacheCard (placed 5 (7,4) card257)), (cacheCard (placed 5 (7,4) card435))])), (cacheCard (combine (3,5) #v[(cacheCard (placed 6 (4,7) card40)), (cacheCard (placed 1 (0,4) card517)), (cacheCard (combine (3,4) #v[(cacheCard (placed 7 (3,6) card5)), (cacheCard (combine (3,7) #v[(cacheCard (placed 7 (3,7) card4)), (cacheCard (placed 5 (4,4) card93))]))]))]))]))
def card666 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 5 (3,0) card5)), (cacheCard (combine (4,3) #v[(cacheCard (placed 1 (3,0) card5)), (cacheCard (combine (1,3) #v[(cacheCard (placed 6 (4,3) card4)), (cacheCard (placed 0 (1,2) card314))]))]))]))
def card667 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (3,0) card7)), (cacheCard (placed 2 (4,0) card9)), (cacheCard (placed 0 (0,1) card666))]))
def card668 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 2 (3,0) card7)), (cacheCard (placed 0 (2,0) card9)), (cacheCard (placed 0 (0,1) card666))]))
def card669 : Card := (cacheCard (combine (6,4) #v[(cacheCard (placed 4 (4,8) card188)), (cacheCard (placed 2 (7,3) card590)), (cacheCard (placed 4 (3,7) card668)), (cacheCard (combine (6,7) #v[(cacheCard (placed 2 (7,3) card19)), (cacheCard (placed 1 (5,4) card197)), (cacheCard (placed 2 (7,3) card225)), (cacheCard (combine (4,5) #v[(cacheCard (placed 7 (7,7) card25)), (cacheCard (combine (5,7) #v[(cacheCard (placed 5 (6,4) card5)), (cacheCard (combine (4,7) #v[(cacheCard (placed 5 (7,6) card48)), (cacheCard (combine (4,6) #v[(cacheCard (placed 7 (4,8) card0)), (cacheCard (combine (5,6) #v[(cacheCard (placed 6 (7,6) card0)), (cacheCard (placed 7 (7,7) card66))]))])), (cacheCard (combine (3,7) #v[(cacheCard (placed 4 (3,7) card5)), (cacheCard (placed 0 (3,4) card36))])), (cacheCard (combine (3,7) #v[(cacheCard (placed 2 (6,6) card24)), (cacheCard (placed 0 (3,4) card36))]))]))]))]))]))]))
def card670 : Card := (cacheCard (combine (6,6) #v[(cacheCard (placed 0 (5,1) card459)), (cacheCard (combine (5,5) #v[(cacheCard (placed 7 (7,6) card40)), (cacheCard (placed 1 (2,4) card125)), (cacheCard (placed 1 (1,1) card660))])), (cacheCard (placed 4 (2,10) card661)), (cacheCard (combine (5,5) #v[(cacheCard (placed 7 (7,6) card40)), (cacheCard (placed 1 (2,4) card125)), (cacheCard (placed 1 (1,3) card663))])), (cacheCard (combine (5,6) #v[(cacheCard (placed 0 (3,4) card270)), (cacheCard (placed 2 (7,3) card588)), (cacheCard (placed 4 (4,9) card638)), (cacheCard (combine (7,6) #v[(cacheCard (placed 1 (3,5) card106)), (cacheCard (placed 1 (3,5) card219)), (cacheCard (placed 4 (5,9) card530))])), (cacheCard (combine (5,5) #v[(cacheCard (placed 7 (7,6) card40)), (cacheCard (placed 3 (2,5) card98)), (cacheCard (placed 4 (4,9) card512))]))])), (cacheCard (combine (5,5) #v[(cacheCard (placed 7 (7,6) card40)), (cacheCard (placed 1 (2,4) card125)), (cacheCard (placed 0 (2,1) card617))])), (cacheCard (combine (6,4) #v[(cacheCard (placed 4 (5,8) card13)), (cacheCard (placed 4 (5,8) card31)), (cacheCard (placed 4 (3,7) card355)), (cacheCard (placed 4 (3,8) card356)), (cacheCard (placed 0 (2,3) card434)), (cacheCard (placed 1 (3,3) card435)), (cacheCard (placed 6 (7,8) card441))])), (cacheCard (combine (5,5) #v[(cacheCard (placed 7 (7,6) card40)), (cacheCard (placed 1 (2,4) card125)), (cacheCard (placed 4 (4,10) card535))])), (cacheCard (placed 1 (0,2) card665)), (cacheCard (combine (6,4) #v[(cacheCard (placed 0 (4,2) card188)), (cacheCard (placed 4 (4,8) card188)), (cacheCard (placed 6 (7,8) card441)), (cacheCard (placed 6 (7,8) card442)), (cacheCard (placed 2 (7,3) card514)), (cacheCard (placed 4 (3,7) card667))])), (cacheCard (combine (6,4) #v[(cacheCard (placed 2 (7,2) card13)), (cacheCard (placed 2 (7,3) card514)), (cacheCard (placed 2 (7,3) card590)), (cacheCard (placed 4 (3,7) card668)), (cacheCard (combine (5,5) #v[(cacheCard (placed 1 (2,4) card125)), (cacheCard (placed 4 (4,7) card136))]))])), (cacheCard (placed 0 (0,0) card669))]))
def card671 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (0,2) card28)), (cacheCard (placed 1 (0,2) card126)), (cacheCard (placed 3 (0,4) card126)), (cacheCard (combine (3,4) #v[(cacheCard (placed 7 (5,4) card22)), (cacheCard (placed 2 (4,0) card464))]))]))
def card672 : Card := (cacheCard (combine (2,2) #v[(cacheCard (placed 3 (0,2) card34)), (cacheCard (placed 1 (0,1) card305)), (cacheCard (combine (2,1) #v[(cacheCard (placed 0 (1,0) card22)), (cacheCard (placed 1 (0,1) card22))]))]))
def card673 : Card := (cacheCard (combine (4,4) #v[(cacheCard (combine (1,4) #v[(cacheCard (placed 0 (1,3) card30)), (cacheCard (placed 3 (1,4) card74))])), (cacheCard (combine (3,4) #v[(cacheCard (placed 6 (5,4) card0)), (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (4,3) card38)), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (1,4) card5)), (cacheCard (placed 0 (1,3) card260))]))]))])), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (2,2) card188)), (cacheCard (placed 6 (6,8) card190)), (cacheCard (placed 7 (6,7) card230)), (cacheCard (placed 0 (1,3) card263)), (cacheCard (placed 4 (1,8) card306))])), (cacheCard (combine (3,4) #v[(cacheCard (placed 6 (5,4) card0)), (cacheCard (combine (1,4) #v[(cacheCard (placed 2 (4,3) card38)), (cacheCard (placed 0 (1,3) card145))]))])), (cacheCard (combine (1,4) #v[(cacheCard (placed 0 (1,3) card30)), (cacheCard (combine (4,5) #v[(cacheCard (placed 4 (1,7) card263)), (cacheCard (placed 4 (1,7) card271)), (cacheCard (placed 4 (1,7) card424)), (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (3,6) card8)), (cacheCard (placed 0 (3,2) card19)), (cacheCard (placed 7 (5,6) card25))])), (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (1,4) card5)), (cacheCard (placed 0 (3,3) card10))]))]))]))]))
def card674 : Card := (cacheCard (combine (2,4) #v[(cacheCard (placed 2 (2,2) card34)), (cacheCard (placed 0 (1,2) card149)), (cacheCard (placed 0 (0,0) card673))]))
def card675 : Card := (cacheCard (combine (7,6) #v[(cacheCard (placed 0 (6,1) card459)), (cacheCard (placed 0 (2,2) card618)), (cacheCard (placed 2 (10,2) card629)), (cacheCard (combine (7,7) #v[(cacheCard (placed 2 (8,3) card12)), (cacheCard (placed 0 (4,3) card356)), (cacheCard (placed 0 (4,3) card364)), (cacheCard (placed 2 (8,3) card367)), (cacheCard (placed 6 (8,9) card671))])), (cacheCard (combine (7,4) #v[(cacheCard (placed 0 (5,2) card188)), (cacheCard (placed 6 (9,8) card190)), (cacheCard (placed 2 (8,2) card441)), (cacheCard (placed 2 (8,2) card442)), (cacheCard (placed 6 (8,7) card514)), (cacheCard (placed 0 (4,3) card667))])), (cacheCard (combine (7,3) #v[(cacheCard (placed 4 (6,8) card304)), (cacheCard (placed 6 (8,7) card672)), (cacheCard (combine (7,4) #v[(cacheCard (placed 3 (6,6) card8)), (cacheCard (placed 7 (8,6) card26)), (cacheCard (placed 1 (5,2) card133)), (cacheCard (placed 0 (6,1) card186)), (cacheCard (placed 4 (7,8) card187))])), (cacheCard (placed 3 (1,7) card674)), (cacheCard (combine (6,6) #v[(cacheCard (combine (7,4) #v[(cacheCard (placed 5 (7,3) card5)), (cacheCard (placed 5 (9,2) card179))])), (cacheCard (combine (6,5) #v[(cacheCard (placed 7 (8,6) card22)), (cacheCard (placed 5 (8,5) card34)), (cacheCard (placed 7 (8,6) card305))]))]))])), (cacheCard (combine (7,7) #v[(cacheCard (placed 0 (5,3) card190)), (cacheCard (placed 2 (9,3) card190)), (cacheCard (placed 0 (4,3) card363)), (cacheCard (placed 6 (8,9) card671))])), (cacheCard (combine (6,5) #v[(cacheCard (placed 5 (8,5) card34)), (cacheCard (placed 3 (3,6) card97)), (cacheCard (placed 4 (5,10) card535))])), (cacheCard (combine (7,3) #v[(cacheCard (placed 3 (3,7) card328)), (cacheCard (placed 3 (3,7) card330)), (cacheCard (placed 4 (4,7) card384)), (cacheCard (placed 6 (8,7) card672)), (cacheCard (placed 3 (1,7) card674)), (cacheCard (combine (7,4) #v[(cacheCard (placed 3 (3,6) card321)), (cacheCard (placed 5 (8,3) card354))]))]))]))
def card676 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,3) card7)), (cacheCard (placed 0 (1,2) card8)), (cacheCard (placed 1 (0,2) card9)), (cacheCard (combine (2,4) #v[(cacheCard (placed 6 (4,6) card55)), (cacheCard (placed 0 (1,2) card380))]))]))
def card677 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 6 (4,7) card13)), (cacheCard (placed 4 (2,7) card14)), (cacheCard (placed 6 (4,7) card33)), (cacheCard (placed 3 (1,6) card589)), (cacheCard (placed 1 (0,2) card676))]))
def card678 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 4 (0,7) card31)), (cacheCard (placed 3 (0,5) card160)), (cacheCard (combine (2,6) #v[(cacheCard (placed 6 (2,6) card18)), (cacheCard (combine (4,3) #v[(cacheCard (placed 7 (5,4) card22)), (cacheCard (placed 2 (4,2) card382))]))]))]))
def card679 : Card := (cacheCard (combine (2,3) #v[(cacheCard (placed 0 (1,0) card52)), (cacheCard (combine (3,3) #v[(cacheCard (placed 4 (0,3) card0)), (cacheCard (placed 5 (5,1) card222))]))]))
def card680 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 6 (5,3) card0)), (cacheCard (combine (1,3) #v[(cacheCard (placed 2 (4,0) card56)), (cacheCard (placed 6 (5,5) card179))]))]))
def card681 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (0,4) card11)), (cacheCard (combine (4,6) #v[(cacheCard (placed 6 (4,7) card44)), (cacheCard (placed 6 (4,7) card52)), (cacheCard (combine (4,3) #v[(cacheCard (placed 7 (5,6) card32)), (cacheCard (placed 3 (1,4) card44)), (cacheCard (placed 3 (3,6) card90))])), (cacheCard (combine (4,3) #v[(cacheCard (placed 0 (3,3) card17)), (cacheCard (placed 7 (5,6) card32))]))]))]))
def card682 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 4 (3,8) card408)), (cacheCard (placed 4 (3,8) card410)), (cacheCard (placed 6 (6,8) card475)), (cacheCard (placed 3 (1,7) card509)), (cacheCard (placed 7 (7,7) card510)), (cacheCard (placed 4 (2,8) card587)), (cacheCard (placed 6 (7,8) card646)), (cacheCard (combine (4,3) #v[(cacheCard (placed 2 (4,2) card44)), (cacheCard (placed 2 (4,2) card52)), (cacheCard (placed 4 (3,7) card128)), (cacheCard (placed 1 (1,2) card676))])), (cacheCard (combine (6,4) #v[(cacheCard (placed 2 (7,2) card422)), (cacheCard (placed 4 (2,8) card450)), (cacheCard (placed 6 (7,7) card503)), (cacheCard (placed 0 (3,0) card642)), (cacheCard (combine (6,5) #v[(cacheCard (placed 4 (3,8) card59)), (cacheCard (placed 3 (2,5) card105)), (cacheCard (placed 2 (7,1) card678)), (cacheCard (combine (6,6) #v[(cacheCard (placed 2 (7,2) card13)), (cacheCard (placed 6 (7,8) card14)), (cacheCard (placed 4 (3,7) card79)), (cacheCard (placed 2 (7,3) card679)), (cacheCard (combine (4,6) #v[(cacheCard (placed 2 (7,3) card377)), (cacheCard (combine (6,7) #v[(cacheCard (placed 0 (6,3) card7)), (cacheCard (placed 2 (7,3) card9)), (cacheCard (placed 5 (8,4) card386))])), (cacheCard (placed 0 (2,3) card426)), (cacheCard (combine (5,6) #v[(cacheCard (placed 6 (7,6) card0)), (cacheCard (placed 1 (2,4) card222))]))]))]))])), (cacheCard (placed 4 (2,7) card680)), (cacheCard (combine (6,5) #v[(cacheCard (placed 0 (3,1) card430)), (cacheCard (placed 0 (2,2) card431)), (cacheCard (placed 7 (7,5) card592)), (cacheCard (placed 2 (7,1) card678)), (cacheCard (combine (6,6) #v[(cacheCard (placed 6 (7,8) card13)), (cacheCard (placed 4 (3,7) card79)), (cacheCard (placed 2 (7,2) card243)), (cacheCard (placed 2 (7,3) card679))])), (cacheCard (placed 4 (2,9) card681))]))]))]))
def card683 : Card := (cacheCard (combine (3,5) #v[(cacheCard (placed 1 (0,4) card50)), (cacheCard (placed 1 (0,4) card150)), (cacheCard (combine (2,5) #v[(cacheCard (placed 6 (4,5) card5)), (cacheCard (placed 3 (0,6) card9))])), (cacheCard (combine (2,5) #v[(cacheCard (placed 6 (4,5) card5)), (cacheCard (placed 0 (1,2) card604))])), (cacheCard (placed 4 (0,10) card682))]))
def card684 : Card := (cacheCard (combine (7,10) #v[(cacheCard (combine (8,7) #v[(cacheCard (placed 4 (5,10) card118)), (cacheCard (placed 3 (5,10) card355)), (cacheCard (placed 3 (5,11) card434)), (cacheCard (placed 1 (3,6) card468)), (cacheCard (combine (9,7) #v[(cacheCard (placed 4 (6,8) card8)), (cacheCard (placed 4 (6,10) card115)), (cacheCard (placed 1 (5,6) card469)), (cacheCard (placed 4 (5,12) card470)), (cacheCard (placed 3 (4,8) card485)), (cacheCard (placed 4 (4,12) card489))])), (cacheCard (placed 7 (9,11) card491))])), (cacheCard (placed 3 (0,15) card623)), (cacheCard (combine (7,9) #v[(cacheCard (placed 0 (6,6) card50)), (cacheCard (placed 0 (6,6) card97)), (cacheCard (placed 2 (7,6) card98)), (cacheCard (placed 6 (8,11) card454)), (cacheCard (placed 5 (8,7) card455)), (cacheCard (placed 1 (2,6) card624))])), (cacheCard (placed 5 (9,6) card625)), (cacheCard (placed 3 (0,14) card630)), (cacheCard (placed 5 (10,6) card632)), (cacheCard (placed 5 (11,6) card636)), (cacheCard (placed 1 (3,6) card639)), (cacheCard (combine (7,11) #v[(cacheCard (placed 4 (4,14) card174)), (cacheCard (placed 0 (5,7) card475)), (cacheCard (placed 2 (9,7) card475)), (cacheCard (placed 0 (5,7) card483)), (cacheCard (placed 1 (4,8) card508)), (cacheCard (placed 5 (10,8) card508)), (cacheCard (placed 4 (4,14) card566)), (cacheCard (placed 0 (5,7) card587)), (cacheCard (placed 2 (9,7) card587)), (cacheCard (placed 4 (5,15) card635)), (cacheCard (placed 4 (3,15) card644)), (cacheCard (placed 4 (3,15) card645)), (cacheCard (placed 4 (3,15) card647))])), (cacheCard (placed 1 (1,5) card656)), (cacheCard (placed 1 (4,5) card657)), (cacheCard (placed 1 (2,4) card670)), (cacheCard (placed 5 (12,3) card675)), (cacheCard (placed 1 (2,6) card683)), (cacheCard (combine (8,7) #v[(cacheCard (placed 0 (5,4) card257)), (cacheCard (combine (9,7) #v[(cacheCard (placed 0 (6,6) card8)), (cacheCard (placed 2 (9,6) card313))])), (cacheCard (placed 3 (5,11) card434)), (cacheCard (placed 5 (11,6) card468)), (cacheCard (placed 7 (9,11) card491))]))]))
def card685 : Card := (cacheCard (combine (5,5) #v[(cacheCard (placed 3 (1,6) card67)), (cacheCard (placed 7 (7,6) card175)), (cacheCard (placed 0 (2,2) card228)), (cacheCard (placed 4 (2,8) card435)), (cacheCard (placed 0 (3,2) card531)), (cacheCard (combine (3,2) #v[(cacheCard (placed 1 (3,2) card5)), (cacheCard (combine (6,4) #v[(cacheCard (placed 1 (2,2) card96)), (cacheCard (combine (6,2) #v[(cacheCard (placed 4 (3,6) card351)), (cacheCard (combine (2,1) #v[(cacheCard (placed 7 (3,5) card4)), (cacheCard (combine (3,1) #v[(cacheCard (placed 7 (3,4) card5)), (cacheCard (placed 0 (2,0) card312))]))]))]))]))]))]))
def card686 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 5 (6,2) card134)), (cacheCard (placed 5 (6,2) card180)), (cacheCard (placed 0 (3,0) card337)), (cacheCard (placed 5 (7,2) card435)), (cacheCard (placed 5 (6,3) card558)), (cacheCard (combine (5,4) #v[(cacheCard (placed 1 (2,3) card43)), (cacheCard (placed 5 (7,2) card57)), (cacheCard (placed 0 (3,0) card340))])), (cacheCard (combine (4,2) #v[(cacheCard (placed 4 (4,6) card7)), (cacheCard (placed 4 (3,6) card9)), (cacheCard (placed 5 (7,2) card256))]))]))
def card687 : Card := (cacheCard (combine (5,5) #v[(cacheCard (placed 1 (2,4) card44)), (cacheCard (placed 2 (6,0) card324)), (cacheCard (placed 1 (0,1) card685)), (cacheCard (placed 0 (1,1) card686))]))
def card688 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 1 (0,1) card0)), (cacheCard (combine (3,4) #v[(cacheCard (placed 4 (0,5) card8)), (cacheCard (placed 3 (0,5) card41)), (cacheCard (placed 4 (0,7) card253)), (cacheCard (placed 4 (0,7) card256)), (cacheCard (placed 3 (0,5) card336))]))]))
def card689 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 1 (1,4) card44)), (cacheCard (placed 2 (5,0) card324)), (cacheCard (placed 0 (0,1) card686)), (cacheCard (combine (4,6) #v[(cacheCard (placed 2 (5,2) card67)), (cacheCard (placed 6 (5,8) card175)), (cacheCard (placed 1 (1,3) card228)), (cacheCard (placed 5 (5,3) card373)), (cacheCard (placed 5 (7,3) card435)), (cacheCard (placed 1 (0,4) card688))]))]))
def card690 : Card := (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (2,3) card21)), (cacheCard (placed 6 (5,6) card56)), (cacheCard (combine (3,6) #v[(cacheCard (placed 0 (2,2) card39)), (cacheCard (placed 0 (2,2) card80)), (cacheCard (placed 1 (0,2) card463))]))]))
def card691 : Card := (cacheCard (combine (3,6) #v[(cacheCard (placed 1 (2,3) card8)), (cacheCard (combine (4,5) #v[(cacheCard (placed 4 (3,6) card27)), (cacheCard (placed 3 (1,7) card277)), (cacheCard (placed 1 (1,3) card278))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 1 (3,3) card5)), (cacheCard (combine (4,5) #v[(cacheCard (placed 1 (3,2) card0)), (cacheCard (combine (6,5) #v[(cacheCard (placed 3 (2,6) card102)), (cacheCard (placed 0 (2,3) card400)), (cacheCard (combine (6,6) #v[(cacheCard (placed 3 (3,6) card30)), (cacheCard (placed 4 (3,9) card59)), (cacheCard (placed 0 (5,2) card462)), (cacheCard (combine (5,6) #v[(cacheCard (placed 6 (7,6) card0)), (cacheCard (placed 0 (3,2) card317))]))]))]))]))])), (cacheCard (combine (3,7) #v[(cacheCard (placed 2 (3,3) card6)), (cacheCard (placed 1 (2,4) card8)), (cacheCard (placed 1 (0,2) card690)), (cacheCard (combine (4,5) #v[(cacheCard (placed 0 (3,4) card21)), (cacheCard (placed 7 (6,7) card56)), (cacheCard (combine (6,5) #v[(cacheCard (placed 1 (2,4) card39)), (cacheCard (placed 1 (2,4) card80)), (cacheCard (combine (6,7) #v[(cacheCard (combine (2,6) #v[(cacheCard (placed 5 (3,3) card5)), (cacheCard (placed 1 (2,4) card35))])), (cacheCard (placed 4 (5,10) card460)), (cacheCard (placed 0 (2,2) card488))]))]))]))]))]))
def card692 : Card := (cacheCard (combine (1,5) #v[(cacheCard (placed 1 (0,2) card5)), (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (0,2) card110)), (cacheCard (placed 0 (0,2) card119)), (cacheCard (placed 4 (1,8) card399)), (cacheCard (placed 0 (0,1) card430)), (cacheCard (placed 0 (0,3) card461)), (cacheCard (placed 4 (1,8) card475)), (cacheCard (combine (3,3) #v[(cacheCard (placed 4 (2,7) card13)), (cacheCard (placed 4 (2,7) card14)), (cacheCard (placed 3 (0,6) card118)), (cacheCard (placed 2 (4,1) card192)), (cacheCard (placed 0 (2,1) card193)), (cacheCard (placed 0 (1,0) card396)), (cacheCard (placed 7 (6,6) card435))])), (cacheCard (combine (4,4) #v[(cacheCard (placed 4 (0,5) card2)), (cacheCard (placed 4 (1,7) card509))]))]))]))
def card693 : Card := (cacheCard (combine (7,8) #v[(cacheCard (placed 0 (4,4) card147)), (cacheCard (placed 7 (8,8) card339)), (cacheCard (placed 1 (2,5) card692)), (cacheCard (combine (5,7) #v[(cacheCard (placed 6 (7,10) card319)), (cacheCard (combine (5,8) #v[(cacheCard (placed 0 (4,4) card28)), (cacheCard (placed 1 (2,7) card409))])), (cacheCard (combine (5,8) #v[(cacheCard (placed 5 (7,4) card168)), (cacheCard (placed 1 (2,7) card409)), (cacheCard (placed 1 (1,6) card611))])), (cacheCard (combine (3,5) #v[(cacheCard (placed 5 (7,5) card6)), (cacheCard (placed 2 (6,4) card26)), (cacheCard (placed 2 (7,2) card214)), (cacheCard (combine (5,4) #v[(cacheCard (placed 5 (6,4) card10)), (cacheCard (placed 4 (4,8) card308))]))])), (cacheCard (combine (5,6) #v[(cacheCard (placed 6 (5,8) card44)), (cacheCard (placed 4 (5,8) card52)), (cacheCard (combine (5,4) #v[(cacheCard (placed 2 (7,4) card233)), (cacheCard (placed 7 (6,7) card314)), (cacheCard (placed 3 (4,7) card314))]))]))]))]))
def card694 : Card := (cacheCard (combine (5,7) #v[(cacheCard (placed 3 (2,8) card116)), (cacheCard (placed 2 (7,3) card188)), (cacheCard (placed 1 (2,5) card397)), (cacheCard (placed 5 (8,4) card435)), (cacheCard (placed 0 (2,2) card691)), (cacheCard (combine (4,6) #v[(cacheCard (placed 4 (4,11) card390)), (cacheCard (placed 2 (7,3) card544)), (cacheCard (placed 1 (0,5) card545)), (cacheCard (placed 5 (9,5) card546)), (cacheCard (placed 1 (0,5) card549))])), (cacheCard (combine (5,4) #v[(cacheCard (placed 4 (5,8) card7)), (cacheCard (placed 3 (4,7) card26)), (cacheCard (placed 7 (8,8) card142)), (cacheCard (placed 3 (0,11) card693))]))]))
def card695 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 1 (0,4) card12)), (cacheCard (placed 4 (1,8) card118)), (cacheCard (placed 1 (0,3) card135)), (cacheCard (placed 3 (0,7) card182)), (cacheCard (combine (4,6) #v[(cacheCard (placed 1 (1,5) card44)), (cacheCard (placed 2 (5,1) card324)), (cacheCard (placed 0 (0,2) card686)), (cacheCard (combine (4,7) #v[(cacheCard (placed 2 (5,3) card67)), (cacheCard (placed 6 (5,9) card175)), (cacheCard (placed 1 (1,4) card228)), (cacheCard (placed 5 (7,4) card435)), (cacheCard (placed 1 (0,5) card688)), (cacheCard (combine (1,5) #v[(cacheCard (placed 0 (1,5) card5)), (cacheCard (combine (3,8) #v[(cacheCard (placed 0 (1,4) card96)), (cacheCard (combine (1,4) #v[(cacheCard (placed 6 (4,5) card5)), (cacheCard (combine (1,7) #v[(cacheCard (placed 6 (2,8) card308)), (cacheCard (placed 5 (5,5) card348)), (cacheCard (combine (1,6) #v[(cacheCard (placed 0 (1,3) card11)), (cacheCard (placed 2 (2,2) card75)), (cacheCard (placed 4 (1,7) card103))])), (cacheCard (combine (1,6) #v[(cacheCard (placed 0 (1,3) card11)), (cacheCard (placed 2 (2,4) card17)), (cacheCard (placed 7 (2,7) card90))]))]))]))]))]))]))]))]))
def card696 : Card := (cacheCard (combine (5,4) #v[(cacheCard (placed 6 (6,8) card12)), (cacheCard (placed 7 (9,7) card322)), (cacheCard (placed 2 (6,1) card369)), (cacheCard (placed 7 (8,7) card435)), (cacheCard (placed 0 (2,1) card622)), (cacheCard (combine (4,4) #v[(cacheCard (placed 3 (1,7) card317)), (cacheCard (combine (5,7) #v[(cacheCard (placed 7 (5,7) card5)), (cacheCard (placed 5 (6,4) card197))])), (cacheCard (placed 7 (8,7) card436)), (cacheCard (placed 6 (8,9) card685))]))]))
def card697 : Card := (cacheCard (combine (5,3) #v[(cacheCard (placed 7 (6,3) card7)), (cacheCard (placed 0 (2,2) card8)), (cacheCard (placed 0 (0,0) card690)), (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (2,3) card21)), (cacheCard (placed 6 (5,6) card56)), (cacheCard (combine (3,6) #v[(cacheCard (placed 2 (4,2) card39)), (cacheCard (placed 2 (5,2) card121)), (cacheCard (combine (5,6) #v[(cacheCard (placed 7 (6,6) card151)), (cacheCard (placed 5 (8,5) card460)), (cacheCard (combine (6,6) #v[(cacheCard (placed 7 (9,7) card95)), (cacheCard (combine (5,2) #v[(cacheCard (placed 7 (5,3) card16)), (cacheCard (placed 0 (2,2) card374))]))]))]))]))]))]))
def card698 : Card := (cacheCard (combine (4,6) #v[(cacheCard (placed 0 (3,2) card12)), (cacheCard (placed 6 (6,8) card182)), (cacheCard (placed 0 (2,2) card188)), (cacheCard (placed 5 (7,3) card619)), (cacheCard (placed 0 (1,0) card620)), (cacheCard (placed 0 (1,1) card622)), (cacheCard (placed 1 (0,1) card687)), (cacheCard (placed 1 (1,2) card697))]))
def card699 : Card := (cacheCard (combine (7,5) #v[(cacheCard (placed 0 (4,4) card197)), (cacheCard (placed 0 (4,1) card321)), (cacheCard (placed 2 (11,0) card693)), (cacheCard (combine (4,8) #v[(cacheCard (placed 2 (7,4) card147)), (cacheCard (placed 3 (3,8) card249)), (cacheCard (placed 5 (9,5) card692)), (cacheCard (combine (6,8) #v[(cacheCard (placed 0 (4,4) card371)), (cacheCard (placed 5 (9,7) card460)), (cacheCard (combine (7,8) #v[(cacheCard (placed 7 (10,9) card95)), (cacheCard (placed 1 (4,4) card112)), (cacheCard (combine (7,6) #v[(cacheCard (placed 0 (6,4) card42)), (cacheCard (placed 1 (4,5) card52))]))]))]))])), (cacheCard (combine (6,4) #v[(cacheCard (placed 3 (4,5) card389)), (cacheCard (placed 0 (5,0) card545)), (cacheCard (placed 4 (5,9) card546)), (cacheCard (placed 0 (5,0) card549)), (cacheCard (combine (6,3) #v[(cacheCard (placed 6 (7,6) card10)), (cacheCard (placed 6 (7,6) card48)), (cacheCard (placed 3 (4,6) card134)), (cacheCard (combine (7,4) #v[(cacheCard (placed 4 (4,5) card5)), (cacheCard (placed 4 (5,7) card259))]))]))]))]))
def card700 : Card := (cacheCard (combine (4,5) #v[(cacheCard (placed 4 (0,8) card204)), (cacheCard (combine (2,5) #v[(cacheCard (placed 1 (0,4) card39)), (cacheCard (placed 0 (1,2) card52))])), (cacheCard (placed 0 (3,0) card460)), (cacheCard (combine (2,6) #v[(cacheCard (placed 0 (1,2) card61)), (cacheCard (placed 1 (0,3) card348)), (cacheCard (combine (2,5) #v[(cacheCard (placed 1 (1,2) card0)), (cacheCard (combine (3,5) #v[(cacheCard (placed 6 (4,5) card5)), (cacheCard (placed 4 (1,6) card197))]))]))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 6 (5,8) card304)), (cacheCard (combine (4,4) #v[(cacheCard (placed 2 (4,2) card7)), (cacheCard (placed 3 (3,6) card8)), (cacheCard (placed 4 (3,7) card9))])), (cacheCard (combine (2,5) #v[(cacheCard (placed 1 (0,4) card40)), (cacheCard (placed 0 (1,2) card52))]))]))]))
def card701 : Card := (cacheCard (combine (7,7) #v[(cacheCard (placed 3 (3,8) card12)), (cacheCard (placed 2 (8,3) card322)), (cacheCard (placed 0 (4,4) card435)), (cacheCard (placed 6 (9,10) card697)), (cacheCard (placed 0 (1,2) card699)), (cacheCard (combine (5,10) #v[(cacheCard (combine (5,8) #v[(cacheCard (placed 3 (4,8) card10)), (cacheCard (placed 2 (6,6) card39))])), (cacheCard (placed 5 (10,6) card683)), (cacheCard (combine (5,8) #v[(cacheCard (placed 5 (8,7) card52)), (cacheCard (placed 1 (1,6) card325))])), (cacheCard (combine (4,7) #v[(cacheCard (placed 2 (7,6) card8)), (cacheCard (placed 1 (2,6) card463))])), (cacheCard (combine (4,8) #v[(cacheCard (placed 3 (4,8) card18)), (cacheCard (placed 2 (7,6) card348))])), (cacheCard (placed 1 (2,6) card700)), (cacheCard (combine (5,8) #v[(cacheCard (placed 3 (4,8) card10)), (cacheCard (combine (5,9) #v[(cacheCard (placed 3 (5,10) card5)), (cacheCard (placed 0 (4,6) card9))])), (cacheCard (combine (5,9) #v[(cacheCard (placed 3 (5,10) card5)), (cacheCard (placed 0 (4,6) card372))]))]))]))]))
def card702 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 3 (0,3) card22)), (cacheCard (placed 0 (0,1) card400)), (cacheCard (combine (4,2) #v[(cacheCard (placed 1 (1,2) card30)), (cacheCard (placed 0 (0,0) card108)), (cacheCard (combine (1,1) #v[(cacheCard (placed 0 (1,0) card15)), (cacheCard (placed 1 (0,1) card40))])), (cacheCard (placed 0 (1,0) card511))]))]))
def card703 : Card := (cacheCard (combine (4,3) #v[(cacheCard (placed 6 (5,7) card13)), (cacheCard (placed 2 (5,0) card369)), (cacheCard (combine (3,3) #v[(cacheCard (placed 0 (3,2) card195)), (cacheCard (combine (5,3) #v[(cacheCard (placed 2 (5,3) card3)), (cacheCard (placed 0 (4,2) card27))])), (cacheCard (combine (2,3) #v[(cacheCard (placed 2 (5,3) card0)), (cacheCard (placed 4 (2,6) card52))])), (cacheCard (combine (3,2) #v[(cacheCard (placed 7 (4,6) card0)), (cacheCard (placed 4 (2,6) card101))]))])), (cacheCard (placed 4 (1,6) card516)), (cacheCard (combine (4,2) #v[(cacheCard (placed 4 (4,6) card7)), (cacheCard (placed 6 (5,6) card9)), (cacheCard (combine (3,2) #v[(cacheCard (placed 7 (4,5) card5)), (cacheCard (combine (5,2) #v[(cacheCard (placed 3 (4,5) card5)), (cacheCard (combine (2,2) #v[(cacheCard (placed 5 (6,2) card11)), (cacheCard (placed 1 (2,2) card103)), (cacheCard (placed 2 (5,1) card157))]))]))]))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 6 (5,7) card9)), (cacheCard (placed 5 (5,3) card49)), (cacheCard (placed 0 (3,1) card186)), (cacheCard (combine (5,3) #v[(cacheCard (placed 2 (5,3) card18)), (cacheCard (placed 2 (5,2) card77))]))]))]))
def card704 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 1 (0,4) card22)), (cacheCard (placed 4 (0,6) card400)), (cacheCard (combine (4,5) #v[(cacheCard (placed 3 (1,5) card30)), (cacheCard (combine (4,6) #v[(cacheCard (placed 5 (5,4) card28)), (cacheCard (placed 0 (1,3) card58)), (cacheCard (placed 0 (1,2) card306))])), (cacheCard (placed 0 (0,0) card703)), (cacheCard (combine (4,3) #v[(cacheCard (placed 4 (1,6) card516)), (cacheCard (combine (5,5) #v[(cacheCard (placed 6 (5,5) card2)), (cacheCard (placed 0 (4,2) card52))])), (cacheCard (combine (5,5) #v[(cacheCard (placed 6 (5,5) card2)), (cacheCard (placed 6 (5,6) card10))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 5 (5,3) card25)), (cacheCard (placed 7 (5,6) card78))]))]))]))]))
def card705 : Card := (cacheCard (combine (5,4) #v[(cacheCard (placed 2 (6,2) card422)), (cacheCard (placed 4 (1,8) card450)), (cacheCard (placed 6 (6,7) card503)), (cacheCard (placed 0 (2,0) card642)), (cacheCard (placed 4 (1,7) card680)), (cacheCard (combine (5,5) #v[(cacheCard (placed 4 (2,8) card59)), (cacheCard (placed 3 (1,5) card105)), (cacheCard (placed 2 (6,1) card323)), (cacheCard (combine (5,6) #v[(cacheCard (placed 6 (6,8) card14)), (cacheCard (placed 4 (2,7) card79)), (cacheCard (placed 1 (3,3) card181)), (cacheCard (placed 2 (6,2) card189)), (cacheCard (placed 4 (4,8) card367)), (cacheCard (placed 1 (3,3) card474))]))])), (cacheCard (combine (5,5) #v[(cacheCard (placed 2 (6,1) card323)), (cacheCard (placed 0 (2,1) card430)), (cacheCard (placed 0 (1,2) card431)), (cacheCard (placed 7 (6,5) card592)), (cacheCard (placed 4 (1,9) card681)), (cacheCard (combine (5,6) #v[(cacheCard (placed 4 (2,7) card79)), (cacheCard (placed 2 (6,2) card243)), (cacheCard (placed 2 (8,1) card518)), (cacheCard (combine (4,4) #v[(cacheCard (placed 6 (5,7) card52)), (cacheCard (placed 2 (6,2) card242))]))]))]))]))
def card706 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 7 (8,6) card512)), (cacheCard (placed 3 (1,6) card517)), (cacheCard (placed 7 (8,6) card527)), (cacheCard (placed 7 (8,6) card537)), (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (2,4) card15)), (cacheCard (placed 3 (1,5) card65)), (cacheCard (combine (7,3) #v[(cacheCard (placed 3 (3,4) card261)), (cacheCard (combine (6,4) #v[(cacheCard (placed 4 (3,4) card4)), (cacheCard (placed 1 (2,3) card9))])), (cacheCard (combine (5,3) #v[(cacheCard (placed 3 (3,4) card154)), (cacheCard (placed 4 (3,6) card159))])), (cacheCard (combine (7,5) #v[(cacheCard (placed 3 (3,5) card22)), (cacheCard (placed 2 (8,2) card152)), (cacheCard (placed 0 (4,1) card166))]))]))])), (cacheCard (combine (5,3) #v[(cacheCard (placed 7 (7,5) card417)), (cacheCard (placed 7 (6,5) card420)), (cacheCard (placed 7 (6,5) card526)), (cacheCard (placed 3 (0,6) card532)), (cacheCard (combine (3,3) #v[(cacheCard (placed 1 (0,3) card318)), (cacheCard (placed 7 (7,4) card334)), (cacheCard (placed 3 (3,5) card379))])), (cacheCard (combine (3,4) #v[(cacheCard (placed 7 (6,5) card66)), (cacheCard (placed 7 (6,6) card238)), (cacheCard (placed 3 (2,5) card394))]))])), (cacheCard (combine (7,5) #v[(cacheCard (placed 3 (3,5) card22)), (cacheCard (placed 3 (4,5) card74)), (cacheCard (placed 4 (3,9) card325)), (cacheCard (combine (7,4) #v[(cacheCard (placed 1 (4,4) card30)), (cacheCard (placed 0 (4,1) card59)), (cacheCard (placed 3 (3,6) card296)), (cacheCard (placed 0 (6,1) card603))]))]))]))
def card707 : Card := (cacheCard (combine (5,6) #v[(cacheCard (placed 0 (4,1) card459)), (cacheCard (placed 4 (3,10) card535)), (cacheCard (placed 0 (1,1) card617)), (cacheCard (placed 1 (0,1) card660)), (cacheCard (placed 1 (0,3) card663)), (cacheCard (combine (5,7) #v[(cacheCard (placed 3 (2,8) card116)), (cacheCard (placed 5 (7,4) card134)), (cacheCard (placed 5 (7,4) card180)), (cacheCard (placed 0 (4,2) card337)), (cacheCard (placed 5 (8,4) card435)), (cacheCard (placed 5 (7,5) card558)), (cacheCard (placed 1 (0,3) card662))])), (cacheCard (combine (5,4) #v[(cacheCard (placed 6 (6,8) card14)), (cacheCard (placed 4 (4,8) card33)), (cacheCard (placed 3 (1,7) card322)), (cacheCard (combine (5,7) #v[(cacheCard (placed 0 (5,3) card7)), (cacheCard (placed 2 (6,3) card9)), (cacheCard (placed 5 (6,4) card380))]))])), (cacheCard (combine (5,4) #v[(cacheCard (placed 4 (3,7) card136)), (cacheCard (placed 0 (3,2) card267)), (cacheCard (placed 3 (1,7) card322)), (cacheCard (placed 5 (9,3) card322)), (cacheCard (combine (5,7) #v[(cacheCard (placed 0 (5,3) card7)), (cacheCard (placed 1 (4,4) card8)), (cacheCard (placed 2 (6,3) card9)), (cacheCard (placed 4 (4,9) card485))]))])), (cacheCard (combine (5,4) #v[(cacheCard (placed 4 (4,8) card13)), (cacheCard (placed 6 (6,8) card14)), (cacheCard (placed 7 (8,7) card332)), (cacheCard (combine (5,7) #v[(cacheCard (placed 2 (6,3) card9)), (cacheCard (placed 1 (2,4) card115)), (cacheCard (placed 5 (8,3) card302)), (cacheCard (placed 5 (8,3) card303))]))])), (cacheCard (combine (5,7) #v[(cacheCard (placed 2 (6,3) card12)), (cacheCard (placed 2 (6,3) card13)), (cacheCard (placed 5 (8,4) card118)), (cacheCard (placed 6 (6,10) card369)), (cacheCard (placed 5 (8,4) card435)), (cacheCard (placed 0 (4,1) card528)), (cacheCard (placed 1 (1,3) card689))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 5 (8,4) card537)), (cacheCard (placed 4 (3,9) card537)), (cacheCard (placed 5 (7,4) card702)), (cacheCard (placed 4 (3,8) card702)), (cacheCard (placed 1 (0,4) card704)), (cacheCard (placed 0 (3,1) card704))])), (cacheCard (placed 4 (2,10) card705)), (cacheCard (placed 4 (0,10) card706))]))
def card708 : Card := (cacheCard (combine (7,8) #v[(cacheCard (placed 5 (12,7) card459)), (cacheCard (placed 5 (11,6) card475)), (cacheCard (placed 3 (4,10) card587)), (cacheCard (placed 1 (4,7) card603)), (cacheCard (placed 0 (5,5) card605)), (cacheCard (placed 6 (11,13) card650)), (cacheCard (placed 0 (1,1) card684)), (cacheCard (combine (6,8) #v[(cacheCard (placed 0 (5,5) card117)), (cacheCard (placed 2 (9,6) card137)), (cacheCard (placed 2 (9,6) card181)), (cacheCard (placed 2 (9,5) card257)), (cacheCard (placed 2 (9,5) card435)), (cacheCard (combine (7,7) #v[(cacheCard (placed 2 (9,5) card57)), (cacheCard (placed 2 (9,5) card88)), (cacheCard (placed 2 (9,5) card111)), (cacheCard (placed 0 (5,5) card213)), (cacheCard (combine (5,8) #v[(cacheCard (placed 5 (9,8) card7)), (cacheCard (placed 1 (4,7) card234)), (cacheCard (placed 5 (9,7) card241))])), (cacheCard (combine (7,6) #v[(cacheCard (placed 2 (7,5) card44)), (cacheCard (placed 0 (7,5) card52)), (cacheCard (combine (7,9) #v[(cacheCard (placed 2 (7,5) card7)), (cacheCard (placed 0 (6,5) card9)), (cacheCard (placed 5 (9,6) card92))]))]))])), (cacheCard (combine (9,8) #v[(cacheCard (placed 3 (5,8) card7)), (cacheCard (placed 5 (11,7) card186)), (cacheCard (placed 6 (9,11) card292))]))])), (cacheCard (combine (9,8) #v[(cacheCard (placed 3 (5,9) card12)), (cacheCard (placed 5 (11,6) card135)), (cacheCard (placed 0 (6,6) card181)), (cacheCard (placed 4 (6,11) card435)), (cacheCard (placed 4 (5,11) card565)), (cacheCard (placed 2 (12,4) card687)), (cacheCard (placed 0 (5,4) card689))])), (cacheCard (placed 7 (13,13) card694)), (cacheCard (placed 0 (5,3) card695)), (cacheCard (placed 5 (13,3) card696)), (cacheCard (placed 1 (3,4) card698)), (cacheCard (placed 2 (13,1) card701)), (cacheCard (combine (9,8) #v[(cacheCard (placed 1 (5,7) card12)), (cacheCard (placed 3 (5,9) card12)), (cacheCard (placed 5 (11,7) card12)), (cacheCard (placed 7 (11,9) card12)), (cacheCard (placed 0 (5,1) card490)), (cacheCard (placed 2 (11,1) card490))])), (cacheCard (placed 2 (12,3) card707))]))
def card709 : Card := (cacheCard (combine (5,7) #v[(cacheCard (placed 2 (6,3) card14)), (cacheCard (placed 5 (8,4) card116)), (cacheCard (placed 5 (7,4) card181)), (cacheCard (combine (6,6) #v[(cacheCard (placed 5 (9,3) card524)), (cacheCard (placed 7 (9,9) card536)), (cacheCard (placed 7 (10,7) card545)), (cacheCard (placed 5 (10,3) card655)), (cacheCard (placed 4 (1,11) card664)), (cacheCard (combine (5,4) #v[(cacheCard (placed 4 (5,8) card11)), (cacheCard (placed 7 (8,7) card253)), (cacheCard (combine (4,5) #v[(cacheCard (placed 1 (2,5) card53)), (cacheCard (placed 3 (2,7) card56)), (cacheCard (placed 0 (4,3) card392))]))])), (cacheCard (combine (5,4) #v[(cacheCard (placed 4 (5,8) card11)), (cacheCard (placed 4 (4,8) card521)), (cacheCard (combine (5,3) #v[(cacheCard (placed 4 (5,7) card6)), (cacheCard (placed 6 (6,6) card89))]))]))]))]))
def card710 : Card := (cacheCard (combine (3,6) #v[(cacheCard (placed 0 (2,2) card13)), (cacheCard (placed 2 (4,2) card14)), (cacheCard (placed 1 (0,3) card117)), (cacheCard (combine (3,3) #v[(cacheCard (placed 4 (3,7) card7)), (cacheCard (placed 3 (0,6) card115)), (cacheCard (combine (3,2) #v[(cacheCard (placed 0 (3,2) card6)), (cacheCard (placed 3 (2,6) card196))])), (cacheCard (placed 1 (1,2) card577))]))]))
def card711 : Card := (cacheCard (combine (6,6) #v[(cacheCard (placed 2 (7,3) card120)), (cacheCard (placed 1 (1,4) card338)), (cacheCard (placed 1 (1,3) card437)), (cacheCard (placed 1 (0,4) card611)), (cacheCard (placed 3 (1,7) card613)), (cacheCard (placed 4 (1,10) card634)), (cacheCard (placed 4 (3,10) card642)), (cacheCard (placed 4 (3,10) card643)), (cacheCard (combine (6,5) #v[(cacheCard (placed 3 (1,6) card104)), (cacheCard (placed 3 (1,6) card359)), (cacheCard (placed 4 (1,9) card452)), (cacheCard (placed 0 (3,2) card476)), (cacheCard (placed 4 (3,9) card479)), (cacheCard (placed 2 (9,0) card520))]))]))
def card712 : Card := (cacheCard (combine (5,6) #v[(cacheCard (placed 4 (2,9) card174)), (cacheCard (placed 1 (2,3) card508)), (cacheCard (placed 5 (8,3) card508)), (cacheCard (placed 4 (2,9) card566)), (cacheCard (placed 1 (2,3) card605)), (cacheCard (placed 5 (8,3) card605)), (cacheCard (placed 4 (1,10) card647)), (cacheCard (placed 1 (0,2) card650)), (cacheCard (placed 5 (10,2) card650)), (cacheCard (combine (5,4) #v[(cacheCard (placed 3 (2,7) card116)), (cacheCard (placed 3 (2,8) card297)), (cacheCard (placed 5 (8,3) card435)), (cacheCard (placed 1 (2,3) card435)), (cacheCard (placed 7 (10,8) card649)), (cacheCard (combine (6,4) #v[(cacheCard (placed 4 (5,7) card44)), (cacheCard (placed 5 (10,3) card545)), (cacheCard (placed 7 (10,7) card655))]))])), (cacheCard (placed 2 (9,1) card661)), (cacheCard (placed 0 (2,1) card710)), (cacheCard (placed 0 (1,0) card711))]))
def card713 : Card := (cacheCard (combine (5,6) #v[(cacheCard (placed 1 (2,3) card508)), (cacheCard (placed 5 (8,3) card508)), (cacheCard (placed 1 (2,3) card605)), (cacheCard (placed 5 (8,3) card605)), (cacheCard (placed 4 (1,10) card645)), (cacheCard (placed 4 (1,10) card647)), (cacheCard (placed 1 (0,2) card650)), (cacheCard (placed 5 (10,2) card650)), (cacheCard (placed 4 (2,9) card654)), (cacheCard (placed 6 (8,9) card654)), (cacheCard (placed 0 (1,0) card711))]))
def card714 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 2 (3,2) card15)), (cacheCard (placed 3 (0,6) card88)), (cacheCard (combine (3,6) #v[(cacheCard (placed 0 (2,3) card41)), (cacheCard (placed 3 (0,6) card55))]))]))
def card715 : Card := (cacheCard (combine (5,6) #v[(cacheCard (placed 4 (2,9) card523)), (cacheCard (placed 1 (0,3) card532)), (cacheCard (placed 6 (8,9) card536)), (cacheCard (placed 6 (6,10) card545)), (cacheCard (placed 4 (2,10) card655)), (cacheCard (placed 1 (0,1) card664)), (cacheCard (combine (3,5) #v[(cacheCard (placed 1 (2,5) card44)), (cacheCard (placed 1 (2,5) card52)), (cacheCard (placed 2 (6,3) card134)), (cacheCard (combine (4,4) #v[(cacheCard (placed 6 (5,8) card53)), (cacheCard (placed 0 (4,2) card53)), (cacheCard (placed 0 (2,2) card111)), (cacheCard (placed 1 (2,4) card394))]))])), (cacheCard (combine (4,6) #v[(cacheCard (placed 2 (7,3) card361)), (cacheCard (placed 5 (8,5) card408)), (cacheCard (placed 7 (8,9) card621)), (cacheCard (placed 1 (0,3) card714)), (cacheCard (combine (7,5) #v[(cacheCard (placed 1 (3,5) card22)), (cacheCard (placed 1 (4,5) card74)), (cacheCard (placed 0 (3,1) card325)), (cacheCard (combine (7,6) #v[(cacheCard (placed 3 (4,6) card30)), (cacheCard (placed 0 (4,3) card110)), (cacheCard (placed 1 (3,4) card296)), (cacheCard (placed 0 (4,3) card511))]))]))]))]))
def card716 : Card := (cacheCard (combine (7,5) #v[(cacheCard (placed 1 (3,4) card9)), (cacheCard (placed 4 (4,6) card49)), (cacheCard (placed 0 (3,2) card142)), (cacheCard (combine (6,4) #v[(cacheCard (placed 0 (4,2) card55)), (cacheCard (placed 2 (7,0) card659))]))]))
def card717 : Card := (cacheCard (combine (6,6) #v[(cacheCard (placed 1 (2,5) card192)), (cacheCard (placed 7 (8,7) card192)), (cacheCard (placed 2 (10,1) card550)), (cacheCard (placed 4 (0,11) card550)), (cacheCard (placed 0 (3,3) card578)), (cacheCard (placed 6 (7,9) card578)), (cacheCard (placed 1 (1,3) card622)), (cacheCard (placed 7 (9,9) card622)), (cacheCard (placed 0 (0,1) card716)), (cacheCard (placed 6 (10,11) card716))]))
def card718 : Card := (cacheCard (combine (7,5) #v[(cacheCard (placed 6 (8,8) card120)), (cacheCard (placed 3 (2,7) card276)), (cacheCard (placed 3 (2,7) card338)), (cacheCard (placed 3 (2,8) card437)), (cacheCard (placed 3 (1,7) card611)), (cacheCard (placed 0 (4,1) card642)), (cacheCard (placed 0 (4,1) card643)), (cacheCard (combine (6,5) #v[(cacheCard (placed 5 (8,5) card44)), (cacheCard (placed 5 (8,5) card52)), (cacheCard (placed 6 (8,7) card155)), (cacheCard (placed 3 (2,8) card341))])), (cacheCard (combine (7,6) #v[(cacheCard (placed 0 (2,2) card452)), (cacheCard (placed 2 (10,0) card520)), (cacheCard (placed 4 (5,9) card587)), (cacheCard (placed 7 (8,6) card612)), (cacheCard (placed 0 (2,1) card633))])), (cacheCard (combine (7,6) #v[(cacheCard (placed 5 (10,5) card329)), (cacheCard (placed 0 (2,2) card452)), (cacheCard (placed 4 (6,9) card462)), (cacheCard (combine (6,6) #v[(cacheCard (placed 3 (4,6) card52)), (cacheCard (placed 7 (8,6) card52)), (cacheCard (placed 1 (4,5) card232)), (cacheCard (placed 5 (8,5) card232))])), (cacheCard (combine (7,4) #v[(cacheCard (placed 4 (6,8) card12)), (cacheCard (placed 6 (8,8) card12)), (cacheCard (placed 0 (6,2) card12)), (cacheCard (placed 2 (8,3) card377)), (cacheCard (combine (7,3) #v[(cacheCard (placed 3 (6,6) card8)), (cacheCard (placed 5 (9,3) card229))]))])), (cacheCard (combine (6,6) #v[(cacheCard (placed 5 (8,5) card315)), (cacheCard (placed 0 (4,2) card317)), (cacheCard (placed 4 (3,9) card640))]))]))]))
def card719 : Card := (cacheCard (combine (3,3) #v[(cacheCard (placed 2 (3,0) card318)), (cacheCard (placed 4 (2,7) card334)), (cacheCard (combine (3,6) #v[(cacheCard (placed 0 (2,2) card53)), (cacheCard (placed 6 (3,8) card53)), (cacheCard (placed 6 (3,7) card209)), (cacheCard (combine (4,6) #v[(cacheCard (placed 1 (0,5) card53)), (cacheCard (placed 7 (6,6) card53)), (cacheCard (placed 7 (5,6) card209)), (cacheCard (combine (4,7) #v[(cacheCard (placed 1 (3,3) card1)), (cacheCard (combine (4,8) #v[(cacheCard (placed 7 (4,9) card0)), (cacheCard (combine (4,5) #v[(cacheCard (placed 3 (2,8) card45)), (cacheCard (placed 5 (6,5) card343)), (cacheCard (combine (3,8) #v[(cacheCard (placed 5 (4,5) card5)), (cacheCard (placed 0 (3,4) card412))]))]))]))]))]))])), (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (2,1) card65)), (cacheCard (placed 1 (0,3) card301)), (cacheCard (placed 7 (5,5) card417))])), (cacheCard (combine (3,4) #v[(cacheCard (placed 2 (3,2) card15)), (cacheCard (placed 0 (2,1) card65)), (cacheCard (placed 1 (1,3) card72))]))]))
def card720 : Card := (cacheCard (combine (7,6) #v[(cacheCard (placed 7 (8,6) card54)), (cacheCard (placed 7 (8,6) card64)), (cacheCard (combine (3,5) #v[(cacheCard (placed 7 (6,6) card10)), (cacheCard (placed 2 (6,3) card180)), (cacheCard (placed 1 (3,5) card200))])), (cacheCard (combine (7,5) #v[(cacheCard (placed 1 (3,4) card40)), (cacheCard (placed 1 (3,4) card310)), (cacheCard (combine (5,7) #v[(cacheCard (placed 7 (5,8) card0)), (cacheCard (combine (7,7) #v[(cacheCard (placed 2 (8,3) card12)), (cacheCard (placed 2 (8,3) card13)), (cacheCard (placed 6 (8,10) card369)), (cacheCard (placed 1 (5,4) card474)), (cacheCard (combine (6,7) #v[(cacheCard (placed 2 (7,4) card52)), (cacheCard (placed 1 (4,6) card315))])), (cacheCard (combine (7,4) #v[(cacheCard (placed 7 (8,7) card197)), (cacheCard (placed 5 (8,4) card201))]))]))]))]))]))
def card721 : Card := (cacheCard (combine (5,4) #v[(cacheCard (placed 2 (6,1) card14)), (cacheCard (placed 4 (2,6) card176)), (cacheCard (placed 0 (2,2) card216)), (cacheCard (placed 1 (2,3) card218)), (cacheCard (combine (5,6) #v[(cacheCard (placed 4 (5,7) card7)), (cacheCard (placed 5 (6,3) card8)), (cacheCard (combine (2,4) #v[(cacheCard (placed 7 (6,6) card25)), (cacheCard (combine (3,6) #v[(cacheCard (placed 2 (3,2) card22)), (cacheCard (combine (4,6) #v[(cacheCard (placed 5 (5,3) card5)), (cacheCard (combine (2,6) #v[(cacheCard (placed 4 (2,6) card5)), (cacheCard (placed 6 (5,7) card208))]))]))]))]))]))]))
def card722 : Card := (cacheCard (combine (4,4) #v[(cacheCard (placed 2 (5,1) card13)), (cacheCard (placed 4 (1,6) card176)), (cacheCard (combine (4,6) #v[(cacheCard (placed 5 (5,3) card8)), (cacheCard (placed 4 (3,7) card9)), (cacheCard (placed 6 (5,8) card366)), (cacheCard (combine (3,4) #v[(cacheCard (placed 0 (3,3) card17)), (cacheCard (placed 7 (5,6) card32))]))])), (cacheCard (combine (5,4) #v[(cacheCard (placed 6 (5,4) card2)), (cacheCard (placed 1 (2,2) card345))])), (cacheCard (combine (3,4) #v[(cacheCard (placed 6 (5,4) card0)), (cacheCard (placed 2 (5,2) card307))])), (cacheCard (combine (3,4) #v[(cacheCard (placed 6 (5,4) card0)), (cacheCard (placed 0 (2,1) card267))]))]))
def card723 : Card := (cacheCard (combine (5,5) #v[(cacheCard (placed 0 (1,1) card328)), (cacheCard (placed 0 (1,1) card330)), (cacheCard (combine (4,5) #v[(cacheCard (placed 6 (5,7) card46)), (cacheCard (placed 0 (2,1) card321))])), (cacheCard (combine (2,4) #v[(cacheCard (placed 6 (3,8) card53)), (cacheCard (placed 0 (2,2) card53)), (cacheCard (placed 1 (1,4) card310))])), (cacheCard (combine (5,7) #v[(cacheCard (combine (3,7) #v[(cacheCard (placed 6 (3,8) card44)), (cacheCard (placed 6 (3,8) card52)), (cacheCard (placed 5 (5,4) card180)), (cacheCard (combine (3,4) #v[(cacheCard (placed 6 (4,8) card9)), (cacheCard (placed 3 (2,7) card90)), (cacheCard (placed 5 (6,4) card99))]))])), (cacheCard (combine (5,6) #v[(cacheCard (placed 0 (2,4) card82)), (cacheCard (placed 4 (2,8) card176)), (cacheCard (placed 1 (2,5) card218)), (cacheCard (placed 6 (6,10) card369))])), (cacheCard (combine (3,7) #v[(cacheCard (placed 6 (3,8) card44)), (cacheCard (placed 6 (3,8) card52)), (cacheCard (placed 5 (5,4) card180)), (cacheCard (combine (3,4) #v[(cacheCard (placed 1 (2,4) card145)), (cacheCard (placed 3 (2,7) card314))]))])), (cacheCard (combine (5,6) #v[(cacheCard (placed 2 (6,3) card13)), (cacheCard (placed 4 (4,9) card192)), (cacheCard (placed 6 (6,10) card369)), (cacheCard (placed 1 (2,4) card435)), (cacheCard (placed 1 (3,4) card474)), (cacheCard (placed 3 (3,8) card477))])), (cacheCard (placed 0 (0,2) card721)), (cacheCard (placed 0 (1,2) card722))]))]))
def card724 : Card := (cacheCard (combine (6,8) #v[(cacheCard (placed 5 (9,5) card523)), (cacheCard (placed 5 (9,5) card524)), (cacheCard (placed 1 (1,5) card677)), (cacheCard (combine (4,8) #v[(cacheCard (placed 0 (3,5) card57)), (cacheCard (placed 2 (7,5) card111)), (cacheCard (placed 5 (10,7) card390)), (cacheCard (placed 0 (4,5) card397))])), (cacheCard (combine (7,8) #v[(cacheCard (placed 1 (3,6) card188)), (cacheCard (placed 3 (3,10) card188)), (cacheCard (placed 0 (5,5) card258)), (cacheCard (combine (4,8) #v[(cacheCard (placed 5 (8,7) card19)), (cacheCard (placed 7 (8,9) card19)), (cacheCard (placed 0 (4,6) card395))])), (cacheCard (combine (4,8) #v[(cacheCard (placed 5 (8,7) card19)), (cacheCard (placed 2 (7,5) card231)), (cacheCard (placed 0 (4,5) card279))])), (cacheCard (combine (6,9) #v[(cacheCard (placed 6 (6,11) card53)), (cacheCard (placed 0 (4,6) card637))]))])), (cacheCard (placed 7 (10,10) card719)), (cacheCard (combine (4,7) #v[(cacheCard (placed 7 (8,8) card53)), (cacheCard (placed 1 (2,7) card53)), (cacheCard (placed 7 (10,12) card720)), (cacheCard (placed 1 (0,3) card720))])), (cacheCard (combine (6,7) #v[(cacheCard (placed 0 (4,4) card512)), (cacheCard (placed 3 (2,10) card600)), (cacheCard (placed 6 (9,11) card621)), (cacheCard (placed 1 (3,6) card702)), (cacheCard (placed 2 (8,3) card714))])), (cacheCard (combine (4,8) #v[(cacheCard (placed 0 (3,5) card88)), (cacheCard (placed 2 (7,5) card231)), (cacheCard (placed 5 (8,6) card267)), (cacheCard (combine (7,8) #v[(cacheCard (placed 3 (3,8) card7)), (cacheCard (placed 1 (3,7) card9)), (cacheCard (placed 0 (4,5) card604))]))])), (cacheCard (placed 6 (8,13) card723))]))
def card725 : Card := (cacheCard (combine (7,8) #v[(cacheCard (placed 4 (6,12) card459)), (cacheCard (placed 7 (11,9) card579)), (cacheCard (placed 6 (11,12) card581)), (cacheCard (placed 4 (4,11) card654)), (cacheCard (placed 0 (3,3) card661)), (cacheCard (placed 6 (10,12) card677)), (cacheCard (placed 7 (12,11) card682)), (cacheCard (placed 4 (2,13) card694)), (cacheCard (placed 0 (2,2) card696)), (cacheCard (placed 6 (11,12) card698)), (cacheCard (placed 0 (2,2) card709)), (cacheCard (placed 0 (4,3) card710)), (cacheCard (placed 3 (2,12) card715)), (cacheCard (placed 7 (13,12) card717)), (cacheCard (placed 0 (2,2) card718)), (cacheCard (placed 6 (12,15) card724))]))
def card726 : Card := (cacheCard (combine (8,7) #v[(cacheCard (placed 1 (3,6) card459)), (cacheCard (placed 4 (6,11) card579)), (cacheCard (placed 1 (3,3) card581)), (cacheCard (placed 1 (4,4) card654)), (cacheCard (placed 5 (12,3) card661)), (cacheCard (placed 3 (3,10) card677)), (cacheCard (placed 4 (4,12) card682)), (cacheCard (placed 1 (2,2) card694)), (cacheCard (placed 5 (13,2) card696)), (cacheCard (placed 3 (3,11) card698)), (cacheCard (placed 5 (13,2) card709)), (cacheCard (placed 5 (12,4) card710)), (cacheCard (placed 0 (3,2) card715)), (cacheCard (placed 4 (3,13) card717)), (cacheCard (placed 5 (13,2) card718)), (cacheCard (placed 5 (15,2) card724))]))
def card727 : Card := (cacheCard (combine (8,8) #v[(cacheCard (placed 0 (4,3) card648)), (cacheCard (placed 1 (3,4) card648)), (cacheCard (placed 3 (3,12) card648)), (cacheCard (placed 4 (4,13) card648)), (cacheCard (placed 1 (0,0) card708)), (cacheCard (placed 2 (16,0) card708)), (cacheCard (placed 4 (0,16) card708)), (cacheCard (placed 7 (16,16) card708)), (cacheCard (placed 0 (3,3) card712)), (cacheCard (placed 1 (3,3) card712)), (cacheCard (placed 2 (13,3) card712)), (cacheCard (placed 3 (3,13) card712)), (cacheCard (placed 4 (3,13) card712)), (cacheCard (placed 5 (13,3) card712)), (cacheCard (placed 6 (13,13) card712)), (cacheCard (placed 7 (13,13) card712)), (cacheCard (placed 2 (13,3) card713)), (cacheCard (placed 3 (3,13) card713)), (cacheCard (placed 4 (3,13) card713)), (cacheCard (placed 5 (13,3) card713)), (cacheCard (placed 0 (1,1) card725)), (cacheCard (placed 1 (1,1) card725)), (cacheCard (placed 2 (15,1) card725)), (cacheCard (placed 3 (1,15) card725)), (cacheCard (placed 4 (1,15) card725)), (cacheCard (placed 5 (15,1) card725)), (cacheCard (placed 6 (15,15) card725)), (cacheCard (placed 7 (15,15) card725)), (cacheCard (placed 1 (1,1) card726)), (cacheCard (placed 2 (15,1) card726)), (cacheCard (placed 4 (1,15) card726)), (cacheCard (placed 6 (15,15) card726))]))

def T727 : Finset Cell := card727.T
def axis17 : Finset ℤ := (Finset.range 17).image Int.ofNat
def board17 : Finset Cell := axis17.product axis17

theorem mem_axis17 (x : ℤ) : x ∈ axis17 ↔ 0 ≤ x ∧ x ≤ 16 := by
  simp only [axis17, Finset.mem_image, Finset.mem_range]
  constructor
  · rintro ⟨n,hn,rfl⟩
    change 0 ≤ (n : ℤ) ∧ (n : ℤ) ≤ 16
    omega
  · rintro ⟨hx0,hx16⟩
    refine ⟨x.toNat,by omega,?_⟩
    change (x.toNat : ℤ) = x
    omega

set_option maxHeartbeats 20000000 in
set_option maxRecDepth 65536 in
theorem endpoint :
    card727.A = ∅ ∧ card727.h = 21 ∧ card727.T.card = 251 ∧
      (∀ p ∈ card727.T, 0 ≤ p.1 ∧ p.1 ≤ 16 ∧ 0 ≤ p.2 ∧ p.2 ≤ 16) := by
  decide +kernel

theorem supported_root : WinIn HasSnaky T727 21 ∅ ∅ := by
  have hw := card727.valid card727.T ∅ ∅ (Finset.Subset.refl _)
    (by simp) (by simp [endpoint.1]) (by simp)
    (by norm_num [endpoint.2.1, endpoint.2.2.1])
  simpa only [endpoint.2.1, T727] using hw

theorem not_hasSnaky_empty : ¬HasSnaky ∅ := by
  rintro ⟨r,t,h⟩
  have hx := h (Finset.mem_image_of_mem (place r t)
    (show (0,0) ∈ snaky by decide))
  simp at hx

theorem fixed_confined_policy :
    ∃ σ : Policy Cell,
      Forces σ HasSnaky T727 21 ∅ ∅ ∧
      ∀ β : ℕ → Cell, Legal σ HasSnaky β 21 0 ∅ ∅ →
        ∃ F G c d, Execution σ HasSnaky T727 β 21 0 ∅ ∅ F G c d ∧
          HasSnaky F ∧ Disjoint F G ∧ F ⊆ T727 ∧
          F.card = c ∧ G.card = d ∧ c ≤ 21 ∧ d ≤ 20 ∧ c = d+1 := by
  have hf := fixed_policy supported_root
  refine ⟨policy HasSnaky T727,hf,?_⟩
  intro β hl
  obtain ⟨F,G,c,d,he⟩ := hf.executes β 0 (by simp) hl
  obtain ⟨hw,hd,_,_,hs,hc,hb,hcn,hdn,hcd⟩ := he.summary
  refine ⟨F,G,c,d,he,hw,hd,?_,?_,?_,hcn,by omega,?_⟩
  · simpa only [Finset.empty_union] using hs
  · simpa only [Finset.card_empty, Nat.zero_add] using hc
  · simpa only [Finset.card_empty, Nat.zero_add] using hb
  · exact hcd.resolve_left not_hasSnaky_empty

theorem finite_board_has_room (M B : Finset Cell)
    (h : M.card + B.card ≤ 40) :
    ∃ x ∈ T727, x ∉ M ∧ x ∉ B := by
  apply fresh_in
  have hc : T727.card = 251 := endpoint.2.2.1
  omega

theorem envelope_in_board17 : T727 ⊆ board17 := by
  intro p hp
  obtain ⟨hx0,hx16,hy0,hy16⟩ := endpoint.2.2.2 p hp
  exact Finset.mem_product.mpr ⟨(mem_axis17 _).mpr ⟨hx0,hx16⟩,
    (mem_axis17 _).mpr ⟨hy0,hy16⟩⟩

theorem finite_board_corollaries :
    T727.card = 251 ∧ board17.card = 289 ∧ T727 ⊆ board17 ∧
    ∃ σ : Policy Cell,
      Forces σ HasSnaky T727 21 ∅ ∅ ∧
      ∀ Q : Finset Cell, T727 ⊆ Q →
        ∀ β : ℕ → Cell, Legal σ HasSnaky β 21 0 ∅ ∅ →
          ∃ F G c d, Execution σ HasSnaky T727 β 21 0 ∅ ∅ F G c d ∧
            HasSnaky F ∧ Disjoint F G ∧ F ⊆ Q ∧
            F.card = c ∧ G.card = d ∧ c ≤ 21 ∧ d ≤ 20 ∧ c = d+1 := by
  obtain ⟨σ,hf,hw⟩ := fixed_confined_policy
  refine ⟨endpoint.2.2.1,by decide +kernel,envelope_in_board17,σ,hf,?_⟩
  intro Q hQ β hl
  obtain ⟨F,G,c,d,he,hs,hd,hT,hc,hb,hcn,hdn,hcd⟩ := hw β hl
  exact ⟨F,G,c,d,he,hs,hd,hT.trans hQ,hc,hb,hcn,hdn,hcd⟩

#print axioms fixed_confined_policy
#print axioms finite_board_corollaries

end SnakyFinite
