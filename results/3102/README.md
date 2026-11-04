# Result 3102

## The Support-At-Most-Five Pebbling Number of the Lemke Square Is 64

**Status:** `independently_verified` (`publishable_theorem`, `novelty_status=verified_new`)<br>
**Resolved scope:** Every 64-pebble configuration supported on at most five vertices of the 64-vertex Cartesian square L box L of the 8-vertex Lemke graph reaches every target root<br>
**Field:** graph theory and combinatorial optimization

## Summary

Ronald Graham conjectured in 1989 that the pebbling number of a Cartesian product of connected graphs satisfies $\pi(G_1 \mathbin{\square} G_2) \le \pi(G_1)\pi(G_2)$, with the $64$-vertex Cartesian square $L \mathbin{\square} L$ of the eight-vertex Lemke graph $L$ ($\pi(L)=8$) serving as the classical minimal open testbed. Prior work established the sharp threshold $64$ on $L \mathbin{\square} L$ only for configurations supported on at most four vertices. We prove that the support-at-most-five pebbling number of $L \mathbin{\square} L$ is exactly $64$: every nonnegative integer configuration of total size $64$ supported on at most five vertices reaches every target root.

## Open Boundaries

- Configurations on L box L with support size >= 6 and unrestricted Graham's pebbling conjecture

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_3102_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_3102_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `support_five.md` | Mathematical proof / verification artifact |
| `discharge_cover.py` | Mathematical proof / verification artifact |
| `fiber_discharge.py` | Mathematical proof / verification artifact |
| `pebbling.py` | Mathematical proof / verification artifact |
| `test_discharge_cover.py` | Mathematical proof / verification artifact |
| `verification-summary.json` | Structured verification summary |
