# Statement fidelity for `Problem48.lean`

## Formal declaration

The declaration under review is `Problem48.problem48_counterexample`.

It states the following conditional proposition.  Let `X` be the formal term
`connectedSum E2 S2xS2`.  Given:

1. a predicate `Prime` and proofs that `T23` and `T25` satisfy it;
2. a predicate `AmbientAdmissible` and a proof that `X` satisfies it;
3. a relation `D.rel` equipped with symmetry and transitivity;
4. for every knot label `K`, a locality proof
   `knotSurgery X K ~ connectedSum (knotSurgery E2 K) S2xS2`; and
5. for every knot label `K`, a stabilization proof
   `connectedSum (knotSurgery E2 K) S2xS2 ~ X`;

the theorem constructs a witness with `K1 = T23`, `K2 = T25`, both marked
prime, distinct, not mirrors, and with diffeomorphic knot-surgery manifolds.

## Correspondence with the mathematical proof

- `AmbientAdmissible X` corresponds to the checked hypotheses that
  `X = E(2) # (S^2 x S^2)` is closed, simply connected and smooth, and that
  the regular elliptic fiber is square-zero with simply connected complement.
- `locality` corresponds to the cut-and-paste diffeomorphism
  `X_K -> E(2)_K # (S^2 x S^2)` when the connected sum is performed away from
  the elliptic fiber.
- `stabilization` corresponds exactly to Baykur's published
  one-`S^2 x S^2` stabilization theorem applied to `(E(2),F)`.
- Symmetry and transitivity of `D.rel` correspond to inversion and composition
  of diffeomorphisms.
- The `Prime T23` and `Prime T25` hypotheses correspond to the source-checked
  bridge-number argument.  Distinctness and non-mirroring of the finite labels
  are kernel-checked definitionally.

## Coverage boundary

Lean checks the complete logical composition from the three source-backed
topological inputs to the counterexample witness.  It does not formalize the
smooth 4-manifold definitions, Baykur's theorem, the elliptic-fiber complement
calculation, or the locality lemma from first principles.  Those remain
human-reviewed mathematical inputs and are not represented as hidden Lean
axioms: they appear explicitly as hypotheses of the theorem.
