import Mathlib.LinearAlgebra.Projection

namespace SupportedEuler

variable {R M N Q : Type*} [Ring R]
variable [AddCommGroup M] [Module R M]
variable [AddCommGroup N] [Module R N]
variable [AddCommGroup Q] [Module R Q]

theorem fixed_of_mem_range
    (p : M →ₗ[R] M) (hp : p.comp p = p)
    {x : M} (hx : x ∈ LinearMap.range p) : p x = x := by
  obtain ⟨y, rfl⟩ := hx
  exact DFunLike.congr_fun hp y

theorem range_inter_eq_map
    (p : M →ₗ[R] M) (hp : p.comp p = p)
    (F : Submodule R M) (hF : ∀ x ∈ F, p x ∈ F) :
    LinearMap.range p ⊓ F = F.map p := by
  apply le_antisymm
  · intro x hx
    exact ⟨x, hx.2, fixed_of_mem_range p hp hx.1⟩
  · intro x hx
    obtain ⟨y, hy, rfl⟩ := hx
    exact ⟨⟨y, rfl⟩, hF y hy⟩

theorem exact_on_ranges
    (f : M →ₗ[R] N) (g : N →ₗ[R] Q)
    (a : M →ₗ[R] M) (b : N →ₗ[R] N)
    (hb : b.comp b = b) (hfa : f.comp a = b.comp f)
    (hex : ∀ y : N, g y = 0 ↔ ∃ x : M, f x = y) :
    ∀ y : N, y ∈ LinearMap.range b →
      (g y = 0 ↔ ∃ x : M, x ∈ LinearMap.range a ∧ f x = y) := by
  intro y hy
  constructor
  · intro h
    obtain ⟨x, hx⟩ := (hex y).mp h
    refine ⟨a x, ⟨x, rfl⟩, ?_⟩
    calc
      f (a x) = b (f x) := DFunLike.congr_fun hfa x
      _ = b y := congrArg b hx
      _ = y := fixed_of_mem_range b hb hy
  · rintro ⟨x, _, hx⟩
    exact (hex y).mpr ⟨x, hx⟩

theorem surjective_on_ranges
    (g : N →ₗ[R] Q) (b : N →ₗ[R] N) (c : Q →ₗ[R] Q)
    (hc : c.comp c = c) (hgc : g.comp b = c.comp g)
    (hgs : Function.Surjective g) :
    ∀ z : Q, z ∈ LinearMap.range c →
      ∃ y : N, y ∈ LinearMap.range b ∧ g y = z := by
  intro z hz
  obtain ⟨y, hy⟩ := hgs z
  refine ⟨b y, ⟨y, rfl⟩, ?_⟩
  calc
    g (b y) = c (g y) := DFunLike.congr_fun hgc y
    _ = c z := congrArg c hy
    _ = z := fixed_of_mem_range c hc hz

theorem injective_on_range
    (f : M →ₗ[R] N) (a : M →ₗ[R] M)
    (hf : Function.Injective f) :
    Function.Injective (fun x : LinearMap.range a => f x) := by
  intro x y h
  exact Subtype.ext (hf h)

theorem invariant_quotient_fixed_lift
    (p : M →ₗ[R] M) (hp : p.comp p = p)
    (F G : Submodule R M) (hG : ∀ x ∈ G, p x ∈ G)
    {x : M} (hxG : x ∈ G) (hxF : p x - x ∈ F) :
    ∃ y : M, y ∈ G ∧ p y = y ∧ y - x ∈ F := by
  refine ⟨p x, hG x hxG, ?_, hxF⟩
  exact DFunLike.congr_fun hp x

end SupportedEuler
