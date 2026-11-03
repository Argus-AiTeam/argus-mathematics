# Frozen scope for counterexample campaign 1994

## Exact target

The campaign seeks a positive construction that refutes the conjectured
nonexistence of a dense planar rational-distance set:

> There exists a countable set \(S\subseteq\mathbb R^2\) such that
> \(\overline S=\mathbb R^2\) and, for every distinct \(x,y\in S\),
> \[
> d(x,y)=\sqrt{(x_1-y_1)^2+(x_2-y_2)^2}\in\mathbb Q_{>0}.
> \]

Here countable means finite or countably infinite; density forces the latter.
The closure and distance are Euclidean. Requiring the distance itself to be a
positive rational is essential: merely proving that its square is rational
does not suffice.

Equivalently, an admissible witness may be given by an injective enumeration
\(E:\mathbb N\to\mathbb R^2\) satisfying

1. for all \(m\ne n\), there is an exactly represented
   \(q_{m,n}\in\mathbb Q_{>0}\) with
   \(\|E(m)-E(n)\|_2^2=q_{m,n}^2\); and
2. for every \(c\in\mathbb Q^2\) and \(k\ge 1\), there is an \(n\) with
   \(\|E(n)-c\|_2<1/k\).

The second condition is equivalent to plane density because rational centers
and positive reciprocal radii form a countable basis for \(\mathbb R^2\).

## Exact candidate certificates

Every accepted candidate must be a finite artifact with a deterministic,
independently rerunnable exact verifier. Decimal output may accompany the
certificate but may not discharge an equality, inequality, totality, or
infinite quantifier.

### A. Exact-enumerator certificate

An admissible enumerator package contains:

1. a finite exact definition of a total injective function
   \(E:\mathbb N\to\mathbb R^2\), including an exact representation and
   equality procedure for its coordinates;
2. a uniform finite proof or mechanically checked proof object that, from
   arbitrary \(m\ne n\), produces \(q_{m,n}\in\mathbb Q_{>0}\) and verifies
   \(\|E(m)-E(n)\|_2^2=q_{m,n}^2\);
3. a uniform finite density proof, for example an enumeration
   \(B_j=B(c_j,r_j)\) of all rational open balls together with a total index
   function \(N(j)\) and exact inequalities proving \(E(N(j))\in B_j\); and
4. the verifier command and all inputs needed to check the preceding
   statements without network access or floating-point trust.

### B. Exact extension-theorem certificate

An admissible extension package enumerates all rational open balls
\((B_j)_{j\in\mathbb N}\) and gives a deterministic exact construction of
nested finite sets
\[
F_0\subset F_1\subset\cdots
\]
such that, for every \(j\):

1. all distinct pairs in \(F_j\) have positive rational distance;
2. the extension step terminates and produces a new point
   \(p_j\in B_j\setminus F_j\) whose distance to every point of \(F_j\) is a
   positive rational; and
3. \(F_{j+1}=F_j\cup\{p_j\}\), with exact representations preserved by the
   step.

The finite certificate must mechanically check the extension theorem for an
arbitrary stage, not only replay a bounded list of successful stages. Then
\(S=\bigcup_jF_j\) is countable, meets every rational ball, and has rational
distance between every distinct pair.

## Reused reviewed source audit

The authoritative read-only audit row is
`/home/argustest/zimo/counterexample-batch-1/audits/status/agent-open-expert.csv`,
row `id=1994`, whose review status is `independently_verified`. It records:

- Junkai Qiu, *Infinite rational distance sets in affine general position:
  constructions in every dimension*, arXiv:2608.23529v1, p. 1,
  Introduction: the dense planar problem remains open; the cited new infinite
  construction is dense on an analytic arc, not in the plane.
- Erdős Problems #212, `https://www.erdosproblems.com/212`, `OPEN` entry:
  the problem is listed as open.
- Jafar Shaffaf, *A solution of the Erdos-Ulam problem on rational distance
  sets assuming the Bombieri-Lang conjecture*, arXiv:1501.00159v3, Abstract:
  the stated negative conclusion depends on the Bombieri-Lang conjecture.

These are known-status and boundary facts, not evidence for the target
existence claim. The target claim therefore carries no external assumption.
The source-scope claim in `research/MATH_STATE.json` records them separately.
The audit also identifies campaign ID 1279 as an exact duplicate of ID 1994;
that duplication does not supply a witness.

## Explicitly non-qualifying outcomes

The following outcomes are outside the success contract:

- any finite rational-distance configuration, because a finite subset of
  \(\mathbb R^2\) is closed and is not dense in the plane;
- an infinite set dense only relative to a line, circle, analytic arc, or any
  other proper closed subset of the plane;
- a result conditional on Bombieri-Lang or another unproved hypothesis;
- arbitrarily many successful finite extensions without a proved total,
  compatible extension rule for every stage;
- a finite pair check, finite density grid, long numerical prefix,
  floating-point residual, numerical near-solution, heuristic, or sampled
  experiment;
- rational squared distances without exact rational square roots, or zero
  distance for indices claimed to represent distinct points;
- a timeout, failed search, adapter or transport error, incomplete output,
  `UNKNOWN`, or absence of a counterexample in a bounded search.

No exact candidate has been found, submitted, or reviewed at this scope stage.

