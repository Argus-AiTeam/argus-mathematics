# Exact synthesis excluding `m(a)=5`, `K(a)=7`

Use the campaign convention

`P(a)={(n,k): 1<=k<=floor(n/2), C(n,k)=a}`,

`m(a)=|P(a)|`, and let `K(a)` be the largest lower index among the
nontrivial occurrences. The result proved here is

`m(a)=5 => K(a)!=7`.

Together with the reviewed lower bound `m(a)=5 => K(a)>=7`, this gives

`m(a)=5 => K(a)>=8`.

This is a logical synthesis of existing complete classifications. It neither
recomputes their integral points nor turns a finite search miss into a
nonexistence result.

## Hash-pinned inputs

| role | artifact | SHA-256 |
|---|---|---|
| reviewed lower bound `K(a)>=7` | `research/lower_index_six_certificate.json` | `0dd4f5d842a5bb9caf47440a6773995d5caabcd9c5d208dcc28de66fa1ba1b73` |
| exhaustive `K=7` lower-index reduction | `research/k7_67_overlap_equality_certificate.json` | `26a7e4f79151198cd3ace0334cf86c93e4bcae40e76857f69fc5be6ba9d507e1` |
| complete `(2,4)` classification | `research/k7_24_intersection_certificate.json` | `9cae0a28e78209668f1c8bed3f61f6cd022b8dfb6c66c1034482273fee9895d6` |
| complete `(3,6)` and `(4,6)` classifications | `research/k7_36_46_intersections_certificate.json` | `9e5f9a6d89d0684df53fd355b3cb349ab27f0af020f86575e8c14451cb2eae12` |
| complete next `K=8` residual | `research/k8_lower_index_overlap_reduction_certificate.json` | `8a3ff5cebaf061393ee4915e386c141dcdf4ae794f2a8c033f813c899b5cabf8` |

The executable certificate refuses to run if any pinned content changes.

## Exhaustion and branch exclusions

If `m(a)=5`, then `a>=2`; `(a,1)` is the unique trivial occurrence, so
there are four distinct nontrivial lower indices. At `K(a)=7`, the reviewed
reduction enumerates all

`C(5,3)=10`

four-element subsets of `{2,3,4,5,6,7}` containing `7`. Seven are excluded
by the earlier complete pair classifications, and the surviving list is
exactly

`{2,4,6,7}`, `{3,5,6,7}`, `{4,5,6,7}`.

Every occurrence has row `n>=2k`. Since all four occurrences have the same
value, each surviving set forces the pair equality shown below.

| lower-index set | forced equality and exact domain | complete outcome |
|---|---|---|
| `{2,4,6,7}` | `C(Y,2)=C(X,4)`, `Y>=4`, `X>=8` | The only value is `210`; `P(210)={(10,4),(21,2),(210,1)}`, so `m(210)=3`, `K(210)=4`. |
| `{3,5,6,7}` | `C(n,3)=C(m,6)`, `n>=6`, `m>=12` | No integer solution in the domain. |
| `{4,5,6,7}` | `C(n,4)=C(m,6)`, `n>=8`, `m>=12` | No integer solution in the domain. |

The first branch cannot realize the required multiplicity or lower-index set,
and the other two branches have no campaign point. These three sets exhaust
the `K=7` residual, proving `m(a)=5 => K(a)!=7`. Since `K(a)` is an integer,
the inherited lower bound `K(a)>=7` strengthens to `K(a)>=8`.

The exceptional positive values in the `(3,6)` and `(4,6)` tables are also
checked exactly:

`P(1)={}`,

`P(84)={(9,3),(84,1)}`,

`P(210)={(10,4),(21,2),(210,1)}`.

The completeness of these short occurrence lists uses
`C(n,k)>=n` in the left half, hence every occurrence of a positive value
`a` has `n<=a`.

## Remaining exact boundary

The hash-pinned `K=8` reduction enumerates all twenty four-element subsets
of `{2,...,8}` containing `8`. Exactly two all-disjoint systems remain:

`{3,5,7,8}`, `{5,6,7,8}`.

Neither system is excluded here. Thus `C-T5`, both `K=8` branches, and the
counterexample objective remain open.

## Reproduction

Run

```text
/home/argustest/zimo/argus-latest/.venv/bin/python research/k7_total_exclusion_synthesis_certificate.py
```

The script writes
`research/k7_total_exclusion_synthesis_certificate.json` and verifies the
five input hashes, all ten `K=7` sets, the three domain filters, every listed
exceptional occurrence and multiplicity, the total implication, and the
twenty-set `K=8` residual.
