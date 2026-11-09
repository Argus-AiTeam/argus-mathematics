# A quantitative repeated-path verification theorem

## Result and scope

The passage from actual repeated path occurrences to multiplicity-stage
expectations in the staged torsion-free manuscript is valid under its stated
upstream turn-count and edge-prescription inputs. The proof below derives the
counts from the paths; it does not assume either disputed counting formula.
It also gives an explicit finite error budget and a stronger admissible
unpaired proportion. No false manuscript assertion has been established.

This is a **general conditional verification theorem**, with an independent
Lean certification of its finite occurrence/coarea and component-inequality
cores. It is not a finite-enumeration proof, a refutation, or a certification of
the whole group-algebra construction. Independent review of the prose and its
translation from paths is still required. Novelty and publishable significance
relative to the literature have not been independently established.

The earlier result being compared is `thm:bounded-patterns` itself: it gives an
unspecified uniform error and the conservative choice
`min(1/4, delta/(16(1+a_0)))`. The improvement here is an explicit path-derived
finite error bound, valid for general typed graph laws, and the range
`epsilon < tau/(A-tau)` below. Merely multiplying hypothetical stage bounds
would not establish this result.

## Source and quotations

All source locations are in the staged release
`research/openai_manuscript/`
`A-Torsion-Free-Group-Algebra-That-Is-Not-Directly-Finite-October-4-2026/build/sections/`.
The dated release, filenames, and LaTeX labels identify the version.

| File and location | Literal assertion audited |
|---|---|
| `patterns.tex:22-25`, `eq:distinct-comparison-edges` | "paired positions traverse distinct underlying undirected edges of $\Gamma$." |
| `patterns.tex:28-45`, `thm:bounded-patterns` | "In particular, $\varepsilon$ is chosen before $K_0,C,I$." |
| `patterns.tex:165-171`, `eq:stage-incidence` | `\sum_j E_j=H`, `\sum_j V_j\le H+\iota`, `\sum_j(V_j-E_j-k_j)\le0` |
| `patterns.tex:437-442`, `eq:fixed-stage-expectation` | `n^{V_j-E_j-k_j}\exp(-\sum_{i:m_i\ge j}d_i+o(L))` |
| `patterns.tex:475-481`, `eq:stage-label-count` | the positive term is `2\min_{i\in\mathcal U}d_i-\delta s`, at stages `z_{\mathcal U}\ge j` |
| `patterns.tex:561-569`, `eq:stage-product`, `eq:epsilon-choice` | `\log\prod_j B_j\le-\frac\delta2 H+a_0b_0+o(L)` and `\varepsilon:=\min\{\frac14,\frac{\delta}{16(1+a_0)}\}` |
| `random.tex:147-150`, `eq:turn-count` | the reduced-turn count is `np\,w(t,u)+O(1)` |
| `random.tex:300-316`, `lem:prescriptions` | collections of distinct prescriptions have probability at most `(np)^{-E}\exp(o(L))`, uniformly for `E<=C_1 L` |

The proof uses no external literature theorem. The upstream stochastic inputs
are explicit hypotheses, not newly certified facts about the source model.
The source proves them in `random.tex`; the application to that model remains
dependent on those proofs. The word-mass input is checked independently here.
The project Wiki contained no earlier result about this bounded-path bridge.
No claim of a literature novelty search is made.

## Quantitative theorem

Let `T` be a finite alphabet of size `t>=2`, with fixed-point-free involution
`bar`. Let the turn weights satisfy:

1. `0 <= w(a,b) <= 1`, with zero exactly on cancelling turns;
   positive weights are at least `exp(-A)`.
2. `w(a,b)=w(bar(b),bar(a))`.
3. For every integer `h>=1`,
   `sum_{W in T^h} P(W)^2 <= K exp(-2 tau (h-1))`,
   where `A>tau>0`, `K>=1`, and
   `P(a_1...a_h)=product_{r<h} w(a_r,a_{r+1})`.

Fix `c >= 1 + (log K)/2 + 2 tau`. Consider random labelled graphs on a
fixed finite number of prescribed sides, each with at most `n` vertices.
The vertex sets and allowable outgoing label slots `S_x` are fixed
before sampling. Edges connect compatible inverse slots and use each
slot at most once. In particular there is at most one outgoing edge of
a given label at a vertex. The graph has girth at least `L`, where
`L -> infinity`. Assume, for every fixed
length bound `C`, nonnegative uniform errors `eta_n -> 0` and
`e_n=o(L)` such that:

* on either prescribed side, every reduced turn `(a,b)` has at most
  `np w(a,b) exp(eta_n)` vertices with `bar(a),b in S_x`,
  for fixed `0<p<=1`;
* any specified `E<=CL` distinct edge prescriptions have joint probability
  at most `(np)^(-E) exp(e_n)`.

These are only local vertex counts and a distinct-edge probability bound;
they contain no assumption about repeated-path multiplicities, stage
incidences, link words, or pattern counts. A bounded choice of prescribed
roots is fixed before sampling. The two-side source model is the instance
used below.

Take any actual system from the bounded-path theorem: at most `K_0` paths,
closed and cyclically immersed apart from at most one immersed interval
starting at a prescribed root; total length `L<=H<=CL`; at most `I`
disjoint interval comparisons; distinct underlying edges at paired
positions. Equality and inverse-reversed equality are both allowed.
Write `b_0` for the unpaired positions and `iota` for the interval indicator.

The following finite bound holds for every enlarged pattern obtained from
these paths. Let:

* `J` bound its number of marked chains;
* `M` bound every edge multiplicity;
* `d>=1` bound the number of affine subcomparisons;
* `s>4` be a common grid scale;
* `theta` bound `dist(a/s,Z)` for every affine offset `a`;
* `2 theta+8/s <= kappa < 1/4`;
* `Q=16(2JM+4d)`.

There are deterministic first-moment bounds `B_j`, for
`1<=j<=m_*<=M`, such that a full realization has probability at most
`min_j B_j`, and

```text
log product_j B_j <= -tau H + (A-tau)b_0 + D,

D = tau JM(s+1) + (A+2c)H/(s-1) + (A-tau)sQ
    + M [ J log(1/p) + H eta_n + e_n
          + {J(s+1)+(kappa s+1)H/(s-1)} log t ].
```

In particular, for every fixed `K_0,C,I` and
`0<epsilon<tau/(A-tau)`, the probability of any such system with
`b_0<=epsilon H` tends to zero. The choice of `epsilon` depends only on
the alphabet and weights. Thresholds, convergence rates, and the constants
`J,M,d` may depend on `K_0,C,I`. No independence of stages is assumed.

### Proof: actual paths give bounded chains

Here and below graph degrees count half-edges. Girth greater than two
excludes loops and parallel edges in the image graph.

For completeness, the bounded-rank argument is as follows. Remove trees
and circle components and suppress degree-two vertices. In the remaining
weighted multigraph let `r` be the number of edges; its minimum degree is
at least three and its total edge length is at most `CL`. The stationary
nonbacktracking walk on directed edges has expected length at most `kCL/r`
in `k` steps. At least half its mass is on walks of length at most
`2kCL/r`; each walk has mass at most `(2r)^(-1)2^(-(k-1))`.
For `k=ceil(log_2(8r))+1`, there are more than `(2r)^2` such walks.
Two have equal endpoints, so their expansions contain a cycle of length
at most `4kCL/r`. Thus `r<=4C(ceil(log_2(8r))+1)`, bounding `r` in
terms of `C`. Circle components contribute at most `C` to cycle rank.
This proof works for weighted loops and parallel edges in the suppressed
multigraph too; the original image has none.

An optional explicit bound is `r<=64C^2`: for `r>=25`,
`ceil(log_2(8r))+1 <= log_2 r+5 <= 2 sqrt(r)`.
The inequality `log_2 r<=sqrt(r)` holds for `r>=16`, by its derivative
and equality at 16. For smaller `r`, the asserted bound follows from
`C>=1`. Hence the image cycle rank is at most `64C^2+C`.

Mark every non-degree-two vertex and every indexed path endpoint.
A leaf must be an interval endpoint, so there are at most two leaves.
The identity
`sum_{deg(v)>=3}(deg(v)-2)=2 beta-2 components+#leaves`
bounds both branch vertices and their total degree. Each component
contains a path start, so even circle components have a mark. The
chains between marks partition all edges. One may use the integer bound
`J=ceil(192C^2+3C+2K_0+4)`. It need not be sharp.

Every path traverses whole chains: at an unmarked degree-two vertex its
next edge is forced by immersion. Successive traversals of a fixed
oriented edge in one indexed path are separated by a nonempty reduced
closed walk, of length at least `L`. Consequently
`m_e<=2(H/L+K_0)<=2(C+K_0)`; use
`M=ceil(2(C+K_0))`. Chain multiplicities are constant, and the total
number of chain traversals is at most `JM`. Splitting comparisons at
chain/index boundaries gives boundedly many subcomparisons; for example
`d=max(1,I+2JM)` is a safe upper bound. Each split is forced, not a
new combinatorial choice.

### Proof: turns give the stage incidence, including endpoints

At a vertex, pair the two traversal incidences belonging to each actual
path turn, including the closing turns of the closed paths. The only
unmatched incidences are the two interval endpoints, counted twice at
one vertex if necessary. Immersion pairs different half-edges.

For a fixed half-edge, matching injects all its non-endpoint incidences
into the other incidences at that vertex. Thus, writing `a(v)` for its
number of unmatched incidences,

```text
2 max_{e incident to v} m_e <= sum_{e incident to v} m_e + a(v).
```

This is the finite occurrence-matching lemma in `Main.lean`, applied at
the vertex. Loops are absent, so a half-edge's incidence count is exactly
the undirected edge multiplicity. A vertex belongs to exactly
`max_{e incident to v}m_e` stages and an edge to exactly `m_e`
stages. Double counting, also formalized by `stage_coarea`, gives

```text
sum_j E_j=H,
2 sum_j V_j <= 2H+2 iota,
sum_j (V_j-E_j-k_j) <= 0,
```

with `k_1=iota` and other `k_j=0`. The root is fixed only at stage one.
Individual stage exponents can be positive: the actual theta-graph
fixture in `verify.py` has exponents `(-1,0,1)`. It would be invalid
to demand nonpositive exponent at every stage separately.

### Proof: an actual common grid and occurrence matching

Orient each chain and put its edge positions at half-integer coordinates.
Incorporating traversal direction and comparison reversal, each
subcomparison is `x -> sigma x+a`, where `sigma` is `+1` or `-1`
and `a` is an integer. In chain orientation the constraint is equality
for `sigma=+1` and inverse equality for `sigma=-1`.

Put `N=floor(L^(1/(2(d+1))))` and `R=floor(sqrt(N))`.
The pigeonhole principle, applied to the `N^d+1` vectors
`({ell a_1/L},...,{ell a_d/L})`, gives `1<=u<=N^d` with
all `dist(u a/L,Z)<=1/N`. Pick the first such integer deterministically
and put `s=L/(uR)`. Then

```text
L/(N^d R) <= s <= L/R,
dist(a/s,Z) <= R/N,
s -> infinity,  s/L -> 0.
```

Choose `kappa=2R/N+8/s` once it is below `1/4`.
Full blocks are the edge positions in grid intervals `[ks,(k+1)s)`
contained in a chain. Their integer lengths satisfy `s-1<=h_i<=s+1`.
The final fragment on a chain has fewer than `s+1` edges.

Each chain traversal supplies a separate occurrence of every one of its
blocks. Within each subcomparison match two occurrences when their
compared contiguous overlap has length at least `(1-kappa)s`, retaining
the entire overlap constraint. This is a partial matching, not an
arbitrary graph on occurrences: the overlap is greater than half of
either block's length, and two overlaps at one occurrence would violate
disjointness of the compared path positions.

Exclude occurrences within distance `3s+4` of a traversal endpoint or a
subcomparison endpoint. There are at most `2JM+4d` such endpoints.
For `s>4` a single endpoint can affect fewer than 16 full-block
occurrences along its indexed path, so at most `Q` occurrences are
excluded. This bound also covers endpoints shared by adjacent traversals.
An unexcluded occurrence that has a compared position is wholly within
one subcomparison. Its image is within `theta s` of a grid interval on
the partner chain, still full and within that comparison. The overlap
has at least `s-theta s-2` positions; the displayed choice of `kappa`
is more than sufficient to match it. Consequently every unexcluded,
unmatched occurrence has all of its positions unpaired.

Let `B` be the number of underlying blocks, `S=sum_i m_i` the number
of full-block occurrences, `b_*` the unmatched occurrences, and `F`
the number of path positions in fragments. The actual construction gives

```text
F <= JM(s+1),                 S <= H/(s-1),
sS >= H-JM(s+1)-H/(s-1),
sb_* <= b_0+H/(s-1)+sQ.                         (1)
```

The last line follows from `(s-1)(b_*-Q)<=b_0` and
`b_*<=S<=H/(s-1)`. These are occurrence budgets: a fragment or block
traversed repeatedly is counted repeatedly here.

### Proof: link words and projections, not independent traversals

Forget occurrence indices to obtain a multigraph on underlying blocks.
Include isolated blocks. In a component `U`, write
`S_U=sum_{i in U}m_i`, `z_U=max_{i in U}m_i`, and let `b_U`
be its unmatched occurrences.

A spanning tree, rooted at a prescribed word, determines all but at
most `kappa s+1` letters of each next word. Thus the number of
extensions is at most
`t^((kappa s+1)(|U|-1))`.

A translation self-link has nonzero integer step: zero step would
compare the same underlying edge. Its equality graph on word positions
is a forest, a subgraph of paths in residue classes modulo the step.
Its at least `(1-kappa)s` distinct equality edges leave at most
`kappa s+1` components. There are therefore at most
`t^(kappa s+1)` choices for that word.

A reflection self-link has no reduced solution. Its compared interval
and reflected interval each exceed half the block and have a nonempty,
reflection-invariant interval of intersection. The center is either a
fixed letter, forcing it to equal its inverse, or two adjacent inverse
letters. Both are excluded. This argument uses linear block coordinates;
there is no cyclic-word exception inside a block. Combining a self-link
word count with tree propagation costs at most
`t^((kappa s+1)|U|)`.

If there is no self-link, mate the occurrences of a maximum-multiplicity
block with occurrences of other blocks. This is injective, so
`z_U-b_U<=S_U-z_U`, or `2z_U<=S_U+b_U`. The Lean occurrence
lemma proves this for all finite partial matchings, not only the fixtures.

For a reduced block word put `d_i=floor(-log P(W_i))`. The word-mass
hypothesis and `h_i>=s-1` imply

```text
tau s-c <= d_i <= As,
# {W of length h_i in bin d_i} <= exp(2d_i-2tau s+2c).       (2)
```

Indeed, `P(W)^2<=K exp(-2tau(h_i-1))` proves the lower bin
bound, allowing one unit for the floor. Every word in the bin has
`P(W)>exp(-d_i-1)`; multiplying the word-mass bound by
`exp(2d_i+2)` proves the cardinality bound. The definition of `c`
absorbs both the length rounding and the floor.

Let `Z_j` count **restrictions of extendable full string assignments**
to the image subgraph of edges with multiplicity at least `j`, and their
injective realizations. A link component is represented exactly when
`z_U>=j`. For a component without self-links choose a block with the
minimum bin, even if it is absent at that stage. Count all full
assignments from that root and project; projection cannot increase
cardinality. Thus the stage label count is at most

```text
exp( [J(s+1)+(kappa s+1)B] log t
     + sum_{U without self-link, z_U>=j}
           (2d_min(U)-2tau s+2c) ).                         (3)
```

The first term includes all fragments and tree propagation. Constraints
at junctions or between components have only been dropped, so this is an
upper bound. Counting arbitrary independent strings on the stage instead
would be wrong; the absent minimum-bin block remains a constraint through
extendability. The asymmetric-multiplicity fixture explicitly exercises
this projection.

### Proof: fixed-stage expectation uses distinct edges only

Let `Q_j<=J` be the active chains. Their unmarked internal vertices
number exactly `E_j-Q_j`. Choose images for these vertices using the
turn count, for unfixed marked vertices using at most `n` choices, and
for a prescribed root using one choice. Before enforcing injectivity,
this gives

```text
n^(V_j-k_j) p^(E_j-Q_j)
  product_{internal chain turns} w(a,b) exp(H eta_n).
```

Retain only injective and type-compatible assignments. Such an assignment
asks for `E_j` distinct prescriptions, **not** for all repeated path
traversals. The edge-prescription hypothesis bounds its probability by
`(np)^(-E_j) exp(e_n)`. Cancelling powers leaves, after discarding
turn factors outside full blocks,

```text
n^(V_j-E_j-k_j)
 exp( J log(1/p)+H eta_n+e_n - sum_{i:m_i>=j} d_i ).         (4)
```

Every factor discarded is at most one. A fixed root is marked, so no
turn-frequency factor was assigned to it incorrectly. This derives the
fixed-stage formula from the actual image graph.

Multiply (3) and (4) to define `B_j`. Markov's inequality gives
`E Z_j<=B_j` and a full realization has probability at most every
`B_j`. These statements do not compare random variables from different
stages probabilistically.

### Proof: explicit stage product and uniform parameter order

The powers of `n` in the product cancel or decrease, by the already
derived incidence inequality. For a component without self-links put
`S=S_U`, `z=z_U`, `b=b_U`, and `d=d_min(U)`.
Its total bin contribution is at most

```text
z(2d-2tau s+2c)-Sd
 <= -tau sS+(A-tau)sb+c(S+b).                              (5)
```

Here is an exact two-case proof. Set
`D_0=d-tau s+c` and `B_0=(A-tau)s+c`, so
`0<=D_0<=B_0`. The difference between the right side and the
left side is `B_0 b-(2z-S)D_0`. If `2z-S<=0`, both terms
are nonnegative. Otherwise it equals
`B_0(b-(2z-S))+(2z-S)(B_0-D_0)`, again nonnegative.
This universal real inequality is also proved in Lean. In the actual
sum, `sum m_i d_i>=S d`, so replacing it by `S d` was in the
correct direction.

A self-link component has no positive bin term, and contributes at most
`-tau sS+cS`. Sum (5) over components, use `sum b_U=b_*<=S`,
and then use (1). The resulting bound is exactly the theorem's `D`:
the two rounding terms involving `H/(s-1)` combine to
`(A+2c)H/(s-1)`. This establishes the finite estimate.

For fixed `K_0,C,I`, the displayed grid has `s->infinity`,
`s=o(L)` and `kappa->0`, uniformly over patterns. Every term of
`D/L` therefore tends to zero; its multipliers `J,M,d,C` are now
fixed. Set `gamma=tau-(A-tau)epsilon>0`. For all sufficiently
large `n`, the product is at most `exp(-gamma H/2)`. Some
stage has `B_j<=exp(-gamma H/(2M))`.

There are polynomially many unlabelled patterns: bounded chain graphs,
boundedly many oriented chain traversal sequences, and integer chain
lengths and comparison endpoints in `[0,CL]`. Fixing a grid is
deterministic. There are at most `(floor(As)+1)^B` bin choices;
their logarithm is at most `H log(As+1)/(s-1)=o(L)`, uniformly.
Hence the union bound is
`exp(-gamma L/(2M)+o(L)) -> 0`.

For clarity, a crude two-side unlabelled-pattern bound is
`F_0(CL+1)^(J+4I)`, where one may take

```text
F_0 = 2(J+1)(2J+1) 2^(2J) (2J)^(2J+JM)
      (JM+1)^(K_0+1) (K_0+1)^2 (I+1)(2K_0^2)^I.
```

This overcounts labelled chain endpoints, side choices, all traversal
words of length at most `JM`, cuts into paths, interval/root
designation, and four endpoints and reversal for each comparison.
Extra choices only increase the bound. Thus its exponent depends on
the fixed bounds but not on `L`. The finite number of root choices
can equally be absorbed in `F_0`.

This proves the universal theorem, including the actual path-system
bridge and the required order of quantifiers.

## Exact instantiation of the manuscript's weights

Let `v=16513`, `p=129/16513`. Partition **letters**, not outgoing
slots, into `X` (the seven ordinary letters paired with extras),
`O` (the other `v-7` ordinary letters), and `E` (the seven extras).
For the squared-weight matrix the exact row-sum quotient, in order
`(X,O,E)` for both rows and columns, is

```text
Q = [ 7p^2             (v-7)p^2          3/2   ]
    [ 7/129^2         (v-8)/129^2       7p^2  ]
    [ 6/129^2         (v-7)/129^2       7p^2  ].
```

The positive vector is `f=(4,1,1)`. The middle row gives

```text
lambda = 16533/16641 + 7p^2
       = 71589573988/72026254783 < 1,
```

and the other two row ratios are at most this. This covers every
allowed choice of the ordinary inverse pairing. It proves
`sum P(W)^2 <= 4t lambda^(h-1)` for every `h>=1`, by
nonnegative-matrix induction and `1<=f<=4`.

Since `lambda=1-2tau` with
`tau=436680795/144052509566`, the elementary inequality
`1-x<=exp(-x)` gives the word-mass hypothesis with `K=4t`,
`t=16520`. Use `A=5`: every positive weight is at least
`1/129>exp(-5)`, and `verify.py` proves `exp(5)>129` from
a rational partial exponential sum. Also
`log(4t)<17` and `tau<1/4`, so `c=11` safely satisfies the
bin-error condition.

An explicit strengthened choice is

```text
epsilon = tau/(2(A-tau))
        = 87336159/287930346814.
```

It gives `gamma=tau/2`, with no dependence on `K_0,C,I`.
This is an exact positive rational, not a decimal fitted to finite data.

The two stochastic hypotheses correspond respectively to
`random.tex`, `eq:turn-count`, and `lem:prescriptions`. Their source
errors `O(1/n)` and `O(L(CL+r_n)/n)=o(L)` have exactly the
uniformity required above. This identifies the dependency; their full
independent verification is outside this bounded-path mission.

## Reproducible evidence and limitations

Run `python3 research/bounded-path-core/verify.py`. It reconstructs
actual finite graph paths, chain decompositions, affine subcomparisons,
full-block occurrences and links before checking the budgets. It also
replays the rational quotient, its characteristic polynomial, certified
word bins, and the parameter identities in `exact_certificate.json`.
Its graph fixtures include a translation self-link with only two
unpaired positions, inverse comparisons, a fractional grid, an absent
minimum-bin block, positive individual stage exponent, and the sharp
root-endpoint correction. Deliberately inadmissible comparisons are
rejected. These are regression checks, not the proof of the universal
quantifiers, which is given above.

The exact Jacobian operation was
`matrix.characteristic_polynomial.compute` on the actual three-class
quotient. Its inspected contract, payload, and typed output are the
dedicated `jacobian_*.json` files. The server reported version `0.14.0`,
protocol `2025-11-25`, and completed normally. The polynomial is replayed
without Jacobian in `verify.py`; no spectral-radius conclusion is
inferred merely from a characteristic polynomial or a timeout.

`Main.lean` and `statement_fidelity.md` delimit the formal part.
The authorized verifier compiled the current source with Lean 4.31.0,
exit code zero and no proof holes, recording the immutable certificate
beside it. The analytic path-to-probability proof still requires
independent Reviewer reading. No Reviewer approval, literature novelty
verdict, or campaign completion is asserted here.
