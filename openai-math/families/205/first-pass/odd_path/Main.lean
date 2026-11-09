import Mathlib

set_option maxRecDepth 100000
set_option maxHeartbeats 0

namespace OddPath

abbrev Bit := Fin 2
abbrev Tag := Fin 4
abbrev Column := Fin 4
abbrev State := Fin 8
abbrev Mat := Matrix Bit Bit ℤ
abbrev Vec := Bit → ℤ

def mat (a b c d : ℤ) : Mat := !![a, b; c, d]
def J : Mat := mat 0 1 (-1) 0
def Q : Mat := mat 1 1 1 2
def Qinv : Mat := mat 2 (-1) (-1) 1

def original (i : Tag) : Mat :=
  match i.val with
  | 0 => 1
  | 1 => mat 1 0 0 (-1)
  | 2 => mat 0 1 1 0
  | _ => J

def test (i : Tag) : Mat :=
  match i.val with
  | 0 => 1
  | 1 => mat 3 (-2) 4 (-3)
  | 2 => mat 1 0 3 (-1)
  | _ => mat (-3) 2 (-5) 3

def adj (X : Mat) : Mat :=
  mat (X 1 1) (-X 0 1) (-X 1 0) (X 0 0)

theorem conjugator_inverse : Q * Qinv = 1 ∧ Qinv * Q = 1 := by decide

theorem test_is_conjugate : ∀ i : Tag, test i = Q * original i * Qinv := by decide

theorem adjugate_bridge (X : Mat) : J * X.transpose * J = -adj X := by
  ext a b
  fin_cases a <;> fin_cases b <;>
    simp [J, adj, mat, Matrix.mul_apply, Matrix.vecMul, dotProduct, Fin.sum_univ_two]

def basisCoordinates : Matrix (Fin 4) (Fin 4) ℤ := fun i j =>
  match i.val with
  | 0 => test j 0 0
  | 1 => test j 0 1
  | 2 => test j 1 0
  | _ => test j 1 1

theorem test_basis_determinant : Matrix.det basisCoordinates = 4 := by
  decide

def length (r : Column) : ℕ := r.val + 1
def columnFactor (r : Column) : ℤ := (length r).factorial
def advance (p : Bool) (n : ℕ) : Bool := if n % 2 = 0 then p else !p

def words (r : Column) : List (List Tag) :=
  ((List.finRange 4).take (length r)).permutations'

def inversions : List Tag → ℕ
  | [] => 0
  | x :: xs => (xs.filter (fun y => y.val < x.val)).length + inversions xs

def sign (w : List Tag) : ℤ := if inversions w % 2 = 0 then 1 else -1

theorem column_words_length :
    ∀ r : Column, ∀ w ∈ words r, w.length = length r := by decide

theorem column_words_count :
    ∀ r : Column, (words r).length = (length r).factorial := by decide

theorem column_words_membership (r : Column) (w : List Tag) :
    w ∈ words r ↔ w.Perm ((List.finRange 4).take (length r)) :=
  List.mem_permutations'

theorem column_words_nodup : ∀ r : Column, (words r).Nodup := by decide

def oriented (p : Bool) (X : Mat) : Mat := if p then X.transpose else X
def scale (c : ℤ) (A : Mat) : Mat := fun a b => c * A a b
def action (A : Mat) (f : Vec) (a : Bit) : ℤ := ∑ b : Bit, A a b * f b

-- Each step sums the two physical letter indices and their alternating J edge.
def raw (p : Bool) : List Tag → Vec → Vec
  | [], f => f
  | x :: xs, f => fun a =>
      ∑ b : Bit, ∑ c : Bit,
        oriented p (test x) a b * J b c * raw (!p) xs f c

def wordMatrix (p : Bool) : List Tag → Mat
  | [] => 1
  | x :: xs => (oriented p (test x) * J) * wordMatrix (!p) xs

def altTensor (p : Bool) : List (List Tag) → Vec → Vec
  | [], _ => fun _ => 0
  | w :: ws, f => fun a => sign w * raw p w f a + altTensor p ws f a

def altMatrix (p : Bool) : List (List Tag) → Mat
  | [] => 0
  | w :: ws => scale (sign w) (wordMatrix p w) + altMatrix p ws

def columnMatrix (p : Bool) (r : Column) : Mat := altMatrix p (words r)

def tensor (p : Bool) : List Column → Vec → Vec
  | [], f => f
  | r :: rs, f => altTensor p (words r) (tensor (advance p (length r)) rs f)

def matrixRun (p : Bool) : List Column → Mat
  | [] => 1
  | r :: rs => columnMatrix p r * matrixRun (advance p (length r)) rs

def terminal (b : Bit) : ℤ := if b = 1 then 1 else 0
def contraction (rs : List Column) : ℤ := tensor false rs terminal 0

theorem action_mul (A B : Mat) (f : Vec) (a : Bit) :
    action (A * B) f a = action A (action B f) a := by
  simp [action, Matrix.mul_apply, Fin.sum_univ_two]
  ring

theorem raw_eq_matrix (p : Bool) (w : List Tag) (f : Vec) (a : Bit) :
    raw p w f a = action (wordMatrix p w) f a := by
  induction w generalizing p a with
  | nil =>
      fin_cases a <;> simp [raw, wordMatrix, action, Matrix.one_apply]
  | cons x xs ih =>
      simp only [raw, wordMatrix]
      simp_rw [ih]
      simp [action, Matrix.mul_apply, Fin.sum_univ_two]
      ring

theorem altTensor_eq_matrix (p : Bool) (ws : List (List Tag)) (f : Vec) (a : Bit) :
    altTensor p ws f a = action (altMatrix p ws) f a := by
  induction ws with
  | nil => simp [altTensor, altMatrix, action]
  | cons w ws ih =>
      simp only [altTensor, altMatrix]
      rw [raw_eq_matrix, ih]
      simp [action, scale, Fin.sum_univ_two]
      ring

theorem tensor_eq_matrix (p : Bool) (rs : List Column) (f : Vec) (a : Bit) :
    tensor p rs f a = action (matrixRun p rs) f a := by
  induction rs generalizing p a with
  | nil =>
      fin_cases a <;> simp [tensor, matrixRun, action, Matrix.one_apply]
  | cons r rs ih =>
      change altTensor p (words r) (tensor (advance p (length r)) rs f) a =
        action (columnMatrix p r * matrixRun (advance p (length r)) rs) f a
      rw [altTensor_eq_matrix, action_mul]
      exact congrArg (fun h => action (columnMatrix p r) h a)
        (funext fun b => ih (advance p (length r)) b)

theorem terminal_edge (b : Bit) : J b 1 = if b = 0 then 1 else 0 := by
  fin_cases b <;> decide

theorem single_position_endpoint (x : Tag) (a : Bit) :
    raw false [x] terminal a = test x a 0 := by
  simp [raw, oriented, terminal, J, mat, Fin.sum_univ_two]

theorem actual_contraction_bridge (rs : List Column) :
    contraction rs = matrixRun false rs 0 1 := by
  rw [contraction, tensor_eq_matrix]
  simp [action, terminal]

def normalized (p : Bool) (r : Column) : Mat :=
  if p then
    match r.val with
    | 0 => J
    | 1 => mat 3 4 (-2) (-3)
    | 2 => mat (-5) 3 3 (-2)
    | _ => 1
  else
    match r.val with
    | 0 => J
    | 1 => test 1
    | 2 => mat (-2) (-3) (-3) (-5)
    | _ => -1

theorem column_matrix_table :
    ∀ (p : Bool) (r : Column),
      columnMatrix p r = scale (columnFactor r) (normalized p r) := by
  decide

def signedBasis (g : State) : Mat :=
  match g.val with
  | 0 => test 0
  | 1 => test 1
  | 2 => test 2
  | 3 => test 3
  | 4 => -test 0
  | 5 => -test 1
  | 6 => -test 2
  | _ => -test 3

def stateMatrix (p : Bool) (g : State) : Mat :=
  signedBasis g * if p then J else 1

theorem normalized_state_closed :
    ∀ (p : Bool) (g : State) (r : Column), ∃ h : State,
      stateMatrix p g * normalized p r = stateMatrix (advance p (length r)) h := by
  decide

theorem scale_mul (c : ℤ) (A B : Mat) :
    scale c A * B = scale c (A * B) := by
  ext a b
  simp [scale, Matrix.mul_apply, Fin.sum_univ_two]
  ring

theorem mul_scale (c : ℤ) (A B : Mat) :
    A * scale c B = scale c (A * B) := by
  ext a b
  simp [scale, Matrix.mul_apply, Fin.sum_univ_two]
  ring

theorem scale_scale (c d : ℤ) (A : Mat) :
    scale c (scale d A) = scale (c * d) A := by
  ext a b
  simp [scale, mul_assoc]

theorem state_step (p : Bool) (g : State) (r : Column) :
    ∃ h : State, stateMatrix p g * columnMatrix p r =
      scale (columnFactor r) (stateMatrix (advance p (length r)) h) := by
  obtain ⟨h, hh⟩ := normalized_state_closed p g r
  refine ⟨h, ?_⟩
  rw [column_matrix_table, mul_scale, hh]

def total : List Column → ℕ
  | [] => 0
  | r :: rs => length r + total rs

def weight : List Column → ℤ
  | [] => 1
  | r :: rs => columnFactor r * weight rs

def finish (p : Bool) : List Column → Bool
  | [] => p
  | r :: rs => finish (advance p (length r)) rs

theorem advance_add (p : Bool) (a b : ℕ) :
    advance (advance p a) b = advance p (a + b) := by
  have ha : a % 2 < 2 := Nat.mod_lt a (by decide)
  have hb : b % 2 < 2 := Nat.mod_lt b (by decide)
  cases p <;>
    by_cases h₁ : a % 2 = 0 <;> by_cases h₂ : b % 2 = 0 <;>
    simp [advance, Nat.add_mod, h₁, h₂] <;> omega

theorem finish_eq (p : Bool) (rs : List Column) :
    finish p rs = advance p (total rs) := by
  induction rs generalizing p with
  | nil => simp [finish, total, advance]
  | cons r rs ih =>
      simp only [finish, total]
      rw [ih, advance_add]

theorem all_length_state (p : Bool) (g : State) (rs : List Column) :
    ∃ h : State, stateMatrix p g * matrixRun p rs =
      scale (weight rs) (stateMatrix (finish p rs) h) := by
  induction rs generalizing p g with
  | nil =>
      refine ⟨g, ?_⟩
      change stateMatrix p g * 1 = scale 1 (stateMatrix p g)
      rw [Matrix.mul_one]
      ext a b
      simp [scale]
  | cons r rs ih =>
      obtain ⟨h, hh⟩ := state_step p g r
      obtain ⟨z, hz⟩ := ih (advance p (length r)) h
      refine ⟨z, ?_⟩
      simp only [matrixRun, weight, finish]
      rw [← Matrix.mul_assoc, hh, scale_mul, hz, scale_scale]

theorem initial_state : stateMatrix false 0 = 1 := by decide

theorem odd_state_endpoint :
    ∀ g : State, stateMatrix true g 0 1 = -3 ∨ stateMatrix true g 0 1 = -1 ∨
      stateMatrix true g 0 1 = 1 ∨ stateMatrix true g 0 1 = 3 := by decide

theorem column_factor_positive : ∀ r : Column, 0 < columnFactor r := by decide

theorem weight_positive (rs : List Column) : 0 < weight rs := by
  induction rs with
  | nil => decide
  | cons r rs ih =>
      exact mul_pos (column_factor_positive r) ih

theorem uniform_contraction (rs : List Column) (odd : total rs % 2 = 1) :
    ∃ ε : ℤ, (ε = -3 ∨ ε = -1 ∨ ε = 1 ∨ ε = 3) ∧
      contraction rs = ε * weight rs := by
  obtain ⟨h, hh⟩ := all_length_state false 0 rs
  have hf : finish false rs = true := by
    rw [finish_eq]
    simp [advance, odd]
  rw [initial_state, Matrix.one_mul, hf] at hh
  refine ⟨stateMatrix true h 0 1, odd_state_endpoint h, ?_⟩
  rw [actual_contraction_bridge, hh]
  simp [scale, mul_comm]

theorem uniform_nonzero (rs : List Column) (odd : total rs % 2 = 1) :
    contraction rs ≠ 0 := by
  obtain ⟨ε, he, hc⟩ := uniform_contraction rs odd
  have hn : ε ≠ 0 := by rcases he with h | h | h | h <;> omega
  rw [hc]
  exact mul_ne_zero hn (ne_of_gt (weight_positive rs))

end OddPath

#print axioms OddPath.uniform_contraction
#print axioms OddPath.uniform_nonzero
