# Uniform two-element conjugate joins in the MS14 subgroup

## 1. Statement and improvement over the accepted result

Put \(F=F(x,y)\), \(R=x^{-1}y^2xy^{-3}\),
\(S_e=x^{-1}yx^2y^ex^{-2}\), and \(H_e=\langle R,S_e\rangle\),
where \(e\in\{-1,1\}\).

**Theorem.** For every \(u,v\in H_e\) and every \(h\in F\), the subgroup
\[
                    \langle u,hvh^{-1}\rangle
\]
contains no ambient primitive. In fact, every nonidentity element of this
subgroup has a cyclically reduced representative containing both signs of
at least one of \(x,y\).

In particular this proves the requested assertion for every
\(\alpha\in\operatorname{Aut}(F(a,b))\), with
\(u=\alpha(a)(R,S_e)\) and \(v=\alpha(b)(R,S_e)\). There is no bound on
\(\alpha\), either donor, \(h\), or a subgroup word. Neither generation of
\(H_e\) by \(u,v\) nor their primitivity inside \(H_e\) is required.

The strongest accepted input fixes the donor conjugacy classes to \(R,S_e\)
and allows every \(h\). The present statement allows *all two elements* of
the fixed subgroup before that conjugation. This is a genuine enlargement
of the quantifier range, not a longer finite Nielsen search.

This is not a theorem about \(\langle H_e,hH_eh^{-1}\rangle\), not an
invariant under unrestricted interleaved AC moves, and not an AC
counterexample. Independent mathematical review, originality, and
publication-level significance remain outstanding.

## 2. Known input and scope of source retrieval

The accepted input is
`../ms14-conjugate-join-primitive/THEOREM.md`, independently accepted in
handoff `313369bedbc7/round-0001.json`: for both signs and every \(h\),
\(\langle R,hS_eh^{-1}\rangle\) is primitive-free. Its axis reduction,
98-case certificate, and independently attributed Piggott Remark 1.2 are
reused as accepted; none is regenerated here.

That result also excludes any terminal Nielsen block after the displayed
join. It explicitly does not exclude an initial arbitrary Nielsen block.
The new quantifier over \(\alpha\) is therefore substantive.

A limited web lookup on 2026-11-03 found Piggott's primary abstract for
*Algorithmic constructions and primitive elements in the free group of
rank 2*, arXiv:math/0504401v2. It concerns primitive normal forms, not this
uniform conjugate-join assertion. The search supplied no verified source
settling the proposed assertion. An attempted AMS link for Evans's
*Primitive elements in free groups* redirected to an unrelated journal
index and was not usable. Neither the search summary nor that inaccessible
paper is used as a mathematical assumption or a novelty certificate.

The accepted rank-two primitive sign criterion is used through
claim `K1187-MS14-RANK2-PRIMITIVE-SIGN` and its independently confirmed
assumption `PIGGOTT-R12`: a cyclically reduced ambient primitive uses at most
one sign of each generator. We call such words **sign-coherent**. The four
possible alphabets are `xy`, `xY`, `Xy`, `XY`, with capitals denoting inverses.
This is only a necessary condition, not a converse.

A second, route-specific source lookup found the primary abstract of
Kapovich--Myasnikov, *Stallings foldings and the subgroup structure of free
groups*, arXiv:math/0202285v1. Folded graphs and fiber products are established
methods, not claimed as new here. That abstract does not settle the present
two-element assertion. No unsupported statement in the search engine's
summary, including its purported undecidability or novelty claims, is used.
The bounded-overlap reduction below is proved directly. This limited
retrieval does not verify originality.

## 3. The fixed core and its quantitative certificates

Use the following labelled theta graph \(\Gamma_e\), with branch vertices
\(o,z\). Its three internally disjoint arcs are
\[
 A:o\longrightarrow z,\quad \operatorname{lab}(A)=Xy,\qquad
 B:z\longrightarrow o,\quad \operatorname{lab}(B)=yxYYY,\qquad
 C:z\longrightarrow o,\quad \operatorname{lab}(C)=xx\,y^e\,XX.
\]
Their lengths are \(2,5,5\). Every arc has its reverse, labelled by the
inverse word. Thus \(AB=R\), \(AC=S_e\), and
\[
 T_e=B^{-1}C=R^{-1}S_e=
 \begin{cases}
 \texttt{yyyXYxxYXX},&e=-1,\\
 \texttt{yyyXYxxyXX},&e=1.
 \end{cases}
\]
At \(o\) the outgoing labels are \(X,y,x\), and at \(z\) they are
\(Y,y,x\). Interior vertices have two distinct outgoing labels. Hence the
graph is folded, has 11 vertices and 12 unoriented edges, and its two
independent loops \(AB,AC\) generate its fundamental group.

A reduced path in a folded graph has a reduced label: adjacent inverse
labels would have to be reverse traversals of the same edge. Consequently
the universal cover of \(\Gamma_e\) embeds, label-preservingly, into the
Cayley tree of \(F\). Write \(\mathcal T_e\) for its image, with the lift of
\(o\) at the identity. It is an \(H_e\)-invariant subtree, its quotient is
\(\Gamma_e\), and it contains the axis of every nonidentity element of
\(H_e\). This also verifies that the displayed core represents exactly
\(H_e\), with free basis \(R,S_e\).

The new `certificate.json` records this explicit core, not a reconstruction
of the accepted 98-case atlas. It supplies two additional finite facts:

1. In the off-diagonal labelled self-product of \(\Gamma_e\), vertices are
   ordered pairs \((p,q)\) with \(p\ne q\). An edge has label \(a\) exactly
   when both coordinates have an \(a\)-edge. Every component is a tree and
   has diameter at most **4**.
2. The directed subgraph for each sign alphabet is acyclic. The maximum
   lengths of its directed paths, in the order `xy,xY,Xy,XY`, are
   \[
                    (4,6,6,4)\quad(e=-1),\qquad
                    (4,7,7,4)\quad(e=1).
   \]
   Saved integer heights increase by at least one across every edge, and
   lie between zero and the corresponding displayed bound.

Both statements are checked from all literal labelled edges by the separate
standard-library `replay.py`. In particular parallel edges and inverse
orientations are not discarded when checking the forest.

These are universal overlap bounds, not Nielsen-length bounds. Indeed, if
\(h\notin H_e\), a vertex \(w\) of
\(\mathcal T_e\cap h\mathcal T_e\) projects to
\((\pi(w),\pi(h^{-1}w))\) in the off-diagonal product. If the two coordinates
were equal, then \(w\) and \(h^{-1}w\) would differ by an element \(g\in H_e\);
the free left action on the Cayley tree would give \(g=h\), a contradiction.
A reduced path in the intersection therefore projects to a nonbacktracking
path in the product forest. Such a path has length at most four. Thus
\[
 h\notin H_e\quad\Longrightarrow\quad
       \operatorname{diam}(\mathcal T_e\cap h\mathcal T_e)\leq4.       \tag{1}
\]
The empty intersection is permitted. This also proves malnormality, but
only the stronger quantitative statement (1) is needed.

The sign-path bounds imply that no nonempty closed reduced path in
\(\Gamma_e\) is sign-coherent. Cyclic reduction of any subgroup loop remains
a closed reduced path, possibly based at another vertex. Hence every
nonidentity element of \(H_e\), including every power, has a mixed-sign
cyclic representative.

## 4. A general finite short-element reduction

Here is the mechanism removing both infinite donor quantifiers.

**Finite-reduction lemma.** Let \(\Gamma\) be a finite folded core in the
rank-two rose, representing a subgroup \(H\). Suppose its off-diagonal
self-product is a forest of maximum component diameter \(D\), every
sign-coherent path in \(\Gamma\) has length at most \(L\), and its shortest
nonempty cyclically reduced circuit has length \(g>D\).
To establish mixed-sign cyclic representatives in every
\(\langle u,hvh^{-1}\rangle\), \(u,v\in H\), it suffices to establish that
property for all conjugate joins of the finitely many cyclic conjugacy
classes represented by circuits of length at most \(D+L\) in \(\Gamma\).

**Proof.** The sign-path bound already excludes a coherent cyclic word in
\(H\). If a donor is the identity, the join is conjugate to a cyclic
subgroup of \(H\), so the assertion follows. If \(h\in H\), the whole join
lies in \(H\). Otherwise the argument proving (1) applies to \(\Gamma\):
the two invariant subtrees meet in diameter at most \(D\).

Let \(\ell_u,\ell_v\) be the translation lengths of the two nonidentity
donors in the ambient Cayley tree. Their axes lie in those invariant
subtrees. Each axis projects to a cyclically reduced circuit in \(\Gamma\),
so \(\ell_u,\ell_v\geq g>D\).

If the axes are disjoint, their shortest connector and their two cyclic
periods give a folded barbell, exactly as in Section 2.2 of the accepted
theorem. Every nonempty cyclically nonbacktracking circuit traverses a
whole donor circle. Its label cannot be sign-coherent.

If the axes intersect, their intersection is a segment of length
\(d\leq D<\min(\ell_u,\ell_v)\). For \(d=0\) the two circles form a folded
bouquet, with the same conclusion. For \(d>0\), take an endpoint of the
intersection as base and, if necessary, invert a donor. The two cyclic
periods share exactly the intersection segment. Their union in the
quotient is a theta graph, with arc lengths
\[
                         d,\quad \ell_u-d,\quad \ell_v-d.
\]
It is folded: at each endpoint of the shared segment the two continuations
are distinct, since otherwise the actual axes would intersect further.
The shared segment is shorter than either period, so its endpoints remain
distinct on each circle. There are no additional vertex identifications
or folds. The two original generator loops are accepted after simultaneous
conjugation to the chosen base.

In any folded inverse graph, free cancellation preserves path endpoints,
and cyclic cancellation of a closed reduced path leaves a closed path at
another vertex. Thus a nonidentity join element with a coherent cyclic
representative would give a directed closed walk of positive length in one
of the four sign subgraphs. Such a walk contains a simple directed cycle.
The two donor cycles are not coherent, so in the theta graph that simple
cycle must be its third cycle, formed by the two unshared arcs.

Each of those arcs is sign-coherent in the same alphabet and projects to
a path of \(\Gamma\); left translation does not change labels. Therefore
\[
                        \ell_u-d\leq L,\qquad\ell_v-d\leq L.
\]
In particular \(\ell_u,\ell_v\leq D+L\). Both donors, independently up to
ambient conjugacy and inversion, are among the finite short classes in the
lemma. The asserted short-join property excludes this last possibility.
This proves the lemma. \(\square\)

The finite bound is a *consequence of a hypothetical coherent cyclic
representative*, not an imposed restriction on the donors or conjugator.
This distinction is why a finite certificate suffices here.

## 5. All short classes and their joins

Apply the lemma with \(D=4\), \(g=7\), and \(L=6\) or \(7\).
The only nonempty cyclically reduced circuits in \(\Gamma_e\) of length
at most 10 or 11 are the three simple cycles
\[
                             R,\quad S_e,\quad T_e,
\]
up to rotation and inversion. To see completeness, a circuit traverses
whole theta arcs between branch vertices. A two-arc circuit is one of
these three cycles. A longer cyclically nonbacktracking circuit has at
least four arcs. The length-two arc cannot be adjacent to itself, so such
a circuit has length at least \(2+5+2+5=14\). A circuit cannot remain
inside an arc. This proves the classification without any Nielsen bound.

For arbitrary conjugations of two cyclic words \(P,Q\), the common-vertex
axis argument from the accepted theorem gives, whenever the axes meet,
\[
 h=P^k\,t\,Q^{-l},\qquad
 t=\operatorname{prefix}_i(P)\operatorname{prefix}_j(Q)^{-1},
 \quad 0\leq i<|P|,\quad0\leq j<|Q|.
\]
Conjugating the subgroup by \(P^{-k}\) reduces to that phase input.
Disjoint axes give a folded barbell whose circles are mixed-sign.
This argument works for repeated as well as distinct donor types.
Inverting a donor does not change the subgroup; swapping the two donor
types gives the same family after simultaneous conjugation by \(h^{-1}\).

The unordered pair \((R,S_e)\) is precisely the accepted theorem, whose
certificate is not rebuilt. The five other pairs, with repetition, are
\[
               (R,R),\quad(S_e,S_e),\quad(T_e,T_e),\quad
               (R,T_e),\quad(S_e,T_e).
\]
Their phase counts for each sign are \(49,49,100,70,70\). The new
certificate therefore contains exactly **676** cases for the two signs.
For every case it gives a folded inverse graph accepting the two literal
phase generators, and a topological order for each of the four sign
subgraphs. Hence no such graph contains a sign-coherent cyclic circuit.
It is sufficient that the graph accepts the generators; the conclusion
does not assume that a saved graph accepts *only* their subgroup.

The separate replay verifies the exact case index set, the literal
substitutions and phase conjugators, all inverse edges, determinism,
connectivity, generator loops, and every strict order inequality. Therefore
it establishes all five new short-pair boundaries. Together with the
accepted \((R,S_e)\) boundary they meet the hypothesis of the
finite-reduction lemma.

The lemma now proves the stronger mixed-sign conclusion of the theorem.
The independently accepted rank-two primitive criterion applies to each
cyclically reduced ambient representative and excludes primitivity.
The identity is not primitive. This proves the theorem and its all-Nielsen
corollary. \(\square\)

## 6. Reproduction and limits

The saved replay passed all 676 new phase cases, 1352 literal generator
loops, 20480 inverse-edge and determinism checks, 2704 sign orders, and
40960 edge inequalities. It independently reconstructed both 110-vertex
off-diagonal products, each with 60 unoriented edges and 50 tree components,
checked every component diameter, and exhaustively identified the three
short classes at thresholds 10 and 11. Six deliberately corrupted controls
were rejected. The largest saved phase graph has 19 vertices; 48 phase
graphs have rank one and 628 have rank two, both allowed.

The independently runnable finite certificate check is:

```
python3 research/experiments/ms14-nielsen-uniform-primitive/replay.py
```

`certificate.py` generates only the new core bounds and the 676 new cases,
reusing the accepted folding implementation but never regenerating the
accepted atlas. `replay.py` imports neither implementation.
The Argus Jacobian operation `graph.directed.acyclic_order.compute` is
restricted to the disjoint union of the eight new core sign subgraphs.
Its exact typed contract, payload, output, server version, protocol, and
adapter status are saved in dedicated JSON files. This is supporting exact
DAG evidence, not the proof of (1) or of the universal reduction. A timeout,
transport error, incomplete result, or UNKNOWN is not a conclusion.
The actual operation returned acyclic=true and an independently checked
order on all 88 vertices and 96 edges, with Jacobian 0.14.0, protocol
2025-11-25, adapter exit zero, and no timeout or structured error.

For the AC application, an arbitrary initial Nielsen block gives two
elements of \(H_e\). After independent conjugations, simultaneous
conjugation reduces their subgroup to the join in the theorem. A further
arbitrary Nielsen block stays inside that primitive-free subgroup, and
terminal componentwise conjugations preserve primitivity. Thus this
excludes an unrestricted Nielsen--conjugation--Nielsen block, even with
independent conjugations at that one stage. Repeated genuinely internal
conjugation stages remain outside the conclusion.

Earlier exploratory searches reached 13792 short-basis phase graphs without
a sign cycle; a later 65-second search stopped after 76760 phase graphs.
Those finite observations are not used in the proof. Only the universal
geometric reduction makes the new finite atlas exhaustive.

No Lean source or compiler verdict is claimed. The prose geometry still
requires independent review. The campaign cannot be declared complete
without the separately required verification of originality and
publication-level significance.
