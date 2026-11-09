# A uniform retained-anchor travel theorem

## Result and scope

The three arguments in Proposition `prop:anchor-travel` of the staged
existence manuscript are valid under its stated allocation, geometric,
and posterior interfaces. An explicit consequence is

\[
 T_{\rm anchor}\le
 1400C_0(V+\ell P+\ell Q)
 +\frac{24}{5}\{kr_0+
       288C_0(k+1)(1+\ell)L_H\},\qquad
 \ell=1+\log(k+1).
\tag{1}
\]

Here \(L_H=\sum_jr_j|\Lambda_j^H|\) involves the fixed pools, not the
number of their subsequent uses. The multiplicative constant has no
dependence on height, horizon, input law, or \(k\); \(C_0\) is the
absolute domination constant of the allocation interface.

This is a quantified verification, not a counterexample, a verification
of the entire manuscript, or a claim that the entire argument has been
formalized. The finite tests below are supplementary, not the proof.
No false literal manuscript assertion was identified in this mission.
There is therefore no `F_` refutation claim to file.

The stronger theorem below allows an arbitrary positive affine offset,
fractional comparator weights, and several simultaneous physical movers.
Its novelty and publication significance require independent assessment.
A targeted literature lookup found the staged manuscript and secondary
commentary, but established no independently verified primary source for
this extension. Absence of such a source in that lookup is not a novelty
certificate.

## Sources and unverified upstream assertions

All existence-source paths below are relative to
`research/openai_manuscript/Squared-logarithmic-randomized-k-server-on-arbitrary-metrics-September-24-2026/build/source/latex/sections/`.

* `03_allocation_data.tex`, `thm:allocation`,
  `eq:allocation-constraints`: nonnegative dominated allocations,
  constant root allocation, and subtree feasibility. Only these
  constraints are used here; the movement bound of that theorem is not.
* `07_partitions.tex`, heavy-ball construction,
  `eq:heavy-condition`, `lem:fixed-alphabet`, and the final posterior
  interface: actual fixed prefix maps, geometric cells, cooldown labels,
  intersecting-ball reuse, and conditioning with the old map.
* `08_travel.tex`, `lem:park-variation`, `lem:key-size-refresh`,
  `lem:park-coefficients`, `prop:anchor-travel`: the assertions adjudicated.
  Their constants and accounting order are checked below.
* `09_rounding.tex` consumes anchor travel, and `10_transfer.tex` consumes
  the finite-law estimate. Neither downstream argument is verified here.
  The companion's finite-table, bounded-suffix and delayed-activation
  assertions likewise remain open in the proof graph.

The proof uses elementary finite conditional expectation and elementary
calculus, both explained below. It does not import Bregman's theorem,
the allocation movement bound, the embedding movement bound, or a
competitive-ratio theorem as a proved input.

## General theorem: exact hypotheses

Fix a finite metric \(Y\), a finite horizon, a finite filtered probability
space, and a finite fixed set of labeled members with nonnegative fixed
weights of total \(K>0\). Their locations and successive couplings define
posterior measures \(\mu_t\), of mass \(K\), and expected total physical
movement \(Q\). Several members may move on a step. An ordinary counting
measure with \(k\) members is the special case \(K=k\).

There are finitely many levels, \(r_j=r_0\tau^{-j}\), \(\tau\ge2\), and
adapted maps into a fixed full prefix tree. The expected weighted movement
of the coupled mapped members in the first-disagreement leaf metric is
\(P\). Old-map variables are filtered by the actual conditional
expectation identity at every step. All old allocation, reference, map,
and anchor parameters are measurable at the previous filtration time.

At completed states, \(q_{\rm root}=K\),
\(0\le q_v\le C_0m_v\), \(\sum_{i\text{ child}}q_i\le q_v\), and
\(C_0\ge1\). Here \(m_v\) is the posterior member mass below \(v\).
Define parks \(p_v=q_v-\sum_{i\text{ child}}q_i\), and let \(V\)
be the expected weighted subtree-allocation variation. Every level cell
has diameter at most \(40r_j\), and points of that cell are within
\(20r_j\) of its anchor. Root representation is fixed.

Each level has a fixed finite heavy-label pool. Heavy balls have radii
in \([16r_j,20r_j]\), centers separated by more than \(100r_j\), and
precedence over other cells. For a heavy slot let \(b\) be all parks at
that depth with that last label, and \(M=\mu(C)\) its entire ball mass.
An absent slot has \(M=b=0\). Freshly present slots were absent from the
preceding map. The only anchor change of a retained slot is an
intersecting-ball reuse from \(a\) to \(x\), with \(d(a,x)>8r\).
At each such move, for some \(\gamma<1/100\), \(0\le\delta\le1/100\),
and a fixed \(h>0\),

\[
 H=\mu_t(B(x,\gamma r))\ge h,\quad
 B(x,\gamma r)\subset C\subset B(x,D_Hr),\quad
 \mu_t(B(x,D_Hr))\le(1+\delta)H.
\tag{2}
\]

Successive retained anchor distances are at most \(40r\). These
conditions follow from the specified heavy-update rule in the application;
they are explicit hypotheses of the general theorem, not consequences
of the estimate being proved.

Choose any \(\alpha>0\). Every slot has a persistent reference
\(u\in[\alpha,\alpha+K]\), initially \(\alpha+M_0\), held whenever
\(5u/6\le\alpha+M\le6u/5\), and otherwise refreshed to \(\alpha+M\).
Slots run this tracker even while absent. Put

\[
 \rho=6/5,\quad L=\log(1+K/\alpha),\quad e=1+L,\quad
 D_s=288(\alpha+K)(1+e)L_H.
\]

Then

\[
 \boxed{\quad
 T_{\rm anchor}\le700C_0(1+\alpha/h)
       \{V+e(P+Q)\}
       +\frac{12}{5}(1+\alpha/h)\{Kr_0+C_0D_s\}.
 \quad}
\tag{3}
\]

All quantities are finite. The same proof applies to general finite
probability weights, not just rational ones. Rationality is needed only
by the executable finite examples.

## 1. Parks and height-free coefficient packing

Subtree telescoping gives \(\sum_{w\ge v}p_w=q_v\) and
\(\sum_vp_v=K\). Taking differences, noting the constant root,
gives

\[
 \sum_vr_{|v|}|\Delta p_v|
 \le(1+\tau^{-1})
     \sum_{v\ne{\rm root}}r_{|v|-1}|\Delta q_v|.
\tag{4}
\]

Grouping fixed depth-label coordinates gives
\(b\le C_0M\) and
\(\sum_{j,\lambda}r_j|\Delta b|\le\sum_vr_{|v|}|\Delta p_v|\).
This includes internal and root parks; it uses no leaf-only assumption.
Also \(b/u\le\rho C_0M/(\alpha+M)\le\rho C_0\).

Fix a completed state and \(y\in Y\). Select those levels with a heavy
center within \(7r_j\) of \(y\). Separation makes that center unique.
The selected heavy ball contains \(B(y,r_j)\), whence

\[
 u_j\ge\rho^{-1}\{\alpha+\mu(B(y,r_j))\}.
\tag{5}
\]

For every level \(j\), not just selected ones,

\[
 \sum_{i\ge j,\ i\ {\rm selected}}b_i
       \le C_0\mu(B(y,67r_j)).
\tag{6}
\]

Indeed, a positive depth-\(i\) park has a validity witness in its
subtree, because \(q_v\le C_0m_v\). Its witness is within \(27r_i\)
of \(y\). Group the parks by depth-\(j\) ancestors. Their amount in
each group is at most that ancestor's \(q_v\). Every point with this
prefix is within \(40r_j\) of the group's witness, hence within
\(67r_j\) of \(y\). Distinct prefixes are disjoint, and domination
proves (6).

Set \(A_j=\alpha+\mu(B(y,67r_j))\),
\(B_j=\alpha+\mu(B(y,r_j))\); extend \(B_j=\alpha+K\) for \(j\le0\).
Since \(\tau^7\ge128>67\), \(A_j\le B_{j-7}\). Consequently

\[
 \sum_{j=1}^J\log(A_j/B_j)\le7\log((\alpha+K)/\alpha)=7L.
\tag{7}
\]

Cancellation of the middle terms leaves at most seven positive
endpoint terms; all negative endpoint terms are retained or discarded
in the favorable direction. Each summand is nonnegative.
There are at most \(7L/\log2\le14L\) bad levels \(A_j>2B_j\).
Here \(\log2=\int_1^2 dz/z\ge1/2\).

Partition the other selected levels into bands
\(2^a\alpha\le A_j<2^{a+1}\alpha\).
There are at most \(1+L/\log2\le1+2L\) bands.
Within a band of scale \(R=2^a\alpha\), (5) gives \(u_j\ge R/(2\rho)\),
and (6), applied at its coarsest level, gives total numerator at most
\(2C_0R\). Thus its coefficient sum is at most \(4\rho C_0\).
Combining bad and good levels,

\[
 \sum_{\rm selected}b_j/u_j
 \le\rho C_0\{14L+4(1+2L)\}
 \le27C_0(1+L)=27C_0e.
\tag{8}
\]

No summation of a constant over all levels occurs. The Lean packing
theorem verifies the finite band-mass/denominator argument and its
constant aggregation for arbitrary finite index sets. The geometric
reduction and logarithmic count (5)--(7) are proved here, not encoded
as a claim that Lean checked metric geometry.

## 2. Affine refresh accounting on all filtering steps

For \(s,u\in[\alpha,\alpha+K]\) use the tangent to
\(f(s)=-s\log(s/\alpha)\):

\[
 T_u(s)=u-[1+\log(u/\alpha)]s.
\]

The old slope has absolute value at most \(e\). At refresh the tangent
potential releases

\[
 G(u,s)=s\log(s/u)-s+u
       \ge\frac{(s-u)^2}{2\max(s,u)}
       \ge\frac{s+u}{144}.
\tag{9}
\]

For \(s\ge u\), the gap is
\(\int_u^s(s-z)z^{-1}dz\); for \(s\le u\), it is
\(\int_s^u(z-s)z^{-1}dz\). Replace the denominator by
\(\max(s,u)\) to obtain the first bound.
Outside the holding interval,
\(|s-u|\ge\max(s,u)/6\), yielding the second bound.
These are inequalities, not floating-point evaluations of logarithms.

Hold the old map and reference while filtering old-key counts on
**every** step. The signed tangent change has zero expected value by
the tower identity with its old measurable slope. Then drift to the
new count. A member whose first key disagreement is \(j_0\) changes
at most two heavy-slot indicators per level, and

\[
 \sum_{j\ge j_0}r_j\le r_{j_0-1}/(\tau-1).
\]

Thus the total expected weighted absolute count drift is at most
\(2P/(\tau-1)\le2P\), and tangent input at most \(2eP\).
Every endpoint tangent has absolute value at most
\((\alpha+K)(1+e)\). Telescoping the signed tangent potential over
the fixed pools and using (9) gives

\[
 R:=\mathbb E\sum r_j(u_{\rm old}+u_{\rm new})1_{\rm refresh}
       \le288eP+D_s.
\tag{10}
\]

There is only one pair of endpoint allowances for the whole horizon.
The persistent references are crucial: reuse or absence does not
reinitialize a tracker.

The tempting route "cancel only on refresh/edit events" is false:
equiprobable increments \(-1/2,+1/2\) have mean zero, but their
positive-event-restricted contribution is \(1/4\). The manuscript
explicitly avoids that route; this observation does not refute it.
The Jacobian adapter independently computes the unrestricted mean
in exactly this example.

## 3. Ordered travel potential and retained-anchor payment

Let \(\kappa\) be zero on \((-\infty,4]\), affine with slope \(1/3\)
on \([4,7]\), and one on \([7,\infty)\). Use

\[
 \Phi=\sum_{j,\lambda}r_j(b_{j,\lambda}/u_{j,\lambda})
       \int_{C_{j,\lambda}}\kappa(d(a_{j,\lambda},z)/r_j)\,d\mu(z).
\]

At completed states \(0\le\Phi\le\rho Kr_0\).
Decompose each signed change in the following order.

1. **Filter with every old parameter held:** expected signed change
   is zero on every step, before selecting any event.
2. **Drift locations and memberships, holding old anchors, parks and
   references:** changed keys cost at most \(2\rho C_0P\), by the
   same indicator-geometric sum used above. For an unchanged key, a
   positive ramp increment is at most
   \(d(y,z)(b_{\rm old}/u_{\rm old})/3\), and is zero if
   \(d(a_{\rm old},y)\ge7r_j\).
   Apply (8) pointwise at the old location and old state, even after
   conditioning the coupling on the new history. Sum over all weighted
   physical movers: cost at most \(9C_0eQ\).
3. **Refresh:** the new integral \(I\) satisfies \(0\le I\le M<s\).
   If \(s\ge u\), the change of \(rb_{\rm old}I/u\) is nonpositive.
   If \(s<u\), its positive part is at most \(rb_{\rm old}\le
   \rho C_0ru\). Hence the total is at most \(\rho C_0R\).
   No bound on \(I/u_{\rm old}\) is assumed.
4. **Update parks:** with the new reference, \(I/u_{\rm new}\le\rho\),
   so this costs at most \(\rho\sum r_j|\Delta b|\).
   Fresh anchor initialization costs at most one more such sum, since
   the old park of a freshly present label was zero. By (4) their
   combined budget is at most \(3\rho V\).
5. **Move retained anchors:** (2) gives \(H\le M\le(1+\delta)H\) and
   \(u_{\rm new}\le\rho(\alpha+M)\).
   On the inner ball the old ramp is one and the new ramp zero.
   On the remaining part of \(C\), increases have mass at most
   \(\delta H\). The potential drop is therefore at least

\[
 rb_{\rm new}\frac{(1-\delta)H}{\rho(\alpha+(1+\delta)H)}
 \ge rb_{\rm new}\frac{1-\delta}{\rho(\alpha/h+1+\delta)}
 \ge\frac{rb_{\rm new}}{2(1+\alpha/h)}.
\tag{11}
\]

The last inequality already holds for \(0\le\delta\le1/4\):
\(1-\delta\ge3/4\) and
\(\alpha/h+1+\delta\le(5/4)(1+\alpha/h)\).
The geometric ramp argument still uses \(\gamma<1/100\).
For \(\alpha=h=1\), this pays at least \(rb_{\rm new}/4\),
exactly the uniform payment needed in the manuscript.

Let \(A=1+\alpha/h\). Signed telescoping of the five substeps gives

\[
 \frac{T_{\rm anchor}}{2A}
 \le \rho Kr_0+3\rho V+2\rho C_0P
                  +9C_0eQ+\rho C_0(288eP+D_s).
\tag{12}
\]

Since \(e\ge1\), \(C_0\ge1\), and all costs are nonnegative, the
coefficients after multiplying by \(2A\) are
\((36/5)A\) for \(V\), at most \(696C_0Ae\) for \(P\),
and \(18C_0Ae\) for \(Q\).
Each is bounded by the coefficient in (3). Equation (1) is (3)
at \(\alpha=h=1\).
Actual retained-anchor displacement costs at most \(40T_{\rm anchor}\).

## Executable and formal evidence

Run `python3 research/anchor_travel/verify.py` from the campaign root.
It checks exact rational constant identities and universal nonnegative
polynomial decompositions, finite geometric/capacity cases including
internal parks, persistent-slot refresh examples, and the typed Jacobian
result. These finite cases alone do not prove (3).

`Main.lean` separately proves universally quantified finite packing,
refresh-ratio, retained-drop, telescoping and constant-aggregation
kernels. `statement_fidelity.md` names exactly what it does and does not
formalize. Only a successful real Lean compiler run is evidence of those
declarations. The full finite stochastic-geometric theorem above is a
prose proof requiring independent mathematical review.

The proof graph deliberately leaves both manuscripts' main theorems,
upstream allocation/embedding, rounding, transfer, and computational
claims open. The improvement over the initial untested travel hypothesis
is a complete explicit-constant argument, including the coefficient
summation and two adaptive-payment mechanisms, not a new general-metric
competitive-ratio result.
