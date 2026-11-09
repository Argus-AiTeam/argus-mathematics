# Selective four-body retention for the seven-row comparison

## Result and its scope

Use the physical, coefficient-one fermionic interaction and norm-one
increasing wedges of the staged manuscripts. Let `P_{q,l}` denote the
spin-`2q-2-l` projection on the **ordered** tensor product `V_q tensor V_q`.
Set

    R_sel = I - P_{q,4} - P_{q,10} - P_{q,12} - P_{q,14},
    gamma_sel = 4785933319001 / 10^14.

**Theorem.** For every fixed `0 < c < gamma_sel` there is an integer `q_c`
such that, simultaneously on every particle sector of the physical Fock
space and for every integer `q >= q_c`,

    H_q^2 >= c H_q + L_4(W_4 R_sel W_4*).

In particular all pair-spin deficits `l >= 15` remain with coefficient one;
so do every smaller deficit except `4,10,12,14`. Since the proposition's
`R_q^hi` is a subprojection of `R_sel`, this proves the live target
`prop:retained-blocks`, with its entire-Fock-space quantifier.

This is a proposed **structural strengthening**, with a complete
mathematical proof and a finite exact arithmetic certificate. Independent
Reviewer acceptance and publication-level novelty assessment remain
outstanding. It is not a many-particle finite-size experiment and not a
formalization of the whole theorem.

The gap coefficient alone is **not** claimed new or best known.
The staged companion already gives `4616733319001/10^14`; the gain over
that number here is exactly `423/250000`. Moreover the primary source
Qiang Gao, *Improving the lower bound on the Laughlin gap: An SDP search*,
arXiv:2610.12700v1 (October 8, 2026), Definition 2.3 and Theorem 2.4,
already treats block-dependent allowances. Its Corollary 4.3 gives
`0.0601984667...` using the same rows and sharper allowance/tail estimates;
its abstract reports `0.2190037845063196...` with larger rows.
Those are stronger gap-only results. The passages obtained from
`https://arxiv.org/html/2610.12700v1`, Sections 2-4, do not assert the
selective retained operator above. This bounded source comparison is not
a proof that no other source contains it. No result from Gao is used as
a hypothesis of the proof below.

## 1. Algebra, phases, and spin limits

For `a` in an exterior power let `B(a)` be the adjoint of left exterior
multiplication. Thus `B(a wedge b)=B(b)B(a)`. Lifting a positive
finite-body matrix preserves positivity because its positive rank-one
decomposition lifts to a sum of `B(a)*B(a)`. Lifts commute with rotations.
All sums over pair labels in `W_4` use ordered pairs.

Normal order the two inner annihilators in
`sum_{p,r} B_p* B_p B_r* B_r`. The zero-contraction term is
`sum_{p,r} B(v_p wedge v_r)* B(v_p wedge v_r)`.
Two contractions give `H`, since the restriction to two particles is a
projection. On three particles `H=W_3 W_3*`. Subtracting the already
determined two-body coefficient determines the three-body coefficient.
There are no terms of higher degree. Consequently, on **all** sectors,

    H^2 = H + L_3(W_3 (W_3*W_3-I) W_3*) + L_4(W_4 W_4*).       (1)

No unordered-pair factor of two occurs.

Take the lowering basis with `v_0=-e_0 wedge e_1`. Simultaneous lowering
and the binomial theorem give, for `i<j` and `i+j=p+1`,

    v_p(i,j) = (i-j) sqrt((q)_i (q)_j p! /
                              (q (2q-2)_p i! j!)).

It is zero otherwise. Here `(s)_p` is a falling factorial. Normalization
follows by extracting coefficients from

    sum_{i,j} (i-j)^2 binom(q,i) binom(q,j) x^(i+j)
      = 2 q x (1+x)^(2q-2).

The limiting coefficient is
`v_p^*(i,j)=(i-j)sqrt(p!/(2^p i!j!))`.
Changing all pair phases simultaneously does not change `H`, either
wedge map, or any target spin projection.

For completeness the three-body eigenvalue computation does not rely
on a finite-flux extrapolation. In the antisymmetric-first-two tensor
model, `W_3` is `sqrt(3)` times antisymmetrization, so its Gram operator
is the compression of `I-P_13-P_23`. In the multiplicity-free spin block
at deficit `z`, the two compressed swaps have the same scalar `b_z`.
A normalized highest vector has coefficients `s_p` on
`v_p tensor e_{z-p}`, satisfying

    s_{p+1}/s_p =
      -sqrt((z-p)(q-z+p+1)/((p+1)(2q-2-p))).

Testing the swapped vector against `v_0 tensor e_z` uses only the
ordered triples `(0,z,1)` and `(1,z,0)`. The preceding pair formula gives

    2 b_z = (-1)^(z-1) (q)_z/(2q-2)_z
              * [ z(2q-z-1)/q + (z-1) ].

The first contribution is absent at `z=0`, which separately gives
`2 b_0=1`. Simplifying the bracket proves for every allowed `z`

    q_z(q) := -2 b_z
      = (-1)^z (q)_z/(2q-2)_z * (3z-1-z(z+1)/q).              (2)

In particular `q_z=-1` at `z=0,1,3`, so `W_3` annihilates those
sectors. For fixed `z`, `q_z(q)` tends to `(3z-1)(-1/2)^z`.

The other coupling limits are equally finite. For spins `j_1,j_2`,
the highest-vector adjacent ratio at deficit `z` is

    -sqrt((z-p)(2j_2-z+p+1)/((p+1)(2j_1-p))).

When `j_2/(j_1+j_2)` tends to `u^2`, normalization with sign
`(-1)^z` at `p=0` gives the polynomial
`(uX-vY)^z/sqrt(z!)`, where `v=sqrt(1-u^2)`. Normalized total lowering
gives multiplication by `(vX+uY)/sqrt(T-z+1)` in each fixed descendant.
Thus the limiting vector at deficit `T` is

    (uX-vY)^z (vX+uY)^(T-z) / sqrt(z!(T-z)!).                 (3)

The monomials `X^p Y^(T-p)/sqrt(p!(T-p)!)` are orthonormal. The change
of variables is orthogonal; hence these coupled vectors are normalized
and mutually orthogonal. Highest weights, followed by normalized
lowering, also prove the finite SU(2) tensor decomposition: the
resulting orthogonal irreducible dimensions sum to the tensor-product
dimension. Fixed-deficit limits here are limits of finitely many
recurrences with nonzero normalization constants, not varying-rank
matrix limits.

## 2. Exact finite comparisons and the selective target

Use **exactly** the seven staged rows, with `P=10^7`, `lambda=ell/P`,
`i=p+j-t`, and

    alpha_pj = (a_pj/P) sqrt(2^(p-t) t! i!/(p! j!)).

Define `F_rho=lambda B_t + sum alpha_pj c_i* c_j B_p` and
`K_q=(2q-1) integral sum F_rho(g)*F_rho(g) dg >= 0`.
The single CAR reordering `c_i c_k*=delta_ik-c_k*c_i` gives

    K_q = eta H + A_3 + A_4,
    eta = sum lambda^2 = 93527408868499/10^14.                 (4)

The cubic coefficient before wedging consists of the two cross terms
`lambda alpha` and the `alpha alpha delta_ik` term. Each preserves
`T=p+j<=15`. In the limiting coupled basis from (3), its spin trace
is exactly

    e_z = sum_{rho,T} [2 lambda s_{z,T,t} sum_{p+j=T}alpha_pj s_{z,T,p}
                         +(sum_{p+j=T}alpha_pj s_{z,T,p})^2].

Finite-flux traces converge to these finite expressions. The independently
recomputed positive margins are in `exact_certificate.json`, for
`z=2,4,5,...,15`. Their million-scaled floors agree with the staged
table, but the verifier checks the actual rational margins, not only
those floors. Since `d_{3,z}/d_a -> 3/2`, all the strict inequalities
persist for sufficiently large `q`. Together with the three null
sectors of (2) this gives

    A_3 <= L_3(W_3 sum_{z<=15} q_z(q) R_{3,z} W_3*).           (5)

For the four-body term let `k=p'+l-t` and `O_{p,j,k}=c_k c_j B_p`.
Its unaveraged coefficient is

    -sum alpha_pj alpha_p'l O_{p,j,k}* O_{p',l,i}.             (6)

Both sides have orbital-index sum `T+1`, where
`T=p+j+k=p'+l+i<=23`. A spin of deficit `D` has its highest vector
at `T=D`, so (6) has no spin block `D>23`, exactly at finite flux.
In `V_q tensor wedge^2 U_q` the second pair spin is `q-r`, `r` odd,
and the spin in block `D` is `2q-1-D`. The copy set is
`R_D={1,3,...} intersect [1,D]`, and `d_D=4q-1-2D`.
The two applications of (3) give

    S_r(D,T;p,j,k) =
      sqrt(2) s^{1/sqrt(2)}_{r,j+k,j}
              s^{1/sqrt(2)}_{D-r,T-r,p},                     (7)

antisymmetric in `j,k`. Their finite-flux versions are normalized
intertwining descendants. At `r=1` the pair phase is exactly the
negative pair phase already fixed above.

Let `w_{Dr}^q` be the wedged highest vectors, and let `G_D` be the
limiting Gram matrix of their columns. Schur averaging (6) gives
copy matrix `(d_a/d_D) E_D^q`, where

    (E_D)_{rs} =
      -sum_{rho,p,j,p',l;T>=D}
          alpha_pj alpha_p'l S_r(D,T;p,j,k) S_s(D,T;p',l,i),   (8)

and `E_D^q -> E_D`. Haar averaging keeps the matrix between equivalent
copies: an intertwining average is scalar on the spin factor, with
that scalar determined by its partial trace. No cross-copy term is
dropped.

The original target contributes only copy `r=1`, namely the matrix
`(d_D/d_a) chi`, `chi_{rs}=1_{r=s=1}`. Its deficit on `V_q tensor V_q`
is `l=D-1`. Define

    t_D = 1 for D in {5,11,13,15}, and 0 otherwise;
    eps_D = 3/10^6 for D in {11,13,14,15,16,17,18,19,20},
            and 0 otherwise.                                (9)

The **new exact finite comparison** is

    G_D (2 t_D chi - E_D + eps_D I) G_D >= 0,   1<=D<=23.     (10)

This retains substantially more target than a gap-only comparison:
only `l=4,10,12,14` are spent. All other targets, even those overlapping
the auxiliary support, are unspent.

Here is the arithmetic and its independent checks. Expand (3) by
repeated polynomial multiplication; its integer coefficients are

    U(c,z,T,p) = [X^p Y^(T-p)] (X-Y)^z(cX+Y)^(T-z).

The verifier cross-checks these against the finite binomial sum,
checks the coupling orthogonality and pair normalization, and derives
`e_z` from the row integers. For (8) write
`u_r=1/(r!(D-r)!)`, `E=diag(sqrt(u)) Y diag(sqrt(u))`.
Multiplying the two row factors and the two factors from (7) cancels
the radical and leaves the rational scalar

    -a_pj a_p'l / P^2
      * 2^(1-2T+p+p'-t+(r+s)/2) i! k! t!/(T-D)!

times
`U(1,r,j+k,j) U(1,D-r,T-r,p)
 U(1,s,l+i,l) U(1,D-s,T-s,p')`.
This derives every entry of `Y` directly from the rows.

Independently form each physical Slater coefficient of `w_{Dr}^*`
by choosing the two pair indices from an increasing quadruple `A`
of sum `D+1`, multiplying the normalized pair coefficient by (7),
and including the actual permutation sign of the wedge.
After dividing by `sqrt(u_r / product_{a in A} a!)` it is rational,
called `L_r(A)`. The verifier checks cancellation by exact positive
rational square roots before comparing to the factorial shortcut.
Consequently

    G=diag(sqrt(u)) Z diag(sqrt(u)),
    Z_rs=sum_A L_r(A)L_s(A)/product_{a in A} a!.

Inequality (10) is therefore the positive diagonal congruence of

    Z [diag((2 t_D 1_{r=1}+eps_D)u_r)
          -diag(u) Y diag(u)] Z.                             (11)

All entries of (11) are rational. Exact symmetric Schur complements
give positive pivots and a **zero** final residual for every `D`;
the complete entries and pivots are in the certificate. No inverse
of `G` is used. This is a separate PSD test from the manuscript's
characteristic-coefficient test. The original, less selective,
certificate with `t_D=1`, `eps_D=3/10^6` is checked as well.

The adapter independently returns inertia `(3,0,3)` for the `D=11`
comparison, retaining the exact source matrix. Its discovery, contract,
upper-triangular payload, output, version `0.14.0`, protocol
`2025-11-25`, and exit status are saved in dedicated JSON files.
The first full-coordinate payload was rejected by the adapter's
symmetric-coordinate validation. That error and its exact payload are
preserved separately; they are not a mathematical conclusion.

## 3. Kernel-safe, pair-relative finite-flux transfer

This step is essential: (10) alone does not establish an eventual
operator theorem. For any finite map `W` and self-adjoint `C`,

    (W*W) C (W*W) >= 0  iff  W C W* >= 0.                    (12)

Indeed both say that the form of `C` is nonnegative on
`range(W*)=range(W*W)=(ker W)^perp`. This is a statement at a fixed
matrix, not a continuity assertion about ranges.
The discarded shortcut is genuinely invalid: `W_n=diag(1,1/n)` and
`C=diag(1,-1)` have a nonnegative limiting compressed form, but
`W_n C W_n*` has eigenvalue `-1/n^2` at every finite `n`.
The manuscripts explicitly avoid, rather than assert, that shortcut.

All the highest-vector annihilators for `D<=23` involve only modes
`0,...,24`. On the fixed local exterior algebra define

    Delta_q |A> = product_{x in A} d_q(x) |A>,
    d_q(x)=sqrt((q)_x/q^x),
    r_p(q)=sqrt((2q)^p/(2q-2)_p).

For `q>=24`, `0<Delta_q<=I`, `r_p>=1`, and both `Delta_q` and its
inverse converge in norm to `I`. Comparing the factors of every
removed mode proves **exactly**

    B_p = r_p Delta_q^-1 B(v_p^*) Delta_q,
    B(v_p wedge e_j wedge e_k)
      = r_p/(d_q(j)d_q(k))
          Delta_q^-1 B(v_p^* wedge e_j wedge e_k) Delta_q.    (13)

The inverse diagonal acts on the output sector. Repeated removed
labels give zero on both sides. With
`h_* = sum_{p=0}^{23} B(v_p^*)*B(v_p^*)` and
`h_q = sum_{p=0}^{23} B_p*B_p`, (13) gives

    Delta_q h_* Delta_q <= h_q.                             (14)

For each fixed `D` put `b=(p,j,k)`, `p+j+k=D`, `j<k`, and
`A_b=c_k c_j B(v_p^*)`. Define real matrices

    beta^q_{rb}=S_r^q(D,D;p,j,k) r_p/(d_q(j)d_q(k)),
    C_D^q = t_D (d_D/d_a)chi - E_D^q + eps_D I,
    M_q = (beta^q)^T C_D^q beta^q.

All these are fixed finite matrices, and `M_q -> M_*`. Equations (13)
identify the lifted form with

    Delta_q sum_{b,c} (M_q)_{bc}
                 A_b* Delta_q^-2 A_c Delta_q.               (15)

By (10), (12), and positivity of the lift,
`sum (M_*)_{bc} A_b*A_c >= 0` on every local particle sector.
Importantly, `M_*` itself need not be positive.

On the finite Hilbert direct sum of local output spaces set

    R_q = (M_q-M_*) tensor Delta_q^-2
                 + M_* tensor (Delta_q^-2-I).

Its norm is at most
`||M_q-M_*|| ||Delta_q^-2|| + ||M_*|| ||Delta_q^-2-I||`,
which tends to zero. This also handles the different output particle
sectors by taking their finite direct sum. Contractions have norm at
most one, so

    sum_b ||A_b phi||^2 <= C_D <phi,h_* phi>,

where `C_D` is the largest multiplicity of a pair label among these
triples. Applying this bound to the error in (15), with
`phi=Delta_q psi`, then using (14), proves

    sum_{r,s}(C_D^q)_{rs} B(w_{Dr}^q)*B(w_{Ds}^q)
       >= -rho_{q,D} h_q,       rho_{q,D}->0.                (16)

This is the kernel-safe relative bound; it requires neither constant
rank nor positivity of the intermediate coefficient matrices.
The two underlying norm inequalities and the exact coefficient
identity are also isolated in `Main.lean`; its statement-fidelity
document explicitly limits what Lean certifies.

Order local modes before spectator modes. The isometry taking a local
wedge tensor a spectator wedge to their ordered product sends each
local annihilator to its local action tensor the identity: the removal
sign counts earlier local modes only. The diagonals and all even
quadratic expressions in (13)-(16) likewise act on the local factor
alone. Thus (16) holds on full physical Fock space, with the same
constant for every number of occupied spectator modes.

Finally average (16) over rotations. Schur averaging gives
`d_a integral h_q(g) dg=24H`. There are only 23 comparison blocks, so
their total error is bounded by
`24 sum_D rho_{q,D} H = o(1)H`, uniformly over all particle numbers.

## 4. Allowance, infinite tail, and conclusion

Write `T_spent=L_4(W_4 sum_{D in {5,11,13,15}} P_{q,D-1} W_4*)`.
Averaging (16) says

    T_spent - A_4 + sum_D eps_D X_D >= -o(1) H,
    X_D=d_a integral sum_r B(w_{Dr}^q(g))*B(w_{Dr}^q(g)) dg.

Before wedging, the coupled highest vectors have orthonormal rows in
the uncoupled basis `v_p tensor (e_j wedge e_k)`, `p+j+k=D`, `j<k`.
Bessel, followed by the contraction bound, gives

    sum_r ||B(w_{Dr}^q)psi||^2
       <= sum_{p+j+k=D,j<k} ||c_k c_j B_p psi||^2
       <= sum_{p+j+k=D,j<k} ||B_p psi||^2.

There are `n_D=floor((D+1)^2/4)` triples. Each pair vector contributes
`H/d_a` after Haar averaging, so `X_D<=n_D H`. The exact set (9)
therefore has allowance price

    sum_D eps_D n_D = 658 * 3/10^6,                          (17)

not the manuscript's uniform price `1222 * 3/10^6`. This blockwise
pricing is not claimed new; its use with the selective **unspent**
operator is the strengthening being proposed.

For the infinite three-body tail use (2). For `16<=z<=q` its bracket
is positive, so only odd `z` are negative. A normalized highest vector
`sum_{p=0}^z s_p v_p tensor e_{z-p}`, after wedging and lifting, has
quadratic form

    ||sum_p s_p c_{z-p}(g)B_p(g)psi||^2
       <= sum_{p=0}^z ||B_p(g)psi||^2.

Its orbit resolves the spin projection with factor `d_{3,z}`.
Consequently the tail is at least `-delta_q H`, with

    delta_q=sum_{17<=z<=q,z odd}
                (d_{3,z}/d_a)|q_z(q)|(z+1).

For `q>=4`, the falling-factorial ratios are nonincreasing,
`(q)_z/(2q-2)_z <= (2/3)^z`, and `d_{3,z}/d_a<=2`.
The summands, extended by zero for `z>q`, are dominated by the
summable sequence `6z(z+1)(2/3)^z`. Dominated convergence proves

    delta_q -> (3/2) sum_{z>=17,z odd}(3z-1)(z+1)2^-z
             = 61/4096.                                    (18)

The last equality is an exact geometric-series computation, not a
truncation: with `z=17+2m`, the polynomial is `900+208m+12m^2`.
The verifier evaluates the three resulting series rationally.

Combining (1), (5), (16)-(18), and (4) now gives on full Fock space

    H_q^2 >= K_q
        + (1-eta-delta_q-658*(3/10^6)-o(1)) H_q
        + L_4(W_4 R_sel W_4*).

The coefficient tends to `gamma_sel`. For any fixed `c<gamma_sel`,
choose the **single** flux threshold after the finitely many strict
three-body comparisons hold and the scalar error is less than
`gamma_sel-c`. All error estimates already hold on full Fock space;
this choice therefore makes no reference to particle number.
Discard `K_q>=0`. This proves the theorem.

Since `gamma_sel>1/25` and `R_sel>=R_q^hi`, dropping the positive
lift of `W_4(R_sel-R_q^hi)W_4*` proves the original proposition.
No false literal manuscript assertion was found in this route; no
refutation of the original proposition or its stated lemmas is claimed.

## Reproduction and remaining independent obligations

From the campaign root:

    python3 research/retained_blocks/verify.py

The standard-library script reads both staged row files, requires them
to agree, rederives every rational matrix and margin, replays the
singular Schur complements, and compares all exact results with
`exact_certificate.json`. It checks finite-flux Gram normalization
independently in 117 small `(q,z)` cases; those cases are diagnostics,
not the proof of (2) for arbitrary `q`. It also binds the saved typed
Jacobian result to the independently recomputed source matrix.
No service or floating-point eigensolver is needed to replay it.

The real Lean 4.31.0 compiler run has `exit_code=0`, `proof_holes=[]`,
and `audit_exit_code=0`. Its source-bound certificate is
`lean/certificates/C_FORMAL_TRANSFER-bab17824d6bd220b.json`;
`lean_verify_result.json` records the full invocation and result.
This certifies the two abstract transfer inequalities and rational
coefficient arithmetic identified in `statement_fidelity.md`, not the
entire spherical theorem.

The independent Reviewer must inspect (especially) the translation
`D=l+1`, the selective target in (10), the annihilator conjugation and
output-sector diagonals in (13)-(16), and the all-sector quantifier in
the conclusion. The ordinary proof is not replaced by the exact tables
or by the smaller Lean formalization.
