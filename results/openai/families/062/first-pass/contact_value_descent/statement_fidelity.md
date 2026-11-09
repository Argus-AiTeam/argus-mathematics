# Statement fidelity: contact-value descent and its arithmetic sublemma

## Geometric target C_DES_DESCENT

The target is exactly Proposition `des:descent` in the staged manuscript
`Contact-Fano-manifolds-and-the-LeBrun-Salamon-conjecture-September-23-2026`,
`build/sections/descent.tex`. The full geometric proof is in `report.md`.
**The geometric proposition is not formalized in Main.lean.**

| Object or quantifier | Manuscript meaning retained in the report |
|---|---|
| Ground field | C, characteristic zero. |
| X | Smooth simply connected complex projective contact Fano manifold; its analytic fundamental group is trivial. |
| F, theta, L | The given contact sequence, with nondegenerate L-valued Levi form; no replacement contact structure. |
| Picard hypothesis | Pic(X)=Z[L], not just a choice of some other ample line bundle. |
| Lines | A dense covering family of free maps f:P1->X with f*L=O(1); no standard splitting type or irreducible tangent-direction variety is assumed. |
| Z, M | X x X and the actual contact polarization L boxtimes L. |
| Y | Every proper integral algebraic space over C; no normality, projectivity, dimension, or fiber assumption is added. |
| p | Every dominant morphism Y->Z; no finiteness or flatness is required. |
| W12, W21 | Everywhere regular sections of the two vector bundles specified in the proposition, with exactly equal contact values xi. |
| Conclusion | Existence of exactly one everywhere regular B in H0(Z,M) satisfying p*B=xi, not just rational descent or descent to a different polarization. |

| Source obligation | Report location |
|---|---|
| `lines:positive`, `des:line-quotient` | Section 2 proves the intrinsic trivial quotient and its annihilated positive part for every free contact line. |
| Smooth dominant test evaluation | Section 2 derives an open full-Hom family from the assumed covering family. |
| Finite image, normalization, `des:base-open` | Section 3; no map from Y to its image's normalization is assumed. |
| `des:component-section`, `des:all-sheets` | Section 4; every dominating pullback component is used, including components without a generic K-point. |
| Detection of any branch divisor | Section 5 handles both projection cases, codimension-two avoidance, transversality, and meeting U simultaneously. |
| `des:branch-model`, `des:pullback-germ` | Section 6 constructs the analytic coordinates and the smooth dominating pullback germ; vertical or embedded components elsewhere are harmless. |
| Codimension-one unramifiedness | Section 6 treats an arbitrary ramification divisor and every positive integer index greater than one. |
| Purity at nonclosed points | Section 7 checks normality, regularity, quasi-finiteness, equal positive local dimensions, and all height-one generizations. |
| Connectedness and final descent | Section 7 obtains degree one analytically, finite birational descent algebraically, and uniqueness by dominance. |

The known source results used by the report are explicit assumptions of
C_DES_DESCENT in MATH_STATE.json. Engineer source reading is not an
independent citation approval. The other manuscript propositions remain
unverified; none is silently assumed as an input to this descent theorem.

## Exactly what Main.lean formalizes: C_DES_INTEGER_ORDER

The two declarations are:

1. `ContactValueDescent.exponent_mul_integer_ne_one` (unqualified declaration
   name: `exponent_mul_integer_ne_one`):
   for every natural number e with 2<=e and every integer m,
   `(e : Int) * m != 1`.
2. `ContactValueDescent.power_order_obstruction` (unqualified declaration
   name: `power_order_obstruction`):
   for every type A with a monoid structure, every function
   `order : A -> Int`, every natural e>=2, and all z,t in A, if
   `order (z^e) = (e : Int) * order z` and `order t = 1`,
   then `z^e != t`.

All these quantifiers and both order hypotheses are explicit. The function
`order` is not asserted to be a valuation; the theorem assumes only the
specified power equality. No field, analytic ring, smoothness, properness,
finite morphism, normalization, purity, or covering-space theorem is encoded.
Both conclusions use propositional `Not`, not Boolean inequality.
There are no user-declared axioms or omitted proof terms.

In report Section 6, after the independent geometric arguments produce a
degree-one sheet, instantiate A conceptually as the multiplicative monoid of
nonzero meromorphic germs on that sheet. The germ called t in the formal
statement represents `a(t_base)`, not necessarily the chosen base parameter.
Transversality gives its order one. Ordinary vanishing order gives the
power equality. The nonzero germ z represents the local branch coordinate
after absorbing the analytic unit; its e-th power is `a(t_base)`.
The second declaration rules out precisely this equality when e>=2.
This analytic instantiation is explained in prose, not constructed in Lean.

Thus a real successful Lean 4.31.0 compiler run certifies only the universal
integer-order obstruction. It cannot certify C_DES_DESCENT or the
classification. The compiler result must be bound to this unchanged file
and Main.lean by the official evidence command with
`--claim C_DES_INTEGER_ORDER`. Fidelity itself remains a human judgement.

## Standalone exact replay

`verify.py` rechecks the exact cubic discriminant and the stored typed
Jacobian result and validates the fresh compiler record for the arithmetic
sublemma. A finite cubic instance is not substituted for the universal
arithmetic theorem, and neither is substituted for the complete geometric
proof. Independent Reviewer examination of the report, its hypotheses, and
its citations is still required.
