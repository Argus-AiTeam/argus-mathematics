import Mathlib

noncomputable section

open CategoryTheory CategoryTheory.Limits

namespace CouniversalityAudit

universe u v w z

def edge {α : Type u} (a b : α) : (α × α) →₀ ℤ := by
  classical
  exact if a = b then 0 else Finsupp.single (a, b) 1

theorem edge_identity_iff {E : Type u} [PartialOrder E]
    (a b c : E) (hab : a ≤ b) (hbc : b ≤ c) :
    edge a c - edge a b = edge b c ↔ a = b ∨ b = c := by
  classical
  constructor
  · intro h
    by_contra hn
    have habn : a ≠ b := fun he => hn (Or.inl he)
    have hbcn : b ≠ c := fun he => hn (Or.inr he)
    have hacn : a ≠ c := by
      intro he
      apply habn
      exact le_antisymm hab (by simpa [he] using hbc)
    have hc := congrArg (fun q : (E × E) →₀ ℤ => q (a, c)) h
    simp [edge, habn, hbcn, hacn, Ne.symm hbcn] at hc
  · rintro (rfl | rfl) <;> simp [edge]

def normalized {α : Type u} (l : List α) : (List α) →₀ ℤ := by
  classical
  exact if l.Nodup then Finsupp.single l 1 else 0

theorem normalized_repeat {α : Type u} (pre post : List α) (a : α) :
    normalized (pre ++ a :: a :: post) = 0 := by
  classical
  simp [normalized, List.nodup_append]

theorem normalized_last_duplicate {α : Type u} (l : List α) (a : α) :
    normalized (l ++ [a, a]) = 0 := by
  exact normalized_repeat l [] a

def AppendControl {E : Type u} [LE E] (f g : E → E) : Prop :=
  ∀ x y, x ≤ y → f x = g x ∨ g x = g y

theorem append_control_iff_edge_identities {E : Type u} [PartialOrder E]
    (f g : E → E) (hg : Monotone g) (hfg : ∀ x, f x ≤ g x) :
    AppendControl f g ↔
      ∀ x y, x ≤ y →
        edge (f x) (g y) - edge (f x) (g x) = edge (g x) (g y) := by
  constructor
  · intro hc x y hxy
    exact (edge_identity_iff _ _ _ (hfg x) (hg hxy)).mpr (hc x y hxy)
  · intro he x y hxy
    exact (edge_identity_iff _ _ _ (hfg x) (hg hxy)).mp (he x y hxy)

theorem terminal_correction {E : Type u} [PartialOrder E]
    (f g : E → E) (hg : Monotone g) (hc : AppendControl f g)
    (l : List E) (u v : E)
    (hl : ∀ x ∈ l, x ≤ u) (huv : u ≤ v) :
    normalized (((l ++ [u]).map f) ++ [g v]) -
        normalized (((l ++ [u]).map f) ++ [g u]) =
      normalized ((l ++ [u, v]).map g) := by
  classical
  by_cases hlast : g u = g v
  · rw [hlast]
    simp [List.map_append, ← hlast, normalized_last_duplicate]
  · have hmap : (l ++ [u]).map f = (l ++ [u]).map g := by
      apply List.map_congr_left
      intro x hx
      have hxu : x ≤ u := by
        rcases List.mem_append.mp hx with hx | hx
        · exact hl x hx
        · have he : x = u := by simpa using hx
          exact le_of_eq he
      have hxv : x ≤ v := le_trans hxu huv
      rcases hc x v hxv with he | he
      · exact he
      · exfalso
        apply hlast
        apply le_antisymm (hg huv)
        simpa [← he] using hg hxu
    rw [hmap]
    simp [List.map_append, List.append_assoc, normalized_last_duplicate]

theorem sieve_constancy_implies_control {E : Type u} [PartialOrder E]
    (A : Set E) (hA : IsLowerSet A) (f g : E → E)
    (hold : ∀ x ∈ A, f x = g x)
    (hnew : ∀ x ∉ A, ∀ y ∉ A, g x = g y) :
    AppendControl f g := by
  intro x y hxy
  by_cases hx : x ∈ A
  · exact Or.inl (hold x hx)
  · have hy : y ∉ A := fun hy => hx (hA hxy hy)
    exact Or.inr (hnew x hx y hy)

theorem glue_along_adjunction
    {C : Type u} [Category.{v} C] {D : Type w} [Category.{z} D]
    {L : C ⥤ D} {R : D ⥤ C} (adj : L ⊣ R)
    {A X B Y : C} {a : A ⟶ X} {i : A ⟶ B}
    {j : X ⟶ Y} {b : B ⟶ Y} (sq : IsPushout a i j b)
    (Z : D) (s : L.obj X ⟶ Z) (p : L.obj B ⟶ Z)
    (h : L.map a ≫ s = L.map i ≫ p) :
    ∃! q : L.obj Y ⟶ Z, L.map j ≫ q = s ∧ L.map b ≫ q = p := by
  let tx := (adj.homEquiv X Z) s
  let tb := (adj.homEquiv B Z) p
  have ht : a ≫ tx = i ≫ tb := by
    dsimp [tx, tb]
    rw [← adj.homEquiv_naturality_left, ← adj.homEquiv_naturality_left, h]
  let d := sq.desc tx tb ht
  refine ⟨(adj.homEquiv Y Z).symm d, ?_, ?_⟩
  · constructor
    · rw [← adj.homEquiv_naturality_left_symm]
      change (adj.homEquiv X Z).symm (j ≫ sq.desc tx tb ht) = s
      rw [sq.inl_desc]
      exact (adj.homEquiv X Z).symm_apply_apply s
    · rw [← adj.homEquiv_naturality_left_symm]
      change (adj.homEquiv B Z).symm (b ≫ sq.desc tx tb ht) = p
      rw [sq.inr_desc]
      exact (adj.homEquiv B Z).symm_apply_apply p
  · intro q hq
    apply (adj.homEquiv Y Z).injective
    rw [Equiv.apply_symm_apply]
    apply sq.hom_ext
    · rw [← adj.homEquiv_naturality_left, hq.1]
      exact (sq.inl_desc tx tb ht).symm
    · rw [← adj.homEquiv_naturality_left, hq.2]
      exact (sq.inr_desc tx tb ht).symm

#print axioms edge_identity_iff
#print axioms append_control_iff_edge_identities
#print axioms terminal_correction
#print axioms sieve_constancy_implies_control
#print axioms glue_along_adjunction

end CouniversalityAudit

end
