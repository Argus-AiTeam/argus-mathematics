# Controlled-volume switching

## Exact source and scope

The source is the staged September 25, 2026 manuscript
`A-finite-entropy-system-without-a-smooth-positive-volume-model-September-25-2026`.
All section references below are to its `build/sections/` directory.
The assertion under audit is the last displayed inequality of
`04-switching.tex`, in the proof of `thm:switching`:

\[
             \Phi_*(\rho_k|_{G_k})\leq 2\rho_k.                 \tag{S}
\]

Here \(M\) is compact, smooth, of positive finite dimension, optionally
with smooth boundary; \(S\) is a smooth diffeomorphism preserving a
strictly positive smooth probability density \(\nu\). For \(n=2^k\),
the partition \(\mathcal D_k\) consists of full oblique product cells
and one omitted-points cell. Its probability pair law is

\[
 \rho_k=\sum_{\nu(Q)>0}\frac{\nu|_Q\otimes\nu|_Q}{\nu(Q)}.
\]

Both marginals are exactly \(\nu\). Neither the restriction to \(G_k\)
nor a further restriction to endpoint labels is normalized. The switch
is ordered: \(\Phi(x,y)=(z,w)\). Both outputs must remain in the
*same* original product cell. A Jacobian computation without injectivity
does not imply (S).

The common starting basis has separately orthonormal slow and fast
columns, but need not be orthogonal as a whole. Its inverse may grow as
\(e^{Cbn}\). The threshold \(\gamma_Q\), dimensions, reference spaces,
and endpoint projections are fixed by finitely many bins, not chosen
measurably from input-dependent frames. Rates and their sums can have
either sign. Zero-dimensional groups use determinant and exterior
power zero equal to one.

The retained inputs have positive product-face and endpoint-bin
margins. The outputs need not be good points. The recovery formula is

\[
 (U_x,V_x,U_y,V_y)=
 (\operatorname{bin}(S^nz),\operatorname{bin}(S^{-n}w),
  \operatorname{bin}(S^nw),\operatorname{bin}(S^{-n}z)).
\]

The source proves a zero-entropy obstruction, not just finite entropy.
Its model hypothesis is a strictly positive smooth density, not full
support or mere absolute continuity. The finite-entropy Lean comparator
is not evidence for the zero-entropy theorem.

## Source-grounded dependency map

| Claim | Source proposition | Mathematical role |
|---|---|---|
| `C152_MAIN` | `01-introduction.tex`, `thm:main` | Ergodic, invertible, nonatomic zero-entropy system without the stated smooth model |
| `C152_STATIONARY` | `02-stationary.tex`, `lem:dyadic`, `prop:good-frames` | Summable chord errors and compact good frame sets |
| `C152_LINEAR` | `03-linear.tex`, `prop:finite-splitting` | All-subinterval exterior bounds, oblique splitting and intrinsic leading volumes |
| `C152_BIN` | `03-linear.tex`, `lem:bin-spaces` | Common threshold, starting spaces and fixed endpoint projections |
| `C152_RELATIVE` | `03-linear.tex`, `lem:relative-exterior` | Relative, rather than absolute, perturbation of signed exterior growth |
| `C152_ORBITS` | `04-switching.tex`, `lem:switch-orbits` | Boundary inverse, sharp orbit joins, larger uniqueness tube and wall margins |
| `C152_JACOBIAN` | `04-switching.tex`, `lem:switch-jacobian` | Four relative determinants and the joint density Jacobian |
| `C152_INJECTIVE` | `04-switching.tex`, `lem:switch-injective` | Label recovery, boundary uniqueness and disjoint output pieces |
| `C152_VOLUME` | `04-switching.tex`, final proof | Unnormalized joint measure domination (S) |
| `C152_WORDS` | `05-words.tex`, `prop:words`, `lem:recognition`, `lem:rates` | Hierarchical words, recognition, rates and graph relations |
| `C152_SYSTEM` | `06-process.tex`, `prop:system` | Ergodic nonatomic zero-entropy phase extension |
| `C152_WINDOWS` | `06-process.tex`, `lem:aligned-law`, `prop:window-entropy`, `lem:graph-windows` | Aligned sampling, window entropy and simultaneous graph constraints |
| `C152_OBSTRUCTION` | `07-obstruction.tex`, `lem:cheap-scales`, `lem:graph-independent`, `lem:symbol-matching` | The final statistical contradiction |

These are dependencies, not declarations that the full manuscript is
proved. The symbolic claims remain outside this analytic mission.
The strongest prior project state contained only the open audit goal,
with no supporting mathematical evidence.

## Literature boundary

Section 04 cites Smale (1967), section I.7, for historical local-product
geometry and Chow--Lin--Palmer (1989), Lemma 3.2 and Proposition 4.1,
for a shadowing precedent. Its own text explicitly supplies the
finite-interval boundary inverse instead of invoking either result.
Neither literature theorem is an assumption of the argument here.
Likewise the frame construction in Section 02 is supplied explicitly;
the reference to Oseledets is historical, not a limiting-splitting or
convergence-rate hypothesis.

No claim of a literature-verified novelty result is made at scope.
In particular, an algebraic determinant check or a finite no-witness
search cannot close `C152_VOLUME` or the campaign.

## Theorem: controlled-volume switching at Holder regularity

Fix \(0<\alpha\leq1\). Suppose instead that \(S\) is a
\(C^{1,\alpha}\) diffeomorphism and that its invariant probability
\(\nu\) has a continuous, strictly positive density in smooth charts.
Then the entire conclusion of `thm:switching` holds. More precisely,
the same finite-bin construction gives a Borel injective complementary
switch and numbers \(K_k\longrightarrow1\) such that

\[
 \Phi_*(\rho_k|_{G_k})\leq K_k\rho_k,\qquad
 (z_k)_*(\rho_k|_{G_k})\leq K_k\nu.                         \tag{1}
\]

In particular (S) holds under the manuscript's actual, stronger
hypotheses. The statement includes oblique splittings, empty groups,
and smooth boundary. This is a regularity extension of the *analytic
switching theorem*, not a claim that the symbolic zero-entropy
construction has been independently verified.

What follows is an engineer's mathematical proof, with exact universal
scalar and combinatorial obligations checked by `verify.py`.
It is not a Lean formalization; independent mathematical review,
including statement fidelity and the measure argument, remains required.

### 1. Stationary input and finite linear estimates

Here are derivations of the upstream estimates, so (1) is not
conditional on an unexamined Lyapunov convergence rate.

For a stationary square-integrable process, let \(A_h\) be its mean
on a block of length \(2^h\), and set
\(v_h=\mathbb E A_{h-1}^2-\mathbb E A_h^2\).
If \(U,V\) are the child means and \(W=(U+V)/2\), stationarity and
\((V-W)=-(U-W)\) give
\(v_h=\mathbb E(U-W)^2\geq0\). Thus
\(\sum v_h\leq\mathbb E Y_0^2\).
Refine the cumulative-sum chord one dyadic generation at a time.
At generation \(a\), the normalized displacement at a new midpoint
is \(2^{-a-1}(U-W)\). The squared maximum over \(2^a\)
intervals is bounded by the sum of their squares, so its \(L^2\)
norm is at most \(2^{-a/2-1}\sqrt{v_{h-a}}\).
The triangle inequality and convolution with the summable sequence
\((2^{-a/2-1})_{a\geq0}\) yield
\[
 \sum_h\|Z_h\|_2^2<\infty.                                  \tag{2}
\]
This argument uses stationarity, not independence.

Positive-diagonal QR applied to \(DS\) acts continuously and
invertibly on the compact orthonormal frame bundle. Start with the
fiberwise rotation-invariant probability over \(\nu\), and average
its iterates. Compactness of probabilities on a compact metric space
gives an invariant subsequential limit with the same base marginal.
The continuous bounded functions \(\log R_{jj}\) are stationary on
this lift. Apply (2), and denote the combined \(L^2\) majorant at
length \(2^{k+1}\) by \(a_{k+1}\), with \(\sum a_h^2<\infty\).
For example
\[
 b_k=40\eta^{-1/2}a_{k+1}+2^{-k/10}
\]
has square-summable terms and the required floor. The union squared
Markov bound for the chord on \([-n,n]\) is
\(4a_{k+1}^2/b_k^2\leq\eta/400\).
The finitely many non-strict chord inequalities define a compact
frame set. Its base projection loses no more measure. Subtracting
two chord errors bounds every subinterval error by \(2bn\).
All of this needs continuity and invertibility of \(DS\), not \(C^2\)
regularity.

For completeness, write the triangular steps in a good moving frame
as \(A_t\), their diagonal average rates as \(\lambda_j\), and the
diagonal chord errors as \(e_j(t)\). Conjugating by
\(D_t=\operatorname{diag}(\exp e_j(t))\) makes the diagonal constant
\(\exp\lambda_j\), at an endpoint cost \(e^{Cbn}\).
The new entries and inverse entries are \(e^{Cbn}\)-bounded.
A product entry in a fixed-dimensional triangular matrix can change
its index at most dimension minus one times. Consequently it is a
sum of at most polynomially many terms in \(n\), each bounded by
the largest diagonal exponential times \(e^{Cbn}\).
The polynomial loss is absorbed by \(\log(2n+1)\leq bn\).

Apply this argument to each exterior power. Its triangular diagonal
entries are the exponentials of the corresponding sums of rates.
A largest diagonal entry supplies the lower operator-norm bound;
the path count supplies the upper bound. The same reasoning applies
to inverse steps in reverse order. Thus on every subinterval
\[
 \left|\log\|\bigwedge^q A(t,s)\|
  -(t-s)\sum_{j=1}^q\lambda_{(j)}\right|\leq Cbn.              \tag{3}
\]

To separate the rates at a threshold \(\gamma\), eliminate entries
between the two index groups in increasing superdiagonal order.
The elementary shear coefficient satisfies
\[
 u_{t+1}=q u_t+f_t,\qquad q=e^{\lambda_i-\lambda_j}.
\]
Use initial value zero if \(q<1\), terminal value zero if \(q>1\).
In the appropriate direction every summation coefficient has modulus
at most one, so \(|u_t|\leq2n\max|f_t|\); division by a small gap is
unnecessary. Upper triangularity prevents a later shear from
reintroducing earlier entries. Only a dimension-dependent number
of shears is needed. Their accumulated gauge and inverse are
\(e^{Cbn}\)-bounded.

The two coordinate index groups now give invariant spaces.
Their projections and matching bases have inverse cost \(e^{Cbn}\).
Triangular path counting in each block yields slow forward and fast
backward propagation with rates \(\gamma-g\) and \(-\gamma-g\).
The intrinsic fast volume on an interval is exactly
\[
 e^{\Lambda(t-s)}V_f(t)/V_f(s),\qquad
 V_f(t)=\sqrt{\det(C_f(t)^*C_f(t))}.
\]
The gauge bounds give \(e^{-Cbn}\leq V_f(t)\leq e^{Cbn}\);
the analogous slow backward formula uses
\(\Omega=-\sum_{\rm slow}\lambda_j\).
An exterior sector of degree \(p\) with a slow factor has rate at
most \(\Lambda-2g\). Decomposing arbitrary other factors by the
oblique projections gives the mixed-minor bound at cost \(e^{Cbn}\).
This proves the linear estimates used below for both signs of
\(\Lambda,\Omega\). For degree zero the exterior map is exactly one.

### 2. A common bin structure at \(C^{1,\alpha}\) regularity

Put \(t=b^{1/8}\), so
\[
 B=t,\quad b=t^8,\quad g=t^4,\quad L=\lceil t^2n\rceil,\quad
 h=e^{-tn},\quad r=e^{-2tn},\quad \delta=e^{-3tn/2}.            \tag{4}
\]
Here \(t\to0\) and \(t\geq n^{-1/80}\). In particular all of
\(nt,nt^2,nt^4,nt^6,nt^8\) grow faster than \(\log n\);
successive terms in that list have ratios tending to zero.
This proves every absorption below for *any fixed* constants,
not for a chosen hidden constant or a particular numerical scale.

Two starts in a bin of diameter \(O(h)\) stay within \(e^{CL}h\)
for \(|s|\leq L\). A common nested chart can be used along these
short orbits. Holder continuity of the one-step derivatives and
telescoping products give
\[
 \|DS^{\pm L}_x-DS^{\pm L}_y\|
       \leq e^{-\alpha Bn+CL}=:\zeta,\qquad
 \sigma_{\min}(DS^{\pm L}_x)\geq e^{-CL}=:m.                 \tag{5}
\]
Polynomial factors in \(L\) have been included in \(CL\).
Singular-value min--max gives the Lipschitz bound
\(|\sigma_j(P)-\sigma_j(Q)|\leq\|P-Q\|\).
Since \(\zeta/m\to0\), the corresponding log difference is at
most \(2\zeta/m\). Subtracting consecutive degrees in (3) shows
that the sorted rates of any two witnesses over the bin differ by
\[
 O(bn/L)+2\zeta/(mL)=o(g).                                  \tag{6}
\]

Among the \(d+1\) numbers \((1+8j)g\), at least one is more than
\(3g\) from every rate of a reference witness: each rate excludes
at most one candidate. Equation (6) makes this a common threshold
with gap \(g\) and common fast dimension \(p\).

For a reference forward short product let \(W\) be the bottom
\(d-p\) right-singular space. The top \(p\) singular values are at
least \(e^{(\gamma+g)L-Cbn}\), whereas each unit slow vector of
any witness has image norm at most
\(e^{(\gamma-g)L+Cbn}+\zeta\). Orthogonality of singular images
therefore gives
\[
 \|\Pi_{W^\perp}v\|
 \leq e^{-2gL+Cbn}+e^{-\alpha Bn+CL}\leq e^{-cgL}.            \tag{7}
\]
Equal dimensions turn this directed bound into a graph over \(W\):
the graph norm is at most
\(\epsilon/\sqrt{1-\epsilon^2}\) if the directed bound is
\(\epsilon<1\). Thus the orthogonal projectors are \(O(\epsilon)\)
apart. Use a backward short product for the fast spaces.
At time \(n\), repeat the backward argument from a *common endpoint
bin*, on \([n-L,n]\); at \(-n\), repeat the forward argument on
\([-n,-n+L]\). The all-subinterval estimates (3) use the original
rates, so no goodness of an output or new endpoint orbit is assumed.
Projection onto a representative endpoint space has smallest
stretch at least \(\sqrt{1-\epsilon^2}\), hence inverse norm at
most two.

These are finite choices per scale. The matrix \(E_Q\) with
separately orthonormal slow and fast columns satisfies
\(\|E_Q\|\leq\sqrt2\), \(\|E_Q^{-1}\|\leq e^{Cbn}\);
it is never replaced by an orthogonal matrix.

### 3. Retention and cell weights

Use the source's coarse cubes of side \(h\) and full product cells
\(E_Q([0,r)^d+rj)\) contained in them. A cell has physical diameter
\(O(r)\) and volume at least \(e^{-Cbn}r^d\), so the total number
is at most \(e^{CBn}\). Incomplete cells lose \(O(r/h)\) volume:
every such point is within \(O(r)\) of a coarse wall. This uses
the forward diameter bound, not a bound for \(E_Q^{-1}\).
The first-chart assignment loses only \(O(h)\) near the finitely
many chart-region faces.

In a full cell, product-coordinate strips of width \(\tau r\)
occupy at most \(2d\tau\) of its coordinate volume. The constant
\(|\det E_Q|\) cancels. The density oscillation on a physical
cell is \(1+o(1)\), uniformly, because chart densities are
continuous and bounded below on finitely many compact patches.
The endpoint coarse strips have volume \(O(\tau)\), and
invariance controls their preimages. For a smooth boundary,
exclude all integer orbit visits within \(c_0h\) of the boundary;
the loss is \(O(nh)=o(1)\).

Together with the bad-base loss this gives the source's
\(\nu(M\setminus R_k)\leq\eta/100+C_d\tau+o(1)\).
Choose fixed \(\tau>0\) small, then \(k\) large, to make this less
than \(\eta/4\). Since both marginals of \(\rho_k\) are \(\nu\),
\(\rho_k(R_k\times R_k)\geq1-\eta/2\).
Only full cells meet \(R_k\), so this is precisely \(\rho_k(G_k)\).
No assertion about the fraction of good points in an individual
cell has been used.

### 4. Boundary inversion, nonlinear solutions and uniqueness

Use fixed regular charts along the future of \(x\) and past of \(y\),
with the prescribed common chart at zero and the prescribed charts
at the endpoints. Work with both displacement strings and their
matching equation at zero. Weight the displacement at time \(s\)
by \(e^{-\gamma s}\). In these variables, slow propagation forward
and fast propagation backward cost
\(e^{Cbn}e^{-g|s-u|}\), and the associated projections cost
\(e^{Cbn}\).

Prescribe the future slow displacement \(a\) at zero. Propagate its
slow part forward, including forcing. The terminal fast projection
determines the fast terminal displacement; its restriction to the
fast space has inverse norm at most two. Propagate fast backward.
The dependence of the initial fast component on \(a\) is
\[
 K_+=-\widetilde A(0,n)|_{E_n^f}
      (P^+|_{E_n^f})^{-1}P^+
      \widetilde A(n,0)|_{E_0^s},\qquad
 \|K_+\|\leq e^{-2gn+Cbn}.                                  \tag{8}
\]
The two decaying propagators are essential; the projection need
not annihilate the slow space. Summed forcing costs \(e^{Cbn}\)
since \(1/g\) is absorbed by \(\log n=o(bn)\).
On the past half, prescribe fast displacement \(b'\) at zero
and obtain the analogous slow correction \(K_-b'\) with the
same bound.

The matching map \((a,b')\mapsto a-b'\) is invertible with cost
\(e^{Cbn}\): (7) perturbs the fixed oblique reference matching map
by \(e^{-cgL}=o(e^{-C_0bn})\) for every fixed \(C_0\).
The corrections (8) are smaller still. Neumann inversion solves
the entire weighted boundary system at cost \(e^{Cbn}\).
Removing the weights costs \(e^{O(gn)}\). Thus its inverse has
sup-norm bound
\[
                           Q=e^{Cgn}.                       \tag{9}
\]
This is also valid when both halves are the *same* true good
orbit. If a group is empty, omit that group's variables and
terminal data; the remaining matching map is still invertible.

In the fixed charts, the nonlinear one-step residual satisfies
\[
 \|\mathcal R(v)\|_\infty\leq H\|v\|_\infty^{1+\alpha},\qquad
 \|\mathcal R(v)-\mathcal R(u)\|_\infty
       \leq H\delta^\alpha\|v-u\|_\infty                     \tag{10}
\]
on the \(\delta\)-ball. These follow by integrating the Holder
derivative along the segment. There is no factor \(n\), since a
residual coordinate uses only one step.
The matching and endpoint equations have no nonlinear residual.
The inhomogeneity from the two starting points is \(O(r)\).
For large \(k\),
\[
 QH\delta^\alpha\leq\tfrac14,\qquad QC_0r\leq\delta/4.         \tag{11}
\]
Indeed their logarithms have negative leading terms
\(-3\alpha Bn/2\) and \(-Bn/2\), while \(\log Q=O(gn)\).
The fixed-point map sends the closed \(\delta\)-ball into its
\(\delta/2\)-ball and contracts by at most \(1/4\).
Geometric convergence of its iterates gives a unique solution.
It has sharp radius at most \(2QC_0r=e^{Cgn}r\).

The same inequality proves the **larger-radius uniqueness** for
any fixed prescribed boundary values, not just zero values:
if two arrays solve the same equations in this ball, their
difference \(D\) satisfies \(D\leq\frac14D\), hence \(D=0\).
This is the uniqueness used later; local invertibility alone
would not suffice.

The zero-forcing linear initial graphs differ from the reference
slow and fast spaces by
\(e^{Cbn}(e^{-cgL}+e^{-2gn+Cbn})\).
Solving their matching equation differs from ideal coordinate
exchange by that quantity times \(r\). By (10), the nonlinear
correction, including all inverse-basis costs, is
\(e^{Cgn}r^{1+\alpha}=o(r)\).
Therefore
\[
 z=(y_s,x_f)+o(r),\qquad w=(x_s,y_f)+o(r)                    \tag{12}
\]
in the actual oblique product coordinates.
Choose \(k\) large enough for each error to be less than
\(\tau r/4\). Both outputs have margin \(3\tau r/4\) in
their original cell. The sharp endpoint error is \(o(h)\);
the endpoints have margin \(3\tau h/4\) in their original bins.
All these choices hold uniformly on retained pairs.
With boundary, the entire \(\delta\)-tube is smaller than the
excluded collar; all constructed orbit points remain in \(M\).

Changing an internal chart or a good-frame witness does not
change the solution. Both constructions solve the same endpoint
equations, and each has radius \(o(\delta)\); expressed in
either fixed set of regular charts, they lie in that construction's
uniqueness ball.

### 5. Signed relative exterior transfer and all four determinants

For clarity, the following product estimate is proved rather than
replaced by absolute continuity of a long iterate. Suppose
\(\|\bigwedge^p A(t,s)\|\leq e^{\sigma(t-s)+a}\) on every
subinterval, \(\|A_t\|\leq K\), and
\(\|\widehat A_t-A_t\|\leq\epsilon\leq1\).
Multilinearity in \(p\) columns gives
\(\|\bigwedge^p\widehat A_t-\bigwedge^p A_t\|\leq C(d,K)\epsilon\).
Expand the product by altered positions. A term with \(q\)
alterations has \(q+1\) unaltered intervals, including empty ones,
of total length \(m-q\). Its norm is at most
\[
 e^{\sigma(m-q)+(q+1)a}(C\epsilon)^q
       =e^{\sigma m+a}(C\epsilon e^{a-\sigma})^q.
\]
There are \(\binom mq\) choices. Hence
\[
 \|\bigwedge^p\widehat A(m,0)-\bigwedge^p A(m,0)\|
 \leq e^{\sigma m+a}
       [(1+C\epsilon e^{a+|\sigma|})^m-1].                  \tag{13}
\]
No sign hypothesis on \(\sigma\) has entered. In degree zero
the difference is exactly zero.

Use the common reference charts along each shadowed half.
By Holder continuity, the derivative difference is at most
\(H\delta^\alpha\); the reference product has (3).
With \(m\leq2n\), \(a=O(bn)\), bounded \(|\sigma|\), and
\(\epsilon=H e^{-3\alpha Bn/2}\), the right side of (13),
divided by \(e^{\sigma m-C_0bn}\), tends to zero for every
fixed \(C_0\). For example it is bounded by
\[
 C m\epsilon e^{(2C_1+C_0)bn+C_2}
       \exp(Cm\epsilon e^{C_1bn+C_2}),                     \tag{14}
\]
whose decisive logarithm is
\(-3\alpha Bn/2+O(bn)+O(\log n)\).
Thus even an exponentially *small* leading minor is transferred
relatively accurately.

At a true input, use orthonormal bases within its fast and slow
spaces. Its fast future minor is bounded below by
\(e^{\Lambda_xn-Cbn}\). Every nonleading future minor has a
slow factor and is bounded above by
\(e^{(\Lambda_x-2g)n+Cbn}\).
Aligning the bases within their respective spaces with the
reference bases changes each column by \(O(e^{-cgL})\).
Use (3) and multilinearity to bound this error; after division
by the leading lower bound it is at most \(e^{-cgL+Cbn}\).
The oblique inverse costs are also \(e^{Cbn}\), not uniform
constants. The same calculation works backward with \(\Omega_x\).

Write the leading absolute minors as \(A_x,A_y,B_x,B_y>0\).
Their nonleading-to-leading ratios tend to zero uniformly.
Equation (14) transfers them from \(x\) to \(z\), from \(y\)
to \(w\), and for the crossed pasts, with relative errors tending
to zero. This argument never compares a rate of \(x\) with a
rate of \(y\).

Here is an explicit dimension-uniform budget. Set
\(N=\binom dp\), and choose \(k\) large enough that:

* each nonleading input maximal minor is at most
  \(e=1/(64N)\) times its corresponding leading absolute minor;
* the change of every maximal minor on a shadowed half is at
  most \(e\) times that same input leading minor.

These are consequences of the preceding *uniform asymptotic
estimates*, not additional hypotheses on the dynamics.
At an output, a leading minor differs relatively by at most \(e\),
and every nonleading one is at most \(2e\).
Expanding a full endpoint determinant along its future rows has
\(N\) terms. The unique leading product is \(A_aB_b\);
each nonleading term uses a nonleading minor on *both* sides.
The normalized error at an input is at most \((N-1)e^2\).
At an output it is at most
\[
                       2e+(4N-3)e^2.                      \tag{15}
\]
Both are strictly below \(\theta=1/16\). Clearing the positive
denominator \(4096N^2\), and putting \(N=1+h\), gives respectively
the positive polynomials
\[
 256h^2+511h+256,\qquad 256h^2+380h+127.                    \tag{16}
\]
Thus all four full endpoint determinants are nonzero and lie
between \((1-\theta)A_aB_b\) and \((1+\theta)A_aB_b\)
in absolute value.

Differentiating the four endpoint equations gives
\[
 |\det D\Phi|=
 \frac{|\det DH_{xx}(x)|\,|\det DH_{yy}(y)|}
      {|\det DH_{xy}(z)|\,|\det DH_{yx}(w)|}.                \tag{17}
\]
The target permutation has determinant of absolute value one.
The factors \(A_x,A_y,B_x,B_y\) cancel individually.
Each product-basis endpoint determinant has a factor \(\det E_Q\);
the two factors above and two below also cancel exactly.
This remains true for arbitrarily small \(|\det E_Q|\).
Replacing the fixed budget \(e\) by the actual vanishing errors
shows \(J_{\rm coord}\Phi=1+o(1)\).

Let \(D_k\) be the supremum, over full physical cells, of the
largest chart density divided by the smallest.
Continuity and positivity give \(D_k\to1\). The inverse density
Jacobian is bounded by
\[
       J_{\nu\otimes\nu}\Phi^{-1}
        \leq \left(\frac{1+\theta}{1-\theta}\right)^2D_k^2. \tag{18}
\]
In particular, once \(D_k\leq101/100\), the explicit right side
with \(\theta=1/16\) is
\[
        \frac{2948089}{2250000}<2.                         \tag{19}
\]
With the actual vanishing determinant errors, (18) tends to one.

When \(p=0\), the full past endpoint map is invertible and the
equations give \(z=y,w=x\). When \(p=d\), they give \(z=x,w=y\).
Thus the empty-group cases are exactly a swap or the identity,
with density Jacobian one. They do not require a fictitious
nonleading minor.

### 6. Local branches, label recovery and global multiplicity

Fix one retained input and its labels. Nonsingularity just proved
gives a local \(C^1\) pair branch of the endpoint equations.
This can also be obtained directly from the contraction:
keep the old reference halves and vary the endpoint data.
The fixed-point derivative is
\[
 (I-\mathcal L^{-1}D\mathcal R)^{-1}
           \mathcal L^{-1}D(\text{boundary data});
\]
the inverse is its convergent Neumann series by (11).
The difference-quotient remainder tends to zero uniformly on a
smaller ball, proving the displayed derivative formula.
Applying the same argument to the derivative at the point gives
the elementary local inverse theorem when that derivative is
nonsingular.

The constructed solutions for nearby retained inputs agree with
this branch. At fixed \(k\), continuity of the finitely many
iterates makes their reference halves as close as desired.
Both candidate solutions then lie in the old \(\delta\)-tube
and solve the same equations with the same new boundary values.
The larger-radius uniqueness following (11) identifies them.
In the old charts the matching datum remains the *old* coordinate
difference; only endpoint values are varied. This avoids
assuming continuity of frame witnesses.

All retained conditions are Borel. Positive margins make cell
and endpoint labels locally constant among nearby retained inputs.
Second countability gives a countable cover by these local branches.
Disjointifying it gives Borel pieces on each of which \(\Phi\)
is a restriction of a \(C^1\) local diffeomorphism.

Now suppose two retained pairs have identical ordered outputs.
Equation (12) and the strict face margins imply that both came
from the same full product cell. Hence their starting bin,
threshold, dimensions and reference basis agree.
The endpoint margins give exactly the recovery formula in the
scope statement. Thus every endpoint chart and projection agrees
for the two candidate pairs.

The future orbits of \(x,x'\) both shadow \(z\); their past
orbits both shadow \(w\). Their *entire* orbits on \([-n,n]\)
are therefore within \(2e^{Cgn}r=o(\delta)\).
Moreover recovered labels and endpoint equations give
\[
                  F_x(x')=F_x(x),\qquad P_x(x')=P_x(x).
\]
Use the true good orbit of \(x\) for *both* reference halves
in the boundary problem. Both \(x\) and \(x'\) solve its zero
matching and zero terminal displacement data, inside the same
uniqueness ball. Thus \(x'=x\). The future of \(y,y'\)
shadows \(w\), and their past shadows \(z\); the same reasoning
gives \(y'=y\).

This proves global multiplicity at most one, including between
different endpoint-label pieces. Goodness of \(z,w\) was not used.

### 7. A direct weighted-volume lemma and the measure inequality

The elementary lemma below records why local Jacobians plus the
just-proved multiplicity statement really imply a measure bound.
It also supplies a proof without treating a change-of-variables
citation as an unchecked hypothesis.

**Weighted-volume lemma.** Let \(E\) be a Borel subset of Euclidean
space, covered by countably many restrictions of \(C^1\) local
diffeomorphisms \(T\). Suppose \(T\) is injective on \(E\), the
input and output densities \(u,v\) are continuous and positive
on the local neighborhoods, and
\[
                    v(Ta)|\det DT(a)|/u(a)\geq j>0.
\]
Then \(T_*(u\,da|_E)\leq j^{-1}v\,da\).

To prove it, first note that an \(L\)-Lipschitz map in the sup
norm multiplies Lebesgue outer measure by at most \(L^m\) in
dimension \(m\). Indeed, cover its domain by cubes with total
volume arbitrarily close to outer measure; the image of the
intersection with each cube lies in a cube with at most \(L\)
times the side length. For an invertible linear map \(A\),
Lebesgue measure is multiplied by \(|\det A|\). This follows by
Gaussian elimination into permutations, diagonal scalings and
shears, using the product measure formula for each shear.

At \(a_0\), put \(A=DT(a_0)\) and take a sufficiently small convex
neighborhood so that \(A^{-1}T=\operatorname{id}+e\) with
\(\|De\|_{\infty\to\infty}<\epsilon\).
The inverse, on its image, is \((1-\epsilon)^{-1}\)-Lipschitz.
Consequently, for every Borel subset \(H\) of this neighborhood,
\[
 |H|\leq(1-\epsilon)^{-m}|\det A|^{-1}|T(H)|.
\]
Shrink also so that \(u\leq(1+\epsilon)u(a_0)\) and
\(v\circ T\geq(1-\epsilon)v(Ta_0)\). Hence
\[
 \int_Hu\leq
 \frac{1+\epsilon}{(1-\epsilon)^{m+1}j}\int_{T(H)}v.          \tag{20}
\]
Local images of Borel sets are Borel because the local maps are
homeomorphisms. For a fixed \(\epsilon>0\), take a countable
cover of such neighborhoods and disjointify it on \(E\).
Injectivity makes their images disjoint. Sum (20), then let
\(\epsilon\downarrow0\). This proves the lemma, including
measurability and the precise multiplicity coefficient.

Apply it to each Borel local piece of \(G_k\) in a cell square
\(Q'\times Q'\), with density \(f(a_1)f(a_2)\).
Equation (18) supplies \(j^{-1}=K_k\to1\).
For any Borel output set \(A\),
\[
 \begin{split}
 \Phi_*(\rho_k|_{G_k})(A)
 &=\sum_{Q'}\frac1{\nu(Q')}
    \int_{G_k\cap(Q'\times Q')}1_A(\Phi(a))\,d(\nu\otimes\nu)(a)\\
 &\leq K_k\sum_{Q'}\frac{(\nu\otimes\nu)
                      (A\cap\Phi(G_k\cap(Q'\times Q')))}
                           {\nu(Q')}\\
 &\leq K_k\sum_{Q'}\frac{(\nu\otimes\nu)(A\cap(Q'\times Q'))}
                           {\nu(Q')}
 =K_k\rho_k(A).                                            \tag{21}
 \end{split}
\]
Only positive-volume full cells appear in the first two sums;
the final law also has its omitted-points cell, which only
increases the right side. Cell preservation keeps the coefficient
\(1/\nu(Q')\) unchanged. Global injectivity makes the images
of the disjoint pieces disjoint *before* their integrals are
added. There is no factor \(1/\rho_k(G_k)\).

Projection onto the first coordinate in (21) gives the single
switch inequality since the first marginal of \(\rho_k\) is
\(\nu\). The cell count, retention, shadowing and
\(\sum B_k^{16}=\sum b_k^2<\infty\) were proved above.
This proves (1), and hence (S).

## Exact certificate and limitations

`verify.py` uses only the Python standard library. It checks the
universal positive-polynomial determinant margins (16), the exact
strict factor (19), signed product-expansion algebra, the
Pascal induction identity, all scale-dominance exponents, the
boundary contraction budget, the ordered endpoint-data permutation,
independent leading-factor and oblique-determinant cancellation,
and cell-weight normalization.

Two deliberate negative controls ensure that important omitted
hypotheses would matter. A three-sheet translation fold has local
Jacobian one and preserves its sole cell, but pushes unit mass
onto a set of area \(1/3\), violating domination by twice area.
Separately, normalizing the restriction of the identity to a
quarter-area set also violates domination by twice area.
These refute *abbreviated candidate arguments*, not assertions
made by the manuscript.

The Jacobian adapter was used only for the universal two-dimensional
normalized boundary determinant \(\det\left[\begin{smallmatrix}
u&1\\1&v\end{smallmatrix}\right]=uv-1\).
Its exact typed payload, response, server version, protocol and
runtime are preserved separately. This scalar operation is not
presented as proof of the analytic theorem.

The code does not execute arbitrary diffeomorphisms or formally
check the analytic proof, measure theory, or the symbolic
zero-entropy construction. Those distinctions are intentional:
the certificate checks universal algebraic obligations rather than
passing finite samples, and the proof discharges their analytic
premises. No false literal manuscript assertion was identified,
so no manuscript `F_` refutation claim is warranted.

For a primary-source cross-check, Mathlib **v4.31.0**,
`Mathlib/MeasureTheory/Function/Jacobian.lean`, lines 1183--1189,
states `MeasureTheory.lintegral_image_eq_lintegral_abs_det_fderiv_mul`
for a measurable set, a within-set derivative at every point,
an injective map on that set, and an arbitrary nonnegative
integrand. Its source is
<https://raw.githubusercontent.com/leanprover-community/mathlib4/v4.31.0/Mathlib/MeasureTheory/Function/Jacobian.lean>.
The injectivity and measurable-set hypotheses agree with (21);
the independent covering proof above does not assume this theorem.
The unrelated uniform-hyperbolic references returned by a narrow
literature search do not establish or contradict the present
finite-horizon, scale-dependent, high-measure assertion.
No matching primary-source generalization was obtained in that
search. Novelty is therefore **not independently verified** here.
