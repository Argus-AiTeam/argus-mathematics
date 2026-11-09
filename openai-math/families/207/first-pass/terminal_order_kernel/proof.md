# Terminal twisted equality/order kernels

## Scoped source and question

The source is the staged October 5, 2026 manuscript, under
`research/openai_manuscript/The-l1-Bass-Conjecture-for-Discrete-Groups-October-5-2026/build/sections/`.
The September manuscript is an alternative route, not a dependency here.

The exact target is `06-curvature.tex`, Lemma `pf:terminal-singular`
(lines 210-307) and its consequence `pf:terminal` (lines 309-321).
The operator must be derived from `05-connection.tex`, `co:forms` and
`co:last-kernel`, and `06-curvature.tex`, `pf:kernel`, without replacing
either lag kernel.

The terminal label kernel in `co:end-fields` is equality. The two lag
kernels in `co:last-kernel` are:

1. `sign(s)` when the twist has infinite order.
2. `sign(s) 1_{|s|<1}` when the twist has finite order.

On `H = L2((0,1) x G, Y(u)_y du)`, the operator is therefore

    T(u,y;v,z) = sum_{a in Z} U(v+a-u) 1_{y=g^a z}.

In the infinite-order case the left action on group labels is free.
For labels `g^a y0, g^b y0`, equality selects the unique shift `a-b`;
the coordinate `u-a` gives an ordinary sign kernel. In the finite-order
case, only shifts `0,+1,-1` occur. Their separate source and target
spaces need not have the same measures. In particular, treating the
shifted maps as invariant label blocks would not be justified; the
manuscript correctly reindexes target summands instead.

The terminal channel's mass bound is stated in `04-channels.tex`,
Lemma `ch:terminal` (lines 347-365), and used in `05-connection.tex`,
`co:end-fields` (lines 98-109). Its smoothness and finite local support
are used in `co:regularity` (lines 195-234). The Fisher bound needed to
apply the operator estimate to manuscript curvature is `co:fisher`
(lines 545-552); it is an input to, not a consequence of, a singular-value
certificate.

## Minimal proof dependencies

The operator theorem will use only finite total nonnegative mass,
nonatomic time measures, freeness for the full-sign case, and bijectivity
for the truncated-sign case. Neither spatial displacement, channel
support diameter, nor a bound on the twist order is needed for this
operator question. Those hypotheses may still be needed elsewhere in
the manuscript.

The analytic route below is a finite-rank approximation by successive
intervals of equal combined source/target mass, followed by a mass
budget over orbit or paired-label blocks. The only finite-dimensional
ingredients are the singular-value minimax argument, the determinant
identity for an alternating matrix, and Hadamard's inequality. These
elementary ingredients will be justified in the proof, not taken from
an unchecked literature theorem.

The curvature pairing is derived by exterior differentiation of
`co:forms`, then period reduction using twisted equivariance. The
Fisher estimate and the construction of the actual channel remain
separate inputs. Positivity, raw-stage occupancy, spatial summaries,
normalization, scale assembly, cyclic detection, and the main Bass
theorem are outside this bounded certification.

## Prior evidence and unsuccessful routes

The initial campaign ledger contains no reviewed result for this
component. The inherited Wiki index has no matching Bass/order-kernel
entry. No failed mathematical route is being inherited or silently
retried. Fixed-size matrix experiments cannot establish the quantified
compression estimate and will be used only as boundary regressions.

Jacobian discovery found an exact two-by-two singular-spectrum
operation, not an all-dimension order-kernel theorem. Its typed contract
was inspected before use. The bounded compression calculation is kept
separate from the universal proof.

No false manuscript assertion has been established in this scoped
reading. No refutation verdict is claimed.

## Quantified verification theorem

Let `L` be a countable label set, `sigma` a bijection of `L`, and `mu_y`
finite nonatomic positive measures on `(0,1)`. Put

    m = sum_y mu_y((0,1)) < infinity,
    H = direct_sum_y L2(mu_y).

Zero measures are allowed. There is no lower bound on a nonzero mass,
no bound on the number of labels, and no relation required between the
measures of two labels. The manuscript is the special case
`dmu_y(u) = Y_b(u)_y du`, `sigma(y) = g y`, and `m <= 1`.

Define `T` by the displayed periodized equality kernel above. There
are two different conclusions for its two different lag kernels:

1. If every `sigma`-orbit is free (isomorphic to `Z`) and
   `U(s) = sign(s)`, every finite-dimensional orthogonal compression
   has `s_nu <= 4 m / nu`, for every integer `nu >= 1`.
2. For **any** bijection `sigma`, including permutations with mixed
   finite and infinite orbits, if `U(s) = sign(s) 1_{|s|<1}`, every
   finite-dimensional orthogonal compression has
   `s_nu <= 36 m / nu`, for every integer `nu >= 1`.

Singular values are in nonincreasing order, repeated with multiplicity
and completed by zeros. Both operators are compact and skew-adjoint
on the real Hilbert space. No spatial-displacement hypothesis is
needed for this operator theorem. In particular, its truncated
conclusion covers orders one and two, even though order one does not
satisfy the manuscript's separate displacement hypothesis.

For either operator, any positive even integer `k`, vectors
`X_1,...,X_k` in `H`, and scalar `W >= 0` satisfy, with
`Q_ii' = <X_i, T X_i'>`,

    |Pf(W Q)| <= (36 m W)^(k/2) product_i ||X_i|| / sqrt(k!).

If `n,beta > 0`, `a,l_i >= 0`, and
`||X_i|| <= a l_i sqrt(n/beta)`, this implies the entirely explicit
bound

    |Pf(W Q)| <= (sqrt(108 m) a sqrt(W/beta))^k
                  (n/k)^(k/2) product_i l_i.

For `m <= 1`, the constant `sqrt(108 m)` may be replaced by `11`.
Thus the precise kernel in the manuscript gives `pf:terminal-singular`
with `C = 36` and `pf:terminal` with `C = 11`, provided its stated
channel and Fisher hypotheses hold. For a dependent family of `k`
vectors, the Pfaffian is exactly zero. The empty Pfaffian is one and
is treated separately, without the expression `n/0`.

### Proof 1: the two-measure approximation

Let `mu,nu` be finite nonatomic positive measures on the line, of
combined mass `M`. If `M=0`, use the zero operator. Otherwise, continuity
of the distribution function of `mu+nu`, its limits at infinity, and
the intermediate value theorem give `N` successive intervals
`I_1,...,I_N` of equal combined mass `M/N`. This works on an unbounded
support as well as a bounded one. Endpoints have zero mass.

For any of the three kernels `sign(s-t)`, `1_{s<t}`, `1_{s>t}`, retain
the kernel between different intervals and replace it by zero within
each interval. The resulting operator `A_N` has the explicit formula

    (A_N f)(t) = sum_b c_ab integral_{I_b} f(s) dnu(s),  t in I_a,

where `c_ab` is the appropriate constant order comparison for `a != b`
and `c_aa=0`. Its range lies in the span of the `N` functions
`1_{I_a}` in `L2(mu)`, so its rank is at most `N`. Zero target masses
can only reduce that rank. `Main.lean` verifies the finite-matrix
version of precisely this factorization through a bin set; the
displayed integral formula proves the Hilbert-space version directly.

The remainder `R=A-A_N` maps the source interval `I_a` only into the
target interval `I_a`. For such a block, the kernel bound by one and
Cauchy--Schwarz give

    ||R_a f||_L2(mu)^2
      <= mu(I_a) nu(I_a) ||f||_L2(nu)^2
      <= (M/(2N))^2 ||f||_L2(nu)^2.

The last inequality is the exact identity
`(p+q)^2 - 4pq = (p-q)^2 >= 0`.
Both the source and target interval decompositions are orthogonal,
so summing the squared inequalities proves `||R|| <= M/(2N)`.
The same calculation on the whole line gives
`||A|| <= sqrt(mu(R)nu(R)) <= M/2`.
Neither equality of source and target measures nor positive masses
of individual intervals was used.

### Proof 2: the countable mass budget

Consider any family of paired blocks with mutually orthogonal source
spaces and mutually orthogonal target spaces. Suppose their combined
masses are `b_i`, their norms are at most `b_i/2`, their rank-`N`
approximation errors are at most `b_i/(2N)`, and
`sum_i b_i <= 2m`.

For an error target `x>0`, discard the blocks with `b_i <= 2x`.
There are only finitely many remaining blocks: infinitely many
`b_i>2x` would contradict finite total mass. On each remaining block
choose

    N_i = ceil(b_i/(2x)).

Then its error is at most `x`. Writing `q=b_i/(2x)>1`, the elementary
ceiling bounds give `N_i < q+1 < 2q`; in particular `N_i <= b_i/x`.
Therefore the assembled approximant has

    rank <= sum_retained N_i <= (sum_retained b_i)/x <= 2m/x.

On discarded blocks the norm is already at most `x`. Orthogonality
on both sides, not invariance of individual blocks, shows that the
error of the whole operator is at most `x`. This argument includes
zero source masses, zero target masses, and an infinite family of
nonzero masses.

For three such contributions, approximate each with error `x/3`.
The triangle inequality and rank subadditivity give

    total error <= x,
    total rank <= 3 (2m/(x/3)) = 18m/x.

The finite-rank approximants for every `x>0` also prove compactness.
These are universal inequalities in the total mass, not estimates
that grow with a truncated number of blocks.

### Proof 3: free full-sign orbits

Fix an orbit representative `y0`. Every label in that orbit is
uniquely `sigma^a y0`, `a in Z`. The equality constraint between
`y=sigma^a y0` and `z=sigma^b y0` selects exactly the shift `a-b`.
Consequently, putting `t=u-a`, `s=v-b`, the kernel is

    sign(v+a-b-u) = sign(s-t).

The open intervals `(-a,1-a)` are disjoint. Push `mu_(sigma^a y0)`
onto the corresponding interval by `u -> u-a` and sum the resulting
measures. This gives a finite nonatomic measure `lambda_o`; the
coordinate change is a unitary identification of the orbit Hilbert
space with `L2(lambda_o)`. Its mass is `m_o`. Different orbit Hilbert
spaces are orthogonal and their masses sum to `m`.

Apply Proof 1 with equal source and target measure `lambda_o`,
so the combined mass is `b_o=2m_o`. Proof 2 now provides an
approximation of the full operator of rank at most `2m/x` with error
at most `x`. No bound on how far apart the matching integer shifts
are is needed.

### Proof 4: the exact truncated kernel, without an order assumption

For `0<u,v<1`, put `d=v-u`, so `-1<d<1`. For the unchanged kernel
`U(s)=sign(s)1_{|s|<1}`, all shifts other than `0,+1,-1` vanish.
The three remaining values are exactly

    T(u,y;v,z)
      = sign(v-u) 1_{y=z}
        + 1_{v<u} 1_{y=sigma z}
        - 1_{v>u} 1_{y=sigma^{-1} z}.                 (*)

For example, `U(v+1-u)=1_{v<u}` and
`U(v-1-u)=-1_{v>u}`. At `u=v`, all three terms are zero
with the stated jump convention. Nonatomicity also makes any
different values at those jump points irrelevant as operators.

The first contribution pairs `L2(mu_z)` with itself. The second pairs
`L2(mu_z)` with `L2(mu_(sigma z))`; the third pairs it with
`L2(mu_(sigma^{-1} z))`. In each contribution, distinct source blocks
are orthogonal and distinct target blocks are orthogonal, since
`sigma` and `sigma^{-1}` are bijections. The shifted source and target
spaces are **not** being identified with invariant subspaces.

For each paired block use Proof 1, with combined mass
`b_z=mass(mu_z)+mass(mu_(sigma z))` or the corresponding inverse,
and with the appropriate order kernel. In each contribution,
the sum of combined masses is exactly `2m`. Proof 2 gives the
three-contribution rank/error bounds `18m/x` and `x`.

If `sigma` is the identity, (*) is identically zero:
`sign(v-u)=1_{v>u}-1_{v<u}`. If `sigma` is an involution,
it becomes

    sign(v-u) (1_{y=z}-1_{y=sigma z}).

Thus order two causes no double-counting error; it does not license
dropping either shifted term. These identities, including equal times
and fixed labels, are proved for arbitrary label types in `Main.lean`.
The three-contribution bound remains valid for every permutation,
not only permutations of a common finite order.

### Proof 5: all compression singular values

For a finite-dimensional orthogonal projection `P_E`, the
approximation `A_x` above gives `P_E A_x|_E` of no larger rank and
error at most `x`. If a real matrix `A` has an approximant `B` of
rank less than `nu` and error at most `x`, its `nu`th singular value
is at most `x`: in the span of its first `nu` right singular vectors,
the restriction of `B` has a nonzero kernel vector. Normalize it to
`v`. Then `||A v|| >= s_nu` whereas
`||A v||=||(A-B)v|| <= x`. This also handles repeated singular values.
Indices larger than the compression dimension have singular value zero.

If `m=0`, all measures and all operators vanish. If `m>0`, set
`x=4m/nu` for the free full-sign case. The rank bound is at most
`nu/2 < nu`, proving `s_nu <= 4m/nu`. For the truncated case use
`x=36m/nu`, giving the same rank bound and `s_nu <= 36m/nu`.
This completes the proof for every dimension and every index.

The full-sign kernel is antisymmetric on each unfolded orbit.
Formula (*) is antisymmetric by interchanging `(u,y),(v,z)` and
using `y=sigma z` iff `z=sigma^{-1} y`; this is also formalized.
Bounded kernels and finite total mass justify Fubini for the
pairings of `L2` vectors by Cauchy--Schwarz. Thus `T*=-T`.

### Proof 6: the curvature sign, compression and Pfaffian

Suppose a time-dependent field is nonnegative, smooth with finite
local label support on a period, twisted-equivariant, and has
`partial_i Y=0` at its zero coordinates. Suppose its logarithmic
derivatives `X_i=partial_i Y/Y`, set to zero at zero weights, are in
`H`. These are explicit application hypotheses; the operator theorem
above did not require differentiation at all.

Exterior differentiation of the actual one-form gives

    B = -1/2 integral U(v-u) dY(u) Y(v),
    dB = +1/2 integral U(v-u) dY(u) wedge dY(v).

The plus sign follows from `d(dY(u) Y(v))=-dY(u) wedge dY(v)`.
At a fixed period cut there is no moving-boundary term. For full sign
and finite local label support, equality selects only finitely many
shifts locally, which also justifies differentiation; for truncated
sign the lag integral is bounded.

Write `v=w+a` with `0<w<1`, and use
`Y(w+a)=sigma^a Y(w)`. This gives exactly `pf:kernel`, not a
replacement kernel. Antisymmetry shows that the two terms in the
coefficient of the wedge agree after interchange, canceling the
factor `1/2`. Since `partial_i Y=X_i Y`, the result is precisely

    (dB)_ii' = <X_i, T X_i'>.

Let `E` be the span of the `k` vectors. If `dim(E)<k`, the pairing
matrix has rank less than `k`, its determinant is zero, and so is
its Pfaffian. Otherwise choose an orthonormal basis of `E` and put
the vector coordinates in the square matrix `V`. Then
`Q=V^T T_E V`. Using the algebraic identity `Pf(Q)^2=det(Q)`,
`|det(T_E)|=product_nu s_nu`, and Hadamard's inequality gives

    |Pf(Q)| <= product_i ||X_i|| (product_{nu=1}^k s_nu)^(1/2)
             <= (36m)^(k/2) product_i ||X_i|| / sqrt(k!).

Scaling an alternating matrix by `W` scales its size-`k` Pfaffian
by `W^(k/2)`. This proves the first Pfaffian assertion, including
zero vectors, zero mass and `W=0`.

The elementary finite-dimensional identities used here do not require
an external analytic theorem. To see the Pfaffian determinant identity,
write the alternating form as `omega=sum_{i<j} A_ij e_i wedge e_j`.
The coefficient of the top form in `omega^(k/2)/(k/2)!` is `Pf(A)`;
under a change of basis `V` it changes by `det(V)`. If a skew matrix
has a nonzero entry, simultaneously permute its rows and columns to
put that entry in position `(1,2)`. Adding multiples of the first
two basis vectors to the others then makes it congruent to
`[[0,a],[-a,0]]` direct sum a smaller skew matrix, by a change of
basis of determinant one. Both the determinant and the squared
Pfaffian acquire the factor `a^2`. Induction proves equality, the
all-zero matrix and the empty matrix being the base cases. This
also proves the assertion when the matrix is singular.
Hadamard's inequality follows by Gram--Schmidt: the absolute
determinant is the product of successive perpendicular lengths,
each bounded by the corresponding original column length; for
dependent columns it is zero. Finally,
`det(A^T A)=(det A)^2` and the definition of singular values as
the square roots of the eigenvalues of `A^T A` give
`|det A|=product s_nu`. These arguments apply in every finite
dimension, not just the regression dimensions.

For completeness an entirely elementary all-integer bound is
`k! >= (k/3)^k` for `k>=1`. Indeed,
`j! >= 2^(j-1)` for `j>=1`, by induction. For each integer `k>=1`,
the binomial theorem and
`binom(k,j)/k^j <= 1/j!` give

    (1+1/k)^k <= sum_{j=0}^k 1/j!
              <= 1 + sum_{j=1}^k 2^{-(j-1)} < 3.

Starting from `1! >= 1/3`, induction proves the asserted factorial
bound: the induction step reduces exactly to
`(1+1/k)^k <= 3`. Substitution in the Pfaffian estimate and the
stated vector bounds gives `sqrt(108m)` above. Finally `108<121`
permits the constant `11` when `m<=1`.

## What the executable and Lean evidence establish

`verify.py` replays the exact symbolic identities underlying the mass
budget and constants, verifies the saved Jacobian answer, and checks
exact rational integrations of the unchanged kernels on a bounded
collection of interval-step subspaces. These are boundary regressions,
not a passage from finitely many matrices to all dimensions.

`Main.lean` proves the arbitrary-dimension weighted-bin factorization
and rank bound, and the arbitrary-permutation kernel identities,
without proof holes. The official compiler record is
`lean_verification.json`, with the statement fidelity in
`statement_fidelity.md`. Neither this Lean result nor the finite
regressions formalize nonatomic quantiles, the operator-norm
Cauchy--Schwarz argument, the countable allocation argument, the
singular-value minimax step, or the Pfaffian argument. Their complete
mathematical proofs are above and require independent reading.

This improves the initial project state from an untested assertion
to an explicit all-dimension proof with constants `4,36,11` and a
checked algebraic core. It does not claim that these constants are
optimal, that the generalization is a globally new literature result,
or that the Bass conjecture has been proved. Novelty and publishable
significance remain for independent assessment; the campaign remains
open beyond this bounded node.

The deterministic replay command, from the campaign root, is

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/terminal_order_kernel/verify.py
```

Its saved output is `replay.json`. The recorded run checked ten symbolic
identities, twelve unequal-measure order compressions, eighteen twisted
compression cases (including zero spaces), ninety-eight exact
singular-value thresholds, and thirty positive-even-size Pfaffians.
These counts describe the regressions only. The quantified theorem is
proved by Proofs 1-6, with the formal scope stated separately above.
