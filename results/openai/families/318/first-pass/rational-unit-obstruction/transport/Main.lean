namespace CompletedPrimitiveTransport

structure Matrix2 (R : Type) where
  a00 : R
  a01 : R
  a10 : R
  a11 : R

structure Matrix3 (R : Type) where
  a00 : R
  a01 : R
  a02 : R
  a10 : R
  a11 : R
  a12 : R
  a20 : R
  a21 : R
  a22 : R

variable {R : Type} [OfNat R 0] [Add R] [Sub R] [Mul R]

def mul2 (x y : Matrix2 R) : Matrix2 R :=
  ⟨x.a00 * y.a00 + x.a01 * y.a10,
   x.a00 * y.a01 + x.a01 * y.a11,
   x.a10 * y.a00 + x.a11 * y.a10,
   x.a10 * y.a01 + x.a11 * y.a11⟩

def sub2 (x y : Matrix2 R) : Matrix2 R :=
  ⟨x.a00 - y.a00, x.a01 - y.a01,
   x.a10 - y.a10, x.a11 - y.a11⟩

def trace2 (x : Matrix2 R) : R := x.a00 + x.a11

def form2 (x y z : Matrix2 R) : R :=
  trace2 (mul2 x (sub2 (mul2 y z) (mul2 z y)))

def mul3 (x y : Matrix3 R) : Matrix3 R :=
  ⟨x.a00 * y.a00 + x.a01 * y.a10 + x.a02 * y.a20,
   x.a00 * y.a01 + x.a01 * y.a11 + x.a02 * y.a21,
   x.a00 * y.a02 + x.a01 * y.a12 + x.a02 * y.a22,
   x.a10 * y.a00 + x.a11 * y.a10 + x.a12 * y.a20,
   x.a10 * y.a01 + x.a11 * y.a11 + x.a12 * y.a21,
   x.a10 * y.a02 + x.a11 * y.a12 + x.a12 * y.a22,
   x.a20 * y.a00 + x.a21 * y.a10 + x.a22 * y.a20,
   x.a20 * y.a01 + x.a21 * y.a11 + x.a22 * y.a21,
   x.a20 * y.a02 + x.a21 * y.a12 + x.a22 * y.a22⟩

def sub3 (x y : Matrix3 R) : Matrix3 R :=
  ⟨x.a00 - y.a00, x.a01 - y.a01, x.a02 - y.a02,
   x.a10 - y.a10, x.a11 - y.a11, x.a12 - y.a12,
   x.a20 - y.a20, x.a21 - y.a21, x.a22 - y.a22⟩

def trace3 (x : Matrix3 R) : R := x.a00 + x.a11 + x.a22

def form3 (x y z : Matrix3 R) : R :=
  trace3 (mul3 x (sub3 (mul3 y z) (mul3 z y)))

def upperBlock (a v w : R) (x : Matrix2 R) : Matrix3 R :=
  ⟨a, v, w, 0, x.a00, x.a01, 0, x.a10, x.a11⟩

theorem parabolicTrace
    (addZero : ∀ x : R, x + 0 = x)
    (zeroAdd : ∀ x : R, 0 + x = x)
    (mulZero : ∀ x : R, x * 0 = 0)
    (zeroMul : ∀ x : R, 0 * x = 0)
    (subSelf : ∀ x : R, x - x = 0)
    (mulComm : ∀ x y : R, x * y = y * x)
    (a b c v₁ v₂ w₁ w₂ t₁ t₂ : R) (x y z : Matrix2 R) :
    form3 (upperBlock a v₁ v₂ x)
      (upperBlock b w₁ w₂ y) (upperBlock c t₁ t₂ z) =
    form2 x y z := by
  have hbc : b * c - c * b = 0 := by
    rw [mulComm b c]
    exact subSelf (c * b)
  simp only [form3, form2, trace3, trace2, mul3, mul2, sub3, sub2,
    upperBlock, addZero, zeroAdd, mulZero, zeroMul, subSelf, hbc]

theorem completedTransport
    {A T W WC D : Type}
    (pullback : A → T)
    (pullbackInjective : ∀ x y, pullback x = pullback y → x = y)
    (witt : A → WC) (base : W → WC)
    (baseInjective : ∀ x y, base x = base y → x = y)
    (coefficient : W → D)
    (scaleA : A → A) (scaleW : W → W)
    (scaleWC : WC → WC) (scaleD : D → D)
    (wittScalar : ∀ x, witt (scaleA x) = scaleWC (witt x))
    (baseScalar : ∀ x, base (scaleW x) = scaleWC (base x))
    (coefficientScalar : ∀ x,
      coefficient (scaleW x) = scaleD (coefficient x))
    (e₃ e₂ : A) (c₃ c₂ : W)
    (unit₃ : witt e₃ = base c₃)
    (unit₂ : witt e₂ = base c₂)
    (geometric : pullback e₃ = pullback (scaleA e₂))
    (zero : D)
    (nonzero : coefficient c₂ ≠ zero)
    (scalarNonzero : ∀ x, x ≠ zero → scaleD x ≠ zero) :
    coefficient c₃ = scaleD (coefficient c₂) ∧
      coefficient c₃ ≠ zero := by
  have hgeom : e₃ = scaleA e₂ :=
    pullbackInjective e₃ (scaleA e₂) geometric
  have hwitt : c₃ = scaleW c₂ := by
    apply baseInjective c₃ (scaleW c₂)
    calc
      base c₃ = witt e₃ := unit₃.symm
      _ = witt (scaleA e₂) := congrArg witt hgeom
      _ = scaleWC (witt e₂) := wittScalar e₂
      _ = scaleWC (base c₂) := congrArg scaleWC unit₂
      _ = base (scaleW c₂) := (baseScalar c₂).symm
  have hcoeff : coefficient c₃ = scaleD (coefficient c₂) := by
    calc
      coefficient c₃ = coefficient (scaleW c₂) :=
        congrArg coefficient hwitt
      _ = scaleD (coefficient c₂) := coefficientScalar c₂
  constructor
  · exact hcoeff
  · intro hzero
    exact scalarNonzero (coefficient c₂) nonzero (hcoeff.symm.trans hzero)

end CompletedPrimitiveTransport
