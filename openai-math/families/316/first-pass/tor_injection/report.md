# Even-degree Tor injection for suspended Dickson ideals

## Statement and scope

The target is `lem:tor-injection`, `build/algebra.tex`, lines 388--513,
in the staged September 25, 2026 manuscript. Write

\[
 t=d_0,\quad y_j=d_j\ (1\leq j<k),\quad
 D=\mathbb F_2[t,y_1,\ldots,y_{k-1}],\quad M=\Sigma^n t^nD.
\]

Here \(k\geq1\), \(n\geq0\), and \(n\equiv k\pmod2\). The claim is that
\[
 I_A\otimes_A M\longrightarrow I_{A/K}\otimes_{A/K}(M/I_EM)
\]
is injective on the kernel of the action map in every even internal
(manuscript: total) degree. Internal degree includes the suspension and
the operation degree, but not the homological degree.

The argument below is a uniform proof, not an inference from finite
experiments. It also proves a stronger exponent-support statement for
all positive Tor degrees over the first \(k\) primitives. The formal
source certifies the exponent-truncation step, not the entire Steenrod
algebra or Curtis's conjecture. Independent Reviewer acceptance and
novelty/significance assessment remain pending.

## Source-grounded inputs

The standard Steenrod input is Milnor's polynomial dual and coproduct
description at two: *The Steenrod Algebra and Its Dual*, Ann. Math.
67 (1958), 150--171, DOI `10.2307/1969932`, Theorem 3 and Appendix 1.
The exterior algebra \(E=\Lambda(q_0,q_1,\ldots)\) has
\(|q_i|=2^{i+1}-1\), and \(q_i x_s=x_s^{2^{i+1}}\). The quotient ideal
is \(K=I_EA=AI_E\). The reduction from this standard description to
the last assertion is given below; it is not an extra assumption that
the manuscript's Tor claim holds.

The manuscript's assertions about geometric weight modules, cones,
Cartier halving, and the final Hopf--Kervaire argument are recorded as
unverified dependencies of its main theorem. None is proved by this
local audit.

A bounded initial literature search located Milnor's primary source
and related Dickson hit-problem literature, but did not identify an
exact prior statement of the exponent-support theorem below. That
limited search does not establish novelty. In particular, standard
exterior resolutions and localization are not claimed as new.

The previously suggested monomial-only or one-primitive-at-a-time
test is insufficient: it does not determine the quotient by *all*
degree-two relations or detect cancellations among components of a
cycle. That route is retired, rather than counted as verification.

## 1. Actions derived from polynomial squares

The polynomial action is fixed independently by
\[
 \operatorname{Sq}^r(x_1^{a_1}\cdots x_k^{a_k})
 =\sum_{r_1+\cdots+r_k=r}
   \prod_s\binom{a_s}{r_s}\,x_s^{a_s+r_s}.
\]
The binomial coefficients are reduced modulo two. Cartan and the
Milnor primitive recurrence give the derivations stated above.

Use the root polynomial
\[
 P(U)=\prod_{a\in\langle x_1,\ldots,x_k\rangle_{\mathbb F_2}}(U+a)
     =\sum_{j=0}^k d_jU^{2^j},\qquad d_k=1.
\]
Applying \(q_i\) to \(P(x_s)=0\) gives
\[
 \sum_{j<k}q_i(d_j)x_s^{2^j}=t x_s^{2^{i+1}}.
\]
Uniqueness of a linearized polynomial of degree at most \(2^{k-1}\)
on the binary span proves
\[
 D_i=q_i=t\partial_{y_{i+1}}\quad(0\leq i<k-1),\qquad
 D_{k-1}=t(t\partial_t+\sum_{j=1}^{k-1}y_j\partial_{y_j}).
 \tag{1}
\]
Raising the root equation to \(2^{r+1}\) gives
\[
 q_{k+r}=\sum_{j<k}d_j^{\,2^{r+1}}q_{j+r}.                 \tag{2}
\]
Induction expresses every later primitive as
\(q_i=\sum_{j<k}b_{ij}q_j\), where all \(b_{ij}\) are polynomial
squares. Such coefficients commute past every primitive, and
multiplication by them preserves \(t^nD\).

For completeness, \(t^nD\) is stable under every square: \(t\) is
the product of the nonzero binary linear forms; the total square of
each such form \(a\) is \(a+a^2\). Thus the total square of \(t\) is
divisible by \(t\), and Cartan proves ideal stability.

At exponent \(c>n\), a monomial is a simultaneous \(E\)-coinvariant
exactly when
\[
 c\equiv k\pmod2,\qquad \text{every }y_j\text{-exponent is odd}.
 \tag{3}
\]
Indeed an even \(y_j\)-exponent is hit by \(D_{j-1}\), using a
preimage at exponent \(c-1\). If all are odd, \(D_{k-1}\) on
the monomial at exponent \(c-1\) has coefficient
\((c-1)+(k-1)=c+k\) modulo two. No primitive hits the floor
\(c=n\). Formula (2), and the fact that its coefficients are
squares, show that later primitives introduce no additional hits.
This proves (3) on arbitrary linear combinations, since these images
are monomial spans.

## 2. Laurent freeness, with an explicit basis

Let \(E_k=\Lambda(q_0,\ldots,q_{k-1})\),
\(L=D[t^{-1}]\), and
\[
 R=\mathbb F_2[t^2,t^{-2},y_1^2,\ldots,y_{k-1}^2].
\]
Every \(D_i\) annihilates \(R\). Set
\[
 v_0=t^{-k}\prod_{j=1}^{k-1}y_j.
\]
For \(S\subseteq\{1,\ldots,k-1\}\), put
\(q_S=\prod_{j\in S}q_{j-1}\). Directly from (1),
\[
 q_Sv_0=t^{|S|-k}\prod_{j\notin S}y_j,\qquad
 q_{k-1}q_Sv_0=t^{|S|-k+1}\prod_{j\notin S}y_j.       \tag{4}
\]
The Euler coefficient in the second identity is
\((|S|-k)+(k-1-|S|)=-1=1\) in \(\mathbb F_2\), including
negative Laurent exponents. For each square-free \(y\)-monomial,
the two exponents in (4) have opposite parity. Consequently the
\(2^k\) orbit elements in (4) are an \(R\)-basis of \(L\).
In particular
\[
 E_k\otimes_{\mathbb F_2}R \longrightarrow L,\qquad
 q_T\otimes r\longmapsto r q_Tv_0
 \tag{5}
\]
is an \(E_k\)-module isomorphism. It is also homogeneous after the
shift \(|v_0|=-\sum_{i<k}|q_i|\).

This proves actual freeness over \(E_k\), rather than merely
assuming that localization preserves projectivity. It independently
verifies the projectivity assertion used in the manuscript. The
manuscript's displayed section has the same valid interpretation:
the free module carries the regular action on its first factor.

## 3. Uniform exponent-support theorem

**Theorem.** For every \(k\geq1\), \(n\geq0\), and \(s>0\), the
homology computing \(\operatorname{Tor}^{E_k}_s(\mathbb F_2,t^nD)\)
is canonically represented by the cycles whose coefficient
\(t\)-exponent is exactly \(n\). There are no boundaries at that
exponent and every cycle supported at exponents greater than \(n\)
is a boundary. For \(\Sigma^nt^nD\), this Tor group is concentrated
in internal degrees congruent to \(s\) modulo two.
The theorem does **not** require \(n\equiv k\pmod2\).

**Proof.** Tensor the one-generator periodic resolutions. In
homological degree \(s\) the basis is indexed by
\(\alpha\in\mathbb N^k\), \(\sum\alpha_i=s\), and
\[
 d(e_\alpha\otimes f)
   =\sum_{\alpha_i>0}e_{\alpha-e_i}\otimes D_i f.       \tag{6}
\]
For one generator, exactness of the augmented periodic resolution
is immediate: the kernel and image of multiplication by \(q_i\)
are both the span of \(q_i\). Tensoring these augmented resolutions
over the field preserves exactness (their vector-space
contractions can be tensored), and their terms are free over
\(E_k\). Thus (6) really computes Tor in every degree.
There is no factor \(\alpha_i\) in this differential. Thus it is
the divided-power/periodic resolution, not the ordinary polynomial
derivative complex. Every nonzero monomial term of (6) raises
the coefficient \(t\)-exponent by **exactly one**.

The complex with coefficients in \(L\) is exact in positive
homological degrees by (5). For a cycle \(z\) with exponents
\(\geq n+1\), choose any finite Laurent filling \(y\) with \(dy=z\).
Let \(y_{\geq n}\) discard all coefficient monomials below \(n\).
The strict exponent shift gives the identity
\[
 d(y_{\geq n})=(dy)_{\geq n+1}=z.                    \tag{7}
\]
This proves the claimed filling inside \(t^nD\).

For an arbitrary cycle, split off its coefficient-exponent-\(n\)
part. Since (6) shifts each exponent by one, both that part and
the remaining part are cycles separately. The remaining part is
a boundary by (7). No boundary has coefficient exponent \(n\),
because every coefficient before differentiation has exponent at
least \(n\). This proves the asserted canonical identification.

Finally a coefficient at the floor in \(\Sigma^nt^nD\) has even
degree: its parity is \(n+n\). Each resolution generator contributes
an odd degree, so a homological-degree-\(s\) basis element has
internal degree \(s\) modulo two. This proves the parity assertion.
\(\square\)

In addition, multiplication by \(t^2\), which is \(E_k\)-linear,
annihilates every positive Tor group in this theorem: it carries
each floor representative strictly above the floor, where the
class is zero. This is an unbounded algebraic consequence, not a
finite-search observation.

The exponent shift in this proof is asserted only for the first
\(k\) primitives. Later primitives need not shift the exponent by
exactly one. Applying truncation directly to the full infinite
primitive complex would be an unjustified shortcut.

## 4. Replacement of later primitives in the balanced tensor

Let \(z=\sum_i q_i\otimes z_i\) be an even-degree cycle in
\(I_E\otimes_EM\). All its coefficients have odd degree in \(M\).
Because \(n\equiv k\), their \(t\)-exponents are opposite to \(k\),
and are at least \(n+1\). By (3), each \(z_i\) belongs to \(I_EM\).
This assertion holds for sums, not just for individual monomials.

Write \(q_i=\sum_{j<k}b_{ij}q_j\) on \(M\). On a hit \(q_sy\),
the full degree-two balancing relations give
\[
\begin{aligned}
 q_i\otimes q_sy
 &=q_s\otimes q_iy\\
 &=\sum_{j<k}q_s\otimes b_{ij}q_jy\\
 &=\sum_{j<k}q_j\otimes b_{ij}q_sy .
\end{aligned}                                                    \tag{8}
\]
The middle interchange is valid because \(q_jb_{ij}=0\);
all intermediate coefficients remain in \(M\). Linearity proves
(8) on \(I_EM\). It is not being asserted on arbitrary
coefficients.

After replacement the coefficients still have exponent at least
\(n+1\), and the action remains zero. Hence the representative is a
cycle in the first-\(k\) complex. The theorem in Section 3 with
\(s=1\) makes it a boundary already over \(E_k\), so its image in
\(I_E\otimes_EM\) is zero. Therefore
\[
 \operatorname{Tor}^{E}_1(\mathbb F_2,M)_{\mathrm{even}}=0.
 \tag{9}
\]

The first two differentials really present the balanced tensor:
the relations are \(e_iq_i y\) and
\(e_iq_jy+e_jq_iy\) for \(i<j\). Omitting the repeated pairs or
testing separate \(q_i\)'s would not prove (9).

## 5. Projection to the Steenrod quotient

From the polynomial dual description, the annihilator of \(I_EA\)
is the square subalgebra of \(A_*\): in the restricted coaction,
the coefficients of the single exterior dual generators are the
ordinary partial derivatives. They vanish simultaneously exactly
on squares. Dualizing the Frobenius map gives
\(V(\operatorname{Sq}^{2a})=\operatorname{Sq}^a\) and
\(V(\operatorname{Sq}^{2a+1})=0\), so \(\ker V=I_EA\).
Conjugation gives \(AI_E=I_EA\). Thus \(KM=I_EM\).

Right exactness gives
\[
 K\otimes_AM\longrightarrow I_A\otimes_AM
 \longrightarrow I_{A/K}\otimes_{A/K}(M/I_EM)\longrightarrow0.
\]
Multiplication \(I_E\otimes_EA\to K\) is onto, and hence so is
\(I_E\otimes_EM\to K\otimes_AM\). A homogeneous even-degree
cycle in the projection kernel therefore lifts to an even-degree
cycle in \(I_E\otimes_EM\): the action maps to the *same* \(M\)
commute, so its action is zero, not merely zero modulo \(I_EM\).
Equation (9) makes this preimage zero. Its image is zero as well.
This proves precisely `lem:tor-injection`, including its application
domain \(n>0\) and its boundary case \(n=0\).

No repair of this particular manuscript implication is necessary.
The injection supplies the nonvanishing-preservation step used in
`lem:algebra-even-vanishing`; it does not verify that lemma's other
steps, functional halving, the geometric inputs, or Curtis's conjecture.

## Certification boundary

`Main.lean` and `statement_fidelity.md` describe the general finite
Laurent-support filling theorem underlying (7). The kernel checks
this uniform statement for arbitrary coefficient modules and every
integer floor. The existence of Laurent fillings in the Dickson
application is supplied by the explicit human proof (4)--(6), not
silently assumed to have been formalized.

The official Lean 4.31.0 run succeeded with compiler exit code 0,
axiom-audit exit code 0, and `proof_holes=[]`. Its archived certificate is
`lean_evidence/certificates/C316_TRUNCATION-2db17c0a3e80028e.json`.
The ledger derives `closed_kernel` for **C316_TRUNCATION only**.
The full injection and Laurent free-basis proof remain human proofs
awaiting independent review. Two preceding elaboration failures are
retained as superseded, inconclusive evidence; neither counted as
support.

`verify.py` and `exact_certificate.json` replay 94 polynomial-action
equalities, 189 complete even-degree components of the **all-primitives**
Tor-one complex, and 450 components of the first-\(k\) floor-support
theorem in homological degrees 1, 2, and 3. Every primitive and
degree-two relation that fits the component's total degree is
included. Each computed kernel basis is filled using the complete
relation matrix; this is stronger than merely comparing ranks.
The first-\(k\) checks include both parities of \(n\), as the stronger
theorem permits. The script also checks that the current Lean source
and fidelity document match the successful compiler certificate.
These finite computations are regression evidence only; the
all-\(k,n\) conclusion rests on the proof above and the formal
support theorem.

For a concrete mixed-cycle example take \(k=n=2\), total degree 18,
and write \(t=d_0,y=d_1\). In order the degree-one basis is
\[
 q_0\otimes t^3y^3,\quad q_0\otimes t^5,\quad
 q_1\otimes t^3y^2,\quad q_2\otimes t^3.
\]
The action columns, in the coefficient basis
\((t^2y^5,t^4y^2)\), are \((2,0,2,2)\) when encoded by binary
row supports. The seven degree-two columns, in the displayed
degree-one basis, are
\[
 (0,\ 2,\ 5,\ 0,\ 11,\ 0,\ 0).
\]
In order, their coefficient labels are
\((00,t^2y^4),(00,t^4y),(01,t^2y^3),(01,t^4),
(02,t^2y),(11,t^2y^2),(12,t^2)\).
Their rank is 3. The kernel basis has binary supports \(2,5,9\),
with filling-column supports \(\{1\},\{2\},\{1,4\}\), respectively
(indices start at zero). In particular this checks a mixed
\(q_0,q_2\) cycle, not just individual monomials. The certificate
contains the full ordered bases and all these vectors.

As a nonvanishing control, \(q_0\otimes t^2\) at \(k=n=2\),
degree **9**, is an all-primitives Tor-one cycle. Its degree-two
space is zero and evaluation on its sole coordinate separates
it from boundaries. This is a genuine odd-degree class over \(E\),
not a counterexample to the even-degree assertion and not a
claim about its image in Tor over \(A\).

Jacobian discovery offered bounded finite-field rank/nullspace
operations and unrelated Lie-algebra homology, not an unbounded
Dickson-module Tor solver. After inspecting its typed contract,
one bounded operation, `prime_field.matrix.rank.compute`, was
used on precisely the \(4\)-by-\(7\) relation matrix above.
Jacobian 0.14.0, MCP protocol `2025-11-25`, returned rank 3,
adapter exit code 0, no timeout, and complete typed output.
`jacobian_payload.json`, `jacobian_result.json`, and
`jacobian_status.json` preserve its exact input, output, provenance,
and status. This agreement is not substituted for the uniform proof.

To replay the exact certificate from the campaign root:

```sh
python3 research/tor_injection/verify.py
```

To obtain a new genuine compiler certificate, use the installed CLI's
positional source argument (its inspected contract has no `--source`
option):

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m \
  argus_skill.verticals.math.lean_evidence verify \
  research/tor_injection/Main.lean --project-root . \
  --claim C316_TRUNCATION \
  --statement-fidelity research/tor_injection/statement_fidelity.md \
  --artifact-dir research/tor_injection/lean_evidence
```

The primary Milnor paper was obtained and its Appendix 1 (printed
p. 171) and Theorem 3 (printed p. 162) opened. A separate reader
must still attribute the ledger's `MILNOR_DUAL` citation. The
Engineer does not self-clear that citation or the statement-fidelity
review. The report makes no `verified_new` or publishable-significance
claim; the campaign remains open until the required independent
Reviewer and novelty/significance gates are satisfied.
