#!/usr/bin/env python3
"""Replay the exact upstream proof closure; never certify a partial build."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
from fractions import Fraction
from urllib.request import urlopen


ROOT = Path(__file__).resolve().parent
PROJECT = ROOT.parent.parent
COMMIT = "4eaee87548250b2682affda7d05d947c05554bae"
ENTRY = "OAI.Analysis.Kaplansky.Main"
UPSTREAM = ROOT / "upstream"
BUILD = ROOT / "olean"
PORTED = ROOT / "ported"
MATHLIB = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
CERTIFICATE = ROOT / "exact_certificate.json"
PERMITTED_AXIOMS = {"propext", "Quot.sound", "Classical.choice"}
COMPATIBILITY = {
    "OAI.Algebra.OrderedStates.RationalCone": [
        ("rwa [← s.smul_mem_iff (neg_pos.2 hr)",
         "change -(r⁻¹ • x) - y ∈ s.toConvexCone\n"
         "        rwa [← s.toConvexCone.smul_mem_iff (neg_pos.2 hr)"),
        ("rwa [← s.smul_mem_iff hr",
         "change r⁻¹ • x + y ∈ s.toConvexCone\n"
         "        rwa [← s.toConvexCone.smul_mem_iff hr"),
    ],
    "OAI.Algebra.OrderedStates.Semigroup": [
        ("import Mathlib.Basic.Real.Basic", "import Mathlib.Data.Real.Basic")
    ],
    "OAI.Geometry.ComplexBundle.ZeroSign": [
        ("import Mathlib.Basic.Sign.Basic", "import Mathlib.Data.Sign.Basic")
    ],
    "OAI.Analysis.MatrixScaling.Gram": [
        ("import Mathlib.Basic.Complex.BigOperators", "import Mathlib.Data.Complex.BigOperators")
    ],
    "OAI.Geometry.ComplexBundle.Replacement": [
        ("import Mathlib.Basic.Real.Basic", "import Mathlib.Data.Real.Basic")
    ],
    "OAI.Analysis.Quasitrace.Defect": [
        ("import Mathlib.Basic.Complex.Basic", "import Mathlib.Data.Complex.Basic")
    ],
    "OAI.Analysis.Quasitrace.Basic": [
        ("  have := StarAlgebra.isMulCommutative_adjoin ℂ\n"
         "    (fun element helement => (hsa element helement).isStarNormal)\n"
         "    (fun element helement other hother _ => hc element helement other hother)\n"
         "    (by\n"
         "      intro element helement other hother _",
         "  have := StarAlgebra.isMulCommutative_adjoin ℂ hc\n"
         "    (by\n"
         "      intro element helement other hother"),
        ("  let := StarSubalgebra.isMulCommutative_topologicalClosure (StarAlgebra.adjoin ℂ s)",
         "  let := StarSubalgebra.commRingTopologicalClosure (StarAlgebra.adjoin ℂ s)\n"
         "    (fun x y => mul_comm x y)")
    ],
    "OAI.Analysis.Quasitrace.Infiniteness": [
        ("⟨properlyInfinite_map e.toStarAlgHom,properlyInfinite_map e.symm.toStarAlgHom⟩",
         "⟨properlyInfinite_map (StarAlgHomClass.toStarAlgHom e),\n"
         "    properlyInfinite_map (StarAlgHomClass.toStarAlgHom e.symm)⟩")
    ],
    "OAI.Analysis.Cuntz.Quasitrace": [
        ("(gelfandStarTransform B).symm.toStarAlgHom",
         "(StarAlgHomClass.toStarAlgHom ((gelfandStarTransform B).symm))"),
        (":=\n  (map_realPart (spectralCornerHom (A := A) i) a).symm",
         ":= by\n"
         "  simp only [realPart_apply_coe, ← Complex.coe_smul, corner_add, corner_star, corner_smul]"),
        (":=\n  (map_imaginaryPart (spectralCornerHom (A := A) i) a).symm",
         ":= by\n"
         "  simp only [imaginaryPart_apply_coe, ← Complex.coe_smul, corner_sub, corner_star, corner_smul]"),
        ("  simp [corner, entry, CStarMatrix.toOneByOne]\n  rfl",
         "  simp [corner, entry, CStarMatrix.toOneByOne]")
    ],
    "OAI.Analysis.Cuntz.Regularization": [
        ("(CStarMatrix.reindexₐ ℂ A e.symm).toStarAlgHom",
         "StarAlgHomClass.toStarAlgHom (CStarMatrix.reindexₐ ℂ A e.symm)")
    ],
    "OAI.Analysis.Kaplansky.ActualAlgebra": [
        ("(actualDefectAmplificationEquiv m).toStarAlgHom",
         "(StarAlgHomClass.toStarAlgHom (actualDefectAmplificationEquiv m))")
    ],
    "OAI.Analysis.Cuntz.Commutative": [("dite_eq_left", "dif_pos")],
    "OAI.Geometry.ComplexBundle.Hom": [
        ("dite_eq_left", "dif_pos"),
        ("continuousOn_iff_continuous_domRestrict", "continuousOn_iff_continuous_restrict")
    ],
    "OAI.Geometry.ComplexBundle.Grassmann": [("dite_eq_left", "dif_pos")],
    "OAI.Geometry.ComplexBundle.LineStage": [
        ("dite_eq_left", "dif_pos"), ("dite_eq_right", "dif_neg")
    ],
    "OAI.Geometry.ComplexBundle.Complement": [
        ("dite_eq_left", "dif_pos"),
        ("e.symmL_apply y.property", "Trivialization.symmL_apply"),
        ("e.symmL_apply z.val.1.property", "Trivialization.symmL_apply")
    ],
    "OAI.Geometry.BundleTests.Retained": [
        ("dite_eq_left", "dif_pos"), ("dite_eq_right", "dif_neg"),
        ("ite_eq_right", "if_neg"),
        ("      TotalSpace.mk' (EuclideanSpace ℂ (TestBundleSlot m R j.val)) z.proj\n"
         "        (retainedFiberEquiv m R z.proj z.2 a j)) := by",
         "      (show (smoothTestBundleCore m R R j.val (Nat.le_refl R)\n"
         "        (Nat.le_of_lt_succ j.isLt)).TotalSpace from\n"
         "        TotalSpace.mk' (EuclideanSpace ℂ (TestBundleSlot m R j.val)) z.proj\n"
         "          (retainedFiberEquiv m R z.proj z.2 a j))) := by"),
        ("  refine ⟨FiberBundle.continuous_proj _ _,?_⟩\n  intro s\n",
         "  refine ⟨(retainedBundleCore m R).continuous_proj,?_⟩\n  intro s\n")
    ],
    "OAI.Analysis.Quasitrace.Compactness": [
        ("Set.mem_ofPred_eq", "Set.mem_setOf_eq")
    ],
    "OAI.Geometry.ComplexBundle.Avoidance": [
        ("Set.mem_ofPred_eq", "Set.mem_setOf_eq")
    ],
    "OAI.Analysis.MatrixScaling.Critical": [
        ("Set.mem_ofPred_eq", "Set.mem_setOf_eq")
    ],
    "OAI.Geometry.ComplexBundle.GrassmannManifold": [
        ("mem_ofPred_eq", "mem_setOf_eq")
    ],
    "OAI.Geometry.ComplexBundle.OpenIncidence": [
        ("mem_ofPred_eq", "mem_setOf_eq"),
        ("ha.continuousOn.domRestrict",
         "(continuousOn_iff_continuous_restrict.mp ha.continuousOn)")
    ],
    "OAI.Geometry.BundleTests.Normalization": [
        ("mem_ofPred_eq", "mem_setOf_eq")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.ProductCover": [
        ("mem_ofPred_eq", "mem_setOf_eq")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.LineNormalization": [
        ("mem_ofPred_eq", "mem_setOf_eq")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.GraphNormalization": [
        ("mem_ofPred_eq", "mem_setOf_eq")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.Sections": [("ite_eq_right", "if_neg")],
    "OAI.AlgebraicTopology.IntegralHomology.Thom": [("ite_eq_right", "if_neg")],
    "OAI.Geometry.BundleTests.Multiplicities": [("ite_eq_right", "if_neg")],
    "OAI.Geometry.BundleTests.Base": [("ite_eq_right", "if_neg")],
    "OAI.Analysis.MatrixScaling.Bounds": [
        ("ite_eq_left", "if_pos"), ("ite_eq_right", "if_neg"),
        ("Set.ofPred_forall", "Set.setOf_forall")
    ],
    "OAI.Analysis.MatrixScaling.Continuous": [
        ("Set.ofPred_forall", "Set.setOf_forall"),
        ("import Mathlib.Analysis.Matrix.Order",
         "import Mathlib.Analysis.Matrix.Order\n"
         "import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Basic"),
        (":=\n  CFC.continuousOn_sqrt.comp_continuous hP (fun y => (hpos y).posSemidef.nonneg)",
         ":= by\n"
         "  letI : CStarAlgebra (Matrix (Fin d) (Fin d) ℂ) := {}\n"
         "  exact CFC.continuousOn_sqrt.comp_continuous hP (fun y => (hpos y).posSemidef.nonneg)")
    ],
    "OAI.Analysis.MatrixScaling.Canonical": [
        ("continuousOn_iff_continuous_domRestrict", "continuousOn_iff_continuous_restrict")
    ],
    "OAI.Geometry.ComplexBundle.Projection": [
        ("continuousOn_iff_continuous_domRestrict", "continuousOn_iff_continuous_restrict"),
        ("theorem projectionLine_eq_span",
         """theorem eq_span_singleton_of_mem_of_finrank_eq_one
    {K V : Type*} [DivisionRing K] [AddCommGroup V] [Module K V]
    {p : Submodule K V} (hp : Module.finrank K p = 1) {v : V}
    (hv : v ∈ p) (hne : v ≠ 0) : p = Submodule.span K {v} := by
  letI : FiniteDimensional K p := Module.finite_of_finrank_eq_succ hp
  symm
  apply Submodule.eq_of_le_of_finrank_eq
    ((Submodule.span_singleton_le_iff_mem _ _).mpr hv)
  rw [finrank_span_singleton hne, hp]

theorem projectionLine_eq_span""")
    ],
    "OAI.Geometry.ComplexBundle.Frames": [
        ("continuousOn_iff_continuous_domRestrict", "continuousOn_iff_continuous_restrict"),
        ("  apply Matrix.gram_eq_one_iff_orthonormal.mp\n"
         "  rw [metricFrame, gram_frameMul]\n"
         "  exact inverse_sqrt_gram_identity (Matrix.posDef_gram_of_linearIndependent hv)",
         """  have hg : gram ℂ (metricFrame v) = 1 := by
    rw [metricFrame, gram_frameMul]
    exact inverse_sqrt_gram_identity (Matrix.posDef_gram_of_linearIndependent hv)
  apply orthonormal_iff_ite.mpr
  intro i j
  simpa only [gram_apply, Matrix.one_apply] using congrArg (fun G => G i j) hg"""),
        ("simp [bundleChartBasis, bundleChartFrame, hy]",
         "simp [bundleChartBasis, bundleChartFrame, hy, Trivialization.coe_symmₗ]"),
        ("simp [bundleChartFrame, hy, Trivialization.mk_symm]",
         "simp [bundleChartFrame, hy, Trivialization.coe_symmₗ, Trivialization.mk_symm]"),
        ("simp [bundleOrthonormalFrame_eq, hy]",
         "simp [bundleOrthonormalFrame_eq, hy, Trivialization.coe_symmₗ]")
    ],
    "OAI.Geometry.ComplexBundle.Maps": [
        ("continuousOn_iff_continuous_domRestrict", "continuousOn_iff_continuous_restrict"),
        ("simpa [b, bundleChartBasis, bundleChartFrame, hy] using he",
         "simpa [b, bundleChartBasis, bundleChartFrame, hy, Trivialization.coe_symmₗ] using he")
    ],
    "OAI.Geometry.ComplexBundle.Projective": [
        ("continuousOn_iff_continuous_domRestrict", "continuousOn_iff_continuous_restrict"),
        ("  exact continuousOn_const.smul\n",
         "  exact (continuousOn_const : ContinuousOn\n"
         "    (fun _ : projectionSpace (1+k) 1 => (v 0 : ℂ)) (projectionChartSet i)).smul\n")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.ProjectivePuncture": [
        ("continuousOn_iff_continuous_domRestrict", "continuousOn_iff_continuous_restrict"),
        ("import OAI.Geometry.ComplexBundle.GrassmannManifold",
         "import OAI.Geometry.ComplexBundle.GrassmannManifold\n"
         "import OAI.Geometry.ComplexBundle.Projection")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.OpenUnion": [
        ("he.isZero_of_both_isZero hs hi",
         "he.isZero_of_both_zeros (hs.eq_of_src _ _) (hi.eq_of_tgt _ _)")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.Product": [
        ("  let γ : Path a (fun _ => (1 : ℂˣ)) :=\n"
         "    Classical.choice (PathConnectedSpace.joined a (fun _ => (1 : ℂˣ)))",
         "  let γ : Path a (fun _ => (1 : ℂˣ)) :=\n"
         "    Path.pi (fun i => Classical.choice (PathConnectedSpace.joined (a i) (1 : ℂˣ)))")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.Connected": [
        ("simpa [test, a, b, hab, Ne.symm hab] using he'",
         "simpa [test, a, b, hab, Ne.symm hab, Sigma.ι_desc] using he'"),
        ("simp [componentCoefficient]", "simp [componentCoefficient, Sigma.ι_desc]"),
        ("simp [componentCoefficient, h]", "simp [componentCoefficient, h, Sigma.ι_desc]")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.Sphere": [
        ("PiLp.equivOfUnique 2 ℝ (fun _ : Fin 1 => ℝ)",
         "(EuclideanSpace.equiv (Fin 1) ℝ).trans "
         "(ContinuousLinearEquiv.piUnique ℝ (fun _ : Fin 1 => ℝ))"),
        ("h.map e.continuous", "h.map (fun p => p.map e.continuous)"),
        ("hx.map e.symm.continuous", "hx.map (fun p => p.map e.symm.continuous)"),
        ("simpa only [e.symm_apply_apply] using hx.map",
         "simpa only [Joined, a, b, e.symm_apply_apply] using hx.map")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.ProjectiveClass": [
        ("ite_eq_left", "if_pos"), ("ite_eq_right", "if_neg"),
        ("mem_ofPred_eq", "mem_setOf_eq"),
        ("n).isZero_of_both_isZero\n"
         "      hpuncture (projectiveSpaceLocalHomology_isZero (by omega) P n hne)",
         "n).isZero_of_both_zeros\n"
         "      (hpuncture.eq_of_src _ _)\n"
         "      ((projectiveSpaceLocalHomology_isZero (by omega) P n hne).eq_of_tgt _ _)"),
        ("q).isZero_of_both_isZero\n"
         "          hpuncture (projectivePointLocalHomology_isZero L hpos P q (by omega))",
         "q).isZero_of_both_zeros\n"
         "          (hpuncture.eq_of_src _ _)\n"
         "          ((projectivePointLocalHomology_isZero L hpos P q (by omega)).eq_of_tgt _ _)")
    ],
    "OAI.Analysis.Kaplansky.Products": [
        ("omit [∀ i, Nontrivial (A i)] in\n"
         "@[simp] theorem boundedProduct_sum_apply",
         "@[simp] theorem boundedProduct_sum_apply")
    ],
    "OAI.Analysis.Kaplansky.ShiftAlgebra": [
        ("ContinuousLinearMap.nonneg_iff_isPositive.mpr ha",
         "(ContinuousLinearMap.nonneg_iff_isPositive a).mpr ha")
    ],
    "OAI.Geometry.ComplexBundle.Evaluation": [
        ("(e i).symmL_apply (R := ℝ) hx", "(e i).symmL_apply (R := ℝ) x"),
        ("e₁.symmL_apply hx.1", "Trivialization.symmL_apply"),
        ("e₂.symmL_apply hx.2", "Trivialization.symmL_apply")
    ],
    "OAI.Analysis.Kaplansky.BundlePolynomials": [("ite_eq_right", "if_neg")],
    "OAI.AlgebraicTopology.IntegralHomology.SmallChains": [
        ("import Mathlib.CategoryTheory.Limits.Preserves.SigmaConst",
         "import Mathlib.CategoryTheory.Limits.Preserves.SigmaConst\n"
         "import Mathlib.CategoryTheory.Limits.MonoCoprod"),
        ("    unfold integralSimplicialChains\n"
         "    dsimp [SSet.chainComplexFunctor]\n"
         "    apply +allowSynthFailures Functor.map_mono",
         "    apply HomologicalComplex.mono_of_mono_f\n"
         "    intro n\n"
         "    change Mono ((sigmaConst.obj (ModuleCat.of ℤ ℤ)).map (f.app (Opposite.op ⦋n⦌)))\n"
         "    exact (sigmaConst.obj (ModuleCat.of ℤ ℤ)).map_mono _"),
        ("instance standardSimplexMetricSpace (Index : Type*) [Fintype Index] :\n"
         "    MetricSpace (Convexity.StdSimplex ℝ Index) :=\n"
         "  (Convexity.StdSimplex.isEmbedding_toFun_comp_weights ℝ Index).comapMetricSpace\n"
         "    (fun simplex => (simplex.weights : Index → ℝ))",
         "instance standardSimplexMetricSpace (Index : Type*) [Fintype Index] :\n"
         "    MetricSpace (_root_.stdSimplex ℝ Index) := inferInstance"),
        ("Convexity.StdSimplex", "_root_.stdSimplex")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.SmallExcision": [
        ("  simp [singularIntoSmallLeft]\n  rfl",
         "  simp only [singularIntoSmallLeft, Category.assoc,\n"
         "    SSet.Subcomplex.homOfLE_ι, singularSubsetIso_hom_ι]\n  rfl"),
        ("  simp [singularIntoSmallRight]\n  rfl",
         "  simp only [singularIntoSmallRight, Category.assoc,\n"
         "    SSet.Subcomplex.homOfLE_ι, singularSubsetIso_hom_ι]\n  rfl")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.TupleChains": [
        ("Sigma.ι_comp_desc", "Sigma.ι_desc")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.Subdivision": [
        ("Sigma.ι_comp_desc", "Sigma.ι_desc"),
        ("variable {κ : Type}\n", "variable {κ : Type} [Fintype κ]\n"),
        ("variable [Fintype κ]\n\n", ""),
        ("  exact (iConvexComb_assoc t v w).symm",
         """  classical
  apply _root_.stdSimplex.ext
  simp only [simplexCombination_coe, Function.comp_apply]
  ext j
  simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul,
    Finset.sum_mul, Finset.mul_sum, mul_assoc]
  rw [Finset.sum_comm]"""),
        ("(StdSimplex.barycenter (K := ℝ) (M := Fin (n+2))).weights_nonneg index",
         "_root_.stdSimplex.zero_le (StdSimplex.barycenter (𝕜 := ℝ) (X := Fin (n+2))) index"),
        ("(StdSimplex.barycenter (K := ℝ) (M := Fin (n+2))).total_of_fintype",
         "_root_.stdSimplex.sum_eq_one (StdSimplex.barycenter (𝕜 := ℝ) (X := Fin (n+2)))"),
        ("StdSimplex.weights_single", "StdSimplex.vertex_coe"),
        ("Finsupp.single_apply", "Pi.single_apply"),
        (".weights", ""),
        ("StdSimplex.single", "StdSimplex.vertex"),
        ("(R := ℝ)", "(S := ℝ)"),
        ("Simplicial Convexity", "Simplicial"),
        ("StdSimplex", "_root_.stdSimplex")
    ],
    "OAI.AlgebraicTopology.IntegralHomology.Simplex": [
        ("instance simplexMetricSpace {κ : Type} [Fintype κ] : MetricSpace (StdSimplex ℝ κ) :=\n"
         "  Topology.IsEmbedding.comapMetricSpace\n"
         "    (fun point : StdSimplex ℝ κ => (point.weights : κ → ℝ))\n"
         "    (StdSimplex.isEmbedding_toFun_comp_weights ℝ κ)",
         "instance simplexMetricSpace {κ : Type} [Fintype κ] : MetricSpace (StdSimplex ℝ κ) :=\n"
         "  inferInstance"),
        ("  t.iConvexComb v",
         """  ⟨∑ index, t index • ⇑(v index), by
    exact (convex_stdSimplex ℝ κ).sum_mem
      (fun index _ => _root_.stdSimplex.zero_le t index) (_root_.stdSimplex.sum_eq_one t)
      (fun index _ => (v index).property)⟩"""),
        ("  classical\n"
         "  simp [simplexCombination, iConvexComb, StdSimplex.weights_sConvexComb,\n"
         "    StdSimplex.weights_map, Finsupp.sum_mapDomain_index, add_smul,\n"
         "    Finsupp.sum_fintype, Finsupp.coe_finsetSum, Finsupp.coe_smul]",
         "  rfl"),
        ("  ⟨simplexCombination v, by\n"
         "    apply (StdSimplex.isEmbedding_toFun_comp_weights ℝ κ).continuous_iff.mpr\n"
         "    change Continuous (fun point => ⇑(simplexCombination v point).weights)\n"
         "    simp only [simplexCombination_coe]\n"
         "    apply continuous_finsetSum\n"
         "    intro index _\n"
         "    exact (StdSimplex.continuous_weights_apply ℝ index).smul continuous_const⟩",
         """  ⟨simplexCombination v, by
    have h : Continuous (fun point : StdSimplex ℝ ι =>
        ∑ index, point index • ⇑(v index)) := by
      apply continuous_finsetSum
      intro index _
      exact ((continuous_apply index).comp continuous_subtype_val).smul continuous_const
    exact h.subtype_mk _⟩"""),
        ("  exact Convexity.iConvexComb_single i v",
         """  classical
  apply Subtype.ext
  change (∑ j, (Pi.single i (1 : ℝ) : ι → ℝ) j • (v j).val) = (v i).val
  simp [Pi.single_apply]"""),
        ("  exact StdSimplex.iConvexComb_single t",
         """  classical
  apply Subtype.ext
  change (∑ i, t.val i • Pi.single i (1 : ℝ)) = t.val
  ext j
  simp [Pi.single_apply, Finset.sum_apply, Pi.smul_apply]"""),
        ("  exact (Convexity.iConvexComb_map t f v).symm",
         """  classical
  apply _root_.stdSimplex.ext
  simp only [simplexCombination_coe, Function.comp_apply]
  ext j
  simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul,
    _root_.stdSimplex.map_coe, FunOnFinite.linearMap_apply_apply,
    Finset.sum_filter, Finset.sum_mul, ite_mul, zero_mul]
  rw [Finset.sum_comm]
  simp"""),
        ("  exact Convexity.map_iConvexComb t v",
         """  classical
  apply _root_.stdSimplex.ext
  change FunOnFinite.linearMap ℝ ℝ f (∑ i, t i • ⇑(v i)) =
    ∑ i, t i • FunOnFinite.linearMap ℝ ℝ f (v i)
  simp only [map_sum, map_smul]"""),
        ("(StdSimplex.map_single j i.succAbove).symm",
         "(StdSimplex.map_vertex i.succAbove j).symm"),
        ("StdSimplex.continuous_map ℝ f", "StdSimplex.continuous_map (S := ℝ) f"),
        ("    simp only [simplexTupleCenter, simplexCombination_coe, StdSimplex.weights_barycenter_apply, Fintype.card_fin, Nat.cast_add, Nat.cast_ofNat]",
         """    have hb (i : Fin (n+2)) :
        (StdSimplex.barycenter : StdSimplex ℝ (Fin (n+2))) i =
          (Fintype.card (Fin (n+2)) : ℝ)⁻¹ := rfl
    simp only [simplexTupleCenter, simplexCombination_coe, hb,
      Fintype.card_fin, Nat.cast_add, Nat.cast_ofNat]"""),
        ("t.weights_nonneg", "(_root_.stdSimplex.zero_le t)"),
        ("t.total_of_fintype", "(_root_.stdSimplex.sum_eq_one t)"),
        (".weights", ""),
        ("StdSimplex.single", "StdSimplex.vertex"),
        ("(R := ℝ)", "(S := ℝ)"),
        ("Simplicial Convexity", "Simplicial"),
        ("StdSimplex", "_root_.stdSimplex"),
        ("import Mathlib.Analysis.Convex._root_.stdSimplex",
         "import Mathlib.Analysis.Convex.StdSimplex")
    ],
}


def without_comments(source):
    result = []
    depth = 0
    quoted = False
    i = 0
    while i < len(source):
        pair = source[i:i + 2]
        if depth:
            if pair == "/-":
                depth += 1
                i += 2
            elif pair == "-/":
                depth -= 1
                i += 2
            else:
                result.append("\n" if source[i] == "\n" else " ")
                i += 1
        elif not quoted and pair == "/-":
            depth = 1
            result.append(" ")
            i += 2
        elif not quoted and pair == "--":
            end = source.find("\n", i)
            i = len(source) if end == -1 else end
        else:
            char = source[i]
            result.append(char)
            if char == "\\" and quoted and i + 1 < len(source):
                result.append(source[i + 1])
                i += 2
                continue
            if char == '"':
                quoted = not quoted
            i += 1
    if depth or quoted:
        raise ValueError("Unterminated comment or string in upstream source")
    return "".join(result)


def imports(source):
    found = []
    for line in without_comments(source).splitlines():
        match = re.match(r"^\s*(?:public\s+)?import\s+(.+)$", line)
        if match:
            found.extend(token for token in match[1].split()
                         if token not in {"all"})
    return found


def module_path(module):
    if not re.fullmatch(r"OAI(?:\.[A-Za-z_][A-Za-z_0-9]*)+", module):
        raise ValueError(f"Unexpected upstream module: {module}")
    return UPSTREAM.joinpath(*module.split(".")).with_suffix(".lean")


def source_closure(fetch):
    ordered = []
    active = set()
    seen = set()
    digests = {}
    suspicious = []

    def visit(module):
        if module in active:
            raise ValueError(f"Import cycle at {module}")
        if module in seen:
            return
        active.add(module)
        path = module_path(module)
        if fetch:
            url = ("https://raw.githubusercontent.com/openai/math/"
                   f"{COMMIT}/lean/{module.replace('.', '/')}.lean")
            with urlopen(url, timeout=45) as response:
                data = response.read()
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
        source = path.read_text()
        digests[module] = hashlib.sha256(path.read_bytes()).hexdigest()
        clean = without_comments(source)
        for line_number, line in enumerate(clean.splitlines(), 1):
            if re.search(r"\b(sorry|admit|axiom|unsafe|native_decide)\b", line):
                suspicious.append({"module": module, "line": line_number,
                                   "text": line.strip()})
        for dependency in imports(source):
            if dependency.startswith("OAI."):
                visit(dependency)
            elif not dependency.startswith(("Mathlib.", "Mathlib", "Lean.", "Init", "Batteries.")):
                raise ValueError(f"Unaccounted dependency {dependency} in {module}")
        active.remove(module)
        seen.add(module)
        ordered.append(module)

    visit(ENTRY)
    return ordered, digests, suspicious


def arithmetic_checks():
    delta = Fraction(1, 5)
    margin = Fraction(1, 2) - 2 * delta - delta * delta
    defect = (1 - Fraction(2, 3)) / (2 * 24)
    if margin != Fraction(3, 50) or defect != Fraction(1, 144):
        raise AssertionError("Exact source constants did not replay")
    payload_path = ROOT / "jacobian_perturbation.payload.json"
    output_path = ROOT / "jacobian_perturbation.output.json"
    output = json.loads(output_path.read_text())
    if output["request"]["operation_id"] != "polynomial.box.enclosure.compute":
        raise AssertionError("Wrong Jacobian operation")
    result = output["result"]["output"]
    payload = json.loads(payload_path.read_text())
    if output["request"]["payload"] != payload:
        raise AssertionError("Jacobian payload mismatch")
    for key in ("polynomial", "box"):
        if result[key] != payload[key]:
            raise AssertionError(f"Jacobian source mismatch: {key}")
    def rational(value):
        return Fraction(int(value["num"]), int(value["den"]))
    enclosure = result["enclosure"]
    if rational(enclosure["lower"]) != margin:
        raise AssertionError("Wrong exact perturbation margin")
    if rational(enclosure["upper"]) != Fraction(1, 2):
        raise AssertionError("Wrong exact upper enclosure")
    return {
        "scope": "Auxiliary exact constants only; not a proof of C294_MAIN.",
        "perturbation_margin_on_closed_box": str(margin),
        "defect_at_N_24_c_two_thirds": str(defect),
        "jacobian_server": output["server"],
        "jacobian_protocol": output["protocol_version"],
        "jacobian_operation": output["request"]["operation_id"],
        "jacobian_adapter_exit": 0,
    }


def compile_closure(ordered, previous, compatibility):
    env = os.environ.copy()
    env["ELAN_TOOLCHAIN"] = "leanprover/lean4:v4.31.0"
    version = subprocess.run(["lean", "--version"], env=env, text=True,
                             capture_output=True, check=True).stdout.strip()
    if not re.search(r"Lean \(version 4\.31\.0(?:,|\s)", version):
        raise RuntimeError(f"Wrong compiler: {version}")
    search = subprocess.run(["lake", "env", "printenv", "LEAN_PATH"],
                            cwd=MATHLIB, env=env, text=True,
                            capture_output=True, check=True).stdout.strip()
    env["LEAN_PATH"] = str(BUILD) + os.pathsep + search
    ported_digests = {}
    if compatibility:
        for module, replacements in COMPATIBILITY.items():
            source = module_path(module).read_text()
            for old, new in replacements:
                if old not in source:
                    raise ValueError(f"Compatibility source fragment is missing: {module}: {old}")
                source = source.replace(old, new)
            path = PORTED.joinpath(*module.split(".")).with_suffix(".lean")
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(source)
            ported_digests[module] = hashlib.sha256(path.read_bytes()).hexdigest()
    prior = previous.get("compilation", {})
    prefix = prior.get("compiled_module_count", 0)
    if prior.get("compiler") != version:
        prefix = 0
    old_ports = prior.get("ported_source_sha256", {})
    for changed in set(old_ports) | set(ported_digests):
        if old_ports.get(changed) != ported_digests.get(changed):
            prefix = min(prefix, ordered.index(changed))
    for module in ordered[:prefix]:
        if not BUILD.joinpath(*module.split(".")).with_suffix(".olean").is_file():
            raise RuntimeError(f"Previously compiled module is missing: {module}")
    compiled = ordered[:prefix]
    for module in ordered[prefix:]:
        out = BUILD.joinpath(*module.split(".")).with_suffix(".olean")
        out.parent.mkdir(parents=True, exist_ok=True)
        package_root = PORTED if module in ported_digests else UPSTREAM
        path = (PORTED.joinpath(*module.split(".")).with_suffix(".lean")
                if module in ported_digests else module_path(module))
        command = ["lean", "-R", str(package_root), "-o", str(out), str(path)]
        run = subprocess.run(command, cwd=UPSTREAM, env=env, text=True,
                             stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        if run.returncode:
            log = ROOT / f"compile_failure_{module.replace('.', '_')}.txt"
            log.write_text(run.stdout)
            return {
                "status": "blocked",
                "compiler": version,
                "compiled_module_count": len(compiled),
                "failed_module": module,
                "command": command,
                "exit_code": run.returncode,
                "diagnostic": str(log.relative_to(PROJECT)),
                "transitive_axioms_checked": False,
                "ported_source_sha256": ported_digests,
                "compatibility_edits": COMPATIBILITY if compatibility else {},
            }
        compiled.append(module)
    command = ["lean", str(ROOT / "Main.lean")]
    run = subprocess.run(command, cwd=PROJECT, env=env, text=True,
                         stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    (ROOT / "main_compiler_output.txt").write_text(run.stdout)
    if run.returncode:
        return {"status": "blocked", "compiler": version, "command": command,
                "exit_code": run.returncode,
                "compiled_module_count": len(compiled),
                "ported_source_sha256": ported_digests,
                "compatibility_edits": COMPATIBILITY if compatibility else {},
                "transitive_axioms_checked": False,
                "diagnostic": "research/certification/main_compiler_output.txt"}
    match = re.search(r"Certification294\.main.*?depends on axioms:\s*\[([^\]]*)\]",
                      run.stdout, re.S)
    if not match:
        raise RuntimeError("No transitive main-theorem axiom report")
    axioms = set(filter(None, re.split(r"[\s,]+", match[1].strip())))
    if not axioms <= PERMITTED_AXIOMS:
        raise RuntimeError(f"Disallowed transitive axioms: {sorted(axioms)}")
    return {"status": "compiled", "compiler": version, "exit_code": 0,
            "compiled_module_count": len(compiled),
            "ported_source_sha256": ported_digests,
            "compatibility_edits": COMPATIBILITY if compatibility else {},
            "transitive_axioms_checked": True, "axioms": sorted(axioms),
            "independent_statement_fidelity": "pending Host Reviewer"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fetch", action="store_true",
                        help="Acquire only the necessary OAI dependency closure at the pinned commit.")
    parser.add_argument("--compile", action="store_true",
                        help="Compile every necessary module with Lean 4.31.0 and inspect axioms.")
    parser.add_argument("--compatibility", action="store_true",
                        help="Apply the explicitly listed Lean 4.31.0 compatibility backports.")
    parser.add_argument("--rebuild", action="store_true",
                        help="Recompile the complete closure without reusing its successful prefix.")
    args = parser.parse_args()
    if not (args.fetch or args.compile):
        args.compile = True
        args.compatibility = True
    if args.rebuild and not args.compile:
        parser.error("--rebuild requires compilation, not a fetch-only invocation")
    previous = json.loads(CERTIFICATE.read_text()) if CERTIFICATE.exists() else {}
    ordered, digests, suspicious = source_closure(args.fetch)
    if not args.fetch and previous.get("source_sha256") != digests:
        raise RuntimeError("Proof-closure source differs from the acquired certificate")
    certificate = {
        "claim": "C294_MAIN",
        "status": "source_acquired" if args.fetch else "not_certified",
        "certifies_main_theorem": False,
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "upstream_commit": COMMIT,
        "upstream_entry": ENTRY,
        "module_count": len(ordered),
        "source_sha256": digests,
        "formal_source_sha256": hashlib.sha256((ROOT / "Main.lean").read_bytes()).hexdigest(),
        "statement_fidelity_sha256": hashlib.sha256(
            (ROOT / "statement_fidelity.md").read_bytes()).hexdigest(),
        "verifier_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        "static_sensitive_tokens": suspicious,
        "arithmetic": arithmetic_checks(),
        "independent_review": "pending Host Reviewer",
    }
    if args.compile:
        certificate["compilation"] = compile_closure(
            ordered, {} if args.rebuild else previous, args.compatibility)
        certificate["status"] = certificate["compilation"]["status"]
        certificate["certifies_main_theorem"] = certificate["status"] == "compiled"
        native_path = ROOT / "lean_check.json"
        if certificate["certifies_main_theorem"] and native_path.exists():
            native = json.loads(native_path.read_text())
            if (native.get("source_sha256") != certificate["formal_source_sha256"]
                    or native.get("statement_fidelity_sha256")
                    != certificate["statement_fidelity_sha256"]):
                raise RuntimeError("Native Lean evidence is stale; rerun lean_evidence verify")
            if (native.get("status") != "success" or native.get("exit_code") != 0
                    or native.get("audit_exit_code") != 0
                    or native.get("proof_holes") != []):
                raise RuntimeError("Native Lean evidence does not certify a hole-free proof")
            certificate["native_lean_evidence"] = {
                "artifact": str(native_path.relative_to(PROJECT)),
                "sha256": hashlib.sha256(native_path.read_bytes()).hexdigest(),
                "exit_code": native["exit_code"],
                "proof_holes": native["proof_holes"],
                "audit_exit_code": native["audit_exit_code"],
            }
    CERTIFICATE.write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({key: value for key, value in certificate.items()
                      if key not in {"source_sha256", "static_sensitive_tokens"}},
                     indent=2))
    return 0 if args.fetch and not args.compile else (
        0 if certificate.get("compilation", {}).get("status") == "compiled" else 1)


if __name__ == "__main__":
    sys.exit(main())
