import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.LinearAlgebra.Matrix.Trace

namespace TransferAudit

universe u v w z

variable {Site : Type u} [Fintype Site] [DecidableEq Site]
variable {Local : Type v} [Fintype Local] [DecidableEq Local]
variable {R : Type w} [CommSemiring R]

def tensorMatrix (A : Site -> Matrix Local Local R) :
    Matrix (Site -> Local) (Site -> Local) R :=
  fun x y => Finset.univ.prod (fun i => A i (x i) (y i))

theorem tensorMatrix_mul (A B : Site -> Matrix Local Local R) :
    tensorMatrix (fun i => A i * B i) = tensorMatrix A * tensorMatrix B := by
  ext x y
  simp only [tensorMatrix, Matrix.mul_apply]
  rw [Fintype.prod_sum]
  simp only [Finset.prod_mul_distrib]

theorem tensorMatrix_one :
    tensorMatrix (fun _ : Site => (1 : Matrix Local Local R)) = 1 := by
  ext x y
  by_cases h : x = y
  · subst y
    simp [tensorMatrix]
  · have witness : Exists (fun i => Not (x i = y i)) := by
      by_contra hn
      push Not at hn
      exact h (funext hn)
    obtain ⟨i, hi⟩ := witness
    simp only [tensorMatrix, Matrix.one_apply, if_neg h]
    apply Finset.prod_eq_zero (Finset.mem_univ i)
    exact if_neg hi

theorem trace_tensorMatrix (A : Site -> Matrix Local Local R) :
    Matrix.trace (tensorMatrix A) =
      Finset.univ.prod (fun i => Matrix.trace (A i)) := by
  simp only [Matrix.trace, Matrix.diag_apply, tensorMatrix]
  exact (Fintype.prod_sum (fun i j => A i j j)).symm

theorem tensorMatrix_word {Event : Type z} (events : List Event)
    (A : Event -> Site -> Matrix Local Local R) :
    (events.map (fun e => tensorMatrix (A e))).prod =
      tensorMatrix (fun i => (events.map (fun e => A e i)).prod) := by
  induction events with
  | nil => exact tensorMatrix_one.symm
  | cons e events ih =>
      simp only [List.map_cons, List.prod_cons]
      rw [ih, <- tensorMatrix_mul]

theorem trace_tensorMatrix_word {Event : Type z} (events : List Event)
    (A : Event -> Site -> Matrix Local Local R) :
    Matrix.trace ((events.map (fun e => tensorMatrix (A e))).prod) =
      Finset.univ.prod
        (fun i => Matrix.trace ((events.map (fun e => A e i)).prod)) := by
  rw [tensorMatrix_word, trace_tensorMatrix]

theorem prod_filter_identity {Event : Type z} (events : List Event)
    (active : Event -> Bool) (A : Event -> Matrix Local Local R) :
    (events.map (fun e => if active e then A e else 1)).prod =
      ((events.filter active).map A).prod := by
  induction events with
  | nil => rfl
  | cons e events ih =>
      cases h : active e <;> simp [h, ih]

theorem trace_supported_word {Event : Type z} (events : List Event)
    (active : Event -> Site -> Bool)
    (A : Event -> Site -> Matrix Local Local R) :
    Matrix.trace
        ((events.map
          (fun e => tensorMatrix (fun i => if active e i then A e i else 1))).prod) =
      Finset.univ.prod
        (fun i => Matrix.trace
          (((events.filter (fun e => active e i)).map (fun e => A e i)).prod)) := by
  rw [trace_tensorMatrix_word]
  apply Finset.prod_congr rfl
  intro i _
  rw [prod_filter_identity]

end TransferAudit
