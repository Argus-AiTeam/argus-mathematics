# Universal verification of the backward charge

## Result and scope

The chain `join:backward-decomposition` -> `join:later-omissions` ->
`join:capacity` has a universal finite-orbit proof, for both of the manuscript's
mask currencies. Later projection congruences contribute exactly their
reciprocal factors **to the widened, prefix-only linked majorant**. The resulting
transport uses no more than the actual successful plus capacities. It neither
duplicates an ancestor label nor changes a first-sharing epoch.

This is a verification theorem, not a counterexample to the manuscript, not a
finite-search inference, and not a proof of the weak inhomogeneous
Duffin--Schaeffer conjecture. The analytic first-join estimates, summation of
roundoff, sparse-alignment input, and existence/loss bounds for the partitions
are not certified here. In particular, we quantify over histories having the
structural properties stipulated in `tables.tex`; we do not presume the
quantitative conclusions of its three inputs.

`Main.lean` proves the finite-sum core over arbitrary **real** weights and
arbitrary finite index types. Sections below prove its instantiation for the
manuscript's grids and histories. This latter correspondence is a mathematical
proof for independent review, not something the Lean compiler checked by
parsing the LaTeX. `statement_fidelity.md` separates these two responsibilities.
Publication-level significance and novelty remain for independent assessment;
no `verified_new` or Reviewer acceptance is asserted.

All source references below refer to
[`build/sections`](../openai_manuscript/The-weak-inhomogeneous-Duffin-Schaeffer-conjecture-September-25-2026/build/sections).
The audited manuscript is the staged September 25, 2026 version.

## Precise finite transport theorem

Let \(X,Y\) be finite origin-label sets and \(A,B\) finite image-label sets.
Let \(m_{xa},n_{yb}\geq0\) be actual link masses, with
\[
 \sum_xm_{xa}\leq u_a,\qquad \sum_yn_{yb}\leq v_b,
 \qquad u_a,v_b\geq0.
\]
One unmapped static endpoint is permitted: use an identity matrix on that
endpoint, with its retained static weight on the diagonal.

Put \(T=(A\times B)\times(X\times Y)\) and
\[
 W(a,b,x,y)=K(a,b)m_{xa}n_{yb},\qquad K\geq0.
\]
The kernel may contain successful-image indicators, a distance predicate,
carried ordinary factors, and **any nonnegative kernel of preserved future
masks**. In particular, it need not factor into separate endpoint functions.

Let \(C=\prod_{i\in E}C_i\) be a finite product of finite additive groups.
Let \(\chi:T\to C\) record the designated original-grid projection digits.
Suppose, for every \(i\) and \(d\in C_i\), there is a bijection of \(T\) that
adds \(d\) to digit \(i\), preserves all other digits, and preserves \(W\).
No group law on these chosen bijections is required. Then
\[
 \sum_{\chi(t)=0}W(t)=\frac{1}{|C|}\sum_tW(t).
 \tag{1}
\]
For **any** additional predicate \(P\), invariant or not,
\[
 \sum_{\substack{P(t)\\\chi(t)=0}}W(t)
 \leq \frac1{|C|}\sum_{a,b}K(a,b)u_av_b.
 \tag{2}
\]
Thus later survival predicates may be discarded, but may not be silently
included in the equality (1).

Proof: compose the individual digit bijections to obtain, for each \(c\in C\),
a weight-preserving bijection taking the zero fiber to the \(c\)-fiber.
All fibers have the same weight. Summing fibers proves (1), including the
possibility of stabilizers in the underlying translation group. Drop \(P\)
by nonnegativity. In the unrestricted sum, interchange finite summations:
\[
 \sum_tW(t)=
 \sum_{a,b}K(a,b)\Big(\sum_xm_{xa}\Big)\Big(\sum_yn_{yb}\Big).
\]
Apply the column bounds to prove (2).

The Lean declarations `lift_individual_digits`, `digit_average`,
`invariant_fiber_average`, `tupleWeight_sum`, and `projected_transport` prove
these assertions. In contrast with a column-sum argument alone, this theorem
establishes the exact projection factor **before** applying capacity.

For \(C_i=\mathbb Z/q_i\mathbb Z\), \(q_i>0\), the divisor is
\(\prod_iq_i\), by `residue_space_card`. The theorem therefore extends the
structural charge to disjoint-prime-supported prime-power deficits, whenever
the corresponding digit translations exist. It also permits correlated outer
mask kernels. No analytic estimates for these extensions are claimed.

## Instantiation: actual later omissions

Fix a separately stopped joint-loss term at prime \(p\). Group by the ordered
pair of \(p\)-components and the two after-\(p\) mask classes. For an unmapped
static endpoint, fix its centre and row in place of its \(p\)-component.
Also fix the static anchor choices if needed and the carried larger-prime
ordinary factors. This fixes the later-omission products and the current outer
masks. Every image pair belongs to just one such group, so this grouping does
not multiply its eventual capacity. The tuple sets include complete labelled
arrays per unit circle, with zero matrix entries allowed. They do not require
the image labels to survive to the current join.

On the first mapped side write \(d=d_{<p}b_1\) and put
\(V_0=L/d_{<p}\). At the \(p\)-step its minus grid has phase \(b_1a\gamma\).
The current point
\[
 x=\frac{z+a\gamma}{V_0/b_1}
   =\frac{b_1z+b_1a\gamma}{V_0}
\]
is exactly the ancestor whose numerator is \(0\bmod b_1\).
This is an equality of grids, not a probabilistic interpretation of the mask
law. See `tables.tex`, `tab:projected-grid`, the same-location ancestor
paragraph, and `joins.tex`, `join:later-omissions`.

Let \(l\mid b_1\). The definition of a first bad omission, and the fact that
the continuing branch passed all larger primes before splitting at \(p\),
give two essential facts: the original centres have the same \(l\)-exponent
\(\nu_l\), and the partner does not omit \(l\). In particular, omission primes
on the two mapped sides are disjoint. Good adaptive masks have deficit at most
one, so one digit in \(\mathbb Z/l\mathbb Z\) records this condition.
Indeed an adaptive prime lies at or above the row's start, whose
log-log height is at least \(A_0B\). For the retained large bands it exceeds
\(\exp(C_{\rm mask}B)\); a deficit of at least two would already violate
the excess-prime-power condition in `pre:good-masks`.

Translation by \(1/l^{\nu_l}\) is a bijection of the expanded origin grids,
the plus grids and their labels, and any unmapped partner grid. On the first
origin numerator it adds
\[
 \alpha_l=V_0/l^{\nu_l},
\]
a unit modulo \(l\). It adds a multiple of each other designated omission
prime and a multiple of \(p\). An image's pre-success denominator \(L'/d'\)
has the full \(p\)-power and the same full \(l\)-power: it is in the origin's
component at the \(p\)-step and \(d'\) is supported below \(p\).
Consequently this translation preserves its success residue at \(p\).
The same holds for the second linked endpoint or its retained static
forbidden field. For a required digit increment \(d\), take a power of this
translation whose exponent is \(d\alpha_l^{-1}\bmod l\).
The unit \(\alpha_l\) can depend on the origin centre and its below-\(p\)
mask. Make this choice on each invariant block of fixed row tags. Translation
preserves those tags, so the resulting piecewise translation is still a
bijection, with the opposite translation as inverse on that same block.
No single row-independent unit is being assumed before summing origins.
`unit_digit_lift` formalizes the unit-inversion part.

There is an important prime-power point: translation by \(1/l^{\nu_l}\) may
have order \(l^{\nu_l}\), not \(l\). Our proof does **not** assume an action of
the smaller color group, a free orbit of length \(l\), or a homomorphic section
of a quotient. The selected lifts are merely bijections; that is precisely the
hypothesis of `lift_individual_digits`.

Every factor in \(W\) is invariant under these bijections:

1. The pre-\(p\) core contains every later full \(l^{\nu_l}\).
   The component edge threshold forces these later exponents to agree
   along each path, since a discrepancy at \(l\) costs at least
   \(\log l>\beta Y_p\); reductions in the pre-core affect only primes
   already passed. This is the structural tail equality from `tables.tex`,
   not an application of an unproved component-size estimate.
   Therefore the actual earlier prefixes and the entire labelled matching
   matrix transport equivariantly. Cells may be permuted; they need not be
   individually fixed.
2. The image \(p\)-success residues and the static factors through \(p\)
   remain fixed by the divisibilities just proved.
3. Simultaneous translation preserves the widened image distance, widths,
   mask tags, and the now-scalar ordinary factors.
   If several periodic near lifts are counted, their number is a
   nonnegative translation-invariant image kernel; the finite theorem
   allows this multiplicity, not only Boolean kernels.

These are exactly the core requirements in `tables.tex`, its chronology/core
subsection and matching rule, not independence hypotheses about how past
matchings were chosen. Later clipping, survival tests, and partition predicates
have already been dropped by raw-weight monotonicity. The preliminary
common-cell restriction supplies the span bound before it is dropped.

Apply (1) with
\[
 C=\prod_{l\mid b_1b_2}\mathbb Z/l\mathbb Z.
\]
Its cardinality is \(b_1b_2\), because the omission supports are disjoint and
the deficits are squarefree. For a single mapped side set \(b_2=1\).
This proves exactly the assertion of `join:later-omissions` for the stipulated
majorant. It does not assert that actual later surviving weights have
probability \(1/(b_1b_2)\).

## Correlated backward expansion, with no inherited alignment

The residual scaling on a plus row is
\(s_p=R_p^{[\nu_p\geq2]}\). If its before-update raw weight is \(w\), its
matched and unpaired plus portions have total \(s_pw\), and all of that total
is retained precisely on its success. For a fixed after-prime mask \(a\),
the definition \(\pi_L(d)=\phi(L/d)/L\), and the elementary count
\(\phi(p^j)=p^j-p^{j-1}\) for \(j\geq1\), give
\[
 \pi_{p^\nu I'}(a)=R_p\pi_{I'}(a),\qquad
 \pi_{p^\nu I'}(pa)=\frac{s_p}{p}\pi_{I'}(a).
\]
The second formula includes \(\nu=1\), using \(\phi(1)=1\).
These are exactly `tab:mask-transition`. For a matched portion of residual size
\(m\), `tab:mask-transition` gives before masses \(m/p,mR_p\) and after
masses \(mS,m(1-S)\), in units of the after-mask coefficient. The identities
`matched_currency` and `residual_mask_transition` keep this scaling explicit.
The exact deficit-law calculations in `verify.py` additionally check both
\(\nu_p=1\) and \(\nu_p\geq2\). No mask probability is used as a substitute for
a numerator-density argument.

For a full-factor minus point with pre-weight \(w\), put \(M=\sum_\xi m_\xi\).
Its actual complementary retention rule is
\[
 w^+=(w-M)(1-q)+\sum_\xi m_\xi(1-I_\xi)
      =(1-q)w-(D-qM),\quad
 D=\sum_\xi m_\xi I_\xi,\quad q=1/p.
 \tag{3}
\]
This is `raw_minus_update`; row capacity proves its nonnegativity.
On the common pre-core orbit, each \(I_\xi\) has mean \(q\), and each actual
link mass is constant under transported labels. Hence \(\mathbb ED=qM\)
(`linked_success_mean`).

For the second side use \(v,N,E\). Without any independence,
\[
 \mathbb E(w^+v^+)=
 (1-q)^2wv+\mathbb E(DE)-q^2MN
 \leq (1-q)^2wv+\mathbb E(DE).
 \tag{4}
\]
`correlated_covariance` and `correlated_step_bound` prove the unnormalized
finite-sum forms of (4). A static forbidden field has one indicator and
coefficient equal to its retained smaller static weight; a scalar field has
zero centered part. Thus the same formulas cover an adaptive-static term.

Continue **only** the product part of (4), keeping the actual pre-prefix.
Stop the nonnegative \(DE\) part separately. The continued part contains no
indicator conditioning on a larger-prime success, since neither the joint
term nor a conditional expectation is carried into it. Between primes, all
later thinning and clipping multipliers are at most one and can be dropped.
For an omitted current row, retain its successful ancestor subgrid rather
than inserting a new success probability. Mismatch fields may be dropped
with their exact inverse-ordinary-factor restoration; a first bad omission
terminates the continuing calculation.

The static replacement at the end of a range is pointwise after an anchor
average, not an independence assertion about a past adaptive plan. Write the
hard birth weight as the finite average of its fixed-anchor products.
Drop its soft/additional tests. In each product choose one active forbidden
residue at each applicable prime, or its prescribed scalar when there is no
exclusion; deleting the other exclusions only increases the product.
All adaptive multipliers are those computed from the **actual averaged**
tables and remain the same for every auxiliary anchor choice. They can thus
be kept outside this static average until they are read backwards.
At a later projection, the birth numerator is an affine function of the
current numerator with multiplier supported at later primes. At each birth
prime that multiplier is a unit, so the retained exclusion is still one
fixed residue. This directly proves the upper replacement used here from
the birth prescriptions; none of the quantitative first-mass or period
conclusions of `tab:virtual-marginals` is needed. Empty adaptive ranges
make this replacement immediately.

The ordinary-factor restoration in `join:mismatch-restoration` also has a
direct uniform bound under the actual good-mask condition. Set
\(P_0=\rho H\), choose \(d_0<\rho\), and note that
\(P_0>d_0B_i,d_0B_j\). With \(S\) the distinct primes exceeding \(P_0\)
dividing \(UTde\), `prescriptions.tex`, `pre:good-masks`, gives
\[
 \sum_{\substack{p\mid d\\p>P_0}}\frac1p
 \leq(\log2)^{-.3},\qquad
 \sum_{\substack{p\mid e\\p>P_0}}\frac1p
 \leq(\log2)^{-.3}.
\]
Also, since \(p>P_0\) and \(\log p\geq\log2\),
\[
 \sum_{\substack{p\mid UT\\p>P_0}}\frac1p
 \leq\frac{\sum_{p\mid UT}\log p}{P_0\log2}
 \leq\frac{\log(UT)}{\rho H\log2}
 \leq\frac1{\rho\log2}.
\]
For \(p\geq2\), integration of \(1/(1-t)\) from \(0\) to \(1/p\)
gives \(-\log(1-1/p)\leq2/p\). Consequently, for every fixed \(C\geq0\),
\[
 \prod_{p\in S}R_p^{-C}
 \leq\exp\!\left(2C\bigl((\rho\log2)^{-1}
                       +2(\log2)^{-.3}\bigr)\right).
 \tag{7}
\]
This proves the required uniform restoration without a large-prime
independence claim. It is an elementary prose part of the instantiation,
not part of the Lean finite-sum theorem. The recursion in Lean retains
arbitrary nonnegative continuation factors, so it is valid before or after
applying (7).

For a finite trace with local bounds \(Q_i\leq r_iQ_{i+1}+J_i\),
\(r_i\geq0\), the resulting bound is
\[
 Q_0\leq\Big(\prod_i r_i\Big)Q_{\rm terminal}
  +\sum_i\Big(\prod_{j<i}r_j\Big)\operatorname{Charge}_i.
 \tag{5}
\]
Here each \(J_i\) is a projected transport term and
\(J_i\leq\operatorname{Charge}_i\) is **derived** from (2), not assumed in the
definition of a trace. `ChargeData` stores the structural digit-shift and
matrix data. `complete_backward_charge` proves (5);
`chargedTerms_length` and `chargedTerms_nonnegative` establish exactly one
nonnegative separately stopped term per stage. No stopped term is expanded
into a tree of new covariance terms.

## Capacities, masks, and projection multiplicity

The `tables.tex` matching matrix is made separately for each after-\(p\)
mask and width, with columns bounded by residual-scaled plus weights.
Every nonzero link consequently preserves the entire future mask. Its split
at the current join determines both \(b_i\) and the outer mask \(a_i\).
All centres in the matching component have the same prime powers from \(p\)
upward. The carried upper ordinary factors and the later-omission factors
therefore depend only on these preserved data, not on the below-\(p\)
origin row. The original weights of an origin need not equal those of its
image; only the **actual raw link mass** is transported.

`preserved_currency` proves, for any kernel \(k\) of those future masks,
that replacing origin tags by image tags leaves each nonzero link-product
term unchanged. In particular the two permissible kernels are
\[
 k_{\rm broad}(f,g)=\pi_I(a(f))\pi_I(a(g)),\qquad
 k_{\rm clip}(f,g)=\mathbf1_{\{a(f)=a(g)\}}\pi_I(a(f)).
 \tag{6}
\]
They are `broadKernel` and `clippingKernel`. The second is a single
coefficient, not its square. Neither kernel need be normalized for the
capacity argument; the actual deficit law is normalized separately.

For a fixed successful image pair, its coefficient, broadened distance
predicate, and successful indicators can now be put outside the origin
sums. The two column bounds multiply, proving (2) with either (6).
A plus label's arrival on success is exactly its residual-scaled pre-weight:
both matched and unpaired portions survive. Thus the bound really is the
weight of each successful image, not a larger, hypothetical post-weight.
For a static endpoint, use the identity matrix and keep its smaller factors.

There is no hidden sum over possible future masks. An original label records
its centre, its assigned row, and its numerator coordinate
(`tables.tex`, paragraph after `tab:projected-grid`). Its assigned row fixes
its complete original mask. For that fixed row, expanding the displayed grid
identity above gives the numerator \(b_iz\), injectively; conversely a
divisible ancestor numerator has just one descendant numerator \(z\).
Zero/dead labels can be kept without creating a second descendant.
Below-\(p\) origin masks are already separate rows of the single matrix.
`projection_no_multiplicity` proves the corresponding finite-sum bound for
an injective ancestor map. Averaging the congruence removes a condition on
these same matrix rows; it does not recreate a copy of the matrix for every
current row.

## First-sharing epochs

Let \(E_t\) be the component equivalence relation after each chronological
event; extend an inactive centre as an isolated singleton until birth.
These equivalence relations grow. Suppose \(x,y\) first share at \(J\), and
the linked replacements \(a,b\) lie with \(x,y\), respectively, at a time
\(t<J\). At \(J\), transitivity gives \(aE_Jb\). If \(aE_sb\) for \(s<J\),
then at \(\max(s,t)<J\), transitivity would give
\(xE_{\max(s,t)}y\), a contradiction. Hence the image pair first shares
exactly at \(J\).

`first_epoch_preserved` proves this for arbitrary growing equivalence
relations, and `first_epoch_unique` proves that this epoch is unique.
The two \(p\)-step components can be placed at a common chronological time
before the join; operations on distinct components commute for this purpose.
An unmapped newborn is left fixed. A born-at-\(J\) endpoint is never replaced
by an earlier link. Thus old-old and mixed comparisons satisfy precisely
these hypotheses. Nonadjacent newborn-newborn comparisons have empty adaptive
ranges and generate no linked term.

All preimages of a fixed image pair are consequently summed at the same
first-sharing epoch before applying its column capacities. There is still an
intentional sum over stopping primes and the finite choice of mapped sides;
there is no additional comparison-epoch multiplicity.

## What is and is not certified

The scope uses no external literature theorem as an unproved assumption:
the finite reindexing, unit lift, covariance algebra, capacity inequality,
injective projection bound, and chronological argument are proved above and
in Lean. These elementary ingredients themselves are not claimed as new
literature results. The candidate contribution is their source-faithful,
universal composition for this adaptive backward charge, together with the
arbitrary-mask-kernel and digit-space generalization.

The seed campaign ledger contained no mathematical certificate. Relative to
the insufficient column-only route, the improvement is a universal proof of
projection averaging and epoch preservation, including prime-power
translations that do not split into a color-group action. Increasing a finite
search bound would not have established either fact.

`verify.py` uses exact rational arithmetic to replay the deficit transitions,
genuinely correlated raw updates, disjoint later omissions on prime-power
translation periods, both mask currencies, growing component histories, and
backward unrolling. Its finite fixtures are not offered as faithful full
retained-centre counterexamples or as evidence for universal quantifiers.
The universal evidence is the theorem and its instantiation proof.

The one bounded Jacobian call conditions an explicit distribution encoding
two later digits and a common success bit. It returns event mass \(1/35\)
and preserves the success law \(1/3\), exactly. The operation, payload,
protocol, server version, and complete typed output are in the adjacent JSON
files. It is corroboration, not a proof strategy or an independence argument.

No false literal manuscript assertion has been established by this work.
Accordingly there is no invented `F_...` refutation. Independent review must
assess this correspondence, replay the certificate, and decide significance
before campaign completion can be claimed. In particular, the graph must
retain the remaining first-join estimates and the other two quantitative
inputs as unresolved.

## Replay

From the campaign root, the exact replay is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/backward-charge/verify.py
```

The formal replay, recording a real compiler result for `C_BC`, is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/backward-charge/Main.lean --statement-fidelity research/backward-charge/statement_fidelity.md --claim C_BC --project-root .
```

The current official certificate is cited by `exact_certificate.json` and
`research/MATH_STATE.json`; its source and fidelity text are archived with
the compiler answer.
