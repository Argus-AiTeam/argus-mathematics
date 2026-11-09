# The ramified GL4 degree-20 route

## Result and scope

This note proves the representation identities and derives the inherited
comparison `t <= 5/22`. It isolates, but does not prove, the analytic estimate
that would give `t <= 19/84`. Neither the comparison nor the identities are
claimed to be new. No publishable improvement, exact global example in the
specified local family, or independent certification is established here.

Let pi be a unitary cuspidal representation of GL4(A_Q), with cuspidal
exterior-square transfer Pi on GL6(A_Q). Write omega for the central character
of pi. At a fixed prime p >= 5 assume

    pi_p = Ind(sigma |det|^t tensor sigma |det|^-t),  0 <= t < 1/2,

with normalized induction and sigma unitary supercuspidal on GL2(Q_p).
The local transfer is understood in the local Langlands normalization.

The source inputs and their verification limits are:

* Blomer-Brumley, arXiv:1003.0559v4, Definition 1, footnote 1, Theorems 1-2,
  Section 1.2, and Section 3, read directly. Theorem 2 requires absolute
  convergence of the symmetric-square L-function on Re(s)>1 and then applies
  at every place. The GL4 bound 9/22 already includes ramified places.
* Rankin-Selberg absolute convergence for unitary cuspidal representations
  on Re(s)>1, as explicitly recalled in the final paragraph of their
  Section 1.2. This is a known input, not a result of this note.
* Kim's exterior-square transfer, JAMS 16 (2003), Theorem A,
  DOI 10.1090/S0894-0347-02-00410-1. A research worker read the local
  compatibility statement in the introduction, p. 1, of the
  Asgari-Raghuram author manuscript dated 9 September 2008,
  https://math.okstate.edu/people/asgari/Files/cuspidality.pdf .
  The possible exceptions described there are places over 2 or 3 with
  supercuspidal GL4 component. They do not affect p >= 5.
  Kim's original theorem text was not obtained; direct primary-source
  attribution remains outstanding. The inducing GL2 supercuspidality is
  not the exceptional GL4 condition.

These are mathematical inputs with citation obligations, not kernel-certified
claims. In particular, reading a secondary attribution is not represented as
reading Kim's original theorem.

## 1. Exact representation identities

Work over C. Put V=C^4, W=Lambda^2 V, and d=det(V). The wedge pairing
W tensor W -> d is nondegenerate and symmetric. Hence
W^vee = W tensor d^-1. Its differential embeds sl(V) in so(W); the map is
injective (and both sides have dimension 15). Including scalar endomorphisms
gives an equivariant embedding End(V) -> End(W). Complete reducibility gives
a complement of dimension 36-16=20.

More precisely,

    Lambda^2(W) tensor d^-1 = sl(V),
    Sym^2(W) tensor d^-1 = 1 direct_sum R20,
    End(W) = End(V) direct_sum R20,
    R20 = S_(2,2)(V) tensor d^-1.

The invariant line in Sym^2(W) tensor d^-1 is the inverse wedge pairing.
The last identity also follows from the Schur-character identity
s_(2,2)=h_2^2-h_1 h_3. Thus R20 is a genuine irreducible representation,
not just a virtual difference.

The standard-library program `gl4_degree20_exact.py` checks these as exact
Laurent-character equalities, checks all weight multiplicities, constructs
the 36-by-16 matrix of the differential on the basis E_ab, and computes
its rank over Q. Its character checks quantify over a diagonal torus with
independent variables, not a finite list of numerical matrices. Characters
determine these complex reductive-group representations.

The first five matches from the bounded Jacobian discovery query contained
no directly relevant representation-decomposition operation.
The inspected `matrix.rank.compute` contract does match the inclusion-rank
subproblem. The initial 36-by-16 payload was rejected by an actual runtime
32-row limit, despite the displayed schema allowing 64 rows. That error
is preserved and is not mathematical evidence. The revised payload is an
explicit 16-by-16 full-rank row minor of the same matrix. A nonzero rank-16
minor certifies rank 16 of the original 16-column matrix. The program records
the zero-based row indices so the extraction can be checked exactly.

## 2. Ramified local detection

Let r be the two-dimensional Weil representation of sigma, let delta=det(r),
and write nu=|.|_p. Unitary supercuspidality makes r bounded, with monodromy
N=0. Define the bounded three-dimensional representation

    A = Ad(r) = Sym^2(r) tensor delta^-1.

The local parameter V_p = r nu^t direct_sum r nu^-t has

    W_p = delta nu^(2t)
          direct_sum (Sym^2(r) direct_sum delta)
          direct_sum delta nu^(-2t).

The middle summand is bounded. Consequently m(Pi,p)=2t, including the
interpretation m=0 at t=0. Cuspidality and the unitary central character
make Pi unitary. Its local unitarity already forces 2t<1/2 when t>0.

Since omega_p=delta^2, applying the preceding identities gives

    R20(V_p)
      = nu^(4t) direct_sum nu^(-4t)
        direct_sum (1 direct_sum A) nu^(2t)
        direct_sum (1 direct_sum A) nu^(-2t)
        direct_sum (1 direct_sum A direct_sum Sym^2(A)).

For t>0 the dimensions at exponents -4t,-2t,0,2t,4t are 1,4,10,4,1.
The direct-sum identity also holds at t=0, when those exponents coalesce.
The two extreme characters are trivial on inertia, independently of the
ramification of delta or of r. This is why the degree-20 Euler factor detects
4t even though the original standard local L-factor may be trivial.

With Frobenius normalized by nu(Frob_p)=p^-1, the local factor has the
reciprocal-polynomial form

    L_p(s,R20) = product_j (1-beta_j p^-s)^-1,
    max_j |beta_j| = p^(4t).

For t>0 the root p^(4t) occurs exactly once; all other roots have modulus
at most p^(2t). It cannot be canceled, since the local numerator is 1.
If a(p^ell) are these local coefficients, Cauchy-Hadamard therefore gives

    limsup_(ell -> infinity) |a(p^ell)|^(1/ell) = p^(4t).

At t=0 the same radius statement is 1 and the desired numerical bounds
are automatic. The exact character script also verifies the entire local
decomposition, not just its dimension.

## 3. Verification of the inherited bound

At every unramified prime l, write alpha_l and beta_l for the semisimple
parameters of pi and Pi. Exterior-square compatibility and the identities
above give, for every k >= 1,

    tr(Sym^2(beta_l^k) omega_l(Frob_l)^(-k))
      = tr(End(beta_l^k)) - tr(End(alpha_l^k)) + 1.

For a unitary unramified representation, the dual Satake multiset is its
complex-conjugate multiset. The two endomorphism traces are thus
|tr(beta_l^k)|^2 and |tr(alpha_l^k)|^2, respectively. Since |omega_l|=1,

    |tr(Sym^2(beta_l^k))|
      <= |tr(beta_l^k)|^2 + |tr(alpha_l^k)|^2 + 1.

The three majorants are the logarithmic coefficients of
L(s,Pi x Pi^vee), L(s,pi x pi^vee), and zeta(s). Rankin-Selberg absolute
convergence gives a finite sum of these majorants weighted by l^(-k u)/k
for every real u>1. Exponentiating the absolutely convergent logarithmic
series proves absolute convergence of the symmetric-square Dirichlet series.
This argument does not assume automorphy of a symmetric-square transfer.

There are only finitely many remaining local factors. By local unitarity,
m(Pi,v)<1/2; Section 3 of Blomer-Brumley gives holomorphy of their
symmetric-square factors on Re(s)>2m(Pi,v). Their local Dirichlet expansions
therefore converge absolutely on Re(s)>1 as well. This also avoids relying
on exterior-square compatibility at either exceptional small prime for the
absolute-convergence argument.

All hypotheses of Blomer-Brumley Theorem 2 for the cuspidal GL6 representation
Pi are now met. Its symmetric square has degree m=6*7/2=21. Hence

    2t = m(Pi,p) <= 1/2 - 1/22 = 5/11,
    t <= 5/22.

This is the inherited comparison, stronger for the stated local family
than the general GL4 estimate 9/22. It is not an original bound. The
proposed improvement is exactly 5/22-19/84=1/924. A bounded external search
did not verify a stronger applicable consequence; that absence is not a
proof that 5/22 is the best published bound, and establishes no novelty.

## 4. What the quotient actually supplies

Choose a fixed finite set S containing the exceptional small primes and any
places to be omitted, but not the specified prime p. At every retained
place exterior-square compatibility holds. The identities of incomplete
Euler products, initially for Re(s)>1, are

    F_eta^S(s)
      := L^S(s,Pi x Pi^vee tensor eta)
         / L^S(s,pi x pi^vee tensor eta)
       = L^S(s,Pi,Sym^2 tensor omega^-1 eta) / L^S(s,eta).

Here eta is a unitary character. The identity follows from the equality
Lambda^2(W) tensor d^-1 = Ad(V), since
L^S(s,pi x pi^vee tensor eta)
= L^S(s,eta) L^S(s,Ad(pi) tensor eta).
It is not a claim that Ad(pi) or R20(pi) has an automorphic transfer.
Both sides are continued meromorphically using the Rankin-Selberg quotient.

At p, F_1^S has the local factor from Section 2. At the other retained
places its factors are also those of the genuine representation R20.
The logarithmic-coefficient bound

    |tr(R20(alpha_l^k))|
      <= |tr(beta_l^k)|^2 + |tr(alpha_l^k)|^2

gives absolute convergence on Re(s)>1, with the finitely many ramified
factors handled separately. In particular, if F_1^S(s)=sum a(n)n^-s,
then sum |a(n)| n^(-1-epsilon) is finite for every epsilon>0.

At an auxiliary unramified prime q, a nontrivial conductor-q twist eta
has local conductor contributions q^36 and q^16 to the two Rankin-Selberg
factors. Their quotient has the formal conductor contribution q^20.
This explains the candidate degree. It does NOT prove that the quotient
is holomorphic or that a degree-20 summation estimate follows.

Importantly, the second formula reduces the possible new denominator
singularities from a degree-16 Rankin-Selberg denominator to those of a
degree-one L-function. It does not remove them. A zero rho of L^S(s,eta)
is removable in the quotient only if the numerator vanishes there to
at least the same order. No such divisibility theorem has been established
here. Conversely, no uncanceled pole has been exhibited: failure to prove
cancellation is not proof of a pole.

There need not be a global square root of omega. Thus a general twist
Sym^2(Pi) tensor omega^-1 eta must not silently be identified with the
untwisted symmetric square of Pi twisted by a global character. The
Rankin-Selberg definition above needs no such square-root assumption.

## 5. The missing analytic estimate, with its exact residue term

Let g be a fixed nonnegative smooth function supported in [1/2,2], with
g(1)=1. Put X=p^ell. Sum over auxiliary primes q in [Q,2Q] outside S
and distinct from p, and define

    A(X,Q) = sum_q sum_(n^2 = X^2 mod q) a(n) g(n/X).

For n != X in the support, the congruence implies q divides
(n-X)(n+X). When Q=X^theta with fixed theta>0, the number of such
prime divisors in [Q,2Q] is bounded in terms of theta. Absolute
convergence from Section 4 therefore proves

    A(X,Q) = a(X) N(Q) + O_(pi,g,epsilon,theta)(X^(1+epsilon)),

where N(Q) is the number of eligible primes and N(Q) is asymptotic to
Q/log(Q). This diagonal extraction is justified without coefficient positivity.

The needed upper bound is

    |A(X,Q)| <<_(pi,p,g,epsilon) X^(1+epsilon) + Q^(21/2+epsilon).   (U20)

If (U20) held for Q=X^(2/21) and every sufficiently large ell, it would
give |a(p^ell)| << p^(ell*(19/21+epsilon)). Section 2 would then give
4t<=19/21, hence t<=19/84. An estimate on a merely selected subsequence
of coefficients would not be a replacement for this radius argument.

To see precisely what is missing, for a Dirichlet character chi modulo q
write

    D_chi(X) = sum_n a(n) chi(n)^2 g(n/X)
             = (1/(2*pi*i)) integral_(Re(s)=c)
                 H_(q,chi)(s) ghat(s) X^s ds,   c>1.

Here H_(q,chi)=F_(chi^2)^S for a nontrivial square character. For either
of the two characters with chi^2=1, the character extended by zero
removes the q-Euler factor, so
H_(q,chi)=F_1^S(s)/L_q(s,R20). This imprimitive correction is necessary
for the Mellin identity; it does not alter the amplifier definition.

Character orthogonality gives the exact identity

    A(X,Q) = sum_q (1/(q-1)) sum_(chi mod q) conjugate(chi(X)^2) D_chi(X).

A contour shift for each D_chi must include

    R(X,Q,T)
      = sum_q (1/(q-1)) sum_chi conjugate(chi(X)^2)
        sum_(rho crossed, |Im(rho)|<=T)
          Res_(s=rho) [ H_(q,chi)(s) ghat(s) X^s ].

This is a finite-height expression; taking T to infinity needs its own
justification. For chi^2 nontrivial, at a simple zero rho of L^S(s,chi^2),
when the numerator
N_chi(s)=L^S(s,Pi,Sym^2 tensor omega^-1 chi^2) is holomorphic there, the
potential residue is exactly

    N_chi(rho) ghat(rho) X^rho / (L^S)'(rho,chi^2).

For chi^2=1, include the q-depletion polynomial in the numerator.
For multiple zeros it is the full Laurent residue, with the corresponding
derivatives and powers of log(X). It cannot be replaced by the simple-zero
formula or dropped without justification. Poles of the numerator and finite
local corrections must also be included when present.

The usual symmetric-square argument does not control this additional sum.
Blomer-Brumley Section 3 and Lemma 1 restrict its possible nonholomorphic
square twists to a bounded number of exceptional characters per auxiliary
prime. For this counting conclusion it suffices to use the elementary
necessary condition chi^(2n)=omega_rho^(-2) for self-duality of rho tensor chi,
and Lemma 1 with exponent 2n; no sharper central-character identity is needed.
Zeros of the new degree-one denominators are not restricted by that
exceptional-character condition. Meromorphic functional equations, formal
degree 20, and absolute convergence to the right of 1 do not supply a bound
for N_chi(rho)/(L^S)'(rho,chi^2).

In particular, none of the following repairs is a proof of (U20):

* Ignoring the crossed residues because the quotient has the desired degree.
* Treating a zero-free region near 1 as a zero-free critical strip.
* Multiplying back by L(s,chi^2): this restores the degree-21 numerator,
  and with the presently justified method restores the inherited 5/22 bound.
* Using nonnegativity: a genuine representation has nonnegative weight
  multiplicities, not nonnegative values of every Frobenius character.

The unresolved obligation is a uniform control of this residue contribution
(including its limiting operation), together with the transformed
degree-20 sums, within the budget in (U20). A proved cancellation theorem
with the requisite growth and functional-equation estimates is one possible
way to address it; a sufficiently strong averaged residue estimate is
another. Neither is proved by this work.

The continuation `gl4_degree20_residues.md` supplies a contour-grouped
infinite-height interpretation and the transformed-integral estimate,
under its explicitly recorded standard analytic inputs. Its inherited
residue envelope at Q=X^(2/21) is only X^(232/231+epsilon), not the
required X^(1+epsilon). It also proves that the latter bound is equivalent
to the desired t<=19/84 in this framework. No improvement is claimed.

## 6. The global-family and publication limitations

The local representation in the question is a legitimate unitary generic
complementary-series representation for 0<t<1/2, and at t=0 it is a
legitimate tempered induced representation. This does not globalize it.
Existence of a positive-t cuspidal example must not be assumed.

The research worker read Asgari-Raghuram Theorem 1.1 and Proposition 3.2,
and their Example 6.1 together with Martin's "Modularity of hypertetrahedral
representations", DOI 10.1016/j.crma.2004.05.003, Theorem 1.1 and Example 1.
They provide genuine global examples with cuspidal exterior-square transfer,
but the passages read do not prescribe the local parameter r direct_sum r
at the chosen ramified prime.

Shin's "Automorphic Plancherel density theorem",
DOI 10.1007/s11856-012-0018-z, Theorem 5.13 and Corollary 5.14 in the author
manuscript, were also examined by the research worker. The positive-measure
existence statements and density assertions do not imply occurrence of the
single nondiscrete tempered representation Ind(sigma tensor sigma).
Allowing two independent unramified unitary twists changes the exact local
condition. No prescribed-local construction meeting both requirements has
been verified.

These construction papers are search findings, not ingredients in the
comparison proof, and are not represented as discharging a construction
claim. Originality, significance, and independent source/proof review
remain open. The campaign must continue; this is an incomplete bounded
mission, not a negative resolution of the conjecture or a publishable result.

## Replay

Run from the campaign root:

    python3 research/gl4_degree20_exact.py

The dedicated Jacobian files retain the inspected contract, the failed
36-by-16 request and structured validation error, and the corrected minor
request and typed result. To replay the corrected operation:

    /home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run --operation matrix.rank.compute --payload-file research/jacobian/gl4-inclusion-minor-input.json

These checks certify only the stated algebra. They do not check an
automorphic existence theorem, pole cancellation, (U20), or novelty.
