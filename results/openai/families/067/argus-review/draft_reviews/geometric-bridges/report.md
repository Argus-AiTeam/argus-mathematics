# Geometric bridges to the pseudoindex-five quadratic

**Assessment: the actual-family numerical implication is supported by the
separate prose arguments, conditional on the explicitly named external
theorems.** It is neither a consequence of modular arithmetic alone nor
Lean-kernel closure. No concrete gap was found in the bridges as stated;
their support must not be extended to full classification.

Here `old/` is
`campaigns/9000067/`.
The inspected argument is `old/research/pseudoindex-five-audit/report.md`,
especially "Independent derivation" and "Geometric bridges and their
hypotheses", against the manuscript's Sections 2 and 4 at revision
`4eaee87548250b2682affda7d05d947c05554bae`. Historical source excerpts
and independent judgements were reused with their qualifications, not
promoted to formal proofs.

## Exact claim

Let `X` be a smooth connected complex Fano sixfold with nef `T_X`,
Picard number one and **pseudoindex** five. Choose an irreducible
component of rational curves of globally minimum anticanonical degree
five, with its normalized universal family
`pi:U^9 -> V^8`, `e:U^9 -> X^6`. For a general `x`, set

```
F = e^(-1)(x), E = T_e, h_X = c1(T_X)/5, h = e^*h_X,
c = c1(T_pi), ell = 2h-c,
L = (T_pi|F)^dual,
S = int_F c1(T_F)c1(L)^2, D = int_F c1(L)^3.
```

The marked tangent map makes `L` ample. The claim is `D>0` and
`3S^2-20SD+32D^2=0`, for this actual family. It is not a claim for an
arbitrary numerical vector, a merely generic splitting, or a family
with unspecified positivity/normalization.

## C67_UNIVERSAL v1--v6: fibrations and every member

Kanemitsu's **2017** Proposition 1.6 supplies smooth projective `V`,
the smooth projective-line fibration, and smooth evaluation with connected
fibres of the stated dimensions. Its arbitrary-dimensional setup applies
to `n=6,d=5`. It does **not** state `E|C=O(-1)^3` for every member.

The report supplies the missing separate argument, also present in the
fixed manuscript. For any member `phi:C=P1 -> X`, nefness and
Birkhoff--Grothendieck give a nonnegative splitting of `phi^*T_X`,
so `H^1=0` and `h^0=6+5=11`. The relevant birational map-space
component is smooth. Its principal `PGL2` quotient and compatible
marked family give a map `P1 x H -> U` over evaluation. Differentiating
a constant map-space tangent direction along all of `C` gives a global
section of `T_U|C`; its evaluation is exactly that prescribed element of
`H^0(phi^*T_X)`. The map on global sections is therefore surjective.

The tangent sequence of `pi` is an extension of `O^8` by `O(2)`;
it has `h^0=11`, `h^1=0`. Thus that surjection is an isomorphism.
The evaluation tangent sequence gives `H^0(E|C)=H^1(E|C)=0`.
Every line-bundle summand on `P1` with both groups zero has degree
`-1`. Hence all three summands have degree `-1`, **for each C**.
No immersion assumption is used in this argument.

The graph-only `F067_KANEMITSU_EVERY_MEMBER_SPLITTING` records an
invalid attribution/inference: the cited fibration proposition alone
does not establish the splitting. It is not a refutation of this repaired
argument or of the manuscript. The graph's "Kanemitsu 2016" label must
not be silently identified with the retrieved 2017 proposition; the 2016
high-Picard-number theorem is a different classification input.

## C67_INVOLUTION v1--v3: rational projective-line cohomology

For `pi`, the restrictions of `1,c/2` form a fibre basis, so rational
Leray--Hirsch gives unique `a+cb` with base classes `a,b` and
`pi_*c=2`. Relative GRR for `O_U` gives `pi_*td(T_pi)=1`, whose
weight-one base part is `pi_*c^2/12=0`. Thus `c^2` is pulled back.
Negating `c` defines a ring involution. With `delta=pi^*pi_*`,

```
delta(a+cb)=2b, bar(alpha)=alpha-c delta(alpha),
delta(alpha beta)=delta(alpha) beta+bar(alpha) delta(beta).
```

In particular `ell` descends, `bar(h)=ell-h`, and
`alpha-h delta(alpha)` descends. Difference-quotient notation denotes
these identities; it never inverts a cohomology class. No integral
projective-bundle presentation or integral class `h` is assumed.

## C67_DESCENT v1--v2: an actual degree-one twist

Use the actual bundle
`A=e^*(-K_X) tensor (T_pi^dual)^2`, not a fictional line bundle
whose Chern class is `h`. It has degree `5-4=1` on every `pi`-fibre,
and `c1(A)=5h-2c=h+2ell`. Thus `E tensor A` restricts to `O^3`
on every fibre. Cohomology and base change make
`B=pi_*(E tensor A)` locally free of rank three. Fibrewise evaluation
is an isomorphism, hence so is `pi^*B -> E tensor A`.

The shifted roots of `E` obtained by adding `h` are therefore the roots
of `pi^*B` minus `2ell`. Their elementary symmetric polynomials
`r,s,t` descend globally. A splitting only over a dense open subset
would not prove this; the preceding every-member argument is essential.

## C67_HODGE v1--v6 and C67_GRR v1--v2

For the smooth projective `e` over simply connected `X`, all rational
cohomology local systems are constant. Completeness matters: `U` is
itself a smooth projective compactification. Deligne's global invariant
cycle theorem makes restriction from `H^k(U,Q)` surject onto the
entire fibre cohomology. It is a morphism of pure Hodge structures.
Restrictions of global classes of each type span the corresponding
fibre component and remain flat of that type, so the Hodge filtration
is constant. Relative Hodge--de Rham degeneration identifies
`R^j e_*Omega^p_(U/X)` with its graded pieces. These are holomorphically
trivial.

This does not infer a constant period map from trivial monodromy in an
arbitrary noncomplete analytic family. It does not require `V` simply
connected or `F` Fano/rationally connected.

Relative GRR for `O_U` and `E^dual=Omega^1_(U/X)` now gives

```
e_*td_i(E)=0,
e_*[td(E) ch(E^dual)]_i=0, for i>3.
```

The derived pushforward is its **alternating K-theory sum**; positive
Chern characters vanish because the Hodge bundles are trivial.
Individual higher direct images need not vanish. This supplies genuine
extra relations, not consequences of the tangent-sequence polynomials.

## C67_MATRIX v1: every row group

Tangent-sequence additivity gives
`q_i+x_i=c^i+pi^*(i! ch_i(T_V))`. Applying the product rule gives
the report's `D_i=delta x_i`, in particular `D_1=5`,
`D_2=2r-3ell`. For `i>=7`, `x_i=0` because `dim X=6`.

| Row group | Why its weight-nine integral vanishes |
|---|---|
| `w(m-h Delta m)` | Descends to `V`, whose dimension is 8. |
| `w Delta m` | Also descends, with total weight 9. |
| `wm`, base weight greater than 6 | Its base factor vanishes on `X`. |
| `w Delta m`, same base weights | Integration of that zero class vanishes. |
| `wD_i`, `i>=7` | `delta x_i=0`. |
| `w theta_i` and `w psi_i`, `i>3` | Relative GRR and the projection formula; only the integrals must vanish. |

Consequently the geometric intersection vector satisfies `Av=0`.
The explicit Newton/binomial/Todd polynomials in the report and the
inspected source agree with the standalone reconstruction; the last
row group must not be promoted from an integral relation to a zero-class
claim.

## C67_PRODUCTS v1--v4 and C67_NUMERICAL v1--v2

For general `x`, `F` is smooth, connected and projective, hence irreducible.
Its map to the reduced through-point locus `V_x` is finite: the normalization
of a nonconstant curve has finitely many points above `x`. Kebekus's
versioned theorem says only finitely many curves are singular **at x**
and these are immersed. It does not say all singular curves through
`x` are finite (that larger locus can have dimension one).
As `dim V_x=3`, the finite map is generically one-to-one. Thus normal
`F` is the normalization to which the finite tangent-map theorem applies.

The differential identifies `T_pi|F` with the tautological subline.
Therefore `c1(L)=-c|F=ell|F`. Pullback of `O(1)` along a finite
map is ample, so `D>0`; this is not an embedding or VMRT-normality
assertion.

Fano rational connectedness/simple connectedness is an external theorem.
Kodaira vanishing and the Lefschetz `(1,1)`/divisor comparison give
`H^2(X,Q)=Q h_X` from `rho=1`. For an invariant monomial `G_j`
of weight 3 or 4, its pushforward is consequently a scalar in
`H^0` or `H^2`. With `I=int_X h_X^6>0`, define

```
xi_i = int_X M_i / I,
e_*G_j = D eta_j h_X^(weight(G_j)-3).
```

Then `xi_0=eta_0=1`, `eta_1=S/D`, and each selected integral equals
`D I xi_i eta_j` by the projection formula. The missing three invariant
monomials are simply unselected, not assumed zero. Dividing by the
**one common nonzero** `DI`, and applying the separately assessed rational
lemma, proves the claimed quadratic.

## Sources, versions and external assumptions

The current review ledger records reuse of the historical arguments and
source records before this assessment. The following proposition-level
inputs remain external; the review does not re-prove them.

| Input actually used | Source and checked boundary |
|---|---|
| Smooth minimal-family fibrations | Kanemitsu 2017, DOI `10.4310/MRL.2017.v24.n5.a6`, Definition 1.4 and Proposition 1.6, pp. 1456--57. Arbitrary dimension; no splitting conclusion. |
| Map-space and marked quotients | Brion--Kannan, `arxiv:1910.06197v2`, Sections 2.1--2.2, diagram (2.1), evaluation after (2.4), quotient (2.5). Normalization is harmless on this all-free smooth component. |
| Fixed part/global invariant cycles | Deligne 1971, DOI `10.1007/BF02684692`, Theorem 4.1.1(ii), p. 40, Corollary 4.1.2, p. 42. A smooth complete compactification is required; `U` supplies it. |
| Graded Hodge bundles | Griffiths 1970, DOI `10.1090/S0002-9904-1970-12444-2`, Section 1 p. 231, Section 2(a)--(c), pp. 232--33; proper smooth polarized family, filtration reindexed. |
| GRR | Borel--Serre 1958, Sections 5(d), 7, p. 113; proper morphisms of nonsingular quasi-projective varieties, rational classes. The relative formula is a corollary by Todd multiplicativity and projection formula. |
| Tangent map and singular-at-point locus | Kebekus, `arxiv:math/0004023v2`, Notation-Assumptions 3.1, Theorem 3.3(1), Section 3.2 and Theorem 3.4. Covering family, proper `V_x`, general `x`, positive line bundle; map on the normalization is finite, not necessarily an embedding. |
| Fano topology | Campana--Peternell 1999 survey, Theorems 2.11 and 5.3.2, `https://library.slmath.org/books/Book37/files/campana.pdf`; Fano implies rationally connected implies simply connected. |
| Additional standard background | Birkhoff--Grothendieck and line-bundle cohomology on `P1`; rational Leray--Hirsch; cohomology and base change plus fibrewise evaluation/Nakayama; Kodaira vanishing and Lefschetz `(1,1)`. These are named assumptions, not fully sourced or kernel-discharged here. |

The historical `literature/*.txt`, `literature/sources.json` and
`reviewer-primary-excerpts.txt` were inspected in the source-assessment
read. The present bounded source read also checked the cited primary
statements. For map spaces and tangent maps the checked version is the
stated preprint, not unattained final publisher wording. The old compound
`FANO_BASE_FACTS` judgement was inconclusive; the topology assertions
are source-supported, whereas the separate standard divisor/cohomology
steps remain explicit external inputs. This is not a claim of canonical
project-level citation-queue closure.

## Historical version and review reconciliation

All listed versions retain the same natural mathematical statement.
Universal-family revisions add Kanemitsu, replace an unversioned quotient
citation with v2, and add standard splitting. Hodge revisions replace
prose citations with canonical Deligne/Griffiths citations; they do not
remove theorems from the proof. Products revisions replace an unattained
published citation with the inspected Kebekus v2. Involution/descent/GRR
revisions make standard dependencies explicit. Numerical v2 adds the
compound Fano background. None is a new theorem.

The later old ledger contains independent supporting opinions on these
bridges and the numerical implication, not just an algebra replay.
`reviewer-replay.json` expressly bounds that review to the numerical
implication and excludes classification, novelty, canonical attribution
closure and Lean certification. The earlier report's pending wording is
therefore stale for this bounded historical review, but still does not
accept this campaign's six-unit review.

`C67_SCOPE_LIMITS` v1--v2 is correct as a statement about **the finite
calculation alone**. Its recorded bridge warnings are not evidence that
the later separate geometric arguments failed. `C67_CORE_AUDIT` and
`C67_INDEPENDENT_REVIEW` have only the bounded provenance meaning just
explained. All old graph nodes and their flags remain unmodified; they
cannot turn a reviewer opinion into a Lean theorem, nor can their open
labels negate an inspected proof.

The legitimate contribution is a source-grounded reproduction of the
manuscript's numerical bridge and its algebraic audit. No new geometric
classification or verified novelty is established.
