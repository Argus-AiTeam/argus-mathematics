import Mathlib

namespace OrdinaryCutoff

open Filter

variable {F M X : Type*} [Field F]
  [AddCommGroup M] [Module F M]
  [AddCommGroup X] [Module F X]

def stable (S : Module.End F M) : Submodule F M :=
  ⨅ n : ℕ, LinearMap.range (S ^ n)

def nilpotentPart (S : Module.End F M) : Submodule F M :=
  ⨆ n : ℕ, LinearMap.ker (S ^ n)

theorem intertwines_pow (S : Module.End F M) (T : Module.End F X)
    (f : M →ₗ[F] X) (commutes : ∀ m, f (S m) = T (f m)) :
    ∀ n m, f ((S ^ n) m) = (T ^ n) (f m) := by
  intro n
  induction n with
  | zero => intro m; simp
  | succ n ih =>
      intro m
      rw [pow_succ', Module.End.mul_apply, commutes, ih,
        pow_succ', Module.End.mul_apply]

theorem preserves_stable (S : Module.End F M) (T : Module.End F X)
    (f : M →ₗ[F] X) (commutes : ∀ m, f (S m) = T (f m))
    {m : M} (hm : m ∈ stable S) :
    f m ∈ stable T := by
  apply (Submodule.mem_iInf _).mpr
  intro n
  obtain ⟨v, hv⟩ := (Submodule.mem_iInf _).mp hm n
  exact ⟨f v, by rw [← intertwines_pow S T f commutes n, hv]⟩

theorem split_transfer_bijective [FiniteDimensional F X]
    (T Φ : Module.End F X) (split : ∀ x, T (Φ x) = x) :
    Function.Bijective T := by
  have hs : Function.Surjective T := fun x => ⟨Φ x, split x⟩
  exact ⟨LinearMap.injective_iff_surjective.mpr hs, hs⟩

theorem stable_cutoff_of_split
    [FiniteDimensional F M] [FiniteDimensional F X]
    (S : Module.End F M) (T Φ : Module.End F X)
    (f : M →ₗ[F] X)
    (commutes : ∀ m, f (S m) = T (f m))
    (split : ∀ x, T (Φ x) = x)
    (kernel_nilpotent : ∀ m, f m = 0 → ∃ n : ℕ, (S ^ n) m = 0)
    (absorption : ∃ n : ℕ, ∀ x, ∃ m, f m = (T ^ n) x) :
    Function.Bijective (fun m : stable S => f m) := by
  have ht := split_transfer_bijective T Φ split
  have ht_pow : ∀ n : ℕ, Function.Bijective (T ^ n) := by
    intro n
    simpa only [Module.End.coe_pow] using ht.iterate n
  have hnil : nilpotentPart S ≤ LinearMap.ker f := by
    apply iSup_le
    intro n m hm
    apply (ht_pow n).1
    rw [← intertwines_pow S T f commutes n]
    simpa using congrArg f hm
  have hdisjoint : Disjoint (nilpotentPart S) (stable S) :=
    (LinearMap.isCompl_iSup_ker_pow_iInf_range_pow S).disjoint
  have hsurj : Function.Surjective f := by
    obtain ⟨n, hn⟩ := absorption
    intro x
    obtain ⟨y, hy⟩ := (ht_pow n).2 x
    obtain ⟨m, hm⟩ := hn y
    exact ⟨m, hm.trans hy⟩
  constructor
  · intro u v huv
    have hker : f ((u : M) - v) = 0 := by
      simp [map_sub, huv]
    obtain ⟨n, hn⟩ := kernel_nilpotent _ hker
    have hnilmem : (u : M) - v ∈ nilpotentPart S :=
      (le_iSup (fun n : ℕ => LinearMap.ker (S ^ n)) n) hn
    have hstable : (u : M) - v ∈ stable S := (stable S).sub_mem u.2 v.2
    have hz : (u : M) - v = 0 := by
      have hbot : (u : M) - v ∈ (⊥ : Submodule F M) := by
        rw [← disjoint_iff.mp hdisjoint]
        exact ⟨hnilmem, hstable⟩
      exact hbot
    exact Subtype.ext (sub_eq_zero.mp hz)
  · intro x
    obtain ⟨m, hm⟩ := hsurj x
    have htop : nilpotentPart S ⊔ stable S = ⊤ :=
      (LinearMap.isCompl_iSup_ker_pow_iInf_range_pow S).sup_eq_top
    have hmem : m ∈ nilpotentPart S ⊔ stable S := by
      rw [htop]
      trivial
    obtain ⟨u, hu, v, hv, huv⟩ := Submodule.mem_sup.mp hmem
    refine ⟨⟨v, hv⟩, ?_⟩
    have hfu : f u = 0 := hnil hu
    have hsum : f u + f v = x := by rw [← map_add, huv, hm]
    simpa [hfu] using hsum

theorem stable_action_naturality
    {M' X' : Type*} [AddCommGroup M'] [Module F M']
    [AddCommGroup X'] [Module F X']
    (S : Module.End F M) (S' : Module.End F M')
    (a : M →ₗ[F] M') (f : M →ₗ[F] X) (f' : M' →ₗ[F] X')
    (b : X →ₗ[F] X')
    (transfer_naturality : ∀ m, a (S m) = S' (a m))
    (coefficient_naturality : ∀ m, f' (a m) = b (f m))
    (m : stable S) :
    f' (⟨a m, preserves_stable S S' a transfer_naturality m.2⟩ : stable S') =
      b (f m) := by
  exact coefficient_naturality m

section ProcyclicNorm

variable {R : Type*} [CommRing R]

def normFive (g : R) : R := 1 + g + g ^ 2 + g ^ 3 + g ^ 4

theorem norm_chain_identity (g : R) :
    (g - 1) * normFive g = g ^ 5 - 1 := by
  unfold normFive
  ring

theorem characteristic_five_norm :
    normFive (Polynomial.X : Polynomial (ZMod 5)) =
      (Polynomial.X - 1) ^ 4 := by
  have h5 : (5 : Polynomial (ZMod 5)) = 0 := CharP.cast_eq_zero _ 5
  unfold normFive
  linear_combination
    (Polynomial.X ^ 3 - Polynomial.X ^ 2 + Polynomial.X) * h5

theorem trivial_character_corestriction :
    normFive (1 : ZMod 5) = 0 := by
  decide

end ProcyclicNorm

end OrdinaryCutoff
