# Objective: verify the first high-yield counterexample batch

Use the latest clean Argus checkout to turn the candidate list in
`inputs/POSSIBLE_COUNTEREXAMPLES_ALL.csv` into a small, publication-ready first
batch of exact counterexamples or published refutations.

## Concrete outcome

Produce **20 accepted rows** in `outputs/results.csv`. An accepted row must be
one of:

- `confirmed_counterexample`: an explicit witness is given and independently
  checked against the exact proposition;
- `published_refutation`: a primary scholarly source explicitly refutes the
  exact proposition and the relevant source passage has been read;
- `corrected_misstatement`: the displayed problem is false only because its
  quantifier, normalization, convention, or transcription differs from the
  source, and the correction is documented from primary material.

Start from `inputs/priority_pool.csv`. If fewer than 20 rows survive exact
alignment and evidence review, exhaust that pool and report the honest smaller
number; do not lower the bar or count variant-only evidence.

## Required workflow

1. Re-read the exact Chinese problem statement and, when available, the
   UnsolvedMath page and original source. Freeze the proposition actually being
   tested, including all quantifiers, normalizations, domains, asymptotic
   regimes, and conventions.
2. Treat CSV labels and search snippets only as leads. They are not evidence.
3. Prefer primary sources: papers, authors' manuscripts, official problem-list
   pages, or maintained formal/computational artifacts. Read the relevant full
   text before using a source decisively.
4. For an explicit witness, produce a reproducible exact check. First inspect
   the Jacobian 0.14.0 operation catalog with
   `/home/argustest/zimo/references/jacobian/.venv/bin/jacobian --help` and use a
   matching typed operation when one exists. Otherwise write the smallest
   deterministic exact checker needed for the claim. Never treat timeout,
   floating-point agreement, a failed search, or an `UNKNOWN` result as a
   mathematical conclusion.
5. Have the Reviewer independently check proposition alignment, source
   meaning, and the witness/check. Reject attractive evidence that proves only
   a nearby variant.

## Deliverables

- `outputs/results.csv`, UTF-8, with these columns in this order:
  `ID,title,disposition,exact_proposition,counterexample_or_refutation,verification_method,verification_command,source_urls,source_excerpt_location,confidence,limitations`
- One evidence directory per accepted ID at `evidence/<ID>/`, containing a
  concise `README.md`, the exact checker input/output when applicable, and
  enough source metadata to retrieve the cited primary material again. Do not
  copy entire copyrighted papers into the repository.
- `reports/BATCH_001.md`, summarizing accepted results, rejected near-misses,
  Jacobian operations used, reproducibility commands, and remaining risks.
- `outputs/rejected.csv` for reviewed candidates that failed alignment or
  evidence standards, with columns `ID,title,rejection_reason,notes`.

## Acceptance checks

- Run `python scripts/validate_outputs.py` successfully.
- Every accepted ID is unique and came from the supplied CSV.
- Every accepted row has at least one source URL and a precise source location.
- Every `confirmed_counterexample` has a rerunnable exact verification command
  and archived checker output.
- No row relies only on a search snippet, secondary news story, aggregator,
  ResearchGate metadata page, or model-generated assertion.
- The report states the exact Argus and Jacobian revisions used and the UTC
  completion date.

## Scope and authority

This is a bounded research-and-verification mission. Do not modify the Argus or
Jacobian source checkouts. Do not publish, message third parties, open issues or
pull requests, or change machine-wide configuration. Network retrieval of
public sources and local artifact creation inside this project are allowed.

Pinned clean revisions at launch:

- Argus: `33da786bbc6787a2eeb63a5f492498eae87c78c7`
- Jacobian: `7df85cac75e3a249cb69c6bae685c42b75a31390`
