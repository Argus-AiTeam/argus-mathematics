# Integral homology and simultaneous monodromy of the actual Kummer family

## Result and scope

**Verification theorem.** Let \(E/\mathbb C\) be an elliptic curve with an
oriented primitive period basis \(a,b\). Let \(n\geq3\) be odd and
\(m>1\) divide \(n\). Use the manuscript's actual normalized family
\[
 C_{m,R}:\quad Y^m=f_R(Z),\qquad
 \operatorname{div}(f_R)=([n]R)-(-[n]R)-n(R)+n(-R),\quad f_R(O)=1.
\]
The parameter \(R\) avoids exactly the collisions excluded in `geo:family`,
and any further finitely many deleted parameters. Then:

1. The lifted handle cycles are an integral symplectic basis, on which the
   deck generator \(u\) acts by simultaneous cyclic permutation.
   In particular \(H_1(C_{m,R},\mathbb Z)\) and
   \(H^1(C_{m,R},\mathbb Z)\) are free of rank two over
   \(\mathbb Z[C_m]\).
2. The horizontal and vertical half-period collision loops give, **in one
   transported basis**, upper and lower shears with entries
   \(\sigma_a(2-u-u^{-1})\) and \(\sigma_b(2-u-u^{-1})\).
   Each sign is in \(\{1,-1\}\), as allowed in the manuscript.
3. This homology calculation has a cellular proof valid after base change
   to every commutative coefficient ring, without inverting \(m\).
   Consequently character evaluation gives free rank-two lattices at
   every coefficient prime. Equal residual characters give equal residual
   representations **before** semisimplification on these lattices.
   For \(n=3p\) this proves the three stated congruences.

These are universal statements, not extrapolations from the numerical cases
in `verify.py`. Sections below supply the geometric proof. `Main.lean`
certifies the universally quantified cellular and specialization algebra.
The exact script checks a polygon model derived here, its boundary and
twist matrices, all permitted signs and indexing reversals, ramified
coefficient cases, an adapter replay, and freshness of the compiler evidence.

This verifies the bridge in `mon:integral-module`, `mon:vanishing-classes`,
`mon:transvections`, `sys:integral-evaluation`, and `sys:congruences`.
It does **not** verify `sys:properties`, the arithmetic local opens,
simultaneous residual specialization, the automorphy inputs, descent, or
`thm:main`. No literal manuscript assertion in this scope was refuted.

This is an independently derived verification, not a claim of a newly
discovered general fact about surface homology. The literature lookup did
not establish novelty. Independent Reviewer replay and a publishability/
novelty assessment remain necessary; this file does not close the
campaign's `verified_new` gate.

## 1. Why this particular cover is a split slit cover

It would be incorrect to begin with an arbitrary two-point cyclic cover
of a torus: an unramified twisting character can change its handle lifts.
The following argument determines that character from the **normalized
function of this family**.

Work on the constant-\(E\) parameter curve near \(R=O\), with local
coordinates \(r,z\) whose first derivatives agree. Blow up \((z,r)=(0,0)\).
The four divisor sections meet the exceptional line at
\(v=z/r=n,-n,1,-1\), respectively. They are distinct in characteristic
zero. The involution \(Z\mapsto-Z\) and the normalization give
\(f_R(-Z)=f_R(Z)^{-1}\). The involution preserves each of the main and
exceptional vertical divisors, so the valuation of \(f\) along each is its
own negative, hence zero. This argument also rules out a hidden scalar
power of the parameter.

The restriction to the exceptional line is therefore
\[
 q_n(v)=\frac{v-n}{v+n}
         \left(\frac{v+1}{v-1}\right)^n.
\]
Indeed its divisor is prescribed, and its scalar is fixed by the section
\(Z=O\), which meets this line at \(v=0\). Since \(n\) is odd,
\(q_n(0)=(-1)(-1)^n=1\). Also \(q_n(\infty)=1\).
On the main component the restriction has no divisor and is constant;
matching at the node shows that its value is \(1\), not an unspecified
nonzero scalar.

Choose a fixed small disk \(D\) around \(O\). On the compact complement of
its interior, \(f_R\) is a holomorphic unit for all sufficiently small
\(r\), including \(r=0\), and tends uniformly to \(1\). Its image there
lies in a simply connected neighborhood of \(1\). The root tending to
\(1\), multiplied by the fixed \(m\)-th roots of unity, gives **\(m\)
globally labeled sheets over the complement**, over a full small parameter
disk containing \(0\). This proves triviality; it is not inferred just
from the number of branch points.

The cover of \(D\) is connected, because a meridian of either simple
branch point has monodromy \(1\) or \(-1\) in \(C_m\). The sections of
orders \(\pm n\) have trivial monodromy, since \(m\mid n\).
The boundary monodromy is zero. There are thus \(m\) boundary components,
each mapping with degree one. A triangulation of \(D\) containing the
two branch points lifts with \(m\) copies of every open cell except that
each branch vertex has one lift instead of \(m\). Hence
\[
 \chi(\pi^{-1}D)=m-2(m-1)=2-m.
\]
With \(m\) boundary components this is an oriented genus-zero surface.
The whole cover is consequently obtained by gluing this planar surface
to \(m\) copies of a once-punctured torus.

For \(R_s=(s/n)a\), \(0<s<1/2\), the short branch arc extends to the arc
from \(-sa\) to \(sa\) through \(O\). There is no collision on this open
path. Isotopy of the arc, together with the preceding determination of the
unramified character at its start, gives the slit description along the
whole path. The vertical path is identical with \(a,b\) interchanged.

## 2. Integral lattice, with an explicit equivariant chain model

Each punctured torus has two handle cycles. Choose the horizontal cycle
at height \(1/2\) and vertical cycle at horizontal coordinate \(1/2\),
or isotopic representatives outside \(D\). Their lifts \(a_i,b_i\)
have intersections
\[
 \langle a_i,b_j\rangle=\delta_{ij},\quad
 \langle a_i,a_j\rangle=\langle b_i,b_j\rangle=0.
\]
There is a direct integral proof that these generate. In Mayer--Vietoris
for the planar piece and the \(m\) punctured tori, the map on \(H_0\)
from the \(m\) gluing circles is injective, since each has its own torus
component. On \(H_1\) their images span the homology of the planar piece,
while each torus boundary is zero. The resulting quotient is exactly the
direct sum of the \(m\) handle homologies. This argument works with every
commutative coefficient ring \(A\), not merely with rational coefficients.

Here is a second, explicit cellular presentation, which is the one
replayed by the script. Collapse the usual paths inside the cut polygons
to obtain two branch vertices \(v_+,v_-\), three edge orbits
\(a_i,b_i,e_i\), and \(m\) oriented faces. Edge \(e_i\) goes from
\(v_+\) to \(v_-\). The face word is
\[
       a_i b_i a_i^{-1} b_i^{-1} e_i e_{i+1}^{-1}.
       \tag{1}
\]
One can obtain (1) directly by inserting one torus handle into each
bigon of the two-branch-point sphere cover: the two banks of the slit
bound successive bigons, and the handle contributes its commutator.
Thus this is a construction of the slit surface, not a presentation
deduced from the desired homology or matrices.

For additional verification of the gluing, let \(\phi\) advance along
the face words and let \(\alpha\) reverse an edge. The vertex permutation
\(\phi\alpha\) has the following local transitions:
\[
 a_i^+\mapsto b_i^-\mapsto a_i^-\mapsto b_i^+
       \mapsto e_i^+\mapsto a_{i-1}^+,\qquad
 e_i^-\mapsto e_{i+1}^-.
\]
It has exactly two circular links, of lengths \(5m\) and \(m\).
Projection to the \(m=1\) torus has local degree \(m\) at each vertex,
with opposite generating sheet steps; away from them it is a covering.
The deck action increments every index. This checks both the surface
condition and the required branch data.

Put \(A_m=A[u]/(u^m-1)\) and let \(\varepsilon\) be augmentation.
Counting signed edges in (1), rather than postulating a differential,
gives
\[
 C_2=A_m,\quad C_1=A_m a\oplus A_m b\oplus A_m e,\quad C_0=A^2,
\]
\[
 d_2(q)=(0,0,(1-u)q),\qquad
 d_1(a,b,e)=(-\varepsilon(e),\varepsilon(e)).
       \tag{2}
\]

For completeness, the exactness in (2) is elementary even if \(A\)
has torsion or nilpotents. If \(\sum_{i=0}^{m-1}c_i=0\), set
\(p_0=0\), \(p_{i+1}=p_i+c_i\). Then \(p_m=p_0\).
With \(q_i=p_{i+1}\) and cyclic indices,
\[
       q_i-q_{i-1}=c_i
\]
also at \(i=0\). Conversely every cyclic difference has zero sum.
Therefore
\[
 \ker\varepsilon=(1-u)A_m,\qquad
 H_1(C_{m,R},A)\simeq A_m a\oplus A_m b.             \tag{3}
\]
The projection in (3) and its section \( (a,b)\mapsto(a,b,0)\) are
explicit and natural in \(A\). Also
\(\ker(1-u)=A(1+u+\cdots+u^{m-1})\), so the remaining homology
groups are \(H_0=A\) and \(H_2=A\), as expected for this surface.
No averaging or rational-to-integral inference occurs.

For cohomology, if \(\alpha_i,\beta_i\) are the dual coordinate functionals,
then \(u^*\alpha_i=\alpha_{i-1}\) and similarly for \(\beta_i\).
Reindexing by \(-i\) gives the regular module again. Equivalently,
\([1](xy)\) is a perfect coefficient pairing on \(\mathbb Z[C_m]\).
The smooth parameter curve is connected, so equivariant transport gives
the lattice assertion on every smooth fiber. Over the manuscript's
\(t\)-line, use its explicit constant-\(E\) pullback
\((x,y)\mapsto(x,y(R)y)\). This identifies the actual covers, not just
their genera.

## 3. The actual collision has twist exponent one

At \(R_*=a/(2n)\), write \(t=R-R_*\) and
\(z=Z-a/2\) in additive analytic coordinates. Only the two simple
branch sections collide there, so locally
\[
       f_R=g(z,t)\frac{z-nt}{z+nt}
\]
with \(g\) a holomorphic unit. Locally take its analytic \(m\)-th root
and put \(V=Y/g^{1/m}\). The exact equation is
\[
       (z+nt)(V^m-1)=-2nt.                           \tag{4}
\]
For each \(\zeta^m=1\), the derivative of \(V^m-1\) at \(\zeta\)
is \(m\zeta^{m-1}\ne0\) in \(\mathbb C\). Thus \(X=z+nt\) and
\(U=V^m-1\) are analytic coordinates near that node, and
\[
                        XU=-2nt.
\]
There are \(m\) such nodes, and their smoothing orders are **one**.
The number \(2n\) is a nonzero complex unit, not an exponent.
The identical calculation applies to \(R_*=b/(2n)\).
Taking roots of analytic units in this characteristic-zero argument
does not invert \(m\) in any coefficient-ring lattice.

One does not need to cite an unexamined integral Picard--Lefschetz theorem
for this calculation. In the annulus \(XU=t\), varying
\(\arg t\) through \(2\pi\) rotates one boundary once relative to the
other, which is one Dehn twist. A crossing arc acquires one copy of the
core circle with its intersection sign. For disjoint node annuli the
twists have disjoint support and therefore act on integral homology as
\[
 \gamma\longmapsto
 \gamma+\sigma\sum_i\langle\gamma,\delta_i\rangle\delta_i.
       \tag{5}
\]
The common sign records the intersection convention or inversion of the
based loop. Orienting an individual \(\delta_i\) oppositely changes
neither summand. This derives the required integral formula from the
local model and the elementary action of a twist.

As \(s\) tends to \(1/2\) along the horizontal slit, a small circle around
the shrinking gap has \(m\) closed lifts. Each lift uses one bank on sheet
\(i\) and the other on sheet \(i+1\), or \(i-1\) if indexing is reversed.
It is disjoint from all horizontal handle cycles. Its intersections
with the vertical cycles are one on each of the two adjacent sheets,
with opposite signs. Since Section 2 already established an **integral**
basis, these intersections determine the actual class:
\[
                 \delta_i=\pm(a_i-a_{i+1}).         \tag{6}
\]
This step is the geometric identification missing from any audit that
starts only with the asserted matrices.

Let \(D e_i=e_i-e_{i+1}\). Substitution into (5) gives the off-diagonal
matrix
\[
 DD^{\mathsf T}=2I-P-P^{-1},
\]
where \(P e_i=e_{i+1}\). In particular
\[
 b_j\longmapsto b_j+\sigma_a(2a_j-a_{j-1}-a_{j+1}),
 \qquad a_j\longmapsto a_j.
\]
Reversing the deck generator leaves this matrix unchanged.
The vertical collision gives the analogous lower shear.

## 4. Why these are in one basis, not two unrelated ones

Choose the initial horizontal and vertical parameters inside the single
small parameter disk from Section 1. Both fixed handle loops lie in the
same complement of \(D\). The analytic roots tending to the fixed
\(m\)-th roots of unity label their lifts over **the entire parameter
disk, including \(R=0\)**. Transport between the two initial parameters
therefore fixes the common labeled basis from (3). There is no residual
monodromy on these generators from going around \(0\).

Continue the horizontal and vertical slits from these starts to their
respective collisions and return the small collision loops along the
same paths. These are based loops in the same smooth parameter space.
The preceding computation therefore supplies both shears in the same
integral lattice. A different initial root labeling is only a common
cyclic shift; it commutes with the Laplacian. Passing from the
constant-\(E\) pullback to \(U\) maps its based loops to loops of the
original family and preserves their actions. Removing further finite
sets permits representatives avoiding those points and does not lose
these elements from the monodromy image.

## 5. Integral specialization and the three congruences

Embed the arithmetic fiber into \(\mathbb C\). Finite-coefficient
Betti--etale comparison, compatible with the deck transformations, and
inverse limits give
\[
 M_\ell=H^1_{\mathrm{et}}(C_{n,\overline F},\mathbb Z_\ell)
       \simeq\mathbb Z_\ell[C_n]^2.
\]
This uses characteristic zero of the **geometric base field**. It does
not require \(\ell\nmid n\), or a cover model smooth in residue
characteristic \(\ell\). The comparison input is recorded as
`A_BETTI_ETALE` on `C_GPS_EVALUATION`.

The rotations are defined over \(F\), so every \(G_F\)-action matrix in
a chosen group-ring basis is in
\(\mathrm{GL}_2(\mathbb Z_\ell[C_n])\).
For a coefficient ring of integers \(\mathcal O\) and an evaluation
\(e_\theta:\mathbb Z_\ell[C_n]\to\mathcal O\),
\[
       T_\theta=M_\ell\otimes_{e_\theta}\mathcal O
                  \simeq\mathcal O^2.
\]
Applying a ring homomorphism to a matrix and its inverse preserves their
inverse relation, so this is a stable lattice with a continuous action.
In characteristic zero the group algebra splits into its character
factors, and this evaluated quotient is the specified \(\theta\)-space.
No integral projector is being used.

Reduction gives
\[
 T_\theta/\mathfrak mT_\theta
       =M_\ell\otimes_{\overline e_\theta}k .
\]
If \(\overline e_\theta=\overline e_{\theta'}\), the right-hand sides,
including every Galois-action matrix, are identical. In particular these
particular residual lattices agree before semisimplification.

In a residue field of characteristic \(\ell\), an \(\ell^r\)-th root
of unity is \(1\): \((z-1)^{\ell^r}=z^{\ell^r}-1=0\), and a field has
no nonzero nilpotents. Thus for \(\chi=\psi\eta\), of respective orders
\(3p,p,3\),
\[
 \overline\chi_p=\overline\eta_p,\qquad
 \overline\chi_3=\overline\psi_3,\qquad
 \overline\psi_p=1.
\]
This proves precisely the three congruences of `sys:congruences`.

There is no assertion that a degree-divisible pullback from a smaller
cover is an integral isomorphism. The rational identifications at the
elliptic endpoints preserve **semisimplified** reductions. An elementary
reason is as follows. Scale two stable lattices to be nested, with
finite quotient \(Q\). Reduction gives the exact sequence with ends
\(Q[\varpi]\) and \(Q/\varpi Q\); these ends have the same composition
factors, by the two exact sequences for multiplication by \(\varpi\)
on \(Q\). The two reduced lattices therefore have the same composition
factors and isomorphic semisimplifications.

As a further consistency check, in every field and for every nonzero
\(\lambda\ne1\),
\[
       2-\lambda-\lambda^{-1}
          =(1-\lambda)(1-\lambda^{-1})\ne0.
\]
Both shears consequently have no common invariant line, also after
field extension. The trivial-character value is zero and is **not**
covered by that assertion. This does not replace the manuscript's
separate arithmetic argument for its trivial-character representation.

## 6. Evidence, literature, and what was not checked

Run the standalone exact replay from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/geometric_prime_switch/verify.py
```

`exact_certificate.json` records exact cellular replays for \(m=3,5,9,15\),
including coefficient primes dividing \(m\), all four shear-sign choices,
and character-ring examples \(p=101,109\), both satisfying \(p>100\).
Its finite checks supplement, rather than prove, the universal geometric
argument. The Laplacian cofactors and characteristic-dependent kernel
dimensions are standard cycle-graph facts, not claimed novel discoveries.

There are also actual arithmetic fibers, not just abstract matrices:
\(E:y^2=x^3-x+1\), \(R=(0,1)\), \(t=0\), for \(n=3,5,9\).
Here \(h(0)=1\), so the manuscript's twist is exactly \(E\).
The script checks every chord/tangent cubic factorization using rational
arithmetic and constructs the divisor of the Miller function
\(G_{n,R}\), with
\(\operatorname{div}(G_{n,R})=n(R)-([n]R)-(n-1)(O)\).
The quotient \(G_{n,-R}/G_{n,R}\) has precisely `geo:kummer`'s divisor.
At \(O\), each line/vertical factor has the same leading coefficient for
\(R\) and \(-R\), so the quotient has value \(1\), identifying the actual
normalized function. All five required points are checked to be distinct.
The exceptional-fiber rational expression is checked separately for
divisors of \(n=3,9,15,303,327\). These are explicit finite constructions
and sign checks, not a substitute for the universal proof.

The single Jacobian operation was inspected before use:
`chain_complex.homology.compute`, field `QQ`, degrees 0 through 2, cell
dimensions `[2,9,3]`. The **exact payload** and **unaltered typed output**
are `jacobian_payload.json` and `jacobian_output.json`.
Server version `0.14.0`, protocol `2025-11-25`, adapter exit status zero,
and Betti numbers `[1,6,1]` were obtained. No timeout or structured error
was returned. This is one bounded rational calculation, not evidence for
integral freeness by itself.

The actual Lean 4.31.0 compiler run returned exit code zero and
`proof_holes=[]`. Its immutable claim certificate is
`certificates/C_GPS_ALGEBRA-93537cc90355f9b6.json`; `lean_verify.json`,
`lean_check.json`, and `compile.log` preserve the run. The separate
`statement_fidelity.md` says exactly which objects and quantifiers were
formalized and which geometry was not. `verify.py` rejects stale source
or fidelity bytes. An earlier failed run was a Lean parsing failure from
using the reserved word `prefix` as a definition name; it is retained as
inconclusive evidence, not treated as a mathematical refutation.

The bounded literature worker actually read J. S. Milne,
*Lectures on Etale Cohomology*, version 2.21, 22 March 2013,
[author-hosted source](https://www.jmilne.org/math/CourseNotes/LEC.pdf).
The relevant statements are Theorem 21.1 (p. 130) and Theorem 20.2
(p. 127). Short source passages:

> Let \(X\) be a nonsingular variety over \(\mathbb C\). For any finite
> abelian group \(\Lambda\) and \(r\geq0\),
> \(H^r(X_{\mathrm{et}};\Lambda)\simeq H^r(X_{\mathrm{cx}};\Lambda)\).

> If \(\pi:X\to S\) is proper and smooth and \(F\) is locally constant
> with finite stalks, then \(R^r\pi_*F\) is locally constant with finite
> stalks, provided the torsion in \(F\) is prime to the characteristic of \(k\).

This is an author exposition, not a claim to have opened the original
SGA comparison proof. It has no DOI or arXiv identifier supplied here;
the ledger honestly labels the prose reference `uncited`, not registry-
resolved or independently attributed. The Reviewer must read the source
and assess its application. The original integral SGA 7 passage and a
direct published statement identifying this family's common integral
basis were not obtained in the bounded lookup. The argument above does
not assume those unexamined statements.

The remaining unformalized obligations are the geometric identifications
in Sections 1--4, the application of comparison, and the arithmetic
interpretation in Section 5. They have proofs here but are not Lean
theorems. All proof-graph nodes remain unconfirmed until the Host-invoked
independent Reviewer has checked them. No Engineer-written status
substitutes for that review or for a novelty finding.
