import Mathlib

namespace CompilerPreprocess

universe u v

inductive Base (A : Type u)
  | anchor : A → Base A
  | cutC
  | cutD
  | workspace

inductive Tag (A : Type u) (D : Type v)
  | clean
  | dirty : D → Option A → Tag A D

structure Cell (A : Type u) (D : Type v) where
  base : Base A
  tag : Tag A D

inductive Head
  | raw
  | quota
  | cleanup

structure Sector (A : Type u) (D : Type v) where
  alpha : Bool
  left : List (Cell A D)
  head : Head
  right : List (Cell A D)
  omega : Bool

variable {A : Type u} {D : Type v}

def anchor (a : A) : Cell A D := ⟨.anchor a, .clean⟩
def cutC : Cell A D := ⟨.cutC, .clean⟩
def cutD : Cell A D := ⟨.cutD, .clean⟩
def workspace : Cell A D := ⟨.workspace, .clean⟩

def cellGrade (b : Cell A D) : Nat :=
  match b.base with
  | .cutC => 2
  | .workspace => 0
  | _ => 1

def cellsGrade : List (Cell A D) → Nat
  | [] => 0
  | b :: bs => cellGrade b + cellsGrade bs

def Sector.grade (s : Sector A D) : Nat :=
  (if s.alpha then 1 else 0) + cellsGrade s.left + 1 +
    cellsGrade s.right + (if s.omega then 1 else 0)

def sectorsGrade : List (Sector A D) → Nat
  | [] => 0
  | s :: ss => s.grade + sectorsGrade ss

@[simp] theorem cellsGrade_append (l r : List (Cell A D)) :
    cellsGrade (l ++ r) = cellsGrade l + cellsGrade r := by
  induction l with
  | nil => simp [cellsGrade]
  | cons b l ih => simp [cellsGrade, ih, Nat.add_assoc]

def slide : List (Cell A D) → List (Cell A D) →
    List (Cell A D) × List (Cell A D)
  | ⟨.anchor a, .clean⟩ :: l, r => slide l (anchor a :: r)
  | l, r => (l, r)

def rawNormal (a : Bool) (l r : List (Cell A D)) (o : Bool) : Sector A D :=
  let p := slide l r
  ⟨a, p.1, .raw, p.2, o⟩

def trim : List (Cell A D) → List (Cell A D)
  | ⟨.workspace, .clean⟩ :: l => trim l
  | l => l

def quotaResult (a : Bool) (l r : List (Cell A D)) (o : Bool) :
    List (Sector A D) :=
  match l with
  | ⟨.cutC, .clean⟩ :: rest =>
      [rawNormal a rest [] true, rawNormal true [] r o]
  | _ => [⟨a, l, .quota, cutD :: r, o⟩]

def emit (b : Cell A D) : List (Cell A D) :=
  match b with
  | ⟨.anchor _, .dirty _ (some a)⟩ => [anchor a]
  | _ => []

def cleanLeft : List (Cell A D) → List (Cell A D) → List (Cell A D)
  | [], r => r
  | b :: l, r => cleanLeft l (emit b ++ r)

def preprocess : Sector A D → List (Sector A D)
  | ⟨a, l, .raw, r, o⟩ => [rawNormal a l r o]
  | ⟨a, l, .quota, ⟨.cutD, .clean⟩ :: r, o⟩ => quotaResult a (trim l) r o
  | s@⟨_, _, .quota, _, _⟩ => [s]
  | ⟨a, l, .cleanup, r, o⟩ =>
      [⟨a, [], if a then .raw else .cleanup, cleanLeft l r, o⟩]

theorem slide_grade (l r : List (Cell A D)) :
    cellsGrade (slide l r).1 + cellsGrade (slide l r).2 =
      cellsGrade l + cellsGrade r := by
  induction l generalizing r with
  | nil => rfl
  | cons b l ih =>
    rcases b with ⟨base, tag⟩
    cases base with
    | anchor a =>
      cases tag with
      | clean =>
        change cellsGrade (slide l (anchor a :: r)).1 +
          cellsGrade (slide l (anchor a :: r)).2 = _
        rw [ih]
        simp [cellsGrade, cellGrade, anchor]
        omega
      | dirty d out => rfl
    | cutC => cases tag <;> rfl
    | cutD => cases tag <;> rfl
    | workspace => cases tag <;> rfl

@[simp] theorem rawNormal_grade (a o : Bool) (l r : List (Cell A D)) :
    (rawNormal a l r o).grade = (Sector.mk a l .raw r o).grade := by
  have h := slide_grade l r
  dsimp only [rawNormal, Sector.grade]
  omega

@[simp] theorem trim_grade (l : List (Cell A D)) :
    cellsGrade (trim l) = cellsGrade l := by
  induction l with
  | nil => rfl
  | cons b l ih =>
    rcases b with ⟨base, tag⟩
    cases base <;> cases tag <;> simp [trim, cellsGrade, cellGrade, ih]

theorem emit_grade (b : Cell A D) : cellsGrade (emit b) ≤ cellGrade b := by
  rcases b with ⟨base, tag⟩
  cases base <;> cases tag <;> simp [emit, cellsGrade, cellGrade, anchor]
  split <;> simp [cellsGrade, cellGrade]

theorem cleanLeft_grade (l r : List (Cell A D)) :
    cellsGrade (cleanLeft l r) ≤ cellsGrade l + cellsGrade r := by
  induction l generalizing r with
  | nil => simp [cleanLeft, cellsGrade]
  | cons b l ih =>
    have h := ih (emit b ++ r)
    have he := emit_grade b
    simp only [cellsGrade_append] at h
    simp only [cleanLeft, cellsGrade]
    omega

@[simp] theorem quotaResult_grade (a o : Bool) (l r : List (Cell A D)) :
    sectorsGrade (quotaResult a l r o) =
      (Sector.mk a l .quota (cutD :: r) o).grade := by
  cases l with
  | nil => rfl
  | cons b l =>
    rcases b with ⟨base, tag⟩
    cases base <;> cases tag <;>
      simp only [quotaResult, sectorsGrade, rawNormal_grade] <;>
      simp [Sector.grade, cellsGrade, cellGrade, cutD] <;> omega

theorem preprocess_grade (s : Sector A D) :
    sectorsGrade (preprocess s) ≤ s.grade := by
  rcases s with ⟨a, l, head, r, o⟩
  cases head with
  | raw => simp [preprocess, sectorsGrade, rawNormal_grade]
  | cleanup =>
    have h := cleanLeft_grade l r
    simp only [preprocess, sectorsGrade, Sector.grade, cellsGrade]
    omega
  | quota =>
    cases r with
    | nil => simp [preprocess, sectorsGrade]
    | cons b r =>
      rcases b with ⟨base, tag⟩
      cases base <;> cases tag <;>
        simp [preprocess, sectorsGrade, quotaResult_grade, Sector.grade, trim_grade, cutD]

theorem raw_slide (a o : Bool) (l r : List (Cell A D)) (x : A) :
    preprocess ⟨a, l, .raw, anchor x :: r, o⟩ =
      preprocess ⟨a, anchor x :: l, .raw, r, o⟩ := rfl

theorem quota_insertion (a o : Bool) (l r : List (Cell A D)) :
    preprocess ⟨a, l, .quota, cutD :: r, o⟩ =
      preprocess ⟨a, workspace :: l, .quota, cutD :: r, o⟩ := rfl

theorem merge (a o : Bool) (l r : List (Cell A D)) :
    preprocess ⟨a, l, .raw, [], true⟩ ++
        preprocess ⟨true, [], .raw, r, o⟩ =
      preprocess ⟨a, cutC :: l, .quota, cutD :: r, o⟩ := rfl

theorem cleanup_cell (a o : Bool) (b : Cell A D) (l r : List (Cell A D)) :
    preprocess ⟨a, b :: l, .cleanup, r, o⟩ =
      preprocess ⟨a, l, .cleanup, emit b ++ r, o⟩ := rfl

theorem cleanup_boundary (o : Bool) (r : List (Cell A D)) :
    preprocess ⟨true, [], .cleanup, r, o⟩ =
      preprocess ⟨true, [], .raw, r, o⟩ := rfl

theorem raw_slide_step_grade (a o : Bool) (l r : List (Cell A D)) (x : A) :
    (Sector.mk a l .raw (anchor x :: r) o).grade =
      (Sector.mk a (anchor x :: l) .raw r o).grade := by
  simp [Sector.grade, cellsGrade, cellGrade, anchor]
  omega

theorem quota_step_grade (a o : Bool) (l r : List (Cell A D)) :
    (Sector.mk a (workspace :: l) .quota (cutD :: r) o).grade =
      (Sector.mk a l .quota (cutD :: r) o).grade := by
  simp [Sector.grade, cellsGrade, cellGrade, workspace]

theorem merge_step_grade (a o : Bool) (l r : List (Cell A D)) :
    (Sector.mk a (cutC :: l) .quota (cutD :: r) o).grade =
      (Sector.mk a l .raw [] true).grade +
        (Sector.mk true [] .raw r o).grade := by
  simp [Sector.grade, cellsGrade, cellGrade, cutC, cutD]
  omega

theorem cleanup_cell_step_grade (a o : Bool) (b : Cell A D)
    (l r : List (Cell A D)) :
    (Sector.mk a l .cleanup (emit b ++ r) o).grade ≤
      (Sector.mk a (b :: l) .cleanup r o).grade := by
  have h := emit_grade b
  simp only [Sector.grade, cellsGrade, cellsGrade_append]
  omega

theorem cleanup_boundary_step_grade (o : Bool) (r : List (Cell A D)) :
    (Sector.mk true [] .raw r o).grade =
      (Sector.mk true [] .cleanup r o).grade := rfl

end CompilerPreprocess
