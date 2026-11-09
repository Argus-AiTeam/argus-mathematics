# All-order verification and refinement of the analytic Fisher mechanism

## Result and scope

The Wick identity and squared-cumulant Fisher estimate in section 3, and the
tensor-signal cumulant estimate and entropy integration in section 4, are
valid with the stated tensor independence. No false assertion in those
steps has been established. In particular, no refutation of the main
entropy-separation theorem is claimed.

Here is a stronger statement of the analytic result. Let `p >= 2`, let
`B_1,...,B_p` be free standard semicircular variables, and let `Y` be **any
symmetric self-adjoint contraction in a separate tensor factor**. The
symmetry is distributional: all odd moments of `Y` vanish. Put
`C=(B_1,...,B_p,Y)`, let the standard semicircular family `S` be free from
the whole tuple `C`, and write

    V_u = C + sqrt(u) S,     c = tau(Y^2),
    c_i = 1 (i <= p),        c_(p+1) = c,
    g(u) = Phi*(V_u) - sum_i 1/(u+c_i),
    L(a) = (1/2) sum_i log(2*pi*e*(a+c_i)),    K = 128.

All assertions below hold in a finite von Neumann algebra with faithful
normal tracial state. For every `u > 2*K^2*sqrt(p)`,

    0 <= g(u) <= 2*K^6*p^(3/2)/u^4,
    g(u) <= K^8*p / (u^5 * (1-K^4*p/u^2))
         <= (4/3)*K^8*p/u^5.                         (1)

For every `a > 0`, with the manuscript's exact normalization of `chi*`,

    chi*(V_a) = L(a) - (1/2) integral_a^infinity g(u) du.    (2)

The integral is finite. If `a > 2*K^2*sqrt(p)`, its half is at most both

    K^6*p^(3/2)/(3*a^3)    and    K^8*p/(6*a^4).       (3)

Consequently the manuscript's `chi*(V_a) > L(a)-1/2` holds. More strongly,
at `a = alpha*K^2*sqrt(p)`, `alpha > 2`, the entropy deficit is at most
`1/(6*alpha^4*p)`. This improves the stated analytic deficit rather than
altering the signal or an entropy definition.

There is also an exact leading coefficient, not just an upper bound. Set

    d = tau(Y^4) - 2*c^2,      D = 2*p*c^2 + d^2.

Then

    limit_(u -> infinity) u^5*g(u) = D,
    limit_(a -> infinity) a^4*(L(a)-chi*(V_a)) = D/8.   (4)

For the prescribed uniform `p`-point variable,

    c = (p+1)/(3*(p-1)),
    d = -(p+1)*(p^2+11)/(45*(p-1)^3).                 (5)

The manuscript gives only the first bound of (1) and the first bound of
(3); the dimension-saving estimate and (4) are extensions proved here.
The linear dependence on `p` in a uniform `u^(-5)` bound is optimal:
for the atomic signal, `D >= 2*p/9`, so no constant independent of
`p` can replace `p` by `p^beta`, `beta<1`, at all sufficiently
large noise times satisfying the stated threshold.
The bounded literature search described below does **not** establish
novelty. Publishability and independent acceptance remain for the
Reviewer; this is not a declaration that the campaign is complete.

## 1. Background, conventions and sources

For an ordered word `i_1,...,i_m`, free cumulants are defined by

    tau(C_i1 ... C_im) = sum_(pi in NC(m)) product_(A in pi) kappa(C_iA).

The order within every block is the original order. Its inversion is
the sum of block-moment products with coefficients `mu(pi,1_m)`.
We use mixed-cumulant vanishing only **between free algebras**, in
particular between the whole signal algebra and the noise algebra, and
among the `B` coordinates. It is never applied between `Y` and `B`.
Semicircular cumulants are zero except at order two.

These are Nica--Speicher, *Lectures on the Combinatorics of Free
Probability* (2006), DOI `10.1017/CBO9780511735127`, Proposition 11.4,
Theorem 11.16 and Examples 11.21. The Catalan enumeration and interval
factorization used in section 4 below are Proposition 9.4, Theorem 9.29,
and Propositions 10.14--10.15 of the same book. The author-hosted version is
<https://www.math.uni-sb.de/ag/speicher/publikationen/Nica-Speicher.pdf>.

A separate research agent read these locators in that author PDF,
including the freeness hypotheses. It reported support for both
`NS_CUMULANTS` and the Catalan corollary `NS_MOBIUS`. For example,
Proposition 9.4 states, "The number of elements in NC(n) is equal to the
Catalan number Cn." Examples 11.21 states, "This tells us that the second
order cumulant of s is equal to sigma^2 and all other cumulants are zero"
(the displayed parameter is transcribed in ASCII). The `4^m`
inequalities are consequences of the formulas, not verbatim quotations.
The DOI existence probe returned `present`.

**Attribution limitation:** this reader did not persist an official
`citation_check attribute` record. That command archives under
`research/literature/`, outside this mission's writable paths. No
independent attribution or Reviewer verdict has been fabricated, and the
canonical citations remain in the ledger. The source-reading result is
not represented as a literature-tier archival certificate.

The other explicit background facts are standard finite-tracial
conditional expectation as a contractive orthogonal `L2` projection,
trace Cauchy--Schwarz, and polynomial `L2` density in `W*(Z)`. They are
recorded as `TRACIAL_L2`, with the manuscript's statement and density
proof as the source. Entropy is a definition, specifically equation
`chistar` in section 2, not a different cutoff or limiting convention.

No relevant prior page was found in the inherited project wiki index.
A bounded comparison with Nica, `arxiv:1506.01345v3`, Proposition 4.3
and Proposition 5.9, and Diez, `arxiv:2306.00967v1`, Lemmas 1, 2, 4 and
Theorem 11, found related tensor paired-label combinatorics and
higher-order Stein/Fisher estimates. It did not identify this precise
tensor refinement, nor prove that it is new. These papers are not
assumptions of the proof.

## 2. Wick testing at every order, with the adjoint

Let `C` now be an arbitrary centered bounded self-adjoint `n`-tuple;
its entries need not be free or have real mixed moments. Let `S` be
standard semicircular and free from `C`. For an index list `j` of length
`r`, define `U_j` by summing over matchings of disjoint adjacent pairs
in the **original** index list: deleting a pair gives the factor
`-delta_(j_a,j_(a+1))`. The empty matching leaves the original product.
This gives `U_j^* = U_reverse(j)`. For example,

    U_(i,i,i,i) = S_i^4 - 3*S_i^2 + 1,

not a repeated-deletion rule that also deletes newly adjacent letters.

Expand `tau(U_j^* P(C+sqrt(u)S))` by noncrossing cumulants after expanding
each `Z` letter into `C` or `sqrt(u)S`. Fix those choices and a
noncrossing partition on the undeleted positions. Every block meeting
the initial Wick segment is a pair: mixed signal/noise blocks vanish,
and all other noise cumulants vanish. Let `A` be the set of its
initial-initial pairs whose endpoints are adjacent in the original
initial list. Deletion terms contributing to this same partition are
in bijection with subsets `F` of `A`: restore exactly the deleted pairs.
Their covariance factors agree, their signs are `(-1)^|F|`, and
restoring an adjacent pair preserves noncrossingness. Hence their sum
is zero unless `A` is empty.

If any initial-initial pair is present, choose an innermost one.
Every position strictly between its endpoints is also initial and
must pair within that interval; an external partner would cross the
chosen pair. A minimal such interval therefore has no intervening
position. Thus `A` is nonempty whenever any internal initial pair
occurs. This proves cancellation, including nested internal pairs.

In a surviving partition all `r` initial positions pair to `P`.
Their order in `U_j^*` is the reverse of `j`, so noncrossingness selects
the `P` positions in order `j_1,...,j_r`. The pair arches separate all
remaining positions into gaps; no block can join distinct gaps.
The unrestricted sums in the gaps give their moments, without any
freeness assumption inside the signal. Each external pair contributes
`sqrt(u)`. Therefore, for every polynomial `P`,

    D_j(P) = u^(-r/2) tau(U_j(S)^* P(Z)).             (6)

This includes complex polynomial coefficients by linearity. Terms
with `r > degree(P)` vanish. With zero signal and `u=1`, (6) makes
`U_j` orthogonal to all shorter words and gives the matching-index
Kronecker delta against words of the same degree. Since its leading
word has coefficient one, this proves Wick orthonormality; conjugate
symmetry handles unequal degrees.

At `r=1`, the derivative is the free difference quotient, so

    xi_i = u^(-1/2) E[S_i | W*(Z)]                  (7)

is a conjugate variable. It is self-adjoint. Neither a real-cumulant
restriction nor coordinate freeness was used.

## 3. The Fisher bound and the infinite-series justification

Assume diagonal signal covariance `tau(C_i C_j)=delta_ij*c_i`,
`c_i >= 0`, and write `v_i=u+c_i`. From (7),
`Phi*(Z) <= n/u`. Testing the conjugate identity with `Z_i` gives
`tau(Z_i xi_i)=1`, and Cauchy--Schwarz gives
`||xi_i||_2^2 >= 1/v_i`. These hold for all `u>0`.

For a fixed polynomial, group the noncrossing partitions of
`tau(Z_i P(Z))` by the block containing its first position. This is
a finite identity:

    tau(Z_i P) = v_i D_i(P)
        + sum_(r>=2,j) kappa_(r+1)(C_i,C_j1,...,C_jr) D_j(P).   (8)

There are no terms with `r>degree(P)`. Adding free semicircular noise
changes only second cumulants. Suppose

    T(u) = sum_(r>=2) u^(-r) ||kappa_(r+1)(C)||_2^2 < infinity.

Define, in the ambient `L2` space,

    R_i = sum_(r>=2,j) u^(-r/2)
          kappa_(r+1)(C_i,C_j1,...,C_jr) U_j(S)^*.

The adjoint Wick family is orthonormal, so this is a convergent
orthogonal series and `sum_i ||R_i||_2^2 = T(u)`.
For bounded `P`, `|tau(A P)| <= ||A||_2 ||P^*||_2`; thus the trace
pairing is continuous under this convergence. By (6), the tail of
the pairing is identically zero beyond `degree(P)`. Equations
(6)--(8) give

    tau((Z_i-v_i xi_i) P) = tau(R_i P).

The coefficients are **not conjugated**: the pairing here is
bilinear. Test with adjoint polynomials and use polynomial density
and the orthogonal-projection characterization to conclude

    Z_i-v_i xi_i = E[R_i | W*(Z)].                    (9)

There is no interchange of an uncontrolled series with a trace.

Self-adjointness, `tau(Z_i xi_i)=1`, and `||Z_i||_2^2=v_i` give

    ||Z_i-v_i xi_i||_2^2 = v_i^2*(||xi_i||_2^2 - 1/v_i).

Projection contraction and `v_i>=u` now prove exactly

    0 <= g(u) <= u^(-2) T(u).                        (10)

In particular, the use of `U_j^*` in the series is correct even when
mixed cumulants are imaginary.

## 4. Tensor support, the original bound, and the dimension saving

Return to the tensor signal of the theorem. A block moment with
`b` semicircular letters and `y` letters `Y` is

    tau_B(B_i1 ... B_ib) * tau_Y(Y^y),                (11)

with the original order of the `B` letters retained. Its first factor
is a sum of noncrossing pairings matching equal indices.

Consider a nonzero product of block moments in the cumulant inversion
formula for a partition `pi`. Select such a `B` pairing inside each
block. Their union is noncrossing on the `B` positions. To see this,
suppose two chosen pairs cross. If their blocks are distinct, their
four endpoints would cross the partition `pi`, which is impossible.
If the blocks agree, their selected within-block pairing would cross,
also impossible. Deleting all `Y` positions preserves the order.
This is the relation-theoretic statement `noncrossing_union` in Lean.

For fixed `b` positions, a fixed pairing permits exactly `p^(b/2)`
labelings, or at most that many if extra equalities are imposed.
One endpoint label per pair determines every label. Taking the union
over at most `4^b` pairings gives at most `4^b*p^(b/2)` labelings.
The Lean statements `pairing_label_bound` and
`family_pairing_label_bound` prove these counting implications at
every finite size. A nonzero cumulant has at least one nonzero
block-moment product, so this counts its possible support even
though some eligible entries cancel.

For completeness, `|NC(m)|=Cat_m<=4^m`. The Kreweras/interval
factorization of `mu(pi,1_m)` writes its absolute value as a product
of Catalan numbers whose index sum is at most `m`, and hence it is
at most `4^m`. Since the norm of every `B_i` is two and that of `Y`
is at most one, a product of block moments is bounded by `2^m`.
Thus **each** order-`m` cumulant has magnitude at most `32^m`.

Summing the support count over the positions of the `B` letters gives

    #support <= sum_b binom(m,b) 4^b p^(b/2)
             = (1+4*sqrt(p))^m <= 5^m p^(m/2).

Consequently

    ||kappa_m(C)||_2^2 <= 32^(2m)*5^m*p^(m/2)
                       <= K^(2m)*p^(m/2),           (12)

because `32^2*5=5120 <= 128^2`. Taking square roots proves the
literal manuscript lemma at all orders.

There are two further cancellations. If `m>=3` and there is no `Y`,
the cumulant is zero by semicircularity of the `B` family. If there
is exactly one `Y`, the block containing it has a factor `tau(Y)=0`
in every inversion term, by (11). Hence every nonzero higher
cumulant has at least two `Y` letters. For `p>=1`, restricting
the support sum to `b<=m-2` yields

    #support <= 5^m*p^((m-2)/2).

Finally every odd-order moment is zero: either the number of `B`
letters or the number of `Y` letters is odd. In an inversion term
of odd total degree some block has odd size and therefore zero
moment. Thus all odd-order cumulants vanish. In particular,

    ||kappa_m(C)||_2^2 <= K^(2m)*p^((m-2)/2)          (13)

for every even `m>=4`. This dimension saving uses tensor moments,
not an incorrect freeness replacement.

## 5. Summing and integrating: all parameters, not a finite search

Put `A=K^2*sqrt(p)`. From (12), (10) is bounded by

    u^(-2) sum_(r>=2) A^(r+1)/u^r
      = A^3 / (u^4*(1-A/u)).

For `u>2*A` this is at most `2*A^3/u^4`, proving the requested
bound for **every** permitted `p` and `u`. This also proves the
required series summability before it is used.

Using (13) and odd-order vanishing instead gives

    u^(-2) sum_(k>=2) K^(4k)*p^(k-1)/u^(2k-1)
      = K^8*p / (u^5*(1-A^2/u^2))
      <= (4/3)*K^8*p/u^5.

This proves (1). Both sums have ratio strictly less than one
under the displayed threshold; no limiting finite check is used.

For all positive times, the unconditional Fisher bounds give

    0 <= g(u) <= sum_i c_i/(u*(u+c_i))
               <= (sum_i c_i)/u^2.                  (14)

Fisher information is measurable: the polynomial variational
formula is a countable supremum of continuous functions of the
moments, and the moments of `V_u` are continuous in `u`. Thus
`g` is integrable on `[a,infinity)` for every `a>0`.

Adding an independent free semicircular noise of variance `s` to
`V_a` has the law of `V_(a+s)`, since second cumulants add and all
other noise cumulants vanish. In the definition of `chi*(V_a)`,
write the integrand as the sum of `-g(a+s)` and the finite
covariance corrections

    1/(1+s) - 1/(a+c_i+s).

Each correction is absolutely integrable, with integral
`log(a+c_i)`. Equation (14) handles the other term, so this
calculation never subtracts two divergent integrals. It proves
(2), and integrating the two bounds in (1), with the factor
one half, proves (3). The first of (3) is strictly less than
`1/24` at the threshold in question, hence strictly less than
`1/2`, as required.

For `h,t>0`, subtracting the finite expressions (2) also gives

    chi*(V_(h+t))-chi*(V_h)
      = (1/2) integral_0^t Phi*(V_(h+s)) ds.

This is the free-noise entropy identity only. It does not prove
the specified-ensemble classical-to-free transfer in section 5.

## 6. Exact large-noise leading coefficient

Let `E_u` denote conditional expectation onto `W*(V_u)` and set

    T_i = sum_(j1,j2,j3) kappa_4(C_i,C_j1,C_j2,C_j3) U_(j1,j2,j3)(S)^*.

By (13), odd-order vanishing, and orthogonality,

    sum_i ||u^(3/2) R_i - T_i||_2^2
      <= K^12*p^2 / (u^2*(1-A^2/u^2)) -> 0.          (15)

This estimate concerns all remaining orders, not a formal asymptotic
series. Write `T_i=Q_i(S)` for its finite Wick polynomial.
Because

    V_u/sqrt(u) = S + C/sqrt(u) -> S

in coordinate operator norm, `Q_i(V_u/sqrt(u)) -> T_i` in
operator norm, hence in `L2`. The former lies in `W*(V_u)`.
The best-approximation property therefore gives
`||E_u(T_i)-T_i||_2 -> 0`. Combine this fact with (15) and
projection contraction in (9) to obtain

    u^(3/2) (V_(u,i)-(u+c_i)xi_(u,i)) -> T_i in L2.

Use the exact residual-norm identity from section 3:

    u^5*g(u)
      = sum_i [u^2/(u+c_i)^2] *
          ||u^(3/2)(V_(u,i)-(u+c_i)xi_(u,i))||_2^2
      -> sum_i ||T_i||_2^2 = ||kappa_4(C)||_2^2.      (16)

There are only the following nonzero fourth cumulants:

    kappa_4(B_i,Y,B_j,Y) = kappa_4(Y,B_i,Y,B_j) = delta_ij*c,
    kappa_4(Y,Y,Y,Y) = d.

Indeed the two same-species pair blocks cross precisely in
the alternating arrangements; in every other two-`B`, two-`Y`
arrangement their noncrossing product subtracts the full moment.
All-`B` fourth cumulants vanish; words with a single `Y` or
an odd number of `B` vanish. It follows that
`||kappa_4(C)||_2^2=2*p*c^2+d^2`. This proves the first limit
in (4). For every epsilon, (16) sandwiches `g(u)` between
`(D-epsilon)/u^5` and `(D+epsilon)/u^5` at all sufficiently
large times. Integrating and using (2) proves the second
limit in (4), with coefficient `D/8`.

For the atomic `Y`, write `y_j=(2*j-p+1)/(p-1)`, `0<=j<p`.
Expanding its second and fourth powers and using

    sum j   = p*(p-1)/2,
    sum j^2 = p*(p-1)*(2*p-1)/6,
    sum j^3 = p^2*(p-1)^2/4,
    sum j^4 = p*(p-1)*(2*p-1)*(3*p^2-3*p-1)/30

gives `tau(Y^4)=(p+1)*(3*p^2-7)/(15*(p-1)^3)` and (5).
These sum formulas also follow successively by telescoping
`(j+1)^r-j^r`, so no sampling in `p` is used in their derivation.
In particular `c>1/3` and `D>=2*p/9`. If
`g(u)<=M*p^beta/u^5` held uniformly over `p` above the threshold,
taking `u` to infinity for each fixed `p` would give
`2*p/9<=M*p^beta`. This is impossible for `beta<1` as `p`
tends to infinity, proving the claimed dimension optimality.

## 7. Executable and formal evidence: what each establishes

Run the standalone standard-library program:

    $WORKSPACE/argus-live-update/.venv/bin/python research/analytic_fisher/verify.py

It recomputes and compares `exact_certificate.json`. The
`--write-certificate` option regenerates that deterministic file.
Its exact arithmetic is rational or Gaussian-rational; there
are no floating-point tolerance tests. It checks Catalan
enumeration through degree eight, direct original-adjacent
Wick orthonormality, Wick testing against a genuinely nonfree
Pauli signal, and the actual tensor signal's moments and
cumulants at the recorded finite orders and values of `p`.
Recursive cumulants are cross-checked against independent
Kreweras-Mobius inversion at the recorded orders.

For centered Pauli `X,Y,Z`, `kappa_3(X,Y,Z)=i`. At `u=4`,
testing the first residual against `P=x_Y*x_Z` gives `i` with
the manuscript's adjoint and unconjugated coefficients.
Removing the adjoint or conjugating the coefficients instead
gives `-i`. Those deliberately modified formulas are **not**
assertions of the manuscript and do not warrant `F_` claims.
The tensor tests also check the nonzero alternating cumulant
`kappa_4(B_i,Y,B_i,Y)=c`, which would incorrectly vanish if
tensor independence had been replaced by freeness.

`Main.lean` formalizes the all-order noncrossing-union and
pair-label-counting kernel described in
`statement_fidelity.md`. The fresh official Lean 4.31.0
run returned compiler exit `0`, axiom-audit exit `0`, and
`proof_holes=[]`. The immutable record is
`certificates/AF_KERNEL-6fff72e964446391.json`; the ledger
derives `closed_kernel` for `AF_KERNEL` version 3. That
record certifies `AF_KERNEL` only. It is not a Lean
formalization of sections 2--6 of this report; those are
mathematical proofs requiring independent review.

Jacobian discovery found no matching noncrossing-cumulant
operation. The inspected `matrix.partial_trace.compute`
contract was used for one bounded ancillary tensor-trace
check: tracing the `4`-dimensional identity over a `2`-dimensional
factor returns `2*I_2`. With normalized traces this is the
factorized value of `(X tensor I)(I tensor Z)(X tensor I)
(I tensor Z)` for Pauli involutions `X,Z`. It checks tensor
trace arithmetic, not the semicircular law or an all-order
claim. `jacobian_discovery.json`,
`jacobian_noncrossing_discovery.json`,
`jacobian_contract.json`, `jacobian_payload.json`, and
`jacobian_output.json` retain the exact contracts and typed
result. The adapter returned normally, server version
`0.14.0`, protocol `2025-11-25`, operation
`matrix.partial_trace.compute`, runtime `1 ms`; no timeout,
transport error or `UNKNOWN` outcome was used as evidence.

The finite experiments support implementation and orientation;
the universal quantifiers in (1)--(4) are established by
the proofs above, with the stated formal subkernel. The
main theorem's ensemble-flow, block-event and microstates
finiteness/realization branches remain open in the proof
graph. No Reviewer approval, novelty certification or
full-separation certification is claimed.
