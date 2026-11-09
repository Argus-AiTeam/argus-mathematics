# Statement fidelity: the oriented-interval transport core

The claim recorded for this source is `C_INTERVAL`, in context `CTX_PT`.
The principal declaration is `PartitionTransport.barrier_transport`.

Objects and quantifiers: `alpha` is an arbitrary linearly ordered type, not a
bounded list of sample coordinates. `marks` and `marks'` are arbitrary sets in
that type. `active` and `active'` are arbitrary predicates. The endpoints
`a,b` and tested point `x` are universally quantified. No finiteness,
generic-position, or distinct-vertex assumption is used.

`Consecutive marks p q` says that BOTH endpoints are in the marked set,
`p < q`, and there is no marked point strictly between them. The marked set
includes geometric square endpoints as well as field-selected points.
`Barrier marks active x` says that some such closed interval `[p,q]` contains
`x` and its INITIAL endpoint satisfies `active p`. It does not use `active q`.

Hypotheses of `barrier_transport`: `a,b` belong to the first marked set;
the two sets agree at EVERY point of the closed interval `[a,b]`; the
activation predicates agree at EVERY point of `[a,b)`; and `a < x < b`.
The endpoint hypotheses and closed-interval agreement imply that `a,b`
also belong to the second set. There is NO agreement hypothesis at `b`
for activation and NO constraint on marks or activation outside `[a,b]`.

Conclusion: membership of `x` in the two unions of activated consecutive
closed intervals is equivalent. This is pointwise equality on the entire
open chart interval, including interior marked points. Translation is
represented by pulling the destination data back to the same oriented
line parameter; it is not assumed to preserve a terminal endpoint's flag.

`consecutive_in_chart`, `consecutive_transfer`, and `barrier_transfer` are
the supporting declarations. They establish the clipping step and
transfer consecutive intervals without assuming their endpoints match
in advance.

Two further universally quantified real-number lemmas encode other
load-bearing steps of the same proof:

* `tangent_flag_of_entry`: if a defining affine inequality has value
  `d >= 0` at an endpoint and `d + t*s > 0` for some `t > 0`, then
  the lexicographic flag `(d,s,w)` is positive, for arbitrary `w`.
  Applied separately to every strict half-plane defining a convex chart,
  this proves that the positive tangent flag selects the chart entered.
  At a coincident boundary with `d=s=0` the entry hypothesis cannot hold;
  such lines do not enter the open chart.
* `inactive_cutoff_buffer`: for arbitrary real `N,Q,c,c'`, if `Q < N`,
  `abs(c'-c) <= Q`, and `abs(c') > 4*N`, then `abs(c) > 3*N`.
  This is the universal mismatch inequality, not a check at one value of N.

Limits: Lean does NOT formalize the polygon algebra, the geometric reduction
from chart crossings to endpoint hypotheses, lattice finiteness, the random
field law, probability estimates, amenability, or the main group theorem.
Those are not conclusions of this source. The full deterministic geometric
verification is the prose theorem in `transport_theorem.md`; the exact
Python fixtures exercise its reduction but do not replace its proof.
The host's independent Reviewer must check this interpretation and the
remaining prose geometry. Kernel compilation alone does not do that.
