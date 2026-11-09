# Statement fidelity: C86_PACKING_CORE

`Main.lean` formalizes the universal **algebraic packing core**, not the
complete sparse-count theorem or the trilinear Hilbert transform.
All declarations are in namespace `SparseCount`. There are no additional
axioms, finite-search assumptions, or oracle results.

The dimension `d` is any natural number, including zero.
`Bounded K n` means every coordinate of the integer vector `n : Fin d -> Z`
has absolute value at most the integer `K`.
The shift map `f : (Fin d -> Z) ->+ R` is any additive group homomorphism.
`dotShift zeta` constructs the manuscript's map `n |-> sum_i n_i*zeta_i`,
so the general homomorphism quantifier includes all real frequencies.

`Near f K E x` means there exists an integer vector of coordinate bound
`K` for which `|x+f(n)| <= E`. The sign is immaterial for the symmetric
neighborhoods in the manuscript. A manuscript neighborhood `U_i(t)` is
contained in this predicate with `K=6*t*N_0` and `E=t*epsilon_i`.
`bounded_add`, `bounded_neg`, `bounded_sub`, `near_zero`, `Near.add`,
`Near.neg`, and `Near.sub` prove the required neighborhood arithmetic.
They do not require injectivity or rational independence of the shift map.

`anchor_sums_separated` quantifies arbitrary real sets `A,P`, arbitrary
local center `c`, integer index budgets `Q,Kb,Kl`, real scalar budgets
`S,Eb,El`, and an arbitrary exact collision predicate `V : R -> Prop`.
It assumes:

1. `V x` implies `Near f Kb Eb x`;
2. `Kb+Kl+Kl <= Q` and `Eb+El+El <= S`;
3. each `p` in `P` satisfies `Near f Kl El (p-c)`;
4. distinct anchors `a,a'` are separated by strictly more than `S` modulo
   every shift bounded by `Q`;
5. distinct `p,p'` in `P` do not satisfy `V (p-p')`.

Its conclusion is that any indexed sums `a+p,a'+p'` whose difference
satisfies `V` have both equal anchors and equal packing points.
This proves separation and index injectivity, not merely distinctness
of an unindexed sumset. In the application `V x` is membership in the
exact manuscript neighborhood `U_3(2H_3)`. Only the inclusion of that
neighborhood in `Near` is used: a packing outside `U_3(2H_3)` is not
silently assumed to be a packing outside the larger all-shift predicate.
This distinction retains the lattice factor 6 and the scalar grid.
`anchor_sum_card` then proves the exact finite
cardinality identity `|image(add, A x P)|=|A|*|P|` from this injectivity
condition. Equal sums satisfy `V 0` because zero belongs to the exact
manuscript neighborhood. The separate helper `near_zero` proves the
corresponding fact for `Near` with nonnegative budgets.
The finite combinatorial proof in `proof.md` supplies the global packing
bound on `3B_3`; Lean does not assume or prove that entire proof.

`annular_not_near` quantifies arbitrary dimension and shift homomorphism,
positive real `mu,R`, real `nu` with `mu <= nu`, a dominant real residual
`big`, other residual sum `small`, raw linear form `raw`, integer witness
`n0`, and budgets. It assumes
`mu*R <= |big| <= nu*R`, `|small| <= mu*R/100`,
`E <= mu*R/100`, the exact relation
`raw+f(n0)=big+small`, index reserves `Kw+Kb <= Q`, and the pure-shift
gap excluding `[mu*R/100,100*nu*R]` for every shift bounded by `Q`.
It concludes `not (Near f Kb E raw)`.
This is the cross-translation contradiction, with arbitrary residual signs.
The weaker gap compared with the original manuscript is intentional:
the proof's real-to-grid reduction retains this narrower gap.
This theorem does not prove that the manuscript frequency tests meet the
five hypotheses; that remains the separate open claim `C86_THIN_INPUTS`.

`auxiliary_balance` proves the polynomial identity for the substitution
`delta=x^810, alpha=x^2, kappa=x^3`, namely
`alpha^4*kappa^24*x=x^81`.
`growth_exponent_margin` proves
`8D+2D^2 < 50D^2` for every integer `D>=1`, the exponent comparison in
the small-growth-scale argument. These are supporting algebraic facts,
not formalizations of the full density estimate.

The passage from the five hypotheses to the numerical budgets, the graph
and block arguments, minimal-growth proof, maximal-packing constructions,
and real-data approximation are proved in `proof.md` and require human
independent review. `verify.py` additionally replays all displayed
quantitative budgets and the actual Jacobian LP primal/dual certificate.
A zero-hole compiler verdict on this file must not be relabeled as a
kernel proof of `C86_SPARSE_EXPLICIT`.
