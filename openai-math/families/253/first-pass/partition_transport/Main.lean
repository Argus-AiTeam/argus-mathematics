import Mathlib.Data.Real.Basic
import Mathlib.Order.Interval.Set.Basic
import Mathlib.Tactic.Linarith

namespace PartitionTransport

variable {α : Type*} [LinearOrder α]

def Consecutive (marks : Set α) (p q : α) : Prop :=
  p ∈ marks ∧ q ∈ marks ∧ p < q ∧
    ∀ r, r ∈ marks → p < r → r < q → False

def Barrier (marks : Set α) (active : α → Prop) (x : α) : Prop :=
  ∃ p q, Consecutive marks p q ∧ p ≤ x ∧ x ≤ q ∧ active p

theorem consecutive_in_chart
    {marks : Set α} {a b p q x : α}
    (ha : a ∈ marks) (hb : b ∈ marks)
    (hx : a < x ∧ x < b)
    (hpq : Consecutive marks p q)
    (hpx : p ≤ x) (hxq : x ≤ q) :
    a ≤ p ∧ q ≤ b := by
  rcases hpq with ⟨_, _, _, hgap⟩
  constructor
  · by_contra h
    exact hgap a ha (lt_of_not_ge h) (lt_of_lt_of_le hx.1 hxq)
  · by_contra h
    exact hgap b hb (lt_of_le_of_lt hpx hx.2) (lt_of_not_ge h)

theorem consecutive_transfer
    {marks marks' : Set α} {a b p q : α}
    (hmarks : ∀ z, a ≤ z → z ≤ b → (z ∈ marks ↔ z ∈ marks'))
    (hap : a ≤ p) (hqb : q ≤ b)
    (hpq : Consecutive marks p q) :
    Consecutive marks' p q := by
  rcases hpq with ⟨hp, hq, hpq, hgap⟩
  refine ⟨(hmarks p hap (le_trans (le_of_lt hpq) hqb)).mp hp,
    (hmarks q (le_trans hap (le_of_lt hpq)) hqb).mp hq, hpq, ?_⟩
  intro r hr hpr hrq
  exact hgap r
    ((hmarks r (le_trans hap (le_of_lt hpr))
      (le_trans (le_of_lt hrq) hqb)).mpr hr) hpr hrq

theorem barrier_transfer
    {marks marks' : Set α} {active active' : α → Prop} {a b x : α}
    (ha : a ∈ marks) (hb : b ∈ marks)
    (hmarks : ∀ z, a ≤ z → z ≤ b → (z ∈ marks ↔ z ∈ marks'))
    (hactive : ∀ z, a ≤ z → z < b → (active z ↔ active' z))
    (hx : a < x ∧ x < b)
    (hbarrier : Barrier marks active x) :
    Barrier marks' active' x := by
  rcases hbarrier with ⟨p, q, hpq, hpx, hxq, hp⟩
  have hbounds := consecutive_in_chart ha hb hx hpq hpx hxq
  exact ⟨p, q, consecutive_transfer hmarks hbounds.1 hbounds.2 hpq,
    hpx, hxq, (hactive p hbounds.1 (lt_of_le_of_lt hpx hx.2)).mp hp⟩

theorem barrier_transport
    {marks marks' : Set α} {active active' : α → Prop} {a b x : α}
    (ha : a ∈ marks) (hb : b ∈ marks)
    (hmarks : ∀ z, a ≤ z → z ≤ b → (z ∈ marks ↔ z ∈ marks'))
    (hactive : ∀ z, a ≤ z → z < b → (active z ↔ active' z))
    (hx : a < x ∧ x < b) :
    Barrier marks active x ↔ Barrier marks' active' x := by
  have hab : a ≤ b := le_of_lt (lt_trans hx.1 hx.2)
  have ha' : a ∈ marks' := (hmarks a le_rfl hab).mp ha
  have hb' : b ∈ marks' := (hmarks b hab le_rfl).mp hb
  constructor
  · exact barrier_transfer ha hb hmarks hactive hx
  · exact barrier_transfer ha' hb'
      (fun z hz hzb => (hmarks z hz hzb).symm)
      (fun z hz hzb => (hactive z hz hzb).symm) hx

theorem tangent_flag_of_entry
    (d s w : ℝ) (hd : 0 ≤ d)
    (hentry : ∃ t : ℝ, 0 < t ∧ 0 < d + t * s) :
    0 < d ∨ (d = 0 ∧ (0 < s ∨ (s = 0 ∧ 0 < w))) := by
  by_cases hpos : 0 < d
  · exact Or.inl hpos
  · have hz : d = 0 := by linarith
    refine Or.inr ⟨hz, Or.inl ?_⟩
    rcases hentry with ⟨t, ht, hvalue⟩
    by_contra hs
    have hprod : t * s ≤ 0 :=
      mul_nonpos_of_nonneg_of_nonpos (le_of_lt ht) (le_of_not_gt hs)
    nlinarith

theorem inactive_cutoff_buffer
    (N Q c c' : ℝ) (hN : Q < N)
    (hshift : |c' - c| ≤ Q) (hmissing : ¬ |c'| ≤ 4 * N) :
    3 * N < |c| := by
  have hc : -|c| ≤ c ∧ c ≤ |c| := abs_le.mp (le_refl |c|)
  have hs := abs_le.mp hshift
  have htriangle : |c'| ≤ |c| + Q := abs_le.mpr ⟨by linarith, by linarith⟩
  have hlarge : 4 * N < |c'| := lt_of_not_ge hmissing
  linarith

end PartitionTransport
