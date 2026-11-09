# Exact supported shears and transitivity

## Scope and source statements

This investigation concerns the shared exact-transitivity argument, not the
Margulis--Platonov conjecture in its entirety. The target passages are
`lem:chars-pure-shears` and `prop:chars-difference` in the number-field
manuscript dated September 23, 2026, and `char:supported-shears` and
`char:transitivity` in the function-field manuscript dated October 5, 2026.

The original setting is a quadratic **separable** extension L/k and a central
division L-algebra D of odd degree n >= 3, with a unitary involution. A
star-stable maximal subfield E is Galois over L; its involution is denoted by
bar. The distinct parameters t_i are the L-conjugates of d, and their set is
disjoint from the conjugates bar(t_i). In the function-field argument E = LF
with F/k cyclic of odd degree, and the additional restriction d bar(d) not in k
is retained. In particular t_i bar(t_i) != 1, the condition needed for the
separable degree-two slope map in characteristic two.

The group H has simultaneous diagonal phases diag(lambda, mu), lambda and mu
in E^1, and simultaneous boosts [[1, t_i bar(h)], [h, 1]], h in E^1.
Blockwise Zariski density alone is not being treated as membership of H.
The manuscript explicitly inserts a normal-subgroup extraction argument
between density and supported unipotents.

The arithmetic inputs to be distinguished from the algebraic core are:
weak approximation for U; local splitting at nonsplit finite places and
isotropy of the resulting unitary group in dimension at least three;
the number-field unit theorem; and finiteness of the degree-zero divisor
class group over a finite field. The additive-generation lemmas in both
manuscripts require exact globalization after their local-closure arguments.

The inherited Wiki index has no entry matching Margulis--Platonov, exact
supported shears, or this transitivity problem. No inherited result is used.
The staged manuscripts are accessible locally; external proposition-level
retrieval remains to be recorded before reliance on a citation is discharged.

## Mathematical status

No admissible counterexample has yet been established. A split-matrix
experiment, if used, is an algebraic diagnostic and is not a counterexample
under the division-algebra hypotheses. A finite sample will not settle the
universal assertion.

The first Jacobian multiplication request was refused at operation validation:
`matrix.budget_exceeded`, because the admission checker cannot bound
cancellation with a multi-term denominator. This is a tool limitation, not a
mathematical verdict. The original request and structured error are preserved.
A separate polynomial request clears the denominator, without changing the
identity or suppressing its required nonvanishing hypothesis.

## 1. A stronger exact block theorem

**Theorem A (explicit normal-kernel separation).** Let E/F be a separable
quadratic extension of global fields, with conjugation bar. Let m >= 1 and
let t_1,...,t_m be distinct nonzero elements of E such that

    {t_i} intersect {bar(t_i)} = empty.

If char(E)=2, assume also t_i bar(t_i) != 1 for every i. Let H be generated
in the product of m copies of GL_2(E) by the simultaneous diagonal phases
diag(lambda,mu), lambda,mu in E^1, and the simultaneous boosts

    B_h(t) = [[1,t/h],[h,1]],  h in E^1.

Then H contains an actual nonidentity upper elementary matrix supported on
any prescribed single block, and an actual nonidentity lower elementary
matrix supported there.

This statement does not require the t_i to be conjugates, m to be odd, a
division algebra realizing the blocks, or [E:Q] >= 6. The original
manuscripts satisfy its hypotheses. In the function-field manuscript,
E=LF with the two Galois actions commuting, so d bar(d) not in k implies
t_i bar(t_i) != 1. The stronger original restriction is retained in the
application, rather than silently replaced.

The proof below supplies exact words and finite exceptional sets in place of
the manuscript's algebraic-subgroup/density argument. Its congruence units
are powers of a phase, not applications of the number-field unit theorem or
the function-field divisor-class theorem. This is the mathematical
improvement over the strongest relevant prior argument, namely the two
staged proofs. It is not a claim that the resulting theorem is new to the
entire literature: novelty remains for independent assessment.

### 1.1 Triangular words

Write a=t_j, b=bar(t_j). Thus a,b are different and neither is 0 or 1.
For a phase z define

    D_z = (1+ab-2a)z+b-a,
    z' = ((a-b)z+1+ab-2b)/D_z,
    h' = (a-1)(b+z)/((b-1)(az+1)).

These are the manuscript's other-fiber point and slope ratio, in simplified
form. Direct identities give

    z' bar(z') = 1,       h' bar(h') = 1,
    ell(z') = ell(z),     ell(z) = (1+z)^2/((1+az)(z+b)).

Here conjugation exchanges a,b and replaces z by 1/z. Put

    N_z = (ab-2a+1)z-ab+2b-1.

Then

    z'-z = -(z+1)N_z/D_z.

In odd characteristic N_z is nonzero: its coefficients sum to 2(b-a).
In characteristic two N_z=(ab+1)(z+1), nonzero under the stated
restriction. Thus z' != z outside finitely many phases, in every allowed
characteristic. This explicitly checks the inseparable boundary rather
than inferring it from a characteristic-zero computation.

Set

    g_j(t) = (B_{h'}(t) B_{h'z'}(t))^-1 B_1(t) B_z(t).

Its lower-left entry is exactly

    -(t-a)(z+1)^2 N_z / ((t-1)^2(az+1)D_z).                 (1)

For generic z this has its unique zero in t at a. The boosts, their
products and their inverses have the coefficient-conjugation form
[[alpha(t),t bar(beta)(t)],[beta(t),bar(alpha)(t)]], with bar fixing
the formal variable t. Therefore the upper-right entry of g_j(t) is
t times the coefficient-conjugate of (1). Its only zero at nonzero t
is b. All t_l avoid b, and every t_l other than a avoids a.

At z=-1 the rational formulas are regular, z'=-1 and h'=-1.
Both boost products specialize to (1-t)I, so g_j(t)=I there.
Consequently each diagonal entry at each t_l is a nonzero rational
function of z, since its specialization is 1. Excluding its finitely
many zeros, and the already named denominators and branch coincidences,
leaves an upper triangular nondiagonal matrix at j and four nonzero
entries at every other block.

The set E^1 is infinite: for theta not fixed by bar the phases
(theta+v)/(bar(theta)+v), v in F, are distinct. An infinite subset of
a field avoids the finitely many roots of these nonzero univariate
polynomials. No topological limit or dense-group membership is used.
The evaluation at z=-1 only proves that a rational function is not zero.
Replacing a by bar(t_j) gives a lower triangular nondiagonal word at j.

### 1.2 An explicit kernel word

Use the convention [A,B]=ABA^-1B^-1 and let D(x)=diag(x,1).
For g=[[a,b],[c,d]], Delta=ad-bc != 0, direct multiplication gives

    ([[D(x),g],[D(y),g]])_21
      = b c^2 d (x-1)(x-y)(y-1)
        (adxy-adx-ady+bc)/(x^2 y^2 Delta^3).               (2)

This identity is over the localization of an integer polynomial ring.
It is not a numerical experiment, and remains valid in every
characteristic under the displayed nonvanishing hypotheses.

If g is upper triangular, [D(x),g] is the actual unipotent
U((x-1)b/d). Thus the double commutator is the identity. If all four
entries of g are nonzero, put y=x^2 in (2). Apart from x=1,-1, the
only possibly forbidden x are roots of

    ad x^3-ad x^2-ad x+bc.

Its leading coefficient ad is nonzero in every characteristic. At most
five phase values are excluded (at most four in characteristic two).
For every j != i, choose an allowed phase x and put

    k_j = [[D(x),g_j],[D(x^2),g_j]].

This is an actual word of H, is exactly the identity at j, and has
nonzero lower-left entry at i. If boosts and diagonal phases are each
counted as one generator, k_j has word length at most 40: g_j uses
four boosts and the two inner commutators each have length at most 10.
This bound concerns the one-block kernel witness, not the final
supported shear or a bound on additive generation.

Let K_j be the full kernel of H's projection on block j.
It is normal in H and contains k_j. Equation (2), rather than projective
Zariski density, now supplies the noncentral element needed below.

## 2. Phase-ring congruence lemma

**Lemma B.** Put R=Z[E^1], which is also the additive group Z E^1 because
E^1 is multiplicatively closed. For any alpha,beta in E^times and r in E
there are a finitely generated subring T of R with fraction field E,
a nonzero c in T, and an infinite-order unit u of T such that, for I=cT,

    I subset alpha R intersect beta R,
    u=1+st with s,t in I,       (1-u^2)r in I.             (3)

**Proof.** First Frac(R)=E, in all characteristics. If x != bar(x),
the phases

    v=x/bar(x),       w=(x+1)/(bar(x)+1)

satisfy

    bar(x)=(1-w)/(w-v).

The denominators are nonzero: x and x+1 cannot be zero, and w=v would
give x=bar(x). Hence every nonfixed x lies in Frac(R). Choose one
nonfixed theta; a fixed y is (theta+y)-theta, so fixed elements also
lie there.

The torsion subgroup of the multiplicative group of a global field is
finite. In a number field this follows from the degree bound on roots
of unity; in a global function field torsion elements lie in its finite
constant field. Since E^1 is infinite, choose a phase z of infinite
order. In positive characteristic such a z is nonconstant.

Write alpha=A/B and beta=C/D with nonzero A,B,C,D in R and put c=AC.
Then c/alpha=BC and c/beta=AD belong to R. Because E=Frac(R) is a
finitely generated field, choose finitely many elements of R whose
fractions generate E. Enlarge that finite list to include A,B,C,D,
z,z^-1, and a numerator r_0 and nonzero denominator r_1 for r.
Let T be the subring they generate. Then cT is contained in both
alpha R and beta R.

We need the following elementary fact, proved here to avoid an
unrecorded arithmetic theorem: if T is a finitely generated subring
of a global field and 0 != a in T, then T/aT is finite.

In characteristic zero, write T=Z[t_1,...,t_l]. Each generator has
a primitive integer polynomial, whose reduction modulo any prime p
is not the zero polynomial. Thus T/pT is a finite F_p-algebra, or
the zero ring. Successive p-power quotients and the Chinese remainder
theorem give T/nT finite for every nonzero integer n. A polynomial
for a with nonzero integer constant term supplies 0 != n in aT.
Hence T/aT is finite.

In characteristic p, a constant a is a unit. Otherwise the global
field is finite over F_p(a). Each generator t_i has a relation
P_i(a,t_i)=0 with P_i in F_p[A,X]. Remove the largest common power
of A from its coefficients; cancellation is valid because a != 0.
Then P_i(0,X) is nonzero, so every image of t_i modulo aT is
algebraic over F_p. The quotient is finite.

Apply this fact to a=c^2 r_1. The image of z is a unit of the finite
quotient, so some positive power u=z^m is 1 modulo c^2 r_1 T.
It remains an infinite-order unit in T. Take s=c and t=(u-1)/c.
Then t lies in c r_1 T subset I, and

    (1-u^2)r = -(u-1)(1+u)r_0/r_1 lies in c^2 T subset I.

This proves (3). No integral closure, global unit theorem, or
divisor-class finiteness is required. QED.

## 3. Exact extraction in a normal subgroup

**Lemma C.** Suppose H_0 <= GL_2(E) contains U(alpha R) and L(beta R)
with alpha,beta nonzero. Let P be normal in H_0 and contain
p=[[a,b],[c,d]] with c != 0. Then P contains nonidentity upper and
lower elementary matrices.

**Proof.** Set r=a/c and choose I,u,s,t as in Lemma B. All four factors in

    U(s)L(t)U(-s/u)L(-tu)=diag(u,u^-1)                    (4)

belong to H_0: multiplication by a unit of T preserves I. So does
U((1-u^2)r). Put

    h=U((1-u^2)r)diag(u,u^-1),      q=h^-1 p^-1 h p.

Normality puts q in P. Exact multiplication, with no derivative or
projective-representative argument, gives

    q = [[u^-2, (1-u^2)(d-au^2)/(u^2 c)],[0,u^2]].

For 0 != x in I,

    [q,U(x)] = U((u^-4-1)x) in P.                        (5)

Its coefficient is nonzero because u has infinite order. This remains
true in characteristic two: infinite order implies u^4 != 1.
The membership in (5) uses normality and actual elements, not the
Zariski closure of P.

To obtain a lower unipotent, interchange the two coordinate axes.
The already obtained upper unipotent becomes a matrix with nonzero
lower-left entry in the transported normal subgroup. The transported
ambient group contains L(alpha R) and U(beta R), so the argument
applies again with Lemma B and a fresh congruence unit if necessary.
Transporting back gives a nonidentity lower unipotent. The axis
interchange need not itself belong to H_0. QED.

## 4. Intersections of kernels without density

At any block i, the triangular words of Section 1.1 and diagonal phases
give U(alpha) and L(beta) in H_i for some nonzero alpha,beta.
Conjugation by phases and the identities U(x)U(y)=U(x+y) and
U(x)^-1=U(-x) give U(alpha R) and L(beta R).

For j != i, the image of K_j is normal in H_i and contains the projection
of k_j with nonzero lower-left entry. Lemma C gives upper and lower
unipotents in that image.

Inductively suppose N is the intersection of some of these kernels and
its image at i contains U(v), v != 0. Choose a lift n in N of U(v)
and a lift k in the next K_j of L(w), w != 0. Both N and K_j are
normal in H, so

    [n,k] in N intersect K_j.

At block i its lower-left entry is

    ([U(v),L(w)])_21 = v w^2 != 0.                      (6)

The image of N intersect K_j is again normal in H_i, so Lemma C
gives both elementary unipotents in it. This proves the induction.
At the end the lifts are the identity at every other block.
For m=1, the already constructed upper and lower unipotents of H_i
are supported on its only block. Theorem A follows.

This proof never invokes the classification of algebraic subgroups of
PGL_2, algebraic perfectness, or commutators of dense images.

## 5. Exact additive generation over global fields

**Theorem D.** In the original division-algebra unitary setting, over a
number field or a global function field, Z U(k)=D as abstract additive
groups.

The proof below unifies the two arithmetic arguments. The external
arithmetic inputs are separated explicitly in `arithmetic_sources.md`.

Let M=Z U(k). It is a subring. In characteristic zero take A=Z and
K_0=Q. In characteristic p choose a place of k split in L. Field weak
approximation and Hilbert 90 give z in L^1 with a simple pole above it
and a simple zero at its conjugate place. Then t_0=z+z^-1 lies in k
intersect M and has a simple pole. Therefore k/F_p(t_0) is finite
separable. Take A=F_p[t_0] and K_0=F_p(t_0). In either case M is an
A-module and D is finite-dimensional over K_0, with separable center.

Fix a finite prime pi of A, let K be the completion of K_0, and let C
be the additive closure of M in D_K. It is an O_K-module, by continuity
and density of A in O_K. The unitary group has weak approximation:
for theta in L minus k the map

    x -> (x+theta)(x+bar(theta))^-1,       x*=x,

is birational with U, including in characteristic two. Its inverse
is (u-1)^-1(theta-u bar(theta)). The nonempty Cayley open is dense
in each local analytic group, so field weak approximation on the
Hermitian vector space proves the assertion. Consequently C contains
the product of the local unitary groups above pi.

Put W=intersection_{r>=0} pi^r C. This is a closed K-vector subspace:
it is O_K-stable and division by pi preserves it. Local unitary
elements preserve W on the left and right, by approximation by
global unitary elements.

Their K-linear span is all of D_K. Indeed, after a separable scalar
extension to an algebraic closure, each independent pair of matrix
factors is parametrized by (g,g^-t), g in GL_n. Varying a scalar
multiple lambda*g separates the two Laurent weights lambda and
lambda^-1 in every characteristic. Invertible matrices span their
matrix algebra. Varying the independent factors separates the
different pairs. Local points are Zariski dense, as follows also
from the Cayley open, so the same linear-span equality holds over K.
Thus W is a two-sided ideal of the semisimple algebra D_K.

Every simple factor occurs in W. At a nonsplit place v, the local
algebra over L_v is split (the unitary-involution criterion and
local Brauer invariants), and its n-dimensional Hermitian form is
isotropic since n>=3. Its local unitary group is unbounded. Take
an unbounded sequence there and the identity in all other components.
Normalize by pi^{r_j}, r_j -> infinity, into a compact annulus
in the finite-dimensional K-space, and extract a nonzero limit.
For every fixed r the normalized terms eventually lie in pi^r C,
so the limit belongs to W and has support only on that simple factor.
At a split place the pair of reciprocal central scalars
(pi^-r,pi^r), and then its reverse, isolates each of the two factors.
An ideal meeting a simple factor nontrivially contains it. Hence
W=D_K and C=D_K.

This is still only local density. The remaining exact step is essential.
The K_0-span of M is D, since otherwise its extension to K would be
a proper closed subspace containing C. Choose a full A-lattice
Lambda subset M. For x=pi^-j lambda, lambda in Lambda, choose
a in M with a-x in the completed lattice at pi. Choose q in A
clearing all denominators of a away from pi and satisfying
q=1 modulo pi^j; the Chinese remainder theorem allows both.
Then qa-qx belongs to the lattice at every finite prime, hence
to Lambda, while (q-1)x belongs to Lambda. The exact equality

    x = qa - (qa-qx) - (q-1)x

puts x in M. Partial fractions over the PID A now give
K_0 Lambda=D subset M. QED.

The standard external inputs here are field weak approximation,
existence of a split place for a separable quadratic global extension,
and the local splitting/isotropy assertions. They are not certified
by the matrix computation or by Lean. No strong approximation,
global Hasse principle, or Margulis--Platonov theorem is used in
Theorems A or D.

## 6. Exact transitivity and the manuscript application

Let G be generated by independent left U(k)-multiplications and the
boost transformations on D^2. The Skolem--Noether decomposition
D=direct_sum E w_i identifies the original block action with Theorem A.
If c != 0 choose a nonzero block coordinate c_i and a supported
upper shear. Its increment is a nonzero element y in D, independent
of a. Conjugating this shear by (a,c)->(v a,c) gives increment vy.
Products and inverses give every element of

    (Z U(k)) y = D,

using Theorem D and the fact that nonzero y is invertible in D.
Thus for each fixed c != 0 every exact change of a is possible.
The lower argument changes c arbitrarily whenever a != 0.

Every nonzero pair reaches (1,1): when c != 0 first change a to 1,
then c to 1; when c=0, a != 0, first change c to 1 and then a to 1.
This proves actual transitivity, not transitivity of a closure.
Division is used exactly in the nonzero-increment amplification.
No split-matrix diagnostic is offered as a division-algebra example.

For the original F_d, pair-invariance and the invertible Sylvester
construction are the preceding manuscript inputs. Transitivity makes
F_d constant. At e=(d-bar(d))^-1, a=1,c=0, one has
e+e*=0 and ed+d*e*=1, giving m_e=1 and m_ed=bar(d)/d.
Hence the constant is chi(bar(d)/d). If b,bd are in the manuscript's
domain, choose a,c from their defining Hermitian equations; the
Sylvester solution is e=b, and the pair is nonzero by invertibility
of the Sylvester operator. This gives the two displayed difference
identities with their original quantifiers.

This last application does not independently certify the prior
noncommutative pair-invariance identity, nor the later continuity,
recurrence, or structural reductions. The proof graph leaves those
obligations open on both main-theorem paths.

## 7. Certification boundary and result classification

The result is a universal exact structural verification and a strengthened
block theorem, not an admissible counterexample and not a finite exclusion.
The explicit double-commutator route and phase-ring arithmetic replace
substantial portions of the original proof. No false manuscript assertion
has been identified in this selected passage; accordingly no invented
`F_...` refutation claim is filed.

`verify.py` replays universal rational/polynomial identities, the
characteristic-two exceptional factor, and the Jacobian typed output.
`Main.lean` verifies normal-subgroup membership as well as algebraic
identities and exact additive amplification, subject to the statement
fidelity boundary stated separately. Neither executable certifies cited
local arithmetic, the entire handwritten proof, or novelty.

Independent Reviewer replay and assessment of statement fidelity,
arithmetic citations, significance, and novelty remain required.

## 8. Reproduction and current review obligations

From the campaign root, run:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/exact_transitivity/verify.py
```

The script recomputes universal identities, checks the characteristic-two
exception, replays the typed Jacobian result, and checks that the current
Lean source and statement-fidelity text match the compiler record.
It updates `exact_certificate.json` only after every required check passes.
SymPy is the only non-standard Python dependency.

The official Lean 4.31.0 run completed with exit_code=0 and proof_holes=[].
The claim ledger derives `closed_kernel` for **C_ET_FORMAL_CORE**, with
certificate
`research/exact_transitivity/certificates/C_ET_FORMAL_CORE-2ec206e59ea6c18d.json`.
This status is confined to the formalized algebraic core, not the
global arithmetic or either full manuscript. No source or fidelity
document was edited during the successful run.

The same run checked this exact campaign root,
`campaigns/9000018`,
with math_state_exit=0 and proof_graph_exit=0.

Citation status was also exposed rather than suppressed. The canonical
Kosters citation is `unchecked` until an independent reader attributes
the retrieved theorem; `kosters_excerpt.txt` contains its hypotheses.
The other three arithmetic dependencies have source-only citations
(`uncited` in the schema), with precise locations and the retrieval
limits recorded in `arithmetic_sources.md`. Their mathematical
applicability and all statement-fidelity judgements await the Host's
independent Reviewer. An Engineer's supporting opinion is not that
independent judgement.
