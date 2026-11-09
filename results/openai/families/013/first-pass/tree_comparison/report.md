# Finite-field tree comparison: literal scope and source map

## Status and scope

This is an audit of Lemma `lem:tree-comparison`, not a proof or refutation
of Ostmann's conjecture. The Engineer has completed the all-prime proof
below and its supporting exact checks. No false manuscript assertion
has been established. Independent review of the analytic proof and
statement fidelity is pending.

The staged source is
`research/openai_manuscript/the-additive-indecomposability-of-the-primes-September-24-2026/build/`.
Source files remain unchanged.

## Objects and quantifiers

The manuscript's main assertion (`01-introduction.tex`, `cor:ostmann`)
quantifies over **all** subsets A,B of the nonnegative integers with at
least two elements each: their sumset cannot have finite symmetric
difference from the positive primes. Both eventual prime coverage and
eventual exclusion of composite sums are required. The finite-summand
reduction (`02-preliminaries.tex`, `lem:finite-factor`) reduces this to
two infinite summands (`thm:main`), using the fixed-shift sieve. These
are source assertions recorded for dependency tracking, not audited
conclusions of this local mission.

The tree lemma is independent of that arithmetic hypothesis:

* q is any odd prime, U is its multiplicative group, and all field
  arguments use probability measure.
* g(0)=0 and q^(-1) sum_x |g(x)|^2 <= 1. No pointwise bound is assumed.
* epsilon is the maximum of
  |q^(-1) sum_x g(x) chi(x) exp(2 pi i a x/q)| over every
  multiplicative character chi and every a in the field. All
  characters, including the principal one, are zero at zero.
* A depth-l full ordered binary tree has r=2^l unit leaf variables.
  Every frequency, root current entry, D', and internal C and u is a
  unit. The consistency equations are
  C_(n,+,+) C_(n,+,-) = u_n C_(n,+) and their minus-child analogues.
* Internal entries and arguments are exactly those in `eq:src36`.
  A zero reconstructed p kills the entire diagram, before any division
  by p. Bottom siblings have opposite conjugations; different pairs
  may make different choices.
* The single-diagram assertion is E|W|^2 <= 3^r.
* In the paired assertion l>=2. Each diagram has a partition into b
  nonempty sets, the two sets of components are paired, and the law is
  uniform on equality of the paired component products. If b<=3r/4,
  the assertion is |E W1 conjugate(W2)| <= C_l(epsilon+q^(-1/4)),
  uniformly in all permitted partitions, parameters, and conjugations.

The estimate must also handle a two-parallel-edge cycle, held leaves
whose current entry is a reconstructed p, and sparse or large-valued g.
An isolated numerical violation of an unspecified asymptotic constant
would not be a refutation.

## Manuscript dependency map

| Claim | Source locator | Dependencies / audit boundary |
|---|---|---|
| Ostmann assertion | `01-introduction.tex`, `cor:ostmann` | Finite-summand reduction and two-infinite-summand contradiction |
| Finite-summand reduction | `02-preliminaries.tex`, `lem:finite-factor` | Fixed-shift sieve and prime coverage |
| Collision stability | `02-preliminaries.tex`, `lem:collision`, `eq:src2` | Complementary residue supports; weighted congruent-pair count |
| Quadratic decorrelation | `03-quadratic.tex`, `prop:quadratic`, lines 6-19 | Collision stability; separate quadratic argument |
| Higher character decorrelation | `04-characters.tex`, `prop:characters`, lines 17-26 | Collision stability and the quadratic input |
| Mixed Fourier-character flatness | `04-characters.tex`, `cor:mixed-flatness`, lines 1117-1133 | Previous two decorrelations and balanced supports |
| Fourier supply | `05-supply.tex`, `prop:supply`, lines 3-25 | Coverage and size/collision inputs; explicitly independent of mixed flatness |
| Tree comparison | `06-tree.tex`, `lem:tree-comparison`, `eq:src35`-`eq:src42` | Density, quartet majorants, affine Mellin bound, two-bad fourth moment, cycle projection |
| History comparisons | `07-construction.tex`, `prop:comparisons`, lines 704-775; `08-arithmetic.tex`, lines 604-640 | Arithmetic equidistribution plus tree comparison at spectator primes |
| Final transfers and contradiction | `09-conclusion.tex`, lines 170-199 and 308-386 | Transfer lower bound, comparison upper bound, permutation symmetrization |

The source's necessary counting bounds do not themselves contradict
coverage. For example, the formal growth values A(x)=B(x)=sqrt(x/log x)
satisfy the weaker square-root/log-power restrictions and the product
lower bound simultaneously. This is a retired arithmetic shortcut, not
a flaw in the manuscript: the introduction expressly warns against it.

No external analytic theorem is needed for the planned local proof:
the affine estimate and the Gauss/fourth-moment calculation are to be
derived directly. Thus no unexamined literature theorem is being taken
as a local-proof assumption. The Gowers, Babai--Nikolov--Pyber, and Gill
references in Section 06 are motivation, not premises of its direct
calculation. No novelty priority claim follows from verifying this
manuscript lemma.

## Tool capability finding

The installed Jacobian server reports version 0.14.0, MCP protocol
2025-11-25. Discovery and the inspected contract are retained in the
adjacent JSON files. The inspected polynomial-map operation can exactly
evaluate a **specified finite field**; it cannot certify a quantified
character estimate or the whole tree theorem. A bounded squaring-map
execution is relevant to the two-to-one pullback, but will remain
supporting finite evidence, not an all-field proof.

The actual execution was rejected with `INVALID_REQUEST` at
`operation_validation`: its finite-extension presentation validator
disallows the degree-one modulus `[0,1]`. The adapter exit status was 2;
there was no timeout and no mathematical result. The exact payload and
structured error are retained. This is a limitation of the inspected
operation, not evidence that Jacobian has no other prime-field tools.

# An explicit-constant verification theorem

**Theorem.** Under exactly the diagram hypotheses above, for every odd
prime q,

    E |W|^2 <= 3^r,
    |E W1 conjugate(W2)| <= 16^r (epsilon + q^(-1/4))

in the paired setting l>=2, b<=3r/4. The second assertion remains true
under the more general hypothesis that the first diagram's
component--bottom-quartet multigraph has a cycle, without requiring the
numerical restriction on b. Different unit parameters and bottom-pair
conjugations in the second diagram are allowed.

This is an all-field mathematical proof, not an inference from the
finite tests below. It verifies the complete stated comparison and
makes its implicit depth constant explicit. It does not claim that the
manuscript's arithmetic inputs are valid, or that its analytic argument
or the cycle generalization is novel. Independent review must assess
the proof, its fidelity, and any publishability claim separately.

## 1. Density and the zero convention

On valid points, direct cancellation in eq:src36 gives

    y = d-e,       d/e = (s_plus/s_minus)(H_minus/H_plus).

The root argument is c divided by the product of all leaves. Conditional
on the exposed product at a node and its ancestors, the left descendant
product is uniform on U and determines the right product. All current
entries are already fixed. Thus d/e is a fixed unit times the inverse
square of that left product. A specified valid split has at most two
preimages, each of conditional probability 1/(q-1).

For k nodes at any horizontal level, their arguments determine all
ancestor arguments by differences. The valid subprobability law is
therefore dominated by

    2^(k-1) times independent uniform measure on U^k.             (1)

No conditioning on ancestor validity renormalizes this subprobability
measure. Invalid p values simply contribute zero. For k=r this yields

    E|W|^2 <= 2^(r-1) (q/(q-1))^r ||g||_2^(2r) <= 3^r.           (2)

The depth-zero convention gives the same conclusion directly.

## 2. Bottom-pair Fourier data

Write L=q/(q-1)<=3/2. For sigma=+1 or -1 and f=g or conjugate(g), set

    h(d,t)=f(sigma*d*t/(t-1)) conjugate(f(sigma*d/(t-1))),

zero when d=0 or t=0,1. Let R(d)=E_(t in U)|h(d,t)|^2. R is independent
of these choices: conjugation has no effect, and swapping the ordered
pair shows invariance under sigma. The valid (d,t) parametrization is
a bijection to ordered distinct unit pairs. Hence

    E_U R <= L^2.                                               (3)

For d nonzero let P_chi(d) be the Mellin coefficient of h(d,t).
Extend P_chi to d=0 by its autocorrelation formula, NOT by h(0,t):

    P_chi(d)=L E_x (f*conjugate(chi))(x)
                      conjugate((f*conjugate(chi))(x-sigma*d)).

With the probability additive Fourier convention, put
w_chi(a)=hat(P_chi)(a), J_chi=sum_a w_chi(a), and
r_chi=sum_a w_chi(a)^2. Autocorrelation gives

    w_chi(a)=L |hat(f*conjugate(chi))(sigma*a)|^2 >= 0,
    J_chi=L ||g||_2^2 <= L,
    max_a w_chi(a)<=L epsilon^2,
    max_chi r_chi<=L^2 epsilon^2,
    sum_chi r_chi<=2L<=3.                                      (4)

For the last inequality, Mellin Parseval at nonzero d contributes at
most L; the q-1 equal autocorrelation values at d=0 contribute at most
another L. In particular

    E_U |P_chi|^2 <= L r_chi.                                   (5)

If F(t)=sum_chi c_chi chi(t), character orthogonality and
Cauchy--Schwarz give, for K in U,

    |E_z F(K z^(+/-2)) conjugate(rho(z))|^2
        <= 2 sum_(chi^(+/-2)=rho) |c_chi|^2.                    (6)

Every square coset's probability law is likewise dominated by twice
uniform unit measure for nonnegative integrands. These are density
bounds, not pointwise bounds on g.

## 3. The uniform affine Mellin bound

For all eta and a we prove

    sum_chi |hat(P_chi chi eta)(a)|^2
        <= L (epsilon^4 + sqrt(3) q^(-1/2)).                    (7)

Here and below a multiplicative twist kills the value at zero even if
the twisting character is principal. Expanding h(d,lambda*d) in
Mellin characters and applying Parseval in lambda identifies the left
side with

    E_(lambda in U) |E_d h(d,lambda*d) eta(d) e_q(-a*d)|^2.

The change of variables

    t=sigma/lambda,  v=1/z,  1/x=v-t*v^2,
    G(v)=(f*eta)(1/v)e_q(-a*sigma/v),  G(0)=0

turns the inner expression, up to a unit scalar, into TG(t), where

    TF(t)=q^(-1) sum_(v in U) conjugate(G(v)) F(v-v^2*t).

The excluded d=0, lambda*d=1 values correspond precisely to the zero
terms in this formula. Inversion preserves the probability L2 norm,
so ||G||_2<=1 and |E G|<=epsilon.

Let U_v F(t)=F(v-v^2*t). Each U_v is unitary. The coordinate map in
U_v^* U_w is

    t |-> (w/v)^2*t + w-w^2/v.                                 (8)

For a fixed slope, z=w/v has at most two choices. If z is not 1,
the translation v*(z-z^2) determines v uniquely. The identity map has
only w=v representations: z=-1 has translation -2v nonzero because
q is odd. If c(A,B) are the coefficients of T^*T in the affine actions
F(t)|->F(A*t+B), then its identity coefficient is at most 1/q, and
Cauchy--Schwarz on the other fibers gives

    sum_(A,B)|c(A,B)|^2
       <= q^(-2)+2q^(-4)(sum_v|G(v)|^2)^2 <= 3q^(-2).           (9)

On the mean-zero additive Fourier basis, the squared Hilbert--Schmidt
norm of this affine sum is at most q sum|c|^2: the action sends the
mode xi to A*xi with coefficient e_q(xi*B), and additive Parseval
in B gives that bound. Consequently

    ||T^*T||_(mean-zero operator) <= sqrt(3) q^(-1/2).

Constants and mean-zero functions are invariant orthogonal subspaces.
On constants T acts by conjugate(E G). Applying T to G thus gives

    E_t |TG(t)|^2 <= |E G|^4 + sqrt(3)q^(-1/2)||G-E G||_2^2
                   <= epsilon^4 + sqrt(3)q^(-1/2).

Restricting t to U costs at most L. This proves (7), with no external
affine-group theorem and no boundedness hypothesis on G.

## 4. A uniform fourth moment, including principal twists

For nonnegative weights w of mass J, let r_w=sum_b w(b)^2.
Character orthogonality gives

    (q-1)^(-1) sum_alpha sum_a |sum_b w(b)alpha(a-b)|^4
        <= 2q r_w^2 + J^4.                                    (10)

Indeed, a surviving term has
(a-b1)(a-b2)=(a-b3)(a-b4) nonzero. Equal unordered pairs contribute
at most 2r_w^2 for each a. For unequal unordered pairs the difference
of the two monic quadratics is a nonzero polynomial of degree at most
one, hence has at most one root. Their total weight is at most J^4.
Repeated roots and repeated b's require no extra hypothesis.

The principal character contributes at least

    (q-1)^(-1) sum_a (J-w(a))^4
        >= J^4 - 3J^4/(q-1).

For every nonprincipal alpha, the elementary Gauss identity has
|hat(alpha)(a)|=q^(-1/2) for a nonzero and zero for a=0. Thus

    |hat(P_chi alpha)(a)|
        = q^(-1/2) |sum_b w_chi(b) conjugate(alpha)(a-b)|.

Subtracting the principal term BEFORE applying this identity proves

    sum_(alpha!=1,a)|hat(P_chi alpha)(a)|^4
        <= 2r_chi^2 + 3J_chi^4/q^2.

By (4), for either pair type,

    sum_(chi,alpha!=1,a)|hat(P_chi alpha)(a)|^4
        <=16(epsilon^2+q^(-1)).                                (11)

The principal twist is different:

    hat(P_chi 1_U)(a)=w_chi(a)-J_chi/q.                          (12)

It has maximum modulus at most L(epsilon^2+q^(-1)), and its
squared Fourier norm is at most r_chi.

For fixed nu, consider the two-bad sum

    sum_(a,chi,psi)
      |hat(P_chi nu conjugate(psi))(a)|^2
      |hat(P_psi conjugate(nu) conjugate(chi))(-a)|^2.

When both twists are nonprincipal, Cauchy--Schwarz and (11) bound this
by 16(epsilon^2+q^(-1)). When exactly one is principal, its associated
other index is fixed; Gauss convolution bounds the other squared
Fourier factor by L^2/q, and summing the first squared factor costs
at most 2L. Each of the two cases costs at most 2L^3/q.
When both are principal, both indices are fixed, and (12) bounds the
contribution by 2L^4(epsilon^4+q^(-2)). The total is at most

    40(epsilon^2+q^(-1)) <=64(epsilon^2+q^(-1/2)).               (13)

The Gauss formula used here follows by squaring
sum_x alpha(x)e_q(x), substituting x=u*z, and summing the nontrivial
character over U. Its squared modulus is exactly q. No analytic
literature assumption is needed.

## 5. Parameter-free quartet majorants

Fix a quartet product and valid ancestor data. Its parent argument y
is fixed and nonzero. Write d,e for its pair arguments, with d-e=y.
Let

    (F star G)(y)=(q-1)^(-1) sum_(d,e in U; d-e=y) F(d)G(e).

For nonnegative F,G, E_(y in U)(F star G)(y) is at most
(E_U F)(E_U G), by discarding the d=e exclusion.

**Both moving leaves in the same pair.** Apply (6) to that pair,
then expose the product and split of the two held leaves. Their two
square-coset densities cost at most four. A majorant is

    B_same,rho(y)=8 (S_rho star R)(y),
    S_rho(d)=sum_(sign=+/-1) sum_(chi^2=rho^sign)|P_chi(d)|^2.

For the right moved pair use R star S instead; the same mean bounds
apply.
The inverse coordinate convention is included by the two signs.
Equations (3)--(5) give

    sup_rho E_U B_same,rho <=243 epsilon^2 <=256 delta,
    sum_rho E_U B_same,rho <=162 <=256,                         (14)

where delta=epsilon^2+q^(-1/2). Each S_rho has at most four terms;
summing over rho counts each chi twice.

**One moving leaf in each pair.** Orient that leaf as free in each
pair. Dividing the reconstruction formulas gives

    t_L/d = fixed_unit * H_held,L^2,
    t_R/e = fixed_unit * H_held,R^2,
    p_*^2 = (s_plus*s_minus/(s_n*D'*u_n^2)) * y/(d*e).

If the held leaf uses the residual current entry, its form is
t_L=lambda_L*d (friendly); if it uses p_*, its form is
t_L=lambda_L/e (bad). On the right these are respectively
t_R=lambda_R*e and t_R=lambda_R/d. In all four cases, lambda_L
and lambda_R are independent uniform square-coset variables when the
held leaves vary. Their fixed multipliers may depend on y and the
ancestor data, but NOT on the held variables.

Changing the sign of the moving coordinate changes p_* by a sign and
does not change these ratios or the pair differences. Thus the
quartet value depends on the moving coordinate only through d/e,
a fixed unit times its square or inverse square. Applying (6),
dominating both parameter cosets, and converting the sum normalization
to 1/q costs at most 2*4*L^2<=18. Define

    C_nu(y;lambda_L,lambda_R)
      = q^(-1) sum_(d,e in U; d-e=y)
            h_L(d,t_L)h_R(e,t_R)nu(d/e),
    B_cross,rho(y)
      =18 sum_(sign=+/-1) sum_(nu^2=rho^sign)
                  E_(lambda_L,lambda_R in U)|C_nu(y)|^2.        (15)

All invalid reconstructions are zero terms: t_L=1 or t_R=1 kills
a bottom pair; parent ratio 1 cannot give d-e=y nonzero.

Summing (15) over rho and using Mellin Parseval in d/e gives

    sum_rho E_U B_cross,rho <=36 L^4 <256.                       (16)

For a fixed nu, extend the nonnegative y average to the full field
at cost L. Mellin expansion of the two h factors, orthogonality in
the independent lambdas, and additive convolution Parseval reduce
the full-field average to

    sum_(a,chi,psi)|hat(P_chi alpha)(a)|^2
                       |hat(P_psi beta)(-a)|^2,                (17)

with twists

| Left/right choice | alpha | beta |
|---|---|---|
| friendly/friendly | nu*chi | conjugate(nu)*psi |
| friendly/bad | nu*chi*conjugate(psi) | conjugate(nu) |
| bad/friendly | nu | conjugate(nu)*psi*conjugate(chi) |
| bad/bad | nu*conjugate(psi) | conjugate(nu)*conjugate(chi) |

If the left choice is friendly, (7) sums the chi index uniformly,
and Parseval bounds the remaining sum by 3. The right-friendly case
is symmetric. Each is at most 8 delta, using epsilon<=1.
The last row is bounded by (13), hence by 64 delta. Since (15)
has at most four nu terms,

    sup_rho E_U B_cross,rho <=18*4*L*64 delta <8192 delta.         (18)

Finally sum the majorants over 32 same-pair and 64 cross-pair types:
two choices of moved pair and four choices of (sigma,f) for each pair
give the former count; four friendly/bad patterns and four choices of
(sigma,f) for each pair give the latter. These overcount harmlessly
and include every permitted conjugation, orientation and coordinate
convention. The resulting SINGLE family B_rho(y) has no ancestor or
unit-parameter dependence, and, with K=2^20,

    sup_rho E_U B_rho <=K delta,
    sum_rho E_U B_rho <=K.                                     (19)

Indeed 32*256+64*8192=532480<K and 96*256<K.
For an untouched quartet, exposing its parent ratio and both bottom
ratios costs at most eight:

    B_0(y)=8(R star R)(y),     E_U B_0 <=8L^4<=81/2<K.           (20)

Every domination in this section integrates a nonnegative quantity.
In particular (19) is an averaged statement, not an invalid bound on
individual g values or individual P_chi(d).

## 6. Component fibers, cycles, and the complete paired bound

A component product map with nonempty blocks has constant fiber size
(q-1)^(r-b). Thus the paired law can be generated by independent
uniform component totals and, independently in the two diagrams,
uniform leaf fibers above those totals. Each marginal is uniform
independent unit leaves.

Put k=r/4. The first diagram's bipartite multigraph has r edges and
b+k<=r vertices, no isolated vertices, and therefore a cycle.
Take a simple cycle, allowing two parallel edges. Alternating
multiplication of its leaf variables by z and z^(-1) preserves
every component product AND every bottom-quartet product. Let P be
the average over z. It is an orthogonal projection. For the component
totals T, conditional expectation satisfies E(W1|T)=E(PW1|T).
Conditional Cauchy--Schwarz, (2), and contraction give

    |E W1 conjugate(W2)| <=3^(r/2) ||PW1||_2.                    (21)

Condition on all bottom-quartet products. Ancestor data, including
validity, are fixed. On valid ancestors the quartet interiors are
independent uniform product fibers. In each cycle quartet, its two
held variables and one moving coordinate are independent uniform units;
the other moving coordinate is determined by the product. If t
quartets occur in the cycle, Mellin Parseval in these independent
moving coordinates leaves precisely

    product_(j=1..t) rho_j^(delta_j)=1,  delta_j=+1 or -1.

The held averages and (19)--(20) dominate the projected squared norm
by the sum of products of the appropriate B_rho(y_j) and B_0(y_j).
These majorants depend only on the quartet root arguments. Equation
(1) at that horizontal level dominates their joint subprobability
law by 2^(k-1) times independent unit measure. All summands are
nonnegative, so that domination is legitimate even for unbounded g.

Put b_rho=E_U B_rho and b_0=E_U B_0. One character in the cycle
relation is uniquely determined by the others. Therefore

    ||PW1||_2^2
      <=2^(k-1) (sup_rho b_rho) (sum_rho b_rho)^(t-1) b_0^(k-t)
      <=2^k K^k delta.                                        (22)

For a two-parallel-edge cycle t=1: its sole index is the principal
character and (22) uses b_1<=sup b_rho. No longer cycle is assumed.
If an ancestor is invalid its entire contribution was already zero.

Combining (21)--(22), K=2^20, k=r/4, and
sqrt(epsilon^2+q^(-1/2))<=epsilon+q^(-1/4) gives

    |E W1 conjugate(W2)|
      <=3^(r/2) 2^(21r/8) (epsilon+q^(-1/4))
      <=16^r (epsilon+q^(-1/4)).

This proves both parts of the literal tree comparison, uniformly in
all the specified data. It also proves the stated cycle-criterion
extension. No claim has been made that the arithmetic reduction to
these diagrams is correct.

## Foundational identities and verification boundary

The Fourier identities used above follow by expanding finite sums and
using sum_x e_q(a*x)=q for a=0 and zero otherwise. The corresponding
character orthogonality follows for any finite abelian group by
translating the sum by an element on which a nonprincipal character
is not 1. Fourier inversion and Parseval then follow by expanding the
squared sums. For U, its square map has fibers {z,-z}, hence image
index two; the same index statement in the dual gives at most two
square roots of a character. These elementary finite identities,
Cauchy--Schwarz and finite-dimensional operator norms are the only
general tools used in the proof.

`Main.lean` addresses the universal rational and collision algebra,
not the complete analytic theorem. Its exact coverage is listed in
`statement_fidelity.md`. `verify.py` checks universal polynomial
identities and rational constant budgets, and also runs exact finite
stress tests. The finite cases are diagnostic support only. Neither
the compiler nor the script checks that the prose proof faithfully
implements all its analytic and probabilistic steps; that is the
independent Reviewer's remaining obligation.

## Exact replay results and their limits

The completed script checks nine universal rational/polynomial
identities and all rational constant budgets in the proof. Its finite
diagnostics enumerate 4,244 leaf tuples across 20 field/depth/parameter
cases, including 2,140 zero-reconstruction outcomes, 324
function/conjugation cases and 19,008 quartet sign-lift checks.
The functions include unit-modulus complex phases, sparse functions
with values of modulus 3/2, and a single spike. Every tested function's
probability L2 norm is checked exactly.

It also checks 259 paired partition cases with different diagram
parameters and conjugations: all 86 equal-block-count pairs of the
14 allowed unordered partitions of four leaves, at each of q=3,5,7,
and one nonparallel two-quartet cycle at depth three. A fixed
nonvanishing complex-valued test function is used for these paired
diagnostics. Both diagrams have nonzero weights and every tested
projection has positive norm. In particular the depth-three check is
not vacuous: each diagram has 128 nonzero weights. Sparse functions
were not substituted into this check when they made every weight
zero. This allocation changes no universal hypothesis in the proof.

The official Lean 4.31.0 run returned exit code 0, `proof_holes=[]`,
and axiom-audit exit code 0. Its archived claim certificate is
`certificates/C_TREE_ALGEBRA-aecfcac1b0b37198.json`. The source and its
fidelity document have not been edited since that run. As explained
above, this formally certifies the universal algebra only.

From the campaign root, replay the exact script with:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/tree_comparison/verify.py
```

For a fresh real compiler run with ledger recording:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/tree_comparison/Main.lean --statement-fidelity research/tree_comparison/statement_fidelity.md --project-root . --claim C_TREE_ALGEBRA
```

`exact_certificate.json` records these different evidence scopes
explicitly. It is not a claim that a program has checked the complete
harmonic-analytic proof. There are no external theorem assumptions in
this local proof and the citation-status command reports no blocking
lookups. No manuscript statement was judged false; consequently no
fabricated `F_` refutation claim has been introduced. The whole
manuscript, novelty, publishability, and independent acceptance remain
outside the Engineer's certified conclusions.
