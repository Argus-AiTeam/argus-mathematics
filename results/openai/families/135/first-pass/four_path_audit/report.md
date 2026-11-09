# A uniform four-path reduction for iterated matrix multiplication

## Scope and source

The audited passage is `eq:four-path-trace` through
`eq:moment-reduction` in the staged September 25, 2026 manuscript,
`build/sections/04-moments.tex`. The target here is this dependency, not the
asymptotic depth-five lower bound. The product-rank estimates, the balanced
word estimate, and their asymptotic parameter estimates remain separate,
unverified dependencies.

Let the matrix width be an integer `w >= 1`. Let a word of length
`d = k + m` specify `k >= 1` differentiation layers V and `m >= 1`
multiplication layers U, with no adjacent V layers. All matrices are full
`w` by `w` matrices; both external path vertices are fixed to label 1.
Include all variables, even inactive variables in the endpoint matrices.
Thus `v = k*w^2`, `u = m*w^2`, and there are `w^(d-1)` paths.

Take integers `a >= k` and `b >= 1`. The operator is
`F = IMM_(w,d)(partial_V,U)` from bidegree `(a,b)` to `(a-k,b+m)`.
The domain dimension is
`D = binom(v+a-1,a)*binom(u+b-1,b)`. In ordinary monomial bases the
Gram matrix is diagonal, with entry `M!` at exponent vector `M`.
Consequently the adjoint matrix is `G_domain^(-1) F^T G_codomain`.
This convention is a definition, not an appeal to a theorem about Fock
spaces.

Write `A=a/v`, `B=b/u`, `alpha=A/(1+A)`, `beta=B/(1+B)`,
and `mu=A^k*(1+B)^m`. A pairing word has letters N and D. N pairs
`(P,Q)` and `(R,S)`; D pairs `(P,R)` and `(Q,S)`. In the original
disjoint classification, the two D coordinates must differ. A *relaxed*
quadruple drops only those inequalities, retaining the assigned D
weights, even at newly admitted all-equal coordinates.

## Known statements and assumptions

The manuscript states the weak-composition factorial-moment formula and
its termwise comparison with independent geometric variables in
`lem:occupation-moments`. It states the four local polynomials in
`eq:local-polynomials` and the normalized geometric weights in
`eq:local-weights`. These are verification obligations, not assumptions
that the audit may silently import.

The only initially borrowed mathematical input to the scoped reduction
is the occupation comparison, explicitly entered in the claim ledger
against the locally read lemma. Its elementary coefficient-extraction
proof will be supplied here before discharging that dependency. No
external literature theorem is needed for this finite algebraic
reduction. A targeted search of the inherited project Wiki index found
no entry for IMM, four paths, occupation moments, or factorial Gram
matrices. No novelty conclusion follows from that negative lookup.

## Universal verification target

For every pairing word `tau`, let `sw(tau)` count switches between
consecutive letters. The relaxed quadruples should number exactly
`w^(2*(d-1)-sw(tau))`. For an N layer `t`, let `h_t` count its internal
end vertices at which both adjacent pairing letters are N. The claimed
coincidence probability is `w^(-h_t)`. The supports of those events for
different V layers should be disjoint, hence their generating function
should factor.

Together with independently derived local weights and the occupation
comparison, this would prove

```
T2 / (D*w^(2*(d-1))*mu^2)
 <= (1+beta)^m *
    sum_tau w^(-sw(tau))*alpha^(-dV(tau))*beta^(dU(tau)) *
      prod_(t in V, tau_t=N) (1+alpha^(-1)*w^(-h_t)).
```

The target is parameter-uniform. Exact finite tests alone will not
establish it. A Lean formalization will certify the universal
pairing-count/factorization core, with a separate statement-fidelity
document identifying precisely what is and is not formalized.

## Theorem

The universal verification target above holds. More generally, the
coincidence generating function factors with a different arbitrary
rational coefficient `c_t` in each selected N layer, provided the selected
layers are pairwise nonadjacent. Positivity is needed for the moment
*inequality*, not for this exact generating-function identity.

This is a proof of a parameter-uniform reduction. It is not a proof of the
manuscript's balanced-word estimate or its asymptotic circuit lower bound,
and no claim of literature novelty is made.

### 1. Operator, adjoint, and four-path trace

For an ordinary domain monomial `z^M`, the path operator has coefficient
`prod_(t in V) M_(E_t(P))` and output exponent `M+epsilon_P`; each
differentiated coordinate occurs only once. In the normalized basis
`z^M/sqrt(M!)`, multiplying by the square root of the output-to-input Gram
ratio gives

```
c_P(M)^2 = prod_(t in V) M_(E_t(P)) *
           prod_(t in U) (M_(E_t(P))+1).
```

Use coefficient zero if an input exponent is negative or a required
derivative is unavailable. Two paths have different shift vectors:
the layer coordinate in the shift determines both ends of every edge,
and hence the entire path.

In normalized bases set `H=F^*F`. Direct multiplication gives

```
H_(M,M') = sum_(P,Q: M+epsilon_P=M'+epsilon_Q) c_P(M)c_Q(M').
```

The entries are real and `H` is symmetric. Expanding
`tr(H^2)=sum_(M,M') H_(M,M')^2` and substituting the uniquely determined
`M'=M+epsilon_P-epsilon_Q` proves `eq:four-path-trace`. Multiplying a
uniform domain expectation by `D` is just summing over all `M`; it
does not add another factor of `D` or a sum over `M'`. In ordinary
monomial coordinates the same calculation uses
`H=G_domain^(-1) F^T G_codomain F`. This is the independent matrix
calculation used by the executable verifier.

### 2. Occupation comparison, without an imported theorem

For nonnegative integers `h_i`, put `H=sum h_i`. The identity

```
sum_(j>=0) (j)_h y^j = h!*y^h/(1-y)^(h+1)
```

follows by differentiating the geometric formal power series `h`
times and multiplying by `y^h`. Multiplying these identities for `r`
coordinates and extracting `y^t` gives, if `H<=t`,

```
sum_(|M|=t) prod_i (M_i)_(h_i)
  = prod_i h_i! * binom(t+r-1,t-H).
```

Division by `binom(t+r-1,t)` proves

```
E prod_i (M_i)_(h_i) = (t)_H/r^(overline H) * prod_i h_i!.
```

For `H>t`, each summand is zero, as is the falling factorial on the
right. This includes `t=0`. Independent geometric variables of mean
`G=t/r` have factorial moments `h!*G^h`, by the same generating-series
calculation. For `G>0` and `H<=t`, the ratio of composition to geometric
moments is

```
prod_(j=0,...,H-1) (1-j/t)/(1+j/r) <= 1.
```

For `H>t` the first moment is zero; for `t=0` both distributions are
concentrated at zero. Therefore every polynomial with nonnegative
coefficients in the multivariate falling-factorial basis has
composition expectation at most its independent geometric expectation.
This proves the upper comparison for all relevant parameters; the
manuscript's asymptotic lower comparison is not needed here.

The V and U exponent vectors are independent because the domain
basis is a Cartesian product. They are not independent within either
group, and no such independence was used.

### 3. Exact local contributions and geometric weights

At a single layer, compatibility says `e_p-e_q=e_r-e_s`; the common
sign of that layer's shifts cancels. If `p=q`, then `r=s` and the
type is N. Otherwise the positive and negative coordinates of this
vector force `p=r`, `q=s`, and `p!=q`, the D type. This is a disjoint
classification; the all-equal case is N only.

For N the local shift of `M'` is zero. For D it is `-e_i+e_j` in V
and `e_i-e_j` in U. Multiplying the four square-root coefficients
therefore gives exactly:

| Layer | N (`i=j` allowed) | D (`i!=j`) |
|---|---|---|
| V | `M_i*M_j` | `M_i*(M_j+1)` |
| U | `(M_i+1)*(M_j+1)` | `(M_i+1)*M_j` |

These are also valid when the contribution is zero. A negative
coordinate in `M'` requires `M_i=0` in a V-D layer or `M_j=0` in a U-D
layer, and the respective polynomial vanishes. An unavailable N
derivative also gives zero. Coordinates from different layers are
distinct, so there is no other way an occupation can become invalid.

For repeated N coordinates,

```
z^2 = (z)_2+(z)_1,
(z+1)^2 = (z)_2+3*(z)_1+1.
```

For distinct coordinates every factor is `(z)_1` or `(z)_1+1`.
Thus every local product has nonnegative factorial-basis
coefficients, of V order at most `2*k` and U order at most `2*m`.
Section 2 applies, even when some orders exceed `a` or `b`.

The second moment of a geometric variable of mean `G` is
`2*G^2+G`. Using independence only for the comparison geometric
variables, division by `A^2` per V layer and `(1+B)^2` per U layer
gives precisely:

| Layer | N | D |
|---|---|---|
| V | `1+alpha^(-1)*1_(i=j)` | `alpha^(-1)` |
| U | `1+beta*1_(i=j)` | `beta` |

For example `(2*A^2+A)/A^2=1+(A+1)/A`, not just `1+1/A`.
The product of all denominators used in this normalization is
`mu^2`. No repeated-coordinate factorial has been discarded.

### 4. Relaxed quadruples and the exact vertex count

Fix a pairing word `tau`. Dropping only the D inequalities enlarges
its class. The newly admitted tuples receive the *assigned*
D weights in the last table, not a purported geometric expectation
of an all-equal D tuple. Every original tuple keeps its weight,
and all added weights are nonnegative. Classes may overlap after
relaxation; this only increases the sum.

At an internal vertex, write the four labels as `(p,q,r,s)`.
The adjacent pairing letters impose their pairings on these four
labels. If both letters are N, the possibilities are exactly
`(i,i,j,j)` with `w^2` choices. For DD they are exactly `(i,j,i,j)`,
again with `w^2` choices. For ND or DN both pairings hold and all
four labels must agree, with exactly `w` choices.

At either external vertex there is one choice, all four labels
being the fixed endpoint. Choosing the internal labels independently
gives four paths because every matrix entry exists. Conversely a
relaxed quadruple supplies these internal labels uniquely. This is
a bijection, not merely a count of compatible local patterns.
If `L=d-1` and `sw` internal vertices are switches, its cardinality is

```
(w^2)^(L-sw) * w^sw = w^(2*L-sw).
```

In particular there is no free endpoint factor. Full matrices and
the fixed endpoint convention are hypotheses of this theorem.

### 5. Coincidence events and their exact factorization

Consider an N layer `t`. Its two coordinates agree if and only if
the P and R labels agree at both end vertices. An external endpoint
already agrees. At a switch the four labels already agree. At an
internal NN vertex the two labels `i,j` are independent and uniform
in `[w]`, with coincidence probability `1/w`.

Let `S_t` be the set of its internal NN end vertices. These are the
only random tests left, and `h_t=|S_t|`. Thus its coordinate
coincidence event has probability `w^(-h_t)`. The empty set is
important: when `h_t=0` the event is certain.

For distinct nonadjacent selected layers, the full endpoint sets,
and hence the subsets `S_t`, are disjoint. The uniform relaxed
assignment space is a Cartesian product of the internal vertex
spaces. Regroup its NN pair coordinates by these disjoint supports,
leaving all other vertex labels in an unused residual factor.
This is a bijection of finite sets, so each block has its uniform
distribution independently of the others.

For completeness, one can count a block without probabilistic
terminology. A block with `h` pair coordinates has `w^(2*h)`
assignments. Exactly `w^h` have equal labels at every coordinate,
by the bijection sending an all-diagonal assignment to its first
labels. Its mean weight `1+c*1_event` is therefore

```
(w^(2*h)+c*w^h)/w^(2*h) = 1+c*w^(-h).
```

Finite Fubini, or simply distributing a product of finite sums,
then proves the exact identity

```
E prod_t (1+c_t*1_event_t) = prod_t (1+c_t*w^(-h_t)).
```

This holds for arbitrary rational coefficients, including zero and
negative ones. The moment application takes every `c_t=alpha^(-1)>0`.
No independence of adjacent U-layer coincidence events is claimed.

The Lean development proves the original fixed-endpoint
quadruple-to-vertex bijection, the four vertex cardinalities, the
count for every finite pairing word, finite Fubini after explicit
regrouping by an owner map, the diagonal-block count, the formula
for arbitrary pairwise disjoint supports, and the nonadjacent-layer
support implication. Its support theorem starts from ungrouped
site assignments: independence is a conclusion, not an input.
The end-to-end declarations are `fixed_quadruple_count` and
`fixed_quadruple_factorization`; the latter averages actual P/R
edge-coordinate coincidence events on the original constrained
quadruple space, using the proved `layerCoincidence_iff` to identify
their NN supports.

### 6. Combining the inequalities

The occupation comparison and local calculations give
`T2 <= D*mu^2` times the sum of the normalized geometric weights of
the compatible quadruples. Relax each type class as in Section 4.
For an N layer in U, bound its weight pointwise by `1+beta`;
there are at most `m` such layers. Leave every D weight unchanged.

For the remaining N layers in V, Section 5 evaluates the average
weight exactly. Multiplying this average by the number
`w^(2*L-sw(tau))` of relaxed assignments gives the contribution of
`tau`. Summing the words and dividing by `D*w^(2*L)*mu^2` proves
the stated reduction. All denominators are positive because
`w,k,m,b>=1` and `a>=k`.

Nothing in this proof uses `w=d`, a balanced schedule, a large
parameter limit, or the manuscript's reduction as a premise.

## An additional exact first-trace identity

The same domain and Gram conventions yield, for these parameters,

```
T = D*w^(d-1) * (a)_k/v^(overline k) *
    sum_(j=0,...,m) binom(m,j)*(b)_j/u^(overline j).
```

Indeed the paths have distinct shifts, so first-trace cross terms
vanish. A path uses one distinct coordinate in each layer.
Apply the exact V factorial moment, expand the product of U terms
`(M_i+1)`, and apply the exact U moments to each chosen subset.
All paths have the same expectation by coordinate exchangeability.
The inactive coordinates remain in `v,u` in both rising
factorials; they do not supply an extra path or endpoint factor.
This also shows `T>0` for `a>=k`, without an asymptotic estimate.

For a finite nonzero complex matrix, if the positive eigenvalues
of `F^*F` are `lambda_1,...,lambda_r`, Cauchy--Schwarz gives
`(sum lambda_i)^2 <= r*sum lambda_i^2`. Since `r=rank(F)`,
this proves the separate trace-rank inequality. It does not supply
the unverified balanced-word or circuit estimates.

## A boundary obstruction outside the manuscript hypotheses

The no-adjacent-V condition is substantive. For width 2, schedule
`VVU`, pairing word `NNN`, and both selected coefficients equal to
1, the first V event tests the first internal NN vertex, while
the second tests both internal NN vertices. Their probabilities
are `1/2` and `1/4`, and their intersection has probability `1/4`,
not `1/8`. Therefore

```
E[(1+1_E1)*(1+1_E2)] = 2,
(1+P(E1))*(1+P(E2)) = 15/8.
```

This disproves only an extension with adjacent V layers. It does
not refute any assertion of the staged manuscript and is not
entered as a false-manuscript claim.

## Exact executable checks and the independent-review boundary

`verify.py` uses only the Python standard library. Run

```
$WORKSPACE/argus-live-update/.venv/bin/python research/four_path_audit/verify.py
```

It recomputes and compares `exact_certificate.json`; it does not
accept that file's conclusions as inputs. The certificate contains
30 operator cases (widths 1, 2, 3, both endpoint orientations, and
all positive-count nonadjacent schedules through length 4 for
widths 1 and 2), 106 pairing words, 840 disjoint-support generating
function checks, and 1,974 exact occupation moments. Extra trace
cases use occupations above the minimum and `b=2`.

Each operator case independently constructs the ordinary
integer monomial matrix, computes its adjoint with factorial Gram
matrices, and computes both traces as rational numbers. The
second trace is compared against direct zero-extended four
square-root coefficients (whose squared product is checked to be
a perfect integer square), and each of those contributions is
also compared with the local polynomial table. It separately
checks the occupation, geometric, relaxation, and final word-sum
inequalities. Thus the comparison is not two implementations of
the manuscript's normalized word formula.

The exact Jacobian adapter request is
`matrix.symbolic.multiply.compute`, inspected before execution.
`jacobian_payload.json` and `jacobian_result.json` preserve its
payload and typed result, including protocol `2025-11-25`,
server `0.14.0`, and successful adapter status. It computes the
square of the two-pairing vertex-count transfer matrix
`[[w^2,w],[w,w^2]]`. The verifier independently checks its
polynomial coefficients. This small symbolic calculation is
supporting evidence, not the universal proof.

The finite checks are **finite verification**, not by themselves a
proof for all parameters. The preceding argument is a universal
mathematical proof; `Main.lean` is its explicitly delimited formal
core. Independent Reviewer replay, assessment of statement
fidelity, and any publishability or novelty judgement remain
required. No false assertion in the audited passage has been
established. The full asymptotic theorem remains open in the
campaign dependency graph.

The official `lean_evidence verify` run on November 5, 2026 used Lean
4.31.0 and returned `status=success`, `exit_code=0`, and
`proof_holes=[]`. It recorded mechanical support for `C_FP_CORE` in
`research/four_path_audit/certificates/C_FP_CORE-1bfec39f61d3a5a0.json`.
The full runtime answer is `lean_verify.json`; the compiler also
produced the standard `lean_check.json` and `compile.log` beside the
source. The archived certificate binds both `Main.lean` and
`statement_fidelity.md`. Neither has been edited after this run.
This compiler result is not an independent human fidelity verdict.

At Engineer handoff, the exact project root was
`campaigns/9000135`.
`math_state check`, `proof_graph_check check`, and
`lean_evidence check` all exited zero there. The proof-graph nodes
remain open with `reviewer_confirmed=false` until independent review;
compiler success has not been substituted for that review.
