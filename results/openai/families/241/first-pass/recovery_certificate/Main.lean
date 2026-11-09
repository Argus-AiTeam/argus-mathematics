import Mathlib

set_option autoImplicit false
set_option maxHeartbeats 1600000

namespace FourValueRecovery

open Encodable

abbrev Stream := ℕ → ℕ

def oracle (T : Stream) : ℕ →. ℕ := fun n => Part.some (T n)

abbrev Relative (T : Stream) (f : ℕ →. ℕ) :=
  Nat.RecursiveIn {oracle T} f

theorem relative_ordinary {T : Stream} {f : ℕ → ℕ} (hf : Computable f) :
    Relative T (fun n => Part.some (f n)) :=
  RecursiveIn.iff_nat.mp hf.computableIn

theorem relative_comp {T : Stream} {f g : ℕ → ℕ}
    (hf : Relative T (fun n => Part.some (f n)))
    (hg : Relative T (fun n => Part.some (g n))) :
    Relative T (fun n => Part.some (f (g n))) := by
  simpa using Nat.RecursiveIn.comp hf hg

theorem relative_pair {T : Stream} {f g : ℕ → ℕ}
    (hf : Relative T (fun n => Part.some (f n)))
    (hg : Relative T (fun n => Part.some (g n))) :
    Relative T (fun n => Part.some (Nat.pair (f n) (g n))) := by
  simpa [Seq.seq] using Nat.RecursiveIn.pair hf hg

def oraclePrefix (T : Stream) : ℕ → ℕ
  | 0 => 0
  | n + 1 => Nat.pair (oraclePrefix T n) (T n)

theorem relative_prefix (T : Stream) :
    Relative T (fun n => Part.some (oraclePrefix T n)) := by
  have hleft : Computable (fun z : ℕ => z.unpair.2.unpair.1) :=
    ((Primrec.fst.comp Primrec.unpair).comp
      (Primrec.snd.comp Primrec.unpair)).to_comp
  have hright : Computable (fun z : ℕ => z.unpair.2.unpair.2) :=
    ((Primrec.snd.comp Primrec.unpair).comp
      (Primrec.snd.comp Primrec.unpair)).to_comp
  have horacle : Relative T (oracle T) := .oracle _ (by simp)
  have hstep : Relative T (fun z => Part.some
      (Nat.pair z.unpair.2.unpair.2 (T z.unpair.2.unpair.1))) :=
    relative_pair (relative_ordinary hright)
      (relative_comp horacle (relative_ordinary hleft))
  have hp : Relative T (fun z =>
      z.unpair.2.rec (Part.some 0) fun n ih =>
        ih.bind fun c => Part.some (Nat.pair c (T n))) := by
    simpa using Nat.RecursiveIn.prec
      (relative_ordinary (Computable.const 0)) hstep
  have harg : Computable (fun n : ℕ => Nat.pair 0 n) :=
    (Primrec₂.pair.comp (Primrec.const 0) Primrec.id).to_comp
  have hp' : Relative T (fun z => Part.some (oraclePrefix T z.unpair.2)) := by
    apply Nat.RecursiveIn.of_eq_tot hp
    intro z
    induction z.unpair.2 with
    | zero => simp [oraclePrefix]
    | succ n ih =>
        exact Part.mem_bind_iff.mpr
          ⟨oraclePrefix T n, ih, by simp [oraclePrefix]⟩
  simpa only [Nat.unpair_pair] using relative_comp hp' (relative_ordinary harg)

def prefixAt (k c i : ℕ) : Option ℕ :=
  if i < k then
    some (((fun x : ℕ => x.unpair.1)^[k - 1 - i] c).unpair.2)
  else none

theorem prefixAt_correct (T : Stream) {k i : ℕ} (hi : i < k) :
    prefixAt k (oraclePrefix T k) i = some (T i) := by
  induction k with
  | zero => omega
  | succ k ih =>
      by_cases h : i = k
      · subst i
        simp [prefixAt, oraclePrefix]
      · have hik : i < k := by omega
        have he : k - i = (k - 1 - i) + 1 := by omega
        simpa only [prefixAt, if_pos hi, oraclePrefix, Nat.add_sub_cancel,
          he, Function.iterate_succ_apply, Nat.unpair_pair, if_pos hik] using ih hik

theorem primrec_prefixAt :
    Primrec (fun x : ℕ × ℕ × ℕ => prefixAt x.1 x.2.1 x.2.2) := by
  have hi : Primrec (fun x : ℕ × ℕ × ℕ =>
      (fun z : ℕ => z.unpair.1)^[x.1 - 1 - x.2.2] x.2.1) :=
    Primrec.nat_iterate
      (Primrec.nat_sub.comp
        (Primrec.nat_sub.comp Primrec.fst (Primrec.const 1))
        (Primrec.snd.comp Primrec.snd))
      (Primrec.fst.comp Primrec.snd)
      (((Primrec.fst.comp Primrec.unpair).comp Primrec.snd).to₂)
  exact Primrec.ite
    (Primrec.nat_lt.comp (Primrec.snd.comp Primrec.snd) Primrec.fst)
    (Primrec.option_some.comp ((Primrec.snd.comp Primrec.unpair).comp hi))
    (Primrec.const none)

def allB {α : Type} (p : α → Bool) (xs : List α) : Bool :=
  xs.foldr (fun x b => p x && b) true

theorem allB_iff {α : Type} (p : α → Bool) (xs : List α) :
    allB p xs = true ↔ ∀ x ∈ xs, p x = true := by
  induction xs with
  | nil => simp [allB]
  | cons x xs ih => simp [allB, ← ih]

theorem primrec_allB {α β : Type} [Primcodable α] [Primcodable β]
    {f : α → List β} {p : α → β → Bool}
    (hf : Primrec f) (hp : Primrec₂ p) :
    Primrec (fun a => allB (p a) (f a)) := by
  exact Primrec.list_foldr hf (Primrec.const true)
    ((Primrec.and.comp (hp.comp Primrec.fst (Primrec.fst.comp Primrec.snd))
      (Primrec.snd.comp Primrec.snd)).to₂)

abbrev Fact := ℕ × ℕ × ℕ
abbrev Query := ℕ × ℕ
abbrev Step := Fact × ℕ × ℕ × List Query

def conclusion (s : Step) : Fact := s.1
def branchValue (s : Step) : ℕ := s.2.1
def fuel (s : Step) : ℕ := s.2.2.1
def table (s : Step) : List Query := s.2.2.2
def level (s : Step) : ℕ := s.1.1
def input (s : Step) : ℕ := s.1.2.1
def output (s : Step) : ℕ := s.1.2.2

def branch (h b : ℕ) : ℕ := if b = h then 1 else 0

def join (A B : Stream) : Stream :=
  fun i => if i % 2 = 0 then A (i / 2) else B (i / 2)

def component (T : Stream) (c : ℕ) : Stream := fun i => T (Nat.pair c i)

abbrev Accepts (p : Nat.Partrec.Code) (j b k : ℕ) (qs : List Query) : Prop :=
  Nat.Partrec.Code.evaln k p (encode (j, b, qs)) = some 0

def tableMatches (qs : List Query) (A : Stream) : Prop :=
  ∀ x ∈ qs, A x.1 = x.2

def Runs (p : Nat.Partrec.Code) (A B C : Stream) : Prop :=
  ∀ j b, (∃ k qs, Accepts p j b k qs ∧ tableMatches qs (join A B)) ↔ C j = b

def premises (j _h : ℕ) (s : Step) : List Fact :=
  if level s = 0 then [] else
    (table s).flatMap (fun x =>
      if x.1 % 2 = 0 then [(level s - 1, x.1 / 2, x.2)] else []) ++
    (if level s % 2 = 1 then [(level s - 1, j, branchValue s)] else [])

def leaves (h : ℕ) (s : Step) : List Query :=
  if level s = 0 then [(Nat.pair 0 (input s), output s)] else
    (table s).flatMap (fun x =>
      if x.1 % 2 = 0 then [] else
        [(Nat.pair (if level s % 2 = 1 then 2 + branch h (branchValue s) else 1)
          (x.1 / 2), x.2)])

def localGood (p q : Nat.Partrec.Code) (s : Step) : Bool :=
  if level s = 0 then true else
    decide (Accepts (if level s % 2 = 1 then p else q)
      (input s) (output s) (fuel s) (table s))

def Valid (T : Stream) (p q : Nat.Partrec.Code) (j h : ℕ) : List Step → Prop
  | [] => True
  | s :: ss =>
      Valid T p q j h ss ∧ localGood p q s = true ∧
      (∀ a ∈ premises j h s, a ∈ ss.map conclusion) ∧
      tableMatches (leaves h s) T

theorem valid_append {T : Stream} {p q : Nat.Partrec.Code} {j h : ℕ}
    {ss tt : List Step} (hs : Valid T p q j h ss) (ht : Valid T p q j h tt) :
    Valid T p q j h (ss ++ tt) := by
  induction ss with
  | nil => exact ht
  | cons s ss ih =>
      refine ⟨ih hs.1, hs.2.1, ?_, hs.2.2.2⟩
      intro a ha
      simpa using List.mem_append_left (tt.map conclusion) (hs.2.2.1 a ha)

def HasProof (T : Stream) (p q : Nat.Partrec.Code) (j h : ℕ) (a : Fact) : Prop :=
  ∃ ss, Valid T p q j h ss ∧ a ∈ ss.map conclusion

theorem gather_proofs {T : Stream} {p q : Nat.Partrec.Code} {j h : ℕ}
    (as : List Fact)
    (hp : ∀ a ∈ as, HasProof T p q j h a) :
    ∃ ss, Valid T p q j h ss ∧ ∀ a ∈ as, a ∈ ss.map conclusion := by
  induction as with
  | nil => exact ⟨[], trivial, by simp⟩
  | cons a as ih =>
      obtain ⟨ss, hs, ha⟩ := hp a (by simp)
      obtain ⟨tt, ht, htail⟩ := ih (fun b hb => hp b (by simp [hb]))
      refine ⟨ss ++ tt, valid_append hs ht, ?_⟩
      intro b hb
      rcases List.mem_cons.mp hb with rfl | hb
      · simpa using List.mem_append_left (tt.map conclusion) ha
      · simpa using List.mem_append_right (ss.map conclusion) (htail b hb)

theorem proof_of_step {T : Stream} {p q : Nat.Partrec.Code} {j h : ℕ}
    (s : Step) (hg : localGood p q s = true) (hl : tableMatches (leaves h s) T)
    (hp : ∀ a ∈ premises j h s, HasProof T p q j h a) :
    HasProof T p q j h (conclusion s) := by
  obtain ⟨ss, hs, hm⟩ := gather_proofs (premises j h s) hp
  exact ⟨s :: ss, ⟨hs, hg, hm, hl⟩, by simp [conclusion]⟩

def semantic (X Y : ℕ → Stream) (a : Fact) : Prop :=
  (if a.1 % 2 = 0 then X (a.1 / 2) else Y (a.1 / 2)) a.2.1 = a.2.2

theorem left_premise (j h : ℕ) (s : Step) (hz : level s ≠ 0)
    {x : Query} (hx : x ∈ table s) (he : x.1 % 2 = 0) :
    (level s - 1, x.1 / 2, x.2) ∈ premises j h s := by
  simp only [premises, hz, ↓reduceIte, List.mem_append]
  exact Or.inl (List.mem_flatMap.mpr ⟨x, hx, by simp [he]⟩)

theorem branch_premise (j h : ℕ) (s : Step) (hz : level s ≠ 0)
    (ho : level s % 2 = 1) :
    (level s - 1, j, branchValue s) ∈ premises j h s := by
  simp [premises, hz, ho]

theorem right_leaf (h : ℕ) (s : Step) (hz : level s ≠ 0)
    {x : Query} (hx : x ∈ table s) (he : x.1 % 2 ≠ 0) :
    (Nat.pair (if level s % 2 = 1 then 2 + branch h (branchValue s) else 1)
      (x.1 / 2), x.2) ∈ leaves h s := by
  simp only [leaves, hz, ↓reduceIte]
  exact List.mem_flatMap.mpr ⟨x, hx, by simp [he]⟩

theorem step_sound {T : Stream} {p q : Nat.Partrec.Code} {j h : ℕ}
    {X Y : ℕ → Stream}
    (hzero : X 0 = component T 0)
    (hp : ∀ n, Runs p (X n) (component T (2 + branch h (X n j))) (Y n))
    (hq : ∀ n, Runs q (Y n) (component T 1) (X (n + 1)))
    (s : Step) (hg : localGood p q s = true)
    (hm : ∀ a ∈ premises j h s, semantic X Y a)
    (hl : tableMatches (leaves h s) T) :
    semantic X Y (conclusion s) := by
  change (if level s % 2 = 0 then X (level s / 2) else Y (level s / 2))
    (input s) = output s
  by_cases hz : level s = 0
  · have hh := hl (Nat.pair 0 (input s), output s) (by simp [leaves, hz])
    simpa [hz, hzero, component] using hh
  by_cases ho : level s % 2 = 1
  · have he : (level s - 1) % 2 = 0 := by omega
    have hd : (level s - 1) / 2 = level s / 2 := by omega
    have hb := hm _ (branch_premise j h s hz ho)
    have hb' : X (level s / 2) j = branchValue s := by
      simpa [semantic, he, hd] using hb
    have hrun : tableMatches (table s)
        (join (X (level s / 2))
          (component T (2 + branch h (X (level s / 2) j)))) := by
      intro x hx
      by_cases heven : x.1 % 2 = 0
      · have hh := hm _ (left_premise j h s hz hx heven)
        simpa [semantic, he, hd, join, heven] using hh
      · have hh := hl _ (right_leaf h s hz hx heven)
        simpa [join, heven, ho, component, hb'] using hh
    have ha : Accepts p (input s) (output s) (fuel s) (table s) := by
      simpa [localGood, hz, ho] using hg
    have hh := (hp (level s / 2) (input s) (output s)).mp
      ⟨fuel s, table s, ha, hrun⟩
    simpa [show level s % 2 ≠ 0 by omega] using hh
  · have he : level s % 2 = 0 := by omega
    have he' : (level s - 1) % 2 ≠ 0 := by omega
    have hd : level s / 2 = (level s - 1) / 2 + 1 := by omega
    have hrun : tableMatches (table s)
        (join (Y ((level s - 1) / 2)) (component T 1)) := by
      intro x hx
      by_cases heven : x.1 % 2 = 0
      · have hh := hm _ (left_premise j h s hz hx heven)
        simpa [semantic, he', join, heven] using hh
      · have hh := hl _ (right_leaf h s hz hx heven)
        simpa [join, heven, ho, component] using hh
    have ha : Accepts q (input s) (output s) (fuel s) (table s) := by
      simpa [localGood, hz, ho] using hg
    have hh := (hq ((level s - 1) / 2) (input s) (output s)).mp
      ⟨fuel s, table s, ha, hrun⟩
    simpa [he, hd] using hh

theorem valid_sound {T : Stream} {p q : Nat.Partrec.Code} {j h : ℕ}
    {X Y : ℕ → Stream}
    (hzero : X 0 = component T 0)
    (hp : ∀ n, Runs p (X n) (component T (2 + branch h (X n j))) (Y n))
    (hq : ∀ n, Runs q (Y n) (component T 1) (X (n + 1)))
    {ss : List Step} (hv : Valid T p q j h ss) :
    ∀ a ∈ ss.map conclusion, semantic X Y a := by
  induction ss with
  | nil => simp
  | cons s ss ih =>
      intro a ha
      rcases List.mem_cons.mp ha with rfl | ha
      · exact step_sound hzero hp hq s hv.2.1
          (fun b hb => ih hv.1 b (hv.2.2.1 b hb)) hv.2.2.2
      · exact ih hv.1 a ha

theorem next_half_proofs {T : Stream} {p q : Nat.Partrec.Code} {j h n : ℕ}
    {X Y : ℕ → Stream}
    (hp : Runs p (X n) (component T (2 + branch h (X n j))) (Y n))
    (ih : ∀ i, HasProof T p q j h (2 * n, i, X n i)) :
    ∀ i, HasProof T p q j h (2 * n + 1, i, Y n i) := by
  intro i
  obtain ⟨k, qs, hk, hqs⟩ := (hp i (Y n i)).mpr rfl
  let s : Step := ((2 * n + 1, i, Y n i), X n j, k, qs)
  have hg : localGood p q s = true := by
    simpa [localGood, s, level, input, output, fuel, table] using hk
  have hl : tableMatches (leaves h s) T := by
    intro a ha
    have ha' : a ∈ qs.flatMap (fun x =>
        if x.1 % 2 = 0 then [] else
          [(Nat.pair (2 + branch h (X n j)) (x.1 / 2), x.2)]) := by
      simpa [leaves, s, level, table, branchValue] using ha
    obtain ⟨x, hx, hxa⟩ := List.mem_flatMap.mp ha'
    by_cases he : x.1 % 2 = 0
    · simp [he] at hxa
    · have heq : a = (Nat.pair (2 + branch h (X n j)) (x.1 / 2), x.2) := by
        simpa [he] using hxa
      subst a
      simpa [join, he, component] using hqs x hx
  apply proof_of_step s hg hl
  intro a ha
  have ha' : a ∈ qs.flatMap (fun x =>
      if x.1 % 2 = 0 then [(2 * n, x.1 / 2, x.2)] else []) ++
      [(2 * n, j, X n j)] := by
    simpa [premises, s, level, table, branchValue] using ha
  rcases List.mem_append.mp ha' with ha | ha
  · obtain ⟨x, hx, hxa⟩ := List.mem_flatMap.mp ha
    by_cases he : x.1 % 2 = 0
    · have heq : a = (2 * n, x.1 / 2, x.2) := by simpa [he] using hxa
      subst a
      have hv : X n (x.1 / 2) = x.2 := by simpa [join, he] using hqs x hx
      simpa [hv] using ih (x.1 / 2)
    · simp [he] at hxa
  · have heq : a = (2 * n, j, X n j) := by simpa using ha
    subst a
    exact ih j

theorem next_whole_proofs {T : Stream} {p q : Nat.Partrec.Code} {j h n : ℕ}
    {X Y : ℕ → Stream}
    (hq : Runs q (Y n) (component T 1) (X (n + 1)))
    (ih : ∀ i, HasProof T p q j h (2 * n + 1, i, Y n i)) :
    ∀ i, HasProof T p q j h (2 * (n + 1), i, X (n + 1) i) := by
  intro i
  obtain ⟨k, qs, hk, hqs⟩ := (hq i (X (n + 1) i)).mpr rfl
  let s : Step := ((2 * (n + 1), i, X (n + 1) i), 0, k, qs)
  have hg : localGood p q s = true := by
    simpa [localGood, s, level, input, output, fuel, table] using hk
  have hl : tableMatches (leaves h s) T := by
    intro a ha
    have ha' : a ∈ qs.flatMap (fun x =>
        if x.1 % 2 = 0 then [] else [(Nat.pair 1 (x.1 / 2), x.2)]) := by
      simpa [leaves, s, level, table] using ha
    obtain ⟨x, hx, hxa⟩ := List.mem_flatMap.mp ha'
    by_cases he : x.1 % 2 = 0
    · simp [he] at hxa
    · have heq : a = (Nat.pair 1 (x.1 / 2), x.2) := by simpa [he] using hxa
      subst a
      simpa [join, he, component] using hqs x hx
  apply proof_of_step s hg hl
  intro a ha
  have ha' : a ∈ qs.flatMap (fun x =>
      if x.1 % 2 = 0 then [(2 * n + 1, x.1 / 2, x.2)] else []) := by
    simpa [premises, s, level, table, show 2 * (n + 1) - 1 = 2 * n + 1 by omega]
      using ha
  obtain ⟨x, hx, hxa⟩ := List.mem_flatMap.mp ha'
  by_cases he : x.1 % 2 = 0
  · have heq : a = (2 * n + 1, x.1 / 2, x.2) := by simpa [he] using hxa
    subst a
    have hv : Y n (x.1 / 2) = x.2 := by simpa [join, he] using hqs x hx
    simpa [hv] using ih (x.1 / 2)
  · simp [he] at hxa

theorem all_stage_proofs {T : Stream} {p q : Nat.Partrec.Code} {j h : ℕ}
    {X Y : ℕ → Stream}
    (hzero : X 0 = component T 0)
    (hp : ∀ n, Runs p (X n) (component T (2 + branch h (X n j))) (Y n))
    (hq : ∀ n, Runs q (Y n) (component T 1) (X (n + 1))) :
    ∀ n i, HasProof T p q j h (2 * n, i, X n i) := by
  intro n
  induction n with
  | zero =>
      intro i
      let s : Step := ((0, i, X 0 i), 0, 0, [])
      apply proof_of_step s
      · rfl
      · intro a ha
        have he : a = (Nat.pair 0 i, X 0 i) := by simpa [leaves, s, level, input, output] using ha
        subst a
        simpa [component] using (congrFun hzero i).symm
      · simp [premises, s, level]
  | succ n ih =>
      exact next_whole_proofs (hq n) (next_half_proofs (hp n) ih)

attribute [fun_prop] Primrec
attribute [fun_prop] Primrec.id Primrec.const Primrec.fst Primrec.snd Primrec.pair Primrec.comp

@[fun_prop] theorem pr_natPair : Primrec (fun x : ℕ × ℕ => Nat.pair x.1 x.2) :=
  Primrec₂.natPair
@[fun_prop] theorem pr_add : Primrec (fun x : ℕ × ℕ => x.1 + x.2) := Primrec.nat_add
@[fun_prop] theorem pr_sub : Primrec (fun x : ℕ × ℕ => x.1 - x.2) := Primrec.nat_sub
@[fun_prop] theorem pr_mul : Primrec (fun x : ℕ × ℕ => x.1 * x.2) := Primrec.nat_mul
@[fun_prop] theorem pr_div : Primrec (fun x : ℕ × ℕ => x.1 / x.2) := Primrec.nat_div
@[fun_prop] theorem pr_mod : Primrec (fun x : ℕ × ℕ => x.1 % x.2) := Primrec.nat_mod

@[fun_prop] theorem pr_eq {α : Type} [Primcodable α] [DecidableEq α] :
    Primrec (fun x : α × α => decide (x.1 = x.2)) := Primrec.eq.decide
@[fun_prop] theorem pr_and : Primrec (fun x : Bool × Bool => x.1 && x.2) := Primrec.and
@[fun_prop] theorem pr_or : Primrec (fun x : Bool × Bool => x.1 || x.2) := Primrec.or
@[fun_prop] theorem pr_cons {α : Type} [Primcodable α] :
    Primrec (fun x : α × List α => x.1 :: x.2) := Primrec.list_cons
@[fun_prop] theorem pr_append {α : Type} [Primcodable α] :
    Primrec (fun x : List α × List α => x.1 ++ x.2) := Primrec.list_append
@[fun_prop] theorem pr_get {α : Type} [Primcodable α] :
    Primrec (fun x : List α × ℕ => x.1[x.2]?) := Primrec.list_getElem?

attribute [fun_prop] Primrec.unpair Primrec.option_some Primrec.encode Primrec.decode
  Primrec.list_head? Primrec.option_isSome Nat.Partrec.Code.primrec_evaln

@[fun_prop] theorem pr_conclusion : Primrec conclusion := Primrec.fst
@[fun_prop] theorem pr_branchValue : Primrec branchValue := Primrec.fst.comp Primrec.snd
@[fun_prop] theorem pr_fuel : Primrec fuel := Primrec.fst.comp (Primrec.snd.comp Primrec.snd)
@[fun_prop] theorem pr_table : Primrec table := Primrec.snd.comp (Primrec.snd.comp Primrec.snd)
@[fun_prop] theorem pr_level : Primrec level := Primrec.fst.comp Primrec.fst
@[fun_prop] theorem pr_input : Primrec input := Primrec.fst.comp (Primrec.snd.comp Primrec.fst)
@[fun_prop] theorem pr_output : Primrec output := Primrec.snd.comp (Primrec.snd.comp Primrec.fst)

@[fun_prop] theorem pr_branch (h : ℕ) : Primrec (branch h) :=
  Primrec.ite (Primrec.eq.comp Primrec.id (Primrec.const h))
    (Primrec.const 1) (Primrec.const 0)

theorem pr_level_zero : PrimrecPred (fun s : Step => level s = 0) :=
  Primrec.eq.comp pr_level (Primrec.const 0)

theorem pr_level_odd : PrimrecPred (fun s : Step => level s % 2 = 1) :=
  Primrec.eq.comp (Primrec.nat_mod.comp pr_level (Primrec.const 2)) (Primrec.const 1)

@[fun_prop] theorem pr_premises (j h : ℕ) : Primrec (premises j h) := by
  apply Primrec.ite pr_level_zero (Primrec.const [])
  apply Primrec₂.comp Primrec.list_append
  · apply Primrec.list_flatMap pr_table
    change Primrec (fun x : Step × Query =>
      if x.2.1 % 2 = 0 then [(level x.1 - 1, x.2.1 / 2, x.2.2)] else [])
    apply Primrec.ite
      (Primrec.eq.comp (Primrec.nat_mod.comp (Primrec.fst.comp Primrec.snd)
        (Primrec.const 2)) (Primrec.const 0))
    · fun_prop
    · exact Primrec.const []
  · apply Primrec.ite pr_level_odd
    · fun_prop
    · exact Primrec.const []

@[fun_prop] theorem pr_leaves (h : ℕ) : Primrec (leaves h) := by
  have hc : Primrec (fun s : Step =>
      if level s % 2 = 1 then 2 + branch h (branchValue s) else 1) := by
    apply Primrec.ite pr_level_odd
    · fun_prop
    · exact Primrec.const 1
  apply Primrec.ite pr_level_zero
  · fun_prop
  · apply Primrec.list_flatMap pr_table
    change Primrec (fun x : Step × Query =>
      if x.2.1 % 2 = 0 then [] else [(Nat.pair
        (if level x.1 % 2 = 1 then 2 + branch h (branchValue x.1) else 1)
        (x.2.1 / 2), x.2.2)])
    apply Primrec.ite
      (Primrec.eq.comp (Primrec.nat_mod.comp (Primrec.fst.comp Primrec.snd)
        (Primrec.const 2)) (Primrec.const 0)) (Primrec.const [])
    exact (by fun_prop : Primrec (fun x : ℕ × Query =>
      [(Nat.pair x.1 (x.2.1 / 2), x.2.2)])).comp
        ((hc.comp Primrec.fst).pair Primrec.snd)

@[fun_prop] theorem pr_localGood (p q : Nat.Partrec.Code) : Primrec (localGood p q) := by
  have hc : Primrec (fun s : Step => if level s % 2 = 1 then p else q) :=
    Primrec.ite pr_level_odd (Primrec.const p) (Primrec.const q)
  have he : Primrec (fun s : Step =>
      Nat.Partrec.Code.evaln (fuel s) (if level s % 2 = 1 then p else q)
        (encode (input s, output s, table s))) :=
    Nat.Partrec.Code.primrec_evaln.comp
      ((pr_fuel.pair hc).pair (Primrec.encode.comp
        (pr_input.pair (pr_output.pair pr_table))))
  exact Primrec.ite pr_level_zero (Primrec.const true)
    (pr_eq.comp (he.pair (Primrec.const (some 0))))

@[fun_prop] theorem pr_mem {α : Type} [Primcodable α] [DecidableEq α] :
    Primrec (fun x : List α × α => decide (x.2 ∈ x.1)) := by
  have h : PrimrecRel (fun (xs : List α) (a : α) => ∃ b ∈ xs, b = a) :=
    Primrec.eq.exists_mem_list
  exact (h.of_eq (by simp)).decide

def checkLeaves (k c : ℕ) (xs : List Query) : Bool :=
  allB (fun x => decide (prefixAt k c x.1 = some x.2)) xs

def checkPremises (ss : List Step) (xs : List Fact) : Bool :=
  allB (fun x => decide (x ∈ ss.map conclusion)) xs

def checkStep (p q : Nat.Partrec.Code) (j h k c : ℕ) (ss : List Step) (s : Step) : Bool :=
  localGood p q s && checkPremises ss (premises j h s) &&
    checkLeaves k c (leaves h s)

def checkProof (p q : Nat.Partrec.Code) (j h k c : ℕ) : List Step → Bool
  | [] => true
  | s :: ss => checkProof p q j h k c ss && checkStep p q j h k c ss s

theorem prefixAt_sound {T : Stream} {k i b : ℕ}
    (h : prefixAt k (oraclePrefix T k) i = some b) : T i = b := by
  by_cases hi : i < k
  · simpa [prefixAt_correct T hi] using h
  · simp [prefixAt, hi] at h

theorem checkProof_sound {T : Stream} {p q : Nat.Partrec.Code} {j h k : ℕ}
    {ss : List Step} (hc : checkProof p q j h k (oraclePrefix T k) ss = true) :
    Valid T p q j h ss := by
  induction ss with
  | nil => trivial
  | cons s ss ih =>
      have hh : checkProof p q j h k (oraclePrefix T k) ss = true ∧
          localGood p q s = true ∧
          (∀ a ∈ premises j h s, a ∈ ss.map conclusion) ∧
          (∀ x ∈ leaves h s,
            prefixAt k (oraclePrefix T k) x.1 = some x.2) := by
        simpa [checkProof, checkStep, checkPremises, checkLeaves, allB_iff,
          and_assoc] using hc
      exact ⟨ih hh.1, hh.2.1, hh.2.2.1,
        fun x hx => prefixAt_sound (hh.2.2.2 x hx)⟩

theorem checkProof_complete {T : Stream} {p q : Nat.Partrec.Code} {j h k : ℕ}
    {ss : List Step} (hv : Valid T p q j h ss)
    (hb : ∀ s ∈ ss, ∀ x ∈ leaves h s, x.1 < k) :
    checkProof p q j h k (oraclePrefix T k) ss = true := by
  induction ss with
  | nil => rfl
  | cons s ss ih =>
      have ht := ih hv.1 (fun s hs => hb s (by simp [hs]))
      simp only [checkProof, Bool.and_eq_true]
      refine ⟨ht, ?_⟩
      simp only [checkStep, Bool.and_eq_true, checkPremises, checkLeaves, allB_iff,
        decide_eq_true_eq]
      exact ⟨⟨hv.2.1, hv.2.2.1⟩, fun x hx =>
        (prefixAt_correct T (hb s (by simp) x hx)).trans
          (congrArg some (hv.2.2.2 x hx))⟩

theorem finite_query_bound {α : Type} (xs : List α) (f : α → ℕ) :
    ∃ k, ∀ x ∈ xs, f x < k := by
  induction xs with
  | nil => exact ⟨0, by simp⟩
  | cons x xs ih =>
      obtain ⟨k, hk⟩ := ih
      refine ⟨max (f x + 1) k, ?_⟩
      intro y hy
      rcases List.mem_cons.mp hy with rfl | hy
      · exact lt_of_lt_of_le (Nat.lt_succ_self _) (le_max_left _ _)
      · exact lt_of_lt_of_le (hk y hy) (le_max_right _ _)

theorem hasProof_head {T : Stream} {p q : Nat.Partrec.Code} {j h : ℕ} {a : Fact}
    (hp : HasProof T p q j h a) :
    ∃ s ss, conclusion s = a ∧ Valid T p q j h (s :: ss) := by
  obtain ⟨ss, hv, ha⟩ := hp
  induction ss with
  | nil => simp at ha
  | cons s ss ih =>
      rcases List.mem_cons.mp ha with ha | ha
      · exact ⟨s, ss, ha.symm, hv⟩
      · exact ih hv.1 ha

attribute [fun_prop] primrec_prefixAt

@[fun_prop] theorem pr_checkLeaves :
    Primrec (fun x : ℕ × ℕ × List Query => checkLeaves x.1 x.2.1 x.2.2) := by
  apply primrec_allB (Primrec.snd.comp Primrec.snd)
  change Primrec (fun x : (ℕ × ℕ × List Query) × Query =>
    decide (prefixAt x.1.1 x.1.2.1 x.2.1 = some x.2.2))
  have hl : Primrec (fun x : (ℕ × ℕ × List Query) × Query =>
      prefixAt x.1.1 x.1.2.1 x.2.1) :=
    primrec_prefixAt.comp (g := fun x : (ℕ × ℕ × List Query) × Query =>
      (x.1.1, x.1.2.1, x.2.1)) (by fun_prop)
  exact pr_eq.comp (hl.pair (Primrec.option_some.comp (Primrec.snd.comp Primrec.snd)))

@[fun_prop] theorem pr_checkPremises :
    Primrec (fun x : List Step × List Fact => checkPremises x.1 x.2) := by
  have hm : Primrec (fun ss : List Step => ss.map conclusion) :=
    Primrec.list_map Primrec.id (pr_conclusion.comp Primrec.snd).to₂
  apply primrec_allB Primrec.snd
  change Primrec (fun x : (List Step × List Fact) × Fact =>
    decide (x.2 ∈ x.1.1.map conclusion))
  have hmap : Primrec (fun x : (List Step × List Fact) × Fact =>
      x.1.1.map conclusion) := hm.comp (by fun_prop)
  apply (pr_mem.comp (hmap.pair Primrec.snd)).of_eq
  intro x
  simp only [decide_eq_decide]

@[fun_prop] theorem pr_checkStep (p q : Nat.Partrec.Code) (j h : ℕ) :
    Primrec (fun x : ℕ × ℕ × List Step × Step =>
      checkStep p q j h x.1 x.2.1 x.2.2.1 x.2.2.2) := by
  unfold checkStep
  fun_prop

@[fun_prop] theorem pr_checkProof (p q : Nat.Partrec.Code) (j h : ℕ) :
    Primrec (fun x : ℕ × ℕ × List Step =>
      checkProof p q j h x.1 x.2.1 x.2.2) := by
  have hr : Primrec (fun x : ℕ × ℕ × List Step =>
      List.recOn (motive := fun _ => Bool) x.2.2 true
        (fun s ss ih => ih && checkStep p q j h x.1 x.2.1 ss s)) := by
    have hs : Primrec (fun x : (ℕ × ℕ × List Step) × (Step × List Step × Bool) =>
        x.2.2.2 && checkStep p q j h x.1.1 x.1.2.1 x.2.2.1 x.2.1) := by fun_prop
    exact Primrec.list_rec
      (h := fun a b => b.2.2 && checkStep p q j h a.1 a.2.1 b.2.1 b.1)
      (Primrec.snd.comp Primrec.snd) (Primrec.const true) hs.to₂
  apply hr.of_eq
  intro x
  induction x.2.2 with
  | nil => rfl
  | cons s ss ih => simp [checkProof, ih]

def headAnswer (query : ℕ) : List Step → Option ℕ
  | [] => none
  | s :: _ =>
      if level s = query.unpair.1 ∧ input s = query.unpair.2 then some (output s)
      else none

def candidate (p q : Nat.Partrec.Code) (j h query c pref : ℕ) : Option ℕ :=
  (decode (α := List Step) c.unpair.2).bind (fun ss =>
    cond (checkProof p q j h c.unpair.1 pref ss) (headAnswer query ss) none)

def extract (c : ℕ) : ℕ :=
  output (((decode (α := List Step) c.unpair.2).getD []).head!)

@[fun_prop] theorem pr_headAnswer :
    Primrec (fun x : ℕ × List Step => headAnswer x.1 x.2) := by
  have hr : Primrec (fun x : (ℕ × List Step) × (Step × List Step) =>
    if level x.2.1 = x.1.1.unpair.1 ∧ input x.2.1 = x.1.1.unpair.2
    then some (output x.2.1) else none) := by
    apply Primrec.ite
      ((Primrec.eq.comp (by fun_prop) (by fun_prop)).and
        (Primrec.eq.comp (by fun_prop) (by fun_prop)))
    · fun_prop
    · exact Primrec.const none
  apply (Primrec.list_casesOn
    (h := fun a b => if level b.1 = a.1.unpair.1 ∧ input b.1 = a.1.unpair.2
      then some (output b.1) else none)
    Primrec.snd (Primrec.const none) hr.to₂).of_eq
  intro x
  cases x.2 <;> rfl

@[fun_prop] theorem pr_candidate (p q : Nat.Partrec.Code) (j h : ℕ) :
    Primrec (fun x : ℕ × ℕ × ℕ => candidate p q j h x.1 x.2.1 x.2.2) := by
  apply Primrec.option_bind (by fun_prop)
  change Primrec (fun x : (ℕ × ℕ × ℕ) × List Step =>
    cond (checkProof p q j h x.1.2.1.unpair.1 x.1.2.2 x.2)
      (headAnswer x.1.1 x.2) none)
  exact Primrec.cond (by fun_prop) (by fun_prop) (Primrec.const none)

@[fun_prop] theorem pr_extract : Primrec extract :=
  pr_output.comp (Primrec.list_headI.comp
    (Primrec.option_getD.comp
      (Primrec.decode.comp ((Primrec.snd.comp Primrec.unpair))) (Primrec.const [])))

theorem candidate_sound {T : Stream} {p q : Nat.Partrec.Code} {j h query c b : ℕ}
    (hc : candidate p q j h query c (oraclePrefix T c.unpair.1) = some b) :
    ∃ s ss, Valid T p q j h (s :: ss) ∧
      level s = query.unpair.1 ∧ input s = query.unpair.2 ∧
      output s = b ∧ extract c = b := by
  obtain ⟨ss, hd, hc⟩ := Option.bind_eq_some_iff.mp hc
  by_cases hv : checkProof p q j h c.unpair.1 (oraclePrefix T c.unpair.1) ss = true
  · have hh : headAnswer query ss = some b := by simpa [hv] using hc
    cases ss with
    | nil => simp [headAnswer] at hh
    | cons s ss =>
        have hh' : (level s = query.unpair.1 ∧ input s = query.unpair.2) ∧ output s = b := by
          simpa [headAnswer] using hh
        refine ⟨s, ss, checkProof_sound hv, hh'.1.1, hh'.1.2, hh'.2, ?_⟩
        rw [extract, hd]
        exact hh'.2
  · have hf : checkProof p q j h c.unpair.1 (oraclePrefix T c.unpair.1) ss = false := by
      cases hb : checkProof p q j h c.unpair.1 (oraclePrefix T c.unpair.1) ss <;> simp_all
    simp [hf] at hc

theorem candidate_complete {T : Stream} {p q : Nat.Partrec.Code} {j h l i b : ℕ}
    (hp : HasProof T p q j h (l, i, b)) :
    ∃ c, candidate p q j h (Nat.pair l i) c (oraclePrefix T c.unpair.1) = some b := by
  obtain ⟨s, ss, hs, hv⟩ := hasProof_head hp
  obtain ⟨k, hk⟩ := finite_query_bound ((s :: ss).flatMap (leaves h)) Prod.fst
  have hb : ∀ a ∈ s :: ss, ∀ x ∈ leaves h a, x.1 < k := by
    intro a ha x hx
    exact hk x (List.mem_flatMap.mpr ⟨a, ha, hx⟩)
  have hv' := checkProof_complete hv hb
  have hl : level s = l := congrArg Prod.fst hs
  have hi : input s = i := congrArg (fun a : Fact => a.2.1) hs
  have ho : output s = b := congrArg (fun a : Fact => a.2.2) hs
  refine ⟨Nat.pair k (encode (s :: ss)), ?_⟩
  simp only [candidate, Nat.unpair_pair, Encodable.encodek, Option.bind_some,
    hv', Bool.cond_true, headAnswer, hl, hi, ho, and_self, ↓reduceIte]

def search (T : Stream) (p q : Nat.Partrec.Code) (j h query : ℕ) : Part ℕ :=
  Nat.rfind (fun c => Part.some
    (candidate p q j h query c (oraclePrefix T c.unpair.1)).isSome)

theorem relative_search (T : Stream) (p q : Nat.Partrec.Code) (j h : ℕ) :
    Relative T (search T p q j h) := by
  have hdata : Computable (fun z : ℕ =>
      cond (candidate p q j h z.unpair.1 z.unpair.2.unpair.1
        z.unpair.2.unpair.2).isSome 0 1) := by
    apply Primrec.to_comp
    exact Primrec.cond (by fun_prop) (Primrec.const 0) (Primrec.const 1)
  have harg : Relative T (fun z => Part.some
      (Nat.pair z.unpair.1
        (Nat.pair z.unpair.2 (oraclePrefix T z.unpair.2.unpair.1)))) :=
    relative_pair (relative_ordinary (by exact (by fun_prop : Primrec
      (fun z : ℕ => z.unpair.1)).to_comp))
      (relative_pair (relative_ordinary (by exact (by fun_prop : Primrec
        (fun z : ℕ => z.unpair.2)).to_comp))
        (relative_comp (relative_prefix T)
          (relative_ordinary (by exact (by fun_prop : Primrec
            (fun z : ℕ => z.unpair.2.unpair.1)).to_comp))))
  have hr := Nat.RecursiveIn.rfind (relative_comp (relative_ordinary hdata) harg)
  refine hr.of_eq ?_
  intro query
  apply congrArg Nat.rfind
  funext c
  cases hc : candidate p q j h query c (oraclePrefix T c.unpair.1) <;>
    simp [Nat.unpair_pair, hc]

theorem infinite_oracle_substitution {T : Stream} {p q : Nat.Partrec.Code} {j h : ℕ}
    {X Y : ℕ → Stream}
    (hzero : X 0 = component T 0)
    (hp : ∀ n, Runs p (X n) (component T (2 + branch h (X n j))) (Y n))
    (hq : ∀ n, Runs q (Y n) (component T 1) (X (n + 1))) :
    Relative T (fun z => Part.some (X z.unpair.1 z.unpair.2)) := by
  have hout : Relative T (fun query =>
      (search T p q j h query).bind (fun c => Part.some (extract c))) :=
    Nat.RecursiveIn.comp (relative_ordinary pr_extract.to_comp)
      (relative_search T p q j h)
  have hquery : Computable (fun z : ℕ => Nat.pair (2 * z.unpair.1) z.unpair.2) :=
    (by fun_prop : Primrec (fun z : ℕ => Nat.pair (2 * z.unpair.1) z.unpair.2)).to_comp
  have hall := Nat.RecursiveIn.comp hout (relative_ordinary hquery)
  apply Nat.RecursiveIn.of_eq_tot hall
  intro z
  obtain ⟨c, hc⟩ := candidate_complete (all_stage_proofs hzero hp hq z.unpair.1 z.unpair.2)
  have hc' : (candidate p q j h (Nat.pair (2 * z.unpair.1) z.unpair.2)
      c (oraclePrefix T c.unpair.1)).isSome = true := by simp [hc]
  obtain ⟨d, hd, _⟩ := Nat.rfind_min'
    (p := fun c => (candidate p q j h (Nat.pair (2 * z.unpair.1) z.unpair.2)
      c (oraclePrefix T c.unpair.1)).isSome) hc'
  have hd' : (candidate p q j h (Nat.pair (2 * z.unpair.1) z.unpair.2)
      d (oraclePrefix T d.unpair.1)).isSome = true := by
    simpa using Nat.rfind_spec hd
  obtain ⟨b, hb⟩ := Option.isSome_iff_exists.mp hd'
  obtain ⟨s, ss, hv, hl, hi, ho, he⟩ := candidate_sound hb
  have hs := valid_sound hzero hp hq hv (conclusion s) (by simp)
  have hh : X z.unpair.1 z.unpair.2 = b := by
    simpa [semantic, conclusion, ← show level s = s.1.1 from rfl,
      ← show input s = s.1.2.1 from rfl, ← show output s = s.1.2.2 from rfl,
      hl, hi, ho, Nat.unpair_pair] using hs
  apply Part.mem_bind_iff.mpr
  refine ⟨Nat.pair (2 * z.unpair.1) z.unpair.2, by simp, ?_⟩
  apply Part.mem_bind_iff.mpr
  refine ⟨d, hd, ?_⟩
  simp [hh, he]

def rationalSpan (t s : ℝ) : Prop :=
  ∃ a b : ℚ, s = (a : ℝ) + (b : ℝ) * t

theorem span_zero (t : ℝ) : rationalSpan t 0 := by
  exact ⟨0, 0, by simp⟩

theorem span_increment (t : ℝ) (d : ℚ) (r : ℕ) :
    rationalSpan t ((d : ℝ) * (t - r)) := by
  refine ⟨-d * r, d, ?_⟩
  push_cast
  ring

theorem span_add {t a b : ℝ} (ha : rationalSpan t a) (hb : rationalSpan t b) :
    rationalSpan t (a + b) := by
  obtain ⟨x, y, rfl⟩ := ha
  obtain ⟨z, w, rfl⟩ := hb
  refine ⟨x + z, y + w, ?_⟩
  push_cast
  ring

def orbit (F : ℝ → Stream) (u t : ℝ) (d : ℚ) (j h : ℕ) : ℕ → ℝ
  | 0 => 0
  | n + 1 =>
      let s := orbit F u t d j h n
      s + (d : ℝ) * (t - branch h (F (u + s) j))

def choices (F : ℝ → Stream) (u t : ℝ) (d : ℚ) (j h n : ℕ) : ℕ :=
  branch h (F (u + orbit F u t d j h n) j)

theorem orbit_step (F : ℝ → Stream) (u t : ℝ) (d : ℚ) (j h n : ℕ) :
    orbit F u t d j h (n + 1) =
      orbit F u t d j h n + (d : ℝ) * (t - choices F u t d j h n) := rfl

theorem orbit_in_span (F : ℝ → Stream) (u t : ℝ) (d : ℚ) (j h : ℕ) :
    ∀ n, rationalSpan t (orbit F u t d j h n) := by
  intro n
  induction n with
  | zero => exact span_zero t
  | succ n ih => exact span_add ih (span_increment t d _)

theorem infinite_confinement
    (F : ℝ → Stream) (u t : ℝ) (d : ℚ) (j h : ℕ) (lo hi : ℝ)
    (ht0 : 0 < t) (ht1 : t < 1) (hd : 0 < (d : ℝ))
    (hlo : lo < 0) (hhi : 0 < hi)
    (hleft : ∀ s, rationalSpan t s → lo ≤ s → s ≤ lo + d → F (u + s) j ≠ h)
    (hright : ∀ s, rationalSpan t s → hi - d ≤ s → s ≤ hi → F (u + s) j = h) :
    ∀ n, lo ≤ orbit F u t d j h n ∧ orbit F u t d j h n ≤ hi := by
  intro n
  induction n with
  | zero => exact ⟨hlo.le, hhi.le⟩
  | succ n ih =>
      let s := orbit F u t d j h n
      have hspan : rationalSpan t s := orbit_in_span F u t d j h n
      by_cases hb : F (u + s) j = h
      · have hs : lo + d < s := by
          by_contra hn
          exact hleft s hspan ih.1 (le_of_not_gt hn) hb
        have he : orbit F u t d j h (n + 1) = s + (d : ℝ) * (t - 1) := by
          change s + (d : ℝ) * (t - branch h (F (u + s) j)) = _
          simp only [branch, hb, ↓reduceIte, Nat.cast_one]
        rw [he]
        constructor <;> nlinarith [mul_pos hd ht0, mul_pos hd (sub_pos.mpr ht1)]
      · have hs : s < hi - d := by
          by_contra hn
          exact hb (hright s hspan (le_of_not_gt hn) ih.2)
        have he : orbit F u t d j h (n + 1) = s + (d : ℝ) * t := by
          change s + (d : ℝ) * (t - branch h (F (u + s) j)) = _
          simp only [branch, hb, ↓reduceIte, Nat.cast_zero, sub_zero]
        rw [he]
        constructor <;> nlinarith [mul_pos hd ht0, mul_pos hd (sub_pos.mpr ht1)]

def count (r : ℕ → ℕ) : ℕ → ℕ
  | 0 => 0
  | n + 1 => count r n + r n

theorem telescope (F : ℝ → Stream) (u t : ℝ) (d : ℚ) (j h : ℕ) :
    ∀ n, orbit F u t d j h n =
      (d : ℝ) * ((n : ℝ) * t - count (choices F u t d j h) n) := by
  intro n
  induction n with
  | zero => simp [orbit, count]
  | succ n ih =>
      rw [orbit_step, ih, count]
      push_cast
      ring

theorem average_error {F : ℝ → Stream} {u t : ℝ} {d : ℚ} {j h n : ℕ}
    (hd : 0 < (d : ℝ)) (hn : 0 < n)
    (hb : |orbit F u t d j h n| < 1) :
    |t - (count (choices F u t d j h) n : ℝ) / n| <
      1 / ((n : ℝ) * d) := by
  have hn' : 0 < (n : ℝ) := by exact_mod_cast hn
  have hden : 0 < (n : ℝ) * d := mul_pos hn' hd
  have he : t - (count (choices F u t d j h) n : ℝ) / n =
      orbit F u t d j h n / ((n : ℝ) * d) := by
    rw [telescope]
    field_simp
  rw [he, abs_div, abs_of_pos hden]
  exact (div_lt_div_iff_of_pos_right hden).mpr hb

def fourOracle (F : ℝ → Stream) (u v t : ℝ) (d : ℚ) : Stream := fun z =>
  match z.unpair.1 with
  | 0 => F u z.unpair.2
  | 1 => F (u - v) z.unpair.2
  | 2 => F (v - u + (d : ℝ) * t) z.unpair.2
  | _ => F (v - u + (d : ℝ) * (t - 1)) z.unpair.2

theorem bounded_local_programs_compute_branches
    (F : ℝ → Stream) (u v t rho lo hi : ℝ) (d : ℚ) (j h : ℕ)
    (p q : Nat.Partrec.Code)
    (ht0 : 0 < t) (ht1 : t < 1) (hd : 0 < (d : ℝ)) (hdr : (d : ℝ) < rho)
    (hlo : -rho < lo) (hlo0 : lo < 0) (hhi0 : 0 < hi) (hhi : hi < rho)
    (hleft : ∀ s, rationalSpan t s → lo ≤ s → s ≤ lo + d → F (u + s) j ≠ h)
    (hright : ∀ s, rationalSpan t s → hi - d ≤ s → s ≤ hi → F (u + s) j = h)
    (plocal : ∀ s a, rationalSpan t s → rationalSpan t a → |s| < rho → |a| < rho →
      Runs p (F (u + s)) (F (v - u + a)) (F (v + s + a)))
    (qlocal : ∀ s, rationalSpan t s → |s| < rho →
      Runs q (F (v + s)) (F (u - v)) (F (u + s))) :
    Relative (fourOracle F u v t d)
      (fun n => Part.some (choices F u t d j h n)) := by
  let T := fourOracle F u v t d
  let X : ℕ → Stream := fun n => F (u + orbit F u t d j h n)
  let Y : ℕ → Stream := fun n => F (v + orbit F u t d j h (n + 1))
  have hb := infinite_confinement F u t d j h lo hi ht0 ht1 hd hlo0 hhi0 hleft hright
  have habs : ∀ n, |orbit F u t d j h n| < rho := by
    intro n
    exact abs_lt.mpr ⟨lt_of_lt_of_le hlo (hb n).1, lt_of_le_of_lt (hb n).2 hhi⟩
  have hzero : X 0 = component T 0 := by
    funext i
    simp [X, T, component, fourOracle, orbit]
  have hp : ∀ n, Runs p (X n) (component T (2 + branch h (X n j))) (Y n) := by
    intro n
    let a : ℝ := (d : ℝ) * (t - choices F u t d j h n)
    have ha : |a| < rho := by
      by_cases hc : F (u + orbit F u t d j h n) j = h
      · simp only [a, choices, branch, hc, ↓reduceIte, Nat.cast_one]
        apply abs_lt.mpr
        constructor <;> nlinarith [mul_pos hd ht0, mul_pos hd (sub_pos.mpr ht1)]
      · simp only [a, choices, branch, hc, ↓reduceIte, Nat.cast_zero, sub_zero]
        apply abs_lt.mpr
        constructor <;> nlinarith [mul_pos hd ht0, mul_pos hd (sub_pos.mpr ht1)]
    have hh := plocal (orbit F u t d j h n) a
      (orbit_in_span F u t d j h n) (span_increment t d _) (habs n) ha
    have he : F (v + orbit F u t d j h n + a) = Y n := by
      dsimp [Y]
      rw [orbit_step]
      simp [a, add_assoc]
    rw [he] at hh
    have hc : component T (2 + branch h (X n j)) = F (v - u + a) := by
      funext i
      by_cases hv : X n j = h <;>
        simp [component, T, fourOracle, branch, hv, a, choices, X] at *
    rw [hc]
    exact hh
  have hq : ∀ n, Runs q (Y n) (component T 1) (X (n + 1)) := by
    intro n
    have hh := qlocal (orbit F u t d j h (n + 1))
      (orbit_in_span F u t d j h (n + 1)) (habs (n + 1))
    have hc : component T 1 = F (u - v) := by
      funext i
      simp [component, T, fourOracle]
    rw [hc]
    exact hh
  have hstreams := infinite_oracle_substitution hzero hp hq
  have hread : Relative T (fun n => Part.some (X n j)) := by
    refine (relative_comp hstreams
      (relative_ordinary (by exact (by fun_prop : Primrec
        (fun n : ℕ => Nat.pair n j)).to_comp))).of_eq ?_
    intro n
    simp only [Nat.unpair_pair]
  have hr : Relative T (fun n => Part.some (branch h (X n j))) :=
    relative_comp (relative_ordinary (pr_branch h).to_comp) hread
  exact hr

theorem relative_count {T : Stream} {r : ℕ → ℕ}
    (hr : Relative T (fun n => Part.some (r n))) :
    Relative T (fun n => Part.some (count r n)) := by
  have hn : Relative T (fun z => Part.some z.unpair.2.unpair.1) :=
    relative_ordinary (by exact (by fun_prop : Primrec
      (fun z : ℕ => z.unpair.2.unpair.1)).to_comp)
  have hi : Relative T (fun z => Part.some z.unpair.2.unpair.2) :=
    relative_ordinary (by exact (by fun_prop : Primrec
      (fun z : ℕ => z.unpair.2.unpair.2)).to_comp)
  have hadd : Relative T (fun z => Part.some (z.unpair.1 + z.unpair.2)) :=
    relative_ordinary (by exact (by fun_prop : Primrec
      (fun z : ℕ => z.unpair.1 + z.unpair.2)).to_comp)
  have hs : Relative T (fun z => Part.some
      (z.unpair.2.unpair.2 + r z.unpair.2.unpair.1)) := by
    simpa only [Nat.unpair_pair] using
      relative_comp hadd (relative_pair hi (relative_comp hr hn))
  have hp : Relative T (fun z => z.unpair.2.rec (Part.some 0) fun n ih =>
      ih.bind fun c => Part.some (c + r n)) := by
    simpa using Nat.RecursiveIn.prec (relative_ordinary (Computable.const 0)) hs
  have hp' : Relative T (fun z => Part.some (count r z.unpair.2)) := by
    apply Nat.RecursiveIn.of_eq_tot hp
    intro z
    induction z.unpair.2 with
    | zero => simp [count]
    | succ n ih =>
        exact Part.mem_bind_iff.mpr ⟨count r n, ih, by simp [count]⟩
  refine (relative_comp hp' (relative_ordinary (by exact (by fun_prop : Primrec
    (fun n : ℕ => Nat.pair 0 n)).to_comp))).of_eq ?_
  intro n
  simp only [Nat.unpair_pair]

noncomputable def rationalQuery (z : ℕ) : ℝ :=
  ((z.unpair.1 : ℝ) - z.unpair.2.unpair.1) / (z.unpair.2.unpair.2 + 1)

noncomputable def strictCut (t : ℝ) (z : ℕ) : ℕ := if rationalQuery z < t then 1 else 0

def lower (K z N S : ℕ) : Prop :=
  z.unpair.1 * N + K * (z.unpair.2.unpair.2 + 1) <
    S * (z.unpair.2.unpair.2 + 1) + z.unpair.2.unpair.1 * N

def upper (K z N S : ℕ) : Prop :=
  S * (z.unpair.2.unpair.2 + 1) + K * (z.unpair.2.unpair.2 + 1) +
    z.unpair.2.unpair.1 * N < z.unpair.1 * N

instance (K z N S : ℕ) : Decidable (lower K z N S) := inferInstanceAs (Decidable (_ < _))
instance (K z N S : ℕ) : Decidable (upper K z N S) := inferInstanceAs (Decidable (_ < _))

def separated (K z N S : ℕ) : Bool := decide (lower K z N S) || decide (upper K z N S)

def decodedAnswer (K z N S : ℕ) : ℕ := if lower K z N S then 1 else 0

theorem lower_iff {K z N S : ℕ} (hn : 0 < N) :
    lower K z N S ↔ rationalQuery z < (S : ℝ) / N - (K : ℝ) / N := by
  have hn' : 0 < (N : ℝ) := by exact_mod_cast hn
  have hd : 0 < (z.unpair.2.unpair.2 : ℝ) + 1 := by positivity
  rw [rationalQuery, ← sub_div, div_lt_div_iff₀ hd hn']
  constructor
  · intro h
    have hc :
        (z.unpair.1 : ℝ) * N + K * ((z.unpair.2.unpair.2 : ℝ) + 1) <
        (S : ℝ) * ((z.unpair.2.unpair.2 : ℝ) + 1) +
          z.unpair.2.unpair.1 * N := by exact_mod_cast h
    nlinarith
  · intro h
    have hc :
        (z.unpair.1 : ℝ) * N + K * ((z.unpair.2.unpair.2 : ℝ) + 1) <
        (S : ℝ) * ((z.unpair.2.unpair.2 : ℝ) + 1) +
          z.unpair.2.unpair.1 * N := by nlinarith
    exact_mod_cast hc

theorem upper_iff {K z N S : ℕ} (hn : 0 < N) :
    upper K z N S ↔ (S : ℝ) / N + (K : ℝ) / N < rationalQuery z := by
  have hn' : 0 < (N : ℝ) := by exact_mod_cast hn
  have hd : 0 < (z.unpair.2.unpair.2 : ℝ) + 1 := by positivity
  rw [rationalQuery, ← add_div, div_lt_div_iff₀ hn' hd]
  constructor
  · intro h
    have hc :
        (S : ℝ) * ((z.unpair.2.unpair.2 : ℝ) + 1) +
          K * ((z.unpair.2.unpair.2 : ℝ) + 1) +
          z.unpair.2.unpair.1 * N < (z.unpair.1 : ℝ) * N := by exact_mod_cast h
    nlinarith
  · intro h
    have hc :
        (S : ℝ) * ((z.unpair.2.unpair.2 : ℝ) + 1) +
          K * ((z.unpair.2.unpair.2 : ℝ) + 1) +
          z.unpair.2.unpair.1 * N < (z.unpair.1 : ℝ) * N := by nlinarith
    exact_mod_cast hc

theorem decoding_sound {t : ℝ} {K z N S : ℕ} (hn : 0 < N)
    (he : |t - (S : ℝ) / N| < (K : ℝ) / N)
    (hs : separated K z N S = true) :
    decodedAnswer K z N S = strictCut t z := by
  have herr := abs_lt.mp he
  have hs' : lower K z N S ∨ upper K z N S := by simpa [separated] using hs
  by_cases hl : lower K z N S
  · have hh := (lower_iff hn).mp hl
    have hlt : rationalQuery z < t := by linarith
    simp [decodedAnswer, hl, strictCut, hlt]
  · have hu := (upper_iff hn).mp (hs'.resolve_left hl)
    have hgt : t < rationalQuery z := by linarith
    simp [decodedAnswer, hl, strictCut, not_lt.mpr hgt.le]

theorem decoding_terminates {t : ℝ} {K : ℕ} {r : ℕ → ℕ}
    (hk : 0 < K) (z : ℕ) (hne : rationalQuery z ≠ t)
    (he : ∀ N, 0 < N → |t - (count r N : ℝ) / N| < (K : ℝ) / N) :
    ∃ n, separated K z (n + 1) (count r (n + 1)) = true := by
  have hg : 0 < |t - rationalQuery z| := abs_pos.mpr (sub_ne_zero.mpr hne.symm)
  obtain ⟨N, hN⟩ := exists_nat_gt (2 * (K : ℝ) / |t - rationalQuery z|)
  have hk' : 0 < (K : ℝ) := by exact_mod_cast hk
  have hN0 : 0 < (N : ℝ) := lt_trans (div_pos (by positivity) hg) hN
  have hn : 0 < N := by exact_mod_cast hN0
  have hg' : 2 * (K : ℝ) < (N : ℝ) * |t - rationalQuery z| := by
    have hh := (div_lt_iff₀ hg).mp hN
    nlinarith
  have hsmall : 2 * ((K : ℝ) / N) < |t - rationalQuery z| := by
    rw [← mul_div_assoc, div_lt_iff₀ hN0]
    simpa only [mul_comm] using hg'
  have herr := abs_lt.mp (he N hn)
  have hs : separated K z N (count r N) = true := by
    rcases lt_or_gt_of_ne hne with hlt | hgt
    · have hgap : |t - rationalQuery z| = t - rationalQuery z :=
        abs_of_pos (sub_pos.mpr hlt)
      have hl : lower K z N (count r N) := (lower_iff hn).mpr (by
        rw [hgap] at hsmall
        linarith)
      simp [separated, hl]
    · have hgap : |t - rationalQuery z| = rationalQuery z - t := by
        rw [abs_of_neg (sub_neg.mpr hgt)]
        ring
      have hu : upper K z N (count r N) := (upper_iff hn).mpr (by
        rw [hgap] at hsmall
        linarith)
      simp [separated, hu]
  refine ⟨N - 1, ?_⟩
  simpa only [Nat.sub_add_cancel hn] using hs

@[fun_prop] theorem pr_lt : Primrec (fun x : ℕ × ℕ => decide (x.1 < x.2)) :=
  Primrec.nat_lt.decide

theorem pr_lower (K : ℕ) :
    PrimrecPred (fun x : ℕ × ℕ × ℕ => lower K x.1 x.2.1 x.2.2) := by
  change PrimrecPred (fun x : ℕ × ℕ × ℕ =>
    x.1.unpair.1 * x.2.1 + K * (x.1.unpair.2.unpair.2 + 1) <
      x.2.2 * (x.1.unpair.2.unpair.2 + 1) + x.1.unpair.2.unpair.1 * x.2.1)
  exact Primrec.nat_lt.comp (by fun_prop) (by fun_prop)

theorem pr_upper (K : ℕ) :
    PrimrecPred (fun x : ℕ × ℕ × ℕ => upper K x.1 x.2.1 x.2.2) := by
  change PrimrecPred (fun x : ℕ × ℕ × ℕ =>
    x.2.2 * (x.1.unpair.2.unpair.2 + 1) + K * (x.1.unpair.2.unpair.2 + 1) +
      x.1.unpair.2.unpair.1 * x.2.1 < x.1.unpair.1 * x.2.1)
  exact Primrec.nat_lt.comp (by fun_prop) (by fun_prop)

@[fun_prop] theorem pr_separated (K : ℕ) :
    Primrec (fun x : ℕ × ℕ × ℕ => separated K x.1 x.2.1 x.2.2) :=
  Primrec.or.comp (pr_lower K).decide (pr_upper K).decide

@[fun_prop] theorem pr_decodedAnswer (K : ℕ) :
    Primrec (fun x : ℕ × ℕ × ℕ => decodedAnswer K x.1 x.2.1 x.2.2) :=
  Primrec.ite (pr_lower K) (Primrec.const 1) (Primrec.const 0)

theorem relative_boolean_find {T : Stream} {test : ℕ → ℕ → Bool}
    (ht : Relative T (fun z => Part.some (cond (test z.unpair.1 z.unpair.2) 0 1))) :
    Relative T (fun query => Nat.rfind (fun n => Part.some (test query n))) := by
  refine (Nat.RecursiveIn.rfind ht).of_eq ?_
  intro query
  apply congrArg Nat.rfind
  funext n
  cases ht : test query n <;> simp [Nat.unpair_pair, ht]

def decodeSearch (K : ℕ) (r : ℕ → ℕ) (query : ℕ) : Part ℕ :=
  Nat.rfind (fun n => Part.some (separated K query (n + 1) (count r (n + 1))))

theorem branches_compute_cut {T : Stream} {t : ℝ} {K : ℕ} {r : ℕ → ℕ}
    (hk : 0 < K) (hne : ∀ z, rationalQuery z ≠ t)
    (hr : Relative T (fun n => Part.some (r n)))
    (he : ∀ N, 0 < N → |t - (count r N : ℝ) / N| < (K : ℝ) / N) :
    Relative T (fun z => Part.some (strictCut t z)) := by
  have hN : Relative T (fun z => Part.some (z.unpair.2 + 1)) :=
    relative_ordinary (by exact (by fun_prop : Primrec
      (fun z : ℕ => z.unpair.2 + 1)).to_comp)
  have hargs : Relative T (fun z => Part.some
      (Nat.pair z.unpair.1 (Nat.pair (z.unpair.2 + 1) (count r (z.unpair.2 + 1))))) :=
    relative_pair (relative_ordinary (by exact (by fun_prop : Primrec
      (fun z : ℕ => z.unpair.1)).to_comp))
      (relative_pair hN (relative_comp (relative_count hr) hN))
  have htestData : Computable (fun z : ℕ =>
      cond (separated K z.unpair.1 z.unpair.2.unpair.1 z.unpair.2.unpair.2) 0 1) := by
    exact (Primrec.cond (by fun_prop) (Primrec.const 0) (Primrec.const 1)).to_comp
  have hanswerData : Computable (fun z : ℕ =>
      decodedAnswer K z.unpair.1 z.unpair.2.unpair.1 z.unpair.2.unpair.2) :=
    (by fun_prop : Primrec (fun z : ℕ =>
      decodedAnswer K z.unpair.1 z.unpair.2.unpair.1 z.unpair.2.unpair.2)).to_comp
  have htest : Relative T (fun z => Part.some (cond
      (separated K z.unpair.1 (z.unpair.2 + 1) (count r (z.unpair.2 + 1))) 0 1)) := by
    refine (relative_comp (relative_ordinary htestData) hargs).of_eq ?_
    intro z
    simp only [Nat.unpair_pair]
  have hanswer : Relative T (fun z => Part.some
      (decodedAnswer K z.unpair.1 (z.unpair.2 + 1) (count r (z.unpair.2 + 1)))) := by
    refine (relative_comp (relative_ordinary hanswerData) hargs).of_eq ?_
    intro z
    simp only [Nat.unpair_pair]
  have hsearch : Relative T (decodeSearch K r) := relative_boolean_find htest
  have hpairs := Nat.RecursiveIn.pair (relative_ordinary (T := T) Computable.id) hsearch
  have houtput := Nat.RecursiveIn.comp hanswer hpairs
  apply Nat.RecursiveIn.of_eq_tot houtput
  intro z
  obtain ⟨n, hn⟩ := decoding_terminates hk z (hne z) he
  obtain ⟨m, hm, _⟩ := Nat.rfind_min'
    (p := fun n => separated K z (n + 1) (count r (n + 1))) hn
  have hs : separated K z (m + 1) (count r (m + 1)) = true := by
    simpa using Nat.rfind_spec hm
  have hc := decoding_sound (Nat.succ_pos m) (he (m + 1) (Nat.succ_pos m)) hs
  apply Part.mem_bind_iff.mpr
  refine ⟨Nat.pair z m, ?_, ?_⟩
  · simpa [Seq.seq, decodeSearch] using Part.mem_map (Nat.pair z) hm
  · simpa only [Nat.unpair_pair, Part.mem_some_iff] using hc.symm

theorem irrational_query_ne {t : ℝ} (ht : Irrational t) (z : ℕ) :
    rationalQuery z ≠ t := by
  have hh := ht.ne_rational ((z.unpair.1 : ℤ) - z.unpair.2.unpair.1)
    ((z.unpair.2.unpair.2 : ℤ) + 1)
  intro h
  apply hh
  simpa only [rationalQuery, Int.cast_sub, Int.cast_natCast, Int.cast_add,
    Int.cast_one] using h.symm

theorem recovery_core
    (F : ℝ → Stream) (u v t rho lo hi : ℝ) (d : ℚ) (K j h : ℕ)
    (p q : Nat.Partrec.Code)
    (ht : Irrational t) (ht0 : 0 < t) (ht1 : t < 1)
    (hk : 0 < K) (hdBound : 1 / (d : ℝ) ≤ (K : ℝ))
    (hd : 0 < (d : ℝ)) (hdr : (d : ℝ) < rho) (hrho : rho < 1)
    (hlo : -rho < lo) (hlo0 : lo < 0) (hhi0 : 0 < hi) (hhi : hi < rho)
    (hleft : ∀ s, rationalSpan t s → lo ≤ s → s ≤ lo + d → F (u + s) j ≠ h)
    (hright : ∀ s, rationalSpan t s → hi - d ≤ s → s ≤ hi → F (u + s) j = h)
    (plocal : ∀ s a, rationalSpan t s → rationalSpan t a → |s| < rho → |a| < rho →
      Runs p (F (u + s)) (F (v - u + a)) (F (v + s + a)))
    (qlocal : ∀ s, rationalSpan t s → |s| < rho →
      Runs q (F (v + s)) (F (u - v)) (F (u + s))) :
    Relative (fourOracle F u v t d) (fun n => Part.some (choices F u t d j h n)) ∧
    Relative (fourOracle F u v t d) (fun z => Part.some (strictCut t z)) := by
  have hbranches := bounded_local_programs_compute_branches F u v t rho lo hi d j h p q
    ht0 ht1 hd hdr hlo hlo0 hhi0 hhi hleft hright plocal qlocal
  refine ⟨hbranches, branches_compute_cut hk (irrational_query_ne ht) hbranches ?_⟩
  intro N hn
  have hconf := infinite_confinement F u t d j h lo hi ht0 ht1 hd hlo0 hhi0 hleft hright N
  have habs : |orbit F u t d j h N| < 1 :=
    lt_trans (abs_lt.mpr
      ⟨lt_of_lt_of_le hlo hconf.1, lt_of_le_of_lt hconf.2 hhi⟩) hrho
  have herr := average_error hd hn habs
  have hn' : 0 < (N : ℝ) := by exact_mod_cast hn
  have he : 1 / ((N : ℝ) * d) = (1 / (d : ℝ)) / N := by
    field_simp
    <;> ring
  exact lt_of_lt_of_le herr (by
    rw [he]
    exact (div_le_div_iff_of_pos_right hn').mpr hdBound)

theorem four_value_recovery
    (F : ℝ → Stream) (u v t rho lo hi : ℝ) (d : ℚ) (j h : ℕ)
    (p q : Nat.Partrec.Code)
    (ht : Irrational t) (ht0 : 0 < t) (ht1 : t < 1)
    (hd : 0 < (d : ℝ)) (hdr : (d : ℝ) < rho) (hrho : rho < 1)
    (hlo : -rho < lo) (hlo0 : lo < 0) (hhi0 : 0 < hi) (hhi : hi < rho)
    (hleft : ∀ s, rationalSpan t s → lo ≤ s → s ≤ lo + d → F (u + s) j ≠ h)
    (hright : ∀ s, rationalSpan t s → hi - d ≤ s → s ≤ hi → F (u + s) j = h)
    (plocal : ∀ s a, rationalSpan t s → rationalSpan t a → |s| < rho → |a| < rho →
      Runs p (F (u + s)) (F (v - u + a)) (F (v + s + a)))
    (qlocal : ∀ s, rationalSpan t s → |s| < rho →
      Runs q (F (v + s)) (F (u - v)) (F (u + s))) :
    Relative (fourOracle F u v t d) (fun n => Part.some (choices F u t d j h n)) ∧
    Relative (fourOracle F u v t d) (fun z => Part.some (strictCut t z)) := by
  obtain ⟨K, hK⟩ := exists_nat_gt (1 / (d : ℝ))
  have hk : 0 < K := by
    have hh : 0 < (K : ℝ) := lt_trans (one_div_pos.mpr hd) hK
    exact_mod_cast hh
  exact recovery_core F u v t rho lo hi d K j h p q ht ht0 ht1 hk hK.le hd hdr hrho
    hlo hlo0 hhi0 hhi hleft hright plocal qlocal

#print axioms infinite_oracle_substitution
#print axioms recovery_core
#print axioms four_value_recovery

end FourValueRecovery
