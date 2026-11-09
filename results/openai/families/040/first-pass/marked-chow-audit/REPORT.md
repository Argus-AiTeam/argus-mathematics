# Arbitrary-length retained-output Chow verification

## Result and its exact scope

**The bridge in Lemma `rel:marked-reduction` and Proposition
`prop:universal` is valid**, with the stated *chosen formal* diagonal
coefficient. The proof below applies to every pair of nonnegative point
lengths, not just length two. It uses standard geometric theorems listed
in `sources.md`. No false assertion in the assigned bridge has been
established. Consequently this work does not manufacture an `F_` claim.

This is a mathematical proof with an executable exact-algebra replay,
not a kernel formalization of Chow theory. Independent Host Reviewer
acceptance is pending. In particular, it does not verify the manuscript's
based-determinant obstruction theory, the auxiliary fixed virtual
multiplicities, either positivity branch, or Bloch's conjecture.

The strongest prior result in this campaign was the untested objective.
The substantive advance is an arbitrary-length Chow proof, with an
explicit residual-point rule for **both ordered relative Ext classes**
and an implementation acting on the actual fiber expression. A prior
campaign's related Wiki argument is not treated as this manuscript's
certificate or as a novelty certification. The publishable research
target remains unchanged; novelty of this verification is not claimed.

## 1. Statement verified

Let \(X\) be a smooth connected projective complex surface and let
\(\chi(\mathcal O_X)=1\). Use precisely the notation, Euler convention,
ordered weights \(w_1=1/2,w_2=-1/2\), and coefficient extraction of
`relation.tex`. In particular, \(T,H,L_1,L_2\) are line classes,
\(D_1=T,D_2=H\), \(m_i=D_i(D_i-K)/2\), and
\[
 R_X=\mathbb Q[1,K,c_2(T_X),L_1,L_2,T,H]\subset CH^*(X)_{\mathbb Q}.
\]
For all \(n_1,n_2,p\geq0\), the literal expression
`rel:fiber-contribution` has a decomposition
\[
 C_*(T,H;n_1,n_2)=c_*[\Delta_X]+\Gamma_*,
 \qquad
 \Gamma_*\in\sum_{a+b=2}R_X^a\boxtimes R_X^b.                 \tag{1}
\]
There is a fixed constructive rule for \(c_*\), depending only on the
integer parameters, weights, \(\int_Xc_2(T_X)\), and
\(\int_XUV\) for the five listed line classes \(K,L_1,L_2,T,H\).
The rule gives zero when \(n_1=n_2=0\). Negative \(m_i\) mean zero,
as stipulated in the manuscript. Effectivity is unnecessary for (1);
it is required only to identify the expression with a geometric
localization contribution.

No assertion of uniqueness of \(c_*\) on an individual surface is
included. In particular, evaluating the total class on a rational
surface does not recover the selected coefficient.

## 2. External geometric inputs

We use the consecutive surface Hilbert scheme and its universal
sequence from EGL, arXiv:math/9904095v1, Section 1 and Lemma 1.1.
We also use rational Chow projection and flat-base-change formulas,
the projective bundle formula, regular-embedding self-intersection,
and Grothendieck--Riemann--Roch for proper maps between smooth
projective varieties and perfect complexes. Exact source boundaries
are recorded in `sources.md`; these are assumptions in the ledger,
not theorems proved by the executable.

Hilbert schemes and the consecutive nested schemes here are smooth
projective. Thus their coherent sheaves are perfect, Chow pullbacks
between them are defined, and proper perfect pushforward and derived
base change along the surface projections are available.

The foundational input is the full smooth-variety GRR theorem, not
the restricted locally-free-cohomology statement displayed at Stacks
Tag 02UO. The full statement was subsequently read in Vakil's
November 24, 2004 notes, Section 2; applying it additively to locally
free resolutions gives exactly the perfect-complex version needed here.

## 3. Residual pullback does not assume transversality

For \(r>0\), write \(N_r=X^{[r-1,r]}\),
\(\sigma=(\phi,\rho):N_r\to X^{[r-1]}\times X\), and
\(\mathcal L=\mathcal O_{N_r}(1)\), \(\zeta=c_1(\mathcal L)\).
The quotient-line convention is essential. The universal sequence is
\[
 0\longrightarrow(\psi\times1)^*\mathcal I_r
 \longrightarrow(\phi\times1)^*\mathcal I_{r-1}
 \longrightarrow j_*\mathcal L\longrightarrow0,             \tag{2}
\]
where \(j\) is the graph of \(\rho\).

Universal ideals are flat over their Hilbert base. Therefore the two
pullbacks in (2), obtained by changing that base while carrying along
the surface, have no higher Tor. **This does not say** that restriction
of an ideal to a residual point is underived. The latter is always
interpreted as a pullback of a perfect \(K\)-class. This distinction
matters at collisions and is preserved by the Ext rules below.

The graph \(j:N_r\to N_r\times X\) is a regular codimension-two
embedding with normal bundle \(\rho^*T_X\): it is a section of the
smooth surface projection. In the pullback of the diagonal by
\((\rho,1)\), the two diagonal equations cut out precisely this
regular graph. The Koszul resolution remains exact, so this square
is Tor independent even if \(\rho\) is not flat. With additional
surface slots the same argument applies after a smooth product.
Consequently graph classes are pullbacks of equality diagonals
between the residual slot and the relevant old slot. No avoidance
of the universal incidence locus is required.

GRR and derived duality give
\[
 \begin{split}
 \operatorname{ch}(j_*\mathcal L)
   &=j_*(e^\zeta\rho^*\operatorname{td}(T_X)^{-1}),\\
 (j_*\mathcal L)^\vee
   &=j_*(\mathcal L^{-1}\otimes\rho^*K^{-1})[-2],\\
 \operatorname{ch}_k(F^\vee)&=(-1)^k\operatorname{ch}_k(F).
 \end{split}                                                \tag{3}
\]
The even shift introduces no minus sign. On a surface,
\[
 \operatorname{td}(T_X)=1-\tfrac12K+\tfrac1{12}(K^2+c_2),
 \qquad
 \operatorname{td}(T_X)^{-1}
   =1+\tfrac12K+\tfrac1{12}(2K^2-c_2).                       \tag{4}
\]
These are complete surface expressions, not approximations controlled
by the Hilbert length.

## 4. The actual tautological and Ext classes obey the recursion

Let \(A_i(P)=P^{[n_i]}\) and retain the manuscript's
\[
 E_{ij}(P)=R\Gamma(P)-R\pi_*(\mathcal I_i^\vee\otimes^{\mathbf L}
                                      \mathcal I_j(P)).
\]
After lowering length \(i\) by one, denote the smaller classes by a
superscript minus. Projection formula applied to (2)--(3) gives
\[
 \begin{split}
 \psi^*A_i(P)
    &=A_i^-(P)+\mathcal L\otimes\rho^*P,\\
 \psi^*E_{ij}(P)
    &=E_{ij}^-(P)+
       \mathcal L^{-1}\otimes\rho^*(P-K)
                  \otimes^{\mathbf L}\mathcal I_j|_\rho,\\
 \psi^*E_{ji}(P)
    &=E_{ji}^-(P)+
       \mathcal L\otimes\rho^*P
                  \otimes^{\mathbf L}(\mathcal I_j^\vee)|_\rho .
 \end{split}                                                \tag{5}
\]
Here the notation means equality in perfect \(K\)-theory on the
nested scheme with all other factors carried along. Restriction
\(|_\rho\) is derived. In the second line the correction has
exponential twist \(-\zeta+P-K\); in the third it has
\(\zeta+P\) and a derived-dual ideal. Interchanging these two
formulas, deleting \(K\), or using a minus sign from the even
duality shift would be incorrect.

For an empty factor these identities specialize to
\[
 E_{i0}(P)=((K-P)^{[n_i]})^\vee,\qquad
 E_{0j}(P)=P^{[n_j]}.                                      \tag{6}
\]
The program implements (2)--(6), not a guessed incidence graph.

Alternatively, to put the *entire* integrand directly in the statement
of `rel:marked-reduction`, smooth-projection GRR gives exactly
\[
 \begin{split}
 \operatorname{ch}R\pi_*
  R\mathcal Hom(\mathcal I_i,\mathcal I_j(P))
 &=\pi_*(\operatorname{ch}(\mathcal I_i^\vee)
          \operatorname{ch}(\mathcal I_j)e^P\operatorname{td}(T_X)),\\
 \operatorname{ch}(P^{[n_i]})
 &=\pi_*((1-\operatorname{ch}(\mathcal I_i))
                         e^P\operatorname{td}(T_X)).
 \end{split}                                                \tag{7}
\]
These are `rel:ext-grr` and `rel:tautological-grr`, including their
derived interpretation. Constant complexes contribute their Euler
characteristic alone:
\[
 [R\Gamma(P)]=\chi(P)[\mathcal O],\qquad
 \chi(P)=1+\tfrac12\int_XP(P-K).                             \tag{8}
\]
Thus irregularity does not introduce additional individual
cohomology dimensions into the fiber expression.

Products of the surface pushforwards in (7) are replaced, by flat
base change and projection formula, by one pushforward with distinct
auxiliary surface slots for each factor. This is valid over the
Hilbert base together with both marked factors. Neither output is
integrated in this operation.

## 5. All-degree projective pushdown, including its sign

For a resolution
\(0\to U_1\to U_0\to\mathcal I_{r-1}\to0\), put
\(a=\operatorname{rank}U_1=\operatorname{rank}U_0-1\).
The regular zero locus \(N_r\subset\mathbb P(U_0)\) has class
\(c_a(U_1^\vee(1))\). In quotient convention the projective
bundle formula gives, for every \(k\geq0\),
\[
 \begin{split}
 \sigma_*(\zeta^k)
 &=\sum_{b=0}^{\min(a,k)}
       c_b(U_1^\vee)[c(U_0^\vee)^{-1}]_{k-b}\\
 &=[c(U_1^\vee)/c(U_0^\vee)]_k
   =c_k(-\mathcal I_{r-1}^\vee).                           \tag{9}
 \end{split}
\]
This agrees with EGL Lemma 1.1,
\((-1)^k c_k(-\mathcal I_{r-1})\), not the unsigned Segre
class of the ideal.

Writing \(g_k=c_k(-\mathcal I^\vee)\), the Chern-character generating
identity is particularly useful:
\[
 \sum_{k\geq0}g_kz^k
  =\exp\!\left(\sum_{k\geq1}(k-1)!
                           \operatorname{ch}_k(\mathcal I)z^k\right).
                                                               \tag{10}
\]
Indeed, substitute
\(\operatorname{ch}_k(-\mathcal I^\vee)=-(-1)^k
\operatorname{ch}_k(\mathcal I)\) in the usual logarithm of the
total Chern class; the two signs cancel. Differentiating formal
series proves the **all-degree** recurrence
\[
 g_0=1,\qquad
 k g_k=\sum_{j=1}^k j!\operatorname{ch}_j(\mathcal I)g_{k-j}.
                                                               \tag{11}
\]
No bounded test replaces this generating-series argument. Point
ideals have \(\operatorname{ch}_1=0\). In particular
\(g_2=\operatorname{ch}_2(\mathcal I)=-[Z]\), and at length two
\(\sigma_*(\zeta^2)=-[\Delta_X]\).

The inverse-series specialization archived for Jacobian is
\((1+3z+3z^2)^{-1}\) through \(z^8\), a scalar algebraic
specialization of the denominator in (9). The adapter refused this
payload at validation with `formal_power_series.inverse_coefficient_growth`
and exit code 2. Its exact payload, inspected contract, typed error,
protocol, server version, and execution status are retained. The
refusal is **not** support or refutation of (9). `verify.py`
independently computes and multiplies the rational inverse.

## 6. Arbitrary-length induction in Chow

Fix a finite polynomial as in `rel:marked-reduction`, with any number
of auxiliary slots and the two outputs distinguished. Choose the
first positive Hilbert factor, in a fixed order. With other factors
unchanged, projection formula and
\(\psi_*[N_r]=r[X^{[r]}]\) identify its pushforward with \(1/r\)
times the pushforward of its pullback to \(N_r\).

Substitute (2) in every ideal occurrence, use (3)--(4) for its
graph term, and use the sign in (3) for every derived dual.
The result is a finite polynomial in \(\zeta\) whose coefficients
pull back from the smaller Hilbert product and one new surface slot.
Apply (9) to each power. The answer is again a polynomial of the
allowed type, because (10)--(11) express its added Chern classes in
Chern characters of the smaller universal ideal at the new slot.

This lowers \(n_1+n_2\) by **exactly one** and never integrates an
output. Induction terminates after \(n_1+n_2\) steps. At length zero
all positive-degree ideal Chern characters vanish and only decorated
equality diagonals on surface powers remain. Division by each positive
integer is legitimate in rational Chow. Equations (2), (3), and (9)
are Chow or perfect-\(K\) identities on the entire spaces, so this
argument does not remove a collision locus and then incorrectly
extend an equality from a dense open subset.

This proves `rel:marked-reduction` for arbitrary lengths. It also
proves its variant with any fixed finite number of outputs.

## 7. Why the actual Euler expression is a finite admissible input

For a perfect class \(V\) of rank \(r\),
\[
 e_u(V)=u^r\exp\!\left(\sum_{k\geq1}
            (-1)^{k-1}(k-1)!\operatorname{ch}_k(V)u^{-k}\right).
                                                               \tag{12}
\]
All moving weights in `eq:moving-ratio` have nonzero constant
part \(+1\) or \(-1\). Expand at \(x_1=x_2=0\), then in positive
intrinsic Chow degree. For fixed extracted \(x\)-degrees, scalar
weight powers are finite binomial truncations. The fixed factors
are finite Euler polynomials even at \(x_i=0\); no inversion of a
fixed weight zero is performed.

If \(N=n_1+n_2\), the ordinary codimension-two pushforward only uses
intrinsic degree \(2N+2\) on \(M\times X\times X\). All intrinsic
degrees in the expansions are nonnegative. It is therefore safe to
truncate each moving expansion above \(2N+2\) before performing
anything else. Formula (7), the independent-slot product rule, and
the finite Newton formulas for Chern classes now make every term an
input to Section 6. The insertions are exactly
\(-\operatorname{ch}_2(\mathcal I_i)=[Z_i]\) plus the separate
line/weight terms in `eq:insertion`. No tangent bundle of the Hilbert
scheme or unspecified geometric class is left outside this input.

The order of taking the equivariant second Chern character and then
specializing \(t=1/2\) is the manuscript's order. Nothing here
replaces it by the second ordinary Chern character of an already
specialized exponential.

## 8. Excess intersections and the selected coefficient

Let a multigraph encode a product of equality diagonals among surface
slots. For a connected component with \(v\) vertices and \(e\) edges,
first impose any fixed spanning tree. These \(v-1\) equalities are
regular of the expected codimension and give the small diagonal.
Every additional edge pulls back the normal bundle \(T_X\) of an
already satisfied equality. Self-intersection contributes \(c_2(T_X)\).
Induction on the remaining edges proves
\[
 \prod_{uv\text{ edge}}[\Delta_{uv}]
 =\iota_*\prod_C
       \operatorname{pr}_C^*c_2(T_X)^{\,e_C-v_C+1}.          \tag{13}
\]
This is `rel:graph-intersection`, including cycles and repeated
edges; assuming all these intersections transverse would be wrong.
Decorations restrict to their component's common coordinate.

A component with no output is integrated. It contributes zero
unless its decoration has codimension two; a surviving decoration
is a rational combination of \(c_2(T_X)\) and products of the five
line classes. A component with one output leaves its decoration
on that factor. If the outputs are separated, the result is an
external product in the ring in (1). If they are connected, the
result is \(\Delta_{X*}\eta\). At output codimension two,
\(\eta\) has codimension zero and hence is a scalar, since \(X\)
is connected.

Fix the Hilbert reduction order, expansion order, and graph edge
order **before evaluation on \(X\)**. Assign the connected-output
terms to \(c_*\), and only then evaluate integrated decorations as
intersection numbers. This proves (1), the numerical dependence,
and the promised coefficient-selection rule. It never solves for
a coefficient from a Chow relation on one surface.

If both lengths vanish, there are no incidence terms or residual
slots; the two insertions are separate output polynomials. No edge
joins the outputs, so the selected coefficient is zero.

For an irregular surface the diagonal can have odd-cohomology
Kunneth components, but (13) is an identity of Chow classes, not
a decomposition into cohomological projectors. All these components
remain inside \([\Delta_X]\). Thus no hypothesis \(q=0\), no
algebraicity of cohomology, and no Chow--Kunneth decomposition
enters the proof.

After (1) is established in Chow, any real cohomology class
\(\alpha\in H^2(X,\mathbb R)\) orthogonal to the five line classes
satisfies
\(\int C_*(\alpha\boxtimes\alpha)=c_*\int\alpha^2\).
The external terms of bidegrees \((0,2)\) and \((2,0)\) vanish by
degree, and those of bidegree \((1,1)\) vanish by orthogonality.
This tests the already selected coefficient on an irregular surface;
it is not a definition extracted from numerical EGL universality.

## 9. What the executable checks

Run, without external services or nonstandard Python dependencies,

```text
python3 research/marked-chow-audit/verify.py
```

The executable checks the Todd inverse, ideal-sequence sign,
derived-dual sign, and nontransverse excess examples. More
substantively, it implements (2)--(6), (11), and (12) on the literal
fiber expression in the legitimate parameter slice
\[
 L_1=L_2=T=H=0,\quad p=m_1=m_2=0.
\]
For this slice \(J=Z_1+Z_2\), the fixed factors are
\(c_{n_i}(((K)^{[n_i]})^\vee)\), both ordered Ext denominators
remain present, and the constant moving ratio is
\((-1)^{n_2}\). The relevant positive moving degree is \(N-2\).
There is no hidden replacement by an isolated graph exercise.
Every recursive step strictly lowers the actual point length.
The program retains the connected-output coefficient separately
from external products **before** realizing them on a surface.

An independent implementation sums torus fixed partitions on
\(\mathbb P^2\). It uses the character
\[
 E_{\lambda,\mu}(0)=
 V_\mu+e^{a+b}V_\lambda^\vee
 -(1-e^a)(1-e^b)V_\lambda^\vee V_\mu
\]
on each chart, the two arm/leg tangent weights for every box, and
exact rational series expansion of the moving Euler factors.
This second calculation does not call the nested-scheme rewriting
or its graph normalizer. It checks the complete ordinary output
class in the basis \(h^2\boxtimes1,h\boxtimes h,1\boxtimes h^2\).
Its tangent-character and localization formulas are additional
standard geometric inputs **only to this finite cross-check**,
not to the arbitrary-length proof above.

The archived cases include total length three and four with both
Hilbert factors nonempty. They are implementation cross-checks,
not evidence that a finite number of lengths proves the theorem.
There is also a genuine nonzero coefficient-extraction case:
\(X=\mathbb P^2,\ T=\mathcal O(1),\ H=L_1=L_2=0,\ (n_1,n_2)=(1,0)\),
\(p=0,\ (m_1,m_2)=(2,0)\). Here \(T=-K/3\), an actual rational
Chow equality on \(\mathbb P^2\), and the program keeps both
projective variables until extraction. It selects \(c_*=1\)
before realizing the class in the projective-plane Chow ring.
Indeed the only connected-output contribution in codimension two
is \([x_1^2]x_1/(1-x_1)=1\): the ordered moving factor with empty
target cancels, and the other has rank-one denominator
\(1-x_1-T|_\rho\). The complete class, including external terms,
has coefficients \((7/4,-17/4,7/4)\) in the displayed basis, which
the independent toric implementation reproduces. Thus the executable
also checks nonzero coefficient selection, not just cases in which
all connected-output terms vanish.

The uniform mathematical conclusion comes from the explicit
closed induction in Sections 3--8. Conversely, success of the
toric comparison does not imply uniqueness of the selected
diagonal coefficient; \(\Delta_{\mathbb P^2}\) itself is
decomposable. `exact_certificate.json` records that distinction
and does not report a Lean or Reviewer verdict.

## 10. Downstream boundary

This settles the marked Chow uncertainty shared by the two positivity
branches, subject to independent review of the proof and its inputs.
To turn it into `thm:chow-relation`, one must still establish that the
actual virtual localization contributions are precisely the explicit
fiber expressions with the manuscript's multiplicities. This requires
`prop:quot-pot`, `prop:fixed-pot`, `prop:fixed-pg0`, and
`prop:fixed-auxiliary`. Nonzero total coefficients then require the
separate `prop:nonrank` and `prop:rankone` arguments. These nodes
remain open in the campaign proof graph.

For completeness, the correspondence interface itself needs no extra
geometric hypothesis: on a zero-cycle \(z\), an external product
\(a\boxtimes b\) acts by zero if \(\operatorname{codim}a>0\),
because \(za=0\) on a surface, and acts by
\(\lambda\deg(z)b\) if \(a=\lambda[X]\).
The diagonal acts as the identity. Thus a genuine relation
\(0=c[\Delta_X]+\Gamma\), once obtained by the separate virtual
geometry, annihilates \(CH_0(X)^0_{\mathbb Q}\) when \(c\ne0\).
This establishes the passage from this specific retained-output
decomposition to the zero-cycle action; it does not assert that the
unverified geometry supplies the relation.

The campaign is not declared complete, and no publishable-novelty or
independent-review status has been inferred from arithmetic agreement.
