import Mathlib

/- Pinned source: lean/OAI/GroupTheory/Thompson/Model.lean -/

namespace OAI

noncomputable section

open scoped ENNReal

universe uG

namespace ThompsonNonamenability

abbrev UnitInterval := Set.Icc (0 : ℝ) 1

def unitIntervalZero : UnitInterval := ⟨0, le_rfl, zero_le_one⟩
def unitIntervalOne : UnitInterval := ⟨1, zero_le_one, le_rfl⟩

structure IntervalHomeomorph where
  toHomeomorph : UnitInterval ≃ₜ UnitInterval

namespace IntervalHomeomorph

instance : CoeFun IntervalHomeomorph (fun _ => UnitInterval → UnitInterval) :=
  ⟨fun f => f.toHomeomorph⟩

end IntervalHomeomorph

def IsDyadic (x : ℝ) : Prop :=
  ∃ (k : ℤ) (n : ℕ), x = (k : ℝ) / (2 : ℝ) ^ n

structure DyadicPLWitness (f : IntervalHomeomorph) where
  pieceCount : ℕ
  positive : 0 < pieceCount
  knots : Fin (pieceCount + 1) → UnitInterval
  strictMono_knots : StrictMono knots
  first : knots 0 = unitIntervalZero
  last : knots (Fin.last pieceCount) = unitIntervalOne
  dyadic : ∀ i, IsDyadic (knots i : ℝ)
  cover : ∀ x : UnitInterval, ∃ i : Fin pieceCount,
    knots i.castSucc ≤ x ∧ x ≤ knots i.succ
  exponent : Fin pieceCount → ℤ
  affine : ∀ (i : Fin pieceCount) (x : UnitInterval),
    knots i.castSucc ≤ x → x ≤ knots i.succ →
    (f x : ℝ) = (f (knots i.castSucc) : ℝ) +
      (2 : ℝ) ^ exponent i * ((x : ℝ) - (knots i.castSucc : ℝ))

def HasDyadicPLPieces (f : IntervalHomeomorph) : Prop := Nonempty (DyadicPLWitness f)

def F := {f : IntervalHomeomorph // StrictMono f ∧ HasDyadicPLPieces f}

abbrev BoundedReal (G : Type uG) := lp (fun _ : G => ℝ) ∞

variable {G : Type uG} [Group G]

def leftPull (h : G) : BoundedReal G →ₗ[ℝ] BoundedReal G where
  toFun f := ⟨fun g => f (h * g), memℓp_infty ⟨‖f‖, by
    rintro y ⟨g, rfl⟩
    exact lp.norm_apply_le_norm ENNReal.top_ne_zero f (h * g)⟩⟩
  map_add' f g := by
    apply lp.ext
    funext x
    rfl
  map_smul' r f := by
    apply lp.ext
    funext x
    rfl

structure InvariantMean (G : Type uG) [Group G] where
  toLinearMap : BoundedReal G →ₗ[ℝ] ℝ
  positive : ∀ f : BoundedReal G, (∀ g, 0 ≤ f g) → 0 ≤ toLinearMap f
  normalized : toLinearMap 1 = 1
  left_invariant : ∀ (h : G) (f : BoundedReal G),
    toLinearMap (leftPull h f) = toLinearMap f

end ThompsonNonamenability

end

end OAI

/- Pinned source: lean/OAI/GroupTheory/Thompson/InvariantMean.lean -/

namespace OAI

/-!
# Positive normalized left-invariant means

The domain is the actual space of all bounded real functions on the group.
Continuity is a consequence of positivity and normalization, not an assumption.
-/

noncomputable section

open scoped ENNReal

universe uG

namespace ThompsonNonamenability

@[simp]
theorem BoundedReal.smul_one_apply {G : Type uG} (r : ℝ) (g : G) :
    (r • (1 : BoundedReal G)) g = r := by
  simp [lp.coeFn_smul, lp.infty_coeFn_one]

variable {G : Type uG} [Group G]

@[simp]
theorem leftPull_apply (h : G) (f : BoundedReal G) (g : G) :
    leftPull h f g = f (h * g) := rfl

@[simp]
theorem leftPull_one (f : BoundedReal G) : leftPull (1 : G) f = f := by
  apply lp.ext
  funext g
  simp

/-- Pullback reverses the order of the two left multiplications. -/
theorem leftPull_mul (h k : G) (f : BoundedReal G) :
    leftPull (h * k) f = leftPull k (leftPull h f) := by
  apply lp.ext
  funext g
  simp [mul_assoc]

namespace InvariantMean

instance : CoeFun (InvariantMean G) (fun _ => BoundedReal G → ℝ) :=
  ⟨fun M => M.toLinearMap⟩

@[simp]
theorem map_zero (M : InvariantMean G) : M 0 = 0 := M.toLinearMap.map_zero

@[simp]
theorem map_add (M : InvariantMean G) (f g : BoundedReal G) :
    M (f + g) = M f + M g := M.toLinearMap.map_add f g

@[simp]
theorem map_sub (M : InvariantMean G) (f g : BoundedReal G) :
    M (f - g) = M f - M g := M.toLinearMap.map_sub f g

@[simp]
theorem map_smul (M : InvariantMean G) (r : ℝ) (f : BoundedReal G) :
    M (r • f) = r * M f := by
  simpa only [smul_eq_mul] using M.toLinearMap.map_smul r f

/-- Evaluation of a constant function. -/
@[simp]
theorem map_const (M : InvariantMean G) (r : ℝ) :
    M (r • (1 : BoundedReal G)) = r := by
  rw [map_smul, M.normalized, mul_one]

/-- Positivity gives monotonicity for the pointwise order. -/
theorem mono (M : InvariantMean G) {f g : BoundedReal G}
    (hfg : ∀ x, f x ≤ g x) : M f ≤ M g := by
  have h := M.positive (g - f) (fun x => sub_nonneg.mpr (hfg x))
  rw [map_sub] at h
  exact sub_nonneg.mp h

/-- A mean has norm at most one, as a consequence of its defining axioms. -/
theorem abs_apply_le_norm (M : InvariantMean G) (f : BoundedReal G) :
    |M f| ≤ ‖f‖ := by
  have hbound (g : G) : -‖f‖ ≤ f g ∧ f g ≤ ‖f‖ := by
    apply abs_le.mp
    simpa only [Real.norm_eq_abs] using
      lp.norm_apply_le_norm ENNReal.top_ne_zero f g
  have hlo := M.mono (f := (-‖f‖) • (1 : BoundedReal G)) (g := f)
    (fun g => by simpa only [BoundedReal.smul_one_apply] using (hbound g).1)
  have hhi := M.mono (f := f) (g := ‖f‖ • (1 : BoundedReal G))
    (fun g => by simpa only [BoundedReal.smul_one_apply] using (hbound g).2)
  rw [map_const] at hlo hhi
  exact abs_le.mpr ⟨hlo, hhi⟩

/-- The continuous functional furnished automatically by a positive normalized mean. -/
def toContinuousLinearMap (M : InvariantMean G) : BoundedReal G →L[ℝ] ℝ :=
  M.toLinearMap.mkContinuous 1 (fun f => by
    simpa only [one_mul, Real.norm_eq_abs] using M.abs_apply_le_norm f)

@[simp]
theorem toContinuousLinearMap_apply (M : InvariantMean G) (f : BoundedReal G) :
    M.toContinuousLinearMap f = M f := rfl

theorem continuous (M : InvariantMean G) : Continuous M :=
  M.toContinuousLinearMap.continuous

theorem norm_toContinuousLinearMap_le_one (M : InvariantMean G) :
    ‖M.toContinuousLinearMap‖ ≤ 1 := by
  apply ContinuousLinearMap.opNorm_le_bound _ zero_le_one
  intro f
  simpa only [toContinuousLinearMap_apply, one_mul, Real.norm_eq_abs] using
    M.abs_apply_le_norm f

/-- Normalization makes the automatic functional's operator norm exactly one. -/
theorem norm_toContinuousLinearMap (M : InvariantMean G) :
    ‖M.toContinuousLinearMap‖ = 1 := by
  apply le_antisymm M.norm_toContinuousLinearMap_le_one
  have h := M.toContinuousLinearMap.le_opNorm (1 : BoundedReal G)
  simpa only [toContinuousLinearMap_apply, M.normalized, norm_one, mul_one] using h

end InvariantMean

end ThompsonNonamenability

end

end OAI

/- Pinned source: lean/OAI/GroupTheory/PolycyclicRecognition/Analysis/MeanSubgroup.lean -/

namespace OAI

/-!
# Restricting invariant means to subgroups

The finite-index height kernel in the recognition argument inherits amenability
from the ambient group. The construction below works for an arbitrary subgroup:
choose representatives for right cosets, construct an equivariant map to the subgroup,
and extend each bounded function by composition with this map.
-/

noncomputable section

namespace PolycyclicRecognition

open ThompsonNonamenability
open scoped ENNReal

universe u

variable {G : Type u} [Group G]

/-- The representative selected for the right coset containing `g`. -/
def rightCosetRepresentative (K : Subgroup G) (g : G) : G :=
  (Quotient.mk'' g : Quotient (QuotientGroup.rightRel K)).out

/-- A right-coset transversal gives an equivariant coordinate in the subgroup. -/
def subgroupCoordinate (K : Subgroup G) (g : G) : K :=
  ⟨g * (rightCosetRepresentative K g)⁻¹,
    QuotientGroup.rightRel_apply.mp
      (Quotient.exact' (Quotient.out_eq' (Quotient.mk'' g :
        Quotient (QuotientGroup.rightRel K))))⟩

/-- The subgroup coordinate intertwines the left action of the subgroup. -/
theorem subgroupCoordinate_mul (K : Subgroup G) (k : K) (g : G) :
    subgroupCoordinate K ((k : G) * g) = k * subgroupCoordinate K g := by
  have hq : (Quotient.mk'' ((k : G) * g) : Quotient (QuotientGroup.rightRel K)) =
      Quotient.mk'' g := by
    apply Quotient.sound'
    apply QuotientGroup.rightRel_apply.mpr
    simpa only [mul_inv_rev, mul_assoc, mul_inv_cancel_left] using K.inv_mem k.property
  apply Subtype.ext
  change (k : G) * g * (rightCosetRepresentative K ((k : G) * g))⁻¹ =
    (k : G) * (g * (rightCosetRepresentative K g)⁻¹)
  unfold rightCosetRepresentative
  rw [hq, mul_assoc]

/-- Extend a bounded subgroup function to the whole group by the equivariant coordinate. -/
def subgroupFunctionExtension (K : Subgroup G) : BoundedReal K →ₗ[ℝ] BoundedReal G where
  toFun f := ⟨fun g => f (subgroupCoordinate K g), memℓp_infty ⟨‖f‖, by
    rintro y ⟨g, rfl⟩
    exact lp.norm_apply_le_norm ENNReal.top_ne_zero f (subgroupCoordinate K g)⟩⟩
  map_add' f g := by
    apply lp.ext
    funext x
    rfl
  map_smul' r f := by
    apply lp.ext
    funext x
    rfl

@[simp]
theorem subgroupFunctionExtension_apply (K : Subgroup G) (f : BoundedReal K) (g : G) :
    subgroupFunctionExtension K f g = f (subgroupCoordinate K g) := rfl

@[simp]
theorem subgroupFunctionExtension_one (K : Subgroup G) :
    subgroupFunctionExtension K 1 = 1 := by
  apply lp.ext
  funext g
  rfl

/-- Equivariance makes extension commute with pullback by subgroup translations. -/
theorem subgroupFunctionExtension_leftPull (K : Subgroup G) (k : K) (f : BoundedReal K) :
    subgroupFunctionExtension K (leftPull k f) =
      leftPull (k : G) (subgroupFunctionExtension K f) := by
  apply lp.ext
  funext g
  change f (k * subgroupCoordinate K g) = f (subgroupCoordinate K ((k : G) * g))
  rw [subgroupCoordinate_mul]

/-- Every subgroup of a group with an invariant mean has an invariant mean. -/
def subgroupInvariantMean (M : InvariantMean G) (K : Subgroup G) : InvariantMean K where
  toLinearMap := M.toLinearMap.comp (subgroupFunctionExtension K)
  positive f hf := M.positive _ (fun g => hf (subgroupCoordinate K g))
  normalized := by
    change M.toLinearMap (subgroupFunctionExtension K 1) = 1
    rw [subgroupFunctionExtension_one]
    exact M.normalized
  left_invariant k f := by
    change M.toLinearMap (subgroupFunctionExtension K (leftPull k f)) =
      M.toLinearMap (subgroupFunctionExtension K f)
    rw [subgroupFunctionExtension_leftPull]
    exact M.left_invariant (k : G) (subgroupFunctionExtension K f)

end PolycyclicRecognition

end

end OAI

/- Pinned source: lean/OAI/GroupTheory/PolycyclicRecognition/Analysis/CoarseEquivalence.lean -/

namespace OAI

/-!
# Coarse equivalences of discrete groups

Finite subsets are the bounded sets in a word metric on a finitely generated
group. Controlling all finite sets of differences is the metric-free form of
being bornologous. For finitely generated groups, a coarse equivalence in this
sense is a quasi-isometry. It also matches the coarse-equivalence formulation
of Li's finiteness and duality theorems.
-/

namespace PolycyclicRecognition

open scoped Pointwise

variable {G H J : Type*} [Group G] [Group H] [Group J]

/-- Uniform control of bounded differences, for the discrete group coarse structure. -/
def GroupBornologous (f : G → H) : Prop :=
  ∀ S : Set G, S.Finite → ∃ T : Set H, T.Finite ∧
    ∀ x y, x⁻¹ * y ∈ S → (f x)⁻¹ * f y ∈ T

theorem groupBornologous_hom (f : G →* H) : GroupBornologous f := by
  intro S hS
  refine ⟨f '' S, hS.image f, fun x y hxy => ?_⟩
  exact ⟨x⁻¹ * y, hxy, by simp⟩

theorem GroupBornologous.comp {f : G → H} {g : H → J}
    (hg : GroupBornologous g) (hf : GroupBornologous f) :
    GroupBornologous (g ∘ f) := by
  intro S hS
  obtain ⟨T, hT, hfT⟩ := hf S hS
  obtain ⟨U, hU, hgU⟩ := hg T hT
  exact ⟨U, hU, fun x y hxy => hgU (f x) (f y) (hfT x y hxy)⟩

/-- Coarse inverse maps with uniformly bounded errors, measured by finite
sets of group differences. -/
structure GroupCoarseEquivalence (G H : Type*) [Group G] [Group H] where
  toFun : G → H
  invFun : H → G
  bornologous_toFun : GroupBornologous toFun
  bornologous_invFun : GroupBornologous invFun
  left_error : (Set.range fun x => x⁻¹ * invFun (toFun x)).Finite
  right_error : (Set.range fun y => y⁻¹ * toFun (invFun y)).Finite

namespace GroupCoarseEquivalence

/-- Coarse inverses force finite fibers; this is the properness condition in
the discrete-group definition of a coarse map. -/
theorem finite_fiber (e : GroupCoarseEquivalence G H) (y : H) :
    (e.toFun ⁻¹' {y}).Finite := by
  apply (e.left_error.image (fun a => e.invFun y * a⁻¹)).subset
  intro x hx
  have hxy : e.toFun x = y := hx
  refine ⟨x⁻¹ * e.invFun y, ?_, ?_⟩
  · exact ⟨x, by dsimp only; rw [hxy]⟩
  · simp

def symm (e : GroupCoarseEquivalence G H) : GroupCoarseEquivalence H G where
  toFun := e.invFun
  invFun := e.toFun
  bornologous_toFun := e.bornologous_invFun
  bornologous_invFun := e.bornologous_toFun
  left_error := e.right_error
  right_error := e.left_error

omit [Group J] in
private theorem composite_error (f : G → H) (g : H → G) (f' : H → J) (g' : J → H)
    (hg : GroupBornologous g)
    (h : (Set.range fun x => x⁻¹ * g (f x)).Finite)
    (h' : (Set.range fun y => y⁻¹ * g' (f' y)).Finite) :
    (Set.range fun x => x⁻¹ * g (g' (f' (f x)))).Finite := by
  obtain ⟨T, hT, hgT⟩ := hg _ h'
  apply (h.mul hT).subset
  rintro _ ⟨x, rfl⟩
  refine ⟨x⁻¹ * g (f x), ⟨x, rfl⟩,
    (g (f x))⁻¹ * g (g' (f' (f x))), ?_, ?_⟩
  · exact hgT (f x) (g' (f' (f x))) ⟨f x, rfl⟩
  · simp [mul_assoc]

def trans (e : GroupCoarseEquivalence G H) (e' : GroupCoarseEquivalence H J) :
    GroupCoarseEquivalence G J where
  toFun := e'.toFun ∘ e.toFun
  invFun := e.invFun ∘ e'.invFun
  bornologous_toFun := e'.bornologous_toFun.comp e.bornologous_toFun
  bornologous_invFun := e.bornologous_invFun.comp e'.bornologous_invFun
  left_error := composite_error e.toFun e.invFun e'.toFun e'.invFun
    e.bornologous_invFun e.left_error e'.left_error
  right_error := composite_error e'.invFun e'.toFun e.invFun e.toFun
    e'.bornologous_toFun e'.right_error e.right_error

end GroupCoarseEquivalence

theorem finite_rightCosetRepresentatives (K : Subgroup G) [K.FiniteIndex] :
    (Set.range (rightCosetRepresentative K)).Finite := by
  have : Finite (Quotient (QuotientGroup.rightRel K)) :=
    Finite.of_equiv (G ⧸ K) (QuotientGroup.quotientRightRelEquivQuotientLeftRel K).symm
  apply (Set.finite_range (fun q : Quotient (QuotientGroup.rightRel K) => q.out)).subset
  rintro _ ⟨g, rfl⟩
  exact ⟨Quotient.mk'' g, rfl⟩

theorem groupBornologous_subgroupCoordinate (K : Subgroup G) [K.FiniteIndex] :
    GroupBornologous (subgroupCoordinate K) := by
  intro S hS
  let R := Set.range (rightCosetRepresentative K)
  have hR : R.Finite := finite_rightCosetRepresentatives K
  let T := R * S * R⁻¹
  have hT : T.Finite := (hR.mul hS).mul hR.inv
  refine ⟨K.subtype ⁻¹' T, hT.preimage (fun _ _ _ _ h => Subtype.val_injective h), ?_⟩
  intro x y hxy
  change ((subgroupCoordinate K x : G))⁻¹ * (subgroupCoordinate K y : G) ∈ T
  have heq : ((subgroupCoordinate K x : G))⁻¹ * (subgroupCoordinate K y : G) =
      rightCosetRepresentative K x * (x⁻¹ * y) * (rightCosetRepresentative K y)⁻¹ := by
    simp [subgroupCoordinate, mul_assoc]
  rw [heq]
  refine ⟨_, ⟨_, ⟨x, rfl⟩, _, hxy, rfl⟩, _, ?_, rfl⟩
  simpa only [Set.mem_inv, inv_inv] using
    (show rightCosetRepresentative K y ∈ R from ⟨y, rfl⟩)

/-- Finite-index subgroups are coarsely equivalent to their ambient groups.
The coordinate map uses a finite right-coset transversal. -/
noncomputable def finiteIndexCoarseEquivalence (K : Subgroup G) [K.FiniteIndex] :
    GroupCoarseEquivalence K G where
  toFun := K.subtype
  invFun := subgroupCoordinate K
  bornologous_toFun := groupBornologous_hom K.subtype
  bornologous_invFun := groupBornologous_subgroupCoordinate K
  left_error := by
    let R := Set.range (rightCosetRepresentative K)
    have hR : R.Finite := finite_rightCosetRepresentatives K
    apply (hR.inv.preimage (fun _ _ _ _ h => Subtype.val_injective h)).subset
    rintro _ ⟨x, rfl⟩
    change (x : G)⁻¹ * ((x : G) * (rightCosetRepresentative K x)⁻¹) ∈ R⁻¹
    simpa only [inv_mul_cancel_left, Set.mem_inv, inv_inv] using
      (show rightCosetRepresentative K x ∈ R from ⟨x, rfl⟩)
  right_error := by
    apply (finite_rightCosetRepresentatives K).inv.subset
    rintro _ ⟨y, rfl⟩
    change y⁻¹ * (y * (rightCosetRepresentative K y)⁻¹) ∈ _
    simpa only [inv_mul_cancel_left, Set.mem_inv, inv_inv] using
      (show rightCosetRepresentative K y ∈ Set.range (rightCosetRepresentative K)
        from ⟨y, rfl⟩)

end PolycyclicRecognition

end OAI

/- Pinned source: lean/OAI/GroupTheory/PolycyclicRecognition/Analysis/MetricCoarseBridge.lean -/

namespace OAI

/-!
# Metric quasi-isometries and the discrete group coarse structure

The finiteness and duality endgame uses finite sets of group differences.
Here an actual metric quasi-isometry supplies that data. The metrics are
left invariant and their bounded identity balls are finite, as for word
metrics on finitely generated groups. No recognition theorem is assumed.
-/

noncomputable section

namespace PolycyclicRecognition

open Metric

variable {G H : Type*} [Group G] [Group H]
  [MetricSpace G] [MetricSpace H]
  [IsIsometricSMul G G] [IsIsometricSMul H H]

/-- Left invariance measures a group difference by the distance between its
two endpoints. -/
theorem dist_one_groupDifference (x y : G) : dist 1 (x⁻¹ * y) = dist x y := by
  simpa using (dist_mul_left x⁻¹ x y)

/-- An upper coarse Lipschitz inequality sends each finite set of group
differences into a finite identity ball. -/
theorem groupBornologous_of_metric_bound (f : G → H)
    (hfinite : ∀ R : ℝ, (closedBall (1 : H) R).Finite)
    {K C : ℝ} (hK : 0 ≤ K)
    (hupper : ∀ x y, dist (f x) (f y) ≤ K * dist x y + C) :
    GroupBornologous f := by
  intro S hS
  obtain ⟨R, hR⟩ := (isBounded_iff_subset_closedBall (1 : G)).mp hS.isBounded
  refine ⟨closedBall (1 : H) (K * R + C), hfinite _, ?_⟩
  intro x y hxy
  have hdist : dist x y ≤ R := by
    have h := hR hxy
    simpa only [mem_closedBall, dist_comm (x⁻¹ * y), dist_one_groupDifference] using h
  change dist ((f x)⁻¹ * f y) 1 ≤ _
  rw [dist_comm, dist_one_groupDifference]
  exact (hupper x y).trans (add_le_add (mul_le_mul_of_nonneg_left hdist hK) le_rfl)

/-- Uniformly bounded metric displacement is a finite set of group errors. -/
theorem finite_groupDifference_range_of_metric_bound (r : G → G)
    (hfinite : ∀ R : ℝ, (closedBall (1 : G) R).Finite)
    {E : ℝ} (herror : ∀ x, dist x (r x) ≤ E) :
    (Set.range fun x => x⁻¹ * r x).Finite := by
  apply (hfinite E).subset
  rintro _ ⟨x, rfl⟩
  simpa only [mem_closedBall, dist_comm (x⁻¹ * r x), dist_one_groupDifference]
    using herror x

/-- Coarse inverse metric maps produce the concrete equivalence used by
Li's group-cohomological invariance theorems. -/
def groupCoarseEquivalenceOfMetricInverse (f : G → H) (r : H → G)
    (hfiniteG : ∀ R : ℝ, (closedBall (1 : G) R).Finite)
    (hfiniteH : ∀ R : ℝ, (closedBall (1 : H) R).Finite)
    {K C K' C' E E' : ℝ} (hK : 0 ≤ K) (hK' : 0 ≤ K')
    (hf : ∀ x y, dist (f x) (f y) ≤ K * dist x y + C)
    (hr : ∀ x y, dist (r x) (r y) ≤ K' * dist x y + C')
    (hleft : ∀ x, dist x (r (f x)) ≤ E)
    (hright : ∀ y, dist y (f (r y)) ≤ E') :
    GroupCoarseEquivalence G H where
  toFun := f
  invFun := r
  bornologous_toFun := groupBornologous_of_metric_bound f hfiniteH hK hf
  bornologous_invFun := groupBornologous_of_metric_bound r hfiniteG hK' hr
  left_error := finite_groupDifference_range_of_metric_bound (r ∘ f) hfiniteG hleft
  right_error := finite_groupDifference_range_of_metric_bound (f ∘ r) hfiniteH hright

/-- A metric quasi-isometry yields an actual discrete-group coarse
equivalence. The inverse is chosen from coarse surjectivity, and all its
control estimates are derived from the lower inequality. -/
def groupCoarseEquivalenceOfQuasiIsometry (f : G → H)
    (hfiniteG : ∀ R : ℝ, (closedBall (1 : G) R).Finite)
    (hfiniteH : ∀ R : ℝ, (closedBall (1 : H) R).Finite)
    {K C K' C' E : ℝ} (hK : 0 ≤ K) (hK' : 0 ≤ K')
    (hupper : ∀ x y, dist (f x) (f y) ≤ K * dist x y + C)
    (hlower : ∀ x y, dist x y ≤ K' * dist (f x) (f y) + C')
    (hsurj : ∀ y, ∃ x, dist y (f x) ≤ E) : GroupCoarseEquivalence G H := by
  choose r hr using hsurj
  refine groupCoarseEquivalenceOfMetricInverse f r hfiniteG hfiniteH hK hK'
    hupper (C' := K' * (E + E) + C') (E := K' * E + C') (E' := E) ?_ ?_ hr
  · intro x y
    have hdist : dist (f (r x)) (f (r y)) ≤ dist x y + (E + E) := by
      calc
        dist (f (r x)) (f (r y)) ≤
            dist (f (r x)) x + dist x y + dist y (f (r y)) :=
          dist_triangle4 _ _ _ _
        _ ≤ E + dist x y + E := by
          gcongr
          exact (dist_comm (f (r x)) x).trans_le (hr x)
          exact hr y
        _ = dist x y + (E + E) := by ring
    calc
      dist (r x) (r y) ≤ K' * dist (f (r x)) (f (r y)) + C' := hlower _ _
      _ ≤ K' * (dist x y + (E + E)) + C' := by gcongr
      _ = K' * dist x y + (K' * (E + E) + C') := by ring
  · intro x
    exact (hlower x (r (f x))).trans
      (add_le_add (mul_le_mul_of_nonneg_left (hr (f x)) hK') le_rfl)

end PolycyclicRecognition

end

end OAI

/- Pinned source: lean/OAI/GroupTheory/PolycyclicRecognition/Analysis/LinearMetricChains.lean -/

namespace OAI

/-!
# Linear metric chains and coarse Lipschitz bounds

An explicit large-scale geodesic condition allows one to sum local bounds
along a chain. For continuous homomorphisms out of proper metric groups,
the local bound comes from compactness. This is the elementary metric step
in the proper cocompact homomorphism form of the Milnor--Švarc argument.
-/

noncomputable section

namespace PolycyclicRecognition

open Metric Set

/-- Chains joining any two points with bounded step size and a linear bound
on the number of steps, including their vertices and endpoint identities. -/
structure LinearMetricChains (X : Type*) [PseudoMetricSpace X] where
  step : ℝ
  step_pos : 0 < step
  slope : ℝ
  slope_nonneg : 0 ≤ slope
  error : ℝ
  error_nonneg : 0 ≤ error
  chain : ∀ x y : X, ∃ (n : ℕ) (p : ℕ → X),
    p 0 = x ∧ p n = y ∧ (n : ℝ) ≤ slope * dist x y + error ∧
      ∀ i < n, dist (p i) (p (i + 1)) ≤ step

variable {X Y : Type*} [PseudoMetricSpace X] [PseudoMetricSpace Y]

/-- A uniform bound on single steps becomes an affine metric bound by
summing along the actual chains. -/
theorem LinearMetricChains.coarseLipschitz (C : LinearMetricChains X) (f : X → Y)
    {D : ℝ} (hD : 0 ≤ D)
    (hstep : ∀ x y, dist x y ≤ C.step → dist (f x) (f y) ≤ D) :
    ∀ x y, dist (f x) (f y) ≤ (D * C.slope) * dist x y + D * C.error := by
  intro x y
  obtain ⟨n, p, hp0, hpn, hn, hp⟩ := C.chain x y
  have hdist : dist (f (p 0)) (f (p n)) ≤ (n : ℝ) * D := by
    calc
      dist (f (p 0)) (f (p n)) ≤
          ∑ i ∈ Finset.range n, dist (f (p i)) (f (p (i + 1))) :=
        dist_le_range_sum_dist (f ∘ p) n
      _ ≤ ∑ _i ∈ Finset.range n, D := by
        exact Finset.sum_le_sum (fun i hi => hstep _ _ (hp i (Finset.mem_range.mp hi)))
      _ = (n : ℝ) * D := by simp
  rw [hp0, hpn] at hdist
  calc
    dist (f x) (f y) ≤ (n : ℝ) * D := hdist
    _ ≤ (C.slope * dist x y + C.error) * D := mul_le_mul_of_nonneg_right hn hD
    _ = (D * C.slope) * dist x y + D * C.error := by ring

variable {G H : Type*} [Group G] [Group H] [MetricSpace G] [MetricSpace H]
  [IsIsometricSMul G G] [IsIsometricSMul H H]

/-- A continuous homomorphism out of a proper metric group has uniformly
bounded image displacement on any bounded source step. -/
theorem continuousHom_bounded_metric_steps [ProperSpace G]
    (f : G →* H) (hf : Continuous f) (R : ℝ) :
    ∃ D : ℝ, 0 ≤ D ∧ ∀ x y, dist x y ≤ R → dist (f x) (f y) ≤ D := by
  obtain ⟨D, hD⟩ := (isCompact_closedBall (1 : G) R).bddAbove_image
    (continuous_const.dist hf).continuousOn
  refine ⟨max D 0, le_max_right _ _, fun x y hxy => ?_⟩
  have hmem : x⁻¹ * y ∈ closedBall (1 : G) R := by
    simpa only [mem_closedBall, dist_comm (x⁻¹ * y), dist_one_groupDifference] using hxy
  have hb : dist (1 : H) (f (x⁻¹ * y)) ≤ D := hD (mem_image_of_mem _ hmem)
  rw [map_mul, map_inv, dist_one_groupDifference] at hb
  exact hb.trans (le_max_left _ _)

/-- The homomorphism's affine bound requires only compactness and the
explicit linear chains; no global differentiability estimate is needed. -/
theorem continuousHom_coarseLipschitz [ProperSpace G] (C : LinearMetricChains G)
    (f : G →* H) (hf : Continuous f) :
    ∃ K B : ℝ, 0 ≤ K ∧ 0 ≤ B ∧
      ∀ x y, dist (f x) (f y) ≤ K * dist x y + B := by
  obtain ⟨D, hD, hstep⟩ := continuousHom_bounded_metric_steps f hf C.step
  exact ⟨D * C.slope, D * C.error,
    mul_nonneg hD C.slope_nonneg, mul_nonneg hD C.error_nonneg,
    C.coarseLipschitz f hD hstep⟩

end PolycyclicRecognition

end

end OAI

/- Pinned source: lean/OAI/GroupTheory/PolycyclicRecognition/Analysis/ProperCocompactMetric.lean -/

namespace OAI

/-!
# Metric comparison through a proper cocompact homomorphism

Properness bounds preimages of target balls. A coarse section and explicit
linear metric chains then give the lower quasi-isometry inequality. Together
with the continuous-homomorphism upper bound this is the metric part of the
Milnor--Švarc comparison, proved here without a recognition hypothesis.
-/

noncomputable section

namespace PolycyclicRecognition

open Metric Set

variable {G H : Type*} [Group G] [Group H] [MetricSpace G] [MetricSpace H]
  [IsIsometricSMul G G] [IsIsometricSMul H H]

/-- A proper homomorphism has uniformly bounded preimages of bounded
group differences. Compactness of the kernel is included in this argument. -/
theorem properHom_bounded_preimage_steps [ProperSpace H]
    (f : G →* H) (hproper : IsProperMap f) (R : ℝ) :
    ∃ D : ℝ, 0 ≤ D ∧ ∀ x y, dist (f x) (f y) ≤ R → dist x y ≤ D := by
  have hcompact := hproper.isCompact_preimage (isCompact_closedBall (1 : H) R)
  obtain ⟨D, hD⟩ := hcompact.bddAbove_image (continuous_const.dist continuous_id).continuousOn
  refine ⟨max D 0, le_max_right _ _, fun x y hxy => ?_⟩
  have hmem : x⁻¹ * y ∈ f ⁻¹' closedBall (1 : H) R := by
    change dist (f (x⁻¹ * y)) 1 ≤ R
    rw [map_mul, map_inv, dist_comm, dist_one_groupDifference]
    exact hxy
  have hb : dist (1 : G) (x⁻¹ * y) ≤ D := hD (mem_image_of_mem _ hmem)
  rw [dist_one_groupDifference] at hb
  exact hb.trans (le_max_left _ _)

omit [MetricSpace G] [IsIsometricSMul G G] in
/-- Cocompactness, expressed as a compact cover of right image cosets,
gives the metric coarse-surjectivity radius. -/
theorem compact_image_cover_coarsely_surjective (f : G →* H)
    (K : Set H) (hK : IsCompact K)
    (hcover : ∀ h : H, ∃ (g : G) (k : H), k ∈ K ∧ f g * k = h) :
    ∃ E : ℝ, 0 ≤ E ∧ ∀ h : H, ∃ g : G, dist h (f g) ≤ E := by
  obtain ⟨R, hR⟩ := hK.isBounded.subset_closedBall (1 : H)
  refine ⟨max R 0, le_max_right _ _, fun h => ?_⟩
  obtain ⟨g, k, hk, rfl⟩ := hcover h
  refine ⟨g, ?_⟩
  have hkR : dist k 1 ≤ R := hR hk
  calc
    dist (f g * k) (f g) = dist k 1 := by simpa only [mul_one] using dist_mul_left (f g) k 1
    _ ≤ max R 0 := hkR.trans (le_max_left _ _)

/-- The lower quasi-isometry inequality is a consequence of properness,
coarse surjectivity, and target chains. No injectivity is required. -/
theorem properHom_coarse_lower [ProperSpace H] (C : LinearMetricChains H)
    (f : G →* H) (hproper : IsProperMap f) {E : ℝ}
    (hsurj : ∀ h, ∃ g, dist h (f g) ≤ E) :
    ∃ A B : ℝ, 0 ≤ A ∧ 0 ≤ B ∧
      ∀ x y, dist x y ≤ A * dist (f x) (f y) + B := by
  choose r hr using hsurj
  obtain ⟨D, hD, hpre⟩ := properHom_bounded_preimage_steps f hproper (E + C.step + E)
  obtain ⟨L, hL, herror⟩ := properHom_bounded_preimage_steps f hproper E
  have hstep : ∀ x y : H, dist x y ≤ C.step → dist (r x) (r y) ≤ D := by
    intro x y hxy
    apply hpre
    calc
      dist (f (r x)) (f (r y)) ≤
          dist (f (r x)) x + dist x y + dist y (f (r y)) := dist_triangle4 _ _ _ _
      _ ≤ E + C.step + E := by
        exact add_le_add (add_le_add ((dist_comm (f (r x)) x).trans_le (hr x)) hxy) (hr y)
  have hrbound := C.coarseLipschitz r hD hstep
  have herr (x : G) : dist x (r (f x)) ≤ L := herror x (r (f x)) (hr (f x))
  refine ⟨D * C.slope, D * C.error + (L + L),
    mul_nonneg hD C.slope_nonneg,
    add_nonneg (mul_nonneg hD C.error_nonneg) (add_nonneg hL hL), fun x y => ?_⟩
  calc
    dist x y ≤ dist x (r (f x)) + dist (r (f x)) (r (f y)) + dist (r (f y)) y :=
      dist_triangle4 _ _ _ _
    _ ≤ L + ((D * C.slope) * dist (f x) (f y) + D * C.error) + L := by
      exact add_le_add (add_le_add (herr x) (hrbound (f x) (f y)))
        ((dist_comm (r (f y)) y).trans_le (herr y))
    _ = (D * C.slope) * dist (f x) (f y) + (D * C.error + (L + L)) := by ring

/-- A continuous proper homomorphism with compact image-coset cover is a
metric quasi-isometry when both metrics have the stated linear chains. -/
theorem proper_cocompact_hom_quasiIsometry [ProperSpace G] [ProperSpace H]
    (CG : LinearMetricChains G) (CH : LinearMetricChains H)
    (f : G →* H) (hf : Continuous f) (hproper : IsProperMap f)
    (K : Set H) (hK : IsCompact K)
    (hcover : ∀ h : H, ∃ (g : G) (k : H), k ∈ K ∧ f g * k = h) :
    ∃ A B A' B' E : ℝ, 0 ≤ A ∧ 0 ≤ B ∧ 0 ≤ A' ∧ 0 ≤ B' ∧ 0 ≤ E ∧
      (∀ x y, dist (f x) (f y) ≤ A * dist x y + B) ∧
      (∀ x y, dist x y ≤ A' * dist (f x) (f y) + B') ∧
      (∀ h, ∃ g, dist h (f g) ≤ E) := by
  obtain ⟨E, hE, hsurj⟩ := compact_image_cover_coarsely_surjective f K hK hcover
  obtain ⟨A, B, hA, hB, hupper⟩ := continuousHom_coarseLipschitz CG f hf
  obtain ⟨A', B', hA', hB', hlower⟩ := properHom_coarse_lower CH f hproper hsurj
  exact ⟨A, B, A', B', E, hA, hB, hA', hB', hE, hupper, hlower, hsurj⟩

end PolycyclicRecognition

end

end OAI

/- Pinned source: lean/OAI/GroupTheory/PolycyclicRecognition/Analysis/MetricQuasiEquivalence.lean -/

namespace OAI

/-!
# Composing the metric comparisons in a Lie-model reduction

The proper cocompact homomorphism reduction has arrows in both directions.
We keep actual coarse inverse maps and their affine bounds, so that the
three-arrow zigzag can be composed without assuming a recognition result.
-/

noncomputable section

namespace PolycyclicRecognition

/-- Actual coarse inverse maps with affine metric bounds in both directions. -/
structure MetricQuasiEquivalence (X Y : Type*) [PseudoMetricSpace X] [PseudoMetricSpace Y] where
  toFun : X → Y
  invFun : Y → X
  toFun_control : ∃ K C : ℝ, 0 ≤ K ∧ 0 ≤ C ∧
    ∀ x y, dist (toFun x) (toFun y) ≤ K * dist x y + C
  invFun_control : ∃ K C : ℝ, 0 ≤ K ∧ 0 ≤ C ∧
    ∀ x y, dist (invFun x) (invFun y) ≤ K * dist x y + C
  left_close : ∃ E : ℝ, 0 ≤ E ∧ ∀ x, dist x (invFun (toFun x)) ≤ E
  right_close : ∃ E : ℝ, 0 ≤ E ∧ ∀ y, dist y (toFun (invFun y)) ≤ E

namespace MetricQuasiEquivalence

variable {X Y Z : Type*} [PseudoMetricSpace X] [PseudoMetricSpace Y] [PseudoMetricSpace Z]

/-- Reverse a comparison using its specified coarse inverse. -/
def symm (e : MetricQuasiEquivalence X Y) : MetricQuasiEquivalence Y X where
  toFun := e.invFun
  invFun := e.toFun
  toFun_control := e.invFun_control
  invFun_control := e.toFun_control
  left_close := e.right_close
  right_close := e.left_close

/-- Compose actual comparisons, including explicit bounds for the errors
of their composite inverse maps. -/
def trans (e : MetricQuasiEquivalence X Y) (e' : MetricQuasiEquivalence Y Z) :
    MetricQuasiEquivalence X Z where
  toFun := e'.toFun ∘ e.toFun
  invFun := e.invFun ∘ e'.invFun
  toFun_control := by
    obtain ⟨K, C, hK, hC, hf⟩ := e.toFun_control
    obtain ⟨K', C', hK', hC', hf'⟩ := e'.toFun_control
    refine ⟨K' * K, K' * C + C', mul_nonneg hK' hK,
      add_nonneg (mul_nonneg hK' hC) hC', fun x y => ?_⟩
    calc
      dist (e'.toFun (e.toFun x)) (e'.toFun (e.toFun y))
          ≤ K' * dist (e.toFun x) (e.toFun y) + C' := hf' _ _
      _ ≤ K' * (K * dist x y + C) + C' := by gcongr; exact hf x y
      _ = (K' * K) * dist x y + (K' * C + C') := by ring
  invFun_control := by
    obtain ⟨K, C, hK, hC, hf⟩ := e.invFun_control
    obtain ⟨K', C', hK', hC', hf'⟩ := e'.invFun_control
    refine ⟨K * K', K * C' + C, mul_nonneg hK hK',
      add_nonneg (mul_nonneg hK hC') hC, fun x y => ?_⟩
    calc
      dist (e.invFun (e'.invFun x)) (e.invFun (e'.invFun y))
          ≤ K * dist (e'.invFun x) (e'.invFun y) + C := hf _ _
      _ ≤ K * (K' * dist x y + C') + C := by gcongr; exact hf' x y
      _ = (K * K') * dist x y + (K * C' + C) := by ring
  left_close := by
    obtain ⟨E, hE, he⟩ := e.left_close
    obtain ⟨E', hE', he'⟩ := e'.left_close
    obtain ⟨K, C, hK, hC, hf⟩ := e.invFun_control
    refine ⟨E + (K * E' + C), add_nonneg hE (add_nonneg (mul_nonneg hK hE') hC),
      fun x => ?_⟩
    calc
      dist x (e.invFun (e'.invFun (e'.toFun (e.toFun x))))
          ≤ dist x (e.invFun (e.toFun x)) +
              dist (e.invFun (e.toFun x))
                (e.invFun (e'.invFun (e'.toFun (e.toFun x)))) := dist_triangle _ _ _
      _ ≤ E + (K * E' + C) := by
        exact add_le_add (he x) ((hf _ _).trans
          (add_le_add (mul_le_mul_of_nonneg_left (he' (e.toFun x)) hK) le_rfl))
  right_close := by
    obtain ⟨E, hE, he⟩ := e.right_close
    obtain ⟨E', hE', he'⟩ := e'.right_close
    obtain ⟨K, C, hK, hC, hf⟩ := e'.toFun_control
    refine ⟨E' + (K * E + C), add_nonneg hE' (add_nonneg (mul_nonneg hK hE) hC),
      fun y => ?_⟩
    calc
      dist y (e'.toFun (e.toFun (e.invFun (e'.invFun y))))
          ≤ dist y (e'.toFun (e'.invFun y)) +
              dist (e'.toFun (e'.invFun y))
                (e'.toFun (e.toFun (e.invFun (e'.invFun y)))) := dist_triangle _ _ _
      _ ≤ E' + (K * E + C) := by
        exact add_le_add (he' y) ((hf _ _).trans
          (add_le_add (mul_le_mul_of_nonneg_left (he (e'.invFun y)) hK) le_rfl))

/-- Choose a coarse inverse from the coarse-surjectivity part of a
quasi-isometry, and prove its affine bound using the lower inequality. -/
def ofQuasiIsometry (f : X → Y) {K C K' C' E : ℝ}
    (hK : 0 ≤ K) (hC : 0 ≤ C) (hK' : 0 ≤ K') (hC' : 0 ≤ C') (hE : 0 ≤ E)
    (hupper : ∀ x y, dist (f x) (f y) ≤ K * dist x y + C)
    (hlower : ∀ x y, dist x y ≤ K' * dist (f x) (f y) + C')
    (hsurj : ∀ y, ∃ x, dist y (f x) ≤ E) : MetricQuasiEquivalence X Y := by
  choose r hr using hsurj
  refine ⟨f, r, ⟨K, C, hK, hC, hupper⟩, ?_, ?_, ⟨E, hE, hr⟩⟩
  · refine ⟨K', K' * (E + E) + C', hK',
      add_nonneg (mul_nonneg hK' (add_nonneg hE hE)) hC', fun x y => ?_⟩
    have hd : dist (f (r x)) (f (r y)) ≤ dist x y + (E + E) := by
      calc
        dist (f (r x)) (f (r y)) ≤
            dist (f (r x)) x + dist x y + dist y (f (r y)) := dist_triangle4 _ _ _ _
        _ ≤ E + dist x y + E := by
          exact add_le_add (add_le_add ((dist_comm _ _).trans_le (hr x)) le_rfl) (hr y)
        _ = dist x y + (E + E) := by ring
    calc
      dist (r x) (r y) ≤ K' * dist (f (r x)) (f (r y)) + C' := hlower _ _
      _ ≤ K' * (dist x y + (E + E)) + C' := by gcongr
      _ = K' * dist x y + (K' * (E + E) + C') := by ring
  · refine ⟨K' * E + C', add_nonneg (mul_nonneg hK' hE) hC', fun x => ?_⟩
    exact (hlower x (r (f x))).trans
      (add_le_add (mul_le_mul_of_nonneg_left (hr (f x)) hK') le_rfl)

/-- Recover the usual inequalities from actual coarse inverse maps. -/
theorem quasiIsometry_toFun (e : MetricQuasiEquivalence X Y) :
    ∃ K C K' C' E : ℝ, 0 ≤ K ∧ 0 ≤ C ∧ 0 ≤ K' ∧ 0 ≤ C' ∧ 0 ≤ E ∧
      (∀ x y, dist (e.toFun x) (e.toFun y) ≤ K * dist x y + C) ∧
      (∀ x y, dist x y ≤ K' * dist (e.toFun x) (e.toFun y) + C') ∧
      (∀ y, ∃ x, dist y (e.toFun x) ≤ E) := by
  obtain ⟨K, C, hK, hC, hf⟩ := e.toFun_control
  obtain ⟨K', C', hK', hC', hr⟩ := e.invFun_control
  obtain ⟨L, hL, hl⟩ := e.left_close
  obtain ⟨E, hE, he⟩ := e.right_close
  refine ⟨K, C, K', C' + (L + L), E, hK, hC, hK',
    add_nonneg hC' (add_nonneg hL hL), hE, hf, ?_, fun y => ⟨e.invFun y, he y⟩⟩
  intro x y
  calc
    dist x y ≤ dist x (e.invFun (e.toFun x)) +
        dist (e.invFun (e.toFun x)) (e.invFun (e.toFun y)) +
          dist (e.invFun (e.toFun y)) y := dist_triangle4 _ _ _ _
    _ ≤ L + (K' * dist (e.toFun x) (e.toFun y) + C') + L := by
      exact add_le_add (add_le_add (hl x) (hr _ _)) ((dist_comm _ _).trans_le (hl y))
    _ = K' * dist (e.toFun x) (e.toFun y) + (C' + (L + L)) := by ring

end MetricQuasiEquivalence

/-- Coarse inverse maps for a proper cocompact homomorphism, suitable for
composition along the model zigzag. -/
theorem nonempty_metricQuasiEquivalence_of_proper_cocompact_hom
    {G H : Type*} [Group G] [Group H] [MetricSpace G] [MetricSpace H]
    [IsIsometricSMul G G] [IsIsometricSMul H H] [ProperSpace G] [ProperSpace H]
    (CG : LinearMetricChains G) (CH : LinearMetricChains H)
    (f : G →* H) (hf : Continuous f) (hproper : IsProperMap f)
    (K : Set H) (hK : IsCompact K)
    (hcover : ∀ h : H, ∃ (g : G) (k : H), k ∈ K ∧ f g * k = h) :
    Nonempty (MetricQuasiEquivalence G H) := by
  obtain ⟨A, B, A', B', E, hA, hB, hA', hB', hE, hup, hlo, hsurj⟩ :=
    proper_cocompact_hom_quasiIsometry CG CH f hf hproper K hK hcover
  exact ⟨MetricQuasiEquivalence.ofQuasiIsometry f hA hB hA' hB' hE hup hlo hsurj⟩

end PolycyclicRecognition

end

end OAI

/- Pinned source: lean/OAI/GroupTheory/PolycyclicRecognition/Analysis/CoarseEquivalenceMetric.lean -/

namespace OAI

/-! # Passing from finite-difference control to metric coarse inverses -/

noncomputable section
namespace PolycyclicRecognition

open Metric Set

variable {G H : Type*} [Group G] [Group H] [MetricSpace G] [MetricSpace H]
  [IsIsometricSMul G G] [IsIsometricSMul H H]

theorem GroupBornologous.bounded_metric_steps {f : G → H}
    (hf : GroupBornologous f)
    (hfinite : ∀ R : ℝ, (closedBall (1 : G) R).Finite) (R : ℝ) :
    ∃ D : ℝ, 0 ≤ D ∧ ∀ x y, dist x y ≤ R → dist (f x) (f y) ≤ D := by
  obtain ⟨T, hT, hmap⟩ := hf _ (hfinite R)
  obtain ⟨D, hD⟩ := hT.isBounded.subset_closedBall (1 : H)
  refine ⟨max D 0, le_max_right _ _, fun x y hxy => ?_⟩
  have hx : x⁻¹ * y ∈ closedBall (1 : G) R := by
    simpa only [mem_closedBall, dist_comm (x⁻¹ * y), dist_one_groupDifference] using hxy
  have hd := hD (hmap x y hx)
  rw [mem_closedBall, dist_comm, dist_one_groupDifference] at hd
  exact hd.trans (le_max_left _ _)

theorem GroupBornologous.coarseLipschitz {f : G → H}
    (hf : GroupBornologous f) (C : LinearMetricChains G)
    (hfinite : ∀ R : ℝ, (closedBall (1 : G) R).Finite) :
    ∃ K B : ℝ, 0 ≤ K ∧ 0 ≤ B ∧
      ∀ x y, dist (f x) (f y) ≤ K * dist x y + B := by
  obtain ⟨D, hD, hstep⟩ := hf.bounded_metric_steps hfinite C.step
  exact ⟨D * C.slope, D * C.error, mul_nonneg hD C.slope_nonneg,
    mul_nonneg hD C.error_nonneg, C.coarseLipschitz f hD hstep⟩

theorem finite_groupDifference_bounded_error {r : G → G}
    (hr : (range fun x => x⁻¹ * r x).Finite) :
    ∃ E : ℝ, 0 ≤ E ∧ ∀ x, dist x (r x) ≤ E := by
  obtain ⟨E, hE⟩ := hr.isBounded.subset_closedBall (1 : G)
  refine ⟨max E 0, le_max_right _ _, fun x => ?_⟩
  have hx := hE (mem_range_self x)
  rw [mem_closedBall, dist_comm, dist_one_groupDifference] at hx
  exact hx.trans (le_max_left _ _)

/-- On metrics with linear chains and finite balls, an actual discrete
coarse equivalence is a metric quasi-equivalence. -/
def GroupCoarseEquivalence.metric (e : GroupCoarseEquivalence G H)
    (CG : LinearMetricChains G) (CH : LinearMetricChains H)
    (hG : ∀ R : ℝ, (closedBall (1 : G) R).Finite)
    (hH : ∀ R : ℝ, (closedBall (1 : H) R).Finite) : MetricQuasiEquivalence G H where
  toFun := e.toFun
  invFun := e.invFun
  toFun_control := e.bornologous_toFun.coarseLipschitz CG hG
  invFun_control := e.bornologous_invFun.coarseLipschitz CH hH
  left_close := finite_groupDifference_bounded_error e.left_error
  right_close := finite_groupDifference_bounded_error e.right_error

/-- An isomorphism is also a discrete coarse equivalence, with exact inverses. -/
def MulEquiv.groupCoarseEquivalence (e : G ≃* H) : GroupCoarseEquivalence G H where
  toFun := e
  invFun := e.symm
  bornologous_toFun := groupBornologous_hom e.toMonoidHom
  bornologous_invFun := groupBornologous_hom e.symm.toMonoidHom
  left_error := by simp
  right_error := by simp

end PolycyclicRecognition

end

end OAI

/- Pinned source: lean/OAI/GroupTheory/PolycyclicRecognition/CoarseFiniteGeneration.lean -/

namespace OAI

/-! # Finite generation is preserved by discrete-group coarse equivalence. -/

namespace PolycyclicRecognition

variable {G H : Type*} [Group G] [Group H]

/-- Coarse connectedness, expressed by finite generation, transfers through the
finite-difference control and finite error sets of a coarse equivalence. -/
theorem GroupCoarseEquivalence.finitelyGenerated (e : GroupCoarseEquivalence G H)
    [Group.FG G] : Group.FG H := by
  classical
  obtain ⟨S, hS, hSfinite⟩ := Group.fg_iff.mp (inferInstance : Group.FG G)
  obtain ⟨T, hT, hcontrol⟩ := e.bornologous_toFun S hSfinite
  let E := Set.range fun y => y⁻¹ * e.toFun (e.invFun y)
  let U := T ∪ E ∪ {e.toFun 1}
  have hU : U.Finite := (hT.union e.right_error).union (Set.finite_singleton _)
  let K := Subgroup.closure U
  have hTmem {t : H} (ht : t ∈ T) : t ∈ K :=
    Subgroup.subset_closure (Or.inl (Or.inl ht))
  have hsteps : ∀ a : G, ∀ x : G, (e.toFun x)⁻¹ * e.toFun (x * a) ∈ K := by
    intro a
    have ha : a ∈ Subgroup.closure S := hS ▸ Subgroup.mem_top a
    induction ha using Subgroup.closure_induction with
    | mem a ha =>
      intro x
      exact hTmem (hcontrol x (x * a) (by simpa using ha))
    | one =>
      intro x
      simp
    | mul a b _ _ ia ib =>
      intro x
      have hm := K.mul_mem (ia x) (ib (x * a))
      simpa only [mul_assoc, mul_inv_cancel_left] using hm
    | inv a _ ia =>
      intro x
      have hi := K.inv_mem (ia (x * a⁻¹))
      simpa only [mul_assoc, inv_mul_cancel_left, mul_inv_cancel_right,
        mul_inv_rev, inv_inv, inv_mul_cancel, mul_one] using hi
  apply Group.fg_iff.mpr
  refine ⟨U, top_unique ?_, hU⟩
  intro y _
  have hbase : e.toFun 1 ∈ K := Subgroup.subset_closure (Or.inr (Set.mem_singleton _))
  have himage : e.toFun (e.invFun y) ∈ K := by
    simpa using K.mul_mem hbase (hsteps (e.invFun y) 1)
  have herr : y⁻¹ * e.toFun (e.invFun y) ∈ K :=
    Subgroup.subset_closure (Or.inl (Or.inr ⟨y, rfl⟩))
  simpa only [mul_inv_rev, inv_inv, mul_inv_cancel_left] using
    K.mul_mem himage (K.inv_mem herr)

end PolycyclicRecognition

end OAI

/- Pinned source: lean/OAI/GroupTheory/PolycyclicRecognition/Analysis/SelfQuasiIsometry.lean -/

namespace OAI

/-! # Uniform coarse inverse bounds for self quasi-isometries -/

noncomputable section
namespace PolycyclicRecognition

variable (G : Type*) [PseudoMetricSpace G] (K C : ℝ)

/-- The usual upper, lower and coarse-surjectivity inequalities, with the
lower inequality multiplied by `K` to avoid division. For `1 ≤ K` this is
exactly the standard `(K,C)` definition. -/
structure SelfQuasiIsometry where
  toFun : G → G
  upper : ∀ x y, dist (toFun x) (toFun y) ≤ K * dist x y + C
  lower : ∀ x y, dist x y ≤ K * dist (toFun x) (toFun y) + K * C
  surjective : ∀ y, ∃ x, dist y (toFun x) ≤ C

variable {G K C}

def SelfQuasiIsometry.inverse (f : SelfQuasiIsometry G K C) : G → G :=
  fun y => Classical.choose (f.surjective y)

theorem SelfQuasiIsometry.inverse_close (f : SelfQuasiIsometry G K C) (y : G) :
    dist y (f.toFun (f.inverse y)) ≤ C :=
  Classical.choose_spec (f.surjective y)

theorem SelfQuasiIsometry.left_inverse_close (f : SelfQuasiIsometry G K C)
    (hK : 0 ≤ K) (x : G) : dist (f.inverse (f.toFun x)) x ≤ 2 * K * C := by
  have h := f.lower x (f.inverse (f.toFun x))
  have hc := mul_le_mul_of_nonneg_left (f.inverse_close (f.toFun x)) hK
  rw [dist_comm] at h
  linarith

theorem SelfQuasiIsometry.inverse_upper (f : SelfQuasiIsometry G K C)
    (hK : 0 ≤ K) (x y : G) :
    dist (f.inverse x) (f.inverse y) ≤ K * dist x y + 3 * K * C := by
  have hd : dist (f.toFun (f.inverse x)) (f.toFun (f.inverse y)) ≤ dist x y + 2 * C := by
    have := dist_triangle4 (f.toFun (f.inverse x)) x y (f.toFun (f.inverse y))
    have hx := f.inverse_close x
    have hy := f.inverse_close y
    rw [dist_comm x] at hx
    linarith
  have := f.lower (f.inverse x) (f.inverse y)
  have := mul_le_mul_of_nonneg_left hd hK
  linarith

end PolycyclicRecognition

end

end OAI

/- Exact cyclic-series declarations and constructors only. -/
namespace OAI

/-! Cyclic subnormal series and their minimum lengths in finite p-groups. -/

namespace ChromaticCyclic

structure CyclicStep {G : Type*} [Group G] (H K : Subgroup G) : Prop where
  le : H ≤ K
  normal : (H.subgroupOf K).Normal
  cyclic : letI := normal; IsCyclic (K ⧸ H.subgroupOf K)

structure CyclicSeries {G : Type*} [Group G] (H K : Subgroup G) (n : ℕ) where
  group : ℕ → Subgroup G
  first : group 0 = H
  last : group n = K
  step : ∀ i < n, CyclicStep (group i) (group (i + 1))

namespace CyclicStep
variable {G : Type*} [Group G]

protected theorem refl (H : Subgroup G) : CyclicStep H H := by
  refine ⟨le_rfl, ?_, ?_⟩
  · rw [Subgroup.subgroupOf_self]; infer_instance
  · have : Subsingleton (H ⧸ H.subgroupOf H) := by
      simpa only [Subgroup.subgroupOf_self] using
        (QuotientGroup.subsingleton_quotient_top : Subsingleton (H ⧸ (⊤ : Subgroup H)))
    infer_instance

protected theorem bot (K : Subgroup G) [IsCyclic K] : CyclicStep ⊥ K := by
  refine ⟨bot_le, Subgroup.normal_subgroupOf, ?_⟩
  exact isCyclic_of_surjective (QuotientGroup.mk' _) (QuotientGroup.mk'_surjective _)

end CyclicStep

namespace CyclicSeries
variable {G A : Type*} [Group G] [Group A] {H K L : Subgroup G} {n : ℕ}

def refl (H : Subgroup G) : CyclicSeries H H 0 where
  group := fun _ => H
  first := rfl
  last := rfl
  step := by omega

def cons (s : CyclicStep H K) (c : CyclicSeries K L n) : CyclicSeries H L (n + 1) where
  group := fun | 0 => H | i + 1 => c.group i
  first := rfl
  last := c.last
  step := by
    rintro (_ | i) hi
    · simpa [c.first] using s
    · exact c.step i (by omega)


end CyclicSeries
end ChromaticCyclic
end OAI
namespace OAI

/-!
# Polycyclic and virtually polycyclic groups

We use the existing concrete cyclic subnormal series, including normality and
cyclicity of each quotient. Neither polycyclicity nor virtual polycyclicity is
an unspecified property parameter.
-/

namespace PolycyclicRecognition

open ChromaticCyclic

variable (G : Type*) [Group G]

/-- A polycyclic group has a finite subnormal series from the trivial subgroup
to the whole group with cyclic factors. -/
def IsPolycyclic : Prop :=
  ∃ n : ℕ, Nonempty (CyclicSeries (⊥ : Subgroup G) ⊤ n)

/-- A virtually polycyclic group contains a polycyclic subgroup of finite index. -/
def IsVirtuallyPolycyclic : Prop :=
  ∃ H : Subgroup G, H.FiniteIndex ∧ IsPolycyclic H


end PolycyclicRecognition
end OAI
namespace OAI

/-!
# Cyclic factors and extensions of polycyclic groups

These are elementary consequences of concrete cyclic subnormal series. They
are used in the nilpotent branch of the recognition argument.
-/

namespace PolycyclicRecognition

open ChromaticCyclic

variable {G : Type*} [Group G]

/-- A cyclic group has a one-step cyclic series. -/
theorem isPolycyclic_of_isCyclic [IsCyclic G] : IsPolycyclic G := by
  have : IsCyclic (⊤ : Subgroup G) :=
    isCyclic_of_injective (⊤ : Subgroup G).subtype Subtype.val_injective
  exact ⟨1, ⟨CyclicSeries.cons (CyclicStep.bot ⊤) (CyclicSeries.refl ⊤)⟩⟩


end PolycyclicRecognition
end OAI

/- Task-local witnesses, not author theorems. -/

namespace Family255InterfaceWitnesses

open OAI.PolycyclicRecognition

theorem integers_polycyclic : IsPolycyclic (Multiplicative ℤ) :=
  isPolycyclic_of_isCyclic

theorem integers_virtually_polycyclic : IsVirtuallyPolycyclic (Multiplicative ℤ) :=
  by
    let : IsCyclic (⊤ : Subgroup (Multiplicative ℤ)) :=
      isCyclic_of_injective (⊤ : Subgroup (Multiplicative ℤ)).subtype Subtype.val_injective
    exact ⟨⊤, inferInstance, isPolycyclic_of_isCyclic⟩

noncomputable def integers_coarse_identity :
    GroupCoarseEquivalence (Multiplicative ℤ) (Multiplicative ℤ) where
  toFun := id
  invFun := id
  bornologous_toFun := groupBornologous_hom (MonoidHom.id _)
  bornologous_invFun := groupBornologous_hom (MonoidHom.id _)
  left_error := by simpa using Set.finite_singleton (1 : Multiplicative ℤ)
  right_error := by simpa using Set.finite_singleton (1 : Multiplicative ℤ)

theorem integers_coarse_identity_retains_fg : Group.FG (Multiplicative ℤ) :=
  integers_coarse_identity.finitelyGenerated

def real_identity_quasi_isometry : SelfQuasiIsometry ℝ 1 0 where
  toFun := id
  upper := by intros; simp
  lower := by intros; simp
  surjective := fun y => ⟨y, by simp⟩

theorem real_identity_inverse_error (x : ℝ) :
    dist (real_identity_quasi_isometry.inverse
      (real_identity_quasi_isometry.toFun x)) x ≤ 0 := by
  simpa using real_identity_quasi_isometry.left_inverse_close (by norm_num) x

#print axioms integers_polycyclic
#print axioms integers_virtually_polycyclic
#print axioms integers_coarse_identity_retains_fg
#print axioms real_identity_inverse_error
#print axioms OAI.PolycyclicRecognition.GroupCoarseEquivalence.metric
#print axioms OAI.PolycyclicRecognition.GroupCoarseEquivalence.finitelyGenerated
#print axioms OAI.PolycyclicRecognition.SelfQuasiIsometry.inverse_upper

end Family255InterfaceWitnesses
