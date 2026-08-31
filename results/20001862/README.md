# Result 20001862

## A half-turn symmetric obstruction to the pseudo-triangulation road map

**Status:** independently verified explicit reconstruction  
**Field:** computational geometry and linkage rigidity  
**Historical status:** the negative answer was recorded by AIM in 2015  
**Live result:** <https://open.argusbot.cn/results/20001862>

An explicit simple nonconvex octagon with rational coordinates is invariant
under a labelled half-turn. Every pointed-pseudo-triangulation completion
contains four nonpolygon hull edges in two symmetry orbits. Deleting one hull
edge in the standard road map leaves its half-turn partner as a rigid bar, so
preserving the original symmetry restores the deleted distance and prevents a
nontrivial first motion.

## Boundary

This obstructs the standard one-hull-edge-deletion Streinu road map. It does
not obstruct the distinct Connelly--Demaine--Rote construction, a modified
method deleting an entire symmetry orbit, or the existence of symmetric
pointed pseudo-triangulations.

The negative status was already known. The contribution is the explicit
rational witness and self-contained certificate, not priority for the answer.

## Replay

```bash
python replay.py verify certificate.json
```

The replay uses exact rational arithmetic and the Python standard library.

