/-
Portions adapted from OpenAI's math repository under Apache 2.0; see LICENSE.
Adapted for campaign 9000133 from the nine named VariableWL source modules.
Changes: no machine/refinement dependencies; arbitrary finite address alphabet,
unrestricted finite real dimensions, and possibly empty coordinate domains;
alignment_link is proved structurally, without the binary-permutation shortcut.
All mathematical dependencies of the projection theorem are included below.
-/
import Mathlib


/- Adapted from Affine.lean. -/
namespace ProjectionAudit
universe uAffine5
namespace VariableWL.Affine

abbrev Bit := ZMod 2
abbrev Vec (d : ℕ) := Fin d → Bit
abbrev SquareVal (d e : ℕ) := (Vec d × Vec e) × (Bit × Bit)

open scoped CharTwo

variable {d e : ℕ}

def boundary (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit)
    (z : SquareVal d e) : Bit :=
  L z.1.1 + R z.1.2 + z.2.1 + z.2.2

def Fiber (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit) (c : Bit) :=
  { z : SquareVal d e | boundary L R z = c }

@[simp] theorem boundary_add (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit)
    (z w : SquareVal d e) : boundary L R (z + w) = boundary L R z + boundary L R w := by
  simp only [boundary, Prod.fst_add, Prod.snd_add, map_add]
  ring

@[simp] theorem boundary_zero (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit) :
    boundary L R 0 = 0 := by
  simp [boundary]

def kernel (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit) :
    Submodule Bit (SquareVal d e) where
  carrier := Fiber L R 0
  zero_mem' := boundary_zero L R
  add_mem' := by
    intro z w hz hw
    change boundary L R (z + w) = 0
    rw [boundary_add, hz, hw, add_zero]
  smul_mem' := by
    intro a z hz
    change boundary L R (a • z) = 0
    change boundary L R z = 0 at hz
    simp only [boundary, Prod.smul_fst, Prod.smul_snd, map_smul, smul_eq_mul] at *
    calc
      a * L z.1.1 + a * R z.1.2 + a * z.2.1 + a * z.2.2 =
          a * (L z.1.1 + R z.1.2 + z.2.1 + z.2.2) := by ring
      _ = 0 := by rw [hz, mul_zero]

theorem fiber_nonempty (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit) (c : Bit) :
    (Fiber L R c).Nonempty := by
  exact ⟨((0, 0), (c, 0)), by simp [Fiber, boundary]⟩

theorem fiber_translate (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit)
    {c : Bit} {ξ : SquareVal d e} (hξ : ξ ∈ Fiber L R c) :
    (fun z => z + ξ) '' Fiber L R 0 = Fiber L R c := by
  ext w
  constructor
  · rintro ⟨z, hz, rfl⟩
    change boundary L R (z + ξ) = c
    rw [boundary_add, hz, hξ, zero_add]
  · intro hw
    refine ⟨w - ξ, ?_, sub_add_cancel _ _⟩
    change boundary L R (w - ξ) = 0
    change boundary L R w = c at hw
    change boundary L R ξ = c at hξ
    have hsub : boundary L R (w - ξ) = boundary L R w - boundary L R ξ := by
      simp only [boundary, Prod.fst_sub, Prod.snd_sub, map_sub]
      ring
    rw [hsub, hw, hξ, sub_self]

theorem fiber_full_left (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit)
    (c : Bit) (x : Vec d) : ∃ z ∈ Fiber L R c, z.1.1 = x := by
  refine ⟨((x, 0), (c + L x, 0)), ?_, rfl⟩
  simp [Fiber, boundary, add_comm, add_left_comm]

theorem fiber_full_right (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit)
    (c : Bit) (x : Vec e) : ∃ z ∈ Fiber L R c, z.1.2 = x := by
  refine ⟨((0, x), (c + R x, 0)), ?_, rfl⟩
  simp [Fiber, boundary, add_comm, add_left_comm]

theorem fiber_full_vertical₀ (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit)
    (c y : Bit) : ∃ z ∈ Fiber L R c, z.2.1 = y := by
  refine ⟨((0, 0), (y, c + y)), ?_, rfl⟩
  simp [Fiber, boundary, add_comm, add_left_comm]

theorem fiber_full_vertical₁ (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit)
    (c y : Bit) : ∃ z ∈ Fiber L R c, z.2.2 = y := by
  refine ⟨((0, 0), (c + y, y)), ?_, rfl⟩
  simp [Fiber, boundary]

def fiberEquiv (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit) (c : Bit) :
    Fiber L R c ≃ Vec d × Vec e × Bit where
  toFun z := (z.1.1.1, z.1.1.2, z.1.2.1)
  invFun a := ⟨((a.1, a.2.1), (a.2.2, c + L a.1 + R a.2.1 + a.2.2)), by
    simp [Fiber, boundary, add_assoc, add_left_comm, add_comm]⟩
  left_inv z := by
    apply Subtype.ext
    rcases z with ⟨⟨⟨x,y⟩,⟨v,w⟩⟩, h⟩
    change ((x, y), (v, c + L x + R y + v)) = ((x, y), (v, w))
    change L x + R y + v + w = c at h
    have hw : c + L x + R y + v = w := by
      rw [← h]
      simp [add_left_comm, add_comm]
    rw [hw]
  right_inv a := rfl

theorem fiber_card (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit) (c : Bit) :
    Nat.card (Fiber L R c) = 2 ^ (d + e + 1) := by
  rw [Nat.card_congr (fiberEquiv L R c)]
  simp [pow_add, mul_assoc]

theorem fiber_card_le_sixteen (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit)
    (c : Bit) (internal : d + e ≤ 3) : Nat.card (Fiber L R c) ≤ 16 := by
  rw [fiber_card]
  calc
    2 ^ (d + e + 1) ≤ 2 ^ 4 := Nat.pow_le_pow_right (by decide) (by omega)
    _ = 16 := by norm_num

end VariableWL.Affine

namespace VariableWL.Markers

abbrev Bit := ZMod 2
open scoped CharTwo

variable {V : Type uAffine5} {G : SimpleGraph V}

def walkSum (ω : V → V → Bit) : {u v : V} → G.Walk u v → Bit
  | _, _, .nil => 0
  | u, _, .cons (v := v) _ p => ω u v + walkSum ω p

@[simp] theorem walkSum_nil (ω : V → V → Bit) (u : V) :
    walkSum ω (SimpleGraph.Walk.nil : G.Walk u u) = 0 := rfl

@[simp] theorem walkSum_cons (ω : V → V → Bit) {u v w : V}
    (h : G.Adj u v) (p : G.Walk v w) :
    walkSum ω (.cons h p) = ω u v + walkSum ω p := rfl

@[simp] theorem walkSum_append (ω : V → V → Bit) {u v w : V}
    (p : G.Walk u v) (q : G.Walk v w) :
    walkSum ω (p.append q) = walkSum ω p + walkSum ω q := by
  induction p with
  | nil => simp [walkSum]
  | cons h p ih => simp [SimpleGraph.Walk.cons_append, walkSum, ih, add_assoc]

@[simp] theorem walkSum_reverse (ω : V → V → Bit)
    (hsym : ∀ u v, G.Adj u v → ω u v = ω v u) {u v : V} (p : G.Walk u v) :
    walkSum ω p.reverse = walkSum ω p := by
  induction p with
  | nil => simp [walkSum]
  | @cons u v w h p ih =>
      simp only [SimpleGraph.Walk.reverse_cons, walkSum_append, ih, walkSum_cons,
        walkSum_nil, add_zero]
      rw [← hsym u v h, add_comm]

theorem exists_potential (ω : V → V → Bit)
    (hsym : ∀ u v, G.Adj u v → ω u v = ω v u)
    (hconn : G.Preconnected) (root : V)
    (hzero : ∀ u (p : G.Walk u u), walkSum ω p = 0) :
    ∃ s : V → Bit, ∀ u v, G.Adj u v → s u + s v = ω u v := by
  classical
  let p : (v : V) → G.Walk root v := fun v => (hconn root v).some
  refine ⟨fun v => walkSum ω (p v), ?_⟩
  intro u v huv
  have hc := hzero root (((p u).append huv.toWalk).append (p v).reverse)
  simp only [walkSum_append, walkSum_reverse ω hsym, SimpleGraph.Adj.toWalk,
    walkSum_cons, walkSum_nil, add_zero] at hc
  calc
    walkSum ω (p u) + walkSum ω (p v) =
        (walkSum ω (p u) + ω u v + walkSum ω (p v)) + ω u v := by
      simp [add_comm, add_assoc]
    _ = ω u v := by rw [hc, zero_add]

theorem walkSum_of_potential (ω : V → V → Bit) (s : V → Bit)
    (hs : ∀ u v, G.Adj u v → s u + s v = ω u v) {u v : V} (p : G.Walk u v) :
    walkSum ω p = s u + s v := by
  induction p with
  | nil => simp [walkSum]
  | @cons u v w h p ih =>
    rw [walkSum_cons, ih, ← hs u v h]
    simp [add_assoc]

end VariableWL.Markers

namespace VariableWL.Affine
open scoped CharTwo

theorem gauge_horizontal {d : ℕ} (x y h h' : Vec d) (s t δ : Bit)
    (hmark : s + t = δ) :
    (x + s • (h' + h)) + (y + t • (h' + h)) + δ • h' = x + y + δ • h := by
  ext i
  change x i + s * (h' i + h i) + (y i + t * (h' i + h i)) + δ * h' i =
    x i + y i + δ * h i
  rw [← hmark]
  have htwo : (2 : Bit) = 0 := by decide
  linear_combination (h' i * (s + t)) * htwo

theorem gauge_vertical {d e : ℕ} (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit)
    (x : Vec d) (y : Vec e) (h h' : Vec d) (j j' : Vec e) (s t : Bit)
    (hs : s = t) (hdiff : L (h' + h) = R (j' + j)) :
    L (x + s • (h' + h)) + R (y + t • (j' + j)) = L x + R y := by
  subst t
  simp only [map_add, map_smul, smul_eq_mul]
  have hd : L h' + L h = R j' + R j := by simpa using hdiff
  rw [hd]
  simp [add_comm, add_left_comm]

theorem shift_difference {d e : ℕ} (L : Vec d →ₗ[Bit] Bit) (R : Vec e →ₗ[Bit] Bit)
    (h h' : Vec d) (j j' : Vec e) (b : Bit)
    (hh : L h + R j = b) (hh' : L h' + R j' = b) :
    L (h' + h) = R (j' + j) := by
  simp only [map_add]
  have htwo : (2 : Bit) = 0 := by decide
  linear_combination hh' + hh - (R j' + R j - b) * htwo

end VariableWL.Affine


end ProjectionAudit


/- Adapted from Subdivision.lean. -/

namespace ProjectionAudit

universe uSubdivision1 uSubdivision2 uSubdivision3 uSubdivision4 uSubdivision5 uSubdivision6 uSubdivision7 uSubdivision8 uSubdivision9

namespace VariableWL.Subdivision

variable {P : Type uSubdivision1} {E : Type uSubdivision2} {n : ℕ}

abbrev Vertex (P : Type uSubdivision3) (E : Type uSubdivision4) (n : ℕ) := P ⊕ (E × Fin n)
abbrev Link (E : Type uSubdivision5) (n : ℕ) := E × Fin (n+1)

def left (src : E → P) (l : Link E n) : Vertex P E n :=
  if h : l.2.val = 0 then .inl (src l.1)
  else .inr (l.1, ⟨l.2.val - 1, by omega⟩)

def right (dst : E → P) (l : Link E n) : Vertex P E n :=
  if h : l.2.val = n then .inl (dst l.1)
  else .inr (l.1, ⟨l.2.val, by omega⟩)

theorem endpoints_ne (hn : 0 < n) (src dst : E → P) (l : Link E n) :
    left src l ≠ right dst l := by
  unfold left right
  split_ifs with h₀ h₁ h₁
  · omega
  · simp
  · simp
  · intro h
    have hh := congrArg (fun x : Vertex P E n =>
      match x with | .inl _ => 0 | .inr x => x.2.val) h
    simp only at hh
    omega

theorem exists_unused_cut [DecidableEq E] (S : Finset (Link E n))
    (hS : S.card < n+1) : ∃ cut : E → Fin (n+1), ∀ e, (e, cut e) ∉ S := by
  classical
  have hx (e : E) : ∃ i : Fin (n+1), (e,i) ∉ S := by
    by_contra h
    have hall : ∀ i : Fin (n+1), (e,i) ∈ S := by simpa using h
    have hsub : Finset.univ.image (fun i : Fin (n+1) => (e,i)) ⊆ S := by
      intro x hx
      obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hx
      exact hall i
    have hc := Finset.card_le_card hsub
    rw [Finset.card_image_of_injective _ (fun _ _ h => Prod.mk.inj h |>.2),
      Finset.card_univ, Fintype.card_fin] at hc
    omega
  exact ⟨fun e => (hx e).choose, fun e => (hx e).choose_spec⟩

def owner (src dst : E → P) (cut : E → Fin (n+1)) : Vertex P E n → P
  | .inl p => p
  | .inr (e,j) => if j.val < (cut e).val then src e else dst e

@[simp] theorem owner_real (src dst : E → P) (cut : E → Fin (n+1)) (p : P) :
    owner src dst cut (.inl p) = p := rfl

theorem owner_link (src dst : E → P) (cut : E → Fin (n+1))
    (l : Link E n) (hcut : l.2 ≠ cut l.1) :
    owner src dst cut (left src l) = owner src dst cut (right dst l) := by
  have hv : l.2.val ≠ (cut l.1).val := fun h => hcut (Fin.ext h)
  unfold left right
  split_ifs with h₀ h₁ h₁
  · omega
  · simp only [owner]
    rw [if_pos (by omega)]
  · simp only [owner]
    rw [if_neg (by omega)]
  · simp only [owner]
    have hi : l.2.val - 1 < (cut l.1).val ↔ l.2.val < (cut l.1).val := by omega
    simp only [hi]

def depth (cut : E → Fin (n+1)) : Vertex P E n → ℕ
  | .inl _ => 0
  | .inr (e,j) => if j.val < (cut e).val then j.val+1 else n-j.val

theorem depth_link (src dst : E → P) (cut : E → Fin (n+1))
    (l : Link E n) (hcut : l.2 ≠ cut l.1) :
    if l.2.val < (cut l.1).val then
      depth cut (right dst l) = depth cut (left src l) + 1
    else depth cut (left src l) = depth cut (right dst l) + 1 := by
  have hv : l.2.val ≠ (cut l.1).val := fun h => hcut (Fin.ext h)
  have hb := l.2.isLt
  have hbc := (cut l.1).isLt
  unfold left right
  split_ifs <;> simp only [depth]
  all_goals (try split_ifs) <;> omega

def supportGraph (hn : 0 < n) (src dst : E → P) (S : Set (Link E n)) :
    SimpleGraph (Vertex P E n) where
  Adj v w := ∃ l ∈ S,
    (v = left src l ∧ w = right dst l) ∨ (v = right dst l ∧ w = left src l)
  symm := ⟨by
    rintro v w ⟨l, hl, h⟩
    exact ⟨l, hl, h.elim (fun h => Or.inr h.symm) (fun h => Or.inl h.symm)⟩⟩
  loopless := ⟨by
    rintro v ⟨l, _, h⟩
    exact endpoints_ne hn src dst l (h.elim (fun h => h.1.symm.trans h.2)
      (fun h => h.2.symm.trans h.1))⟩

theorem owner_adj (hn : 0 < n) (src dst : E → P) (S : Set (Link E n))
    (cut : E → Fin (n+1)) (hc : ∀ l ∈ S, l.2 ≠ cut l.1)
    {v w : Vertex P E n} (h : (supportGraph hn src dst S).Adj v w) :
    owner src dst cut v = owner src dst cut w := by
  obtain ⟨l, hl, h⟩ := h
  rcases h with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
  · exact owner_link src dst cut l (hc l hl)
  · exact (owner_link src dst cut l (hc l hl)).symm

theorem owner_walk (hn : 0 < n) (src dst : E → P) (S : Set (Link E n))
    (cut : E → Fin (n+1)) (hc : ∀ l ∈ S, l.2 ≠ cut l.1)
    {v w : Vertex P E n} (p : (supportGraph hn src dst S).Walk v w) :
    owner src dst cut v = owner src dst cut w := by
  induction p with
  | nil => rfl
  | cons h p ih => exact (owner_adj hn src dst S cut hc h).trans ih

theorem at_most_one_real [DecidableEq E] (hn : 0 < n) (src dst : E → P)
    (S : Finset (Link E n)) (hS : S.card < n+1) {p q : P}
    (h : (supportGraph hn src dst S).Reachable (.inl p) (.inl q)) : p = q := by
  obtain ⟨cut, hc⟩ := exists_unused_cut S hS
  apply owner_walk hn src dst S cut (fun l hl h => ?_) h.some
  change l ∈ S at hl
  exact hc l.1 (by simpa only [← h, Prod.eta] using hl)

end VariableWL.Subdivision

namespace VariableWL.Subdivision
variable {P : Type uSubdivision6} {E : Type uSubdivision7} {n : ℕ}

def parent (src dst : E → P) (cut : E → Fin (n+1)) : Vertex P E n → Vertex P E n
  | .inl p => .inl p
  | .inr (e,j) =>
    if j.val < (cut e).val then
      if h : j.val = 0 then .inl (src e)
      else .inr (e, ⟨j.val-1, by omega⟩)
    else
      if h : j.val+1 = n then .inl (dst e)
      else .inr (e, ⟨j.val+1, by omega⟩)

theorem parent_link (src dst : E → P) (cut : E → Fin (n+1))
    (l : Link E n) (hcut : l.2 ≠ cut l.1) :
    if l.2.val < (cut l.1).val then
      parent src dst cut (right dst l) = left src l
    else parent src dst cut (left src l) = right dst l := by
  have hv : l.2.val ≠ (cut l.1).val := fun h => hcut (Fin.ext h)
  have hb := l.2.isLt
  have hbc := (cut l.1).isLt
  unfold left right
  split_ifs <;> simp only [parent]
  all_goals try split_ifs
  all_goals first | omega | rfl | (congr 2; apply Fin.ext; simp only; omega)

theorem acyclic_of_unique_lower {V : Type uSubdivision8} (G : SimpleGraph V) (rank : V → ℕ)
    (hne : ∀ u v, G.Adj u v → rank u ≠ rank v)
    (hunique : ∀ u v w, G.Adj u v → G.Adj u w →
      rank v < rank u → rank w < rank u → v = w) : G.IsAcyclic := by
  classical
  intro v p hp
  obtain ⟨u, hu, hmax⟩ := (p.support.toFinset).exists_max_image rank
    ⟨v, List.mem_toFinset.mpr p.start_mem_support⟩
  have hup : u ∈ p.support := List.mem_toFinset.mp hu
  let q := p.rotate u hup
  have hq : q.IsCycle := hp.rotate hup
  have hs : G.Adj u q.snd := by
    simpa only [SimpleGraph.Walk.getVert_zero, SimpleGraph.Walk.snd] using
      q.adj_getVert_succ (i := 0) (by have := hq.three_le_length; omega)
  have ht : G.Adj u q.penultimate := by
    have := q.adj_getVert_succ (i := q.length-1) (by have := hq.three_le_length; omega)
    rw [Nat.sub_add_cancel (by have := hq.three_le_length; omega),
      SimpleGraph.Walk.getVert_length] at this
    exact this.symm
  have hm (x : V) (hx : x ∈ q.support) : rank x ≤ rank u := by
    apply hmax x
    exact List.mem_toFinset.mpr ((p.mem_support_rotate_iff u hup).mp hx)
  have hms := hm q.snd (q.getVert_mem_support 1)
  have hmt := hm q.penultimate (q.getVert_mem_support (q.length-1))
  exact hq.snd_ne_penultimate (hunique u q.snd q.penultimate hs ht
    (lt_of_le_of_ne hms (hne _ _ hs).symm) (lt_of_le_of_ne hmt (hne _ _ ht).symm))

theorem chosen_support_acyclic (hn : 0 < n) (src dst : E → P)
    (S : Set (Link E n)) (cut : E → Fin (n+1))
    (hc : ∀ l ∈ S, l.2 ≠ cut l.1) : (supportGraph hn src dst S).IsAcyclic := by
  have hedge {u v} (h : (supportGraph hn src dst S).Adj u v) :
      (depth cut u + 1 = depth cut v ∧ parent src dst cut v = u) ∨
      (depth cut v + 1 = depth cut u ∧ parent src dst cut u = v) := by
    obtain ⟨l, hl, h⟩ := h
    have hd := depth_link src dst cut l (hc l hl)
    have hp := parent_link src dst cut l (hc l hl)
    split_ifs at hd hp with hi
    · rcases h with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
      · exact Or.inl ⟨hd.symm, hp⟩
      · exact Or.inr ⟨hd.symm, hp⟩
    · rcases h with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
      · exact Or.inr ⟨hd.symm, hp⟩
      · exact Or.inl ⟨hd.symm, hp⟩
  apply acyclic_of_unique_lower _ (depth cut)
  · intro u v h
    rcases hedge h with ⟨h, _⟩ | ⟨h, _⟩ <;> omega
  · intro u v w hv hw hdv hdw
    rcases hedge hv with ⟨h, _⟩ | ⟨_, h⟩
    · omega
    rcases hedge hw with ⟨h', _⟩ | ⟨_, h'⟩
    · omega
    exact h.symm.trans h'

theorem small_support_acyclic [DecidableEq E] (hn : 0 < n) (src dst : E → P)
    (S : Finset (Link E n)) (hS : S.card < n+1) :
    (supportGraph hn src dst S).IsAcyclic := by
  obtain ⟨cut, hc⟩ := exists_unused_cut S hS
  exact chosen_support_acyclic hn src dst S cut (fun l hl h => hc l.1
    (by change l ∈ S at hl; simpa only [← h, Prod.eta] using hl))

theorem internal_adj_wire (hn : 0 < n) (src dst : E → P) (S : Set (Link E n))
    {e f : E} {i j : Fin n}
    (h : (supportGraph hn src dst S).Adj (.inr (e,i)) (.inr (f,j))) : e = f := by
  obtain ⟨l, _, h⟩ := h
  rcases h with ⟨h₁, h₂⟩ | ⟨h₁, h₂⟩
  all_goals
    simp only [left, right] at h₁ h₂
    split_ifs at h₁ h₂
    all_goals simp_all

end VariableWL.Subdivision

namespace VariableWL.Markers
open scoped CharTwo
variable {V : Type uSubdivision9} {G : SimpleGraph V}

theorem walkSum_congr {ω ω' : V → V → Bit}
    (h : ∀ u v, G.Adj u v → ω u v = ω' u v) {u v : V} (p : G.Walk u v) :
    walkSum ω p = walkSum ω' p := by
  induction p with
  | nil => rfl
  | cons h' p ih => rw [walkSum_cons, walkSum_cons, h _ _ h', ih]

@[simp] theorem walkSum_zero {u v : V} (p : G.Walk u v) :
    walkSum (fun _ _ => 0) p = 0 := by
  induction p with
  | nil => rfl
  | cons _ _ ih => simp [walkSum, ih]

theorem walkSum_add (ω ω' : V → V → Bit) {u v : V} (p : G.Walk u v) :
    walkSum (fun x y => ω x y + ω' x y) p = walkSum ω p + walkSum ω' p := by
  induction p with
  | nil => simp [walkSum]
  | cons _ _ ih => simp only [walkSum_cons, ih]; ring

theorem walkSum_mul (ω : V → V → Bit) (c : Bit) {u v : V} (p : G.Walk u v) :
    walkSum (fun x y => ω x y * c) p = walkSum ω p * c := by
  induction p with
  | nil => simp [walkSum]
  | cons _ _ ih => simp only [walkSum_cons, ih]; ring

end VariableWL.Markers

end ProjectionAudit


/- Adapted from Wrapping.lean. -/

namespace ProjectionAudit

universe uWrapping1 uWrapping2 uWrapping3 uWrapping4 uWrapping5 uWrapping6 uWrapping7 uWrapping8 uWrapping9 uWrapping10 uWrapping11

namespace VariableWL.Wrapping
open scoped CharTwo
open Markers
abbrev Bit := ZMod 2

variable {I : Type uWrapping1} {V : Type uWrapping2} [DecidableEq I] {G : SimpleGraph V}

structure RowDiagram (G : SimpleGraph V) (next : Equiv.Perm I) where
  boundary : V → I
  horizontal : V → V → Option I
  symmetric : ∀ u v, G.Adj u v → horizontal u v = horizontal v u
  shape : ∀ u v, G.Adj u v →
    match horizontal u v with
    | none => boundary u = boundary v
    | some i => (boundary u = i ∧ boundary v = next i) ∨
        (boundary v = i ∧ boundary u = next i)

namespace RowDiagram

variable {next : Equiv.Perm I} (D : RowDiagram G next)

def rowWeight (i : I) (u v : V) : Bit := if D.horizontal u v = some i then 1 else 0

def Wraps (marked : I) : Prop :=
  ∃ v : V, ∃ p : G.Walk v v, walkSum (D.rowWeight marked) p = 1

theorem boundary_incidence (i : I) {u v : V} (h : G.Adj u v) :
    (if D.boundary u = i then (1 : Bit) else 0) +
      (if D.boundary v = i then 1 else 0) =
    D.rowWeight i u v + D.rowWeight (next.symm i) u v := by
  have hs := D.shape u v h
  cases hh : D.horizontal u v with
  | none =>
    simp only [hh] at hs
    simp [rowWeight, hh, hs]
  | some j =>
    simp only [hh] at hs
    rcases hs with ⟨hu, hv⟩ | ⟨hv, hu⟩
    · simp [rowWeight, hh, hu, hv, ← next.eq_symm_apply]
    · simp [rowWeight, hh, hu, hv, ← next.eq_symm_apply, add_comm]

theorem row_parity_next {v : V} (p : G.Walk v v) (i : I) :
    walkSum (D.rowWeight (next i)) p = walkSum (D.rowWeight i) p := by
  classical
  let s (v : V) : Bit := if D.boundary v = next i then 1 else 0
  have ht := walkSum_of_potential
    (fun u v => D.rowWeight (next i) u v + D.rowWeight i u v) s
    (fun u v h => by simpa [s] using D.boundary_incidence (next i) h) p
  rw [walkSum_add] at ht
  have hh := congrArg (fun x => x + walkSum (D.rowWeight i) p) ht
  simpa [add_assoc] using hh

theorem row_parity_all
    (horbit : ∀ i j : I, ∃ m : ℕ, next^[m] i = j)
    {v : V} (p : G.Walk v v) (i j : I) :
    walkSum (D.rowWeight i) p = walkSum (D.rowWeight j) p := by
  obtain ⟨m, rfl⟩ := horbit i j
  induction m with
  | zero => rfl
  | succ m ih =>
    rw [Function.iterate_succ_apply', D.row_parity_next]
    exact ih

theorem finRotate_orbit {r : ℕ} [NeZero r] (i j : Fin r) :
    ∃ m : ℕ, (finRotate r)^[m] i = j := by
  refine ⟨(j-i).val, ?_⟩
  rw [← finCycle_eq_finRotate_iterate]
  simp

theorem covers_rows {B : Type uWrapping3} [DecidableEq B] (U : Finset B) (row : B → I)
    (hcover : ∀ u v, G.Adj u v → ∀ i, D.horizontal u v = some i → i ∈ U.image row)
    (horbit : ∀ i j : I, ∃ m : ℕ, next^[m] i = j)
    {marked : I} (hw : D.Wraps marked) : ∀ i, i ∈ U.image row := by
  classical
  obtain ⟨v, p, hp⟩ := hw
  intro i
  by_contra hi
  have hz : walkSum (D.rowWeight i) p = 0 := by
    rw [walkSum_congr (ω' := fun _ _ => 0) (fun u v h => ?_), walkSum_zero]
    simp only [rowWeight, ite_eq_right_iff, one_ne_zero, imp_false]
    exact fun hh => hi (hcover u v h i hh)
  have he := D.row_parity_all horbit p i marked
  rw [hz, hp] at he
  exact zero_ne_one he

theorem blocks_card_ge [Fintype I] {B : Type uWrapping4} [DecidableEq B]
    (U : Finset B) (row : B → I)
    (hcover : ∀ u v, G.Adj u v → ∀ i, D.horizontal u v = some i → i ∈ U.image row)
    (horbit : ∀ i j : I, ∃ m : ℕ, next^[m] i = j)
    {marked : I} (hw : D.Wraps marked) : Fintype.card I ≤ U.card := by
  have he : U.image row = Finset.univ := Finset.eq_univ_of_forall
    (D.covers_rows U row hcover horbit hw)
  calc
    Fintype.card I = (U.image row).card := by rw [he, Finset.card_univ]
    _ ≤ U.card := Finset.card_image_le

theorem row_injective [Fintype I] {B : Type uWrapping5} [DecidableEq B]
    (U : Finset B) (row : B → I)
    (hcover : ∀ u v, G.Adj u v → ∀ i, D.horizontal u v = some i → i ∈ U.image row)
    (horbit : ∀ i j : I, ∃ m : ℕ, next^[m] i = j)
    {marked : I} (hw : D.Wraps marked) (hc : U.card = Fintype.card I) :
    Set.InjOn row (↑U : Set B) := by
  apply Finset.card_image_iff.mp
  have he : U.image row = Finset.univ := Finset.eq_univ_of_forall
    (D.covers_rows U row hcover horbit hw)
  rw [he, Finset.card_univ, hc]

end RowDiagram

end VariableWL.Wrapping

namespace VariableWL.Wrapping.RowDiagram
open scoped CharTwo
open Markers
variable {I : Type uWrapping6} {V : Type uWrapping7} {L : Type uWrapping8} [DecidableEq I] [DecidableEq L]
    {G : SimpleGraph V} {next : Equiv.Perm I} (D : RowDiagram G next)

def Labeled (label : V → L) (first last : I → L) : Prop :=
  ∀ u v, G.Adj u v →
    match D.horizontal u v with
    | none => (D.boundary u, label u) = (D.boundary v, label v)
    | some i =>
      ((D.boundary u, label u) = (i, first i) ∧
        (D.boundary v, label v) = (next i, last i)) ∨
      ((D.boundary v, label v) = (i, first i) ∧
        (D.boundary u, label u) = (next i, last i))

theorem label_incidence (label : V → L) (first last : I → L)
    (hl : D.Labeled label first last) (i : I) (x : L) {u v : V} (h : G.Adj u v) :
    (if (D.boundary u, label u) = (i,x) then (1 : Bit) else 0) +
      (if (D.boundary v, label v) = (i,x) then 1 else 0) =
    D.rowWeight i u v * (if first i = x then 1 else 0) +
      D.rowWeight (next.symm i) u v * (if last (next.symm i) = x then 1 else 0) := by
  have hs := hl u v h
  cases hh : D.horizontal u v with
  | none =>
    simp only [hh] at hs
    rw [hs]
    simp [rowWeight, hh]
  | some j =>
    simp only [hh] at hs
    rcases hs with ⟨hu, hv⟩ | ⟨hv, hu⟩
    all_goals
      rw [hu, hv]
      by_cases hji : j = i <;> by_cases hjp : j = next.symm i <;>
        simp_all [rowWeight, ← next.eq_symm_apply, add_comm]

theorem label_coherence (label : V → L) (first last : I → L)
    (hl : D.Labeled label first last)
    (horbit : ∀ i j : I, ∃ m : ℕ, next^[m] i = j)
    {marked : I} (hw : D.Wraps marked) : ∀ i, last i = first (next i) := by
  obtain ⟨v, p, hp⟩ := hw
  have hpar (i : I) : walkSum (D.rowWeight i) p = 1 :=
    (D.row_parity_all horbit p i marked).trans hp
  have hc (i : I) : last (next.symm i) = first i := by
    let s (v : V) : Bit := if (D.boundary v, label v) = (i,first i) then 1 else 0
    have ht := walkSum_of_potential
      (fun u v => D.rowWeight i u v * (if first i = first i then 1 else 0) +
        D.rowWeight (next.symm i) u v * (if last (next.symm i) = first i then 1 else 0)) s
      (fun u v h => D.label_incidence label first last hl i (first i) h) p
    rw [walkSum_add, walkSum_mul, walkSum_mul, hpar, hpar] at ht
    by_contra he
    simp [he] at ht
  intro i
  simpa using hc (next i)

end VariableWL.Wrapping.RowDiagram

namespace VariableWL.Wrapping
variable {I : Type uWrapping9} {B : Type uWrapping10} {L : Type uWrapping11} [Fintype I] [DecidableEq I] [DecidableEq B]

theorem overlap_compl_card_le_one (U A B' : Finset B) (row : B → I)
    (hA : A ⊆ U) (hB : B' ⊆ U) (hU : U.card ≤ Fintype.card I + 1)
    (hcA : A.card = Fintype.card I) (hcB : B'.card = Fintype.card I)
    (hi : Set.InjOn row (↑A : Set B)) :
    ((A ∩ B').image row)ᶜ.card ≤ 1 := by
  have hsub : A ∪ B' ⊆ U := Finset.union_subset hA hB
  have hle := Finset.card_le_card hsub
  have hcard := Finset.card_union_add_card_inter A B'
  have hinj : Set.InjOn row (↑(A ∩ B') : Set B) := hi.mono (by
    intro x hx; exact (Finset.mem_inter.mp hx).1)
  rw [Finset.card_compl, Finset.card_image_iff.mpr hinj]
  omega

theorem adjacent_cover (next : Equiv.Perm I) (hnofix : ∀ i, next i ≠ i)
    (S : Finset I) (hS : Sᶜ.card ≤ 1) (i : I) : i ∈ S ∨ next.symm i ∈ S := by
  by_contra h
  push Not at h
  have hi : next.symm i ≠ i := by
    intro he
    have hh := congrArg next he
    exact hnofix i (by simpa using hh.symm)
  have hsub : {i, next.symm i} ⊆ Sᶜ := by
    intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl
    · exact Finset.mem_compl.mpr h.1
    · exact Finset.mem_compl.mpr h.2
  have hc := Finset.card_le_card hsub
  rw [Finset.card_pair hi.symm] at hc
  omega

theorem overlap_address_unique (next : Equiv.Perm I) (hnofix : ∀ i, next i ≠ i)
    (U A B' : Finset B) (row : B → I)
    (hA : A ⊆ U) (hB : B' ⊆ U) (hU : U.card ≤ Fintype.card I + 1)
    (hcA : A.card = Fintype.card I) (hcB : B'.card = Fintype.card I)
    (hi : Set.InjOn row (↑A : Set B)) (a a' : I → L)
    (hlabel : ∀ b ∈ A ∩ B', a (row b) = a' (row b) ∧
      a (next (row b)) = a' (next (row b))) : a = a' := by
  funext i
  have hc := overlap_compl_card_le_one U A B' row hA hB hU hcA hcB hi
  rcases adjacent_cover next hnofix _ hc i with h | h
  · obtain ⟨b, hb, rfl⟩ := Finset.mem_image.mp h
    exact (hlabel b hb).1
  · obtain ⟨b, hb, hbi⟩ := Finset.mem_image.mp h
    have hh := (hlabel b hb).2
    simpa only [hbi, Equiv.apply_symm_apply] using hh

theorem finRotate_no_fixed {r : ℕ} (hr : 2 ≤ r) (i : Fin r) : finRotate r i ≠ i := by
  have h : i ∈ (finRotate r).support := by
    rw [support_finRotate_of_le hr]
    exact Finset.mem_univ i
  exact Equiv.Perm.mem_support.mp h

end VariableWL.Wrapping

end ProjectionAudit


/- Adapted from ProductImages.lean. -/

namespace ProjectionAudit

universe uProductImages1 uProductImages2 uProductImages3 uProductImages4 uProductImages5 uProductImages6

namespace VariableWL.ProductImages
open scoped CharTwo
open VariableWL.Affine

variable (m r : ℕ) (P : Type uProductImages1) (E : Type uProductImages2)

structure Instance where
  dimension : P → ℕ
  source : E → P
  target : E → P
  domain : E → Fin r → Finset (Fin m)
  map : E → Fin r → (Fin m) → (Fin m)
  map_injective : ∀ e i, Set.InjOn (map e i) (domain e i)
  linearLeft : ∀ e, Vec (dimension (source e)) →ₗ[Bit] Bit
  linearRight : ∀ e, Vec (dimension (target e)) →ₗ[Bit] Bit
  constantLeft : E → Bit
  constantRight : E → Bit

namespace Instance
variable {m r : ℕ} {P : Type uProductImages3} {E : Type uProductImages4} (J : Instance m r P E)

abbrev Address (m r : ℕ) := Fin r → (Fin m)

def Allowed (e : E) (a : Address m r) : Prop := ∀ i, a i ∈ J.domain e i

def mapAddress (e : E) (a : Address m r) : Address m r := fun i => J.map e i (a i)

def leftForm (e : E) (v : Vec (J.dimension (J.source e))) : Bit :=
  J.linearLeft e v + J.constantLeft e

def rightForm (e : E) (v : Vec (J.dimension (J.target e))) : Bit :=
  J.linearRight e v + J.constantRight e

structure Witness where
  values : ∀ p : P, Address m r → Set (Vec (J.dimension p))
  nonempty : ∀ p a, (values p a).Nonempty
  images : ∀ e a, J.Allowed e a →
    J.leftForm e '' values (J.source e) a =
      J.rightForm e '' values (J.target e) (J.mapAddress e a)

def Consistent : Prop := Nonempty J.Witness

namespace Witness
variable {J} (Q : J.Witness)

def wireValues (e : E) (a : Address m r) : Set Bit :=
  J.leftForm e '' Q.values (J.source e) a

theorem wireValues_nonempty (e : E) (a : Address m r) :
    (Q.wireValues e a).Nonempty := (Q.nonempty _ _).image _

theorem right_image (e : E) (a : Address m r) (ha : J.Allowed e a) :
    J.rightForm e '' Q.values (J.target e) (J.mapAddress e a) =
      Q.wireValues e a := (Q.images e a ha).symm

theorem lift_left (e : E) (a : Address m r) {b : Bit} (hb : b ∈ Q.wireValues e a) :
    ∃ v ∈ Q.values (J.source e) a, J.leftForm e v = b := hb

theorem lift_right (e : E) (a : Address m r) (ha : J.Allowed e a)
    {b : Bit} (hb : b ∈ Q.wireValues e a) :
    ∃ v ∈ Q.values (J.target e) (J.mapAddress e a), J.rightForm e v = b := by
  rw [← Q.right_image e a ha] at hb
  exact hb

end Witness

theorem exists_ambient (e : E) (i : Fin r) :
    ∃ f : Equiv.Perm (Fin m), ∀ a ∈ J.domain e i, f a = J.map e i a := by
  obtain ⟨f,hf⟩ := Equiv.Perm.exists_extending_pair
    (fun a : {a // a ∈ J.domain e i} => a.val)
    (fun a : {a // a ∈ J.domain e i} => J.map e i a.val)
    Subtype.val_injective (fun a b h => Subtype.ext (J.map_injective e i a.property b.property h))
  exact ⟨f, fun a ha => hf ⟨a,ha⟩⟩

noncomputable def ambient (e : E) (i : Fin r) : Equiv.Perm (Fin m) :=
  (J.exists_ambient e i).choose

theorem ambient_on_domain (e : E) (i : Fin r) (a : (Fin m)) (ha : a ∈ J.domain e i) :
    J.ambient e i a = J.map e i a := (J.exists_ambient e i).choose_spec a ha

open Subdivision
variable {n : ℕ}

def labels : Vertex P E n → Fin r → Finset (Fin m)
  | .inl _, _ => Finset.univ
  | .inr (e,_), i => J.domain e i

def Matches (l : Link E n) (i : Fin r) (a b : (Fin m)) : Prop :=
  a ∈ J.domain l.1 i ∧ b = if l.2.val = n then J.map l.1 i a else a

theorem matches_left (l : Link E n) (i : Fin r) {a b : (Fin m)} (h : J.Matches l i a b) :
    a ∈ J.labels (left J.source l) i := by
  unfold left
  split_ifs <;> simp only [labels]
  · exact Finset.mem_univ _
  · exact h.1

theorem matches_right (l : Link E n) (i : Fin r) {a b : (Fin m)} (h : J.Matches l i a b) :
    b ∈ J.labels (right J.target l) i := by
  unfold right
  split_ifs with hn
  · exact Finset.mem_univ _
  · simp only [labels]
    rw [h.2, if_neg hn]
    exact h.1

noncomputable def alignment (cut : E → Fin (n+1)) :
    Vertex P E n → Fin r → Equiv.Perm (Fin m)
  | .inl _, _ => Equiv.refl _
  | .inr (e,j), i => if j.val < (cut e).val then Equiv.refl _ else J.ambient e i

theorem alignment_match (hn : 0 < n) (cut : E → Fin (n+1))
    (l : Link E n) (hc : l.2 ≠ cut l.1) (i : Fin r)
    {a b : (Fin m)} (h : J.Matches l i a b) :
    J.alignment cut (left J.source l) i a =
      J.alignment cut (right J.target l) i b := by
  have hv : l.2.val ≠ (cut l.1).val := fun hh => hc (Fin.ext hh)
  have hl := l.2.isLt
  have hk := (cut l.1).isLt
  unfold left right
  split_ifs with h₀ h₁ h₁
  · omega
  · simp only [alignment]
    rw [if_pos (by omega)]
    simp only [Equiv.refl_apply]
    exact (h.2.trans (if_neg h₁)).symm
  · simp only [alignment]
    rw [if_neg (by omega), Equiv.refl_apply]
    rw [J.ambient_on_domain _ _ _ h.1, h.2, if_pos h₁]
  · simp only [alignment]
    have hi : l.2.val - 1 < (cut l.1).val ↔ l.2.val < (cut l.1).val := by omega
    rw [h.2, if_neg h₁]
    simp only [hi]

end Instance
end VariableWL.ProductImages

namespace VariableWL.ProductImages.Instance
open VariableWL.Affine Subdivision
variable {m r n : ℕ} {P : Type uProductImages5} {E : Type uProductImages6} (J : ProductImages.Instance m r P E)

abbrev Shifts (n : ℕ) := (∀ p, Vec (J.dimension p)) × (E × Fin n → Bit)

def shiftLeft (h : J.Shifts n) (l : Link E n) : Bit :=
  if h₀ : l.2.val = 0 then J.leftForm l.1 (h.1 (J.source l.1))
  else h.2 (l.1, ⟨l.2.val-1, by omega⟩)

def shiftRight (h : J.Shifts n) (l : Link E n) : Bit :=
  if h₁ : l.2.val = n then J.rightForm l.1 (h.1 (J.target l.1))
  else h.2 (l.1, ⟨l.2.val, by omega⟩)

def ShiftSystem (S : Set (Link E n)) (h : J.Shifts n) : Prop :=
  ∀ l ∈ S, J.shiftLeft h l = J.shiftRight h l

def cutShifts (cut : E → Fin (n+1)) (v : ∀ p, Vec (J.dimension p)) : J.Shifts n :=
  (v, fun (e,j) => if j.val < (cut e).val then J.leftForm e (v (J.source e))
    else J.rightForm e (v (J.target e)))

theorem cutShifts_equation (hn : 0 < n) (cut : E → Fin (n+1))
    (v : ∀ p, Vec (J.dimension p)) (l : Link E n) (hc : l.2 ≠ cut l.1) :
    J.shiftLeft (J.cutShifts cut v) l = J.shiftRight (J.cutShifts cut v) l := by
  have hv : l.2.val ≠ (cut l.1).val := fun h => hc (Fin.ext h)
  have hl := l.2.isLt
  have hk := (cut l.1).isLt
  unfold shiftLeft shiftRight
  split_ifs with h₀ h₁ h₁
  · omega
  · simp only [cutShifts]
    rw [if_pos (by omega)]
  · simp only [cutShifts]
    rw [if_neg (by omega)]
  · simp only [cutShifts]
    have hi : l.2.val - 1 < (cut l.1).val ↔ l.2.val < (cut l.1).val := by omega
    simp only [hi]

theorem small_shift_exists [DecidableEq E] (hn : 0 < n)
    (S : Finset (Link E n)) (hS : S.card < n+1) (v : ∀ p, Vec (J.dimension p)) :
    ∃ h : J.Shifts n, h.1 = v ∧ J.ShiftSystem S h := by
  obtain ⟨cut,hc⟩ := exists_unused_cut S hS
  refine ⟨J.cutShifts cut v, rfl, fun l hl => J.cutShifts_equation hn cut v l ?_⟩
  intro h
  exact hc l.1 (by change l ∈ S at hl; simpa only [← h, Prod.eta] using hl)

theorem internal_equation (h : J.Shifts n) (l : Link E n)
    (heq : J.shiftLeft h l = J.shiftRight h l)
    {e f : E} {i j : Fin n}
    (hl : left J.source l = .inr (e,i)) (hr : right J.target l = .inr (f,j)) :
    h.2 (e,i) = h.2 (f,j) := by
  unfold left at hl
  split at hl
  · cases hl
  · rename_i h₀
    unfold right at hr
    split at hr
    · cases hr
    · rename_i h₁
      have hl' := Sum.inr.inj hl
      have hr' := Sum.inr.inj hr
      simp only [shiftLeft, shiftRight, dif_neg h₀, dif_neg h₁] at heq
      simpa only [hl', hr'] using heq

end VariableWL.ProductImages.Instance

end ProjectionAudit


/- Adapted from Blocks.lean. -/

namespace ProjectionAudit

universe uBlocks1 uBlocks2 uBlocks3 uBlocks4 uBlocks5 uBlocks6 uBlocks7 uBlocks8 uBlocks9 uBlocks10 uBlocks11 uBlocks12 uBlocks13 uBlocks14 uBlocks15 uBlocks16 uBlocks17 uBlocks18

namespace VariableWL.Blocks
open Subdivision
variable {m r n : ℕ} {P : Type uBlocks1} {E : Type uBlocks2}

structure Horizontal (m r n : ℕ) (P : Type uBlocks3) (E : Type uBlocks4) where
  row : Fin r
  type : Vertex P E n
  first : (Fin m)
  last : (Fin m)
  deriving DecidableEq

structure Vertical (m r n : ℕ) (E : Type uBlocks5) where
  row : Fin r
  link : Link E n
  label : (Fin m)
  deriving DecidableEq

structure Square (m r n : ℕ) (E : Type uBlocks6) where
  row : Fin r
  link : Link E n
  first : (Fin m)
  last : (Fin m)
  deriving DecidableEq

abbrev Corner (m r n : ℕ) (P : Type uBlocks7) (E : Type uBlocks8) := Fin r × Vertex P E n × (Fin m)
abbrev Readout (m r n : ℕ) (P : Type uBlocks9) (E : Type uBlocks10) := Horizontal m r n P E ⊕ Vertical m r n E
abbrev RawBlock (m r n : ℕ) (P : Type uBlocks11) (E : Type uBlocks12) := Horizontal m r n P E ⊕ Square m r n E

variable (J : ProductImages.Instance m r P E)

def matchOutput (l : Link E n) (i : Fin r) (a : (Fin m)) : (Fin m) :=
  if l.2.val = n then J.map l.1 i a else a

def ValidHorizontal (h : Horizontal m r n P E) : Prop :=
  h.first ∈ J.labels h.type h.row ∧ h.last ∈ J.labels h.type (finRotate r h.row)

def ValidSquare (s : Square m r n E) : Prop :=
  s.first ∈ J.domain s.link.1 s.row ∧ s.last ∈ J.domain s.link.1 (finRotate r s.row)

def Valid : RawBlock m r n P E → Prop
  | .inl h => ValidHorizontal J h
  | .inr s => ValidSquare J s

abbrev Block := { b : RawBlock m r n P E // Valid J b }

def row : RawBlock m r n P E → Fin r
  | .inl h => h.row
  | .inr s => s.row

def squareLeft (s : Square m r n E) : Horizontal m r n P E :=
  ⟨s.row, left J.source s.link, s.first, s.last⟩

def squareRight (s : Square m r n E) : Horizontal m r n P E :=
  ⟨s.row, right J.target s.link, matchOutput J s.link s.row s.first,
    matchOutput J s.link (finRotate r s.row) s.last⟩

def squareBottom (s : Square m r n E) : Vertical m r n E := ⟨s.row, s.link, s.first⟩
def squareTop (s : Square m r n E) : Vertical m r n E := ⟨finRotate r s.row, s.link, s.last⟩

def HasReadout : RawBlock m r n P E → Readout m r n P E → Prop
  | .inl h, a => a = .inl h
  | .inr s, a => a = .inl (squareLeft J s) ∨ a = .inl (squareRight J s) ∨
      a = .inr (squareBottom s) ∨ a = .inr (squareTop s)

def end0 : Readout m r n P E → Corner m r n P E
  | .inl h => (h.row, h.type, h.first)
  | .inr v => (v.row, left J.source v.link, v.label)

def end1 : Readout m r n P E → Corner m r n P E
  | .inl h => (finRotate r h.row, h.type, h.last)
  | .inr v => (v.row, right J.target v.link, matchOutput J v.link v.row v.label)

theorem readout_ne (hr : 2 ≤ r) (hn : 0 < n) (a : Readout m r n P E) :
    end0 J a ≠ end1 J a := by
  cases a with
  | inl h =>
    intro he
    exact Wrapping.finRotate_no_fixed hr h.row (congrArg Prod.fst he).symm
  | inr v =>
    intro he
    exact endpoints_ne hn J.source J.target v.link (congrArg (fun c => c.2.1) he)

def diagram (hr : 2 ≤ r) (hn : 0 < n) (U : Set (Block (n := n) J)) :
    SimpleGraph (Corner m r n P E) where
  Adj v w := ∃ b ∈ U, ∃ a, HasReadout J b.val a ∧
    ((v = end0 J a ∧ w = end1 J a) ∨ (v = end1 J a ∧ w = end0 J a))
  symm := ⟨by
    rintro v w ⟨b,hb,a,ha,h⟩
    exact ⟨b,hb,a,ha,h.elim (fun h => Or.inr h.symm) (fun h => Or.inl h.symm)⟩⟩
  loopless := ⟨by
    rintro v ⟨b,hb,a,ha,h⟩
    exact readout_ne J hr hn a (h.elim (fun h => h.1.symm.trans h.2)
      (fun h => h.2.symm.trans h.1))⟩

theorem finRotate_twice_ne (hr : 3 ≤ r) (i : Fin r) : finRotate r (finRotate r i) ≠ i := by
  have : NeZero r := ⟨by omega⟩
  intro he
  have hh : (1 : Fin r) + 1 = 0 := by
    apply add_left_cancel (a := i)
    simpa only [finRotate_apply, add_assoc, add_zero] using he
  have hval := congrArg Fin.val hh
  have h1 : 1 % r = 1 := Nat.mod_eq_of_lt (by omega)
  have h2 : 2 % r = 2 := Nat.mod_eq_of_lt (by omega)
  norm_num [Fin.val_add, Fin.val_one, h1, h2] at hval

def horizontalTag (v w : Corner m r n P E) : Option (Fin r) :=
  if w.1 = finRotate r v.1 then some v.1
  else if v.1 = finRotate r w.1 then some w.1 else none

theorem horizontalTag_readout (hr : 3 ≤ r) (a : Readout m r n P E) :
    horizontalTag (end0 J a) (end1 J a) =
      (match a with | .inl h => some h.row | .inr _ => none) ∧
    horizontalTag (end1 J a) (end0 J a) =
      (match a with | .inl h => some h.row | .inr _ => none) := by
  cases a with
  | inl h =>
    dsimp only [horizontalTag, end0, end1]
    simp only [if_neg (finRotate_twice_ne hr h.row).symm]
    exact ⟨rfl,rfl⟩
  | inr v =>
    have hne := (Wrapping.finRotate_no_fixed (by omega) v.row).symm
    dsimp only [horizontalTag, end0, end1]
    simp only [if_neg hne, and_self]

def rowDiagram (hr : 3 ≤ r) (hn : 0 < n) (U : Set (Block (n := n) J)) :
    Wrapping.RowDiagram (diagram J (by omega) hn U) (finRotate r) where
  boundary := Prod.fst
  horizontal := horizontalTag
  symmetric := by
    rintro v w ⟨b,hb,a,ha,h⟩
    rcases h with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩
    · exact (horizontalTag_readout J hr a).1.trans (horizontalTag_readout J hr a).2.symm
    · exact (horizontalTag_readout J hr a).2.trans (horizontalTag_readout J hr a).1.symm
  shape := by
    rintro v w ⟨b,hb,a,ha,h⟩
    rcases h with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩
    · rw [(horizontalTag_readout J hr a).1]
      cases a with
      | inl h => exact Or.inl ⟨rfl,rfl⟩
      | inr v => rfl
    · rw [(horizontalTag_readout J hr a).2]
      cases a with
      | inl h => exact Or.inr ⟨rfl,rfl⟩
      | inr v => rfl

end VariableWL.Blocks

namespace VariableWL.Blocks
open Subdivision
variable {m r n : ℕ} {P : Type uBlocks13} {E : Type uBlocks14} (J : ProductImages.Instance m r P E)

def linksOf : RawBlock m r n P E → Finset (Link E n)
  | .inl _ => ∅
  | .inr s => {s.link}

noncomputable def supportLinks (U : Finset (Block (n := n) J)) : Finset (Link E n) :=
  by classical exact U.biUnion (fun b => linksOf b.val)

theorem supportLinks_card (U : Finset (Block (n := n) J)) :
    (supportLinks J U).card ≤ U.card := by
  classical
  calc
    _ ≤ ∑ b ∈ U, (linksOf b.val).card := Finset.card_biUnion_le
    _ ≤ ∑ _b ∈ U, 1 := Finset.sum_le_sum fun b _ => by
      cases b.val <;> simp [linksOf]
    _ = U.card := by simp

theorem square_link_mem (U : Finset (Block (n := n) J)) {b : Block (n := n) J}
    (hb : b ∈ U) {s : Square m r n E} (hs : b.val = .inr s) :
    s.link ∈ supportLinks J U := by
  classical
  apply Finset.mem_biUnion.mpr
  exact ⟨b,hb,by simp [hs, linksOf]⟩

theorem hasReadout_horizontal_row {b : RawBlock m r n P E} {h : Horizontal m r n P E}
    (hh : HasReadout J b (.inl h)) : h.row = row b := by
  classical
  cases b with
  | inl h' => cases hh; rfl
  | inr s =>
    rcases hh with hh | hh | hh | hh
    · cases hh; rfl
    · cases hh; rfl
    · cases hh
    · cases hh

theorem hasReadout_vertical_link {b : RawBlock m r n P E} {v : Vertical m r n E}
    (hh : HasReadout J b (.inr v)) : v.link ∈ linksOf b := by
  classical
  cases b with
  | inl h => cases hh
  | inr s =>
    rcases hh with hh | hh | hh | hh
    · cases hh
    · cases hh
    · cases hh; simp [linksOf, squareBottom]
    · cases hh; simp [linksOf, squareTop]

theorem projection_adj (hr : 2 ≤ r) (hn : 0 < n) (U : Finset (Block (n := n) J))
    {v w : Corner m r n P E} (h : (diagram J hr hn U).Adj v w) :
    v.2.1 = w.2.1 ∨ (supportGraph hn J.source J.target (supportLinks J U)).Adj v.2.1 w.2.1 := by
  classical
  obtain ⟨b,hb,a,ha,h⟩ := h
  have hv {a : Vertical m r n E} (ha : HasReadout J b.val (.inr a)) :
      a.link ∈ supportLinks J U := Finset.mem_biUnion.mpr
        ⟨b,hb,hasReadout_vertical_link J ha⟩
  rcases h with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ <;> cases a with
  | inl h => exact Or.inl rfl
  | inr v =>
    apply Or.inr
    first
    | exact ⟨v.link, hv ha, Or.inl ⟨rfl,rfl⟩⟩
    | exact ⟨v.link, hv ha, Or.inr ⟨rfl,rfl⟩⟩

theorem projection_reachable (hr : 2 ≤ r) (hn : 0 < n) (U : Finset (Block (n := n) J))
    {v w : Corner m r n P E} (h : (diagram J hr hn U).Reachable v w) :
    (supportGraph hn J.source J.target (supportLinks J U)).Reachable v.2.1 w.2.1 := by
  classical
  obtain ⟨p⟩ := h
  induction p with
  | nil => exact SimpleGraph.Reachable.refl _
  | cons h p ih =>
    rcases projection_adj J hr hn U h with h | h
    · exact h ▸ ih
    · exact h.reachable.trans ih

theorem row_cover (hr : 3 ≤ r) (hn : 0 < n) (U : Finset (Block (n := n) J))
    {v w : Corner m r n P E} (h : (diagram J (by omega) hn U).Adj v w)
    {i : Fin r} (hi : (rowDiagram J hr hn U).horizontal v w = some i) :
    i ∈ U.image (fun b => row b.val) := by
  classical
  obtain ⟨b,hb,a,ha,h⟩ := h
  have he : (Sum.elim (fun h => some h.row) (fun _ => none) a) = some i := by
    rcases h with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩
    · have ht := (horizontalTag_readout J hr a).1.symm.trans hi
      cases a <;> exact ht
    · have ht := (horizontalTag_readout J hr a).2.symm.trans hi
      cases a <;> exact ht
  cases a with
  | inr v => cases he
  | inl h =>
    have he' := Option.some.inj he
    exact Finset.mem_image.mpr ⟨b,hb,(hasReadout_horizontal_row J ha).symm.trans he'⟩

theorem wrapping_card_ge (hr : 3 ≤ r) (hn : 0 < n) (U : Finset (Block (n := n) J))
    {marked : Fin r} (hw : (rowDiagram J hr hn U).Wraps marked) : r ≤ U.card := by
  classical
  have : NeZero r := ⟨by omega⟩
  simpa only [Fintype.card_fin] using (rowDiagram J hr hn U).blocks_card_ge U
    (fun b => row b.val) (fun _ _ h _ hi => row_cover J hr hn U h hi)
    Wrapping.RowDiagram.finRotate_orbit hw

theorem wrapping_row_injective (hr : 3 ≤ r) (hn : 0 < n) (U : Finset (Block (n := n) J))
    {marked : Fin r} (hw : (rowDiagram J hr hn U).Wraps marked) (hc : U.card = r) :
    Set.InjOn (fun b : Block (n := n) J => row b.val) (↑U : Set (Block (n := n) J)) := by
  classical
  have : NeZero r := ⟨by omega⟩
  exact (rowDiagram J hr hn U).row_injective U (fun b => row b.val)
    (fun _ _ h _ hi => row_cover J hr hn U h hi)
    Wrapping.RowDiagram.finRotate_orbit hw (by simpa only [Fintype.card_fin] using hc)

noncomputable def aligned (cut : E → Fin (n+1)) (v : Corner m r n P E) : (Fin m) :=
  J.alignment cut v.2.1 v.1 v.2.2

noncomputable def firstLabel (cut : E → Fin (n+1)) : RawBlock m r n P E → (Fin m)
  | .inl h => J.alignment cut h.type h.row h.first
  | .inr s => J.alignment cut (left J.source s.link) s.row s.first

noncomputable def lastLabel (cut : E → Fin (n+1)) : RawBlock m r n P E → (Fin m)
  | .inl h => J.alignment cut h.type (finRotate r h.row) h.last
  | .inr s => J.alignment cut (left J.source s.link) (finRotate r s.row) s.last

theorem square_alignment (hn : 0 < n) (cut : E → Fin (n+1))
    (s : Square m r n E) (hs : ValidSquare J s) (hc : s.link.2 ≠ cut s.link.1) :
    aligned J cut (end0 J (.inl (squareRight J s))) = firstLabel J cut (.inr s) ∧
    aligned J cut (end1 J (.inl (squareRight J s))) = lastLabel J cut (.inr s) := by
  classical
  constructor
  · exact (J.alignment_match hn cut s.link hc s.row ⟨hs.1,rfl⟩).symm
  · exact (J.alignment_match hn cut s.link hc (finRotate r s.row) ⟨hs.2,rfl⟩).symm

theorem horizontal_labels (hn : 0 < n) (cut : E → Fin (n+1))
    (b : Block (n := n) J) (hc : ∀ l ∈ linksOf b.val, l.2 ≠ cut l.1)
    {h : Horizontal m r n P E} (hh : HasReadout J b.val (.inl h)) :
    aligned J cut (end0 J (.inl h)) = firstLabel J cut b.val ∧
    aligned J cut (end1 J (.inl h)) = lastLabel J cut b.val := by
  classical
  obtain ⟨b,hb⟩ := b
  cases b with
  | inl h' => cases hh; exact ⟨rfl,rfl⟩
  | inr s =>
    rcases hh with hh | hh | hh | hh
    · cases hh; exact ⟨rfl,rfl⟩
    · cases hh; exact square_alignment J hn cut s hb (hc s.link (by simp [linksOf]))
    · cases hh
    · cases hh

theorem vertical_labels (hn : 0 < n) (cut : E → Fin (n+1))
    (b : Block (n := n) J) (hc : ∀ l ∈ linksOf b.val, l.2 ≠ cut l.1)
    {v : Vertical m r n E} (hv : HasReadout J b.val (.inr v)) :
    aligned J cut (end0 J (.inr v)) = aligned J cut (end1 J (.inr v)) := by
  classical
  obtain ⟨b,hb⟩ := b
  cases b with
  | inl h => cases hv
  | inr s =>
    have hcut := hc s.link (by simp [linksOf])
    rcases hv with hv | hv | hv | hv
    · cases hv
    · cases hv
    · cases hv; exact J.alignment_match hn cut s.link hcut s.row ⟨hb.1,rfl⟩
    · cases hv; exact J.alignment_match hn cut s.link hcut (finRotate r s.row) ⟨hb.2,rfl⟩

end VariableWL.Blocks

namespace VariableWL.Blocks
open Subdivision
variable {m r n : ℕ} {P : Type uBlocks15} {E : Type uBlocks16} (J : ProductImages.Instance m r P E)

theorem recovered_address (hr : 3 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J)) (cut : E → Fin (n+1))
    (hcut : ∀ l ∈ supportLinks J U, l.2 ≠ cut l.1)
    {marked : Fin r} (hw : (rowDiagram J hr hn U).Wraps marked) (hc : U.card = r) :
    ∃ a : Fin r → (Fin m), ∀ b ∈ U,
      firstLabel J cut b.val = a (row b.val) ∧
        lastLabel J cut b.val = a (finRotate r (row b.val)) := by
  classical
  have : NeZero r := ⟨by omega⟩
  have hrows := (rowDiagram J hr hn U).covers_rows U (fun b => row b.val)
    (fun _ _ h _ hi => row_cover J hr hn U h hi)
    Wrapping.RowDiagram.finRotate_orbit hw
  have hi := wrapping_row_injective J hr hn U hw hc
  choose chosen hat using fun i => Finset.mem_image.mp (hrows i)
  have hatmem (i) : chosen i ∈ U := (hat i).1
  have hatrow (i) : row (chosen i).val = i := (hat i).2
  have hateq (b : Block (n := n) J) (hb : b ∈ U) : chosen (row b.val) = b :=
    hi (hatmem _) hb (hatrow _)
  let first := fun i => firstLabel J cut (chosen i).val
  let last := fun i => lastLabel J cut (chosen i).val
  have hl : (rowDiagram J hr hn U).Labeled (aligned J cut) first last := by
    rintro v w ⟨b,hb,c,hc,h⟩
    have hc' : ∀ l ∈ linksOf b.val, l.2 ≠ cut l.1 := fun l hl =>
      hcut l (Finset.mem_biUnion.mpr ⟨b,hb,hl⟩)
    have hfirst : first (row b.val) = firstLabel J cut b.val := by
      dsimp only [first]; rw [hateq b hb]
    have hlast : last (row b.val) = lastLabel J cut b.val := by
      dsimp only [last]; rw [hateq b hb]
    rcases h with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩
    · dsimp only [rowDiagram]
      rw [(horizontalTag_readout J hr c).1]
      cases c with
      | inl h =>
        have hrow := hasReadout_horizontal_row J hc
        obtain ⟨hf,hl⟩ := horizontal_labels J hn cut b hc' hc
        rw [← hrow] at hfirst hlast
        exact Or.inl ⟨Prod.ext rfl (hf.trans hfirst.symm),
          Prod.ext rfl (hl.trans hlast.symm)⟩
      | inr v => exact Prod.ext rfl (vertical_labels J hn cut b hc' hc)
    · dsimp only [rowDiagram]
      rw [(horizontalTag_readout J hr c).2]
      cases c with
      | inl h =>
        have hrow := hasReadout_horizontal_row J hc
        obtain ⟨hf,hl⟩ := horizontal_labels J hn cut b hc' hc
        rw [← hrow] at hfirst hlast
        exact Or.inr ⟨Prod.ext rfl (hf.trans hfirst.symm),
          Prod.ext rfl (hl.trans hlast.symm)⟩
      | inr v => exact Prod.ext rfl (vertical_labels J hn cut b hc' hc).symm
  have hcoherent := (rowDiagram J hr hn U).label_coherence (aligned J cut) first last
    hl Wrapping.RowDiagram.finRotate_orbit hw
  refine ⟨first, fun b hb => ⟨?_, ?_⟩⟩
  · dsimp only [first]; rw [hateq b hb]
  · rw [← hcoherent (row b.val)]
    dsimp only [last]; rw [hateq b hb]

end VariableWL.Blocks

namespace VariableWL.ProductImages.Instance
open VariableWL.Affine Subdivision
variable {m r n : ℕ} {P : Type uBlocks17} {E : Type uBlocks18} (J : ProductImages.Instance m r P E)

def AgreeAt (h g : J.Shifts n) : Vertex P E n → Prop
  | .inl p => h.1 p = g.1 p
  | .inr q => h.2 q = g.2 q

theorem shiftLeft_agree {h g : J.Shifts n} (l : Link E n)
    (ha : J.AgreeAt h g (left J.source l)) : J.shiftLeft h l = J.shiftLeft g l := by
  unfold left at ha
  unfold shiftLeft
  split_ifs at ha ⊢ with hl
  · exact congrArg (J.leftForm l.1) ha
  · exact ha

theorem shiftRight_agree {h g : J.Shifts n} (l : Link E n)
    (ha : J.AgreeAt h g (right J.target l)) : J.shiftRight h l = J.shiftRight g l := by
  unfold right at ha
  unfold shiftRight
  split_ifs at ha ⊢ with hr
  · exact congrArg (J.rightForm l.1) ha
  · exact ha

theorem shiftLeft_eq_internal (h : J.Shifts n) (l : Link E n) {q : E × Fin n}
    (hq : left J.source l = .inr q) : J.shiftLeft h l = h.2 q := by
  unfold left at hq
  split at hq
  · cases hq
  · rename_i hl
    simp only [shiftLeft, dif_neg hl, Sum.inr.inj hq]

theorem shiftRight_eq_internal (h : J.Shifts n) (l : Link E n) {q : E × Fin n}
    (hq : right J.target l = .inr q) : J.shiftRight h l = h.2 q := by
  unfold right at hq
  split at hq
  · cases hq
  · rename_i hr
    simp only [shiftRight, dif_neg hr, Sum.inr.inj hq]

theorem agree_adj (hn : 0 < n) (S : Set (Link E n)) {h g : J.Shifts n}
    (hh : J.ShiftSystem S h) (hg : J.ShiftSystem S g)
    {v w : Vertex P E n} (he : (supportGraph hn J.source J.target S).Adj v w)
    (hv : J.AgreeAt h g v) (hw : ∀ p, w = .inl p → h.1 p = g.1 p) :
    J.AgreeAt h g w := by
  cases w with
  | inl p => exact hw p rfl
  | inr q =>
    obtain ⟨l,hl,(⟨hvl,hwr⟩ | ⟨hvr,hwl⟩)⟩ := he
    · have ha := J.shiftLeft_agree l (hvl ▸ hv)
      have hb := (hh l hl).symm.trans (ha.trans (hg l hl))
      rw [J.shiftRight_eq_internal h l hwr.symm,
        J.shiftRight_eq_internal g l hwr.symm] at hb
      exact hb
    · have ha := J.shiftRight_agree l (hvr ▸ hv)
      have hb := (hh l hl).trans (ha.trans (hg l hl).symm)
      rw [J.shiftLeft_eq_internal h l hwl.symm,
        J.shiftLeft_eq_internal g l hwl.symm] at hb
      exact hb

theorem agree_reachable (hn : 0 < n) (S : Set (Link E n)) {h g : J.Shifts n}
    (hh : J.ShiftSystem S h) (hg : J.ShiftSystem S g) (root : Vertex P E n)
    (hroot : J.AgreeAt h g root)
    (hreals : ∀ p, (supportGraph hn J.source J.target S).Reachable root (.inl p) →
      h.1 p = g.1 p) {w : Vertex P E n}
    (hw : (supportGraph hn J.source J.target S).Reachable root w) : J.AgreeAt h g w := by
  obtain ⟨path⟩ := hw
  have walk_prop {v w : Vertex P E n} (p : (supportGraph hn J.source J.target S).Walk v w)
      (hv : J.AgreeAt h g v)
      (hr : (supportGraph hn J.source J.target S).Reachable root v) : J.AgreeAt h g w := by
    induction p with
    | nil => exact hv
    | @cons v u w h p ih =>
      have hu := hr.trans h.reachable
      exact ih (J.agree_adj hn S hh hg h hv (fun p he => hreals p (he ▸ hu))) hu
  exact walk_prop path hroot (.refl _)

end VariableWL.ProductImages.Instance

end ProjectionAudit


/- Adapted from BlockImages.lean. -/

namespace ProjectionAudit

universe uBlockImages1 uBlockImages2 uBlockImages3 uBlockImages4 uBlockImages5 uBlockImages6 uBlockImages7 uBlockImages8 uBlockImages9 uBlockImages10 uBlockImages11 uBlockImages12

namespace VariableWL.Blocks
open scoped CharTwo
open VariableWL.Affine Subdivision
variable {m r n : ℕ} {P : Type uBlockImages1} {E : Type uBlockImages2} (J : ProductImages.Instance m r P E)

def dimension : Vertex P E n → ℕ
  | .inl p => J.dimension p
  | .inr _ => 1

abbrev Value (t : Vertex P E n) := Vec (dimension J t)

def vectorShift (h : J.Shifts n) : ∀ t : Vertex P E n, Value J t
  | .inl p => h.1 p
  | .inr q => fun _ => h.2 q

def linkLeft (l : Link E n) : Value J (left J.source l) →ₗ[Bit] Bit := by
  unfold left
  split_ifs with hz
  · rw [dif_pos hz]
    exact J.linearLeft l.1
  · rw [dif_neg hz]
    exact LinearMap.proj (0 : Fin 1)

def linkRight (l : Link E n) : Value J (right J.target l) →ₗ[Bit] Bit := by
  unfold right
  split_ifs with hz
  · rw [dif_pos hz]
    exact J.linearRight l.1
  · rw [dif_neg hz]
    exact LinearMap.proj (0 : Fin 1)

def leftConstant (l : Link E n) : Bit := if l.2.val = 0 then J.constantLeft l.1 else 0
def rightConstant (l : Link E n) : Bit := if l.2.val = n then J.constantRight l.1 else 0

def linkConstant (l : Link E n) : Bit := leftConstant J l + rightConstant J l

theorem dependent_linear_apply {A : Type uBlockImages3} (d : A → ℕ) {i j : A} (he : i = j)
    (L : Vec (d i) →ₗ[Bit] Bit) (v : ∀ t, Vec (d t)) :
    (cast (congrArg (fun t => Vec (d t) →ₗ[Bit] Bit) he) L) (v j) = L (v i) := by
  subst j; rfl

theorem linkLeft_eval (h : J.Shifts n) (l : Link E n) :
    linkLeft J l (vectorShift J h (left J.source l)) + leftConstant J l =
      J.shiftLeft h l := by
  by_cases hz : l.2.val = 0
  · have he := dependent_linear_apply (dimension J) (i := .inl (J.source l.1))
      (j := left J.source l) (by simp only [left, dif_pos hz])
      (J.linearLeft l.1) (vectorShift J h)
    simp only [linkLeft, dif_pos hz, leftConstant, if_pos hz,
      ProductImages.Instance.shiftLeft, ProductImages.Instance.leftForm]
    exact congrArg (fun z => z + J.constantLeft l.1) he
  · simp only [linkLeft, dif_neg hz, leftConstant, if_neg hz, add_zero,
      ProductImages.Instance.shiftLeft]
    exact dependent_linear_apply (dimension J)
      (i := .inr (l.1, ⟨l.2.val-1, by omega⟩)) (j := left J.source l)
      (by simp only [left, dif_neg hz]) (LinearMap.proj (0 : Fin 1)) (vectorShift J h)

theorem linkRight_eval (h : J.Shifts n) (l : Link E n) :
    linkRight J l (vectorShift J h (right J.target l)) + rightConstant J l =
      J.shiftRight h l := by
  by_cases hz : l.2.val = n
  · have he := dependent_linear_apply (dimension J) (i := .inl (J.target l.1))
      (j := right J.target l) (by simp only [right, dif_pos hz])
      (J.linearRight l.1) (vectorShift J h)
    simp only [linkRight, dif_pos hz, rightConstant, if_pos hz,
      ProductImages.Instance.shiftRight, ProductImages.Instance.rightForm]
    exact congrArg (fun z => z + J.constantRight l.1) he
  · simp only [linkRight, dif_neg hz, rightConstant, if_neg hz, add_zero,
      ProductImages.Instance.shiftRight]
    exact dependent_linear_apply (dimension J)
      (i := .inr (l.1, ⟨l.2.val, by omega⟩)) (j := right J.target l)
      (by simp only [right, dif_neg hz]) (LinearMap.proj (0 : Fin 1)) (vectorShift J h)

theorem link_equation_iff (h : J.Shifts n) (l : Link E n) :
    linkLeft J l (vectorShift J h (left J.source l)) +
        linkRight J l (vectorShift J h (right J.target l)) = linkConstant J l ↔
      J.shiftLeft h l = J.shiftRight h l := by
  rw [← linkLeft_eval J h l, ← linkRight_eval J h l]
  unfold linkConstant
  constructor <;> intro he
  · have hh := congrArg (fun z => z + linkRight J l (vectorShift J h (right J.target l)) +
        leftConstant J l) he
    simpa [add_assoc, add_comm, add_left_comm] using hh
  · have hh := congrArg (fun z => z + leftConstant J l +
        linkRight J l (vectorShift J h (right J.target l))) he
    simpa [add_assoc, add_comm, add_left_comm] using hh

abbrev ReadoutValue : Readout m r n P E → Type
  | .inl h => Value J h.type
  | .inr _ => Bit

abbrev Potentials := ∀ v : Corner m r n P E, Value J v.2.1

def marker (marked i : Fin r) : Bit := if i = marked then 1 else 0

def potentialValues (marked : Fin r) (h : J.Shifts n) (M : Potentials (n := n) J) :
    ∀ a : Readout m r n P E, ReadoutValue J a
  | .inl x => M (x.row, x.type, x.first) + M (finRotate r x.row, x.type, x.last) +
      marker marked x.row • vectorShift J h x.type
  | .inr y => linkLeft J y.link (M (y.row, left J.source y.link, y.label)) +
      linkRight J y.link (M (y.row, right J.target y.link, matchOutput J y.link y.row y.label))

theorem potential_square (marked : Fin r) (h : J.Shifts n) (M : Potentials (n := n) J)
    (s : Square m r n E) (hs : J.shiftLeft h s.link = J.shiftRight h s.link) :
    linkLeft J s.link (potentialValues J marked h M (.inl (squareLeft J s))) +
      linkRight J s.link (potentialValues J marked h M (.inl (squareRight J s))) +
      potentialValues J marked h M (.inr (squareBottom s)) +
      potentialValues J marked h M (.inr (squareTop s)) =
        marker marked s.row * linkConstant J s.link := by
  have he := (link_equation_iff J h s.link).mpr hs
  dsimp only [potentialValues, squareLeft, squareRight, squareBottom, squareTop, end0, end1]
  simp only [map_add, map_smul, smul_eq_mul]
  have ht : (2 : Bit) = 0 := by decide
  linear_combination (marker marked s.row) * he +
    (linkLeft J s.link (M (s.row, left J.source s.link, s.first)) +
      linkLeft J s.link (M (finRotate r s.row, left J.source s.link, s.last)) +
      linkRight J s.link (M (s.row, right J.target s.link,
        matchOutput J s.link s.row s.first)) +
      linkRight J s.link (M (finRotate r s.row, right J.target s.link,
        matchOutput J s.link (finRotate r s.row) s.last))) * ht

def gaugePotentials (h g : J.Shifts n) (M : Potentials (n := n) J) (s : Corner m r n P E → Bit) :
    Potentials (n := n) J := fun v => M v + s v • (vectorShift J g v.2.1 + vectorShift J h v.2.1)

theorem gauge_horizontal_readout (marked : Fin r) (h g : J.Shifts n)
    (M : Potentials (n := n) J) (s : Corner m r n P E → Bit) (x : Horizontal m r n P E)
    (hs : s (end0 J (.inl x)) + s (end1 J (.inl x)) = marker marked x.row) :
    potentialValues J marked g (gaugePotentials J h g M s) (.inl x) =
      potentialValues J marked h M (.inl x) := by
  exact Affine.gauge_horizontal _ _ _ _ _ _ _ hs

theorem gauge_vertical_readout (marked : Fin r) (h g : J.Shifts n)
    (M : Potentials (n := n) J) (s : Corner m r n P E → Bit) (y : Vertical m r n E)
    (hs : s (end0 J (.inr y)) = s (end1 J (.inr y)))
    (hh : J.shiftLeft h y.link = J.shiftRight h y.link)
    (hg : J.shiftLeft g y.link = J.shiftRight g y.link) :
    potentialValues J marked g (gaugePotentials J h g M s) (.inr y) =
      potentialValues J marked h M (.inr y) := by
  exact Affine.gauge_vertical _ _ _ _ _ _ _ _ _ _ hs
    (Affine.shift_difference _ _ _ _ _ _ _
      ((link_equation_iff J h y.link).mpr hh) ((link_equation_iff J g y.link).mpr hg))

end VariableWL.Blocks

namespace VariableWL.Markers
open scoped CharTwo
variable {V : Type uBlockImages4} {G : SimpleGraph V}

@[simp] theorem walkSum_copy (ω : V → V → Bit) {u v u' v' : V}
    (p : G.Walk u v) (hu : u = u') (hv : v = v') :
    walkSum ω (p.copy hu hv) = walkSum ω p := by
  subst u'; subst v'; rfl

theorem exists_potential_all (ω : V → V → Bit)
    (hsym : ∀ u v, G.Adj u v → ω u v = ω v u)
    (hzero : ∀ u (p : G.Walk u u), walkSum ω p = 0) :
    ∃ s : V → Bit, ∀ u v, G.Adj u v → s u + s v = ω u v := by
  classical
  let root (v : V) : V := (G.connectedComponentMk v).out
  have hr (v : V) : G.Reachable (root v) v :=
    SimpleGraph.ConnectedComponent.exact (G.connectedComponentMk v).out_eq
  let p (v : V) : G.Walk (root v) v := (hr v).some
  refine ⟨fun v => walkSum ω (p v), ?_⟩
  intro u v huv
  have he : root v = root u := congrArg (fun c : G.ConnectedComponent => c.out)
    (SimpleGraph.ConnectedComponent.sound huv.reachable).symm
  have hc := hzero (root u)
    (((p u).append huv.toWalk).append ((p v).copy he rfl).reverse)
  simp only [walkSum_append, walkSum_reverse ω hsym, walkSum_copy,
    SimpleGraph.Adj.toWalk, walkSum_cons, walkSum_nil, add_zero] at hc
  calc
    walkSum ω (p u) + walkSum ω (p v) =
        (walkSum ω (p u) + ω u v + walkSum ω (p v)) + ω u v := by
      simp [add_comm, add_assoc]
    _ = ω u v := by rw [hc, zero_add]
end VariableWL.Markers

namespace VariableWL.Wrapping.RowDiagram
open scoped CharTwo
open VariableWL.Markers
variable {I : Type uBlockImages5} {V : Type uBlockImages6} [DecidableEq I] {G : SimpleGraph V}
    {next : Equiv.Perm I} (D : VariableWL.Wrapping.RowDiagram G next)

theorem nonwrapping_potential (marked : I) (hn : ¬ D.Wraps marked) :
    ∃ s : V → Bit, ∀ u v, G.Adj u v → s u + s v = D.rowWeight marked u v := by
  apply Markers.exists_potential_all
  · intro u v h
    simp only [rowWeight, D.symmetric u v h]
  · intro u p
    have hx : ∀ x : Bit, x = 0 ∨ x = 1 := by decide
    rcases hx (walkSum (D.rowWeight marked) p) with h | h
    · exact h
    · exact (hn ⟨u,p,h⟩).elim
end VariableWL.Wrapping.RowDiagram

namespace VariableWL.Blocks
open scoped CharTwo
open VariableWL.Affine Subdivision
variable {m r n : ℕ} {P : Type uBlockImages7} {E : Type uBlockImages8} (J : ProductImages.Instance m r P E)

theorem readout_adj (hr : 2 ≤ r) (hn : 0 < n) (U : Set (Block (n := n) J))
    {b : Block (n := n) J} (hb : b ∈ U) {a : Readout m r n P E}
    (ha : HasReadout J b.val a) : (diagram J hr hn U).Adj (end0 J a) (end1 J a) :=
  ⟨b,hb,a,ha,Or.inl ⟨rfl,rfl⟩⟩

theorem diagram_mono (hr : 2 ≤ r) (hn : 0 < n) {U V : Set (Block (n := n) J)}
    (h : U ⊆ V) : diagram J hr hn U ≤ diagram J hr hn V := by
  rintro u v ⟨b,hb,a,ha,hh⟩
  exact ⟨b,h hb,a,ha,hh⟩

theorem gauge_nonwrapping (hr : 3 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J)) (marked : Fin r)
    (h g : J.Shifts n) (M : Potentials (n := n) J)
    (hh : J.ShiftSystem (supportLinks J U) h)
    (hg : J.ShiftSystem (supportLinks J U) g)
    (hnw : ¬ (rowDiagram J hr hn U).Wraps marked) :
    ∃ M' : Potentials (n := n) J, ∀ b ∈ U, ∀ a, HasReadout J b.val a →
      potentialValues J marked g M' a = potentialValues J marked h M a := by
  classical
  obtain ⟨s,hs⟩ := (rowDiagram J hr hn U).nonwrapping_potential marked hnw
  refine ⟨gaugePotentials J h g M s, ?_⟩
  intro b hb a ha
  have hed := readout_adj J (by omega) hn U hb ha
  have he := hs (end0 J a) (end1 J a) hed
  dsimp only [rowDiagram] at he
  unfold Wrapping.RowDiagram.rowWeight at he
  dsimp only at he
  simp only [(horizontalTag_readout J hr a).1] at he
  cases a with
  | inl x =>
    apply gauge_horizontal_readout J marked h g M s x
    simpa [marker] using he
  | inr y =>
    apply gauge_vertical_readout J marked h g M s y
    · simp only [reduceCtorEq, ite_false] at he
      have he' := congrArg (fun z => z + s (end1 J (.inr y))) he
      simpa [add_assoc] using he'
    · exact hh y.link (Finset.mem_biUnion.mpr
        ⟨b,hb,hasReadout_vertical_link J ha⟩)
    · exact hg y.link (Finset.mem_biUnion.mpr
        ⟨b,hb,hasReadout_vertical_link J ha⟩)
end VariableWL.Blocks

namespace VariableWL.ProductImages.Instance
open VariableWL.Affine Subdivision
variable {m r n : ℕ} {P : Type uBlockImages9} {E : Type uBlockImages10} (J : ProductImages.Instance m r P E)

noncomputable def replaceInternal (hn : 0 < n) (S : Set (Link E n))
    (root : Vertex P E n) (a : Bit) (h : J.Shifts n) : J.Shifts n := by
  classical
  exact (h.1, fun q => if (supportGraph hn J.source J.target S).Reachable root (.inr q)
    then a else h.2 q)

theorem replaceInternal_agree_outside (hn : 0 < n) (S : Set (Link E n))
    (root : Vertex P E n) (a : Bit) (h : J.Shifts n) {v : Vertex P E n}
    (hv : ¬ (supportGraph hn J.source J.target S).Reachable root v) :
    J.AgreeAt (J.replaceInternal hn S root a h) h v := by
  classical
  cases v with
  | inl p => rfl
  | inr q => exact if_neg hv

theorem replaceInternal_system (hn : 0 < n) (S : Set (Link E n))
    (root : Vertex P E n) (a : Bit) (h : J.Shifts n) (hh : J.ShiftSystem S h)
    (hnr : ∀ p, ¬ (supportGraph hn J.source J.target S).Reachable root (.inl p)) :
    J.ShiftSystem S (J.replaceInternal hn S root a h) := by
  classical
  intro l hl
  have hadj : (supportGraph hn J.source J.target S).Adj
      (left J.source l) (right J.target l) := ⟨l,hl,Or.inl ⟨rfl,rfl⟩⟩
  by_cases hr : (supportGraph hn J.source J.target S).Reachable root (left J.source l)
  · have hr' := hr.trans hadj.reachable
    obtain ⟨q,hq⟩ : ∃ q, left J.source l = .inr q := by
      cases he : left J.source l with
      | inl p => exact (hnr p (he ▸ hr)).elim
      | inr q => exact ⟨q,rfl⟩
    obtain ⟨q',hq'⟩ : ∃ q', right J.target l = .inr q' := by
      cases he : right J.target l with
      | inl p => exact (hnr p (he ▸ hr')).elim
      | inr q => exact ⟨q,rfl⟩
    rw [J.shiftLeft_eq_internal _ l hq, J.shiftRight_eq_internal _ l hq']
    simp only [replaceInternal, if_pos (hq ▸ hr), if_pos (hq' ▸ hr')]
  · have hr' : ¬ (supportGraph hn J.source J.target S).Reachable root (right J.target l) :=
      fun hw => hr (hw.trans hadj.symm.reachable)
    rw [J.shiftLeft_agree l (J.replaceInternal_agree_outside hn S root a h hr),
      J.shiftRight_agree l (J.replaceInternal_agree_outside hn S root a h hr')]
    exact hh l hl

theorem exists_scalar_shift (hn : 0 < n) (S : Set (Link E n))
    (root : Vertex P E n) (a : Bit) (h : J.Shifts n) (hh : J.ShiftSystem S h)
    (hnr : ∀ p, ¬ (supportGraph hn J.source J.target S).Reachable root (.inl p)) :
    ∃ g : J.Shifts n, J.ShiftSystem S g ∧ ∀ q,
      (supportGraph hn J.source J.target S).Reachable root (.inr q) → g.2 q = a := by
  classical
  refine ⟨J.replaceInternal hn S root a h,
    J.replaceInternal_system hn S root a h hh hnr, ?_⟩
  intro q hq
  exact if_pos hq

theorem internal_adj_values (hn : 0 < n) (S : Set (Link E n))
    (h : J.Shifts n) (hh : J.ShiftSystem S h) {q q' : E × Fin n}
    (ha : (supportGraph hn J.source J.target S).Adj (.inr q) (.inr q')) :
    h.2 q = h.2 q' := by
  obtain ⟨l,hl,⟨he,he'⟩ | ⟨he,he'⟩⟩ := ha
  · exact (J.shiftLeft_eq_internal h l he.symm).symm.trans
      ((hh l hl).trans (J.shiftRight_eq_internal h l he'.symm))
  · exact (J.shiftRight_eq_internal h l he.symm).symm.trans
      ((hh l hl).symm.trans (J.shiftLeft_eq_internal h l he'.symm))

theorem scalar_constant (hn : 0 < n) (S : Set (Link E n))
    (h : J.Shifts n) (hh : J.ShiftSystem S h) (q : E × Fin n)
    (hnr : ∀ p, ¬ (supportGraph hn J.source J.target S).Reachable (.inr q) (.inl p))
    {q' : E × Fin n}
    (hr : (supportGraph hn J.source J.target S).Reachable (.inr q) (.inr q')) :
    h.2 q = h.2 q' := by
  have walk_prop {v w : Vertex P E n}
      (p : (supportGraph hn J.source J.target S).Walk v w)
      (hv : ∃ qv, v = .inr qv ∧ h.2 q = h.2 qv)
      (hreach : (supportGraph hn J.source J.target S).Reachable (.inr q) v) :
      ∃ qw, w = .inr qw ∧ h.2 q = h.2 qw := by
    induction p with
    | nil => exact hv
    | @cons v u w hadj p ih =>
      obtain ⟨qv,rfl,hv⟩ := hv
      have hu := hreach.trans hadj.reachable
      obtain ⟨qu,rfl⟩ : ∃ qu, u = .inr qu := by
        cases u with
        | inl real => exact (hnr real hu).elim
        | inr qu => exact ⟨qu,rfl⟩
      exact ih ⟨qu,rfl,hv.trans (J.internal_adj_values hn S h hh hadj)⟩ hu
  obtain ⟨qw,he,hh'⟩ := walk_prop hr.some ⟨q,rfl,rfl⟩ (.refl _)
  cases Sum.inr.inj he
  exact hh'
end VariableWL.ProductImages.Instance

namespace VariableWL.ProductImages.Instance
open Subdivision
variable {m r n : ℕ} {P : Type uBlockImages11} {E : Type uBlockImages12} (J : ProductImages.Instance m r P E)

noncomputable def transport (l : Link E n) (i : Fin r) : Equiv.Perm (Fin m) :=
  if l.2.val = n then J.ambient l.1 i else Equiv.refl _

theorem alignment_link (hn : 0 < n) (cut : E → Fin (n+1))
    (l : Link E n) (hc : l.2 ≠ cut l.1) (i : Fin r) :
    J.alignment cut (left J.source l) i =
      J.alignment cut (right J.target l) i * J.transport l i := by
  have hv : l.2.val ≠ (cut l.1).val := fun h => hc (Fin.ext h)
  have hl := l.2.isLt
  have hk := (cut l.1).isLt
  apply Equiv.ext
  intro a
  unfold left right
  split_ifs with h₀ h₁ h₁
  · omega
  · simp [alignment, transport, h₁, show l.2.val < (cut l.1).val by omega]
  · have hside : ¬ n - 1 < (cut l.1).val := by omega
    simp [alignment, transport, h₁, hside]
  · have hi : l.2.val - 1 < (cut l.1).val ↔ l.2.val < (cut l.1).val := by omega
    simp [alignment, transport, h₁, hi,
      show Equiv.refl (Fin m) = (1 : Equiv.Perm (Fin m)) from rfl]

noncomputable def relativeAlignment (cut cut' : E → Fin (n+1))
    (v : Vertex P E n) (i : Fin r) : Equiv.Perm (Fin m) :=
  J.alignment cut v i * (J.alignment cut' v i)⁻¹

theorem relativeAlignment_link (hn : 0 < n) (cut cut' : E → Fin (n+1))
    (l : Link E n) (hc : l.2 ≠ cut l.1) (hc' : l.2 ≠ cut' l.1) (i : Fin r) :
    J.relativeAlignment cut cut' (left J.source l) i =
      J.relativeAlignment cut cut' (right J.target l) i := by
  unfold relativeAlignment
  rw [J.alignment_link hn cut l hc i, J.alignment_link hn cut' l hc' i]
  simp only [mul_inv_rev, mul_assoc, mul_inv_cancel_left]

theorem relativeAlignment_reachable (hn : 0 < n) (S : Set (Link E n))
    (cut cut' : E → Fin (n+1))
    (hc : ∀ l ∈ S, l.2 ≠ cut l.1) (hc' : ∀ l ∈ S, l.2 ≠ cut' l.1)
    {v w : Vertex P E n} (h : (supportGraph hn J.source J.target S).Reachable v w)
    (i : Fin r) : J.relativeAlignment cut cut' v i = J.relativeAlignment cut cut' w i := by
  obtain ⟨p⟩ := h
  induction p with
  | nil => rfl
  | cons ha _ ih =>
    apply Eq.trans _ ih
    obtain ⟨l,hl,⟨rfl,rfl⟩ | ⟨rfl,rfl⟩⟩ := ha
    · exact J.relativeAlignment_link hn cut cut' l (hc l hl) (hc' l hl) i
    · exact (J.relativeAlignment_link hn cut cut' l (hc l hl) (hc' l hl) i).symm
end VariableWL.ProductImages.Instance

end ProjectionAudit


/- Adapted from BlockCoordinates.lean. -/

namespace ProjectionAudit

universe uBlockCoordinates1 uBlockCoordinates2 uBlockCoordinates3 uBlockCoordinates4 uBlockCoordinates5 uBlockCoordinates6 uBlockCoordinates7 uBlockCoordinates8 uBlockCoordinates9 uBlockCoordinates10 uBlockCoordinates11 uBlockCoordinates12 uBlockCoordinates13 uBlockCoordinates14 uBlockCoordinates15 uBlockCoordinates16 uBlockCoordinates17 uBlockCoordinates18 uBlockCoordinates19 uBlockCoordinates20 uBlockCoordinates21

namespace VariableWL.Subdivision
variable {P : Type uBlockCoordinates1} {E : Type uBlockCoordinates2} {n : ℕ}

theorem realFree_reachable_wire (hn : 0 < n) (src dst : E → P)
    (S : Set (Link E n)) (q : E × Fin n)
    (hnr : ∀ p, ¬ (supportGraph hn src dst S).Reachable (.inr q) (.inl p))
    {v : Vertex P E n} (hr : (supportGraph hn src dst S).Reachable (.inr q) v) :
    ∃ j, v = .inr (q.1,j) := by
  have aux {u v : Vertex P E n} (p : (supportGraph hn src dst S).Walk u v)
      (hu : ∃ j, u = .inr (q.1,j))
      (hreach : (supportGraph hn src dst S).Reachable (.inr q) u) :
      ∃ j, v = .inr (q.1,j) := by
    induction p with
    | nil => exact hu
    | @cons u v w ha p ih =>
      obtain ⟨i,rfl⟩ := hu
      have hv := hreach.trans ha.reachable
      obtain ⟨q',rfl⟩ : ∃ q', v = .inr q' := by
        cases v with
        | inl real => exact (hnr real hv).elim
        | inr q' => exact ⟨q',rfl⟩
      have hw := internal_adj_wire hn src dst S ha
      exact ih ⟨q'.2, by rw [hw]⟩ hv
  exact aux hr.some ⟨q.2,rfl⟩ (.refl _)
end VariableWL.Subdivision

namespace VariableWL.Markers
open scoped CharTwo
variable {V : Type uBlockCoordinates3} {G H : SimpleGraph V}

theorem walkSum_mapLe (ω : V → V → Bit) (h : G ≤ H) {u v : V} (p : G.Walk u v) :
    walkSum ω (p.mapLe h) = walkSum ω p := by
  induction p with
  | nil => rfl
  | cons _ _ ih => exact congrArg (_ + ·) ih

theorem exists_nonzero_edge (ω : V → V → Bit) {u v : V} (p : G.Walk u v)
    (hp : walkSum ω p ≠ 0) :
    ∃ x y, G.Reachable u x ∧ G.Adj x y ∧ ω x y ≠ 0 := by
  induction p with
  | nil => exact (hp rfl).elim
  | @cons u v w ha p ih =>
    by_cases he : ω u v = 0
    · obtain ⟨x,y,hx,hy,hh⟩ := ih (by simpa only [walkSum_cons, he, zero_add] using hp)
      exact ⟨x,y,ha.reachable.trans hx,hy,hh⟩
    · exact ⟨u,v,.refl _,ha,he⟩
end VariableWL.Markers

namespace VariableWL.Blocks
open Subdivision
variable {m r n : ℕ} {P : Type uBlockCoordinates4} {E : Type uBlockCoordinates5} (J : ProductImages.Instance m r P E)

def anchor : RawBlock m r n P E → Corner m r n P E
  | .inl h => end0 J (.inl h)
  | .inr s => end0 J (.inl (squareLeft J s))

theorem readout_reachable (hr : 2 ≤ r) (hn : 0 < n) (U : Set (Block (n := n) J))
    {b : Block (n := n) J} (hb : b ∈ U) {a : Readout m r n P E}
    (ha : HasReadout J b.val a) :
    (diagram J hr hn U).Reachable (anchor J b.val) (end0 J a) ∧
      (diagram J hr hn U).Reachable (anchor J b.val) (end1 J a) := by
  obtain ⟨b,hb'⟩ := b
  cases b with
  | inl h =>
    cases ha
    exact ⟨.refl _, (readout_adj J hr hn U hb rfl).reachable⟩
  | inr s =>
    have hL := (readout_adj J hr hn U hb (Or.inl rfl)).reachable
    have hR := (readout_adj J hr hn U hb (Or.inr (Or.inl rfl))).reachable
    have hB := (readout_adj J hr hn U hb (Or.inr (Or.inr (Or.inl rfl)))).reachable
    have hT := (readout_adj J hr hn U hb (Or.inr (Or.inr (Or.inr rfl)))).reachable
    rcases ha with rfl | rfl | rfl | rfl
    · exact ⟨.refl _,hL⟩
    · exact ⟨hB,hB.trans hR⟩
    · exact ⟨.refl _,hB⟩
    · exact ⟨hL,hL.trans hT⟩

theorem wrapping_mono (hr : 3 ≤ r) (hn : 0 < n)
    {U V : Set (Block (n := n) J)} (h : U ⊆ V) {marked : Fin r}
    (hw : (rowDiagram J hr hn U).Wraps marked) : (rowDiagram J hr hn V).Wraps marked := by
  obtain ⟨v,p,hp⟩ := hw
  exact ⟨v,p.mapLe (diagram_mono J (by omega) hn h),
    (Markers.walkSum_mapLe _ _ p).trans hp⟩

theorem wrapping_connected (hr : 3 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J)) {marked : Fin r}
    (hw : (rowDiagram J hr hn U).Wraps marked) (hc : U.card = r) :
    ∃ root : Corner m r n P E, ∀ b ∈ U,
      (diagram J (by omega) hn U).Reachable root (anchor J b.val) := by
  classical
  have : NeZero r := ⟨by omega⟩
  have hi := wrapping_row_injective J hr hn U hw hc
  obtain ⟨root,p,hp⟩ := hw
  refine ⟨root, ?_⟩
  intro b hb
  have hpar := (rowDiagram J hr hn U).row_parity_all
    Wrapping.RowDiagram.finRotate_orbit p (row b.val) marked
  obtain ⟨u,v,hu,hv,he⟩ := Markers.exists_nonzero_edge _ p
    (show Markers.walkSum ((rowDiagram J hr hn U).rowWeight (row b.val)) p ≠ 0 by
      rw [hpar,hp]; exact one_ne_zero)
  have htag : horizontalTag u v = some (row b.val) := by
    by_contra hh
    exact he (if_neg hh)
  obtain ⟨b',hb',a,ha,heq⟩ := hv
  have haRow : row b'.val = row b.val := by
    have ht : Sum.elim (fun h => some h.row) (fun _ => none) a = some (row b.val) := by
      rcases heq with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩
      · have hh := (horizontalTag_readout J hr a).1.symm.trans htag
        cases a <;> exact hh
      · have hh := (horizontalTag_readout J hr a).2.symm.trans htag
        cases a <;> exact hh
    cases a with
    | inr a => cases ht
    | inl a => exact (hasReadout_horizontal_row J ha).symm.trans (Option.some.inj ht)
  have hbb : b' = b := hi hb' hb haRow
  subst b'
  obtain ⟨h0,h1⟩ := readout_reachable J (by omega) hn U hb ha
  rcases heq with ⟨rfl,_⟩ | ⟨rfl,_⟩
  · exact hu.trans h0.symm
  · exact hu.trans h1.symm
end VariableWL.Blocks

namespace VariableWL.ProductImages.Instance
open VariableWL.Affine Subdivision
variable {m r n : ℕ} {P : Type uBlockCoordinates6} {E : Type uBlockCoordinates7} (J : ProductImages.Instance m r P E)

theorem lift_scalar_to_cut (hn : 0 < n) (Q : J.Witness)
    (S : Set (Link E n)) (cut : E → Fin (n+1))
    (hc : ∀ l ∈ S, l.2 ≠ cut l.1) (q : E × Fin n)
    (a : Address m r) (ha : J.Allowed q.1 a) {b : Bit}
    (hb : b ∈ Q.wireValues q.1 a) :
    ∃ g : J.Shifts n, J.ShiftSystem S g ∧ g.2 q = b ∧
      ∀ p, (supportGraph hn J.source J.target S).Reachable (.inr q) (.inl p) →
        g.1 p ∈ Q.values p (fun i => J.alignment cut (.inr q) i (a i)) := by
  classical
  by_cases hj : q.2.val < (cut q.1).val
  · obtain ⟨v,hv,hvb⟩ := Q.lift_left q.1 a hb
    let values : ∀ p, Vec (J.dimension p) := Function.update (fun _ => 0) (J.source q.1) v
    have hval : values (J.source q.1) = v := Function.update_self _ _ _
    refine ⟨J.cutShifts cut values, fun l hl => J.cutShifts_equation hn cut values l (hc l hl), ?_, ?_⟩
    · simpa only [cutShifts, if_pos hj, hval] using hvb
    · intro p hp
      have ho := owner_walk hn J.source J.target S cut hc hp.some
      have he : J.source q.1 = p := by simpa only [owner, if_pos hj] using ho
      subst p
      simpa only [cutShifts, hval, alignment, if_pos hj, Equiv.refl_apply] using hv
  · obtain ⟨v,hv,hvb⟩ := Q.lift_right q.1 a ha hb
    let values : ∀ p, Vec (J.dimension p) := Function.update (fun _ => 0) (J.target q.1) v
    have hval : values (J.target q.1) = v := Function.update_self _ _ _
    refine ⟨J.cutShifts cut values, fun l hl => J.cutShifts_equation hn cut values l (hc l hl), ?_, ?_⟩
    · simpa only [cutShifts, if_neg hj, hval] using hvb
    · intro p hp
      have ho := owner_walk hn J.source J.target S cut hc hp.some
      have he : J.target q.1 = p := by simpa only [owner, if_neg hj] using ho
      subst p
      have had : (fun i => J.alignment cut (.inr q) i (a i)) = J.mapAddress q.1 a := by
        funext i
        simp only [alignment, if_neg hj, mapAddress, J.ambient_on_domain _ _ _ (ha i)]
      simpa only [cutShifts, hval, had] using hv

theorem agree_from_real [DecidableEq E] (hn : 0 < n)
    (S : Finset (Link E n)) (hS : S.card < n+1) {h g : J.Shifts n}
    (hh : J.ShiftSystem S h) (hg : J.ShiftSystem S g) (p : P)
    (he : h.1 p = g.1 p) {v : Vertex P E n}
    (hv : (supportGraph hn J.source J.target S).Reachable (.inl p) v) :
    J.AgreeAt h g v := by
  apply J.agree_reachable hn S hh hg (.inl p) he _ hv
  intro p' hp'
  have hpp := at_most_one_real hn J.source J.target S hS hp'
  subst p'
  exact he

theorem agree_from_internal (hn : 0 < n) (S : Set (Link E n))
    {h g : J.Shifts n} (hh : J.ShiftSystem S h) (hg : J.ShiftSystem S g)
    (q : E × Fin n) (he : h.2 q = g.2 q)
    (hnr : ∀ p, ¬ (supportGraph hn J.source J.target S).Reachable (.inr q) (.inl p))
    {v : Vertex P E n} (hv : (supportGraph hn J.source J.target S).Reachable (.inr q) v) :
    J.AgreeAt h g v :=
  J.agree_reachable hn S hh hg (.inr q) he (fun p hp => (hnr p hp).elim) hv
end VariableWL.ProductImages.Instance

namespace VariableWL.Blocks
open Subdivision
variable {m r n : ℕ} {P : Type uBlockCoordinates8} {E : Type uBlockCoordinates9} (J : ProductImages.Instance m r P E)

noncomputable def componentBlocks (hr : 2 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J)) (c : (diagram J hr hn U).ConnectedComponent) :
    Finset (Block (n := n) J) := by
  classical
  exact U.filter fun b => (diagram J hr hn U).connectedComponentMk (anchor J b.val) = c

theorem mem_componentBlocks (hr : 2 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J)) (c : (diagram J hr hn U).ConnectedComponent)
    (b : Block (n := n) J) : b ∈ componentBlocks J hr hn U c ↔
      b ∈ U ∧ (diagram J hr hn U).connectedComponentMk (anchor J b.val) = c := by
  classical
  exact Finset.mem_filter

theorem componentBlocks_subset (hr : 2 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J)) (c : (diagram J hr hn U).ConnectedComponent) :
    componentBlocks J hr hn U c ⊆ U := by
  intro b hb
  exact ((mem_componentBlocks J hr hn U c b).mp hb).1

theorem readout_component (hr : 2 ≤ r) (hn : 0 < n) (U : Set (Block (n := n) J))
    {b : Block (n := n) J} (hb : b ∈ U) {a : Readout m r n P E}
    (ha : HasReadout J b.val a) :
    (diagram J hr hn U).connectedComponentMk (anchor J b.val) =
      (diagram J hr hn U).connectedComponentMk (end0 J a) ∧
    (diagram J hr hn U).connectedComponentMk (anchor J b.val) =
      (diagram J hr hn U).connectedComponentMk (end1 J a) := by
  obtain ⟨h0,h1⟩ := readout_reachable J hr hn U hb ha
  exact ⟨SimpleGraph.ConnectedComponent.sound h0, SimpleGraph.ConnectedComponent.sound h1⟩

theorem component_adj (hr : 2 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J)) (c : (diagram J hr hn U).ConnectedComponent)
    {v w : Corner m r n P E} (hv : (diagram J hr hn U).connectedComponentMk v = c)
    (ha : (diagram J hr hn U).Adj v w) :
    (diagram J hr hn (componentBlocks J hr hn U c)).Adj v w := by
  obtain ⟨b,hb,a,hb',he⟩ := ha
  have hc : (diagram J hr hn U).connectedComponentMk (anchor J b.val) = c := by
    obtain ⟨h0,h1⟩ := readout_component J hr hn U hb hb'
    rcases he with ⟨rfl,_⟩ | ⟨rfl,_⟩
    · exact h0.trans hv
    · exact h1.trans hv
  exact ⟨b, (mem_componentBlocks J hr hn U c b).mpr ⟨hb,hc⟩,a,hb',he⟩

theorem component_reachable (hr : 2 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J)) (c : (diagram J hr hn U).ConnectedComponent)
    {v w : Corner m r n P E} (hv : (diagram J hr hn U).connectedComponentMk v = c)
    (hw : (diagram J hr hn U).Reachable v w) :
    (diagram J hr hn (componentBlocks J hr hn U c)).Reachable v w := by
  obtain ⟨p⟩ := hw
  induction p with
  | nil => exact .refl _
  | cons ha p ih =>
    have hv' := (SimpleGraph.ConnectedComponent.sound ha.reachable).symm.trans hv
    exact (component_adj J hr hn U c hv ha).reachable.trans (ih hv')

theorem component_anchors_connected (hr : 2 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J)) (c : (diagram J hr hn U).ConnectedComponent)
    {b b' : Block (n := n) J} (hb : b ∈ componentBlocks J hr hn U c)
    (hb' : b' ∈ componentBlocks J hr hn U c) :
    (diagram J hr hn (componentBlocks J hr hn U c)).Reachable
      (anchor J b.val) (anchor J b'.val) := by
  have hb0 := ((mem_componentBlocks J hr hn U c b).mp hb).2
  have hb1 := ((mem_componentBlocks J hr hn U c b').mp hb').2
  exact component_reachable J hr hn U c hb0 (SimpleGraph.ConnectedComponent.exact (hb0.trans hb1.symm))

end VariableWL.Blocks

namespace VariableWL.Subdivision
variable {P : Type uBlockCoordinates10} {E : Type uBlockCoordinates11} {A : Type uBlockCoordinates12} {n : ℕ}

theorem internal_reachable_invariant (hn : 0 < n) (src dst : E → P)
    (S : Set (Link E n)) (F : E × Fin n → A)
    (hF : ∀ q q', (supportGraph hn src dst S).Adj (.inr q) (.inr q') → F q = F q')
    (q : E × Fin n)
    (hnr : ∀ p, ¬ (supportGraph hn src dst S).Reachable (.inr q) (.inl p))
    {q' : E × Fin n} (hr : (supportGraph hn src dst S).Reachable (.inr q) (.inr q')) :
    F q = F q' := by
  have aux {u v : Vertex P E n} (p : (supportGraph hn src dst S).Walk u v)
      (hu : ∃ qu, u = .inr qu ∧ F q = F qu)
      (hreach : (supportGraph hn src dst S).Reachable (.inr q) u) :
      ∃ qv, v = .inr qv ∧ F q = F qv := by
    induction p with
    | nil => exact hu
    | @cons u v w ha p ih =>
      obtain ⟨qu,rfl,hu⟩ := hu
      have hv := hreach.trans ha.reachable
      obtain ⟨qv,rfl⟩ : ∃ qv, v = .inr qv := by
        cases v with
        | inl real => exact (hnr real hv).elim
        | inr qv => exact ⟨qv,rfl⟩
      exact ih ⟨qv,rfl,hu.trans (hF qu qv ha)⟩ hv
  obtain ⟨qv,he,hh⟩ := aux hr.some ⟨q,rfl,rfl⟩ (.refl _)
  cases Sum.inr.inj he
  exact hh
end VariableWL.Subdivision

namespace VariableWL.ProductImages.Instance
open Subdivision
variable {m r n : ℕ} {P : Type uBlockCoordinates13} {E : Type uBlockCoordinates14} (J : ProductImages.Instance m r P E)

theorem alignment_internal_adj (hn : 0 < n) (S : Set (Link E n))
    (cut : E → Fin (n+1)) (hc : ∀ l ∈ S, l.2 ≠ cut l.1)
    {q q' : E × Fin n} (ha : (supportGraph hn J.source J.target S).Adj (.inr q) (.inr q'))
    (i : Fin r) : J.alignment cut (.inr q) i = J.alignment cut (.inr q') i := by
  obtain ⟨l,hl,⟨he,he'⟩ | ⟨he,he'⟩⟩ := ha
  · have hlast : l.2.val ≠ n := by
      intro h; simp only [right, dif_pos h] at he'; cases he'
    have h := J.alignment_link hn cut l (hc l hl) i
    simpa only [← he, ← he', transport, if_neg hlast,
      show Equiv.refl (Fin m) = (1 : Equiv.Perm (Fin m)) from rfl, mul_one] using h
  · have hlast : l.2.val ≠ n := by
      intro h; simp only [right, dif_pos h] at he; cases he
    have h := J.alignment_link hn cut l (hc l hl) i
    simpa only [← he, ← he', transport, if_neg hlast,
      show Equiv.refl (Fin m) = (1 : Equiv.Perm (Fin m)) from rfl, mul_one] using h.symm

theorem alignment_internal_reachable (hn : 0 < n) (S : Set (Link E n))
    (cut : E → Fin (n+1)) (hc : ∀ l ∈ S, l.2 ≠ cut l.1) (q : E × Fin n)
    (hnr : ∀ p, ¬ (supportGraph hn J.source J.target S).Reachable (.inr q) (.inl p))
    {q' : E × Fin n} (hr : (supportGraph hn J.source J.target S).Reachable (.inr q) (.inr q'))
    (i : Fin r) : J.alignment cut (.inr q) i = J.alignment cut (.inr q') i :=
  internal_reachable_invariant hn J.source J.target S (fun q => J.alignment cut (.inr q) i)
    (fun _ _ h => J.alignment_internal_adj hn S cut hc h i) q hnr hr
end VariableWL.ProductImages.Instance

namespace VariableWL.Blocks
open Subdivision
variable {m r n : ℕ} {P : Type uBlockCoordinates15} {E : Type uBlockCoordinates16} (J : ProductImages.Instance m r P E)

noncomputable def typesOf : RawBlock m r n P E → Finset (Vertex P E n) := by
  classical
  exact fun b => match b with
    | .inl h => {h.type}
    | .inr s => {left J.source s.link, right J.target s.link}

noncomputable def supportTypes (U : Finset (Block (n := n) J)) : Finset (Vertex P E n) := by
  classical
  exact U.biUnion fun b => typesOf J b.val

theorem type_has_horizontal (b : RawBlock m r n P E) {t : Vertex P E n}
    (ht : t ∈ typesOf J b) : ∃ h : Horizontal m r n P E,
      HasReadout J b (.inl h) ∧ h.type = t := by
  classical
  cases b with
  | inl h =>
    have he : t = h.type := by simpa only [typesOf, Finset.mem_singleton] using ht
    exact ⟨h,rfl,he.symm⟩
  | inr s =>
    simp only [typesOf, Finset.mem_insert, Finset.mem_singleton] at ht
    rcases ht with rfl | rfl
    · exact ⟨squareLeft J s,Or.inl rfl,rfl⟩
    · exact ⟨squareRight J s,Or.inr (Or.inl rfl),rfl⟩

theorem anchor_mem_types (b : RawBlock m r n P E) : (anchor J b).2.1 ∈ typesOf J b := by
  classical
  cases b <;> simp [anchor, typesOf, end0, squareLeft]

theorem supportLinks_endpoints (U : Finset (Block (n := n) J)) {l : Link E n}
    (hl : l ∈ supportLinks J U) :
    left J.source l ∈ supportTypes J U ∧ right J.target l ∈ supportTypes J U := by
  classical
  obtain ⟨b,hb,hl⟩ := Finset.mem_biUnion.mp hl
  obtain ⟨b,hvalid⟩ := b
  cases b with
  | inl h => simp [linksOf] at hl
  | inr s =>
    have he : l = s.link := by simpa only [linksOf, Finset.mem_singleton] using hl
    subst l
    constructor <;> apply Finset.mem_biUnion.mpr ⟨⟨.inr s,hvalid⟩,hb,?_⟩ <;> simp [typesOf]

theorem support_reachable_mem (hn : 0 < n) (U : Finset (Block (n := n) J))
    {v w : Vertex P E n} (hv : v ∈ supportTypes J U)
    (hw : (supportGraph hn J.source J.target (supportLinks J U)).Reachable v w) :
    w ∈ supportTypes J U := by
  obtain ⟨p⟩ := hw
  induction p with
  | nil => exact hv
  | cons ha p ih =>
    apply ih
    obtain ⟨l,hl,⟨_,rfl⟩ | ⟨_,rfl⟩⟩ := ha
    · exact (supportLinks_endpoints J U hl).2
    · exact (supportLinks_endpoints J U hl).1

theorem support_types_connected (hr : 2 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J))
    (hconn : ∀ b ∈ U, ∀ b' ∈ U, (diagram J hr hn U).Reachable (anchor J b.val) (anchor J b'.val))
    {v w : Vertex P E n} (hv : v ∈ supportTypes J U) (hw : w ∈ supportTypes J U) :
    (supportGraph hn J.source J.target (supportLinks J U)).Reachable v w := by
  classical
  obtain ⟨b,hb,hv⟩ := Finset.mem_biUnion.mp hv
  obtain ⟨b',hb',hw⟩ := Finset.mem_biUnion.mp hw
  obtain ⟨h,hh,rfl⟩ := type_has_horizontal J b.val hv
  obtain ⟨h',hh',rfl⟩ := type_has_horizontal J b'.val hw
  have h0 := (readout_reachable J hr hn U hb hh).1
  have h1 := (readout_reachable J hr hn U hb' hh').1
  exact projection_reachable J hr hn U ((h0.symm.trans (hconn b hb b' hb')).trans h1)

noncomputable def addressAt (cut : E → Fin (n+1)) (a : Fin r → (Fin m))
    (t : Vertex P E n) : Fin r → (Fin m) := fun i => (J.alignment cut t i).symm (a i)

def Recovers (cut : E → Fin (n+1)) (U : Finset (Block (n := n) J))
    (a : Fin r → (Fin m)) : Prop := ∀ b ∈ U,
    firstLabel J cut b.val = a (row b.val) ∧
      lastLabel J cut b.val = a (finRotate r (row b.val))

theorem anchor_label_allowed (b : Block (n := n) J) :
    (anchor J b.val).2.2 ∈ J.labels (anchor J b.val).2.1 (row b.val) := by
  obtain ⟨b,hb⟩ := b
  cases b with
  | inl h => exact hb.1
  | inr s => exact J.matches_left s.link s.row ⟨hb.1,rfl⟩

theorem firstLabel_anchor (cut : E → Fin (n+1)) (b : RawBlock m r n P E) :
    firstLabel J cut b = J.alignment cut (anchor J b).2.1 (row b) (anchor J b).2.2 := by
  cases b <;> rfl

end VariableWL.Blocks

namespace VariableWL.Blocks
open Subdivision
variable {m r n : ℕ} {P : Type uBlockCoordinates17} {E : Type uBlockCoordinates18} (J : ProductImages.Instance m r P E)

theorem recovers_unique (hr : 3 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J)) (cut : E → Fin (n+1))
    {marked : Fin r} (hw : (rowDiagram J hr hn U).Wraps marked)
    {a a' : Fin r → (Fin m)} (ha : Recovers J cut U a) (ha' : Recovers J cut U a') : a = a' := by
  classical
  have : NeZero r := ⟨by omega⟩
  funext i
  obtain ⟨b,hb,hi⟩ := Finset.mem_image.mp ((rowDiagram J hr hn U).covers_rows U
    (fun b => row b.val) (fun _ _ h _ hi => row_cover J hr hn U h hi)
    Wrapping.RowDiagram.finRotate_orbit hw i)
  rw [← hi, ← (ha b hb).1, (ha' b hb).1]

theorem wrapping_address_allowed (hr : 3 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J)) (cut : E → Fin (n+1))
    (hc : ∀ l ∈ supportLinks J U, l.2 ≠ cut l.1)
    {marked : Fin r} (hw : (rowDiagram J hr hn U).Wraps marked) (hcard : U.card = r)
    (q : E × Fin n) (hq : (.inr q : Vertex P E n) ∈ supportTypes J U)
    (hnr : ∀ p, (.inl p : Vertex P E n) ∉ supportTypes J U)
    {a : Fin r → (Fin m)} (ha : Recovers J cut U a) :
    J.Allowed q.1 (addressAt J cut a (.inr q)) := by
  classical
  have : NeZero r := ⟨by omega⟩
  obtain ⟨root,hroot⟩ := wrapping_connected J hr hn U hw hcard
  have hconn : ∀ b ∈ U, ∀ b' ∈ U,
      (diagram J (by omega) hn U).Reachable (anchor J b.val) (anchor J b'.val) :=
    fun b hb b' hb' => (hroot b hb).symm.trans (hroot b' hb')
  have hnr' : ∀ p, ¬ (supportGraph hn J.source J.target (supportLinks J U)).Reachable
      (.inr q) (.inl p) := fun p hp => hnr p (support_reachable_mem J hn U hq hp)
  intro i
  obtain ⟨b,hb,hi⟩ := Finset.mem_image.mp ((rowDiagram J hr hn U).covers_rows U
    (fun b => row b.val) (fun _ _ h _ hi => row_cover J hr hn U h hi)
    Wrapping.RowDiagram.finRotate_orbit hw i)
  have ht : (anchor J b.val).2.1 ∈ supportTypes J U :=
    Finset.mem_biUnion.mpr ⟨b,hb,anchor_mem_types J b.val⟩
  have hreach := support_types_connected J (by omega) hn U hconn hq ht
  obtain ⟨j,he⟩ := realFree_reachable_wire hn J.source J.target (supportLinks J U) q hnr' hreach
  have hal := J.alignment_internal_reachable hn (supportLinks J U) cut hc q hnr'
    (he ▸ hreach) i
  have hal' : J.alignment cut (.inr q) i = J.alignment cut (anchor J b.val).2.1 i := by
    simpa only [he] using hal
  have hlabel := anchor_label_allowed J b
  rw [hi, he] at hlabel
  change (J.alignment cut (.inr q) i).symm (a i) ∈ J.domain q.1 i
  rw [hal', ← hi, ← (ha b hb).1, firstLabel_anchor, Equiv.symm_apply_apply]
  simpa only [hi, ProductImages.Instance.labels] using hlabel

theorem permutation_coordinates {A : Type uBlockCoordinates19} (f g f' g' : Equiv.Perm A)
    (h : f * g⁻¹ = f' * g'⁻¹) (x : A) : f.symm (f' x) = g.symm (g' x) := by
  have he := congrArg (fun p : Equiv.Perm A => f⁻¹ * p * g') h
  have hfg : g⁻¹ * g' = f⁻¹ * f' := by simpa only [mul_assoc, inv_mul_cancel_left,
    inv_mul_cancel, mul_one] using he
  exact congrArg (fun e : Equiv.Perm A => e x) hfg.symm

theorem addressAt_cut_independent (hr : 3 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J)) (cut cut' : E → Fin (n+1))
    (hc : ∀ l ∈ supportLinks J U, l.2 ≠ cut l.1)
    (hc' : ∀ l ∈ supportLinks J U, l.2 ≠ cut' l.1)
    {marked : Fin r} (hw : (rowDiagram J hr hn U).Wraps marked)
    {a a' : Fin r → (Fin m)} (ha : Recovers J cut U a) (ha' : Recovers J cut' U a')
    (t : Vertex P E n)
    (hconn : ∀ b ∈ U, (supportGraph hn J.source J.target (supportLinks J U)).Reachable
      t (anchor J b.val).2.1) : addressAt J cut a t = addressAt J cut' a' t := by
  classical
  have : NeZero r := ⟨by omega⟩
  funext i
  obtain ⟨b,hb,hi⟩ := Finset.mem_image.mp ((rowDiagram J hr hn U).covers_rows U
    (fun b => row b.val) (fun _ _ h _ hi => row_cover J hr hn U h hi)
    Wrapping.RowDiagram.finRotate_orbit hw i)
  have hrel := J.relativeAlignment_reachable hn (supportLinks J U) cut cut' hc hc' (hconn b hb) i
  have hp := permutation_coordinates (J.alignment cut t i) (J.alignment cut' t i)
    (J.alignment cut (anchor J b.val).2.1 i) (J.alignment cut' (anchor J b.val).2.1 i)
    hrel (anchor J b.val).2.2
  change (J.alignment cut t i).symm (a i) = (J.alignment cut' t i).symm (a' i)
  rw [← hi, ← (ha b hb).1, ← (ha' b hb).1, firstLabel_anchor, firstLabel_anchor]
  simpa only [hi] using hp

theorem recovered_overlap (hr : 3 ≤ r) (hn : 0 < n)
    (U W W' : Finset (Block (n := n) J)) (cut : E → Fin (n+1))
    (hW : W ⊆ U) (hW' : W' ⊆ U) (hU : U.card ≤ r+1)
    (hcW : W.card = r) (hcW' : W'.card = r)
    {marked : Fin r} (hw : (rowDiagram J hr hn W).Wraps marked)
    {a a' : Fin r → (Fin m)} (ha : Recovers J cut W a) (ha' : Recovers J cut W' a') : a = a' := by
  classical
  apply Wrapping.overlap_address_unique (finRotate r) (Wrapping.finRotate_no_fixed (by omega))
    U W W' (fun b => row b.val) hW hW' (by simpa using hU)
    (by simpa using hcW) (by simpa using hcW')
    (wrapping_row_injective J hr hn W hw hcW) a a'
  intro b hb
  obtain ⟨hb,hb'⟩ := Finset.mem_inter.mp hb
  exact ⟨(ha b hb).1.symm.trans (ha' b hb').1, (ha b hb).2.symm.trans (ha' b hb').2⟩
end VariableWL.Blocks

namespace VariableWL.ProductImages.Instance
open VariableWL.Affine Subdivision
variable {m r n : ℕ} {P : Type uBlockCoordinates20} {E : Type uBlockCoordinates21} (J : ProductImages.Instance m r P E)

theorem scalar_image_of_real (hn : 0 < n) (Q : J.Witness)
    (S : Finset (Link E n)) (hS : S.card < n+1) (cut : E → Fin (n+1))
    (hc : ∀ l ∈ S, l.2 ≠ cut l.1) (h : J.Shifts n) (hh : J.ShiftSystem S h)
    (q : E × Fin n) (p : P)
    (hp : (supportGraph hn J.source J.target S).Reachable (.inr q) (.inl p))
    (a : Address m r) (ha : J.Allowed q.1 a)
    (hreal : h.1 p ∈ Q.values p (fun i => J.alignment cut (.inr q) i (a i))) :
    h.2 q ∈ Q.wireValues q.1 a := by
  classical
  have hg : J.ShiftSystem S (J.cutShifts cut h.1) := fun l hl =>
    J.cutShifts_equation hn cut h.1 l (hc l hl)
  have he := J.agree_from_real hn S hS hh hg p rfl hp.symm
  change h.2 q = (J.cutShifts cut h.1).2 q at he
  rw [he]
  have ho := owner_walk hn J.source J.target S cut hc hp.some
  by_cases hj : q.2.val < (cut q.1).val
  · have hpe : J.source q.1 = p := by simpa only [owner, if_pos hj] using ho
    subst p
    have hmem : h.1 (J.source q.1) ∈ Q.values (J.source q.1) a := by
      simpa only [alignment, if_pos hj, Equiv.refl_apply] using hreal
    exact ⟨h.1 (J.source q.1),hmem, by simp only [cutShifts, if_pos hj]⟩
  · have hpe : J.target q.1 = p := by simpa only [owner, if_neg hj] using ho
    subst p
    have had : (fun i => J.alignment cut (.inr q) i (a i)) = J.mapAddress q.1 a := by
      funext i
      simp only [alignment, if_neg hj, mapAddress, J.ambient_on_domain _ _ _ (ha i)]
    rw [had] at hreal
    rw [← Q.right_image q.1 a ha]
    exact ⟨h.1 (J.target q.1),hreal, by simp only [cutShifts, if_neg hj]⟩
end VariableWL.ProductImages.Instance

end ProjectionAudit


/- Adapted from BlockExtensions.lean. -/

namespace ProjectionAudit

universe uBlockExtensions1 uBlockExtensions2 uBlockExtensions3 uBlockExtensions4 uBlockExtensions5 uBlockExtensions6 uBlockExtensions7 uBlockExtensions8

namespace VariableWL.Blocks
open Subdivision ProductImages.Instance
variable {m r n : ℕ} {P : Type uBlockExtensions1} {E : Type uBlockExtensions2} (J : ProductImages.Instance m r P E)

def SupportConnected (hn : 0 < n) (C : Finset (Block (n := n) J)) : Prop :=
  ∀ t ∈ supportTypes J C, ∀ u ∈ supportTypes J C,
    (supportGraph hn J.source J.target (supportLinks J C)).Reachable t u

def NoReal (C : Finset (Block (n := n) J)) : Prop :=
  ∀ p, (.inl p : Vertex P E n) ∉ supportTypes J C

def Avoids (cut : E → Fin (n+1)) (C : Finset (Block (n := n) J)) : Prop :=
  ∀ l ∈ supportLinks J C, l.2 ≠ cut l.1

theorem supportLinks_mono {C D : Finset (Block (n := n) J)} (h : C ⊆ D) :
    supportLinks J C ⊆ supportLinks J D := by
  classical
  exact Finset.biUnion_subset_biUnion_of_subset_left _ h

theorem supportTypes_mono {C D : Finset (Block (n := n) J)} (h : C ⊆ D) :
    supportTypes J C ⊆ supportTypes J D := by
  classical
  exact Finset.biUnion_subset_biUnion_of_subset_left _ h

theorem avoids_mono {C D : Finset (Block (n := n) J)} (h : C ⊆ D)
    {cut : E → Fin (n+1)} (ha : Avoids J cut D) : Avoids J cut C :=
  fun l hl => ha l (supportLinks_mono J h hl)

theorem supportTypes_nonempty {C : Finset (Block (n := n) J)} (hC : C.Nonempty) :
    (supportTypes J C).Nonempty := by
  classical
  obtain ⟨b,hb⟩ := hC
  exact ⟨(anchor J b.val).2.1, Finset.mem_biUnion.mpr ⟨b,hb,anchor_mem_types J b.val⟩⟩

theorem support_noReal_reach (hn : 0 < n) (C : Finset (Block (n := n) J))
    (hnr : NoReal J C) {t : Vertex P E n} (ht : t ∈ supportTypes J C) :
    ∀ p, ¬ (supportGraph hn J.source J.target (supportLinks J C)).Reachable t (.inl p) :=
  fun p hp => hnr p (support_reachable_mem J hn C ht hp)

theorem component_support_connected (hr : 2 ≤ r) (hn : 0 < n)
    (U : Finset (Block (n := n) J)) (c : (diagram J hr hn U).ConnectedComponent) :
    SupportConnected J hn (componentBlocks J hr hn U c) := by
  intro t ht u hu
  exact support_types_connected J hr hn _
    (fun _ hb _ hb' => component_anchors_connected J hr hn U c hb hb') ht hu

theorem internal_same_address (hn : 0 < n) (C : Finset (Block (n := n) J))
    (hC : SupportConnected J hn C) (hnr : NoReal J C)
    (cut : E → Fin (n+1)) (hc : Avoids J cut C) (a : Address m r)
    {q q' : E × Fin n} (hq : Sum.inr q ∈ supportTypes J C)
    (hq' : Sum.inr q' ∈ supportTypes J C) :
    q.1 = q'.1 ∧ addressAt J cut a (.inr q) = addressAt J cut a (.inr q') := by
  have hp := hC _ hq _ hq'
  have hnq := support_noReal_reach J hn C hnr hq
  obtain ⟨j,he⟩ := realFree_reachable_wire hn J.source J.target (supportLinks J C) q hnq hp
  have heP : q' = (q.1,j) := Sum.inr.inj he
  have hqq := congrArg Prod.fst heP
  refine ⟨hqq.symm, ?_⟩
  funext i
  have hh := J.alignment_internal_reachable hn (supportLinks J C) cut hc q hnq
    (he ▸ hp) i
  have hh' : J.alignment cut (.inr q) i = J.alignment cut (.inr q') i := by
    simpa only [he] using hh
  simp only [addressAt, hh']

theorem wrapping_address_allowed_superset (hr : 3 ≤ r) (hn : 0 < n)
    (C W : Finset (Block (n := n) J)) (hW : W ⊆ C)
    (hC : SupportConnected J hn C) (hnr : NoReal J C)
    (cut : E → Fin (n+1)) (hc : Avoids J cut C)
    {marked : Fin r} (hw : (rowDiagram J hr hn W).Wraps marked) (hcard : W.card = r)
    {a : Address m r} (ha : Recovers J cut W a) {q : E × Fin n}
    (hq : Sum.inr q ∈ supportTypes J C) : J.Allowed q.1 (addressAt J cut a (.inr q)) := by
  have hne : W.Nonempty := Finset.card_pos.mp (by omega)
  obtain ⟨t,ht⟩ := supportTypes_nonempty J hne
  obtain ⟨q',rfl⟩ : ∃ q', t = Sum.inr q' := by
    cases t with
    | inl p => exact (hnr p (supportTypes_mono J hW ht)).elim
    | inr q' => exact ⟨q',rfl⟩
  have had := wrapping_address_allowed J hr hn W cut (avoids_mono J hW hc)
    hw hcard q' ht (fun p hp => hnr p (supportTypes_mono J hW hp)) ha
  obtain ⟨he,he'⟩ := internal_same_address J hn C hC hnr cut hc a hq
    (supportTypes_mono J hW ht)
  rw [he,he']
  exact had

def AddressCondition (Q : J.Witness) (cut : E → Fin (n+1))
    (C : Finset (Block (n := n) J)) (a : Address m r) (h : J.Shifts n) : Prop :=
  (∀ p, Sum.inl p ∈ supportTypes J C → h.1 p ∈ Q.values p (addressAt J cut a (.inl p))) ∧
  (NoReal J C → ∀ q, Sum.inr q ∈ supportTypes J C →
    h.2 q ∈ Q.wireValues q.1 (addressAt J cut a (.inr q)))

def Admissible (hr : 3 ≤ r) (hn : 0 < n) (marked : Fin r) (Q : J.Witness)
    (cut : E → Fin (n+1)) (C : Finset (Block (n := n) J)) (h : J.Shifts n) : Prop :=
  J.ShiftSystem (supportLinks J C) h ∧
  ∀ W ⊆ C, W.card = r → (rowDiagram J hr hn W).Wraps marked →
    ∀ a, Recovers J cut W a → AddressCondition J Q cut C a h

@[simp] theorem addressAt_real (cut : E → Fin (n+1)) (a : Address m r) (p : P) :
    addressAt J cut a (.inl p) = a := rfl

theorem admissible_of_one (hr : 3 ≤ r) (hn : 0 < n) (marked : Fin r) (Q : J.Witness)
    (cut : E → Fin (n+1)) (C W : Finset (Block (n := n) J)) (hC : C.card ≤ r+1)
    (hW : W ⊆ C) (hcard : W.card = r) (hw : (rowDiagram J hr hn W).Wraps marked)
    (a : Address m r) (ha : Recovers J cut W a) (h : J.Shifts n)
    (hs : J.ShiftSystem (supportLinks J C) h) (had : AddressCondition J Q cut C a h) :
    Admissible J hr hn marked Q cut C h := by
  refine ⟨hs, ?_⟩
  intro W' hW' hcW' hw' a' ha'
  have he := recovered_overlap J hr hn C W W' cut hW hW' hC hcard hcW' hw ha ha'
  subst a'
  exact had

theorem addressCondition_exists (hn : 0 < n) (Q : J.Witness)
    (C : Finset (Block (n := n) J)) (hC : SupportConnected J hn C)
    (cut : E → Fin (n+1)) (hc : Avoids J cut C) (a : Address m r) :
    ∃ h : J.Shifts n, J.ShiftSystem (supportLinks J C) h ∧ AddressCondition J Q cut C a h := by
  classical
  choose v hv using Q.nonempty
  let h := J.cutShifts cut (fun p => v p a)
  have hh : J.ShiftSystem (supportLinks J C) h :=
    fun l hl => J.cutShifts_equation hn cut _ l (hc l hl)
  by_cases hnr : NoReal J C
  · by_cases he : (supportTypes J C).Nonempty
    · obtain ⟨t,ht⟩ := he
      obtain ⟨q,rfl⟩ : ∃ q, t = Sum.inr q := by
        cases t with
        | inl p => exact (hnr p ht).elim
        | inr q => exact ⟨q,rfl⟩
      obtain ⟨b,hb⟩ := Q.wireValues_nonempty q.1 (addressAt J cut a (.inr q))
      obtain ⟨g,hg,hgb⟩ := J.exists_scalar_shift hn (supportLinks J C) (.inr q) b h hh
        (support_noReal_reach J hn C hnr ht)
      refine ⟨g,hg,⟨fun p hp => (hnr p hp).elim, fun _ q' hq' => ?_⟩⟩
      rw [hgb q' (hC _ ht _ hq')]
      obtain ⟨he,ha⟩ := internal_same_address J hn C hC hnr cut hc a ht hq'
      simpa only [he,ha] using hb
    · refine ⟨h,hh,⟨?_, fun _ q hq => (he ⟨.inr q,hq⟩).elim⟩⟩
      intro p hp
      exact (he ⟨.inl p,hp⟩).elim
  · refine ⟨h,hh,⟨?_,fun hh => (hnr hh).elim⟩⟩
    intro p _
    exact hv p a

theorem admissible_exists (hr : 3 ≤ r) (hn : 0 < n) (marked : Fin r) (Q : J.Witness)
    (C : Finset (Block (n := n) J)) (hC : SupportConnected J hn C) (hcard : C.card ≤ r+1)
    (cut : E → Fin (n+1)) (hc : Avoids J cut C) :
    ∃ h : J.Shifts n, Admissible J hr hn marked Q cut C h := by
  classical
  by_cases hw : ∃ W ⊆ C, W.card = r ∧ (rowDiagram J hr hn W).Wraps marked
  · obtain ⟨W,hW,hcW,hw⟩ := hw
    obtain ⟨a,ha⟩ := recovered_address J hr hn W cut (avoids_mono J hW hc) hw hcW
    obtain ⟨h,hs,had⟩ := addressCondition_exists J hn Q C hC cut hc a
    exact ⟨h, admissible_of_one J hr hn marked Q cut C W hcard hW hcW hw a ha h hs had⟩
  · refine ⟨J.cutShifts cut (fun _ => 0), ⟨?_,?_⟩⟩
    · exact fun l hl => J.cutShifts_equation hn cut _ l (hc l hl)
    · intro W hW hcW hwW
      exact (hw ⟨W,hW,hcW,hwW⟩).elim
end VariableWL.Blocks

namespace VariableWL.Blocks
open Subdivision ProductImages.Instance
variable {m r n : ℕ} {P : Type uBlockExtensions3} {E : Type uBlockExtensions4} (J : ProductImages.Instance m r P E)

theorem addressAt_cut_independent_superset (hr : 3 ≤ r) (hn : 0 < n)
    (C W : Finset (Block (n := n) J)) (hW : W ⊆ C) (hC : SupportConnected J hn C)
    (cut cut' : E → Fin (n+1)) (hc : Avoids J cut C) (hc' : Avoids J cut' C)
    {marked : Fin r} (hw : (rowDiagram J hr hn W).Wraps marked)
    {a a' : Address m r} (ha : Recovers J cut W a) (ha' : Recovers J cut' W a')
    {t : Vertex P E n} (ht : t ∈ supportTypes J C) :
    addressAt J cut a t = addressAt J cut' a' t := by
  classical
  have : NeZero r := ⟨by omega⟩
  funext i
  obtain ⟨b,hb,hi⟩ := Finset.mem_image.mp ((rowDiagram J hr hn W).covers_rows W
    (fun b => row b.val) (fun _ _ h _ hi => row_cover J hr hn W h hi)
    Wrapping.RowDiagram.finRotate_orbit hw i)
  have ht' : (anchor J b.val).2.1 ∈ supportTypes J C :=
    Finset.mem_biUnion.mpr ⟨b,hW hb,anchor_mem_types J b.val⟩
  have hrel := J.relativeAlignment_reachable hn (supportLinks J C) cut cut' hc hc'
    (hC _ ht _ ht') i
  have hp := permutation_coordinates (J.alignment cut t i) (J.alignment cut' t i)
    (J.alignment cut (anchor J b.val).2.1 i) (J.alignment cut' (anchor J b.val).2.1 i)
    hrel (anchor J b.val).2.2
  change (J.alignment cut t i).symm (a i) = (J.alignment cut' t i).symm (a' i)
  rw [← hi, ← (ha b hb).1, ← (ha' b hb).1, firstLabel_anchor, firstLabel_anchor]
  simpa only [hi] using hp

theorem admissible_cut_change (hr : 3 ≤ r) (hn : 0 < n) (marked : Fin r) (Q : J.Witness)
    (C : Finset (Block (n := n) J)) (hC : SupportConnected J hn C)
    (cut cut' : E → Fin (n+1)) (hc : Avoids J cut C) (hc' : Avoids J cut' C)
    {h : J.Shifts n} (hh : Admissible J hr hn marked Q cut C h) :
    Admissible J hr hn marked Q cut' C h := by
  refine ⟨hh.1, ?_⟩
  intro W hW hcW hw a' ha'
  obtain ⟨a,ha⟩ := recovered_address J hr hn W cut (avoids_mono J hW hc) hw hcW
  obtain ⟨hreal,hscalar⟩ := hh.2 W hW hcW hw a ha
  refine ⟨?_,?_⟩
  · intro p hp
    rw [← addressAt_cut_independent_superset J hr hn C W hW hC cut cut' hc hc' hw ha ha' hp]
    exact hreal p hp
  · intro hnr q hq
    rw [← addressAt_cut_independent_superset J hr hn C W hW hC cut cut' hc hc' hw ha ha' hq]
    exact hscalar hnr q hq

theorem admissible_restrict (hr : 3 ≤ r) (hn : 0 < n) (marked : Fin r) (Q : J.Witness)
    (C D : Finset (Block (n := n) J)) (hD : D ⊆ C)
    (hC : SupportConnected J hn C) (hDc : SupportConnected J hn D)
    (hsize : (supportLinks J C).card < n+1)
    (cut : E → Fin (n+1)) (hc : Avoids J cut C)
    {h : J.Shifts n} (hh : Admissible J hr hn marked Q cut C h) :
    Admissible J hr hn marked Q cut D h := by
  classical
  refine ⟨fun l hl => hh.1 l (supportLinks_mono J hD hl), ?_⟩
  intro W hW hcW hw a ha
  obtain ⟨hreal,hscalar⟩ := hh.2 W (hW.trans hD) hcW hw a ha
  refine ⟨fun p hp => hreal p (supportTypes_mono J hD hp), ?_⟩
  intro hnrD q hq
  by_cases hnr : NoReal J C
  · exact hscalar hnr q (supportTypes_mono J hD hq)
  · have hex : ∃ p, Sum.inl p ∈ supportTypes J C := by
      simpa only [NoReal, not_forall, not_not] using hnr
    obtain ⟨p,hp⟩ := hex
    have had := wrapping_address_allowed_superset J hr hn D W hW hDc hnrD cut
      (avoids_mono J hD hc) hw hcW ha hq
    apply J.scalar_image_of_real hn Q (supportLinks J C) hsize cut hc h hh.1 q p
      (hC _ (supportTypes_mono J hD hq) _ hp) (addressAt J cut a (.inr q)) had
    simpa only [addressAt, Equiv.apply_symm_apply, addressAt_real] using hreal p hp
end VariableWL.Blocks

namespace VariableWL.Blocks
open Subdivision ProductImages.Instance
variable {m r n : ℕ} {P : Type uBlockExtensions5} {E : Type uBlockExtensions6} (J : ProductImages.Instance m r P E)

theorem admissible_lift (hr : 3 ≤ r) (hn : 0 < n) (marked : Fin r) (Q : J.Witness)
    (C D : Finset (Block (n := n) J)) (hD : D ⊆ C)
    (hC : SupportConnected J hn C) (hDc : SupportConnected J hn D)
    (hcard : C.card ≤ r+1) (hsize : (supportLinks J C).card < n+1)
    (hcardD : D.card = r) (hw : (rowDiagram J hr hn D).Wraps marked)
    (cut : E → Fin (n+1)) (hc : Avoids J cut C)
    {h : J.Shifts n} (hh : Admissible J hr hn marked Q cut D h) :
    ∃ g : J.Shifts n, Admissible J hr hn marked Q cut C g ∧
      ∀ t ∈ supportTypes J D, J.AgreeAt h g t := by
  classical
  obtain ⟨a,ha⟩ := recovered_address J hr hn D cut (avoids_mono J hD hc) hw hcardD
  have had := hh.2 D (Finset.Subset.refl _) hcardD hw a ha
  have hsizeD : (supportLinks J D).card < n+1 :=
    lt_of_le_of_lt (Finset.card_le_card (supportLinks_mono J hD)) hsize
  by_cases hnrD : NoReal J D
  · obtain ⟨t,ht⟩ := supportTypes_nonempty J
      (show D.Nonempty from Finset.card_pos.mp (by omega))
    obtain ⟨q,rfl⟩ : ∃ q, t = Sum.inr q := by
      cases t with
      | inl p => exact (hnrD p ht).elim
      | inr q => exact ⟨q,rfl⟩
    have hqa : J.Allowed q.1 (addressAt J cut a (.inr q)) :=
      wrapping_address_allowed_superset J hr hn D D (Finset.Subset.refl _) hDc hnrD
        cut (avoids_mono J hD hc) hw hcardD ha ht
    obtain ⟨g,hg,hgq,hgreal⟩ := J.lift_scalar_to_cut hn Q (supportLinks J C) cut hc q
      (addressAt J cut a (.inr q)) hqa (had.2 hnrD q ht)
    have hcond : AddressCondition J Q cut C a g := by
      refine ⟨?_,?_⟩
      · intro p hp
        simpa only [addressAt, Equiv.apply_symm_apply, addressAt_real] using
          hgreal p (hC _ (supportTypes_mono J hD ht) _ hp)
      · intro hnrC q' hq'
        have hqC := supportTypes_mono J hD ht
        have he := J.scalar_constant hn (supportLinks J C) g hg q
          (support_noReal_reach J hn C hnrC hqC) (hC _ hqC _ hq')
        rw [← he,hgq]
        obtain ⟨hwire,haddr⟩ := internal_same_address J hn C hC hnrC cut hc a hqC hq'
        simpa only [hwire,haddr] using had.2 hnrD q ht
    refine ⟨g,admissible_of_one J hr hn marked Q cut C D hcard hD hcardD hw a ha g hg hcond,?_⟩
    intro t ht'
    exact J.agree_from_internal hn (supportLinks J D) hh.1
      (fun l hl => hg l (supportLinks_mono J hD hl)) q hgq.symm
      (support_noReal_reach J hn D hnrD ht) (hDc _ ht _ ht')
  · obtain ⟨p,hp⟩ : ∃ p, Sum.inl p ∈ supportTypes J D := by
      simpa only [NoReal, not_forall, not_not] using hnrD
    let g := J.cutShifts cut h.1
    have hg : J.ShiftSystem (supportLinks J C) g :=
      fun l hl => J.cutShifts_equation hn cut h.1 l (hc l hl)
    have hcond : AddressCondition J Q cut C a g := by
      refine ⟨?_,?_⟩
      · intro p' hp'
        have hpp := at_most_one_real hn J.source J.target (supportLinks J C) hsize
          (hC _ (supportTypes_mono J hD hp) _ hp')
        subst p'
        exact had.1 p hp
      · intro hnrC
        exact (hnrC p (supportTypes_mono J hD hp)).elim
    refine ⟨g,admissible_of_one J hr hn marked Q cut C D hcard hD hcardD hw a ha g hg hcond,?_⟩
    intro t ht
    exact J.agree_from_real hn (supportLinks J D) hsizeD hh.1
      (fun l hl => hg l (supportLinks_mono J hD hl)) p rfl (hDc _ hp _ ht)
end VariableWL.Blocks

namespace VariableWL.Blocks
open Subdivision ProductImages.Instance
variable {m r n : ℕ} {P : Type uBlockExtensions7} {E : Type uBlockExtensions8} (J : ProductImages.Instance m r P E)

def componentMap (hr : 2 ≤ r) (hn : 0 < n)
    {V U : Finset (Block (n := n) J)} (h : V ⊆ U) :
    (diagram J hr hn V).ConnectedComponent → (diagram J hr hn U).ConnectedComponent :=
  SimpleGraph.ConnectedComponent.map (SimpleGraph.Hom.ofLE (diagram_mono J hr hn h))

@[simp] theorem componentMap_mk (hr : 2 ≤ r) (hn : 0 < n)
    {V U : Finset (Block (n := n) J)} (h : V ⊆ U) (v : Corner m r n P E) :
    componentMap J hr hn h ((diagram J hr hn V).connectedComponentMk v) =
      (diagram J hr hn U).connectedComponentMk v := rfl

theorem componentBlocks_map_subset (hr : 2 ≤ r) (hn : 0 < n)
    {V U : Finset (Block (n := n) J)} (h : V ⊆ U)
    (d : (diagram J hr hn V).ConnectedComponent) :
    componentBlocks J hr hn V d ⊆
      componentBlocks J hr hn U (componentMap J hr hn h d) := by
  intro b hb
  obtain ⟨hb,he⟩ := (mem_componentBlocks J hr hn V d b).mp hb
  apply (mem_componentBlocks J hr hn U _ b).mpr
  exact ⟨h hb, (congrArg (componentMap J hr hn h) he)⟩

theorem wrapping_component_all (hr : 3 ≤ r) (hn : 0 < n)
    (V : Finset (Block (n := n) J)) (hV : V.card ≤ r) (marked : Fin r)
    (d : (diagram J (by omega) hn V).ConnectedComponent)
    (hw : (rowDiagram J hr hn (componentBlocks J (by omega) hn V d)).Wraps marked) :
    componentBlocks J (by omega) hn V d = V ∧ V.card = r := by
  have hsub := componentBlocks_subset J (by omega) hn V d
  have hge := wrapping_card_ge J hr hn _ hw
  have hle := Finset.card_le_card hsub
  exact ⟨Finset.eq_of_subset_of_card_le hsub (by omega), by omega⟩

theorem wrapping_component_unique (hr : 3 ≤ r) (hn : 0 < n)
    (V : Finset (Block (n := n) J)) (hV : V.card ≤ r) (marked : Fin r)
    {d d' : (diagram J (by omega) hn V).ConnectedComponent}
    (hw : (rowDiagram J hr hn (componentBlocks J (by omega) hn V d)).Wraps marked)
    (hw' : (rowDiagram J hr hn (componentBlocks J (by omega) hn V d')).Wraps marked) : d = d' := by
  obtain ⟨he,hc⟩ := wrapping_component_all J hr hn V hV marked d hw
  obtain ⟨he',_⟩ := wrapping_component_all J hr hn V hV marked d' hw'
  obtain ⟨b,hb⟩ := Finset.card_pos.mp (show 0 < V.card by omega)
  have hbd : b ∈ componentBlocks J (by omega) hn V d := (Finset.ext_iff.mp he b).mpr hb
  have hbd' : b ∈ componentBlocks J (by omega) hn V d' := (Finset.ext_iff.mp he' b).mpr hb
  exact ((mem_componentBlocks J (by omega) hn V d b).mp hbd).2.symm.trans
    ((mem_componentBlocks J (by omega) hn V d' b).mp hbd').2

theorem vectorShift_agree {h g : J.Shifts n} {t : Vertex P E n}
    (he : J.AgreeAt h g t) : vectorShift J h t = vectorShift J g t := by
  cases t with
  | inl p => exact he
  | inr q => exact congrArg (fun b : Affine.Bit => fun _ : Fin 1 => b) he

theorem potentialValues_shift_agree (marked : Fin r) (h g : J.Shifts n)
    (M : Potentials (n := n) J) (a : Readout m r n P E)
    (ha : J.AgreeAt h g (end0 J a).2.1) :
    potentialValues J marked h M a = potentialValues J marked g M a := by
  cases a with
  | inl x =>
    change J.AgreeAt h g x.type at ha
    simp only [potentialValues, vectorShift_agree J ha]
  | inr _ => rfl

theorem potentialValues_potentials_agree (marked : Fin r) (h : J.Shifts n)
    (M N : Potentials (n := n) J) (a : Readout m r n P E)
    (he0 : M (end0 J a) = N (end0 J a)) (he1 : M (end1 J a) = N (end1 J a)) :
    potentialValues J marked h M a = potentialValues J marked h N a := by
  cases a with
  | inl x => simp only [potentialValues, end0, end1] at he0 he1 ⊢; rw [he0,he1]
  | inr y => simp only [potentialValues, end0, end1] at he0 he1 ⊢; rw [he0,he1]

theorem readout_type_mem {b : RawBlock m r n P E} {a : Readout m r n P E}
    (ha : HasReadout J b a) : (end0 J a).2.1 ∈ typesOf J b := by
  classical
  cases b with
  | inl h => cases ha; simp [typesOf, end0]
  | inr s =>
    rcases ha with rfl | rfl | rfl | rfl <;>
      simp [typesOf, end0, squareLeft, squareRight, squareBottom, squareTop]

abbrev ReadoutValues := ∀ a : Readout m r n P E, ReadoutValue J a

def OffsetFamily (hr : 3 ≤ r) (hn : 0 < n) (marked : Fin r) (Q : J.Witness)
    (U : Finset (Block (n := n) J)) (F : ReadoutValues (n := n) J) : Prop :=
  ∃ cut : E → Fin (n+1), Avoids J cut U ∧
  ∃ h : (diagram J (by omega) hn U).ConnectedComponent → J.Shifts n,
  ∃ M : Potentials (n := n) J,
    (∀ c, Admissible J hr hn marked Q cut (componentBlocks J (by omega) hn U c) (h c)) ∧
    ∀ b ∈ U, ∀ a, HasReadout J b.val a →
      F a = potentialValues J marked (h ((diagram J (by omega) hn U).connectedComponentMk
        (anchor J b.val))) M a

def representedValues (hr : 2 ≤ r) (hn : 0 < n) (marked : Fin r)
    (U : Finset (Block (n := n) J))
    (h : (diagram J hr hn U).ConnectedComponent → J.Shifts n)
    (M : Potentials (n := n) J) : ReadoutValues (n := n) J :=
  fun a => potentialValues J marked (h ((diagram J hr hn U).connectedComponentMk (end0 J a))) M a

theorem representedValues_on_block (hr : 2 ≤ r) (hn : 0 < n) (marked : Fin r)
    (U : Finset (Block (n := n) J))
    (h : (diagram J hr hn U).ConnectedComponent → J.Shifts n)
    (M : Potentials (n := n) J) {b : Block (n := n) J} (hb : b ∈ U)
    {a : Readout m r n P E} (ha : HasReadout J b.val a) :
    representedValues J hr hn marked U h M a =
      potentialValues J marked (h ((diagram J hr hn U).connectedComponentMk (anchor J b.val))) M a := by
  unfold representedValues
  rw [← (readout_component J hr hn U hb ha).1]

theorem offsetFamily_nonempty (hr : 3 ≤ r) (hn : 0 < n) (hlarge : r+1 < n+1)
    (marked : Fin r) (Q : J.Witness) (U : Finset (Block (n := n) J)) (hU : U.card ≤ r+1) :
    ∃ F : ReadoutValues (n := n) J, OffsetFamily J hr hn marked Q U F := by
  classical
  obtain ⟨cut,hcut⟩ := exists_unused_cut (supportLinks J U)
    (lt_of_le_of_lt ((supportLinks_card J U).trans hU) hlarge)
  have hc : Avoids J cut U := by
    intro l hl he
    exact hcut l.1 (by simpa only [← he,Prod.eta] using hl)
  have hex (c : (diagram J (by omega) hn U).ConnectedComponent) :=
    admissible_exists J hr hn marked Q (componentBlocks J (by omega) hn U c)
      (component_support_connected J (by omega) hn U c)
      ((Finset.card_le_card (componentBlocks_subset J (by omega) hn U c)).trans hU)
      cut (avoids_mono J (componentBlocks_subset J (by omega) hn U c) hc)
  choose h hh using hex
  refine ⟨representedValues J (by omega) hn marked U h (fun _ => 0), cut,hc,h,(fun _ => 0),hh,?_⟩
  exact fun b hb a ha => representedValues_on_block J (by omega) hn marked U h _ hb ha
end VariableWL.Blocks

end ProjectionAudit


/- Adapted from ExactProjection.lean. -/

namespace ProjectionAudit

universe uExactProjection1 uExactProjection2 uExactProjection3 uExactProjection4 uExactProjection5 uExactProjection6 uExactProjection7 uExactProjection8 uExactProjection9 uExactProjection10

namespace VariableWL.Blocks
open Subdivision ProductImages.Instance
variable {m r n : ℕ} {P : Type uExactProjection1} {E : Type uExactProjection2} (J : ProductImages.Instance m r P E)

theorem component_links_small (hr : 2 ≤ r) (hn : 0 < n) (hlarge : r+1 < n+1)
    (U : Finset (Block (n := n) J)) (hU : U.card ≤ r+1)
    (c : (diagram J hr hn U).ConnectedComponent) :
    (supportLinks J (componentBlocks J hr hn U c)).card < n+1 :=
  lt_of_le_of_lt ((supportLinks_card J _).trans
    ((Finset.card_le_card (componentBlocks_subset J hr hn U c)).trans hU)) hlarge

theorem offsetFamily_restrict (hr : 3 ≤ r) (hn : 0 < n) (hlarge : r+1 < n+1)
    (marked : Fin r) (Q : J.Witness) (U V : Finset (Block (n := n) J))
    (hU : U.card ≤ r+1) (hVU : V ⊆ U) {F : ReadoutValues (n := n) J}
    (hF : OffsetFamily J hr hn marked Q U F) : OffsetFamily J hr hn marked Q V F := by
  classical
  obtain ⟨cut,hc,h,M,hh,hF⟩ := hF
  refine ⟨cut,avoids_mono J hVU hc, fun d => h (componentMap J (by omega) hn hVU d),M,?_,?_⟩
  · intro d
    apply admissible_restrict J hr hn marked Q
      (componentBlocks J (by omega) hn U (componentMap J (by omega) hn hVU d))
      (componentBlocks J (by omega) hn V d)
      (componentBlocks_map_subset J (by omega) hn hVU d)
      (component_support_connected J (by omega) hn U _)
      (component_support_connected J (by omega) hn V d)
      (component_links_small J (by omega) hn hlarge U hU _) cut
      (avoids_mono J (componentBlocks_subset J (by omega) hn U _) hc)
    exact hh _
  · intro b hb a ha
    exact hF b (hVU hb) a ha

theorem choose_extension_shifts (hr : 3 ≤ r) (hn : 0 < n) (hlarge : r+1 < n+1)
    (marked : Fin r) (Q : J.Witness) (U V : Finset (Block (n := n) J))
    (hU : U.card ≤ r+1) (hV : V.card ≤ r) (hVU : V ⊆ U)
    (cut : E → Fin (n+1)) (hc : Avoids J cut U)
    (h : (diagram J (by omega) hn V).ConnectedComponent → J.Shifts n)
    (hh : ∀ d, Admissible J hr hn marked Q cut (componentBlocks J (by omega) hn V d) (h d)) :
    ∃ g : (diagram J (by omega) hn U).ConnectedComponent → J.Shifts n,
      (∀ c, Admissible J hr hn marked Q cut (componentBlocks J (by omega) hn U c) (g c)) ∧
      ∀ d, (rowDiagram J hr hn (componentBlocks J (by omega) hn V d)).Wraps marked →
        ∀ t ∈ supportTypes J (componentBlocks J (by omega) hn V d),
          J.AgreeAt (h d) (g (componentMap J (by omega) hn hVU d)) t := by
  classical
  have hex (c : (diagram J (by omega) hn U).ConnectedComponent) :
      ∃ g : J.Shifts n, Admissible J hr hn marked Q cut
          (componentBlocks J (by omega) hn U c) g ∧
        ∀ d : (diagram J (by omega) hn V).ConnectedComponent, componentMap J (by omega) hn hVU d = c →
          (rowDiagram J hr hn (componentBlocks J (by omega) hn V d)).Wraps marked →
          ∀ t ∈ supportTypes J (componentBlocks J (by omega) hn V d), J.AgreeAt (h d) g t := by
    by_cases he : ∃ d : (diagram J (by omega) hn V).ConnectedComponent, componentMap J (by omega) hn hVU d = c ∧
        (rowDiagram J hr hn (componentBlocks J (by omega) hn V d)).Wraps marked
    · obtain ⟨d,hd,hw⟩ := he
      have hsub : componentBlocks J (by omega) hn V d ⊆ componentBlocks J (by omega) hn U c := by
        rw [← hd]
        exact componentBlocks_map_subset J (by omega) hn hVU d
      obtain ⟨hall,hcard⟩ := wrapping_component_all J hr hn V hV marked d hw
      obtain ⟨g,hg,hagree⟩ := admissible_lift J hr hn marked Q
        (componentBlocks J (by omega) hn U c) (componentBlocks J (by omega) hn V d)
        hsub (component_support_connected J (by omega) hn U c)
        (component_support_connected J (by omega) hn V d)
        ((Finset.card_le_card (componentBlocks_subset J (by omega) hn U c)).trans hU)
        (component_links_small J (by omega) hn hlarge U hU c)
        ((congrArg Finset.card hall).trans hcard) hw cut
        (avoids_mono J (componentBlocks_subset J (by omega) hn U c) hc) (hh d)
      refine ⟨g,hg,?_⟩
      intro d' _ hw'
      have hdd := wrapping_component_unique J hr hn V hV marked hw hw'
      subst d'
      exact hagree
    · obtain ⟨g,hg⟩ := admissible_exists J hr hn marked Q
        (componentBlocks J (by omega) hn U c) (component_support_connected J (by omega) hn U c)
        ((Finset.card_le_card (componentBlocks_subset J (by omega) hn U c)).trans hU)
        cut (avoids_mono J (componentBlocks_subset J (by omega) hn U c) hc)
      exact ⟨g,hg, fun d hd hw => (he ⟨d,hd,hw⟩).elim⟩
  choose g hg hagree using hex
  exact ⟨g,hg,fun d hw => hagree _ d rfl hw⟩

theorem offsetFamily_extend_strict (hr : 3 ≤ r) (hn : 0 < n) (hlarge : r+1 < n+1)
    (marked : Fin r) (Q : J.Witness) (U V : Finset (Block (n := n) J))
    (hU : U.card ≤ r+1) (hV : V.card ≤ r) (hVU : V ⊆ U)
    {F : ReadoutValues (n := n) J} (hF : OffsetFamily J hr hn marked Q V F) :
    ∃ G : ReadoutValues (n := n) J, OffsetFamily J hr hn marked Q U G ∧
      ∀ b ∈ V, ∀ a, HasReadout J b.val a → G a = F a := by
  classical
  obtain ⟨cut₀,hc₀,h,M,hh,hF⟩ := hF
  obtain ⟨cut,hcut⟩ := exists_unused_cut (supportLinks J U)
    (lt_of_le_of_lt ((supportLinks_card J U).trans hU) hlarge)
  have hc : Avoids J cut U := by
    intro l hl he
    exact hcut l.1 (by simpa only [← he,Prod.eta] using hl)
  have hh' (d) : Admissible J hr hn marked Q cut (componentBlocks J (by omega) hn V d) (h d) :=
    admissible_cut_change J hr hn marked Q _ (component_support_connected J (by omega) hn V d)
      cut₀ cut (avoids_mono J (componentBlocks_subset J (by omega) hn V d) hc₀)
      (avoids_mono J ((componentBlocks_subset J (by omega) hn V d).trans hVU) hc) (hh d)
  obtain ⟨g,hg,hagree⟩ := choose_extension_shifts J hr hn hlarge marked Q U V hU hV hVU cut hc h hh'
  have hex (d : (diagram J (by omega) hn V).ConnectedComponent) :
      ∃ M' : Potentials (n := n) J, ∀ b ∈ componentBlocks J (by omega) hn V d,
        ∀ a, HasReadout J b.val a →
          potentialValues J marked (g (componentMap J (by omega) hn hVU d)) M' a =
            potentialValues J marked (h d) M a := by
    by_cases hw : (rowDiagram J hr hn (componentBlocks J (by omega) hn V d)).Wraps marked
    · refine ⟨M,?_⟩
      intro b hb a ha
      exact (potentialValues_shift_agree J marked (h d) (g (componentMap J (by omega) hn hVU d)) M a
        (hagree d hw _ (Finset.mem_biUnion.mpr ⟨b,hb,readout_type_mem J ha⟩))).symm
    · apply gauge_nonwrapping J hr hn _ marked (h d) (g (componentMap J (by omega) hn hVU d)) M
        (hh' d).1 _ hw
      intro l hl
      exact (hg _).1 l (supportLinks_mono J (componentBlocks_map_subset J (by omega) hn hVU d) hl)
  choose Ms hMs using hex
  let N : Potentials (n := n) J := fun v => Ms ((diagram J (by omega) hn V).connectedComponentMk v) v
  let G := representedValues J (by omega) hn marked U g N
  refine ⟨G,⟨cut,hc,g,N,hg,?_⟩,?_⟩
  · exact fun b hb a ha => representedValues_on_block J (by omega) hn marked U g N hb ha
  · intro b hb a ha
    let d := (diagram J (by omega) hn V).connectedComponentMk (anchor J b.val)
    have hb' : b ∈ componentBlocks J (by omega) hn V d :=
      (mem_componentBlocks J (by omega) hn V d b).mpr ⟨hb,rfl⟩
    obtain ⟨he0,he1⟩ := readout_component J (by omega) hn V hb ha
    have hN := potentialValues_potentials_agree J marked
      (g (componentMap J (by omega) hn hVU d)) N (Ms d) a
      (show N (end0 J a) = Ms d (end0 J a) by dsimp only [N,d]; rw [← he0])
      (show N (end1 J a) = Ms d (end1 J a) by dsimp only [N,d]; rw [← he1])
    change representedValues J (by omega) hn marked U g N a = F a
    rw [representedValues_on_block J (by omega) hn marked U g N (hVU hb) ha]
    exact hN.trans ((hMs d b hb' a ha).trans (hF b hb a ha).symm)

theorem offsetFamily_exact_projection (hr : 3 ≤ r) (hn : 0 < n) (hlarge : r+1 < n+1)
    (marked : Fin r) (Q : J.Witness) (U V : Finset (Block (n := n) J))
    (hU : U.card ≤ r+1) (hVU : V ⊆ U) {F : ReadoutValues (n := n) J} :
    OffsetFamily J hr hn marked Q V F ↔
      ∃ G : ReadoutValues (n := n) J, OffsetFamily J hr hn marked Q U G ∧
        ∀ b ∈ V, ∀ a, HasReadout J b.val a → G a = F a := by
  classical
  constructor
  · intro hF
    by_cases he : V = U
    · subst U
      exact ⟨F,hF,fun _ _ _ _ => rfl⟩
    · apply offsetFamily_extend_strict J hr hn hlarge marked Q U V hU _ hVU hF
      have hc := Finset.card_lt_card (Finset.ssubset_iff_subset_ne.mpr ⟨hVU,he⟩)
      omega
  · rintro ⟨G,hG,hGF⟩
    obtain ⟨cut,hc,h,M,hh,hrep⟩ := offsetFamily_restrict J hr hn hlarge marked Q U V hU hVU hG
    exact ⟨cut,hc,h,M,hh,fun b hb a ha => (hGF b hb a ha).symm.trans (hrep b hb a ha)⟩
end VariableWL.Blocks

namespace VariableWL.Blocks
open scoped CharTwo
open Subdivision ProductImages.Instance VariableWL.Affine
variable {m r n : ℕ} {P : Type uExactProjection3} {E : Type uExactProjection4} (J : ProductImages.Instance m r P E)

def RawValue : RawBlock m r n P E → Type
  | .inl h => Value J h.type
  | .inr s => SquareVal (dimension J (left J.source s.link)) (dimension J (right J.target s.link))

instance rawValueAddCommGroup (b : RawBlock m r n P E) : AddCommGroup (RawValue J b) := by
  cases b <;> dsimp only [RawValue] <;> infer_instance

noncomputable instance rawValueFintype (b : RawBlock m r n P E) : Fintype (RawValue J b) := by
  cases b <;> dsimp only [RawValue] <;> infer_instance

def boundaryMap (b : RawBlock m r n P E) : RawValue J b →+ Bit := by
  cases b with
  | inl h => exact 0
  | inr s =>
    exact { toFun := boundary (linkLeft J s.link) (linkRight J s.link)
            map_zero' := boundary_zero _ _
            map_add' := boundary_add _ _ }

def inhomogeneity (marked : Fin r) : RawBlock m r n P E → Bit
  | .inl _ => 0
  | .inr s => marker marked s.row * linkConstant J s.link

def LegalValue (marked : Fin r) (ε : Bit) (b : RawBlock m r n P E) (z : RawValue J b) : Prop :=
  boundaryMap J b z = ε * inhomogeneity J marked b

abbrev Valuation (marked : Fin r) (ε : Bit) (b : Block (n := n) J) :=
  {z : RawValue J b.val // LegalValue J marked ε b.val z}

noncomputable instance valuationFintype (marked : Fin r) (ε : Bit) (b : Block (n := n) J) :
    Fintype (Valuation J marked ε b) := Fintype.ofFinite _

theorem legal_zero (marked : Fin r) (b : RawBlock m r n P E) :
    LegalValue J marked 0 b 0 := by simp [LegalValue]

theorem legal_nonempty (marked : Fin r) (ε : Bit) (b : RawBlock m r n P E) :
    ∃ z : RawValue J b, LegalValue J marked ε b z := by
  cases b with
  | inl h => exact ⟨0,by simp [LegalValue, inhomogeneity, boundaryMap]⟩
  | inr s =>
    exact fiber_nonempty (linkLeft J s.link) (linkRight J s.link)
      (ε * (marker marked s.row * linkConstant J s.link))

def translateValuation (marked : Fin r) (b : Block (n := n) J)
    (ξ : Valuation J marked 1 b) : Valuation J marked 0 b ≃ Valuation J marked 1 b where
  toFun z := ⟨z.val + ξ.val, by
    change boundaryMap J b.val (z.val + ξ.val) = 1 * inhomogeneity J marked b.val
    rw [map_add,z.property,ξ.property,zero_mul,zero_add]⟩
  invFun z := ⟨z.val - ξ.val, by
    change boundaryMap J b.val (z.val - ξ.val) = 0 * inhomogeneity J marked b.val
    rw [map_sub,z.property,ξ.property,sub_self,zero_mul]⟩
  left_inv z := Subtype.ext (add_sub_cancel_right _ _)
  right_inv z := Subtype.ext (sub_add_cancel _ _)

def valueOfReadouts (F : ReadoutValues (n := n) J) : (b : RawBlock m r n P E) → RawValue J b
  | .inl h => F (.inl h)
  | .inr s => ((F (.inl (squareLeft J s)), F (.inl (squareRight J s))),
      (F (.inr (squareBottom s)), F (.inr (squareTop s))))

def Carries (b : RawBlock m r n P E) (z : RawValue J b)
    (a : Readout m r n P E) (v : ReadoutValue J a) : Prop :=
  match b with
  | .inl h => a = .inl h ∧ HEq v z
  | .inr s =>
      (a = .inl (squareLeft J s) ∧ HEq v z.1.1) ∨
      (a = .inl (squareRight J s) ∧ HEq v z.1.2) ∨
      (a = .inr (squareBottom s) ∧ HEq v z.2.1) ∨
      (a = .inr (squareTop s) ∧ HEq v z.2.2)

theorem valueOfReadouts_carries (F : ReadoutValues (n := n) J)
    {b : RawBlock m r n P E} {a : Readout m r n P E} (ha : HasReadout J b a) :
    Carries J b (valueOfReadouts J F b) a (F a) := by
  cases b with
  | inl h => cases ha; exact ⟨rfl,HEq.rfl⟩
  | inr s =>
    rcases ha with rfl | rfl | rfl | rfl
    · exact Or.inl ⟨rfl,HEq.rfl⟩
    · exact Or.inr (Or.inl ⟨rfl,HEq.rfl⟩)
    · exact Or.inr (Or.inr (Or.inl ⟨rfl,HEq.rfl⟩))
    · exact Or.inr (Or.inr (Or.inr ⟨rfl,HEq.rfl⟩))

theorem carries_hasReadout {b : RawBlock m r n P E} {z : RawValue J b}
    {a : Readout m r n P E} {v : ReadoutValue J a} (h : Carries J b z a v) : HasReadout J b a := by
  cases b with
  | inl _ => exact h.1
  | inr _ =>
    exact h.elim (fun h => Or.inl h.1)
      (fun h => h.elim (fun h => Or.inr (Or.inl h.1))
        (fun h => h.elim (fun h => Or.inr (Or.inr (Or.inl h.1)))
          (fun h => Or.inr (Or.inr (Or.inr h.1)))))

theorem carries_exists {b : RawBlock m r n P E} (z : RawValue J b)
    {a : Readout m r n P E} (ha : HasReadout J b a) : ∃ v, Carries J b z a v := by
  cases b with
  | inl h => cases ha; exact ⟨z,rfl,HEq.rfl⟩
  | inr s =>
    rcases ha with rfl | rfl | rfl | rfl
    · exact ⟨z.1.1,Or.inl ⟨rfl,HEq.rfl⟩⟩
    · exact ⟨z.1.2,Or.inr (Or.inl ⟨rfl,HEq.rfl⟩)⟩
    · exact ⟨z.2.1,Or.inr (Or.inr (Or.inl ⟨rfl,HEq.rfl⟩))⟩
    · exact ⟨z.2.2,Or.inr (Or.inr (Or.inr ⟨rfl,HEq.rfl⟩))⟩

theorem offsetFamily_legal (hr : 3 ≤ r) (hn : 0 < n) (marked : Fin r) (Q : J.Witness)
    (U : Finset (Block (n := n) J)) {F : ReadoutValues (n := n) J}
    (hF : OffsetFamily J hr hn marked Q U F) {b : Block (n := n) J} (hb : b ∈ U) :
    LegalValue J marked 1 b.val (valueOfReadouts J F b.val) := by
  obtain ⟨cut,hc,h,M,hh,hrep⟩ := hF
  let c := (diagram J (by omega) hn U).connectedComponentMk (anchor J b.val)
  have hbC : b ∈ componentBlocks J (by omega) hn U c :=
    (mem_componentBlocks J (by omega) hn U c b).mpr ⟨hb,rfl⟩
  have hsys := (hh c).1
  obtain ⟨b,hvalid⟩ := b
  cases b with
  | inl x => simp [LegalValue, boundaryMap, inhomogeneity]
  | inr s =>
    have hl := square_link_mem J (componentBlocks J (by omega) hn U c) hbC rfl
    have h0 := hrep ⟨.inr s,hvalid⟩ hb (.inl (squareLeft J s)) (Or.inl rfl)
    have h1 := hrep ⟨.inr s,hvalid⟩ hb (.inl (squareRight J s)) (Or.inr (Or.inl rfl))
    have h2 := hrep ⟨.inr s,hvalid⟩ hb (.inr (squareBottom s)) (Or.inr (Or.inr (Or.inl rfl)))
    have h3 := hrep ⟨.inr s,hvalid⟩ hb (.inr (squareTop s)) (Or.inr (Or.inr (Or.inr rfl)))
    change linkLeft J s.link (F (.inl (squareLeft J s))) +
      linkRight J s.link (F (.inl (squareRight J s))) + F (.inr (squareBottom s)) +
        F (.inr (squareTop s)) = 1 * (marker marked s.row * linkConstant J s.link)
    rw [h0,h1,h2,h3,one_mul]
    exact potential_square J marked (h c) M s (hsys s.link hl)

noncomputable def familyList (hr : 3 ≤ r) (hn : 0 < n) (marked : Fin r) (Q : J.Witness)
    (U : Finset (Block (n := n) J)) {F : ReadoutValues (n := n) J}
    (hF : OffsetFamily J hr hn marked Q U F) : ∀ b : ↑U, Valuation J marked 1 b.val :=
  fun b => ⟨valueOfReadouts J F b.val.val, offsetFamily_legal J hr hn marked Q U hF b.property⟩
end VariableWL.Blocks

namespace VariableWL.Blocks
open Subdivision ProductImages.Instance VariableWL.Affine
variable {m r n : ℕ} {P : Type uExactProjection5} {E : Type uExactProjection6} (J : ProductImages.Instance m r P E)

theorem valueOfReadouts_congr {b : RawBlock m r n P E} {F G : ReadoutValues (n := n) J}
    (he : ∀ a, HasReadout J b a → F a = G a) : valueOfReadouts J F b = valueOfReadouts J G b := by
  cases b with
  | inl h => exact he _ rfl
  | inr s =>
    dsimp only [valueOfReadouts]
    rw [he _ (Or.inl rfl), he _ (Or.inr (Or.inl rfl)),
      he _ (Or.inr (Or.inr (Or.inl rfl))), he _ (Or.inr (Or.inr (Or.inr rfl)))]

def OffsetLists (hr : 3 ≤ r) (hn : 0 < n) (marked : Fin r) (Q : J.Witness)
    (U : Finset (Block (n := n) J)) : Set (∀ b : ↑U, Valuation J marked 1 b.val) :=
  {ξ | ∃ F : ReadoutValues (n := n) J, OffsetFamily J hr hn marked Q U F ∧
    ∀ b : ↑U, (ξ b).val = valueOfReadouts J F b.val.val}

def restrictList (marked : Fin r) {U V : Finset (Block (n := n) J)} (hVU : V ⊆ U)
    (ξ : ∀ b : ↑U, Valuation J marked 1 b.val) : ∀ b : ↑V, Valuation J marked 1 b.val :=
  fun b => ξ ⟨b.val,hVU b.property⟩

theorem offsetLists_nonempty (hr : 3 ≤ r) (hn : 0 < n) (hlarge : r+1 < n+1)
    (marked : Fin r) (Q : J.Witness) (U : Finset (Block (n := n) J)) (hU : U.card ≤ r+1) :
    (OffsetLists J hr hn marked Q U).Nonempty := by
  obtain ⟨F,hF⟩ := offsetFamily_nonempty J hr hn hlarge marked Q U hU
  exact ⟨familyList J hr hn marked Q U hF,F,hF,fun _ => rfl⟩

theorem exact_projection (hr : 3 ≤ r) (hn : 0 < n) (hlarge : r+1 < n+1)
    (marked : Fin r) (Q : J.Witness) (U V : Finset (Block (n := n) J))
    (hU : U.card ≤ r+1) (hVU : V ⊆ U) :
    restrictList J marked hVU '' OffsetLists J hr hn marked Q U = OffsetLists J hr hn marked Q V := by
  ext ξ
  constructor
  · rintro ⟨η,⟨F,hF,hη⟩,rfl⟩
    exact ⟨F,offsetFamily_restrict J hr hn hlarge marked Q U V hU hVU hF,
      fun b => hη ⟨b.val,hVU b.property⟩⟩
  · rintro ⟨F,hF,hξ⟩
    obtain ⟨G,hG,hGF⟩ := (offsetFamily_exact_projection J hr hn hlarge marked Q U V hU hVU).mp hF
    refine ⟨familyList J hr hn marked Q U hG, ⟨G,hG,fun _ => rfl⟩,?_⟩
    funext b
    apply Subtype.ext
    exact (valueOfReadouts_congr J (fun a ha => hGF b.val b.property a ha)).trans (hξ b).symm
end VariableWL.Blocks

namespace VariableWL.Blocks
open Subdivision ProductImages.Instance VariableWL.Affine
variable {m r n : ℕ} {P : Type uExactProjection7} {E : Type uExactProjection8} (J : ProductImages.Instance m r P E)

instance readoutValueAddCommGroup (a : Readout m r n P E) : AddCommGroup (ReadoutValue J a) := by
  cases a <;> dsimp only [ReadoutValue] <;> infer_instance

noncomputable instance readoutValueFintype (a : Readout m r n P E) : Fintype (ReadoutValue J a) := by
  cases a <;> dsimp only [ReadoutValue] <;> infer_instance

theorem squareLeft_ne_right (hn : 0 < n) (s : Square m r n E) :
    squareLeft J s ≠ squareRight J s := by
  intro h
  exact endpoints_ne hn J.source J.target s.link (congrArg Horizontal.type h)

theorem squareBottom_ne_top (hr : 2 ≤ r) (s : Square m r n E) :
    squareBottom s ≠ squareTop s := by
  intro h
  exact Wrapping.finRotate_no_fixed hr s.row (congrArg Vertical.row h).symm

theorem carries_unique (hr : 2 ≤ r) (hn : 0 < n) {b : RawBlock m r n P E}
    {z : RawValue J b} {a : Readout m r n P E} {v w : ReadoutValue J a}
    (hv : Carries J b z a v) (hw : Carries J b z a w) : v = w := by
  cases b with
  | inl h => exact eq_of_heq (hv.2.trans hw.2.symm)
  | inr s =>
    have hlr := squareLeft_ne_right J hn s
    have hbt := squareBottom_ne_top hr s
    rcases hv with ⟨hv,hv'⟩ | ⟨hv,hv'⟩ | ⟨hv,hv'⟩ | ⟨hv,hv'⟩ <;>
      rcases hw with ⟨hw,hw'⟩ | ⟨hw,hw'⟩ | ⟨hw,hw'⟩ | ⟨hw,hw'⟩
    all_goals first | exact eq_of_heq (hv'.trans hw'.symm) | exfalso; aesop

noncomputable def readout {b : RawBlock m r n P E} (z : RawValue J b)
    {a : Readout m r n P E} (ha : HasReadout J b a) : ReadoutValue J a :=
  (carries_exists J z ha).choose

theorem readout_carries {b : RawBlock m r n P E} (z : RawValue J b)
    {a : Readout m r n P E} (ha : HasReadout J b a) : Carries J b z a (readout J z ha) :=
  (carries_exists J z ha).choose_spec

theorem readout_eq (hr : 2 ≤ r) (hn : 0 < n) {b : RawBlock m r n P E}
    {z : RawValue J b} {a : Readout m r n P E} (ha : HasReadout J b a)
    {v : ReadoutValue J a} (hv : Carries J b z a v) : readout J z ha = v :=
  carries_unique J hr hn (readout_carries J z ha) hv

theorem carries_add (hr : 2 ≤ r) (hn : 0 < n) {b : RawBlock m r n P E}
    {z z' : RawValue J b} {a : Readout m r n P E} {v v' : ReadoutValue J a}
    (hv : Carries J b z a v) (hv' : Carries J b z' a v') :
    Carries J b (z+z') a (v+v') := by
  cases b with
  | inl h =>
    obtain ⟨rfl,hv⟩ := hv
    have h₁ := eq_of_heq hv
    have h₂ := eq_of_heq hv'.2
    subst v; subst v'
    exact ⟨rfl,HEq.rfl⟩
  | inr s =>
    rcases hv with ⟨rfl,hv⟩ | ⟨rfl,hv⟩ | ⟨rfl,hv⟩ | ⟨rfl,hv⟩
    · have h₁ := eq_of_heq hv
      have h₂ := carries_unique J hr hn hv' (Or.inl ⟨rfl,HEq.rfl⟩)
      subst v; subst v'
      exact Or.inl ⟨rfl,HEq.rfl⟩
    · have h₁ := eq_of_heq hv
      have h₂ := carries_unique J hr hn hv' (Or.inr (Or.inl ⟨rfl,HEq.rfl⟩))
      subst v; subst v'
      exact Or.inr (Or.inl ⟨rfl,HEq.rfl⟩)
    · have h₁ := eq_of_heq hv
      have h₂ := carries_unique J hr hn hv' (Or.inr (Or.inr (Or.inl ⟨rfl,HEq.rfl⟩)))
      subst v; subst v'
      exact Or.inr (Or.inr (Or.inl ⟨rfl,HEq.rfl⟩))
    · have h₁ := eq_of_heq hv
      have h₂ := carries_unique J hr hn hv' (Or.inr (Or.inr (Or.inr ⟨rfl,HEq.rfl⟩)))
      subst v; subst v'
      exact Or.inr (Or.inr (Or.inr ⟨rfl,HEq.rfl⟩))

theorem readout_add (hr : 2 ≤ r) (hn : 0 < n) {b : RawBlock m r n P E}
    (z z' : RawValue J b) {a : Readout m r n P E} (ha : HasReadout J b a) :
    readout J (z+z') ha = readout J z ha + readout J z' ha :=
  readout_eq J hr hn ha (carries_add J hr hn (readout_carries J z ha) (readout_carries J z' ha))

theorem readout_valueOfReadouts (hr : 2 ≤ r) (hn : 0 < n)
    (F : ReadoutValues (n := n) J) {b : RawBlock m r n P E} {a : Readout m r n P E}
    (ha : HasReadout J b a) : readout J (valueOfReadouts J F b) ha = F a :=
  readout_eq J hr hn ha (valueOfReadouts_carries J F ha)

theorem readout_zero (hr : 2 ≤ r) (hn : 0 < n) {b : RawBlock m r n P E}
    {a : Readout m r n P E} (ha : HasReadout J b a) : readout J 0 ha = 0 := by
  have h := readout_add J hr hn (0 : RawValue J b) 0 ha
  have hh : readout J 0 ha + readout J 0 ha = readout J 0 ha := by simpa using h.symm
  exact add_eq_left.mp hh

theorem offsetLists_agree (hr : 3 ≤ r) (hn : 0 < n) (marked : Fin r) (Q : J.Witness)
    (U : Finset (Block (n := n) J)) {ξ : ∀ b : ↑U, Valuation J marked 1 b.val}
    (hξ : ξ ∈ OffsetLists J hr hn marked Q U) (b c : ↑U)
    (a : Readout m r n P E) (hb : HasReadout J b.val.val a) (hc : HasReadout J c.val.val a) :
    readout J (ξ b).val hb = readout J (ξ c).val hc := by
  obtain ⟨F,hF,hξ⟩ := hξ
  rw [hξ b, hξ c, readout_valueOfReadouts J (by omega) hn,
    readout_valueOfReadouts J (by omega) hn]
end VariableWL.Blocks

namespace VariableWL.Blocks
variable {m r n : ℕ} {P : Type uExactProjection9} {E : Type uExactProjection10} [Fintype P] [Fintype E]

noncomputable instance horizontalFintype : Fintype (Horizontal m r n P E) := by
  classical
  refine Fintype.ofInjective (fun h => (h.row,h.type,h.first,h.last)) ?_
  rintro ⟨a,b,c,d⟩ ⟨a',b',c',d'⟩ h
  simp only [Prod.mk.injEq] at h
  rcases h with ⟨rfl,rfl,rfl,rfl⟩
  rfl

noncomputable instance verticalFintype : Fintype (Vertical m r n E) := by
  classical
  refine Fintype.ofInjective (fun h => (h.row,h.link,h.label)) ?_
  rintro ⟨a,b,c⟩ ⟨a',b',c'⟩ h
  simp only [Prod.mk.injEq] at h
  rcases h with ⟨rfl,rfl,rfl⟩
  rfl

noncomputable instance squareFintype : Fintype (Square m r n E) := by
  classical
  refine Fintype.ofInjective (fun h => (h.row,h.link,h.first,h.last)) ?_
  rintro ⟨a,b,c,d⟩ ⟨a',b',c',d'⟩ h
  simp only [Prod.mk.injEq] at h
  rcases h with ⟨rfl,rfl,rfl,rfl⟩
  rfl

noncomputable instance blockFintype (J : ProductImages.Instance m r P E) : Fintype (Block (n := n) J) :=
  Fintype.ofFinite _
end VariableWL.Blocks

end ProjectionAudit

namespace ProjectionAudit.VariableWL.Blocks
open Subdivision ProductImages.Instance VariableWL.Affine

theorem full_projection_certificate {m r n : ℕ} {P E : Type*}
    (J : ProductImages.Instance m r P E)
    (hr : 3 ≤ r) (hn : 0 < n) (hlarge : r + 1 < n + 1)
    (marked : Fin r) (hconsistent : J.Consistent) :
    ∃ H : (U : Finset (Block (n := n) J)) →
        Set (∀ b : ↑U, Valuation J marked 1 b.val),
      (∀ U, U.card ≤ r + 1 → (H U).Nonempty) ∧
      (∀ U, U.card ≤ r + 1 →
        ∀ ξ ∈ H U, ∀ b c : ↑U, ∀ a,
          ∀ hb : HasReadout J b.val.val a,
          ∀ hc : HasReadout J c.val.val a,
            readout J (ξ b).val hb = readout J (ξ c).val hc) ∧
      (∀ U V, U.card ≤ r + 1 → ∀ hVU : V ⊆ U,
        restrictList J marked hVU '' H U = H V) := by
  obtain ⟨Q⟩ := hconsistent
  refine ⟨fun U => OffsetLists J hr hn marked Q U, ?_, ?_, ?_⟩
  · exact fun U hU => offsetLists_nonempty J hr hn hlarge marked Q U hU
  · intro U _ ξ hξ b c a hb hc
    exact offsetLists_agree J hr hn marked Q U hξ b c a hb hc
  · exact fun U V hU hVU => exact_projection J hr hn hlarge marked Q U V hU hVU

theorem manuscript_projection_certificate {m r : ℕ} {P E : Type*}
    (J : ProductImages.Instance m r P E) (hr : 3 ≤ r)
    (marked : Fin r) (hconsistent : J.Consistent) :
    ∃ H : (U : Finset (Block (n := 4 * (r + 1)) J)) →
        Set (∀ b : ↑U, Valuation J marked 1 b.val),
      (∀ U, U.card ≤ r + 1 → (H U).Nonempty) ∧
      (∀ U, U.card ≤ r + 1 →
        ∀ ξ ∈ H U, ∀ b c : ↑U, ∀ a,
          ∀ hb : HasReadout J b.val.val a,
          ∀ hc : HasReadout J c.val.val a,
            readout J (ξ b).val hb = readout J (ξ c).val hc) ∧
      (∀ U V, U.card ≤ r + 1 → ∀ hVU : V ⊆ U,
        restrictList J marked hVU '' H U = H V) :=
  full_projection_certificate J hr (by omega) (by omega) marked hconsistent

end ProjectionAudit.VariableWL.Blocks

#print axioms ProjectionAudit.VariableWL.Blocks.full_projection_certificate
#print axioms ProjectionAudit.VariableWL.Blocks.manuscript_projection_certificate

/- Compressed-reduction extension; the approved EP source above is unchanged. -/

set_option linter.unnecessarySimpa false
set_option linter.unusedSimpArgs false

noncomputable section

attribute [local instance] Classical.propDecidable

namespace CompressedReduction

universe u v

namespace Game

variable {V : Type u} {W : Type v}

local instance : DecidableEq V := Classical.decEq V
local instance : DecidableEq W := Classical.decEq W

abbrev Position (V : Type u) (W : Type v) := Finset (V × W)

def PartialIso (G : SimpleGraph V) (H : SimpleGraph W) (p : Position V W) : Prop :=
  ∀ a ∈ p, ∀ b ∈ p,
    (a.1 = b.1 ↔ a.2 = b.2) ∧ (G.Adj a.1 b.1 ↔ H.Adj a.2 b.2)

structure Invariant (G : SimpleGraph V) (H : SimpleGraph W) (K : ℕ)
    (S : Set (Position V W)) : Prop where
  partialIso : ∀ p ∈ S, PartialIso G H p
  discard : ∀ p ∈ S, ∀ q, q ⊆ p → q ∈ S
  announce : ∀ p ∈ S, p.card < K →
    ∃ e : V ≃ W, ∀ x, insert (x, e x) p ∈ S

def Winning (G : SimpleGraph V) (H : SimpleGraph W) (K : ℕ)
    (p : Position V W) : Prop :=
  ∃ S, Invariant G H K S ∧ p ∈ S

def Equivalent (G : SimpleGraph V) (H : SimpleGraph W) (K : ℕ) : Prop :=
  Winning G H K ∅

theorem Winning.partialIso {G : SimpleGraph V} {H : SimpleGraph W} {K : ℕ}
    {p : Position V W} (hp : Winning G H K p) : PartialIso G H p := by
  obtain ⟨S, hS, hp⟩ := hp
  exact hS.partialIso p hp

theorem Winning.discard {G : SimpleGraph V} {H : SimpleGraph W} {K : ℕ}
    {p : Position V W} (hp : Winning G H K p) {q : Position V W} (hq : q ⊆ p) :
    Winning G H K q := by
  obtain ⟨S, hS, hp⟩ := hp
  exact ⟨S, hS, hS.discard p hp q hq⟩

theorem Winning.announce {G : SimpleGraph V} {H : SimpleGraph W} {K : ℕ}
    {p : Position V W} (hp : Winning G H K p) (hcard : p.card < K) :
    ∃ e : V ≃ W, ∀ x, Winning G H K (insert (x, e x) p) := by
  obtain ⟨S, hS, hp⟩ := hp
  obtain ⟨e, he⟩ := hS.announce p hp hcard
  exact ⟨e, fun x => ⟨S, hS, he x⟩⟩

def degree (G : SimpleGraph V) (x : V) : ℕ := Nat.card {y // G.Adj x y}

theorem Winning.degree {G : SimpleGraph V} {H : SimpleGraph W} {K : ℕ}
    (hK : 2 ≤ K) {p : Position V W} (hp : Winning G H K p)
    {x : V} {y : W} (hxy : (x,y) ∈ p) : degree G x = degree H y := by
  classical
  have hs : Winning G H K {(x,y)} :=
    hp.discard (Finset.singleton_subset_iff.mpr hxy)
  obtain ⟨e, he⟩ := hs.announce (by simp only [Finset.card_singleton]; omega)
  have ha (z : V) : G.Adj x z ↔ H.Adj y (e z) :=
    ((he z).partialIso (x,y) (by simp) (z,e z) (by simp)).2
  let eN : {z // G.Adj x z} ≃ {z // H.Adj y z} :=
    { toFun := fun z => ⟨e z, (ha z).mp z.property⟩
      invFun := fun z => ⟨e.symm z, (ha (e.symm z)).mpr (by simpa using z.property)⟩
      left_inv := fun z => Subtype.ext (e.symm_apply_apply z)
      right_inv := fun z => Subtype.ext (e.apply_symm_apply z) }
  exact Nat.card_congr eN

theorem of_isomorphism {G : SimpleGraph V} {H : SimpleGraph W}
    (K : ℕ) (e : V ≃ W) (he : ∀ x y, G.Adj x y ↔ H.Adj (e x) (e y)) :
    Equivalent G H K := by
  classical
  let S : Set (Position V W) := {p | ∀ a ∈ p, a.2 = e a.1}
  refine ⟨S, ⟨?_, ?_, ?_⟩, by simp [S]⟩
  · intro p hp a ha b hb
    rw [hp a ha, hp b hb]
    exact ⟨e.injective.eq_iff.symm, he a.1 b.1⟩
  · exact fun p hp q hq a ha => hp a (hq ha)
  · intro p hp _
    refine ⟨e, ?_⟩
    intro x a ha
    rcases Finset.mem_insert.mp ha with rfl | ha
    · rfl
    · exact hp a ha

end Game

namespace Marks

variable {V : Type u} {W : Type v}

abbrev Vertex (V : Type u) (w : V → ℕ) (q : ℕ) :=
  V ⊕ ((Σ x : V, Fin (w x)) ⊕ (Unit ⊕ Fin q))

def base {w : V → ℕ} {q : ℕ} (x : V) : Vertex V w q := .inl x
def mark {w : V → ℕ} {q : ℕ} (x : V) (i : Fin (w x)) : Vertex V w q :=
  .inr (.inl ⟨x,i⟩)
def hub {w : V → ℕ} {q : ℕ} : Vertex V w q := .inr (.inr (.inl ()))
def pad {w : V → ℕ} {q : ℕ} (i : Fin q) : Vertex V w q := .inr (.inr (.inr i))

def owner {w : V → ℕ} {q : ℕ} : Vertex V w q → Option V
  | .inl x => some x
  | .inr (.inl x) => some x.1
  | _ => none

def Adj (G : SimpleGraph V) (w : V → ℕ) (q : ℕ) :
    Vertex V w q → Vertex V w q → Prop
  | .inl x, .inl y => G.Adj x y
  | .inl x, .inr (.inl y) => x = y.1
  | .inr (.inl x), .inl y => x.1 = y
  | .inr (.inr (.inl _)), y => y ≠ hub
  | x, .inr (.inr (.inl _)) => x ≠ hub
  | _, _ => False

def graph (G : SimpleGraph V) (w : V → ℕ) (q : ℕ) :
    SimpleGraph (Vertex V w q) where
  Adj := Adj G w q
  symm := ⟨by
    intro x y h
    rcases x with x | x | x | x <;> rcases y with y | y | y | y
    · exact h.symm
    all_goals simpa [Adj, hub, eq_comm] using h⟩
  loopless := ⟨by
    intro x
    rcases x with x | x
    · exact fun h => G.ne_of_adj h rfl
    · rcases x with x | x
      · exact id
      · rcases x with x | x <;> simp [Adj, hub]⟩

@[simp] theorem adj_base_base (G : SimpleGraph V) (w : V → ℕ) (q : ℕ) (x y : V) :
    (graph G w q).Adj (base x) (base y) ↔ G.Adj x y := Iff.rfl

@[simp] theorem adj_hub (G : SimpleGraph V) (w : V → ℕ) (q : ℕ)
    (x : Vertex V w q) : (graph G w q).Adj hub x ↔ x ≠ hub := by
  rcases x with x | x
  · simp [graph, Adj, hub]
  · rcases x with x | x
    · simp [graph, Adj, hub]
    · rcases x with x | x <;> simp [graph, Adj, hub]

theorem diameter_two (G : SimpleGraph V) (w : V → ℕ) (q : ℕ)
    (x y : Vertex V w q) :
    x = y ∨ (graph G w q).Adj x y ∨
      ∃ z, (graph G w q).Adj x z ∧ (graph G w q).Adj z y := by
  by_cases he : x = y
  · exact Or.inl he
  by_cases hx : x = hub
  · exact Or.inr (Or.inl (hx ▸ (adj_hub G w q y).mpr (Ne.symm (hx ▸ he))))
  by_cases hy : y = hub
  · exact Or.inr (Or.inl (hy ▸ ((adj_hub G w q x).mpr hx).symm))
  exact Or.inr (Or.inr ⟨hub, ((adj_hub G w q x).mpr hx).symm,
    (adj_hub G w q y).mpr hy⟩)

theorem connected (G : SimpleGraph V) (w : V → ℕ) (q : ℕ) :
    (graph G w q).Connected := by
  haveI : Nonempty (Vertex V w q) := ⟨hub⟩
  refine ⟨?_⟩
  intro x y
  rcases diameter_two G w q x y with h | h | ⟨z,hx,hy⟩
  · exact h ▸ SimpleGraph.Reachable.refl x
  · exact h.reachable
  · exact hx.reachable.trans hy.reachable

def liftEquiv (w : V → ℕ) (w' : W → ℕ) (q : ℕ)
    (e : V ≃ W) (hw : ∀ x, w x = w' (e x)) :
    Vertex V w q ≃ Vertex W w' q :=
  Equiv.sumCongr e (Equiv.sumCongr
    (Equiv.sigmaCongr e (fun x => finCongr (hw x)))
    (Equiv.refl _))

@[simp] theorem liftEquiv_base (w : V → ℕ) (w' : W → ℕ) (q : ℕ)
    (e : V ≃ W) (hw : ∀ x, w x = w' (e x)) (x : V) :
    liftEquiv w w' q e hw (base x) = base (e x) := rfl

@[simp] theorem liftEquiv_hub (w : V → ℕ) (w' : W → ℕ) (q : ℕ)
    (e : V ≃ W) (hw : ∀ x, w x = w' (e x)) :
    liftEquiv w w' q e hw hub = hub := rfl

theorem order [Fintype V] (w : V → ℕ) (q : ℕ) :
    Nat.card (Vertex V w q) =
      Fintype.card V + (∑ x, w x) + 1 + q := by
  simp [Vertex, Nat.card_eq_fintype_card, Fintype.card_sigma, add_assoc]

def baseNeighbors (G : SimpleGraph V) (w : V → ℕ) (q : ℕ) (x : V) :
    {y // (graph G w q).Adj (base x) y} ≃
      ({y // G.Adj x y} ⊕ (Fin (w x) ⊕ Unit)) where
  toFun := by
    rintro ⟨y,hy⟩
    rcases y with y | ⟨y,i⟩ | y | y
    · exact .inl ⟨y,hy⟩
    · change x = y at hy
      subst y
      exact .inr (.inl i)
    · exact .inr (.inr ())
    · exact False.elim hy
  invFun := by
    rintro (y | i | u)
    · exact ⟨base y.val, y.property⟩
    · exact ⟨mark x i, rfl⟩
    · exact ⟨hub, by simp [graph, Adj, base, hub]⟩
  left_inv := by
    rintro ⟨y,hy⟩
    rcases y with y | ⟨y,i⟩ | y | y
    · rfl
    · change x = y at hy
      subst y
      rfl
    · cases y; rfl
    · exact False.elim hy
  right_inv := by
    rintro (y | i | u)
    · rfl
    · rfl
    · cases u; rfl

theorem degree_base [Fintype V] (G : SimpleGraph V) (w : V → ℕ) (q : ℕ) (x : V) :
    Game.degree (graph G w q) (base x) = Game.degree G x + w x + 1 := by
  rw [Game.degree, Nat.card_congr (baseNeighbors G w q x)]
  simp [Game.degree, Nat.card_eq_fintype_card, add_assoc]

def markNeighbors (G : SimpleGraph V) (w : V → ℕ) (q : ℕ)
    (x : V) (i : Fin (w x)) :
    {y // (graph G w q).Adj (mark x i) y} ≃ (Unit ⊕ Unit) where
  toFun := by
    rintro ⟨y,hy⟩
    rcases y with y | y | y | y
    · exact .inl ()
    · exact False.elim hy
    · exact .inr ()
    · exact False.elim hy
  invFun := by
    rintro (u | u)
    · exact ⟨base x,rfl⟩
    · exact ⟨hub,by simp [graph, Adj, mark, hub]⟩
  left_inv := by
    rintro ⟨y,hy⟩
    rcases y with y | y | y | y
    · change x = y at hy
      subst y
      rfl
    · exact False.elim hy
    · cases y; rfl
    · exact False.elim hy
  right_inv := by rintro (u | u) <;> cases u <;> rfl

theorem degree_mark (G : SimpleGraph V) (w : V → ℕ) (q : ℕ)
    (x : V) (i : Fin (w x)) :
    Game.degree (graph G w q) (mark x i) = 2 := by
  rw [Game.degree, Nat.card_congr (markNeighbors G w q x i)]
  simp

def padNeighbors (G : SimpleGraph V) (w : V → ℕ) (q : ℕ) (i : Fin q) :
    {y // (graph G w q).Adj (pad i) y} ≃ Unit where
  toFun := fun _ => ()
  invFun := fun _ => ⟨hub,by simp [graph, Adj, pad, hub]⟩
  left_inv := by
    rintro ⟨y,hy⟩
    rcases y with y | y | y | y
    · exact False.elim hy
    · exact False.elim hy
    · cases y; rfl
    · exact False.elim hy
  right_inv := fun _ => Subsingleton.elim _ _

theorem degree_pad (G : SimpleGraph V) (w : V → ℕ) (q : ℕ) (i : Fin q) :
    Game.degree (graph G w q) (pad i) = 1 := by
  rw [Game.degree, Nat.card_congr (padNeighbors G w q i)]
  simp

def hubNeighbors (G : SimpleGraph V) (w : V → ℕ) (q : ℕ) :
    {y // (graph G w q).Adj hub y} ≃
      (V ⊕ ((Σ x : V, Fin (w x)) ⊕ Fin q)) where
  toFun := by
    rintro ⟨y,hy⟩
    rcases y with y | y | y | y
    · exact .inl y
    · exact .inr (.inl y)
    · exact False.elim ((adj_hub G w q _).mp hy (by cases y; rfl))
    · exact .inr (.inr y)
  invFun := by
    rintro (y | y | y)
    · exact ⟨base y,(adj_hub G w q _).mpr (by simp [base,hub])⟩
    · exact ⟨mark y.1 y.2,(adj_hub G w q _).mpr (by simp [mark,hub])⟩
    · exact ⟨pad y,(adj_hub G w q _).mpr (by simp [pad,hub])⟩
  left_inv := by
    rintro ⟨y,hy⟩
    rcases y with y | y | y | y
    · rfl
    · rfl
    · exact False.elim ((adj_hub G w q _).mp hy (by cases y; rfl))
    · rfl
  right_inv := by rintro (y | ⟨y,i⟩ | y) <;> rfl

theorem degree_hub [Fintype V] (G : SimpleGraph V) (w : V → ℕ) (q : ℕ) :
    Game.degree (graph G w q) hub = Fintype.card V + (∑ x, w x) + q := by
  rw [Game.degree, Nat.card_congr (hubNeighbors G w q)]
  simp [Nat.card_eq_fintype_card, Fintype.card_sigma, add_assoc]

theorem base_degree_bounds [Fintype V] (G : SimpleGraph V) (w : V → ℕ)
    (q : ℕ) (x : V) :
    w x + 1 ≤ Game.degree (graph G w q) (base x) ∧
      Game.degree (graph G w q) (base x) ≤ w x + Fintype.card V := by
  classical
  let f : {y // G.Adj x y} ⊕ Unit → V :=
    fun y => match y with | .inl y => y.val | .inr _ => x
  have hf : Function.Injective f := by
    rintro (a | a) (b | b) h
    · exact congrArg Sum.inl (Subtype.ext h)
    · exact False.elim (G.ne_of_adj a.property h.symm)
    · exact False.elim (G.ne_of_adj b.property h)
    · simp
  have hc := Nat.card_le_card_of_injective f hf
  have hc' : Game.degree G x + 1 ≤ Fintype.card V := by
    simpa [f, Game.degree, Nat.card_eq_fintype_card] using hc
  rw [degree_base]
  omega

theorem base_degree_lt_hub [Fintype V] (G : SimpleGraph V) (w : V → ℕ)
    (q : ℕ) (hN : 2 ≤ Fintype.card V) (hw : ∀ x, 0 < w x) (x : V) :
    Game.degree (graph G w q) (base x) < Game.degree (graph G w q) hub := by
  classical
  haveI : Nontrivial V := Fintype.one_lt_card_iff_nontrivial.mp (by omega)
  obtain ⟨y,hy⟩ := exists_ne x
  have hs : w x + w y ≤ ∑ z, w z := by
    calc
      w x + w y = ∑ z ∈ ({x,y} : Finset V), w z := by simp [hy, Ne.symm hy]
      _ ≤ ∑ z, w z := Finset.sum_le_sum_of_subset (by simp)
  have hb := (base_degree_bounds G w q x).2
  rw [degree_hub]
  have := hw y
  omega

theorem degree_hub_congr (G : SimpleGraph V) (H : SimpleGraph W)
    (w : V → ℕ) (w' : W → ℕ) (q : ℕ)
    (e : V ≃ W) (hw : ∀ x, w x = w' (e x)) :
    Game.degree (graph G w q) hub = Game.degree (graph H w' q) hub := by
  apply Nat.card_congr
  apply Equiv.subtypeEquiv (liftEquiv w w' q e hw)
  intro x
  rw [adj_hub,adj_hub]
  have he := (liftEquiv w w' q e hw).injective.ne_iff (x := x) (y := hub)
  simpa only [liftEquiv_hub] using he.symm

@[simp] theorem liftEquiv_mark (w : V → ℕ) (w' : W → ℕ) (q : ℕ)
    (e : V ≃ W) (hw : ∀ x, w x = w' (e x)) (x : V) (i : Fin (w x)) :
    liftEquiv w w' q e hw (mark x i) = mark (e x) (finCongr (hw x) i) := rfl

@[simp] theorem liftEquiv_pad (w : V → ℕ) (w' : W → ℕ) (q : ℕ)
    (e : V ≃ W) (hw : ∀ x, w x = w' (e x)) (i : Fin q) :
    liftEquiv w w' q e hw (pad i) = pad i := rfl

theorem liftEquiv_adj (G : SimpleGraph V) (H : SimpleGraph W)
    (w : V → ℕ) (w' : W → ℕ) (q : ℕ)
    (e : V ≃ W) (hw : ∀ x, w x = w' (e x))
    (x y : Vertex V w q)
    (hbase : ∀ a b, x = base a → y = base b → (G.Adj a b ↔ H.Adj (e a) (e b))) :
    (graph G w q).Adj x y ↔
      (graph H w' q).Adj (liftEquiv w w' q e hw x) (liftEquiv w w' q e hw y) := by
  rcases x with x | ⟨x,i⟩ | x | x <;> rcases y with y | ⟨y,j⟩ | y | y
  · exact hbase x y rfl rfl
  all_goals simp [graph, Adj, liftEquiv, Equiv.sigmaCongr, hub, e.injective.eq_iff]

theorem recognize [Fintype V] [Fintype W] {B : Type*}
    (G : SimpleGraph V) (H : SimpleGraph W)
    (c : V → B) (d : W → B) (j : B → ℕ)
    (hj : Function.Injective j) (hpos : ∀ b, 0 < j b)
    (w : V → ℕ) (w' : W → ℕ) (q : ℕ)
    (hw : ∀ x, w x = j (c x) * (Fintype.card V + 1))
    (hw' : ∀ y, w' y = j (d y) * (Fintype.card V + 1))
    (e : V ≃ W) (he : ∀ x, w x = w' (e x))
    (hN : 2 ≤ Fintype.card V) {K : ℕ} (hK : 2 ≤ K)
    {p : Game.Position (Vertex V w q) (Vertex W w' q)}
    (hp : Game.Winning (graph G w q) (graph H w' q) K p)
    {x : V} {y : Vertex W w' q} (hxy : (base x,y) ∈ p) :
    ∃ z, y = base z ∧ c x = d z := by
  have hd := hp.degree hK hxy
  have hcard := Fintype.card_congr e
  have hb := base_degree_bounds G w q x
  have hxpos := hpos (c x)
  have hwx := hw x
  have hlo : 2 < Game.degree (graph G w q) (base x) := by
    have hm := Nat.mul_le_mul_right (Fintype.card V + 1) hxpos
    nlinarith
  rcases y with z | ⟨z,i⟩ | u | i
  · refine ⟨z,rfl,hj ?_⟩
    change Game.degree (graph G w q) (base x) = Game.degree (graph H w' q) (base z) at hd
    have hz := base_degree_bounds H w' q z
    have hwz := hw' z
    by_contra hn
    rcases lt_or_gt_of_ne hn with h | h
    · have hm := Nat.mul_le_mul_right (Fintype.card V + 1) (Nat.succ_le_iff.mpr h)
      rw [← hcard] at hz
      nlinarith
    · have hm := Nat.mul_le_mul_right (Fintype.card V + 1) (Nat.succ_le_iff.mpr h)
      rw [← hcard] at hz
      nlinarith
  · change Game.degree (graph G w q) (base x) = Game.degree (graph H w' q) (mark z i) at hd
    rw [degree_mark] at hd
    omega
  · cases u
    have hh := degree_hub_congr G H w w' q e he
    have hs := base_degree_lt_hub G w q hN
      (fun z => by rw [hw]; exact Nat.mul_pos (hpos _) (by omega)) x
    change Game.degree (graph G w q) (base x) = Game.degree (graph H w' q) hub at hd
    omega
  · change Game.degree (graph G w q) (base x) = Game.degree (graph H w' q) (pad i) at hd
    rw [degree_pad] at hd
    omega

end Marks

namespace Construction

set_option backward.isDefEq.respectTransparency false
set_option linter.unusedSectionVars false

open ProjectionAudit.VariableWL
open ProjectionAudit.VariableWL.Affine ProjectionAudit.VariableWL.Subdivision
open ProjectionAudit.VariableWL.Blocks
open scoped CharTwo

variable {m r n : ℕ} {P E : Type*}
variable (J : ProductImages.Instance m r P E) (marked : Fin r)

abbrev Base (ε : Bit) := Σ b : Block (n := n) J, Valuation J marked ε b

instance baseFintype [Fintype P] [Fintype E] (ε : Bit) :
    Fintype (Base (n := n) J marked ε) := inferInstance

def baseGraph (ε : Bit) : SimpleGraph (Base (n := n) J marked ε) where
  Adj x y := x.1 ≠ y.1 ∧
    (∃ a, HasReadout J x.1.val a ∧ HasReadout J y.1.val a) ∧
    ∀ a (hx : HasReadout J x.1.val a) (hy : HasReadout J y.1.val a),
      readout J x.2.val hx = readout J y.2.val hy
  symm := ⟨by
    rintro x y ⟨h,hs,he⟩
    exact ⟨Ne.symm h,hs.elim (fun a ha => ⟨a,ha.2,ha.1⟩),
      fun a hx hy => (he a hy hx).symm⟩⟩
  loopless := ⟨fun _ h => h.1 rfl⟩

def zeroVertex (b : Block (n := n) J) : Base (n := n) J marked 0 :=
  ⟨b,⟨0,legal_zero J marked b.val⟩⟩

def defaultOffset (b : Block (n := n) J) : Valuation J marked 1 b :=
  ⟨(legal_nonempty J marked 1 b.val).choose,
    (legal_nonempty J marked 1 b.val).choose_spec⟩

def baseEquiv (τ : ∀ b : Block (n := n) J, Valuation J marked 1 b) :
    Base (n := n) J marked 0 ≃ Base (n := n) J marked 1 :=
  Equiv.sigmaCongr (Equiv.refl _) (fun b => translateValuation J marked b (τ b))

@[simp] theorem baseEquiv_apply (τ : ∀ b : Block (n := n) J, Valuation J marked 1 b)
    (b : Block (n := n) J) (z : Valuation J marked 0 b) :
    baseEquiv J marked τ ⟨b,z⟩ = ⟨b,translateValuation J marked b (τ b) z⟩ := rfl

theorem translation_adj (hr : 3 ≤ r) (hn : 0 < n)
    (F : ReadoutValues (n := n) J)
    (τ : ∀ b : Block (n := n) J, Valuation J marked 1 b)
    (b c : Block (n := n) J) (x : Valuation J marked 0 b) (y : Valuation J marked 0 c)
    (hb : (τ b).val = valueOfReadouts J F b.val)
    (hc : (τ c).val = valueOfReadouts J F c.val) :
    (baseGraph J marked 0).Adj ⟨b,x⟩ ⟨c,y⟩ ↔
      (baseGraph J marked 1).Adj (baseEquiv J marked τ ⟨b,x⟩)
        (baseEquiv J marked τ ⟨c,y⟩) := by
  have he (a) (ha : HasReadout J b.val a) (ha' : HasReadout J c.val a) :
      readout J (x.val + (τ b).val) ha = readout J (y.val + (τ c).val) ha' ↔
        readout J x.val ha = readout J y.val ha' := by
    rw [readout_add J (by omega) hn, readout_add J (by omega) hn,
      hb,hc,readout_valueOfReadouts J (by omega) hn,
      readout_valueOfReadouts J (by omega) hn,add_right_cancel_iff]
  change (b ≠ c ∧ _ ∧ _) ↔ (b ≠ c ∧ _ ∧ _)
  constructor
  · rintro ⟨h,hs,hv⟩
    exact ⟨h,hs,fun a ha ha' => (he a ha ha').mpr (hv a ha ha')⟩
  · rintro ⟨h,hs,hv⟩
    exact ⟨h,hs,fun a ha ha' => (he a ha ha').mp (hv a ha ha')⟩

variable [Fintype P] [Fintype E]

def number (b : Block (n := n) J) : ℕ :=
  (Fintype.equivFin (Block (n := n) J) b).val + 1

theorem number_pos (b : Block (n := n) J) : 0 < number J b := by
  simp [number]

theorem number_injective : Function.Injective (number (n := n) J) := by
  intro b c h
  apply (Fintype.equivFin _).injective
  apply Fin.ext
  simpa [number] using h

def weight (ε : Bit) (x : Base (n := n) J marked ε) : ℕ :=
  number J x.1 * (Fintype.card (Base (n := n) J marked 0) + 1)

abbrev Vertex (ε : Bit) (q : ℕ) := Marks.Vertex (Base (n := n) J marked ε) (weight J marked ε) q

def graph (ε : Bit) (q : ℕ) : SimpleGraph (Vertex (n := n) J marked ε q) :=
  Marks.graph (baseGraph J marked ε) (weight J marked ε) q

def fullEquiv (q : ℕ) (τ : ∀ b : Block (n := n) J, Valuation J marked 1 b) :
    Vertex (n := n) J marked 0 q ≃ Vertex (n := n) J marked 1 q :=
  Marks.liftEquiv (weight J marked 0) (weight J marked 1) q
    (baseEquiv J marked τ) (fun _ => rfl)

@[simp] theorem fullEquiv_base (q : ℕ)
    (τ : ∀ b : Block (n := n) J, Valuation J marked 1 b)
    (b : Block (n := n) J) (z : Valuation J marked 0 b) :
    fullEquiv J marked q τ (Marks.base ⟨b,z⟩) =
      Marks.base ⟨b,translateValuation J marked b (τ b) z⟩ := rfl

@[simp] theorem fullEquiv_mark (q : ℕ)
    (τ : ∀ b : Block (n := n) J, Valuation J marked 1 b)
    (b : Block (n := n) J) (z : Valuation J marked 0 b)
    (i : Fin (weight J marked 0 ⟨b,z⟩)) :
    fullEquiv J marked q τ (Marks.mark ⟨b,z⟩ i) =
      Marks.mark ⟨b,translateValuation J marked b (τ b) z⟩ i := rfl

@[simp] theorem fullEquiv_hub (q : ℕ)
    (τ : ∀ b : Block (n := n) J, Valuation J marked 1 b) :
    fullEquiv J marked q τ Marks.hub = Marks.hub := rfl

@[simp] theorem fullEquiv_pad (q : ℕ)
    (τ : ∀ b : Block (n := n) J, Valuation J marked 1 b) (i : Fin q) :
    fullEquiv J marked q τ (Marks.pad i) = Marks.pad i := rfl

def blockOf {q : ℕ} (x : Vertex (n := n) J marked 0 q) : Option (Block (n := n) J) :=
  (Marks.owner x).map Sigma.fst

def active {q : ℕ} (p : Game.Position (Vertex (n := n) J marked 0 q) (Vertex (n := n) J marked 1 q)) :
    Finset (Block (n := n) J) := by
  classical
  exact p.biUnion (fun a => (blockOf J marked a.1).toFinset)

theorem mem_active {q : ℕ}
    {p : Game.Position (Vertex (n := n) J marked 0 q) (Vertex (n := n) J marked 1 q)}
    {a} (ha : a ∈ p) {b} (hb : blockOf J marked a.1 = some b) :
    b ∈ active J marked p := by
  classical
  simp only [active,Finset.mem_biUnion]
  exact ⟨a,ha,by simp [hb]⟩

theorem active_mono {q : ℕ}
    {p s : Game.Position (Vertex (n := n) J marked 0 q) (Vertex (n := n) J marked 1 q)}
    (hs : s ⊆ p) : active J marked s ⊆ active J marked p := by
  classical
  intro b hb
  rcases Finset.mem_biUnion.mp hb with ⟨a,ha,hb⟩
  exact Finset.mem_biUnion.mpr ⟨a,hs ha,hb⟩

theorem active_card {q : ℕ}
    (p : Game.Position (Vertex (n := n) J marked 0 q) (Vertex (n := n) J marked 1 q)) :
    (active J marked p).card ≤ p.card := by
  classical
  calc
    _ ≤ ∑ a ∈ p, (blockOf J marked a.1).toFinset.card := Finset.card_biUnion_le
    _ ≤ ∑ _a ∈ p, 1 := Finset.sum_le_sum (fun a _ => by
      cases blockOf J marked a.1 <;> simp)
    _ = p.card := by simp

theorem active_insert {q : ℕ}
    (p : Game.Position (Vertex (n := n) J marked 0 q) (Vertex (n := n) J marked 1 q))
    (x : Vertex (n := n) J marked 0 q) (y : Vertex (n := n) J marked 1 q) :
    active J marked (insert (x,y) p) =
      (blockOf J marked x).toFinset ∪ active J marked p := by
  classical
  exact Finset.biUnion_insert

theorem fullEquiv_congr {q : ℕ}
    (τ υ : ∀ b : Block (n := n) J, Valuation J marked 1 b)
    (x : Vertex (n := n) J marked 0 q)
    (h : ∀ b, blockOf J marked x = some b → τ b = υ b) :
    fullEquiv J marked q τ x = fullEquiv J marked q υ x := by
  rcases x with ⟨b,z⟩ | ⟨⟨b,z⟩,i⟩ | u | i
  · change Marks.base (w := weight J marked 1) (q := q)
        ⟨b,translateValuation J marked b (τ b) z⟩ =
      Marks.base ⟨b,translateValuation J marked b (υ b) z⟩
    rw [h b rfl]
  · change Marks.mark (w := weight J marked 1) (q := q)
        ⟨b,translateValuation J marked b (τ b) z⟩ i =
      Marks.mark ⟨b,translateValuation J marked b (υ b) z⟩ i
    rw [h b rfl]
  · cases u; rfl
  · rfl

def Safe (hr : 3 ≤ r) (hn : 0 < n) (Q : J.Witness) (q : ℕ)
    (p : Game.Position (Vertex (n := n) J marked 0 q) (Vertex (n := n) J marked 1 q)) : Prop :=
  p.card ≤ r+1 ∧ ∃ F : ReadoutValues (n := n) J,
    OffsetFamily J hr hn marked Q (active J marked p) F ∧
    ∃ τ : ∀ b : Block (n := n) J, Valuation J marked 1 b,
      (∀ b ∈ active J marked p, (τ b).val = valueOfReadouts J F b.val) ∧
      ∀ a ∈ p, a.2 = fullEquiv J marked q τ a.1

theorem safe_partialIso (hr : 3 ≤ r) (hn : 0 < n) (Q : J.Witness) (q : ℕ)
    {p : Game.Position (Vertex (n := n) J marked 0 q) (Vertex (n := n) J marked 1 q)}
    (hp : Safe J marked hr hn Q q p) :
    Game.PartialIso (graph J marked 0 q) (graph J marked 1 q) p := by
  obtain ⟨_,F,_,τ,hτ,he⟩ := hp
  intro a ha b hb
  rw [he a ha,he b hb]
  refine ⟨(fullEquiv J marked q τ).injective.eq_iff.symm, ?_⟩
  apply Marks.liftEquiv_adj
  intro x y hx hy
  obtain ⟨bx,zx⟩ := x
  obtain ⟨by',zy⟩ := y
  exact translation_adj J marked hr hn F τ bx by' zx zy
    (hτ bx (mem_active J marked ha (by rw [hx]; rfl)))
    (hτ by' (mem_active J marked hb (by rw [hy]; rfl)))

theorem safe_discard (hr : 3 ≤ r) (hn : 0 < n) (hlarge : r+1 < n+1)
    (Q : J.Witness) (q : ℕ)
    {p s : Game.Position (Vertex (n := n) J marked 0 q) (Vertex (n := n) J marked 1 q)}
    (hp : Safe J marked hr hn Q q p) (hs : s ⊆ p) :
    Safe J marked hr hn Q q s := by
  obtain ⟨hcard,F,hF,τ,hτ,he⟩ := hp
  have hsub := active_mono J marked hs
  refine ⟨(Finset.card_le_card hs).trans hcard,F,?_,τ,?_,?_⟩
  · exact offsetFamily_restrict J hr hn hlarge marked Q
      (active J marked p) (active J marked s)
      ((active_card J marked p).trans hcard) hsub hF
  · exact fun b hb => hτ b (hsub hb)
  · exact fun a ha => he a (hs ha)

theorem safe_announce (hr : 3 ≤ r) (hn : 0 < n) (hlarge : r+1 < n+1)
    (Q : J.Witness) (q : ℕ)
    {p : Game.Position (Vertex (n := n) J marked 0 q) (Vertex (n := n) J marked 1 q)}
    (hp : Safe J marked hr hn Q q p) (hcard : p.card < r+1) :
    ∃ e : Vertex (n := n) J marked 0 q ≃ Vertex (n := n) J marked 1 q,
      ∀ x, Safe J marked hr hn Q q (insert (x,e x) p) := by
  obtain ⟨_,F,hF,τ,hτ,he⟩ := hp
  let U := active J marked p
  have hU : U.card ≤ r := by
    change (active J marked p).card ≤ r
    have := active_card J marked p
    omega
  have ext (b : Block (n := n) J) :
      ∃ G : ReadoutValues (n := n) J,
        OffsetFamily J hr hn marked Q (insert b U) G ∧
        ∀ c ∈ U, ∀ a, HasReadout J c.val a → G a = F a := by
    apply (offsetFamily_exact_projection J hr hn hlarge marked Q (insert b U) U
      ((Finset.card_insert_le _ _).trans (by omega)) (by simp)).mp hF
  choose G hG hGF using ext
  let υ : ∀ b : Block (n := n) J, Valuation J marked 1 b := fun b =>
    ⟨valueOfReadouts J (G b) b.val,
      offsetFamily_legal J hr hn marked Q (insert b U) (hG b) (by simp)⟩
  have hυ (b : Block (n := n) J) (hb : b ∈ U) :
      (υ b).val = valueOfReadouts J F b.val :=
    valueOfReadouts_congr J (fun a ha => hGF b b hb a ha)
  have hυτ (b : Block (n := n) J) (hb : b ∈ U) : υ b = τ b :=
    Subtype.ext ((hυ b hb).trans (hτ b hb).symm)
  have hold (a) (ha : a ∈ p) : a.2 = fullEquiv J marked q υ a.1 := by
    rw [he a ha]
    exact (fullEquiv_congr J marked υ τ a.1
      (fun b hb => hυτ b (mem_active J marked ha hb))).symm
  refine ⟨fullEquiv J marked q υ, ?_⟩
  intro x
  have hnew : (insert (x,fullEquiv J marked q υ x) p).card ≤ r+1 :=
    (Finset.card_insert_le _ _).trans (by omega)
  have hmatch : ∀ a ∈ insert (x,fullEquiv J marked q υ x) p,
      a.2 = fullEquiv J marked q υ a.1 := by
    intro a ha
    rcases Finset.mem_insert.mp ha with rfl | ha
    · rfl
    · exact hold a ha
  cases hx : blockOf J marked x with
  | none =>
    have hactive : active J marked (insert (x,fullEquiv J marked q υ x) p) = U := by
      rw [active_insert,hx]
      simp [U]
    refine ⟨hnew,F,?_,υ,?_,hmatch⟩
    · simpa only [hactive] using hF
    · intro b hb
      exact hυ b (hactive ▸ hb)
  | some b =>
    have hactive : active J marked (insert (x,fullEquiv J marked q υ x) p) = insert b U := by
      rw [active_insert,hx]
      simp [U]
    refine ⟨hnew,G b,?_,υ,?_,hmatch⟩
    · simpa only [hactive] using hG b
    · intro c hc
      rw [hactive] at hc
      rcases Finset.mem_insert.mp hc with rfl | hc
      · rfl
      · exact (hυ c hc).trans
          (valueOfReadouts_congr J (fun a ha => (hGF b c hc a ha).symm))

theorem consistency_implies_game (hr : 3 ≤ r) (hn : 0 < n) (hlarge : r+1 < n+1)
    (q : ℕ) (hconsistent : J.Consistent) :
    Game.Equivalent (graph (n := n) J marked 0 q) (graph (n := n) J marked 1 q) (r+1) := by
  obtain ⟨Q⟩ := hconsistent
  refine ⟨{p | Safe J marked hr hn Q q p},⟨?_,?_,?_⟩,?_⟩
  · exact fun _ hp => safe_partialIso J marked hr hn Q q hp
  · exact fun _ hp _ hs => safe_discard J marked hr hn hlarge Q q hp hs
  · exact fun _ hp hc => safe_announce J marked hr hn hlarge Q q hp hc
  · obtain ⟨F,hF⟩ := offsetFamily_nonempty J hr hn hlarge marked Q ∅ (by simp)
    refine ⟨by simp,F,?_,defaultOffset J marked,?_,?_⟩
    · simpa [active] using hF
    · simp [active]
    · simp

theorem winning_block (q : ℕ) (hN : 2 ≤ Fintype.card (Base (n := n) J marked 0))
    (hr : 3 ≤ r)
    {p : Game.Position (Vertex (n := n) J marked 0 q) (Vertex (n := n) J marked 1 q)}
    (hp : Game.Winning (graph J marked 0 q) (graph J marked 1 q) (r+1) p)
    {b : Block (n := n) J} {z : Valuation J marked 0 b} {y : Vertex (n := n) J marked 1 q}
    (hxy : (Marks.base ⟨b,z⟩,y) ∈ p) :
    ∃ ξ : Valuation J marked 1 b, y = Marks.base ⟨b,ξ⟩ := by
  obtain ⟨⟨c,ξ⟩,hy,hbc⟩ := Marks.recognize
    (baseGraph J marked 0) (baseGraph J marked 1)
    Sigma.fst Sigma.fst (number J) (number_injective J) (number_pos J)
    (weight J marked 0) (weight J marked 1) q
    (fun _ => rfl) (fun _ => rfl)
    (baseEquiv J marked (defaultOffset J marked)) (fun _ => rfl) hN (by omega) hp hxy
  cases hbc
  exact ⟨ξ,hy⟩

def queryPair (F : ReadoutValues (n := n) J) (b : Block (n := n) J)
    (hb : LegalValue J marked 1 b.val (valueOfReadouts J F b.val)) (q : ℕ) :
    Vertex (n := n) J marked 0 q × Vertex (n := n) J marked 1 q :=
  (Marks.base (zeroVertex J marked b), Marks.base ⟨b,⟨valueOfReadouts J F b.val,hb⟩⟩)

def query (U : Finset (Block (n := n) J)) (F : ReadoutValues (n := n) J)
    (hlegal : ∀ b ∈ U, LegalValue J marked 1 b.val (valueOfReadouts J F b.val)) (q : ℕ) :
    Game.Position (Vertex (n := n) J marked 0 q) (Vertex (n := n) J marked 1 q) :=
  U.attach.image (fun b => queryPair J marked F b.val (hlegal b.val b.property) q)

theorem mem_query {U : Finset (Block (n := n) J)} {F : ReadoutValues (n := n) J}
    {hlegal} {q : ℕ} {a} :
    a ∈ query J marked U F hlegal q ↔
      ∃ (b : Block (n := n) J) (hb : b ∈ U), a = queryPair J marked F b (hlegal b hb) q := by
  constructor
  · intro ha
    obtain ⟨b,_,h⟩ := Finset.mem_image.mp ha
    exact ⟨b.val,b.property,h.symm⟩
  · rintro ⟨b,hb,rfl⟩
    exact Finset.mem_image.mpr ⟨⟨b,hb⟩,by simp,rfl⟩

theorem query_card (U : Finset (Block (n := n) J)) (F : ReadoutValues (n := n) J)
    (hlegal) (q : ℕ) : (query J marked U F hlegal q).card ≤ U.card := by
  exact Finset.card_image_le.trans (by simp)

def Candidate (q : ℕ) (U : Finset (Block (n := n) J)) (F : ReadoutValues (n := n) J) : Prop :=
  ∃ hlegal : ∀ b ∈ U, LegalValue J marked 1 b.val (valueOfReadouts J F b.val),
    Game.Winning (graph J marked 0 q) (graph J marked 1 q) (r+1) (query J marked U F hlegal q)

theorem candidate_restrict {q : ℕ} {U V : Finset (Block (n := n) J)}
    {F : ReadoutValues (n := n) J} (hF : Candidate J marked q U F) (hVU : V ⊆ U) :
    Candidate J marked q V F := by
  obtain ⟨hlegal,hwin⟩ := hF
  refine ⟨fun b hb => hlegal b (hVU hb),hwin.discard ?_⟩
  intro a ha
  obtain ⟨b,hb,rfl⟩ := (mem_query J marked).mp ha
  exact (mem_query J marked).mpr ⟨b,hVU hb,rfl⟩

def patchReadouts (F : ReadoutValues (n := n) J) (b : Block (n := n) J)
    (z : RawValue J b.val) : ReadoutValues (n := n) J :=
  fun a => if ha : HasReadout J b.val a then readout J z ha else F a

theorem patch_value (hr : 3 ≤ r) (hn : 0 < n)
    (F : ReadoutValues (n := n) J) (b : Block (n := n) J) (z : RawValue J b.val) :
    valueOfReadouts J (patchReadouts J F b z) b.val = z := by
  have hf (a) (ha : HasReadout J b.val a) :
      patchReadouts J F b z a = readout J z ha := dif_pos ha
  obtain ⟨b,hb⟩ := b
  cases b with
  | inl h =>
    change patchReadouts J F ⟨.inl h,hb⟩ z (.inl h) = z
    rw [hf _ rfl]
    exact readout_eq J (by omega) hn (b := .inl h) (z := z) (a := .inl h)
      rfl ⟨rfl,HEq.rfl⟩
  | inr s =>
    apply Prod.ext
    · apply Prod.ext
      · change patchReadouts J F ⟨.inr s,hb⟩ z (.inl (squareLeft J s)) = z.1.1
        rw [hf _ (Or.inl rfl)]
        exact readout_eq J (by omega) hn _ (Or.inl ⟨rfl,HEq.rfl⟩)
      · change patchReadouts J F ⟨.inr s,hb⟩ z (.inl (squareRight J s)) = z.1.2
        rw [hf _ (Or.inr (Or.inl rfl))]
        exact readout_eq J (by omega) hn _ (Or.inr (Or.inl ⟨rfl,HEq.rfl⟩))
    · apply Prod.ext
      · change patchReadouts J F ⟨.inr s,hb⟩ z (.inr (squareBottom s)) = z.2.1
        rw [hf _ (Or.inr (Or.inr (Or.inl rfl)))]
        exact readout_eq J (by omega) hn _ (Or.inr (Or.inr (Or.inl ⟨rfl,HEq.rfl⟩)))
      · change patchReadouts J F ⟨.inr s,hb⟩ z (.inr (squareTop s)) = z.2.2
        rw [hf _ (Or.inr (Or.inr (Or.inr rfl)))]
        exact readout_eq J (by omega) hn _ (Or.inr (Or.inr (Or.inr ⟨rfl,HEq.rfl⟩)))

theorem candidate_extend (hr : 3 ≤ r) (hn : 0 < n) (q : ℕ)
    (hN : 2 ≤ Fintype.card (Base (n := n) J marked 0))
    {U : Finset (Block (n := n) J)} (hU : U.card ≤ r)
    {F : ReadoutValues (n := n) J} (hF : Candidate J marked q U F)
    (b : Block (n := n) J) :
    ∃ G : ReadoutValues (n := n) J, Candidate J marked q (insert b U) G ∧
      ∀ c ∈ U, ∀ a, HasReadout J c.val a → G a = F a := by
  by_cases hb : b ∈ U
  · exact ⟨F,by simpa [Finset.insert_eq_of_mem hb] using hF,fun _ _ _ _ => rfl⟩
  obtain ⟨hlegal,hwin⟩ := hF
  obtain ⟨e,he⟩ := hwin.announce ((query_card J marked U F hlegal q).trans_lt (by omega))
  let x : Vertex (n := n) J marked 0 q := Marks.base (zeroVertex J marked b)
  have hw := he x
  obtain ⟨ξ,hξ⟩ := winning_block J marked q hN hr hw (Finset.mem_insert_self _ _)
  let G := patchReadouts J F b ξ.val
  have hGF (c) (hc : c ∈ U) (a) (ha : HasReadout J c.val a) : G a = F a := by
    dsimp only [G,patchReadouts]
    split_ifs with hba
    · have hcb : c ≠ b := fun h => hb (h ▸ hc)
      have hsource : (graph J marked 0 q).Adj
          (Marks.base (zeroVertex J marked c)) x := by
        change (baseGraph J marked 0).Adj (zeroVertex J marked c) (zeroVertex J marked b)
        refine ⟨hcb,⟨a,ha,hba⟩,?_⟩
        intro v hv hv'
        exact (readout_zero J (by omega) hn hv).trans (readout_zero J (by omega) hn hv').symm
      have hpair : queryPair J marked F c (hlegal c hc) q ∈ query J marked U F hlegal q :=
        (mem_query J marked).mpr ⟨c,hc,rfl⟩
      have ht := ((hw.partialIso _ (Finset.mem_insert_of_mem hpair)
        (x,e x) (Finset.mem_insert_self _ _)).2.mp hsource)
      rw [hξ] at ht
      change (baseGraph J marked 1).Adj
        ⟨c,⟨valueOfReadouts J F c.val,hlegal c hc⟩⟩ ⟨b,ξ⟩ at ht
      exact (ht.2.2 a ha hba).symm.trans (readout_valueOfReadouts J (by omega) hn F ha)
    · rfl
  have hval (c) (hc : c ∈ U) :
      valueOfReadouts J G c.val = valueOfReadouts J F c.val :=
    valueOfReadouts_congr J (fun a ha => hGF c hc a ha)
  have hnewlegal : ∀ c ∈ insert b U, LegalValue J marked 1 c.val (valueOfReadouts J G c.val) := by
    intro c hc
    rcases Finset.mem_insert.mp hc with hcb | hc
    · subst c
      rw [show valueOfReadouts J G b.val = ξ.val from patch_value J hr hn F b ξ.val]
      exact ξ.property
    · rw [hval c hc]
      exact hlegal c hc
  refine ⟨G,⟨hnewlegal,?_⟩,hGF⟩
  apply hw.discard
  intro a ha
  obtain ⟨c,hc,rfl⟩ := (mem_query J marked).mp ha
  rcases Finset.mem_insert.mp hc with hcb | hc
  · subst c
    have hpair : queryPair J marked G b (hnewlegal b (by simp)) q = (x,e x) := by
      rw [hξ]
      apply congrArg (fun z : Valuation J marked 1 b =>
        (x,Marks.base (w := weight J marked 1) (q := q) ⟨b,z⟩))
      exact Subtype.ext (patch_value J hr hn F b ξ.val)
    exact hpair ▸ Finset.mem_insert_self _ _
  · apply Finset.mem_insert_of_mem
    have hpair : queryPair J marked G c (hnewlegal c (by simp [hc])) q =
        queryPair J marked F c (hlegal c hc) q := by
      apply congrArg (fun z : Valuation J marked 1 c =>
        (Marks.base (w := weight J marked 0) (q := q) (zeroVertex J marked c),
          Marks.base (w := weight J marked 1) (q := q) ⟨c,z⟩))
      exact Subtype.ext (hval c hc)
    rw [hpair]
    exact (mem_query J marked).mpr ⟨c,hc,rfl⟩

theorem candidate_nonempty (hr : 3 ≤ r) (hn : 0 < n) (q : ℕ)
    (hN : 2 ≤ Fintype.card (Base (n := n) J marked 0))
    (hwin : Game.Equivalent (graph (n := n) J marked 0 q) (graph (n := n) J marked 1 q) (r+1))
    (U : Finset (Block (n := n) J)) :
    U.card ≤ r+1 → ∃ F, Candidate J marked q U F := by
  induction U using Finset.induction_on with
  | empty =>
    intro _
    refine ⟨fun _ => 0,(by simp),?_⟩
    simpa [query,Game.Equivalent] using hwin
  | @insert b U hb ih =>
    intro hcard
    have hU : U.card ≤ r := by
      rw [Finset.card_insert_of_notMem hb] at hcard
      omega
    obtain ⟨F,hF⟩ := ih (by omega)
    obtain ⟨G,hG,_⟩ := candidate_extend J marked hr hn q hN hU hF b
    exact ⟨G,hG⟩

def occupied (A : Fin r → Block (n := n) J) : Finset (Block (n := n) J) :=
  Finset.univ.image A

def mixed (A B : Fin r → Block (n := n) J) (k : ℕ) (i : Fin r) : Block (n := n) J :=
  if i.val < k then B i else A i

theorem replace_cover (hr : 3 ≤ r) (hn : 0 < n) (q : ℕ)
    (hN : 2 ≤ Fintype.card (Base (n := n) J marked 0))
    (A B : Fin r → Block (n := n) J) (o : Fin r → Readout m r n P E)
    (ha : ∀ i, HasReadout J (A i).val (o i))
    (hb : ∀ i, HasReadout J (B i).val (o i))
    {F : ReadoutValues (n := n) J} (hF : Candidate J marked q (occupied J A) F) :
    ∃ G, Candidate J marked q (occupied J B) G ∧ ∀ i, G (o i) = F (o i) := by
  have step : ∀ k, k ≤ r →
      ∃ G, Candidate J marked q (occupied J (mixed J A B k)) G ∧
        ∀ i, G (o i) = F (o i) := by
    intro k
    induction k with
    | zero =>
      intro _
      have hz : mixed J A B 0 = A := funext (fun i => if_neg (Nat.not_lt_zero i.val))
      refine ⟨F,?_,fun _ => rfl⟩
      rw [hz]
      exact hF
    | succ k ih =>
      intro hk
      obtain ⟨G,hG,hGo⟩ := ih (by omega)
      let i : Fin r := ⟨k,by omega⟩
      have hcard : (occupied J (mixed J A B k)).card ≤ r :=
        Finset.card_image_le.trans (by simp)
      obtain ⟨T,hT,hTG⟩ := candidate_extend J marked hr hn q hN hcard hG (B i)
      have hsub : occupied J (mixed J A B (k+1)) ⊆
          insert (B i) (occupied J (mixed J A B k)) := by
        intro c hc
        obtain ⟨j,_,rfl⟩ := Finset.mem_image.mp hc
        by_cases hj : j.val = k
        · have hji : j = i := Fin.ext hj
          subst j
          simp [mixed,i]
        · have hm : mixed J A B (k+1) j = mixed J A B k j := by
            unfold mixed
            have he : j.val < k+1 ↔ j.val < k := by omega
            simp only [he]
          rw [hm]
          exact Finset.mem_insert_of_mem (Finset.mem_image.mpr ⟨j,by simp,rfl⟩)
      refine ⟨T,candidate_restrict J marked hT hsub,?_⟩
      intro j
      have ho : HasReadout J (mixed J A B k j).val (o j) := by
        unfold mixed
        split_ifs
        · exact hb j
        · exact ha j
      exact (hTG (mixed J A B k j) (Finset.mem_image.mpr ⟨j,by simp,rfl⟩) (o j) ho).trans (hGo j)
  obtain ⟨G,hG,hGo⟩ := step r le_rfl
  have he : mixed J A B r = B := funext (fun i => if_pos i.isLt)
  rw [he] at hG
  exact ⟨G,hG,hGo⟩

abbrev ringHorizontal (t : Subdivision.Vertex P E n) (a : ProductImages.Instance.Address m r)
    (i : Fin r) : Horizontal m r n P E :=
  ⟨i,t,a i,a (finRotate r i)⟩

def ringBlock (t : Subdivision.Vertex P E n) (a : ProductImages.Instance.Address m r)
    (ha : ∀ i, a i ∈ J.labels t i) (i : Fin r) : Block (n := n) J :=
  ⟨.inl (ringHorizontal t a i),⟨ha i,ha (finRotate r i)⟩⟩

def ringSum (t : Subdivision.Vertex P E n) (a : ProductImages.Instance.Address m r)
    (F : ReadoutValues (n := n) J) : Value J t :=
  ∑ i, F (.inl (ringHorizontal t a i))

abbrev targetAddress (l : Link E n) (a : ProductImages.Instance.Address m r) :
    ProductImages.Instance.Address m r :=
  fun i => matchOutput J l i (a i)

theorem left_allowed (l : Link E n) (a : ProductImages.Instance.Address m r)
    (ha : J.Allowed l.1 a) (i : Fin r) : a i ∈ J.labels (left J.source l) i :=
  J.matches_left l i ⟨ha i,rfl⟩

theorem right_allowed (l : Link E n) (a : ProductImages.Instance.Address m r)
    (ha : J.Allowed l.1 a) (i : Fin r) :
    targetAddress J l a i ∈ J.labels (right J.target l) i :=
  J.matches_right l i ⟨ha i,rfl⟩

def squareAt (l : Link E n) (a : ProductImages.Instance.Address m r) (i : Fin r) :
    Square m r n E := ⟨i,l,a i,a (finRotate r i)⟩

def squareBlock (l : Link E n) (a : ProductImages.Instance.Address m r)
    (ha : J.Allowed l.1 a) (i : Fin r) : Block (n := n) J :=
  ⟨.inr (squareAt l a i),⟨ha i,ha (finRotate r i)⟩⟩

theorem square_ring_equation (q : ℕ) (l : Link E n) (a : ProductImages.Instance.Address m r)
    (ha : J.Allowed l.1 a) {F : ReadoutValues (n := n) J}
    (hF : Candidate J marked q (occupied J (squareBlock J l a ha)) F) :
    linkLeft J l (ringSum J (left J.source l) a F) +
      linkRight J l (ringSum J (right J.target l) (targetAddress J l a) F) =
        linkConstant J l := by
  obtain ⟨hlegal,_⟩ := hF
  let X : Fin r → Value J (left J.source l) :=
    fun i => F (.inl (ringHorizontal (left J.source l) a i))
  let Z : Fin r → Value J (right J.target l) :=
    fun i => F (.inl (ringHorizontal (right J.target l) (targetAddress J l a) i))
  let Y : Fin r → Bit := fun i => F (.inr ⟨i,l,a i⟩)
  have he (i : Fin r) :
      linkLeft J l (X i) + linkRight J l (Z i) + Y i + Y (finRotate r i) =
        marker marked i * linkConstant J l := by
    have h := hlegal (squareBlock J l a ha i) (Finset.mem_image.mpr ⟨i,by simp,rfl⟩)
    change linkLeft J l (X i) + linkRight J l (Z i) + Y i + Y (finRotate r i) =
      1 * (marker marked i * linkConstant J l) at h
    simpa only [one_mul] using h
  have hs := Finset.sum_congr (s₁ := Finset.univ) rfl (fun i _ => he i)
  simp only [Finset.sum_add_distrib,← map_sum] at hs
  have hy : (∑ i : Fin r, Y (finRotate r i)) = ∑ i : Fin r, Y i :=
    Equiv.sum_comp (finRotate r) Y
  have hm : (∑ i : Fin r, marker marked i * linkConstant J l) = linkConstant J l := by
    simp [marker,ite_mul]
  rw [hy,hm] at hs
  change linkLeft J l (∑ i, X i) + linkRight J l (∑ i, Z i) = linkConstant J l
  have htwo : (2 : Bit) = 0 := by decide
  linear_combination hs - (∑ i : Fin r, Y i) * htwo

theorem link_transfer (hr : 3 ≤ r) (hn : 0 < n) (q : ℕ)
    (hN : 2 ≤ Fintype.card (Base (n := n) J marked 0))
    (l : Link E n) (a : ProductImages.Instance.Address m r) (ha : J.Allowed l.1 a)
    {F : ReadoutValues (n := n) J}
    (hF : Candidate J marked q
      (occupied J (ringBlock J (left J.source l) a (left_allowed J l a ha))) F) :
    ∃ G, Candidate J marked q
        (occupied J (ringBlock J (right J.target l) (targetAddress J l a) (right_allowed J l a ha))) G ∧
      linkLeft J l (ringSum J (left J.source l) a F) +
        linkRight J l (ringSum J (right J.target l) (targetAddress J l a) G) =
          linkConstant J l := by
  obtain ⟨T,hT,hTF⟩ := replace_cover J marked hr hn q hN
    (ringBlock J (left J.source l) a (left_allowed J l a ha)) (squareBlock J l a ha)
    (fun i => .inl (ringHorizontal (left J.source l) a i))
    (fun _ => rfl) (fun _ => Or.inl rfl) hF
  obtain ⟨G,hG,hGT⟩ := replace_cover J marked hr hn q hN (squareBlock J l a ha)
    (ringBlock J (right J.target l) (targetAddress J l a) (right_allowed J l a ha))
    (fun i => .inl (ringHorizontal (right J.target l) (targetAddress J l a) i))
    (fun _ => Or.inr (Or.inl rfl)) (fun _ => rfl) hT
  refine ⟨G,hG,?_⟩
  have hs := square_ring_equation J marked q l a ha hT
  have hleft : ringSum J (left J.source l) a T = ringSum J (left J.source l) a F :=
    Finset.sum_congr rfl (fun i _ => hTF i)
  have hright : ringSum J (right J.target l) (targetAddress J l a) G =
      ringSum J (right J.target l) (targetAddress J l a) T :=
    Finset.sum_congr rfl (fun i _ => hGT i)
  rw [hright,← hleft]
  exact hs

theorem link_transfer_reverse (hr : 3 ≤ r) (hn : 0 < n) (q : ℕ)
    (hN : 2 ≤ Fintype.card (Base (n := n) J marked 0))
    (l : Link E n) (a : ProductImages.Instance.Address m r) (ha : J.Allowed l.1 a)
    {F : ReadoutValues (n := n) J}
    (hF : Candidate J marked q
      (occupied J (ringBlock J (right J.target l) (targetAddress J l a) (right_allowed J l a ha))) F) :
    ∃ G, Candidate J marked q
        (occupied J (ringBlock J (left J.source l) a (left_allowed J l a ha))) G ∧
      linkLeft J l (ringSum J (left J.source l) a G) +
        linkRight J l (ringSum J (right J.target l) (targetAddress J l a) F) =
          linkConstant J l := by
  obtain ⟨T,hT,hTF⟩ := replace_cover J marked hr hn q hN
    (ringBlock J (right J.target l) (targetAddress J l a) (right_allowed J l a ha))
    (squareBlock J l a ha)
    (fun i => .inl (ringHorizontal (right J.target l) (targetAddress J l a) i))
    (fun _ => rfl) (fun _ => Or.inr (Or.inl rfl)) hF
  obtain ⟨G,hG,hGT⟩ := replace_cover J marked hr hn q hN (squareBlock J l a ha)
    (ringBlock J (left J.source l) a (left_allowed J l a ha))
    (fun i => .inl (ringHorizontal (left J.source l) a i))
    (fun _ => Or.inl rfl) (fun _ => rfl) hT
  refine ⟨G,hG,?_⟩
  have hs := square_ring_equation J marked q l a ha hT
  have hleft : ringSum J (left J.source l) a G = ringSum J (left J.source l) a T :=
    Finset.sum_congr rfl (fun i _ => hGT i)
  have hright : ringSum J (right J.target l) (targetAddress J l a) T =
      ringSum J (right J.target l) (targetAddress J l a) F :=
    Finset.sum_congr rfl (fun i _ => hTF i)
  rw [hleft,← hright]
  exact hs

def ringValues (q : ℕ) (t : Subdivision.Vertex P E n) (a : ProductImages.Instance.Address m r)
    (ha : ∀ i, a i ∈ J.labels t i) : Set (Value J t) :=
  {v | ∃ F, Candidate J marked q (occupied J (ringBlock J t a ha)) F ∧ ringSum J t a F = v}

theorem allowedReal (p : P) (a : ProductImages.Instance.Address m r) :
    ∀ i, a i ∈ J.labels (.inl p : Subdivision.Vertex P E n) i :=
  fun _ => Finset.mem_univ _

theorem allowedInternal (e : E) (j : Fin n) (a : ProductImages.Instance.Address m r)
    (ha : J.Allowed e a) :
    ∀ i, a i ∈ J.labels (.inr (e,j) : Subdivision.Vertex P E n) i := ha

def realValues (q : ℕ) (p : P) (a : ProductImages.Instance.Address m r) :
    Set (Vec (J.dimension p)) :=
  ringValues (n := n) J marked q (.inl p) a (allowedReal J p a)

def scalarValues (q : ℕ) (e : E) (j : Fin n) (a : ProductImages.Instance.Address m r)
    (ha : J.Allowed e a) : Set Bit :=
  (fun v : Value J (.inr (e,j)) => v (0 : Fin 1)) ''
    ringValues J marked q (.inr (e,j)) a (allowedInternal J e j a ha)

theorem scalar_comparison (x y b c : Bit) (h : x+y = b+c) : x+b = y+c := by
  have hh := congrArg (fun z => z+y+b) h
  simpa [add_assoc,add_comm,add_left_comm] using hh

theorem link_images (hr : 3 ≤ r) (hn : 0 < n) (q : ℕ)
    (hN : 2 ≤ Fintype.card (Base (n := n) J marked 0))
    (l : Link E n) (a : ProductImages.Instance.Address m r) (ha : J.Allowed l.1 a) :
    (fun v => linkLeft J l v + leftConstant J l) ''
        ringValues J marked q (left J.source l) a (left_allowed J l a ha) =
      (fun v => linkRight J l v + rightConstant J l) ''
        ringValues J marked q (right J.target l) (targetAddress J l a) (right_allowed J l a ha) := by
  ext s
  constructor
  · rintro ⟨v,⟨F,hF,hv⟩,rfl⟩
    obtain ⟨G,hG,hcomp⟩ := link_transfer J marked hr hn q hN l a ha hF
    refine ⟨ringSum J (right J.target l) (targetAddress J l a) G,⟨G,hG,rfl⟩,?_⟩
    rw [← hv]
    exact (scalar_comparison _ _ _ _ hcomp).symm
  · rintro ⟨v,⟨F,hF,hv⟩,rfl⟩
    obtain ⟨G,hG,hcomp⟩ := link_transfer_reverse J marked hr hn q hN l a ha hF
    refine ⟨ringSum J (left J.source l) a G,⟨G,hG,rfl⟩,?_⟩
    rw [← hv]
    exact scalar_comparison _ _ _ _ hcomp

def ringShifts (a : ProductImages.Instance.Address m r) (F : ReadoutValues (n := n) J) :
    J.Shifts n :=
  (fun p => ringSum J (.inl p) a F,
    fun ej => ringSum J (.inr ej) a F (0 : Fin 1))

theorem ringShifts_value (a : ProductImages.Instance.Address m r)
    (F : ReadoutValues (n := n) J) (t : Subdivision.Vertex P E n) :
    vectorShift J (ringShifts J a F) t = ringSum J t a F := by
  cases t with
  | inl p => rfl
  | inr ej =>
    funext i
    have hi := @Subsingleton.elim (Fin 1) inferInstance i 0
    subst i
    rfl

theorem ring_values_image (q : ℕ) (t : Subdivision.Vertex P E n)
    (a : ProductImages.Instance.Address m r) (ha : ∀ i, a i ∈ J.labels t i)
    (f : Value J t → Bit) :
    f '' ringValues J marked q t a ha =
      {b | ∃ F, Candidate J marked q (occupied J (ringBlock J t a ha)) F ∧
        f (ringSum J t a F) = b} := by
  ext b
  constructor
  · rintro ⟨v,⟨F,hF,hv⟩,hb⟩
    exact ⟨F,hF,hv ▸ hb⟩
  · rintro ⟨F,hF,hb⟩
    exact ⟨ringSum J t a F,⟨F,hF,rfl⟩,hb⟩

theorem ring_support_congr {t u : Subdivision.Vertex P E n}
    {a b : ProductImages.Instance.Address m r}
    {ha : ∀ i, a i ∈ J.labels t i} {hb : ∀ i, b i ∈ J.labels u i}
    (ht : t = u) (hab : a = b) :
    occupied J (ringBlock J t a ha) = occupied J (ringBlock J u b hb) := by
  cases ht
  cases hab
  rfl

theorem normalized_images (hr : 3 ≤ r) (hn : 0 < n) (q : ℕ)
    (hN : 2 ≤ Fintype.card (Base (n := n) J marked 0))
    (l : Link E n) (a : ProductImages.Instance.Address m r) (ha : J.Allowed l.1 a) :
    {b | ∃ F, Candidate J marked q
          (occupied J (ringBlock J (left J.source l) a (left_allowed J l a ha))) F ∧
        J.shiftLeft (ringShifts J a F) l = b} =
      {b | ∃ F, Candidate J marked q
          (occupied J (ringBlock J (right J.target l) (targetAddress J l a) (right_allowed J l a ha))) F ∧
        J.shiftRight (ringShifts J (targetAddress J l a) F) l = b} := by
  have hl (F : ReadoutValues (n := n) J) :
      linkLeft J l (ringSum J (left J.source l) a F) + leftConstant J l =
        J.shiftLeft (ringShifts J a F) l := by
    simpa only [ringShifts_value] using linkLeft_eval J (ringShifts J a F) l
  have hr' (F : ReadoutValues (n := n) J) :
      linkRight J l (ringSum J (right J.target l) (targetAddress J l a) F) + rightConstant J l =
        J.shiftRight (ringShifts J (targetAddress J l a) F) l := by
    simpa only [ringShifts_value] using linkRight_eval J (ringShifts J (targetAddress J l a) F) l
  ext b
  constructor
  · rintro ⟨F,hF,hb⟩
    obtain ⟨G,hG,hcomp⟩ := link_transfer J marked hr hn q hN l a ha hF
    refine ⟨G,hG,?_⟩
    rw [← hr',← hb,← hl]
    exact (scalar_comparison _ _ _ _ hcomp).symm
  · rintro ⟨F,hF,hb⟩
    obtain ⟨G,hG,hcomp⟩ := link_transfer_reverse J marked hr hn q hN l a ha hF
    refine ⟨G,hG,?_⟩
    rw [← hl,← hb,← hr']
    exact scalar_comparison _ _ _ _ hcomp

theorem first_images (hr : 3 ≤ r) (hn : 0 < n) (q : ℕ)
    (hN : 2 ≤ Fintype.card (Base (n := n) J marked 0))
    (e : E) (a : ProductImages.Instance.Address m r) (ha : J.Allowed e a) :
    J.leftForm e '' realValues (n := n) J marked q (J.source e) a =
      scalarValues (n := n) J marked q e ⟨0,hn⟩ a ha := by
  unfold realValues scalarValues
  change (fun v : Value J (.inl (J.source e) : Subdivision.Vertex P E n) =>
    J.leftForm e v) '' ringValues J marked q (.inl (J.source e)) a (allowedReal J _ a) = _
  erw [ring_values_image,ring_values_image]
  let l : Link E n := (e,⟨0,by omega⟩)
  have hA : targetAddress J l a = a := by
    funext i
    simp [l,targetAddress,matchOutput,Ne.symm (Nat.ne_of_gt hn)]
  have hL : occupied J (ringBlock J (left J.source l) a (left_allowed J l a ha)) =
      occupied J (ringBlock J (.inl (J.source e)) a (allowedReal J _ a)) :=
    ring_support_congr J (by simp [l,left]) rfl
  have hR : occupied J (ringBlock J (right J.target l) (targetAddress J l a) (right_allowed J l a ha)) =
      occupied J (ringBlock J (.inr (e,⟨0,hn⟩)) a (allowedInternal J _ _ a ha)) :=
    ring_support_congr J (by simp [l,right,Ne.symm (Nat.ne_of_gt hn)]) hA
  have hh := normalized_images J marked hr hn q hN l a ha
  rw [hL,hR,hA] at hh
  simpa [ProductImages.Instance.shiftLeft,ProductImages.Instance.shiftRight,ringShifts,
    hA,l,Ne.symm (Nat.ne_of_gt hn)] using hh

theorem internal_images (hr : 3 ≤ r) (hn : 0 < n) (q : ℕ)
    (hN : 2 ≤ Fintype.card (Base (n := n) J marked 0))
    (e : E) (a : ProductImages.Instance.Address m r) (ha : J.Allowed e a)
    (k : ℕ) (hk : k+1 < n) :
    scalarValues (n := n) J marked q e ⟨k,by omega⟩ a ha =
      scalarValues (n := n) J marked q e ⟨k+1,hk⟩ a ha := by
  unfold scalarValues
  erw [ring_values_image,ring_values_image]
  let l : Link E n := (e,⟨k+1,by omega⟩)
  have hA : targetAddress J l a = a := by
    funext i
    simp [l,targetAddress,matchOutput,Nat.ne_of_lt hk]
  have hL : occupied J (ringBlock J (left J.source l) a (left_allowed J l a ha)) =
      occupied J (ringBlock J (.inr (e,⟨k,by omega⟩)) a (allowedInternal J _ _ a ha)) :=
    ring_support_congr J (by simp [l,left]) rfl
  have hR : occupied J (ringBlock J (right J.target l) (targetAddress J l a) (right_allowed J l a ha)) =
      occupied J (ringBlock J (.inr (e,⟨k+1,hk⟩)) a (allowedInternal J _ _ a ha)) :=
    ring_support_congr J (by simp [l,right,Nat.ne_of_lt hk]) hA
  have hh := normalized_images J marked hr hn q hN l a ha
  rw [hL,hR,hA] at hh
  simpa [ProductImages.Instance.shiftLeft,ProductImages.Instance.shiftRight,ringShifts,
    hA,l,Nat.ne_of_lt hk] using hh

theorem last_images (hr : 3 ≤ r) (hn : 0 < n) (q : ℕ)
    (hN : 2 ≤ Fintype.card (Base (n := n) J marked 0))
    (e : E) (a : ProductImages.Instance.Address m r) (ha : J.Allowed e a) :
    scalarValues (n := n) J marked q e ⟨n-1,by omega⟩ a ha =
      J.rightForm e '' realValues (n := n) J marked q (J.target e) (J.mapAddress e a) := by
  unfold realValues scalarValues
  change _ = (fun v : Value J (.inl (J.target e) : Subdivision.Vertex P E n) =>
    J.rightForm e v) '' ringValues J marked q (.inl (J.target e)) (J.mapAddress e a)
      (allowedReal J _ (J.mapAddress e a))
  erw [ring_values_image,ring_values_image]
  let l : Link E n := (e,⟨n,by omega⟩)
  have hA : targetAddress J l a = J.mapAddress e a := by
    funext i
    simp [l,targetAddress,matchOutput,ProductImages.Instance.mapAddress]
  have hL : occupied J (ringBlock J (left J.source l) a (left_allowed J l a ha)) =
      occupied J (ringBlock J (.inr (e,⟨n-1,by omega⟩)) a (allowedInternal J _ _ a ha)) :=
    ring_support_congr J (by simp [l,left,Nat.ne_of_gt hn]) rfl
  have hR : occupied J (ringBlock J (right J.target l) (targetAddress J l a) (right_allowed J l a ha)) =
      occupied J (ringBlock J (.inl (J.target e)) (J.mapAddress e a) (allowedReal J _ _)) :=
    ring_support_congr J (by simp [l,right]) hA
  have hh := normalized_images J marked hr hn q hN l a ha
  rw [hL,hR,hA] at hh
  simpa [ProductImages.Instance.shiftLeft,ProductImages.Instance.shiftRight,ringShifts,
    hA,l,Nat.ne_of_gt hn] using hh

theorem game_implies_consistency (hr : 3 ≤ r) (hn : 0 < n) (q : ℕ)
    (hN : 2 ≤ Fintype.card (Base (n := n) J marked 0))
    (hwin : Game.Equivalent (graph (n := n) J marked 0 q) (graph (n := n) J marked 1 q) (r+1)) :
    J.Consistent := by
  refine ⟨{ values := realValues (n := n) J marked q, nonempty := ?_, images := ?_ }⟩
  · intro p a
    let ha : ∀ i : Fin r, a i ∈ J.labels (.inl p : Subdivision.Vertex P E n) i :=
      fun _ => Finset.mem_univ _
    have hc : (occupied J (ringBlock J (.inl p) a ha)).card ≤ r+1 :=
      Finset.card_image_le.trans (by simp)
    obtain ⟨F,hF⟩ := candidate_nonempty J marked hr hn q hN hwin _ hc
    exact ⟨ringSum J (.inl p) a F,F,hF,rfl⟩
  · intro e a ha
    have walk : ∀ k (hk : k < n),
        scalarValues (n := n) J marked q e ⟨0,hn⟩ a ha =
          scalarValues (n := n) J marked q e ⟨k,hk⟩ a ha := by
      intro k
      induction k with
      | zero => intro _; rfl
      | succ k ih =>
        intro hk
        exact (ih (by omega)).trans (internal_images J marked hr hn q hN e a ha k hk)
    exact (first_images J marked hr hn q hN e a ha).trans
      ((walk (n-1) (by omega)).trans (last_images J marked hr hn q hN e a ha))

theorem game_iff_consistency (hr : 3 ≤ r) (hn : 0 < n) (hlarge : r+1 < n+1)
    (q : ℕ) (hN : 2 ≤ Fintype.card (Base (n := n) J marked 0)) :
    Game.Equivalent (graph (n := n) J marked 0 q) (graph (n := n) J marked 1 q) (r+1) ↔
      J.Consistent :=
  ⟨game_implies_consistency J marked hr hn q hN,
    consistency_implies_game J marked hr hn hlarge q⟩

def blockCode (b : Block (n := n) J) :
    Fin r × (Subdivision.Vertex P E n ⊕ Link E n) × Fin m × Fin m :=
  match b.val with
  | .inl h => (h.row,.inl h.type,h.first,h.last)
  | .inr s => (s.row,.inr s.link,s.first,s.last)

theorem blockCode_injective : Function.Injective (blockCode (n := n) J) := by
  rintro ⟨b,hb⟩ ⟨c,hc⟩ he
  apply Subtype.ext
  rcases b with ⟨i,t,a,b⟩ | ⟨i,l,a,b⟩ <;>
    rcases c with ⟨j,u,c,d⟩ | ⟨j,k,c,d⟩ <;>
    simp only [blockCode,Prod.mk.injEq,Sum.inl.injEq,Sum.inr.injEq,reduceCtorEq,
      false_and,and_false] at he
  all_goals rcases he with ⟨rfl,rfl,rfl,rfl⟩; rfl

theorem block_count_bound :
    Fintype.card (Block (n := n) J) ≤
      r * (Fintype.card P + n * Fintype.card E + (n+1) * Fintype.card E) * m^2 := by
  have h := Fintype.card_le_of_injective _ (blockCode_injective (n := n) J)
  calc
    Fintype.card (Block (n := n) J) ≤
        Fintype.card (Fin r × (Subdivision.Vertex P E n ⊕ Link E n) × Fin m × Fin m) := h
    _ = _ := by simp [Fintype.card_prod,Fintype.card_sum]; ring

theorem dimension_bound (D : ℕ) (hD : 1 ≤ D) (hd : ∀ p, J.dimension p ≤ D)
    (t : Subdivision.Vertex P E n) : dimension J t ≤ D := by
  cases t with
  | inl p => exact hd p
  | inr _ => exact hD

theorem raw_count_bound (D : ℕ) (hD : 1 ≤ D) (hd : ∀ p, J.dimension p ≤ D)
    (b : RawBlock m r n P E) :
    Fintype.card (RawValue J b) ≤ 2^(2*D+2) := by
  cases b with
  | inl h =>
    have ht := dimension_bound J D hD hd h.type
    change Fintype.card (Vec (dimension J h.type)) ≤ _
    simpa [Vec,Bit] using
      (Nat.pow_le_pow_right (n := 2) (by decide) (show dimension J h.type ≤ 2*D+2 by omega))
  | inr s =>
    have hl := dimension_bound J D hD hd (left J.source s.link)
    have hr := dimension_bound J D hD hd (right J.target s.link)
    have hc : Fintype.card (RawValue J (.inr s)) =
        2^(dimension J (left J.source s.link) + dimension J (right J.target s.link) + 2) := by
      simp [RawValue,SquareVal,Vec,Bit,pow_add]
    rw [hc]
    exact Nat.pow_le_pow_right (by decide) (by omega)

theorem base_count_bound (D : ℕ) (hD : 1 ≤ D) (hd : ∀ p, J.dimension p ≤ D)
    (ε : Bit) :
    Fintype.card (Base (n := n) J marked ε) ≤ 2^(2*D+2) * Fintype.card (Block (n := n) J) := by
  change Fintype.card (Σ b : Block (n := n) J, Valuation J marked ε b) ≤ _
  rw [Fintype.card_sigma]
  calc
    (∑ b : Block (n := n) J, Fintype.card (Valuation J marked ε b)) ≤
        ∑ _b : Block (n := n) J, 2^(2*D+2) := by
      apply Finset.sum_le_sum
      intro b _
      exact (Fintype.card_le_of_injective Subtype.val Subtype.val_injective).trans
        (raw_count_bound J D hD hd b.val)
    _ = _ := by simp; ring

theorem blocks_le_base :
    Fintype.card (Block (n := n) J) ≤ Fintype.card (Base (n := n) J marked 0) :=
  Fintype.card_le_of_injective (zeroVertex J marked)
    (fun _ _ h => congrArg Sigma.fst h)

theorem equal_orders (q : ℕ) :
    Nat.card (Vertex (n := n) J marked 0 q) = Nat.card (Vertex (n := n) J marked 1 q) :=
  Nat.card_congr (fullEquiv J marked q (defaultOffset J marked))

theorem padding_order (ε : Bit) (q : ℕ) :
    Nat.card (Vertex (n := n) J marked ε q) =
      Nat.card (Vertex (n := n) J marked ε 0) + q := by
  rw [Marks.order,Marks.order]

theorem marked_order_bound :
    Nat.card (Vertex (n := n) J marked 0 0) ≤
      (Fintype.card (Base (n := n) J marked 0))^3 +
      (Fintype.card (Base (n := n) J marked 0))^2 +
      Fintype.card (Base (n := n) J marked 0) + 1 := by
  let N := Fintype.card (Base (n := n) J marked 0)
  have hB := blocks_le_base (n := n) J marked
  have hw (x : Base (n := n) J marked 0) : weight J marked 0 x ≤ N * (N+1) := by
    have hn' := (Fintype.equivFin (Block (n := n) J) x.1).isLt
    have hn : number J x.1 ≤ N := by unfold number; dsimp [N]; omega
    exact Nat.mul_le_mul_right (N+1) hn
  have hs : (∑ x : Base (n := n) J marked 0, weight J marked 0 x) ≤ N * (N*(N+1)) := by
    calc
      _ ≤ ∑ _x : Base (n := n) J marked 0, N*(N+1) := Finset.sum_le_sum (fun x _ => hw x)
      _ = _ := by simp [N]
  rw [Marks.order]
  dsimp only [N] at hs ⊢
  nlinarith

theorem sixth_power_bound (A m N : ℕ) (hm : 1 ≤ m) (hN : N ≤ A*m^2) :
    N^3 + N^2 + N + 1 ≤ (A^3+A^2+A+1)*m^6 := by
  have hm2 : 1 ≤ m^2 := Nat.one_le_pow _ _ hm
  have hm4 : 1 ≤ m^4 := Nat.one_le_pow _ _ hm
  have hm6 : 1 ≤ m^6 := Nat.one_le_pow _ _ hm
  have h2 : N^2 ≤ A^2*m^4 := by
    calc
      N^2 ≤ (A*m^2)^2 := Nat.pow_le_pow_left hN 2
      _ = _ := by ring
  have h3 : N^3 ≤ A^3*m^6 := by
    calc
      N^3 ≤ (A*m^2)^3 := Nat.pow_le_pow_left hN 3
      _ = _ := by ring
  have h4 : A^2*m^4 ≤ A^2*m^6 := by nlinarith [Nat.mul_le_mul_left (A^2*m^4) hm2]
  have h5 : A*m^2 ≤ A*m^6 := by nlinarith [Nat.mul_le_mul_left (A*m^2) hm4]
  nlinarith

theorem order_bound (D : ℕ) (hD : 1 ≤ D) (hd : ∀ p, J.dimension p ≤ D)
    (hm : 1 ≤ m) (ε : Bit) (q : ℕ) :
    let A := 2^(2*D+2) *
      (r * (Fintype.card P + n*Fintype.card E + (n+1)*Fintype.card E))
    Nat.card (Vertex (n := n) J marked ε q) ≤ (A^3+A^2+A+1)*m^6 + q := by
  intro A
  have hN : Fintype.card (Base (n := n) J marked 0) ≤ A*m^2 := by
    exact (base_count_bound J marked D hD hd 0).trans
      (by
        have h := Nat.mul_le_mul_left (2^(2*D+2)) (block_count_bound (n := n) J)
        simpa [A,Nat.mul_assoc] using h)
  have hz : Nat.card (Vertex (n := n) J marked 0 0) ≤ (A^3+A^2+A+1)*m^6 :=
    (marked_order_bound J marked).trans (sixth_power_bound A m _ hm hN)
  have hp := padding_order (n := n) J marked ε q
  have hε : ε = 0 ∨ ε = 1 := by
    change (ε : ZMod 2) = 0 ∨ ε = 1
    fin_cases ε <;> simp
  rcases hε with rfl | rfl
  · omega
  · have he := equal_orders (n := n) J marked 0
    omega

end Construction

namespace Augment
open ProjectionAudit.VariableWL
open ProjectionAudit.VariableWL.Affine ProjectionAudit.VariableWL.Subdivision
open ProjectionAudit.VariableWL.Blocks
open scoped CharTwo
variable {m r n : ℕ} {P E : Type*} (J : ProductImages.Instance m r P E)

def withDummy : ProductImages.Instance m r (P ⊕ Unit) E where
  dimension := Sum.elim J.dimension (fun _ => 1)
  source := fun e => .inl (J.source e)
  target := fun e => .inl (J.target e)
  domain := J.domain
  map := J.map
  map_injective := J.map_injective
  linearLeft := J.linearLeft
  linearRight := J.linearRight
  constantLeft := J.constantLeft
  constantRight := J.constantRight

theorem consistent_iff : (withDummy J).Consistent ↔ J.Consistent := by
  constructor
  · rintro ⟨Q⟩
    exact ⟨{
      values := fun p a => Q.values (.inl p) a
      nonempty := fun p a => Q.nonempty (.inl p) a
      images := fun e a ha => Q.images e a ha
    }⟩
  · rintro ⟨Q⟩
    refine ⟨{
      values := fun p a => match p with
        | .inl p => Q.values p a
        | .inr _ => Set.univ
      nonempty := ?_
      images := fun e a ha => Q.images e a ha
    }⟩
    rintro (p | u) a
    · exact Q.nonempty p a
    · exact ⟨0,Set.mem_univ _⟩

def dummyBlock (marked : Fin r) (hm : 0 < m) : Block (n := n) (withDummy J) :=
  ⟨.inl ⟨marked,.inl (.inr ()),⟨0,hm⟩,⟨0,hm⟩⟩,
    ⟨Finset.mem_univ _,Finset.mem_univ _⟩⟩

def dummyVertex (marked : Fin r) (hm : 0 < m) (b : Bit) :
    Construction.Base (n := n) (withDummy J) marked 0 :=
  ⟨dummyBlock J marked hm,⟨fun _ => b,by
    change (0 : Bit) = 0
    rfl⟩⟩

theorem dummyVertex_injective (marked : Fin r) (hm : 0 < m) :
    Function.Injective (dummyVertex (n := n) J marked hm) := by
  intro b c h
  have hz := eq_of_heq (Sigma.mk.inj_iff.mp h).2
  have hv := congrArg Subtype.val hz
  exact congrFun hv (0 : Fin 1)

theorem two_base_vertices [Fintype P] [Fintype E] (marked : Fin r) (hm : 0 < m) :
    2 ≤ Fintype.card (Construction.Base (n := n) (withDummy J) marked 0) := by
  have h := Fintype.card_le_of_injective _ (dummyVertex_injective (n := n) J marked hm)
  simpa [Bit] using h

variable [Fintype P] [Fintype E]

abbrev Vertex (marked : Fin r) (ε : Bit) (q : ℕ) :=
  Construction.Vertex (n := 4*(r+1)) (withDummy J) marked ε q

def graph (marked : Fin r) (ε : Bit) (q : ℕ) : SimpleGraph (Vertex J marked ε q) :=
  Construction.graph (n := 4*(r+1)) (withDummy J) marked ε q

theorem compressed_reduction (hr : 3 ≤ r) (hm : 2 ≤ m) (marked : Fin r) (q : ℕ) :
    Game.Equivalent (graph J marked 0 q) (graph J marked 1 q) (r+1) ↔ J.Consistent := by
  exact (Construction.game_iff_consistency (withDummy J) marked hr (by omega) (by omega) q
    (two_base_vertices J marked (by omega))).trans (consistent_iff J)

theorem equal_orders (marked : Fin r) (q : ℕ) :
    Nat.card (Vertex J marked 0 q) = Nat.card (Vertex J marked 1 q) :=
  Construction.equal_orders (withDummy J) marked q

theorem padding_order (marked : Fin r) (ε : Bit) (q : ℕ) :
    Nat.card (Vertex J marked ε q) = Nat.card (Vertex J marked ε 0) + q :=
  Construction.padding_order (withDummy J) marked ε q

theorem connected (marked : Fin r) (ε : Bit) (q : ℕ) :
    (graph J marked ε q).Connected :=
  Marks.connected _ _ _

theorem diameter_two (marked : Fin r) (ε : Bit) (q : ℕ)
    (x y : Vertex J marked ε q) :
    x = y ∨ (graph J marked ε q).Adj x y ∨
      ∃ z, (graph J marked ε q).Adj x z ∧ (graph J marked ε q).Adj z y :=
  Marks.diameter_two _ _ _ x y

theorem order_bound (D : ℕ) (hD : 1 ≤ D) (hd : ∀ p, J.dimension p ≤ D)
    (hm : 1 ≤ m) (marked : Fin r) (ε : Bit) (q : ℕ) :
    let A := 2^(2*D+2) *
      (r * (Fintype.card P + 1 + (4*(r+1))*Fintype.card E +
        (4*(r+1)+1)*Fintype.card E))
    Nat.card (Vertex J marked ε q) ≤ (A^3+A^2+A+1)*m^6 + q := by
  have hd' : ∀ p, (withDummy J).dimension p ≤ D := by
    rintro (p | u)
    · exact hd p
    · exact hD
  simpa using Construction.order_bound (withDummy J) marked D hD hd' hm ε q

end Augment

#print axioms CompressedReduction.Augment.compressed_reduction
#print axioms CompressedReduction.Augment.order_bound

end CompressedReduction
