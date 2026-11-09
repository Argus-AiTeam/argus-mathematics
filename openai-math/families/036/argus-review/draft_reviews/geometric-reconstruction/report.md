# Geometric reconstruction: bounded assessment of the old draft

## Scope, conclusion, and provenance

**Scoped verdict: supported_in_stated_scope.** The seven decisive implications
in the old reconstruction have mathematical justifications on the stated
hypotheses. No concrete unresolved proof gap was identified in this bounded
assessment. This is an ordinary mathematical assessment of an existing
argument, not a counterexample search, a machine formalization of geometry,
or native independent Reviewer acceptance. Native Host review remains pending.

The primary draft is the old `research/frobenius_core/REPORT.md`, specifically
lines 15-41, 138-184, and 186-543. The assigned claims are
`C9000036-FINITE-DATA` v7, `C9000036-REDUCTION` v4,
`C9000036-JETS` v1, `C9000036-FILTRATION` v1,
`C9000036-SLOPE` v2, `C9000036-RANK` v1,
`C9000036-DET` v1, and `C9000036-ORDER` v1.
`OBJECTIVE.md`, `PRIOR_DRAFTS.json`, and the already-written
`research/DRAFT_REVIEW_INDEX.json` determine the present review scope.

The original comparison source is

    campaigns/9000036/research/openai_manuscript/
      Numerical-Semiampleness-of-Nef-Adjoint-Divisors-October-3-2026/
      build/sections/frobenius.tex

under `$WORKSPACE/counterexample-batch-1/`. Its staging symlink
currently resolves to the corresponding file under
`openai-math/preprints/`.
The manifest `campaigns/9100036/MANUSCRIPTS.json` pins revision
`4eaee87548250b2682affda7d05d947c05554bae`. A read-only `sha256sum` check of
this one source returned

    9503296abdcd780a5e6a778d961e9e1f7c9391290b4d68b1f1c9bb9139083f2a

which exactly matches its existing manifest entry. No Git operation,
restaging, source edit, or old checker invocation was performed.

### Historical evidence is stronger than the stale status prose

The complete old ledger has 34 versions of 21 claim IDs, not 34 mathematical
results. Its later evidence includes eight supporting judgement records by
`reviewer:41e8b874f58e` for the eight assigned claims. These are visible in
old `MATH_STATE.json` lines 941-1035 and match the current claim statements.
There are also five supporting independent literature-attribution records,
lines 869-927, for **four** distinct propositions: Langer has two recorded
uses. The corresponding literature files were read.

These historical supporting readings must not be erased by the report's
earlier "review has not occurred" wording or the graph's open,
`reviewer_confirmed=false` flags. Conversely, they are not current native
Host acceptance, and this assessment does not impersonate their author or
file new citation evidence under a Reviewer identity.

The retired FINITE-DATA and AUDIT-FROB routes are provenance replacements,
not mathematical disproofs. BOUNDED-ONLY is genuinely inadequate as a proof
strategy: finitely many matrices cannot establish the vector-bundle
identifications, uniform curve estimates, or unbounded good reductions.

## Exact geometric claim

There is no dataset satisfying all of the following conditions, with all
specified data fixed before varying the residual characteristic.

1. `W` is smooth, connected, projective over the complex numbers, and has
   dimension `n >= 2`. `D,H` are rational Cartier divisors, `H` is ample,
   `S` is an integral Cartier divisor, `q` is a positive integer, and
   `r > 1`, `epsilon > 0` are real numbers. With `h=H^n`, the five
   numerical inequalities are

       h <= (2 epsilon)^n,
       K_W.H^(n-1) <= 2h/r,
       (2D+qS).H^(n-1) <= 4h,
       (14 epsilon)^n < 1/4,
       80 epsilon < 3/4.

2. There is a fixed smooth integral complete-intersection flag
   `W=W_n > W_(n-1) > ... > W_1=C`. At step `i`, the divisor cutting the
   next member has class `h_i=l_i H` restricted from `W`, where
   `l_i` is a fixed positive integer making `l_i H` Cartier. The
   restriction of the ambient cotangent bundle satisfies

       mu_min(Omega_W^1 restricted to C) >= 0.

3. Over `W x W`, let

       Z=P(O_W(S)_1 direct-sum O_W(S)_2),
       xi=c_1(O_Z(1)),       M=D_1+D_2+q xi.

   The projective-bundle convention is that the direct image of
   `O_Z(a xi)` is the `a`-th symmetric power of the displayed sum for
   every integer `a >= 0`. The two axes are the sections associated to
   the two summands. There is one fixed point `z_*` outside both axes
   and a finite system of sections of `k_0 M`, with `k_0` a positive
   integer and `k_0 D` Cartier, surjecting onto ordinary jets through
   order `(2n+2)k_0` at `z_*`. "Through order a" means reduction modulo
   the `(a+1)`-st power of the maximal ideal.

4. Independently of the two base coordinates of `z_*`, there is a fixed
   point `x` of `W`, its blowup `pi:W_hat -> W` with exceptional divisor
   `J`, and the fixed curve class

       gamma=f_*(A_1 ... A_(n-1)).

   Here `f:V -> W_hat` is a birational morphism, `V` is smooth integral
   projective, and each `A_i` is ample integral Cartier. With
   `j_gamma=J.gamma > 0`, the endpoint inequalities are

       pi^*(D+K_W/2).gamma <= 40 epsilon j_gamma,
       pi^*(D+K_W/2+qS).gamma <= 40 epsilon j_gamma.

   By affinity these are equivalent to the same inequality for every
   real `lambda` in `[0,q]`.

There is no additional nefness of `D`, `S`, or `K_W`, no
pseudo-effectivity assumption on `K_W`, no strong semistability
assumption, and no requirement that the jet coordinates equal `x`.
The flag and movable witness themselves are hypotheses, not objects
inferred from the surrounding abundance programs.

## Primary propositions and their applications

The following are precise paraphrases of source statements, not quotations
of the authors' applications. Both local Stacks excerpts and the public
primary statements were read. The PDF passages were additionally extracted
to stdout with `pdftotext`, without producing or altering reference files.

| Primary proposition | Actual source hypotheses and conclusion | Application checked here |
|---|---|---|
| Stacks 01ZM, Lemma 32.10.1 (1)-(3) | Directed inverse system of quasi-compact, quasi-separated schemes, affine transition morphisms, and its limit. Finitely presented schemes descend; morphisms between models descend at a later index; equal base-changed morphisms become equal at a later index. | Spectra of finitely generated subalgebras of the complex numbers form this system. A finite list has a common descent index. Smoothness and ampleness require the separate arguments below. |
| Stacks 0559, Lemma 37.27.5 | A finite-type morphism to an irreducible base whose generic fibre is geometrically irreducible has geometrically irreducible fibres on a nonempty open. | The spread base is integral and the complex input gives geometric irreducibility of the generic fibres. Relative smoothness supplies geometric reducedness separately. |
| Nitsure, arXiv:math/0504590v1, Theorem 5.1 (Grothendieck), Section 5, printed p.24 | Noetherian base, projective morphism, relatively very ample line bundle, coherent source sheaf, and a fixed rational Hilbert polynomial. The fixed-polynomial Quot functor is represented by a projective scheme over the base. | The curve family and restricted cotangent bundle meet these conditions. Finitely many possible negative quotient ranks and degrees give finitely many proper Quot loci, not an infinite union. |
| Langer, DOI 10.4007/annals.2004.159.251, Corollary 2.5, p.258; Section 2 setup pp.256-257 | Smooth projective variety over an algebraically closed field of characteristic `p>0`, fixed nef slope polarizations, torsion-free sheaf of rank `rho`, and a nef divisor `A` with `T_X(A)` globally generated. With `alpha=max(L_max-mu_max,mu_min-L_min)`, the bound is `alpha <= (rho-1) A.D_1...D_(n-1)/(p-1)`. | On a curve the polarization product is empty and the intersection is `deg A`. Taking the ambient restricted cotangent bundle of rank `n` gives the required lower asymptotic slope. No tensor semistability follows from or is attributed to this statement. |

For Nitsure, the general Quot definition on printed pp.3-4 was also read:
the target quotient is coherent, has proper support, and is flat over the
parameter scheme. Over a geometric field point flatness is automatic.
The explanation of Theorem 5.1 following the main construction, printed
pp.27-28, confirms projectivity through the closed Grassmannian locus.

The auxiliary degree choice for Langer, the tensor-quotient argument, and
the use of proper Quot images are applications proved below, not additional
sentences quoted from those sources. Sun, Kitadai-Sumihiro, and
Mustata-Schwede are not assumed here: the relevant local identities and
jet comparison are reconstructed. The original attribution to the companion
*Log abundance in characteristic zero*, Theorem 9.1, is recorded as
attribution, not independently verified or used as a proof input.

## Seven-section support table

| Section and old locator | Claim/version | Decisive implication and concrete support | Assessment |
|---|---|---|---|
| 1, REPORT 186-246 | REDUCTION v4 | Finite descent and open conditions; negative quotients have finitely many Hilbert polynomials with proper images; Noether normalization of the already localized algebra supplies arbitrarily large good characteristics. | Supported; no strong semistability or effective-cone specialization is assumed. |
| 2, REPORT 247-303 | JETS v1 | Products give a triangular monomial jet system; fixed fillers are local units; the degree threshold covers Frobenius jets; an `A_*`-linear coordinate projection selects exactly `p`-divisible weights even when `A_*` is nonreduced. | Supported; generic full rank is obtained at the jet coordinates, not presumed at `x`. |
| 3, REPORT 304-363 | FILTRATION v1 | Etale-local parameter differences identify the global truncated associated graded; complementary monomials give a GL-equivariant perfect pairing; its rational Chern sum yields the normalized Frobenius class. | Supported, including characteristic 2. |
| 4, REPORT 364-412 | SLOPE v2 | Langer's actual curve hypothesis is met with uniformly bounded `deg A`; generated Frobenius twists bound every tensor quotient; the socle duality gives one common maximal-slope bound. | Supported without tensor-product semistability. |
| 5, REPORT 413-477 | RANK v1 | Cartier restriction filtrations and curve evaluation inject sections into finite arrays; each piece is bounded by its rank times the same polynomial, and the sum of ranks is `p^n`. | Supported; no number-of-pieces factor is introduced. |
| 6, REPORT 478-507 | DET v1 | Any selection of weight-labelled independent source columns gives the stated external-product factors; average weights are in `[0,q]`; the finite remainder list controls every selected column set and every reduced-fibre section. | Supported with the correct source-dual sign and normalization by `R=s^2`. |
| 7, REPORT 508-543 | ORDER v1 | Adapted order filtrations prevent leading-term cancellation in disjoint parameter sets; residue-field row operations put the same determinant in the required maximal-ideal power at `(x',x')`. | Supported; both orders concern the same nonzero section and the independently fixed point. |

`C9000036-FINITE-DATA` v7 is supported by the conjunction of these seven
checked implications, not by counting them as seven separate proofs of the
aggregate theorem.

## 1. Good reductions, finite Quot loci, and unbounded characteristics

Choose `T_0` sufficiently ample that `T_0+aS` is globally generated for
every integer `0 <= a <= (k_0-1)q`. Fix the needed nonvanishing sections
over the complex numbers. This uses only a finite list of line bundles.
It does not require positivity of `S`.

Finite-presentation descent applies to the varieties, morphisms, points,
sections, and their compatibility equalities. Line-bundle transition data
and the finitely many section expressions also descend. Smooth connected
complex `W` is integral: distinct irreducible components of a smooth scheme
cannot meet, so connectedness rules out multiple components.

Projectivity and the finitely many ample bundles can be retained by spreading
fixed embeddings supplied by sufficiently high powers. Once proper models
have been chosen, the image of the relative nonsmooth locus is closed and
misses the generic point. Removing it makes the families smooth. Stacks 0559
then gives geometric irreducibility; together these give geometric
integrality. Birationality follows from the descended dense-open
isomorphisms after ensuring those opens meet each fibre. The point section
in the smooth family gives its relative blowup, with the usual exceptional
divisor; the regular-immersion description ensures the relevant base changes.
The prescribed ordinary jet algebra is finite locally free along the
smooth point section. A finite matrix of the given sections is surjective
on an open after spreading, and their finitely many nonvanishings persist.
There is no need to assume that every global section space commutes with
base change.

For the slope condition, put `V=Omega_W^1 restricted to C`, of rank `n`.
Choose a positive-degree relative line `L`, with fixed degree `d`, such that
`V tensor L` is relatively generated. A rank-`b` coherent quotient `Q` then
has

    deg Q >= -bd.

Indeed, its twist is generated; after removing torsion its determinant has
nonnegative degree, and torsion contributes nonnegative length. Rank-zero
quotients are torsion and cannot have negative degree. Thus every negative
quotient has one of the finite pairs

    1 <= b <= n,       -bd <= e <= -1.

With a relatively very ample line of degree `d_emb` and the fixed genus
`g`, these pairs determine Hilbert polynomials
`b d_emb m + e + b(1-g)`. Nitsure supplies a projective Quot scheme for
each polynomial. Its image in the base is closed. Its geometric generic
fibre is empty: a negative-degree coherent quotient would give, after
removing torsion, a negative-degree bundle quotient, contradicting the
complex minimum-slope hypothesis after field extension. Removing the
finitely many images preserves that hypothesis in every remaining
geometric fibre. Neither an infinite union of closed sets nor strong
semistability is being used.

Crucially, perform the following argument on the **already localized**
good-model algebra `R`. It is still an integral finitely generated
characteristic-zero algebra over the integers. Noether normalization of
`R tensor Q`, followed by clearing finitely many integer denominators,
gives a nonzero integer `N` such that

    R[1/N] is finite integral over Z[1/N][t_1,...,t_d].

Lying-over at `(p,t_1,...,t_d)` gives a closed point with residue field
finite over `GF(p)` for every prime not dividing `N`. Thus a nonempty
good spread cannot leave only bounded characteristics. The displayed
argument supplies good reductions in all but finitely many characteristics,
although it does not compute `N`.

Finally, `gamma` tests effective divisors on each reduction directly.
Their pullbacks under the retained birational `f` are effective Cartier
divisors, whose intersections with the ample `A_i` are nonnegative.
This establishes the needed inequality for sections that do not lift to
characteristic zero, without specializing an effective cone.

## 2. Products, fillers, Frobenius jets, and full generic rank

For a good prime `p >= k_0`, set

    v=p-k_0 floor(p/k_0),       N_p=floor(p/k_0),
    B_p=k_0 N_p D+T_0=pD+T_0-vD.

`B_p` is integral Cartier even if `pD` is not. To multiply the jet system,
split each monomial of degree at most `(2n+2)k_0 N_p` into `N_p` monomials
of degree at most `(2n+2)k_0`. Lift each factor by the given ordinary jet
surjection. Its error has strictly higher degree than the factor's prescribed
leading term. Products therefore give all monomials with a triangular
transition matrix and unit diagonal on the finite jet space. Equivalently,
successively subtract higher-degree errors using the higher-degree rows.
No factorial or characteristic-dependent multinomial coefficient is inverted.

A fixed first-slot filler in `T_0` and a fixed second-slot filler in
`T_0+vqS`, together with the second fibre coordinate to power `vq`, form a
nonvanishing section of `vq xi+T_(0,1)+T_(0,2)`. Only finitely many `v`
occur. Multiplication by this local unit changes the divisor to
`pq xi+B_(p,1)+B_(p,2)` and preserves its jet surjection.

In `2n+1` regular parameters the Frobenius quotient has monomials whose
individual exponents are below `p`, with top total degree `(2n+1)(p-1)`.
The difference from the supplied ordinary order is

    (2n+2)(p-v)-(2n+1)(p-1)
      =p-(2n+2)v+(2n+1).

Thus `p >= (2n+2)(k_0-1)` is a sufficient, deliberately conservative
threshold. The ordinary maximal-ideal power beyond this top degree lies
in the Frobenius parameter ideal.

Smooth local coordinates give finite flat relative Frobenius
`F:W -> W'`, of degree `s=p^n`. Let `E_p=F_*O_W(B_p)` and
`U_b=H^0(W,B_p+pbS)`. Projection formula gives the evaluation map

    direct-sum_(b+c=q) U_b tensor U_c tensor O(-bS'_1-cS'_2)
      -> E_p external-tensor E_p.

At the two jet base coordinates, their two Frobenius fibre algebras have
tensor product `A_*`, of dimension `R=p^(2n)`. Trivialize the lines and
choose torus coordinate `z` with `z_0 != 0`. The full jet quotient is

    A_*[z]/(z^p-z_0^p).

It is free over `A_*` on `1,z,...,z^(p-1)` because the relation is monic;
`z` is already invertible there. Reduction of `z^j` has constant
coordinate zero unless `p` divides `j`, when it is `z_0^j`. Composing the
jet surjection with this coordinate projection surjects onto `A_*`.
The surviving coefficients, for `j=pb`, are exactly the fibre evaluations
of the displayed summands, times nonzero scalars. This is an
`A_*`-linear projection on the target algebra, so no nilpotents are lost;
the resulting spanning assertion is also valid as a statement of
vector-space surjectivity over the residue field. The map has rank `R`
there and hence generically on the integral product. This says nothing
about full rank at the independently chosen diagonal point.

## 3. Global filtration, socle pairing, and Chern identity

On `Delta_F=W x_(W') W`, all weight pairs with sum `q` give the same line

    L_p=O_(Delta_F)(B_(p,1)+B_(p,2)+pqS_1),

since both `pS_i` pull back `S'` from `W'`. Finite base change and projection
formula identify its pushforward with `(E_p tensor E_p)(qS')`. Every column
restricted to the diagonal is consequently the evaluation of a global
section of `L_p`. The rank at any diagonal point is bounded by
`h^0(Delta_F,L_p)`.

Etale-locally, the ideal of its reduced diagonal is generated by parameter
differences `t_i` with `t_i^p=0`. The associated degree-one bundle is the
ambient cotangent bundle. Coordinate changes act on degree one by their
Jacobian and respect the ideal of `p`-th powers. The canonical map from
the truncated symmetric algebra to the associated graded is locally an
isomorphism, hence globally an isomorphism. This supplies the bundles

    G_j=O_W(2B_p+pqS) tensor A_j(Omega_W^1),
    u=n(p-1),       0 <= j <= u,       sum_j rank A_j=p^n.

The same computation with only the second-factor line gives the graded
pieces `O_W(B_p) tensor A_j(Omega_W^1)` of `F^*E_p`. The section
inequality comes from this actual finite filtration; no stability theorem
for the Frobenius direct image is required.

Complementary monomials give a perfect multiplication pairing in the
truncated polynomial algebra. Its top line has character
`(det V)^(p-1)`: diagonal matrices give that weight, transvections leave
only the original top monomial, and permutations give the same character
in characteristic `p`. This is a GL-equivariant polynomial identity,
not merely a count at finitely many field points, and therefore gives
the global bundle identity

    A_(u-j)(V)=A_j(V)^dual tensor (det V)^(p-1).

Writing `e_j=rank A_j`, complementary degrees satisfy

    c_1(A_j)+c_1(A_(u-j))=e_j(p-1)K_W.

Sum over all `j`; the involution on degrees and the rank sum yield

    2 sum_j c_1(A_j)=s(p-1)K_W,
    c_1(E_p)/s=B_p/p+(p-1)K_W/(2p).

The second identity uses the filtration of `F^*E_p` and Frobenius
multiplication by `p` on the identified twisted divisor classes. Division
by 2 occurs in rational divisor classes, not in the coefficient field;
characteristic 2 is not an exception.

## 4. Uniform slopes without tensor semistability

Let `g` be the fixed curve genus. For `g <= 1`, the tangent bundle is
globally generated with `A=O_C`. For `g >= 2`, a line of degree `4g-2`
has `T_C tensor A` of degree `2g`. Subtracting any point leaves degree
`2g-1 > 2g-2`, so Serre duality proves global generation. This degree
argument works in every residue characteristic. An auxiliary line of this
degree may also be chosen before spreading. Put

    c=(n-1)max(4g-2,0).

Langer's actual Corollary 2.5, applied to the rank-`n` bundle `V`, and
the retained `mu_min(V)>=0`, give `L_min(V)>=-c/(p-1)`.

The tensor estimate has a separate proof. Fix `p` and an integer `i`.
Choose a line `A_e` with degree

    ceil(-mu_min(F_C^(e*)V))+2g.

After subtracting any point the twist has minimum slope at least `2g-1`,
so its first cohomology vanishes by Serre duality and the twist is
generated. For every bundle quotient `Q` of `V^(tensor i)`, the quotient
`F_C^(e*)Q tensor A_e^(tensor i)` is generated and therefore has
nonnegative degree. Hence

    p^e mu(Q)+i deg A_e >= 0.

Divide by `p^e` and take the defining asymptotic-slope limit. The rounded
genus term tends to zero, giving `mu(Q)>=i L_min(V)`. Apply this to
all quotients, including quotients obtained by composition through a
truncated symmetric piece. This proves the minimum-slope bound needed
for `A_(u-j)(V)`, not just a bound on its average degree. The limit is
for fixed `p,i`; no interchange with the characteristic limit occurs.

Using the socle duality,

    mu_max(A_j(V))
      <= (p-1)K_W.C+(u-j)c/(p-1)
      <= (p-1)K_W.C+nc.

With `Lambda=product_i l_i`, the numerical hypotheses then give

    mu_max(G_j restricted to C)
      <= p(4+2/r)Lambda h
         +2(T_0-vD).C-K_W.C+nc
      <= 7p Lambda h+C_0.

Here `C_0` is the fixed nonnegative maximum of the finite remainder list
displayed below. Since `r>1`, the leading coefficient `4+2/r` is below
6, so 7 is valid. Neither tensor semistability nor positivity of `K_W`
on all curves is used. The single curve hypothesis does itself imply
`K_W.C>=0`, which is compatible with, but not an added hypothesis to,
this argument.

## 5. Flag evaluation and the rank polynomial

Iterate the Cartier restriction sequences down the fixed flag.
For each already fixed preceding twist, sufficiently negative twisting
by the next ample flag divisor kills sections. One justification is to
generate a positive twist of the dual bundle and dualize, embedding the
bundle in a sum of positive ample line twists. Further negative twisting
then kills the ambient line sections. The stopping index may depend on
`p,j` and the preceding twists; no uniform stopping index is required.

The resulting finite restriction filtrations, followed by enlargement of
nonnegative sums, give

    h^0(W,G_j)
      <= sum_(b_i>=0)
         h^0(C,G_j restricted to C tensor O_C(-sum_i b_i h_i)).

Put `d_i=l_i Lambda h` and `M_p=7p Lambda h+C_0`. A summand vanishes when
`sum_i b_i d_i > M_p`, since its maximum slope is negative. Otherwise
evaluation at `floor(M_p)+1` distinct curve points is injective: the
kernel would consist of sections in a bundle with negative maximum
slope after subtracting those points. This bounds the summand by
`e_j(M_p+1)`. Algebraic closures of residue fields have enough distinct
curve points for this finite evaluation.

There are at most `product_i(1+M_p/d_i)` tuples, so

    h^0(W,G_j) <= e_j P(p),
    P(X)=(aX+C_0+1) product_i(1+(aX+C_0)/d_i),
    a=7 Lambda h.

These are genuine linear evaluation and restriction bounds. If explicit
injections are wanted, choose splittings of the finite section
filtrations, then trivialize the evaluation fibres and pad the resulting
arrays. Their common integer size is
`(floor(M_p)+1) product_i(floor(M_p/d_i)+1)`. A splitting of the evaluation
quotient similarly handles the diagonal evaluation image. None of these
injections assumes the desired rank inequality.

Summing the **ranks** of the graded pieces now gives

    h^0(Delta_F,L_p) <= s P(p).

There is no additional factor `u+1`. Since
`product_i d_i=Lambda^n h^(n-1)`, the polynomial's leading coefficient
is `A=7^n h`. All coefficients are nonnegative. Set `E=P(1)-A>=0`.
For every `p>=1`, each lower-degree normalized term is bounded by its
coefficient divided by `p`; therefore

    P(p)/p^n <= A+E/p,
    rank_diagonal/R <= A+E/p.

This verifies the geometric specialization of the scalar error budget
without treating an assumed numerical bound as the geometric proof.

## 6. Arbitrary selected columns and the fixed order error

Choose any `R=s^2` generically independent weight-labelled columns from
bases of the source summands. If `m_i` is their total slot-`i` weight,
the target determinant and inverse source determinant give the actual
external-product factors

    Q_i=(det E_p)^s tensor O_(W')(m_i S'),
    lambda_i=m_i/R in [0,q],       lambda_1+lambda_2=q.

The positive sign on `m_i S'` comes from dualizing the negative source
twist. This construction does not assume balanced column choices or
`lambda_i=q/2`.

The Chern identity proves the exact normalized class

    c_1(Q_i)/R
      =D+K_W/2+lambda_i S+(T_0-vD-K_W/2)/p.

The endpoint inequality applies to each selected average weight.
The error numerator has only `k_0` possible values, independently of
the columns. With the nonnegative constant `C_gamma` below,

    pi^*c_1(Q_i).gamma/(R j_gamma)
      <= 40 epsilon+C_gamma/p.

For every nonzero section `tau` of `Q_i` on a reduction, its zero divisor
has effective strict transform
`pi^*div(tau)-ord_(x')(tau)J`. Intersecting with the retained witness gives

    ord_(x')(tau)/R <= 40 epsilon+C_gamma/p.

This works for sections existing only on the reduction. It uses the
actual determinant factors and the fixed movable witness, not nefness
of those factors or a lifting assumption.

## 7. Upper and lower orders of the same external-product determinant

The selected determinant `sigma` is nonzero because those columns are
generically independent. Kunneth in degree zero identifies its section
space with `H^0(Q_1) tensor H^0(Q_2)`. Filter each factor space by order
at `x'`. The filtration terminates: a zero germ would force a global
section to vanish on the integral variety, and Krull intersection
excludes infinite order for a nonzero germ.

Choose bases adapted to these filtrations. In each order degree their
leading forms are independent. The product's regular local ring has
two disjoint sets of parameters and a bigraded associated graded.
Tensor products of these independent leading forms stay independent in
each bidegree; different bidegrees cannot cancel. A nonzero tensor
therefore has order equal to the minimum sum of the factor orders among
its nonzero adapted-basis coefficients. In particular, for this `sigma`,

    ord_(x',x')(sigma)/R <= 80 epsilon+2 C_gamma/p.

The adapted-basis qualification is essential; no assertion that arbitrary
unadapted tensor expressions cannot cancel is being made.

At the same point `(x',x')`, let `t` be the rank of the selected square
matrix. It is at most the full diagonal rank already bounded in Section 5.
After local trivializations, invertible constant residue-field row
operations make `R-t` rows zero at the point. All their entries belong
to the maximal ideal `m`, so every determinant monomial belongs to
`m^(R-t)`. The row operations multiply the determinant by a nonzero
scalar and do not change its order. Thus

    ord_(x',x')(sigma)/R >= 1-t/R
      >= 1-rank_diagonal/R.

Generic nonvanishing was proved using `z_*`; neither of these two order
estimates moves the determinant or replaces `x` with a jet coordinate.

## Explicit-threshold interface and its precise limitation

The definitions in old REPORT lines 138-184 are supported by the above
calculations:

    C_0=max({0} union
      {2(T_0-vD).C-K_W.C+nc : 0<=v<k_0}),

    C_gamma=max({0} union
      {pi^*(T_0-vD-K_W/2).gamma/j_gamma : 0<=v<k_0}),

    A=7^n h,       E=P(1)-A,
    delta_rank=1/4-A,       delta_order=3/4-80 epsilon.

All divisor-based error constants are rational and fixed. The gaps are
positive: `A <= (14 epsilon)^n < 1/4` and `80 epsilon < 3/4`.
For every good prime

    p >= P_* = max(2, k_0, (2n+2)(k_0-1),
                   floor(E/delta_rank)+1,
                   floor(2 C_gamma/delta_order)+1),

the two strict inequalities follow:

    rank_diagonal/R <= A+E/p < 1/4,
    ord(sigma)/R <= 80 epsilon+2 C_gamma/p < 3/4.

Section 7 simultaneously gives `ord(sigma)/R > 3/4`. Section 1 supplies
good primes beyond this fixed threshold. Thus the displayed explicit
`C_0,C_gamma,E,P_*` theorem is substantively supported, conditional on
the original geometric hypotheses and the correctly applied primary
propositions; its geometric implications have been checked here.

There is a precise effectiveness limitation, not a mathematical gap:
`P_*` is a numerical threshold **for good reductions**. The argument does
not provide a computed integer containing every bad prime or an algorithm
constructing the good spread and its witnesses. Nor is the exact theorem
with arbitrary real `epsilon,r` a conclusion of the rational-scalar Lean
interface. Its real inequalities are established by the prose argument.
If a rational formal budget is required, a rational number above
`epsilon` with `80 eta<3/4` exists by the strict gap; this may enlarge the
formal order threshold and adds no rationality hypothesis to the geometry.

## Comparison with the original and formalization boundary

The pinned original `thm:finite-data` has exactly the hypotheses restated
above, including rational `D,H`, integral `S`, the fixed flag and off-axis
jets, and the independent blowup witness. Its following subsections already
give the same proof architecture: spread and preserve slopes, multiply and
fill jets, select divisible torus weights, filter the Frobenius diagonal,
use Langer and the tensor-quotient argument, sum a common flag polynomial,
normalize determinant factors, and compare adapted-tensor and rank-forced
orders. It already uses both the finite Quot alternative and the
column-independent finite remainder list.

Accordingly, the geometric old claim is a **reproduction/reconstruction**
of the original theorem and argument, not a new strengthening of its
hypotheses. The reconstruction adds explicit descent details, a direct
unbounded-characteristic explanation, more local character bookkeeping,
and concrete constants replacing the original uniform `O(1/p)` notation.
The explicit threshold is a quantitative refinement of this argument.
Its novelty was not established and is not presumed.

The statement-fidelity text was read; `Main.lean` was not inspected and no
Python, Lean, Jacobian, or Argus replay was duplicated. The parent handles
those replays and their actual toolchains. The documented formal results
address universal weight arithmetic, truncated exponent counts, conditional
linear evaluation/filtration inequalities, rational scalar budgets, and
determinant ideal-power membership. They do not themselves construct or
verify the spread, the geometric jet map, the global bundle filtration,
Langer's applicability, the flag injections, the actual determinant line
bundles, or the external-product upper-order argument. Those obligations
are precisely the substantive prose assessment above.

No unsupported proof step in the assigned scope remains identified.
This conclusion neither establishes the four surrounding manuscript main
theorems nor settles their open dependency programs. It is not a
refutation of an original theorem, a claim of original discovery, family
completion, or self-acceptance. Independent review is
`pending_native_host_reviewer`.
