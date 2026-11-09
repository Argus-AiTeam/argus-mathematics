# Effective finite-data Frobenius obstruction

## Scope and classification

The target is `thm:finite-data` in
`research/openai_manuscript/Numerical-Semiampleness-of-Nef-Adjoint-Divisors-October-3-2026/build/sections/frobenius.tex`,
not the abundance or minimal-model conjectures in the companion papers.
The manuscript sources and their staging symlinks are inputs, not editable
artifacts. The campaign remains exploratory, with a publishable target.
Independent Host-invoked review has not occurred.

Here is the complete geometric assertion being audited. Suppose that:

* W is smooth, connected and projective over C, of dimension n >= 2;
  D and H are rational Cartier divisors, H is ample, S is integral Cartier,
  q is a positive integer, r > 1, and epsilon > 0.
* Writing h = H^n, the numerical bounds are
  h <= (2 epsilon)^n, K_W H^(n-1) <= 2h/r,
  (2D+qS) H^(n-1) <= 4h,
  (14 epsilon)^n < 1/4 and 80 epsilon < 3/4.
* A fixed smooth integral complete-intersection flag ends in a curve C.
  Its successive divisors have classes l_i H, with positive integers l_i
  making these classes Cartier, and
  mu_min(Omega_W^1 restricted to C) >= 0.
* On Z = P(O_W(S)_1 direct-sum O_W(S)_2) over W x W, with the
  symmetric-power direct-image convention, finitely many sections of
  k_0(D_1+D_2+q xi) generate all ordinary jets of order (2n+2)k_0
  at a point z_* outside both axes. Here k_0 is a positive integer and
  k_0 D is Cartier.
* Independently of the coordinates of z_*, there is a point x, its blowup
  pi: W_hat -> W with exceptional divisor J, and a fixed class
  gamma = f_*(A_1 ... A_(n-1)), where f: V -> W_hat is birational,
  V is smooth integral projective, and all A_i are ample integral Cartier.
  One has j_gamma = J.gamma > 0 and
  pi^*(D+K_W/2+lambda S).gamma <= 40 epsilon j_gamma for
  every real lambda in [0,q] (equivalently, for both endpoints).

The assertion is that no such fixed dataset exists. Neither nefness of
D, S or K_W nor pseudo-effectivity of K_W is an additional hypothesis.
All constants and all geometric choices must precede varying the residual
characteristic.

## Family statements and actual dependencies

These are assertions of the supplied manuscripts, not accepted external
theorems. Certifying the finite-data assertion alone does not certify any
of these four main statements.

| Manuscript and statement locator | Statement | Principal choke points |
|---|---|---|
| Projective numerical semiampleness, `build/sections/introduction.tex`, `thm:main` | For a projective klt rational pair in characteristic zero with K+B pseudo-effective and M a nef rational Cartier divisor on X, nefness of D=K+B+M implies D is numerically equivalent to a semiample rational Cartier divisor. | Companion ordinary log abundance and generalized MMP; simultaneous induction and nef reduction; terminal Calabi-Yau full-nef-dimension bigness; scalar and projective-bundle jet estimates; the finite-data Frobenius obstruction. |
| Compact Kahler numerical semiampleness, `build/sections/01-introduction.tex`, `thm:main` | For a smooth connected compact Kahler X, an effective rational SNC boundary with coefficients <1, and a nef rational holomorphic line M, if K+B is pseudo-effective and K+B+M is nef, its real Bott-Chern class has a semiample rational line representative. | Projective positive-part theorem (Proposition 8.1 of the projective companion); analytic ordinary decomposition; the algebraic-dimension-zero two-diagonal argument; rational nef descent, global flat twists and period-based adjoint construction. |
| Generalized minimal models, `build/sections/01-introduction.tex`, `thm:main` | A projective generalized lc rational pair over an algebraically closed characteristic-zero field, with fixed nef rational b-divisor, admits a non-extracting discrepancy-improving birational model: nef adjoint in the pseudo-effective case, or a connected-fibre Mori contraction of relative Picard number one with relatively antiample adjoint otherwise. No factoriality or arbitrary-MMP termination is asserted. | Local cyclic-character phase theorem; cone and product estimates; valuation optimization, Cartier selection and rounding; integral jump, lifting/mixing and bounded-fibre estimates; smooth termination and relative weak-Zariski-decomposition transfer. |
| Numerical-dimension-one minimal models, `build/sections/introduction.tex`, `main:theorem` | A smooth connected complex projective n-fold, n >= 3, with K pseudo-effective and section-growth kappa_sigma(K)=1 has a finite K-negative MMP to a projective rational-factorial terminal model with nef K; on a common resolution p^*K_X=q^*K_Y+E, E effective q-exceptional and containing every contracted prime transform. | Codimension-two stabilization of concatenated perturbation MMPs; extension from a fixed surface with a fixed ample twist; quadratic-growth exclusion; a second surface through a hypothetical negative curve. The good-model corollary separately assumes companion log abundance. |

The section-growth convention in the fourth paper fixes the ample twist
before the limsup; it does not assert an O(m) bound. The Kahler statement
allows a flat change of line bundle, not actual semiampleness of the original
adjoint. These distinctions are retained in the claim ledger.

## Literature scope

The supplied Wiki index and a targeted search of its semantic pages supplied
no family-specific Frobenius or slope result. Unrelated occurrences of
"Frobenius" in other campaigns are not inputs here. The staging directories
are traversable by explicit source paths; a non-following glob's report of
empty directories was not treated as missing mathematical evidence.

The projective bibliography supplies the following precise leads:

* A. Langer, *Semistable sheaves in positive characteristic*,
  Annals 159 (2004), 251-276,
  DOI 10.4007/annals.2004.159.251, Corollary 2.5.
  Its curve-slope inequality is the only specialized external numerical
  estimate in the reconstruction below; it must be read with its hypotheses.
* X. Sun, *Direct images of bundles under Frobenius morphism*,
  arXiv:math/0611360v2, Theorem 3.7 and Lemma 4.2
  (published DOI 10.1007/s00222-008-0125-y).
* Y. Kitadai and H. Sumihiro, *Canonical filtrations and stability of direct
  images by Frobenius morphisms*, DOI 10.2748/tmj/1215442876,
  Corollary 3.5.
* M. Mustata and K. Schwede, *A Frobenius variant of Seshadri constants*,
  arXiv:1203.1081v1, proof of Proposition 2.12, Equation (2.8)
  (published DOI 10.1007/s00208-013-0976-4).

The local filtration, socle pairing, jet comparison and first-Chern identity
will be reconstructed rather than assumed from these last three sources.
The companion *Log abundance in characteristic zero*, Theorem 9.1, is
the manuscript's attribution for the target; it is not an independent proof
input. The other companions' abundance, MMP and analytic results remain
unverified family dependencies.

The foundational results used for the reduction argument were separately
read at their actual sources:

* The Stacks Project, [tag 01ZM](https://stacks.math.columbia.edu/tag/01ZM),
  Lemma 32.10.1, descends finitely presented schemes, morphisms and
  equalities along a directed affine inverse limit of quasi-compact,
  quasi-separated schemes. It is not alone a smoothness/ampleness theorem.
* The Stacks Project, [tag 0559](https://stacks.math.columbia.edu/tag/0559),
  Lemma 37.27.5, spreads geometric irreducibility of the generic fibre to
  a nonempty open for a finite-type morphism with irreducible base.
* N. Nitsure, *Construction of Hilbert and Quot Schemes*,
  arXiv:math/0504590v1, Theorem 5.1 (Grothendieck), printed page 24,
  gives a projective fixed-Hilbert-polynomial Quot scheme for a coherent
  sheaf on a projective scheme over a noetherian base.

The exact hypotheses and the applications are separated in the adjacent
`stacks_*_excerpt.txt` and `nitsure_theorem_5_1.txt`. A search-generated
suggestion to cite Stacks 01XW for Quot projectivity was rejected after
opening that primary page: it computes projective-space cohomology,
not Quot schemes. No unexamined search summary is treated as a theorem.

## Jacobian scope

Discovery and exact typed contracts are retained in the adjacent
`jacobian_*_find.json`, `jacobian_find.json`, and
`jacobian_*_contract.json` files. The reported server is Jacobian 0.14.0,
protocol 2025-11-25, through Argus's isolated MCP-stdio bridge.
The bounded prime-field matrix operation can check a small torus-coordinate
quotient, but not a vector-bundle filtration, its uniform slope bound, or
arbitrarily large good reductions. The symbolic determinant operation works
over QQ in at most eight variables, not arbitrary local rings in varying
characteristic. This mismatch is not repaired by changing the target.

The chosen bounded operation is `prime_field.matrix.rank.compute`.
Its exact payload is `jacobian_rank_payload.json`: columns are z^j for
0 <= j <= 6 in GF(3)[z]/(z^3-1), in the basis (1,z,z^2).
The first coordinate selects precisely weights divisible by 3. The run is a
finite illustration only, not a proof of the geometric theorem.

The recorded run succeeded, returned rank 3 over GF(3), and bound the typed
answer to the exact input matrix; its adapter runtime was 0 ms. There was
no structured error or timeout. `verify.py` independently checks an identity
3-by-3 minor and the three-row upper bound. Nothing about this finite run
is used to conclude uniformity.

## Effective verification theorem

The following is a quantitative refinement of the target's proof, not a
counterexample. Fix a purported dataset in the target statement. Choose the
finite filler system T_0 as below and put

    h = H^n > 0,       Lambda = product(l_i),
    d_i = l_i Lambda h > 0,       a = 7 Lambda h,
    g = genus(C),     c = (n-1) max(4g-2,0).

For the finite set of rational divisor classes indexed by 0 <= v < k_0,
define the following **fixed, explicit** rational numbers:

    C_0 = max( {0} union
        { 2(T_0-vD).C - K_W.C + n c : 0 <= v < k_0 } ),

    C_gamma = max( {0} union
        { pi^*(T_0-vD-K_W/2).gamma / j_gamma : 0 <= v < k_0 } ),

    P(X) = (a X+C_0+1) product_i (1+(a X+C_0)/d_i),
    A = 7^n h,       E = P(1)-A.

All coefficients of P are nonnegative, its degree is n, its leading
coefficient is A, and E >= 0. No selected determinant column or filtration
degree enters these constants. Define positive gaps

    delta_rank = 1/4 - A,
    delta_order = 3/4 - 80 epsilon.

The first is positive since A <= (14 epsilon)^n < 1/4. For every good
residual characteristic p satisfying

    p >= P_* := max(2, k_0, (2n+2)(k_0-1),
                    floor(E/delta_rank)+1,
                    floor(2 C_gamma/delta_order)+1),

the hypotheses yield a nonzero determinant sigma, of size R=p^(2n), for
which simultaneously

    ord(sigma)/R >= 1 - rank_diagonal/R > 3/4,
    ord(sigma)/R <= 80 epsilon + 2 C_gamma/p < 3/4.

There are good reductions with p arbitrarily large, so this is a
contradiction. The proof below supplies the geometric implications; the
algebraic interfaces and uniform-budget induction have separate Lean proofs.
No numerical fixture in the certificate is represented as a geometric
dataset.

### 1. Good reductions really are available

Choose an integral Cartier T_0 sufficiently ample that T_0+vS is globally
generated for every integer 0 <= v <= (k_0-1)q. Choose, over C, the
finitely many filler sections needed to be nonzero at the two fixed base
coordinates of z_*. There is no moving choice as p varies.

All varieties, points, blowups, the birational morphism f, ample divisors,
line bundles, sections, and the flag descend to an integral finitely
generated characteristic-zero Z-algebra R_0. Localize this algebra so that
the models and flag members are smooth projective and geometrically
integral, all specified ample line bundles stay ample, the blowup and
exceptional divisor have the specified form, and the finite jet and
nonvanishing conditions persist. A finite jet evaluation is a map between
finite locally free modules after localization; its cokernel vanishes on an
open neighbourhood of the generic fibre. Spread dense-open isomorphisms
for f and the other birational maps; their fibrewise nonemptiness is retained
after localization. Intersections of the fixed divisor classes are constant.

Concretely, preserve projectivity and each ample line by descending fixed
projective embeddings for sufficiently high powers of the finitely many
ample lines. Preserve smoothness by the smooth-locus criterion and
properness: the nonsmooth locus is closed with image missing the generic
point. Apply Stacks 0559 to each model and each flag member for geometric
irreducibility; smoothness supplies geometric reducedness. Thus the
finite-presentation descent result is not being misquoted as automatically
preserving all these open properties.

Here is an explicit openness argument for the only slope condition used.
On the curve family, choose a fixed positive-degree line bundle L of degree
d so that V tensor L, V=Omega_W^1|_C, is relatively generated, after
localization. Every rank-b coherent quotient of V has degree >= -bd.
A negative-degree quotient therefore has one of finitely many pairs
(b,e), 1 <= b <= n, -bd <= e <= -1. The relative Quot scheme for each
such Hilbert polynomial is projective, so its image in the base is closed.
None of these images contains the geometric generic point: removing the
torsion from a negative-degree quotient gives a negative-degree bundle
quotient, contrary to the complex hypothesis. Removing these finitely many
images ensures mu_min(V)>=0 on every remaining geometric fibre.
This does not assume strong semistability after reduction.

There is a useful algebraic reason that localization cannot leave only
bounded characteristics. For any integral finitely generated Z-algebra R
of characteristic zero, apply Noether normalization to R tensor Q.
Clear the finitely many integer denominators in the normalizing elements
and in monic equations for the algebra generators. For some nonzero integer
N, R[1/N] is finite integral over
Z[1/N][t_1,...,t_d]. Lying-over supplies a closed point of R[1/N] above
(p,t_1,...,t_d) for every prime p not dividing N. Its residue field is finite
over GF(p). Apply this to the already localized good-model algebra.
After excluding the fixed denominator primes, good reductions thus exist
in all but finitely many prime characteristics, in particular beyond P_*.
The integer N belongs to the chosen spread, not to the variable p.

Finally the class gamma on each such reduction tests **all effective
divisors there**, whether or not they lift. Indeed, the pullback of an
effective Cartier divisor by the fixed birational f is effective, and its
intersection with the fixed ample A_1,...,A_(n-1) is nonnegative. Smoothness
of the blowup makes the relevant divisors Cartier. This avoids any
specialization claim about an effective cone.

### 2. Ordinary jets, Frobenius jets and the off-diagonal full rank

Write v=p-k_0 floor(p/k_0), so 0<=v<k_0, and set

    N_p=floor(p/k_0),       B_p=k_0 N_p D+T_0,
    B_p-pD=T_0-vD.

Products of N_p sections from the fixed system generate ordinary jets
through (2n+2)k_0 N_p. To see this in every characteristic, split each
monomial of that total degree into N_p monomials of degree <=(2n+2)k_0.
Lift the factors using the given jet surjection. Their product has the
prescribed leading monomial and only terms of strictly higher degree.
An induction in total degree removes these errors. The degree-zero product
starts the induction. No factorial is inverted.

Multiply this system by a fixed filler of class
v q xi+T_(0,1)+T_(0,2), using a weight-zero first-slot section and the
second coordinate to power vq. The filler is nonzero at z_* because both
torus coordinates are nonzero. The resulting divisor is

    pq xi+B_(p,1)+B_(p,2).

Multiplication by the filler is a unit on the local jet algebra.
For d=2n+1, the quotient by p-th powers of regular parameters has basis
the monomials with all d exponents <p, hence top degree d(p-1).
The exact identity

    (2n+2)(p-v)-(2n+1)(p-1)
       = p-(2n+2)v+(2n+1)

shows that p >= (2n+2)(k_0-1) suffices for the required ordinary/Frobenius
jet comparison. Thus it holds for every p>=P_*.

Let F:W->W' be relative Frobenius. Smooth local coordinates make F finite
flat of degree s=p^n. Set E_p=F_*O_W(B_p), a vector bundle of rank s,
and U_b=H^0(W,B_p+pbS). Projection formula gives the manuscript's map

    direct-sum_(b+c=q)
      U_b tensor U_c tensor O(-bS'_1-cS'_2)
        -> E_p external-tensor E_p.                         (1)

At the two base coordinates of z_*, let A_* be the tensor product of the
two Frobenius fibre algebras. It has dimension p^(2n), and need not be
reduced. In a torus coordinate z with value z_0 != 0, the full local
Frobenius jet algebra is

    A_*[z]/(z^p-z_0^p),

free over A_* on 1,z,...,z^(p-1). The coefficient of 1 in the reduction
of z^j is zero unless p divides j, and then is z_0^j. Surjectivity onto
the full algebra therefore implies surjectivity of the coefficient of 1.
Only j=pb, 0<=b<=q, survive; these coefficients are exactly the fibre
values of the summands in (1), multiplied by nonzero scalars z_0^(pb).
Thus (1) has full rank R=s^2 at that pair of points, and generically.
The argument is linear over A_*, so does not discard nilpotents. No
identification of this pair with (x,x) has been made.

### 3. Reconstructing the diagonal filtration and its determinant

Let Delta_F=W x_(W') W and h_F:Delta_F->W'. Since
pS_1 and pS_2 both pull back S' from W', all pairs b+c=q restrict to
the same line

    L_p=O_(Delta_F)(B_(p,1)+B_(p,2)+pqS_1).

Finite base change identifies (E_p tensor E_p)(qS') on the diagonal with
(h_F)_*L_p. Consequently the values of all columns of (1) at any diagonal
point lie in the image of H^0(Delta_F,L_p). In particular their rank is
at most that dimension.

Etale smooth coordinates identify the diagonal ideal locally with the
ideal generated by parameter differences t_1,...,t_n, with t_i^p=0.
Its conormal bundle is Omega_W^1. Coordinate changes preserve the
p-th-power ideal because (sum a_i t_i)^p=sum a_i^p t_i^p.
The associated graded is therefore Sym(Omega_W^1)/(p-th powers), not the
ordinary untruncated symmetric algebra. Put

    u=n(p-1),        A_j(V)=degree-j truncated symmetric power,
    e_j=rank A_j(V),       sum_j e_j=p^n=s.

Filtering L_p gives the bundles on W

    G_j=O_W(2B_p+pqS) tensor A_j(Omega_W^1),  0<=j<=u.       (2)

The same coordinate calculation, with only the second-factor line,
filters F^*E_p with pieces O_W(B_p) tensor A_j(Omega_W^1).
This derives the filtration rather than importing a stability assertion
about F_* from Sun or Kitadai-Sumihiro.

The top truncated monomial pairs each exponent vector with its complement
to (p-1,...,p-1). Multiplication thus gives a perfect pairing

    A_(u-j)(V) = A_j(V)^dual tensor (det V)^(p-1).           (3)

For completeness the top line has the stated character in every
characteristic: a diagonal change of frame acts by product a_i^(p-1);
a transvection contributes only its original top monomial since each
other term has an exponent >=p; and a swap acts by 1, equal to
(-1)^(p-1) in characteristic p. These matrices generate GL_n over the
field; the local polynomial identity gives the same bundle character.
Alternatively the one-dimensional algebraic representation is determined
by its restriction to the diagonal torus.

Summing (3) and using e_(u-j)=e_j gives, in rational divisor classes,

    2 sum_j c_1(A_j(Omega_W^1)) = s(p-1)K_W.               (4)

There is no division by 2 in the coefficient field: this is an identity
in the rational numerical divisor space, valid also when p=2. It follows
that

    c_1(E_p)/s = B_p/p + (p-1)K_W/(2p).                   (5)

Indeed c_1(F^*E_p)=s B_p+sum_j c_1(A_j), and relative Frobenius multiplies
twisted numerical divisor classes by p. Complement and coordinate-sum
arithmetic, including p=2, is separately formalized in Main.lean.

### 4. An explicit uniform slope bound

The primary Langer paper was actually obtained from the Annals publisher;
`langer_2004.pdf`, its text, and `langer_corollary_2_5.txt` are local.
Section 2 allows smooth projective varieties of arbitrary dimension.
Corollary 2.5, page 258, bounds both Frobenius extremal-slope errors by
(rank-1)deg(A)/(p-1) on a curve, provided A is nef and T_C tensor A is
globally generated. This is the exact numerical input used here; it does
not assert tensor-product semistability.

For g<=1 take A=O_C. For g>=2 take a line of degree 4g-2; then
deg(T_C tensor A)=2g, and Serre duality gives global generation by
testing evaluation at each point. Thus deg A<=max(4g-2,0), independently
of p. With V=Omega_W^1|_C, the preserved mu_min(V)>=0 gives

    L_min(V) >= -c/(p-1).                                (6)

Here L_min is the limit of p^(-e)mu_min(F_C^(e*)V).
The following tensor estimate needs an argument, rather than a
characteristic-zero tensor-semistability assertion. For fixed p and i,
choose a line A_e of degree
ceil(-mu_min(F_C^(e*)V))+2g. Subtracting any point leaves minimum slope
>2g-2, so Serre duality makes F_C^(e*)V tensor A_e globally generated.
For any bundle quotient Q of V^(tensor i), the bundle
F_C^(e*)Q tensor A_e^(tensor i) is generated, and hence has nonnegative
degree. Dividing its degree by rank and p^e and taking e->infinity gives

    mu(Q) >= i L_min(V),   so
    mu_min(V^(tensor i)) >= i L_min(V).                   (7)

This limit is for each fixed p,i. There is no simultaneous limit or
uniform choice of e hidden here. A_j(V) is a quotient of V^(tensor j).
Applying (7) to A_(u-j)(V) and then (3) gives

    mu_max(A_j(V)) <= (p-1)K_W.C + (u-j)c/(p-1)
                    <= (p-1)K_W.C + n c.                (8)

For (2), substitution of B_p=pD+T_0-vD now gives

    mu_max(G_j|_C)
      <= p(2D+qS+K_W).C + 2(T_0-vD).C-K_W.C+n c
      <= p(4+2/r)Lambda h+C_0
      <= a p+C_0 = M_p.                                 (9)

The last step uses r>1; 7 is larger than 4+2/r. The constants in
(6)-(9) have no dependence on j or on p. We did not assume K_W
pseudo-effective. The curve slope hypothesis itself implies K_W.C>=0,
but no stronger positivity is used.

### 5. The common flag polynomial really bounds the rank

Iterate the Cartier restriction sequences down the fixed flag. At each
stage sections vanish after sufficiently negative ample twisting: the
dual of the fixed vector bundle admits a sufficiently positive generated
twist, which embeds the original bundle in a sum of ample line twists.
This stopping index need not be uniform. Enlarging the resulting finite
nonnegative sums gives

    h^0(W,G_j) <= sum_(b_1,...,b_(n-1)>=0)
      h^0(C,G_j|_C tensor O_C(-sum b_i h_i)).             (10)

A summand is zero if sum b_i d_i>M_p, by (9) and the absence of sections
in a negative-maximal-slope curve bundle. Every other summand is at most
e_j(M_p+1): evaluation at floor(M_p)+1 distinct points is injective,
since its kernel would have negative maximal slope. The possible tuples
number at most product_i(1+M_p/d_i). Hence

    h^0(W,G_j) <= e_j P(p),                              (11)
    h^0(Delta_F,L_p) <= sum_j e_j P(p) = s P(p).          (12)

The ranks, not merely the number of filtration pieces, are summed.
This is the reason no extraneous factor n(p-1)+1 appears.
Equivalently, choose linear splittings of the finite section filtrations
and trivialize the finitely many evaluation fibres. There is then an
injective linear map from the diagonal evaluation image into a product of
piece spaces, each of which embeds into e_j times the same integer-sized
evaluation array. Its size is
(floor(M_p)+1) product_i(floor(M_p/d_i)+1).
`evaluated_filtration_dimension_bound`, `flag_count_bound`, and
`rank_from_evaluations` formalize the resulting dimension and count
inequalities. They derive a rank bound from injections, rather than taking
the numerical rank bound as an axiom.

Because product d_i=Lambda^n h^(n-1), the leading coefficient of P is
a^n/(product d_i)=7^n h=A. For p>=1, all lower-degree coefficients
are nonnegative and p^(k-n)<=1/p for k<n. Consequently

    P(p)/p^n <= A+E/p.                                  (13)

This can also be proved without expanding a degree-n polynomial.
For nonnegative a_i,b_i and 0<=t<=1, induction gives

    product(a_i+b_i t)
      <= product a_i + t(product(a_i+b_i)-product a_i).

In the induction step the new slack is the old slack multiplied by
(a+b t), plus b(B-A)t(1-t), both nonnegative. Main.lean and
`exact_certificate.json` verify this identity and the induction for
arbitrary finite index sets. Apply it at t=1/p to the factors

    (a, C_0+1),       (a/d_i, 1+C_0/d_i).

They are exactly the factors of P(p)/p^n; their t=0 product is A and
their t=1 product is P(1). Thus this formalized algebra supplies (13),
not an assumed O(1/p).

Equations (12)-(13) prove the precise all-good-prime bound

    rank_diagonal/R <= A+E/p < 1/4                      (14)

whenever p>=P_*. Both the fixed-flag evaluation argument and Langer's
hypotheses are indispensable geometric inputs to (14); a compiler run
for a scalar inequality alone would not prove it.

### 6. Determinant normalization and the column-independent error

Choose any R generically independent columns of (1). Their determinant
is a nonzero section of an actual external-product line Q_1 box Q_2.
If m_i is the sum of the slot-i weights of the selected columns, then

    Q_i=(det E_p)^s tensor O_(W')(m_i S'),
    lambda_i=m_i/R in [0,q],       lambda_1+lambda_2=q.

Formula (5) gives the exact normalized class

    c_1(Q_i)/R = D+K_W/2+lambda_i S
                  +(T_0-vD-K_W/2)/p.                  (15)

The error numerator has only k_0 possible values. The affine
movable-curve inequality, tested at its endpoints, and the definition
of C_gamma yield

    pi^*c_1(Q_i).gamma/(R j_gamma)
           <= 40 epsilon+C_gamma/p.                   (16)

For any nonzero section tau of Q_i, the strict transform of its zero
divisor on the point blowup is effective. Intersecting with gamma gives

    0 <= pi^*c_1(Q_i).gamma - ord_(x')(tau) j_gamma.

Thus every such tau satisfies ord(tau)/R<=40 epsilon+C_gamma/p.
This bound is uniform over all columns and all sections, and applies to
sections existing only on a reduction. No lifting of tau is asserted.

### 7. Both orders concern the very same nonzero determinant

Over the algebraically closed residue field, Kunneth identifies
H^0(Q_1 box Q_2) with H^0(Q_1) tensor H^0(Q_2). Filter each finite
section space by order at x' and choose a basis adapted to that filtration.
The filtration terminates: a section with zero germ on an integral
variety is zero, and Krull intersection rules out infinite order for
a nonzero germ. In each degree the leading forms of these basis elements
are independent.

The completed local ring of W' x W' at (x',x') has two disjoint sets
of n regular parameters. Its associated graded splits by the two degrees.
In each bidegree, tensor products of the independent leading forms remain
independent. Consequently a nonzero tensor has order equal to the minimum
sum of factor orders among its nonzero adapted-basis coefficients.
In particular (16) gives, for the chosen sigma,

    ord_(x',x')(sigma)/R <= 80 epsilon+2 C_gamma/p.        (17)

For the lower bound evaluate the chosen square matrix at (x',x').
Its rank t is bounded by (14). Invertible constant row operations over
the residue field make R-t rows zero at that point. All entries in those
rows belong to the maximal ideal m of the product local ring. Every
Leibniz term therefore belongs to m^(R-t). Constant row operations
multiply the determinant by a nonzero scalar, so

    ord_(x',x')(sigma) >= R-t > 3R/4.                    (18)

Main.lean proves the determinant ideal-power assertion over every
commutative ring, without a characteristic or reducedness assumption.
Smoothness identifies maximal-ideal order with the displayed vanishing
order. By the definition of P_*, (17) is strictly <3R/4, contradicting
(18). Section 1 supplies arbitrarily large good p. This completes the
ordinary mathematical reconstruction of the entire finite-data
incompatibility, not merely an isolated rank calculation.

## Certification boundary and remaining review

The strongest prior result in the supplied project state was only the
campaign goal: there were no decomposed claims, proof certificates or
verified core sources. Relative to the manuscript, the mathematical
refinement is the explicit finite-data constants C_0, C_gamma,
E=P(1)-7^nH^n and P_*, together with a proof of their uniformity and of
unbounded availability of good reductions. This is an effective
verification theorem candidate, not an assertion of a new abundance
theorem or a verified novelty classification.

The proof uses the standard foundations of smooth projective spreading,
proper relative Quot schemes, Harder-Narasimhan slopes, Serre duality,
finite flat Frobenius in smooth coordinates, and Kunneth for external
line bundles. The nontrivial imported numerical estimate is precisely
Langer's Corollary 2.5. Its published hypotheses were read and matched;
independent citation attribution is still for the Host-invoked Reviewer.
The finite-presentation, geometric-irreducibility and proper-Quot inputs
are recorded separately as external assumptions with their precise
propositions, not folded into the Lean certificate. All four sources have
local excerpts ready for independent attribution; none is marked as
independently checked by its filer.
The local filtration, character calculation, tensor-slope deduction,
flag bound, determinant normalization and two orders have been supplied
above instead of being assumed from companion assertions.

**Machine-checked versus prose:** Lean proves the universal algebra
listed in STATEMENT_FIDELITY.md. Its final contradiction theorem has
explicit geometric-interface hypotheses; the compiler does not construct
the varieties or prove those hypotheses. Sections 1-7, including the
per-piece rank argument and good reductions, are the separate geometric
proof that must be independently read. No axiom in Main.lean asserts
the disputed uniformity or rank bound. A successful compile alone must
not change the full geometric claim to `closed_kernel`.

The Python replay proves five universal sparse-polynomial identities
over QQ and replays bounded monomial/frame calculations and scalar
fixtures. The finite computations are adversarial tests of the formulas,
not proofs for all dimensions or characteristics. The universal finite-set
induction is in Lean and the geometric interpretation is in this report.
The script rejects a changed identity, weakened identity, wrong scalar
error, bad sign, undersized prime, missing experiment, corrupted Jacobian
rank, or a claim that review/geometric formalization has occurred.
It also exhausts the 625 two-by-two polynomial matrices with entries in
{0,1,x,y,1+x}, checking determinant order against rank defect whenever the
determinant is nonzero. A separate GF(3) experiment tests every nonzero
tensor in the product of spans (1+x,1+2x) and (1+y,1+2y).
This intentionally uses **unadapted** displayed bases: their individual
orders are zero, but their spans contain x and y, and the tensor space
contains xy of order two. Thus replacing the manuscript's adapted-basis
argument by the maximum orders of an arbitrary displayed basis would be
false. The manuscript makes no such replacement.

To replay the exact algebra:

```bash
python3 research/frobenius_core/verify.py --self-test
```

For the installed Argus CLI the Lean source is positional (`--source` is
not a supported flag). The statement-faithful invocation is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify --project-root . \
  --claim C9000036-FROB research/frobenius_core/Main.lean \
  --statement-fidelity research/frobenius_core/STATEMENT_FIDELITY.md
```

The tool writes its canonical lowercase fidelity copy, compiler result,
log and archived certificate next to Main.lean, within the owned directory.
The original uppercase fidelity document is the supplied source for it.
No new Lake workspace, manuscript snapshot, manifest, or source modification
is required.

Independent review has not occurred. The complete geometric reconstruction,
statement fidelity, literature attribution, and whether the effective
refinement reaches the publishable/novelty bar remain Reviewer's decisions.
The four family main theorems and their other choke points remain open.

### Observed Engineer replay

The standalone command exited 0: five universal polynomial identities,
73 basis monomials, 78 socle frame tests, all 625 polynomial matrices
(516 with nonzero determinant), all 80 nonzero GF(3) tensors, and both
scalar fixtures passed; all eleven deliberately corrupted certificates
were rejected. These counts
describe finite adversarial tests, not the scope of the universal theorem.
The final official Lean 4.31.0 run exited 0 with `proof_holes=[]`;
its independent axiom-audit command also exited 0. The archived mechanical
record is
`certificates/C9000036-FROB-7aac2d34fd95560e.json`. The ledger derives
`closed_kernel` for **C9000036-FROB only**, and explicitly reports that
statement fidelity has not yet been independently verified.

Earlier compiler failures were ordinary proof-development errors, not
mathematical refutations; their recorded verdicts are inconclusive and
superseded by the successful source version. No source or fidelity edit
has been made after the successful compile.

The final campaign-local structural checks both exited 0 against
`campaigns/9000036`.
The current route captures the final claim versions; preliminary routes
are explicitly retired with their provenance-update reasons.
`citation_check status` deliberately remains nonzero: eight uses of four
distinct propositions still require independent attribution. This is a
review gate, not evidence against those propositions. The Engineer has
not filed supporting literature verdicts under a second identity.
