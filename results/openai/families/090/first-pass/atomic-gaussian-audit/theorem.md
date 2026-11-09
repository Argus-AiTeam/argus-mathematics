# Exact verification of the atomic Gaussian construction

## Result and scope

**Verification theorem (independent review pending).** The actual construction
in the staged *An atomic certificate for triangular-lattice universal
optimality*, September 26, 2026, produces the stated sharp Gaussian Fourier
minorants for every real `alpha >= 1`. In particular, both Proposition
`prop:exact-interpolation` and Proposition `prop:global-signs` follow from the
independently recomputed inequalities below. The assertion covers every
positive interpolation node and every real nonnegative squared radius, not a
finite collection of Gaussian parameters or evaluation points.

The coefficient family also extends continuously, in its finite-plus-`ell^1`
norm and hence in every Schwartz seminorm, to `z = 0`. Its nonzero limiting
Fourier pair has the sharp packing signs and has a nonzero negative first
derivative at the first positive node. This boundary statement is proved
below; it is not an assumption about the packing companion.

This is a computer-assisted analytic proof, **not** a Lean formalization.
`verify.py` uses only integer and rational arithmetic to establish its finite
premises, exact spectral identities, and rational continuum comparisons.
The arguments passing from these premises to functions on an infinite
dimensional space and to signs on a continuum are supplied here. No claim
that a finite checker alone proves the analytic theorem is made.

The staged checker was first run without modification and passed. The new
checker neither imports nor executes it. Its independent features include
integer cyclotomic reconstruction of the columns, direct sine-product
evaluation of local node data and midpoint barriers, and a separate interval
implementation. The improvement over that prior local evidence is a
source-specific independent reconstruction and a complete audit of its
infinite and continuum implications, with an explicit boundary extension.
Originality, publishable significance, and independent acceptance remain for
the normal Reviewer. The other three manuscripts and the downstream energy
argument are outside this theorem's scope.

## 1. Objects and exact source correspondence

All source references below are to `build/main.tex` in the staged atomic
manuscript. The checker verifies the proposition labels, damping constants,
fixed coefficients, and Gaussian target against that file.

Put

\[
 b=\sqrt3/2,\quad B=b^{-2}=4/3,\quad
 h=17/50,\quad H=27/50,\quad\eta=H-h=1/5,\quad\kappa=\pi/36.
\]

Use the same scalar coordinate `s = b |x|^2` in the physical and Fourier
variables, and the Fourier kernel `exp(-2 pi i x.dot(xi))`. Let

\[
\begin{split}
I&=\{0,1,3,4,7,9,12,13,16,19,21,25,27,28,31\},\\
\mathcal N&=(36\mathbb Z+I)\cap(0,\infty),\\
f&=\{1,3,4,7,9,12,13,16,19,21\},\quad
L=\{0\}\cup f,\quad T=\mathcal N\setminus f,\\
P(s)&=\prod_{a\in I}(2\sin\kappa(s-a))^2
       =\sum_{j=-15}^{15}P_j e^{i\pi js/18}.
\end{split}
\]

At each node write `P(n+v) = Q_n v^2 (1+D_n v+O(v^2))`. These are real,
36-periodic data with `Q_n > 0`. Define the inputs exactly as in
`analytic:input-functions`:

\[
\begin{split}
U_i(s)={}&e^{-\pi Hs}\sum_{n\in L}
 \{c_{i,n}\kappa^2P(s)\csc^2\kappa(s-n)
       +d_{i,n}\kappa P(s)\cot\kappa(s-n)\}\\
&+C_i e^{-\pi hs}P(s)
+e^{-\pi hs}\sum_{n\in T}
 \{c_{i,n}P(s)/(s-n)^2+d_{i,n}P(s)/(s-n)\}.
\end{split}
\]

All apparent poles are removed. The fixed coefficients are

\[
c_{1,0}=c_{2,0}=11/25,\quad d_{1,0}=d_{2,0}=0,\quad
C_1=-3/500,\quad C_2=3/500.
\]

Set `F_1=U_1+hat U_2`, `F_2=U_2+hat U_1`, and `J_i=e^{pi h s}F_i`.
For `alpha >= 1` put

\[
z=\{\pi(\alpha/b-h)\}^{-1}>0,\qquad
G_z(s)=Q_1z e^{(1-s)/z}.
\]

The desired jets are `J_1(n)=G_z(n)`, `J_1'(n)=G_z'(n)`,
`J_2(n)=J_2'(n)=0` at **all** `n in N`.

The lattice `A=b^{-1/2}{(m+n/2,bn):m,n in Z}` has covolume one and
`b|a|^2=m^2+mn+n^2`. Enumeration of the 36-by-36 residue square in the
checker establishes a modular identity, not a cutoff on lattice vectors:
the full residue set of that integer polynomial is exactly `I`, since
reduction modulo 36 commutes with polynomial evaluation.
The dual is a quarter-turn of `A`: writing `a_1,a_2` for its positively
oriented area-one basis and `R` for a counterclockwise quarter-turn, the
dual basis is `-R a_2,R a_1`. Consequently `A` and `A*` have the same radii.
Every nonzero required physical or dual shell is therefore included.

## 2. Spectral formulas, normalization, and convergence

### Exact finite-column identities

Take `q=exp(i pi/18)`. It satisfies `q^12-q^6+1=0`, `q^36=1`, and
`q^9=i`. In the integer ring `Z[X]/(X^12-X^6+1)`, the checker constructs
the Laurent polynomial

\[
\prod_{a\in I}(2-q^{-a}Y-q^aY^{-1})
\]

by exact integer operations. For every residue `n`, its value and first
Euler derivative at `Y=q^n` vanish exactly. To construct the column at `n`,
it removes that factor. Multiplication by `4 kappa^2` gives the double-pole
column; multiplication by
`kappa(-i q^{-n}Y+i q^nY^{-1})` gives the simple-pole column.
It then checks coefficientwise, for every `n in L` and `0 <= j <= 15`,
the two identities

\[
\begin{split}
M_{j;c,n}&=-4\kappa^2 b_j
 \sum_{\ell=j+1}^{15}(\ell-j)P_\ell q^{(\ell-j)n},\\
M_{j;d,n}&=i\kappa b_j
 \left(P_j+2\sum_{\ell=j+1}^{15}P_\ell q^{(\ell-j)n}\right),
\qquad b_j=2-\mathbf1_{j=0}.
\end{split}
\]

Thus these are identities of the specified columns, not guessed spectral
data. The zero-frequency coefficient is **not doubled**.
The local data are computed independently from the product:

\[
Q_n=4\kappa^2\prod_{a\ne n}(2\sin\kappa(n-a))^2,\qquad
D_n=2\kappa\sum_{a\ne n}\cot\kappa(n-a).
\]

### Tail columns

For `u=s-n`, the identities

\[
\frac{e^{i\pi au}-1}{u}=i\pi\int_0^a e^{i\pi tu}\,dt,\qquad
\frac{e^{i\pi au}-1-i\pi au}{u^2}
 =-\pi^2\int_0^a(a-t)e^{i\pi tu}\,dt
\]

hold with oriented integrals, including `a<0`, and by continuity at `u=0`.
Sum with coefficients `P_l exp(i pi t_l n)`, where `t_l=l/18`.
The constant and linear terms cancel by the exact double-zero identities
just verified. Splitting positive and negative frequencies and pairing
conjugates gives, on `(t_{j-1},t_j)`, the folded densities

\[
\rho_{c,n}(t)=-2\pi^2\sum_{\ell=j}^{15}
 (t_\ell-t)P_\ell e^{i\pi(t_\ell-t)n},\qquad
\rho_{d,n}(t)=2i\pi\sum_{\ell=j}^{15}
 P_\ell e^{i\pi(t_\ell-t)n}.
\]

There is no atom at zero in either continuous measure. Direct integration
of absolute values gives the uniform column-variation majorants

\[
W_{j,c}=2(\pi/18)^2\sum_{\ell=j}^{15}
 (\ell-j+\tfrac12)|P_\ell|,\qquad
W_{j,d}=(2\pi/18)\sum_{\ell=j}^{15}|P_\ell|.
\]

All node-dependent phases have modulus one. In particular these bounds
require no powers of the node index in the coefficient norm.

### Fourier waves

For `k>0` and `|t|<=5/6` the physical wave is
`Phi_{k,t}(x)=exp(-pi b(k-it)|x|^2)`. Its exact two-dimensional transform is

\[
\widehat\Phi_{k,t}(\xi)
 =\frac1{b(k-it)}\exp\{-\pi|\xi|^2/[b(k-it)]\}.
\]

For positive real parameters this follows by the one-dimensional Gaussian
integral, differentiation of its Fourier integral and integration by parts,
and then taking the product of two coordinates. Holomorphic continuation
on the right half-plane establishes the complex formula. There is no
square-root prefactor in dimension two. Dividing by `exp(-pi v s)` yields
exactly `lambda_k(t) exp(i pi zeta_{k,v}(t)s)`, with

\[
X_k=\frac{B}{k^2+t^2},\quad
\lambda_k=\frac{k+it}{b(k^2+t^2)},\quad
\zeta_{k,v}=-tX_k+i(kX_k-v).
\]

For `k,v in {h,H}`, the minima of `kX_k-v` over the entire frequency
interval occur at its endpoints. Their exact values, in the order
`(h,h),(h,H),(H,h),(H,H)`, are

\[
100079/455650,\quad8949/455650,\quad
216419/554650,\quad105489/554650,
\]

all positive. The checker verifies these rational identities.

For every Schwartz seminorm, derivatives of `Phi` are a polynomial times
the fixed Gaussian modulus `exp(-pi b k |x|^2)`, with coefficients uniformly
bounded on the compact frequency interval. Integration against a finite
measure is therefore bounded in that seminorm by a constant times total
variation. The uniform tail-variation bounds give convergence in **every**
Schwartz seminorm for every `ell^1` coefficient list. For the transforms,
the reciprocal Gaussian parameters form another compact subset of the
right half-plane. The same proof applies. This justifies all sums,
removable jets, Fourier interchanges, and differentiations used here.
Fubini can also be used for the Fourier integrals, since the wave's
physical `L^1` norm is `1/(bk)`, independently of `t`.
Reality follows from conjugate symmetry and taking real parts after
folding. Radial evenness and Fourier inversion give `hat F_1=F_2`.

## 3. What the finite certificate establishes

All numbers in this section are rigorously enclosed, not floating-point
measurements. The following table abbreviates the named records in
`exact_certificate.json`.

| Quantity | Certified bound |
|---|---:|
| `Q_n`, for every residue | `0.157 < Q_n < 40` |
| `abs(D_n)`, for every residue | `< 2.83` |
| `Q_16,Q_19,Q_21` | `> 16` |
| `||(I-R)^(-1)||_1` | `< 16.16 < 17` |
| `||(I+R)^(-1)||_1` | `< 3.89 < 5` |
| finite lists `||A_1 e||_1, ||A_2 e||_1` | `< 2.58, < 2.80` |
| tail variation norm | `< 119` |
| tail-to-finite envelope | `< 335 < 340` |
| transformed finite-to-tail envelope | `< 7e-15` |
| direct repetition envelope | `< 2.5e-10` |
| tail-to-tail envelope | `< 2.3e-8 < 3e-8` |
| transformed constant-to-tail envelope | `< 1.27e-7 < 1.3e-7` |
| omitted finite target | `< 8.1e-8 < 8.2e-8` |
| omitted tail target | `< 9.2e-29 < 1e-26` |

Here `R` is the actual opposite-side jet correction matrix defined by
`eq:finite-jet-map`, with damping `H` for its rows and pole columns.
`A_i` is computed from precisely the fixed columns and truncated targets of
`eq:finite-system`, not from a surrogate inverse problem.

The Gaussian data
`e=(z,1,zw,w,zu,u,zp,p)`, where `w=exp(-2/z)`, `u=exp(-3/z)`,
and `p=exp(-6/z)`, lie in the complete polytope

\[
\begin{split}
\mathcal E=\{&(z,1,Zw-\Delta,w,a,u,r,p):\\
&0\le z\le Z=.391,\quad0\le w\le .0061,\quad0\le\Delta\le .00018,\\
&0\le u\le .00048,\quad0\le a\le Zu,\quad
0\le r,p\le .0000003\}.
\end{split}
\]

Indeed the maximal physical `z` is less than `Z`; the three endpoint
exponentials are less than their displayed bounds. The maximum of
`(Z-z)exp(-2/z)` is attained at `sqrt(1+2Z)-1` and is below `.00015`.
Also `zu<=Zu` and `zp<=p`, since `Z<1`.
These endpoint and critical-point comparisons are enclosed by the checker.

The checker forms all deleted-jet Taylor polynomials of degree 20 on the
14 signed half-cells. It recomputes all 27 ordinary sign tests and all four
exceptional tests, with the strict thresholds in
`eq:finite-sign-tests` and `eq:exceptional-tests`.
For clarity, these are **659 Bernstein coefficient rows over the entire
polytope**, not tests at 659 points. For a scalar row
`(b,c,l,d,k,j,n,r)`, the minimum is exactly

\[
c+Z\min(b,0)+W_*\min(d+Zl,0)+\Delta_*\min(-l,0)
+U_*\min(0,j,j+Zk)+P_*(\min(n,0)+\min(r,0)).
\]

This follows by independent minimization of `z,w,Delta,r,p` and the
three vertices of `0<=a<=Zu,0<=u<=U_*`.
Power coefficients are converted by
`b_i=sum_{r<=i} binom(i,r)/binom(N,r) t_r`, for `N=20` or `22`.
Expanding the binomial theorem gives this identity, and the Bernstein
basis is nonnegative with sum one on `[0,1]`.
Thus these finite rows prove the polynomial inequalities on a continuum
of parameters and displacements.

### Arithmetic soundness

`Bound` encloses a real number by integer endpoints with denominator
`10^72`; multiplication uses the extrema of the four endpoint products,
division excludes zero, and square root uses integer square roots.
The specialized square routine accounts for intervals crossing zero.
Complex numbers are rectangles. All rounding is outward using integer
floor/ceiling division, including at negative numbers.
Machin's identity gives `pi` from two 60-term alternating rational sums,
each bracketed by its next term. Exponentials use range reduction to
modulus at most one, 100 Taylor terms, and repeated squaring. The omitted
norm is at most `2/101! < 10^-72`, explicitly checked. Each endpoint
comparison is strict. Gauss--Jordan elimination uses interval operations
and only replaces entries by zero or one when the row-operation identity
establishes that value exactly.
Cyclotomic coefficient identities use integers only.

## 4. Infinite interpolation and correction estimates

At node `n`, after removing its own damping `v` (`H` on `f`, `h` on `T`),
the direct coefficient jets are

\[
Q_n(c_n,d_n+D_nc_n).
\]

For a transformed contribution `Z`, cancelling its jets changes these
coefficients by `Q_n^{-1}(-Z(n),D_nZ(n)-Z'(n))`. Thus one Fourier wave
contributes exactly

\[
Q_n^{-1}\lambda_k e^{i\pi\zeta_{k,v}n}
 (-1,D_n-i\pi\zeta_{k,v}).
\]

Inverting the direct map on the desired physical target gives

\[
\frac{Q_1}{Q_n}e^{\pi(v-h)n+(1-n)/z}
 \bigl(z,-1+(\pi(v-h)-D_n)z\bigr).
\]

These are the manuscript's actual coefficient equations.
The periodic finite column at `n in L` also contributes at `n+36l`, `l>=1`.
In tail coefficient coordinates its contribution is
`exp(-pi eta(n+36l))(c_n,d_n-pi eta c_n)`.
It is **subtracted on the same side**, not exchanged with the opposite
side. Its norm is at most
`(1+pi eta)/(exp(36 pi eta)-1)`. This includes the fixed node zero.
There are no other direct cross-terms: the other residue columns have
double zeros, and each rational tail column has only one removable pole.

To pass from the finite frequency envelopes to **every** tail node, write

\[
\psi_{k,v,n}(t)=
\frac{(1+|D_n|+d_b)\sqrt{X_k}}{Q_n}
 e^{-\pi(kX_k-v)n},\qquad
d_b=\pi\sqrt{v^2+(B-2kv)X_k}.
\]

The logarithmic derivative of its prefactor with respect to `X_k` is at
most `1/X_k`, because `B-2kv>0`. The exponential contributes `-pi k n`.
For `n>=1`,
`1/X_k <= (k^2+25/36)/B < 3k < pi k n`.
Consequently `psi` increases with `t` on `[0,5/6]`.
The right endpoint of each frequency interval bounds its full continuous
tail density, so the `W` majorants are sufficient without quadrature.
Periodicity of `Q,D` gives the exact geometric sum

\[
\sum_{m\in T}\psi_{k,h,m}(t)=
\frac{\sum_{n\in T_0}\psi_{k,h,n}(t)}
 {1-e^{-36\pi(kX_k-h)}},\qquad T_0=T\cap[25,61).
\]

`T_0` has all 15 residues once; every element of `T` has a unique such
representation. Its denominator is strictly positive by Section 2.
This proves the claimed all-node operator bounds from the finite
enclosures, not merely bounds for the first tail period.

Let `Bop` denote opposite-side tail-to-finite correction, `Cop` finite-to-tail
transformed correction, `Dop` tail-to-tail transformed correction, and `Aop`
the same-side direct repetition. The bounds above give

\[
\|Bop\|<340,\quad\|Dop\|<\delta=3\,10^{-8},\quad
\|Cop\|+\|Aop\|<\beta=3\,10^{-10}.
\]

Finite absolute column sums give bounded `ell^1` maps: Tonelli applied to
the entrywise majorant proves absolute convergence, and density of
finitely supported lists then defines the full operators.

For `epsilon=+1,-1`, form sums/differences `u_epsilon=u_1+epsilon u_2`,
and similarly for `w,r,s`. The **exact** system is

\[
(I-\epsilon R)u_\epsilon-\epsilon Bop\,w_\epsilon=r_\epsilon,\qquad
(I-\epsilon Dop)w_\epsilon-(\epsilon Cop-Aop)u_\epsilon=s_\epsilon.
\]

With `L_epsilon=(I-epsilon R)^(-1)`, substitution gives

\[
[I-\epsilon Dop-(\epsilon Cop-Aop)L_\epsilon\epsilon Bop]w_\epsilon
=s_\epsilon+(\epsilon Cop-Aop)L_\epsilon r_\epsilon.
\]

Notice the repetition sign has not changed in the difference equation.
The operator removed from the identity has norm less than
`delta+340 beta N_epsilon<1`, with `N_+=17,N_-=5`.
Its Neumann series converges in operator norm on the complete `ell^1`
space. Substitution recovers the finite lists. Conversely every solution
must satisfy these reversible equations, proving uniqueness.
The targets and fixed-column residuals belong to `ell^1`, as follows from
the displayed geometric sums and the target's exponential decay.

For the error from the actual finite approximant, set

\[
d=8.2\,10^{-8},\quad
d'_+=10^{-26}+6\beta,\quad
d'_-=10^{-26}+6\beta+.012(1.3\,10^{-7}).
\]

The finite trigonometric lists, including their fixed rows, have total norm
below six. The constant columns cancel in the sum; their coefficient
difference is `.012`. Applying the same inverse to the residual gives

\[
e'_\epsilon=\frac{d'_\epsilon+\beta N_\epsilon d}
 {1-\delta-340\beta N_\epsilon},\qquad
e_\epsilon=N_\epsilon(d+340e'_\epsilon).
\]

Exact rational evaluation in the independent checker gives individual
half-sum bounds

\[
\|w_i\|_1<2.581\,10^{-9}<3\,10^{-9},\qquad
\|u_i-(A_ie)_f\|_1<8.961\,10^{-6}<10^{-5}.
\]

This proves exact interpolation and approximation for every `alpha>=1`,
including summability and Schwartz convergence, without solving any
truncated tail as a proxy.

## 5. All-radius signs

For a twice differentiable function let

\[
U_m[\varphi](v)=
\int_0^1(1-t)\varphi''(m+tv)\,dt.
\]

For `v!=0` this is the function minus its value and linear jet at `m`,
divided by `v^2`; at zero it is half the second derivative. Thus exact
jets give

\[
G(m+v)-J_1(m+v)=v^2(U_m[G]-U_m[J_1]),\qquad
J_2(m+v)=v^2U_m[J_2].
\]

### Curvature and truncation

Direct differentiated waves have magnitude at most
`d_a^2 exp(-s E_a)`, where `d_a=pi sqrt(t^2+(k-h)^2)`,
`E_a=pi(k-h)`. Transformed waves have magnitude at most
`d_b^2 sqrt(X_k) exp(-s E_b)`, with `v=h` and
`E_b=pi(kX_k-h)>0`. The certified half-curvature envelopes per unit
coefficient on `s>=s_0` are

| `s_0` | `0` | `1` | `2` | `14.5` | `23` |
|---|---:|---:|---:|---:|---:|
| finite pole lists | `1510` | `46` | `14` | `.00465` | `.000023` |
| tail lists | `26500` | `1160` | `800` | `800` | `800` |

Both input lists are included in these envelopes: each separate
direct/transformed maximum is multiplied by its own list norm and then
added; no missing factor of two is hidden here.
For tail measures, the direct maximum is at `t=5/6`.
The transformed factor is proportional to
`(h^2+(B-2h^2)X)sqrt(X)exp(-pi(hX-h)s)`.
At `s=0` it increases with `X`; at `s>=1` its logarithmic derivative is
at most `3/(2X)-pi h s<0`, by the checked exact endpoint inequality.
This proves the full-frequency maxima used in the tail row.
The transformed constant has half-curvature at most `.002` per unit
coefficient for `s>=14.5`.

For one exponential wave `exp(ws)`, the degree-20 divided-jet Taylor
remainder is bounded by

\[
\frac{d^2(|y|d)^{21}e^{-mE}}{23!\,(1-|y|d/24)},\qquad
d=|w|,\quad E=-\operatorname{Re}w.
\]

Indeed this majorizes the first omitted term and all successive ratios.
The denominator is positive: `|y|<=1.5`, `d_a<3`, `d_b<12`.
Weighting by the finite list bound three and constant coefficient `.006`
gives errors below `.002` at `m=1` and `.00001` at subsequent tested nodes.
The coefficient correction norms and the curvature table therefore give
the following errors between exact deleted jets and finite polynomials:

\[
\begin{array}{c|c}
(m,y)&|U_m[J_i](y\tau)-T_i(\tau)|\\\hline
(1,-1)&<.018\\
(1,1)&<.003\\
m\ge3&<.00016
\end{array}\qquad(0\le\tau\le1).
\]

The checker verifies the exact rational sums producing these bounds.

### Gaussian comparisons and the first seven cells

Convexity gives `U_m[G]>=0`. For `v<=0`, its integral formula gives
`U_m[G]>=Q_1 exp((1-m)/z)/(2z)`. For `v>=0`,

\[
U_m[G](v)\ge Q_1e^{(1-m)/z}
 \frac{3z+v}{6z^2+4zv+v^2}.
\]

To prove the latter, put `x=v/z` and
`q(x)=exp(-x)(6+4x+x^2)-6+2x`. Direct differentiation gives
`q(0)=q'(0)=0`, `q''(x)=x^2 exp(-x)>=0`, and the required rational
inequality follows after multiplying by its positive denominator.
The polynomial identities behind this calculation are checked exactly.

The seven cells, with their half-displacements, are

\[
\begin{array}{c|c|c}
1 &[0,2]&-1,1\\
3 &[2,3.5]&-1,.5\\
4 &[3.5,5.5]&-.5,1.5\\
7 &[5.5,8]&-1.5,1\\
9 &[8,10.5]&-1,1.5\\
12&[10.5,12.5]&-1.5,.5\\
13&[12.5,14.5]&-.5,1.5
\end{array}
\]

On the left half-cell at one, the finite tests give `T_2>.174` and
`Q_1/(2Z)-T_1>.057`. Subtracting `.018` proves both comparisons,
including the endpoint `s=0`. On the right half-cell, `T_2>.011` and
the `.003` error prove side two.
At `m=3`, the Gaussian rational lower bound is decreasing in each of
`z,v>=0`; its value at `(Z,.5)` is `836500/974643>.8`.
For `v<=0` the same `.8` lower bound follows from `1/(2Z)>.8`.
The finite tests `.8 Q_1 w-T_1>.00055` and `T_2>.00097`,
less the `.00016` error, prove both comparisons.
For `m=4,7,9,12,13`, the tested bounds for `-T_1` and `T_2` are
at least `.00047`, and convexity completes the comparison after the same
error. This treats every half-cell except side one to the right of one.

For that exception, at a fixed allowed `(w,Delta,a,u,r,p)` the polynomial
`-T_1` is affine in the free coordinate `z`. Let its endpoint values be
`A(v),D(v)` at `z=0,Z`. Multiply the desired comparison, after the `.003`
error, by `B(z)=v^2+4zv+6z^2`. Its Bernstein coefficients as a cubic in
`z/Z`, before subtracting the error, are

\[
\begin{split}
&v(Q_1+vA),\\
&Q_1(v+Z)+(2B_1A+B_0D)/3,\\
&Q_1(v+2Z)+(B_2A+2B_1D)/3,\\
&Q_1(v+3Z)+B_2D,
\end{split}
\]

where `B_0=v^2,B_1=v^2+2Zv,B_2=v^2+4Zv+6Z^2`.
The independently checked exceptional tests bound the parenthesized
first expression below by `.046`, and the others by `.056,.024,.027`.
On `0<=v<=1`, `0<=B_0<=B_1<=B_2<3.5`. Subtracting `.003` from
both `A,D` leaves the first coefficient nonnegative, and the others
strictly positive. This is a polynomial positivity proof on the
**containing** polytope, not an interpolation of the exponential data
as functions of `z`. At `v=0`, actual `z>0` gives positive Bernstein weight
to a nonzero coefficient; `B(z)>0` permits division.
Exact contacts at the interpolation nodes complete both signs on
`[0,14.5]`.

### All remaining gaps

Let `m` be a nearest zero of `P` to `s`. On each half-gap,
`P(s)/(s-m)^2` is log-concave: ordinary sine-square factors contribute
`-2 kappa^2 csc^2(kappa(s-a))` to the logarithmic second derivative,
while the removed factor contributes
`2((s-m)^(-2)-kappa^2 csc^2(kappa(s-m)))<=0`.
The latter inequality is `abs(sin x)<=abs(x)`; the removable endpoint
is obtained by continuity. Concavity of the logarithm bounds the quotient
below by the smaller of its endpoint values.

The independent direct-product midpoint bounds are, in consecutive
gap order starting with `(0,1)`,

\[
.165,.120,.054,.482,.656,1.11,.337,3.13,9.26,
8.19,19.08,2.34,.706,6.80,14.1.
\]

Together with `Q_n>.157` this proves
`P(s)>.054(s-m)^2` off every zero, on the full real line by periodicity.
For `14.5<=s<=23`, the relevant node values exceed 16 and the relevant
midpoint values exceed three, so the stronger bound is
`P(s)>3(s-m)^2`, with `m=16,19,21` on the respective nearest-node cells.

Write `J_i=C_i P+J_i^0`. Subtracting the direct constant preserves all
positive-node jets. The half-curvature of `J_i^0` along the segment joining
`m` and `s` is bounded by

\[
K=3.01 q+800(3\,10^{-9})+.006(.002),\qquad
q=\begin{cases}.00465&14.5\le s\le23,\\ .000023&s>23.\end{cases}
\]

For the middle range choose `m=16` on `[14.5,17.5]`, `19` on
`[17.5,20]`, and `21` on `[20,23]`. These segments stay in `[14.5,23]`.
For `s>23`, every nearest zero is a positive node at least 25, and
the segment stays above 23. Thus the relevant curvature bounds apply
to **each whole joining segment**. The certified comparisons are

\[
\begin{array}{c|c|c|c}
\text{range}&K&.006P(s)/(s-m)^2\text{ is greater than}&\text{margin}\\\hline
[14.5,23]&.0140109&.018&.0039891\\
(23,\infty)&.00008363&.000324&.00024037 .
\end{array}
\]

On side two, the zero jets now give
`J_2(s)>=.006P(s)-K(s-m)^2>=0`.
On side one, matching jets and convexity of `G` give
`J_1(s)<=G(s)-.006P(s)+K(s-m)^2<=G(s)`.
At nodes the equalities already hold. This covers the full unbounded
half-line, including all later periods of the rational tail.

## 6. Normalization and the boundary extension

The positive normalization `D=Q_1 z exp(1/z)` satisfies

\[
D^{-1}e^{-\pi hs}G_z(s)
=e^{-(\pi h+1/z)s}=e^{-\pi\alpha|x|^2}.
\]

Consequently `f_alpha=F_1/D` is real radial Schwartz,
`f_alpha(x)<=exp(-pi alpha |x|^2)`, and `hat f_alpha=F_2/D>=0`
everywhere. All required lattice contacts and dual zeros follow from
the exact positive-node jets and the modular/dual-lattice calculation
in Section 1. This proves the verification theorem.

For the additional endpoint result, the linear coefficient operator
in Section 4 is independent of `z`. Its right-hand side extends
continuously in the finite-plus-`ell^1` norm to `z=0`: the target
coefficients at node one tend to the finite pair corresponding to
`J_1(1)=0,J_1'(1)=-Q_1`; all other target jets tend to zero.
On the tail they are dominated by a summable geometric sequence at
`z=Z`, so continuity follows by dominated convergence for series.
The bounded inverse therefore extends the coefficient lists continuously.
Section 2's seminorm bounds make the resulting `F_i` Schwartz-continuous.

For every fixed `s>1`, `G_z(s)->0`, and at one it tends to zero as well.
The already proved signs pass to the limit, giving

\[
F_1^0(x)\le0\quad(b|x|^2\ge1),\qquad
F_2^0=\widehat F_1^0\ge0\quad\text{everywhere}.
\]

At all positive nodes both functions have value zero. The first member
has scalar derivative `-exp(-pi h)Q_1` at node one; at the other
positive nodes both value and first derivative vanish.
The side-two left-cell margin gives `F_2^0(0)>=.174-.018=.156>0`.
Thus this is a nonzero pair, not a zero-function limit of the normalized
Gaussian minorants.

Poisson summation for a Schwartz function on the area-one lattice gives
`F_1^0(0)=F_2^0(0)>0`, since all its nonzero shell samples vanish
on both sides. One can derive this instance of Poisson summation by
periodizing the Schwartz function over `A`; absolute convergence of
every derivative gives a smooth periodic function whose Fourier
coefficient at `w in A*` is the Fourier transform at `w`.
Both Fourier series converge absolutely, and evaluation at zero gives
the identity. This proves the sharp packing normalization without using
any assertion from the other staged manuscripts.

## 7. Evidence boundaries and replay

From the campaign root run

```text
$WORKSPACE/argus-live-update/.venv/bin/python research/atomic-gaussian-audit/verify.py
```

Default mode recomputes all data and compares the complete deterministic
result with `exact_certificate.json`; it does not overwrite that file.
`--write-certificate` explicitly regenerates it.
There are 404 exact identity checks and 121 named outward enclosures in
the initial certificate; the count increases if additional comparisons
are added. Polynomial tests cover 659 Bernstein rows.

One bounded Jacobian operation was inspected and executed through the
prescribed adapter:
`interval.expression.box_enclosure.compute`, server `0.14.0`,
protocol `2025-11-25`. Its exact input is `jacobian_request.json` and its
typed output is `jacobian_result.json`. Natural Arb interval propagation
reported `DOMAIN_UNPROVEN` at a division node for the full frequency box.
The adapter process exited zero, with no transport error or timeout, but
its mathematical output is a **non-conclusion**. It supports neither this
theorem nor a refutation. The positive decay assertion used here is instead
the exact rational endpoint calculation plus monotonicity in Section 2.
The independent checker requires no Jacobian installation or live service.

No false literal manuscript assertion was found in the audited construction,
so no `F_` refutation claim is manufactured. A Reviewer finding one must
register and judge it separately rather than overwrite this conclusion.
The present report has no external theorem assumption beyond foundational
real/complex analysis, with the specific Fourier and operator arguments
given above. Literature retrieval is background only: CKMRV,
`arxiv:1902.05438v3`, Introduction Section 1.2, describes the previously open
planar universal-optimality question and its proved eight- and
twenty-four-dimensional results. It is not being invoked as a proof of
this construction. An automated search summary that suggested a full planar
Lean formalization was not supported by an inspected primary formal source
and is not used as evidence. Current novelty and independent certification
are not inferred from that search.
