import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Topology.DenseEmbedding

noncomputable section

open scoped InnerProduct

namespace OperatorSquare

variable {H1 H2 H3 H4 : Type*}
  [NormedAddCommGroup H1] [InnerProductSpace ℂ H1] [CompleteSpace H1]
  [NormedAddCommGroup H2] [InnerProductSpace ℂ H2] [CompleteSpace H2]
  [NormedAddCommGroup H3] [InnerProductSpace ℂ H3] [CompleteSpace H3]
  [NormedAddCommGroup H4] [InnerProductSpace ℂ H4] [CompleteSpace H4]

theorem rectangle_squares
    (F : H2 →L[ℂ] H1) (G : H4 →L[ℂ] H3)
    (K : H3 →L[ℂ] H1) (N : H4 →L[ℂ] H2)
    (h1 : F ∘L N = K ∘L G)
    (h2 : F† ∘L K = N ∘L G†) :
    ((K ∘L K†) ∘L F = F ∘L (N ∘L N†)) ∧
    ((K† ∘L K) ∘L G = G ∘L (N† ∘L N)) ∧
    ((F† ∘L F) ∘L N = N ∘L (G† ∘L G)) ∧
    ((F ∘L F†) ∘L K = K ∘L (G ∘L G†)) := by
  have h2star : K† ∘L F = G ∘L N† := by
    simpa only [ContinuousLinearMap.adjoint_comp, ContinuousLinearMap.adjoint_adjoint]
      using congrArg (fun T => T†) h2
  refine ⟨?_, ?_, ?_, ?_⟩
  · calc
      (K ∘L K†) ∘L F = K ∘L (K† ∘L F) := by
        simp only [ContinuousLinearMap.comp_assoc]
      _ = K ∘L (G ∘L N†) := by rw [h2star]
      _ = (K ∘L G) ∘L N† := by simp only [ContinuousLinearMap.comp_assoc]
      _ = (F ∘L N) ∘L N† := by rw [h1]
      _ = F ∘L (N ∘L N†) := by simp only [ContinuousLinearMap.comp_assoc]
  · calc
      (K† ∘L K) ∘L G = K† ∘L (K ∘L G) := by
        simp only [ContinuousLinearMap.comp_assoc]
      _ = K† ∘L (F ∘L N) := by rw [h1]
      _ = (K† ∘L F) ∘L N := by simp only [ContinuousLinearMap.comp_assoc]
      _ = (G ∘L N†) ∘L N := by rw [h2star]
      _ = G ∘L (N† ∘L N) := by simp only [ContinuousLinearMap.comp_assoc]
  · calc
      (F† ∘L F) ∘L N = F† ∘L (F ∘L N) := by
        simp only [ContinuousLinearMap.comp_assoc]
      _ = F† ∘L (K ∘L G) := by rw [h1]
      _ = (F† ∘L K) ∘L G := by simp only [ContinuousLinearMap.comp_assoc]
      _ = (N ∘L G†) ∘L G := by rw [h2]
      _ = N ∘L (G† ∘L G) := by simp only [ContinuousLinearMap.comp_assoc]
  · calc
      (F ∘L F†) ∘L K = F ∘L (F† ∘L K) := by
        simp only [ContinuousLinearMap.comp_assoc]
      _ = F ∘L (N ∘L G†) := by rw [h2]
      _ = (F ∘L N) ∘L G† := by simp only [ContinuousLinearMap.comp_assoc]
      _ = (K ∘L G) ∘L G† := by rw [h1]
      _ = K ∘L (G ∘L G†) := by simp only [ContinuousLinearMap.comp_assoc]

theorem fixed_target_squares {X C D : Type*} [Nonempty D]
    (F : X → H2 →L[ℂ] H1) (K : C → H3 →L[ℂ] H1)
    (N : D → H4 →L[ℂ] H2)
    (htotal : Dense (Submodule.span ℂ {v : H1 | ∃ x w, F x w = v} : Set H1))
    (heq : ∀ c x d,
      (K c ∘L (K c)†) ∘L F x = F x ∘L (N d ∘L (N d)†)) :
    ∀ c c', K c ∘L (K c)† = K c' ∘L (K c')† := by
  classical
  let d : D := Classical.choice inferInstance
  intro c c'
  apply ContinuousLinearMap.ext_on htotal
  rintro v ⟨x, w, rfl⟩
  calc
    (K c ∘L (K c)†) (F x w)
        = (F x ∘L (N d ∘L (N d)†)) w :=
      congrArg (fun T : H2 →L[ℂ] H1 => T w) (heq c x d)
    _ = (K c' ∘L (K c')†) (F x w) :=
      (congrArg (fun T : H2 →L[ℂ] H1 => T w) (heq c' x d)).symm

theorem total_adjoint_fixed_square_injective {I : Type*}
    (F : I → H1 →L[ℂ] H2) (S : H1 →L[ℂ] H1)
    (hsquare : ∀ i, (F i)† ∘L F i = S)
    (htotal : ∀ v : H1,
      (∀ i w, inner ℂ (((F i)†) w) v = 0) → v = 0) :
    Function.Injective S := by
  intro u v huv
  have hS : S (u - v) = 0 := by simp [map_sub, huv]
  have hzero : u - v = 0 := by
    apply htotal (u - v)
    intro i w
    have hmem : u - v ∈ ((F i)† ∘L F i).ker := by
      change ((F i)† ∘L F i) (u - v) = 0
      rw [hsquare i]
      exact hS
    rw [ContinuousLinearMap.ker_adjoint_comp_self] at hmem
    change F i (u - v) = 0 at hmem
    rw [ContinuousLinearMap.adjoint_inner_left, hmem, inner_zero_right]
  exact sub_eq_zero.mp hzero

theorem cancel_dense_range
    (A : H1 →L[ℂ] H2) (S T : H2 →L[ℂ] H3)
    (hA : DenseRange A) (heq : S ∘L A = T ∘L A) : S = T := by
  have hfun : (fun x => S x) = (fun x => T x) :=
    hA.equalizer S.continuous T.continuous (by
      funext x
      exact congrArg (fun Q : H1 →L[ℂ] H3 => Q x) heq)
  ext x
  exact congrFun hfun x

theorem contraction_projection
    (C : H2 →L[ℂ] H3 →L[ℂ] H1)
    (P0 : H1 →L[ℂ] H1) (P1 : H2 →L[ℂ] H2) (P2 : H3 →L[ℂ] H3)
    (hP2 : ∀ h, P2 (P2 h) = P2 h)
    (hleft : ∀ g h, P0 (C g h) = C g (P2 h))
    (hright : ∀ g h, P0 (C g h) = C (P1 g) h) :
    ∀ g h, P0 (C g h) = C (P1 g) (P2 h) := by
  intro g h
  calc
    P0 (C g h) = C g (P2 h) := hleft g h
    _ = P0 (C g (P2 h)) := by
      have heq := hleft g (P2 h)
      rw [hP2] at heq
      exact heq.symm
    _ = C (P1 g) (P2 h) := hright g (P2 h)

end OperatorSquare
