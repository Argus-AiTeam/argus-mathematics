import Mathlib.Data.Fintype.Card
import Mathlib.Tactic

namespace AnalyticFisher

def NoncrossingPartition {m : ℕ} (R : Fin m → Fin m → Prop) : Prop :=
  ∀ a b c d, a < b → b < c → c < d → R a c → R b d → R a b

def NoCrossing {m : ℕ} (Q : Fin m → Fin m → Prop) : Prop :=
  ∀ a b c d, a < b → b < c → c < d → Q a c → Q b d → False

theorem noncrossing_union {m : ℕ} {R Q : Fin m → Fin m → Prop}
    (hR : NoncrossingPartition R)
    (refines : ∀ a b, Q a b → R a b)
    (within : ∀ a b c d, a < b → b < c → c < d →
      R a b → Q a c → Q b d → False) :
    NoCrossing Q := by
  intro a b c d hab hbc hcd hac hbd
  exact within a b c d hab hbc hcd
    (hR a b c d hab hbc hcd (refines a c hac) (refines b d hbd)) hac hbd

abbrev PairConstant {m k p : ℕ} (a b : Fin k → Fin m) (f : Fin m → Fin p) : Prop :=
  ∀ j, f (a j) = f (b j)

theorem pairing_label_bound {m k p : ℕ} (a b : Fin k → Fin m)
    (covers : ∀ i, ∃ j, i = a j ∨ i = b j) :
    Fintype.card {f : Fin m → Fin p // PairConstant a b f} ≤ p ^ k := by
  classical
  let encode : {f : Fin m → Fin p // PairConstant a b f} → (Fin k → Fin p) :=
    fun f j => f.val (a j)
  have injective : Function.Injective encode := by
    intro f g h
    apply Subtype.ext
    funext i
    obtain ⟨j, hj | hj⟩ := covers i
    · subst i
      exact congrFun h j
    · subst i
      exact (f.property j).symm.trans ((congrFun h j).trans (g.property j))
  simpa using Fintype.card_le_of_injective encode injective

theorem family_pairing_label_bound {m k p t : ℕ}
    (a b : Fin t → Fin k → Fin m)
    (covers : ∀ s i, ∃ j, i = a s j ∨ i = b s j) :
    Fintype.card {f : Fin m → Fin p // ∃ s, PairConstant (a s) (b s) f} ≤
      t * p ^ k := by
  classical
  let decode :
      (Σ s : Fin t, {f : Fin m → Fin p // PairConstant (a s) (b s) f}) →
      {f : Fin m → Fin p // ∃ s, PairConstant (a s) (b s) f} :=
    fun sf => ⟨sf.2.val, ⟨sf.1, sf.2.property⟩⟩
  have surjective : Function.Surjective decode := by
    intro f
    obtain ⟨s, hs⟩ := f.property
    exact ⟨⟨s, ⟨f.val, hs⟩⟩, rfl⟩
  calc
    Fintype.card {f : Fin m → Fin p // ∃ s, PairConstant (a s) (b s) f} ≤
        Fintype.card (Σ s : Fin t,
          {f : Fin m → Fin p // PairConstant (a s) (b s) f}) :=
      Fintype.card_le_of_surjective decode surjective
    _ = ∑ s : Fin t,
        Fintype.card {f : Fin m → Fin p // PairConstant (a s) (b s) f} := by
      simp only [Fintype.card_sigma]
    _ ≤ ∑ _s : Fin t, p ^ k := by
      apply Finset.sum_le_sum
      intro s _
      exact pairing_label_bound (a s) (b s) (covers s)
    _ = t * p ^ k := by simp

end AnalyticFisher
