# External inputs, attribution and bounded prior art

**Assessment:** the consulted primary propositions support the indicated standard inputs and methodological precedents under their own hypotheses. They do not establish novelty of the density extension. Source reading and formal citation-attribution status are separate: the current ledger's ten bindings remain independently unchecked.

## Provenance and complete assumption coverage

Old A01 records `C_K1_PRIOR_ART` and the external assumptions on the geometric claims; A04 section 8 describes the lookup. These are old Argus attribution assertions, not original mathematical contributions. All 13 supplied literature artifacts, A16-A28, were examined at their actual propositions. The original comparison manuscript is OpenAI's September 24, 2026 source, revision `4eaee87548250b2682affda7d05d947c05554bae`.

| External input | Proposition read; exact limitation |
|---|---|
| `A_ISOLATED_BEZOUT` | Mondal, **arXiv:1806.05346v5**, Corollary VIII.3 and IV.4.2 (38)-(39), Proposition IV.28(2). A17 lines 3964-3990, 8316-8320: local quotient lengths at a nonsingular point, finite precisely at an isolated zero; isolated-solution product-degree bound, without requiring every global component to be zero-dimensional. |
| `A_PROJECTIVE_CURVE_MODEL` | Stacks `0BY1`, Theorem 53.2.6, and `0BY3`, Lemma 53.2.8 (A27-A28, HTML lines 175ff and 173-177). The model is normal/nonsingular; smoothness uses a perfect field, which `C` is. |
| `A_CURVE_DEGREES` | Stacks `0AYU`, `0AYY`, `0B40` (A23-A25, lines 175ff): degree under birational pullback on proper schemes of dimension at most one; effective Cartier divisor length; nonnegative degree from a nonzero section on a proper curve. These are not unconditional positivity assertions. |
| `A_BLOWUP` | Stacks `02OS`, `02ND`, `02NS` (A18-A20, lines 175ff): Cartier exceptional divisor and isomorphism off the center; integrality requires an integral base and nonzero ideal; projectivity and relative ampleness require a finite-type ideal. |
| `A_REES_EVENTUAL` | Stacks `0AG7`, `0AG6` (A21-A22, lines 175ff): Noetherian degree-zero ring, finite generation in degree one, finite graded module/coherent sheaf; eventual graded-piece identification and higher-cohomology vanishing. No assertion about every small degree or integral closure is substituted. |
| `A_SERRE_VANISHING` | Stacks `0B5U`, Lemma 30.17.1 (1)->(2) (A26, lines 177-190): proper scheme over a Noetherian affine base and ample invertible sheaf. |
| `A_AMPLE_PLUS_NEF` | Lazarsfeld, *Positivity in Algebraic Geometry I* (2004), **DOI 10.1007/978-3-642-18808-4**, Corollary 1.4.10, p.53 (A16 lines 2414-2432). A nef real divisor plus a positive multiple of an ample real divisor is ample on a **projective variety or scheme**. |

The corresponding mathematical applications, including ordinary Rees powers and the possibly singular projective closure, are analyzed in the multiplicity, normal-basis, curve and bridge reports. They are assumptions taken from named sources, not kernel-proved geometric consequences.

## Farhi: product obstruction is not arbitrary-center interpolation

The primary [arXiv v1 PDF](https://arxiv.org/pdf/math/0603257v1) and [v1 source](https://arxiv.org/e-print/math/0603257v1) were read at **section 5.2, Theorem 5.3**, pp.35-37, and **section 5.2.1, Corollary 5.4**, pp.42-43. Current assumption: `A_FARHI_PRODUCTS`.

Theorem 5.3 treats one specified point on a product of irreducible commutative algebraic groups defined over a number field, with positive dimensions `gi`, suitable local addition laws of bidegree `(c,c')`, and a nonzero multihomogeneous form of multidegree `delta`. With `g=sum gi`, it assumes `0<epsilon<=1`, `delta_i>=gi+1`, and, for `1<=i<p`,

    delta_i/delta_(i+1) > (p c'/epsilon)^g product_j d(Gj).

Vanishing at the point for the weighted derivative staircase `sum_i |alpha_i|/delta_i < g epsilon` produces a proper subvariety containing it, whose geometric components are products and form one Galois orbit. It supplies a degree bound with a factor counting geometric components and persistence for the smaller `epsilon` staircase, as well as a height bound. The component count is **not** a number of interpolation centers.

Corollary 5.4 specializes to products of powers of `G_m` and one rational point, with the corresponding degree and product-component conclusion. Its literal adjacent-degree condition is printed with endpoint `i<=p`, leaving `delta_(p+1)` undefined. The well-posed range `i<p` in Theorem 5.3 supports the methodological comparison; this review does not silently repair the corollary or use a corrected version as a theorem. This is a citation-scope observation, not a new attack on the pi manuscript.

Neither passage states the arbitrary-center coordinate-flat packet criterion `nT theta^|T|<1`. The old report's product-shaped-obstruction comparison is warranted at this limited level, not as an identification of the two theorems.

## Philippon: sumsets and subgroup obstructions

The primary [1986 journal article](https://www.numdam.org/item/10.24033/bsmf.2060.pdf), **DOI 10.24033/bsmf.2060**, was read at **Theorem 2.1**, pp.357-358, and **Lemma 5.1 and proof**, pp.380-383. Current assumption: `A_PHILIPPON_PERSISTENCE`.

The theorem uses a product of commutative algebraic groups over `C` or `C_l`, an analytic subgroup `A`, and a finite set `Sigma` containing zero. With `n=dim G`, a nonzero multihomogeneous polynomial must vanish along `A` to order at least `nT+1` at every point of the **n-fold sumset** `Sigma(n)`. Its conclusion concerns a connected algebraic subgroup, incomplete degree-controlled defining equations and a bound involving `binomial(T+s,s)`, distinct subgroup cosets and a multihomogeneous Hilbert-Samuel form. The statement does not itself call that subgroup proper.

Lemma 5.1's translated derivative ideals and a stabilized component provide derivative persistence on translated components; the stabilizer and its identity component enter the subgroup/coset conclusion. These are genuine precedents for the derivative-chain method. They are not a theorem about arbitrary prescribed centers with only the coordinate-flat occupancy condition.

The [1987 addendum](https://www.numdam.org/item/10.24033/bsmf.2084.pdf), DOI `10.24033/bsmf.2084`, p.398, strengthens a translated-vanishing conclusion. It is mentioned only to distinguish versions: the current assumption is the **1986** statement, not an unannounced import of the addendum.

## Negative lookup and independence boundary

The finding is that these specific passages do not contain the exact density theorem. It is not an exhaustive search and cannot justify novelty. The old report records that Demailly 1992 section 6 could not be obtained in its lookup and was unused. That inherited failed retrieval is recorded with its reason; it is not a claim that the source is unavailable now, nor an assumed theorem. The supplied Wiki index has no relevant family-017 interpolation entry.

The full old ledger contains 27 versions of 16 claims and 24 evidence records, including 22 human judgements from an Engineer and a reviewer-labelled actor. Those records are historical data. They do not resolve the old report's explicit pending-review caveats or authorize this Engineer to accept the present family review.

The current `citation_check status --project-root campaigns/9200017` returned exit **1**: ten assumption bindings are `unchecked` (nine distinct proposition groups, with the curve-model input also explicitly used by the normal-basis claim). The primary sources have been read; the missing record is independent attribution on the current ledger, not source access.

The installed `citation_check attribute` archives to `research/literature/`, outside this mission's authoritative writable paths. No such out-of-scope archive was created, and no supporting attribution was filed under a fabricated second identity. Native independent review and an authorized resolution of that archive-path constraint are needed before claiming the citation-delivery gate is clear. This report does not substitute structural ledger validity for citation approval.
