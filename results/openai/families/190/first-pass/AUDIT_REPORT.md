# Exact distance for the literal ordered-matrix construction

## Scope and primary sources

The objects are the literal \(66\)-by-\(66\) pattern \(H\) and matrices
\(A_h\), not the upstream Lean comparator. Throughout \(h\geq1\),
\(m=2^h\), and \(n=(386h+2)m\). Ordered copies match both zeros and ones;
edits may flip any binary entry in either direction.

All source references below are to the staged September 25, 2026 manuscript
`research/openai_manuscript/Polynomial-removal-fails-for-ordered-binary-matrices-September-25-2026/build/`.
The following passages were read directly, rather than inferred from the
title or an external summary:

* `sections/02-construction.tex`, equation `eq:pattern-definition` and the
  definition of \(S\): the dense \(64\)-by-\(64\) anchor, its five-bit corner,
  the two unit-vector signatures, and body \(P=((1,0),(1,1))\).
* The same section, `eq:tree-orders`, `eq:body-modes`, and
  `eq:variable-entries`: row/column orientations, shared singleton leaves,
  six modes per level, and the four threshold rules.
* `sections/04-distance.tex`, Proposition `prop:distance`: the claimed
  arbitrary-binary-edit lower bound \(m^2\), using protected selections.
* `sections/03-pinning.tex`, Lemmas `lem:nonanchor-traces` and
  `lem:anchor-rigidity`: at most \(27\) non-anchor traces on five columns
  and localization of every anchor copy.
* `sections/03b-count.tex`, Proposition `prop:copy-count`: all original
  copies use the leaf diagonal, giving \(N_H(A_h)\leq m n^{130}\).
* The same section, Remark `rem:hitting-not-repair`: changing the \(m\)
  diagonal leaf ones to zeros creates a \(W_{h,d}^+\) copy. This is a known
  failed repair, not a manuscript error.

No external removal theorem is needed for the proposed exact-distance
proof. The manuscript's historical literature claims are outside this
bounded theorem and are not assumed here. A targeted search of the inherited
Wiki found no relevant ordered-binary-matrix result. Publication-level
novelty and independent acceptance remain for the Host-invoked Reviewer.

## Theorem

For every integer \(h\geq1\), the literal construction satisfies
\[
 \boxed{\min\operatorname{edits}_H(A_h)=m^2=4^h},\qquad
 \boxed{N_H(A_h)=2m^{130}}.
\]
In particular its manuscript bound \(N_H(A_h)\leq m n^{130}\) is retained.
An optimal repair deletes the ones in
\[
 R_{h,0}^-\times\widehat C_{W_{h,0}^-}(1)
 \quad\text{and}\quad
 R_{h,1}^-\times\widehat C_{W_{h,1}^-}(1).
\]

The improvement over the strongest relevant prior statement is mathematical:
the manuscript proves only the lower edit bound \(m^2\) and the upper copy
bound \(m n^{130}\). Here a matching repair is proved safe against *every*
ordered copy, the number of copies is computed exactly, and the lower-bound
selection is made deterministic. These are extensions of a construction
that passes this audit, not a refutation of that construction.

## 1. A deterministic protected-selection partition

Give each position within a block its zero-based local index. Set
\(q_i=2^{h-i}\), so there are \(2^i\) blocks of size \(q_i\) in each
depth/sign class. A class position is specified by its node index and its
local index. The two sign names at depth \(h\) denote one class, not two.

**Radix lemma.** If \(m=qk\) with \(q,k\geq1\), then for every fixed
\(a\in[0,m)\) the map
\[
 b\longmapsto
 \left(\left\lfloor\frac{(a+b)\bmod m}{q}\right\rfloor,\ b\bmod q\right)
 \tag{1}
\]
is a bijection from \([0,m)\) to \([0,k)\times[0,q)\).

Indeed, write \(b=qt+r\), \(0\leq r<q\), and
\(a+r=qc+s\), \(0\leq s<q\). Then
\[
 (a+b)\bmod(qk)=q((c+t)\bmod k)+s.
\]
Consequently, from an image \((p,r)\) recover the unique input by
\[
 b=q\bigl((p-\lfloor(a+r)/q\rfloor)\bmod k\bigr)+r,
 \tag{2}
\]
where this difference is taken modulo \(k\), not truncated as a
nonnegative integer subtraction. This proves the lemma, including the
boundary cases \(q=1\) and \(k=1\).

For each \((a,b)\in[0,m)^2\), select one position from every size-\(m\)
class on each axis as follows. Put \(z=(a+b)\bmod m\). Select local index
\(a\) in every anchor row group and in the dummy row block, and local index
\(b\) in every anchor column group and in the dummy column block. In each
row class at depth \(i\), select node \(\lfloor z/q_i\rfloor\) and local
index \(a\bmod q_i\); on the column axis use the same node and local index
\(b\bmod q_i\). At the leaf select the shared position once on each axis.
These node indices form one common root-to-leaf path.

Call a cell *protected* if at least one of its positions is an anchor or
a dummy, or if both positions have depth zero. Every protected cell
belongs to exactly one of these \(m^2\) selections:

* If both positions are anchors or dummies, their local indices determine
  \(a,b\) directly.
* If its row is an anchor or dummy and its column is variable, the row
  determines \(a\); (1) determines \(b\). The opposite case is the same
  lemma with the two inputs interchanged.
* For two depth-zero variable positions, the selected local indices are
  exactly \(a,b\), since \(q_0=m\).

These cases are disjoint after classifying a position as either variable
or anchor/dummy. Thus the protected portions of the selections partition
the protected cells. In particular any set of \(M<m^2\) edited cells
contaminates at most \(M\) selections, regardless of which unprotected
cells were edited. One selection has no protected edits.

## 2. Arbitrary binary edits: the lower bound

Let \(B\) be any binary matrix with fewer than \(m^2\) differences from
\(A_h\), and take the uncontaminated selection from Section 1. Denote
its selected variable positions by \(x_i^\pm,y_i^\pm\) and its dummy
positions by \(x_*,y_*\). Every selected anchor entry and every selected
anchor-to-body signature is unchanged. Every selected dummy incidence
against a variable position is one. The selected root entries are
\[
 B(x_0^+,y_0^+)=1,\qquad B(x_0^-,y_0^-)=0.
 \tag{3}
\]
At each mode the selected anchor representatives are an actual copy of
\(S\) in \(B\). Any correctly ordered body \(P\) in that mode therefore
completes to a copy of the literal \(H\).

Suppose \(B\) contains no \(H\). If its plus and minus diagonal entries
at depth \(i-1\) are respectively one and zero, avoiding \(P\) in
\(V_i^+\) and \(V_i^-\) gives
\[
 B(x_i^+,y_{i-1}^+)=1,\qquad
 B(x_i^-,y_{i-1}^-)=0.
 \tag{4}
\]
For example the two forbidden alternatives are respectively
\(((1,0),(1,1))\) with rows child/parent and parent/child. Set
\(d=\lfloor z/q_i\rfloor\bmod2\). Avoiding \(P\) in
\(W_{i,d}^+\) and \(W_{i,d}^-\), with the dummy row supplying their
bottom ones, now gives
\[
 B(x_i^+,y_i^+)=1,\qquad B(x_i^-,y_i^-)=0.
 \tag{5}
\]
The row/column orders hold because the chosen nodes are parent and child:
plus row child before parent, minus row parent before child, plus column
parent before child, minus column child before parent. The dummy row is
last and the dummy column is first among non-anchors. All signatures in
these modes are protected; the intermediate variable entries in (4)--(5)
need not be unchanged.

Induct from (3). At depth \(h\) the two values in (5) are values of
one and the same cell, an impossibility. Thus every such \(B\) contains
\(H\), proving \(\min\operatorname{edits}_H(A_h)\geq m^2\).
This argument also gives an algorithm: choose an uncontaminated pair
\((a,b)\), scan the four bodies at each successive depth, and output
the first \(P\) with its selected anchor. It must occur.

## 3. Deletion-stable anchor rigidity

The following stability statement is stronger than what is needed for
the proposed repair but keeps an essential scope restriction.

**Stability lemma.** Starting with \(A_h\), one may change an arbitrary
collection of its variable-to-anchor unit-vector incidences to zero,
provided each deletion is of a *whole anchor group against one variable
position*, on either axis. Keep all dummy incidences, all anchor-to-anchor
entries, and all non-anchor-to-non-anchor entries unchanged. In every
resulting matrix \(D\), every ordered copy of \(S\) is still exactly one
representative of each anchor group of one mode. Moreover every ordered
\(H\)-copy in \(D\) was already a copy in \(A_h\).

Here a dummy position is not a variable position. The lemma does not
permit arbitrary dummy-signature edits. It also does not permit a partial
deletion within an anchor group. Neither extension is used.

**Proof of the finite anchor facts.** In columns \(1,\ldots,59\),
rows \(1,\ldots,59\) have their distinct diagonal zeros, whereas rows
\(60,\ldots,64\) are all ones there and are distinguished by their distinct
five-bit suffixes. Thus all rows are distinct and have at least \(58\)
ones. The first \(59\) columns each have exactly one zero. The last five
are distinct coordinate functions on the \(32\) words, each with \(16\)
zeros, so all columns are distinct and have at least \(48\) ones.
The first \(32\) rows or columns meet no replacement entry, giving at most
one zero in each corresponding restriction. The corner lists all words.

**Incidence and trace facts, uniformly in \(h\).** A non-leaf variable row
of depth \(i\) and sign \(\sigma\) participates only in
\(V_i^\sigma,V_{i+1}^\sigma,W_{i,d}^\sigma\), omitting nonexistent
levels; a leaf row participates in \(V_h^\pm,W_{h,d}^\pm\).
A non-leaf variable column participates only in
\(V_{i+1}^\sigma,W_{i+1,0}^\sigma,W_{i+1,1}^\sigma,W_{i,d}^\sigma\);
a leaf column participates only in \(W_{h,d}^\pm\).
Each participating mode contributes a single unit-vector one. Thus a
variable position has at most four ones against any opposite-axis
selection using at most one position from each anchor group. Deletions
only reduce that number, and leave at most one one per individual mode.

On five variable columns, split by depth/sign class, counting the common
leaf class once, and order within each class by node index. In each class
every variable row has a suffix of ones, possibly empty. A non-leaf row
is supported in at most two classes; a leaf row in at most three. A class
with \(a\) chosen columns has at most \(a\) distinct nonempty suffixes, so
there are at most five such suffixes in total. A variable trace is a union
of at most three of them, allowing at most
\(\sum_{j=0}^3\binom5j=26\) traces. The dummy row adds at most one.
If a chosen column is dummy, its coordinate is constant one, allowing
at most \(16\) words instead. No five non-anchor columns are shattered.
The same statement holds in \(D\), because these entries were not edited.

**Rigidity.** Anchor groups remain groups of identical rows or columns:
deleting a whole group against a variable position preserves this
identity. Dummy positions also remain identical. In an \(S\)-copy,
distinctness of \(S\)'s rows and columns therefore permits at most one
position from each anchor group and at most one dummy on either axis.
If at most \(32\) selected positions on each axis were anchors, its last
\(32\) rows and last five columns would be non-anchors and would realize
all five-bit words, contradicting the trace bound. Thus one axis has
more than \(32\) anchors.

Suppose it is the row axis. The first \(32\) selected rows are anchors.
No selected column is variable, since it would have at most four ones
there, instead of the required at least \(31\). Hence at least \(63\)
selected columns are anchors. Every two such columns have a common one
in the first \(32\) rows, and hence belong to the same mode \(t\), because
different anchor modes meet in zeros. An anchor row from a different
mode would have at most one one in the whole copy, contradicting row
density. Thus all selected anchor rows belong to \(t\).

A dummy column has at most one one against these anchor rows of \(t\),
contradicting density on the first \(32\) selected rows; there is no dummy
column either. All \(64\) selected columns are consequently anchor columns
of \(t\). Any non-anchor row has at most one one against them and cannot
be a row of \(S\). All selected rows are anchors of \(t\) as well.
If the initially dense axis was the column axis, the same argument
interchanges rows and columns: the first-\(32\) density, incidence bound,
zero cross-mode entries, and unit dummy signatures hold on both axes,
and both full row and column weights exceed one.
There are \(64\) distinct groups on each axis and \(64\) selected positions,
so every group is represented exactly once, in order.

Finally the two body rows of an \(H\)-copy must have signatures
\(e_1^{\mathsf T},e_2^{\mathsf T}\) against this complete anchor. They
cannot be anchor rows: those give either a dense row of \(S\) or zero.
Each non-anchor signature in each mode was originally zero or one of
the two unit vectors, and deletion cannot create a new nonzero unit
vector. Therefore a surviving body role was the same original role.
The identical argument applies to body columns. Body entries and anchor
entries have not changed. The identical \(66\) row and column positions
already formed \(H\) in \(A_h\). This proves the stability lemma. \(\square\)

## 4. Classifying and counting all original copies

Apply the stability lemma with no deletions. Every \(H\)-copy has the
designated body roles of a single mode. Write \(u=\lfloor p/2\rfloor\)
for a child row's parent index, \(a\) for a parent row index, \(b\)
for a parent column index, and \(v=\lfloor q/2\rfloor\) for a child
column's parent index.

In \(V_i^+\), row order gives \(u\leq a\); the bottom-right one gives
\(a\leq b\), whereas the top-right zero requires \(u>b\).
In \(V_i^-\), row order gives \(u\geq a\); the top-right zero gives
\(a\geq b\), whereas the bottom-right one requires \(u<b\).
Both are impossible.

In \(W_{i,d}^+\), column order and the top-left one give
\(u\leq b\leq v\). The common parity \(p\equiv q\equiv d\pmod2\)
implies \(p=2u+d\leq2v+d=q\); the top-right entry cannot be zero.
In \(W_{i,d}^-\), column order and the top-right zero give
\(v\leq b\leq u\), hence \(p\geq q\) by the same parity identity.
For \(i<h\), its top-left entry is \(\mathbf1[p<q]=0\), impossible.
At \(i=h\) the shared-leaf rule makes that entry
\(\mathbf1[p\leq q]\), so it is one exactly when
\[
 p=q,\qquad u=v=b.
 \tag{6}
\]

Conversely every choice in (6) does give the body \(P\), in the correct
orders. There are \(m\) choices of leaf \(p\); its parity fixes the
mode \(W_{h,p\bmod2}^-\). There are \(m\) choices of dummy row and
exactly two choices of column in its depth-\(h-1\) parent minus block.
Each of the \(128\) anchor groups independently contributes \(m\)
representatives. Thus
\[
 N_H(A_h)=m\cdot m\cdot2\cdot m^{128}=2m^{130}.
 \tag{7}
\]
This counts every ordered copy once: rigidity fixes its mode and groups,
and (6) fixes the possible leaf and parent blocks. Since \(m\geq2\)
and \(n\geq m\), (7) is at most \(m n^{130}\).
It also verifies the manuscript's leaf-diagonal assertion.

## 5. The optimal repair, with no new copies

For each leaf \(p\), delete its incidence with all \(m\) columns of
anchor group one of \(W_{h,p\bmod2}^-\). This is a whole unit-vector
incidence of precisely the permitted type in Section 3. It turns that
row's \(e_1^{\mathsf T}\) signature in its terminal minus mode into zero.
Nothing else is edited.

If the resulting matrix contained \(H\), Section 3 would make it an
original copy, and Section 4 would make its mode \(W_{h,d}^-\), with a
leaf row of parity \(d\) in the first body role. That row now has zero
signature, not \(e_1^{\mathsf T}\), a contradiction. This excludes every
ordered copy, including copies with an initially unprescribed prefix;
it is not merely a check of the original designated bodies.

Each parity class has \(m/2\) leaf rows and each target anchor group has
\(m\) columns. The two rectangles are disjoint and every entry was one.
The number of binary changes is
\(2(m/2)m=m^2\), proving the upper bound. Combined with Section 2,
this proves the theorem.

More generally, suppressing the signatures of an arbitrary subset \(T\)
of leaves changes \(m|T|\) cells and leaves exactly
\(2(m-|T|)m^{129}\) copies. The same stability argument proves that
these are precisely the original copies with leaf outside \(T\).

## 6. Exact evidence and its limits

`verify.py` uses only the Python standard library. Run it from any directory
as `python3 /path/to/9000190/verify.py`; it reconstructs the full
`exact_certificate.json` and requires exact equality. Its
`--write-certificate` flag regenerates that certificate.

The certificate checks the literal finite \(S\), four universal
linear-combination contradictions and the terminal equality implications,
the radix inverse through depth seven, the actual ordered block bodies
and edit rectangles through depth four, and all five distinct non-anchor
block-column sets through depth three. Duplicate columns within one block
cannot shatter even two coordinates; the block trace computation therefore
covers all potentially shattered five-position configurations at those
depths. The observed trace maxima for depths one, two, three are \(5,9,11\),
respectively, not a claim that those are the all-depth maxima.

For each of depths one through three, it also extracts and checks all
\(4356\) entries and both orders of a concrete \(H\)-copy in four edited
hosts: the original, the failed diagonal repair, all but one plus-root
cells flipped, and the proposed optimal repair with one deletion omitted.
These explicitly test the strict lower-bound threshold \(m^2-1\).
They do not exhaust arbitrary edits; Section 2 proves the arbitrary-edit
statement.

The inspected Jacobian operation `sat.solve` returns `UNSAT` for the
five-variable, depth-one propagation obstruction. Its exact payload,
typed result, server version, and protocol are in
`research/certification/jacobian/`. A separate exact \(32\)-assignment
truth table replays it in `verify.py`. The initial noncanonical-CNF
validation error is preserved separately and supplies no mathematical
evidence; the typed canonicalization and corrected successful operation
are preserved too. The all-depth proof does not depend on trusting Z3.

`Main.lean` formalizes the radix injectivity, the raw four-body all-depth
propagation obstruction, the common-parity mode arithmetic, and the exact
count/repair power identities. `research/STATEMENT_FIDELITY.md` states its
quantifiers and the host-level arguments that remain in this report.
In particular no claim is made that Lean has formalized global anchor
rigidity or the full minimum-edit definition.

The final official Lean evidence run used the actual Lean 4.31.0 compiler
and completed with `exit_code=0`, `proof_holes=[]` (14.445 seconds).
Its archived certificate is
`research/certification/lean/certificates/C_LEAN_CORE-adef5a81661033af.json`.
The original source and fidelity document have not been edited since that
successful run. Reproduce it from the campaign root with:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify Main.lean \
  --project-root . --claim C_LEAN_CORE \
  --statement-fidelity research/STATEMENT_FIDELITY.md \
  --artifact-dir research/certification/lean
```

The initial failed compiler run is retained as inconclusive historical
evidence; it is superseded by the successful run on the revised source.
The final standalone Python replay also reproduced the exact certificate.
Neither replay substitutes for independent review of the prose proof.

No false literal manuscript assertion was found in this bounded audit,
so no manuscript `F_` refutation claim is warranted. The deliberately
failed diagonal repair is correctly identified as failed by the manuscript.
Global novelty and independent certification are not self-awarded:
Host-invoked independent Reviewer replay is still required.
