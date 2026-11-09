# Old-draft assessment: adjoint lifting

**Disposition: supported, within the explicit hypotheses below.**
This is an Engineer's bounded mathematical assessment, not native independent
Reviewer acceptance, a formal certificate of geometry, or family completion.
No novelty is claimed. No decisive unfilled mathematical step was found in
Theorem A; its dependency declarations and proof scope must not be confused.

## Evidence, versions, and attribution

All old-relative paths below are relative to the read-only workspace
`campaigns/9000037`.
Write `A = research/adjoint_jet_lifting` and
`P = research/openai_manuscript/The-ordinary-double-point-gap-in-every-dimension-September-24-2026/build`.
The assessed proof is `A/report.md:1–427`, especially Theorem A at 141–416
and its manuscript specialization at 417–427. Theorem B starts at 428 and
is outside this unit. Historical bindings are in `research/MATH_STATE.json`.

| Old claim | Natural-statement change | Recorded external assumptions |
|---|---|---|
| `C_AJL_GENERAL@1` | Adjoint-only assertion: compatible shifted interior indices lift to `K_B+kL`. | None |
| `@2` | Identical natural statement; not a new theorem. | HOWALD |
| `@3` | Identical natural statement. | HOWALD, PRINCIPALIZATION |
| `@4` | Identical natural statement. | HOWALD, PRINCIPALIZATION, KV_WEIL |
| `@5` | Arbitrary `M`, rational `t>0`, independent nef remainder; explicitly integral `B`, dimension at least two. | Same three, reordered |
| `C_AJL_LIFT@1` | Manuscript's `q+c ∈ Int K ⇒ q ∈ Gamma`, for `q ∈ Lambda`. | None directly attached |

All six records have empty `formal_statement`; all have empty
`retired_assumptions`. Versions 1–4 share natural-statement content hash
`be939e1c1accd8c7ff2ef3a4273048f70ae09915005902b14a15821bf2b770d1`;
version 5 has `f5628c1d1ded536c57a9d219d092b4a0a321bf2c5b570a0026401674deeb3a57`.
The lifting specialization has
`6b8208ab1b1ac1481c4bb0833e06dd209fbbb7e2be122e7efa115c80a7138d73`.
The old graph expressly makes LIFT depend on GENERAL. Status labels add no proof.

Versions 1–4 are abbreviated prose, interpreted here in the explicit shared
report scope, not as statements with invented additional quantifiers.
They follow from version 5 by `M=K_B+kL`, `t=k>0` integral, nef remainder zero.
Already version 1 dispensed with subcanonicity compared with the manuscript;
version 5's further strengthening is the independent nef twist and rational `t`.
The manuscript itself states the subcanonical lemma in
`P/sections/05-adjoint-semigroup.tex:108–120`; its opening explicitly disclaims
canonical interiority. This is a review of that reproduction/specialization
and the proposed strengthening, not an attribution of a new manuscript result.

## Exact strongest statement and scope

Let `B` be an integral smooth effective proper algebraic complex DM orbifold,
of dimension `N>=2`, with trivial generic stabilizer and projective coarse space.
Let `L` be an ample orbifold line bundle; rational positivity is understood
after descent to the coarse space. At a selected residual gerbe the stabilizer
is `mu_m`, the fiber character of `L` is faithful and numbered 1.
Fix algebraic equivariant étale coordinates `z_i`, of characters `b_i`, and an
algebraic equivariant frame of `L`. These are not arbitrary formal coordinates.

Order monomials by increasing total degree, then increasing lexicographic
exponent vector. Let `Gamma_L` record the original integral degree `j` and
the initial exponent of nonzero sections of `jL`; put
`K(L)=closure(cone(Gamma_L))` in `R × R^N`. Interior means ordinary interior.
For a line bundle `M`, let `d` be its fiber character at the chosen gerbe.
If `t>0` is rational and

```
M-K_B-tL is nef,
alpha ∈ Z_{\ge 0}^N,       sum b_i alpha_i ≡ d (mod m),
(t,alpha+1) ∈ Int K(L),
```

then some global section of `M` has initial exponent exactly `alpha`.
A change of equivariant algebraic frame by a unit preserves this exponent.
This statement does not require subcanonicity, Fano positivity, a volume bound,
Reeb minimization, a maximal stabilizer, or semigroup finite generation.
Those are not thereby removed from the manuscript's other arguments.

For `-K_B=rL`, set `M=jL`, `t=j+r`, `q=(j,alpha)`, `c=(r,1,...,1)`.
The congruence is exactly `q ∈ Lambda`. Interiority in the exponent orthant
gives `alpha_i+1>0`, hence integral `alpha_i>=0`; positivity of the original
degree on `K\{0}` gives `j+r>0`. The nef remainder is zero.
Thus `q+c ∈ Int K` supplies precisely the premise of Theorem A, with no
assumption `c ∈ Int K`. One must not use the scaled degree `Nj/r` here.
The source definitions and algebraic-coordinate condition were checked in
`P/sections/04-jet-interiority.tex:25–122`. Its other propositions and the
volume-gap hypotheses are dependency boundaries, not independently established here.

## Decisive argument assessment

### A1: finite separation, not a SAGBI argument (`A/report.md:173–212`)

Openness gives rational `0<t0<t` with `(t0,alpha+1)` interior.
A small surrounding simplex can be approximated inside `cone(Gamma_L)`;
the finitely many actual section indices used still surround the point.
This uses closure and ordinary interior, not generation of the entire semigroup.
For a degree cutoff `D` exceeding the selected initials and `alpha`, rational
weights near a common positive value realize all required finite comparisons.
They can satisfy `(D+1)min(u_i)>D max(u_i)`, excluding every higher-degree tail.
Successive small perturbations order equal-degree exponents lexicographically.
Clearing denominators and dividing the gcd preserves these strict comparisons.

With `p=u.alpha`, `U=u.(alpha+1)`, slicing the finite cone by degree `t0`
and weight `U` leaves a neighborhood in the whole `(N-1)`-dimensional plane.
Rational surrounding points have rational nonnegative generator coefficients.
After a common denominator `a`, products of actual sections give sections of
`at0 L` with single weight initials `z^{beta_l}`, `u.beta_l=aU`.
Their normalized convex hull surrounds `alpha+1` in that plane.
Products preserve single initials even beyond the original cutoff.
No unsupported assertion about all Taylor initials being weight initials occurs.

### A2–A3: global model, inertia, and the monomial on E (213–301)

Each weight ideal contains a power of the maximal ideal; its quotient is a
finite equivariant jet at the gerbe. Descent, using the whole orbit on a larger
chart, and extension by the unit ideal globalize the multiplicative filtration.
The algebraic-coordinate hypothesis is essential to this construction.
Its Rees algebra is generated locally by `z_i q^ell`, `1<=ell<=u_i`.
The opens `z_i q^{u_i} != 0` cover by the displayed power identity in A2.
There `T=(z_i q^{u_i-1})/(z_i q^{u_i})` is regular, including `u_i=1`.
These identify the stack Proj with the stated smooth weighted-blowup model.
Finite generation gives a projective coarse modification, not a smooth coarse model.

The divisor `E=(T=0)` is `[P(u)/mu_m]`; its possibly ineffective generic
inertia cannot be discarded. The stack canonical identity is
`K_Z+E=pi^*K_B+(sum u_i)E`.
For `P0=pi^*M-pE` and `H=pi^*(at0 L)-aUE`, cancellation gives
`P0-(K_Z+E)-H/a=pi^*(M-K_B-t0 L)`.
The right side is nef and big because it includes `(t-t0)pi^*L`.

On `x_k=1`, retain the finite group
`H_k={(rho,zeta):rho^{u_k}zeta^{b_k}=1}`, not a presumed direct product.
The character of `P0|E` is `rho^p zeta^d`; the remaining monomial has exactly
this character, since its missing factor is trivial on `H_k`.
Thus `x^alpha` really is a section on E, with no illicit fractional powers.
Projection deleting coordinate k is an affine isomorphism on `u.x=U`.
Consequently `alpha_rem+1` is in the ordinary interior of the projected
normalized convex hull, hence of the scaled Newton polyhedron of `b|E`.
Howald applies on each smooth finite uniformizer; invariant ideal membership
descends with the just-checked line character. It is not applied to a singular
coarse exceptional divisor, nor is vanishing applied to ineffective E.

### A4: coarse rounding and Weil-divisor vanishing (302–344)

The models to which this step is applied have projective coarse spaces.
For divisorial inertia `e`, write the stack coefficient of a Cartier divisor
as `d0`, and the fractional coefficient of `D_c` as `k/e`, `0<=k<e`.
If the stack boundary coefficient is `theta<1`, then
`Delta=R+Theta_c-{D_c}` has coefficient `(e-1+theta-k)/e` in `[0,1)`.
Coefficient bounds alone would not prove klt on a singular coarse space:
the decisive additional argument is that its log pullback to every smooth
finite quotient chart is bounded above by the SNC subunit boundary `Theta`.
Subtracting an effective pullback only increases log discrepancies;
the finite-map discrepancy formula then gives klt downstairs.

Normal extension across codimension two makes `q_*O(D)` reflexive and
identifies it with `O_X(floor D_c)` by its codimension-one orders.
Exactness of finite-group invariants over C removes higher coarse pushforwards;
no flatness assertion is needed. Quotient singularities are locally Q-factorial,
so `floor D_c` is an integral Q-Cartier Weil divisor, not necessarily Cartier.
The equality
`floor D_c-(K_X+Delta)=D_c-(K_X+R+Theta_c)`
preserves the descended nef-and-big class. Fujino 3.2.4 therefore has precisely
the needed hypotheses; the additional lc-center condition is vacuous for klt.

### A5: actual restriction surjection and regular pushdown (345–416)

Principalize `b O_Z(-E)` with boundary E, not b alone.
The total divisor is `G+sigma^*E`, so its SNC support contains both `E'`
and `Supp G`, together with the nontrivial exceptional divisors.
Since b is generically a unit on E, G does not contain E'.
Smooth NC centers restrict to smooth blowups of E; thus `E'->E` resolves
the restricted ideal, whose total transform is exactly `O(-G|E')`.
Smooth functoriality glues the centers over the étale groupoid, not merely
the final spaces. Suitable powers of relatively ample bundles descend,
preserving projectivity of the coarse resolution.

Put `A0=K_Y+sigma^*(P0-K_Z-E)-floor(G/a)`. Direct cancellation gives
`A0-(K_Y+{G/a})=sigma^*pi^*(M-K_B-t0 L)+(sigma^*H-G)/a`.
The first summand is nef and big; the second is nef, being generated by
the chosen sections. Vanishing gives `H^1(Y,A0)=0`, hence an actual global
surjection to `(A0+E')|E'`, not just local multiplier-ideal membership.
Adjunction identifies that target with
`tau^*(P0|E)+K_{E'}-tau^*K_E-floor((G|E')/a)`.
Round-down commutes here: SNC transversality gives multiplicity-one restrictions,
and two components of G cannot restrict to the same prime of E'.
Otherwise three boundary components would meet in codimension two.
Howald membership supplies the target section by the log-resolution definition.

Finally `A0+E'=sigma^*P0+F-floor(G/a)`, where
`F=K_Y-sigma^*K_Z-sigma^*E+E'` is effective and exceptional.
A smooth codimension-h blowup contributes `h-1`, or `h-2` if its center
lies in the strict boundary; codimension-one blowups are identities.
At nonexceptional primes there can be no pole. Normal extension therefore
pushes the lift to a regular section of P0. Its restriction equals the
specified monomial on dense E and hence everywhere on integral E.
Since `p>=0`, this pushes to M, with no weight below p and weight-p part
exactly `z^alpha`. Every preceding Taylor monomial has smaller weight by A1.
This proves the claimed initial, not merely nonvanishing or an asymptotic bound.

Two presentation qualifications are harmless in this application.
A4's standalone wording should retain projective coarse space.
Also Kollár 35(3) alone gives an isomorphism off the cosupport of the
**product**, not off the restricted ideal's cosupport on E. The proof only
needs a log resolution and an isomorphism at generic E; nontrivial smooth
blowups cannot modify its generic Cartier point. No stronger restriction
functoriality or simultaneous-resolution theorem is required.

## Primary-source readings and citation boundary

* **HOWALD — supports.** Primary HTML `https://arxiv.org/html/math/0003232v1`,
  Definition 1 and Main Theorem, was read, not only the saved summary.
  Necessary excerpt: “Let r>0 be a rational number”; the theorem contains
  “exactly” the monomials with `lambda+1 ∈ Int(rP) ∩ L`.
  The ambient variety is smooth; the theorem specializes to monomial ideals
  on affine space. It proves local multiplier-ideal membership, not lifting.
* **KV_WEIL — supports.** Osamu Fujino, *Cone and contraction theorem for
  projective morphisms between complex analytic spaces*, author's version 0.00,
  `https://www.math.kyoto-u.ac.jp/~fujino/cone-and-contraction.pdf`.
  `A/fujino.txt:1484–1491`, Theorem 3.2.4,
  printed p.31 / PDF p.41, was checked against the supplied PDF using
  `pdftotext -layout` to stdout. Necessary excerpt: “Let L be a Q-Cartier
  integral Weil divisor on X.” The theorem requires projective morphism,
  lc pair, nef and big difference, and bigness on every lc center.
  The title-page text identifies version 0.00, 2023/10/9 (`:80`).
  Taking the target to be a point gives the required klt cohomology vanishing.
* **PRINCIPALIZATION — supports with the explained descent argument.**
  János Kollár, *Resolution of Singularities—Seattle Lecture*,
  `https://arxiv.org/abs/math/0508332v3`.
  `A/kollar.txt:1221–1243`, Theorem 35, printed/PDF pp.24–25, was checked
  against the PDF. Necessary excerpts: “all centers of blow-ups are smooth”
  and “BP commutes with smooth morphisms (34.1)”.
  Its hypotheses are a smooth finite-type characteristic-zero scheme,
  an ideal nonzero on each component, and an SNC boundary.
  Definition 25 (`:898–918`) controls the evolving boundary;
  34.1 (`:1168–1183`) controls smooth-surjective descent of the sequence.
  Proposition 9.1 (`:373–398`, p.8) states equivariance for resolution;
  the same smooth-functoriality argument applies to Theorem 35's ideal data.
  Theorem 36 (`:1245–1258`, p.25) is not an extra simultaneous-resolution input.
  The saved header says arXiv v3, 12 February 2007, but also prints
  “November 26, 2024”; this bibliographic peculiarity is not silently erased.

These began as worker readings, not independent Reviewer citation attributions.
The original worker could not archive under `research/literature/` and ran no
attribution command. The current provenance-repair mission explicitly owns
that archive and the active ledger. The current Engineer read the supplied
passages and persisted them with the supported `citation_check attribute`
operation under `engineer:repair-active-review-provenance`, not a Reviewer
identity. HOWALD and PRINCIPALIZATION now have `confirmed` source assessments:

* HOWALD: `research/literature/610edcfcc82266a99db680e761c5866d.json`,
  containing the unchanged supplied excerpt.
* PRINCIPALIZATION: `research/literature/dabdaf604132aaa3f850408dab6ac68d.json`,
  containing an explicitly labelled ASCII transcription of the already reviewed
  passages, including the hypotheses and qualifications above.

Both attribution operations succeeded without refusals. Existing assumptions,
their source identifiers and locators, and their filer
`engineer:old-draft-scope` are unchanged. KV_WEIL retains its disclosed
prose-only `uncited` status. Persistence is not a new independent Reviewer
verdict, a new literature search, or a proof of global lifting.

## Verification, supported scope, and remaining obligations

The real toolchain was the prescribed Argus virtualenv Python, JSON/hash
inspection, local text/PDF reading, and primary Howald HTML retrieval.
No old command or source script was executed; no Lean or Jacobian operation
was needed. `Main.lean`/`statement_fidelity.md` concern conditional integer
facet algebra, explicitly not this geometry. The archived finite certificates
cannot certify GENERAL or LIFT; Theorem B, saturation, and the quadric remain
separate units. No manuscript-wide or novelty conclusion follows.

At the original bounded assessment, both official checks used explicit root
`campaigns/9200037`:
`math_state check` returned 0 (`ok: true`); `proof_graph_check check`
returned 2 because root `research/PROOF_GRAPH.json` is absent.
After the provenance correction, the official math-state and citation-status
checks at that same root both exit 0 with no issues or blocking citations.
The proof-graph command still exits 2 for absence. A graph is expressly
nonapplicable to the live exploratory old-draft review and was not created;
that exit is not represented as a successful graph check.

The checked proof supports version 5 and, by the substitutions above, the
explicitly scoped versions 1–4 and LIFT version 1. No substantive mathematical
repair is left by this reading; standard tame-stack/descent facts used above
are background geometry, not results of the cited multiplier formula or Lean.
Source-attribution persistence is complete. Native independent review of the
current provenance correction remains required; no new mathematical conclusion
or Reviewer approval is asserted by this amendment.
The old report SHA-256 is `17d1a9c1ce14603a2c19222ca5f8c703309b90a32fad24691c725e971ce29453`;
the old ledger SHA-256 is `ec4f81770910f55dbc1eeb8922a806cfe477890c35a2ed84b3bab03fcad86376`.
Full source/version fingerprints and scope exclusions are in `verdict.json`.
