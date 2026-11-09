import Mathlib

set_option autoImplicit false
set_option maxHeartbeats 1500000
set_option linter.unusedSectionVars false

namespace TemporalBoundary

variable {Job : Type*} [Fintype Job] [DecidableEq Job]

structure Precedence (Job : Type*) [Fintype Job] where
  rel : Job → Job → Prop
  irrefl : ∀ x, ¬ rel x x
  trans : ∀ {x y z}, rel x y → rel y z → rel x z
  rank : Job → ℕ
  rank_injective : Function.Injective rank
  rank_pos : ∀ x, 1 ≤ rank x
  rank_bound : ∀ x, rank x ≤ Fintype.card Job
  rank_strict : ∀ {x y}, rel x y → rank x < rank y

structure Complete (T : ℕ) (f : Job → ℤ) : Prop where
  range : ∀ x, 1 ≤ f x ∧ f x ≤ T
  triple : ∀ t : ℤ, 1 ≤ t → t ≤ T → Nat.card {x // f x = t} = 3

def Feasible (P : Precedence Job) (f : Job → ℤ) : Prop :=
  ∀ ⦃x y⦄, P.rel x y → f x < f y

structure Schedule (P : Precedence Job) (T : ℕ) where
  time : Job → ℤ
  feasible : Feasible P time
  complete : Complete T time

def Inside {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a b : ℤ) : Set Job :=
  {x | a < σ.time x ∧ σ.time x < b}

def Reorders {P : Precedence Job} {T : ℕ} (σ τ : Schedule P T)
    (a b : ℤ) : Prop :=
  (∀ x, x ∈ Inside σ a b ↔ x ∈ Inside τ a b) ∧
  ∀ x, x ∉ Inside σ a b → τ.time x = σ.time x

theorem reorders_refl {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (a b : ℤ) : Reorders σ σ a b :=
  ⟨fun _ => Iff.rfl, fun _ _ => rfl⟩

theorem reorders_trans {P : Precedence Job} {T : ℕ}
    {σ τ υ : Schedule P T} {a b : ℤ}
    (h : Reorders σ τ a b) (k : Reorders τ υ a b) :
    Reorders σ υ a b := by
  refine ⟨fun x => (h.1 x).trans (k.1 x), ?_⟩
  intro x hx
  exact (k.2 x (fun ht => hx ((h.1 x).mpr ht))).trans (h.2 x hx)

theorem reorders_enlarge {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a b c d : ℤ}
    (h : Reorders σ τ c d) (hac : a ≤ c) (hdb : d ≤ b) :
    Reorders σ τ a b := by
  have forward : ∀ x, x ∈ Inside σ a b → x ∈ Inside τ a b := by
    intro x hx
    by_cases hc : x ∈ Inside σ c d
    · have ht := (h.1 x).mp hc
      exact ⟨lt_of_le_of_lt hac ht.1, lt_of_lt_of_le ht.2 hdb⟩
    · simpa only [Inside, Set.mem_setOf_eq, h.2 x hc] using hx
  refine ⟨fun x => ⟨forward x, ?_⟩, ?_⟩
  · intro hx
    by_cases hc : x ∈ Inside σ c d
    · exact ⟨lt_of_le_of_lt hac hc.1, lt_of_lt_of_le hc.2 hdb⟩
    · simpa only [Inside, Set.mem_setOf_eq, h.2 x hc] using hx
  · intro x hx
    apply h.2 x
    intro hc
    exact hx ⟨lt_of_le_of_lt hac hc.1, lt_of_lt_of_le hc.2 hdb⟩

inductive Boundary (Job : Type*)
  | left
  | actual (jobs : Finset Job)
  | right

def Boundary.jobs : Boundary Job → Finset Job
  | .left | .right => ∅
  | .actual jobs => jobs

def Boundary.reverse : Boundary Job → Boundary Job
  | .left => .right
  | .right => .left
  | .actual jobs => .actual jobs

def D (P : Precedence Job) : Boundary Job → Set Job
  | .left => Set.univ
  | .right => ∅
  | .actual jobs => {x | ∃ y ∈ jobs, P.rel y x}

def Pred (P : Precedence Job) : Boundary Job → Set Job
  | .left => ∅
  | .right => Set.univ
  | .actual jobs => {x | ∃ y ∈ jobs, P.rel x y}

def WeakD (P : Precedence Job) (B : Boundary Job) : Set Job :=
  D P B ∪ (B.jobs : Set Job)

def WeakPred (P : Precedence Job) (B : Boundary Job) : Set Job :=
  Pred P B ∪ (B.jobs : Set Job)

def Placed {P : Precedence Job} {T : ℕ} (σ : Schedule P T) :
    Boundary Job → ℤ → Prop
  | .left, a => a = 0
  | .right, a => a = (T : ℤ) + 1
  | .actual jobs, a => jobs.card = 3 ∧ ∀ x, x ∈ jobs ↔ σ.time x = a

def IsUp (P : Precedence Job) (A : Set Job) : Prop :=
  ∀ ⦃x y⦄, P.rel x y → x ∈ A → y ∈ A

def IsDown (P : Precedence Job) (A : Set Job) : Prop :=
  ∀ ⦃x y⦄, P.rel x y → y ∈ A → x ∈ A

theorem D_up (P : Precedence Job) (B : Boundary Job) : IsUp P (D P B) := by
  cases B with
  | left => exact fun _ _ _ _ => Set.mem_univ _
  | right => exact fun _ _ _ hx => False.elim hx
  | actual jobs =>
      rintro x y hxy ⟨z, hz, hzx⟩
      exact ⟨z, hz, P.trans hzx hxy⟩

theorem pred_down (P : Precedence Job) (B : Boundary Job) :
    IsDown P (Pred P B) := by
  cases B with
  | left => exact fun _ _ _ hy => False.elim hy
  | right => exact fun _ _ _ _ => Set.mem_univ _
  | actual jobs =>
      rintro x y hxy ⟨z, hz, hyz⟩
      exact ⟨z, hz, P.trans hxy hyz⟩

theorem weakPred_down (P : Precedence Job) (B : Boundary Job) :
    IsDown P (WeakPred P B) := by
  intro x y hxy hy
  rcases hy with hy | hy
  · exact Or.inl (pred_down P B hxy hy)
  · cases B with
    | left => simp [Boundary.jobs] at hy
    | right => exact Or.inl (Set.mem_univ _)
    | actual jobs => exact Or.inl ⟨y, hy, hxy⟩

theorem D_after {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : Boundary Job} {a : ℤ} (hB : Placed σ B a)
    {x : Job} (hx : x ∈ D P B) : a < σ.time x := by
  cases B with
  | left =>
      dsimp [Placed] at hB
      have := (σ.complete.range x).1
      omega
  | right => exact False.elim hx
  | actual jobs =>
      obtain ⟨y, hy, hyx⟩ := hx
      have ht := (hB.2 y).mp hy
      simpa only [ht] using σ.feasible hyx

theorem weakPred_before {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : Boundary Job} {a : ℤ} (hB : Placed σ B a)
    {x : Job} (hx : x ∈ WeakPred P B) : σ.time x ≤ a := by
  cases B with
  | left => simp [WeakPred, Pred, Boundary.jobs] at hx
  | right =>
      dsimp [Placed] at hB
      have := (σ.complete.range x).2
      omega
  | actual jobs =>
      rcases hx with ⟨y, hy, hxy⟩ | hx
      · have ht := (hB.2 y).mp hy
        exact (σ.feasible hxy).le.trans_eq ht
      · exact ((hB.2 x).mp hx).le

theorem at_not_D {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : Boundary Job} {a : ℤ} (hB : Placed σ B a)
    {x : Job} (hx : σ.time x ≤ a) : x ∉ D P B :=
  fun hd => (not_lt_of_ge hx) (D_after hB hd)

def swapTime {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (x y : Job) : Job → ℤ :=
  σ.time ∘ Equiv.swap x y

def ExchangeFeasible {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (x y : Job) : Prop :=
  Feasible P (swapTime σ x y)

theorem complete_reindex {T : ℕ} {f : Job → ℤ}
    (h : Complete T f) (e : Job ≃ Job) : Complete T (f ∘ e) := by
  refine ⟨fun x => h.range (e x), ?_⟩
  intro t ht hT
  let k : {x // (f ∘ e) x = t} ≃ {x // f x = t} :=
    { toFun := fun x => ⟨e x, x.property⟩
      invFun := fun x => ⟨e.symm x, by simpa using x.property⟩
      left_inv := fun x => by ext; simp
      right_inv := fun x => by ext; simp }
  exact (Nat.card_congr k).trans (h.triple t ht hT)

noncomputable def exchanged {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (x y : Job) (h : ExchangeFeasible σ x y) :
    Schedule P T :=
  ⟨swapTime σ x y, h, complete_reindex σ.complete (Equiv.swap x y)⟩

structure Priority (P : Precedence Job) where
  index : Job → ℕ
  injective : Function.Injective index
  respects : ∀ {x y}, P.rel x y → index x < index y

noncomputable def slotJobs {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (t : ℤ) : Finset Job := by
  classical
  exact Finset.univ.filter (fun x => σ.time x = t)

noncomputable def slotKeys {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (π : Priority P) (t : ℤ) : Finset ℕ :=
  (slotJobs σ t).image π.index

noncomputable def slotWord {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (π : Priority P) (t : ℤ) : List ℕ :=
  (slotKeys σ π t).sort (· ≤ ·)

noncomputable def sideSlots (a b : ℤ) : List ℤ :=
  (Finset.Ioo a b).sort (· ≤ ·)

noncomputable def word {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (π : Priority P) (a b : ℤ) : List ℕ :=
  (sideSlots a b).flatMap (slotWord σ π)

def Normalized {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (π : Priority P) (a b : ℤ) : Prop :=
  ∀ τ : Schedule P T, Reorders σ τ a b →
    ¬ List.Lex (· < ·) (word τ π a b) (word σ π a b)

theorem orderedInsert_improves (l : List ℕ) {x y : ℕ}
    (hxy : x < y) (hx : x ∉ l) :
    List.Lex (· < ·) (l.orderedInsert (· ≤ ·) x)
      (l.orderedInsert (· ≤ ·) y) := by
  induction l with
  | nil => exact List.Lex.rel hxy
  | cons a l ih =>
      have hxa : x ≠ a := fun h => hx (by simp [h])
      have hxl : x ∉ l := fun h => hx (by simp [h])
      simp only [List.orderedInsert_cons]
      by_cases hxa' : x ≤ a
      · rw [if_pos hxa']
        by_cases hya : y ≤ a
        · rw [if_pos hya]
          exact List.Lex.rel hxy
        · rw [if_neg hya]
          exact List.Lex.rel (lt_of_le_of_ne hxa' hxa)
      · have hya : ¬ y ≤ a := by omega
        rw [if_neg hxa', if_neg hya]
        exact List.Lex.cons (ih hxl)

theorem sort_insert_ordered (s : Finset ℕ) (x : ℕ) (hx : x ∉ s) :
    (insert x s).sort (· ≤ ·) =
      (s.sort (· ≤ ·)).orderedInsert (· ≤ ·) x := by
  apply List.Perm.eq_of_pairwise' (r := (· ≤ ·))
      (Finset.pairwise_sort _ _)
      ((Finset.pairwise_sort s (· ≤ ·)).orderedInsert x _)
  rw [← Multiset.coe_eq_coe]
  rw [Finset.sort_eq,
    Multiset.coe_eq_coe.mpr (List.perm_orderedInsert (· ≤ ·) x (s.sort (· ≤ ·)))]
  change (insert x s).val = x ::ₘ (↑(s.sort (· ≤ ·)) : Multiset ℕ)
  rw [Finset.sort_eq]
  exact Finset.insert_val_of_notMem hx

theorem lex_append_arbitrary {α : Type*} {r : α → α → Prop}
    {l m : List α} (h : List.Lex r l m) (hlen : l.length = m.length)
    (u v : List α) : List.Lex r (l ++ u) (m ++ v) := by
  induction h with
  | nil => simp_all
  | rel h => exact List.Lex.rel h
  | cons h ih =>
      exact List.Lex.cons (ih (by simpa using hlen))

theorem flatMap_lex_at {α : Type*} {f g : ℤ → List α}
    {R : α → α → Prop} (ts : List ℤ) (hs : ts.Pairwise (· < ·))
    {r : ℤ} (hr : r ∈ ts)
    (hb : ∀ t ∈ ts, t < r → f t = g t)
    (ha : List.Lex R (f r) (g r)) (hlen : (f r).length = (g r).length) :
    List.Lex R (ts.flatMap f) (ts.flatMap g) := by
  induction ts with
  | nil => simp at hr
  | cons t ts ih =>
      simp only [List.pairwise_cons] at hs
      rcases List.mem_cons.mp hr with h | h
      · subst t
        simpa only [List.flatMap_cons] using
          lex_append_arbitrary ha hlen (ts.flatMap f) (ts.flatMap g)
      · have ht := hs.1 r h
        have he := hb t (by simp) ht
        simp only [List.flatMap_cons, he]
        apply List.Lex.append_left
        exact ih hs.2 h (fun u hu => hb u (by simp [hu]))

theorem reorders_exchange_inside {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {x y : Job} {a b : ℤ}
    (hx : x ∈ Inside σ a b) (hy : y ∈ Inside σ a b)
    (hf : ExchangeFeasible σ x y) :
    Reorders σ (exchanged σ x y hf) a b := by
  classical
  have he : ∀ z, z ≠ x → z ≠ y →
      (exchanged σ x y hf).time z = σ.time z := by
    intro z hzx hzy
    simp [exchanged, swapTime, Equiv.swap_apply_of_ne_of_ne hzx hzy]
  refine ⟨?_, ?_⟩
  · intro z
    by_cases hzx : z = x
    · subst z
      simpa only [Inside, Set.mem_setOf_eq, exchanged, swapTime,
        Function.comp_apply, Equiv.swap_apply_left] using (iff_of_true hx hy)
    by_cases hzy : z = y
    · subst z
      simpa only [Inside, Set.mem_setOf_eq, exchanged, swapTime,
        Function.comp_apply, Equiv.swap_apply_right] using (iff_of_true hy hx)
    · simp only [Inside, Set.mem_setOf_eq, he z hzx hzy]
  · intro z hz
    exact he z (fun h => hz (h ▸ hx)) (fun h => hz (h ▸ hy))

theorem slotJobs_exchange_before {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {x y : Job} {t : ℤ}
    (hxy : σ.time y < σ.time x) (ht : t < σ.time y)
    (hf : ExchangeFeasible σ x y) :
    slotJobs (exchanged σ x y hf) t = slotJobs σ t := by
  classical
  ext z
  have hxt : σ.time x ≠ t := by omega
  have hyt : σ.time y ≠ t := by omega
  by_cases hzx : z = x
  · subst z
    simp [slotJobs, exchanged, swapTime, hxt, hyt]
  by_cases hzy : z = y
  · subst z
    simp [slotJobs, exchanged, swapTime, hxt, hyt]
  · simp [slotJobs, exchanged, swapTime,
      Equiv.swap_apply_of_ne_of_ne hzx hzy]

theorem slotJobs_exchange_at {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {x y : Job}
    (hxy : σ.time y < σ.time x) (hf : ExchangeFeasible σ x y) :
    slotJobs (exchanged σ x y hf) (σ.time y) =
      insert x ((slotJobs σ (σ.time y)).erase y) := by
  classical
  have hne : x ≠ y := by intro h; subst y; omega
  have htne : σ.time x ≠ σ.time y := ne_of_gt hxy
  ext z
  by_cases hzx : z = x
  · subst z
    simp [slotJobs, exchanged, swapTime]
  by_cases hzy : z = y
  · subst z
    simp [slotJobs, exchanged, swapTime, hne.symm, htne]
  · simp [slotJobs, exchanged, swapTime, hzx, hzy,
      Equiv.swap_apply_of_ne_of_ne hzx hzy]

theorem slotWord_exchange_improves {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} (π : Priority P) {x y : Job}
    (hxy : σ.time y < σ.time x) (hπ : π.index x < π.index y)
    (hf : ExchangeFeasible σ x y) :
    List.Lex (· < ·) (slotWord (exchanged σ x y hf) π (σ.time y))
      (slotWord σ π (σ.time y)) ∧
    (slotWord (exchanged σ x y hf) π (σ.time y)).length =
      (slotWord σ π (σ.time y)).length := by
  classical
  let s := ((slotJobs σ (σ.time y)).erase y).image π.index
  have hx : π.index x ∉ s := by
    intro h
    obtain ⟨z, hz, he⟩ := Finset.mem_image.mp h
    have hez : z = x := π.injective he
    subst z
    have ht : σ.time x = σ.time y := by
      simpa [slotJobs] using (Finset.mem_erase.mp hz).2
    omega
  have hy : π.index y ∉ s := by
    intro h
    obtain ⟨z, hz, he⟩ := Finset.mem_image.mp h
    exact (Finset.mem_erase.mp hz).1 (π.injective he)
  have hsnew : slotKeys (exchanged σ x y hf) π (σ.time y) = insert (π.index x) s := by
    simp only [slotKeys, slotJobs_exchange_at hxy hf, Finset.image_insert, s]
  have hsold : slotKeys σ π (σ.time y) = insert (π.index y) s := by
    have hyj : y ∈ slotJobs σ (σ.time y) := by simp [slotJobs]
    dsimp [slotKeys, s]
    rw [← Finset.image_insert, Finset.insert_erase hyj]
  simp only [slotWord, hsnew, hsold, sort_insert_ordered s _ hx,
    sort_insert_ordered s _ hy]
  exact ⟨orderedInsert_improves _ hπ (by simpa only [Finset.mem_sort] using hx),
    by simp only [List.orderedInsert_length]⟩

theorem lex_prefix_no_exchange {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {π : Priority P} {a b r : ℤ}
    (hn : Normalized σ π a b) (hτ : Reorders σ τ a b)
    (hp : ∀ t ≤ r, slotJobs τ t = slotJobs σ t)
    {x y : Job} (hx : x ∈ Inside τ a b)
    (hyr : τ.time y = r) (har : a < r) (hry : r < τ.time x)
    (hπ : π.index x < π.index y) : ¬ ExchangeFeasible τ x y := by
  intro hf
  have hrb : r < b := hry.trans hx.2
  have hy : y ∈ Inside τ a b := ⟨by simpa [hyr] using har, by simpa [hyr] using hrb⟩
  let υ := exchanged τ x y hf
  have hυ : Reorders σ υ a b :=
    reorders_trans hτ (reorders_exchange_inside hx hy hf)
  apply hn υ hυ
  apply flatMap_lex_at (sideSlots a b) (Finset.sortedLT_sort _).pairwise
      (r := r)
  · simpa only [sideSlots, Finset.mem_sort, Finset.mem_Ioo] using And.intro har hrb
  · intro t _ htr
    dsimp [slotWord, slotKeys, υ]
    rw [slotJobs_exchange_before (by simpa [hyr] using hry) (by simpa [hyr] using htr) hf,
      hp t htr.le]
  · have h := (slotWord_exchange_improves π (by simpa [hyr] using hry) hπ hf).1
    rw [hyr] at h
    simpa only [slotWord, slotKeys, hp r le_rfl] using h
  · have h := (slotWord_exchange_improves π (by simpa [hyr] using hry) hπ hf).2
    rw [hyr] at h
    simpa only [slotWord, slotKeys, hp r le_rfl] using h

theorem child_reordering_keeps_prefix {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {c d : ℤ} (h : Reorders σ τ c d) :
    ∀ t ≤ c, slotJobs τ t = slotJobs σ t := by
  intro t htc
  classical
  ext x
  simp only [slotJobs, Finset.mem_filter, Finset.mem_univ, true_and]
  by_cases hx : x ∈ Inside σ c d
  · have hx' := (h.1 x).mp hx
    have hσ : σ.time x ≠ t := by intro he; have := hx.1; omega
    have hτ : τ.time x ≠ t := by intro he; have := hx'.1; omega
    simp [hσ, hτ]
  · rw [h.2 x hx]

theorem normalized_child_future_no_exchange {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {π : Priority P} {a b c d : ℤ}
    (hn : Normalized σ π a b) (hτ : Reorders σ τ c d)
    (hac : a < c) (hdb : d ≤ b)
    {x y : Job} (hx : x ∈ Inside τ c d)
    (hy : τ.time y = c) (hπ : π.index x < π.index y) :
    ¬ ExchangeFeasible τ x y :=
  lex_prefix_no_exchange hn (reorders_enlarge hτ hac.le hdb)
    (child_reordering_keeps_prefix hτ)
    ⟨hac.trans hx.1, lt_of_lt_of_le hx.2 hdb⟩ hy hac
    (by simpa [hy] using hx.1) hπ

theorem boundary_jobs_time {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {B : Boundary Job} {a : ℤ}
    (hB : Placed σ B a) {x : Job} (hx : x ∈ B.jobs) :
    σ.time x = a := by
  cases B with
  | left => simp [Boundary.jobs] at hx
  | right => simp [Boundary.jobs] at hx
  | actual jobs => exact (hB.2 x).mp hx

theorem time_mem_boundary {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {B : Boundary Job} {a : ℤ}
    (hB : Placed σ B a) {x : Job} (hx : σ.time x = a) :
    x ∈ B.jobs := by
  cases B with
  | left =>
      have hr := (σ.complete.range x).1
      dsimp [Placed] at hB
      omega
  | right =>
      have hr := (σ.complete.range x).2
      dsimp [Placed] at hB
      omega
  | actual jobs => exact (hB.2 x).mpr hx

theorem relation_at_boundary_descends {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {B : Boundary Job} {a : ℤ}
    (hB : Placed σ B a) {u x : Job} (hu : σ.time u = a)
    (hux : P.rel u x) : x ∈ D P B := by
  have hum := time_mem_boundary hB hu
  cases B with
  | left => exact Set.mem_univ _
  | right => simp [Boundary.jobs] at hum
  | actual jobs => exact ⟨u, hum, hux⟩

theorem exchange_feasible_of_ready {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {x y : Job} (hxy : σ.time y < σ.time x)
    (hpred : ∀ u, P.rel u x → σ.time u < σ.time y)
    (hsucc : ∀ z, P.rel y z → σ.time x < σ.time z) :
    ExchangeFeasible σ x y := by
  have hne : x ≠ y := by intro h; subst y; omega
  intro u z huz
  have old := σ.feasible huz
  by_cases hux : u = x
  · subst u
    by_cases hzx : z = x
    · subst z; exact False.elim (P.irrefl x huz)
    by_cases hzy : z = y
    · subst z; omega
    · simpa only [swapTime, Function.comp_apply, Equiv.swap_apply_left,
        Equiv.swap_apply_of_ne_of_ne hzx hzy] using hxy.trans old
  by_cases huy : u = y
  · subst u
    by_cases hzx : z = x
    · subst z; have := hpred y huz; omega
    by_cases hzy : z = y
    · subst z; exact False.elim (P.irrefl y huz)
    · simpa only [swapTime, Function.comp_apply, Equiv.swap_apply_right,
        Equiv.swap_apply_of_ne_of_ne hzx hzy] using hsucc z huz
  by_cases hzx : z = x
  · subst z
    simpa only [swapTime, Function.comp_apply,
      Equiv.swap_apply_of_ne_of_ne hux huy, Equiv.swap_apply_left] using hpred u huz
  by_cases hzy : z = y
  · subst z
    simpa only [swapTime, Function.comp_apply,
      Equiv.swap_apply_of_ne_of_ne hux huy, Equiv.swap_apply_right] using old.trans hxy
  · simpa only [swapTime, Function.comp_apply,
      Equiv.swap_apply_of_ne_of_ne hux huy,
      Equiv.swap_apply_of_ne_of_ne hzx hzy] using old

theorem successor_forced_by_no_exchange {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {x y : Job} (hxy : σ.time y < σ.time x)
    (hpred : ∀ u, P.rel u x → σ.time u < σ.time y)
    (hno : ¬ ExchangeFeasible σ x y) :
    ∃ z, P.rel y z ∧ σ.time z ≤ σ.time x := by
  classical
  by_contra h
  push Not at h
  exact hno (exchange_feasible_of_ready hxy hpred h)

def Reach (P : Precedence Job) (x y : Job) : Prop :=
  x = y ∨ P.rel x y

theorem reach_trans {P : Precedence Job} {x y z : Job}
    (h : Reach P x y) (k : Reach P y z) : Reach P x z := by
  rcases h with rfl | h
  · exact k
  rcases k with rfl | k
  · exact Or.inr h
  · exact Or.inr (P.trans h k)

theorem trace_strict_successors {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {C : Set Job} {s t : ℤ}
    (hstep : ∀ y ∈ C, s ≤ σ.time y → σ.time y < t →
      ∃ z, z ∈ C ∧ P.rel y z ∧ σ.time z ≤ t)
    {y : Job} (hy : y ∈ C) (hsy : s ≤ σ.time y) (hyt : σ.time y ≤ t) :
    ∃ z, z ∈ C ∧ σ.time z = t ∧ Reach P y z := by
  have aux : ∀ n : ℕ, ∀ y ∈ C, s ≤ σ.time y → σ.time y ≤ t →
      (t - σ.time y).toNat = n →
      ∃ z, z ∈ C ∧ σ.time z = t ∧ Reach P y z := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
        intro y hy hsy hyt he
        by_cases htime : σ.time y = t
        · exact ⟨y, hy, htime, Or.inl rfl⟩
        have hlt : σ.time y < t := lt_of_le_of_ne hyt htime
        obtain ⟨u, hu, hyu, hut⟩ := hstep y hy hsy hlt
        have htimeu := σ.feasible hyu
        have hm : (t - σ.time u).toNat < n := by omega
        obtain ⟨z, hz, hzt, huz⟩ :=
          ih _ hm u hu (by omega) hut rfl
        exact ⟨z, hz, hzt, reach_trans (Or.inr hyu) huz⟩
  exact aux _ y hy hsy hyt rfl

def LowPrefix {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (π : Priority P) (a v : ℤ) (L : Set Job) : Prop :=
  ∀ x ∈ Inside σ a v, x ∈ L →
    ∀ y ∈ Inside σ a v, y ∉ L → π.index x < π.index y

theorem lowPrefix_ideal {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v : ℤ} {L : Set Job}
    (hL : LowPrefix σ π a v L) {u x : Job}
    (hu : u ∈ Inside σ a v) (hx : x ∈ Inside σ a v)
    (hux : P.rel u x) (hxl : x ∈ L) : u ∈ L := by
  by_contra hul
  have h₁ := hL x hx hxl u hu hul
  have h₂ := π.respects hux
  omega

structure EarliestAdvance {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (a v : ℤ) (L : Set Job)
    (B : Boundary Job) (s : ℤ) (target : Finset Job) (t : ℤ) : Prop where
  source : Placed σ B s
  target_slot : Placed σ (.actual target) t
  increasing : s < t
  target_in_side : a < t ∧ t < v
  exception : ∃ x, σ.time x = t ∧ x ∈ L ∧ x ∉ D P B
  earliest : ∀ u ∈ Inside σ a v, u ∈ L →
    s < σ.time u → σ.time u < t → u ∈ D P B

theorem earliest_exception_ready {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v s t : ℤ}
    {L : Set Job} {B : Boundary Job} {target : Finset Job}
    (hL : LowPrefix σ π a v L)
    (h : EarliestAdvance σ a v L B s target t) (has : a ≤ s)
    {x : Job} (hxt : σ.time x = t) (hxl : x ∈ L) (hxD : x ∉ D P B) :
    ∀ u, P.rel u x → σ.time u < s := by
  intro u hux
  have hut : σ.time u < t := by simpa [hxt] using σ.feasible hux
  by_contra hus
  have hsu : s ≤ σ.time u := le_of_not_gt hus
  have hx : x ∈ Inside σ a v := by simpa [Inside, hxt] using h.target_in_side
  by_cases hueq : σ.time u = s
  · exact hxD (relation_at_boundary_descends h.source hueq hux)
  · have hsu' : s < σ.time u := lt_of_le_of_ne hsu (Ne.symm hueq)
    have hu : u ∈ Inside σ a v :=
      ⟨lt_of_le_of_lt has hsu', hut.trans h.target_in_side.2⟩
    have hul := lowPrefix_ideal hL hu hx hux hxl
    exact hxD (D_up P B hux (h.earliest u hu hul hsu' hut))

def I2 {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (A : Boundary Job) (a : ℤ) (Q : Set Job) : Prop :=
  ∀ z ∈ Q, σ.time z ≤ a → z ∈ WeakPred P A

def I3 {P : Precedence Job} {T : ℕ} {Key : Type*} [LT Key]
    (σ : Schedule P T) (A : Boundary Job) (a b : ℤ)
    (Q : Set Job) (key : Job → Key) : Prop :=
  ∀ τ : Schedule P T, Reorders σ τ a b →
    ∀ x ∈ Inside τ a b, x ∉ D P A →
      ∀ y ∈ A.jobs, y ∈ Q → key x < key y → ¬ ExchangeFeasible τ x y

inductive ExceptionWalk {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (π : Priority P) (a v : ℤ) (S : Set Job)
    (A : Boundary Job) : Boundary Job → ℤ → Prop
  | start (hA : Placed σ A a) : ExceptionWalk σ π a v S A A a
  | advance {B : Boundary Job} {s t : ℤ} {target : Finset Job}
      (past : ExceptionWalk σ π a v S A B s)
      (L : Set Job) (cut_prefix : LowPrefix σ π a v L)
      (within : ∀ x ∈ Inside σ a v, x ∈ L → x ∈ S)
      (step : EarliestAdvance σ a v L B s target t) :
      ExceptionWalk σ π a v S A (.actual target) t

theorem walk_start_or_interior {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v c : ℤ}
    {S : Set Job} {A B : Boundary Job}
    (h : ExceptionWalk σ π a v S A B c) :
    (B = A ∧ c = a) ∨ (a < c ∧ c < v) := by
  cases h with
  | start _ => exact Or.inl ⟨rfl, rfl⟩
  | advance _ _ _ _ step => exact Or.inr step.target_in_side

theorem walk_placed {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v c : ℤ}
    {S : Set Job} {A B : Boundary Job}
    (h : ExceptionWalk σ π a v S A B c) : Placed σ B c := by
  cases h with
  | start hA => exact hA
  | advance _ _ _ _ step => exact step.target_slot

theorem walk_carry_transport {P : Precedence Job} {T : ℕ}
    {Key : Type*} [LT Key] {parent σ : Schedule P T}
    {π : Priority P} {a b v c : ℤ} {S Q C : Set Job}
    {oldKey : Job → Key} {A B : Boundary Job}
    (hwalk : ExceptionWalk σ π a v S A B c)
    (hn : Normalized σ π a v) (hvb : v ≤ b)
    (hprep : Reorders parent σ a b) (hI3 : I3 parent A a b Q oldKey)
    (hCup : IsUp P C) (hCQ : C ⊆ Q)
    (hhigh : ∀ y ∈ Inside σ a v, y ∈ C → y ∉ S)
    (hkeys : ∀ x ∈ Inside σ a v, x ∈ S → x ∉ D P A →
      ∀ y ∈ C, oldKey x < oldKey y) :
    ∀ y ∈ A.jobs, y ∈ C →
      ∃ z ∈ B.jobs, z ∈ C ∧ Reach P y z := by
  induction hwalk with
  | start hA =>
      intro y hy hyC
      exact ⟨y, hy, hyC, Or.inl rfl⟩
  | @advance B s t target past L hL hLS step ih =>
      intro y hy hyC
      obtain ⟨u, hu, huC, hyu⟩ := ih y hy hyC
      obtain ⟨x, hxt, hxL, hxD⟩ := step.exception
      have hxE : x ∈ Inside σ a v := by
        simpa [Inside, hxt] using step.target_in_side
      have hsCase := walk_start_or_interior past
      have has : a ≤ s := by rcases hsCase with ⟨_, rfl⟩ | h; exact le_rfl; exact h.1.le
      have hready := earliest_exception_ready hL step has hxt hxL hxD
      have hlocalStep : ∀ q ∈ C, s ≤ σ.time q → σ.time q < t →
          ∃ z, z ∈ C ∧ P.rel q z ∧ σ.time z ≤ t := by
        intro q hq hsq hqt
        have hno : ¬ ExchangeFeasible σ x q := by
          by_cases hqa : σ.time q = a
          · have hsa : s = a := by omega
            have hBA : B = A := by
              rcases hsCase with h | h
              · exact h.1
              · omega
            have hqA : q ∈ A.jobs :=
              time_mem_boundary (by simpa [hBA, hsa] using step.source) hqa
            have hxDA : x ∉ D P A := by simpa [hBA] using hxD
            apply hI3 σ hprep x ⟨hxE.1, lt_of_lt_of_le hxE.2 hvb⟩ hxDA q hqA (hCQ hq)
            exact hkeys x hxE (hLS x hxE hxL) hxDA q hq
          · have haq : a < σ.time q := by omega
            have hqE : q ∈ Inside σ a v := ⟨haq, hqt.trans step.target_in_side.2⟩
            have hqL : q ∉ L := fun hl => hhigh q hqE hq (hLS q hqE hl)
            exact lex_prefix_no_exchange hn (reorders_refl σ a v)
              (fun _ _ => rfl) hxE rfl haq (by simpa [hxt] using hqt)
              (hL x hxE hxL q hqE hqL)
        obtain ⟨z, hqz, hzt⟩ :=
          successor_forced_by_no_exchange (by simpa [hxt] using hqt)
            (fun p hp => lt_of_lt_of_le (hready p hp) hsq) hno
        exact ⟨z, hCup hqz hq, hqz, by simpa [hxt] using hzt⟩
      have hut : σ.time u = s := boundary_jobs_time step.source hu
      obtain ⟨z, hzC, hzt, huz⟩ :=
        trace_strict_successors hlocalStep huC (by omega)
          (by simpa only [hut] using step.increasing.le)
      exact ⟨z, time_mem_boundary step.target_slot hzt, hzC, reach_trans hyu huz⟩

def Precedence.reverse (P : Precedence Job) : Precedence Job where
  rel x y := P.rel y x
  irrefl := P.irrefl
  trans hxy hyz := P.trans hyz hxy
  rank x := Fintype.card Job + 1 - P.rank x
  rank_injective := by
    intro x y he
    change Fintype.card Job + 1 - P.rank x = Fintype.card Job + 1 - P.rank y at he
    apply P.rank_injective
    have hx := P.rank_bound x
    have hy := P.rank_bound y
    omega
  rank_pos := by intro x; have := P.rank_bound x; omega
  rank_bound := by intro x; have := P.rank_pos x; omega
  rank_strict := by
    intro x y h
    have hlt := P.rank_strict h
    have hx := P.rank_bound x
    have hy := P.rank_bound y
    omega

theorem reverse_ranks_sum (P : Precedence Job) (x : Job) :
    P.rank x + P.reverse.rank x = Fintype.card Job + 1 := by
  have := P.rank_bound x
  dsimp [Precedence.reverse]
  omega

def reverseTime (T : ℕ) (t : ℤ) : ℤ := (T : ℤ) + 1 - t

noncomputable def Schedule.reverse {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) : Schedule P.reverse T where
  time x := reverseTime T (σ.time x)
  feasible := by
    intro x y h
    have := σ.feasible h
    dsimp [reverseTime]
    omega
  complete := by
    constructor
    · intro x
      have := σ.complete.range x
      dsimp [reverseTime]
      omega
    · intro t ht hT
      let e : {x // reverseTime T (σ.time x) = t} ≃
          {x // σ.time x = reverseTime T t} :=
        { toFun := fun x => ⟨x, by have := x.property; dsimp [reverseTime] at *; omega⟩
          invFun := fun x => ⟨x, by have := x.property; dsimp [reverseTime] at *; omega⟩
          left_inv := fun _ => rfl
          right_inv := fun _ => rfl }
      exact (Nat.card_congr e).trans
        (σ.complete.triple (reverseTime T t) (by dsimp [reverseTime]; omega)
          (by dsimp [reverseTime]; omega))

@[simp] theorem D_reverse (P : Precedence Job) (B : Boundary Job) :
    D P.reverse B.reverse = Pred P B := by cases B <;> rfl

@[simp] theorem pred_reverse (P : Precedence Job) (B : Boundary Job) :
    Pred P.reverse B.reverse = D P B := by cases B <;> rfl

@[simp] theorem boundary_reverse_jobs (B : Boundary Job) :
    B.reverse.jobs = B.jobs := by cases B <;> rfl

@[simp] theorem weakD_reverse (P : Precedence Job) (B : Boundary Job) :
    WeakD P.reverse B.reverse = WeakPred P B := by simp [WeakD, WeakPred]

@[simp] theorem weakPred_reverse (P : Precedence Job) (B : Boundary Job) :
    WeakPred P.reverse B.reverse = WeakD P B := by simp [WeakD, WeakPred]

theorem placed_reverse {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {B : Boundary Job} {a : ℤ} (hB : Placed σ B a) :
    Placed σ.reverse B.reverse (reverseTime T a) := by
  cases B with
  | left => simpa [Placed, Boundary.reverse, reverseTime] using hB
  | right =>
      dsimp [Placed] at hB
      dsimp [Placed, Boundary.reverse, reverseTime]
      omega
  | actual jobs =>
      refine ⟨hB.1, ?_⟩
      intro x
      dsimp [Schedule.reverse, reverseTime]
      rw [hB.2 x]
      omega

@[simp] theorem inside_reverse {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (a b : ℤ) :
    Inside σ.reverse (reverseTime T b) (reverseTime T a) = Inside σ a b := by
  ext x
  dsimp [Inside, Schedule.reverse, reverseTime]
  omega

theorem reorders_reverse {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a b : ℤ} (h : Reorders σ τ a b) :
    Reorders σ.reverse τ.reverse (reverseTime T b) (reverseTime T a) := by
  constructor
  · intro x
    simpa only [inside_reverse] using h.1 x
  · intro x hx
    have ht := h.2 x (by simpa only [inside_reverse] using hx)
    dsimp [Schedule.reverse]
    rw [ht]

structure Separator {P : Precedence Job} {T : ℕ} (σ : Schedule P T)
    (domain low : Set Job) (B : Boundary Job) (s : ℤ) : Prop where
  earlier_high : ∀ x ∈ domain, x ∉ low → σ.time x < s → x ∈ Pred P B
  later_low : ∀ x ∈ domain, x ∈ low → s < σ.time x → x ∈ D P B

theorem reversed_separator_low_before {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {domain low : Set Job} {B : Boundary Job} {s : ℤ}
    (hB : Placed σ B s)
    (hsep : Separator σ.reverse domain low B.reverse (reverseTime T s))
    {z : Job} (hz : z ∈ domain) (hzL : z ∈ low) (hzt : σ.time z ≤ s) :
    z ∈ WeakPred P B := by
  by_cases he : σ.time z = s
  · exact Or.inr (time_mem_boundary hB he)
  · apply Or.inl
    have ht : reverseTime T s < σ.reverse.time z := by
      dsimp [Schedule.reverse, reverseTime]
      omega
    simpa only [D_reverse] using hsep.later_low z hz hzL ht

def switchG (P : Precedence Job) (ancestorLeft A V : Boundary Job)
    (historicalExtension : Set Job) : Set Job :=
  {x | x ∈ D P ancestorLeft ∧ x ∉ WeakPred P A ∧
    x ∉ WeakPred P V ∧ x ∈ historicalExtension}

theorem switchG_up {P : Precedence Job} {ancestorLeft A V : Boundary Job}
    {Hstar : Set Job} (hHstar : IsUp P Hstar) :
    IsUp P (switchG P ancestorLeft A V Hstar) := by
  rintro x y hxy ⟨hxD, hxA, hxV, hxH⟩
  exact ⟨D_up P ancestorLeft hxy hxD,
    fun hy => hxA (weakPred_down P A hxy hy),
    fun hy => hxV (weakPred_down P V hxy hy), hHstar hxy hxH⟩

theorem switchG_from_incoming_separators {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {ancestorLeft A V : Boundary Job}
    {u v a b w : ℤ} {H centerLow Hstar : Set Job}
    (hU : Placed σ ancestorLeft u) (hA : Placed σ A a) (hV : Placed σ V v)
    (ancestry : u < v ∧ v ≤ a ∧ a < b ∧ b ≤ w)
    (oldCenter : Separator σ.reverse (Inside σ u w) centerLow
      V.reverse (reverseTime T v))
    (oldEndpoint : Separator σ.reverse (Inside σ v w) H
      A.reverse (reverseTime T a))
    (cutoffInOldCone : ∀ x ∈ Inside σ u w, x ∈ H →
      x ∈ Pred P.reverse ancestorLeft.reverse)
    (cutoffInCenter : ∀ x ∈ Inside σ u w, x ∈ H → x ∈ centerLow)
    (extensionOnAllU : ∀ x ∈ Inside σ u w, x ∈ Hstar ↔ x ∈ H)
    (extensionUpset : IsUp P Hstar) :
    IsUp P (switchG P ancestorLeft A V Hstar) ∧
    (∀ x ∈ Inside σ a b, x ∉ D P A →
      x ∈ switchG P ancestorLeft A V Hstar) ∧
    (∀ z ∈ switchG P ancestorLeft A V Hstar, ¬ σ.time z ≤ a) := by
  refine ⟨switchG_up extensionUpset, ?_, ?_⟩
  · intro x hx hxD
    have hxU : x ∈ Inside σ u w := by
      constructor <;> dsimp [Inside, Set.mem_setOf_eq] at hx ⊢ <;> omega
    have hxE : x ∈ Inside σ v w := by
      constructor <;> dsimp [Inside, Set.mem_setOf_eq] at hx ⊢ <;> omega
    have hxH : x ∈ H := by
      by_contra hn
      have ht : σ.reverse.time x < reverseTime T a := by
        dsimp [Schedule.reverse, reverseTime]
        exact sub_lt_sub_left hx.1 _
      exact hxD (by simpa only [pred_reverse] using oldEndpoint.earlier_high x hxE hn ht)
    refine ⟨?_, ?_, ?_, (extensionOnAllU x hxU).mpr hxH⟩
    · simpa only [pred_reverse] using cutoffInOldCone x hxU hxH
    · intro hm
      have := weakPred_before hA hm
      exact (not_le_of_gt hx.1) this
    · intro hm
      have := weakPred_before hV hm
      have hvx : v < σ.time x := lt_of_le_of_lt ancestry.2.1 hx.1
      exact (not_le_of_gt hvx) this
  · rintro z ⟨hzD, hzA, hzV, hzHstar⟩ hza
    have huz : u < σ.time z := D_after hU hzD
    have hzU : z ∈ Inside σ u w := ⟨huz, by omega⟩
    have hzH : z ∈ H := (extensionOnAllU z hzU).mp hzHstar
    by_cases hzv : σ.time z ≤ v
    · exact hzV (reversed_separator_low_before hV oldCenter hzU
        (cutoffInCenter z hzU hzH) hzv)
    · have hzE : z ∈ Inside σ v w := ⟨lt_of_not_ge hzv, hzU.2⟩
      exact hzA (reversed_separator_low_before hA oldEndpoint hzE hzH hza)

theorem walk_initial_placed {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a v c : ℤ}
    {S : Set Job} {A B : Boundary Job}
    (h : ExceptionWalk σ π a v S A B c) : Placed σ A a := by
  induction h with
  | start hA => exact hA
  | advance _ _ _ _ _ ih => exact ih

theorem reorders_past_time {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a b : ℤ} (h : Reorders σ τ a b)
    {z : Job} (hz : τ.time z ≤ a) : τ.time z = σ.time z := by
  apply h.2 z
  intro hm
  have ht := ((h.1 z).mp hm).1
  omega

theorem I2_reorders {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {A : Boundary Job} {a b : ℤ} {Q : Set Job}
    (h : I2 σ A a Q) (hr : Reorders σ τ a b) : I2 τ A a Q := by
  intro z hz hzt
  apply h z hz
  rwa [← reorders_past_time hr hzt]

theorem I3_reorders {P : Precedence Job} {T : ℕ}
    {Key : Type*} [LT Key] {σ τ : Schedule P T}
    {A : Boundary Job} {a b : ℤ} {Q : Set Job} {key : Job → Key}
    (h : I3 σ A a b Q key) (hr : Reorders σ τ a b) :
    I3 τ A a b Q key :=
  fun υ hυ => h υ (reorders_trans hr hυ)

theorem weakPred_boundary_witness {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {A : Boundary Job} {a v : ℤ}
    (hA : Placed σ A a) (hav : a < v) (hv : v ≤ (T : ℤ) + 1)
    {z : Job} (hz : z ∈ WeakPred P A) :
    ∃ y ∈ A.jobs, Reach P z y := by
  cases A with
  | left => simp [WeakPred, Pred, Boundary.jobs] at hz
  | right =>
      dsimp [Placed] at hA
      omega
  | actual jobs =>
      rcases hz with ⟨y, hy, hzy⟩ | hz
      · exact ⟨y, hy, Or.inr hzy⟩
      · exact ⟨z, hz, Or.inl rfl⟩

theorem reach_boundary_weakPred {P : Precedence Job} {B : Boundary Job}
    {z y : Job} (hy : y ∈ B.jobs) (hzy : Reach P z y) :
    z ∈ WeakPred P B := by
  rcases hzy with rfl | hzy
  · exact Or.inr hy
  · cases B with
    | left => simp [Boundary.jobs] at hy
    | right => exact Or.inl (Set.mem_univ _)
    | actual jobs => exact Or.inl ⟨y, hy, hzy⟩

theorem carry_past_at_walk_end {P : Precedence Job} {T : ℕ}
    {Key : Type*} [LT Key] {parent σ : Schedule P T}
    {π : Priority P} {a b v c : ℤ} {S Q C : Set Job}
    {oldKey : Job → Key} {A B : Boundary Job}
    (hwalk : ExceptionWalk σ π a v S A B c)
    (hn : Normalized σ π a v) (hav : a < v) (hv : v ≤ (T : ℤ) + 1)
    (hvb : v ≤ b) (hprep : Reorders parent σ a b)
    (hI2 : I2 parent A a Q) (hI3 : I3 parent A a b Q oldKey)
    (hCup : IsUp P C) (hCQ : C ⊆ Q)
    (hhigh : ∀ y ∈ Inside σ a v, y ∈ C → y ∉ S)
    (hkeys : ∀ x ∈ Inside σ a v, x ∈ S → x ∉ D P A →
      ∀ y ∈ C, oldKey x < oldKey y) :
    ∀ z ∈ C, σ.time z ≤ a → z ∈ WeakPred P B := by
  intro z hz hzt
  have hzold : z ∈ WeakPred P A := I2_reorders hI2 hprep z (hCQ hz) hzt
  obtain ⟨y, hyA, hzy⟩ :=
    weakPred_boundary_witness (walk_initial_placed hwalk) hav hv hzold
  have hyC : y ∈ C := by
    rcases hzy with rfl | hzy
    · exact hz
    · exact hCup hzy hz
  obtain ⟨u, huB, _, hyu⟩ :=
    walk_carry_transport hwalk hn hvb hprep hI3 hCup hCQ hhigh hkeys y hyA hyC
  exact reach_boundary_weakPred huB (reach_trans hzy hyu)

def injection (P : Precedence Job) (A outerRight : Boundary Job) : Set Job :=
  D P A \ Pred P outerRight

theorem I2_from_local_separator {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {B : Boundary Job} {a v c : ℤ}
    {S preQ childQ : Set Job} (hB : Placed σ B c) (hcv : c < v)
    (hsep : Separator σ (Inside σ a v) S B c)
    (hunion : ∀ x ∈ Inside σ a v, x ∈ preQ ↔ x ∉ S)
    (hprune : childQ ⊆ preQ)
    (hpast : ∀ z ∈ preQ, σ.time z ≤ a → z ∈ WeakPred P B) :
    I2 σ B c childQ := by
  intro z hz hzc
  have hzpre := hprune hz
  by_cases hza : σ.time z ≤ a
  · exact hpast z hzpre hza
  · have hzE : z ∈ Inside σ a v := ⟨lt_of_not_ge hza, lt_of_le_of_lt hzc hcv⟩
    by_cases hze : σ.time z = c
    · exact Or.inr (time_mem_boundary hB hze)
    · exact Or.inl (hsep.earlier_high z hzE ((hunion z hzE).mp hzpre)
        (lt_of_le_of_ne hzc hze))

theorem same_update_I2 {P : Precedence Job} {T : ℕ}
    {Key : Type*} [LT Key] {parent σ : Schedule P T}
    {π : Priority P} {a b v c : ℤ} {S Q C childQ : Set Job}
    {oldKey : Job → Key} {A B outerRight : Boundary Job}
    (hwalk : ExceptionWalk σ π a v S A B c)
    (hn : Normalized σ π a v) (hav : a < v) (hv : v ≤ (T : ℤ) + 1)
    (hvb : v ≤ b) (hprep : Reorders parent σ a b)
    (hI2 : I2 parent A a Q) (hI3 : I3 parent A a b Q oldKey)
    (hCup : IsUp P C) (hCQ : C ⊆ Q)
    (hhigh : ∀ y ∈ Inside σ a v, y ∈ C → y ∉ S)
    (hkeys : ∀ x ∈ Inside σ a v, x ∈ S → x ∉ D P A →
      ∀ y ∈ C, oldKey x < oldKey y)
    (hsep : Separator σ (Inside σ a v) S B c)
    (hunion : ∀ x ∈ Inside σ a v,
      x ∈ C ∪ injection P A outerRight ↔ x ∉ S)
    (hprune : childQ ⊆ C ∪ injection P A outerRight) :
    I2 σ B c childQ := by
  have hcv : c < v := by
    rcases walk_start_or_interior hwalk with ⟨_, rfl⟩ | h
    · exact hav
    · exact h.2
  apply I2_from_local_separator (walk_placed hwalk) hcv hsep hunion hprune
  intro z hz hza
  rcases hz with hz | hz
  · exact carry_past_at_walk_end hwalk hn hav hv hvb hprep hI2 hI3
      hCup hCQ hhigh hkeys z hz hza
  · exact False.elim (at_not_D (walk_initial_placed hwalk) hza hz.1)

structure ListOrderInterface {P : Precedence Job} {T : ℕ}
    {PreKey ChildKey : Type*} [LT PreKey] [LT ChildKey]
    (σ : Schedule P T) (π : Priority P) (a v c d : ℤ)
    (B : Boundary Job) (preQ childQ : Set Job)
    (preKey : Job → PreKey) (childKey : Job → ChildKey) : Prop where
  pruning_subset : childQ ⊆ preQ
  localI1 : ∀ x ∈ Inside σ c d, x ∉ D P B → x ∈ childQ
  pruning_comparison : ∀ x ∈ Inside σ c d, x ∈ childQ →
    ∀ y ∈ childQ, childKey x < childKey y → preKey x < preKey y
  priority_comparison : ∀ x ∈ Inside σ a v, x ∈ preQ →
    ∀ y ∈ Inside σ a v, y ∈ preQ →
      preKey x < preKey y → π.index x < π.index y

theorem advanced_child_I3 {P : Precedence Job} {T : ℕ}
    {PreKey ChildKey : Type*} [LT PreKey] [LT ChildKey]
    {σ : Schedule P T} {π : Priority P} {a v c d : ℤ}
    {B : Boundary Job} {preQ childQ : Set Job}
    {preKey : Job → PreKey} {childKey : Job → ChildKey}
    (hn : Normalized σ π a v) (hB : Placed σ B c)
    (hac : a < c) (hdv : d ≤ v)
    (hlist : ListOrderInterface σ π a v c d B preQ childQ preKey childKey) :
    I3 σ B c d childQ childKey := by
  intro τ hτ x hx hxD y hy hyQ hkey
  have hxσ : x ∈ Inside σ c d := (hτ.1 x).mpr hx
  have hxQ := hlist.localI1 x hxσ hxD
  have hytime : σ.time y = c := boundary_jobs_time hB hy
  have hyτ : τ.time y = c := by
    rw [hτ.2 y (by simp [Inside, hytime])]
    exact hytime
  have hxE : x ∈ Inside σ a v := ⟨hac.trans hxσ.1, lt_of_lt_of_le hxσ.2 hdv⟩
  have hyE : y ∈ Inside σ a v := by
    have hcd : c < d := hxσ.1.trans hxσ.2
    exact ⟨by simpa [hytime] using hac, by simpa [hytime] using lt_of_lt_of_le hcd hdv⟩
  have hπ := hlist.priority_comparison x hxE (hlist.pruning_subset hxQ)
    y hyE (hlist.pruning_subset hyQ)
    (hlist.pruning_comparison x hxσ hxQ y hyQ hkey)
  exact normalized_child_future_no_exchange hn hτ hac hdv hx hyτ hπ

theorem same_update_I3 {P : Precedence Job} {T : ℕ}
    {OldKey PreKey ChildKey : Type*} [LT OldKey] [LT PreKey] [LT ChildKey]
    {parent σ : Schedule P T} {π : Priority P} {a b v c d : ℤ}
    {S Q C childQ : Set Job} {A B outerRight : Boundary Job}
    {oldKey : Job → OldKey} {preKey : Job → PreKey} {childKey : Job → ChildKey}
    (hwalk : ExceptionWalk σ π a v S A B c)
    (hn : Normalized σ π a v) (hdv : d ≤ v) (hvb : v ≤ b)
    (hprep : Reorders parent σ a b) (hI3 : I3 parent A a b Q oldKey)
    (hCQ : C ⊆ Q)
    (hlist : ListOrderInterface σ π a v c d B
      (C ∪ injection P A outerRight) childQ preKey childKey)
    (carry_comparison : ∀ x ∈ C, ∀ y ∈ C,
      preKey x < preKey y → oldKey x < oldKey y) :
    I3 σ B c d childQ childKey := by
  rcases walk_start_or_interior hwalk with ⟨rfl, rfl⟩ | hinside
  · intro τ hτ x hx hxD y hy hyQ hkey
    have hxσ := (hτ.1 x).mpr hx
    have hxQ := hlist.localI1 x hxσ hxD
    have hxpre := hlist.pruning_subset hxQ
    have hypre := hlist.pruning_subset hyQ
    have hxC : x ∈ C := by
      rcases hxpre with h | h
      · exact h
      · exact False.elim (hxD h.1)
    have hyC : y ∈ C := by
      rcases hypre with h | h
      · exact h
      · exact False.elim (at_not_D (walk_initial_placed hwalk)
          (boundary_jobs_time (walk_initial_placed hwalk) hy).le h.1)
    apply hI3 τ (reorders_trans hprep (reorders_enlarge hτ le_rfl (hdv.trans hvb)))
      x ⟨hx.1, lt_of_lt_of_le hx.2 (hdv.trans hvb)⟩ hxD y hy (hCQ hyC)
    exact carry_comparison x hxC y hyC
      (hlist.pruning_comparison x hxσ hxQ y hyQ hkey)
  · exact advanced_child_I3 hn (walk_placed hwalk) hinside.1 hdv hlist

theorem reorders_before_threshold {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a b r : ℤ} (h : Reorders σ τ a b) (hra : r ≤ a)
    (x : Job) :
    (σ.time x < r ↔ τ.time x < r) ∧
    (σ.time x = r ↔ τ.time x = r) ∧
    (r < σ.time x ↔ r < τ.time x) := by
  by_cases hx : x ∈ Inside σ a b
  · have hx' := (h.1 x).mp hx
    have hσ := hx.1
    have hτ := hx'.1
    constructor <;> try constructor <;> omega
  · rw [h.2 x hx]
    exact ⟨Iff.rfl, Iff.rfl, Iff.rfl⟩

theorem placed_before_reorders {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a b r : ℤ} {B : Boundary Job}
    (h : Reorders σ τ a b) (hra : r ≤ a) (hB : Placed σ B r) :
    Placed τ B r := by
  cases B with
  | left => exact hB
  | right => exact hB
  | actual jobs =>
      exact ⟨hB.1, fun x => (hB.2 x).trans (reorders_before_threshold h hra x).2.1⟩

theorem reversed_separator_before_reorders {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {a b r : ℤ} {B : Boundary Job} {domain low : Set Job}
    (h : Reorders σ τ a b) (hra : r ≤ a)
    (hs : Separator σ.reverse domain low B.reverse (reverseTime T r)) :
    Separator τ.reverse domain low B.reverse (reverseTime T r) := by
  constructor
  · intro x hx hxl hxt
    have he := (reorders_before_threshold h hra x).2.2
    apply hs.earlier_high x hx hxl
    have hrt : r < τ.time x := by
      dsimp [Schedule.reverse, reverseTime] at hxt
      omega
    have hσ := he.mpr hrt
    dsimp [Schedule.reverse, reverseTime]
    omega
  · intro x hx hxl hxt
    have he := (reorders_before_threshold h hra x).1
    apply hs.later_low x hx hxl
    have htr : τ.time x < r := by
      dsimp [Schedule.reverse, reverseTime] at hxt
      omega
    have hσ := he.mpr htr
    dsimp [Schedule.reverse, reverseTime]
    omega

structure IncomingAncestor {P : Precedence Job} {T : ℕ}
    (σ : Schedule P T) (A : Boundary Job) (a b : ℤ) where
  oldWitness : Schedule P T
  ancestorLeft : Boundary Job
  ancestorRight : Boundary Job
  oldCenter : Boundary Job
  u : ℤ
  v : ℤ
  w : ℤ
  historicalLow : Set Job
  centerLow : Set Job
  extension : Set Job
  ancestorLeft_placed : Placed oldWitness ancestorLeft u
  ancestorRight_placed : Placed oldWitness ancestorRight w
  endpoint_placed : Placed oldWitness A a
  center_placed : Placed oldWitness oldCenter v
  endpoint_actual : ∃ jobs, A = .actual jobs
  center_actual : ∃ jobs, oldCenter = .actual jobs
  ancestry : u < v ∧ v ≤ a ∧ a < b ∧ b ≤ w
  confined_changes : Reorders oldWitness σ a b
  center_separator : Separator oldWitness.reverse (Inside oldWitness u w) centerLow
    oldCenter.reverse (reverseTime T v)
  endpoint_separator : Separator oldWitness.reverse (Inside oldWitness v w) historicalLow
    A.reverse (reverseTime T a)
  cutoff_old_cone : ∀ x ∈ Inside oldWitness u w, x ∈ historicalLow →
    x ∈ Pred P.reverse ancestorLeft.reverse
  cutoff_center : ∀ x ∈ Inside oldWitness u w, x ∈ historicalLow → x ∈ centerLow
  extension_agreement : ∀ x ∈ Inside oldWitness u w,
    x ∈ extension ↔ x ∈ historicalLow
  extension_up : IsUp P extension

def IncomingAncestor.G {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {A : Boundary Job} {a b : ℤ}
    (h : IncomingAncestor σ A a b) : Set Job :=
  switchG P h.ancestorLeft A h.oldCenter h.extension

theorem IncomingAncestor.current_left_placed {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {A : Boundary Job} {a b : ℤ}
    (h : IncomingAncestor σ A a b) : Placed σ A a :=
  placed_before_reorders h.confined_changes le_rfl h.endpoint_placed

theorem IncomingAncestor.G_properties {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {A : Boundary Job} {a b : ℤ}
    (h : IncomingAncestor σ A a b) :
    IsUp P h.G ∧
    (∀ x ∈ Inside σ a b, x ∉ D P A → x ∈ h.G) ∧
    (∀ z ∈ h.G, ¬ σ.time z ≤ a) := by
  have hua : h.u ≤ a := (h.ancestry.1.trans_le h.ancestry.2.1).le
  have hUchange := reorders_enlarge h.confined_changes hua h.ancestry.2.2.2
  have hEchange := reorders_enlarge h.confined_changes h.ancestry.2.1 h.ancestry.2.2.2
  have hUeq : Inside h.oldWitness h.u h.w = Inside σ h.u h.w :=
    Set.ext hUchange.1
  have hEeq : Inside h.oldWitness h.v h.w = Inside σ h.v h.w :=
    Set.ext hEchange.1
  apply switchG_from_incoming_separators
    (placed_before_reorders h.confined_changes hua h.ancestorLeft_placed)
    h.current_left_placed
    (placed_before_reorders h.confined_changes h.ancestry.2.1 h.center_placed)
    h.ancestry
  · rw [← hUeq]
    exact reversed_separator_before_reorders h.confined_changes h.ancestry.2.1 h.center_separator
  · rw [← hEeq]
    exact reversed_separator_before_reorders h.confined_changes le_rfl h.endpoint_separator
  · rw [← hUeq]
    exact h.cutoff_old_cone
  · rw [← hUeq]
    exact h.cutoff_center
  · rw [← hUeq]
    exact h.extension_agreement
  · exact h.extension_up

def IncomingAncestor.after_reordering {P : Precedence Job} {T : ℕ}
    {σ τ : Schedule P T} {A : Boundary Job} {a b : ℤ}
    (h : IncomingAncestor σ A a b) (hr : Reorders σ τ a b) :
    IncomingAncestor τ A a b :=
  { h with confined_changes := reorders_trans h.confined_changes hr }

theorem IncomingAncestor.frozen_G_after_every_reordering
    {P : Precedence Job} {T : ℕ} {σ : Schedule P T}
    {A : Boundary Job} {a b : ℤ} (h : IncomingAncestor σ A a b)
    (τ : Schedule P T) (hr : Reorders σ τ a b) :
    IsUp P h.G ∧
    (∀ x ∈ Inside τ a b, x ∉ D P A → x ∈ h.G) ∧
    (∀ z ∈ h.G, ¬ τ.time z ≤ a) :=
  (h.after_reordering hr).G_properties

def switchQualifiers {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {A : Boundary Job} {a b : ℤ}
    (incoming : IncomingAncestor σ A a b) (h : ℕ) : Set Job :=
  (incoming.G ∩ {x | h ≤ P.rank x}) ∪ D P A

theorem switchQualifiers_no_early {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {A : Boundary Job} {a b : ℤ}
    (incoming : IncomingAncestor σ A a b) (h : ℕ) :
    ∀ z ∈ switchQualifiers incoming h, ¬ σ.time z ≤ a := by
  intro z hz hzt
  rcases hz with hz | hz
  · exact incoming.G_properties.2.2 z hz.1 hzt
  · exact at_not_D incoming.current_left_placed hzt hz

theorem switch_update_I2 {P : Precedence Job} {T : ℕ}
    {σ : Schedule P T} {π : Priority P} {a b v c : ℤ}
    {A B : Boundary Job} {S childQ : Set Job}
    (incoming : IncomingAncestor σ A a b) (h : ℕ)
    (hwalk : ExceptionWalk σ π a v S A B c)
    (hav : a < v) (hsep : Separator σ (Inside σ a v) S B c)
    (hunion : ∀ x ∈ Inside σ a v,
      x ∈ switchQualifiers incoming h ↔ x ∉ S)
    (hprune : childQ ⊆ switchQualifiers incoming h) :
    I2 σ B c childQ := by
  have hcv : c < v := by
    rcases walk_start_or_interior hwalk with ⟨_, rfl⟩ | h
    · exact hav
    · exact h.2
  apply I2_from_local_separator (walk_placed hwalk) hcv hsep hunion hprune
  intro z hz hzt
  exact False.elim (switchQualifiers_no_early incoming h z hz hzt)

theorem switch_update_I3 {P : Precedence Job} {T : ℕ}
    {PreKey ChildKey : Type*} [LT PreKey] [LT ChildKey]
    {σ : Schedule P T} {π : Priority P} {a b v c d : ℤ}
    {A B : Boundary Job} {S childQ : Set Job}
    {preKey : Job → PreKey} {childKey : Job → ChildKey}
    (incoming : IncomingAncestor σ A a b) (h : ℕ)
    (hwalk : ExceptionWalk σ π a v S A B c)
    (hn : Normalized σ π a v) (hdv : d ≤ v)
    (hlist : ListOrderInterface σ π a v c d B
      (switchQualifiers incoming h) childQ preKey childKey) :
    I3 σ B c d childQ childKey := by
  rcases walk_start_or_interior hwalk with ⟨rfl, rfl⟩ | hinside
  · intro τ hτ x hx hxD y hy hyQ hkey
    have hytime := boundary_jobs_time (walk_initial_placed hwalk) hy
    exact False.elim (switchQualifiers_no_early incoming h y
      (hlist.pruning_subset hyQ) hytime.le)
  · exact advanced_child_I3 hn (walk_placed hwalk) hinside.1 hdv hlist

abbrev ListKey := ℕ ×ₗ ℕ

structure TemporalState (Job : Type*) [Fintype Job] [DecidableEq Job] (T : ℕ) where
  frame : Precedence Job
  schedule : Schedule frame T
  left : Boundary Job
  right : Boundary Job
  a : ℤ
  b : ℤ
  left_placed : Placed schedule left a
  right_placed : Placed schedule right b
  ordered : a < b
  qualifiers : Set Job
  key : Job → ListKey

def TemporalState.Valid {T : ℕ} (N : TemporalState Job T) : Prop :=
  I2 N.schedule N.left N.a N.qualifiers ∧
    I3 N.schedule N.left N.a N.b N.qualifiers N.key

def rootState {T : ℕ} (P : Precedence Job) (σ : Schedule P T) :
    TemporalState Job T where
  frame := P
  schedule := σ
  left := .left
  right := .right
  a := 0
  b := (T : ℤ) + 1
  left_placed := rfl
  right_placed := rfl
  ordered := by omega
  qualifiers := Set.univ
  key x := toLex (1, P.rank x)

theorem root_valid {T : ℕ} (P : Precedence Job) (σ : Schedule P T) :
    (rootState P σ).Valid := by
  constructor
  · intro z _ hzt
    have hr := (σ.complete.range z).1
    change σ.time z ≤ 0 at hzt
    omega
  · intro τ hτ x hx hxD y hy
    simp [rootState, Boundary.jobs] at hy

structure SameTemporalData {T : ℕ} (N : TemporalState Job T) where
  prepared : Schedule N.frame T
  preparation : Reorders N.schedule prepared N.a N.b
  priority : Priority N.frame
  center : Finset Job
  v : ℤ
  center_placed : Placed prepared (.actual center) v
  center_interior : N.a < v ∧ v < N.b
  center_range : v ≤ (T : ℤ) + 1
  childLeft : Boundary Job
  childRight : Finset Job
  c : ℤ
  d : ℤ
  cutoff : Set Job
  carry : Set Job
  childQ : Set Job
  preKey : Job → ListKey
  childKey : Job → ListKey
  walk : ExceptionWalk prepared priority N.a v cutoff N.left childLeft c
  right_placed : Placed prepared (.actual childRight) d
  nonempty_child : (Inside prepared c d).Nonempty
  right_before_center : d ≤ v
  left_separator : Separator prepared (Inside prepared N.a v) cutoff childLeft c
  right_separator : Separator prepared (Inside prepared N.a v) cutoff (.actual childRight) d
  normalized : Normalized prepared priority N.a v
  carry_up : IsUp N.frame carry
  carry_old : carry ⊆ N.qualifiers
  local_union : ∀ x ∈ Inside prepared N.a v,
    x ∈ carry ∪ injection N.frame N.left N.right ↔ x ∉ cutoff
  promoted_old_key : ∀ x ∈ Inside prepared N.a v,
    x ∈ cutoff → x ∉ D N.frame N.left →
      ∀ y ∈ carry, N.key x < N.key y
  list_order : ListOrderInterface prepared priority N.a v c d childLeft
    (carry ∪ injection N.frame N.left N.right) childQ preKey childKey
  carry_comparison : ∀ x ∈ carry, ∀ y ∈ carry,
    preKey x < preKey y → N.key x < N.key y

def SameTemporalData.child {T : ℕ} {N : TemporalState Job T}
    (e : SameTemporalData N) : TemporalState Job T where
  frame := N.frame
  schedule := e.prepared
  left := e.childLeft
  right := .actual e.childRight
  a := e.c
  b := e.d
  left_placed := walk_placed e.walk
  right_placed := e.right_placed
  ordered := by obtain ⟨x, hx⟩ := e.nonempty_child; exact hx.1.trans hx.2
  qualifiers := e.childQ
  key := e.childKey

theorem SameTemporalData.preserves {T : ℕ} {N : TemporalState Job T}
    (e : SameTemporalData N) (hN : N.Valid) : e.child.Valid := by
  constructor
  · exact same_update_I2 e.walk e.normalized e.center_interior.1 e.center_range
      e.center_interior.2.le e.preparation hN.1 hN.2 e.carry_up e.carry_old
      (fun y hy hyC => (e.local_union y hy).mp (Or.inl hyC))
      e.promoted_old_key e.left_separator e.local_union e.list_order.pruning_subset
  · exact same_update_I3 e.walk e.normalized e.right_before_center
      e.center_interior.2.le e.preparation hN.2 e.carry_old e.list_order e.carry_comparison

structure SwitchTemporalData {T : ℕ} (N : TemporalState Job T) where
  prepared : Schedule N.frame.reverse T
  preparation : Reorders N.schedule.reverse prepared (reverseTime T N.b) (reverseTime T N.a)
  priority : Priority N.frame.reverse
  center : Finset Job
  v : ℤ
  center_placed : Placed prepared (.actual center) v
  center_interior : reverseTime T N.b < v ∧ v < reverseTime T N.a
  incoming : IncomingAncestor prepared N.right.reverse
    (reverseTime T N.b) (reverseTime T N.a)
  childLeft : Boundary Job
  childRight : Finset Job
  c : ℤ
  d : ℤ
  cutoff : Set Job
  rankCut : ℕ
  childQ : Set Job
  preKey : Job → ListKey
  childKey : Job → ListKey
  walk : ExceptionWalk prepared priority (reverseTime T N.b) v cutoff N.right.reverse childLeft c
  right_placed : Placed prepared (.actual childRight) d
  nonempty_child : (Inside prepared c d).Nonempty
  right_before_center : d ≤ v
  left_separator : Separator prepared (Inside prepared (reverseTime T N.b) v) cutoff childLeft c
  right_separator : Separator prepared (Inside prepared (reverseTime T N.b) v)
    cutoff (.actual childRight) d
  normalized : Normalized prepared priority (reverseTime T N.b) v
  local_union : ∀ x ∈ Inside prepared (reverseTime T N.b) v,
    x ∈ switchQualifiers incoming rankCut ↔ x ∉ cutoff
  list_order : ListOrderInterface prepared priority (reverseTime T N.b) v c d childLeft
    (switchQualifiers incoming rankCut) childQ preKey childKey

def SwitchTemporalData.child {T : ℕ} {N : TemporalState Job T}
    (e : SwitchTemporalData N) : TemporalState Job T where
  frame := N.frame.reverse
  schedule := e.prepared
  left := e.childLeft
  right := .actual e.childRight
  a := e.c
  b := e.d
  left_placed := walk_placed e.walk
  right_placed := e.right_placed
  ordered := by obtain ⟨x, hx⟩ := e.nonempty_child; exact hx.1.trans hx.2
  qualifiers := e.childQ
  key := e.childKey

theorem SwitchTemporalData.preserves {T : ℕ} {N : TemporalState Job T}
    (e : SwitchTemporalData N) : e.child.Valid := by
  constructor
  · exact switch_update_I2 e.incoming e.rankCut e.walk e.center_interior.1
      e.left_separator e.local_union e.list_order.pruning_subset
  · exact switch_update_I3 e.incoming e.rankCut e.walk e.normalized
      e.right_before_center e.list_order

-- Constructors carry local construction data, never a temporal invariant.
inductive TemporalHistory {T : ℕ} : TemporalState Job T → Prop
  | root (P : Precedence Job) (σ : Schedule P T) : TemporalHistory (rootState P σ)
  | same {N : TemporalState Job T} (past : TemporalHistory N)
      (e : SameTemporalData N) : TemporalHistory e.child
  | switched {N : TemporalState Job T} (past : TemporalHistory N)
      (e : SwitchTemporalData N) : TemporalHistory e.child

theorem TemporalHistory.boundary_invariants {T : ℕ} {N : TemporalState Job T}
    (h : TemporalHistory N) : N.Valid := by
  induction h with
  | root P σ => exact root_valid P σ
  | same _ e ih => exact e.preserves ih
  | switched _ e _ => exact e.preserves

theorem TemporalHistory.future_boundary_invariants {T : ℕ}
    {N : TemporalState Job T} (h : TemporalHistory N)
    (τ : Schedule N.frame T) (hr : Reorders N.schedule τ N.a N.b) :
    I2 τ N.left N.a N.qualifiers ∧
    I3 τ N.left N.a N.b N.qualifiers N.key :=
  ⟨I2_reorders h.boundary_invariants.1 hr,
    I3_reorders h.boundary_invariants.2 hr⟩

end TemporalBoundary
