# A nongraded surface-cone obstruction, including its equality boundary

## Result and certification boundary

**Theorem.** Let X be a smooth integral projective surface over C, and let
H be an ample globally generated integral divisor. Put

\[
 h=H^2,\quad T=\bigoplus_{j\geq0}H^0(X,\mathcal O_X(jH)),\quad
 R=\widehat{T_{T_{>0}}}.
\]

If R has a nonzero finite maximal Cohen--Macaulay module, then

\[
                         K_X^2-2c_2(X)<6h.                 \tag{T}
\]

In particular, the non-strict conclusion of the staged manuscript's
`thm:obstruction` follows. Since the intersection numbers are integers,
(T) also gives \(K_X^2-2c_2(X)\leq6h-1\).
The strict conclusion comes from modifying at slope width **at least** one,
rather than only width greater than one. Nothing else is strengthened by
assumption. For a module of R-rank one the same proof gives the stronger
non-strict inequality \(K_X^2-2c_2(X)\leq3h\).

This is a proof of the geometric implication, with a kernel-checked
universally quantified algebraic core. It is not a finite search and not
an assertion that a nongraded module is graded or descends to an Ulrich
sheaf. The geometry below is a prose proof using the explicit standard
results in `sources/READINGS.md`; Lean does **not** formalize schemes,
coherent sheaves, the cited surface theorems, or their application.
Independent Reviewer acceptance of those parts and of statement fidelity
is still required. No false literal assertion in the staged proof has
been established by this investigation, so there is no invented
`F_<LABEL>` refutation.

The source is
`research/openai_manuscript/A-Complete-Local-Domain-Without-a-Small-Cohen-Macaulay-Module-September-23-2026/build/paper.tex`.
The relevant anchors are `thm:obstruction`, Sections `sec:cone`,
`sec:balancing`, `sec:lattice`, `sec:numerical`, and Lemmas `lem:balance`,
`lem:lattice`, `lem:factor`. The proof below explicitly checks the
compatibility of those sections; it does not take their disputed
conclusions as external assumptions.

## 1. The model and the actual nongraded module

Choose three sections of O_X(H) with no common zero. This is possible
successively: avoid components of the first section's divisor, and then
avoid the finite intersection of the first two divisors. They give a
morphism f:X -> D=P^2 with f^*O_D(1)=O_X(H). It is finite: a
positive-dimensional projective fiber would contain a curve on which an
ample line bundle has degree zero. Properness and quasi-finiteness imply
finiteness by [S10]. It is surjective, and deg(f)=h by intersecting the pullbacks
of two general lines.

Write S=C[x0,x1,x2], A=C[[x0,x1,x2]], with xi acting on T by the three
chosen sections. Surjectivity of f implies injectivity S -> T. The
projection formula identifies T with the nonnegative graded sections of
the coherent sheaf f_*O_X on P^2, so T is finite over S
([S1], Lemma 30.14.1(5)). T is a domain: a rational trivialization of H
embeds it in C(X)[t]. If homogeneous S-generators have degrees at most a,
the ideal b=(x0,x1,x2)T satisfies

\[
 b^j\subset T_{\geq j},\qquad T_{\geq j+a}\subset b^j.
\]

Thus
\[
 T\otimes_S A=\prod_{j\geq0}T_j=\widehat{T_{T_{>0}}}=R.       \tag{1}
\]

Here completion of finite modules and flatness are [S2] and [S3].
The two filtrations are cofinal. Also T/b is a finite-dimensional graded
C-algebra with degree-zero part C, so its unique homogeneous maximal
ideal is nilpotent and rad(b)=T_{>0}. These facts justify the localization
and completion in (1). Products of the lowest nonzero homogeneous terms
show that R is a domain. The geometric-series inverse of an element
with nonzero constant term shows that R is local, with residue field C.
The finite injection A -> R makes dim R=3.

Let V0=Tot(O_D(-1)) be the blow-up of affine three-space at the origin,
and W0=X x_D V0=Tot(O_X(-H)). Base-change both along S -> A, obtaining
g:W -> V and p:W -> Spec R. The map g is finite. The zero sections
X in W and D in V are effective Cartier divisors. Their ideals J and I
satisfy

\[
 J=I O_W,\qquad J|_X=O_X(H),\qquad I|_D=O_D(1).             \tag{2}
\]

The positive signs in (2) are **conormal** signs, not normal-bundle signs.
Flatness of S -> A preserves the Cartier nonzerodivisors.

For completeness, this construction needs no degree-one generation of T.
On X_i={s_i != 0}, which is affine as a finite inverse image of the
standard affine in D, clearing poles along s_i=0 gives

\[
 T[1/s_i]=\Gamma(X_i,O_{X_i})[s_i,s_i^{-1}].
\]

For example a regular function on X_i has bounded pole order along its
complement; X is normal, so absence of poles elsewhere suffices for
extension. This identifies W0 minus X with the cone minus its vertex,
and the identification persists after base change. Consequently

\[
 W\setminus X=\operatorname{Spec}R\setminus\{\mathfrak m\},
 \qquad
 V\setminus D=\operatorname{Spec}A\setminus\{\mathfrak m_A\}. \tag{3}
\]

V and W are proper over Spec A, since V0 is a blow-up and W0 -> V0 is
finite. At a point of their closed fibers, the quotient by the Cartier
equation is a regular local ring of D or X. If B/(t) is regular and t
is a nonzerodivisor in a Noetherian local ring B, then B is regular:
lift generators of the quotient maximal ideal and adjoin t to bound the
embedding dimension by dim(B/(t))+1=dim B. This proves regularity along
the fibers. Every point specializes to the closed fiber: its closure is
proper over the local base and its nonempty closed image contains the
closed point. A local ring at a generization is a localization of the
local ring at that specialization. Thus V and W are regular everywhere.
Their regular irreducible components are disjoint; all meet the integral
closed fiber, which can meet only one of these open-and-closed
components. Therefore both models are integral.

This also gives normality of R without assuming it: a finite affine
cover of the separated W0 has affine intersections, and flat base change
of the kernel computing global sections gives

\[
 \Gamma(W,O_W)=\Gamma(W0,O_{W0})\otimes_S A=T\otimes_S A=R.
\]

Global functions on an integral normal scheme are integrally closed in
their fraction field: an integral rational function lies in every
integrally closed local ring, and hence is everywhere regular.

Now let M be a nonzero finite MCM R-module. Its support has dimension
three because depth is three. A proper closed subset of Spec R has
dimension at most two: any chain in V(q), q != (0), can be lengthened
by the zero prime of the domain. Hence M has full support. The xi are a
system of parameters, so they are M-regular by [S4]. M has depth three
as an A-module and is A-free by [S5]:

\[
                              M\simeq A^N,\quad N>0.        \tag{4}
\]

There was no choice of a grading on M. The finite-dimensional domain
R tensor_A Frac(A) is a field; (4) shows that the R-generic rank r of M
is positive. The depth localization inequality [S6] gives

\[
 \operatorname{depth}M_q
 \geq 3-\dim(R/q)\geq\dim R_q.
\]

The last comparison follows by concatenating chains of primes, not by an
unstated equidimensionality or catenarity assumption. By (3), R_q is
regular for q != m. Applying [S5] locally shows that the actual
restriction of M to the puncture is a vector bundle.

Set E=(p^*M)^{**}. On the regular W this is coherent and torsion-free,
and it agrees with that vector bundle off X. Its restriction P=E/J E
is torsion-free on X, even though it need not be locally free.
Here is the local argument, rather than a blanket assertion that
restriction preserves torsion-freeness. Over a regular local domain B,
any coherent dual is the kernel of a map between finite free modules.
The image is torsion-free, hence has depth at least one whenever
dim B>=1; the depth lemma [S11] gives depth at least min(2,dim B) for the
dual. Apply this to E, itself a dual. At every nongeneric point of X,
dim B>=2 and the Cartier equation is E-regular. Thus E/tE has depth at
least one there by [S12]. Its only possible associated point on the integral X
is the generic point, which is exactly torsion-freeness. At that point
B is a DVR and E is free of rank r, so P has positive rank r.
The depth argument is essential: the torsion-free ideal (t,x) in
C[t,x,y] has restriction at t=0 with presentation
C[x,y]^2/((-x,0)), whose first generator is nonzero and killed by x.
This negative control does not refute the manuscript, which starts
with a double dual rather than an arbitrary torsion-free extension.

Finally g_*E is torsion-free on V: a nonzero local function on V is
nonzero on the integral dominant W, so it acts injectively on E.
Its restriction off D is the bundle obtained from the A-module in (4),
and is therefore O^N. This establishes every input used in the next
two sections.

## 2. A strict-width extension without losing the punctured trivialization

For any nonzero torsion-free B on X put
\[
                 \mu(B)=c_1(B)H/(\operatorname{rk}(B)h).
\]
The Harder--Narasimhan filtration exists in this setting. One can prove
the needed existence directly: embed B in a sum of sufficiently positive
line bundles by dualizing a generating surjection for B^*(mH).
Such a surjection follows from [S1]: apply generating twists to f_*B^*
on P^2, pull back the surjection, and use the surjective multiplication
counit f^*f_*B^* -> B^* for the finite affine map f. Increase the common
twist so all summands have the same twist.
Taking determinants bounds subsheaf degrees above; their slope
denominators are at most rank(B)h, so a maximal slope exists. Among
maximal-slope subsheaves choose maximal rank and saturate. Saturation
does not lower degree, and the quotient is torsion-free. A quotient
subsheaf of slope at least this slope would lift to a subsheaf with
larger slope or the same slope and larger rank, a contradiction.
Induction on rank yields semistable torsion-free factors with strictly
decreasing slopes. This is also the usual proof of the filtration; we
do not assume that P itself is semistable.

Suppose the current P has slope width at least one. Let G be its last
semistable quotient and B the kernel. Form on W

\[
                 E'=\ker(E\longrightarrow i_*G).
\]

This is a coherent torsion-free subsheaf of E and equals E off X.
The exact two-term Cartier resolution
0 -> J -> O_W -> O_X -> 0 gives

\[
 \operatorname{Tor}_1^W(E,O_X)=0,\qquad
 \operatorname{Tor}_1^W(i_*G,O_X)=G\otimes J|_X=G(H).
\]

Thus the long exact Tor sequence, **including** its first term, yields

\[
                   0\longrightarrow G(H)\longrightarrow P'
                        \longrightarrow B\longrightarrow0,
 \qquad P'=E'|_X.                                        \tag{5}
\]

No flatness of G over W is assumed. Both ends of (5) are torsion-free
on the integral X, so P' is torsion-free of the same rank r. This
justifies every repetition of the operation; reflexivity or local
freeness of E' is not needed thereafter.

The maximum slope of an extension of two torsion-free sheaves is at
most the larger of their maximum slopes: intersect any subsheaf with
the kernel and use its image in the quotient. Since
\[
 \mu_{\max}(G(H))=\mu_{\min}(P)+1\leq\mu_{\max}(P),
\]
(5) does not increase the maximum slope. Notice that **equality**
causes no problem here. On the other hand
\[
                   \mu(P')=\mu(P)+\operatorname{rk}(G)/r
                            \geq\mu(P)+1/r.               \tag{6}
\]
Every average slope is bounded by the initial maximum slope. An
infinite sequence of operations would contradict (6), since its
averages would exceed that fixed upper bound after more than
r(mu_max(P_initial)-mu(P_initial)) steps. This is the Archimedean
argument formalized by `no_infinite_modifications`.

The process therefore stops with width delta<1, not just delta<=1.
All the while E remains torsion-free, P remains torsion-free of rank r,
and the actual punctured bundle is unchanged. Hence g_*E continues to
be torsion-free and trivial off D. This is the required simultaneous
preservation assertion.

The strict-width phenomenon is not a new claim about optimal extensions:
Chen--Sun already obtain width in [0,1) in their analytic setting.
Our use here is the explicit algebraic proof (5)--(6), valid on the
Noetherian Cartier model just constructed, without importing an analytic
extension theorem with different hypotheses.

## 3. Divisor lattices: actual restriction, including torsion layers

Let L'=g_*E and L=O_V^N, using its fixed punctured identification.
Clearing denominators on a finite affine cover gives
I^b L subset L' subset I^(-b)L for some b. Tensoring L' by I^b makes

\[
                        I^{2b}L\subset L'\subset L.        \tag{7}
\]

Its restriction F to D is changed to F(b). This does not change
v(F)=2 ch_2(F)/N-(c_1(F)/N)^2, by the usual twist formula, valid for
coherent sheaves as well as bundles. At the generic point of D the
Cartier local ring is a one-dimensional regular local domain, so L'
is free of rank N there. Thus F always has rank N.

One can also perform this normalization on the same extension, rather
than merely its pushforward: replace E by E tensor J^b. Since J=g^*I,
the finite projection formula gives g_*(E tensor J^b)=(g_*E) tensor I^b.
Its restriction is P(bH), its factors are G_i(bH), and every factor
slope shifts by the same integer b. Torsion-freeness, rank, width<1,
the punctured bundle, and each pushforward variance are unchanged.
Thus the lattice-character data and the balanced factor data can
literally refer to the same sheaf, as in `full_numeric_obstruction`.

Let Q=L/L' and Q_j=I^jQ/I^(j+1)Q. The filtration is finite by (7).
The map I^j L -> I^j Q is surjective; passing to the indicated
quotients shows that
\[
                         O_D(j)^N\twoheadrightarrow Q_j.  \tag{8}
\]
For n_j=rank(Q_j) and d_j=c_1(Q_j), (8) implies
\[
                         0\leq n_j\leq N,\qquad d_j\geq jn_j. \tag{9}
\]
To see the second assertion without discarding torsion, Q_j(-j) is
globally generated, as is its quotient by its torsion subsheaf.
The determinant of that torsion-free quotient has a nonzero section
(take the wedge of generically independent generating sections).
Its first Chern class is therefore effective. The divisorial first
Chern class of the torsion subsheaf has the nonnegative generic
lengths of its one-dimensional support as coefficients; its
zero-dimensional part has first Chern class zero. Additivity gives
(9), including n_j=0.

There is a finite-Tor-dimension restriction map G_0(V) -> G_0(D):
\[
 [B]\longmapsto
 [B\otimes O_D]-[\operatorname{Tor}_1^V(B,O_D)].
\]
It is additive by the long exact Tor sequence and has no higher Tor,
because O_D has the two-term Cartier resolution. This observation is
important: one must not simply restrict a quotient filtration and
assume exactness. For a sheaf Q_j supported on D the Tor term is
Q_j(1). For L and L' it is zero, since the divisor equation is a
nonzerodivisor on a torsion-free sheaf. Applying this map first to
0 -> L' -> L -> Q -> 0 and then to the filtration of Q gives

\[
              [F]=[O_D^N]+\sum_j([Q_j(1)]-[Q_j])
                        \quad\text{in }G_0(D).            \tag{10}
\]

This proof of (10) allows singular L', singular F, and arbitrary
coherent quotient layers; no omitted Tor vanishing for Q or Q_j is
being used. If ch(Q_j)=(n_j,d_j,z_j), then
\[
                  \operatorname{ch}(Q_j(1)-Q_j)
                               =(0,n_j,d_j+n_j/2).
\]
In particular z_j cancels, including contributions from
zero-dimensional torsion. Consequently
\[
 c_1(F)=\sum_j n_j,\qquad
 2\operatorname{ch}_2(F)=\sum_j(2d_j+n_j)
                         \geq\sum_j(2j+1)n_j.             \tag{11}
\]

For any finite sequence of real numbers 0<=n_j<=N, with indices
starting at zero, the following is an exact identity:
\[
\begin{split}
 N\sum_j(2j+1)n_j-\left(\sum_j n_j\right)^2
   =\sum_j n_j(N-n_j)
       +2\sum_{j>\ell}n_j(N-n_\ell)\geq0.                 \tag{12}
\end{split}
\]
Zero ranks and nonmonotone ranks are allowed. The identity follows by
expanding, since there are exactly j integers ell with 0<=ell<j.
An independent all-length induction is kernel-checked in
`layer_quadratic_nonneg`: with S=sum_{j<k}n_j the next defect differs
by n_k((2k+1)N-2S-n_k), which is nonnegative because S<=kN.
Combining (11)--(12) and N>0 proves
\[
                                v(F)\geq0.                \tag{13}
\]

Finally, the finite affine map g has exact pushforward and restriction
commutes with its pushforward in this situation:
\[
 (g_*E)/I(g_*E)=g_*(E/JE)=f_*P.                            \tag{14}
\]
This can be checked on affine rings; it does not assume g is flat.
The first equality uses J=I O_W from (2). Thus the F in (13) is
**precisely the pushforward of the modified P**, not the restriction
of its reflexive hull or of the original unmodified module.
Its rank is simultaneously N and rh, the latter by generic finite
pushforward under f. Therefore N=rh and
\[
                                v(f_*P)\geq0.             \tag{15}
\]
Equations (5)--(6), (9)--(10), and (14) are where the potentially
incompatible sheaf hypotheses are actually reconciled.

## 4. Surface upper bound and the strict conclusion

For a torsion-free semistable factor G of P, set
\[
 u=\operatorname{rk}G,\quad k=K_XH,\quad
 m=\frac{c_1(f_*G)}{uh},\quad q=\frac{\operatorname{ch}_2(f_*G)}{uh}.
\]
Finite pushforward is exact and preserves Euler characteristics.
Together with the projection formula, Riemann--Roch [S7] on the two
smooth surfaces gives, for every integer t,
\[
\begin{split}
 \tfrac12t^2+(\tfrac32+m)t+1+\tfrac32m+q
 &=\tfrac12t^2+\left(\mu(G)-\frac{k}{2h}\right)t\\
 &\quad+\frac{\chi(O_X)}h+
       \frac{\operatorname{ch}_2(G)}{uh}
       -\frac{c_1(G)K_X}{2uh}.
\end{split}                                               \tag{16}
\]
For clarity, we apply Riemann--Roch to the smooth structure maps
X -> Spec C and P^2 -> Spec C, **not** a smooth-morphism theorem to
the ramified finite f. Every coherent sheaf on a smooth projective
surface has a finite locally free resolution: take successive
surjections from sums of negative twists; the second syzygy is locally
free by [S11] and [S5]. Indeed, at a regular local ring of dimension
d<=2, the first kernel has depth at least min(d,1), and the second
at least d, so [S5] makes the second kernel free. Zero kernels require
no application of a depth lemma with nonzero-term hypotheses. Generating
twists are obtained as above (or from a projective embedding). This extends the
locally free formula [S7] additively to G and f_*G. Consequently no
local-freeness assumption on either sheaf is hidden in (16).

The linear term gives
\[
                    m=\mu(G)-k/(2h)-3/2.                  \tag{17}
\]
Equating constants and completing the square gives the universally
checked identity
\[
 v(f_*G)=\tfrac14+\frac{2\chi(O_X)}h+
 \frac{2\operatorname{ch}_2(G)/u-c_1(G)K_X/u}{h}
 -\left(\mu(G)-\frac{k}{2h}\right)^2.                      \tag{18}
\]

Bogomolov [S8] applies because X is smooth projective over C, H is ample,
and G is torsion-free and slope-semistable. It states
2u ch_2(G)<=c_1(G)^2. Changing the normalization of all slopes by the
same positive h does not change semistability. Put
C=c_1(G)/u-K_X/2 in NS(X)_Q. The final two terms of (18) are at most
\[
 \frac{C^2-K_X^2/4}{h}-\frac{(CH)^2}{h^2}
                              \leq-\frac{K_X^2}{4h}.       \tag{19}
\]
The last inequality is the Hodge index theorem [S9], extended from
integral to rational classes by clearing denominators. No
Neron--Severi rank-one condition is involved. Substituting Noether's
formula 12 chi(O_X)=K_X^2+c_2(X), obtained from [S7] at O_X, yields
\[
              v(f_*G)\leq\tfrac14-
                         \frac{K_X^2-2c_2(X)}{12h}.        \tag{20}
\]

Let G_i be all the HN factors, u_i their positive ranks, w_i=u_i/r,
and m_i as in (17). Finite pushforward is exact. Additivity of Chern
characters and ranks, rather than a splitting of P, proves
\[
 v(f_*P)=\sum_iw_i v(f_*G_i)
                   +\sum_iw_i(m_i-\bar m)^2,\quad
 \bar m=\sum_iw_i m_i.                                    \tag{21}
\]
By (17) the m_i have exactly the same width delta<1 as the HN slopes.
For any nonnegative weights summing to one and values in [a,b],
the weighted variance is at most (b-a)^2/4: bound the weighted square
distance to the interval midpoint, then subtract the square of the
distance of the mean to that midpoint. This is kernel-checked for an
arbitrary finite index type and arbitrary weights, not just two
factors. In particular the variance V in (21) is strictly less than
1/4. Combining (15), (20), and (21) gives
\[
 0\leq v(f_*P)\leq\tfrac14-
              \frac{K_X^2-2c_2(X)}{12h}+V,\qquad V<\tfrac14.
\]
Since h>0, this is (T). More quantitatively the proof gives
\[
                  K_X^2-2c_2(X)\leq(3+3\delta^2)h.
\]
If r=1, P has one HN factor, V=0, and the rank-one assertion follows.
This completes the proof, with none of grading, Ulrich descent,
semistability of the whole restriction, or the desired lower Chern
bound assumed at any stage.

## 5. Prior results, what is new here, and unresolved review work

The inherited Wiki index was searched for this manuscript, Cohen--Macaulay
modules, nongraded cones, and divisor lattices; no relevant prior project
page was found. Focused primary-source retrieval distinguished the
following comparisons (details and availability are in the readings).

Chen--Sun, arXiv:1808.02172v1, Theorem 1.4(I), already prove optimal
width in [0,1) for reflexive analytic extensions on the blow-up of a
ball, with conormal twisting in Proposition 2.6. Those hypotheses are
not silently substituted for this completed-cone problem.

Anghel, arXiv:2609.15589v1, Theorems 1.1 and 1.3, exclude graded
MCM modules under the sharper numerical condition K^2-2c2>3H^2.
The present domain of modules is larger: arbitrary finite modules
over the vertex completion. Its weaker constant six must not be
advertised as a numerical improvement of that graded bound.

Liang Chen, arXiv:2609.24142v1, Main claim 1.1, proposes a completed-local
obstruction under K numerically equivalent to 4H; its Consequence 1.2
is explicitly conditional on that proposed claim. This proof assumes
neither that claim nor the proportionality condition.

The later Anghel survey arXiv:2610.30027v1, Theorem 8.2, repeats the
non-strict constant-six obstruction and attributes it to this OpenAI
manuscript; it is not an independent antecedent. Theorem 10.3 states
a higher-dimensional analogue. The focused lookup found no matching
strict constant-six statement. That is bounded negative retrieval,
**not** a proof of global novelty.

Relative to the staged theorem and these comparators, this deliverable
adds an explicit equality-boundary strengthening and a fresh Lean
4.31.0 certification of the all-length, all-rank algebra behind the
nongraded proof. The full geometric implication is proved above, not
left as an assumption of the formal arithmetic. Nevertheless the
geometric proof, all source attributions, the natural/formal reading,
and any publishability or priority claim still require the independent
Reviewer. They have not been marked reviewer-confirmed by Engineer.

## 6. Reproduction and exactly what the executable certificate proves

From the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/nongraded-obstruction/verify.py
```

The verifier checks symbolic identities over Q with free symbols,
including the arbitrary-index induction step for (12), conormal
twist signs in (10), cancellation of arbitrary layer ch_2, (18),
the Hodge-square rearrangement, Noether substitution, and the
mean/variance identities. Its finite adversarial cases are explicitly
regressions, not the proof of universal inequalities. It checks that
the archived genuine Lean compiler and axiom-audit verdicts are zero,
have no proof holes, bind the present formal source and fidelity text,
and are still attached to `C_NG_ALG`. It also replays the typed Jacobian
result and its exact payload; the single operation only encloses a
normalized nonnegative defect factor on [0,1]^2 and proves no sheaf
theorem. The universal inequalities themselves are the Lean theorems,
not inferred from these finite cases or this Jacobian operation.

In particular `factor_upper_bound` carries the complete scalar
Bogomolov/Hodge/Noether inequality step. `full_numeric_obstruction`
then derives the lower and upper variance inequalities from all finite
layer and factor data, without assuming either v>=0 or the final
obstruction. This is stronger evidence than an assembly theorem that
takes the disputed lattice inequality as an input; the necessary
identification of those data with the actual modified sheaf is proved
in Sections 1--4 above.

`--write-certificate` generates `exact_certificate.json` from those
measurements; the default run reproduces and compares it. `--check-project`
also invokes both official checkers on the absolute current campaign
root, records their actual exit codes, and requires both to be zero.
This checks ledger/graph structure, **not** mathematical truth or
Reviewer acceptance.

To recompile rather than validate the archived compiler evidence:

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/nongraded-obstruction/Main.lean --statement-fidelity research/nongraded-obstruction/statement_fidelity.md --artifact-dir research/nongraded-obstruction/lean --project-root . --claim C_NG_ALG
```

The source and its reading were unchanged after the successful compile.
No new Lake workspace was created and the prebuilt Mathlib workspace was
used. Only the current final compiler record supplies evidence; earlier
failed elaborations do not. Neither failed computation nor an unavailable
publisher endpoint was counted as a mathematical refutation.
