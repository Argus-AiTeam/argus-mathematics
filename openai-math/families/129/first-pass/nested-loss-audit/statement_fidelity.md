# Statement fidelity: arbitrary-degree nested loss

**Claim:** `C_NEST_CHAIN`.
**Formal source:** `research/nested-loss-audit/Main.lean`.
**Main declaration:** `NestedLoss.Diagram.nested_chain_bound`.

## Objects and quantifiers

`X` is any finite type with a `Fintype` instance. Taking `X = Fin m`
gives every degree `m >= 1` in the manuscript. The Lean result also permits
the empty type, so it has no hidden lower-degree or enumeration restriction.
The two disjoint signed label sets are represented by `Bool × X`.
The Boolean coordinate is retained in every recurrent-class set; classes
of opposite signs cannot coincide or share labels.

`Rel X` is exactly `X -> X -> Prop`, with no functionality, totality,
symmetry, reflexivity, determinism, or nonemptiness restrictions.
`comp a b`, written `a ;; b`, means
`exists z, a x z and b z y`: this is the manuscript's path order.
`cl a` is `Relation.ReflTransGen a`, including length-zero paths.
Inequalities between relations are pointwise implications (edge inclusion).

`Diagram X` has four arbitrary relations `F`, `B`, `L`, and `R`.
Their coordinates use the common index type `X`; the roles of the source
and target copies are exactly those of the four blocks in `diagrams.tex`.
`Diagram.mul` is the four displayed finite-path product formulas.
Its `R` field initially uses
`B_b (R_a L_b)* R_a F_b`, to make reflection definitional.
`product_R_matches` proves equality with the manuscript's
`B_b R_a (L_b R_a)* F_b`; this is not an extra hypothesis.
The other three fields agree directly with `diag:product`.
The mathematical derivation of the product formulas from first-exit
paths is explained in the report. An independently implemented graph
reachability product in `verify.py` supplies finite cross-checks, not an
arbitrary-degree formalization of that separate semantic equivalence.

`Idem e` means `mul e e = e`.
`Nested d e` means both `mul e d = d` and `mul d e = d`.
It does not mean edge inclusion. Idempotency is supplied separately for
every diagram in the main theorem.

`K e = (L_e R_e)*`, `P e = K_e F_e K_e`, and
`U e d = K_e F_d K_e`.
`flip` exchanges `F,B` and `L,R`; `flip_mul` verifies reversal of product
order. `forSign` uses the original diagram for the positive sign and its
reflection for the negative sign. Consequently `signedP` and `signedU`
implement precisely the two signed relations in the manuscript, not just
the positive-sign surrogate.

## Classes, missingness, and the inequality

`classOf p x` consists of labels `y` with both `p x y` and `p y x`.
`classes p` is the image of the recurrent labels (`p x x`) under this
map. For the transitive relations proved here these are exactly the
nonempty recurrent equivalence classes, with no arbitrary representatives
or duplicate copies. `classes_disjoint` proves the requisite disjointness.

`missing p u` filters those classes that contain no `u`-loop.
The manuscript defines missingness using any point in the class.
`uniform_loop` and `missing_iff_at` prove the equivalence under the
corner absorptions. These absorptions are proved for adjacent nested
diagrams by `corner_absorption` and `signed_corner_absorption`, and for
every base-to-stage pair by `chain_through` and `signed_initial_corner`.
Thus the formal missing sets have the manuscript's meaning everywhere
they occur in the main theorem; a class with mixed missingness is not
silently treated as well-defined.

The theorem quantifies over `b : Nat -> Diagram X`, an arbitrary
`k : Nat`, and a finite signed-class set `j0`. Only `b 0` through `b k`
are used. Its hypotheses are exactly:

- `b n` is idempotent for every `n <= k`;
- `b (n+1)` is nested under `b n` for every `n < k`;
- `j0` is a subset of the recurrent signed classes of `b 0`;
- for every `n <= k`, the missing set of `b n` relative to `b 0`
  is contained in `j0`.

Its conclusion is the natural-number inequality

`sum (n in range k) card(M_(b n)(b (n+1))) <= 2 * card(j0)`.

Reindexing `n+1` as `j` gives exactly `nest:chain`. The empty chain,
empty budget, empty through relations, newly created return paths,
and merging recurrent classes are all included.

## Load-bearing declarations actually proved

`cl_union` and `cl_slide` establish both star rearrangements by finite-path
induction. `left_star_absorption`, `right_star_absorption`,
`through_absorption`, `absorption`, and `nested_K` prove
`nest:absorption`; no absorption assertion is assumed.

`finite_idempotent_factor` proves the finite recurrent-factor property
by an actual finite-pigeonhole argument. `rectangle_factor` derives the
through-edge factorization needed from `diag:rectangles`.
`containment_witness` derives the two recurrent old points and all four
new-class membership relations. `containment_from_witness` and
`signed_containment` prove exactly the one-nonmissing-or-two-old-classes
dichotomy, including whole-class containment. No rectangle or containment
assertion is assumed.

`step_budget` is the integral form of the half-weight argument:
`2 * new_unprotected + missing <= 2 * old_unprotected`.
The main theorem constructs persistent protected labels from the initial
nonbudget classes, proves missing classes unprotected, applies the
already-proved signed containment, and telescopes this inequality.
It protects every label in a nonbudget initial class instead of choosing
one. Uniformity proves all those labels retain loops, so this is a
valid stronger invariant and does not change the theorem's hypotheses.

## Trust and limits

The source contains no `sorry`, `admit`, user axiom, or assumed
manuscript-specific lemma. It uses Lean's ordinary classical mathematics
and Mathlib's kernel-checked finite-set and relation infrastructure.
The final `#print axioms` commands expose dependencies of the load-bearing
declarations. The compiler checks the encoded theorem, not this document.
An independent Reviewer must check this interpretation and the mathematical
first-exit interpretation of the coordinate product.

This certification does **not** establish `diag:transport`, the
amplification induction, either automata representation, or either
manuscript's exponential state lower bound. It certifies the nesting
mechanism, including the absorption and containment dependencies, only.
