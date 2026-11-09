# Quadratic Gaussian-cascade transport and its cavity consequences

## Statement and scope

This note independently proves the finite-step joint-law assertion of
Lemma `cav:quadratic`, not just its log determinant. It also derives
`cav:evaluation` and `cav:spin-test` under the actual integer-count block
coupling. These are finite-cascade results, not a proof of the limiting
pressure theorem, the finite-size comparison, or cavity self-consistency.
Independent Reviewer acceptance and a novelty/significance assessment remain
separate from the calculations and proofs here.

The source is the staged September 25, 2026 manuscript, relative to
`research/openai_manuscript/All-temperature-pressure-for-orthogonally-invariant-Ising-spin-glasses-September-25-2026/`:

| Assertion | Source |
|---|---|
| Quadratic tilt, including joint terminal marks | `build/50-cavity.tex:453-689`, labels `cav:quadratic`, `cav:q-path`, `cav:q-transform` |
| Marked Poisson-cascade recursion | `build/10-arrays.tex:293-371`, label `arr:rpc` |
| Coupling and integer multiplicities | `build/50-cavity.tex:11-21,52-85,89-132`, labels `cav:counts`, `cav:coupling` |
| Cavity logarithm and spin tests | `build/50-cavity.tex:788-890`, labels `cav:evaluation`, `cav:spin-test` |
| Meaning of the conditional spin product | `build/20-field.tex:11-70`, labels `fld:kernel`, `fld:B`, `fld:derivative` |

Before this mission the campaign ledger contained the campaign objective
alone. The manuscript already states the spectral-resolvent transport
formula. The improvement here is an independent proof for every finite
depth and dimension, an abstract matrix-ladder extension, and separately
checkable noncommutative algebra. Novelty of this extension is not asserted.

### Known input and routes that do not settle the question

The known probabilistic mechanism is independent Poisson marking and
rescaling, used by Bolthausen and Sznitman, *On Ruelle's probability
cascades and an abstract cavity method*, CMP 197 (1998), 247-276,
DOI `10.1007/s002200050450`, Appendix, Proposition A.2. The elementary
mapping calculation needed here is proved below, so the result does not
depend on importing an unexamined general cavity theorem.

A determinant calculation alone does not determine a joint Gaussian law.
Boundedly many matrix examples cannot prove a statement quantified over
all depths and dimensions. A truncated Poisson cascade is not an exact
Ruelle cascade. In particular, tilting a common root by an annealed
exponential weight, or sharing a residual between separate visits, changes
the problem. None of these shortcuts is used.

No false literal manuscript assertion has been established by this note.
In particular, no counterexample is inferred from absence of a witness.

## A matrix-ladder transport theorem

Let `d >= 0`, `k >= 1`, and
`0 = zeta_0 < zeta_1 < ... < zeta_k = 1`.
Let `B_0 >= B_1 >= ... >= B_k = 0` be real symmetric matrices in
Loewner order. Assume either `B_0 = 0`, or `B_0` is positive definite
and `B_0^{-1} - K` is positive definite, where `K` is symmetric.
No commutation assumption is imposed on the `B_i` or on `K`.
Set

```
Delta_i = B_{i-1} - B_i,
Sigma_i = Delta_i / zeta_i,                  1 <= i <= k,
J_i = (I - B_i K)^{-1},
K_i = K J_i.
```

Give the root an independent `N(0, Sigma_0)` mark, for any positive
semidefinite `Sigma_0`. Give each edge at level `i < k` an independent
`N(0, Sigma_i)` increment. Add an independent `N(0, Sigma_k)` residual
on each visit to a leaf, including separate visits to the same leaf.
The unmarked Ruelle cascade has exponents `zeta_1,...,zeta_{k-1}`.
Tilt this probability, including its residual kernel, by
`exp(Y_k^T K Y_k / 2)`, normalizing separately for each realized root
and cascade.

**Theorem.** The normalizer is positive and finite almost surely and its
logarithm is integrable. Its expected logarithm is

```
(1/2) Tr(Sigma_0 K_0)
 - sum_{i=1}^k (1/(2 zeta_i))
       log(det(I-B_{i-1}K) / det(I-B_iK)).
```

After a genealogy-preserving tree relabeling the unmarked cascade has
its original law and is independent of centered Gaussian innovations.
Their covariances are

```
root:    J_0 Sigma_0 J_0^T,
level i: J_{i-1} Sigma_i J_i^T
       = (F(B_{i-1}) - F(B_i)) / zeta_i,      1 <= i <= k,
F(B) = (I-BK)^{-1} B.
```

The terminal sum of these innovations has exactly the tilted terminal
mark law. This statement holds jointly for every finite number of
replicas with their common levels. The level `k` innovation is redrawn
independently on each visit, not shared between replicas at the same leaf.

### Proof: admissibility and Gaussian kernels

For `0 <= S <= B_0` with `B_0 > 0`, write

```
I - S^{1/2} K S^{1/2}
 = I - S^{1/2} B_0^{-1} S^{1/2}
   + S^{1/2}(B_0^{-1}-K)S^{1/2}.
```

The first term on the right is positive semidefinite:
`B_0^{-1/2} S B_0^{-1/2} <= I` implies the same upper spectral bound
for `S^{1/2} B_0^{-1} S^{1/2}`. The second is strictly positive on any
vector not killed by `S^{1/2}`; on its kernel the first term is the
identity. Thus the left side is positive definite, even for singular
`S`. Sylvester's determinant identity proves `det(I-SK)>0`.
If `B_0=0`, every `B_i` and every `Delta_i` is zero and these assertions
are immediate.

The matrix `K_i` is symmetric, since
`K(I-B_iK)^{-1} = (I-KB_i)^{-1}K`. Direct multiplication gives

```
I - Delta_i K_i = (I-B_{i-1}K) J_i.          (1)
```

For `0 <= t <= 1` replace `Delta_i` by `t Delta_i`.
The right-hand determinant is nonzero by the preceding argument with
`S=B_i+t Delta_i`. Therefore the real symmetric matrix
`I-t zeta_i Sigma_i^{1/2}K_i Sigma_i^{1/2}` never has a zero
eigenvalue. It starts at the identity, so it remains positive definite.
This proves the exact integrability condition for each Gaussian tilt.

For `u` fixed, square completion, using `z=Sigma_i^{1/2}g` when
`Sigma_i` is singular, now gives

```
(1/zeta_i) log E exp(zeta_i (u+z)^T K_i (u+z)/2)
 = -(1/(2 zeta_i)) log det(I-Delta_i K_i)
   + u^T K_{i-1}u/2.                        (2)
```

Indeed, for `T_i=(I-Delta_i K_i)^{-1}`, equation (1) gives
`J_i T_i=J_{i-1}` and hence `K_i T_i=K_{i-1}`.
The normalized Gaussian transition for the running sum is

```
Y_i | Y_{i-1}=u ~ N(T_i u, T_i Sigma_i).     (3)
```

Here `T_i Sigma_i` equals the symmetric positive semidefinite matrix
`Sigma_i^{1/2}(I-zeta_i Sigma_i^{1/2}K_i Sigma_i^{1/2})^{-1}
Sigma_i^{1/2}`. Formulae (1)-(3) require no inverse of `Sigma_i`.
They include a zero increment.

### Proof: the probability change of measure

At an edge of exponent `zeta`, let `M(deta)` be its conditional mark law
and let `a(eta)>0` satisfy `int a(eta)^zeta M(deta)=1`.
The change `(v,eta) -> (v a(eta),eta)` in
`zeta v^{-1-zeta}dv M(deta)` yields the product intensity

```
zeta u^{-1-zeta}du [a(eta)^zeta M(deta)].
```

This follows by the one-dimensional substitution `v=u/a(eta)`.
The Laplace functional of a Poisson process identifies the transformed
point process and its independent conditional marks. This calculation
may first be done on finite-intensity restrictions and then by
monotone convergence.

Let `X_i` be the backward value after integrating the levels below `i`;
integrate the residual at exponent one. Equation (2) says that each
`X_i` is a finite constant plus `Y_i^T K_i Y_i/2`. The multipliers
`a_i=exp(X_i-X_{i-1})` satisfy the preceding normalization at exponent
`zeta_i`. Applying the mapping from the bottom upward gives independent
unmarked descendant processes of the original laws, independently of
the ancestor marks. Edge multipliers telescope to `exp(X_{k-1}-X_0)`.
Residual integration changes the leaf weight by `exp(X_{k-1})`;
conditional residual sampling uses its separately normalized kernel.
This proves the sampled-kernel rule (3) for every finite sampled
genealogy, including coincident leaves.

For completeness, if `T` is the unnormalized total cascade mass, its
finiteness and logarithmic integrability can be proved recursively.
A stable Poisson sum of exponent `zeta` has Laplace transform
`exp(-c s^zeta)` with `0<c<infinity`. Integration against powers of
`s` gives all negative moments and the positive moments below `zeta`.
These imply an integrable squared logarithm. At successive levels the
strict exponent inequalities supply the necessary fractional moments.
For `k=1`, `T=1` and there is no Poisson step.

If `T_new` is the transformed total, pathwise telescoping gives

```
log Z = X_0 + log T_new - log T.
```

Conditional on the root, `T_new` and `T` have the same marginal law.
Their independence is neither asserted nor needed. Their logarithms
are integrable, and `X_0` is a quadratic polynomial in a finite
Gaussian root. Taking expectations gives the stated normalizer formula.
In particular the common root is not exponentially reweighted; no
unconditional moment of `exp(Y_0^T K_0 Y_0/2)` is required.

### Proof: joint terminal marks and noncommutative order

Write equation (3) as `Y_i=T_i Y_{i-1}+eta_i`. Its centered innovations
have laws independent of the parent. Under the marked Poisson mapping
they are conditionally independent on distinct edges. Put `U_i=J_iY_i`.
Then

```
U_i = U_{i-1} + J_i eta_i,
Cov(J_i eta_i) = J_{i-1} Sigma_i J_i^T.       (4)
```

The root is `U_0=J_0Y_0`. For symmetric `B,C,K`, direct multiplication
on the left by `I-BK` and on the right by `I-KC` proves

```
F(B)-F(C) = (I-BK)^{-1}(B-C)(I-KC)^{-1}.    (5)
```

Since `(I-KC)^{-1}=J_C^T`, equation (5) with
`B=B_{i-1}`, `C=B_i` proves the covariance formula in the theorem.
It is a symmetric positive semidefinite matrix by equation (4), despite
the nonsymmetric appearance of its product expression. Because `B_k=0`,
`J_k=I`, so `U_k=Y_k`, not merely a differently normalized variable.
The innovations are independent of the relabeled unmarked cascade.
Their Gaussian law and shared-edge rule determine every finite-replica
joint law. This proves the theorem.

## Smooth-curve extension and the manuscript specialization

The same theorem applies to any continuously differentiable symmetric
matrix curve `G:[0,1]->Sym_d` with `G(0)=0`, `G'(x)>=0`, and, for
`d>0`, `G(x)>0` for `x>0` and `G(1)^{-1}-K>0`. Values of `G` at
different arguments need not commute. Given any finite quantile `p`,
put `p_{-1}=0`, `p_k=1`, `D=D_p`,

```
B_i=G(D(p_i)),
Sigma_i=int_{p_{i-1}}^{p_i} G'(D(r)) dr,
Sigma_0=p_0 G'(D(p_0)).
```

On `(p_{i-1},p_i)` for `i>0`, `D'=-zeta_i`, so
`B_{i-1}-B_i=zeta_i Sigma_i`; on `(0,p_0)`, `D` is constant.
Matrix differentiation of (5) gives
`(F o G)'=J G' J^T`. Consequently the entire transformed covariance
path, including its diagonal excess, is obtained by replacing `G` by
`F o G`. If `f(x)=log det(I-G(x)K)`, the normalizer is
`-(1/2) int_0^1 f'(D(r))dr`, including the root interval.
The endpoint values use the one-sided smooth derivatives.

For the manuscript, `G=H=(bI-A_0)^{-1}`, `H(0)=0`.
The finite alphabet with strictly positive proportions makes the
resolvent equation strictly decreasing from infinity to zero above
`lambda_+`, hence defines `b(x)` for all positive `x`. The inverse
function theorem at `1/b=0` gives the smooth endpoint and `H'(0)=I`.
Writing `M_2=sum_a rho_a/(b-lambda_a)^2`, one has

```
b'=-1/M_2,
H'=M_2^{-1}(bI-A_0)^{-2} >= 0,
H(x)^{-1}-K=b(x)I-A > 0,
F(H(x))=(b(x)I-A)^{-1}.
```

Thus every hypothesis of the ladder theorem holds and it proves all
the assertions in `cav:quadratic`. Adjacent equal `p_i` give zero
increments, regardless of the positive interval weights. A zero
diagonal excess is a zero residual kernel. If `p=0`, only the
exponent-one residual survives; if `p=1`, `D=0`, the only mark is
the unchanged `N(0,I)` root and `E log Z=Tr(K)/2`.
For `d=0` all matrices are empty, the normalizer is one, and every
mark is the unique zero-dimensional vector.

## Precise cavity consequences

These consequences require additional hypotheses not present in the
abstract quadratic lemma: a positive rational finite spectral alphabet,
an integer `n` with `s_a=n rho_a` integral, a full symmetric block
`M=[[A,L],[L^T,C]]` with eigenvalue `lambda_a` of multiplicity `n`,
cavity spectral compression
`E^T(bI-M)^{-1}E=sum_a rho_a/(b-lambda_a) I_n`, and `A_0` having
`n-s_a` copies of `lambda_a`. They are exactly the limiting
integer-count coupling of `cav:coupling`. Arbitrary matrices merely
satisfying `cav:quadratic` do not imply `cav:evaluation`.

The Schur complement and these multiplicities give, for positive `x`,

```
C+L^T (bI-A)^{-1}L = R(x) I_n,
det(I-HK) = x^n product_a (b-lambda_a)^{s_a},
(1/n) (log det(I-HK))' = x R'(x),
L^T (F o H)' L = R'(x) I_n.
```

The apparent logarithmic singularities cancel at zero; both original
matrix functions are smooth there. With
`h(s)=int_0^{p(s)}R'(D(r))dr` and `v=int_0^1R'(D(r))dr`, the
post-quadratic field `L^T y` therefore has independent coordinates,
common-level covariance `h`, and diagonal covariance `v`.
Its independent residual has covariance `(v-h_*)I_n`,
where `h_*=h(1-)`.

Integrating the residual against `exp(z dot epsilon)` gives the
spin-independent factor `exp(n(v-h_*)/2)`. The deterministic term
gives `exp(n R(0)/2)`. The remaining uniform Ising sum is
`product_j cosh(z_j)`; its marked recursion factors over coordinates
and contributes `n[ell(h)+h_*/2]`. Adding the quadratic normalizer
therefore gives

```
(1/n) E log <W>_p
 = ell(h) + (1/2)[R(0)+int_0^1 (1-D(r))R'(D(r))dr].             (6)
```

For almost every `r`,

```
1-D(r)-int_{p(s)>r}p(s)ds = -rD'(r).
```

Fubini followed by integration by parts, using `D(1)=0`, transforms
the bracket in (6) into
`int_0^1 p(s)h(s)ds + int_0^1 R(D(r))dr`. This proves precisely
`cav:evaluated`, with the manuscript's probability, not counting,
spin normalization.

For the spin test the residual is integrated separately for each
replica. Its factor is independent of that replica's spin, including
when the replicas choose the same leaf. In each remaining coordinate
let `F_{k-1}=log cosh`, `F_{i-1}=T_{zeta_i,h_i-h_{i-1}}F_i`.
The root kernel is unchanged; the other kernels have density
`exp(zeta_i(F_i(z_i)-F_{i-1}(z_{i-1})))` against the original Gaussian
increment. Differentiating the convolution in the starting position
shows

```
F_i'(Z_i) = E[tanh(Z_{k-1}) | Z_0,...,Z_i].
```

Two spin samples splitting after level `i` have independent futures
given that shared history. Their conditional product is
`F_i'(Z_i)^2`; define `B_i=E[F_i'(Z_i)^2]`. The relabeling preserves
genealogy and the unmarked cascade law. Therefore, for every bounded
continuous `phi` and every fixed coordinate `j`,

```
E <phi(Q_12) epsilon_j^1 epsilon_j^2>_{p,W}
 = sum_i w_i phi(p_i) B_i
 = int_0^1 phi(p(s)) B_h(s)ds.
```

The same statement holds for bounded measurable `phi` in this finite
setting. Coincident overlap values retain their separate common-level
events; if the field is also repeated, their `B_i` agree. Nothing
here proves the subsequent identity `B_h=p`, which requires the
finite-size cavity-spin transfer and site symmetry.

Finally the joint, not merely marginal, theorem supplies the estimate
used to remove cutoffs. The post-quadratic diagonal covariance is
bounded by `sup_{[0,1]}||(F o H)'||`, independently of the finite
rounding. Jensen gives
`E<|y|^r>_W <= E<|y^1|^r exp(V_1-V_2)>_K`.
Conditional on the common level the two marks are centered Gaussian
with uniformly bounded covariance; the finitely many spin
coefficients make this bound finite uniformly in the rounding.
Markov and `|log W|<=C(1+|y|^2)` then give the cutoff conclusions.
This justifies those finite-cascade estimates, not untruncated
finite-size convergence.

## What the executable and formal checks do

`verify.py` checks the exact certificate, including source labels,
admissibility, noncommutative matrix products, a genuine integer-count
noncommuting cavity block, and all listed boundary fixtures. The finite
fixtures are regression checks, not the proof of the universal
probability theorem above.

`Main.lean` formalizes the dimension-independent ordered algebraic
identities used in (1), (4), and (5). `statement_fidelity.md` separates
that algebraic formal theorem from the analytic Gaussian and Poisson
arguments in this note. A successful compiler run must not be described
as formalization of the full pressure theorem or of probability theory
not encoded in the source.

The deterministic replay passed. It covers seven spectral boundary
fixtures, a nonzero rank-deficient matrix ladder, a smooth curve whose
values do not commute, and a genuine noncommuting integer-count cavity
block. Five fixtures detect reversing the mean-rescaling product.
The actual coupling uses eigenvalues `(0,1,2)`, proportions
`(1,4,4)/9`, `n=9`, `s=(1,4,4)`, and `d=18`; `A_0` has
multiplicities `(8,5,5)`. Its rational orthogonal complement gives

```
A = [[2/3,-2/3],[-2/3,1]] tensor I_9,
L = [[0],[-2/3]] tensor I_9,
C = (4/3) I_9.
```

In the certificate's coordinate order `A` and `A_0` do not commute.
The two-level quantile has `p=(4/77,8/27)` and `w=(3/4,1/4)`;
its resolvent nodes are exactly `b=(11/4,3)`,
`D=(1844/2079,19/27)`. Thus this check satisfies the actual
integer-count hypotheses, rather than merely the quadratic lemma's
weaker spectral bounds.

The real Lean 4.31.0 compiler and axiom audit returned exit code zero
and `proof_holes=[]`. The immutable claim certificate is
`certificates/QC_ALGEBRA-fcf1b91c58af1c6e.json`; the source and fidelity
document have not been edited since that run. The separate exact
Jacobian inertia operation returned `(2,0,0)` and `positive_definite`
for `bI-A` in the small noncommuting spectral fixture, with adapter
exit zero. That operation checks admissibility only.

Independent review still has to read the universal Gaussian/Poisson
argument, confirm statement fidelity, replay the exact script, and
attribute the primary-source assumption `QC_RPC/BS_A2` under a reader
identity different from its filer. The retrieved primary PDF and
hypothesis-inclusive excerpt are available locally. No publication
novelty, pressure-theorem verification, or independent Reviewer verdict
is claimed by the Engineer.
