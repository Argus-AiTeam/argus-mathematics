# Beyond search: thinning and common-phase extraction

**Assessment: partially supported.** The source supplies substantive
conditional arguments for thinning and extraction, but the old Argus
finite-search result is not a certificate for the full compression lemma.
This unit covers `L_ER_THINNING@1`, `L_ER_EXTRACTION@1` and
`C_ER_COMPRESSION@1`; none has an old supporting independent judgement
or a formal source of its own.

## Statement, hypotheses and attribution

The source is Sections 03 and 04 of the September 23, 2026 manuscript,
whose staged bytes match reference revision
`4eaee87548250b2682affda7d05d947c05554bae`. These are manuscript results
listed as open dependencies by Argus, not original Argus theorems.

`lemma:compression` fixes `D_0,P_0>=1`, a strictly positive probability
mass function `q` on the integers, an integer `g>0` and probability
`omega` on the circle with
`q(x)/q(0)=integral chi_{gx} d omega` and
`F_0=-log q(0)<=D_0*d`. A finite nonempty `S` satisfies
`log|nS|<=D_0*d*h^P_0*log d` for every integer `1<=n<=d^2`.
For `d/h^2<=E<=D_0*d`, every probability `lambda` on `S` satisfies
the displayed independent `T`-letter difference moment bound, at cost `E`.
The conclusion is one center `x_0 in S` and nonempty `S' subset S` with

```
log|S|-log|S'| <= C(D_0)*d^2/(E*h^2),
integral exp[-L*sum_x v(x)*(1-Re chi_{g(x-x_0)})] d omega >= exp(-C*E)
```

for **every** probability `v` on that same `S'`. The exponential constant
is numerical; the size constant may depend on `D_0` and the sufficiently
large threshold also on `P_0`.

The low-end lemma `entropy-foundations:thinning` / `eq:source-3` asserts
`K_m(W;r)<=C*E` for every finite refinement, provided
`m<=m_*`, `2*m*r<=T_0`, and `r<=T*exp(-w^2)/2`, with the particular
`nu,Psi` of `entropy-foundations:exchangeable`.

## What the actual thinning argument checks

Read Sections 03's `cost-rules`, `block-cost`, and the entire thinning
proof, not just its conclusion. Given the exchangeable-law bound, the
common submeasure of a short-block law `mu` and `Q=nu^m` has mass
`1-epsilon`, where `epsilon<=C*m_*sqrt(E)/T`. Tag each of `2r` blocks
using this submeasure. On `B>=r` tagged blocks, accept with probability
`B/(2r)` and select an ordered uniform `r`-tuple. The factor `B` cancels
the probability `1/B` that a given tagged block occupies a particular row.
The unnormalized accepted marginal `eta` therefore satisfies `eta<=Q`,
and its missing mass `delta` is at most `3*epsilon`.

This cancellation, not independence of the original blocks, justifies
completion by independent residual rows `(Q-eta)/delta`. Conditioning on
the **ordered selected indices**, not the whole tag pattern, costs at
most `log 2+r log(2r)`. The accepted contribution is weighted by its
acceptance probability; no division by a tiny conditional selection
probability is used. Convexity of the combined divergence-plus-noisy-
information cost permits forgetting those indices.

The residual cost is bounded by
`delta*r*log(1/delta)+delta*log|mrS|`; setting the residual error to zero
is admissible. The first term is at most `r/e`, the index entropy is
`o(d/h^2)`, and `delta<=d^(-1/2+o(1))` plus the sumset hypothesis makes
the last term `o(d/h^2)`. These estimates are uniform in admissible
`m,r`, with the allowed fixed-parameter threshold. The zero-residual case
is handled separately. Thus this is a real conditional proof mechanism,
not numerical evidence or an entropy realization supplied by Lean.

## What the extraction argument checks

Section 04, `Completion of the proof of lemma:compression`, first needs
both the low-end bound and the search conclusion to get the **high-end**
bound `K_m(W;r)<=C*E`, with `s=mr>=L`. The full-vector lifting lemma
is necessary to interpret this cost on all letters.

For a fixed whole context stack, the comparator product
`p=product nu_{w_i}` need not equal the true conditional one-letter
marginals. The source correctly uses relative entropy to that comparator,
not an unjustified assertion of conditional iid letters. Prescribed
unfrozen row marginals give the average frozen cost `<=C*E` and average
comparator divergence
`<=C(D_0)d^2/(E*h^2)`. Markov selection of one stack and then one
coordinate can pay both nonnegative quantities simultaneously.

At that stack the identity

```
C(w) = D((X^s,Gamma) || p*q) + H(Z) - F_0
```

and data processing give an independent noisy-sum atom of mass at least
`q(0)exp(-C*E)`. The characteristic representation gives a lower bound
for `integral product_i |phi_i|`. With
`A=sum_i(1-|phi_i|^2)`, the inequality
`product_i |phi_i| <= exp(-A/2)` selects one region of mass
`>=exp(-C*E)`, with mean defect `O(E)`. Selecting a coordinate,
then a center, and pruning letters with too large an individual averaged
defect gives a set of `mu`-mass at least `1/2`.
Binary data processing controls its cardinality. Jensen's inequality
and `L<=s` give the exponential bound for every later weight `v`.
Crucially the region, center and subset are chosen **before** `v`;
there is no interchange of these quantifiers.

## Concrete outstanding obligation

These conditional mechanisms are consistent with the literal conclusion;
no flaw in the manuscript is established. To upgrade the **full**
compression claim from the old audit's evidence, establish the particular
`nu,Psi` with all three `eq:source-2` bounds from the original
all-`lambda` moment hypothesis: the marginal-constrained Gibbs duality
in `entropy-foundations:variational`, preservation of the same error
under projection/conditioning, and the simultaneous prefix selection
producing the uniform short-block total-variation estimate. Then use that
same law, constants and full-vector cost throughout the thinning and
frozen-stack steps above.

That is a specific probabilistic/variational bridge, not an assertion
that a missing compiler file makes prose invalid. The present review
checks the downstream conditional calculations; it does not claim an
independently accepted reconstruction of the entire upstream construction.
The old finite proof contains none of those probability laws. The old
route `R_ER_COMPRESSION_CHAIN` is consequently a decomposition, not
evidence that its conjunction is discharged. Literary novelty is not
claimed or established, and the Fourier chain remains separate.
