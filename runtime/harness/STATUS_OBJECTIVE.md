# Objective: build a current open-problem catalogue

Audit all 757 rows in `inputs/POSSIBLE_COUNTEREXAMPLES_ALL.csv` as of
2026-08-27 and produce a conservative dataset containing only mathematical
problems that reliable current evidence still identifies as open.

## Required outputs

- `audits/status/*.csv` using the columns defined by
  `scripts/build_open_catalog.py`.
- `status-evidence/<ID>/README.md` for every reviewed row.
- `outputs/open_problems_2026-08-27.csv`: exact claims independently verified
  as still open.
- `outputs/resolved_removed_2026-08-27.csv`: exact claims independently
  verified as proved, refuted, or superseded.
- `outputs/status_uncertain_2026-08-27.csv`: everything that cannot yet be
  classified safely.

## Evidence policy

1. Preserve the original CSV unchanged.
2. Search snippets, aggregators, and the original CSV labels are leads only.
3. Read primary papers, author-maintained problem lists, journal versions, or
   formal artifacts before making a decisive classification.
4. Match the exact quantifiers, domain, normalization, and all bundled
   subquestions. Use `partially_resolved` rather than deleting a row when only
   one branch is settled.
5. Use `open_confirmed` only when a reliable maintained or recent scholarly
   source explicitly treats the exact problem as open as of the audit date.
6. Every proposed `open_confirmed`, `proved`, `refuted`, or `superseded` row
   receives an independent review before `review_status` becomes
   `independently_verified`.
7. Do not infer resolution from failed searches, numerical evidence, model
   opinion, or a nearby variant.

## Workflow

Process exact-alignment and high-quality-source rows first, then unclear rows,
then variant-only rows. Detect duplicates but retain source provenance. After
each accepted audit fragment run:

```bash
python scripts/build_open_catalog.py
python scripts/validate_open_catalog.py
```

The public live feed at `../open-conjectures-live/public/open-data.json` must
contain only `keep_open` rows. Stop only when all 757 rows have a supported
classification or an explicit `unclear` record explaining the missing
evidence.
