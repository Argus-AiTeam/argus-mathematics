import Mathlib

set_option maxRecDepth 10000
set_option maxHeartbeats 0

namespace DiagramDeficit

def words {α : Type} (alphabet : List α) : ℕ → List (List α)
  | 0 => [[]]
  | n + 1 => alphabet.flatMap fun x => (words alphabet n).map (x :: ·)

theorem words_complete {α : Type} (alphabet : List α) :
    ∀ l : List α, (∀ x ∈ l, x ∈ alphabet) → l ∈ words alphabet l.length := by
  intro l
  induction l with
  | nil => simp [words]
  | cons x xs ih =>
    intro h
    apply List.mem_flatMap.mpr
    refine ⟨x, h x (by simp), ?_⟩
    apply List.mem_map.mpr
    exact ⟨xs, ih (fun y hy => h y (by simp [hy])), rfl⟩

def distinctWords : ℕ → List (List (Fin 5))
  | 0 => [[]]
  | n + 1 => (distinctWords n).flatMap fun tail =>
      ((List.finRange 5).filter fun v => !tail.contains v).map (v_cons tail)
where
  v_cons (tail : List (Fin 5)) (v : Fin 5) := v :: tail

theorem distinctWords_complete :
    ∀ l : List (Fin 5), l.Nodup → l ∈ distinctWords l.length := by
  intro l
  induction l with
  | nil => simp [distinctWords]
  | cons x xs ih =>
    intro h
    obtain ⟨hx, hxs⟩ := List.nodup_cons.mp h
    apply List.mem_flatMap.mpr
    refine ⟨xs, ih hxs, ?_⟩
    apply List.mem_map.mpr
    refine ⟨x, ?_, rfl⟩
    simp [hx]

def vertexValid (fan : Fin 3) (v : Fin 5) : Bool :=
  if fan = 0 then true else decide (v.val < 4)

def pointPart (fan : Fin 3) (v : Fin 5) : Bool :=
  if fan = 2 then v == 0 else decide (v.val < 2)

def port (fan : Fin 3) (v : Fin 5) : Bool :=
  if fan = 0 then decide (2 ≤ v.val)
  else if fan = 1 then v == 0 || decide (2 ≤ v.val)
  else decide (1 ≤ v.val)

def triangle (fan : Fin 3) (u v : Fin 5) : Bool :=
  vertexValid fan u && vertexValid fan v && !(pointPart fan u == pointPart fan v)

def validLink (fan : Fin 3) (vs : List (Fin 5)) (ks : List (Fin 3)) : Bool :=
  decide (2 ≤ vs.length) && decide (vs.length ≤ 5) && decide vs.Nodup &&
  decide (ks.length = vs.length) && vs.all (vertexValid fan) &&
  (List.range vs.length).all (fun i =>
    let j := (i + 1) % vs.length
    let u := vs.getD i 0
    let v := vs.getD j 0
    let k := ks.getD i 0
    (if k = 0 then triangle fan u v else port fan u && port fan v && decide (u ≠ v)) &&
    !(k == 1 && ks.getD j 0 == 1)) &&
  !(vs.length == 2 && ks.all (fun k => k == 0))

def picked (ks : List (Fin 3)) (mask : List Bool) (pred : Fin 3 → Bool) : ℕ :=
  ((ks.zip mask).filter fun pair => pair.2 && pred pair.1).length

def qCount (ks : List (Fin 3)) (mask : List Bool) : ℕ :=
  picked ks mask (· == 0)

def dCount (ks : List (Fin 3)) (mask : List Bool) : ℕ :=
  picked ks mask (· != 0)

def xCount (ks : List (Fin 3)) (mask : List Bool) : ℕ :=
  picked ks mask (· == 1)

def yCount (ks : List (Fin 3)) (mask : List Bool) : ℕ :=
  picked ks mask (· == 2)

def payment (fan : Fin 3) (vs : List (Fin 5))
    (ks : List (Fin 3)) (mask : List Bool) : ℕ :=
  ((List.range vs.length).filter fun i =>
    mask.getD i false && ks.getD i 0 != 0 && fan == 1 &&
    (vs.getD i 0 == 0 || vs.getD ((i + 1) % vs.length) 0 == 0)).length

def partialFlag (mask : List Bool) : ℕ := if mask.all id then 0 else 1

def transitions (vs : List (Fin 5)) (mask : List Bool) : ℕ :=
  ((List.range vs.length).filter fun i =>
    mask.getD i false != mask.getD ((i + 1) % vs.length) false).length

def edgeUse (vs : List (Fin 5)) (ks : List (Fin 3)) (mask : List Bool)
    (u v : Fin 5) : ℕ :=
  ((List.range vs.length).filter fun i =>
    mask.getD i false && ks.getD i 0 == 0 &&
    ((vs.getD i 0 == u && vs.getD ((i + 1) % vs.length) 0 == v) ||
      (vs.getD i 0 == v && vs.getD ((i + 1) % vs.length) 0 == u))).length

def localCheck (fan : Fin 3) (vs : List (Fin 5))
    (ks : List (Fin 3)) (mask : List Bool) : Bool :=
  !mask.any id || decide (
    4 ≤ 2 * dCount ks mask + qCount ks mask + payment fan vs ks mask + 3 * partialFlag mask ∧
    2 * xCount ks mask ≤ 2 * yCount ks mask + qCount ks mask +
      payment fan vs ks mask + 3 * partialFlag mask ∧
    2 * partialFlag mask ≤ transitions vs mask ∧
    qCount ks mask ≤ 4 ∧
    xCount ks mask ≤ 1 ∧
    dCount ks mask = xCount ks mask + yCount ks mask ∧
    1 ≤ qCount ks mask + dCount ks mask ∧
    ∀ u v : Fin 5, edgeUse vs ks mask u v ≤ 1)

def candidates : List (List (Fin 5) × List (Fin 3)) :=
  (List.range 6).flatMap fun n => (distinctWords n).flatMap fun vs =>
    (words (List.finRange 3) n).map fun ks => (vs, ks)

def casesFor (fan : Fin 3) := candidates.filter fun pair => validLink fan pair.1 pair.2

theorem cases_complete (fan : Fin 3) (vs : List (Fin 5)) (ks : List (Fin 3))
    (hv : validLink fan vs ks = true) : (vs, ks) ∈ casesFor fan := by
  have hf := hv
  simp only [validLink, Bool.and_eq_true, decide_eq_true_eq] at hf
  have hn : vs.length ≤ 5 := by tauto
  have hd : vs.Nodup := by tauto
  have hk : ks.length = vs.length := by tauto
  apply List.mem_filter.mpr
  refine ⟨?_, hv⟩
  apply List.mem_flatMap.mpr
  refine ⟨vs.length, by simp; omega, ?_⟩
  apply List.mem_flatMap.mpr
  refine ⟨vs, distinctWords_complete vs hd, ?_⟩
  apply List.mem_map.mpr
  refine ⟨ks, ?_, rfl⟩
  simpa [hk] using words_complete (List.finRange 3) ks (by simp)

def localCertificate : Bool :=
  (List.finRange 3).all fun fan => (casesFor fan).all fun pair =>
    (words [false, true] pair.1.length).all fun mask =>
      localCheck fan pair.1 pair.2 mask

theorem local_certificate : localCertificate = true := by decide +kernel

theorem local_sound (fan : Fin 3) (vs : List (Fin 5)) (ks : List (Fin 3))
    (mask : List Bool) (hv : validLink fan vs ks = true)
    (hm : mask.length = vs.length) (hr : mask.any id = true) :
    4 ≤ 2 * dCount ks mask + qCount ks mask + payment fan vs ks mask + 3 * partialFlag mask ∧
    2 * xCount ks mask ≤ 2 * yCount ks mask + qCount ks mask +
      payment fan vs ks mask + 3 * partialFlag mask ∧
    2 * partialFlag mask ≤ transitions vs mask ∧
    qCount ks mask ≤ 4 ∧
    xCount ks mask ≤ 1 ∧
    dCount ks mask = xCount ks mask + yCount ks mask ∧
    1 ≤ qCount ks mask + dCount ks mask ∧
    ∀ u v : Fin 5, edgeUse vs ks mask u v ≤ 1 := by
  have h := List.all_eq_true.mp local_certificate fan (by simp)
  have h' := List.all_eq_true.mp h (vs, ks) (cases_complete fan vs ks hv)
  have hmask : mask ∈ words [false, true] vs.length := by
    simpa [hm] using words_complete [false, true] mask (by
      intro b hb
      cases b <;> simp)
  have h'' := List.all_eq_true.mp h' mask hmask
  simpa [localCheck, hr] using h''

theorem layer_sum {X : Type} [Fintype X] (w : X → ℕ) (c : X → ℝ)
    (N : ℕ) (hw : ∀ x, w x ≤ N) :
    (∑ j ∈ Finset.range N, ∑ x : X, if j < w x then c x else 0) =
      ∑ x : X, (w x : ℝ) * c x := by
  classical
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro x hx
  have hf : (Finset.range N).filter (fun j => j < w x) = Finset.range (w x) := by
    ext j
    simp only [Finset.mem_filter, Finset.mem_range]
    have := hw x
    omega
  rw [← Finset.sum_filter, hf]
  simp [nsmul_eq_mul]

def layerRank {X : Type} [Fintype X] [DecidableEq X]
    (w : X → ℕ) (root : X → X) (j : ℕ) : ℕ :=
  (Finset.univ.filter fun x => j < w x ∧ root x ≠ x).card

theorem rank_is_coincidence_rank {X : Type} [Fintype X] [DecidableEq X]
    (w : X → ℕ) (root : X → X)
    (hi : ∀ x, root (root x) = root x) (hm : ∀ x, w x ≤ w (root x)) (j : ℕ) :
    layerRank w root j +
      ((Finset.univ.filter fun x => j < w x).image root).card =
      (Finset.univ.filter fun x => j < w x).card := by
  classical
  let L : Finset X := Finset.univ.filter fun x => j < w x
  have hr : L.filter (fun x => root x = x) = L.image root := by
    ext v
    constructor
    · intro h
      obtain ⟨hv, heq⟩ := Finset.mem_filter.mp h
      exact Finset.mem_image.mpr ⟨v, hv, heq⟩
    · intro h
      obtain ⟨u, hu, rfl⟩ := Finset.mem_image.mp h
      apply Finset.mem_filter.mpr
      constructor
      · exact Finset.mem_filter.mpr
          ⟨Finset.mem_univ _, lt_of_lt_of_le (Finset.mem_filter.mp hu).2 (hm u)⟩
      · exact hi u
  have hn : L.filter (fun x => ¬root x = x) =
      Finset.univ.filter (fun x => j < w x ∧ root x ≠ x) := by
    ext x
    simp [L]
  have h := Finset.card_filter_add_card_filter_not (s := L) (fun x => root x = x)
  rw [hr, hn] at h
  simpa [layerRank, L, Nat.add_comm] using h

theorem layerRank_sum {X : Type} [Fintype X] [DecidableEq X]
    (w : X → ℕ) (root : X → X) (N : ℕ) (hw : ∀ x, w x ≤ N) :
    (∑ j ∈ Finset.range N, (layerRank w root j : ℝ)) =
      ∑ x : X, if root x ≠ x then (w x : ℝ) else 0 := by
  classical
  have hc (j : ℕ) :
      (layerRank w root j : ℝ) =
      ∑ x : X, if j < w x then (if root x ≠ x then (1 : ℝ) else 0) else 0 := by
    simp only [layerRank, Finset.card_eq_sum_ones, Nat.cast_sum, Finset.sum_filter]
    apply Finset.sum_congr rfl
    intro x hx
    by_cases hj : j < w x <;> by_cases hr : root x = x <;> simp [hj, hr]
  simp_rw [hc]
  simpa only [mul_ite, mul_one, mul_zero] using
    layer_sum w (fun x => if root x ≠ x then 1 else 0) N hw

theorem contacts_charge {X H : Type} [Fintype X] [Fintype H] [DecidableEq X]
    (w : X → ℕ) (root : X → X)
    (side : H × Bool → (Σ x : X, Fin (w x))) (hs : Function.Injective side)
    (hd : ∀ h, (side (h, false)).1 ≠ (side (h, true)).1)
    (hc : ∀ h, root (side (h, false)).1 = root (side (h, true)).1) :
    Fintype.card H ≤ ∑ x : X, if root x ≠ x then w x else 0 := by
  classical
  let choose (h : H) : Bool :=
    decide (root (side (h, false)).1 = (side (h, false)).1)
  have hn (h : H) : root (side (h, choose h)).1 ≠ (side (h, choose h)).1 := by
    by_cases hl : root (side (h, false)).1 = (side (h, false)).1
    · simp only [choose, hl, decide_true]
      intro hr
      exact hd h (hl.symm.trans ((hc h).trans hr))
    · have hchoose : choose h = false := by simp [choose, hl]
      rw [hchoose]
      exact hl
  let charge (h : H) :
      (Σ x : {x : X // root x ≠ x}, Fin (w x.val)) :=
    ⟨⟨(side (h, choose h)).1, hn h⟩, (side (h, choose h)).2⟩
  have hi : Function.Injective charge := by
    intro h k heq
    have he := congrArg (fun z : (Σ x : {x : X // root x ≠ x}, Fin (w x.val)) =>
      (⟨z.1.val, z.2⟩ : Σ x : X, Fin (w x))) heq
    change side (h, choose h) = side (k, choose k) at he
    exact congrArg Prod.fst (hs he)
  have hh := Fintype.card_le_of_injective charge hi
  have hh' : Fintype.card H ≤ ∑ x : {x : X // root x ≠ x}, w x.val := by
    simpa only [Fintype.card_sigma, Fintype.card_fin] using hh
  have hsum : (∑ x : {x : X // root x ≠ x}, w x.val) =
      ∑ x : X, if root x ≠ x then w x else 0 := by
    rw [← Finset.sum_subtype (Finset.univ.filter fun x : X => root x ≠ x)
      (by simp) w]
    rw [Finset.sum_filter]
  exact hsum ▸ hh'

theorem weighted_rank {X H : Type} [Fintype X] [Fintype H] [DecidableEq X]
    (w : X → ℕ) (root : X → X)
    (side : H × Bool → (Σ x : X, Fin (w x))) (hs : Function.Injective side)
    (hd : ∀ h, (side (h, false)).1 ≠ (side (h, true)).1)
    (hc : ∀ h, root (side (h, false)).1 = root (side (h, true)).1)
    (N : ℕ) (hw : ∀ x, w x ≤ N) (cost : ℕ → ℝ)
    (hr : ∀ j < N, (layerRank w root j : ℝ) ≤ cost j) :
    (Fintype.card H : ℝ) ≤ ∑ j ∈ Finset.range N, cost j := by
  classical
  have hcharge : (Fintype.card H : ℝ) ≤
      ∑ x : X, if root x ≠ x then (w x : ℝ) else 0 := by
    exact_mod_cast contacts_charge w root side hs hd hc
  rw [← layerRank_sum w root N hw] at hcharge
  exact hcharge.trans (Finset.sum_le_sum fun j hj => hr j (Finset.mem_range.mp hj))

structure LocalPattern where
  fan : Fin 3
  vertices : List (Fin 5)
  kinds : List (Fin 3)
  selected : List Bool
  valid : validLink fan vertices kinds = true
  mask_length : selected.length = vertices.length
  represented : selected.any id = true

def LocalPattern.q (l : LocalPattern) := qCount l.kinds l.selected
def LocalPattern.d (l : LocalPattern) := dCount l.kinds l.selected
def LocalPattern.x (l : LocalPattern) := xCount l.kinds l.selected
def LocalPattern.y (l : LocalPattern) := yCount l.kinds l.selected
def LocalPattern.p (l : LocalPattern) := payment l.fan l.vertices l.kinds l.selected
def LocalPattern.j (l : LocalPattern) := partialFlag l.selected
def LocalPattern.rad (l : LocalPattern) := transitions l.vertices l.selected

theorem LocalPattern.bounds (l : LocalPattern) :
    4 ≤ 2 * l.d + l.q + l.p + 3 * l.j ∧
    2 * l.x ≤ 2 * l.y + l.q + l.p + 3 * l.j ∧
    2 * l.j ≤ l.rad ∧ l.q ≤ 4 ∧ l.x ≤ 1 ∧ l.d = l.x + l.y := by
  obtain ⟨h1, h2, h3, h4, h5, h6, h7, h8⟩ :=
    local_sound l.fan l.vertices l.kinds l.selected l.valid l.mask_length l.represented
  exact ⟨h1, h2, h3, h4, h5, h6⟩

theorem LocalPattern.nonempty_steps (l : LocalPattern) : 1 ≤ l.q + l.d := by
  obtain ⟨h1, h2, h3, h4, h5, h6, h7, h8⟩ :=
    local_sound l.fan l.vertices l.kinds l.selected l.valid l.mask_length l.represented
  exact h7

theorem LocalPattern.field_capacity (l : LocalPattern) (u v : Fin 5) :
    edgeUse l.vertices l.kinds l.selected u v ≤ 1 := by
  obtain ⟨h1, h2, h3, h4, h5, h6, h7, h8⟩ :=
    local_sound l.fan l.vertices l.kinds l.selected l.valid l.mask_length l.represented
  exact h8 u v

def total (L : List LocalPattern) (f : LocalPattern → ℕ) : ℝ :=
  ((L.map f).sum : ℕ)

theorem total_add (L : List LocalPattern) (f g : LocalPattern → ℕ) :
    total L (fun l => f l + g l) = total L f + total L g := by
  induction L with
  | nil => simp [total]
  | cons l L ih =>
    simp only [total, List.map_cons, List.sum_cons, Nat.cast_add] at *
    linarith

theorem local_totals (L : List LocalPattern) :
    4 * (L.length : ℝ) ≤ 2 * total L LocalPattern.d + total L LocalPattern.q +
      total L LocalPattern.p + 3 * total L LocalPattern.j ∧
    2 * total L LocalPattern.x ≤ 2 * total L LocalPattern.y + total L LocalPattern.q +
      total L LocalPattern.p + 3 * total L LocalPattern.j ∧
    2 * total L LocalPattern.j ≤ total L LocalPattern.rad ∧
    total L LocalPattern.q ≤ 4 * L.length ∧
    total L LocalPattern.d = total L LocalPattern.x + total L LocalPattern.y := by
  induction L with
  | nil => norm_num [total]
  | cons l L ih =>
    have h := l.bounds
    have h1 : (4 : ℝ) ≤ 2 * l.d + l.q + l.p + 3 * l.j := by exact_mod_cast h.1
    have h2 : (2 : ℝ) * l.x ≤ 2 * l.y + l.q + l.p + 3 * l.j := by
      exact_mod_cast h.2.1
    have h3 : (2 : ℝ) * l.j ≤ l.rad := by exact_mod_cast h.2.2.1
    have h4 : (l.q : ℝ) ≤ 4 := by exact_mod_cast h.2.2.2.1
    have h5 : (l.d : ℝ) = l.x + l.y := by exact_mod_cast h.2.2.2.2.2
    simp only [total, List.map_cons, List.sum_cons, List.length_cons, Nat.cast_add,
      Nat.cast_one] at *
    constructor
    · linarith [ih.1]
    constructor
    · linarith [ih.2.1]
    constructor
    · linarith [ih.2.2.1]
    constructor
    · linarith [ih.2.2.2.1]
    · linarith [ih.2.2.2.2]

theorem local_population (L : List LocalPattern) :
    L.length ≤ (L.map LocalPattern.q).sum + (L.map LocalPattern.d).sum := by
  induction L with
  | nil => simp
  | cons l L ih =>
    have h := l.nonempty_steps
    simp only [List.length_cons, List.map_cons, List.sum_cons]
    omega

theorem sum_except_le {X : Type} [Fintype X] [DecidableEq X]
    (u v : X → ℝ) (h : ∀ x, u x ≤ v x) (a : X) :
    (∑ x : X, u x) - u a ≤ (∑ x : X, v x) - v a := by
  classical
  have he (f : X → ℝ) :
      (∑ x : X, if x = a then 0 else f x) = (∑ x : X, f x) - f a := by
    calc
      _ = ∑ x : X, (f x - if x = a then f x else 0) := by
        apply Finset.sum_congr rfl
        intro x hx
        by_cases hxa : x = a <;> simp [hxa]
      _ = _ := by simp [Finset.sum_sub_distrib]
  rw [← he u, ← he v]
  apply Finset.sum_le_sum
  intro x hx
  by_cases hxa : x = a
  · simp [hxa]
  · simpa [hxa] using h x

structure Incidence (nt nf ne : ℕ) where
  top : Fin nt → ℕ
  fanWeight : Fin nf → ℕ
  decoration : Fin ne → ℕ
  halfLength : Fin ne → ℕ
  uses : Fin nt → Fin nf → Bool
  seven_slots : ∀ a, (Finset.univ.filter fun b => uses a b).card = 7
  links : Fin nf → List LocalPattern
  turns : Fin nt → Fin nf → ℕ
  turn_budget : ∀ a b, turns a b ≤ if uses a b then top a else 0
  turns_total : ∀ b, ((links b).map LocalPattern.d).sum = ∑ a, turns a b
  dominant : Fin nf → Option (Fin nt)
  dominant_turns : ∀ b a, dominant b = some a →
    ((links b).map LocalPattern.x).sum = turns a b
  weight_links : ∀ b, (links b).length ≤ fanWeight b
  weight_slots : ∀ a b, uses a b = true → top a ≤ fanWeight b
  weight_attained : ∀ b, (links b).length < fanWeight b →
    ∃ a, dominant b = some a ∧ uses a b = true ∧ top a = fanWeight b
  three_turns : 3 * (∑ a, top a) ≤ ∑ b, ((links b).map LocalPattern.d).sum

def Incidence.T {nt nf ne} (D : Incidence nt nf ne) : ℝ := ∑ a, (D.top a : ℝ)
def Incidence.W {nt nf ne} (D : Incidence nt nf ne) : ℝ := ∑ b, (D.fanWeight b : ℝ)
def Incidence.E {nt nf ne} (D : Incidence nt nf ne) : ℝ := ∑ e, (D.decoration e : ℝ)
def Incidence.Q {nt nf ne} (D : Incidence nt nf ne) : ℝ :=
  ∑ b, total (D.links b) LocalPattern.q
def Incidence.P {nt nf ne} (D : Incidence nt nf ne) : ℝ :=
  ∑ b, total (D.links b) LocalPattern.p
def Incidence.J {nt nf ne} (D : Incidence nt nf ne) : ℝ :=
  ∑ b, total (D.links b) LocalPattern.j
def Incidence.Rad {nt nf ne} (D : Incidence nt nf ne) : ℝ :=
  ∑ b, total (D.links b) LocalPattern.rad
def Incidence.S {nt nf ne} (D : Incidence nt nf ne) (b : Fin nf) : ℝ :=
  ∑ a, if D.uses a b then (D.top a : ℝ) else 0
def Incidence.Half {nt nf ne} (D : Incidence nt nf ne) : ℝ :=
  ∑ e, (D.halfLength e : ℝ) * D.decoration e

theorem Incidence.slot_sum {nt nf ne} (D : Incidence nt nf ne) :
    (∑ b, D.S b) = 7 * D.T := by
  classical
  unfold S
  rw [Finset.sum_comm]
  calc
    (∑ a : Fin nt, ∑ b : Fin nf, if D.uses a b then (D.top a : ℝ) else 0) =
        ∑ a : Fin nt, 7 * (D.top a : ℝ) := by
      apply Finset.sum_congr rfl
      intro a ha
      rw [← Finset.sum_filter]
      simp [D.seven_slots a, nsmul_eq_mul]
    _ = _ := by rw [← Finset.mul_sum]; rfl

theorem Incidence.turn_sum_le {nt nf ne} (D : Incidence nt nf ne) (b : Fin nf) :
    total (D.links b) LocalPattern.d ≤ D.S b := by
  have h : ((D.links b).map LocalPattern.d).sum ≤
      ∑ a, if D.uses a b then D.top a else 0 := by
    rw [D.turns_total b]
    exact Finset.sum_le_sum fun a ha => D.turn_budget a b
  unfold total S
  exact_mod_cast h

theorem Incidence.other_turns_le {nt nf ne} (D : Incidence nt nf ne)
    (b : Fin nf) (a : Fin nt) (ha : D.dominant b = some a) (hu : D.uses a b = true) :
    total (D.links b) LocalPattern.y ≤ D.S b - D.top a := by
  have hb (a' : Fin nt) : (D.turns a' b : ℝ) ≤
      if D.uses a' b then (D.top a' : ℝ) else 0 := by
    exact_mod_cast D.turn_budget a' b
  have h := sum_except_le (fun a' => (D.turns a' b : ℝ))
    (fun a' => if D.uses a' b then (D.top a' : ℝ) else 0) hb a
  have ht : (∑ a', (D.turns a' b : ℝ)) = total (D.links b) LocalPattern.d := by
    unfold total
    exact_mod_cast (D.turns_total b).symm
  have hx : (D.turns a b : ℝ) = total (D.links b) LocalPattern.x := by
    unfold total
    exact_mod_cast (D.dominant_turns b a ha).symm
  rw [ht, hx, hu] at h
  have hd := (local_totals (D.links b)).2.2.2.2
  change total (D.links b) LocalPattern.d - total (D.links b) LocalPattern.x ≤
    D.S b - D.top a at h
  linarith

theorem Incidence.apex {nt nf ne} (D : Incidence nt nf ne) (b : Fin nf) :
    2 * total (D.links b) LocalPattern.d + 4 * ((D.fanWeight b : ℝ) - D.S b) ≤
      total (D.links b) LocalPattern.q + total (D.links b) LocalPattern.p +
        3 * total (D.links b) LocalPattern.j := by
  have hl := local_totals (D.links b)
  by_cases hm : (D.links b).length < D.fanWeight b
  · obtain ⟨a, ha, hu, ht⟩ := D.weight_attained b hm
    have hy := D.other_turns_le b a ha hu
    rw [ht] at hy
    linarith [hl.2.1, hl.2.2.2.2]
  · have heq : D.fanWeight b = (D.links b).length :=
      Nat.le_antisymm (Nat.le_of_not_gt hm) (D.weight_links b)
    have heq' : (D.fanWeight b : ℝ) = (D.links b).length := by exact_mod_cast heq
    have hd := D.turn_sum_le b
    linarith [hl.1]

theorem Incidence.nominal_apex {nt nf ne} (D : Incidence nt nf ne) :
    6 * D.T + 4 * (D.W - 7 * D.T) ≤ D.Q + D.P + 3 * D.J := by
  have h := Finset.sum_le_sum (s := Finset.univ) (fun b hb => D.apex b)
  have ht : 3 * D.T ≤ ∑ b, total (D.links b) LocalPattern.d := by
    unfold T total
    exact_mod_cast D.three_turns
  simp only [Finset.sum_add_distrib, ← Finset.mul_sum, Finset.sum_sub_distrib] at h
  rw [D.slot_sum] at h
  change 2 * (∑ b, total (D.links b) LocalPattern.d) + 4 * (D.W - 7 * D.T) ≤
    D.Q + D.P + 3 * D.J at h
  linarith

theorem Incidence.capacities {nt nf ne} (D : Incidence nt nf ne) :
    D.Q ≤ 4 * D.W ∧ 2 * D.J ≤ D.Rad := by
  have hq : ∀ b, total (D.links b) LocalPattern.q ≤ 4 * (D.fanWeight b : ℝ) := by
    intro b
    have h := (local_totals (D.links b)).2.2.2.1
    have hw : ((D.links b).length : ℝ) ≤ D.fanWeight b := by
      exact_mod_cast D.weight_links b
    linarith
  constructor
  · have h := Finset.sum_le_sum (s := Finset.univ) (fun b hb => hq b)
    simpa only [Q, W, Finset.mul_sum] using h
  · have h := Finset.sum_le_sum (s := Finset.univ)
      (fun b hb => (local_totals (D.links b)).2.2.1)
    simpa only [J, Rad, Finset.mul_sum] using h

def fieldWeight {nt nf ne} (D : Incidence nt nf ne)
    (owner : Fin nt ⊕ (Fin nf ⊕ Fin ne)) : ℕ :=
  match owner with
  | .inl a => D.top a
  | .inr (.inl b) => D.fanWeight b
  | .inr (.inr e) => D.decoration e

def layerCost {nt nf ne} (D : Incidence nt nf ne)
    (alpha beta delta : ℝ) (j : ℕ) : ℝ :=
  (∑ a, if j < D.top a then (3 - beta) - 7 * (2 - alpha) else 0) +
  (∑ b, if j < D.fanWeight b then 2 - alpha else 0) +
  (∑ e, if j < D.decoration e then (D.halfLength e : ℝ) - delta else 0)

theorem layer_prerequisites {nt nf ne} (D : Incidence nt nf ne) (j : ℕ)
    (a : Fin nt) (b : Fin nf) (h : j < D.top a) (hu : D.uses a b = true) :
    j < D.fanWeight b :=
  lt_of_lt_of_le h (D.weight_slots a b hu)

theorem layerCost_sum {nt nf ne} (D : Incidence nt nf ne)
    (alpha beta delta : ℝ) (N : ℕ)
    (ht : ∀ a, D.top a ≤ N) (hw : ∀ b, D.fanWeight b ≤ N)
    (he : ∀ e, D.decoration e ≤ N) :
    (∑ j ∈ Finset.range N, layerCost D alpha beta delta j) =
      ((3 - beta) - 7 * (2 - alpha)) * D.T + (2 - alpha) * D.W +
        D.Half - delta * D.E := by
  unfold layerCost
  simp only [Finset.sum_add_distrib]
  rw [layer_sum D.top (fun _ => (3 - beta) - 7 * (2 - alpha)) N ht,
    layer_sum D.fanWeight (fun _ => 2 - alpha) N hw,
    layer_sum D.decoration (fun e => (D.halfLength e : ℝ) - delta) N he]
  simp only [mul_sub, Finset.sum_sub_distrib, ← Finset.sum_mul]
  have hh : (∑ e : Fin ne, (D.decoration e : ℝ) * D.halfLength e) = D.Half := by
    unfold Incidence.Half
    exact Finset.sum_congr rfl (fun e he => mul_comm _ _)
  rw [hh]
  unfold Incidence.T Incidence.W Incidence.E
  ring

theorem Incidence.weight_is_max {nt nf ne} (D : Incidence nt nf ne) (b : Fin nf) :
    D.fanWeight b =
      max (D.links b).length
        (Finset.univ.sup fun a => if D.uses a b then D.top a else 0) := by
  have hs : (Finset.univ.sup fun a => if D.uses a b then D.top a else 0) ≤
      D.fanWeight b := by
    apply Finset.sup_le
    intro a ha
    by_cases hu : D.uses a b = true
    · simpa [hu] using D.weight_slots a b hu
    · simp [hu]
  apply Nat.le_antisymm
  · by_cases hr : (D.links b).length < D.fanWeight b
    · obtain ⟨a, ha, hu, ht⟩ := D.weight_attained b hr
      have h := Finset.le_sup (f := fun a => if D.uses a b then D.top a else 0)
        (Finset.mem_univ a)
      simp only [hu, ↓reduceIte] at h
      rw [ht] at h
      exact h.trans (le_max_right _ _)
    · exact (Nat.le_of_not_gt hr).trans (le_max_left _ _)
  · exact max_le (D.weight_links b) hs

theorem support_card_le_sum {X : Type} [Fintype X] (w : X → ℕ) :
    (Finset.univ.filter fun x => 0 < w x).card ≤ ∑ x, w x := by
  classical
  rw [Finset.card_eq_sum_ones, Finset.sum_filter]
  apply Finset.sum_le_sum
  intro x hx
  by_cases hp : 0 < w x
  · simp only [if_pos hp]
    omega
  · simp only [if_neg hp]
    exact Nat.zero_le _

def Incidence.areaNat {nt nf ne} (D : Incidence nt nf ne) : ℕ :=
  (∑ a, D.top a) + (∑ b, ((D.links b).map LocalPattern.q).sum) +
    ∑ e, D.decoration e

theorem Incidence.fan_support {nt nf ne} (D : Incidence nt nf ne) :
    (Finset.univ.filter fun b => 0 < D.fanWeight b).card ≤
      7 * (∑ a, D.top a) + ∑ b, ((D.links b).map LocalPattern.q).sum := by
  let s (b : Fin nf) : ℕ := ∑ a, if D.uses a b then D.top a else 0
  have hs : (∑ b, s b) = 7 * (∑ a, D.top a) := by
    have h := D.slot_sum
    unfold S T at h
    exact_mod_cast h
  have hb (b : Fin nf) :
      (if 0 < D.fanWeight b then 1 else 0) ≤
        s b + ((D.links b).map LocalPattern.q).sum := by
    by_cases hp : 0 < D.fanWeight b
    · simp only [if_pos hp]
      by_cases hsp : 0 < s b
      · omega
      · have hz : s b = 0 := Nat.eq_zero_of_not_pos hsp
        have hd : ((D.links b).map LocalPattern.d).sum ≤ s b := by
          rw [D.turns_total b]
          exact Finset.sum_le_sum (fun a ha => D.turn_budget a b)
        have hw : D.fanWeight b ≤ (D.links b).length + s b := by
          by_cases hr : (D.links b).length < D.fanWeight b
          · obtain ⟨a, ha, hu, ht⟩ := D.weight_attained b hr
            have ht' : (if D.uses a b then D.top a else 0) ≤ s b :=
              Finset.single_le_sum
                (f := fun a' => if D.uses a' b then D.top a' else 0)
                (fun a' _ => Nat.zero_le _) (Finset.mem_univ a)
            simp only [hu, ↓reduceIte] at ht'
            rw [ht] at ht'
            omega
          · omega
        have hpop := local_population (D.links b)
        omega
    · simp [hp]
  rw [Finset.card_eq_sum_ones, Finset.sum_filter]
  calc
    _ ≤ ∑ b, (s b + ((D.links b).map LocalPattern.q).sum) :=
      Finset.sum_le_sum fun b hb' => hb b
    _ = _ := by rw [Finset.sum_add_distrib, hs]

theorem Incidence.occurrence_bound {nt nf ne} (D : Incidence nt nf ne) :
    (Finset.univ.filter fun a => 0 < D.top a).card +
      (Finset.univ.filter fun b => 0 < D.fanWeight b).card +
      (Finset.univ.filter fun e => 0 < D.decoration e).card ≤ 8 * D.areaNat := by
  have ht := support_card_le_sum D.top
  have hf := D.fan_support
  have he := support_card_le_sum D.decoration
  unfold areaNat
  omega

theorem Incidence.layer_size {nt nf ne} (D : Incidence nt nf ne) (j : ℕ) :
    (Finset.univ.filter fun a => j < D.top a).card +
      (Finset.univ.filter fun b => j < D.fanWeight b).card +
      (Finset.univ.filter fun e => j < D.decoration e).card ≤ 8 * D.areaNat := by
  have hs {X : Type} [Fintype X] (w : X → ℕ) :
      (Finset.univ.filter fun x => j < w x).card ≤
        (Finset.univ.filter fun x => 0 < w x).card := by
    classical
    apply Finset.card_le_card
    intro x hx
    simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hx ⊢
    omega
  exact (Nat.add_le_add (Nat.add_le_add (hs D.top) (hs D.fanWeight))
    (hs D.decoration)).trans D.occurrence_bound

noncomputable def fieldsOf {nt nf ne np : ℕ}
    (owner : Fin np → Fin nt ⊕ (Fin nf ⊕ Fin ne))
    (tops : Finset (Fin nt)) (fans : Finset (Fin nf)) (decos : Finset (Fin ne)) :
    Finset (Fin np) := by
  classical
  exact Finset.univ.filter fun v =>
    match owner v with
    | .inl a => a ∈ tops
    | .inr (.inl b) => b ∈ fans
    | .inr (.inr e) => e ∈ decos

noncomputable def collectionRank {nt nf ne np : ℕ}
    (owner : Fin np → Fin nt ⊕ (Fin nf ⊕ Fin ne)) (root : Fin np → Fin np)
    (tops : Finset (Fin nt)) (fans : Finset (Fin nf)) (decos : Finset (Fin ne)) : ℕ :=
  (fieldsOf owner tops fans decos).card -
    ((fieldsOf owner tops fans decos).image root).card

structure RankedFragment (alpha beta delta : ℝ) (nt nf ne np nh : ℕ)
    extends Incidence nt nf ne where
  owner : Fin np → Fin nt ⊕ (Fin nf ⊕ Fin ne)
  root : Fin np → Fin np
  root_idempotent : ∀ v, root (root v) = root v
  root_maximal : ∀ v, fieldWeight toIncidence (owner v) ≤
    fieldWeight toIncidence (owner (root v))
  side : Fin nh × Bool → (Σ v : Fin np, Fin (fieldWeight toIncidence (owner v)))
  side_injective : Function.Injective side
  side_distinct : ∀ h, (side (h, false)).1 ≠ (side (h, true)).1
  side_class : ∀ h, root (side (h, false)).1 = root (side (h, true)).1
  boundary_raw : ℕ
  boundary_rad : ℕ
  radial_count : toIncidence.Rad ≤ boundary_rad
  raw_count : (boundary_raw : ℝ) + 2 * nh =
    toIncidence.Q + toIncidence.P + 2 * toIncidence.Half
  rank_bound : ∀ (tops : Finset (Fin nt)) (fans : Finset (Fin nf))
      (decos : Finset (Fin ne)),
    (∀ a ∈ tops, ∀ b, uses a b = true → b ∈ fans) →
    tops.card + fans.card + decos.card ≤ 8 * toIncidence.areaNat →
    (collectionRank owner root tops fans decos : ℝ) ≤
      ((3 - beta) - 7 * (2 - alpha)) * tops.card +
      (2 - alpha) * fans.card +
      ∑ e ∈ decos, ((halfLength e : ℝ) - delta)

theorem RankedFragment.layer_rank {alpha beta delta nt nf ne np nh}
    (D : RankedFragment alpha beta delta nt nf ne np nh) (j : ℕ) :
    (layerRank (fun v => fieldWeight D.toIncidence (D.owner v)) D.root j : ℝ) ≤
      layerCost D.toIncidence alpha beta delta j := by
  let tops := Finset.univ.filter fun a => j < D.top a
  let fans := Finset.univ.filter fun b => j < D.fanWeight b
  let decos := Finset.univ.filter fun e => j < D.decoration e
  have hclosed : ∀ a ∈ tops, ∀ b, D.uses a b = true → b ∈ fans := by
    intro a ha b hb
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ _,
      layer_prerequisites D.toIncidence j a b (Finset.mem_filter.mp ha).2 hb⟩
  have hbound := D.rank_bound tops fans decos hclosed (D.toIncidence.layer_size j)
  have hfields : fieldsOf D.owner tops fans decos =
      Finset.univ.filter (fun v => j < fieldWeight D.toIncidence (D.owner v)) := by
    ext v
    cases hv : D.owner v with
    | inl a => simp [fieldsOf, tops, fieldWeight, hv]
    | inr rest =>
      cases rest with
      | inl b => simp [fieldsOf, fans, fieldWeight, hv]
      | inr e => simp [fieldsOf, decos, fieldWeight, hv]
  have hr := rank_is_coincidence_rank
    (fun v => fieldWeight D.toIncidence (D.owner v)) D.root
    D.root_idempotent D.root_maximal j
  have heq : collectionRank D.owner D.root tops fans decos =
      layerRank (fun v => fieldWeight D.toIncidence (D.owner v)) D.root j := by
    unfold collectionRank
    rw [hfields]
    omega
  rw [heq] at hbound
  have hc : layerCost D.toIncidence alpha beta delta j =
      ((3 - beta) - 7 * (2 - alpha)) * tops.card +
      (2 - alpha) * fans.card +
      ∑ e ∈ decos, ((D.halfLength e : ℝ) - delta) := by
    unfold layerCost
    simp only [← Finset.sum_filter]
    simp [tops, fans, decos, nsmul_eq_mul, mul_comm]
    ring
  rw [hc]
  exact hbound

theorem RankedFragment.weighted_contacts {alpha beta delta nt nf ne np nh}
    (D : RankedFragment alpha beta delta nt nf ne np nh) :
    (nh : ℝ) ≤ ((3 - beta) - 7 * (2 - alpha)) * D.toIncidence.T +
      (2 - alpha) * D.toIncidence.W + D.toIncidence.Half - delta * D.toIncidence.E := by
  let N := (∑ a, D.top a) + (∑ b, D.fanWeight b) + ∑ e, D.decoration e
  have ht (a : Fin nt) : D.top a ≤ N := by
    have h : D.top a ≤ ∑ a', D.top a' :=
      Finset.single_le_sum (fun a' _ => Nat.zero_le _) (Finset.mem_univ a)
    omega
  have hw (b : Fin nf) : D.fanWeight b ≤ N := by
    have h : D.fanWeight b ≤ ∑ b', D.fanWeight b' :=
      Finset.single_le_sum (fun b' _ => Nat.zero_le _) (Finset.mem_univ b)
    omega
  have he (e : Fin ne) : D.decoration e ≤ N := by
    have h : D.decoration e ≤ ∑ e', D.decoration e' :=
      Finset.single_le_sum (fun e' _ => Nat.zero_le _) (Finset.mem_univ e)
    omega
  have hp (v : Fin np) : fieldWeight D.toIncidence (D.owner v) ≤ N := by
    cases hv : D.owner v with
    | inl a => simpa [fieldWeight, hv] using ht a
    | inr rest =>
      cases rest with
      | inl b => simpa [fieldWeight, hv] using hw b
      | inr e => simpa [fieldWeight, hv] using he e
  have h := weighted_rank (fun v => fieldWeight D.toIncidence (D.owner v)) D.root
    D.side D.side_injective D.side_distinct D.side_class N hp
    (layerCost D.toIncidence alpha beta delta) (fun j hj => D.layer_rank j)
  simp only [Fintype.card_fin] at h
  rw [layerCost_sum D.toIncidence alpha beta delta N ht hw he] at h
  exact h

theorem RankedFragment.boundary_deficit {alpha beta delta nt nf ne np nh}
    (D : RankedFragment alpha beta delta nt nf ne np nh) :
    4 * ((beta - 7 * alpha) * D.toIncidence.T + alpha * D.toIncidence.W +
      delta * D.toIncidence.E) ≤ 2 * D.boundary_raw + 3 * D.boundary_rad := by
  have hc := D.weighted_contacts
  have ha := D.toIncidence.nominal_apex
  have hr := D.raw_count
  have hj : 2 * D.toIncidence.J ≤ (D.boundary_rad : ℝ) :=
    D.toIncidence.capacities.2.trans D.radial_count
  nlinarith

noncomputable def kappa4 (alpha beta delta : ℝ) : ℝ :=
  min (beta - 7 * alpha) (min (alpha / 4) delta)

noncomputable def kappa5 (alpha beta delta : ℝ) : ℝ :=
  min (beta - 7 * alpha) (min (alpha / 5) delta)

theorem kappa4_pos (alpha beta delta : ℝ)
    (ha : 0 < alpha) (hb : 7 * alpha < beta) (hd : 0 < delta) :
    0 < kappa4 alpha beta delta := by
  unfold kappa4
  exact lt_min (sub_pos.mpr hb) (lt_min (by positivity) hd)

theorem kappa5_pos (alpha beta delta : ℝ)
    (ha : 0 < alpha) (hb : 7 * alpha < beta) (hd : 0 < delta) :
    0 < kappa5 alpha beta delta := by
  unfold kappa5
  exact lt_min (sub_pos.mpr hb) (lt_min (by positivity) hd)

theorem incidence_nonneg {nt nf ne} (D : Incidence nt nf ne) :
    0 ≤ D.T ∧ 0 ≤ D.Q ∧ 0 ≤ D.E := by
  constructor
  · unfold Incidence.T
    positivity
  constructor
  · unfold Incidence.Q total
    positivity
  · unfold Incidence.E
    positivity

theorem deficit_controls_area {nt nf ne} (D : Incidence nt nf ne)
    (alpha beta delta : ℝ) (ha : 0 < alpha) :
    kappa4 alpha beta delta * (D.T + D.Q + D.E) ≤
      (beta - 7 * alpha) * D.T + alpha * D.W + delta * D.E := by
  have hpos := incidence_nonneg D
  have hkt : kappa4 alpha beta delta ≤ beta - 7 * alpha := min_le_left _ _
  have hkq : kappa4 alpha beta delta ≤ alpha / 4 :=
    (min_le_right _ _).trans (min_le_left _ _)
  have hke : kappa4 alpha beta delta ≤ delta :=
    (min_le_right _ _).trans (min_le_right _ _)
  have ht := mul_le_mul_of_nonneg_right hkt hpos.1
  have he := mul_le_mul_of_nonneg_right hke hpos.2.2
  have hq : kappa4 alpha beta delta * D.Q ≤ alpha * D.W := by
    calc
      _ ≤ (alpha / 4) * D.Q := mul_le_mul_of_nonneg_right hkq hpos.2.1
      _ ≤ (alpha / 4) * (4 * D.W) :=
        mul_le_mul_of_nonneg_left D.capacities.1 (by positivity)
      _ = _ := by ring
  nlinarith

theorem fragment_bound {alpha beta delta nt nf ne np nh}
    (D : RankedFragment alpha beta delta nt nf ne np nh)
    (ha : 0 < alpha) :
    4 * kappa4 alpha beta delta *
        (D.toIncidence.T + D.toIncidence.Q + D.toIncidence.E) ≤
      2 * D.boundary_raw + 3 * D.boundary_rad ∧
    2 * (D.boundary_raw : ℝ) + 3 * D.boundary_rad ≤
      3 * ((D.boundary_raw : ℝ) + D.boundary_rad) := by
  have h := deficit_controls_area D.toIncidence alpha beta delta ha
  have hbnd := D.boundary_deficit
  have hraw : (0 : ℝ) ≤ D.boundary_raw := Nat.cast_nonneg _
  constructor <;> nlinarith

theorem manuscript_fragment {alpha beta delta nt nf ne np nh}
    (D : RankedFragment alpha beta delta nt nf ne np nh)
    (ha : 0 < alpha) (hb : 7 * alpha < beta) (hd : 0 < delta) :
    D.toIncidence.T + D.toIncidence.Q + D.toIncidence.E ≤
      ((D.boundary_raw : ℝ) + D.boundary_rad) / kappa5 alpha beta delta := by
  have h := fragment_bound D ha
  have hk : kappa5 alpha beta delta ≤ kappa4 alpha beta delta := by
    unfold kappa5 kappa4
    apply min_le_min le_rfl
    apply min_le_min _ le_rfl
    linarith
  have harea : 0 ≤ D.toIncidence.T + D.toIncidence.Q + D.toIncidence.E := by
    have hn := incidence_nonneg D.toIncidence
    linarith
  have hmul := mul_le_mul_of_nonneg_right hk harea
  have hbnd : (0 : ℝ) ≤ (D.boundary_raw : ℝ) + D.boundary_rad := by positivity
  apply (le_div_iff₀ (kappa5_pos alpha beta delta ha hb hd)).mpr
  nlinarith

end DiagramDeficit
