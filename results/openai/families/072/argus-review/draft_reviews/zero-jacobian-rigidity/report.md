# Zero-Jacobian rigidity and the harmonic barrier

**Assessment:** `C_AT_RIGIDITY` v1 is supported by its deterministic prose
argument. The first-power special case is inherited from manuscript I;
the all-k classification is an old proposed strengthening, not verified
novelty. This is not a Lean proof of rigidity or native acceptance.

## Exact statement and source

For k>0 and F holomorphic injective on H, with F(i)=0 and F'(i)=1, let
q=-iyF''/F' and

\[
 k^2J=k(k-1)+(2k-1)\operatorname{Re}q+|q|^2.
\]

If J vanishes identically, then k=1 and F is either F_infinity(z)=z-i or

\[
 F_t(z)=\frac{(z-t)^2-(i-t)^2}{2(i-t)},\qquad t\in\mathbb R,
\]

with unique finite vertex t in the nonaffine case. Conversely these
maps have J identically zero at k=1.

The proof is Section 5 of the snapshot-matching old
`9000072/research/affine_transport/report.md`; there is only one ledger
version of this claim. I's `06-equality-barrier.tex`,
`lem:no-zero-J`, proves the k=3/4 obstruction by the same rectangle
barrier. Its authorship is OpenAI, dated September 24, 2026, at the staged
reference revision recorded in the coverage index. The old report
extends that barrier to all k>0 other than one, and adds the k=1
classification. It must not be credited with originating I's obstruction.

## Decisive proof checked

Completing the square gives |q+k-1/2|^2=1/4. The distance from zero
to this **circle**, not to its filled disk, is

\[
 \delta=\bigl||k-1/2|-1/2\bigr|.
\]

For k>0, delta=0 only at k=1; the other algebraic possibility k=0 is
excluded. Thus for k not equal to one, h=F''/F' is nonzero everywhere
and |h(x+iy)|>=delta/y. Univalence supplies nonvanishing F', so h is
holomorphic; consequently u=log|h| is a finite harmonic function.

On [-1,1] times [epsilon,1], compare u to

\[
 b_\epsilon=\log\delta+\log(1/\epsilon)\cos(\pi x/2)
 \frac{\sinh(\pi(1-y)/2)}{\sinh(\pi/2)}.
\]

The added factor vanishes on the sides and top. On the bottom it
lies between zero and one, so b_epsilon<=log delta-log epsilon<=u.
The harmonic minimum principle gives u>=b_epsilon inside. At i/2
the coefficient of log(1/epsilon) is fixed and strictly positive,
contradicting finiteness of u(i/2) as epsilon decreases. The
rectangle remains inside H at each positive epsilon; no boundary
regularity of F on the real axis is presumed.

At k=1 the equation is
y Im(h)+y^2|h|^2=0. If h is identically zero, the two normalizations give
the affine map. Otherwise choose a nonempty open set where h is nonzero.
There Im(1/h)=y, so the holomorphic function 1/h-z is real-valued
and constant, say -t with t real. The holomorphic identity
(z-t)h(z)=1 extends over all H by the identity theorem, rather than
assuming that a reciprocal initially defined off zeros is global.
It follows that h has no zeros. Solving F''/F'=1/(z-t) and imposing
F'(i)=1,F(i)=0 gives exactly F_t. In particular
t=i-1/F''(i), so the vertex is unique.

Conversely the explicit formulas give J=0. The factorization

\[
 F_t(z)-F_t(w)=\frac{(z-w)(z+w-2t)}{2(i-t)}
\]

proves injectivity on H: the second factor has positive imaginary
part for z,w in H. The denominator is nonzero for real t.
Holomorphy, F_t(i)=0, and F_t'(i)=1 follow directly; they are not
replaced by a disk-coordinate analogy.

## Relation to the other claims

The expected-Jacobian argument at p=1,beta=1/4 gives k=3/4 and
J identically zero almost surely, contradicting the barrier just checked.
At p=2,beta=1, k=1 instead permits the affine/quadratic locus. Thus
the rigidity claim does **not** itself identify a probability on that
locus; this is the separate
[`critical-cauchy-law`](../critical-cauchy-law/report.md) unit.

The proof also does not classify normalized disk maps as rotations of
Koebe. The old checker explicitly gives
f_t(zeta)=zeta(1+t zeta/(i-t))/(1-zeta)^2. Only the zero-vertex
representative has the usual Koebe formula in those fixed disk
coordinates; the entire family is an affine-rebasing orbit.

## Evidence, limits, and unresolved scope

The read-only 38-check symbolic replay verifies the completed square,
quadratic Jacobian identity, reciprocal pre-Schwarzian, normalization,
and injectivity factorization. It does not prove the harmonic barrier
or identity theorem. The Lean source proves the denominator,
zero-value normalization, and injectivity restricted to H; it contains
neither the global rigidity implication nor a declaration of derivative
normalization.

No mathematical gap was identified in this deterministic prose argument.
The relevant foundations are the harmonic minimum principle, elementary
holomorphic identity/open-mapping principles, and the nonvanishing
derivative of a univalent map. A claim of full formal rigidity would
require formalizing the barrier and the reciprocal pre-Schwarzian
classification; the current local algebra certificate cannot supply
either implication.

I's barrier is an identified reproduction. Priority of the all-k
strengthening and k=1 classification is unresolved by the bounded
literature review. Absence of a matching classification in the sources
examined is not proof of novelty. Native independent scrutiny of this
assessment remains pending.
