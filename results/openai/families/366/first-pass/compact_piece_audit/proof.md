# Compact-piece exclusion: analytic proof and exact algebra

## Result and scope

Under exactly the hypotheses stated in Proposition `compact-piece`, the
proposition and all three lemmas in `interaction.tex` hold. The proof below
checks the compact Sobolev extensions, exterior normalization, finite-disk
comparisons, translation derivatives, arbitrary one-sided traces, and final
removal. No assumption-satisfying counterexample or load-bearing sign error is
established.

There is also a useful structural strengthening. A compact-support interaction
is harmonic on every allowed translation chamber under **local** square
integrability alone. An exact cutoff cancellation gives the variational
inequality for this interaction without a growth assumption. Under the source
growth hypothesis it equals the source's absolutely convergent interaction.
This supplies an independent derivation, not just numerical agreement with the
source. Moreover, the source growth bound follows directly from a circular
competitor; it need not be separately assumed for an absolute minimizer.

These are ordinary analytic proofs with an exact symbolic certificate for the
finite algebraic obligations. `verify.py` does **not** mechanically prove the
Sobolev, distributional, or harmonic-analysis arguments. No Lean formalization
or independent Reviewer verdict is claimed. Novelty is not claimed, and this
scoped result does not by itself complete the publishable campaign.

### Source map

All line references are to the staged file
[`interaction.tex`](../openai_manuscript/Interior-regularity-of-planar-Mumford-Shah-minimizers-September-24-2026/build/sections/interaction.tex).

| Source lines / label | Obligation | Proof here |
|---|---|---|
| 46-68, `prop:compact-piece` | Exact exclusion statement | Sections 3-9 |
| 90-154, `lem:compact-projection` | Projection, normalization, decay, field equations | Section 2 |
| 163-252, `lem:translated-comparison` | Admissibility, length cancellation, annular errors, polarization | Section 4 |
| 254-299, `lem:harmonic-interaction` | Translation Laplacian, minimum principle, all real amplitudes | Sections 5-6 |
| 311-342 | Cutoff product, gluing through A, global divergence, growth | Section 3 |
| 351-378, `eq:remove-projection` | Remove the potential without global L2 of G | Section 7 |
| 380-429, `eq:jump-flux` | Independent traces, orientation, planar rigidity | Section 8 |
| 430-440 | Vanishing fields and admissible removal | Section 9 |

The main regularity theorem, initial reduction, imported planar theory,
compact-isolation lemma, and weak-L4 equivalence have separate open ledger
claims. In particular this proof does not verify that a generalized limit has
the source's **full** `W^{1,2}(B_R \ H)` membership. Interior
`W^{1,2}_{loc}(R^2 \ H)` alone is not substituted for that hypothesis.

### Known inputs and prior work

The only imported analytic inputs are classical Sobolev calculus and harmonic
regularity/rigidity. The propositions actually read are:

* John K. Hunter, *Notes on Partial Differential Equations*, Chapter 3,
  Proposition 3.21(1),(3) and Theorem 3.24: product/change-of-coordinate
  formulas for weak derivatives and density of `C_c^\infty(R^n)` in
  `W^{k,p}(R^n)`, for integer k and `1 <= p < infinity`.
* The same notes, Chapter 2, the Weyl-lemma statement after Theorem 2.2:
  a harmonic distribution on an open set has a smooth harmonic representative;
  Theorem 2.15: a harmonic function attaining a global extremum on a connected
  open set is constant; Theorem 2.10 and Corollary 2.11: analyticity and
  determination by all derivatives at one point of a connected open set.

The source PDFs and extracted text are in `literature/hunter_ch2.*` and
`literature/hunter_ch3.*`. They were obtained from the author's
[Chapter 2](https://www.math.ucdavis.edu/~hunter/pdes/ch2.pdf) and
[Chapter 3](https://www.math.ucdavis.edu/~hunter/pdes/ch3.pdf); the author's
directory lists the revision as 18 June 2014. These lecture notes have no
versioned DOI or arXiv identifier supplied by that source. Their complete
prose citations, rather than an invented identifier, are recorded as
assumptions in the ledger. Independent citation confirmation remains the
Reviewer's responsibility. The relevant applications meet the hypotheses:
weak harmonicity first supplies smoothness, and every minimum/continuation
argument below is on a connected open domain.

The Hilbert projection and anchored Poincare arguments used below are included
explicitly. Sobolev gluing uses overlapping open collars, not an unproved
matching of normal derivatives.

For comparison, Deangelis, *Solution of the Mumford-Shah conjecture*,
[arXiv:2609.26732v1](https://arxiv.org/html/2609.26732v1), Proposition 3.1
and Section 3.2, already assert compact-piece exclusion for reduced generalized
global minimizers with connected complement and a proper compact relatively
clopen piece. That source was opened; a short excerpt is in
`literature/prior_art.txt`. Its argument uses relaxed second variations,
Hodge equality, and holomorphic separation. It is **not** a premise here.
The improvement in this verification is technical: Sections 5-6 replace a
noncompact pairing by a compact correlation, prove an exact cutoff
cancellation, and obtain harmonicity and constancy on the full translation
chamber. This is not a new global classification or verified-new literature
claim. No previously retired project route was present on entry.

## 1. Conventions and exact hypotheses

Write `curl a = d_1 a_2 - d_2 a_1` and
`grad_perp b = (-d_2 b, d_1 b)`. With these conventions

\[
 \Delta a=\nabla\operatorname{div}a+
                 \nabla^\perp\operatorname{curl}a,\qquad
 \langle\nabla^\perp T,a\rangle=-\langle T,\operatorname{curl}a\rangle.
 \tag{1}
\]

Translations are `a_t(x)=a(x-t)` and `A_t=A+t`. A first translation
derivative has a minus sign; a translation Laplacian has no sign change.
All crack sets in the proposition have zero planar area because they have
locally finite length. Integrands below are gradient densities, not the
distributional derivative of a discontinuous scalar function.

For the proposition assume H is closed, rectifiable, and locally finite length;
D is its connected complement; v belongs to `W^{1,2}(B_R \ H)` for every R;
all admissible compact set/value changes are allowed by absolute minimality;
and the stated linear energy bound holds. Suppose a prohibited A exists,
and set `B=H\A`, `O=R^2\B`. The compactness and separation hypotheses give a
cutoff `chi in C_c^\infty(O)` equal to one on a neighborhood of A. Empty B
is permitted throughout.

## 2. The projection lemma, including its normalization

Let A now be any compact zero-area set as in the lemma. The gradient density
`e=grad h` is L2 and compactly supported. The closure Z in the source is a
closed subspace of a Hilbert space, so the orthogonal projection Q exists.
For completeness, a sequence minimizing the distance to a closed subspace
is Cauchy by the parallelogram identity; its limit attains the distance.
Differentiating squared distance along each subspace direction gives
orthogonality. Orthogonality also gives uniqueness.

Every `z in Z` is the gradient of a globally defined locally Sobolev
potential. To see the potentially important two-dimensional constant issue,
choose smooth potentials `zeta_j` with gradients converging to z, and subtract
their averages on the fixed square `S_1=(-1,1)^2`. On a larger square S_R,
the elementary square Poincare inequality and the zero average on S_1 give

\[
 \|u\|_{L^2(S_R)}\leq C_R\|\nabla u\|_{L^2(S_R)}
 \quad\text{if }\fint_{S_1}u=0.                       \tag{2}
\]

The square inequality follows by writing the difference between two values
as two coordinate-line integrals, applying Cauchy-Schwarz, and integrating
over both endpoints. To obtain (2), first subtract the average on S_R,
and bound that average by averaging `u-u_{S_R}` on S_1. Apply (2) to
differences of the normalized potentials. They converge in W1,2 on every
fixed square; the limits agree on overlaps. Apply this to `z=Qe` to obtain
phi with `grad phi=Qe`. At this point phi is unique up to a constant.

For every smooth compact whole-plane test zeta,

\[
 \int(e-\nabla\phi)\cdot\nabla\zeta=0.
\]

Consequently `Delta phi=div e` and `div p=0`, where `p=e-grad phi`.
Off A, `p=grad(h-phi)` weakly, so `curl p=0` there. Equation (1) gives
the last asserted field equation. All these statements are distributions
on the whole plane, with no assertion that the jump derivative of h
vanishes.

Outside a disk containing the support of e, phi is harmonic by Weyl's
lemma. It is a single-valued scalar function with finite Dirichlet energy.
Its angular Fourier coefficients solve

\[
 u_n''+r^{-1}u_n'-n^2r^{-2}u_n=0.
\]

They are a constant plus a log term for n=0, and combinations of `r^n`
and `r^{-n}` for n>=1. For a cosine or sine mode
`(a r^n+b r^{-n})`, its radial-plus-angular energy density, integrated
over the angle, is

\[
 2\pi n^2(a^2r^{2n-1}+b^2r^{-2n-1}).
 \tag{3}
\]

Orthogonality makes these nonnegative contributions add. Thus finite
exterior energy excludes every growing mode and the log term, whose
energy is proportional to `integral dr/r`. It leaves a constant and
decaying modes. Subtract the constant. Smooth Fourier data on any fixed
exterior circle, followed by termwise differentiation of the geometrically
convergent series outside twice that radius, give

\[
 \phi=O(r^{-1}),\qquad \nabla^k\phi=O_k(r^{-1-k}).
 \tag{4}
\]

A function with the same gradient differs by a constant on the connected
plane, so tending to zero fixes the normalization uniquely. On any bounded
ball, `F=h-phi` belongs to the required Sobolev space and has gradient p.
Outside the support of h, `F=-phi`, proving all source decay claims.
Neither F nor phi is claimed to belong to global L2: an `r^{-1}` tail
need not be square integrable in two dimensions.

## 3. The split in the proposition is legitimate

Let m be the gradient density of v. For every smooth compact ambient psi,
`v+s psi` is an admissible same-set comparison for both signs of s,
including when its support meets H. The linear coefficient of the
finite-domain energy difference is zero. Therefore

\[
 \operatorname{div}m=0\quad\text{on the whole plane}.       \tag{5}
\]

The product `h=chi v` belongs to `W^{1,2}(R^2\A)` after extending it by
zero near B. Indeed, the compact support of chi has positive distance
from B. On that support the only possible obstruction is A; elsewhere
the product is identically zero on an open neighborhood. The product
rule gives an L2 gradient and the full-ball L2 hypothesis on v gives an
L2 value. On overlapping open collars these definitions agree as
Sobolev functions. Locality of weak derivatives, or a partition of unity
in a distributional test, glues them. There is no new jump at a boundary
of the cutoff support.

Apply Section 2, and define `f=(1-chi)v+phi` on O. On a neighborhood of A,
`f=phi`; away from A the product formula applies. The same open-overlap
argument shows `f in W^{1,2}(B_R\B)` for every R, with

\[
 v=f+F\text{ off }H,\qquad G=m-p=\nabla f\text{ a.e. on }O.
 \tag{6}
\]

The a.e. qualification uses the zero area of A. Equations (5) and
`div p=0` give `div G=0` globally, hence f is weakly, then smoothly,
harmonic on O. In particular `supp curl G subset B`. Also

\[
 \int_{B_R}|G|^2\leq 2C(1+R)+2\|p\|_2^2.                 \tag{7}
\]

D is connected and dense, and `D subset O subset closure D`, so O is
connected. To check this elementary topological step, in a separation of
O the connected set D would lie on one side, whereas every nonempty
relatively open other side must meet D by density.

## 4. The source finite-disk comparison and its errors

Choose a translation disk whose closed, slightly enlarged disk still
keeps A_t disjoint from B. For fixed t and real sigma let
`w=F_t-F+sigma P_t`, and let eta_R be one near the closed ball B_R,
zero near the exterior of B_2R, with derivative bounded by a constant/R.
Take R so large that A, A_t, and the supports of h, h_t and h'_t lie
strictly inside B_R. Use

\[
 J=B\cup A_t,\qquad V_R=v+\eta_R w,
 \tag{8}
\]

with its inside formula understood as `f+F_t+sigma P_t`. This inside
formula is Sobolev off J. On the gluing annulus the old and new compact
pieces are absent, so `H=J=B` there and the outer formula is Sobolev
off J. The formulas agree on open collars where eta_R is respectively
one or zero. This proves full local W1,2 membership, including the
interfaces. J is closed, rectifiable and locally finite length.

The symmetric set difference lies in `A union A_t`, and the value
difference is essentially supported in the closed ball B_2R. Choose a
slightly larger bounded open comparison disk. Lengths cancel there
exactly: B is common, A_t is disjoint from B, and its length equals that
of A. No preservation of exterior separation is being silently imposed.

For fixed t,sigma, the exterior estimates give on the annulus

\[
 |w|\leq C(1+|\sigma|)R^{-1},\quad
 |\nabla w|\leq C(1+|\sigma|)R^{-2},\quad
 \|\nabla(\eta_R w)\|_2\leq C(1+|\sigma|)R^{-1}.
 \tag{9}
\]

The L2 factors follow from the annulus area being O(R^2).
The absolute Dirichlet error on the annulus is bounded by

\[
 2\|m\|_2\|\nabla(\eta_Rw)\|_2+
       \|\nabla(\eta_Rw)\|_2^2
 =O((1+|\sigma|)R^{-1/2})+
       O((1+|\sigma|)^2R^{-2}).                          \tag{10}
\]

All constants here are for fixed t and fixed h,h'; the argument does
not require uniformity as sigma tends to infinity. First pass to the
limit for each fixed sigma; the resulting inequality holds for every
real sigma.

On a dyadic annulus of radius s, (7) and the decay of p_t,q_t give
L2 bounds `O(s^{1/2})` and `O(s^{-1})`. Thus the integrals of their
absolute products are `O(s^{-1/2})`. The dyadic series converges, and
bounded-set products are L1 by Cauchy-Schwarz. This proves the source
absolute convergence, without assuming that G is globally L2.

In the inner disk the two gradients are `G+p_t+sigma q_t` and `G+p`.
Polarization, translation invariance of all the L2 pairings of p,q,
and (10) give exactly

\[
 0\leq 2(I_p(t)-I_p(0))+
       2\sigma(I_q(t)+\langle p,q\rangle)+
       \sigma^2\|q\|_2^2.                              \tag{11}
\]

Every energy comparison made before the limit is finite. Infinite
whole-plane energies of m or G have not been subtracted.

## 5. A growth-free compact-correlation theorem

**Theorem (compact-support div-curl interaction).** Let A be compact, B
closed, and let `e in L2(R^2;R^2)` have compact support and distributional
curl supported in A. Let `G in L2_loc(R^2;R^2)` satisfy `div G=0`
globally and `supp curl G subset B`. Then

\[
 \mathcal J_e(t)=\int G(x)\cdot e(x-t)\,dx
 \tag{12}
\]

is continuous, and is harmonic on
`U=R^2\(B-A)={t:A_t intersects B is empty}`. Neither a growth bound nor
global square integrability of G is needed.

**Proof.** On each compact t-set all the translated supports of e lie
in one fixed compact x-set. Cauchy-Schwarz and continuity of translations
in L2 give finiteness and continuity of (12). Put `E(x)=e(-x)`; the
interaction is the sum of the two distributional convolutions `G_i*E_i`.
E is compactly supported, so these convolutions and all derivatives are
well defined even though G need not be tempered.

For vector distributions a,b with one compactly supported, commutation
of convolution and derivatives gives the two-dimensional identity

\[
 \Delta\sum_i a_i*b_i
       =(\operatorname{div}a)*(\operatorname{div}b)
          +(\operatorname{curl}a)*(\operatorname{curl}b).
 \tag{13}
\]

To justify, expand the right side. The two diagonal derivative terms for
each `a_i*b_i` give its Laplacian; the four mixed terms cancel in pairs.
For distributions this follows from the same calculation tested against
a compact smooth function; compactness of one factor permits the
convolution definition and transfer of each derivative. Alternatively,
mollify both factors locally and pass in distributions. Thus no product
of two distributions at a point is used.

Here `div G=0`, and `curl E=-(curl e)(-x)` is supported in -A.
The support of a convolution is contained in the sum of the supports;
this follows directly by testing on a neighborhood disjoint from that
sum. The sum `B-A` is closed because A is compact. Consequently the
Laplacian of (12) is supported in `B-A`. Weyl's lemma makes the
continuous interaction harmonic on U. This proves the theorem.

This theorem is stronger in its field hypotheses than the source
harmonicity statement. It does not assert a global minimum or constancy
without a variational hypothesis.

### Exact finite-cutoff cancellation

In the variational setting of Sections 3-4 set `e=grad h`, `e'=grad h'`.
For every admissible t, not just small ones, (8) is an admissible
comparison for sufficiently large R. Write

\[
 \Psi=\phi_t-\phi+\sigma\phi'_t,\quad
 d=p_t-p+\sigma q_t,\quad
 d_R=\nabla_{\rm density}(\eta_R w).
\]

Because eta_R equals one near every compact h-support,

\[
 d_R=e_t-e+\sigma e'_t-\nabla(\eta_R\Psi).                \tag{14}
\]

The last potential is a compactly supported whole-plane W1,2 function.
Local L2 of G, its global distributional divergence equation, and
compactly supported smooth approximation imply the **exact**, finite-R
identity

\[
 \int G\cdot d_R
   =\mathcal J_e(t)-\mathcal J_e(0)+\sigma\mathcal J_{e'}(t).
 \tag{15}
\]

The normalized exterior potentials give
`Psi=O(R^{-1})` and `grad Psi in L2` globally. Thus

\[
 d_R-d=(1-\eta_R)\nabla\Psi-\Psi\nabla\eta_R
       \longrightarrow0\quad\text{in }L2,              \tag{16}
\]

by the L2 tail and an `O(R^{-1})` bound on the second term.
In the finite-domain energy difference, use `m=G+p`. Its value is

\[
 2\int G\cdot d_R+2\langle p,d_R\rangle+\|d_R\|_2^2.
\]

Pass to the limit using (15)-(16), only pairing globally L2 fields
p and d_R in the latter two terms. Translation invariance gives

\[
 0\leq 2(\mathcal J_e(t)-\mathcal J_e(0))+
 2\sigma(\mathcal J_{e'}(t)+\langle p,q\rangle)+
 \sigma^2\|q\|_2^2.                                    \tag{17}
\]

This derivation has no growth requirement on m or G. It does not claim
that a separate annular pairing with an arbitrary locally L2 G tends
to zero. It cancels that pairing exactly before taking the limit.
The exterior normalization is still essential in (16).

Apply the theorem to `e=grad h`, whose curl is supported in A, and
to G from (6). Setting sigma=0 in (17) gives a global minimum at zero
in U. On the connected component U_0 containing zero, the minimum
principle gives constant `J_e`. At any fixed t in U_0, the remaining
quadratic in sigma has zero constant coefficient. If its linear half
coefficient ell were nonzero, choosing
`sigma=-ell/(1+Q)`, where `Q=||q||_2^2>=0`, would give

\[
 2\sigma\ell+\sigma^2 Q
       =-\frac{\ell^2(Q+2)}{(Q+1)^2}<0.                 \tag{18}
\]

It follows that

\[
 \mathcal J_e(t)=\mathcal J_e(0),\qquad
 \mathcal J_{e'}(t)=-\langle p,q\rangle
 \quad(t\in U_0).                                     \tag{19}
\]

This includes Q=0 and uses both signs of the independent amplitude.

## 6. Direct audit of the source translation derivatives

There is no sign defect in the source proof. To check it without relying
on Section 5, shrink the translation disk and choose a smooth compact
zeta in O equal to one on a neighborhood of all A_t in its closure.
Since G is the smooth harmonic gradient on O, zeta G is a smooth
compact whole-plane test field. Thus the local part of I_p is smooth in
t by transferring derivatives to this test field. Equation (1) yields

\[
 \Delta_t\langle p_t,\zeta G\rangle
 =\langle\nabla^\perp\operatorname{curl}p_t,\zeta G\rangle
 =-\langle\operatorname{curl}p_t,\operatorname{curl}(\zeta G)\rangle=0.
 \tag{20}
\]

The support of the curl distribution is contained in A_t and the other
factor vanishes on a neighborhood of it, which justifies the final
zero even for a distribution of positive order.

For the other part of I_p, the support of `1-zeta` stays uniformly
away from A_t on bounded sets. There p_t is smooth harmonic, with
uniform derivative bounds for t in smaller compact translation disks.
At infinity an order-k translation derivative is `O(r^{-2-k})`.
Cauchy-Schwarz on the dyadic annuli gives the summable uniform
majorants `O(s^{-1/2-k})`. Differentiation under that integral is
therefore legitimate to every order, and its translation Laplacian
also vanishes. This proves the source harmonicity directly. Equations
(11) and (18), with the harmonic minimum principle, prove precisely
the source constants on its small disk.

## 7. Removing a potential when G is only locally L2

For every projected h' and fixed t, the integrand
`G dot grad phi'_t` is absolutely integrable: on dyadic annuli its
bound is again `O(s^{-1/2})`, and it is integrable on bounded sets.
For a cutoff theta_R, the potential `theta_R phi'_t` is whole-plane
W1,2 and compactly supported. Mollification approximates it by smooth
tests supported in a fixed slightly larger disk, so local L2 of G
justifies testing its global divergence equation:

\[
 \int\theta_R G\cdot\nabla\phi'_t
       =-\int G\cdot\nabla\theta_R\,\phi'_t.             \tag{21}
\]

The right side is bounded by
`O(R^{1/2}) O(R^{-1})=O(R^{-1/2})`: the second norm is the L2 norm
of `phi'_t grad theta_R`. Absolute convergence permits the limit on
the left. Hence

\[
 \int G\cdot\nabla\phi'_t=0,\qquad
 I_q(t)=\int G\cdot e'_t=\mathcal J_{e'}(t).             \tag{22}
\]

The same proof with h instead of h' gives `I_p=J_e`. In particular
Section 5 independently proves the original source interactions and
their constancy. This is not an application of an L2 orthogonal
projection to G, and it does not assert global L2 of G.

## 8. Arbitrary one-sided traces and the planar rigidity step

Choose a graph strip around a smaller regular subarc:
`gamma(s)=(s,kappa(s))`, s in I, and
`T(s,r)=(s,kappa(s)+r)`, `|r|<a`. Its closure is compact in O and
the only crack in it is the continuation of the chosen arc in A.
Kappa is C1 near the closed interval. T and its inverse are C1 with
bounded first derivatives on this strip and have Jacobian one.
After decreasing the translation disk, all translates of this fixed
strip remain in O.

Choose eta smooth, compactly supported in `(-a,a)`, with eta(0)=1.
For each `beta in C_c^\infty(I)`, define on r>0
`h'_beta(T(s,r))=beta(s)eta(r)`, and set it to zero on r<0 and
outside the strip. Its upper-side gradient is

\[
 e'_\beta=(\beta'\eta-\kappa'\beta\eta',\ \beta\eta').
 \tag{23}
\]

Both values and gradients are square integrable. The function vanishes
on neighborhoods of the outer edges of the strip, so its extension by
zero introduces no other jump. Off A the upper/lower definitions are
Sobolev on overlapping open sets. Thus it is exactly an allowed compact
`W^{1,2}(R^2\A)` test. Its upper-minus-lower trace is beta. The
connectedness of the entire complement imposes no equality of these
two local traces.

Fix the upward normal
`n=(-kappa',1)/sqrt(1+kappa'^2)`. Using (22), or directly using
(12), integrate over the translated upper strip. For completeness the
integration can be done without any C2 regularity of kappa: writing
`G=(G_1,G_2)` in graph coordinates,

\[
 \begin{split}
 \partial_s[\beta\eta G_1(T+t)]
 +\partial_r\{\beta\eta[G_2(T+t)-\kappa'(s)G_1(T+t)]\}\\
 =e'_\beta(T)\cdot G(T+t)+
                  \beta\eta\,(\operatorname{div}G)(T+t).
 \end{split}                                         \tag{24}
\]

The chain-rule terms containing kappa' cancel; no kappa'' occurs.
The divergence is zero, the side and top edge terms vanish, and the
bottom outward normal is -n. Therefore the source's unspecified sign
is specifically minus with this convention:

\[
 I_{q_\beta}(t)=
 -\int_I\beta(s)n(s)\cdot\nabla f(\gamma(s)+t)
                         \sqrt{1+\kappa'(s)^2}\,ds.     \tag{25}
\]

This also follows by Sobolev integration by parts on a C1 graph domain.
The calculation (24) explicitly justifies the orientation and the
absence of other boundary terms.

By (19), or by the source constants, (25) is independent of t for every
beta. At each fixed t, the fundamental lemma for smooth compact tests
and continuity in s give

\[
 n(s)\cdot\nabla f(\gamma(s)+t)
       =n(s)\cdot\nabla f(\gamma(s))\quad(s\in I).       \tag{26}
\]

There is one common translation disk for all beta because the entire
fixed strip, not a beta-dependent support, was kept inside O.
Fix an interior s_0 and put `n_0=n(s_0)`. Equation (26) says the one
fixed directional derivative `n_0 dot grad f` is constant on an open
disk centered at gamma(s_0).

On that disk the Hessian is symmetric and trace-free, so it has the
form `[[a,b],[b,-a]]`. Differentiating the constant directional
derivative gives

\[
 \begin{pmatrix}n_1&n_2\\-n_2&n_1\end{pmatrix}
 \binom a b=0,\qquad
 \det\begin{pmatrix}n_1&n_2\\-n_2&n_1\end{pmatrix}
       =n_1^2+n_2^2=1.                               \tag{27}
\]

Thus the Hessian vanishes and f is affine on that disk. Its affine
extension is harmonic everywhere. Harmonic analyticity/unique
continuation on the connected open set O makes f affine on all O.
Since B has zero area, G is the same constant vector almost everywhere
on the plane.

## 9. Growth, removal, and the empty-remainder case

For a constant vector c, its squared L2 norm on B_R is
`pi R^2 |c|^2`. Bound (7) forces `c=0`. With G=0, choose the permitted
variation h'=h in the constant-interaction identity. Its projected
field is exactly q=p by linearity and the unique normalization.
Consequently `||p||_2^2=0`, and hence m=0.

Since D is connected and v is locally Sobolev there, zero gradient
makes v a single constant on D. Extend that same constant across A
on O, and take B as the new crack. The new function is locally W1,2
on the complement of B, agrees almost everywhere with the old one,
and thus has empty essential support of its difference from v.
The set change is exactly A, compactly contained in some bounded open
comparison domain. B is closed and rectifiable. Dirichlet energy is
unchanged and the finite length in that domain decreases by
`H^1(A)>0`. This is the required contradiction.

If B is empty, O is the whole plane, every finite translation is
allowed, the strip and all cutoff arguments still apply, and the final
comparison has empty crack. No regular arc in B, no properness of A
inside H, and no global L2 condition on the constant comparison
function have been used; the comparison class is local on bounded
domains.

### The growth hypothesis is automatic in this comparison class

This observation is not needed to weaken the source hypotheses. For
any radius r, use the competitor

\[
 L=(H\setminus B_r)\cup\partial B_r,\qquad
 w=0\text{ in }B_r,\quad w=v\text{ outside }B_r.
\]

The entire joining circle is removed from the Sobolev domain, so no
matching of traces is required. This is a closed rectifiable
compact-change competitor in a slightly larger disk. Its outside
energies agree with the original ones. Its added circle length is
at most `2 pi r`, including any overlap with H. Minimality yields

\[
 \int_{B_r}|m|^2+\mathcal H^1(H\cap B_r)\leq2\pi r.
 \tag{28}
\]

Local finiteness and full-ball Sobolev membership ensure both sides of
the comparison are finite. Thus the compact-piece proposition remains
valid if its explicit growth assumption is omitted but its full
absolute comparison class and Sobolev hypotheses are retained.
Equation (28) would not follow from a topology-restricted or merely
same-crack comparison class.

## 10. What the exact certificate does and does not establish

Run, from any working directory:

```
$WORKSPACE/argus-live-update/.venv/bin/python \
  families/366/first-pass/compact_piece_audit/verify.py
```

The script uses SymPy for exact polynomial/rational arithmetic and reads
`exact_certificate.json` and the saved typed Jacobian result. It makes
no network request and imports neither Argus nor Jacobian. It binds the
source labels and the relevant defining equations and hypotheses, and verifies
the universal Hodge and div-curl symbols, formal adjoint sign,
translation signs, energy polarization, the all-amplitude witness (18),
the Hessian system (27), Fourier-mode energy and ODE identities,
graph-coordinate divergence cancellation, and the exact scaling
exponents in the source error estimates. Universal polynomial
identities are checked as identities, not by sampling.

The authorized Jacobian adapter was discovered and its exact input and
output contracts inspected before use. The matching operation
`matrix.symbolic.determinant.compute` evaluates precisely the 2-by-2
matrix in (27), over `QQ(nx,ny)`. The preserved payload, output,
contract, protocol, server version, successful adapter exit, and lack
of timeout/error are specified in the certificate. No operation was
forced to decide a PDE statement. The local script independently
decodes the typed rational polynomials and recomputes the determinant.

Three adversarial boundary checks prevent overreading the result:

* For `kappa(s)=s^2/3`, `beta=(1-s^2)^2`, `eta(r)=(1-r)^2` on
  `-1<s<1, 0<r<1`, and the harmonic function `f=x^2-y^2`,
  direct area integration agrees with (25), giving
  `32/105 + (32/15)t_2`. It is harmonic but not constant.
  This is a sign/trace test, **not** a minimizer counterexample:
  minimality is indispensable for constancy.
* For a flat strip and `G=(0,1)`, the compact gradient-density pairing
  is `-16/15`, although G is globally divergence-free. G is not
  globally L2 and has quadratic growth. Thus replacing (21) by
  an unjustified assertion of L2 orthogonality is not valid.
* In three dimensions `f=x_2^2-x_3^2` is harmonic with constant
  derivative in the first direction but is not affine.
  The planar determinant step must not be extended to higher
  dimension by the same reasoning.

These explicit countermodels refute only the indicated stronger,
unasserted inferences. They do not refute any source claim. The zero
field, zero quadratic coefficient, nonzero rational normal directions,
and sign-reversed algebraic formulas are also exercised by the replay.

All measure/Sobolev constructions, distributional limits, minimum
principles, uniqueness statements, and admissibility arguments above
remain analytic proof obligations for independent human review. The
certificate explicitly says so. The manuscript's remaining reductions
and the final scientific significance/novelty judgement remain open.
