# Exact coordinate convention and low-side geometric lift

## Statement proved here

Let \(E,P,T,v,w,C\) be the integral data in
`two_change_negative_mutation_lift.json`. There exists an embedded
genus-three Seifert surface \(F_U\subset S^3\) whose boundary is the actual
unknot, an ordered basis \(x_0,\ldots,x_5\) for \(H_1(F_U;\mathbb Z)\), and
two disjoint crossing disks \(D_v,D_w\) such that:

1. the Seifert matrix of \(F_U\) in this basis is \(T\);
2. the intersection covectors of \(D_v\cap F_U\) and \(D_w\cap F_U\) are
   \(v\) and \(w\);
3. the indicated opposite crossing changes replace \(T\) by
   \(C=T+vv^T-ww^T\).

Consequently the boundary knot produced by those changes has
unknotting number at most two. This is an existence construction, not the
mechanically recoverable diagram required by the campaign.

## Coordinates

Put
\[
H_{10}=H_{32}=H_{54}=1,\qquad J=H-H^T.
\]
The columns of \(P\) give the final basis in the basis used for \(E\), so
\[
P^TJP=J,\qquad T=P^TEP.
\]
The rank-one update columns are covectors: their entries are the
intersection/linking numbers with the chosen basis cycles. They are
\[
v=(-34,-13,32,24,1,0)^T,\qquad
w=(-49,10,10,38,0,1)^T.
\]

To see why the fourth coordinates cannot be replaced over the integers by
\(-1,-2\), write
\[
v(a)=(-34,-13,32,a,1,0)^T,\qquad
w(b)=(-49,10,10,b,0,1)^T.
\]
The disjointness condition is the vanishing of the induced intersection
pairing on covectors. Since \(J^{-1}=-J\), it is equivalent to
\[
v(a)^TJw(b)=976+10a-32b=0.
\]
All integral solutions are
\[
a=24+16k,\qquad b=38+5k.
\]
The witness uses \(k=0\). The pair \((-1,-2)\) consists only of congruent
modulo-five representatives; over the integers it gives pairing \(1030\),
not zero. Thus it reproduces the finite-field search residue but not the
exact topological data.

The vectors are individually primitive, and the minor on rows \(4,5\) is
\[
\det\begin{pmatrix}1&0\\0&1\end{pmatrix}=1.
\]
Hence they span a primitive rank-two summand of the covector lattice. The
calculation above shows that this summand is isotropic.

## The unknot surface

In the interleaved order used in the JSON, \(E\) is built from the empty
matrix by three directed elementary enlargements. At step \(r\), append
coordinates \(p_r,q_r\) with
\[
E(q_r,p_r)=1,\quad E(q_r,q_r)=0,
\]
all pairings involving \(q_r\) otherwise zero, and with the following
framing and old-coordinate coupling for \(p_r\):

| \(r\) | \(E(p_r,p_r)\) | \(E(\text{old},p_r)=E(p_r,\text{old})^T\) |
|---|---:|---|
| 1 | \(1\) | empty |
| 2 | \(-1\) | \((1,-1)^T\) |
| 3 | \(-2\) | \((-2,-1,1,1)^T\) |

Geometrically, a directed elementary enlargement is obtained by adding a
tube to a Seifert surface; it changes the surface and its basis but not its
boundary knot. Starting from the standard spanning disk therefore gives a
genus-three surface \(F_U\) for the actual unknot with matrix \(E\).
Changing the homology basis by \(P\) changes that matrix to \(T=P^TEP\)
without changing the embedded surface or its boundary.

This is the directed form of the usual enlargement construction. It is
also stated explicitly by Swatee Naik and Theodore Stanford, *A move on
diagrams that generates S-equivalence of knots*,
[arXiv:math/9911005v1](https://arxiv.org/abs/math/9911005v1), p. 7:
congruence is a basis change and an enlargement is addition of a tube to
the Seifert surface.

## Two disjoint crossing disks

For a connected oriented surface with one boundary component, the
intersection map identifies relative one-cycles with integral covectors on
absolute first homology. A primitive isotropic rank-two summand extends to
a symplectic basis. In the standard surface model, the first two members
of the corresponding relative cut system are represented by disjoint
proper nonseparating arcs. Transporting that cut system by an
orientation-preserving surface homeomorphism gives disjoint proper arcs
\(\alpha_v,\alpha_w\subset F_U\) whose intersection covectors are exactly
\(v,w\).

In a bicollar of \(F_U\), thicken each arc to a crossing disk meeting
\(\partial F_U\) at its two endpoints. Disjoint arc neighborhoods give
disjoint disks \(D_v,D_w\). Let \(L_v=\partial D_v\) and
\(L_w=\partial D_w\). If \(X,Y\) are basis cycles, the standard integral
surgery linking formula gives
\[
\operatorname{lk}_{\mathrm{new}}(X^+,Y)
=\operatorname{lk}_{\mathrm{old}}(X^+,Y)
+\epsilon\,\operatorname{lk}(X^+,L)\operatorname{lk}(Y,L),
\]
where the sign \(\epsilon\) is fixed by the crossing twist. Since the
linking column is the intersection covector of the arc, the two chosen
twists change the Seifert matrix by \(+vv^T\) and \(-ww^T\). The resulting
matrix is exactly the displayed \(C\). Reversing those same two twists
returns the boundary to \(\partial F_U\), the unknot.

## Constraint on a compatible Conway ball

In O'Brien's standard basis, the \(A\)-cycles are represented outside the
mutating ball and the \(B\)-cycles are represented inside it. If a crossing
disk were contained in the outside ball, its boundary would have zero
linking with every \(B\)-cycle; its update covector would therefore have
zero entries in coordinates \(4,5\). A disk contained in the inside ball
would similarly have zero entries on the \(A\)-coordinates \(0,1,2\).

Neither update has either support restriction:
\[
v_A=(-34,-13,32),\quad v_B=(1,0),\qquad
w_A=(-49,10,10),\quad w_B=(0,1).
\]
Thus, in any realization using this exact basis and these exact covectors,
both crossing disks must meet the Conway sphere. This does not prove that
such disks and a sphere cannot coexist, but it rules out the simpler
construction in which the unknotting changes are localized on one side of
the mutation.

## What remains unproved

This argument does not provide PD/DT data, embedded representatives of the
two arcs, or a Reidemeister replay. More importantly, it does not locate a
Conway sphere in this same embedding.

O'Brien's mutation calculation starts with a Seifert surface already in
standard position relative to a mutating ball and then derives the block
form and the replacement \(B\mapsto B^T\); see Killian Michael O'Brien,
*Seifert's algorithm, Châtelet bases and the Alexander ideals of classical
knots* (Durham PhD thesis, 2002), Section 5.3.1, equations (5.4)-(5.7),
printed pp. 98-101. It is not a converse from a numerical block matrix to
an embedded Conway sphere. No such sphere, endpoint orientation
certificate, or mutation-compatible disk-band realization has been
constructed here. Therefore this result does not emit a mutant-knot
candidate.
