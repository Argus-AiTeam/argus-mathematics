# Distinct births on symmetric factorial memories

## Result and scope

The birth-address modifications actually used in Weighted Dilation Graphs
(WDG), `build/sections/02-transference.tex`, preserve its stated symmetric
memory spaces. They also preserve both absolute adjoint bounds when particle
values coincide. Conditional on the unmodified signed-edge contraction and
positive Schur estimates, they imply the claimed low-rank bound, with constants
uniform in every memory cutoff. The theorem below gives an explicit finite,
inhomogeneous version as well as the manuscript's asymptotic specialization.

An arbitrary multiplier selecting an *old index*, without transforming that
index when the old list is permuted, need not give a symmetric output. That
observation is not a refutation of an absolute Schur bound: positive domination
still bounds the canonically symmetrically compressed operator. The actual
birth multipliers do not have this defect. In particular the comparison with
Poisson-Dirichlet (PD), `build/sections/04-memory.tex:350-363`, does not refute
WDG's restoration step. No false manuscript assertion is claimed here.

This is a conditional verification theorem, not a proof of any of the three
prime-distribution theorems. In particular the clean-edge Fourier estimate,
rare-transfer estimate, root replacement, original lifespan identity, and
truncation error remain inputs. The finite computations are regression
certificates, not proofs of universal quantifiers. The separate Lean file
certifies only the declarations described in `statement_fidelity.md`.
Publication-level significance and novelty require independent review.

## Source map and baseline

All WDG locators in this note refer to `02-transference.tex`.

| Assertion | Locator |
|---|---|
| Symmetric factorial memory, including numerical coincidences | `eq:memory-hilbert-space`, lines 409-430 |
| Indexed ghost deletion, ordered fresh integral divided by the batch factorial | `eq:ghost-row`, lines 451-477 |
| Canonical active slots; ordered promotions; fresh target integrations | edge definition, lines 479-515 |
| Ghost adjoint and its two Schur ratios | `eq:ghost-joint-integral`, `eq:ghost-schur-ratios`, lines 650-695 |
| Edge joint measure and factorial reversal | `eq:edge-joint-measure`, `eq:edge-factorial-reversal`, lines 706-755 |
| Unrestricted local-multiplier wording | `lem:memory-absolute`, lines 758-795 |
| Signed-edge input | `eq:whole-edge-contraction`, lines 1035-1037 |
| Potential addresses and equality rank | lines 1052-1106 |
| Fresh-integration and rank-threshold arguments | lines 1108-1170 |
| Birth phases, batch averaging, low-rank estimate | lines 1172-1237 |

The scoped baseline had no verified restoration result in this campaign.
WDG already proves the elementary partition/cycle identity and already warns
that a single collision estimate is insufficient. Neither is claimed as new.
The improvement here is an explicit, parameter-uniform local-operator and
factorial-adjoint verification, and the finite hybrid bound below, rather than
a larger finite search or a symmetry-only objection.

The background identity for unsigned Stirling numbers is also recorded in
NIST DLMF, Section 26.8(i), equation 26.8.3
<https://dlmf.nist.gov/26.8.E3>. Its defining convention counts permutations
with **A-r** cycles at rank r, not r cycles. The identity is proved below, so
no external theorem is needed. A targeted literature search did not identify
an independently sourced statement of the precise operator theorem below;
that non-result does not establish novelty.

## 1. Factorial memory and the exact local distinction

Let P be a finite set of integer labels, with positive masses nu(p). For each
p let R_p be a finite residue/anchor set with counting measure and one
distinguished hit at a given position. Put

    Z = {(p,r): p in P, r in R_p},   lambda(p,r) = nu(p),
    F = direct_sum_{j >= 0} L2_sym(Z^j, lambda^j / j!).

Tensor products over any finite number of groups and with invariant
active-slot spaces are allowed. A cutoff B is any nonnegative integer;
projection before and after each operation restricts the total pending size
to at most B. No constant below depends on B.

Equivalently, a memory is an occupancy vector n: Z -> N with finite support.
Its measure is

    m(n) = product_z lambda(z)^n(z) / n(z)! .                 (1)

Indeed the number of ordered representatives is j!/product_z n(z)!, and
the ordered measure is divided by j!. Formula (1) does not assume distinct
values and is particularly important on the numerical diagonals.

An indexed choice formula preserves F if relabelling the old indices, and
simultaneously relabelling every selected deletion/promotion index, leaves
its coefficient unchanged and permutes its target memory. The relabelling
is a bijection of choices. Applied to a symmetric test function, corresponding
summands are equal, so the resulting function is symmetric. This argument
uses the full permutation group, not a free action on distinct tuples; it
therefore applies unchanged when values coincide.

For comparison, take a two-particle hit list (a,b), delete only index 1,
and test with the symmetric one-particle function f(a)=0, f(b)=1. The raw
output is a nonzero constant times f(b); at the permuted list it is that
constant times f(a). Thus unrestricted old-index dependence need not descend.
This is an exact obstruction to a stronger endomorphism interpretation, not
an obstruction to either absolute estimate in WDG.

To see the latter distinction precisely, let P_sym be conditional averaging
over old-memory permutations. On ordered representatives, extend the absolute
choice formula to test functions by first applying P_sym at the target.
Its positive kernel has the same weighted row and column estimates as the
quotient kernel. For any choice multiplier phi with |phi| <= 1,

    |T_phi P_sym f| <= T_abs P_sym |f|.

Positive domination gives both Schur estimates, also after applying P_sym at
the source. Thus P_sym T_phi P_sym is bounded even when the raw formula
does not preserve symmetry. This does not assert that inserting projections
preserves histories of arbitrary index-sensitive choices. For the actual
birth choices, the equivariance just proved shows that it does.

## 2. Ordered birth batches and both ghost adjoints

In one group write A=q_i/rho^2, D=-eta_i/rho, C=V_g D, and
s=sum_p nu(p). For a ghost batch of size b, a local multiplier may depend
on its ordered fresh labels as phi_b(p_1,...,p_b), with |phi_b| <= 1.
It may also depend on fixed external coordinates. It does not distinguish
untransformed old indices.

For each fixed old deletion choice, the remainder of the fresh integral is
symmetric in its b fresh variables. Hence replacing phi_b by

    phi_bar_b(p) = (1/b!) sum_{sigma in S_b} phi_b(p o sigma)       (2)

leaves the integral unchanged. This is a change of integration variables
for each permutation, followed by averaging. Product measure is invariant,
even on repeated tuples. There is still just the original divisor 1/b! in
the birth integral; formula (2) is an average, not another counting divisor
on the transition coefficient. Also |phi_bar_b| <= 1. Reindexing old
deletions is equivariant, so this modified ghost is an endomorphism of F.

For a survivor list u of length k, a deleted hit batch alpha of length t,
and a born hit batch beta of length b, the joint integral has measure

    lambda^k(du) nu^t(dalpha) nu^b(dbeta) / (k! t! b!),             (3)

coefficient A^z(u) D^t C^b, and extra multiplier phi_bar_b(beta).
The indexed deletion identity is

    binom(k+t,t)/(k+t)! = 1/(k! t!).

Interchange alpha and beta in (3) and conjugate the coefficient. Thus the
adjoint interchanges C and D (and conjugates), and its multiplier is the
conjugate of the original multiplier on the *deleted* batch. It is not
incorrectly reapplied to the adjoint's newly born batch.

There is an alternative coordinatewise verification with no distinct-value
assumption. Let u_z,d_z,b_z be survivor, deleted and born multiplicities at
a hit coordinate z. Multiplying a row coefficient by its source measure
gives the common factorial factor

    nu(z)^(u_z+d_z+b_z)/(u_z! d_z! b_z!).                         (4)

Both adjoint directions give (4). Nonhit multiplicities are unchanged.
Multiplication over all coordinates proves (3), including all stabilizers
of repeated tuples.

With w(n)=v^|n|, the absolute unmodified weighted row and column ratios are

    exp(|C| v s) (A + |D|/v)^z(n),
    exp(|D| v s) (A + |C|/v)^z(n).                               (5)

Deletion subsets give the binomial powers, and the factorial fresh
integral gives the exponentials. They are the two directions of (3).
Choose v so both parentheses are at most one. Every modified kernel is
dominated by these positive kernels; cutoffs can only remove nonnegative
terms. This proves both estimates for every B and, by positive monotone
limits, for the untruncated local ghosts. The same calculation allows
doubled birth coefficients when v is chosen with that margin.

## 3. Stores, promotions, and factorial edge reversal

Fix a pattern, canonical active-slot permutations, shared/free labels,
and ordered promotion and store slots. Write a for the number promoted,
b for the number stored, and k for the number of surviving old particles.
The step Delta is determined before fresh target labels are drawn. With
counting residue measure, the source and target memories are

    X = u union ((p_h,-Delta mod p_h))_{h <= a},
    Y = T_Delta u union ((s_h,Delta mod s_h))_{h <= b}.

Their joint memory and active-label measure is

    lambda^k(du)/k! * product_h nu(p_h) * product_h nu(s_h).        (6)

The relevant factorial identity is

    (k+a)_a/(k+a)! = 1/k! = (k+b)_b/(k+b)!.                     (7)

It counts injections into specified *ordered slots*. It does not count
distinct numerical prime values. All multiplicities, including coincident
stored and surviving particles, are retained in (6). Translation is a
measure-preserving bijection and each hit condition selects one point of
counting measure.

Reversal exchanges the ordered promoted and stored slots and changes Delta
to -Delta. It keeps the original coefficient V_g^(-a). If the reversed
row convention instead charges V_g^(-b) to its promotions, its extra factor
is V_g^(b-a). Equivalently a directly generated adjoint pays V_g^(-b_rev)
on its newly stored particles. The two endpoint rho factors exchange.
The ban on newly stored particles being promoted on the same edge makes
the reversed survivor/promotion/store description the same admissible
choice system.

A multiplier depending on which canonical target slots are fresh, and on
their fresh prime labels, is equivariant under all old-index permutations:
permuting an injection changes its indices, not its target slot or whether
that slot is fresh. Its conjugate on the reversed local choice is bounded
by one. Thus (6)-(7) continue to give both adjoint estimates. In particular,
it would be wrong on reversal to test whether that reversed *target* slot
is fresh: the original condition becomes a condition on the corresponding
reversed source slot not being stored.

For completeness, the uniform promotion count is
(z)_a rho^(z-a), not a count of distinct values. For fixed a and 0<rho<1,
it is bounded for all z, since its consecutive ratio tends to rho.
The same calculation controls original stores in the adjoint direction.
Because a,b <= ell+m, all transfer and Schur-weight factors are bounded
per group, independently of j and J. Fresh masses are bounded, restrictions
only decrease absolute kernels, and slot symmetrizations are positive
self-adjoint averages. This proves stability of both WDG absolute edge
bounds, including all numerical diagonals and memory-size projections.

## 4. A parameter-uniform distinct-birth theorem

Consider N edges separated by N+1 ghost operations of the preceding types,
on any finite tensor product of the spaces above, with cutoff B >= 0.
There are A potential birth addresses. An address is local to exactly one
operation, or to the initial boundary. Within an operation it is a
canonical fresh target slot or an ordered coordinate of the ghost batch.
It is performed precisely when that slot is fresh or that batch coordinate
exists. Births take integer values; disjoint prime groups are allowed.

Assume the following bounds, with constants uniform in B.

* The empty-memory boundary vectors have norm product at most b_norm.
  The value-independent positive initial majorant, evaluated by independent
  fresh integrations, has mass at most b_mass. This is not an arbitrary
  possibly smaller mass after conditioning initial labels. The terminal
  boundary is bounded by the positive Schur weight.
* Every birth-modified ghost has norm at most H_j; edge i has signed norm
  at most S_i>0.
  Every birth-modified edge has norm at most K_i, where K_i>=S_i.
  Let R_j and U_i be positive weighted row bounds for ghosts and edges.
* Fresh laws have total mass at least one and maximal atom at most delta.
  In a positive row majorant, their mass factors can be bounded independently
  of the fresh values: the step, promotion counts, damping and Schur-weight
  ratios are fixed first, coefficients are bounded by their suprema, and
  exclusions may be dropped. The same holds for the initial fresh active
  slots in the majorant defining b_mass.

These are assertions about the choice formula, not just its matrix norm.
The third hypothesis is essential to the high-rank argument. It holds for
WDG because Delta uses shared/free D-labels, not fresh target labels.
For ghosts the product integral and factorial divisor give it directly.
No such hypothesis is inferred for an arbitrary signed kernel.

Set

    U = b_mass * product_j R_j * product_i U_i,
    V = b_norm * product_j H_j * product_i S_i,
    Q = max(1, max_i K_i/S_i),
    c(A,r) = coefficient of t^r in product_{j=0}^{A-1}(1+j t).

When A=0 the product has its single coefficient c(0,0)=1.
For any A, sum over all its coefficients (0 <= r <= A).
Then the scalar history with globally distinct performed births satisfies

    |Z_distinct| <= sum_r c(A,r) *
                   min(U delta^r, V Q^min(N,2r)).               (8)

More precisely, before grouping by rank the second term is

    V * product_{i in D_pi}(K_i/S_i),                           (9)

where D_pi is the set of affected edges. Formula (8) is uniform in
B, repeated values, group sizes, batch sizes and inhomogeneous edge bounds,
subject to the displayed hypotheses. It is a conditional verification and
a quantitative strengthening of the coarse rank split.

### Proof

A collection pi of disjoint nonsingleton blocks has

    mu(pi) = product_blocks (-1)^(h-1)(h-1)!,
    r(pi)  = sum_blocks (h-1).

For a realized history, impose that every address in each block is
performed and the birth values within that block agree. A block can be
given a cycle in (h-1)! ways. Consequently summing mu(pi) over all
compatible collections is the sign sum over permutations within each
equal-value class of *performed* addresses. A class of size at least two
has sign sum zero by multiplication by a fixed transposition; a singleton
has sign sum one. Unperformed addresses are not included. This proves the
exact distinctness indicator.

The absolute coefficient sum at rank r is c(A,r): it counts permutations
of A addresses with A-r cycles. Inserting the last address either makes
a singleton (no rank change), or inserts it after one of the A-1 existing
addresses (one rank increase). This gives the recurrence and the product
defining c(A,r). Also

    c(A,r) <= (A(A-1)/2)^r/r! <= A^(2r)                        (10)

for A>=1: the coefficient is an elementary symmetric sum of
0,...,A-1, and expanding the r-th power counts each distinct r-subset r!
times, along with other nonnegative terms.

Fix pi of rank r. Choose the chronologically first address in each block
as pivot, using canonical order within one operation. There are exactly
r dependent addresses. At each dependent fresh integration, constrain
its value to the already fixed pivot. Replace its unconstrained mass by
at most delta. Since an unconstrained total mass is at least one, this
improves that factor by at most delta.

For a ghost operation with d designated dependent coordinates of a batch
of size b, the mass estimate is delta^d s^(b-d) <= delta^d s^b;
the original coefficient and 1/b! remain. Summing only supported b's is
bounded by the original full positive row sum. Pivots within the batch
are integrated before their dependents. For an edge the independent
fresh slots give the same estimate, after the fixed majorants stated in
the hypotheses. Initial slots have the same product estimate.

For pivots that have already died, retain their values as conditioning
variables. Backward induction on operations bounds each remaining
positive suffix by its row constant times the Schur weight, uniformly in
every retained pivot value. This proves an absolute contribution at most
U delta^r. It does not require the pivot to remain a live memory particle.

There is a second, signed bound. For each block, with pivot beta_0,

    1_{all p_beta_j=p_beta_0}
      = integral_[0,1]^(h-1)
          exp(2 pi i sum_j tau_j(p_beta_j-p_beta_0)) dtau.        (11)

This follows by integrating each integer Fourier character. Collect
the factors of (11) at their birth operations and require the designated
births there to be performed. Every local multiplier has modulus at most
one. Sections 1-3 show that these *particular* multipliers act on the
same symmetric spaces and obey the same two positive adjoint estimates.
The initial multiplier only decreases the boundary norm; if a boundary
active-slot projection is needed it is also a contraction.

Crucially, after (11) no phase or birth tag has to follow a live particle.
All unaffected edges still have their full signed pattern sum and both
active-slot symmetrizations. There is no conditioning of those edges on
the pivot value in this signed argument.

A block of size h>=2 touches h<=2(h-1) addresses. Hence at most 2r
addresses, and at most min(N,2r) edges, are affected. Every ghost costs its
H_j, whether affected or not. Cauchy-Schwarz, the operator-norm product
bound, and then the Fourier integral give (9), bounded by
V Q^min(N,2r). Both estimates hold for the same pi, so take their minimum,
multiply by |mu(pi)|, and sum. This proves (8).

## 5. WDG specialization and the exact rank loss

Take S_i=L^(-G), K_i=L^C_a, H_j=L^C_v, and bounded boundary norms.
For a fixed rank-r collection, (9) gives

    O(L^((-G+C_v)N+C_v+min(N,2r)(G+C_a)))
      <= O(L^((-G+C_v)N+C_v+2r(G+C_a))).                        (12)

This is exactly `eq:low-rank-path-bound`, including the loss of the
complete signed norm on affected edges, and all N+1 ghost costs. It is
not merely a verification of the elementary partition indicator.

The high-rank argument gives

    L^(C_h(N+1)) (C/P_star)^r,                                (13)

since the tilted total mass is >=1 and <=2, and its maximal atom is
O(P_star^(-1)). No extra factor depending on a numerical multiplicity,
the number of dead pivots, a batch factorial, or the memory cutoff occurs.

Here L=log x, T=log L (WDG `01-preliminaries.tex:22`),
N=2 ceil(L^0.52), P_star=exp(L^c), 0<c<0.47. For fixed J the address
count is polynomial in L, so (10) is <=L^(C' r) with an exponent
independent of J once x is sufficiently large for that fixed J.
Choose

    r0 = ceil(C'' N T / log P_star).

For sufficiently large L, C L^C'/P_star <= exp(-L^c/2).
The sum of (13) with its coefficient count for r>=r0 is then bounded
by a fixed multiple of

    exp(C_h(N+1)T - C'' N T/2),

which is o(L^(-EN)) if C'' is chosen with a fixed sufficient margin.
For r<r0, r0/N=O(T/L^c)+O(1/N)=o(1); combining (10) and (12) gives

    L^((-G+C_v+o(1))N) = o(L^(-EN))

when G>E+C_v+3, as in WDG. The finite sum is empty on the high-rank
side if the threshold exceeds the available ranks, which causes no issue.
The order of choices is unchanged: G and the ideal accuracy are fixed
before the later sufficiently large fixed J.

In contrast, a lone collision bound would have exponential scale
exp(C N log L-L^c), which cannot give exp(-E N log L) for positive fixed
C,E at these scales. The retired single-collision route is therefore not
reopened by the finite verification.

## 6. Evidence and limits

`verify.py` uses exact rational arithmetic to recompute the following:
the old-index obstruction; raw and averaged fresh-batch integrals;
factorial ghost and independently generated edge adjoints with repeated
values; positive domination in both Schur directions; the full finite
birth-address expansion for histories containing stores, promotions and
ghosts; rank coefficients and rank-dependent contraction losses.
It also checks dependent fresh integrations inside one batch, exact
hybrid-versus-threshold bounds, and the freshness of the existing Lean
compiler record. The latter is not a new compiler invocation.

`jacobian_payload.json`, `jacobian_contract.json` and
`jacobian_result.json` retain one bounded authorized-adapter check:
the exact spectrum {0,1} of the two-order memory averaging projector.
This is a check of the compression distinction, not a proof of (8).

`Main.lean` and its compiler certificate cover the quantified core stated
in `statement_fidelity.md`. Neither the compiler nor the finite script
certifies the unproved analytic inputs. The ledger records those explicitly.
No main theorem is marked proved or refuted by this local result, and no
independent Reviewer verdict is manufactured by the Engineer.
