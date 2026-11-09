# Ramified-type density: a weighted estimate and explicit weight repair

Publication assessment, 2026-11-04: the host's round-4 mathematical review
accepted (53), using the augmented weights, at 00:19:05Z. Section 24 freezes
that statement and assesses its publication claim. The recommendation is
positive for independent publication review, **not** a `verified_new`
certificate. The campaign remains incomplete. Earlier round-specific
descriptions of open proof obligations are retained as the development
record; the current mathematical verdict is the one recorded in
`roles/reviewer/progress.json`, `unweighting_continuation_review`.

## Result and scope

The requested unconditional bound

    #{pi in F(q): t_pi >= tau} << q^(3-4 tau+epsilon),
    0 < tau <= 1/8,                                           (1)

now has an **independently reviewed unconditional proof with explicitly
changed technical weights**, in Sections 15-22. Publication-level
originality and significance remain unverified.
The host Reviewer has independently supported Sections 2-14, including
the actual support bound, all seven nonidentity exclusions and the
positive pretrace proof of the weighted estimate (38).

The Reviewer's literal proposed lower bound for the individual weights
(22) does not follow from the allowed type choice: Section 15 constructs
a fixed conjugate type for which all these identity Whittaker weights
vanish. This is a local normalization obstruction, not an automorphic
counterexample. The repair uses finitely many fixed type conjugates and
archimedean translates, and character-matched projectors at the other
fixed bad places. It leaves the original counted family and K0(q)
unchanged. The new weights are defined separately in (49); both their
lower bound and their weighted upper bound are proved separately.
Nothing here relabels (49) as (22), or asserts (13) for every original
type position.

The inherited pointwise comparison `t <= 5/22` and the earlier degree-20
identities are unchanged. Compared with that work, the new calculation is
a local spectral test without a Dirichlet denominator, not a better
pointwise bound. Compared with the first density
round, Section 8 bounds the Whittaker identity distribution, not merely
A_k(1). Compared with the second reviewed round, the improvement is a
weighted global estimate in the required growing range. The present
improvement is the reviewed conversion to the unweighted count through a
uniformly nonzero finite test and exact prime-level norm cancellation,
not another finite classification or a smaller local norm.

Fix `p >= 5` and a unitary supercuspidal representation sigma of GL2(Q_p).
The local family is

    pi(t) = Ind(sigma |det|^t tensor sigma |det|^-t),
    0 <= t < 1/2,                                           (2)

with normalized induction. The global mission retains cuspidality of pi
and its exterior-square transfer, so the recorded comparison applies.
For global notation, fixed-data prime level means fixed central character,
fixed compact level away from q, bounded archimedean spectrum, and a
Gamma_0(q) factor. Each representation is counted once. The supplied mission
and referenced mission record do not give further values for this fixed
data; the local results below do not require such a choice. No assertion
about a differently chosen global family is substituted for (1).

## 1. Known inputs and the invisible standard Euler factor

The source statements and versions are recorded in
`literature/gl4-ramified-density-sources.txt`. Section 25 distinguishes the
seven source conclusions from the deductions used here; its primary
passages retain the hypotheses and normalizations.

Pascadi--Thorner, arXiv:2508.14888v2, Theorem 1.8 includes ramified
**standard Euler roots**. Blomer, arXiv:1906.07459v2, Theorems 1-2 gives
the exponent in (1) at an **unramified** detecting place in its prime-level
family, using standard Hecke eigenvalues in a specified range. Neither
statement is a growing ramified-type estimate. The principal-level theorems
of Assing--Blomer and Assing--Blomer--Nelson also have different level and
local-test hypotheses; their weight-removal statements cannot simply be
assigned to the present weights.

Here is the exact reason that standard coefficients fail. Let r_sigma be
the irreducible two-dimensional Weil representation of sigma. Its inertia
invariants are a Weil-stable subspace, hence are zero or the whole space.
The latter would make an irreducible two-dimensional representation factor
through the cyclic unramified quotient, which is impossible over C.
Thus `r_sigma^I=0`. Unramified twisting does not change this, and

    L_p(s,pi(t)) = 1,
    lambda_pi(p^j) = 0  for every j >= 1.                    (3)

A projector onto the inertial class alone also has no growing spectral
gain. These observations exclude two particular detections, not the
existence of a density theorem.

## 2. Bernstein coordinates, including the self-twist factor

Let f be the order of the finite group of unramified characters chi with
`sigma tensor chi = sigma`, and put `b=p^f`. Equality of central characters
implies `chi^2=1`, so `f` is 1 or 2.

The unramified-character torus modulo self-twists has coordinate
`z=chi(p)^f`, not always `chi(p)`. For the Bernstein component

    s = [GL2 x GL2, sigma tensor sigma],

the center is `C[z1^+-1,z2^+-1]^(S_2)`. The type existence and affine-Hecke
description are the recorded Secherre--Stevens input. The twist quotient
and normalized Steinberg segments can also be read directly in
Aubert--Plymen, arXiv:math/0302169v4, Section 4.

In (2) the unordered coordinates are exactly

    {z1,z2} = {b^t,b^-t}.                                   (4)

There is no extra factor of two from the dimension of sigma:
`|det|^t(diag(p,1))=p^-t`; the factor f comes from the quotient.
Conversely, ignoring f loses a factor of two when f=2.

Choose a unitary type (J,lambda) for s and its scalar type idempotent

    e(g) = dim(lambda)/vol(J) * conjugate(tr lambda(g)), g in J,
    e(g) = 0, otherwise.

It is a self-adjoint idempotent, acting as the orthogonal projection onto
the lambda-isotypic subspace. With `vol(GL4(Z_p))=1`,
`e(1)=dim(lambda)^2/vol(J)`. A regular central function Z acts on the type
algebra; `Ze` is compactly supported, and

    pi(Ze) = Z(z_pi) pi(e).                                 (5)

This uses the center of the type algebra, not a globally compactly
supported Bernstein projector onto every vector of the block.

## 3. The unfiltered local norm really grows

For `k >= 1`, let `P_k=z1^k+z2^k` and `u_k=P_k e`.
On (2), its scalar is `b^(kt)+b^(-kt)`. However, one cannot conclude
that `||u_k||_2` is bounded from `|P_k|<=2` on the unitary torus.

There are two tempered strata in this Bernstein component. The partition
(1,1) gives unitary principal inductions, with `|z1|=|z2|=1`. The partition
(2) gives unitary unramified twists of `St(sigma,2)`. On the latter,

    {z1,z2} = {zeta b^(1/2), zeta b^(-1/2)}, |zeta|=1.

The representation is tempered even though its *cuspidal support* has
exponents +/-1/2: its nonzero monodromy must not be discarded. It is not
a representation of the complementary family (2).

By group Plancherel and the positive formal degree of this discrete-series
stratum, the constant

    c_St = integral_St tr pi(e) d mu(pi)

is positive and independent of k. Unramified twists are trivial on the
compact group J, so the nonzero projection rank is constant on this
stratum. Equation (5) and Plancherel give

    ||u_k||_2^2
      = c_St (b^k+2+b^-k) + E_k,
    0 <= E_k <= 4 e(1).                                    (6)

This is an exact exponential local L2 cost, not a numerical experiment.
At `b^k` comparable to `q^2` it costs `q^2` in this norm.
Only the inference that this unfiltered test has a bounded local L2
normalization is retired.

**Important distinction:** `(u_k^* * u_k)(1)` is an ordinary group-trace
identity value. A Kuznetsov identity term is a Whittaker/Bessel distribution,
not automatically this value. Equation (6) does not prove a `q^2` loss
in every possible Kuznetsov implementation, nor an obstruction to (1).

## 4. A cutoff removing that local cost

Define the symmetric polynomial

    B(z1,z2) = (b+b^-1)z1z2-z1^2-z2^2,
    b B(z1,z2) = (b z1-z2)(b z2-z1),                        (7)
    h_k = (B P_k)e,             A_k = h_k^* * h_k.

All these are actual compactly supported type-algebra elements for each
finite k. The convolution square is positive on every unitary
representation, regardless of the signs or phases of a central character:
`pi(A_k)=pi(h_k)^* pi(h_k)`. In particular, positivity is not an assertion
that every geometric orbital integral is nonnegative.

On (2), set

    B(t) = b+b^-1-b^(2t)-b^(-2t).

For every fixed `T<1/2` and `0<=t<=T`,

    B(t) >= d_T := b+b^-1-b^(2T)-b^(-2T) > 0.              (8)

Indeed, `x+x^-1` is strictly increasing for `x>1`, and
`1<=b^(2t)<=b^(2T)<b`. Equations (4)-(5) yield

    pi(t)(A_k) = a_k(t) pi(t)(e),
    a_k(t) = B(t)^2 (b^(kt)+b^(-kt))^2
           >= d_T^2 b^(2kt).                               (9)

The constants are independent of k and t in this interval. In the mission
one may take `T=5/22` using the inherited comparison, without improving it.

On every tempered principal induction,

    |B P_k| <= 2(b+b^-1+2).

On every tempered Steinberg twist, B is identically zero by (7).
The two strata exhaust the tempered component by Aubert--Plymen,
Section 5 preceding (16). Outside the component pi(e)=0. Plancherel,
including `integral tr pi(e) d mu(pi)=e(1)`, therefore proves

    A_k(1) = ||h_k||_2^2
       <= 4(b+b^-1+2)^2 e(1),             for all k >= 1.   (10)

It also bounds the reduced convolution-operator norm of h_k by
`2(b+b^-1+2)`, since (5) gives that bound on every tempered representation.
Neither assertion bounds its action on the global non-tempered cuspidal
spectrum under investigation.

The cutoff has Bernstein degree two. Thus `B P_k` has degree k+2.
This is an algebraic degree, **not** a proved Cartan-support height,
L1 norm, Whittaker integral, or Kloosterman-modulus bound for its realization
in GL4(Q_p) by itself. Section 11 uses the explicit generator supports
and their action on a lattice chain to obtain the missing height bound.
An abstract Hecke-algebra isomorphism alone would not justify that step.

## 5. The precise global range still required

Choose a fixed `c>0` and

    k = floor(log_b(c q^2)).

For all sufficiently large q this is positive and
`c q^2/b < b^k <= c q^2`. Hence (9) gives, for `t>=tau`,

    a_k(t) >= d_T^2 (c/b)^(2tau) q^(4tau).                 (11)

For nonnegative weights w_pi(q), independent of k, the normalized
spectral inequality and representation-wise lower bound needed are

    sum_{pi in F(q)} w_pi(q) a_k(t_pi) << q^eta,
       uniformly for b^k <= c q^2,                         (12)
    w_pi(q) >> q^(-3-eta)  for every pi in F(q),            (13)

for every eta>0. Equations (11)-(13), with `eta=epsilon/2`, would imply
(1). This conditional deduction has constants independent of q, pi and k.
Section 13 now proves (12) for the weights (22), with a fixed compact
archimedean convolution square. The original deduction still lacks (13).
Sections 15-22 explain why an arbitrary type position obstructs that
deduction and give a different, explicitly stated test for the same count.

The distinction between the two requirements remains essential:

* Section 8 proves a uniform bound for the Whittaker identity distribution.
  Section 10 gives the complete character-compatible cell list and
  necessary prime-level minor conditions. The new support argument in
  Sections 11-12, not those results alone, excludes every nonidentity cell
  in the specified range.
* Blomer's `mZ <= c q^2` range concerns his standard Fourier indices.
  Replacing m by `b^k` does not identify those indices or transfer that
  range to this test. The new proof obtains the range independently from
  the actual type-Hecke support; it does not substitute indices into
  Blomer's formula.
* A positive convolution square makes the spectral side nonnegative.
  It does not make the separate geometric cells nonnegative and does
  not allow an unestimated cell to be dropped.
* Section 9 specifies the nonnegative cuspidal spectral weights without
  conflating them with ordinary Plancherel weights. Their representation-wise
  lower bound remains unproved. Genericity or pointwise nonvanishing does
  not prove (13).

For an admissible range only `b^k` comparable to `q^rho` and a weighted
upper-bound loss `q^gamma`, the same calculation would give
`q^(3+gamma-2rho tau+epsilon)`, not automatically (1).
The needed inequality is `2rho tau-gamma >= 4tau`.
The new weighted estimate gives `rho=2, gamma=0`, but without (13) it
does not give an unweighted count. No assertion is made that this
support range is maximal. The exact cost in (6) belongs only to the
unfiltered ordinary L2 calculation.

## 6. Comparison with the exterior-square transfer family

This comparison does not assume the standard roots of pi detect t.
Write delta=det(r_sigma). A fixed finite-order global character xi can
cancel delta on inertia at p: extend the finite character on Z_p^*
to a Dirichlet character of p-power conductor. Matching its value at a
uniformizer is unnecessary. The cuspidal transfer

    Pi' = (exterior-square pi) tensor xi

then has two standard local roots at p of absolute values `p^(2t)` and
`p^(-2t)`. The remaining local summands are bounded, so the largest
root modulus is `p^(2t)`. The character and its conductor are fixed.

Consider the favorable usual prime-level case `a(pi_q)<=1` with central
character unramified at q. Its Weil inertia is trivial. Otherwise
conductor one would force one nontrivial tame inertia character, making
the determinant ramified. Thus its monodromy is either zero or has rank
one and Jordan type (2,1,1). In the latter case choose `N e2=e1`; on
the exterior square only

    e2 wedge e3 -> e1 wedge e3,
    e2 wedge e4 -> e1 wedge e4

are nonzero. Its rank and conductor are two. Consequently
`C(Pi') << q^2` when the remaining data are fixed. This is a conductor
calculation, not a new density theorem.

Pascadi--Thorner with n=6 and theta=2tau bounds the number of *distinct*
Pi' in the transferred family by

    q^(24(1-4tau)+epsilon),       0<tau<=1/8.                (14)

Counting original pi also requires control of the transfer fibres. No
uniform fibre bound is assumed or proved here. Even granting injectivity,
the exponent in (14) exceeds `3-4tau` throughout this interval:

    (24-96tau)-(3-4tau) = 21-92tau >= 19/2.

The first Reviewer identified a stronger applicable comparison. The remark
immediately after Theorem 1.8 on p. 7 of the pinned primary PDF allows
`D_F^(-n^2) Q^(2n)` to be replaced by the maximum pair Rankin--Selberg
conductor. This remark is absent from the HTML rendering retrieved here;
it has now been read directly in the PDF.

The transferred monodromy is `2 S_2 + 2 S_1`, where S_j is a length-j
nilpotent Jordan block. If both representations have this monodromy, their
pair has

    (2 S_2 + 2 S_1) tensor (2 S_2 + 2 S_1)
       = 4 S_3 + 8 S_2 + 8 S_1,

of dimension 36 and nilpotent rank `4*2+8=16`. If just one is ramified,
the rank is 12; if neither is ramified, it is zero. Inertia remains trivial.
The Reviewer independently checked these exact ranks. With fixed remaining
data, `C(Pi'_1 x dual(Pi'_2)) << q^16`. The refined distinct-transfer bound
is therefore

    q^(16(1-4tau)+epsilon),       0<tau<=1/8.                (14a)

This improves the *comparison* (14), not the mission's bound. Even granting
injectivity of the transfer, its gap from (1) is

    (16-64tau)-(3-4tau) = 13-60tau >= 11/2.

At tau=1/8 the refined comparison is 8 versus 5/2. A transfer fibre bound
is still absent. Neither (14) nor (14a) furnishes the proposed saving;
no impossibility of a more family-specific transferred estimate follows.

## 7. Exact replay and what remains open

`gl4_ramified_type_exact.py` reuses the existing exact character arithmetic.
It checks (7), Weyl symmetry, both Steinberg substitutions, the Laurent
specialization (4), a power-sum recurrence, and the rank-two exterior-square
monodromy calculation. It emits a rational-polynomial square certificate
for one explicitly selected index. The displayed proofs, not a finite
sample of indices, establish the identities and estimates for every k.

Run from the campaign root:

    python3 -B research/gl4_ramified_type_exact.py --index 3 \
      --emit-payload research/jacobian/ramified-type-sos-input.json

The separately inspected Jacobian operation is
`polynomial.sos.decomposition.check`. Its dedicated input requests a check of

    [(b x-y)(b y-x)(x^3+y^3)]^2

as a rational sum of squares. The native exact checks passed and their
output is `gl4_ramified_type_exact.json`. The adapter returned exit 2,
`INVALID_REQUEST`, with `sum_of_squares.degree_bound`: the requested square
has total degree 14 in (b,x,y). Its inspected schema did not specify the
numeric total-degree ceiling. The rejection is preserved, and is neither
an algebraic verdict nor evidence for or against (1). No smaller sample
was substituted for the full selected polynomial merely to obtain success.

The adapter contract, exact payload and structured error are preserved under
`research/jacobian/ramified-type-*`. The inspected server reported version
0.14.0 and protocol 2025-11-25; the validation-error response itself contains
no fresh server metadata. The operator-positivity proof is the
convolution-star argument, not a sidecar verdict. No Lean formalization
is claimed.

The host subsequently verified the mixed-level proof in Sections 11-13.
The original unweighting claim must not be inferred from that verdict.
Sections 15-22 give the new diagnostic and replacement route; the
unfiltered bounded-L2 inference remains retired for the Steinberg
Plancherel obstruction in (6).

The continuation has a separate exact replay command; it does not rerun
the unchanged cutoff or rejected SOS payload:

    python3 -B research/gl4_ramified_type_exact.whittaker.py \
      --jacobian-output research/jacobian/ramified-whittaker-s4-output.json

Its finite domain is all 24 elements of S_4, independently enumerated by
the inspected Jacobian operation `group.conjugacy_classes.compute`. The
operation's role is exhaustive domain enumeration, not a theorem about
Kuznetsov integrals. The script checks the root-character condition for
every element, records a root witness for each of the 16 exclusions, and
computes the southwest-minor polynomials for the eight remaining elements.
It also checks the compact-averaging factor on a finite group by a
coefficientwise Gram identity. The universal p-adic argument is the proof
in Section 8, not that finite check.

## 8. The actual Whittaker identity distribution

Let G=GL4(Q_p), let U be its standard upper unipotent subgroup, and put

    psi(u)=psi_0(u12+u23+u34),
    D_psi(F)=integral_U F(u) psi(u) du,                     (15)

where psi_0 is a fixed unitary additive character and `vol(U(Z_p))=1`.
Keep `vol(GL4(Z_p))=1` for the group Haar measure. This sign convention
matches Whittaker coefficients defined using conjugate(psi); replacing
both conventions by their inverses gives the identical statements.
Since F is compactly supported, (15) is an ordinary integral, not a
regularized value.

For `h in C_c^infinity(G)`, set

    Q_psi h(g)=integral_U h(g u) psi(u) du.

It satisfies `Q_psi h(g u)=psi(u)^-1 Q_psi h(g)`. With the quotient
measure on G/U compatible with the specified Haar measures, unfolding
the squared norm gives the exact identity

    D_psi(h^* * h) = ||Q_psi h||_(L2(G/U,psi))^2.           (16)

For example, the integrand after one change of variables is
`integral_G conjugate(h(x)) h(x u) dx=(h^* * h)(u)`.
Compact support justifies this calculation. Equation (16), not h's
ordinary group L2 norm, is the local Whittaker identity distribution.

Here is a direct proof of the required uniform bound which does not
import a Whittaker Plancherel theorem. Put

    d=diag(p^-3,p^-2,p^-1,1),
    U_m=d^m U(Z_p)d^-m,       m>=0.

These are nested compact open subgroups of U with union U. Their
volumes are `p^(10m)`, since the six positive-root heights sum to 10.
For each fixed m, define a function on G by

    P_m h(g)=integral_(U_m) h(g u) psi(u) du.

All integrations below are compact. Expanding the norm and substituting
`x=g v`, `u=v w` proves

    ||P_m h||_L2(G)^2
       = vol(U_m) integral_(U_m) (h^* * h)(u) psi(u) du.    (17)

This is valid for nonabelian U_m because psi is a character. Let L(h)
denote left convolution on L2(G). Since `h_k=h_k*e`, Fubini gives

    P_m h_k = L(h_k) P_m e.

The already reviewed reduced-operator bound from Section 4 is
`||L(h_k)|| <= M_b:=2(b+b^-1+2)`, independently of k. Apply it in
(17) and use `e^**e=e`. Choose m large enough to contain
`(supp A_k union supp e) intersection U`, and divide by `vol(U_m)`.
One obtains, for every k, with no bound on how large this m must be,

    0 <= D_psi(A_k) <= M_b^2 D_psi(e).                     (18)

The factor `p^(10m)` cancels exactly, so increasing support introduces
no hidden cost in this argument.

For the actual scalar type idempotent, let `H=J intersection U`. Character
orthogonality on the compact group H computes the fixed normalization:

    D_psi(e)
      = dim(lambda) vol(H)/vol(J)
          * dim Hom_H(lambda,psi).                        (19)

Thus (18)-(19) are an explicit all-k bound for the required p-adic
identity distribution. In particular it is not being replaced by A_k(1).
There is a useful possible zero here: if `Hom_H(lambda,psi)=0`, this
Whittaker coefficient sees no type vector at the identity. Then the
weights in Section 9 vanish on this type and cannot imply (13).
Being a type does not by itself prove a positive Whittaker normalization.

One also knows the determinant grading of the actual test. An unramified
twist chi with `chi(p)=a` sends each z_i to `a^f z_i`, while fixing e.
The homogeneous multiplier BP_k is multiplied by `a^(f(k+2))`.
Equivariance of the Bernstein action under twisting, or Fourier uniqueness
on the integer determinant grading, implies

    supp h_k is contained in {v_p(det g)=f(k+2)},
    supp A_k is contained in {v_p(det g)=0}.               (20)

This does not bound any of the smaller minors of g.

## 9. Spectral weights and the level-q identity normalization

At the growing prime use the standard compact open subgroup

    K0(q)={g in GL4(Z_q): g41,g42,g43 in q Z_q},
    e_q=1_(K0(q))/vol(K0(q)).

Reduction modulo q identifies its index with the number of hyperplanes
in F_q^4. Consequently

    V_q:=vol(K0(q))^-1=q^3+q^2+q+1.

The global standard additive character is trivial on Z_q, and
`U(Q_q) intersection K0(q)=U(Z_q)`. Therefore the **actual** local
Whittaker identity distribution is

    D_(psi_q)(e_q)=V_q,                                    (21)

not 1. This normalization must be accounted for in (12).

Use an adelic automorphic L2 norm with fixed Haar measures, rather than a
classical norm whose volume convention changes silently with q. For each
cuspidal pi, let V_pi(q) be the space of vectors satisfying the fixed
finite-place conditions, the lambda-isotypic condition at p, the K0(q)
condition at q, and the spherical condition at infinity. Fix a positive
bi-spherical archimedean test with scalar transform H(pi_infinity)>=0.
For a finite collection of pi, take an L2-orthonormal basis B_pi(q) of
each V_pi(q), and define

    W_phi(1)=integral_(U(Q)\U(A)) phi(u) conjugate(Psi(u)) du,
    w_pi(q)=H(pi_infinity)/V_q
              * sum_(phi in B_pi(q)) |W_phi(1)|^2.         (22)

These weights are independent of k and are basis independent. In
particular, representation counting is not being replaced by counting
the dimension of V_pi(q).

The finite cuspidal kernel expansion for the test with p-factor A_k
is exact linear algebra: on V_pi(q), that factor acts by a_k(t_pi),
and the q-projector acts by 1. Taking the two Whittaker coefficients and
dividing by V_q gives exactly

    sum_pi w_pi(q) a_k(t_pi).

This assertion for a finite spectral truncation needs no exchange of
infinite spectral and geometric sums. Other unitary representations have
nonnegative quadratic forms because A_k is a convolution square.
Section 13 supplies an L2 pretrace construction: the noncuspidal part is
the squared norm of an orthogonal projection, rather than a formally
discarded Eisenstein expansion.

For compact representatives of the global test, the unipotent identity
orbit factors into local distributions (15). Its q-factor (21) is canceled
by the displayed division by V_q, its p-factor is bounded by (18), and
all other factors are fixed. Fixed central-character averaging causes
no k-dependent factor: (20) restricts contributing local central scalars
at p to units. Give the scalar units central Haar volume 1 at every
finite place. More explicitly, for a central scalar z put
`R_z Q_psi h(g)=Q_psi h(g z)`. This is a unitary translation on G/U,
and the unfolding used in (16) gives

    D_psi(g -> A_k(z g))
      = <Q_psi h_k, R_z Q_psi h_k>.

Its absolute value is at most `D_psi(A_k)` by Cauchy-Schwarz, uniformly
in z. Integrating against the unitary central character over the unit
scalars therefore costs at most their fixed Haar volume. The same
argument applies at the other finite places, and the archimedean
factor is fixed. This describes the identity contribution only, not
the nonidentity geometric side.

With H bounded below on the chosen fixed spectral window, (13) would
require

    sum_(phi in B_pi(q)) |W_phi(1)|^2 >> q^-eta

for every relevant pi. This lower bound for the unchanged individual
weight is not proved here; Section 15 shows why it is not automatic. Nor does
(18) imply it: an upper bound on an identity distribution cannot produce
a representation-wise lower bound.

## 10. Every possible Weyl cell and the necessary minor conditions

Use permutation matrices defined by `w(e_i)=e_(w(i))`, and write a Bruhat
representative as `t w`, with diagonal t. For a root subgroup U_ij with
`i<j` and `w(i)<w(j)`, its occurrence in the stabilizer forces equality
between the two Whittaker characters. The left character is nontrivial
exactly when `w(j)=w(i)+1`; the right one exactly when `j=i+1`.
Thus a necessary and sufficient character-compatibility condition on w is

    for every i<j with w(i)<w(j),
    (j=i+1) if and only if (w(j)=w(i)+1).                  (23)

When both sides are simple, the additional torus condition is
`t_(w(i))=t_(w(j))`. All other shared positive-root characters are
trivial. These equalities suffice because the shared root subgroups
generate the stabilizer.

The exhaustive S_4 computation gives the following table. Delta_i denotes
the determinant of the last i rows and first i columns, and `d_w` is
the dimension of the compatible torus modulo scalars.

| w(1)w(2)w(3)w(4) | length | torus equalities | d_w | nonzero Delta_i(tw) |
|---|---:|---|---:|---|
| 1234 | 0 | t1=t2=t3=t4 | 0 | none |
| 2341 | 3 | t2=t3=t4 | 1 | i=3 |
| 3412 | 4 | t3=t4, t1=t2 | 1 | i=2 |
| 3421 | 5 | t3=t4 | 2 | i=2,3 |
| 4123 | 3 | t1=t2=t3 | 1 | i=1 |
| 4231 | 5 | t2=t3 | 2 | i=1,3 |
| 4312 | 5 | t1=t2 | 2 | i=1,2 |
| 4321 | 6 | none | 3 | i=1,2,3 |

This list includes every possible character-compatible cell, not a claim
that every listed cell actually contributes for the chosen test. The 16
other permutations have a specific mismatched root and vanish by character
integration. No nonidentity entry in the table has been discarded by a
positivity argument.

There are also exact necessary prime-level support conditions. Southwest
minors are unchanged by left and right multiplication by upper unipotents.
Every Delta_i(g), `1<=i<=3`, for `g in K0(q)` is divisible by q, because
its submatrix includes the last row in the first i columns. Hence

    Delta_i(tw) != 0 and
    U(Q_q) t w U(Q_q) intersects K0(q)
        imply Delta_i(tw) in q Z_q.                       (24)

The listed nonzero minors equal, up to their recorded permutation sign,
the product of the last i entries of t. These implications are necessary,
not sufficient conditions for a nonzero orbital integral.

For precision, let `H_i(k)=sup_(g in supp A_k) |Delta_i(g)|_p`.
With the other finite tests compact projectors, their determinant
valuations are zero; (20) gives the same at p. A rational orbit which
meets all finite supports has determinant +/-1. Compact archimedean
support and fixed support at the other bad primes, together with the
product formula applied to a nonzero Delta_i(tw), turn (24) into

    q <= C_i H_i(k),                                      (25)

where C_i depends only on the fixed tests. In particular, if this
inequality fails, the corresponding orbit is absent. Equations (20)
and (25) isolate the support information actually required; Bernstein
degree or a reduced-operator norm does not estimate H_i(k).

The remaining local distributions are, with compatible quotient measures,
the character-twisted integrals of

    f_v(u1^-1 t w u2) conjugate(psi_v(u1)) psi_v(u2)

over `(U x U)` modulo the stabilizer of tw. At w=1 and t=1 this is
precisely (15). The second review correctly left all seven nonidentity
rows open: (25) alone contains no bound for H_i(k). The next sections
provide that bound and use one additional arithmetic fact about the
3412 row. They do not import a fixed-test maximal-compact formula as an
estimate uniform in k.

## 11. Sharp support of the actual multiplier

Write `||g||_p=max_(i,j)|g_ij|_p`. We prove, for the fixed type e and
`d=k+2`,

    g in supp h_k:
      ||g||_p <= C,       ||g^-1||_p <= C b^(d/2),
    g in supp A_k:
      ||g||_p, ||g^-1||_p <= C b^(d/2).                   (26)

Constants in this section may depend on p, sigma and the fixed type,
but not on k, q or the varying representation pi.

First use a simple type for the repeated-supercuspidal component in
the standard proper-order position. The precise source input is
Secherre [SIII], Sections 2.5.3-2.5.5, Theorem 4.6 and Proposition 4.16;
the cover and its compatibility with the Bernstein component are [SS],
Theorem B and Proposition 5.7. This is a support-preserving realization,
not just an abstract equivalence.

In the split group its simple field is E, its two blocks are E^s, and

    s [E:Q_p]=2,       b=|k_E|^s,       e_E=2/f.

The level-zero case is included by taking E=Q_p and s=2. Let
`varpi=varpi_E`, put `L=O_E^s`, and identify the underlying Q_p-space
with `E^s direct-sum E^s`. The periodic lattice chain is

    L_(2m)   = varpi^m L direct-sum varpi^m L,
    L_(2m+1) = varpi^m L direct-sum varpi^(m+1) L.          (27)

It satisfies `L_(j+2 e_E)=p L_j`. The simple-type group preserves every
L_j. In the matrix realization let

    s_0 = [0,I; I,0],       omega = [0,I; varpi I,0].

The normalized Hecke generators T and O have supports `J s_0 J` and
`J omega J`, respectively, and satisfy

    T^2=1+c_b T,       c_b=sqrt(b)-1/sqrt(b),
    T^-1=T-c_b,        O^2 T=T O^2.

With the normalization of O corresponding to the fixed sigma, the
Bernstein generators are `Theta_1=T O`, `Theta_2=O T^-1`.
Indeed `Theta_1 Theta_2=T O^2 T^-1=O^2` and
`Theta_2 Theta_1=O T^-1 T O=O^2`. The normalized parabolic-induction
compatibility of the cover identifies their unordered characters with
the z_1,z_2 of Section 2. A common scalar change in this normalization
would not change any support below.

Consequently, for `S=z1+z2` and `D=z1 z2`,

    S = T O + O T - c_b O,       D=O^2,                   (28)
    supp(S e) is contained in
      J diag(varpi I,I) J union J diag(I,varpi I) J
                             union J omega J,
    supp(D e) is contained in J diag(varpi I,varpi I) J.

The scalar type corner has the same support containment as the
matrix-valued Hecke algebra: the scalar matrix coefficients introduce
only factors supported on J. This does not require the coefficient on
every listed double coset to be nonzero.

Each of the three representatives for S satisfies, for every integer j,

    L_(j+2) contained in g L_j contained in L_j.

The representative for D sends L_j exactly to L_(j+2). The same
statements hold after multiplication by J on either side. Composition
therefore gives

    g in supp(S^a D^r e), a,r>=0:
    L_(j+2(a+r)) contained in g L_j
                                  contained in L_(j+2r). (29)

This is an induction on the number of factors, using all j, not an
operator-norm estimate multiplied k times in a poorly adapted basis.

The recurrence `P_0=2, P_1=S, P_k=S P_(k-1)-D P_(k-2)` expresses
P_k as a polynomial in S,D with nonnegative exponents and weighted
degree k, where S has degree one and D degree two. Also
`B=(b+b^-1+2)D-S^2`. Thus every monomial of B P_k has
`a+2r=d` with a,r>=0. Equation (29) implies

    L_(j+2d) contained in g L_j contained in L_j
                               for every g in supp h_k. (30)

Take j=0 for `g L_0 contained in L_0`, and j=-2d for
`g^-1 L_0 contained in L_(-2d)`. The latter use of all j avoids assuming
that g commutes with E. The periodicity in (27) now gives the first line
of (26): the bounded rounding cost is independent of d, and
`p^(d/e_E)=p^(fd/2)=b^(d/2)`. Convolution support gives
`supp A_k contained in (supp h_k)^-1 (supp h_k)`, proving the second
line. No estimate of the Hecke coefficients is needed.

This proves (26) for the chosen simple type. It also proves it for the
original fixed type e, without replacing A_k. Indeed, let e_0 be the
simple-type idempotent just used. The type equivalence for their common
Bernstein category makes e_0 full in its Bernstein ideal. Hence there
are finitely many fixed compactly supported functions x_j,y_j such that

    e = sum_j x_j * e_0 * y_j.

For completeness, apply the equivalence to the smooth module H(G)e:
the quotient by H(G)e_0 H(G)e has zero e_0-part and is therefore zero.
Writing its element e as a finite sum gives the displayed identity.
Centrality of Z=B P_k gives

    Z e = sum_j x_j * (Z e_0) * y_j.                      (31)

Multiplication by those fixed compact supports changes each matrix-norm
bound only by a fixed constant. This proves (26) for the actual h_k
and A_k, including fixed conjugations of the type.

Combining (26) with `|det g|_p=1` on supp A_k gives the explicit minor
bounds

    H_1(k), H_3(k) <= C b^((k+2)/2),
    H_2(k) <= C b^(k+2).                                  (32)

For H_3 use the cofactor identity with g^-1 and det g; bounding a
three-by-three determinant by `||g||_p^3` would lose the required range.

## 12. All seven nonidentity cells vanish in the required range

For the global compact test, put `R=b^((k+2)/2)`. A rational orbit
meeting all finite supports has determinant +/-1, as in Section 10.
For a nonzero southwest minor of size one or three, the product formula,
(24), (26) and the fixed supports at the other places imply

    q <= C R.                                             (33)

Here the archimedean support is fixed and compact modulo the center;
after the determinant normalization its relevant minors and inverse
minors are bounded by fixed constants. The good finite factors bound
their absolute values by one; the finitely many other factors cost
only fixed constants.

The following covers every nonidentity row. The entry denotes the
rational quantity to which to apply the product formula:

| Weyl cell | Quantity | Reason its q-adic valuation is at least one |
|---|---|---|
| 2341 | Delta_3 | (24) |
| 3421 | Delta_3 | (24) |
| 4123 | Delta_1 | (24) |
| 4231 | Delta_1 | (24) |
| 4312 | Delta_1 | (24) |
| 4321 | Delta_1 | (24) |
| 3412 | t_3=t_4 | Delta_2=t_3^2 and integral valuations |

The last row is essential. For 3412 write
`t=diag(a,a,d_0,d_0)`. Its nonzero southwest minor is
`Delta_2(tw)=d_0^2`. Condition (24) says
`2 v_q(d_0)>=1`; since d_0 is rational, `v_q(d_0)` is an integer,
so `v_q(d_0)>=1`. At p, (32) gives `|d_0|_p<=C R`;
at the other places take square roots of the fixed bounds for Delta_2.
The product formula for d_0 proves (33) for this row too. Treating its
minor as an arbitrary number merely divisible by q would lose this
factor of two.

Central-character averaging does not invalidate this argument. If a
rational representative gamma meets the central average of the test,
then at every finite prime l,
`v_l(det gamma)+4 v_l(z_l)=0` for some scalar z_l. All determinant
valuations are therefore divisible by four. Multiplication of gamma
by one rational scalar gives a representative of determinant +/-1.
The remaining local central scalars are units; they preserve the
q-divisibility and p-adic norm bounds. At infinity they range over a
fixed compact set because the determinant has been normalized.
Compatibility of the torus and the square property of Delta_2 are
unchanged by this scalar normalization.

Let C be the maximum of the seven fixed constants in (33), and choose,
for example,

    0 < c < 1/(C^2 b^2).

If `b^k<=c q^2`, then `C R=C b b^(k/2)<q`, contradicting (33).
Thus no compatible nonidentity rational orbit meets the global support.
The sixteen incompatible Weyl cells vanish by character integration.
In particular the combined nonidentity contribution is **exactly zero**
in this range, not an unproved cancellation or an estimate with an
unspecified k-dependent constant. This is only a sufficient small-c
range; it is not asserted to be maximal.

## 13. Positive pretrace and the continuous spectrum

Here are convergence and positivity details that avoid an unsupported
infinite Eisenstein expansion. Work on
`X=Z(A)G(Q)\G(A)` with the fixed unitary central character. Normalize
`vol(U(Q)\U(A))=1`, compatibly with the local Haar measures.

Choose a fixed smooth compact-mod-center bi-spherical archimedean
function h_infinity, and take its convolution square as the test there.
Then `H(pi_infinity)=|hat(h_infinity)(pi_infinity)|^2` in (22).
It can be bounded below on the prescribed compact spherical spectral
window: choose a normalized bi-spherical approximate identity sufficiently
near the maximal compact subgroup. Continuity of the normalized spherical
functions, uniformly on that compact parameter set, makes its transform
within 1/2 of one. This choice is fixed independently of q and k.

Let h be the product with p-factor h_k, q-factor e_q, the fixed other
finite orthogonal projectors, and archimedean factor h_infinity.
Central averaging is understood with the fixed character; it is the
usual convolution homomorphism to functions compact modulo Z(A).
Thus `A=h^* * h` has the prescribed p-factor A_k and q-factor e_q.

For a compact-mod-center smooth test F define the automorphic kernel

    K_F(x,y)=sum_(gamma in Z(Q)\G(Q)) F(x^-1 gamma y),

with its central character convention understood. If x,y range over
fixed compact sets in X, this sum is locally finite, uniformly there:
the rational points in G/Z are discrete in its adelic points, and the
relevant intersection is compact. In particular this applies to compact
sets of representatives of `[U]=U(Q)\U(A)`.

Define the smoothed Whittaker vector

    v_h(x)=integral_[U] K_h(x,u) Psi(u) du.                (34)

It is a smooth L2 vector. Indeed its support in X is contained in
the image of the product of a compact set of representatives of [U]
with the inverse support of h. The kernel sum is locally finite there,
so v_h is bounded and compactly supported. This proves existence for
each q,k without any assumption about temperedness of the spectrum.

The convolution identity for kernels and Fubini, now for compact
supports, give

    ||v_h||_2^2 =
      integral_[U]^2 K_A(u_1,u_2)
                    conjugate(Psi(u_1)) Psi(u_2) du_1 du_2. (35)

One can first expand the norm of (34); unfolding the automorphic
variable is the ordinary identity `R(h)^* R(h)=R(h^* * h)`.
The original double integral in (35) is absolutely convergent: on
compact representatives of [U]^2 its kernel has only finitely many
rational terms, uniformly on that compact set. Grouping by rational
U-double orbits is therefore legitimate. Unfolding a stabilizer uses
its compact rational unipotent quotient. A nontrivial stabilizer
character integrates to zero, giving exactly (23). For compatible
orbits this is the relative-kernel expansion with the local
distributions displayed at the end of Section 10. There is no
conditionally rearranged infinite sum hiding in this argument.

Section 12 removes every nonidentity orbit when `b^k<=c q^2`.
The remaining identity orbit factors into the local Whittaker
distributions of Section 8, including the fixed central average.
By (18), (21) and the central-translation bound in Section 9,

    0 <= ||v_h||_2^2 / V_q <= C_fixed.                    (36)

The constant depends only on the fixed data. The potentially large
support of h was used to prove existence, but introduces no constant
in (36): all nonidentity terms have vanished and the actual identity
bound is uniform.

Finally let P_cusp be the orthogonal projection onto the closed span
of the L2 cuspidal representations. Decompose the Hilbert space, not
a formal spectral series:

    ||v_h||_2^2 =
       ||P_cusp v_h||_2^2 + ||(1-P_cusp)v_h||_2^2.        (37)

The second term is nonnegative and contains all continuous and residual
contributions, with no temperedness assumption and no need to exchange
an Eisenstein integral with a geometric sum. For an orthonormal cusp
vector phi the coefficient of v_h is, up to complex conjugation,
`W_(R(h)^* phi)(1)`. On the type/level/spherical space of a pi in F(q),
its squared absolute value is
`a_k(t_pi) H(pi_infinity) |W_phi(1)|^2`.
Bessel's inequality applied to (37), and then (36), prove

    sum_(pi in F(q)) w_pi(q) a_k(t_pi) <= C_fixed,
                       whenever b^k<=c q^2.              (38)

This is the actual estimate (12), with the weights (22), and constants
independent of q, pi and k. Equation (37) is a rigorous positive treatment
of the entire noncuspidal spectrum, not a claim that it is absent.
The argument establishes the needed relative pretrace identity and
inequality, not an explicit parametrization of Eisenstein measures.

Using only these weights, the density bound (1) still requires (13).
A zero or very small Whittaker weight is not repaired by (38). No
positive uniform type-Whittaker norm has been inferred from that upper
bound. The host Reviewer has supported (38); the new finite-test repair
and its source attribution, originality and significance remain separate
review obligations.

## 14. Exact replay for the support continuation

The new independently rerunnable finite calculation is

    python3 -B research/gl4_ramified_type_exact.support.py \
      --jacobian-input research/jacobian/ramified-support-kernel-input.json \
      --jacobian-output research/jacobian/ramified-support-kernel-output.json \
      --reviewed-cells research/gl4_ramified_type_exact.whittaker.json

It verifies the lattice-chain generator inclusions for every residue of
the two possible periods, two and four. The explicit periodicity extends
these checks to all integer chain indices; the induction (29)-(30) is
proved in the text, not inferred from testing finitely many k.
It attaches a nonzero arithmetic witness to each of the seven already
reviewed cells without rerunning the earlier enumeration.

The inspected Jacobian operation `matrix.nullspace.compute` was executed
on the three-by-four matrix with rows
`(1,-1,0,0), (0,0,1,-1), (1,1,1,1)`. It returned rank three and the
primitive kernel vector `(-1,-1,1,1)`. A native determinant calculation
checks the rank certificate -2. This confirms that the middle cell's
corner valuation is twice an integer, not an arbitrary positive real.
The exact payload, contract and successful typed result are preserved
in the `ramified-support-kernel-*` files. The adapter returned exit zero,
with server 0.14.0, protocol 2025-11-25 and runtime 1 ms.

The finite checker rejects a wrong kernel, an omitted 3412 cell, and a
missing square-minor torus equality. Its successful output is
`gl4_ramified_type_exact.support.json`. It does not mechanically certify
the cited type equivalence, the p-adic support proof, or the Hilbert-space
argument; those are the separately stated mathematical proof and its
source dependencies. The unchanged cutoff checks, identity-bound
diagnostic and rejected SOS payload were not repeated.

## 15. An exact obstruction to the unchanged weight lower bound

The type in Section 2 was not required to be positioned compatibly with
the fixed standard Whittaker character. This matters even for a fixed
prime and a fixed Bernstein block.

Let (J,lambda) be any smooth type. Choose r>=1 with
`K(r)=1+p^r M_4(Z_p)` contained in J and in the kernel of lambda.
Such r exists by smoothness and finite dimension. Put

    g_0=diag(p^(-r-1),1,1,1),
    u_0=I+p^-1 E_12
       =g_0 (I+p^r E_12) g_0^-1.                         (39)

The conjugate type is a type for the same block, and u_0 acts trivially
on its entire isotypic subspace. But `psi(u_0)=psi_0(p^-1)!=1`.
For every psi-Whittaker functional ell and vector v in that subspace,

    ell(v)=ell(pi(u_0)v)=psi(u_0) ell(v),

so ell(v)=0. Thus the weights (22) for this permitted fixed type position
are identically zero whenever the indicated representation occurs.
The earlier local norm and support estimates still apply, with fixed
changed constants, and (38) remains true but gives no count.

This proves failure of the arbitrary-position nonvanishing inference.
It does not identify a zero for an unspecified concrete original type,
prove that F(q) is nonempty, construct a non-tempered automorphic
representation, or refute (1). Multiplying by an adjoint factor cannot
remove this zero. At infinity there is another unjustified inference:
`H(pi_infinity)>0` does not imply that the spherical Whittaker function
is nonzero at the single point 1. We do not assert an automorphic zero
there; we remove the need for such an assertion.

The route through automatic (13) is therefore replaced, explicitly, by
a finite test enlargement. All translations below are chosen once from
the fixed data, never separately for a growing q or a particular pi.

## 16. The exact local and global normalizations

For a unitary generic local representation define

    I_(pi,psi)(v)=integral_U^st
        <pi(u)v,v>/||v||^2 conjugate(psi(u)) du,
    beta_(pi,psi)(E)=sum_(v in ONB(im pi(E))) I_(pi,psi)(v), (40)

where E is an orthogonal compact Hecke projector. Use the fixed
self-dual additive measure, so vol U(Z_l)=1 at a finite prime l.
Lapid--Mao [LM, Lemma 4.4] identifies the stable integral with
`|ell_psi(v)|^2/||v||^2` for a suitably normalized Whittaker functional.
Consequently beta is nonnegative, basis independent, and equal to the
squared norm of the bounded functional `ell_psi pi(E)`. The unprojected
ell need not be a bounded functional on the whole Hilbert representation.

In the Whittaker model its precise normalization is

    I_(pi,psi)(W)=|W(1)|^2/J(W),
    J(W)=integral_(U_4\P_4) |W(x)|^2 dx.

The mirabolic measure here is the gauge-form measure of [LM, Section 4],
not a measure silently assigning GL3(Z_l) volume one. Its GL3 factor has
volume `kappa_3(l)=prod_(j=1)^3(1-l^-j)`.

Let `R_pi=Res_(s=1) L(s,pi x dual(pi))` for the **finite** global
Rankin--Selberg L-function, and set
`Delta_(4,l)=prod_(j=1)^4(1-l^-j)^-1`.
Thus over Q, `R_pi=L(1,pi,Ad)` in the finite adjoint convention.
For pure tensors the GL4 theorem of [LM, Theorem 4.1] gives

    |W_phi(1)|^2/||phi||_adelic^2
       = C_meas * prod_(j=2)^4 zeta(j)/R_pi
         * I_infinity(phi_infinity)
         * prod_(l in S_fin)
             [L_l(1,pi_l x dual(pi_l))/Delta_(4,l)]
             I_l(phi_l).                                (41)

Here S contains infinity and all non-spherical or ramified test places.
The remaining local spherical vectors contribute one after their local
Euler factors are combined. C_meas is a fixed positive scalar accounting
for the campaign's fixed adelic Haar convention; it is independent of
q, pi and all vectors. This follows directly by taking the residue in
`Delta_GL4^S(s)/L^S(s,pi x dual(pi))`. In particular omitted local
Rankin--Selberg factors are in the numerator, not the denominator.
For the source's precise Tamagawa convention the corresponding scalar
is fixed by its global pairing formula. No conjecture for other groups
is used.

Equation (41) also follows by factoring the invariant mirabolic pairings
in the displayed formula preceding [LM, Lemma 4.4]. It is homogeneous
in every local norm. Choose local unit vectors, transfer their tensor
product isometrically into the adelic L2 realization, and then sum.
For a finite tensor-product orthonormal basis the local sums are exactly
the beta factors in (40), not dimensions of invariant spaces. Changing
to another orthonormal basis leaves the squared functional norm unchanged.
This justifies applying (41) to the weights below.

At the fixed detecting prime, [PS, Section 7.1] gives
`L_p(s,sigma x dual(sigma))=(1-b^-s)^-1`. Multiplicativity under the
normalized induction (2) therefore gives

    L_p(1,pi(t),Ad)
      =(1-p^-1) /
        [(1-b^-1)^2 (1-b^(-1-2t)) (1-b^(-1+2t))].        (42)

Both upper and lower bounds for this positive expression are fixed on
`0<=t<=T=5/22`. Formula (42) is not a nonvanishing assertion for ell
on a prescribed type.

For the other fixed finite places we only need a lower bound for the
local factors in (41). The inherited all-place bound H_4(9/22) of [BB]
and tempered local Rankin--Selberg theory bound each pair Euler root
gamma by `l^(9/11)`. There are at most 16 such roots. Complex roots occur
in conjugate pairs and real factors at s=1 are positive; hence

    L_l(1,pi_l x dual(pi_l)) >= (1+l^(-2/11))^-16
                              >= 2^-16.

For a fixed finite set of l, division by Delta_(4,l) thus costs only a
fixed positive constant. The same gap justifies the absolutely convergent
Schur sums used next. No Ramanujan conjecture or new pointwise bound is
assumed.

## 17. Prime-level cancellation, including the mirabolic volume

Let q be outside the fixed bad primes. Since `K1(q) subset K0(q)`,
the local conductor exponent a(pi_q) is at most one. Conversely, the
newvector at exponent one is K0(q)-fixed: one has
`K0(q)=Z(Z_q) K1(q)`, and the central character is unramified at q.
For a(pi_q)=0, the spherical vector is already K0(q)-fixed.

The Weil inertia is trivial. Indeed a nontrivial inertia action with
conductor at most one would have a three-dimensional invariant subspace,
zero Swan conductor and one nontrivial tame character on the complement.
Its determinant would be ramified, contrary to the central character.
Thus the Weil--Deligne monodromy is either zero or has Jordan type
(2,1,1). In the latter case its parameter has the form
`chi tensor Sp(2) direct_sum chi_2 direct_sum chi_3`, with unramified
characters; its standard Euler degree is three.

Take the spherical or essential Whittaker vector W with W(1)=1.
Use volume-one GL3(Z_q) measure temporarily and call the corresponding
mirabolic squared norm J_1. Iwasawa decomposition, the spherical Schur
formula and [MA, Corollaries 3.2-3.3] give

    J_1(W)=sum_(lambda_1>=lambda_2>=lambda_3>=0)
                  q^(-|lambda|) |s_lambda(alpha)|^2,      (43)

with alpha the four standard roots in the spherical case and the three
standard roots in the conductor-one case. For four roots one appends
lambda_4=0. The exponent in (43) comes from
`delta_B4(diag(a,1))/delta_B3(a)=|det a|`; it has no additional q-volume
factor. The actual norm in (40) is `J(W)=kappa_3(q) J_1(W)`.

For four roots, the Schur Cauchy identity sums all partitions. Removing
columns of height four shows that imposing lambda_4=0 multiplies that
sum by `1-q^-4 |alpha_1 alpha_2 alpha_3 alpha_4|^2=1-q^-4`,
since the central character is unitary. Thus

    J(W)=kappa_3(q)(1-q^-4) L_q(1,pi_q x dual(pi_q))
         =L_q(1,pi_q x dual(pi_q))/Delta_(4,q).            (44)

For three roots the Cauchy identity gives
`J_1(W)=L_formal(1)`, where
`L_formal(s)=prod_(i,j=1)^3(1-alpha_i conjugate(alpha_j) q^-s)^-1`.
This is not quite the full pair factor. On the Sp(2) self-pair the
kernel of monodromy has Frobenius roots q^-1 and 1; the naive product
of standard roots includes q^-1 but omits 1. All other summands match
the naive product. Therefore

    L_q(s,pi_q x dual(pi_q))=zeta_q(s) L_formal(s).

Unitarity identifies the contragredient standard roots with the
conjugates used above; there is no assumption that each inducing
character separately has modulus one. Combining the formulas gives

    [L_q(1,pi_q x dual(pi_q))/Delta_(4,q)] I_q(W)
       = (1-q^-4)/(1-q^-1)
       = 1+q^-1+q^-2+q^-3.                               (45)

In the spherical case the same product is exactly one, by (44).
The beta sum for the full K0(q)-space contains the corresponding unit
vector, so its product with `L_q/Delta_(4,q)` is at least one in both
cases. There is no positive or negative power of q to hide in a local
normalization.

For completeness, the rank of the pair monodromy in the conductor-one
case is six:

    (Sp(2)+2 Sp(1)) tensor (Sp(2)+2 Sp(1))
          =Sp(3)+4 Sp(2)+5 Sp(1).

Its dimension is 16, kernel dimension 10, and conductor 6 because
inertia is trivial. At q the pair conductor is therefore q^6 or 1.
Together with fixed level elsewhere and a fixed spectral window, this
gives `C(pi x dual(pi)) << q^6`. Bounded fixed level bounds the remaining
finite conductors; the bounded archimedean parameters bound their gamma
shifts. This is about pi itself, not its exterior-square transfer.

## 18. A fixed finite family of type translates

Here is the uniform repair of (39). Fix a compact Hecke idempotent e
of the original type, and r with K(r) in its kernel. Every generic
unitary representation containing e has principal depth at most r.
Choose once
`m>=max(1,r+d(4,Q_p))` from [ABN, Proposition 2.3], and put

    a_m=diag(p^(-3m),p^(-2m),p^-m,1),  K'=a_m K(m) a_m^-1.

For v fixed by K(m), changing variables `u=a_m n a_m^-1` in its
stable matrix-coefficient integral changes psi to psi_m. The Haar
Jacobian is `prod_(i<j) p^(m(j-i))=p^(10m)`. Therefore

    beta_(pi,psi)(e_K')=p^(10m) S_(pi,m)(psi_m)>=p^(10m). (46)

This sign of the conductor shift and this Haar power are essential.
The constant d is retained for p=5 or 7.

Let z_s be the Bernstein block projector. Its product
`E_s=z_s e_K'` is a compact Hecke function: apply the natural block
projection to the vector e_K' in the smooth regular Hecke module.
Its image is again a vector of that module, hence is compactly
supported; naturality makes the projection commute with right
translations. This is the essentially compact property of Bernstein
central distributions, not compact support of z_s itself.
On a representation in s,
pi(E_s)=pi(e_K') is an orthogonal finite-rank projection.
Fullness of the type idempotent in its block, as used in Section 11,
gives finitely many fixed compact Hecke functions x_j,y_j with

    E_s=sum_j x_j*e*y_j.

Each x_j*e is a finite sum `sum_i c_ji delta_(g_i)*e`.
To see this directly, take a common sufficiently small compact open H
on which e is left invariant and every x_j is right invariant.
Their compact supports meet only finitely many right H-cosets, and
`delta_(g h)*e=delta_g*e` for h in H.

Use the normalization of ell in (40). Unitarity gives
`||pi(y_j)||<=||y_j||_1`, while
`||ell pi(g_i) pi(e)||^2=beta_(pi,psi)(e^(g_i))`, where
`e^g=delta_g*e*delta_(g^-1)`.
The triangle inequality followed by Cauchy--Schwarz gives

    beta_(pi,psi)(e_K')
      =||ell pi(E_s)||^2
      <= [sum_j ||y_j||_1 sum_i |c_ji|
                       sqrt(beta_(pi,psi)(e^(g_i)))]^2
      <= C_e sum_i beta_(pi,psi)(e^(g_i)).                (47)

All the functionals after projection are bounded, so the operator
inequalities are legitimate. The last constant is finite and fixed;
one can take `C_e=sum_i (sum_j ||y_j||_1 |c_ji|)^2`.
There is no factor dim pi^{K'} or dim pi(e). Equations (46)-(47)
prove a uniform positive lower bound for the **sum** of these finitely
many conjugate-type masses. A separate g_i depending on pi was not
chosen by a compactness argument.

At each of the other fixed bad primes l, choose r_l so that the original
fixed level contains K_l(r_l). Choose fixed
`m_l>=max(1,r_l+d(4,Q_l))` and use the single projector onto
`a_(l,m_l) K_l(m_l) a_(l,m_l)^-1`. The same calculation gives beta at
least `l^(10m_l)`. These are fixed auxiliary tests, not new restrictions
on F(q). Their supports and all their determinant valuations are fixed,
and their determinants are units.

## 19. Removing the prescribed-point issue at infinity

Use the same compact spherical spectral window Omega as in (22).
For its normalized spherical Whittaker functions W_mu, [AB, (3.4)]
and the following norm formula give positive invariant mirabolic norms
J_mu uniformly bounded above. Their parameters have the inherited
all-place gap from the boundary. The functions depend continuously on
mu and none is identically zero. This is the finite-cover input used
in [B, Lemma 6], not a conclusion that W_mu(1) is uniformly nonzero.

For each mu in Omega choose a positive diagonal point g with
W_mu(g)!=0. Continuity gives a neighborhood with the same strict
lower bound at that point. A finite subcover selects fixed points
g_1,...,g_N and proves

    sum_j |W_mu(g_j)|^2/J_mu >= c_Omega>0
                     for every mu in Omega.               (48)

Choose the fixed compact bi-spherical h_0 of Section 13 with
`|hat h_0(mu)|>=1/2` on Omega, and write `H_0=|hat h_0|^2`.
For each j use the actual archimedean convolution factor
`h_(infinity,j)=h_0*delta_(g_j^-1)`.
It is a smooth compact function, and
`pi(h_(infinity,j))^*=pi(g_j) conjugate(hat h_0(mu)) P_K`
on a spherical representation. Its contribution is consequently
`H_0(mu)|W_mu(g_j)|^2/J_mu`.
Its convolution square has fixed conjugated compact support.
The finite sum has the uniform positive archimedean mass required
by (48). No archimedean scale grows with q or k.

## 20. The augmented weights and their lower bound

For each of the finitely many p-conjugates indexed by i, let
V_pi^i(q) have p-projector e^(g_i), q-projector e_K0(q), the other
fixed finite projectors chosen in Section 18, and the original
spherical line at infinity. Choose an adelically L2-orthonormal basis
B_pi^i(q). Let R(g_j) act at infinity only. Define

    w_dagger_pi(q)
      = H_0(pi_infinity)/V_q
          sum_(i,j) sum_(phi in B_pi^i(q))
                        |W_(R(g_j)phi)(1)|^2.            (49)

These are the actual weights of the new finite sum of tests, independent
of k and of all basis choices. They are not w_pi(q) in (22).
The original representation family is retained, and each representation
will be counted once regardless of the number of these auxiliary vectors.

Apply (41) to each term and sum the finite tensor-product bases. With
S_0 the fixed finite test places, the result is

    w_dagger_pi(q)
       = C_meas prod_(j=2)^4 zeta(j) / (V_q R_pi)
          * [H_0(mu) sum_j I_infinity(pi(g_j)v_sph)]
          * [(L_p/Delta_(4,p)) sum_i beta_p(e^(g_i))]
          * prod_(l in S_0, l!=p)
                    [(L_l/Delta_(4,l)) beta_l(E_l)]
          * [(L_q/Delta_(4,q)) beta_q(e_K0(q))].           (50)

All finite L_l here are the pair factors at s=1, not standard L-factors.
The p-factor is bounded below by (42), (46)-(47); the remaining fixed
finite factors by Sections 16 and 18; the archimedean factor by (48);
and the last factor by (44)-(45). Each lower bound is uniform in pi.

The finite global pair function has degree 16 and a simple pole at one.
It satisfies the hypotheses of [LI, Theorem 2]. The conductor bound in
Section 17 and that theorem imply `R_pi <<_eta q^eta` for every eta>0.
This is a residue upper bound, not a conjectural bound for individual
Fourier coefficients. Thus

    w_dagger_pi(q) >= c_eta/(V_q q^eta)
                    >= c'_eta q^(-3-eta).                (51)

All constants depend only on the fixed family, auxiliary choices and
eta, not q, pi or k. Equations (40)-(50) explicitly account for local
Whittaker normalization, fixed-place factors, the adelic L2 norm, the
archimedean norm, and the adjoint/Rankin--Selberg value. A positive
constant is not manufactured by changing the normalization of ell:
the stable pairing fixes its size, and the global formula uses exactly
that normalization.

## 21. Checking the changed test, then deriving the same count

One cannot simply attach (51) to (38), since their weights differ.
For each pair i,j take the genuine global convolution factor with
p-part `h_k^(g_i)`, infinity part `h_(infinity,j)`, the fixed projectors
of Section 18 at the other bad primes, and e_K0(q) at q.
Its square is positive. Centrality of BP_k and invariance under inner
conjugation give its scalar a_k(t_pi) on the conjugate type space.
The spectral computation of Section 13, with the displayed adjoint
action in Section 19, is exactly the corresponding summand in
`w_dagger_pi(q) a_k(t_pi)`.

Here are the changes to the geometric argument.

1. On each p-support `supp(A_k^(g_i))`, fixed conjugation multiplies
   the matrix and inverse bounds of (31) by at most
   `||g_i||_p ||g_i^-1||_p`. It preserves determinant valuation zero.
   The outer-minor exponent remains (k+2)/2, not k+2.
2. The reduced-operator bound for h_k is unchanged by conjugation.
   The proof of (18), applied with e^(g_i) and the original character,
   gives `D_psi(A_k^(g_i))<=M_b^2 D_psi(e^(g_i))`.
   The latter numbers are fixed and finite. At the other fixed places
   the new compact tests have fixed identity distributions.
3. The global character Psi and the K0(q) factor have not changed.
   Thus the compatible Weyl list and the q-divisibility conditions are
   exactly those of Section 10. Heights at the additional fixed finite
   and archimedean supports contribute only fixed constants to the
   product-formula inequalities. The six outer-minor cells still
   require `q<=C b^((k+2)/2)`; the 3412 square-minor cell requires
   the same inequality. Unit finite determinants preserve the
   central-normalization argument. Choose c smaller, once, to make
   all these inequalities impossible throughout `b^k<=c q^2`.

The finite sum of compact positive pretrace constructions is therefore
well defined with all seven nonidentity contributions zero. Dividing
by V_q cancels the unchanged local q identity distribution. The
noncuspidal contribution is a finite sum of squared complementary
projection norms; it is retained and nonnegative. Consequently

    sum_(pi in F(q)) w_dagger_pi(q) a_k(t_pi) <= C_fixed,
                              b^k<=c q^2.                (52)

This verifies the required upper bound for the changed tests, with
constants independent of q, pi and k. It is not a claim that arbitrary
changes of test preserve a Kuznetsov estimate.

For sufficiently large q choose `k=floor(log_b(c q^2))>=1`, so
`c q^2/b < b^k <= c q^2`. The inherited bound `t_pi<=T=5/22`
keeps the cutoff away from zero. For every t_pi>=tau,

    a_k(t_pi)>=d_T^2 b^(2k tau)
              >=d_T^2 (c/b)^(2tau) q^(4tau).

Combine this inequality with (51)-(52), taking eta=epsilon. Each
representation being counted contributes at least a fixed positive
multiple of `q^(4tau-3-epsilon)` to (52). It follows that

    #{pi in F(q):t_pi>=tau} << q^(3-4tau+epsilon),
                          0<tau<=1/8.                    (53)

The finitely many smaller q are absorbed into the constant: for fixed
level and bounded spherical spectrum the relevant cuspidal space is
finite dimensional. This proves the claimed implication without
counting invariant-vector dimensions, assuming no transfer-fibre
bound, and without strengthening the pointwise estimate.

## 22. Comparison and present certification status

The strongest prior result for the actual test was the independently
verified weighted inequality (38), which allowed zero weights.
The new mathematical content is a fixed finite local repair and the
complete normalization argument giving (51), together with a check of
the modified geometry in (52). Their reviewed conclusion is the same
unweighted family count (1), not a weighted or altered-family output.
The literal arbitrary-position lower bound (13) is not submitted as
proved; its zero-weight obstruction and the need for a changed test
are part of the result.

The primary-source comparison in Section 6 remains the strongest
recorded transferred-family comparison: (14a) has exponent
`16(1-4tau)`, even before accounting for unknown transfer fibres.
Its gap from (53) is `13-60tau>=11/2` on the requested interval.
The new proof addresses the original ramified family directly.
Blomer's prime-level exponent agrees with (53) at an unramified
detecting place, but his standard local coefficients vanish here.
The principal-level results [AB] and [ABN] supply specific
normalization inputs, not the growing mixed-level estimate.

These comparisons identify a mathematical difference from the cited
theorems. They do not prove that the argument or its consequences are
new in the literature. The host's round-4 review subsequently supported
the analytic proof and independently attributed the ten new normalization
source occurrences. Section 24 addresses the separately outstanding
publication assessment. The result is not yet an accepted publishable
result, not a solution of generalized Ramanujan, and not a new pointwise
bound. No Lean certificate is claimed.

## 23. Exact replay for the unweighting continuation

Run the new finite certificate from the campaign root:

    python3 -B research/gl4_ramified_type_exact.unweighting.py \
      --jacobian-input research/jacobian/ramified-unweighting-fourier-input.json \
      --jacobian-output research/jacobian/ramified-unweighting-fourier-output.json

The saved output is `gl4_ramified_type_exact.unweighting.json`. It
binds the source, reused exact-arithmetic helper, adapter input and
adapter output by SHA-256. It checks the following distinct finite
facts, not the analytic theorem as a black box:

* The p=5 instance of (39), exact cancellation of all ten distinct
  Fourier character pairs on C5, and the inverse of `1-zeta_5`.
  The all-prime type-kernel obstruction is the equivariance proof in
  Section 15, not an extrapolation from this finite group.
* The six positive-root exponents summing to the Haar exponent 10.
* The 16-dimensional map `X -> NX-XN`, its rank 6, square rank 1
  and cube zero, and an exact ten-dimensional homogeneous kernel.
  Its formal Frobenius weights differ from the nine naive product
  roots by precisely the extra root 1, justifying the Euler-factor
  algebra in (45) once the local parameter is specified.
* The polynomial identity
  `kappa_3(x)(1-x)(1+x+x^2+x^3)=kappa_4(x)`, and the spherical
  `kappa_3(x)(1-x^4)=kappa_4(x)`. These are exact polynomial
  identities, not floating-point estimates at selected q.

Four negative cases are rejected: a false/incomplete Fourier verdict,
the wrong conductor shift, omission of the scalar pair-kernel vector,
and omission of the Tamagawa mirabolic volume. The typed Jacobian
operation was `finite_abelian_group.spectral_pair.decide`, run once
through the Argus sidecar on the complete five-element group after
inspection of its contract. It returned SPECTRAL with exit zero,
runtime 1 ms, server 0.14.0 and protocol 2025-11-25, without an error
or timeout. The exact payload and typed output are preserved under
`research/jacobian/ramified-unweighting-fourier-*`.

The operation does not certify p-adic type theory, the infinite Schur
sum, the global period formula, the finite-test norm inequality, or
originality. The analytic proofs and cited inputs received the round-4
review described above; publication claims require their own review.
The previous support, cutoff, Weyl-cell
and rejected SOS diagnostics were unchanged and were not repeated.

## 24. Publication assessment of the frozen theorem

### 24.1. Statement, quantifiers and accepted evidence

The theorem being assessed is exactly (53), over **Q**, not an extension
to every number field. Fix p>=5, a unitary supercuspidal sigma of
GL2(Q_p), the original unitary central character, the original fixed
finite-level conditions away from the growing prime, and the original
compact **spherical** archimedean spectral window Omega. The type and
all other auxiliary fixed data in Sections 2-23 are fixed independently
of q. Let q vary over primes outside this fixed bad set.

For source statements normalized to have central character trivial on
the embedded positive reals, use one fixed unitary norm twist and its
inverse. This bijection preserves t and the conductor exponents, and
only translates the fixed spectral window and fixed sigma by unitary
twists. It is a comparison normalization, not a new restriction on F(q).

F(q) is the original set of isomorphism classes of unitary cuspidal GL4
automorphic representations satisfying those conditions, having nonzero
K0(q)-invariants, having cuspidal exterior-square transfer, and satisfying

    pi_p = Ind(sigma |det|^t tensor sigma |det|^-t),
    0 <= t < 1/2,

with normalized induction. This is the specified complementary ray,
not the entire Bernstein component, a varying-depth family, or a family
with freely varying unitary twists. Conductor-zero representations at q
are not removed. Each representation is counted once.

For every such fixed data, every **fixed** 0<tau<=1/8, and every
epsilon>0, there is C depending on those data, tau and epsilon such that

    N_q(tau) := #{pi in F(q): t_pi>=tau}
              <= C q^(3-4tau+epsilon)

for every admissible prime q. No uniformity as p, sigma, Omega or tau
varies is asserted. The bound t<=5/22 is inherited, not improved.
The auxiliary finite sum (49) changes the tests, not F(q); (22) need
not have a positive representation-wise lower bound.

The accepted mathematical evidence is the host review of Sections 15-23,
following the earlier support and weighted-pretrace reviews, and the
already replayed exact certificates listed in Sections 7, 14 and 23.
This assessment changes no analytic argument or finite certificate.
It does not turn a manuscript judgment into a compiler proof. The
ledger statement and context of C_GL4_RAMIFIED_REPAIRED_DENSITY are
not revised merely to replace their historical staging language.

### 24.2. Closest primary results and actual consequences

Versioned locators and reader/access qualifications are in
`literature/gl4-ramified-density-sources.txt`. The following compares
statements and specific deductions, not titles or search-result snippets.

| Primary result | What it supplies | Consequence for the frozen claim |
|---|---|---|
| Blomer [B], Theorems 1-2 | For the spherical prime-level family, unramified detection gives q^(3-4tau+epsilon); the standard-Hecke range is mZ<=c q^2. | This is the closest exponent and method. The ramified pi_p here has standard Euler factor 1. Its Hecke coefficients do not detect t. Neither theorem states the growing type-test estimate used here. |
| Assing--Blomer--Nelson [ABN], Theorem 1.1 | Principal-level density, with detecting place outside the level, and the improved volume exponent 1-(2tau/(n-1))(1+1/(n+1)). | An embedding into principal level Nq has p dividing N. The detecting-place hypothesis fails. Even a counterfactual extension has a much worse volume scale; see below. |
| Finis--Lapid [FL], Definition 1.2 and Theorem 1.4 | Limit multiplicity for non-degenerate congruence families, with finite places allowed in S. | This does cover ramified local detection qualitatively: the bounded non-tempered set t>=tau contributes o(q^3). It must not be dismissed as spherical-only. Theorem 3.2 and Section 2 do not supply the support-uniform quantitative approximation needed for 4tau. |
| Finis--Lapid--Mueller [FLM], Theorem 7.10 and Remark 7.11 | A normalized principal-level trace error with power saving, for the specified fixed support/type class. | A trace estimate is not yet a spectral-set count. The remark leaves quantitative approximation untreated; principal-level volume is also different. |
| Brumley--Milicevic [BM], Theorem 1.3, Definition 1, Remarks 1(1), Propositions 9.1-9.2 | Effective limit multiplicity and density using archimedean localization; an explicit remark permits other shrinking compact-open subgroups. | The level-shape extension is acknowledged. Its detecting weight involves Re(nu_pi,infinity), not t_pi,p, and does not state the requisite growing ramified Bernstein-test bound. |
| Matz--Templier [MT], Theorems 1.1, 1.4 and Corollary 1.8; Assing--Jana [AJ], Theorem 1 | Quantitative polynomial detection in a growing archimedean family with unramified finite test places. For n=4, [AJ] gives X^(9-12theta+epsilon). | The variable is the archimedean cutoff X, with finite level one, not q with fixed Omega. Permitting nonspherical infinity does not permit the present ramified pi_p. |
| Lichtman--Pascadi [LP], Theorems 1.2 and 1.5, Remark 1.7 | General-conductor and prime-level improvements for unramified detecting places; the general displayed scale is C^(n(1-2theta)/(2theta)+epsilon). | The August 2026 revision was included. Remark 1.7 discusses ramified extensions as a possibility, not as the theorem supplied here. |
| Pascadi--Thorner [PT], Theorem 1.8 and the following PDF remark | Density of standard Euler roots, including at ramified places, with a maximum-pair-conductor refinement. | Direct use is vacuous for pi_p. Transfer does detect t, but gives the weaker distinct-transfer estimate below and requires a separate fibre bound to count pi. Its more general Rankin--Selberg sieve is considered separately below. |

For [FL], put p and the other fixed bad places in S. The archimedean
window and a common compact-open stabilizer at the fixed finite places
make the local spectral set bounded. The inherited upper bound T<1/2
and tau>0 keep this complementary set away from the tempered endpoints.
The mixed K0(q) family is non-degenerate. Its normalized non-tempered
mass tends to zero; its finite invariant-vector multiplicities are at
least one, so the representation count is o(q^3). This uses ambient
volume, not an asymptotic for F(q). What is added by (53) is a specified
power saving for each fixed tau, not the first qualitative density-zero
statement at a ramified place.

The principal-level shortcut has two independent problems. First,
enlarging the fixed level does not make pi_p unramified. Second, principal
SL4 level Nq has volume of order q^15, not q^3. If one disregarded the
first problem, the [ABN] exponent would give q^(15-12tau+epsilon).
Its recorded bound on principal invariant dimensions is at most
q^(6+epsilon). Even pretending one could divide by that full factor
would leave q^(9-12tau+epsilon), worse than (53) by 6-8tau>=5.
An **upper** bound on invariant dimensions does not license this
division; this is a deliberately optimistic numerical diagnostic, not
an application of [ABN] or a claimed density bound.

Twisting by a character does not fix the detecting-place obstruction:
a character twist of the GL2 supercuspidal sigma is still supercuspidal,
and still has no inertia-invariant standard Weil subspace. Nor does an
inertial-class projector grow with t. Fixed-level insertion into a
spherical trace formula and **uniformity in the degree of a growing
ramified test** are different assertions.

The [FL]/[FLM] support and approximation limitations and the [BM]
archimedean localization do not prove their methods incapable of such
an extension. They show why the displayed theorems and remarks are not
already the required quantitative corollary. Optimizing those proofs
for this test would be additional mathematics, not an existing bound
that this assessment has verified.

### 24.3. Stronger transfer and auxiliary-sieve comparisons

The strongest recorded **exterior-square** comparison is (14a), not
the coarse q^(24(1-4tau)+epsilon). The fixed twist of the cuspidal GL6
transfer has a standard root of modulus p^(2t). At q its monodromy is
2 S_2+2 S_1; the pair has rank 16. The PDF remark after [PT, Theorem
1.8] consequently gives

    #{distinct qualifying twisted transfers}
       << q^(16(1-4tau)+epsilon).

On 0<tau<=1/8 the exponent gap is 13-60tau>=11/2, and at tau=1/8
the exponents are 8 and 5/2. This is a comparison of distinct transfers.
No uniform fibre bound has been proved; it cannot be silently promoted
to a count of the original pi. Conversely, no impossibility of a
family-specific transferred argument is inferred.

There is a further plausible deduction that should not be hidden behind
the vanishing standard factor. [PT, Theorems 1.1 and 5.1] treat
Rankin--Selberg coefficients themselves; an automorphic GL4 x GL2
tensor-product transfer is **not** required. For a favourable comparison,
grant a fixed cuspidal GL2 representation rho with rho_p=dual(sigma).
This auxiliary globalization is granted only for the comparison, not
added to the hypotheses of (53). Put b=p^f as before. The local pair
factor and its coefficients are

    L_p(s,pi x rho)
       = [(1-b^t p^(-fs))(1-b^-t p^(-fs))]^-1,
    lambda_(pi x rho)(p^(fj))
       = sum_(a=0)^j b^((2a-j)t) >= b^(jt),
    lambda_(rho x dual(rho))(p^(fj)) = 1.                 (54)

The last equality uses the same fixed supercuspidal self-pair factor
already used in Section 16. Thus this detection is real, not vacuous.
Theorem 5.1, (5.2), with a single coefficient supported at p^(fj),
gives a mean square O(q^epsilon X) at length
X>=Q^8 |S|^eta for a GL4 family S of conductor Q<<q. Choosing
b^j comparable to X and absorbing the arbitrary small powers gives
the coarse comparison q^(8(1-2tau)+epsilon).

One can make this comparison more favourable using the pair conductors,
just as in the published refinement. For the original GL4 family,
the q-monodromy is S_2+2 S_1. Two such blocks tensor to

    S_3+4 S_2+5 S_1,

of rank 6; one unramified factor gives rank 4. Thus the maximum pair
conductor is O(q^6), with all other data fixed. The negative-line
estimate in [PT, Lemma 5.2] and the paragraph deriving (5.2) depend
on this pair conductor; replacing the coarse Q^8 there by its actual
maximum permits X=q^(6+o(1)), with the small |S|^eta factor absorbed
using their polynomial family-size bound. Equation (54) then gives
the favourable auxiliary-sieve comparison

    N_q(tau) << q^(6(1-2tau)+epsilon),                    (55)

under the granted availability of rho. This is a deduction for comparison,
not a new campaign result or a claim that Theorem 1.8 directly detects
ramified inducing exponents. It counts original representations, so it
has no transfer-fibre problem. Its exponent still exceeds (53) by
3-8tau>=2: at tau=1/8 it gives 9/2 rather than 5/2.
This stress test is stronger than comparing only the GL6 transfer, but
is itself weaker than ambient O(q^3) control throughout this interval.
It does not exclude other, more efficient uses of the covered-coefficient
sieve. Independent publication review should check this deduction and
the stated support limitations, not merely the weaker coarse transfer.

### 24.4. What is potentially new and why the size matters

The candidate contribution is **the combination** of a ramified detector,
its precise growing-support realization, and an unweighted mixed-level
estimate with exponent 3-4tau. The following are not claimed as new:
type existence and affine-Hecke theory, Plancherel inversion, positive
convolution squares, compact Whittaker covers, principal-level Bessel
lower bounds, the GL_n period formula, or the general strategy of
amplifying non-tempered spectrum.

There are concrete quantitative tasks between those known inputs and
(53). The ordinary power-sum multiplier has the Steinberg cost (6).
The degree-two cutoff removes that stratum while retaining a uniform
gain on the inherited interval. Degree alone does not give the needed
matrix/inverse support. The actual lattice-chain realization and the
3412 square-minor constraint give the q^2 range for this ramified test.
Finally, an allowed type position can have zero prescribed Whittaker
mass. The finite type-conjugate construction supplies a uniform lower
bound without a dimension loss, and the **same changed tests** are
checked in the upper bound. These are the nontrivial links being
submitted as the technical contribution, rather than a claim that
renaming a known Hecke index proves the result.

The quantitative significance is an absolute exceptional-count bound.
Since V_q=q^3+q^2+q+1, the saving from the ambient volume exponent is
4tau (up to epsilon): for tau=1/16 the exponent is 11/4, and for
tau=1/8 it is 5/2. It replaces the applicable qualitative o(q^3)
comparison by a specified power saving in a direction invisible to the
standard Euler factor. It attains the numerical unramified prime-level
exponent without claiming to improve that known exponent.

There is **no proved asymptotic #F(q)~c q^3**, no positive Plancherel-mass
assertion for this exact ray, no proved abundance of such global
representations, and no constructed exceptional representation. In
particular, (53) must not be advertised as a relative exceptional
proportion q^(-4tau) within F(q), or as a proven nonvacuous lower/upper
asymptotic for that restricted family. Non-tempered exceptions are
conjecturally absent. The reason for considering the result substantial
is uniform quantitative control of that possibility, not an assertion
that exceptions exist. No claim about a sharp ramified L^r/Sarnak--Xue
benchmark is needed for this recommendation.

### 24.5. Assessment and independent-review boundary

**Engineer assessment:** the evidence supports submitting this as a
candidate **new theorem of publication-level significance**, specifically
a quantitative ramified-type extension of prime-level density, not a
new pointwise Ramanujan bound. The positive basis is the applicability
analysis above and the identified quantitative links not furnished by
the cited statements. It is not the absence of a matching search hit
or the length of the proof.

This is not yet a verified-new publishable result. The host Reviewer
must separately decide whether the ramified growing-support estimate
and dimension-free finite-test repair are a genuine contribution rather
than an immediate existing consequence, and whether their restricted
but explicit quantitative scope is substantial enough. The old analytic
acceptance answers neither question. The new comparison-source
occurrences also need independent attribution; earlier accepted source
readings should be reused rather than rerun without a concrete conflict.

The bounded lookup obtained the selected public primary versions. It
did not establish an exhaustive census of all later versions, papers,
or unpublished consequences. The selected [FL]/[BM] proofs might admit
an unrecorded optimization, and the full covered-coefficient machinery
in [PT] might have further consequences not exhausted by (54)-(55).
These possibilities remain explicitly unresolved; no global
non-derivability theorem is asserted. Publisher versions were not
silently substituted for the pinned preprints. The p. 7 [PT] remark is
reused from the accepted PDF reading because the retrieved HTML omits it.

The new review should address Sections 24.1-24.5 and their source
locators, including (55), the transfer-fibre limitation and the missing
restricted-family asymptotic. It should reopen Sections 2-23 only if a
specific conflict with a source or with the frozen statement appears.
Until that review accepts both novelty and significance, the public
statuses remain `novelty_status=unverified`, campaign incomplete, with
no replacement proof route started in this bounded review mission.

## 25. Precise source implications

The following supplies the source-to-assumption arguments for the seven
occurrences in `C_GL4_RAMIFIED_SHARP_SUPPORT`,
`C_GL4_RAMIFIED_SOURCE_SCOPE`, and `C_GL4_RAMIFIED_TYPE_LOCAL`.
It does not change (51)-(53), the family in Section 24.1, or its
quantifiers. Actual primary passages, mathematical transcriptions and
explicitly labelled deductions are retained separately in
`literature/gl4-seven-source-types.txt`,
`literature/gl4-seven-source-density.txt`, and
`literature/gl4-seven-source-plancherel.txt`.

### 25.1. Generator supports and the parameter

For `SIMPLE_TYPE_GENERATOR_SUPPORT`, [SIII] uses a proper simple-type
order, compatible extensions and its specified affine-Hecke realization.
Theorem 4.6 supplies the reflection and cyclic supports `J s_0 J` and
`J omega J`; Proposition 4.16 extends support preservation to the affine
basis. Proposition 4.5 concerns its specified comparison of simple
types, not every equivalence of Bernstein categories. In the split case
the division algebra centralizing E is E, so the cyclic representative
in formula (17) is precisely the omega of Section 11.

Here is the parameter conversion used in (27)-(30). In [SS], Theorem B
gives parameter `p^(n(sigma) s(sigma))`; for split GL2,
`s(sigma)=1`, and the torsion number `n(sigma)` is our f.
Proposition 5.7 gives the same parameter as `|k_E|^s`.
Writing `|k_E|=p^f_E` and `[E:Q_p]=e_E f_E`, we obtain

    f=s f_E,       s e_E f_E=2,       e_E=2/f.

Thus `p^(d/e_E)=b^(d/2)` is a consequence of the two parameter
descriptions, not a rescaling of the exponent in the theorem.
The normalized cover identifies the Levi unramified-twist characters
with the Bernstein generators. The determinant valuation of the Levi
translation `varpi_E I_s` is `s f_E=f`; its twist character is therefore
`chi(p)^f`, rather than `chi(p)`. Fixing sigma as origin calibrates the
common scalar in the cyclic generator. This is the normalized
parabolic-induction identification used in (28), not an arbitrary
abstract isomorphism of centers.

The sources supply these generators and comparisons. The all-index
lattice inclusions (29)-(30), their bounded rounding cost and the
cofactor argument (32) are the separate proofs in Section 11.
No growing-support or orbital-integral estimate is attributed to
[SIII] or [SS].

### 25.2. Fullness is an algebraic finite-span argument

For `TYPE_CATEGORY_FULLNESS`, the categorical equivalence in the
Introduction of [SS] and the cover in Theorem B and Proposition 5.7
are the cited input. The following supplies the asserted consequence.

Let `A=C_c^infinity(GL4(Q_p))`, with convolution and compact-open local
units, and let e and e_0 be the scalar idempotents of two types for
the same Bernstein component s. The smooth modules Ae and Ae_0 lie
in that component. For any smooth V in the component put
`N=A e_0 V`, meaning its algebraic span. Since e_0 is idempotent,
`e_0 V` lies in N. The quotient V/N is still in the component and
has zero e_0-part. The type equivalence detects zero objects, so
`V/N=0`.

Apply this to `V=Ae` and its vector e. Algebraic span means a finite
sum, giving

    e=sum_j x_j*e_0*y_j,       x_j in A, y_j in Ae.

All factors are compactly supported. They can be chosen once for the
fixed pair of types, independently of k, q and the representation.
Reversing e and e_0 gives the reverse factorization; applying the same
generation argument to the regular block gives fullness in its
two-sided ideal. There is no topological completion or infinite sum.

For a central block multiplier Z, naturality gives exactly (31).
Hence its support transfers through finitely many fixed left and
right compact supports. Abstract category equivalence alone does
not preserve individual double cosets; the finite factorization,
together with the actual simple-type support proof, is what transfers
the matrix-norm estimates. The Bernstein projector used to select the
block need not itself be compactly supported.

### 25.3. The center and compact realization

For `RAMIFIED_TYPE_CENTER`, [SS] constructs the type and affine algebra;
Theorem 7.2(iii) preserves supports for its specified cover comparison.
The center and compactness conclusion also uses the following algebra,
which is not quoted as part of that theorem.

Put `r=sqrt(b)`, `c=r-r^-1`, and use the normalized T,O of Section 11.
Set `X=TO`, `Y=OT^-1`. They are invertible, `XY=YX=O^2`, and

    T X - Y T = c X,       T Y - X T = -c X.

Let `R=C[X^+-1,Y^+-1]` and let iota interchange X,Y. The relations give

    T a = iota(a) T + c X (a-iota(a))/(X-Y),       a in R.

The quotient on the right is Laurent polynomial: clear an invariant
power of XY and use divisibility of antisymmetric polynomials by X-Y.
Together with `T^2=1+cT`, this gives the normal form `R+RT`.
To see independence, on the rational-function field in X,Y represent T
by

    U = r iota + c X/(X-Y) (1-iota).

Direct multiplication verifies the quadratic and cross relations;
with `O=U^-1 X` it also gives `O^2=XY`, as required by the original
cyclic-generator presentation.
The coefficient of iota is `(r^-1 X-rY)/(X-Y)`, a nonzero rational
function. The identity and iota are linearly independent over that
field, as follows by applying them to 1 and X. Thus `a+dU=0` forces
d=a=0, proving uniqueness of the normal form.

If `a+dT` is central, its commutator with X has T-coefficient
`d(Y-X)`. Since R is a domain, d=0. Its commutator with T then forces
`a=iota(a)`; conversely this condition kills the cross-relation
correction. Therefore

    Z(H(2,b))=C[X^+-1,Y^+-1]^(S_2).

This proves the assertion for regular functions, not meromorphic
functions or infinite series. The inertial torus is
`(X_nr(GL2)/X_nr(sigma))^2`; two twists represent the same
supercuspidal precisely when their ratio is a self-twist. Its
coordinates are therefore the z_i of Section 2, and the normalized
cover identifies X,Y with these coordinates, up to their interchange.

The scalar corner eAe is a matrix algebra over the type-Hecke algebra,
using the finitely many matrix-coefficient units for lambda in C_c(J).
A central regular Z corresponds to Z times the identity matrix.
Every Laurent expression uses finitely many products of compactly
supported generators and inverses, and the matrix units are compactly
supported. Consequently Ze is in A. Section 25.2 gives the same
conclusion for any other fixed type in the component. This proves
compactness for each finite polynomial; it does not infer a uniform
support bound from degree.

There is a bounded symbolic check of the coefficient algebra, separate
from the proof above. Put `S=X+Y`, `D=XY`. On the basis 1,X over the
invariant field, the multiplication-by-X and T matrices are

    M=[[0,-D],[1,S]],       U=[[r,rS],[0,-r^-1]].

For a matrix `V=[[a,h],[j,d]]`, three necessary entries of
`[V,M]=[V,U]=0` are

    (r+r^-1)j=0,       h+Dj=0,       -a-Sj+d=0.

Their solutions are exactly scalar matrices, which also satisfy the
remaining commutator entries. The exact system is retained in
`literature/gl4-seven-source-center-input.json`; the inspected contract
and typed output use the matching `-contract.json` and `-output.json`
names. It is independently rerunnable with

    /home/argustest/zimo/argus-live-update/.venv/bin/python \
      -m argus_skill.tools.jacobian run \
      --operation matrix.symbolic.linear_system.solve \
      --payload-file research/literature/gl4-seven-source-center-input.json

The adapter works over `QQ(r,S,D)`, not all specializations. For the
present `r=sqrt(b)>1`, the explicit elimination above also works at
every S,D, since `r+r^-1` never vanishes. This finite check does not
certify type theory, Plancherel, or the global density theorem.
The recorded run returned `NON_UNIQUE`, zero particular solution and
kernel basis `(1,0,0,1)`. Its returned system matches the exact input.
The rank-three minor on columns a,h,j is `r+r^-1`, so the displayed
kernel is complete, not merely a supplied solution vector.

### 25.4. The two tempered strata

For `RAMIFIED_BLOCK_PLANCHEREL`, [AP] Theorems 2.1 and 2.3 give
ordinary group Plancherel and its Bernstein decomposition, with
`vol(GL4(Z_p))=1`. Section 5 parametrizes the tempered component by
partitions of the repetition number. For repetition two the only
partitions are (1,1) and (2): unitary principal inductions and unitary
unramified twists of `St(sigma,2)`. Remark 4.2 gives support exponents
`-1/2,+1/2`. The quotient map in Section 4 is the f-th power map, so
the latter stratum has coordinates
`{u b^(1/2),u b^(-1/2)}`, `|u|=1`.

For its Levi M=G, the Plancherel density is its positive formal degree.
Positivity follows from the Schur-orthogonality squared norm of any
nonzero discrete-series matrix coefficient modulo the center.
The orbit has positive measure, not a positive atom at each fixed
central character. A type has nonzero, constant finite projection
rank along that orbit: an unramified character is trivial on its
compact group. This proves `c_St>0` in (6). The other stratum
contributes at most `4e(1)`. The zero of B on the entire discrete-series
orbit and its bounded value on the principal torus then prove (10)
by Plancherel. These deductions explain the exact role of the source;
they do not identify a Whittaker distribution with evaluation at 1.

### 25.5. The three global comparison inputs

`BLOMER_UNRAMIFIED_RANGE` uses [B], arXiv:1906.07459v2, Theorems 1-2
for n>=3, prime q, a fixed bounded spherical spectral window, and
`v!=q`. Its finite detecting place is unramified. The second-moment
theorem requires `(m,q)=1`, `Z>=1`, `mZ<=c q^2`; the density exponent
is `n-1-4sigma+epsilon`. Equation (5.3) bounds the normalized
Fourier-coefficient square below by
`|lambda_pi(m)|^2 q^(-(n-1)-epsilon)`. This uses an upper bound for
the adjoint value, not just nonvanishing. The coefficient is after
factoring off the archimedean Whittaker function, not `W_phi(1)`.

Lemma 7 and Section 7 use the indices `M=N=(m,1,...,1)` and
`X=(Z,1,...,1)`. At the q^2 range Blomer retains and estimates the
cell w_*; all nonidentity terms vanish only in his smaller q range.
This clarification is important: the separate ramified-type
all-cell argument in Sections 11-13 is not a quotation of Blomer's
q^2 proof. Neither theorem asserts a growing ramified-type extension.

`PT_STANDARD_ROOT_DENSITY` uses [PT], arXiv:2508.14888v2,
Theorem 1.8, (1.22), and (3.1). Retain a finite subset S of the
unitary cuspidal GL_n family with central characters trivial on the
embedded positive reals, its actual maximum analytic conductor Q,
`Q>=D_F^c(n,epsilon)`, a prime ideal P and `theta>=0`. Its bound is

    N(P)^n (D_F^(-n^2) Q^(2n))^(
                             (1-2theta)/max(1,4theta)+epsilon).

Equation (3.1) defines the alpha_j as standard Euler roots, with
zeros allowed for the missing degree at a ramified prime. It does
allow ramified P. When the local factor is 1, all these roots are
zero, so the particular standard-root detector is silent. The
inertia-invariant proof in Section 1 establishes exactly this
situation for (2); it does not exclude other Rankin-Selberg tests.
The fixed norm twist in Section 24.1 supplies the source's central
normalization without changing the family being compared.

`PT_PAIR_CONDUCTOR_REFINEMENT` uses the actual remark immediately
after Theorem 1.8 on PDF p. 7: replace the base
`D_F^(-n^2) Q^(2n)` by
`max_(pi,pi' in S) C(pi x dual(pi'))`. The original finite-family,
normalization and Q-range hypotheses remain in force. This still
counts distinct members satisfying the standard-root condition.
For a transfer-image family it counts images; neither the theorem
nor the remark supplies a fibre bound. The PDF passage, not an
omitting HTML rendering, is the evidence for this refinement.

The seven occurrence-specific readings support these precisely
scoped dependencies. They are source attributions and the displayed
deductions, not a new independent certification of (53), a stronger
bound, or a renewed publication verdict.
