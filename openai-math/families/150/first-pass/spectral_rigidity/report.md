# Spectral endpoint rigidity on a flat triangle double

## Statement and scope

The target is Proposition `prop:rigidity` in the October 5, 2026
weak-mixing manuscript. On the regular oriented double of any fixed
nondegenerate Euclidean triangle, for every real lambda and every bounded
measurable eigenfunction of the almost-everywhere geodesic flow, prove

    Xf = i lambda f,  Yf = 0,
    ||grad f||_2^2 = lambda^2 ||f||_2^2.

There is no irrational-angle hypothesis in this proposition. The
irrational-angle hypothesis belongs to the later exclusion of nonconstant
billiard eigenfunctions. All derivatives and tests here are on the regular
surface, not across a cone tip.

## Scope findings established before the verification

1. `OBJECTIVE.md` and `sections/introduction.tex`, Theorem `thm:main`,
   concern the full Liouville flow and its self-product, not a directional
   flow on a rational unfolding.
2. Forni--Moll, *Cohomological equation for geodesic flows on flat
   surfaces*, arXiv:2510.18128v1, Section 3.4 and Corollary 4.2, use the
   completed horizontal Sobolev space H^(1,0). Their corollary assumes
   that membership; it is not a measurable-eigenfunction regularity
   theorem. Their proof uses square summability of coefficient
   derivative norms. Importing that corollary before proving transverse
   regularity would not establish the target. The staged weak-mixing
   manuscript acknowledges this distinction rather than making that
   import.
3. The submitted argument instead uses `lem:energy`, `lem:smoothing`,
   and `lem:bounded-modes`, followed by `eq:tail-equation`,
   `eq:endpoint-identity`, and two successive weak limits in
   `sections/rigidity.tex`. At scope, these are obligations, not
   independently verified facts.

The local Wiki index and a targeted title/description search contained no
prior billiard or Forni--Moll result applicable to this step. No claim of
novelty follows from that local search.

## Result and evidential distinction

The proof below establishes the proposition, including its endpoint
identity, without assuming square-summable coefficient gradients,
transverse regularity, or any extension of an operator across a cone tip.
It also gives the L2 strengthening in Section 10. This is an independent
proof verification and a strengthening, not a counterexample. No false
literal assertion in the staged manuscripts has been established by
this investigation. In particular, the failed direct use of
Forni--Moll is a retired approach, not an error attributed to a manuscript
that expressly avoids it.

The exact polynomial identities, an arbitrary-length induction, and the
finite-tail index partition have executable certificates in `verify.py`.
`Main.lean` separately certifies the spectral telescoping and endpoint
algebra in Lean 4.31.0 with no proof holes. Neither program certifies the
analytic arguments about measurable sets, smoothing, or weak convergence.
Those arguments are proved below and require independent human review.
No independent Reviewer acceptance or verified-new novelty determination
is asserted.

## 1. Geometric and functional-analytic setup

The completion of the oriented triangle double is compact and has three
Euclidean cone points of positive, finite angles. Write \(r\) for distance
to this finite set. Near a tip of angle \(\omega\), the area of its radius
\(t\) disk is \(\omega t^2/2\). Thus, for each fixed \(L\),
\(\bar A\{r<L\epsilon\}=O_L(\epsilon^2)\).
All constants below can depend on the fixed triangle and on \(\lambda\);
none is claimed uniform as the triangle degenerates.

Almost every geodesic is complete in both time directions. A finite-time
incomplete unit-speed path has a limit in the compact completion. If the
limit is regular, a Euclidean chart continues it. At a cone tip, develop
the lift of its final cone segment into the plane. A straight line ending
at the origin is radial, so the final segment has constant lifted polar
angle. It cannot have infinitely many seam crossings. A compact regular
segment likewise cannot have accumulating transverse crossings, since in
a local chart both the geodesic and the seam are straight. Geodesics
along a seam have measure zero. Consequently a vertex hit has a finite
side itinerary; for each of the countably many itineraries, unfolding
makes a vertex hit a straight-line incidence with a fixed point. Its
directions form a null set at almost every initial position. Fubini and
a countable union prove the assertion.

On the resulting full-measure invariant regular set, the flow preserves
normalized Liouville measure, because it is locally translation at fixed
direction. Its inverse is the negative-time map. Composition is strongly
continuous in L2: this first follows for continuous compactly supported
regular functions by dominated convergence and then for all L2 functions
by their density and unitarity.

Folding the two copies back onto the triangle, with the corresponding
local isometry on tangent vectors, sends straight seam crossings to
specular reflections. The two sheets have equal area, and a reflection
preserves uniform angular measure. Thus folding pushes normalized
Liouville measure to the billiard measure and intertwines every regular
time map. This verifies the factor assertion recorded as `L_DOUBLE`,
although the proposition itself is a statement on the double.

In oriented flat charts set
\[
 \partial=(\partial_{x_1}-i\partial_{x_2})/2,\quad
 \bar\partial=(\partial_{x_1}+i\partial_{x_2})/2,\quad
 A=X-i\lambda.
\]
Then
\[
 X=e^{i\theta}\partial+e^{-i\theta}\bar\partial,\qquad
 Y=i e^{i\theta}\partial-i e^{-i\theta}\bar\partial .
 \tag{1}
\]
The two fields commute, preserve volume locally, and have formal adjoints
\(X^*=-X\), \(Y^*=-Y\), \(A^*=-A\) on compact regular tests. A chart
rotation by \(\phi\) changes \(f_j\) by \(e^{-ij\phi}\),
\(\partial f_j\) by \(e^{-i(j+1)\phi}\), and
\(\bar\partial f_j\) by \(e^{-i(j-1)\phi}\). Hence all pairings below
are between sections of the same unitary line bundle.

The eigenfunction hypothesis implies \(Af=0\) locally. Indeed,
\(\langle f,\varphi\circ\Psi_{-t}\rangle
=e^{i\lambda t}\langle f,\varphi\rangle\);
differentiate at zero for a compact regular smooth test. Its support
has a regular neighborhood where the differentiation is classical.
No assertion about a cone-tip domain is involved.

We use the following elementary Hilbert-space facts. They introduce no
extra regularity hypotheses. L2 on this second-countable finite-volume
bundle and the coefficient-section L2 spaces are separable. A bounded
sequence has a weakly convergent subsequence: diagonalize its coordinates
against a countable orthonormal basis; the limiting coordinate functional
is bounded by the original norm bound and is represented by its
square-summable coordinates. Distributional derivatives are closed under
weak L2 convergence of functions and derivatives, by testing and
integration by parts against compact regular tests. Smooth compact
regular tests are dense, by truncating the cone neighborhoods and using
local coordinate mollifiers and a partition of unity.

Angular Parseval applies first on local trivializations and then globally,
since transition factors are unitary. Its completeness follows, for
example, by approximating circle functions by their Fejer sums: continuous
functions have uniformly convergent Fejer approximants, and continuous
functions are dense in circle L2. Orthogonal projection then gives the
L2 Fourier expansion and Parseval. The same argument applies to
Hilbert-valued coefficients, using finite simple tensors.

## 2. Localized spectral energy, with the correction sign

Let \(w\) be spatially smooth with values in angular L2 and have compact
regular spatial support. Its spatial derivatives are all in L2, so the
Fourier coefficients and their differentiated series are square summable.
Compact regular integration by parts gives
\[
 D_j:=\|\partial w_j\|_2^2
     =\|\bar\partial w_j\|_2^2
     =\tfrac14\|\nabla w_j\|_2^2 .
 \tag{2}
\]
This equality is used only for such compactly supported functions, not
silently extended to the eventual uncut coefficients.

Put \(C_j=\operatorname{Re}\langle i\lambda w_{j+1},
\partial w_j\rangle\). From (1),
\[
 D_j-D_{j+2}
 =R_j+C_j-C_{j+1},\qquad
 R_j=\operatorname{Re}\langle(Aw)_{j+1},
                   \partial w_j-\bar\partial w_{j+2}\rangle .
 \tag{3}
\]
The nontrivial spectral sign is
\[
 \operatorname{Re}\langle i\lambda w_{j+1},\bar\partial w_{j+2}\rangle
 =\operatorname{Re}\langle-i\lambda\partial w_{j+1},w_{j+2}\rangle
 =C_{j+1}.
\]
In the last equality one conjugates the scalar pairing; its real part
does not change. Inner products are linear in the first entry throughout.

Summing (3) over every integer from \(m\) through \(N\) yields
\[
 \sum_{j=m}^N R_j
 =D_m+D_{m+1}-D_{N+1}-D_{N+2}-C_m+C_{N+1}.
 \tag{4}
\]
This is not a parity sum. The two high D terms and the high C term
tend to zero by the square summability already available for \(w\).
The R series is absolutely convergent by Cauchy--Schwarz. If \(Aw\)
vanishes off the part over a measurable base set \(E\), Parseval over
that same base set and
\[
 \sum_{j\ge m}|\partial w_j-\bar\partial w_{j+2}|^2
 \le 2\sum_j(|\partial w_j|^2+|\bar\partial w_j|^2)
 =\sum_j|\nabla w_j|^2
\]
bound the absolute R sum by \(\|Aw\|_2\|1_E\nabla w\|_2\).
Finally
\[
 |C_m|\le|\lambda|\|w_{m+1}\|_2\sqrt{D_m}
 \le D_m/2+\lambda^2\|w_{m+1}\|_2^2/2.
\]
Consequently
\[
 D_m/2+D_{m+1}\le
 \|Aw\|_2\|1_E\nabla w\|_2+
 \lambda^2\|w_{m+1}\|_2^2/2.                 \tag{5}
\]
This proves `lem:energy` with its exact constant and sign.

## 3. Smoothing and individual coefficient regularity

On a fixed positive-radius circle in each model cone, compactness supplies
a uniform embedded-chart radius. Scaling gives an embedded disk of radius
at least \(c r(x)\) near the tip; compactness away from the tips gives the
same needed conclusion there. Choose fixed \(K>2\) large enough for
embedded disks of radius \(4\epsilon\) whenever
\(r>(K-2)\epsilon\).

Let \(S_\epsilon\) be convolution at fixed parallel angle with a
nonnegative radial mass-one kernel supported in the epsilon disk,
defined for \(r>K\epsilon\). Radiality makes it independent of the
oriented chart. Derivatives are taken before zero extension. For every
integer \(k\ge0\), kernel scaling and Fubini give
\[
 \epsilon^k\|\nabla^k S_\epsilon u\|_{L^2(r>K\epsilon)}
 \le C_k\|u\|_2,\qquad
 \epsilon^k\|\nabla^k S_\epsilon u\|_\infty
 \le C_k\|u\|_\infty.                       \tag{6}
\]
For completeness, the squared L2 estimate at a center is at most
\(C_k\epsilon^{-2}\) times the angular L2 mass in its epsilon disk.
For a fixed sampled point, its possible centers lie in an embedded
O(epsilon)-disk of area \(O(\epsilon^2)\). Integrating centers gives
(6). Parallel transport preserves angular measure. At order zero
positivity gives the sharper L-infinity contraction with constant one.

Local constant-coefficient differentiation gives commutation with
\(X,Y,A\), also for distributions by testing. Approximate-identity
convergence holds for smooth compact regular inputs; density and the
uniform L2 bound extend \(S_\epsilon u\to u\) to each fixed L2 input,
including the zero extension near the tips.

If \(u=0\) for \(r<L\epsilon\), where \(L>K+4\), the Lipschitz bound
for \(r\) implies \(S_\epsilon u=0\) for
\(K\epsilon<r<(L-1)\epsilon\). Its extension is therefore smooth
through the artificial boundary \(r=K\epsilon\), has compact regular
spatial support, and has no boundary distribution there. If also
\(Au\in L2\), local commutation gives
\[
 A S_\epsilon u=S_\epsilon Au              \tag{7}
\]
globally on the regular bundle. Both sides vanish in the omitted
neighborhood, because the local derivative of a zero distribution is zero.

Now let \(|h|\le H\) and \(Ah=0\) only locally in distributions.
Choose a smooth spatial cutoff \(\chi_\epsilon\), zero for
\(r\le(K+1)\epsilon\), one for \(r\ge(K+2)\epsilon\), and with
gradient bounded by \(C/\epsilon\). For small epsilon its three
transition annuli \(E_\epsilon\) are disjoint. The compactly supported
field \(v_\epsilon=\chi_\epsilon S_\epsilon h\) obeys
\[
 Av_\epsilon=(X\chi_\epsilon)S_\epsilon h,\quad
 \|Av_\epsilon\|_2+
 \|1_{E_\epsilon}\nabla v_\epsilon\|_2\le CH .
\]
Indeed each pointwise bound is \(CH/\epsilon\) on area
\(O(\epsilon^2)\). Also \(\|v_\epsilon\|_2\le H\), because the
measure is normalized. Apply (5) with \(E=E_\epsilon\) to obtain
\[
 \|\nabla(v_\epsilon)_j\|_2\le C_\lambda H
 \quad\hbox{for all integers }j.           \tag{8}
\]
The approximate identity and shrinking cutoff region give
\(v_\epsilon\to h\) in L2. For each fixed \(j\), weak compactness,
local derivative testing, and lower semicontinuity pass (8) to \(h_j\).
This proves `lem:bounded-modes`. It does not assert summability over
\(j\), equality of the two uncut complex-derivative norms, or any
cone-tip trace condition.

## 4. The full tail and its two boundary modes

For arbitrary \(m\in\mathbb Z\), set
\[
 U=\sum_{j\ge m}P_jf,\qquad b=\bar\partial f_m,\quad
 a=\partial f_{m-1},\quad
 B=b e^{i(m-1)\theta}-a e^{im\theta}.       \tag{9}
\]
The tail is in L2; it need not be bounded. By Section 3, \(B\) is
globally in L2. For every \(N\ge m+2\), the mode recurrence
\(\partial f_{j-1}+\bar\partial f_{j+1}=i\lambda f_j\) gives
\[
 A\sum_{j=m}^N P_jf
 =B-(\bar\partial f_{N+1})e^{iN\theta}
       +(\partial f_N)e^{i(N+1)\theta}.     \tag{10}
\]
One can check this for every integer output index by the seven
exhaustive regions \(j<m-1\), \(j=m-1\), \(j=m\),
\(m<j<N\), \(j=N\), \(j=N+1\), \(j>N+1\). These regions,
including their mask inequalities for arbitrary indices, are checked
symbolically in `verify.py`; they are not a sample of tail lengths.

The two upper terms in (10) are bounded in L2 uniformly in \(N\) by
(8). Their pairings with a fixed L2 field are at most a constant times
its norms in angular modes \(N,N+1\), which tend to zero by Parseval.
They therefore tend weakly to zero. The finite tails tend strongly
to \(U\), so local testing yields
\[
 AU=B.                                    \tag{11}
\]

## 5. Safe-segment averages and their support

Fix \(0<s<1\), then let epsilon decrease with \(T=s/\epsilon\).
Choose \(L>K+4\). Let \(G_\epsilon\) contain the regular states whose
whole forward segment of length \(T\) stays in \(r>L\epsilon\).
This is measurable: along a regular compact segment \(r\) is continuous,
and its minimum can be expressed using a countable dense set of times.
Because \(r\) is 1-Lipschitz along unit-speed paths, a mesh with spacing
at most epsilon detects any visit to \(r\le L\epsilon\) at some mesh
point in \(r\le(L+1)\epsilon\). There are at most \(T/\epsilon+2\)
mesh points. Measure preservation and the cone area formula give
\[
 \nu(G_\epsilon^c)\le C(T\epsilon+\epsilon^2)
                    =C(s+\epsilon^2).    \tag{12}
\]

Set
\[
 q_\epsilon=f1_{G_\epsilon},\qquad
 g_\epsilon=T^{-1}\int_0^T e^{i\lambda t}
                         q_\epsilon\circ\Psi_{-t}\,dt . \tag{13}
\]
The integral exists in L2 by strong continuity and as a measurable
bounded field by Fubini. Replacing \(q_\epsilon\) by \(f\) gives
exactly \(f\). Thus
\[
 \|g_\epsilon\|_\infty\le H,\quad
 \|g_\epsilon-f\|_2\le CH\sqrt{s+\epsilon^2},\quad
 Ag_\epsilon=T^{-1}
   (q_\epsilon-e^{i\lambda T}q_\epsilon\circ\Psi_{-T}),\quad
 \|Ag_\epsilon\|_2\le2H/T.                 \tag{14}
\]
For the derivative identity, change variables in a pairing with a
compact regular smooth test and integrate the exact derivative
\[
 \frac{d}{dt}\left(e^{i\lambda t}
                  \overline{\varphi(\Psi_tz)}\right)
 =e^{i\lambda t}\overline{(A\varphi)(\Psi_tz)}.
\]
The test and its horizontal derivative are bounded; finite-time Fubini
is legitimate. No derivative of the indicator is taken.

For every \(t\in[0,T]\), the support of
\(q_\epsilon\circ\Psi_{-t}\) is contained in
\(\Psi_tG_\epsilon\subset\{r>L\epsilon\}\), up to null sets.
Consequently both \(g_\epsilon\) and its residual in (14) vanish
over \(r<L\epsilon\). Define \(w_\epsilon=S_\epsilon g_\epsilon\).
By (6)--(7) this has compact regular spatial support and
\[
 \|w_\epsilon\|_\infty\le H,\quad
 \|Aw_\epsilon\|_2\le CH\epsilon/s,\quad
 \|\nabla w_\epsilon\|_2\le CH/\epsilon,\quad
 \|YAw_\epsilon\|_2\le CH/s .              \tag{15}
\]
All its higher spatial derivatives are in L2 for fixed epsilon.

## 6. First limit and admissibility of the transverse test

Keep \(s\) fixed. For every compact regular smooth \(\varphi\),
\[
 \langle YAw_\epsilon,\varphi\rangle
 =-\langle Aw_\epsilon,Y\varphi\rangle\longrightarrow0.
\]
The uniform-in-epsilon bound \(CH/s\) from (15) and density imply
\[
 YAw_\epsilon\rightharpoonup0\quad\hbox{in L2}. \tag{16}
\]
Explicitly, to test against any fixed \(u\in L2\), approximate it by
\(\varphi\); the pairing with \(u-\varphi\) is bounded by
\((CH/s)\|u-\varphi\|_2\). First let epsilon tend to zero and
only then improve that approximation. This argument makes no claim
uniform as \(s\downarrow0\).

It is legitimate to test (11) against \(Yw_\epsilon\). Its finite
angular Fourier sums are smooth compact regular tests and converge
to it both in L2 and in the graph norm of \(A\). Indeed, position
derivatives commute with angular truncation, and
\(\nabla Yw_\epsilon\in L2\) by the second spatial derivative bound.
The coefficients of \(X,Y\) depend on angle but not position, so
the first horizontal derivatives of these truncations also converge.
Passing the compact-test identity to the limit gives
\[
 \langle B,Yw_\epsilon\rangle
 =-\langle U,AYw_\epsilon\rangle
 =-\langle U,YAw_\epsilon\rangle
 \longrightarrow0.                       \tag{17}
\]
Here \(U\) is a fixed L2 field, and (16) is sufficient. Commutation
is local constant-coefficient commutation on compact regular support;
it asserts nothing about commuting unbounded operator extensions
across cone tips.

Equation (5), now with \(E=M\), and (15) give
\[
 \|\nabla(w_\epsilon)_j\|_2^2
       \le CH^2(s^{-1}+\lambda^2).         \tag{18}
\]
Choose a subsequence with \(w_\epsilon\rightharpoonup h_s\) in L2
and weakly convergent gradients of the four coefficients
\(m-2,m-1,m,m+1\). Local testing identifies these limits as the
corresponding gradients of \(h_s\). Moreover
\[
 |h_s|\le H,\quad Ah_s=0\ \hbox{locally},\quad
 \|h_s-f\|_2\le CH\sqrt{s}.                \tag{19}
\]
The L-infinity bound follows directly from weak L2 convergence:
\(|\langle h_s,\phi\rangle|\le H\|\phi\|_1\) for all L2 tests,
which by testing on measurable subsets forces \(|h_s|\le H\).
The local equation follows from \(Aw_\epsilon\to0\). For the
distance estimate use
\[
 w_\epsilon-f
 =S_\epsilon(g_\epsilon-f)+(S_\epsilon f-f),
\]
the uniform L2 operator bound, (14), and weak lower semicontinuity.

Only the four named coefficient gradients enter
\((P_{m-1}+P_m)Yw_\epsilon\). Since \(B\) has just those two
output modes, their weak convergence in (17) gives
\[
 \langle B,(P_{m-1}+P_m)Yh_s\rangle=0.    \tag{20}
\]
No bound on the full \(Yw_\epsilon\) survives or is needed.

## 7. Second limit and the endpoint identity

The estimate (18) diverges as \(s\downarrow0\) and is not used for
that limit. Instead (19) is an exact bounded local solution of
\(Ah_s=0\), precisely the hypothesis of Section 3. Reapply (8):
\[
 \|\nabla(h_s)_j\|_2\le C_\lambda H
 \quad(j\in\mathbb Z),                    \tag{21}
\]
independently of \(s\). Flow invariance of \(h_s\) is unnecessary.

Along any sequence \(s\downarrow0\), (19) gives strong L2 convergence
to \(f\). Pass to a subsequence on which the gradients of the same
four coefficients converge weakly. Local testing identifies each
limit with its derivative of \(f\). Since \(B\) is fixed in L2,
(20) passes to
\[
 \boxed{\langle B,(P_{m-1}+P_m)Yf\rangle=0.} \tag{22}
\]
At this point only the two modes of \(Yf\) in (22) are asserted
to be L2. This argument works for each arbitrary integer \(m\);
it does not require the same subsequence for different \(m\).

The order of these limits is essential to this proof. A diagonal
choice \(s=s(\epsilon)\downarrow0\) would destroy the uniform bound
used to extend compact-test convergence in (16) to the fixed
possibly nonsmooth tail \(U\). We do not make that shortcut.

## 8. Sharp endpoint algebra and horizontal regularity

The recurrence and (1) imply
\[
 (Yf)_{m-1}=-\lambda f_{m-1}-2ib,\qquad
 (Yf)_m=\lambda f_m+2ia.
\]
Set \(E_m=\|b\|_2^2+\|a\|_2^2\) and
\(M_m=\|f_{m-1}\|_2^2+\|f_m\|_2^2\).
With the specified inner-product convention, (22) reads
\[
 2iE_m=\lambda\bigl(\langle b,f_{m-1}\rangle+
                              \langle a,f_m\rangle\bigr). \tag{23}
\]
Cauchy--Schwarz in the direct sum of the two coefficient L2 spaces
therefore gives \(2E_m\le|\lambda|\sqrt{E_mM_m}\). This Hilbert
inequality follows from the nonnegativity of
\(\|z-tw\|^2\), with the minimizing scalar \(t\) when \(w\ne0\);
the zero vector case is immediate. If \(E_m>0\), divide by its
square root and square. If \(E_m=0\), the result is immediate. Thus
\[
 E_m\le\lambda^2 M_m/4.                   \tag{24}
\]
In particular, lambda zero is included without division by lambda.
The constant \(1/4\) is sharp as an algebraic implication: for scalar
data \(b=i\lambda v/2,\ a=i\lambda u/2\), both tested mode values
are zero and equality holds in (24). These scalar data are not
asserted to be a construction of a billiard eigenfunction.

For complex-valued weak coefficient derivatives, pointwise algebra
gives \(|\nabla f_j|^2=2(|\partial f_j|^2+
|\bar\partial f_j|^2)\). Summing nonnegative terms in (24), with
each coefficient mass appearing twice, gives
\[
 \sum_j\|\nabla f_j\|_2^2
 =2\sum_m E_m
 \le\lambda^2\|f\|_2^2.                  \tag{25}
\]
This is the first point where summability of uncut coefficient
gradients has been proved.

Angular partial sums of \(f\) now converge together with their
horizontal derivatives in L2. Parseval makes the derivative tails
Cauchy by (25); local testing identifies the limits as the weak
derivatives of \(f\). Rotation between the orthonormal directions
\(v,v^\perp\) and the spatial coordinates gives
\[
 \|Xf\|_2^2+\|Yf\|_2^2
 =\|\nabla f\|_2^2\le\lambda^2\|f\|_2^2.
\]
Since \(Xf=i\lambda f\), the first term already equals the right
side. Hence \(Yf=0\) and equality holds. This completes the proof
of the exact proposition for every real lambda, including zero,
with no irrational-angle or cone-tip-domain hypothesis.

## 9. What this settles, and what it does not

For the target proposition there is no analytic dependency left
unproved in this report: Sections 1--3 establish the geometric,
Hilbert-space, smoothing, and coefficient premises; Sections 4--7
establish the endpoint identity; Section 8 proves its consequence.
These are mathematical proofs, not automatically checked analytic
certificates. Their correctness is for the independent Reviewer to
assess.

The strongest prior result in the supplied scope was Sobolev rigidity,
which already assumed horizontal regularity and treated invariance.
Here bounded measurable eigenfunctions at arbitrary real frequency
acquire that regularity through (22)--(25). Relative to the staged
manuscript, the contribution is an independently expanded verification,
not discovery of the proposition. Neither the reflection argument nor
the compact-operator spectral criterion is recertified by this bounded
mission. Both manuscripts' other load-bearing claims remain separately
open in the proof graph.

A targeted external search returned no trustworthy additional primary
source for a prior measurable spectral theorem. Its generated summary
confused the transverse field Y with circle rotation and is not used.
The primary Forni--Moll statement was obtained and read directly.
Absence of a found source does not establish novelty.

## 10. L2 strengthening

The proposition remains true with \(f\in L2(SM)\) in place of
\(f\in L^\infty(SM)\), with the same spectral quantifiers and
conclusion. This is a consequence of the completed bounded theorem,
not an extra assumption in its proof.

For each positive integer \(N\), define
\[
 f^{[N]} =
 \begin{cases}
 f\min(1,N/|f|),& f\ne0,\\
 0,& f=0.
 \end{cases}
\]
This bounded radial truncation commutes with unit complex
multiplication. Thus \(f^{[N]}\) has the same flow eigenfrequency
and converges to \(f\) strongly in L2 by dominated convergence.
The bounded result implies, in every flat chart,
\[
 \nabla f^{[N]}=i\lambda v f^{[N]} .
\]
The right sides converge in L2 to \(i\lambda v f\). Closedness of
local distributional derivatives gives
\(\nabla f=i\lambda v f\) with global finite norm.
Consequently \(Yf=0\), \(Xf=i\lambda f\), and
\(\|\nabla f\|_2^2=\lambda^2\|f\|_2^2\).
No chain rule for a nonsmooth truncation was used. Novelty of this
strengthening has not been independently established.

## Reproduction and review boundary

From the campaign root:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/spectral_rigidity/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/spectral_rigidity/Main.lean --statement-fidelity research/spectral_rigidity/statement_fidelity.md --claim L_SR_ALGEBRA --project-root .
```

The first command replays exact symbolic identities, the universal
tail-index partition and induction, Jacobian's retained typed result,
and the source text and scope of the real compiler certificate. It
does not recompile Lean or test measurable functions numerically.
The second command is the real Lean replay and records its own
kernel evidence. After any ledger or graph mutation, run both official
campaign-local checks as required by the operator.

The independent Reviewer must read the analytic proof, the statement
fidelity document, and the L2 truncation argument, rather than infer
their correctness from an exit code. The Forni--Moll assumption
`S_SCOPE_FM/FM_COR42` is contextual, not a dependency of `C_SR`;
its independent citation attribution remains outstanding. The official
attribution command necessarily archives under `research/literature/`,
outside this mission's writable paths, so the Engineer has not invoked
that out-of-scope write or impersonated an independent reader. The
obtained primary excerpt is retained inside the authorized directory.
