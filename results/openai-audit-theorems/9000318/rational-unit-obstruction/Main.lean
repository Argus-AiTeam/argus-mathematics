namespace RationalUnitObstruction

theorem unitFirstDetection
    {B T : Type} (b0 : B) (t0 : T)
    (r : B × T → B)
    (unitFirst : ∀ b, r (b, t0) = b)
    (x : B × T)
    (secondVanishes : x.2 = t0)
    (naturality : r x = b0) :
    x = (b0, t0) := by
  have hx : x = (x.1, t0) := Prod.ext rfl secondVanishes
  have hfirst : x.1 = b0 := by
    calc
      x.1 = r (x.1, t0) := (unitFirst x.1).symm
      _ = r x := congrArg r hx.symm
      _ = b0 := naturality
  exact Prod.ext hfirst secondVanishes

theorem excludesEveryRetraction
    {B T : Type} (b0 : B) (t0 : T)
    (x : B × T)
    (secondVanishes : x.2 = t0)
    (nonzero : x ≠ (b0, t0)) :
    ¬ ∃ r : B × T → B,
      (∀ b, r (b, t0) = b) ∧ r x = b0 := by
  intro h
  obtain ⟨r, unitFirst, naturality⟩ := h
  exact nonzero
    (unitFirstDetection b0 t0 r unitFirst x secondVanishes naturality)

theorem cancelDetector
    {Y Z : Type} (d : Y → Z)
    (injective : ∀ a b, d a = d b → a = b)
    (y y0 : Y) (vanishes : d y = d y0) :
    y = y0 :=
  injective y y0 vanishes

end RationalUnitObstruction
