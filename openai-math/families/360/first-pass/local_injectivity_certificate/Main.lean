import Mathlib

/-
Upstream consolidation from openai/math commit
4eaee87548250b2682affda7d05d947c05554bae, Apache-2.0.
Modification: module imports are consolidated into import Mathlib.
Two proved compatibility lemmas restore older API names used by these sources.
The original proof bodies, source modules and LICENSE are retained in upstream_sources/.
-/

private theorem uniqueDiffOn_uIcc {a b : ℝ} (hab : a ≠ b) :
    UniqueDiffOn ℝ (Set.uIcc a b) := by
  rcases lt_or_gt_of_ne hab with h | h
  · rw [Set.uIcc_of_le h.le]
    exact uniqueDiffOn_Icc h
  · rw [Set.uIcc_comm, Set.uIcc_of_le h.le]
    exact uniqueDiffOn_Icc h

private theorem dite_eq_left {p : Prop} [Decidable p] {α : Sort*}
    (hp : p) {a : p → α} {b : ¬p → α} :
    (if h : p then a h else b h) = a hp := dif_pos hp

-- Upstream module: OAI/Geometry/WeakMTW/Variations/SecondCurveChain.lean

namespace OAI

namespace WeakMTWGlobalSupport

section

open Filter
open scoped Topology ContDiff
namespace SecondCurveChain
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

 theorem second {f : E → ℝ} {c : ℝ → E} {t : ℝ} {v acc : E}
    (hf : ContDiffAt ℝ 2 f (c t)) (hc : ContDiffAt ℝ 2 c t)
    (hv : HasDerivAt c v t) (ha : HasDerivAt (deriv c) acc t) :
    deriv (deriv (f ∘ c)) t =
      fderiv ℝ (fderiv ℝ f) (c t) v v + fderiv ℝ f (c t) acc := by
  have hD := (hf.fderiv_right (m := 1) (by norm_num)).differentiableAt (by norm_num)
  have hDc := hD.hasFDerivAt.comp_hasDerivAt t hv
  have hprod := hDc.clm_apply ha
  have heq : deriv (f ∘ c) =ᶠ[𝓝 t]
      (fun s => fderiv ℝ f (c s) (deriv c s)) := by
    have hevent := (hf.eventually (by norm_num)).filter_mono hv.continuousAt.tendsto
    filter_upwards [hevent, hc.eventually (by norm_num)] with s hs hcs
    change ContDiffAt ℝ 2 f (c s) at hs
    exact ((hs.differentiableAt (by norm_num)).hasFDerivAt.comp_hasDerivAt s
      (hcs.differentiableAt (by norm_num)).hasDerivAt).deriv
  rw [heq.deriv_eq]
  simpa only [Function.comp_def,hv.deriv] using hprod.deriv

end SecondCurveChain
end

end WeakMTWGlobalSupport

end OAI

-- Upstream module: OAI/Geometry/WeakMTW/Variations/LineTaylor.lean

namespace OAI

namespace WeakMTWGlobalSupport

section

open Set Filter
open scoped Topology ContDiff
namespace MovingTaylor
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

 theorem line_second_at {f : E → ℝ} (x v : E) (t : ℝ)
    (hf : ContDiffAt ℝ 2 f (x+t•v)) :
    deriv (deriv (fun r : ℝ => f (x+r•v))) t =
      fderiv ℝ (fderiv ℝ f) (x+t•v) v v := by
  have hv : ∀ r : ℝ, HasDerivAt (fun r : ℝ => x+r•v) v r := fun r => by
    simpa using (hasDerivAt_id r).smul_const v |>.const_add x
  have ha : HasDerivAt (deriv (fun r : ℝ => x+r•v)) 0 t := by
    have he : deriv (fun r : ℝ => x+r•v) = fun _ => v := funext (fun r => (hv r).deriv)
    rw [he]
    exact hasDerivAt_const t v
  simpa only [Function.comp_def,map_zero,add_zero] using
    SecondCurveChain.second hf (by fun_prop) (hv t) ha

 theorem second_segment {f : E → ℝ} (x v : E)
    (hf : ∀ t ∈ Icc (0 : ℝ) 1, ContDiffAt ℝ 2 f (x+t•v)) :
    ∃ t ∈ Ioo (0 : ℝ) 1,
      f (x+v)-f x-fderiv ℝ f x v =
        fderiv ℝ (fderiv ℝ f) (x+t•v) v v / 2 := by
  let g : ℝ → ℝ := fun t => f (x+t•v)
  have hg (t : ℝ) (ht : t ∈ Icc (0 : ℝ) 1) : ContDiffAt ℝ 2 g t :=
    (hf t ht).comp t (by fun_prop)
  have hgOn : ContDiffOn ℝ (1+1 : ℕ) g (uIcc (0 : ℝ) 1) := by
    rw [uIcc_of_le (by norm_num : (0 : ℝ) ≤ 1)]
    exact fun t ht => (hg t ht).contDiffWithinAt
  obtain ⟨t,ht,he⟩ := taylor_mean_remainder_lagrange_iteratedDeriv (n := 1)
    (by norm_num : (0 : ℝ) ≠ 1) hgOn
  have ht' : t ∈ Ioo (0 : ℝ) 1 := by simpa [uIoo_of_lt (by norm_num : (0 : ℝ) < 1)] using ht
  have hD : derivWithin g (uIcc (0 : ℝ) 1) 0 = fderiv ℝ f x v := by
    have hfx : ContDiffAt ℝ 2 f x := by simpa using hf 0 (by simp)
    have hfx' : HasFDerivAt f (fderiv ℝ f x) (x+(0 : ℝ)•v) := by simpa using (hfx.differentiableAt (by norm_num)).hasFDerivAt
    have hd := hfx'.comp_hasDerivAt 0
      (show HasDerivAt (fun r : ℝ => x+r•v) v 0 by simpa using (hasDerivAt_id (0 : ℝ)).smul_const v |>.const_add x)
    have hd' : HasDerivAt g (fderiv ℝ f x v) 0 := by simpa only [g,Function.comp_def] using hd
    exact hd'.hasDerivWithinAt.derivWithin (uniqueDiffOn_uIcc (by norm_num : (0 : ℝ) ≠ 1) 0 (by simp))
  have h2 : iteratedDeriv 2 g t = fderiv ℝ (fderiv ℝ f) (x+t•v) v v := by
    simpa only [iteratedDeriv_succ,iteratedDeriv_zero,Function.comp_def,g] using
      line_second_at x v t (hf t ⟨ht'.1.le,ht'.2.le⟩)
  refine ⟨t,ht',?_⟩
  simp only [taylorWithinEval_succ,taylor_within_zero_eval,iteratedDerivWithin_succ,
    iteratedDerivWithin_zero] at he
  rw [hD] at he
  norm_num only [Nat.factorial_one,Nat.cast_one,inv_one,sub_zero,one_pow,one_mul,
    one_smul,Nat.factorial_succ,Nat.cast_mul,Nat.cast_ofNat] at he
  rw [h2,mul_one] at he
  simpa only [g,one_smul,zero_smul,add_zero,sub_add_eq_sub_sub] using he
end MovingTaylor
end

end WeakMTWGlobalSupport

end OAI

-- Upstream module: OAI/Geometry/WeakMTW/Variations/MovingTaylor.lean

namespace OAI

namespace WeakMTWGlobalSupport

section

open Set Filter
open scoped Topology ContDiff
namespace MovingTaylor
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

 theorem tendsto_clm_apply {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    {α : Type*} {l : Filter α} {f : α → E →L[ℝ] F} {g : α → E}
    {L : E →L[ℝ] F} {v : E} (hf : Tendsto f l (𝓝 L)) (hg : Tendsto g l (𝓝 v)) :
    Tendsto (fun a => f a (g a)) l (𝓝 (L v)) :=
    (isBoundedBilinearMap_apply (𝕜 := ℝ) (E := E) (F := F)).continuous.continuousAt.tendsto.comp (hf.prodMk_nhds hg)

 theorem segment_norm_bound (_ : E) (v : E) {t : ℝ} (ht : t ∈ Icc (0 : ℝ) 1) :
    ‖t•v‖ ≤ ‖v‖ := by
  rw [norm_smul,Real.norm_eq_abs,abs_of_nonneg ht.1]
  exact mul_le_of_le_one_left (norm_nonneg _) ht.2

 theorem moving_segment_tendsto {x v : ℕ → E} {a : E}
    (hx : Tendsto x atTop (𝓝 a)) (hv : Tendsto v atTop (𝓝 0))
    {t : ℕ → ℝ} (ht : ∀ᶠ j in atTop, t j ∈ Icc (0 : ℝ) 1) :
    Tendsto (fun j => x j+t j•v j) atTop (𝓝 a) := by
  have hzero : Tendsto (fun j => t j•v j) atTop (𝓝 (0 : E)) := by
    rw [tendsto_zero_iff_norm_tendsto_zero]
    apply squeeze_zero' (Eventually.of_forall (fun _ => norm_nonneg _))
      (ht.mono (fun j hj => segment_norm_bound (x j) (v j) hj))
    simpa using hv.norm
  simpa using hx.add hzero

 theorem moving_segment_smooth {f : E → ℝ} {a : E} (hf : ContDiffAt ℝ ∞ f a)
    {x v : ℕ → E} (hx : Tendsto x atTop (𝓝 a)) (hv : Tendsto v atTop (𝓝 0)) :
    ∀ᶠ j in atTop, ∀ t ∈ Icc (0 : ℝ) 1, ContDiffAt ℝ 2 f (x j+t•v j) := by
  have hnear : ∀ᶠ z in 𝓝 a, ContDiffAt ℝ 2 f z :=
    (hf.of_le (show (2 : ℕ∞ω) ≤ ∞ from WithTop.coe_le_coe.mpr le_top)).eventually (by norm_num)
  obtain ⟨ε,hε,hball⟩ := Metric.mem_nhds_iff.mp hnear
  have hsmall : ∀ᶠ j in atTop, ‖x j-a‖+‖v j‖ < ε := by
    apply (tendsto_order.mp ((hx.sub tendsto_const_nhds).norm.add hv.norm)).2 ε
    simpa using hε
  filter_upwards [hsmall] with j hj t ht
  apply hball
  rw [Metric.mem_ball,dist_eq_norm]
  change ‖x j+t•v j-a‖ < ε
  calc
    _ = ‖(x j-a)+t•v j‖ := by congr 1; abel
    _ ≤ ‖x j-a‖+‖t•v j‖ := norm_add_le _ _
    _ ≤ ‖x j-a‖+‖v j‖ := add_le_add (le_refl _) (segment_norm_bound (x j) (v j) ht)
    _ < ε := hj

 theorem second_limit {f : E → ℝ} {a e : E} (hf : ContDiffAt ℝ ∞ f a)
    {x d : ℕ → E} {l : ℕ → ℝ}
    (hx : Tendsto x atTop (𝓝 a)) (hd : Tendsto d atTop (𝓝 e))
    (hl : Tendsto l atTop (𝓝 0)) (hlne : ∀ᶠ j in atTop, l j ≠ 0) :
    Tendsto (fun j => (f (x j+l j•d j)-f (x j)-fderiv ℝ f (x j) (l j•d j))/(l j)^2)
      atTop (𝓝 (fderiv ℝ (fderiv ℝ f) a e e / 2)) := by
  classical
  have hv : Tendsto (fun j => l j•d j) atTop (𝓝 (0 : E)) := by simpa using hl.smul hd
  have hsm := moving_segment_smooth hf hx hv
  let P (j : ℕ) (t : ℝ) : Prop := t ∈ Ioo (0 : ℝ) 1 ∧
    f (x j+l j•d j)-f (x j)-fderiv ℝ f (x j) (l j•d j) =
      fderiv ℝ (fderiv ℝ f) (x j+t•(l j•d j)) (l j•d j) (l j•d j) / 2
  have hex : ∀ᶠ j in atTop, ∃ t, P j t := hsm.mono (fun j hj => second_segment (x j) (l j•d j) hj)
  let t (j : ℕ) : ℝ := if H : ∃ t, P j t then Classical.choose H else 0
  have ht : ∀ᶠ j in atTop, P j (t j) := hex.mono (fun j hj => by
    dsimp only [t]
    rw [dite_eq_left hj]
    exact Classical.choose_spec hj)
  have hpoint := moving_segment_tendsto hx hv (ht.mono (fun j hj => ⟨hj.1.1.le,hj.1.2.le⟩))
  have hH : ContinuousAt (fderiv ℝ (fderiv ℝ f)) a :=
    ((hf.fderiv_right (m := ∞) (by simp)).fderiv_right (m := ∞) (by simp)).continuousAt
  have hlim := (tendsto_clm_apply (tendsto_clm_apply (hH.tendsto.comp hpoint) hd) hd).div_const 2
  apply hlim.congr'
  filter_upwards [ht,hlne] with j hj hlj
  rw [hj.2]
  simp only [map_smul,smul_apply,smul_eq_mul,Function.comp_def]
  field_simp [hlj]

 theorem first_limit {f : E → ℝ} {a e : E} (hf : ContDiffAt ℝ ∞ f a)
    {x d : ℕ → E} {l : ℕ → ℝ}
    (hx : Tendsto x atTop (𝓝 a)) (hd : Tendsto d atTop (𝓝 e))
    (hl : Tendsto l atTop (𝓝 0)) (hlne : ∀ᶠ j in atTop, l j ≠ 0) :
    Tendsto (fun j => (f (x j+l j•d j)-f (x j))/l j)
      atTop (𝓝 (fderiv ℝ f a e)) := by
  have h2 := second_limit hf hx hd hl hlne
  have hD := tendsto_clm_apply ((hf.fderiv_right (m := ∞) (by simp)).continuousAt.tendsto.comp hx) hd
  have hh := (h2.mul hl).add hD
  simp only [mul_zero,zero_add] at hh
  apply hh.congr'
  filter_upwards [hlne] with j hj
  simp only [map_smul,smul_eq_mul,Function.comp_def]
  field_simp [hj]
  ring

end MovingTaylor
end

end WeakMTWGlobalSupport

end OAI

-- Upstream module: OAI/Geometry/WeakMTW/Variations/ParametricTaylor.lean

namespace OAI

namespace WeakMTWGlobalSupport

section

open Set Filter
open scoped Topology ContDiff
namespace MovingTaylor
variable {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
  [NormedAddCommGroup F] [NormedSpace ℝ F]

 theorem param_first_limit {f : E × F → ℝ} {a e : E} {b : F}
    (hf : ContDiffAt ℝ ∞ f (a,b))
    {x d : ℕ → E} {q : ℕ → F} {l : ℕ → ℝ}
    (hx : Tendsto x atTop (𝓝 a)) (hd : Tendsto d atTop (𝓝 e))
    (hq : Tendsto q atTop (𝓝 b))
    (hl : Tendsto l atTop (𝓝 0)) (hlne : ∀ᶠ j in atTop, l j ≠ 0) :
    Tendsto (fun j => (f (x j+l j•d j,q j)-f (x j,q j))/l j)
      atTop (𝓝 (fderiv ℝ f (a,b) (e,0))) := by
  simpa only [Prod.smul_mk,smul_zero,Prod.mk_add_mk,add_zero] using
    first_limit hf (hx.prodMk_nhds hq) (hd.prodMk_nhds (tendsto_const_nhds (x := (0 : F)))) hl hlne

 theorem param_second_limit {f : E × F → ℝ} {a e : E} {b : F}
    (hf : ContDiffAt ℝ ∞ f (a,b))
    {x d : ℕ → E} {q : ℕ → F} {l : ℕ → ℝ}
    (hx : Tendsto x atTop (𝓝 a)) (hd : Tendsto d atTop (𝓝 e))
    (hq : Tendsto q atTop (𝓝 b))
    (hl : Tendsto l atTop (𝓝 0)) (hlne : ∀ᶠ j in atTop, l j ≠ 0) :
    Tendsto (fun j => (f (x j+l j•d j,q j)-f (x j,q j)-
        l j*fderiv ℝ f (x j,q j) (d j,0))/(l j)^2)
      atTop (𝓝 (fderiv ℝ (fderiv ℝ f) (a,b) (e,0) (e,0) / 2)) := by
  have hscale (j : ℕ) : fderiv ℝ f (x j,q j) (l j•d j,0) =
      l j*fderiv ℝ f (x j,q j) (d j,0) := by
    simpa only [Prod.smul_mk,smul_zero,smul_eq_mul] using
      (fderiv ℝ f (x j,q j)).map_smul (l j) (d j,0)
  simpa only [Prod.smul_mk,smul_zero,Prod.mk_add_mk,add_zero,hscale] using
    second_limit hf (hx.prodMk_nhds hq) (hd.prodMk_nhds (tendsto_const_nhds (x := (0 : F)))) hl hlne
end MovingTaylor
end

end WeakMTWGlobalSupport

end OAI

-- Upstream module: OAI/Geometry/WeakMTW/Support/CollisionCalculus.lean

namespace OAI

namespace WeakMTWGlobalSupport

section

open Set Filter
open scoped Topology ContDiff
namespace MovingTaylor
variable {E F P ι : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
  [NormedAddCommGroup F] [NormedSpace ℝ F] [NormedAddCommGroup P] [NormedSpace ℝ P]
  [Fintype ι]

 theorem collision_limits {B : E × F → ℝ} {C : ι → E × P → ℝ}
    {x₀ e : E} {y₀ : F} {a₀ : ι → P} {β₀ : ℝ} {θ₀ : ι → ℝ}
    (hB : ContDiffAt ℝ ∞ B (x₀,y₀)) (hC : ∀ i, ContDiffAt ℝ ∞ (C i) (x₀,a₀ i))
    {x d : ℕ → E} {y : ℕ → F} {a : ℕ → ι → P} {β l : ℕ → ℝ} {θ : ℕ → ι → ℝ}
    (hx : Tendsto x atTop (𝓝 x₀)) (hd : Tendsto d atTop (𝓝 e))
    (hy : Tendsto y atTop (𝓝 y₀)) (ha : ∀ i, Tendsto (fun j => a j i) atTop (𝓝 (a₀ i)))
    (hβ : Tendsto β atTop (𝓝 β₀)) (hθ : ∀ i, Tendsto (fun j => θ j i) atTop (𝓝 (θ₀ i)))
    (hl : Tendsto l atTop (𝓝 0)) (hlpos : ∀ᶠ j in atTop, 0 < l j)
    (hθpos : ∀ᶠ j in atTop, ∀ i, 0 ≤ θ j i)
    (hineq : ∀ᶠ j in atTop, ∀ i,
      B (x j+l j•d j,y j)-B (x j,y j) -
      β j*(C i (x j+l j•d j,a j i)-C i (x j,a j i)) ≤ 0)
    (hcancel : ∀ᶠ j in atTop, ∑ i, θ j i *
      (fderiv ℝ B (x j,y j) (d j,0)-β j*fderiv ℝ (C i) (x j,a j i) (d j,0)) = 0) :
    (∀ i, fderiv ℝ B (x₀,y₀) (e,0)-β₀*fderiv ℝ (C i) (x₀,a₀ i) (e,0) ≤ 0) ∧
    (∑ i, θ₀ i * (fderiv ℝ (fderiv ℝ B) (x₀,y₀) (e,0) (e,0) -
      β₀*fderiv ℝ (fderiv ℝ (C i)) (x₀,a₀ i) (e,0) (e,0)) ≤ 0) := by
  have hlne := hlpos.mono (fun _ hj => hj.ne')
  constructor
  · intro i
    have hlim := (param_first_limit hB hx hd hy hl hlne).sub
      (hβ.mul (param_first_limit (hC i) hx hd (ha i) hl hlne))
    apply le_of_tendsto hlim
    filter_upwards [hlpos,hineq] with j hj hji
    have hh := div_nonpos_of_nonpos_of_nonneg (hji i) hj.le
    convert hh using 1
    ring
  · have hlimB := param_second_limit hB hx hd hy hl hlne
    have hlimC (i : ι) := param_second_limit (hC i) hx hd (ha i) hl hlne
    have hlim := tendsto_finsetSum Finset.univ (fun i _ => (hθ i).mul (hlimB.sub (hβ.mul (hlimC i))))
    have hle : ∑ i, θ₀ i * (fderiv ℝ (fderiv ℝ B) (x₀,y₀) (e,0) (e,0) / 2 -
        β₀*(fderiv ℝ (fderiv ℝ (C i)) (x₀,a₀ i) (e,0) (e,0) / 2)) ≤ 0 := by
      apply le_of_tendsto hlim
      filter_upwards [hlpos,hθpos,hineq,hcancel] with j hj hjθ hji hjc
      let DB := fderiv ℝ B (x j,y j) (d j,0)
      let DC := fun i => fderiv ℝ (C i) (x j,a j i) (d j,0)
      let VB := B (x j+l j•d j,y j)-B (x j,y j)
      let VC := fun i => C i (x j+l j•d j,a j i)-C i (x j,a j i)
      change ∑ i, θ j i*((VB-l j*DB)/(l j)^2-β j*((VC i-l j*DC i)/(l j)^2)) ≤ 0
      have heq : (∑ i, θ j i*((VB-l j*DB)/(l j)^2-β j*((VC i-l j*DC i)/(l j)^2))) =
          ((∑ i, θ j i*(VB-β j*VC i))-l j*(∑ i, θ j i*(DB-β j*DC i)))/(l j)^2 := by
        rw [Finset.mul_sum,← Finset.sum_sub_distrib,Finset.sum_div]
        apply Finset.sum_congr rfl
        intro i _
        ring
      rw [heq,hjc,mul_zero,sub_zero]
      exact div_nonpos_of_nonpos_of_nonneg (Finset.sum_nonpos (fun i _ => mul_nonpos_of_nonneg_of_nonpos (hjθ i) (hji i))) (sq_nonneg _)
    have heq : (∑ i, θ₀ i * (fderiv ℝ (fderiv ℝ B) (x₀,y₀) (e,0) (e,0) / 2 -
        β₀*(fderiv ℝ (fderiv ℝ (C i)) (x₀,a₀ i) (e,0) (e,0) / 2))) =
        (∑ i, θ₀ i * (fderiv ℝ (fderiv ℝ B) (x₀,y₀) (e,0) (e,0) -
        β₀*fderiv ℝ (fderiv ℝ (C i)) (x₀,a₀ i) (e,0) (e,0))) / 2 := by
      rw [Finset.sum_div]
      apply Finset.sum_congr rfl
      intro i _
      ring
    rw [heq] at hle
    linarith
end MovingTaylor
end

end WeakMTWGlobalSupport

end OAI

-- BEGIN CAMPAIGN CORE
noncomputable section
open Filter Topology
open scoped BigOperators ContDiff

namespace MovingActive

theorem tendstoZeroOfAbsLe {f r : ℕ → ℝ}
    (hr : Tendsto r atTop (𝓝 0)) (h : ∀ j, |f j| ≤ r j) :
    Tendsto f atTop (𝓝 0) := by
  have hn : Tendsto (fun j => -r j) atTop (𝓝 0) := by
    simpa using hr.neg
  exact hn.squeeze hr (fun j => (abs_le.mp (h j)).1)
    (fun j => (abs_le.mp (h j)).2)

theorem barycentricCancellation {I V : Type*} [Fintype I]
    [NormedAddCommGroup V] [InnerProductSpace ℝ V]
    {m : I → ℝ} {a : I → V} {p e : V}
    (hunit : ∑ i, m i = 1) (hbary : ∑ i, m i • a i = p) :
    ∑ i, m i * inner ℝ (a i - p) e = 0 := by
  classical
  have hv : (∑ i, m i • (a i - p)) = (0 : V) := by
    simp only [smul_sub, Finset.sum_sub_distrib, ← Finset.sum_smul,
      hunit, one_smul, hbary, sub_self]
  have hi := congrArg (fun z : V => inner ℝ z e) hv
  simpa only [sum_inner, real_inner_smul_left, inner_zero_left] using hi

theorem weightedRemainderBound {I : Type*} [Fintype I]
    {m ε : I → ℝ} {r : ℝ}
    (hm : ∀ i, 0 ≤ m i) (hunit : ∑ i, m i = 1)
    (hε : ∀ i, |ε i| ≤ r) :
    |∑ i, m i * ε i| ≤ r := by
  classical
  have hu : (∑ i, m i * ε i) ≤ ∑ i, m i * r :=
    Finset.sum_le_sum fun i _ =>
      mul_le_mul_of_nonneg_left (abs_le.mp (hε i)).2 (hm i)
  have hl : (∑ i, m i * (-r)) ≤ ∑ i, m i * ε i :=
    Finset.sum_le_sum fun i _ =>
      mul_le_mul_of_nonneg_left (abs_le.mp (hε i)).1 (hm i)
  rw [← Finset.sum_mul, hunit, one_mul] at hu hl
  exact abs_le.mpr ⟨hl, hu⟩

theorem cancellationBound {I : Type*} [Fintype I]
    {m d B ε : I → ℝ} {l Δ : ℝ}
    (hm : ∀ i, 0 ≤ m i) (hunit : ∑ i, m i = 1)
    (hl : 0 < l) (hΔ : Δ ≤ 0)
    (hexp : ∀ i, l * d i + l ^ 2 / 2 * B i + l ^ 2 * ε i ≤ Δ)
    (hcancel : ∑ i, m i * d i = 0) :
    (∑ i, m i * B i) / 2 + ∑ i, m i * ε i ≤ 0 := by
  classical
  have hsum := Finset.sum_le_sum
    (fun i (_ : i ∈ Finset.univ) =>
      mul_le_mul_of_nonneg_left (hexp i) (hm i))
  have heq :
      (∑ i, m i * (l * d i + l ^ 2 / 2 * B i + l ^ 2 * ε i)) =
      l * (∑ i, m i * d i) +
        l ^ 2 / 2 * (∑ i, m i * B i) +
        l ^ 2 * (∑ i, m i * ε i) := by
    calc
      _ = ∑ i, (l * (m i * d i) +
          l ^ 2 / 2 * (m i * B i) + l ^ 2 * (m i * ε i)) := by
        apply Finset.sum_congr rfl
        intro i _
        ring
      _ = _ := by
        simp only [Finset.sum_add_distrib, ← Finset.mul_sum]
  rw [heq, hcancel, mul_zero, zero_add,
    ← Finset.sum_mul, hunit, one_mul] at hsum
  have hs : l ^ 2 * ((∑ i, m i * B i) / 2 +
      ∑ i, m i * ε i) ≤ 0 := by
    calc
      _ = l ^ 2 / 2 * (∑ i, m i * B i) +
          l ^ 2 * (∑ i, m i * ε i) := by ring
      _ ≤ Δ := hsum
      _ ≤ 0 := hΔ
  exact (mul_le_mul_iff_right₀ (sq_pos_of_pos hl)).mp (by simpa using hs)

theorem movingFiniteCollisionImpossible
    {I : ℕ → Type*} [∀ j, Fintype (I j)]
    {m d B ε : (j : ℕ) → I j → ℝ} {l Δ r : ℕ → ℝ} {gap : ℝ}
    (hm : ∀ j i, 0 ≤ m j i) (hunit : ∀ j, ∑ i, m j i = 1)
    (hl : ∀ j, 0 < l j) (hΔ : ∀ j, Δ j ≤ 0)
    (hexp : ∀ j i,
      l j * d j i + (l j) ^ 2 / 2 * B j i +
        (l j) ^ 2 * ε j i ≤ Δ j)
    (hcancel : ∀ j, ∑ i, m j i * d j i = 0)
    (hε : ∀ j i, |ε j i| ≤ r j)
    (hr : Tendsto r atTop (𝓝 0))
    (hgap : Tendsto (fun j => ∑ i, m j i * B j i) atTop (𝓝 gap))
    (hpositive : 0 < gap) : False := by
  have hR : Tendsto (fun j => ∑ i, m j i * ε j i) atTop (𝓝 0) :=
    tendstoZeroOfAbsLe hr fun j =>
      weightedRemainderBound (hm j) (hunit j) (hε j)
  have hlim := (hgap.div_const 2).add hR
  have hnonpos : gap / 2 + 0 ≤ 0 := le_of_tendsto hlim
    (Eventually.of_forall fun j =>
      cancellationBound (hm j) (hunit j) (hl j) (hΔ j)
        (hexp j) (hcancel j))
  linarith

theorem vanishingWeightBounded {w B : ℕ → ℝ} {K : ℝ}
    (hw : Tendsto w atTop (𝓝 0)) (hB : ∀ j, |B j| ≤ K) :
    Tendsto (fun j => w j * B j) atTop (𝓝 0) := by
  have hu : Tendsto (fun j => |w j| * K) atTop (𝓝 0) := by
    simpa using hw.abs.mul (tendsto_const_nhds (x := K))
  apply tendstoZeroOfAbsLe hu
  intro j
  rw [abs_mul]
  exact mul_le_mul_of_nonneg_left (hB j) (abs_nonneg _)

theorem finiteWeightedLimit {I : Type*} [Fintype I]
    {m B : ℕ → I → ℝ} {m₀ B₀ : I → ℝ}
    (hm : ∀ i, Tendsto (fun j => m j i) atTop (𝓝 (m₀ i)))
    (hB : ∀ i, Tendsto (fun j => B j i) atTop (𝓝 (B₀ i))) :
    Tendsto (fun j => ∑ i, m j i * B j i) atTop
      (𝓝 (∑ i, m₀ i * B₀ i)) := by
  exact tendsto_finsetSum Finset.univ (fun i _ => (hm i).mul (hB i))

theorem firstOrderNonpos {l Δ d B ε : ℕ → ℝ} {d₀ B₀ : ℝ}
    (hl : Tendsto l atTop (𝓝 0)) (hlpos : ∀ j, 0 < l j)
    (hd : Tendsto d atTop (𝓝 d₀)) (hB : Tendsto B atTop (𝓝 B₀))
    (hε : Tendsto ε atTop (𝓝 0)) (hΔ : ∀ j, Δ j ≤ 0)
    (hexp : ∀ j, l j * d j + (l j) ^ 2 / 2 * B j +
      (l j) ^ 2 * ε j ≤ Δ j) :
    d₀ ≤ 0 := by
  have hlim : Tendsto (fun j => d j + l j * (B j / 2 + ε j))
      atTop (𝓝 d₀) := by
    simpa using hd.add (hl.mul ((hB.div_const 2).add hε))
  apply le_of_tendsto hlim
  apply Eventually.of_forall
  intro j
  have hs : l j * (d j + l j * (B j / 2 + ε j)) ≤ 0 := by
    calc
      _ = l j * d j + (l j) ^ 2 / 2 * B j +
          (l j) ^ 2 * ε j := by ring
      _ ≤ Δ j := hexp j
      _ ≤ 0 := hΔ j
  exact (mul_le_mul_iff_right₀ (hlpos j)).mp (by simpa using hs)

theorem positiveWeightFace {I : Type*} [Fintype I] {m d : I → ℝ}
    (hm : ∀ i, 0 ≤ m i) (hd : ∀ i, d i ≤ 0)
    (hcancel : ∑ i, m i * d i = 0) :
    ∀ i, 0 < m i → d i = 0 := by
  classical
  have hterm (i : I) : m i * d i ≤ 0 :=
    mul_nonpos_of_nonneg_of_nonpos (hm i) (hd i)
  intro i hi
  have hsingle : -(m i * d i) ≤ ∑ k, -(m k * d k) :=
    Finset.single_le_sum (fun k _ => neg_nonneg.mpr (hterm k))
      (Finset.mem_univ i)
  rw [Finset.sum_neg_distrib, hcancel, neg_zero] at hsingle
  have hprod : 0 ≤ m i * d i := by linarith
  have hdi : 0 ≤ d i := by nlinarith
  exact le_antisymm (hd i) hdi

theorem limitingPositiveWeightFace {I : Type*} [Fintype I]
    {m d : ℕ → I → ℝ} {m₀ d₀ : I → ℝ}
    (hm : ∀ i, Tendsto (fun j => m j i) atTop (𝓝 (m₀ i)))
    (hd : ∀ i, Tendsto (fun j => d j i) atTop (𝓝 (d₀ i)))
    (hmpos : ∀ j i, 0 ≤ m j i) (hdnonpos : ∀ i, d₀ i ≤ 0)
    (hcancel : ∀ j, ∑ i, m j i * d j i = 0) :
    ∀ i, 0 < m₀ i → d₀ i = 0 := by
  have hm₀ (i : I) : 0 ≤ m₀ i :=
    ge_of_tendsto (hm i) (Eventually.of_forall fun j => hmpos j i)
  have hc : Tendsto (fun j => ∑ i, m j i * d j i) atTop (𝓝 0) := by
    have heq : (fun j => ∑ i, m j i * d j i) = (fun _ => (0 : ℝ)) :=
      funext hcancel
    rw [heq]
    exact tendsto_const_nhds
  have hzero : (∑ i, m₀ i * d₀ i) = 0 :=
    tendsto_nhds_unique (finiteWeightedLimit hm hd) hc
  exact positiveWeightFace hm₀ hdnonpos hzero

section SmoothParameters
variable {E F P I : Type*}
  [NormedAddCommGroup E] [NormedSpace ℝ E]
  [NormedAddCommGroup F] [NormedSpace ℝ F]
  [NormedAddCommGroup P] [NormedSpace ℝ P]
  [Fintype I]

theorem smoothParameterCollisionImpossible {B : E × F → ℝ} {C : I → E × P → ℝ}
    {x₀ e : E} {y₀ : F} {a₀ : I → P} {β₀ : ℝ} {θ₀ : I → ℝ}
    (hB : ContDiffAt ℝ ∞ B (x₀, y₀))
    (hC : ∀ i, ContDiffAt ℝ ∞ (C i) (x₀, a₀ i))
    {x d : ℕ → E} {y : ℕ → F} {a : ℕ → I → P}
    {β l : ℕ → ℝ} {θ : ℕ → I → ℝ}
    (hx : Tendsto x atTop (𝓝 x₀)) (hd : Tendsto d atTop (𝓝 e))
    (hy : Tendsto y atTop (𝓝 y₀))
    (ha : ∀ i, Tendsto (fun j => a j i) atTop (𝓝 (a₀ i)))
    (hβ : Tendsto β atTop (𝓝 β₀))
    (hθ : ∀ i, Tendsto (fun j => θ j i) atTop (𝓝 (θ₀ i)))
    (hl : Tendsto l atTop (𝓝 0)) (hlpos : ∀ᶠ j in atTop, 0 < l j)
    (hθpos : ∀ᶠ j in atTop, ∀ i, 0 ≤ θ j i)
    (hineq : ∀ᶠ j in atTop, ∀ i,
      B (x j + l j • d j, y j) - B (x j, y j) -
        β j * (C i (x j + l j • d j, a j i) - C i (x j, a j i)) ≤ 0)
    (hcancel : ∀ᶠ j in atTop, ∑ i, θ j i *
      (fderiv ℝ B (x j, y j) (d j, 0) -
        β j * fderiv ℝ (C i) (x j, a j i) (d j, 0)) = 0)
    (hgap : 0 < ∑ i, θ₀ i *
      (fderiv ℝ (fderiv ℝ B) (x₀, y₀) (e, 0) (e, 0) -
        β₀ * fderiv ℝ (fderiv ℝ (C i)) (x₀, a₀ i) (e, 0) (e, 0))) :
    False := by
  have h := OAI.WeakMTWGlobalSupport.MovingTaylor.collision_limits
    hB hC hx hd hy ha hβ hθ hl hlpos hθpos hineq hcancel
  exact (not_lt_of_ge h.2) hgap

end SmoothParameters
end MovingActive

#print axioms MovingActive.movingFiniteCollisionImpossible
#print axioms MovingActive.barycentricCancellation
#print axioms MovingActive.limitingPositiveWeightFace
#print axioms MovingActive.vanishingWeightBounded
#print axioms MovingActive.smoothParameterCollisionImpossible
