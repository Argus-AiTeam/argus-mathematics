# One-step Cauchy mode splitting

## Statement and scope

The following is a universal theorem, not an inference from the finite replay.
It verifies equations `eq:tensor-mode-expansion` and
`eq:tensor-recursion-identity` and the child edge/degree assertions in
`quantitative-contraction.tex`, under the manuscript's actual packet
conventions. It does not certify packet construction, the full recursion's
running time, entry-evaluation complexity, the reduction from counting, or
novelty. The previously accepted Hermite theorem is neither changed nor used
in the proof of this one-step identity.

Let \(a\geq1\), \(L=2^a\), \(S=\{-L,\ldots,L-1\}\),
\(\alpha=2^{a+1}\), and
\[
 C(T)=\prod_{q\in S}(T-q),\qquad
 W_{xy}(T)=\frac{C(T)}{C'(0)(T-y+x)}.
\]
The last expression denotes the polynomial obtained by cancellation, including
at a root of its displayed denominator. Let
\(\mathcal O=\mathbb Z_{(2)}[U]/(f)\), with \(f\) monic of positive degree
and irreducible modulo two, and
\(\mathcal A=\mathcal O[V]/(V^\ell)\), \(\ell\geq1\).
In fact, the argument below needs only monicity of \(f\).

Fix \(p\geq1\), \(t\in S\setminus\{0\}\) with \(i=v_2(t)<a\),
\(\zeta\in\mathcal O\), and \(T=t+\alpha\zeta\).
Partition the edges of an arbitrary finite Boolean bipartite multigraph into
packets with injective occupied slots in \(\{0,\ldots,L-1\}\).
An edge has the same occupied slot at both ends; a vacant slot has no port.
In each coordinate the packet has a fixed unordered pair of endpoint
symbols. If this pair is unequal, its orientation is specified by that
coordinate's slot bit, using one convention throughout the packet. Group
vertices by their symbol in coordinate \(i\). Lift tensor entries once,
entrywise, as in the manuscript; throughout this theorem these fixed entries
are arbitrary elements of \(\mathcal A\).

For each packet with unequal symbols at coordinate \(i\), each tile
\(y=y_0+2^{i+1}j\), \(0\leq y_0<2^{i+1}\), and each
\(b\geq0\) with \(b+1<p\), introduce precisely the manuscript's mode
\[
 Z=(\text{packet},y_0,b),\quad w_Z=b+1,\quad
 L_Z(X)=\sum_{\text{occupied columns in the tile}}j^bX_y.
\]
Its source is the tile's column group and its target is the other symbol
in the packet's pair. Empty tiles are included and \(0^0=1\).

Then the manuscript's packet tensors and child networks, with these modes
and with \(\sum_Zw_Z\beta_Z<p\), satisfy
\[
 F(t+\alpha\zeta)=
 \sum_{\beta:\,\sum_Zw_Z\beta_Z<p}\prod_{g=1}^r Z_{g,\beta}
 \quad\text{in }\mathcal A/(2^p).
 \tag{1}
\]
If the supplied packet embedding has at most \(3M/L\) packets and at most
\(3M/r\) real ports of either side in any group, there are at most
\(6M/D\) modes of each weight, \(D=L/2^i\), and each child has at most
\(6M/r\) edges and maximum degree at most \(\max(\Delta,2L)\).
For \(r=64\), \(M>0\), and \(2L\leq\Delta\), this gives strictly fewer
than \(M/8\) edges and maximum degree at most \(\Delta\).

## 1. Integral normalization at the actual grid

Put \(d=v_2(C'(0))\) and \(c=C'(0)/2^d\), an odd, possibly negative,
integer. For every \(t\in S\) and \(0\leq k\leq a\),
\[
 \#\{q\in S\setminus\{t\}:v_2(t-q)=k\}=2^{a-k}.
 \tag{2}
\]
Indeed, \(S\) is a complete residue system modulo \(2^{a+1}\); the
specified difference classes are exactly the \(2^{a-k}\) classes divisible
by \(2^k\) but not \(2^{k+1}\). No nonzero difference has valuation
greater than \(a\). Thus
\[
 v_2(C'(t))=\sum_{k=0}^a k2^{a-k}=d.
\]
For \(q\ne t\), write \(k_q=v_2(t-q)\) and
\[
 h_q(\zeta)=\frac{t-q}{2^{k_q}}+
                  2^{a+1-k_q}\zeta\in\mathcal O.
\]
Each \(h_q\) reduces to 1 modulo two. Hence, with no division by
\(\zeta\) and also when \(\zeta=0\),
\[
 \frac{C(T)}{C'(0)}=2^{a+1}n,\qquad
 n=\zeta c^{-1}\prod_{q\ne t}h_q(\zeta)\in\mathcal O.
 \tag{3}
\]

Here and below the unit assertion does not hide a field assumption:
for any finite free monic quotient \(\mathcal O\), multiplication by an
element congruent to 1 modulo two has an integral matrix congruent to the
identity modulo two. Its determinant is an odd element of
\(\mathbb Z_{(2)}\); the adjugate formula constructs its inverse in
\(\mathcal O\). An odd scalar is inverted in the same way, or directly.
Thus irreducibility is not needed for this part. We can use
\(\mathbb Q[U]/(f)\) as an ambient rational algebra without assuming it
is a field.

For completeness this also proves integrality of every *local* entry, where
one must not invert a potentially zero denominator. Write \(d_0=y-x\in S\).
If \(d_0=t\), cancellation gives
\[
 W_{xy}(T)=c^{-1}\prod_{q\ne t}h_q(\zeta).
\]
If \(d_0\ne t\), it gives
\[
 W_{xy}(T)=
 2^{a+1-k_{d_0}}\zeta c^{-1}
                       \prod_{q\ne t,d_0}h_q(\zeta).
 \tag{4}
\]
These formulas are in \(\mathcal O\), including at all polynomial
evaluation roots. They agree with the manuscript's polynomial kernel.
They extend coefficientwise to \(\mathcal A\) and to its quotient
modulo \(2^p\). There is no division by two in that quotient.

## 2. Orientation and the crossing expansion

Since \(t\equiv2^i\pmod{2^{i+1}}\), adding \(t\) flips bit \(i\),
also for negative \(t\). At \(T=t\) the only potentially nonzero entries
have \(y=x+t\). If a packet's pair is unequal, the row and column
orientations are opposite, so those entries join equal *symbols* and
are local. Equal-symbol packets are entirely local. This verifies the
orientation used in the text, rather than reversing source and target.

In an unequal-symbol packet, crossing from \(x\) to a tile means that
bit \(i\) of \(x\) equals bit \(i\) of \(y_0\). Therefore
\[
 A_0=t-y_0+x\ne0,\qquad
 \delta=v_2(A_0)\leq i.                                  \tag{5}
\]
Otherwise \(y_0\equiv x+2^i\pmod{2^{i+1}}\), which has the opposite
bit. Put \(h=2^{i+1}\) and
\[
 v=\frac{A_0}{2^\delta}+2^{a+1-\delta}\zeta,\quad
 q=2^{i+1-\delta}v^{-1},\quad
 A=2^{a+1-\delta}nv^{-1}.
 \tag{6}
\]
Both \(v\) and \(1-qj\) are units: they reduce to 1 modulo two.
The denominator \(T-y_0+x\) is exactly \(2^\delta v\), not an
unexamined formal inverse. For every occupied \(y=y_0+hj\),
the canceled kernel consequently has the exact identity
\[
 W_{xy}(T)=A(1-qj)^{-1}
 \quad\text{in }\mathcal O.                              \tag{7}
\]
One way to check (7), without rational cancellation assumptions on the
coefficient ring, is to multiply it by the units \(v\) and \(1-qj\)
and use (3) and (4); multiplication by the nonzero integer
\(2^\delta\) is injective in the finite free \(\mathbb Z_{(2)}\)-module.
This covers the manuscript's actual Cauchy specialization.

For \(N=p-1\), the finite geometric identity in any commutative ring is
\[
 A(1-qj)^{-1}
 =A\sum_{b=0}^{N-1}(qj)^b+
                  A(qj)^N(1-qj)^{-1}.                    \tag{8}
\]
The coefficient of \(j^b\) is
\[
 c_{x,y_0,b}=Aq^b
 =2^{\,a+1-\delta+b(i+1-\delta)}n v^{-(b+1)}.
 \tag{9}
\]
It is divisible by \(2^{b+1}\), since \(\delta\leq i<a\).
The remainder in (8) is divisible by
\(2^{a+1-\delta+N(i+1-\delta)}\), hence by \(2^p\).
For \(p=1\), \(N=0\), the sum is empty and the same conclusion
follows from \(2\mid A\). Thus (8) is exactly the expansion in the
manuscript, with precisely its strict inequality \(b+1<p\).
Its sign is positive, since the denominator is
\((T-y_0+x)-hj\).

Equations (3), (5), (6), and (9) supply the integral factors of
every mode coefficient explicitly. Nothing here assumes the desired
Cauchy expansion or substitutes a generic low-rank kernel for it.

## 3. Weighted truncation

Fix the independent real-port bits \(X,Y\). In each row, replace the
crossing part by \(\sum_Z c_{x,Z}Z\), keeping the actual local part
unchanged. The affine factors \(l_0(z)=1-z\) and \(l_1(z)=z\)
introduce only the signs \(-1\) and \(+1\) on mode coefficients.
Since each \(c_{x,Z}\) is \(2^{w_Z}\) times an element of
\(\mathcal O\), every coefficient of exponent vector \(\beta\)
in their product is a multiple of \(2^{\sum_Zw_Z\beta_Z}\).
To see this directly, each distributive term selecting exponent
\(\beta\) contains \(\beta_Z\) copies of the factor \(2^{w_Z}\);
their product is \(2^{\sum_Zw_Z\beta_Z}\). Summing those terms
does not remove divisibility. This argument uses no domain,
noncancellation, or positivity assumption.

After substituting \(Z=L_Z(X)\), terms of weight at least \(p\)
vanish in \(\mathcal A/(2^p)\). The linear forms \(L_Z\) have
integer coefficients, so substitution cannot spend precision.
The same holds after multiplication by the fixed tensor entries
and after summing bits. In particular, nilpotents in \(V\),
zero coefficients, and cancellations cause no exception.

## 4. Packet/group extraction and independent bit sums

Let \(R_{k,g}\) be the product of the row factors in packet \(k\)
with row symbol \(g\), using local column bits and formal modes.
Its coefficients depend only on \(Y\)-bits of those rows and
local \(X\)-bits of group \(g\) in that packet. Its formal
variables are exactly the modes with target \((k,g)\).
These target-variable sets are disjoint and partition the mode set,
including modes that never appear because there is no target row.
Therefore
\[
 [Z^\beta]\prod_{k,g}R_{k,g}
   =\prod_{k,g}[Z^{\beta|_{\mathrm{target}(k,g)}}]R_{k,g}.
 \tag{10}
\]
This follows by the coefficient formula for a product in disjoint
indeterminates: the only possible distribution of the prescribed
exponents between factors is their restriction to each variable set.
In particular there is no multinomial coefficient or factorial.

After substituting the source forms, regroup (10) as
\[
 \prod_g\prod_k\left(
 [Z^{\beta|_{\mathrm{target}(k,g)}}]R_{k,g}\,
 \prod_{\substack{Z\text{ in }k\\\mathrm{source}(Z)=g}}
                                    L_Z(X)^{\beta_Z}\right).
 \tag{11}
\]
The parenthesized expression is exactly the specified packet tensor
for child \((g,\beta)\). Its arguments are exactly that packet's
real row and column ports with symbol \(g\). If no target rows exist,
the coefficient of a positive target exponent is zero. If a source
tile is empty, the source form is zero and its zeroth power is one.
If a packet contributes no ports to this child, its tensor is a
scalar; scalar isolated vertices are allowed by the stated network
definition.

Write \(H_g\) for the product of all *old* vertex tensors of group
\(g\), on both sides. A vertex has one label, so no tensor in \(H_g\)
depends on another group's bits. This includes old isolated vertices.
The sets of row and column port bits partition by their endpoint
groups, and are independent: the deformation has not identified
\(X\) with \(Y\). Finite distributivity gives
\[
 \sum_{X,Y}\prod_g
       \left(H_g\prod_k T_{k,g,\beta}\right)
 =\prod_g\sum_{X_g,Y_g}
       H_g\prod_k T_{k,g,\beta}
 =\prod_g Z_{g,\beta}.                                  \tag{12}
\]
The last equality is the definition of child contraction. Each
retained old port becomes one edge to its packet vertex, with that
port bit as the child's edge variable. Distinct parallel edges keep
distinct ports. Equations (7)--(12), followed by the finite sum over
weight \(<p\), prove (1).

All calculations use the fixed lifts chosen at the beginning of
this call. Reducing the resulting packet entries modulo \(2^p\) and
canonically lifting them for a later call does not change (1).
No assertion that canonical lifting preserves addition is needed.

## 5. Size and multiplicity

There are \(2^{i+1}\) tiles per unequal-symbol packet. Thus, for
each weight, the number of modes is at most
\[
 K2^{i+1}\leq (3M/L)2^{i+1}=6M/D.
 \tag{13}
\]
Tiles with no real columns and modes with no target rows can only
increase this upper bound, not invalidate the identity.

For a fixed group let \(R_g,C_g\) be its real row and column port
counts. The child has *one edge per retained port*, so its edge
count is \(E_g=R_g+C_g\), not the number of original edges whose
two endpoints have symbol \(g\). The packet load assumptions give
\[
 E_g\leq6M/r.
 \tag{14}
\]
At \(r=64\) and \(M>0\), this is \(3M/32<M/8\).
Every old vertex retains its degree. A packet vertex has at most
\(L\) row ports plus \(L\) column ports, so its degree is at most
\(2L\). The new graph is bipartite with old vertices on one side,
packet vertices on the other; no graph simplicity is required.
It has at most the old vertex count in the group plus \(K\)
vertices. These are precisely the one-step size assertions.

For clarity, (13) also gives the claimed mode-tuple scale without
any asymptotic partition theorem. If \(M>0\), for every \(\theta>0\)
the number \(N_p\) of admissible tuples obeys
\[
 N_p\leq\exp\left(\theta p+
       \frac{6M}{D}\sum_{j\geq1}-\ln(1-e^{-\theta j})\right)
 \leq\exp\left(\theta p+\frac{12M}{D\theta}\right).
 \tag{15}
\]
For the second inequality expand the nonnegative logarithmic
series, sum the geometric series, use
\(e^x-1\geq x\), and bound
\(\sum_{h\geq1}h^{-2}\leq1+\int_1^\infty x^{-2}\,dx=2\).
Taking \(\theta=\sqrt{12M/(Dp)}\) gives the explicit bound
\(N_p\leq\exp(4\sqrt{3Mp/D})\). The Hermite precision estimate
is a separate input if one wants to infer the manuscript's
\(\exp(O_C(M/\sqrt u))\) expression.

## Evidence boundary and prior result

The strongest accepted prior result here concerned tapered Hermite
recovery and its smaller sufficient precision. This theorem establishes
the different missing mechanism: that the actual packet Cauchy kernel
admits integral, weight-divisible modes and that their coefficients
contract on genuinely smaller children. It does not upgrade the prior
conditional conclusion into a certificate of the entire counting algorithm.

The proof uses elementary finite algebra and the displayed grid count,
proved above. No unexamined external proposition is assumed. The local
Wiki search located no prior theorem about this packet/Cauchy mechanism.
The Lean source and statement-fidelity document specify exactly which
universal algebraic subclaims receive kernel verification; the grid,
orientation, packet instantiation, and graph interpretation above are
written proof obligations for independent review. The standalone
`verify.py` supplies adversarial exact finite replays, not a proof of
universal quantification. Significance and novelty remain for the Host's
independent Reviewer; neither is asserted here.
