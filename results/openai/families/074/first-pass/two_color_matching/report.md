# Smooth two-color matching: an independent proof and a sharp finite-type extension

## Result and scope

**Theorem 1.** The impossibility and fixed-power robustness in
`lem:two-color-matching`, lines 278--778 of the staged four-dimensional
manuscript's `build/sections/03-comparison.tex`, hold with their stated
quantifiers. Neither algebraicity, uniform index priors, nor independence
of the two sampled indices is needed.

The proof below also gives the following stronger statement.

**Theorem 2 (sharp pure-type matching).** Fix integers \(m\geq1\) and
\(J>m\). Suppose, as \(N\to\infty\), two indexed lists of real
\(C^{J+1}([0,1])\) functions each have at most \(N^{d+o(1)}\) members,
where \(d\) is finite. All derivatives, including order zero, are bounded
by \(N^{o(1)}\). A probability law \(Q\) on \((i_1,i_2,t)\) has

\[
 Q_\kappa(i,dt)\leq N^{o(1)}\pi_{\kappa,i}\,dt,\qquad
 \pi_{\kappa,i}\geq0,\quad\sum_i\pi_{\kappa,i}=1.
\]

Write \(\Delta_j=f_{1,i_1}^{(j)}(t)-f_{2,i_2}^{(j)}(t)\).
If every event satisfies

\[
 |\Delta_j|\leq N^{-(1-j/m)+o(1)}\quad(0\leq j<m),
 \qquad |\Delta_m|\geq N^{-o(1)},
 \tag{1}
\]

then

\[
                         d\geq (m+1)/2.                 \tag{2}
\]

For every \(m\), Section 10 constructs examples for all integers \(L\geq2\),
with \(N=L^m\), attaining this exponent with constant losses. Thus (2) is
sharp, not a bounded numerical observation. For every fixed
\(d_0<(m+1)/2\), the exclusion is uniform with sufficiently small fixed
power losses.

These are mathematical proofs submitted for **independent review**, not
claims that a Python run or a compiler verified all their analysis.
The universal determinant and finite hidden-history domination theorem
have a real Lean 4.31.0 certificate. The Taylor, probability, integration,
and scale-limit arguments below are not formalized. Neither Kakeya main
theorem is certified by this report. Mathematical novelty and publishable
significance remain for independent assessment.

## 1. Source fidelity and prior knowledge

The source statement fixes \(D\geq1\), an integer \(J>D\), and \(d_0<1\).
It forbids a sequence with \(d\leq d_0\), two lists bounded by
\(N^{d+o(1)}\), a common \(K=N^{o(1)}\), both index-time marginal
inequalities \(Q_\kappa(i,dt)\leq K\pi_{\kappa,i}dt\), value gap at most
\(K/N\), and a gap at least \(1/K\) in some derivative order \(1,\ldots,D\)
at each event. This report uses exactly these hypotheses. It treats
indexed lists, not just distinct functions. Zero prior weights carry no
event mass and may be ignored. Affine translation identifies any unit
interval with \([0,1]\).

| Source labels in `03-comparison.tex` | Obligation addressed here |
|---|---|
| `a02:jet-scales`--`a02:descendant-count` | Sections 2--3: nested records, Taylor bounds, pre-selection masses |
| `a02:palette-likelihood` | Section 4: entropy and the exceptional-step estimate |
| switching experiment | Section 5: marginal bounds, time densities, positive successful mass |
| `a02:full-past-kernel` | Section 6: one start-dependent measure and unnormalized backward iteration |
| `a02:endpoint-polynomial`, `a02:endpoint-jacobian` | Section 7: arbitrary order and signed time increments |
| `a02:final-target-widths`--`a02:entropy-increment` | Section 8: the actual sampling-to-volume inequality |
| final two paragraphs | Section 9: ordered limits and fixed-power robustness |

Both manuscripts' main chains are recorded as **open** in
`../PROOF_GRAPH.json`. The 3D source ends through critical vanishing and
maximal reduction; the 4D chain passes through model reduction, critical
paths, comparison, and the narrowness branches. Source assertions are
recorded as source assertions in `../MATH_STATE.json`, not used as proofs
of either main theorem.

The only specialized external theorem used below is the uniform
semialgebraic component bound in S. Basu, *Algorithms in Real Algebraic
Geometry: A Survey*, arXiv:1409.1534v1, Theorem 2.17. Its exact hypotheses
and statement were opened and are excerpted in `finite_fiber_source.txt`.
It applies to real polynomial endpoint fibers of fixed dimension and
degree, not to the original smooth functions. Ordinary Taylor's theorem,
conditional probabilities on standard Borel spaces, finite entropy
identities, Tonelli's theorem, and the inverse/change-of-variables
theorems of multivariable calculus are used in their usual forms.
The entropy identity needed here is derived below.

Christ's *Quasiextremals for a Radon-like Transform*,
arXiv:1106.0722v1, was opened as context for the source's stated
refinements analogy. Its operator and conclusions are different; no
theorem from it is imported to prove the matching claim. A targeted
literature search did not identify a primary-source statement of
Theorem 2 under these arbitrary-prior smooth hypotheses. That limited
negative retrieval is **not** a verification of novelty. Unverified
theorem numbers suggested for inaccessible BPR book links are not used.

For comparison, summing finite-type sublevel lengths over pairs loses
the repeated-use information in both marginals and cannot reach
\(d\geq1\) in general. Counting determinants at a few orders also does
not resolve the claim. The proof uses the sampled law itself.

Throughout, a factor denoted \(N^{o(1)}\) is uniform over the finite grid
and all starts at that grid. The grid and all its constants are fixed
**before** taking \(N\to\infty\). Products of a fixed number of subpower
factors, and losses from a fixed number of logarithmic selections, are
still subpower. There is no uniformity assertion as the grid is refined
before that limit.

## 2. Gap profiles and scales

By pigeonholing the derivative order which witnesses the gap, and then
dyadic ranges of all gaps through order \(J\), restrict to a set of
subpower probability. Gaps smaller than \(N^{-B}\), for a fixed \(B>2\),
are recorded only by that upper bound. There are \(O(\log N)\) ranges per
coordinate. After a subsequence their exponents converge to
\(\beta_j\), with

\[
 \beta_j\geq0,\quad \beta_0\geq1,\quad
 \beta_q=0\text{ for some }1\leq q\leq D.
 \tag{3}
\]

For an uncut gap its magnitude is \(N^{-\beta_j+o(1)}\); at a cutoff
only the upper bound is asserted. Normalizing the selection enlarges
the marginal constant by a subpower factor, keeping the original priors.

Put, for \(0\leq a\leq1\),

\[
 r(a)=\max_{1\leq j\leq J}(a-\beta_j)/j,\qquad
 l_j(a)=\max_{0\leq x\leq a}(x-jr(x)).
 \tag{4}
\]

Here \(l_0(a)=a\). The function \(r\) is increasing, convex and
piecewise affine, \(r(0)=0\), and \(r(a)\geq a/D\). Moreover

\[
 0\leq l_j(a)\leq\beta_j,\qquad
 l_j(a)-l_{j+i}(a)\leq ir(a).
 \tag{5}
\]

For the second inequality evaluate \(l_{j+i}\) at a maximizer \(x\) of
\(l_j\), and use \(r(x)\leq r(a)\). For \(a>0\),

\[
                     (J+1-j)r(a)>l_j(a).                \tag{6}
\]

Indeed, for a positive maximizing \(x\), \((J+1)r(x)>x\);
at \(x=0\) the right side is zero and \(r(a)>0\).

On an open piece with active order \(m\), \(r' =1/m\), and

\[
 r=(a-\beta_m)/m,\qquad
 l_j=a-jr\ (j\leq m),\qquad l_j>a-jr\ (j>m).
 \tag{7}
\]

The slope of \(x-jr(x)\) is nonnegative up to that piece for \(j\leq m\);
for \(j>m\), moving left within the piece strictly increases it.
In particular \(l_m=\beta_m\), and

\[
 l_{m+i}(a)+ir(a)-\beta_m>0\quad(1\leq i\leq J-m).
 \tag{8}
\]

An active order satisfies \(m\leq D\): for \(j>D\) and \(a>0\),
\((a-\beta_j)/j\leq a/j<a/D\). Cutoff orders cannot be active.

Trim the endpoints of all active pieces, omit pieces too short to trim,
and stay away from zero. On the remaining compact pieces all the strict
gaps in (6), (8) are uniformly positive. Fix \(C>5J\), \(D_1>5\), and
then a sufficiently small step \(b\). Subdivide those pieces with mesh
\(b\). Use steps \([a,a+b]\) only when \(a+Cb\) remains in the same piece.
The finite grid contains their endpoints, all \(a+Cb\), their initial
points \(A_0\), and 1. Only after the fixed-grid limit will the mesh or
trims decrease.

## 3. Nested records and the mass bookkeeping

Use nested dyadic intervals \(I_a\) of length comparable to
\(N^{-r(a)}\). The state \(F_a\) records \(I_a\), both arms' derivative
bins at its center, of widths \(N^{-l_j(a)}\), \(0\leq j\leq J\), and all
earlier grid states. For \(t\in I_a\), translating a jet box gives
uncertainty in order \(j\) at most

\[
 N^{o(1)}
 \left(\sum_{i=0}^{J-j}N^{-l_{j+i}(a)-ir(a)}
             +N^{-(J+1-j)r(a)}\right)
 \leq N^{-l_j(a)+o(1)}.                                \tag{9}
\]

This follows term by term from (5), (6). Translating the two actual
arms from their common event time to the center gives the same bound,
since their order \(k\) difference is at most \(N^{-\beta_k+o(1)}\)
and \(l_k\leq\beta_k\). Thus the two center-bin records differ by only
subpowerly many neighbors at every recorded level.

One color index and \(I_1\) determine that arm's entire recorded history.
There are at most \(N^{d+r(1)+o(1)}\) such choices. The other arm's
history has subpowerly many neighbor choices on this **fixed** grid.
Consequently

\[
                      |\operatorname{supp}F_1|
                          \leq N^{d+r(1)+o(1)}.         \tag{10}
\]

Here and later the argument works for any finite \(d\), not just \(d<1\).

For clarity, let \(P_{\rm pre}\) be the event law at this point.
If \(B_N=|\operatorname{supp}F_1|\), discard atoms lighter than
\(1/(B_N\log N)\), losing at most \(1/\log N\). Nesting gives the same
lower mass bound for their ancestors. Dyadically pigeonhole the
**pre-selection** atom masses at every grid level. A fixed number of
choices costs a subpower factor. Pass to a subsequence to obtain

\[
 P_{\rm pre}(F_a=e)=N^{-u_a+o(1)}
\]

uniformly for occurring retained atoms. Then

\[
 0\leq u_a\leq u_c\ (a<c),\qquad u_1\leq d+r(1).
 \tag{11}
\]

Disjoint retained \(c\)-children of a retained \(a\)-parent each have
pre-selection mass at least \(N^{-u_c-o(1)}\), while their parent's mass
is at most \(N^{-u_a+o(1)}\). Their number is therefore at most

\[
                         N^{u_c-u_a+o(1)}.              \tag{12}
\]

Let \(P\) be the final normalized event law. No assertion identifying
its conditional child masses with pre-selection masses is made.
Its two index-time marginal bounds still hold with subpower constants.

## 4. Entropy selects good steps

In an active \(m\)-piece, define \(Z\) to be the pair of order \(m\) bins
at the center of \(I_{A_0}\), with width \(N^{-\beta_m-D_1b}\).
The coarser bins are in \(F_{A_0}\), so

\[
 H(Z\mid F_{A_0})\leq2D_1b\log N+O(1).
\]

All entropies here are under \(P\). For a usable step let

\[
 L_a=\log\frac{P(Z\mid F_{a+Cb})}{P(Z\mid F_a)}
\]

at the sampled value. Its mean is the difference
\(H(Z\mid F_a)-H(Z\mid F_{a+Cb})\geq0\). Summing those differences
and grouping the mesh indices by their residue modulo \(C\) telescopes:

\[
                  \sum_a {\mathbb E}L_a
                      \leq C H(Z\mid F_{A_0}).          \tag{13}
\]

There are \(O(1/b)\) steps. Conditional on the fine state, if \(p\) is
its palette law and \(q\) the coarse palette law, then

\[
 \sum_{p(z)<q(z)}p(z)\log(q(z)/p(z))
 \leq e^{-1}\sum_zq(z)\leq e^{-1}.
\]

Thus the average of \({\mathbb E}(L_a)_+\) is
\(O(b^2\log N+1)\), with constants depending on the fixed trimmed piece.
Markov's inequality twice shows that, except for
\(O(b^{1/2})+o_N(1)\) of the steps, the event
\(L_a>b^{5/4}\log N\) has probability at most \(b^{1/4}\).
Call the other steps good. Writing \(\eta=b^{5/4}\), a good step gives

\[
 P(Z=z\mid F_{a+Cb})\leq N^\eta P(Z=z\mid F_a)
 \tag{14}
\]

except on a set of \(P\)-probability at most \(b^{1/4}\).
This is a statement at the actual fine and coarse states, not
independence of the palette and the past.

## 5. Switching, errors, and positive surviving mass

Fix a good step and make \(m+1\) traversals. Start with \(E^0\sim P\).
At leg \(p+1\), refresh \(\widetilde E^p\) from \(P\) conditional on
\(F_{a+Cb}(\widetilde E^p)=F_{a+Cb}(E^p)\). Keep the running time
\(t_p=t(E^p)\). Choose one of its two arms, then draw \(E^{p+1}\) from
\(P\) conditional only on that arm's color, index, and \(I_a\).
Its time \(t_{p+1}\) is the arrival time. No traversal is required to
move forward in time.

Before killing paths, both \(E^p\) and \(\widetilde E^p\) have law
bounded by \(2^pP\). Refreshing on a state preserves such domination.
For traversal, the law from an adaptively chosen color is bounded by
the sum of the two color kernels; each one, averaged over \(P\),
preserves \(P\). This proves the claim without any restriction on how
the choice depends on hidden history.

A traversal preserves the chosen arm's entire coarse history. The
other arm is a subpower neighbor at both endpoints. A refresh
preserves \(F_a\). After at most \(m+1\) traversals, every possible
coarse state therefore lies in a start-determined set
\(\mathcal V(E^0)\) of subpower cardinality.

Let \(t_a\) be the center of \(I_a\), subtract the degree \(J\) Taylor
polynomial \(T\) of a starting arm there, and normalize

\[
 s=(t-t_a)N^{r(a)},\qquad
 Y_j=N^{l_j(a)}(\varphi-T)^{(j)}(t),\quad 0\leq j<m.
\]

Equation (7) gives the exact relations \(dY_j/ds=Y_{j+1}\) for \(j<m-1\).
For the last coordinate,

\[
                         dY_{m-1}/ds=U+O(N^{-2b}).     \tag{15}
\]

The residual order \(m\) derivative is multiplied by \(N^{\beta_m}\).
Its variation on \(I_a\) is bounded by

\[
 N^{o(1)}
 \left(\sum_{i=1}^{J-m}N^{\beta_m-l_{m+i}(a)-ir(a)}
                  +N^{\beta_m-(J+1-m)r(a)}\right).
\]

Equations (6), (8), and the choice of \(b\) make this smaller than
\(N^{-2b}\). Coarse-neighbor bounds give \(|U|\leq N^{o(1)}\).

Crucially, \(U\) can be **defined as a discretized quantity**, a
deterministic function of the exact start, the current coarse state,
the palette \(Z\), and the chosen color. Translate the order \(m\)
palette and the higher coarse bins at \(A_0\) to \(t_a\).
The palette error is \(O(N^{-D_1b})\); each higher-bin error has a
strict exponent \(l_{m+i}(A_0)+ir(A_0)-\beta_m>0\).
Remainders have a strict gap as well. This gives (15), with room in
the exponents. The normalized gap between the two fresh controls is
\(N^{-o(1)}\). After the first leg choose a control at distance at least
half that gap from the preceding control. This guarantees all
consecutive control gaps are \(N^{-o(1)}\), even for a history-dependent
choice.

At a switch the incoming arm and the refreshed arm have neighboring
fine bins, and the witness and running times are in the same fine
interval. Applying (9) at the **running** time bounds the jump of
\(Y_j\) by

\[
 N^{l_j(a)-l_j(a+Cb)+o(1)}
 =N^{-(1-j/m)Cb+o(1)}\leq N^{-2b}\quad(j<m).
 \tag{16}
\]

This includes the initial comparison to the starting arm.

Kill a path at a refresh if (14) fails. Also kill it if the selected
color-index/interval cell has \(P\)-mass less than
\(\pi_{\kappa,i}|I_a|/\log N\). For each color the sum of those
thresholds over all indices and time intervals is \(1/\log N\).
The un-killed marginal bounds show that all these failures have total
probability
\(O_m(b^{1/4})+O_m(1/\log N)\).
On a retained cell the next conditional time density is bounded by

\[
 \frac{N^{o(1)}\pi_{\kappa,i}}
      {\pi_{\kappa,i}|I_a|/\log N}
                         =N^{o(1)}/|I_a|.              \tag{17}
\]

In normalized time it is at most a uniform subpower constant \(B_N\).
This remains true after conditioning on the entire refreshed event
and its selected index, because the next draw uses only that cell.

Require the \(m\) internal arrival times to be pairwise separated by
\(\rho_N=N^{-o(1)}\), choosing \(\rho_N\) so that \(B_N\rho_N\to0\).
Testing each new time against its predecessors costs at most
\(O_m(B_N\rho_N)\). Consequently, for sufficiently small fixed \(b\)
and then sufficiently large \(N\), the **unnormalized** experiment has
successful probability at least a constant \(c_m>0\), averaged over
starts. Nothing here conditions an earlier kernel on later survival.

## 6. The full-past domination, with the hidden data retained

Fix an exact start \(e_0\), and hence its frame \(T\).
For every \(v\in\mathcal V(e_0)\), push the conditional coarse palette
law \(P(Z\in\cdot\mid F_a=v)\) through each of the two discretized
control maps just defined. Let \(\Lambda_{e_0}\) be the sum of all
these pushforwards. It is a finite atomic measure, with

\[
                       \Lambda_{e_0}(\mathbb R)
                              \leq2|\mathcal V(e_0)|=N^{o(1)}.
 \tag{18}
\]

Let \(h\) denote any full history before a refresh. It fixes a fine
state \(w\) and its coarse ancestor \(v\). The refresh is drawn with
law \(P(\cdot\mid F_{a+Cb}=w)\), independently of the rest of \(h\).
For a nonnegative test \(g(U)\), killing the bad palette values and
bounding the selected color by the **sum** of both possible colors
gives

\[
 \begin{split}
 {\mathbb E}_h[1_{\rm good}g(U)]
 &\leq\sum_z1_{\rm good}(z)P(Z=z\mid w)
                     \{g(u_{v,1}(z))+g(u_{v,2}(z))\}\\
 &\leq N^\eta\int g\,d\Lambda_{e_0}.
 \end{split}                                             \tag{19}
\]

Even a color chosen from the complete refreshed event satisfies the
first inequality: its displayed control is one of those two values.
No disintegration over the selected hidden index is replaced by a
coarse disintegration.

Given that refreshed event and its actual chosen index, (17) bounds
the new-time law. Additional killing can only decrease a
nonnegative integral. Thus the joint successful-step kernel satisfies,
as a measure inequality for almost every admissible full history,

\[
             Q_h(dU\,ds)\leq B_NN^\eta
                                      \Lambda_{e_0}(dU)\,ds.
 \tag{20}
\]

The **same** \(\Lambda_{e_0}\) works for every history from this start.

Here is the precise iteration. For a nonnegative measurable test of
the start and all displayed controls and times, first apply (20) to
its last step with the full preceding history fixed. The resulting
upper integral is a function only of the preceding displayed data,
since the reference measure is common to all histories. Repeat
backwards. Tonelli and simple-function approximation justify the
argument for arbitrary nonnegative measurable tests. For \(m+1\)
steps this yields domination by

\[
              (B_NN^\eta)^{m+1}
                       \prod_{p=1}^{m+1}\Lambda_{e_0}(dU_p)\,ds_p.
 \tag{21}
\]

This is domination of necessary tests, not independence of the true
path. It would generally be false for kernels renormalized after
survival. The finite analogue, with arbitrary hidden full histories,
is proved for every path length in Lean by
`adaptive_domination_from_fibers`.

## 7. Arbitrary-order endpoint geometry

Solve the exact nilpotent system with controls \(U_1,\ldots,U_{m+1}\),
starting time \(s_0\), internal times \(s_1,\ldots,s_m\), and final time
\(s=s_{m+1}\). If \(Y_j^0\) are the initial low jets, the free
contribution is
\(\sum_{k=j}^{m-1}Y_k^0(s-s_0)^{k-j}/(k-j)!\). The control contribution is

\[
 \frac{1}{(m-j)!}
 \left\{U_1(s-s_0)^{m-j}
          +\sum_{p=1}^m(U_{p+1}-U_p)(s-s_p)^{m-j}\right\}.
 \tag{22}
\]

For a constant-control leg the state update is the finite Taylor
flow, valid for positive or negative time increments. Composing
these flows telescopes the endpoint contributions at each switch,
which proves (22) without ordering any times.

At fixed controls the map
\((s_1,\ldots,s_m,s)\mapsto(Y_0,\ldots,Y_{m-1},s)\) is polynomial.
The last row supplies a unit block. The internal-time derivative
matrix has entry

\[
 - (U_{p+1}-U_p)\frac{(s-s_p)^{m-j-1}}{(m-j-1)!}.
\]

Extract the column factors and factorial row factors, reverse the
rows, and apply the Vandermonde identity. Its absolute determinant is

\[
 |\det D\Phi|=
 \frac{\prod_{p=1}^m|U_{p+1}-U_p|
       \prod_{p<q}|s_p-s_q|}{\prod_{k=0}^{m-1}k!}.
 \tag{23}
\]

The Lean declaration `endpoint_abs_det` proves this matrix identity
for every natural \(m\), with arbitrary real column factors and
coordinates. Substitution \(x_p=s-s_p\) gives the displayed signs.
On successful paths, (23) is at least \(N^{-o(1)}\).

There is a uniform finite bound \(M_m\) on regular preimage
multiplicity. To check the external theorem's hypotheses explicitly,
for any target \(y\) take the polynomials \(\Phi_i-y_i\) defining its
fiber and the additional polynomial \(\det D\Phi\). Their number,
degree and dimension are fixed in terms of \(m\), independently of
the controls, frame, start and target. Basu's Theorem 2.17 bounds the
component counts of the positive and negative determinant sign
conditions on that fiber. At each such point the inverse function
theorem makes the fiber locally a singleton, so all these components
are singleton points. Singular positive-dimensional components, if
present, are irrelevant. This proves the needed bound without
assuming every polynomial fiber is finite.

It follows for every measurable target \(T_*\) and separated fixed
controls that

\[
 \left|\{(s_1,\ldots,s_m,s):\Phi(s_1,\ldots,s_m,s)\in T_*,
                     \ |\det D\Phi|\geq N^{-o(1)}\}\right|
                      \leq N^{o(1)}|T_*|.              \tag{24}
\]

For completeness, cover the regular locus by countably many open
sets where \(\Phi\) is a diffeomorphism and partition it into disjoint
measurable pieces subordinate to that cover. Change variables on
each piece. Summing the reciprocal-Jacobian integrals counts each
target point at most \(M_m\) times, proving (24). This also explains
why no unproved injectivity assumption is hidden in the argument.

## 8. From the actual sampling law to a target-volume bound

Let \(c=a+b\). A possible final child state \(F_c\) fixes its own
interval \(I_c\) and both Taylor-bin records there. For either final
color, at each final time in that interval, translate that arm's bins,
subtract \(T\), and apply the coarse normalization. Equation (9) at
level \(c\) gives width

\[
 N^{l_j(a)}
 \left(\sum_{k=j}^J N^{-l_k(c)-(k-j)r(c)}
                  +N^{-(J+1-j)r(c)}\right)N^{o(1)}
                   \leq N^{-(1-j/m)b+o(1)}
 \quad(0\leq j<m).                                     \tag{25}
\]

The normalized final-time interval has length \(N^{-b/m+o(1)}\).
The accumulated simulation error from (15), (16) is
\(O_m(N^{-2b+o(1)})\), since the normalized times stay bounded and the
system is a fixed-dimensional triangular linear system. It fits
inside every width in (25). There is no replacement of the child's
time interval by the entire coarse interval.

Fubini therefore bounds one child's target volume, even if its center
moves with final time, by

\[
 N^{-bA_m+o(1)},\qquad
 A_m=\frac1m+\sum_{j=0}^{m-1}(1-j/m)
                     =\frac1m+\frac{m+1}{2}.           \tag{26}
\]

Every successful endpoint belongs to the target of its actual final
arm and child state. Equations (12) and (18) show that the union over
both colors and all possible coarse neighbors of the start has volume
at most

\[
                  N^{u_{a+b}-u_a-bA_m+o(1)}.            \tag{27}
\]

This union is determined by the start and the retained state records.
For a fixed control tuple, membership of the exact endpoint in its
slightly enlarged union, along with the time and control separations,
is a necessary test of displayed data alone. Apply (24) to that test,
then integrate against \(\Lambda_{e_0}^{m+1}\) in (21). Atomic controls
cause no problem: (24) is uniform in the fixed controls.
All masses in (18), density factors \(B_N\), and inverse Jacobian
factors are subpower. Hence

\[
 P(\text{success}\mid E^0=e_0)
 \leq N^{u_{a+b}-u_a-bA_m+(m+1)b^{5/4}+o_N(1)}.          \tag{28}
\]

This is the promised sampling-to-volume implication, not a
determinant-only argument. Its bound is uniform over starts.
Average (28), use the positive success mass from Section 5, and take
the fixed-grid \(N\)-limit. Every good step satisfies

\[
 u_{a+b}-u_a
 \geq b\left(\frac1m+\frac{m+1}{2}\right)
                            -(m+1)b^{5/4}.             \tag{29}
\]

The source weakens \((m+1)/2\) to 1. Retaining it gives Theorem 2.

## 9. Limits, contradiction, and robustness

For each fixed trimmed grid take a subsequence in \(N\) fixing the
finite collection of good steps and the mass exponents. Sum (29) on
them; all uncounted increments of \(u\) are nonnegative by (11).
The exceptional fraction is \(O(b^{1/2})\); unusable endpoint steps
cost \(O_J(Cb)\) length; and the total \(b^{5/4}\) error is \(O_J(b^{1/4})\).
Only now send \(b\to0\), and then remove the trims.
If \(m(a)\) denotes the active order except at the finitely many
breakpoints, (11) gives

\[
 d+r(1)\ \geq\int_0^1
                \left(\frac1{m(a)}+\frac{m(a)+1}{2}\right)\,da.
\]

Since \(r(0)=0\) and \(r'=1/m(a)\) almost everywhere, this simplifies to

\[
                    d\geq\frac12\int_0^1(m(a)+1)\,da\geq1.
 \tag{30}
\]

Mass exponents may depend on the grid; only their uniform upper bound
\(d+r(1)\) is used. Thus no incompatible-grid limits of individual
conditional laws or masses have been assumed. Equation (30)
contradicts the original \(d\leq d_0<1\), proving Theorem 1.

For the pure-type hypotheses (1), \(\beta_j\geq1-j/m\) for \(j<m\)
and \(\beta_m=0\). For \(a<1\), the order \(m\) line strictly dominates
all others: lower orders give at most \(1/m+(a-1)/j<a/m\), and higher
orders give at most \(a/j<a/m\). Therefore \(r(a)=a/m\) and
\(m(a)=m\) on \((0,1)\). Equation (30) gives (2).
The proof did not require a common cap \(d<1\) before (30), so this
extension is not obtained by applying Theorem 1 outside its range.

To specify fixed-power robustness precisely, in Theorem 1 replace
the list cap by \(N^{d_0+\epsilon}\), every subpower bound by
\(N^\epsilon\), the value bound by \(N^{-1+\epsilon}\), and the gap
lower bound by \(N^{-\epsilon}\). If no \(\epsilon_*>0\) excluded these
configurations for all sufficiently large \(N\), then for every
integer \(n\) one could choose a configuration at \(N_n\geq n\) with
\(\epsilon_n\leq1/n\). Taking \(N_n\to\infty\) makes **all** losses
subpower and gives the forbidden sequence with exponent cap \(d_0\).
Monotonicity then gives uniformity for \(0<\epsilon\leq\epsilon_*\).
The same diagonal argument, with \(d_0<(m+1)/2\) and the inequalities
in (1) relaxed by \(N^\epsilon\), proves Theorem 2's robustness.
This proves existence of a tolerance, not an explicit numerical value.

## 10. An unbounded exact construction proving sharpness

Fix any \(m\geq1\) and integer \(L\geq2\), and put \(N=L^m\).
For \(0\leq j<m\), let

\[
 p_j=m-j,\quad C_j={m\choose j},\quad
 A_j=\{0,\ldots,L^{p_j}-1\},\quad
 B_j=\{-C_jL^{p_j},\ldots,(C_j+1)L^{p_j}-1\}.
\]

Set \(A=\prod_j A_j\), \(B=\prod_j B_j\), and

\[
 f_{1,a}(t)=t^m+\sum_{j=0}^{m-1}a_j L^{-p_j}t^j,\qquad
 f_{2,b}(t)=\sum_{j=0}^{m-1}b_j L^{-p_j}t^j.
 \tag{31}
\]

Write \(M=|A|\) and \(C_*=\prod_j(2C_j+1)\). Exactly,

\[
 M=L^{m(m+1)/2}=N^{(m+1)/2},\qquad |B|=C_*M.
 \tag{32}
\]

Choose \(t\) uniformly on \([0,1]\) and \(a\) uniformly on \(A\),
independently. For \(n=\lfloor Lt\rfloor\) (endpoints are immaterial), set

\[
 c_j(n)={m\choose j}(-n)^{m-j},\qquad b_j=a_j-c_j(n).
\]

Because \(|c_j(n)|\leq C_jL^{p_j}\), this \(b\) lies in \(B\).
The binomial theorem gives the **exact identity**

\[
                     f_{1,a}(t)-f_{2,b}(t)=(t-n/L)^m.
 \tag{33}
\]

On each time cell \(0\leq t-n/L\leq1/L\). Thus the value gap is at most
\(N^{-1}\); the order \(j<m\) gap is at most
\(\frac{m!}{(m-j)!}N^{-(1-j/m)}\); and the order \(m\) gap is exactly
\(m!\). Coefficients in (31) are bounded in terms of \(m\), so all
derivatives through any fixed \(J+1\) are bounded by a constant.

With uniform **reference** priors \(\pi_{1,a}=1/M\) and
\(\pi_{2,b}=1/(C_*M)\), the actual marginals satisfy

\[
 Q_1(a,dt)=M^{-1}dt,\qquad
 Q_2(b,dt)=M^{-1}1_{\{b+c(\lfloor Lt\rfloor)\in A\}}dt
                                  \leq C_*\pi_{2,b}dt. \tag{34}
\]

For a fixed cell and \(b\) there is at most one possible \(a\), which
proves (34). The second index is strongly correlated with the first
index and time. No claim of independence of the two indices is made.
One constant
\(\max\{C_*,m!(2^m+m+1)\}\) bounds all losses and derivatives.
Equations (31)--(34), valid for **every** \(L\), establish sharpness.
These are not counterexamples to the manuscript, since their exponent
is at least 1.

## 11. Exact replay and what remains unchecked

Run, from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/two_color_matching/verify.py
```

The script reconstructs the symbolic matrices, signed-flow endpoint
identities, rational scale bookkeeping, adaptive hidden-history
examples, and polynomial construction; checks the preserved typed
Jacobian result against its exact request; and checks freshness and
success of the sanctioned Lean record. Its deterministic output must
match `exact_certificate.json`. The finite checks are deliberately
labelled finite. General proofs are Sections 2--10 and the universal
Lean declarations, not extrapolations from those checks.

The Jacobian adapter was discovered and its exact typed determinant
contract inspected before custom certificate code. One bounded
operation, `matrix.symbolic.determinant.compute`, was run on the order
3 derivative matrix. `jacobian_payload.json` and `jacobian_result.json`
preserve the exact request, typed output, server version, protocol and
absence of a structured error. It establishes one exact polynomial
calculation, not the general-order claim.

The Lean run is attached to claim `CORE074`, not `MATCH074` or
`SHARP074`. Its statement-fidelity document names its exact coverage and
exclusions. Earlier unsuccessful compiler runs are inconclusive
implementation feedback, not mathematical refutations.

The remaining certification step is Host-invoked independent Reviewer
reading/replay, including the continuous proof, the source fidelity,
the cited component theorem, and the sharp extension's significance
and novelty. No independent approval is recorded by the Engineer.
