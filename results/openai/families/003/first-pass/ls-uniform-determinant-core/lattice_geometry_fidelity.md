# Universal lattice-face selection: statement fidelity

## Certified declarations

`LatticeGeometry.lean` imports `Mathlib` and works in namespace
`LSLatticeGeometry`. Its principal declarations are:

```lean
theorem latticeFaceSelection : LatticeFaceSelection

theorem lattice_face_selection
    (N : ℕ) (hN : 1 ≤ N)
    (S : Finset Z4) (hSne : S.Nonempty) (hS : S ⊆ intBox N)
    (F : Z4 → ℂ) (hF : ∃ m, F m ≠ 0)
    (hFzero : ∀ m ∈ enlargedBox N, F m = 0) :
    ∃ u ∈ S, ∃ (m r : Z4) (k : ℤ),
      r ≠ 0 ∧ intDot r u = k ∧ F m ≠ 0 ∧
        ∀ n ∈ S, intDot r n ≠ k → F (m + n - u) = 0
```

Here `Z4 = Fin 4 → ℤ`,
`intBox N = Fintype.piFinset (fun _ => Finset.Ico 0 (N : ℤ))`,
`enlargedBox N = intBox (4 * (N - 1) + 1)`, and
`intDot r n = ∑ i, r i * n i`.
The definition of `LatticeFaceSelection` is the literal quantified
interface from `LSRectInterpolation.LatticeFaceSelection`, with only its
namespace changed. The duplicated lattice definitions unfold identically
to the interpolation file's definitions.

Neither declaration assumes the selection conclusion, a supporting-face
lemma, a rationality assertion, or any analytic or polynomial property of
`F`. There are no additional mathematical hypotheses.

## Whole-chain proof

1. Embed the integer lattice in real Euclidean four-space by coordinate
   casts. This is a closed embedding. Every subset of the lattice is
   closed, so the image of `{m | F m ≠ 0}` is closed even when it is
   infinite and `F` is completely arbitrary.
2. Set `P = convexHull ℝ (toE '' S)` and `K = 4 • P`. The finite convex hull
   is compact. Minimize distance to the closed nonzero support over `K`,
   then attain distance to that support using properness of Euclidean
   space. This produces a global minimizing pair `(m,y)` against every
   nonzero lattice point and every point of `K`.
3. Coordinate bounds put every integer point of `K` in `enlargedBox N`.
   Consequently `h = toE m - y` is nonzero. The real projection
   characterization gives the supporting inequality on `K`.
4. Apply Mathlib's positive-weight Caratheodory theorem to `p = y/4`.
   The supporting inequality and positivity force every point in this
   representation onto the same supporting face. Their difference span
   lies in the proper kernel of `inner h`, so affine independence bounds
   their number by four. A weight is therefore at least `1/4`; its point
   is `toE u` for some `u ∈ S`.
5. For every `n ∈ S`, subtract `1/4` from that weight and insert `toE n`
   with weight `1/4`. All weights remain nonnegative and sum to one.
   This proves `y + toE n - toE u ∈ K`.
6. If `F (m+n-u) ≠ 0`, global minimality makes this translated point a
   nearest point for `toE (m+n-u)`, with residual still `h`. Apply the
   projection inequality again, now testing against `y`. Together with
   the original inequality it forces
   `inner h (toE n) = inner h (toE u)`. This is the exact universal
   translation argument, not merely its sign identity.
7. Form the integral matrix `A` whose rows are `n-u` for all points of
   this supporting face in `S`. Its real kernel contains the nonzero
   vector `h`. Therefore the integral Gram matrix `B = Aᵀ*A` has zero
   determinant: first over the reals, then over the integers by
   injectivity of integer casts. Mathlib's integral-domain singular-matrix
   theorem supplies a nonzero **integer** vector `r` with `B*r = 0`.
   The identity `r·(B*r) = (A*r)·(A*r)` and the sum-of-squares criterion
   give `A*r = 0`. Hence every supporting-face point lies on
   `intDot r n = intDot r u`. Set `k = intDot r u`.
8. A nonzero translate must lie on that integer hyperplane, so every
   translate indexed by a point off the hyperplane vanishes, as required.

The integral Gram-matrix argument proves the needed rational-hyperplane
step without field-extension rank lemmas or denominator clearing.
Singleton sets, lower-dimensional hulls, and `N = 1` are included.

## Compiler evidence and axioms

Verified with Lean **4.31.0**, using the existing built Mathlib workspace:

```sh
cd $WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0
$WORKSPACE/.elan/bin/lake env lean \
  families/003/first-pass/ls-uniform-determinant-core/LatticeGeometry.lean
```

Compiler exit code: **0**. The actual compiler transcript, exported type,
version, exit status, and source SHA-256 are in `geometry_compile.log`.
Both principal declarations report exactly:

```text
[propext, Classical.choice, Quot.sound]
```

There is no `sorryAx`, `sorry`, `admit`, new axiom, or unsafe declaration.
No remaining geometry obligation is assumed or omitted. This certifies the
geometry interface, not the manuscript's analytic conclusions.
