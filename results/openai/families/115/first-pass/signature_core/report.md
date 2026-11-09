# Exact certification of integer balanced summation

## Result and scope

The universal balanced-summation assertion is true in the positive laminar
model stated in the capped manuscript, including width one. The complete
integer-weight construction, arbitrary finite iteration, invalid removals,
reflected additions, and finite limiting weights are proved in Lean 4.31.0
in `Main.lean`. The sampler's weighted occupancy estimate is also proved.
This is an independent formal verification of a shared load-bearing core,
not a refutation, a new sampling/counting result, or an established novelty
claim. Independent Reviewer acceptance, including statement fidelity, remains
necessary.

The persisted official receipt is `lean_check.json`: compiler exit `0`,
axiom-audit exit `0`, and `proof_holes=[]`. Its archived certificate is
`certificates/C_SIG_CORE-ade1ddce35c34b65.json`; the ledger derives
`C_SIG_CORE` version 2 as `closed_kernel`, with statement fidelity explicitly
not independently verified. Both final official checks exited `0` against
`campaigns/9000115`.

The primary statements compared are:

* Capped manuscript,
  `An-FPRAS-for-Cell-Bounded-Contingency-Tables-September-24-2026/build/sections/integer-signatures.tex`,
  `lem:integer-signature`, `eq:laminar-rank-one`,
  `eq:integer-summation-matrix`, and `cor:hj-signatures`.
* Sampler,
  `Exact-Uniform-Sampling-of-Contingency-Tables-with-Arbitrary-Margins-September-24-2026/build/sections/signatures.tex`,
  `lem:laminar-signature`, `lem:pair-summation`, `prop:signature`,
  `eq:soft-marginal`, and `eq:soft-limit`.

Paths in this list are relative to `research/openai_manuscript/`.
No external Lorentzian closure theorem is used. Branden--Huh is background,
not an unverified dependency of this proof. The mathematical assertion was
already present in these sources; the improvement over the prior ledger,
which contained only the open campaign goal, is a parametric kernel-checked
proof and an explicit application audit, rather than more finite tests.

## Certified theorem

Let `I` be finite, let `m_i >= 0` be integers, and let `L` be laminar.
For each `G in L`, let `psi_G : Z -> (0,infinity)` be log-concave.
Put

    F(v) = product_G psi_G(sum_{i in G} v_i)

on `0 <= v_i <= m_i`, `sum_i v_i = R`, and zero elsewhere.
Eliminate any finite collection of disjoint pairs `{a_t,b_t}`, with both
capacities equal to an arbitrary integer `M_t >= 1`, by the unweighted sum
over `(k,M_t-k)`, `0 <= k <= M_t`. Let `Phi` be the result and
`r = R - sum_t M_t`.

For every box-valid integer display `z` of total `r+2`, the matrix

    Q_ih = Phi(z-e_i-e_h)

has positive index at most one. Repeated removals are genuine integer
subtractions: if `z_i=1` the diagonal entry is zero; if `z_i=0` its whole
row is zero. For every box-valid display of total `r-2`, the same conclusion
holds for `Phi(z+e_i+e_h)`. Both conclusions persist under entrywise finite
limits of such weights, even when some limiting entries vanish.

Positive index here counts multiplicity. For a real symmetric form it is
equivalently the largest dimension of a positive-definite restriction.
The formal condition is the projection inequality

    B(u,u)>0  =>  B(u,u) B(v,v) <= B(u,v)^2.

`no_positive_plane` proves that this rules out every positive-definite
two-dimensional pullback. Conversely, two positive eigenvectors from an
orthonormal eigenbasis would give exactly such a pullback, so the usual
eigenvalue formulation follows.

## Standalone proof

### 1. Laminar base and invalid entries

Discard zero-display indices temporarily. At a display put
`l_G=sum_G z_i`,

    gamma_G = psi_G(l_G) psi_G(l_G-2) / psi_G(l_G-1)^2,
    alpha_i = product_{G containing i} psi_G(l_G-1)/psi_G(l_G).

All denominators are positive, and `0 < gamma_G <= 1`.
The extended product matrix, before invalid repeated removals are zeroed, is
`W diag(alpha) K diag(alpha)`, where `W=product_G psi_G(l_G)>0` and

    K_ih = product_{G containing i,h} gamma_G.

Along the chain of sets containing `i,h`, telescoping gives

    K = 11^T - sum_G c_G 1_G 1_G^T,
    c_G = (1-gamma_G) product_{H strictly containing G} gamma_H >= 0.

Thus `K` is nonpositive on `sum_i a_i=0`.
The Lean proof gives an equivalent finite induction: erase a minimal
laminar set `G`; its insertion subtracts
`(1-gamma_G) product_{H != G, H containing G} gamma_H` times its block
rank-one form. Laminarity and minimality prove the required block is
constant. This proves the kernel identity's consequence without treating
it as an assumption.

Restoring inactive coordinates is a diagonal pullback with scale zero at
those indices. Every still-invalid entry is a diagonal at `z_i=1`.
Replacing it by zero subtracts a nonnegative diagonal form. The same
hyperplane remains nonpositive. `removal_form_identity` proves this
correction exactly for the product entries; `slice_removal_identity`
checks both the box and the total slice.

### 2. One balanced pair, arbitrary width at least two

Write the actual two-removal form at pair display `(k,M-k)` as

    N_k = [ V_k       S(k-1)    S(k)
            S(k-1)^T  u(k-1)    u(k)
            S(k)^T    u(k)      u(k+1) ].

Here `S(-1)=S(M)=0`, `u(0)=u(M)=u(M+1)=0`, and `u(k)>0` for
`1 <= k < M`. Positivity follows by choosing any valid balanced profiles
in all previously eliminated pairs; it does not require the margins to
be satisfied. `block_decomposition` checks the equality to the actual
integer removals, including the invalid first-coordinate removals at
`k=0`. The induction hypothesis supplies the signature of each `N_k`.

For any real old vector `a` on the common hyperplane

    a^T sum_{l=0}^{M-1} S(l) = 0,

put

    g(k) = a^T sum_{l=0}^{k-1} S(l) / u(k),  1 <= k < M,

and zero otherwise. Then

    a^T S(l) = u(l+1)g(l+1) - u(l)g(l)

also at both endpoints. All divisions are interior and positive.
For `v_k=(a,g(k),-g(k))`,

    N_k(v_k,e_a) = u(k-1)(g(k)-g(k-1)),
    N_k(v_k,e_b) = u(k+1)(g(k+1)-g(k)).

If either corresponding diagonal is positive, projection bounds
`N_k(v_k,v_k)` by the sum of the two nonnegative squared-difference
terms. If both diagonals vanish, an interior display has `u(k)>0`;
the sum of the pair axes has square `2u(k)>0` and is orthogonal to
`v_k`. Its projection bound is zero. The endpoints have a positive
inward diagonal. This covers `M=2,k=1` without division by zero.

Exact expansion therefore gives

    a^T V_k a + 2u(k)g(k)^2
      - u(k-1)g(k-1)^2 - u(k+1)g(k+1)^2 <= 0.

Summing `k=0,...,M` cancels every auxiliary term, including endpoints.
Hence `sum_k V_k` is nonpositive on one common hyperplane and has
positive index at most one. Arbitrary sums of signature matrices would
not suffice: `diag(1,0)+diag(0,1)=I_2`. That failed shortcut is not a
manuscript assertion and is not reported as a refutation.

### 3. Width one and finite iteration

For `M=1`, both blocks reduce to `[V_k,S;S^T,0]`.
If `S` is nonzero, a nonzero null axis in a one-positive form forces its
orthogonal hyperplane to be nonpositive. For completeness, if `B(e,e)=0`,
`B(e,w)!=0`, and a positive vector `v` satisfied `B(e,v)=0`, subtract
the projection of `w` on `v`; then adding a suitable multiple of `e`
produces a positive vector orthogonal to `v`, a contradiction.
`null_axis` proves this algebraically, with no limiting argument.

If any old `z_i>0`, the coefficient
`S_i=Psi(z-e_i,0,0)` is positive by the actual model's positivity.
Otherwise box-validity gives `z=0`; all old removals are invalid and
both `V_k` vanish. Thus the exceptional `S=0` case is not an extra
hypothesis. `contract_signature` proves these alternatives from the
integer model itself.

`contract_positive` proves that ordinary pair summation preserves exact
support on the new box/total and strict positivity on its valid slice.
`iterated_closure` now inducts over any finite number of pairs.
`Coordinates iota n` is a disjoint sum of the remaining indices and
`n` two-point sets, so any arbitrarily labelled disjoint pairing is
covered by a coordinate bijection. No binary Lorentzian closure or
factorial lift is substituted for integer contraction.

### 4. Companion weighted estimate

At occupancy `D=B+1`, use only box-valid displays `1,...,D-1`.
The identical local inequality holds. Multiply it by
`w_k=k(D-k)`, whose boundary values are zero. Finite summation by parts
and `2w_k-w_{k-1}-w_{k+1}=2` give

    2 sum_{k=1}^{D-1} u(k)g(k)^2
      <= -a^T (sum_{k=1}^{D-1} k(D-k)V_k) a.

`pair_weighted` proves this without requiring matrices at the out-of-box
endpoint displays. It asserts this quadratic bound, not a signature
for the weighted matrix.

### 5. Additions and finite limits

Reflect every integer coordinate by `v_i -> m_i-v_i`.
The factors become `psi_G(sum_G m_i - a)`, still positive and
log-concave. A balanced pair is sent to `(M-k,k)`; reversal permutes
its `M+1` terms. The full total becomes `sum_i m_i-R` and the remaining
total becomes `sum_active m_i-r`. A display of total `r-2` becomes a
display two above that reflected total. Reflected removals are exactly
original additions. `integer_addition_signature` proves this for the
same eliminated weight, not for an unrelated reflected model.

For a pointwise limiting sequence of forms, fix `u` of positive limiting
square. Its approximating square is eventually positive. Pass
`B_n(u,u)B_n(v,v)<=B_n(u,v)^2` to the limit. `limit_closed`,
`matrix_limit`, and `limiting_signature` formalize this argument.
All sums here are finite, so limits commute with the balanced sums.
Zeros in an equality limit are introduced only after the positive
argument; no limiting zero is used as a divisor.

## Exact application to the softened weights

### Capped `h_j`

The actual definition is `scales.tex`, `eq:hj`: on every box-valid small
profile of total `p=sum_small b_s`, balanced or not,

    h_j(x,y) = sum_{free z_e=0,...,b_e} 2^(-j D(x,y,z)/H),
    D = A (sum_roots |delta_v| + sum_tree dist(z_t,[0,b_t])/b_t).

Tree values are the unique nonroot completion. Use physical intervals
`[0,b_s]` for small/free cells, and `[-10db_t,10db_t]` for tree cells.
Thus tree offsets are `ell_t=-10db_t` and widths `M_t=20db_t`;
all eliminated widths are positive. Encode row and column views as
`ell_s+x_s` and `ell_s+M_s-y_s`. They agree exactly when
`x_s+y_s=M_s`.

Give the full box/total weight

    alpha^(sum_nonroots |L_v-kappa_v|)
      * 2^(-(jA/H)(sum_roots |L_v-kappa_v|
                    + sum_tree dist(ell_t+x_t,[0,b_t])/b_t)),
    0 < alpha < 1.

Row factors use disjoint `x` groups, column factors disjoint `y` groups,
and each tree penalty is a unary subset of its row group. Equal sets
can be combined. The exponents are convex; multiplication by their
nonpositive logarithmic coefficients makes all factors log-concave.
At `j=0` the second factor is constant one, which is permitted.
Set the full total to `sum_s M_s`; after summing all large pairs it
leaves exactly `p` on the small coordinates.

Here is the finite bijection, not merely an analogy. Fix an arbitrary
box-valid small profile of total `p` and arbitrary integer free values
in `[0,b_e]`. Root the maximum-capacity large-cell spanning forest.
Leaf elimination solves each nonroot margin equation for its parent
edge, uniquely and integrally. No root equation is imposed.
The forest estimate places every solution in the chosen tree intervals.
Conversely a surviving balanced full profile has that free restriction,
and uniqueness forces the same tree values. For physical value `v`
the tree pair is uniquely `(v-ell,ell+M-v)`. Thus there is exactly
one surviving full profile per free assignment.

The interval estimate does not need balanced small profiles. Relative
to a feasible baseline table `X*`, sum signed nonroot equations on the
far side of a tree cut. Internal large edges cancel; the terms left
are free edges crossing the cut and small *incidences*, including both
incidences of an unbalanced small cell when necessary. Maximum-capacity
exchange gives `b_e<=b_t` on each crossing free edge. In the actual
integer free box, `|z_e-X*_e|<=b_e<=b_t`; each small incidence deviation
is at most `b_s<W<=b_t`. At most `d` free edges and `2d` small
incidences give `|z_t-X*_t|<=3db_t` (the manuscript uses `4db_t` on
the larger real free box). Since `0<=X*_t<=b_t`, this lies inside
`[-10db_t,10db_t]` for `d>=1`. This uses the retained-instance
feasibility, scale separation, and maximum-forest hypotheses, not a
signature conclusion.

As `alpha` tends to zero, exactly the nonroot equalities survive.
The remaining factor is **exactly** `2^(-jD/H)`, not `2^(-D)` unless
`j=H`. The finite bijection proves equality to `h_j` without extra
terms or multiplicity. The certified limit and addition/removal
theorems therefore give `cor:hj-signatures`. The graph/forest setup is
proved in prose here and cited as an application dependency; it is
not claimed as part of the Lean formalization.

### Sampler `f_eta`

In the sampler, the positive factors are `eta` raised to absolute full
row/column deviations and positive-part small row/column deviations.
They use row `x` groups, column `y` groups, and their nested small
subgroups; hence the family is laminar. Fixed box-valid coordinates
simply shift their factors and restrict their sets, preserving
laminarity. Summing all large pairs yields **exactly**
`eq:soft-marginal`, with one term per large-cell integer assignment,
on every small box profile of the prescribed total, even outside
transversal/defect patterns.

On the graph patterns where the actual `f` is defined, zero penalty
means full padded margins and nonnegative original small residuals.
Lines without large slots then have residual zero by their full-margin
equalities. A completion `A` maps uniquely to large pairs
`(A_s,C-A_s)`, and conversely every zero-penalty summand gives that
completion. Its total is at most `N+|B|L < C=N+dL+U+2`, since
`|B|<d`; thus the finite cap excludes no nonnegative completion.
The empty block has its one empty assignment. Consequently the
finite `eta -> 0` limit gives precisely the actual completion count
on these patterns. No hard margin is imposed during the positive
projection argument. This is essential for positivity of every
interior `u`.

These applications certify the quadratic signatures only. They do
not by themselves certify lifts, tree-marginal interpolation,
transport bounds, mixing, sampling, counting, or their complexity.

## Replay and adversarial evidence

Run from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/signature_core/verify.py

The script uses exact rational congruence pivots, not floating eigenvalues,
to check 42,714 matrices from 2,520 models, including 14,238 equality-limit
matrices, inactive coordinates, repeated removals, two eliminated pairs,
and reflection of the full factors. It separately checks the local
expansion and finite endpoints. These are finite experiments, not the
universal proof. The default replay also invokes the real Lean verifier
and both official campaign-local checks; `--exact-only` explicitly does
not certify the theorem.

`jacobian_payload.json`, `jacobian_result.json`, and
`jacobian_status.json` preserve one bounded typed adapter operation,
`matrix.inertia.compute`, after discovery and inspection. Its exact
three-coordinate instance has inertia `(1,2,0)`, independently replayed
by the script. It is not universal evidence.

No false literal manuscript assertion was found in the certified scope.
There is consequently no invented `F_...` refutation claim. Compiler
success does not establish novelty or statement fidelity; the Host's
independent Reviewer must assess those separately.
