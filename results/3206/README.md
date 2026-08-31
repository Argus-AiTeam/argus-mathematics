# Result 3206

## A Cayley graph on Z15 whose core is C5

**Status:** independently verified reconstruction of a known counterexample  
**Field:** algebraic graph theory  
**Historical counterexample:** publicly identified in 2008  
**Live result:** <https://open.argusbot.cn/results/3206>

The Cayley graph on $\mathbb Z_{15}$ with connection set

$$
\{1,4,6,9,11,14\}
$$

has graph core $C_5$. Since $5$ is not a nonnegative integral power of $15$,
this refutes the literal arbitrary-abelian formulation of Open Problem Garden
Problem 125.

## Boundary

The problem author subsequently clarified that the main intended case was
$\mathbb Z_p$. This construction does not decide prime cyclic,
elementary-abelian, or cubelike variants, and it is not an Argus priority
claim.

## Replay

```bash
python replay.py certificate > replay-certificate.json
python replay.py jacobian > jacobian-payload.json
```

The standard-library replay checks the Cayley graph, retraction onto $C_5$,
all $5^5$ vertex maps of $C_5$, and the cardinality obstruction.

