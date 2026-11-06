# Common-sample tree reduction

The target is the original `lem:reduction` in `sections/trees.tex`, not a
conditional recurrence or a finite family of examples. Its input is an
arbitrary finite, equal-depth, indexed probability tree. Child weights are
positive and sum to one. Labels may be empty, have unequal sizes, or repeat
on different arcs. Labels need only be disjoint along each full path;
incomparable subtrees may reuse coordinates.

At level j, the capacity m_j is a positive integer,
m_(j+1) >= 16 m_j, and the child laws are alpha_j-spread, where
0 < alpha_j <= a and rho = exp(50) a < 1. The requested conclusion is a
deterministic successful output for at least 3/4 of Bernoulli-rho samples:
the same number of levels, capacities floor(m_j/2), spread
alpha_j/(1-exp(-m_j)), and recovery of an original full path from every
output full path by adjoining the one common sample.

## Primary-source scope

A separate primary-source reader obtained the following passages before
implementation. These are method ancestry, not assumptions granting the
tree reduction.

* Mossel, Niles-Weed, Sun, and Zadik, *A Bayesian proof of the spread
  lemma*, Random Structures & Algorithms 66 (2025), e70008,
  DOI `10.1002/rsa.70008`, Sections 2.1--2.3. The final published text was
  obtained from the MIT repository (the Wiley endpoint returned HTTP 403).
  Section 2.2, proof of Lemma 1, gives the posterior proportional to
  pi(B) rho^(-|B|) 1(B subset Y). Section 2.1 gives the unconditional
  target marginal and A' minus W subset A intersect A'. Theorem 2 permits
  nonuniform sizes and empty sets, with normalized expected fragment bound
  7(alpha/rho)^(1/3). None of these passages states the arbitrary-tree,
  one-common-sample reduction.
  Published source:
  <https://dspace.mit.edu/server/api/core/bitstreams/8a515ab1-dde1-4828-8fa7-8fef96f6cc88/content>.
* Tran, `arxiv:2609.20546v2`, Section 3, Lemma 3.1
  (`kkc2_v3.tex`, lines 379--405, proof lines 423--434): with
  a = 64 e q_H < 1, maximizing normalized containment produces a core
  smaller than |F|/64 when the law is not a-spread, and the conditional
  added-edge law is a-spread. Lemmas 3.2--3.3 concern nested uniform
  graph copies. Section 4, Conjecture 4.1 (lines 535--549), proposes a
  coupling to absorb a spread set into product noise. Proposition 4.4
  (lines 618--648) assumes that conjecture. This is not an unconditional
  general probability-tree reduction.
  Source: <https://arxiv.org/src/2609.20546v2>.
* Mossel, Niles-Weed, Sun, and Zadik, `arxiv:2209.03326v1`, Equation (5)
  (`Finding_the_threshold-rev4.tex`, lines 291--298), gives the
  ordinary-copy ratio M_(J,H)/M_J by symmetry. It supports the graph
  copy-count identity, not common-sample dependence.
  Source: <https://arxiv.org/html/2209.03326v1#S2.E5>.

No claim of literature-wide novelty follows from this bounded source read.
The manuscript main theorem, iteration, and graph hierarchy are recorded
as separate open claims. Certifying the reduction does not certify them.

## Dependence that must actually be proved

The input tree stays fixed when defining its local masses and potentials.
For each fixed child b, every descendant label avoids A_b. Therefore the
entire descendant potential is a function of coordinates outside A_b.
This is a fixed-input measurability statement, not an independence claim
after selection or pruning.

At fixed W the source has its prior child law, but the target generally
does not. For example, with two equally weighted singleton labels x and y,
rho=1/2, and W={x}, the target probabilities are 3/4 and 1/4. The route
that replaces a fixed-W target marginal by its prior is invalid; this is
not an assertion made by the staged manuscript.

For the actual transition, the outside-label distortion bound controls
E[t_vb(W) D_b(W)] by exp(11 m_s) nu_v(b) E[D_b(W)].
Together with the local failure bound and the factor exp(m_s) in the
potential, it gives the manuscript's expected-potential recurrence.
There is no independence between levels, no independent sample per node,
and no full-path spread assumption in this argument.

## Universal verification and a structural strengthening

The independently authored formal source proves the original reduction as
`TreeReduction.pathwise_reduction`. It also proves
`TreeReduction.pathwise_three_reduction`: **the capacity separation can be
3 instead of 16**, without changing the sampling density, success probability,
capacity halving, spread inflation, or recovery conclusion.
This is a universal extension of the staged reduction, not a reconstruction
of a graph example or an isolated numerical inequality. Its significance and
novelty still require independent adjudication.

The official Lean 4.31.0 run returned **exit_code=0, proof_holes=[]** and
recorded `C_TREE_REDUCTION` version 2 as `closed_kernel`, with no outstanding
assumptions. Its immutable archive is
`certificates/C_TREE_REDUCTION-c419892233c8de30.json`.
Every audited declaration depends only on `propext`, `Classical.choice`,
and `Quot.sound`. Neither the expected recurrence nor an output-existence
assertion is a premise of the principal theorem. The proof graph remains
open for independent review; the Engineer has not set any Reviewer flag.

The strongest prior result in the staged manuscript is the factor-16
reduction with a sum-of-exponentials potential bound. The present proof
closes the actual indexed-kernel and common-sample dependencies and establishes
the simpler, uniform bound

    E[D_v] <= exp(-7 m_s)

at every non-leaf node, already under factor-3 separation.

### Indexed planting and the local estimates

For a source c of weight nu_c and Y = W union A_c, exact product
integration gives its joint density

    nu_c rho^(-|A_c|) 1(A_c subset Y).

Summing over the actual indices gives Z(Y), so division by Z(Y) is the
posterior on those indices, even when labels repeat or are empty or unequal.
The source itself certifies Z(Y)>0 at every planted union. The formal lemmas
`indexed_plant_density`, `planted_density`, and `joint_source` derive these
facts from the product law, rather than assuming a kernel with the desired
marginals.

For a fixed target label A_b, put R=|A_c intersect A_b|. The finite
subset expansion proves, for q>=1,

    E_c[q^R]
      = sum_(J subset A_b) (q-1)^|J| P(J subset A_c)
      <= (1 + alpha(q-1))^|A_b|.

With q=1/rho this is at most exp(m). With q=exp(50)/rho it is at most
2^m. The latter tilt bounds the contribution with 2R>m by
exp(-25m) 2^m. The planted density bounds the small-denominator event by
exp(-10m); the other failure contribution is at most
exp(10m) exp(-25m) 2^m <= exp(-14m).
For positive integer m their sum is at most exp(-9m).
These are `moment_bound`, `tail_moment`, and `local_failure`.

For arbitrary nonnegative f invariant under changes inside A_b, the condition
A_b minus A_c subset W involves only coordinates inside A_b. Direct product
factorization therefore gives

    E[1(target=b, Z>=exp(-10m)) f(W)]
      <= exp(10m) nu_b E[f(W)] E_c[rho^(-R)]
      <= exp(11m) nu_b E[f(W)].

This is `distortion`; it does not assert a fixed-W prior target marginal.

### One common sample and the potential

`treeDisjoint_iff_pathwise` proves that the recursive avoidance condition used
in the formal proof is equivalent to pairwise disjointness along all full
paths. It uses positivity and normalization of the child laws to show every
subtree has a full path. In particular, avoidance of the incoming label
throughout a child subtree is derived from the manuscript hypothesis, not
silently added.

The local masses inspect only the union of that fixed node's child labels.
Recursive coordinate invariance proves `potential_avoids`: D_b ignores the
incoming label A_b, before any selection or conditioning. Applying the
outside-label estimate to this actual nonnegative potential yields
`expected_recurrence`,

    E[D_v] <= exp(-8m_s) + exp(12m_s) sum_b nu_v(b) E[D_b].

No independence between levels, disjointness of incomparable branches, or
spread of full paths is used. Under m_(s+1)>=3m_s, backward induction gives

    E[D_v] <= exp(-8m_s) + exp(12m_s-7m_(s+1))
             <= 2 exp(-8m_s) <= exp(-7m_s).

Leaves have potential zero. A bad node has D_v>1 by local normalization and
the actual recursive goodness threshold. Thus the probability of a bad root
is at most exp(-7m_1)<1/4.

### Deterministic output

At a good node, gamma_v is the sum of non-failure target masses over good
children, and gamma_v>=1-exp(-m_j)>0. `reduce` retains exactly the good
children of positive target mass, with their original distinct indices,
weights t_vb/gamma_v, and labels A_b minus W. The same W is passed recursively.

`retainedLaw` proves positive normalized child weights, so depth is unchanged.
`mass_capacity` proves the floor(m_j/2) capacity bound.
`reduced_disjoint` and `reduced_recovery` prove pathwise disjointness and
full-path recovery through the original target histories.
Finally, `mass_spread_raw` compares the fragment to its source at fixed W.
For nonempty J its conditional probability is at most

    alpha_j^|J| / gamma_v
      <= alpha_j^|J| / (1-exp(-m_j))
      <= (alpha_j/(1-exp(-m_j)))^|J|.

The empty-set constraint is normalization. All of these properties are
conclusions of the formal development, not premises of its final theorem.
`procedure` is an explicit deterministic mathematical function of W; no
auxiliary source or target sampling is performed by that function.

## Exact replay and its scope

`verify.py` uses rational arithmetic to exhaust all samples of two explicit
depth-two trees with capacities (1,16) and (1,3), on 11 and 5 coordinates.
The child laws include empty and repeated singleton labels and a larger label.
Different equal-label histories have different continuations; incomparable
branches share coordinates. Descendant failure potentials are nonzero.
The script checks every input hypothesis, actual posterior/source masses,
planted densities, outside-label atom domination, local failure, fixed-input
potential invariance, pruning, recovery, capacity, and spread.
It represents the finite potentials exactly as polynomials in e with rational
coefficients.

The examples use rho=1/2, alpha=10^(-24), and a=rho exp(-50).
The exact bounds 8/3<e<11/4 certify alpha<=a and every exponential comparison.
For the upper bound, sum the exponential series through degree 5 and bound
the remaining terms by (1/6!)/(1-1/7); for j>=0,
(6+j)!>=6! 7^j. The lower bound is the degree-3 sum.
Enumeration is explicitly a finite stress test; it is **not** the evidence
for universality.

The preserved Jacobian operation
`probability.finite_distribution.condition.compute` conditions six rational
source/sample atoms for labels empty, {x}, {x}, with source weights
1/2,1/4,1/4. The planted union is {x} on an event of mass 3/4; its
conditional atom masses are 1/3,1/6,1/6,1/6,1/6. The payload and typed output
are in dedicated JSON files, including server version and protocol.
`verify.py` independently replays that exact calculation. This bounded tool
result supplies no universal mathematical conclusion.

The default script invocation also performs the real, claim-bound Lean
4.31.0 compilation and both official campaign-local checks. The final compiler
record is `lean_check.json`, with the claim-specific archive reported by
`math_state show --claim C_TREE_REDUCTION`. The CLI installed on this host
takes its source as a positional argument, rather than the older `--source`
spelling.

The first durable replay completed both finite cases and the saved Jacobian
check, then obtained a successful compiler result whose ledger registration
was refused: the claim still carried its pre-development formal text.
The claim was restated against the finished source. The three stale goal
references reported by the checker were refreshed without changing the
natural statement, route obligations, or the retired shortcut's reason.
A fresh compiler-only feedback run then attached the real certificate and
returned zero for both campaign-local checks. The unchanged finite
computations were not repeated, and no mathematical source or fidelity text
was changed during either compiler run.

A subsequent fidelity clarification replaces the ambiguous phrase "empty output
levels" by "levels consisting only of empty labels"; non-leaf nodes always
retain nonempty positive child laws. The mathematical source was unchanged.
As required, a fresh official run bound that clarified document to the proof
and retired the previous reading's certificate. The final archive above is
the replacement, not the retired certificate.

## Remaining dependencies and review

No literal assertion in the staged manuscript was refuted. The fixed-W prior
target shortcut above is expressly rejected by the manuscript, not an erratum
to it. Accordingly, no artificial F_ claim is created.

The original iteration, tree-covering theorem, graph hierarchy, and main
graph-threshold theorem remain separately open in the campaign ledger and
proof graph. The core proof is self-contained relative to Mathlib and does
not assume any external cited theorem. The primary-source ancestry claim is
separate; its citation attribution and the final significance/novelty judgement
remain for independent review.

Specifically, `citation_check status` still lists `MNSZ_BAYES`, `MNSZ_COPY`,
and `TRAN_CORE` on `C_PRIOR_METHODS` as unchecked. Their initial independent
reader's findings above are not substituted for the required attributed
source excerpts. This does not make them dependencies of the kernel proof.

The compiler checks encoded mathematics, not statement fidelity or novelty.
The independent Reviewer must inspect `statement-fidelity.md`, replay the
certificate, and judge those questions before campaign acceptance.
