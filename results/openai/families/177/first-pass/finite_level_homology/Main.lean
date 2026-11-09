import Mathlib

namespace FiniteLevelHomology

universe u v

structure AddTower where
  Obj : ℕ → Type u
  [group : ∀ n, AddCommGroup (Obj n)]
  down : ∀ n m, m ≤ n → (Obj n →+ Obj m)
  down_self : ∀ n x, down n n (le_refl n) x = x
  down_comp : ∀ l n m (hmn : m ≤ n) (hnl : n ≤ l) x,
    down n m hmn (down l n hnl x) = down l m (le_trans hmn hnl) x

attribute [instance] AddTower.group

structure TowerMap (A B : AddTower.{u}) where
  atLevel : ∀ n, A.Obj n →+ B.Obj n
  naturality : ∀ n m (hmn : m ≤ n) x,
    B.down n m hmn (atLevel n x) = atLevel m (A.down n m hmn x)

def EventuallyInImage {A B : AddTower.{u}} (f : TowerMap A B) : Prop :=
  ∀ m, ∃ n, ∃ hmn : m ≤ n, ∀ b : B.Obj n,
    ∃ a : A.Obj m, f.atLevel m a = B.down n m hmn b

theorem twoLayerEventuallyInImage
    {A B C A' B' C' : AddTower.{u}}
    (i : TowerMap A B) (p : TowerMap B C)
    (i' : TowerMap A' B') (p' : TowerMap B' C')
    (f : TowerMap A A') (g : TowerMap B B') (h : TowerMap C C')
    (left : ∀ n x, g.atLevel n (i.atLevel n x) =
      i'.atLevel n (f.atLevel n x))
    (right : ∀ n x, p'.atLevel n (g.atLevel n x) =
      h.atLevel n (p.atLevel n x))
    (p_onto : ∀ n, Function.Surjective (p.atLevel n))
    (target_exact : ∀ n y, p'.atLevel n y = 0 →
      ∃ z, i'.atLevel n z = y)
    (hf : EventuallyInImage f) (hh : EventuallyInImage h) :
    EventuallyInImage g := by
  intro m
  obtain ⟨n, hmn, hf_n⟩ := hf m
  obtain ⟨l, hnl, hh_l⟩ := hh n
  refine ⟨l, le_trans hmn hnl, ?_⟩
  intro y
  let yn := B'.down l n hnl y
  obtain ⟨c, hc⟩ := hh_l (p'.atLevel l y)
  obtain ⟨b, hb⟩ := p_onto n c
  have hpy : p'.atLevel n yn = h.atLevel n c := by
    calc
      p'.atLevel n yn =
          C'.down l n hnl (p'.atLevel l y) :=
        (p'.naturality l n hnl y).symm
      _ = h.atLevel n c := hc.symm
  have hz0 : p'.atLevel n (yn - g.atLevel n b) = 0 := by
    rw [map_sub, hpy, right, hb, sub_self]
  obtain ⟨z, hz⟩ := target_exact n (yn - g.atLevel n b) hz0
  obtain ⟨a, ha⟩ := hf_n z
  refine ⟨B.down n m hmn b + i.atLevel m a, ?_⟩
  calc
    g.atLevel m (B.down n m hmn b + i.atLevel m a) =
        B'.down n m hmn (g.atLevel n b) +
          i'.atLevel m (f.atLevel m a) := by
      rw [map_add, ← g.naturality, left]
    _ = B'.down n m hmn (g.atLevel n b) +
          B'.down n m hmn (i'.atLevel n z) := by
      rw [ha, ← i'.naturality]
    _ = B'.down n m hmn (g.atLevel n b + i'.atLevel n z) :=
      (map_add (B'.down n m hmn) _ _).symm
    _ = B'.down n m hmn yn := by
      rw [hz]
      congr 1
      abel
    _ = B'.down l m (le_trans hmn hnl) y :=
      B'.down_comp l n m hmn hnl y

theorem levelwiseSurjective {A B : AddTower.{u}} (f : TowerMap A B)
    (onto : ∀ n m (hmn : m ≤ n),
      Function.Surjective (B.down n m hmn))
    (eventual : EventuallyInImage f) :
    ∀ m, Function.Surjective (f.atLevel m) := by
  intro m b
  obtain ⟨n, hmn, hn⟩ := eventual m
  obtain ⟨y, hy⟩ := onto n m hmn b
  obtain ⟨a, ha⟩ := hn y
  exact ⟨a, ha.trans hy⟩

theorem surjectiveOfTransfer {A : Type u} {B : Type v}
    (inclusion : A → B) (transfer : B → A)
    (splits : ∀ b, inclusion (transfer b) = b) :
    Function.Surjective inclusion := by
  intro b
  exact ⟨transfer b, splits b⟩

theorem trivialActionOfSurjectiveFixedImages
    {G : Type u} [Group G] {H : Type v}
    (rho : G →* Equiv.Perm H) (generators : Set G)
    (generates : Subgroup.closure generators = ⊤)
    (A : G → Type v) (embed : ∀ g, A g → H)
    (onto : ∀ g ∈ generators, Function.Surjective (embed g))
    (fixed : ∀ g ∈ generators, ∀ x, rho g (embed g x) = embed g x) :
    ∀ g x, rho g x = x := by
  have hle : Subgroup.closure generators ≤ rho.ker := by
    apply (Subgroup.closure_le rho.ker).mpr
    intro g hg
    change rho g = 1
    ext x
    obtain ⟨y, rfl⟩ := onto g hg x
    exact fixed g hg y
  intro g x
  have hg : g ∈ Subgroup.closure generators := by
    rw [generates]
    trivial
  have hk := hle hg
  change rho g = 1 at hk
  rw [hk]
  rfl

theorem relativeIdentityReflection
    {S T U : Type u} [Ring S] [Ring T] [Ring U]
    (phi : S →+* T) (augmentation : S →+* U)
    (injective_on_kernel : ∀ x, augmentation x = 0 → phi x = 0 → x = 0)
    (x : S) (aug_x : augmentation x = 1) (phi_x : phi x = 1) :
    x = 1 := by
  apply sub_eq_zero.mp
  apply injective_on_kernel (x - 1)
  · simp [aug_x]
  · simp [phi_x]

theorem relativeWitnessIdentity {R : Type u} [Ring R]
    (b s : R) (witness : s = 1) :
    b + (1 - b) * s = 1 := by
  rw [witness, mul_one]
  abel

theorem complementarySupportsCommute {R : Type u} [Ring R]
    (x y : R) (xy : x * y = 0) (yx : y * x = 0) :
    (1 + x) * (1 + y) = (1 + y) * (1 + x) := by
  simp only [mul_add, add_mul, one_mul, mul_one, xy, yx, add_zero]
  abel

end FiniteLevelHomology
