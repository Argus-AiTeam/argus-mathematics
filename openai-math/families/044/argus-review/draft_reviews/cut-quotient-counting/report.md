# ENGINEER source-fidelity assessment: cut-quotient-counting

Assessment: the source supplies a detailed invariant reachability recurrence
and a correctly normalized, conditional identification with the known
Hausel formula. This is different from the cut-symbol surjection and is not
a theorem supplied by the old Lean core.

## Exact claim, hypotheses, and attribution

C_COUNTING@1 asserts that `prop:cut-recurrence` and
`prop:hausel-identification` identify the multipartition sum with Hausel
Betti numbers at determinant stability.

In the source, the original finite quiver has a loop at every positive-rank
vertex, flavor is trivial, one loop at each such vertex is deleted, and
\(c_{ij}=n_{ij}+n_{ji}\) counts the remaining arrows symmetrically.
For a finite array \(m=(m_{i,s})\), positive slots have type \((i,s)\),
\[
b_{de}=c_{i(d)i(e)}\min(s(d),s(e)),\quad
P_m=\mathbb C[x_d],\quad \mathcal W_m=\prod_{i,s}S_{m_{i,s}}.
\]
The full homogeneous cut ideal and its invariant Hilbert polynomial are
\[
J_m=\left\langle
 q_S=\prod_{d\in S}x_d^{w_{i(d)}}
       \prod_{d\in S,e\notin S}(x_d-x_e)^{b_{de}}
 :\varnothing\ne S\subseteq\Omega_m^+\right\rangle,\qquad
h_m(q)=\operatorname{Hilb}((P_m/J_m)^{\mathcal W_m};q).
\]
Polynomial degree one records half cohomological degree.
Write \((q)_m=\prod_{i,s}\prod_{j=1}^{m_{i,s}}(1-q^j)\),
\(w(m)=\sum_{i,s}w_i m_{i,s}\),
\(D_m=\tfrac12 b(m,m)\), and \(\|m\|_i=\sum_s s m_{i,s}\).
The two precise assertions are
\[
\frac1{(q)_m}
 =\sum_{k+m'=m}
   q^{w(k)+b(k,m')}\frac{h_{m'}(q)}{(q)_k},
\]
and, with \(C(v)=\tfrac12\sum_{ij}c_{ij}v_iv_j\) and
\(l_i=\sum_s m_{i,s}\),
\[
P_{X_{\det}(v,w)}(q)
 =\sum_{\|m\|=v}
    q^{C(v)-D_m+w\cdot(v-l)}h_m(q).
\]
The empty array gives 1. An unframed supported component gives a unit cut
and zero quotient. No reduced replacement of \(J_m\) is intended.

Attribution: OpenAI, *The equivariant cohomological Hikita conjecture for
arbitrary quivers*, September 24, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`.
Source root:
`openai-math/preprints/The-equivariant-cohomological-Hikita-conjecture-for-arbitrary-quivers-September-24-2026`.
The decisive file is `build/sections/counting.tex`, with labels
`lem:finite-cut-quotient`, `prop:cut-recurrence`,
`eq:cut-cohomology`, `eq:cut-stratum-codimension`,
`eq:cut-stratum-euler`, `eq:cut-thom-sequence`,
`cor:cut-generating-ratio`, `prop:hausel-identification`,
`eq:hausel-ordinary`, and `eq:hausel-cut-bound`.
Cut definitions are in `build/sections/laurent.tex`,
`eq:cut-polynomial`.

The counting file's SHA-256 is
`10859f6ab290811c40bef1992379cda73aff7e7618b0d711dc8e5dfe50bdc8a9`,
matching the reference manifest at
`campaigns/9100044/MANUSCRIPTS.json`.
All ten source digests and nine existing old-snapshot digests matched in
read-only comparisons. The old source reference is a symlink to this
version, not an independent old source archive; the measurement table is
in bfn-laurent-generation/report.md.

## Old version disposition

The historical ledger has only C_COUNTING@1, no independent formal proof
or certificate for it; the old graph leaves it open. It is a source-only
dependency of the loop comparison. It is not another instance of
C_CUT_TRACE, and the old support-length regression does not establish
this recurrence or the Betti identification.

## Decisive recurrence argument

The source builds a representation space \(E_m\) with one-dimensional
slot spaces, \(b_{de}\) arrows in each direction between distinct slots,
and \(w_{i(d)}\) arrows from a fixed framing line to slot \(d\).
The slot torus acts by change of basis. Let \(U_m\) be the open subset
where every slot is reachable from the frame through nonzero arrow
coordinates.

For the open locus with at most \(r\) unreachable slots, a stratum
\(Z_S\) with exactly \(r\) unreachable slots is cut out by zero incoming
coordinates into \(S\). It is smooth, closed in that open locus, and a
vector bundle over the reachable open for the complementary array \(m'\).
Its equivariant cohomology is
\[
(P_{m'}/J_{m'})[x_d:d\in S].
\]
Its normal rank is \(w(k)+b(k,m')\) and its Euler class is exactly
\(q_S\). Only incoming arrows vanish, so there is no extra factor of two
from the bidirected graph.

The non-zero-divisor point is addressed over the possibly nonreduced
ring \(P_{m'}/J_{m'}\). In the new variables of \(S\), \(q_S\) has a
unique highest-total-degree monomial with coefficient one. Multiplication
is therefore injective over any coefficient ring. Self-intersection
makes the Gysin map injective. Different strata are disjoint, so their
direct-sum Gysin map is injective too. The Thom sequence becomes short
exact; induction gives even cohomology and surjectivity of restriction
from \(P_m\). Since every stratum class lifts from a coefficient
polynomial, the projection formula identifies the kernel as the ideal
of all the actual Euler cut products. Thus
\[
H^*_{T_m}(U_m)=P_m/J_m
\]
as a ring, not merely after reduction.

Permutations of equal types act on this entire construction. Complex
Thom orientations introduce no permutation signs. Exactness of finite
invariants over \(\mathbb C\) makes a subset orbit with count vector
\(k\) contribute
\[
q^{w(k)+b(k,m')}\frac{h_{m'}(q)}{(q)_k}.
\]
Its stabilizer is \(\mathcal W_k\times\mathcal W_{m'}\); there is no
binomial multiplicity after taking invariants. Summing the strata proves
the recurrence.

Finiteness is also justified independently: a common zero with a nonzero
coordinate value \(a\) would make the cut on all slots of value \(a\)
nonzero. Hence the common zero locus is contained in the origin, or the
ideal is the unit ideal. Nullstellensatz is used only for finite
dimensionality, not to replace the ideal by its radical.

## Generating ratio and Betti normalization

The identity
\(D_{k+m'}=D_k+D_{m'}+b(k,m')\) transforms the recurrence into
\[
\sum_m z^{\|m\|}q^{-D_m-w(m)}h_m(q)
 =
\frac{\sum_m z^{\|m\|}q^{-D_m-w(m)}/(q)_m}
     {\sum_m z^{\|m\|}q^{-D_m}/(q)_m}.
\]
There are finitely many arrays in each fixed \(z\)-degree and the
denominator has constant term one, so this is a formal-series identity.

The source compares determinant stability with the affine complex
moment fiber at \((\operatorname{id}_{V_i})_i\), using flat
hyperkahler rotation and affine Kempf--Ness, not a claim that the
rotation is holomorphic. For the original quiver,
\[
E_Q(\lambda)=
 \sum_{a:i\to j}\langle\lambda^i,\lambda^j\rangle
 -\sum_i\langle\lambda^i,\lambda^i\rangle.
\]
Deleting one loop per vertex gives \(E_Q(\lambda)=D_m\);
\(\sum_i\langle\lambda^i,(1^{w_i})\rangle=w(m)\) and the half
dimension is \(C(v)+w\cdot v\). These identities give exactly the
displayed shift, not its reciprocal.

The primary formula was retrieved from Tamas Hausel, *Betti numbers of
holomorphic symplectic quotients via arithmetic Fourier transform*,
**arXiv:math/0511163v2**, Theorem 5, Equation (9), at
<https://arxiv.org/html/math/0511163v2>.
It explicitly allows multiple edges and loops and gives the ordinary
Poincare-series generating ratio with \(t^{-d(v,w)}\) on the left,
\(d=2(C(v)+w\cdot v)\) here. Setting \(q=t^2\) gives the source's
`eq:hausel-ordinary`. Its partition pairing is
\(\sum_{a,b}\min(\lambda_a,\mu_b)\), and its denominator factors are
\(\prod_j(1-t^{2j})\). Thus the theorem-level source supports the
normalization actually used, rather than only an arithmetic count or an
abstract reference to Betti numbers. The geometric comparison of the
particular moment levels is still an input.

## RRT attribution: related known mathematics, not the symbol theorem

The following exact version was also retrieved beyond the abstract:
Markus Reineke, Brendon Rhoades, Vasu Tewari, *Zonotopal algebras,
orbit harmonics, and Donaldson-Thomas invariants of symmetric quivers*,
**arXiv:2207.11861v2**, at
<https://arxiv.org/html/2207.11861v2>.

Its Section 4 works with symmetric adjacency \(a_{ij}\), at least one
loop per vertex, and, for the covering-graph argument in Section 4.2,
a connected graph \(G_{Q,\gamma}\). Between different colors that graph
has \(a_{ij}\) edges per pair, and within a color it has \(a_{ii}-1\).

- Lemma 4.2 identifies the split product \(f_{\delta,\bar\delta}\)
  with a cut-edge product and obtains every bond product up to the
  \(S_\gamma\)-action.
- Corollary 4.3 gives
  \(A_\gamma^{\mathrm{prim}}=\mathcal P(G)\oplus J_\gamma\), where
  \(J_\gamma\) equals the cocircuit ideal in the difference-polynomial
  ring.
- Section 4.4 identifies the reduced-incidence cocircuit presentation
  with Hausel--Sturmfels's toric Nakajima cohomology presentation,
  Equation (37) of that cited source.

This supports the known cocircuit/toric interpretation. It does not
state the support-length Laurent-symbol surjection, its unnormalized
stabilizer trace, or the precise framed invariant recurrence above.
Disconnected unframed components here are handled by unit cuts, not by
silently applying RRT's connected-graph hypothesis.

## Supported scope, remaining obligations, and classification

The recurrence, invariant multiplicities, formal ratio, and substitutions
into the retrieved Hausel formula are internally supported. Their use as
the ordinary Betti polynomial remains conditional on the stated
determinant GIT/moment-level comparison, including loops and empty cases,
and the equivariant Thom/Gysin framework. Those are source arguments,
not certified by the old finite checker. No claim about \(B_0\) follows
until the separate cut-symbol map and BFN/Laurent interface apply.

Known reconstruction: cocircuit presentations and Hausel's Betti
formula. Source-only proposed argument: this reachability recurrence and
its particular multipartition assembly. Originality has not been
established. No contradiction was found in the assigned claim.
Native Host-invoked independent review remains required and pending;
this ENGINEER assessment is not self-acceptance.
