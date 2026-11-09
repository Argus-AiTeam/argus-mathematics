import SpectralCubic
import Hessian

open scoped ComplexConjugate Matrix MatrixOrder ComplexOrder Matrix.Norms.L2Operator
open Matrix Finset WithLp

noncomputable section

namespace SharedTraceAssembly

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

theorem cubicSum_bound_unsorted (m : ι → ℝ)
    (D : Matrix ι ι ℂ) (hD : D.IsHermitian) (c : ℝ) (hc : 0 ≤ c)
    (hop : ∀ x : EuclideanSpace ℂ ι,
      ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D x‖ ≤ c * ‖x‖)
    (s : Finset ι) :
    ‖SharedTraceCubic.cubicSum m D s‖ ≤ 5 * c * SharedTraceCubic.cost m D s := by
  classical
  refine Finset.strongInductionOn s ?_
  intro s ih
  by_cases hs : s.Nonempty
  · obtain ⟨a, ha, hmax⟩ := s.exists_max_image (fun i => |m i|) hs
    let t := s.erase a
    have hat : a ∉ t := by simp [t]
    have hst : insert a t = s := by simpa [t] using insert_erase ha
    have hit := ih t (erase_ssubset ha)
    have hord : ∀ j ∈ t, |m j| ≤ |m a| :=
      fun j hj => hmax j (mem_of_mem_erase hj)
    have hi := SharedTraceCubic.increment_bound m D hD c hc hop t a hord
    rw [← hst, SharedTraceCubic.cubicSum_insert m D t a hat]
    calc
      ‖SharedTraceCubic.cubicSum m D t + SharedTraceCubic.cubicEntry m D a a a +
          3 * (∑ j ∈ t, SharedTraceCubic.cubicEntry m D a a j) +
          3 * (∑ j ∈ t, ∑ k ∈ t, SharedTraceCubic.cubicEntry m D a j k)‖ ≤
          ‖SharedTraceCubic.cubicSum m D t‖ + ‖SharedTraceCubic.cubicEntry m D a a a‖ +
            ‖3 * (∑ j ∈ t, SharedTraceCubic.cubicEntry m D a a j)‖ +
            ‖3 * (∑ j ∈ t, ∑ k ∈ t, SharedTraceCubic.cubicEntry m D a j k)‖ :=
        (norm_add_le _ _).trans (add_le_add
          ((norm_add_le _ _).trans (add_le_add (norm_add_le _ _) le_rfl)) le_rfl)
      _ = ‖SharedTraceCubic.cubicSum m D t‖ +
          (‖SharedTraceCubic.cubicEntry m D a a a‖ +
            3 * ‖∑ j ∈ t, SharedTraceCubic.cubicEntry m D a a j‖ +
            3 * ‖∑ j ∈ t, ∑ k ∈ t, SharedTraceCubic.cubicEntry m D a j k‖) := by
        norm_num [norm_mul]
        ring
      _ ≤ 5 * c * SharedTraceCubic.cost m D t +
          5 * c * (SharedTraceCubic.weight m D a a +
            2 * ∑ j ∈ t, SharedTraceCubic.weight m D a j) := add_le_add hit hi
      _ = 5 * c * SharedTraceCubic.cost m D (insert a t) := by
        rw [SharedTraceCubic.cost_insert m D hD t a hat]
        ring
  · have he : s = ∅ := not_nonempty_iff_eq_empty.mp hs
    simp [he, SharedTraceCubic.cubicSum, SharedTraceCubic.cost]

def realDiagonal (m : ι → ℝ) : Matrix ι ι ℂ := diagonal fun i => (m i : ℂ)

lemma realDiagonal_hermitian (m : ι → ℝ) : (realDiagonal m).IsHermitian := by
  change (realDiagonal m)ᴴ = realDiagonal m
  simp [realDiagonal]

lemma realDiagonal_mul (m r : ι → ℝ) :
    realDiagonal m * realDiagonal r = realDiagonal (fun i => m i * r i) := by
  simp [realDiagonal, Matrix.diagonal_mul_diagonal]

lemma diagonal_square_pos (m : ι → ℝ) :
    (realDiagonal m * realDiagonal m).PosSemidef := by
  simpa only [(realDiagonal_hermitian m).eq] using
    Matrix.posSemidef_conjTranspose_mul_self (realDiagonal m)

lemma sqrt_diagonal_square (m : ι → ℝ) :
    CFC.sqrt (realDiagonal m * realDiagonal m) = realDiagonal (fun i => |m i|) := by
  have hp : (realDiagonal fun i => |m i|).PosSemidef := by
    apply Matrix.posSemidef_diagonal_iff.mpr
    intro i
    exact_mod_cast abs_nonneg (m i)
  apply (CFC.sqrt_eq_iff _ _ (diagonal_square_pos m).nonneg hp.nonneg).mpr
  rw [realDiagonal_mul, realDiagonal_mul]
  congr 1
  funext i
  exact abs_mul_abs_self _

lemma diagonal_sandwich_entries (m : ι → ℝ) (D : Matrix ι ι ℂ) (i j : ι) :
    (realDiagonal m * D * realDiagonal m) i j =
      (m i : ℂ) * D i j * (m j : ℂ) := by
  simp [realDiagonal, Matrix.diagonal_mul, Matrix.mul_diagonal]

theorem b_diagonal_square (m : ι → ℝ) (D : Matrix ι ι ℂ) :
    SharedTraceHessian.b (diagonal_square_pos m) (realDiagonal m * D * realDiagonal m) =
      (3 / 2 : ℝ) * SharedTraceCubic.cost m D univ := by
  let K := realDiagonal m * D * realDiagonal m
  let Y : Matrix ι ι ℂ := fun i j => K i j / ((|m i| + |m j| : ℝ) : ℂ)
  have hs : SharedTraceHessian.Supported (realDiagonal m * realDiagonal m) K := by
    simpa only [(realDiagonal_hermitian m).eq] using
      SharedTraceHessian.supported_gram (realDiagonal m) D
  have hy : SharedTraceHessian.lyap (CFC.sqrt (realDiagonal m * realDiagonal m)) Y = K := by
    rw [sqrt_diagonal_square]
    ext i j
    rw [realDiagonal, SharedTraceHessian.lyap_diagonal]
    change ((|m i| + |m j| : ℝ) : ℂ) *
      (K i j / ((|m i| + |m j| : ℝ) : ℂ)) = K i j
    by_cases hz : |m i| + |m j| = 0
    · have hi : m i = 0 := abs_eq_zero.mp (by nlinarith [abs_nonneg (m i), abs_nonneg (m j)])
      simp [K, diagonal_sandwich_entries, hi]
    · exact mul_div_cancel₀ _ (by exact_mod_cast hz)
  rw [SharedTraceHessian.b_eq_of_solution (diagonal_square_pos m) hs hy,
    SharedTraceHessian.pairing_entries]
  congr 1
  unfold SharedTraceCubic.cost
  apply Finset.sum_congr rfl
  intro i hi
  apply Finset.sum_congr rfl
  intro j hj
  change (star (K i j) * (K i j / ((|m i| + |m j| : ℝ) : ℂ))).re = _
  rw [← mul_div_assoc, show star (K i j) * K i j = (Complex.normSq (K i j) : ℂ) from
    Complex.normSq_eq_conj_mul_self.symm]
  simp only [Complex.div_ofReal_re, Complex.ofReal_re]
  dsimp [K]
  rw [diagonal_sandwich_entries]
  simp only [SharedTraceCubic.weight, Complex.normSq_mul, Complex.normSq_ofReal]
  simp only [← pow_two, sq_abs]
  ring

lemma norm_rotate (U : Matrix.unitaryGroup ι ℂ) (D : Matrix ι ι ℂ) :
    ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) (SharedTraceHessian.rotate U D)‖ =
      ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D‖ := by
  simp only [Matrix.l2_opNorm_toEuclideanCLM, SharedTraceHessian.rotate_eq]
  change ‖(U : Matrix ι ι ℂ) * D * (star U : Matrix ι ι ℂ)‖ = ‖D‖
  exact (CStarRing.norm_mul_coe_unitary ((U : Matrix ι ι ℂ) * D) (star U)).trans
    (CStarRing.norm_coe_unitary_mul U D)

lemma hermitian_rotate (U : Matrix.unitaryGroup ι ℂ)
    {D : Matrix ι ι ℂ} (hD : D.IsHermitian) :
    (SharedTraceHessian.rotate U D).IsHermitian := by
  change (SharedTraceHessian.rotate U D)ᴴ = _
  simp [SharedTraceHessian.rotate_eq, hD.eq, Matrix.mul_assoc,
    Matrix.star_eq_conjTranspose]

theorem hermitian_cubic_bound (M D : Matrix ι ι ℂ)
    (hM : M.IsHermitian) (hD : D.IsHermitian) :
    ‖Matrix.trace ((D * M) ^ 3)‖ ≤
      (10 / 3 : ℝ) * ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D‖ *
        SharedTraceHessian.b
          (show (M * M).PosSemidef by
            simpa only [hM.eq] using Matrix.posSemidef_conjTranspose_mul_self M)
          (M * D * M) := by
  let U := hM.eigenvectorUnitary
  let m := hM.eigenvalues
  let D' := SharedTraceHessian.rotate (star U) D
  have hdiag : SharedTraceHessian.rotate (star U) M = realDiagonal m := by
    exact hM.conjStarAlgAut_star_eigenvectorUnitary
  have hD' : D'.IsHermitian := hermitian_rotate (star U) hD
  have hcub := cubicSum_bound_unsorted m D' hD'
    ‖Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D'‖
    (norm_nonneg _) (ContinuousLinearMap.le_opNorm _) univ
  rw [← SharedTraceCubic.trace_cube_diagonal] at hcub
  have htr : Matrix.trace ((D' * realDiagonal m) ^ 3) =
      Matrix.trace ((D * M) ^ 3) := by
    rw [← hdiag]
    change Matrix.trace (((Unitary.conjStarAlgAut ℂ _ (star U)) D *
      (Unitary.conjStarAlgAut ℂ _ (star U)) M) ^ 3) = _
    rw [← map_mul, ← map_pow]
    exact SharedTraceHessian.trace_rotate (star U) _
  have hp : (M * M).PosSemidef := by
    simpa only [hM.eq] using Matrix.posSemidef_conjTranspose_mul_self M
  have hs : SharedTraceHessian.Supported (M * M) (M * D * M) := by
    simpa only [hM.eq] using SharedTraceHessian.supported_gram M D
  have hb := SharedTraceHessian.b_unitary (star U) hp hs
  have hrotmul (X Y : Matrix ι ι ℂ) :
      SharedTraceHessian.rotate (star U) (X * Y) =
        SharedTraceHessian.rotate (star U) X * SharedTraceHessian.rotate (star U) Y :=
    map_mul (Unitary.conjStarAlgAut ℂ _ (star U)) X Y
  simp only [hrotmul, hdiag] at hb
  have hb' : SharedTraceHessian.b (diagonal_square_pos m)
      (realDiagonal m * D' * realDiagonal m) = SharedTraceHessian.b hp (M * D * M) := hb
  rw [b_diagonal_square] at hb'
  rw [show Matrix.diagonal (fun i => (m i : ℂ)) = realDiagonal m from rfl, htr,
    norm_rotate (star U) D] at hcub
  nlinarith [norm_nonneg (Matrix.toEuclideanCLM (n := ι) (𝕜 := ℂ) D)]

end SharedTraceAssembly
