import Mathlib

namespace AllParabolicReduction

def orbit {T : Type*} (f : T → T) (x : T) : ℕ → T
  | 0 => x
  | n + 1 => f (orbit f x n)

def SequentialChainComplete (T : Type*) [Preorder T] : Prop :=
  ∀ c : ℕ → T, Monotone c → ∃ z, IsLUB (Set.range c) z

def SemilinearBelow (T : Type*) [Preorder T] : Prop :=
  ∀ a b c : T, a ≤ c → b ≤ c → a ≤ b ∨ b ≤ a

theorem increasing_orbit_fixed
    {T : Type*} [PartialOrder T]
    (complete : SequentialChainComplete T)
    (f : T ≃o T) (x : T) (up : x ≤ f x) :
    ∃ z, x ≤ z ∧ f z = z := by
  have step : ∀ n, orbit f x n ≤ orbit f x (n + 1) := by
    intro n
    induction n with
    | zero => exact up
    | succ n ih => exact f.monotone ih
  have mono : Monotone (orbit f x) := monotone_nat_of_le_succ step
  obtain ⟨z, upper, least⟩ := complete (orbit f x) mono
  have xz : x ≤ z := upper ⟨0, rfl⟩
  have zpre : z ≤ f.symm z := by
    apply least
    rintro _ ⟨n, rfl⟩
    have hn : f (orbit f x n) ≤ z := upper ⟨n + 1, rfl⟩
    simpa only [OrderIso.symm_apply_apply] using f.symm.monotone hn
  have fz : f z ≤ z := by
    simpa only [OrderIso.apply_symm_apply] using f.monotone zpre
  have zf : z ≤ f z := by
    apply least
    rintro _ ⟨n, rfl⟩
    cases n with
    | zero => exact up.trans (f.monotone xz)
    | succ n => exact f.monotone (upper ⟨n, rfl⟩)
  exact ⟨z, xz, le_antisymm fz zf⟩

theorem fixed_above_meet
    {T : Type*} [SemilatticeInf T]
    (semilinear : SemilinearBelow T)
    (complete : SequentialChainComplete T)
    (f : T ≃o T) (y : T) :
    ∃ z, y ⊓ f y ≤ z ∧ f z = z := by
  let x := y ⊓ f y
  have left : x ≤ f y := inf_le_right
  have right : f x ≤ f y := f.monotone inf_le_left
  rcases semilinear x (f x) (f y) left right with up | down
  · exact increasing_orbit_fixed complete f x up
  · have up : x ≤ f.symm x := by
      simpa only [OrderIso.symm_apply_apply] using f.symm.monotone down
    obtain ⟨z, xz, hz⟩ := increasing_orbit_fixed complete f.symm x up
    have fz : f z = z := by
      have h := congrArg f hz
      simpa only [OrderIso.apply_symm_apply] using h.symm
    exact ⟨z, xz, fz⟩

theorem second_fixed_point_outside
    {T : Type*} [SemilatticeInf T]
    (semilinear : SemilinearBelow T)
    (complete : SequentialChainComplete T)
    (f : T ≃o T) (U V : Set T)
    (nonempty : U.Nonempty)
    (forward : ∀ y ∈ U, f y ∈ U)
    (meet_closed : ∀ a ∈ U, ∀ b ∈ U, a ⊓ b ∈ U)
    (disjoint : Disjoint U V)
    (lower : ∀ a b, a ≤ b → b ∈ V → a ∈ V) :
    ∃ z, z ∉ V ∧ f z = z := by
  obtain ⟨y, hy⟩ := nonempty
  have hm : y ⊓ f y ∈ U := meet_closed y hy (f y) (forward y hy)
  obtain ⟨z, hz, fixed⟩ := fixed_above_meet semilinear complete f y
  refine ⟨z, ?_, fixed⟩
  intro zv
  exact Set.disjoint_left.mp disjoint hm (lower _ _ hz zv)

theorem facing_terminal_class_singleton
    {T : Type*} (interval : T → T → Set T)
    (U V : Set T) (p : T)
    (nonempty : U.Nonempty)
    (disjoint : Disjoint U V)
    (hp : p ∈ V)
    (facing : ∀ u ∈ U, ∀ v ∈ V, p ∈ interval u v)
    (terminal : ∀ a b, p ∈ interval a b → p = a ∨ p = b) :
    V = {p} := by
  obtain ⟨u, hu⟩ := nonempty
  have pne : p ≠ u := by
    intro h
    exact Set.disjoint_left.mp disjoint hu (h ▸ hp)
  ext v
  constructor
  · intro hv
    rcases terminal u v (facing u hu v hv) with bad | good
    · exact (pne bad).elim
    · simpa only [Set.mem_singleton_iff] using good.symm
  · intro hv
    simp only [Set.mem_singleton_iff] at hv
    simpa only [hv] using hp

theorem finite_eventual_stage
    {I A : Type*} [LinearOrder I]
    (limit : I) (items : Finset A) (E : I → A → Prop)
    (below : ∃ i, i < limit)
    (persistent : ∀ i j, i ≤ j → ∀ a, E i a → E j a)
    (eventual : ∀ a ∈ items, ∃ i, i < limit ∧ E i a) :
    ∃ i, i < limit ∧ ∀ a ∈ items, E i a := by
  classical
  induction items using Finset.induction_on with
  | empty =>
      obtain ⟨i, hi⟩ := below
      exact ⟨i, hi, by simp⟩
  | @insert a items not_mem ih =>
      have old : ∀ b ∈ items, ∃ i, i < limit ∧ E i b := by
        intro b hb
        exact eventual b (Finset.mem_insert_of_mem hb)
      obtain ⟨i, hi, all_old⟩ := ih old
      obtain ⟨j, hj, new⟩ := eventual a (Finset.mem_insert_self a items)
      refine ⟨max i j, max_lt hi hj, ?_⟩
      intro b hb
      rcases Finset.mem_insert.mp hb with rfl | hb
      · exact persistent j (max i j) (le_max_right _ _) b new
      · exact persistent i (max i j) (le_max_left _ _) b (all_old b hb)

def relationStabilizer
    {G T : Type*} [Group G] [MulAction G T]
    (R : T → T → Prop) (equiv : Equivalence R)
    (invariant : ∀ (g : G) (a b : T), R a b → R (g • a) (g • b))
    (x : T) : Subgroup G where
  carrier := {g | R x (g • x)}
  one_mem' := by
    change R x ((1 : G) • x)
    simpa only [one_smul] using equiv.refl x
  mul_mem' := by
    intro g h hg hh
    exact equiv.trans hg (by simpa only [mul_smul] using invariant g x (h • x) hh)
  inv_mem' := by
    intro g hg
    have h := invariant g⁻¹ x (g • x) hg
    have hi : R (g⁻¹ • x) x := by simpa only [inv_smul_smul] using h
    exact equiv.symm hi

theorem generators_fix_class
    {G T : Type*} [Group G] [MulAction G T]
    (R : T → T → Prop) (equiv : Equivalence R)
    (invariant : ∀ (g : G) (a b : T), R a b → R (g • a) (g • b))
    (x : T) (S : Set G) (generates : Subgroup.closure S = ⊤)
    (fixes : ∀ g ∈ S, R x (g • x)) :
    ∀ g : G, R x (g • x) := by
  let H := relationStabilizer R equiv invariant x
  have contained : S ⊆ H := fixes
  have closed : Subgroup.closure S ≤ H := (Subgroup.closure_le H).mpr contained
  have all : (⊤ : Subgroup G) ≤ H := by simpa only [generates] using closed
  intro g
  exact all (by trivial)

theorem no_first_fixed_at_limit
    {I G T : Type*} [LinearOrder I] [Group G] [MulAction G T]
    (limit : I) (R : I → T → T → Prop)
    (equiv : ∀ i, Equivalence (R i))
    (invariant : ∀ (i : I) (g : G) (a b : T), R i a b → R i (g • a) (g • b))
    (persistent : ∀ i j, i ≤ j → ∀ a b, R i a b → R j a b)
    (x : T) (S : Finset G)
    (generates : Subgroup.closure (↑S : Set G) = ⊤)
    (below : ∃ i, i < limit)
    (eventual : ∀ g ∈ S, ∃ i, i < limit ∧ R i x (g • x)) :
    ∃ i, i < limit ∧ ∀ g : G, R i x (g • x) := by
  obtain ⟨i, hi, hS⟩ := finite_eventual_stage limit S
    (fun i g => R i x (g • x)) below
    (fun i j hij g h => persistent i j hij x (g • x) h) eventual
  exact ⟨i, hi, generators_fix_class (R i) (equiv i) (invariant i) x
    (↑S : Set G) generates hS⟩

theorem doubling_fixed_iff (x : ℚ) : 2 * x = x ↔ x = 0 := by
  constructor
  · intro h
    linarith
  · rintro rfl
    norm_num

end AllParabolicReduction
