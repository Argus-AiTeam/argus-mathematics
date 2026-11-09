# Distributional alignment: partial formal certification

## Statement being audited

The source is `sections/alignment.tex`, `lem:alignment`, in the staged
September 24, 2026 manuscript. Its quantifier order is

\[
 \forall s,d\geq1\ \forall\eta>0\ \exists r\geq s\
 \exists\mu\in\mathbb Q_{\geq0}^{\binom{[r]}s}\
 \forall M_*\ \forall(A_I):\quad
 \Pr_{B\sim\mu}[\text{an alignment on }B\text{ exists}]\geq1-\eta.
\]

Here the probabilities sum to one; each list has at most \(d\) elements;
and lists on \(I,J\) are disjoint whenever \(\max I<\min J\).
An alignment is a map \(a:M_*\to B\) with \(a(A_I)\subseteq I\) for
every nonempty \(I\subseteq B\). The distribution is not allowed to depend
on the lists or the label universe. A counterexample to one proposed
distribution is not a counterexample to this assertion.

## Source-grounded dependency decomposition

The following are distinct obligations of `sections/alignment-proof.tex`.

1. **Finite patterns.** List lengths and equality of occupied slots suffice
   to determine separation and badness. For fixed \(r,s,d\) there are
   finitely many patterns, independently of \(M_*\).
2. **Finite minimax.** Failure of a real-valued universal sampler at a
   fixed tolerance \(\xi>0\), for every \(r\), gives random allowed
   patterns \(C_r\) for which every \(s\)-set has badness probability at
   least \(\xi\).
3. **Homogenization and extension.** Finite Ramsey theory, compactness of
   finite probability simplices, and a countable consistent extension
   produce an order-invariant law on rationally indexed patterns with
   the same positive badness lower bound.
4. **Invariant cut.** In an order-invariant separated pattern, every
   equivalence class of occupied slots almost surely has a common index.
5. **Rationalization.** A strict tolerance margin allows replacement of a
   real sampler by a rational sampler, uniformly over all patterns.

The manuscript explicitly invokes finite zero-sum minimax
(`vonNeumann1928`) in item 2 and the finite multicolor Ramsey theorem
(`Ramsey1930`) in item 3. Trotter--Winkler is motivational rather than an
additional implication used in the displayed argument. Austin's theorem
and Label Cover hardness are not dependencies of this lemma.

The countable extension and compactness steps are also substantive
dependencies; they must not be hidden in a formalization's hypotheses.
No prior campaign evidence for these obligations was present in the
claim ledger at the start of this mission. The inherited Wiki index has
no entry matching alignment, finite minimax, Ramsey, or coloring.

## Invariant-cut argument, with the null events made explicit

Fix a slot at a finite nonempty rational set \(I\), and let \(E\) be its
occupancy event. For its equivalence class \(L\), put
\[
 p_L=\sup\{\min J:L\text{ has an occurrence at }J\}.
\]
The defining set is nonempty on \(E\), since it contains \(\min I\).
For every occurrence \(J\), separation with \(I\) gives
\(\min J\leq\max I\). Consequently
\(\min I\leq p_L\leq\max I\).

For a fixed increasing rational automorphism fixing \(I\), equivariance
of the supremum and invariance of the array law imply invariance of the
finite Borel measure
\(\nu(U)=\Pr(E\ \text{and}\ p_L\in U)\). This does not condition on an
event of probability zero.

In a gap \((a,b)\) between consecutive elements of \(I\), every pair of
rationals \(a<q<q'<b\) is related by a rational piecewise-linear
automorphism fixing \(I\). Thus the two half-lines ending at \(q,q'\)
have equal measure, and \(\nu((q,q'])=0\). Such rational intervals
countably cover the gap. It follows that \(\nu((a,b))=0\), and hence
\(\Pr(E,\ p_L\notin I)=0\).

There are countably many possible slots. Intersecting their
probability-one events therefore gives one probability-one event on
which \(p_L\) belongs to every occurrence set of every class \(L\).
Equivalent slots use the same supremum, not independently chosen cuts.
On this event no finite rational set is bad.

This is an ordinary mathematical argument, not yet a Lean certificate
of the full alignment theorem. In particular, proving the last paragraph
alone does not formalize minimax, homogeneous extraction, countable
extension, or existence of a finite rational sampler.

## Certification boundary

No false literal manuscript assertion has been established here.
Accordingly no `F_` refutation claim is warranted merely by an
unsuccessful candidate sampler. Full all-parameter formal certification
remains an obligation until an actual compiler-checked proof of the
stated quantifiers is present.

Four real Lean 4.31.0 runs, each with `exit_code=0`, axiom-audit exit
zero, and `proof_holes=[]`, now certify the following precisely scoped
results. Each source has its own unchanged statement-fidelity document
and an archived claim-bound native certificate.

| Claim | Formal result | Native certificate |
|---|---|---|
| `A_PATTERNS` | Finite-universe relabeling preserving list sizes, used-label equalities, disjointness, and alignment under arbitrary restrictions | `finite-patterns/certificates/A_PATTERNS-9bfdf2b7e5ac3c2a.json` |
| `A_MINIMAX` | The finite-game randomized-adversary implication, with the correct player/quantifier orientation, proved from Sion | `minimax/certificates/A_MINIMAX-c6e843341f51bdea.json` |
| `A_RATIONALIZATION` | A single rational law preserves the expectation bound uniformly over every test function in `[0,1]` | `rationalization/certificates/A_RATIONALIZATION-ae5105e7e73b159e.json` |
| `A_THREE_UPPER` | A universe-independent explicit rational sampler and failure bound for `s=3` | `certificates/A_THREE_UPPER-ad4b0bcf2d676633.json` |

This improves the starting state, which had no mathematical certificates,
to three general-purpose formal ingredients plus the complete three-layer
upper theorem. It does **not** close the all-parameter alignment theorem.
In particular, the finite-universe result does not construct the
canonical coherent restriction maps needed by the projective-law
extraction; those remain part of `A_HOMOGENIZATION`.

## A sharp quantitative result for three layers

For \(r\geq3\) and \(d\geq1\), let \(v_{r,d}\) be the infimum, over all
laws on triples, of the largest failure probability among admissible
size-\(d\) list families. Then
\[
                 v_{r,d}=\min\{1,d/(r-2)\}.                 \tag{1}
\]
The upper bound is attained by the rational law uniformly choosing
\(\{1,j,r\}\), \(1<j<r\). Thus the sampling law in this special case is
explicit and independent of the label universe. This gives a
quantitative three-layer refinement of the manuscript's qualitative
existence statement; no novelty or publishability claim is made for it.

Here is the upper-bound argument, formalized in `Main.lean`. If the
triple \(l<t<h\) is bad, some label \(x\) has no common index there.
Occurrences avoiding \(h\) and \(l\) lie, respectively, in
\(\{l,t\}\) and \(\{t,h\}\). An occurrence avoiding \(t\) must equal
\(\{l,h\}\): a singleton \(l\) would be separated from the right
occurrence, and a singleton \(h\) from the left occurrence.
Consequently \(x\in A_{\{l,h\}}\). If the same \(x\) witnessed badness
at \(t<t'\), its left occurrence at \(t\) and right occurrence at
\(t'\) would be separated. Therefore different bad middle indices
require different labels on \(A_{\{l,h\}}\), and there are at most
\(d\) of them.

For the lower bound, use labels \(x_j\), put \(A_{\{j\}}=\{x_j\}\),
and for each pair \(i<k\) choose a set
\(S_{ik}\subseteq\{i+1,\ldots,k-1\}\) of size
\(\min(d,k-i-1)\). Put
\(A_{\{i,k\}}=\{x_j:j\in S_{ik}\}\) and make all longer lists empty.
All occurrences of \(x_j\) have convex hull containing \(j\), so
separation holds. A triple \(i<j<k\) is bad exactly when \(j\in S_{ik}\).
Choose each \(S_{ik}\) uniformly among subsets of its prescribed size.
Then every triple is bad with probability
\(\min(1,d/(k-i-1))\geq\min(1,d/(r-2))\). Averaging over this finite
random family proves the lower bound against every proposed sampler,
with the law fixed before the adversarial list family. This proves
(1) in ordinary mathematics. Its lower-bound half is not covered by
the Lean upper-bound certificate.

For \(r=5,d=1\), the lower-bound families number exactly twelve.
`verify.py` constructs their payoff matrix and independently checks
rational primal and dual laws of value \(1/3\) with exact `Fraction`
arithmetic. The finite matrix is not being used as a proof for
arbitrary \(r,d\).

## An exact exclusion of uniform sampling for four layers

This excludes a candidate proof route, **not a manuscript assertion**.
For \(r\geq4\), split the indices into consecutive parts of sizes
\(a=\lfloor r/2\rfloor\) and \(b=\lceil r/2\rceil\).
Put a single label \(x\) on every pair crossing the cut and on no
other list. Separation holds because the convex hull of every
occurrence crosses that same cut.

A four-set is bad precisely when it contains two indices in each
part. In that case the four crossing pairs have empty total
intersection. If the split is \(1+3\), all occurrences contain the
unique index in the smaller part; if it is \(0+4\), there is no
occurrence. Hence uniform sampling has failure probability
\[
 \frac{\binom a2\binom b2}{\binom r4}\ \geq\ \frac38.
\]
Writing \(r=2m\) or \(r=2m+1\), \(m\geq2\), the difference from \(3/8\)
is respectively
\[
 \frac{12m-9}{8(2m-1)(2m-3)},\qquad
 \frac{12m+3}{8(2m+1)(2m-1)}.
\]
`verify.py` checks these polynomial identities exactly and substitutes
\(m=n+2\), obtaining strictly positive constant terms and nonnegative
coefficients in numerator and denominator. Thus the bound holds for
**all** \(r\geq4\), not merely the explicitly enumerated examples.
The uniform-sampling route is retired in the claim ledger; the
source's nonuniform minimax/Ramsey route remains open.

## Source access and unresolved obligations

The original DOI endpoints for von Neumann (1928) and Ramsey (1930)
returned HTTP 406 and 403 respectively. The alternate GDZ page
returned navigation without the mathematical text; the suggested
Ramsey PDF returned 404 and the Internet Archive endpoint could not
be retrieved. These are source-access limitations, not refutations.
Search-generated theorem numbers or paraphrases were not treated as
passages read from the papers. The minimax assumption has since been
retired with an explicit reason: its finite-game implication was proved
in Lean using the installed Mathlib Sion theorem. Ramsey,
finite-simplex compactness, and countable extension remain explicitly
uncited assumptions of the unresolved homogenization claim.

The installed Lean compiler is 4.31.0. The advertised Lake workspace
exists, with Mathlib under `.lake/packages/mathlib` rather than directly
under its root. The local primary source
`Mathlib/Topology/Sion.lean` contains Sion's general saddle-point theorem
and lists the finite bilinear case as a specialization to be spelled
out. `minimax/Main.lean` now supplies that application with the precise
strict-threshold implication needed here. No all-parameter
homogenization or countable-pattern construction has been formalized
in this mission.

The Jacobian adapter was discovered and its exact typed LP contract
was preserved, including server version `0.14.0` and protocol
`2025-11-25`. The full finite game was rejected first by the normalized
variable admission bound, then by the possible-simplex-bases bound.
A separately identified pinned-endpoint projection with duplicate
rows removed was also rejected by admission before any solve. The
exact payloads and structured `INVALID_REQUEST` outputs are retained
in the dedicated `jacobian-lp*.json` files. These are **non-conclusions**,
not numerical evidence. There was no timeout and no optimality result.
The value \(1/3\) is established independently by the explicit exact
primal/dual laws, not inferred from these adapter errors.

`verify.py` also exhausts all 4,140 partial equality partitions of the
seven possible one-slot lists on three points. Exactly 1,799 satisfy
separation and 287 are bad. For every allowed pattern it compares
direct enumeration of maps with the common-intersection criterion and
the formalized three-point witness characterization. This is a finite
experiment, not the proof of the arbitrary-universe upper theorem.
The script separately checks all four native source/fidelity hashes
against the actual compiler records and archived theorem texts.

The exact artifacts here therefore certify restricted results and
exclude a tempting candidate law. They do not meet the mission's
acceptance condition for `A_ALIGNMENT`, do not refute it, and do not
terminate the publishable campaign. Independent Reviewer replay is
still required, and the general-\(s\) frontier remains active.

The remaining formal obligations are (a) canonical finite-pattern
restriction, Ramsey homogenization, diagonal limits, and countable
extension; (b) the full random-pattern invariant-cut theorem; and
(c) an integrated proof producing `r` and the rational sampling law
for every `s,d,eta` before the arbitrary label universe and lists.
No theorem in these files may be relabeled as that missing proof.

Replaying the exact certificate uses only the Python standard library:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/alignment-audit/verify.py
```

Independent compiler replay should use `lean_evidence verify` with each
source's adjacent fidelity document and its tabled claim identifier.
All native evidence is within this campaign directory; no shared-batch
root check is being substituted for a campaign-local check.
