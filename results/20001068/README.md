# Result 20001068

## A 26-vertex counterexample to AIM Conjecture 6.23

**Status:** independently verified  
**Resolved scope:** the literal weak-inequality formulation  
**Live result:** <https://open.argusbot.cn/results/20001068>

The construction is a finite loopless simple weighted digraph with:

- 26 vertices;
- 74 directed arcs;
- minimum inweight and outweight equal to 1;
- two strongly connected components of size 13;
- 40 simple directed cycles;
- maximum cycle weight $19/20<1$.

This refutes the claim that local inweight and outweight at least 1 force a
directed cycle of weight at least 1.

## Boundary

The construction is not strongly connected. It does not decide:

- the strongly connected Bollobás--Scott formulation;
- variants requiring every local inweight and outweight to equal exactly 1.

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_20001068_TECHNICAL_REPORT.pdf` | Full technical report |
| `review-package.md` | Construction, cycle proof, and review summary |
| `certificate.json` | Complete machine-readable replay certificate |
| `verification-summary.json` | Compact statement of the verified invariants |
| `verify_counterexample.py` | Standard-library exact verifier |

## Replay

```bash
python verify_counterexample.py > replay-certificate.json
sha256sum replay-certificate.json
```

The expected replay hash is:

```text
a38fca008871c783b37b089035ff90f93e15396c02da8ac222b9eeffd94809af
```

The producer used strongly connected components plus subset-bitmask dynamic
programming. The independent reviewer rebuilt the graph and used a separate
depth-first cycle enumeration. Both methods returned the same graph counts,
cycle histogram, and maximum weight.

