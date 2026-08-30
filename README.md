# Argus Mathematics

Public mathematical results, verification artifacts, and research records from
the [Argus AI Team](https://github.com/Argus-AiTeam).

[中文说明](README.zh-CN.md) ·
[Live mathematics portal](https://open.argusbot.cn/) ·
[Full problem catalog](https://open.argusbot.cn/catalog) ·
[Research broadcast](https://open.argusbot.cn/broadcast)

## What this repository contains

This repository preserves the completed and reviewable outputs of the Argus
mathematics program. It is organized around claims and their evidence rather
than around model transcripts.

As of **2026-08-30**, the public program contains:

- **3 published result packages** with technical reports or editor notes;
- **2 independently replayable computational certificates**;
- **1 Lean-checked logical composition** with an explicit formalization
  boundary;
- **30 active research targets** on the live workbench;
- **757 historical problem records** under source and status audit.

The live portal changes more frequently than this repository. The repository
is the durable archive for completed result packages; the portal remains the
current view of active campaigns and catalog status.

## Published results

| ID | Result | Field | Public status |
|---|---|---|---|
| [20001068](results/20001068/) | A 26-vertex counterexample to the literal weak-inequality form of AIM Conjecture 6.23 | Weighted digraphs | Independently verified |
| [11000263](results/11000263/) | $X_3\neq0$ under two natural well-typed repairs of Bigelow Question 6 | Braid groups and algebra | Internal review passed; external specialist review invited |
| [2884](results/2884/) | A scope-level counterexample to the arbitrary-$X$ wording of K3 Problem 4.8 | Smooth 4-manifolds and knot surgery | Scope observation; the fixed $X=E(2)$ conjecture remains open |

### Result 20001068

A finite loopless simple weighted digraph is constructed with 26 vertices and
74 arcs. Every vertex has total inweight and outweight at least 1, but all 40
simple directed cycles have weight $19/20$. This refutes the literal
weak-inequality statement of AIM Conjecture 6.23.

It does **not** refute strongly connected variants or formulations requiring
every local inweight and outweight to equal exactly 1.

### Result 11000263

Bigelow's printed presentation invokes a generator that does not exist in the
stated braid group. Under each of two natural well-typed repairs, an unreduced
Burau representation gives

$$
\rho(X_3)=(q-u)(q^2-u)E_2\neq0.
$$

The result is a negative answer under those two explicit repaired
presentations. It is not an unconditional statement about the ill-typed
literal presentation, and no worldwide priority claim is made.

### Result 2884

For the fixed ambient pair

$$
(X,F)=\left(E(2)\mathbin{\sharp}(S^2\times S^2),\ \text{regular elliptic fiber}\right),
$$

where $\sharp$ denotes the connected sum,
the prime knots $T(2,3)$ and $T(2,5)$ are neither equal nor mirrors, while
the corresponding knot-surgery manifolds are diffeomorphic after applying the
published stabilization theorem.

This addresses the general arbitrary-$X$ wording of Problem 4.8. It does
**not** settle the Fintushel--Stern K3 conjecture with $X$ fixed to $E(2)$.

## Evidence policy

Each result directory distinguishes:

1. the exact claim that is supported;
2. nearby variants that are not decided;
3. the technical report or mathematical note;
4. machine-readable certificates and replay code;
5. the level of independent or specialist review;
6. any novelty or priority limitation.

Terms such as *verified*, *reviewed*, and *formalized* are used only with the
scope defined in [docs/status-and-scope.md](docs/status-and-scope.md).

## Reproduce the computational checks

Python 3.10 or newer is recommended.

```bash
python -m pip install -r requirements.txt
python scripts/verify_artifacts.py
python results/11000263/verify_burau.py
python results/20001068/verify_counterexample.py > /tmp/result-20001068.json
```

The verifier for Result 2884 checks a larger campaign bundle that includes
source transcriptions and Jacobian replay files. Those inputs are not all part
of the current public download package, so the archived verifier is retained
for provenance but is not presented as a standalone repository check. The
Lean file checks the logical composition described in
[`statement_fidelity.md`](results/2884/statement_fidelity.md).

## Repository layout

```text
results/
  20001068/   independently verified weighted-digraph counterexample
  11000263/   Burau witness for two repaired Bigelow presentations
  2884/       K3 Problem 4.8 scope observation
docs/
  status-and-scope.md
  research-program.md
data/
  results.json
scripts/
  verify_artifacts.py
SHA256SUMS
```

## Review and citation

Mathematical scrutiny is welcome. A useful review should identify the result
ID, the exact claim or boundary being reviewed, and either a reproducible
calculation or a precise source/theorem issue.

Use [`CITATION.cff`](CITATION.cff) for repository-level citation. Individual
technical reports should be cited directly when they are the object of
discussion.
