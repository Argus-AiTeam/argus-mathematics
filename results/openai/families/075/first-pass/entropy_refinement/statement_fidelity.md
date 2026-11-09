# Statement fidelity: adaptive finite refinement

This document describes `EntropyRefinement.finite_search` and
`EntropyRefinement.manuscript_search` in `Main.lean`. It does not describe
a formal proof of the Fourier-convergence theorem.

## Objects and quantifiers

The type `S` is arbitrary, with an arbitrary preorder. In the entropy
application, `s <= v` must be interpreted as *finite further context
refinement*. The formal theorem constructs its result with finitely many
offer calls and finite inductions, and composes this relation using its
preorder laws.

`Model S` consists of a real accumulated cost `cost : S -> R` and real
coordinates `a`, `hi`, `lo : S -> Nat -> R`. All its fields are hypotheses:
cost is monotone in refinement; `a` is between zero and one, monotone
in its natural index, and antitone under refinement; endpoints satisfy
`0 <= lo <= hi <= 1`, are antitone under refinement, and obey
`hi(s,k) <= lo(s,j)` for `j < k`.

Every natural index is quantified. The manuscript's finite family can be
extended by `a=1`, `hi=lo=0`, and `good=true` beyond its final index;
the proved witness is before `N*q*n`, where the partition fits.

`good : S -> Nat -> Prop` is arbitrary and need not be stable under
further refinement. At every state and failed index, the offer hypothesis
quantifies **every** real `x` with `0<x<=eta` for a fixed `eta>0`.
It supplies a further state whose actual `a` decrease is at least `x`
and whose cost increment is at most `2*(hi-lo)*x`, with `hi-lo`
evaluated before that update. This is not an exact-decrease hypothesis.

## Universal theorem

`finite_search` universally quantifies real parameters
`a0,a1,d0,d1,u,eta,eps`, natural counts `n,q,N`, the model and predicate,
and the initial state. Its scalar hypotheses are exactly

    0<a0<a1, 0<=d0, 0<=d1, 0<u, 0<eta, 0<=eps<=1,
    1<=n*d0, 1<=N*d1, 1<q*u,
    d0*exp(2*u/a0)<=eps,
    (d1+eps)*((a1/(a1-a0))^q-1)<=1.

The natural counts are cast to reals in these inequalities. It concludes
that there are `v` and a **zero-based** `j<N*q*n` with `s<=v`,
`good v j`, and both cost bounds

    cost v-cost s <= 2*a1+2*a0,
    cost v-cost s <= 4*a1.

The proof includes the index loop (`index_aux`, `index_visit`), the exact
entry/exit telescope (`sweep_raw`, `ordered_sweep`), the subblock reduction
(`subblock_visit`), the reverse target telescope and implicit recurrence
(`reverse_macro_aux`, `reverse_macro`), and the macroblock/outer sweep
(`macro_visit`, `grouped`, `finite_search`).

No field asserts decreasing widths or telescoping widths at a fixed
state. The telescope uses upper endpoints at entry and lower endpoints
at exit. The index loop uses the permissible target
`min(eta, remaining actual decrease)`, rather than requiring the
manuscript's larger full-offer capacity; this is sufficient for its
existential proposition and permits arbitrary actual overshoots.

## Manuscript-parameter specialization

`manuscript_search` quantifies real `t,ell,eta` and natural `n,N,q`.
It assumes

    1<=t, 4<=exp(t), 5*t<=ell,
    (n:R)=exp(ell), (N:R)=exp(t),
    2*t^2<=(q:R)<=2*t^2+1, 0<eta.

It assumes the same model and offer contract and concludes discovery
before `N*q*n` at cost at most `4*(100000/(ell*t))`.
The proof verifies the scalar conditions for

    u=1/t^2, a0=100/(t^2*ell), a1=100000/(ell*t),
    d0=exp(-ell/2), d1=exp(-t/2), eps=exp(-2*ell/5).

`paper_scale`, `paper_ratio`, and `paper_geometric` prove the required
exponential and rational estimates. In particular, the geometric estimate
is for `q` continuing steps, not an assumed `1/u` step bound. The actual
manuscript has `t=log N`, `ell=log n`, `n>=N^5`, `N>=4`, and
`q=ceil(2*t^2)`, giving these hypotheses. These last identifications and
the floor/asymptotic partition estimates are explained in the report,
not encoded as a theorem about `d` in Lean.

## Unencoded entropy and analytic inputs

The intended substitution is `a=I_r/D_*`,
`hi=G_high/D_*`, `lo=G_low/D_*`, and
`cost=(E/D_*)*(G_1(empty)-G_1(W))/D_*`.
The predicate `good` is the exact noisy-cost inequality in Proposition
`entropy-refinement:search`. Positivity of `eta` and the offer contract
come from gluing and independent Bernoulli partial observations, not from
assuming the conclusion.

The source does not define Shannon entropy, the optimized contextual
costs, or Fourier partial sums. It does not prove that the manuscript's
entropy quantities satisfy the model or offer hypotheses. Those inputs
remain separately recorded and open to independent audit. It also does
not encode the final `4*a1<=C/h^2` asymptotic conversion. A successful
compile therefore certifies the universal combinatorial theorem and its
explicit scalar specialization, and nothing stronger.

All theorem proofs are present. There are no project-defined axioms,
proof holes, or deferred subproofs. The separate compiler record, not
this document, establishes the actual compiler result; independent
review is still needed for the fidelity of this interpretation and for
the transfer to the manuscript.
