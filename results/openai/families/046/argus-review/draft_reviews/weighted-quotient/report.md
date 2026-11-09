# Weighted quotient: supported within its accepted scope

**Assessment:** the old Argus argument supports the infinite quotient and based
monodromy invariance for the actual family, for every dyadic `n>=4`. Reuse the
native independent acceptance of mission `84ee177ee388`, round 1. This is not
acceptance of a surface theorem, a fourfold theorem, or novelty.

Paths beginning `research/surface_weighted_audit/` below refer to the read-only
old workspace `campaigns/9000046`.
Current replay paths begin `research/draft_reviews/weighted-quotient/replay/`.

## Statement, hypotheses, version and attribution

The original is OpenAI, *A surface counterexample to Shafarevich holomorphic
convexity*, September 23, 2026, source revision
`4eaee87548250b2682affda7d05d947c05554bae`. Relevant declarations are
`lem:family`, `prop:based-monodromy`, `prop:monodromy-raising`,
`lem:pinched-sphere`, `lem:finite-geometric-monodromy` in
`build/sections/03-family.tex`, the involution construction in section 04, and
`lem:deep-invariance`, `lem:distinguished-meridians`,
`prop:infinite-quotient` in section 05. The manuscript uses multiplication by
four. The Argus report reconstructs that argument and proposes its dyadic
extension; it is attributed in the old ledger to `engineer:gpt-6.1-sol`.

All seven surface TeX files enumerated in `MANUSCRIPTS.json` match its declared
revision and their old `research/openai_manuscript` copies byte for byte. The
three principal weighted artifacts also match their declared preserved-snapshot
digests. The reference manuscript is not another Argus result.

Let `E=C/(Z+Z*omega)`, with `omega^2+omega+1=0`, and let `q:E->P1` quotient
by sign. For `n=2^r`, `r>=2`, define `f_n` by `q[n]=f_n q`; mark the
`3n^2` inverse images of the three targets
`s, bar(omega)s, bar(omega)^2 s`. The parameter space is the sphere minus
`q(E[2]) union q(ker(1-omega))`, a five-point set; its based group is free of
rank four. This is a marked genus-zero family, not a genus-two fiber family.
The six-punctured torus auxiliary group is free of rank seven, with weights
`1,1,1,1,1,2,2` on `x,y,a0,a1,a2,c0,c1`. Work is in characteristic two
and in the indicated free pro-2 completions.

The latest old claim `S_DYADIC`, version 2, asserts that at `t=49/200`, any
`J>=2n` satisfying

```
(1+6n^2) t (4t)^J / (1-4t) < 1/100
```

imposes the entire closed `D_J` parameter-subgroup action, not just finitely
many sampled equalities. Together with the full involution relations and a
subsequently chosen finite boundary-power family of cost `<1/100`, this leaves
an infinite pro-2 quotient. Each punctured fiber has dense image. There is a
finite parameter cover with a selected ramification index **exactly two**;
every compactification meridian has finite image, and every distinguished
vertical meridian has trivial image. No assertion of discrete surjectivity
onto an infinite profinite group is made.

For `n=4`, the fiber has 48 markings, and killing its 24 pair boundaries gives
a free rank-24 group. Before imposing the involution the auxiliary collapsed
torus group has rank 48. These are different groups and are not interchangeable.

## Decisive argument and claim dispositions

The following is a crosswalk of all 13 weighted-unit ledger claims. Versions
refer to the old ledger, not newly invented result versions.

| Claim | Exact supported assertion and decisive argument | Disposition |
|---|---|---|
| `S_ACTUAL` v1 | The actual corrected based monodromies preserve five explicit mod-two characters; changes to the weight-two pair boundaries start in degree at least three. The geometric double covers supply these characters, rather than an assumed identity on abelianization. | Supported by the accepted universal argument; finite identities are supporting checks. |
| `S_PINCH` v1 | The actual based covering group surjects onto the sphere group. Equivariant core collapse gives the pinching square and transfers equalizers; it does not assume invariance of the pinching kernel. | Supported; the based square is indispensable. |
| `S_TRIANGULAR` v1 | Iterated translation differences on a regular `(Z/n)^2` orbit form a discrete free basis, hence a free pro-2 basis. The substitution is triangular in the original free generators. | Supported universal basis proof, not just the `n=4` example. |
| `S_SHIFT` v1 | Translations and sign raise completed weighted degree by one in the difference basis, including cyclic endpoints. | Supported; endpoint free-word identities are checked. |
| `S_INVOLUTION` v1 | An acyclic leading differential selects half the generators' number of relations and imposes the full pro-2 involution, not merely its Frattini action. | Supported by the nonlinear generation proof; matrix rank alone is insufficient. |
| `S_TRANSFER` v1 | Operator substitution in the regular translation action transfers the parameter Magnus lower bound to the collapsed `L` component. | Supported by the universal substitution proof, with finite formal-algebra support. |
| `S_DEEP` v1 | At most `4^N` representatives in layer `N`, with all covering-basis equalities, impose invariance on the whole closed deep subgroup. Closure and continuity, not a finite truncation, complete the argument. | Supported; no exhaustion claim about infinite words is inferred from a computation. |
| `S_FINITE_ACTION` v1 | Actual joint marking/sign monodromy is `(Z/n)^2` semidirect inversion `C2`, of order `2n^2`. Its mod-two augmentation ideal has exact nilpotence index `2n`; consequently `D_(2n)` kills that finite action. | Supported dyadic statement; the actual displacement data matter. |
| `S_BOUNDARY` v2 | The selected base cover has index-two ramification; distinguished vertical meridians are killed. Other finitely many meridians can be made torsion after compactification within the remaining budget. | Supported; includes the external Riemann existence input. |
| `S_GS` v2 | A locally finite countable pro-2 presentation with convergent negative weighted Golod-Shafarevich expression is infinite. The report's countable-relator argument is needed to apply the cited weighted-deficiency result. | Supported with the explicitly cited external theorem, not kernel-verified here. |
| `S_DYADIC` v2 | The preceding obligations establish the stated quotient for every `n=2^r`, `r>=2`, with the displayed `J` condition. | Accepted existing Argus theorem; dyadic strengthening has no verified novelty claim. |
| `S_QUOTIENT` v1 | The actual quotient is infinite; every punctured fiber image is dense; all boundary images are finite; distinguished vertical images are trivial. | Accepted input to the separate geometric unit. |
| `S_LITERATURE` v3 | The quoted linear Shafarevich and scope-qualified Eyssidieux-Funar statements do not by themselves decide this marked-family quotient. | Supported source-scope comparison, not an infinitude proof or a novelty certificate. |

The exact margin is transparent. The report obtains

```
G_n(t) = 3t (1+t^2+...+t^(n-2)) (1+t+...+t^(n-1)) >= G_4(t).
G_4(49/200) = 65806513251003 / 64000000000000.
1-G_4(49/200)+2/100 = -526513251003 / 64000000000000 < 0.
```

The least certified depth at `n=4` is `J=579`; the finite-action threshold is
8, not 579. These numbers serve different obligations.

Section 8, lines 755-832 of the old report, supplies **all** geometric input
used downstream. It constructs `M=<gamma_*^2> Gamma_J`, proves
`<gamma_*> intersect M=<gamma_*^2>`, splits the markings over the finite
parameter cover, and defines `rho_0` from the actual based semidirect product.
The local collision `w^2=u^2` yields `3n^2/2` two-marked tails after one
blowup per pair. A tail meridian is a section circuit times a killed pair
boundary, up to conjugacy and orientation; thus all distinguished vertical
meridians are killed. After counting the remaining boundary components, their
images are lifted to the compact pro-2 presentation group and sufficiently
large powers are imposed. Choosing `2^e>=bit_length(b)+7` for the finite
number `b` of remaining meridians meets the stated budget. This order of
choices avoids a circular bound on the cover's eventual boundary complexity.

The original section 05 explicitly has the same index-two cover, 48 markings,
24 tails and distinguished-meridian calculation. The dependent Argus report
therefore uses the accepted actual input, not a surrogate with similar
finite monodromy.

## Sources and prior independent review

| Assumption or comparison | Exact source and scope | Historical independent reader |
|---|---|---|
| `EJ_PWD` | Ershov-Jaikin-Zapirain, `arxiv:1007.1489v3`, section 1.2, weighted deficiency definition and infinitude paragraph: positive weighted deficiency implies infinitude. | `reviewer:84ee177ee388`; literature `9c7721888b3c73083d92232a2ac5cfcd.json`. |
| `SGA1_RET` | SGA 1, `arxiv:math/0206203v2`, Expose XII, Theorem 5.1: finite etale algebraic/analytic covers are equivalent for a locally finite type complex scheme; properness is not required. | Same reader; literature `d8c13d38de66a01768cbc28cc5f69e49.json`; shared with geometry. |
| `LINEAR_SHAFAREVICH` | `doi:10.4007/annals.2012.176.3.4`, publisher abstract: universal cover of a complex projective manifold with a **linear** fundamental group is holomorphically convex. No faithful complex linear representation is established here. | Same reader; literature `7e5731de35590f214c7b557aee181760.json`. |
| `EF_SCOPE` | Eyssidieux-Funar, `arxiv:2112.06726v1`, Theorem 1.2 and the preceding definition of `S(N)`: a specified semistable closed genus-`g>=2` family with uniform ramification, with the stated exceptional values of `N`; the stable case gives Steinness. No identification of this construction with their `S(N)` is supplied. | Same reader; literature `c61b30e287561d9000c4fe97476a73ae.json`. |

The retained primary excerpts are the four short files in the weighted
`sources/` directory and the complete `sga1.txt`. They are source evidence,
not additional Argus contributions. The last two sources are comparisons,
not premises of the weighted quotient proof.

The native receipt is
`$WORKSPACE/.argus-campaign-9000046/projects/87e68093bad5/handoffs/84ee177ee388/round-0001.json`.
It was produced by role `reviewer`, with `review.status="done"`, and says:

> The reviewed universal argument establishes the actual-family infinite
> quotient and based monodromy invariance. Certificate replay passes, altered
> witnesses are rejected, and all four primary-source citations are
> independently checked. This closes the bounded mission, not either
> manuscript's main theorem.

The old ledger binds its supporting judgments to the latest claims above.
There are no older-version bindings among its active routes. Reuse is an
explicit external input in the current ledger; this Engineer has not
impersonated that reader or issued current independent acceptance.

## Replay and certification boundary

The script and five JSON inputs were copied unchanged into current-campaign
scratch. No old `--write` operation was run.

```
$WORKSPACE/argus-latest/.venv/bin/python \
  research/draft_reviews/weighted-quotient/replay/verify.py
```

The single current-host replay exited zero in 0.467 seconds under Python
3.13.5. It checked exact nonlinear algebra, all 12 sign displacements, the
`D_8` finite-action kernel and `J=579`; seven internally altered certificates
were rejected. Exact command, cwd, stdout, stderr and timeout status are in
`replay/replay.json`. The script's historical "review pending" output is not a
new status verdict; its printed text was deliberately not altered.

The old Jacobian contract, exact GF(2) matrix payload, typed output and status
are preserved. They describe `prime_field.matrix.rank.compute`, a 16-by-16
binary matrix of rank 16, with exit zero and no timeout. This is one finite
rank subclaim, not four results and not a nonlinear or geometric proof.
There is no Lean source for this unit. Neither the local Python checker nor
that matrix operation proves infinitude or all-n invariance by itself.

## Failed routes, duplicates and remaining limits

`R_SCALAR_ONLY` fails because a negative scalar expression alone supplies no
actual relator-degree or based-action proof. `R_FRATTINI_ONLY` fails because
Frattini rank alone supplies no nonlinear filtration transfer or invariance.
For `n=2`, the **unchanged counted method** has
`G_2(t)=3t(1+t)<15/16` for `t<1/4`; it cannot make its presentation negative.
`R_DYADIC_TWO_UNCHANGED_WEIGHTS` is a method exclusion, not a finite quotient
proof, a refutation of infinitude at `n=2`, or permission to reopen that route.

The report, certificate, typed records, old ledger versions, graph references,
snapshot copies and current replay copies all support one argument. The
geometric report's reuse of the quotient is not a second quotient proof.
The retained versions `[1,2]` of `S_DYADIC`, `S_GS`, `S_BOUNDARY`, and
`[1,2,3]` of `S_LITERATURE` are reconciled as revisions, not additional units.

This review adds no theorem beyond the strongest relevant accepted result.
It supplies the source/dependency identity check, explicit certificate scope
and family coverage needed for the old-work review. The `n=4` argument is a
reconstruction of the original; the all-dyadic formulation and auxiliary basis
and finite-action refinements are proposed strengthenings with **unverified
novelty**. Surface geometry is assessed separately; the fourfold obligations
are not discharged here. Current whole-review acceptance belongs to the native
Host-invoked Reviewer.
