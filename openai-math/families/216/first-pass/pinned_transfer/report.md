# Moving-parameter primary-pin transfer

## Source-grounded scope

The target is `lem:profile-pins` in the staged Essential Singularity
manuscript, `build/sections/profile.tex`. This is a conditional transfer
statement, not an assertion that fixed-temperature convergence is uniform.
Its hypotheses are Gaussian Laplace and moment limits with one coefficient
`a_* > 0` on every fixed nondegenerate rectangle along the same sequences
`b_k in J`, `n_k -> infinity`, and joint convergence of the fractional mean
modulo `2 pi` to an independent uniform variable.

The domain is a fixed rectangle. The pin is a nonempty finite union of
aligned positive-area boxes. Faces and passages remain nondegenerate and
positive-width; only bounded lattice rounding is allowed. Every primary
vertex in the pin is fixed to zero, but internal subdivision vertices are
not pinned by that prescription. The unit-edge Laplacian uses counting
measure, not one quarter of that operator. A density is sampled as
`n^(-2) f(x/n)` and a shift as `g(x/n)`; cell averages use their full
primary counts even after exploration.

The asserted covariance is `a_* integral_U f_i G_p f_j`, where `G_p` is
the inverse of `integral_U grad(v).grad(w)` on
`{v in H^1(U): v=0 a.e. on p}`, with variational free (Neumann) outer
walls. Densities may have nonzero integral. The conclusion includes every
fixed finite collection, all real Laplace transforms, and all polynomial
moments.

The proof takes the subdivision limit at each fixed primary graph first,
then `k -> infinity`, then band-cell size `ell -> 0`, then
`lambda -> infinity`. A cable remainder must vanish in the stated
iterated fixed-graph limsup sense, not merely along an unspecified
diagonal. The finite inputs under examination are
`eq:profile-path-cost` and `eq:profile-sign-error`, with antecedents
`lem:pins-path` / `eq:pins-local-path` and `lem:pins-resampling` in the
critical-exponent manuscript's `build/sections/30-pins.tex`.

The strongest prior project result at the start of this mission was an
open campaign goal: the existing ledger had no evidence and no routes.
The project Wiki index contains no XY/pinning-specific prior result.
No external theorem is taken as proved in this report at scope.

## Result and certification boundary

The route below proves the conditional transfer in `lem:profile-pins`,
subject to independent mathematical review. It does **not** refute that
lemma or the physical correlation-length theorem. Its additional
quantitative conclusion is a cubic reach estimate, (19) below, replacing
the source's successive qualitative mass truncations.

The exact finite sign algebra and the final cubic closure are formalized
in `Main.lean`. The continuum approximation, probability disintegration,
and limit passages are mathematical proofs below, not Lean theorems.
`verify.py` independently replays the finite algebra and exact rational
examples; it does not turn a finite experiment into a continuum proof.
The primary-network resistance `13/11` returned by Jacobian is a
normalization check only. No absence of a witness in that graph is used
as evidence for the transfer.

The fixed-temperature theorem is not a premise of this proof. All
probabilistic limit inputs are the sequence-level hypotheses of the
target lemma. The prior strongest recorded result was the open target;
the improvement here is a proof of the complete transfer and an explicit
moment-to-reach modulus, not a purported new value of the XY exponent.
Novelty and publishable significance remain questions for independent
review.

## 1. Uniform finite comparisons

We give the finite input rather than assume that a fixed-temperature
proof supplies uniform constants. Let \(B=\max J\), \(q=b/(2N)\), and
let \(j\) be one integer chain increment. For \(|t|\le R\) and
\(N\ge 2B e^{2\pi R}\), put \(z=q e^{2\pi R}\le1/4\). Then
\[
 \begin{split}
 2\sum_{j\ge1}q^{j^2}(\cosh(2\pi tj)-1)
 &\le4\pi^2t^2\sum_{j\ge1}j^2z^j\\
 &=4\pi^2t^2\,\frac{z(1+z)}{(1-z)^3}
 \le12\pi^2t^2z.
 \end{split}
\]
The denominator of the increment transform is at least one, and
\(\log(1+x)\le x\). Consequently
\[
 \log {\mathbb E}e^{2\pi tj}
 \le \frac{6\pi^2 B e^{2\pi R}}{N}t^2.                 \tag{1}
\]
Thus the full-chain transform costs at most a constant times \(t^2\),
uniformly over \(b\in J\). This is an explicit version of
`eq:profile-chain-mgf`; it is not the inverse bare microscopic precision.

For completeness, the needed Gaussian-lattice comparison follows from
the following parity identity. For a Euclidean lattice \(L\), write
\(\rho(x)=e^{-\pi\|x\|^2}\) and
\(h_c(z)=\rho_{\sqrt2}(2L+c+z)\), \(c\in L/2L\). The bijection
\((u,v)\mapsto(u+v,u-v)\) gives
\[
 \rho(L+x)\rho(L+y)=\sum_c h_c(x+y)h_c(x-y),\qquad
 \sum_c h_c(z)^2=\rho(L)\rho(L+z).
\]
Cauchy--Schwarz proves
\[
 \rho(L+x)^2\rho(L+y)^2
 \le \rho(L)^2\rho(L+x+y)\rho(L+x-y).                  \tag{2}
\]
Taking the second derivative in \(y\) at zero shows that the
logarithmic Hessian of the periodic Gaussian is minimized at a lattice
point. Differentiating the Gaussian sum expresses this as covariance
minimization on translated lattices. Differentiating that inequality
twice at the centered translate gives
\[
 {\mathbb E}X^2Y^2\ge
 {\mathbb E}X^2{\mathbb E}Y^2+2({\mathbb E}XY)^2
\]
for any real linear tests of a centered lattice Gaussian. In particular,
adding positive quadratic precision decreases centered covariance.
For a fixed real tilt \(tX\), differentiation with respect to a
rank-one added precision is nonpositive because the tilted raw second
moment dominates its centered counterpart. Hence centered real
transforms also decrease with added precision. Integrating covariance
minimization along a real tilt gives
\[
                 \log {\mathbb E}e^X\ge\tfrac12{\mathbb E}X^2.
                                                               \tag{3}
\]
Arbitrary positive forms follow by sums and limits of rank-one forms.
Centered coordinate constraints follow by sending their precisions to
infinity. All these arguments apply to the lattice in its actual
parallel span.

Poisson summation identifies a centered characteristic transform with
a periodic Gaussian on the dual lattice. Applying (2) there proves
the characteristic logarithmic-Hessian comparison. In particular
\[
 {\mathbb E}[X^2\cos(tY)]
 \le {\mathbb E}X^2\,{\mathbb E}\cos(tY).
                                                               \tag{4}
\]
One must retain the sign when differentiating: if \(F(s)\) is the
positive characteristic transform in the \(X\) direction, then
\(F''/F-(F'/F)^2\ge-{\mathbb E}X^2\).
Since \(F''=-{\mathbb E}[X^2\cos(tY)]\), this gives (4), with the
additional nonpositive term \(-F'^2/F\). Thus there is no missing
gradient term with the opposite sign in the source's size-bias step.
Multiplication by \(2/(\pi t^2)\), subtraction from the identity at
zero, and integration give
\[
               {\mathbb E}[X^2|Y|]\ge
                    {\mathbb E}X^2\,{\mathbb E}|Y|.              \tag{5}
\]
The individual integrands after subtraction are nonnegative, so
Tonelli applies; the final quantities are finite by reference moments.

These are known finite Gaussian inequalities: (2) is
Regev--Stephens-Davidowitz, *An Inequality for Gaussians on Lattices*,
arXiv:1502.04796v3, Theorem 2.1; the Hessian and covariance forms are
Proposition 3.1 and Corollary 3.2. The preceding derivation supplies
the input internally, rather than treating an unchecked literature
claim as a proof of the transfer.

Apply the comparisons on the \(N\)-subdivided graph. Extend a primary
flow through every bond of its original edge and release all centered
constraints. Independence and (1) bound its transform by
\[
 \log{\mathbb E}e^{tX}\le C_{J,R}t^2\sum_e w_e^2
 \quad\text{if } \max_e|tw_e|\le R.                              \tag{6}
\]
Normalizing a flow by its Euclidean norm gives all fixed moments and
fixed normalized linear exponential moments. Additional zero pins,
including internal pins, and tightened segments only improve these
comparisons. For grounded tests, the flow may discharge into grounded
primary vertices.

At a fixed primary graph the full-chain transform tends to
\(\exp\{b(\cosh(2\pi t)-1)\}\). A spanning tree, with all remaining
normalized edge weights bounded by one, dominates the vertex sums
and their fixed polynomial/exponential insertions. A confined
constant is summed against its Gaussian penalty; a free constant is
factored out. This proves convergence to the stated Bessel law,
including primary hard pins and band normalizers. No rate uniform
in the primary graph has been used.

## 2. The path estimate with the primary normalization

Here is an elementary quantitative form of the geometric step. In an
\(H\)-row, \(W\)-column nearest-neighbor rectangle, suppose at least
\(L\) rows contain a zero of a variation \(v\). Let \(E_h,E_v\)
be its horizontal and vertical unit-edge energies. Telescoping
within an anchored row gives row squared norm at most \(W^2\) times
its horizontal energy. For any column, any row, and any anchored row,
\[
 |v_{i,j}|^2\le2|v_{i,j_0}|^2+
                    2H\sum_{\text{vertical edges in column }i}
                              |\nabla v|^2.
\]
Average over the \(L\) anchored rows and sum over all vertices:
\[
 \sum |v|^2\le \frac{2HW^2}{L}E_h+2H^2E_v.                      \tag{7}
\]
Thus \(L\ge\alpha H\), \(H,W=O(\ell n)\) give
\(n^{-2}\sum|v|^2\le C_\alpha\ell^2 E(v)\).

A primary path from a touched cell to distance comparable to its
diameter lies, until its first exit, in a fixed enlargement. One
coordinate crosses a fixed fraction of the lattice levels of that
enlargement; nearest-neighbor connectivity gives an anchored vertex
on each intervening level. Use (7), interchanging coordinates if
necessary. At a wall intersect the enlargement with \(U\); its
dimensions remain comparable. The finite positive-width geometry
ensures the same bounded enlargement and overlap constants after
the permitted roundings. For a macroscopic cluster, every touched
small cell has such a path: a connected cluster of diameter at least
\(r\) cannot be contained in a sufficiently small enlargement when
\(\ell<r/C\). The filled starting region gives the same anchors.

For disjoint cells with full primary probability denominators,
Cauchy--Schwarz and (7), summed over the bounded-overlap
enlargements, imply
\[
 \left|\sum_d|d|c_d v_d\right|^2
 \le C\ell^2\left(\sum_d|d|c_d^2\right)E(v).
                                                               \tag{8}
\]
Taking the dual norm proves exactly `eq:profile-path-cost`.
Changing \(|d|\) from counting area to its continuum area changes
only bounded geometric constants, tending to one at each fixed
partition. No factor of \(n\), \(N\), or a cell's unvisited
proportion has been discarded. In particular the cost of the
remaining probability average is bounded independently of \(\ell\).
A fixed \(r\)-sized anchored patch, followed by the rectangle
Poincare inequality, bounds the remaining full-component mean by
a constant \(V_r\).

On a cable cut at its first zero, the remaining transition kernel
is \(p_t(0,h_y)\), with \(t\) at most the original bond time.
Indeed the first-hitting density from the revealed endpoint
multiplies this kernel; the original bridge denominator cancels
the original endpoint kernel. This is the Brownian Markov
factorization, and it increases the precision on the remainder.
Insert visited coordinates at zero for the centered comparison.
The flow identity then concerns exactly the zero extension of the
unvisited test. Applying (6) transfers (8) and the mean estimate
to every centered cable posterior, uniformly in sufficiently large
subdivision. The source's replacement of bare variance by primary
reference cost is essential here and is valid.

## 3. Band limits and the sigma-finite tails

Fix the band partition and strength first. Let \(S\) be the primary
mean and \(\bar h_K\) the band mean. The difference \(S-\bar h_K\)
has bounded reference cost, and
\[
              W\le e^{-\lambda|K|\bar h_K^2/2}.
                                                               \tag{9}
\]
Summing (9) over translations has uniform Gaussian tails, also
after a fixed polynomial insertion. The reference bound controls
the difference of the two means. The assumed joint free limit
and independent uniform phase therefore give translation
integration \(dc/(2\pi)\), with polynomial insertions, at this
fixed partition. This proves convergence to the Gaussian with
precision \(a_*^{-1}E+\lambda\sum_d|d|v_d^2\).

After integrating the constant, cell projection of the mean-free
Neumann covariance has uniformly bounded Hilbert--Schmidt norm.
For a rectangle this follows directly from
\(\sum_{(j,l)\ne(0,0)}(j^2+l^2)^{-2}<\infty\);
restriction, projection, and subtraction of the band mean are
bounded \(L^2\) maps. If \(t_j\) are the eigenvalues after
multiplication by \(\lambda\), then for every \(q\ge1\)
\[
 0\le q\log(1+t)-\log(1+qt)
       \le \tfrac12q(q-1)t^2.
                                                               \tag{10}
\]
Differentiate both sides to verify this inequality. Gaussian
determinants, the one-dimensional constant integral, and Poincare
with its constant controlled on \(K\) consequently give
\[
 \limsup_{\ell\downarrow0}\limsup_k
        {\cal P}_n(\widehat W^q(1+|S|)^M)<\infty
                                                               \tag{11}
\]
for every fixed \(q,M,\lambda\). This is a bound on normalized
weights, not a nonexistent lattice quadratic-exponential moment.

Strong convergence of the cell projections and energy compactness
give the inverse form
\[
              T_\lambda^{-1}
                 =(-\Delta_U/a_*+\lambda1_K)^{-1}.               \tag{12}
\]
If \(g\) vanishes near \(K\), its weak Neumann test has variance
\(a_*E(g)\), because \(T_\lambda(a_*g)=A_Ug\).
Its fourth moment is \(3(a_*E(g))^2\), uniformly in \(\lambda\).

We justify the tail transfer used with (11). Conditional on primary
magnitudes and the open graph, the unweighted nonzero-cluster signs
are independent fair signs. This follows directly by splitting
each Gaussian bridge into its zero-hitting and non-hitting parts:
the former endpoint weight is unchanged by either endpoint sign
flip, and the latter joins only equal signs. Summation over lattice
magnitudes gives a sigma-finite signless measure \(\nu\). Bridge
segments can be appended before exploration; conditional on a
completed cluster the complement has the proper centered law
described in Section 2. Count clusters by their least primary
vertex, a condition measurable at completion.

Write \(m_C=M_C(u)\), \(Q=\sum_Cm_C^2\). On \(Q\le4t^2\),
Chebyshev makes \(|S|\le Ct\) have arbitrarily large conditional
sign probability. The Rademacher fourth-moment inequality and
Paley--Zygmund make \(|(h,f)|\ge c(\sum_C M_C(f)^2)^{1/2}\)
have a fixed positive probability. Choose \(C\) so these events
intersect with fixed positive probability. Each translation orbit
has at most \(C'(1+t)\) representatives with \(|S|\le Ct\).
The reference moments from (6) therefore give
\[
 \begin{split}
 \nu(Q\le4t^2)&\le C(1+t),\\
 \int_{Q\le4t^2}\left(\sum_C M_C(f)^2\right)^q d\nu
 &\le C_q(1+t)
       \left(t|\textstyle\sum f|+
            {\cal R}(f-u\sum f)^{1/2}\right)^{2q}.                \tag{13}
 \end{split}
\]
After exposure of a cluster of diameter at least \(r\), (8)
bounds every conditional moment of the remaining signed mean.
Jensen in its fair signs bounds every moment of the complement
squared-mass sum \(Q_U\). In particular
\(\Pr(Q_U\le4t^2\mid C)\ge1/2\) for \(t\ge t(r)\). For any
nonnegative completed-cluster cost \(I(C)\), condition and sum
over least-primary roots to obtain
\[
 \int\sum_{\operatorname{diam}C\ge r}I(C)1_{\{m_C\le2t\}}d\nu
 \le2\int1_{\{Q\le8t^2\}}
        \sum_{\operatorname{diam}C\ge r}I(C)1_{\{m_C\le2t\}}d\nu .
                                                               \tag{14}
\]

For clarity, arbitrarily high polynomial damping, not a Gaussian
tail, suffices. Every sufficiently small cluster misses one of
finitely many fixed probability boxes. Assign it such a box; its
mass is a mean-free cluster mass for the difference between that
box and \(u\). If the small clusters account for at least half
of \(Q>t^2\), (13) with arbitrarily high moment order gives an
arbitrarily high inverse power of \(t\).

Otherwise use the intrinsic macroscopic-cluster majorant
\(\sum_C2m_C^2t^{-2}1_{\{m_C\le2t\}}\). Conditional on \(C\),
write \(S=\sigma_Cm_C+S_U\).
If \(m_C\ge t/2\), either \(|S_U|\le m_C/2\), when
\((1+|S|)^{-M}=O(t^{-M})\), or a high complement moment
gives an arbitrarily high inverse power of \(t\).
If \(m_C<t/2\), then \(Q>t^2\) forces
\(Q_U>3t^2/4\), handled by the same conditional moments.
After dropping the upper bin cutoff, (14) bounds the intrinsic
majorant's integral by \(32\nu(Q\le8t^2)=O(1+t)\).
It follows that, for every \(j\), a sufficiently large \(M\)
satisfies
\[
 {\cal P}_{n,N}\big((1+|S|)^{-M}
                  1_{\{t^2<Q\le4t^2\}}\big)
                       \le C_j(1+t)^{-j}.                       \tag{15}
\]
All bounds so far depend on \(J\), the fixed geometry, and the
displayed orders or \(r\), not on \(k,N\).

Apply Holder with exponents \(4,4,2\), using (11), (15), and
(13) on each dyadic bin. The two polynomial factors in \(S\)
cancel. Choosing \(j\) after the requested moment order makes
the sum and its tail uniformly convergent. For a cell average
minus \(S\), the Neumann cosine expansion has reference cost
\(O(1+\log(1/\ell))\): low frequencies give the logarithm and
the high-frequency density \(L^2\) estimate gives a bounded
remainder. Hence, with \(D_\ell^2=1+\log(1/\ell)\),
\[
 {\mathbb E}_W\left(\sum_C M_C(d)^2\right)^q+
             {\mathbb E}_W|d_*|^{2q}
        \le C_{q,\lambda}D_\ell^{2q}+o_k(1).                    \tag{16}
\]
Here selections for \(d_*\) depend on signless data and have
coefficients between zero and the full cell weights. Fixed
observation boxes have a constant instead of \(D_\ell\).
All limits in (11), (12), (16) remove \(N\) first at a fixed
primary graph.

## 4. Exact sign-resampling algebra and the error estimate

Put \(A_{CD}=\sum_d|d|M_C(d)M_D(d)\), \(C\ne D\).
The diagonal terms of the quadratic band energy do not depend
on signs. If \(L\) is the set of resampled clusters, elementary
Walsh orthogonality gives the **exact** conditional identity
\[
 {\mathbb E}_{\sigma,\sigma'}
       |\log W(\sigma')-\log W(\sigma)|^2
   =2\lambda^2\!
       \sum_{\{C,D\}:\{C,D\}\cap L\ne\varnothing} A_{CD}^2
   \le2\lambda^2\sum_{C\in L}\sum_{D\ne C}A_{CD}^2.              \tag{17}
\]
To see this without an independence shortcut, label each old
sign by \((C,0)\), and a fresh sign by \((C,1)\) only when
\(C\in L\). Distinct unordered pairs give distinct character
supports within either sample. Every affected fresh support
contains a tag 1, whereas every old support has only tag 0.
Thus all the old and affected fresh characters are orthogonal,
including pairs sharing a cluster. Unaffected pairs cancel.
This is the universal identity formalized by
`PinnedTransfer.sign_resampling_exact`; no assumption about a
bounded number of clusters is made.

Integrate (17) on \(Q\le t^2\). Expose \(C\), retain the
intrinsic condition \(m_C\le t\), and drop the complement
cutoff. The inner sum is the conditional second moment of
\(\sum_d|d|M_C(d)h_d^U\). Only cells touched by \(C\)
have nonzero coefficients, so (8) and (6) bound it by
\(C\ell^2\sum_d|d|M_C(d)^2\).
Reinsert the bin with (14), then use (13).
Since \(\sum_d|d|\) is bounded, this gives exactly
\[
 {\cal P}_{n,N}\left(1_{\{Q\le t^2\}}
       |\log W(\sigma')-\log W(\sigma)|^2\right)
       \le C_{\lambda,t,r}\ell^2D_\ell^2+o_k(1).                 \tag{18}
\]
Small \(t\) are covered by enlarging the fixed cutoff to
\(t(r)\). The coefficient constant in (17) counts unordered
pairs correctly; there is no missing factor growing with
the number of clusters.

On this finite-mass bin split where the logarithmic difference
exceeds \(\eta\). Equation (18), Holder, and (11) control that
exceptional set. On the other set use
\(|e^x-e^y|\le(e^\eta-1)(e^x+e^y)\).
Take the mesh and cell limits, then \(\eta\downarrow0\).
Swapping the old and fresh sign samples preserves the
unweighted enlarged measure and \(Q\); (13)--(16) therefore
remove the bin cutoff for both densities, including polynomial
insertions. This proves the claimed total-variation sign
resampling, not just convergence against bounded tests.

A cluster of diameter below \(r\) meets only boundedly many
neighboring \(r\)-cells. For a bounded density, Cauchy--Schwarz
and (13) bound the second moment of their signed sum on a
fixed bin by \(C_t r^2(1+\log(1/r))\).
Higher bin moments, interpolation, and the same weighted
tails make this contribution vanish in every fixed moment.
Consequently, for nonnegative fixed smears \(f,g\), resample
at a threshold below \(r\), discard smaller clusters, and use
the band Gaussian limit to obtain
\[
 \limsup_{\ell\downarrow0}\limsup_k\limsup_N
 {\mathbb E}_W\sum_{\operatorname{diam}C\ge r}
                      M_C(f)M_C(g)
                      \le(f,T_\lambda^{-1}g).
\]
Fair-sign Jensen bounds every fixed moment of the corresponding
squared mass sums by the Gaussian even smear moment. In
particular their second moments have a common bound for
\(\lambda\ge\lambda_0>0\). Here and below this uniformity is
**after** the primary-mesh and band-cell limits.

## 5. Tilt errors and the two variance deficits

During exploration \(h_d=d_*+h_d^U\). The centered posterior
with the restricted band form must be tilted by
\(L=-\lambda\sum_d|d|d_*h_d^U\). Equations (8) and (16)
give, with \(\epsilon^2=C\lambda^2\ell^2
\sum_d|d|d_*^2\),
\[
 {\mathbb E}_W\epsilon^{2q}
   +{\mathbb E}_W\left(\sum_{\operatorname{diam}C\ge r}
                               \epsilon_C^2\right)^q
       \le C_{q,\lambda,r}\ell^{2q}D_\ell^{2q}+o_k(1).
\]
For \(\epsilon\le1\), symmetry and (6) give
\(1\le\mu(e^L)\), \(\mu(e^{2L})\le e^{C\epsilon^2}\),
and \(\mu((e^L-1)^2)\le C'\epsilon^2\).
Cauchy--Schwarz with fourth moments makes the change in
fixed-cost means and second moments \(O(\epsilon)\).

For a single exposed cluster write
\(A_C=M_C(B)\), \(Z_C=M_C(i)\),
\(Q_A=\sum A_C^2\), \(Q_Z=\sum Z_C^2\), and
\(E_2=\sum\epsilon_C^2\), restricting to the fixed
macroscopic threshold wherever necessary. The exact
large-tilt majorant is
\[
 \sum_C A_C1_{\{\epsilon_C>1\}}
                (1+h_i^2+Z_C^2)
       \le\sqrt{Q_AE_2}(1+h_i^2+Q_Z).
\]
For small tilts the errors are at most
\(\sqrt{Q_A}(1+\sqrt{Q_Z})(\sqrt{E_2}+E_2)\).
Holder and the preceding moments make both expectations
vanish. Filled-region exploration is handled by discarding
\(\epsilon>1\) directly with its high moments and actual
band moments. There is no exponential moment of
\(\epsilon^2\) in this argument.

Choose fixed finite coverings \(i_1,\ldots,i_m\) of a
separator on the starting side and \(B_1,\ldots,B_b\)
on the target side, with positive gaps from the band and
the starting/target regions. A reaching path must hit
both separators. Fix \(r>0\) smaller than these gaps.
A reached cell of radius \(\rho\) has centered remaining
reference variance at most \(C_0\), by (8), independently
of \(\rho\). A logarithmic trial supported within a
fixed radius away from \(K\) gives band prior variance
\(c'a_*\log(1/\rho)-C\), uniformly in \(\lambda\).
At a free wall restrict the trial to \(U\).
Choose \(\rho\) once so that this variance exceeds
\(C_0+2c\), \(c>0\). Band convergence then gives the
gap \(c\) at each fixed \(\lambda\). This is the sole
use of \(a_*>0\); no lower bound for \(a(b_k)\) is used.

For a target cell \(B=B_j\), write its average as exposed
plus unvisited. The centered posterior has extra zero
pins and increased precision, so its variance is at most
the prior variance, and is at most that variance minus
\(c\) if \(B\) is reached. The restored-tilt errors
vanish as just proved. Fair-sign resampling of the
exposed sum therefore gives the exterior deficit
\[
 c\,\Pr_W(B\text{ reached})
    \le {\mathbb E}_W\sum_{C:C\cap p\ne\varnothing}A_C^2+o(1).
\]
For the second deficit, bias by \(|h_x|\), \(x\in B\),
and expose only its cluster. Equation (5) makes the
pre-exposure second moment at \(i=i_l\) at least its
unbiased variance. The bias is measurable at completion
and cancels from the conditional complement law.
Apply the same posterior gap, multiply by
\({\mathbb E}|h_x|\), and sum the primary averaging
weights over \(B\):
\[
 c\,{\mathbb E}_W\sum_{C:C\cap i_l\ne\varnothing}A_C
       \le {\mathbb E}_W\sum_C A_C Z_{l,C}^2+o(1).
\]
The exposed square is \(Z_{l,C}^2\) for a one-cluster
exploration, so it has no off-diagonal sign error.
The cancellation of the prior variance times
\({\mathbb E}|h_x|\) takes place at each finite graph;
no uniform point-height moment is asserted or needed.
Only clusters spanning a fixed gap cause a nonzero
exposed or tilted term; their threshold is the fixed
\(r\), and the previous summed tilt bounds apply.
Clusters confined near the bias point cause neither
term and require no small-cluster counting bound.

## 6. Quantitative closure and the full transfer

Here is an explicit consequence of those two deficits. For
one target cell \(B\), let
\[
 P_{\lambda,B}=\limsup_{\ell\downarrow0}\limsup_k\limsup_N
                    \Pr_W(B\text{ reached}),\qquad
 H_{\lambda,B}=\sum_{l=1}^m(B,T_\lambda^{-1}i_l).
\]
Take \(M\) to be a common bound for the limiting second
moments of \(Q_A\) and all \(Q_{Z_l}\), uniform for
\(\lambda\ge\lambda_0\). Let \(\mathcal T\) be the
clusters meeting \(p\); terms with \(A_C=0\) are
irrelevant. Every contributing member of \(\mathcal T\)
meets some \(i_l\). Define the exposed second mass
\(e={\mathbb E}\sum_{\mathcal T}A_C^2\) and the
dominating first mass
\(s=\sum_l{\mathbb E}\sum_{C\cap i_l\ne\varnothing}A_C\).
All the following inequalities hold along any scalar
subsequence realizing the iterated limsup, after its
vanishing errors have been removed.

Holder on probability times cluster counting measure gives
\[
 e^3\le M s^2,\qquad
 \left({\mathbb E}\sum_C A_C Z_{l,C}^2\right)^2
       \le H_l\,{\mathbb E}\sum_C A_C Z_{l,C}^3
       \le M H_l.
\]
For the last inequality use
\(\sum A Z^3\le\sqrt{Q_A}Q_Z^{3/2}\), then Holder
with exponents \(4,4/3\).
The biased deficits and finite-sum Cauchy--Schwarz give
\(c^2s^2\le mM\sum_l H_l\).
The exterior deficit gives \(cP_{\lambda,B}\le e\).
The exact polynomial closure in `PinnedTransfer.cubic_reach`
now proves
\[
       \boxed{\quad c^5P_{\lambda,B}^{\,3}
                    \le mM^2 H_{\lambda,B}.\quad}               \tag{19}
\]
No fractional-power division is needed to prove it, including
the case \(H=0\). Formula (19) concerns a specified target
comparison cell. For the entire target region,
\[
 P_{\lambda,V}\le\sum_{j=1}^b
       (mM^2H_{\lambda,B_j}/c^5)^{1/3}.
                                                               \tag{20}
\]
This distinction avoids incorrectly omitting a covering
constant for the full reach event.

As \(\lambda\to\infty\), energy compactness and recovery
by functions zero on \(K\) make \(T_\lambda^{-1}\)
decrease to the inverse with a hard zero band.
That band separates \(B_j\) from \(i_l\); the limiting
form is an orthogonal sum on the two sides. Hence
\(H_{\lambda,B_j}\to0\), and (20) proves vanishing reach.
Second mass moments used in \(M\) are uniform at this
stage by Gaussian covariance monotonicity from Section 4.
There is no need to choose \(\lambda\), \(\ell\), or
\(N\) as a function of \(k\).

For a smooth \(g\) vanishing near \(p\), place \(K\)
in the gap between \(p\) and the support of \(g\).
On successful exploration the exposed test
\(X_g=(h,A_{U,n}g_n)\) is zero. Its centered
posterior variance is at most the desired primary-pin
variance, because it has at least that pin, possibly
further zeros, increased segment precision, and a
nonnegative restricted band form. Take the subdivision
limit at this fixed primary graph. The tilt error
vanishes in the first two remaining limits.
On failed exploration, Cauchy--Schwarz bounds the
second moment by
\(\sqrt{3}\,a_*E(g)P_{\lambda,V}^{1/2}\).
The band variance is \(a_*E(g)\). Therefore
\[
 \liminf_k\operatorname{Var}_{p}X_g
       \ge a_*E(g)-
              \sqrt{3}\,a_*E(g)P_{\lambda,V}^{1/2}.
\]
Let \(\lambda\to\infty\). Releasing the pin gives the
opposite variance upper bound. Thus
\(\operatorname{Var}_pX_g\to a_*E(g)\).
The test has total zero, so (3) and free precision
release squeeze its Laplace transform:
\[
 \tfrac12t^2\operatorname{Var}_pX_g
 \le \log{\mathbb E}_p e^{tX_g}
 \le \log{\mathbb E}_{\rm free}e^{tX_g}.
\]
Both endpoints tend to \(a_*t^2E(g)/2\).
Finite real linear combinations prove joint Gaussian
Laplace limits for these tests; (6) gives convergence
of all polynomial moments.

Finally let \(v=G_pf\). The grounded form convergence
established in the next section gives smooth \(g_j\)
vanishing near \(p\) such that
\[
 \lim_k{\cal R}_{p,n}
              (f_n-A_{U,n}g_{j,n})=E(v-g_j)\longrightarrow0.
                                                               \tag{21}
\]
The reference moments make the error vanish in every
fixed moment. For Laplace transforms use
\(|e^x-e^y|\le |x-y|(e^x+e^y)\), Cauchy--Schwarz,
and the uniform fixed linear exponential moments
in (6). The limiting variance is
\(a_*E(v)=a_*\int fG_pf\). Apply this to all finite
linear combinations of the \(f_i\) and polarize.
This proves the entire conclusion of `lem:profile-pins`,
including nonzero-total densities.

## 7. Grounded form consistency without a new pin convention

Here are details behind (21). On the fixed rectangle,
triangulate each mesh square consistently and interpolate
primary variations linearly. On a square with vertex
values \(a,b,c,d\) in cyclic order, the two-triangle
energy is one half the sum of the four squared edge
differences. Interior edges occur in two squares.
Boundary-strip discrepancies vanish for smooth recovery
functions, while restriction to compact interior
subrectangles gives the exact lower energy bound.
The corresponding scaled \(L^2\) interpolation norm
is equivalent to the primary counting norm.

A bounded-energy sequence, extended with its pinned
values zero, has bounded \(H^1(U)\) norm: Poincare
with a fixed positive-area zero subset controls the
constant. Compactness in \(L^2(U)\) can be seen by
the rectangle cosine expansion (truncate the
frequencies, then use the energy bound on the tail).
Any limit is zero a.e. on each pin box: compact
subboxes have eventually only zero vertices, and
their union exhausts the box up to measure zero.
This proves the grounded lower form bound.

For recovery, smooth functions zero in a neighborhood
of \(p\) are energy dense among \(H^1(U)\) functions
zero a.e. on \(p\). To verify the boundary issue,
reflect across free outer faces. Along an inner
pin face use the zero trace supplied by the
zero-on-the-box condition, translate the local
function a small distance away from that face,
and mollify. At a corner use the finitely many
rectangular coordinate patches and a partition
of unity; zero-extend across Dirichlet faces
before translation. The positive-width/no-point-
contact geometry is exactly what permits these
Lipschitz patches. Translation and mollification
are continuous in \(H^1\). Restricting back to
\(U\) proves the stated density while imposing
no trace condition on free faces.
Samples of such a smooth function are zero at
all pinned vertices for sufficiently fine meshes,
and their unit-edge energies converge by Riemann
sums to \(E_U\). Bounded rounding changes only
a shrinking boundary strip, so the same lower
bound and recovery apply along every allowed
rounding sequence.

Minimize the grounded strictly convex functionals
\(\tfrac12E_n(w)-(f_n,w)\).
The lower bound, recovery, and compactness just
proved show that their minimizers converge and
\[
       (f_n,A_{p,n}^{-1}f_n)\to(f,G_pf).
\]
For a fixed smooth \(g_j\) zero near \(p\),
quadrature and energy consistency give
\[
 \begin{split}
 {\cal R}_{p,n}(f_n-A_{U,n}g_{j,n})
  &=(f_n,A_{p,n}^{-1}f_n)-2(f_n,g_{j,n})
                              +(g_{j,n},A_{U,n}g_{j,n})\\
  &\longrightarrow E_U(v)-2E_U(v,g_j)+E_U(g_j).
 \end{split}
\]
This is (21). Pinned coefficients are immaterial
and a representing flow may discharge into the
pin; there is no zero-total requirement on \(f\).

## 8. Exact replay and what remains independent

`verify.py` uses only the Python standard library.
Run it from the campaign root with
`python3 research/pinned_transfer/verify.py`.
Its universal finite check reduces the sign
Gram calculation to two unordered pairs, hence
at most four cluster identities, and exhausts
their old/fresh membership patterns. It also
checks Walsh orthogonality directly, the exact
cubic slack polynomial, the parameterized sharpness
family below, and the independent grounded-network
solution matching Jacobian. Inequality (10) is
proved by differentiation in the report, not
silently checked by the script.

The Lean source verifies the same universal
sign-support algebra for arbitrary finite types
and the cubic closure for all real parameters,
not just the replay's small instances. Its
statement-fidelity document explicitly excludes
the analytic continuum argument. The exact
certificate records these boundaries.

No false literal manuscript assertion has been
identified on this route, so there is presently
no justified `F_*` refutation claim to file.
An independent Reviewer must check the analytic
proof, statement fidelity, significance/novelty,
and replay before accepting this mission.

The current exact replay passed 576 pair-Gram
cases and 184 nonnegative rational Bernstein
coefficients. The real Lean 4.31.0 compiler run
exited zero with `proof_holes=[]`; it certified
`C_PIN_ALGEBRA`, not the complete analytic theorem.
Its archived certificate is
`certificates/C_PIN_ALGEBRA-9119b28d03a13e7d.json`.
Two earlier proof-script elaboration failures
were recorded as inconclusive, not as mathematical
refutations; the current source has a successful
fresh compiler record.

## 9. Optimality of the cubic modulus for the stated moment data

This is an abstract sharpness statement for the two deficits
and fourth mass moments, **not** a construction of a Bessel
field or a counterexample to any manuscript claim.
Let \(t\ge2\) be an integer. In each active outcome take one
cluster, meeting the comparison cell \(i\). Use these three
outcomes; otherwise take no cluster:

| Probability | \(A\) | \(Z\) | Meets starting set |
|---|---:|---:|---|
| \(t^{-4}\) | \(t\) | \(t^{-4}\) | yes |
| \(t^{-2}-t^{-4}\) | \(t^{-8}\) | \(t^{-8}\) | yes |
| \(2t^{-12}\) | \(t^3\) | \(t^3\) | no |

Define reach to be the union of the first two outcomes,
so \(p=t^{-2}\). The exterior deficit with \(c=1\) holds:
\[
 e-p=t^{-18}-t^{-20}\ge0.
\]
The first mass through \(i\) is
\(s=t^{-3}+t^{-10}-t^{-12}+2t^{-9}\).
The biased second mass is
\(b=2t^{-3}+t^{-11}+t^{-26}-t^{-28}\).
Its gap obeys
\[
 b-s\ge t^{-3}(1-2t^{-6}-t^{-7})>0.
\]
Also
\[
 {\mathbb E}A^4=3+t^{-34}-t^{-36}<4,\qquad
 {\mathbb E}Z^4=2+t^{-20}+t^{-34}-t^{-36}<4,
\]
and
\[
 H={\mathbb E}AZ
      =2t^{-6}+t^{-7}+t^{-18}-t^{-20},\qquad
                      2p^3\le H\le3p^3.
\]
All event probabilities, including the remaining probability,
are nonnegative. Thus no bound \(p\le C H^\alpha\) with
\(\alpha>1/3\), uniform in these abstract data with
\(c=1,m=1,M=4\), is possible. Any stronger exponent for
the actual cable laws would need information beyond these
two deficits and the displayed moment bounds.

The script reconstructs these rational Laurent moments,
compares the resulting polynomials with the certificate,
and proves every required polynomial nonnegative on the
whole interval \(0\le q=1/t\le1/2\) by nonnegative Bernstein
coefficients. This is a parameter-uniform exact certificate,
not a search over finitely many temperatures or mesh sizes.
