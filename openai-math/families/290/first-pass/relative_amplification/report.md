# Tensor-word rigidity and a weighted prefix-error obstruction

## Result and scope

We prove the implication in the relative manuscript's "Repeated tensor
tests" section, independently of its iterated completely positive kernel:
the stated, fully uniform narrow-total-energy estimate implies `U=D`.
The proof does **not** assume spectral control of an actual propagated
vector or its error. We also obtain a finite-horizon weighted prefix-error
lower bound, which allows the error to vary with both the prefix and the
terminal horizon.

This is an analytic verification theorem, with a precisely delimited Lean
certificate for the capture geometry, Hilbert norm loss, arbitrary-horizon
loss accounting, and nonsummability. It is not a finite numerical
verification or a formalization of the full analytic theorem. Independent
review and novelty/significance assessment remain pending.

Source locations, relative to `research/openai_manuscript/`:

* `Expected-amenable-subalgebras-preserving-core-commutants-September-23-2026/`
  `build/paper.tex`: products and `U,D`, lines 590-637; uniform energy
  proposition, lines 642-674; hybrid/time averaging and repeated tests,
  lines 910-1119.
* `Bounded-recovery-for-modular-spectral-averages-September-23-2026/`
  `build/sections/04-bounded-recovery.tex`: bounded recovery, especially
  its arbitrary bounded operator quantifier and fourfold band enlargement.
  That theorem and the supplied incomplete comparator are **not used**.

The upstream absolute theorem, product isometries, iterated kernel,
uniform energy estimate, and downstream continuous-core reduction are
outside the verification claim. No false manuscript assertion has been
established by this reconstruction; consequently no fictitious `F_` claim
is introduced.

## 1. Abstract rigidity theorem (C_RA)

Let H,K be separable complex Hilbert spaces, X,Y self-adjoint (possibly
unbounded), and `W_s=exp(isY)`. Define the unitary

```
D = integral E_X(dx) tensor W_x
```

on `H tensor K`; this is the bounded Borel functional calculus
`exp(i X tensor Y)`. Let U be any contraction on that space. On
`H^(tensor n) tensor K`, U_j and D_j act on position j and the common
last factor, and `S_n=sum X_j` is defined by the joint functional calculus.
For arbitrary real shifts d_0,...,d_n set

```
C = W_(d_n) U_n W_(d_(n-1)) ... W_(d_1) U_1 W_(d_0)
V = W_(sum d_j) exp(i S_n tensor Y).
```

Assume: for each eta in K there is a nonnegative function eps_eta(delta)
tending to zero as delta decreases to zero such that

```
norm((C-V)(xi tensor eta)) <= eps_eta(delta)*norm(xi)                 (1)
```

for every n>=1, all shifts, every interval I of length delta, and every
xi in the S_n-spectral subspace of I. The modulus may depend on eta but
not on n, the shifts, I's position, or xi.

**Theorem.** Under these assumptions U=D.

Zero Hilbert spaces cause no exception: the operator identity is then
immediate. No compactness, finite-dimensionality, boundedness of X or Y,
or invariance of X-spectral subspaces under U is assumed.

### 1.1 Hybrid disintegration (L_RA_HYBRID)

Replace any chosen subset J of the U positions by D. If no U remains,
the difference from V is zero. Otherwise use the countable cyclic
multiplication representation of X in each replaced coordinate.
Disintegrate over their spectral values x=(x_j)_(j in J).
All unreplaced U positions and all W shifts are decomposable with
respect to these coordinates, because they act as the identity on those
H factors. At a replaced position D_j becomes the shift W_(x_j).
Thus each fiber is an ordinary word in the remaining U positions,
with additional, arbitrary real shifts.

The input xi is not required to be elementary. If its total energy is
in I, its fiber in the remaining H coordinates has remaining total
energy in `I-sum_(j in J)x_j`, almost everywhere. This follows directly
by disintegrating the joint spectral projection of the total sum.
The interval still has length delta.

The final factor of the initial input is still the **same eta**.
Any fiber multiplicity is an untouched auxiliary Hilbert factor:
expand in an orthonormal basis, apply the homogeneous inequality (1)
to each coefficient vector, and sum squares. Therefore the fiber
bound has squared norm at most
`eps_eta(delta)^2 * norm(xi_x)^2`. Integration proves (1) for the
hybrid, with precisely the same modulus. The fiber shifts depend on
x, which is harmless precisely because (1) is uniform over all shifts
and over the interval position.

For `G_j=(U_j+D_j)/2`, expand the finite word into its 2^n hybrids.
Their nonnegative coefficients sum to one. The norm triangle inequality
therefore gives the same bound, not n times that bound.

### 1.2 Time averaging without a commutation assumption

Choose a real, even, smooth g supported in `[-delta/2,delta/2]`,
with integral |g|^2 equal to one. With unitary Fourier normalization,
`p(t)=|g_hat(t)|^2` is an even probability density.
For any unit xi in `H^(tensor n)` put
`F(z)=g(S_n-z)xi tensor eta`.
Spectral calculus and Tonelli give

```
integral norm(g(S_n-z)xi)^2 dz = 1.
```

Hilbert-valued Fourier transformation gives
`F_hat(t)=g_hat(-t)*(exp(-it S_n)xi tensor eta)`.
One rigorous way to justify this identity is first to bound the spectrum
of xi and take simple spectral approximations, then pass to the Hilbert
L2 limit. The preceding isometry controls the approximation; equivalently
one may work in each cyclic scalar spectral representation. This avoids
an unjustified pointwise Fourier transform of an arbitrary L2 function.

Let T be the bounded difference of any original, hybrid, or averaged
word and V. Applying Plancherel to TF and then to F gives

```
integral norm(T(exp(it S_n)xi tensor eta))^2 p(t) dt
 = integral norm(T(g(S_n-z)xi tensor eta))^2 dz
 <= eps_eta(delta)^2.                                               (2)
```

The sign change is valid because g and p are even. Each right-hand input
is in an energy interval of length delta. A bounded linear T acts
pointwise on the Hilbert-valued L2 space and commutes with the Fourier
transform in that sense; **T need not commute with S_n**. The density p
is the same for all tensor lengths and shifts.

## 2. A quantitative theorem without a uniform-error assumption

Suppose `Delta=U-D` is nonzero. Boundedness and density of algebraic tensors,
followed by spectral truncation in the first factor, give unit h,eta
such that h has X-spectrum in `[-l,l]`, l>=0, and
`Delta(h tensor eta)` is nonzero. Indeed, vanishing on all such elementary
tensors would imply Delta=0 on a dense linear subspace.
Strong continuity gives c>0 and `0<b<=1` for which

```
norm(Delta(exp(iuX)h tensor W_v eta)) >= c   (|u|,|v|<=b).             (3)
```

Let p be **any** probability density, choose A>=1, and write
`alpha=integral_[-A,A] p(t)dt`. For any finite horizon m, independently
sample t with density p and, for j=1,...,m,

```
r_j uniform on [-2A,2A],   s_j uniform on [-B_j,B_j],
B_j >= b+(j-1)l, B_j>0,
a_j = (b/(2A))*(b/B_j).
```

All current samples are independent of t and of past samples. At step j
insert the unit vector `exp(i(t-r_j)X)h` in the fresh H position and act
with `W_(s_j) G_j W_(-s_j)`. Let zeta_(m,k) denote the actual prefix
state and chi_(m,k) its ideal D version, starting at eta. Define

```
e_(m,k)^2 = E norm(zeta_(m,k)-chi_(m,k))^2.
```

The m subscript permits a different finite experiment for every horizon;
no infinite-product coupling is needed. The ideal state equals

```
exp(i S_k tensor Y)
  ((tensor_(i<=k) exp(i(t-r_i)X)h) tensor eta).                        (4)
```

**Weighted prefix-error theorem.** For every finite m,

```
sum_(j=1)^m a_j e_(m,j-1)^2
 >= (alpha*c^2/8)*sum_(j=1)^m a_j - 1.                              (5)
```

This is a nonuniform-error extension of the amplification argument.
It is a rigorous consequence for arbitrary separable H,K, not a
claim that a numerical sample approximates those spaces.

### 2.1 Capturing the ideal defect

At step j=k+1, let v and v_0 be the actual and ideal inputs after fresh
insertion and the inner shift `W_(-s_j)`. Let

```
Q = 1_(|t-r_j|<=b) * 1_(|S_k-s_j|<=b),
```

where S_0=0. Q acts only on old H positions (and by a scalar indicator),
so it commutes with Delta_j and G_j. Define

```
I_j = E norm(Delta_j Q v_0)^2,
R_j = E norm(Delta_j Q(v-v_0))^2,
F_j = E norm(Delta_j Q v)^2,
L_j = E(norm(zeta_(m,j-1))^2 - norm(zeta_(m,j))^2).
```

All vectors and bounded-operator expressions are strongly measurable:
the phase groups and shift groups are strongly continuous, and only
finitely many bounded operations are composed. Moving-window spectral
projections are measurable by spectral calculus. All integrands are
bounded, so the expectations and the subsequent Fubini/Tonelli
interchanges are legitimate.

In (4), disintegrate the old coordinates over total energy e. Their
last factor is W_e eta, and `|e|<=(j-1)l`; the old H coefficient can be
arbitrary. The entire interval `[e-b,e+b]` lies in `[-B_j,B_j]`.
Hence its s_j capture probability is exactly b/B_j. For `|t|<=A`,
`[t-b,t+b]` lies in `[-2A,2A]` because b<=1<=A; its r_j capture
probability is b/(2A). On each captured fiber (3) applies with
`u=t-r_j` and `v=e-s_j`. The old H coefficients have total squared
norm one. Consequently

```
I_j >= alpha*c^2*a_j.                                              (6)
```

### 2.2 Capturing an unrestricted error (L_RA_CAPTURE)

For **every real e**, with no boundedness hypothesis,

```
Pr_s(|e-s|<=b)
 = max(0,min(B_j,e+b)-max(-B_j,e-b))/(2B_j)
 <= b/B_j.                                                        (7)
```

For an arbitrary old state error E, spectral calculus and Tonelli yield

```
E_s norm(1_(|S_k-s|<=b) E)^2 <= (b/B_j)*norm(E)^2.                   (8)
```

This argument uses the scalar spectral measure of E; E can be
entangled with K and can have unbounded old-energy support. It is
not legitimate to replace E by an ideal spectrally localized vector,
and no such replacement is made.

Condition on t and every past sample. E is then fixed. The fresh
vector has norm one for each r_j, even though its direction depends
on r_j and t. Q does not act on this fresh factor. W_(-s_j) commutes
with Q and is unitary. Thus the dependence of v on r_j and s_j does
not affect its captured **norm**. The universal phase-capture bound
`Pr_r(|t-r|<=b)<=b/(2A)` and (8) can now be multiplied, by independence.
After averaging over t and the past,

```
E norm(Q(v-v_0))^2 <= a_j*e_(m,j-1)^2.
```

Since norm Delta_j<=2, it follows that

```
R_j <= 4*a_j*e_(m,j-1)^2.                                         (9)
```

This is the essential common probability factor; discarding it on the
error side would not prove the theorem.

### 2.3 Loss accounting and proof of (5)

For any vector v, contraction U and unitary D imply the exact identity

```
norm(v)^2 - norm((U+D)v/2)^2
 = norm((U-D)v)^2/4 + (norm(v)^2-norm(Uv)^2)/2.
```

The second term is nonnegative. Since Q commutes with Delta_j and is
an orthogonal projection,

```
F_j <= E norm(Delta_j v)^2 <= 4*L_j.                                (10)
```

Also `Delta_j Q v_0 = Delta_j Q v - Delta_j Q(v-v_0)`.
The squared norm triangle estimate gives

```
I_j <= 2*F_j + 2*R_j.                                             (11)
```

Inserting unit fresh factors and applying outer shifts preserve norms,
so `sum L_j = 1 - E norm(zeta_(m,m))^2 <= 1`. Combining
(6), (9), (10), (11) and summing proves

```
alpha*c^2*sum a_j <= 8 + 8*sum a_j e_(m,j-1)^2,
```

which is exactly (5). This deliberately avoids any independence
assumption about the old error and t.

## 3. Rigidity follows from nonsummability

Return to (1). Choose delta so that
`eps=eps_eta(delta)<c/8`, and use the density p from Section 1.2.
Choose A>=1 with alpha>=3/4. Use

```
B_j=b+1+j*l,   j>=1.
```

Condition on every sample except t. At prefix k the fresh tensor is
`exp(it S_k) xi_k`, with fixed unit
`xi_k=tensor_(i<=k) exp(-ir_i X)h`.
The product of conjugated G positions is an averaged word with shifts

```
d_0=-s_1, d_i=s_i-s_(i+1) (1<=i<k), d_k=s_k,
```

whose sum is zero. Equation (2), and then averaging over the other
samples, therefore gives `e_(m,k)^2<=eps^2` for every prefix k and
every terminal m. No modulus for W_s eta, for an actual propagated
last factor, or for an error vector is used.

Equation (5) now yields, for every m,

```
(alpha*c^2/8-eps^2)*sum_(j<=m) a_j <= 1.                            (12)
```

The coefficient is positive; indeed it is greater than
`3c^2/32-c^2/64=5c^2/64`.
The weights are positive and, including l=0, satisfy

```
a_j >= [b^2/(2A*(b+1+l))]/j,  j>=1.
```

This follows from `b+1+j*l <= (b+1+l)*j`. Their partial sums are
unbounded by harmonic-series divergence. Hence (12) is impossible
for all finite m. This proves U=D.

More generally (5) rules out any family of finite experiments whose
weighted mean prefix squared error is eventually bounded strictly
below alpha*c^2/8, for **any** nonsummable positive capture schedule
satisfying the stated containment condition. A common error bound
is a convenient sufficient condition, not a necessary formulation.

## 4. Certification boundary and prior-result comparison

`Main.lean` proves the arbitrary-horizon scalar theorem (5), the
contradiction for nonnegative nonsummable weights and a subcritical
uniform squared error, nonsummability of the actual affine reciprocal
weights, the unrestricted scalar capture inequality (7), the interior
equality, the squared norm triangle inequality, and the Hilbert
averaging loss inequality. All terminal-indexed experiment arrays
may vary with m. The theorem statements do not smuggle in bounded
error support or consistency of infinite experiments.

The compiler does not construct the operator random experiment,
disintegrate spectral measures, invoke vector-valued Plancherel,
or establish its hypotheses. Those bridges are the analytic proof
above. `statement_fidelity.md` describes the exact formal statements.
`verify.py` independently replays the finite rational/polynomial
identities and the saved typed Jacobian result; it is not a decision
procedure for infinite-dimensional operators.

The strongest supplied comparator is the manuscript's qualitative
repeated-test theorem, with a proof but no supplied formal
certification of this amplification mechanism. The contribution here
is its independent abstract verification, an exact formal arbitrary-
terminal/nonsummability core, and the stronger weighted nonuniform
prefix-error obstruction (5). It is **not** an upgrade of the incomplete
bounded-recovery comparator into a proof.

Background only: Teschl, *Mathematical Methods in Quantum Mechanics*,
GSM 99, first edition (online version February 12, 2009),
ISBN 9780821846605, Lemma 3.4 and Theorem 3.7 for spectral calculus and
cyclic multiplication representations, and Theorem 7.5 for scalar
Plancherel. The author's freely available primary PDF was obtained and
these propositions were read; the short passage and the edition are
in `background_excerpt.txt`. The Hilbert-valued extension follows by
orthonormal-coordinate expansion and Tonelli. The ledger records these
as background assumptions, with independent source attribution still
owed by the Reviewer.

The inherited wiki index had no matching amplification/bicentralizer
entry. An external novelty search failed with HTTP 503; no absence of
prior art or verified-new literature claim is inferred from that failure.
The independent Reviewer must assess publishability and novelty rather
than inherit a self-awarded classification.

Jacobian 0.14.0, protocol 2025-11-25, was discovered and inspected before
custom computation. Its finite Kronecker contract does not cover the
target theorem. The bounded `matrix.symbolic.multiply.compute` operation
is used only for the averaging/difference Gram identity; exact request,
typed output, and scope limitations are preserved in dedicated JSON
files. No timeout or unknown result is treated as mathematical evidence.
