# The stable-coordinate obstruction and a uniform family of surface embeddings

## Result and scope

Let \(k\) be a characteristic-zero field and put
\[
 B=k[x,y,z,u]/(xy-z(z+1)),\quad s=y-x(x+u^2),\quad
 I=(x-s^2+u^2,z-sx).
 \tag{1}
\]
The unrestricted assertion under audit is
\[
  E\ne0,\quad E\in\operatorname{LND}_k(B)
  \quad\Longrightarrow\quad I\cap\ker E=\{0\}.
 \tag{2}
\]
The proof below establishes (2), and explains its precise coordinate
implication for the October manuscript's **literal** polynomial
\[
 Q=x_2^2-x_4^2+x_1x_3,\qquad
 f=x_1-2Q\{Q(x_2+x_4)+x_1x_4\}.
 \tag{3}
\]
No restriction to a bounded, triangular, or explicitly parametrized family of
derivations is made. No false manuscript assertion has been established.
Compiler compatibility failures are not mathematical refutations.

There are two independent strengthened statements: a global, denominator-free
principalization over arbitrary commutative rings, and rigidity under arbitrary
lower-auxiliary-degree perturbations. Their precise statements and proofs are
given below. They also give Theorem 3: a uniform invariant-restriction and
nonstabilization theorem for embedded Danielewski-type surfaces, for every
polynomial parameter, including singular and reducible members.
`verify.py` has passed 81 exact checks and generated
`exact_certificate.json`; those computations are not offered as an enumeration
proof of (2). `Main.lean` formalizes the unrestricted obstruction, the literal
coordinate implication, and both strengthened cores. The official Lean 4.31.0
run returned exit 0 with `proof_holes=[]`; all eight printed declarations use
only `propext`, `Classical.choice`, and `Quot.sound`.
The 92-module dependency closure and both campaign-local gates passed.
Theorem 3 is a prose corollary of these ingredients, not an additional Lean
declaration. Independent statement-fidelity, significance, and novelty review
belongs to the Host's Reviewer.

## 1. A universal global principalization certificate

**Theorem 1.** In any commutative ring \(R\) with identity, let
\(a,d,b,c,t\in R\) satisfy \(ac-bd=1\). Set
\[
 s=dc-abt,\quad v=a^2t-d^2,\quad f_0=t-s^2,\quad g_0=bd-sab.
\]
Then \((f_0,g_0)=(v)\). This includes zero divisors, the zero ring, and
every characteristic. No localization, reducedness, or cancellation is needed.

**Proof.** Set
\[
 A=c^2-b^2t,\qquad r=a^2(ac-3bd),\qquad
 q=d^2(3ac-bd)+rt.
 \tag{4}
\]
Expansion, using \(ac-bd=1\), gives
\[
 f_0=Av,\qquad g_0=b^2v,\qquad
 rA+qb^2=(ac-bd)^3=1.
 \tag{5}
\]
Thus \(v=rf_0+qg_0\), proving both ideal inclusions.
For clarity, these are polynomial identities modulo the determinant relation,
not pointwise implications. In the free integer polynomial ring, with
\(\rho=ac-bd-1\), the exact signed residuals are
\[
 f_0-Av=-t\rho(\rho+2),\qquad
 g_0-b^2v=-bd\rho.
 \tag{6}
\]
Equations (4)--(6) prove the assertion after substitution into **any** \(R\).
They are replayed symbolically and proved directly by `ring` and ideal
inclusions in `universal_principalization`. \(\square\)

For the manuscript use
\[
 C=k[a,d,b,c,u]/(ac-bd-1),\quad
 (x,y,z,u)=(ab,dc,db,u),\quad t=ab+u^2.
 \tag{7}
\]
Then \(s\) and \(f_0,g_0\) are exactly the images of (1), and
\(v=a^3b+a^2u^2-d^2\). Hence \(IC=(v)\) globally.
The manuscript gives a localized proof followed by an \(a=0\) argument;
Theorem 1 gives explicit global witnesses and removes the domain hypothesis
from this algebraic step.

## 2. A lower-auxiliary-degree perturbation theorem

Give \(C\) its two actual integer gradings
\[
\begin{array}{c|rrrrr}
 &a&d&b&c&u\\ \hline
 \text{fiber weight}&1&1&-1&-1&0\\
 \text{auxiliary degree}&0&1&-1&0&1.
\end{array}
\tag{8}
\]
The determinant relation has degree zero for both. In particular these are
gradings on the quotient, not formal labels attached to chosen representatives.

**Theorem 2.** Let \(k\) have characteristic zero. For any \(W\in C\)
whose auxiliary components in degrees \(j>1\) vanish, every locally nilpotent
\(k\)-derivation \(D\) of \(C\) that preserves all fiber-weight spaces and
satisfies
\[
 D\bigl(W+a^2u^2-d^2\bigr)=0
 \tag{9}
\]
is zero. Neither auxiliary homogeneity nor fiber homogeneity of \(W\)
is required.

**Proof.** The ring \(C\) is a domain: its defining polynomial is primitive
and linear in \(c\), with coprime coefficients \(a\) and \(bd+1\).
The five homogeneous generators and the finite supports of their images
give a largest nonzero auxiliary degree shift \(m\) of \(D\). Let \(D_m\)
be that component. It is a nonzero derivation, and preserves fiber weights
because the two homogeneous projections commute.

This component is locally nilpotent even if \(m\) is negative. For homogeneous
\(r\) of degree \(e\), the degree-\(e+nm\) component of \(D^n(r)\) is
\(D_m^n(r)\): an occurrence of any smaller shift makes the total smaller.
Eventually \(D^n(r)=0\), so eventually \(D_m^n(r)=0\). Finite homogeneous
decompositions give the assertion for every element.

All components of \(D(W)\) have degree at most \(m+1\). Taking degree \(m+2\)
in (9) therefore gives
\[
 D_m(a^2u^2-d^2)=0.
 \tag{10}
\]
This step works for arbitrary inhomogeneous \(W\); it does not rely on its
having just one lower homogeneous term.

For a locally nilpotent derivation of a characteristic-zero domain the
kernel is factorially closed among nonzero products. Indeed,
\(\exp(TD)(rs)=\exp(TD)(r)\exp(TD)(s)\), and degrees of nonzero polynomials
over a domain add. If \(rs\ne0\) is fixed, both exponential factors are
constant. Apply this first to
\((au-d)(au+d)\), and then to \(au\), in (10). The factors are genuinely
nonzero: the point \((a,d,b,c,u)=(1,0,0,1,1)\) evaluates both to 1.
The same point verifies \(a,u\ne0\). Since 2 is invertible, this yields
\[
 D_m(a)=D_m(d)=D_m(u)=0.
 \tag{11}
\]

Put \(q=cD_m(b)-bD_m(c)\), an element of \(C\), not initially a rational
function. Differentiating \(ac-bd=1\) and using (11) gives
\[
 D_m(b)=aq,\qquad D_m(c)=dq.
 \tag{12}
\]
If \(q=0\), all five generators are killed, contradicting \(D_m\ne0\).
We next show that \(q\) belongs to the polynomial subring \(k[a,d,u]\).

The \(a\)-chart is
\[
 C[a^{-1}]=k[a,a^{-1},d,u][b],\qquad c=(1+bd)/a.
 \tag{13}
\]
It proves algebraic independence of \(a,d,u\) and identifies localization
at the nonzero elements of \(k[a,d,u]\) with \(K[b]\), where
\(K=k(a,d,u)\). This localization retains local nilpotence because
all denominators are invariant by (11). A locally nilpotent \(K\)-derivation
of \(K[b]\) sends \(b\) into \(K\): if its value had degree \(r\ge1\),
its \(n\)-th nonzero iterate on \(b\) would have degree \(1+n(r-1)\);
the leading coefficient cannot vanish in characteristic zero.
Consequently (12) gives \(q\in K\).

The two independent charts (13) and
\[
 C[d^{-1}]=k[a,d,d^{-1},u][c],\qquad b=(ac-1)/d
 \tag{14}
\]
now imply
\[
 C\cap K\subset
 k[a,a^{-1},d,u]\cap k[a,d,d^{-1},u]=k[a,d,u].
 \tag{15}
\]
The absence of \(b\)- or \(c\)-coefficients follows from polynomial
algebraic independence over \(K\). The last intersection follows from
coprimeness of \(a,d\) in the UFD \(k[a,d,u]\): a reduced denominator
dividing powers of both must be a unit. Thus no regularity or
polynomiality of \(q\) has been assumed.

Preservation of fiber weights makes both summands in \(q\) have weight
\(-2\). But the polynomial subring \(k[a,d,u]\) has only nonnegative
fiber weights, since its generator weights are \(1,1,0\).
Thus \(q=0\), the required contradiction. \(\square\)

The manuscript's rigidity proposition is the specialization \(W=a^3b\),
of auxiliary degree \(-1\). A further explicit family covered by the theorem is
\[
 a^3b+a^2u^2-d^2+\lambda a^2u+\mu ad+\nu a^2
 \quad(\lambda,\mu,\nu\in k).
 \tag{16}
\]
The arbitrary-\(W\) theorem is stronger than this three-parameter example.
No claim is made that every perturbation in (16) gives a new stable
noncoordinate polynomial in affine four-space.

## 3. Every base action lifts: the actual hypotheses

The map in (7) is injective. For \(U_0=D(z+1)\), its inverse chart formulas are
\[
 b=x/a,\quad c=(z+1)/a,\quad d=ay/(z+1),
 \qquad C[(z+1)^{-1}]=B[(z+1)^{-1}][a,a^{-1}].
 \tag{17}
\]
For \(U_1=D(z)\) they are
\[
 b=z/d,\quad c=y/d,\quad a=xd/z,\qquad
 C[z^{-1}]=B[z^{-1}][d,d^{-1}].
 \tag{18}
\]
These opens cover because \((z+1)-z=1\). Injectivity already follows from
(17) and the domain property of \(B\). On the overlap
\(d=a\,y/(z+1)\), with unit inverse transition \(x/z\).
Consequently \(\operatorname{Spec}C\) is the complement of the zero section
of an actual line bundle \(\mathcal L\) over \(Y=\operatorname{Spec}B\).

Every line bundle on \(\mathbb A^1\times Y\) is pulled back from its
restriction at zero. Indeed the two base charts are
\[
 B[(z+1)^{-1}]=k[x,t,u,(xt+1)^{-1}],\qquad
 B[z^{-1}]=k[x,t,u,(xt-1)^{-1}],
 \tag{19}
\]
using separate \(t=y/(z+1)\) and \(t=y/z\). Each chart ring and its
polynomial extension is a noetherian UFD, so its line bundles are trivial.
Here is the algebraic fact being used. Embed an invertible module over a
UFD in its fraction field and clear denominators, obtaining a finitely
generated invertible ideal. Divide its generators by their gcd. If the
resulting gcd-one ideal were proper, localize at a maximal ideal containing
it. Its invertibility makes it principal there, with a nonunit generator.
A prime factor of that generator in the localized UFD divides every
original generator globally: denominators outside the maximal ideal cannot
contain that prime. This contradicts gcd one. Thus the original ideal,
and hence the line bundle, is principal.
The transition over the overlap is a unit of a polynomial ring over a
domain, hence independent of the affine-line parameter. Specialization
at zero therefore retains the same transition.

For any additive action \(\alpha\) on \(Y\), this property supplies an
isomorphism \(\eta:\pi^*\mathcal L\longrightarrow\alpha^*\mathcal L\).
Normalize it at zero by a unit of \(B\). The composite lift at parameters
\(S,T\) and the lift at \(S+T\) differ by an automorphism of the same line
bundle over \(\mathbb A^2\times Y\), hence by a unit of \(B[S,T]\).
Since \(B\) is a domain, the unit is constant in \(S,T\), and its value at
\((0,0)\) is 1. This proves the group law, not merely a family of fiber maps.
The lift is fiberwise linear, commutes with scaling, and preserves the
punctured bundle.

In particular every \(E\in\operatorname{LND}_k(B)\) lifts to a locally
nilpotent, fiber-weight-preserving derivation \(\widetilde E\) of \(C\).
The exponential/action dictionary is valid here because \(k\) has
characteristic zero. The lift extends \(E\), and injectivity of \(B\to C\)
ensures that it is nonzero when \(E\ne0\).

If \(0\ne h\in I\cap\ker E\), Theorem 1 gives \(h=vq\) in \(C\), with
both factors nonzero because \(C\) is a domain. Factorial closure gives
\(\widetilde E(v)=0\), contradicting Theorem 2. This proves (2).
The formal library's universal lift uses an equivalent normalized
determinant-frame construction: it proves existence, normalization, group law,
base naturality, and weight compatibility, rather than taking them as interfaces.

### A uniform family of invariant-quotient-dominant surface embeddings

**Theorem 3.** Work over \(\mathbb C\) and let
\(\psi\in\mathbb C[T]\) be arbitrary. In the fixed threefold \(Y=\operatorname{Spec}B\),
put
\[
 t_\psi=u^2+\psi(x),\qquad s_\psi=y-xt_\psi,\qquad
 J_\psi=(t_\psi-s_\psi^2,\ z-s_\psi x).
\]
Then every nonzero \(E\in\operatorname{LND}_{\mathbb C}(B)\) satisfies
\[
 J_\psi\cap\ker E=\{0\}.
\]
Equivalently, restriction \(\ker E\longrightarrow B/J_\psi\) is injective.
Moreover,
\[
 B/J_\psi\simeq
 \mathbb C[X,S,U]/(S^2-U^2-\psi(X))
 \simeq\mathbb C[X,R,V]/(RV-\psi(X)).
\]
No nontrivial additive-group action on \(Y\) preserves this closed subscheme.
There is no smoothness, squarefreeness, nonzero-parameter, or irreducibility
hypothesis on \(\psi\). In particular \(\psi=0\) is included, with its
reducible surface, but the assertion concerns that whole closed subscheme,
not either component separately.

**Proof.** The embedding is given on coordinate rings by
\[
 (x,y,z,u)\longmapsto
 \bigl(X,\ S+X(U^2+\psi(X)),\ XS,\ U\bigr).
\]
Writing \(F=S^2-U^2-\psi(X)\), its substituted quadric relation is
\(-X^2F\), its substituted \(s_\psi\) is \(S\), and its two ideal
generators are \(-F,0\). Conversely \(S\mapsto s_\psi\), \(X\mapsto x\),
\(U\mapsto u\) gives the inverse on the quotient: \(S^2-U^2-\psi(X)\)
maps to the negative first generator, while \(y\) and \(z\) are recovered
from their displayed formulas. These identities prove a quotient-algebra
isomorphism globally; no cancellation or chart restriction is used.
The second isomorphism uses \(R=S-U,\ V=S+U\), with inverse
\(S=(R+V)/2,\ U=(V-R)/2\).

Pull \(t_\psi\) back to \(C\). Theorem 1 gives
\[
 J_\psi C=(v_\psi),\qquad
 v_\psi=a^2\bigl(u^2+\psi(ab)\bigr)-d^2
        =v_{\rm high}+W_\psi,\qquad W_\psi=a^2\psi(ab).
\]
If \(\psi(T)=\sum_{n\geq0}\lambda_nT^n\), then
\(W_\psi=\sum_n\lambda_n a^{n+2}b^n\); its summands have auxiliary
degrees \(-n\leq0\). This verifies Theorem 2's bound uniformly for every
polynomial degree, without enumerating derivations or polynomials.
Given \(0\ne h\in J_\psi\cap\ker E\), the unconditional action lift
produces a nonzero, fiber-weight-preserving LND \(\widetilde E\) on \(C\).
Injectivity of \(B\to C\) keeps \(h\) nonzero. Write \(h=v_\psi q\).
Both factors are nonzero in the domain \(C\); factorial closure gives
\(\widetilde E(v_\psi)=0\), and Theorem 2 forces \(\widetilde E=0\),
a contradiction.

Finally \(g_\psi=z-s_\psi x\) is nonzero: its value at the actual quadric
point \((x,y,z,u)=(0,0,-1,0)\) is \(-1\), for every \(\psi\).
If a nonzero LND preserved \(J_\psi\), the last nonzero iterate of
\(g_\psi\) under that derivation would be a nonzero element of
\(J_\psi\cap\ker E\). This is impossible. The characteristic-zero
action/LND dictionary proves the action formulation. \(\square\)

For \(\psi(T)=T\), this is exactly the manuscript's ideal \(I\).
The improvement is the unrestricted polynomial family, its explicit surface
interpretation, and its nonstabilization conclusion. Dominance here refers
to the morphism to \(\operatorname{Spec}(\ker E)\); no finite-generation
claim about that invariant algebra is needed. The corollary is proved
above in prose from the formalized cores and lift; the Python certificate
does not purport to enumerate this infinite family. Global novelty of this
surface theorem remains for independent review.

## 4. The precise coordinate-to-invariant implication

Write, exactly as in the manuscript,
\[
 P=k[p,s,u,F,J],\quad x=s^2-u^2+pF,\quad
 H=x^2F-(1+2sx)J-pJ^2-u,\quad A=P/(H).
 \tag{20}
\]
Give \((p,s,u,F,J)\) the integer weights \((-1,0,0,1,1)\).
For the literal-coordinate implication in this section, \(k=\mathbb C\).
The quotient filtration is exhaustive and separated: for \(r>0\),
its degree-\((-r)\) part lies in \(p^rA\), whose intersection is zero
in the polynomial domain \(A\), since \(p\) is a nonzero nonunit.
The polynomial presentation of \(A\) is justified in Section 5 below.

The highest relation is \(H_*=H+u\), homogeneous of degree 1. For any
nonzero \(q\in P\), the highest term of \(qH\) is
\(\operatorname{in}(q)H_*\), so the entire initial ideal is \((H_*)\).
After inverting \(p\), use \(y=s+x(x+u^2)\), \(z=sx+pJ\); the exact identity
\[
 xy-z(z+1)=p(H+u)
 \tag{21}
\]
identifies the graded localization with \(B[\tau,\tau^{-1}]\).
The relation is primitive and linear in \(y\), hence irreducible there.
Before localization \(H_*\) is not divisible by \(p\), so it is irreducible
and prime in the UFD \(P\). Thus the associated graded ring is the domain
\[
 G=B[\tau,I/\tau]\subset B[\tau,\tau^{-1}],\qquad \deg\tau=-1,
 \quad\deg B=0.
 \tag{22}
\]
The five assigned generator degrees are attained: none of their classes
is zero in \(P/(H_*)\).
For every \(\ell>0\), its actual homogeneous piece is
\(G_\ell=\tau^{-\ell}I^\ell\). To see this, a generator monomial of degree
\(\ell\) has numerator in \(I^{\ell+r}\subset I^\ell\) for some \(r\ge0\);
the reverse inclusion uses the products of exactly \(\ell\) ideal generators.

Suppose \(A=k[p,q_1,q_2,q_3]\). Some \(q_i\) has positive filtration degree,
since otherwise all of \(A\) would have nonpositive degree, contradicting
\(\deg F=1\). Choose \(q_1\) of positive degree and
\(D=\partial/\partial q_2\). This nonzero LND kills \(p,q_1\).
The finite maximum
\[
 m=\max_{D(t)\ne0}\{\deg D(t)-\operatorname{wt}(t)\}
 \quad(t=p,s,u,F,J)
 \tag{23}
\]
is an attained shift bound on the **whole** quotient filtration, by
representatives and the product rule. It gives a nonzero leading derivation
\(D_0\) of degree \(m\), with
\[
 D_0^r([a]_d)=[D^r(a)]_{d+rm}.
 \tag{24}
\]
Equation (24) proves local nilpotence for arbitrary signs of \(d,m\).
It also shows that \(D_0\) kills \(\tau\) and the nonzero leading form
\(\eta\) of \(q_1\), of some degree \(\ell>0\).

Localize only at the invariant \(\tau\). Homogeneity in (22) gives a
unique derivation \(E:B\to B\) with \(D_0(b)=\tau^{-m}E(b)\).
It is nonzero, since otherwise \(D_0\) would kill the entire Laurent ring;
and \(E^r(b)=\tau^{rm}D_0^r(b)\), so it is locally nilpotent.
Write \(\eta=\tau^{-\ell}h\) with \(0\ne h\in I^\ell\). Then
\(D_0(\eta)=0\) gives \(E(h)=0\), and \(I^\ell\subset I\).
This is the unrestricted coordinate-to-invariant implication, contradicting (2).

## 5. Binding the obstruction to (3), and stabilization

The signed matrix substitution
\[
 M=\begin{pmatrix}F&s-u\\s+u&-p\end{pmatrix},\quad
 e=(x,-J)^{\mathsf t},\quad n=(J,x)^{\mathsf t},\quad
 M'=(1-2ne^{\mathsf t})M
 \tag{25}
\]
preserves \(x=-\det M\), since \(e^{\mathsf t}n=0\).
Its inverse is \(M=(1+2ne^{\mathsf t})M'\); these are polynomial
substitutions, not rational ones. If the new off-diagonal entries are
\(s'-u'\), \(s'+u'\), then \(H=-J-u'\). Eliminate \(u'=-J\) to obtain
\[
 A=k[p',s',F',J],\quad
 x=(s')^2-J^2+p'F',\quad
 p=p'-2x\{x(s'+J)+p'J\}.
 \tag{26}
\]
Thus \((p',s',F',J)=(x_1,x_2,x_3,x_4)\) gives **exactly** (3),
not a merely similar polynomial. Its values at the origin and at
\((1,0,0,0)\) are 0 and 1, so it is a nonzero nonunit.
The symbolic certificate checks (21), (25), their inverses, and this
literal transport; `literal_matches` binds the formal definitions as well.

For completeness, one-stability is not inferred from a polynomial fiber.
In \(P[p^{-1}]=k[p,p^{-1}][x,y,z,u]\), take
\(\Delta=-p\partial_u\), fixing \(p,x,y,z\). It preserves \(P\), since
\[
 \Delta u=-p,\quad \Delta s=2pxu,\quad
 \Delta F=-4sxu-2u,\quad \Delta J=-2x^2u.
 \tag{27}
\]
Its restriction is locally nilpotent, and (21) gives \(\Delta H=p\).
Thus \(\exp(w\Delta)\) fixes \(p\) and sends \(H\) to \(H+pw\).
The exact generator nilpotence orders (including verified nonzero preceding
iterates) are \(1,3,2,5,3\) for
\(p,s,u,F,J\); their verification plus the Leibniz rule proves local
nilpotence on all polynomials, rather than restricting to a finite ansatz.

Put \(x_0=s^2-u^2\) and
\[
 L=x_0^2F-(1+2sx_0)J,\qquad N=(1-2sx_0)F+4s^2J.
 \tag{28}
\]
This matrix has determinant 1, with inverse
\(F=4s^2L+(1+2sx_0)N\),
\(J=-(1-2sx_0)L+x_0^2N\).
Expansion gives \(H=L-u+pQ_0\), with
\(Q_0=2x_0F^2+pF^3-2sFJ-J^2\).
Set \(w'=w+Q_0\) and eliminate \(L=u-pw'\).
This proves \(A[w]=k[p,s,u,N,w']\) with \(p\) fixed, hence one-stability
of the literal \(f\). The noncoordinate conclusion follows from Sections 3--4.

At \(p=0\), (28) gives \(A/(p)=k[s,u,N]\). At \(p=\lambda\ne0\),
(21) gives \(k[x,y,z,u]/(xy-z(z+1)-\lambda u)=k[x,y,z]\).
These fiber arguments are distinct from, and do not replace, the obstruction.

## 6. Boundary and zero-divisor checks

| Boundary | Exact check, without deleting components |
|---|---|
| \(a=0\) | \(bd=-1\), \(g_0=-1\), \(v=-d^2\), and \((-b^2)v=1\). The global ideal witnesses also hold here. |
| \(z=0\) | Use \(U_0\), not \(D(z)\). Its boundary has \(xy=0\); both components and their intersection are retained. |
| \(z=-1\) | Use \(U_1\), not \(D(z+1)\). Again \(xy=0\); neither \(x\) nor \(y\) is assumed invertible. |
| \(p=0\) | The defining equation becomes exactly \(L-u\), and \(N\) remains free; the \(p^{-1}\)-chart is not used. |

The bounded Jacobian operation was inspected before custom polynomial code.
`polynomial.ideal.normal_form.compute`, server 0.14.0, protocol 2025-11-25,
returned `COMPUTED`, `in_ideal=true`, and zero remainder for \(g_0+1\)
modulo \((ac-bd-1,a)\). Its exact typed payload and output are
`jacobian_request.json` and `jacobian_result.json`, with adapter exit 0.
This operation fits that ideal check, not a universal derivation quantifier.
The Python verifier independently replays the reduction.

The September manuscript is recorded separately in the proof graph:
its arbitrary-base lifting lemma, cusp translation and Bezout certificate,
zero-fiber identification, and ambient critical-point obstruction are distinct
obligations. The verifier checks the literal cusp identity, the compatible
linear equations without cancelling either coefficient, the ideal equality
used to eliminate \(W\), the inverse linear parameter, the translation, and
the explicit Bezout identity. At \((h,u,v,w)=(2,0,-1/2,1/2)\), the literal
September polynomial has value \(-1\) and all four partial derivatives zero.
These checks do not substitute the September result for the live October goal.

## 7. Prior results, citations, and novelty limits

The strongest inspected upstream result is not just a comparator:
`OAI/AlgebraicGeometry/StableCoordinate/Principal.lean` assembles an
unrestricted noncoordinate theorem, stabilization, and all fibers. In
particular `Rigidity.lean`, `LiftObstruction.lean`, and
`CoordinateToQuadric.lean` contain implementation proofs on the exact quotients.
Before this campaign those inspected interfaces were **not** a local Lean
certificate. The upstream snapshot requests Lean 4.34.1; the assigned host
toolchain is Lean 4.31.0. The dependency replay stages only the transitive
closure needed by this source, and preserves the upstream Apache license.

The mathematical improvement over the inspected statements is direct:
Theorem 2 allows an arbitrary inhomogeneous lower-degree perturbation, rather
than just the degree-\(-1\) monomial \(a^3b\); Theorem 1 gives explicit
global ideal witnesses over any commutative ring with arbitrary \(t\), rather
than a complex-domain localization argument. The central universal
obstruction and the precise literal coordinate implication are not weakened.
The proof source does not import the final `Principal`, `NonCoordinate`,
or `Rigidity` theorem as a substitute for its new rigidity argument.

A separate bounded primary-source reader obtained the following passages.
They are comparisons, not unproved axioms of the formal result:

* Michel Brion, *On linearization of line bundles*, J. Math. Sci. Univ.
  Tokyo 22 (2015), 113--147, Lemma 2.9, printed p.120:
  "Let \(X\) be a reduced \(G\)-scheme, and \(L\) a line bundle on \(X\).
  Then \(L\) admits a \(G\)-linearization if and only if the line bundles
  \(\alpha^*(L)\) and \(p_2^*(L)\) on \(G\times X\) are isomorphic."
  The ambient convention is an arbitrary field and connected algebraic group.
  [Published primary PDF, pp.116,120--121](https://www.ms.u-tokyo.ac.jp/journal/pdf/jms220104.pdf).
  This is conditional on the pullback isomorphism; (19) discharges that
  condition here. The manuscript does not infer a lift from reducedness alone.
* Sh. Kaliman and L. Makar-Limanov, *AK-invariant of affine domains*,
  author version, Proposition 2.1(3), p.3:
  "Suppose \(a_1,a_2\in A\). Then
  \(a_1a_2\in A^\partial\setminus\{0\}\) implies
  \(a_1,a_2\in A^\partial\). In particular, every unit \(u\in A\)
  belongs to \(A^\partial\)."
  Its opening convention allows reduced affine complex varieties and says
  that irreducibility is imposed beginning with Lemma 2.2. That convention
  should not be silently moved backwards to Proposition 2.1.
  [Primary author PDF, pp.2--3](https://www.math.miami.edu/~kaliman/library/KM-L.miyanishi.pdf).
  Our application is expressly to a characteristic-zero **domain**, with
  no UFD hypothesis, and is proved independently in Section 2 and in the
  reused formal helper. It does not rely on any broader reading of the
  author's ambient convention.

Three targeted searches by that reader did not locate a verified primary
source explicitly stating the two full strengthened statements. This is
**not a global novelty or publishability certification**. Their significance
and novelty, as well as statement fidelity and independent replay, remain
for the Host-invoked Reviewer. A known-result reconstruction, a finite
no-witness search, and mere successful source compilation would not themselves
close the campaign.

## 8. Reproduction and formal evidence boundary

The exact symbolic certificate is replayed with

```text
$WORKSPACE/argus-live-update/.venv/bin/python research/stable_core_certificate/verify.py
```

The compiler dependency build is replayed incrementally with
`replay_formal.py`. An independent rebuild uses
`$WORKSPACE/argus-live-update/.venv/bin/python research/stable_core_certificate/replay_formal.py --rebuild --certify-main`
through the durable runner, since it can exceed two minutes.
No lakefile is added and the prebuilt Mathlib workspace is used.
`formal_build_result.json` records actual module commands and outcomes.
The completed run reports 92 modules and no failed or blocked dependencies.
New compatibility proofs for the older public APIs and
the needed localization/Nagata UFD step are ordinary checked Lean proofs,
not axioms.
The `--certify-main` phase invokes the official compiler recorder and both
campaign-local checkers. It also checks all eight printed axiom lists against
the standard logical foundations and preserves the exact tool outputs in
`lean_verification_result.json` and `formal_gate_result.json`.

The official check uses the installed positional-source CLI:

```text
LEAN_PATH="$PWD/research/stable_core_certificate/formal_build" \
ELAN_TOOLCHAIN=leanprover/lean4:v4.31.0 \
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/stable_core_certificate/Main.lean \
  --project-root . --claim C_STABLE_CORE_VERIFY \
  --artifact-dir research/stable_core_certificate \
  --statement-fidelity research/stable_core_certificate/statement_fidelity.md
```

The `--source` spelling in the mission prose is not an option of the installed
CLI; the positional source above expresses the same requested check.
`#print axioms` is requested for the independent extensions, exclusion,
coordinate link, and literal stable-noncoordinate package. The recorded
outcome is compiler exit 0, `proof_holes=[]`, and no mathematical axioms;
logical foundations `propext`, `Classical.choice`, and `Quot.sound` are
not mathematical hypotheses. The archived certificate is
`certificates/C_STABLE_CORE_VERIFY-1f2393b585c126fe.json`, attached to
version 3 of `C_STABLE_CORE_VERIFY`. Both campaign-local checks returned
exit 0 at certification. The Lean source and its fidelity document remain
unchanged from that run. A compiler verdict is not independent approval
of statement fidelity or a certification of global novelty.
