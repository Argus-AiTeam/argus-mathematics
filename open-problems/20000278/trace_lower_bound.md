# Fixed-boundary trace saturation on the vertex blowup

## Result and scope

Write \(r=1116\). For the fixed construction and the admissible boundary
\(\Gamma_s\) in `irrational_jump_candidate.md`, this note proves the following
conditional geometric statement:
\[
 \forall\,0<\epsilon<1/2\quad \exists\,N\in\mathbb Z_{\geq0}:
 \quad
 \tau(S,\Gamma_s;\mathfrak n^{r+N+\alpha})
       =\mathfrak n^{r+N+1}
       \not\subseteq\mathfrak n^{r+N+2}.                 \tag{1}
\]
The conditions are precisely that the fixed section ring has the stated
standard grading and smooth normalized vertex blowup, and that the boundary
is admissible as specified in Sections 3 and 5 of that file. Their independent
geometric certification remains open. No endpoint assertion about other
boundaries is used or proved here.

The proof uses Schwede--Tucker, **arXiv:1212.6956v1, Theorem 4.1**, not Ajit's
eventual-equality theorem as an assumption. It supplies the missing
pushforward-surjectivity argument, including every Frobenius twist. The
required integer \(N\) is boundary-dependent. It is specified below by a
finite Serre-vanishing cutoff, not by a numerical search.

## 1. Divisors, modules, and admissible exponents

Set \(C=\operatorname{Spec}S\), \(G=W_0\), and
\(\pi:Y\longrightarrow C\). Let \(\rho:Y\longrightarrow W\) be the bundle
projection. Put
\[
 D=K_C+\Gamma_s,\qquad
 B=\Gamma_{s,Y}+(s+1)G,\qquad
 T_t=\pi^*D+tG=K_Y+B+tG.
\]
The last equality uses the compatible canonical divisors in the specified
boundary construction. The strict transform is
\(\Gamma_{s,Y}=\rho^*(H_s/m_s)\); it is smooth and transverse to the zero
section, with coefficient \(1/m_s<1\). Its components and \(G\) form an SNC
divisor. The index of \(D\) divides \(m_s=q\ell\), prime to 13.

Fix one \(\epsilon\), then its specified
\[
 q>2/\epsilon,\quad 13\nmid q,\quad h=\lceil q\theta\rceil,\quad
 s=h/q,\quad\alpha=1-(h+1)/q.
\]
Let \(c=\varphi(m_s)\), \(Q=13^c\). Then \(m_s\mid Q-1\),
\((Q-1)D\) is Cartier, and \((Q-1)\alpha\) is an integer. For every
integer \(n\geq0\), put \(t=n+\alpha\). Thus, for every \(e\in c\mathbb Z_{\geq0}\),
\[
 (13^e-1)D\text{ is Cartier},\qquad
 (13^e-1)t\in\mathbb Z,\qquad
 (13^e-1)T_t\text{ is integral Cartier on }Y.              \tag{2}
\]
No arbitrary Frobenius exponent is used in a line-bundle twist.

The parameter test module on the regular SNC pair is
\[
 M_t=\tau(\omega_Y,T_t)
     =\mathcal O_Y(\lceil K_Y-T_t\rceil)
     =\mathcal O_Y(-\lfloor B+tG\rfloor).
                                                               \tag{3}
\]
Canonical divisors are integral and are accounted for by Cartier twisting;
there is no assumption that a separately chosen representative of \(K_Y\)
has SNC support. These are fractional canonical modules with compatible
rational identifications if \(T_t\) is not effective. An unwarranted
inclusion in \(\omega_Y\) is not needed.

Since \(\alpha+s+1=2-1/q\), (3) becomes
\[
 M_\alpha=\mathcal O_Y(-G),\qquad
 M_{n+\alpha}=M_\alpha(-nG)=\mathcal O_Y(-(n+1)G).          \tag{4}
\]
Here the strict-transform coefficient has floor zero and the exceptional
coefficient has floor \(n+1\). In particular, the endpoint is not obtained
by rounding \(\alpha+s+1\) to 2.

## 2. The actual one-step map and its kernel

The map in Schwede--Tucker Theorem 4.1, with its \(b=0\) case as in the proof,
is the restriction of the Frobenius trace:
\[
 \Phi_t:
 F^c_{Y*}\!\left(M_t\otimes
       \mathcal O_Y((1-Q)T_t)\right)\longrightarrow M_t,
 \qquad K_t=\ker\Phi_t.                                  \tag{5}
\]
The entire tensor product is **inside** \(F^c_{Y*}\). It cannot be removed
on pushing to \(C\).

For completeness, surjectivity in this particular SNC situation can be
read directly from the local Cartier trace. In SNC parameters \(x_i\),
write the coefficients of \(B+tG\) as \(d_i+f_i\), where \(d_i\) are
integers, \(0\leq f_i<1\), and \((Q-1)f_i\) are integers.
After trivializing the canonical factor, the source of (5) is the monomial
ideal whose exponents along these parameters are
\[
                  Qd_i+(Q-1)f_i.
\]
The monomial with exponents \(Qd_i+Q-1\) along these parameters, and \(Q-1\)
along the remaining regular parameters, belongs to that source. The
Cartier trace sends it to \(\prod_i x_i^{d_i}\), with a coefficient chosen
to have coefficient-field Cartier trace 1. Such a coefficient exists also
over an imperfect F-finite field: the Frobenius dual on that field is a
nonzero linear functional, not the inseparable field trace. This
calculation may be made after faithfully flat completion in a regular
local ring; surjectivity descends. It also shows that every image is
divisible by \(\prod_i x_i^{d_i}\).

Here is also a minimality argument for (3), so that its target is not a
larger guessed ideal. Work first in the completed regular local ring
\(\kappa[[x_1,\ldots,x_d]]\), and put
\(g=\prod_i x_i^{d_i}\). This ideal is compatible with all the boundary
Cartier maps: for \(P=13^e\), the input exponent in coordinate \(i\)
is at least
\[
 d_i+\lceil(P-1)(d_i+f_i)\rceil\ \geq\ P d_i,
\]
so a nonzero Cartier-trace image is divisible by \(x_i^{d_i}\).

Conversely, let \(J\ne0\) be a compatible ideal, and choose a nonzero
coefficient of \(x^k\) in some \(a\in J\). Choose \(e\) a sufficiently
large multiple of \(c\), so \(P>\max_i k_i\) and all the integers
\[
                  l_i=d_i+(P-1)(1-f_i)-k_i
\]
are nonnegative. For coordinates not in the boundary, use \(d_i=f_i=0\).
Apply the allowed Cartier map with multiplier
\(\prod_i x_i^{(P-1)(d_i+f_i)+l_i}\) to \(a\), also choosing a coefficient
multiplier so that the selected coefficient has field Cartier trace 1.
The selected term maps to \(g\). Any other surviving term has exponent
difference from \(k\) in \(P\mathbb Z_{\geq0}^d\): a negative difference
cannot be a multiple of \(P\), since \(P>k_i\). The image is therefore
\(g\) times a unit, and \(g\in J\). This proves minimality. Finite
Frobenius and its Hom modules commute with the faithfully flat
completion here, so compatibility and the conclusion descend to the
regular local ring. Integral Cartier shifting then gives (3) for
\(T_t=K_Y+B+tG\).

In particular (5) is surjective as a map of sheaves on \(Y\), and \(K_t\)
is coherent, since \(Y\) is Noetherian and Frobenius is finite.

Now the projection formula gives an isomorphism of **exact sequences**:
\[
\begin{split}
 M_{n+\alpha}((1-Q)T_{n+\alpha})
    &=M_\alpha((1-Q)T_\alpha)(-QnG),\\
 F^c_{Y*}\big(M_{n+\alpha}((1-Q)T_{n+\alpha})\big)
    &\simeq F^c_{Y*}\big(M_\alpha((1-Q)T_\alpha)\big)(-nG),\\
 \Phi_{n+\alpha}&=\Phi_\alpha\otimes\mathcal O_Y(-nG),\\
 K_{n+\alpha}&\simeq K_\alpha(-nG).
\end{split}                                                     \tag{6}
\]
The equality of maps uses the projection-formula compatibility of the
trace, locally \(\operatorname{Tr}(u^Qv)=u\operatorname{Tr}(v)\).
This verifies the kernel assertion, not just the easier target-module
assertion in Ajit Lemma 3.8.

## 3. One cutoff controls all the correctly twisted kernels

The line bundle \(\mathcal O_Y(-G)\) is \(\pi\)-ample, and \(\pi\) is
projective over the Noetherian affine scheme \(C\). Relative Serre
vanishing, in the form of the Stacks Project, **Lemma 30.16.2, Tag 02O1**,
applied to the one fixed coherent sheaf \(K_\alpha\) gives an
integer \(b_\alpha\geq0\) with
\[
 R^1\pi_*(K_\alpha(-jG))=0
                    \quad\hbox{for every integer }j\geq b_\alpha. \tag{7}
\]
For an exact choice, take \(b_\alpha=0\) if all the groups for \(j\geq0\)
vanish; otherwise take one plus the largest nonnegative \(j\) for which
the group does not vanish. Relative Serre vanishing makes this a finite
integer. No numerical value or effective regularity bound is asserted.
The primary statement, with its Noetherian-base, properness, coherence,
and relative-ampleness hypotheses, was read and retained in
`../evidence/literature/stacks-02O1.html`.

Fix \(n\geq b_\alpha\), and set \(t=n+\alpha>0\). For every
\(e\in c\mathbb Z_{\geq0}\), (2), (6), and the ordinary projection formula
give
\[
\begin{split}
 K_t((1-13^e)T_t)
  &\simeq K_\alpha\big(-[n+(13^e-1)t]G\big)
       \otimes\pi^*\mathcal O_C((1-13^e)D),\\
 R^1\pi_*\big(K_t((1-13^e)T_t)\big)&=0.                  \tag{8}
\end{split}
\]
The twist index \(j=n+(13^e-1)t\) is an **integer** and satisfies
\(j\geq n\geq b_\alpha\). The factor pulled back from \(C\) is an invertible
sheaf, so tensoring it preserves the vanishing. This proves (8) for
every required \(e\), including \(e=0\); there is no exchange of a
pointwise Frobenius cutoff with a uniform one.

Here is the resulting correctly typed iteration. Write
\[
 P_e(t)=\pi_*F^e_{Y*}\big(M_t((1-13^e)T_t)\big),
              \qquad P_0(t)=\pi_*M_t.
\]
For every \(e\in c\mathbb Z_{\geq0}\), tensor the exact sequence (5) by
\(\mathcal O_Y((1-13^e)T_t)\), apply \(F^e_{Y*}\), and then apply \(\pi_*\).
Its kernel before those pushforwards is the sheaf in (8). Since finite
Frobenius pushforward is exact and commutes with \(\pi_*\), (8) proves
that the induced map
\[
                         P_{e+c}(t)\longrightarrow P_e(t)          \tag{9}
\]
is surjective. The source is correct because
\[
 (1-Q)T_t+Q(1-13^e)T_t=(1-13^{e+c})T_t.
\]
Composing (9) gives the actual iterated trace, by trace transitivity.
Consequently
\[
 \operatorname{Im}\big(\operatorname{Tr}_Y^e:P_e(t)\to
                  \pi_*M_t\big)=\pi_*M_t
                         \quad(e\in c\mathbb Z_{>0}).              \tag{10}
\]
The misleading untwisted sequence with terms \(F^e_{C*}\pi_*M_t\)
is neither needed nor asserted.

## 4. Matching Schwede--Tucker and selecting the witness

In the notation of Schwede--Tucker Theorem 4.1, take its \(b=0\),
its \(c\) equal to our \(c\), and its integer numerator
\(a_{\rm ST}=(Q-1)t>0\). Its kernel \(N\) is exactly \(K_t\) in (5).
Its condition (4.1.1) is
\[
 R^1\pi_*\big(K_t(-(13^e-1)tG)\big)=0
                                      \quad(e=e_1+kc).
\]
By (6)-(7), this holds with \(e_1=c\) for every \(k\geq0\).
The additional pullback twist in the proof of that theorem is precisely
the invertible factor retained in (8). In particular all of that theorem's
Frobenius-exponent restrictions, not just a single vanishing, are met.

Its conclusion is the trace **image**
\[
 \tau(C,\Gamma_s;\mathfrak n^t)
      =\operatorname{Im}
         \left(\operatorname{Tr}_Y^c:
          \pi_*F^c_{Y*}(M_t((1-Q)T_t))\to\pi_*M_t\right).
                                                               \tag{11}
\]
Here the birational trace into the canonical module on \(C\) is the
identity in the common function field. Its compatibility with Frobenius
identifies the map in (11) with the map in the source theorem, followed
by the specified rational canonical identification. Equation (13)
below identifies its target with an actual ideal of \(S\).
By (10), this particular image is the entire target. Thus, for every
integer \(n\geq b_\alpha\),
\[
                 \tau(C,\Gamma_s;\mathfrak n^{n+\alpha})
                         =\pi_*\mathcal O_Y(-(n+1)G).              \tag{12}
\]
Equality is proved here by a new surjectivity argument; it is not the
conclusion of Theorem 4.1 quoted without its map.

The precise comparison with the requested Ajit statements is:

| Ajit, arXiv:2605.26354v1 | What is used here |
|---|---|
| Lemma 3.7 | Replace the printed untwisted sequence by the actual \(P_e(t)\) and (9); identify its image using Schwede--Tucker (11). |
| Lemma 3.8 | Prove the isomorphism of trace exact sequences (6), including the source twist \(-QnG\), not only \(M_t=M_\alpha(-nG)\). |
| Lemma 3.9 | Use relative Serre vanishing on \(K_\alpha\), then prove (8) for every admissible \(e\), as well as the one-step case \(e=0\). |
| Theorem 3.10 | Derive its sufficient equality for this fixed boundary and fractional part via (10)-(12); do not assume the theorem's conclusion or a cutoff uniform over boundaries. |

The needed features of the **fixed normalized blowup** follow directly
from its stated standard section-ring geometry. On a blowup chart
associated to a degree-one section \(x_i\), its ring is
\(S[\mathfrak n/x_i]=S_{(x_i)}[x_i]\). These charts glue to
\(\operatorname{Tot}\mathcal O_W(-A)\), with \(G\) the zero section.
They are regular when \(W\) is smooth, so normalization changes nothing.
The tautological ideal is \(\mathfrak n\mathcal O_Y=\mathcal O_Y(-G)\),
and it is relatively ample. Finally
\[
 \pi_*\mathcal O_Y(-dG)
      =\bigoplus_{j\geq d}H^0(W,jA)
      =\mathfrak n^d\qquad(d\in\mathbb Z_{\geq0}),                \tag{13}
\]
where the second equality uses generation in degree one. These
identifications do not replace the blowup by another resolution.

Choose
\[
                 N=\max(0,b_\alpha-r),\qquad n=r+N.              \tag{14}
\]
Equations (12)-(14) give the equality in (1).
For a specific nonzero class, the effective fixed divisor
\(A=3f^*L\) has its canonical section
\(\sigma=1\in H^0(W,A)=S_1\). This is a section in **degree one**,
not the unit of \(S_0\). Its power
\[
                    \sigma^{r+N+1}
       \in\tau(S,\Gamma_s;\mathfrak n^{r+N+\alpha})               \tag{15}
\]
is nonzero because \(S\) is a domain, and has degree exactly \(r+N+1\).
It is therefore outside \(\mathfrak n^{r+N+2}\). Localization at
\(\mathfrak n\) preserves this obstruction: multiplying by a denominator
outside \(\mathfrak n\) leaves a nonzero degree-\((r+N+1)\) component.

## 5. Relation to the reviewed descent and remaining obligations

The order of choices is
\[
 \epsilon\ \longmapsto\ (q,h,s,\alpha,H_s,m_s,c)
       \ \longmapsto\ K_\alpha\ \longmapsto\ b_\alpha
       \ \longmapsto\ N\ \longmapsto\ \sigma^{r+N+1}.
\]
Only after these choices do (8)-(11) quantify over every required
Frobenius exponent. No bound is uniform over \(\epsilon\) or over
boundaries.

The independently reviewed Section 6 descent needs only (15) and its
noncontainment, not the stronger equality proved conditionally here.
Indeed a hypothetical containment at \(\lambda_*-\epsilon\), monotonicity
to \(r+\alpha\), and the full-big Skoda identity would put the full big
test ideal at \(r+N+\alpha\) inside \(\mathfrak m^{r+N+2}\). The boundary
summand contains (15), a contradiction. With the separate all-boundary
upper bound at \(\lambda_*\), this would give the desired strict jump.

Compared with the strongest prior result, this supplies the previously
missing map-level implication from a boundary-dependent Serre cutoff to
the required lower class. It does not supply the still-open independent
geometric eligibility certificate, admissible-boundary certificate,
full-big localization/Skoda application, or endpoint upper bound.
No complete irrational-jump certificate or nondiscreteness result is
claimed. Independent Reviewer acceptance of this argument is pending.
