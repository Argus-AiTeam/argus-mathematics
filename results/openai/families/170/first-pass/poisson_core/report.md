# Dimension-three Poisson core

## Scope and known status

The target is the uniform conditional estimate in `learn:high-moment` of
*Sharp Logarithmic Exponents for Fixed Off-Diagonal Ramsey Numbers*
(OpenAI, September 24, 2026), compared with `eq:ambient-high-moment` in
`predictor-score.tex` of the companion *r(5,t)* manuscript.
For every admissible prepared input and fixed own-cell schedules, the proposed
estimate is

\[
  \mathbb E[(T_x^\star)^p\mid\mathcal O_x]
  \leq B^p\exp(-pP/10).
\]

The supplied prior status is **untested**, not verified, for both this estimate
and the manuscripts' claimed logarithmic exponent \(s-2+\varepsilon\).
Context replacement, entropy, decoding, and iteration are separate unresolved
dependencies; verifying a moment calculation would not establish them.
No prior exact certificate or independent review is present in the initial
campaign ledger.

An eventual counterexample must respect the actual preparation and schedule
hypotheses. A small-field anomaly, an unrealizable incidence pattern, or a
bounded unsuccessful search cannot settle the sufficiently-large-prime claim.
The calculation starts with exact mixed Poisson moments, allowing repeated
hyperplanes; component attenuation and certificate enumeration come afterwards.

No external mathematical theorem is currently assumed for this investigation.
The needed elementary Poisson generating-function identities will be derived
directly. The inherited Wiki index has no entry matching Poisson, Ramsey,
high moments, or prepared inputs. This is a local retrieval result, not a
literature novelty claim.

## Exact source and dependency boundary

The fixed-off-diagonal source is
`build/sections/03-learning.tex:366-372`; its conditional law is defined
at lines 307-316. The center is unsampled and all point-batch counts in
the own cell, excluding the center, are fixed at values of positive
probability. Remaining line-batch counts are independent Poisson
variables. The own-cell factors are deterministic elements of \(\{0,1\}\).

The input includes \(j=3\), \(n'\in[n/2,n]\),
\(B=q^3/n'\), \(f_x\le .04\), and typical pencil masses
\(.75\le\lambda'_H<2\), deviations
\(\delta'_H=\lambda'_H-(1-f_x)\) with \(|\delta'_H|\le .18\).
Regularity supplies \(\sum_H(\delta'_H)^2\le CBe^{L/100}\).
The dyadic overlap bounds are
\[
 E_a/B^2\le e^{P/50}a^{-200},\qquad
 \Delta_a/B\le e^{P/50}a^{-200},
\]
and the strong-degree bound is
\(\Delta_{1/(100p)}/B\le e^{-3P}\).
These are hypotheses of the learning section, not conclusions of this
audit about the preceding geometric preparation.

The main Ramsey lower-bound construction also needs preparation,
short-row implementation, marking, compression, decoding, and iteration.
The present mission isolates the conditional moment implication from
the stated prepared-input bounds. It does not assume the Ramsey theorem
or certify those other implications.

The companion source, `build/predictor-score.tex:303-328`, instead
states \(\mathbb E[T_x^p1_{\mathcal G_x}]\le B^pe^{-.1pP}\).
It allows an own-cell union of mass at most .08 and, in its high case,
uses a radial hit truncation \(\mathcal G_x\). Its internal mass lower
bound is again .74, with centering \(b_0\le e^{-.92L}\).
Its external-schedule conditioning, repeated-singleton treatment,
dictionary of charged events, and root encoding have the same purposes.
No independence conditional on \(\mathcal G_x\) is asserted.
The fixed-off-diagonal claim is untruncated and has the smaller own cell.

## Jacobian scope

The installed sidecar advertises version 0.14.0, protocol 2025-11-25.
The inspected rational generating-function operation accepts only a
bounded rational Taylor series; the finite-distribution moment operation
accepts at most 256 rational atoms; the finite-field rank operation
computes a direction-bound linear-map rank. None proves an arbitrary-order
Poisson mixed-moment identity or the static enumeration theorem.
Custom exact algebra is therefore needed for those universal statements.

One genuinely matching bounded operation is used for an independent
arithmetic check, not as evidence of the full estimate:
`probability.finite_distribution.raw_moment.compute`.
Take independent Poisson counts on three disjoint radial cells with
mean \(\log 2\), let \(H_1\) use the first two cells and \(H_2\) the
last two, and center both emptiness indicators at \(1/4\).
The repeated mixed product
\((I_{H_1}-1/4)^2(I_{H_2}-1/4)\) has the four rational atoms in
`jacobian-mixed-repeat-payload.json`. The adapter result is retained in
`jacobian-mixed-repeat-output.json`. This algebra check deliberately
does not purport to be an admissible counterexample to the manuscript.

## Exact mixed moments, with repetitions

Let \(\mathcal A\) be a finite atom set, let \(a_\ell\ge0\), and let
independent counts \(N_\ell\) have Poisson means \(La_\ell\).
For a block \(H\subseteq\mathcal A\), write \(I_H=1_{\{N_\ell=0\
(\ell\in H)\}}\). Directly from the Poisson probability at zero,
\[
 \mathbb E\prod_{i\in A}I_{H_i}
 =\exp\left(-L\sum_{\ell\in\bigcup_{i\in A}H_i}a_\ell\right).
\]
The union is ordinary union. The index set \(A\) is a subset of
**positions**, even when some \(H_i\)'s agree. Expanding the centered
product therefore gives, for every ordered list,
\[
 M(H_1,\ldots,H_k)=
 \sum_{A\subseteq[k]}(-b)^{k-|A|}
 \exp\left(-L\sum_{\ell\in\bigcup_{i\in A}H_i}a_\ell\right).       \tag{1}
\]
In particular, if \(z=\exp(-L\lambda_H)\),
\[
 M(\underbrace{H,\ldots,H}_{k})
 =(1-z)(-b)^k+z(1-b)^k.                                      \tag{2}
\]
For two distinct blocks with overlap mass \(\theta\), (1) gives
\[
 M(H,H')=(e^{-L\lambda_H}-b)(e^{-L\lambda_{H'}}-b)
       +e^{-L(\lambda_H+\lambda_{H'})}(e^{L\theta}-1).          \tag{3}
\]
Independent batches multiply these one-batch moments. Fixed zero-one
gates multiply the result by a deterministic zero-one factor, even
for repeated blocks. This proves that the own-cell conditioning does
not introduce an extra distributional assumption.

`Main.lean` proves the union-indicator recursion underlying (1) for
arbitrary finite weighted hit laws and arbitrary lists, not just for
distinct blocks or a prescribed order. The Poisson identification of
the vacancy probabilities is the elementary calculation above.

## A quantitative linear-incidence extension

Here is a finite-parameter theorem, rather than a finite search.
It isolates the mechanism actually required by the manuscript.

**Theorem.** Let \(\mathcal H\) be a finite family of distinct subsets
of a finite atom set, with any two blocks intersecting in at most one
atom. Give atom \(\ell\) strength \(a_\ell\ge0\). Put
\(\lambda_H=\sum_{\ell\in H}a_\ell\),
\(\theta_{HH'}=\sum_{\ell\in H\cap H'}a_\ell\), and
\(\delta_H=\lambda_H-c\). Let \(C\ge1\), \(B\ge e^P\), \(P=LR\);
let \(p\ge2\) and \(R\ge1600\) be even integers. Suppose:

1. \(c\ge .74\), \(.75\le\lambda_H<2\), \(|\delta_H|\le .18\), and
   \(\sum_H\delta_H^2\le CBe^{L/100}\).
2. \(|\mathcal H|\le CB^2\), and each positive-strength atom belongs
   to at most \(CB\) blocks.
3. There is a finite collection of \(D\) dyadic intervals \([a,2a)\)
   covering all positive overlaps. At their lower endpoints,
   \(E_a/B^2,\Delta_a/B\le e^{P/50}a^{-200}\).
   Also \(\Delta_{1/(100p)}/B\le e^{-3P}\).
4. \(L\ge100\) and \(L\ge100\log(4L)\).
   With \(d=\lfloor R/800\rfloor\),
   \[
    p\,\frac{d+19}{20}\left(\frac{19}{20}\right)^{d-1}<\frac12. \tag{4}
   \]

Set \(A=10^6(C+p+R+P+D+1)\), and let \(g_{H,r}\in\{0,1\}\)
be arbitrary deterministic gates. For independent Poisson
\(N_{\ell,r}\) of means \(La_\ell\), set
\[
 Y_H=\prod_{r=1}^R g_{H,r}
       \left(1_{\{N_{\ell,r}=0\ (\ell\in H)\}}-e^{-Lc}\right),
 \qquad T=\sum_HY_H.
\]
Then
\[
 \mathbb E T^p\le
 B^p A^{1000p}e^{-17pP/50}.                                 \tag{5}
\]
In particular, if \(P\ge10000\log A\), then
\(\mathbb E T^p\le B^pe^{-pP/10}\).

The theorem does not require representability over a field. In a
linear set system, two distinct atoms lie in at most one block:
otherwise those two blocks would have intersection size at least two.
This is the only reconstruction uniqueness used below. Zero-strength
atoms can be deleted.

### Proof: conditional attenuation

Expand into ordered \(p\)-tuples, retaining repetitions. On distinct
blocks, use the graph of overlaps \(>t=1/(100p)\).
A singleton occurring once is simple; every other component is nonsimple.
An atom is external if it belongs to different components. In each
tuple block, total external strength is at most \(pt=.01\): assign
each such atom to one other component's block containing it and use
the cross-component overlap bound.

Fix all external schedules. Remaining atom schedules of different
components are independent. A block has internal mass at least .74.
If externally untouched, its expected absolute centered factor is at
most \(2e^{-.74L}\); if touched, its factor is \(-e^{-Lc}\), of no
larger magnitude. All factors have magnitude at most one. For a
nonsimple component, keeping one block's factors therefore bounds
its expected absolute product by
\[
 (2e^{-.74L})^R\le e^{-.7P}.                                \tag{6}
\]
This remains true for a repeated singleton: idempotence of the
emptiness indicator does not imply independence of its copies.

For a simple block let \(s=p\theta_{\max}\le .01\), taking
\(\theta_{\max}\) only over other distinct blocks of the tuple.
In an untouched batch its signed mean has absolute value at most
\(Le^{-.74L}(|\delta_H|+s)\), by the mean value theorem.
In any batch its absolute mean is at most \(2e^{-.74L}\).
Let \(\mathcal B_H\) mean at least \(R/2\) touched batches.
Outside \(\mathcal B_H\), retain \(R/2\) sharper factors and use
\((u+v)^{R/2}\le2^{R/2-1}(u^{R/2}+v^{R/2})\).
The condition on \(L\) absorbs both this factor and the powers of \(L\);
since \(R/2\ge200\), this gives
\[
 e^{-.68P}
 \left(|\delta_H|^{R/2}+(p\theta_{\max})^{200}
                    +1_{\mathcal B_H}\right).              \tag{7}
\]
Gates cannot increase these bounds.

Apply (6)-(7) to valid tuples **before** any geometric enlargements.
Expand the three nonnegative terms in (7). Only probabilities of
simultaneous selected \(\mathcal B_H\)'s remain after integrating the
external schedules. Independence is not asserted after conditioning
on these events.

### Proof: distinct charges and the residual roots

Keep a dictionary of already introduced atoms. A new atom is charged
at a specified positive-hit batch, except that a pair operation
charges 200 distinct batches. Once an atom is in the dictionary,
later references to it impose no further hit condition.

For any encoded block, the sum of probability upper bounds for a new
atom and witnessing batch is
\[
 \sum_{\ell\in H}\sum_{r=1}^R La_\ell=P\lambda_H<2P.          \tag{8}
\]
For a dictionary of size \(m\), old references have total incremental
weight at most \(m\). Thus a new-or-old choice costs at most \(2P+m\).
The actual probabilities may be smaller than \(La_\ell\); no truncation
of that upper bound is needed.

First encode nonsimple components, and simple deviation choices.
Encode simple shift choices by naming a maximizing neighbor and a
dyad. If that neighbor is already encoded, use \(\Delta_a/B\);
otherwise encode the pair using \(E_a/B^2\), dropping the neighbor's
extra simple requirement, which is at most one.

For the remaining hit-event vertices, use the following operations.
An **anchor** encodes a block having a touched atom in an encoded
block. Pay (8) if new, or reference the dictionary; there are at most
\(CB\) possible incident blocks. If no anchor applies but two
unencoded blocks share hits in at least 200 distinct batches, use a
**pair**. Their unique shared atom is outside every encoded block,
hence outside the dictionary. Choose 200 distinct witnessing batches.
For overlap in \([a,2a)\), their total hit weight is at most
\((2Pa)^{200}\); multiplying \(E_a/B^2\) cancels \(a^{-200}\).
Repeat until neither operation applies.

Suppose \(h\) vertices remain. Each has at least \(R/2\) touched
batches, all witnessed on atoms shared with residual vertices.
A chosen neighbor occurs in at most 199 witnessing batches, or a
pair would apply. A chosen atom also occurs in at most 199: any
one other residual block containing it would give such a pair.
Greedily retaining a witness and deleting witnesses with its neighbor
or atom removes fewer than 400. Each vertex thus has at least
\(d=\lfloor R/800\rfloor\) witnesses with distinct neighbors **and**
distinct atoms. This step uses realized incidence, not a synthetic
graph substituting for incidence.

Select each residual vertex as a root independently with probability
\(1/20\). For any fixed list of \(d\) distinct neighbors, the
probability of fewer than two roots is exactly
\[
 (19/20)^d+(d/20)(19/20)^{d-1}
 =\frac{d+19}{20}(19/20)^{d-1}.
\]
By (4), the probability that any list fails is less than \(1/2\).
The probability of selecting more than \(h/10\) roots is at most
\(1/2\), by their mean \(h/20\). Hence there exists a root set of
size \(r\le h/10\) giving every nonroot two witnesses to roots.
If there are fewer than \(d+1\) residual vertices, the residual case
was impossible in the first place.

Encode root blocks freely, at normalized cost at most \(CB\) each.
Encode a nonroot using the two distinct witness atoms in its two
named root neighbors, at weighted choice cost at most \((2P+m)^2\).
Those atoms determine at most one block, whose normalization is \(1/B\).
Consequently the root group's geometric factor is
\[
 C^r B^{2r-h}\le C^h,\qquad 2r-h\le-4h/5.                   \tag{9}
\]
Every operation introduces at most 200 dictionary atoms per encoded
vertex, so throughout \(m\le200p\).

For each fixed valid tuple this constructs a static certificate from
every realization of its required events. A certificate retains only
its positive charged events. They are distinct external atom-batch
pairs, hence independent under the original fixed-gate law. Thus
\[
 1_{\cap_H\mathcal B_H}
 \le\sum_{\text{static }c}\prod_{(\ell,r)\in\mathcal L(c)}
                      1_{\{N_{\ell,r}>0\}},
\]
and integration bounds each product by \(\prod La_\ell\).
The sum covers all possible resulting descriptions, not an adaptively
chosen description treated as fixed. Discarding absence requirements
only enlarges it. Reuse never charges the same event again.

### Proof: weighted enumeration and explicit overhead

All counts below are normalized by \(B\) for each tuple position.
Dyads contribute at most \(D\); \(200p,2p,2P,C,2P+200p\le A\).

| Operation | Positions consumed | Weighted cost before attenuation |
|---|---:|---|
| Nonsimple initial strong pair | 2 | \(D e^{P/50}(200p)^{200}\) |
| Repeated-singleton initial pair | 2 | \(C\) |
| Further distinct tree vertex | 1 | \(e^{-3P}\) |
| Further repeated position | 1 | \(B^{-1}\le e^{-P}\) |
| Simple deviation | 1 | \(Ce^{L/100}\) |
| Shift to encoded neighbor or new pair | 1 or 2 | \(D e^{P/50}(2p)^{200}\) |
| Hit anchor | 1 | \(C(2P+200p)\) |
| Hit pair | 2 | \(D e^{P/50}(2P)^{200}\) |
| Residual root group | \(h\) | \(C^h(2P+200p)^{2h}\) |

For the first line choose the actual strong-pair dyad. Its lower
endpoint is greater than \(t/2\), giving the displayed bound; no
unavailable threshold estimate is being assumed.
For deviations, \(|\delta|^{R/2}\le\delta^2\).
The two-direction count in the last line keeps directions distinct
until uniqueness has been used. Only afterwards is its positive
weighted sum enlarged to the product of marginal sums; the corresponding
universal inequality is in `Main.lean`.

A nonsimple component of \(k\ge2\) positions therefore costs at most
\[
 A^{202k}\exp\{-[17/25+(k-2)]P\}
 \le A^{202k}e^{-17kP/50},                                  \tag{10}
\]
because the exponent margin is \(33(k-2)/50\).
For a simple operation consuming \(k=1\) or \(2\) positions,
the worst exponential cost in the table is \(e^{P/50}\);
combined with \(e^{-17kP/25}\) this is at most
\(e^{-33kP/50}\).
A deviation costs at most \(e^{P/100}\), and root groups retain
\(e^{-17hP/25}\); both are stronger. The algebraic factor of any
operation or group is at most \(A^{202k}\).

For clarity, the remaining combinatorial overhead does not encode the
full strong graph or all witnesses. Use restricted-growth labels for
equal positions and components (at most \(p^{2p}\) choices), parent
names and orders for component trees (at most \(p^{2p}\)), three
simple-term tags, operation tags, and an encoding order (at most
\(15^p p^p\)), root subsets (at most \(2^p\)), and at most two
neighbor names per vertex (at most \(p^{2p}\)). Dictionary references
are already counted by \(2P+m\); batch and dyad choices are already
counted in the table. These choices are bounded by
\((1000p)^{20p}\le A^{20p}\), with slack for empty groups and the
recorded orders. Atom geometry is counted only in the weighted sums,
never as a further unbounded label alphabet.

There are at most \(p\) encoding operations; their consumed positions
partition the \(p\) positions. Successive positive sums can be bounded
in encoding order by the table's uniform bounds after previously
encoded geometry has been fixed. This is valid for roots first and
nonroots later, too. Every block used for (8) retains its mass bound.
Other compatibility restrictions may now be discarded, after (6)-(7)
have been assigned to valid tuples. Multiplying (10) and the simple
bounds and summing the discrete descriptions gives
\[
 B^{-p}\mathbb E T^p
 \le A^{222p}e^{-17pP/50}
 \le A^{1000p}e^{-17pP/50}.
\]
Finally \(1000p\log A\le pP/10\), leaving exponent at most
\(-6pP/25\), which is stronger than \(-pP/10\). This proves (5).

## Application to the prepared projective input

At a fixed center, take atoms to be positive-strength radial lines
in \(X_x\), and blocks to be typical hyperplanes in its pencil.
Distinct planes through \(x\) share exactly one radial line; two
different radial lines determine exactly one plane. An atom lies in
at most \(q+1\) pencil planes. The total pencil size is \(Q_2\).
Indeed, quotienting the four-dimensional vector space by the line
representing \(x\) gives a three-dimensional space: radial lines
become its one-dimensional subspaces and pencil planes its
two-dimensional subspaces. The intersection and span assertions
follow from their dimensions. Counting nonzero vectors modulo
nonzero scalar multiples gives the stated \(Q_2\) and \(q+1\) counts.

For large \(q\), sparse incidence and the smaller-side orientation
give \(n'\le n\le2q^2\), hence \(B\ge q/2\),
\(Q_2\le8B^2\), and \(q+1\le4B\).
Also \(\log B\ge\sigma-\log2\), so \(B\ge e^P\) at the
stated scale \(P=o(\sigma)\).
This size bound follows directly from the stated mixing inequality:
\[
 (p_3-\tau/q)\sqrt{|S||T|}\le q,
 \quad
 p_3=(1-Q_3^{-1})/q,\quad
 |S|\le|T|.
\]
For \(Q_3^{-1}+\tau\le1/4\) this even gives
\(n\le4q^2/3<2q^2\). To derive the mixing inequality without an
external theorem, let \(M\) be the point-plane incidence matrix.
Each point lies in \(Q_2\) planes and two distinct points lie in
\(Q_1=q+1\), so
\(MM^{\mathsf T}=q^2I+Q_1J\). On vectors perpendicular to the
all-ones vector this has squared norm \(q^2\); Cauchy--Schwarz
on centered set indicators gives the displayed mixing inequality.
Thus no literature theorem is an unrecorded dependency here.

Take \(C\) larger than 8 and the regularity constant. The remaining
finite-theorem inputs are exactly `learn:typical-bounds`,
`learn:overlap-input`, `learn:strong-degree-input`, and
`learn:elementary-sizes`. Every positive overlap is at least \(q/n'\);
the source's dyads down to \(q^{-10}\) therefore cover it and have
\(D=O(\sigma)\).

For completeness, write \(\beta=\eta/10^7>0\). Uniformly over
\(\sigma^\beta\le D_{\rm budget}\le\sigma^{1-\eta/2}\),
\[
 L\ge\sigma^{9\beta},\quad
 R\ge\sigma^\beta,\quad
 \sigma^{10\beta}\le P\le4\sigma^{1-\eta/2+9\beta},\quad
 p\le10000\sigma/P+2.
\]
Thus \(\log A=O(\log\sigma)=o(P)\),
\(\log L=o(L)\), \(R\to\infty\), and
\(\log p=O(\log\sigma)=o(R)\).
With \(d\asymp R\), the logarithm of the left side of (4) is at most
\(\log p+\log(d+19)-\log20+(d-1)\log(19/20)\), which tends to
minus infinity uniformly. All finite numerical hypotheses follow.
The coefficient \(\eta/2-9\beta
=\eta(1/2-9/10^7)\) is positive, as needed for \(P=o(\sigma)\).

Fixing any allowed own-cell schedule leaves precisely the independent
atom-batch counts of the theorem, with deterministic gates and
\(c=1-f_x\ge .96\). All constants above are independent of those
schedule values and of the support. Consequently the theorem implies
the literal conditional bound `learn:high-moment`, with its stated
uniformity, **conditional on the prepared-input inequalities**.

## Evidence strength and remaining limits

This is a proposed universal verification theorem and a structural
extension to finite linear incidence systems. It is not a counterexample,
not a finite-field exhaustion, and not a proof of either Ramsey theorem.
No false literal manuscript assertion has been established here, so no
`F_...` refutation claim has been manufactured.

`verify.py` checks exact mixed-moment algebra, the independent Jacobian
arithmetic, and symbolic nonnegative-coefficient certificates for the
universal exponent accounting. Its finite examples are regression checks
only. `Main.lean` separately certifies the universal algebraic core
described in `statement_fidelity.md`; it does not certify the full
enumeration-to-moment implication. The full theorem above needs
independent mathematical review, particularly the completeness of the
static descriptions and the overhead count. Novelty and publishable
significance are not claimed verified by the Engineer.

The initial ledger had no certificate for this core. The improvement
over that prior state is an explicit finite-parameter implication for
all linear incidence systems, a fully written static counting proof,
and a separately checked universal algebraic formalization. It is
not merely a larger successful finite search.

Automated literature discovery suggested general concentration and
upper-tail references, but did not supply a reliably inspected primary
proposition matching this theorem. Its inconsistent alleged theorem
statements are not assumptions and are not cited as mathematical
support. No verified novelty claim follows from that search.

The authorized Lean 4.31.0 run completed with exit code zero and
`proof_holes=[]`. Its archived mechanical evidence belongs only to
`PC_FORMAL_CORE`. The exact Python replay also completed with exit
code zero. Independent statement-fidelity approval, full-theorem
review, significance, and novelty remain outstanding.

The failed attack at this scope was to treat reused direction hits as
fresh factors. The actual source expressly does not do that: dictionary
reuse adds an index choice of incremental weight one. Thus that attack
does not identify a false source assertion. It is not evidence that
the remaining geometric or compression dependencies are correct.

## Replay

From the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/poisson_core/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/poisson_core/Main.lean --statement-fidelity research/poisson_core/statement_fidelity.md --claim PC_FORMAL_CORE --project-root .
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root .
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root .
```

The Python replay reads the saved real compiler result and rejects a
changed source or fidelity document. The second command requests a new
real compilation; leave both formal files untouched while it runs.
The Reviewer must additionally read the analytic proof: replaying the
algebra alone is not approval of (5).
