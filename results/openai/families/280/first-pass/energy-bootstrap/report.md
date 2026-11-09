# Energy-to-locality audit

## Scope and prior results

The target is `build/02-energy.tex` of the staged September 25, 2026
OpenAI manuscript. The energy-to-locality subtheorem is separate from module
integration, fusion positivity, unitarization, and categorical exhaustion.
The campaign's publishable/exploratory settings are unchanged.

The strongest relevant prior results located at scope are:

* Carpi--Tanimoto--Weiner, arXiv:2103.16475v5, Proposition 3.3:
  a commutator bound of energy order beta gives a nonzero-mode bound of
  order (beta+1)/2 for a Hermitian quasi-primary field. The corrected
  Theorem 3.7 requires Hermitian primary generators with optimal bounds,
  together with currents and Virasoro fields.
* Carpi--Tomassini, arXiv:2303.14097v2, Proposition 3.17:
  a simple unitary C2-cofinite VOA is exponentially energy-bounded.
  Their Theorem 4.5 obtains polynomial bounds for a finite extension of
  an already energy-bounded unitary subalgebra. It does not assert the
  manuscript's general optimal-bound theorem.
* The manuscript's ordinary-module starting bound invokes Zhu,
  DOI 10.1090/S0894-0347-96-00182-8, Sections 4.3--4.4 and Theorem 4.4.1.
  The original PDF could not be obtained: two AMS endpoints returned HTTP
  403 and an institutional repository exceeded its redirect limit. This
  is an unavailable-source fact, not a finding that Zhu's theorem is
  misapplied. The independent proof below instead uses the accessible
  primary theorem of Dong--Li--Mason, arXiv:q-alg/9703016v2, Theorem 3(i).
  Its equations (1.8), (8.5)--(8.6), and Theorems 7.1 and 8.1 identify
  precisely the ordinary-module convergent series needed here, by taking
  the finite automorphism group to be trivial. Rationality is not a
  hypothesis of part (i).
* The conformal-net conclusion invokes CKLW, arXiv:1503.01260v4,
  Theorems 6.8 and 8.1. Its application remains conditional on proving
  energy bounds and strong locality.

The direct identity `d a[0] = [L_1,a[-1]]` is a failed route to an
optimal zero-mode estimate: applying separate operator-norm estimates
loses one energy power. The manuscript itself points this out before
its Mobius transfer. A scalar contraction, even if formally proved,
cannot replace a proof of the constrained operator sums or this transfer.

The inherited Wiki index was searched for vertex algebras, Virasoro,
unitarity, and energy bounds. No relevant prior page was found.

## Computation boundary

Jacobian discovery used the prescribed isolated adapter (server 0.14.0,
protocol 2025-11-25). The inspected
`polynomial.ideal.normal_form.compute` contract computes bounded
commutative polynomial remainders over QQ. It does not decide a
noncommutative mode identity, an operator-norm inequality, or an
infinite-energy analytic assertion. No result from that contract is
being used as evidence for the sharp normal-product bound.

## Current mathematical status

**Engineer conclusion, pending independent review.** The sharp
normal-product estimate has an independent all-length proof. In fact
its intermediate cutoff can be taken explicitly as

\[
 c_b=\sum_{i=1}^{\ell}(d_i-1).
\]

The zero-mode transfer and both contractions also admit the proofs below,
without assuming the energy estimate they are intended to establish.
For the vacuum, these arguments only require C2-cofiniteness, simplicity,
unitarity, and CFT type: rationality is unnecessary. Thus they yield a
candidate strengthening of the energy-to-locality subtheorem to simple
unitary C2-cofinite VOAs.

The universal finite operator-path core compiled with Lean **4.31.0**,
exit code **0**, no proof holes, and a successful axiom audit. The
compiler did **not** check the analytic proof below, its literature
inputs, statement fidelity, novelty, or the rest of the manuscript.
No false manuscript assertion has been established; no `F_` refutation
claim is warranted by these results. Independent Reviewer replay,
citation attribution, and originality assessment remain mandatory.

## 1. The fixed-cutoff constrained-column theorem

Let the physical modes of Hermitian generators satisfy
`a[m]* = a[-m]` and lower energy by `m`. Their weights `d_i` are
positive integers. Work initially on finite-energy vectors in a
nonnegative-energy, orthogonally graded Hilbert space. For integer
`M>=1`, put

\[
 R_a(M)^2=\sup_{\xi\in P_M,\ \|\xi\|\leq1}
                 \sum_{m\geq0}\|a[m]\xi\|^2,
\quad
 X_M=\max\left(1,\max_a(R_a(M)/M^{d_a-1/2})^{1/d_a},
  \max_{d_a\geq2}(\|a[0]P_M\|/M^{d_a-1})^{1/d_a}\right).
\]

Assume these quantities are finite, not that they are bounded or have
their desired eventual growth. Finiteness follows even before polynomial
bounds when the relevant compressed energy spaces are finite dimensional.
Assume the usual algebraic negative-product expansion, not any norm
estimate for its sums.

**Theorem A.** For every fixed nested monomial

\[
 b=a^1_{(-1-n_1)}\cdots a^\ell_{(-1-n_\ell)}\Omega,\qquad
 d_i\geq1,\quad n_i\geq0,\quad
 D_b=\sum_i d_i,\quad w=D_b+\sum_i n_i\geq2,
\]

one has

\[
 \|b[0]P_N\|\leq C_b N^{w-1}X_{N+c_b}^{D_b},
 \qquad c_b=\sum_i(d_i-1),\quad N\in\mathbb Z_{\geq1}.
\]

The constant may depend on the monomial but not on `N` or energy-level
dimensions. No C2-cofiniteness, rationality, module integration,
orthogonality of different paths, or prior optimal energy bound is
needed for this theorem.

### Algebraic expansion, including its signs

The iterate formula with ordinary product index `-1-n_i` puts generator
`i` either on the left with physical index
`-d_i-n_i-j_i`, or on the right with index `1-d_i+j_i`.
Here `j_i>=0`. Its coefficient is

\[
 \binom{n_i+j_i}{n_i}
 \quad\hbox{on the left},\qquad
 (-1)^{n_i}\binom{n_i+j_i}{n_i}
 \quad\hbox{on the right}.
\]

This follows from
`(-1)^j binom(-1-n,j)=binom(n+j,n)` and the second term's
additional sign in the iterate formula. All left factors precede all
right factors; right factors occur in reverse nesting order. The
vacuum contributes only its zero physical mode. Consequently a
zero-mode term has the exact constraint

\[
 \sum_{i\in R}j_i-\sum_{i\in L}j_i
       =D_b+\sum_{i\in L}n_i-|R|.                 \tag{1}
\]

This is not a sum over independent, unconstrained mode choices.

### A single cutoff, before any norm estimates

Fix endpoint vectors `eta,xi` in `P_N`. Move the left product to
`eta` by adjunction. Every resulting left step lowers energy by
`d_i+n_i+j_i`, hence never raises it. On the right, a step changes
energy by `d_i-1-j_i`, at most `d_i-1`. Every prefix is therefore at
energy at most `N+c_b`. This argument works for real, including
nonintegral, initial energies.
Because the zero mode preserves energy, testing both endpoints in
`P_N` computes `||b[0]P_N||`, not merely a weaker compressed norm.

Put `M=N+c_b`. A nonzero right step has nonnegative output, so its
`j_i` is at most its input energy plus `d_i-1`, at most `M`.
The corresponding left inequality is
`j_i<=input-d_i-n_i<=N<=M`. Thus **every contributing index lies
in `{0,...,M}`** and projections `P_M` can be inserted at every
intermediate position. Neither `M` nor the index bound depends on the
values of the indices. This establishes truncation before estimating
the number or norm of paths.

There is a useful improvement over repeatedly bounding uncompressed
negative modes. For `s>0`,

\[
 \|P_M a[-s]P_M\|=\|P_M a[s]P_M\|\leq R_a(M).
                                                        \tag{2}
\]

The equality is the adjoint equality of compressed bounded operators,
not the generally false assertion
`||a[-s]P_M||<=R_a(M)` without a cutoff shift.
There are just `d_i-1` negative right indices. Therefore the family of
compressed right modes has column norm at most
`sqrt(d_i) R_(a_i)(M)`; the left-adjoint family has column norm at
most `R_(a_i)(M)`. Equation (2) is why a recursively expanding
cutoff is unnecessary.

### All-length path squares

For any finite column family `T_j` with
`sum_j ||T_j v||^2 <= K ||v||^2`, applying this inequality to
each vector of a preceding path and summing proves the same statement
for one more factor. Induction on the actual number of factors gives,
for `p=|L|` and `q=|R|`,

\[
 \sum_{\boldsymbol j_L}\|L(\boldsymbol j_L)^*\eta\|^2
       \leq M^{2D_L-p}X_M^{2D_L}\|\eta\|^2,
\]
\[
 \sum_{\boldsymbol j_R}\|R(\boldsymbol j_R)\xi\|^2
       \leq \left(\prod_{i\in R}d_i\right)
                M^{2D_R-q}X_M^{2D_R}\|\xi\|^2.            \tag{3}
\]

The compressed families all act on the same cutoff space, so this is
an ordinary induction on finite families of maps. It does not assume
independence or orthogonality of paths. `iteratedColumns` formalizes
the induction for every list length and arbitrary actual maps.

### The constrained sum and its exact counting factor

If `p,q>=1`, fixing a left tuple in (1) leaves at most `(M+1)^(q-1)`
right completions, since deleting one right coordinate determines it
uniquely from the sum. Fixing a right tuple leaves at most
`(M+1)^(p-1)` left completions. This includes lengths one, empty
fibers, targets outside the attainable range, and all nesting patterns.

For any finite bipartite graph with maximum degrees `r,s`, any real
arrays `A,B` satisfy

\[
 \left|\sum_{(u,v)\in E}A_u B_v\right|^2
   \leq rs\left(\sum_u A_u^2\right)\left(\sum_v B_v^2\right). \tag{4}
\]

Indeed apply Cauchy--Schwarz on the edge set, and then count each
`A_u^2` and `B_v^2` by its degree. This is valid even when many
paths have the same energy or vector. `graphSchur`, `tupleSumCount`,
and `modeSumSchur` prove (4) and its constrained-tuple specialization
for all finite sizes in Lean.

Apply (4) with `A=||L*eta||`, `B=||R xi||` and (3). Taking square
roots gives

\[
 C_b (M+1)^{(p+q-2)/2}M^{D_b-(p+q)/2}X_M^{D_b}
       \leq C'_b M^{D_b-1}X_M^{D_b}.                    \tag{5}
\]

Absolute values of the binomial coefficients cost at most
`C_b (1+M)^(sum_i n_i)`. Since
`1<=N`, `M<=(1+c_b)N`, (5) gives the claimed power `N^(w-1)`.
The saving comes from the two completion counts, not from an
orthogonality assertion or an assumed scalar recurrence.

### Unmixed patterns and boundary cases

An all-left term cannot have total physical index zero.
In an all-right term (1) reads `sum_i j_i=c_b`, so the number and
indices of terms are bounded independently of `N`. If `ell>=2`,
the individual compressed mode bounds give
`C_b M^(D_b-ell/2) X_M^D_b`, and
`D_b-ell/2<=D_b-1<=w-1`.
If `ell=1,n_1=0,w>=2`, use the zero-mode numerator in `X_M`.
If `ell=1,n_1>0`, differentiation gives exactly

\[
 b[0]=(-1)^{n_1}\binom{d_1+n_1-1}{n_1}a^1[0].
\]

The column bound `M^(d_1-1/2)X_M^d_1` suffices because
`d_1-1/2<=d_1+n_1-1`. Weight zero is scalar; weight one is a
single weight-one generator and is bounded by `N^(1/2)X_N`.
This completes Theorem A, including every order pattern.

## 2. Establishing polynomial bounds without circularity

Here use a finite family `S` spanning all Hermitian quasi-primaries
through weight `D`, with `V_w=C2(V)_w` for `w>D`.

### The filtration

Let `E_t` be generated by arbitrary mode strings of total generator
weight at most `t`. The iterate identity, by induction on the length
of a chosen expression for its first input, proves
`u_(r) E_s subset E_(t+s)` for `u in E_t`. Translation preserves
generator degree, by its mode derivation identity and its vanishing
on the vacuum.

Induct on conformal weight. At weights at most `D`, the orthogonal
decomposition into quasi-primaries and `L_-1 V_(w-1)` gives
`V_w subset E_w`. Above `D`, express the state in `C2(V)`.
Every homogeneous term `u_(-2)v` has
`wt(u)+wt(v)=w-1`, so the same induction and stability put it in
`E_(w-1)`; the vacuum-factor case is translation. This also proves
the strict degree saving for every `C2(V)_w`, not just high weights.

To reorder a string, move a nonnegative ordinary generator mode to
the right. Every commutator state `a_(j)b`, `j>=0`, has weight
at most `d_a+d_b-1` and hence a previously proved expression of
strictly smaller generator degree. Induct first on generator degree
and then on the number of moves in the uncommuted string. The latter
mode eventually kills the vacuum; the former terms are already
handled by the degree induction. Truncation on the fixed vector
makes the commutator sums finite. This proves precisely the negative
monomial filtration, without an energy-bound assumption.

### The exponential start is a positive graded trace, not an operator extension

For a Hermitian quasi-primary generator of weight `d`, the iterate
formula gives on finite energies

\[
 T_a=(a_{(-1)}a)[0]
   =\sum_{j\geq0}\{a[-d-j]a[d+j]
                  +a[d-1-j]a[j+1-d]\}.                 \tag{6}
\]

Both terms are positive squares. For `m>=0`, the second family
contains `a[m]* a[m]`, at `j=m+d-1`. Thus
`sum_(m>=0)||a[m]xi||^2 <= <T_a xi,xi>`.

The DLM ordinary one-point theorem gives
`Z_a(q)=sum_h q^h Tr_(W(h))(T_a)<infinity` for `0<q<1`.
For an irreducible ordinary module this is exactly their Theorem 3(i)
at `g=h=1` and `v=a_(-1)a`; their normalization `q^(-c/24)`
is a fixed scalar. For the manuscript's `W`, ABD Theorem 4.5,
finitely many simple types and finite-dimensional grades give a finite
sum of ordinary simples. Unitarity makes that sum orthogonal.
For the vacuum alone none of this regularity/rationality input is
needed: simplicity makes `V` its own ordinary simple module.

Positivity level by level bounds the column on `W(h)` by
`q^(-h) Z_a(q)`. For a sum of input energy levels, each fixed mode
has distinct output levels; summing squared norms therefore gives

\[
 R_a(N)^2\leq q^{-N}Z_a(q).                              \tag{7}
\]

No bounded extension of `T_a` or interchange with an unbounded
Hilbert-space trace has been used.

### Additive-cutoff contraction

Set
`B_N=max(1,max_(a,m)||P_N a[m]P_N||^(1/d_a))`.
Adjunction controls its negative modes by the positive ones, so (7)
gives `log B_N=O(N+1)`.

For a fixed state of weight `w`, its negative monomial expressions
and the cutoff proof above give

\[
 \|P_N u[\mu]P_N\|\leq C_u(1+N)^{p_u}B_{N+c_u}^{w}.
                                                               \tag{8}
\]

This preliminary estimate counts all tuples crudely and bounds
each inserted generator mode by the definition of `B`. It does
not use Theorem A or a polynomial bound.

For `m>0`, write

\[
 C_{a,m}=[a[m],a[-m]]
   =\sum_{j\geq0}\binom{d-1+m}{j}(a_{(j)}a)[0].         \tag{9}
\]

Its states have weights at most `2d-1`. For the compressed modes
in `B_N`, `1<=m<=N`; applying (8) gives
`||C_(a,m)P_N|| <= C(1+N)^p B_(N+c)^(2d-1)`.
For input energy `h`, let `A_h` be the norm of the raising mode
`a[-m]:W(h)->W(h+m)`. Adjunction gives

\[
 A_h^2\leq A_{h-m}^2+\|C_{a,m}|_{W(h)}\|.              \tag{10}
\]

After at most `1+N/m` steps the input energy is negative. There is
no dimension factor and no need to put the raising-mode output
inside `P_N`. The identity `d a[0]=[L_1,a[-1]]`, using the
linear Virasoro bound, handles the zero mode at this preliminary
stage with only a fixed additive shift. Taking the `d`-th root
gives

\[
 B_N\leq C(1+N)^p B_{N+c}^{\rho},\qquad
 \rho=1-\frac1{2D}<1.                                 \tag{11}
\]

Iterate logarithms. The remainder
`rho^r log B_(N+rc)` tends to zero by (7). The summand is bounded
using `1+N+jc<=(1+N)(1+jc)`; the convergent weighted logarithmic
series gives `log B_N<=C+p' log(1+N)`. Thus `B_N` is polynomial.
Applying (8) with an endpoint cutoff of size
`O(1+h+|mu|)` proves ordinary polynomial energy bounds for every
state. Summing over input levels is legitimate by their distinct
output energies.

In particular all smooth smears and their formal adjoints preserve
the common smooth domain, and `R_a(N)` and `X_N` grow at most
polynomially. These are outputs of the first contraction, not
assumptions of the second.

## 3. Sharp nonzero modes and the quantitative zero-mode transfer

Subtract (9) at `m=0` from (9) at `m>0`. The former is zero as an
operator; subtraction cancels the `j=0` term without asserting
`a_(0)a=0` as a state. The remaining fields have weights at most
`2d-2`. Theorem A, the filtration and the separate weight-zero and
weight-one bounds imply, for `d>=2`,

\[
 \|C_{a,m}P_N\|
   \leq C(1+m)^p N^{2d-3} X_{N+c}^{2d-2}.             \tag{12}
\]

Here the state list is fixed independently of `m`. For `w=1`,
the exponent `1/2` is at most `2d-3`; for `w=0`, use a constant.
All powers of `X` are at most `2d-2`. Increasing a fixed cutoff is
legitimate using the comparison of raw numerators described below.
Equation (10) now gives

\[
 \|a[m]P_N\|\leq C(1+|m|)^p N^{d-1}X_{N+c}^{d-1},
             \qquad m\ne0.                           \tag{13}
\]

For a raising mode this uses only input levels at most `N` in (10),
even when its output is above `N`. For a lowering mode, adjunction
uses the corresponding raising map on the lower input level;
modes with `m>N` vanish. Thus the cutoff in `X` is independent of
`|m|`.

### Mobius transfer uses neither a net nor primary-field diffeomorphism covariance

Positive-energy unitary Virasoro integration supplies a Mobius
representation independently of a net. The quasi-primary
commutators for `L_-1,L_0,L_1` integrate on the already established
smooth domain:
`U_g a(f) U_g*=a(f_g)`, where
`f_g(g(theta))=g'(theta)^(d-1) f(theta)`.
To justify this identity, differentiate the conjugate with the
inverse-evolving test. The mode commutators cancel its derivative;
the preliminary polynomial bounds justify differentiation in every
needed Sobolev norm. Only Mobius covariance of a quasi-primary is
used, not the stronger diffeomorphism covariance of a primary.

For `f(theta)=exp(i theta)`, the smear is `a[1]`. Along the
unitary flow generated by `(L_1-L_-1)/2`,

\[
 [(L_1-L_{-1})/2,a[1]]
       =(d-2)a[2]/2+d\,a[0]/2.                        \tag{14}
\]

Thus the mean `c_g` of the transformed test has derivative `d/2`
at the identity. Fix a small `g` with `c_g!=0`. Since a physical
mode changes energy by its index,

\[
 \Pi_h U_g a[1]U_g^*\Pi_h=c_g a[0]\Pi_h.             \tag{15}
\]

This is a level compression of a smooth-domain identity.

Let `H=1+L_0`, `H'=U_gHU_g*`. The latter is a fixed linear
combination of `1,L_0,L_1,L_-1`; the linear Virasoro estimates give
`H'P_M W subset P_(M+1)W` and `||H'P_M||<=C_g(1+M)`.
Induction on the actual power gives

\[
 \|H^j U_g^*P_N\|=\|(H')^jP_N\|
   \leq C_g^j\prod_{i=0}^{j-1}(1+N+i)
   \leq C_g^j(1+N+j)^j.                              \tag{16}
\]

There is no assertion that `U_g* P_N` has finite spectral support.
For any fixed integer `r>=0`, choose an integer `K>4C_g` and put
`j=N>r` in (16). Spectral calculus yields

\[
 \|H^r(1-P_{KN})U_g^*P_N\|
 \leq (KN)^{-(N-r)}C_g^N(1+2N)^N
 \leq C_{r,K}N^r(3C_g/K)^N.                          \tag{17}
\]

The finitely many `N<=r` are bounded by the fixed-power Sobolev
estimate. This exponentially decaying tail estimate has no energy
multiplicity factor. Choose `r` at least the preliminary energy
order of `a[1]`. Using (13) on the low-energy block and (17) on
the tail proves

\[
 \|a[1]U_g^*P_N\|
 \leq C N^{d-1}X_{KN+c}^{d-1}+O(1).
\]

Compression in (15), followed by the supremum of level norms
(the zero mode preserves each level), gives exactly

\[
 \|a[0]P_N\|\leq C N^{d-1}X_{KN+c}^{d-1}.            \tag{18}
\]

This proves the needed quantitative transfer with a fixed
multiplicative cutoff; the bounded error is absorbed since `X>=1`.
The failed direct commutator shortcut has not been reused.

## 4. The second contraction and strong locality

For any generator of weight `d>=1`, the state of `T_a` has weight
`2d`. If `2d>D`, it is in `C2(V)` and has generator degree at most
`2d-1`. If `2d<=D`, split it into a quasi-primary of weight `2d`
and an `L_-1` descendant. The latter is in `C2(V)` and has the
same strict degree saving. The former is a fixed combination of
generators of weight `2d`; apply (18) with that weight. In both
cases, Theorem A and (18) imply

\[
 \|T_aP_N\|\leq C N^{2d-1}X_{K_0N}^{2d-1}.           \tag{19}
\]

This includes `d=1`, whose quasi-primary term has weight two.

Although `X` need not be monotone, its raw column and zero-mode
numerators are monotone. For `N<=M<=cN`, each normalized
`d`-th root in its definition therefore gives `X_N<=cX_M`.
There are only finitely many expansions and generator weights,
so one fixed integer `K_0` absorbs all additive and multiplicative
cutoffs, without a new `N`-dependent constant.

Taking a square root of the positive-column inequality from (6)
and (19), then the `d`-th root defining `X`, contracts the column
term with exponent `(2d-1)/(2d)`. Equation (18) contracts its
zero-mode term with exponent `(d-1)/d`. Consequently

\[
 X_N\leq C X_{K_0N}^{\sigma},\qquad
 \sigma=1-\frac1{2D}<1.                               \tag{20}
\]

Iterating logarithms leaves
`sigma^j log X_(K_0^j N)`. By the polynomial bound already proved,
this is at most
`sigma^j(A+s log(1+N)+sj log K_0)`, which tends to zero.
It follows that `X_N` is uniformly bounded. No inequality such as
`sigma K_0^s<1` is needed, and no energy bound was assumed during
the derivation of (20).

Equations (13) and (18) now give energy order `d-1`. Apply them
on each level using `N=max(1,ceil(h))<=1+h`, and add squared
norms across input levels for a fixed mode. Any specified Hermitian
quasi-primary is accommodated by enlarging the fixed `D` before
the argument. For weight one the positive column gives half-order
bounds; adjunction at energy `h+m` gives
`C(1+h+m)^(1/2)<=(1+m)^(1/2)C(1+h)^(1/2)` for raising
modes, in particular the stated at-most-linear bound.

For the vacuum, decompose the finitely many generators into
Virasoro highest-weight descendants using unitarity and the finite
energy spaces. At each level the orthogonal complement of
negative-Virasoro-mode descendants is primary. Choose Hermitian
bases of the finitely many primary spaces needed. Those vectors
and the conformal vector generate `S` and hence `V`. They satisfy
the optimal bounds just proved; weight-one fields are currents
and the conformal field has a linear bound. The **corrected**
CTW Theorem 3.7 applies with its Hermitian hypothesis, proving
strong locality. CKLW Theorem 6.8 then constructs the irreducible
conformal net.

**Theorem B (analytic proof; independent review pending).**
A simple unitary CFT-type C2-cofinite VOA is energy-bounded and
CKLW-strongly local. In particular the manuscript's strongly rational
energy-to-locality subtheorem follows; its module bound follows on
each grading-restricted already unitary module using regularity
and the ordinary one-point theorem.

The proof improves on the prior results located in scope by eliminating
the requirement of an already energy-bounded finite-index subalgebra
and, for the vacuum, rationality. The exact cutoff in Theorem A
also strengthens the manuscript's unspecified fixed-cutoff claim.
Whether these improvements are new to the wider literature has
**not** been independently established. Search-engine-generated
summaries claiming general 2025--2026 theorems were not accepted
as sources: the cited Cn-cofiniteness and conformal-block papers
do not by their titles or summaries establish optimal operator
energy bounds. No `verified_new` designation is being asserted.

## 5. Exact computation and certification boundaries

`Main.lean` proves the all-size graph pairing, all-size constrained
tuple count, all-length column iteration, real-energy prefix cutoff,
one-step index bound, and the exponent identity. The compile and
axiom audit used the installed Mathlib workspace without a new
Lake project. The immutable compiler certificate is recorded on
`C_PATH_CORE`; its separate reading is `statement_fidelity.md`.
Only this finite core has mechanical evidence.

The Jacobian diagnostic uses the inspected
`matrix.inertia.compute` contract on a **9-by-9** exact rational
Schur-remainder matrix for two left and two right indices in
`{0,1,2}` with `sum(right)-sum(left)=2`. Its payload,
typed output, protocol, server version, and constraint-to-matrix
construction are preserved in the adjacent dedicated JSON files.
The adapter returned inertia `(9,0,0)` and `positive_definite`;
`verify.py` independently replays exact rational LDL elimination.
This is one finite diagnostic, not support for a universal
analytic assertion. The earlier polynomial-normal-form contract
was a mismatch and was not forced onto the operator problem.

The script also checks constrained counts and squared Schur
inequalities on finite parameter ranges, a saturating graph
example, fixed-cutoff paths with fractional starting energies,
and exact Heisenberg derivative-field zero-mode identities.
The latter compare the signed iterate expansion with an independent
Wick/derivative expansion on the neutral Fock sector, not with
the desired norm inequality. This sector embeds in a positive
even rank-one lattice VOA, but the finite checks do not certify
all hypotheses or all fields of any VOA theorem.

To replay the exact diagnostics and verify that the existing
compiler certificate still matches its source and reading:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/energy-bootstrap/verify.py
```

For a fresh real compiler run, from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/energy-bootstrap/Main.lean --statement-fidelity research/energy-bootstrap/statement_fidelity.md --claim C_PATH_CORE --project-root . --timeout 90
```

Do not edit the source or reading during that command. Its measured
successful run took approximately 16 seconds; the first diagnostic
run had two elaboration errors, recorded as inconclusive rather than
mathematical refutations. The source was corrected before the successful
run, and its reading was unchanged. The earlier durable-run receipt
was task `energy-bootstrap-lean-core-1`,
run `energy-bootstrap-lean-core-1-1793914991418211838`,
state `submitted`; its subsequent terminal status was `error`.
That failed run is not cited as support.

## 6. Review boundary

The proof graph leaves all analytic and downstream theorem nodes
unproved pending independent review. A passing schema check or a
Lean core certificate must not be used to mark them independently
proved. The Engineer's proof judgements are opinions tied to this
report. The host-invoked Reviewer must check the analytic
specialization, actual source hypotheses, statement fidelity and
originality before accepting a publishable result.

The Zhu locator is unresolved, but the proof does not depend on it:
the ledger records its retirement with the explicit DLM replacement
reason. No refutation of Zhu, the manuscript, or its main theorem
is inferred from source unavailability. Sections 3--8 of the
manuscript have only been dependency-mapped, not verified.

All official structural checks are run against the campaign root
`campaigns/9000280`,
not the shared batch directory. Their final exit statuses and the
remaining independent-review requirement are recorded in the role
progress files.
