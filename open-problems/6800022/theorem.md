# Complete obstruction for the normalized reciprocal-reflection locus

A global embeddedness obstruction for a specified reflection/spin
component of genus-one four-ended minimal-surface data. The proof is
in prose, with rerunnable exact algebra; it is not a formalization
or an embedded-surface construction.

## Setup and theorem

Fix
\[
 r>1,\qquad L=\log r,\qquad \rho=\sqrt r,\qquad
 s=\sigma\rho,\quad \sigma\in\{+1,-1\},\qquad
 E=\mathbb C^\times/r^{\mathbb Z}.
\]
The reciprocal involution is \(I[z]=[1/\bar z]\).
In the normalized Kato--Muroya representation the kernel is
\[
 h(z,q)=\sum_{\ell\in\mathbb Z}\frac{s^\ell}{z-qr^\ell}.
\]
Write
\[
 P(z)=\sum_{j=1}^4c_jh(z,q_j),\qquad
 Q(z)=\sum_{j=1}^4b_jh(z,q_j),\qquad
 g=P/Q,\quad \eta=-Q^2dz.
\]
The coefficients are homogeneous, so both \(g=0\) and
\(g=\infty\) remain allowed as limiting end-normal values.
The additive spinors \(e^{u/2}P(e^u)\) and \(e^{u/2}Q(e^u)\)
have multipliers \((-1,\sigma)\) along the ordered generators
\((2\pi i,L)\). This specifies the **normalized nonzero-spin**
scope; the sign of \(s\) is retained, not discarded by relabeling
a spin class while leaving the geometric data unchanged.

Let \(N_1\) and \(N_2\) count punctures on the two fixed ovals
\(|z|=1\) and \(|z|=\rho\), respectively, and let \(N_3\)
count two-point nonfixed orbits of \(I\). Four invariant punctures
therefore satisfy \(N_1+N_2+2N_3=4\).

Admissibility means four distinct catenoidal punctures with nonzero
end weights, no common spinor zero away from the punctures, a
degree-four Gauss map, and vanishing real periods of the full
Weierstrass null one-form on every closed curve. The associated
complete finite-total-curvature immersion has individually embedded
ends. Reciprocal-reflection data satisfy the source reflection
equations, so \(I\) induces an ambient plane reflection. **One
unoriented limiting-normal axis** means that every end normal lies
in the same antipodal pair; a two-plus-two split is a consequence
of a putative global embedding, not an extra hypothesis.

**Theorem.** No admissible datum in this normalized nonzero-spin
reciprocal-reflection one-axis locus is globally embedded, for any
\(r>1\), either \(\sigma\), or any of the nine distributions.

Here global embedding means an injective immersion and a
homeomorphism onto its image. The conclusion does not deny
period-closing immersions with individually embedded ends. It is
not the unrestricted genus-one end-count conjecture and constructs
no counterexample to the original witness target.

## Proof

If \(N_1+N_2>0\), apply the accepted
[fixed-puncture obstruction](../kato-muroya-nonzero-reciprocal-fixed/torsion_obstruction.md)
and its
[local and full-period reduction](../kato-muroya-nonzero-reciprocal-fixed/reduction.md).
End ordering and the local equations reduce a putative embedding
to \((2,2,0)\). The complete periods exclude the positive signed
half-period and place the negative branch on the reviewed
four-torsion period circle, where the global continuation
obstruction applies. These are restrictions on a putative
embedding, not an immersion-level classification.
Its independent Reviewer done receipt is
`/home/argustest/zimo/.argus-campaign-6800022-run2/projects/0f2d784a6dfc/handoffs/85c325059410/round-0002.json`.
The receipt covers asymmetric coefficients, planar intermediate
ends, removable-end escape, and repeated nonzero growths. This
submission reuses that result without changing or reopening its
proof.

If \(N_1+N_2=0\), then \(N_3=2\). The end-ordering lemma excludes
an in-plane axis. In the perpendicular-axis case, the homogeneous
local equations force an auxiliary vertical-plane reflection.
For the positive signed half-period, its compact unpunctured oval
has a periodic tangent square root, incompatible with a planar
Jordan curve. For the negative sign, the exact cycle exchange
preserves the complete spin and null-form data and transports it
to the reviewed excluded conjugation locus (also into an all-fixed
reciprocal locus under the auxiliary reflection). The complete
proof, including both periods and logarithmic terms, is the
[no-fixed-puncture obstruction](../kato-muroya-nonzero-reciprocal-nofixed/obstruction.md),
Sections 1-6.

These are all cases:

| \(N_3\) | \((N_1,N_2,N_3)\) | Obstruction |
|---|---|---|
| 0 | \((4,0,0),(3,1,0),(2,2,0),(1,3,0),(0,4,0)\) | Accepted fixed-puncture theorem |
| 1 | \((2,0,1),(1,1,1),(0,2,1)\) | Accepted fixed-puncture theorem |
| 2 | \((0,0,2)\) | New auxiliary-oval obstruction / exact negative-spin transport |

The signed branches are covered as follows:

| Stratum | \(s=+\rho\) | \(s=-\rho\) |
|---|---|---|
| \(N_1+N_2>0\) | End ordering/local reduction, then complete-period obstruction | End ordering/local reduction, then four-torsion continuation obstruction |
| \((N_1,N_2,N_3)=(0,0,2)\) | Forced auxiliary reflection and compact-oval tangent parity | Exact full-data cycle exchange into an accepted excluded locus |

No limiting argument changes a boundary into an admissible member.
Collisions, zero weights, and common spinor zeros are excluded by
the theorem's original conditions. Equal nonzero end growths are
included in both parts. This proves the asserted full-locus
obstruction using the stated previously reviewed mathematical
lemmas, with no additional unproved geometric conjecture.

The transitive CCCC premise here is the **explicit algebraic model**
in [source_lemmas.md](source_lemmas.md), (E1)-(E3). The unchanged anchor, period,
spin, and meridian certificates evaluate exactly those expressions.
They do not require the unresolved claim that these expressions
transcribe Wohlgemuth's primary displayed data. `source_lemmas.md`
proves the precise regularity/topology replacement and identifies
the three already independently inspected reciprocal source premises.

## Improvement over the strongest accepted result

The accepted theorem handled exactly the eight distributions with
a fixed puncture. It did not cover \((0,0,2)\), nor authorize a
spin-blind substitution of reciprocal reflection for conjugation.
The new argument supplies that ninth distribution, separates the
two signed branches, proves the additional reflection rather than
assuming it, and identifies the transported null one-form and both
periods exactly. This is the mathematical increment; no larger
end-count theorem is inferred.

## Comparison with prior results

[literature/comparison.md](literature/comparison.md) compares the actual hypotheses of
Kato--Muroya 2012 Theorem 7.3 and Kato--Muroya 2015 Theorem 7.1,
Corollary 7.2, and Lemma 6.4, using a separate primary-source reader.
The named theorems do not directly subsume this complete global
embeddedness obstruction. The positive branch is the \(\omega_1\)
class in the marking aligned with its auxiliary real oval, not the
classes excluded there in 2015.

The mathematical significance is a complete, all-modulus exclusion of
a specified reflection/spin component in the first unresolved
genus/end case \(g=1,k=4\), rather than a bounded period search.
The auxiliary-oval argument eliminates an entire signed branch
without solving its periods; the negative branch is a fully
admissibility-preserving reduction. The planar turning theorem and
spin transport themselves are classical tools and are not claimed
as new general principles.

Non-subsumption by the inspected sources is evidence of a concrete
gap filled, not an exhaustive literature survey or an editorial
publication decision. The existing independent Reviewer assessed
this theorem and its separation from the reviewed CCCC model as
`verified_new` and `publishable`; that verdict is preserved, not
reissued by the Engineer. The comparison does not certify the
historical unreadable display or unexamined contents of Romon's
thesis. The original witness claim `TARGET` remains open.

## Rerunnable exact evidence and admitted premises

The no-fixed-puncture identities replay with:

```bash
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/kato-muroya-nonzero-reciprocal-nofixed/verify_exact.py
```

The dedicated Jacobian payload and complete typed response are
preserved beside that script. The operation was
`polynomial.ideal.normal_form.compute`, adapter exit 0, server
`0.14.0`, protocol `2025-11-25`, outcome `COMPUTED`, with exact
zero remainder. Its scope is the planar speed identity, not the
geometric theorem.

The separately rerunnable source-normalization certificate is:

```bash
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/reciprocal-reflection-theorem/verify_source_premises.py
```

It checks the explicit data normalization, four height residues,
the typed bounded Jacobian products, and provenance of the three
unchanged independent Kato--Muroya source readings. Archiving those
existing readings as citation evidence does not create another
independent review.

The exact invariant comparison replays with:

```bash
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/reciprocal-reflection-theorem/literature/verify_cccc_comparison.py
```

These algebraic certificates support the displayed identities;
they do not independently prove global embeddedness obstructions,
statement fidelity, originality, or significance. Those conclusions
also require the prose arguments and the independent reviews.

The historical `WOHLGEMUTH-CCCC-DATA` attribution remains
inconclusive in its preserved original record. It is retired as a
live mathematical assumption because the theorem and comparison
use the directly proved explicit model, not an unreadable display.
The changed explicit-model premise `CCCC-FAMILY-DATA`, version 3,
and its dependency split were independently admitted in mission
`e4e6f877e439`, round 1, by
`reviewer:copilot-l2-e4e6f877e439`. Its existing supporting judgment
is `judgement-CCCC-FAMILY-DATA-aa50e19fa6e8`; the historical
inconclusive attribution is not replaced by that judgment.

The independent receipts have distinct scopes:

| Receipt | Admitted contribution |
|---|---|
| `85c325059410`, round 2 | Fixed-puncture obstruction, including asymmetric, planar-intermediate, removable-end, and repeated-growth cases |
| `b0d24e3c49b9`, round 2 | Completed nine-distribution theorem and strict same-spin explicit-model extension; `verified_new` originality and `publishable` significance |
| `e4e6f877e439`, round 1 | Explicit-model source premise and dependency split; preservation of the accepted theorem and comparison |

The receipts are preserved under
`/home/argustest/zimo/.argus-campaign-6800022-run2/projects/0f2d784a6dfc/handoffs/`,
in each mission's `round-0002.json` or `round-0001.json`, respectively.

## Authorized outcome and final-review boundary

This submission addresses alternative **(a)** of the publishable-theorem
authorization in [OBJECTIVE.md](../../OBJECTIVE.md): a global
period/embeddedness obstruction for genus-one four-ended families.
Its resolved component is exactly the **normalized nonzero-spin,
reciprocal-reflection, one-axis** locus defined above, at all
moduli, all nine distributions, and both signed branches. The
strict asymmetric-family extension explains why this is submitted
as a `new_theorem`, not a bounded search miss or a reconstruction
of the explicit CCCC-model exclusion.

Final campaign-level independent certification must judge this
scope against the authorized obstruction-theorem objective and
record correctness, statement fidelity, `verified_new` originality,
and `publishable` significance through the normal final-submission
path. The existing independent receipts and admitted premises are
reused, not reissued by the Engineer. This final decision remains
pending; neither a manuscript edit nor a graph status is campaign
certification. `TARGET` remains open, and no unrestricted end-count
theorem, additional spin component, or embedded counterexample is
asserted.
