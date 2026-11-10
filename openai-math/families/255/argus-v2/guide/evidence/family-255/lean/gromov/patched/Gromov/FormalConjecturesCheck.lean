module

public import Gromov.Gromov
public import Gromov.PolynomialGrowth

/-!
# Cross-check of `main_gromov_theorem` against the `formal-conjectures` statement

The definitions `CayleyBall`, `GrowthFunction` and `HasPolynomialGrowth` below are copied
verbatim from the `formal-conjectures` repository (Apache-2.0):

* <https://github.com/google-deepmind/formal-conjectures>,
  `FormalConjecturesForMathlib/Algebra/Group/GrowthFunction.lean`
* the theorem being checked against is `GromovPolynomialGrowth.GromovPolynomialGrowthTheorem` in
  `FormalConjectures/Wikipedia/GromovPolynomialGrowth.lean`.

They are reproduced here rather than imported because that repository pins a different Lean
toolchain and Mathlib revision than this development.

The reference statement is an `Iff`:
```
theorem GromovPolynomialGrowthTheorem [Group.FG G] :
    HasPolynomialGrowth G ↔ Group.IsVirtuallyNilpotent G
```
This development proves the forward (hard) direction, `gromov_forward` below.  The converse
(Bass-Guivarc'h: a virtually nilpotent group has polynomial growth) is *not* proved here, so this
file does not discharge the reference `sorry` on its own.

The two statements measure growth differently -- balls `CayleyBall S n` of words of length `≤ n`
in `S ∪ S⁻¹` there, versus `S ^ n` for a symmetric `S ∋ 1` here -- so the bridge is
`coe_normGen_pow`, which says the two agree once the generating set is normalized.
-/

public section

set_option linter.style.longLine false

@[instance_reducible]
private noncomputable def generatorsData {G : Type*} (gg : Group G) (de : DecidableEq G)
    (T : Finset G) (hT : Nonempty T)
    (hgen : (@Subgroup.closure G gg (T : Set G) : Set G) = Set.univ)
    (h1 : @OfNat.ofNat G 1 (@One.toOfNat1 G gg.toOne) ∈ T)
    (hinv : ∀ g ∈ T, @Inv.inv G gg.toInv g ∈ T)
    (hi : Infinite G) (hp : @HasPolynomialGrowth G gg de T) : Generates :=
  @Generates.mk G gg de T hT hgen h1 hinv hi hp

private theorem gromovOfGeneratorData {G : Type*} (gg : Group G) (de : DecidableEq G)
    (T : Finset G) (hT : Nonempty T)
    (hgen : (@Subgroup.closure G gg (T : Set G) : Set G) = Set.univ)
    (h1 : @OfNat.ofNat G 1 (@One.toOfNat1 G gg.toOne) ∈ T)
    (hinv : ∀ g ∈ T, @Inv.inv G gg.toInv g ∈ T)
    (hi : Infinite G) (hp : @HasPolynomialGrowth G gg de T) :
    @Group.IsVirtuallyNilpotent G gg := by
  let inst := generatorsData gg de T hT hgen h1 hinv hi hp
  obtain ⟨n, hn⟩ := hp
  exact GeneratesNS.main_gromov_theorem (hGS := inst) n hn

namespace FormalConjecturesCheck

open scoped Pointwise

variable {G : Type*} [Group G]

/-! ### Normalizing the generating set -/

variable [DecidableEq G]

/-- `S ∪ S⁻¹ ∪ {1}` as a `Finset`: the symmetric, `1`-containing generating set that
`Generates` requires. -/
@[expose]
noncomputable def normGen (S : Set G) (hS : S.Finite) : Finset G :=
  insert 1 (hS.toFinset ∪ hS.toFinset⁻¹)

lemma mem_normGen (S : Set G) (hS : S.Finite) {g : G} :
    g ∈ normGen S hS ↔ g = 1 ∨ g ∈ S ∨ g⁻¹ ∈ S := by
  simp only [normGen, Finset.mem_insert, Finset.mem_union, Set.Finite.mem_toFinset,
    Finset.mem_inv']

lemma one_mem_normGen (S : Set G) (hS : S.Finite) : (1 : G) ∈ normGen S hS :=
  (mem_normGen S hS).mpr (Or.inl rfl)

lemma subset_normGen (S : Set G) (hS : S.Finite) : S ⊆ (normGen S hS : Set G) :=
  fun _ hx => (mem_normGen S hS).mpr (Or.inr (Or.inl hx))

lemma inv_mem_normGen (S : Set G) (hS : S.Finite) {g : G} (hg : g ∈ normGen S hS) :
    g⁻¹ ∈ normGen S hS := by
  rcases (mem_normGen S hS).mp hg with rfl | hg | hg
  · simpa using one_mem_normGen S hS
  · exact (mem_normGen S hS).mpr (Or.inr (Or.inr (by simpa using hg)))
  · exact (mem_normGen S hS).mpr (Or.inr (Or.inl hg))

/-- The bridge between the two notions of ball: powers of the normalized generating set are
exactly the Cayley balls of the original one. -/
lemma coe_normGen_pow (S : Set G) (hS : S.Finite) (n : ℕ) :
    ((normGen S hS ^ n : Finset G) : Set G) = CayleyBall S n := by
  induction n with
  | zero =>
    ext g
    simp only [pow_zero, Finset.coe_one, Set.mem_one, CayleyBall, Set.mem_ofPred_eq]
    constructor
    · rintro rfl
      exact ⟨[], by simp, by simp, by simp⟩
    · rintro ⟨l, hl, -, rfl⟩
      simp [List.eq_nil_of_length_eq_zero (Nat.le_zero.mp hl)]
  | succ n ih =>
    rw [pow_succ, Finset.coe_mul, ih]
    ext g
    constructor
    · rintro ⟨x, ⟨l, hl, hmem, rfl⟩, t, ht, rfl⟩
      rcases (mem_normGen S hS).mp ht with rfl | ht' | ht'
      · exact ⟨l, hl.trans (Nat.le_succ n), hmem, by simp⟩
      · exact ⟨l ++ [t], by simpa using hl, by
          intro s hs
          rcases List.mem_append.mp hs with hs | hs
          · exact hmem s hs
          · simp only [List.mem_singleton] at hs
            exact hs ▸ Or.inl ht', by simp⟩
      · exact ⟨l ++ [t], by simpa using hl, by
          intro s hs
          rcases List.mem_append.mp hs with hs | hs
          · exact hmem s hs
          · simp only [List.mem_singleton] at hs
            exact hs ▸ Or.inr ht', by simp⟩
    · rintro ⟨l, hl, hmem, rfl⟩
      by_cases hlen : l.length ≤ n
      · -- short word: pad on the right with `1`
        exact ⟨l.prod, ⟨l, hlen, hmem, rfl⟩, 1, one_mem_normGen S hS, by simp⟩
      · -- full-length word: peel off the last letter
        have hne : l ≠ [] := by rintro rfl; simp at hlen
        have hsplit : l.dropLast ++ [l.getLast hne] = l := List.dropLast_append_getLast hne
        have hdrop : l.dropLast.length ≤ n := by
          rw [List.length_dropLast]
          omega
        refine ⟨l.dropLast.prod, ⟨l.dropLast, hdrop, fun s hs => hmem s ?_, rfl⟩,
          l.getLast hne, ?_, ?_⟩
        · exact hsplit ▸ List.mem_append.mpr (Or.inl hs)
        · exact (mem_normGen S hS).mpr (Or.inr (hmem _ (List.getLast_mem hne)))
        · conv_rhs => rw [← hsplit]
          simp

lemma card_normGen_pow (S : Set G) (hS : S.Finite) (n : ℕ) :
    (normGen S hS ^ n).card = GrowthFunction S n := by
  rw [GrowthFunction, ← coe_normGen_pow, Set.ncard_coe_finset]

/-! ### The forward direction of the reference statement -/

private lemma normGen_polynomial (S : Set G) (hSfin : S.Finite) (C : ℝ) (d : ℕ)
    (hbound : ∀ n : ℕ, 0 < n → (GrowthFunction S n : ℝ) ≤ C * (n : ℝ) ^ d) :
    HasPolynomialGrowthD (normGen S hSfin) d := by
  refine ⟨⌈C⌉₊, fun n hn => ?_⟩
  have hcard : ((normGen S hSfin) ^ n).card = GrowthFunction S n := card_normGen_pow S hSfin n
  have hb := hbound n (by omega)
  rw [← hcard] at hb
  have h : (((normGen S hSfin) ^ n).card : ℝ) ≤ (⌈C⌉₊ : ℝ) * (n : ℝ) ^ d :=
    hb.trans (by gcongr; exact Nat.le_ceil C)
  exact_mod_cast h

private lemma normGen_generates (S : Set G) (hSfin : S.Finite)
    (hSgen : Subgroup.closure S = ⊤) :
    (Subgroup.closure (normGen S hSfin : Set G) : Set G) = ⊤ := by
  have hclosure : Subgroup.closure ((normGen S hSfin : Finset G) : Set G) = ⊤ := by
    rw [eq_top_iff, ← hSgen]
    exact Subgroup.closure_mono (subset_normGen S hSfin)
  rw [hclosure]
  rfl

private theorem normalized_data (S : Set G) (hSfin : S.Finite)
    (hSgen : Subgroup.closure S = ⊤) (C : ℝ) (d : ℕ)
    (hbound : ∀ n : ℕ, 0 < n → (GrowthFunction S n : ℝ) ≤ C * (n : ℝ) ^ d) :
    ∃ T : Finset G, Nonempty T ∧
      (Subgroup.closure (T : Set G) : Set G) = Set.univ ∧
      (1 : G) ∈ T ∧ (∀ g ∈ T, g⁻¹ ∈ T) ∧ _root_.HasPolynomialGrowth T := by
  refine ⟨normGen S hSfin, ⟨⟨1, one_mem_normGen S hSfin⟩⟩,
    normGen_generates S hSfin hSgen, one_mem_normGen S hSfin,
    fun _ hg => inv_mem_normGen S hSfin hg, d, ?_⟩
  exact normGen_polynomial S hSfin C d hbound

omit [Group G] [DecidableEq G] in
private theorem infinite_forward (gg : Group G) (de : DecidableEq G) (S : Set G)
    (hSfin : S.Finite) (hSgen : @Subgroup.closure G gg S = ⊤) (hinf : Infinite G)
    (C : ℝ) (d : ℕ)
    (hbound : ∀ n : ℕ, 0 < n → (@GrowthFunction G gg S n : ℝ) ≤ C * (n : ℝ) ^ d) :
    @Group.IsVirtuallyNilpotent G gg := by
  obtain ⟨T, hT, hgen, h1, hinv, hp⟩ := @normalized_data G gg de S hSfin hSgen C d hbound
  exact @gromovOfGeneratorData G gg de T hT hgen h1 hinv hinf hp

omit [Group G] [DecidableEq G] in
/-- **The forward direction of `GromovPolynomialGrowth.GromovPolynomialGrowthTheorem`**, derived
from `GeneratesNS.main_gromov_theorem`: a finitely generated group of polynomial growth (in the
`formal-conjectures` formulation) is virtually nilpotent. -/
theorem gromov_forward (G : Type*) [gg : Group G] (h : @HasPolynomialGrowth G gg) :
    Group.IsVirtuallyNilpotent G := by
  classical
  obtain ⟨S, hSfin, hSgen, C, d, hC, hbound⟩ := h
  rcases finite_or_infinite G with hfin | hinf
  · exact GeneratesNS.finite_virtually_nilpotent
  · exact infinite_forward gg (inferInstance : DecidableEq G) S hSfin hSgen hinf C d hbound

omit [Group G] [DecidableEq G] in
/-- The forward direction with the reference statement's exact signature, including the
`[Group.FG G]` hypothesis.  That hypothesis is redundant here: `HasPolynomialGrowth G` already
supplies a finite generating set, so `gromov_forward` proves the same conclusion without it. -/
@[nolint unusedArguments]
theorem gromov_forward_fg (G : Type*) [Group G] [Group.FG G] (h : HasPolynomialGrowth G) :
    Group.IsVirtuallyNilpotent G :=
  gromov_forward G h

end FormalConjecturesCheck
