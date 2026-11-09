# Specified classes, modification, and the actual cup map

This proves C318CO2ACTION and decides C318CO2 at p=5,n=3,t=1,m=2,
subject to independent review of the new argument and its cited inputs.
It uses the literal bounded-pole connected-marking algebra, not its
completion or perfection. The result is an independent verification of
the manuscript's proposition at these parameters, not a novelty claim.

Write K_a=GL_a(Z_5), P_a=O_(D_a)^times, G=K_2, and
J_3={g in GL_3(Q_5): v_5(det g)=0}. Fix the manuscript's rank-independent
K-theory coordinate f_2, its standard-representation classes kappa_a,
and its divided determinant class. In this note alpha_(a,i) ALWAYS
means the leading integral class selected by that construction.
The xi_i are the leading mod-five classes of the corresponding fixed
rank-three sphere representatives after actual modification transport.
No generator is rescaled or reselected below.

**Theorem.** Under the certified ordinary dual comparison, the transpose
action of xi_1 and xi_2 is cup product by the actual reductions of
alpha_(2,1) and alpha_(2,2). These two classes generate H^*(G,k).
The specified xi_3 acts by zero. Consequently the original unital map

    exterior_k(e_1,e_2) -> H^*_cts(P_3,B_conn,G),
    e_i |-> xi_i cup 1,       |e_1|=1, |e_2|=3,

is an isomorphism of graded k-algebras. Its basis is
1, xi_1 cup 1, xi_2 cup 1, (xi_1 cup xi_2) cup 1, in degrees 0,1,3,4.

## 1. Settled scope and known inputs

Round four, 2026-11-05T13:43:23Z, independently accepted
C318ORD_SUPPORT, C318CO2ORDINARY, C318SUPALG fidelity, and
SUP-CUP-DUALITY. Reuse that proof, the certified finiteness induction,
and the accepted cutoff/corestriction and actual-unit criteria.
The former route R318-CO2-CENTRAL-ALONE is already retired: a contraction
and dimensions alone neither identify the ordinary comparison nor its
specified classes. That failed shortcut is not reopened here.

The following inputs are recorded on C318ACTMOD and C318ACTGEN in
MATH_STATE.json. All source texts were obtained and the indicated
passages read. Independent attribution of these new uses is pending.
Relative bundle classification, the determinant-matched marking
component, and the continuous support/duality models are reused from
the accepted geometric and support inputs.

| Input | Exact external result used |
|---|---|
| ACT-MODIFICATION-DUALITY | Scholze--Weinstein, arxiv:1211.6357v2, Theorem 7.2.3: the basic EL duality preserves both actual period maps and both group actions. Basic-locus and determinant reductions are specified below, not attributed to an unstated theorem. |
| ACT-CDN | Colmez--Dospinescu--Niziol, arxiv:1905.11495v1, Theorems 1.1 and 5.1: integral AND finite-coefficient Drinfeld cohomology and arithmetic twists. |
| ACT-DLH | Dotto--Le Hung, arxiv:2507.13500v1, Theorem 1.1, Propositions 5.5, 5.7, 5.12: the actual compact/Iwahori constant-cohomology input; 5>a+1 for a=2,3. |
| ACT-K-CONTINUITY | Geisser--Hesselholt, doi:10.1090/S0002-9947-04-03599-8, Theorem C: finite-coefficient pro-continuity for Z_5. |
| ACT-K-TC | Hesselholt--Madsen, doi:10.1016/0040-9383(96)00003-1, Theorem D and Addendum 5.2: local K-theory is the connective TC cover. |
| ACT-TC-COORDINATE | Blumberg--Mandell, arxiv:2012.07951v2, Section 2: the twist-two Sigma^3 ell summand, pi_3=Z_5 and pi_2=0. |
| ACT-ETALE-EDGE | Hesselholt--Madsen, doi:10.4007/annals.2003.158.1, Theorem A, (6.1.9), Theorem 6.1.10: the canonical odd etale edge for Q_5. |
| ACT-CHERN | Weibel, doi:10.1007/978-94-017-0695-7_14, Lemma 2.3, Propositions 2.8, 4.4, 5.2: actual Chern reduction, coefficients, transfer and surjectivity. |
| ACT-FL | Fontaine--Laffaille, doi:10.24033/asens.1437, Theorem 6.1, Section 7.14, Proposition 7.15(i), Theorem 8.4(ii), Lemma 5.4: exact integral realization and finite full faithfulness in weights [0,2]. |
| ACT-TATE-PERIOD | Fontaine, doi:10.2307/2007012, Proposition 2.17, pp.543--544, and Section 4.11: the primitive period and its residue valuation. |
| ACT-BOREL | Huber--Kings, doi:10.1017/S1474748010000216, Definition 0.4.5, Remark 0.4.6, Theorem 1.3.2 and Section 2.2--2.3: the SAME transgressed-Chern primitive, regulator and exponential. |
| ACT-CYCLOTOMIC | Besser--de Jeu, doi:10.1016/j.ansens.2003.01.003, Theorems 1.10, 1.12, Remark 1.13, Definition 4.6: a discrete cyclotomic K_3 class and its syntomic value, without a conjectural weight assumption. |
| ACT-COLEMAN | Besser--de Jeu, doi:10.1090/S0025-5718-07-02027-3, Propositions 4.2, 4.8, Corollary 4.9: the bounded measure for the five-depleted dilogarithm. |
| ACT-CHARACTER | Tamme, arxiv:1111.4109v1, remark after Definition 4.23 and Section 5.9: degree-two character is minus c_2 on positive K-theory Hurewicz images. |
| ACT-VOLUME | Huber--Soergel, arxiv:1011.5081v1, Proposition 1.3 and Section 3: product of the specified transgressed primitives and raw entry volume. |
| ACT-INTEGRAL-LAZARD | Huber--Kings--Naumann, arxiv:0904.3863v3, Theorem 3.3.3, Proposition 4.2.4, Remark 4.2.5: the integral uniform-group comparison is the same rational differentiation map. |

## 2. The actual modification transport at rank three

The determinant-matched modification stack has presentations

    M_3 = [P^2_C/P_3] = [Omega^2_C/J_3].

Here Omega is the complement of the rational Q_5-hyperplanes.
For completeness, a length-one lower modification of a slope-1/3
stable bundle has degree zero and no positive-slope subbundle:
a proper rank-r subbundle would have positive integral degree
strictly below r/3<1. Its kernel is therefore slope zero.
Conversely an upper modification of the trivial rank-three bundle
has nonnegative slopes and total degree one. Its positive part is
a single stable degree-one summand; absence of a slope-zero quotient
is precisely the rational-hyperplane condition. Relative classification
and the slope-zero local-system equivalence make these constructions
inverse on v-local families, not just on geometric points.
This is the basic EL duality of Scholze--Weinstein Theorem 7.2.3,
with the determinant reduction specified by the already certified
marking component: frame changes on one side are J_3, on the other P_3.

Take the unramified field of definition of all Honda endomorphisms.
Arithmetic commutes with the two constant groups and preserves the
determinant lattice. Choose gamma with mod-five cyclotomic value 2;
the cyclotomic extension is totally ramified, so the unramified
enlargement does not prevent this choice.

Use the constant-section maps on the actual action nerves, denoted eta.
They commute with coefficient maps, torsor base change, and cup
products term by term. The accepted continuous parameter/bar model
computes the descent spectral sequences. The projective rows have
arithmetic scalars 2^(-j), j=0,1,2. ACT-CDN gives exactly these scalars
on the Drinfeld rows, with their actual topological Steinberg duals;
it is not a reduction of a rational pro-etale formula.
Thus the scalars are 1,3,4 in F_5.

The building restriction H^*(J_3,F_5)->H^*(K_3,F_5) is an isomorphism
by the following bounded calculation. Each chamber face stabilizer
lies between an Iwahori and a maximal compact. Its index over the
Iwahori is a flag count prime to five. Transfer makes restriction
injective; ACT-DLH makes the maximal-compact composite an isomorphism.
All face restrictions are consequently isomorphisms. Identifying them
by ACTUAL restriction, the finite chamber has the constant cochain
complex of a simplex. Its edge is the original vertex restriction.
This proves the assertion, including its map, not just its dimension.

Both descent filtrations are bounded. Coprimality of (T-1)^N and
(T-3)^N(T-4)^N separates the generalized-one summand, even with
nilpotent extensions. The unit identifies each geometric degree-zero
row with constant continuous cochains. All other rows disappear from
that summand. Hence actual pullbacks induce multiplicative isomorphisms

    H^*(P_3,F_5) -> H^*(M_3,F_5)_(1) <- H^*(J_3,F_5)
                   -> H^*(K_3,F_5).

Only mod-five cohomology is needed here. Constant-section naturality
also shows that reduction of the specified transported sphere classes
is this exact pair of pullbacks: taking the finite coefficient
Hurewicz map does not replace a class. Extension to k takes place
afterward; gamma is not made to act on the scalar ring R.

## 3. Why the independent-locus action is block restriction

Fix the connected quotient at t=1, its length-one quotient at infinity,
and a rational frame of its slope-zero kernel W_1. On [Z/G] the actual
extension becomes, after that modification,

    0 -> W_3 -> V_3' -> i_* L -> 0,
    0 -> L_2 tensor O -> W_3 -> W_1 -> 0.

The second row is slope zero. Its local-system sequence has the
ACTUAL integral Tate lattice L_2 in its kernel and the fixed rational
quotient Q_5. Its rational splittings have frame-change group

    H = { [g v; 0 1] : g in K_2, v in Q_5^2 }  subset J_3.

Its projection pi:H->K_2 has the displayed block-diagonal section s.
The H-torsor induces the J_3 frame torsor of the modified bundle;
its K_2 quotient is precisely the torsor defining q:[Z/G]->BG.
This is a factorization of the original torsors.

There is an actual inflation equivalence H^*(K_2,k)->H^*(H,k).
Here is the required continuous calculation. Exhaust Q_5^2 by
5^(-r)Z_5^2. Restrictions in positive compact-lattice cohomology
are zero over F_5, since degree-one restriction multiplies by five
and the algebra is exterior. In degree zero they are identity.
Restriction of continuous cochain terms is surjective by extension
from an open-and-closed subset. The countable inverse-limit sequence
is therefore exact with no lim^1 term in cohomology.
This proves H^j_cts(Q_5^2,F_5)=0 for j>0.

The same calculation works with every extra compact profinite
parameter T: refine a finite clopen partition of T and the compact
lattice source simultaneously. Filtered colimits of the finite
products of cochain complexes are exact; termwise restrictions
are again surjective. Taking T=K_2^b in the external double bar
proves the asserted inflation equivalence, compatible with the
outer faces. It is not an assertion about discrete Q_5^2.
Restriction along s is its inverse. Thus for EVERY c_J,

    res_H(c_J) = inf_(K_2)^H res_(K_2)^(K_3)(res_(K_3)^(J_3)c_J).

Indeed apply restriction along s to both sides, then use its
injectivity. This is the split-inflation factorization formalized
in action/Main.lean.

If c_P corresponds to c_K under Section 2, pull their equality on
M_3 along the actual modified-extension map [Z/G]->M_3.
Torsor naturality and the displayed H-factorization give

    b^* c_P = q^* res_(K_2)^(K_3)c_K.

This equality identifies original pullback classes, hence their cup
maps on supported coefficients. It does NOT extend b to dependent
tuples. Only after identifying this BG-class do we use the certified
G-equivariant ambient support map, which is BG-linear.

The connected-corestriction bridge is natural for these degree-shifted
maps after forgetting the connected action. Hence the equality descends
to the certified ordinary dual comparison with its graded transpose.
No equivariant splitting is needed.

All new scalar cochains are locally constant. On each compact support,
each finite piece of the nerve and each fixed comparison homotopy,
the finitely many rational transition functions are bounded in one
Q_5 lattice and have a common clopen refinement. After restricting
the resulting continuous primitive to that compact parameter source,
it too has a finite partition. Enlarging cutoffs as in the certified
support proof gives one common finite frame/root stage and pole bound.
There is no uniform cutoff on the whole noncompact rational group.
Frame pullback and trace are the already certified ones; the unit and
the single volume line have not changed.

## 4. The selected rank-two primitives, not another exterior basis

The rank-independent maps f_2 and kappa_a give, on actual leading classes,

    res_(K_2)^(K_3) alpha_(3,2) = alpha_(2,2).

The reduced standard representation restricts to the reduced rank-two
representation, since the extra trivial line cancels its rank.
ACT-K-CONTINUITY makes this identity true on finite continuous
Postnikov components before limits. The determinant divided logarithm
likewise restricts to alpha_(2,1). It remains to prove that these
particular two classes, not merely some classes of these degrees,
have unit top product.

### 4.1 The actual f_2 coordinate

Put X=K(Z_5)^hat_5, g=(f_2)_*:pi_3 X -> Z_5.
ACT-K-TC and ACT-TC-COORDINATE make g an integral isomorphism
and pi_2 X=0. Localization at Q_5 and ACT-ETALE-EDGE give

    pi_3 X / 5^r = K_3(Q_5;Z/5^r)
                 = H^1(Q_5,mu_(5^r)^tensor2).

The actual universal Chern map c_2 is an isomorphism integrally.
To check its normalization, over Q_5(zeta_5) its mod-five map is
onto by Weibel Proposition 5.2, since (2-1)!=1. Proposition 4.4
identifies transfer because 2 is invertible modulo five.
Restriction/corestriction multiplies by [Q_5(zeta_5):Q_5]=4,
also invertible. It follows that the mod-five Chern map over Q_5
is onto. Both its source and target are one-dimensional; the
integral groups are free of rank one. Lemma 2.3 and Proposition 2.8
identify this map with reduction of the actual integral Chern map.
Nakayama proves that c_2^S:pi_3 X -> H^1(Q_5,Z_5(2)) is an isomorphism.
No arbitrary rational regulator coordinate is inserted.

### 4.2 The weight-two exponential lattice

Use the standard basis e_2=t_cyc^(-2) tensor e_cyc^tensor2,
with phi(e_2)=5^(-2)e_2. This basis is integral for the
Fontaine--Laffaille lattice: the period-ring ideal formula gives
t_cyc^2 in S^2, whereas

    v_5 theta((t_cyc^2/5)/xi^2) = 2/4-1 = -1/2 < 0

excludes t_cyc^2/5. Exact rank preservation and rational comparison
therefore identify the rank-one realization with Z_5 t_cyc^2,
not with an unknown multiple. Weight zero uses the primitive unit 1.

An integral extension in these covariant conventions has

    Fil^0 = Z_5(e_0+x e_2),   phi(e_0)=e_0+y e_2,
    x in Z_5,                z:=y+x/25 in Z_5.

These are exactly strong divisibility: phi(Fil^0) is integral,
25 phi(e_2)=e_2, and the two divided images generate.
Its exponential parameter is

    x - y/(1-1/25) = (25/24)(x-z).

A change e_0 -> e_0+b e_2 subtracts b from both x and z.
Taking x=1,z=0 gives a primitive integral extension. To see
primitivity, in the dual positive-weight interval [0,2] its
filtered generator is f_2-f_0 and divided Frobenius sends it to f_2.
A section of the weight-two quotient modulo five would have to
send its generator to f_2-f_0, but Frobenius compatibility would
require its image to be f_2. They differ by the nonzero f_0.
Finite full faithfulness in ACT-FL therefore excludes a Galois
splitting modulo five.

Thus this integral class is not divisible by five. Since the
integral H^1 is free of rank one, it generates that group. Its
parameter is 25/24. Consequently, in the STANDARD period basis,

    exp_BK^(-1) H^1(Q_5,Z_5(2)) = 25 Z_5.

The elementary parameter, change-of-lift, and nonsplitting algebra
is part of the new Lean source. Realization and full faithfulness
are explicitly imported theorems, not claimed formalizations.

### 4.3 A detected evaluation fixes the rational scalar

Let b_2 be the SAME transgressed-Chern primitive as in ACT-BOREL.
Additivity of kappa and the fixed spectrum map f_2 imply that the
stable rational family alpha_(a,2) is primitive under block sum.
Its degree-three primitive space is one-dimensional, so it is
lambda_2 b_2, with a rank-independent scalar lambda_2.

A nonzero discrete evaluation is needed to determine that scalar;
density of discrete K-theory is not assumed. Choose the Teichmuller
fourth root zeta in Z_5 with reduction 2, and embed Q(i) by i->zeta.
The cyclotomic symbol [i]_2 gives a rational discrete K_3 class by
ACT-CYCLOTOMIC. Its regulator is nonzero. Indeed ACT-COLEMAN gives

    (1-5^(-2)) Li_2(zeta) = integral_(Z_5^times) x^(-2) dmu_zeta,
    mu_zeta(a+5^r Z_5) = zeta^a/(1-zeta^(5^r)).

Modulo five this integral is evaluated already at level one.
The numerator polynomial is

    P_2(X)=X+4X^2+4X^3+X^4,       P_2(2)=1 in F_5.

Its denominator reduces to 1-2=-1, a unit. Thus Li_2(zeta)
is nonzero (in fact it has valuation two). ACT-CHARACTER and the
Chern-preserving syntomic comparison of ACT-BOREL identify this
nonzero character value with a nonzero etale c_2 regulator.
The number-field construction has no unproved weight hypothesis.

Put t_2=exp_BK^(-1)c_2^S(g^(-1)(1)); Section 4.2 gives
t_2 in 25 Z_5^times. Evaluation on the detected discrete class x
satisfies

    <alpha_2,hur(x)> = g(x_hat),
    <b_2,hur(x)> = exp_BK^(-1)r_5(x) = t_2 g(x_hat).

The bottom Postnikov class of f_2 evaluates as its actual pi_3
coordinate g; the second equality is ACT-BOREL with the Chern
normalization just checked. Both evaluations are nonzero.
Therefore lambda_2=t_2^(-1), and

    alpha_(2,2) tensor Q_5 = epsilon_2 5^(-2)b_2,
                          epsilon_2 in Z_5^times.

For the specified divided determinant logarithm similarly
alpha_(2,1) tensor Q_5 = epsilon_1 5^(-1)b_1 with epsilon_1 a unit.
The epsilons describe the ORIGINAL choices; we do not replace them
by one or rescale either alpha.

### 4.4 Their top product is an integral unit

For U_r=1+5^r M_2(Z_5), ACT-INTEGRAL-LAZARD applies with trivial
coefficient Z_5: U_r is uniform and the action lies in 1+5 End(Z_5).
Its actual logarithm Lie algebra is 5^r M_2(Z_5). The integral
top Chevalley--Eilenberg differential is zero because every
adjoint trace is zero. Its top lattice is consequently

    H^4(U_r,Z_5) = Z_5 5^(-4r) omega_2

under the SAME rational differentiation map. No factor 4! or 9!
is silently included. The full K_2 has trivial adjoint determinant.
Oriented duality identifies top restriction with the index on
integral orientation lines (first at each finite coefficient level,
then by inverse limit). The index has valuation

    v_5[K_2:U_r] = 4(r-1)+v_5|GL_2(F_5)| = 4r-3.

Hence its top integral lattice is Z_5 5^(-3)omega_2.
ACT-VOLUME gives b_1 b_2=+/-omega_2. With the ordered entry basis
E_11,E_12,E_21,E_22 the explicit HK formula is
b_1(X)=Tr(X), b_2(X,Y,Z)=Tr(X[Y,Z])/2, and the product is -omega_2.
Thus the selected alpha_(2,1)alpha_(2,2) is a UNIT of that top lattice.

Integral torsionfreeness follows from the mod-five dimensions in
ACT-DLH and the identical rational Lie dimensions by the coefficient
sequence: dim H^q(F_5)=rank H^q(Z_5)+t_q+t_(q+1) forces all torsion
counts to vanish. Reducing the selected product is therefore nonzero
in H^4(K_2,F_5). The perfect exterior top pairing makes the map
from the exterior algebra on THESE classes injective: any nonzero
homogeneous kernel element could be multiplied to a nonzero top
kernel element. ACT-DLH gives equal dimensions, so it is an
isomorphism. Finite coefficient extension gives the same assertion
over the admissible k.

Finally alpha_(3,3) restricts into H^5(K_2,Z_5)=0, since cd_5 K_2=4.
This proves zero restriction of the SPECIFIED class without
dividing the degree-five trace formula by 5! in characteristic five.
Its sphere representative need not be nullhomotopic; only the
ordinary class and its ordinary action are asserted zero.

## 5. Applying the certified actual-unit criterion

For c_P=xi_i, Section 2 uses exactly c_K=bar(alpha_(3,i)).
Section 3 identifies its action with the original upper-left
restriction, and Section 4 identifies that restriction as
bar(alpha_(2,i)) for i=1,2 and zero for i=3.
The certified support and connected-corestriction maps therefore give

    Hom_k(H^j(P_3,B_conn,G),k) tensor R
        = H^(4-j)(G,k) tensor R

as modules for THESE xi_i, with the previously certified graded
transpose signs and the single retained volume line.
The right side is the reindexed regular exterior module just proved.
This establishes C318CO2ACTION.

Apply the accepted actual-unit criterion, not a new cyclic-vector
choice. The actual degree-zero unit is nonzero and is a basis of
the one-dimensional k-line H^0. After faithful almost scalar
extension its image is an invertible, not merely nonzero, multiple
of a degree-zero regular-module basis. The original cup map based
at 1 is thus an isomorphism after extension; faithfulness kills
its kernel and cokernel over k. The zero xi_3 action descends as well.
Odd squares are zero since 2 is invertible, giving the asserted
graded algebra, not only a vector-space presentation.

## 6. Exact and formal evidence

`action/Main.lean` verifies the universal split-inflation factorization,
the transported equality of specified pullbacks, a Bezout projector
including generalized (not necessarily semisimple) factors, and the
weight-two lattice parameter and mod-five nonsplitting algebra.
Its fidelity note explicitly separates these from imported geometry,
local K-theory, filtered realization, and continuous cohomology.

The new-only verifier checks the actual rational transgressed-Chern
forms on gl_2 and their upper-left restrictions from gl_3, the integral
unimodularity calculation, the selected normalizations' index exponents,
the cyclotomic finite reduction, and generalized arithmetic projectors.
These are exact algebraic diagnostics, not finite approximations to
P_3-cohomology. The inspected Jacobian operation checks the source-bound
four-coordinate top-pairing matrix. No unchanged accepted proof or
compiler source is rerun.

    PYTHONDONTWRITEBYTECODE=1 python3 research/coheight-two-unit/verify.py --action-only

No manuscript assertion has been refuted in this argument. The theorem
is engineer-supported, with independent proof, source-applicability,
and formal-fidelity review required before campaign certification.
