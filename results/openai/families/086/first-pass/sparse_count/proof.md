# An explicit dimension-uniform sparse-count theorem

## Statement and scope

Use the data and the **five complete hypotheses** of
`lem:finite-sparse-count` in the staged October 5, 2026 manuscript,
`build/sections/counting.tex`:

1. Two labels in different core roles determine at most one full core tuple,
   with at most \(L\) scale occurrences.
2. In the three-core case, each label's incidence at scale \(s\) is at most
   \(w_s\), where \(w_s\geq0\) and \(\sum_s w_s\leq M\).
3. Distinct same-role labels occurring at scales \(s,t\) obey
   \(|a-a'+n\cdot\zeta|>\Sigma\max(R_s,R_t)\) for every integer
   \(\|n\|_\infty\leq Q\).
4. For every core triple, with excluded role \(l'\) and
   \(\alpha_i=i-l'\), every tuple at scale \(s\) has an integer
   \(\|n\|_\infty\leq B\) such that
   \(\mu R_s\leq|\sum_i\alpha_i a_i+36n\cdot\zeta|\leq\nu R_s\).
5. At every occupied scale, all integer \(\|n\|_\infty\leq Q\) satisfy
   \(|n\cdot\zeta|\notin[\mu R_s/1000,1000\nu R_s]\).

Here there are three or four core roles in \(\{0,1,2,3\}\), at most \(M\)
injectively real-valued labels per core role, finitely many dyadic scales,
\(M,L,B\geq1\), and \(0<\mu\leq1\leq\nu\).
Put \(D=d+1\) and \(\ell=1+\log_2(2+D^2\nu/\mu)\).

**Theorem.** Explicit admissible constants are
\[
 C_{\rm res}=2^{40},\qquad C=2^{160}.
\]
With \(Q\geq C_{\rm res}D^2B\) and
\(\Sigma\geq C_{\rm res}D^2\nu\), for every \(0<\delta\leq1\),
\[
 \sum_{s:N_s\leq\delta M^2}N_s
 \leq 2^{160}\ell L^{29}\delta^{1/810}M^2.                 \tag{1}
\]
Consequently the complete stated bound with exponent \(1/2080\) holds.
The numerical exponent improves the strongest prior result relevant here,
namely the staged manuscript's \(1/2080\), by balancing its auxiliary
powers. No claim of global literature novelty or publishability is made
before independent review.

This is a universal finite theorem, not a finite no-witness experiment.
It does **not** verify the frequency-test application, `prop:thin-count`,
`prop:core-estimate`, or `thm:main`. No false manuscript assertion is
identified in this proof.

## Grid reduction

It is enough first to prove a grid version with reserves \(2^{30}D^2B\)
and \(2^{30}D^2\nu\), and the narrower pure-shift forbidden interval
\([\mu R_s/100,100\nu R_s]\). All quantities in this paragraph refer to
that grid version until the final paragraph.

If any scale is occupied, its reciprocal scale is positive: hypothesis 4
forces \(R_s\geq0\), and \(R_s=0\) contradicts hypothesis 5 at \(n=0\).
Otherwise (1) is immediate.

The grid has step \(h>0\); label and frequency coordinates are multiples
of \(6h\). For all blocks choose \(h\) sufficiently small that
\[
 N_0=\lceil32B\rceil\leq33B,\qquad
 \epsilon_{\mathfrak b}
   =h\lceil16\nu R_{\mathfrak b}^+/h\rceil
   \leq17\nu R_{\mathfrak b}^+ .
\]
Define finite symmetric subsets of \(h\mathbb Z\)
\[
 U_{\mathfrak b}(t)=
 \{6n\cdot\zeta+u:\|n\|_\infty\leq tN_0,\
     u\in h\mathbb Z,\ |u|\leq t\epsilon_{\mathfrak b}\}.
                                                               \tag{2}
\]
They contain zero and \(U(t)+U(t')\subseteq U(t+t')\).
The divisions by \(1,2,3\) below stay on the grid.

## A quantitative four-path lemma

A bipartite graph with parts of size at most \(M\), at least
\(\eta M^2\) edges, and a proper coloring with at most \(M\) colors,
has a subset \(B_0\) of the first part with
\[
 |B_0|\geq\eta M/8
\]
such that each ordered pair of its vertices has at least
\(2^{-28}\eta^5M^3\) four-step paths with distinct ordered color
quadruples. Repeated vertices in a path are allowed.

Indeed pad the second part to \(m=\lceil M\rceil\leq2M\), and let
\(Y\) be the neighborhood of a uniformly random vertex. Then
\(\mathbb E|Y|^2\geq\eta^2M^2/4\). Call an ordered pair bad if its
codegree is less than \(2^{-12}\eta^2M\). Its chance to lie in \(Y^2\)
is its codegree divided by \(m\), so the expected number of bad pairs
is at most \(2^{-12}\eta^2M^2\). Some \(Y\) therefore satisfies
\[
 |Y|^2-100\,\#\{\text{bad pairs in }Y^2\}
 \geq(1/4-100/4096)\eta^2M^2>\eta^2M^2/8.
\]
Delete vertices with more than \(|Y|/4\) bad partners. Fewer than
\(|Y|/25\) vertices disappear. The retained set has size at least
\(\eta M/8\); any two retained vertices have at least \(|Y|/2\)
common good partners in \(Y\). Each partner gives at least
\((2^{-12}\eta^2M)^2\) choices of the two intermediate vertices
in the other part. This exceeds the asserted path count.
Starting at a fixed vertex, an ordered color sequence determines
the entire path by proper coloring, proving color-sequence injectivity.

## Blocks and difference covers

Restrict throughout to the scales with \(N_s\leq\delta M^2\).
Hypothesis 1 gives total mass at most \(LM^2\), and total incidence
at a fixed core label at most \(LM\).
Take \(0<\alpha\leq1/4\), \(0<\kappa<1\), with \(\delta\leq\alpha/2\).
In descending reciprocal-scale order, greedily make blocks of mass at
most \(\alpha M^2\). Except possibly for the last, each has mass greater
than \((\alpha-\delta)M^2\), so their number satisfies
\[
 J_0\leq3L/\alpha.                                           \tag{3}
\]

In one role and block, while uncovered-label incidence exceeds
\(\kappa M^2\), project to a simple bipartite graph in that role
and another core role, keeping one scale witness per edge.
It has at least \((\kappa/L)M^2\) edges. Color by a third core label;
hypothesis 1 makes this a proper coloring. Apply the four-path lemma
with \(\eta=\kappa/L\).

Alternating the four annular relations on a path cancels the middle
first-role label and the two second-role labels. Dividing by the
first-role coefficient gives
\[
 a-a'\in q(c_1,c_2,c_3,c_4)+U_{\mathfrak b}(1).              \tag{4}
\]
The scalar error is at most \(4\nu R_{\mathfrak b}^+\).
The shift in (2) has index at most \(24B\): the four original
indices add with signs, and \(36/\alpha_i=6(6/\alpha_i)\).
All nonzero progression coefficients divide 6. Thus (4) follows
with no rounding error.

A maximal packing of \(B_0-B_0\) with distinct differences outside
\(U_{\mathfrak b}(2)\) has at most \(2^{28}\eta^{-5}M\) points.
Otherwise the at least \(2^{-28}\eta^5M^3\) color quadruples for
each packed difference would exceed the available \(M^4\).
Maximality gives a cover by that many translates of \(U(2)\).
Remove \(B_0\); there are at most \(8\eta^{-1}\) iterations.
Consequently, except for \(\kappa M^2\) uncovered occurrences per role
and block, the labels are covered by at most
\[
 K=2^{32}(L/\kappa)^6                                      \tag{5}
\]
sets \(B\), each with \(B-B\) covered by at most \(KM\)
translates of that block's \(U(2)\).

Discard occurrences with an uncovered own-block label; this costs
at most \(4J_0\kappa M^2\). Call a role future if its label belongs
to a cover set of that role in a strictly later block.
Nonfuture labels are disjoint between blocks in each core role.
For the side role use the nonfuture masses
\(m_l^{\mathfrak b}=\sum_{s\in\mathfrak b}w_s\); these also sum to at
most \(M\).

Occurrences with fewer than three future roles have two nonfuture roles.
For each fixed pair their mass in a block is at most
\(\min(\alpha M^2,Lm_i^{\mathfrak b}m_j^{\mathfrak b})\).
Using \(\min(u,v)\leq\sqrt{uv}\) and Cauchy--Schwarz, their total
mass over the at most six pairs is at most
\[
 6\sqrt{L\alpha}\,M^2.                                    \tag{6}
\]
For a core/side pair the same inequality follows directly from
hypothesis 2; no nonexistent side label is introduced.

Assign each remaining occurrence one triple of future core roles and
one future cover set \(B_i\) for each. There are at most
\[
 4J_0^4K^3                                                \tag{7}
\]
combinations. Fix one of mass \(\rho M^2>0\).
Here \(0<\rho\leq\alpha\leq1\).

## Four ranges and polynomial reserves

Set
\[
 \Gamma=2^{32}D^2\nu/\mu .
\]
If \(\rho\leq2^{14}\delta\ell\), retain that bound.
Otherwise cut the ordered mass at its quartiles and omit bins
crossing the three cuts. Each of the four remaining ranges has mass
at least \(\rho M^2/8\): a range loses at most \(2\delta M^2\)
from its quarter, and \(\rho>16\delta\).

Write \(R^\#\) for the largest second-range reciprocal scale.
The first range supplies anchor sets \(A_i\subseteq B_i\) with
\[
 |A_i|\geq\rho M/(8L),                                   \tag{8}
\]
since fixed-label incidence is at most \(LM\). Distinct anchors
are separated modulo every reserved shift by more than
\(\Sigma R^\#\).
The last range supplies distinct actual triples \(F\), each with
one scale witness, and
\[
 |F|\geq\rho M^2/(8L).                                   \tag{9}
\]
Each triple has at most \(L\) scale occurrences by hypothesis 1.

Each range contains at least \(\rho/(8\delta)\) occupied dyadic bins.
There are more than \(2^{11}\ell\) bins in the third range, whereas
\(\log_2\Gamma=32+\log_2(D^2\nu/\mu)\leq32\ell\).
Thus every second-range scale is at least \(\Gamma\) times every
last-range scale and every future-block scale. Greedily thin the
second range to ratio at least \(\Gamma\).
Each selection excludes at most
\(1+\lceil\log_2\Gamma\rceil\leq64\ell\) occupied bins, leaving
actual triples \(t_v\), at their scale witnesses \(R_v\), with
\[
 q\geq\rho/(512\delta\ell).                              \tag{10}
\]

For each future block, subdividing the \(d\) index intervals and the
scalar interval covers \(U(t)\) by at most \((2t+1)^D\) translates
of \(U(1)\). There is an odd \(1\leq H_i\leq100D^2\) such that
\[
 |U_i(H_i+2)|\leq2|U_i(H_i)|.                            \tag{11}
\]
For otherwise iteration to \(100D^2+1\) gives growth greater than
\(2^{50D^2}\), while the subdivision bound gives at most
\[
 (200D^2+3)^D\leq(256D^2)^D
 \leq2^{8D+2D^2}<2^{50D^2}.
\]
Here \(D\leq2^D\) for integers \(D\geq1\); its induction step is
\(D+1\leq2D\). This preliminary exponential bound chooses \(H_i\)
only; it is not multiplied into any count.

The anchor translates \(a+U_i(H_i)\) are disjoint. An intersection
would express their difference modulo a shift of index at most
\(39600D^2B\), with scalar error at most \(3400D^2\nu R^\#\).
Both fit the \(2^{30}\) reserves and contradict (8)'s separation.
Let \(Z_i=A_i+U_i(H_i)\). The difference cover and (11) give
\[
 |Z_i-B_i|\leq2KM|U_i(H_i)|,\qquad
 |Z_i|=|A_i||U_i(H_i)|,
\]
so a nonempty \(X_i\subseteq Z_i\) minimizing
\(r_i=|X_i-B_i|/|X_i|\) satisfies
\[
 r_i\leq r_0:=16KL/\rho.                                \tag{12}
\]

## Minimal growth, proved rather than assumed

For a finite \(C=\{c_1,\ldots,c_m\}\), let \(X_j\) consist of those
\(x\in X_i\) for which \(x+c_j\) is not in an earlier translate of
\(X_i\). Then \(|X_i+C|=\sum_j|X_j|\).
Every point of \((X_i\setminus X_j)-B_i+c_j\) already lies in an
earlier translate of \(X_i-B_i\). Thus the number of new points
at step \(j\) is at most
\[
 |X_i-B_i|-|(X_i\setminus X_j)-B_i|
 \leq r_i|X_i|-r_i|X_i\setminus X_j|=r_i|X_j|.
\]
Minimality justifies the inequality; when the complement is empty
both its size and its difference set size are zero.
Consequently \(|X_i-B_i+C|\leq r_i|X_i+C|\).
Inducting with \(C=-(m-1)B_i\) proves
\[
 |X_i-mB_i|\leq r_i^m|X_i|.                             \tag{13}
\]
This is the additive specialization of Petridis,
arXiv:1101.3507v3, Proposition 2.1 and Section 3; the displayed
argument discharges that external dependency.

Some anchor translate contains \(Y_i\subseteq X_i\) with
\(|Y_i|\geq|X_i|/M\). Its differences lie in \(U_i(2H_i)\).
If \(P\subseteq mB_i\) has distinct differences outside \(U_i(2H_i)\),
the sets \(Y_i-p\), \(p\in P\), are disjoint subsets of \(X_i-mB_i\).
Therefore
\[
 |P|\leq r_i^m M\leq r_0^mM,\qquad m=2,3.               \tag{14}
\]
Maximal such packings cover their ambient sumsets by translates of
the same \(U_i(2H_i)\).

## Slab cover: why there are only two factors of \(M\)

Consider the outputs in \(2B_1\times2B_2\times2B_3\) satisfying
\[
 \left|\sum_i\alpha_i x_i+36n\cdot\zeta\right|
 \leq2\nu R^\#,\qquad\|n\|_\infty\leq2B.                \tag{15}
\]
By (14), cover the first two sumsets by at most \(r_0^2M\) translates
each of \(U_i(2H_i)\). Over a fixed pair, possible third coordinates
belong to \(2B_3\) and to
\[
 c+\{n\cdot\zeta:\|n\|_\infty\leq2^{18}D^2B\}
       +[-2^{15}D^2\nu R^\#,2^{15}D^2\nu R^\#].          \tag{16}
\]
The divided indices are integral because \(\alpha_3\) divides 6.
Direct bounds before rounding to powers of two are
\[
 36(2\cdot100D^2)(33B)+72B\leq237672D^2B<2^{18}D^2B,
\]
\[
 (2\cdot3\cdot2\cdot100\cdot17D^2+2)\nu R^\#
 \leq20402D^2\nu R^\#<2^{15}D^2\nu R^\#.
\]

Take a maximal \(U_3(2H_3)\)-packing \(P\) of this local set.
The **indexed** sums \(a+p\), \(a\in A_3,p\in P\), are distinct
and still form such a packing. Equal anchors reduce to the defining
property of \(P\). For distinct anchors, a collision would put their
difference modulo a shift of index at most
\[
 (2\cdot2^{18}+39600)D^2B=563888D^2B<2^{20}D^2B
\]
within error
\[
 (2\cdot2^{15}+3400)D^2\nu R^\#
   =68936D^2\nu R^\#<2^{17}D^2\nu R^\#.
\]
This contradicts anchor separation, including when two indexed sums
are equal. The zero shift/error belong to the collision neighborhood.
This injectivity is essential before multiplying cardinalities.

Now \(A_3+P\subseteq3B_3\), so (14) and (8) imply
\[
 |A_3||P|\leq r_0^3M,\qquad |P|\leq8r_0^3L/\rho.
\]
Maximality covers the local third-coordinate set. Multiplying the
three numbers of boxes gives a slab cover with at most
\[
 8r_0^7(L/\rho)M^2
   =2^{31}K^7(L/\rho)^8M^2                             \tag{17}
\]
translates of \(\prod_i U_i(2H_i)\). The factor \(M\) is removed
by the anchors, not by an unjustified assertion about slab dimension.

## Separation of every indexed translated output

All \(q|F|\) indexed triples \(t_v+f\) lie in (15): add their annular
relations, whose indices add to at most \(2B\) and whose upper
residuals sum to at most \(2\nu R^\#\).

In a single translation, distinct \(f,f'\) differ in a label coordinate.
If their outputs share a cover box that coordinate difference belongs
to \(U_i(4H_i)\). Its shift index is at most \(79200D^2B\), and its
scalar error at most \(6800D^2\nu R_{\mathrm{future},i}^+\).
The last-range witnesses are above this future scale. Thus hypothesis 3
and \(\Sigma\geq2^{30}D^2\nu\) rule out this collision without needing
an additional last-range/future scale margin.

For different translations let \(R\) be the larger selected scale.
The dominant annular residual has magnitude in \([\mu R,\nu R]\).
The other three residuals have total absolute value at most
\[
 3\nu R/\Gamma\leq(3/2^{32})\mu R<\mu R/100.            \tag{18}
\]
Same-box coordinate differences would lie in \(U_i(4H_i)\).
Their weighted scalar errors total at most
\[
 9\cdot6800D^2\nu\max_i R_{\mathrm{future},i}^+
 \leq(61200/2^{32})\mu R<\mu R/100.                    \tag{19}
\]
Here using 9 for the sum of the three absolute coefficients is a
safe bound (the actual maximum is 6).
The original four residual shifts and box shifts combine to an
integer index of size at most
\[
 (144+9\cdot79200)D^2B=712944D^2B<2^{20}D^2B\leq Q.
\]
Equations (18)--(19) force the absolute value of this pure shift into
\[
 [49\mu R/50,\ 51\nu R/50]
 \subseteq[\mu R/100,\ 100\nu R],
\]
contradicting hypothesis 5 of the grid version. This argument also
excludes exact equal outputs with different indices \(v\).
Thus every cover box contains at most one indexed output.

The Lean theorems `anchor_sums_separated`, `anchor_sum_card`, and
`annular_not_near` certify the universal algebraic packing mechanisms
in these two sections, for arbitrary dimension and arbitrary additive
integer-shift homomorphisms. The anchor theorem uses the exact collision
predicate \(V(x)=[x\in U_3(2H_3)]\), requiring only its inclusion in a
bounded all-shift neighborhood; it does not strengthen the packing
hypothesis to exclusion from that larger neighborhood.
Their statement fidelity is documented separately. They do not encode
the entire graph and block proof.
The Jacobian LP independently minimizes the normalized other-residual
minus box-error contribution in (18)--(19). Its optimum \(-1/50\),
added to the dominant-residual lower bound 1, gives \(49/50\).
Its result is replayed exactly, not used as a proof of the full
sparse-count theorem.

## Density estimate and optimized powers

By (9)--(10), the number of indexed outputs is at least
\(2^{-12}\rho^2M^2/(\delta\ell L)\).
Comparing with (17) gives
\[
 \rho^{10}\leq2^{43}\delta\ell K^7L^9.
\]
Since \(\ell,K,L\geq1\), taking tenth roots gives
\(\rho\leq2^5\ell KL\delta^{1/10}\).
The previously omitted case satisfies
\(\rho\leq2^{14}\delta\ell
 \leq2^{14}\ell KL\delta^{1/10}\).
Hence the uniform bound is
\[
 \rho\leq2^{14}\ell KL\delta^{1/10}.                    \tag{20}
\]
Combine (3), (5)--(7), and (20):
\[
 M^{-2}\sum_sN_s
 \leq12L\kappa/\alpha+6\sqrt{L\alpha}
       +324\cdot2^{142}\ell L^{29}
                    \alpha^{-4}\kappa^{-24}\delta^{1/10}.       \tag{21}
\]

Put \(x=\delta^{1/810}\), \(\alpha=x^2\), \(\kappa=x^3\).
For \(x\leq1/2\), the required \(\delta\leq\alpha/2\) holds.
The three powers in (21) are respectively \(x\), \(x\), and
\[
 x^{-8}x^{-72}x^{81}=x.
\]
Also \(\sqrt L\leq L\leq\ell L^{29}\). Thus the grid bound is
\[
 \sum_sN_s
 \leq(18+324\cdot2^{142})\ell L^{29}xM^2
 \leq2^{152}\ell L^{29}xM^2.                            \tag{22}
\]
For \(x>1/2\), use the total-mass bound \(LM^2\) and
\(1<2x\), which is stronger than needed for (22).
The optimization improves the manuscript's auxiliary choice
\(\alpha=\delta^{1/1040},\kappa=\alpha^2\); it does not depend on
any extra structure of its frequency-test application.

Finally return to arbitrary real input. There are finitely many labels,
scales, and integer shifts of size at most \(Q\). Approximate the real
labels and frequency coordinates by multiples of \(6h\), leaving the
combinatorial data unchanged. For sufficiently small \(h\), distinct
labels stay distinct, separation holds with \(\Sigma'=\Sigma/2\),
annuli hold with \(\mu'=\mu/2,\nu'=2\nu\), and the forbidden interval
\([\mu'R_s/100,100\nu'R_s]\) is retained: it is strictly inside
the original \([\mu R_s/1000,1000\nu R_s]\).
The original \(2^{40}\) reserves imply the grid's \(2^{30}\) reserves
even after these relaxations. The counts, \(M,L,\delta\), and dyadic
scales do not change.
Moreover \(\ell'\leq\ell+2\leq2\ell\).
Applying (22) proves (1), with room to spare since \(2^{153}<2^{160}\).
No limiting cardinality assertion, lattice rank assumption, or
dimension-dependent covering factor is being suppressed. \(\square\)
