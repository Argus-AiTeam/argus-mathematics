import Mathlib

open Finset

namespace CollisionCertificate

variable {V : Type*} [DecidableEq V]

inductive Upward (Z : Finset V) (parent : V → V) : V → V → Prop
  | refl (v : V) : Upward Z parent v v
  | step {m v : V} (h : Upward Z parent m v) (hp : parent v ∈ Z) :
      Upward Z parent m (parent v)

theorem upward_mem {Z U : Finset V} {parent : V → V} {m v : V}
    (h : Upward Z parent m v) (hm : m ∈ U)
    (closed : ∀ w ∈ U, parent w ∈ Z → parent w ∈ U) : v ∈ U := by
  induction h with
  | refl => exact hm
  | step h hp ih => exact closed _ ih hp

theorem marked_closure {Z U M : Finset V} {parent : V → V}
    (sub : U ⊆ Z) (marks : M ⊆ U)
    (cover : ∀ v ∈ Z, ∃ m ∈ M, Upward Z parent m v)
    (closed : ∀ w ∈ U, parent w ∈ Z → parent w ∈ U) : U = Z := by
  apply Finset.Subset.antisymm sub
  intro v hv
  obtain ⟨m, hm, path⟩ := cover v hv
  exact upward_mem path (marks hm) closed

def backwardCount (Z U : Finset V) (left right : V → V) (v : V) : ℕ :=
  (if left v ∉ Z ∨ left v ∈ U then 1 else 0) +
  (if right v ∉ Z ∨ right v ∈ U then 1 else 0)

theorem backwardCount_le (Z U : Finset V) (left right : V → V) (v : V) :
    backwardCount Z U left right v ≤ 2 := by
  unfold backwardCount
  split_ifs <;> omega

theorem saturated_backward {Z U : Finset V} {left right : V → V} {v : V}
    (h : backwardCount Z U left right v = 2) :
    (left v ∉ Z ∨ left v ∈ U) ∧ (right v ∉ Z ∨ right v ∈ U) := by
  by_cases hl : left v ∉ Z ∨ left v ∈ U
  · by_cases hr : right v ∉ Z ∨ right v ∈ U
    · exact ⟨hl, hr⟩
    · simp [backwardCount, hl, hr] at h
  · by_cases hr : right v ∉ Z ∨ right v ∈ U
    · simp [backwardCount, hl, hr] at h
    · simp [backwardCount, hl, hr] at h

theorem terminal_suffix_bound {Z U M : Finset V} {parent left right : V → V}
    (sub : U ⊆ Z) (proper : U ≠ Z)
    (cover : ∀ v ∈ Z, ∃ m ∈ M, Upward Z parent m v)
    (parent_slot : ∀ v ∈ Z, parent v = left v ∨ parent v = right v) :
    (∑ v ∈ U, backwardCount Z U left right v) +
      (if M ⊆ U then 1 else 0) ≤ 2 * U.card := by
  classical
  have total_le :
      (∑ v ∈ U, backwardCount Z U left right v) ≤ ∑ _v ∈ U, (2 : ℕ) :=
    Finset.sum_le_sum (fun v _ => backwardCount_le Z U left right v)
  have constant_sum : (∑ _v ∈ U, (2 : ℕ)) = 2 * U.card := by
    simp [Nat.mul_comm]
  by_cases hm : M ⊆ U
  · have not_saturated : ¬ ∀ v ∈ U, backwardCount Z U left right v = 2 := by
      intro saturated
      apply proper
      apply marked_closure sub hm cover
      intro v hv hp
      obtain ⟨hl, hr⟩ := saturated_backward (saturated v hv)
      rcases parent_slot v (sub hv) with heq | heq
      · rcases hl with outside | inside
        · exact False.elim (outside (heq ▸ hp))
        · exact heq ▸ inside
      · rcases hr with outside | inside
        · exact False.elim (outside (heq ▸ hp))
        · exact heq ▸ inside
    push_neg at not_saturated
    obtain ⟨v, hv, hne⟩ := not_saturated
    have strict :
        (∑ v ∈ U, backwardCount Z U left right v) < ∑ _v ∈ U, (2 : ℕ) := by
      apply Finset.sum_lt_sum (fun w _ => backwardCount_le Z U left right w)
      exact ⟨v, hv, by have := backwardCount_le Z U left right v; omega⟩
    rw [constant_sum] at strict
    simp only [if_pos hm]
    omega
  · simp only [if_neg hm, Nat.add_zero]
    exact constant_sum ▸ total_le

def forkMultiplicity (n : ℕ) : ℕ :=
  ∑ s ∈ Finset.range (n + 1), ∑ a ∈ Finset.range (s + 1), s.choose a

theorem forkMultiplicity_closed (n : ℕ) :
    forkMultiplicity n + 1 = 2 ^ (n + 1) := by
  have inner (s : ℕ) : (∑ a ∈ Finset.range (s + 1), s.choose a) = 2 ^ s := by
    simpa using Nat.sum_range_choose s
  induction n with
  | zero => norm_num [forkMultiplicity]
  | succ n ih =>
      have recur : forkMultiplicity (n + 1) = forkMultiplicity n + 2 ^ (n + 1) := by
        unfold forkMultiplicity
        rw [Finset.sum_range_succ, inner]
      rw [recur, pow_succ]
      omega

end CollisionCertificate
