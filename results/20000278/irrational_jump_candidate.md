# A characteristic-13 candidate and a conditional full-test-ideal jump

This is mathematical scope, not an accepted counterexample. The objects below
are fixed, including the polarization and proposed jumping exponent. The
conditional implication in Section 6 isolates what an exact-certificate phase
must establish. No assertion about nondiscreteness follows from it.

## 1. Question and definition correspondence

The primary AIM page, Problem 1.3 [Miller], asks about discreteness and rationality
of F-jumping numbers in the non-Q-Gorenstein case. It does not itself specify
locality, F-finiteness, a test-ideal definition, or a characteristic. We use the
standard full **big** test ideal on an F-finite normal local domain, essentially
of finite type over an F-finite field. This is an explicit specialization of the
question, not extra hypotheses quoted from AIM.

For such a domain \(R\), a nonzero ideal \(\mathfrak a\), and \(t\geq0\), let
\(\tau_b(R;\mathfrak a^t)\) be the smallest nonzero ideal \(J\) such that
\[
 \phi\big(F_*^e(\mathfrak a^{\lceil t(p^e-1)\rceil}J)\big)\subseteq J
 \quad\text{for every }e>0,\quad
 \phi\in\operatorname{Hom}_R(F_*^eR,R).
\]
All Cartier maps occur. This is not a finitistic test ideal or the test ideal of
one chosen finitely generated Cartier subalgebra.

Schwede, **arXiv:0906.4313v2**, Definitions 3.15-3.16, uses this uniformly
compatible-ideal definition (the condition \(J\cap R^\circ\ne\varnothing\) is
\(J\ne0\) for a domain). Corollary **5.2 in this version** gives
\[
 \tau_b(R;\mathfrak a^t)=
 \sum_{\substack{\Delta\geq0\\
          K_R+\Delta\ {\rm Q\text{-}Cartier}\\
          p\nmid\operatorname{ind}(K_R+\Delta)}}
       \tau(R,\Delta;\mathfrak a^t).                         \tag{1}
\]
Schwede--Tucker, **arXiv:1212.6956v1**, Definition 3.4, defines the summands by
replacing all maps with
\(\operatorname{Hom}_R(F_*^eR(\lceil(p^e-1)\Delta\rceil),R)\).
These agree with Ajit, **arXiv:2605.26354v1**, Definitions 2.1-2.2 and
Theorem 2.5. Ajit's citation label "[Sch11b, Theorem 6.2]" is not the locator in
the retrieved arXiv version; the recorded proposition is Corollary 5.2.

The precise negative-witness target is one eligible fixed \(R,\mathfrak a\)
and one irrational \(\lambda>0\) satisfying
\[
 \tau_b(R;\mathfrak a^{\lambda-\epsilon})
       \supsetneq \tau_b(R;\mathfrak a^\lambda)
       \quad\text{for every }0<\epsilon<\epsilon_0.           \tag{2}
\]
Our proposed \(\epsilon_0\) is \(1/2\). A sequence of auxiliary boundary
thresholds, a multiplier-ideal jump, or an irrational geometric threshold alone
does not establish (2). Finitely accumulating jumps would be a different
negative witness and are not asserted.

Primary sources retained locally:

- `evidence/literature/aim-problem-1.3.html`, retrieved from
  <http://aimpl.org/testandmultiplierideals/1/>.
- `evidence/literature/2605.26354v1.pdf` and its layout-text extraction.
- `evidence/literature/0906.4313v2.pdf` and its layout-text extraction.
- `evidence/literature/1212.6956v1.pdf` and its layout-text extraction.

## 2. One actual ring and exponent

Let
\[
 k=\mathbb F_{13}(u,v,w,z),\qquad
 E/k:\ y^2=x(x-1)(x-u),
\]
where \(u,v,w,z\) are algebraically independent. Write \(O\) for the point at
infinity, \(X=E\times E\), \(f_1=\{O\}\times E\), \(f_2=E\times\{O\}\), and
\(\delta\) for the diagonal. Fix the actual divisors
\[
 M=3(f_1+f_2),\qquad L=6f_1+3f_2+6\delta.
\]
This is the \(k=2\) member of Ajit's Section 5.1 family; that integer family
parameter is unrelated to our field notation \(k\).

The expression
\[
 b=x_1^3x_2^3+v x_1^3+w x_2^3+z
       \in H^0(X,\mathcal O_X(2M))                           \tag{3}
\]
specifies a global section: \(1,x^3\) are sections of
\(\mathcal O_E(6O)\). Define the finite double cover
\[
 f:W=\operatorname{Spec}_X
       \big(\mathcal O_X\oplus\mathcal O_X(-M)\big)\longrightarrow X,
 \qquad \xi^2=b,
\]
where (3) defines the multiplication on the second summand. There is no
"general branch member" still to choose in this definition.

Set \(A_0=f^*L\), \(A=3A_0\), and distinguish the graded and local rings:
\[
 S=\bigoplus_{j\geq0}H^0(W,\mathcal O_W(jA)),\qquad
 \mathfrak n=S_+,\qquad
 \boxed{R=S_{\mathfrak n},\quad\mathfrak a=\mathfrak m=\mathfrak nR.} \tag{4}
\]
This section-ring definition specifies a ring, not just an existence class.
A list of generators and relations has not been computed.

The proposed values are
\[
 \theta=\frac{7+\sqrt{17}}{48},\qquad
 \kappa=1-\theta=\frac{41-\sqrt{17}}{48},\qquad r=1116,
\]
\[
 \boxed{\lambda_*=r+\kappa
                =\frac{53609-\sqrt{17}}{48}.}                \tag{5}
\]
Neither 3 in the polarization nor 1116 in the exponent means "large enough".
The latter is the generator count relevant to Skoda, not an estimate of an
unknown boundary-comparison bound.

## 3. Geometric verification and its remaining standard inputs

The following are explicit derivations. Standard geometric results used in
them are recorded as assumptions, not as kernel-verified conclusions.

**Base and branch.** The field is infinite and
\([k:k^{13}]=13^4\). The Legendre curve is smooth because \(u\ne0,1\).
The separable degree-six map \(g=x^3:E\to\mathbb P^1\) has branch values
\(\{0,1,u^3,\infty\}\). Equation (3) is the pullback under \(g\times g\) of the
graph
\[
 B_2=-\frac{vB_1+z}{B_1+w}.
\]
Its determinant is nonzero since \(z-vw\ne0\); algebraic independence excludes
all sixteen pairs of branch values, including the values at infinity.
At least one factor map is therefore unramified at every point of the
pullback. The graph is smooth with both projections isomorphisms, so the branch
divisor on \(X\) is geometrically smooth. It is a nonempty ample divisor.
Connectedness of ample divisors on an abelian surface, or the cohomology
vanishing used below, gives geometric connectedness. Smoothness and
connectedness give geometric integrality. Its multiplicity-one valuations
also show that \(b\) is not a square in \(k(X)\).
Consequently \(W\) is smooth and geometrically integral, and the double-cover
canonical formula gives
\[
 f_*\mathcal O_W=\mathcal O_X\oplus\mathcal O_X(-M),\qquad
 K_W\sim f^*M.                                               \tag{6}
\]

For the literal \(\operatorname{End}_{\bar k}(E)=\mathbb Z\) hypothesis in
Ajit's Lemma 5.2, there is a standard specialization argument. The good
specializations \(u=2,4\) over \(\mathbb F_{13}\) have respectively
\[
 (\#E,\operatorname{Tr}F,\operatorname{Tr}(F)^2-52)
       =(8,6,-16),\quad(16,-2,-48).
\]
Their ordinary endomorphism algebras are \(\mathbb Q(i)\) and
\(\mathbb Q(\sqrt{-3})\). Injectivity of geometric endomorphism specialization
excludes a larger generic endomorphism algebra. The specialization theorem
and the ordinary-elliptic-curve classification remain explicit standard
inputs; no mechanical endomorphism certificate is claimed.

**A fixed standard grading.** Let \(S^{(0)}=\bigoplus H^0(W,jA_0)\).
Both \(M\) and \(L-M=3(f_1+2\delta)\) are globally generated and ample.
For the second assertion a group automorphism identifies \(f_1,\delta\)
with the two fiber classes, giving degrees 3 and 6. Thus \(L\), and hence
\(A_0\), are globally generated. For every integer \(j\geq1\), (6) gives
\[
 H^i(W,jA_0)=H^i(X,jL)\oplus H^i(X,jL-M)=0\quad(i>0),          \tag{7}
\]
using ample-line-bundle vanishing on abelian varieties; \(jL-M\) is ample
because it is \((j-1)L+(L-M)\).
The Castelnuovo--Mumford multiplication lemma applied using \(A_0\) gives
\[
 S^{(0)}_n S^{(0)}_1=S^{(0)}_{n+1}\quad(n\geq3).
\]
Indeed the required groups are \(H^1(W,(n-1)A_0)\) and
\(H^2(W,(n-2)A_0)\), both covered by (7). It follows that
\[
 S^{(0)}_{3j}=S^{(0)}_3(S^{(0)}_1)^{3j-3}
                 =(S^{(0)}_3)^j .
\]
Thus \(S=(S^{(0)})^{(3)}\) is generated in degree one. Its full section-ring
construction on the smooth surface gives finite generation and normality;
the resulting degree-one embedding also makes \(A\) very ample.
This supplies an explicit replacement for the unspecified Veronese in
Ajit's Remark 4.3.

**Threshold and generator count.** With Ajit's matrix convention,
\[
 L\longleftrightarrow\begin{pmatrix}12&6\\6&9\end{pmatrix},
 \qquad M\longleftrightarrow3I.
\]
The nef/pseudo-effective threshold is the larger root of
\[
 \det(3tL-M)=9(72t^2-21t+1)=0.
\]
Ajit's Proposition 5.3 and Corollary 5.7 identify this with
\[
 \inf\{t:tA-K_W\text{ is pseudo-effective}\}=\theta.
\]
Here \(K_W\) is ample, so the truncation by zero in the source's definition
of \(t_0\) does not change the threshold. For \(t>\theta\), \(tA-K_W\) is
ample, not merely pseudo-effective.

The intersection numbers are \(L^2=144\), \(LM=63\), \(M^2=18\).
By (6), abelian Riemann--Roch, and ample vanishing,
\[
 \dim_k S_1=h^0(X,3L)+h^0(X,3L-M)
 =\frac{1296}{2}+\frac{1296-378+18}{2}
 =648+468=1116.                                               \tag{8}
\]
Since the grading is standard, \(\mathfrak m/\mathfrak m^2\simeq S_1\);
thus \(r\) in (5) is the minimal number of generators.

The ring (4) is three-dimensional, normal, local, and essentially of finite
type over \(k\), hence excellent and F-finite. Ajit's Lemma 4.1 identifies
the vertex blowup with \(Y=\operatorname{Tot}\mathcal O_W(-A)\), with
exceptional zero section \(W_0\),
\(\mathfrak n\mathcal O_Y=\mathcal O_Y(-W_0)\), and \(-W_0\) relatively ample.
The punctured cone is smooth. Irrationality of \(\theta\), together with the
cone canonical-class criterion in Lemma 4.5/Corollary 4.6, rules out
Q-Gorensteinness at the vertex. These cone results and their applicability
are recorded obligations rather than an independently accepted eligibility
certificate.

For the auxiliary integers of source Lemma 4.9, the same calculation improves
the general convergence statement to
\[
 q_m:=\min\{q:H^0(W,qA-mK_W)\ne0\}=\lceil m\theta\rceil,
 \qquad0<q_m/m-\theta<1/m.                                    \tag{9}
\]
Below the threshold the divisor is not pseudo-effective; above it the
corresponding divisor \(3qL-mM\) on \(X\) is ample and has sections. Equality
cannot occur. Formula (9) does not validate any assertion about natural
pullbacks or multiplier ideals in Theorems 4.18-4.19.

**Arithmetic actually executed.** The discriminant of
\(72x^2-21x+1\) is \(153=9\cdot17\), not a rational square. Its larger root is
\(\theta\), so \(\theta,\kappa,\lambda_*\) are irrational. The inspected
Jacobian operation `algebraic_number.compare` returned exact root isolation
\[
                 1/5<\theta<1/4.
\]
Its operation contract, exact payload, unmodified typed output, and execution
status are in `evidence/jacobian/`. This is only an arithmetic result. It
certifies neither eligibility nor any Frobenius image.

## 4. What the complete source route actually uses

The full Sections 3-5 construction was read, and Section 9 was followed because
Sections 3-5 explicitly defer the actual full-ideal jump to it.

| Source in arXiv:2605.26354v1 | Content and scope |
|---|---|
| Setup 3.1; Definitions 3.2, 3.6 | Fixed effective boundary; regular normalized blowup of the ideal; SNC strict transform plus exceptional support; index \(p^b m\), \(p\nmid m\), and an arithmetic grid \(A_{b,c}\). |
| Lemmas 3.7-3.9; Theorem 3.10 | Assert fixed-boundary trace/stable-image comparison for \(n+\alpha\), \(\alpha\in A_{0,c}\), \(n\ge T_\Delta\). Relative Serre vanishing supplies no numerical bound here. |
| Theorems 3.13-3.14 | Extend the assertion to general index and then all sufficiently large real exponents for a fixed boundary. These extensions are not needed for Section 6 below. |
| Corollary 3.16 | Chooses finite boundary sets at one fixed exponent and obtains eventual equality after integer translation. It does not make those sets or bounds uniform in the fractional part. Applying Setup 3.1 to arbitrary chosen boundaries also needs its SNC hypothesis. |
| Lemma 3.17 | Claims all-exponent \(\tau(X,\Delta;\mathfrak a^t)\subseteq\mathcal J(X,\Delta;\mathfrak a^t)\). This, not eventual equality, is the upper-bound input. |
| Lemmas 4.10-4.11; Proposition 4.12 | Bound every boundary's exceptional coefficient by \(1+\theta\), and construct special SNC cone boundaries from ample \(sA-K_W\), \(s>\theta\). |
| Propositions 4.13-4.14 | Give \(\mathcal J(C,\Gamma_s;\mathfrak n^t)=\mathfrak n^{\lfloor t+s+1\rfloor}\), and claim the same for \(\tau\) only beyond a boundary-dependent bound. |
| Propositions 4.15-4.18; Theorem 4.19 | Natural-pullback and limiting multiplier-ideal formulas. They are not substituted for a full big test ideal and are not needed for the conditional jump argument below. |
| Proposition 4.21; Remark 4.22 | Eventual comparison along a fixed fractional part away from \(\kappa\); the endpoint is explicitly referred to Proposition 9.4. |
| Proposition 5.3; Remark 5.4; Proposition 5.5; Corollary 5.7 | The \(E\times E\), \(L_k,M\), double-cover construction and its quadratic irrational threshold; used in (3)-(5). |
| Theorems 5.9, 5.15; Remark 5.16 | The higher-dimensional matrix construction starts with a characteristic-zero assumption and an unspecified Hilbert-irreducibility specialization. It is not used as an explicit positive-characteristic witness. |
| Lemmas 9.1-9.3; Proposition 9.4 | Skoda, the all-boundary upper bound, and one special-boundary lower bound yield \(\forall\epsilon\ \exists N(\epsilon)\ \forall n\ge N(\epsilon)\), not a uniform \(N\). |
| Corollary 9.5; Theorem 9.6; proof of Theorem 2 | The source then invokes translation of jumps and a cited isolated-singularity discreteness theorem to reach \(r+\kappa\). These extra jump-translation and discreteness steps are avoided below. |

The original Schwede--Tucker source was also opened. In
**arXiv:1212.6956v1, Theorem 4.1 and Remark 4.2** (not Theorem 5.1 in this
version), the conclusion is a Frobenius **trace image**, with a hypothesis
\[
 R^1\pi_*\!\left(N(-(p^e-1)p^b tG)\right)=0
 \quad(e=e_1+nc).
\]
It is not literally an assertion that the image equals the whole multiplier
ideal. Its proof and Ajit's Lemmas 3.7-3.9 must be matched as maps, including
all twists and trace-surjectivity hypotheses. Remark 4.2 identifies finding
the vanishing exponent as a computational obstruction. Remark 4.3 warns
against replacing the normalized blowup by an arbitrary resolution.
The local primary sources were obtained; no source-access failure is being
used as mathematical evidence.

The subsequent map-level derivation in `trace_lower_bound.md` retains the
twists omitted from the shorthand stable-image diagram. It supplies a
boundary-dependent Serre argument for the lower obligation, conditional on
the fixed geometric and admissible-boundary hypotheses, and awaits
independent review. It does not establish the separate endpoint bound.

## 5. Exact auxiliary boundary obligation

For rational \(s=h/q>\theta\) with \(13\nmid q\), put
\[
 D_s=3hL-qM=3(3h(2f_1+f_2+2\delta)-q(f_1+f_2)).
\]
The integral class inside the last parentheses has positive-definite matrix
\[
 P_s=\begin{pmatrix}12h-q&6h\\6h&9h-q\end{pmatrix},\qquad
 T'_s=\operatorname{tr}P_s=21h-2q>0.
\]
Its determinant is a positive integer. Choose the first integer
\(\ell>T'_s\) with \(13\nmid\ell\), so \(\ell\leq T'_s+2\), and set
\(m_s=q\ell\). The estimate
\(\lambda_{\min}(P_s)>1/T'_s\) makes \(\ell P_s-I\) positive definite.
Consequently \(\ell D_s\) and \(\ell D_s-M\) are triples of ample integral
classes. The usual third-power very-ampleness and double-cover separation
lemmas imply that
\[
 m_s(sA-K_W)=f^*(\ell D_s)
\]
is very ample. Those geometric lemmas are explicit remaining inputs; a
particular smooth section of this auxiliary system has not been enumerated.
Bertini over the fixed infinite field then gives a smooth member \(H_s\).
Put \(\Delta_s=H_s/m_s\) and let \(\Gamma_s\) be its cone boundary.
The source's Proposition 4.12 must give
\[
 \pi^*(K_C+\Gamma_s)
  =K_Y+\Gamma_{s,Y}+(s+1)W_0,\qquad
 m_s(K_C+\Gamma_s)\text{ Cartier},                            \tag{10}
\]
with SNC support and strict-transform coefficients \(1/m_s<1\).
The index divides \(m_s\) and is therefore prime to 13.

This makes the boundary choices and their arithmetic restrictions explicit.
The actual ring in (4) is independent of \(s,q,\ell,H_s\).

## 6. Conditional every-epsilon implication at the fixed exponent

Here is a reduction to precise mathematical obligations, not an assertion that
those obligations have already been certified. Work on \(S\) and then localize,
using localization of the relevant test ideals.

**Upper obligation U.** For every boundary in (1), its exceptional coefficient
on \(Y\) satisfies \(k_\Gamma\geq1+\theta\), and its test ideal obeys the
divisorial multiplier upper bound. Hence
\[
 \tau(S,\Gamma;\mathfrak n^{\lambda_*})
   \subseteq\mathfrak n^{\lfloor\lambda_*+k_\Gamma\rfloor}
   \subseteq\mathfrak n^{r+2}.
\]
Summing gives
\[
             \tau_b(R;\mathfrak m^{\lambda_*})
                       \subseteq\mathfrak m^{r+2}.           \tag{U}
\]
This is the precise all-boundary use of source Lemmas 3.17, 4.10, and 9.2.
One must justify the valuative upper bound for arbitrary summands, not assume
that their strict transforms are SNC on this fixed blowup. No \(T_\Gamma\)
or matching endpoint equality is needed.

**Lower obligation L.** Fix any \(0<\epsilon<1/2\). Choose an integer
\(q>2/\epsilon\) with \(13\nmid q\), then set
\[
 h=\lceil q\theta\rceil,\qquad s=h/q,\qquad
 \alpha=1-(h+1)/q.
\]
Exactly,
\[
 \theta<s<\theta+1/q,\quad
 \kappa-\epsilon<\alpha<\kappa,\quad
 0<\alpha<1,\quad \alpha+s+1=2-1/q.                         \tag{11}
\]
Use the boundary of Section 5. One may take
\(c=\varphi(m_s)\); then \(m_s\mid13^c-1\), and
\(\alpha\in A_{0,c}\).
The necessary lower requirement is that there exists an integer
\(N\geq0\), allowed to depend on this boundary and on \(\epsilon\), with
\[
 \tau(S,\Gamma_s;\mathfrak n^{r+N+\alpha})
                  \not\subseteq\mathfrak n^{r+N+2}.          \tag{L_min}
\]
It suffices, but is not necessary, to prove the stronger statement:
there exists an integer
\(N\geq0\), allowed to depend on this boundary and on \(\epsilon\), such that
\[
 \tau(S,\Gamma_s;\mathfrak n^{r+N+\alpha})
             =\mathfrak n^{r+N+1}.                         \tag{L}
\]
Theorem 3.10 plus Proposition 4.13 would supply (L) if their application is
validated. The real-exponent Theorem 3.14 is not needed.
The map-level proof in `trace_lower_bound.md` now derives (L) directly from
the actual Schwede--Tucker trace image and relative Serre vanishing, without
assuming Ajit's eventual-equality assertion. Its explicit lower class is
the \((r+N+1)\)-st power of the canonical degree-one section of \(A\).
The geometric hypotheses and independent acceptance of the new proof
remain separate obligations.

**Descent lemma.** Assume (1), (U), (L), monotonicity and localization, and the
full-big-test-ideal Skoda identity
\[
 \tau_b(R;\mathfrak m^t)
       =\mathfrak m\,\tau_b(R;\mathfrak m^{t-1})\quad(t\geq r).
                                                                    \tag{S}
\]
This is the identity in source Lemma 9.1, not its further assertion about
equivalence of jumping numbers under translation.
Suppose for contradiction that
\(\tau_b(R;\mathfrak m^{\lambda_*-\epsilon})
        \subseteq\mathfrak m^{r+2}\).
By (11) and monotonicity the same holds at \(r+\alpha\).
Iterating (S), which is allowed since \(r+\alpha>r\), gives
\[
 \tau_b(R;\mathfrak m^{r+N+\alpha})
       \subseteq\mathfrak m^{r+N+2}.
\]
But (L), localization, and (1) give the opposite lower containment
\[
 \mathfrak m^{r+N+1}
       \subseteq\tau_b(R;\mathfrak m^{r+N+\alpha}).
\]
This is impossible: a nonzero element of \(S_1\) has a nonzero
\((r+N+1)\)-st power of exactly that degree, not in
\(\mathfrak n^{r+N+2}\). Localization cannot erase the degree obstruction,
because every denominator outside \(\mathfrak n\) has a nonzero constant term.
Therefore
\[
 \tau_b(R;\mathfrak m^{\lambda_*-\epsilon})
                   \not\subseteq\mathfrak m^{r+2}.
\]
Together with (U) and monotonicity this proves (2), **conditionally on the
listed inputs**, for every \(0<\epsilon<1/2\).

The candidate index \(r=1116\) was fixed before \(\epsilon\); only the
auxiliary \(N\) depends on it. No powers of \(\mathfrak m\) were cancelled.
Neither a uniform comparison bound over all boundaries, a no-accumulation
theorem, nor an equivalence of jumps under integer translation is assumed.
The same contradiction uses only (L_min): use its class outside the next
power instead of the entire lower ideal in the displayed argument.

## 7. What is established at scope, and what is not

Compared with the previously accepted one-node structural repair, this work
specifies an actual characteristic, elliptic curve, branch section, smooth
double-cover model, third-Veronese section ring, maximal ideal, and exact
irrational proposed exponent. It supplies the arithmetic in (8)-(11) and the
conditional descent lemma, rather than just the title/abstract or the
irrational threshold.

The following indispensable obligations remain open in `MATH_STATE.json` and
`PROOF_GRAPH.json`:

1. Complete the cited geometric eligibility argument, including the standard
   inputs isolated in Section 3, and the auxiliary-boundary hypotheses in
   Section 5. No machine-checked finite presentation is supplied.
2. Independently review `trace_lower_bound.md`, which derives (L), and hence
   the sufficient lower class, with the actual trace domains, kernel twists,
   and all required Frobenius quantifiers. This is a conditional geometric
   proof, not a citation-only claim or a completed candidate certificate.
3. Establish the all-boundary upper statement (U) for the full intrinsic
   invariant and justify localization and the Skoda identity in this setting.
4. Independently review the source attributions and the conditional implication.
   Engineer opinions and the small arithmetic operation are not Reviewer
   acceptance or a counterexample certificate.

Two failed shortcuts are retired, not the underlying construction: an
irrational geometric threshold alone cannot certify a full-ideal jump; and
\(\forall\epsilon\,\exists N(\epsilon)\) cannot be replaced by
\(\exists N\,\forall\epsilon\). The descent lemma is a different implication
that does not make that replacement. A failure of the trace comparison would
retire this mechanism only, not settle AIM Problem 1.3.

No additional negative-witness route is opened in this scope milestone.
The independent campaign remains active.
