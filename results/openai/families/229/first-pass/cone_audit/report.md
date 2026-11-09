# Four-state permutation-product inequalities

## Exact question and source scope

The target is Proposition 3.1, equations `A-product` and `H-product`, in
`research/openai_manuscript/The-Reconstruction-Threshold-for-the-Ferromagnetic-Four-State-Potts-Model-October-5-2026/build/sections/03-cone.tex`.
The coordinates are the literal matrix in that manuscript's
`02-experiments.tex`:

```
L = [[1,1,-1,-1], [1,-1,1,-1], [1,-1,-1,1]].
```

For arbitrary probability vectors p,q in the closed four-state simplex, let
x=Lp, A=sum(x_i^2), B=x_1*x_2*x_3, and
C=x_1^2*x_2^2+x_1^2*x_3^2+x_2^2*x_3^2. The coefficient rows in the basis
`[1,A,B,A^2,C,AB,A^3,AC,B^2]`, divided by 1000, are exactly

```
H: [0,0,1000,-100,-150,300,-20,70,-510]
F: [0,4000,-3000,700,-4000,-800,0,0,0]
G: [1000,-1610,-3100,773,4000,-3980,0,0,0]
```

For each of the 24 permutations pi, set U_i=4*p_i*q_pi(i), z=sum(U_i),
and P=U/z if z>0. A summand z*phi(P) is **zero** if z=0. Brackets mean
the sum over all 24 permutations divided by 24, not a uniform average
over distinct resulting posteriors. Put D0=A(p)*A(q)*(A(p)+A(q))/1000.
The requested assertions are

```
Delta_A = A(p)+A(q)-H(p)*F(q)-F(p)*H(q)-D0-[z*A(P)] >= 0,
Delta_H = [z*H(P)]-H(p)*G(q)-G(p)*H(q) >= 0.
```

Their truth is not presumed. Positivity on sampled rational pairs or matching
the authors' traversal counts would not constitute a universal proof.

## Retrieved evidence and outstanding obligations

The staged threshold README describes exact C++ traversals with terminal
counts `4479 19 lp=2074 lt=166` and `1935 20 lp=871 lt=97`.
These are author-reported provenance, not independently established evidence.
The mathematical reductions, sign tests, coverage, and zero-denominator
extension must each be checked before those records can support a proof.

The staged capacity manuscript, `build/main.tex`, proposition `companion`,
uses the preserved class and moment saving from threshold Proposition 3.2.
Failure of either polynomial inequality would invalidate that particular
derivation; it would not by itself refute either main reconstruction theorem.

A targeted lookup of the project Wiki index found no entries on Potts,
reconstruction, four-state models, or campaign 9000229. No outside theorem is
currently being assumed: the selected algebraic question can be addressed
using exact arithmetic and elementary polynomial inequalities.

Jacobian discovery and the typed contract for
`polynomial.box.enclosure.compute` are retained in dedicated JSON files.
That operation supplies sound rational box enclosures, not a universal
simplex certificate merely by returning an interval containing zero.

The initial unresolved obligations are source binding, sign-test soundness,
closed-domain coverage, all-24 permutation normalization, and continuity at
zero-overlap faces. Independent Reviewer replay is required for acceptance.

## Exact adversarial checkpoint and selected proof route

The independent rational evaluator tested 676 pairs from 26 ordered
probability vectors: small-denominator partitions and perturbations of the
uniform vector at scales 2^(-4), 2^(-8), and 2^(-16). Sixty-one pairs have
at least one zero-overlap permutation. Neither slack was negative. This is
only a finite experiment and does not resolve either universal assertion.

The retained author evidence contains run summaries, not replayable leaf
certificates. That is the specified gap requiring one fresh construction of
the subdivision trees. `replay.cpp` includes the unchanged retained coefficient
engine, adds independent direct rational checks of its root formulas, and
exports the actual complete binary trees. Ordinary replay checks the supplied
trees' leaf signs; it does not search for a different tree or accept a
completion marker. `verify.py` independently checks tree syntax, both-child
coverage, literal source coefficients, all 24 coordinate actions, and
reciprocal remainder identities. A matching traversal count is not an
acceptance condition.

The coefficient engine is reused, not presented as an independently written
second engine. Its algebraic interpretation and arithmetic bounds must also
be reviewed. The new proof object improves on the prior run-log evidence by
making each leaf and every covering split explicit and replayable.

### Algebraic replacement for the Taylor remainder argument

Let t_k(z) be the manuscript's degree-five Taylor polynomial for z^(-k)
at one. Exact polynomial division gives

```
1 - z*t_1(z)   = (z-1)^6,
1 - z^5*t_5(z) = (z-1)^6*(1+6z+21z^2+56z^3+126z^4).
```

Consequently t_k(z)<=z^(-k) on the entire positive half-line for k=1,5.
No analytic Taylor theorem or convergence-radius assumption is required.
Jacobian 0.14.0, protocol 2025-11-25, operation
`polynomial.box.enclosure.compute`, returned the exact enclosure
[1,36201] for the second quotient on [0,4], with adapter exit status zero.
Its exact payload and typed output are in `jacobian_payload.json` and
`jacobian_result.json`; no timeout, UNKNOWN, or incomplete output was used.

`Main.lean` formalizes these identities and the abstract finite-sum Type T
and Type P soundness implications. Its separate fidelity document explicitly
excludes the unencoded coefficient implementation, traversal, and boundary
argument. The full product inequalities are not claimed to be Lean theorems.

### Boundary and normalization

For any nonnegative U, z=sum(U)=0 implies U=0. When z>0, U/z is a
probability vector and each coordinate of L(U/z) has absolute value at
most one. Hence |A(U/z)|<=3 and, by the literal H coefficients,
|H(U/z)|<=493/100. Thus the absolute weighted summands are bounded by
3z and (493/100)z, respectively. Their assigned zero values at z=0 are
the unique continuous extensions. This argument covers approaches through
arbitrary changing posterior directions, not only fixed rays.

The original rational rows use K=24 times the nonaveraged right-hand
side, k=1 and N=-|LU|^2 for row a, and k=5 and
N=z^6*H(U/z) for row b. Therefore the checked rational sums are exactly
24*Delta_A and 24*Delta_H. All 24 relative permutations occur, including
repetitions of a posterior caused by stabilizers.
For each fixed pair of coordinate positions i,j there are exactly 3!=6
permutations with pi(i)=j. Hence sum_pi(z_pi)=24 for every probability
pair. This also confirms that the weighted average has total mass one.
If either input is uniform, z_pi=1 and the output is a permutation of the
other input; both slacks are exactly zero. The universal claims are
non-strict, as their near-uniform degeneracies require.

## Proof of the all-domain certificate implication

The following argument explains exactly what a successful executable replay
proves. It is not an inference from the number of cells visited.

**Reduction to ordered inputs.** For a probability permutation Pi, the
induced coordinate matrix is L*Pi*transpose(L)/4. All 24 matrices are
signed permutation matrices with product of the three signs equal to one.
Thus A,B,C,H,F,G are invariant. If the inputs are separately permuted by
sigma and tau, changing the output index to j=sigma(i) replaces the relative
permutation by tau*pi*sigma^(-1). This is a bijection of all 24 permutations,
and the output permutation does not change A or H. Both slacks are therefore
invariant under separate input permutations.

For ordered p, put p_5=0 and X_i=(i+1)*(p_(i+1)-p_(i+2)), i=0,...,3.
Then X_i>=0, their sum telescopes to one, and p=sum(X_i*S_i).
Consequently the initial product of ordered simplices represents every
input orbit. No positivity or distinctness of the input coordinates is
assumed in this reduction.

**Coefficient positivity.** A bihomogeneous coefficient array represents
sum(c_IJ*X^I*Y^J). If its coefficients are nonnegative, so is its value at
every pair of nonnegative barycentric vectors. Multiplication by
W_r(X)*W_s(Y), where W_r=(sum X)^r, preserves values when both masses
are one. This justifies degree elevation and mixed-degree addition.
The Lean declaration `coefficient_nonnegative` checks the finite-sum
positivity principle; identifying the stored array with these monomials
is part of the implementation argument below.

**Scalar inputs to Type T.** The unchanged standard-library scalar checker
expands the literal coefficients in the ordered-coordinate linear forms.
It checks every coefficient of H+1/2 at degree 6, F at degree 5,
G at degree 14, and (3-Euler)H at degree 6. Their minima are respectively
19/50, 0, 87/1000, and 0. Coefficient positivity and permutation invariance
give the scalar assertions on the full simplex. Since the uniform vector
has zero coordinates under L, t*x remains in the coordinate tetrahedron.
The identity

```
d/dt [t^(-3)*H(t*x)] = t^(-4)*(Euler-3)H(t*x) <= 0
```

gives H(t*x)>=t^3*H(x) for 0<t<=1, and H(0)=0 covers t=0.
No Bernstein approximation theorem is needed for these coefficient tests.

**Type T.** For k=1,5, the exact reciprocal identities above prove
z^(-k)>=t_k(z) for z>0. In row a,
N+3z^2=z^2*(3-A(P))>=0; in row b,
N+z^6/2=z^6*(H(P)+1/2)>=0. Multiplying the reciprocal bound by this
nonnegative factor and subtracting m*z yields

```
N/z^k >= (N+m*z^(k+1))*t_k(z)-m*z.
```

Summation proves that nonnegative Type T coefficients imply the desired
rational lower bound on the cell interior. `shifted_reciprocal_lower`
and `typeT_sound` formalize these implications.

**Type P.** The degree-three interpolant J may be any rational polynomial.
The particular truncation and lattice construction do not have to approximate
the rational summand accurately. After homogeneous degree elevation, set
O=W_2*N-z^k*J and Q=z^k*W_3. The coefficients of z and therefore Q are
nonnegative. For every negative coefficient O_IJ the code requires Q_IJ>0
and chooses the least nonnegative multiple c of 2^(-32) large enough for
all such coefficients. Its integer ceiling calculation uses the actual
positive common denominators, not floating-point division. Thus every
coefficient of O+cQ is nonnegative. On the cell interior,

```
N/z^k = J-c+(O+cQ)/z^k >= J-c.
```

The final nonnegative coefficient test on K+sum(J-c) therefore proves
the rational target. `corrected_remainder_lower` and `typeP_sound`
formalize this implication without an interpolation-accuracy assumption.
If any required Q coefficient is zero, the unchanged engine aborts rather
than treating that correction as valid.

**Coverage and boundaries.** Replace one endpoint of an edge by its
midpoint. The old coordinates of the changed pair are
X_i=X'_i/2 and X_j=X'_j+X'_i/2. Their monomial expansion gives the
coefficient transformation

```
X^I -> sum_{t=0}^{I_j} 2^(-I_i-t)*binom(I_j,t)
       * (X')^(I+t*e_i-t*e_j).
```

This child represents exactly X_i<=X_j; replacing the other endpoint
represents X_j<=X_i. The two closed children cover their parent, and each
coordinate change has nonzero determinant. The proof tree includes both
children of every split. Its recursive syntax check rejects an omitted
child, an invalid edge, or trailing unverified data. The C++ replay also
checks the actual vertex masses, ordering, nonnegativity, and affine
independence at every visited cell.

A full-dimensional simplex of probability vectors cannot be contained in
a coordinate face. At every barycentric interior point, all four coordinates
are therefore strictly positive, as are all relative-permutation overlaps.
The sign-test implications apply there. The weighted continuity bounds
already proved extend the inequalities to the whole closed cell. Thus zero
overlaps require neither division by zero nor a missing support hypothesis.
Combining coverage and permutation reduction proves the requested closed
domain, not merely a dense rational sample.

## Correspondence with the retained coefficient engine

This is the human-readable implementation argument that accompanies replay.
The source is only 185 lines; it is included unchanged, and its original
source binding is checked against the retained `full-runs.json`.

The index lists enumerate every four-variable exponent of each total degree
in descending lexicographic order. `ones(r)` is the multinomial expansion of
W_r(X)*W_r(Y). Polynomial multiplication adds exponents in both indices
and adds the products of integer numerators. Addition first multiplies by
W_1 as needed, then uses a positive common denominator. These are precisely
the ordinary monomial operations used in the proof, not value sampling.

In the initial cell, each vertex is stored at scale 12*2^24. Removing
2^24 and using denominator 12 gives the exact ordered vertices S_i.
The product coefficients 4*a_iv*b_j,pi(v), after removal of 2^48 and
division by 144, give exactly U_v. `inv` constructs the nine invariant
polynomials in their literal order; `dot` multiplies each lower-degree
term by the necessary power of its third argument and divides by 1000.
Using W_1 gives the input statistics; using z gives the polynomial
numerator z^6*H(U/z).

For a polynomial depending only on X, homogeneous storage includes a
factor W_r(Y). The column for Y_0^r therefore recovers its true X
coefficients, because that coefficient of W_r is one. The analogous row
does the same for a Y-only polynomial. This proves that `tensor` forms
the input-statistic products in K without an extra multinomial factor.
The factor 24 and the D0 subtraction consequently have exactly the signs
and normalizations stated in the question. Independent direct rational
evaluations compare K, every N and z, and the Type T expression at 36 pairs
of root barycentric points. These are regression checks; the algebraic
identification just given, not those finitely many points, supplies the
universal correspondence.

Midpoint substitution clears 2^r from the coefficient transformation.
Its integer multiplier is
2^(r-I_i-t)*binom(I_j,t), and its recurrence division is exact because
r-I_i-t>=0 throughout. In Type P, evaluation at integer degree-three
nodes is divided by 3^(2r). The cardinal-polynomial matrix stores
960 times the homogeneous coefficients of the cardinal polynomials;
two-sided interpolation therefore divides by 960^2. The remainder
test is performed on that actual rational interpolant.

All coefficient numerators and denominators are arbitrary-precision
integers. Only combinatorial indices, vertices, and small factors use
fixed-width types. The maximum polynomial degree is 11, with at most
364^2 entries; the depth limit bounds counters by 2^25-1. Factorials
through 19!, multinomial products through 92400^2, midpoint multipliers,
and evaluation powers through 3^6 fit the documented integer types.
The conservative weighted edge bound is
2594073385365405696 < 2^63. Midpoint vertex arithmetic remains integral
through depth 24 because the initial coordinates have a factor 2^24.
The unchanged focused harness checked the combinatorial and interpolation
identities and representative coefficient substitutions under UBSan;
its output is retained as `safety_unit.log`. This does not substitute for
the separately replayed full sign trees.

## Precise consequence for the companion input

With successful replay of the polynomial pair, the remaining link to
the companion input is a direct proof, not an external citation assumption.
For a uniform input, the observation likelihood for state i is 4*p_i.
Conditional independence therefore gives product marginal density
z=4*sum(p_i*q_i) and posterior U/z. Both marginal laws have barycenter
(1/4,...,1/4), so the density integrates to one. Simultaneous coordinate
permutation preserves this operation, hence preserves symmetry.

For symmetric marginal laws mu,nu, their independent product measure
permits replacing z*phi(P) by its all-24 relative-permutation average.
The H inequality integrates to
E_product H >= E_mu H*E_nu G + E_mu G*E_nu H.
Since G>=0, this preserves the class E H>=0. The A inequality similarly
integrates to the sum of input second moments minus two nonnegative
H/F terms and

```
(E_mu[A^2]*E_nu[A] + E_mu[A]*E_nu[A^2])/1000.
```

Dropping only the two nonnegative H/F terms yields exactly the stated
moment saving. Channel steps preserve the class by the scaling inequality;
observed mixtures independent of the input preserve it by linearity.
The revealing law has H=13/100 and the uninformative law has H=0.
This proves the threshold closure proposition and supplies precisely the
capacity paper's companion proposition, with no assertion that its other
capacity arguments have been certified here.

On the threshold side, the cubic tree recursion is the downstream
dependency: combining two branches saves 2*(lambda^2*m_n)^3/1000,
and averaging the event of at least two children gives the coefficient
in Section 4. The present certificate targets its common algebraic input.
It is not a formalization of either complete probabilistic paper, nor a
claim of a new reconstruction threshold absent independent novelty review.

## Formal and execution status

The abstract sign-test source compiled successfully with Lean 4.31.0:
compiler exit 0 and `proof_holes=[]`. Its current archived certificate is
`certificates/C_CERTIFICATE_SOUNDNESS_4-1cd766f3a4ae1591.json`.
The first attempt exposed a proof-script elaboration error, not a false
mathematical statement; that failed run remains recorded as inconclusive.
The corrected source has a fresh successful compiler record.

Both finite sign trees have now been constructed successfully under durable
task `cone4-exact-replay`; `run_receipt.json` preserves its exact handle.
The computed covering trees have the following statistics:

| Row | Nodes | Maximum depth | Type T leaves | Type P leaves |
|---|---:|---:|---:|---:|
| a | 4479 | 19 | 166 | 2074 |
| b | 1935 | 20 | 97 | 871 |

These are descriptive statistics of freshly checked signs, not trusted
acceptance markers. The complete trees are stored in `exact_certificate.json`.
Six negative tests also passed: a corrupted reciprocal quotient, a missing
child, an invalid split axis, an out-of-domain alleged witness, a false
uniform-input alleged witness, and a forged Type T certificate at the root.
The last is rejected by an actual negative coefficient, not just syntax.

Fresh ordinary replay of both produced trees completed successfully, with
exit code zero and all six rejection tests passing again. It recomputed
the leaf signs without searching for a replacement tree. A separately
corrupted proof file was also passed through the command-line interface
and rejected with exit code one and the expected diagnostic. Independent
Reviewer acceptance remains required. The external-citation checker reports
no outstanding assumptions for this scoped algebraic proof.

The standalone replay command from the campaign root is:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/cone_audit/verify.py --self-test
```

It uses Python's standard library and a GCC-compatible C++17 compiler with
Boost multiprecision headers. The retained source remains read-only. Replaying
does not modify the proof tree, and nonzero exit means no acceptance.
The separate `--build-certificate` option reconstructs the trees and is not
needed for independent replay.

## Result and acceptance boundary

The Engineer result is a computer-assisted **universal verification theorem**
for both literal inequalities, for all real p,q in the closed product of
four-state probability simplices. It is not a counterexample, a sampled
nonnegativity claim, or an inference from matching retained counts. No false
assertion was identified in the scoped pair, and no manuscript refutation
is being claimed.

The abstract Type T/P soundness core additionally has a fresh zero-hole
Lean 4.31.0 certificate. The full subdivision computation and its
statement-to-source interpretation are not formalized in Lean. The shared
coefficient engine is disclosed and its mathematical interpretation is given
above; independent Reviewer replay and statement-fidelity review must still
decide acceptance.

The campaign remains exploratory at the requested publishable bar. This
handoff does not assert `novelty_status=verified_new`, a publishable result
classification, or completion of either full probabilistic manuscript.
The proof graph intentionally retains unconfirmed nodes until the independent
Reviewer acts.
