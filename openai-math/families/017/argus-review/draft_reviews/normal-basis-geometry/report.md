# Normal bases and coordinate-flat geometry

**Assessment:** the report gives a coherent characteristic-zero geometric argument, but it is substantially more than the Lean core or the rank-two example. Those certificates alone would leave specific geometric obligations unproved.

## Exact statement and provenance

Inventory A04 section 3 develops old claim `C_GEOM_BASES`; the original source is OpenAI's September 24, 2026 interpolation section, revision `4eaee87548250b2682affda7d05d947c05554bae`, particularly `geom:all-bases` and `geom:log-differential`. Current claim: `C_GEOM_BASES`.

Let `Z` be a proper irreducible algebraic component of positive dimension in the affine chart `Y!=0`. Use

    D0 = Y partial_Y + sum_i partial_Xi,  Di = partial_Xi (i>0).

For every coordinate normal basis `A` and frame normal basis `B`, suppose the product bound `product_A w <= C* product_B v` holds. Require the separated opposite strict inequality for all equal-cardinality sets of sizes 1 through `m` whose largest positive symmetric-difference index belongs to `A`. Here `vi=wi/theta`, and `C*` is the uniform multiplicity constant. The ambient conclusion is that `Y` is constant. In the analogous positive-coordinate system **within a constant-Y fiber**, the conclusion is containment in a proper coordinate flat.

This assertion is not for arbitrary analytic subvarieties, characteristic-positive algebraic varieties, or an arbitrary collection of numerical basis labels. The quotient bases must be actual bases at general smooth points.

## Argument checked

If some positive coordinate direction is not tangent, choose the largest such index `i`. Its nonzero image in the normal quotient extends to a coordinate basis containing `i`. Higher positive directions are tangent, so none occur in either kind of normal basis. A frame basis omitting `i` would have largest positive differing index `i`, contradicting the two product inequalities. Consequently **every** frame basis contains `i`.

Removing `Di` therefore leaves a family that does not span the normal quotient. This uses ordinary basis extraction from a spanning finite family; non-spanning cannot be inferred merely from one rank-two numerical example. On `Y!=0` the ambient span of the remaining fields is exactly

    Qi = ker(dXi - dY/Y).

Indeed, any vector in this hyperplane has the expression

    (vY/Y) D0 + sum_(j!=i) (vj-vY/Y) Dj.

Thus `Qi+TZ` is proper. If a tangent vector lay outside the hyperplane, that vector and the hyperplane would span the whole ambient space. Hence `TZ` is contained in `Qi`, giving `dXi=dY/Y` along the smooth locus.

The next step is genuinely algebraic geometry. If `Y` were nonconstant, choose a smooth point where `dY` is nonzero and an algebraic linear slice whose tangent line has nonzero `dY`. Its component through the point is an algebraic curve with nonconstant `Y`. On the complete smooth model, `dXi=dY/Y` holds meromorphically. A nonconstant rational function `Y` has a zero or pole; at such a point, `Y=s^r u`, `r!=0`, gives residue `r` for `dY/Y`. The derivative of a meromorphic function has residue zero, since the potential coefficient from differentiating its constant term is zero. This is a contradiction over `C`. Then `dXi=0`, so `Xi` is constant too.

If all positive directions are tangent, a proper tangent subspace containing their `m`-dimensional span must equal that span, and `dY=0`. This covers the alternative omitted by an argument using only a selected nontangent direction.

Within a constant-Y fiber, use the `m` positive-coordinate directions and the corresponding all-bases inequalities. Two distinct basis sets have a largest positive differing index, so separation forces the family to consist of a single set `S`. It is nonempty for a proper component. For each `i` in `S`, removing that coordinate prevents spanning the quotient, hence `dXi=0`. Those coordinates are constant, placing the component in a proper coordinate flat. The curve proofs obtain the needed fiber inequalities by running persistence in the fiber; they do not pretend that an arbitrary ambient bound automatically has every fiber hypothesis.

## Inputs and remaining boundary

Complete smooth curve models use Stacks Theorem 53.2.6 (`0BY1`) and Lemma 53.2.8 (`0BY3`), archived as A27/A28; perfection holds for `C`. This input is registered as `A_PROJECTIVE_CURVE_MODEL`. Algebraic slicing, extension of a rational differential identity, and the characteristic-zero residue argument are explicitly discussed above rather than attributed to a compiler.

A09 formalizes the hyperplane implication, invertible shear and finite-set product contradictions. A15 expressly excludes the span identification, quotient-basis extraction, residues, and algebraic constancy. The rank example in A06/A07 has three rows; it cannot establish these statements in arbitrary dimension. The report supplies the missing arguments in prose, so this limitation of the certificates is not by itself a gap in the written proof.

The strongest supported scope is the above geometric lemma with actual normal bases and the stated separation, using the multiplicity result when it is invoked. Independent review of these nonformal steps remains required. No conclusion about an entire manuscript or about novelty follows.
