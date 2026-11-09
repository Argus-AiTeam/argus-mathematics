# Integral congruence-to-persistence verification

## Result and scope

For the October 5, 2026 construction, `top:chern-divisibility`,
`top:k-divisibility`, and `top:component-detection` follow with their stated
eventual-in-j quantifiers, arbitrary fiber coordinates, and integral
coefficients. The proof below gives sufficient thresholds uniform over all
vertices, simplices, and choices of short edge paths. No torsion-freeness of
cohomology or K-theory is used.

Compared with the manuscript's existential thresholds, the quantitative
contribution here is the explicit bound J_component(r,n) below. The
independently compiled cochain implication also works for every positive
modulus, and the nilpotent-ring argument works with arbitrary torsion.
These refinements are not asserted to be new results in the literature.

This is a verification of the topological branch, not a proof of maximal-index
vanishing, a refutation, or a claim of publication-level novelty. In particular,
October `ana:transfer`, `ana:endpoints`, and the maximal assembly naturality
argument remain unaudited dependencies of the main theorem. The September
disc construction is a different, reduced-assembly branch and is not proved by
this certificate.

## Uniform hypotheses and thresholds

Let S be the manuscript's finite symmetric generating set of SL(3,Z). Put

    A = max(2, max over s in S of the maximum absolute row sum of s),
    a = the least integer with A <= 2^a,
    Delta = |S| + 6,
    D_r = sum(Delta^i, i=0,...,r) - 1,
    L_r = floor(log_2 D_r).

Here r is any integer at least 3. A Rips simplex of Y_j lies in a radius-r
ball, so its dimension is at most D_r. This bound is independent of j.
For a word of length at most 2r, every entry has absolute value at most
A^(2r). Thus

    j >= a*r + 1

implies 2^(2j) > 2*A^(2r), which makes reduction modulo 2^(2j) injective
on the entire word ball of radius 2r. This is a norm bound, not an
enumeration of a finite collection of j's.

The following sufficient, deliberately nonminimal thresholds apply:

    J_chern(r) = max(2*r + 1, a*r + 1),
    J_K(r) = max(J_chern(r), L_r + 1),
    J_component(r,n) = max(J_chern(r), L_r + v_2(|n|) + 1),  n != 0.

For these choices l_j = 100(j+1) > 4r. The component threshold also gives
j > 2r and 2^j > D_r. Thresholds depend on r, S, and, for detection,
the fixed nonzero integer n, never on a vertex or simplex.

## 1. The lifted identity with a noncentral congruence kernel

Write m=2^j, U=I+mE12, V=I+mE23, and

    g(a,b) = V^b U^a,    C = I+m^2 E13.

These are integral matrices for arbitrary integer a,b, including negative
exponents. Matrix multiplication over Z gives, before reduction,

    g(a,b) g(a',b') = g(a+a',b+b') C^(a*b').

In the kernel N of Q_(3j) -> Q_(2j), an element has a unique expression
I+m^2 D modulo m^3 with D determined modulo m. Its product law is addition
of D, since m^4 is a multiple of m^3. Consequently

    d : N -> Z/m,   d(I+m^2 D) = D13 mod m

is an additive homomorphism, and d(C)=1. Every g(a,b) is I modulo m, and

    (I+m^2 D)(I+m T) - (I+m T)(I+m^2 D)
      = m^3 (D T - T D).

Thus N commutes with g modulo m^3. It need not commute with q or a Cayley
word. For example, n=I+m^2 E13 and q=I+E31 both come from SL(3,Z), and

    n q - q n = m^2(E11-E33).

This is nonzero modulo m^3 for every j>=1. This observation excludes a
central-kernel shortcut, not an assertion in the manuscript: the October
proof explicitly avoids that shortcut.

For every ordered Rips edge xy choose a graph path of length at most r.
Its Cayley word w_xy has length at most r, and its horizontal seam counts
are the unique small-lift seams a_xy,b_xy. Left Cayley actions commute with
right horizontal actions. In Q_(2j),

    q_y = w_xy q_x g(a_xy,b_xy).

On an ordered triangle, seam additivity and the commutation of U,V modulo
m^2 imply w_02 = w_12 w_01 in Q_(2j). The preceding uniform injectivity
bound upgrades this to an equality of integral matrices.

Choose arbitrary lifts qtilde_x to Q_(3j), and define n_xy on the right by

    qtilde_y = wtilde_xy qtilde_x gtilde_xy n_xy.

Substituting the 01 edge into the 12 edge, the only interchange needed is
n_01 gtilde_12 = gtilde_12 n_01. Associativity, the word identity, and
the product formula give

    qtilde_2
      = wtilde_02 qtilde_0 gtilde_02 C^(a_01*b_12) n_01 n_12.

Left cancellation against the direct 02 edge yields

    n_02 = C^(a_01*b_12) n_01 n_12.

No element has been commuted past qtilde_0 or a Cayley word.
The Lean declaration `lifted_triangle` formalizes exactly this group
cancellation with no centrality assumption on those objects.

## 2. Integral Chern divisibility, including torsion

The seams are integer 1-cocycles representing p_Y^*u_1 and p_Y^*u_2.
Set c_xy=d(n_xy). Applying d to the preceding identity gives

    c_02 = a_01*b_12 + c_01 + c_12    in Z/m.

For the convention delta c(012)=c_12-c_02+c_01, this says

    delta c = -a cup b.

Choose integer lifts chat on the ordered edges. There is therefore an
integer 2-cochain

    kappa = (a cup b + delta chat)/m.

The numerator is pointwise divisible by m. Both delta(a cup b)=0 and
delta^2 chat=0, so m delta kappa=0 as an integer 3-cochain. Integer
cochains are torsion-free; hence delta kappa=0. It follows that

    [a cup b] = m [kappa] in H^2(P_r(Y_j);Z).

This argument only uses torsion-freeness of the groups of integer
cochains, not of their cohomology. It is also the elementary cochain
proof of exactness at H^2 in the coefficient long exact sequence.
`integral_cocycle_divisible`, `integral_lift_is_closed`, and
`integral_lift_representation` encode the modular lift and this
distinction in Lean. Classification of complex line bundles by the first
Chern class, including its tensor-product group law, now supplies an
m-th root of p_Y^*L_j. This proves `top:chern-divisibility`.

## 3. Uniform integral K-divisibility

Let z=[L']-1 for an m-th root just obtained. A classifying map from the
finite complex P_r(Y_j), of dimension at most D_r, can be cellularly
approximated into CP^(D_r). The integral projective-space relation
(H-1)^(D_r+1)=0 pulls back to z^(D_r+1)=0. Thus

    [p_Y^*L_j]-1 = (1+z)^(2^j)-1
                 = sum(binomial(2^j,h) z^h, h=1,...,D_r).

For 1<=h<=D_r<2^j, the exact identity

    h * binomial(2^j,h) = 2^j * binomial(2^j-1,h-1)

implies v_2(binomial(2^j,h)) >= j-v_2(h) >= j-L_r.
Equivalently, one can use the stronger exact valuation
v_2(binomial(2^j,h))=j-v_2(h). The Lean proof uses the existing
prime-power binomial factorization theorem to derive the required
uniform divisibility; it does not infer a theorem from sampled j,h.

All coefficients have the integer factor 2^(j-L_r). Factoring it out
inside K^0 and multiplying by p_Y^*e_3 gives

    p_Y^*theta_j in 2^(j-L_r) K^1(P_r(Y_j)).

This is valid in arbitrary integral K-groups, including groups with
torsion. No rational Chern character, tensoring with Q, or cancellation
inside K-theory is involved. `dyadic_choose_divisible` and
`nilpotent_binomial_divisible` formalize the arithmetic and ring
implication. This proves `top:k-divisibility`.

## 4. Component detection

For j>2r use the manuscript's induced subcomplexes M+ on heights t>=-r
and M- on t<=r. A diameter-r simplex cannot contain heights below -r
and above r, so they cover P_r(X_j). Their intersection I is induced on
[-r,r]. A length-r path between vertices in I stays in [-2r,2r], hence
inside the product collar. Forgetting height therefore defines a
simplicial h:I->P_r(Y_j), and p_X restricted to I equals p_Y h.

Suppose the endpoint difference n(t+)_*tau_j-n(t-)_*tau_j vanished.
The finite-subcomplex Mayer--Vietoris exact sequence supplies eta in
K_1(I) whose image in K_1(M+) is n(t+)_*tau_j (and whose image in M-
has the matching sign prescribed by the sequence).
Pairing with the restriction of p_X^*theta_j and using
p_X t+=id and <theta_j,tau_j>=1 gives

    n = <h^* p_Y^*theta_j, eta>.

By Section 3, the integer on the right is a multiple of 2^(j-L_r).
For j>=J_component(r,n), j-L_r>v_2(|n|), an impossibility. This proves
`top:component-detection` for every fixed n!=0 and r>=3. It does not
assert the conclusion at small j, or allow n to vary after j is fixed.

The separated-union restriction and filtered-colimit argument in
`top:infinite-order` then prove infinite order of the topological class.
There is no inference about either reduced or maximal index vanishing.

## External inputs and what is checked

Hatcher, *Vector Bundles and K-Theory*, version 2.2 (November 2017),
Proposition 3.10 supplies line-bundle classification as a group
isomorphism for CW homotopy types. Proposition 2.24 supplies the integral
projective-space K-ring. Both statements were read in the author's
primary PDF and are extracted in `literature/hatcher-excerpts.txt`.
This also corrects the search service's inaccurate suggestion that
Proposition 2.24 is the line-bundle-classification proposition.
That search error is not an error in the staged manuscript.

Cellular approximation, the natural integer K-homology index pairing,
finite-subcomplex Mayer--Vietoris exactness, and the existence of the
pairing-one torus class are standard inputs, recorded explicitly in the
claim ledger. The manuscript cites Higson--Roe (2000) and Blackadar
(1998) for the latter K-homology facts. Their primary book texts were
not obtained here; no unexamined proposition locator is certified.
Independent source attribution and review of the topological
interpretation remain the Reviewer's responsibility.

`verify.py` checks universal polynomial identities over Z, the cochain
sign and cocycle identities, and the explicit threshold inequalities.
Any finite regressions it runs are labeled as such. `Main.lean`
provides a separate compiler-checked, parameter-uniform algebraic core;
`statement_fidelity.md` says precisely what it does and does not encode.
The Jacobian result is a supplementary fixed-modulus coefficientwise
check, not the proof of the all-j assertion. Neither the script nor Lean
constructs the analytic K-homology Mayer--Vietoris sequence.

The certificate replays with
`python3 research/certificates/congruence-persistence/verify.py` from the
campaign root, without a network or additional Python packages. It checks
the saved compiler result against the current source and statement reading;
it does not pretend that reading a saved result is a fresh compilation.
For independent compiler replay, run:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/certificates/congruence-persistence/Main.lean --statement-fidelity research/certificates/congruence-persistence/statement_fidelity.md --claim C_CP_ALG --project-root .
```
