# Degree-three support and norm audit

**Engineer conclusion.** The September 26 degree-three argument survives this
audit: the proof below establishes its conclusion from the explicitly stated
standard K-theoretic inputs. No counterexample to its lemmas was found. This
is a mathematical verification, not a proof of novelty and not a formal
verification of K-theory. The exact-arithmetic replay succeeds. Independent
Reviewer certification, including independent citation attribution, is still
required. The September 25 degree-five theorem remains unresolved.

## Scope and epistemic boundary

This report audits the September 26, 2026 manuscript, *An integral
degree-three Gersten counterexample*. The September 25 manuscript is inventoried
separately, with manuscript-qualified identifiers; its degree-five theorem is
not an input to, or a conclusion of, this audit.

The target is the full implication from the cyclotomic plane model to integral
noninjectivity in degree three. Polynomial computations alone cannot certify
that implication. The replay certificate will distinguish exact algebra,
mathematical arguments, and external K-theoretic inputs. No Lean formalization
or independent Reviewer approval is claimed.

## Literature scope before computation

The staged September 26 proof uses the following precise external assertions:

1. A natural, strongly convergent motivic-to-K spectral sequence for
   characteristic-zero fields, with the mixed integral/coefficient product.
   The manuscript cites Friedlander--Suslin, Theorem 16.2 and Appendix C.2--C.3,
   and Suslin, Lemma 3.4 and Theorem 6.1.
2. Motivic--etale comparison in weights at least the cohomological degree,
   and 5-cohomological dimension two for finite extensions of Q_5.
   The cited locators are Voevodsky, Theorems 6.16--6.17, and Weibel,
   VI.4.1--4.2 and VI.7 before Proposition 7.3.
3. Steinberg's relation in Quillen K_2, Quillen's vanishing of K_2 of finite
   fields, coherent localization and devissage, regular resolution, proper
   pushforward, flat base change, and filtered-colimit continuity.
4. The field K_1 transfer is the norm, and transfer satisfies the projection
   formula for multiplication by an integral class and a coefficient class.

These are proof assumptions pending proposition-level source checks, not
conclusions of an exact-arithmetic program.

An initial web discovery found Feld's arXiv:2608.05005v2 and
<https://hexagonmath.org/2611.00017v1>. The latter's abstract explicitly treats
recent integral Gersten counterexamples as conditional on confirmation.
Neither is used as a proof input. Search summaries and mirrors repeating the
target manuscript do not constitute independent verification or establish
novelty. No failure route has yet been established, and the existing campaign
ledger contains no earlier mathematical result stronger than the initial goal.

The separate source-reading agent found the needed product constructions in
Friedlander--Suslin (published DOI 10.1016/S0012-9593(02)01109-6), and the
product-preserving comparison in Suslin's *Trudy* edition, volume 241,
pages 218--253, Math-Net item tm398. This is not the differently paginated
English journal citation (pages 202--237). For the precise etale target,
Suslin Corollary 7.5 and Theorem 7.6 supply the truncation comparison after
Voevodsky Theorem 6.16 (DOI 10.4007/annals.2011.174.1.11). Voevodsky
Theorem 6.17 alone has etale **motivic hypercohomology** as its target.
These distinctions matter to attribution but do not by themselves refute
the field lemma. The cited primary PDFs and relevant page extracts have
been archived under `literature/motivic/`.

The mixed product in Friedlander--Suslin is a pairing with the integral
spectral sequence; no claim that an arbitrary choice of Bott lift is a
pure Adams eigenvector is needed. The nonzero weight-one image, not its
normalization as a specified root of unity, will suffice. A dimension
count alone would not prove the actual product assertion.

The authoritative August 29, 2013 K-book PDF has also been obtained.
III.1.7.1 and its following paragraph identify finite-field-extension
K_1 transfer with the norm; V.3.3.2 proves the spectrum-level projection
formula by the natural tensor isomorphism. III.6.1 and III.6.1.1 state
the field Steinberg presentation and K_2(F_q)=0. V.3.7 and V.3.7.2
provide proper G-theory functoriality and the Tor-independent base-change
formula. The eventual report must check the hypotheses in the actual
localization, not assume that T is itself an open subscheme of C.

No primary source establishing an all-odd-prime integral extension has
yet been read. A search summary suggested such an extension but cited
the mod-three finite-coefficient paper and the existing manuscripts;
that summary is not evidence of either novelty or prior publication.

The primary text of Feld's arXiv:2608.05005v2 was subsequently opened.
Its abstract distinguishes its finite-coefficient example from the integral
conjecture, and its suggested odd-prime variants have degree p-1 and are
explicitly without proof. It therefore does not establish an integral
degree-three theorem at every odd prime. This is a scoped finding, not an
exhaustive novelty search.

## 1. Definitions and statement actually verified

Let zeta be a primitive fifth root of unity, L=Q_5(zeta),
V=O_L, and pi=1-zeta. Write

    P(X,Y,Z) = (X-Z)^5 - X*Y^4 + Y^5 + zeta*Z^5,
    Xcal = Proj V[X,Y,Z]/(P),       C = Xcal_L,
    F(x,y) = (x-1)^5 - x*y^4 + y^5 + zeta,
    R = V[x,y]/(F),                m = (pi,x,y),
    A = R_m,                      S = A/yA,
    t = x mod y,                  D = Frac(S),
    T = Spec A[1/pi].

The special-fiber point corresponding to m is [0:0:1]. The letter D in
this section is a field, not the Fermat curve D in the September 25 paper.
All valuations of local fields are normalized to give a uniformizer value
one. Write f(E/L)=[k_E:k_L] for the residue degree.

**Verification theorem (D3_MAIN).** The ring A is a two-dimensional
Noetherian regular local domain of mixed characteristic (0,5). There is
an integral c in K_3(A) such that

    c|_Frac(A) = 0,
    rho(c|_T) != 0 in G_3(T; Z/5).

Consequently c is nonzero and is not in 5K_3(A). More precisely,
ord_m(pi)=5 and ord_m(5)=20. No assertion about the order of c, its
rationalization, henselization, completion, or the smallest possible K-degree
is included.

K_i(-;Z/5) means pi_i(K(-) smash M_5), not the quotient K_i(-)/5.
In particular, the coefficient connecting map has target **integral**
K_{i-1}. This distinction is essential below.

## 2. External inputs and their exact scope

The following are used as published mathematical inputs, not as output
of `verify.py`.

| Input | Proposition and source actually read | Hypotheses used here |
|---|---|---|
| P0: regular local rings | Stacks Project, Tags 00NO, 00NP and 00NQ, read November 5, 2026. | A regular local ring has polynomial associated graded and is a domain; quotienting by part of a minimal generating set of its maximal ideal is regular of the predicted dimension. The ambient local ring here has parameters pi,x,y, and F replaces pi in a minimal generating set. |
| P1: motivic filtration and mixed product | Friedlander--Suslin, Theorem 16.2, Proposition 16.1, Theorem 15.5, C.2--C.3; DOI 10.1016/S0012-9593(02)01109-6. Also Weibel VI.4.2 and VI.4.2.1, pp.480--481. | A smooth scheme over a field; take Spec E over E itself. Characteristic zero supplies resolution for the standard motivic-product comparison. The mixed integral/coefficient pairing exists for every modulus; modulus 5 also satisfies the stated coefficient-product restrictions. |
| P2: comparison and products of motivic complexes | Suslin, *Trudy* 241 (2003), pp.218--253, Math-Net tm398: Lemma 3.4, Theorem 6.1, Corollary 7.5, Theorem 7.6. Voevodsky, Theorems 6.16--6.17, DOI 10.4007/annals.2011.174.1.11. Weibel VI.4.1. | The field E is perfect and 5 is invertible in E. Norm-residue holds over every finitely generated extension required by Suslin 7.6. The comparison is valid for all s<=j, not just s=j. |
| P3: local cohomological dimension | Weibel VI.7, p.508, immediately before Proposition 7.3. | E is a finite extension of Q_5. The statement includes the prime 5, not only primes different from the residue characteristic. |
| P4: Steinberg symbols and finite fields | Weibel III.6.1, III.6.1.1, IV.1.7.1, IV.1.10.1 and IV.7.2; also IV.1.13 for the finite-field computation. | Both entries of the symbol are nonzero field elements, and u and 1-u occur. The symbols agree with products in Quillen K_2. K_2(F_q)=0 for every finite field. |
| P5: resolution, localization, devissage | Quillen, *Higher algebraic K-theory I*, DOI 10.1007/BFb0067053, section 7.1 and Proposition 3.2. Weibel V.3.3, V.4.1, V.5.1, V.6.1 and V.6.11. | Noetherian schemes; use K=G only for the regular rings A, S and fields. Localization on C is coherent G-theory and does not require C to be smooth. |
| P6: transfer, proper pushforward and base change | Quillen section 7, paragraph 2.7 and the discussion following (2.8); Weibel III.1.7.1 and following paragraph, V.3.3.2, V.3.7 and V.3.7.2. | Finite field extensions are finite free. C is projective with an ample line bundle. The point immersions are finite, and every restriction used is flat. The finite-immersion base change also follows directly by tensoring modules. |
| P7: continuity | Quillen section 7 Proposition 2.2, especially its K-prime conclusion (2.4), printed pp.124--125; Weibel IV.6.4, p.321. | The stages and limit are Noetherian and separated; transition maps are affine **and flat**. The coefficient version follows from the integral one and exactness of filtered colimits. |

The author-hosted K-book is the August 29, 2013 version:
<https://sites.math.rutgers.edu/~weibel/Kbook/Kbook.pdf>.
Publisher metadata for DOI 10.1090/gsm/145 confirms ISBN 9780821891322;
the precise PDF version is recorded because it has its own pagination.

The original Quillen scan was obtained from
<https://www.maths.ed.ac.uk/~v1ranick/papers/quillen1.pdf>.
Its PDF sheets 21--22 contain the continuity, proper-functoriality and
localization passages; OCR is provided in `literature/quillen-page-21.txt`
and `literature/quillen-page-22.txt`, with the scan authoritative for
formula typography. The scan is `literature/quillen-original-scan.pdf`.
The publisher PDF endpoint initially returned HTML,
not a paper. That failed retrieval is not evidence for or against any
mathematical statement.

The cited Matsumoto and Quillen finite-field statements are checked here
in the K-book's explicit statements, identifications and proof of
III.6.1.1; their original research articles were not separately retrieved.
No inaccessible original article is being represented as a source that
was personally opened.

**No hidden smoothness or coefficient substitution.** P1--P3 are applied
to characteristic-zero **fields**, never to V, A or the special fiber.
P5--P7 are applied in G-theory. An abstract isomorphism of groups of the
right size would not replace P1's mixed-product compatibility. Likewise,
an etale comparison of only Milnor K_2 would not replace P2's truncated
complex comparison.

## 3. Exact algebra of the model (D3_MODEL)

The identity

    Phi_5(1-T) = T^4 - 5T^3 + 10T^2 - 10T + 5

is Eisenstein at 5. Thus pi is a uniformizer of V and k_L=F_5.
More explicitly, its relation gives

    pi^4 = 5*(pi^3 - 2*pi^2 + 2*pi - 1).

The parenthesized expression is a unit. Therefore v_L(5)=4.
This fixes the normalization needed both for regularity and for the norm.

Modulo pi the homogeneous equation becomes

    g(X,Y) = X^5 - X*Y^4 + Y^5.

For any root alpha of s^5-s+1 in an algebraic closure of F_5,
alpha^5=alpha-1, and induction gives alpha^(5^r)=alpha-r.
The Frobenius orbit therefore has length exactly five. The polynomial
has derivative -1 and is irreducible of degree five. Its homogenization
is irreducible: it has no factor Y, and dehomogenizing any other
homogeneous factorization would factor s^5-s+1. It stays irreducible
after adjoining the independent variable Z. A factorization of P over L
could be made primitive over the DVR V; reduction of each primitive
homogeneous factor would retain its positive degree. This contradicts
irreducibility of g. Hence C is an integral projective curve.

The ambient local ring V[x,y]_(pi,x,y) is regular of dimension three,
and

    F = -pi + x^5 - 5*x^4 + 10*x^3 - 10*x^2 + 5*x
             - x*y^4 + y^5

has linear term exactly -pi. Quotienting removes one independent
cotangent direction: A has dimension and embedding dimension two, and
is regular, hence a domain. Since F is monic in x, R is finite free
over V[y]; its nonzero localization A is V-flat. In particular V
embeds in A, and the residue field is F_5. This proves mixed
characteristic (0,5), not just an assertion about a reduced equation.

The equation also shows m_A=(x,y) and initially pi in m_A^2.
Consequently 5 in m_A^8. Every intermediate binomial term 5*x,
10*x^2, -10*x^3, 5*x^4 has order at least nine. Thus

    pi = x^5 - x*y^4 + y^5 modulo m_A^6.

Since gr_m(A)=F_5[xbar,ybar], the displayed degree-five form is nonzero.
It follows that ord_m(pi)=5 and ord_m(5)=20. The special fiber is
singular at m, so neither the smooth-over-V nor the unramified
mixed-characteristic Gersten theorem applies.

Now put f(t)=(t-1)^5+zeta. In increasing coefficient order its
coefficients are

    -pi, 5, -10, 10, -5, 1.

Their pi-valuations, except for the leading coefficient, are
1,4,4,4,4. The polynomial is Eisenstein at pi. The finite integral
V-algebra B=V[t]/(f) is a domain and is local, because
B/pi B=F_5[t]/(t^5) has a unique maximal ideal. Its maximal ideal
is (t), its dimension is one, and it is a DVR. Localizing to form
A/yA changes nothing; hence S=B. Its fraction field D is a
degree-five, totally ramified extension of L with residue degree one.

The norm and the Steinberg inputs are

    N_D/L(t) = (-1)^5*f(0) = pi,
    eta = 1-t,     eta^5 = zeta,     eta+t = 1.

In particular t and eta are nonzero. As an extra independent algebra
check, the script builds the five-by-five multiplication matrix of t
over Z[zeta], computes its determinant by all 120 permutation terms,
and checks (I-t)^5=zeta*I. It gets det(t)=1-zeta and det(I-t)=zeta.
It also verifies that Phi_25(1-t) is Eisenstein at 5 of degree twenty.
These are exact polynomial facts, not p-adic numerical approximations.

The locus Y=0 on the generic affine chart is Spec D. There is no
additional point at Y=Z=0, because P(1,0,0)=1. Thus it gives one
closed point q0 of C.

Finally let q be **any** closed point of C, with field E finite over L.
Its extension to Spec O_E can be seen directly: multiply its three
homogeneous coordinates by a common scalar so that they lie in O_E
and at least one is a unit. The homogeneous equation still holds,
and those coordinates define an O_E-point of Xcal. Equivalently,
this is the valuative criterion for projective properness.
If its closed image is
not m, then Y is nonzero at that image: on the special fiber Y=0
forces X=0. The residue X/Y is a root of s^5-s+1 in k_E. Therefore
F_{5^5} is a subfield of k_E, and

    5 divides [k_E:F_5].

This includes points outside the chart Z!=0, and does not assume that
q is L-rational or that E/L is unramified.

## 4. Both integral lifts, and why support really is integral (D3_INTEGRAL)

The coefficient cofiber sequence gives

    K_2(L;Z/5) -> K_1(L)[5] -> 0.

Choose any beta mapping to [zeta], which has exact order five.
For every finite E/L let beta_E be its restriction. Set
a_D=beta_D*[t]. The coefficient cofiber is a sequence of K(D)-modules,
so its boundary is compatible with multiplication by an integral
class, with at most a suspension sign. Thus, by P4,

    partial_coef(a_D)
      = +/- [zeta]*[t]
      = +/- 5*{eta,1-eta}
      = 0  in K_2(D).

The **integral** boundary [zeta] of beta_D is not zero. Its being
eta^5 only kills its class in D^*/D^{*5}; it does not kill zeta in
D^*. The vanishing just proved is a Steinberg-symbol vanishing,
not that invalid fifth-power inference.

Exactness of the coefficient sequence now gives a lift a_tilde in
K_3(D), not merely an element in a finite-coefficient group. Localization
and devissage for the DVR S give

    K_3(S) -> K_3(D) -> K_2(F_5).

P4 makes the last group zero. Hence a_tilde has a lift b in K_3(S).
For this specific residue field one can also see the vanishing directly
from Matsumoto: 2 generates F_5^* of order four, so K_2(F_5) is generated
by x={2,2}, with 4x=0. The pair (3,3) is a Steinberg pair and 3=2^3,
so 9x=0 as well. Since 9-2*4=1, x=0. The replay checks this field
and exponent arithmetic; Matsumoto's identification is still P4.
Let j:Spec S -> Spec A and set c=j_*b in G_3(A)=K_3(A), using P5.
After inverting y the support is empty, so this **integral** class
is zero. Since y is nonzero in the domain A, it follows that
c|_Frac(A)=0, without any divisibility argument.

On inverting pi, S becomes D. For a finite S-module M the base-change
identity is the canonical isomorphism

    A[1/pi] tensor_A M = D tensor_S M

as A[1/pi]-modules. Therefore finite pushforward commutes with this
restriction, and naturality of the coefficient cofiber gives

    rho(c|_T) = i_*a_D.

No regularity of C, no unproved injectivity statement, and no
identification K_3(-;Z/5)=K_3(-)/5 is used.

## 5. The actual field multiplication (D3_FIELD)

Fix **every finite extension E/L**, not just D. By P1--P3,

    E_2^{a,b} = H^{a-b}(E,Z/5(-b)) => K_{-a-b}(E;Z/5).

Put s=a-b and j=-b. The total degree is 2j-s. A possibly nonzero
term must satisfy

    j >= 0,       0 <= s <= min(j,2).

Here s>j vanishes for a field, and for all s<=j P2 identifies the
group with H^s_et(E,mu_5^{tensor j}); this also proves the finite-
coefficient vanishing for s<0. We do **not** make an analogous
unproved assertion about all negative-degree integral motivic groups.

For r>=2, the spectral differential goes from (s,j) to
(s+2r-1,j+r-1). Its s-displacement is at least three, larger than
the whole nonzero strip. Incoming differentials originate at negative
s. Hence all differentials between possibly nonzero terms vanish.
Strong convergence, rather than a bounded computer search, yields

    K_3(E;Z/5) = H^1_et(E,mu_5^{tensor 2})

as a natural edge isomorphism: (s,j)=(1,2) is the only term of
total degree three. There is no extension ambiguity in this degree.
In degree two the terms are (0,1) and (2,2), so there is a
weight-one quotient K_2(E;Z/5) -> H^0(E,mu_5).

Let alpha_E be the image of beta_E in that quotient. Restrict to
an algebraic closure Ebar. Its positive-degree etale cohomology
vanishes, so K_2(Ebar;Z/5)=H^0(Ebar,mu_5). On the other hand,
Matsumoto's presentation makes K_2(Ebar) 5-divisible: choosing r^5=u
gives {u,v}=5{r,v}, and symbols generate. The coefficient sequence
therefore identifies K_2(Ebar;Z/5) with K_1(Ebar)[5].
The restriction of beta_E is nonzero because its boundary is the
same primitive zeta. Naturality of the filtration now implies
alpha_E != 0. Since E contains mu_5, alpha_E generates its
one-dimensional constant F_5-module.

Integral K_1(E)=E^* has only its weight-one piece
H^1(E,Z(1))=E^*. On the degree-one diagonal all j>=2 have
s=2j-1>j, weight zero contributes H^-1(E,Z(0))=0, and negative
weights vanish. Reduction of this weight-one class is precisely
the Kummer class, by Z(1)=G_m[-1] and the Kummer coefficient
triangle.

The filtered mixed product from P1 satisfies

    F^2 K_2(E;Z/5) * F^1 K_1(E) subset F^3 K_3(E;Z/5) = 0.

Consequently the unknown weight-two component of beta_E cannot
contribute to beta_E*[u]. On the only surviving graded piece the
product is the actual motivic cup product, and P2 identifies it
with

    alpha_E cup Kummer(u).

Multiplication by the nonzero invariant alpha_E identifies the
coefficient modules mu_5 and mu_5^{tensor 2}, and hence induces an
isomorphism on H^1. Thus

    theta_E: E^*/E^{*5} -> K_3(E;Z/5),   [u] -> beta_E*[u]

is an isomorphism. It factors through fifth powers since the target,
identified with that H^1, is killed by five. This proves both
injectivity and surjectivity of the specified map, rather than just
an equality of orders of two abstract groups.

The argument does not require choosing a splitting of K_2's
filtration or identifying alpha_E with a particular normalized
root. If beta is changed without changing its integral boundary,
the difference has zero weight-one image (restrict to Ebar and
use injectivity on H^0). Its product with K_1 is zero by the same
filtration argument. Thus the product map is insensitive to that
choice of lift.

## 6. Transfer is the norm, with residue degree (D3_NORM)

For a finite extension E/L, restriction of scalars and tensor
product have a natural isomorphism

    M tensor_E (E tensor_L N) = M tensor_L N.

P6 turns this into a homotopy between the corresponding spectrum
pairings. Smashing the base-field factor with M_5 preserves that
identity. Since beta_E is restricted from beta and the K_1
transfer is the ordinary determinant norm,

    Tr_E/L(beta_E*[u])
      = beta*Tr_E/L([u])
      = beta*[N_E/L(u)].

There is no sign reversal here; the coefficient factor has even
degree two. Define

    lambda = (v_L mod 5) o theta_L^{-1}.

To check the valuation factor directly, multiplication by a
uniformizer of E on the free O_L-module O_E has cokernel k_E.
Its O_L-length is f(E/L). The valuation of its determinant is
that length. Units have determinant a unit, and multiplicativity
then gives, for positive and negative valuations alike,

    v_L(N_E/L(u)) = f(E/L)*v_E(u).

By the **surjectivity** proved in Section 5 every coefficient
class of E is theta_E(u). It follows that lambda annihilates all
transferred coefficient classes when 5 divides f(E/L).

For D, the total degree is five but f(D/L)=1. Hence

    lambda(Tr_D/L(a_D)) = v_L(pi) mod 5 = 1.

Substituting the total degree would incorrectly give zero. This
potential failure is explicitly tested by the replay; it is not
a failure in the manuscript.

## 7. Continuity, localization, and the nonvanishing conclusion

Let Sigma=R minus m and put U_h=Spec R[1/pi,1/h] for h in Sigma.
The chart U_1 is an open of C. Products hk give common refinements,
and all refinement morphisms are principal localizations, hence
affine and flat. Transitivity of ring localization gives

    colim_h R[1/pi,1/h] = A[1/pi],     T = lim_h U_h.

All stages are Noetherian affine schemes, and so is the limit
A[1/pi]; they are separated. P7 therefore gives integral G-theory
continuity. Alternatively, finite presentations of coherent modules,
morphisms and exact diagrams descend through these flat
localizations, and P7's exact-category version applies directly.
The natural exact sequences

    0 -> G_3(Y)/5 -> G_3(Y;Z/5) -> G_2(Y)[5] -> 0

and exactness of filtered colimits give coefficient continuity as
well. In particular, a class which becomes zero in G_3(T;Z/5)
already becomes zero at some U_h. No claim that T is itself an
open subset of C is needed.

Every closed point q specializing to m lies in every U_h.
Indeed, its extension Spec O_E -> Xcal lies in the chart Z!=0:
the inverse image of that chart is an open containing the closed
point of the local scheme Spec O_E, hence the whole scheme. The
pullback of h has nonzero reduction and is a unit in O_E. In
particular q0 belongs to U_h. The complement C minus U_h is
closed and proper in an integral projective curve, hence is a
finite collection of closed points. By Section 3 each omitted
point q has 5 dividing f(E_q/L).

Now let

    w = (q0)_*(theta_D(t)) in G_3(C;Z/5).

Finite-immersion base change on U_h, and then continuity, give
w|_T=i_*a_D=rho(c|_T). Suppose this were zero. There would be
an h for which w|_U_h=0. Coherent localization and devissage
give

    direct_sum_{q in C minus U_h} K_3(E_q;Z/5)
        -> G_3(C;Z/5) -> G_3(U_h;Z/5).

Smashing the localization fiber sequence with the finite Moore
spectrum preserves exactness. Thus

    w = sum_q q_*a_q

for arbitrary coefficient classes a_q. Apply the proper pushforward
p_* for p:C->Spec L. This exists because C is projective; its
functoriality identifies p_*q_* with field transfer. Section 5
applies to **every** E_q, and Section 6 therefore gives

    lambda(p_*w) = sum_q lambda(Tr_E_q/L(a_q)) = 0.

But q0 has field D, so the same expression equals

    lambda(Tr_D/L(theta_D(t))) = 1.

This contradiction proves rho(c|_T) is nonzero. Section 4 proved
integral generic vanishing before this detection argument, so the
conclusion is an integral kernel element, not merely a coefficient
kernel element or an integral class with divisible generic image.
This completes the proof of D3_MAIN from P0--P7.

## 8. Uniform extension exposed by the verification

The argument also yields the following parameterized theorem; it
is an additional mathematical consequence, **not** a claim that
novelty or publishability has already been independently established.

**Uniform cyclotomic family.** Let p be an odd prime, let d>=1
with p not dividing d, and let H/Q_p be the unramified extension
of degree d. Set L=H(zeta_p), V=O_L, pi=1-zeta_p. At the point
m=[0:0:1] of the special fiber of

    (X-Z)^p - X*Y^(p-1) + Y^p + zeta_p*Z^p = 0

let A_p,d be the local ring. Then A_p,d is a two-dimensional
regular local domain of mixed characteristic (0,p) with

    ord_m(pi)=p,          ord_m(p)=p*(p-1).

There is an integral c_p,d in K_3(A_p,d), generically zero, whose
image in G_3(A_p,d[1/pi];Z/p) is nonzero.

**Proof.** The cyclotomic identity gives v_L(p)=p-1 and residue
field F_(p^d). A root alpha of s^p-s+1 has
alpha^(p^d)=alpha-d. Since p does not divide d, its orbit under
the residue-field Frobenius has length p. Thus the special
homogeneous equation is irreducible over F_(p^d), and a point
away from m has residue degree divisible by p over this field.
The proof of generic integrality in Section 3 applies unchanged.

In the ambient regular local ring the equation has linear term
-pi. All intermediate binomial coefficients are divisible by p.
First pi lies in m_A^2. Then those intermediate terms have
m_A-order at least 2(p-1)+1, which is at least p+1 for p>=3.
The nonzero degree-p initial form is x^p-x*y^(p-1)+y^p.
This proves the two stated exact orders.

The divisor y=0 has equation (t-1)^p+zeta_p, Eisenstein at pi;
its residue field is F_(p^d), its relative degree and ramification
index are p, its residue degree is one, and N(t)=pi because p
is odd. Also eta=1-t satisfies eta^p=zeta_p. Choose beta with
integral coefficient boundary zeta_p. Then

    partial_coef(beta_D*[t]) = +/- p*{eta,1-eta} = 0.

K_2(F_(p^d))=0 supplies the second integral lift.

P1--P3 hold with 5 replaced by p: every field in use is a finite
extension of Q_p containing mu_p and has p-cohomological dimension
two. The same three spectral diagonals, nonvanishing argument for
alpha_E, and actual mixed-product argument prove theta_E is an
isomorphism. Only the canonical mixed product is needed, so no
additional associativity property of a mod-three Moore multiplication
is being assumed when p=3. Projection, valuation, continuity and
coherent localization are independent of p. They yield a detector
value one at q0 and zero at every omitted point. Sections 4--7
therefore prove the claimed integral nonvanishing. QED.

The condition p not dividing d is a genuine boundary of this
argument: if p divides d, the Artin--Schreier polynomial splits
over F_(p^d), and the residue-degree exclusion fails. This says
nothing about whether the resulting regular local ring still has
a Gersten kernel. Similarly p=2 is **excluded**: the displayed
divisor polynomial would be t*(t-2), not Eisenstein. Neither case
is a counterexample to the theorem just stated.

This extension is proved by the parameterized argument, not by
testing a list of primes. The executable certificate is deliberately
restricted to p=5,d=1, the assigned manuscript example. Relative
to the campaign's initial empty mathematical ledger, the new evidence
is the full degree-three proof with source-qualified inputs, the
exact replay, and this parameterized consequence. It is not a
claim that the underlying p=5 conclusion was first discovered here.

## 9. What the replay proves, and what it does not

Run, without network access or third-party Python packages:

    python3 research/degree_three_audit/verify.py

It recomputes and compares the deterministic `exact_certificate.json`.
No floating-point arithmetic, random sampling, p-adic precision
cutoff, or symbolic-library simplification is used. It checks:

- both cyclotomic Eisenstein polynomials, exact expansions and
  coefficient valuations;
- the special fiber and the exact Frobenius orbit; the additional
  root-count tests cover residue degrees 1 through 10;
- the multiplication matrix, its two determinants, the eta^5 and
  eta+t identities, and the norm sign;
- all possible degree-one, degree-two and degree-three spectral
  positions from the stated nonzero strip (not an arbitrary weight
  cutoff), and the differential-displacement inequality;
- the distinction between ramification/total degree and residue
  degree, and both detector values;
- exact agreement of the retained Jacobian request and typed
  resultant with the independent integer-polynomial determinant.

The universal finite-field residue constraint is proved by the
Frobenius identity in Section 3, not by the ten root-count cases.
The spectral-index check assumes the published vanishing and
comparison theorems; it does not implement a motivic complex.
The script does not compute Quillen K-groups, construct the
noncanonical lift b as a finite matrix, prove a spectral sequence
exists, or certify source fidelity. Those obligations are covered
by the mathematical proof and primary-source reading, and remain
subject to independent review.

The bounded Jacobian execution used
`polynomial.multivariate.resultant.compute`, server 0.14.0,
protocol 2025-11-25, mcp-stdio. It returned the polynomial 1-z
in 18 ms, with adapter exit status zero and no structured error.
The inspected contract, exact payload, and unmodified typed output
are the dedicated `jacobian.resultant.*.json` files. No UNKNOWN,
timeout or transport failure is treated as mathematical evidence.

## 10. Both manuscript dependency graphs and open boundaries

The ledger and graph use D3 and D5 prefixes because labels such as
`thm:main` and Bott/localization terminology recur in different
manuscripts. All staged TeX files were read, directly for D3 and
through a bounded source-inventory agent for D5; the source-only
appendix was inventoried but not used as a refutation.

The selected chain is

    D3_MODEL -> D3_INTEGRAL
    D3_FIELD -> D3_NORM
    D3_MODEL -> D3_OPENS
    D3_MODEL + D3_FIELD + D3_NORM + D3_OPENS -> D3_DETECTION
    all of the above -> D3_MAIN.

The separate degree-five inventory comprises:

| Qualified node | Content and source label |
|---|---|
| D5_MOORE | coefficient pairing, `lem:moore-product` |
| D5_BOTT_LOCALIZATION | localization/product compatibility, `lem:bott-localization` |
| D5_BOTT | Bott ranges: even 2r for r>=1 at cd<=3; odd 2r+1 for r>=0 at cd<=2, `lem:bott` |
| D5_UNRAMIFIED | unramified cyclotomic K_2/5, `lem:cyclotomic-unramified` |
| D5_K4 | K_4(Z[zeta_5,1/5])[5]=0, `lem:cyclotomic-k4` |
| D5_INTEGRAL | integral K_5 lift and cyclotomic equivariance, `prop:integral-lift` |
| D5_ORBIT | weighted elliptic/Picard detector 4Q, `lem:orbit` |
| D5_LOCAL_RING | the quartic local ring and its divisor, `lem:local-ring` |
| D5_SPLITTING | four generic points and their specializations, `lem:splitting` |
| D5_SPECIALIZATION | valuation-weighted Picard nonvanishing criterion, `prop:specialization` |
| D5_MAIN | the degree-five integral kernel theorem, `thm:main` |
| D5_TRIANGULAR | source-only block-matrix naturality failure, `lem:triangular-naturality-failure` |

The degree-five definitions, full specialization hypotheses,
dependencies and external source locators are in D5_CTX and the
D5 claims in `MATH_STATE.json`; they are not silently identified
with the degree-three objects. In particular their ring has
equation 5+x^4+y^4 over an unramified degree-eight base, not the
cyclotomic quintic local ring.

Historical citations to Gersten, Sherman, Panin, Gillet--Levine,
Geisser--Levine, Skalit, Druzhinin and Feld are contextual rather
than proof inputs in this verification. This audit does not claim
to have certified all their historical attributions or the
unselected degree-five applications of Brauer reciprocity, point
counts, Bott periodicity or finite generation.

**Delivery boundary.** Graph nodes are not marked proved or
reviewer-confirmed by the Engineer. The source passages have been
obtained and read, but the official citation ledger still reports
the D3 assumptions as awaiting independent attribution. The
Engineer does not file supporting citations under a second name
to bypass that requirement. The uniform extension has not earned
`novelty_status=verified_new` or a publishability judgement.
Thus this is an Engineer handoff of a complete proposed proof,
not termination of the campaign or an independently certified
breakthrough. The Host Reviewer must replay the certificate,
check the proof and source statements, and decide significance
and novelty before any campaign acceptance.
