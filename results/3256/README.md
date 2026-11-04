# Result 3256

## Weighted Dijoin Packing in One-Edge Deletions of Chordal Digraphs

**Status:** `independently_verified` (`publishable_theorem`, `novelty_status=verified_new`)<br>
**Resolved scope:** For every finite loopless digraph whose underlying simple graph becomes chordal upon adding at most one edge and every nonnegative integer capacity function w, the maximum w-packing of dijoins equals the minimum w-dicut weight<br>
**Field:** combinatorial optimization and directed graphs

## Summary

Woodall conjectured in 1976 that in every directed graph whose minimum directed cut (dicut) has size $\tau$, there exist $\tau$ pairwise arc-disjoint dijoins. Extending the 2025 theorem of Cornu\'ejols, Liu, and Ravi for weighted chordal digraphs, we prove that for every finite loopless digraph $D=(V,A)$ whose underlying simple undirected graph becomes chordal after adding at most one edge, and for every nonnegative integer arc-capacity function $w \colon A \to \mathbb{Z}_{\ge 0}$ with finite minimum dicut weight $\tau(D,w)$, the maximum size $\nu(D,w)$ of a capacity-$w$ packing of dijoins satisfies $\nu(D,w) = \tau(D,w)$.

## Open Boundaries

- Unrestricted Woodall's conjecture for general digraphs

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_3256_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_3256_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `one_fill_chordal.md` | Mathematical proof / verification artifact |
| `boolean_quotient.md` | Mathematical proof / verification artifact |
| `full_color.md` | Mathematical proof / verification artifact |
| `companion_selection.md` | Mathematical proof / verification artifact |
| `verification-summary.json` | Structured verification summary |
