import Mathlib

namespace PrefixCollisions

open Finset

noncomputable section

def allocations (k : ℕ) : List ℕ → Finset (Fin k → ℕ)
  | [] => by classical exact {fun _ => 1}
  | p :: ps => by
      classical
      exact univ.biUnion fun j =>
        (allocations k ps).image fun f => Function.update f j (p * f j)

theorem prod_update_mul (k p : ℕ) (f : Fin k → ℕ) (j : Fin k) :
    (∏ a, Function.update f j (p * f j) a) = p * ∏ a, f a := by
  classical
  rw [prod_update_of_mem (mem_univ j),
    prod_eq_mul_prod_sdiff_singleton_of_mem (mem_univ j) f]
  ac_rfl

theorem card_allocations_le (k : ℕ) (ps : List ℕ) :
    (allocations k ps).card ≤ k ^ ps.length := by
  classical
  induction ps with
  | nil => simp [allocations]
  | cons p ps ih =>
      have h := card_biUnion_le_card_mul
        (univ : Finset (Fin k))
        (fun j => (allocations k ps).image
          (fun f => Function.update f j (p * f j)))
        (k ^ ps.length)
        (fun _ _ => card_image_le.trans ih)
      simpa [allocations, pow_succ, Nat.mul_comm] using h

theorem allocations_sound (k : ℕ) (ps : List ℕ) (f : Fin k → ℕ)
    (hf : f ∈ allocations k ps) :
    (∏ a, f a) = ps.prod := by
  classical
  induction ps generalizing f with
  | nil =>
      simp only [allocations, mem_singleton] at hf
      subst f
      simp
  | cons p ps ih =>
      obtain ⟨j, _, himage⟩ := mem_biUnion.mp hf
      obtain ⟨g, hg, rfl⟩ := mem_image.mp himage
      rw [prod_update_mul, ih g hg, List.prod_cons]

theorem allocations_complete (k : ℕ) (ps : List ℕ)
    (hps : ∀ p ∈ ps, Nat.Prime p) (f : Fin k → ℕ)
    (hf : (∏ a, f a) = ps.prod) :
    f ∈ allocations k ps := by
  classical
  induction ps generalizing f with
  | nil =>
      have hf1 : (∏ a, f a) = 1 := by simpa using hf
      have heq : f = fun _ => 1 := by
        funext j
        apply Nat.eq_one_of_dvd_one
        rw [← hf1]
        exact dvd_prod_of_mem f (mem_univ j)
      simp [allocations, heq]
  | cons p ps ih =>
      have hp : Nat.Prime p := hps p (by simp)
      have hdiv : p ∣ ∏ a, f a := by
        rw [hf, List.prod_cons]
        exact dvd_mul_right p ps.prod
      obtain ⟨j, _, hj⟩ := (hp.prime.dvd_finsetProd_iff f).mp hdiv
      obtain ⟨z, hz⟩ := hj
      let g : Fin k → ℕ := Function.update f j z
      have hfg : Function.update g j (p * g j) = f := by
        funext a
        by_cases ha : a = j
        · subst a
          simp [g, hz]
        · simp [g, ha]
      have hprod : (∏ a, f a) = p * ∏ a, g a := by
        calc
          (∏ a, f a) = ∏ a, Function.update g j (p * g j) a := by rw [hfg]
          _ = p * ∏ a, g a := prod_update_mul k p g j
      have hg : (∏ a, g a) = ps.prod := by
        apply Nat.eq_of_mul_eq_mul_left hp.pos
        calc
          p * (∏ a, g a) = ∏ a, f a := hprod.symm
          _ = p * ps.prod := by simpa using hf
      have hmem : g ∈ allocations k ps :=
        ih (fun q hq => hps q (List.mem_cons_of_mem p hq)) g hg
      exact mem_biUnion.mpr ⟨j, mem_univ j, mem_image.mpr ⟨g, hmem, hfg⟩⟩

def factorizations (k n : ℕ) : Finset (Fin k → ℕ) :=
  allocations k n.primeFactorsList

theorem mem_factorizations_iff (k n : ℕ) (hn : n ≠ 0) (f : Fin k → ℕ) :
    f ∈ factorizations k n ↔ (∏ a, f a) = n := by
  constructor
  · intro hf
    exact (allocations_sound k n.primeFactorsList f hf).trans
      (Nat.prod_primeFactorsList hn)
  · intro hf
    exact allocations_complete k n.primeFactorsList
      (fun _ hp => Nat.prime_of_mem_primeFactorsList hp) f
      (hf.trans (Nat.prod_primeFactorsList hn).symm)

theorem ordered_factorizations_bound (k n : ℕ) :
    (factorizations k n).card ≤ k ^ n.primeFactorsList.length :=
  card_allocations_le k n.primeFactorsList

theorem two_residuals_bound (k₁ k₂ k n n' : ℕ)
    (hk₁ : k₁ ≤ k) (hk₂ : k₂ ≤ k) :
    ((factorizations k₁ n).product (factorizations k₂ n')).card ≤
      k ^ (n.primeFactorsList.length + n'.primeFactorsList.length) := by
  rw [Finset.product_eq_sprod, Finset.card_product, pow_add]
  exact Nat.mul_le_mul
    ((ordered_factorizations_bound k₁ n).trans
      (Nat.pow_le_pow_left hk₁ n.primeFactorsList.length))
    ((ordered_factorizations_bound k₂ n').trans
      (Nat.pow_le_pow_left hk₂ n'.primeFactorsList.length))

def collisionPairs {α β : Type*} [DecidableEq α] [DecidableEq β]
    (T : Finset α) (F : α → β) : Finset (α × α) :=
  (T.product T).filter fun z => z.1 ≠ z.2 ∧ F z.1 = F z.2

theorem collisionPairs_mono {α β : Type*} [DecidableEq α] [DecidableEq β]
    (T U : Finset α) (F : α → β) (h : U ⊆ T) :
    collisionPairs U F ⊆ collisionPairs T F := by
  intro z hz
  obtain ⟨hpair, hval⟩ := mem_filter.mp hz
  obtain ⟨ha, hb⟩ := mem_product.mp hpair
  exact mem_filter.mpr ⟨mem_product.mpr ⟨h ha, h hb⟩, hval⟩

theorem endpoint_restriction_bound {α β : Type*}
    [DecidableEq α] [LinearOrder β] (T : Finset α) (F : α → β) (t : β) :
    (collisionPairs (T.filter fun a => F a ≤ t) F).card ≤
      (collisionPairs T F).card :=
  card_le_card (collisionPairs_mono T _ F (filter_subset _ _))

end

end PrefixCollisions
