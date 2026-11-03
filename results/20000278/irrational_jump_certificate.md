# An irrational full-big-test-ideal jump in characteristic 13

## Statement and review status

Keep exactly the field, cover, polarization, graded ring, and local ring in
`irrational_jump_candidate.md`, Section 2:
\[
\begin{gathered}
 k=\mathbb F_{13}(u,v,w,z),\qquad
 E:\ y^2=x(x-1)(x-u),\quad X=E\times E,\\
 M=3(f_1+f_2),\qquad L=6f_1+3f_2+6\delta,\\
 W=\operatorname{Spec}_X(\mathcal O_X\oplus\mathcal O_X(-M)),
 \qquad \xi^2=x_1^3x_2^3+v x_1^3+w x_2^3+z,\\
 A=3f^*L,\qquad S=\bigoplus_{j\geq0}H^0(W,jA),\quad
 \mathfrak n=S_+,\qquad R=S_{\mathfrak n},\quad
 \mathfrak m=\mathfrak nR .
\end{gathered}
\]
Write
\[
 \theta=\frac{7+\sqrt{17}}{48},\quad \kappa=1-\theta,\quad
 r=1116,\quad d=r+2=1118,\quad
 \lambda=r+\kappa=\frac{53609-\sqrt{17}}{48}.
\]

**Submitted theorem.** This fixed \(R\) is an F-finite normal
non-Q-Gorenstein local domain essentially of finite type over the F-finite
field \(k\). Its nonzero maximal ideal satisfies
\[
 \tau_b(R;\mathfrak m^\lambda)\subseteq\mathfrak m^{1118},
 \qquad
 \tau_b(R;\mathfrak m^{\lambda-\epsilon})
                  \not\subseteq\mathfrak m^{1118}
       \quad(0<\epsilon<1/2).
                                                        \tag{T}
\]
Consequently \(\lambda\) is an irrational F-jumping number for the **full
intrinsic** big test ideal.

**Final project submission; final certification pending.** This is the
existing exact certificate for the rationality branch of the exploratory
counterexample objective. The independent complete-candidate review in
mission `79bbb02d7092` accepted (T), its geometric prerequisites, and the
full-big-test-ideal implication. Section 8 identifies that verdict and
the earlier accepted components; no earlier conditional verdict is
extended beyond its actual scope.

The mathematical argument in Sections 1-7, the frozen candidate
definition, and the two companion proofs are unchanged. Final
project-level acceptance still belongs to the Host-invoked independent
Reviewer. This submission claims neither nondiscreteness nor novelty,
and is a mathematical certificate, not a formal-kernel proof.

## 1. Geometric facts actually supplied

`candidate_geometry_certificate.md` proves the following facts for these
actual objects, with primary-source statements and explicit derivations.

| Fact used here | Location in the geometric proof |
|---|---|
| The stated branch section is geometrically smooth and nonempty, also over infinity; \(W\) is smooth and geometrically integral; \(K_W\sim f^*M\). | Section 3 |
| On the span of \(f_1,f_2,\delta\), pseudo-effectivity is equivalent to positive semidefiniteness of the displayed matrix. No endomorphism-specialization assumption is needed. | Section 4 |
| The **specified third Veronese** is normal and generated in degree one; \(A\) is very ample; \(R\) is three-dimensional and F-finite; \(\mu(\mathfrak m)=1116\). | Section 5 |
| The global vertex blowup is \(Y=\operatorname{Tot}\mathcal O_W(-A)\), with zero section \(G\), and the blowup over \(\operatorname{Spec}R\) is its regular base change. The vertex ring itself is not Q-Gorenstein. | Section 6 |
| \(\inf\{t:tA-K_W\text{ is pseudo-effective}\}=\theta\); above \(\theta\) the class is ample. | Section 7 |
| For every prescribed rational \(s=h/q>\theta\), \(13\nmid q\), the prescribed \(m_s=q\ell\) is prime to 13 and yields the required smooth auxiliary divisor **over \(k\)**, SNC strict transform, and principal multiple of \(K_C+\Gamma_s\). | Section 8 |

In particular, for the bundle projection \(\rho:Y\to W\),
\[
 \mathfrak n\mathcal O_Y=\mathcal O_Y(-G),\quad
 G|_G\sim-A,\quad K_Y|_G\sim K_W+A.
                                                        \tag{1.1}
\]
Here and below restrictions of Q-Cartier divisors mean restrictions of
their line-bundle classes after clearing denominators.

Let \(v_G\) be the discrete valuation at the generic point of \(G\).
For a nonzero element of \(S\), its value is its least nonzero homogeneous
degree: on a bundle chart a degree-\(j\) section has fibre order \(j\),
and its nonzero leading coefficient does not vanish at the generic
point of \(W\). A denominator outside \(\mathfrak n\) has value zero.
Standard grading therefore gives, for every integer \(j\geq0\),
\[
 \{a\in S:v_G(a)\geq j\}=\mathfrak n^j,\qquad
 I_j:=\{a\in R:v_G(a)\geq j\}=\mathfrak m^j.              \tag{1.2}
\]
These ideals are nonzero. No equality between ordinary and symbolic
powers on an arbitrary singularity is being assumed.

## 2. Every boundary has the required exceptional coefficient

First work either over the global cone \(C=\operatorname{Spec}S\) or
over its vertex localization. Let \(\Gamma\geq0\) be **any** Q-divisor
with \(D=K_C+\Gamma\) Q-Cartier near the vertex. Write on the regular
blowup, near \(G\),
\[
             \pi^*D=K_Y+\Gamma_Y+k_\Gamma G.              \tag{2.1}
\]
The strict transform \(\Gamma_Y\) is effective and has no component
equal to \(G\). Nothing says that it is homogeneous or SNC.

Because \(Y\) is regular, an integral multiple of \(\Gamma_Y\) is an
effective Cartier divisor. Its defining section restricts nontrivially
to the integral \(G\), since it does not vanish at the generic point of
\(G\). Thus \(\Gamma_Y|_G\) is an effective Q-Cartier divisor on \(G\),
even when the intersection is nonreduced or singular.

An invertible multiple of \(D\) pulls back trivially to \(G\): the map
from \(G\) to the base factors through the \(k\)-rational vertex.
Restricting (2.1), using (1.1), gives
\[
          (k_\Gamma-1)A-K_W\sim_{\mathbb Q}\Gamma_Y|_G.
                                                        \tag{2.2}
\]
The right side is effective, hence pseudo-effective. By the threshold
already computed for \(W,A\),
\[
                         k_\Gamma\geq1+\theta.           \tag{2.3}
\]
This is a proof of the coefficient assertion for **all** boundaries,
including boundaries defined only on the local scheme. It is the
restriction argument of Ajit, arXiv:2605.26354v1, Lemma 4.10, with its
effectivity and localization steps made explicit. That lemma need not
be assumed separately.

## 3. Intrinsic endpoint exclusion: all Cartier maps at once

### 3.1. The divisor of an arbitrary map on the birational DVR

The precise external input is Schwede, *F-adjunction*,
**arXiv:0901.1154v4**, Section 3's introductory construction,
Lemma 3.1, Remark 3.3, and Theorem **3.11(a)-(c)** with its proof.
The original PDF and text are retained in
`../evidence/literature/0901.1154v4.{pdf,txt}`.
In this version the map-divisor theorem is 3.11.

For \(Q=13^e\), \(e>0\), let
\(\phi\in\operatorname{Hom}_R(F_*^eR,R)\) be nonzero.
That construction associates an effective Q-divisor \(\Delta_\phi\)
such that \((Q-1)\Delta_\phi\) is integral and
\((Q-1)(K_R+\Delta_\phi)\) is Cartier. Over the local ring it is
principal. The construction uses the rational identification
\[
 \operatorname{Hom}(F_*^e\mathcal O,\mathcal O)
                   \simeq F_*^e\mathcal O((1-Q)K).
                                                        \tag{3.1}
\]
These identifications may be chosen compatibly on the common function
field and on regular charts. Remark 3.3 supplies the required
\((F^e)^!\omega\simeq\omega\) for schemes essentially of finite type
over the F-finite field. A choice of Frobenius dual functional on the
coefficient field is allowed; it is not the inseparable field trace.

For explicit bookkeeping, let \(c\) be the rational coefficient of
\(\phi\) in (3.1). Then
\[
 (Q-1)\Delta_\phi=\operatorname{div}_R(c)+(1-Q)K_R,
 \quad
 (Q-1)(K_R+\Delta_\phi)=\operatorname{div}_R(c).           \tag{3.2}
\]
On \(Y\) the same rational map has divisor
\[
 \operatorname{div}_Y(c)+(1-Q)K_Y
    =(Q-1)\big(\pi^*(K_R+\Delta_\phi)-K_Y\big).
                                                        \tag{3.3}
\]
This identity also proves the birational transformation rule being
used; no extension of a map across an arbitrary singular model is
presupposed.

Let \(V=\mathcal O_{Y,\eta_G}\), a regular F-finite DVR, and let \(z_G\)
be its uniformizer. Write \(k_\phi\) for the coefficient of \(G\) in
\(\pi^*(K_R+\Delta_\phi)-K_Y\).
Frobenius duality on \(V\) makes
\(\operatorname{Hom}_V(F_*^e V,V)\) free of rank one over \(F_*^eV\).
Choose a generator \(\Psi_e\). The localized rational map is
\[
        \phi(x)=\Psi_e(F_*^e(a_\phi x)),\qquad
        v_G(a_\phi)=(Q-1)k_\phi.                         \tag{3.4}
\]
Indeed, replacing the rational canonical representative in (3.1) by a
local generator subtracts \((Q-1)\operatorname{coeff}_G K_Y\) from
\(v_G(c)\), exactly as in (3.3).
An additional unit changes no valuation. The value in (3.4) is integral.
Applying Section 2 to \(\Delta_\phi\) gives
\[
                 k_\phi\geq1+\theta,\qquad a_\phi\in V.
                                                        \tag{3.5}
\]
In particular this specific map extends to an integral map on \(V\).
There was no restriction to homogeneous maps, a single exponent, or
a finitely generated Cartier subalgebra.

### 3.2. Compatibility of the fixed ordinary power

Set \(I_d=\mathfrak m^{1118}\). Let
\[
                 x\in\mathfrak m^{\lceil\lambda(Q-1)\rceil}I_d.
\]
By (1.2), (3.4), and (3.5),
\[
 \begin{split}
 v_G(a_\phi x)
 &\geq (Q-1)k_\phi+\lceil\lambda(Q-1)\rceil+d\\
 &\geq (Q-1)(1+\theta+\lambda)+d
       =(Q-1)d+d=Qd.                                    \tag{3.6}
 \end{split}
\]
The equality uses the **exact** identity
\(\lambda+1+\theta=r+2=d\).
Thus \(a_\phi x=z_G^{Qd}y\) for some \(y\in V\). Linearity of the
Cartier map, with its Frobenius module structure, gives
\[
                 \phi(x)=z_G^d\Psi_e(F_*^e y)\in z_G^dV.
                                                        \tag{3.7}
\]
Also \(\phi(x)\in R\), since \(x\in R\). Hence \(\phi(x)\in I_d\).
The zero map has the same compatibility trivially. Equations
(3.6)-(3.7) hold for every \(e>0\) and **every**
\(\phi\in\operatorname{Hom}_R(F_*^eR,R)\).

The intrinsic big test ideal is the smallest nonzero ideal with exactly
this compatibility. Since \(I_d\ne0\), it follows that
\[
                \boxed{\tau_b(R;\mathfrak m^\lambda)
                                     \subseteq\mathfrak m^{1118}.}
                                                        \tag{3.8}
\]
Every boundary Cartier map restricts to one of these intrinsic maps.
Consequently \(I_d\) is compatible for every boundary as well, and
minimality of its test ideal gives
\[
             \tau(R,\Gamma;\mathfrak m^\lambda)\subseteq I_d
                                                        \tag{3.9}
\]
for **each** summand in the full boundary sum. Thus no summand is omitted
from the endpoint exclusion.

The same argument holds globally on \(S\): (3.1)-(3.3) are available
for this finite-type ring, and (1.2) identifies the global valuation
ideal with \(\mathfrak n^d\). Alternatively, restrict each global map
to \(R\), apply (3.7), and contract using
\(\mathfrak n^dR\cap S=\mathfrak n^d\). This proves
\[
       \tau_b(S;\mathfrak n^\lambda)\subseteq\mathfrak n^{1118},
 \qquad \tau(S,\Gamma;\mathfrak n^\lambda)
                                      \subseteq\mathfrak n^{1118}.
                                                        \tag{3.10}
\]
No comparison with multiplier ideals, resolution of arbitrary boundary
support, or asymptotic boundary cutoff is used in this section.

## 4. Full-big correspondence, localization, and monotonicity

The definitions here are precisely those in Schwede,
**arXiv:0906.4313v2**, Definitions 3.15-3.16, and Schwede--Tucker,
**arXiv:1212.6956v1**, Definition 3.4. A boundary uses
\[
 \operatorname{Hom}_S
   \big(F_*^e S(\lceil(13^e-1)\Gamma\rceil),S\big)
\]
and the ideal power \(\mathfrak n^{\lceil t(13^e-1)\rceil}\);
the intrinsic algebra uses all maps \(F_*^eS\to S\).
Normal domains make the source's nondegeneracy condition automatic
for a nonzero map, and the nonzero ideal \(\mathfrak n\) meets
\(S^\circ=S\setminus\{0\}\).

Schwede **Corollary 5.2 in v2** therefore applies to both \(S\) and \(R\):
\[
           \tau_b(S;\mathfrak n^t)
                  =\sum_{\Gamma}\tau(S,\Gamma;\mathfrak n^t),
                                                        \tag{4.1}
\]
with all effective prime-to-13-index Q-Cartier boundaries in the sum.
The analogous equality holds on \(R\). A finite boundary set uniform in
\(t\) is neither asserted nor needed.

Schwede **Proposition 3.23(ii)**, including its proof by localization of
a homogeneous test element, applies to the full and boundary Cartier
algebras. Finite Frobenius and its finite Hom modules commute with
localization. Thus, putting \(\Gamma_R=\Gamma|_{\operatorname{Spec}R}\),
\[
 \begin{split}
 \tau_b(S;\mathfrak n^t)R&=\tau_b(R;\mathfrak m^t),\\
 \tau(S,\Gamma;\mathfrak n^t)R
                         &=\tau(R,\Gamma_R;\mathfrak m^t).
 \end{split}                                               \tag{4.2}
\]
The boundary algebra localizes component by component, including its
rounded Weil-divisor module. This supplies the previously uncited
localization input, rather than invoking only the phrase "localizing
does not change anything."

Monotonicity also follows directly from compatibility: if \(t_2\geq t_1\),
the required input ideals at \(t_2\) are smaller, so the test ideal at
\(t_1\) is compatible at \(t_2\). Minimality gives
\[
                  \tau_b(R;\mathfrak m^{t_2})
                        \subseteq\tau_b(R;\mathfrak m^{t_1}).
                                                        \tag{4.3}
\]

## 5. Skoda for the full big ideal, with the actual generator count

Here is a derivation that does not assume smoothness or
Q-Gorensteinness of the underlying ring.
For a fixed log-Q-Gorenstein triple and fixed real \(t\geq r\),
use Schwede--Tucker **arXiv:1212.6956v1**, proof of Proposition 3.6,
equations **(3.6.1)-(3.6.3)**. For a sufficiently large effective Cartier
divisor \(B\) and sufficiently large \(e_0\), its formula is
\[
 \tau(R,\Gamma;\mathfrak m^t)
   =\sum_{e\geq e_0}\operatorname{Tr}^e
       F_*^e\big(\mathfrak m^{\lceil t13^e\rceil}L_e\big),
 \quad
 L_e=R\big(\lceil K_R-13^e(K_R+\Gamma)\rceil-B\big).
                                                        \tag{5.1}
\]
The same \(B\) and \(e_0\) may be used at \(t-1\): enlarge the two
allowed divisors to a common Cartier divisor and increase \(e_0\).
The source explicitly allows enlarging \(B\). The factors \(L_e\)
then coincide for the two exponents.

Let \(x_1,\ldots,x_r\) generate \(\mathfrak m\), and let \(Q=13^e\).
For every integer \(N>r(Q-1)\), every degree-\(N\) monomial in these
generators has a factor \(x_i^Q\). Therefore
\[
             \mathfrak m^N
                     =\mathfrak m^{[Q]}\mathfrak m^{N-Q}.
                                                        \tag{5.2}
\]
This is an ideal identity even when the generators satisfy relations.
For \(N=\lceil tQ\rceil\), \(t\geq r\), we have
\(N\geq rQ>r(Q-1)\) and
\(N-Q=\lceil(t-1)Q\rceil\). Substitute (5.2) into each summand of
(5.1). The trace projection formula
\(\operatorname{Tr}^e(F_*^e(x_i^Qy))=
x_i\operatorname{Tr}^e(F_*^e y)\) gives
\[
       \tau(R,\Gamma;\mathfrak m^t)
                    =\mathfrak m\,\tau(R,\Gamma;\mathfrak m^{t-1}).
                                                        \tag{5.3}
\]
Sum (5.3) over the **same full set** of boundaries in (4.1);
multiplication of ideals distributes over this sum. We obtain
\[
         \boxed{\tau_b(R;\mathfrak m^t)
                     =\mathfrak m\,\tau_b(R;\mathfrak m^{t-1})
                             \quad(t\geq1116).}          \tag{5.4}
\]
This uses no cancellation of powers and no equivalence between jumps
under integer translation. The identical reasoning works on \(S\).

## 6. The accepted lower proof now has its geometric hypotheses

Fix any real \(0<\epsilon<1/2\). Choose an integer \(q>2/\epsilon\)
prime to 13, and put
\[
 h=\lceil q\theta\rceil,\qquad s=h/q,\qquad
 \alpha=1-(h+1)/q.
\]
The retained exact arithmetic gives
\[
 \theta<s<\theta+1/q,\quad
 \kappa-\epsilon<\alpha<\kappa,\quad 0<\alpha<1,\quad
 \alpha+s+1=2-1/q.                                      \tag{6.1}
\]
Section 8 of the geometric certificate supplies the prescribed
\(\ell\), \(m_s=q\ell\), and a smooth \(H_s\) over \(k\), with
\[
 m_s(K_C+\Gamma_s)\text{ principal},\quad 13\nmid m_s,\quad
 \pi^*(K_C+\Gamma_s)=K_Y+\rho^*(H_s/m_s)+(s+1)G.           \tag{6.2}
\]
Its SNC and index assertions are now proved for this construction;
they are not imposed on arbitrary boundaries.
Taking \(c=\varphi(m_s)\) gives \(m_s\mid13^c-1\), including the
denominator of \(\alpha\).

The conditional map-level proof in `trace_lower_bound.md` therefore
applies with all of its geometric hypotheses discharged.
Keep exactly its boundary-dependent integer
\[
 b_\alpha=\text{the finite Serre cutoff for its fixed }K_\alpha,
 \qquad N=\max(0,b_\alpha-r).
\]
No numerical or uniform replacement is demanded. Its conclusion is
\[
 \tau(S,\Gamma_s;\mathfrak n^{r+N+\alpha})
                           =\mathfrak n^{r+N+1}.         \tag{6.3}
\]
All Frobenius exponents in that proof remain on its specified
progression; the integrality and vanishing quantifiers are unchanged.

In particular its explicit nonzero class is
\(\sigma^{r+N+1}\), where \(\sigma=1\in H^0(W,A)\) is the canonical
section of the **effective divisor \(A\)**, regarded in degree one,
not as the scalar unit in degree zero. It is outside
\(\mathfrak n^{r+N+2}\), and remains outside after localization by
(1.2). Equations (4.1)-(4.2) and (6.3) therefore give
\[
        \tau_b(R;\mathfrak m^{r+N+\alpha})
                              \not\subseteq\mathfrak m^{r+N+2}.
                                                        \tag{6.4}
\]

## 7. Every-epsilon strictness at the fixed irrational exponent

This is the previously reviewed descent, now using the actual inputs.
Suppose that
\(\tau_b(R;\mathfrak m^{\lambda-\epsilon})\subseteq\mathfrak m^{r+2}\).
Since \(r+\alpha>\lambda-\epsilon\), monotonicity gives
\(\tau_b(R;\mathfrak m^{r+\alpha})\subseteq\mathfrak m^{r+2}\).
Iterate (5.4) \(N\) times; all exponents exceed \(r\). It follows that
\[
       \tau_b(R;\mathfrak m^{r+N+\alpha})
          =\mathfrak m^N\tau_b(R;\mathfrak m^{r+\alpha})
          \subseteq\mathfrak m^{r+N+2},
\]
contradicting (6.4). Thus the second assertion in (T) holds for each
\(\epsilon\) in the entire stated interval. With (3.8) and monotonicity,
\[
       \tau_b(R;\mathfrak m^{\lambda-\epsilon})
              \supsetneq\tau_b(R;\mathfrak m^\lambda)
                     \qquad(0<\epsilon<1/2).             \tag{7.1}
\]
The nonsquare \(17\) makes \(\lambda\) irrational. The field, ring,
ideal, and \(\lambda\) never depend on \(\epsilon\). Only the
auxiliary boundary and the finite Serre cutoff do.

## 8. Exact dependencies and scope of replay

The mathematical certificate consists of this implication together with
the geometric derivations in `candidate_geometry_certificate.md` and
the retained, independently reviewed `trace_lower_bound.md`.
The original candidate note fixes the objects and contains the
already reviewed descent; its historical open-status paragraphs are
not substituted for this submission.

All numerical facts used are the retained exact quadratic-root and
intersection calculations, not new sampling. The retained Jacobian catalog
discovery in `../evidence/jacobian/endpoint-operations.json` found no
operation for Cartier-map compatibility, test ideals, or these
geometric implications. Its three word matches concern rational
canonical forms, numerical-semigroup Frobenius numbers, and Galois
Frobenius cycle types. None was forced onto this claim, and the
unchanged prior arithmetic operation was not rerun.

The external propositions are named where used and in the
mathematical ledger. Their complete primary documents are retained
locally. In particular this proof does **not** depend on Ajit's
all-boundary multiplier comparison, an End-specialization argument,
or an independently unverified numerical Serre bound.

The accepted handoffs distinguish the three mathematical scopes:

| Reviewed mission | Accepted mathematical content | Retained proof |
|---|---|---|
| `136a6d66174d` | The fixed construction, exact arithmetic, source-aligned definitions, and conditional Skoda descent; no complete counterexample at that stage. | `irrational_jump_candidate.md`; `../evidence/reviewer/theta-replay.json` |
| `a059189d6e84` | The conditional map-level lower argument, including every required Frobenius twist and the boundary-dependent Serre cutoff; not the geometric prerequisites or endpoint. | `trace_lower_bound.md` |
| `79bbb02d7092` | The complete frozen-ring certificate: geometric and auxiliary-boundary hypotheses, every-Cartier-map endpoint exclusion, localization, full-big Skoda, and strictness for every \(0<\epsilon<1/2\). | `candidate_geometry_certificate.md` and Sections 1-7 above, together with the retained lower proof |

Each mission's `round-0001.json` is the Host's
`round_reviewed_handoff`, with `producer_role=reviewer` and
`review.status=done`, under
`/home/argustest/zimo/.argus-campaign-20000278/projects/76ca6ac33ef0/handoffs/`.
The complete-candidate verdict is also recorded in
`../roles/reviewer/progress.json` at `2026-09-05T10:37:54Z`.
Its artifact-specific supporting judgements are in `MATH_STATE.json`.
The earlier notes' open-status paragraphs describe their earlier
submissions, not additional unresolved hypotheses of (T).

All nineteen active source attributions have independent supporting
verdicts in the ledger, including the fourteen completed with the
complete-candidate review. Their archived passages and original
documents remain in `../evidence/reviewer/`,
`../evidence/literature/`, and `literature/`. In particular, the formerly
pending geometry, Cartier-map correspondence, localization, and trace
sum attributions are not still awaiting an initial reading. This
submission reuses those readings; it does not file author approvals.

The retained exact arithmetic operation is
`algebraic_number.compare`. Its inspected contract, payload, typed
output, and execution metadata are
`../evidence/jacobian/algebraic-number-compare.contract.json` and the
`../evidence/jacobian/theta-less-than-quarter.{payload,output,run}.json`
files; `../evidence/reviewer/theta-replay.json` records the independent
replay. This operation certifies only the stated quadratic-root
comparison, not a test-ideal jump. Replay of (T) is the exact
mathematical argument in Sections 1-7 and the two companion proofs,
with the retained primary-source propositions. It is not a finite
test-ideal computation, and it does not require a numerical or
epsilon-uniform replacement for \(b_\alpha\).

For known-result context, the independent complete-candidate review
read the abstract and Theorem 2 of Ajit,
**arXiv:2605.26354v1**, which already asserts irrational full-big
F-jumps by this cone strategy. The present submission is the fixed
explicit specialization above, not a claim of new-result priority or
endorsement of every stronger assertion in that preprint.

The remaining decision is final project-level independent certification
that this same eligible non-Q-Gorenstein ring and ideal satisfy (T) and
that the retained certificate is independently replayable. Earlier
bounded acceptance and structural checks do not issue that verdict.
No mathematical dependency is reopened absent a concrete conflict in
the final review.
