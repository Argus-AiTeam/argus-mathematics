# An actual canonical kernel at prime five

## Result and scope

Let S be the 5-local sphere, X = holim_j S/5^j, and

    i = L_4(eta_X): L_4 X -> L_4 L_K(5) X.

For each integer m with **13 <= m <= 16**, the actual sphere product
beta_1^m has a nonzero image in pi_(38m) L_4 X, and that image is killed
by the specified map i. The degrees are 494, 532, 570, and 608.
In particular the operator's degree-608, sixteenth-power assertion holds.
The map i has no homotopy retraction.

This is a proof from the explicitly listed established topological inputs,
not a computation of stable stems or a wholly formalized theorem about
spectra. Lean certifies its abstract filtered-ring and commutative-square
reduction. Python independently checks exact finite-field/cochain and
filtered-product sign calculations. Neither computation is substituted for
the topological arguments below. Independent campaign review is pending.

The strongest selected manuscript statement names m=16. The improvement
here is the range 13 through 16: the sphere coefficients satisfy the sharper
upper line already implicit in Devinatz--Hopkins, so the possible extra
adic degree in the manuscript is unnecessary for this application.
We do not claim that 13 is the least possible kernel exponent, or that a
negative literature search establishes publication novelty.

## Established inputs, with exact source locators

1. **Lower named unit.** Heard, arXiv:1501.07759v2, proof of Theorem 5.6,
   printed p. 13, identifies beta with the actual unit image of the
   classical beta_1 in E_(p-1)^{hG}. Here p is odd and G is the specified
   maximal finite extended stabilizer subgroup containing p-torsion.
   At p=5 this is a K(4)-local commutative ring spectrum Y. The degree is
   2p(p-1)-2=38 and the cohomological bidegree of beta is (2,40).
   Heard--Mathew--Stojanoska, arXiv:1511.08064v1, Proposition 2.7 and the
   discussion on printed pp. 8-9, corroborate the Ext comparison, its
   possible nonzero scalar, and permanence. An independent source reader
   checked these passages; see `lower-source-reading.txt`.
2. **Lower ordinary E_infinity.** Heard, same version, Lemma 5.8,
   printed p. 14: in positive even cohomological filtration the ordinary
   homotopy fixed point spectral sequence has ring

       F_5[Delta^{+/-5}][beta]/(beta^17).

   This is not a Tate E_infinity calculation. In particular beta^16 is
   nonzero. Its filtration/internal degree is (32,640), total degree 608.
3. **Local Adams convergence and topology.** Devinatz--Hopkins,
   Topology 43 (2004), DOI 10.1016/S0040-9383(03)00029-6, Theorem 1(iii)
   identifies the full-group fixed points with B=L_K(5)S; Theorem 1(iv)
   supplies the strongly convergent local E_5-Adams spectral sequence.
   Remark 1.3 specifies the full (5,u_1,...,u_4)-adic topology.
   Theorems 2(ii) and 3 identify ordinary finite-group fixed points and
   their strongly convergent spectral sequence with the local construction.
   Appendix A, pp. 40-41, defines the relative injective resolutions used
   below. The source is saved as `dh04.pdf`, with extracted `dh04.txt`.
4. **Pure stabilizer dimension.** Morava, Annals of Mathematics 121 (1985),
   DOI 10.2307/1971192, Section 2.1.2, pp. 25-27, identifies the pure
   stabilizer with maximal-order units of the central division algebra
   of dimension n^2 over Q_p. Section 2.2.0 identifies analytic and virtual
   dimension n^2. The discussion preceding Proposition 2.2.2 and that
   proposition give finite ordinary p-cohomological dimension n^2 when
   p-1 does not divide n. Its stated *strict* dimension n^2+1 concerns
   unrestricted discrete coefficient modules and is not the ordinary
   p-primary dimension used here. Thus cd_5(St_5)=25.
   This accessible primary source replaces dependence on an inaccessible
   copy of Serre 1965 (the publisher returned HTTP 403).
5. **Finite cohomology and passage to the adic limit.**
   Devinatz--Hopkins, Lemma 4.21(ii) and its proof, printed pp. 21-22,
   show that, for a closed subgroup H of the extended stabilizer and a
   profinite module presented by finite discrete modules, continuous
   cohomology is the inverse limit of finite-level cohomology. The proof
   specifically establishes finiteness of each H^s(H;M_j), even when H
   has torsion. This is also the convention in Remark 1.3.
6. **Torsion in the relevant sphere stem.** Serre, Annals of Mathematics
   54 (1951), DOI 10.2307/1969485, Chapter V, Section 3, Proposition 3,
   states that pi_i(S^n) is finite for odd n and i>n. Suspend into an odd
   sphere in the stable range to deduce that beta_1 is torsion.
   This does not rely on an unverified assertion about its exact order.

These are external established inputs, not new results claimed here.
All the remaining comparisons are proved next. General categorical facts
used are the exactness and universal property of spectral localization,
the long exact sequence of homotopy groups, and limits of local objects
remaining local.

## 1. The lower associated-graded class is an actual nonzero product

The ordinary homotopy fixed point spectrum Y=E_4^{hG} is K(4)-local:
E_4 is local and local objects are closed under homotopy limits. Its unit
eta:S->Y is a ring map. Let y=eta_*(beta_1). By input 1,

    y belongs to F^2 pi_38 Y, with [y]=c beta and c in F_5^*.

We justify the actual multiplicative filtration, rather than silently
equating an E_2 product with a homotopy product. Use the free homogeneous
bar space EG, with its skeletal filtration. For a simplex with barycentric
coordinates t_0,...,t_q, let c_i=sum_(j<=i)t_j, c_-1=0, and put

    ell_i = 2(min(c_i,1/2)-min(c_(i-1),1/2)),
    rho_i = 2(max(c_i,1/2)-max(c_(i-1),1/2)).

Both vectors are barycentric. These formulas commute with ordered
coordinate aggregation, since the corresponding intervals are
consecutive and intersection lengths add, including empty fibers.
Consequently they define a continuous equivariant map EG->EG x EG,
homotopic to the diagonal by linear interpolation of barycentric
coordinates. On the region with the half-cut in coordinate k, its two
faces have dimensions k and q-k. Thus it carries the s-skeleton into
the union of products of skeleta whose dimensions sum to at most s.
It descends to relative maps

    EG/EG^(r+s-1) -> (EG/EG^(r-1)) smash (EG/EG^(s-1)).

Applying equivariant function spectra and multiplication gives products
on the *relative fibers* of the ordinary fixed-point tower. Their images
in pi_*Y are multiplicative, and after forgetting the relative conditions
their product is the actual product, by the homotopy to the diagonal.
On the kth region the source/product coordinate Jacobian is +2^q;
the cellular map is the Alexander--Whitney sum, with no extra orientation
sign. Hence its E_2 product is the ordinary cup product, and exact-couple
naturality identifies every later product. Multi-cuts in successive
positive-length intervals give filtered associativity: refinement is
composition and different lengths are joined within a convex simplex.

Strong convergence identifies the successive quotients of this actual
filtration with the ordinary E_infinity. It follows that

    [y^16] = c^16 beta^16 != 0 in F^32/F^33.

Therefore y^16 is nonzero in pi_608 Y. The nonzero associated-graded
class is sufficient; no assertion about hidden additive extensions is
needed. If y^m were zero for 0<=m<=16, multiplying by y^(16-m) would
contradict y^16!=0. In particular every required mth power is nonzero.
The unit identifies these powers with the *specified* beta_1^m.

## 2. The order-five quotient is treated semilinearly

Write O=W(F_(5^5))[[u_1,...,u_4]], with maximal ideal m, and let

    G_5 = St_5 semidirect Gal(F_(5^5)/F_5).

The Galois quotient Q is C_5. The extended group has a subgroup of order
five, so a torsion-free analytic cohomological-dimension theorem must NOT
be applied to that extended group for arbitrary coefficients. This route
is explicitly retired in the claim ledger.

For completeness, a pure element g of order five would satisfy
Phi_5(g)=0 in the division algebra: (g-1)Phi_5(g)=0 and g-1 is nonzero.
Phi_5(X+1)=X^4+5X^3+10X^2+10X+5 is Eisenstein at five, so Q_5(g)
would have degree four. The dimension-25 division algebra, as a left
vector space over this subfield, would then have Q_5-dimension divisible
by four. This is impossible. The pure dimension theorem therefore
applies exactly as input 4 states.

The pure stabilizer fixes W(F_(5^5)). Indeed it fixes the residue field,
and in the complete deformation ring the roots lifting residue elements
of X^(5^5)-X are unique by Hensel's lemma (the derivative is -1 modulo m).
It therefore fixes the Teichmuller representatives and their convergent
Witt expansions. The quotient acts by the Witt Frobenius. The finite
modules (E_5)_q/m^j(E_5)_q thus have Witt-linear pure action and semilinear
Galois action; the full ideal is invariant. Odd q gives the zero module.

Here is a proof of the required semilinear acyclicity, valid without
finiteness or flatness of a module P. For a finite group Q acting on a
commutative ring W, choose w with sum_g g(w)=1. On homogeneous equivariant
cochains f:Q^(q+1)->P define

    (hf)(g_0,...,g_(q-1))
       = sum_gamma gamma(w) f(gamma,g_0,...,g_(q-1)).

Changing gamma to g gamma and using semilinearity proves equivariance.
In hd+dh the term deleting the inserted coordinate is f; all the terms
deleting a displayed coordinate have coefficients (-1)^(i+1)+(-1)^i=0.
Thus hd+dh=id in every positive degree, so H^i(Q,P)=0 for i>0.
No division by |Q| occurs.

The necessary Witt trace-one element exists: a residue trace-one
element lifts to w_0 whose Witt trace is an invariant unit; divide w_0
by that unit. An explicit residue model is

    k = F_5[a]/(a^5-a-1), sigma(a)=a+1, w=-a^4.

The polynomial is irreducible: a^(5^5)=a, and its gcd with X^5-X is one;
since 5 is prime, the standard factor-degree argument proves
irreducibility. Equivalently this is the nontrivial Artin--Schreier
polynomial over F_5. The identity

    sum_(i=0)^4 -(a+i)^4 = 1

gives the trace-one element even though Trace(1)=5=0. Python replays
this exact field identity, the complete Jacobian Frobenius table, and
the homogeneous-cochain contraction in positive degrees 1,2,3.
These are finite exact tests of the displayed formulas; the all-module,
all-degree proof is the cancellation argument above.

Hochschild--Serre for finite discrete coefficients now collapses:
the pure cochain differential is Witt-linear, and its cohomology carries
the conjugation-semilinear Q-action. Its positive Q-cohomology vanishes,
so H^s(G_5;M_j)=H^s(St_5;M_j)^Q=0 for s>25.

## 3. A sharp upper cohomology line for the actual sphere coefficients

For M=(E_5)_q=lim_j M_j, continuous inhomogeneous cochains are the
inverse limit of the finite-level cochains. Their transition maps are
degreewise surjective: lift the finitely many values of a locally constant
cochain. The countable inverse-limit exact sequence is

    0 -> lim^1 H^(s-1)(G_5;M_j)
      -> H^s(G_5;M) -> lim H^s(G_5;M_j) -> 0.

The manuscript keeps a possible extra degree and obtains s>26. For
these sphere coefficients, input 5 shows that every finite-level
cohomology group is finite. A tower of finite groups is Mittag--Leffler:
for each target index its descending sequence of images stabilizes.
Hence its lim^1 is zero. One can see this directly from the
product description of lim^1 as coker(1-shift): each finite subsystem
of the equations a_j-t_j(a_(j+1))=b_j has a solution by backward
substitution, and compactness of the product of finite groups gives a
solution to the whole system. Consequently

    H^s_cts(G_5;(E_5)_q)=0 for every s>25 and every q.

This is also exactly the inverse-limit cohomology convention of DH
Remark 1.3 and the conclusion of Lemma 4.21(ii). We make no analogous
finite-cohomological-dimension claim for arbitrary extended-group
modules. This sharper conclusion is not obtained by dropping a lim^1
term without its finiteness justification.

## 4. The upper filtration is multiplicative on actual stage images

Work in K(5)-local spectra with tensor U tensor V=L_K(5)(U smash V)
and unit B=L_K(5)S. Let E=E_5 and I=fib(B->E).

First compare relative Adams resolutions in an exact monoidal stable
category. Suppose T_(s+1)->T_s->Q_s and T'_(s+1)->T'_s->Q'_s
are two such resolutions starting at V, with E-injective right terms
and E tensor q_s split monic. Given f_s:T_s->T'_s over V, set
g=q'_s f_s. Choose Q'_s -> E tensor Z -> Q'_s as a retract and
a left inverse sigma to E tensor q_s. Then

    Q_s -> E tensor Q_s -> E tensor T_s
        -> E tensor E tensor Z -> E tensor Z -> Q'_s

(unit, sigma, E tensor (inclusion composed with g), multiplication,
retraction) extends g along q_s. Naturality of the unit and the
module-unit law prove that its composite with q_s is exactly g.
The resulting square extends to the fiber triangles. Starting with
identity at stage zero constructs maps through any specified finite
stage, *over V*. This gives inclusion of stage-s images in [W,V].
Reversing the resolutions gives equality. There is no index shift
and no need to assert an equivalence of inverse-limit towers.
These are precisely the relative resolutions in DH Appendix A.

Tensoring the fiber triangle I->B->E with I^(tensor s) gives

    I^(tensor(s+1)) -> I^(tensor s) -> E tensor I^(tensor s).

Multiplication on E splits E tensor q_s, and the right term is
E-injective. The stage-image comparison with the DH resolution,
input 3, identifies the actual filtration:

    F^s pi_* B = image(pi_* I^(tensor s) -> pi_* B).

In particular F^0 is the whole group and F^1 is the kernel of
pi_*B->pi_*E. A suspended sphere mapping to a local object is
equivalently a suspended local unit mapping to that object. Tensoring
lifts through I^(tensor r) and I^(tensor s) therefore lifts their
*actual homotopy product* through I^(tensor(r+s)). Thus
F^r F^s is contained in F^(r+s). Monoidal localization sends the
sphere product to that product. No smashing-localization assertion
is used.

Strong convergence supplies separation and identifies these actual
successive quotients with E_infinity. By Section 3 the E_2 page is
zero for s>25. Hence all quotients F^s/F^(s+1) are zero for s>=26.
That tail is constant, and separation makes its common value zero:

    F^26 pi_* B = 0.

This is vanishing of *homotopy images*, not a claim that the maps
I^(tensor 26)->B themselves are null. No phantom-map or exponent
argument is being smuggled into this step.

## 5. The upper unit kills the same named products

Let b be the image of beta_1 in pi_38 B. The source element is
torsion by input 6, whereas (E_5)_38 is torsion-free. Thus b
maps to zero in E and belongs to F^1. Evenness gives

    F^1 pi_38 B / F^2 pi_38 B = E_infinity^(1,39) = 0,

since (E_5)_39=0 already on E_2. Therefore b belongs to F^2.
For every m>=13, b^m belongs to F^(2m), contained in F^26=0.
Because the unit is multiplicative, this is the image of the
specified sphere product beta_1^m, not a chosen substitute.
The original m=16 assertion also follows using the manuscript's
weaker F^27 tail: 32>=27. The improvement to m=13 uses the
separately justified sharp line.

## 6. Completion and the *specified* canonical map

Taking inverse limits of the cofiber sequences
S --5^j--> S -> S/5^j, with transition 5 on the left and identity
in the middle, identifies the fiber C of c:S->X with

    holim(... --5--> S --5--> S) = F(S[1/5],S).

Multiplication by five is invertible on C, since it is invertible
on the first argument of this function spectrum. It remains so
after ordinary smash with K(a). But the homotopy of K(a) smash C
is a module over K(a)_*, and is annihilated by five for a>=1.
An endomorphism both zero and invertible forces this module to be
zero. Thus c is a K(a)-equivalence, without commuting smash
products with inverse limits.

The K(4)-local detector S->Y consequently factors through X, and
then through L_4 X, because a K(4)-local object is L_4-local.
These factorizations can be chosen as ring maps: use
L_K(4)X ~= L_K(4)S, followed by its ring-unit factorization into Y.
The localization functors are monoidal into their local categories;
this assertion does not require the localization to be smashing.
Its nonzero value on beta_1^m proves that the image z_m in
pi_(38m)L_4 X is nonzero, for all 13<=m<=16.

Let eta denote K(5)-localization and lambda denote L_4-localization.
Naturality gives the two actual equalities

    eta_X c = L_K(5)(c) eta_S,
    i lambda_X = lambda_(L_K(5)X) eta_X.

Their composite says

    i lambda_X c
      = lambda_(L_K(5)X) L_K(5)(c) eta_S.

The right side sends beta_1^m to zero by Section 5, so i_*(z_m)=0.
The nonzero z_m therefore obstructs a homotopy retraction of this
exact map i. This completes the proof, with all source inputs
exposed above.

## Machine scope and remaining review

`verify.py` checks the exact finite algebra, sparse cochain homotopy,
cyclic resolution, half-cut signs and boundary naturality, truncation
calculation, and degree/threshold arithmetic. `Main.lean` proves the
universal filtered-ring tail/power theorem and its specified-square
kernel assembly for 13<=m<=16. `statement_fidelity.md` gives the
quantifiers and the omitted topological constructions precisely.

The topological inputs and the prose constructions of Sections 1, 2,
4, and 6 require mathematical review; the exact script is not a
decision procedure for them. The Host, not Engineer, invokes the
independent Reviewer. Publication significance and novelty remain
for that review; a targeted search for the explicit beta_1^13
canonical kernel returned no relevant results, which is not a
novelty certificate.

The official Lean 4.31.0 compiler run completed with exit_code=0,
audit_exit_code=0, and proof_holes=[]; its claim-bound certificate is
`certificates/C318ALG-42d6b21372954c97.json`. Only the usual kernel
axioms `propext` and `Quot.sound` occur in the printed core declarations.
This certifies C318ALG, not the topological claim C318P5.

For substantive offline replay run `python3 verify.py`. The optional
`python3 verify.py --lean` additionally performs a fresh compiler run
through the prescribed explicit Argus interpreter and both campaign-local
structural checks. The stored exact certificate is generated from the
finite algebra, not from artifact-existence or hash assertions.

Formal citation attribution is still queued in `citation-status.json`.
The primary texts were obtained and the lower statements independently
read, but source-reader judgements are not substituted for the official
literature tier. The official attribution writer unconditionally archives
under `research/literature/`, outside this mission's authoritative writable
paths; it was not run in violation of that boundary. Citation archival and
the independent topological review remain Host/Reviewer delivery gates.
