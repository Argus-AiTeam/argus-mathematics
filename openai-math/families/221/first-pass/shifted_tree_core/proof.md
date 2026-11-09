# Exact shifted-tree absolute mass and retained marginals

## Scope and sources

The target is the finite-tree calculation in OpenAI, *The Mezard--Parisi
formula for diluted spin glasses*, September 23, 2026, `build/sections/trees.tex`,
Lemmas `tree:reference-total` and `tree:charging`, and
`build/sections/decorrelation.tex`, equations
`decor:relative-absolute-cost` through `decor:induction-identity`.
The staged sources, including their retained unary vertices and permission to
reuse uncolored old leaves, are authoritative.

No external theorem is needed for the proposed finite combinatorial proof.
The manuscript cites Mezard--Parisi and Panchenko--Talagrand for hierarchical
power means, not for these extension coefficient assertions. Those literature
results are not assumptions of the claim here. A search of the inherited
project Wiki found no prior result about this extension rule. No originality
claim is made by this source comparison.

Finite enumeration alone cannot establish the target. In particular, binary
trees, distinct depths at distinct aligned vertices, and fresh-only histories
are not substitutes for the manuscript's hypotheses.

## Statement to be decided

Let a finite old tree have all leaves at depth \(L\), with all unary vertices
retained, and let \(m_d=d/L\). Protect one old leaf (the anchor). At each color,
either use an uncolored old leaf with coefficient one, or adjoin a completely
new path at an internal vertex \(v\), with coefficient
\(m_{d(v)}-n(v)m_{d(v)+1}\). Protect the chosen leaf.

For two aligned old copies of an arbitrary labeled topology \(S\), split at
\(d<e\), where \(e\) is the first internal split of \(S\), shift every internal
target split by one. Require the anchor and new colors to have these two
shifted copies, and add side-I colors before side-II colors. Set
\(J=\kappa(S^+)^2\), with the manuscript's full multiway-branching product.

The obligations are: the signed reference product, the coefficients of each
retained side-II prefix class, the equality of retained sampling laws within
each class, and an absolute extension mass bound divided by \(|J|\) independent
of \(L\), including coincident depths at distinct vertices. The thermodynamic
limit, perturbation identities, and pressure equality are outside this claim.

**Stronger result.** The normalized absolute coefficient mass in this
construction is exactly
\[
                  \boxed{\ \sum_E|c_E|/J=2s^2+L^{-1}\ } . \tag{0}
\]
It needs no interior lower bound on the branching depths. Section 6 proves
this using a one-old-leaf normal form, rather than estimating just the first
small factor at each branching vertex. The separation of shifted depths from
all old branching depths remains a hypothesis.

## Universal retained-kernel theorem

Write \(s=|S|\geq2\), \(B=b(S)\), \(q=2s\), and \(k=2s-1\).
Assume all old and shifted depths are admissible, and that every shifted
internal depth is absent from the set of *all* old branching depths, including
\(d\). There is no requirement that distinct shifted vertices have distinct
depths. In particular corresponding vertices of the two copies are aligned.
Assume also that each shifted internal depth \(t\) satisfies \(m_t\geq\tau>0\).
The manuscript's regularity hypotheses imply these assumptions for sufficiently
large \(L\), with, for example, \(\tau=\eta/2\).

Let \(P_\ell\), \(d\leq\ell<e\), be the sampling law of every old path together
with a new marked prefix through \(e\), freshly diverging from the old II stem
at \(\ell\). Let \(P_{\mathrm{old}}\) be the old sampling law with the old II
prefix through \(e\) marked. These are probability laws, conditional on any
fixed root, for arbitrary path-dependent probability kernels. New variables
below the marked depth are not included. Identify the retained coordinates
within each class, without identifying distinct vertices that happen to sample
the same value.

**Theorem.** For every bounded measurable function \(G\) of the old variables
and this marked prefix, the signed extension sum satisfies
\[
 \sum_E c_E\,E_{\mathcal T_E}G
 =
 J\left(m_e E_{P_{\mathrm{old}}}G
       -\sum_{\ell=d}^{e-1} c_\ell E_{P_\ell}G\right),
 \qquad
 c_d=(d+2)\delta,\quad c_\ell=\delta\ \ (\ell>d).
 \tag{1}
\]
Here the interpretation of \(G\) is the same coordinatewise in each law.
The history has no dependence on sampled values. Moreover, with
\[
 H=2\sum_{v\in\operatorname{Br}(S)}(a_v-2),\qquad b=2B,
\]
one has \(J\ne0\) and
\[
 \frac{\sum_E|c_E|}{|J|}
 \leq
 \frac{k!}{(k-b)!}(q+k)^b[2(q+k)]^{k-b}\tau^{-H}.
 \tag{2}
\]
All assertions are uniform over admissible topologies, old-leaf reuse, kernels,
and depths subject to the stated size and interior hypotheses. The constant
does not depend on hierarchy depth. Equation (1) is a signed retained-kernel
identity, not merely an identity for a particular overlap.

### 1. Cancellation in a reference-free subtree

For a subtree rooted at depth \(u\), put \(r=\#\{\text{its leaves}\}\).
Sum \(m_v-n_vm_{v+1}\) over its internal vertices. Every nonroot internal
vertex has one incoming contribution \(-m_v\), canceled by its own \(+m_v\).
Each terminal vertex contributes \(-m_L=-1\); the root contributes \(+m_u\).
Thus the internal sum is \(m_u-r\).

If the subtree has no reference leaf, every leaf in it is an unused old leaf:
every previously added fresh leaf is already colored, and is therefore a
reference. Consequently the sum of *all* eligible choices inside this subtree,
including old-leaf choices, is \(r+(m_u-r)=m_u\). This observation is exactly
where omitting old-leaf reuse would give the wrong answer.

At a required divergence vertex of depth \(t\), let \(n\) be the full current
child count and \(j\) the number of excluded children containing references.
All the remaining \(n-j\) child subtrees are reference-free. Their total is
\((n-j)m_{t+1}\); the fresh choice at the vertex has coefficient
\(m_t-nm_{t+1}\). The row sum is therefore
\[
 m_t-nm_{t+1}+(n-j)m_{t+1}=m_t-jm_{t+1}. \tag{3}
\]
This argument includes terminal children and arbitrary multiway branches.
The continuation is unrestricted inside a reference-free child, as required
by the manuscript's constraints.

For any prescribed reference topology, its splitting depths with existing
references determine the divergence vertex and excluded reference children.
Starting with the last color and summing backwards, (3) factors out a number
depending only on that reference topology, not on how the old tree realizes
the earlier colors. At a final branching vertex of arity \(a\), the successive
new child groups encounter \(j=1,\ldots,a-1\). Hence the product is exactly
\(\kappa=\prod_v\prod_{j=1}^{a_v-1}(m_{t_v}-jm_{t_v+1})\), for every color
order. There is no binary-tree assumption or missing multiway factorial.

### 2. The prefix classes

All side-I reference paths follow the old anchor through depth \(e\).
They therefore leave every old-II child count through depth \(e-1\) unchanged.
The old vertex at \(d\) has two children, while each old-II vertex at
\(d<\ell<e\) is unary.

Fix the side-I history and the first side-II choice. Summing all subsequent
side-II colors backwards gives \(\kappa(S^+)\), by (3). A first side-II
choice whose prefix through \(e\) is new must be the fresh choice at the
old-II stem vertex \(\ell<e\). Its coefficient is
\(m_d-2m_{d+1}=-c_d\) at \(d\), or
\(m_\ell-m_{\ell+1}=-\delta=-c_\ell\) at \(\ell>d\).
It is independent of the side-I history. Summing side I gives the other
\(\kappa(S^+)\), so the coefficient of this whole class is \(-c_\ell J\).

The remaining first choices are exactly the choices *inside* the old-II
subtree rooted at \(e\), including its root, all its internal vertices, and
its unused old leaves. This subtree contains no reference before the first
side-II choice, so Section 1 gives their sum \(m_e\). The later side-II and
side-I sums again supply the two factors \(\kappa(S^+)\). Thus the old-prefix
class has coefficient \(m_eJ\), directly, without appealing to a presumed
total coefficient.

As a consistency check,
\(\sum_{\ell=d}^{e-1}c_\ell=(d+2+e-d-1)\delta=m_e+\delta\).
The full signed coefficient is therefore \(-\delta J\), in agreement with
the additional reference separation factor at \(d\).

### 3. Retained marginals

Within one prefix class, retain all old paths and the first side-II prefix
through \(e\). Delete all other new portions. Starting at the deepest deleted
vertex, integrate its probability kernel; this gives one, conditionally on
its entire ancestral prefix. Repeating this operation deletes each unused
subtree. The same argument applies when the marked prefix ends before a leaf.
A reused old leaf adds no integration variable. The old variables themselves
are never deleted.

The result is \(P_\ell\) or \(P_{\mathrm{old}}\), independent of the history
within the class. Kernels may depend on the complete prefix, and \(G\) may
depend arbitrarily on the old variables. No independence between \(G\) and
the marked prefix is asserted or needed. Only sibling independence
conditional on the ancestral prefix, as in the manuscript's tree law, is
used. Thus the fixed class expectation can be pulled out of the signed
coefficient sum. The coefficients in Section 2 prove (1).

For the manuscript's application, take
\(G=f(a\mathbin{\cdot}b_{\mathrm{marked}})\). This yields exactly its projected
left side. The anchor-only construction has total coefficient \(-\delta J\).
Substituting these into the prescribed-tree perturbation identity and moving
the \(m_e E[f(a\cdot b)]\) term gives `decor:induction-identity`, with the same
sign. This is an implication *from* that perturbation identity; that
probabilistic identity is not proved here.

### 4. Absolute charging, including coincident depths

For a current full tree with \(r\) leaves, all fresh coefficients are
negative. Section 1 at the root, using \(m_0=0\), shows that their absolute
sum is \(r\). There are at most \(r\) eligible old leaves, each of coefficient
one, so an unrestricted step costs at most \(2r\leq2(q+k)\).

Each specified target branching vertex whose depth is absent from all old
branching depths first becomes branching at a fresh *unary* divergence.
If the vertex did not exist initially, it was first introduced as a unary
part of a fresh path, and the same assertion applies. A fresh extension
creates at most one branching vertex: its divergence vertex. Its new path
is unary everywhere else. Consequently the first-creation steps of \(b\)
distinct target vertices are distinct, even if some depths coincide.

Assign these \(b\) vertices to their distinct creation steps. There are at
most \(k!/(k-b)!\) assignments. For a fixed assignment, discard every
constraint except that each designated step makes a unary divergence at its
assigned depth. At a fixed depth there are at most \(r\leq q+k\) vertices:
their descendant leaf sets are nonempty and disjoint. Each unary divergence
has absolute coefficient \(\delta\). Thus a designated step costs at most
\((q+k)\delta\), and every other step at most \(2(q+k)\).
Successive finite summation gives
\[
 \sum_E|c_E|
 \leq \frac{k!}{(k-b)!}(q+k)^b[2(q+k)]^{k-b}\delta^b. \tag{4}
\]
If a history is counted for several assignments, this only enlarges the
nonnegative upper bound. Repeated assigned depths cause no problem; the
assigned *steps* remain distinct. Here \(b=2B\leq2s-2<k\).

For comparison with the formal history theorem, there is also a coarser
bound not requiring assignment enumeration. Let \(D\) be the set of specified
depths, with \(|D|\leq b\leq k\). Mark every unary divergence at a depth in
\(D\), including those not ultimately used by the target. Each successful
history has at least \(b\) marked steps by the preceding creation argument.
The marked one-step absolute mass is at most \(|D|(q+k)\delta\).
Divide each marked edge weight by \(\delta\). The rescaled row mass is at
most \(C'=(2+k)(q+k)\), uniformly over every history prefix. Backward
summation bounds rescaled \(k\)-step mass by \((C')^k\). Since \(0<\delta\leq1\)
and every successful history has at least \(b\) marks,
\[
 \sum_E|c_E|\leq (C')^k\delta^b. \tag{5}
\]
This weaker constant is enough for the depth-uniform conclusion and is the
history bound formalized below. Dead history prefixes can be represented by
nodes with zero allowed children; they contribute zero mass.

### 5. Dividing by the full multiway coefficient

At each target vertex, the \(j=1\) factor is \(-\delta\). For \(j\geq2\),
\[
 |m_t-jm_{t+1}|=(j-1)m_t+j\delta\geq\tau.
\]
The two target copies have \(b\) distinct branching vertices, regardless
of coincidences of their depths. Therefore
\[
 |J|\geq\delta^b\tau^H>0. \tag{6}
\]
Combining (4) and (6) proves (2). Combining (5) and (6) gives the alternative
formal constant \([(2+k)(q+k)]^k\tau^{-H}\).
The interior hypothesis is essential to this argument for multiway
vertices; it has not been dropped or replaced by an assumption of distinct
depths. In particular no assertion of a depth-uniform bound as
\(\tau\downarrow0\) follows from this charging argument alone.

### 6. An exact absolute-mass theorem without an interior condition

The following more general identity explains the unexpectedly small absolute
mass of the shifted construction.

**Reference-free absolute-mass theorem.** Allow any strictly increasing mesh
\(0=m_0<\cdots<m_L=1\). Let \(O\) be an arbitrary full old subtree rooted at
depth \(u\), with \(q\geq1\) leaves, all eligible. Require \(r\geq1\) colors
to form any admissible target tree \(U\) from that root, with no branching
depth of \(U\) a branching depth anywhere in \(O\). The first color may make
any old or fresh choice inside \(O\); subsequent colors obey the prescribed
reference splits. Then
\[
 \sum_E c_E=m_u\kappa(U),\qquad
 \sum_E|c_E|=(2qr-m_u)|\kappa(U)|. \tag{7}
\]
More precisely, there are exactly \(qr\) histories that select an old leaf.
Each selects exactly one, has coefficient \(\kappa(U)\), and is indexed
bijectively by that old leaf and its target color. Every other history has
the opposite sign. The singleton target has \(\kappa(U)=1\) and is included.
The finite family here records the choices in a fixed color order, not
artificial permutations of fresh-child names.

**Proof.**

First, two target colors cannot both select old leaves: their last common
vertex would be an old branching vertex, whereas its required depth is a
target branching depth. The disjoint-depth hypothesis rules this out.

Next consider a target tree already containing a fixed old leaf \(a\) as
an anchor, with that leaf's target position fixed. Its remaining reference
extensions are *rigid*: in any color order there is exactly one history,
all its choices are fresh, and its coefficient is \(\kappa(U)\).
To see this, take the next required divergence vertex \(v\). If it is not
an old vertex, every current child was introduced by an earlier fresh
reference and contains such a reference. If it is an old vertex, it is
unary in the old tree, because its depth is a target branching depth.
Moreover it must be on the old anchor path. Otherwise an existing reference
passing through \(v\) and the anchor would have an old branching depth
as their last common depth, contrary to the prescribed target tree.
Its unique old child therefore contains the anchor. Every other current
child contains an earlier fresh reference. Thus in both cases *every*
current child at \(v\) is excluded, and the fresh choice at \(v\) is the
only allowed choice. Induction gives uniqueness. Its factors are exactly
those of \(\kappa(U)\), by the child-group count \(j=1,\ldots,a_v-1\).

Now fix an old leaf \(a\) and a target color \(j\) that is to select it.
In a history with that selection, every other selection is fresh.
Move the old selection to the start, preserving the relative order and
labels of all fresh choices. This leaves the current *uncolored tree shape*
at every fresh choice unchanged: selecting an old leaf creates no vertex,
changes no child count, and has coefficient one. Every final pairwise
target splitting constraint remains satisfied. Early inclusion of the old
reference merely imposes sooner a constraint that the final history already
satisfies. No other old selection needs to remain eligible.

Conversely, the rigid history anchored at \(a\) in target position \(j\)
can move its old selection back to position \(j\). The leaf is still
unused there; all other operations are fresh. Its shape, coefficients, and
final reference tree are unchanged. These two operations are inverse.
Thus each pair \((a,j)\) gives precisely one history, of coefficient
\(\kappa(U)\). This proves the claimed \(qr\) normal forms, not just their
total weight.

Every internal fresh coefficient is strictly negative. Also
\(\operatorname{sgn}\kappa(U)=(-1)^{r-1}\), since
\(\sum_v(a_v-1)=r-1\).
A one-old history has \(r-1\) fresh choices; a zero-old history has \(r\).
Let \(P=qr|\kappa(U)|\) be the absolute mass of the one-old histories,
and \(Q\) that of the zero-old histories. Section 1 gives the signed total
\(m_u\kappa(U)\) (sum the later colors, then the unrestricted first color).
Multiplying by the sign of \(\kappa(U)\) gives
\(P-Q=m_u|\kappa(U)|\). Therefore
\(P+Q=(2qr-m_u)|\kappa(U)|\), proving (7).

Apply (7) to the old-II subtree at \(e\), where \(q=r=s\).
For side I the old anchor is present from the start, so rigidity gives its
unique history of coefficient \(\kappa(S^+)\).
Every fresh-prefix class has a wholly new stem below \(\ell<e\), and its
later target-II history is rigid without any unused old subtree; all its
history coefficients have the same negative sign after multiplying by
side I. Its absolute class mass is consequently \(c_\ell J\).
The old-prefix class has absolute mass \((2s^2-m_e)J\), by (7).
Adding them and using \(\sum_\ell c_\ell=m_e+\delta\) proves (0).

Equivalently, the entire shifted construction has exactly \(s^2\)
positive histories, one for each old-II leaf / target-II color pair.
Every one has coefficient \(J>0\). All other histories have negative
coefficient, and the signed total is \(-\delta J\).
Thus its positive and negative absolute masses are respectively
\(s^2J\) and \((s^2+\delta)J\), giving the same formula.

This is the coefficient \(\ell^1\) norm on extension *histories*.
It is not a claim that the total variation of a retained sampled measure
equals that norm; pushing histories to retained variables can cause
additional cancellation. In particular, (0) supplies the bound actually
needed for projection errors, with the explicit constant \(2s^2+1\)
for all \(L\geq1\), without an interior assumption.

## Comparison with primary sources

The strongest prior result in the audited source for this particular use is
the bound `decor:relative-absolute-cost`, \(C_{s,\eta}\), obtained from
`tree:charging`. The exact formula (0) replaces that unspecified constant
and removes its interior-depth dependence while keeping the disjoint-depth
hypothesis. It does not repair or refute those valid prior bounds.
The manuscript already gives \(2+\delta\) for the two-old-path, one-color
case in the opening of its extension-coefficient subsection. Formula (0)
extends that singleton calculation to every topology; (7) also treats
unequal old and target leaf counts and nonuniform meshes.

A bounded primary-source lookup inspected the target's finite-tree and
decorrelation sections; Panchenko--Talagrand, *Bounds for diluted mean-fields
spin glass models*, arXiv:math/0405357, Section 5, Proposition 2, equations
(5.3)--(5.5); Mezard--Parisi, *The Bethe lattice spin glass revisited*,
arXiv:cond-mat/0009418, Appendix I, equations (91)--(94) and the derivative
discussion after (99); and Ghirlanda--Guerra, *General properties of overlap
probability distributions in disordered spin systems. Towards Parisi
ultrametricity*, arXiv:cond-mat/9807333, Section 3, equation (28).
The latter three discuss power means/cascades or additional-replica overlap
mixtures, not the general coefficient absolute-mass formula (7).
No match for (7) or its one-old-leaf normal form was located in that bounded
lookup. Ruelle's original paper was not independently inspected. These are
comparison sources, not unproved dependencies of the self-contained proof.
The lookup is not a proof of originality, and no `verified_new` assessment
is claimed.

## What is machine checked, and what is not

`Main.lean` proves the arbitrary-full-tree cancellation and reference-free
row formula, the full fresh absolute mass, unary-row bounds, backward
products on arbitrary finite history trees, the rescaled history charging
bound, all multiway denominator bounds without injectivity of depths, the
prefix coefficient algebra, and finite-kernel pruning and class factorization.
It also checks deletion of an identity/weight-one old-selection move from
an arbitrary list of state-dependent weighted moves, and the exact
absolute-mass conclusion from the one-old-leaf sign/count normal form.
`statement_fidelity.md` specifies every formal hypothesis and the precise
boundary: the identification of the manuscript's histories with these
abstract history trees, the geometric rigidity and normal-form bijection,
the distinct-creation-step argument, and general measurable-kernel pruning
are the explicit mathematical arguments above,
not additional conclusions claimed to have been checked by Lean.

`verify.py` is an independent executable model of the literal extension rule.
Its exact finite fixtures check the signed classes and retained old-labeled
tree skeletons, include genuine three- and four-way vertices, nested shapes,
old-leaf reuse after the first side-II choice, different color orders, and
equal-depth sibling vertices. Its output remains a finite experiment and
does not replace this universal proof. The Jacobian typed payload and output
check precisely the algebra in (3); their successful adapter status is not a
universal theorem.

No manuscript assertion has been refuted by this work. No theorem about
thermodynamic limits, covariance decay, perturbation selection, or the full
Mezard--Parisi variational equality follows from this isolated certification.
Independent Reviewer replay and assessment of the mathematical/formal
translation are still required. Novelty and publishable significance remain
unassessed rather than being inferred from successful compilation.
