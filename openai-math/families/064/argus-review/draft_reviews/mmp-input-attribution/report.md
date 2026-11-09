# Exact relative MMP input and attribution

**Assessment:** this is a precisely stated, unresolved external input, not a
proved MMP theorem. The assessment agrees with the old independent
inconclusive judgements. Neither a source-access failure nor a valid
conditional preservation argument proves or refutes its existence.

## Claims, versions and source

`C_RELATIVE_MMP_INPUT_064` versions 1 and 2 have statement hash
`171f9bd6279c677ffff170c72ce20c135018286720e3c02105dbd69091fc9d0d`.
Version 2 adds the explicit unverified `A_KM79_REQUIRED_064`; there is no
second theorem, source verification or mathematical strengthening between
the versions.

The old source is `model_derivation.md:164-179,267-end`. The relevant
manuscript is `prop:log-model`, especially the paragraph applying the
program over \(X\), in `build/sections/06-model.tex`, revision
`4eaee87548250b2682affda7d05d947c05554bae`.

The required input is a finite \((K_V+H_V)\)-MMP for the smooth, Q-factorial
marked semistable threefold \(V\), **relative to the projective birational
target \(X\)**. Its steps must be projective over \(X\), consist of
divisorial contractions and flips, preserve Q-factoriality, extract no
divisors, preserve the usual dlt discrepancy inequalities for any boundary
for which these same steps are negative, and terminate with a nef model or
Mori fiber space. \(H_V\) has coefficient-one horizontal components.
The target has the literal log-model hypotheses, not an extra klt or
mu-constant assumption.

## What the proof needs, and what it does not establish

The initial pair \((V,H_V)\) is SNC, hence dlt, and
\((V,H_V+V_c)\) is SNC for every remaining \(c\). This checks the
starting-pair requirement. It does **not** by itself construct contractions
or flips or prove termination.

The precise relative base is load-bearing. A program only over the curve
could contract curves not contracted by \(V\to X\), need not factor over
\(X\), and would not establish nefness *over \(X\)* or the stipulated
off-section isomorphism by the old reasoning. Accordingly no theorem only
over a curve may be silently substituted for the formulated input.
Likewise a theorem for an unmarked threefold, a boundary with coefficients
strictly below one, or an altered target singularity hypothesis would need
a further argument; the old draft supplies no such reduction.

The preservation unit legitimately uses the numerical triviality of a
fiber pulled back from the curve to apply discrepancy preservation to each
augmented boundary along one fixed sequence. That is a conditional
consequence, not a mechanism for proving the sequence exists. The
birational-target dimension argument excludes a Mori fiber outcome only
*after* such a relative terminating sequence has been supplied.

Thus the concrete gap is a theorem/application giving this finite marked
relative MMP with all of these hypotheses and relative-base conditions.
This is more specific than "the book could not be downloaded." No
contradiction in the asserted input has been demonstrated.

## Bounded primary-source check

The manuscript attributes its step to Kollár--Mori, *Birational Geometry
of Algebraic Varieties* (1998), Definition 7.1 and Theorem 7.9, book DOI
`10.1017/CBO9780511662560`. The old draft records unsuccessful Cambridge,
Google Books and institutional-mirror access attempts; those historical
attempts were read as evidence, not rerun or treated as current availability.

In this review the official Cambridge chapter page was fetched once:

<https://www.cambridge.org/core/books/birational-geometry-of-algebraic-varieties/semistable-minimal-models/FBE3AE59A8E2924E2F7974416F3C8211>

It redirected to the `/abs/` chapter page. The publisher identifies
Chapter 7, pages 207-240, chapter DOI `10.1017/CBO9780511662560.009`.
Its accessible summary describes semistable threefold MMP viewed as a
family of surfaces over a curve, and an access link; it does not expose
Definition 7.1 or Theorem 7.9. This confirms chapter metadata only,
not the required relative base or boundary theorem.

A single targeted web lookup asked specifically for the primary statements,
their coefficient-one horizontal boundary convention and the relative base.
It returned publisher/Google Books locations but no readable operative
passage. No theorem text, individual theorem page, precise hypothesis list
or replacement result was obtained. No PDF was compiled or mathematical
MMP operation executed. This is a bounded unsuccessful attribution check,
not a survey or proof of unavailability everywhere.

The active ledger therefore retains the assumption as source-only, with
the exact needed input and the claimed bibliographic locator explained in
prose. It does not file a fabricated proposition quotation, a supporting
self-check, or a successful DOI resolution as theorem verification.
Definition 7.1 and Theorem 7.9 remain unattributed at proposition level.

## Inheritance, originality and disposition

The old independent judgements
`judgement-C_RELATIVE_MMP_INPUT_064-f749947fd1e8` and
`judgement-A_KM79_REQUIRED_064-4528790ff46e` are both inconclusive.
Their subjects and dependencies agree with the source examined here, so
they are retained rather than upgraded or discarded because of graph labels.

This unit is an external-input formulation and attribution debt, not an
original theorem, a counterexample, or a completed attack on the
manuscript. No novelty has been established. A proposed unconditional
log-model conclusion would require closing this gap, but is not pursued
in this review. There is no Lean formalization. The input and parent
log-model proposition remain mathematically unresolved by the listed work;
the review of that unresolved state is ready for native independent review.
