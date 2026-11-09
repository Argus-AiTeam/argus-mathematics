# Fixed-seed refinement and error-sensitive oracle transfer

The target is Theorem `thm:refinement` in
`research/openai_manuscript/An-Almost-Linear-Approximation-Scheme-for-Edit-Distance-September-24-2026/build/sections/04-cones.tex`.
It is a statement about **every fixed complete good integer seed**, not about
an average over initial seed randomness.

## Objects and quantifiers

The strings, labeled interval tree, valid integer endpoint pairs, and all
large-input parameters are those of `02-geometry.tex`. In particular,
`ell >= 2^1000`, `F = ell`, `L0 = 32 F`, and `L = 128 F`. At each state,
`c(I,q)` is ordinary unit-cost edit distance and
`z(I,q) = (q+ - q-) - |I|`.

The factor `A` is a power of two in `[1,A_init]`. A supplied integer table
on the entire state domain must satisfy

```
0 <= U(I,q) <= N,     c(I,q) <= U(I,q) <= A c(I,q).
```

Set `a = max(1,A/F)`. The constructed table must obey, for each state,

```
d_S(I,q) >= c(I,q)/a                         for every outcome;
E[max(d_S(I,q)-c(I,q),0) | the fixed U] <= c(I,q)/ell;
c(I,q) = 0  =>  d_S(I,q) = 0                for every outcome.
```

The expectation is over fresh refinement streams only. A counterexample
to this theorem must meet the large-input cutoff and all seed bounds.
A smaller local model cannot be called a counterexample to this theorem
unless it is embedded into the manuscript's actual construction.

## Dependency boundary

The lower and zero-cost clauses use initial cones, Bellman preservation,
and Lemma `lem:refinement-invariants` (`04-cones.tex`, `05-bands.tex`).
The excess clause additionally uses the fixed comparison tree and
comparison-band coverage (`06-comparison.tex`), the fixed-block entropy
bound, group accuracy, and the complete-child-table first crossing
(`07-regret.tex`), followed by the tree/time telescope and parameter
estimate (`08-accuracy.tex`). Finite numerical mixtures and the lazy keyed
randomness model are additional obligations (`09-numerics.tex`,
`10-work.tex`).

Conditioning on a fixed good seed is not the same operation as
conditioning a refinement stream on its own success. Within a pass,
the claimed independence is that complete tables at strict descendants
are measurable without the current parent's fresh keyed streams.
No independence between different child tables is claimed or needed.

## Pinned upstream evidence

The source investigation used `openai/math` commit
`4eaee87548250b2682affda7d05d947c05554bae`, not a moving branch.

* `lean/OAI/Combinatorics/EditApproximation/AlmostLinear.lean`, lines
  20-42, states accuracy of the particular final algorithm with
  probability at least `2/3`; it does not universally quantify over an
  externally supplied good seed.
* `AlmostLinearConditional.lean`, lines 18-46, exposes Bernstein inputs.
  `AlmostLinear.lean`, lines 13-18, supplies them. The word
  "conditional" alone is therefore not evidence of a circular proof.
* `Geometry/NodeRegret.lean`, lines 18-48, proves a deterministic
  first-crossing transfer from antitone band costs, a uniform group
  inequality, online/cone wiring, and coarse clipped bounds. Its
  conclusion is comparative accumulated regret, not final positive
  excess.
* `Geometry/FirstCrossing.lean`, lines 18-81, defines the crossing using
  the **whole** fixed band-cost table, not a sampled action. Once the
  complete child environment is fixed, its prefix is deterministic.
* `Refinement/PhysicalConditionalNode.lean`, lines 27-93, does quantify
  over arbitrary good natural-number seed tables. It proves local
  expected comparative regret under explicit fixed-deeper-environment,
  parent-wiring, numerical, and Bernstein hypotheses. Lines 94-155
  implement the first-crossing proof. This is a relevant proof idea,
  not a substitute for checking the full refinement guarantee.

Immutable source links have the common prefix
`https://github.com/openai/math/blob/4eaee87548250b2682affda7d05d947c05554bae/`.
No upstream theorem or external concentration theorem has yet been
imported as an unproved assumption into a claimed verification.
The project Wiki index search supplied no refinement-specific prior
result. The prior campaign ledger contained only the root audit goal
and no mathematical evidence.

The narrower subsequent lookup found a stronger prior result:
`Refinement/PhysicalProgramStateAccuracy.lean`, lines 28-63, explicitly
states `physicalProgram_expected_state_excess` for arbitrary good
natural-number seed tables, arbitrary rational `1 <= A <= initialFactor`,
and every physical state. There is no `U <= N` premise. Its Bernstein
argument is supplied by the separately proved `finiteBernsteinInput` in
`Probability/BernsteinFinite.lean`, lines 66-84. Thus merely reproducing
arbitrary-fixed-seed expected excess is not a new mathematical result.
Neither lookup compiled or certified that upstream dependency closure.

The independent extension proved below is an error-sensitive
first-crossing theorem: replace a uniform group-success event and a
deterministic coarse cap by the actual positive oracle overshoot, and
charge its first moment. This is a stronger transfer statement, not an
assertion that the manuscript is false. Its application uses the actual
band's entropy bound and comparison-tree geometry, derived below, not an
assumed final-accuracy interface.

The small two-outcome oracle model used to replay a first moment has
`S=1`, one action, `c=1`, `delta=1/10`, `kappa=1/4`,
`A_0=57/50`, `A_1=Y_1=B_1=1`. The two equally likely cone values are
`11/10` and `57/50`. Relative to
`(1+delta) A_1 + kappa delta c = 9/8`, their positive overshoots are
`0` and `3/200`. This is an example of the generalized oracle model,
**not** an edit-string counterexample or a finite verification of
Theorem `thm:refinement`.

## The error-sensitive refinement theorem

Keep the fixed good seed, warmup, bands, genuine action costs, whole-cell
caching, and clipped update of sections 04-05. Allow the group selectors
to have arbitrary joint laws, including correlation with the online
draws and with other times, provided that the conditional marginal of
each online draw, given the complete child tables, is the prescribed
finite mixture. The law must be well founded by node height. For an
algorithmic version, use exactly sampled finite rational kernels.
No new oracle is permitted to return a fabricated action cost.

Fix a starting state with true cost `D>0` and its deterministic comparison
tree. Let `G` be its non-bad, velocity-passing nonterminals. At `v in G`,
write, with the manuscript's notation,

```
A[v,t,alpha] = L e_v + sum_i d_t(I_i,s_i(alpha)),
B[v,t]       = L e_v + sum_i max(c_i,d_t(I_i,q_i)),
m[v,t]       = min_{alpha in C_v} A[v,t,alpha],
xi[v,t]      = max(Pi_t(I_v,q_v)
                  - (1+delta) m[v,t] - kappa delta c_v, 0),
Defect       = (1/S) sum_{v in G} sum_{t=1}^S E[xi[v,t]].
```

These are operational cone/action quantities, not the final answer or
its error. In particular `xi` does not assume any accuracy conclusion.
Define

```
E0 = (8 M + 512 F) J/P
   + 40000 F^2 H^(1/4) (1+J/P+J/T)/S
   + (2 J/S) [H^(-1/4) + 4 tau F
       + 64 F (4 (p_*+21) ell/eta + 2 kappa) + 2 delta]
   + 128 F J H^(-3).
```

**Theorem.** Under the preceding hypotheses,

```
d_S >= c/a,                c=0 => d_S=0,
E[(d_S(root)-D)+] <= E0 D + Defect.
```

With the actual large-input parameters, `E0 <= 5/(8 ell)`. Consequently
the original `D/ell` accuracy remains valid for every such group law
satisfying `Defect <= 3 D/(8 ell)`. This is an L1 oracle-quality
condition, not a simultaneous-success event or an independence
condition on group failures.

For the manuscript's particular selector,

```
Defect <= 4 F J D H^(-4) <= 400 D H^(-3) <= D/(8 ell).
```

Thus its fixed-seed expected excess is in fact bounded here by
`3 D/(4 ell)`, a conservative allocation of the available slack.
This last coefficient is not claimed to be an optimized constant.

The improvement over the inspected upstream `NodeRegret` interface is
precise: the transfer no longer needs `max(c,d_t) <= 2 F c` or Boolean
group-failure events as hypotheses. It uses the minimal nonnegative
additive oracle overshoot and its first moment. The coarse cap is used
only when specializing to the manuscript's failure-probability bound.
The existing arbitrary-fixed-seed result is not claimed as new.
Publication-level novelty of this error-sensitive extension still
requires independent assessment; the source lookup was not a
comprehensive novelty search.

## Proof of the error-sensitive transfer

Condition on complete child tables at one non-bad velocity-passing
comparison node. All action histories below are then deterministic.
Use zero-based time in this paragraph, so current costs are `A[t+1]`.
Let `s_t` be the sampled online action, `p_t=Pi_{t+1}`, and let `y_t`
be the actual online minimum. Then

```
A[t+1,alpha] <= A[t,alpha],
p_t <= A[t,alpha]                           for every alpha,
y_t <= A[t+1,s_t],
B_t >= c,
p_t <= (1+delta) A[t+1,alpha]
       + kappa delta c + xi_t                for every alpha.
```

The last line follows from the definition of the band minimum; `xi_t`
is the smallest nonnegative error for which it can hold simultaneously
for every band action. This minimality follows by testing a minimizing
action. `oracleDefect_upper` and `oracleDefect_minimal` formalize both
directions.

Let `q` be the first time at which some band action has current cost
strictly below `c`, or `S` if no such time exists. Before `q`, every
current action cost is at least `c`. Put `u=A[t+1,s_t]`,
`v=A[t,s_t]`, and
`d=min(p,max(p/(1+delta),y))`.
If `d<=u`, monotonicity and `xi>=0` give

```
max(c,d) <= u + kappa (v-u) + xi.
```

Otherwise `y<=u<d` forces `d<=p/(1+delta)` and
`u<p/(1+delta)`. Together with `p<=v`, this gives
`v-u>delta u>=delta c`. The soft group inequality gives

```
p <= (1+delta)u + kappa delta c + xi
  <= (1+delta) [u + kappa(v-u) + xi].
```

Division by `1+delta>0` proves the same bound. This is
`prefix_step`. No bound on `p` by a coarse multiple of `c` was used.

At the crossing, a witnessing action has current cost below `c`, so

```
max(c,d)-B <= (1+kappa) delta c + xi.
```

After the crossing, that same action's previous-index cost stays below
`c`. The Bellman option forces `d<c`, hence `max(c,d)-B<=0`.
These are `crossing_step` and `after_step`.
The existence and minimality of the first crossing are proved in Lean
from the bounded set of time labels; no stopping-time independence
assumption is hidden in its definition.

Summing the three phases gives the sharper deterministic theorem
`firstCrossing_defect_sum`:

```
sum_t [max(c,d_{t+1})-B_t]
 <= sum_{t<q} [A[t+1,s_t]+kappa(A[t,s_t]-A[t+1,s_t])-B_t]
    + 1_{q<S}(1+kappa)delta c + sum_t xi_t.
```

For `0<=kappa<=1`, the crossing charge is at most `2 delta c`.
Taking any normalized finite weighted expectation proves
`expected_firstCrossing_defect`. Neither the defects, the online
actions, nor their time coordinates are assumed independent.
The prefix `t<q` is fixed after child-table conditioning. Its expected
augmented action regret, rather than the parent regret or final excess,
is the only online-learning input.

## Discharging the construction-specific inputs

### Geometry, seed, and deterministic invariants

Changing the target endpoints costs at most their L1 distance:
delete/insert endpoint portions, or the whole substrings when they are
disjoint. Thus `c` and `|z|` are 1-Lipschitz and `c>=|z|`.
Concatenating independently chosen child targets costs their edit
costs plus the gaps/overlaps connection charge. One proof is to
traverse their target intervals and connecting jumps on the boundary
line, retaining one forward crossing of every unit edge of the
parent target. All backward crossings come from paid connecting
jumps; they pay for deletions of unretained child letters. The
remaining forward connecting crossings pay for inserted letters.
The signed displacement identity proves the parallel inequality
for `|z|`.

For `a=max(1,A/F)`, `A/a<=F`. Since `Fc` is an integer,
`ceil(U/a)<=Fc`. Thus the scaled seed lies between
`max(c/a,|z|)` and `Fc`. Every initial cone preserves these lower
bounds. At a positive-cost state choose `b<=c<2b`; rounding both
endpoints moves them by less than `2b/P`, so the rounded center
has cost in `[b/2,4b]` and is eligible. Its cone value is at most
`Fc+66Fb/P<=2Fc`. At zero cost, its own zero cone attains zero.
This also proves the local-rule/global-envelope identity: any
competitive center is within `c/16`, has cost in
`[15c/16,17c/16]`, and therefore lies in the displayed initial
local scale and radius ranges.

The Bellman operator is monotone, contains `w0`, and preserves
`max(c/a,|z|)` by the two connection inequalities. Its iterates
decrease, and `B(d0)<=d0`. Each warmup cone is L-Lipschitz.
Every extra group and online option is a genuine current-child
wide-action cone. Hence

```
B_I(d_t) <= Pi_t, Y_t,      Pi_t <= B_I(d_{t-1}),
B_I(d_t) <= d_t <= B_I(d_{t-1}) <= d_{t-1}.
```

This proves the lower bound without incorrectly relying on
`Pi/(1+delta)` alone. The zero branch is exactly zero.
For spatial regularity, the fixed whole-cell choices make `Pi`
a minimum of L-cones. Since
`Pi/(1+delta)<=d_t<=Pi`, it follows that
`d_t(q)<=(1+delta)d_t(q')+L|q-q'|_1`.
The scalar lower, zero, floor, and spatial implications appear as
`update_lower`, `update_zero`, `update_floor`, and `update_spatial`
in Lean. Leaves use exact costs.

### Comparison geometry and bands

At a positive comparison state, round its endpoints to scale `b`,
take an exact optimal path there, split it at child cuts, and round
the internal target anchors to the same grid. The action has shared
endpoints, zero connection charge, and shift radius below `6b`.
Writing `c_i` for its child costs and `e` for the outside rounding,

```
e <= 2c/P,     c(r) <= sum_i c_i <= (1+4M/P)c,
c <= Le+sum_i c_i.
```

Carrying stopped costs forward at each level shows that every
frontier costs at most `2D`, terminal costs at most
`(1+8MJ/P)D`, total nonterminal cost at most `2JD`, and total
outside rounding at most `4JD/P`. This uses
`(1+4M/P)^J<=1+8MJ/P` when `4MJ/P<=1/2`.
All comparison choices depend only on the strings, not the
refinement randomness.

For completeness, the band-coverage estimate does not assume
additive warmup masses. Put

```
W=sum_i m_i,  G=W-Z>=0,  R=m(q)-W,
K=sum_i z_i^2/m_i-z(r)^2/W,
h=Le+w0(q)/T.
```

Use `0/0=0`; zero child masses have zero shift. Averaging the
warmup inequalities gives `R+G<=h`. Cancellation of masses over
the comparison tree gives
`sum R_- <= sum h + C_term` and therefore
`sum G<=C_term+2 sum h`.
The weighted variance identity is

```
K = sum_{m_i>0} (z_i-(z(r)/W)m_i)^2/m_i >=0.
```

For energy `E=z^2/m`, the outside rounding and
`|z(r)|<=min(W,2m(q))` imply

```
K <= sum_i E_i-E_q+3e+2R_-.
```

Indeed subtract the two parent energy fractions, split their
numerator difference from their denominator difference, bound the
first by `3e`, and bound a positive denominator discrepancy by
`2(W-m(q))`. All nonterminal denominators are positive because
`Z>=c(r)/a>0`. Thus

```
sum(K+G) <= 4 C_term+3 sum e+4 sum h
          <=5000F(1+J/P+J/T)D.
```

At a bad node `c<2 H^(1/4)(K+G)`, giving the stated total bad
cost bound. This controls the exceptional costs globally, not
by pretending that every comparison node has a small curvature.

At a non-bad node, the comparison prefix at cut `j` has mass
`M_j=sum_{i<=j}m_i`. Appending the comparison suffix to any
prefix competitor proves
`M_j-G<=Phi_j(p_j*)<=M_j`. Weighted Cauchy--Schwarz and
`|z(r)/W-z(r)/Z| W<=G` then give

```
|p_j*-p0-(z(r)/Z)Phi_j(p_j*)|
 <= sqrt(KW)+2G
 <= tau theta b/M.
```

The final inequality follows from
`M<=H^(1/20)`, `K,G<=b H^(-1/4)`, `W<8ell b`, and
`ell^200<=H^(1/100)`. The left side after multiplying by `M/b`
is at most `sqrt(8ell)H^(-3/40)+2H^(-1/5)`, which is
smaller than `ell^(-44)` at the cutoff.
The velocity test makes each cut's allowed shift diameter at most
`2theta b/M`; no convexity of the shift set is needed.
Consequently

```
h_Sigma <=2b+2 sum_i w0(q_i)+8L0 theta b <=64Fb.
```

Dyadic child rounding is a multiple of the parent grid spacing,
preserves each child's valid endpoint order, changes its endpoints
by less than `2theta h_i`, and gives `|z_i(beta)|<=2h_i`.
Its shift radius is below `10b`. Hence all guards pass.
These derivations establish the actual comparison action's band
membership; it is not an abstract feasible comparator postulate.

### The conditional entropy input

On one fixed band, normalize costs by `f_t(i,s)=d_t(i,s)/h_i`.
Their coordinates lie in `[0,1]` and decrease. Every feasible
action vector has child-block mass `h_i/h_Sigma`; averaging all
listed action vectors is positive in every coordinate.
The band diameter and spatial inequality give the within-block
range

```
range(Delta_t) <=2delta+8Ltheta<=3delta<=kappa/eta.
```

Here `Delta_t=f_{t-1}-f_t`. This is a within-block bound; no
false claim that all child decrements are individually small is
needed.

Here is a self-contained potential argument for the input used in
the formal transfer. Let
`Psi(v)=max_{rho in Q}(H(rho)+eta<v,rho>)`.
The maximizer `p` is positive: moving toward a positive feasible
vector gains a positive `s log(1/s)` entropy term at a zero
coordinate, dominating all linear terms. Strict concavity makes
it unique. First-order optimality and the entropy identity give

```
H(rho)+eta<v,rho> <= Psi(v)-KL(rho||p).
```

Put `g_hat_t=-f_{t-1}`, `u_t=g_hat_t+(1-2kappa)Delta_t`.
Moving from `v=sum_{j<t}u_j` to `v+g_hat_t` costs at most
`eta<g_hat_t,rho_t>`. Subtract each block's minimum from
`Delta_t`, obtaining a remainder `r` with `0<=eta r<=kappa`.
The block minima have the same scalar product at all feasible
vectors. The KL penalty therefore bounds the remaining potential
increment by the scalar block-minimum increment plus

```
log sum_k rho[t,k] exp(eta(1-2kappa)r_k).
```

This last formula follows directly by normalizing the displayed
exponential weights; the leftover term is a nonnegative relative
entropy. For `0<=x<=kappa<=1/2`,

```
exp((1-2kappa)x) <=1+(1-kappa)x.
```

To check it, differentiate
`log(1+(1-kappa)x)-(1-2kappa)x`; its derivative is
`[kappa-(1-2kappa)(1-kappa)x]/[1+(1-kappa)x]>=0`.
Together with `log(1+y)<=y`, this bounds the innovation
increment by `eta(1-kappa)<Delta_t,rho_t>`.

Telescope the potential through any fixed prefix. Its initial
value is at most `log d`, and its final value is at least the
objective at the comparison action, whose entropy is nonnegative.
Finally `sum_t Delta_t<=1` coordinatewise. Rearrangement gives

```
sum_t <f_t+kappa Delta_t,rho_t>
 <= sum_t <f_t,rho*>+log(d)/eta+2kappa.
```

An L1 mixture error `H^(-3)` adds at most that amount per term
because `f_t+kappa Delta_t` lies in `[0,1]^d`.
Multiplying by `h_Sigma` cancels the normalization and gives the
actual action-cost prefix bound

```
E sum_{t<q} [A_t(alpha_t)+kappa(A_{t-1}(alpha_t)-A_t(alpha_t))-B_t]
 <= h_Sigma [log(d_C)/eta+2kappa+S H^(-3)].
```

The comparison action's child values are no larger than their
clipped values in `B_t`. The charge `Le` cancels on both sides.
The first crossing is a deterministic prefix of this conditioned
cost history, so this is not optional stopping with an unjustified
independence assumption.

### Conditioning and finite execution

With the whole seed fixed, induction on remaining physical height
shows that complete child tables use only strict-descendant
streams. Warmup and band data are deterministic functions of the
seed. At a parent, group results are keyed by whole cell and time,
and online actions by query, scale, and time. No child computation
asks for a current-parent stream. Thus conditioning on complete
child tables preserves the prescribed parent marginal laws.
Child tables may be arbitrarily correlated with one another.

There are finitely many relevant node, state, time, scale, and
action labels. Exact rational optimization mixtures and finite
uniform samples therefore induce a finite law on the returned
choices, even though rejection sampling uses fair infinite bit
streams as an implementation. Sampling terminates almost surely
with finite expectation; it does not allocate an infinite table.
Finite conditional expectations can be written as nested weighted
sums. `mean_product_kernel` and `conditional_mean_bound` check
the algebra without requiring a product-independent child law.

The optimizer's numerical contract is also discharged, rather
than treated as an exact optimization oracle. With `G=H+d+2`,
smooth entropy at `sigma=G^(-50)`; its uniform perturbation is
at most `4d sqrt(sigma)`. Approximate gradients within
`G^(-20)` and use step `2/(j+2)`. The concave smoothness inequality
gives

```
D_{j+1} <=(1-step)D_j+2G^(-20)step+2step^2/sigma,
D_j <=2G^(-20)+8/[sigma(j+1)]  (j>=1).
```

The first step is one, removing any dependence on the magnitude
of the initial linear objective. After `G^80` steps, the true
objective gap is at most `12G^(-20)`. Negative entropy has
Hessian at least the identity on the simplex. First-order
optimality then gives L1 error at most
`sqrt(24d)G^(-10)<=H^(-3)`.
The selected-vertex weights are exactly
`2(j+1)/[K(K+1)]`. A rational gradient uses the finite series
`log r=2 sum_k ((r-1)/(r+1))^(2k+1)/(2k+1)`;
`G^60` terms suffice for the displayed error since `r>=sigma`.
Uniform-integer rejection sampling of the triangular weights
samples the rational mixture exactly, with success probability
greater than one half per trial. All action lists and all
iteration counts are finite. The same reasoning applies to each
finite lazy request. This establishes finite execution of the
original refinement, not its separate almost-linear work theorem.

### Oracle-defect bounds for the original group sampler

For fixed child tables, one sampled scale uses independent child
indices. Its normalized sample `X` satisfies

```
0<=X<=2Mh/b,   E X<=128F,   Var X<=256FMh/b,
k_h>=Q1 Mh/b.
```

The required two-sided Bernstein bound can be derived directly:
for a centered variable `Z` with `|Z|<=R`, expand its exponential
series and use `n!>=2*3^(n-2)` for `n>=2`. For `0<=lambda<3/R`,

```
E exp(lambda Z) <=
 exp(lambda^2 Var(Z)/[2(1-lambda R/3)]).
```

Independence multiplies these moment bounds. Markov's inequality,
with `lambda=alpha/[v+R alpha/3]`, bounds a sample-mean upper
tail by `exp(-k alpha^2/[2v+2R alpha/3])`; apply the same
argument to `-Z` for the lower tail. Thus no unexamined external
concentration proposition is needed in this application.

Set `alpha=gamma/(2ell)`. The failure probability for a fixed
member and sampled scale is at most
`2 exp(-ell^37/3000)`. Union over at most `2ell` scales and
`(P+1)^2` members gives at most `H^(-4)`. For an explicit
domination, write `e=log2 ell>=1000`, `h=log2 H<=ell`.
Then

```
log(4ell(P+1)^2)+4 log H
 <= log(16ell)+[2(p_*+20)+4]h log 2
 <= 60 ell^2
 < ell^37/3000.
```

Here `p_*<=e`, `e+1<=ell`, `h<=ell`, and the final bound is
extremely loose at `e>=1000`. Exact scales have no failure.
Shared draws across members do not invalidate this union bound.

Endpoint rounding and spatial regularity give, uniformly in every
band action,

```
V(beta;d_t) <=(1+delta)x_t(alpha)+(6L+2)theta h_Sigma,
d_t(beta_i)<=2h_i.
```

Estimate minimization costs at most an additional `2gamma b`;
moving within the whole cell costs at most `2Ltheta b`.
The total coefficient is at most
`e_*=2gamma+512LFtheta<=kappa delta`.
Hence `xi=0` on group success. On failure,
`0<=xi<=Pi<=w0<=2Fc`, since all action costs are nonnegative.
Consequently `E[xi | child tables]<=2Fc H^(-4)`. This
specialization uses the coarse cap, but the error-sensitive
transfer theorem itself does not.

### Tree and time summation

At all other comparison nodes the Bellman option gives,
deterministically,

```
sum_t R_t <= sum_i (clipped d_0-clipped d_S)_i
          <= W-|z(r)| <=4Fc.
```

For a non-bad velocity-failing node, this improves to
`(H^(-1/4)+4tau F)c` because `|z(r)|>(1-tau)Z`.
Bad nodes have total cost at most
`10000 F H^(1/4)(1+J/P+J/T)D`.
At a good node, the error-sensitive bound already proved gives
the entropy allowance, `2delta c`, and its actual defect sum.
Use `h_Sigma<=64Fc`, `log d_C<=4(p_*+21)ell`, and
total comparison cost at most `2JD`.

For each fixed outcome and time, clipped node regrets telescope:

```
clipped d_t(root)=C_term+L sum_v e_v+sum_v R_t(v).
```

The terminal values are exact. Averaging in time bounds the final
positive excess because the root values decrease. This is
`root_excess_from_node_regrets`, not a hypothesis that the final
positive excess is small. Conditioning, then integrating node
bounds, uses only the tower identity and linearity.
Substituting the preceding cost bounds yields exactly `E0 D+Defect`.
The initial and zero-cost bounds were already established
deterministically, completing the stated extension and its
application to every admissible fixed seed.

## Exact parameter certificate

Substitute `J<=100H/ell`, `T>=H^(3/4)`, `S=H/ell^2`,
`F=ell`, `P>=H^20`, and the weaker `M<=H` into `E0`.
Its monomials are dominated by

```
52000 H^(-18)
+8040000 ell^4 H^(-1/2)
+200 ell H^(-1/4)
+1000000 (p_*+21) ell^(-2)
+13200 H^(-2).
```

`verify.py` reconstructs this symbolic substitution over rational
exponents, checks every coefficient and monomial domination, and
checks the following universal induction certificates. It does
not construct an infeasibly large input or enumerate a bounded
range and call it a proof.

Write `ell=2^e`, `H=2^h`, with `e>=1000` and `h>=2^(e-1)`.
The first, second, third, and fifth terms are at most
`1/(8ell)` respectively from the stronger affine bounds

```
h >= e+19,   h >=10e+52,   h >=8e+44,   h >=e+17.
```

Each follows for all `e>=1000` by induction from its exact
base value: if `2^(e-1)>=u e+v`, doubling dominates
`u(e+1)+v` because `u(e-1)+v>=0`.
For the fourth term, `p_*<=e` and
`(e+21)^2<=2^e` imply `p_*+21<=sqrt(ell)`.
The latter inequality propagates by

```
2(e+21)^2-(e+22)^2=e^2+40e+398>=0.
```

Finally `(8*1000000)^2<=2^e` at `e>=1000`.
Squaring positive quantities proves the fourth allocation without
floating-point square roots. The original oracle tax has the
additional allocation `400H^(-3)<=1/(8ell)`, certified by the
stronger affine bound `h>=e+12`.

The other structural slack inequalities used above follow from
the same cutoff: `200e<=2^e/200` and `p_*+21<=sqrt(ell)`,
with increasing right-side slack. For the group union bound it
suffices that `180000<=ell^35`; for the remainder of band
coverage and rounding it suffices to substitute
`ell^200<=H^(1/100)` into the displayed powers. These are
universal exponent comparisons, not empirical large-number
approximations.

## Formal statement fidelity and remaining verification boundary

`Main.lean` is an independent Mathlib proof, with no imported OAI
modules, no declared axioms, and no admitted proofs.

* `firstCrossing_defect_sum` quantifies over **every** action type,
  finite horizon, real antitone action history, actual scalar
  clipped update, online action, and nonnegative additive defect.
  It explicitly assumes the previous-index Bellman domination,
  the online candidate inequality, and `B_t>=c`. It proves the
  phase-resolved accumulated parent-regret bound.
* `expected_firstCrossing_defect` adds an arbitrary normalized
  nonnegative finite probability law, the augmented-online-prefix
  allowance, and per-time first-moment defect budgets. It proves
  expected parent regret. It does not assume group/online
  independence, a coarse cap, or the conclusion it proves.
* `oracleDefect_upper`, `oracleDefect_nonneg`, and
  `oracleDefect_minimal` establish the residual's adequacy and
  minimality relative to an actual band minimum.
* `mean_product_kernel` and `conditional_mean_bound` implement
  finite disintegration with kernels allowed to depend on the
  environment. No independence of child coordinates is encoded.
* `root_excess_from_node_regrets` assumes the exact tree
  telescoping identity, antitone root estimates, and expected
  accumulated node budgets, and **derives** the final positive
  excess bound. `root_accuracy_from_defect_budgets` composes it
  with the explicit `5/8 + 3/8` error allocation.
* `update_lower`, `update_upper`, `update_zero`, `update_floor`,
  and `update_spatial` check the scalar invariant steps.
  The empty-online branch of the manuscript is not encoded by
  a fake large real number: the first-crossing theorem is applied
  only at a retained comparison band, where an online action
  exists and the online minimum is finite. Outside that case,
  the prose uses the Bellman inequality directly.

**Boundary:** Lean checks this universal transfer and aggregation
core, not an end-to-end encoding of strings, cones, the rational
optimizer, Bernstein, band coverage, or the parameter definitions.
Their concrete instantiation is the mathematical proof above and
the exact symbolic/exponent replay; it is not kernel-closed merely
because `Main.lean` compiles. The original refinement claim and
the full L1 extension must therefore receive independent
mathematical review separately from the kernel-certified transfer
claim. No upstream final-accuracy theorem is assumed in that
application. The full almost-linear running-time theorem is
outside this bounded mission's certification.

The final compiler output explicitly prints transitive axioms of
the main declarations. Only `propext`, `Classical.choice`, and
`Quot.sound` are acceptable here; `sorryAx`, opaque external
mathematical axioms, or a stale source/fidelity hash invalidate
the formal certificate. No literal flawed manuscript assertion
has been established, so no `F_*` refutation claim is asserted.

## Reproduction

From the campaign root, run `python3 research/refinement/verify.py`
to replay the exact arithmetic, exponent inductions, typed Jacobian
result, and freshness of the archived Lean evidence. To obtain a
new real compiler result for the registered formal statement, run

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/refinement/Main.lean --statement-fidelity research/refinement/statement_fidelity.md --artifact-dir research/refinement --project-root . --claim C121_DEFECT_TRANSFER --timeout 100
```

The compiler result is attached only to `C121_DEFECT_TRANSFER`.
Do not label the full edit-string theorem `closed_kernel` from
this command.
