# Disjoint resampling on fixed-degree simple graphs

**Outcome.** The original ordered disjoint sum is positive semidefinite for
every graphical degree vector. The complete graph-specific proof has passed
Lean 4.31.0 with compiler and axiom-audit exit codes zero, no proof holes,
and only `propext`, `Classical.choice`, and `Quot.sound` in the requested
transitive axiom lists. The ledger derives `C_DISJOINT_CORE` as
`closed_kernel`, with no undischarged assumptions. Independent statement
fidelity and Reviewer acceptance remain outstanding.

The report also proves that the coefficient \(1\) in the manuscript's
local error bound cannot be decreased uniformly, by an explicit
unbounded graphical family. No manuscript refutation or verified novelty
is claimed.

## Statement and source scope

The target is the ordered sum

\[
D=\sum_{a,b\in\binom V2,\ a\cap b=\varnothing}(I-E_a)(I-E_b)
\]

on the **entire** nonempty set of labeled simple graphs of degree vector
\(d\), with uniform probability measure. Here \(E_a\) is exactly the
pair-fiber conditional expectation in the staged `setup.tex`: fix the graph
away from \(a\), its internal edge, and every outside vertex's number of
neighbors in \(a\). No host restriction or extra conditioning is introduced.
An individual disjoint interaction may be negative; the assertion concerns
the sum of both orders over all disjoint pairs.

The staged `disjoint.tex`, Proposition `dis:interaction`, reduces the problem
to a local interaction inequality. The staged `slice.tex`, Lemma
`sl:comparison` and Corollaries `sl:global` and `dis:nonnegative`, supply
the slice budget and its ordered-sum assembly. The cell encoding explicitly
allows the two outside singleton sets to overlap. The absent-center and
zero-projection cases are part of the stated result, not additional
nondegeneracy assumptions.

## Settled external source findings

1. Fu, Qin, and Wang, *Spectral Gap for the Binary Fixed-Margin Swap Chain*,
   arXiv:2606.22636v2, Theorem 5.1, is the cited three-row input in the
   surrounding mixing argument. The mission brief reports that its primary
   statement was inspected. That fact is not an independent citation check
   by this Engineer, and the disjoint theorem does not depend on it.
2. The primary repository `openai/math`, commit
   `4eaee87548250b2682affda7d05d947c05554bae`, contains an actual solution
   at `lean/OAI/Probability/SwitchChain/Main.lean`. Its scope document
   `lean/docs/131.md` covers the switch-chain estimates, not the exact
   sampler. Comparator challenge placeholders are not manuscript errors.
3. Source-closure inspection is recorded in `upstream/AUDIT.txt`.
   It found actual graph-cell, interaction, and slice-budget proofs in
   165 transitive OAI modules, with no explicit project-source axioms or
   proof placeholders. This is **not** a compiler or transitive kernel
   axiom verdict. Mathlib remains an external source-inspection boundary.
4. The upstream source pins Lean **4.34.1**. The assigned host has Lean
   **4.31.0**. Upstream build configuration invokes Git and is not run.
   A source snapshot, a successful newer-version build, or the absence of
   suspicious source tokens would not by itself certify this mission.
5. A focused literature lookup for an explicit sharp equality-frame
   comparison on the Johnson slice returned no verifiable primary source
   containing the specialized formulas. This is an inconclusive novelty
   lookup, not evidence that the formulas are new.

No false manuscript assertion has been established by these findings.
In particular, dependence or a negative single interaction does not refute
the ordered-sum claim.

## Universal verification argument

The following argument is for arbitrary numbers of vertices, not a
conclusion extrapolated from the finite probes.

### 1. The graph-to-cell reduction

Write \(a=\{i,j\}\), \(b=\{k,l\}\), and \(O=V\setminus(a\cup b)\).
Fix the graph on \(O\), the two internal edges \(ij,kl\), and the two
neighbor counts of each \(w\in O\), separately into \(a\) and into \(b\).
These data are preserved by both complete pair fibers. Let \(A,B\subset O\)
be the two sets of count-one vertices. A graph in the resulting cell is
specified uniquely by its binary cross matrix \(M\), and by subsets
\(U\subset A\), \(W\subset B\) assigned to \(i,k\).

Let \(r,c\) be the first row and column sums of \(M\). Subtracting the
recorded internal edge and the count-two neighbors from the degrees of
\(i,k\) gives integers \(q_0,q_1\) satisfying
\[
 |U|=q_0-r,\qquad |W|=q_1-c.
\]
The sum of degrees in \(a\) determines the total \(s\) of \(M\).
Conversely, these equations and a binary matrix of total \(s\) enforce
all four remaining degrees; outside degrees are already enforced by the
recorded counts. This constructs a bijection onto the **entire** cell.
If \(A\cap B\ne\varnothing\), the two membership choices concern different
edges; no equality between the two choices is imposed.

Within the cell the full \(a\)-fiber is exactly \(X=(c,W)\), while the
full \(b\)-fiber is \(Y=(r,U)\). This orientation is important:
resampling the left pair conditions on the right data. Uniform graph
measure becomes uniform measure on these encodings, including their
cross-matrix multiplicities.

For \(s=0,4\) the matrix is fixed. For \(s=1,3\) the row and column sums
independently determine its unique exceptional position. These cases
give a product law for \(X,Y\), after any infeasible subset sizes are
deleted.

For \(s=2\), the multiplicity matrix, with rows \(r=0,1,2\) and columns
\(c=0,1,2\), is
\[
 m_{rc}=\begin{pmatrix}0&1&0\\1&2&1\\0&1&0\end{pmatrix}.
\]
Set \(a_t=\binom{|A|}{q_0-t}\), \(b_t=\binom{|B|}{q_1-t}\), taking
out-of-range binomial coefficients to be zero. The row/column joint
weights are \(a_r m_{rc}b_c\). The three aggregate masses are
\[
 L=(a_0+a_2)b_1,\quad R=a_1(b_0+b_2),\quad C=2a_1b_1.
\]
Here \(L,R\) are the disjoint events \(r\ne1,c\ne1\), and \(C\)
is the central mass. If \(C=0\), either \(a_1=0\) or \(b_1=0\);
nonempty support is then a single row or column. If either \(L\) or
\(R\) vanishes the same product-law conclusion holds, even if the
center is present. Thus an absent center does not require a limiting
argument or division by zero.

### 2. Rank-one interaction and an explicit positive certificate

Suppose \(L,R,C>0\). Center and normalize the indicators of \(c\ne1\)
and \(r\ne1\), obtaining \(u,v\) in the ranges of \(E_a,E_b\). Their
inner product is \(-\rho\), where
\[
 \rho^2=\frac{LR}{(L+C)(R+C)},\qquad 0<\rho<1.
\]
The strict upper bound follows from the identity
\[
 (L+C)(R+C)-LR=C(L+R+C)>0.
\]
The conditional law of \(Y\) given \(X\) depends only on whether \(c=1\);
indeed, the probability of each specific feasible \(Y=(r,U)\) is
\(m_{rc}/\sum_t a_t m_{tc}\). The symmetric statement holds on the
other side. Consequently all centered correlations except the \(u,v\)
plane vanish. The remaining orthogonal summands are the centered
parts of the two conditioning spaces orthogonal to that plane, and
\(J=(\operatorname{ran}E_a+\operatorname{ran}E_b)^\perp\).

On the plane, write \(f=xu+yv\). Its two deviations are
\(y(v+\rho u)\) and \(x(u+\rho v)\). The interaction plus the two
line-projection energies equals
\[
 (1-\rho^2)(x^2+y^2+2\rho xy)
 =(1-\rho^2)\{\rho(x+y)^2+(1-\rho)(x^2+y^2)\}\ge0.       \tag{1}
\]
This is a sum-of-squares certificate valid for either sign of \(xy\).
In fact, the coefficient of the two errors can be reduced from \(1\)
to \(\rho\) on this particular cell.

On each full \(a\)-fiber the vector \(v-E_av\) is either zero or a
multiple of its centered equality indicator for \(k,l\). Its line is
therefore contained in \(\operatorname{ran}R_{a,b}\), including when
that indicator vanishes. The other line is treated symmetrically.
The cross toggle fixes the two conditioning data, so its antisymmetric
range lies in \(J\). On \(J\) both deviations are the identity; its
contribution dominates the gain projection energy. Together with
(1), this proves exactly
\[
 2\langle h_af,h_bf\rangle
 \ge 2\|g_{a,b}f\|^2-\|R_{a,b}f\|^2-\|R_{b,a}f\|^2.     \tag{2}
\]
In the product-law cases the deviations commute and their product
is the projection onto \(J\), proving a stronger inequality without
the two errors. Averaging over the invariant cells proves (2)
globally.

### 3. Exact slice spectrum and complete budget

Let \(r=N-q\) and
\[
 p=\frac{q(q-1)+r(r-1)}{N(N-1)}.
\]
When \(N\ge3\) and \(1\le q\le N-1\), the centered equality vectors
have common positive squared norm \(p(1-p)\). Map a pair coefficient
vector \(c\) to \(Bc=\sum_{i<j}c_{ij}z_{ij}/\sqrt{p(1-p)}\).
Then \(S=BB^*\).

The coefficient space decomposes orthogonally into constants \(C_0\),
vectors \(c_{ij}=u_i+u_j\) with \(\sum_i u_i=0\) (\(C_1\)), and
row-zero symmetric coefficients (\(C_2\)). Their dimensions are
\(1,N-1,N(N-3)/2\); \(C_2\) is absent at \(N=3\).
The map \(u\mapsto(u_i+u_j)\) is injective for \(N\ge3\), as restriction
to any triangle shows. Its orthogonal complement is exactly the
row-zero space, proving exhaustion without a representation-theoretic
assumption.

The Gram entries depend only on whether their two pairs agree, meet
in one vertex, or are disjoint. The meeting/disjoint coefficient sums
are \((N-4)c_{ij},-(N-3)c_{ij}\) on \(C_1\), and
\(-2c_{ij},c_{ij}\) on \(C_2\), by their row sums. Thus \(B^*B\)
is scalar on each space. It kills \(C_0\), since the number of equal
pairs is fixed. On \(C_1\) use the exact identities
\[
 \sum_{i<j}(u_i+u_j)z_{ij}=(q-r)\sum_i u_i x_i,\quad
 \operatorname{Var}\Big(\sum_i u_ix_i\Big)
   =\frac{qr}{N(N-1)}\sum_i u_i^2,\quad
 \sum_{i<j}(u_i+u_j)^2=(N-2)\sum_i u_i^2.
\]
The resulting eigenvalue is
\[
 \mu_1=\frac{(q-r)^2}{2(N-2)p}.
\]
Using \(\operatorname{tr}(B^*B)=\binom N2\) gives, for \(N\ge4\),
the **exact** second eigenvalue
\[
 \mu_2=\frac{2(q-1)(r-1)}{(N-3)(N-2)p}.                 \tag{3}
\]
This also explicitly identifies its zero image when \(q=1\) or \(r=1\).

The transposition generator \(G=\tfrac12\sum_{i<j}(I-\tau_{ij})\)
acts on the two images by \(N/2,N-1\), respectively. This follows
by summing transpositions on \(x_i\) and \(x_ix_j\); constant and
linear terms cancel for row-zero coefficients. The images are
orthogonal, and their orthogonal complement is invariant under the
self-adjoint positive \(G\); on that complement \(S=0\).
The two required comparisons follow from the exact identities
\[
\begin{aligned}
 (N-1)\{N(N-2)p-(q-r)^2\}&=2N(q-1)(r-1)\ge0,\\
 N\{(N-1)(N-2)p-2(q-1)(r-1)\}&=(N-1)(q-r)^2\ge0.
\end{aligned}                                                    \tag{4}
\]
Thus \(\mu_1\le N/2\) and
\(\mu_2/(N-1)\le1/(N-3)\le1\), proving \(S\preceq G\).
More precisely, for \(N\ge4\),
\[
 S\preceq \kappa(N,q)G,\qquad
 \kappa=\max\{2\mu_1/N,\ \mu_2/(N-1)\}\le1.             \tag{5}
\]
The zero-image coefficients may be omitted. For an interior slice
\(2\le q\le N-2\), \(N\ge5\), both ratios are strictly below one.

For \(N\le2\) or \(q\in\{0,N\}\), every centered equality vector
vanishes and the comparison is immediate. At \(N=3\) there is no
second image. At a balanced slice the first image vanishes. At
\(N=4,q=2\), \(\mu_1=0,\mu_2=3=N-1\): equality holds on the nonzero
quadratic image, **not** on the whole slice. These observations cover
all exceptional divisions and dimensions.

On each full \(a\)-fiber a pair \(b\) of singleton labels gives exactly
the same coordinate swap and equality projection as \(G,Q_{ij}\).
If a label is not a singleton, both terms vanish. Consequently (4)
proves the complete directed budget, not just a selected collection
of \(b\)'s:
\[
 \sum_{b\cap a=\varnothing}\|R_{a,b}f\|^2
 \le\sum_{b\cap a=\varnothing}\|g_{a,b}f\|^2.            \tag{6}
\]

### 4. Ordered assembly

Both orders of every disjoint pair-pair occur in \(D\), so its bilinear
form is symmetric. Summing (2) over **unordered** disjoint pair-pairs
and using \(g_{a,b}=g_{b,a}\) gives
\[
 \langle f,Df\rangle\ge
 \sum_a\left(\sum_{b\cap a=\varnothing}\|g_{a,b}f\|^2
       -\sum_{b\cap a=\varnothing}\|R_{a,b}f\|^2\right)\ge0.
\]
There is no additional factor \(1/2\). The same proof with (5)
retains a nonnegative fiberwise slack
\((1-\kappa(N,q))\langle f,Gf\rangle\), when its interior formula
applies.

## Graph-realizable sharpness of the local error coefficient

Here is an unbounded-parameter construction, beyond a single negative
interaction example. For every integer \(m\ge1\), take
\[
 V=\{i,j,k,l\}\sqcup O,\quad |O|=m,\qquad
 d=(1,m+1,1,m+1,2,\ldots,2).
\]
Consider the common preserved-data cell with no internal edges \(ij,kl\),
no edges on \(O\), and exactly one neighbor of every \(w\in O\) in each
of \(a=\{i,j\}\), \(b=\{k,l\}\). The outside singleton sets are both
the entire \(O\).

Its states are exactly the following \(2m+2\) simple graphs.
Start with all edges \(jw,lw\) for \(w\in O\).

* The two central graphs add either \(ik,jl\) or \(il,jk\).
* For each \(t\in O\), the top graph replaces \(jt\) by \(it\)
  and adds \(jk,jl\).
* For each \(t\in O\), the side graph replaces \(lt\) by \(kt\)
  and adds \(il,jl\).

Every listed vertex has the specified degree, and the graphs are distinct.
Conversely, in the cell the cross total is two and \(q_0=q_1=1\);
the multiplicity table leaves just these top, side, and central cases.
This proves completeness of the cell for every \(m\), not just for
the probed parameter values.

Put \(f=-1\) on top graphs, \(f=1\) on side graphs, and \(f=0\) on
the two centers; extend it by zero to the rest of \(\Omega_d\).
The common cell is invariant under both complete pair resamplings.
The nontrivial \(a\)-fiber consists of the \(m\) top graphs and the
two centers. Its deviation values are \(-2/(m+2)\) and \(m/(m+2)\);
the side graphs have zero deviation. The \(b\)-fiber calculation
reverses the signs and exchanges top and side. These deviations are
exactly their respective equality-line projections, while \(g_{a,b}f=0\).
In the conditional uniform measure of the cell,
\[
\begin{aligned}
 I_m:=2\langle h_af,h_bf\rangle
   &=-\frac{2m^2}{(m+1)(m+2)^2},\\
 E_m:=\|R_{a,b}f\|^2+\|R_{b,a}f\|^2
   &=\frac{2m}{(m+1)(m+2)},\\
 -I_m/E_m&=\frac{m}{m+2}\longrightarrow1.
\end{aligned}
\]
Global uniform inner products multiply both quantities by the same
positive cell probability, so the ratio is unchanged. Therefore an
inequality \(I\ge2\|gf\|^2-cE\) valid for every graphical degree vector
forces \(c\ge1\). Together with (2), this proves **optimality of the
manuscript's universal coefficient \(1\)**. It is not a counterexample
to the manuscript.

This sharpness conclusion is a strengthening of the audit's prior
source-level and finite-example evidence. Its mathematical novelty and
publishable significance remain questions for independent review;
they are not inferred from a failed literature search.

## Reproducibility and evidentiary limits

`Main.lean` is generated from 118 pinned project modules needed for the
actual graph interaction, slice transport, and assembly. It does not
import the upstream Lake configuration or the comparator. The port changes
conditional-lemma names, an older `ReflTransGen.lift` application, and an
explicit definitional `Finset.mapEmbedding` reduction. All such changes
retain the original propositions. The appended `Argus9000131.disjoint_core`
states the arbitrary-parameter symmetric positive form explicitly.
The compiler's transitive axiom lists, not the earlier source scan, are
the axiom evidence. `statement_fidelity.md` separates the graph theorem
from the additional scalar sharpness formalization.

The executable checks use exact rational Schur complements, never numerical
eigenvalue thresholds. They reconstruct full degree spaces and the original
fiber keys, check the graph-cell bijection and both conditioning directions,
check all local residuals and complete budgets, and check their exact
ordered assembly. The finite scope is all degree spaces with \(n\le5\),
plus the two constant degree vectors \(1^6,2^6\). Slice probes cover
every \(0\le q\le N\le7\). The sharpness-family probes have
\(m=1,2,5,20\); the proof for all \(m\) is the counting argument above,
not extrapolation from those probes.

The dedicated Jacobian payload checks twice the Gram matrix of the three
complementary equality-indicator classes on the \(N=4,q=2\) slice:
diagonal \(2\), off-diagonal \(-1\). Its spectrum is \(3,3,0\).
Complementary pairs have identical centered indicators, so duplicating the
three classes yields the original six-column frame with the same nonzero
spectrum \(3,3\). The full typed result, server version, protocol, payload,
and adapter exit status are retained in the `jacobian_*.json` files.
This small check is not substituted for the universal proof.

Independent replay is:

```sh
python3 research/disjoint_core/verify.py
```

The Python replay uses SymPy (measured here with version 1.14.0) and the
standard library. `exact_certificate.json` records the successful combined
replay, the exact finite scopes, all-parameter algebra, sharpness-family
measurements, and the bound compiler certificate
`lean_evidence/certificates/C_DISJOINT_CORE-62dcf5099e93ad3c.json`.

By default this reruns the exact probes and invokes the prescribed
`lean_evidence verify --claim C_DISJOINT_CORE` on the actual source and
fidelity document. Submit that command through the durable runner if it
may exceed two minutes. To replay only the exact computations while
checking an already measured compiler certificate, pass
`--lean-record research/disjoint_core/lean_evidence/certificates/<certificate>.json`.
The verifier checks its source and fidelity hashes, claim binding,
zero compiler exit, absent proof holes, and the requested transitive
axiom lists. Reusing an old certificate after editing either input fails.
`--probes-only` is explicitly a checkpoint and cannot produce the universal
certificate.

The exact sampler and the remaining main mixing theorem are not certified
by this deliverable. The Engineer does not set independent acceptance,
verified novelty, or campaign completion.
