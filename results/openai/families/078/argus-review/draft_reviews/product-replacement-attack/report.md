# Failed actual-product replacement attack

**Assessment: a justified exclusion of the old uncontrolled replacement
route, not a refutation of the manuscript.** This unit accounts for
`R_DB_UNCONTROLLED_ACTUAL_PRODUCT`; it has no separate old claim id
or formal theorem. The existing arguments and fixtures are reviewed,
not expanded into a new search or repair.

## Contribution classification and attribution rationale

**Classification: `refutes_argus_attack`.** The existing diagonal law
shows why the old unqualified actual-product inference fails, and the
sharp retention fixture shows why omitting `r` would fail. Neither is a
refutation of OpenAI: the manuscript's
`02-entropy.tex:369-409` (`lem:marginal-core`) supplies the controlled
replacement, and `07-rate-transfer.tex:951-967` includes the retention
factor. The erroneous inference/omission belongs to the Argus attack,
and its obstruction to the old Argus analysis; the manuscript is not
credited with either error. The specific attack is rejected without
calling its replacement a new theorem or excluding unrelated
mathematical objections.

## Source, attribution and exact assertion

The old route is in campaign `9000078`'s `MATH_STATE.json`, with goal
`DB_MAIN` and obligation `DB_RETAINED_MARGINAL`. Its immutable retirement
reason is:

> A product comparison to named populations does not automatically give
> a subpower comparison to a retained laws own marginals; the simultaneous
> marginal core, not an unquantified replacement, is necessary.

The corresponding old proof-graph route is
`uncontrolled-actual-product-replacement`, marked `ruled_out`, with the
same mathematical reason. Report section 2, lines 108-171, supplies the
example and the already existing core argument. The report, ledger and
graph match the `2026-11-06T10:20Z` snapshot. The manuscript comparison is
the directional-bootstrap proof at `07-rate-transfer.tex:841-993`,
revision `4eaee87548250b2682affda7d05d947c05554bae`. Attribution is to
the old Argus Engineer's attempted route and its subsequent analysis;
the manuscript is the source being audited, not the author of the
invalid uncontrolled inference.

The rejected step would infer controlled domination by **actual**
marginals merely from `q<=D*mu*nu` for **named** probability populations
after conditioning or restriction. Named references and actual
marginals are different objects. In an asymptotic use, a factor that
depends on a small actual marginal is not automatically subpower.

## Decisive existing arguments

The report's existing two-point diagonal example takes `0<e<1`,
`q(0,0)=e`, `q(1,1)=1-e`, with zero off-diagonal entries and uniform
named references. It satisfies `q<=4*mu*nu`; its actual marginals are
`alpha=beta=(e,1-e)`. At `(0,0)` its actual-product density is
`q(0,0)/(alpha(0)*beta(0))=1/e`, arbitrarily large. Thus there is no
uniform actual-product control from the named comparison alone. This
is the **already recorded** obstruction, not a newly discovered
manuscript counterexample.

The existing simultaneous core gives the missing quantitative floors.
For a probability law dominated by `D*mu*nu`, threshold `1/4` retains
mass `M>=1/2`; its normalized marginals satisfy
`mu<=4*M*alpha`, `nu<=4*M*beta`, hence
`q_core<=16*D*M*alpha*beta<=16*D*alpha*beta`.
The named child and pin comparisons also persist with factor `D/M`.
These distinct inequalities are needed by the star/projection proof.
The old report explicitly says that the manuscript supplies the core.
This review does not insert a new repair or treat the rejected
unqualified route as the actual manuscript proof.

The other relevant old attempted omission was the retention factor.
The preserved six-atom fixture has original parent mass `1/3`,
original conditional bin cap `1/6`, common-event parent retention
`r=2/3` and separation retention `v=1/4`. The final conditional bin
mass is `1`. The correct cap is `(1/6)/(r*v)=1`; omitting `r` gives
only `(1/6)/v=2/3` and is false. But the manuscript's factor
`(r_j*v_j)^(-1)` **contains `r_j`**. The fixture therefore detects
an invalid omission in an attack or reading, not a false assertion
in the source.

## Evidence and safe replay

The exact old certificate records
`false_manuscript_assertions_established=[]`,
`all_scale_counterexample=null`, and the interpretation that the
necessary `r` factor is present. The existing `verify.py` was inspected
for side effects and replayed read-only by the parent. Its unchanged
fixtures include the diagonal example `e=1/16`, the actual-product
core comparisons, and the sharp retention identities.
`../finite-core/replay/existing_verify_output.json` records success:
15 core cases, 128 conditional-cap checks, 192 rate updates and 81
mesh cases. These are finite experiments, not all-scale exclusions
of other attacks.

The separately inspected bounded Jacobian conditioning replay matches
the old typed law exactly, including event mass `5/9` and the changed
actual pin marginal. It is supporting normalization evidence only.
The fresh Lean reproduction in the finite-core unit proves the finite
core/algebra ingredients, not a formal theorem that the manuscript
or every possible attack is correct.

The route itself has **no** independent verdict refuting the manuscript.
Relevant matching prior supports are
`judgement-DB_FINITE_CORE-b195a60f0949`,
`judgement-DB_RETAINED_MARGINAL-35c3badb8353`, and
`judgement-DB_MAIN-ca1db2f4cd9d`; they support the controlled
argument under its stated hypotheses. They must not be relabelled
as manuscript-refutation evidence.

## Scope, unresolved obligations and novelty

The specific uncontrolled inference fails and its old retirement
reason is justified. The tested missing-`r` omission also fails as
an interpretation of the actual source. This does not rule out
unrelated mathematical objections, prove the no-strip branch,
establish the upstream one-label outputs, or settle `BR_MAIN`.

No all-scale counterexample to the manuscript is supplied. The
route's exclusion is a failed-attack contribution, not a new
mathematical theorem or a priority claim. The existing controlled
proof remains conditional on its analytical inputs. Native
acceptance of this unit and the complete review remains pending.
