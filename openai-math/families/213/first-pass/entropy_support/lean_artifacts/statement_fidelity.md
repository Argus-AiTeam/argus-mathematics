# Statement fidelity: universal weighted pooling core

The source `Main.lean` formalizes the finite weighted reconstruction and
budget-transport core used in Sections 1.3--1.5 of `report.md`. Its ledger
claim is `C_ENTROPY_POOLING`, not the original `C_ENTROPY` claim.
The declarations described here are `weighted_cauchy`, `node_budget`,
`budget_transfer`, and `entropy_budget_transfer`, all in namespace
`EntropySupport`.

`EntropySupport.weighted_cauchy` quantifies over any finite type G and
arbitrary real functions w,u,v on G, assuming only w is nonnegative.
It proves the weighted squared Cauchy--Schwarz inequality. In particular
there is no independence hypothesis relating the weights and biases.

`EntropySupport.node_budget` additionally quantifies over real q,b,C.
The hypotheses are q>=0, C>0, the exact reconstruction identity

    sum_g w_g u_g v_g = q b,

and the reconstruction-norm bound

    sum_g w_g u_g^2 <= C q.

It proves `q b^2/C <= sum_g w_g v_g^2`, including q=0.

`EntropySupport.budget_transfer` has arbitrary finite types H and G,
with w,u,v indexed by H and G and q,b,C indexed by H. It assumes
the preceding hypotheses separately for every h and sums the node
conclusions. There is no bound on either finite cardinality and no
positivity assumption on u,v,b.

For the concrete application, H is the finite set of positive-Q local
nodes, G can be the finite set of all permutation/global fresh nodes,
and w(h,g) is rho_g if node g is owned by h and zero otherwise.
The function v(h,g) is the bias conditioned on the full global prefix.
The function u(h,g) is the degree-(a_h-1) discrete reproducing kernel
evaluated at the current algorithm's rank. The rank-pooling identity
and polynomial reproducing identity give the exact reconstruction.
The freshness probability is at most one, so the kernel's squared
norm gives the norm bound with C=C(a_h,m). These identifications are
proved in the mathematical report, not encoded as decision trees
or assumed as independence in the formal source.

`EntropySupport.entropy_budget_transfer` additionally quantifies over
real p,D and real costs indexed by H. It assumes 0<p<1,
`p(1-p) cost(h) <= q(h)b(h)^2`, and a total global energy at most D/2.
It proves `sum_h cost(h)/C(h) <= D/(2p(1-p))`.
For the report, cost(h)=Q(h)d(r_h||p) and D=D(Q||mu).

The source does not define Bernoulli laws, relative entropy, query trees,
permutations, conditional expectations, polynomial degrees, or the
constant C(a,m). It does not formally prove that legal algorithms
supply its reconstruction and norm hypotheses, nor prove either
percolation theorem. Those are not conclusions of this Lean claim.
The universal mathematical entropy proof and interpolation application
remain the explicit proofs in the report, requiring independent review.
