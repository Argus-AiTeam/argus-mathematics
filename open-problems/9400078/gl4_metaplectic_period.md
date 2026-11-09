# The rank-six metaplectic period and the missing saving

## Outcome

**No positive saving is proved.** The correct even-rank specialization of
Takeda's integral gives the meromorphic identity (3.3) below, with the
distinguished ramified factor retained. Its Eisenstein normalizer is
`L^T(6z,eta^6)`, not the denominator `L^S(z,eta)` of the degree-20 quotient.
Neither the normalization nor the known numerator holomorphy supplies an
estimate beyond that quotient. The precise unresolved automorphic estimate
is (5.2).

The established comparison remains `t<=5/22`. In particular, neither an
explicit `delta>0` nor the endpoint `19/84` has been obtained. This is a
source specialization and an incomplete mathematical attempt, not a new
reduction, an automorphic counterexample, or a publishable result.

The conditional implication from any requested saving to
`t<=5/22-delta/4` is proved in Section 6 using the previously reviewed
contour and local-detection arguments. This implication does not supply
the saving.

## 1. Setting and source dependencies

Use the family, coefficients, cutoff, and contours of
`gl4_degree20.md`, `gl4_degree20_residues.md`, and
`gl4_degree20_sparse_twists.md`. Thus pi is unitary cuspidal on GL4(A_Q),
Pi=Lambda^2(pi) is cuspidal on GL6(A_Q), and omega=omega_pi. At p>=5,

    pi_p = Ind(sigma |det|^t tensor sigma |det|^-t),
    0<=t<1/2,

where sigma is unitary supercuspidal on GL2(Q_p). The finite campaign
set S contains all other bad places but excludes p. Put X=p^ell.
The auxiliary primes q lie in [Q,2Q], are outside S, and differ from p.
In the dense sector, eta=chi^2 with chi^4!=1; eta is nonreal and primitive
of conductor q. All twists eta are even.

For each fixed pi,p,S,g, the desired bound is

    |R_complex(X,X^(2/21))|
        <<_(pi,p,S,g,epsilon) X^(232/231-delta+epsilon),    (1.1)

for every epsilon>0 and all sufficiently large ell. One explicit
`0<delta<=1/231` must work throughout the family. The constant and
the threshold are allowed to depend on the fixed family member; uniform
constants in sigma or pi are not an additional acceptance requirement.

The new source inputs, recorded as assumptions on
`C_GL4_METAPLECTIC_PERIOD`, are:

* Takeda [A], **arXiv:1005.1979v8**, Section 3, Proposition 3.16,
  equation (5.2), and Proposition 5.5: the even-rank integral, its
  unramified calculation and almost Euler product, and pointwise local
  nonvanishing.
* Takeda [B], **arXiv:1506.04791v1**, Section 4.1, equations (4.5) and
  (6.1), and Theorem 6.2: normalized induction, the normalizing factors,
  and the normalized Eisenstein pole theorem.
* [B], Theorem 7.1: holomorphy of the incomplete twisted symmetric-square
  L-function away from its possible simple poles at 0 and 1, in the
  finite-order normalizing-character case used here.

The primary-source reader's formulas, hypotheses, exact-version locators,
and reported printed discrepancies are preserved in
`literature/takeda-even-rank-source.txt`. That file is a faithful record
of the returned source reading, not a verbatim source transcription.
Independent Reviewer attribution of these three new assumptions is pending.
The formulas here use [A]'s even-rank central-character calculation and
[B]'s explicit later normalization; they do not silently use the discrepant
lines noted in the reading.

The existing algebra, contour, and sparse-sector certificates have not
changed and were not replayed. The previous coefficient-only inference,
inherited-envelope bootstrap, and termwise-convexity inference remain
retired. Their failure is not a failure of all automorphic methods.

## 2. The actual even-rank specialization

Set

    w = omega_Pi = omega^3,       lambda = omega^-1 eta.

The first equality follows from
`det(Lambda^2 V)=(det V)^3`. No square root of omega is assumed.
Use `s` for [B]'s normalized-induction variable, `u` for [A]'s older
unnormalized variable, and `z` for the L-function variable. Then

    u=s+1/2,       z=2u-1/2=2s+1/2.                      (2.1)

Let G^(2) be the square-determinant subgroup of GL6, and P=P_(5,1).
For a cusp form phi in Pi, the period is

    Z_eta(s) =
      integral_(Z(A)G^(2)(Q)\G^(2)(A))
        phi(g) Theta_eta(kappa(g)) E_eta(kappa(g),s;f^s) dg. (2.2)

Here the two genuine factors descend jointly, with product central
character w^-1. It is essential not to replace (2.2) with the odd-rank
integral over the full GL6 quotient.

The exceptional form and the inducing representation are

    Theta_eta in vartheta^psi_(lambda w^-2)
                  = vartheta^psi_(omega^-7 eta),
    tau_eta = theta_w metaplectic_tensor tilde(lambda^-3)
            = theta_(omega^3) metaplectic_tensor
                                      tilde(omega^3 eta^-3),
    f^s in normalized-Ind_(tilde P)^(tilde GL6)
                                      (tau_eta tensor delta_P^s).

The representation theta_w here is on the metaplectic GL5. In [A]'s
older Levi notation the inducing object is theta_(omega^3,eta^-3).
The difference is the change
`theta_(a,b)^old = theta_(a,a*b)^new`, not a different twist.

For even rank r, [B]'s normalizing character is `w^2 lambda^r`.
At rank six it is exactly

    c_eta = w^2 lambda^6
          = omega^6 (omega^-1 eta)^6 = eta^6.             (2.3)

For a bad set T suitable for the section f^s, the normalized series is

    E_eta^*(g,s) = L^T(6z,eta^6) E_eta(g,s).              (2.4)

At an unramified finite place of odd residual characteristic, the
specified spherical local integral and intertwiner are

    Z_v(s) = L_v(z,Pi,Sym^2 tensor lambda)/L_v(6z,eta^6),
    A_v(s)f^s_(0,v)(1) = L_v(6z-5,eta^6)/L_v(6z,eta^6).  (2.5)

The numerator `6z-5=12s-2` in the intertwiner must not be confused with
the denominator `6z=12s+3` in (2.4). The possible normalized Eisenstein
poles s=+-1/4 become z=1,0.

The exceptional character condition is `eta^6=1`. Nonreal eta of
order 3 or 6 are therefore not excluded from that condition. Equivalently,
for eta=chi^2 it is `chi^12=1`. There are at most twelve such chi at
each q. The existing sparse-sector lemma, without a new proof, bounds
their grouped residue contribution by O(X^(1+epsilon)). This observation
only keeps the source theorem correctly scoped; enlarging that sparse
sector supplies no dense-sector saving and is not a successful endpoint.

### Exact character-substitution certificate

The change from exponent vectors in (w,lambda) to those in (omega,eta)
is the integer matrix M. The four columns of D represent, in order,
`w^2 lambda^6`, `w^-2 lambda`, `lambda^-3`, and
`w^-1 lambda^-3`. Thus

    M = [[3,-1], [0,1]],
    D = [[2,-2,0,-1], [6,1,-3,-3]],
    M D = [[0,-7,3,0], [6,1,-3,-3]].                    (2.6)

The inspected Jacobian operation `matrix.symbolic.multiply.compute`
evaluates precisely (2.6), over Q with no field variables. Its dedicated
files are `jacobian/metaplectic-character-{discovery,contract,input,output}.json`.
The recorded result used server 0.14.0, protocol 2025-11-25, and returned
the displayed matrix with adapter exit 0, no error, and no timeout.
This certifies the character substitutions only, not the analytic estimate.

The operation can be independently rerun from the campaign root:

    /home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run --operation matrix.symbolic.multiply.compute --payload-file research/jacobian/metaplectic-character-input.json

## 3. Restoring every omitted factor, especially p

For each eta choose a finite bad set T=T_eta containing infinity,
the places above 2, all ramified representation/twist data, the
campaign set S, p, q, and any extra places required by the section.
Write T_f for its finite places. It is not assumed that one
twist-independent section or one common T works for all eta.

The finite local integrals factor; the archimedean part is grouped in
[A]'s almost Euler product. Put

    B_eta(z) = Z_infinity((z-1/2)/2)
                 product_(v in T_f) Z_v((z-1/2)/2),
    P_eta(z) = the period (2.2) with E replaced by E^*,
                 evaluated at s=(z-1/2)/2.

Canceling exactly the bad-place Tate factors in [A], equation (5.2),
gives, initially sufficiently far right and then meromorphically,

    P_eta(z) = L^T(z,Pi,Sym^2 tensor lambda) B_eta(z).     (3.1)

One can choose data nonzero at a prescribed regular point, so B_eta
need not be identically zero. This does not imply it is everywhere
nonzero, nor supply a lower bound uniform in eta.

Define the finite restoration product

    J_eta,T(z) =
      product_(v in T_f outside S)
        L_v(z,Pi,Sym^2 tensor lambda)/L_v(z,eta).          (3.2)

The identity for the campaign's actual quotient is

    F_eta^S(z)
      = [P_eta(z) J_eta,T(z)]/[B_eta(z) L^T(z,eta)].       (3.3)

Indeed, multiply the incomplete numerator in (3.1) by its omitted
factors in T_f outside S, and do the same for the degree-one
denominator. This yields exactly `L^S(z,Pi,Sym^2 tensor lambda)/L^S(z,eta)`.
The equality is one of meromorphic functions; zeros of B_eta can cancel
against P_eta and must not be counted as extra poles of the result.

At q, Pi and omega are unramified and eta is a nontrivial conductor-q
character. Both local L-factors in (3.2) are 1: the twisted unramified
Weil parameters have no inertia invariants. This does not identify
the local test-vector integral Z_q with 1 or control its size.
Also eta^6 may be unramified at q, so its normalizing Tate factor
must still be omitted according to T.

At p, the previously reviewed representation identity gives

    J_eta,p(z) = L_p(z,R20 tensor eta_p)
              = product_j (1-beta_j eta(p) p^-z)^-1,
    max_j |beta_j| = p^(4t).                             (3.4)

Here eta_p is unramified, |eta(p)|=1, and for t>0 the extreme root
`beta=p^(4t)` occurs once. This is exactly the retained Euler factor
that detects t in the local coefficient sequence. The ramified
test-vector integral Z_p is not an identification with (3.4).
Omitting J_eta,p when using the incomplete integral would change the
quantity being estimated and lose the required local detection.

## 4. What normalization and holomorphy do not settle

[B]'s incomplete-numerator theorem does not assert holomorphy after
the factors (3.2) have been restored, or after division by L^S(z,eta).
Even in the twists for which P_eta is holomorphic, (3.3) contains the
same degree-one denominator as before.

This distinction can be seen without a heuristic about zero spacing.
In the region Re(z)>1/6, the Euler product

    L^T(6z,eta^6)

is absolutely convergent and nonzero. Therefore, at a zero rho of
L^T(z,eta) with Re(rho)>1/6 and multiplicity m, the scalar

    L^T(6z,eta^6)/L^T(z,eta)

has a pole of order m. The normalizer itself supplies no zero there.
This is a statement about that scalar, not a proof of an uncanceled
pole of F_eta^S: the actual cuspidal period or the other factors can
still cancel it.

For example, at a simple zero rho where P_eta and J_eta,T are
holomorphic and B_eta(rho)!=0, the potential residue is

    P_eta(rho) J_eta,T(rho) ghat(rho) X^rho
       / [B_eta(rho) (L^T)'(rho,eta)].                    (4.1)

No estimate for this expression follows from qualitative holomorphy.
For a multiple zero, write L^T(z,eta)=(z-rho)^m d_eta(z),
with d_eta(rho)!=0. If P_eta J_eta,T/B_eta is holomorphic there,
its quotient by d_eta has a Taylor series; its coefficients through
degree m-1 determine the principal part of F_eta^S. Their cancellation
is not implied by the existence of that Taylor series.

In full generality use the reviewed Laurent formula: if the actual
principal part of F_eta^S is sum_(j=1)^M b_(-j)(z-rho)^(-j), its
contribution is

    X^rho sum_(j=1)^M b_(-j)
      sum_(r=0)^(j-1) [ghat^(r)(rho)/r!]
                       [(log X)^(j-1-r)/(j-1-r)!].       (4.2)

This includes numerator poles and restored local poles as well as
denominator zeros. No pole set is replaced by a list of simple zeros.
Only actual poles after all meromorphic cancellations count.

The exterior-square origin has been used in w=omega^3, in (2.3),
and in the local restoration (3.4). No additional identity for the
cuspidal pairing exploiting that origin has been obtained. In
particular, local existence of the invariant line does not by itself
factor a global period by L^S(z,eta).

## 5. The precise remaining automorphic lemma

Let h>0 and c>1 be admissible contour boundaries from the reviewed
contour argument, and let H_j be its common good heights for each
fixed finite twist family. Define

    F_eta,period(z) =
        P_eta(z) J_eta,T(z)/(B_eta(z) L^T(z,eta)),

and let P_eta,actual denote all its actual poles with -h<Re(rho)<c.
Then set

    R_period(X,Q) =
      lim_j sum_(q in [Q,2Q]) 1/(q-1)
        sum_(chi^4!=1) conjugate(eta(X))
          sum_(rho in P_eta,actual, |Im(rho)|<H_j)
            Res_(z=rho) [F_eta,period(z) ghat(z) X^z].    (5.1)

The eligible primes and eta=chi^2 are as in Section 1. By (3.3) and
the already reviewed contour-grouping theorem,

    R_period(X,Q) = R_complex(X,Q).

No new exchange of the height limit with the q limit is made. For
each fixed Q the family is finite and the height limit is taken first.

**Unresolved lemma (`C_GL4_PERIOD_SAVING_LEMMA`).** For these actual
cuspidal periods, prove that one explicit uniform 0<delta<=1/231 gives

    |R_period(X,X^(2/21))|
       <<_(pi,p,S,g,epsilon) X^(232/231-delta+epsilon)     (5.2)

for every epsilon>0 and all sufficiently large X=p^ell.

A proof must introduce additional automorphic information about the
periods, not just substitute (3.1) into the original quotient. It must
bound the q- and eta-dependence of the relevant period/local-factor
combination. Proposition 5.5's pointwise choices supply no quantitative
control of the varying exceptional vectors, sections, or inverse
bad-place factors. Separate inverse bounds for B_eta are not logically
necessary if one controls the combination directly, but they cannot be
assumed from pointwise nonvanishing.

The source contracts provide neither such a combined estimate nor
divisibility at every denominator zero to its full multiplicity.
Controlling only the normalized Eisenstein poles at z=0,1 is not
controlling (5.1). Bounding individual absolute residues is not required
by (5.2), but the phases and all multiplicities must be retained if
one seeks cancellation instead.

Thus (5.1) is currently an exact rewriting of the old obstruction,
not a new reduction that shortens the proof gap. The normalization-only
inference is retired; the stronger automorphic lemma remains unproved,
not refuted. No further coefficient-only diagnostic is substituted for it.

## 6. Consequence of any genuine saving

For each fixed `0<delta<=1/231`, the requested residue estimate is
equivalent, under the reviewed inputs, to `t<=5/22-delta/4`.

**Proof.** The full contour identity, the diagonal extraction, and the
real-sector estimate already give, at Q=X^(2/21),

    R_complex(X,Q) = N(Q) a(p^ell) + O_epsilon(X^(1+epsilon)),
    N(Q) asymptotic to Q/log Q.                          (6.1)

This reuses the established left-boundary and real-sector estimates;
it does not re-prove them using Takeda's integral.

Put alpha_delta=232/231-delta. Since delta<=1/231,
alpha_delta>=1. If (1.1) holds, (6.1), division by N(Q), and absorption
of log Q into an arbitrarily small epsilon give

    |a(p^ell)| <<_epsilon X^(alpha_delta-2/21+epsilon)
                        = X^(10/11-delta+epsilon).

The reviewed local radius formula then implies

    4t<=10/11-delta,       t<=5/22-delta/4.               (6.2)

Conversely, if (6.2) holds, the previously established local estimate

    |a(p^ell)| <= binomial(ell+19,19) X^(4t)

and (6.1) imply (1.1), since its exponent alpha_delta is at least 1.
The polynomial in ell is absorbed into any positive epsilon. This
works for every sufficiently large ell, not a selected subsequence.
At delta=1/231, (6.2) is t<=19/84. QED.

The strongest inherited result used here remains t<=5/22 and
R_complex=O(X^(232/231+epsilon)). The current specialization changes
neither exponent. A strongest-applicable-literature comparison,
an exact prescribed-local global-family construction, novelty,
significance, and independent correctness review remain open; no
new positive bound exists here to submit to a novelty comparison.
