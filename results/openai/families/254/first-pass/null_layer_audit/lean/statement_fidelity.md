# Reading of `Main.lean`

The source proves general linear-algebra and bounded-transition lemmas in
namespace `NullLayerAudit`. It does **not** encode an Artin group, a zigzag
algebra, the actual transported complexes, the existence of the Weyl
subobjects, or Proposition `null:obstruction` itself. Their connection is
proved in `theorem.md` and remains a prose obligation for the independent
Reviewer. The ledger claim for this source is `K_NULL_CORE`, not
`N_OBSTRUCTION`.

All vector spaces in the first three declarations are arbitrary modules
over an arbitrary field. Every linear map and every spanning or exactness
property is an explicit hypothesis, not an axiom declaration.

* `middleExact` assumes that every cycle of `D` is a linear combination
  of two specified cycles plus a boundary, and that two specified linear
  functionals detect those two cycles and kill boundaries and middle
  elements. A projection identifies the middle part of a boundary with
  `a (p₀ u)`. The conclusion is that any embedded middle cycle is in the
  range of `a`. In the diagonal Hom application, the detectors are the
  diagonal length-zero coefficient and normalized Frobenius supertrace;
  off the cycle subspace the first detector is extended linearly.
* `middleExactAcyclic` proves the corresponding range conclusion when
  the whole cycle subspace consists of boundaries. This is the
  off-diagonal actual-Hom case.
* `secondaryKernelZero` assumes exactness only for cycles in a specified
  submodule `N`, not for the entire Hom complex. The two inclusions land
  in `N`; a projection detects the length-zero inclusion and kills both
  the correction inclusion and boundaries. Equality of the two
  differentials forces the original length-zero element to be zero.
  In the application `N` is the homogeneous negative-total-degree
  space containing the proposed cycle and its length-one correction.
  The cap and direct-summand hypotheses are what give the differential
  equality in the full Hom complex; they are proved in prose.

The separation declarations are over the real numbers with a finite
coordinate type `J`. The type `W` indexes the tests; it need not be
declared finite because finiteness is not required for these implications.

* `strictChamberDetect` has an explicit chamber-cover hypothesis for a
  given nonzero linear functional: it is a negative nonnegative,
  nontrivial combination of the coordinates of one test transformation.
  Strict coordinate inequalities at that test force a negative value.
* `finiteSeparation` assumes a nonempty test type, the same cover and
  strict inequalities, `B ≤ 0`, `H ≥ 0`, and
  `H ≤ B + η (e - s w)` at every test. It concludes the **linear map**
  `η = 0`, and the two scalar equalities `B = H = 0`.
  The actual finite Coxeter group supplies the cover; its elementary
  maximization proof is in `theorem.md`.
* `topVanishes` quantifies over an arbitrary finite real matrix with
  only `C j j = 2` prescribed. Two arrays agree away from `j`, both
  `j`-rows are zero, and their change satisfies the stated old-top
  count formula. The conclusion is `t = 0`. Symmetry, positive
  definiteness, and nonnegativity are not needed for this implication.

`MovePath R n s t` is an actual inductively defined path of **exactly**
`n` moves in the relation `R`. It is not a reachability assumption.

* `rankStage` assumes a natural-number rank bounded by `L`. From any
  good unfinished state a move increases the rank by one. Given
  `rank s + fuel = L`, it constructs a path of at most `fuel` moves
  to a state that is either not good or finished.
* `boundedStagesEscape` assumes a stage invariant, a stage construction
  of at most `L` actual moves that either exits good states or advances
  the invariant, and the incompatibility of the final invariant with
  goodness. It constructs a path of at most `N * L` moves to a state
  that is not good. It does not assume the existence of that final path.
  The manuscript application has
  `N = d_b - d_min + 1` interpreted as a positive natural number and
  `L = length(w_J)`. The stage construction is established from
  `rankStage`, the socle firing rule, and the preceding algebraic lemmas.

The source contains no `sorry`, `admit`, target-conclusion axiom, or
unchecked computational oracle. Its ordinary classical dependencies are
to be reported by the real compiler. A successful compiler run certifies
these parameterized implications only; it does not independently check
the categorical interpretation or mathematical novelty.
