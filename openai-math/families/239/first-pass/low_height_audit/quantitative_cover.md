# A quantitative low-height covering theorem

## Result and status

The proof below verifies the full covering assertion in U,
`sections/04-low-height-cover.tex`, and obtains a stronger height range.
It uses the same minimizing-chain idea, but makes the flag estimate
explicit and removes all fiber costs for single-dimensional drops.
It is a mathematical proof offered for independent review, not a claim
that a finite computation proves an infinite covering theorem.
The Lean file certifies the exact finite-block amortization and algebra
specified in `statement_fidelity.md`; it does not formalize this entire proof.
Neither singularity theorem is proved here. Originality has not been
independently established.

Throughout, lattices carry their induced Euclidean volumes, quotients mean
orthogonal projection, and a primitive sublattice is the intersection of its
real span with its ambient lattice. Put \(L=\log N\).

**Theorem Q (quantitative cover).** Suppose \(N\ge16\) is an integer,
\[
 0<a\le1/40,\qquad N^{-2/5}\le a,\qquad
 aL\ge\log(10(L+2)).
 \tag{Q0}
\]
For every real \(b\ge0\), and every integer \(0\le m\le N\), a list
\(\mathcal C(N,m,a,b)\) of rational subspaces of \(\mathbb R^m\),
independent of the space to be approximated, covers every rational
\(W\) with \(\log H(W)\le b\) within distance \(b/(aL)\), and satisfies
\[
 \log_2|\mathcal C(N,m,a,b)|\le \lceil Q(N,a,b)\rceil,\qquad
 Q=10000\left[
 NL+N^2N^{-2a}(L+2)^2+aNb+\frac{b^2}{a^3L}
 \right].
 \tag{Q1}
\]
The empty ambient space is included. The list is existential and finite;
no polynomial-time construction is asserted.

**Corollary R (larger height range).** For all sufficiently large integers
\(N\), uniformly for \(0\le m\le N\), a single list covers every
\[
 \log H(W)\le N(\log N)^{1/9}
\]
within distance \(N(\log N)^{-2/3}\), with
\[
 \log_2|\mathcal C|\le 100000N^2(\log N)^{-1/9}.
 \tag{R}
\]
This implies the exact quantifiers and both bounds of U, Theorem 4.1,
for every fixed \(D,A>0\). The list in (R) does not even depend on
\(D,A\); only the threshold for applying it to their height budget does.

## 1. Lattice and minimization facts

For a rational space \(V\), a primitive integer basis has a nonzero
integer exterior product. Consequently \(H(V)\ge1\), and there are only
finitely many rational subspaces of \(\mathbb R^m\) of height at most a
fixed constant: in each rank their primitive Pluecker vectors lie in a
bounded ball of an integer lattice and determine the space, up to sign.

For rational \(X,Y\),
\[
 H(X+Y)H(X\cap Y)\le H(X)H(Y).
 \tag{1}
\]
Indeed, extend a basis of the primitive lattice of \(X\cap Y\) to bases
of those of \(X,Y\). Projection of the latter complement onto \(X^\perp\)
can only decrease its volume. The concatenated basis generates a
finite-index sublattice of the lattice of \(X+Y\); saturation can only
decrease its determinant. The quotient determinant formula then gives
(1). This proves the height submodularity needed here, rather than
assuming the surrounding manuscript's lattice lemmas.

For primitive \(J\subseteq M\), extension of an integer basis of \(J\)
to a basis of \(M\), followed by an orthogonal block determinant, gives
\[
 \det(M/J)=\det M/\det J,\qquad
 (M/J)^*=M^*\cap(\operatorname{span}J)^\perp.
 \tag{2}
\]
Thus, if \(V\subseteq U\) are rational and
\(\Lambda=(U\cap\mathbb Z^m)^*\),
\[
 \det(\Lambda\cap V^\perp)=H(V)/H(U).
 \tag{3}
\]
Notice the order of the ratio. The three-dimensional exact example in
`verify.py` checks it in a nonunimodular ambient lattice.

Write \(h(V)=\log_N H(V)\). For a rational \(P\), minimize
\(F_P(V)=h(V)+a\,d(V,P)\). The zero competitor restricts the search to
\(H(V)\le N^{am}\), so a minimum exists. For \(P'\subseteq P\), dimension
identities and
\[
 (X\cap P)+(Y\cap P')\subseteq(X+Y)\cap P,\quad
 (X\cap P)\cap(Y\cap P')=X\cap Y\cap P'
\]
imply
\[
 d(X+Y,P)+d(X\cap Y,P')\le d(X,P)+d(Y,P').
 \tag{4}
\]
For \(P'=P\), (1) and (4) show that the sum and intersection of
minimizers are minimizers. Finiteness supplies a greatest minimizer
\(U(P)\). Applying (1) and (4) to the greatest old and new minimizers,
and using minimality for both terms, gives
\[
 P'\subseteq P\quad\Longrightarrow\quad U(P')\subseteq U(P).
 \tag{5}
\]

## 2. Chain and loss budget

Choose pivot coordinates on \(W\), and successively impose each of its
nonpivot graph equations, obtaining
\(P_0=\mathbb R^m\supset\cdots\supset P_{m-r}=W\), where \(r=\dim W\).
At a processed coordinate \(e\),
\(P_{s-1}=P_s\oplus\mathbb R e\); every unprocessed coordinate vector
lies in \(P_s\). This equality is a direct sum, not an asserted orthogonal
sum. Set \(U_s=U(P_s)\) and \(E_s=F_{P_s}(U_s)\).

Since \(H(\mathbb R e)=1\), (1) gives \(H(V+\mathbb R e)\le H(V)\).
If \(e\in P_s\setminus U_s\), adjoining it also reduces the distance
by one, contradicting minimality. Thus all unprocessed coordinate
vectors lie in \(U_s\). Also
\[
 d(V+\mathbb R e,P_{s-1})\le d(V,P_s).
\]
To see this, the new intersection contains
\((V\cap P_s)\oplus\mathbb R e\), while the dimension of \(V\) grows
by at most one. Testing the old minimum with \(U_s+\mathbb R e\)
therefore proves \(E_{s-1}\le E_s\).

We have \(U_0=\mathbb R^m\), \(E_0=0\), and
\[
 E_{m-r}\le h(W),\qquad d(U_{m-r},W)\le h(W)/a.
 \tag{6}
\]
Let \(c_s=\dim U_{s-1}-\dim U_s\), let \(z\) count zero drops, and
put \(\dim U_{m-r}=r+\theta\). At a zero drop the unchanged minimizer
contains \(e\), so its intersection with \(P_{s-1}\) has dimension
exactly one more than its intersection with \(P_s\). Hence that step
increases the energy by \(a\). It follows that
\[
 z\le h(W)/a,\quad |\theta|\le h(W)/a,\quad
 \sum_{c_s\ge2}(c_s-1)=z-\theta .
\]
Since \(c\le2(c-1)\) for integers \(c\ge2\),
\[
 S:=\sum_{c_s\ge2}c_s\le4h(W)/a.
 \tag{7}
\]
The total number of all flag positions, \(\sum_s c_s\), is at most \(m\).
No enumeration of the graph coefficients is being charged or needed.

## 3. Balance and an explicit expensive-position bound

For a nonzero drop \(U_{\rm old}\supset U_{\rm new}\) of size \(c\),
let
\[
 \Lambda=(U_{\rm old}\cap\mathbb Z^m)^*,\qquad
 K=\Lambda\cap U_{\rm new}^{\perp}.
\]
The primitive rank-\(c\) lattice \(K\) determines the new space.
For a primitive rank-\(t\) sublattice of \(\Lambda\), use (3) and
compare its normal space with the old minimum. Because a codimension
\(t\) change alters the rank distance to a fixed space by at most \(t\),
saturation gives, for **every** sublattice,
\[
 \det J\ge N^{-a\operatorname{rank}J}\quad(J\subseteq\Lambda).
 \tag{8}
\]
For primitive \(K'\subseteq K\), its normal space \(V'\) lies between
the old and new spaces. Comparing \(V'\) with the new minimum gives
\[
 \det K/\det K'\le N^{a(c-\operatorname{rank}K')}.
 \tag{9}
\]
Primitivity in \(K\) implies primitivity in \(\Lambda\), so (3) really
does apply. Both directions of these inequalities are essential.

Build a saturated flag \(K_i\) by choosing a shortest nonzero vector
\(v_i\) in \(K/K_{i-1}\). Put \(\mu_i=\|v_i\|\) and
\(y_i=\log_N\mu_i\). A shortest vector is primitive, so (2) and (9)
give every suffix bound
\[
 \sum_{j=i}^c y_j\le a(c-i+1).
 \tag{10}
\]
Minkowski's elementary cube bound is
\(\lambda_1(M)\le\sqrt u\,(\det M)^{1/u}\) in rank \(u\).
For completeness, any cube of side \(2t\) with \(t^u>\det M\)
has volume \(>2^u\det M\); the usual fundamental-domain pigeonhole
argument applied to its half cube yields a nonzero lattice vector
in it. Its norm is at most \(\sqrt u\,t\), and let \(t\) decrease to
\((\det M)^{1/u}\).
Apply this to \(K_{i+u-1}/K_{i-1}\). Since \(v_i\) is shortest in
the larger quotient, for every available interval,
\[
 y_i\le \frac1u\sum_{j=i}^{i+u-1}y_j+\tfrac12\log_N u .
 \tag{11}
\]
There is **no** unspecified constant in (11). The full suffix gives
\(y_i\le1/2+a\).

Call \(i\) expensive if \(y_i>1/2-3a\). Partition the suffix beginning
at the first expensive index into consecutive blocks, each beginning
at an expensive index and ending before the next one, or at the end.
There is exactly one block per expensive position. For a block of
length \(u\), put \(w=\sum_{\rm block}(y_j-a)\). Equation (11) gives
\[
 w\ge u(1/2-4a-\tfrac12\log_N u).
 \tag{12}
\]
If \(u\le q:=N^{2/5}\), then \(w\ge u/5\), since \(a\le1/40\).
For every block \(u\le N\), \(w\ge-4au\). The sum of the \(w\)'s is
nonpositive by (10).

Here is an exact amortization, avoiding a hidden constant in \(O(ac)\).
For each block, short or long,
\[
 1\le 5w+(20a+1/q)u .
 \tag{13}
\]
For a short block, \(5w\ge u\ge1\). For a long block,
\(5w+20au\ge0\) and \(u/q>1\). Summing (13), the excess term
disappears and the total length is at most \(c\). Thus the number of
expensive positions is at most
\[
 (20a+N^{-2/5})c\le21ac.
 \tag{14}
\]
If \(c=1\), (10) instead gives \(y_1\le a<1/2-3a\), so there are
no expensive positions. `Main.lean` verifies (12)--(14)'s real
inequalities for arbitrary finite block families. The partition and
its lattice provenance have been proved above, not inferred from tests.

## 4. All image and fiber choices are charged

At flag position \(i\), put \(\Pi=\Lambda/K_{i-1}\).
The prefix determinant bound from \(y_j\le1/2+a\) and the lift of any
rank-\(t\) sublattice of \(\Pi\) into \(\Lambda\) give the sharper version
of U's `eq:cover-projected-determinants`:
\[
 \det J\ge
 N^{-at-(1/2+2a)(i-1)}
 \ge N^{-at-(i-1)}\quad(J\subseteq\Pi).
 \tag{15}
\]
The lift contains \(K_{i-1}\), and its determinant is the product of
the prefix and projected determinants by (2). This justifies applying
(8) to that lift, rather than to an arbitrary Euclidean projection.

Minimize \(\det M/T^{\operatorname{rank}M}\) in \(\Pi\), where
\(T=N^{-2a}\), and choose a deterministic minimizing primitive
sublattice \(M_0\). The existence argument is the same finite
exterior-product argument in this fixed lattice. Its zero competitor
has value one. By (15),
\[
 j_0:=\operatorname{rank}M_0\le(i-1)/a.
 \tag{16}
\]
Every sublattice of \(\Omega=\Pi/M_0\) has determinant at least \(T\)
to its rank: otherwise its lift would improve the objective.
In particular \(M_0=0\) at \(i=1\). All single-drop fibers therefore
have cardinality one. No choice or description of \(M_0\) is charged,
because it is a fixed function of the decoded lattice \(\Pi\).

For \(k=\operatorname{rank}\Omega>0\), the precise Reverse Minkowski
input in `report.md`, scaled by \(T\), yields
\[
 \rho_{s_0}(\Omega)\le3/2,\qquad
 s_0=N^{-2a}/(10(L+2)).
 \tag{17}
\]
The all-sublattice hypothesis follows from the preceding minimization,
and \(k\le N\) allows this common, smaller parameter. Rank zero means
one image and requires no invocation of that theorem.

Poisson summation in the same primary source, Equation (5), gives for
\(s_1\ge s_0\)
\[
 \rho_{s_1}(\Omega)
 \le(s_1/s_0)^k\rho_{s_0}(\Omega).
 \tag{18}
\]
Indeed \(\rho_s(\Omega)/s^k=\rho_{1/s}(\Omega^*)/\det\Omega\)
is decreasing in \(s\). This is a second external input, with
its normalization checked against the source, not a reversed
Gaussian comparison.

A ball of radius \(r\) contains at most
\(\exp(\pi r^2/s^2)\rho_s(\Omega)\) points. At an inexpensive
position \(r=N^{1/2-3a}\); (17) shows that its image can be specified
using at most
\[
 2+1000 N^{1-2a}(L+2)^2
 \tag{19}
\]
bits, including rounding up. At any position use the common radius
\(R=N^{1/2+a}\). For an expensive image, choose \(s_1=N^a\);
then \(s_1/s_0=N^{3a}10(L+2)\ge1\). Equations (17)--(18) and
(Q0) give, before rounding,
\[
 \log_2\#\{\text{images}\}
 \le1+8N+8aNL\le20aNL .
 \tag{20}
\]
Here \(\pi/\log2<8\), \(1/\log2<2\), and
\(\log(10(L+2))\le aL\) have been used. Rounding is covered by
\(22aNL\) bits. Since at most \(21aS\) positions in the whole
chain are expensive, all expensive images cost at most
\[
 462a^2NL S.
 \tag{21}
\]

For a fixed image in \(\Omega\), let \(\mathcal V\) consist of all its
lifts in \(\Pi\) of norm at most \(R\). Its differences lie in \(M_0\).
If \(F\) is the real span of these differences, let
\(j=\dim F\le j_0\), and \(M_F=\Pi\cap F\). Equation (15) gives
\(\det M_F\ge N^{-aj-(i-1)}\).
For \(j>0\), choose \(j\) independent differences of length at most
\(2R\), generating \(M'\subseteq M_F\). In each coset of \(M'\),
the half-open fundamental parallelotopes at the points of \(\mathcal V\)
are disjoint up to boundaries. Centered at a fixed \(v_0\in\mathcal V\),
they lie in the \(j\)-ball of radius \(2(1+j)R\).
Sum the volume bound separately over the
\([M_F:M']=\det M'/\det M_F\) cosets. Cancellation of \(\det M'\)
gives
\[
 |\mathcal V|\le
 \frac{\operatorname{vol}_j B_j(2(1+j)R)}{\det M_F}
 \le (8N^{3/2+a})^j N^{aj+(i-1)} .
 \tag{22}
\]
There is no assertion that parallelotopes in different cosets are
disjoint from each other. Only the within-coset disjointness is used.
For \(j=0\) there is at most one lift.

For \(N\ge16\), (22) and (16) bound the logarithm by
\((5/a)(i-1)\log_2N\). At \(i=1\) the cost is exactly zero;
otherwise rounding up is bounded by \(12(i-1)L/a\) bits.
The fiber cost for a whole drop is thus at most
\(6Lc(c-1)/a\). Only multidrops contribute. Since nonnegative
numbers satisfy \(\sum c_s^2\le(\sum c_s)^2\),
all fibers cost at most
\[
 6LS^2/a .
 \tag{23}
\]
This sharpens U's bound by eliminating its single-drop fiber term.

## 5. Adaptive decoding and the fixed-list quantifier

Before any flag choices, encode the pivot subset, a coordinate
permutation, the nonnegative drops, and the expensive-position marks.
Pad these data to fixed-length fields; their total cost is at most
\(8NL\) bits. The decoder does not know \(W\) or any graph coefficient.
It starts at \(U_0=\mathbb R^m\). A zero drop does nothing.
At a nonzero drop the old lattice is known. At position \(i\), the
already chosen normal prefix determines \(\Pi\), the canonical
minimizer \(M_0\), its quotient \(\Omega\), and all candidate image and
fiber sets used in (19)--(22). Choose their orders deterministically,
for example using a canonical rational basis and lexicographic
integer coordinates among the finitely many vectors in a ball.

The image and fiber indices determine \(v_i\). Its lift determines
\[
 K_i=\Lambda\cap\operatorname{span}(K_{i-1},\widetilde v_i).
 \tag{24}
\]
Actual flags are saturated, so (24) reconstructs exactly their prefix;
after \(c\) positions the decoder obtains \(K\) and its normal space
\(U_{\rm new}\) within \(U_{\rm old}\). This determines the next
ambient dual lattice. No continuous parameters remain unencoded.

Only prefixes that occur for actual minimizing chains need obey
(8)--(16). For any such prefix, the candidate image and fiber sets
are nevertheless defined from decoded data alone, and their full
sizes obey the uniform bounds above. Pruning all other branches
therefore cannot add choices. The metadata determines the number of
remaining positions, so completed encodings are prefix-free.
Padding them to a common maximum length bounds the total number of
terminal spaces, even though candidate sets vary with the prefix.
There is no multiplication of unrelated pointwise nets or a net
chosen after seeing \(W\).

Putting (7), (19), (21), and (23) together with \(h(W)\le b/L\),
the length of every actual encoding is at most
\[
 \begin{split}
 8NL+2N+1000N^2N^{-2a}(L+2)^2
 &+462a^2NL(4b/(aL))\\
 &+(6L/a)(4b/(aL))^2\\
 =8NL+2N+1000N^2N^{-2a}(L+2)^2
 &+1848aNb+96b^2/(a^3L)
 \le Q(N,a,b).
 \end{split}
 \tag{25}
\]
All rounding of vector indices has already been included. Removing
duplicates among the decoded terminal spaces gives a fixed list with
at most \(2^{\lceil Q\rceil}\) members. Equation (6) gives its claimed
distance. This proves Q, including \(m=0\), for which the singleton
list suffices.

## 6. Exact parameter improvement and the manuscript's quantifiers

Choose \(a=L^{-2/9}\) and \(b=NL^{1/9}\). All three conditions in
(Q0) hold for all sufficiently large \(N\). The distance and dominant
cost terms are exactly
\[
 \frac b{aL}=NL^{-2/3},\quad
 aNb=N^2L^{-1/9},\quad
 \frac{b^2}{a^3L}=N^2L^{-1/9}.
 \tag{26}
\]
The remaining normalized terms are
\[
 \frac{L^{10/9}}N\longrightarrow0,\qquad
 e^{-2L^{7/9}}(L+2)^2 L^{1/9}\longrightarrow0 .
 \tag{27}
\]
For the second limit, its logarithm is
\(-2L^{7/9}+2\log(L+2)+(1/9)\log L\), which tends to minus
infinity. Thus (25), including its final ceiling, is eventually
less than the bound in (R). This proves R.

For each fixed real \(D,A>0\), with \(\ell=\log L\),
\[
 \ell^D=o(L^{1/9}),\qquad
 L^{-2/3}=o(\ell^{-A}),\qquad
 100000L^{-1/9}=o(\ell^{-A}).
 \tag{28}
\]
These follow from \(x^t=o(e^{\epsilon x})\) for every fixed real
\(t\) and positive \(\epsilon\), proved, for example, by choosing an
integer \(k>t\) in the exponential series after replacing \(\epsilon\)
by \(\epsilon/2\). The limits in (27) follow by the same argument.
They are not numerical extrapolations from small \(N\).
Choose a threshold depending on \(D,A\) making all three comparisons
in (28) and (Q0) hold. Apply the same list (R) at each such \(N,m\).
This yields exactly the manuscript's height coverage, distance at most
\(N\ell^{-A}\), and cardinality at most \(2^{N^2\ell^{-A}}\),
simultaneously for all \(m\le N\). No asymptotic quantifier is weakened.

## 7. What the evidence does and does not settle

The executable checks replay exact determinant identities, rational
subspace identities, primitive reconstruction, the nonorthogonal graph
step, the universal block-count proof's finite test instances, and the
rational exponent algebra in (26). These are regression and fidelity
checks, not a finite proof of Q. The full proof of Q is Sections 1--5.
The independent Reviewer must check that proof, the connection of the
formal block family to actual flags, and the two external inputs.

No false literal manuscript assertion has been established by this
audit, so no `F_` refutation claim is warranted. Its normal balance,
expensive-position count, adaptive reconstruction, and total cost pass
this analysis. The improvement in (R) and the absent single-drop fiber
charge are explicit mathematical differences from the strongest staged
cover, not evidence that the two main singularity claims are correct.
Novelty remains unverified pending stronger literature comparison and
independent review; this is not a terminal publishable certification.
