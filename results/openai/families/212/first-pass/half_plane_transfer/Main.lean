import Mathlib

set_option autoImplicit false

noncomputable section

open Filter

namespace HalfPlaneTransfer

def shiftPath {V : Type*} (p : ℕ → V) (l : ℕ) : ℕ → V :=
  fun i => p (l + i)

def walkCost {V : Type*} (w : V → V → ℝ) (p : ℕ → V) (N : ℕ) : ℝ :=
  ∑ i ∈ Finset.range N, w (p i) (p (i + 1))

def IsWalk {V : Type*} (Adj : V → V → Prop) (p : ℕ → V) (N : ℕ) : Prop :=
  ∀ i < N, Adj (p i) (p (i + 1))

structure PassageModel (V : Type*) (Adj : V → V → Prop) where
  weight : V → V → ℝ
  distance : V → V → ℝ
  walkBound : ∀ p N, IsWalk Adj p N →
    distance (p 0) (p N) ≤ walkCost weight p N
  attain : ∀ x y, ∃ (N : ℕ) (p : ℕ → V), IsWalk Adj p N ∧
    p 0 = x ∧ p N = y ∧ walkCost weight p N = distance x y
  triangle : ∀ x y z, distance x z ≤ distance x y + distance y z

theorem walkCostCongr {V : Type*} (w v : V → V → ℝ) (p : ℕ → V) (N : ℕ)
    (heq : ∀ i < N, w (p i) (p (i + 1)) = v (p i) (p (i + 1))) :
    walkCost w p N = walkCost v p N := by
  apply Finset.sum_congr rfl
  intro i hi
  exact heq i (Finset.mem_range.mp hi)

theorem walkCostAdd {V : Type*} (w : V → V → ℝ) (p : ℕ → V) (l r : ℕ) :
    walkCost w p (l + r) =
      walkCost w p l + walkCost w (shiftPath p l) r := by
  simp [walkCost, Finset.sum_range_add, shiftPath, Nat.add_assoc]

theorem walkCostSplit {V : Type*} (w : V → V → ℝ) (p : ℕ → V)
    {l N : ℕ} (hl : l ≤ N) :
    walkCost w p N =
      walkCost w p l + walkCost w (shiftPath p l) (N - l) := by
  simpa only [Nat.add_sub_of_le hl] using walkCostAdd w p l (N - l)

theorem walkPrefix {V : Type*} {Adj : V → V → Prop} {p : ℕ → V}
    {l N : ℕ} (hw : IsWalk Adj p N) (hl : l ≤ N) : IsWalk Adj p l := by
  intro i hi
  exact hw i (lt_of_lt_of_le hi hl)

theorem walkSuffix {V : Type*} {Adj : V → V → Prop} {p : ℕ → V}
    {l N : ℕ} (hw : IsWalk Adj p N) (hl : l ≤ N) :
    IsWalk Adj (shiftPath p l) (N - l) := by
  intro i hi
  have hli : l + i < N := by omega
  simpa [shiftPath, Nat.add_assoc] using hw (l + i) hli

theorem strictSideOnInterval (H : ℕ → ℤ) (a N : ℕ) (cut : ℤ)
    (hstep : ∀ i < N, H (i + 1) ≤ H i + 1)
    (hend : cut < H N)
    (hno : ∀ i, a ≤ i → i ≤ N → H i ≠ cut) :
    ∀ i, a ≤ i → i ≤ N → cut < H i := by
  intro i hai hiN
  by_contra hbad
  have hstart : H i < cut := by
    have := hno i hai hiN
    omega
  have hprop : ∀ j, i ≤ j → j ≤ N → H j < cut := by
    intro j hij
    induction j, hij using Nat.le_induction with
    | base =>
        intro _
        exact hstart
    | succ j hij ih =>
        intro hjN
        have hp := ih (by omega)
        have hs := hstep j (by omega)
        have hn := hno (j + 1) (by omega) hjN
        omega
  have := hprop N hiN (le_refl N)
  omega

theorem lastCut (H : ℕ → ℤ) (N : ℕ) (cut : ℤ)
    (hstep : ∀ i < N, H (i + 1) ≤ H i + 1)
    (hend : cut < H N)
    (hhit : ∃ i, i ≤ N ∧ H i = cut) :
    ∃ l, l ≤ N ∧ H l = cut ∧
      ∀ i, l < i → i ≤ N → cut < H i := by
  classical
  let s := (Finset.range (N + 1)).filter (fun i => H i = cut)
  have hne : s.Nonempty := by
    obtain ⟨i, hi, hcut⟩ := hhit
    exact ⟨i, Finset.mem_filter.mpr ⟨Finset.mem_range.mpr (by omega), hcut⟩⟩
  let l := s.max' hne
  have hlmem : l ∈ s := Finset.max'_mem s hne
  have hlN : l ≤ N := by
    have := Finset.mem_range.mp (Finset.mem_filter.mp hlmem).1
    omega
  have hlcut : H l = cut := (Finset.mem_filter.mp hlmem).2
  have hno : ∀ i, l + 1 ≤ i → i ≤ N → H i ≠ cut := by
    intro i hli hiN hic
    have himem : i ∈ s :=
      Finset.mem_filter.mpr ⟨Finset.mem_range.mpr (by omega), hic⟩
    have himax : i ≤ l := Finset.le_max' s i himem
    omega
  refine ⟨l, hlN, hlcut, ?_⟩
  intro i hli hiN
  exact strictSideOnInterval H (l + 1) N cut hstep hend hno i (by omega) hiN

section WalkTransfer

variable {V : Type*} {Adj : V → V → Prop}

def SharedOnSide (M₀ M₁ : PassageModel V Adj) (height : V → ℤ) (cut : ℤ) :
    Prop :=
  ∀ u v, Adj u v → cut ≤ height u → cut ≤ height v →
    (cut < height u ∨ cut < height v) → M₁.weight u v = M₀.weight u v

theorem costEqualityOnSide (M₀ M₁ : PassageModel V Adj)
    (height : V → ℤ) (cut : ℤ) (hshare : SharedOnSide M₀ M₁ height cut)
    (p : ℕ → V) (N : ℕ) (hw : IsWalk Adj p N)
    (hside : ∀ i ≤ N, cut < height (p i)) :
    walkCost M₁.weight p N = walkCost M₀.weight p N := by
  apply walkCostCongr
  intro i hi
  exact hshare (p i) (p (i + 1)) (hw i hi)
    (le_of_lt (hside i (by omega))) (le_of_lt (hside (i + 1) (by omega)))
    (Or.inl (hside i (by omega)))

theorem cutTouchLowerBound (M₀ M₁ : PassageModel V Adj)
    (height : V → ℤ) (cut : ℤ) (b : V → ℝ)
    (hstep : ∀ u v, Adj u v → height v ≤ height u + 1)
    (hshare : SharedOnSide M₀ M₁ height cut)
    (hdom : ∀ u v, b v - b u ≤ M₀.distance u v)
    (p : ℕ → V) (N : ℕ) (hw : IsWalk Adj p N)
    (hend : cut < height (p N)) (δ : ℝ)
    (hbar : ∀ z, height z = cut →
      δ ≤ M₁.distance (p 0) z - (b z - b (p 0)))
    (hhit : ∃ i, i ≤ N ∧ height (p i) = cut) :
    b (p N) - b (p 0) + δ ≤ walkCost M₁.weight p N := by
  obtain ⟨l, hlN, hlcut, hside⟩ :=
    lastCut (fun i => height (p i)) N cut
      (fun i hi => hstep _ _ (hw i hi)) hend hhit
  have heq : walkCost M₁.weight (shiftPath p l) (N - l) =
      walkCost M₀.weight (shiftPath p l) (N - l) := by
    apply walkCostCongr
    intro i hi
    have hA : cut ≤ height (p (l + i)) := by
      by_cases hi0 : i = 0
      · subst i
        simpa using le_of_eq hlcut.symm
      · exact le_of_lt (hside (l + i) (by omega) (by omega))
    have hB : cut < height (p (l + i + 1)) :=
      hside (l + i + 1) (by omega) (by omega)
    simpa [shiftPath, Nat.add_assoc] using
      hshare (p (l + i)) (p (l + i + 1)) (hw (l + i) (by omega))
        hA (le_of_lt hB) (Or.inr hB)
  have hpre := M₁.walkBound p l (walkPrefix hw hlN)
  have hsuf : M₀.distance (p l) (p N) ≤
      walkCost M₀.weight (shiftPath p l) (N - l) := by
    simpa [shiftPath, Nat.add_sub_of_le hlN] using
      M₀.walkBound (shiftPath p l) (N - l) (walkSuffix hw hlN)
  have hb := hbar (p l) hlcut
  have hd := hdom (p l) (p N)
  have hsplit := walkCostSplit M₁.weight p hlN
  linarith

theorem oneTargetDistanceEquality (M₀ M₁ : PassageModel V Adj)
    (height : V → ℤ) (cut : ℤ) (b : V → ℝ)
    (hstep : ∀ u v, Adj u v → height v ≤ height u + 1)
    (hshare : SharedOnSide M₀ M₁ height cut)
    (hdom : ∀ u v, b v - b u ≤ M₀.distance u v)
    (x y : V) (_hx : cut < height x) (hy : cut < height y) (δ : ℝ)
    (hbar₀ : ∀ z, height z = cut → δ ≤ M₀.distance x z - (b z - b x))
    (hbar₁ : ∀ z, height z = cut → δ ≤ M₁.distance x z - (b z - b x))
    (hdefect : M₀.distance x y - (b y - b x) < δ) :
    M₁.distance x y = M₀.distance x y := by
  obtain ⟨N, p, hw, hp0, hpN, hcost⟩ := M₀.attain x y
  have hno : ∀ i ≤ N, height (p i) ≠ cut := by
    intro i hi hic
    have hb := cutTouchLowerBound M₀ M₀ height cut b hstep
      (fun _ _ _ _ _ _ => rfl) hdom p N hw (by simpa [hpN] using hy) δ
      (by simpa [hp0] using hbar₀) ⟨i, hi, hic⟩
    rw [hp0, hpN, hcost] at hb
    linarith
  have hside : ∀ i ≤ N, cut < height (p i) := by
    intro i hi
    exact strictSideOnInterval (fun j => height (p j)) 0 N cut
      (fun j hj => hstep _ _ (hw j hj)) (by simpa [hpN] using hy)
      (fun j _ hj => hno j hj) i (Nat.zero_le i) hi
  have hcosteq := costEqualityOnSide M₀ M₁ height cut hshare p N hw hside
  have hupper : M₁.distance x y ≤ M₀.distance x y := by
    calc
      M₁.distance x y ≤ walkCost M₁.weight p N := by
        simpa [hp0, hpN] using M₁.walkBound p N hw
      _ = walkCost M₀.weight p N := hcosteq
      _ = M₀.distance x y := hcost
  obtain ⟨L, q, hq, hq0, hqL, hqcost⟩ := M₁.attain x y
  have hlower : M₀.distance x y ≤ M₁.distance x y := by
    by_cases hhit : ∃ i, i ≤ L ∧ height (q i) = cut
    · have hb := cutTouchLowerBound M₀ M₁ height cut b hstep hshare hdom
        q L hq (by simpa [hqL] using hy) δ
        (by simpa [hq0] using hbar₁) hhit
      rw [hq0, hqL, hqcost] at hb
      linarith
    · have hqno : ∀ i ≤ L, height (q i) ≠ cut := by
        intro i hi hic
        exact hhit ⟨i, hi, hic⟩
      have hqside : ∀ i ≤ L, cut < height (q i) := by
        intro i hi
        exact strictSideOnInterval (fun j => height (q j)) 0 L cut
          (fun j hj => hstep _ _ (hq j hj)) (by simpa [hqL] using hy)
          (fun j _ hj => hqno j hj) i (Nat.zero_le i) hi
      have heq := costEqualityOnSide M₀ M₁ height cut hshare q L hq hqside
      calc
        M₀.distance x y ≤ walkCost M₀.weight q L := by
          simpa [hq0, hqL] using M₀.walkBound q L hq
        _ = walkCost M₁.weight q L := heq.symm
        _ = M₁.distance x y := hqcost
  exact le_antisymm hupper hlower

theorem rootMinimizingSegments (M : PassageModel V Adj) (p : ℕ → V)
    (hw : ∀ N, IsWalk Adj p N)
    (hroot : ∀ N, walkCost M.weight p N = M.distance (p 0) (p N))
    {i j : ℕ} (hij : i ≤ j) :
    walkCost M.weight (shiftPath p i) (j - i) = M.distance (p i) (p j) := by
  have hsplit := walkCostSplit M.weight p hij
  rw [hroot j, hroot i] at hsplit
  have htri := M.triangle (p 0) (p i) (p j)
  have hbound : M.distance (p i) (p j) ≤
      walkCost M.weight (shiftPath p i) (j - i) := by
    simpa [shiftPath, Nat.add_sub_of_le hij] using
      M.walkBound (shiftPath p i) (j - i) (walkSuffix (hw j) hij)
  linarith

theorem retainedRootMinimizing (M₀ M₁ : PassageModel V Adj)
    (height : V → ℤ) (cut : ℤ) (b : V → ℝ)
    (hstep : ∀ u v, Adj u v → height v ≤ height u + 1)
    (hshare : SharedOnSide M₀ M₁ height cut)
    (hdom : ∀ u v, b v - b u ≤ M₀.distance u v)
    (p : ℕ → V) (hw : ∀ N, IsWalk Adj p N)
    (hside : ∀ i, cut < height (p i))
    (hroot : ∀ N, walkCost M₀.weight p N = M₀.distance (p 0) (p N))
    (hcal : ∀ N, M₀.distance (p 0) (p N) = b (p N) - b (p 0))
    (δ : ℝ) (hδ : 0 < δ)
    (hbar₀ : ∀ z, height z = cut →
      δ ≤ M₀.distance (p 0) z - (b z - b (p 0)))
    (hbar₁ : ∀ z, height z = cut →
      δ ≤ M₁.distance (p 0) z - (b z - b (p 0))) :
    ∀ N, walkCost M₁.weight p N = M₁.distance (p 0) (p N) := by
  intro N
  have hdist := oneTargetDistanceEquality M₀ M₁ height cut b hstep hshare hdom
    (p 0) (p N) (hside 0) (hside N) δ hbar₀ hbar₁ (by rw [hcal N]; linarith)
  calc
    walkCost M₁.weight p N = walkCost M₀.weight p N :=
      costEqualityOnSide M₀ M₁ height cut hshare p N (hw N) (fun i _ => hside i)
    _ = M₀.distance (p 0) (p N) := hroot N
    _ = M₁.distance (p 0) (p N) := hdist.symm

theorem eventualDistanceEquality (M₀ M₁ : PassageModel V Adj)
    (height : V → ℤ) (cut : ℤ) (b : V → ℝ)
    (hstep : ∀ u v, Adj u v → height v ≤ height u + 1)
    (hshare : SharedOnSide M₀ M₁ height cut)
    (hdom : ∀ u v, b v - b u ≤ M₀.distance u v)
    (p : ℕ → V) (htarget : ∀ᶠ j in atTop, cut < height (p j))
    (x : V) (hx : cut < height x) (δ : ℝ) (hδ : 0 < δ)
    (hbar₀ : ∀ z, height z = cut → δ ≤ M₀.distance x z - (b z - b x))
    (hbar₁ : ∀ z, height z = cut → δ ≤ M₁.distance x z - (b z - b x))
    (hdefect : Tendsto (fun j => M₀.distance x (p j) - (b (p j) - b x))
      atTop (nhds 0)) :
    ∀ᶠ j in atTop, M₁.distance x (p j) = M₀.distance x (p j) := by
  have hsmall : ∀ᶠ j in atTop,
      M₀.distance x (p j) - (b (p j) - b x) < δ :=
    hdefect.eventually (Iio_mem_nhds hδ)
  filter_upwards [hsmall, htarget] with j hj ht
  exact oneTargetDistanceEquality M₀ M₁ height cut b hstep hshare hdom
    x (p j) hx ht δ hbar₀ hbar₁ hj

end WalkTransfer

theorem movingComparability {X Z D n : ℝ}
    (hX : X ≤ n / 2) (hZ : n ≤ Z) (hD : Z - X ≤ D) :
    Z ≤ 2 * D ∧ X + Z + n ≤ 5 * D ∧ n / 2 ≤ D := by
  constructor
  · linarith
  constructor <;> linarith

theorem fixedUpperComparability {X Z D c : ℝ} (hc : 0 < c)
    (hD : c * X ≤ D) (hZ : Z ≤ D + X) :
    c / (c + 2) * (X + Z) ≤ D := by
  have hm := mul_le_mul_of_nonneg_left hZ (le_of_lt hc)
  rw [div_mul_eq_mul_div, div_le_iff₀ (by linarith : 0 < c + 2)]
  nlinarith

theorem fixedLowerComparability {X Z D c : ℝ} (hc : 0 < c)
    (hD : c * X / 2 ≤ D) (hZ : Z ≤ D + X) :
    c / (c + 4) * (X + Z) ≤ D := by
  have hm := mul_le_mul_of_nonneg_left hZ (le_of_lt hc)
  rw [div_mul_eq_mul_div, div_le_iff₀ (by linarith : 0 < c + 4)]
  nlinarith

theorem movingBarrier {T M R B az ax γ D E S : ℝ}
    (hγ : 0 ≤ γ) (hD : 0 ≤ D) (hE : 0 ≤ E) (hEsmall : E ≤ γ / 40)
    (hscale : S ≤ 5 * D) (hgap : γ * D ≤ M - R)
    (hmetric : M - E * S ≤ T)
    (hrootz : |az| ≤ γ / 8 * D) (hrootx : |ax| ≤ γ / 8 * D)
    (hB : B = R + az - ax) :
    γ / 2 * D ≤ T - B := by
  have hES : E * S ≤ γ / 8 * D := by
    have h₁ := mul_le_mul_of_nonneg_left hscale hE
    have h₂ := mul_le_mul_of_nonneg_right hEsmall (show 0 ≤ 5 * D by positivity)
    nlinarith
  have hγD : 0 ≤ γ * D := mul_nonneg hγ hD
  have hz := le_abs_self az
  have hx := neg_le_abs ax
  nlinarith

theorem fixedBarrier {T M R B az ax g ε C S : ℝ}
    (hS : 0 ≤ S) (hε : ε ≤ g / 8) (hC : 8 * C ≤ g * S)
    (hgap : g * S ≤ M - R) (hmetric : M - ε * S ≤ T)
    (hroot : |az| + |ax| ≤ ε * S + 2 * C) (hB : B = R + az - ax) :
    g / 2 * S ≤ T - B := by
  have herr := mul_nonneg (sub_nonneg.mpr hε) hS
  have hz := le_abs_self az
  have hx := neg_le_abs ax
  nlinarith

def MetricApprox {V : Type*} (rad : V → ℝ) (d m : V → V → ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ R : ℝ, 0 ≤ R ∧
    ∀ x z, R ≤ rad x + rad z → |d x z - m x z| ≤ ε * (rad x + rad z)

def RootApprox {V : Type*} (rad a : V → ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ C : ℝ, 0 ≤ C ∧ ∀ x, |a x| ≤ ε * rad x + C

theorem eventualFixedBarrier {V : Type*}
    (rad : V → ℝ) (hrad : ∀ x, 0 ≤ rad x)
    (d m : V → V → ℝ) (ρ b : V → ℝ) (sector : V → Prop)
    (height : V → ℤ) (cut : ℤ) (g : ℝ) (hg : 0 < g)
    (hmetric : MetricApprox rad d m)
    (hroot : RootApprox rad (fun x => b x - ρ x))
    (hgap : ∀ x, sector x → ∀ z, height z = cut →
      g * (rad x + rad z) ≤ m x z - (ρ z - ρ x)) :
    ∃ R : ℝ, 0 < R ∧ ∀ x, sector x → R ≤ rad x →
      ∀ z, height z = cut →
        g / 2 * (rad x + rad z) ≤ d x z - (b z - b x) := by
  obtain ⟨R₀, hR₀, hmet⟩ := hmetric (g / 8) (by positivity)
  obtain ⟨C, hC, hrootC⟩ := hroot (g / 8) (by positivity)
  let R := 1 + R₀ + 8 * C / g
  have hdiv : 0 ≤ 8 * C / g := by positivity
  have hR : 0 < R := by dsimp [R]; linarith
  refine ⟨R, hR, ?_⟩
  intro x hx hxR z hz
  have hS : 0 ≤ rad x + rad z := add_nonneg (hrad x) (hrad z)
  have hRm : R₀ ≤ rad x + rad z := by dsimp [R] at hxR; linarith [hrad z]
  have hdivS : 8 * C / g ≤ rad x + rad z := by
    dsimp [R] at hxR
    linarith [hrad z]
  have hCS : 8 * C ≤ g * (rad x + rad z) := by
    have := (div_le_iff₀ hg).mp hdivS
    nlinarith
  have hm := (abs_le.mp (hmet x z hRm)).1
  have hrx := hrootC x
  have hrz := hrootC z
  apply fixedBarrier (S := rad x + rad z) (g := g) (ε := g / 8)
    (C := C) (M := m x z) (R := ρ z - ρ x)
    (az := b z - ρ z) (ax := b x - ρ x)
  · exact hS
  · exact le_refl _
  · exact hCS
  · exact hgap x hx z hz
  · linarith
  · linarith
  · ring

theorem asymptoticTransfer {V : Type*} {Adj : V → V → Prop}
    (M₀ M₁ : PassageModel V Adj) (height : V → ℤ) (cut : ℤ) (b ρ : V → ℝ)
    (hstep : ∀ u v, Adj u v → height v ≤ height u + 1)
    (hshare : SharedOnSide M₀ M₁ height cut)
    (hdom : ∀ u v, b v - b u ≤ M₀.distance u v)
    (rad : V → ℝ) (hrad : ∀ x, 0 ≤ rad x)
    (m : V → V → ℝ) (sector : V → Prop)
    (hside : ∀ x, sector x → cut < height x)
    (g : ℝ) (hg : 0 < g)
    (hmetric₀ : MetricApprox rad M₀.distance m)
    (hmetric₁ : MetricApprox rad M₁.distance m)
    (hroot : RootApprox rad (fun x => b x - ρ x))
    (hgap : ∀ x, sector x → ∀ z, height z = cut →
      g * (rad x + rad z) ≤ m x z - (ρ z - ρ x))
    (p : ℕ → V) (htarget : ∀ᶠ j in atTop, cut < height (p j))
    (hdefect : ∀ x, Tendsto (fun j => M₀.distance x (p j) - (b (p j) - b x))
      atTop (nhds 0)) :
    ∃ R : ℝ, 0 < R ∧ ∀ x, sector x → R ≤ rad x →
      ∀ᶠ j in atTop, M₁.distance x (p j) = M₀.distance x (p j) := by
  obtain ⟨R₀, hR₀, hbar₀⟩ := eventualFixedBarrier rad hrad M₀.distance m ρ b
    sector height cut g hg hmetric₀ hroot hgap
  obtain ⟨R₁, hR₁, hbar₁⟩ := eventualFixedBarrier rad hrad M₁.distance m ρ b
    sector height cut g hg hmetric₁ hroot hgap
  let R := max 1 (max R₀ R₁)
  have hR : 0 < R := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1) (le_max_left _ _)
  refine ⟨R, hR, ?_⟩
  intro x hx hxR
  have hRx : 1 ≤ rad x := le_trans (le_max_left _ _) hxR
  have hRx₀ : R₀ ≤ rad x :=
    le_trans (le_trans (le_max_left _ _) (le_max_right _ _)) hxR
  have hRx₁ : R₁ ≤ rad x :=
    le_trans (le_trans (le_max_right _ _) (le_max_right _ _)) hxR
  have hδ : 0 < g / 2 * rad x := mul_pos (by positivity) (by linarith)
  apply eventualDistanceEquality M₀ M₁ height cut b hstep hshare hdom p htarget
    x (hside x hx) (g / 2 * rad x) hδ
  · intro z hz
    have hb := hbar₀ x hx hRx₀ z hz
    have hp := mul_nonneg (show 0 ≤ g / 2 by positivity) (hrad z)
    nlinarith
  · intro z hz
    have hb := hbar₁ x hx hRx₁ z hz
    have hp := mul_nonneg (show 0 ≤ g / 2 by positivity) (hrad z)
    nlinarith
  · exact hdefect x

theorem movingCutBarriers {V : Type*}
    (d₀ d₁ m : V → V → ℝ) (b ρ : V → ℝ)
    (height : V → ℤ) (cut : ℤ) (x : V)
    (D S : V → ℝ) (γ n E₀ E₁ : ℝ)
    (hγ : 0 < γ) (hn : 0 < n)
    (hE₀ : 0 ≤ E₀) (hE₁ : 0 ≤ E₁)
    (hEsmall₀ : E₀ ≤ γ / 40) (hEsmall₁ : E₁ ≤ γ / 40)
    (hgeom : ∀ z, height z = cut → n / 2 ≤ D z ∧ S z ≤ 5 * D z)
    (hgap : ∀ z, height z = cut → γ * D z ≤ m x z - (ρ z - ρ x))
    (hmetric₀ : ∀ z, height z = cut → m x z - E₀ * S z ≤ d₀ x z)
    (hmetric₁ : ∀ z, height z = cut → m x z - E₁ * S z ≤ d₁ x z)
    (hrootz : ∀ z, height z = cut → |b z - ρ z| ≤ γ / 8 * D z)
    (hrootx : ∀ z, height z = cut → |b x - ρ x| ≤ γ / 8 * D z) :
    (∀ z, height z = cut → γ * n / 4 ≤ d₀ x z - (b z - b x)) ∧
    (∀ z, height z = cut → γ * n / 4 ≤ d₁ x z - (b z - b x)) := by
  have hraw : ∀ (d : V → V → ℝ) (E : ℝ), 0 ≤ E → E ≤ γ / 40 →
      (∀ z, height z = cut → m x z - E * S z ≤ d x z) →
      ∀ z, height z = cut → γ * n / 4 ≤ d x z - (b z - b x) := by
    intro d E hE hEs hmet z hz
    obtain ⟨hDz, hSz⟩ := hgeom z hz
    have hD : 0 ≤ D z := by linarith
    have hb := movingBarrier (le_of_lt hγ) hD hE hEs hSz (hgap z hz)
      (hmet z hz) (hrootz z hz) (hrootx z hz)
      (show b z - b x = (ρ z - ρ x) + (b z - ρ z) - (b x - ρ x) by ring)
    have hp := mul_nonneg (le_of_lt hγ) (show 0 ≤ D z - n / 2 by linarith)
    nlinarith
  exact ⟨hraw d₀ E₀ hE₀ hEsmall₀ hmetric₀, hraw d₁ E₁ hE₁ hEsmall₁ hmetric₁⟩

theorem movingCutDistanceEquality {V : Type*} {Adj : V → V → Prop}
    (M₀ M₁ : PassageModel V Adj) (height : V → ℤ) (cut : ℤ)
    (b ρ : V → ℝ) (x y : V)
    (hstep : ∀ u v, Adj u v → height v ≤ height u + 1)
    (hshare : SharedOnSide M₀ M₁ height cut)
    (hdom : ∀ u v, b v - b u ≤ M₀.distance u v)
    (hx : cut < height x) (hy : cut < height y)
    (D S : V → ℝ) (m : V → V → ℝ) (γ n E₀ E₁ : ℝ)
    (hγ : 0 < γ) (hn : 0 < n)
    (hE₀ : 0 ≤ E₀) (hE₁ : 0 ≤ E₁)
    (hEsmall₀ : E₀ ≤ γ / 40) (hEsmall₁ : E₁ ≤ γ / 40)
    (hgeom : ∀ z, height z = cut → n / 2 ≤ D z ∧ S z ≤ 5 * D z)
    (hgap : ∀ z, height z = cut → γ * D z ≤ m x z - (ρ z - ρ x))
    (hmetric₀ : ∀ z, height z = cut → m x z - E₀ * S z ≤ M₀.distance x z)
    (hmetric₁ : ∀ z, height z = cut → m x z - E₁ * S z ≤ M₁.distance x z)
    (hrootz : ∀ z, height z = cut → |b z - ρ z| ≤ γ / 8 * D z)
    (hrootx : ∀ z, height z = cut → |b x - ρ x| ≤ γ / 8 * D z)
    (hdefect : M₀.distance x y - (b y - b x) < γ * n / 4) :
    M₁.distance x y = M₀.distance x y := by
  obtain ⟨hb₀, hb₁⟩ := movingCutBarriers M₀.distance M₁.distance m b ρ
    height cut x D S γ n E₀ E₁ hγ hn hE₀ hE₁ hEsmall₀ hEsmall₁
    hgeom hgap hmetric₀ hmetric₁ hrootz hrootx
  exact oneTargetDistanceEquality M₀ M₁ height cut b hstep hshare hdom
    x y hx hy (γ * n / 4) hb₀ hb₁ hdefect

theorem twoCoordinatesFromLimits
    (f₂ f₁₂ g₂ g₁₂ : ℕ → ℝ) (a₁ a₂ b₁ b₂ : ℝ)
    (heq₂ : f₂ =ᶠ[atTop] g₂) (heq₁₂ : f₁₂ =ᶠ[atTop] g₁₂)
    (ha₂ : Tendsto f₂ atTop (nhds a₂))
    (hb₂ : Tendsto g₂ atTop (nhds b₂))
    (ha₁₂ : Tendsto f₁₂ atTop (nhds (a₁ + a₂)))
    (hb₁₂ : Tendsto g₁₂ atTop (nhds (b₁ + b₂))) :
    a₁ = b₁ ∧ a₂ = b₂ := by
  have h₂ : a₂ = b₂ := tendsto_nhds_unique ha₂ (hb₂.congr' heq₂.symm)
  have h₁₂ : a₁ + a₂ = b₁ + b₂ :=
    tendsto_nhds_unique ha₁₂ (hb₁₂.congr' heq₁₂.symm)
  exact ⟨by linarith, h₂⟩

theorem finiteWitnessThreshold {V : Type*} (K : Finset V) (P : V → ℕ → Prop)
    (h : ∀ x ∈ K, ∀ᶠ j in atTop, P x j) :
    ∀ᶠ j in atTop, ∀ x ∈ K, P x j := by
  classical
  induction K using Finset.induction_on with
  | empty =>
      simp
  | @insert x K hx ih =>
      have hfirst := h x (Finset.mem_insert_self x K)
      have hrest := ih (fun y hy => h y (Finset.mem_insert_of_mem hy))
      filter_upwards [hfirst, hrest] with j hj hK
      intro y hy
      rcases Finset.mem_insert.mp hy with rfl | hy
      · exact hj
      · exact hK y hy

theorem busemannWitnessEquality (u v u' v' : ℕ → ℝ) (a b : ℝ)
    (hu : u =ᶠ[atTop] u') (hv : v =ᶠ[atTop] v')
    (ha : Tendsto (fun j => u j - v j) atTop (nhds a))
    (hb : Tendsto (fun j => u' j - v' j) atTop (nhds b)) : a = b := by
  have heq : (fun j => u j - v j) =ᶠ[atTop] (fun j => u' j - v' j) := by
    filter_upwards [hu, hv] with j hj hk
    rw [hj, hk]
  exact tendsto_nhds_unique ha (hb.congr' heq.symm)

end HalfPlaneTransfer
