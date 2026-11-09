# Contextual entropy inputs and offers

**Assessment: supported in the stated finite-probabilistic scope, by prose
reading and the old independent judgements, not by the finite-search compiler.**
The attribution is to Sections 03 and 04 of the September 23, 2026 manuscript.
These are reviewed reproductions, not new entropy results.

## Claims, definitions and revision

`L_ER_CONTEXT@1`, `L_ER_GLUE@1`, `L_ER_OFFER@1` are stated in old context
`CTX_ER@1`. The relevant reference files are
`build/sections/03-entropy-foundations.tex` and
`04-entropy-refinement.tex` under the old manuscript directory.
Their actual bytes match the reference manifest at revision
`4eaee87548250b2682affda7d05d947c05554bae`; the index records their exact
digests. This is measured agreement, not an assumption that all revisions
of the paper are identical.

All variables here are finite-valued. A context is a joint law `(X,W)`;
refinement keeps `W` and applies a finite channel conditional on `(X,W)`,
preserving the marginal of `X`. The quantity `G_s(W)` is the entropy of
the sum of **independent copies of the current pair**, conditional on all
their contexts. In contrast, `I_r(W)` minimizes
`r H(X|W)-H(X^r|sum X_a,W^r)` over arbitrary row couplings with the
prescribed one-row pair marginal. `K_m(W;r)` similarly minimizes the
noisy block-sum cost, including `E c(Gamma)`, allowing correlated rows
and error in `TS-TS`. Within each prescribed block row the pairs are iid.

`L_ER_CONTEXT` is `entropy-foundations:context-bounds`: given the
constructed marginal `nu` and correlated law `Psi` of
`entropy-foundations:exchangeable`, `G_s` is increasing in `s` for
`s <= m_*`, `I_r` is increasing in `r` for `r <= T_0`, both decrease
under every finite refinement, and both are between zero and a common
`D_*=C'_0(D_0)d`. The bounds are uniform over those refinements, not over
arbitrary distributions unrelated to that construction.

## Decisive checks

For `G_s`, conditional independence gives
`H(A+B) >= H(A+B|B)=H(A)` at fixed contexts. Refinement is additional
conditioning in an iid extension. For `I_r`, projecting an `(r+1)`-row
trial and applying the entropy chain rule bounds its objective below by
the admissible `r`-row objective. Refining each row with fresh independent
channel randomness gives the source's `refinement-identity`:

```
F-F' = sum H(A_a|V_a) - H(A^r|Z,V^r) >= 0.
```

The cancellation uses conditional independence of the new channels given
the old pairs and output, not independence of the old rows. The common
bound follows from the noisy correlated trial: `H(Gamma) <= F_0+E c(Gamma)`
and `H(sum X_i) <= I(X^s;Z_s)+2H(Gamma)`. Its short-block total-variation
comparison transfers the bound only for `s <= m_*`; the sumset hypothesis
pays the entropy-continuity error. Projection of `Psi` gives the initial
`I_r` bound, then refinement monotonicity preserves it. Thus the dependence
on the preceding `nu,Psi` construction must not be dropped.

The full-vector version of `K_m` is legitimate: projecting vectors to sums
cannot increase the objective, and sampling each vector independently
conditional on its own sum and contexts gives a lift with equality.
Fresh auxiliary randomness in refinement is essential; substituting other
actual letters of a row would not preserve its prescribed iid marginal.

For `L_ER_GLUE`, Section 04 `entropy-refinement:gluing`, independently
couple an exact trial `U` and noisy `(m-1)`-block trial `Y,Gamma`. The
new trials `U+Y` and `U` with context `(U+Y,P)` have the required row
marginals. The entropy chain rule, conditioning, and the invertible map
`(U,Y) -> (U+Y,U)` give

```
K_m(W;r) + I_r(W') <= K_{m-1}(W;r) + I_r(W).
G_1(W)-G_1(W') = G_m(W)-G_{m-1}(W).
```

For the partial observation, retain an independent Bernoulli mark with
probability `zeta`. Synchronizing that mark across rows is allowed because
row couplings are arbitrary. Mixing the old and fully refined optimal
trials shows
`I_r(W^(zeta)) <= (1-zeta)I_r(W)+zeta I_r(W')`.
Thus actual decrease is **at least** the scaled full decrease; equality
is neither asserted nor needed. The one-letter entropy loss scales exactly.

For `L_ER_OFFER`, telescope the full offers separately from the same
current state. Failure of the target inequality gives
`sum d_m > tau` and `sum c_m = tau*p_j`, with nonnegative terms.
If `p_j>0`, the offers with `c_m>2*p_j*d_m` have total decrease less
than `tau/2`. Among at most `m_*` remaining offers one has
`d_m >= eta=tau/(2*m_*)` and `c_m <= 2*p_j*d_m`.
If `p_j=0`, all costs vanish and the same selection works. Marking this
observation with probability `x/d_m` supplies every `0<x<=eta`,
with actual decrease at least `x` and cost at most `2*p_j*x`.
This checks exactly the formal oracle hypothesis, including its zero-width
case and arbitrary overshoot.

## Provenance and remaining scope

The old independent support records are
`judgement-L_ER_CONTEXT-84c480baa150`,
`judgement-L_ER_GLUE-1d5e202d585a`,
`judgement-L_ER_OFFER-49c5f4ad68eb`,
and the assumption judgements
`judgement-A_CONTEXT_BOUNDS-243d18c5cbe1`,
`judgement-A_BLOCK_GLUE-43f61fd445dc`.
Their subject hashes match the respective v1 statements/assumptions.
The manuscript judgements record source paths, not historical source
hashes. We therefore reuse them as matching historical independent opinions,
not as cryptographic attestation of the manuscript bytes at judgement time.
The current measured source binding and direct argument reading supply the
present fidelity assessment. No new independent acceptance is fabricated.

`A_CONTEXT_BOUNDS` and `A_BLOCK_GLUE` remain explicit local unpublished
inputs to the manuscript transfer in the active review ledger. No DOI or
canonical proposition identifier was invented; the exact file revision and
labels are provided. Standard finite entropy identities are used as such.
The motivating Lee citation in Section 03 is not needed for this review's
argument, whose dual calculation is given locally.

These inputs are not Lean-verified and do not establish the full compression
or analytic chain. Their common-bound proof uses the earlier `nu,Psi`
construction; accepting that construction under the original compression
hypotheses is a separate scope issue described in the compression unit.
