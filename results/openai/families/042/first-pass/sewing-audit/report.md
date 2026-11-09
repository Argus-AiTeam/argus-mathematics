# Uniform annular sewing audit

## Scope and source facts

The target is Theorem `sew:chain` in OpenAI, *Every complex K3 surface is
Oka*, September 23, 2026, staged at
`research/openai_manuscript/Every-complex-K3-surface-is-Oka-September-23-2026/build/`.
The question is whether its **stated exact transition hypotheses** imply a
positive common transverse radius independent of every block length and the
number of blocks. A result here is not a proof or a refutation of the K3 Oka
conjecture.

The source establishes the following intended dependency structure. These
are source facts, not acceptance of the mathematical assertions.

| Source locator | Assertion or role |
|---|---|
| `sections/introduction.tex`, `thm:main`, lines 20-35 | Every complex K3 surface has CAP in every source dimension. |
| `sections/local.tex`, `loc:criterion`, lines 44-61 | Two appropriate transverse, locally biholomorphic entire-cylinder families imply property L; a limiting long-disc formulation is also stated. |
| `sections/gluing.tex`, `ana:cap`, lines 22-27 | Property L everywhere on a complete complex surface implies CAP in every source dimension. |
| `sections/gluing.tex`, `ana:polydisc`, lines 327-334 | The finite-radius polydisc approximation step underlying CAP. |
| `sections/globalization.tex`, `glue:trace`, lines 483-496 | Nonlinear trace splitting and gluing across a real interface, without a lower bound for complex normal thickness. |
| `sections/degeneration.tex`, `deg:seams`, lines 303-319 | Core/neck transitions meet the sewing hypotheses except for exactness. |
| `sections/rational.tex`, `rat:strips`, lines 270-282 | Buffered periodic symplectic strip charts persist under the stated deformation. |
| `sections/sewing.tex`, `sew:centers` | Period adjustment supplies exactness, conditional on continued uniform buffered choices at the updated centers. |
| `sections/sewing.tex`, `sew:chain` | Uniform sewing of the resulting bi-infinite exact symplectic annular chain. |

The degeneration route invokes `sew:centers`, then `sew:chain`, then
`loc:criterion` (`degeneration.tex`, lines 390-440). The rational route also
uses `sew:chain` and the center/action correction mechanism before applying
`loc:criterion` (`rational.tex`, lines 315-336, 413-420, 498-526).
The main theorem still needs those geometric constructions and the analytic
L-to-CAP argument even if sewing is verified.

The broader argument cites Chen--Gounelas, *Curves of maximal moduli on K3
surfaces*, Theorem A, DOI `10.1017/fms.2022.24`, for its genus-one input
(`projective.tex`, lines 24-35), and Xie--Zhao, *Periods of Oka K3 surfaces are
dense*, `arxiv:2608.24392v2`, Theorems A, B, E, together with Verbitsky's
erratum, `arxiv:1708.05802v1`, for period/dynamics inputs
(`introduction.tex`, lines 128-132; `dynamics.tex`, lines 9-10).
Those external propositions are recorded for independent source checking,
not used as black boxes in the sewing proof.

A targeted literature lookup did not supply a primary proposition stating
the precise infinite-chain quantitative theorem. General curve-gluing and
Cartan-splitting references returned by that lookup are not substituted for
it. This is not a verified novelty claim. No earlier certified sewing result
was present in the campaign ledger at the start of this mission.

## Result and verification boundary

**Engineer conclusion, pending independent review:** `sew:chain` is true
under its stated hypotheses. In particular one may take \(b=r/4\), after
reducing the error threshold as below. There is no surviving first-order
transverse obstruction from a parameter-dependent translation. The proof
also gives joint holomorphic dependence on arbitrary passive complex
parameters with the same constants.

This is a complete analytic proof supported by exact symbolic identities
and scalar inequalities, **not** a proof-kernel formalization. The
rerunnable `verify.py` checks the supporting identities, all-index
induction algebra, rational bounds, and the saved typed Jacobian result.
It does not replace the analytic argument below by finite samples.
Independent source-fidelity, mathematical, significance, and novelty review
remain pending. No false manuscript assertion was identified, so there is
no manuscript `F_<LABEL>` claim to refute.

### Precise theorem

Use all the objects, quantifiers, and hypotheses of `sew:chain`, including
exactness, degree-one lifts, the uniform bound on \(a'_j\), and the
compatibility \(\phi_j=\phi_{j+1}F_j\). Write vector norms in maximum norm
and matrix norms in its induced operator norm. Set
\[
\begin{split}
 N&=8(A+2),& K&=1024N^6,& c_0&=64,\\
 s_0&=h/2,& \rho_0&=r/2,&
 d&=\min\{1/4,h/(32c_0),r/(32c_0)\},\\
 e_*&=d^7/(1024K),&&& b&=r/4 .
\end{split}                                                    \tag{1}
\]
 Here \(A\geq0\) is automatic from the manuscript's derivative bound on
 a nonempty parameter disc.
 Then \(0\leq e<e_*\) suffices for the theorem. These deliberately
conservative constants are independent of every \(L_j\) and of the
cardinality of the chain. For a finite chain the same construction applies
with missing Fourier tails set to zero; its glued domain has the
corresponding finite ends, not an asserted entire-cylinder conclusion.

For the passive-parameter extension, let \(T\) be any complex manifold.
Allow the charts and transition functions to depend jointly holomorphically
on \(t\in T\), with all hypotheses and bounds holding uniformly for every
\(t\). Symplecticity and immersion refer to the active \((w,p)\) variables
on each \(t\)-slice. The construction below gives
\(\Phi:\mathbb C\times\Delta_{r/4}\times T\to M\), jointly holomorphic
and periodic, with the same active-coordinate bounds. No bound on
passive derivatives or compactness of \(T\) is asserted.

## 1. Adversarial algebra and exactness

Put \(\lambda=p\,dw\) and \(X_H=(H_p,-H_w)\). Then
\(d\lambda=-dw\wedge dp\), and
\[
 \mathcal L_{X_H}\lambda=d(pH_p-H).                              \tag{2}
\]
Consequently Hamiltonian flows are exact with this sign convention.
For \(J(w,p)=(w+a(p),p)\),
\[
 J^*\lambda-\lambda=p\,a'(p)\,dp
   =d\left(p\,a(p)-\int_0^p a(\zeta)\,d\zeta\right).             \tag{3}
\]
Thus \(E=J^{-1}F\) is exact whenever \(F\) is exact. The dependence
of \(a\) on \(p\) does not spoil exactness.

There is a tempting but incorrect shortcut in which a Hamiltonian vector
field is merely evaluated at \(J\). The manuscript does **not** take that
shortcut. With \(Q=G\circ J\), the actual identity is
\[
 \begin{split}
 Q_w&=G_w\circ J,\\
 Q_p&=G_p\circ J+a'(p)G_w\circ J,\\
 (DJ)^{-1}(X_G\circ J)
   &=(G_p\circ J+a'G_w\circ J,-G_w\circ J)=X_Q .
 \end{split}                                                    \tag{4}
\]
The extra horizontal term is precisely what cancels; it does not
produce a transverse remainder. The universal identity is checked with
independent symbols for \(a'\), \(G_w\), and \(G_p\), not at selected
numerical values.

The adversarial exact family used by the script is
\[
 z=e^{kw},\quad k=2\pi i n,\quad n\in\mathbb Z\setminus\{0\},
 \qquad E=(w,p+\epsilon z),\qquad J=(w+a_0+sp^2,p).
\]
For \(F=JE=(W,P)\), direct differentiation gives
\[
 \det DF=1,\qquad
 F^*\lambda-\lambda
   =d\left(\frac{2s}{3}(p+\epsilon z)^3+\frac{\epsilon z}{k}\right).
                                                                    \tag{5}
\]
All parameters are symbolic. This probes the problematic interaction of a
nonzero Fourier mode with a genuinely transverse-dependent shear.
It is a local identity test, not a purported chain satisfying every global
chart-image hypothesis. On buffered domains its error can be arbitrarily
small. No admissible counterexample emerged; the proof in Sections 2-7,
rather than this family, settles the unrestricted assertion.

The competing constant transverse drift \(E=(w,p+c)\) has
\[
 E^*\lambda-\lambda=c\,dw .
\]
For \(c\ne0\) it fails exactness and cannot refute `sew:chain`. More
generally, periods of degree-one symplectic coordinate changes are additive:
if transitions have periods \(D_j\) and changes have periods \(c_j\), a
zero-period normal form requires
\[
                       c_{j+1}-c_j=D_j.                         \tag{6}
\]
Uniformly bounded small changes have bounded \(c_j\). Thus a constant
nonzero period cannot be hidden in uniformly bounded changes along a
bi-infinite chain. This is a period obstruction, not an admissible
counterexample to the exact theorem. Equation (6) also checks the
recentering sign; it does not certify the separate geometric center choices.

## 2. Removing the only linear transverse obstruction

Here and in the next sections a margin loss \(\delta\) is allocated a
fixed finite number of times; the whole step loses at most \(64\delta\).
Always \(0<\delta<1\). For a periodic, mean-zero holomorphic function \(f\)
define
\[
                 \mathcal P f(w,p)=\int_0^1 t f(w+t,p)\,dt .
\]
Integration by parts gives \((\mathcal P f)_w=f\); its mean is zero,
it is holomorphic, and \(\|\mathcal P f\|\leq\|f\|/2\).
This explicitly avoids any primitive growing with a block length.

For \(E=(w+u,p+v)\), symplecticity and zero period give
\[
 u_w+v_p=-u_wv_p+u_pv_w,\qquad
               v_0=-\int_0^1 v u_w\,dw .                        \tag{7}
\]
The term \(p u_w\) integrates to zero. A coordinate Cauchy estimate
after a loss \(\delta\) gives
\(\|v_0\|\leq e^2/\delta\), and one further parameter loss gives
\(\|v_0'\|\leq e^2/\delta^2\). Both bounds are independent of height
because a holomorphic periodic function's mean is independent of the
horizontal representative.

Take \(H=\mathcal P(-v+v_0)\). Since \(\|v_0\|\leq e\) even
before using (7), \(\|H\|\leq e\). It has mean zero and
\[
 H_w=-v+v_0,\qquad
 (u-H_p-u_0)_w=-u_wv_p+u_pv_w-v_0'.                             \tag{8}
\]
The last right-hand side has zero mean. Applying \(\mathcal P\)
again bounds \(u-H_p-u_0\) by \(3e^2/(2\delta^2)\).
Since \(\delta<1\), in maximum norm
\[
 (u,v)=(u_0,0)+X_H+R,\qquad
            \|H\|\leq e,\quad \|R\|\leq2\delta^{-2}e^2.         \tag{9}
\]
This proves `sew:linearize`, with its required finite margin losses.
Exactness has eliminated the linear transverse mean, not the horizontal
mean \(u_0(p)\), which is an allowed change of model translation.

## 3. Uniform Fourier splitting, including parameter dependence

At any stage suppose
\[
 |\operatorname{Im}a_j+L_j|\leq\kappa<1/4,\qquad |a_j'|\leq A+1.
\]
Use exactly the slanted domains \(D_j(s,\rho)\) of the manuscript.
For \(T_j=-H_j\), continue \(w_{l+1}=w_l+a_l(p)\) and set
\[
 G_j=\sum_{l\geq j}T_l^-(w_l,p)-\sum_{l<j}T_l^+(w_l,p).         \tag{10}
\]
The positive and negative Fourier parts have their usual one-sided
holomorphic continuations outside the original seam.

For negative frequencies use the coefficient line
\(\operatorname{Im}w_l=L_l+s-\delta/4\).
For positive frequencies use \(L_l-s+\delta/4\).
At a point of \(D_j(s-\delta,\rho)\) the distances in the favorable
directions are respectively at least
\[
 3\delta/4+(1-\kappa)(l-j),\qquad
 3\delta/4+(1-\kappa)(j-1-l).                                  \tag{11}
\]
For the nearest terms these are the upper and slanted lower inequalities
defining \(D_j\). Each more distant term adds an intervening length
\(L_l\) minus an error of magnitude at most \(\kappa\); hence it adds
at least \(1-\kappa\). No upper length bound occurs.

Put \(g=1-\kappa\geq3/4\). The absolute majorant for either tail is
\[
 e\sum_{n\geq1}\sum_{q\geq0}
     e^{-2\pi n(3\delta/4+gq)}
 \leq
 \frac{11e}{9}\frac{1}{e^{3\pi\delta/2}-1}
 \leq \frac{22e}{81\delta}.                                    \tag{12}
\]
For completeness, \(2\pi gn\geq9/2\) and
\(e^x\geq1+x\) imply
\((1-e^{-2\pi gn})^{-1}\leq11/9\); also \(\pi\geq3\).
The two tails together are at most \(44e/(81\delta)<e/\delta\).
These rational constants, rather than a truncated double sum, are checked
by the script.

Thus (10) converges normally and is holomorphic in \((w,p)\).
Its two common tails cancel in \(G_j-G_{j+1}J_j\), leaving
\(T_j^-+T_j^+=-H_j\). This proves the splitting equation for the
infinite chain, not just for finite partial chains.

A point of \(D_j(s-\delta,\rho-\delta)\) has an active-coordinate
polydisc of radius \(\delta/N\) in \(D_j(s,\rho)\).
Indeed a displacement of that size changes the slanted inequality by
at most \((1+A+1)\delta/N=\delta/8\); the upper edge and disc
inequalities have still larger buffers. Coordinate Cauchy estimates on
successive such buffered domains therefore give
\[
 \|G_j\|\leq\delta^{-1}e,\quad
 \|X_{G_j}\|\leq N\delta^{-2}e,\quad
 \|DX_{G_j}\|\leq4N^2\delta^{-3}e.                              \tag{13}
\]
The diagonal second derivatives cost a factor two, and the two entries
in a row give the harmless factor four.

This proves `sew:split`. In particular, differentiating a long partial sum
of the functions \(a_l(p)\) is neither necessary nor used: normal
convergence gives a bounded holomorphic \(G_j\), and Cauchy's formula
estimates its derivatives on the same local slanted geometry.

## 4. A quantitative, domain-valid Newton step

Assume for this step
\[
                        K\delta^{-7}e\leq1/1024 .              \tag{14}
\]
Reserve a total loss \(64\delta\). One possible allocation, in units of
\(\delta\), is: 6 for (7)-(9), 2 for splitting, 4 for Cauchy estimates,
8 for positive and negative flows, 4 for compositions, 4 for moving
the slanted boundaries, and 36 unused buffer. At every use of a
Cauchy estimate its polydisc radius is \(\delta/N\), not \(\delta\);
this is already included in (13). The starting and ending margins
in Section 5 leave all these domains nonempty.

Let \(K_j\) be the time-one flow of \(X_{G_j}\). Put
\[
                 D=N\delta^{-2}e,\qquad
                 L=4N^2\delta^{-3}e .
\]
Since \(K\geq N^2\), (14) implies
\[
 D\leq\delta/(1024N),\qquad L\leq1/256 .
\]
The flow and its inverse are defined on the reserved domains, and
\[
 \|K_j-\mathrm{id}\|\leq D,\quad
 \|K_j-\mathrm{id}-X_{G_j}\|
                         \leq LD=4N^3\delta^{-5}e^2 .          \tag{15}
\]
These facts need no unquoted gluing or implicit-function theorem.
Picard iteration on paths in a polydisc of radius \(\delta/N\)
maps paths into that polydisc and contracts by at most \(L<1\).
Its iterates are holomorphic in the initial coordinates, and their
uniform limit gives the flow. Integrating
\(X(K_t)-X\) gives (15). Uniqueness gives the inverse negative-time
flow. Equation (2) proves exactness.

By (4), \(J_j^{-1}K_{j+1}J_j\) is the time-one flow of
\(Q_j=G_{j+1}J_j\). On a buffered seam \(\|Q_j\|\leq e/\delta\)
because the translated seam lies in the target \(D_{j+1}\).
The bounds (13)-(15) consequently apply to \(Q_j\) as well.
The first-order term of
\[
 \widehat E_j=J_j^{-1}K_{j+1}^{-1}J_j\,E_j\,K_j
\]
is, using \(G_j-Q_j=-H_j\),
\[
             (u_j,v_j)+X_{G_j}-X_{Q_j}=(u_{j,0},0)+R_j .        \tag{16}
\]
This is the shear-conjugated cancellation being audited.

Here is an explicit remainder budget. The source flow contributes
\(4N^3\delta^{-5}e^2\). Composing \(E_j\) after that flow adds at
most \(N^2\delta^{-3}e^2\), since
\(\|D(E_j-\mathrm{id})\|\leq N\delta^{-1}e\).
The inverse \(Q_j\)-flow contributes another
\(4N^3\delta^{-5}e^2\).
Evaluating \(X_{Q_j}\) at the displaced point costs at most
\[
 4N^2\delta^{-3}e\,(D+e)\leq8N^3\delta^{-5}e^2 .
\]
Their sum is at most \(17N^3\delta^{-5}e^2\).
Adding (9) makes this at most \(19N^3\delta^{-5}e^2\).

Set \(J_j^{\rm new}(w,p)=(w+a_j(p)+u_{j,0}(p),p)\).
Since these shears commute,
\((J_j^{\rm new})^{-1}J_j\) is the shear by \(-u_{j,0}\).
Its use in normalizing \(\widehat E_j\) multiplies the last bound
by at most \(1+e/\delta\leq2\). Thus
\[
 \|(J_j^{\rm new})^{-1}K_{j+1}^{-1}F_jK_j-\mathrm{id}\|
 \leq38N^3\delta^{-5}e^2
 \leq K\delta^{-6}e^2 .                                       \tag{17}
\]
This proves `sew:newton-bound` with \(q=6\).

All compositions above are legitimate on the reserved domains.
The sum of a flow displacement, an \(E_j\) displacement, and another
flow displacement is less than one reserved \(\delta/N\) polydisc.
On the full blocks a flow changes a slanted boundary by at most
\((A+2)D\), while updating its model changes it by at most \(e\).
Their sum is less than \(\delta/4\), leaving the allocated boundary
buffer. Translated seams have the same buffer because their lower
inequality is exactly \(Y>L_j-s\). The other edge is at distance
at least \(1-\kappa-2s>1/2\). At most two adjacent charts are used.
The shear update changes \(|a_j'|\) by at most \(e/\delta\).
Exactness persists by (2)-(3) and pullback under compositions and
inverses. There is no error or loss proportional to \(L_j\) or to a
number of intervening charts.

## 5. All-index majorant and positive limiting width

The zero-error case glues immediately. Otherwise let
\[
 \delta_n=d2^{-n},\quad B=Kd^{-6},\quad
 \theta=64B e_0\leq d/16\leq1/64.
\]
Starting from the initial restricted domains, (17) implies
\[
 e_{n+1}\leq B2^{6n}e_n^2 .
\]
For \(x_n=B2^{6(n+1)}e_n\), this is exactly
\(x_{n+1}\leq x_n^2\), hence, for every integer \(n\geq0\),
\[
             e_n\leq B^{-1}2^{-6(n+1)}\theta^{2^n}.             \tag{18}
\]
This is an induction, not a finite iteration test. Moreover
\[
 K\delta_n^{-7}e_n
   \leq\frac{2^n\theta^{2^n}}{64d}
   \leq\frac{\theta(2\theta)^n}{64d}
   \leq\frac1{1024}.                                          \tag{19}
\]
Here \(2^n\geq n+1\), proved by induction. Thus (14) holds at
every step, justifying the induction and every domain inclusion used in it.

The total loss in either margin is
\[
 c_0\sum_{n\geq0}\delta_n=2c_0d\leq\min(h,r)/16.
\]
Consequently
\[
                  s_\infty\geq7h/16,\qquad
                  \rho_\infty\geq7r/16>r/4 .                  \tag{20}
\]
For explicit bounds on the model changes, (19) gives
\[
 \begin{split}
 \sum_{m\geq n}e_m&\leq\delta_n/512,\\
 \sum_{n\geq0}e_n/\delta_n&\leq d^6/(1008K)<1.
 \end{split}                                                   \tag{21}
\]
Thus
\[
 |\operatorname{Im}a_j^{(n)}+L_j|
 \leq h/8+d/512<h/3,\qquad |(a_j^{(n)})'|\leq A+1 .
\]
These are precisely the uniform translation bounds used in Sections 3-4.
There is no circular dependence on a translation derivative accumulated
over the chain.

For completeness, (18) implies convergence of
\(\sum_n\delta_n^{-k}e_n\) for every fixed \(k\).
The ratio of successive majorants is
\(2^{k-6}\theta^{2^n}\), which tends to zero.
For \(k\leq6\) the particularly simple bound is
\[
 \sum_n\delta_n^{-k}e_n
       \leq \frac{d^{6-k}}{64K}\frac{\theta}{1-\theta}.          \tag{22}
\]
These sums tend to zero with \(e_0\). Higher derivative estimates
can also be obtained directly by Cauchy's formula on any fixed further
smaller limiting domain, so a single threshold does not have to be
chosen separately for each derivative order.

## 6. Limit coordinate changes and their domains

Let \(D_j^n\) be the current slanted block domain and let
\(C_j^n=K_j^0K_j^1\cdots K_j^{n-1}\), with the rightmost map
applied first. Section 4 gives \(K_j^n(D_j^{n+1})\subset D_j^n\).
The initial \(D_j^0\) lies in the original chart domain: its lower
edge is above \(-h/2-h/8\), and its upper edge is below \(L_j+h/2\).
Its closure still has a fixed positive buffer in the original domain,
including the transverse buffer \(\rho_0=r/2<r\).

Put \(\widetilde a_j=\lim_n a_j^{(n)}\) and define
\(D_j^\infty\) using \(\widetilde a_{j-1},s_\infty,\rho_\infty\).
The tail in (21) is smaller than the remaining margin
\(s_n-s_\infty=2c_0\delta_n\).
Hence \(D_j^\infty\subset D_j^n\) for every \(n\), with enough
buffer for the compositions; the fact that the lower edges move
does not invalidate the common limiting domain.

From the variational equation of a flow,
\[
 \|DK_j^n-I\|\leq2(4N^2\delta_n^{-3}e_n).
\]
By (19),
\[
 S:=\sum_n8N^2\delta_n^{-3}e_n
          \leq N^2d^4/(120K)\leq1/120 .
\]
Thus the derivatives of the finite compositions are bounded by
\(\prod_n(1+\|DK_j^n-I\|)\leq e^S\leq120/119<2\).
Integrating along the \(n\)-th flow path gives
\(\|C_j^{n+1}-C_j^n\|\leq2N\delta_n^{-2}e_n\).
The sum converges by (22), uniformly in \(j\). This proves
convergence of \(C_j^n\) to \(C_j\), not just convergence of an
uncomposed sequence of small corrections.

Uniform convergence and coordinate Cauchy integrals prove joint
holomorphicity and convergence of derivatives on smaller domains.
Every finite composition is symplectic, so
\(\det DC_j=1\). Its differential therefore never degenerates.
The derivative's distance from the identity is at most
\(e^S-1\leq1/119<1/4\).
In particular \(C_j\) is injective on the convex lifted core
\[
                \{h/2<Y<L_j-h/2\}\times\Delta_{r/4}.
\]
This core is contained in \(D_j^\infty\), since
\(s_\infty-h/3\geq5h/48>0\). The derivative bound proves
injectivity by integrating along line segments; periodicity then
gives injectivity on the cylinder core as well. This supplies genuine
small changes of variables on blocks with fixed positive end margins.

Set \(\widetilde\phi_j=\phi_jC_j\).
Passing to the limit in the exact chart identities on each fixed
buffered seam gives
\[
 \widetilde\phi_j(w,p)=
       \widetilde\phi_{j+1}(w+\widetilde a_j(p),p).              \tag{23}
\]
No uniform bound on derivatives of the original \(\phi_j\) is required:
the passage to the limit is local for each fixed chart. Uniform
smallness refers to the coordinate changes and the model-translation
changes, as in the manuscript statement. Equations (21)-(22)
and Cauchy's formula give exactly their claimed approximation and
fixed-order derivative conclusions.

## 7. Global coverage, with no uniformization assumption

Define \(\sigma_0=0\) and
\(\sigma_{j+1}=\sigma_j+\widetilde a_j\) in both directions.
Only finite sums define each \(\sigma_j\), so they are holomorphic
even though their derivatives need not be uniformly bounded as
\(|j|\) tends to infinity. Write \(w_j=w+\sigma_j(p)\) and
\[
                         B_j(p)=L_j-\operatorname{Im}\sigma_j(p).
\]
If \(c_{j-1}=L_{j-1}+\operatorname{Im}\widetilde a_{j-1}\),
then the exact edge identity is
\[
                   B_j-B_{j-1}=L_j-c_{j-1}\geq1-h/3.           \tag{24}
\]
Thus \(B_j\) tends to the two opposite infinities as \(j\) does,
locally uniformly in \(p\) (in fact the displayed lower spacing
bound is uniform on the whole common disc).

In the global coordinates, \(D_j^\infty\) is precisely
\[
 \Omega_j=\{B_{j-1}(p)-s_\infty<\operatorname{Im}w
                         <B_j(p)+s_\infty,\quad |p|<\rho_\infty\}.
                                                                    \tag{25}
\]
These sets cover the full cylinder times \(\Delta_{\rho_\infty}\),
and the cover is locally finite. Since
\(2s_\infty\leq h<1-h/3\), nonadjacent sets are disjoint.
The adjacent intersection is exactly the strip of width \(2s_\infty\)
around \(B_j(p)\), namely the surviving seam where (23) holds.
Consequently the holomorphic maps
\(\widetilde\phi_j(w+\sigma_j(p),p)\) glue without any further
cocycle or nonadjacent-overlap condition.

Each shear preserves \(dw\wedge dp\), so the glued pullback of
\(\omega\) is \(dw\wedge dp\). This proves immersion.
All the maps and corrections are degree one and periodic, so lifting the
global cylinder coordinate gives the required period-one map on
\(\mathbb C\times\Delta_{r/4}\). Equations (24)-(25) prove full
global domain coverage even for arbitrarily large individual \(L_j\).
This completes the proof of `sew:chain`.

## 8. Passive parameters and the mathematical improvement

For a passive complex parameter \(t\), horizontal integration, the
unique mean-zero primitive, Fourier coefficients, normally convergent
Fourier tails, and Picard iterates are all jointly holomorphic.
Every estimate above is an active-coordinate estimate uniform in
\(t\). Limits are jointly holomorphic by the same Cauchy argument
on local parameter charts. The finite sums \(\sigma_j(p,t)\)
and the locally finite cover then give the passive-parameter extension
stated above. There is no new period in a passive direction to remove:
only relative symplecticity on the active cylinders is asserted.

Compared with the initial campaign state, which had no certified sewing
result, this supplies a complete uniform analytic proof rather than
finite-mode reassurance. Compared with the manuscript's asserted result,
it makes explicit the admissible radius, conservative smallness threshold,
all-stage domain inequalities, moving-limit-domain inclusion, and the
composition derivative product; it also proves the passive-parameter
version. The calculation confirms, rather than refutes, the manuscript's
shear-conjugated first-order cancellation.

The proof uses only coordinate Cauchy estimates, Fourier coefficients,
and elementary Picard and normal-convergence arguments explained here.
It does not invoke Chen--Gounelas, Xie--Zhao, a uniformization theorem,
or an external symplectic gluing theorem. It leaves all geometric
seam-supply and L-to-CAP claims in the proof graph open.
Whether this verification and parametric extension meet the campaign's
publishable/new-result bar is for independent review; a failed literature
lookup does not establish novelty.

## Replay

Run from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/sewing-audit/verify.py --json
```

The initial replay passed 146 exact checks. The saved Jacobian run
used `polynomial.map.jacobian`, server `0.14.0`, protocol `2025-11-25`,
via the required Argus adapter, exited zero, and returned a complete
typed result in `jacobian-output.json` bound to `jacobian-payload.json`.
No timeout, transport failure, or `UNKNOWN` outcome is treated as
mathematical evidence. The script replays that saved output; it does
not start another adapter run.

`exact_certificate.json` records hypotheses, quantifiers, constants,
manuscript correspondence, the two adversarial probes, and the limits of
mechanical verification. In particular neither the script nor the
certificate asserts independent Reviewer acceptance or a kernel proof
of complex analysis.
