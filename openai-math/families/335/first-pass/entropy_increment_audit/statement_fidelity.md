# Statement fidelity: weighted probability defect

The formal claim is `C_LEAN_WEIGHTED_DEFECT`, not the scalar-curvature theorem.
The principal declaration is
`OrderedEntropy.weighted_probability_defect` in `Main.lean`.
Its unqualified declaration name is `weighted_probability_defect`.
It quantifies over **every finite index type** and real-valued functions
`w`, `u`, `sigma`, and `v`. The weights are nonnegative and sum to one;
`u` is nonnegative and has weighted mean `b`.
The real parameters `m` and `eps` are nonnegative, `a >= 1/2`,
`0 <= lam <= 1/2`, `cp > 0`, and `0 < theta <= 1/16`.
For every index it assumes the identity
`v_i = a(sigma_i-1) + lam(u_i-b)`.

Its conclusion is

```
m eps sum_i w_i u_i max(1-sigma_i,0)
 <= cp eps [sum_i w_i v_i^2 + theta sum_i w_i(u_i-b)^2]
    + [m^2/(cp theta)] eps [b^2+sum_i w_i(u_i-b)^2].
```

For the manuscript substitute `w_i=nu_i`, `eps=epsilon`, `b=bar_u`,
`v_i=V_i`, `a=1/2+theta`, and `lam=1/2-2theta`.
Then `s_i=epsilon nu_i u_i`, and the left side is exactly
`m sum_i A_i^2 (1-sigma_i)_+`. The conclusion is the second line of
`eq:entropy-v-error`, with explicit constant `C_(cp)=1/cp`.
The first-line domination has constant 2, supplied by
`OrderedEntropy.defect_domination`.

The formal theorem does not impose a lower bound on positive weights, an
upper bound on `sigma_i`, or a bound on the index type's cardinality.
It even allows zero weights because it treats `u_i` and `sigma_i` as
already defined finite real numbers. This does **not** interpret the
manuscript's divisions at a zero weight: the manuscript omits those indices.
It also does not need `m=epsilon*b`, `sigma_i>=0`, or weighted mean
`sigma_i=1`; removing these assumptions makes the formal theorem stronger
and does not change its application to the manuscript.

Supporting declarations:

* `scalar_young` (`OrderedEntropy.scalar_young`) proves the scalar inequality by an explicit
  sum of three nonnegative squares, for arbitrary real `m,u,v,d`.
* `weighted_young` (`OrderedEntropy.weighted_young`) sums that inequality against arbitrary
  nonnegative finite weights.
* `probability_second_moment` (`OrderedEntropy.probability_second_moment`) proves the exact weighted
  second-moment/variance identity under the two stated sum identities.
* `defect_domination` (`OrderedEntropy.defect_domination`) gives the
  first-line positive-part estimate from the defining identity for `v`.

This source does not encode ordered matrices, graph-prescription existence,
the matrix reserve bound, logarithmic estimates, the coarse-region surplus,
or the main scalar-curvature inequality. Those are not certified by the
compiler outcome. The compiler checks the declarations above; the
correspondence in this document and the rest of `proof.md` still require
independent human mathematical review.
