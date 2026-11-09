# A parameterized all-depth, many-root collision theorem

## Result and scope

The collision assertion in `build/witnesses.tex`, Proposition
`prop:collision`, survives this audit. The proof below derives its geometric,
embedding, and prospective-visitation dependencies without conditioning on
actual visitation. It also improves the manuscript's summation: under exactly
its deterministic good-prefix hypotheses,

\[
 \Pr(\mathcal C_k)
 =O\bigl(k^2(D^{-40}+n^{-1})\bigr).
 \tag{1}
\]

Here **any positive integer \(k\)** is allowed, including an \(n\)-dependent
one, with an absolute implied constant independent of \(k\). All roots are
independently sampled oriented edges **with replacement**, all are executed,
and \(\mathcal C_k\) concerns **every exposed candidate**, including candidates
above threshold and candidates whose children are never traversed.
In particular (1) implies the requested \(O(D^{-35}+n^{-1})=o(D^{-1})\)
for \(k=1,2\), uniformly at arbitrary depth.

Keeping the quantitative unfolding error yields the stronger refinement

\[
 \Pr(\mathcal C_k)
 =O\bigl(k^2(\kappa_n D^{-96}+n^{-1})\bigr),\qquad
 \kappa_n=(1+\log n)^{C_0}.
 \tag{2}
\]

Consequently one may replace \(\kappa_n D^{-96}\) by
\(D^{-96+\zeta}\) for any fixed \(\zeta>0\). The coarse bound (1)
uses only the manuscript's stated factor-two envelope and is the primary
specialization. The improvement over the manuscript's exponent \(-35\)
comes from two explicit changes: the root-plus-fork cost is \(C_D^2\),
not \(C_D^3\), and the ordered one-tree generating function is
\(2e^{2x}-e^x\), not the relaxed \(e^{3x}\).

This is a proof and proposed quantitative generalization, **not an
independently accepted certification yet**. No false manuscript assertion
has been established, so no refutation claim is filed. The Host's independent
Reviewer must assess the proof, the graph-to-formal-statement translation,
and the significance/novelty of this strengthening.

The theorem takes the *deterministic conclusions* of `prop:prefix` as
hypotheses. It does not certify their probability of occurrence, or the full
terminal-leave theorem. The latter remains behind the separate `C_PREFIX`
and moment dependencies in the ledger. Section 8 explains the source audit.

## 1. Finite-parameter theorem

Let \(G\) be a finite simple graph on \(n\) vertices with \(m>0\) edges.
Set \(p=2m/n^2\), \(D=np^2\), and assume \(0<p<1<D\).
Choose an integer \(L\ge1\) and numbers \(a,K,\kappa\ge1\). Suppose:

1. Every edge has at most \(aD\) common neighbors. Write
   \(\rho=\max_v\deg(v)/(2m)\).
2. Both rooted-template upper bounds in `prop:prefix` hold, with factor
   \(\kappa\), through order \(3L+1\). In the first bound all same-root
   subtemplate scalings must be at least one; in the second **every**
   completion scaling after enlarging the root set must be at most one.
   The distinguished set is independent in the template, not necessarily
   in its prescribed image.
3. \(D^L p\le1\).
4. In the independent paired unfolding, let \(q_{e,T}\) and \(I_{e,T}\)
   be the probabilities and integrals defined in `queries.tex`, and put
   \(J=\max_{e,T,t}I_{e,T}(t)<1\). For every pair
   \(\{f,g\}\subset T\) and \(t\in[0,1]\),
   \[
    \frac{q_{f,T}(t)q_{g,T}(t)}{(1-J)^2}
       \le \frac K{1+2Dt}.                         \tag{Q}
   \]

Hypothesis (Q) is a deterministic bound on scalar probabilities. It
does **not** assume conditional independence, visitation, or absence of
collisions. Section 6 derives it from the actual good-prefix hypotheses.

Define \(C=1+2D\), \(\mu=\log C/(2D)\), \(x=2aDK\mu=aK\log C\), and
\(\beta=\kappa\max\{p,(aD)^{-L}\}\). Then, for \(k\) independent oriented
roots sampled with replacement,

\[
\begin{split}
 \Pr(\mathcal C_k)
 &\le 2k(k-1)\rho+
       4k^2\beta C^2\bigl(3e^{2x}-e^x\bigr)\\
 &\le 2k(k-1)\rho+
       12k^2\kappa\max\{p,(aD)^{-L}\}C^{\,2+2aK}.       \tag{3}
\end{split}
\]

All depths are included in (3). There is no depth cutoff or finite-size
enumeration in its proof.

## 2. A collision really gives two paths

Use the deterministic potential occurrence tree for each root, with an
independent uniform coordinate on each candidate occurrence. The branching
degree is bounded by twice the maximum triangle degree of an edge. A path
of length \(j\) has decreasing priorities with probability \(1/j!\).
The union bound \(M^j/j!\to0\), followed by finite branching, proves
almost sure finite evaluation. Apply this at every potential node,
countably many in total. It also makes all hypothetical subtree outputs
simultaneously well defined and measurable. This argument is independent
of collisions and of the scalar approximation.

Construct a formal graph from the visited calls. A root introduces a
disjoint formal edge. Each visited child adds a fresh vertex attached
to the endpoints of its responsible focus edge. Its two new edges are
its focus; its attachment edge is not. Thus every formal edge is focused
at its unique birth call. No edge is ever added between old vertices.
Every formal triangle is one birth triangle: inspect its newest vertex,
whose only older neighbors are its two attachment endpoints.

First suppose all formal labels are distinct. If a candidate triangle
type is exposed at two different calls, its two responsible focus edges
are distinct, so together they already represent all three vertices of
that type. If there is no extra adjacency between their formal labels,
these three vertices form a formal birth triangle. Its two new edges
are focused only at its birth call, which omits that triangle as parent;
its attachment edge is focused only once. The type can therefore be
exposed at most once, a contradiction. Hence some pair of distinct,
formally nonadjacent vertices has adjacent labels in \(G\).
Their birth paths have injective labels.

Now suppose a label first repeats at the birth of \(z\) on attachment
edge \(uv\), and an earlier vertex \(w\) has the same label as \(z\).
All earlier labels are distinct; \(u,v,w\) are distinct and their
labels form a triangle. If \(uw\) or \(vw\) is absent formally, it is
the desired earlier extra edge. Its two ancestral paths lie entirely
before the first repetition. Its nonadjacency persists because no
old-old edge is subsequently added.

Otherwise \(uvw\) is an earlier formal birth triangle. If its newest
vertex is \(u\) or \(v\), then \(uv\) was born there, and the unique
call focusing \(uv\) omits this parent triangle: it cannot introduce
\(z\) with that type. If its newest vertex is \(w\), then \(w\) and
\(z\) would be two children of the unique call focusing \(uv\), both
with the same candidate type. A list has each type once and traverses
it at most once. Both alternatives are impossible.

The only excluded first repetitions are among initial root endpoints.
Each endpoint of a uniform oriented edge has distribution
\(\pi(v)=\deg(v)/(2m)\). Two independent endpoints from different roots
coincide with probability \(\sum_v\pi(v)^2\le\rho\). There are four
endpoint pairs per root pair. Thus root overlap costs at most
\(4\binom{k}{2}\rho=2k(k-1)\rho\). Roots are **not** resampled or
conditioned to be disjoint.

This proof used the focus edges of the *exposing* calls. It did not
assume either repeated candidate's child was visited. Hence it covers
the entire exposed-list event specified by the operator.

## 3. Extra-edge embeddings and every completion condition

Fix a union of two ancestral birth-call paths, using \(r\in\{1,2\}\)
root edges and \(\ell\) non-root calls. Its formal graph \(J\) has
\(2r+\ell\) vertices and \(r+2\ell\) edges. The distinct nonadjacent
marks \(u,v\) supply \(J^+=J+uv\).

If \(\ell<L\), order roots first and births parent-first. Each vertex
has at most two older neighbors. In any nonempty vertex subset of
size \(s\), its oldest vertex has no older neighbor in that subset,
so there are at most \(2s-2\) edges of \(J\), and at most \(2s-1\)
of \(J^+\). In particular every subgraph has at most \(2s\) edges.
Its scaling is at least \(n^sp^{2s}=D^s\ge1\); the empty graph has
scaling one. The first template bound, of order at most \(L+3\),
therefore gives
\[
 \#(J^+\hookrightarrow G)
 \le\kappa(2m)^r D^\ell p
 \le(2m)^r(aD)^\ell\beta.                         \tag{4}
\]

If \(\ell\ge L\), take the last \(L\) births \(Z\) in **any**
parent-first total order. All preceding labels have at most
\((2m)^r(aD)^{\ell-L}\) assignments: expose root orientations,
then third vertices using the common-neighbor bound. Ignore
injectivity restrictions when making this upper bound, but fix an
injective assignment when applying the template estimate.

Retain the two backward edges of each vertex of \(Z\) and the extra
edge \(uv\). Let \(I\) be their endpoints outside \(Z\); retain no
edge inside \(I\). Each suffix birth is an ancestor of a marked
suffix birth: it lies on a marked path, and every later birth of
that path is still in the suffix. Thus at least one mark is free.
The \(2L\) backward edges are distinct, and the extra edge is not one
of them. We have
\[
 |I|\le2L+1,\quad v(H)\le3L+1,\quad e(H)=2L+1,\quad
 S(H,I)=D^Lp\le1.                                \tag{5}
\]

Here is the full completion argument, including disconnected suffixes.
For \(U\subsetneq Z\), assign each retained backward edge to its newer
endpoint. It contributes at most two edges per vertex of \(U\).
If \(H[I\cup U]\) had more than \(2|U|\) edges, it would have to
contain the extra edge and **both** backward edges of every vertex
of \(U\). Thus every free mark is in \(U\). The two focus edges of
a non-root parent both contain its newly born vertex, so retaining
both backward edges of a child forces its preceding call's vertex
into \(U\) whenever that vertex is free. Propagating back from the
free marks includes all of \(Z\), a contradiction. Therefore
\[
 e(H[I\cup U])\le2|U|,\quad
 S(H[I\cup U],I)\ge D^{|U|}\ge1.                  \tag{6}
\]

Every enlarged distinguished set is \(I\cup U\). Its completion
scaling is exactly
\[
 \frac{S(H,I)}{S(H[I\cup U],I)}\le1
\]
for proper \(U\), by (5)--(6), and is **one**, not less than one,
when \(U=Z\). This verifies *every* hypothesis of the second template
bound. It gives at most \(\kappa\) suffix extensions. Ignoring
avoidance of preceding images outside \(I\) only increases the count.
Multiplication proves (4) also in the long case.

`terminal_suffix_bound` in `Main.lean` proves the universal finite
counting step in (6). Its `cover` hypothesis is supplied by the
parent-first suffix observation above; closure of \(U\) is derived,
not assumed. Its two backward slots count actual distinct edges for
the birth construction, as explained in `statement_fidelity.md`.
Completion scaling, the template inequality, and (4) are proved here,
not claimed as Lean theorems.

## 4. Prospective visitation, not adaptively conditioned independence

Fix the pattern **and its embedding before any priorities are exposed**.
Its specified oriented roots have probability \((2m)^{-r}\), even when
other sampled root types coincide. If the proposed children cannot be
distinct allowed candidates, the event is impossible. Otherwise each
specified child is a distinct uniform occurrence coordinate \(u_y\).

Condition only on these coordinates. To visit every selected call,
priorities must decrease along every selected path. At a required
non-root call \(z\), let \(t_z\) be the largest priority of its required
children. Define \(O_z\) to say that all off-pattern candidates with
priority less than \(t_z\) have hypothetically false children.
All selected calls being visited necessitates every \(O_z\).
If there is a selected fork, the earlier selected child must additionally
return false before the later is reached; dropping this condition is
a valid upper bound.

An off-pattern child roots a potential subtree disjoint from all
selected calls and all other such off-pattern subtrees. In word
coordinates for the potential tree, these child roots form the outer
boundary of a prefix-closed selected tree: they are pairwise
prefix-incomparable, and none is a prefix of a selected coordinate.
Thus their entire descendant coordinate sets are disjoint, including
for an ancestor and a descendant selected call. Distinct root trees
have disjoint coordinate namespaces. Conditional on the selected
coordinates, the \(O_z\) are consequently independent. No return
value, exposed list, or actual visitation event was conditioned on.

The hypothetical child of an occurrence of \(S\) has true probability
\(q_{f,S}(v)q_{g,S}(v)\) at its own priority \(v\). Indeed, with \(S\)
omitted the two focus edges have disjoint candidate sets and independent
occurrence descendants. Chronological stopping changes the visited
children, not the event that *all* potential successful children fail.
Integrating over \(v<t\) gives \(I_{e,S}(t)\). Hence
\[
 \Pr(O_z\mid(u_y))
 =\prod_{\text{off-pattern }S}(1-I_{e(S),S}(t_z))
 \le Kb(t_z),\quad b(t)=\frac1{1+2Dt},             \tag{7}
\]
by (Q), since at most two factors were removed.

For one selected child, (7) supplies \(Kb(u)\). For a fork, use
\[
 b(\max(u,v))=(1+2D\min(u,v))b(u)b(v)
                  \le Cb(u)b(v).
\]
Ignore root off-pattern conditions and insert each missing root-child
factor using \(b(u)\ge C^{-1}\).

Crucially the total loss here is at most \(C^2\). If \(R\) is the
number of selected child steps leaving roots and \(F\) the number
of non-root forks, then \(R+F\) equals the number of non-root leaves
of the selected forest: subtract the count of internal vertices
from the count of edges. All such leaves are marked birth calls,
so \(R+F\le2\). Empty paths and root marks only lower this count.
There are at most \(\ell\) contributing non-root internal calls,
and \(K\ge1\). Thus conditional visitation is bounded by
\[
 C^2K^\ell\prod_y b(u_y)\,
       {\bf1}\{\text{all selected path orders hold}\}.             \tag{8}
\]

## 5. Exact ordering and the unbounded sum

For one root, let \(h\) be the common trunk length and \(s_1,s_2\)
the arm lengths; \(\ell=h+s_1+s_2\). Transform each coordinate
by \(w=\mu^{-1}\int_0^u b(t)\,dt\). All \(\ell!\) strict total
orders have equal product measure \(\mu^\ell/\ell!\).
The trunk must precede both arms in decreasing-priority order; the
arms can interleave in \(\binom{s_1+s_2}{s_1}\) ways. Therefore the
integral in (8) is
\[
 \frac{\mu^\ell}{\ell!}\binom{s_1+s_2}{s_1}.       \tag{9}
\]
The two-root integral is \(\mu^{s_1+s_2}/(s_1!s_2!)\).
These formulas include zero lengths.

For fixed \((h,s_1,s_2)\), there are at most \(4k^2 2^\ell\)
patterns of either root morphology. To check the constant: choose
the ordered root indices in at most \(k^2\) ways; a root mark has
at most two endpoint choices, giving at most four altogether;
each child chooses one of at most two named focus edges. Marks
born at non-root calls have a unique new vertex. The third vertices
are supplied by the embedding, not by an extra pattern multiplicity.
Invalid patterns are discarded.

Multiply this count by (4), the root matching probability
\((2m)^{-r}\), and (8)--(9). For the one-root morphology, sum using
\[
 \sum_{h+s_1+s_2=\ell}\binom{s_1+s_2}{s_1}
 =\sum_{s=0}^{\ell}\sum_{j=0}^{s}\binom{s}{j}
 =2^{\ell+1}-1.                                  \tag{10}
\]
The universal finite identity (10) is `forkMultiplicity_closed` in
the Lean source. Consequently its exponential generating function is
\(2e^{2x}-e^x\), where \(x=2aDK\mu\). For distinct roots the sum is
\(e^{2x}\). This proves the first inequality of (3); its second
follows by discarding the negative term and using
\(e^{2x}=C^{2aK}\).

Every summand is nonnegative before the generating functions are
simplified. The countable union bound, or monotone convergence of
the depth-truncated union bounds, therefore applies. The finite
evaluation argument in Section 2 identifies its limit with the actual
query event. There is no interchange involving a signed summation
or an unexplored tail.

## 6. Deriving (Q) from the actual good-prefix conditions

For completeness, this section independently supplies the analytic
dependency; (Q) is not silently added to the manuscript's hypotheses.
Only the degree, codegree and link-cycle parts of `prop:prefix` are
needed. Write \(r_0=8000\), \(\epsilon=1/2000\).

For each vertex \(u\), let \(M_u\) be its link adjacency matrix and
\(N_u=\deg(u)\). Its row sums are \((1\pm n^{-c})D\), and its
injective cycle counts through length \(r_0\) are
\((1\pm n^{-c})D^j\). In the trace of \(M_u^{r_0}\), a noninjective
closed walk has either a tree support with at most \(r_0/2\) edges,
or a cyclic support on fewer than \(r_0\) vertices. For each of the
finitely many fixed walk shapes, the tree count is at most
\(O(np)(2D)^{r_0/2}\). In the cyclic case choose one simple cycle
and extend a rooted spanning forest, giving \(O(D^{r_0-1})\).
It follows that
\[
 \operatorname{tr}((M_u/D)^{r_0})
 =1+O(n^{-c}+D^{-1}+npD^{-4000})
 =1+O(n^{-c_*}),\quad c_*=\min(c,1/1000).
\]
The last residual exponent is
\(npD^{-4000}\sim n^{-6999/2000}\).

By the row sums and the Rayleigh quotient, the largest eigenvalue of
\(M_u/D\) is \(1+O(n^{-c})\). Since \(r_0\) is even, all other
eigenvalues have absolute value \(O(n^{-\gamma})\), where
\(\gamma=c_*/r_0>0\). The normalized all-ones vector has residual
norm \(O(n^{-c})\) for eigenvalue one. Projecting on the complementary
eigenspaces, whose distance from one is at least \(1/2\), shows that
the leading projector differs by \(O(n^{-c})\) from
\({\bf1}{\bf1}^{\mathsf T}/N_u\). Thus
\[
 \|M_u/D-{\bf1}{\bf1}^{\mathsf T}/N_u\|_2=O(n^{-\gamma}). \tag{11}
\]

Let \(A\) be the edge-space adjacency matrix for co-triangular edges,
and \(P\) the sum of star averaging matrices. Every co-triangular
edge pair has one common endpoint, so \(A\) is the sum of link
matrices. Each edge belongs to two stars. Applying (11) in quadratic
forms gives \(A/D=P+R\), with
\(\|R\|_2=O(n^{-\gamma})\), \(\|R\|_\infty=O(1)\), and \(P\)
positive semidefinite.

Define \(U y(uv)=y(u)+y(v)\) and let \(V\) average edges at a vertex.
Then \(P=UV\), \(VU=\mathrm{Id}+W\), where \(W\) is the neighbor
random-walk matrix, \(\|U\|_\infty=2\), and
\(\|V\|_\infty=\|W\|_\infty=1\). The exponential series gives
\[
 e^{-sP}=\mathrm{Id}-U\int_0^s e^{-v(\mathrm{Id}+W)}\,dv\,V,
 \quad \|e^{-sP}\|_\infty\le1+2s,\quad \|e^{-sP}\|_2\le1.
\]
Iterate
\(E(s)=e^{-sP}-\int_0^s e^{-(s-v)P}R E(v)\,dv\)
a fixed \(j_0\) times, where \(j_0\gamma>2\).
The term with \(j<j_0\) factors \(R\) has infinity norm at most
\((1+2s)^{j+1}\|R\|_\infty^j s^j/j!\).
The remainder has Euclidean norm at most
\(\|R\|_2^{j_0} e^{s\|R\|_2}s^{j_0}/j_0!\).
Using \(\|H\|_\infty\le\sqrt m\|H\|_2\le n\|H\|_2\),
this is \(o(1)\) in infinity norm for \(s\le\log n\).
For fixed constants \(C_1,J_1\) we obtain
\[
 \sup_{s\le\log n}\|e^{-sA/D}\|_\infty
 \le C_1(1+\log n)^{J_1}.                         \tag{12}
\]
The large perturbation order is fixed, not a growing-depth cutoff.

The exact product identities follow directly from the independent
occurrence subtrees:
\[
 I_{e,T}(t)=\int_0^t q_{f,T}(v)q_{g,T}(v)\,dv,\qquad
 q_e(t)=\prod_{T\ni e}(1-I_{e,T}(t)),\qquad
 q_{e,T}=q_e/(1-I_{e,T}).
\]
They first give Lipschitz \(I\), then continuous \(q\), then \(C^1\)
functions. Put \(s=\tfrac12\log(1+2Dt)\) and
\(z_e=\log(q_e(t)/q(t))\), \(q(t)=(1+2Dt)^{-1/2}\).
Where the factors are positive, differentiation gives
\[
 z'_e=1-\frac1D\sum_{T=\{e,f,g\}}
 \frac{\exp(z_f+z_g)}
 {(1-I_{e,T})(1-I_{f,T})(1-I_{g,T})}.             \tag{13}
\]
This identity has three denominator factors; none is suppressed.

Choose \(0<\alpha<\min(c,1/1000)\). Bootstrap
\(\|z\|_\infty\le n^{-\alpha}\) and \(I\le1/2\).
Then \(q_{e,T}\le2e^{n^{-\alpha}}q\) and
\[
 J=O(\log n/D),\qquad
 \|z'+(A/D)z\|_\infty
 =O(n^{-2\alpha}+n^{-c}+\log n/D).
\]
Equation (12) and variation of constants improve
\(\|z\|_\infty\) to \(o(n^{-\alpha})\); they improve \(I\le1/2\)
to \(I\le1/4\). Continuity and a first-exit argument, with all
factors bounded below by \(3/4\), extend these estimates through
\(t=1\). No assumed survival factorization in the *finite* process
enters this argument.

In particular
\[
 \frac{q_{f,T}q_{g,T}}{(1-J)^2}
 \le e^{2n^{-\alpha}}(1-J)^{-4} b(t)
 =(1+O(n^{-\alpha}+\log n/D))b(t).               \tag{14}
\]
This proves (Q) with \(K=2\) for all sufficiently large \(n\).
For a separate exact check of the numerical slack, if
\(q_{e,T}/q\le1+\eta\) and \(J\le\eta\le1/100\), then
\((1+\eta)^2/(1-\eta)^2\le2\).
After multiplying by the positive denominator, the difference is
\(1-6\eta+\eta^2\ge47/50>0\).
The bounded Jacobian operation `polynomial.box.enclosure.compute`
returns the exact enclosure \([47/50,10001/10000]\).
The standalone script also proves its lower bound without the adapter:
\[
 1-6\eta+\eta^2=(1-6r)+6(r-\eta)+\eta^2,\quad r=1/100.
\]
The adapter supplies this elementary algebraic move only; it is not
evidence for the stochastic argument.

## 7. Specialization and comparison with the prior bound

The actual prefix has \(D\sim n^{1/1000}\),
\(p=n^{-999/2000}+O(n^{-2})\), \(L=100\), \(B=50\), and
\(H_0=8001\ge301\). Its degree estimate gives \(\rho=O(n^{-1})\).
The exact powers relevant to the two template cases are
\[
 D^{100}p=n^{-799/2000+o(1)}<1,\quad
 pD^{50}=n^{-899/2000+o(1)},\quad
 D^{100-50}=n^{1/20+o(1)}.
\]
Since \(C_0\) is fixed, every fixed power of \(\log n\) is smaller
than these positive powers of \(n\), regardless of the size of \(C_0\).
Thus \(\beta\le D^{-50}\) eventually, uniformly over good graphs.
Apply (3) with \(a=K=2\): \(2+2aK=10\) and
\(D^{-50}(1+2D)^{10}=O(D^{-40})\). This proves (1).
For fixed \(k\), its ratio to \(D^{-1}\) is
\(O(D^{-39}+D/n)=o(1)\).

For (2), take \(a=1+n^{-c}\) and
\(K=e^{2n^{-\alpha}}(1-J)^{-4}\), justified by (14).
Then \((aK-1)\log C=o(1)\) and
\(C^{2+2aK}=O(C^4)=O(D^4)\). Also
\(\beta\le\kappa D^{-100}\), since \(pD^{100}\le1\) and \(a\ge1\).
This proves (2). All constants are independent of \(k\).

The same bounds control total variation between the \(k\)-root finite
and independent answer vectors. On first exposure use a fresh priority
for each actual triangle type; on later exposure use an independent
new occurrence priority. Unexposed type priorities remain independent
conditional on the execution history. Before the first repeated exposed
type the executions coincide. This proves the coupling for all answer
events, not only the all-true event.

## 8. Primary-source findings and remaining review boundaries

The exact primary document obtained was
<https://arxiv.org/html/2412.15039v2>, dated 3 August 2025.
The archived source and exact statement excerpts are
`joos-kuehn-v2.html`, `S7.algocf15.txt`, and `S10.algocf1.txt`.
Lemma 7.15 states both extension bounds with the stopping event
\(i<\tau_{\mathscr B}\wedge\tau_{\mathscr B'}\), the order cap
\(1/\varepsilon^4\), the fixed root injection, and the respective
subtemplate/completion quantifiers. Thus the source-statement findings
supplied by the Planner are confirmed at that level. In particular
checking only the total suffix scaling would not suffice; Section 3
checks the full quantifier.

The HTML's literal formula in Lemma 10.1 has ambiguous parentheses,
`\exp(-\log n)^{4/3})`. This excerpt is preserved literally rather
than silently corrected. It does not affect the deterministic theorem
proved here. The full early-prefix specialization, including the
stopping-event probability and its intended exponent, is **not**
certified by this report. Independent citation attribution is likewise
still owed on `C_PREFIX`: the Engineer who filed those assumptions
cannot supply its own independent supporting attribution.

The strongest prior result relevant here is the staged manuscript's
one-/two-root \(O(D^{-35}+n^{-1})\) bound. This report supplies an
explicit finite-parameter many-root theorem, the sharper path-order sum,
and a kernel-checkable suffix counting theorem; it does not merely
replay a bounded no-counterexample search. No claim is made that these
proof improvements are already independently judged publishable or
absent from every other source.

A targeted web lookup for earlier all-depth paired-query collision bounds
returned the same OpenAI preprint as its only direct primary match, rather
than an independently checked predecessor for (3). Its generated description
overstated the preprint's root range; the staged primary source explicitly
restricts `prop:collision` to \(k\in\{1,2\}\). That search summary is not used
as evidence for either the theorem or novelty. Literature-wide novelty
therefore remains an independent-review question.

## 9. Reproduction and exactly what is machine checked

Run `verify.py` using an ordinary Python 3 interpreter. It checks the
exact certificate parameters, rational power calculations, polynomial
identities, the source-bound Jacobian result, and the freshness and
zero-hole status of the real Lean compiler record. Its bounded
pattern/suffix and occurrence-boundary enumerations are adversarial
diagnostics only and are explicitly labelled as such.

For a fresh kernel replay, use:

```text
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/collision_certificate/Main.lean --statement-fidelity research/collision_certificate/statement_fidelity.md --claim C_SUFFIX_CORE --project-root .
```

The exact formal scope is stated in `statement_fidelity.md`. Neither
the entire probability theorem nor the analytic stability argument is
being described as formalized. The independent Reviewer must read
Sections 2--7 and the statement-fidelity mapping, rerun the technical
certificate, and run both campaign-local official checks before
acceptance. All proof-graph nodes remain unconfirmed until that happens.
