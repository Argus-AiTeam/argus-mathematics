# Formal statement fidelity

The claim recorded for this source is **C_TWO_ENDS_FORMAL**, not the complete
operator-algebra bridge or the manuscript's final ZFC theorem.

Declarations: `twoEndedIdentity`, `twoEndedBound`, `productDecay`,
`minProductTendsto`, `rectangularMinDecay`, `transferCases`,
`longCoreRemains`.

`SelectiveBridge.twoEndedIdentity` quantifies over every (possibly
noncommutative) ring and arbitrary elements `p,w,d,e`. Its sole hypothesis is
`(1-p)*w*(1-p)=0`. It proves exactly the algebraic decomposition used at the
two ends of a centered free-product word. In the application, `p` is the
orthogonal projection onto module words starting with the second factor.

`SelectiveBridge.twoEndedBound` quantifies over every normed ring and the same
four elements. In addition it assumes `norm(1-p)<=1`; it does not assume the
desired norm estimate. It proves

    norm(d*w*e) <= norm(d*p)*norm(w)*norm(e)
                    + norm(d)*norm(w)*norm(p*e).

`SelectiveBridge.productDecay` quantifies over arbitrary index types, arbitrary
filters on them, and endpoint families bounded in norm by fixed nonnegative
real numbers. It assumes the two one-variable endpoint norms tend to zero and
the preceding complementary-corner hypotheses. Its conclusion is norm decay
on the **product filter**, not a diagonal sequence or iterated limit.

`SelectiveBridge.minProductTendsto` proves that `(n,t) -> min(n,t)` tends to
infinity on the product of the two natural-number tail filters.
`SelectiveBridge.rectangularMinDecay` composes any scalar null sequence with
that map. These justify the rectangular projection-excision tails.

`SelectiveBridge.transferCases` and `SelectiveBridge.longCoreRemains`
quantify over all natural word lengths, not a bounded enumeration. They
partition the possible empty-core cases when at most two outer letters are
transferred. They do not model operators or prove that a transfer is valid.

The source does **not** formalize amalgamated free products, pure states,
excision, the endpoint expectation estimate, or the boundary-symbol theorem.
Those analytic hypotheses and their application are proved in `report.md`
and require independent mathematical review. In particular the compiler
certificate for this source must never be reported as a kernel proof of
`C_BRIDGE_DECAY` or `C_BOUNDARY_SYMBOL`.
