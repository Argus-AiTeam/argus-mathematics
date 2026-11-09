# Parameter-uniform structural verification

## Result and scope

For every natural number \(c\), the construction in the staged manuscript
has a rational instance \(I\) and a natural number \(B\) with
\[
 |I|=5B,\qquad 1/6<a_i<1,\qquad
 \operatorname{LP}_{\rm ind}(I)=\operatorname{LP}_{\rm type}(I)=B,\qquad
 \operatorname{OPT}(I)>B+c.
\]
The two LPs use their full capacity-feasible configuration spaces. Integral
packings are arbitrary assignments of every physical item to a bin.

This is a verification of existing mathematics, not a new construction or
a claim of novelty. The earlier available result was a source implementation
targeting Lean 4.34.1 without a campaign-local compiler certificate. The
present deliverable localizes the complete 44-file domain proof, not just
its final theorem, to Lean 4.31.0. `STATEMENT_FIDELITY.md` identifies the
objects, statements, necessary compatibility changes, and limitations.
Independent Reviewer approval of that reading is still required.

## The finite combinatorial ingredient

Fix \(d\ge1\). Construct an auxiliary rooted tree in \(2d-1\) phases.
At a phase with \(N\) current leaves, index those leaves by \(i=1,\ldots,N\).
Below leaf \(i\), attach \(2^i\) disjoint spines of length \(i\), half with
red endpoints and half with blue endpoints. The quota at the \(i\)-th new
global depth is \(2^{i-1}\). If \(i<N\), attach
\(1+\sum_{j=i+1}^N2^{j-1}\) disjoint continuation chains of length \(N-i\)
below each spine endpoint. All phase-end leaves are at the same depth.

An unmarked phase-start leaf has an unmarked spine: all quotas in the
first \(i\) new levels sum to \(2^i-1\), less than the number of disjoint
spines. An unmarked endpoint has an unmarked continuation: there is one
more chain than the total remaining quota. Iteration gives an unmarked
complete path for every quota-respecting marking of the auxiliary tree.

Every complete path has one colored endpoint per phase, hence at least
\(d\) red or at least \(d\) blue vertices. Retain all red-rich paths in
one copy and all blue-rich paths in another. No edges are contracted.
These are the two competing trees. Marking all retained vertices of the
designated color gives a separate \(d\)-fold marking within the quotas.
A pair of shared-quota one-hit markings would project to a
quota-respecting one-hit marking of every auxiliary-tree path, a
contradiction. The argument permits marks at arbitrary positive depths,
not merely colored endpoints.

## Parameters, geometry, and scalar encoding

Use the four-vertex clique, \(k=2\), and \(\rho=1/8\). For the prescribed
\(c\), set
\[
 P_0=100^{11},\quad K=25(c+1)(1+5P_0),\quad d=960K,
 \quad P=\sum_\ell p_\ell,\quad R=100(P+4K+1).
\]
The formal definition of \(d\) is the ceiling of
\(\max(72K,120K/\rho)\), which is the same integer here.

Embed the tree roots in \([0,1]\) and \([4,5]\), with depth widths
\(\lambda_\ell=g[100(D_*+1)]^{-\ell}\), where
\(g=1/[16(R+1)^m]\), and set \(\Delta=\lambda_L/10\).
Sibling cells are separated by \(3\lambda_\ell\); descendants remain
inside their ancestor cells. Job baselines and edge offsets are
\[
 b_{e,j}=\tfrac12+g\bigl(j(R+1)^{e-1}-1\bigr),\qquad
 \beta_e=g\bigl((R+1)^{e-1}-1\bigr).
\]
Jobs lie away from the trees. An interval of length at most
\(\lambda_\ell+\Delta\) meets at most one depth-\(\ell\) cell;
one of length at most \(\lambda_1+\Delta\) meets at most one job cell.

The inventory has \(B\) items in each of five roles, and equal labelwise
counts in the row, anchor, and local-auxiliary roles. The ten integer
count equations in `instance.tex` give radix-100 primary scores \(p_i\)
with \(|p_i|<P_0\). Their zero five-item patterns are exactly the four
displayed patterns. Label scores are \(3^v,-2\,3^v,3^v\) in the three
labeled roles. Both scores sum to zero over the entire inventory.
Sizes are
\[
 a_i=\tfrac15+\gamma p_i+\mu q_i+\nu w_i,\quad
 \gamma=(1000P_0)^{-1},\
 \mu=\gamma/(1000\,3^4),\
 \nu=\mu/1000 .
\]
Here \(|w_i|\le6\). These inequalities give \(1/6<a_i<1\).
The lower-scale contributions to a five-item bin are smaller than one
unit at the next scale. Thus a feasible five-item bin has nonpositive
primary score, then nonpositive secondary score when primary is zero.
With both scores zero, capacity is exactly the coordinate inequality.

For a good deadline tuple, the completion is
\(h=b-\Delta\,1_{\rm short}-\ell_U-\ell_D\), and feasibility is
\(h\le z\). Its coverage interval is \([h,b)\).
For a good key tuple, feasibility is
\[
 b_{r'}-b_r+\beta_f-\beta_e+
 \Delta(1_{\rm nonpermit}-1_{\rm short})\le0.                 \tag{1}
\]
If \(r'>r\), the position increase dominates every possible earlier-edge
offset by at least \(g-\Delta>0\). Independently, if \(f>e\), its edge
offset dominates every possible earlier-row displacement by the same
positive margin. Consequently (1) implies both \(r'\le r\) and \(f\le e\).
An exact-position long row must use a current permit or an earlier-edge
resource. Neither order conclusion assumes the other.

## Arbitrary-packing extraction

Suppose that an arbitrary packing has at most \(B+c\) bins. Since it has
\(5B\) items and each bin holds at most five, at most \(25c\) items are in
nonfull bins. Primary-score conservation bounds negative-primary full
bins, giving fewer than \(K\) items outside the four table patterns.

In a table tuple the row and local labels are no larger than the anchor
label. For a label prefix \(S\) and either other labeled role \(r\),
the number of exports from \(S\) to outside anchors is exactly
\[
 E_r(S)=O_A(S)-O_r(S)\le K,
\]
where \(O\) counts items outside table tuples. This uses equality of the
original role inventories. Thus at most \(3K\) anchors at any label
are outside good tuples, jointly over all deadlines and keys.
This is a single prefix loss, not a loss per job.

At a test point \(a\), write \(A\) for the good deadline-tuples' baseline
prefix, \(C\) for their completion prefix, and \(I\) for interval coverage.
Half-open endpoints give the exact identity \(C=A+I\), including ties.
Shifting \(d\) deadlines across a test gives
\(C\ge B_v(a)+d-3K\).
Earlier good keys consume distinct rows in the same earlier prefix, so
\(A\le B_v(a)+3K\). Therefore \(I\ge d-6K\).

Let \(x_v^+,x_v^-\) count good tuples using length-one auxiliaries on
each side. Their total inventories give
\(\sum x_v^+\le dk\), \(\sum x_v^-\le d(n-k)\).
If both counts at a vertex were below \(d-6K\), each leaf test point
would need coverage from a global-zero, positive-local tuple.
Geometry turns these tuples into shared-quota marks in the two competing
trees, hitting every path. This is impossible. Hence each vertex has
\(x_v^+\ge d-6K\) or \(x_v^-\ge d-6K\).

Exclude job cells met by a global-zero, positive-local tuple. There are
at most \(P\) exclusions per label. At a nonexcluded current job, let
\(\xi\) count current good keys using strictly earlier rows and \(u\)
count current short rows used by good deadline tuples. Those \(\xi\)
rows are distinct from the rows consumed by good earlier keys. The
correct strengthened baseline inequality is
\[
 A+\xi\le B_v(a)+3K,\qquad I\le x_v^++u.
\]
Combining it with the completion prefix gives
\(u-\xi\ge d-x_v^+-6K\).
At least \(d-3K\) current keys are good. After displaced matches, at most
\(d-u\) current short rows remain for them. The number \(L\) of
exact-position long matches therefore satisfies
\[
 L\ge u-\xi-3K\ge d-x_v^+-9K.                              \tag{2}
\]
Displacement is permitted and compensates with exactly the required
sign. It is not discarded or assumed small.

For edge \(e\), earlier keys and earlier resources both number
\(2dR(e-1)\). Every good earlier key consumes a distinct earlier resource,
by the independent edge order. The number of resources left after these
matches equals the number of missing earlier keys, at most \(3nK\).
Other uses only decrease what remains. Thus the exact-position long
matches at both current endpoints jointly obey
\[
 \sum_{v,j}L_{v,(e,j)}\le dR+3nK.                          \tag{3}
\]
This does not charge a separate loss for each earlier edge.

If both endpoints had \(x_v^+\le d/8\), then (2), \(d\ge72K\),
and the at least \(R-P\) retained jobs per endpoint would give demand
at least \(2(R-P)3d/4\). Its excess over (3) is exactly
\[
 \frac{97dP}{2}+(50d-3)nK+50d>0 .
\]
Consequently \(C_*=\{v:x_v^+>d/8\}\) is a vertex cover.
The side-choice and global budgets give
\[
 |C_*|\le\frac{dk}{d-6K}+\frac{48Kn}{d}
 \le k+\frac{60Kn}{d}\le k+\rho n.
\]
For \(K_4,k=2,\rho=1/8\), this is at most \(5/2\), while every
vertex cover has at least three vertices. No such packing exists.

## The full fractional optima

At each vertex construct both local states. In each, fund \(d\) root
rows on the chosen side and use a separate \(d\)-fold tree marking on the
other. Give selected-state deadline tuples the long job rows and the
other state the short rows. Their completion prefixes dominate the exact
deadline prefixes, so sorting matches all deadlines feasibly. Unused
positive local auxiliaries can go in remaining slots and only move
completions earlier. Remaining key tuples use short rows and nonpermits
in the selected state, long rows and permits in the other.

Each state uses every labeled physical item at its vertex once. Averaging
the two states at each of the four vertices gives exactly every pooled
stock: \(2d\) length-one items on each side, the prescribed zero-length
stocks, \(dR\) permits and \(dR\) nonpermits per edge, and every flag stock.

A template fixes its three labeled items. If its required global and
flag pools have cardinalities \(U,F>0\), give each of the \(UF\)
physical-copy choices mass \(1/(2UF)\). Roles are disjoint, so the five
copies are distinct. Every generated configuration is feasible. A template
has total mass \(1/2\), contributes \(1/(2U)\) to each global copy, and
\(1/(2F)\) to each flag copy. Adding coincident configurations preserves
these counts. Every physical item receives coverage one and the objective
is \(B\).

Projecting these configurations by numerical size gives a feasible
type solution of the same objective, even if different species have
equal sizes. Conversely every feasible subset or type multiset has
cardinality at most five. Summing any covering solution's demand
inequalities gives \(5B\le5\) times its objective. Both full LP values
are therefore exactly \(B\).

## Exact replay and honest limits

`Main.lean` proves the uniform result and prints transitive axioms of
48 central declarations. The acceptable set is only
`propext`, `Classical.choice`, and `Quot.sound`.
The official `lean_evidence` result must have compiler exit zero,
environment-audit exit zero, and `proof_holes=[]`, and be recorded on
the current formal version of `C118_STRUCTURAL_GAP`.

`verify.py` checks the complete localized closure and the source/fidelity
binding. By default it also repeats the real compiler and environment
audit; submit that long command through the durable runner. Use
`--recorded-lean` to inspect the current official result without repeating
an unchanged compilation. `--compare-upstream` additionally reconstructs
every documented compatibility change from the read-only originals.

The exact finite probes cover all 6,188 five-subclass multisets, tied
endpoints, both independent key orders, positive displacements, earlier
inventory conservation, physical-pool weights, and the edge-demand
polynomial identity. Jacobian supplies a sharp rational primal-dual
certificate for the abstract loss arithmetic. Its earlier, larger request
was rejected by a simplex-basis admission limit and supplies no
mathematical conclusion. None of these bounded experiments substitutes
for the parameter-uniform Lean proof or is a literal packing
counterexample. No false manuscript assertion was identified.

The certificate does not cover the separate PCP/hardness claims or the
polynomial-time construction bound. The formal prefix lemmas use rational
test points, which suffice because all tested coordinates are rational;
the stronger all-real-points intermediate statement is not separately
certified. Source reconstruction, compilation, and this engineer's
mathematical reading do not constitute independent Reviewer acceptance.
