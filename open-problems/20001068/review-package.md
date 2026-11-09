# Result 20001068 — exact weighted-digraph counterexample

## Claim decided

The literal weak-inequality form of AIM Conjecture 6.23 says that a finite
weighted digraph with inweight and outweight at least 1 at every vertex must
contain a directed cycle of total weight at least 1.

The published construction has 26 vertices and 74 arcs. Every vertex has
inweight and outweight at least 1, while every simple directed cycle has total
weight exactly 19/20. It therefore refutes that literal statement.

It does **not** refute variants requiring equality of the local weights or a
strongly connected digraph.

## Construction

For each sign `s` in `{-,+}`, use vertices

`r_s, a0_s, a1_s, b01_s,...,b05_s,b11_s,...,b15_s`.

In the plus component, for each `i in {0,1}` and `j in {1,...,5}`, add

- `r+ -> ai+` with weight `1/2`;
- `ai+ -> bij+` with weight `1/5`;
- `bij+ -> r+` with weight `1/4`;
- `bij+ -> ai+` with weight `3/4`.

Reverse all these arcs, preserving their weights, in the minus component.
Finally add `bij- -> bij+` with weight `4/5` for every leaf.

The cross arcs all point from the minus component to the plus component, so no
directed cycle crosses between components.

## Cycle proof

Within either component, the only simple directed cycles are

- `ai <-> bij`, of weight `3/4 + 1/5 = 19/20`;
- `r -> ai -> bij -> r` (or its reversed minus copy), of weight
  `1/2 + 1/5 + 1/4 = 19/20`.

There are twenty cycles of each length, hence forty in total.

## Reproduction

Download `verify_counterexample.py` and run:

```text
python verify_counterexample.py > replay-certificate.json
```

The script uses only the Python standard library and integer arithmetic in
units of `1/20`. A byte-identical replay has SHA-256:

`a38fca008871c783b37b089035ff90f93e15396c02da8ac222b9eeffd94809af`

An independent Reviewer used a separate depth-first enumeration and obtained
the same 26 vertices, 74 arcs, 40 cycles, and maximum cycle weight 19/20.

## Publication status

The audit row was atomically appended as the sole new row after a certified
296-row prefix. Scientific fields matched the preregistered staging row, and
the review status was promoted to `independently_verified`.
