# Uniform influence for simple uniform hypergraphs

## Result and scope

For every integer `r >= 3` there is a positive finite real `C_r` such
that every `n >= r`, every `0 < p < 1`, and every vertex-invariant
Boolean property of simple `r`-uniform hypergraphs satisfy

```
Var_p(f) <= C_r I_p(f) / (log n)^(r/(r-1)).
```

Influence means pivotal influence, without a bias prefactor.
Monotonicity is not assumed. `Main.lean` proves this complete statement
as `HypergraphInfluence.uniform_influence`, with genuine finite
Bernoulli product variance and influence definitions in `Model.lean`.
The prescribed claim-linked Lean 4.31.0 verifier and standalone replay
passed: `exit_code=0`, `proof_holes=[]`, and axiom-audit exit zero.
All 42 non-Mathlib dependencies were freshly compiled; the final theorem
and its audited dependencies use only `propext`, `Classical.choice`,
and `Quot.sound`. The ledger derives `H_VARIANCE` v2 as `closed_kernel`,
with no external assumptions, stale evidence, or outstanding ledger
issues. The kernel certificate is
`certificates/certificates/H_VARIANCE-9681ad1f15675943.json`.
Independent Reviewer acceptance and statement-fidelity approval remain
pending; kernel status does not stand for that review.

The independently accepted capture source and certificate are reused
unchanged. Compared with that prior result, this work discharges the
remaining analytic, restriction, symmetry, transfer, and uniform-constant
obligations and reaches the principal theorem. Compared with the pinned
upstream generic Fourier/graph development, it adds a full hypergraph
integration. The contribution asserted here is independent formal
certification, not a new unformalized influence inequality or an
exhaustive bibliographic novelty claim.

## Analytic identities and normalization

Let `sigma = sqrt(p(1-p))` and `alpha = r/(r-1)`.
The biased characters are products of `(x_e-p)/sigma`. Their coefficients
obey

```
Var_p(f) = sum_(S nonempty) fhat(S)^2,
sum_S |S| fhat(S)^2 = sigma^2 I_p(f).
```

Both statements are derived from the product law; the second uses the
squared Boolean coordinate difference, so no sign or monotonicity
assumption is needed. It follows at once that
`Var_p(f) <= sigma^2 I_p(f) <= I_p(f)/4`.

For any finite coordinate set, the generic low-degree theorem states
that individual pivotal influences at most `I/m`, with `m >= 1`, imply

```
sum_(1 <= |A| <= sigma log(m)/64) hhat(A)^2 <= m^(-1/4) I(h).
```

The cutoff is a real comparison. The port compiles its tensor-product
two-to-four estimate and low-degree projection argument, not a theorem
assuming that analytic ingredient. The full 29-module generic dependency
closure is retained, with Apache-2.0 attribution, from
`openai/math@4eaee87548250b2682affda7d05d947c05554bae`.
Three conditional-rewrite compatibility substitutions suffice for the
generic Lean 4.31.0 port. Additional generic restriction/counting helpers
are attributed in `block_support/source-manifest.json`.
These are checked proof dependencies, not unproved literature assumptions.

## Surviving symmetry and exact restriction

For a fixed `m`-vertex block `B`, leave free every edge meeting `B`;
condition only on edges entirely outside it. A permutation supported on
`B` fixes each assigned coordinate pointwise, hence fixes every exterior
assignment. An edge with `j` vertices in `B` has as its orbit all edges
with its fixed exterior part and an arbitrary `j`-subset of `B`.
The orbit has `choose(m,j)` distinct elements.

For `1 <= j <= r < m`, this number is at least `m`. For example,
`j*choose(m,j)=m*choose(m-1,j-1)` and
`choose(m-1,j-1) >= choose(j,j-1)=j` give the bound.
Influences are equal along the orbit by coordinate reindexing of the
product law. Nonnegativity therefore gives each influence at most
the restricted total divided by `m`.

Apply the low-degree theorem to each restricted Boolean function `f_y`.
Exact orthogonality in the assigned coordinates gives, for each free
support `A`,

```
E_y[fhat_y(A)^2] = sum_(D subset exterior) fhat(A union D)^2.
```

There is no bound on `|D|`. Conditioning the pivotal event similarly
gives `E_y[I_e(f_y)] = I_e(f)` for every free coordinate.
Thus, for `k = sigma log(m)/64`,

```
sum_S Pr_B(1 <= |S intersect F_B| <= k) fhat(S)^2
  <= m^(-1/4) (r m/n) I_p(f).
```

The last factor uses fixed-size block sampling: each vertex belongs
to the block with probability `m/n`, so a union bound over the `r`
vertices of an edge bounds its touching probability by `r m/n`.
`Block.lean` and its support modules prove all these steps.

## Capture transfer and the full tail

Put `L=(k/r)^alpha`. Under
`r L (m-1)/(n-1) <= 1/2`, the accepted capture theorem says that
every nonempty simple support with `|S| <= L` has capture probability
at least `m/(2n)`. An injective map forgetting the edge subtype identifies
the Fourier support and its retained edges with the accepted theorem's
objects. Multiplying each squared coefficient by that probability and
summing nonnegative terms gives

```
sum_(1 <= |S| <= L) fhat(S)^2 <= 2r m^(-1/4) I_p(f).
```

Division is by the positive `m/(2n)`. If `L<1`, the sum is empty;
`empty_low_range` proves this for all real cutoffs. The high-degree
bound follows from the actual weighted Parseval identity:

```
Var_p(f) <= low_mass(L) + sigma^2 I_p(f)/L.
```

`Transfer.lean` proves both inequalities. Neither the block estimate
nor the capture conclusion is assumed in the final theorem.

## Constants uniform down to arbitrarily small bias

The numerical proof uses `m = ceil(sqrt n)`, rather than the manuscript's
floor. For every fixed `r` and `alpha`, logarithmic powers are little-o
of every positive power of `n`. Consequently, eventually

```
m >= r+1,  m <= n,  log m >= (log n)/2,
m-1 <= sqrt n,  4r(log n)^alpha <= sqrt n,
(log n)^alpha <= m^(1/4).
```

All eventual assertions and ceiling inequalities are proved in
`Constants.lean`. Since `L <= (log n)^alpha`, they imply the capture
condition: `r L (m-1) <= n/4 <= (n-1)/2` for `n >= 2`.
They also bound the low-mass coefficient by `2r/(log n)^alpha`.

For `0 < sigma <= 1/2` and `alpha <= 2`,
`sigma^2 <= sigma^alpha`. Together with
`log m >= (log n)/2`, this gives

```
sigma^2 / L <= (128r)^alpha / (log n)^alpha.
```

This proof does not divide by a lower bound for `sigma` and remains
valid as `sigma` tends to zero. It also covers `L<1`, when the tail
controls the whole variance. If `N` is an eventual scale threshold,
the proof chooses the finite constant

```
C_r = 2r + (128r)^alpha + (log(N+3))^alpha + 1.
```

For `n < N`, positivity and monotonicity of the logarithm and real
powers give `(log n)^alpha <= (log(N+3))^alpha`, so the Poincare
bound `Var_p(f) <= I_p(f)/4` finishes the small-`n` case.
This proves the exact order of quantifiers required for `C_r`.

## Adversarial checks and replay

`verify.py` supplements the universal proof with rational biased-Fourier
checks on four-coordinate Boolean functions, including nonmonotone
ones and extreme rational biases. It checks Parseval, pivotal rather
than resampling normalization, restriction averaging with unrestricted
exterior degrees, and averaged restricted influences.
Finite binomial-orbit checks include the excluded boundary `j=m`,
where the orbit has size one and the required strict inequality
`r<m` would fail.

The one bounded Jacobian operation is
`group_action.subset.canonicalize`, on a three-subset under the full
six-vertex symmetric action. Its typed result is orbit size `20` and
stabilizer size `36`; the exact payload, contract, server/protocol,
output, and adapter status are retained. This is a finite check,
not universal proof evidence. No false literal manuscript assertion
has been established, so no `F_` refutation claim is warranted.

Run from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/certificates/hypergraph_influence/verify.py
```

The verifier checks the accepted capture certificate's unchanged source,
rebuilds the entire non-Mathlib theorem dependency closure, invokes the
prescribed claim-linked Lean evidence verifier on `H_VARIANCE`, audits
the final theorem's transitive axioms, and runs both official checks
against this campaign root. It does not certify the graph-family route,
the threshold corollary, or mathematical/bibliographic novelty beyond
the documented formalization scope. Independent acceptance of the
full theorem is reserved for the Host-invoked Reviewer.

The completed replay is `certification_result.json`, with its submitted
task/run/check command preserved in `certification_receipt.json`.
Both official checks returned zero against
`campaigns/9000186`.
The final exact experiment totals were 18 Boolean/bias cases, 72
restriction coefficient identities, and 33 interior orbit checks,
with no counterexample. These counts do not replace the universal proof.
