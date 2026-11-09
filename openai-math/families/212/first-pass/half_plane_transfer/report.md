# Exact-label transfer across a horizontal cut

## Statement and source scope

The target is `lem:cut-transfer`, not the no-bigeodesics theorem. All source
references below are to the staged **No bigeodesics in planar first-passage
percolation, September 24, 2026**, `build/sections/`.

The target has the quantifier order

\[
 \exists (n_k)\text{ deterministic}\quad
 \mathbb P\bigl[
   \forall\text{ finite upper-ray families }P,\ \forall K\text{ finite},\
   \exists k_0,\ \forall k\ge k_0:\ {\cal T}(P,K,n_k);
   \quad \forall n,\ \forall\text{ lower rays }q,\
   \exists L:\ {\cal L}(q,L,n)
 \bigr]=1.
\]

Here \({\cal T}\) preserves the entire paths, their exact linear labels,
all Busemann evaluations on \(K\times K\), and eventually the distances
from each \(x\in K\) to their targets. The latter target threshold is
allowed to depend on \(k\). The assertion \({\cal L}\) preserves the
tail starting at \(q_L\) and its exact label. It asserts neither preservation
of the entire lower ray nor a tail index uniform over rays or cuts.

The scoped inputs, retained as assumptions rather than re-proved FPP
theorems, are:

1. `02-preliminaries.tex`, `lem:finite-minimizers`: finite geodesics exist.
   The proof uses positive finite weights and the iid nonatomic law.
   Uniqueness is available but the transfer comparison only needs existence.
2. `02-preliminaries.tex`, `lem:busemann-basic`,
   `eq:calibration-defect`: an additive, metric-dominated Busemann function
   calibrates its ray; for every fixed \(x\),
   \(T_U(x,p_j)-B_p^U(x,p_j)\downarrow0\).
3. `02-preliminaries.tex`, `thm:structure(ii)`,
   `eq:busemann-linearity`: in each of countably many iid environments,
   **every** ray has an asymptotically linear Busemann function and its
   directions are contact directions of its linear functional.
   The fixed-functional coalescence assertion (iii) is not used in transfer.
4. `02-preliminaries.tex`, `lem:uniform-metric`: the endpoint-uniform
   error is \(o(|x|+|y|)\). This is used for fixed metrics, not assumed
   uniformly over the independently replaced metrics.
5. `03-sectors.tex`, `lem:charts`, `eq:chart-contact-sector`: all contacts
   of an upper label have positive vertical coordinate bounded away from
   zero; all contacts of its negative are strictly lower. This gives
   escape in height and a strictly positive gap on the opposite closed
   semicircle. The all-ray cone proposition is stronger than needed here.
6. `04-exceptional.tex`, `eq:half-plane-coupling`: \(U,V_n,W_n\) have the
   same iid law; the shared upper edge set includes horizontal cut edges
   and upward edges starting on the cut. Downward edges starting on the
   cut are shared by \(U,W_n\). Independence between different \(n\)'s is
   neither stated nor needed.

**Boundary-comparison dependency.** The assertion that the structural
theorem has the stated minimum-moment scope is upstream of this audit.
`02-preliminaries.tex` explicitly invokes `09-boundary-comparison.tex`,
`prop:boundary-uniqueness`, in replacing an expectation argument in
Ahlberg--Hoffman. This report does not verify that appendix or its
literature attribution, and cannot certify the structural theorem at
that moment scope independently of them. The transfer argument below
treats simultaneous ray linearity and the uniform metric theorem as
explicit premises; it does not covertly promote fixed-label probability-one
events to a simultaneous event.

The project Wiki index was searched for half-plane transfer, Busemann,
and bigeodesic entries; no relevant entry was found. The initial campaign
ledger contains no prior certified result for this target.

## Proof

### One event and one deterministic subsequence

Take the countable intersection of the simultaneous regularity events
in the scoped inputs for \(U\), all \(V_n\), and all \(W_n\).
These environments have the same deterministic norm \(m\). No
fixed-functional uniqueness or coalescence event is included.

For any one such fixed metric define
\[
 E_n(T)=\sup_{x,y\in\mathbb Z^2}
 \frac{|T(x,y)-m(y-x)|}{|x|+|y|+n}.
\]
This is measurable, since the supremum is countable. Given \(\epsilon>0\),
the uniform metric theorem bounds the numerator by
\(\epsilon(|x|+|y|)\) outside a finite set of pairs; let \(C\) be
the largest numerator on that finite set. Thus
\(E_n(T)\le\max(\epsilon,C/n)\), proving finiteness and convergence
to zero. Identical marginal laws give
\[
 \mathbb P(E_n(T_{V_n})>\epsilon)
   =\mathbb P(E_n(T_U)>\epsilon)\longrightarrow0.
\]
Recursively choose deterministic integers \(n_k>n_{k-1}\), \(n_k\ge k\),
with
\(\mathbb P(E_{n_k}(T_{V_{n_k}})>2^{-k})<2^{-k}\).
Borel--Cantelli gives \(E_{n_k}(T_{V_{n_k}})\to0\) on a further
probability-one event: directly, the probability of any failure after
index \(K\) is at most \(\sum_{k\ge K}2^{-k}\to0\), so infinitely many
failures have probability zero. Also \(E_{n_k}(T_U)\to0\). This choice precedes
every choice of ray, functional, and witness set. Dependence between
the resampled metrics is immaterial.

Work on this event from now on.

### Deriving the moving-cut barrier

Choose any upper \(U\)-ray \(p\), let \(\rho\) be its label, and put
\[
 b(w)=B_p^U(0,w),\qquad a(w)=b(w)-\rho(w)=o(|w|).
\]
All zeroes of \(m(d)-\rho(d)\) on the unit circle are strictly upper.
Nonnegativity, continuity and compactness therefore give
\[
 \gamma=\min_{|d|=1,\ d_2\le0}(m(d)-\rho(d))>0.
\]
By homogeneity, \(m(d)-\rho(d)\ge\gamma|d|\) for every lower
displacement \(d\).

Fix finite \(K\), enlarged to contain \(p_0\), and put
\(R=\max_{x\in K}|x|\), \(A=\max_{x\in K}|a(x)|\).
For \(n\ge2R+1\), \(z\in H_n\), \(x\in K\), write
\(X=|x|\), \(Z=|z|\), \(D=|z-x|\). The triangle and vertical bounds give
\[
 X\le n/2,\quad Z\ge n,\quad D\ge Z-X,\qquad
 Z\le2D,\quad X+Z+n\le5D,\quad D\ge n/2.
\]
In particular \(z-x\) is strictly lower. These inequalities do not
restrict the horizontal coordinate of \(z\).

For all sufficiently large \(k\), with \(n=n_k\), both normalized
metric errors are at most \(\gamma/40\). Rooted sublinearity gives,
uniformly for \(|z|\ge n\),
\[
 |a(z)|\le(\gamma/16)|z|\le(\gamma/8)D.
\]
Increasing \(k\) so that \(n\ge16A/\gamma\) gives
\(|a(x)|\le(\gamma/8)D\) for every \(x\in K\).
For \(T=T_U\) or \(T_{V_n}\), it follows that
\[
\begin{split}
 T(x,z)-B_p^U(x,z)
 &\ge\gamma D-E_n(T)(X+Z+n)-|a(z)|-|a(x)|\\
 &\ge (5\gamma/8)D
 \ge(\gamma/2)D
 \ge\delta_n,\qquad \delta_n=\gamma n/4>0. \tag{1}
\end{split}
\]
Thus the barrier is **derived** from the stated asymptotics, uniformly
on the entire unbounded cut. No uniformity over \(\rho\) was used.

### Last-cut decomposition and exact distances

Consider any finite nearest-neighbor walk \(\pi\) from \(x\) to \(y\),
with both endpoints strictly above the cut, which visits it. Choose
the **last** cut index \(l\) and vertex \(z\). Every subsequent vertex
is strictly above the cut: a vertex below it would require another
cut visit to reach \(y\), since a nearest-neighbor step cannot skip
an integer height. Hence the suffix, including its first upward
edge, has the same costs in \(U,V_n\).

The prefix cost is at least \(T_{V_n}(x,z)\); the suffix cost is at
least \(T_U(z,y)\ge B_p^U(z,y)\). Additivity gives
\[
 T_{V_n}(\pi)\ge
 B_p^U(x,y)+[T_{V_n}(x,z)-B_p^U(x,z)]. \tag{2}
\]
The same statement holds entirely in \(U\). This is a decomposition
of a walk with traversal multiplicity, not an assertion that the
prefix or suffix is geodesic. Repeated cut visits, repeated edges,
and horizontal edges on the cut all remain in the prefix.
A cut-avoiding walk with endpoints on this side stays on this side
and has unchanged cost.

The height of \(p_j\) tends to \(+\infty\), so its entire vertex
sequence has a finite minimum height. For sufficiently large \(n_k\)
the whole path is strictly above \(H_{n_k}\). Its segment from \(p_0\)
to \(p_j\) has unchanged cost \(B_p^U(p_0,p_j)\). Equations (1)--(2)
make every cut-touching competitor strictly more expensive, while
every cut-avoiding competitor has its original \(U\) cost. Every root
prefix therefore remains minimizing in \(V_{n_k}\). Every subsegment
then minimizes too: a cheaper replacement subsegment would make its
root prefix cheaper. The unchanged simple infinite path is a ray.

For an arbitrary \(x\in K\), fix one sufficiently large \(k\). The
calibration defect
\[
 d_j(x)=T_U(x,p_j)-B_p^U(x,p_j)\longrightarrow0
\]
is eventually smaller than \(\delta_{n_k}\). A \(U\)-minimizer must
then avoid the cut by (2), and is an unchanged competitor in \(V_{n_k}\).
Every cut-touching \(V_{n_k}\)-walk costs at least
\(B_p^U(x,p_j)+\delta_{n_k}>T_U(x,p_j)\); every avoiding walk has
its \(U\) cost, at least \(T_U(x,p_j)\). Consequently
\[
 T_{V_{n_k}}(x,p_j)=T_U(x,p_j)\quad(j\ge J(x,p,k)). \tag{3}
\]
Taking the largest of the finitely many target thresholds for \(K\)
gives simultaneous equality there. Subtracting two equalities and
taking the Busemann limits proves exact equality on \(K\times K\).
The target threshold is not asserted to be uniform in \(k\).

### Exact labels: a new comparison with moving basepoints

Keep one cut \(n=n_k\) at which \(p\) is preserved. Both metrics are
now fixed. Let \(0<c<1\), \(x_2\ge c|x|\), \(z\in H_n\), and
again put \(X=|x|\), \(Z=|z|\), \(D=|z-x|\), \(S=X+Z\). Then
\[
 D\ge x_2+n\ge cX,\qquad Z\le D+X,\qquad
 D\ge\kappa S,\quad\kappa=\frac{c}{c+2}.
\]
Thus \(m(z-x)-\rho(z-x)\ge gS\), where \(g=\gamma\kappa>0\).
For every \(\epsilon>0\), rooted sublinearity on the lattice gives
a finite \(C_\epsilon\ge0\) with
\[
 |a(w)|\le\epsilon|w|+C_\epsilon\quad\text{for all }w.
\]
This follows by taking a maximum over the finite ball not covered by
the asymptotic estimate. Separately for each of the two fixed metrics,
the metric error is at most \(\epsilon S\) once \(S\) is large enough.
It follows that
\[
 \min(T_U(x,z),T_{V_n}(x,z))-B_p^U(x,z)
   \ge(g-2\epsilon)S-2C_\epsilon.
\]
Choose \(\epsilon=g/8\), then take \(|x|\) large enough for both
metric estimates and \(S\ge8C_\epsilon/g\). We obtain
\[
 \min(T_U(x,z),T_{V_n}(x,z))-B_p^U(x,z)
       \ge(g/2)(|x|+|z|). \tag{4}
\]
This includes the error at the **moving basepoint** \(x\), not only
the error at the cut vertex \(z\). The estimate is uniform over all
horizontal cut positions.

For every such fixed \(x\), the defect \(d_j(x)\to0\) and (4) imply
eventual equality of its two target distances by the last-cut
comparison. Root distances from \(p_0\) are equal for every \(j\),
by preservation and calibration. Hence
\[
 B_p^{V_n}(p_0,x)=B_p^U(p_0,x)
       \quad\text{for every sufficiently far }x_2\ge c|x|. \tag{5}
\]
The threshold for \(j\) may vary with \(x\); this does not affect the
equality after taking each Busemann limit.

Use \(c=1/2\), first \(x=ke_2\), then \(x=k(e_1+e_2)\).
Both sequences are in this sector. If \(\sigma\) is the new label,
asymptotic linearity in the two fixed environments and (5), divided
by \(k\), give
\[
 \sigma(e_2)=\rho(e_2),\qquad
 \sigma(e_1)+\sigma(e_2)=\rho(e_1)+\rho(e_2).
\]
Thus both coordinates agree. Preserving directions alone would not
have proved this; the second fixed-cut comparison is essential.

For any finite family of upper rays, take the largest of their
individual cut thresholds. The common subsequence and common event
were chosen before all of them. This proves part (i) with its
literal quantifier order, even for environment-dependent labels.

### All lower tails at each fixed complementary cut

Fix any \(n\ge1\) and any lower \(U\)-ray \(q\), with label
\(\lambda\). Write \(b_-(w)=B_q^U(0,w)\) and
\(a_-(w)=b_-(w)-\lambda(w)=o(|w|)\).
The positive opposite-semicircle gap is now
\[
 \gamma_-=\min_{|d|=1,\ d_2\ge0}(m(d)-\lambda(d))>0.
\]
Choose \(0<c\le1/2\) so that eventually \(q_{j,2}\le-c|q_j|\).
The strict lower contact sector permits this. Translating by the
fixed starting vertex does not change limiting directions, so this
is a statement in absolute coordinates as required.

For \(x_2\le-c|x|\), \(|x|\ge2n/c\), \(z\in H_n\), the
displacement is upward and
\[
 D\ge cX-n\ge cX/2,\qquad Z\le D+X,\qquad
 D\ge\kappa_-S,\quad \kappa_-=\frac{c}{c+4}.
\]
Apply exactly the fixed-metric error argument giving (4), now in
\(U,W_n\), with \(g_-=\gamma_-\kappa_->0\). For all sufficiently
far such \(x\), uniformly for every \(z\in H_n\),
\[
 \min(T_U(x,z),T_{W_n}(x,z))-B_q^U(x,z)
       \ge(g_-/2)(|x|+|z|). \tag{6}
\]
No asymptotic control of the sequence \(W_n\) as \(n\to\infty\)
has been assumed.

Pick \(a=q_L\) far enough for (6) and so that the entire remaining
tail lies strictly below the cut. In a cut-touching walk from \(a\)
to a later \(q_j\), the suffix after its last cut vertex lies
strictly below the cut. Its first edge is downward; all suffix
edges are outside \(E_n^+\) and are shared by \(U,W_n\).
In particular, an unshared horizontal cut edge can only be in the
prefix. The signed-height last-cut argument and (6) prove
preservation of every calibrated prefix from \(a\), hence of the
whole tail as a \(W_n\)-ray.

For every sufficiently far fixed \(x\) in the strict lower sector,
its \(U\) calibration defect also tends to zero, so (6) proves
eventual equality of target distances from \(x\). Distances from
the preserved anchor \(a\) agree for all later targets. Thus the
two tail Busemann functions agree at \((a,x)\). Apply this at
\(x=-ke_2\) and \(x=-k(e_1+e_2)\); these directions lie in the
chosen sector because \(c\le1/2\). Their two normalized limits
identify the two label coordinates as exactly \(\lambda\).

All \(W_n\) were placed in the initial countable regularity event,
and the argument chose an arbitrary \(n\) and then an arbitrary
lower ray. It proves \(\forall n\,\forall q\,\exists L\), not a
countable intersection over selected rays. This proves part (ii).

## Certification and limitations

`Main.lean` formalizes the universal finite-walk comparison, signed
last-cut localization, both comparability formulas, barrier algebra,
the derivation of fixed-cut barriers from asymptotic moduli, their
composition into exact eventual distance equality, preservation of
minimizing root prefixes and segments, finite witness thresholds,
Busemann difference limits, and recovery of both coordinates.
`statement_fidelity.md` gives the precise translation and the portions
remaining in prose. In particular, `asymptoticTransfer` and
`movingCutDistanceEquality` derive the barriers rather than assume the
disputed conclusion.

`verify.py` replays exact rational identities, all short lattice walks
in its stated regression range (including loops and repeated cut
visits), and the independent-direction Jacobian output. It also checks
the source/fidelity binding of the authorized Lean certificate.
By default `verify.py` also performs a fresh standalone Lean compiler
replay; it fails explicitly if the compiler or the certified workspace
is missing. `--recorded-lean` instead checks the already recorded real
compiler result without recompiling. The finite computations are
regression checks, not proofs of infinite or almost-sure assertions.

The authorized Lean 4.31.0 run returned `exit_code=0`,
`proof_holes=[]`, and `audit_exit_code=0`. Its archived certificate is
`certificates/C_CT_CORE-69ed72f13c851087.json`; the ledger derives
`closed_kernel` for **C_CT_CORE**, not for the stochastic target
**C_CT_TRANSFER**. A separate standalone compiler replay also succeeded.
The exact script checks eight slack identities and enumerates 43,690
lattice walks. Of these, 26,552 end on the retained side, 8,976 touch
the cut, 5,520 revisit it, and 4,604 use a horizontal cut edge.
The coordinate matrix has determinant \(-1\), as both the Jacobian
typed output and exact rational replay confirm.

The seven scoped source-premise attributions are recorded with
locators but await independent attribution review. In particular,
reading the appendix's assertion is not a proof of its claimed repair.
No independent Reviewer verdict is recorded by the Engineer.

**Conclusion.** The literal transfer lemma follows from its stated
simultaneous structural and metric hypotheses. No false assertion or
counterexample to that lemma was demonstrated. Its proof preserves
the actual quantifiers, not a fixed-label surrogate. This is a
conditional verification of a load-bearing manuscript mechanism, not
a verified-new theorem, not an iid counterexample, and not certification
of the entire manuscript family. The upstream boundary comparison and
all other no-bigeodesics dependencies remain open in the campaign graph.
Independent Reviewer replay and statement-fidelity/source-premise review
are required before acceptance of this node.
