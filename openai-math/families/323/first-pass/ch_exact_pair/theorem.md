# A dimension-free crop lemma and the prescribed-weight estimate

## Result and scope

Under precisely the parameter, block-window and thinning hypotheses in
the staged manuscript's `exact-pairs.tex`, every valid finite expression
in the relevant pure norming set, or in the full mixed norming set,
satisfies

\[
 \sum_{i=1}^{L_J}|f(x_i)|\le {1794\over7}{L_J\over m_J}.
 \tag{1}
\]

Thus the requested coefficient \(2112/7\) is valid. The improvement is
not obtained merely by changing the manuscript's arithmetic: simultaneous
succession in the ordinal and color orders makes **two**, not four,
partially cropped blocks sufficient. This gives six marked indices per
path, uniformly for intersections of any number of coherently ordered
interval crops. The grouped recursion below is valid at arbitrary finite
construction depth and permits arbitrary overlaps between different
weight groups.

This is a full-quantifier theorem **about blocks satisfying the stated
hypotheses**, not a finite search or an unconditional construction of those
blocks. The window-existence argument, in particular Proposition
`path:weak-cauchy`, is not certified here. The last section proves exactly
how (1) supplies Proposition `pair:exact` once that separate prerequisite
is discharged. Neither the full CH counterexample nor the independence
theorem is claimed proved. Independent review, including significance and
novelty assessment, remains the Host's responsibility.

The strongest prior result being compared is the staged manuscript's
\(2112/7\) estimate, obtained with eight marks and uniform recursive
budget 64. Here the number of marks is six and the uniform budget is
\(130/7\); the final coefficient is \(1794/7\).

## Definitions and exact hypotheses

Fix one manuscript family. Put \(r=s'\), \(1<q<r\), and
\(\theta_j=L_j^{1/r}/m_j\). The positive integers \(L_j,m_j\) are
strictly increasing. Write

\[
 c=\sum_{j\ge1}\theta_j<1/8,\quad
 B=2\sum_{j<J}L_j,\quad L=L_J,\quad d=d_J.
\]

The parameter hypotheses used here are

\[
 \sum_{j\ge J}\theta_j\le4\theta_J,\quad
 8^{-d}\le\theta_J,\quad
 (1+B)^d(1+B+L^{1/q'})\le L/m_J.
 \tag{2}
\]

All block vectors are finite, nonzero and successive in the ordinal
order. In the mixed case they are successive in color order as well;
in the pure case they lie on the family's fixed color. The data are
\(x_1,\ldots,x_L\), windows \([J_i,T_i]\), and thresholds with

\[
 \|x_i\|\le2,\quad J_i>J,\quad J_{i+1}>T_i,\quad
 \sum_{b=1}^{h}\|P_{I_b}x_i\|\le A h^{1/r}
 \ (h\le L_{J_i}),\qquad A=16,
 \tag{3}
\]

for every successive disjoint ordinal interval family, and

\[
 \|x_i\|_1\sum_{j>T_i}m_j^{-1}\le\epsilon,\quad
 \epsilon L^{1/r}\le\theta_J,\quad
 T_e\delta_{e+1}\le\epsilon 2^{-e}.
 \tag{4}
\]

For each \(e<L\), every **original uncropped** finite path has at most
three indices \(i>e\) for which
\[
 \left|\sum_{\ell:J_i\le j_\ell\le T_i}\phi_\ell(x_i)\right|
   >\delta_{e+1}. \tag{5}
\]
The window coherence condition is needed to obtain (5), not to apply
the estimate once (5) holds. Likewise weak nullity and the lower norm
bound \(1\) are needed upstream or in the final normer selection, not
in the estimate itself. No stronger version of (5), and no condition
about cropped-path coding, is assumed.

The relevant expressions are exactly those of `norming.tex`.
A nonterminal expression is either Type I, viewed as a one-piece path
with coefficient 1, or Type II, a finite combination of **crops of
original valid paths** with rational coefficients \(a_b\) and
\(\sum_b|a_b|^q\le1\). The active weights across those cropped paths
are pairwise distinct. A weight-\(j\) group has coefficient
\(|a_b|/m_j\) and at most \(L_j\) nonzero cropped children, successive
in the required order, from earlier construction stages. Cropping
does not recode a path. Empty cropped pieces are discarded.

In the pure case the terminals are coordinates. In the mixed case
the terminals are arbitrary pure norming functionals. Every such
terminal has norm at most one; it meets at most one mixed block
because it is supported on one color. Interval and rectangle
projections are contractive. These elementary norm/crop properties
also follow directly from the actual rules: distribute crops through
Type I children, intersect the existing crops in Type II, and induct
on construction stage. Coordinate coefficients stay at most one:
within a Type I group a coordinate meets one child, and across paths
the active weights are distinct, giving total coefficient at most
\(\sum_j1/m_j<1\). This last parameter hypothesis is used only for
these norm/coefficient facts and (4).

Here is also the pure/full norm comparison needed in Section 7.
Induct on mixed construction stage to show that the restriction to
\(C_k\) of each mixed functional lies in the absolutely convex hull of
\(K_k\). This holds for pure terminals. A mixed Type I node has at
most one child meeting this color. In Type II, each path has at most
one piece meeting it, and that piece at most one child, by strict
color succession. The total restriction coefficient mass is at most
\(\sum_j1/m_j<1\), since the active weights are distinct. The induction
therefore closes. Since \(K_k\subset K\), both norm inequalities follow.

## 1. Two partial blocks for any coherent product crop

Let \(S_i\) be finite supports successive in every one of an arbitrary
collection of linear orders. Let \(R\) be the intersection of one
convex interval in each order. If \(R\) meets \(S_a\) and \(S_c\),
where \(a<b<c\), then \(S_b\subset R\).

Indeed choose \(u\in S_a\cap R\), \(v\in S_c\cap R\), and \(z\in S_b\).
In every order, \(u<z<v\). Convexity of that order's crop puts \(z\)
in it. This holds for every order and every \(z\), proving the claim.
Consequently, among any finite set of blocks met by \(R\), only its
first and last can be partially, rather than wholly, contained in \(R\).
There are at most two partial blocks, independently of the number of
orders. The conclusion persists on an arbitrary subset of block indices.

This applies to ordinal interval crops and to the manuscript's rectangles,
since mixed blocks have simultaneous succession in the same index order
for both attributes. It does **not** apply to block orders that disagree;
no such generality is used or claimed.

The order-convexity assertion and finite endpoint count are formalized
in `ExactPair.product_crop_between` and `ExactPair.at_most_two_partial`;
`ExactPair.product_crop_partial_bound` formally composes them for an
arbitrary finite assigned index set.

## 2. Local decomposition with arbitrary assigned subsets

Assign to a node any \(I\subset\{1,\ldots,L\}\) and put
\(v_i=|f(x_i)|1_I(i)\). Every charge and continuation below is zero
outside \(I\). Repeated use of the triangle inequality bounds \(v\)
coordinatewise by the charges plus continued child vectors. We never
assume unconditionality of the Banach-space norm.

**Above the window.** At column \(i\), a weight \(j>T_i\) contributes
at most \(\|x_i\|_1/m_j\). The path coefficient is at most 1, each
coordinate meets at most one child in this group, and each active
weight occurs once. Summing (4) gives an \(\ell_r\) charge at most
\(\epsilon L^{1/r}\).

**Inside the window.** Let \(t_{bi}\) be path \(b\)'s cropped
\([J_i,T_i]\)-evaluation. For each fixed \(i\), these pieces are legal
further crops of the **original** paths. A weight interval selects a
consecutive segment of their successive pieces; an ordinal cut selects
that segment without changing any history. Intersect with the original
interval or rectangle crop. The resulting active weight sets remain
disjoint. Type II and rational approximation therefore give
\[
 \|(t_{bi})_b\|_{q'}\le\|x_i\|\le2. \tag{6}
\]
Here rational approximation is legitimate even for nonrational \(q\):
rational points of the closed \(\ell_q\) unit ball are dense, by
approximating points in its interior and scaling towards that interior.

For each path with a nonzero assigned column, let \(e\in I\) be its
first such column. Mark \(e\), every later nonzero assigned column
whose block is only partly contained in the crop, and every later
uncropped hit at threshold \(\delta_{e+1}\). If \(e=L\), the last
instruction is empty. Section 1 gives at most two partial columns
and (5) at most three hits after \(e\). Hence there are at most **six**
marks, including the first column.

At any unmarked nonzero column the whole block is in the crop.
Its cropped evaluation equals the uncropped window evaluation and
has magnitude at most \(\delta_{e+1}\). At most \(T_e\) paths have
earliest column \(e\): choose one nonzero active weight in
\([J_e,T_e]\) from each; these choices are distinct. Their
coefficients have magnitude at most 1. Thus the unmarked charge at
column \(i\) is at most
\[
 \sum_{e<i}T_e\delta_{e+1}\le\epsilon.
\]
Its \(\ell_r\) norm is at most \(\epsilon L^{1/r}\). This argument
counts only nonzero window evaluations and so also allows cancellation
within a path.

For the marked charge \(M_i\), (6) and finite-dimensional duality give
\[
 M_i\le2\Big(\sum_{b:i\ {\rm marked}}|a_b|^q\Big)^{1/q}.
\]
Summing the \(q\)th powers and using six marks per path gives
\[
 \|M\|_r\le\|M\|_q\le2\,6^{1/q}\le12,\qquad
 \|M\|_1\le12L^{1/q'}. \tag{7}
\]
Only \(q<r\) is used for the norm comparison.

**Below the window.** In a group \(j<J_i\), let \(d_{ji}\) count
its child ordinal ranges meeting \(\operatorname{supp}x_i\).
The ranges are successive, even after rectangle cropping.
If \(d_{ji}=0\) the evaluation is zero. Otherwise the child norm bounds,
contractive projections and (3), applicable since
\(d_{ji}\le L_j\le L_{J_i}\), give the charge
\[
 {A\over m_j}d_{ji}^{1/r}. \tag{8}
\]
If \(d_{ji}=1\), instead continue to the unique child with coefficient
\(|a_b|/m_j\). Each child receives the subset of \(I\) for which it
is the unique meeting child. These assigned sets are disjoint
**within that group** and contained in \(I\).

For the stopped cases \(d_{ji}\ge2\),
\[
 \sum_{i:d_{ji}\ge2}d_{ji}\le2L_j. \tag{9}
\]
To see this, list the successive child intervals. If a child interval
meets a block which also meets an earlier child, that block is the
first possible block meeting this child interval. Otherwise a still
earlier block meeting this child and the earlier child's coordinate
in the later block would violate succession. Thus there is at most
one such block. Similarly at most one block meeting this child can
also meet a later child. Every incidence counted on the left has
one of these properties, proving (9). Gaps in finite supports do not
affect the order argument.

It follows from (8)--(9) that a stopped group's \(\ell_r\) charge is
at most \(2A\theta_j\). In (8) the unused path coefficient was bounded
by 1, so it remains a valid bound for Type II.

## 3. The overlap-tolerant substitution principle

For one group let \(w_h\) be arbitrary vectors, supported on its
disjoint child assignments, with \(\|w_h\|_r\le K\). The **exact**
disjoint-support identity gives
\[
 \left\|\sum_h w_h\right\|_r^r=\sum_h\|w_h\|_r^r.
\]
Consequently its weighted recombination has norm at most
\(K L_j^{1/r}/m_j=K\theta_j\). The triangle inequality, not any
cross-group disjointness, gives
\[
 \left\|\sum_j {|a_{b(j)}|\over m_j}\sum_h w_{jh}\right\|_r
 \le K\sum_j\theta_j\le cK. \tag{10}
\]
There is one group per active weight; missing groups may be padded by
zero vectors. Each result stays supported on its parent assignment.
This proves (10) equally for original evaluation vectors, substituted
small charges, and residual vectors. It is the point at which losing
the assignment-support invariant would invalidate the proof.

For completeness, disjoint power addition follows coordinate by
coordinate because at most one summand is nonzero. Taking the \(r\)th
root, then using the triangle inequality across groups, proves (10).
These statements for **all finite real dimensions and all finite
exponents at least one**, together with support preservation, are
kernel-checked in `ExactPair.disjoint_sum_norm`, `grouped_bound`,
`assignments_give_disjointness`, and `supported_recombine`. No bound
on group count, dimension, or inter-group overlap is imposed there.

## 4. A uniform bound at every construction stage

Every terminal evaluation vector has \(\ell_r\) norm at most 2.
Assume the same assertion with bound \(K\) for earlier-stage children,
with **every** possible assigned subset. Sections 2--3 bound the
current vector by
\[
 12+2\epsilon L^{1/r}+2Ac+cK
 \le12+34c+cK.
\]
The choice \(K=130/7\) closes this induction, since
\[
 12+{34\over8}+{1\over8}{130\over7}={130\over7}.
 \tag{11}
\]
It exceeds the terminal bound. Every actual expression has finite
construction stage and all children in either operation belong to
earlier stages, so induction proves the uniform bound for all of
them. The stage is arbitrary; no maximum construction depth is assumed.

## 5. Cutting only the low-weight singleton edges

Now continue only singleton cases of weights \(j<J\), stopping after
\(d\) such continuation edges. Boundary cases with \(j<J\) remain
large \(\ell_1\) charges. Low-window groups with \(j\ge J\) are stopped
entirely, including their singleton cases. For such a group, (9)
and at most \(L\) singleton block incidences give total incidence
\[
 2L_j+L\le3L_j.
\]
Thus its entire \(\ell_r\) charge is at most \(3A\theta_j\).
Together with the above-window and unmarked charges, the small
charge at a node is at most
\[
 \sigma=3A\sum_{j\ge J}\theta_j+2\epsilon L^{1/r}
 \le194\theta_J. \tag{12}
\]
Terminal nodes have zero small charge.

Define the worst small-plus-residual budget recursively by
\[
 S_0=130/7,\qquad S_{h+1}=194\theta_J+cS_h.
\]
Equation (10) and the support invariant justify substitution at
every node, even when assigned subsets overlap across weights.
Terminating branches contribute zero small charge and residual,
so they cannot increase this budget. By induction on the cutoff,
\[
 S_d\le {194\over1-c}\theta_J+c^d{130\over7}.
\]
Since \(c^d\le8^{-d}\le\theta_J\), (2) gives
\[
 S_d\le {1552+130\over7}\theta_J
       ={1682\over7}\theta_J. \tag{13}
\]
This induction, for every natural \(d\), is the geometric recurrence
formalized by `ExactPair.smallBudget_le` and
`ExactPair.manuscript_small_budget`. It is independent of the original
construction stage.

The residual means the **whole** assigned evaluation vector at depth
\(d\), bounded by Section 4, not merely a coefficient or a coordinate.
Finite-dimensional Holder converts (13) to the root \(\ell_1\) bound
\[
 L^{1-1/r}S_d\le{1682\over7}{L\over m_J}. \tag{14}
\]

## 6. The other charges and their population

At each node the remaining \(\ell_1\) charges consist of a possible
terminal, the marked contribution, and boundary cases with \(j<J\).
By (7)--(9), \(d_{ji}^{1/r}\le d_{ji}\), \(m_j\ge1\), and the
distinctness of the weights, their sum is at most
\[
 2+12L^{1/q'}+AB\le16(1+B+L^{1/q'}). \tag{15}
\]
A terminal contributes only its terminal charge, so writing all three
upper bounds at once is harmless.

There are at most \(b=\sum_{j<J}L_j=B/2\) continued children per
node. If \(N_h\) is the population above depth \(h\) of the complete
\(b\)-ary tree, then \(N_0=0\) and \(N_{h+1}=1+bN_h\). Induction gives
\(N_h\le(1+b)^h\le(1+B)^h\): in the induction step use
\((1+b)^h\ge1\). This also covers \(J=1\), \(B=b=0\), where there is
at most the root. The population majorant is formalized in
`ExactPair.chargeNodes_le`.

Every propagated edge coefficient has magnitude at most one.
Therefore (15), the population bound, and (2) bound all these root
\(\ell_1\) charges by \(16L/m_J\). Adding (14) proves (1), since
\(1682/7+16=1794/7<2112/7<500\).

All inductions are finite but universally quantified. The only required
analytic inequalities are the triangle inequality, finite Holder, and
monotonicity of finite-dimensional \(\ell_p\) norms. In the formal core,
the norm is Mathlib's actual finite `PiLp` norm, not an assumed version
of the desired estimate.

## 7. Exact connection to Proposition `pair:exact`

Assume now the manuscript's separate existence argument supplies
the above \(L_J\) blocks in any prescribed tail, additionally with
\(\|x_i\|\ge1\). Put
\[
 y={m_J\over L_J}\sum_{i=1}^{L_J}x_i .
\]
Taking the supremum of (1) over the relevant norming set gives
\(\|y\|\le1794/7<500\). The pure/full norm equality is used in
the pure case; the mixed case uses the full set \(K\), including
its pure terminals.

For each block choose a same-family normer with positive evaluation
at least \(1/2\), possible by symmetry, the norming property and
\(\|x_i\|\ge1\). Crop to the ordinal block range and, in mixed mode,
to its color range. These are allowed crops and do not change its
evaluation on \(x_i\). Their supports are nonzero and successive in
the family's required order. They are finitely many earlier-stage
functionals, so their Type I operation at weight \(J\) is legitimate
after taking the maximum of their finite stages:
\[
 \phi={1\over m_J}\sum_{i=1}^{L_J}g_i,\qquad
 \phi(y)={1\over L_J}\sum_i g_i(x_i)\ge1/2 .
\]
All cross evaluations vanish by successive disjoint supports. The
support of \(\phi\) lies in the ordinal range of \(y\), and in its
color range when mixed. Thus the estimate gives the precise
conclusion of `pair:exact`, conditional only on the explicitly
unresolved block-window existence prerequisite.

## Evidence boundary

`lean/Main.lean` proves the universal norm, support, crop, recurrence,
counting and rational-constant **core lemmas** named above. It does
not encode the manuscript's entire norming grammar or certify its
upstream analytic prerequisites. `verify.py` replays that compiler
evidence, the exact Jacobian primal/dual certificate, the source-rule
bindings, and finite regression checks of crop and assignment geometry.
Those finite checks are not substituted for the proofs in Sections 1--6.

The local estimate proof does not invoke either comparative exact-pair
paper mentioned before the manuscript's proof. No proposition from
those papers is needed or assumed here. The project Wiki contained no
entry for this manuscript or this estimate when scoped. Novelty beyond
the explicit improvement and the dimension-free generalization is not
asserted without independent literature review.

To replay the certificate from the campaign root, run
`$WORKSPACE/argus-live-update/.venv/bin/python research/ch_exact_pair/verify.py`.
The default performs a fresh official Lean run for `C_CH_KERNEL` and
both campaign-local ledger/graph checks. `--regressions-only` deliberately
skips the compiler and is not a certification replay.
